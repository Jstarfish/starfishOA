CREATE OR REPLACE PROCEDURE p_om_issue_adjfund_modify
/*****************************************************************/
   ----------- 适用于oms调用手工调整调节资金 ---------------
   ----------- add by dzg 2014-07-16
   ----------- 支持三种模式：
   ----------- 拨出到奖池 4 out_issue_pool_manual （已经废弃，通过奖池调整功能来实现）
   ----------- 发行费拨入 5 in_commission
   ----------- 其他来源拨入 6、 in_other
   ----------- modify by dzg 2014.10.20 修改支持本地化
   /*****************************************************************/
(
 --------------输入----------------
 p_game_code  IN NUMBER, --游戏编码
 p_adj_amount IN NUMBER, --调整金额
 p_adj_type   IN NUMBER, --调整类型
 p_remark     IN STRING, --调整备注
 p_admin_id   IN NUMBER, --操作人员
 ---------出口参数---------
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述
 ) IS

   v_amount        NUMBER(28); -- 调整金额
   v_amount_before NUMBER(28); -- 调整前金额
   v_amount_after  NUMBER(28); -- 调整后金额
   v_adj_flow      CHAR(32); -- 当前调节流水
   --v_pool_flow     CHAR(32); -- 当前奖池流水
   v_curr_issue    NUMBER; -- 当期期次

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

   -- 按照类型确定数据金额是否为负值
   if p_adj_type in (eadj_change_type.out_issue_pool_manual) then
      v_amount := 0 - p_adj_amount;
   else
      v_amount := p_adj_amount;
   end if;

   --获取当前期次
   v_curr_issue := f_get_game_current_issue(p_game_code);

   -- 更新当前调节基金余额，同时获取调整之前和调整之后的金额
   UPDATE adj_game_current
      SET pool_amount_before = pool_amount_after,
          pool_amount_after  = pool_amount_after + p_adj_amount
    WHERE game_code = p_game_code
   returning pool_amount_before, pool_amount_after into v_amount_before, v_amount_after;

   -- 插入调整申请
   INSERT INTO adj_game_change
      (adj_flow,
       game_code,
       adj_amount,
       adj_amount_before,
       adj_amount_after,
       adj_change_type,
       adj_desc,
       adj_time,
       adj_admin)
   VALUES
      (f_get_game_flow_seq,
       p_game_code,
       p_adj_amount,
       v_amount_before,
       v_amount_after,
       p_adj_type,
       p_remark,
       sysdate,
       p_admin_id)
   RETURNING adj_flow INTO v_adj_flow;

   -- 3)插入流水
   INSERT INTO adj_game_his
      (his_code,
       game_code,
       issue_number,
       adj_change_type,
       adj_amount,
       adj_amount_before,
       adj_amount_after,
       adj_time,
       adj_reason,
       adj_flow)
   VALUES
      (f_get_game_his_code_seq,
       p_game_code,
       v_curr_issue,
       p_adj_type,
       p_adj_amount,
       v_amount_before,
       v_amount_after,
       sysdate,
       p_remark,
       v_adj_flow);

   /*-----------    更新数据    -----------------*/
   -- 根据不同的调节类型进行不同的处置
   CASE p_adj_type
      WHEN eadj_change_type.out_issue_pool_manual THEN

         -- 如果：拨出到奖池 4 out_issue_pool_manual，可以调用存储过程 p_om_add_pool 实现
         select 1 into v_amount from dual;

      WHEN eadj_change_type.in_commission THEN
         -- 如果：发行费拨入 5 in_commission
         -- 则减少发行费，减少流水
         -- 插入调节资金流水，更新总额
         -- 插入发行费流水
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
             v_curr_issue,
             ecomm_change_type.out_to_adj,
             p_adj_amount,
             (SELECT adj_amount_after
                FROM gov_commision
               WHERE game_code = p_game_code
                 AND his_code = (SELECT MAX(his_code)
                                   FROM gov_commision
                                  WHERE game_code = p_game_code)),
             (SELECT adj_amount_after
                FROM gov_commision
               WHERE game_code = p_game_code
                 AND his_code = (SELECT MAX(his_code)
                                   FROM gov_commision
                                  WHERE game_code = p_game_code)) -
             p_adj_amount,
             sysdate,
             p_remark);

   -- 其他来源拨入 6、 in_other
      WHEN eadj_change_type.in_other THEN
         -- 什么都不做
         select 1 into v_amount from dual;
   END CASE;
   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

END;
