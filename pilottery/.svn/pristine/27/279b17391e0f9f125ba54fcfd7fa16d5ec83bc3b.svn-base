/********************************************************************************/
  ------------------- 适用于机构佣金流水序号----------------------------
  ----针对表FLOW_ORG_COMM_DETAIL(机构销售佣金流水)的ORG_FUND_COMM_FLOW字段创建同一序列函数
  ----add by 陈震: 2015-12-19
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_comm_flow_org_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'JGYJ'||lpad(seq_org_fund_flow.nextval,20,'0');
END;
