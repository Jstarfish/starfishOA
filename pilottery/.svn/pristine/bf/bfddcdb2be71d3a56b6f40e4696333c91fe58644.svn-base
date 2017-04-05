CREATE OR REPLACE PROCEDURE p_sys_update_negative_issue
/****************************************************************/
------------------适用于: 刷新以下表中期次为负值的数据 ----------
----------------- adj_game_his
----------------- iss_game_pool_his
/****************************************************************/
IS
   v_cnt    number(10);
BEGIN
   update adj_game_his
      set issue_number = f_get_right_issue(game_code, issue_number)
    where issue_number < 0;

   update iss_game_pool_his
      set issue_number = f_get_right_issue(game_code, issue_number)
    where issue_number < 0;

   commit;
END;
