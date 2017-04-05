CREATE OR REPLACE PROCEDURE p_mis_dss_50_gen_rpt_3124(p_settle_id IN NUMBER) IS
  v_rpt_day DATE;
BEGIN
  SELECT settle_date
    INTO v_rpt_day
    FROM his_day_settle
   WHERE settle_id = p_settle_id;

  INSERT INTO tmp_rst_3124
    (game_code,
     pay_date,
     area_code,
     hd_payment_sum,
     hd_payment_amount,
     hd_payment_tax,
     ld_payment_sum,
     ld_payment_amount,
     ld_payment_tax,
     payment_sum)
    SELECT game_code,
           v_rpt_day,
           pay_area,
           SUM(hd_pay_amount_without_tax) AS h_amount,
           SUM(hd_pay_bets) AS h_bets,
           SUM(hd_tax_amount) AS h_tax,
           SUM(ld_pay_amount_without_tax) AS l_amount,
           SUM(ld_pay_bets) AS l_bets,
           SUM(ld_tax_amount) AS l_tax,
           SUM(pay_amount_without_tax) AS amount
      FROM sub_pay
     WHERE pay_date = to_char(v_rpt_day, 'yyyy-mm-dd')
     GROUP BY game_code, pay_area;

  -- 计算区域汇总数据
  merge into tmp_rst_3124 dest
  using (SELECT game_code,
                pay_date,
                '00' area_code,
                SUM(hd_payment_sum) hd_payment_sum,
                SUM(hd_payment_amount) hd_payment_amount,
                SUM(hd_payment_tax) hd_payment_tax,
                SUM(ld_payment_sum) ld_payment_sum,
                SUM(ld_payment_amount) ld_payment_amount,
                SUM(ld_payment_tax) ld_payment_tax,
                SUM(payment_sum) payment_sum
           FROM tmp_rst_3124
          WHERE area_code <> '00'
          GROUP BY game_code, pay_date) src
  on (dest.game_code = src.game_code and dest.pay_date = src.pay_date and dest.area_code = src.area_code)
  when matched then
    update
       set hd_payment_sum    = dest.hd_payment_sum + src.hd_payment_sum,
           hd_payment_amount = src.hd_payment_amount +
                               dest.hd_payment_amount,
           hd_payment_tax    = src.hd_payment_tax + dest.hd_payment_tax,
           ld_payment_sum    = src.ld_payment_sum + dest.ld_payment_sum,
           ld_payment_amount = src.ld_payment_amount +
                               dest.ld_payment_amount,
           ld_payment_tax    = src.ld_payment_tax + dest.ld_payment_tax,
           payment_sum       = src.payment_sum + dest.payment_sum
  when not matched then
    insert
      (game_code,
       pay_date,
       area_code,
       hd_payment_sum,
       hd_payment_amount,
       hd_payment_tax,
       ld_payment_sum,
       ld_payment_amount,
       ld_payment_tax,
       payment_sum)
    values
      (src.game_code,
       src.pay_date,
       src.area_code,
       src.hd_payment_sum,
       src.hd_payment_amount,
       src.hd_payment_tax,
       src.ld_payment_sum,
       src.ld_payment_amount,
       src.ld_payment_tax,
       src.payment_sum);

  COMMIT;

  -- 更新区域名称
  UPDATE tmp_rst_3124
     SET area_name =
         (SELECT area_name
            FROM v_mis_area
           WHERE area_code = tmp_rst_3124.area_code);
  COMMIT;
END;
