CREATE OR REPLACE PROCEDURE p_mis_dss_50_gen_rpt_3125(p_settle_id IN NUMBER) IS
   v_rpt_day DATE;
BEGIN
   SELECT settle_date
     INTO v_rpt_day
     FROM his_day_settle
    WHERE settle_id = p_settle_id;

   INSERT INTO tmp_rst_3125
      (sale_date, game_code, area_code, sale_sum, sale_count, sale_bet)
      SELECT v_rpt_day, game_code, sale_area, SUM(pure_amount), SUM(pure_tickets), SUM(pure_bets)
        FROM sub_sell
       WHERE sale_date = to_char(v_rpt_day, 'yyyy-mm-dd')
       GROUP BY game_code, sale_area;
   COMMIT;

/*   -- 计算区域汇总数据
   FOR v_n_area_type IN REVERSE 1 .. 2 LOOP
      INSERT INTO tmp_rst_3125
         (sale_date, game_code, area_code, sale_sum, sale_count, sale_bet)
         SELECT sale_date, game_code, area.father_area, SUM(sale_sum), SUM(sale_count), SUM(sale_bet)
           FROM tmp_rst_3125 tab, v_mis_area area
          WHERE tab.area_code = area.area_code
            AND area.area_type = v_n_area_type
          GROUP BY sale_date, game_code, area.father_area;
   END LOOP;
   COMMIT;
*/
   
      -- 计算区域汇总数据
      INSERT INTO tmp_rst_3125
         (sale_date, game_code, area_code, sale_sum, sale_count, sale_bet)
         SELECT sale_date, game_code, area.father_area, SUM(sale_sum), SUM(sale_count), SUM(sale_bet)
           FROM tmp_rst_3125 tab, v_mis_area area
          WHERE tab.area_code = area.area_code
            AND area.area_type = 1
          GROUP BY sale_date, game_code, area.father_area;
   COMMIT;
   
   

   -- 更新区域名称
   UPDATE tmp_rst_3125
      SET area_name           =
          (SELECT area_name
             FROM v_mis_area
            WHERE area_code = tmp_rst_3125.area_code),
          single_ticket_amount = (case when sale_count=0 then 0 else sale_sum / sale_count end);
   COMMIT;
END;