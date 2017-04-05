create or replace procedure p_mis_dss_40_gen_fact(p_settle_id in number) is
   v_rpt_day date;
begin
   -- 2015/3/3 his_payticket 兑奖表中，入库的issue_number字段，是兑奖期，不再是买票期
   select settle_date
     into v_rpt_day
     from his_day_settle
    where settle_id = p_settle_id;
   /*****************************************************/
   /*******************  销售主题统计  ******************/
   -- 退票不能跨天出现，因此这里不考虑跨天出现退票的情况
   dbms_output.put_line('calc sell ....');
   delete from sub_sell
    where sale_date = to_char(v_rpt_day, 'yyyy-mm-dd');
   insert into sub_sell
      (sale_date,
       sale_week,
       sale_month,
       sale_quarter,
       sale_year,
       game_code,
       issue_number,
       sale_agency,
       sale_area,
       sale_teller,
       sale_terminal,
       bet_methold,
       loyalty_code,
       result_code,
       sale_amount,
       sale_bets,
       sale_commission,
       sale_tickets,
       sale_lines,
       pure_amount,
       pure_bets,
       pure_commission,
       pure_tickets,
       pure_lines,
       sale_amount_single_issue,
       sale_bets_single_issue,
       sale_commision_single_issue,
       pure_amount_single_issue,
       pure_bets_single_issue,
       pure_commision_single_issue)
      with
      /* 针对不区分多期，统计销售情况 */
      normal as
       (select sell.terminal_code,
               sell.teller_code,
               sell.agency_code,
               sell.game_code,
               sell.issue_number,
               sell.bet_methold,
               sell.loyalty_code,
               sell.result_code,
               -- 单期票
               nvl(sum(sell.ticket_amount), 0)     as sale_amount,
               nvl(sum(sell.ticket_bet_count), 0)  as sale_bets,
               nvl(sum(sell.commissionamount), 0)  as sale_commission,
               count(applyflow_sell)               as sale_tickets,
               nvl(sum(sell.bet_line), 0)          as sale_lines,
               -- 净销售额
               sum(case when can.applyflow_cancel is null then sell.ticket_amount    else 0 end) as pure_amount,
               sum(case when can.applyflow_cancel is null then sell.ticket_bet_count else 0 end) as pure_bets,
               sum(case when can.applyflow_cancel is null then sell.commissionamount else 0 end) as pure_commission,
               sum(case when can.applyflow_cancel is null then 1                     else 0 end) as pure_tickets,
               sum(case when can.applyflow_cancel is null then sell.bet_line         else 0 end) as pure_lines,
               -- 多期票
               0                       as sale_amount_single_issue,
               0                       as sale_bets_single_issue,
               0                       as sale_commision_single_issue,
               0                       as pure_amount_single_issue,
               0                       as pure_bets_single_issue,
               0                       as pure_commision_single_issue
          from tmp_src_sell sell
          left join tmp_src_cancel can
         using (applyflow_sell)
         group by sell.terminal_code,
                  sell.teller_code,
                  sell.agency_code,
                  sell.game_code,
                  sell.issue_number,
                  sell.salecommissionrate,
                  sell.bet_methold,
                  sell.loyalty_code,
                  sell.result_code),
      /* 针对多期统计每一期销售 */
      multi as
       (select sell.terminal_code,
               sell.teller_code,
               sell.agency_code,
               game_code,
               issue_number,
               sell.bet_methold,
               sell.loyalty_code,
               sell.result_code,
               -- 单期票
               0 as sale_amount,
               0 as sale_bets,
               0 as sale_commission,
               0 as sale_tickets,
               0 as sale_lines,
               0 as pure_amount,
               0 as pure_bets,
               0 as pure_commission,
               0 as pure_tickets,
               0 as pure_lines,
               -- 多期票
               nvl(sum(sell.ticket_amount), 0)           as sale_amount_single_issue,
               nvl(sum(sell.ticket_bet_count), 0)        as sale_bets_single_issue,
               nvl(sum(sell.commissionamount), 0)        as sale_commision_single_issue,
               sum(case when can.applyflow_cancel is null then sell.ticket_amount         else 0 end)  as pure_amount_single_issue,
               sum(case when can.applyflow_cancel is null then sell.ticket_bet_count      else 0 end)  as pure_bets_single_issue,
               sum(case when can.applyflow_cancel is null then sell.commissionamount      else 0 end)  as pure_commision_single_issue
          from tmp_multi_sell sell
          left join tmp_multi_cancel can
         using (applyflow_sell, game_code, issue_number)
         group by sell.terminal_code,
                  sell.teller_code,
                  sell.agency_code,
                  game_code,
                  issue_number,
                  sell.bet_methold,
                  sell.loyalty_code,
                  sell.result_code),
      /* 普通期统计结果与多期票统计结果合并 */
      total_data as
       (select game_code,
               issue_number,
               agency_code,
               area.agency_area_code as area_code,
               teller_code,
               terminal_code,
               bet_methold,
               loyalty_code,
               result_code,
               sum(sale_amount) as sale_amount,
               sum(sale_bets) as sale_bets,
               sum(sale_commission) as sale_commission,
               sum(sale_tickets) as sale_tickets,
               sum(sale_lines) as sale_lines,
               sum(pure_amount) as pure_amount,
               sum(pure_bets) as pure_bets,
               sum(pure_commission) as pure_commission,
               sum(pure_tickets) as pure_tickets,
               sum(pure_lines) as pure_lines,
               sum(sale_amount_single_issue) as sale_amount_single_issue,
               sum(sale_bets_single_issue) as sale_bets_single_issue,
               sum(sale_commision_single_issue) as sale_commision_single_issue,
               sum(pure_amount_single_issue) as pure_amount_single_issue,
               sum(pure_bets_single_issue) as pure_bets_single_issue,
               sum(pure_commision_single_issue) as pure_commision_single_issue
          from (select *
                  from normal
                union all
                select *
                  from multi)
          join v_mis_agency area
         using (agency_code)
         group by game_code, issue_number, agency_code, area.agency_area_code, teller_code, terminal_code, bet_methold, loyalty_code, result_code)
      select to_char(v_rpt_day, 'yyyy-mm-dd') as sale_date,
             to_char(v_rpt_day, 'yyyy-ww') as sale_week,
             to_char(v_rpt_day, 'yyyy-mm') as sale_month,
             to_char(v_rpt_day, 'yyyy-q') as sale_quarter,
             to_char(v_rpt_day, 'yyyy') as sale_year,
             game_code,
             issue_number,
             agency_code,
             area_code,
             teller_code,
             terminal_code,
             bet_methold,
             loyalty_code,
             result_code,
             nvl(sale_amount, 0),
             nvl(sale_bets, 0),
             nvl(sale_commission, 0),
             nvl(sale_tickets, 0),
             nvl(sale_lines, 0),
             nvl(pure_amount, 0),
             nvl(pure_bets, 0),
             nvl(pure_commission, 0),
             nvl(pure_tickets, 0),
             nvl(pure_lines, 0),
             nvl(sale_amount_single_issue, 0),
             nvl(sale_bets_single_issue, 0),
             nvl(sale_commision_single_issue, 0),
             nvl(pure_amount_single_issue, 0),
             nvl(pure_bets_single_issue, 0),
             nvl(pure_commision_single_issue, 0)
        from total_data;
  dbms_output.put_line('p_mis_dss_40_gen_fact->sub_sell:' || sql%rowcount);
  commit;

--modify by kwx 2016-5-12 将"issue_number as pay_issue"修改为"pay_issue_number as pay_issue"
   /*****************************************************/
   /******************* 兑奖主题统计 ******************/
   dbms_output.put_line('calc pay ....');
   delete from sub_pay
    where pay_date = to_char(v_rpt_day, 'yyyy-mm-dd');
   insert into sub_pay
      (pay_date,
       pay_week,
       pay_month,
       pay_quarter,
       pay_year,
       game_code,
       issue_number,
       pay_issue,
       pay_agency,
       pay_area,
       pay_teller,
       pay_terminal,
       loyalty_code,
       is_gui_pay,
       is_big_one,
       pay_amount,
       pay_amount_without_tax,
       tax_amount,
       pay_bets,
       hd_pay_amount,
       hd_pay_amount_without_tax,
       hd_tax_amount,
       hd_pay_bets,
       ld_pay_amount,
       ld_pay_amount_without_tax,
       ld_tax_amount,
       ld_pay_bets,
       pay_commission,
       pay_tickets)
      with
      win_detail as
      (select applyflow_sell,
              sum(hd_win_amount) as hd_win_amount,
              sum(hd_win_amount_without_tax) as hd_win_amount_without_tax,
              sum(hd_tax_amount) as hd_tax_amount,
              sum(hd_win_bets) as hd_win_bets,
              sum(ld_win_amount) as ld_win_amount,
              sum(ld_win_amount_without_tax) as ld_win_amount_without_tax,
              sum(ld_tax_amount) as ld_tax_amount,
              sum(ld_win_bets) as ld_win_bets
         from his_win_ticket
        where applyflow_sell in (select applyflow_sell from tmp_src_pay)
        group by applyflow_sell),
      pay_detail as
      (select applyflow_pay,
              applyflow_sell,
              game_code,
              (select issue_number from his_sellticket where applyflow_sell=main.applyflow_sell) as issue_number,
              org_code,
              terminal_code,
              teller_code,
              agency_code,
              paytime,
              winningamounttax,
              winningamount,
              taxamount,
              paycommissionrate,
              commissionamount,
              winningcount,
              hd_winning,
              hd_count,
              ld_winning,
              ld_count,
              loyalty_code,
              is_big_prize,
              pay_issue_number as pay_issue
         from tmp_src_pay main
      ),
      total_data as
       (select main.game_code,
               main.issue_number,
               main.pay_issue,
               main.agency_code,
               main.org_code,
               main.teller_code,
               main.terminal_code,
               main.loyalty_code,
               nvl2(gui.gui_pay_flow, 1, 0) as is_gui_pay,
               main.is_big_prize as is_big_one,
               sum(winningamounttax) as pay_amount,
               sum(winningamount) as pay_amount_without_tax,
               sum(taxamount) as tax_amount,
               sum(winningcount) as pay_bets,
               sum(detail.hd_win_amount) as hd_pay_amount,
               sum(detail.hd_win_amount_without_tax) as hd_pay_amount_without_tax,
               sum(detail.hd_tax_amount) as hd_tax_amount,
               sum(detail.hd_win_bets) as hd_pay_bets,
               sum(detail.ld_win_amount) as ld_pay_amount,
               sum(detail.ld_win_amount_without_tax) as ld_pay_amount_without_tax,
               sum(detail.ld_tax_amount) as ld_tax_amount,
               sum(detail.ld_win_bets) as ld_pay_bets,
               sum(main.commissionamount) as pay_commission,
               count(main.applyflow_sell) as pay_tickets
          from pay_detail main
          join win_detail detail
            on (main.applyflow_sell = detail.applyflow_sell)
          left join sale_gamepayinfo gui
            on (main.applyflow_sell = gui.applyflow_sale and gui.is_success = 1)
         group by main.game_code,
                  main.issue_number,
                  main.pay_issue,
                  main.terminal_code,
                  main.teller_code,
                  main.agency_code,
                  main.org_code,
                  main.loyalty_code,
                  nvl2(gui.gui_pay_flow, 1, 0),
                  main.is_big_prize)
      select to_char(v_rpt_day, 'yyyy-mm-dd') as pay_date,
             to_char(v_rpt_day, 'yyyy-ww') as pay_week,
             to_char(v_rpt_day, 'yyyy-mm') as pay_month,
             to_char(v_rpt_day, 'yyyy-q') as pay_quarter,
             to_char(v_rpt_day, 'yyyy') as pay_year,
             game_code,
             issue_number,
             pay_issue,
             agency_code,
             org_code,
             teller_code,
             terminal_code,
             loyalty_code,
             is_gui_pay,
             is_big_one,
             nvl(pay_amount, 0),
             nvl(pay_amount_without_tax, 0),
             nvl(tax_amount, 0),
             nvl(pay_bets, 0),
             nvl(hd_pay_amount, 0),
             nvl(hd_pay_amount_without_tax, 0),
             nvl(hd_tax_amount, 0),
             nvl(hd_pay_bets, 0),
             nvl(ld_pay_amount, 0),
             nvl(ld_pay_amount_without_tax, 0),
             nvl(ld_tax_amount, 0),
             nvl(ld_pay_bets, 0),
             nvl(pay_commission, 0),
             nvl(pay_tickets, 0)
        from total_data;
   dbms_output.put_line('p_mis_dss_40_gen_fact->sub_pay:' || sql%rowcount);
   commit;

   /*****************************************************/
   /******************* 退票主题统计 ******************/
   dbms_output.put_line('calc cancel ....');
   delete from sub_cancel
    where cancel_date = to_char(v_rpt_day, 'yyyy-mm-dd');
   insert into sub_cancel
      (cancel_date,
       cancel_week,
       cancel_month,
       cancel_quarter,
       cancel_year,
       game_code,
       issue_number,
       cancel_agency,
       cancel_area,
       cancel_teller,
       cancel_terminal,
       sale_agency,
       sale_area,
       sale_teller,
       sale_terminal,
       loyalty_code,
       is_gui_pay,
       cancel_amount,
       cancel_bets,
       cancel_tickets,
       cancel_commission,
       cancel_lines)
      with
      total_data_detail as
       (select game_code,
               issue_number,
               c_agency_code as cancel_agency,
               c_org_code as cancel_area,
               c_teller_code as cancel_teller,
               c_terminal_code as cancel_terminal,
               agency_code as sale_agency,
               (select agency_area_code from v_mis_agency where can.agency_code = agency_code) as sale_area,
               teller_code as sale_teller,
               terminal_code as sale_terminal,
               loyalty_code,
               (case when exists(select 1 from sale_cancelinfo where gui_cancel_flow=can.applyflow_sell and is_success = 1) then 1 else 0 end) as is_gui_pay,
               ticket_amount,
               ticket_bet_count,
               commissionamount,
               bet_line
          from tmp_src_cancel can),
      total_data as
      (select game_code,issue_number,cancel_agency,cancel_area,cancel_teller,cancel_terminal,sale_agency,sale_area,sale_teller,sale_terminal,loyalty_code,is_gui_pay,
              sum(ticket_amount) as cancel_amount,
              sum(ticket_bet_count) as cancel_bets,
              count(*) as cancel_tickets,
              sum(commissionamount) as cancel_commission,
              sum(bet_line) as cancel_lines
         from total_data_detail
        group by game_code,issue_number,cancel_agency,cancel_area,cancel_teller,cancel_terminal,sale_agency,sale_area,sale_teller,sale_terminal,loyalty_code,is_gui_pay
      )
      select to_char(v_rpt_day, 'yyyy-mm-dd') as cancel_date,
             to_char(v_rpt_day, 'yyyy-ww') as cancel_week,
             to_char(v_rpt_day, 'yyyy-mm') as cancel_month,
             to_char(v_rpt_day, 'yyyy-q') as cancel_quarter,
             to_char(v_rpt_day, 'yyyy') as cancel_year,
             game_code ,
             issue_number,
             cancel_agency  ,
             cancel_area  ,
             cancel_teller  ,
             cancel_terminal  ,
             sale_agency,
             sale_area,
             sale_teller,
             sale_terminal,
             loyalty_code,
             is_gui_pay,
             nvl(cancel_amount, 0),
             nvl(cancel_bets, 0),
             nvl(cancel_tickets, 0),
             nvl(cancel_commission, 0),
             nvl(cancel_lines, 0)
        from total_data;
  dbms_output.put_line('p_mis_dss_40_gen_fact->sub_cancel:' || sql%rowcount);
  commit;

   /*****************************************************/
   /******************* 中奖主题统计 ******************/
   dbms_output.put_line('calc win ....');
   delete from sub_win
    where winning_date = to_char(v_rpt_day, 'yyyy-mm-dd');
   insert into sub_win
      (winning_date,
       winning_week,
       winning_month,
       winning_quarter,
       winning_year,
       game_code,
       issue_number,
       sale_agency,
       sale_area,
       sale_teller,
       sale_terminal,
       bet_methold,
       loyalty_code,
       is_big_one,
       win_amount,
       win_amount_without_tax,
       tax_amount,
       win_bets,
       hd_win_amount,
       hd_win_amount_without_tax,
       hd_tax_amount,
       hd_win_bets,
       ld_win_amount,
       ld_win_amount_without_tax,
       ld_tax_amount,
       ld_win_bets)
      with
      total_data as
       (select win.game_code,
               win.issue_number,
               win.agency_code,
               area.agency_area_code as area_code,
               win.teller_code,
               win.terminal_code,
               sell.bet_methold,
               sell.loyalty_code,
               win.is_big_prize as is_big_one,
               sum(win_amount) as win_amount,
               sum(win_amount_without_tax) as win_amount_without_tax,
               sum(tax_amount) as tax_amount,
               sum(win_bets) as win_bets,
               sum(hd_win_amount) as hd_win_amount,
               sum(hd_win_amount_without_tax) as hd_win_amount_without_tax,
               sum(hd_tax_amount) as hd_tax_amount,
               sum(hd_win_bets) as hd_win_bets,
               sum(ld_win_amount) as ld_win_amount,
               sum(ld_win_amount_without_tax) as ld_win_amount_without_tax,
               sum(ld_tax_amount) as ld_tax_amount,
               sum(ld_win_bets) as ld_win_bets
          from tmp_src_win win, his_sellticket sell, v_mis_agency area
         where win.applyflow_sell = sell.applyflow_sell
           and win.agency_code = area.agency_code
         group by win.game_code,
                  win.issue_number,
                  win.terminal_code,
                  win.teller_code,
                  win.agency_code,
                  area.agency_area_code,
                  sell.bet_methold,
                  sell.loyalty_code,
                  win.is_big_prize)
      select to_char(v_rpt_day, 'yyyy-mm-dd') as winning_date,
             to_char(v_rpt_day, 'yyyy-ww') as winning_week,
             to_char(v_rpt_day, 'yyyy-mm') as winning_month,
             to_char(v_rpt_day, 'yyyy-q') as winning_quarter,
             to_char(v_rpt_day, 'yyyy') as winning_year,
             game_code,
             issue_number,
             agency_code,
             area_code,
             teller_code,
             terminal_code,
             bet_methold,
             loyalty_code,
             is_big_one,
             nvl(win_amount, 0),
             nvl(win_amount_without_tax, 0),
             nvl(tax_amount, 0),
             nvl(win_bets, 0),
             nvl(hd_win_amount, 0),
             nvl(hd_win_amount_without_tax, 0),
             nvl(hd_tax_amount, 0),
             nvl(hd_win_bets, 0),
             nvl(ld_win_amount, 0),
             nvl(ld_win_amount_without_tax, 0),
             nvl(ld_tax_amount, 0),
             nvl(ld_win_bets, 0)
        from total_data;
  dbms_output.put_line('p_mis_dss_40_gen_fact->sub_win:' || sql%rowcount);
  commit;

  /*****************************************************/
  /******************* 弃奖主题统计 ******************/
  dbms_output.put_line('calc abandon ....');
  delete from sub_abandon
  where abandon_date = to_char(v_rpt_day, 'yyyy-mm-dd');
  insert into sub_abandon
    (abandon_date,
     abandon_week,
     abandon_month,
     abandon_quarter,
     abandon_year,
     game_code,
     sale_issue,
     winning_issue,
     winning_date,
     sale_agency,
     sale_area,
     sale_teller,
     sale_terminal,
     bet_methold,
     loyalty_code,
     is_big_one,
     win_amount,
     win_amount_without_tax,
     tax_amount,
     win_bets,
     hd_win_amount,
     hd_win_amount_without_tax,
     hd_tax_amount,
     hd_win_bets,
     ld_win_amount,
     ld_win_amount_without_tax,
     ld_tax_amount,
     ld_win_bets)
    with
    win_issue as
    (select applyflow_sell,win.issue_number from his_win_ticket win join tmp_src_abandon using(applyflow_sell)),
    total_data as
     (select sell.game_code,
             sell.issue_number as sale_issue,
             win_detail.issue_number as winning_issue,
             trunc(winning_time) as winning_date,
             sell.agency_code,
             area.org_code as area_code,
             sell.teller_code,
             sell.terminal_code,
             sell.bet_methold,
             sell.loyalty_code,
             sum(win_amount)                as win_amount,
             sum(win_amount_without_tax)    as win_amount_without_tax,
             sum(tax_amount)                as tax_amount,
             sum(WIN_BETS)                  as win_bets,
             sum(HD_WIN_AMOUNT)             as hd_win_amount,                             -- 税前奖金（高等奖）
             sum(HD_WIN_AMOUNT_WITHOUT_TAX) as hd_win_amount_without_tax,                 -- 税后奖金（高等奖）
             sum(HD_TAX_AMOUNT)             as hd_tax_amount,                             -- 缴税额  （高等奖）
             sum(HD_WIN_BETS)               as hd_win_bets,                               -- 中奖注数（高等奖）
             sum(LD_WIN_AMOUNT)             as ld_win_amount,                             -- 税前奖金（低等奖）
             sum(LD_WIN_AMOUNT_WITHOUT_TAX) as ld_win_amount_without_tax,                 -- 税后奖金（低等奖）
             sum(LD_TAX_AMOUNT)             as ld_tax_amount,                             -- 缴税额  （低等奖）
             sum(LD_WIN_BETS)               as ld_win_bets                                -- 中奖注数（低等奖）
        from tmp_src_abandon
        join his_sellticket sell using(applyflow_sell)
        join inf_agencys area on (sell.agency_code=area.agency_code)
        join win_issue win_detail using(applyflow_sell)
       group by sell.game_code,
                sell.issue_number,
                win_detail.issue_number,
                trunc(winning_time),
                sell.agency_code,
                area.org_code,
                sell.teller_code,
                sell.terminal_code,
                sell.bet_methold,
                sell.loyalty_code)
    select to_char(v_rpt_day, 'yyyy-mm-dd'),
           to_char(v_rpt_day, 'yyyy-ww'),
           to_char(v_rpt_day, 'yyyy-mm'),
           to_char(v_rpt_day, 'yyyy-q'),
           to_char(v_rpt_day, 'yyyy'),
           total_data.game_code,
           sale_issue,
           winning_issue,
           winning_date,
           agency_code,
           area_code,
           teller_code,
           terminal_code,
           bet_methold,
           loyalty_code,
           0,
           nvl(win_amount, 0),
           nvl(win_amount_without_tax, 0),
           nvl(tax_amount, 0),
           nvl(win_bets, 0),
           nvl(hd_win_amount, 0),
           nvl(hd_win_amount_without_tax, 0),
           nvl(hd_tax_amount, 0),
           nvl(hd_win_bets, 0),
           nvl(ld_win_amount, 0),
           nvl(ld_win_amount_without_tax, 0),
           nvl(ld_tax_amount, 0),
           nvl(ld_win_bets, 0)
      from total_data;
  dbms_output.put_line('p_mis_dss_40_gen_fact->sub_abandon:' || sql%rowcount);
  commit;
end;
