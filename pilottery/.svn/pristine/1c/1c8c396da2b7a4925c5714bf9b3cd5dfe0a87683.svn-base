/**************************************************************************************************************************/
  ------------------- 适用于订单收货明细、订单申请明细、出货单申请明细、调拨单申请明细、---------------------------
  ------------------- 退货单明细、损毁单明细、盘点差错明细、盘点结果明细、盘点前库存明细的序列---------------------------
  ----针对表如下表创建的SEQUENCE_NO字段创建同一序列函数
  ----WH_ORDER_RECEIVE_DETAIL(订单收货明细)     
  ----SALE_ORDER_APPLY_DETAIL(订单申请明细)     
  ----SALE_DELIVERY_ORDER_DETAIL(出货单申请明细)
  ----SALE_TB_APPLY_DETAIL(调拨单申请明细)      
  ----SALE_RETURN_RECODER_DETAIL(退货单明细)    
  ----WH_BROKEN_RECODER_DETAIL(损毁单明细)      
  ----WH_CP_NOMATCH_DETAIL(盘点差错明细)        
  ----WH_CHECK_POINT_DETAIL(盘点结果明细)       
  ----WH_CHECK_POINT_DETAIL_BE(盘点前库存明细)
  ----add by dzg: 2015-9-11 
/**************************************************************************************************************************/
CREATE OR REPLACE FUNCTION f_get_detail_sequence_no_seq
   RETURN VARCHAR2 IS
BEGIN
   return lpad(seq_detail_sequence_no.nextval,24,'0');
END;
