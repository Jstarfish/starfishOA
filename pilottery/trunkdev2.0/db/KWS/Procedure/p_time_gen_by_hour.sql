create or replace procedure p_time_gen_by_hour
/****************************************************************/
   ------------------- 仅用于统计数据（以当前时间为结束时间，统计上一个间隔的时间） -------------------
   ---- add by 陈震: 2015/10/14
   /*************************************************************/
is
   v_start_time         date;                -- 统计开始时间
   v_end_time           date;                -- 统计结束时间
   v_now_seq            number(10);          -- 当前的序列号

   v_step_minutes       number(10);          -- 统计间隔时间（分钟）

begin
   v_step_minutes := 5;

   -- 计算统计开始时间和结束时间
   v_end_time := sysdate;
   v_start_time := sysdate - v_step_minutes / 24 / 60;
   v_now_seq := to_number(to_char(v_end_time, 'hh24')) * 60 / v_step_minutes + trunc(to_number(to_char(v_end_time, 'mi')) / v_step_minutes) + 1;

   -- 按小时统计销量
   insert into his_sale_hour
      (calc_date, calc_time, plan_code, org_code, sale_amount, cancel_amount, pay_amount,day_sale_amount,day_cancel_amount,day_pay_amount)
   with time_con as
    (select v_start_time s_time,
            v_end_time e_time,
            trunc(sysdate) this_day
       from dual),
   /**  时段统计值  **/
   sale_stat as
    (select plan_code, org_code, sum(sale_amount) sale_amount
       from flow_sale, time_con
      where sale_time >= s_time
        and sale_time < e_time
      group by plan_code, org_code
     union all
     -- 电脑票
     select to_char(game_code), org_code, sum(TICKET_AMOUNT)
       from his_sellticket
       join time_con on (1=1)
       join inf_agencys using(agency_code)
      where SALETIME >= s_time
        and SALETIME < e_time
      group by game_code, org_code
     ),
   cancel_stat as
    (select plan_code, org_code, sum(sale_amount) cancel_amount
       from flow_cancel, time_con
      where cancel_time >= s_time
        and cancel_time < e_time
      group by plan_code, org_code
     union all
     -- 电脑票
     select to_char(game_code), org_code, sum(ticket_amount)
       from his_cancelticket
       join time_con on (1=1)
       join his_sellticket using(applyflow_sell)
      where canceltime >= s_time
        and canceltime < e_time
      group by game_code, org_code
     ),
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
      group by plan_code, org_code
     union all
     -- 电脑票
     select to_char(game_code), org_code, sum(winningamounttax)
       from HIS_PAYTICKET, time_con
      where PAYTIME >= s_time
        and PAYTIME < e_time
      group by game_code, org_code
     ),
   /**  时段累计值  **/
   day_sale_stat as
    (select plan_code, org_code, sum(sale_amount) day_sale_amount
       from flow_sale, time_con
      where sale_time >= this_day
        and sale_time < e_time
      group by plan_code, org_code
     union all
     -- 电脑票
     select to_char(game_code), org_code, sum(TICKET_AMOUNT)
       from his_sellticket
       join time_con on (1=1)
       join inf_agencys using(agency_code)
      where SALETIME >= this_day
        and SALETIME < e_time
      group by game_code, org_code
     ),
   day_cancel_stat as
    (select plan_code, org_code, sum(sale_amount) day_cancel_amount
       from flow_cancel, time_con
      where cancel_time >= this_day
        and cancel_time < e_time
      group by plan_code, org_code
     union all
     -- 电脑票
     select to_char(game_code), org_code, sum(ticket_amount)
       from his_cancelticket
       join time_con on (1=1)
       join his_sellticket using(applyflow_sell)
      where canceltime >= this_day
        and canceltime < e_time
      group by game_code, org_code
    ),
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
      group by plan_code, org_code
     union all
     -- 电脑票
     select to_char(game_code), org_code, sum(winningamounttax)
       from HIS_PAYTICKET, time_con
      where PAYTIME >= this_day
        and PAYTIME < e_time
      group by game_code, org_code
    ),
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

   commit;

   -- 按小时统计销售站排行
   insert into his_sale_hour_agency
      (calc_date, calc_time, plan_code, agency_code, area_code, sale_amount, cancel_amount, pay_amount, day_sale_amount, day_cancel_amount, day_pay_amount)
   with time_con as
    (select v_start_time s_time,
            v_end_time e_time,
            trunc(sysdate) this_day
       from dual),
   /**  时段统计值  **/
   sale_stat as
    (select plan_code, agency_code, sum(sale_amount) sale_amount
       from flow_sale, time_con
      where sale_time >= s_time
        and sale_time < e_time
      group by plan_code, agency_code
     union all
     -- 电脑票
     select to_char(game_code), agency_code, sum(TICKET_AMOUNT)
       from his_sellticket, time_con
      where SALETIME >= s_time
        and SALETIME < e_time
      group by game_code, agency_code
     ),
   cancel_stat as
    (select plan_code, agency_code, sum(sale_amount) cancel_amount
       from flow_cancel, time_con
      where cancel_time >= s_time
        and cancel_time < e_time
      group by plan_code, agency_code
     union all
     -- 电脑票
     select to_char(game_code), his_cancelticket.agency_code, sum(ticket_amount)
       from his_cancelticket
       join time_con on (1=1)
       join his_sellticket using(applyflow_sell)
      where his_cancelticket.is_center = 0
	    and canceltime >= s_time
        and canceltime < e_time
      group by game_code, his_cancelticket.agency_code
     ),
   pay_stat as
    (select plan_code, pay_agency as agency_code, sum(pay_amount) pay_amount
       from flow_pay, time_con
      where is_center_paid = 3
	    and pay_time >= s_time
        and pay_time < e_time
        and pay_agency is not null
      group by plan_code, pay_agency
     union all
     -- 电脑票
     select to_char(game_code), agency_code, sum(winningamounttax)
       from HIS_PAYTICKET, time_con
      where is_center = 0
	    and PAYTIME >= s_time
        and PAYTIME < e_time
      group by game_code, agency_code
     ),
   /**  时段累计值  **/
   day_sale_stat as
    (select plan_code, agency_code, sum(sale_amount) day_sale_amount
       from flow_sale, time_con
      where sale_time >= this_day
        and sale_time < e_time
      group by plan_code, agency_code
     union all
     -- 电脑票
     select to_char(game_code), agency_code, sum(TICKET_AMOUNT)
       from his_sellticket, time_con
      where SALETIME >= this_day
        and SALETIME < e_time
      group by game_code, agency_code
     ),
   day_cancel_stat as
    (select plan_code, agency_code, sum(sale_amount) day_cancel_amount
       from flow_cancel, time_con
      where cancel_time >= this_day
        and cancel_time < e_time
      group by plan_code, agency_code
     union all
     -- 电脑票
     select to_char(game_code), his_cancelticket.agency_code, sum(ticket_amount)
       from his_cancelticket
       join time_con on (1=1)
       join his_sellticket using(applyflow_sell)
      where his_cancelticket.is_center = 0
	    and canceltime >= s_time
        and canceltime < e_time
      group by game_code, his_cancelticket.agency_code
     ),
   day_pay_stat as
    (select plan_code, pay_agency as agency_code, sum(pay_amount) day_pay_amount
       from flow_pay, time_con
      where is_center_paid = 3
	    and pay_time >= this_day
        and pay_time < e_time
        and pay_agency is not null
      group by plan_code, pay_agency
     union all
     -- 电脑票
     select to_char(game_code), agency_code, sum(winningamounttax)
       from HIS_PAYTICKET, time_con
      where is_center = 0
	    and PAYTIME >= s_time
        and PAYTIME < e_time
      group by game_code, agency_code
     ),
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
	commit;

    insert into his_terminal_online (
	 CALC_DATE,  CALC_TIME,  ORG_CODE,  ORG_NAME,  TOTAL_COUNT,  ONLINE_COUNT)
    select to_char(v_end_time,'yyyy-mm-dd'),v_now_seq,org_code,org_name,count(*),sum(is_logging) cnt
     from saler_terminal join inf_agencys using(agency_code) join inf_orgs using(org_code)
    where saler_terminal.status = 1 and org_code<>'00' group by org_code,org_name;
    commit;

end;