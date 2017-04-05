/********************************************************************************/
  ------------------- 适用于资金管理序号-----------------------------
  ----针对表INF_AGENCY_DELETE(售站清退)的FUND_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_inf_agency_delete_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'QT'||lpad(seq_fund_no.nextval,8,'0');
END;
