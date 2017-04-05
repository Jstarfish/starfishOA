/********************************************************************************/
  ------------------- 返回游戏名称 -----------------------------
  ----add by 孔维鑫: 2016/8/2
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_game_name(
   p_game_code IN number -- 游戏编号

) RETURN STRING IS
   /*-----------    变量定义     -----------------*/
   v_ret_code STRING(64) := ''; -- 返回值

BEGIN
    select SHORT_NAME
         into v_ret_code
           from inf_games
          where game_code = p_game_code;

   return v_ret_code;

END;
