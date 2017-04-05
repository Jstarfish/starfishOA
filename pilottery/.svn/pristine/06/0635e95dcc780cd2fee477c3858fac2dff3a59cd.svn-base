CREATE OR REPLACE PROCEDURE p_mis_dss_50_gen_rpt_3112(p_settle_id IN NUMBER) IS
   v_rpt_day DATE;
BEGIN
   SELECT settle_date
     INTO v_rpt_day
     FROM his_day_settle
    WHERE settle_id = p_settle_id;
   INSERT INTO tmp_rst_3112
      (purged_date, game_code, issue_number, winning_sum, hd_purged_amount, ld_purged_amount, hd_purged_sum, ld_purged_sum, purged_amount)
      WITH game_issue AS
       (
        /* 确定指定日期的弃奖游戏期次 */
        SELECT game_code, issue_number
          FROM tmp_aband_issue),
      abandon AS
       (
        /* 弃奖 */
        SELECT game_code,
                sale_issue issue_number,
                SUM(win_amount) AS win_amount,
                SUM(hd_win_amount) AS hd_win_amount,
                SUM(hd_win_bets) AS hd_win_bets,
                SUM(ld_win_amount) AS ld_win_amount,
                SUM(ld_win_bets) AS ld_win_bets
          FROM sub_abandon
         WHERE (game_code, sale_issue) IN (SELECT game_code, issue_number
                                               FROM game_issue)
         GROUP BY game_code, sale_issue),
      win AS
       (
        /* 中奖 */
        SELECT game_code, issue_number, SUM(win_amount) AS win_amount
          FROM sub_win
         WHERE (game_code, issue_number) IN (SELECT game_code, issue_number
                                               FROM game_issue)
         GROUP BY game_code, issue_number)
      /* 拼起来，插入数据 */
      SELECT trunc(v_rpt_day),
             game_code,
             issue_number,
             win.win_amount,
             abandon.hd_win_amount,
             abandon.ld_win_amount,
             abandon.hd_win_bets,
             abandon.ld_win_bets,
             abandon.win_amount
        FROM abandon
        JOIN win
       USING (game_code, issue_number);

   COMMIT;
END;
