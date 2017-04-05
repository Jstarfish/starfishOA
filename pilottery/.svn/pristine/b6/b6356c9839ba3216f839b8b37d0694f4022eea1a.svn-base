CREATE OR REPLACE PROCEDURE p_admin_modify
/****************************************************************/
  ------------------- 适用修改系统用户-------------------
  ----创建系统用户
  ----add by dzg: 2015-11-10
  ----业务流程：修改用户
  /*************************************************************/
(
 --------------输入----------------
 p_admin_id          IN NUMBER, --ID
 p_admin_realname    IN STRING, --真实姓名
 p_admin_loginid     IN STRING, --登录名
 p_admin_gender      IN NUMBER, --性别
 p_admin_insticode   IN STRING, --所属部门编码
 p_admin_birthday    IN Date, --出生日期
 p_admin_mobilephone IN STRING, --移动电话
 p_admin_officephone IN STRING, --办公电话
 p_admin_homephone   IN STRING, --家庭电话
 p_admin_email       IN STRING, --电子邮件
 p_admin_address     IN STRING, --家庭住址
 p_admin_remark      IN STRING, --备注信息
 p_admin_defaultpwd  IN STRING, --默认密码
 p_admin_ismarketm   IN NUMBER, --是否市场管理员
 
 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 
 ) IS

  v_count_temp NUMBER := 0; --临时变量
  v_temp_str   varchar(100) := ''; --临时变量

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

  --用户已存在
  v_count_temp := 0;
  SELECT count(o.admin_id)
    INTO v_count_temp
    FROM adm_info o
   WHERE o.admin_id = p_admin_id
     AND o.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 3;
    c_errormesg := error_msg.err_p_outlet_topup_2;
    RETURN;
  END IF;

  /*----------- 数据校验   -----------------*/
  --基本信息
  update adm_info
     set admin_realname    = p_admin_realname,
         admin_login       = p_admin_loginid,
         admin_gender      = P_admin_gender,
         admin_email       = P_admin_email,
         admin_birthday    = P_admin_birthday,
         admin_tel         = p_admin_officephone,
         admin_mobile      = p_admin_mobilephone,
         admin_phone       = p_admin_homephone,
         admin_org         = p_admin_insticode,
         admin_address     = p_admin_address,
         admin_remark      = p_admin_remark,
         admin_update_time = sysdate,
         is_collecter      = p_admin_ismarketm
   where admin_id = p_admin_id;

  --循环的插入管理员信息，并更新权限信息表
  --先清理原有数据

  IF p_admin_ismarketm = eboolean.yesorenabled THEN
  
    v_count_temp := 0;
    SELECT count(o.acc_no)
      INTO v_count_temp
      FROM acc_mm_account o
     WHERE o.market_admin = p_admin_id;
  
    IF v_count_temp <= 0 THEN
      --新增
      v_temp_str := f_get_acc_no(p_admin_id, 'MM');
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
        (p_admin_id,
         eacc_type.main_account,
         p_admin_realname,
         eacc_status.available,
         v_temp_str,
         0,
         0,
         '-');
      --插入市场管理账户
      insert into inf_market_admin
        (market_admin, trans_pass, credit_by_tran, max_amount_ticketss)
      values
        (p_admin_id, p_admin_defaultpwd, 0, 0);
    ELSE
      --编辑
      update acc_mm_account
         set acc_mm_account.acc_status = eacc_status.available
       where acc_mm_account.market_admin = p_admin_id;
    
    END IF;
  
  ELSE
    update acc_mm_account
       set acc_mm_account.acc_status = eacc_status.stoped
     where acc_mm_account.market_admin = p_admin_id;
  
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END p_admin_modify;
/
