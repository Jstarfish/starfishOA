create or replace function f_get_sys_param
/*******************************************************************************/
  ----- 获取系统参数
  ----- add by 陈震 @ 2016-04-19
  -----
/*******************************************************************************/
(
  p_param in number
)
  return varchar2
  result_cache
  relies_on(inf_agencys)
is
  v_rtv varchar2(4000);
begin
  begin
    select sys_default_value into v_rtv from sys_parameter where sys_default_seq = p_param;
  exception
    when no_data_found then
      raise_application_error(-20001, error_msg.err_f_get_sys_param_1);
      return '';
  end;

  return v_rtv;
end;
