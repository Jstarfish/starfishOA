/********************************************************************************/
  ------------------- 适用于资金管理序号-----------------------------
  ----针对表FUND_CHARGE_CENTER(销售站(机构)中心充值)的FUND_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_fund_charge_center_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'FC'||lpad(seq_fund_no.nextval,8,'0');
END;
