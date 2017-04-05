CREATE OR REPLACE FUNCTION f_get_sys_noticeid_seq RETURN number IS
BEGIN
    return seq_sys_host_logid.nextval;
END;
