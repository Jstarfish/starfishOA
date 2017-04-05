create or replace function f_get_agency_type(
  p_agency in string --站点编码

) return inf_agencys.agency_type%type
  result_cache
  relies_on(inf_agencys)

is
  /*-----------    变量定义     -----------------*/
  v_agency_type inf_agencys.agency_type%type; -- 返回值

begin

  select agency_type
    into v_agency_type
    from inf_agencys
   where agency_code = p_agency;

  return v_agency_type;

end;
