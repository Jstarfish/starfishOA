/********************************************************************************/
  ------------------- �����ڶҽ���¼���----------------------------
  ----��Ա�FLOW_PAY(�ҽ���¼)��PAY_FLOW�ֶδ���ͬһ���к���
  ----add by dzg: 2015-9-11 
/********************************************************************************/

CREATE OR REPLACE FUNCTION f_get_flow_pay_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'DJ'||lpad(seq_pay_flow.nextval,22,'0');
END;