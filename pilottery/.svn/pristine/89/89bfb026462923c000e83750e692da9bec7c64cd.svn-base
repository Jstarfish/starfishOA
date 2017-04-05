CREATE OR REPLACE PROCEDURE p_om_modify_teller_signoff
/***************************************************************
  ------------------- 销售员签出终端 -------------------
  ---- modify by dzg 2014.10.20 修改支持本地化
  ************************************************************/
(
 --------------输入----------------
 p_teller_code          IN NUMBER, --销售员id
 p_latest_sign_off_time IN DATE, --最后签出日期时间
 ---------出口参数---------
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述
 ) IS
BEGIN

  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  --更新销售员签入信息
  UPDATE inf_tellers t
     SET t.latest_sign_off_time = p_latest_sign_off_time,
         t.is_online = eboolean.noordisabled
   WHERE t.teller_code = p_teller_code;

  IF SQL%NOTFOUND THEN
    c_errorcode := 1;
    --c_errormesg := '更新销售员签出信息失败';
    c_errormesg := error_msg.MSG0039;
    RETURN;
  END IF;

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

END;
