set feedback off

-- 即开票用户定时任务，记录库存值
prompt '正在创建定时任务 。。。。。。'

begin
   --dbms_scheduler.drop_job('job_mview');
   --dbms_scheduler.drop_schedule('schu_every_5mins');
   --dbms_scheduler.drop_program('prog_refresh_mview');

   /*********************************************************************************/
   /************  每日执行 ************/
   dbms_scheduler.create_schedule (
     schedule_name     => 'schu_every_day',
     start_date        => to_timestamp_tz(to_char(trunc(sysdate),'yyyy-mm-dd') || ' 12:01:00 am +7:00', 'yyyy-mm-dd hh:mi:ss am tzh:tzm'),
     repeat_interval   => 'freq = DAILY;byhour=0;byminute=0;bysecond=0;',
     comments          => '每天0点，需要执行的程序');

   dbms_scheduler.create_program (
      program_name           => 'prog_his_day',
      program_action         => 'p_his_gen_by_day',
      program_type           => 'stored_procedure',
      comments               => 'Daily generate the statictics of all lotteries',
      enabled                => true);

   dbms_scheduler.create_job (
      job_name           =>  'job_refresh_day',
      program_name       =>  'prog_his_day',
      schedule_name      =>  'schu_every_day',
      enabled            =>  true);

   /*********************************************************************************/
   /************  每五分钟执行 ************/
   dbms_scheduler.create_schedule (
     schedule_name     => 'schu_monitor',
     start_date        => to_timestamp_tz(to_char(trunc(sysdate,'hh24') + (trunc(to_number(to_char(sysdate,'mi'))/5) + 1) * 5/24/60, 'yyyy-mm-dd hh:mi:ss am') || ' +7:00', 'yyyy-mm-dd hh:mi:ss am tzh:tzm'),
     repeat_interval   => 'freq = minutely;interval=5;bysecond=0;',
     comments          => '生成监控报表数据');

   dbms_scheduler.create_program (
      program_name           => 'prog_monitor',
      program_action         => 'p_his_gen_by_hour',
      program_type           => 'stored_procedure',
      comments               => 'Hour generate the statictics',
      enabled                => true);

   dbms_scheduler.create_job (
      job_name           =>  'job_monitor',
      program_name       =>  'prog_monitor',
      schedule_name      =>  'schu_monitor',
      enabled            =>  true);

end;
/

exit;
