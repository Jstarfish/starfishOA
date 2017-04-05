CREATE OR REPLACE PROCEDURE p_mis_dss_30_gen_multi_issue IS
   v_issue_count NUMBER(10); -- 多期票的总期数
   v_loop        NUMBER(10); -- 循环中的期次变量
   v_issue       NUMBER(10); -- 计算获得的期次编号
   v_issue_seq   NUMBER(10); -- 期次序号

   v_sell his_sellticket%ROWTYPE; -- 销售期次的内容

BEGIN
  
  -- 计算获得的结果为 单期票+多期拆分为单期记录
  -- 在每个日结区间产生的销售、退票和兑奖记录中，找出多期票的部分进行拆分，获得同单期票一样的结果，然后再拼接上单期票，形成待统计数据
   /********************      销售票      *********************/
   -- 买票的多期
   FOR table_sell IN (SELECT *
                        FROM tmp_src_sell
                       WHERE issue_count > 1) LOOP
      v_issue_count := table_sell.issue_count;

      -- 获取多期票
      SELECT issue_seq
        INTO v_issue_seq
        FROM tmp_all_issue
       WHERE game_code = table_sell.game_code
         AND issue_number = table_sell.issue_number;

      FOR v_loop IN 1 .. v_issue_count LOOP
         -- 计算期次编号

         SELECT issue_number
           INTO v_issue
           FROM tmp_all_issue
          WHERE game_code = table_sell.game_code
            AND issue_seq = v_issue_seq + v_loop - 1;

         -- 插入
         INSERT INTO tmp_multi_sell
            (applyflow_sell,
             saletime,
             terminal_code,
             teller_code,
             agency_code,
             game_code,
             issue_number,
             ticket_amount,
             ticket_bet_count,
             salecommissionrate,
             commissionamount,
             bet_methold,
             bet_line,
             loyalty_code,
             result_code)
         VALUES
            (table_sell.applyflow_sell,
             table_sell.saletime,
             table_sell.terminal_code,
             table_sell.teller_code,
             table_sell.agency_code,
             table_sell.game_code,
             v_issue,
             table_sell.ticket_amount / v_issue_count,
             table_sell.ticket_bet_count / v_issue_count,
             table_sell.salecommissionrate,
             table_sell.commissionamount / v_issue_count,
             table_sell.bet_methold,
             table_sell.bet_line,
             table_sell.loyalty_code,
             table_sell.result_code);

      END LOOP;
   END LOOP;

   -- 算完多期，再合并上单期票，全活
   INSERT INTO tmp_multi_sell
      (applyflow_sell,
       saletime,
       terminal_code,
       teller_code,
       agency_code,
       game_code,
       issue_number,
       ticket_amount,
       ticket_bet_count,
       salecommissionrate,
       commissionamount,
       bet_methold,
       bet_line,
       loyalty_code,
       result_code)
      SELECT applyflow_sell,
             saletime,
             terminal_code,
             teller_code,
             agency_code,
             game_code,
             issue_number,
             ticket_amount,
             ticket_bet_count,
             salecommissionrate,
             commissionamount,
             bet_methold,
             bet_line,
             loyalty_code,
             result_code
        FROM tmp_src_sell
       WHERE issue_count = 1;

   /********************      兑奖票      *********************/
   -- 多期票兑奖，兑奖期、销售期、票面期次这些应该怎么办？？ 跨天多期怎么办？（规则上没有跨天多期）
   -- 兑奖多期
/*   FOR table_pay IN (SELECT *
                       FROM tmp_src_pay
                      WHERE applyflow_sell IN (SELECT applyflow_sell
                                                 FROM his_sellticket_multi_issue)) LOOP
      -- 获取中奖期次的信息
      for table_win in (
                        SELECT ISSUE_NUMBER,
                               sum(WINNINGAMOUNTTAX) WINNINGAMOUNTTAX,
                               sum(WINNINGAMOUNT) WINNINGAMOUNT,
                               sum(TAXAMOUNT) TAXAMOUNT,
                               sum(PRIZE_COUNT) PRIZE_COUNT,
                               max(IS_HD_PRIZE) IS_HD_PRIZE
                          FROM HIS_WIN_TICKET_DETAIL
                         WHERE applyflow_sell = table_pay.applyflow_sell
                         group by ISSUE_NUMBER) loop

         INSERT INTO tmp_multi_pay
            (applyflow_pay,
             applyflow_sell,
             game_code,
             pay_issue_number,
             terminal_code,
             teller_code,
             agency_code,
             org_code,
             is_center,
             paytime,
             paycommissionrate,
             -- 某一个中奖期次
             issue_number,
             winningamounttax,
             winningamount,
             taxamount,
             commissionamount,
             winningcount,
             hd_winning,
             hd_count,
             ld_winning,
             ld_count,
             loyalty_code,
             is_big_prize)
         VALUES
            (table_pay.applyflow_pay,
             table_pay.applyflow_sell,
             table_pay.game_code,
             table_pay.issue_number,          -- 兑奖期次
             table_pay.terminal_code,         -- 兑奖的
             table_pay.teller_code,           -- 兑奖的
             table_pay.agency_code,           -- 兑奖的
             table_pay.org_code,              -- 兑奖的
             table_pay.is_center,
             table_pay.paytime,
             table_pay.paycommissionrate,
             -- 某一个中奖期次
             table_win.issue_number,
             table_win.winningamounttax,
             table_win.winningamount,
             table_win.taxamount,
             table_pay.paycommissionrate * table_win.winningamounttax / 1000,
             table_win.PRIZE_COUNT,
             (case when table_win.IS_HD_PRIZE = 1 then table_win.winningamounttax else 0 end),
             (case when table_win.IS_HD_PRIZE = 1 then table_win.PRIZE_COUNT else 0 end),
             (case when table_win.IS_HD_PRIZE = 0 then table_win.winningamounttax else 0 end),
             (case when table_win.IS_HD_PRIZE = 0 then table_win.PRIZE_COUNT else 0 end),
             table_pay.loyalty_code,
             table_pay.is_big_prize);

      END LOOP;
   END LOOP;
*/
   -- 拼上单期票
   INSERT INTO tmp_multi_pay
      (applyflow_pay,
       applyflow_sell,
       game_code,
       issue_number,
       pay_issue_number,
       terminal_code,
       teller_code,
       agency_code,
       org_code,
       is_center,
       paytime,
       winningamounttax,
       winningamount,
       taxamount,
       paycommissionrate,
       commissionamount,
       winningcount,
       hd_winning,
       hd_count,
       ld_winning,
       ld_count,
       loyalty_code,
       is_big_prize)
      SELECT applyflow_pay,
             applyflow_sell,
             game_code,
             issue_number,
             pay_issue_number,
             terminal_code,
             teller_code,
             agency_code,
             org_code,
             is_center,
             paytime,
             winningamounttax,
             winningamount,
             taxamount,
             paycommissionrate,
             commissionamount,
             winningcount,
             hd_winning,
             hd_count,
             ld_winning,
             ld_count,
             loyalty_code,
             is_big_prize
        FROM tmp_src_pay
       WHERE applyflow_sell NOT IN (SELECT applyflow_sell
                                      FROM his_sellticket_multi_issue);

   /********************      取消票      *********************/
   -- 退票多期
   FOR table_cancel IN (SELECT *
                          FROM tmp_src_cancel
                         WHERE applyflow_sell IN (SELECT applyflow_sell
                                                    FROM his_sellticket_multi_issue)) LOOP
      -- 获取销售期的信息
      SELECT *
        INTO v_sell
        FROM his_sellticket
       WHERE applyflow_sell = table_cancel.applyflow_sell;
      FOR v_loop IN 1 .. v_sell.issue_count LOOP
         -- 计算期次编号
         SELECT issue_seq
           INTO v_issue_seq
           FROM tmp_all_issue
          WHERE game_code = v_sell.game_code
            AND issue_number = v_sell.issue_number;
         SELECT issue_number
           INTO v_issue
           FROM tmp_all_issue
          WHERE game_code = v_sell.game_code
            AND issue_seq = v_issue_seq + v_loop - 1;

         INSERT INTO tmp_multi_cancel
            (applyflow_cancel,
             canceltime,
             applyflow_sell,
             c_terminal_code,
             c_teller_code,
             c_agency_code,
             c_org_code,
             is_center,
             saletime,
             terminal_code,
             teller_code,
             agency_code,
             game_code,
             issue_number,
             ticket_amount,
             ticket_bet_count,
             salecommissionrate,
             commissionamount,
             bet_methold,
             bet_line,
             loyalty_code)
         VALUES
            (table_cancel.applyflow_cancel,
             table_cancel.canceltime,
             table_cancel.applyflow_sell,
             table_cancel.c_terminal_code,
             table_cancel.c_teller_code,
             table_cancel.c_agency_code,
             table_cancel.c_org_code,
             table_cancel.is_center,
             table_cancel.saletime,
             table_cancel.terminal_code,
             table_cancel.teller_code,
             table_cancel.agency_code,
             table_cancel.game_code,
             v_issue,
             table_cancel.ticket_amount / v_issue_count,
             table_cancel.ticket_bet_count / v_issue_count,
             table_cancel.salecommissionrate,
             table_cancel.commissionamount / v_issue_count,
             table_cancel.bet_methold,
             table_cancel.bet_line,
             table_cancel.loyalty_code);

      END LOOP;
   END LOOP;
   COMMIT;

   -- 拼单期
   INSERT INTO tmp_multi_cancel
      (applyflow_cancel,
       canceltime,
       applyflow_sell,
       c_terminal_code,
       c_teller_code,
       c_agency_code,
       c_org_code,
       is_center,
       saletime,
       terminal_code,
       teller_code,
       agency_code,
       game_code,
       issue_number,
       ticket_amount,
       ticket_bet_count,
       salecommissionrate,
       commissionamount,
       bet_methold,
       bet_line,
       loyalty_code)
      SELECT applyflow_cancel,
             canceltime,
             applyflow_sell,
             c_terminal_code,
             c_teller_code,
             c_agency_code,
             c_org_code,
             is_center,
             saletime,
             terminal_code,
             teller_code,
             agency_code,
             game_code,
             issue_number,
             ticket_amount,
             ticket_bet_count,
             salecommissionrate,
             commissionamount,
             bet_methold,
             bet_line,
             loyalty_code
        FROM tmp_src_cancel
       WHERE applyflow_sell NOT IN (SELECT applyflow_sell
                                      FROM his_sellticket_multi_issue);

  commit;
END;
