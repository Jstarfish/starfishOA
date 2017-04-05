CREATE OR REPLACE PACKAGE eticket_status IS
   /****** 损毁单-损毁原因（41-被盗、42-损坏、43-丢失） ******/
   /****** 状态（11-在库、12-在站点，20-在途，31-已销售、41-被盗、42-损坏、43-丢失） ******/
   in_warehouse         /* 11-在库 */                  CONSTANT NUMBER := 11;
   in_agency            /* 12-在站点 */                CONSTANT NUMBER := 12;
   on_way               /* 20-在途 */                  CONSTANT NUMBER := 20;
   in_mm                /* 21-管理员持有 */            CONSTANT NUMBER := 21;
   saled                /* 31-已销售 */                CONSTANT NUMBER := 31;
   stolen               /* 41-被盗 */                  CONSTANT NUMBER := 41;
   broken               /* 42-损坏 */                  CONSTANT NUMBER := 42;
   lost                 /* 43-丢失 */                  CONSTANT NUMBER := 43;
END;

