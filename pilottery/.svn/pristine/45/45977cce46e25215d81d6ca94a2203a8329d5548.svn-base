CREATE OR REPLACE PROCEDURE p_outlet_modify
/****************************************************************/
  ------------------- 适用于修改站点-------------------
  ----修改站点信息
  ----如果编码不能修改，就把新旧的编码都设成一样的
  ----修改会检测p_outlet_code 是否已经存在
  ----如果修改同时修改扩展，账户编号；如果发现有充值或者预订信息则编码不能修改
  ----add by dzg: 2015-9-12
  ----modify by dzg:2015-9-15 增加修改经纬度
  /*************************************************************/
(
 --------------输入----------------
 p_outlet_code_o    IN STRING, --站点原编码
 p_outlet_code      IN STRING, --站点新编码
 p_outlet_name      IN STRING, --站点名称
 p_outlet_person    IN STRING, --站点联系人
 p_outlet_phone     IN STRING, --站点联系人电话
 p_outlet_bankid    IN NUMBER, --关联银行
 p_outlet_bankacc   IN STRING, --关联银行账号
 p_outlet_pid       IN STRING, --证件号码
 p_outlet_cno       IN STRING, --合同编码
 p_area_code        IN STRING, --所属区域
 p_Institution_code IN STRING, --所属部门
 p_outlet_address   IN STRING, --站点地址
 p_outlet_stype     IN NUMBER, --店面类型
 p_outlet_type      IN NUMBER, --站点类型
 p_outlet_admin     IN NUMBER, --站点管理人员
 p_outlet_g_n       IN STRING, --站点经度
 p_outlet_g_e       IN STRING, --站点维度

 ---------出口参数---------
 c_outlet_code OUT STRING, --站点编码
 c_errorcode   OUT NUMBER, --错误编码
 c_errormesg   OUT STRING --错误原因

 ) IS

  v_count_temp NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  c_outlet_code := p_outlet_code;
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
     And u.org_status = eorg_status.available;

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

  --检测站点编码
  IF p_outlet_code <> p_outlet_code_o THEN

    --非空
    IF ((p_outlet_code IS NULL) OR length(p_outlet_code) <= 0) THEN
      c_errorcode := 6;
      c_errormesg := error_msg.ERR_P_OUTLET_MODIFY_2;
      RETURN;
    END IF;

    --长度
    IF (length(p_outlet_code) <> 8) THEN
      c_errorcode := 6;
      c_errormesg := error_msg.ERR_P_OUTLET_MODIFY_2;
      RETURN;
    END IF;

    v_count_temp := substr(p_outlet_code, 0, 4);
    --前四位区域编码
    IF (p_area_code <> v_count_temp) THEN
      c_errorcode := 6;
      c_errormesg := error_msg.ERR_P_OUTLET_MODIFY_2;
      RETURN;
    END IF;

    --编码重复
    v_count_temp := 0;
    SELECT count(u.agency_code)
      INTO v_count_temp
      FROM inf_agencys u
     WHERE u.agency_code = p_outlet_code;

    IF v_count_temp > 0 THEN
      c_errorcode := 5;
      c_errormesg := error_msg.ERR_P_OUTLET_MODIFY_2;
      RETURN;
    END IF;

    --有资金业务
    v_count_temp := 0;
    SELECT count(a.agency_fund_flow)
      INTO v_count_temp
      FROM flow_agency a, acc_agency_account c
     WHERE a.acc_no = c.acc_no
       AND c.agency_code = p_outlet_code;

    IF v_count_temp > 0 THEN
      c_errorcode := 6;
      c_errormesg := error_msg.ERR_P_OUTLET_MODIFY_3;
      RETURN;
    END IF;

    --有订单业务
    v_count_temp := 0;
    SELECT count(u.order_no)
      INTO v_count_temp
      FROM sale_order u
     WHERE u.apply_agency = p_outlet_code;

    IF v_count_temp > 0 THEN
      c_errorcode := 5;
      c_errormesg := error_msg.ERR_P_OUTLET_CREATE_1;
      RETURN;
    END IF;

  END IF;

  --基本信息
  update inf_agencys
     set agency_code       = c_outlet_code,
         agency_name       = p_outlet_name,
         storetype_id      = p_outlet_stype,
         agency_type       = p_outlet_type,
         bank_id           = p_outlet_bankid,
         bank_account      = p_outlet_bankacc,
         telephone         = p_outlet_phone,
         contact_person    = p_outlet_person,
         address           = p_outlet_address,
         org_code          = p_Institution_code,
         area_code         = p_area_code,
         market_manager_id = p_outlet_admin
   where agency_code = p_outlet_code_o;

  --扩展信息
  update inf_agency_ext
     set agency_code = c_outlet_code,
         personal_id = p_outlet_pid,
         contract_no = p_outlet_cno,
         glatlng_n   = p_outlet_g_n,
         glatlng_e   = p_outlet_g_e
   where agency_code = p_outlet_code_o;

  IF p_outlet_code_o <> p_outlet_code_o THEN
    --更新账户
    update acc_agency_account
       set agency_code = c_outlet_code
     where agency_code = p_outlet_code_o;

    --变更资金结算率
    update game_agency_comm_rate
       set agency_code = c_outlet_code
     where agency_code = p_outlet_code_o;
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END p_outlet_modify;
