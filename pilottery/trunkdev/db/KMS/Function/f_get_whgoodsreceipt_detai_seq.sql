/********************************************************************************/
  ------------------- �����ڳ��ⵥ��ⵥ��ϸ���----------------------------
  ----��Ա�WH_GOODS_RECEIPT_DETAIL(��ⵥ��ϸ)��SGI_NO�ֶδ���ͬһ���к���
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_whgoodsreceipt_detai_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'RK'||lpad(seq_wh_sgi_sgr_detail_no.nextval,8,'0');
END;
