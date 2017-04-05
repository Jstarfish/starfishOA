CREATE OR REPLACE PACKAGE epublisher_sjz IS
   /****** 石家庄印制厂对应的包装码规格 ******/
   /****** 1、箱码长度  ******/
   /****** 2、盒码长度  ******/
   /****** 3、本码长度  ******/
   /****** 4、票码长度  ******/
   len_trunk                /* 箱码长度 */                  CONSTANT NUMBER := 5;
   len_box                  /* 盒码长度 */                  CONSTANT NUMBER := 2;
   len_package              /* 本码长度 */                  CONSTANT NUMBER := 7;
   len_ticket               /* 票码长度 */                  CONSTANT NUMBER := 3;
   ticket_start             /* 一本中的起始票号 */          CONSTANT NUMBER := 100;

   len_fast_identity_code   /* 奖符长度 */                  CONSTANT NUMBER := 5;
   fast_identity_code_pos   /* 奖符偏移量 */                CONSTANT NUMBER := 17;
END;
/
