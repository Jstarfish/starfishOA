CREATE OR REPLACE PROCEDURE p_mm_fund_repay
/****************************************************************/
  ------------------- 适用于市场专员还款-------------------
  ----市场专员还款
  ----add by dzg: 2015-9-28
  ----业务流程：插入申请表，插入流水，更新账户
  ----modify by dzg:2015-10-26 修改表结构导致存储过程异常
  /*************************************************************/
(
 --------------输入----------------

 p_amount   IN NUMBER, --充值金额
 p_mm_id    IN NUMBER, --市场管理人员
 p_admin_id IN NUMBER, --当前操作人员
 p_remark   in varchar2, -- 注释。只有在负值还款时使用

 ---------出口参数---------
 c_flow_code  OUT STRING, --申请流水
 c_bef_amount OUT NUMBER, --还款前金额
 c_aft_amount OUT NUMBER, --还款后金额
 c_errorcode  OUT NUMBER, --错误编码
 c_errormesg  OUT STRING --错误原因

 ) IS

  v_count_temp NUMBER := 0; --临时变量
  v_flow_code  varchar2(50) := ''; --临时变量流水
  v_acc_code   varchar2(50) := ''; --账户编号

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --编码不能为空
  IF ((p_mm_id IS NULL) OR (p_mm_id <= 0)) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_mm_fund_repay_1;
    RETURN;
  END IF;

  --用户不存在或者无效
  SELECT count(u.admin_id)
    INTO v_count_temp
    FROM adm_info u
   WHERE u.admin_id = p_mm_id
     And u.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_mm_fund_repay_2;
    RETURN;
  END IF;

  --当前操作人不能为空
  IF (p_admin_id IS NULL) THEN
    c_errorcode := 3;
    c_errormesg := error_msg.err_p_mm_fund_repay_3;
    RETURN;
  END IF;

  --操作人无效
  v_count_temp := 0;
  SELECT count(u.admin_id)
    INTO v_count_temp
    FROM adm_info u
   WHERE u.admin_id = p_mm_id
     And u.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 4;
    c_errormesg := error_msg.err_p_mm_fund_repay_4;
    RETURN;
  END IF;

  --金额无效
  IF ((p_amount IS NULL) OR (p_amount = 0)) THEN
    c_errorcode := 5;
    c_errormesg := error_msg.err_p_mm_fund_repay_5;
    RETURN;
  END IF;

  -- 获取初始化信息
  select acc.acc_no, acc.account_balance
    into v_acc_code, c_bef_amount
    from acc_mm_account acc
   where acc.market_admin = p_mm_id;

  --插入基本信息
  v_flow_code := f_get_fund_mm_cash_repay_seq();

  insert into fund_mm_cash_repay
    (mcr_no, market_admin, repay_amount, repay_time, repay_admin, remark)
  values
    (v_flow_code, p_mm_id, p_amount, sysdate, p_admin_id, p_remark);

  p_mm_fund_change(p_mm_id, eflow_type.fund_return, p_amount, v_flow_code, c_aft_amount);

  c_flow_code  := v_flow_code;
  c_bef_amount := c_bef_amount - p_amount;
  c_aft_amount := c_bef_amount;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END p_mm_fund_repay;
