create or replace procedure p_set_get_gameinfo
/*******************************************************************************/
  ----- 主机：游戏信息请求
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

  v_ret_num     number(3);
  v_ret_str     varchar2(4000);

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
  v_ret_str := f_get_agency_info(v_agency);
  if length(v_ret_str) <> 0 then
    for tab in (select rownum cnt, column_value from table(dbtool.strsplit(v_ret_str, '^'))) loop
      case tab.cnt
        when 1 then
          v_out_json.put('contact_address', tab.column_value);
        when 2 then
          v_out_json.put('contact_phone', tab.column_value);
      end case;
    end loop;

  end if;

  -- 获取票面宣传语，系统参数
  v_ret_str := f_get_ticket_memo(0);
  v_out_json.put('ticket_slogan', v_ret_str);

  v_out_json.put('rc', 0);

  c_json := v_out_json.to_char;

exception
  when others then
    c_errorcode := 1;
    c_errormesg := error_msg.err_common_1 || sqlerrm;
end;

