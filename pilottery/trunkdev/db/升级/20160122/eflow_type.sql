CREATE OR REPLACE PACKAGE eflow_type IS
   /****** 提供给以下表使用： ******/
   /******     机构资金流水（flow_org）                  ******/
   /******     站点资金流水（flow_agency）               ******/
   /******     市场管理员资金流水（flow_market_manager） ******/
   /****** 资金类型（1-充值，2-提现，3-彩票调拨，4-机构佣金（专用于正向调拨），5-销售佣金，6-兑奖佣金，7-销售，8-兑奖，9-为站点充值，10-现金上缴，11-站点退货，12-机构退货，13-撤销佣金，14-市场管理员为站点提现  ******/
   /******           21-机构佣金之销售明细，22-机构佣金之兑奖明细，23-机构佣金之退票明细，31-退机构佣金之调拨退货） add @2016-01-22 by chenzhen ******/

   charge                       /* 1-充值       */                  CONSTANT NUMBER := 1;
   withdraw                     /* 2-提现       */                  CONSTANT NUMBER := 2;
   carry                        /* 3-彩票调拨   */                  CONSTANT NUMBER := 3;
   org_comm                     /* 4-机构佣金（专用于正向调拨） */  CONSTANT NUMBER := 4;
   sale_comm                    /* 5-销售佣金   */                  CONSTANT NUMBER := 5;
   pay_comm                     /* 6-兑奖佣金   */                  CONSTANT NUMBER := 6;
   sale                         /* 7-销售       */                  CONSTANT NUMBER := 7;
   paid                         /* 8-兑奖       */                  CONSTANT NUMBER := 8;
   charge_for_agency            /* 9-市场管理员为站点充值 */        CONSTANT NUMBER := 9;
   fund_return                  /* 10-现金上缴  */                  CONSTANT NUMBER := 10;
   agency_return                /* 11-站点退货  */                  CONSTANT NUMBER := 11;
   org_return                   /* 12-机构退货  */                  CONSTANT NUMBER := 12;
   cancel_comm                  /* 13-撤销佣金  */                  CONSTANT NUMBER := 13;
   withdraw_for_agency          /* 14-市场管理员为站点提现 */       CONSTANT NUMBER := 14;

   org_comm_agency_sale         /* 21-机构佣金之销售明细    */      CONSTANT NUMBER := 21;
   org_comm_pay                 /* 22-机构佣金之兑奖明细    */      CONSTANT NUMBER := 22;
   org_comm_agency_return       /* 23-机构佣金之退票明细    */      CONSTANT NUMBER := 23;
   org_comm_org_return          /* 31-退机构佣金之调拨退货  */      CONSTANT NUMBER := 31;
END;
/
