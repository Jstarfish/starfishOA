  ------------------- ��������Ʒ���-----------------------------
  ----��Ա�ITEM_ITEMS(��Ʒ) ��ITEM_CODE�ֶδ���ͬһ���к���
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_item_code_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'IT'||lpad(seq_item_code.nextval,6,'0');
END;
