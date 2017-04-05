CREATE OR REPLACE PACKAGE ecp_status IS
   /****** 适用于以下表：                                 ******/
   /******    2.1.5.12 盘点单（wh_check_point）           ******/
   /******        盘点状态（1-盘点中，2-盘点结束）	status ******/

   working                /* 1-盘点中   */                  CONSTANT NUMBER := 1;
   done                   /* 2-盘点结束 */                  CONSTANT NUMBER := 2;
END;
/
