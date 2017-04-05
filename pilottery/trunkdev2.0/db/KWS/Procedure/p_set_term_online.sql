create or replace procedure p_set_term_online
/*******************************************************************************/
  ----- 记录终端机在线时长 add by Chen Zhen @ 2016-07-21
  ----- 请求JSON:
  ----- 
  ----- {
  ----- "type":1002,
  ----- "term_code":"0101000101",
  ----- "current_time":1469066100,
  ----- "online_seconds":1200
  ----- }
  ----- 
  ----- term_code 字符串类型，
  ----- current_time：数字类型，表示当前系统时间的时间戳
  ----- online_seconds：数字类型，表示到curr_time 为止，此终端机已经在线多少秒（累计值）
  ----- 
  ----- 响应JSON
  ----- {
  ----- "type":1002,
  ----- "rc":0
  ----- }

  /*******************************************************************************/
(
  p_json       in string,  --入口json
  c_json       out string, --出口json
  c_errorcode  out number, --错误编码
  c_errormesg  out string  --错误原因

)
is
  v_term            saler_terminal.terminal_code%type;
  v_host_stamp      sys_terminal_online_time.host_begin_time_stamp%type;
  v_online_time     sys_terminal_online_time.online_time%type;
  v_trade_type      number(10);

  v_input_json      json;
  v_out_json        json;

  v_ret_string      varchar2(4000);

begin
  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_input_json := json(p_json);
  v_out_json := json();

  -- 获取输入值
  v_trade_type := v_input_json.get('type').get_number;
  v_term := v_input_json.get('term_code').get_string;
  v_host_stamp := v_input_json.get('begin_time').get_number;
  v_online_time := v_input_json.get('online_seconds').get_number;

  if v_trade_type <> 1002 then
    c_errorcode := 1;
    c_errormesg := error_msg.err_comm_trade_type_error || 'Want->1002 Real->' || v_trade_type;             -- 报文输入有错
    return;
  end if;

  insert into SYS_TERMINAL_ONLINE_TIME (
              TERMINAL_CODE, HOST_BEGIN_TIME_STAMP, ONLINE_TIME,    RECORD_TIME, RECORD_DAY) 
       values (
              v_term,        v_host_stamp,          v_online_time,  sysdate,     to_char(sysdate, 'yyyy-mm-dd')
              );

  v_out_json.put('type', v_trade_type);
  v_out_json.put('rc', 0);
  c_json := v_out_json.to_char;

  commit;
exception
  when others then
    rollback;
    c_errorcode := 1;
    c_errormesg := error_msg.err_common_1 || sqlerrm;
end;
