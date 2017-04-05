/********************************************************************************/
  ------------------- 返回站点所属区域代码-----------------------------
  ----add by 陈震: 2016/08/01
/********************************************************************************/
create or replace function f_get_agency_area(
  p_applyflow_sell in string --销售请流水

) return string
  result_cache
  relies_on(inf_agencys)

is
  /*-----------    变量定义     -----------------*/
  v_ret_code string(8) := ''; -- 返回值

begin

  select area_code
    into v_ret_code
    from his_sellticket join inf_agencys on his_sellticket.agency_code=inf_agencys.agency_code
	and applyflow_sell=p_applyflow_sell;

  return v_ret_code;

end;
