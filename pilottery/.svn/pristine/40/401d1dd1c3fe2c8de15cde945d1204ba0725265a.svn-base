CREATE OR REPLACE PROCEDURE p_om_terminal_status_ctrl
/****************************************************************/
  ------------------- 适用于控制终端机状态 --------------------
  -------add by dzg 2014-9-19 由于监控延迟可能导致状态更新问题
  -------修订前台对关键对象操作采用存储过程，以便统一入口校验
  -------modify by dzg 2014.10.20 修改支持本地化

  ---------migrate by Chen Zhen @ 2016-04-07 KPW 2.0 版本移植
  /*************************************************************/
(

 --------------输入----------------
 p_terminalcode   IN char, --终端编号
 p_terminalstatus IN NUMBER, --终端机状态

 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 ) IS

  v_temp NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  /*-------检查状态有效-----*/
  IF (p_terminalstatus < eterminal_status.enabled or
     p_terminalstatus > eterminal_status.cancelled) THEN
    c_errorcode := 1;
    --c_errormesg := '无效的状态值';
    c_errormesg := error_msg.MSG0006;
    RETURN;
  END IF;

  /*-------检查是否存在------*/
  v_temp := 0;

  SELECT COUNT(saler_terminal.terminal_code)
    INTO v_temp
    FROM saler_terminal
   WHERE saler_terminal.terminal_code = p_terminalcode;

  IF v_temp <= 0 THEN
    c_errorcode := 1;
    --c_errormesg := '无效的终端机';
    c_errormesg := error_msg.MSG0053;
    RETURN;
  END IF;

  /*-------检查当前状态是否一致,如果清退则提示已经清退-----*/
  v_temp := 0;

  SELECT saler_terminal.status
    INTO v_temp
    FROM saler_terminal
   WHERE saler_terminal.terminal_code = p_terminalcode;

  IF v_temp = p_terminalstatus THEN
    c_errorcode := 1;
    --c_errormesg := '数据库中已经是当前状态';
    c_errormesg := error_msg.MSG0007;
    RETURN;
  END IF;

  IF v_temp = eterminal_status.cancelled THEN
    c_errorcode := 1;
    --c_errormesg := '终端已退机不能执行当前操作';
    c_errormesg := error_msg.MSG0054;
    RETURN;
  END IF;

  /*-----------    更新数据  -----------------*/

  UPDATE saler_terminal
     SET status = p_terminalstatus
   WHERE terminal_code = p_terminalcode;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    --c_errormesg := '数据库异常' || SQLERRM;
    c_errormesg := error_msg.MSG0004 || SQLERRM;

END;
