CREATE OR REPLACE PROCEDURE p_institutions_topup
/****************************************************************/
   ------------------- �����ڻ�����ֵ-------------------
   ----������ֵ
   ----add by dzg: 2015-9-25
   ----ҵ�����̣����������������ˮ�������˻�
   --- POS:outletCode  amount  admin transPassword���г�����Ա��
   --- OMS ������ͬ
   ----��Ҫ���ó���洢����
   /*************************************************************/
(
 --------------����----------------

 p_org_code IN STRING, --��������
 p_amount   IN NUMBER, --��ֵ���
 p_admin_id IN NUMBER, --������Ա

 ---------���ڲ���---------
 c_flow_code  OUT STRING, --������ˮ
 c_bef_amount OUT NUMBER, --��ֵǰ���
 c_aft_amount OUT NUMBER, --��ֵ����
 c_errorcode  OUT NUMBER, --�������
 c_errormesg  OUT STRING --����ԭ��

 ) IS

   v_count_temp NUMBER := 0; --��ʱ����
   v_org_name   varchar2(500) := ''; --վ������
   v_org_accno  varchar2(50) := ''; --վ���˻����

BEGIN

   /*-----------    ��ʼ������    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   v_count_temp := 0;

   /*----------- ����У��   -----------------*/
   --���벻��Ϊ��
   IF ((p_org_code IS NULL) OR length(p_org_code) <= 0) THEN
      c_errorcode := 1;
      c_errormesg := error_msg.err_p_institutions_topup_1;
      RETURN;
   END IF;

   --�û������ڻ�����Ч
   SELECT count(u.admin_id)
     INTO v_count_temp
     FROM adm_info u
    WHERE u.admin_id = p_admin_id
      And u.admin_status <> eadmin_status.DELETED;

   IF v_count_temp <= 0 THEN
      c_errorcode := 2;
      c_errormesg := error_msg.err_p_institutions_topup_2;
      RETURN;
   END IF;

   --������Ч
   v_count_temp := 0;
   SELECT count(u.org_code)
     INTO v_count_temp
     FROM inf_orgs u
    WHERE u.org_code = p_org_code;

   IF v_count_temp <= 0 THEN
      c_errorcode := 3;
      c_errormesg := error_msg.err_p_institutions_topup_3;
      RETURN;
   END IF;

   --��ʼ��

   select a.org_name, b.acc_no
     INTO v_org_name, v_org_accno
     from inf_orgs a
     left join acc_org_account b
       on a.org_code = b.org_code
    where a.org_code = p_org_code;

   --�����ɱ���
   c_flow_code := f_get_fund_charge_cash_seq();

   --�����ʽ���ˮ�����Ϣ
   p_org_fund_change(p_org_code,
                     eflow_type.charge,
                     p_amount,
                     0,
                     c_flow_code,
                     c_aft_amount,
                     v_count_temp);

   -- ����֮ǰ���
   c_bef_amount := c_aft_amount - p_amount;

   insert into fund_charge_center
      (fund_no,
       account_type,
       ao_code,
       ao_name,
       acc_no,
       OPER_AMOUNT,
       BE_ACCOUNT_BALANCE,
       AF_ACCOUNT_BALANCE,
       OPER_TIME,
       OPER_ADMIN)
   values
      (c_flow_code,
       eaccount_type.org,
       p_org_code,
       v_org_name,
       v_org_accno,
       p_amount,
       c_bef_amount,
       c_aft_amount,
       sysdate,
       p_admin_id);

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      c_errorcode := 1;
      c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
