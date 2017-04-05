CREATE OR REPLACE PROCEDURE p_om_modify_teller_signon
/***************************************************************
  ------------------- 销售员签入终端 -------------------
  ---- modify by dzg 2014.10.20 修改支持本地化
  -------migrate by Chen Zhen @ 2016-04-18

  ************************************************************/
(
 --------------输入----------------
 p_teller_code          IN NUMBER, --销售员id
 p_latest_terminal_code IN NUMBER, --最近签入的销售终端编码
 p_latest_sign_on_time  IN DATE, --最近签入日期时间
 ---------出口参数---------
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述
 ) IS
BEGIN

  -- 初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  -- 更新销售员签入信息
  UPDATE inf_tellers t
     SET t.latest_terminal_code = p_latest_terminal_code,
         t.latest_sign_on_time = p_latest_sign_on_time,
         t.is_online = eboolean.yesorenabled
   WHERE t.teller_code = p_teller_code;

  IF SQL%NOTFOUND THEN
    c_errorcode := 1;
    --c_errormesg := '更新销售员签入信息失败';
    c_errormesg := error_msg.MSG0040;
    RETURN;
  END IF;

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

END;
