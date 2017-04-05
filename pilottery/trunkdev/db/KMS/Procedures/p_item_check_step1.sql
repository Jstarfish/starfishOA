CREATE OR REPLACE PROCEDURE p_item_check_step1
/****************************************************************/
  ------------------- �����ڲֿ���Ʒ�̵�-------------------
  ----��һ�����½��̵㵥
  ----add by dzg: 2015-10-13
  ----ҵ�����̣����ֿ������̵�ʱ�������̵㣬�̵�ʱ���ɵ�ǰ�ⷿʵ����
  ----�����ѡ�κ���Ʒ����Ĭ���̵�����
  ----���ݿⶨ��������ɺ����޶�
  ----�����߼��޸Ĳֿ������̵���
  ----modify by dzg :2015-11-22 ��Ʒ�̵�ɾ�����²ֿ�״̬����Ϊ�Ͳ�Ʊ��ͻ
  /*************************************************************/
(
 --------------����----------------
 p_warehouse_opr  IN NUMBER, --�̵���
 p_check_name     IN STRING, --�̵�����
 p_warehouse_code IN STRING, --�ⷿ����
 p_item_codes     IN STRING, --�̵���Ʒ�б��ԡ�,"�ָ�
 
 ---------���ڲ���---------
 c_check_code OUT STRING, --�����̵㵥���
 c_errorcode  OUT NUMBER, --�������
 c_errormesg  OUT STRING --����ԭ��
 
 ) IS

  v_count_temp NUMBER := 0; --��ʱ����
  v_count_tick NUMBER := 0; --�����ʱ�������

BEGIN

  /*-----------    ��ʼ������    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- ����У��   -----------------*/
  --���Ʋ���Ϊ��
  IF ((p_check_name IS NULL) OR length(p_check_name) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_warehouse_check_step1_1;
    RETURN;
  END IF;

  --�ⷿ����Ϊ��
  IF ((p_warehouse_code IS NULL) OR length(p_warehouse_code) <= 0) THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_warehouse_check_step1_2;
    RETURN;
  END IF;

  --�̵�����Ч
  v_count_temp := 0;
  SELECT count(o.admin_id)
    INTO v_count_temp
    FROM adm_info o
   WHERE o.admin_id = p_warehouse_opr
     AND o.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 3;
    c_errormesg := error_msg.err_p_warehouse_check_step1_3;
    RETURN;
  END IF;

  --�ֿ���Ч���������̵���
  v_count_temp := 0;
  SELECT count(o.warehouse_code)
    INTO v_count_temp
    FROM wh_info o
   WHERE o.warehouse_code = p_warehouse_code;
    -- AND o.status = ewarehouse_status.working;

  IF v_count_temp <= 0 THEN
    c_errorcode := 4;
    c_errormesg := error_msg.err_p_warehouse_check_step1_4;
    RETURN;
  END IF;

  --���û����Ʒ�б���Ĭ���̵�����

  /*----------- ��������  -----------------*/
  --���������Ϣ
  c_check_code := f_get_item_ic_no_seq();

  insert into item_check
    (check_no,
     check_name,
     check_date,
     check_admin,
     check_warehouse,
     status,
     remark)
  values
    (c_check_code,
     p_check_name,
     sysdate,
     p_warehouse_opr,
     p_warehouse_code,
     ecp_status.working,
     '');
     
   --���²ֿ�״̬
   
   --update wh_info set wh_info.status = ewarehouse_status.checking
   -- where wh_info.warehouse_code = p_warehouse_code;

  --�����̵�ǰ��¼
  IF ((p_item_codes IS NULL) OR length(p_item_codes) < 0) THEN
  
    insert into item_check_detail_be
      select c_check_code, q.item_code, q.quantity
        from item_quantity q
       where q.warehouse_code = p_warehouse_code;
  
  ELSE
    FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_item_codes))) LOOP
      dbms_output.put_line(i.column_value);
    
      IF length(i.column_value) > 0 THEN
      
        insert into item_check_detail_be
          select c_check_code, q.item_code, q.quantity
            from item_quantity q
           where q.warehouse_code = p_warehouse_code
             and q.item_code = i.column_value;
      
      END IF;
      
    END LOOP;
  
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END;
