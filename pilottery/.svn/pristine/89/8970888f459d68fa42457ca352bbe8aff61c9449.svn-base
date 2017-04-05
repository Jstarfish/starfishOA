CREATE OR REPLACE PROCEDURE p_mis_dss_50_gen_rpt_ncp(p_settle_id IN NUMBER) IS
   v_rpt_day DATE;
BEGIN
   SELECT settle_date
     INTO v_rpt_day
     FROM his_day_settle
    WHERE settle_id = p_settle_id;

   INSERT INTO tmp_rst_ncp
      (count_date,
       agency_code,
       agency_type,
       area_code,
       area_name,
       game_code,
       issue_number,
       sale_sum,
       sale_count,
       cancel_sum,
       cancel_count,
       pay_sum,
       pay_count,
       sale_comm_sum,
       pay_comm_count)
      WITH sell AS
       (
        /* 今天的销售站销售额 */
        SELECT sale_agency AS agency_code,
                game_code,
                issue_number,
                SUM(pure_amount) AS sale_amount,
                SUM(pure_commission) AS sale_commission,
                SUM(pure_tickets) AS sale_tickets
          FROM sub_sell
         WHERE sale_date = to_char(v_rpt_day, 'yyyy-mm-dd')
           and issue_number > 0
         GROUP BY sale_agency, game_code, issue_number),
      pay AS
       (
        /* 今天的兑奖 */
        SELECT pay_agency AS agency_code,
                game_code,
                issue_number,
                SUM(pay_amount_without_tax) AS pay_amount,
                SUM(pay_commission) AS pay_commission,
                SUM(pay_tickets) AS pay_tickets
          FROM sub_pay
         WHERE pay_date = to_char(v_rpt_day, 'yyyy-mm-dd')
           and issue_number > 0
         GROUP BY pay_agency, game_code, issue_number),
      cancel AS
       (
        /* 今天的退票 */
        SELECT cancel_agency AS agency_code,
                game_code,
                issue_number,
                SUM(cancel_amount) AS cancel_amount,
                SUM(cancel_tickets) AS cancel_tickets
          FROM sub_cancel
         WHERE cancel_date = to_char(v_rpt_day, 'yyyy-mm-dd')
           and issue_number > 0
         GROUP BY cancel_agency, game_code, issue_number),
      agency AS
       (SELECT agency_code, agency_type, agency_area_code, agency_area_name, game_code
          FROM v_mis_agency, inf_games)
      SELECT trunc(v_rpt_day),
             agency_code,
             agency.agency_type,
             agency.agency_area_code,
             agency.agency_area_name,
             game_code,
             nvl(issue_number, 0),
             nvl(sale_amount, 0),
             nvl(sale_tickets, 0),
             nvl(cancel_amount, 0),
             nvl(cancel_tickets, 0),
             nvl(pay_amount, 0),
             nvl(pay_tickets, 0),
             nvl(sale_commission, 0),
             nvl(pay_commission, 0)
        FROM agency
        LEFT JOIN (SELECT agency_code,
                          game_code,
                          issue_number,
                          sale_amount,
                          sale_tickets,
                          cancel_amount,
                          cancel_tickets,
                          pay_amount,
                          pay_tickets,
                          sale_commission,
                          pay_commission
                     FROM sell
                     FULL OUTER JOIN pay
                    USING (agency_code, game_code, issue_number)
                     FULL OUTER JOIN cancel
                    USING (agency_code, game_code, issue_number))
       USING (agency_code, game_code);

   COMMIT;

END;
