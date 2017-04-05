/********************************************************************************/
  ------------------- 返回无纸化销售站销售员和终端机编码-----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
create or replace function f_get_cncp_agency_tt(
  p_agency in string --站点编码

) return string
  result_cache
  relies_on(saler_terminal, inf_tellers)

is
  /*-----------    变量定义     -----------------*/
  v_terminal              saler_terminal.terminal_code%type;      -- 兑奖终端
  v_teller                inf_tellers.teller_code%type;           -- 兑奖销售员

begin

  begin
    select max(TERMINAL_CODE) into v_terminal from saler_terminal where AGENCY_CODE = p_agency;
  exception
    when no_data_found then
      raise_application_error(-20001, '没有找到销售站对应的终端（f_get_cncp_agency_tt）');
  end;
    
  begin
    select max(TELLER_CODE) into v_teller from inf_tellers where AGENCY_CODE = p_agency;
  exception
    when no_data_found then
      raise_application_error(-20001, '没有找到销售站对应的销售员（f_get_cncp_agency_tt）');
  end;

  return v_terminal || '#' || to_char(v_teller);

end;
