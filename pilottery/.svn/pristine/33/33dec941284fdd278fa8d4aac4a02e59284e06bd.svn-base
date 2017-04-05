create or replace procedure p_mis_dss_10_gen_abandon(
  p_settle_id    in number,
  p_is_maintance in number default 0
) is
  v_date date;
begin
   select settle_date
     into v_date
     from his_day_settle
    where settle_id = p_settle_id;

   insert into tmp_src_abandon
      (applyflow_sell,
       abandon_time,
       winning_time,
       terminal_code,
       teller_code,
       agency_code,
       game_code,
       issue_number,
       ticket_amount,
       is_big_prize,
       win_amount,
       win_amount_without_tax, -- 中奖金额（税后）
       tax_amount,
       win_bets,
       hd_win_amount,
       hd_win_amount_without_tax, -- 高等奖中奖金额（税后）
       hd_tax_amount,
       hd_win_bets,
       ld_win_amount,
       ld_win_amount_without_tax, -- 低等奖中奖金额（税后）
       ld_tax_amount,
       ld_win_bets)
      with abandon_issue as
       ( /* 凌晨弃奖游戏期次（昨天是兑奖的最后一天，今天形成弃奖） */
        select game_code, issue_number
          from iss_game_issue
         where pay_end_day = to_number(to_char(v_date, 'yyyymmdd'))),
      all_abandon_flow as
       ( /* 所有满足弃奖期次的票号 */
        select applyflow_sell
          from his_sellticket
         where (game_code, end_issue) in
               (select game_code, issue_number from abandon_issue)
       )
      select applyflow_sell,
             v_date + 1,
             winning_time,
             terminal_code,
             teller_code,
             agency_code,
             game_code,
             issue_number,
             ticket_amount,
             is_big_prize,
             win_amount,
             win_amount_without_tax, -- 中奖金额（税后）
             tax_amount,
             win_bets,
             hd_win_amount,
             hd_win_amount_without_tax, -- 高等奖中奖金额（税后）
             hd_tax_amount,
             hd_win_bets,
             ld_win_amount,
             ld_win_amount_without_tax, -- 低等奖中奖金额（税后）
             ld_tax_amount,
             ld_win_bets
        from all_abandon_flow
        join his_win_ticket
       using (applyflow_sell)
	    where applyflow_sell not in (select applyflow_sell from his_payticket where applyflow_sell in (select applyflow_sell from his_sellticket where (game_code, issue_number) in (select game_code, issue_number from abandon_issue)));

   commit;

   -- 弃奖主表
   delete his_abandon_ticket where abandon_time = v_date + 1;
   insert into his_abandon_ticket select * from tmp_src_abandon;
   commit;

   -- 弃奖明细表
   delete his_abandon_ticket_detail where abandon_time = v_date + 1;
   insert into his_abandon_ticket_detail
      (applyflow_sell,
       abandon_time,
       winning_time,
       game_code,
       issue_number,
       prize_level,
       prize_count,
       is_hd_prize,
       winningamounttax,
       winningamount,
       taxamount)
      select applyflow_sell,
             v_date + 1,
             winnning_time,
             game_code,
             issue_number,
             prize_level,
             prize_count,
             is_hd_prize,
             winningamounttax,
             winningamount,
             taxamount
        from his_win_ticket_detail
       where applyflow_sell in (select applyflow_sell from tmp_src_abandon);
   commit;

   if p_is_maintance = 0 then
      -- 弃奖资金进入调节基金
      -- 想法：
      -- 1、计算出弃奖资金
      -- 2、在调节基金中新增一条记录
      -- 3、修改当前的调节基金余额
      -- taishan用户下新建sp，入口参数：
      -- 游戏、期次、弃奖金额
      for v_game_code in 1 .. 20 loop
         for detail in (select issue_number, sum(win_amount) as amount
                          from tmp_src_abandon
                         where game_code = v_game_code
                         group by issue_number
                         order by issue_number) loop
            p_mis_abandon_out(v_game_code,
                              detail.issue_number,
                              detail.amount);
         end loop;
      end loop;
      commit;
   end if;

   -- 重新写临时表内容。这是因为，弃奖日期aband_day和最后兑奖截止日pay_end_day，之间有一天的差距。
   -- 在计算弃奖时，会使用【最后兑奖截止日pay_end_day】来进行。因为当前mis的计算在凌晨进行，所以计算的结果，就是当天产生的弃奖，也就是【弃奖日期aband_day】为计算日。
   -- 这与mis报表中所体现的日期标准有差距。mis报表中（销售、兑奖）所体现的是前一天发生的行为。
   delete tmp_src_abandon;
   insert into tmp_src_abandon
      (applyflow_sell,
       abandon_time,
       winning_time,
       terminal_code,
       teller_code,
       agency_code,
       game_code,
       issue_number,
       ticket_amount,
       is_big_prize,
       win_amount,
       win_amount_without_tax, -- 中奖金额（税后）
       tax_amount,
       win_bets,
       hd_win_amount,
       hd_win_amount_without_tax, -- 高等奖中奖金额（税后）
       hd_tax_amount,
       hd_win_bets,
       ld_win_amount,
       ld_win_amount_without_tax, -- 低等奖中奖金额（税后）
       ld_tax_amount,
       ld_win_bets)
      select applyflow_sell,
             abandon_time,
             winning_time,
             terminal_code,
             teller_code,
             agency_code,
             game_code,
             issue_number,
             ticket_amount,
             is_big_prize,
             win_amount,
             win_amount_without_tax, -- 中奖金额（税后）
             tax_amount,
             win_bets,
             hd_win_amount,
             hd_win_amount_without_tax, -- 高等奖中奖金额（税后）
             hd_tax_amount,
             hd_win_bets,
             ld_win_amount,
             ld_win_amount_without_tax, -- 低等奖中奖金额（税后）
             ld_tax_amount,
             ld_win_bets
        from his_abandon_ticket
       where abandon_time = v_date;

   commit;
end;