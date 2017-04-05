CREATE OR REPLACE PACKAGE ereceipt_type IS
   /****** 适用于以下表：                                                                    ******/
   /****** 2.1.5.10 入库单（wh_goods_receipt）                                               ******/
   /******     入库类型（1-批次入库、2-调拨单入库、3-退货入库、4-站点入库）	receipt_type   ******/

   batch                     /* 1-批次入库   */                  CONSTANT NUMBER := 1;
   trans_bill                /* 2-调拨单入库 */                  CONSTANT NUMBER := 2;
   return_back               /* 3-退货入库   */                  CONSTANT NUMBER := 3;
   agency                    /* 4-站点入库   */                  CONSTANT NUMBER := 4;
END;
