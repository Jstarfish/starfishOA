CREATE OR REPLACE PROCEDURE p_agency_quit
/*****************************************************************/
  ----------- 站点清退 ---------------
  ----------- add by Chen Zhen @ 2016-11-17
  ------------modify by kwx @ 2016-11-25 更新销售站状态
  ----------- 更新余额为0，状态为清退，插入清退流水，删除终端，删除销售员

  /*****************************************************************/
(p_agency_code IN CHAR, --站点编码
 p_admin_id    IN NUMBER, --缴款操作人

 c_agency_curr_amount OUT NUMBER, --站点当前余额
 c_errorcode          OUT NUMBER, --业务错误编码
 c_errormesg          OUT STRING --错误信息描述
 ) IS

  v_agency_info    inf_agencys%rowtype;
  v_agency_account acc_agency_account%rowtype;

  v_his_code  CHAR(10);
  v_balance   number(28); -- 账户余额
  v_f_balance number(28); -- 冻结账户余额

BEGIN

  /*-----------    初始化数据  -----------------*/

  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  --- 获取销售站当前余额
  begin
    SELECT *
      INTO v_agency_info
      FROM inf_agencys
     WHERE agency_code = p_agency_code;
  exception
    when no_data_found then
      c_errorcode := 1;
      c_errormesg := error_msg.err_p_teller_create_1;
  end;

  select *
    into v_agency_account
    from acc_agency_account
   where agency_code = p_agency_code
     and ACC_TYPE = eacc_type.main_account;

  /*----------- 插入数据   -----------------*/
  --插入流水
  insert into inf_agency_delete
    (delete_no,
     agency_code,
     agency_name,
     available_credit,
     credit_limit,
     oper_time,
     oper_admin)
  VALUES
    (f_get_game_his_code_seq,
     p_agency_code,
     v_agency_info.agency_name,
     v_agency_account.account_balance,
     v_agency_account.credit_limit,
     SYSDATE,
     p_admin_id)
  returning delete_no into v_his_code;

  -- 更新余额，状态
  p_agency_fund_change(p_agency_code,
                       eflow_type.withdraw,
                       v_agency_account.account_balance,
                       0,
                       v_his_code,
                       v_balance,
                       v_f_balance);
  --BUG 182 modify by kwx @ 2016-11-25 更新销售站状态
  update inf_agencys
     set status=eagency_status.cancelled
   where agency_code = p_agency_code;
   
  -- 停用账户
  update ACC_AGENCY_ACCOUNT
     set ACC_STATUS = eACC_STATUS.stoped
   where agency_code = p_agency_code
     and ACC_TYPE = eacc_type.main_account;

  -- 停用终端机
  UPDATE saler_terminal
     SET status = eterminal_status.cancelled
   WHERE agency_code = p_agency_code;

  -- 停用销售员
  UPDATE inf_tellers
     SET status = eteller_status.deleted
   WHERE agency_code = p_agency_code;

  c_agency_curr_amount := v_agency_account.account_balance;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.err_common_1 || SQLERRM;

END;
