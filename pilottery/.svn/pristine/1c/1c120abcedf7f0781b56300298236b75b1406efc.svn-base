create or replace procedure p_set_login
/*******************************************************************************/
  ----- add by Chen Zhen @ 2016-04-20
  -----
  /*******************************************************************************/
(
  p_json       in string,  --入口json
  c_json       out string, --出口json
  c_errorcode  out number, --错误编码
  c_errormesg  out string  --错误原因

)
is
  v_teller      inf_tellers.teller_code%type;
  v_term        saler_terminal.terminal_code%type;
  v_last_teller inf_tellers.teller_code%type;
  v_agency_code inf_agencys.agency_code%type;

  v_password    varchar2(32);


  v_input_json  json;
  v_out_json    json;

  v_ret_string  varchar2(4000);
  v_ret_num     number(3);

begin
  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  v_input_json := json(p_json);

  -- 构造返回json
  v_out_json := json();

  -- 调用函数
  v_teller := v_input_json.get('teller_code').get_number;
  v_term := v_input_json.get('term_code').get_string;
  v_agency_code := v_input_json.get('agency_code').get_string;
  v_password := v_input_json.get('password').get_string;


  v_ret_num := f_get_teller_static(v_teller);
  
  -- modify by kwx 2016-06-15 判断销售员不存在
  if v_ret_num = 13 then
    v_out_json.put('rc', ehost_error.host_t_teller_unexist);
    c_json := v_out_json.to_char;
    return;
  -- 判断销售员是否可用	
  elsif v_ret_num = eteller_status.disabled  or  v_ret_num = eteller_status.deleted  then
    v_out_json.put('rc', ehost_error.host_t_teller_disable_err);
    c_json := v_out_json.to_char;
    return;
  end if;

  v_ret_string := f_set_login(p_teller => v_teller,
                              p_term => v_term,
                              p_agency => v_agency_code,
                              p_pass => v_password);


  for tab in (select rownum cnt, column_value from table(dbtool.strsplit(v_ret_string))) loop
    v_ret_string := trim(tab.column_value);
    case tab.cnt
      when 1 then
        v_out_json.put('teller_type', to_number(nullif(v_ret_string, 'null')));
      when 2 then
        v_out_json.put('flownum', to_number(nullif(v_ret_string, 'null')));
      when 3 then
        v_out_json.put('account_balance', to_number(nullif(v_ret_string, 'null')));
      when 4 then
        v_out_json.put('marginal_credit', to_number(nullif(v_ret_string, 'null')));
      when 5 then
        v_out_json.put('rc', to_number(tab.column_value));
    end case;
  end loop;

  c_json := v_out_json.to_char;

  -- 找到原来终端机上原来的销售员
  select latest_login_teller_code
    into v_last_teller
    from saler_terminal
   where terminal_code = v_term;

  -- 强制更新销售员状态为未登录
  if v_last_teller is not null then
    update inf_tellers
       set latest_terminal_code = null,
           latest_sign_off_time = sysdate,
           is_online = eboolean.noordisabled
     where teller_code = v_teller;
  end if;

  -- 更新登录信息
  update saler_terminal
     set is_logging = eboolean.yesorenabled,
         latest_login_teller_code = v_teller
   where terminal_code = v_term;

  update inf_tellers
     set latest_terminal_code = v_term,
         latest_sign_on_time = sysdate,
         is_online = eboolean.yesorenabled
   where teller_code = v_teller;

  commit;
exception
  when others then
    rollback;
    c_errorcode := 1;
    c_errormesg := error_msg.err_common_1 || sqlerrm;
end;
