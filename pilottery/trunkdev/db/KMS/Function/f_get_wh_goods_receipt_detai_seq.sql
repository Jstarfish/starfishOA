/********************************************************************************/
  ------------------- �����ڳ��ⵥ��ⵥ��ϸ���----------------------------
  ----��Ա�WH_GOODS_RECEIPT_DETAIL(��ⵥ��ϸ)��SGI_NO�ֶδ���ͬһ���к���
  ----add by dzg: 2015-9-11
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_wh_goods_receipt_det_seq
   RETURN NUMBER IS
BEGIN
   return seq_wh_sgi_sgr_detail_no.nextval;
END;