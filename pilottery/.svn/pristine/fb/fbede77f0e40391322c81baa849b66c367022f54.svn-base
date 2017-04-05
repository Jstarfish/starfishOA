CREATE OR REPLACE PROCEDURE p_set_issue_error_info
/*****************************************************************/
  ----------- 设置开奖过程中错误信息（主机调用） ---------------
  ----- modify by dzg 2014-06-21 修改不区分具体错误代码，只要错误代码就是1
  ----- 所以也不用传入错误代码 和 错误原因
  /*****************************************************************/
(
  p_game_code            IN NUMBER, --游戏编码
  p_issue_number         IN NUMBER, --期次编码
  c_errorcode            OUT NUMBER, --业务错误编码
  c_errormesg            OUT STRING --错误信息描述
) IS
BEGIN

  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  --更新期次开奖过程错误编码和描述
  UPDATE iss_game_issue g
     SET g.rewarding_error_code = 1
   WHERE g.game_code = p_game_code
     AND g.issue_number = p_issue_number;

  IF SQL%NOTFOUND THEN
    c_errorcode := 1;
    c_errormesg := '更新期次开奖过程错误编码和描述失败'||sqlerrm;
    RETURN;
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);
END;
/
