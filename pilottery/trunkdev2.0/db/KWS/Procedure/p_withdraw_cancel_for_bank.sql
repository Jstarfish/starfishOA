create or replace procedure p_withdraw_cancel_for_bank
/****************************************************************/
  ------------------- 银行提现退款------------------
  ---- 提现申请
  ---- add by dzg: 2017-03-31
  ---- 步骤如下：
  ---- 1、更新日志表状态
  ---- 2、更细余额
  ---- 3、插入退款流水
  /*************************************************************/
(
 --------------输入----------------
 
 p_fund_d_no     in string, --资金编号-交易日志编号
 p_failurereason in string, --失败原因
 p_reponseinfo   in string, --返回的json
 ---------出口参数---------
 c_errorcode out number, --错误编码
 c_errormesg out string --错误原因
 
 ) is

  v_count_temp number := 0; -- 临时变量
  v_fund_no    varchar2(100) := ''; -- 参考流水
  v_wd_money   number := 0; -- 提现金额

  v_org_code     varchar2(10); -- 机构编码
  v_acc_no       char(12);      -- 账户编码
  v_credit_limit number(28); -- 信用额度
  v_balance      number(28); -- 账户余额

begin

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/

  -- 申请编码不能为空
  if ((p_fund_d_no is null) or length(p_fund_d_no) <= 0) then
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_withdraw_approve_1;
    return;
  end if;

  -- 编码不存在或者状态无效（如已审批）
  select count(d.digital_trans_no)
    into v_count_temp
    from fund_digital_translog d
   where d.digital_trans_no = p_fund_d_no
     and d.digital_trans_status <> edigital_trans_status.fail;

  if v_count_temp <= 0 then
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_withdraw_approve_2;
    return;
  end if;

  --初始化
  select w.ref_no, w.apply_amount, w.agency_code, w.acc_no
    into v_fund_no, v_wd_money, v_org_code, v_acc_no
    from fund_digital_translog w
   where w.digital_trans_no = p_fund_d_no;

  if ((v_fund_no is null) or length(v_fund_no) <= 0) then
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_withdraw_approve_1;
    return;
  end if;

  --更新状态
  update fund_withdraw
     set apply_check_time = sysdate,
         apply_status     = eapply_status.canceled,
         apply_memo       = 'the transaction of wing is failure.'
   where fund_no = v_fund_no;
   
   update fund_digital_translog 
   set digital_trans_status=edigital_trans_status.fail,
       res_time=sysdate,
       RES_JSON_DATA=p_reponseinfo,
       FAIL_REASON=p_failurereason
   where  digital_trans_no =p_fund_d_no;

  --更新各种账户流水

  update acc_agency_account
     set account_balance = account_balance + v_wd_money
   where agency_code = v_org_code
     and acc_type = eacc_type.main_account
     and acc_status = eacc_status.available
  returning acc_no, credit_limit, account_balance into v_acc_no, v_credit_limit, v_balance;
  if sql%rowcount = 0 then
    raise_application_error(-20001,
                            dbtool.format_line(v_org_code) ||
                            error_msg.err_p_fund_change_3); -- 未发现销售站的账户，或者账户状态不正确
  end if;

  insert into flow_agency
    (agency_fund_flow,
     ref_no,
     flow_type,
     agency_code,
     acc_no,
     change_amount,
     be_account_balance,
     af_account_balance,
     be_frozen_balance,
     af_frozen_balance,
     frozen_amount)
  values
    (f_get_flow_agency_seq,
     v_fund_no,
     eflow_type.fund_return,
     v_org_code,
     v_acc_no,
     v_wd_money,
     v_balance - v_wd_money,
     v_balance,
     0,
     0,
     0);

  commit;

exception
  when others then
    rollback;
    c_errorcode := 1;
    c_errormesg := error_msg.err_common_1 || sqlerrm;
  
end;
