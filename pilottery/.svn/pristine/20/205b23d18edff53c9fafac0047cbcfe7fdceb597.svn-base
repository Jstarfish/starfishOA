/********************************************************************************/
  ------------------- 返回teller类型-----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
create or replace function f_get_teller_role(
  p_teller in number --站点编码

) return number
  result_cache
  relies_on(inf_tellers)

is
  /*-----------    变量定义     -----------------*/
  v_ret_code number(2); -- 返回值

begin

    select teller_type
      into v_ret_code
      from inf_tellers
     where teller_code = p_teller;

  return v_ret_code;

end;
