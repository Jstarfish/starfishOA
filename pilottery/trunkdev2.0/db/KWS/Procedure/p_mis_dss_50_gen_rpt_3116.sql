CREATE OR REPLACE PROCEDURE p_mis_dss_50_gen_rpt_3116(p_settle_id IN NUMBER) IS
   v_rpt_day DATE;
BEGIN
   SELECT settle_date
     INTO v_rpt_day
     FROM his_day_settle
    WHERE settle_id = p_settle_id;

   INSERT INTO TMP_RST_3116
      (count_date,
       agency_code,
       agency_type,
       area_code,
       area_name,
       game_code,
       issue_number,
       sale_sum,
       sale_comm_sum)
      WITH sell AS
       (
        /* 今天的销售站销售额 */
        SELECT sale_agency AS agency_code,
                game_code,
                issue_number,
                SUM(pure_amount_single_issue) AS sale_amount,
                SUM(pure_commision_single_issue) AS sale_commission
          FROM sub_sell
         WHERE sale_date = to_char(v_rpt_day, 'yyyy-mm-dd')
           and issue_number > 0
         GROUP BY sale_agency, game_code, issue_number),
      agency AS
       (SELECT agency_code, agency_type, agency_area_code, agency_area_name, game_code
          FROM v_mis_agency, inf_games)
      SELECT trunc(v_rpt_day),
             agency_code,
             agency.agency_type,
             agency.agency_area_code,
             agency.agency_area_name,
             game_code,
             nvl(issue_number, 0) as issue_number,
             nvl(sale_amount, 0) as sale_amount,
             nvl(sale_commission, 0) as sale_commission
        FROM agency
        LEFT JOIN sell
       USING (agency_code, game_code);

   COMMIT;

END;
