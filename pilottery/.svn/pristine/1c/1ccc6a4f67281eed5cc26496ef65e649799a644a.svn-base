CREATE OR REPLACE PACKAGE eorder_status IS
   /****** 订单、出货单、调拨单、退货单状态 ******/
   /****** 状态（1-已提交，2-已撤销，3-已受理，4-已发货，5-收货中，6-已收货，7-已审批，8-已拒绝） ******/
   applyed                /* 1-已提交 */                  CONSTANT NUMBER := 1;
   canceled               /* 2-已撤销 */                  CONSTANT NUMBER := 2;
   agreed                 /* 3-已受理 */                  CONSTANT NUMBER := 3;
   sent                   /* 4-已发货 */                  CONSTANT NUMBER := 4;
   receiving              /* 5-收货中 */                  CONSTANT NUMBER := 5;
   received               /* 6-已收货 */                  CONSTANT NUMBER := 6;
   audited                /* 7-已审批 */                  CONSTANT NUMBER := 7;
   refused                /* 8-已拒绝 */                  CONSTANT NUMBER := 8;
END;
/
