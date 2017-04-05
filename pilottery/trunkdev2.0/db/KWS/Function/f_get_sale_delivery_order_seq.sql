/**************************************************************************************************************************/
  ------------------- 适用于订单、出货单、调拨单、退货单、损毁单、盘点单和批次入库单编号的序列---------------------------
  ----针对表SALE_DELIVERY_ORDER(出货单)的DO_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/**************************************************************************************************************************/
CREATE OR REPLACE FUNCTION f_get_sale_delivery_order_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'CH'||lpad(seq_order_no.nextval,8,'0');
END;