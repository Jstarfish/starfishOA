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
    (select org_code,
            plan_code,
            sum(sale_amount) sale_amount,
            sum(COMM_AMOUNT) sale_comm
       from flow_sale, time_con
      where sale_time >= s_time
        and sale_time < e_time
      group by org_code, plan_code),
   cancel_stat as
    (select org_code,
            plan_code,
            sum(sale_amount) cancel_amount,
            sum(COMM_AMOUNT) cancel_comm
       from flow_cancel, time_con
      where cancel_time >= s_time
        and cancel_time < e_time
      group by org_code, plan_code),
   pay_stat as
    (select f_get_flow_pay_org(PAY_FLOW) org_code,
            plan_code,
            nvl(sum(PAY_AMOUNT),0) PAY_AMOUNT,
            nvl(sum(PAY_COMM),0) PAY_COMM
       from flow_pay, time_con
      where PAY_TIME >= s_time
        and PAY_TIME < e_time
      group by f_get_flow_pay_org(PAY_FLOW), plan_code),
   pre_detail as
    (select org_code,
            plan_code,
            sale_amount,
            sale_comm,
            0           as cancel_amount,
            0           as cancel_comm,
            0           as PAY_AMOUNT,
            0           as PAY_COMM
       from sale_stat
     union all
     select org_code,
            plan_code,
            0             as sale_amount,
            0             as sale_comm,
            cancel_amount,
            cancel_comm,
            0             as PAY_AMOUNT,
            0             as PAY_COMM
       from cancel_stat
     union all
     select org_code,
            plan_code,
            0          as sale_amount,
            0          as sale_comm,
            0          as cancel_amount,
            0          as cancel_comm,
            PAY_AMOUNT,
            PAY_COMM
       from pay_stat)
   select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
          org_code,
          plan_code,
          sum(sale_amount) sale_amount,
          sum(sale_comm) sale_comm,
          sum(cancel_amount) cancel_amount,
          sum(cancel_comm) cancel_comm,
          sum(PAY_AMOUNT) PAY_AMOUNT,
          sum(PAY_COMM) PAY_COMM,
          sum(sale_amount - sale_comm - PAY_AMOUNT - PAY_COMM - cancel_amount +
              cancel_comm) incoming
     from pre_detail
    group by org_code, plan_code;

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
   center_pay_comm as
    (select f_get_flow_pay_org(PAY_FLOW) org_code,
            21 FLOW_TYPE,
            sum(PAY_AMOUNT * (case
                  when f_get_org_comm_rate(f_get_flow_pay_org(PAY_FLOW),
                                           plan_code,
                                           batch_no,
                                           2) = -1 then
                   0
                  else
                   f_get_org_comm_rate(f_get_flow_pay_org(PAY_FLOW),
                                       plan_code,
                                       batch_no,
                                       2)
                end) / 1000) AMOUNT
       from flow_pay
      where IS_CENTER_PAID = 1
        and PAY_TIME >= trunc(p_curr_date) - 1
        and PAY_TIME < trunc(p_curr_date)
        and '1' = f_get_sys_param('16')
        and f_get_flow_pay_org(PAY_FLOW) in (select ORG_CODE from INF_ORGS where ORG_TYPE = 2)
      group by f_get_flow_pay_org(PAY_FLOW)),
   center_pay as
    (select f_get_flow_pay_org(PAY_FLOW) org_code,
            20 FLOW_TYPE,
            sum(PAY_AMOUNT) AMOUNT
       from flow_pay
      where IS_CENTER_PAID = 1
        and PAY_TIME >= trunc(p_curr_date) - 1
        and PAY_TIME < trunc(p_curr_date)
      group by f_get_flow_pay_org(PAY_FLOW)),
   fund as
    (select *
       from (select org_code, FLOW_TYPE, AMOUNT from base
             union all
             select org_code, FLOW_TYPE, AMOUNT from center_pay_comm
             union all
             select org_code, FLOW_TYPE, AMOUNT from center_pay) pivot(sum(amount) for FLOW_TYPE in(1 as charge,
                                                                   2 as
                                                                   withdraw,
                                                                   5 as
                                                                   sale_comm,
                                                                   6 as
                                                                   pay_comm,
                                                                   7 as sale,
                                                                   8 as paid,
                                                                   11 as rtv,
                                                                   13 as
                                                                   rtv_comm,
                                                                   20 as
                                                                   center_pay,
                                                                   21 as
                                                                   center_pay_comm))),
   agency_ava as
    (select org_code, BE_ACCOUNT_BALANCE, AF_ACCOUNT_BALANCE
       from base
      where flow_type = 0),
   pre_detail as
    (select org_code,
            nvl(be_account_balance, 0) be_account_balance,
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
            nvl(af_account_balance, 0) af_account_balance
       from fund
       join agency_ava
      using (org_code))
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
      group by org_code, FLOW_TYPE),
   center_pay as
    (select f_get_flow_pay_org(PAY_FLOW) org_code, sum(PAY_AMOUNT) AMOUNT
       from flow_pay
      where PAY_TIME >= trunc(p_curr_date) - 1
        and PAY_TIME < trunc(p_curr_date)
        and IS_CENTER_PAID = 1
      group by f_get_flow_pay_org(PAY_FLOW)),
   center_pay_comm as
    (select f_get_flow_pay_org(PAY_FLOW) org_code,
            21 FLOW_TYPE,
            sum(PAY_AMOUNT * (case
                  when f_get_org_comm_rate(f_get_flow_pay_org(PAY_FLOW),
                                           plan_code,
                                           batch_no,
                                           2) = -1 then
                   0
                  else
                   f_get_org_comm_rate(f_get_flow_pay_org(PAY_FLOW),
                                       plan_code,
                                       batch_no,
                                       2)
                end) / 1000) AMOUNT
       from flow_pay
      where IS_CENTER_PAID = 1
        and PAY_TIME >= trunc(p_curr_date) - 1
        and PAY_TIME < trunc(p_curr_date)
        and '1' = f_get_sys_param('16')
        and f_get_flow_pay_org(PAY_FLOW) in (select ORG_CODE from INF_ORGS where ORG_TYPE = 2)
      group by f_get_flow_pay_org(PAY_FLOW)),
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

end;
