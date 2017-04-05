create or replace function f_check_game_issue_sale(p_game number, p_issue number)
  return boolean
  result_cache
  relies_on(iss_game_issue)
 is
/********************************************************************************/
  ------------------- 适用于检查游戏是否在可售状态 ----------------------------
  ---- add by 陈震: 2016-09-09
/********************************************************************************/
   v_count number(1);
begin
  select count(*)
    into v_count
    from iss_game_issue
   where game_code = p_game
     and issue_number = p_issue
     and issue_status = egame_issue_status.issueopen;
  if v_count = 1 then
    return true;
  else
    return false;
  end if;
end;
