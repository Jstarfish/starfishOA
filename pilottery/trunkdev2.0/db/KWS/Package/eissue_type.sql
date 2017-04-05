CREATE OR REPLACE PACKAGE eissue_type IS
   /******适用于以下表：                                                  ******/
   /******   2.1.5.8 出库单（wh_goods_issue）                             ******/
   /******       出库类型（1-调拨出库、2-出货单出库，3-损毁出库，4-站点退货）	issue_type ******/

   trans_bill                     /* 1-调拨出库   */                  CONSTANT NUMBER := 1;
   delivery_order                 /* 2-出货单出库 */                  CONSTANT NUMBER := 2;
   broken                         /* 3-损毁出库   */                  CONSTANT NUMBER := 3;
   agency_return                  /* 4-站点退货   */                  CONSTANT NUMBER := 4;
END;
