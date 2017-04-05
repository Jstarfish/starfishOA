create or replace procedure p_agency_fund_change
/****************************************************************/
   ------------------- 销售站资金处理（不提交） -------------------
   ---- 按照输入类型，处理销售站资金，同时增加相应的资金流水
   ---- add by 陈震: 2015/9/24

   /*************************************************************/
(
   --------------输入----------------
   p_agency                            in char,          -- 销售站
   p_type                              in char,          -- 资金类型
   p_amount                            in char,          -- 调整金额
   p_frozen                            in number,        -- 冻结金额
   p_ref_no                            in varchar2,      -- 参考业务编号

   --------------输入----------------
   c_balance                           out number,        -- 账户余额
   c_f_balance                         out number         -- 冻结账户余额

 ) is

   v_acc_no                char(12);                                       -- 账户编码
   v_balance               number(28);                                     -- 账户余额
   v_frozen_balance        number(28);                                     -- 账户冻结余额
   v_credit_limit          number(28);                                     -- 信用额度
   v_amount                number(28);                                     -- 账户调整金额
   v_frozen                number(28);                                     -- 冻结账户调整金额

begin
   -- 按照类型，处理正负号
   case
      when p_type in (eflow_type.charge, eflow_type.paid, eflow_type.sale_comm,
                      eflow_type.pay_comm, eflow_type.agency_return,
                      eflow_type.lottery_sale_comm, eflow_type.lottery_pay_comm,
                      eflow_type.lottery_pay, eflow_type.lottery_cancel,
                      eflow_type.lottery_fail_sale, eflow_type.lottery_fail_cancel_comm) then
         v_amount := p_amount;
         v_frozen := 0;

      when p_type in (eflow_type.withdraw, eflow_type.sale, eflow_type.cancel_comm,
                      eflow_type.lottery_sale, eflow_type.lottery_cancel_comm,
                      eflow_type.lottery_fail_sale_comm, eflow_type.lottery_fail_pay_comm,
                      eflow_type.lottery_fail_pay, eflow_type.lottery_fail_cancel) then
         v_amount := 0 - p_amount;
         v_frozen := 0;

      else
         raise_application_error(-20001, dbtool.format_line(p_type) || error_msg.err_p_fund_change_2);            -- 资金类型不合法

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
      raise_application_error(-20001, dbtool.format_line(p_agency) || error_msg.err_p_fund_change_3);            -- 未发现销售站的账户，或者账户状态不正确
   end if;

   -- 失败的各种操作，都不检查余额
   if p_type not in (eflow_type.lottery_fail_sale_comm, eflow_type.lottery_fail_pay_comm, eflow_type.lottery_fail_sale, eflow_type.lottery_fail_pay, eflow_type.lottery_fail_cancel, eflow_type.lottery_fail_cancel_comm) then
      if v_credit_limit + v_balance < 0 then
         raise_application_error(-20001, error_msg.err_p_fund_change_1);            -- 账户余额不足
      end if;
   end if;

   insert into flow_agency
      (agency_fund_flow,      ref_no,   flow_type, agency_code, acc_no,   change_amount, be_account_balance,   af_account_balance, be_frozen_balance,           af_frozen_balance, frozen_amount)
   values
      (f_get_flow_agency_seq, p_ref_no, p_type,    p_agency,    v_acc_no, p_amount,      v_balance - v_amount, v_balance,          v_frozen_balance - v_frozen, v_frozen_balance,  p_frozen);

   c_balance := v_balance;
   c_f_balance := v_frozen_balance;
end;
