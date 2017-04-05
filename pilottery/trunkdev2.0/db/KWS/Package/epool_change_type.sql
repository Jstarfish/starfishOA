CREATE OR REPLACE PACKAGE epool_change_type IS
   /****** 奖池变更类型（1、期次开奖滚入；2、弃奖滚入；3、调节基金自动拨入；4、调节基金手动拨入；5、发行费手动拨入；6、其他来源手动拨入；7、奖池初始化设置。） ******/
   in_issue_reward           /* 1=期次开奖滚入             */          CONSTANT NUMBER := 1;
   in_issue_abandon          /* 2=弃奖滚入                 */          CONSTANT NUMBER := 2;
   in_issue_pool_auto        /* 3=调节基金自动拨入         */          CONSTANT NUMBER := 3;
   in_issue_pool_manual      /* 4=调节基金手动拨入         */          CONSTANT NUMBER := 4;
   in_commission             /* 5=发行费手工拨入           */          CONSTANT NUMBER := 5;
   in_other                  /* 6=其他来源手动拨入         */          CONSTANT NUMBER := 6;
   sys_init                  /* 7=奖池初始化设置           */          CONSTANT NUMBER := 7;
END;
/