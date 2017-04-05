CREATE OR REPLACE PACKAGE eagency_status IS
   /****** 销售站状态(1=可用/2=已禁用/3=已清退) ******/
   enabled                  /* 1=可用 */                CONSTANT NUMBER := 1;
   disabled                 /* 2=已禁用 */              CONSTANT NUMBER := 2;
   cancelled                /* 3=已清退*/               CONSTANT NUMBER := 3;
END;
/
