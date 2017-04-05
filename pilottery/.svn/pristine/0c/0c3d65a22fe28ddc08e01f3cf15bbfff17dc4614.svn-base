create or replace procedure p_his_gen_by_day (
   p_curr_date       date        default sysdate,
   p_maintance_mod   number      default 0
)
/****************************************************************/
   ------------------- 仅用于统计数据（每日0点执行） -------------------
   ---- add by 陈震: 2015/10/14
   /*************************************************************/
is
   v_temp1        number(28);
   v_temp2        number(28);

   v_max_org_pay_flow char(24);

begin

   if p_maintance_mod = 0 then
      -- 库存信息
      insert into his_lottery_inventory
         (calc_date,
          plan_code,
          batch_no,
          reward_group,
          status,
          warehouse,
          tickets,
          amount)
         with total as
          (select to_char(p_curr_date - 1,'yyyy-mm-dd') calc_date,
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
                     nvl(current_warehouse, '[null]'))
         select calc_date,
                plan_code,
                batch_no,
                reward_group,
                status,
                to_char(warehouse),
                tickets,
                tickets * ticket_amount
           from total
           join game_plans
          using (plan_code);

      commit;

      -- 站点资金日结
      insert into his_agency_fund (calc_date, agency_code, flow_type, amount, be_account_balance, af_account_balance)
      with last_day as
       (select agency_code, af_account_balance be_account_balance
          from his_agency_fund
         where calc_date = to_char(p_curr_date - 2, 'yyyy-mm-dd')
           and flow_type = 0),
      this_day as
       (select agency_code, account_balance af_account_balance
          from acc_agency_account
         where acc_type = 1),
      now_fund as
       (select agency_code, flow_type, sum(change_amount) as amount
          from flow_agency
         where trade_time >= trunc(p_curr_date - 1)
           and trade_time < trunc(p_curr_date)
         group by agency_code, flow_type),
      agency_balance as
       (select agency_code, be_account_balance, 0 as af_account_balance from last_day
         union all
        select agency_code, 0 as be_account_balance, af_account_balance from this_day),
      ab as
       (select agency_code, sum(be_account_balance) be_account_balance, sum(af_account_balance) af_account_balance from agency_balance group by agency_code)
      select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
             agency_code,
             flow_type,
             amount,
             0 be_account_balance,
             0 af_account_balance
        from now_fund
      union all
      select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
             agency_code,
             0,
             0,
             be_account_balance,
             af_account_balance
        from ab;

      commit;
   end if;

   -- 站点库存日结
   insert into his_agency_inv
     (calc_date, agency_code, plan_code, oper_type, amount, tickets)
   with base as (
   -- 站点退货
   select SEND_WH agency_code,plan_code,10 inv_type,sum(AMOUNT) amount, sum(TICKETS) tickets
     from WH_GOODS_ISSUE mm join WH_GOODS_ISSUE_detail detail using(SGI_NO)
    where detail.ISSUE_TYPE = 4
      and ISSUE_END_TIME >= trunc(p_curr_date) - 1
      and ISSUE_END_TIME < trunc(p_curr_date)
   group by SEND_WH,plan_code
   union all
   -- 站点收货
   select RECEIVE_WH,plan_code,20 inv_type,sum(AMOUNT) amount, sum(TICKETS) tickets
    from WH_GOODS_RECEIPT mm join WH_GOODS_RECEIPT_detail detail using(sgr_no)
    where detail.RECEIPT_TYPE = 4
      and RECEIPT_END_TIME >= trunc(p_curr_date) - 1
      and RECEIPT_END_TIME < trunc(p_curr_date)
   group by RECEIVE_WH,plan_code
   union all
   -- 站点期初
   select WAREHOUSE,plan_code,88 inv_type,sum(AMOUNT) amount, sum(TICKETS) tickets
     from HIS_LOTTERY_INVENTORY
    where STATUS = 31
      and CALC_DATE = to_char(trunc(p_curr_date) - 2,'yyyy-mm-dd')
   group by WAREHOUSE,plan_code
   union all
   -- 站点期末
   select WAREHOUSE,plan_code,99 inv_type,sum(AMOUNT) amount, sum(TICKETS) tickets
     from HIS_LOTTERY_INVENTORY
    where STATUS = 31
      and CALC_DATE = to_char(trunc(p_curr_date) - 1,'yyyy-mm-dd')
   group by WAREHOUSE,plan_code)
   select to_char(trunc(p_curr_date) - 1,'yyyy-mm-dd'),agency_code, plan_code, inv_type, amount, tickets from base;

   commit;

   -- 销量按部门监控
   insert into his_sale_org (calc_date, org_code, plan_code, sale_amount, sale_comm, cancel_amount, cancel_comm, paid_amount, paid_comm, incoming)
   with time_con as
    (select (trunc(p_curr_date) - 1) s_time, trunc(p_curr_date) e_time from dual),
   sale_stat as
    (select org_code, plan_code, sum(sale_amount) amount, sum(comm_amount) comm
       from flow_sale, time_con
      where sale_time >= s_time
        and sale_time < e_time
      group by org_code, plan_code),
   cancel_stat as
    (select org_code, plan_code, sum(sale_amount) amount, sum(comm_amount) comm
       from flow_cancel, time_con
      where cancel_time >= s_time
        and cancel_time < e_time
      group by org_code, plan_code),
   pay_stat as
    (select f_get_flow_pay_org(pay_flow) org_code, plan_code, nvl(sum(pay_amount),0) amount, nvl(sum(pay_comm),0) comm
       from flow_pay, time_con
      where pay_time >= s_time
        and pay_time < e_time
        and is_center_paid = 3
      group by f_get_flow_pay_org(pay_flow), plan_code),
 pay_center as
    (select org_code, plan_code, nvl(sum(pay_amount),0) amount, nvl(sum(org_pay_comm),0) comm
       from flow_pay_org_comm, time_con
      where pay_time >= s_time
        and pay_time < e_time
        and is_center_paid = 1
      group by org_code, plan_code),
 pre_detail as
    (select * from  (select org_code, plan_code, 1 ftype, amount, comm from sale_stat
                     union all
                     select org_code, plan_code, 2 ftype, amount, comm from cancel_stat
                     union all
                     select org_code, plan_code, 3 ftype, amount, comm from pay_stat
                     union all
                     select org_code, plan_code, 4 ftype, amount, comm from pay_center)
      pivot (sum(amount) as amount, sum(comm) as comm for ftype in (1 as sale, 2 as cancel, 3 as pay, 4 as pay_center))
    ),
   no_null as (
   select to_char(time_con.s_time, 'yyyy-mm-dd') calc_date,
          org_code,
          plan_code,
          nvl(sale_amount, 0) sale_amount,
          nvl(sale_comm, 0) sale_comm,
          nvl(cancel_amount, 0) cancel_amount,
          nvl(cancel_comm, 0) cancel_comm,
          nvl(pay_amount, 0) pay_amount,
          nvl(pay_comm, 0) pay_comm,
          nvl(pay_center_amount, 0) pay_center_amount,
          nvl(pay_center_comm, 0) pay_center_comm
     from pre_detail, time_con)
   select calc_date,org_code,plan_code,sale_amount,sale_comm,cancel_amount,cancel_comm,pay_amount,pay_comm,
          (sale_amount - sale_comm - cancel_amount + cancel_comm - pay_amount - pay_comm - pay_center_amount - pay_center_comm) incoming
     from no_null;
   commit;

   -- 3.17.1.1  部门资金报表（Institution Fund Reports）
   insert into his_org_fund_report
      (calc_date,
       org_code,
       be_account_balance,
       charge,
       withdraw,
       sale,
       sale_comm,
       paid,
       pay_comm,
       rtv,
       rtv_comm,
       af_account_balance,
       incoming,
       pay_up,center_pay,center_pay_comm)
   with base as
    (select org_code,
            FLOW_TYPE,
            sum(AMOUNT) as amount,
            sum(BE_ACCOUNT_BALANCE) as BE_ACCOUNT_BALANCE,
            sum(AF_ACCOUNT_BALANCE) as AF_ACCOUNT_BALANCE
       from his_agency_fund
       join inf_agencys
      using (agency_code)
      where CALC_DATE = to_char(p_curr_date - 1, 'yyyy-mm-dd')
      group by org_code, FLOW_TYPE),
   center_pay as
    (select f_get_flow_pay_org(pay_flow) org_code, 20 FLOW_TYPE, sum(pay_amount) amount
       from flow_pay
      where pay_time >= trunc(p_curr_date) - 1
        and pay_time < trunc(p_curr_date)
        and is_center_paid = 1
      group by f_get_flow_pay_org(pay_flow)),
   center_pay_comm as
    (select org_code, 21 FLOW_TYPE, sum(change_amount) amount
       from flow_org
      where TRADE_TIME >= trunc(p_curr_date) - 1
        and TRADE_TIME < trunc(p_curr_date)
        and FLOW_TYPE = eflow_type.org_center_pay_comm
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
             select org_code, FLOW_TYPE, AMOUNT from center_pay_comm
             union all
             select org_code, FLOW_TYPE, AMOUNT from agency_balance
             union all
             select org_code, FLOW_TYPE, AMOUNT from center_pay) pivot(sum(amount) for FLOW_TYPE in(1 as charge,
                                                                   2  as withdraw,
                                                                   5  as sale_comm,
                                                                   6  as pay_comm,
                                                                   7  as sale,
                                                                   8  as paid,
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
       from fund)
   select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
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
          (sale - sale_comm - paid - pay_comm - rtv + rtv_comm - center_pay - center_pay_comm) incoming,
          (sale - sale_comm - paid - pay_comm - rtv + rtv_comm - center_pay - center_pay_comm + af_account_balance - be_account_balance) pay_up,
          center_pay,
          center_pay_comm
     from pre_detail;

    commit;

    if p_maintance_mod = 0 then
       -- 管理员资金日结
       insert into HIS_MM_FUND (calc_date, MARKET_ADMIN, flow_type, amount, be_account_balance, af_account_balance)
         with last_day as
          (select MARKET_ADMIN, af_account_balance be_account_balance
             from his_mm_fund
            where calc_date = to_char(p_curr_date - 2, 'yyyy-mm-dd')
              and flow_type = 0),
         this_day as
          (select MARKET_ADMIN, account_balance af_account_balance
             from acc_mm_account
            where acc_type = 1),
         mm_balance as
          (select MARKET_ADMIN, be_account_balance, 0 as af_account_balance
             from last_day
           union all
           select MARKET_ADMIN, 0 as be_account_balance, af_account_balance
             from this_day),
         mb as
          (select MARKET_ADMIN,
                  sum(be_account_balance) be_account_balance,
                  sum(af_account_balance) af_account_balance
             from mm_balance
            group by MARKET_ADMIN),
         now_fund as
          (select MARKET_ADMIN, flow_type, sum(change_amount) as amount
             from flow_market_manager
            where trade_time >= trunc(p_curr_date - 1)
              and trade_time < trunc(p_curr_date)
            group by MARKET_ADMIN, flow_type)
         select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
                MARKET_ADMIN,
                flow_type,
                amount,
                0 be_account_balance,
                0 af_account_balance
           from now_fund
         union all
         select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
                MARKET_ADMIN,
                0,
                0,
                be_account_balance,
                af_account_balance
           from mb;

      commit;
   end if;

   -- 管理员库存日结
   insert into HIS_MM_INVENTORY (CALC_DATE, MARKET_ADMIN, PLAN_CODE, OPEN_INV, CLOSE_INV, GOT_TICKETS, SALED_TICKETS, CANCELED_TICKETS, RETURN_TICKETS, BROKEN_TICKETS)
      with
      -- 期初
      open_inv as
       (select WAREHOUSE MARKET_ADMIN, PLAN_CODE, sum(TICKETS) open_INV
          from HIS_LOTTERY_INVENTORY
         where CALC_DATE = to_char(trunc(p_curr_date) - 2, 'yyyy-mm-dd')
           and status = 21
         group by WAREHOUSE, PLAN_CODE),
      -- 期末
      close_inv as
       (select WAREHOUSE MARKET_ADMIN, PLAN_CODE, sum(TICKETS) CLOSE_INV
          from HIS_LOTTERY_INVENTORY
         where CALC_DATE = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
           and status = 21
         group by WAREHOUSE, PLAN_CODE),
      -- 收货
      got as
       (select apply_admin, plan_code, sum(detail.tickets) TICKETS
          from SALE_DELIVERY_ORDER mm
          join wh_goods_issue_detail detail
            on (mm.do_no = detail.ref_no)
         where status = 4
           and OUT_DATE >= trunc(p_curr_date - 1)
           and OUT_DATE < trunc(p_curr_date)
         group by apply_admin, plan_code),
      -- 销售
      saled as
       (select AR_ADMIN, plan_code, sum(detail.TICKETS) TICKETS
          from SALE_AGENCY_RECEIPT mm
          join wh_goods_receipt_detail detail
            on (mm.AR_NO = detail.ref_no)
         where AR_DATE >= trunc(p_curr_date - 1)
           and AR_DATE < trunc(p_curr_date)
         group by AR_ADMIN, plan_code),
      -- 退货
      canceled as
       (select AI_MM_ADMIN, plan_code, sum(detail.TICKETS) TICKETS
          from SALE_AGENCY_RETURN mm
          join wh_goods_issue_detail detail
            on (mm.AI_NO = detail.ref_no)
         where Ai_DATE >= trunc(p_curr_date - 1)
           and Ai_DATE < trunc(p_curr_date)
         group by AI_MM_ADMIN, plan_code),
      -- 还货
      returned as
       (select MARKET_MANAGER_ADMIN, plan_code, sum(detail.TICKETS) TICKETS
          from SALE_RETURN_RECODER mm
          join wh_goods_receipt_detail detail
            on (mm.RETURN_NO = detail.ref_no)
         where status = 6
           and RECEIVE_DATE >= trunc(p_curr_date - 1)
           and RECEIVE_DATE < trunc(p_curr_date)
         group by MARKET_MANAGER_ADMIN, plan_code),
      -- 损毁
      broken_detail as
       (select BROKEN_NO,
               plan_code,
               PACKAGES * (select TICKETS_EVERY_PACK
                             from GAME_BATCH_IMPORT_DETAIL
                            where plan_code = tt.plan_code
                              and batch_no = tt.batch_no) tickets
          from WH_BROKEN_RECODER_DETAIL tt),
      broken as
       (select APPLY_ADMIN, plan_code, sum(TICKETS) TICKETS
          from WH_BROKEN_RECODER
          join broken_detail
         using (BROKEN_NO)
         where APPLY_DATE >= trunc(p_curr_date - 1)
           and APPLY_DATE < trunc(p_curr_date)
         group by APPLY_ADMIN, plan_code),
      total_detail as
       (select apply_admin MARKET_ADMIN,
               plan_code,
               0           as open_inv,
               0           as CLOSE_INV,
               TICKETS     GOT_TICKETS,
               0           as SALED_TICKETS,
               0           as canceled_tickets,
               0           as RETURN_TICKETS,
               0           as BROKEN_TICKETS
          from got
        union all
        select AR_ADMIN  MARKET_ADMIN,
               plan_code,
               0         as open_inv,
               0         as CLOSE_INV,
               0         as GOT_TICKETS,
               TICKETS   as SALED_TICKETS,
               0         as canceled_tickets,
               0         as RETURN_TICKETS,
               0         as BROKEN_TICKETS
          from saled
        union all
        select AI_MM_ADMIN MARKET_ADMIN,
               plan_code,
               0           as open_inv,
               0           as CLOSE_INV,
               0           as GOT_TICKETS,
               0           as SALED_TICKETS,
               tickets     as canceled_tickets,
               0           as RETURN_TICKETS,
               0           as BROKEN_TICKETS
          from canceled
        union all
        select MARKET_MANAGER_ADMIN MARKET_ADMIN,
               plan_code,
               0                    as open_inv,
               0                    as CLOSE_INV,
               0                    as GOT_TICKETS,
               0                    as SALED_TICKETS,
               0                    as canceled_tickets,
               TICKETS              as RETURN_TICKETS,
               0                    as BROKEN_TICKETS
          from returned
        union all
        select APPLY_ADMIN MARKET_ADMIN,
               plan_code,
               0           as open_inv,
               0           as CLOSE_INV,
               0           as GOT_TICKETS,
               0           as SALED_TICKETS,
               0           as canceled_tickets,
               0           as RETURN_TICKETS,
               TICKETS     as BROKEN_TICKETS
          from broken
        union all
        select to_number(MARKET_ADMIN) MARKET_ADMIN,
               PLAN_CODE,
               open_inv,
               0 as CLOSE_INV,
               0 as GOT_TICKETS,
               0 as SALED_TICKETS,
               0 as canceled_tickets,
               0 as RETURN_TICKETS,
               0 as BROKEN_TICKETS
          from open_inv
        union all
        select to_number(MARKET_ADMIN) MARKET_ADMIN,
               PLAN_CODE,
               0 as open_inv,
               CLOSE_INV,
               0 as GOT_TICKETS,
               0 as SALED_TICKETS,
               0 as canceled_tickets,
               0 as RETURN_TICKETS,
               0 as BROKEN_TICKETS
          from close_inv),
      total_sum as
       (select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
               MARKET_ADMIN,
               PLAN_CODE,
               sum(open_inv) as open_inv,
               sum(CLOSE_INV) as CLOSE_INV,
               sum(GOT_TICKETS) GOT_TICKETS,
               sum(SALED_TICKETS) as SALED_TICKETS,
               sum(canceled_tickets) as canceled_tickets,
               sum(RETURN_TICKETS) as RETURN_TICKETS,
               sum(BROKEN_TICKETS) as BROKEN_TICKETS
          from total_detail
         group by MARKET_ADMIN, PLAN_CODE)
      -- 限制人员为市场管理员
      select * from total_sum where exists(select 1 from INF_MARKET_ADMIN where MARKET_ADMIN = total_sum.MARKET_ADMIN);

   commit;

   -- 3.17.1.4  部门应缴款报表（Institution Payable Report）
   insert into his_org_fund
     (calc_date, org_code, charge, withdraw, center_paid, center_paid_comm, pay_up)
   with base as
    (select org_code, FLOW_TYPE, sum(AMOUNT) as amount
       from his_agency_fund
       join inf_agencys
      using (agency_code)
      where CALC_DATE = to_char(p_curr_date - 1, 'yyyy-mm-dd')
        and FLOW_TYPE in (1, 2)
        and org_code in (select org_code from inf_orgs where ORG_TYPE = 1)
      group by org_code, FLOW_TYPE),
   center_pay as
    (select f_get_flow_pay_org(pay_flow) org_code, sum(pay_amount) amount
       from flow_pay
      where pay_time >= trunc(p_curr_date) - 1
        and pay_time < trunc(p_curr_date)
        and is_center_paid = 1
      group by f_get_flow_pay_org(pay_flow)),
   center_pay_comm as
    (select org_code, sum(change_amount) amount
       from flow_org
      where TRADE_TIME >= trunc(p_curr_date) - 1
        and TRADE_TIME < trunc(p_curr_date)
        and FLOW_TYPE = eflow_type.org_center_pay_comm
      group by org_code),
   fund as
    (select *
       from (select org_code, FLOW_TYPE, AMOUNT from base
             union all
             select org_code, 8 FLOW_TYPE, AMOUNT from center_pay
             union all
             select org_code, 21 FLOW_TYPE, AMOUNT from center_pay_comm
            ) pivot(sum(amount) for FLOW_TYPE in(1 as charge, 2 as withdraw, 8 as paid, 21 as paid_comm)))
   select to_char(p_curr_date - 1, 'yyyy-mm-dd') CALC_DATE,
          org_code,nvl(charge, 0) charge,
          nvl(withdraw, 0) withdraw,
          nvl(paid, 0) CENTER_PAID,
          nvl(paid_comm, 0) center_paid_comm,
          (nvl(charge, 0) - nvl(withdraw, 0) - nvl(paid, 0) + nvl(paid_comm, 0)) pay_up from inf_orgs left join fund using (org_code);

   commit;

   -- 部门库存日结
   insert into HIS_ORG_INV_REPORT (calc_date, org_code, oper_type, plan_code, amount, tickets)
   with base as (
      -- 调拨出库、站点退货
      select SEND_ORG org_code,wgid.ISSUE_TYPE do_type ,plan_code,sum(amount) amount, sum(tickets) tickets
        from WH_GOODS_ISSUE_DETAIL wgid
        join WH_GOODS_ISSUE wgi
       using (SGI_NO)
       where ISSUE_END_TIME >= trunc(p_curr_date) - 1
         and ISSUE_END_TIME < trunc(p_curr_date)
         and wgid.ISSUE_TYPE in (1,4)
         group by SEND_ORG,wgid.ISSUE_TYPE,plan_code
      union all
      -- 调拨入库，取计划入库数量（需要先找到调拨单，然后找到调拨单对应的出库单，获取实际出库明细）
      select wri.RECEIVE_ORG org_code, 12 do_type,plan_code,sum(wgid.amount) amount, sum(wgid.tickets) tickets
        from WH_GOODS_ISSUE_DETAIL wgid
        join SALE_TRANSFER_BILL stb
          on (wgid.REF_NO = stb.STB_NO)
        join WH_GOODS_receipt wri
          on (wri.REF_NO = stb.STB_NO)
       where receipt_END_TIME >= trunc(p_curr_date) - 1
         and receipt_END_TIME < trunc(p_curr_date)
         and (wri.receipt_TYPE = 2 or (wri.receipt_TYPE = 1 and wri.RECEIVE_ORG = '00'))
         group by wri.RECEIVE_ORG,wri.receipt_TYPE + 10,plan_code
      union all
      -- 站点入库销售
      select RECEIVE_ORG org_code,wgid.receipt_TYPE + 10 do_type,plan_code,sum(amount) amount, sum(tickets) tickets
        from WH_GOODS_receipt_DETAIL wgid
        join WH_GOODS_receipt wgi
       using (SGR_NO)
       where receipt_END_TIME >= trunc(p_curr_date) - 1
         and receipt_END_TIME < trunc(p_curr_date)
         and wgid.receipt_TYPE = 4
         group by RECEIVE_ORG,wgid.receipt_TYPE + 10,plan_code
      union all
      -- 损毁
      select f_get_admin_org(APPLY_ADMIN) org_code, 20 do_type,PLAN_CODE,
             sum(amount) amount, sum(WH_BROKEN_RECODER_DETAIL.packages) * 100
        from WH_BROKEN_RECODER join WH_BROKEN_RECODER_DETAIL using(BROKEN_NO)
       where APPLY_DATE >= trunc(p_curr_date) - 1
         and APPLY_DATE < trunc(p_curr_date)
       group by f_get_admin_org(APPLY_ADMIN),PLAN_CODE
      union all
      -- 期初库存
      select substr(WAREHOUSE,1,2) org_code,88 do_type,PLAN_CODE,sum(AMOUNT) AMOUNT,sum(TICKETS) TICKETS
        from HIS_LOTTERY_INVENTORY
       where calc_date = to_char(trunc(p_curr_date) - 2, 'yyyy-mm-dd')
         and STATUS = 11
       group by substr(WAREHOUSE,1,2),PLAN_CODE
      union all
      -- 期末库存
      select substr(WAREHOUSE,1,2) org_code,99 do_type,PLAN_CODE,sum(AMOUNT) AMOUNT,sum(TICKETS) TICKETS
        from HIS_LOTTERY_INVENTORY
       where calc_date = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
         and STATUS = 11
       group by substr(WAREHOUSE,1,2),PLAN_CODE
      union all
      select f_get_admin_org(market_admin) org, 66 do_type, PLAN_CODE,
             sum(OPEN_INV) * (select TICKET_AMOUNT from game_plans where plan_code = tt.plan_code),
             sum(OPEN_INV)
        from his_mm_inventory tt
       where calc_date = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
       group by f_get_admin_org(market_admin),plan_code
       union all
       select f_get_admin_org(market_admin) org, 77 do_type, PLAN_CODE,
              sum(CLOSE_INV) * (select TICKET_AMOUNT from game_plans where plan_code = tt.plan_code),
              sum(CLOSE_INV)
        from his_mm_inventory tt
       where calc_date = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
       group by f_get_admin_org(market_admin),plan_code
      )
   select to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd'), org_code, do_type, PLAN_CODE,amount, tickets from base;

   commit;

   if p_maintance_mod = 0 then
      -- 代理商资金报表（Agent Fund Report）
      insert into his_agent_fund_report (calc_date, org_code, flow_type, amount)
      with
         agent_org as (
            select org_code from inf_orgs where org_type = 2),
         base as (
            select org_code, flow_type, sum(change_amount) amount
              from flow_org
             where trade_time >= trunc(p_curr_date) - 1
               and trade_time < trunc(p_curr_date)
               and org_code in (select org_code from agent_org)
             group by org_code, flow_type),
         last_day as (
            select org_code, 88 as flow_type, amount
              from his_agent_fund_report
             where org_code in (select org_code from agent_org)
               and flow_type = 99
               and calc_date = to_char(trunc(p_curr_date) - 2, 'yyyy-mm-dd')),
         today as (
            select org_code, 99 as flow_type, account_balance amount
              from acc_org_account
             where org_code in (select org_code from agent_org)),
         plus_result as (
            select org_code, flow_type, amount from base
            union all
            select org_code, flow_type, amount from last_day
            union all
            select org_code, flow_type, amount from today)
      select to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd'), org_code, flow_type, amount
        from plus_result;

      commit;
   end if;

  -- 销售、退票和兑奖统计
  insert into his_sale_pay_cancel
    (sale_date, sale_month, area_code, org_code, plan_code, sale_amount, sale_comm, cancel_amount, cancel_comm, pay_amount, pay_comm, incoming)
  with sale as
   (select to_char(sale_time, 'yyyy-mm-dd') sale_day,
           to_char(sale_time, 'yyyy-mm') sale_month,
           area_code,
           org_code,
           f_get_old_plan_name(plan_code, batch_no) plan_code,
           sum(sale_amount) sale_amount,
           sum(comm_amount) as sale_comm
      from flow_sale
     where sale_time >= trunc(p_curr_date) - 1
       and sale_time <  trunc(p_curr_date)
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
     where cancel_time >= trunc(p_curr_date) - 1
       and cancel_time <  trunc(p_curr_date)
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
     where pay_time >= trunc(p_curr_date) - 1
       and pay_time <  trunc(p_curr_date)),
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
  select sale_day, sale_month, nvl(area_code, 'NULL'), org_code, plan_code,
         nvl(sum(sale_amount), 0) sale_amount,
         nvl(sum(sale_comm), 0) sale_comm,
         nvl(sum(cancel_amount), 0) cancel_amount,
         nvl(sum(cancel_comm), 0) cancel_comm,
         nvl(sum(pay_amount), 0) pay_amount,
         nvl(sum(pay_comm), 0) pay_comm,
         (nvl(sum(sale_amount), 0) - nvl(sum(sale_comm), 0) - nvl(sum(pay_amount), 0) - nvl(sum(pay_comm), 0) - nvl(sum(cancel_amount), 0) + nvl(sum(cancel_comm), 0)) incoming
    from pre_detail
   group by sale_day, sale_month, area_code, org_code, plan_code;

  insert into his_pay_level
    (sale_date, sale_month, org_code, plan_code, level_1, level_2, level_3, level_4, level_5, level_6, level_7, level_8, level_9, level_10, total)
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
     where pay_time >= trunc(p_curr_date) - 1
       and pay_time <  trunc(p_curr_date))
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
  commit;
end;
