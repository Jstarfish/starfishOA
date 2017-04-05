CREATE OR REPLACE PROCEDURE p_om_agbroadcast_create
/****************************************************************/
  ------------------- 适用于创建站点通知-------------------
  ----add by dzg: 2014-07-15 创建站点通知
  ----业务流程：先插入主表，依次对象字表中
  ---- modify by dzg 2014.10.20 修改支持本地化
  ---- modify by dzg 2015.03.02  修改异常退出是赋值输出为0
  /*************************************************************/
(
 --------------输入----------------
 p_resv_objs         IN STRING, --接收对象,格式如中国（0），北京（10），朝阳（1001），站点A(1001000002)
 p_resv_obj_ids      IN STRING, --接收对象ID列表,使用“,”分割的多个字符串
 p_sender_id         IN NUMBER, --发送人ID
 p_broadcast_title   IN STRING, --通知标题
 p_broadcast_content IN STRING, --通知内容
 p_send_time         IN DATE, --发送时间，类似于生效时间
 ---------出口参数---------
 c_errorcode    OUT NUMBER, --错误编码
 c_errormesg    OUT STRING, --错误原因
 c_broadcast_id OUT NUMBER --通知编号
 
 ) IS

  v_broadcast_id   NUMBER := 0; --临时变量
  v_count_temp     NUMBER := 0; --临时变量
  v_is_con_country NUMBER := 0; --临时变量(是否包含全国)

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_broadcast_id := 0;
  v_count_temp   := 0;
  /*----------- 数据校验   -----------------*/

  /*----------- 检测名称重复 ---------------*/

  IF ( (p_resv_obj_ids is null) 
    OR (p_broadcast_title is null) 
    OR length(p_resv_obj_ids) <= 0 
    OR length(p_broadcast_title) <= 0) THEN
    c_broadcast_id := 0;
    c_errorcode := 1;
    --c_errormesg := '接收对象或标题不能为空';
    c_errormesg := error_msg.MSG0003;
    RETURN;
  END IF;

  /*----------- 循环插入数据  -----------------*/

  --插入公告
  v_broadcast_id := f_get_sys_noticeid_seq();

  INSERT INTO msg_agency_brocast
    (notice_id,
     cast_string,
     send_admin,
     title,
     content,
     create_time,
     send_time)
  VALUES
    (v_broadcast_id,
     p_resv_objs,
     p_sender_id,
     p_broadcast_title,
     p_broadcast_content,
     SYSDATE,
     p_send_time);

  --循环更新子对象

  DELETE FROM msg_agency_brocast_detail
   WHERE msg_agency_brocast_detail.notice_id = v_broadcast_id;

  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_resv_obj_ids))) LOOP
    dbms_output.put_line(i.column_value);
    v_count_temp := f_get_sys_noticeid_seq();
    IF length(i.column_value) > 0 THEN
    
      INSERT INTO msg_agency_brocast_detail
        (detail_id, notice_id, cast_code)
      VALUES
        (v_count_temp, v_broadcast_id, to_number(i.column_value));
    
    END IF;
  END LOOP;

  c_broadcast_id := v_broadcast_id;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.MSG0004 || SQLERRM;
    c_broadcast_id := 0;
  
END p_om_agbroadcast_create;
/
