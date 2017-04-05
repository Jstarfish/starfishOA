create or replace procedure p_set_logoff
/*******************************************************************************/
  ----- add by chen zhen @ 2016-04-20
  -----
  /*******************************************************************************/
(
  p_json       in string,  -- 入口json
  c_json       out string, -- 出口json
  c_errorcode  out number, -- 错误编码
  c_errormesg  out string  -- 错误原因

)
is
  v_teller      inf_tellers.teller_code%type;
  v_term        saler_terminal.terminal_code%type;

  v_input_json  json;
  v_out_json    json;

begin
  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  v_input_json := json(p_json);
  v_out_json := json();

  -- 获取入口参数
  v_teller := v_input_json.get('teller_code').get_number;
  v_term := v_input_json.get('term_code').get_string;

  -- 更新teller状态，
  update inf_tellers
     set latest_terminal_code = null,
         latest_sign_off_time = sysdate,
         is_online = eboolean.noordisabled
   where teller_code = v_teller;

  -- 更新term状态
  update saler_terminal
     set latest_login_teller_code = null,
         is_logging = eboolean.noordisabled
   where terminal_code = v_term;

  commit;

  v_out_json.put('rc', 0);

  c_json := v_out_json.to_char;

exception
  when others then
    rollback;
    c_errorcode := 1;
    c_errormesg := error_msg.err_common_1 || sqlerrm;
end;
