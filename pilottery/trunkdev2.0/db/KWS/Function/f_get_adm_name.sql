CREATE OR REPLACE FUNCTION f_get_adm_name(p_admin_id number) RETURN varchar2
IS
   v_admin_name varchar2(40);
BEGIN
    select ADMIN_REALNAME
      into v_admin_name
      from ADM_INFO
     where ADMIN_ID=p_admin_id;
    return v_admin_name;
exception
   when no_data_found then
      return '[NO NAME FOUND]';
END;
