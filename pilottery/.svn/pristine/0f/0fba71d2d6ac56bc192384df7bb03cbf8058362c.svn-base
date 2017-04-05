create or replace procedure p_set_get_accinfo
/*******************************************************************************/
  ----- 主机：账户余额查询
  ----- add by Chen Zhen @ 2016-04-20
  -----
/*******************************************************************************/
(
  p_json       in string,  --登录的终端机mac地址
  c_json       out string, --登录的终端机软件版本号
  c_errorcode  out number, --错误编码
  c_errormesg  out string  --错误原因

)
is
  v_teller      inf_tellers.teller_code%type;
  v_term        saler_terminal.terminal_code%type;
  v_agency      inf_agencys.agency_code%type;
  v_org         inf_orgs.org_code%type;

  v_input_json  json;
  v_out_json    json;

  v_balance     acc_agency_account.account_balance%type;
  v_credit      acc_agency_account.credit_limit%type;

  v_ret_num     number(3);

begin
  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  v_input_json := json(p_json);
  v_out_json := json();

  -- 解析参数
  v_teller := v_input_json.get('teller_code').get_number;
  v_term := v_input_json.get('term_code').get_string;
  v_agency := v_input_json.get('agency_code').get_string;
  v_org := f_get_agency_org(v_agency);

  -- 通用校验
  v_ret_num := f_set_check_general(v_term, v_teller, v_agency, v_org);
  if v_ret_num <> 0 then
    v_out_json.put('rc', v_ret_num);
    c_json := v_out_json.to_char;
    return;
  end if;

  -- 检索需要的信息
  begin
    select account_balance, credit_limit
      into v_balance, v_credit
      from acc_agency_account
     where agency_code = v_agency
       and acc_type = eacc_type.main_account;
  exception
    when no_data_found then
      v_balance := 0;
      v_credit := 0;
  end;

  v_out_json.put('account_balance', v_balance);
  v_out_json.put('marginal_credit', v_credit);
  v_out_json.put('rc', 0);

  c_json := v_out_json.to_char;

exception
  when others then
    c_errorcode := 1;
    c_errormesg := error_msg.err_common_1 || sqlerrm;
end;
