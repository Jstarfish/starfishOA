create or replace procedure p_set_auth
/*******************************************************************************/
  ----- add by 陈震 @ 2016-04-19
  -----
  /*******************************************************************************/
(
  p_json       in string,  --登录的终端机mac地址
  c_json       out string, --登录的终端机软件版本号
  c_errorcode  out number, --错误编码
  c_errormesg  out string --错误原因

)
is
  v_mac varchar2(100);
  v_ver varchar2(100);

  v_input_json            json;
  v_out_json              json;

  v_ret_string varchar2(4000);

begin
  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  v_input_json := json(p_json);

  -- 获取入口参数
  v_mac := v_input_json.get('mac').get_string;
  v_ver := v_input_json.get('version').get_string;

  -- 调用函数
  v_ret_string := f_set_auth(v_mac, v_ver);

  -- 构造返回json
  v_out_json := json();

  for tab in (select rownum cnt, column_value from table(dbtool.strsplit(v_ret_string))) loop
    case tab.cnt
      when 1 then
        v_out_json.put('agency_code', tab.column_value);
      when 2 then
        v_out_json.put('term_code', tab.column_value);
      when 3 then
        v_out_json.put('org_code', tab.column_value);
      when 4 then
        v_out_json.put('rc', to_number(tab.column_value));
    end case;
  end loop;

  c_json := v_out_json.to_char;

exception
   when others then
      c_errorcode := 1;
      c_errormesg := error_msg.err_common_1 || sqlerrm;
end;
