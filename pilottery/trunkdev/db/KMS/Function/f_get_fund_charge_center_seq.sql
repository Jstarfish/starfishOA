/********************************************************************************/
  ------------------- �������ʽ�������-----------------------------
  ----��Ա�FUND_CHARGE_CENTER(����վ(����)���ĳ�ֵ)��FUND_NO�ֶδ���ͬһ���к���
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_fund_charge_center_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'FC'||lpad(seq_fund_no.nextval,8,'0');
END;