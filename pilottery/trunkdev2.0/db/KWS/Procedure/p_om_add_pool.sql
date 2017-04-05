CREATE OR REPLACE PROCEDURE p_om_add_pool
/****************************************************************/
   ------------------- 适用于向奖池中加钱，手工的 -------------------
   ---- NEW by 陈震 2014.7.7
   ---  modify by dzg 2014.10.20 本地化
   ---  modify by dzg 2014.12.08 修改到和adjfund提示一致验证为0不让提交
   ---  modify by 陈震 2015.4.10 BUG。修复 【调节基金入奖池时，调节基金表中写入正值，导致金额变化和期初期末不符】
   /*************************************************************/
(
 --------------输入----------------
 p_game_code  IN NUMBER, --游戏编码
 p_adj_type   IN NUMBER, --变更类型
 p_adj_amount IN NUMBER, --变更金额
 p_adj_desc   IN VARCHAR2, --变更备注
 p_adj_admin  IN NUMBER, --变更人员
 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING, --错误原因
 c_add_now   OUT NUMBER  --作为返回参数表示“是否立即增加”
 ) IS
   v_issue_current NUMBER(12);   -- 当前期
   v_issue_status  NUMBER(2);    -- 期次状态
   v_has_curr_issue BOOLEAN;      -- 是否存在当前期(true表示有当前期)

   v_amount_before NUMBER(18);   -- 更改前奖池余额
   v_amount_after  NUMBER(18);   -- 更改后奖池余额
   v_pool_flow     CHAR(32);     -- 变更流水号

BEGIN

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   -- 检查输入参数
   IF p_adj_amount IS NULL THEN
      c_errorcode := 1;
      --c_errormesg := '输入参数【调整金额】为空值，程序无法计算';
      c_errormesg := error_msg.MSG0025;
      RETURN;
   END IF;
   IF p_adj_amount = 0 THEN
      c_errorcode := 1;
      --c_errormesg := '调整金额为0没有必要计算';
      c_errormesg := error_msg.MSG0026;
      RETURN;
   END IF;

   /*----------- 检查调整类型   -----------------*/
   -- 针对 “调节基金手动拨入奖池”、“发行费手动拨入奖池”和“其他进入奖池”的方式
   IF p_adj_type NOT IN (epool_change_type.in_issue_pool_manual,
                         epool_change_type.in_commission,
                         epool_change_type.in_other) THEN
      c_errorcode := 1;
      --c_errormesg := '未知的奖池调整类型【' || p_adj_type || '】';
      c_errormesg := error_msg.MSG0002;
      RETURN;
   END IF;

   /*----------- 获得游戏当前期状态   -----------------*/
   v_issue_current := f_get_game_current_issue(p_game_code);
   v_has_curr_issue := true;
   begin
      SELECT issue_status
        INTO v_issue_status
        FROM iss_game_issue
       WHERE game_code = p_game_code
         AND real_start_time IS NOT NULL
         AND real_close_time IS NULL;
   exception
      when no_data_found then
         -- 无当前期
         v_has_curr_issue := false;
   end;

   /*----------- 期状态为（6=开奖号码已录入；7=销售已经匹配；8=已录入奖级奖金；9=本地算奖完成；10=奖级已确认；11=开奖确认；12=中奖数据已录入数据库；）状态时，不能立即生效，只保存   -----------------*/
   IF v_issue_status IN
      (egame_issue_status.enteringdrawcodes,
       egame_issue_status.drawcodesmatchingcompleted,
       egame_issue_status.prizepoolentered,
       egame_issue_status.localprizecalculationdone,
       egame_issue_status.prizeleveladjustmentdone,
       egame_issue_status.prizeleveladjustmentconfirmed,
       egame_issue_status.issuedatastoragecompleted) and v_has_curr_issue THEN
      INSERT INTO iss_game_pool_adj
         (pool_flow,
          game_code,
          pool_code,
          pool_adj_type,
          adj_amount,
          pool_amount_before,
          pool_amount_after,
          adj_desc,
          adj_time,
          adj_admin,
          is_adj)
      VALUES
         (f_get_game_flow_seq,
          p_game_code,
          0,
          p_adj_type,
          p_adj_amount,
          NULL,
          NULL,
          p_adj_desc,
          SYSDATE,
          p_adj_admin,
          eboolean.noordisabled);

      c_add_now := 0;
   ELSE
      -- 更新奖池余额，同时获得调整之前和之后的奖池余额
      UPDATE iss_game_pool
         SET pool_amount_before = pool_amount_after,
             pool_amount_after = pool_amount_after + p_adj_amount,
             adj_time = SYSDATE
       WHERE game_code = p_game_code
         AND pool_code = 0
   returning pool_amount_before, pool_amount_after
        into v_amount_before, v_amount_after;

      /*----------- 期状态为（1=预售；2=游戏期开始；3=期即将关闭；4=游戏期关闭；5=数据封存完毕；13=期结全部完成）状态时，可以立即生效   -----------------*/
      INSERT INTO iss_game_pool_adj
         (pool_flow,
          game_code,
          pool_code,
          pool_adj_type,
          adj_amount,
          pool_amount_before,
          pool_amount_after,
          adj_desc,
          adj_time,
          adj_admin,
          is_adj)
      VALUES
         (f_get_game_flow_seq,
          p_game_code,
          0,
          p_adj_type,
          p_adj_amount,
          v_amount_before,
          v_amount_after,
          p_adj_desc,
          SYSDATE,
          p_adj_admin,
          eboolean.yesorenabled)
      RETURNING pool_flow INTO v_pool_flow;

      -- 加奖池流水
      INSERT INTO iss_game_pool_his
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
          v_issue_current,
          0,
          p_adj_amount,
          v_amount_before,
          v_amount_after,
          SYSDATE,
          p_adj_type,
          p_adj_desc,
          v_pool_flow);

      /*----------- 针对变更类型做后续的事情（都是减钱的买卖） -----------------*/
      CASE p_adj_type
         WHEN epool_change_type.in_issue_pool_manual THEN
            -- 修改余额，同时获得调整之前余额和调整之后余额
            UPDATE adj_game_current
               SET pool_amount_before = pool_amount_after,
                   pool_amount_after = pool_amount_after - p_adj_amount
             WHERE game_code = p_game_code
         returning pool_amount_before, pool_amount_after
              into v_amount_before, v_amount_after;

            -- 类型为 4、调节基金手动拨入
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
                v_issue_current,
                eadj_change_type.out_issue_pool_manual,
                0 - p_adj_amount,                                -- 调节基金拨入奖池，对于调节基金来说是 减少，因此需要写入负值
                v_amount_before,
                v_amount_after,
                SYSDATE,
                p_adj_desc);

         WHEN epool_change_type.in_commission THEN
            -- 类型为 5、发行费手动拨入
            INSERT INTO gov_commision
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
                v_issue_current,
                ecomm_change_type.out_to_pool,
                0 - p_adj_amount,                                  -- 发行费入奖池，对于发行费来说是 减少，因此应该为负值
                nvl((SELECT adj_amount_after
                      FROM gov_commision
                     WHERE game_code = p_game_code
                       AND his_code =
                           (SELECT MAX(his_code)
                              FROM gov_commision
                             WHERE game_code = p_game_code)),
                    0),
                nvl((SELECT adj_amount_after
                      FROM gov_commision
                     WHERE game_code = p_game_code
                       AND his_code =
                           (SELECT MAX(his_code)
                              FROM gov_commision
                             WHERE game_code = p_game_code)),
                    0) - p_adj_amount,
                SYSDATE,
                p_adj_desc);
         WHEN epool_change_type.in_other THEN
            -- 什么都不做
            select 1 into v_amount_before from dual;

         ELSE
            ROLLBACK;
            c_errorcode := 1;
            --c_errormesg := '未知的奖池调整类型【' || p_adj_type || '】';
            c_errormesg := error_msg.MSG0002;
      END CASE;
      c_add_now := 1;
   END IF;

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      c_errorcode := 1;
      c_errormesg := error_msg.MSG0004 || SQLERRM;

END;
