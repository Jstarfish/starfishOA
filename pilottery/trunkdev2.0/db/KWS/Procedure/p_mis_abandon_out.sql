CREATE OR REPLACE PROCEDURE p_mis_abandon_out
/*****************************************************************/
   ----------- 弃奖金额处理（MIS调用） ---------------
   ----------- modify by dzg 本地化修改78行
   /*****************************************************************/
(
 --------------输入----------------
 p_game_code      IN NUMBER, --游戏编码
 p_issue_number   IN NUMBER, --期次编码
 p_abandon_amount IN NUMBER --弃奖金额
 ) IS
   v_game_param NUMBER(1); -- 游戏参数

   v_before_amount NUMBER(18); -- 调整之前金额
   v_after_amount  NUMBER(18); -- 调整之后金额
   v_curr_issue    NUMBER(18); -- 当前期次

BEGIN
   -- 获取游戏参数
   SELECT abandon_reward_collect
     INTO v_game_param
     FROM gp_static
    WHERE game_code = p_game_code;

   -- 获取此游戏的最近未开奖的游戏期次。如果没有合适的记录，那么获取最后一个开奖期次的下一个有效期次序号。
   -- 因为弃奖必须隶属于一个游戏期次，用来生成 奖金动态分配表，给钱一个归处。
   -- 这个最近的游戏期次，就是最后一次开奖的那个游戏期次的下一个。同时这个“下一个”还不能是一个游戏状态为 “预排 prearrangement ”的期次，因为这个期次随时可能被删掉，重新来过。
   begin
      SELECT min(issue_number)
        INTO v_curr_issue
        FROM iss_game_issue
       WHERE game_code = p_game_code
         AND REAL_REWARD_TIME IS NULL
         and issue_status <> egame_issue_status.prearrangement;
      if v_curr_issue is null then
         SELECT max(issue_seq)
           INTO v_curr_issue
           FROM iss_game_issue
          WHERE game_code = p_game_code
            AND REAL_REWARD_TIME IS NOT NULL
            and issue_status <> egame_issue_status.prearrangement;

         begin
            select issue_number
              into v_curr_issue
              from iss_game_issue
             where game_code = p_game_code
               and issue_seq = v_curr_issue + 1
               and issue_status <> egame_issue_status.prearrangement;
         exception
            when no_data_found then
               v_curr_issue := 0 - (v_curr_issue + 1);
         end;
      end if;
   end;

   CASE v_game_param
   /* 进入调节基金 */
      WHEN eabandon_reward_collect.adj THEN
         -- 首先更新余额，获得之前和之后的金额；然后再入历史表
         UPDATE adj_game_current
            SET pool_amount_before = pool_amount_after,
                pool_amount_after  = pool_amount_after + p_abandon_amount
          WHERE game_code = p_game_code
         RETURNING pool_amount_before, pool_amount_after INTO v_before_amount, v_after_amount;

         -- 插入历史表
         INSERT INTO adj_game_his
            (his_code,
             game_code,
             issue_number,
             adj_change_type,
             adj_amount,
             adj_amount_before,
             adj_amount_after,
             adj_time,
             adj_reason)
         VALUES
            (f_get_game_his_code_seq,
             p_game_code,
             v_curr_issue,
             eadj_change_type.in_issue_abandon,
             p_abandon_amount,
             v_before_amount,
             v_after_amount,
             SYSDATE,
             error_msg.MSG0001 || ', Original ISSUE NUMBER is [' ||
             p_issue_number || ']');

   /* 进入奖池 */
      WHEN eabandon_reward_collect.pool THEN
         -- 首先更新余额，获得之前和之后的金额；然后再入历史表
         UPDATE iss_game_pool
            SET pool_amount_before = pool_amount_after,
                pool_amount_after  = pool_amount_after + p_abandon_amount,
                adj_time           = SYSDATE
          WHERE game_code = p_game_code
            AND pool_code = 0
         RETURNING pool_amount_before, pool_amount_after INTO v_before_amount, v_after_amount;

         -- 插入历史记录
         INSERT INTO iss_game_pool_his -- 奖池（期次开奖滚入）
            (his_code,
             game_code,
             issue_number,
             pool_code,
             change_amount,
             pool_amount_before,
             pool_amount_after,
             adj_time,
             pool_adj_type,
             adj_reason)
         VALUES
            (f_get_game_his_code_seq,
             p_game_code,
             v_curr_issue,
             0,
             p_abandon_amount,
             v_before_amount,
             v_after_amount,
             SYSDATE,
             epool_change_type.in_issue_abandon,
             error_msg.MSG0001 || ', Original ISSUE NUMBER is [' ||
             p_issue_number || ']');

   /* 进入公益金 */
      WHEN eabandon_reward_collect.fund THEN
         -- 插入记录
         INSERT INTO commonweal_fund -- 公益金
            (his_code,
             game_code,
             issue_number,
             cwfund_change_type,
             adj_amount,
             adj_amount_before,
             adj_amount_after,
             adj_time,
             adj_reason)
         VALUES
            (f_get_game_his_code_seq,
             p_game_code,
             v_curr_issue,
             ecwfund_change_type.in_from_abandon,
             p_abandon_amount,
             (SELECT adj_amount_after
                FROM commonweal_fund
               WHERE game_code = p_game_code
                 AND his_code = (SELECT MAX(his_code)
                                   FROM commonweal_fund
                                  WHERE game_code = p_game_code)),
             (SELECT adj_amount_after
                FROM commonweal_fund
               WHERE game_code = p_game_code
                 AND his_code = (SELECT MAX(his_code)
                                   FROM commonweal_fund
                                  WHERE game_code = p_game_code)) +
             p_abandon_amount,
             SYSDATE,
             error_msg.MSG0001 || ', Original ISSUE NUMBER is [' ||
             p_issue_number || ']');

   END CASE;
END;
