CREATE OR REPLACE PROCEDURE p_item_check_step1
/****************************************************************/
  ------------------- 适用于仓库物品盘点-------------------
  ----第一步：新建盘点单
  ----add by dzg: 2015-10-13
  ----业务流程：当仓库正在盘点时，不能盘点，盘点时生成当前库房实际量
  ----如果不选任何物品，则默认盘点所有
  ----数据库定义序号生成函数修订
  ----增加逻辑修改仓库正在盘点中
  ----modify by dzg :2015-11-22 物品盘点删除更新仓库状态，因为和彩票冲突
  /*************************************************************/
(
 --------------输入----------------
 p_warehouse_opr  IN NUMBER, --盘点人
 p_check_name     IN STRING, --盘点名称
 p_warehouse_code IN STRING, --库房编码
 p_item_codes     IN STRING, --盘点物品列表，以“,"分割
 
 ---------出口参数---------
 c_check_code OUT STRING, --返回盘点单编号
 c_errorcode  OUT NUMBER, --错误编码
 c_errormesg  OUT STRING --错误原因
 
 ) IS

  v_count_temp NUMBER := 0; --临时变量
  v_count_tick NUMBER := 0; --存放临时库存总量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --名称不能为空
  IF ((p_check_name IS NULL) OR length(p_check_name) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_warehouse_check_step1_1;
    RETURN;
  END IF;

  --库房不能为空
  IF ((p_warehouse_code IS NULL) OR length(p_warehouse_code) <= 0) THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_warehouse_check_step1_2;
    RETURN;
  END IF;

  --盘点人无效
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

  --仓库无效或者正在盘点中
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

  --如果没有物品列表，则默认盘点所有

  /*----------- 插入数据  -----------------*/
  --插入基本信息
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
     
   --更新仓库状态
   
   --update wh_info set wh_info.status = ewarehouse_status.checking
   -- where wh_info.warehouse_code = p_warehouse_code;

  --插入盘点前记录
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
