CREATE OR REPLACE PACKAGE ework_status IS
   /****** 适用于以下表：                                                 ******/
   /****** 出库单（wh_goods_issue）   状态（1-未完成，2-已完成）	status  ******/
   /****** 物品入库（item_receipt）   状态（1-未完成，2-已完成）	status  ******/
   /****** 入库单—WH_GOODS_RECEIPT(STATUS)                               ******/
   /****** 状态（1-未完成，2-已完成） ******/
   working                /* 1-未完成 */                  CONSTANT NUMBER := 1;
   done                   /* 2-已完成 */                  CONSTANT NUMBER := 2;
END;
/
