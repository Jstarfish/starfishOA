/********************************************************************************/
  ------------------- ��������Ʒ������----------------------------
  ----��Ա�item_receipt��ir_no�ֶδ���ͬһ���к���
  ----add by ����: 2015/10/16
/********************************************************************************/
create or replace function f_get_item_ir_no_seq
   return varchar2 is
begin
   return 'IR'||lpad(seq_item_no.nextval,8,'0');
end;