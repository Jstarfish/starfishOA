CREATE OR REPLACE PACKAGE eadj_change_type IS
   /****** 调节基金变更类型（1、期次开奖滚入；2、弃奖滚入；3、期次开奖自动拨出；4、手工拨出到奖池；5、发行费手工拨入调节基金； 6、其他金额手工拨入调节基金；7、期次开奖抹零滚入；8、初始化设置。） ******/
   in_issue_reward           /* 1=期次开奖滚入             */          CONSTANT NUMBER := 1;
   in_issue_abandon          /* 2=弃奖滚入                 */          CONSTANT NUMBER := 2;
   out_issue_pool            /* 3=期次开奖自动拨出         */          CONSTANT NUMBER := 3;
   out_issue_pool_manual     /* 4=手工拨出到奖池           */          CONSTANT NUMBER := 4;
   in_commission             /* 5=发行费手工拨入调节基金   */          CONSTANT NUMBER := 5;
   in_other                  /* 6=其他金额手工拨入调节基金 */          CONSTANT NUMBER := 6;
   in_issue_trunc_winning    /* 7=期次开奖抹零滚入         */          CONSTANT NUMBER := 7;
   sys_init                  /* 8=初始化设置               */          CONSTANT NUMBER := 8;
END;
/