/********************************************************************************/
  ------------------- 适用于出库单入库单序号----------------------------
  ----针对表WH_GOODS_RECEIPT(入库单) 的SGR_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_wh_goods_receipt_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'RK'||lpad(seq_wh_sgi_sgr_no.nextval,8,'0');
END;
