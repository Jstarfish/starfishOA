CREATE OR REPLACE PROCEDURE p_institutions_create
/****************************************************************/
  ------------------- 适用于创建组织机构-------------------
  ----创建组织结构
  ----add by dzg: 2015-9-8
  ----业务流程：先插入主表，依次对象字表中
  ----modify by dzg 2015-9-9 表调整状态，增加初始化状态
  ----modify by dzg 2015-9-12 发现bug，address的值保存成额id列表
  ----modify by dzg 2015-9-16 增加功能，新增时创建账户
  ----modify by dzg 2015-10-22 处理部门人数的问题：默认为0
  ----modify by dzg 2015-11-12 检测机构是否重复管辖区域
  /*************************************************************/
(
 --------------输入----------------
 p_institutions_code  IN STRING, --机构编码
 p_institutions_name  IN STRING, --机构名称
 p_institutions_type  IN STRING, --机构类型  1 公司  2 代理
 p_institutions_pare  IN STRING, --上级结构
 p_institutions_head  IN NUMBER, --部门负责人
 p_institutions_phone IN STRING, --部门电话
 p_institutions_emps  IN NUMBER, --部门人数
 p_institutions_adds  IN STRING, --部门地址
 p_institutions_areas IN STRING, --管辖区域列表,使用“,”分割的多个字符串

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
  --部门编码不能为空
  IF ((p_institutions_code IS NULL) OR length(p_institutions_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_1;
    RETURN;
  END IF;

  --部门名称不能为空
  IF ((p_institutions_name IS NULL) OR length(p_institutions_name) <= 0) THEN
    c_errorcode := 2;
    c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_2;
    RETURN;
  END IF;

  --部门负责人不存在
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

  --部门名称不能为空
  IF ((p_institutions_phone IS NULL) OR length(p_institutions_phone) <= 0) THEN
    c_errorcode := 4;
    c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_4;
    RETURN;
  END IF;

  --部门编码重复
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


 --检测区域被重复管辖
  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_institutions_areas))) LOOP
    dbms_output.put_line(i.column_value);

    IF length(i.column_value) > 0 THEN

       v_count_temp := 0;
        SELECT count(*)
          INTO v_count_temp
          FROM inf_org_area u
         WHERE u.area_code = i.column_value;

        IF v_count_temp > 0 THEN
          c_errorcode := 6;
          c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_6;
          RETURN;
        END IF;

    END IF;
  END LOOP;


  --插入基本信息
  insert into inf_orgs
    (org_code,
     org_name,
     org_type,
     super_org,
     phone,
     director_admin,
     persons,
     address,
     org_status)
  values
    (p_institutions_code,
     p_institutions_name,
     p_institutions_type,
     p_institutions_pare,
     p_institutions_phone,
     p_institutions_head,
     v_insti_pnum,
     p_institutions_adds,
     eorg_status.available);

  --循环插入管辖区域
  --先清理原有数据
  delete from inf_org_area
   where inf_org_area.org_code = p_institutions_code;

  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_institutions_areas))) LOOP
    dbms_output.put_line(i.column_value);

    IF length(i.column_value) > 0 THEN

      insert into inf_org_area
        (org_code, area_code)
      values
        (p_institutions_code, i.column_value);

    END IF;
  END LOOP;

  --创建账户
  insert into acc_org_account
    (org_code,
     acc_type,
     acc_name,
     acc_status,
     acc_no,
     credit_limit,
     account_balance,
     frozen_balance,
     check_code)
  values
    (p_institutions_code,
     eacc_type.main_account,
     p_institutions_name,
     eacc_status.available,
     f_get_acc_no(p_institutions_code,'JG'),
     0,
     0,
     0,
     '-');


  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END p_institutions_create;
