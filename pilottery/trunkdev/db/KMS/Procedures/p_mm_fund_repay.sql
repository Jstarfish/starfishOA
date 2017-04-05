CREATE OR REPLACE PROCEDURE p_mm_fund_repay
/****************************************************************/
  ------------------- �������г�רԱ����-------------------
  ----�г�רԱ����
  ----add by dzg: 2015-9-28
  ----ҵ�����̣����������������ˮ�������˻�
  ----modify by dzg:2015-10-26 �޸ı�ṹ���´洢�����쳣
  /*************************************************************/
(
 --------------����----------------

 p_amount   IN NUMBER, --��ֵ���
 p_mm_id    IN NUMBER, --�г�������Ա
 p_admin_id IN NUMBER, --��ǰ������Ա
 p_remark   in varchar2, -- ע�͡�ֻ���ڸ�ֵ����ʱʹ��

 ---------���ڲ���---------
 c_flow_code  OUT STRING, --������ˮ
 c_bef_amount OUT NUMBER, --����ǰ���
 c_aft_amount OUT NUMBER, --�������
 c_errorcode  OUT NUMBER, --�������
 c_errormesg  OUT STRING --����ԭ��

 ) IS

  v_count_temp NUMBER := 0; --��ʱ����
  v_flow_code  varchar2(50) := ''; --��ʱ������ˮ
  v_acc_code   varchar2(50) := ''; --�˻����

BEGIN

  /*-----------    ��ʼ������    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- ����У��   -----------------*/
  --���벻��Ϊ��
  IF ((p_mm_id IS NULL) OR (p_mm_id <= 0)) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_mm_fund_repay_1;
    RETURN;
  END IF;

  --�û������ڻ�����Ч
  SELECT count(u.admin_id)
    INTO v_count_temp
    FROM adm_info u
   WHERE u.admin_id = p_mm_id
     And u.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_mm_fund_repay_2;
    RETURN;
  END IF;

  --��ǰ�����˲���Ϊ��
  IF (p_admin_id IS NULL) THEN
    c_errorcode := 3;
    c_errormesg := error_msg.err_p_mm_fund_repay_3;
    RETURN;
  END IF;

  --��������Ч
  v_count_temp := 0;
  SELECT count(u.admin_id)
    INTO v_count_temp
    FROM adm_info u
   WHERE u.admin_id = p_mm_id
     And u.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 4;
    c_errormesg := error_msg.err_p_mm_fund_repay_4;
    RETURN;
  END IF;

  --�����Ч
  IF ((p_amount IS NULL) OR (p_amount = 0)) THEN
    c_errorcode := 5;
    c_errormesg := error_msg.err_p_mm_fund_repay_5;
    RETURN;
  END IF;

  -- ��ȡ��ʼ����Ϣ
  select acc.acc_no, acc.account_balance
    into v_acc_code, c_bef_amount
    from acc_mm_account acc
   where acc.market_admin = p_mm_id;

  --���������Ϣ
  v_flow_code := f_get_fund_mm_cash_repay_seq();

  insert into fund_mm_cash_repay
    (mcr_no, market_admin, repay_amount, repay_time, repay_admin, remark)
  values
    (v_flow_code, p_mm_id, p_amount, sysdate, p_admin_id, p_remark);

  p_mm_fund_change(p_mm_id, eflow_type.fund_return, p_amount, v_flow_code, c_aft_amount);

  c_flow_code  := v_flow_code;
  c_bef_amount := c_bef_amount - p_amount;
  c_aft_amount := c_bef_amount;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END p_mm_fund_repay;
