/********************************************************************************/
  ------------------- 返回站点所属组织机构代码-----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
create or replace function f_get_agency_org(
  p_agency in string --站点编码

) return string
  result_cache
  relies_on(inf_agencys)

is
  /*-----------    变量定义     -----------------*/
  v_ret_code string(8) := ''; -- 返回值

begin

  select org_code
    into v_ret_code
    from inf_agencys
   where agency_code = p_agency;

  return v_ret_code;

end;
