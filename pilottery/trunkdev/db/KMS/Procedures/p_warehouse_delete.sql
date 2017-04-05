CREATE OR REPLACE PROCEDURE p_warehouse_delete
/****************************************************************/
  ------------------- ������ɾ���ֿ�-------------------
  ----�޸Ĳֿ�
  ----add by dzg: 2015-9-17
  ----ҵ�����̣�  ���òֿ����п��ʱ�����ɽ���ʱɾ����
  /*************************************************************/
(
 --------------����----------------
 p_warehouse_code IN STRING, --�ⷿ����
 p_warehouse_opr  IN NUMBER, --��ǰ������
 
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

  --����Ƿ��п���Ʊ-trunk
  v_count_temp := 0;
  SELECT count(o.plan_code)
    INTO v_count_temp
    FROM wh_ticket_trunk o
   WHERE o.current_warehouse = p_warehouse_code
     AND o.is_full = eboolean.yesorenabled
     AND o.status = eticket_status.in_warehouse;

  IF v_count_temp > 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_warehouse_delete_1;
    RETURN;
  END IF;

  --����Ƿ��п���Ʊ-box
  v_count_temp := 0;
  SELECT count(o.plan_code)
    INTO v_count_temp
    FROM wh_ticket_box o
   WHERE o.current_warehouse = p_warehouse_code
     AND o.is_full = eboolean.yesorenabled
     AND o.status = eticket_status.in_warehouse;

  IF v_count_temp > 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_warehouse_delete_1;
    RETURN;
  END IF;

  --����Ƿ��п���Ʊ-package
  v_count_temp := 0;
  SELECT count(o.plan_code)
    INTO v_count_temp
    FROM wh_ticket_package o
   WHERE o.current_warehouse = p_warehouse_code
     AND o.is_full = eboolean.yesorenabled
     AND o.status = eticket_status.in_warehouse;

  IF v_count_temp > 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_warehouse_delete_1;
    RETURN;
  END IF;

  --����Ƿ�����Ʒ�ڿ�

  v_count_temp := 0;
  SELECT count(u.item_code)
    INTO v_count_temp
    FROM item_quantity u
   WHERE u.warehouse_code = p_warehouse_code;

  IF v_count_temp > 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_warehouse_delete_1;
    RETURN;
  END IF;

  /*----------- ��������  -----------------*/

  update wh_info
     set status     = ewarehouse_status.stoped,
         stop_admin = p_warehouse_opr,
         stop_date  = sysdate
   where warehouse_code = p_warehouse_code;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END p_warehouse_delete;
/
