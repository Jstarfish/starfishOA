CREATE OR REPLACE PROCEDURE p_outlet_withdraw_app
/****************************************************************/
  ------------------- 适用于站点提现申请-------------------
  ----站点提现
  ----add by dzg: 2015-9-24
  ----业务流程：插入申请表
  --- POS:outletCode  amount  admin （市场管理员）
  --- OMS 参数相同
  --- modify by dzg 2015-10-22 增加验证站点密码
  --- 修改逻辑判断错误：账户金额<申请金额不能提现
  /*************************************************************/
(
 --------------输入----------------
 
 p_outlet_code      IN STRING, --站点编码
 p_password         IN STRING, --站点密码
 p_amount           IN NUMBER, --提现金额
 p_admin_id         IN NUMBER, --市场管理人员

 
 ---------出口参数---------
 c_flow_code   OUT STRING,     --申请流水
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

  --用户不存在或者无效
  SELECT count(u.admin_id)
    INTO v_count_temp
    FROM adm_info u
   WHERE u.admin_id = p_admin_id
     And u.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.ERR_P_OUTLET_TOPUP_2;
    RETURN;
  END IF;


  --检测金额
  v_count_temp := 0;
  SELECT nvl(u.account_balance,0)
    INTO v_count_temp
    FROM acc_agency_account u
   WHERE u.agency_code=p_outlet_code;

  IF v_count_temp < p_amount THEN
    c_errorcode := 3;
    c_errormesg := error_msg.err_p_outlet_withdraw_app_1;
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
    c_errorcode := 4;
    c_errormesg := error_msg.err_p_outlet_withdraw_con_3;
    RETURN;
  END IF;

  --插入基本信息
  
  select a.agency_name, b.acc_no
    INTO v_outlet_name, v_outlet_accno
    from inf_agencys a
    left join acc_agency_account b
      on a.agency_code = b.agency_code
      where a.agency_code =p_outlet_code;

  --先生成编码
  c_flow_code := f_get_fund_charge_cash_seq();
  
  insert into fund_withdraw
  (fund_no,
   account_type,
   ao_code,
   ao_name,
   acc_no,
   apply_amount,
   apply_admin,
   apply_date,
   market_admin,
   apply_status,
   apply_memo)
values
  (c_flow_code,
   eaccount_type.agency,
   p_outlet_code,
   v_outlet_name,
   v_outlet_accno,
   p_amount,
   p_admin_id,
   sysdate,
   p_admin_id,
   eapply_status.applyed,
   '');

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END p_outlet_withdraw_app;
/
