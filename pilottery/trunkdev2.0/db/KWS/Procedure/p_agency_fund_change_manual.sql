CREATE OR REPLACE procedure p_agency_fund_change_manual
/****************************************************************/
   --站点手工调账
/*************************************************************/
(
  --------------输入----------------
  p_agency                            in char,          -- 销售站
  p_type                              in char,          -- 资金类型
  p_amount                            in char,          -- 调整金额
  p_frozen                            in number,        -- 冻结金额
  p_oper                              in number,        -- 操作人员
  p_reason                            in varchar2,      -- 调账原因

  --------------输入----------------
  c_flow_no                           out varchar2,      -- 主键
  c_error_code                        out number,        -- 账户余额
  c_error_msg                         out varchar2       -- 冻结账户余额

 ) is

  v_acc_no                char(12);                                       -- 账户编码
  v_agency_name           varchar2(4000);                                 -- 销售站名称
  v_balance               number(28);                                     -- 账户余额
  v_frozen_balance        number(28);                                     -- 账户冻结余额
  v_credit_limit          number(28);                                     -- 信用额度
  v_amount                number(28);                                     -- 账户调整金额
  v_frozen                number(28);                                     -- 冻结账户调整金额
  v_ref_no                char(10);                                       -- 调账编号（FT12345678）

begin

  dbtool.set_success(errcode => c_error_code, errmesg => c_error_msg);
  -- 按照类型，处理正负号
  case
     when p_type in (eflow_type.charge, eflow_type.paid, eflow_type.sale_comm, eflow_type.pay_comm, eflow_type.agency_return) then
        v_amount := p_amount;
        v_frozen := 0;

     when p_type in (eflow_type.withdraw, eflow_type.sale, eflow_type.cancel_comm) then
        v_amount := 0 - p_amount;
        v_frozen := 0;

     else
        c_error_code := 1;
        c_error_msg := error_msg.err_p_fund_change_2;
        return;
  end case;

  -- 更新余额
  update acc_agency_account
     set account_balance = account_balance + v_amount,
         frozen_balance = frozen_balance + v_frozen
   where agency_code = p_agency
     and acc_type = eacc_type.main_account
     and acc_status = eacc_status.available
  returning
     acc_no,   credit_limit,   account_balance, frozen_balance
  into
     v_acc_no, v_credit_limit, v_balance,       v_frozen_balance;
  if sql%rowcount = 0 then
    c_error_code := 2;    -- 未发现销售站的账户，或者账户状态不正确
    c_error_msg := error_msg.err_p_fund_change_2;
    return;
  end if;
  
  select agency_name
    into v_agency_name
    from inf_agencys
   where agency_code = p_agency;

  insert into fund_tuning
    (fund_no,                 account_type,                  ao_code,  
     ao_name,                 acc_no,                        change_amount, 
     be_account_balance,      af_account_balance,            oper_time, 
     oper_admin,              tuning_reason)
  values
    (f_get_fund_tuning_seq,   eaccount_type.agency,          p_agency, 
     v_agency_name,           v_acc_no,                      v_amount, 
     v_balance - v_amount,    v_balance,                     sysdate, 
     p_oper,                  p_reason)
  returning
     fund_no
  into
     v_ref_no;

  insert into flow_agency
    (agency_fund_flow,        ref_no,                        flow_type, 
     agency_code,             acc_no,                        change_amount,                 
     be_account_balance,      af_account_balance,            be_frozen_balance,             
     af_frozen_balance,       frozen_amount)
  values
    (f_get_flow_agency_seq,   v_ref_no,                      p_type,    
     p_agency,                v_acc_no,                      p_amount,            
     v_balance - v_amount,    v_balance,                     v_frozen_balance - v_frozen,   
     v_frozen_balance,        p_frozen);

  c_flow_no := v_ref_no;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_error_code := 3;
    c_error_msg := error_msg.ERR_COMMON_1 || SQLERRM;

end;
