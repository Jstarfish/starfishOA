CREATE OR REPLACE PROCEDURE p_outlet_withdraw_con
/****************************************************************/
  ------------------- 适用于站点提现确认-------------------
  ----站点提现确认
  ----add by dzg: 2015-9-24
  --- POS:outletCode  amount  admin （市场管理员）
  --- OMS 验证一些密码后则更新状态
  --- 状态值 修订最后一步枚举是提现确认
  /*************************************************************/
(
 --------------输入----------------

 p_outlet_code      IN STRING, --站点编码
 p_password         IN STRING, --站点密码
 p_app_flow         IN STRING, --申请单编号
 p_admin_id         IN NUMBER, --市场管理人员


 ---------出口参数---------
 c_errorcode   OUT NUMBER,     --错误编码
 c_errormesg   OUT STRING      --错误原因

 ) IS

  v_count_temp     NUMBER := 0; --临时变量
  v_outlet_name    varchar2(500) := ''; --站点名称
  v_outlet_accno   varchar2(50) := ''; --站点账户编号

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp  := 0;

  /*----------- 数据校验   -----------------*/
  --编码不能为空
  IF ((p_outlet_code IS NULL) OR length(p_outlet_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_OUTLET_TOPUP_1;
    RETURN;
  END IF;

   --编码不能为空
  IF ((p_app_flow IS NULL) OR length(p_app_flow) <= 0) THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_outlet_withdraw_con_1;
    RETURN;
  END IF;

  --用户不存在或者无效
  SELECT count(u.admin_id)
    INTO v_count_temp
    FROM adm_info u
   WHERE u.admin_id = p_admin_id
     And u.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 3;
    c_errormesg := error_msg.ERR_P_OUTLET_TOPUP_2;
    RETURN;
  END IF;


  --检测申请单检测
  v_count_temp := 0;
  SELECT count(u.fund_no)
    INTO v_count_temp
    FROM fund_withdraw u
   WHERE u.fund_no=p_app_flow
   And u.apply_status = eapply_status.audited ;

  IF v_count_temp <= 0 THEN
    c_errorcode := 4;
    c_errormesg := error_msg.err_p_outlet_withdraw_con_2;
    RETURN;
  END IF;

  --检测站点或密码
  v_count_temp := 0;
  SELECT count(*)
    INTO v_count_temp
    FROM inf_agencys u
   WHERE u.agency_code=p_outlet_code
   And u.login_pass = p_password ;

  IF v_count_temp <= 0 THEN
    c_errorcode := 5;
    c_errormesg := error_msg.err_p_outlet_withdraw_con_3;
    RETURN;
  END IF;


  --插入基本信息
   update fund_withdraw
      set apply_status = eapply_status.withdraw
    where fund_no = p_app_flow;


  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
