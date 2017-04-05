CREATE OR REPLACE PROCEDURE p_set_issue_pool_get
/*****************************************************************/
   ----------- 获得游戏的奖池名称和余额（主机调用） ---------------
   /*****************************************************************/
(
   p_game_code   IN NUMBER, --游戏编码
   c_errorcode   OUT NUMBER, --业务错误编码
   c_errormesg   OUT STRING, --错误信息描述
   c_pool_name   OUT STRING, --奖池名称
   c_pool_amount OUT NUMBER --奖池金额
) IS

BEGIN
   --初始化数据
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   SELECT pool_name,
          nvl(pool_amount_after, 0)
     INTO c_pool_name,
          c_pool_amount
     FROM iss_game_pool
    WHERE game_code = p_game_code
      AND pool_code = 0;

EXCEPTION
   WHEN no_data_found THEN
      c_errorcode := 1;
      c_errormesg := '没有找到游戏[' || p_game_code || ']的奖池.';
   WHEN OTHERS THEN
      dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);
END;
/
