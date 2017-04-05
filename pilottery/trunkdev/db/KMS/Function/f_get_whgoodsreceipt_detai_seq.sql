/********************************************************************************/
  ------------------- 适用于出库单入库单明细序号----------------------------
  ----针对表WH_GOODS_RECEIPT_DETAIL(入库单明细)的SGI_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_whgoodsreceipt_detai_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'RK'||lpad(seq_wh_sgi_sgr_detail_no.nextval,8,'0');
END;
