CREATE OR REPLACE PROCEDURE p_mis_dss_50_gen_rpt_aband(p_settle_id IN NUMBER) IS
   v_rpt_day DATE;
BEGIN
   SELECT settle_date
     INTO v_rpt_day
     FROM his_day_settle
    WHERE settle_id = p_settle_id;

   -- 奖等为-1的列，记录这个期次的弃奖总注数、总张数、金额；非-1时，记录各个奖等的注数和金额

   DELETE mis_report_gui_aband
    WHERE pay_date = v_rpt_day;
   INSERT INTO mis_report_gui_aband
      (pay_date, game_code, issue_number, prize_level, is_hd_prize, prize_bet_count, prize_ticket_count, winningamounttax, winningamount, taxamount)
      WITH issue AS
       ( -- 获取弃奖日的期次列表
        SELECT game_code, issue_number
          FROM TMP_ABAND_ISSUE),
      aband_data AS
       (
        -- 这一期的弃奖明细数据
        SELECT /*+ materialize */
         *
          FROM his_win_ticket_detail
         WHERE applyflow_sell IN (SELECT applyflow_sell
                                    FROM his_abandon_ticket
                                   where (game_code, issue_number) in (select game_code, issue_number from issue))),
      issue_data AS
       ( -- 期次弃奖数据
        SELECT trunc(v_rpt_day) AS pay_date,
                game_code,
                issue_number,
                -1 AS prize_level,
                0 AS is_hd_prize,
                SUM(prize_count) AS prize_bet_count,
                COUNT(DISTINCT applyflow_sell) AS prize_ticket_count,
                SUM(winningamounttax) AS winningamounttax,
                SUM(winningamount) AS winningamount,
                SUM(taxamount) AS taxamount
          FROM aband_data
         GROUP BY game_code, issue_number),
      prize_data AS
       ( -- 期次弃奖明细
        SELECT trunc(v_rpt_day) AS pay_date,
                game_code,
                issue_number,
                prize_level,
                is_hd_prize,
                SUM(prize_count) AS prize_bet_count,
                0 AS prize_ticket_count,
                SUM(winningamounttax) AS winningamounttax,
                SUM(winningamount) AS winningamount,
                SUM(taxamount) AS taxamount
          FROM aband_data
         GROUP BY game_code, issue_number, prize_level, is_hd_prize)
      -- 主查询
      SELECT nvl(pay_date, trunc(v_rpt_day)),
             game_code,
             issue_number,
             nvl(prize_level, -1),
             nvl(is_hd_prize, 0),
             nvl(prize_bet_count, 0),
             nvl(prize_ticket_count, 0),
             nvl(winningamounttax, 0),
             nvl(winningamount, 0),
             nvl(taxamount, 0)
        FROM issue
        LEFT JOIN issue_data
       USING (game_code, issue_number)
      UNION ALL
      SELECT pay_date,
             game_code,
             issue_number,
             prize_level,
             is_hd_prize,
             prize_bet_count,
             prize_ticket_count,
             winningamounttax,
             winningamount,
             taxamount
        FROM prize_data;
   COMMIT;
END;
