CREATE OR REPLACE PROCEDURE p_warehouse_modify
/****************************************************************/
  ------------------- �������޸Ĳֿ�-------------------
  ----�޸Ĳֿ�
  ----add by dzg: 2015-9-17
  ----ҵ�����̣��ȸ��²ֿ�������жϲֿ����Ա��������������������ͬ����ͬ����
  /*************************************************************/
(
 --------------����----------------
 p_warehouse_code     IN STRING, --�ⷿ����
 p_warehouse_name     IN STRING, --�ⷿ����
 p_org_code           IN STRING, --��������
 p_warehouse_adds     IN STRING, --�ⷿ��ַ
 p_warehouse_phone    IN STRING, --�ⷿ�绰
 p_warehouse_admin    IN NUMBER, --�ⷿ������
 p_warehouse_managers IN STRING, --�ⷿ������Ա�б�,ʹ�á�,���ָ�Ķ���ַ���
 
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
  --���벻��Ϊ��
  IF ((p_warehouse_code IS NULL) OR length(p_warehouse_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_WAREHOUSE_CREATE_1;
    RETURN;
  END IF;

  --���벻���ظ�
  v_count_temp := 0;
  SELECT count(o.warehouse_code)
    INTO v_count_temp
    FROM wh_info o
   WHERE o.warehouse_code = p_warehouse_code
     AND o.org_code = p_org_code;

  IF v_count_temp <= 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.ERR_P_WAREHOUSE_MODIFY_1;
    RETURN;
  END IF;

  --���Ʋ���Ϊ��
  IF ((p_warehouse_name IS NULL) OR length(p_warehouse_name) <= 0) THEN
    c_errorcode := 3;
    c_errormesg := error_msg.ERR_P_WAREHOUSE_CREATE_3;
    RETURN;
  END IF;

  --��ַ����Ϊ��
  IF ((p_warehouse_adds IS NULL) OR length(p_warehouse_adds) <= 0) THEN
    c_errorcode := 4;
    c_errormesg := error_msg.ERR_P_WAREHOUSE_CREATE_4;
    RETURN;
  END IF;

  --�����˲�����
  v_count_temp := 0;
  SELECT count(u.admin_id)
    INTO v_count_temp
    FROM adm_info u
   WHERE u.admin_id = p_warehouse_admin
     And u.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 5;
    c_errormesg := error_msg.ERR_P_WAREHOUSE_CREATE_5;
    RETURN;
  END IF;

  --�����ظ���Ͻ
  v_count_temp := 0;

  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_warehouse_managers))) LOOP
    dbms_output.put_line(i.column_value);
  
    IF length(i.column_value) > 0 THEN
    
      v_count_temp := 0;
      SELECT count(u.warehouse_code)
        INTO v_count_temp
        FROM wh_manager u
       WHERE u.manager_id = i.column_value
         And u.is_valid = eboolean.yesorenabled
         And u.warehouse_code <> p_warehouse_code;
    
      IF v_count_temp > 0 THEN
        c_errorcode := 6;
        c_errormesg := i.column_value || error_msg.ERR_P_WAREHOUSE_CREATE_6;
        RETURN;
      END IF;
    
    END IF;
  END LOOP;

  /*----------- ��������  -----------------*/
  --update������Ϣ

  update wh_info
     set warehouse_name = p_warehouse_name,
         org_code       = p_org_code,
         address        = p_warehouse_adds,
         phone          = p_warehouse_phone,
         director_admin = p_warehouse_admin
   where warehouse_code = p_warehouse_code;

  ---����ԭ��������Ϊ��Ч
  update wh_manager
     set is_valid = eboolean.noordisabled
   where warehouse_code = p_warehouse_code;
  update adm_info
     set adm_info.is_warehouse_m = eboolean.noordisabled
   where adm_info.admin_id in
         (select wh_manager.manager_id
            from wh_manager
           where wh_manager.warehouse_code = p_warehouse_code);

  --ѭ���ĸ��¹���Ա��Ϣ��������Ȩ����Ϣ��
  --ԭ�����ݴ���������
  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_warehouse_managers))) LOOP
    dbms_output.put_line(i.column_value);
  
    IF length(i.column_value) > 0 THEN
    
      v_count_temp := 0;
    
      SELECT count(u.warehouse_code)
        INTO v_count_temp
        FROM wh_manager u
       WHERE u.manager_id = i.column_value;
    
      IF v_count_temp > 0 THEN
        ---�����˻�
        update wh_manager
           set warehouse_code = p_warehouse_code,
               org_code       = p_org_code,
               is_valid       = eboolean.yesorenabled,
               start_time     = sysdate
         where manager_id = i.column_value;
      
      END IF;
    
      IF v_count_temp <= 0 THEN
        ---�����˻�
        insert into wh_manager
          (warehouse_code, org_code, manager_id, is_valid, start_time)
        values
          (p_warehouse_code,
           p_org_code,
           i.column_value,
           eboolean.yesorenabled,
           sysdate);
      END IF;
    
      ---����״̬
      update adm_info
         set adm_info.is_warehouse_m = eboolean.yesorenabled
       where adm_info.admin_id = i.column_value;
    
    END IF;
  END LOOP;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END p_warehouse_modify;
/
