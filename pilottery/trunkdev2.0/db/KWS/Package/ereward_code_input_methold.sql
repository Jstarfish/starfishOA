CREATE OR REPLACE PACKAGE ereward_code_input_methold IS
   /****** 开奖号码输入模式（1=手工；2=光盘） ******/
   manual     /* 1=手工 */          CONSTANT NUMBER := 1;
   cdrom      /* 2=光盘 */          CONSTANT NUMBER := 2;
END;
/