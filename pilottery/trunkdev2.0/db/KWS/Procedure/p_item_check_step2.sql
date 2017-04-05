CREATE OR REPLACE PROCEDURE p_item_check_step2
/****************************************************************/
  ------------------- 适用于仓库物品盘点-------------------
  ----第二步：继续盘点 或者 盘点完成
  ----add by dzg: 2015-10-13
  ----业务流程：根据操作状态来定义是否盘点完成，还是继续盘点
  ----modify by dzg :2015-10-26 增加remark 待处理陈震修改完表结构后继续....
  ----更新完毕后重置仓库状态
  /*************************************************************/
(
 --------------输入----------------
 p_warehouse_opr  IN NUMBER, --盘点人
 p_check_code     IN STRING, --盘点单编号
 p_warehouse_code IN STRING, --库房编码
 p_check_opr      IN NUMBER, --盘点操作 ：1 保存  2 保存且完成
 p_remark         IN STRING, --盘点结果备注
 p_items          IN type_item_list, -- 入库的物品对象
 
 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 
 ) IS

  v_count_temp  NUMBER := 0; --临时变量,用于存放盘点前数量
  v_count_temp1 NUMBER := 0; --临时变量,用于存放盘点结果
  v_item        type_item_info; --循环变量的当前值
BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --编码不能为空
  IF ((p_check_code IS NULL) OR length(p_check_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_warehouse_check_step2_1;
    RETURN;
  END IF;

  --编码无效
  v_count_temp := 0;
  SELECT count(o.check_no)
    INTO v_count_temp
    FROM item_check o
   WHERE o.check_no = p_check_code
     AND o.status <> ecp_status.done;

  IF v_count_temp <= 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_warehouse_check_step2_2;
    RETURN;
  END IF;

  --遍历p_items插入盘点后的数据，将采用覆盖式，先删除后插入方式

  for i in 1 .. p_items.count loop
    v_item := p_items(i);
  
    v_count_temp  := 0;
    v_count_temp1 := ecp_result.same;
  
    select be.quantity
      into v_count_temp
      from item_check_detail_be be
     where be.check_no = p_check_code
       and be.item_code = v_item.item_code;
  
    IF (v_count_temp > v_item.quantity) THEN
      v_count_temp1 := ecp_result.less;
    ELSIF (v_count_temp < v_item.quantity) THEN
      v_count_temp1 := ecp_result.more;
    END IF;
  
    delete from item_check_detail_af
     where check_no = p_check_code
       and item_code = v_item.item_code;
  
    insert into item_check_detail_af
      (check_no, item_code, quantity, change_quantity, result)
    values
      (p_check_code,
       v_item.item_code,
       v_item.quantity,
       v_item.quantity - v_count_temp,
       v_count_temp1);
  end loop;
  
  --更新盘点结果备注
  update item_check
     set remark = p_remark
   where check_no = p_check_code;

  --完成则更新状态
  IF ((p_check_opr IS NOT NULL) AND (p_check_opr = 2)) THEN
    
    update item_check
       set status = ecp_status.done
     where check_no = p_check_code;
  
    --更新仓库状态 
    update wh_info
       set wh_info.status = ewarehouse_status.working
     where wh_info.warehouse_code = p_warehouse_code;
  
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END;
