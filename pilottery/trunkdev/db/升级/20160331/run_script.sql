truncate table inf_publishers;
insert into inf_publishers (publisher_code, publisher_name, is_valid, plan_flow) values (1, '石家庄', 1, 1);
insert into inf_publishers (publisher_code, publisher_name, is_valid, plan_flow) values (3, '中彩印制', 1, 2);
commit;

alter table GAME_BATCH_REWARD_DETAIL add pre_safe_code generated always as (substr(SAFE_CODE,1,16));
create index idx_GAME_BATCH_REWARD_pre on game_batch_reward_detail(PLAN_CODE,BATCH_NO,pre_safe_code);

alter table FLOW_GUI_PAY add REMARK VARCHAR2(4000);
comment on column FLOW_GUI_PAY.REMARK is '兑奖备注';

Insert into KWS.ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (120503, 'Inventory Check Inquiry', '12050300', 0, '库存盘点查询',
    '/inventory.do?method=listInventoryCheckInquiry', 1205, 3, 9);
insert into ADM_ROLE_PRIVILEGE(ROLE_ID, PRIVILEGE_ID) values (0,120503) ;
COMMIT;

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
    from flow_pay),
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
 group by sale_day, sale_month, area_code, org_code, plan_code;

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
      from FLOW_PAY)
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
          PLAN_CODE;

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

CREATE OR REPLACE PACKAGE eflow_type IS
   /****** 提供给以下表使用： ******/
   /******     机构资金流水（flow_org）                  ******/
   /******     站点资金流水（flow_agency）               ******/
   /******     市场管理员资金流水（flow_market_manager） ******/

   charge                       /* 1-充值                               */     CONSTANT NUMBER := 1;
   withdraw                     /* 2-提现                               */     CONSTANT NUMBER := 2;
   carry                        /* 3-彩票调拨入库（机构）               */     CONSTANT NUMBER := 3;
   org_comm                     /* 4-彩票调拨入库佣金（机构）           */     CONSTANT NUMBER := 4;
   sale_comm                    /* 5-销售佣金（站点）                   */     CONSTANT NUMBER := 5;
   pay_comm                     /* 6-兑奖佣金（站点）                   */     CONSTANT NUMBER := 6;
   sale                         /* 7-销售（站点）                       */     CONSTANT NUMBER := 7;
   paid                         /* 8-兑奖（站点）                       */     CONSTANT NUMBER := 8;
   charge_for_agency            /* 9-市场管理员为站点充值（管理员）     */     CONSTANT NUMBER := 9;
   fund_return                  /* 10-现金上缴（管理员）                */     CONSTANT NUMBER := 10;
   agency_return                /* 11-站点退货（站点）                  */     CONSTANT NUMBER := 11;
   org_return                   /* 12-彩票调拨出库（机构）              */     CONSTANT NUMBER := 12;
   cancel_comm                  /* 13-撤销佣金（站点）                  */     CONSTANT NUMBER := 13;
   withdraw_for_agency          /* 14-市场管理员为站点提现（管理员）    */     CONSTANT NUMBER := 14;

   org_agency_pay_comm          /* 21-站点兑奖导致机构佣金（机构）      */     CONSTANT NUMBER := 21;
   org_agency_pay               /* 22-站点兑奖导致机构增加资金（机构）  */     CONSTANT NUMBER := 22;
   org_center_pay_comm          /* 23-中心兑奖导致机构佣金（机构）      */     CONSTANT NUMBER := 23;
   org_center_pay               /* 24-中心兑奖导致机构增加资金（机构）  */     CONSTANT NUMBER := 24;
   org_comm_org_return          /* 31-彩票调拨出库退佣金（机构）        */     CONSTANT NUMBER := 31;

   /***********************************************************************************************************/
   /**********************           以下内容用于销售站           *********************************************/
   /***********************************************************************************************************/
   lottery_sale_comm            /* 43-电脑票销售佣金                    */     CONSTANT NUMBER := 43;
   lottery_pay_comm             /* 44-电脑票兑奖佣金                    */     CONSTANT NUMBER := 44;
   lottery_sale                 /* 45-电脑票销售                        */     CONSTANT NUMBER := 45;
   lottery_pay                  /* 41-电脑票兑奖                        */     CONSTANT NUMBER := 41;
   lottery_cancel               /* 42-电脑票退票                        */     CONSTANT NUMBER := 42;
   lottery_cancel_comm          /* 47-电脑票退销售佣金                  */     CONSTANT NUMBER := 47;

   lottery_fail_sale_comm       /* 53-交易失败_电脑票销售佣金（交易失败）  */     CONSTANT NUMBER := 53;
   lottery_fail_pay_comm        /* 54-交易失败_电脑票兑奖佣金（交易失败）  */     CONSTANT NUMBER := 54;
   lottery_fail_sale            /* 55-交易失败_电脑票销售（交易失败）      */     CONSTANT NUMBER := 55;
   lottery_fail_pay             /* 51-交易失败_电脑票兑奖（交易失败）      */     CONSTANT NUMBER := 51;
   lottery_fail_cancel          /* 52-交易失败_电脑票退票（交易失败）      */     CONSTANT NUMBER := 52;
   lottery_fail_cancel_comm     /* 57-交易失败_电脑票退销售佣金（交易失败）*/     CONSTANT NUMBER := 57;
   /***********************************************************************************************************/

END;
/

create or replace package error_msg is
   /****************************************************/
   /****** Error Messages - Multi-lingual Version ******/
   /****************************************************/

   /*----- Common ------*/
   err_comm_password_not_match constant  varchar2(4000) := '{"en":"Password error.","zh":"用户密码错误"}';

   /*----- Procedure ------*/
   -- err_p_cxxxxx_1
   -- err_p_cxxxxx_2
   -- err_f_cxxxxx_1
   -- err_f_cxxxxx_2

   err_p_import_batch_file_1  constant varchar2(4000) := '{"en":"The batch information already exists.","zh":"批次数据信息已经存在"}';
   err_p_import_batch_file_2  constant varchar2(4000) := '{"en":"The plan and batch information in the data file are inconsistent with the user input.","zh":"数据文件中所记录的方案与批次信息，与界面输入的方案和批次不符"}';

   err_p_batch_inbound_1 constant varchar2(4000) := '{"en":"The trunk has already been received.","zh":"此箱已经入库"}';
   err_p_batch_inbound_2 constant varchar2(4000) := '{"en":"The warehouse does not exist.","zh":"无此仓库"}';
   err_p_batch_inbound_3 constant varchar2(4000) := '{"en":"The batch does not exist.","zh":"无此批次"}';
   err_p_batch_inbound_4 constant varchar2(4000) := '{"en":"Wrong operation parameter, must be 1, 2 or 3.","zh":"操作类型参数错误，应该为1，2，3"}';
   err_p_batch_inbound_5 constant varchar2(4000) := '{"en":"Batch receipt code error occurred when continuing or completing lottery receipt. Receipt code does not exist.","zh":"在进行继续入库和完结入库操作时，输入的批次入库单错误，未发现此批次入库单"}';
   err_p_batch_inbound_6 constant varchar2(4000) := '{"en":"Batch receipt code error occurred when continuing lottery receipt, or this batch receipt has already completed.","zh":"在进行继续入库时，输入的批次入库单错误，或者此批次入库单已经完结"}';
   err_p_batch_inbound_7 constant varchar2(4000) := '{"en":"The batch receipt has already completed, please do not repeat the process.","zh":"此批次的方案已经入库完毕，请不要重复进行"}';

   err_f_get_warehouse_code_1 constant varchar2(4000) := '{"en":"The input account type is not \"jg\", \"zd\" or \"mm\".","zh":"输入的账户类型不是“jg”,“zd”,“mm”"}';

   err_f_get_lottery_info_1 constant varchar2(4000) := '{"en":"The input \"Trunk\" code is out of the valid range.","zh":"输入的“箱”号超出合法的范围"}';
   err_f_get_lottery_info_2 constant varchar2(4000) := '{"en":"The input \"Box\" code is out of the valid range.","zh":"输入的“盒”号超出合法的范围"}';
   err_f_get_lottery_info_3 constant varchar2(4000) := '{"en":"The input \"Pack\" code is out of the valid range.","zh":"输入的“本”号超出合法的范围"}';

   err_p_tb_outbound_3  constant varchar2(4000) := '{"en":"Transfer code error occurred when continuing lottery issue, or the corresponding delivery order has completed.","zh":"在进行继续出库时，输入的调拨单号错误，或者此调拨单对应的出库单，出库已经完结"}';
   err_p_tb_outbound_4  constant varchar2(4000) := '{"en":"The transfer order status is incorrect when the transfer issue has completed.","zh":"调拨单出库完结时，调拨单状态不合法"}';
   err_p_tb_outbound_14 constant varchar2(4000) := '{"en":"The actual issued quantity for this transfer order is inconsistent with the applied quantity.","zh":"调拨单实际出库数量与申请数量不符"}';
   err_p_tb_outbound_5  constant varchar2(4000) := '{"en":"The transfer order status is incorrect when the transfer issue is being processed.","zh":"进行调拨单出库时，调拨单状态不合法"}';
   err_p_tb_outbound_6  constant varchar2(4000) := '{"en":"Cannot obtain the delivery code.","zh":"不能获得出库单编号"}';
   err_p_tb_outbound_7  constant varchar2(4000) := '{"en":"The actual number of tickets being delivered should not be larger than the number as specified in the transfer order.","zh":"实际出库票数不应该大于调拨单计划出库票数"}';

   err_p_tb_inbound_2  constant varchar2(4000) := '{"en":"The input parent institution of the warehouse is inconsistent with that as specified in the transfer order.","zh":"输入的仓库所属机构，与调拨单中标明的接收机构不符"}';
   err_p_tb_inbound_3  constant varchar2(4000) := '{"en":"Transfer code error occurred when continuing lottery receipt, or the corresponding receipt order has completed.","zh":"在进行继续入库时，输入的调拨单号错误，或者此调拨单对应的入库单，入库已经完结"}';
   err_p_tb_inbound_4  constant varchar2(4000) := '{"en":"The transfer order status is not as expected when the transfer receipt has completed.","zh":"调拨单入库完结时，调拨单状态与预期值不符"}';
   err_p_tb_inbound_5  constant varchar2(4000) := '{"en":"The transfer order status is incorrect when the transfer receipt is being processed.","zh":"进行调拨单入库时，调拨单状态不合法"}';
   err_p_tb_inbound_6  constant varchar2(4000) := '{"en":"Cannot find the corresponding receipt code with respect to the input transfer code when adding lottery tickets. It may be caused by having entered a wrong transfer code.","zh":"继续添加彩票时，未能按照输入的调拨单编号，查询到相应的入库单编号。可能传入了错误的调拨单编号"}';
   err_p_tb_inbound_25 constant varchar2(4000) := '{"en":"The transfer order does not exist.","zh":"未查询到此调拨单"}';
   err_p_tb_inbound_7  constant varchar2(4000) := '{"en":"The actual number of tickets being transferred should be smaller than or equal to the applied quantity.","zh":"实际调拨票数，应该小于或者等于申请调拨票数"}';

   err_p_batch_end_1 constant varchar2(4000) := '{"en":"The person does not exist.","zh":"无此人"}';
   err_p_batch_end_2 constant varchar2(4000) := '{"en":"The plan is disabled.","zh":"此方案已经不可用"}';
   err_p_batch_end_3 constant varchar2(4000) := '{"en":"Cannot terminate this batch because \"in transit\" or \"in outlet\" lottery ticket may exist.","zh":"存在“在途”和“在站点”的彩票，不能执行批次终结"}';
   err_p_batch_end_4 constant varchar2(4000) := '{"en":"Cannot terminate this batch because \"in transit\" or \"in outlet\" lottery ticket may exist.","zh":"存在“在途”和“在站点”的彩票，不能执行批次终结"}';
   err_p_batch_end_5 constant varchar2(4000) := '{"en":"Cannot terminate this batch because \"in transit\" or \"in outlet\" lottery ticket may exist.","zh":"存在“在途”和“在站点”的彩票，不能执行批次终结"}';


   err_p_gi_outbound_4  constant varchar2(4000) := '{"en":"The delivery order status is incorrect when the delivery issue has completed.","zh":"出货单出库完结时，出货单状态不合法"}';
   err_p_gi_outbound_5  constant varchar2(4000) := '{"en":"The delivery order status is incorrect when the delivery issue is being processed.","zh":"进行出货单出库时，出货单状态不合法"}';
   err_p_gi_outbound_6  constant varchar2(4000) := '{"en":"Cannot obtain the issue code.","zh":"不能获得出库单编号"}';
   err_p_gi_outbound_1  constant varchar2(4000) := '{"en":"The person does not exist.","zh":"无此人"}';
   err_p_gi_outbound_3  constant varchar2(4000) := '{"en":"Transfer code error occurred when continuing lottery issue, or the corresponding delivery order has completed.","zh":"在进行继续出库时，输入的调拨单号错误，或者此调拨单对应的出库单，出库已经完结"}';
   err_p_gi_outbound_10 constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when transferring a \"Trunk\".","zh":"调拨“箱”时，“本”数据出现异常"}';
   err_p_gi_outbound_12 constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Box\". Or the trunk status may be incorrect.","zh":"调拨“盒”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
   err_p_gi_outbound_13 constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when transferring a \"Box\".","zh":"调拨“盒”时，对应的“本”数据异常"}';
   err_p_gi_outbound_16 constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Pack\". Or the trunk status may be incorrect.","zh":"调拨“本”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
   err_p_gi_outbound_7  constant varchar2(4000) := '{"en":"Repeated items found for issue.","zh":"出现重复的出库物品"}';
   err_p_gi_outbound_8  constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Trunk\". Or the trunk status may be incorrect.","zh":"调拨“箱”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
   err_p_gi_outbound_9  constant varchar2(4000) := '{"en":"Exception occurred in \"Box\" data when transferring a \"Trunk\".","zh":"调拨“箱”时，“盒”数据出现异常"}';
   err_p_gi_outbound_2  constant varchar2(4000) := '{"en":"The warehouse does not exist.","zh":"无此仓库"}';
   err_p_gi_outbound_11 constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the box is already inside the issue details.","zh":"盒对应的箱已经出现在出库明细中，逻辑校验失败"}';
   err_p_gi_outbound_14 constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the issue details.","zh":"本对应的箱已经出现在出库明细中，逻辑校验失败"}';
   err_p_gi_outbound_15 constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the issue details.","zh":"本对应的箱已经出现在出库明细中，逻辑校验失败"}';
   err_p_gi_outbound_17 constant varchar2(4000) := '{"en":"Exceeds the \"maximum allowable credit\" as held by this manager.","zh":"超过此管理员允许持有的“最高赊票金额”"}';

   err_p_rr_inbound_1  constant varchar2(4000) := '{"en":"The person does not exist.","zh":"无此人"}';
   err_p_rr_inbound_2  constant varchar2(4000) := '{"en":"The warehouse does not exist.","zh":"无此仓库"}';
   err_p_rr_inbound_3  constant varchar2(4000) := '{"en":"Wrong operation parameter, must be 1, 2 or 3.","zh":"操作类型参数错误，应该为1，2，3"}';
   err_p_rr_inbound_4  constant varchar2(4000) := '{"en":"The return delivery status is incorrect when the return delivery receipt has completed. Expected status: [Receiving].","zh":"还货单入库完结时，还货单状态不合法，期望的换货单状态应该为[收货中]"}';
   err_p_rr_inbound_24 constant varchar2(4000) := '{"en":"Cannot find the return delivery due to incorrect return code.","zh":"还货单编号不合法，未查询到此换货单"}';
   err_p_rr_inbound_5  constant varchar2(4000) := '{"en":"The return delivery status is incorrect when the return delivery receipt has completed. Expected status: [Approved].","zh":"还货单入库完结时，还货单状态不合法，期望的换货单状态应该为[已审批]"}';
   err_p_rr_inbound_15 constant varchar2(4000) := '{"en":"The return delivery status is incorrect when the return delivery receipt is being processed. Expected status: [Receiving].","zh":"还货单继续入库时，还货单状态不合法，期望的换货单状态应该为[接收中]"}';
   err_p_rr_inbound_6  constant varchar2(4000) := '{"en":"Cannot obtain the receipt code.","zh":"不能获得入库单编号"}';
   err_p_rr_inbound_7  constant varchar2(4000) := '{"en":"Repeated items found for receipt.","zh":"出现重复的入库物品"}';
   err_p_rr_inbound_8  constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when transferring a \"Box\".","zh":"调拨“盒”时，“本”数据出现异常"}';
   err_p_rr_inbound_18 constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when transferring a \"Trunk\".","zh":"调拨“箱”时，“本”数据出现异常"}';
   err_p_rr_inbound_28 constant varchar2(4000) := '{"en":"Exception occurred in \"Box\" data when transferring a \"Trunk\".","zh":"调拨“箱”时，“盒”数据出现异常"}';
   err_p_rr_inbound_38 constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Trunk\". Or the trunk status may be incorrect.","zh":"调拨“箱”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
   err_p_rr_inbound_9  constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the box is already inside the receipt details.","zh":"盒对应的箱已经出现在入库明细中，逻辑校验失败"}';
   err_p_rr_inbound_10 constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Box\". Or the trunk status may be incorrect.","zh":"调拨“盒”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
   err_p_rr_inbound_11 constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the receipt details.","zh":"本对应的箱已经出现在入库明细中，逻辑校验失败"}';
   err_p_rr_inbound_12 constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the receipt details.","zh":"本对应的箱已经出现在入库明细中，逻辑校验失败"}';
   err_p_rr_inbound_13 constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Pack\". Or the trunk status may be incorrect.","zh":"调拨“本”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
   err_p_rr_inbound_14 constant varchar2(4000) := '{"en":"There is no information on this plan and batch in the warehouse manager inventory.","zh":"仓库管理员的库存中，没有此方案和批次的库存信息"}';

   err_p_ar_inbound_1  constant varchar2(4000) := '{"en":"The person does not exist.","zh":"无此人"}';
   err_p_ar_inbound_3  constant varchar2(4000) := '{"en":"Repeated items found for receipt.","zh":"出现重复的入库物品"}';
   err_p_ar_inbound_4  constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when processing a \"Trunk\". Or the trunk status may be incorrect.","zh":"处理“箱”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
   err_p_ar_inbound_5  constant varchar2(4000) := '{"en":"Exception occurred in \"Box\" data when processing a \"Trunk\".","zh":"处理“箱”时，“盒”数据出现异常"}';
   err_p_ar_inbound_6  constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when processing a \"Trunk\".","zh":"处理“箱”时，“本”数据出现异常"}';
   err_p_ar_inbound_7  constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the box is already inside the receipt details.","zh":"盒对应的箱已经出现在入库明细中，逻辑校验失败"}';
   err_p_ar_inbound_10 constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when processing a \"Box\". Or the trunk status may be incorrect.","zh":"处理“盒”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
   err_p_ar_inbound_38 constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when processing a \"Box\".","zh":"处理“盒”时，“本”数据出现异常"}';
   err_p_ar_inbound_11 constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the receipt details.","zh":"本对应的箱已经出现在入库明细中，逻辑校验失败"}';
   err_p_ar_inbound_12 constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the receipt details.","zh":"本对应的箱已经出现在入库明细中，逻辑校验失败"}';
   err_p_ar_inbound_13 constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when processing a \"Pack\". Or the trunk status may be incorrect.","zh":"处理“本”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
   err_p_ar_inbound_14 constant varchar2(4000) := '{"en":"There is no information on this plan and batch in the warehouse manager inventory.","zh":"仓库管理员的库存中，没有此方案和批次的库存信息"}';
   err_p_ar_inbound_15 constant varchar2(4000) := '{"en":"The outlet has not set up the sales commission rate of this lottery plan.","zh":"该销售站未设置此方案对应的销售佣金比例"}';
   err_p_ar_inbound_16 constant varchar2(4000) := '{"en":"The outlet does not have an account or the account status is incorrect.","zh":"销售站无账户或相应账户状态不正确"}';
   err_p_ar_inbound_17 constant varchar2(4000) := '{"en":"Insufficient outlet balance.","zh":"销售站余额不足"}';


   err_p_institutions_create_1 constant varchar2(4000) := '{"en":"Institution code cannot be empty.","zh":"部门编码不能为空！"}';
   err_p_institutions_create_2 constant varchar2(4000) := '{"en":"Institution name cannot be empty.","zh":"部门名称不能为空！"}';
   err_p_institutions_create_3 constant varchar2(4000) := '{"en":"Insittution director does not exist.","zh":"部门负责人不存在！"}';
   err_p_institutions_create_4 constant varchar2(4000) := '{"en":"Contact phone cannot be empty.","zh":"部门联系电话不能为空！"}';
   err_p_institutions_create_5 constant varchar2(4000) := '{"en":"This institution code already exists in the system.","zh":"部门编码在系统中已经存在！"}';
   err_p_institutions_create_6 constant varchar2(4000) := '{"en":"Area has been repeatedly governed by other insittution.","zh":"选择区域已经被其他部门管辖！"}';

   err_p_institutions_modify_1 constant varchar2(4000) := '{"en":"Original institution code cannot be empty.","zh":"部门原编码不能为空！"}';
   err_p_institutions_modify_2 constant varchar2(4000) := '{"en":"Other relevant staff in this institution cannot change the institution code.","zh":"部门关联其他人员不能修改编码！"}';

   err_p_outlet_create_1 constant varchar2(4000) := '{"en":"Institution code cannot be empty.","zh":"部门编码不能为空！"}';
   err_p_outlet_create_2 constant varchar2(4000) := '{"en":"The institution is disabled.","zh":"部门无效！"}';
   err_p_outlet_create_3 constant varchar2(4000) := '{"en":"Area code cannot be empty.","zh":"区域编码不能为空！"}';
   err_p_outlet_create_4 constant varchar2(4000) := '{"en":"The area is disabled.","zh":"区域无效！"}';

   err_p_outlet_modify_1 constant varchar2(4000) := '{"en":"The outlet code already exists.","zh":"站点编码已存在！"}';
   err_p_outlet_modify_2 constant varchar2(4000) := '{"en":"The outlet code is invalid.","zh":"站点编码不符合规范！"}';
   err_p_outlet_modify_3 constant varchar2(4000) := '{"en":"Cannot modify outlet code when there is a transaction.","zh":"站点有缴款业务不能变更编码！"}';
   err_p_outlet_modify_4 constant varchar2(4000) := '{"en":"Cannot modify outlet code when there is an order.","zh":"站点有订单业务不能变更编码！"}';

   err_p_outlet_plan_auth_1 constant varchar2(4000) := '{"en":"The delegated plan cannot be empty.","zh":"授权方案不能为空！"}';
   err_p_outlet_plan_auth_2 constant varchar2(4000) := '{"en":"The commission rate of the delegated plan cannot exceed the commission rate of the parent institution.","zh":"授权方案代销费率不能超出所属机构代销费率！"}';

   err_p_org_plan_auth_1 constant varchar2(4000) := '{"en":"The delegated plan cannot be empty.","zh":"授权方案不能为空！"}';
   err_p_org_plan_auth_2 constant varchar2(4000) := '{"en":"The commission rate of the delegated plan cannot exceed 1000.","zh":"授权方案代销费率不能超出1000！"}';

   err_p_warehouse_create_1 constant varchar2(4000) := '{"en":"Warehouse code cannot be empty.","zh":"编码不能为空！"}';
   err_p_warehouse_create_2 constant varchar2(4000) := '{"en":"Warehouse code cannot repeat.","zh":"编码不能重复！"}';
   err_p_warehouse_create_3 constant varchar2(4000) := '{"en":"Warehouse name cannot be empty.","zh":"名称不能为空！"}';
   err_p_warehouse_create_4 constant varchar2(4000) := '{"en":"Warehouse address cannot be empty.","zh":"地址不能为空！"}';
   err_p_warehouse_create_5 constant varchar2(4000) := '{"en":"Warehouse director does not exist.","zh":"负责人不存在！"}';
   err_p_warehouse_create_6 constant varchar2(4000) := '{"en":" has already had administering warehouse.","zh":"-已经有管辖仓库！"}';

   err_p_warehouse_modify_1 constant varchar2(4000) := '{"en":"Warehouse code does not exist.","zh":"编码不存在！"}';

   err_p_admin_create_1 constant varchar2(4000) := '{"en":"Real name cannot be empty.","zh":"真实姓名不能为空！"}';
   err_p_admin_create_2 constant varchar2(4000) := '{"en":"Login name cannot be empty.","zh":"登录名不能为空！"}';
   err_p_admin_create_3 constant varchar2(4000) := '{"en":"Login name already exists.","zh":"登录名已存在！"}';

   err_p_outlet_topup_1 constant varchar2(4000) := '{"en":"Outlet code cannot be empty.","zh":"站点编码不能为空！"}';
   err_p_outlet_topup_2 constant varchar2(4000) := '{"en":"User does not exist or is disabled.","zh":"用户不存在或者无效！"}';
   err_p_outlet_topup_3 constant varchar2(4000) := '{"en":"Password cannot be empty.","zh":"密码不能为空！"}';
   err_p_outlet_topup_4 constant varchar2(4000) := '{"en":"Password is invalid.","zh":"密码无效！"}';

   err_p_institutions_topup_1 constant varchar2(4000) := '{"en":"Institution code cannot be empty.","zh":"机构编码不能为空！"}';
   err_p_institutions_topup_2 constant varchar2(4000) := '{"en":"The current user is disabled.","zh":"当前用户无效！"}';
   err_p_institutions_topup_3 constant varchar2(4000) := '{"en":"The current institution is disabled.","zh":"当前机构无效！"}';

   err_p_outlet_withdraw_app_1 constant varchar2(4000) := '{"en":"Insufficient balance for cash withdraw.","zh":"提现金额不足！"}';
   err_p_outlet_withdraw_con_1 constant varchar2(4000) := '{"en":"Application form cannot be empty.","zh":"申请单不能为空！"}';
   err_p_outlet_withdraw_con_2 constant varchar2(4000) := '{"en":"Application form does not exist or is not approved.","zh":"申请单不存在或状态非审批通过！"}';
   err_p_outlet_withdraw_con_3 constant varchar2(4000) := '{"en":"The outlet does not exist or the password is incorrect.","zh":"站点不存在或密码无效！"}';

   err_p_warehouse_delete_1 constant varchar2(4000) := '{"en":"Cannot delete a warehouse with item inventory.","zh":"仓库中有库存物品，不可进行删除！"}';

   err_p_warehouse_check_step1_1 constant varchar2(4000) := '{"en":"The inventory check name cannot be empty.","zh":"盘点名称不能为空！"}';
   err_p_warehouse_check_step1_2 constant varchar2(4000) := '{"en":"The warehouse for check cannot be empty.","zh":"库房不能为空！"}';
   err_p_warehouse_check_step1_3 constant varchar2(4000) := '{"en":"The check operator is disabled.","zh":"盘点人无效！"}';
   err_p_warehouse_check_step1_4 constant varchar2(4000) := '{"en":"The warehouse is disabled or is in checking.","zh":"仓库无效或者正在盘点中！"}';
   err_p_warehouse_check_step1_5 constant varchar2(4000) := '{"en":"There are no lottery tickets or items for check in this warehouse.","zh":"仓库无彩票物品，没有必要盘点！"}';

   err_p_warehouse_check_step2_1 constant varchar2(4000) := '{"en":"The inventory check code cannot be empty.","zh":"盘点单不能为空！"}';
   err_p_warehouse_check_step2_2 constant varchar2(4000) := '{"en":"The inventory check does not exist or has completed.","zh":"盘点单不存在或已完结！"}';
   err_p_warehouse_check_step2_3 constant varchar2(4000) := '{"en":"The scanned information cannot be empty.","zh":"扫描信息不能为空！"}';

   err_p_mm_fund_repay_1 constant varchar2(4000) := '{"en":"Market manager cannot be empty.","zh":"市场管理员不能为空！"}';
   err_p_mm_fund_repay_2 constant varchar2(4000) := '{"en":"Market manager does not exist or is deleted.","zh":"市场管理员已经删除或不存在！"}';
   err_p_mm_fund_repay_3 constant varchar2(4000) := '{"en":"Current operator cannot be empty.","zh":"当前操作人不能为空！"}';
   err_p_mm_fund_repay_4 constant varchar2(4000) := '{"en":"Current operator does not exist or is deleted.","zh":"当前操作人已经删除或不存在！"}';
   err_p_mm_fund_repay_5 constant varchar2(4000) := '{"en":"The repayment amount is invalid.","zh":"还款金额无效！"}';

   err_common_1 constant varchar2(4000) := '{"en":"Database error.","zh":"数据库操作异常"}';
   err_common_2 constant varchar2(4000) := '{"en":"Invalid status.","zh":"无效的状态值"}';
   err_common_3 constant varchar2(4000) := '{"en":"Object does not exist.","zh":"对象不存在"}';
   err_common_4 constant varchar2(4000) := '{"en":"Parameter name error.","zh":"参数名称错误"}';
   err_common_5 constant varchar2(4000) := '{"en":"Invalid parameter.","zh":"无效的参数"}';
   err_common_6 constant varchar2(4000) := '{"en":"Invalid code.","zh":"编码不符合规范"}';
   err_common_7 constant varchar2(4000) := '{"en":"Code overflow.","zh":"编码溢出"}';
   err_common_8 constant varchar2(4000) := '{"en":"The data is being processed by others.","zh":"数据正在被别人处理中"}';
   err_common_9 constant varchar2(4000) := '{"en":"The deletion requrement cannot be satisfied.","zh":"不符合删除条件"}';

   err_p_fund_change_1 constant varchar2(4000) := '{"en":"Insufficient account balance.","zh":"账户余额不足"}';
   err_p_fund_change_2 constant varchar2(4000) := '{"en":"Incorrect fund type.","zh":"资金类型不合法"}';
   err_p_fund_change_3 constant varchar2(4000) := '{"en":"The outlet account does not exist, or the account status is incorrect.","zh":"未发现销售站的账户，或者账户状态不正确"}';

   err_p_lottery_reward_3 constant varchar2(4000) := '{"en":"This lottery ticket has not been on sale yet.","zh":"彩票未被销售"}';
   err_p_lottery_reward_4 constant varchar2(4000) := '{"en":"This lottery ticket has already been paid.","zh":"彩票已兑奖"}';
   err_p_lottery_reward_5 constant varchar2(4000) := '{"en":"Incorrect system parameter, please contact system administrator for recalibration.","zh":"系统参数值不正确，请联系管理员，重新设置"}';
   err_p_lottery_reward_6 constant varchar2(4000) := '{"en":"The outlet has not set up the payout commission rate of this lottery plan.","zh":"该销售站未设置此方案对应的兑奖佣金比例"}';
   err_p_lottery_reward_7 constant varchar2(4000) := '{"en":"The outlet has not set up the payout commission rate of this lottery plan.","zh":"该销售站未设置此方案对应的兑奖佣金比例"}';

   err_f_check_import_ticket constant varchar2(4000) := '{"en":"Wrong input parameter, must be 1 or 2.","zh":"输入参数错误，应该为1或者2"}';

   err_common_100 constant varchar2(4000) := '{"en":"The person does not exist.","zh":"无此人"}';
   err_common_101 constant varchar2(4000) := '{"en":"The warehouse does not exist.","zh":"无此仓库"}';
   err_common_102 constant varchar2(4000) := '{"en":"There is no batch in this plan.","zh":"无此方案批次"}';
   err_common_103 constant varchar2(4000) := '{"en":"Self-reference exists in the input lottery object.","zh":"输入的彩票对象中，存在自包含的现象"}';
   err_common_104 constant varchar2(4000) := '{"en":"Error occurred when updating the lottery status.","zh":"更新“即开票”状态时，出现错误"}';
   err_common_105 constant varchar2(4000) := '{"en":"Wrong operation parameter, must be 1, 2 or 3.","zh":"操作类型参数错误，应该为1，2，3"}';
   err_common_106 constant varchar2(4000) := '{"en":"Wrong operation parameter, must be 1, 2 or 3.","zh":"操作类型参数错误，应该为1，2，3"}';
   err_common_107 constant varchar2(4000) := '{"en":"The batches of this plan are disabled.","zh":"此方案的批次处于非可用状态"}';
   err_common_108 constant varchar2(4000) := '{"en":"The plan or batch data is empty.","zh":"方案或批次数据为空"}';
   err_common_109 constant varchar2(4000) := '{"en":"No lottery object found in the input parameters.","zh":"输入参数中，没有发现彩票对象"}';

   err_f_check_ticket_include_1 constant varchar2(4000) := '{"en":"This lottery trunk has already been processed.","zh":"此箱彩票已经被处理"}';
   err_f_check_ticket_include_2 constant varchar2(4000) := '{"en":"This lottery box has already been processed.","zh":"此盒彩票已经被处理"}';
   err_f_check_ticket_include_3 constant varchar2(4000) := '{"en":"This lottery pack has already been processed.","zh":"此本彩票已经被处理"}';

   err_p_item_delete_1 constant varchar2(4000) := '{"en":"Item code cannot be empty.","zh":"物品编码不能为空"}';
   err_p_item_delete_2 constant varchar2(4000) := '{"en":"The item does not exist.","zh":"不存在此物品"}';
   err_p_item_delete_3 constant varchar2(4000) := '{"en":"This item currently exists in inventory.","zh":"该物品当前有库存"}';

   err_p_withdraw_approve_1 constant varchar2(4000) := '{"en":"Withdraw code cannot be empty.","zh":"提现编码不能为空"}';
   err_p_withdraw_approve_2 constant varchar2(4000) := '{"en":"The withdraw code does not exist or the withdraw record is disabled.","zh":"提现编码不存在或单据状态无效！"}';
   err_p_withdraw_approve_3 constant varchar2(4000) := '{"en":"Permission denied for cash withdraw approval.","zh":"审批结果超出定义范围！"}';
   err_p_withdraw_approve_4 constant varchar2(4000) := '{"en":"Insufficient balance.","zh":"余额不足！"}';
   err_p_withdraw_approve_5 constant varchar2(4000) := '{"en":"outlet cash withdraw failure.","zh":"销售站资金处理失败！"}';

   err_p_item_outbound_1 constant varchar2(4000) := '{"en":"This item currently does not exist in inventory.","zh":"该物品当前无库存"}';
   err_p_item_outbound_2 constant varchar2(4000) := '{"en":"This item is not enough in inventory.","zh":"该物品在库存不足"}';

   err_p_item_damage_1 constant varchar2(4000) := '{"en":"Item code cannot be empty.","zh":"物品编码不能为空"}';
   err_p_item_damage_2 constant varchar2(4000) := '{"en":"Warehouse code cannot be empty.","zh":"仓库编码不能为空"}';
   err_p_item_damage_3 constant varchar2(4000) := '{"en":"Damage quantity must be positive.","zh":"损毁物品数量必须为正数"}';
   err_p_item_damage_4 constant varchar2(4000) := '{"en":"The operator does not exist.","zh":"损毁登记人不存在"}';
   err_p_item_damage_5 constant varchar2(4000) := '{"en":"The item does not exist or is deleted.","zh":"该物品不存在或已删除"}';
   err_p_item_damage_6 constant varchar2(4000) := '{"en":"The warehouse does not exist or is deleted.","zh":"该仓库不存在或已删除"}';
   err_p_item_damage_7 constant varchar2(4000) := '{"en":"The item does not exist in this warehouse.","zh":"该仓库中不存在此物品"}';
   err_p_item_damage_8 constant varchar2(4000) := '{"en":"The item quantity in this warehouse is less than the input damage quantity.","zh":"该仓库中此物品的数量小于登记损毁的数量"}';

   err_p_ar_outbound_10 constant varchar2(4000) := '{"en":"Cannot refund this ticket because paid tickets may exist.","zh":"有彩票已经兑奖，不能退票"}';
   err_p_ar_outbound_20 constant varchar2(4000) := '{"en":"The corresponding trunk data is missing from the lottery receipt.","zh":"对应的箱数据，没有在入库单中找到"}';
   err_p_ar_outbound_30 constant varchar2(4000) := '{"en":"The corresponding box data is missing from the lottery receipt.","zh":"对应的盒数据，没有在入库单中找到"}';
   err_p_ar_outbound_40 constant varchar2(4000) := '{"en":"The corresponding pack data is missing from the lottery receipt.","zh":"对应的本数据，没有在入库单中找到"}';
   err_p_ar_outbound_50 constant varchar2(4000) := '{"en":"The corresponding trunk data has been found in the receipt, but its status or its outlet information is incorrect.","zh":"对应的箱数据已经在入库单中找到，但是状态或者所属站点信息不正确"}';
   err_p_ar_outbound_60 constant varchar2(4000) := '{"en":"Cannot find the sales record of the refunding ticket.","zh":"未查询到待退票的售票记录"}';
   err_p_ar_outbound_70 constant varchar2(4000) := '{"en":"Exceeds the \"maximum allowable credit\" as held by this manager.","zh":"超过此管理员允许持有的“最高赊票金额”"}';

   err_p_ticket_perferm_1   constant varchar2(4000) := '{"en":"This warehouse is stopped or is in checking. This operation is denied.","zh":"此仓库状态处于盘点或停用状态，不能进行出入库操作"}';
   err_p_ticket_perferm_3   constant varchar2(4000) := '{"en":"The plan of this batch does not exist in the system.","zh":"系统中不存在此批次的彩票方案"}';
   err_p_ticket_perferm_5   constant varchar2(4000) := '{"en":"The plan of this batch has already been disabled.","zh":"此批次的彩票方案已经停用"}';
   err_p_ticket_perferm_10  constant varchar2(4000) := '{"en":"This lottery trunk does not exist.","zh":"此箱彩票不存在"}';
   err_p_ticket_perferm_110 constant varchar2(4000) := '{"en":"This lottery box does not exist.","zh":"此盒彩票不存在"}';
   err_p_ticket_perferm_120 constant varchar2(4000) := '{"en":"The status of this lottery \"Box\" is not as expected, current status: ","zh":"此“盒”彩票的状态与预期不符，当前状态为"}';
   err_p_ticket_perferm_130 constant varchar2(4000) := '{"en":"The system status of this lottery \"Box\" is OPEN, therefore trunk-wise processing is not allowed.","zh":"此“盒”彩票在系统中处于开箱状态，因此不能进行整箱处理"}';
   err_p_ticket_perferm_140 constant varchar2(4000) := '{"en":"Error may exist in the inventory information of this lottery \"Box\", please double-check before proceed.","zh":"此“盒”彩票库存信息可能存在错误，请查询以后再进行操作"}';
   err_p_ticket_perferm_150 constant varchar2(4000) := '{"en":"Exception occurred during lottery processing, please contact the system maintenance for support.","zh":"处理彩票时，出现数据异常，请联系系统人员"}';
   err_p_ticket_perferm_160 constant varchar2(4000) := '{"en":"Exception occurred in the \"Pack\" data when processing a \"Box\". Possible errors include: 1-Some packs in this box have been removed, 2-The status of some packs in this box is not as expected.","zh":"处理“盒”时，“本”数据出现异常。可能的错误为：1-此盒对应的某些本已经被转移，2-此盒对应的某些本的状态与预期状态不符"}';
   err_p_ticket_perferm_20  constant varchar2(4000) := '{"en":"The status of this lottery \"Trunk\" is not as expected, current status: ","zh":"此“箱”彩票的状态与预期不符，当前状态为"}';
   err_p_ticket_perferm_210 constant varchar2(4000) := '{"en":"This lottery pack does not exist.","zh":"此本彩票不存在"}';
   err_p_ticket_perferm_220 constant varchar2(4000) := '{"en":"The status of this lottery \"Pack\" is not as expected, current status: ","zh":"此“本”彩票的状态与预期不符，当前状态为"}';
   err_p_ticket_perferm_230 constant varchar2(4000) := '{"en":"Error may exist in the inventory information of this lottery \"Pack\", please double-check before proceed.","zh":"此“本”彩票库存信息可能存在错误，请查询以后再进行操作"}';
   err_p_ticket_perferm_240 constant varchar2(4000) := '{"en":"Exception occurred during lottery processing, please contact the system maintenance for support.","zh":"处理彩票时，出现数据异常，请联系系统人员"}';
   err_p_ticket_perferm_30  constant varchar2(4000) := '{"en":"The system status of this lottery \"Trunk\" is OPEN, therefore trunk-wise processing is not allowed.","zh":"此“箱”彩票在系统中处于开箱状态，因此不能进行整箱处理"}';
   err_p_ticket_perferm_40  constant varchar2(4000) := '{"en":"Error may exist in the inventory information of this lottery \"Trunk\", please double-check before proceed.","zh":"此“箱”彩票库存信息可能存在错误，请查询以后再进行操作"}';
   err_p_ticket_perferm_50  constant varchar2(4000) := '{"en":"Exception occurred during lottery processing, please contact the system maintenance for support.","zh":"处理彩票时，出现数据异常，请联系系统人员"}';
   err_p_ticket_perferm_60  constant varchar2(4000) := '{"en":"Exception occurred in the \"Box\" data when processing a \"Trunk\". Possible errors include: 1-Some boxes in this trunk have been opened for use, 2-Some boxes in this trunk have been removed, 3-The status of some boxes in this trunk is not as expected.","zh":"处理“箱”时，“盒”数据出现异常。可能的错误为：1-此箱对应的某些盒已经被拆开使用，2-此箱对应的某些盒已经被转移，3-此箱对应的某些盒的状态与预期状态不符"}';
   err_p_ticket_perferm_70  constant varchar2(4000) := '{"en":"Exception occurred in the \"Box\" data when processing a \"Trunk\". Possible errors include: 1-Some packs in this trunk have been removed, 2-The status of some packs in this trunk is not as expected.","zh":"处理“箱”时，“盒”数据出现异常。可能的错误为：1-此箱对应的某些本已经被转移，2-此箱对应的某些本的状态与预期状态不符"}';

   err_f_get_sys_param_1    constant varchar2(4000) := '{"en":"The system parameter is not set. parameter: ","zh":"系统参数未被设置，参数编号为："}';

   err_p_teller_create_1    constant varchar2(4000) := '{"en":"Invalid Agency Code!","zh":"无效的销售站"}';
   err_p_teller_create_2    constant varchar2(4000) := '{"en":"The teller code is already used.","zh":"销售员编号重复"}';
   err_p_teller_create_3    constant varchar2(4000) := '{"en":"The teller code is out of the range.","zh":"输入的编码超出范围！"}';

   err_p_teller_status_change_1  constant varchar2(4000) := '{"en":"Invalid teller status!","zh":"无效的状态值"}';
   err_p_teller_status_change_2  constant varchar2(4000) := '{"en":"Invalid teller Code!","zh":"销售员不存在"}';

end;
/

CREATE OR REPLACE PACKAGE epublisher_code IS
   /****** 印制厂商 ******/
   /****** 1、箱码长度  ******/
   /****** 2、盒码长度  ******/
   /****** 3、本码长度  ******/
   /****** 4、票码长度  ******/
   sjz                /* 石家庄 */                    CONSTANT NUMBER := 1;
   zc3c               /* 中彩三场 */                  CONSTANT NUMBER := 3;
END;
/

create or replace procedure p_get_lottery_reward
/****************************************************************/
   ------------------- 彩票中奖查询 -------------------
   ---- 查询输入的彩票是否中奖，并且返回中奖信息
   ---- add by 陈震: 2015/9/21
   ---- 业务流程：
   ----     1、校验输入参数。（方案批次是否存在，有效位数是否正确；）
   ----     2、查询2.1.4.7 批次信息导入之中奖明细（game_batch_reward_detail）表，是否有记录，有则中奖
   ----     3、截取奖符，去2.1.4.6 批次信息导入之奖符（game_batch_import_reward）中进行查询，获取中奖等级和中奖金额
   ---- modify by dzg :2015/10/21
   ---- 返回一个结果 : 0中奖 1大奖 2 未中奖 3 已兑奖 4 未销售或无效
   ---- 未销售没有返回4

   /*************************************************************/
(
 --------------输入----------------
  p_plan                               in char,             -- 方案编号
  p_batch                              in char,             -- 批次编号
  p_package_no                         in varchar2,         -- 彩票本号
  p_security_string                    in char,             -- 保安区码（21位）
  p_level                              in number,           -- 兑奖级别（1=站点、2=分公司、3=总公司）
 ---------出口参数---------
  c_reward_level                       out number,          -- 中奖奖级
  c_reward_amount                      out number,          -- 中奖金额
  c_reward_result                      out number,          -- 票中奖结果，用于POS端使用
  c_errorcode                          out number,          -- 错误编码
  c_errormesg                          out string           -- 错误原因

 ) is

   v_count                             number(2);           -- 记录数
   v_sys_parameter                     varchar2(100);       -- 系统参数
   v_is_new_ticket                     number(1);           -- 是否新票

   v_safe_code                         varchar2(50);        -- 兑奖码
   v_publish_code                      number(2);           -- 厂商编码

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   c_reward_level := 0;
   c_reward_amount := 0;
   c_reward_result := 2;
   v_is_new_ticket := eboolean.noordisabled;

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if f_get_reward_ticket_ver(p_plan, p_batch, p_package_no) = 0 then
      if not f_check_plan_batch(p_plan, p_batch) then
         c_errorcode := 1;
         c_errormesg := dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || error_msg.err_common_102; -- 无此方案和批次
         return;
      end if;

      -- 判断彩票是否销售
      v_count := 0;
      select count(*)
        into v_count
        from wh_ticket_package
       where plan_code = p_plan
         and batch_no = p_batch
         and package_no = p_package_no
         and status = eticket_status.saled;
      if v_count <= 0 then
         c_reward_result := 4;
         return;
      end if;
   end if;
   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* 查询2.1.4.7 批次信息导入之中奖明细（game_batch_reward_detail）表，是否有记录，有则中奖 *************************/
   v_publish_code := f_get_plan_publisher(p_plan);
   case
      when v_publish_code = epublisher_code.sjz then
         begin
            select safe_code
              into v_safe_code
              from game_batch_reward_detail
             where plan_code = p_plan
               and batch_no = p_batch
               and safe_code = p_security_string;

         exception
            when no_data_found then
               v_count := 0;
         end;

      when v_publish_code = epublisher_code.zc3c then
         begin
            select safe_code
              into v_safe_code
              from game_batch_reward_detail
             where plan_code = p_plan
               and batch_no = p_batch
               and pre_safe_code = substr(p_security_string, 1, 16);

         exception
            when no_data_found then
               v_count := 0;
         end;

   end case;

   if v_count = 1 then
      --已中奖
      c_reward_result := 0;

      select reward_no, single_reward_amount
        into c_reward_level, c_reward_amount
        from game_batch_import_reward
       where plan_code = p_plan
         and batch_no = p_batch
         and instr(fast_identity_code, substr(v_safe_code, epublisher_sjz.fast_identity_code_pos, epublisher_sjz.len_fast_identity_code)) > 0;

      --判断是否已兑奖
      select count(*)
        into v_count
        from flow_pay
       where plan_code = p_plan
         and batch_no = p_batch
         and security_code = p_security_string;
      if v_count = 1 then
         c_reward_result := 3;
      else
        --大奖
        case
           -- 兑奖级别（1=站点、2=分公司、3=总公司）
           when p_level = 1 then
              if c_reward_amount >= to_number(f_get_sys_param(5)) then
                 c_reward_result := 1;
              end if;

           when p_level = 2 then
              if c_reward_amount >= to_number(f_get_sys_param(6)) then
                 if f_get_sys_param(7) = '1' then
                    c_reward_result := 1;
                 end if;
              end if;
           when p_level = 3 then
              return;
           else
              c_errorcode := 1;
              c_errormesg := error_msg.err_common_106;
              return;
        end case;
      end if;
   end if;

exception
   when others then
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
/

CREATE OR REPLACE PROCEDURE p_import_batch_file
/****************************************************************/
   ------------------- 适用于导入批次数据文件 -------------------
   ---- 导入批次数据文件
   ---- add by 陈震: 2015/9/9
   ---- 业务流程：页面中保存数据以后，调用此存储过程，用来导入数据文件
   ----           1、查找  批次信息导入（GAME_BATCH_IMPORT）表，获取文件名
   ----           2、建立扩展表，包装信息、奖符信息、中奖明细信息，
   /*************************************************************/
(
 --------------输入----------------
 p_plan_code in char, -- 方案代码
 p_batch_no  in char, -- 生产批次
 p_oper      IN number, --

 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因

 ) AUTHID CURRENT_USER IS

   v_count number(5);

   v_file_name_package VARCHAR2(500); -- 包装信息文件名
   v_file_name_map     VARCHAR2(500); -- 奖符信息文件名
   v_file_name_reward  VARCHAR2(500); -- 中奖明细信息文件名
   v_import_no         VARCHAR2(12); -- 数据导入编号

   v_table_name varchar2(100); -- 导数据的临时表
   v_sql        varchar2(10000); -- 动态SQL语句

   v_file_plan  varchar2(100); -- 第1行方案代码
   v_file_batch varchar2(100); -- 第5行生产批次

   v_bind_1  varchar2(100); -- 第1行方案代码
   v_bind_2  varchar2(100); -- 第2行彩票分类
   v_bind_3  varchar2(100); -- 第3行彩票名称
   v_bind_4  varchar2(100); -- 第4行单票金额
   v_bind_5  varchar2(100); -- 第5行生产批次
   v_bind_6  varchar2(100); -- 第6行每组箱数
   v_bind_7  varchar2(100); -- 第7行每箱本数
   v_bind_8  varchar2(100); -- 第8行每本张数
   v_bind_9  varchar2(100); -- 第9行奖组张数（万张）
   v_bind_10 varchar2(100); -- 第10行首分组号
   v_bind_11 varchar2(100); -- 第11行生产厂家
   v_bind_12 varchar2(100); -- 第12行单箱重量
   v_bind_13 varchar2(100); -- 第13行总票数
   v_bind_14 varchar2(100); -- 第14行首箱编号（例如“00001”）
   v_bind_15 varchar2(100); -- 第15行每箱盒数

   v_plan_publish          number(1);                                      -- 印制厂商编号

   v_tab_reward            game_batch_import_reward%rowtype;
   v_first_line            boolean;

BEGIN

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   select count(*)
     into v_count
     from dual
    where exists (select 1
             from GAME_BATCH_IMPORT
            where PLAN_CODE = p_plan_code
              and BATCH_NO = p_batch_no);
   IF v_count = 1 THEN
      c_errorcode := 1;
      c_errormesg := error_msg.ERR_P_IMPORT_BATCH_FILE_1; -- 批次数据信息已经存在
      RETURN;
   END IF;

   /**********************************************************/
   /******************* 插入导入信息表 *************************/
   v_file_name_package := 'PACKAGE-' || p_plan_code || '_' || p_batch_no || '.imp';
   v_file_name_map     := 'MAP-' || p_plan_code || '_' || p_batch_no || '.imp';
   v_file_name_reward  := 'REWARD-' || p_plan_code || '_' || p_batch_no || '.imp';

   insert into game_batch_import
      (import_no,
       plan_code,
       batch_no,
       package_file,
       reward_map_file,
       reward_detail_file,
       start_date,
       end_date,
       import_admin)
   values
      (f_get_batch_import_seq,
       p_plan_code,
       p_batch_no,
       v_file_name_package,
       v_file_name_map,
       v_file_name_reward,
       sysdate,
       null,
       p_oper)
   returning import_no into v_import_no;

   /**********************************************************/
   /******************* 导入包装信息 *************************/
   -- 删除原有数据
   -- delete from GAME_BATCH_IMPORT_DETAIL where PLAN_CODE = p_plan_code and BATCH_NO = p_batch_no;

   -- 建立外部表，使用统一的表名 ext_kws_import。导入之前，确定是否存在这张表，存在就删除。
   v_table_name := 'ext_kws_import';
   SELECT COUNT(*)
     INTO v_count
     FROM user_tables
    WHERE table_name = upper(v_table_name);
   IF v_count = 1 THEN
      v_sql := 'drop table ' || v_table_name;
      EXECUTE IMMEDIATE v_sql;
   END IF;

   -- 拼接导入SQL，并开始导入数据
   v_sql := 'create table ' || v_table_name || ' (tmp_col VARCHAR2(100)) ';
   v_sql := v_sql || 'ORGANIZATION EXTERNAL';
   v_sql := v_sql || '  (TYPE ORACLE_LOADER ';
   v_sql := v_sql || '   DEFAULT DIRECTORY impdir';
   v_sql := v_sql || '   ACCESS PARAMETERS ';
   v_sql := v_sql || '      (RECORDS DELIMITED BY NEWLINE';
   v_sql := v_sql || '       LOAD WHEN (tmp_col != BLANKS))';
   v_sql := v_sql || '   LOCATION (''' || v_file_name_package || ''')';
   v_sql := v_sql || '  )';
   EXECUTE IMMEDIATE v_sql;

   -- 先获取包装文件中的所含数据内容
   -- 以下内容，摘自 “SVN\doc\11Reference\现场包装编码规则\说明文件.docx”
   v_sql := 'select * from (select rownum cnt, tmp_col from ext_kws_import) pivot(max(tmp_col) for cnt in(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15))';
   EXECUTE IMMEDIATE v_sql
      into v_bind_1, v_bind_2, v_bind_3, v_bind_4, v_bind_5, v_bind_6, v_bind_7, v_bind_8, v_bind_9, v_bind_10, v_bind_11, v_bind_12, v_bind_13, v_bind_14, v_bind_15;

   -- 判断文件中的数据，与待导入的数据是否一致
   if (v_file_plan <> p_plan_code) or (v_file_batch <> p_batch_no) then
      rollback;
      c_errorcode := 2;
      c_errormesg := error_msg.ERR_P_IMPORT_BATCH_FILE_2; -- 文件中的方案与批次信息同导入记录中内容不符
      RETURN;
   end if;

   -- 插入数据
   insert into GAME_BATCH_IMPORT_DETAIL
      (IMPORT_NO,
       PLAN_CODE,
       BATCH_NO,
       LOTTERY_TYPE,
       LOTTERY_NAME,
       BOXES_EVERY_TRUNK,
       TRUNKS_EVERY_GROUP,
       PACKS_EVERY_TRUNK,
       TICKETS_EVERY_PACK,
       TICKETS_EVERY_GROUP,
       FIRST_REWARD_GROUP_NO,
       TICKETS_EVERY_BATCH,
       FIRST_TRUNK_BATCH,
       STATUS)
   values
      (v_import_no,
       p_plan_code,
       p_batch_no,
       v_bind_2,
       v_bind_3,
       to_number(replace(v_bind_15,chr(13),'')),
       to_number(replace(v_bind_6,chr(13),'')),
       to_number(replace(v_bind_7,chr(13),'')),
       to_number(replace(v_bind_8,chr(13),'')),
       to_number(replace(v_bind_9,chr(13),'')) * 10000,
       to_number(replace(v_bind_10,chr(13),'')),
       to_number(replace(v_bind_13,chr(13),'')),
       to_number(replace(v_bind_14,chr(13),'')),
       ebatch_item_status.working);

   -- 删除临时表
   v_sql := 'drop table ' || v_table_name;
   EXECUTE IMMEDIATE v_sql;

   /**********************************************************/
   /******************* 导入奖符信息 *************************/
   -- 删除原有数据
   delete from GAME_BATCH_IMPORT_REWARD where PLAN_CODE = p_plan_code and BATCH_NO = p_batch_no;

   -- 拼接导入SQL，并开始导入数据
   v_sql := 'create table ' || v_table_name ||
            ' (REWARD_NO VARCHAR2(10),FAST_IDENTITY_CODE VARCHAR2(20),SINGLE_REWARD_AMOUNT VARCHAR2(10),COUNTS VARCHAR2(10)) ';
   v_sql := v_sql || 'ORGANIZATION EXTERNAL';
   v_sql := v_sql || '  (TYPE ORACLE_LOADER ';
   v_sql := v_sql || '   DEFAULT DIRECTORY impdir';
   v_sql := v_sql || '   ACCESS PARAMETERS ';
   v_sql := v_sql ||
            '      (RECORDS DELIMITED BY NEWLINE  LOAD WHEN (FAST_IDENTITY_CODE != BLANKS) fields terminated by 0X''09'' missing field values are null )';
   v_sql := v_sql || '   LOCATION (''' || v_file_name_map || ''')';
   v_sql := v_sql || '  )';
   EXECUTE IMMEDIATE v_sql;

   v_sql := 'truncate table tmp_batch_reward';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'insert into tmp_batch_reward select to_number(replace(REWARD_NO,chr(13),'''')),trim(FAST_IDENTITY_CODE),to_number(replace(SINGLE_REWARD_AMOUNT,chr(13),'''')),to_number(replace(COUNTS,chr(13),'''')) from ' || v_table_name;
   EXECUTE IMMEDIATE v_sql;

   -- 循环外部表，生成数据
   v_first_line := true;
   v_tab_reward.IMPORT_NO := v_import_no;
   v_tab_reward.PLAN_CODE := p_plan_code;
   v_tab_reward.BATCH_NO := p_batch_no;

   for loop_tab in (select * from tmp_batch_reward) loop
      if loop_tab.REWARD_NO is not null then
         if not v_first_line then
            -- 插入上次获取的数据
            insert into GAME_BATCH_IMPORT_REWARD values v_tab_reward;
         end if;

         -- 确保导入的数据，都是瑞尔
         if loop_tab.SINGLE_REWARD_AMOUNT < 1000 then
            rollback;
            delete GAME_BATCH_IMPORT_DETAIL where plan_code = p_plan_code and batch_no=p_batch_no;
            delete GAME_BATCH_IMPORT_REWARD where PLAN_CODE = p_plan_code and BATCH_NO = p_batch_no;
            delete game_batch_import where plan_code = p_plan_code and batch_no=p_batch_no;
            commit;
            raise_application_error(-20001, 'User define error: SINGLE_REWARD_AMOUNT must great 1000');
            return;
         end if;

         v_tab_reward.REWARD_NO := loop_tab.REWARD_NO;
         v_tab_reward.SINGLE_REWARD_AMOUNT := loop_tab.SINGLE_REWARD_AMOUNT;
         v_tab_reward.COUNTS := loop_tab.COUNTS;
         v_tab_reward.FAST_IDENTITY_CODE := loop_tab.FAST_IDENTITY_CODE;
      else
         v_tab_reward.FAST_IDENTITY_CODE := v_tab_reward.FAST_IDENTITY_CODE || ',' || loop_tab.FAST_IDENTITY_CODE;
      end if;

      v_first_line := false;
   end loop;
   -- 处理最后一行数据
   insert into GAME_BATCH_IMPORT_REWARD values v_tab_reward;

   -- 删除临时表
   v_sql := 'drop table ext_kws_import';
   EXECUTE IMMEDIATE v_sql;

   /**********************************************************/
   /******************* 导入奖级信息 *************************/
   -- 删除原有数据
   delete from GAME_BATCH_REWARD_DETAIL where PLAN_CODE = p_plan_code and BATCH_NO = p_batch_no;

   -- 拼接导入SQL，并开始导入数据
   v_sql := 'create table ' || v_table_name || ' (tmp_col VARCHAR2(4000)) ';
   v_sql := v_sql || 'ORGANIZATION EXTERNAL';
   v_sql := v_sql || '  (TYPE ORACLE_LOADER ';
   v_sql := v_sql || '   DEFAULT DIRECTORY impdir';
   v_sql := v_sql || '   ACCESS PARAMETERS ';
   v_sql := v_sql || '      (RECORDS DELIMITED BY NEWLINE' ;
   v_sql := v_sql || '       LOAD WHEN (tmp_col != BLANKS) ';
   v_sql := v_sql || '       fields (';
   v_sql := v_sql || '          tmp_col CHAR(4000) ';
   v_sql := v_sql || '       )';
   v_sql := v_sql || '      )';
   v_sql := v_sql || '   LOCATION (''' || v_file_name_reward || ''')';
   v_sql := v_sql || '  )';
   EXECUTE IMMEDIATE v_sql;

   -- 插入数据
   v_sql := 'insert into GAME_BATCH_REWARD_DETAIL (IMPORT_NO, PLAN_CODE, BATCH_NO, SAFE_CODE) ';
   v_sql := v_sql || 'select ''' || v_import_no || ''',';
   v_sql := v_sql || '       ''' || p_plan_code || ''',';
   v_sql := v_sql || '       ''' || p_batch_no || ''',';
   v_sql := v_sql || '       tmp_col from ext_kws_import';
   EXECUTE IMMEDIATE v_sql;

   -- 设置结束时间字段
   update GAME_BATCH_IMPORT
      set END_DATE = sysdate
    where IMPORT_NO = v_import_no;

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      delete GAME_BATCH_IMPORT_DETAIL where plan_code = p_plan_code and batch_no=p_batch_no;
      delete GAME_BATCH_IMPORT_REWARD where PLAN_CODE = p_plan_code and BATCH_NO = p_batch_no;
      delete GAME_BATCH_REWARD_DETAIL where PLAN_CODE = p_plan_code and BATCH_NO = p_batch_no;
      delete game_batch_import where plan_code = p_plan_code and batch_no=p_batch_no;
      commit;
      c_errorcode := 1;
      c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
/

create or replace procedure p_lottery_reward
/****************************************************************/
   ------------------- 兑奖 -------------------
   ---- 兑奖
   ----     判断此张彩票是否已经销售，没有的话，就不能兑奖；
   ----     查询兑奖记录，判断此张彩票是否已经进行过兑奖，如果已经兑奖，返回失败；
   ----     更新“2.1.4.7 批次信息导入之中奖明细（game_batch_reward_detail）”，更新“2.1.4.6 批次信息导入之奖符（game_batch_import_reward）”，计数器+1；
   ----     获取此彩票的彩票包装信息和奖组，以及此彩票的中奖金额，还有彩票的销售站点；
   ----     新建“兑奖记录”，如果兑奖方式为“1=中心兑奖，2=手工兑奖”时，还需要新建“2.1.7.1 gui兑奖信息记录表（flow_gui_pay）”
   ----     如果是“站点兑奖”，那么，按照单票金额计算兑奖代销费，给兑奖站点加“兑奖金额”和“兑奖佣金”；如果是“中心兑奖”，那么要视系统参数（2），决定是否给销售彩票的销售站增加“兑奖佣金”；


   ---- add by 陈震: 2015/9/21
   ---- 涉及的业务表：
   ----     2.1.4.6 批次信息导入之奖符（game_batch_import_reward）                     -- 更新
   ----     2.1.4.7 批次信息导入之中奖明细（game_batch_reward_detail）                 -- 更新
   ----     2.1.7.1 gui兑奖信息记录表（flow_gui_pay）                                  -- 新增
   ----     2.1.7.2 兑奖记录（flow_pay）                                               -- 新增
   ----     2.1.7.4 站点资金流水（flow_agency）                                        -- 新增

   ---- 业务流程：
   ----     1、校验输入参数。（仓库是否存在；操作类型是否为新、继续、完结；操作人是否合法；）
   ----     2、判断此张彩票是否已经销售，没有的话，就不能兑奖；
   ----     3、查询兑奖记录，判断此张彩票是否已经进行过兑奖，如果已经兑奖，返回失败；
   ----     4、更新

   ---- modify by 陈震 2016-01-22
   ---- 1、增加兑奖机构佣金表，保存兑奖时，产生的机构佣金数据
   ---- 2、站点兑奖和一级机构兑奖，无条件加佣金，总机构不计算佣金
   ---- 3、是否产生兑奖佣金，要看系统参数 16 是否计算分公司中心兑奖佣金（1=计算，2=不计算）；针对代理商的销售站，必须产生机构佣金记录

   ---- modify by 陈震 2016-02-26
   ---- 1、增加印制厂商判断。当方案为石家庄时，录入的安全码为全部安全码，可以直接在数据库中查询；如果方案为中彩三场，那么录入的安全码只获取前16位，然后查询其中奖标示，获取奖等。

   /*************************************************************/
(
  --------------输入----------------
  p_security_string                    in char,                               -- 保安区码（21位）
  p_name                               in char,                               -- 中奖人姓名
  p_contact                            in char,                               -- 中奖人联系方式
  p_id                                 in char,                               -- 中奖人证件号码
  p_age                                in number,                             -- 年龄
  p_sex                                in number,                             -- 性别(1-男，2-女)
  p_paid_type                          in number,                             -- 兑奖方式（1=中心兑奖，2=手工兑奖，3=站点兑奖）
  p_plan                               in char,                               -- 方案编号
  p_batch                              in char,                               -- 批次编号
  p_package_no                         in varchar2,                           -- 彩票本号
  p_ticket_no                          in varchar2,                           -- 票号
  p_oper                               in number,                             -- 操作人
  p_pay_agency                         in char,                               -- 兑奖销售站
  p_pay_time                           in date,                               -- 兑奖时间

  ---------出口参数---------
  c_reward_amount                      out number,                           -- 兑奖金额
  c_pay_flow                           out char,                             -- 兑奖序号
  c_errorcode                          out number,                           -- 错误编码
  c_errormesg                          out string                            -- 错误原因

 ) is

   v_count                 number(5);                                      -- 求记录数的临时变量
   v_agency                char(8);                                        -- 售票销售站

   v_reward_amount         number(18);                                     -- 奖金
   v_reward_level          number(2);                                      -- 奖级
   v_pay_flow              char(24);                                       -- 兑奖流水号

   v_comm_amount           number(18);                                     -- 彩票销售，销售站兑奖佣金
   v_comm_rate             number(18);                                     -- 彩票销售，销售站兑奖佣金比例

   v_single_ticket_amount  number(10);                                     -- 单票金额
   v_lottery_detail        type_lottery_info;                              -- 彩票对象详细信息

   v_area_code             char(4);                                        -- 站点所属区域
   v_admin_realname        varchar2(1000);                                 -- 操作人员名称

   v_sys_param             varchar2(10);                                   -- 系统参数值

   v_balance               number(28);                                     -- 账户余额
   v_f_balance             number(28);                                     -- 冻结账户余额

   v_pay_time              date;                                           -- 兑奖时间
   v_is_new_ticket         number(1);                                      -- 是否新票

   v_org                   char(2);                                        -- 组织结构代码
   v_org_type              number(2);                                      -- 组织机构类型

   v_security_string       varchar2(50);                                   -- 安全区码

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   c_reward_amount := 0;
   v_is_new_ticket := eboolean.noordisabled;

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;

   -- 如果是“爱心方案”，按照系统参数判断是否可用
   if p_plan = 'J2014' and f_get_sys_param(15) <> '1' then
      c_errorcode := 3;
      c_errormesg := dbtool.format_line(p_plan) || dbtool.format_line('00001') || error_msg.err_p_ticket_perferm_5; -- 此批次的彩票方案已经停用
      return;
   end if;

   -- 如果是新票，那么需要检查以下数据
   if f_get_reward_ticket_ver(p_plan, p_batch, p_package_no) = 0 then

      -- 检查批次是否正确
      if not f_check_plan_batch(p_plan, p_batch) then
         c_errorcode := 2;
         c_errormesg := dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || error_msg.err_common_102; -- 无此方案和批次
         return;
      end if;

      -- 检查方案批次是否有效
      if not f_check_plan_batch_status(p_plan, p_batch) then
         c_errorcode := 3;
         c_errormesg := dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || error_msg.err_p_ticket_perferm_5; -- 此批次的彩票方案已经停用
         return;
      end if;

      v_is_new_ticket := eboolean.yesorenabled;

   end if;
   /*----------- 业务逻辑   -----------------*/
   -- 设置默认的兑奖时间
   if p_pay_time is null then
      v_pay_time := sysdate;
   else
      v_pay_time := p_pay_time;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* 判断此张彩票是否已经销售，没有的话，就不能兑奖 *************************/

   -- 获取彩票详细信息
   if v_is_new_ticket = eboolean.yesorenabled then
      v_lottery_detail := f_get_lottery_info(p_plan, p_batch, evalid_number.pack, p_package_no);
   else
      -- 针对旧票，数据统一填写“-”
      v_lottery_detail := type_lottery_info(p_plan, p_batch, evalid_number.pack, '-', '-', '-', p_package_no, p_package_no, 0);
   end if;

   -- 如果是新票，那么需要检查以下数据
   if v_is_new_ticket = eboolean.yesorenabled then

      -- 判断彩票是否销售
      begin
         select current_warehouse
           into v_agency
           from wh_ticket_package
          where plan_code = p_plan
            and batch_no = p_batch
            and package_no = p_package_no
            and p_ticket_no >= ticket_no_start
            and p_ticket_no <= ticket_no_end
            and status = eticket_status.saled;
      exception
         when no_data_found then
            c_errorcode := 4;
            c_errormesg := dbtool.format_line(p_package_no) || error_msg.err_p_lottery_reward_3;                       -- 彩票未被销售
            return;
      end;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* 查询兑奖记录，判断此张彩票是否已经进行过兑奖，如果已经兑奖，返回失败 *************************/
   select count(*)
     into v_count
     from flow_pay
    where plan_code = p_plan
      and batch_no = p_batch
      and security_code = p_security_string;
   if v_count = 1 then
      c_errorcode := 5;
      c_errormesg := dbtool.format_line(p_ticket_no) || error_msg.err_p_lottery_reward_4;                       -- 彩票已兑奖
      return;
   end if;

   /********************************************************************************************************************************************************************/
   case f_get_plan_publisher(p_plan)
      when epublisher_code.sjz then
         -- 更新计数器和标志
         update game_batch_reward_detail
            set is_paid = eboolean.yesorenabled
          where plan_code = p_plan
            and batch_no = p_batch
            and safe_code = p_security_string;

         -- 获取奖级和奖金
         select single_reward_amount, reward_no
           into v_reward_amount, v_reward_level
           from game_batch_import_reward
          where plan_code = p_plan
            and batch_no = p_batch
            and instr(fast_identity_code, substr(p_security_string, epublisher_sjz.fast_identity_code_pos, epublisher_sjz.len_fast_identity_code)) > 0;

      when epublisher_code.zc3c then
         -- 更新计数器和标志
         update game_batch_reward_detail
            set is_paid = eboolean.yesorenabled
          where plan_code = p_plan
            and batch_no = p_batch
            and pre_safe_code = substr(p_security_string, 1, 16)
         returning safe_code into v_security_string;

         -- 获取奖级和奖金
         select single_reward_amount, reward_no
           into v_reward_amount, v_reward_level
           from game_batch_import_reward
          where plan_code = p_plan
            and batch_no = p_batch
            and instr(fast_identity_code, substr(v_security_string, epublisher_sjz.fast_identity_code_pos, epublisher_sjz.len_fast_identity_code)) > 0;

   end case;




   /********************************************************************************************************************************************************************/
   /******************* 进入数据计算 *************************/
   -- 获取单票金额
   begin
      select ticket_amount
        into v_single_ticket_amount
        from game_plans
       where plan_code = p_plan;
   exception
      when no_data_found then
         v_single_ticket_amount := 0;
   end;

   -- 获取操作人员名字
   begin
      select admin_realname into v_admin_realname from adm_info where admin_id = p_oper;
   exception
      when no_data_found then
         v_admin_realname := '';
   end;

   -- 获取系统参数2（中心兑奖，代销费属于“1-销售站点，2-不计算”）
   v_sys_param := f_get_sys_param(2);
   if v_sys_param not in ('1', '2') then
      rollback;
      c_errorcode := 6;
      c_errormesg := dbtool.format_line(v_agency) || dbtool.format_line(p_plan) || error_msg.err_p_lottery_reward_5; -- 系统参数值不正确，请联系管理员，重新设置
      return;
   end if;

   -- 中心兑奖不需要销售站
   if p_paid_type <> 1 then
      -- 获取站点的兑奖佣金比例
      v_comm_rate := f_get_agency_comm_rate(p_pay_agency, p_plan, p_batch, 2);
      if v_comm_rate = -1 then
         rollback;
         c_errorcode := 7;
         c_errormesg := dbtool.format_line(p_pay_agency) || dbtool.format_line(p_plan) || error_msg.err_p_lottery_reward_6; -- 该销售站未设置此方案对应的兑奖佣金比例
         return;
      end if;
   end if;

   case p_paid_type
      when 3 then                                                       -- 销售站兑奖
         -- 计算兑奖代销费
         v_comm_amount := trunc(v_reward_amount * v_comm_rate / 1000);

         -- 获取销售站对应的区域码
         select area_code into v_area_code from inf_agencys where agency_code = p_pay_agency;

         -- 建立兑奖记录
         insert into flow_pay
           (pay_flow,                  pay_agency,              area_code,                      pay_comm,       pay_comm_rate,
            plan_code,                 batch_no,                reward_group,
            trunk_no,                  box_no,                  package_no,                     ticket_no,      security_code,
            pay_amount,                lottery_amount,          pay_time,                       is_center_paid,
            comm_amount,               comm_rate,               reward_no)
         values
           (f_get_flow_pay_seq,        p_pay_agency,            v_area_code,                    v_comm_amount,  v_comm_rate,
            p_plan,                    p_batch,                 v_lottery_detail.reward_group,
            v_lottery_detail.trunk_no, v_lottery_detail.box_no, p_package_no,                   p_ticket_no,    p_security_string,
            v_reward_amount,           v_single_ticket_amount,  v_pay_time,                     p_paid_type,
            v_comm_amount,             v_comm_rate,             v_reward_level)
         returning
            pay_flow
         into
            v_pay_flow;

         -- 给兑奖销售站加“奖金”和“兑奖代销费”
         p_agency_fund_change(p_pay_agency, eflow_type.paid, v_reward_amount, 0, v_pay_flow, v_balance, v_balance);
         p_agency_fund_change(p_pay_agency, eflow_type.pay_comm, v_comm_amount, 0, v_pay_flow, v_balance, v_f_balance);


         -- add @ 2016-01-22 by 陈震
         -- 机构佣金记录
         /** 机构所属销售站兑奖，需要按照兑奖销售站所属机构级别来计算是否给机构佣金  **/
         /** 对于机构类型是总机构的，一概不给于任何佣金和奖金                        **/
         /** 对于机构类型是分公司的，按照系统参数（16）确定是否给于佣金和奖金        **/
         /** 对于机构类型是代理商的，需要给于佣金和奖金                              **/
         v_org := f_get_flow_pay_org(v_pay_flow);
         v_org_type := f_get_org_type(v_org);
         if (v_org_type <> '00' and v_org_type = eorg_type.company and f_get_sys_param(16) = '1') or (v_org_type = eorg_type.agent) then

            v_comm_rate := f_get_org_comm_rate(v_org, p_plan, p_batch, 2);

            if v_comm_rate = -1 then
               v_comm_rate := 0;
            end if;

            v_comm_amount := v_reward_amount * v_comm_rate / 1000;

            insert into flow_pay_org_comm
              (pay_flow,                  pay_agency,              area_code,
               org_code,                  org_type,                org_pay_comm,                   org_pay_comm_rate,
               plan_code,                 batch_no,                reward_group,                   reward_no,
               trunk_no,                  box_no,                  package_no,                     ticket_no,           security_code,
               pay_amount,                lottery_amount,          pay_time,                       is_center_paid)
            values
              (v_pay_flow,                p_pay_agency,            v_area_code,
               v_org,                     v_org_type,              v_comm_amount,                  v_comm_rate,
               p_plan,                    p_batch,                 v_lottery_detail.reward_group,  v_reward_level,
               v_lottery_detail.trunk_no, v_lottery_detail.box_no, p_package_no,                   p_ticket_no,         p_security_string,
               v_reward_amount,           v_single_ticket_amount,  v_pay_time,                     p_paid_type);

            -- 组织机构增加流水
            -- 奖金
            p_org_fund_change(v_org, eflow_type.org_agency_pay, v_reward_amount, 0, v_pay_flow, v_balance, v_balance);

            -- 佣金
            if v_comm_amount > 0 then
               p_org_fund_change(v_org, eflow_type.org_agency_pay_comm, v_comm_amount, 0, v_pay_flow, v_balance, v_balance);
            end if;

         end if;

      when 2 then                                                       -- 管理员手持机现场兑奖（因为没有现场实际应用，所以一下内容未必正确）

         if v_sys_param = '1' then
            -- 计算兑奖代销费
            v_comm_amount := trunc(v_reward_amount * v_comm_rate / 1000);

            -- 获取销售站对应的区域码
            select area_code into v_area_code from inf_agencys where agency_code = p_pay_agency;

            -- 建立兑奖记录
            insert into flow_pay
              (pay_flow,                  pay_agency,              area_code,                      pay_comm,       pay_comm_rate,
               plan_code,                 batch_no,                reward_group,
               trunk_no,                  box_no,                  package_no,                     ticket_no,      security_code,
               pay_amount,                lottery_amount,          pay_time,                       payer_admin,    payer_name,
               is_center_paid,            comm_amount,             comm_rate,                      reward_no)
            values
              (f_get_flow_pay_seq,        v_agency,                v_area_code,                    v_comm_amount,  v_comm_rate,
               p_plan,                    p_batch,                 v_lottery_detail.reward_group,
               v_lottery_detail.trunk_no, v_lottery_detail.box_no, p_package_no,                   p_ticket_no,    p_security_string,
               v_reward_amount,           v_single_ticket_amount,  v_pay_time,                     p_oper,         v_admin_realname,
               p_paid_type,               v_comm_amount,           v_comm_rate,                    v_reward_level)
            returning
               pay_flow
            into
               v_pay_flow;

            -- 给卖票销售站加“兑奖代销费”
            p_agency_fund_change(v_agency, eflow_type.pay_comm, v_comm_amount, 0, v_pay_flow, v_balance, v_f_balance);

            -- 扣减管理员账户金额，因为管理员已经将奖金直接给付彩民

         else
            -- 建立兑奖记录，不填写站点和佣金相关信息
            insert into flow_pay
              (pay_flow,                 plan_code,               batch_no,     reward_group,
               trunk_no,                 box_no,                  package_no,   ticket_no,      security_code,       reward_no,
               pay_amount,               lottery_amount,          pay_time,     payer_admin,    payer_name,          is_center_paid)
            values
              (f_get_flow_pay_seq,       p_plan,                  p_batch,      v_lottery_detail.reward_group,
              v_lottery_detail.trunk_no, v_lottery_detail.box_no, p_package_no, p_ticket_no,    p_security_string,   v_reward_level,
              v_reward_amount,           v_single_ticket_amount,  v_pay_time,   p_oper,         v_admin_realname,    p_paid_type)
            returning
               pay_flow
            into
               v_pay_flow;
         end if;

      when 1 then                                                       -- 中心兑奖

         -- 增加兑奖记录
         insert into flow_pay
           (pay_flow,                  plan_code,               batch_no,     reward_group,
            trunk_no,                  box_no,                  package_no,   ticket_no,      security_code,       reward_no,
            pay_amount,                lottery_amount,          pay_time,     payer_admin,    payer_name,          is_center_paid)
         values
           (f_get_flow_pay_seq,        p_plan,                  p_batch,      v_lottery_detail.reward_group,
            v_lottery_detail.trunk_no, v_lottery_detail.box_no, p_package_no, p_ticket_no,    p_security_string,   v_reward_level,
            v_reward_amount,           v_single_ticket_amount,  v_pay_time,   p_oper,         v_admin_realname,    p_paid_type)
         returning
            pay_flow
         into
            v_pay_flow;

         -- 新增“中心兑奖记录”
         insert into flow_gui_pay
           (gui_pay_no,             winnername,          gender,                    contact,                   age,
            cert_number,            pay_amount,          pay_time,                  payer_admin,               payer_name,
            plan_code,              batch_no,            trunk_no,                  box_no,                    package_no,
            ticket_no,              security_code,       is_manual,                 pay_flow)
         values
           (f_get_flow_gui_pay_seq, p_name,              p_sex,                     p_contact,                 p_age,
            p_id,                   v_reward_amount,     v_pay_time,                p_oper,                    v_admin_realname,
            p_plan,                 p_batch,             v_lottery_detail.trunk_no, v_lottery_detail.box_no,   p_package_no,
            p_ticket_no,            p_security_string,   eboolean.noordisabled,     v_pay_flow);

         -- add @ 2016-01-22 by 陈震
         /** 中心兑奖，需要按照兑奖的机构级别来计算是否给机构佣金                    **/
         /** 对于机构类型是总机构的，一概不给于任何佣金和奖金                        **/
         /** 对于机构类型是分公司的，按照系统参数（16）确定是否给于佣金和奖金        **/
         /** 对于机构类型是代理商的，需要给于佣金和奖金                              **/

         -- 获取兑奖机构
         v_org := f_get_flow_pay_org(v_pay_flow);
         v_org_type := f_get_org_type(v_org);
         if (v_org_type <> '00' and v_org_type = eorg_type.company and f_get_sys_param(16) = '1') or (v_org_type = eorg_type.agent) then

            -- 获取机构佣金比例
            v_comm_rate := f_get_org_comm_rate(v_org, p_plan, p_batch, 2);

            if v_comm_rate = -1 then
               v_comm_rate := 0;
            end if;

            -- 计算机构佣金金额
            v_comm_amount := v_reward_amount * v_comm_rate / 1000;

            insert into flow_pay_org_comm
              (pay_flow,                  plan_code,               batch_no,                       reward_group,
               org_code,                  org_type,                org_pay_comm,                   org_pay_comm_rate,
               trunk_no,                  box_no,                  package_no,                     ticket_no,
               pay_amount,                lottery_amount,          pay_time,                       is_center_paid,
               security_code,             reward_no,               payer_admin,                    payer_name)
            values
              (v_pay_flow,                p_plan,                  p_batch,                        v_lottery_detail.reward_group,
               v_org,                     v_org_type,              v_comm_amount,                  v_comm_rate,
               v_lottery_detail.trunk_no, v_lottery_detail.box_no, p_package_no,                   p_ticket_no,
               v_reward_amount,           v_single_ticket_amount,  v_pay_time,                     p_paid_type,
               p_security_string,         v_reward_level,          p_oper,                         v_admin_realname);

            -- 组织机构增加流水（奖金+佣金）
            -- 奖金
            p_org_fund_change(v_org, eflow_type.org_center_pay, v_reward_amount, 0, v_pay_flow, v_balance, v_balance);

            -- 佣金
            if v_comm_amount > 0 then
               p_org_fund_change(v_org, eflow_type.org_center_pay_comm, v_comm_amount, 0, v_pay_flow, v_balance, v_balance);
            end if;
         end if;

   end case;

   c_reward_amount := v_reward_amount;
   c_pay_flow := v_pay_flow;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
/

create or replace procedure p_lottery_reward_all
/****************************************************************/
   ------------------- 批量兑奖 -------------------
   ---- 兑奖
   ----     判断销售站是否设置过代销费比率
   ----     循环调用兑奖存储过程，完成兑奖操作

   ---- add by 陈震: 2015-12-07
   ---- 涉及的业务表：
   ----     2.1.4.6 批次信息导入之奖符（game_batch_import_reward）                     -- 更新
   ----     2.1.4.7 批次信息导入之中奖明细（game_batch_reward_detail）                 -- 更新
   ----     2.1.7.1 gui兑奖信息记录表（flow_gui_pay）                                  -- 新增
   ----     2.1.7.2 兑奖记录（flow_pay）                                               -- 新增
   ----     2.1.7.4 站点资金流水（flow_agency）                                        -- 新增

   ---- 业务流程：
   ----     1、校验输入参数。（仓库是否存在；操作类型是否为新、继续、完结；操作人是否合法；）
   ----     2、判断此张彩票是否已经销售，没有的话，就不能兑奖；
   ----     3、查询兑奖记录，判断此张彩票是否已经进行过兑奖，如果已经兑奖，返回失败；
   ----     4、更新

   /*************************************************************/
(
  --------------输入----------------
  p_oper                               in number,                          -- 操作人
  p_pay_agency                         in char,                            -- 兑奖销售站
  p_array_lotterys                     in type_lottery_reward_list,        -- 兑奖的彩票对象

  ---------出口参数---------
  c_seq_no                             out string,                         -- 兑奖序号
  c_errorcode                          out number,                         -- 错误编码
  c_errormesg                          out string                          -- 错误原因

 ) is

   v_count                 number(5);                                      -- 求记录数的临时变量
   v_plan                  varchar2(20);                                   -- 方案

   v_djxq_no               char(24);                                       -- 兑奖详情主键
   v_seq_no                number(24);                                     -- 兑奖字表主键

   v_reward_amount         number(18);                                     -- 奖金
   v_pay_flow              char(24);                                       -- 兑奖流水号
   v_c_err_code            number(3);                                      -- 错误代码
   v_c_err_msg             varchar2(4000);                                 -- 错误消息

   v_area_code             char(4);                                        -- 站点所属区域
   v_total_reward_amount   number(28);                                     -- 总奖金

   v_safe_code             varchar2(50);                                   -- 安全码

   v_temp_string           varchar2(4000);

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;

   v_temp_string := f_get_sys_param(2);
   if v_temp_string not in ('1', '2') then
      rollback;
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_pay_agency) || error_msg.err_p_lottery_reward_5; -- 系统参数值不正确，请联系管理员，重新设置
      return;
   end if;

   /*-- 检查站点的兑奖佣金比例
   with
      save_comm as (
         select plan_code,1 cnt from game_agency_comm_rate where agency_code = p_pay_agency),
      all_comm as (
         select distinct plan_code from table(p_array_lotterys)),
      result_tab as (
         select plan_code, cnt from all_comm left join save_comm using(plan_code))
   select count(*) into v_count from result_tab where cnt is null;
   if v_count > 0 then
      with
         save_comm as (
            select plan_code,1 cnt from game_agency_comm_rate where agency_code = p_pay_agency),
         all_comm as (
            select distinct plan_code from table(p_array_lotterys)),
         result_tab as (
            select plan_code, cnt from all_comm left join save_comm using(plan_code))
      select plan_code into v_plan from result_tab where cnt is null and rownum = 1;

      c_errorcode := 3;
      c_errormesg := dbtool.format_line(p_pay_agency) || dbtool.format_line(v_plan) || error_msg.err_p_lottery_reward_6; -- 该销售站未设置此方案对应的兑奖佣金比例
      return;
   end if; */

   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* 开始兑奖 *************************/
   -- 获取销售站对应的区域码
   select area_code into v_area_code from inf_agencys where agency_code = p_pay_agency;

   -- 插入兑奖详情主表，提交
   v_count := p_array_lotterys.count;
   insert into sale_paid (djxq_no, pay_agency, area_code, payer_admin, plan_tickets)
                  values (f_get_flow_pay_detail_seq, p_pay_agency, v_area_code, p_oper, v_count)
                  returning djxq_no into v_djxq_no;

   v_total_reward_amount := 0;

   -- 循环输入记录
   for itab in (select * from table(p_array_lotterys)) loop
      -- 插入兑奖详情子表，并提交
      insert into sale_paid_detail (djxq_no, djxq_seq_no, plan_code, batch_no, package_no, ticket_no, security_code,
                                    is_old_ticket)
                            values (v_djxq_no, f_get_flow_pay_detail_no_seq, itab.plan_code, itab.batch_no, itab.package_no, itab.ticket_no, itab.security_code,
                                    f_get_reward_ticket_ver(itab.plan_code, itab.batch_no, itab.package_no))
                         returning djxq_seq_no into v_seq_no;

      -- 检查是否销售，检查的同时需要考虑新旧票
      begin
         select status into v_count from wh_ticket_package where plan_code = itab.plan_code and batch_no = itab.batch_no and package_no = itab.package_no;
      exception
         when no_data_found then
            -- 没有查询到记录，表示是旧票，旧票以已经销售论处
            v_count := eticket_status.saled;
      end;

      if v_count <> eticket_status.saled then
         update sale_paid_detail
            set paid_status = epaid_status.nosale
          where djxq_seq_no = v_seq_no;
         commit;
         continue;
      end if;

      -- 按照厂商，获取对应的安全码
      case
         when f_get_plan_publisher(itab.plan_code) = epublisher_code.sjz then

            -- 检查票是否中奖
            begin
               select single_reward_amount
                 into v_reward_amount
                 from game_batch_import_reward
                where plan_code = itab.plan_code
                  and batch_no = itab.batch_no
                  and instr(fast_identity_code, substr(itab.security_code, epublisher_sjz.fast_identity_code_pos, epublisher_sjz.len_fast_identity_code)) > 0;
            exception
               when no_data_found then
                  update sale_paid_detail
                     set paid_status = epaid_status.nowin
                   where djxq_seq_no = v_seq_no;
                  commit;
                  continue;
            end;

            if v_reward_amount >= to_number(f_get_sys_param(5)) then
               update sale_paid_detail
                  set paid_status = epaid_status.bigreward,
                      reward_amount = v_reward_amount
                where djxq_seq_no = v_seq_no;
               commit;
               continue;
            end if;

         when f_get_plan_publisher(itab.plan_code) = epublisher_code.zc3c then
            begin
               select safe_code
                 into v_safe_code
                 from game_batch_reward_detail
                where plan_code = itab.plan_code
                  and batch_no = itab.batch_no
                  and pre_safe_code = substr(itab.security_code, 1, 16);

               -- 已经中奖，再检索中奖级别和中奖金额
               select single_reward_amount
                 into v_reward_amount
                 from game_batch_import_reward
                where plan_code = itab.plan_code
                  and batch_no = itab.batch_no
                  and instr(fast_identity_code, substr(v_safe_code, epublisher_sjz.fast_identity_code_pos, epublisher_sjz.len_fast_identity_code)) > 0;

               if v_reward_amount >= to_number(f_get_sys_param(5)) then
                  update sale_paid_detail
                     set paid_status = epaid_status.bigreward,
                         reward_amount = v_reward_amount
                   where djxq_seq_no = v_seq_no;
                  commit;
                  continue;
               end if;
            exception
               when no_data_found then
                  update sale_paid_detail
                     set paid_status = epaid_status.nowin
                   where djxq_seq_no = v_seq_no;
                  commit;
                  continue;
            end;

      end case;

      -- 调用存储过程
      p_lottery_reward(itab.security_code, null, null, null, null, null, 3, itab.plan_code, itab.batch_no, itab.package_no, itab.ticket_no, p_oper, p_pay_agency, sysdate,
                       v_reward_amount, v_pay_flow, v_c_err_code, v_c_err_msg);

      -- 根据存储过程返回结果，更新兑奖详情子表，并提交
      case
         -- 成功
         when v_c_err_code in (0) then
            update sale_paid_detail
               set paid_status = epaid_status.succed,
                   pay_flow = v_pay_flow,
                   reward_amount = v_reward_amount
             where djxq_seq_no = v_seq_no;
            update sale_paid
               set succ_tickets = succ_tickets + 1
             where djxq_no = v_djxq_no;

             v_total_reward_amount := v_total_reward_amount + v_reward_amount;

         -- 非法票
         when v_c_err_code in (2) then
            update sale_paid_detail
               set paid_status = epaid_status.invalid
             where djxq_seq_no = v_seq_no;

         -- 非法票
         when v_c_err_code in (3) then
            update sale_paid_detail
               set paid_status = epaid_status.terminate
             where djxq_seq_no = v_seq_no;

         -- 已兑奖
         when v_c_err_code in (5) then
            update sale_paid_detail
               set paid_status = epaid_status.paid
             where djxq_seq_no = v_seq_no;

         -- 未销售
         when v_c_err_code in (4) then
            update sale_paid_detail
               set paid_status = epaid_status.nosale
             where djxq_seq_no = v_seq_no;

         -- 系统错误
         else
            c_errorcode := 100;
            c_errormesg := v_c_err_msg;
            return;

      end case;

      commit;

   end loop;

   update sale_paid set succ_amount = v_total_reward_amount where djxq_no = v_djxq_no;
   commit;

   c_seq_no := v_djxq_no;

exception
   when others then
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
/

create or replace procedure p_mm_inv_check
/****************************************************************/
   ------------------- 市场管理员库存盘点 -------------------
   ---- 输入一个彩票数组，确定出市场管理员的库存情况（以本为单位），返回两个数组。
   ---- 1、显示彩票不在这个管理员手中的；
   ---- 2、应该在管理员库存，但是未扫描的彩票

   ---- add by 陈震: 2015-12-08

   /*************************************************************/
(
 --------------输入----------------
  p_oper                               in number,                             -- 市场管理员
  p_array_lotterys                     in type_mm_check_lottery_list,         -- 输入的彩票对象

  ---------出口参数---------
  c_array_lotterys                     out type_mm_check_lottery_list,        -- 输出的彩票对象
  c_inv_tickets                        out number,                            -- 库存数量
  c_check_tickets                      out number,                            -- 盘点数量
  c_diff_tickets                       out number,                            -- 差异数量
  c_errorcode                          out number,                            -- 错误编码
  c_errormesg                          out string                             -- 错误原因

 ) is

   v_tmp_lotterys                      type_mm_check_lottery_list;            -- 库存彩票对象
   v_out_lotterys                      type_mm_check_lottery_list;            -- 临时彩票对象
   v_s1_lotterys                       type_mm_check_lottery_list;            -- 临时彩票对象
   v_s2_lotterys                       type_mm_check_lottery_list;            -- 临时彩票对象

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   c_inv_tickets := 0;
   c_check_tickets := 0;
   c_diff_tickets := 0;

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;

   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   -- 获取管理员所有彩票对象（本）
   select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, (ticket_no_end - ticket_no_start + 1), 0)
     bulk collect into v_tmp_lotterys
     from wh_ticket_package
    where status = 21
      and CURRENT_WAREHOUSE = p_oper;

   -- 生成管理员库存数量
   select sum(tickets)
     into c_inv_tickets
     from table(v_tmp_lotterys);
   c_inv_tickets := nvl(c_inv_tickets, 0);

   /********************************************************************************************************************************************************************/
   -- 看看输入的彩票中，有多少本是在库存管理员手中的.统计交集的票数量，为盘点数量
   select sum(src.tickets)
     into c_check_tickets
     from table(p_array_lotterys) dest
     join table(v_tmp_lotterys) src
    using (plan_code, batch_no, package_no);
   c_check_tickets := nvl(c_check_tickets, 0);

   -- 库存 减去 盘点，结果为差异
   c_diff_tickets := nvl(c_inv_tickets - c_check_tickets, 0);

   /********************************************************************************************************************************************************************/
   -- 获取未扫描的票
   select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, 0, 2)
     bulk collect into v_s2_lotterys
     from (
         select plan_code, batch_no, package_no from table(v_tmp_lotterys)
         minus
         select plan_code, batch_no, package_no from table(p_array_lotterys));

   -- 显示不在管理员手中的票
   select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, 0, 1)
     bulk collect into v_s1_lotterys
     from (
         select plan_code, batch_no, package_no from table(p_array_lotterys)
         minus
         select plan_code, batch_no, package_no from table(v_tmp_lotterys));

   -- 合并结果
   select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, tickets, status)
     bulk collect into v_out_lotterys
     from (
         select plan_code, batch_no, package_no, tickets, status from table(v_s1_lotterys)
         union all
         select plan_code, batch_no, package_no, tickets, status from table(v_s2_lotterys));

   c_array_lotterys := v_out_lotterys;

exception
   when others then
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
/

CREATE OR REPLACE PROCEDURE p_outlet_plan_auth
/***************************************************************
  ------------------- 销售站方案批量授权 -------------------
  ---------add by dzg  2015-9-15 单个站点的方案授权
  ---------modify by dzg 2015-11-27 修改站点信用额度，只有代销商时才比较值
  ************************************************************/
(

 --------------输入----------------
 p_outlet_code    IN STRING, --站点编号
 p_outlet_credit  IN NUMBER, --站点信用额度
 p_game_auth_list IN type_game_auth_list, --授权方案列表

 --------------出口参数----------------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因

 ) IS

  v_cur_auth_info type_game_auth_info; --当前授权信息，用于循环遍历
  v_temp          NUMBER := 0; --临时变量，发行费用

BEGIN
  /*-----------    初始化数据    -----------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  /*-----------  输入数据校验    ----------*/
  IF p_game_auth_list.count < 0 THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_OUTLET_PLAN_AUTH_1;
    RETURN;
  END IF;

  /*-----------  校验发行费用    ----------*/


select g.org_type
  into v_temp
  from inf_orgs g
 where g.org_code in (select a.org_code
                        from inf_agencys a
                       where a.agency_code = p_outlet_code);

  if(v_temp is not null and v_temp = eorg_type.agent) then


  FOR i IN 1 .. p_game_auth_list.count LOOP

    v_cur_auth_info := p_game_auth_list(i);
    v_temp          := 0;

    ---获取父区域游戏授权信息

    begin
      SELECT game_org_comm_rate.sale_comm
        INTO v_temp
        FROM game_org_comm_rate
       WHERE game_org_comm_rate.plan_code = v_cur_auth_info.plancode
         AND game_org_comm_rate.org_code IN
             (SELECT inf_agencys.org_code
                FROM inf_agencys
               WHERE inf_agencys.agency_code = v_cur_auth_info.agencycode);

    exception
      when no_data_found then
        v_temp := 0;
    end;

    ---比较值
    IF v_temp < v_cur_auth_info.salecommissionrate THEN
      c_errorcode := 1;
      c_errormesg := error_msg.ERR_P_OUTLET_PLAN_AUTH_2;
      RETURN;
    END IF;

  END LOOP;

  end if;

  /*-----------  更新信用额度       -----------*/

  update acc_agency_account
     set credit_limit = p_outlet_credit
   where agency_code = p_outlet_code
     and acc_type = eacc_type.main_account;

  v_cur_auth_info := NULL;

  /*----------- 选择销售站循环插入 -----------*/

  FOR i IN 1 .. p_game_auth_list.count LOOP

    v_cur_auth_info := p_game_auth_list(i);

    ---先清除
    DELETE FROM game_agency_comm_rate au
     WHERE au.plan_code = v_cur_auth_info.plancode
       AND au.agency_code = v_cur_auth_info.agencycode;

    ---后插入
    insert into game_agency_comm_rate
      (agency_code, plan_code, sale_comm, pay_comm)
    values
      (p_outlet_code,
       v_cur_auth_info.plancode,
       v_cur_auth_info.salecommissionrate,
       v_cur_auth_info.paycommissionrate);

  END LOOP;
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
/

CREATE OR REPLACE PROCEDURE p_warehouse_check_step1
/****************************************************************/
  ------------------- 适用于仓库盘点-------------------
  ----盘点第一步：新建盘点单
  ----add by dzg: 2015-9-25
  ----业务流程：当仓库正在盘点时，不能盘点，盘点时生成当前库房实际量
  ----检查发现问题：数据中包含重复数据，没有检测盒子和箱等的包容关系
  ----更新仓库状态盘点中...
  ----更新本地没有盒签......modify by dzg 2016-01-16 in pp
  ----2016/3/18 修改新建盘点单默认值为有差异

  /*************************************************************/
(
 --------------输入----------------
 p_warehouse_opr  IN NUMBER, --盘点人
 p_check_name     IN STRING, --盘点方案名称
 p_warehouse_code IN STRING, --库房编码
 p_plan_code      IN STRING, --盘点方案（可选）
 p_batch_code     IN STRING, --盘点批次（可选）

 ---------出口参数---------
 c_check_code OUT STRING, --返回盘点单编号
 c_errorcode  OUT NUMBER, --错误编码
 c_errormesg  OUT STRING --错误原因

 ) IS

  v_count_temp NUMBER := 0; --临时变量
  v_count_tick NUMBER := 0; --存放临时库存总量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --名称不能为空
  IF ((p_check_name IS NULL) OR length(p_check_name) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_warehouse_check_step1_1;
    RETURN;
  END IF;

  --库房不能为空
  IF ((p_warehouse_code IS NULL) OR length(p_warehouse_code) <= 0) THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_warehouse_check_step1_2;
    RETURN;
  END IF;

  --盘点人无效
  v_count_temp := 0;
  SELECT count(o.admin_id)
    INTO v_count_temp
    FROM adm_info o
   WHERE o.admin_id = p_warehouse_opr
     AND o.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 3;
    c_errormesg := error_msg.err_p_warehouse_check_step1_3;
    RETURN;
  END IF;

  --仓库无效或者正在盘点中
  v_count_temp := 0;
  SELECT count(o.warehouse_code)
    INTO v_count_temp
    FROM wh_info o
   WHERE o.warehouse_code = p_warehouse_code
     AND o.status = ewarehouse_status.working;

  IF v_count_temp <= 0 THEN
    c_errorcode := 4;
    c_errormesg := error_msg.err_p_warehouse_check_step1_4;
    RETURN;
  END IF;

  --仓库无任何相关物品没有必要盘点
  v_count_temp := 0;

  ---箱检测
  --如下的业务逻辑，基于有批次一定有方案的业务关系
  IF ((p_batch_code IS NOT NULL) OR length(p_batch_code) > 0) THEN
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_trunk o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse
       AND o.plan_code = p_plan_code
       AND o.batch_no = p_batch_code;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;

  ELSIF ((p_plan_code IS NOT NULL) OR length(p_plan_code) > 0) THEN
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_trunk o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse
       AND o.plan_code = p_plan_code;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;
  ELSE
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_trunk o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;
  END IF;

  ---盒子检测
  --如下的业务逻辑，基于有批次一定有方案的业务关系
  IF ((p_batch_code IS NOT NULL) OR length(p_batch_code) > 0) THEN
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_box o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse
       AND o.plan_code = p_plan_code
       AND o.batch_no = p_batch_code;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;

  ELSIF ((p_plan_code IS NOT NULL) OR length(p_plan_code) > 0) THEN
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_box o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse
       AND o.plan_code = p_plan_code;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;
  ELSE
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_box o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;
  END IF;

  ---本检测
  --如下的业务逻辑，基于有批次一定有方案的业务关系
  IF ((p_batch_code IS NOT NULL) OR length(p_batch_code) > 0) THEN
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_package o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse
       AND o.plan_code = p_plan_code
       AND o.batch_no = p_batch_code;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;

  ELSIF ((p_plan_code IS NOT NULL) OR length(p_plan_code) > 0) THEN
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_package o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse
       AND o.plan_code = p_plan_code;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;
  ELSE
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_package o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;
  END IF;

  IF v_count_tick <= 0 THEN
    c_errorcode := 5;
    c_errormesg := error_msg.err_p_warehouse_check_step1_5;
    RETURN;
  END IF;

  /*----------- 插入数据  -----------------*/
  --插入基本信息
  c_check_code := f_get_wh_check_point_seq();

  insert into wh_check_point
    (cp_no,
     warehouse_code,
     cp_name,
     plan_code,
     batch_no,
     status,
     result,
     nomatch_tickets,
     nomatch_amount,
     cp_admin,
     cp_date,
     remark)
  values
    (c_check_code,
     p_warehouse_code,
     p_check_name,
     p_plan_code,
     p_batch_code,
     ecp_status.working,
     ecp_result.less,
     0,
     0,
     p_warehouse_opr,
     sysdate,
     '--');

  --插入盘点前记录
  ---箱
  --同检测一样依赖条件
  IF ((p_batch_code IS NOT NULL) OR length(p_batch_code) > 0) THEN

    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.trunk,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             '-',
             '-',
             d.packs_every_trunk,
             d.tickets_every_pack * d.packs_every_trunk * g.ticket_amount
        FROM wh_ticket_trunk o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND o.status = eticket_status.in_warehouse
         AND o.plan_code = p_plan_code
         AND o.batch_no = p_batch_code;

  ELSIF ((p_plan_code IS NOT NULL) OR length(p_plan_code) > 0) THEN
    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.trunk,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             '-',
             '-',
             d.packs_every_trunk,
             d.tickets_every_pack * d.packs_every_trunk * g.ticket_amount
        FROM wh_ticket_trunk o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND o.status = eticket_status.in_warehouse
         AND o.plan_code = p_plan_code;

  ELSE
    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.trunk,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             '-',
             '-',
             d.packs_every_trunk,
             d.tickets_every_pack * d.packs_every_trunk * g.ticket_amount
        FROM wh_ticket_trunk o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND o.status = eticket_status.in_warehouse;
  END IF;

  ---盒子检测
  IF ((p_batch_code IS NOT NULL) OR length(p_batch_code) > 0) THEN

    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.pack,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             o.box_no,
             p.package_no,
             1,
             d.tickets_every_pack * g.ticket_amount
        FROM wh_ticket_box o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
        Left Join wh_ticket_trunk t
          on (o.plan_code = t.plan_code and o.batch_no = t.batch_no and
             t.trunk_no = o.trunk_no)
        left join wh_ticket_package p
          on (o.plan_code = p.plan_code and o.batch_no = p.batch_no and
           o.box_no = p.box_no)
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND o.status = eticket_status.in_warehouse
         AND t.is_full = eboolean.noordisabled
         AND o.plan_code = p_plan_code
         AND o.batch_no = p_batch_code;

  ELSIF ((p_plan_code IS NOT NULL) OR length(p_plan_code) > 0) THEN
    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.pack,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             o.box_no,
             p.package_no,
             1,
             d.tickets_every_pack * g.ticket_amount
        FROM wh_ticket_box o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
        Left Join wh_ticket_trunk t
          on (o.plan_code = t.plan_code and o.batch_no = t.batch_no and
             t.trunk_no = o.trunk_no)
        left join wh_ticket_package p
          on (o.plan_code = p.plan_code and o.batch_no = p.batch_no and
           o.box_no = p.box_no)
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND t.is_full = eboolean.noordisabled
         AND o.status = eticket_status.in_warehouse
         AND o.plan_code = p_plan_code;

  ELSE
    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.pack,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             o.box_no,
             p.package_no,
             1,
             d.tickets_every_pack * g.ticket_amount
        FROM wh_ticket_box o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
        Left Join wh_ticket_trunk t
          on (o.plan_code = t.plan_code and o.batch_no = t.batch_no and
             t.trunk_no = o.trunk_no)
        left join wh_ticket_package p
          on (o.plan_code = p.plan_code and o.batch_no = p.batch_no and
           o.box_no = p.box_no)
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND t.is_full = eboolean.noordisabled
         AND o.status = eticket_status.in_warehouse;
  END IF;

  ---本检测
  IF ((p_batch_code IS NOT NULL) OR length(p_batch_code) > 0) THEN

    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.pack,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             o.box_no,
             o.package_no,
             1,
             d.tickets_every_pack * g.ticket_amount
        FROM wh_ticket_package o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
        Left Join wh_ticket_box b
          on (o.plan_code = b.plan_code and o.batch_no = b.batch_no and
             o.box_no = b.box_no)
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND o.status = eticket_status.in_warehouse
         AND b.is_full = eboolean.noordisabled
         AND o.plan_code = p_plan_code
         AND o.batch_no = p_batch_code;

  ELSIF ((p_plan_code IS NOT NULL) OR length(p_plan_code) > 0) THEN
    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.pack,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             o.box_no,
             o.package_no,
             1,
             d.tickets_every_pack * g.ticket_amount
        FROM wh_ticket_package o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
        Left Join wh_ticket_box b
          on (o.plan_code = b.plan_code and o.batch_no = b.batch_no and
             o.box_no = b.box_no)
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND b.is_full = eboolean.noordisabled
         AND o.status = eticket_status.in_warehouse
         AND o.plan_code = p_plan_code;

  ELSE
    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.pack,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             o.box_no,
             o.package_no,
             1,
             d.tickets_every_pack * g.ticket_amount
        FROM wh_ticket_package o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
        Left Join wh_ticket_box b
          on (o.plan_code = b.plan_code and o.batch_no = b.batch_no and
             o.box_no = b.box_no)
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND b.is_full = eboolean.noordisabled
         AND o.status = eticket_status.in_warehouse;
  END IF;

  --更新仓库状态
  update wh_info
     set wh_info.status = ewarehouse_status.checking
   where wh_info.warehouse_code = p_warehouse_code;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
/

CREATE OR REPLACE PROCEDURE p_warehouse_check_step2
/****************************************************************/
  ------------------- 适用于仓库盘点-------------------
  ----盘点第二步：扫描入库
  ----add by dzg: 2015-9-25
  ----modify by dzg:2015-10-27增加重复检测功能
  ----modify by dzg:2016-01-16 in pp 暂时不支持本签
  /*************************************************************/
(
 --------------输入----------------
 p_check_code     IN STRING, --盘点单
 p_array_lotterys IN type_lottery_list, -- 入库的彩票对象

 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因

 ) IS

  v_count_temp   NUMBER := 0; --临时变量
  v_count_pack   NUMBER := 0; --总包数
  v_count_tick   NUMBER := 0; --总票数
  v_amount_tatal NUMBER := 0; --总额
  v_total_tickets      NUMBER := 0; --纯变量
  v_total_amount       NUMBER := 0; --纯变量
  v_detail_list           type_lottery_detail_list;                       -- 彩票对象明细
  v_stat_list             type_lottery_statistics_list;                   -- 按照方案和批次统计的金额和票数

  v_item         type_lottery_info; --循环变量的当前值

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --编号不能为空
  IF ((p_check_code IS NULL) OR length(p_check_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_warehouse_check_step2_1;
    RETURN;
  END IF;

  --编号不存在或者已经完结
  v_count_temp := 0;
  SELECT count(o.cp_no)
    INTO v_count_temp
    FROM wh_check_point o
   WHERE o.cp_no = p_check_code
     AND o.status <> ecp_status.done;

  IF v_count_temp <= 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_warehouse_check_step2_2;
    RETURN;
  END IF;

  --记录不能为空
  IF (p_array_lotterys is null or p_array_lotterys.count < 0) THEN
    c_errorcode := 3;
    c_errormesg := error_msg.err_p_warehouse_check_step2_3;
    RETURN;
  END IF;

  --重复检测
  IF (f_check_import_ticket(p_check_code,3,p_array_lotterys)) THEN
    c_errorcode := 4;
    c_errormesg := error_msg.err_p_ar_inbound_3;
    RETURN;
  END IF;


  /*----------- 插入数据  -----------------*/

  --使用陈震函数初始化对象
  p_lottery_detail_stat(p_array_lotterys, v_detail_list, v_stat_list, v_total_tickets, v_total_amount);

  ---循环插入数据
  FOR i IN 1 .. p_array_lotterys.count LOOP

    if( v_detail_list(i).valid_number = evalid_number.box) then
        RAISE_APPLICATION_ERROR(-20123, 'System not support the barcode of box.', TRUE);
    end if;
    v_item := p_array_lotterys(i);
    v_count_pack := 0;
    v_count_tick:= 0;

    p_warehouse_get_sum_info(v_item,
                             v_count_pack,
                             v_count_tick,
                             v_amount_tatal);



    ---后插入 wh_check_point_detail
    insert into wh_check_point_detail
      (cp_no,
       sequence_no,
       valid_number,
       plan_code,
       batch_no,
       trunk_no,
       box_no,
       package_no,
       packages,
       amount)
    values
      (p_check_code,
       f_get_detail_sequence_no_seq(),
       v_detail_list(i).valid_number,
       v_detail_list(i).plan_code,
       v_detail_list(i).batch_no,
       v_detail_list(i).trunk_no,
       v_detail_list(i).box_no,
       v_detail_list(i).package_no,
       v_count_pack,
       v_amount_tatal);

  END LOOP;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
/

CREATE OR REPLACE PROCEDURE p_warehouse_check_step3
/****************************************************************/
  ------------------- 适用于仓库盘点-------------------
  ----盘点第三步：确认完成，并生成结果
  ----add by dzg: 2015-9-25
  ----业务流程：根据对比前的数据和实际扫库数据，进行计算结果
  ----目前只有可能少，或者一致，多属于其他异常
  ----modify by dzg 2015-10-23 增加备注
  ----修改使得第三步和完成都可以使用同一个过程
  ----modify by dzg 2015-11-12 修改计算已盘点数据错误，sql错误，inner没加匹配条件...依旧需要补充其他逻辑
  /*************************************************************/
(
 --------------输入----------------
 p_check_code IN STRING, --盘点单
 p_remark     IN STRING, --盘点备注
 p_isfinish   IN NUMBER, --完成标志

 ---------出口参数---------
 c_before_num    OUT NUMBER, --盘点前总数
 c_before_amount OUT NUMBER, --盘点前总额
 c_after_num     OUT NUMBER, --盘点后总数
 c_after_amount  OUT NUMBER, --盘点后总额
 c_result        OUT NUMBER, --盘点结果
 c_errorcode     OUT NUMBER, --错误编码
 c_errormesg     OUT STRING --错误原因

 ) IS

  v_count_temp NUMBER := 0; --临时变量
  c_isfinish NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  --初始化默认输出值，否则mybatis会有异常提示
  c_before_num    := 0;
  c_before_amount := 0;
  c_after_num     := 0;
  c_after_amount  := 0;
  c_result        := ecp_result.same;
  c_isfinish      := ecp_status.working;

  /*----------- 数据校验   -----------------*/
  --编号不能为空
  IF ((p_check_code IS NULL) OR length(p_check_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_warehouse_check_step2_1;
    RETURN;
  END IF;

  --编号不存在或者已经完结
  IF (p_isfinish > 0 ) THEN
    c_isfinish      := ecp_status.done;
    v_count_temp := 0;
    SELECT count(o.cp_no)
      INTO v_count_temp
      FROM wh_check_point o
     WHERE o.cp_no = p_check_code
       AND o.status <> ecp_status.done;

    IF v_count_temp <= 0 THEN
      c_errorcode := 2;
      c_errormesg := error_msg.err_p_warehouse_check_step2_2;
      RETURN;
    END IF;
  END IF;

  /*----------- 插入数据  -----------------*/
  --入库前总数和金额及其入库金额总数
  --根据总数判断

  --多次调用考虑使用先清除
   delete from wh_cp_nomatch_detail
    where wh_cp_nomatch_detail.cp_no= p_check_code;

  select sum(nd.packages * gd.tickets_every_pack), sum(nd.amount)
    into c_before_num, c_before_amount
    from wh_check_point_detail_be nd
    left join game_batch_import_detail gd
      on (nd.plan_code = gd.plan_code and nd.batch_no = gd.batch_no)
   where nd.cp_no = p_check_code;

  select sum(nd.packages * gd.tickets_every_pack), sum(nd.amount)
    into c_after_num, c_after_amount
    from wh_check_point_detail nd
    left join game_batch_import_detail gd
      on (nd.plan_code = gd.plan_code and nd.batch_no = gd.batch_no)
   inner join wh_check_point_detail_be bf
      on (nd.plan_code = bf.plan_code and nd.batch_no = bf.batch_no and
         nd.valid_number = bf.valid_number and nd.trunk_no = bf.trunk_no and
         nd.box_no = bf.box_no and nd.package_no = bf.package_no)
   where nd.cp_no = p_check_code
   and bf.cp_no =p_check_code;

  IF ((c_before_num IS NULL) OR length(c_before_num) <= 0) THEN
    c_before_num    := 0;
    c_before_amount := 0;
  END IF;

  IF ((c_after_num IS NULL) OR length(c_after_num) <= 0) THEN
    c_after_num    := 0;
    c_after_amount := 0;
  END IF;

  IF (c_before_num = c_after_num) THEN

    update wh_check_point
       set status          = c_isfinish,
           result          = ecp_result.same,
           nomatch_tickets = 0,
           remark          = p_remark,
           nomatch_amount  = 0
     where cp_no = p_check_code;

  ELSE
    ---生成未匹配数据
    c_result        := ecp_result.less;
    insert into wh_cp_nomatch_detail
      select t.cp_no,
             t.sequence_no,
             t.valid_number,
             t.plan_code,
             t.batch_no,
             t.trunk_no,
             t.box_no,
             t.package_no,
             t.packages,
             t.amount
        from (

              select a1.cp_no,
                      a1.sequence_no,
                      a1.valid_number,
                      a1.plan_code,
                      a1.batch_no,
                      a1.trunk_no,
                      a1.box_no,
                      a1.package_no,
                      a1.packages,
                      a1.amount,
                      nvl2(b1.trunk_no, 0, 1) vsign
                from wh_check_point_detail_be a1
                left join wh_check_point_detail b1
                  on (a1.cp_no = b1.cp_no and
                     a1.valid_number = b1.valid_number and
                     a1.trunk_no = b1.trunk_no)
               where a1.cp_no = p_check_code
                 and a1.valid_number = 1

              union

              select a2.cp_no,
                      a2.sequence_no,
                      a2.valid_number,
                      a2.plan_code,
                      a2.batch_no,
                      a2.trunk_no,
                      a2.box_no,
                      a2.package_no,
                      a2.packages,
                      a2.amount,
                      nvl2(b2.trunk_no, 0, 1) vsign
                from wh_check_point_detail_be a2
                left join wh_check_point_detail b2
                  on (a2.cp_no = b2.cp_no and
                     a2.valid_number = b2.valid_number and
                     a2.box_no = b2.box_no)
               where a2.cp_no = p_check_code
                 and a2.valid_number = 2

              union

              select a3.cp_no,
                      a3.sequence_no,
                      a3.valid_number,
                      a3.plan_code,
                      a3.batch_no,
                      a3.trunk_no,
                      a3.box_no,
                      a3.package_no,
                      a3.packages,
                      a3.amount,
                      nvl2(b3.trunk_no, 0, 1) vsign
                from wh_check_point_detail_be a3
                left join wh_check_point_detail b3
                  on (a3.cp_no = b3.cp_no and
                     a3.valid_number = b3.valid_number and
                     a3.package_no = b3.package_no)
               where a3.cp_no = p_check_code
                 and a3.valid_number = 3) t
       where t.vsign = 0;

    update wh_check_point
       set status          = c_isfinish,
           result          = ecp_result.less,
           remark          = p_remark,
           nomatch_tickets = c_before_num - c_after_num,
           nomatch_amount  = c_before_amount - c_after_amount
     where cp_no = p_check_code;

  END IF;

  --结束的解除
  IF (p_isfinish > 0 ) THEN
     update wh_info
        set wh_info.status = ewarehouse_status.working
      where wh_info.warehouse_code in
            (select wh_check_point.warehouse_code
               from wh_check_point
              where wh_check_point.cp_no = p_check_code);
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
/

/********************************************************************************/
  ------------------- 获取方案对应的印制厂商 ----------------------------
  ---- add by 陈震: 2015/9/16
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_plan_publisher(
   p_plan in varchar2
)
   RETURN number

 IS
   v_publish number;

BEGIN
   select PUBLISHER_CODE into v_publish from GAME_PLANS where PLAN_CODE = p_plan;

   return v_publish;
END;
/

CREATE OR REPLACE PROCEDURE p_plan_batch_auth
/***************************************************************
  ------------------- 新增方案，批量授权 -------------------
  --------- add by Chen Zhen  2016-03-30 新增
  ---------
  ************************************************************/
(

 --------------输入----------------
 p_plan_code         IN STRING, -- 新方案编号
 p_ref_plan          IN STRING, -- 参考方案编号

 --------------出口参数----------------
 c_errorcode         OUT NUMBER, --错误编码
 c_errormesg         OUT STRING --错误原因

 ) IS

BEGIN
  /*-----------    初始化数据    -----------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  insert into game_org_comm_rate select org_code, p_plan_code, sale_comm, pay_comm from game_org_comm_rate where plan_code = p_ref_plan;
  insert into game_agency_comm_rate select agency_code, p_plan_code, sale_comm, pay_comm from game_agency_comm_rate where plan_code = p_ref_plan;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
/
