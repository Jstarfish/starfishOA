  ------------------- 适用于物品序号-----------------------------
  ----针对表ITEM_ITEMS(物品) 的ITEM_CODE字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_item_code_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'IT'||lpad(seq_item_code.nextval,6,'0');
END;
