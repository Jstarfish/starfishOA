CREATE OR REPLACE FUNCTION f_get_his_pay_seq RETURN number IS
BEGIN
    return seq_his_pay.nextval;
END;
