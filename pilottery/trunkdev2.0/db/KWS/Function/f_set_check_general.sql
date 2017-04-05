create or replace function f_set_check_general
/*******************************************************************************/
  ----- add by 孔维鑫 @ 2016-04-19
  -----
  /*******************************************************************************/
(
  p_terminal_code in char,
  p_teller_code   in number,
  p_agency_code   in char,
  p_org_code      in char
) return number
  result_cache
  relies_on(saler_terminal,inf_tellers,inf_agencys,inf_orgs)
is
  v_terminal_code saler_terminal.terminal_code%type;
  v_teller_code   inf_tellers.teller_code%type;
  v_agency_code   inf_agencys.agency_code%type;
  v_org_code      inf_orgs.org_code%type;

  v_count number := 0;
begin
  begin
    --检查对应的终端机是否存在,且可用
    select terminal_code
      into v_terminal_code
      from saler_terminal
     where terminal_code = p_terminal_code
       and status = eterminal_status.enabled;

    --检查对应的销售员是否存在,且可用
    select teller_code
      into v_teller_code
      from inf_tellers
     where teller_code = p_teller_code
       and status = eteller_status.enabled;

    --检查对应的销售站是否存在,且可用
    select agency_code
      into v_agency_code
      from inf_agencys
     where agency_code = p_agency_code
       and status = eagency_status.enabled;

    --检查对应的部门是否存在，且可用
    select org_code
      into v_org_code
      from inf_orgs
     where org_code = p_org_code
       and org_status = eorg_status.available;

  exception
    when no_data_found then
      return ehost_error.host_t_token_expired_err;
  end;

  --检查培训员是否登录
  select count(*)
    into v_count
    from dual
   where exists (select 1
            from inf_tellers
           where teller_code = p_teller_code
             and LATEST_TERMINAL_CODE = p_terminal_code
             and is_online = eboolean.yesorenabled);
  if v_count = 0 then
    return ehost_error.host_t_teller_signout_err;
  end if;
  return 0;
end;
