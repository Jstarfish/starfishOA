CREATE OR REPLACE procedure KWS.p_agency_fund_change_manual
/****************************************************************/
   --վ���ֹ�����

   /*************************************************************/
(
   --------------����----------------
   p_agency                            in char,          -- ����վ
   p_type                              in char,          -- �ʽ�����
   p_amount                            in char,          -- �������
   p_frozen                            in number,        -- ������
   p_ref_no                            in varchar2,      -- �ο�ҵ����

   --------------����----------------
   c_error_code                        out number,        -- �˻����
   c_error_msg                         out varchar2         -- �����˻����

 ) is

   v_acc_no                char(12);                                       -- �˻�����
   v_balance               number(28);                                     -- �˻����
   v_frozen_balance        number(28);                                     -- �˻��������
   v_credit_limit          number(28);                                     -- ���ö��
   v_amount                number(28);                                     -- �˻��������
   v_frozen                number(28);                                     -- �����˻��������

begin

    dbtool.set_success(errcode => c_error_code, errmesg => c_error_msg);
   -- �������ͣ�����������
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

   -- �������
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
         c_error_code := 2;    -- δ��������վ���˻��������˻�״̬����ȷ
         c_error_msg := error_msg.err_p_fund_change_2;
         return;          
   end if;

   insert into flow_agency
      (agency_fund_flow,      ref_no,   flow_type, agency_code, acc_no,   change_amount, be_account_balance,   af_account_balance, be_frozen_balance,           af_frozen_balance, frozen_amount)
   values
      (f_get_flow_agency_seq, p_ref_no, p_type,    p_agency,    v_acc_no, p_amount,      v_balance - v_amount, v_balance,          v_frozen_balance - v_frozen, v_frozen_balance,  p_frozen);

   COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_error_code := 3;
    c_error_msg := error_msg.ERR_COMMON_1 || SQLERRM;

end;
/
