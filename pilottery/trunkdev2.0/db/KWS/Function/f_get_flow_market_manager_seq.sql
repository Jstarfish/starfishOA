/********************************************************************************/
  ------------------- 适用于市场管理员资金流水序号-----------------------------
  ----针对表FLOW_MARKET_MANAGER(市场管理员资金流水)的MM_FUND_FLOW字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_flow_market_manager_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'MM'||lpad(seq_mm_fund_flow.nextval,22,'0');
END;
