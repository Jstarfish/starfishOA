/********************************************************************************/
  ------------------- 适用于物品损毁序号----------------------------
  ----针对表ITEM_DAMAGE的id_no字段创建同一序列函数
  ----add by 陈震: 2015/10/16
/********************************************************************************/
create or replace function f_get_item_id_no_seq
   return varchar2 is
begin
   return 'ID'||lpad(seq_item_no.nextval,8,'0');
end;
