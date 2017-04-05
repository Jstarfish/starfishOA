CREATE OR REPLACE FUNCTION f_get_sys_oper_log_seq RETURN varchar2 IS
BEGIN
    return 'RZ' || lpad(seq_sys_log_id.nextval,8,'0');
END;
