CREATE OR REPLACE PACKAGE epaid_status IS
   /****** 兑奖状态（1-成功、2-非法票、3-已兑奖、4-中大奖、5-未中奖、6-未销售、7-新票）	status  ******/
   succed               /* 1-成功 */                    CONSTANT NUMBER := 1;
   invalid              /* 2-非法票 */                  CONSTANT NUMBER := 2;
   paid                 /* 3-已兑奖 */                  CONSTANT NUMBER := 3;
   bigreward            /* 4-中大奖 */                  CONSTANT NUMBER := 4;
   nowin                /* 5-未中奖 */                  CONSTANT NUMBER := 5;
   nosale               /* 6-未销售 */                  CONSTANT NUMBER := 6;
   newticket            /* 7-新票   */                  CONSTANT NUMBER := 7;
   terminate            /* 8-批次终结 */                CONSTANT NUMBER := 8;
END;
