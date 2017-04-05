create or replace procedure p_mm_fund_change
/****************************************************************/
   ------------------- 市场管理员资金处理（不提交） -------------------
   ---- 按照输入类型，处理市场管理员资金，同时增加相应的资金流水
   ---- add by 陈震: 2015/9/24

   /*************************************************************/
(
   --------------输入----------------
   p_mm                                in number,        -- 市场管理员
   p_type                              in char,          -- 资金类型
   p_amount                            in char,          -- 调整金额
   p_ref_no                            in varchar2,      -- 参考业务编号

   --------------输入----------------
   c_balance                           out number         -- 账户余额

 ) is

   v_acc_no                char(12);                                       -- 账户编码
   v_balance               number(28);                                     -- 账户余额
   v_credit_limit          number(28);                                     -- 信用额度
   v_amount                number(28);                                     -- 账户调整金额

begin
   -- 按照类型，处理正负号
   case
      when p_type in (eflow_type.charge_for_agency) then
         v_amount := 0 - p_amount;

      when p_type in (eflow_type.fund_return, eflow_type.withdraw_for_agency) then
         v_amount := p_amount;

      else
         raise_application_error(-20001, dbtool.format_line(p_type) || error_msg.err_p_fund_change_2);            -- 资金类型不合法

   end case;

   -- 更新余额
   update acc_mm_account
      set account_balance = account_balance + v_amount
    where market_admin = p_mm
      and acc_type = eacc_type.main_account
      and acc_status = eacc_status.available
   returning
      acc_no,   credit_limit,   account_balance
   into
      v_acc_no, v_credit_limit, v_balance;

   if v_credit_limit + v_balance < 0 then
      raise_application_error(-20001, error_msg.err_p_fund_change_1);            -- 账户余额不足
   end if;

   insert into flow_market_manager
      (mm_fund_flow,          ref_no,   flow_type, market_admin, acc_no,   change_amount, be_account_balance,   af_account_balance)
   values
      (f_get_flow_agency_seq, p_ref_no, p_type,    p_mm,         v_acc_no, p_amount,      v_balance - v_amount, v_balance);

   c_balance := v_balance;

end;
