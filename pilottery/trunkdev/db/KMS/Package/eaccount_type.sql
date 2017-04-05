CREATE OR REPLACE PACKAGE eaccount_type IS
   /****** 适用于以下表：(账户类型（1-机构，2-站点）	account_type)  ******/
   /******    2.1.9.1 销售站（机构）中心充值（fund_charge_center）   ******/
   /******    2.1.9.2 销售站（机构）现金充值（FUND_CHARGE_CASH）     ******/
   /******    2.1.9.3 销售站（机构）提现（FUND_WITHDRAW）            ******/
   /******    2.1.9.4 销售站（机构）调账（FUND_TUNING）              ******/

   org                      /* 1-机构 */                  CONSTANT NUMBER := 1;
   agency                   /* 2-站点 */                  CONSTANT NUMBER := 2;
END;
/
