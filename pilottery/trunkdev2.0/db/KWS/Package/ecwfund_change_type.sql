CREATE OR REPLACE PACKAGE ecwfund_change_type IS
   /****** 公益金变更类型（1、期次开奖滚入；2、弃奖滚入；） ******/
   in_from_issue_reward     /* 1=期次开奖滚入             */         CONSTANT NUMBER := 1;
   in_from_abandon          /* 2=弃奖滚入             */             CONSTANT NUMBER := 2;
END;
/