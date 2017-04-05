CREATE OR REPLACE PROCEDURE p_set_issue_risk_stat
/******************************************************************************/
------------------- 适用于设置游戏期次风险控制相关统计数值 -------------------
/******************************************************************************/
(
 --------------输入----------------
 p_game_code                  IN NUMBER, --游戏编码
 p_issue_number               IN NUMBER, --期次编码
 p_risk_amount                IN NUMBER, --总共被拒绝金额
 p_risk_ticket_count          IN NUMBER, --总共被拒绝票数
 
 ---------出口参数---------
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述
 ) IS
BEGIN

  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  --更新期次票数统计
  UPDATE iss_game_issue
     SET ISSUE_RICK_AMOUNT = p_risk_amount,
         ISSUE_RICK_TICKETS = p_risk_ticket_count
   WHERE game_code = p_game_code
     AND issue_number = p_issue_number;

  IF SQL%NOTFOUND THEN
    c_errorcode := 1;
    c_errormesg := '期次风险控制相关统计数值失败';
    RETURN;
  END IF;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);
  
END;
