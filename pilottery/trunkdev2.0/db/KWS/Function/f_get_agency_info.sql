/********************************************************************************/
  ------------------- 返回站点信息-----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
create or replace function f_get_agency_info(
  p_agency in string --站点编码

) return string
  result_cache
  relies_on(inf_agencys)

is
  /*-----------    变量定义     -----------------*/
  v_ret_code varchar2(4000) := ''; -- 返回值

begin

  begin
    select nvl(address, '') || '^' || nvl(telephone, '')
      into v_ret_code
      from inf_agencys
     where agency_code = p_agency;
  exception
    when no_data_found then
      return '';
  end;

  return v_ret_code;

end;
