CREATE OR REPLACE PROCEDURE p_outlet_create
/****************************************************************/
  ------------------- 适用于新增站点-------------------
  ----创建组织结构
  ----add by dzg: 2015-9-12
  ----业务流程：先插入主表，插入附属表，默认状态为可用
  ----编码自动生成，返回站点编码
  ----modify by dzg 2015-9-15 增加功能，在新增时创建账户
  /*************************************************************/
(
 --------------输入----------------
 
 p_outlet_name      IN STRING, --站点名称
 p_outlet_person    IN STRING, --站点联系人
 p_outlet_phone     IN STRING, --站点联系人电话
 p_outlet_bankid    IN NUMBER, --关联银行
 p_outlet_bankacc   IN STRING, --关联银行账号
 p_outlet_pid       IN STRING, --证件号码
 p_outlet_cno       IN STRING, --合同编码
 p_area_code        IN STRING, --所属区域
 p_Institution_code IN STRING, --所属部门
 p_outlet_address   IN STRING, --所属区域 
 p_outlet_stype     IN NUMBER, --店面类型
 p_outlet_type      IN NUMBER, --站点类型
 p_outlet_admin     IN NUMBER, --站点管理人员
 p_outlet_g_n       IN STRING, --站点经度
 p_outlet_g_e       IN STRING, --站点维度
 p_outlet_pwd       IN STRING, --站点默认密码
 
 ---------出口参数---------
 c_outlet_code OUT STRING, --站点编码
 c_errorcode   OUT NUMBER, --错误编码
 c_errormesg   OUT STRING --错误原因
 
 ) IS

  v_count_temp NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  c_outlet_code := '';
  v_count_temp  := 0;

  /*----------- 数据校验   -----------------*/
  --部门编码不能为空
  IF ((p_Institution_code IS NULL) OR length(p_Institution_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_OUTLET_CREATE_1;
    RETURN;
  END IF;

  --部门无效
  SELECT count(u.org_code)
    INTO v_count_temp
    FROM inf_orgs u
   WHERE u.org_code = p_Institution_code
     And u.org_status = org_status.available;

  IF v_count_temp <= 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.ERR_P_OUTLET_CREATE_2;
    RETURN;
  END IF;

  --区域不能为空
  IF ((p_area_code IS NULL) OR length(p_area_code) <= 0) THEN
    c_errorcode := 3;
    c_errormesg := error_msg.ERR_P_OUTLET_CREATE_3;
    RETURN;
  END IF;

  --区域无效

  v_count_temp := 0;
  SELECT count(u.area_code)
    INTO v_count_temp
    FROM inf_areas u
   WHERE u.area_code = p_area_code;

  IF v_count_temp <= 0 THEN
    c_errorcode := 4;
    c_errormesg := error_msg.ERR_P_OUTLET_CREATE_4;
    RETURN;
  END IF;

  --插入基本信息

  --先生成编码
  c_outlet_code := f_get_agency_code_by_area(p_area_code);

  insert into inf_agencys
    (agency_code,
     agency_name,
     storetype_id,
     status,
     agency_type,
     bank_id,
     bank_account,
     telephone,
     contact_person,
     address,
     agency_add_time,
     org_code,
     area_code,
     login_pass,
     trade_pass,
     market_manager_id)
  values
    (c_outlet_code,
     p_outlet_name,
     p_outlet_stype,
     eagency_status.enabled,
     p_outlet_type,
     p_outlet_bankid,
     p_outlet_bankacc,
     p_outlet_phone,
     p_outlet_person,
     p_outlet_address,
     sysdate,
     p_Institution_code,
     p_area_code,
     p_outlet_pwd,
     p_outlet_pwd,
     p_outlet_admin);

  --插入扩展信息

  insert into inf_agency_ext
    (agency_code, personal_id, contract_no, glatlng_n, glatlng_e)
  values
    (c_outlet_code, p_outlet_pid, p_outlet_cno, p_outlet_g_n, p_outlet_g_e);

  --生成账户信息
  insert into acc_agency_account
    (agency_code,
     acc_type,
     acc_name,
     acc_status,
     acc_no,
     credit_limit,
     account_balance,
     frozen_balance,
     check_code
     )
  values
    (c_outlet_code,
     eacc_type.main_account,
     p_outlet_name,
     eacc_status.available,
     f_get_acc_no(c_outlet_code,'ZD'),
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
  
END p_outlet_create;
/
