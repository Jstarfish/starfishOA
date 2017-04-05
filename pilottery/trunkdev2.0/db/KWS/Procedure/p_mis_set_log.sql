CREATE OR REPLACE PROCEDURE p_mis_set_log
/***************************************************************
   ------------------- 记录日志 -------------------
   ************************************************************/
(
 --------------输入----------------
 p_log_type in number, -- 日志类型
 p_desc IN varchar2    -- 描述
 ) IS

   -- 同步数据
   v_param     VARCHAR2(200);
   v_ip        VARCHAR2(200);
   v_user      VARCHAR2(200);
   v_pass      VARCHAR2(200);
   v_url       VARCHAR2(200);
   v_c_errorcode NUMBER(10);
   v_c_errormesg VARCHAR2(1000);


   v_log_id    number(28);
   v_log_log_time varchar2(50);

   v_log_desc  varchar2(4000);

BEGIN

   v_log_desc := p_desc;

   -- 本地化
   v_log_desc := replace(v_log_desc, '中奖明细数据入库', 'insert the winning data to DB');
   v_log_desc := replace(v_log_desc, '开始日结', 'Daily Settlement Started');
   v_log_desc := replace(v_log_desc, '日结任务', 'Daily Settlement Job');
   v_log_desc := replace(v_log_desc, '调用', 'Call');
   v_log_desc := replace(v_log_desc, '期结', 'End-of-Issue');
   v_log_desc := replace(v_log_desc, '日结', 'Daily Settlement');
   v_log_desc := replace(v_log_desc, '执行时长', 'Duration');
   v_log_desc := replace(v_log_desc, '任务', 'Task');
   v_log_desc := replace(v_log_desc, '成功', 'Success');
   v_log_desc := replace(v_log_desc, '失败原因', 'Fail');
   v_log_desc := replace(v_log_desc, '失败', 'Fail');
   v_log_desc := replace(v_log_desc, '秒', 'second');
   v_log_desc := replace(v_log_desc, '停止在步骤', 'Stop at the step of ');


   INSERT INTO SYS_INTERNAL_LOG
      (LOG_ID,LOG_TYPE,LOG_DATE,LOG_DESC)
   VALUES
      (seq_his_logid.nextval, p_log_type, current_timestamp, v_log_desc)
   return LOG_ID, to_char(current_timestamp,'yyyy-mm-dd hh24:mi:ss.ff') into v_log_id, v_log_log_time;

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
END;
