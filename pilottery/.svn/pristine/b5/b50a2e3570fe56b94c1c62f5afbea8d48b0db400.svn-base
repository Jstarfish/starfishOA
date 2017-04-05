CREATE OR REPLACE PROCEDURE p_mis_dss_60_gen_rpt_merge_all(p_settle_id IN NUMBER) IS
   v_rpt_day DATE;
   v_exists  NUMBER(1);
   v_lastday_year number(4);
   v_lastday_mon  number(2);
   v_lastday_day  number(2);

   -- 发送消息内容
   v_sale number(28);
   v_pay number(28);
   v_aband number(28);

   v_sql varchar2(4000);
   v_msg varchar2(4000);

   -- for debug
   v_cnt number(10);

BEGIN
   SELECT settle_date
     INTO v_rpt_day
     FROM his_day_settle
    WHERE settle_id = p_settle_id;

   v_lastday_year := to_number(to_char(v_rpt_day,'yyyy'));
   v_lastday_mon := to_number(to_char(v_rpt_day,'mm'));
   v_lastday_day := to_number(to_char(v_rpt_day + 1,'dd'));

   -- 2.1.17.1 区域游戏销售统计表（MIS_REPORT_3111）
   DELETE FROM mis_report_3111
    WHERE sale_date = v_rpt_day;
   INSERT INTO mis_report_3111
      SELECT *
        FROM tmp_rst_3111;
   COMMIT;

   -- 2.1.17.2 弃奖统计日报表（MIS_REPORT_3112）
   DELETE FROM mis_report_3112
    WHERE purged_date = v_rpt_day;
   INSERT INTO mis_report_3112
      SELECT *
        FROM tmp_rst_3112;
   COMMIT;

   -- 2.1.17.3 区域中奖统计表（MIS_REPORT_3113）
   SELECT COUNT(*)
     INTO v_exists
     FROM dual
    WHERE EXISTS (SELECT 1
             FROM calc_rst_3113
            WHERE calc_date = v_rpt_day);
   IF v_exists = 1 THEN
      UPDATE mis_report_3113 dest
         SET sale_sum          = sale_sum - nvl((SELECT sale_sum
                                                  FROM calc_rst_3113
                                                 WHERE dest.game_code = game_code
                                                   AND dest.issue_number = issue_number
                                                   AND dest.area_code = area_code
                                                   AND calc_date = v_rpt_day),
                                                0),
             hd_winning_sum    = hd_winning_sum - nvl((SELECT hd_winning_sum
                                                        FROM calc_rst_3113
                                                       WHERE dest.game_code = game_code
                                                         AND dest.issue_number = issue_number
                                                         AND dest.area_code = area_code
                                                         AND calc_date = v_rpt_day),
                                                      0),
             hd_winning_amount = hd_winning_sum - nvl((SELECT hd_winning_sum
                                                        FROM calc_rst_3113
                                                       WHERE dest.game_code = game_code
                                                         AND dest.issue_number = issue_number
                                                         AND dest.area_code = area_code
                                                         AND calc_date = v_rpt_day),
                                                      0),
             ld_winning_sum    = hd_winning_sum - nvl((SELECT hd_winning_sum
                                                        FROM calc_rst_3113
                                                       WHERE dest.game_code = game_code
                                                         AND dest.issue_number = issue_number
                                                         AND dest.area_code = area_code
                                                         AND calc_date = v_rpt_day),
                                                      0),
             ld_winning_amount = hd_winning_sum - nvl((SELECT hd_winning_sum
                                                        FROM calc_rst_3113
                                                       WHERE dest.game_code = game_code
                                                         AND dest.issue_number = issue_number
                                                         AND dest.area_code = area_code
                                                         AND calc_date = v_rpt_day),
                                                      0),
             winning_sum       = winning_sum - nvl((SELECT hd_winning_sum
                                                        FROM calc_rst_3113
                                                       WHERE dest.game_code = game_code
                                                         AND dest.issue_number = issue_number
                                                         AND dest.area_code = area_code
                                                         AND calc_date = v_rpt_day),
                                                      0),
             winning_rate     =
             (CASE
                WHEN nvl((sale_sum - nvl((SELECT sale_sum
                                           FROM calc_rst_3113
                                          WHERE dest.game_code = game_code
                                            AND dest.issue_number = issue_number
                                            AND dest.area_code = area_code
                                            AND calc_date = v_rpt_day),
                                         0)),
                         0) = 0 THEN
                 0
                ELSE
                 (winning_sum - nvl((SELECT winning_sum
                                         FROM calc_rst_3113
                                        WHERE dest.game_code = game_code
                                          AND dest.issue_number = issue_number
                                          AND dest.area_code = area_code
                                          AND calc_date = v_rpt_day),
                                       0)) / nvl((sale_sum - nvl((SELECT sale_sum
                                                                   FROM calc_rst_3113
                                                                  WHERE dest.game_code = game_code
                                                                    AND dest.issue_number = issue_number
                                                                    AND dest.area_code = area_code
                                                                    AND calc_date = v_rpt_day),
                                                                 0)),
                                                 0)
             END) * 10000
       WHERE (game_code, issue_number, area_code) IN (SELECT game_code, issue_number, area_code
                                                        FROM calc_rst_3113
                                                       WHERE calc_date = v_rpt_day);
      DELETE FROM calc_rst_3113
       WHERE calc_date = v_rpt_day;
   END IF;
   MERGE INTO mis_report_3113 dest
   USING tmp_rst_3113 src
   ON (dest.game_code = src.game_code AND dest.issue_number = src.issue_number AND dest.area_code = src.area_code)
   WHEN MATCHED THEN
      UPDATE
         SET sale_sum          = dest.sale_sum + src.sale_sum,
             hd_winning_sum    = dest.hd_winning_sum + src.hd_winning_sum,
             hd_winning_amount = dest.hd_winning_amount + src.hd_winning_amount,
             ld_winning_sum    = dest.ld_winning_sum + src.ld_winning_sum,
             ld_winning_amount = dest.ld_winning_amount + src.ld_winning_amount,
             winning_sum       = dest.winning_sum + src.winning_sum,
             winning_rate     =
             (CASE
                WHEN (dest.sale_sum + src.sale_sum) = 0 THEN
                 0
                ELSE
                 (dest.winning_sum + src.winning_sum) / (dest.sale_sum + src.sale_sum)
             END) * 10000
   WHEN NOT MATCHED THEN
      INSERT(game_code, issue_number, area_code, area_name, sale_sum, hd_winning_sum, hd_winning_amount, ld_winning_sum, ld_winning_amount, winning_sum, winning_rate)
      VALUES(src.game_code, src.issue_number, src.area_code, src.area_name, src.sale_sum, src.hd_winning_sum, src.hd_winning_amount, src.ld_winning_sum, src.ld_winning_amount, src.winning_sum, src.winning_rate);
   COMMIT;
   INSERT INTO calc_rst_3113
      SELECT game_code,
             issue_number,
             area_code,
             area_name,
             sale_sum,
             hd_winning_sum,
             hd_winning_amount,
             ld_winning_sum,
             ld_winning_amount,
             winning_sum,
             winning_rate,
             v_rpt_day
        FROM tmp_rst_3113;
   COMMIT;

   -- 2.1.17.6 销售站游戏期次报表（MIS_REPORT_NCP）
   DELETE FROM mis_report_ncp
    WHERE count_date = v_rpt_day;
   INSERT INTO mis_report_ncp
      SELECT *
        FROM tmp_rst_ncp;
   COMMIT;

   -- 2.1.17.7 销售年报（MIS_REPORT_3121）
   SELECT COUNT(*)
     INTO v_exists
     FROM dual
    WHERE EXISTS (SELECT 1
             FROM calc_rst_3121
            WHERE calc_date = v_rpt_day);
   IF v_exists = 1 THEN
      UPDATE mis_report_3121 dest
         SET sale_sum    = sale_sum - nvl((SELECT sale_sum
                                            FROM calc_rst_3121 src
                                           WHERE dest.game_code = src.game_code
                                             AND dest.area_code = src.area_code
                                             AND dest.sale_year = src.sale_year
                                             AND src.calc_date = v_rpt_day),
                                          0),
             sale_sum_1  = sale_sum_1 - nvl((SELECT sale_sum_1
                                              FROM calc_rst_3121 src
                                             WHERE dest.game_code = src.game_code
                                               AND dest.area_code = src.area_code
                                               AND dest.sale_year = src.sale_year
                                               AND src.calc_date = v_rpt_day),
                                            0),
             sale_sum_2  = sale_sum_2 - nvl((SELECT sale_sum_2
                                              FROM calc_rst_3121 src
                                             WHERE dest.game_code = src.game_code
                                               AND dest.area_code = src.area_code
                                               AND dest.sale_year = src.sale_year
                                               AND src.calc_date = v_rpt_day),
                                            0),
             sale_sum_3  = sale_sum_3 - nvl((SELECT sale_sum_3
                                              FROM calc_rst_3121 src
                                             WHERE dest.game_code = src.game_code
                                               AND dest.area_code = src.area_code
                                               AND dest.sale_year = src.sale_year
                                               AND src.calc_date = v_rpt_day),
                                            0),
             sale_sum_4  = sale_sum_4 - nvl((SELECT sale_sum_4
                                              FROM calc_rst_3121 src
                                             WHERE dest.game_code = src.game_code
                                               AND dest.area_code = src.area_code
                                               AND dest.sale_year = src.sale_year
                                               AND src.calc_date = v_rpt_day),
                                            0),
             sale_sum_5  = sale_sum_5 - nvl((SELECT sale_sum_5
                                              FROM calc_rst_3121 src
                                             WHERE dest.game_code = src.game_code
                                               AND dest.area_code = src.area_code
                                               AND dest.sale_year = src.sale_year
                                               AND src.calc_date = v_rpt_day),
                                            0),
             sale_sum_6  = sale_sum_6 - nvl((SELECT sale_sum_6
                                              FROM calc_rst_3121 src
                                             WHERE dest.game_code = src.game_code
                                               AND dest.area_code = src.area_code
                                               AND dest.sale_year = src.sale_year
                                               AND src.calc_date = v_rpt_day),
                                            0),
             sale_sum_7  = sale_sum_7 - nvl((SELECT sale_sum_7
                                              FROM calc_rst_3121 src
                                             WHERE dest.game_code = src.game_code
                                               AND dest.area_code = src.area_code
                                               AND dest.sale_year = src.sale_year
                                               AND src.calc_date = v_rpt_day),
                                            0),
             sale_sum_8  = sale_sum_8 - nvl((SELECT sale_sum_8
                                              FROM calc_rst_3121 src
                                             WHERE dest.game_code = src.game_code
                                               AND dest.area_code = src.area_code
                                               AND dest.sale_year = src.sale_year
                                               AND src.calc_date = v_rpt_day),
                                            0),
             sale_sum_9  = sale_sum_9 - nvl((SELECT sale_sum_9
                                              FROM calc_rst_3121 src
                                             WHERE dest.game_code = src.game_code
                                               AND dest.area_code = src.area_code
                                               AND dest.sale_year = src.sale_year
                                               AND src.calc_date = v_rpt_day),
                                            0),
             sale_sum_10 = sale_sum_10 - nvl((SELECT sale_sum_10
                                               FROM calc_rst_3121 src
                                              WHERE dest.game_code = src.game_code
                                                AND dest.area_code = src.area_code
                                                AND dest.sale_year = src.sale_year
                                                AND src.calc_date = v_rpt_day),
                                             0),
             sale_sum_11 = sale_sum_11 - nvl((SELECT sale_sum_11
                                               FROM calc_rst_3121 src
                                              WHERE dest.game_code = src.game_code
                                                AND dest.area_code = src.area_code
                                                AND dest.sale_year = src.sale_year
                                                AND src.calc_date = v_rpt_day),
                                             0),
             sale_sum_12 = sale_sum_12 - nvl((SELECT sale_sum_12
                                               FROM calc_rst_3121 src
                                              WHERE dest.game_code = src.game_code
                                                AND dest.area_code = src.area_code
                                                AND dest.sale_year = src.sale_year
                                                AND src.calc_date = v_rpt_day),
                                             0)
       WHERE (game_code, area_code, sale_year) IN (SELECT game_code, area_code, sale_year
                                                     FROM calc_rst_3121
                                                    WHERE calc_date = v_rpt_day);
      DELETE FROM calc_rst_3121
       WHERE calc_date = v_rpt_day;
   END IF;

   select count(*) into v_cnt from tmp_rst_3121 where sale_sum > 0;
   dbms_output.put_line('tmp_rst_3121 count is  '||v_cnt);
   select count(*) into v_cnt from mis_report_3121 where sale_sum > 0;
   dbms_output.put_line('mis_report_3121 count is  '||v_cnt);

   MERGE INTO mis_report_3121 dest
   USING tmp_rst_3121 src
   ON (dest.game_code = src.game_code AND dest.area_code = src.area_code AND dest.sale_year = src.sale_year)
   WHEN MATCHED THEN
      UPDATE
         SET sale_sum    = dest.sale_sum + src.sale_sum,
             sale_sum_1  = dest.sale_sum_1 + src.sale_sum_1,
             sale_sum_2  = dest.sale_sum_2 + src.sale_sum_2,
             sale_sum_3  = dest.sale_sum_3 + src.sale_sum_3,
             sale_sum_4  = dest.sale_sum_4 + src.sale_sum_4,
             sale_sum_5  = dest.sale_sum_5 + src.sale_sum_5,
             sale_sum_6  = dest.sale_sum_6 + src.sale_sum_6,
             sale_sum_7  = dest.sale_sum_7 + src.sale_sum_7,
             sale_sum_8  = dest.sale_sum_8 + src.sale_sum_8,
             sale_sum_9  = dest.sale_sum_9 + src.sale_sum_9,
             sale_sum_10 = dest.sale_sum_10 + src.sale_sum_10,
             sale_sum_11 = dest.sale_sum_11 + src.sale_sum_11,
             sale_sum_12 = dest.sale_sum_12 + src.sale_sum_12
   WHEN NOT MATCHED THEN
      INSERT
         (game_code,
          area_code,
          sale_year,
          area_name,
          sale_sum,
          sale_sum_1,
          sale_sum_2,
          sale_sum_3,
          sale_sum_4,
          sale_sum_5,
          sale_sum_6,
          sale_sum_7,
          sale_sum_8,
          sale_sum_9,
          sale_sum_10,
          sale_sum_11,
          sale_sum_12)
      VALUES
         (src.game_code,
          src.area_code,
          src.sale_year,
          src.area_name,
          src.sale_sum,
          src.sale_sum_1,
          src.sale_sum_2,
          src.sale_sum_3,
          src.sale_sum_4,
          src.sale_sum_5,
          src.sale_sum_6,
          src.sale_sum_7,
          src.sale_sum_8,
          src.sale_sum_9,
          src.sale_sum_10,
          src.sale_sum_11,
          src.sale_sum_12);
   COMMIT;

   select count(*) into v_cnt from mis_report_3121 where sale_sum > 0;
   dbms_output.put_line('mis_report_3121 count is  '||v_cnt);

   INSERT INTO calc_rst_3121
      SELECT sale_year,
             game_code,
             area_code,
             area_name,
             sale_sum,
             sale_sum_1,
             sale_sum_2,
             sale_sum_3,
             sale_sum_4,
             sale_sum_5,
             sale_sum_6,
             sale_sum_7,
             sale_sum_8,
             sale_sum_9,
             sale_sum_10,
             sale_sum_11,
             sale_sum_12,
             v_rpt_day
        FROM tmp_rst_3121;
   COMMIT;

   -- 2.1.17.8 区域游戏期销售、退票与中奖表（MIS_REPORT_3122）
   SELECT COUNT(*)
     INTO v_exists
     FROM dual
    WHERE EXISTS (SELECT 1
             FROM calc_rst_3122
            WHERE calc_date = v_rpt_day);
   IF v_exists = 1 THEN
      UPDATE mis_report_3122 dest
         SET sale_sum   = sale_sum - nvl((SELECT sale_sum
                                           FROM calc_rst_3122
                                          WHERE calc_date = v_rpt_day
                                            AND dest.game_code = game_code
                                            AND dest.issue_number = issue_number
                                            AND dest.area_code = area_code),
                                         0),
             cancel_sum = cancel_sum - nvl((SELECT cancel_sum
                                             FROM calc_rst_3122
                                            WHERE calc_date = v_rpt_day
                                              AND dest.game_code = game_code
                                              AND dest.issue_number = issue_number
                                              AND dest.area_code = area_code),
                                           0),
             win_sum    = win_sum - nvl((SELECT win_sum
                                          FROM calc_rst_3122
                                         WHERE calc_date = v_rpt_day
                                           AND dest.game_code = game_code
                                           AND dest.issue_number = issue_number
                                           AND dest.area_code = area_code),
                                        0)
       WHERE (game_code, issue_number, area_code) IN (SELECT game_code, issue_number, area_code
                                                        FROM calc_rst_3122
                                                       WHERE calc_date = v_rpt_day);
      DELETE calc_rst_3122
       WHERE calc_date = v_rpt_day;
   END IF;
   MERGE INTO mis_report_3122 dest
   USING tmp_rst_3122 src
   ON (dest.game_code = src.game_code AND dest.issue_number = src.issue_number AND dest.area_code = src.area_code)
   WHEN MATCHED THEN
      UPDATE
         SET sale_sum = dest.sale_sum + src.sale_sum, cancel_sum = dest.cancel_sum + src.cancel_sum, win_sum = dest.win_sum + src.win_sum
   WHEN NOT MATCHED THEN
      INSERT
         (game_code, issue_number, area_code, area_name, sale_sum, cancel_sum, win_sum)
      VALUES
         (src.game_code, src.issue_number, src.area_code, src.area_name, src.sale_sum, src.cancel_sum, src.win_sum);
   COMMIT;
   INSERT INTO calc_rst_3122
      SELECT game_code, issue_number, area_code, area_name, sale_sum, cancel_sum, win_sum, v_rpt_day
        FROM tmp_rst_3122;
   COMMIT;

   -- 2.1.17.9 区域游戏兑奖统计日报表（MIS_REPORT_3123）
   DELETE FROM mis_report_3123
    WHERE pay_date = v_rpt_day;
   INSERT INTO mis_report_3123
      SELECT *
        FROM tmp_rst_3123;
   COMMIT;

   -- 2.1.17.10 高等奖兑奖统计表（MIS_REPORT_3124）
   DELETE FROM mis_report_3124
    WHERE pay_date = v_rpt_day;
   INSERT INTO mis_report_3124
      SELECT *
        FROM tmp_rst_3124;
   COMMIT;

   -- 2.1.17.11 区域游戏销售汇总表（MIS_REPORT_3125）
   DELETE FROM mis_report_3125
    WHERE sale_date = v_rpt_day;
   INSERT INTO mis_report_3125
      SELECT *
        FROM tmp_rst_3125;
   COMMIT;

   -- 当天销售情况发送
   select sum(SALE_SUM) into v_sale from tmp_rst_3111 where area_code=0;
   v_sale := nvl(v_sale,0);
   select sum(PAYMENT_SUM) into v_pay from tmp_rst_3123 where area_code=0;
   v_pay := nvl(v_pay,0);
   select sum(PURGED_AMOUNT) into v_aband from tmp_rst_3112;
   v_aband := nvl(v_aband,0);

END;
