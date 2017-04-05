CREATE OR REPLACE PROCEDURE p_warehouse_modify
/****************************************************************/
  ------------------- 适用于修改仓库-------------------
  ----修改仓库
  ----add by dzg: 2015-9-17
  ----业务流程：先更新仓库表，依次判断仓库管理员，存在跳过，不存在则同新增同操作
  /*************************************************************/
(
 --------------输入----------------
 p_warehouse_code     IN STRING, --库房编码
 p_warehouse_name     IN STRING, --库房名称
 p_org_code           IN STRING, --机构编码
 p_warehouse_adds     IN STRING, --库房地址
 p_warehouse_phone    IN STRING, --库房电话
 p_warehouse_admin    IN NUMBER, --库房负责人
 p_warehouse_managers IN STRING, --库房管理人员列表,使用“,”分割的多个字符串
 
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

  --编码不能重复
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

  --名称不能为空
  IF ((p_warehouse_name IS NULL) OR length(p_warehouse_name) <= 0) THEN
    c_errorcode := 3;
    c_errormesg := error_msg.ERR_P_WAREHOUSE_CREATE_3;
    RETURN;
  END IF;

  --地址不能为空
  IF ((p_warehouse_adds IS NULL) OR length(p_warehouse_adds) <= 0) THEN
    c_errorcode := 4;
    c_errormesg := error_msg.ERR_P_WAREHOUSE_CREATE_4;
    RETURN;
  END IF;

  --负责人不存在
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

  --编码重复管辖
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

  /*----------- 插入数据  -----------------*/
  --update基本信息

  update wh_info
     set warehouse_name = p_warehouse_name,
         org_code       = p_org_code,
         address        = p_warehouse_adds,
         phone          = p_warehouse_phone,
         director_admin = p_warehouse_admin
   where warehouse_code = p_warehouse_code;

  ---更新原来的数据为无效
  update wh_manager
     set is_valid = eboolean.noordisabled
   where warehouse_code = p_warehouse_code;
  update adm_info
     set adm_info.is_warehouse_m = eboolean.noordisabled
   where adm_info.admin_id in
         (select wh_manager.manager_id
            from wh_manager
           where wh_manager.warehouse_code = p_warehouse_code);

  --循环的更新管理员信息，并更新权限信息表
  --原来数据存在则跳过
  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_warehouse_managers))) LOOP
    dbms_output.put_line(i.column_value);
  
    IF length(i.column_value) > 0 THEN
    
      v_count_temp := 0;
    
      SELECT count(u.warehouse_code)
        INTO v_count_temp
        FROM wh_manager u
       WHERE u.manager_id = i.column_value;
    
      IF v_count_temp > 0 THEN
        ---更新账户
        update wh_manager
           set warehouse_code = p_warehouse_code,
               org_code       = p_org_code,
               is_valid       = eboolean.yesorenabled,
               start_time     = sysdate
         where manager_id = i.column_value;
      
      END IF;
    
      IF v_count_temp <= 0 THEN
        ---插入账户
        insert into wh_manager
          (warehouse_code, org_code, manager_id, is_valid, start_time)
        values
          (p_warehouse_code,
           p_org_code,
           i.column_value,
           eboolean.yesorenabled,
           sysdate);
      END IF;
    
      ---更新状态
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
