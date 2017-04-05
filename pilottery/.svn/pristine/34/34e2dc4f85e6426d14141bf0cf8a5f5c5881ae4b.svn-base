CREATE OR REPLACE PACKAGE ebroken_source IS
   /******* 适用于以下表：                                                   ******/
   /*******    2.1.5.16 损毁单（wh_broken_recoder）                          ******/
   /*******        生成来源（1-人工录入，2-调拨单生成，3-盘点生成）	source  ******/

   manual_input                 /* 1-人工录入   */                  CONSTANT NUMBER := 1;
   trans_bill                   /* 2-调拨单生成 */                  CONSTANT NUMBER := 2;
   check_point                  /* 3-盘点生成   */                  CONSTANT NUMBER := 3;
END;
/
