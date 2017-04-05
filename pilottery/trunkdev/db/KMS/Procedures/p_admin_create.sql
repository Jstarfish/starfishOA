CREATE OR REPLACE PROCEDURE p_admin_create
/****************************************************************/
  ------------------- ���ô���ϵͳ�û�-------------------
  ----����ϵͳ�û�
  ----add by dzg: 2015-9-17
  ----ҵ�����̣��Ȳ�������������г�����Ա��������г�����Ա�˻�
  ----modify by dzg 2015-9-24 �����ٲ���һ�ű� inf_market_admin
  /*************************************************************/
(
 --------------����----------------
 p_admin_realname    IN STRING, --��ʵ����
 p_admin_loginid     IN STRING, --��¼��
 p_admin_password    IN STRING, --Ĭ������
 p_admin_gender      IN NUMBER, --�Ա�
 p_admin_insticode   IN STRING, --�������ű���
 p_admin_birthday    IN Date, --��������
 p_admin_mobilephone IN STRING, --�ƶ��绰
 p_admin_officephone IN STRING, --�칫�绰
 p_admin_homephone   IN STRING, --��ͥ�绰
 p_admin_email       IN STRING, --�����ʼ�
 p_admin_address     IN STRING, --��ͥסַ
 p_admin_remark      IN STRING, --��ע��Ϣ
 p_admin_ismarketm   IN NUMBER, --�Ƿ��г�����Ա
 
 ---------���ڲ���---------
 c_admin_id  OUT NUMBER, -- ��½�û�ID
 c_errorcode OUT NUMBER, --�������
 c_errormesg OUT STRING --����ԭ��
 
 ) IS

  v_count_temp NUMBER := 0; --��ʱ����

BEGIN

  /*-----------    ��ʼ������    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- ����У��   -----------------*/
  --��ʵ��������Ϊ��
  IF ((p_admin_realname IS NULL) OR length(p_admin_realname) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_ADMIN_CREATE_1;
    RETURN;
  END IF;

  --��½���Ʋ���Ϊ��
  IF ((p_admin_loginid IS NULL) OR length(p_admin_loginid) <= 0) THEN
    c_errorcode := 2;
    c_errormesg := error_msg.ERR_P_ADMIN_CREATE_2;
    RETURN;
  END IF;

  --��½���Ʋ����ظ�
  v_count_temp := 0;
  SELECT count(o.admin_id)
    INTO v_count_temp
    FROM adm_info o
   WHERE o.admin_login = p_admin_loginid
     AND o.admin_status <> eadmin_status.DELETED;

  IF v_count_temp > 0 THEN
    c_errorcode := 3;
    c_errormesg := error_msg.ERR_P_ADMIN_CREATE_3;
    RETURN;
  END IF;

  /*----------- ����У��   -----------------*/
  --���������Ϣ
  v_count_temp := f_get_adm_id_seq();

  insert into adm_info
    (admin_id,
     admin_realname,
     admin_login,
     admin_password,
     admin_gender,
     admin_email,
     admin_birthday,
     admin_tel,
     admin_mobile,
     admin_phone,
     admin_org,
     admin_address,
     admin_remark,
     admin_status,
     admin_create_time,
     create_admin_id,
     is_collecter)
  values
    (v_count_temp,
     p_admin_realname,
     p_admin_loginid,
     p_admin_password,
     P_admin_gender,
     P_admin_email,
     P_admin_birthday,
     p_admin_officephone,
     p_admin_mobilephone,
     p_admin_homephone,
     p_admin_insticode,
     p_admin_address,
     p_admin_remark,
     eadmin_status.AVAILIBLE,
     sysdate,
     0,
     p_admin_ismarketm);

  --ѭ���Ĳ������Ա��Ϣ��������Ȩ����Ϣ��
  --������ԭ������

  IF p_admin_ismarketm = eboolean.yesorenabled THEN
  
    ---�����г�����Ա�˻�
    insert into acc_mm_account
      (market_admin,
       acc_type,
       acc_name,
       acc_status,
       acc_no,
       credit_limit,
       account_balance,
       check_code)
    values
      (v_count_temp,
       eacc_type.main_account,
       p_admin_realname,
       eacc_status.available,
       f_get_acc_no(v_count_temp, 'MM'),
       0,
       0,
       '-');
    --�����г������˻�
    insert into inf_market_admin
      (market_admin, trans_pass, credit_by_tran, max_amount_ticketss)
    values
      (v_count_temp,
       p_admin_password,
       0,
       0);
  
  END IF;
  c_admin_id := v_count_temp;
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END p_admin_create;
/
