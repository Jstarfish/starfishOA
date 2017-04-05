create or replace procedure p_org_fund_change
/****************************************************************/
   ------------------- 机构资金处理（不提交） -------------------
   ---- 按照输入类型，处理机构资金，同时增加相应的资金流水
   ---- add by 陈震: 2015/9/24

   /*************************************************************/
(
   --------------输入----------------
   p_org                               in char,           -- 机构
   p_type                              in char,           -- 资金类型
   p_amount                            in char,           -- 调整金额
   p_frozen                            in number,         -- 冻结金额
   p_ref_no                            in varchar2,       -- 参考业务编号

   --------------输入----------------
   c_balance                           out number,        -- 账户余额
   c_f_balance                         out number         -- 冻结账户余额

 ) is

   v_acc_no                char(12);                      -- 账户编码
   v_balance               number(28);                    -- 账户余额
   v_frozen_balance        number(28);                    -- 账户冻结余额
   v_credit_limit          number(28);                    -- 信用额度
   v_amount                number(28);                    -- 账户调整金额
   v_frozen                number(28);                    -- 冻结账户调整金额

begin
   -- 按照类型，处理正负号
   case
      when p_type in (eflow_type.charge, eflow_type.org_comm, eflow_type.org_return, eflow_type.org_agency_pay_comm, eflow_type.org_agency_pay, eflow_type.org_center_pay_comm, eflow_type.org_center_pay,eflow_type.org_center_pay) then
         v_amount := p_amount;
         v_frozen := 0;

      when p_type in (eflow_type.withdraw, eflow_type.carry, eflow_type.org_comm_org_return) then
         v_amount := 0 - p_amount;
         v_frozen := 0;

      else
         raise_application_error(-20001, dbtool.format_line(p_type) || error_msg.err_p_fund_change_2);            -- 资金类型不合法

   end case;

   -- 更新余额
   update ACC_ORG_ACCOUNT
      set account_balance = account_balance + v_amount,
          frozen_balance = frozen_balance + v_frozen
    where ORG_CODE = p_org
      and acc_type = eacc_type.main_account
      and acc_status = eacc_status.available
   returning
      acc_no,   credit_limit,   account_balance, frozen_balance
   into
      v_acc_no, v_credit_limit, v_balance,       v_frozen_balance;

   if v_credit_limit + v_balance < 0 then
      raise_application_error(-20001, dbtool.format_line(p_org) || error_msg.err_p_fund_change_1);            -- 账户余额不足
   end if;

   insert into flow_org
      (org_fund_flow,      ref_no,   flow_type, acc_no,   org_code, change_amount, be_account_balance,   af_account_balance, be_frozen_balance,           af_frozen_balance, frozen_amount)
   values
      (f_get_flow_org_seq, p_ref_no, p_type,    v_acc_no, p_org,    p_amount,      v_balance - v_amount, v_balance,          v_frozen_balance - v_frozen, v_frozen_balance,  p_frozen);

   c_balance := v_balance;
   c_f_balance := v_frozen_balance;
end;
