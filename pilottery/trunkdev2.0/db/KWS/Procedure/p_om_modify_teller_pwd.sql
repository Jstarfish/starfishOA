CREATE OR REPLACE PROCEDURE p_om_modify_teller_pwd
/***************************************************************
  ------------------- 修改teller口令 -------------------
  ----- modify by dzg 2014.10.20 修改支持本地化
  ************************************************************/
(
 --------------输入----------------
 p_teller_code  IN NUMBER, --销售员code
 p_old_password IN STRING, --旧口令
 p_new_password IN STRING, --新口令
 ---------出口参数---------
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述
 ) IS
  v_pwd VARCHAR2(32);
BEGIN

  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  --获得销售员旧密码
  SELECT t.password
    INTO v_pwd
    FROM inf_tellers t
   WHERE t.teller_code = p_teller_code;

  --如果旧密码不一致
  IF v_pwd <> p_old_password THEN
    c_errorcode := 1;
    --c_errormesg := '不一样的旧密码';
    c_errormesg := error_msg.MSG0037;
    RETURN;
  END IF;

  --修改密码
  UPDATE inf_tellers t
     SET t.password = p_new_password
   WHERE t.teller_code = p_teller_code;

  IF SQL%NOTFOUND THEN
    c_errorcode := 1;
    --c_errormesg := '更新销售员密码失败';
    c_errormesg := error_msg.MSG0038;
    RETURN;
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

END;
