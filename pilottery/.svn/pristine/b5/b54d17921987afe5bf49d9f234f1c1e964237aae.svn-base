CREATE OR REPLACE FUNCTION f_get_flow_cancel_seq
/********************************************************************************/
  ------------------- 适用于退票记录序号----------------------------
  ----针对表FLOW_CANCEL(退票记录)的CANCEL_FLOW字段创建同一序列函数
  ----add by Chen Zhen: 2015/10/2
/********************************************************************************/
   RETURN VARCHAR2 IS
BEGIN
   return 'TP'||lpad(seq_cancel_flow.nextval,22,'0');
END;
