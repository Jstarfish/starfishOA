create or replace function f_get_ticket_memo
(
/*******************************************************************************/
  ----- 获取票面宣传语
  ----- add by Chen Zhen @ 2016-04-20

/*******************************************************************************/
  p_game_code in number       -- 游戏编码，0表示所有游戏
)
  return varchar2
  result_cache
  relies_on(sys_ticket_memo)
is
  v_ret_str varchar2(4000);
begin
  begin
    select ticket_memo
      into v_ret_str
      from sys_ticket_memo
     where game_code = p_game_code
       and his_code = (select max(his_code)
                         from sys_ticket_memo
                        where game_code = p_game_code);
  exception
    when no_data_found then
      v_ret_str := '';
  end;

  return v_ret_str;
end;
