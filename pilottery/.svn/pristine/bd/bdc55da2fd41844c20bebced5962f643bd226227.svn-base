CREATE OR REPLACE PROCEDURE p_warehouse_delete
/****************************************************************/
  ------------------- 适用于删除仓库-------------------
  ----修改仓库
  ----add by dzg: 2015-9-17
  ----业务流程：  当该仓库中有库存时，不可进行时删除；
  /*************************************************************/
(
 --------------输入----------------
 p_warehouse_code IN STRING, --库房编码
 p_warehouse_opr  IN NUMBER, --当前操作人
 
 ---------出口参数---------
 
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 
 ) IS

  v_count_temp NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --编码不能为空
  IF ((p_warehouse_code IS NULL) OR length(p_warehouse_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_WAREHOUSE_CREATE_1;
    RETURN;
  END IF;

  --检测是否有库存彩票-trunk
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

  --检测是否有库存彩票-box
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

  --检测是否有库存彩票-package
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

  --检测是否有物品在库

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

  /*----------- 插入数据  -----------------*/

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
