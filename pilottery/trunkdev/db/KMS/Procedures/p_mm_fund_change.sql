create or replace procedure p_mm_fund_change
/****************************************************************/
   ------------------- �г�����Ա�ʽ������ύ�� -------------------
   ---- �����������ͣ������г�����Ա�ʽ�ͬʱ������Ӧ���ʽ���ˮ
   ---- add by ����: 2015/9/24

   /*************************************************************/
(
   --------------����----------------
   p_mm                                in number,        -- �г�����Ա
   p_type                              in char,          -- �ʽ�����
   p_amount                            in char,          -- �������
   p_ref_no                            in varchar2,      -- �ο�ҵ����

   --------------����----------------
   c_balance                           out number         -- �˻����

 ) is

   v_acc_no                char(12);                                       -- �˻�����
   v_balance               number(28);                                     -- �˻����
   v_credit_limit          number(28);                                     -- ���ö��
   v_amount                number(28);                                     -- �˻��������

begin
   -- �������ͣ�����������
   case
      when p_type in (eflow_type.charge_for_agency) then
         v_amount := 0 - p_amount;

      when p_type in (eflow_type.fund_return, eflow_type.withdraw_for_agency) then
         v_amount := p_amount;

      else
         raise_application_error(-20001, dbtool.format_line(p_type) || error_msg.err_p_fund_change_2);            -- �ʽ����Ͳ��Ϸ�

   end case;

   -- �������
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
      raise_application_error(-20001, error_msg.err_p_fund_change_1);            -- �˻�����
   end if;

   insert into flow_market_manager
      (mm_fund_flow,          ref_no,   flow_type, market_admin, acc_no,   change_amount, be_account_balance,   af_account_balance)
   values
      (f_get_flow_agency_seq, p_ref_no, p_type,    p_mm,         v_acc_no, p_amount,      v_balance - v_amount, v_balance);

   c_balance := v_balance;

end;
