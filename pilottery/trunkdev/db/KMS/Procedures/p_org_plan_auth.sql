CREATE OR REPLACE PROCEDURE p_org_plan_auth
/***************************************************************
  ------------------- ��֯��������������Ȩ -------------------
  ---------add by dzg  2015-9-16 ��֯�����ķ�����Ȩ
  ----modify by dzg 2015-9-17 д��������Ӷ����
  ************************************************************/
(
 
 --------------����----------------
 p_org_code       IN STRING, --�������
 p_org_credit     IN NUMBER, --�������ö��
 p_game_auth_list IN type_game_auth_list, --��Ȩ�����б�
 
 --------------���ڲ���----------------
 c_errorcode OUT NUMBER, --�������
 c_errormesg OUT STRING --����ԭ��
 
 ) IS

  v_cur_auth_info type_game_auth_info; --��ǰ��Ȩ��Ϣ������ѭ������
  v_temp          NUMBER := 0; --��ʱ���������з���

BEGIN
  /*-----------    ��ʼ������    -----------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  /*-----------  ��������У��    ----------*/
  IF p_game_auth_list.count < 0 THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_ORG_PLAN_AUTH_1;
    RETURN;
  END IF;

  /*-----------  У�鷢�з���    ----------*/
  FOR i IN 1 .. p_game_auth_list.count LOOP
  
    v_cur_auth_info := p_game_auth_list(i);
    ---�Ƚ�ֵ
    IF 1000 < v_cur_auth_info.salecommissionrate THEN
      c_errorcode := 1;
      --c_errormesg := '���з��ó�����Χ';
      c_errormesg := error_msg.ERR_P_ORG_PLAN_AUTH_2;
      RETURN;
    END IF;
  
  END LOOP;

  /*-----------  �������ö��       -----------*/

  update acc_org_account
     set credit_limit = p_org_credit
   where org_code = p_org_code
     and acc_type = eacc_type.main_account;

  v_cur_auth_info := NULL;

  /*----------- ѡ������վѭ������ -----------*/

  FOR i IN 1 .. p_game_auth_list.count LOOP
  
    v_cur_auth_info := p_game_auth_list(i);
  
    ---�����
    DELETE FROM game_org_comm_rate au
     WHERE au.plan_code = v_cur_auth_info.plancode
       AND au.org_code = p_org_code;
  
    ---�����
    insert into game_org_comm_rate
      (org_code, plan_code, sale_comm, pay_comm)
    values
      (p_org_code,
       v_cur_auth_info.plancode,
       v_cur_auth_info.salecommissionrate,
       v_cur_auth_info.paycommissionrate);
  
  END LOOP;
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END;
