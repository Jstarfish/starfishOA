/********************************************************************************/
  ------------------- 适用于机构资金流水序号----------------------------
  ----针对表FLOW_ORG(机构资金流水)的ORG_FUND_FLOW字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_flow_org_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'JG'||lpad(seq_org_fund_flow.nextval,22,'0');
END;
