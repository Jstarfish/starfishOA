create or replace procedure p_mis_dss_20_gen_tmp_src(p_settle_id in number) is
  pre_settle his_day_settle%rowtype;
  now_settle his_day_settle%rowtype;

begin
  -- 获取当前日结信息和最近一次的日结信息
  select *
    into now_settle
    from his_day_settle
   where settle_id = p_settle_id;
  select *
    into pre_settle
    from his_day_settle
   where settle_id = (select max(settle_id)
                        from his_day_settle
                       where settle_id < p_settle_id);

  -- 所有游戏期次进临时表
  insert into tmp_all_issue
    select game_code,
           issue_number,
           issue_seq,
           trunc(real_start_time),
           trunc(real_close_time),
           trunc(issue_end_time),
           real_start_time,
           real_close_time,
           issue_end_time
      from iss_game_issue where game_code <> 14;
  dbms_output.put_line('p_mis_dss_20_gen_tmp_src->游戏期次:' || sql%rowcount);

  -- 销售期次
  insert into tmp_sell_issue
    (game_code, issue_number, issue_seq)
    select game_code, issue_number, issue_seq
      from tmp_all_issue
     where (start_time > pre_settle.opt_date and
           start_time <= now_settle.opt_date) -- 第一种情况，时间段往左偏
        or (close_time > pre_settle.opt_date and
           close_time <= now_settle.opt_date) -- 第二种情况，时间段往右偏
        or (start_time < pre_settle.opt_date and
           (close_time > now_settle.opt_date or close_time is null)); -- 第三种情况，时间段包含统计时间段
  dbms_output.put_line('p_mis_dss_20_gen_tmp_src->销售期次:' || sql%rowcount);

  -- 开奖期次
  insert into tmp_win_issue
    (game_code, issue_number, issue_seq)
    select game_code, issue_number, issue_seq
      from tmp_all_issue
     where reward_time > pre_settle.opt_date
       and reward_time <= now_settle.opt_date;
  dbms_output.put_line('p_mis_dss_20_gen_tmp_src->开奖期次:' || sql%rowcount);

  -- 弃奖期次
  insert into tmp_aband_issue
    (game_code, issue_number, issue_end_time)
    select game_code, issue_number, trunc(issue_end_time)
      from iss_game_issue 
     where game_code <> 14 and 
	 pay_end_day = to_number(to_char(now_settle.settle_date - 1, 'yyyymmdd'));
  dbms_output.put_line('p_mis_dss_20_gen_tmp_src->弃奖期次:' || sql%rowcount);

  commit;

  -- 销售站
  insert into tmp_agency
    (agency_code,
     agency_name,
     storetype_id,
     org_code,
     area_code,
     status,
     agency_type,
     bank_id,
     bank_account,
     marginal_credit,
     available_credit,
     telephone,
     contact_person,
     address,
     agency_add_time)
    select agency_code,
           agency_name,
           storetype_id,
           org_code,
           area_code,
           status,
           agency_type,
           bank_id,
           bank_account,
           credit_limit,
           account_balance,
           telephone,
           contact_person,
           address,
           agency_add_time
      from his_saler_agency
      join acc_agency_account
     using (agency_code)
     where settle_id = now_settle.settle_id
       and acc_type = 1;
  dbms_output.put_line('p_mis_dss_20_gen_tmp_src->销售站:' || sql%rowcount);

  /* 弃奖和中奖的临时表已经在10和15中形成 */
  -- 卖票表
  insert into tmp_src_sell
    (applyflow_sell,
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
     result_code)
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
           result_code
      from his_sellticket
     where game_code <> 14 
	   and sell_seq > pre_settle.sell_seq
       and sell_seq <= now_settle.sell_seq;
  dbms_output.put_line('p_mis_dss_20_gen_tmp_src->卖票表:' || sql%rowcount);
  commit;

  --兑奖表
  insert into tmp_src_pay
    (applyflow_pay,
     applyflow_sell,
     game_code,
     issue_number,
     pay_issue_number,
     terminal_code,
     teller_code,
     agency_code,
     org_code,
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
     is_center)
    select applyflow_pay,
           applyflow_sell,
           game_code,
           (select issue_number from his_sellticket where applyflow_sell= his_payticket.applyflow_sell),
           issue_number,
           terminal_code,
           teller_code,
           agency_code,
           org_code,
           paytime,
           winningamounttax,
           winningamount,
           taxamount,
           (case when is_center=1 then paycommissionrate_o else paycommissionrate end) paycommissionrate,
           (case when is_center=1 then commissionamount_o else commissionamount end) commissionamount,
           winningcount,
           hd_winning,
           hd_count,
           ld_winning,
           ld_count,
           nvl(loyalty_code, 'no_loyalty_code'),
           is_big_prize,
           is_center
      from his_payticket
     where game_code <> 14 
	   and pay_seq > pre_settle.pay_seq
       and pay_seq <= now_settle.pay_seq;
  dbms_output.put_line('p_mis_dss_20_gen_tmp_src->兑奖表:' || sql%rowcount);
  commit;

  -- 退票表
  insert into tmp_src_cancel
    (applyflow_cancel,
     canceltime,
     applyflow_sell,
     c_terminal_code,
     c_teller_code,
     c_agency_code,
     c_org_code,
     saletime,
     terminal_code,
     teller_code,
     agency_code,
     game_code,
     issue_number,
     ticket_amount,
     ticket_bet_count,
     salecommissionrate,
     commissionamount,
     bet_methold,
     bet_line,
     loyalty_code,
     is_center)
    with cancel as
     (select /*+ materialize */
       applyflow_cancel,
       canceltime,
       applyflow_sell,
       terminal_code,
       teller_code,
       agency_code,
       org_code,
       is_center
        from his_cancelticket
       where cancel_seq > pre_settle.cancel_seq
         and cancel_seq <= now_settle.cancel_seq),
    sell as
     (select applyflow_sell,
             saletime,
             terminal_code,
             teller_code,
             agency_code,
             game_code,
             issue_number,
             ticket_amount,
             ticket_bet_count,
             salecommissionrate,
             commissionamount,
             bet_methold,
             bet_line,
             loyalty_code
        from his_sellticket
       where applyflow_sell in (select applyflow_sell from cancel))
    select cancel.applyflow_cancel,
           cancel.canceltime,
           applyflow_sell,
           cancel.terminal_code,
           cancel.teller_code,
           cancel.agency_code,
           org_code,
           sell.saletime,
           sell.terminal_code,
           sell.teller_code,
           sell.agency_code,
           sell.game_code,
           sell.issue_number,
           sell.ticket_amount,
           sell.ticket_bet_count,
           sell.salecommissionrate,
           sell.commissionamount,
           sell.bet_methold,
           sell.bet_line,
           sell.loyalty_code,
           is_center
      from cancel
      join sell
     using (applyflow_sell);
  dbms_output.put_line('p_mis_dss_20_gen_tmp_src->退票表:' || sql%rowcount);
  commit;
end;