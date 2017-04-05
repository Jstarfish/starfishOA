/********************************************************************************/
  ------------------- 返回站点信用额度 -----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
create or replace function f_get_agency_credit(
  p_agency in string --站点编码

) return number
  result_cache
  relies_on(inf_agencys)

is
  /*-----------    变量定义     -----------------*/
  v_ret number(28);

begin

  begin
    select credit_limit
      into v_ret
      from acc_agency_account
     where agency_code = p_agency
       and acc_type=eacc_type.main_account;
  exception
    when no_data_found then
      return 0;
  end;

  return v_ret;

end;
