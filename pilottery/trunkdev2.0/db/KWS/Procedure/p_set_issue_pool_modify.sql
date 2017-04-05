CREATE OR REPLACE PROCEDURE p_set_issue_pool_modify
/*****************************************************************/
   ----------- 设置游戏期次奖池金额（主机调用） ---------------
   ----------- 主机调用，变更方式——>期次变更,变更类型——>期次滚动
   /*****************************************************************/
(
 --------------输入----------------
 p_game_code    IN NUMBER, --游戏编码
 p_issue_number IN NUMBER, --期次编码
 p_pool_amount  IN NUMBER, --滚入的奖池金额
 p_adj_amount   IN NUMBER, --期次奖金抹零
 ---------出口参数---------
 c_errorcode OUT NUMBER,   --业务错误编码
 c_errormesg OUT STRING    --错误信息描述
 ) IS
   v_issue_sale_amount NUMBER(18); -- 期次销售金额

   v_adj_rate  NUMBER(10,6); -- 调节基金比率
   v_gov_rate  NUMBER(10,6); -- 公益金比率
   v_comm_rate NUMBER(10,6); -- 发行费比率

   v_adj_amount_before    NUMBER(28); -- 调整前金额（调节基金）
   v_adj_amount_after     NUMBER(28); -- 调整后金额（调节基金）
   v_pool_amount_before   NUMBER(28); -- 调整前金额（奖池）
   v_pool_amount_after    NUMBER(28); -- 调整后金额（奖池）

BEGIN
   --初始化数据
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   -- 检查输入参数
   IF p_pool_amount IS NULL THEN
      c_errorcode := 1;
      --c_errormesg := '输入参数【滚入的奖池金额】为空值，程序无法计算';
      c_errormesg := error_msg.MSG0064;
      RETURN;
   END IF;
   IF p_adj_amount IS NULL THEN
      c_errorcode := 1;
      --c_errormesg := '输入参数【期次奖金抹零】为空值，程序无法计算';
      c_errormesg := error_msg.MSG0065;
      RETURN;
   END IF;

   -- 获取各种比率
   BEGIN
      SELECT 1000 - theory_rate - fund_rate - adj_rate, fund_rate, adj_rate
        INTO v_comm_rate, v_gov_rate, v_adj_rate
        FROM gp_policy
       WHERE game_code = p_game_code
         AND his_policy_code =
             (SELECT his_policy_code
                FROM iss_current_param
               WHERE game_code = p_game_code
                 AND issue_number = p_issue_number);
   EXCEPTION
      WHEN no_data_found THEN
         c_errorcode := 1;
         --c_errormesg := '无法获取政策参数，程序无法计算。游戏：【' || p_game_code || '】期次：【' ||
         --              p_issue_number || '】';
         c_errormesg := error_msg.MSG0066 ||p_game_code||'-'||p_issue_number;
         RETURN;
   END;
   v_comm_rate := v_comm_rate / 1000;
   v_gov_rate  := v_gov_rate / 1000;
   v_adj_rate  := v_adj_rate / 1000;

   -- 获得期次销售金额
   SELECT issue_sale_amount
     INTO v_issue_sale_amount
     FROM iss_game_issue
    WHERE game_code = p_game_code
      AND issue_number = p_issue_number;
   IF v_issue_sale_amount IS NULL THEN
      c_errorcode := 1;
      --c_errormesg := '期次销售金额为空值，程序无法计算';
      c_errormesg := error_msg.MSG0067;
      RETURN;
   END IF;
   IF v_issue_sale_amount <= 0
      AND p_pool_amount > 0 THEN
      c_errorcode := 1;
      --c_errormesg := '期次销售金额为0，但是输入的奖池金额大于0，出现逻辑错误，程序无法计算';
      c_errormesg := error_msg.MSG0068;
      RETURN;
   END IF;

   -- 设置期初奖池金额
   UPDATE iss_game_issue
      SET pool_start_amount = (select pool_amount_after from iss_game_pool where game_code = p_game_code and pool_code = 0)
    WHERE game_code = p_game_code
      AND issue_number = p_issue_number;

   /*** 入调节基金、发行费、公益金流水 ***/
   INSERT INTO gov_commision -- 发行费
      (his_code,
       game_code,
       issue_number,
       comm_change_type,
       adj_amount,
       adj_amount_before,
       adj_amount_after,
       adj_time,
       adj_reason)
   VALUES
      (f_get_game_his_code_seq,
       p_game_code,
       p_issue_number,
       ecomm_change_type.in_from_issue_reward,
       v_issue_sale_amount * v_comm_rate,
       nvl((SELECT adj_amount_after
        FROM gov_commision
       WHERE game_code = p_game_code
         AND his_code = (SELECT MAX(his_code)
                           FROM gov_commision
                          WHERE game_code = p_game_code)),0),
       nvl((SELECT adj_amount_after
        FROM gov_commision
       WHERE game_code = p_game_code
         AND his_code = (SELECT MAX(his_code)
                           FROM gov_commision
                          WHERE game_code = p_game_code)),0) + v_issue_sale_amount * v_comm_rate,
       SYSDATE,
       '');

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
       p_issue_number,
       ecwfund_change_type.in_from_issue_reward,
       v_issue_sale_amount * v_gov_rate,
       nvl((SELECT adj_amount_after
        FROM commonweal_fund
       WHERE game_code = p_game_code
         AND his_code = (SELECT MAX(his_code)
                           FROM commonweal_fund
                          WHERE game_code = p_game_code)),0),
       nvl((SELECT adj_amount_after
        FROM commonweal_fund
       WHERE game_code = p_game_code
         AND his_code = (SELECT MAX(his_code)
                           FROM commonweal_fund
                          WHERE game_code = p_game_code)),0) + v_issue_sale_amount * v_gov_rate,
       SYSDATE,
       '');

   -- 更新调节基金当前信息，同时获得调整之前和之后的余额
   UPDATE adj_game_current
      SET pool_amount_before = pool_amount_after,
          pool_amount_after = pool_amount_after + v_issue_sale_amount * v_adj_rate
    WHERE game_code = p_game_code
          returning pool_amount_before, pool_amount_after
               into v_adj_amount_before, v_adj_amount_after;

   INSERT INTO adj_game_his -- 调节基金(期次开奖滚入)
      (his_code,
       game_code,
       issue_number,
       adj_change_type,
       adj_amount,
       adj_amount_before,
       adj_amount_after,
       adj_time)
   VALUES
      (f_get_game_his_code_seq,
       p_game_code,
       p_issue_number,
       eadj_change_type.in_issue_reward,
       v_issue_sale_amount * v_adj_rate,
       v_adj_amount_before,
       v_adj_amount_after,
       SYSDATE);

   -- 期次奖金抹零进入调节基金
   IF p_adj_amount > 0 THEN
      -- 更新调节基金当前信息，同时获得调整之前和之后的余额
      UPDATE adj_game_current
         SET pool_amount_before = pool_amount_after,
             pool_amount_after = pool_amount_after + p_adj_amount
       WHERE game_code = p_game_code
             returning pool_amount_before, pool_amount_after
                  into v_adj_amount_before, v_adj_amount_after;

      INSERT INTO adj_game_his -- 调节基金(期次奖金抹零滚入)
         (his_code,
          game_code,
          issue_number,
          adj_change_type,
          adj_amount,
          adj_amount_before,
          adj_amount_after,
          adj_time)
      VALUES
         (f_get_game_his_code_seq,
          p_game_code,
          p_issue_number,
          eadj_change_type.in_issue_trunc_winning,
          p_adj_amount,
          v_adj_amount_before,
          v_adj_amount_after,
          SYSDATE);

   END IF;

   -- 更新奖池余额，同时获得调整之前和之后的奖池余额
   UPDATE iss_game_pool
      SET pool_amount_before = pool_amount_after,
          pool_amount_after = pool_amount_after + p_pool_amount,
          adj_time = SYSDATE
    WHERE game_code = p_game_code
      AND pool_code = 0
returning pool_amount_before, pool_amount_after
     into v_pool_amount_before, v_pool_amount_after;

   -- 如果调整之后，奖池为负值，那么需要调节基金不足
   /**为负数（指的是，主机在经过计算以后，奖池已经被掏空），
      需要使用调节基金的余额补齐，如果调节基金不够，再用发行费补齐，发行费不够，设置调节基金余额为负值，发行费为0；
      然后再设置当前奖池金额为0。*/
   IF v_pool_amount_after < 0 THEN
      --调节基金够补充完毕奖池亏空
      -- 更新调节基金当前信息，同时获得调整之前和之后的余额
      UPDATE adj_game_current
         SET pool_amount_before = pool_amount_after,
             pool_amount_after = pool_amount_after + v_pool_amount_after         -- 奖池的负数，通过调节基金补足
       WHERE game_code = p_game_code
             returning pool_amount_before, pool_amount_after
                  into v_adj_amount_before, v_adj_amount_after;

      INSERT INTO adj_game_his -- 调节基金(填补奖池)
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
          p_issue_number,
          eadj_change_type.out_issue_pool,
          v_pool_amount_after,
          v_adj_amount_before,
          v_adj_amount_after,
          SYSDATE,
          --'期次奖池不足，调节基金补充'
          error_msg.MSG0069
          );

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
          adj_reason,
          pool_flow)
      VALUES
         (f_get_game_his_code_seq,
          p_game_code,
          p_issue_number,
          0,
          0 - v_pool_amount_after,        -- 变化金额就是那个负数，这里写绝对值
          v_pool_amount_after,            -- 变化前奖池余额是负数，变化后，应该是0
          0,
          SYSDATE,
          epool_change_type.in_issue_pool_auto,
          --'期次奖池不足，调节基金补充'
          error_msg.MSG0069,
          NULL);

      -- 更新奖池余额，设置期末余额为0（这是因为奖池期末余额不能为【负值】）
      UPDATE iss_game_pool
         SET pool_amount_after = 0
       WHERE game_code = p_game_code
         AND pool_code = 0;
      v_pool_amount_after := 0;

   end if;

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
       adj_reason,
       pool_flow)
   VALUES
      (f_get_game_his_code_seq,
       p_game_code,
       p_issue_number,
       0,
       p_pool_amount,
       v_pool_amount_before,
       v_pool_amount_after,
       SYSDATE,
       epool_change_type.in_issue_reward,
       --'期次开奖滚入',
       error_msg.MSG0070,
       NULL);

   -- 更新期次统计数据
   UPDATE iss_game_issue
      SET pool_close_amount = v_pool_amount_after
    WHERE game_code = p_game_code
      AND issue_number = p_issue_number;

   COMMIT;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);
END;
