CREATE OR REPLACE PROCEDURE p_admin_create
/****************************************************************/
  ------------------- 适用创建系统用户-------------------
  ----创建系统用户
  ----add by dzg: 2015-9-17
  ----业务流程：先插入主表，如果是市场管理员，则插入市场管理员账户
  ----modify by dzg 2015-9-24 发现少操作一张表 inf_market_admin
  /*************************************************************/
(
 --------------输入----------------
 p_admin_realname    IN STRING, --真实姓名
 p_admin_loginid     IN STRING, --登录名
 p_admin_password    IN STRING, --默认密码
 p_admin_gender      IN NUMBER, --性别
 p_admin_insticode   IN STRING, --所属部门编码
 p_admin_birthday    IN Date, --出生日期
 p_admin_mobilephone IN STRING, --移动电话
 p_admin_officephone IN STRING, --办公电话
 p_admin_homephone   IN STRING, --家庭电话
 p_admin_email       IN STRING, --电子邮件
 p_admin_address     IN STRING, --家庭住址
 p_admin_remark      IN STRING, --备注信息
 p_admin_ismarketm   IN NUMBER, --是否市场管理员
 
 ---------出口参数---------
 c_admin_id  OUT NUMBER, -- 登陆用户ID
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 
 ) IS

  v_count_temp NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --真实姓名不能为空
  IF ((p_admin_realname IS NULL) OR length(p_admin_realname) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_ADMIN_CREATE_1;
    RETURN;
  END IF;

  --登陆名称不能为空
  IF ((p_admin_loginid IS NULL) OR length(p_admin_loginid) <= 0) THEN
    c_errorcode := 2;
    c_errormesg := error_msg.ERR_P_ADMIN_CREATE_2;
    RETURN;
  END IF;

  --登陆名称不能重复
  v_count_temp := 0;
  SELECT count(o.admin_id)
    INTO v_count_temp
    FROM adm_info o
   WHERE o.admin_login = p_admin_loginid
     AND o.admin_status <> eadmin_status.DELETED;

  IF v_count_temp > 0 THEN
    c_errorcode := 3;
    c_errormesg := error_msg.ERR_P_ADMIN_CREATE_3;
    RETURN;
  END IF;

  /*----------- 数据校验   -----------------*/
  --插入基本信息
  v_count_temp := f_get_adm_id_seq();

  insert into adm_info
    (admin_id,
     admin_realname,
     admin_login,
     admin_password,
     admin_gender,
     admin_email,
     admin_birthday,
     admin_tel,
     admin_mobile,
     admin_phone,
     admin_org,
     admin_address,
     admin_remark,
     admin_status,
     admin_create_time,
     create_admin_id,
     is_collecter)
  values
    (v_count_temp,
     p_admin_realname,
     p_admin_loginid,
     p_admin_password,
     P_admin_gender,
     P_admin_email,
     P_admin_birthday,
     p_admin_officephone,
     p_admin_mobilephone,
     p_admin_homephone,
     p_admin_insticode,
     p_admin_address,
     p_admin_remark,
     eadmin_status.AVAILIBLE,
     sysdate,
     0,
     p_admin_ismarketm);

  --循环的插入管理员信息，并更新权限信息表
  --先清理原有数据

  IF p_admin_ismarketm = eboolean.yesorenabled THEN
  
    ---插入市场管理员账户
    insert into acc_mm_account
      (market_admin,
       acc_type,
       acc_name,
       acc_status,
       acc_no,
       credit_limit,
       account_balance,
       check_code)
    values
      (v_count_temp,
       eacc_type.main_account,
       p_admin_realname,
       eacc_status.available,
       f_get_acc_no(v_count_temp, 'MM'),
       0,
       0,
       '-');
    --插入市场管理账户
    insert into inf_market_admin
      (market_admin, trans_pass, credit_by_tran, max_amount_ticketss)
    values
      (v_count_temp,
       p_admin_password,
       0,
       0);
  
  END IF;
  c_admin_id := v_count_temp;
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END p_admin_create;
/
