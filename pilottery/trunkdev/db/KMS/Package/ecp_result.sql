CREATE OR REPLACE PACKAGE ecp_result IS
   /****** 适用于以下表：                                                                        ******/
   /******    2.1.5.12 盘点单（wh_check_point）   盘点结果（1-一致，2-盘亏，3-盘盈）	result    ******/
   /******    2.1.10.7 物品盘点（item_check）     盘点结果（1-一致，2-盘亏，3-盘盈）	result    ******/

   /****** 盘点结果（1-一致，2-盘亏，3-盘盈） ******/
   same                   /* 1-一致 */                  CONSTANT NUMBER := 1;
   less                   /* 2-盘亏 */                  CONSTANT NUMBER := 2;
   more                   /* 3-盘盈 */                  CONSTANT NUMBER := 3;
END;
/
