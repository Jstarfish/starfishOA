CREATE OR REPLACE PROCEDURE p_outlet_bankacc_create
/****************************************************************/
  ------------------- 适用于新建站点银行账户-------------------
  ----add by dzg: 2017-3-24
  /*************************************************************/
(
 --------------输入----------------
 p_outlet_code   IN STRING, --站点编码
 p_acc_type      IN NUMBER, --站点账户类型
 p_currency      IN NUMBER, --币种
 p_bank_acc_no   IN STRING, --银行账号
 p_bank_acc_name IN STRING, --银行账户名
 
 ---------出口参数---------
 
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 
 ) IS

  v_count_temp      NUMBER := 0; --临时变量
  v_acc_no          varchar(100) := ''; --站点账户
  v_digital_acc_seq varchar(100) := ''; --站点账户序号

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/

  --检测站点编码非空
  IF ((p_outlet_code IS NULL) OR length(p_outlet_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_OUTLET_MODIFY_2;
    RETURN;
  END IF;

  --站点无效
  v_count_temp := 0;
  SELECT count(u.agency_code)
    INTO v_count_temp
    FROM inf_agencys u
   WHERE u.agency_code = p_outlet_code;

  IF v_count_temp <= 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_teller_create_1;
    RETURN;
  END IF;

  --账户重复
  v_count_temp := 0;

  select count(*)
    INTO v_count_temp
    from acc_agency_account_digital
   where digital_acc_no = p_bank_acc_no
     and acc_status <> 3;

  IF v_count_temp > 0 THEN
    c_errorcode := 3;
    c_errormesg := error_msg.msg0083;
    RETURN;
  END IF;

  --初始化信息
  select ac.acc_no
    into v_acc_no
    from acc_agency_account ac
   where ac.agency_code = p_outlet_code;

  --生成seq
  v_count_temp := 0;

  select count(*)
    INTO v_count_temp
    from acc_agency_account_digital
   where agency_code = p_outlet_code;

  IF v_count_temp > 0 THEN
  
    select to_number(substr(max(dacc.digital_acc_seq), 10, 3)) + 1
      INTO v_count_temp
      from acc_agency_account_digital dacc
     where dacc.agency_code = p_outlet_code;
  
    v_digital_acc_seq := p_outlet_code || 'D' || lpad(v_count_temp, 3, '0');
  
  ELSE
    v_digital_acc_seq := p_outlet_code || 'D001';
  END IF;

  --基本信息
  insert into acc_agency_account_digital
    (agency_code,
     digital_acc_type,
     acc_status,
     is_default,
     acc_no,
     currency,
     digital_acc_seq,
     digital_acc_no,
     digital_acc_username)
  values
    (p_outlet_code,
     p_acc_type,
     eacc_status.available,
     eboolean.noordisabled,
     v_acc_no,
     p_currency,
     v_digital_acc_seq,
     p_bank_acc_no,
     p_bank_acc_name);

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END p_outlet_bankacc_create;
