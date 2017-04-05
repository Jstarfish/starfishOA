create or replace function f_set_auth
/*******************************************************************************/
  ----- 主机：终端认证
  ----- add by 陈震 @ 2016-04-19
  -----
/*******************************************************************************/
(
  p_mac in string, --登录的终端机mac地址
  p_ver in string  --登录的终端机软件版本号

) return string
  result_cache
  relies_on(inf_agencys, saler_terminal, upg_package)
is
  v_agency_code inf_agencys.agency_code%type;
  v_org inf_orgs.org_code%type;

  v_terminal_code saler_terminal.terminal_code%type;
  v_term_type   saler_terminal.term_type_id%type;

  v_count number := 0;
begin

  --检查终端机对应的销售站是否存在
  begin
    -- 检查mac地址对应的终端机是否存在且有效
    select agency_code, terminal_code, term_type_id
      into v_agency_code, v_terminal_code, v_term_type
      from saler_terminal
     where mac_address = upper(p_mac)
       and status = eterminal_status.enabled;

    -- 检查对应的销售站状态是否有效
    select agency_code, org_code
      into v_agency_code, v_org
      from inf_agencys
     where agency_code = v_agency_code
       and status = eagency_status.enabled;

    -- 检查对应的部门状态是否有效
    select org_code
      into v_org
      from inf_orgs
     where org_code = v_org
       and org_status = eorg_status.available;

  exception
    when no_data_found then
      return 'null, null, null, ' || ehost_error.host_t_authenticate_err;
  end;

  -- 检查版本是否可用
  select count(*)
    into v_count
    from dual
   where exists(select 1
                  from upg_package
                 where pkg_ver = p_ver
                   and adapt_term_type = v_term_type
                   and is_valid = eboolean.yesorenabled);
  if v_count = 0 then
    return 'null, null, null, ' || ehost_error.host_version_not_available_err;
  end if;

  return v_agency_code || ',' || to_char(v_terminal_code) || ',' || v_org || ',0';
end;
