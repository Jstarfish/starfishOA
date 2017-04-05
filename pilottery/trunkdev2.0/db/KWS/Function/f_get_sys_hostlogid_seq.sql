CREATE OR REPLACE FUNCTION f_get_sys_hostlogid_seq RETURN number IS
BEGIN
    return seq_upg_schedule_id.nextval;
END;
