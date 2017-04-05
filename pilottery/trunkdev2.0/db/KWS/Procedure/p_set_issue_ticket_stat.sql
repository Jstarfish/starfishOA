CREATE OR REPLACE PROCEDURE p_set_issue_ticket_stat
/****************************************************************/
------------------- 适用于设置游戏期次统计数值 -------------------
/*************************************************************/
(
 --------------输入----------------
 p_game_code                 IN NUMBER, --游戏编码
 p_issue_number              IN NUMBER, --期次编码
 p_total_sale_amount         IN NUMBER, --总共销售金额
 p_total_sale_ticket_count   IN NUMBER, --总共销售票数
 p_total_sale_bet_count      IN NUMBER, --总共销售注数
 p_total_cancel_amount       IN NUMBER, --总共取消金额
 p_total_cancel_ticket_count IN NUMBER, --总共取消票数
 p_total_cancel_bet_count    IN NUMBER, --总共取消注数

 ---------出口参数---------
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述
 ) IS
   -- 同步数据
   v_param VARCHAR2(200);
   v_ip    VARCHAR2(200);
   v_user  VARCHAR2(200);
   v_pass  VARCHAR2(200);
   v_url   VARCHAR2(200);
   v_c_errorcode NUMBER(10);
   v_c_errormesg VARCHAR2(1000);

BEGIN

  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  --更新期次票数统计
  UPDATE iss_game_issue
     SET issue_sale_amount = p_total_sale_amount,
         issue_sale_tickets = p_total_sale_ticket_count,
         issue_sale_bets = p_total_sale_bet_count,
         issue_cancel_amount = p_total_cancel_amount,
         issue_cancel_tickets = p_total_cancel_ticket_count,
         issue_cancel_bets = p_total_cancel_bet_count
   WHERE game_code = p_game_code
     AND issue_number = p_issue_number;

  IF SQL%NOTFOUND THEN
    c_errorcode := 1;
    c_errormesg := '更新期次票数统计失败';
    RETURN;
  END IF;
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

END;
/
