CREATE OR REPLACE PACKAGE egametype IS
   /****** 游戏类型(1=基诺/2=乐透/3=数字) ******/
   keno                     /* 1=基诺 */                CONSTANT NUMBER := 1;
   lotto                    /* 2=乐透 */                CONSTANT NUMBER := 2;
   digit                    /* 3=数字 */                CONSTANT NUMBER := 3;
   sports                   /* 4=足彩 */                CONSTANT NUMBER := 4;
END;
/