begin
   dbms_scheduler.drop_job('job_refresh_day');
   dbms_scheduler.drop_schedule('schu_every_day');
   dbms_scheduler.drop_program('prog_his_day');

   dbms_scheduler.drop_job('job_monitor');
   dbms_scheduler.drop_schedule('schu_monitor');
   dbms_scheduler.drop_program('prog_monitor');

   /************  每五分钟执行 ************/
   dbms_scheduler.create_schedule (
     schedule_name     => 'schu_monitor',
     start_date        => to_timestamp_tz(to_char(trunc(sysdate,'hh24') + (trunc(to_number(to_char(sysdate,'mi'))/5) + 1) * 5/24/60, 'yyyy-mm-dd hh:mi:ss am') || ' +7:00', 'yyyy-mm-dd hh:mi:ss am tzh:tzm'),
     repeat_interval   => 'freq = minutely;interval=5;bysecond=0;',
     comments          => '生成监控报表数据');

   dbms_scheduler.create_program (
      program_name           => 'prog_monitor',
      program_action         => 'p_time_gen_by_hour',
      program_type           => 'stored_procedure',
      comments               => 'Hour generate the statictics',
      enabled                => true);

   dbms_scheduler.create_program (
      program_name           => 'prog_refresh_negative_issue',
      program_action         => 'p_sys_update_negative_issue',
      program_type           => 'stored_procedure',
      comments               => 'update the negative issue number in table -- adj_game_his,iss_game_pool_his',
      enabled                => true);

   dbms_scheduler.create_job (
      job_name           =>  'job_monitor',
      program_name       =>  'prog_monitor',
      schedule_name      =>  'schu_monitor',
      enabled            =>  true);

   dbms_scheduler.create_job (
      job_name           =>  'job_refresh_negative_issue',
      program_name       =>  'prog_refresh_negative_issue',
      schedule_name      =>  'schu_monitor',
      enabled            =>  true);

end;
/
