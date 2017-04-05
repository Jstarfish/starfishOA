CREATE OR REPLACE PACKAGE eschedule_status IS
   /****** 终端升级计划状态(1=计划中/2=已执行/3=已取消) ******/
   planning         /* 1=计划中 */      CONSTANT NUMBER := 1;
   executed         /* 2=已执行 */      CONSTANT NUMBER := 2;
   cancelled        /* 3=已取消 */      CONSTANT NUMBER := 3;
END;
/
