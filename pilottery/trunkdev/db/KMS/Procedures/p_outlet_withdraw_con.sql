CREATE OR REPLACE PROCEDURE p_outlet_withdraw_con
/****************************************************************/
  ------------------- ������վ������ȷ��-------------------
  ----վ������ȷ��
  ----add by dzg: 2015-9-24
  --- POS:outletCode  amount  admin ���г�����Ա��
  --- OMS ��֤һЩ����������״̬
  --- ״ֵ̬ �޶����һ��ö��������ȷ��
  /*************************************************************/
(
 --------------����----------------

 p_outlet_code      IN STRING, --վ�����
 p_password         IN STRING, --վ������
 p_app_flow         IN STRING, --���뵥���
 p_admin_id         IN NUMBER, --�г�������Ա


 ---------���ڲ���---------
 c_errorcode   OUT NUMBER,     --�������
 c_errormesg   OUT STRING      --����ԭ��

 ) IS

  v_count_temp     NUMBER := 0; --��ʱ����
  v_outlet_name    varchar2(500) := ''; --վ������
  v_outlet_accno   varchar2(50) := ''; --վ���˻����

BEGIN

  /*-----------    ��ʼ������    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp  := 0;

  /*----------- ����У��   -----------------*/
  --���벻��Ϊ��
  IF ((p_outlet_code IS NULL) OR length(p_outlet_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_OUTLET_TOPUP_1;
    RETURN;
  END IF;

   --���벻��Ϊ��
  IF ((p_app_flow IS NULL) OR length(p_app_flow) <= 0) THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_outlet_withdraw_con_1;
    RETURN;
  END IF;

  --�û������ڻ�����Ч
  SELECT count(u.admin_id)
    INTO v_count_temp
    FROM adm_info u
   WHERE u.admin_id = p_admin_id
     And u.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 3;
    c_errormesg := error_msg.ERR_P_OUTLET_TOPUP_2;
    RETURN;
  END IF;


  --������뵥���
  v_count_temp := 0;
  SELECT count(u.fund_no)
    INTO v_count_temp
    FROM fund_withdraw u
   WHERE u.fund_no=p_app_flow
   And u.apply_status = eapply_status.audited ;

  IF v_count_temp <= 0 THEN
    c_errorcode := 4;
    c_errormesg := error_msg.err_p_outlet_withdraw_con_2;
    RETURN;
  END IF;

  --���վ�������
  v_count_temp := 0;
  SELECT count(*)
    INTO v_count_temp
    FROM inf_agencys u
   WHERE u.agency_code=p_outlet_code
   And u.login_pass = p_password ;

  IF v_count_temp <= 0 THEN
    c_errorcode := 5;
    c_errormesg := error_msg.err_p_outlet_withdraw_con_3;
    RETURN;
  END IF;


  --���������Ϣ
   update fund_withdraw
      set apply_status = eapply_status.withdraw
    where fund_no = p_app_flow;


  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
