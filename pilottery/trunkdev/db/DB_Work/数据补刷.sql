set serveroutput on
declare
   v_start_time date; -- 统计开始时间
   v_end_time   date; -- 统计结束时间
   v_now_seq    number(10); -- 当前的序列号

   v_step_minutes number(10); -- 统计间隔时间（分钟）

   v_now_time date;

begin
   delete from his_sale_hour;
   delete from HIS_SALE_HOUR_AGENCY;
dbms_output.enable(100000000);
   for hour24 in 1 .. 20*12+trunc(15/5) loop
      v_step_minutes := 5;

      v_now_time := to_date('2015-11-20 ' || lpad(trunc((hour24 - 1) * v_step_minutes / 60), 2,'0') ||':' || lpad(mod((hour24 - 1) * v_step_minutes, 60),2,'0') ||':00','yyyy-mm-dd hh24:mi:ss');

      --dbms_output.put_line(to_char(v_now_time,'yyyy-mm-dd hh24:mi:ss'));

   -- 计算统计开始时间和结束时间
   v_end_time := v_now_time;
   v_start_time := v_now_time - v_step_minutes / 24 / 60;
   v_now_seq := to_number(to_char(v_end_time, 'hh24')) * 60 / v_step_minutes + trunc(to_number(to_char(v_end_time, 'mi')) / v_step_minutes);

   -- 按小时统计销量
   insert into his_sale_hour
      (calc_date, calc_time, plan_code, org_code, sale_amount, cancel_amount, pay_amount,day_sale_amount,day_cancel_amount,day_pay_amount)
   with time_con as
    (select v_start_time s_time,
            v_end_time e_time,
            trunc(sysdate) this_day
       from dual),
   sale_stat as
    (select plan_code, org_code, sum(sale_amount) sale_amount
       from flow_sale, time_con
      where sale_time >= s_time
        and sale_time < e_time
      group by plan_code, org_code),
   cancel_stat as
    (select plan_code, org_code, sum(sale_amount) cancel_amount
       from flow_cancel, time_con
      where cancel_time >= s_time
        and cancel_time < e_time
      group by plan_code, org_code),
   pay_detail as
    (select plan_code,
            f_get_flow_pay_org(pay_flow) org_code,
            pay_amount
       from flow_pay, time_con
      where pay_time >= s_time
        and pay_time < e_time),
   pay_stat as
    (select plan_code, org_code, sum(pay_amount) pay_amount
       from pay_detail
      group by plan_code, org_code),
   day_sale_stat as
    (select plan_code, org_code, sum(sale_amount) day_sale_amount
       from flow_sale, time_con
      where sale_time >= this_day
        and sale_time < e_time
      group by plan_code, org_code),
   day_cancel_stat as
    (select plan_code, org_code, sum(sale_amount) day_cancel_amount
       from flow_cancel, time_con
      where cancel_time >= this_day
        and cancel_time < e_time
      group by plan_code, org_code),
   day_pay_detail as
    (select plan_code,
            f_get_flow_pay_org(pay_flow) org_code,
            pay_amount
       from flow_pay, time_con
      where pay_time >= this_day
        and pay_time < e_time),
   day_pay_stat as
    (select plan_code, org_code, sum(pay_amount) day_pay_amount
       from day_pay_detail
      group by plan_code, org_code),
   hour_detail as
     (select plan_code, org_code, sale_amount, 0 as cancel_amount, 0 as pay_amount, 0 as day_sale_amount, 0 as day_cancel_amount, 0 as day_pay_amount
        from sale_stat
      union all
      select plan_code, org_code, 0 as sale_amount, cancel_amount, 0 as pay_amount, 0 as day_sale_amount, 0 as day_cancel_amount, 0 as day_pay_amount
        from cancel_stat
      union all
      select plan_code, org_code, 0 as sale_amount, 0 as cancel_amount, pay_amount, 0 as day_sale_amount, 0 as day_cancel_amount, 0 as day_pay_amount
        from pay_stat
      union all
      select plan_code, org_code, 0 as sale_amount, 0 as cancel_amount, 0 as pay_amount, day_sale_amount, 0 as day_cancel_amount, 0 as day_pay_amount
        from day_sale_stat
      union all
      select plan_code, org_code, 0 as sale_amount, 0 as cancel_amount, 0 as pay_amount, 0 as day_sale_amount, day_cancel_amount, 0 as day_pay_amount
        from day_cancel_stat
      union all
      select plan_code, org_code, 0 as sale_amount, 0 as cancel_amount, 0 as pay_amount, 0 as day_sale_amount, 0 as day_cancel_amount, day_pay_amount
        from day_pay_stat),
   hour_stats as
     (select plan_code, org_code,
             sum(sale_amount) as sale_amount, sum(cancel_amount) as cancel_amount, sum(pay_amount) as pay_amount,
             sum(day_sale_amount) as day_sale_amount, sum(day_cancel_amount) as day_cancel_amount, sum(day_pay_amount) as day_pay_amount
        from hour_detail
       group by plan_code, org_code)
   select to_char(e_time,'yyyy-mm-dd'), v_now_seq, plan_code, org_code,
          nvl(sale_amount, 0) as sale_amount, nvl(cancel_amount, 0) as cancel_amount, nvl(pay_amount, 0) as pay_amount,
          nvl(day_sale_amount, 0) as day_sale_amount, nvl(day_cancel_amount, 0) as day_cancel_amount, nvl(day_pay_amount, 0) as day_pay_amount
     from time_con, hour_stats;


   -- 按小时统计销售站排行
   insert into his_sale_hour_agency
      (calc_date, calc_time, plan_code, agency_code, area_code, sale_amount, cancel_amount, pay_amount, day_sale_amount, day_cancel_amount, day_pay_amount)
   with time_con as
    (select v_start_time s_time,
            v_end_time e_time,
            trunc(sysdate) this_day
       from dual),
   sale_stat as
    (select plan_code, agency_code, sum(sale_amount) sale_amount
       from flow_sale, time_con
      where sale_time >= s_time
        and sale_time < e_time
      group by plan_code, agency_code),
   cancel_stat as
    (select plan_code, agency_code, sum(sale_amount) cancel_amount
       from flow_cancel, time_con
      where cancel_time >= s_time
        and cancel_time < e_time
      group by plan_code, agency_code),
   pay_stat as
    (select plan_code, pay_agency as agency_code, sum(pay_amount) pay_amount
       from flow_pay, time_con
      where pay_time >= s_time
        and pay_time < e_time
        and pay_agency is not null
      group by plan_code, pay_agency),
   day_sale_stat as
    (select plan_code, agency_code, sum(sale_amount) day_sale_amount
       from flow_sale, time_con
      where sale_time >= this_day
        and sale_time < e_time
      group by plan_code, agency_code),
   day_cancel_stat as
    (select plan_code, agency_code, sum(sale_amount) day_cancel_amount
       from flow_cancel, time_con
      where cancel_time >= this_day
        and cancel_time < e_time
      group by plan_code, agency_code),
   day_pay_stat as
    (select plan_code, pay_agency as agency_code, sum(pay_amount) day_pay_amount
       from flow_pay, time_con
      where pay_time >= this_day
        and pay_time < e_time
        and pay_agency is not null
      group by plan_code, pay_agency),
   hour_detail as
     (select plan_code, agency_code, sale_amount, 0 as cancel_amount, 0 as pay_amount, 0 as day_sale_amount, 0 as day_cancel_amount, 0 as day_pay_amount
        from sale_stat
      union all
      select plan_code, agency_code, 0 as sale_amount, cancel_amount, 0 as pay_amount, 0 as day_sale_amount, 0 as day_cancel_amount, 0 as day_pay_amount
        from cancel_stat
      union all
      select plan_code, agency_code, 0 as sale_amount, 0 as cancel_amount, pay_amount, 0 as day_sale_amount, 0 as day_cancel_amount, 0 as day_pay_amount
        from pay_stat
      union all
      select plan_code, agency_code, 0 as sale_amount, 0 as cancel_amount, 0 as pay_amount, day_sale_amount, 0 as day_cancel_amount, 0 as day_pay_amount
        from day_sale_stat
      union all
      select plan_code, agency_code, 0 as sale_amount, 0 as cancel_amount, 0 as pay_amount, 0 as day_sale_amount, day_cancel_amount, 0 as day_pay_amount
        from day_cancel_stat
      union all
      select plan_code, agency_code, 0 as sale_amount, 0 as cancel_amount, 0 as pay_amount, 0 as day_sale_amount, 0 as day_cancel_amount, day_pay_amount
        from day_pay_stat),
   hour_stats as
     (select plan_code, agency_code,
             sum(sale_amount) as sale_amount, sum(cancel_amount) as cancel_amount, sum(pay_amount) as pay_amount,
             sum(day_sale_amount) as day_sale_amount, sum(day_cancel_amount) as day_cancel_amount, sum(day_pay_amount) as day_pay_amount
        from hour_detail
       group by plan_code, agency_code)
   select to_char(e_time,'yyyy-mm-dd'), v_now_seq, plan_code, agency_code, (select area_code from inf_agencys where agency_code = hour_stats.agency_code) as area_code,
          nvl(sale_amount, 0) as sale_amount, nvl(cancel_amount, 0) as cancel_amount, nvl(pay_amount, 0) as pay_amount,
          nvl(day_sale_amount, 0) as day_sale_amount, nvl(day_cancel_amount, 0) as day_cancel_amount, nvl(day_pay_amount, 0) as day_pay_amount
     from time_con, hour_stats;


   end loop;
end;
/
