create or replace function f_get_teller_static(
  p_teller in number -- 销售员编码

) return number
  result_cache
  relies_on(inf_tellers)

is
  /*-----------    变量定义     -----------------*/
  v_ret_code number(2); -- 返回值

begin
  begin
    select status
      into v_ret_code
      from inf_tellers
     where teller_code = p_teller;

   exception
      when no_data_found then
      return 13;
   end;
   
   return v_ret_code;
 
end;
