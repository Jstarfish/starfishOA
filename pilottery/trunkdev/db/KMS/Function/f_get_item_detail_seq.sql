/********************************************************************************/
  ------------------- ��������Ʒ����⼰�̵���ϸ����ŷ�����----------------------------
  ----add by ����: 2015/9/24
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_item_detail_seq
   RETURN NUMBER IS
BEGIN
   return seq_item_sequence_no.nextval;
END;