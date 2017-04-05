CREATE OR REPLACE PROCEDURE p_roleprivilege_create
/****************************************************************/
  ------------------- �����ڴ�����ɫȨ��-------------------
  ----������ɫȨ��
  ----add by dzg: 2015-9-19 
  ----ҵ�����̣���ɾ��ԭ���û�Ȩ�ޣ�Ȼ������µĽ�ɫȨ��
  /*************************************************************/
(
 --------------����----------------
 p_role_id      IN NUMBER, --��ɫID
 p_role_privileges   IN STRING, --Ȩ���б�,ʹ�á�,���ָ�Ķ���ַ���
 
 ---------���ڲ���---------
 c_errorcode OUT NUMBER, --�������
 c_errormesg OUT STRING --����ԭ��
 
 ) IS

  v_count_temp NUMBER := 0; --��ʱ����

BEGIN

  /*-----------    ��ʼ������    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- ����У��   -----------------*/
  --��ɫ�����쳣
  IF (p_role_id < 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_1;
    RETURN;
  END IF;

  --ѭ�������ɫ�û�
  --������ԭ������
  
  delete from adm_role_privilege
   where adm_role_privilege.role_id = p_role_id;

  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_role_privileges))) LOOP
    dbms_output.put_line(i.column_value);
  
    IF length(i.column_value) > 0 THEN
      
    insert into adm_role_privilege
      (role_id, privilege_id)
    values
      (p_role_id,i.column_value);
  
    
    END IF;
  END LOOP;
  

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END p_roleprivilege_create;
/
