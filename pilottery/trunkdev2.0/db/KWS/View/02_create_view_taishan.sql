/******************************************/
/** 创建普通功能视图 **/

-- 获取当前正在生效的游戏历史参数
create or replace view v_gp_his_current
as
select his_his_code, game_code, is_open_risk, risk_param
  from gp_history
 where (his_his_code, game_code) in
       (select max(his_his_code), game_code
          from gp_history
         group by game_code);

-- 获取当前正在生效的游戏政策参数
create or replace view v_gp_policy_current
as
select his_policy_code,
       game_code,
       theory_rate,
       fund_rate,
       adj_rate,
       tax_threshold,
       tax_rate,
       draw_limit_day
  from gp_policy
 where (his_policy_code, game_code) in
       (select max(his_policy_code), game_code
          from gp_policy
         group by game_code);

-- 获取当前正在生效的游戏玩法规则
create or replace view v_gp_rule_current
as
select his_rule_code,
       game_code,
       rule_code,
       rule_name,
       rule_desc,
       rule_enable
  from gp_rule
 where (his_rule_code, game_code, rule_code) in
       (select max(his_rule_code), game_code, rule_code
          from gp_rule
         group by game_code, rule_code);

-- 获取当前正在生效的游戏中奖规则
create or replace view v_gp_win_rule_current
as
select his_win_code, game_code, wrule_code, wrule_name, wrule_desc
  from gp_win_rule
 where (his_win_code, game_code, wrule_code) in
       (select max(his_win_code), game_code, wrule_code
          from gp_win_rule
         group by game_code, wrule_code);

-- 获取当前正在生效的游戏奖级规则
create or replace view v_gp_prize_rule_current
as
select his_prize_code,
       game_code,
       prule_level,
       prule_name,
       prule_desc,
       level_prize,
       disp_order
  from gp_prize_rule
 where (his_prize_code, game_code, prule_level) in
       (select max(his_prize_code), game_code, prule_level
          from gp_prize_rule
         group by game_code, prule_level);

-- 游戏普通规则参数
create or replace view v_gp_normal_rule
as
select gps.game_code,
       draw_mode,
       singlebet_amount,
       singleticket_max_issues,
       singleline_max_amount,
       singleticket_max_line,
       singleticket_max_amount,
       abandon_reward_collect
  from gp_static gps, gp_dynamic gpd
 where gps.game_code=gpd.game_code;

-- 游戏控制参数
create or replace view v_gp_control
as
select gps.game_code,
       limit_big_prize,
       limit_payment,
       limit_payment2,
       limit_cancel2,
       cancel_sec,
       saler_pay_limit,
       saler_cancel_limit,
       issue_close_alert_time
  from gp_static gps, gp_dynamic gpd
 where gps.game_code=gpd.game_code;

-- 期次列表中奖信息详情
create or replace view v_game_issue_prize_detail
as
select agency_code,
       agency_name,
       org_code area_code,
       org_name area_name,
       game_code,
       issue_number,
       prize_level,
       prize_name,
       is_hd_prize,
       winning_count,
       single_bet_reward
  from mis_agency_win_stat detail
  left join inf_agencys using(agency_code)
  left join inf_orgs using(org_code);

-- 监控用的期次列表
create or replace view v_mon_game_issue as
select game_code,
       issue_number,
       issue_status,
       (case
           when plan_start_time is null then
            null
           when real_start_time is null then
            plan_start_time
           else
            real_start_time
        end) as real_start_time,
       (case
           when plan_close_time is null then
            null
           when real_close_time is null then
            plan_close_time
           else
            real_close_time
        end) as real_close_time,
       (case
           when plan_reward_time is null then
            null
           when real_reward_time is null then
            plan_reward_time
           else
            real_reward_time
        end) as real_reward_time,
       issue_end_time,
       (select is_open_risk
          from gp_history
         where his_his_code = (select his_his_code
                                 from iss_current_param
                                where game_code = iss_game_issue.game_code
                                  and issue_number = iss_game_issue.issue_number)
           and game_code = iss_game_issue.game_code) as risk_status,
       (select risk_param
          from gp_history
         where his_his_code = (select his_his_code
                                 from iss_current_param
                                where game_code = iss_game_issue.game_code
                                  and issue_number = iss_game_issue.issue_number)
           and game_code = iss_game_issue.game_code) as risk_param,
       pool_start_amount,
       (select admin_realname
          from adm_info
         where admin_id = first_draw_user_id) first_draw_user,
       (select admin_realname
          from adm_info
         where admin_id = second_draw_user_id) second_draw_user,
       pool_close_amount,
       final_draw_number,
       issue_sale_amount,
       issue_sale_tickets,
       issue_cancel_amount,
       issue_cancel_tickets,
       winning_amount
  from iss_game_issue;

---------------------------------------------------------------------------
------------                  mis报表用               ---------------------
---------------------------------------------------------------------------

-- 多期票销售视图
create or replace view v_multi_sell
as
select applyflow_sell,
       saletime,
       terminal_code,
       teller_code,
       agency_code,
       game_code,
       issue_number,
       start_issue,
       end_issue,
       issue_count,
       ticket_amount,
       ticket_bet_count,
       salecommissionrate,
       commissionamount,
       bet_methold,
       bet_line,
       loyalty_code,
       result_code,
       sell_seq
  from his_sellticket
 where applyflow_sell in
       (select applyflow_sell from his_sellticket_multi_issue);

-- 销售站以及所属区域，含上级区域
create or replace view v_mis_agency as
select agency_code, ab.org_code agency_area_code,
       ab.org_name agency_area_name, aa.agency_type, aa.available_credit
  from tmp_agency aa, inf_orgs ab
 where aa.org_code = ab.org_code;

-- 本级区域和上级区域名称
create or replace view v_mis_area_farther as
select org_code area_code,
       org_name area_name,
       org_type area_type,
       super_org father_area,
       (select org_name from inf_orgs where org_code = tab.super_org) father_area_name
  from inf_orgs tab;

-- mis统计用区域，含99-直属统计区域
create or replace view v_mis_area as
select area_code,
       area_name,
       area_type,
       father_area,
       father_area_name
  from v_mis_area_farther;

-- 兑奖票显示买票期次和兑奖期次
create or replace view v_mis_pay_sell_issue as
select applyflow_pay,
       applyflow_sell,
       pay.game_code,
       pay.issue_number as pay_issue,
       sell.issue_number as sell_issue,
       pay.terminal_code,
       pay.teller_code,
       pay.agency_code,
       paytime,
       winningamounttax,
       winningamount,
       taxamount,
       paycommissionrate,
       pay.commissionamount,
       winningcount,
       hd_winning,
       hd_count,
       ld_winning,
       ld_count,
       pay.loyalty_code,
       is_big_prize,
       pay_seq
  from his_payticket pay
  join his_sellticket sell using(applyflow_sell);

-- 退票数据明细
create or replace view v_cancel_detail as
select sale.applyflow_sell,
       sale.saletime,
       sale.terminal_code,
       sale.teller_code,
       sale.agency_code,
       sale.game_code,
       sale.issue_number,
       sale.start_issue,
       sale.end_issue,
       sale.issue_count,
       sale.ticket_amount,
       sale.ticket_bet_count,
       sale.salecommissionrate,
       sale.commissionamount,
       sale.bet_methold,
       sale.bet_line,
       sale.loyalty_code,
       sale.result_code,
       sale.sell_seq,
       cancel.applyflow_cancel,
       cancel.canceltime,
       cancel.terminal_code as cancel_terminal,
       cancel.teller_code as cancel_teller,
       cancel.agency_code as cancel_agency,
       cancel.cancel_seq
  from his_sellticket sale, his_cancelticket cancel
 where sale.applyflow_sell = cancel.applyflow_sell;

---------------------------------------------------------------------------
------------                  新mis报表               ---------------------
---------------------------------------------------------------------------
-- 游戏销售及资金分配表 (佟琳说这个报表已经取掉了)
create or replace view mis_report_new_1 as
with all_comm as
 (select game_code, issue_number, sum(sale_comm + pay_comm) as agency_comm
    from (select game_code,
                 issue_number,
                 sum(pure_commission) as sale_comm,
                 0 as pay_comm
            from sub_sell
           group by game_code, issue_number
          union
          select game_code,
                 pay_issue,
                 0 as sale_comm,
                 sum(pay_commission) as pay_comm
            from sub_pay
           group by game_code, pay_issue)
   group by game_code, issue_number),
base as
 (select game_code,
         issue_number,
         sale_amount,
         (sale_amount - theory_win_amount - adj_fund) as sale_incoming,
         theory_win_amount,
         adj_fund,
         theory_win_amount + adj_fund as win_sum,
         agency_comm,
         0 as saler_comm,
         trunc(sale_amount * (case
                 when game_code = 6 then
                  0.05
                 when game_code = 7 then
                  0.07
                 else
                  0
               end)) as sp_comm
    from iss_game_policy_fund
    join all_comm
   using (game_code, issue_number))
select game_code,
       issue_number,
       sale_amount,
       sale_incoming,
       theory_win_amount,
       adj_fund,
       win_sum,
       agency_comm,
       saler_comm,
       sp_comm,
       (agency_comm + saler_comm + sp_comm) as comm_sum,
       trunc(sale_incoming * 0.1) as fee,
       sale_incoming - (agency_comm + saler_comm + sp_comm) -
       (trunc(sale_incoming * 0.1)) as gross_profit
  from base;

-- 《新电脑票2.0基本功能需求说明书》 3.6.1.1 中奖统计表
-- 中奖统计表
create or replace view mis_report_new_2 as
with base as
 (select game_code,
         issue_number,
         sum(sale_sum) as sale_amount,
         sum(hd_winning_sum) as hd_winning_sum,
         sum(hd_winning_amount) as hd_winning_amount,
         sum(ld_winning_sum) as ld_winning_sum,
         sum(ld_winning_amount) as ld_winning_amount,
         sum(winning_sum) as winning_sum
    from mis_report_3113 where area_code <> '00' group by game_code, issue_number)
select game_code,
       issue_number,
       sale_amount,
       hd_winning_sum,
       hd_winning_amount,
       ld_winning_sum,
       ld_winning_amount,
       winning_sum,
       trunc((case
               when sale_amount = 0 then
                0
               else
                (winning_sum / sale_amount) * 10000
             end)) as winning_rate
  from base;

-- 《新电脑票2.0基本功能需求说明书》 3.6.1.4 弃奖统计表
-- 弃奖统计表
create or replace view mis_report_new_5 as
select game_code,
       issue_number,
       sum(hd_purged_amount) as hd_purged_amount,
       sum(ld_purged_amount) as ld_purged_amount,
       sum(hd_purged_sum) as hd_purged_sum,
       sum(ld_purged_sum) as ld_purged_sum,
       sum(purged_amount) as purged_amount
  from mis_report_3112
 group by game_code, issue_number;


create or replace view mis_report_new_7 as
with all_comm as
 (select game_code, issue_number, sum(sale_comm + pay_comm) as agency_comm
    from (select game_code,
                 issue_number,
                 sum(pure_commission) as sale_comm,
                 0 as pay_comm
            from sub_sell
           group by game_code, issue_number
          union
          select game_code,
                 issue_number,
                 0 as sale_comm,
                 sum(pay_commission) as pay_comm
            from sub_pay
           group by game_code, issue_number)
   group by game_code, issue_number),
base as
 (select game_code,
         issue_number,
         sale_amount,
         (sale_amount - theory_win_amount - adj_fund) as sale_incoming
    from iss_game_policy_fund
    left join all_comm
   using (game_code, issue_number))
select game_code,
       issue_number,
       sale_amount,
       sale_incoming,
       10 as fee_rate,
       trunc(sale_incoming * 0.1) as fee_amount
  from base;

-- 兑奖统计表（按照奖等统计）分天
create or replace view mis_report_new_3_day as
with pay as
 (select game_code,
         pay_date,
         sum(hd_pay_amount) as hd_pay_amount,
         sum(hd_pay_bets) as hd_pay_bets,
         sum(ld_pay_amount) as ld_pay_amount,
         sum(ld_pay_bets) as ld_pay_bets,
         sum(pay_amount) as pay_amount
    from sub_pay
   group by game_code, pay_date),
sell as
 (select game_code, sale_date as pay_date, sum(pure_amount) as sale_amount
    from sub_sell
   group by game_code, sale_date)
select game_code,
       pay_date,
       sale_amount,
       nvl(hd_pay_amount, 0) as hd_pay_amount,
       nvl(hd_pay_bets, 0) as hd_pay_bets,
       nvl(ld_pay_amount, 0) as ld_pay_amount,
       nvl(ld_pay_bets, 0) as ld_pay_bets,
       nvl(pay_amount, 0) as pay_amount
  from sell
  left join pay
 using (game_code, pay_date);

-- 《新电脑票2.0基本功能需求说明书》 3.6.1.2 兑奖统计表（按奖等统计）
-- 兑奖统计表（按照奖等统计）分期次
create or replace view mis_report_new_3_issue as
with pay as
 (select game_code,
         pay_issue,
         sum(hd_pay_amount) as hd_pay_amount,
         sum(hd_pay_bets) as hd_pay_bets,
         sum(ld_pay_amount) as ld_pay_amount,
         sum(ld_pay_bets) as ld_pay_bets,
         sum(pay_amount) as pay_amount
    from sub_pay
   group by game_code, pay_issue),
sell as
 (select game_code, issue_number as pay_issue, sum(pure_amount) as sale_amount
    from sub_sell
   group by game_code, issue_number)
select game_code,
       pay_issue,
       nvl(sale_amount,0) as sale_amount,
       nvl(hd_pay_amount, 0) as hd_pay_amount,
       nvl(hd_pay_bets, 0) as hd_pay_bets,
       nvl(ld_pay_amount, 0) as ld_pay_amount,
       nvl(ld_pay_bets, 0) as ld_pay_bets,
       nvl(pay_amount, 0) as pay_amount
  from sell
  right join pay
 using (game_code, pay_issue);


-- 兑奖统计表（按照奖金统计）分天
create or replace view mis_report_new_4_day as
with pay_limit as
 (select game_code, limit_big_prize, limit_payment2 from gp_static),
pay_detail as
 (select game_code,
         trunc(paytime) as pay_date,
         winningamounttax,
         (case
           when winningamounttax >= pay_limit.limit_big_prize then
            winningamounttax
           else
            0
         end) as big_pay_amount,
         (case
           when winningamounttax >= pay_limit.limit_big_prize then
            winningcount
           else
            0
         end) as big_pay_count,
         (case
           when winningamounttax < pay_limit.limit_big_prize and
                winningamounttax >= pay_limit.limit_payment2 then
            winningamounttax
           else
            0
         end) as mid_pay_amount,
         (case
           when winningamounttax < pay_limit.limit_big_prize and
                winningamounttax >= pay_limit.limit_payment2 then
            winningcount
           else
            0
         end) as mid_pay_count,
         (case
           when winningamounttax < pay_limit.limit_payment2 then
            winningamounttax
           else
            0
         end) as small_pay_amount,
         (case
           when winningamounttax < pay_limit.limit_payment2 then
            winningcount
           else
            0
         end) as small_pay_count
    from his_payticket
    join pay_limit
   using (game_code)),
pay as
 (select game_code,
         pay_date,
         sum(big_pay_amount) as big_pay_amount,
         sum(big_pay_count) as big_pay_count,
         sum(mid_pay_amount) as mid_pay_amount,
         sum(mid_pay_count) as mid_pay_count,
         sum(small_pay_amount) as small_pay_amount,
         sum(small_pay_count) as small_pay_count,
         sum(winningamounttax) as pay_sum
    from pay_detail
   group by game_code, pay_date),
sell_notform as
 (select game_code, sale_date as pay_date, sum(pure_amount) as sale_amount
    from sub_sell
   group by game_code, sale_date),
sell as
 (select game_code, to_date(pay_date, 'yyyy-mm-dd') as pay_date, sale_amount
    from sell_notform)
select game_code,
       pay_date,
       sale_amount,
       nvl(big_pay_amount, 0) as big_pay_amount,
       nvl(big_pay_count, 0) as big_pay_count,
       nvl(mid_pay_amount, 0) as mid_pay_amount,
       nvl(mid_pay_count, 0) as mid_pay_count,
       nvl(small_pay_amount, 0) as small_pay_amount,
       nvl(small_pay_count, 0) as small_pay_count,
       nvl(pay_sum, 0) as pay_sum
  from sell
  left join pay
 using (game_code, pay_date);

-- 兑奖统计表（按照奖金统计）分期次
create or replace view mis_report_new_4_issue as
with pay_limit as
 (select game_code, limit_big_prize, limit_payment2 from gp_static),
pay_detail as
 (select game_code,
         issue_number as pay_issue,
         winningamounttax,
         (case
           when winningamounttax >= pay_limit.limit_big_prize then
            winningamounttax
           else
            0
         end) as big_pay_amount,
         (case
           when winningamounttax >= pay_limit.limit_big_prize then
            winningcount
           else
            0
         end) as big_pay_count,
         (case
           when winningamounttax < pay_limit.limit_big_prize and
                winningamounttax >= pay_limit.limit_payment2 then
            winningamounttax
           else
            0
         end) as mid_pay_amount,
         (case
           when winningamounttax < pay_limit.limit_big_prize and
                winningamounttax >= pay_limit.limit_payment2 then
            winningcount
           else
            0
         end) as mid_pay_count,
         (case
           when winningamounttax < pay_limit.limit_payment2 then
            winningamounttax
           else
            0
         end) as small_pay_amount,
         (case
           when winningamounttax < pay_limit.limit_payment2 then
            winningcount
           else
            0
         end) as small_pay_count
    from his_payticket
    join pay_limit
   using (game_code)),
pay as
 (select game_code,
         pay_issue,
         sum(big_pay_amount) as big_pay_amount,
         sum(big_pay_count) as big_pay_count,
         sum(mid_pay_amount) as mid_pay_amount,
         sum(mid_pay_count) as mid_pay_count,
         sum(small_pay_amount) as small_pay_amount,
         sum(small_pay_count) as small_pay_count,
         sum(winningamounttax) as pay_sum
    from pay_detail
   group by game_code, pay_issue),
sell as
 (select game_code,
         issue_number as pay_issue,
         sum(pure_amount) as sale_amount
    from sub_sell
   group by game_code, issue_number)
select game_code,
       pay_issue,
       sale_amount,
       nvl(big_pay_amount, 0) as big_pay_amount,
       nvl(big_pay_count, 0) as big_pay_count,
       nvl(mid_pay_amount, 0) as mid_pay_amount,
       nvl(mid_pay_count, 0) as mid_pay_count,
       nvl(small_pay_amount, 0) as small_pay_amount,
       nvl(small_pay_count, 0) as small_pay_count,
       nvl(pay_sum, 0) as pay_sum
  from sell
  left join pay
 using (game_code, pay_issue);

 
-- 《新电脑票2.0基本功能需求说明书》 3.6.1.3 兑奖统计表（按奖金统计）
create or replace view mis_report_new_9_issue as
with pay as
 (select game_code,
         pay_issue,
         sum(big_amount) as big_amount,
         sum(big_count) as big_count,
         sum(sml_amount) as sml_amount,
         sum(sml_count) as sml_count
    from (select game_code,
                 pay_issue,
                 sum(pay_amount) as big_amount,
                 sum(pay_tickets) as big_count,
                 0 as sml_amount,
                 0 as sml_count
            from sub_pay
           where is_big_one = 1
           group by game_code, pay_issue
          union all
          select game_code,
                 pay_issue,
                 0 as big_amount,
                 0 as big_count,
                 sum(pay_amount) as sml_amount,
                 sum(pay_tickets) as sml_count
            from sub_pay
           where is_big_one = 0
           group by game_code, pay_issue)
   group by game_code, pay_issue
  ),
sell as
 (select game_code,
         issue_number as pay_issue,
         sum(pure_amount) as sale_amount
    from sub_sell
   group by game_code, issue_number)
select game_code,
       pay_issue,
       nvl(sale_amount,0) as sale_amount,
       nvl(big_amount, 0) as big_amount,
       nvl(big_count, 0) as big_count,
       nvl(sml_amount, 0) as sml_amount,
       nvl(sml_count, 0) as sml_count,
       (nvl(big_amount, 0) + nvl(sml_amount, 0)) as pay_amount
  from sell
  right join pay
 using (game_code, pay_issue);

create or replace view mis_report_new_9_day as
with pay as
 (select game_code,
         pay_date,
         sum(big_amount) as big_amount,
         sum(big_count) as big_count,
         sum(sml_amount) as sml_amount,
         sum(sml_count) as sml_count
    from (select game_code,
                 pay_date,
                 sum(pay_amount) as big_amount,
                 sum(pay_tickets) as big_count,
                 0 as sml_amount,
                 0 as sml_count
            from sub_pay
           where is_big_one = 1
           group by game_code, pay_date
          union all
          select game_code,
                 pay_date,
                 0 as big_amount,
                 0 as big_count,
                 sum(pay_amount) as sml_amount,
                 sum(pay_tickets) as sml_count
            from sub_pay
           where is_big_one = 0
           group by game_code, pay_date)
   group by game_code, pay_date
  ),
sell as
 (select game_code,
         sale_date as pay_date,
         sum(pure_amount) as sale_amount
    from sub_sell
   group by game_code, sale_date)
select game_code,
       pay_date,
       sale_amount,
       nvl(big_amount, 0) as big_amount,
       nvl(big_count, 0) as big_count,
       nvl(sml_amount, 0) as sml_amount,
       nvl(sml_count, 0) as sml_count,
       (nvl(big_amount, 0) + nvl(sml_amount, 0)) as pay_amount
  from sell
  left join pay
 using (game_code, pay_date);


create or replace view mis_report_new_6 as
with pool_his as
 (select game_code,
         nvl((select issue_number
               from iss_game_issue
              where game_code = tab.game_code
                and issue_seq = (0 - tab.issue_number)),
             tab.issue_number) issue_number,
         his_code,
         pool_code,
         change_amount,
         pool_amount_before,
         pool_amount_after,
         adj_time,
         pool_adj_type,
         adj_reason,
         pool_flow
    from iss_game_pool_his tab
   where issue_number < 0
  union all
  select game_code,
         issue_number,
         his_code,
         pool_code,
         change_amount,
         pool_amount_before,
         pool_amount_after,
         adj_time,
         pool_adj_type,
         adj_reason,
         pool_flow
    from iss_game_pool_his
   where issue_number > 0),
adj_his as
 (select game_code,
         nvl((select issue_number
               from iss_game_issue
              where game_code = tab.game_code
                and issue_seq = (0 - tab.issue_number)),
             tab.issue_number) issue_number,
         his_code,
         adj_change_type,
         adj_amount,
         adj_amount_before,
         adj_amount_after,
         adj_time,
         adj_reason,
         adj_flow
    from adj_game_his tab
   where issue_number < 0
  union all
  select game_code,
         issue_number,
         his_code,
         adj_change_type,
         adj_amount,
         adj_amount_before,
         adj_amount_after,
         adj_time,
         adj_reason,
         adj_flow
    from adj_game_his
   where issue_number > 0),
theory_fund as
 (select game_code, issue_number, THEORY_WIN_AMOUNT, ADJ_FUND
    from ISS_GAME_POLICY_FUND),
adj_before as
 (select game_code, issue_number, adj_amount_after
    from adj_his
   where (game_code, issue_number, his_code) in
         (select game_code, issue_number, max(his_code)
            from adj_his
           group by game_code, issue_number)),
adj_after as
 (select game_code, issue_number, adj_amount_before
    from adj_his
   where (game_code, issue_number, his_code) in
         (select game_code, issue_number, min(his_code)
            from adj_his
           group by game_code, issue_number)),
adj_other as
 (select game_code,
         issue_number,
         sum(pool_amount) as pool_amount,
         sum(aband_amount) as aband_amount
    from (select game_code,
                 issue_number,
                 adj_amount   as pool_amount,
                 0            as aband_amount
            from adj_his
           where adj_change_type in (3,4)
          union all
          select game_code,
                 issue_number,
                 0            as pool_amount,
                 adj_amount   as aband_amount
            from adj_his tab
           where adj_change_type = 2)
   group by game_code, issue_number),
adj_base as
 (select game_code,
         issue_number,
         adj_amount_before as adj_before,
         nvl(aband_amount, 0) as ADJ_ABANDON,
         0 - nvl(pool_amount, 0) as ADJ_POOL,
         0 as adj_spec,
         adj_amount_after as adj_after
    from adj_before
    join adj_after
   using (game_code, issue_number)
    left join adj_other
   using (game_code, issue_number)),
pool_before as
 (select game_code, issue_number, pool_amount_after
    from pool_his
   where (game_code, issue_number, his_code) in
         (select game_code, issue_number, max(his_code)
            from pool_his
           where pool_adj_type <> 3
           group by game_code, issue_number)),
pool_after as
 (select game_code, issue_number, pool_amount_before
    from pool_his
   where (game_code, issue_number, his_code) in
         (select game_code, issue_number, min(his_code)
            from pool_his
           where pool_adj_type <> 3
           group by game_code, issue_number)),
hd_reward as
 (select game_code,
         issue_number,
         sum(PRIZE_COUNT * SINGLE_BET_REWARD) as reward
    from ISS_PRIZE
   where is_hd_prize = 1
   group by game_code, issue_number),
pool_base as
 (select game_code,
         issue_number,
         pool_amount_before as POOL_BEFORE,
         nvl(reward, 0) as POOL_HD_REWARD,
         pool_amount_after as POOL_AFTER
    from pool_before
    join pool_after
   using (game_code, issue_number)
   right join hd_reward
   using (game_code, issue_number))
select GAME_CODE,
       ISSUE_NUMBER,
       ADJ_BEFORE,
       ADJ_FUND          as ADJ_ISSUE,
       ADJ_ABANDON,
       ADJ_POOL,
       ADJ_SPEC,
       ADJ_AFTER,
       POOL_BEFORE,
       THEORY_WIN_AMOUNT as POOL_ISSUE,
       ADJ_POOL          as POOL_ADJ,
       POOL_HD_REWARD,
       POOL_AFTER
  from theory_fund
  left join pool_base
 using (game_code, issue_number)
  left join adj_base
 using (game_code, issue_number)
 where issue_number > 0;
