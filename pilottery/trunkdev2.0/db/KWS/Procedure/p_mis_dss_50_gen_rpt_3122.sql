CREATE OR REPLACE PROCEDURE p_mis_dss_50_gen_rpt_3122(p_settle_id IN NUMBER) IS
   v_rpt_day DATE;
BEGIN
   SELECT settle_date
     INTO v_rpt_day
     FROM his_day_settle
    WHERE settle_id = p_settle_id;

   INSERT INTO tmp_rst_3122
      (game_code, issue_number, area_code, sale_sum, cancel_sum, win_sum)
      WITH sell AS
       (
        /* 今天的销售站销售额 */
        SELECT game_code, issue_number, sale_area AS area_code, SUM(pure_amount_single_issue) AS sale_amount
          FROM sub_sell
         WHERE sale_date = to_char(v_rpt_day, 'yyyy-mm-dd')
         GROUP BY game_code, issue_number, sale_area),
      win AS
       (
        /* 今天的中奖 */
        SELECT game_code, issue_number, sale_area AS area_code, SUM(win_amount) AS win_amount
          FROM sub_win
         WHERE winning_date = to_char(v_rpt_day, 'yyyy-mm-dd')
         GROUP BY game_code, issue_number, sale_area),
      cancel AS
       (
        /* 今天的退票 */
        SELECT game_code, issue_number, sale_area AS area_code, SUM(cancel_amount) AS cancel_amount
          FROM sub_cancel
         WHERE cancel_date = to_char(v_rpt_day, 'yyyy-mm-dd')
         GROUP BY game_code, issue_number, sale_area)
      SELECT game_code, issue_number, area_code, nvl(sale_amount, 0), nvl(cancel_amount, 0), nvl(win_amount, 0)
        FROM sell
        FULL JOIN win
       USING (game_code, issue_number, area_code)
        FULL OUTER JOIN cancel
       USING (game_code, issue_number, area_code);

   COMMIT;

/*   -- 计算区域汇总数据
   FOR v_n_area_type IN REVERSE 1 .. 2 LOOP
      INSERT INTO tmp_rst_3122
         (game_code, issue_number, area_code, sale_sum, cancel_sum, win_sum)
         SELECT game_code, issue_number, area.father_area, SUM(sale_sum), SUM(cancel_sum), SUM(win_sum)
           FROM tmp_rst_3122 tab, v_mis_area area
          WHERE tab.area_code = area.area_code
            AND area.area_type = v_n_area_type
          GROUP BY game_code, issue_number, area.father_area;
   END LOOP;
   COMMIT;*/


   -- 计算区域汇总数据
      INSERT INTO tmp_rst_3122
         (game_code, issue_number, area_code, sale_sum, cancel_sum, win_sum)
         SELECT game_code, issue_number, area.father_area, SUM(sale_sum), SUM(cancel_sum), SUM(win_sum)
           FROM tmp_rst_3122 tab, v_mis_area area
          WHERE tab.area_code = area.area_code
            AND area.area_type = 1
          GROUP BY game_code, issue_number, area.father_area;
   COMMIT;
   
   
   -- 更新区域名称
   UPDATE tmp_rst_3122
      SET area_name =
          (SELECT area_name
             FROM v_mis_area
            WHERE area_code = tmp_rst_3122.area_code);
   COMMIT;
END;