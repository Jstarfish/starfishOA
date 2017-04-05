CREATE OR REPLACE FUNCTION f_get_his_win_seq RETURN number IS
BEGIN
    return seq_his_win.nextval;
END;
