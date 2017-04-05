/********************************************************************************/
  ------------------- 返回站点名称 -----------------------------
  ----add by 陈震: 2017/3/21
/********************************************************************************/
create or replace function f_get_agency_name(
  p_agency in string --站点编码

) return string
  result_cache
  relies_on(inf_agencys)

is
  /*-----------    变量定义     -----------------*/
  v_ret_code varchar2(4000) := ''; -- 返回值

begin

    select agency_name
      into v_ret_code
      from inf_agencys
     where agency_code = p_agency;

  return v_ret_code;

end;
