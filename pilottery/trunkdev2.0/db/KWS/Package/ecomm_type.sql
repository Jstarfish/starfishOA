CREATE OR REPLACE PACKAGE ecomm_type IS
   /****** 发行费类型（1、销售；2、兑奖；） ******/
   sale     /* 1=销售         */          CONSTANT NUMBER := 1;
   pay      /* 2=兑奖         */          CONSTANT NUMBER := 2;
END;
/