-- Sales Report + Institution Sales Reports
create or replace view v_report_sale_pay as
with sale as
 (select to_char(sale_time, 'yyyy-mm-dd') sale_day,
         to_char(sale_time, 'yyyy-mm') sale_month,
         area_code,
         org_code,
         f_get_old_plan_name(plan_code, batch_no) plan_code,
         sum(sale_amount) sale_amount,
         sum(comm_amount) as sale_comm
    from flow_sale
   where sale_time >= trunc(sysdate)
     and sale_time <  trunc(sysdate) + 1
   group by area_code,
            org_code,
            f_get_old_plan_name(plan_code, batch_no),
            to_char(sale_time, 'yyyy-mm-dd'),
            to_char(sale_time, 'yyyy-mm')),
cancel as
 (select to_char(cancel_time, 'yyyy-mm-dd') sale_day,
         to_char(cancel_time, 'yyyy-mm') sale_month,
         area_code,
         org_code,
         f_get_old_plan_name(plan_code, batch_no) plan_code,
         sum(sale_amount) cancel_amount,
         sum(comm_amount) as cancel_comm
    from flow_cancel
   where cancel_time >= trunc(sysdate)
     and cancel_time <  trunc(sysdate) + 1
   group by area_code,
            org_code,
            f_get_old_plan_name(plan_code, batch_no),
            to_char(cancel_time, 'yyyy-mm-dd'),
            to_char(cancel_time, 'yyyy-mm')),
pay_detail as
 (select to_char(pay_time, 'yyyy-mm-dd') sale_day,
         to_char(pay_time, 'yyyy-mm') sale_month,
         area_code,
         f_get_flow_pay_org(pay_flow) org_code,
         f_get_old_plan_name(plan_code, batch_no) plan_code,
         pay_amount,
         nvl(comm_amount, 0) comm_amount
    from flow_pay
   where pay_time >= trunc(sysdate)
     and pay_time <  trunc(sysdate) + 1),
pay as
 (select sale_day,
         sale_month,
         area_code,
         org_code,
         plan_code,
         sum(pay_amount) pay_amount,
         sum(comm_amount) as pay_comm
    from pay_detail
   group by sale_day, sale_month, area_code, org_code, plan_code),
pre_detail as (
   select sale_day, sale_month, area_code, org_code, plan_code, sale_amount, sale_comm, 0 as cancel_amount, 0 as cancel_comm, 0 as pay_amount, 0 as pay_comm from sale
    union all
   select sale_day, sale_month, area_code, org_code, plan_code, 0 as sale_amount, 0 as sale_comm, cancel_amount, cancel_comm, 0 as pay_amount, 0 as pay_comm from cancel
    union all
   select sale_day, sale_month, area_code, org_code, plan_code, 0 as sale_amount, 0 as sale_comm, 0 as cancel_amount, 0 as cancel_comm, pay_amount, pay_comm from pay
)
select sale_day, sale_month, area_code, org_code, plan_code,
       nvl(sum(sale_amount), 0) sale_amount,
       nvl(sum(sale_comm), 0) sale_comm,
       nvl(sum(cancel_amount), 0) cancel_amount,
       nvl(sum(cancel_comm), 0) cancel_comm,
       nvl(sum(pay_amount), 0) pay_amount,
       nvl(sum(pay_comm), 0) pay_comm,
       (nvl(sum(sale_amount), 0) - nvl(sum(sale_comm), 0) - nvl(sum(pay_amount), 0) - nvl(sum(pay_comm), 0) - nvl(sum(cancel_amount), 0) + nvl(sum(cancel_comm), 0)) incoming
  from pre_detail
 group by sale_day, sale_month, area_code, org_code, plan_code
union all
select SALE_DATE, SALE_MONTH, (case when AREA_CODE='NULL' then null else AREA_CODE end) AREA_CODE, ORG_CODE, PLAN_CODE, SALE_AMOUNT, SALE_COMM, CANCEL_AMOUNT, CANCEL_COMM, PAY_AMOUNT, PAY_COMM, INCOMING from his_sale_pay_cancel;


create or replace view v_report_pay_level as
with
pay_detail as
   (select to_char(PAY_TIME, 'yyyy-mm-dd') sale_day,
           to_char(PAY_TIME, 'yyyy-mm') sale_month,
           f_get_old_plan_name(plan_code,batch_no) PLAN_CODE,
           (case when REWARD_NO = 1 then PAY_AMOUNT else 0 end) level_1,
           (case when REWARD_NO = 2 then PAY_AMOUNT else 0 end) level_2,
           (case when REWARD_NO = 3 then PAY_AMOUNT else 0 end) level_3,
           (case when REWARD_NO = 4 then PAY_AMOUNT else 0 end) level_4,
           (case when REWARD_NO = 5 then PAY_AMOUNT else 0 end) level_5,
           (case when REWARD_NO = 6 then PAY_AMOUNT else 0 end) level_6,
           (case when REWARD_NO = 7 then PAY_AMOUNT else 0 end) level_7,
           (case when REWARD_NO = 8 then PAY_AMOUNT else 0 end) level_8,
           (case when REWARD_NO = 9 then PAY_AMOUNT else 0 end) level_9,
           (case when REWARD_NO = 10 then PAY_AMOUNT else 0 end) level_10,
           PAY_AMOUNT,
           f_get_flow_pay_org(PAY_FLOW) ORG_CODE
      from FLOW_PAY
     where pay_time >= trunc(sysdate)
       and pay_time <  trunc(sysdate) + 1)
select sale_day,
       sale_month,
       ORG_CODE,
       PLAN_CODE,
       sum(level_1) as level_1,
       sum(level_2) as level_2,
       sum(level_3) as level_3,
       sum(level_4) as level_4,
       sum(level_5) as level_5,
       sum(level_6) as level_6,
       sum(level_7) as level_7,
       sum(level_8) as level_8,
       sum(level_9) as level_9,
       sum(level_10) as level_10,
       sum(PAY_AMOUNT) as total
  from pay_detail
 group by sale_day,
          sale_month,
          ORG_CODE,
          PLAN_CODE
union all
select * from his_pay_level;

create or replace view v_report_lot_inventory as
with total as
 (select to_char(sysdate, 'yyyy-mm-dd') calc_date,
         plan_code,
         batch_no,
         reward_group,
         tab.status,
         nvl(current_warehouse, '[null]') warehouse,
         sum(tickets_every_pack) tickets
    from wh_ticket_package tab
    join game_batch_import_detail
   using (plan_code, batch_no)
   group by plan_code,
            batch_no,
            reward_group,
            tab.status,
            nvl(current_warehouse, '[null]')),
today as
 (select calc_date,
         plan_code,
         batch_no,
         reward_group,
         status,
         warehouse,
         tickets,
         tickets * ticket_amount amount
    from total
    join game_plans
   using (plan_code)),
today_stat as
 (select CALC_DATE,
         PLAN_CODE,
         f_get_plan_name(plan_code) plan_name,
         WAREHOUSE,
         sum(TICKETS) tickets,
         sum(amount) amount
    from today
   where status = 11
   group by CALC_DATE, PLAN_CODE, WAREHOUSE),
his_stat as
 (select CALC_DATE,
         PLAN_CODE,
         f_get_plan_name(plan_code) plan_name,
         WAREHOUSE,
         sum(TICKETS) tickets,
         sum(amount) amount
    from HIS_LOTTERY_INVENTORY
   where status = 11
   group by CALC_DATE, PLAN_CODE, WAREHOUSE),
all_stat as
 (select CALC_DATE, PLAN_CODE, plan_name, WAREHOUSE, tickets, amount
    from today_stat
  union all
  select CALC_DATE, PLAN_CODE, plan_name, WAREHOUSE, tickets, amount
    from his_stat)
select CALC_DATE, PLAN_CODE, plan_name, WAREHOUSE, tickets, amount
  from all_stat
 order by CALC_DATE desc;

-- 机构资金历史报表(历史+实时)
create or replace view v_his_org_fund_report as
with today_flow as
 (select AGENCY_CODE,
         FLOW_TYPE,
         sum(CHANGE_AMOUNT) amount,
         0 as BE_ACCOUNT_BALANCE,
         0 as AF_ACCOUNT_BALANCE
    from flow_agency
   where TRADE_TIME >= trunc(sysdate)
     and TRADE_TIME < trunc(sysdate) + 1
   group by AGENCY_CODE, FLOW_TYPE),
today_balance as
 (select AGENCY_CODE,
         0 as FLOW_TYPE,
         0 as amount,
         sum(BE_ACCOUNT_BALANCE) BE_ACCOUNT_BALANCE,
         sum(AF_ACCOUNT_BALANCE) AF_ACCOUNT_BALANCE
    from (select AGENCY_CODE,
                 0               as BE_ACCOUNT_BALANCE,
                 ACCOUNT_BALANCE as AF_ACCOUNT_BALANCE
            from acc_agency_account
          union all
          select AGENCY_CODE,
                 AF_ACCOUNT_BALANCE as BE_ACCOUNT_BALANCE,
                 0                  as AF_ACCOUNT_BALANCE
            from his_agency_fund
           where CALC_DATE = to_char(sysdate - 1, 'yyyy-mm-dd'))
   group by AGENCY_CODE),
agency_fund as
 (select AGENCY_CODE,
         FLOW_TYPE,
         amount,
         BE_ACCOUNT_BALANCE,
         AF_ACCOUNT_BALANCE
    from today_flow
  union all
  select AGENCY_CODE,
         FLOW_TYPE,
         amount,
         BE_ACCOUNT_BALANCE,
         AF_ACCOUNT_BALANCE
    from today_balance),
base as
 (select org_code,
         FLOW_TYPE,
         sum(AMOUNT) as amount,
         sum(BE_ACCOUNT_BALANCE) as BE_ACCOUNT_BALANCE,
         sum(AF_ACCOUNT_BALANCE) as AF_ACCOUNT_BALANCE
    from agency_fund
    join inf_agencys
   using (agency_code)
   group by org_code, FLOW_TYPE),
center_pay as
 (select f_get_flow_pay_org(pay_flow) org_code, sum(pay_amount) amount
       from flow_pay
      where pay_time >= trunc(sysdate)
        and pay_time < trunc(sysdate) + 1
        and is_center_paid = 1
      group by f_get_flow_pay_org(pay_flow)),
center_pay_comm as
 (select org_code, sum(change_amount) amount
    from flow_org
   where TRADE_TIME >= trunc(sysdate)
     and TRADE_TIME < trunc(sysdate) + 1
     and FLOW_TYPE = 23
   group by org_code),
agency_balance as
 (select * from (select org_code, BE_ACCOUNT_BALANCE, AF_ACCOUNT_BALANCE
    from base
   where flow_type = 0)
   unpivot (amount for flow_type in (BE_ACCOUNT_BALANCE as 88, AF_ACCOUNT_BALANCE as 99))),
fund as
 (select *
    from (select org_code, FLOW_TYPE, AMOUNT from base
             union all
             select org_code, FLOW_TYPE, AMOUNT from agency_balance
             union all
             select org_code, 21 FLOW_TYPE, AMOUNT from center_pay_comm
             union all
             select org_code, 20 FLOW_TYPE, AMOUNT from center_pay)
  pivot(sum(amount)
     for FLOW_TYPE in(1 as charge,
                     2 as withdraw,
                     5 as sale_comm,
                     6 as pay_comm,
                     7 as sale,
                     8 as paid,
                     11 as rtv,
                     13 as rtv_comm,
                     20 as center_pay,
                     21 as center_pay_comm,
                     88 as be,
                     99 as af))),
pre_detail as
 (select org_code,
         nvl(be, 0) be_account_balance,
         nvl(charge, 0) charge,
         nvl(withdraw, 0) withdraw,
         nvl(sale, 0) sale,
         nvl(sale_comm, 0) sale_comm,
         nvl(paid, 0) paid,
         nvl(pay_comm, 0) pay_comm,
         nvl(rtv, 0) rtv,
         nvl(rtv_comm, 0) rtv_comm,
         nvl(center_pay, 0) center_pay,
         nvl(center_pay_comm, 0) center_pay_comm,
         nvl(af, 0) af_account_balance
    from fund),
today_result as (
select to_char(sysdate, 'yyyy-mm-dd') CALC_DATE,
       org_code,
       BE_ACCOUNT_BALANCE,
       charge,
       withdraw,
       sale,
       sale_comm,
       paid,
       pay_comm,
       rtv,
       rtv_comm,
       AF_ACCOUNT_BALANCE,
       nvl((sale - sale_comm - paid - pay_comm - rtv + rtv_comm - center_pay - center_pay_comm), 0) incoming,
       (nvl((sale - sale_comm - paid - pay_comm - rtv + rtv_comm - center_pay - center_pay_comm), 0) + AF_ACCOUNT_BALANCE - BE_ACCOUNT_BALANCE) pay_up,
       center_pay,
       center_pay_comm
  from pre_detail)
select CALC_DATE, ORG_CODE, BE_ACCOUNT_BALANCE, CHARGE, WITHDRAW, SALE, SALE_COMM, PAID, PAY_COMM, RTV, RTV_COMM, AF_ACCOUNT_BALANCE, INCOMING, PAY_UP, center_pay, center_pay_comm from HIS_ORG_FUND_REPORT
union all
select CALC_DATE, ORG_CODE, BE_ACCOUNT_BALANCE, CHARGE, WITHDRAW, SALE, SALE_COMM, PAID, PAY_COMM, RTV, RTV_COMM, AF_ACCOUNT_BALANCE, INCOMING, PAY_UP, center_pay, center_pay_comm from today_result;


-- 销售与退货明细
create or replace view v_trade_detail as
with sales_flow as
 (select 7 as trade_type, agency_code, trade_time, ref_no
    from flow_agency
   where flow_type = 7),
sales_detail as
 (select SEQUENCE_NO,
         trade_type,
         agency_code,
         trade_time,
         plan_code,
         batch_no,
         TRUNK_NO,
         BOX_NO,
         PACKAGE_NO,
         TICKETS,
         AMOUNT
    from WH_GOODS_RECEIPT_DETAIL
    join sales_flow
   using (ref_no)),
return_flow as
 (select 11 as trade_type, agency_code, trade_time, ref_no
    from flow_agency
   where flow_type = 11),
return_detail as
 (select SEQUENCE_NO,
         trade_type,
         agency_code,
         trade_time,
         plan_code,
         batch_no,
         TRUNK_NO,
         BOX_NO,
         PACKAGE_NO,
         TICKETS,
         AMOUNT
    from WH_GOODS_issue_DETAIL
    join return_flow
   using (ref_no)),
all_detail as
 (select * from sales_detail union all select * from return_detail)
select trade_type,
       agency_code,
       trade_time,
       plan_code,
       batch_no,
       TRUNK_NO,
       BOX_NO,
       PACKAGE_NO,
       TICKETS,
       AMOUNT
  from all_detail
 order by SEQUENCE_NO;

 -- 市场管理员库存日结
 create or replace view v_his_mm_inventory as
 select CALC_DATE,
       WAREHOUSE MARKET_ADMIN,
       PLAN_CODE,
       BATCH_NO,
       sum(TICKETS) TICKETS,
       sum(AMOUNT) AMOUNT
  from his_lottery_inventory
 where STATUS = 21
 group by CALC_DATE, WAREHOUSE, PLAN_CODE, BATCH_NO;

 -- 市场管理员库存状态实时查询
create or replace view v_now_mm_inventory as
select current_warehouse market_admin,
       plan_code,
       sum(ticket_no_end - ticket_no_start + 1) tickets,
       count(*) packages
  from wh_ticket_package
 where status = 21
 group by current_warehouse, plan_code;

-- 部门库存查询
create or replace view v_his_org_inventory as
with base as (
  select *
  from his_org_inv_report),
base_t as (
   select * from base
   pivot(sum(tickets) as tickets, sum(amount) as amount
      for oper_type in(1 as tb_out,
                       4 as agency_return,
                       12 as tb_in,
                       14 as agency_sale,
                       20 as broken,
                       66 as mm_open,
                       77 as mm_close,
                       88 as opening,
                       99 as closing))),
base_no_null as (
   select calc_date, org_code, plan_code,
          nvl(tb_out_tickets, 0) tb_out_tickets,
          nvl(tb_out_amount, 0) tb_out_amount,
          nvl(agency_return_tickets, 0) agency_return_tickets,
          nvl(agency_return_amount, 0) agency_return_amount,
          nvl(tb_in_tickets, 0) tb_in_tickets,
          nvl(tb_in_amount, 0) tb_in_amount,
          nvl(agency_sale_tickets, 0) agency_sale_tickets,
          nvl(agency_sale_amount, 0) agency_sale_amount,
          nvl(broken_tickets, 0) broken_tickets,
          nvl(broken_amount, 0) broken_amount,
          nvl(opening_tickets, 0) opening_tickets,
          nvl(opening_amount, 0) opening_amount,
          nvl(closing_tickets, 0) closing_tickets,
          nvl(closing_amount, 0) closing_amount,
          nvl(mm_open_tickets, 0) mm_open_tickets,
          nvl(mm_open_amount, 0) mm_open_amount,
          nvl(mm_close_tickets, 0) mm_close_tickets,
          nvl(mm_close_amount, 0) mm_close_amount
     from base_t)
select calc_date, org_code, plan_code,
       tb_out_tickets,
       tb_out_amount,
       agency_return_tickets,
       agency_return_amount,
       tb_in_tickets,
       tb_in_amount,
       agency_sale_tickets,
       agency_sale_amount,
       broken_tickets,
       broken_amount,
       opening_tickets + mm_open_tickets   opening_tickets,
       opening_amount + mm_open_amount     opening_amount,
       closing_tickets + mm_close_tickets     closing_tickets,
       closing_amount + mm_close_amount       closing_amount
  from base_no_null;

-- 部门应缴明细
create or replace view v_his_fund_pay_up as
   with base as
    (select f_get_agency_org(AGENCY_CODE) org_code,flow_type ,sum(CHANGE_AMOUNT) amount
       from flow_agency
      where FLOW_TYPE in (1, 2)
        and TRADE_TIME >= trunc(sysdate) and TRADE_TIME < trunc(sysdate) + 1
      group by  f_get_agency_org(AGENCY_CODE) ,flow_type),
   center_pay as
    (select f_get_flow_pay_org(pay_flow) org_code, sum(pay_amount) amount
       from flow_pay
      where pay_time >= trunc(sysdate)
        and pay_time < trunc(sysdate) + 1
        and is_center_paid = 1
      group by f_get_flow_pay_org(pay_flow)),
   center_pay_comm as
    (select org_code, sum(change_amount) amount
       from flow_org
      where TRADE_TIME >= trunc(sysdate)
        and TRADE_TIME < trunc(sysdate) + 1
        and FLOW_TYPE = 23
      group by org_code),
   fund as
    (select *
       from (select org_code, FLOW_TYPE, AMOUNT from base
             union all
             select org_code, 8 FLOW_TYPE, AMOUNT from center_pay
             union all
             select org_code, 21 FLOW_TYPE, AMOUNT from center_pay_comm
            ) pivot(sum(amount) for FLOW_TYPE in(1 as charge, 2 as withdraw, 8 as paid, 21 as paid_comm)))
   select to_char(sysdate, 'yyyy-mm-dd') CALC_DATE,
          org_code,nvl(charge, 0) charge,
          nvl(withdraw, 0) withdraw,
          nvl(paid, 0) CENTER_PAID,
          nvl(paid_comm, 0) center_paid_comm,
          (nvl(charge, 0) - nvl(withdraw, 0) - nvl(paid, 0) + nvl(paid_comm, 0)) pay_up
     from inf_orgs left join fund using (org_code)
union all
select calc_date,org_code,charge,withdraw,center_paid,center_paid_comm,pay_up from his_org_fund;


-- 代理商资金报表
create or replace view v_his_agent_fund_report as
with
   agent_org as (
      select org_code from inf_orgs where org_type = 2),
   today as (
      select org_code, flow_type, sum(change_amount) amount
        from flow_org
       where trade_time >= trunc(sysdate)
         and trade_time < trunc(sysdate) + 1
         and org_code in (select org_code from agent_org)
       group by org_code, flow_type),
   last_day as (
      select org_code, 88 as flow_type, amount
        from his_agent_fund_report
       where org_code in (select org_code from agent_org)
         and flow_type = 99
         and calc_date = to_char(trunc(sysdate) - 1, 'yyyy-mm-dd')),
   nowf as (
      select org_code, 99 as flow_type, account_balance amount
        from acc_org_account
       where org_code in (select org_code from agent_org)),
   all_result as (
      select to_char(trunc(sysdate), 'yyyy-mm-dd') calc_date, org_code, flow_type, amount from today
      union all
      select to_char(trunc(sysdate), 'yyyy-mm-dd') calc_date, org_code, flow_type, amount from last_day
      union all
      select to_char(trunc(sysdate), 'yyyy-mm-dd') calc_date, org_code, flow_type, amount from nowf
      union all
      select calc_date, org_code, flow_type, amount from his_agent_fund_report),
   turn_result as (
      select *
        from all_result pivot(
                                         sum(amount) as amount for FLOW_TYPE in (1  as charge             ,
                                                                                 2  as withdraw           ,
                                                                                 3  as carry              ,
                                                                                 4  as org_comm           ,
                                                                                 12 as org_return         ,
                                                                                 21 as org_agency_pay_comm,
                                                                                 22 as org_agency_pay     ,
                                                                                 23 as org_center_pay_comm,
                                                                                 24 as org_center_pay     ,
                                                                                 25 as org_comm_org_return,
                                                                                 88 as begining,
                                                                                 99 as ending
                                                                                )
                                        )
                  )
select *
  from turn_result;
