/********************************************************************************/
  ------------------- 适用于站点资金流水序号-----------------------------
  ----针对表flow_agency(站点资金流水)的AGENCY_FUND_FLOW字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_flow_agency_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'ZD'||lpad(seq_agency_fund_flow.nextval,22,'0');
END;
