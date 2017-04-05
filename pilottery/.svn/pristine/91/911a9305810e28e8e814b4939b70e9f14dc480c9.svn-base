create or replace function f_set_login
/*******************************************************************************/
  ----- 主机：teller 登录
  ----- add by 陈震 @ 2016-04-19
  -----
/*******************************************************************************/
(
  p_teller in inf_tellers.teller_code%type,       -- 登录销售员
  p_term   in inf_terminal.terminal_code%type,    -- 登录终端
  p_agency in inf_agencys.agency_code%type,       -- 登录销售站
  p_pass   in varchar2                            -- 登录密码

) return string
  result_cache
  relies_on(inf_tellers, inf_agencys, saler_terminal, upg_package)
is
  v_teller_info inf_tellers%rowtype;
  v_term_info saler_terminal%rowtype;
  v_agency_info inf_agencys%rowtype;

  v_org inf_orgs.org_code%type;
  v_balance acc_agency_account.account_balance%type;
  v_credit acc_agency_account.credit_limit%type;

begin

  --检查终端机对应的销售站是否存在
  begin
    -- 检查mac地址对应的终端机是否存在且有效
    select *
      into v_teller_info
      from inf_tellers
     where teller_code = p_teller
       and status = eteller_status.enabled
       and password = p_pass;
  exception
    when no_data_found then
      return 'null, null, null, null, ' || ehost_error.host_t_namepwd_err;
  end;

  begin
    -- 检查mac地址对应的终端机是否存在且有效
    select *
      into v_term_info
      from saler_terminal
     where terminal_code = p_term
       and status = eterminal_status.enabled;

    -- 检查对应的销售站状态是否有效
    select *
      into v_agency_info
      from inf_agencys
     where agency_code = v_term_info.agency_code
       and status = eagency_status.enabled;

    -- 检查对应的部门状态是否有效
    select org_code
      into v_org
      from inf_orgs
     where org_code = v_agency_info.org_code
       and org_status = eorg_status.available;

  exception
    when no_data_found then
      return 'null, null, null, null, ' || ehost_error.host_t_token_expired_err;
  end;
  -- modify by kwx 2016-06-21 当销售员不在所属的站点登录的时候会在终端机界面不停的reset,因此改成5
  if not(v_teller_info.agency_code = v_term_info.agency_code and v_term_info.agency_code = p_agency) then
    return 'null, null, null, null, ' || ehost_error.host_t_namepwd_err;
  end if;

  begin
    select account_balance, credit_limit
      into v_balance, v_credit
      from acc_agency_account
     where ACC_TYPE = eacc_type.main_account
       and AGENCY_CODE = v_agency_info.agency_code;
  exception
    when no_data_found then
      raise_application_error(-20001, '没有找到销售站' || v_agency_info.agency_code || '对应的账户');
  end;

  -- 返回 teller type、流水号、余额、信用额度
  return v_teller_info.teller_type || ',' || v_term_info.trans_seq || ',' ||  to_char(v_balance) || ',' || to_char(v_credit) || ',0';
end;
