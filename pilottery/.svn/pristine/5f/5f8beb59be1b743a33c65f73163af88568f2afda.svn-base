CREATE OR REPLACE PACKAGE eflow_type IS
   /****** 提供给以下表使用： ******/
   /******     机构资金流水（flow_org）                  ******/
   /******     站点资金流水（flow_agency）               ******/
   /******     市场管理员资金流水（flow_market_manager） ******/

   charge                       /* 1-充值                               */     CONSTANT NUMBER := 1;
   withdraw                     /* 2-提现                               */     CONSTANT NUMBER := 2;
   carry                        /* 3-彩票调拨入库（机构）               */     CONSTANT NUMBER := 3;
   org_comm                     /* 4-彩票调拨入库佣金（机构）           */     CONSTANT NUMBER := 4;
   sale_comm                    /* 5-销售佣金（站点）                   */     CONSTANT NUMBER := 5;
   pay_comm                     /* 6-兑奖佣金（站点）                   */     CONSTANT NUMBER := 6;
   sale                         /* 7-销售（站点）                       */     CONSTANT NUMBER := 7;
   paid                         /* 8-兑奖（站点）                       */     CONSTANT NUMBER := 8;
   charge_for_agency            /* 9-市场管理员为站点充值（管理员）     */     CONSTANT NUMBER := 9;
   fund_return                  /* 10-现金上缴（管理员）                */     CONSTANT NUMBER := 10;
   agency_return                /* 11-站点退货（站点）                  */     CONSTANT NUMBER := 11;
   org_return                   /* 12-彩票调拨出库（机构）              */     CONSTANT NUMBER := 12;
   cancel_comm                  /* 13-撤销佣金（站点）                  */     CONSTANT NUMBER := 13;
   withdraw_for_agency          /* 14-市场管理员为站点提现（管理员）    */     CONSTANT NUMBER := 14;

   org_agency_pay_comm          /* 21-站点兑奖导致机构佣金（机构）      */     CONSTANT NUMBER := 21;
   org_agency_pay               /* 22-站点兑奖导致机构增加资金（机构）  */     CONSTANT NUMBER := 22;
   org_center_pay_comm          /* 23-中心兑奖导致机构佣金（机构）      */     CONSTANT NUMBER := 23;
   org_center_pay               /* 24-中心兑奖导致机构增加资金（机构）  */     CONSTANT NUMBER := 24;
   org_comm_org_return          /* 31-彩票调拨出库退佣金（机构）        */     CONSTANT NUMBER := 31;

   /***********************************************************************************************************/
   /**********************           以下内容用于销售站           *********************************************/
   /***********************************************************************************************************/
   lottery_sale_comm            /* 43-电脑票销售佣金                    */     CONSTANT NUMBER := 43;
   lottery_pay_comm             /* 44-电脑票兑奖佣金                    */     CONSTANT NUMBER := 44;
   lottery_sale                 /* 45-电脑票销售                        */     CONSTANT NUMBER := 45;
   lottery_pay                  /* 41-电脑票兑奖                        */     CONSTANT NUMBER := 41;
   lottery_cancel               /* 42-电脑票退票                        */     CONSTANT NUMBER := 42;
   lottery_cancel_comm          /* 47-电脑票退销售佣金                  */     CONSTANT NUMBER := 47;

   lottery_fail_sale_comm       /* 53-交易失败_电脑票销售佣金（交易失败）  */     CONSTANT NUMBER := 53;
   lottery_fail_pay_comm        /* 54-交易失败_电脑票兑奖佣金（交易失败）  */     CONSTANT NUMBER := 54;
   lottery_fail_sale            /* 55-交易失败_电脑票销售（交易失败）      */     CONSTANT NUMBER := 55;
   lottery_fail_pay             /* 51-交易失败_电脑票兑奖（交易失败）      */     CONSTANT NUMBER := 51;
   lottery_fail_cancel          /* 52-交易失败_电脑票退票（交易失败）      */     CONSTANT NUMBER := 52;
   lottery_fail_cancel_comm     /* 57-交易失败_电脑票退销售佣金（交易失败）*/     CONSTANT NUMBER := 57;
   /***********************************************************************************************************/

END;
