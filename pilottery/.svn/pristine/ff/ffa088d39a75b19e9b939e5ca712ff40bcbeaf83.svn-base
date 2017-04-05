CREATE OR REPLACE PROCEDURE p_om_terminal_modify
/***************************************************************
  ------------------- 修改terminal -------------------
  ---------create by dzg  2014-9-24 为了减少前端验证采用存储过程
  ---------date 2014-10-23 居然发现该存储过程在svn库中消失了。重新恢复并加注本地化

  ---------migrate by Chen Zhen @ 2016-04-07 KPW 2.0 版本移植
  ************************************************************/
(
 --------------输入----------------
 p_term_code     IN char, --终端编码
 p_mac_address   IN STRING, --终端MAC
 p_unique_code   IN STRING, --唯一标识码
 p_terminal_type IN NUMBER, --终端机型号

 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因

 ) IS

  v_count NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据   ------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count := 0;

  /*-------检测终端是否有效性-------*/
  SELECT COUNT(saler_terminal.terminal_code)
    INTO v_count
    FROM saler_terminal
   WHERE saler_terminal.terminal_code = p_term_code
     AND saler_terminal.status != eterminal_status.cancelled;

  IF v_count < 0 THEN
    c_errorcode := 1;
    c_errormesg := error_msg.MSG0053;
    RETURN;
  END IF;

  /*-------检测MAC有效性是否重复-------*/
  v_count := 0;
  SELECT COUNT(saler_terminal.terminal_code)
    INTO v_count
    FROM saler_terminal
   WHERE upper(mac_address) = upper(p_mac_address)
     AND saler_terminal.terminal_code != p_term_code
     AND saler_terminal.status != eterminal_status.cancelled;

  IF v_count > 0 THEN
    c_errorcode := 1;
    c_errormesg := error_msg.MSG0050;
    RETURN;
  END IF;

  /*-------检测MAC是否有效-------*/
  select count(*)
    into v_count
    from dual
   where regexp_like(upper(p_mac_address), '[0-9||A-Z][0-9||A-Z]:[0-9||A-Z][0-9||A-Z]:[0-9||A-Z][0-9||A-Z]:[0-9||A-Z][0-9||A-Z]:[0-9||A-Z][0-9||A-Z]:[0-9||A-Z][0-9||A-Z]');

  IF v_count = 0 THEN
    c_errorcode := 1;
    --c_errormesg := 'MAC地址不是有效格式';
    c_errormesg := error_msg.msg0048;
    RETURN;
  END IF;

  /*-------更新数据------*/
  UPDATE saler_terminal
     SET unique_code   = p_unique_code,
         term_type_id  = p_terminal_type,
         mac_address   = upper(p_mac_address)
   WHERE terminal_code = p_term_code;

  --提交
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.MSG0004 || SQLERRM;

END;
