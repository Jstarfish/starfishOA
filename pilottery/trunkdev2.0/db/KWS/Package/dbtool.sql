create or replace package dbtool is

  -- 设置数据库错误参数（初始化）
  procedure set_success (
    errcode in out number,
    errmesg in out string
  );

  -- 设置数据库错误参数（错误信息）
  procedure set_dberror
  (
    errcode in out number,
    errmesg in out string
  );

  -- 用法: select * from table(dbtool.strsplit('1,2,3,4,5'))
  function strsplit
  (
    p_value varchar2,
    p_split varchar2 := ','
  ) return tabletype
    pipelined;

  -- 输出“[value]”格式的字符串
  function format_line(p_value varchar2) return varchar2;

  -- 调试打印输出
  procedure p(p_value varchar2);

  -- 日期转字符串(yyyy-mm-dd)
  function d2s(p_value date, p_format varchar2 default 'yyyy-mm-dd') return varchar2;

  -- 字符串转日期(yyyy-mm-dd)
  function s2d(p_value varchar2, p_format varchar2 default 'yyyy-mm-dd') return date;

  -- 时间转字符串
  function t2s(p_value date) return varchar2;

  -- 字符串转时间
  function s2t(p_value varchar2) return date;

  -- 出报表用，除以10，取整到十位
  function trunc_div_10(p_value number) return number;

  -- 出报表用，除以100，取整到百位
  function trunc_div_100(p_value number) return number;

  -- 校验余额
  --function check_balance(p_value varchar2, p_key varchar2, p_check_code varchar2) return number;

  -- 生成校验码
  --function gen_check_code(p_value varchar2, p_key varchar2) return varchar2;

end;
/

create or replace package body dbtool is
  -- 设置数据库错误参数（初始化）
  procedure set_success
  (
    errcode in out number,
    errmesg in out string
  ) is
  begin
    errcode := 0;
    errmesg := 'success';
  end set_success;

  -- 设置数据库错误参数（错误信息）
  procedure set_dberror
  (
    errcode in out number,
    errmesg in out string
  ) is
  begin
    errcode := sqlcode;
    errmesg := sqlerrm;
  end set_dberror;

  function strsplit
  (
    p_value varchar2,
    p_split varchar2 := ','
  )
  -- 用法: select * from table(dbtool.strsplit('1,2,3,4,5'))
  return tabletype
    pipelined is
    v_idx       integer;
    v_str       varchar2(500);
    v_strs_last varchar2(4000) := p_value;

  begin
    v_strs_last := trim(v_strs_last);
    loop
       v_idx := instr(v_strs_last, p_split);
       v_idx := nvl(v_idx,0);
       exit when v_idx = 0;
       v_str       := substr(v_strs_last, 1, v_idx - 1);
       v_strs_last := substr(v_strs_last, v_idx + 1);
       pipe row(v_str);
    end loop;
    pipe row(v_strs_last);
    return;

  end strsplit;

  function format_line(p_value varchar2) return varchar2 is
  begin
    return '[' || nvl(p_value, 'null') || ']';
  end format_line;

  procedure p(p_value varchar2) is
  begin
   dbms_output.put_line(format_line(p_value));
  end p;

  -- 日期转字符串(yyyy-mm-dd)
  function d2s(
    p_value date,
    p_format varchar2 default 'yyyy-mm-dd'
  )
  return varchar2
  is
  begin
    return to_char(p_value, p_format);
  end d2s;

  -- 字符串转日期(yyyy-mm-dd)
  function s2d(
    p_value varchar2,
    p_format varchar2 default 'yyyy-mm-dd'
  )
  return date
  is
  begin
    return to_date(p_value, p_format);
  end s2d;

  -- 时间转字符串(yyyy-mm-dd hh24:mi:ss)
  function t2s(
    p_value date
  )
  return varchar2
  is
  begin
    return d2s(p_value, 'yyyy-mm-dd hh24:mi:ss');
  end t2s;

  -- 字符串转时间(yyyy-mm-dd hh24:mi:ss)
  function s2t(
    p_value varchar2
  )
  return date
  is
  begin
    return s2d(p_value, 'yyyy-mm-dd hh24:mi:ss');
  end s2t;

  -- 校验余额
  --function check_balance(p_value varchar2, p_key varchar2, p_check_code varchar2) return number is
  --begin
  --  if gen_check_code(p_value, p_key) = p_check_code then
  --    return 1;
  --  else
  --    return 0;
  --  end if;
  --end check_balance;

  -- 生成校验码
  --function gen_check_code(p_value varchar2, p_key varchar2) return varchar2 is
  --  l_mac_val  raw(4000);
  --  l_key      raw(4000);
  --  l_mac_algo pls_integer;
  --  l_in       raw(4000);
  --  l_ret      varchar2(4000);
  --begin
  --  l_mac_algo := dbms_crypto.hmac_sh1;
  --  l_in       := utl_i18n.string_to_raw(p_value, 'al32utf8');
  --  l_key      := utl_i18n.string_to_raw(p_key, 'al32utf8');
  --  l_mac_val  := dbms_crypto.mac(src => l_in,
  --                                typ => l_mac_algo,
  --                                key => l_key);
  --  l_ret      := rawtohex(l_mac_val);
  --  return l_ret;
  --end gen_check_code;

  -- 出报表用，除以10，取整到十位
  function trunc_div_10(p_value number) return number is
  begin
    return round(p_value / 1000) * 100;
  end trunc_div_10;

  -- 出报表用，除以100，取整到百位
  function trunc_div_100(p_value number) return number is
  begin
    return round(p_value / 10000) * 1000;
  end trunc_div_100;

begin
   null;
end;
/