CREATE OR REPLACE PROCEDURE p_om_agency_status_ctrl
/****************************************************************/
  ------------------- 适用于控制销售站状态 --------------------
  -------add by dzg 2014-9-19 由于监控延迟可能导致状态更新问题
  -------修订前台对关键对象操作采用存储过程，以便统一入口校验
  -------modify by dzg 2014.10.20 修改支持本地化
  /*************************************************************/
(

 --------------输入----------------
 p_agengcycode  IN NUMBER, --销售站编号
 p_agencystatus IN NUMBER, --销售站状态

 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 ) IS

  v_temp NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);



  /*-------检查状态有效-----*/
  IF(p_agencystatus < eagency_status.enabled or p_agencystatus >eagency_status.cancelled) THEN
     c_errorcode := 1;
     --c_errormesg := '无效的状态值';
     c_errormesg := error_msg.MSG0006;
    RETURN;
  END IF;

  /*-------检查是否存在------*/

  v_temp := 0;

  SELECT COUNT(inf_agencys.agency_code)
    INTO v_temp
    FROM inf_agencys
   WHERE inf_agencys.agency_code = p_agengcycode;

  IF v_temp <= 0 THEN
    c_errorcode := 1;
    --c_errormesg := '无效的销售站';
    c_errormesg := error_msg.MSG0023;
    RETURN;
  END IF;

  /*-------检查当前状态是否一致,如果清退则提示已经清退-----*/
  v_temp := 0;

  SELECT inf_agencys.status
    INTO v_temp
    FROM inf_agencys
   WHERE inf_agencys.agency_code = p_agengcycode;

  IF v_temp = p_agencystatus THEN
    c_errorcode := 1;
    --c_errormesg := '数据库中已经是当前状态';
    c_errormesg := error_msg.MSG0007;
    RETURN;
  END IF;

  IF v_temp = eagency_status.cancelled THEN
    c_errorcode := 1;
    --c_errormesg := '站点已经清退不能执行当前操作';
    c_errormesg := error_msg.MSG0008;
    RETURN;
  END IF;

  /*-----------    更新数据  -----------------*/

  UPDATE inf_agencys
     SET status = p_agencystatus
   WHERE agency_code = p_agengcycode;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    --c_errormesg := '数据库异常' || SQLERRM;
    c_errormesg := error_msg.MSG0004 || SQLERRM;

END;
