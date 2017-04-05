CREATE OR REPLACE PACKAGE eclaiming_scope IS
   /****** 兑奖范围（0=中心通兑、1=机构通兑、4=本站自兑） ******/
   center          /* 0=中心通兑 */      CONSTANT NUMBER := 0;
   org             /* 1=机构通兑 */      CONSTANT NUMBER := 1;
   agency          /* 4=本站自兑 */      CONSTANT NUMBER := 4;
END;
