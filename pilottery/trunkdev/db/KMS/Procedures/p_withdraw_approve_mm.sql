CREATE OR REPLACE PROCEDURE p_withdraw_approve_mm
/****************************************************************/
   ------------------- ����վ������------------------
   ---- վ���������ۼ�����Ա�˻�Ƿ��
   ---- add by Chen Zhen: 2015-10-13
   /*************************************************************/
(
 --------------����----------------

 p_fund_no  IN STRING, -- ����������

 ---------���ڲ���---------
 c_errorcode OUT NUMBER, --�������
 c_errormesg OUT STRING --����ԭ��

 ) IS

   v_agency_code varchar2(100); -- ����վ
   v_mm_code     number; -- ����Ա����
   v_wd_money    NUMBER; -- ���ֽ��
   v_count_temp1 NUMBER; -- ��ʱ����
   v_count_temp2 NUMBER; -- ��ʱ����

BEGIN

   /*-----------    ��ʼ������    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- ����У��   -----------------*/

   --������벻��Ϊ��
   IF ((p_fund_no IS NULL) OR length(p_fund_no) <= 0) THEN
      c_errorcode := 1;
      c_errormesg := error_msg.err_p_withdraw_approve_1;
      RETURN;
   END IF;

   --���벻���ڻ���״̬��Ч������������
   begin
      SELECT AO_CODE, APPLY_AMOUNT, MARKET_ADMIN
        INTO v_agency_code, v_wd_money, v_mm_code
        FROM fund_withdraw
       WHERE fund_no = p_fund_no
         And apply_status = eapply_status.applyed;
   exception
      when no_data_found then
         c_errorcode := 2;
         c_errormesg := error_msg.err_p_withdraw_approve_2;
         RETURN;

   end;

   -- �ۼ�����վ���
   p_agency_fund_change(v_agency_code,
                        eflow_type.withdraw,
                        v_wd_money,
                        0,
                        p_fund_no,
                        v_count_temp1,
                        v_count_temp2);

   -- �������Ƿ��㹻
   IF v_count_temp1 < 0 THEN

      update fund_withdraw
         set apply_check_time = sysdate,
             check_admin_id   = v_mm_code,
             apply_status     = eapply_status.resused,
             apply_memo       = 'Sorry, agency[' || v_agency_code || '] balance has been insufficient. [AUTO Apply]'
       where fund_no = p_fund_no;

      c_errorcode := 4;
      c_errormesg := error_msg.err_p_withdraw_approve_4;

      rollback;
      RETURN;
   END IF;

   --��������״̬
   update fund_withdraw
      set apply_check_time = sysdate,
          check_admin_id   = v_mm_code,
          apply_status     = eapply_status.withdraw,
          apply_memo       = '[AUTO Apply]'
    where fund_no = p_fund_no;

   -- �����г�����Ա�˻�Ƿ����
   p_mm_fund_change(v_mm_code, eflow_type.withdraw_for_agency, v_wd_money, p_fund_no, v_count_temp1);

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      c_errorcode := 1;
      c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
