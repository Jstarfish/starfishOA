create or replace procedure p_mis_dss_50_gen_rpt_3113(p_settle_id in number) is
   v_rpt_day date;
begin
   select settle_date
     into v_rpt_day
     from his_day_settle
    where settle_id = p_settle_id;

   insert into tmp_rst_3113
      (game_code, issue_number, area_code, sale_sum, hd_winning_sum, hd_winning_amount, ld_winning_sum, ld_winning_amount, winning_sum)
      with game_issue as
       (
        /* 确定指定日期的中奖游戏期次 */
        select game_code, issue_number
          from tmp_win_issue),
      win_agency as
       ( /* 期次内的中奖统计，按照销售站统计 */
        select game_code,
               issue_number,
               sale_agency agency_code,
               sum(winningamounttax) as win_amount,
               sum(case when is_hd_prize = 1 then winningamounttax else 0 end) as hd_amount,
               sum(case when is_hd_prize = 1 then prize_count      else 0 end) as hd_bets,
               sum(case when is_hd_prize = 0 then winningamounttax else 0 end) as ld_amount,
               sum(case when is_hd_prize = 0 then prize_count      else 0 end) as ld_bets
          from his_win_ticket_detail
         where (game_code, issue_number) in (select game_code, issue_number
                                               from game_issue)
         group by game_code, issue_number, sale_agency),
      win as
      ( /* 期次内中奖，按照部门统计 */
       select game_code, issue_number, org_code sale_area, sum(win_amount) win_amount, sum(hd_amount) as hd_amount, sum(hd_bets) as hd_bets, sum(ld_amount) as ld_amount, sum(ld_bets) as ld_bets
         from win_agency
         join inf_agencys using (agency_code)
        group by game_code, issue_number, org_code),
      sell as
       ( /* 期次内的期销售额统计（多期票被拆分） */
        select game_code, issue_number, sale_area, sum(pure_amount_single_issue) as sale_amount
          from sub_sell
         where (game_code, issue_number) in (select game_code, issue_number from game_issue)
         group by game_code, issue_number, sale_area)
      select game_code,
             issue_number,
             sale_area,
             nvl(sell.sale_amount,0) sale_amount,
             nvl(win.hd_amount,0) hd_amount,
             nvl(win.hd_bets,0) hd_bets,
             nvl(win.ld_amount,0) ld_amount,
             nvl(win.ld_bets,0) ld_bets,
             nvl(win.win_amount,0) win_amount
        from sell
        left join win
       using (game_code, issue_number, sale_area);
   commit;

   -- 计算区域汇总数据
      insert into tmp_rst_3113
         (game_code,
          issue_number,
          area_code,
          sale_sum,
          hd_winning_sum,
          hd_winning_amount,
          ld_winning_sum,
          ld_winning_amount,
          winning_sum)
         select game_code,
                issue_number,
                area.father_area       as area,
                sum(sale_sum)          as sale_sum,
                sum(hd_winning_sum)    as hd_winning_sum,
                sum(hd_winning_amount) as hd_winning_amount,
                sum(ld_winning_sum)    as ld_winning_sum,
                sum(ld_winning_amount) as ld_winning_amount,
                sum(winning_sum)       as winning_sum
           from tmp_rst_3113 tab, v_mis_area area
          where tab.area_code = area.area_code
            and area.area_type = 1
          group by game_code, issue_number, area.father_area;
   commit;

   -- 更新区域名称
   update tmp_rst_3113
      set area_name =
          (select area_name
             from v_mis_area
            where area_code = tmp_rst_3113.area_code),
          winning_rate = winning_sum / (case when sale_sum=0 then 1 else sale_sum end ) * 10000;
   commit;
end;