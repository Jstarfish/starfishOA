CREATE OR REPLACE PACKAGE edigital_trans_status IS
   /****** 交易状态（1=发起，2=成功返回，3=失败返回，4=返回超时） ******/
   record          /* 1=发起 */            CONSTANT NUMBER := 1;
   succ            /* 2=成功返回 */        CONSTANT NUMBER := 2;
   fail            /* 3=失败返回 */        CONSTANT NUMBER := 3;
   timeout         /* 4=返回超时 */        CONSTANT NUMBER := 4;
END;
