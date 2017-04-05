CREATE OR REPLACE PROCEDURE p_set_issue_winning_stat
(
  p_game_code                  IN NUMBER,   --游戏id
  p_issue_number               IN NUMBER,   --期次编码
  p_total_winning_ticket_count IN NUMBER,   --总共中奖票数
  p_total_winning_amount       IN NUMBER,   --总共中奖金额
  p_total_winning_bet_count    IN NUMBER,   --总共中奖注数
  p_big_winning_ticket_count   IN NUMBER,   --大奖中奖票数
  p_big_winning_amount         IN NUMBER,   --大奖中奖金额

  ---------出口参数---------
  c_errorcode                  OUT NUMBER,  --业务错误编码
  c_errormesg                  OUT STRING   --错误信息描述
) IS
BEGIN

  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  --更新期次中奖统计信息
  UPDATE iss_game_issue g
     SET g.winning_amount = p_total_winning_amount,
         g.winning_bets = p_total_winning_bet_count,
         g.winning_tickets = p_total_winning_ticket_count,
         g.winning_amount_big = p_big_winning_amount,
         g.winning_tickets_big = p_big_winning_ticket_count
   WHERE g.game_code = p_game_code
     AND g.issue_number = p_issue_number;

  IF SQL%NOTFOUND THEN
    c_errorcode := 1;
    c_errormesg := '更新期次中奖统计信息失败'||sqlerrm;
    RETURN;
  END IF;

  commit;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);
  
END;
/
