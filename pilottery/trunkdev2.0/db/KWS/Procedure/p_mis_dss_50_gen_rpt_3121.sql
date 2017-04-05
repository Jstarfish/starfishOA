CREATE OR REPLACE PROCEDURE p_mis_dss_50_gen_rpt_3121(p_settle_id IN NUMBER) IS
   v_rpt_day DATE;
BEGIN
   SELECT settle_date
     INTO v_rpt_day
     FROM his_day_settle
    WHERE settle_id = p_settle_id;

   INSERT INTO tmp_rst_3121
      (sale_year, game_code, area_code, sale_sum)
      SELECT to_number(to_char(v_rpt_day, 'yyyy')), game_code, sale_area, SUM(pure_amount)
        FROM sub_sell
       WHERE sale_date = to_char(v_rpt_day, 'yyyy-mm-dd')
       GROUP BY game_code, sale_area;
   COMMIT;

   
/*   -- 计算区域汇总数据
   FOR v_n_area_type IN REVERSE 1 .. 2 LOOP
      INSERT INTO tmp_rst_3121
         (sale_year, game_code, area_code, sale_sum)
         SELECT sale_year, game_code, area.father_area, SUM(sale_sum)
           FROM tmp_rst_3121 tab, v_mis_area area
          WHERE tab.area_code = area.area_code
            AND area.area_type = v_n_area_type
          GROUP BY sale_year, game_code, area.father_area;
   END LOOP;
   COMMIT;*/

   -- 计算区域汇总数据
      INSERT INTO tmp_rst_3121
         (sale_year, game_code, area_code, sale_sum)
         SELECT sale_year, game_code, area.father_area, SUM(sale_sum)
           FROM tmp_rst_3121 tab, v_mis_area area
          WHERE tab.area_code = area.area_code
          GROUP BY sale_year, game_code, area.father_area;
   COMMIT;
   
   
   -- 按照月份做update
   CASE to_number(to_char(v_rpt_day, 'mm'))
      WHEN 1 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_1 = sale_sum;
      WHEN 2 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_2 = sale_sum;
      WHEN 3 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_3 = sale_sum;
      WHEN 4 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_4 = sale_sum;
      WHEN 5 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_5 = sale_sum;
      WHEN 6 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_6 = sale_sum;
      WHEN 7 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_7 = sale_sum;
      WHEN 8 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_8 = sale_sum;
      WHEN 9 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_9 = sale_sum;
      WHEN 10 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_10 = sale_sum;
      WHEN 11 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_11 = sale_sum;
      WHEN 12 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_12 = sale_sum;
   END CASE;
   COMMIT;

   -- 更新区域名称
   UPDATE tmp_rst_3121
      SET area_name =
          (SELECT area_name
             FROM v_mis_area
            WHERE area_code = tmp_rst_3121.area_code);
   COMMIT;

END;