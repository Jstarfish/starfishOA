CREATE OR REPLACE PROCEDURE p_institutions_modify
/****************************************************************/
  ------------------- 适用于修改组织机构-------------------
  ----修改组织结构
  ----add by dzg: 2015-9-8 
  ----业务流程：判断是否修改编码，如果修改编码，则机构有除
  ----领导之外的其他人员的时候，则不能修改
  ----modify by dzg 2015-9-28 bug修改的时候编码不能重复
  ----modify by dzg 2015-11-13 检测区域重复
  /*************************************************************/
(
 --------------输入----------------
 p_institutions_code_o IN STRING, --机构原编码
 p_institutions_code   IN STRING, --机构编码
 p_institutions_name   IN STRING, --机构名称
 p_institutions_type   IN STRING, --机构类型  1 公司  2 代理
 p_institutions_pare   IN STRING, --上级结构
 p_institutions_head   IN NUMBER, --部门负责人
 p_institutions_phone  IN STRING, --部门电话
 p_institutions_emps   IN NUMBER, --部门人数
 p_institutions_adds   IN STRING, --部门地址
 p_institutions_areas  IN STRING, --管辖区域列表,使用“,”分割的多个字符串
 
 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 
 ) IS

  v_count_temp NUMBER := 0; --临时变量
  v_insti_pnum NUMBER := 0; --部门人数

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;
  
  IF ((p_institutions_emps IS NULL) OR length(p_institutions_emps) <= 0) THEN
    v_insti_pnum := 0;
  ELSE
    v_insti_pnum := p_institutions_emps; 
  END IF;

  /*----------- 数据校验   -----------------*/

  --部门原编码不能为空
  IF ((p_institutions_code_o IS NULL) OR length(p_institutions_code_o) <= 0) THEN
    c_errorcode := 5;
    c_errormesg := error_msg.ERR_P_INSTITUTIONS_MODIFY_1;
    RETURN;
  END IF;

  --部门编码不能为空
  IF ((p_institutions_code IS NULL) OR length(p_institutions_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_1;
    RETURN;
  END IF;

  --如果原编码和新编码不一致
  IF (p_institutions_code_o <> p_institutions_code) THEN
  
    v_count_temp := 0;
    --检测原部门下是不是挂有除负责人外的其他人员
    SELECT count(u.admin_id)
      INTO v_count_temp
      FROM adm_info u
     WHERE u.admin_id in
           (select inf_orgs.director_admin
              from inf_orgs
             where inf_orgs.org_code = p_institutions_code_o);
  
    IF v_count_temp > 0 THEN
      c_errorcode := 6;
      c_errormesg := error_msg.ERR_P_INSTITUTIONS_MODIFY_2;
      RETURN;
    END IF;
  
  END IF;

  --部门名称不能为空
  IF ((p_institutions_name IS NULL) OR length(p_institutions_name) <= 0) THEN
    c_errorcode := 2;
    c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_2;
    RETURN;
  END IF;

  --部门负责人不存在
  v_count_temp := 0;

  IF p_institutions_head > 0 THEN
    SELECT count(u.admin_id)
      INTO v_count_temp
      FROM adm_info u
     WHERE u.admin_id = p_institutions_head
       And u.admin_status <> eadmin_status.DELETED;
  
    IF v_count_temp <= 0 THEN
      c_errorcode := 3;
      c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_3;
      RETURN;
    END IF;
  END IF;

  --部门名称不能为空
  IF ((p_institutions_phone IS NULL) OR length(p_institutions_phone) <= 0) THEN
    c_errorcode := 4;
    c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_4;
    RETURN;
  END IF;

  --部门编码重复

  IF (p_institutions_code_o <> p_institutions_code) THEN
    v_count_temp := 0;
  
    SELECT count(u.org_code)
      INTO v_count_temp
      FROM inf_orgs u
     WHERE u.org_code = p_institutions_code;
  
    IF v_count_temp > 0 THEN
      c_errorcode := 5;
      c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_5;
      RETURN;
    END IF;
  END IF;
  
   --检测区域被重复管辖
  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_institutions_areas))) LOOP
    dbms_output.put_line(i.column_value);
  
    IF length(i.column_value) > 0 THEN
        
       v_count_temp := 0;
        SELECT count(*)
          INTO v_count_temp
          FROM inf_org_area u
         WHERE u.area_code = i.column_value
         and u.org_code != p_institutions_code;

        IF v_count_temp > 0 THEN
          c_errorcode := 6;
          c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_6;
          RETURN;
        END IF;
    
    END IF;
  END LOOP;

  --插入基本信息
  update inf_orgs
     set org_code       = p_institutions_code,
         org_name       = p_institutions_name,
         org_type       = p_institutions_type,
         super_org      = p_institutions_pare,
         phone          = p_institutions_phone,
         director_admin = p_institutions_head,
         persons        = p_institutions_emps,
         address        = p_institutions_adds
   where org_code = p_institutions_code_o;

  --循环插入管辖区域
  --先清理原有数据
  delete from inf_org_area
   where inf_org_area.org_code = p_institutions_code
      or inf_org_area.org_code = p_institutions_code_o;

  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_institutions_areas))) LOOP
    dbms_output.put_line(i.column_value);
  
    IF length(i.column_value) > 0 THEN
    
      insert into inf_org_area
        (org_code, area_code)
      values
        (p_institutions_code, i.column_value);
    
    END IF;
  END LOOP;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END p_institutions_modify;
/
