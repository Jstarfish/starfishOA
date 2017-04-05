CREATE OR REPLACE PACKAGE egame_issue_status IS
   /****** 游戏期次状态(0=预排/1=预售/2=游戏期开始/3=期即将关闭...) ******/
   prearrangement                   /* 0=预排 */                    CONSTANT NUMBER := 0;
   presale                          /* 1=预售 */                    CONSTANT NUMBER := 1;
   issueopen                        /* 2=游戏期开始 */              CONSTANT NUMBER := 2;
   issueclosing                     /* 3=期即将关闭 */              CONSTANT NUMBER := 3;
   issueclosed                      /* 4=游戏期关闭 */              CONSTANT NUMBER := 4;
   issuesealed                      /* 5=数据封存完毕 */            CONSTANT NUMBER := 5;
   enteringdrawcodes                /* 6=开奖号码已录入 */          CONSTANT NUMBER := 6;
   drawcodesmatchingcompleted       /* 7=销售已经匹配 */            CONSTANT NUMBER := 7;
   prizepoolentered                 /* 8=已录入 */                  CONSTANT NUMBER := 8;
   localprizecalculationdone        /* 9=本地算奖完成 */            CONSTANT NUMBER := 9;
   prizeleveladjustmentdone         /* 10=奖级调整完毕 */           CONSTANT NUMBER := 10;
   prizeleveladjustmentconfirmed    /* 11=开奖确认 */               CONSTANT NUMBER := 11;
   issuedatastoragecompleted        /* 12=中奖数据已录入数据库 */   CONSTANT NUMBER := 12;
   issuecompleted                   /* 13=期结全部完成 */           CONSTANT NUMBER := 13;
END;
