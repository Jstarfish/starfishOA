CREATE OR REPLACE PROCEDURE p_om_teller_status_ctrl
/****************************************************************/
  ------------------- 适用于控制销售员状态 --------------------
  -------add by dzg 2014-9-19 由于监控延迟可能导致状态更新问题
  -------修订前台对关键对象操作采用存储过程，以便统一入口校验
  -------modify by dzg 2014.10.20 修改支持本地化

  ---------migrate from Taishan by Chen Zhen @ 2016-03-21

  /*************************************************************/
(

 --------------输入----------------
 p_tellercode   IN NUMBER, --销售员编号
 p_tellerstatus IN NUMBER, --销售员状态

 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 ) IS

  v_temp NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);


   /*-------检查状态有效-----*/
   IF p_tellerstatus not in (eteller_status.enabled, eteller_status.disabled, eteller_status.deleted) THEN
     c_errorcode := 1;
     c_errormesg := error_msg.err_p_teller_status_change_1;                                     -- 无效的状态值
    RETURN;
  END IF;

  /*-------检查是否存在------*/

  v_temp := 0;
  SELECT COUNT(teller_code)
    INTO v_temp
    FROM inf_tellers
   WHERE teller_code = p_tellercode;

  IF v_temp <= 0 THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_teller_status_change_2;                                      -- 销售员不存在
    RETURN;
  END IF;

  /*-----------    更新数据  -----------------*/

  UPDATE inf_tellers
     SET status = p_tellerstatus
   WHERE teller_code = p_tellercode;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg   := error_msg.err_common_1 || SQLERRM;

END;
