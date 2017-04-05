create or replace procedure p_time_gen_by_day (
   p_curr_date       date        default sysdate,
   p_maintance_mod   number      default 0
)
/****************************************************************/
   ------------------- 仅用于统计数据（每日0点执行） -------------------
   ---- add by 陈震: 2015/10/14
   ----
   ---- modify by 陈震 @ 2016-10-26
   ---- 1、增加cncp日结部分
/*************************************************************/
is
begin

   if p_maintance_mod = 0 then
      -- 活动加送的佣金
      if to_char(sysdate, 'dd') = '01' then
        if f_get_sys_param(0) = 'KPW' then
          p_time_lot_promotion;
        end if;
      end if;

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
   select send_wh agency_code,plan_code,10 inv_type,sum(amount) amount, sum(tickets) tickets
     from wh_goods_issue mm join wh_goods_issue_detail detail using(sgi_no)
    where detail.issue_type = 4
      and issue_end_time >= trunc(p_curr_date) - 1
      and issue_end_time < trunc(p_curr_date)
   group by send_wh,plan_code
   union all
   -- 站点收货
   select receive_wh,plan_code,20 inv_type,sum(amount) amount, sum(tickets) tickets
    from wh_goods_receipt mm join wh_goods_receipt_detail detail using(sgr_no)
    where detail.receipt_type = 4
      and receipt_end_time >= trunc(p_curr_date) - 1
      and receipt_end_time < trunc(p_curr_date)
   group by receive_wh,plan_code
   union all
   -- 站点期初
   select warehouse,plan_code,88 inv_type,sum(amount) amount, sum(tickets) tickets
     from his_lottery_inventory
    where status = 31
      and calc_date = to_char(trunc(p_curr_date) - 2,'yyyy-mm-dd')
   group by warehouse,plan_code
   union all
   -- 站点期末
   select warehouse,plan_code,99 inv_type,sum(amount) amount, sum(tickets) tickets
     from his_lottery_inventory
    where status = 31
      and calc_date = to_char(trunc(p_curr_date) - 1,'yyyy-mm-dd')
   group by warehouse,plan_code)
   select to_char(trunc(p_curr_date) - 1,'yyyy-mm-dd'),agency_code, plan_code, inv_type, amount, tickets from base;

   commit;


    -- 销量按部门分方案监控
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
  /* --modify by kwx 2016-06-01 flow_pay里不记录代理商，而flow_pay_org_comm里不记录分公司,因此在做中心兑奖统计时需要将代理商和分公司的合并起来统计 */
    pay_center_stat as
    (select org_code, plan_code, nvl(sum(pay_amount),0) amount, nvl(sum(org_pay_comm),0) comm
       from flow_pay_org_comm, time_con
      where pay_time >= s_time
        and pay_time < e_time
        and is_center_paid = 1
    and f_get_org_type(org_code)=2
      group by org_code, plan_code
    union all
    select f_get_flow_pay_org(pay_flow) org_code, plan_code, nvl(sum(pay_amount),0) amount, nvl(sum(pay_comm),0) comm
       from flow_pay, time_con
      where pay_time >= s_time
        and pay_time < e_time
        and is_center_paid = 1
    and f_get_org_type(f_get_flow_pay_org(pay_flow))=1
      group by f_get_flow_pay_org(pay_flow), plan_code),
    lot_sale_stat as
      (select sale_area org_code, game_code, sum(sale_amount) amount, sum(sale_commission) comm
         from sub_sell, time_con
        where sale_date >= to_char(s_time,'yyyy-mm-dd')
          and sale_date < to_char(e_time,'yyyy-mm-dd')
        group by sale_area, game_code),
  /* --modify by kwx 2016-06-01 目前电脑票没有销售站票退票,但是中心退票会给销售站退佣金,因此暂时统计销售站退票的金额为0 */
     lot_cancel_stat as
      (select sale_area org_code, game_code, 0 amount, sum(cancel_commission) comm
         from sub_cancel, inf_orgs, time_con
        where cancel_date >= to_char(s_time,'yyyy-mm-dd')
          and cancel_date < to_char(e_time,'yyyy-mm-dd')
      and sale_area = org_code
          and org_type = 1
        group by sale_area, game_code),
     lot_pay_stat as
      (select pay_area org_code, game_code, sum(pay_amount) amount, sum(pay_commission) comm
         from sub_pay, time_con
        where pay_agency is not null and pay_date >= to_char(s_time,'yyyy-mm-dd')
          and pay_date < to_char(e_time,'yyyy-mm-dd')
        group by pay_area, game_code),
      lot_pay_center_stat as
      (select org_code,plan_code,sum(amount) amount,sum(comm) comm from (
      select org_code,
              (case when flow_type=36 then (select game_code from his_sellticket where applyflow_sell=(select applyflow_sell from his_payticket where applyflow_pay=flow_org.ref_no))
                    when flow_type=37 then (select game_code from his_sellticket where applyflow_sell=(select applyflow_sell from his_payticket where applyflow_pay=flow_org.ref_no))
              end) plan_code,
              (case when flow_type=37 then change_amount else 0 end) amount,(case when flow_type=36 then change_amount else 0 end) comm
           from flow_org , time_con
       where flow_type in (36,37)
          and trade_time >= s_time
          and trade_time < e_time) group by plan_code,org_code),
      lot_cancel_center_stat as
       (select org_code,plan_code,sum(amount) amount,sum(comm) comm from (
         select org_code,
               (case when flow_type=35 then (select game_code from his_sellticket where applyflow_sell=(select applyflow_sell from his_cancelticket where applyflow_cancel=flow_org.ref_no))
                     when flow_type=38 then (select game_code from his_sellticket where applyflow_sell=(select applyflow_sell from his_cancelticket where applyflow_cancel=flow_org.ref_no))
                end) plan_code,
               (case when flow_type=38 then change_amount else 0 end) amount,(case when flow_type=35 then change_amount else 0 end) comm
           from flow_org , time_con
        where flow_type in (35,38)
           and trade_time >= s_time
           and trade_time < e_time)
    group by plan_code,org_code),
     pre_detail as
    (select * from  (select org_code, plan_code, 1 ftype, amount, comm from sale_stat
                     union all
                     select org_code, plan_code, 2 ftype, amount, comm from cancel_stat
                     union all
                     select org_code, plan_code, 3 ftype, amount, comm from pay_stat
                     union all
                     select org_code, plan_code, 4 ftype, amount, comm from pay_center_stat
                     union all
                     select org_code, to_char(game_code), 5 ftype, amount, comm from lot_sale_stat
                     union all
                     select org_code, to_char(game_code), 6 ftype, amount, comm from lot_cancel_stat
                     union all
                     select org_code, to_char(game_code), 7 ftype, amount, comm from lot_pay_stat
                     union all
                     select org_code, to_char(plan_code), 8 ftype, amount, comm from lot_pay_center_stat
                     union all
                     select org_code, to_char(plan_code), 9 ftype, amount, comm from lot_cancel_center_stat)
      pivot (sum(amount) as amount, sum(comm) as comm for ftype in (1 as sale, 2 as cancel, 3 as pay, 4 as pay_center, 5 as lot_sale, 6 as lot_cancel, 7 as lot_pay, 8 as lot_pay_center, 9 as lot_cancel_center))
    ),
   no_null as (
   select to_char(time_con.s_time, 'yyyy-mm-dd') calc_date,
          org_code,
          plan_code,
          nvl(sale_amount, 0) sale_amount,
          nvl(sale_comm, 0) sale_comm,
          nvl(pay_amount, 0) pay_amount,
          nvl(pay_comm, 0) pay_comm,
          nvl(pay_center_amount, 0) pay_center_amount,
          nvl(pay_center_comm, 0) pay_center_comm,
          nvl(cancel_amount, 0) cancel_amount,
          nvl(cancel_comm, 0) cancel_comm,
          nvl(lot_sale_amount, 0) lot_sale_amount,
          nvl(lot_sale_comm, 0) lot_sale_comm,
          nvl(lot_pay_amount, 0) lot_pay_amount,
          nvl(lot_pay_comm, 0) lot_pay_comm,
          nvl(lot_pay_center_amount, 0) lot_pay_center_amount,
          nvl(lot_pay_center_comm, 0) lot_pay_center_comm,
          nvl(lot_cancel_amount, 0) lot_cancel_amount,
          nvl(lot_cancel_comm, 0) lot_cancel_comm,
      nvl(lot_cancel_center_amount,0) lot_cancel_center_amount,
      nvl(lot_cancel_center_comm,0) lot_cancel_center_comm
     from pre_detail, time_con)
     select calc_date,
       org_code,
       plan_code,
       (sale_amount + lot_sale_amount) as sale_amount,
       (sale_comm + lot_sale_comm) as sale_comm,
       (cancel_amount + lot_cancel_amount + lot_cancel_center_amount) as cancel_amount,
       (cancel_comm + lot_cancel_comm + lot_cancel_center_comm) as cancel_comm,
       (pay_amount + pay_center_amount + lot_pay_amount + lot_pay_center_amount) as pay_amount,
       (pay_comm + pay_center_comm + lot_pay_comm + lot_pay_center_comm) as pay_comm,
          (sale_amount + lot_sale_amount - sale_comm - lot_sale_comm - pay_amount - lot_pay_amount - pay_comm  - lot_pay_comm - pay_center_amount - lot_pay_center_amount - pay_center_comm - lot_pay_center_comm - cancel_amount - lot_cancel_amount + cancel_comm + lot_cancel_comm - lot_cancel_center_amount + lot_cancel_center_comm) incoming
     from no_null;

   commit;

   -- 3.17.1.1  部门资金报表（institution fund reports）
   insert into his_org_fund_report
      (calc_date,       org_code,
       -- 通用
       be_account_balance,  af_account_balance,     charge,    withdraw,     incoming,  pay_up,
       -- 即开票
       sale,                sale_comm,              paid,      pay_comm,     rtv,       rtv_comm,     center_pay,     center_pay_comm,
       -- 电脑票
       lot_sale,            lot_sale_comm,          lot_paid,  lot_pay_comm, lot_rtv,   lot_rtv_comm, lot_center_pay, lot_center_pay_comm,  lot_center_rtv, lot_center_rtv_comm
       )
   with base as
    (select org_code,
            flow_type,
            sum(amount) as amount,
            sum(be_account_balance) as be_account_balance,
            sum(af_account_balance) as af_account_balance
       from his_agency_fund
       join inf_agencys
      using (agency_code)
      where calc_date = to_char(p_curr_date - 1, 'yyyy-mm-dd')
      group by org_code, flow_type),
   center_pay as
    (select f_get_flow_pay_org(pay_flow) org_code, 24 flow_type, sum(pay_amount) amount
       from flow_pay
      where pay_time >= trunc(p_curr_date) - 1
        and pay_time < trunc(p_curr_date)
        and is_center_paid = 1
      group by f_get_flow_pay_org(pay_flow)),
   center_pay_comm as
    (select org_code, flow_type, sum(change_amount) amount
       from flow_org
      where trade_time >= trunc(p_curr_date) - 1
        and trade_time < trunc(p_curr_date)
        and flow_type in (23,35,36,37,38)
      group by org_code, flow_type),
   agency_balance as
    (select * from (select org_code, be_account_balance, af_account_balance
       from base
      where flow_type = 0)
      unpivot (amount for flow_type in (be_account_balance as 88, af_account_balance as 99))),
   fund as
    (select *
       from (select org_code, flow_type, amount from base
             union all
             select org_code, flow_type, amount from center_pay_comm
             union all
             select org_code, flow_type, amount from agency_balance
             union all
             select org_code, flow_type, amount from center_pay) pivot(sum(amount) for flow_type in(1 as charge,
                                                                   2  as withdraw,
                                                                   5  as sale_comm,
                                                                   6  as pay_comm,
                                                                   7  as sale,
                                                                   8  as paid,
                                                                   11 as rtv,
                                                                   13 as rtv_comm,
                                                                   24 as center_pay,
                                                                   23 as center_pay_comm,
                                                                   45 as lot_sale,
                                                                   43 as lot_sale_comm,
                                                                   41 as lot_paid,
                                                                   44 as lot_pay_comm,
                                                                   42 as lot_rtv,
                                                                   47 as lot_rtv_comm,
                                                                   37 as lot_center_pay,
                                                                   36 as lot_center_pay_comm,
                                                                   38 as lot_center_rtv,
                                                                   35 as lot_center_rtv_comm,
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
            nvl(lot_sale, 0) lot_sale,
            nvl(lot_sale_comm, 0) lot_sale_comm,
            nvl(lot_paid, 0) lot_paid,
            nvl(lot_pay_comm, 0) lot_pay_comm,
            nvl(lot_rtv, 0) lot_rtv,
            nvl(lot_rtv_comm, 0) lot_rtv_comm,
            nvl(lot_center_pay, 0) lot_center_pay,
            nvl(lot_center_pay_comm, 0) lot_center_pay_comm,
            nvl(lot_center_rtv, 0) lot_center_rtv,
            (case 2 when (select org_type from inf_orgs where org_code=fund.org_code) then (nvl(lot_center_rtv_comm, 0) - nvl(lot_rtv_comm, 0))  else nvl(lot_center_rtv_comm, 0) end) lot_center_rtv_comm,
            nvl(af, 0) af_account_balance
       from fund),
   will_write as
   (select org_code,
           -- 通用
           be_account_balance, af_account_balance,          charge,          withdraw,
           -- 销售金额-销售佣金-兑奖-兑奖佣金-中心兑奖-中心兑奖佣金+退货佣金-退货金额 -中心退票+中心退票佣金
           (sale - sale_comm - paid - pay_comm - center_pay - center_pay_comm + rtv_comm - rtv
            + lot_sale - lot_sale_comm - lot_paid - lot_pay_comm - lot_center_pay - lot_center_pay_comm - lot_rtv + lot_rtv_comm
            - lot_center_rtv + lot_center_rtv_comm) incoming,
           (charge - withdraw - center_pay - center_pay_comm - lot_center_pay - lot_center_pay_comm  - lot_rtv - lot_rtv_comm - lot_center_rtv - lot_center_rtv_comm) pay_up,
           -- 即开票
           sale,                sale_comm,              paid,      pay_comm,     rtv,       rtv_comm,     center_pay,     center_pay_comm,
           -- 电脑票
           lot_sale,            lot_sale_comm,          lot_paid,  lot_pay_comm, lot_rtv,   lot_rtv_comm, lot_center_pay, lot_center_pay_comm, lot_center_rtv,lot_center_rtv_comm
      from pre_detail)
   select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
          org_code,
          nvl(be_account_balance , 0),   nvl(af_account_balance , 0),   nvl(charge , 0),      nvl(withdraw , 0),          nvl(incoming , 0),    nvl(pay_up , 0),
          nvl(sale , 0),                 nvl(sale_comm , 0),            nvl(paid , 0),        nvl(pay_comm , 0),          nvl(rtv , 0),         nvl(rtv_comm , 0),      nvl(center_pay , 0),     nvl(center_pay_comm , 0),
          nvl(lot_sale , 0),             nvl(lot_sale_comm , 0),        nvl(lot_paid , 0),    nvl(lot_pay_comm , 0),      nvl(lot_rtv , 0),     nvl(lot_rtv_comm , 0),  nvl(lot_center_pay , 0), nvl(lot_center_pay_comm , 0),   nvl(lot_center_rtv , 0),   nvl(lot_center_rtv_comm , 0)
     from will_write right join inf_orgs using (org_code);

    commit;

    if p_maintance_mod = 0 then
       -- 管理员资金日结
       insert into his_mm_fund (calc_date, market_admin, flow_type, amount, be_account_balance, af_account_balance)
         with last_day as
          (select market_admin, af_account_balance be_account_balance
             from his_mm_fund
            where calc_date = to_char(p_curr_date - 2, 'yyyy-mm-dd')
              and flow_type = 0),
         this_day as
          (select market_admin, account_balance af_account_balance
             from acc_mm_account
            where acc_type = 1),
         mm_balance as
          (select market_admin, be_account_balance, 0 as af_account_balance
             from last_day
           union all
           select market_admin, 0 as be_account_balance, af_account_balance
             from this_day),
         mb as
          (select market_admin,
                  sum(be_account_balance) be_account_balance,
                  sum(af_account_balance) af_account_balance
             from mm_balance
            group by market_admin),
         now_fund as
          (select market_admin, flow_type, sum(change_amount) as amount
             from flow_market_manager
            where trade_time >= trunc(p_curr_date - 1)
              and trade_time < trunc(p_curr_date)
            group by market_admin, flow_type)
         select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
                market_admin,
                flow_type,
                amount,
                0 be_account_balance,
                0 af_account_balance
           from now_fund
         union all
         select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
                market_admin,
                0,
                0,
                be_account_balance,
                af_account_balance
           from mb;

      commit;
   end if;

   -- 管理员库存日结
   insert into his_mm_inventory (calc_date, market_admin, plan_code, open_inv, close_inv, got_tickets, saled_tickets, canceled_tickets, return_tickets, broken_tickets)
      with
      -- 期初
      open_inv as
       (select warehouse market_admin, plan_code, sum(tickets) open_inv
          from his_lottery_inventory
         where calc_date = to_char(trunc(p_curr_date) - 2, 'yyyy-mm-dd')
           and status = 21
         group by warehouse, plan_code),
      -- 期末
      close_inv as
       (select warehouse market_admin, plan_code, sum(tickets) close_inv
          from his_lottery_inventory
         where calc_date = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
           and status = 21
         group by warehouse, plan_code),
      -- 收货
      got as
       (select apply_admin, plan_code, sum(detail.tickets) tickets
          from sale_delivery_order mm
          join wh_goods_issue_detail detail
            on (mm.do_no = detail.ref_no)
         where status = 4
           and out_date >= trunc(p_curr_date - 1)
           and out_date < trunc(p_curr_date)
         group by apply_admin, plan_code),
      -- 销售
      saled as
       (select ar_admin, plan_code, sum(detail.tickets) tickets
          from sale_agency_receipt mm
          join wh_goods_receipt_detail detail
            on (mm.ar_no = detail.ref_no)
         where ar_date >= trunc(p_curr_date - 1)
           and ar_date < trunc(p_curr_date)
         group by ar_admin, plan_code),
      -- 退货
      canceled as
       (select ai_mm_admin, plan_code, sum(detail.tickets) tickets
          from sale_agency_return mm
          join wh_goods_issue_detail detail
            on (mm.ai_no = detail.ref_no)
         where ai_date >= trunc(p_curr_date - 1)
           and ai_date < trunc(p_curr_date)
         group by ai_mm_admin, plan_code),
      -- 还货
      returned as
       (select market_manager_admin, plan_code, sum(detail.tickets) tickets
          from sale_return_recoder mm
          join wh_goods_receipt_detail detail
            on (mm.return_no = detail.ref_no)
         where status = 6
           and receive_date >= trunc(p_curr_date - 1)
           and receive_date < trunc(p_curr_date)
         group by market_manager_admin, plan_code),
      -- 损毁
      broken_detail as
       (select broken_no,
               plan_code,
               packages * (select tickets_every_pack
                             from game_batch_import_detail
                            where plan_code = tt.plan_code
                              and batch_no = tt.batch_no) tickets
          from wh_broken_recoder_detail tt),
      broken as
       (select apply_admin, plan_code, sum(tickets) tickets
          from wh_broken_recoder
          join broken_detail
         using (broken_no)
         where apply_date >= trunc(p_curr_date - 1)
           and apply_date < trunc(p_curr_date)
         group by apply_admin, plan_code),
      total_detail as
       (select apply_admin market_admin,
               plan_code,
               0           as open_inv,
               0           as close_inv,
               tickets     got_tickets,
               0           as saled_tickets,
               0           as canceled_tickets,
               0           as return_tickets,
               0           as broken_tickets
          from got
        union all
        select ar_admin  market_admin,
               plan_code,
               0         as open_inv,
               0         as close_inv,
               0         as got_tickets,
               tickets   as saled_tickets,
               0         as canceled_tickets,
               0         as return_tickets,
               0         as broken_tickets
          from saled
        union all
        select ai_mm_admin market_admin,
               plan_code,
               0           as open_inv,
               0           as close_inv,
               0           as got_tickets,
               0           as saled_tickets,
               tickets     as canceled_tickets,
               0           as return_tickets,
               0           as broken_tickets
          from canceled
        union all
        select market_manager_admin market_admin,
               plan_code,
               0                    as open_inv,
               0                    as close_inv,
               0                    as got_tickets,
               0                    as saled_tickets,
               0                    as canceled_tickets,
               tickets              as return_tickets,
               0                    as broken_tickets
          from returned
        union all
        select apply_admin market_admin,
               plan_code,
               0           as open_inv,
               0           as close_inv,
               0           as got_tickets,
               0           as saled_tickets,
               0           as canceled_tickets,
               0           as return_tickets,
               tickets     as broken_tickets
          from broken
        union all
        select to_number(market_admin) market_admin,
               plan_code,
               open_inv,
               0 as close_inv,
               0 as got_tickets,
               0 as saled_tickets,
               0 as canceled_tickets,
               0 as return_tickets,
               0 as broken_tickets
          from open_inv
        union all
        select to_number(market_admin) market_admin,
               plan_code,
               0 as open_inv,
               close_inv,
               0 as got_tickets,
               0 as saled_tickets,
               0 as canceled_tickets,
               0 as return_tickets,
               0 as broken_tickets
          from close_inv),
      total_sum as
       (select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
               market_admin,
               plan_code,
               sum(open_inv) as open_inv,
               sum(close_inv) as close_inv,
               sum(got_tickets) got_tickets,
               sum(saled_tickets) as saled_tickets,
               sum(canceled_tickets) as canceled_tickets,
               sum(return_tickets) as return_tickets,
               sum(broken_tickets) as broken_tickets
          from total_detail
         group by market_admin, plan_code)
      -- 限制人员为市场管理员
      select * from total_sum where exists(select 1 from inf_market_admin where market_admin = total_sum.market_admin);

   commit;

   -- 3.17.1.4  部门应缴款报表（institution payable report）
   insert into his_org_fund
     (calc_date, org_code, charge, withdraw, center_paid, center_paid_comm, pay_up)
   with base as
    (select org_code, flow_type, sum(amount) as amount
       from his_agency_fund
       join inf_agencys
      using (agency_code)
      where calc_date = to_char(p_curr_date - 1, 'yyyy-mm-dd')
        and flow_type in (1, 2)
        and org_code in (select org_code from inf_orgs where org_type = 1)
      group by org_code, flow_type),
   center_pay as
    (select org_code, sum(change_amount) amount
       from flow_org
      where trade_time >= trunc(p_curr_date) - 1
        and trade_time < trunc(p_curr_date)
        and flow_type = eflow_type.org_center_pay
      group by org_code),
   center_pay_comm as
    (select org_code, sum(change_amount) amount
       from flow_org
      where trade_time >= trunc(p_curr_date) - 1
        and trade_time < trunc(p_curr_date)
        and flow_type = eflow_type.org_center_pay_comm
      group by org_code),
   fund as
    (select *
       from (select org_code, flow_type, amount from base
             union all
             select org_code, 8 flow_type, amount from center_pay
             union all
             select org_code, 21 flow_type, amount from center_pay_comm
            ) pivot(sum(amount) for flow_type in(1 as charge, 2 as withdraw, 8 as paid, 21 as paid_comm)))
   select to_char(p_curr_date - 1, 'yyyy-mm-dd') calc_date,
          org_code,nvl(charge, 0) charge,
          nvl(withdraw, 0) withdraw,
          nvl(paid, 0) center_paid,
          nvl(paid_comm, 0) center_paid_comm,
          (nvl(charge, 0) - nvl(withdraw, 0) - nvl(paid, 0) + nvl(paid_comm, 0)) pay_up
     from inf_orgs left join fund using (org_code);

   commit;

   -- 部门库存日结
   insert into his_org_inv_report (calc_date, org_code, oper_type, plan_code, amount, tickets)
   with base as (
      -- 调拨出库、站点退货
      select send_org org_code,wgid.issue_type do_type ,plan_code,sum(amount) amount, sum(tickets) tickets
        from wh_goods_issue_detail wgid
        join wh_goods_issue wgi
       using (sgi_no)
       where issue_end_time >= trunc(p_curr_date) - 1
         and issue_end_time < trunc(p_curr_date)
         and wgid.issue_type in (1,4)
         group by send_org,wgid.issue_type,plan_code
      union all
      -- 调拨入库，取计划入库数量（需要先找到调拨单，然后找到调拨单对应的出库单，获取实际出库明细）
      select wri.receive_org org_code, 12 do_type,plan_code,sum(wgid.amount) amount, sum(wgid.tickets) tickets
        from wh_goods_issue_detail wgid
        join sale_transfer_bill stb
          on (wgid.ref_no = stb.stb_no)
        join wh_goods_receipt wri
          on (wri.ref_no = stb.stb_no)
       where receipt_end_time >= trunc(p_curr_date) - 1
         and receipt_end_time < trunc(p_curr_date)
         and (wri.receipt_type = 2 or (wri.receipt_type = 1 and wri.receive_org = '00'))
         group by wri.receive_org,wri.receipt_type + 10,plan_code
      union all
      -- 站点入库销售
      select receive_org org_code,wgid.receipt_type + 10 do_type,plan_code,sum(amount) amount, sum(tickets) tickets
        from wh_goods_receipt_detail wgid
        join wh_goods_receipt wgi
       using (sgr_no)
       where receipt_end_time >= trunc(p_curr_date) - 1
         and receipt_end_time < trunc(p_curr_date)
         and wgid.receipt_type = 4
         group by receive_org,wgid.receipt_type + 10,plan_code
      union all
      -- 损毁
      select f_get_admin_org(apply_admin) org_code, 20 do_type,plan_code,
             sum(amount) amount, sum(wh_broken_recoder_detail.packages) * 100
        from wh_broken_recoder join wh_broken_recoder_detail using(broken_no)
       where apply_date >= trunc(p_curr_date) - 1
         and apply_date < trunc(p_curr_date)
       group by f_get_admin_org(apply_admin),plan_code
      union all
      -- 期初库存
      select substr(warehouse,1,2) org_code,88 do_type,plan_code,sum(amount) amount,sum(tickets) tickets
        from his_lottery_inventory
       where calc_date = to_char(trunc(p_curr_date) - 2, 'yyyy-mm-dd')
         and status = 11
       group by substr(warehouse,1,2),plan_code
      union all
      -- 期末库存
      select substr(warehouse,1,2) org_code,99 do_type,plan_code,sum(amount) amount,sum(tickets) tickets
        from his_lottery_inventory
       where calc_date = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
         and status = 11
       group by substr(warehouse,1,2),plan_code
      union all
      select f_get_admin_org(market_admin) org, 66 do_type, plan_code,
             sum(open_inv) * (select ticket_amount from game_plans where plan_code = tt.plan_code),
             sum(open_inv)
        from his_mm_inventory tt
       where calc_date = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
       group by f_get_admin_org(market_admin),plan_code
       union all
       select f_get_admin_org(market_admin) org, 77 do_type, plan_code,
              sum(close_inv) * (select ticket_amount from game_plans where plan_code = tt.plan_code),
              sum(close_inv)
        from his_mm_inventory tt
       where calc_date = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
       group by f_get_admin_org(market_admin),plan_code
      )
   select to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd'), org_code, do_type, plan_code,amount, tickets
     from base;

   commit;

   if p_maintance_mod = 0 then
      -- 代理商资金报表（agent fund report）
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
  -- 即开票
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
       and pay_time <  trunc(p_curr_date) ),
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
  ),
  -- 电脑票
  lot_sale as
   (select to_char(saletime, 'yyyy-mm-dd') sale_day,
           to_char(saletime, 'yyyy-mm') sale_month,
           area_code,
           org_code,
           f_get_game_name(game_code) plan_code,
           sum(ticket_amount) lot_sale_amount,
           sum(commissionamount) as lot_sale_comm
      from his_sellticket join inf_agencys
        on his_sellticket.agency_code=inf_agencys.agency_code
        and saletime >= trunc(p_curr_date) - 1
        and saletime <  trunc(p_curr_date) 
        group by area_code,
              org_code,
              f_get_game_name(game_code),
              to_char(saletime, 'yyyy-mm-dd'),
              to_char(saletime, 'yyyy-mm')),
  lot_cancel as
   (select to_char(canceltime, 'yyyy-mm-dd') sale_day,
           to_char(canceltime, 'yyyy-mm') sale_month,
       f_get_agency_area(his_cancelticket.applyflow_sell) area_code,
           org_code,
           f_get_game_name(game_code) plan_code,
           sum(ticket_amount) lot_cancel_amount,
           sum(commissionamount) as lot_cancel_comm
      from his_cancelticket join his_sellticket
        on his_cancelticket.applyflow_sell=his_sellticket.applyflow_sell
        and  canceltime >= trunc(p_curr_date) - 1
        and canceltime <  trunc(p_curr_date) 
        group by f_get_agency_area(his_cancelticket.applyflow_sell),
              org_code,
              f_get_game_name(game_code),
              to_char(canceltime, 'yyyy-mm-dd'),
              to_char(canceltime, 'yyyy-mm')),    
  lot_pay as
   (select to_char(paytime, 'yyyy-mm-dd') sale_day,
           to_char(paytime, 'yyyy-mm') sale_month,
           f_get_agency_area(applyflow_sell) area_code,
           org_code,
           f_get_game_name(game_code) plan_code,
           sum(winningamount) lot_pay_amount,
           sum(commissionamount) lot_pay_comm
      from his_payticket
     where paytime >= trunc(p_curr_date) - 1
       and paytime <  trunc(p_curr_date)
     group by to_char(paytime, 'yyyy-mm-dd'),
              to_char(paytime, 'yyyy-mm'),
              f_get_agency_area(applyflow_sell),
              org_code,
              f_get_game_name(game_code)),
  lot_pre_detail as (
     select sale_day, sale_month, area_code, org_code, plan_code, lot_sale_amount, lot_sale_comm, 0 as lot_cancel_amount, 0 as lot_cancel_comm, 0 as lot_pay_amount, 0 as lot_pay_comm from lot_sale
      union all
     select sale_day, sale_month, area_code, org_code, plan_code, 0 as lot_sale_amount, 0 as lot_sale_comm, lot_cancel_amount, lot_cancel_comm, 0 as lot_pay_amount, 0 as lot_pay_comm from lot_cancel
      union all
     select sale_day, sale_month, area_code, org_code, plan_code, 0 as lot_sale_amount, 0 as lot_sale_comm, 0 as lot_cancel_amount, 0 as lot_cancel_comm, lot_pay_amount, lot_pay_comm from lot_pay
  )
  --计开票
  select sale_day, sale_month, nvl(area_code, 'none') area_code, org_code, plan_code,
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
  --电脑票
  select sale_day, sale_month, nvl(area_code, 'none') area_code, org_code, to_char(plan_code),
         nvl(sum(lot_sale_amount), 0) sale_amount,
         nvl(sum(lot_sale_comm), 0) sale_comm,
         nvl(sum(lot_cancel_amount), 0) cancel_amount,
         nvl(sum(lot_cancel_comm), 0) cancel_comm,
         nvl(sum(lot_pay_amount), 0) pay_amount,
         nvl(sum(lot_pay_comm), 0) pay_comm,
         (nvl(sum(lot_sale_amount), 0) - nvl(sum(lot_sale_comm), 0) - nvl(sum(lot_pay_amount), 0) - nvl(sum(lot_pay_comm), 0) - nvl(sum(lot_cancel_amount), 0) + nvl(sum(lot_cancel_comm), 0)) incoming
    from lot_pre_detail
   group by sale_day, sale_month, area_code, org_code, plan_code;
  
  commit;

  insert into his_pay_level
    (sale_date, sale_month, org_code, plan_code, level_1, level_2, level_3, level_4, level_5, level_6, level_7, level_8, level_other, total)
  with
  pay_detail as
     (select to_char(pay_time, 'yyyy-mm-dd') sale_day,
             to_char(pay_time, 'yyyy-mm') sale_month,
             f_get_old_plan_name(plan_code,batch_no) plan_code,
             (case when reward_no = 1 then pay_amount else 0 end) level_1,
             (case when reward_no = 2 then pay_amount else 0 end) level_2,
             (case when reward_no = 3 then pay_amount else 0 end) level_3,
             (case when reward_no = 4 then pay_amount else 0 end) level_4,
             (case when reward_no = 5 then pay_amount else 0 end) level_5,
             (case when reward_no = 6 then pay_amount else 0 end) level_6,
             (case when reward_no = 7 then pay_amount else 0 end) level_7,
             (case when reward_no = 8 then pay_amount else 0 end) level_8,
             (case when reward_no in (9,10,11,12,13) then pay_amount else 0 end) level_other,
             pay_amount,
             f_get_flow_pay_org(pay_flow) org_code
        from flow_pay
     where pay_time >= trunc(p_curr_date) - 1
       and pay_time <  trunc(p_curr_date))
  select sale_day,
         sale_month,
         org_code,
         plan_code,
         sum(level_1) as level_1,
         sum(level_2) as level_2,
         sum(level_3) as level_3,
         sum(level_4) as level_4,
         sum(level_5) as level_5,
         sum(level_6) as level_6,
         sum(level_7) as level_7,
         sum(level_8) as level_8,
         sum(level_other) as level_other,
         sum(pay_amount) as total
    from pay_detail
   group by sale_day,
            sale_month,
            org_code,
            plan_code;
  commit;


end;