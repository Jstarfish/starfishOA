create or replace procedure p_mis_dss_50_gen_rpt_3117
(p_settle_id       in number)
is
   v_rpt_day   date;

begin
   select settle_date into v_rpt_day from his_day_settle where settle_id=p_settle_id;

   -- 2.1.16.6 大奖兑付明细报表（mis_report_3117）
   delete from mis_report_3117
    where pay_time >= to_date(to_char(v_rpt_day,'yyyy-mm-dd')||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
      and pay_time < to_date(to_char(v_rpt_day+1,'yyyy-mm-dd')||' 00:00:00','yyyy-mm-dd hh24:mi:ss');

   insert into mis_report_3117 (pay_time,          game_code,              issue_number,
                                pay_amount,        pay_tax,                pay_amount_after_tax,
                                pay_tsn,           sale_tsn,               gui_pay_flow,
                                applyflow_sale,    winnername,             cert_type,
                                cert_no,           agency_code,            payer_admin)
   select pay_time,           game_code,           (select issue_number from his_sellticket where applyflow_sell = sale_gamepayinfo.applyflow_sale) as issue_number,
          pay_amount,         pay_tax,             pay_amount_after_tax,
          pay_tsn,            sale_tsn,            gui_pay_flow,
          applyflow_sale,     winnername,          cert_type,
          cert_no,            org_code,            payer_admin
     from sale_gamepayinfo
     join gp_static using(game_code)
    where is_success = 1
      and pay_time >= to_date(to_char(v_rpt_day,'yyyy-mm-dd')||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
      and pay_time < to_date(to_char(v_rpt_day+1,'yyyy-mm-dd')||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
      and pay_amount >= limit_big_prize;

   insert into mis_report_3117 (
          pay_time, game_code, issue_number, pay_amount, pay_tax, pay_amount_after_tax,
          pay_tsn, sale_tsn, gui_pay_flow, applyflow_sale,
          winnername, cert_type, cert_no, agency_code, payer_admin)
   select paytime as pay_time, game_code, (select issue_number from his_sellticket where applyflow_sell = tmp_src_pay.applyflow_sell) as issue_number,
          winningamounttax as pay_amount, taxamount as pay_tax, winningamount as pay_amount_after_tax,
          null as pay_tsn, null as sale_tsn, applyflow_pay as gui_pay_flow, applyflow_sell as applyflow_sale,
          null as winnername, null as cert_type, null as cert_no, agency_code, null as payer_admin
     from tmp_src_pay
    where is_big_prize = 1
      and applyflow_sell not in (select applyflow_sale from mis_report_3117);
   commit;

end;
