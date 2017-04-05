CREATE OR REPLACE FUNCTION f_get_sys_param(p_param in number)
   RETURN VARCHAR2

 IS
   v_rtv varchar2(4000);
BEGIN
   begin
      select SYS_DEFAULT_VALUE into v_rtv from SYS_PARAMETER where SYS_DEFAULT_SEQ = p_param;
   exception
      when no_data_found then
         raise_application_error(-20001, error_msg.err_f_get_sys_param_1);
         return '';
   end;

   return v_rtv;
END;
