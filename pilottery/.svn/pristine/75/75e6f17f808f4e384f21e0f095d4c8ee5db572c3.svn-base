CREATE OR REPLACE PROCEDURE p_mis_set_day_close
/***************************************************************
   ------------------- 设置日结标志 -------------------
   ************************************************************/
(
 --------------输入----------------
 p_settle_day IN DATE, --日结日期
 ---------出口参数---------
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述
 ) IS
   v_now_settle_id NUMBER(10);
   v_sql    VARCHAR2(1000);

   v_desc varchar2(1000);
   v_rec_date date;

BEGIN
   --初始化数据
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   INSERT INTO his_day_settle
      (settle_id, opt_date, settle_date, sell_seq, cancel_seq, pay_seq, win_seq)
   VALUES
      (f_get_his_settle_seq, SYSDATE, p_settle_day, f_get_his_sell_seq, f_get_his_cancel_seq, f_get_his_pay_seq, f_get_his_win_seq)
   RETURNING settle_id INTO v_now_settle_id;
   COMMIT;

   -- 拼接SQL，调用存储过程运行
   v_sql := 'begin p_mis_dss_run('||to_char(v_now_settle_id)||'); p_time_gen_by_day; end;';

   -- 开启job任务
   v_desc := '调用 [日结任务]';
   p_mis_set_log(1,'日结-----] '||v_desc||'.......');
   v_rec_date := sysdate;
   dbms_scheduler.create_job(job_name   => 'JOB_MIS_DAY_SETTLE_'||to_char(p_settle_day,'yyyymmdd'),
                             job_type   => 'PLSQL_BLOCK',
--                             job_class  => 'MIS_JOB_CLASS',
                             job_action => v_sql,
                             enabled    => TRUE);
   


   p_mis_set_log(1,'日结-----] '||v_desc||'成功. 执行时长: [ '||trunc((sysdate-v_rec_date)*24*60*60)||'秒 ]');

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);
      if v_desc is not null then
         p_mis_set_log(1,'日结-----] '||v_desc||'失败. 执行时长: [ '||trunc((sysdate-v_rec_date)*24*60*60)||'秒 ] 失败原因: '||sqlerrm);
      end if;

END;