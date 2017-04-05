create or replace procedure p_mis_dss_05_gen_winning
  (p_settle_id    number,
   p_is_maintance NUMBER default 0)
is
  start_seq number(10);
  end_seq number(10);
  v_set_day date;

begin
  select win_seq, settle_date into end_seq, v_set_day from his_day_settle where settle_id=p_settle_id;
  select max(win_seq) into start_seq from his_day_settle where settle_id<p_settle_id;

  -- 考虑到多期票的问题，
  -- 1、获取今天开奖的期次列表
  -- 2、根据开奖期次获知对应的销售票（his_selltickt中的end_issue）,获知这些票的 请求流水
  -- 3、根据请求流水，将中奖票入库。

  insert into tmp_src_win
    (applyflow_sell,                  winning_time,
     terminal_code,                   teller_code,                      agency_code,
     game_code,                       issue_number,                     is_big_prize,
     ticket_amount,
     win_amount_without_tax,          win_amount,           tax_amount,            win_bets,
     hd_win_amount_without_tax,       hd_win_amount,        hd_tax_amount,         hd_win_bets,
     ld_win_amount_without_tax,       ld_win_amount,        ld_tax_amount,         ld_win_bets)
  with
    -- 当天发布的中奖期次
    winning_issue as (
      select game_code, issue_number from iss_game_issue where issue_end_time >= v_set_day and issue_end_time < v_set_day + 1),
    -- 中奖期次对应的销售票
    sell as (
      select applyflow_sell, terminal_code, teller_code, agency_code, issue_number, game_code, ticket_amount
        from his_sellticket
       where (game_code, end_issue) in (select game_code, issue_number from winning_issue)),
    -- 销售票对应的中奖明细
    win as (
      select applyflow_sell,            max(winnning_time) as winnning_time,
             sum(winningamounttax)                                            as win_amount,                                -- 税前奖金
             sum(winningamount)                                               as win_amount_without_tax,                    -- 税后奖金
             sum(taxamount)                                                   as tax_amount,                                -- 缴税额
             sum(prize_count)                                                 as win_bets,                                  -- 中奖注数
             sum(case when is_hd_prize = 1 then winningamounttax else 0 end)  as hd_win_amount,                             -- 税前奖金（高等奖）
             sum(case when is_hd_prize = 1 then winningamount    else 0 end)  as hd_win_amount_without_tax,                 -- 税后奖金（高等奖）
             sum(case when is_hd_prize = 1 then taxamount        else 0 end)  as hd_tax_amount,                             -- 缴税额  （高等奖）
             sum(case when is_hd_prize = 1 then prize_count      else 0 end)  as hd_win_bets,                               -- 中奖注数（高等奖）
             sum(case when is_hd_prize = 0 then winningamounttax else 0 end)  as ld_win_amount,                             -- 税前奖金（低等奖）
             sum(case when is_hd_prize = 0 then winningamount    else 0 end)  as ld_win_amount_without_tax,                 -- 税后奖金（低等奖）
             sum(case when is_hd_prize = 0 then taxamount        else 0 end)  as ld_tax_amount,                             -- 缴税额  （低等奖）
             sum(case when is_hd_prize = 0 then prize_count      else 0 end)  as ld_win_bets                                -- 中奖注数（低等奖）
        from his_win_ticket_detail
       where applyflow_sell in (select applyflow_sell from sell)
       group by applyflow_sell)
  select applyflow_sell,     win.winnning_time,
         terminal_code,      teller_code,           agency_code,
         game_code,          sell.issue_number,
         (case
              when win_amount_without_tax >= limit_big_prize then 1
              when win_amount_without_tax < limit_big_prize then 0
              else null
          end),
         sell.ticket_amount,
         win.win_amount_without_tax,             win.win_amount,             win.tax_amount,            win.win_bets,
         win.hd_win_amount_without_tax,          win.hd_win_amount,          win.hd_tax_amount,         win.hd_win_bets,
         win.ld_win_amount_without_tax,          win.ld_win_amount,          win.ld_tax_amount,         win.ld_win_bets
    from win
    join sell using(applyflow_sell)
    join gp_static using(game_code);
  
  
  if p_is_maintance <> 0 then
    delete from his_win_ticket where winning_time = v_set_day;
  end if;
  
  insert into his_win_ticket select * from tmp_src_win;

  commit;

end;

