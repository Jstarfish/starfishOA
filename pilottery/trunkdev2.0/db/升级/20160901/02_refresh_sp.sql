set feedback off 
prompt 正在建立[PACKAGE -> dbtool.sql ]...... 
CREATE OR REPLACE PACKAGE dbtool IS

   -- 设置数据库错误参数（初始化）
   PROCEDURE set_success (
      errcode IN OUT NUMBER,
      errmesg IN OUT STRING
   );

   -- 设置数据库错误参数（错误信息）
   PROCEDURE set_dberror
   (
      errcode IN OUT NUMBER,
      errmesg IN OUT STRING
   );

   -- 用法: select * from table(dbtool.strsplit('1,2,3,4,5'))
   FUNCTION strsplit
   (
      p_value VARCHAR2,
      p_split VARCHAR2 := ','
   ) RETURN tabletype
      PIPELINED;

   -- 输出“[value]”格式的字符串
   function format_line(p_value varchar2) return varchar2;
   
   -- 调试打印输出
   procedure p(p_value varchar2);

END;
/

CREATE OR REPLACE PACKAGE BODY dbtool IS
   -- 设置数据库错误参数（初始化）
   PROCEDURE set_success
   (
      errcode IN OUT NUMBER,
      errmesg IN OUT STRING
   ) IS
   BEGIN
      errcode := 0;
      errmesg := 'Success';
   END set_success;

   -- 设置数据库错误参数（错误信息）
   PROCEDURE set_dberror
   (
      errcode IN OUT NUMBER,
      errmesg IN OUT STRING
   ) IS
   BEGIN
      errcode := SQLCODE;
      errmesg := SQLERRM;
   END set_dberror;

   FUNCTION strsplit
   (
      p_value VARCHAR2,
      p_split VARCHAR2 := ','
   )
   -- 用法: select * from table(dbtool.strsplit('1,2,3,4,5'))
    RETURN tabletype
      PIPELINED IS
      v_idx       INTEGER;
      v_str       VARCHAR2(500);
      v_strs_last VARCHAR2(4000) := p_value;

   BEGIN
      v_strs_last := TRIM(v_strs_last);
      LOOP
         v_idx := instr(v_strs_last, p_split);
         v_idx := nvl(v_idx,0);
         EXIT WHEN v_idx = 0;
         v_str       := substr(v_strs_last, 1, v_idx - 1);
         v_strs_last := substr(v_strs_last, v_idx + 1);
         PIPE ROW(v_str);
      END LOOP;
      PIPE ROW(v_strs_last);
      RETURN;

   END strsplit;

   function format_line(p_value varchar2) return varchar2 is
   begin
      return '[' || nvl(p_value, 'NULL') || ']';
   end format_line;

   procedure p(p_value varchar2) is
   begin
     dbms_output.put_line(format_line(p_value));
   end p;

BEGIN
   NULL;
END;
/ 
/ 
prompt 正在建立[PACKAGE -> eabandon_reward_collect.sql ]...... 
CREATE OR REPLACE PACKAGE eabandon_reward_collect IS
   /****** 弃奖方向 ******/
   pool                /* 1=奖池 */                  CONSTANT NUMBER := 1;
   adj                 /* 2=调节基金 */              CONSTANT NUMBER := 2;
   fund                /* 3=公益金 */                CONSTANT NUMBER := 3;
END;
/ 
/ 
prompt 正在建立[PACKAGE -> eaccount_type.sql ]...... 
CREATE OR REPLACE PACKAGE eaccount_type IS
   /****** 适用于以下表：(账户类型（1-机构，2-站点）	account_type)  ******/
   /******    2.1.9.1 销售站（机构）中心充值（fund_charge_center）   ******/
   /******    2.1.9.2 销售站（机构）现金充值（FUND_CHARGE_CASH）     ******/
   /******    2.1.9.3 销售站（机构）提现（FUND_WITHDRAW）            ******/
   /******    2.1.9.4 销售站（机构）调账（FUND_TUNING）              ******/

   org                      /* 1-机构 */                  CONSTANT NUMBER := 1;
   agency                   /* 2-站点 */                  CONSTANT NUMBER := 2;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> eacc_status.sql ]...... 
CREATE OR REPLACE PACKAGE eacc_status IS
   /****** 账户状态（1-可用，2-停用，3-异常） ******/
   available                /* 1-可用 */                  CONSTANT NUMBER := 1;
   stoped                   /* 2-停用 */                  CONSTANT NUMBER := 2;
   abnormal                 /* 3-异常 */                  CONSTANT NUMBER := 3;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> eacc_type.sql ]...... 
CREATE OR REPLACE PACKAGE eacc_type IS
   /****** 账户类型（1-主要账户） ******/
   main_account                     /* 1-主要账户 */                  CONSTANT NUMBER := 1;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> eadj_change_type.sql ]...... 
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
/ 
prompt 正在建立[PACKAGE -> eadmin_login_status.sql ]...... 
CREATE OR REPLACE PACKAGE eadmin_login_status IS
   /****** 用户在线状态(1-在线，2-离线) ******/
   on_line                  /* 1=在线 */                CONSTANT NUMBER := 1;
   off_line                 /* 2=离线 */                CONSTANT NUMBER := 2;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> eadmin_status.sql ]...... 
CREATE OR REPLACE PACKAGE eadmin_status IS
   /****** 用户状态(1-可用，2-删除，3-由于密码原因停用) ******/
   AVAILIBLE                 /* 1=可用 */                  CONSTANT NUMBER := 1;
   DELETED                   /* 2=删除 */                  CONSTANT NUMBER := 2;
   PASSERROR                 /* 3=由于密码原因停用 */      CONSTANT NUMBER := 3;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> eagency_status.sql ]...... 
CREATE OR REPLACE PACKAGE eagency_status IS
   /****** 销售站状态(1=可用/2=已禁用/3=已清退) ******/
   enabled                  /* 1=可用 */                CONSTANT NUMBER := 1;
   disabled                 /* 2=已禁用 */              CONSTANT NUMBER := 2;
   cancelled                /* 3=已清退*/               CONSTANT NUMBER := 3;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> eagency_type.sql ]...... 
CREATE OR REPLACE PACKAGE eagency_type IS
   /****** 销售站类型(1=传统销售站/2=后缴款销售站/3=无纸化/4=中心销售站) ******/
   traditionalagency        /* 1=传统销售站*/           CONSTANT NUMBER := 1;
   accreditedagency         /* 2=后缴款销售站 */        CONSTANT NUMBER := 2;
   paperless                /* 3=无纸化*/               CONSTANT NUMBER := 3;
   center_agency            /* 4=中心销售站*/           CONSTANT NUMBER := 4;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> eapply_status.sql ]...... 
CREATE OR REPLACE PACKAGE eapply_status IS
   /****** 申请记录状态（1=已提交、2=已撤销、3=已审核、4=已拒绝、6-已提现、7=缴款成功） ******/
   /****** 适用于表 销售站（机构）现金充值（fund_charge_cash） 和 销售站（机构）提现（fund_withdraw） ******/
   applyed                  /* 1=已提交 */                  CONSTANT NUMBER := 1;
   canceled                 /* 2=已撤销 */                  CONSTANT NUMBER := 2;
   audited                  /* 3=已审核 */                  CONSTANT NUMBER := 3;
   resused                  /* 4=已拒绝 */                  CONSTANT NUMBER := 4;
   withdraw                 /* 6-已提现 */                  CONSTANT NUMBER := 6;
   charged                  /* 7=缴款成功 */                CONSTANT NUMBER := 7;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> earea_status.sql ]...... 
CREATE OR REPLACE PACKAGE earea_status IS
   /****** 区域状态（1=有效、2=无效） ******/
   valid                   /* 1=有效 */                CONSTANT NUMBER := 1;
   invalid                 /* 2=无效 */                CONSTANT NUMBER := 2;
END;
/ 
/ 
prompt 正在建立[PACKAGE -> earea_type.sql ]...... 
CREATE OR REPLACE PACKAGE earea_type IS
   /****** 区域类型(0=全国/1=省/2=市/3=区县) ******/
   country                  /* 0=全国 */                CONSTANT NUMBER := 0;
   province                 /* 1=省 */                  CONSTANT NUMBER := 1;
   city                     /* 2=市 */                  CONSTANT NUMBER := 2;
   district                 /* 3=区县 */                CONSTANT NUMBER := 3;
END;
/ 
/ 
prompt 正在建立[PACKAGE -> ebatch_item_status.sql ]...... 
CREATE OR REPLACE PACKAGE ebatch_item_status IS
   /****** 适用于以下表：                                                                              ******/
   /******    2.1.4.5 批次信息导入之包装（GAME_BATCH_IMPORT_DETAIL）   状态（1-启用，2-暂停，3-退市）	status   ******/
   /******    2.1.10.1 物品（item_items）                              状态（1-启用，2-暂停，3-退市）	status   ******/

   /****** 状态（1-启用，2-停用） ******/
   working                   /* 1-启用 */                  CONSTANT NUMBER := 1;
   pause                     /* 2-暂停 */                  CONSTANT NUMBER := 2;
   quited                    /* 3-退市 */                  CONSTANT NUMBER := 3;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> eboolean.sql ]...... 
CREATE OR REPLACE PACKAGE eboolean IS
   /****** 公共boolean型枚举状态(1=是|可用|成功/0=否|不可用|失败) ******/
   yesorenabled             /* 1=是|可用|成功 */        CONSTANT NUMBER := 1;
   noordisabled             /* 0=否|不可用|失败 */      CONSTANT NUMBER := 0;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> ebroken_source.sql ]...... 
CREATE OR REPLACE PACKAGE ebroken_source IS
   /******* 适用于以下表：                                                   ******/
   /*******    2.1.5.16 损毁单（wh_broken_recoder）                          ******/
   /*******        生成来源（1-人工录入，2-调拨单生成，3-盘点生成）	source  ******/

   manual_input                 /* 1-人工录入   */                  CONSTANT NUMBER := 1;
   trans_bill                   /* 2-调拨单生成 */                  CONSTANT NUMBER := 2;
   check_point                  /* 3-盘点生成   */                  CONSTANT NUMBER := 3;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> echarity_change_type.sql ]...... 
CREATE OR REPLACE PACKAGE echarity_change_type IS
   /****** 公益金变更类型（1、期次开奖滚入；2、弃奖滚入；） ******/
   in_from_issue_reward     /* 1=期次开奖滚入             */          CONSTANT NUMBER := 1;
   in_from_abandon          /* 2=发行费到奖池             */          CONSTANT NUMBER := 2;
END;
/ 
/ 
prompt 正在建立[PACKAGE -> eclaiming_scope.sql ]...... 
CREATE OR REPLACE PACKAGE eclaiming_scope IS
   /****** 兑奖范围（0=中心通兑、1=机构通兑、4=本站自兑） ******/
   center          /* 0=中心通兑 */      CONSTANT NUMBER := 0;
   org             /* 1=机构通兑 */      CONSTANT NUMBER := 1;
   agency          /* 4=本站自兑 */      CONSTANT NUMBER := 4;
END;
 
/ 
prompt 正在建立[PACKAGE -> ecomm_change_type.sql ]...... 
CREATE OR REPLACE PACKAGE ecomm_change_type IS
   /****** 发行费变更类型（1、期次开奖滚入；2、发行费到奖池；3、发行费到调节基金；） ******/
   in_from_issue_reward     /* 1=期次开奖滚入             */          CONSTANT NUMBER := 1;
   out_to_pool              /* 2=发行费到奖池             */          CONSTANT NUMBER := 2;
   out_to_adj               /* 3=发行费到调节基金         */          CONSTANT NUMBER := 3;
END;
/ 
/ 
prompt 正在建立[PACKAGE -> ecomm_type.sql ]...... 
CREATE OR REPLACE PACKAGE ecomm_type IS
   /****** 发行费类型（1、销售；2、兑奖；） ******/
   sale     /* 1=销售         */          CONSTANT NUMBER := 1;
   pay      /* 2=兑奖         */          CONSTANT NUMBER := 2;
END;
/ 
/ 
prompt 正在建立[PACKAGE -> ecp_result.sql ]...... 
CREATE OR REPLACE PACKAGE ecp_result IS
   /****** 适用于以下表：                                                                        ******/
   /******    2.1.5.12 盘点单（wh_check_point）   盘点结果（1-一致，2-盘亏，3-盘盈）	result    ******/
   /******    2.1.10.7 物品盘点（item_check）     盘点结果（1-一致，2-盘亏，3-盘盈）	result    ******/

   /****** 盘点结果（1-一致，2-盘亏，3-盘盈） ******/
   same                   /* 1-一致 */                  CONSTANT NUMBER := 1;
   less                   /* 2-盘亏 */                  CONSTANT NUMBER := 2;
   more                   /* 3-盘盈 */                  CONSTANT NUMBER := 3;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> ecp_status.sql ]...... 
CREATE OR REPLACE PACKAGE ecp_status IS
   /****** 适用于以下表：                                 ******/
   /******    2.1.5.12 盘点单（wh_check_point）           ******/
   /******        盘点状态（1-盘点中，2-盘点结束）	status ******/

   working                /* 1-盘点中   */                  CONSTANT NUMBER := 1;
   done                   /* 2-盘点结束 */                  CONSTANT NUMBER := 2;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> ecwfund_change_type.sql ]...... 
CREATE OR REPLACE PACKAGE ecwfund_change_type IS
   /****** 公益金变更类型（1、期次开奖滚入；2、弃奖滚入；） ******/
   in_from_issue_reward     /* 1=期次开奖滚入             */         CONSTANT NUMBER := 1;
   in_from_abandon          /* 2=弃奖滚入             */             CONSTANT NUMBER := 2;
END;
/ 
/ 
prompt 正在建立[PACKAGE -> edevice_status.sql ]...... 
CREATE OR REPLACE PACKAGE edevice_status IS
   /****** 设备状态(1=启用/2=暂停/3=停用) ******/
   enabled                  /* 1=启用 */                CONSTANT NUMBER := 1;
   disabled                 /* 2=暂停 */                CONSTANT NUMBER := 2;
   cancelled                /* 3=停用 */                CONSTANT NUMBER := 3;
END;
/ 
/ 
prompt 正在建立[PACKAGE -> edevice_type.sql ]...... 
CREATE OR REPLACE PACKAGE edevice_type IS
   /****** 设备类型（1=RNG） ******/
   rng                  /* 1=RNG */                CONSTANT NUMBER := 1;
END;
/ 
/ 
prompt 正在建立[PACKAGE -> edraw_state.sql ]...... 
CREATE OR REPLACE PACKAGE edraw_state IS
  /****** 期次开奖状态（0=不能开奖状态；1=开奖准备状态；2=数据整理状态；3=备份状态；4=备份完成；5=第一次输入完成；6=第二次输入完成；7=开奖号码审批通过；8=开奖号码审批失败；9=开奖号码已发送；10=派奖检索完成；11=派奖输入已发送；12=中奖统计完成；13=数据稽核已发送 ；14=数据稽核完成；15=期结确认已发送；16=开奖完成） ******/
  
  edraw_unvalid             /* 不能开奖状态                       */  CONSTANT NUMBER := 0;        
  edraw_ready               /* 开奖准备状态                       */  CONSTANT NUMBER := 1;        
  edraw_data_collected      /* 数据整理状态                       */  CONSTANT NUMBER := 2;        
  edraw_backup              /* 备份状态                           */  CONSTANT NUMBER := 3;        
  edraw_backuped            /* 备份完成        第一次输入结果     */  CONSTANT NUMBER := 4;        
  edraw_first_inputted      /* 第一次输入完成                     */  CONSTANT NUMBER := 5;        
  edraw_second_inputted     /* 第二次输入完成                     */  CONSTANT NUMBER := 6;        
  edraw_draw_number_pass    /* 开奖号码审批通过                   */  CONSTANT NUMBER := 7;        
  edraw_draw_number_reject  /* 开奖号码审批失败                   */  CONSTANT NUMBER := 8;        
  edraw_draw_number_sent    /* 开奖号码已发送                     */  CONSTANT NUMBER := 9;        
  edraw_prize_collected     /* 派奖检索完成                       */  CONSTANT NUMBER := 10;       
  edraw_prize_input_sent    /* 派奖输入已发送                     */  CONSTANT NUMBER := 11;       
  edraw_prize_stated        /* 中奖统计完成                       */  CONSTANT NUMBER := 12;       
  edraw_data_check_sent     /* 数据稽核已发送                     */  CONSTANT NUMBER := 13;       
  edraw_data_checked        /* 数据稽核完成                       */  CONSTANT NUMBER := 14;       
  edraw_confirm_sent        /* 期结确认已发送                     */  CONSTANT NUMBER := 15;       
  edraw_draw_finish         /* 开奖完成                           */  CONSTANT NUMBER := 16;       

END;
/
 
/ 
prompt 正在建立[PACKAGE -> eflow_type.sql ]...... 
CREATE OR REPLACE PACKAGE eflow_type IS
   /****** 提供给以下表使用： ******/
   /******     机构资金流水（flow_org）                  ******/
   /******     站点资金流水（flow_agency）               ******/
   /******     市场管理员资金流水（flow_market_manager） ******/

   charge                       /* 1-充值                               */     CONSTANT NUMBER := 1;
   withdraw                     /* 2-提现                               */     CONSTANT NUMBER := 2;

   sale_comm                    /* 5-销售佣金（站点）                   */     CONSTANT NUMBER := 5;
   pay_comm                     /* 6-兑奖佣金（站点）                   */     CONSTANT NUMBER := 6;
   sale                         /* 7-销售（站点）                       */     CONSTANT NUMBER := 7;
   paid                         /* 8-兑奖（站点）                       */     CONSTANT NUMBER := 8;
   agency_return                /* 11-站点退货（站点）                  */     CONSTANT NUMBER := 11;
   cancel_comm                  /* 13-撤销佣金（站点）                  */     CONSTANT NUMBER := 13;

   charge_for_agency            /* 9-市场管理员为站点充值（管理员）     */     CONSTANT NUMBER := 9;
   fund_return                  /* 10-现金上缴（管理员）                */     CONSTANT NUMBER := 10;
   withdraw_for_agency          /* 14-市场管理员为站点提现（管理员）    */     CONSTANT NUMBER := 14;

   carry                        /* 3-彩票调拨入库（机构）               */     CONSTANT NUMBER := 3;
   org_comm                     /* 4-彩票调拨入库佣金（机构）           */     CONSTANT NUMBER := 4;
   org_return                   /* 12-彩票调拨出库（机构）              */     CONSTANT NUMBER := 12;
   org_comm_org_return          /* 31-彩票调拨出库退佣金（机构）        */     CONSTANT NUMBER := 31;

   org_agency_pay_comm          /* 21-站点兑奖导致机构佣金（机构）      */     CONSTANT NUMBER := 21;
   org_agency_pay               /* 22-站点兑奖导致机构增加资金（机构）  */     CONSTANT NUMBER := 22;
   org_agency_sale_comm         /* 25-站点销售导致机构增加佣金（机构）  */     CONSTANT NUMBER := 25;
   org_center_pay_comm          /* 23-中心兑奖导致机构佣金（机构）      */     CONSTANT NUMBER := 23;
   org_center_pay               /* 24-中心兑奖导致机构增加资金（机构）  */     CONSTANT NUMBER := 24;
   
   org_lottery_agency_sale          /* 30-站点销售导致机构减少资金（机构）  */        CONSTANT NUMBER := 30;
   org_lottery_agency_pay_comm      /* 32-站点兑奖导致机构佣金（机构）      */        CONSTANT NUMBER := 32;
   org_lottery_agency_pay           /* 33-站点兑奖导致机构增加资金（机构）  */        CONSTANT NUMBER := 33;
   org_lottery_agency_sale_comm     /* 34-站点销售导致机构增加佣金（机构）  */        CONSTANT NUMBER := 34;
   org_lottery_cancel_comm          /* 35-站点或中心退票导致机构减少佣金（机构）  */  CONSTANT NUMBER := 35;
   org_lottery_agency_cancel        /* 40-站点退票导致机构增加资金（机构）  */        CONSTANT NUMBER := 40;
   org_lottery_center_pay_comm      /* 36-中心兑奖导致机构佣金（机构）      */        CONSTANT NUMBER := 36;
   org_lottery_center_pay           /* 37-中心兑奖导致机构增加资金（机构）  */        CONSTANT NUMBER := 37;
   org_lottery_center_cancel        /* 38-中心退票导致机构增加资金（机构）  */        CONSTANT NUMBER := 38;
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
/ 
prompt 正在建立[PACKAGE -> egame.sql ]...... 
CREATE OR REPLACE PACKAGE egame IS
  /****** 游戏编码（1=双色球；2=3D；4=七乐彩；5=时时彩；6=幸运农场） ******/

  ssq                 /* 1=双色球       */  CONSTANT NUMBER := 1;
  threed              /* 2=3D           */  CONSTANT NUMBER := 2;
  qlc                 /* 4=七乐彩       */  CONSTANT NUMBER := 4;
  ssc                 /* 5=时时彩       */  CONSTANT NUMBER := 5;
  koc6hc              /* 6=七龙星       */  CONSTANT NUMBER := 6;
  kocssc              /* 7=天天赢       */  CONSTANT NUMBER := 7;
  kockeno             /* 8=基诺         */  CONSTANT NUMBER := 8;
  kk2                 /* 9=快二         */  CONSTANT NUMBER := 9;
  kk3                 /* 11=快三        */  CONSTANT NUMBER := 11;
  s11q5               /* 12=11选5       */  CONSTANT NUMBER := 12;

END;
 
/ 
prompt 正在建立[PACKAGE -> egame_issue_status.sql ]...... 
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
/ 
/ 
prompt 正在建立[PACKAGE -> egame_open_type.sql ]...... 
CREATE OR REPLACE PACKAGE egame_open_type IS
   /****** 游戏开奖模式（1=快开、2=内部算奖、3=外部算奖）******/
   autolotterydraw                  /* 1=快开 */            CONSTANT NUMBER := 1;
   manuallotterydraw                /* 2=内部算奖 */        CONSTANT NUMBER := 2;
   inputlotterydraw                 /* 3=外部算奖 */        CONSTANT NUMBER := 3;
END;
/ 
/ 
prompt 正在建立[PACKAGE -> egame_status.sql ]...... 
CREATE OR REPLACE PACKAGE egame_status IS
   /****** 游戏状态(1=启用/2=暂停/3=停用) ******/
   enabled      /* 1=启用 */   CONSTANT NUMBER := 1;
   paused       /* 2=暂停 */   CONSTANT NUMBER := 2;
   cancelled    /* 3=停用 */   CONSTANT NUMBER := 3;
END;
/ 
/ 
prompt 正在建立[PACKAGE -> egame_type.sql ]...... 
CREATE OR REPLACE PACKAGE egametype IS
   /****** 游戏类型(1=基诺/2=乐透/3=数字) ******/
   keno                     /* 1=基诺 */                CONSTANT NUMBER := 1;
   lotto                    /* 2=乐透 */                CONSTANT NUMBER := 2;
   digit                    /* 3=数字 */                CONSTANT NUMBER := 3;
END;
/ 
/ 
prompt 正在建立[PACKAGE -> ehost_error.sql ]...... 
create or replace package ehost_error is
  /****** 适用于主机调用类sp，来源于主机程序                             ******/

  host_t_agency_err              /* 销售站不存在或未启动                                       */  constant number := 3;
  host_t_authenticate_err        /* 认证失败                                                   */  constant number := 4;
  host_t_namepwd_err             /* 用户名或密码错误                                           */  constant number := 5;
  host_t_term_disable_err        /* 终端不可用                                                 */  constant number := 6;
  host_t_cancel_agency_err       /* 退票销售站与售票销售站不匹配                               */  constant number := 7;

  host_t_teller_disable_err      /* 销售员不可用                                               */  constant number := 8;
  host_t_teller_signout_err      /* 销售员未登录                                               */  constant number := 9;
  host_t_term_signed_in_err      /* 此终端机上已有销售员登录                                   */  constant number := 10;
  host_t_teller_cleanout_err     /* 销售员已班结                                               */  constant number := 11;
  host_t_teller_unauthen_err     /* 销售员未授此操作权限                                       */  constant number := 12;
  host_t_teller_unexist          /* 销售员不存在                                               */  constant number := 13;

  host_game_disable_err          /* 游戏不可用                                                 */  constant number := 14;
  host_sell_disable_err          /* 游戏不可销售                                               */  constant number := 15;
  host_pay_disable_err           /* 游戏不可兑奖                                               */  constant number := 16;
  host_cancel_disable_err        /* 游戏不可取消                                               */  constant number := 17;
  host_game_subtype_err          /* 游戏玩法方式不支持                                         */  constant number := 18;
  host_claiming_scope_err        /* 不符合兑奖范围                                             */  constant number := 19;

  host_sell_data_err             /* 彩票销售选号错误                                           */  constant number := 20;
  host_sell_betline_err          /* 彩票销售超过最大行数(场次)限制                             */  constant number := 21;
  host_sell_bettimes_err         /* 彩票销售倍数错误                                           */  constant number := 22;
  host_sell_issuecount_err       /* 彩票销售期数错误                                           */  constant number := 23;
  host_sell_ticket_amount_err    /* 彩票销售金额错误                                           */  constant number := 24;
  host_sell_lack_amount_err      /* 账户余额不足                                               */  constant number := 25;
  host_tsn_err                   /* tsn错误                                                    */  constant number := 27;
  host_pay_lack_cash_err         /* 现金金额不足 (需要放入现金)                                */  constant number := 28;
  host_pay_big_winning_err       /* 中大奖，需要输入票面附加码(此错误码停止使用)               */  constant number := 29;
  host_ticket_not_found_err      /* 没有找到此彩票                                             */  constant number := 30;
  host_pay_paid_err              /* 彩票已兑奖                                                 */  constant number := 31;
  host_cancel_again_err          /* 彩票已退票                                                 */  constant number := 32;
  host_pay_not_win_err           /* 彩票未中奖                                                 */  constant number := 33;
  host_pay_not_draw_err          /* 彩票期还没有开奖                                           */  constant number := 34;
  host_pay_wait_draw_err         /* 彩票期等待开奖                                             */  constant number := 35;
  host_cancel_not_accept_err     /* 彩票退票失败                                               */  constant number := 36;
  host_lack_cash_err             /* 现金金额不足 (当执行取出现金操作时发生)                    */  constant number := 37;

  host_msg_data_err              /* 消息数据错误                                               */  constant number := 38;
  host_version_not_available_err /* 软件版本不可用                                             */  constant number := 39;
  host_gameresult_disable_err    /* 开奖结果不可用                                             */  constant number := 40;
  host_sell_noissue_err          /* 彩票销售无当前期可用                                       */  constant number := 41;
  host_sell_drawtime_err         /* 彩票销售获取开奖时间错误                                   */  constant number := 42;

  host_pay_multi_issue_err       /* 连续多期票，最后一期未结束，不能兑奖                       */  constant number := 43;
  host_teller_pay_limit_err      /* 超出销售员兑奖范围                                         */  constant number := 44;
  host_pay_wait_award_time_err   /* 未到兑奖开始时间                                           */  constant number := 45;
  host_pay_award_time_end_err    /* 兑奖时间已结束                                             */  constant number := 46;
  host_cancel_time_end_err       /* 已过最大撤消时间,不能退票                                  */  constant number := 47;
  host_pay_need_excode_err       /* 兑大奖需要附加码                                           */  constant number := 48;
  host_pay_excode_err            /* 兑大奖附加码错误                                           */  constant number := 49;

  host_pay_dayend_err            /* 兑奖日期已结止                                             */  constant number := 50;
  host_t_cancel_untrainer_err    /* 销售员退培训票                                             */  constant number := 51;
  host_t_cancel_trainer_err      /* 培训员退正常票                                             */  constant number := 52;
  host_t_pay_untrainer_err       /* 销售员兑培训票                                             */  constant number := 53;
  host_t_pay_trainer_err         /* 培训员兑正常票                                             */  constant number := 54;
  host_inquiry_issue_nofound_err /* 彩票期未找到                                               */  constant number := 55;

  host_game_servicetime_out_err  /* 当前不是彩票交易时段                                       */  constant number := 56;

  host_t_term_train_unreport_err /* 培训机不可查销售员报表                                     */  constant number := 57;

  host_pay_paying_err            /* 彩票正在兑奖中                                             */  constant number := 58;
  host_cancel_canceling_err      /* 彩票退票中                                                 */  constant number := 59;

  host_pay_gamelimit_err         /* 游戏兑奖限额： 系统保护阈值（所有的兑奖行为都受此参数限制）*/  constant number := 60;
  host_cancel_moneylimit_err     /* 退票超出限额                                               */  constant number := 61;
  host_flow_number_err           /* 交易流水号不匹配                                           */  constant number := 62;

  host_ap_token_err              /* ap业务token验证失败                                        */  constant number := 63;

  host_type_err                  /* 查询类型(type)错误                                         */  constant number := 64;

  host_t_agency_time_err         /* 超出销售站营业时间                                         */  constant number := 65;

  host_t_agency_type_err         /* 销售站类型不支持                                           */  constant number := 66;

  host_t_teller_signed_in_err    /* 此销售员已登录其他终端机                                   */  constant number := 67;
  host_t_token_expired_err       /* token失效，需要重新认证                                    */  constant number := 68;
  host_t_msn_err                 /* msn错误，需要重新登录                                      */  constant number := 69;

  -- 中心兑奖错误
  oms_pay_money_limit_err        /* 超出游戏兑奖保护金额                                       */  constant number := 17;
  oms_cancel_money_limit_err     /* 超出退票保护金额                                           */  constant number := 24;
  oms_org_not_auth_cancel_err    /* 机构不可退票                                               */  constant number := 27;
  oms_org_not_auth_pay_err       /* 机构不可兑奖                                               */  constant number := 28;
  
  -- 中心退票错误
  oms_result_cancel_again_err    /* 彩票已退票                                               */    constant number := 19;
  
end;
 
/ 
prompt 正在建立[PACKAGE -> eidcardtype.sql ]...... 
CREATE OR REPLACE PACKAGE eidcardtype IS
   /****** 身份证件类型(10=身份证/20=护照/30=军官证/40=士兵证/50=回乡证/90=其他证件) ******/
   idcard                   /* 10=身份证 */         CONSTANT NUMBER := 10;
   passport                 /* 20=护照 */           CONSTANT NUMBER := 20;
   millitaryofficercard     /* 30=军官证 */         CONSTANT NUMBER := 30;
   soldiercard              /* 40=士兵证 */         CONSTANT NUMBER := 40;
   homevisitpermit          /* 50=回乡证 */         CONSTANT NUMBER := 50;
   others                   /* 90=其他证件 */       CONSTANT NUMBER := 90;
END;
/ 
/ 
prompt 正在建立[PACKAGE -> eissue_type.sql ]...... 
CREATE OR REPLACE PACKAGE eissue_type IS
   /******适用于以下表：                                                  ******/
   /******   2.1.5.8 出库单（wh_goods_issue）                             ******/
   /******       出库类型（1-调拨出库、2-出货单出库，3-损毁出库，4-站点退货）	issue_type ******/

   trans_bill                     /* 1-调拨出库   */                  CONSTANT NUMBER := 1;
   delivery_order                 /* 2-出货单出库 */                  CONSTANT NUMBER := 2;
   broken                         /* 3-损毁出库   */                  CONSTANT NUMBER := 3;
   agency_return                  /* 4-站点退货   */                  CONSTANT NUMBER := 4;
END;
 
/ 
prompt 正在建立[PACKAGE -> emsg_disp_loc.sql ]...... 
CREATE OR REPLACE PACKAGE emsg_disp_loc IS
   /****** 终端即时消息显示位置（1=主屏、2=TDS、3=打印机） ******/
   main_screen        /* 1=主屏 */          CONSTANT NUMBER := 1;
   tds                /* 2=TDS */           CONSTANT NUMBER := 2;
   printer            /* 3=打印机 */        CONSTANT NUMBER := 3;

END;
/ 
/ 
prompt 正在建立[PACKAGE -> emsg_send_object.sql ]...... 
CREATE OR REPLACE PACKAGE emsg_send_object IS
   /****** 消息发送对象(0=全国/1=省/2=市/3=区县/4=销售站/5=销售终端/7=用户) ******/
   country                  /* 0=全国 */                CONSTANT NUMBER := 0;
   province                 /* 1=省 */                  CONSTANT NUMBER := 1;
   city                     /* 2=市 */                  CONSTANT NUMBER := 2;
   district                 /* 3=区县 */                CONSTANT NUMBER := 3;
   agency                   /* 4=销售站 */              CONSTANT NUMBER := 4;
   terminal                 /* 5=销售终端 */            CONSTANT NUMBER := 5;
   useraccount              /* 7=用户 */                CONSTANT NUMBER := 7;
END;
/ 
/ 
prompt 正在建立[PACKAGE -> eorder_status.sql ]...... 
CREATE OR REPLACE PACKAGE eorder_status IS
   /****** 订单、出货单、调拨单、退货单状态 ******/
   /****** 状态（1-已提交，2-已撤销，3-已受理，4-已发货，5-收货中，6-已收货，7-已审批，8-已拒绝） ******/
   applyed                /* 1-已提交 */                  CONSTANT NUMBER := 1;
   canceled               /* 2-已撤销 */                  CONSTANT NUMBER := 2;
   agreed                 /* 3-已受理 */                  CONSTANT NUMBER := 3;
   sent                   /* 4-已发货 */                  CONSTANT NUMBER := 4;
   receiving              /* 5-收货中 */                  CONSTANT NUMBER := 5;
   received               /* 6-已收货 */                  CONSTANT NUMBER := 6;
   audited                /* 7-已审批 */                  CONSTANT NUMBER := 7;
   refused                /* 8-已拒绝 */                  CONSTANT NUMBER := 8;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> eorg_status.sql ]...... 
CREATE OR REPLACE PACKAGE eorg_status IS
   /****** 部门状态（1-可用，2-删除） ******/
   available                  /* 1-可用 */                CONSTANT NUMBER := 1;
   deleted                    /* 2-删除 */                CONSTANT NUMBER := 2;
END;
 
/ 
prompt 正在建立[PACKAGE -> eorg_type.sql ]...... 
CREATE OR REPLACE PACKAGE eorg_type IS
   /****** 部门类别（1-公司,2-代理） ******/
   company                  /* 1-公司 */                CONSTANT NUMBER := 1;
   agent                    /* 2-代理 */                CONSTANT NUMBER := 2;
END;
/ 
/ 
prompt 正在建立[PACKAGE -> epaid_status.sql ]...... 
CREATE OR REPLACE PACKAGE epaid_status IS
   /****** 兑奖状态（1-成功、2-非法票、3-已兑奖、4-中大奖、5-未中奖、6-未销售、7-新票）	status  ******/
   succed               /* 1-成功 */                    CONSTANT NUMBER := 1;
   invalid              /* 2-非法票 */                  CONSTANT NUMBER := 2;
   paid                 /* 3-已兑奖 */                  CONSTANT NUMBER := 3;
   bigreward            /* 4-中大奖 */                  CONSTANT NUMBER := 4;
   nowin                /* 5-未中奖 */                  CONSTANT NUMBER := 5;
   nosale               /* 6-未销售 */                  CONSTANT NUMBER := 6;
   newticket            /* 7-新票   */                  CONSTANT NUMBER := 7;
   terminate            /* 8-批次终结 */                CONSTANT NUMBER := 8;
END;
 
/ 
prompt 正在建立[PACKAGE -> eplan_flow.sql ]...... 
CREATE OR REPLACE PACKAGE eplan_flow IS
   /****** 方案应对的处理流程（1-a计划，2-b计划）	plan_flow ******/
   plan_a          /* 1-a计划 */                  CONSTANT NUMBER := 1;
   plan_b          /* 2-b计划 */                  CONSTANT NUMBER := 2;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> epool_change_type.sql ]...... 
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
/ 
prompt 正在建立[PACKAGE -> epublisher_code.sql ]...... 
CREATE OR REPLACE PACKAGE epublisher_code IS
   /****** 印制厂商 ******/
   /****** 1、箱码长度  ******/
   /****** 2、盒码长度  ******/
   /****** 3、本码长度  ******/
   /****** 4、票码长度  ******/
   sjz                /* 石家庄 */                    CONSTANT NUMBER := 1;
   zc3c               /* 中彩三场 */                  CONSTANT NUMBER := 3;
END;
 
/ 
prompt 正在建立[PACKAGE -> epublisher_sjz.sql ]...... 
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
 
/ 
prompt 正在建立[PACKAGE -> ereceipt_type.sql ]...... 
CREATE OR REPLACE PACKAGE ereceipt_type IS
   /****** 适用于以下表：                                                                    ******/
   /****** 2.1.5.10 入库单（wh_goods_receipt）                                               ******/
   /******     入库类型（1-批次入库、2-调拨单入库、3-退货入库、4-站点入库）	receipt_type   ******/

   batch                     /* 1-批次入库   */                  CONSTANT NUMBER := 1;
   trans_bill                /* 2-调拨单入库 */                  CONSTANT NUMBER := 2;
   return_back               /* 3-退货入库   */                  CONSTANT NUMBER := 3;
   agency                    /* 4-站点入库   */                  CONSTANT NUMBER := 4;
END;
 
/ 
prompt 正在建立[PACKAGE -> ereward_code_input_methold.sql ]...... 
CREATE OR REPLACE PACKAGE ereward_code_input_methold IS
   /****** 开奖号码输入模式（1=手工；2=光盘） ******/
   manual     /* 1=手工 */          CONSTANT NUMBER := 1;
   cdrom      /* 2=光盘 */          CONSTANT NUMBER := 2;
END;
/ 
/ 
prompt 正在建立[PACKAGE -> error_msg_multi.sql ]...... 
create or replace package error_msg is
  /****************************************************/
  /****** Error Messages - Multi-lingual Version ******/
  /****************************************************/

  /*----- Common ------*/
  err_comm_password_not_match     constant  varchar2(4000) := '{"en":"Password error.","zh":"用户密码错误"}';
  err_comm_trade_type_error       constant  varchar2(4000) := '{"en":"TRADE TYPE error.","zh":"交易类型错误"}';
  err_common_1                    constant varchar2(4000) := '{"en":"Database error.","zh":"数据库操作异常"}';
  err_common_2                    constant varchar2(4000) := '{"en":"Invalid status.","zh":"无效的状态值"}';
  err_common_3                    constant varchar2(4000) := '{"en":"Object does not exist.","zh":"对象不存在"}';
  err_common_4                    constant varchar2(4000) := '{"en":"Parameter name error.","zh":"参数名称错误"}';
  err_common_5                    constant varchar2(4000) := '{"en":"Invalid parameter.","zh":"无效的参数"}';
  err_common_6                    constant varchar2(4000) := '{"en":"Invalid code.","zh":"编码不符合规范"}';
  err_common_7                    constant varchar2(4000) := '{"en":"Code overflow.","zh":"编码溢出"}';
  err_common_8                    constant varchar2(4000) := '{"en":"The data is being processed by others.","zh":"数据正在被别人处理中"}';
  err_common_9                    constant varchar2(4000) := '{"en":"The deletion requrement cannot be satisfied.","zh":"不符合删除条件"}';
  err_common_100                  constant varchar2(4000) := '{"en":"The person does not exist.","zh":"无此人"}';
  err_common_101                  constant varchar2(4000) := '{"en":"The warehouse does not exist.","zh":"无此仓库"}';
  err_common_102                  constant varchar2(4000) := '{"en":"There is no batch in this plan.","zh":"无此方案批次"}';
  err_common_103                  constant varchar2(4000) := '{"en":"Self-reference exists in the input lottery object.","zh":"输入的彩票对象中，存在自包含的现象"}';
  err_common_104                  constant varchar2(4000) := '{"en":"Error occurred when updating the lottery status.","zh":"更新“即开票”状态时，出现错误"}';
  err_common_105                  constant varchar2(4000) := '{"en":"Wrong operation parameter, must be 1, 2 or 3.","zh":"操作类型参数错误，应该为1，2，3"}';
  err_common_106                  constant varchar2(4000) := '{"en":"Wrong operation parameter, must be 1, 2 or 3.","zh":"操作类型参数错误，应该为1，2，3"}';
  err_common_107                  constant varchar2(4000) := '{"en":"The batches of this plan are disabled.","zh":"此方案的批次处于非可用状态"}';
  err_common_108                  constant varchar2(4000) := '{"en":"The plan or batch data is empty.","zh":"方案或批次数据为空"}';
  err_common_109                  constant varchar2(4000) := '{"en":"No lottery object found in the input parameters.","zh":"输入参数中，没有发现彩票对象"}';


  err_p_import_batch_file_1       constant varchar2(4000) := '{"en":"The batch information already exists.","zh":"批次数据信息已经存在"}';
  err_p_import_batch_file_2       constant varchar2(4000) := '{"en":"The plan and batch information in the data file are inconsistent with the user input.","zh":"数据文件中所记录的方案与批次信息，与界面输入的方案和批次不符"}';
  err_p_import_batch_file_3       constant varchar2(4000) := '{"en":"The import file has error. PACKS_EVERY_TRUNK(line 7) divided by BOXES_EVERY_TRUNK(line 15) is not a integer","zh":"批次导入文件（包装参数）出现逻辑关系错误：{每箱本数/每箱盒数} 的结果不是一个整数"}';

  err_p_batch_inbound_1           constant varchar2(4000) := '{"en":"The trunk has already been received.","zh":"此箱已经入库"}';
  err_p_batch_inbound_2           constant varchar2(4000) := '{"en":"The warehouse does not exist.","zh":"无此仓库"}';
  err_p_batch_inbound_3           constant varchar2(4000) := '{"en":"The batch does not exist.","zh":"无此批次"}';
  err_p_batch_inbound_4           constant varchar2(4000) := '{"en":"Wrong operation parameter, must be 1, 2 or 3.","zh":"操作类型参数错误，应该为1，2，3"}';
  err_p_batch_inbound_5           constant varchar2(4000) := '{"en":"Batch receipt code error occurred when continuing or completing lottery receipt. Receipt code does not exist.","zh":"在进行继续入库和完结入库操作时，输入的批次入库单错误，未发现此批次入库单"}';
  err_p_batch_inbound_6           constant varchar2(4000) := '{"en":"Batch receipt code error occurred when continuing lottery receipt, or this batch receipt has already completed.","zh":"在进行继续入库时，输入的批次入库单错误，或者此批次入库单已经完结"}';
  err_p_batch_inbound_7           constant varchar2(4000) := '{"en":"The batch receipt has already completed, please do not repeat the process.","zh":"此批次的方案已经入库完毕，请不要重复进行"}';

  err_f_get_warehouse_code_1      constant varchar2(4000) := '{"en":"The input account type is not \"jg\", \"zd\" or \"mm\".","zh":"输入的账户类型不是“jg”,“zd”,“mm”"}';

  err_f_get_lottery_info_1        constant varchar2(4000) := '{"en":"The input \"Trunk\" code is out of the valid range.","zh":"输入的“箱”号超出合法的范围"}';
  err_f_get_lottery_info_2        constant varchar2(4000) := '{"en":"The input \"Box\" code is out of the valid range.","zh":"输入的“盒”号超出合法的范围"}';
  err_f_get_lottery_info_3        constant varchar2(4000) := '{"en":"The input \"Pack\" code is out of the valid range.","zh":"输入的“本”号超出合法的范围"}';

  err_p_tb_outbound_3             constant varchar2(4000) := '{"en":"Transfer code error occurred when continuing lottery issue, or the corresponding delivery order has completed.","zh":"在进行继续出库时，输入的调拨单号错误，或者此调拨单对应的出库单，出库已经完结"}';
  err_p_tb_outbound_4             constant varchar2(4000) := '{"en":"The transfer order status is incorrect when the transfer issue has completed.","zh":"调拨单出库完结时，调拨单状态不合法"}';
  err_p_tb_outbound_14            constant varchar2(4000) := '{"en":"The actual issued quantity for this transfer order is inconsistent with the applied quantity.","zh":"调拨单实际出库数量与申请数量不符"}';
  err_p_tb_outbound_5             constant varchar2(4000) := '{"en":"The transfer order status is incorrect when the transfer issue is being processed.","zh":"进行调拨单出库时，调拨单状态不合法"}';
  err_p_tb_outbound_6             constant varchar2(4000) := '{"en":"Cannot obtain the delivery code.","zh":"不能获得出库单编号"}';
  err_p_tb_outbound_7             constant varchar2(4000) := '{"en":"The actual number of tickets being delivered should not be larger than the number as specified in the transfer order.","zh":"实际出库票数不应该大于调拨单计划出库票数"}';

  err_p_tb_inbound_2              constant varchar2(4000) := '{"en":"The input parent institution of the warehouse is inconsistent with that as specified in the transfer order.","zh":"输入的仓库所属机构，与调拨单中标明的接收机构不符"}';
  err_p_tb_inbound_3              constant varchar2(4000) := '{"en":"Transfer code error occurred when continuing lottery receipt, or the corresponding receipt order has completed.","zh":"在进行继续入库时，输入的调拨单号错误，或者此调拨单对应的入库单，入库已经完结"}';
  err_p_tb_inbound_4              constant varchar2(4000) := '{"en":"The transfer order status is not as expected when the transfer receipt has completed.","zh":"调拨单入库完结时，调拨单状态与预期值不符"}';
  err_p_tb_inbound_5              constant varchar2(4000) := '{"en":"The transfer order status is incorrect when the transfer receipt is being processed.","zh":"进行调拨单入库时，调拨单状态不合法"}';
  err_p_tb_inbound_6              constant varchar2(4000) := '{"en":"Cannot find the corresponding receipt code with respect to the input transfer code when adding lottery tickets. It may be caused by having entered a wrong transfer code.","zh":"继续添加彩票时，未能按照输入的调拨单编号，查询到相应的入库单编号。可能传入了错误的调拨单编号"}';
  err_p_tb_inbound_25             constant varchar2(4000) := '{"en":"The transfer order does not exist.","zh":"未查询到此调拨单"}';
  err_p_tb_inbound_7              constant varchar2(4000) := '{"en":"The actual number of tickets being transferred should be smaller than or equal to the applied quantity.","zh":"实际调拨票数，应该小于或者等于申请调拨票数"}';

  err_p_batch_end_1               constant varchar2(4000) := '{"en":"The person does not exist.","zh":"无此人"}';
  err_p_batch_end_2               constant varchar2(4000) := '{"en":"The plan is disabled.","zh":"此方案已经不可用"}';
  err_p_batch_end_3               constant varchar2(4000) := '{"en":"Cannot terminate this batch because \"in transit\" or \"in outlet\" lottery ticket may exist.","zh":"存在“在途”和“在站点”的彩票，不能执行批次终结"}';
  err_p_batch_end_4               constant varchar2(4000) := '{"en":"Cannot terminate this batch because \"in transit\" or \"in outlet\" lottery ticket may exist.","zh":"存在“在途”和“在站点”的彩票，不能执行批次终结"}';
  err_p_batch_end_5               constant varchar2(4000) := '{"en":"Cannot terminate this batch because \"in transit\" or \"in outlet\" lottery ticket may exist.","zh":"存在“在途”和“在站点”的彩票，不能执行批次终结"}';


  err_p_gi_outbound_4             constant varchar2(4000) := '{"en":"The delivery order status is incorrect when the delivery issue has completed.","zh":"出货单出库完结时，出货单状态不合法"}';
  err_p_gi_outbound_5             constant varchar2(4000) := '{"en":"The delivery order status is incorrect when the delivery issue is being processed.","zh":"进行出货单出库时，出货单状态不合法"}';
  err_p_gi_outbound_6             constant varchar2(4000) := '{"en":"Cannot obtain the issue code.","zh":"不能获得出库单编号"}';
  err_p_gi_outbound_1             constant varchar2(4000) := '{"en":"The person does not exist.","zh":"无此人"}';
  err_p_gi_outbound_3             constant varchar2(4000) := '{"en":"Transfer code error occurred when continuing lottery issue, or the corresponding delivery order has completed.","zh":"在进行继续出库时，输入的调拨单号错误，或者此调拨单对应的出库单，出库已经完结"}';
  err_p_gi_outbound_10            constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when transferring a \"Trunk\".","zh":"调拨“箱”时，“本”数据出现异常"}';
  err_p_gi_outbound_12            constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Box\". Or the trunk status may be incorrect.","zh":"调拨“盒”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
  err_p_gi_outbound_13            constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when transferring a \"Box\".","zh":"调拨“盒”时，对应的“本”数据异常"}';
  err_p_gi_outbound_16            constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Pack\". Or the trunk status may be incorrect.","zh":"调拨“本”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
  err_p_gi_outbound_7             constant varchar2(4000) := '{"en":"Repeated items found for issue.","zh":"出现重复的出库物品"}';
  err_p_gi_outbound_8             constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Trunk\". Or the trunk status may be incorrect.","zh":"调拨“箱”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
  err_p_gi_outbound_9             constant varchar2(4000) := '{"en":"Exception occurred in \"Box\" data when transferring a \"Trunk\".","zh":"调拨“箱”时，“盒”数据出现异常"}';
  err_p_gi_outbound_2             constant varchar2(4000) := '{"en":"The warehouse does not exist.","zh":"无此仓库"}';
  err_p_gi_outbound_11            constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the box is already inside the issue details.","zh":"盒对应的箱已经出现在出库明细中，逻辑校验失败"}';
  err_p_gi_outbound_14            constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the issue details.","zh":"本对应的箱已经出现在出库明细中，逻辑校验失败"}';
  err_p_gi_outbound_15            constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the issue details.","zh":"本对应的箱已经出现在出库明细中，逻辑校验失败"}';
  err_p_gi_outbound_17            constant varchar2(4000) := '{"en":"Exceeds the \"maximum allowable credit\" as held by this manager.","zh":"超过此管理员允许持有的“最高赊票金额”"}';

  err_p_rr_inbound_1              constant varchar2(4000) := '{"en":"The person does not exist.","zh":"无此人"}';
  err_p_rr_inbound_2              constant varchar2(4000) := '{"en":"The warehouse does not exist.","zh":"无此仓库"}';
  err_p_rr_inbound_3              constant varchar2(4000) := '{"en":"Wrong operation parameter, must be 1, 2 or 3.","zh":"操作类型参数错误，应该为1，2，3"}';
  err_p_rr_inbound_4              constant varchar2(4000) := '{"en":"The return delivery status is incorrect when the return delivery receipt has completed. Expected status: [Receiving].","zh":"还货单入库完结时，还货单状态不合法，期望的换货单状态应该为[收货中]"}';
  err_p_rr_inbound_24             constant varchar2(4000) := '{"en":"Cannot find the return delivery due to incorrect return code.","zh":"还货单编号不合法，未查询到此换货单"}';
  err_p_rr_inbound_5              constant varchar2(4000) := '{"en":"The return delivery status is incorrect when the return delivery receipt has completed. Expected status: [Approved].","zh":"还货单入库完结时，还货单状态不合法，期望的换货单状态应该为[已审批]"}';
  err_p_rr_inbound_15             constant varchar2(4000) := '{"en":"The return delivery status is incorrect when the return delivery receipt is being processed. Expected status: [Receiving].","zh":"还货单继续入库时，还货单状态不合法，期望的换货单状态应该为[接收中]"}';
  err_p_rr_inbound_6              constant varchar2(4000) := '{"en":"Cannot obtain the receipt code.","zh":"不能获得入库单编号"}';
  err_p_rr_inbound_7              constant varchar2(4000) := '{"en":"Repeated items found for receipt.","zh":"出现重复的入库物品"}';
  err_p_rr_inbound_8              constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when transferring a \"Box\".","zh":"调拨“盒”时，“本”数据出现异常"}';
  err_p_rr_inbound_18             constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when transferring a \"Trunk\".","zh":"调拨“箱”时，“本”数据出现异常"}';
  err_p_rr_inbound_28             constant varchar2(4000) := '{"en":"Exception occurred in \"Box\" data when transferring a \"Trunk\".","zh":"调拨“箱”时，“盒”数据出现异常"}';
  err_p_rr_inbound_38             constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Trunk\". Or the trunk status may be incorrect.","zh":"调拨“箱”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
  err_p_rr_inbound_9              constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the box is already inside the receipt details.","zh":"盒对应的箱已经出现在入库明细中，逻辑校验失败"}';
  err_p_rr_inbound_10             constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Box\". Or the trunk status may be incorrect.","zh":"调拨“盒”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
  err_p_rr_inbound_11             constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the receipt details.","zh":"本对应的箱已经出现在入库明细中，逻辑校验失败"}';
  err_p_rr_inbound_12             constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the receipt details.","zh":"本对应的箱已经出现在入库明细中，逻辑校验失败"}';
  err_p_rr_inbound_13             constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Pack\". Or the trunk status may be incorrect.","zh":"调拨“本”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
  err_p_rr_inbound_14             constant varchar2(4000) := '{"en":"There is no information on this plan and batch in the warehouse manager inventory.","zh":"仓库管理员的库存中，没有此方案和批次的库存信息"}';

  err_p_ar_inbound_1              constant varchar2(4000) := '{"en":"The person does not exist.","zh":"无此人"}';
  err_p_ar_inbound_3              constant varchar2(4000) := '{"en":"Repeated items found for receipt.","zh":"出现重复的入库物品"}';
  err_p_ar_inbound_4              constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when processing a \"Trunk\". Or the trunk status may be incorrect.","zh":"处理“箱”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
  err_p_ar_inbound_5              constant varchar2(4000) := '{"en":"Exception occurred in \"Box\" data when processing a \"Trunk\".","zh":"处理“箱”时，“盒”数据出现异常"}';
  err_p_ar_inbound_6              constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when processing a \"Trunk\".","zh":"处理“箱”时，“本”数据出现异常"}';
  err_p_ar_inbound_7              constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the box is already inside the receipt details.","zh":"盒对应的箱已经出现在入库明细中，逻辑校验失败"}';
  err_p_ar_inbound_10             constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when processing a \"Box\". Or the trunk status may be incorrect.","zh":"处理“盒”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
  err_p_ar_inbound_38             constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when processing a \"Box\".","zh":"处理“盒”时，“本”数据出现异常"}';
  err_p_ar_inbound_11             constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the receipt details.","zh":"本对应的箱已经出现在入库明细中，逻辑校验失败"}';
  err_p_ar_inbound_12             constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the receipt details.","zh":"本对应的箱已经出现在入库明细中，逻辑校验失败"}';
  err_p_ar_inbound_13             constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when processing a \"Pack\". Or the trunk status may be incorrect.","zh":"处理“本”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
  err_p_ar_inbound_14             constant varchar2(4000) := '{"en":"There is no information on this plan and batch in the warehouse manager inventory.","zh":"仓库管理员的库存中，没有此方案和批次的库存信息"}';
  err_p_ar_inbound_15             constant varchar2(4000) := '{"en":"The outlet has not set up the sales commission rate of this lottery plan.","zh":"该销售站未设置此方案对应的销售佣金比例"}';
  err_p_ar_inbound_16             constant varchar2(4000) := '{"en":"The outlet does not have an account or the account status is incorrect.","zh":"销售站无账户或相应账户状态不正确"}';
  err_p_ar_inbound_17             constant varchar2(4000) := '{"en":"Insufficient outlet balance.","zh":"销售站余额不足"}';

  err_p_institutions_create_1     constant varchar2(4000) := '{"en":"Institution code cannot be empty.","zh":"部门编码不能为空！"}';
  err_p_institutions_create_2     constant varchar2(4000) := '{"en":"Institution name cannot be empty.","zh":"部门名称不能为空！"}';
  err_p_institutions_create_3     constant varchar2(4000) := '{"en":"Insittution director does not exist.","zh":"部门负责人不存在！"}';
  err_p_institutions_create_4     constant varchar2(4000) := '{"en":"Contact phone cannot be empty.","zh":"部门联系电话不能为空！"}';
  err_p_institutions_create_5     constant varchar2(4000) := '{"en":"This institution code already exists in the system.","zh":"部门编码在系统中已经存在！"}';
  err_p_institutions_create_6     constant varchar2(4000) := '{"en":"Area has been repeatedly governed by other insittution.","zh":"选择区域已经被其他部门管辖！"}';

  err_p_institutions_modify_1     constant varchar2(4000) := '{"en":"Original institution code cannot be empty.","zh":"部门原编码不能为空！"}';
  err_p_institutions_modify_2     constant varchar2(4000) := '{"en":"Other relevant staff in this institution cannot change the institution code.","zh":"部门关联其他人员不能修改编码！"}';

  err_p_outlet_create_1           constant varchar2(4000) := '{"en":"Institution code cannot be empty.","zh":"部门编码不能为空！"}';
  err_p_outlet_create_2           constant varchar2(4000) := '{"en":"The institution is disabled.","zh":"部门无效！"}';
  err_p_outlet_create_3           constant varchar2(4000) := '{"en":"Area code cannot be empty.","zh":"区域编码不能为空！"}';
  err_p_outlet_create_4           constant varchar2(4000) := '{"en":"The area is disabled.","zh":"区域无效！"}';

  err_p_outlet_modify_1           constant varchar2(4000) := '{"en":"The outlet code already exists.","zh":"站点编码已存在！"}';
  err_p_outlet_modify_2           constant varchar2(4000) := '{"en":"The outlet code is invalid.","zh":"站点编码不符合规范！"}';
  err_p_outlet_modify_3           constant varchar2(4000) := '{"en":"Cannot modify outlet code when there is a transaction.","zh":"站点有缴款业务不能变更编码！"}';
  err_p_outlet_modify_4           constant varchar2(4000) := '{"en":"Cannot modify outlet code when there is an order.","zh":"站点有订单业务不能变更编码！"}';

  err_p_outlet_plan_auth_1        constant varchar2(4000) := '{"en":"The delegated plan cannot be empty.","zh":"授权方案不能为空！"}';
  err_p_outlet_plan_auth_2        constant varchar2(4000) := '{"en":"The commission rate of the delegated plan cannot exceed the commission rate of the parent institution.","zh":"授权方案代销费率不能超出所属机构代销费率！"}';

  err_p_org_plan_auth_1           constant varchar2(4000) := '{"en":"The delegated plan cannot be empty.","zh":"授权方案不能为空！"}';
  err_p_org_plan_auth_2           constant varchar2(4000) := '{"en":"The commission rate of the delegated plan cannot exceed 1000.","zh":"授权方案代销费率不能超出1000！"}';

  err_p_warehouse_create_1        constant varchar2(4000) := '{"en":"Warehouse code cannot be empty.","zh":"编码不能为空！"}';
  err_p_warehouse_create_2        constant varchar2(4000) := '{"en":"Warehouse code cannot repeat.","zh":"编码不能重复！"}';
  err_p_warehouse_create_3        constant varchar2(4000) := '{"en":"Warehouse name cannot be empty.","zh":"名称不能为空！"}';
  err_p_warehouse_create_4        constant varchar2(4000) := '{"en":"Warehouse address cannot be empty.","zh":"地址不能为空！"}';
  err_p_warehouse_create_5        constant varchar2(4000) := '{"en":"Warehouse director does not exist.","zh":"负责人不存在！"}';
  err_p_warehouse_create_6        constant varchar2(4000) := '{"en":" has already had administering warehouse.","zh":"-已经有管辖仓库！"}';

  err_p_warehouse_modify_1        constant varchar2(4000) := '{"en":"Warehouse code does not exist.","zh":"编码不存在！"}';

  err_p_admin_create_1            constant varchar2(4000) := '{"en":"Real name cannot be empty.","zh":"真实姓名不能为空！"}';
  err_p_admin_create_2            constant varchar2(4000) := '{"en":"Login name cannot be empty.","zh":"登录名不能为空！"}';
  err_p_admin_create_3            constant varchar2(4000) := '{"en":"Login name already exists.","zh":"登录名已存在！"}';

  err_p_outlet_topup_1            constant varchar2(4000) := '{"en":"Outlet code cannot be empty.","zh":"站点编码不能为空！"}';
  err_p_outlet_topup_2            constant varchar2(4000) := '{"en":"User does not exist or is disabled.","zh":"用户不存在或者无效！"}';
  err_p_outlet_topup_3            constant varchar2(4000) := '{"en":"Password cannot be empty.","zh":"密码不能为空！"}';
  err_p_outlet_topup_4            constant varchar2(4000) := '{"en":"Password is invalid.","zh":"密码无效！"}';

  err_p_institutions_topup_1      constant varchar2(4000) := '{"en":"Institution code cannot be empty.","zh":"机构编码不能为空！"}';
  err_p_institutions_topup_2      constant varchar2(4000) := '{"en":"The current user is disabled.","zh":"当前用户无效！"}';
  err_p_institutions_topup_3      constant varchar2(4000) := '{"en":"The current institution is disabled.","zh":"当前机构无效！"}';

  err_p_outlet_withdraw_app_1     constant varchar2(4000) := '{"en":"Insufficient balance for cash withdraw.","zh":"提现金额不足！"}';
  err_p_outlet_withdraw_con_1     constant varchar2(4000) := '{"en":"Application form cannot be empty.","zh":"申请单不能为空！"}';
  err_p_outlet_withdraw_con_2     constant varchar2(4000) := '{"en":"Application form does not exist or is not approved.","zh":"申请单不存在或状态非审批通过！"}';
  err_p_outlet_withdraw_con_3     constant varchar2(4000) := '{"en":"The outlet does not exist or the password is incorrect.","zh":"站点不存在或密码无效！"}';

  err_p_warehouse_delete_1        constant varchar2(4000) := '{"en":"Cannot delete a warehouse with item inventory.","zh":"仓库中有库存物品，不可进行删除！"}';

  err_p_warehouse_check_step1_1   constant varchar2(4000) := '{"en":"The inventory check name cannot be empty.","zh":"盘点名称不能为空！"}';
  err_p_warehouse_check_step1_2   constant varchar2(4000) := '{"en":"The warehouse for check cannot be empty.","zh":"库房不能为空！"}';
  err_p_warehouse_check_step1_3   constant varchar2(4000) := '{"en":"The check operator is disabled.","zh":"盘点人无效！"}';
  err_p_warehouse_check_step1_4   constant varchar2(4000) := '{"en":"The warehouse is disabled or is in checking.","zh":"仓库无效或者正在盘点中！"}';
  err_p_warehouse_check_step1_5   constant varchar2(4000) := '{"en":"There are no lottery tickets or items for check in this warehouse.","zh":"仓库无彩票物品，没有必要盘点！"}';

  err_p_warehouse_check_step2_1   constant varchar2(4000) := '{"en":"The inventory check code cannot be empty.","zh":"盘点单不能为空！"}';
  err_p_warehouse_check_step2_2   constant varchar2(4000) := '{"en":"The inventory check does not exist or has completed.","zh":"盘点单不存在或已完结！"}';
  err_p_warehouse_check_step2_3   constant varchar2(4000) := '{"en":"The scanned information cannot be empty.","zh":"扫描信息不能为空！"}';

  err_p_mm_fund_repay_1           constant varchar2(4000) := '{"en":"Market manager cannot be empty.","zh":"市场管理员不能为空！"}';
  err_p_mm_fund_repay_2           constant varchar2(4000) := '{"en":"Market manager does not exist or is deleted.","zh":"市场管理员已经删除或不存在！"}';
  err_p_mm_fund_repay_3           constant varchar2(4000) := '{"en":"Current operator cannot be empty.","zh":"当前操作人不能为空！"}';
  err_p_mm_fund_repay_4           constant varchar2(4000) := '{"en":"Current operator does not exist or is deleted.","zh":"当前操作人已经删除或不存在！"}';
  err_p_mm_fund_repay_5           constant varchar2(4000) := '{"en":"The repayment amount is invalid.","zh":"还款金额无效！"}';

  err_p_fund_change_1             constant varchar2(4000) := '{"en":"Insufficient account balance.","zh":"账户余额不足"}';
  err_p_fund_change_2             constant varchar2(4000) := '{"en":"Incorrect fund type.","zh":"资金类型不合法"}';
  err_p_fund_change_3             constant varchar2(4000) := '{"en":"The outlet account does not exist, or the account status is incorrect.","zh":"未发现销售站的账户，或者账户状态不正确"}';

  err_p_lottery_reward_3          constant varchar2(4000) := '{"en":"This lottery ticket has not been on sale yet.","zh":"彩票未被销售"}';
  err_p_lottery_reward_4          constant varchar2(4000) := '{"en":"This lottery ticket has already been paid.","zh":"彩票已兑奖"}';
  err_p_lottery_reward_5          constant varchar2(4000) := '{"en":"Incorrect system parameter, please contact system administrator for recalibration.","zh":"系统参数值不正确，请联系管理员，重新设置"}';
  err_p_lottery_reward_6          constant varchar2(4000) := '{"en":"The outlet has not set up the payout commission rate of this lottery plan.","zh":"该销售站未设置此方案对应的兑奖佣金比例"}';
  err_p_lottery_reward_7          constant varchar2(4000) := '{"en":"The outlet has not set up the payout commission rate of this lottery plan.","zh":"该销售站未设置此方案对应的兑奖佣金比例"}';

  err_f_check_import_ticket       constant varchar2(4000) := '{"en":"Wrong input parameter, must be 1 or 2.","zh":"输入参数错误，应该为1或者2"}';

  err_f_check_ticket_include_1    constant varchar2(4000) := '{"en":"This lottery trunk has already been processed.","zh":"此箱彩票已经被处理"}';
  err_f_check_ticket_include_2    constant varchar2(4000) := '{"en":"This lottery box has already been processed.","zh":"此盒彩票已经被处理"}';
  err_f_check_ticket_include_3    constant varchar2(4000) := '{"en":"This lottery pack has already been processed.","zh":"此本彩票已经被处理"}';

  err_p_item_delete_1             constant varchar2(4000) := '{"en":"Item code cannot be empty.","zh":"物品编码不能为空"}';
  err_p_item_delete_2             constant varchar2(4000) := '{"en":"The item does not exist.","zh":"不存在此物品"}';
  err_p_item_delete_3             constant varchar2(4000) := '{"en":"This item currently exists in inventory.","zh":"该物品当前有库存"}';

  err_p_withdraw_approve_1        constant varchar2(4000) := '{"en":"Withdraw code cannot be empty.","zh":"提现编码不能为空"}';
  err_p_withdraw_approve_2        constant varchar2(4000) := '{"en":"The withdraw code does not exist or the withdraw record is disabled.","zh":"提现编码不存在或单据状态无效！"}';
  err_p_withdraw_approve_3        constant varchar2(4000) := '{"en":"Permission denied for cash withdraw approval.","zh":"审批结果超出定义范围！"}';
  err_p_withdraw_approve_4        constant varchar2(4000) := '{"en":"Insufficient balance.","zh":"余额不足！"}';
  err_p_withdraw_approve_5        constant varchar2(4000) := '{"en":"outlet cash withdraw failure.","zh":"销售站资金处理失败！"}';

  err_p_item_outbound_1           constant varchar2(4000) := '{"en":"This item currently does not exist in inventory.","zh":"该物品当前无库存"}';
  err_p_item_outbound_2           constant varchar2(4000) := '{"en":"This item is not enough in inventory.","zh":"该物品在库存不足"}';

  err_p_item_damage_1             constant varchar2(4000) := '{"en":"Item code cannot be empty.","zh":"物品编码不能为空"}';
  err_p_item_damage_2             constant varchar2(4000) := '{"en":"Warehouse code cannot be empty.","zh":"仓库编码不能为空"}';
  err_p_item_damage_3             constant varchar2(4000) := '{"en":"Damage quantity must be positive.","zh":"损毁物品数量必须为正数"}';
  err_p_item_damage_4             constant varchar2(4000) := '{"en":"The operator does not exist.","zh":"损毁登记人不存在"}';
  err_p_item_damage_5             constant varchar2(4000) := '{"en":"The item does not exist or is deleted.","zh":"该物品不存在或已删除"}';
  err_p_item_damage_6             constant varchar2(4000) := '{"en":"The warehouse does not exist or is deleted.","zh":"该仓库不存在或已删除"}';
  err_p_item_damage_7             constant varchar2(4000) := '{"en":"The item does not exist in this warehouse.","zh":"该仓库中不存在此物品"}';
  err_p_item_damage_8             constant varchar2(4000) := '{"en":"The item quantity in this warehouse is less than the input damage quantity.","zh":"该仓库中此物品的数量小于登记损毁的数量"}';

  err_p_ar_outbound_10            constant varchar2(4000) := '{"en":"Cannot refund this ticket because paid tickets may exist.","zh":"有彩票已经兑奖，不能退票"}';
  err_p_ar_outbound_20            constant varchar2(4000) := '{"en":"The corresponding trunk data is missing from the lottery receipt.","zh":"对应的箱数据，没有在入库单中找到"}';
  err_p_ar_outbound_30            constant varchar2(4000) := '{"en":"The corresponding box data is missing from the lottery receipt.","zh":"对应的盒数据，没有在入库单中找到"}';
  err_p_ar_outbound_40            constant varchar2(4000) := '{"en":"The corresponding pack data is missing from the lottery receipt.","zh":"对应的本数据，没有在入库单中找到"}';
  err_p_ar_outbound_50            constant varchar2(4000) := '{"en":"The corresponding trunk data has been found in the receipt, but its status or its outlet information is incorrect.","zh":"对应的箱数据已经在入库单中找到，但是状态或者所属站点信息不正确"}';
  err_p_ar_outbound_60            constant varchar2(4000) := '{"en":"Cannot find the sales record of the refunding ticket.","zh":"未查询到待退票的售票记录"}';
  err_p_ar_outbound_70            constant varchar2(4000) := '{"en":"Exceeds the \"maximum allowable credit\" as held by this manager.","zh":"超过此管理员允许持有的“最高赊票金额”"}';

  err_p_ticket_perferm_1          constant varchar2(4000) := '{"en":"This warehouse is stopped or is in checking. This operation is denied.","zh":"此仓库状态处于盘点或停用状态，不能进行出入库操作"}';
  err_p_ticket_perferm_3          constant varchar2(4000) := '{"en":"The plan of this batch does not exist in the system.","zh":"系统中不存在此批次的彩票方案"}';
  err_p_ticket_perferm_5          constant varchar2(4000) := '{"en":"The plan of this batch has already been disabled.","zh":"此批次的彩票方案已经停用"}';
  err_p_ticket_perferm_10         constant varchar2(4000) := '{"en":"This lottery trunk does not exist.","zh":"此箱彩票不存在"}';
  err_p_ticket_perferm_110        constant varchar2(4000) := '{"en":"This lottery box does not exist.","zh":"此盒彩票不存在"}';
  err_p_ticket_perferm_120        constant varchar2(4000) := '{"en":"The status of this lottery \"Box\" is not as expected, current status: ","zh":"此“盒”彩票的状态与预期不符，当前状态为"}';
  err_p_ticket_perferm_130        constant varchar2(4000) := '{"en":"The system status of this lottery \"Box\" is OPEN, therefore trunk-wise processing is not allowed.","zh":"此“盒”彩票在系统中处于开箱状态，因此不能进行整箱处理"}';
  err_p_ticket_perferm_140        constant varchar2(4000) := '{"en":"Error may exist in the inventory information of this lottery \"Box\", please double-check before proceed.","zh":"此“盒”彩票库存信息可能存在错误，请查询以后再进行操作"}';
  err_p_ticket_perferm_150        constant varchar2(4000) := '{"en":"Exception occurred during lottery processing, please contact the system maintenance for support.","zh":"处理彩票时，出现数据异常，请联系系统人员"}';
  err_p_ticket_perferm_160        constant varchar2(4000) := '{"en":"Exception occurred in the \"Pack\" data when processing a \"Box\". Possible errors include: 1-Some packs in this box have been removed, 2-The status of some packs in this box is not as expected.","zh":"处理“盒”时，“本”数据出现异常。可能的错误为：1-此盒对应的某些本已经被转移，2-此盒对应的某些本的状态与预期状态不符"}';
  err_p_ticket_perferm_20         constant varchar2(4000) := '{"en":"The status of this lottery \"Trunk\" is not as expected, current status: ","zh":"此“箱”彩票的状态与预期不符，当前状态为"}';
  err_p_ticket_perferm_210        constant varchar2(4000) := '{"en":"This lottery pack does not exist.","zh":"此本彩票不存在"}';
  err_p_ticket_perferm_220        constant varchar2(4000) := '{"en":"The status of this lottery \"Pack\" is not as expected, current status: ","zh":"此“本”彩票的状态与预期不符，当前状态为"}';
  err_p_ticket_perferm_230        constant varchar2(4000) := '{"en":"Error may exist in the inventory information of this lottery \"Pack\", please double-check before proceed.","zh":"此“本”彩票库存信息可能存在错误，请查询以后再进行操作"}';
  err_p_ticket_perferm_240        constant varchar2(4000) := '{"en":"Exception occurred during lottery processing, please contact the system maintenance for support.","zh":"处理彩票时，出现数据异常，请联系系统人员"}';
  err_p_ticket_perferm_30         constant varchar2(4000) := '{"en":"The system status of this lottery \"Trunk\" is OPEN, therefore trunk-wise processing is not allowed.","zh":"此“箱”彩票在系统中处于开箱状态，因此不能进行整箱处理"}';
  err_p_ticket_perferm_40         constant varchar2(4000) := '{"en":"Error may exist in the inventory information of this lottery \"Trunk\", please double-check before proceed.","zh":"此“箱”彩票库存信息可能存在错误，请查询以后再进行操作"}';
  err_p_ticket_perferm_50         constant varchar2(4000) := '{"en":"Exception occurred during lottery processing, please contact the system maintenance for support.","zh":"处理彩票时，出现数据异常，请联系系统人员"}';
  err_p_ticket_perferm_60         constant varchar2(4000) := '{"en":"Exception occurred in the \"Box\" data when processing a \"Trunk\". Possible errors include: 1-Some boxes in this trunk have been opened for use, 2-Some boxes in this trunk have been removed, 3-The status of some boxes in this trunk is not as expected.","zh":"处理“箱”时，“盒”数据出现异常。可能的错误为：1-此箱对应的某些盒已经被拆开使用，2-此箱对应的某些盒已经被转移，3-此箱对应的某些盒的状态与预期状态不符"}';
  err_p_ticket_perferm_70         constant varchar2(4000) := '{"en":"Exception occurred in the \"Box\" data when processing a \"Trunk\". Possible errors include: 1-Some packs in this trunk have been removed, 2-The status of some packs in this trunk is not as expected.","zh":"处理“箱”时，“盒”数据出现异常。可能的错误为：1-此箱对应的某些本已经被转移，2-此箱对应的某些本的状态与预期状态不符"}';

  err_f_get_sys_param_1           constant varchar2(4000) := '{"en":"The system parameter is not set. parameter: ","zh":"系统参数未被设置，参数编号为："}';

  err_p_teller_create_1           constant varchar2(4000) := '{"en":"Invalid Agency Code!","zh":"无效的销售站"}';
  err_p_teller_create_2           constant varchar2(4000) := '{"en":"The teller code is already used.","zh":"销售员编号重复"}';
  err_p_teller_create_3           constant varchar2(4000) := '{"en":"The teller code is out of the range.","zh":"输入的编码超出范围！"}';

  err_f_gen_teller_term_code_1    constant varchar2(4000) := '{"en":"The teller code is out of the range.","zh":"编码超出范围！"}';

  err_p_teller_status_change_1    constant varchar2(4000) := '{"en":"Invalid teller status!","zh":"无效的状态值"}';
  err_p_teller_status_change_2    constant varchar2(4000) := '{"en":"Invalid teller Code!","zh":"销售员不存在"}';
  err_p_set_sale_1                constant varchar2(4000) := '{"en":"Invalid TYPE(should BE 1) from the input parameter. Type is :","zh":"报文输入有错，非售票报文。类型为："}';
  err_p_set_cancel_1              constant varchar2(4000) := '{"en":"Invalid TYPE(should BE 2, 4) from the input parameter. Type is :","zh":"报文输入有错，非退票报文。类型为："}';
  err_p_set_cancel_2              constant varchar2(4000) := '{"en":"Can not find this ticket. ticket flow No. is ","zh":"未找到对应的售票信息。输入的流水号为："}';
  err_p_set_pay_1                 constant varchar2(4000) := '{"en":"Invalid TYPE(should BE 3, 5) from the input parameter. Type is :","zh":"报文输入有错，非兑奖报文。类型为："}';

  err_p_om_agency_auth_1          constant varchar2(4000) := '{"en":"The sales commission rate of the outlet that belong in some agents can not be large than the sales commission rate of its agent","zh":"代理商所属销售站销售代销费比例不能大于代理商的销售代销费比例"}';
  err_p_om_agency_auth_2          constant varchar2(4000) := '{"en":"The payout commission rate of the outlet that belong in some agents can not be large than the payout commission rate of its agent","zh":"代理商所属销售站销售代销费比例不能大于代理商的销售代销费比例"}';
  err_p_set_json_issue_draw_n_1   constant varchar2(4000) := '{"zh":"游戏期次不存在，或者未开奖"}';

  msg0001                         constant varchar2(4000) := '{"en":"Rolling in from abandoned award","zh":"弃奖滚入"}';
	msg0002                         constant varchar2(4000) := '{"en":"Unknown pool adjustment type","zh":"未知的奖池调整类型"}';
	msg0003                         constant varchar2(4000) := '{"en":"Receiving object or title can not be empty","zh":"接收对象或标题不能为空"}';
	msg0004                         constant varchar2(4000) := '{"en":"Abnormal database operation","zh":"数据库操作异常"}';
	msg0005                         constant varchar2(4000) := '{"en":"The games being authorized can not be empty","zh":"授权游戏不能为空"}';
	msg0006                         constant varchar2(4000) := '{"en":"Invalid status","zh":"无效的状态值"}';
	msg0007                         constant varchar2(4000) := '{"en":"Already at the current state in the database","zh":"数据库中已经是当前状态"}';
	msg0008                         constant varchar2(4000) := '{"en":"This agency has been removed","zh":"站点已经清退"}';
	msg0009                         constant varchar2(4000) := '{"en":"Repeating code","zh":"编号重复"}';
	msg0010                         constant varchar2(4000) := '{"en":"Using 99 in area code is not allowed","zh":"区域编码中不允许使用[99]"}';
	msg0011                         constant varchar2(4000) := '{"en":"The code of the national center must be 0","zh":"全国区域编码必须为[0]"}';
	msg0012                         constant varchar2(4000) := '{"en":"The code of this type of region must be from [00-99]","zh":"此类型区域编码必须为[00-99]"}';
	msg0013                         constant varchar2(4000) := '{"en":"The code of this type of region must be from [0100-9999]","zh":"此类型区域编码必须为[0100-9999]"}';
	msg0014                         constant varchar2(4000) := '{"en":"Format error: the parent code is inconsistent with the parent region","zh":"编码格式错误:父区域编码部分和所属父区域不一致"}';
	msg0015                         constant varchar2(4000) := '{"en":"Number of agencies exceeds the limit of the parent region","zh":"销售站数量限制大于父区域数量限制"}';
	msg0016                         constant varchar2(4000) := '{"en":"Number of tellers exceeds the limit of the parent region","zh":"销售员数量限制大于父区域数量限制"}';
	msg0017                         constant varchar2(4000) := '{"en":"Number of terminals exceeds the limit of the parent region","zh":"终端机数量限制大于父区域数量限制"}';
	msg0018                         constant varchar2(4000) := '{"en":"Central agency","zh":"直属站"}';
	msg0019                         constant varchar2(4000) := '{"en":"The national center cannot be deleted","zh":"中心是系统内置不能删除"}';
	msg0020                         constant varchar2(4000) := '{"en":"The deleting region has affiliated sub-level regions","zh":"该区域有关联子区域不能删除"}';
	msg0021                         constant varchar2(4000) := '{"en":"The deleting region has affiliated agencies","zh":"该区域有关联站点不能删除"}';
	msg0022                         constant varchar2(4000) := '{"en":"The deleting region has affiliated tellers","zh":"该区域有关联用户不能删除"}';
	msg0023                         constant varchar2(4000) := '{"en":"Invalid agency","zh":"无效的销售站点"}';
	msg0024                         constant varchar2(4000) := '{"en":"Invalid operator","zh":"无效的操作人"}';
	msg0025                         constant varchar2(4000) := '{"en":"The adjustment amount cannot be empty","zh":"调整金额不能为空"}';
	msg0026                         constant varchar2(4000) := '{"en":"The adjustment amount is zero, it is not necessary to calculate","zh":"调整金额为0没有必要计算"}';
	msg0027                         constant varchar2(4000) := '{"en":"The issue cannot be empty","zh":"期次不能为空"}';
	msg0028                         constant varchar2(4000) := '{"en":"Invalid game code","zh":"无效的游戏编码"}';
	msg0029                         constant varchar2(4000) := '{"en":"The game is invalid","zh":"游戏无效"}';
	msg0030                         constant varchar2(4000) := '{"en":"The basic parameters are empty","zh":"游戏基础信息配置信息为空"}';
	msg0031                         constant varchar2(4000) := '{"en":"The policy parameters are empty","zh":"游戏政策参数配置信息为空"}';
	msg0032                         constant varchar2(4000) := '{"en":"The prize parameters are empty","zh":"游戏奖级参数配置信息为空"}';
	msg0033                         constant varchar2(4000) := '{"en":"The game subtype parameters are empty","zh":"游戏玩法参数配置信息为空"}';
	msg0034                         constant varchar2(4000) := '{"en":"The winning parameters are empty","zh":"游戏中奖参数配置信息为空"}';
	msg0035                         constant varchar2(4000) := '{"en":"Cannot arrange additional issues on the selected date","zh":"所选日期无法补充排期"}';
	msg0036                         constant varchar2(4000) := '{"en":"There is a time conflict in the issue arrangement","zh":"排期存在时间交叉"}';
	msg0037                         constant varchar2(4000) := '{"en":"Incorrect password","zh":"密码不正确"}';
	msg0038                         constant varchar2(4000) := '{"en":"Failed to update the teller''s password","zh":"更新销售员密码失败"}';
	msg0039                         constant varchar2(4000) := '{"en":"Failed to update the teller''s sign-out information","zh":"更新销售员签出信息失败"}';
	msg0040                         constant varchar2(4000) := '{"en":"Failed to update the teller''s sign-in information","zh":"更新销售员签入信息失败"}';
	msg0041                         constant varchar2(4000) := '{"en":"The teller code can not be repeated","zh":"销售员编号不能重复"}';
	msg0042                         constant varchar2(4000) := '{"en":"Cannot add tellers in a central agency","zh":"中心站不可以配置销售员"}';
	msg0043                         constant varchar2(4000) := '{"en":"The number of tellers is out of range","zh":"销售员数量超出范围"}';
	msg0044                         constant varchar2(4000) := '{"en":"The number of tellers has exceeded the limit of the current region","zh":"销售员数量已经超过当前区域限制值"}';
	msg0045                         constant varchar2(4000) := '{"en":"The number of tellers has exceeded the limit of the parent region","zh":"销售员数量已经超过父区域限制值"}';
	msg0046                         constant varchar2(4000) := '{"en":"Invalid teller","zh":"无效的销售员"}';
	msg0047                         constant varchar2(4000) := '{"en":"The teller has been deleted","zh":"销售员已删除"}';
	msg0048                         constant varchar2(4000) := '{"en":"Format of the MAC address is invalid","zh":"MAC地址格式不正确"}';
	msg0049                         constant varchar2(4000) := '{"en":"The terminal code does not meet the specification","zh":"终端编码不符合规范"}';
	msg0050                         constant varchar2(4000) := '{"en":"The MAC can not be repeated","zh":"MAC地址不能重复"}';
	msg0051                         constant varchar2(4000) := '{"en":"The number of terminals has exceeded the limit of the current region","zh":"终端数量已经超过当前区域限制值"}';
	msg0052                         constant varchar2(4000) := '{"en":"The number of terminals has exceeded the limit of the parent region","zh":"终端数量已经超过父区域限制值"}';
	msg0053                         constant varchar2(4000) := '{"en":"Invalid terminal","zh":"无效的终端机"}';
	msg0054                         constant varchar2(4000) := '{"en":"The terminal has been deleted","zh":"终端已退机"}';
	msg0055                         constant varchar2(4000) := '{"en":"Invalid parameter","zh":"无效的参数对象"}';
	msg0056                         constant varchar2(4000) := '{"en":"The name of the upgrade plan can not be repeated","zh":"升级计划名称不能重复"}';
	msg0057                         constant varchar2(4000) := '{"en":"Invalid upgrade object","zh":"无效的升级对象"}';
	msg0058                         constant varchar2(4000) := '{"en":"Terminal","zh":"终端机"}';
	msg0059                         constant varchar2(4000) := '{"en":"does not exist","zh":"不存在"}';
	msg0060                         constant varchar2(4000) := '{"en":"The machine type does not match the upgrading version","zh":"机型和升级版本要求不匹配"}';
	msg0061                         constant varchar2(4000) := '{"en":"The parameter name is wrong","zh":"参数名称错误"}';
	msg0062                         constant varchar2(4000) := '{"en":"Failed to update the error code and description of the drawing process","zh":"更新期次开奖过程错误编码和描述失败"}';
	msg0063                         constant varchar2(4000) := '{"en":"The pool is not found","zh":"没有找到游戏的奖池"}';
	msg0064                         constant varchar2(4000) := '{"en":"The amount rolling in from the pool cannot be empty","zh":"滚入的奖池金额不能为空"}';
	msg0065                         constant varchar2(4000) := '{"en":"Chump changes cannot be empty","zh":"期次奖金抹零不能为空"}';
	msg0066                         constant varchar2(4000) := '{"en":"Failed to get the policy parameters","zh":"无法获取政策参数"}';
	msg0067                         constant varchar2(4000) := '{"en":"The sales amount cannot be empty","zh":"期次销售金额不能为空值"}';
	msg0068                         constant varchar2(4000) := '{"en":"Logical error: the amount of sales is 0, but the input pool amount is greater than 0","zh":"逻辑错误：期次销售金额为0，但是输入的奖池金额大于0"}';
	msg0069                         constant varchar2(4000) := '{"en":"The pool amount is insufficient, supplemented from the adjustment fund","zh":"期次奖池不足，调节基金补充"}';
	msg0070                         constant varchar2(4000) := '{"en":"Rolling in from drawing","zh":"期次开奖滚入"}';
	msg0071                         constant varchar2(4000) := '{"en":"Failed to process the risk-control related statistics","zh":"期次风险控制相关统计数值失败"}';
	msg0072                         constant varchar2(4000) := '{"en":"The issue status is invalid","zh":"期次状态无效"}';
	msg0073                         constant varchar2(4000) := '{"en":"The issue does not exist or has completed","zh":"期次不存在或期次已完结"}';
	msg0074                         constant varchar2(4000) := '{"en":"The issue can not be repeated","zh":"期次不能重复"}';
	msg0075                         constant varchar2(4000) := '{"en":"Failed to get the payout period from the policy parameters","zh":"无法获取政策参数中的兑奖期"}';
	msg0076                         constant varchar2(4000) := '{"en":"Failed to update the ticket number statistics","zh":"更新期次票数统计失败"}';
	msg0077                         constant varchar2(4000) := '{"en":"Failed to update the winnings statistics","zh":"更新期次中奖统计信息失败"}';
	msg0078                         constant varchar2(4000) := '{"en":"The parameter code can not be empty","zh":"参数编号不能为空"}';
	msg0079                         constant varchar2(4000) := '{"en":"Invalid parameter","zh":"无效参数"}';
	msg0080                         constant varchar2(4000) := '{"en":"The agency code does not meet the specification","zh":"站点编码不符合规范"}';
	msg0081                         constant varchar2(4000) := '{"en":"Agency code overflow","zh":"编码溢出"}';
	msg0082                         constant varchar2(4000) := '{"en":"Error occurred when obtaining the system parameters","zh":"获取系统参数时出现错误"}';
	msg0083                         constant varchar2(4000) := '{"en":"Bank account cannot be repeated","zh":"银行账号不能重复"}';
	msg0084                         constant varchar2(4000) := '{"en":"The issuance fee is out of range","zh":"游戏发行费用超出范围"}';
	msg0085                         constant varchar2(4000) := '{"en":"The data are being processed by others","zh":"数据正在被别人处理中"}';
	msg0086                         constant varchar2(4000) := '{"en":"Deleting condition not satisfied","zh":"不符合删除条件"}';

end;
 
/ 
prompt 正在建立[PACKAGE -> eschedule_status.sql ]...... 
CREATE OR REPLACE PACKAGE eschedule_status IS
   /****** 终端升级计划状态(1=计划中/2=已执行/3=已取消) ******/
   planning         /* 1=计划中 */      CONSTANT NUMBER := 1;
   executed         /* 2=已执行 */      CONSTANT NUMBER := 2;
   cancelled        /* 3=已取消 */      CONSTANT NUMBER := 3;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> esex.sql ]...... 
CREATE OR REPLACE PACKAGE ecommsex IS
   /****** 性别枚举(1=男/2=女) ******/
   male                     /* 1=男 */                  CONSTANT NUMBER := 1;
   female                   /* 2=女 */                  CONSTANT NUMBER := 2;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> esys_comm_log_status.sql ]...... 
CREATE OR REPLACE PACKAGE esys_comm_log_status IS
   /****** 主机通讯状态(0=新增、1=主机已经读取) ******/
   new                  /* 1=可用 */                CONSTANT NUMBER := 1;
   read                 /* 2=已禁用 */              CONSTANT NUMBER := 2;
END;
/ 
/ 
prompt 正在建立[PACKAGE -> eteller_status.sql ]...... 
CREATE OR REPLACE PACKAGE eteller_status IS
   /****** 销售员状态（1=可用；2=已禁用；3=已删除） ******/
   enabled                 /* 1-可用 */                    CONSTANT NUMBER := 1;
   disabled                /* 2-已禁用 */                  CONSTANT NUMBER := 2;
   deleted                 /* 3-已删除 */                  CONSTANT NUMBER := 3;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> eteller_type.sql ]...... 
CREATE OR REPLACE PACKAGE eteller_type IS
   /****** 销售员类型（1=普通销售员； 2=销售站经理；3=培训员） ******/
   employee                /* 1-普通销售员 */              CONSTANT NUMBER := 1;
   manager                 /* 2-销售站经理 */              CONSTANT NUMBER := 2;
   trainner                /* 3-培训员 */                  CONSTANT NUMBER := 3;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> eterminal_status.sql ]...... 
CREATE OR REPLACE PACKAGE eterminal_status IS
   /****** 终端状态(1=可用/2=禁用/3=退机) ******/
   enabled                  /* 1=可用 */                CONSTANT NUMBER := 1;
   disabled                 /* 2=禁用 */                CONSTANT NUMBER := 2;
   cancelled                /* 3=退机 */                CONSTANT NUMBER := 3;
END;
/ 
/ 
prompt 正在建立[PACKAGE -> eticket_status.sql ]...... 
CREATE OR REPLACE PACKAGE eticket_status IS
   /****** 损毁单-损毁原因（41-被盗、42-损坏、43-丢失） ******/
   /****** 状态（11-在库、12-在站点，20-在途，31-已销售、41-被盗、42-损坏、43-丢失） ******/
   in_warehouse         /* 11-在库 */                  CONSTANT NUMBER := 11;
   in_agency            /* 12-在站点 */                CONSTANT NUMBER := 12;
   on_way               /* 20-在途 */                  CONSTANT NUMBER := 20;
   in_mm                /* 21-管理员持有 */            CONSTANT NUMBER := 21;
   saled                /* 31-已销售 */                CONSTANT NUMBER := 31;
   stolen               /* 41-被盗 */                  CONSTANT NUMBER := 41;
   broken               /* 42-损坏 */                  CONSTANT NUMBER := 42;
   lost                 /* 43-丢失 */                  CONSTANT NUMBER := 43;
END;

 
/ 
prompt 正在建立[PACKAGE -> etuning_type.sql ]...... 
CREATE OR REPLACE PACKAGE etuning_type IS
   /****** 适用于以下表：                              ******/
   /****** 2.1.9.4 销售站（机构）调账（fund_tuning）   ******/
   /******     调整类型（1-调增，2-调减）	tuning_type  ******/

   add                     /* 1=调增 */                  CONSTANT NUMBER := 1;
   min                     /* 0=调减 */                  CONSTANT NUMBER := 2;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> evalid_number.sql ]...... 
CREATE OR REPLACE PACKAGE evalid_number IS
   /****** 有效位数（1-箱号、2-盒号、3-本号） ******/
   trunk          /* 1-箱号 */        CONSTANT NUMBER := 1;
   box            /* 2-盒号 */        CONSTANT NUMBER := 2;
   pack           /* 3-本号 */        CONSTANT NUMBER := 3;
   ticket         /* 3-本号 */        CONSTANT NUMBER := 4;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> ewarehouse_status.sql ]...... 
CREATE OR REPLACE PACKAGE ewarehouse_status IS
   /****** 状态（1-启用，2-停用，3-盘点中） ******/
   working                 /* 1-启用 */                  CONSTANT NUMBER := 1;
   stoped                  /* 2-停用 */                  CONSTANT NUMBER := 2;
   checking                /* 3-盘点中 */                CONSTANT NUMBER := 3;
END;
/
 
/ 
prompt 正在建立[PACKAGE -> ework_status.sql ]...... 
CREATE OR REPLACE PACKAGE ework_status IS
   /****** 适用于以下表：                                                 ******/
   /****** 出库单（wh_goods_issue）   状态（1-未完成，2-已完成）	status  ******/
   /****** 物品入库（item_receipt）   状态（1-未完成，2-已完成）	status  ******/
   /****** 入库单—WH_GOODS_RECEIPT(STATUS)                               ******/
   /****** 状态（1-未完成，2-已完成） ******/
   working                /* 1-未完成 */                  CONSTANT NUMBER := 1;
   done                   /* 2-已完成 */                  CONSTANT NUMBER := 2;
END;
/
 
/ 
prompt 正在建立[FUNCTION -> f_check_admin.sql ]...... 
/********************************************************************************/
  ------------------- 适用于检查用户是否存在 ----------------------------
  ---- add by 陈震: 2015/9/17
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_check_admin(p_admin in number)
   RETURN BOOLEAN
 IS
   v_count number(1);
BEGIN
   select count(*) into v_count from dual where exists(select 1 from ADM_INFO where ADMIN_ID=p_admin);
   if v_count = 1 then
      return true;
   else
      return false;
   end if;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_check_box.sql ]...... 
/********************************************************************************/
  ------------------- 适用于检查盒是否存在 ----------------------------
  ---- add by 陈震: 2015/10/29
/********************************************************************************/
create or replace function f_check_box(p_plan varchar2, p_batch varchar2, p_box varchar2)
   return boolean
 is
   v_count number(1);
begin
   select count(*) into v_count from dual where exists(select 1 from wh_ticket_box where plan_code=p_plan and batch_no=p_batch and box_no=p_box);
   if v_count = 1 then
      return true;
   else
      return false;
   end if;
end;
 
/ 
prompt 正在建立[FUNCTION -> f_check_import_ticket.sql ]...... 
CREATE OR REPLACE FUNCTION f_check_import_ticket(
/***************************************************************************************************/
  ----------------- 用于检查出入库票明细之间，是否存在关联关系 -------------------------------------
  ---- add by 陈震: 2015/9/28
  ---- modify by dzg :2015/10/27 增加盘点校验
/********************************************************************************/
   p_sn                    in char,
   p_type                  in number,                 -- 类型（1-入库，2-出库， 3-盘点）
   p_lot_array             in type_lottery_list
)
   RETURN BOOLEAN
IS
   v_lottery_detail        type_lottery_info;                              -- 单张彩票
   v_array_lottery         type_lottery_info;                              -- 去掉自己以后的数组
   v_format_lotterys       type_lottery_list;
   v_all_lottery_list      type_lottery_list;

BEGIN
   /************************************************************************************/
   /******************* 检查输入的出入库对象是否合法 *************************/
   v_format_lotterys := type_lottery_list();
   for v_list_count in 1 .. p_lot_array.count loop
      v_array_lottery := p_lot_array(v_list_count);
      case
         when v_array_lottery.valid_number = evalid_number.trunk then
            v_array_lottery.box_no := '-';
            v_array_lottery.package_no := '-';

         when v_array_lottery.valid_number = evalid_number.box then
            v_lottery_detail := f_get_lottery_info(v_array_lottery.plan_code, v_array_lottery.batch_no, v_array_lottery.valid_number, v_array_lottery.box_no);
            v_array_lottery.trunk_no := v_lottery_detail.trunk_no;
            v_array_lottery.package_no := '-';

         when v_array_lottery.valid_number = evalid_number.pack then
            v_lottery_detail := f_get_lottery_info(v_array_lottery.plan_code, v_array_lottery.batch_no, v_array_lottery.valid_number, v_array_lottery.package_no);
            v_array_lottery.trunk_no := v_lottery_detail.trunk_no;
            v_array_lottery.box_no := v_lottery_detail.box_no;

      end case;

      v_format_lotterys.extend;
      v_format_lotterys(v_format_lotterys.count) := v_array_lottery;
   end loop;

   case
      when p_type = 1 then
         -- 判断入库对象有没有与已经入库的内容重复，或者存在交叉的对象（例如：已经入整箱，再入箱中的一本彩票）
         select type_lottery_info(plan_code, batch_no, valid_number, trunk_no, box_no, '', package_no, '', 0)
           bulk collect into v_all_lottery_list
           from wh_goods_receipt_detail
          where ref_no = p_sn;

      when p_type = 2 then
         -- 判断出库对象有没有与已经出库的内容重复，或者存在交叉的对象（例如：已经入整箱，再入箱中的一本彩票）
         select type_lottery_info(plan_code, batch_no, valid_number, trunk_no, box_no, '', package_no, '', 0)
           bulk collect into v_all_lottery_list
           from wh_goods_issue_detail
          where ref_no = p_sn;
          
       when p_type = 3 then
         --盘点详情单检测
         select type_lottery_info(plan_code, batch_no, valid_number, trunk_no, box_no, '', package_no, '', 0)
          bulk collect into v_all_lottery_list
          from wh_check_point_detail
         where cp_no = p_sn;
          
      else
         raise_application_error(-20001, error_msg.err_f_check_import_ticket);
   end case;

   -- 合并当前数组
   v_all_lottery_list := v_all_lottery_list multiset union v_format_lotterys;

   if f_check_ticket_perfect(v_all_lottery_list) then
      return true;
   end if;

   return false;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_check_org.sql ]...... 
/********************************************************************************/
  ------------------- 适用于检查机构是否存在 ----------------------------
  ---- add by 陈震: 2015/10/13
/********************************************************************************/
create or replace function f_check_org(p_org in varchar2)
   return boolean
 is
   v_count number(1);
begin
   select count(*) into v_count from dual where exists(select 1 from inf_orgs where org_code=p_org);
   if v_count = 1 then
      return true;
   else
      return false;
   end if;
end;
 
/ 
prompt 正在建立[FUNCTION -> f_check_pack.sql ]...... 
/********************************************************************************/
  ------------------- 适用于检查本是否存在 ----------------------------
  ---- add by 陈震: 2015/10/29
/********************************************************************************/
create or replace function f_check_pack(p_plan varchar2, p_batch varchar2, p_pack varchar2)
   return boolean
 is
   v_count number(1);
begin
   select count(*) into v_count from dual where exists(select 1 from wh_ticket_package where plan_code=p_plan and batch_no=p_batch and package_no=p_pack);
   if v_count = 1 then
      return true;
   else
      return false;
   end if;
end;
 
/ 
prompt 正在建立[FUNCTION -> f_check_plan_batch.sql ]...... 
/********************************************************************************/
  ------------------- 适用于检查批次方案是否存在 ----------------------------
  ---- add by 陈震: 2015/9/17
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_check_plan_batch(p_plan in varchar2, p_batch in varchar2)
   RETURN BOOLEAN
 IS
   v_count number(1);
BEGIN
   select count(*) into v_count from dual where exists(select 1 from GAME_BATCH_IMPORT_DETAIL where PLAN_CODE=p_plan and BATCH_NO=p_batch);
   if v_count = 1 then
      return true;
   else
      return false;
   end if;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_check_plan_batch_status.sql ]...... 
/********************************************************************************/
  ------------------- 适用于检查批次是否可用 ----------------------------
  ---- add by 陈震: 2015/9/17
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_check_plan_batch_status(p_plan in varchar2, p_batch in varchar2)
   RETURN BOOLEAN
 IS
   v_count number(1);
BEGIN
   select count(*) into v_count from dual where exists(select 1 from GAME_BATCH_IMPORT_DETAIL where PLAN_CODE=p_plan and BATCH_NO=p_batch and STATUS = ebatch_item_status.working);
   if v_count = 1 then
      return true;
   else
      return false;
   end if;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_check_ticket_include.sql ]...... 
CREATE OR REPLACE FUNCTION f_check_ticket_include(
   p_lottery               in type_lottery_info,
   p_lot_array             in type_lottery_list
)
   RETURN BOOLEAN
IS
   v_loop                  number(10);
   v_array_lottery         type_lottery_info;                              -- 单张彩票

BEGIN

   --p_debug_print_lottery(p_lot_array, 'f_check_ticket_include parameter');
   --p_debug_print_lottery1(p_lottery);

   for v_loop in 1 .. p_lot_array.count loop
      v_array_lottery := p_lot_array(v_loop);

      -- 先匹配方案和批次，不属于同一个方案和批次，不用检查
      if not (p_lottery.plan_code = v_array_lottery.plan_code and p_lottery.batch_no = v_array_lottery.batch_no) then
         return false;
      end if;

      /**********************************************/
      /********-- 彩票的类型为“箱” --****/
      if p_lottery.valid_number = evalid_number.trunk then
         -- 对方只要包含这箱票，就出现错误，因为存在关联关系。不能在一个清单中，既处理父对象，又处理子对象
         if p_lottery.trunk_no = v_array_lottery.trunk_no then
            raise_application_error(-20001, f_print_lottery(p_lottery) || error_msg.err_f_check_ticket_include_1);
            return true;
         end if;

      end if;

      /**********************************************/
      /********-- 彩票的类型为“盒” --****/
      if p_lottery.valid_number = evalid_number.box then
         case
            when v_array_lottery.valid_number in (evalid_number.box, evalid_number.pack) then
               -- 对应数组中的对象为“盒”或者“票”时，判断“盒”号是否相同
               if p_lottery.box_no = v_array_lottery.box_no then
                  raise_application_error(-20001, f_print_lottery(p_lottery) || error_msg.err_f_check_ticket_include_2);
                  return true;
               end if;

            when v_array_lottery.valid_number = evalid_number.trunk then
               -- 对应数组中的对象为“箱”时，判断“盒”对应的箱号是否相同
               if p_lottery.trunk_no = v_array_lottery.trunk_no then
                  raise_application_error(-20001, f_print_lottery(p_lottery) || error_msg.err_f_check_ticket_include_2);
                  return true;
               end if;
         end case;
      end if;


      /**********************************************/
      /********-- 彩票的类型为“票” --****/
      if p_lottery.valid_number = evalid_number.pack then
         case
            when v_array_lottery.valid_number = evalid_number.pack then
               -- 对应数组中的对象为“票”时，判断票号是否相同
               if p_lottery.package_no = v_array_lottery.package_no then
                  raise_application_error(-20001, f_print_lottery(p_lottery) || error_msg.err_f_check_ticket_include_3);
                  return true;
               end if;

            when v_array_lottery.valid_number in (evalid_number.box, evalid_number.trunk) then
               -- 对应数组中的对象为“盒”或者“箱”时，判断票号是否包含在“盒”或者“箱”对应的票中
               if (p_lottery.package_no >= v_array_lottery.package_no) and (p_lottery.package_no <= v_array_lottery.package_no_e) then
                  raise_application_error(-20001, f_print_lottery(p_lottery) || error_msg.err_f_check_ticket_include_3);
                  return true;
               end if;
         end case;
      end if;

   end loop;

   -- 不包含
   return false;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_check_ticket_perfect.sql ]...... 
CREATE OR REPLACE FUNCTION f_check_ticket_perfect(
/***************************************************************************************************/
  ------------------- 检查彩票数组成员之间，是否存在相互包含的关系，同时也检查是否重复 --------------
  ------------------- 用于，入库明细和出库明细的嵌套检查 --------------------------------------------
  ---- add by 陈震: 2015/9/25
/********************************************************************************/
   p_lot_array             in type_lottery_list
)
   RETURN BOOLEAN
IS
   v_loop                  number(10);
   v_loop1                 number(10);
   v_lottery_info          type_lottery_info;                              -- 单张彩票
   v_array_lottery         type_lottery_list;                              -- 去掉自己以后的数组

BEGIN
   --p_debug_print_lottery(p_lot_array,'f_check_ticket_perfect parameter');
   for v_loop in 1 .. p_lot_array.count loop
      v_lottery_info := p_lot_array(v_loop);
      v_array_lottery := type_lottery_list();

      for v_loop1 in 1 .. p_lot_array.count loop
         continue when v_loop1 = v_loop;
         v_array_lottery.extend;
         v_array_lottery(v_array_lottery.count) := p_lot_array(v_loop1);
      end loop;

      if f_check_ticket_include(v_lottery_info, v_array_lottery) then
         return true;
      end if;

   end loop;

   -- 不包含
   return false;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_check_trunk.sql ]...... 
/********************************************************************************/
  ------------------- 适用于检查箱是否存在 ----------------------------
  ---- add by 陈震: 2015/10/29
/********************************************************************************/
create or replace function f_check_trunk(p_plan varchar2, p_batch varchar2, p_trunk varchar2)
   return boolean
 is
   v_count number(1);
begin
   select count(*) into v_count from dual where exists(select 1 from wh_ticket_trunk where plan_code=p_plan and batch_no=p_batch and trunk_no=p_trunk);
   if v_count = 1 then
      return true;
   else
      return false;
   end if;
end;
 
/ 
prompt 正在建立[FUNCTION -> f_check_warehouse.sql ]...... 
/********************************************************************************/
  ------------------- 适用于检查仓库是否存在 ----------------------------
  ---- add by 陈震: 2015/9/17
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_check_warehouse(p_wh in varchar2)
   RETURN BOOLEAN
 IS
   v_count number(1);
BEGIN
   select count(*) into v_count from dual where exists(select 1 from WH_INFO where WAREHOUSE_CODE=p_wh);
   if v_count = 1 then
      return true;
   else
      return false;
   end if;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_acc_no.sql ]...... 
/********************************************************************************/
  ------------------- 适用于三种账户编码的生成 ----------------------------
  ---- add by 陈震: 2015/9/16
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_acc_no(p_org_code in char,
                                        p_acc_type in char)
   RETURN VARCHAR2

 IS
   v_max_code varchar2(20);
BEGIN
   -- 判断机构编码是否正确
   if p_acc_type not in ('JG', 'ZD', 'MM') then
      raise_application_error(-20001, error_msg.ERR_F_GET_WAREHOUSE_CODE_1); -- 输入的账户类型不是“JG”,“ZD”,“MM”
   end if;

   -- 查找此部门的最大仓库编号
   case
      when p_acc_type = 'JG' then
         select max(ACC_NO)
           into v_max_code
           from ACC_ORG_ACCOUNT
          where ORG_CODE = p_org_code;
         if v_max_code is null then
            return p_acc_type || p_org_code || lpad(1, 8, '0');
         end if;
         return p_acc_type || p_org_code || lpad(to_number(substr(v_max_code, 5, 8)) + 1, 8, '0');

      when p_acc_type = 'ZD' then
         select max(ACC_NO)
           into v_max_code
           from ACC_AGENCY_ACCOUNT
          where AGENCY_CODE = p_org_code;
         if v_max_code is null then
            return p_acc_type || p_org_code || '01';
         end if;
         return p_acc_type || p_org_code || lpad(to_number(substr(v_max_code, 11, 2)) + 1, 2, '0');

      when p_acc_type = 'MM' then
         select max(ACC_NO)
           into v_max_code
           from ACC_MM_ACCOUNT
          where MARKET_ADMIN = to_number(p_org_code);
         if v_max_code is null then
            return p_acc_type || p_org_code || lpad(1, 6, '0');
         end if;
         return p_acc_type || p_org_code || lpad(to_number(substr(v_max_code, 7, 6)) + 1, 6, '0');

   end case;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_admin_org.sql ]...... 
/********************************************************************************/
  ------------------- 返回人员所属组织机构代码-----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_admin_org(
   p_admin IN number -- 操作人员

) RETURN STRING IS
   /*-----------    变量定义     -----------------*/
   v_ret_code STRING(8) := ''; -- 返回值

BEGIN

   select ADMIN_ORG
     into v_ret_code
     from ADM_INFO
    where ADMIN_ID = p_admin;

   return v_ret_code;

END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_adm_id_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于获得权限中用户和角色ID-----------------------------
  ----针对表ADM_INFO的ADMIN_ID字段和ADM_ROLE表的ROLE_ID的字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_adm_id_seq RETURN number IS
BEGIN
    return seq_adm_id.nextval;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_adm_name.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_adm_name(p_admin_id number) RETURN varchar2
IS
   v_admin_name varchar2(40);
BEGIN
    select ADMIN_REALNAME
      into v_admin_name
      from ADM_INFO
     where ADMIN_ID=p_admin_id;
    return v_admin_name;
exception
   when no_data_found then
      return '[NO NAME FOUND]';
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_agency_area.sql ]...... 
/********************************************************************************/
  ------------------- 杩斿洖绔欑偣鎵�灞炲尯鍩熶唬鐮�-----------------------------
  ----add by 闄堥渿: 2016/08/01
/********************************************************************************/
create or replace function f_get_agency_area(
  p_applyflow_sell in string --閿�鍞娴佹按

) return string
  result_cache
  relies_on(inf_agencys)

is
  /*-----------    鍙橀噺瀹氫箟     -----------------*/
  v_ret_code string(8) := ''; -- 杩斿洖鍊�

begin

  select area_code
    into v_ret_code
    from his_sellticket join inf_agencys on his_sellticket.agency_code=inf_agencys.agency_code
	and applyflow_sell=p_applyflow_sell;

  return v_ret_code;

end;
 
/ 
prompt 正在建立[FUNCTION -> f_get_agency_code_by_area.sql ]...... 
/********************************************************************************/
  ------------------- 根据区域编码生成站点编码-----------------------------
  ---- add by dzg: 2015-9-12
  ---- modify by Chen Zhen @2016-06-28  修改生成规则。找到0-9999中，未被使用的编号，返回
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_agency_code_by_area
(
  p_area_code IN STRING --区域编码
)
RETURN STRING IS
/*-----------    变量定义     -----------------*/

  v_temp     varchar2(8); -- 临时变量

BEGIN

  select min(agency_code)
    into v_temp
    from (select p_area_code || lpad(rownum, 4, '0') agency_code
            from dual
          connect by rownum < 10000
          minus
          select agency_code
            from inf_agencys
           where inf_agencys.area_code = p_area_code);

  return v_temp;

  EXCEPTION
    WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-100, 'code overflow!');

END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_agency_comm_rate.sql ]...... 
/********************************************************************************/
  ------------------- 获取站点的佣金比例 -----------------------------
  ----add by 陈震: 2015-12-20
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_agency_comm_rate(
   p_agency IN STRING,        -- 站点编码
   p_plan   in string,        -- 方案
   p_batch  in string,        -- 批次
   p_type   in number         -- 佣金类型 （1=销售、2=兑奖）

) RETURN number IS
   /*-----------    变量定义     -----------------*/
   v_rtv number; -- 返回值

   v_plan            varchar2(50);
   v_sale_comm       number(10);
   v_pay_comm        number(10);

BEGIN
   -- 按照方案设置对应的佣金
   case
      -- Iphone
      when (p_plan = 'J0002' or (p_plan = 'J2015' and p_batch = '00001')) then
         v_plan := 'J0002';

      -- Ball
      when (p_plan = 'J0003' or (p_plan = 'J2015' and p_batch = '00002')) then
         v_plan := 'J0003';

      -- GongXi
      when (p_plan = 'J0004') then
         v_plan := 'J0004';

      -- DGL
      when (p_plan = 'J0005') then
         v_plan := 'J0005';

      -- Love
      when (p_plan = 'J2014') then
         -- 爱心没有销售佣金，所以这里要注意
         if p_type = 1 then
            return -1;
         end if;

         v_rtv := to_number(f_get_sys_param(11));
         return v_rtv;

      else
         v_plan := p_plan;

   end case;

   -- 检索相应的佣金比例，如果未查询到，则返回 -1
   begin
      select sale_comm, pay_comm into v_sale_comm, v_pay_comm  from game_agency_comm_rate where agency_code = p_agency and plan_code = v_plan;
   exception
      when no_data_found then
         return -1;
   end;

   if p_type = 1 then
      v_rtv := v_sale_comm;
   else
      v_rtv := v_pay_comm;
   end if;

   return v_rtv;

END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_agency_credit.sql ]...... 
/********************************************************************************/
  ------------------- 返回站点信用额度 -----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
create or replace function f_get_agency_credit(
  p_agency in string --站点编码

) return number
  result_cache
  relies_on(inf_agencys)

is
  /*-----------    变量定义     -----------------*/
  v_ret number(28);

begin

  begin
    select credit_limit
      into v_ret
      from acc_agency_account
     where agency_code = p_agency
       and acc_type=eacc_type.main_account;
  exception
    when no_data_found then
      return 0;
  end;

  return v_ret;

end;
 
/ 
prompt 正在建立[FUNCTION -> f_get_agency_game_comm.sql ]...... 
/********************************************************************************/
  ------------------- 返回站点对应游戏的代销费比例-----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_agency_game_comm(
   p_agency IN STRING,     --站点编码
   p_game_code in number,  -- 游戏编码
   p_comm_type in number   -- 代销费类型（ecomm_type）

) RETURN number IS
   /*-----------    变量定义     -----------------*/
   v_ret_code number(8) := ''; -- 返回值

BEGIN

   case p_comm_type
      when ecomm_type.sale then
         begin
            select sale_commission_rate into v_ret_code
              from auth_agency
             where agency_code = p_agency
               and game_code = p_game_code;
         exception
            when no_data_found then
               v_ret_code := 0;
         end;

      when ecomm_type.pay then
         begin
            select pay_commission_rate into v_ret_code
              from auth_agency
             where agency_code = p_agency
               and game_code = p_game_code;
         exception
            when no_data_found then
               v_ret_code := 0;
         end;
   end case;

   return v_ret_code;

END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_agency_info.sql ]...... 
/********************************************************************************/
  ------------------- 返回站点信息-----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
create or replace function f_get_agency_info(
  p_agency in string --站点编码

) return string
  result_cache
  relies_on(inf_agencys)

is
  /*-----------    变量定义     -----------------*/
  v_ret_code varchar2(4000) := ''; -- 返回值

begin

  begin
    select nvl(address, '') || '^' || nvl(telephone, '')
      into v_ret_code
      from inf_agencys
     where agency_code = p_agency;
  exception
    when no_data_found then
      return '';
  end;

  return v_ret_code;

end;
 
/ 
prompt 正在建立[FUNCTION -> f_get_agency_org.sql ]...... 
/********************************************************************************/
  ------------------- 返回站点所属组织机构代码-----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
create or replace function f_get_agency_org(
  p_agency in string --站点编码

) return string
  result_cache
  relies_on(inf_agencys)

is
  /*-----------    变量定义     -----------------*/
  v_ret_code string(8) := ''; -- 返回值

begin

  select org_code
    into v_ret_code
    from inf_agencys
   where agency_code = p_agency;

  return v_ret_code;

end;
 
/ 
prompt 正在建立[FUNCTION -> f_get_area_display.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_area_display(p_area_code char) RETURN varchar2
IS
   v_display      varchar2(40);
   v_area_type    number(1);
BEGIN
   case
      when p_area_code = 0 then
         v_display := '0';
      when p_area_code > 0 and p_area_code <= 99 then
         v_display := lpad(to_char(p_area_code),2,'0');
      when p_area_code >= 100 and p_area_code <= 9999 then
         v_display := lpad(to_char(p_area_code),4,'0');
      when p_area_code >= 10000 and p_area_code <= 999999 then
         v_display := lpad(to_char(p_area_code),6,'0');
    end case;
    return v_display;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_area_org.sql ]...... 
/********************************************************************************/
  ------------------- 返回区域所属组织机构代码-----------------------------
  ----add by 陈震: 2015/11/10
/********************************************************************************/
create or replace function f_get_area_org(
   p_area in string --站点编码

) return string is
   /*-----------    变量定义     -----------------*/
   v_ret_code string(8) := ''; -- 返回值

begin

   select org_code
     into v_ret_code
     from inf_org_area
    where area_code = p_area;

   return v_ret_code;

end;
 
/ 
prompt 正在建立[FUNCTION -> f_get_batch_import_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于批次信息导入序号-----------------------------
  ----针对表GAME_BATCH_IMPORT、AME_BATCH_IMPORT_DETAIL、GAME_BATCH_IMPORT_REWARD
  ----和GAME_BATCH_REWARD_DETAIL的IMPORT_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11
/********************************************************************************/
CREATE OR REPLACE FUNCTION F_GET_BATCH_IMPORT_SEQ
   RETURN VARCHAR2 IS
BEGIN
   return 'IMP-'||lpad(seq_batch_imp.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_comm_flow_org_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于机构佣金流水序号----------------------------
  ----针对表FLOW_ORG_COMM_DETAIL(机构销售佣金流水)的ORG_FUND_COMM_FLOW字段创建同一序列函数
  ----add by 陈震: 2015-12-19
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_comm_flow_org_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'JGYJ'||lpad(seq_org_fund_flow.nextval,20,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_detail_sequence_no_seq.sql ]...... 
/**************************************************************************************************************************/
  ------------------- 适用于订单收货明细、订单申请明细、出货单申请明细、调拨单申请明细、---------------------------
  ------------------- 退货单明细、损毁单明细、盘点差错明细、盘点结果明细、盘点前库存明细的序列---------------------------
  ----针对表如下表创建的SEQUENCE_NO字段创建同一序列函数
  ----WH_ORDER_RECEIVE_DETAIL(订单收货明细)     
  ----SALE_ORDER_APPLY_DETAIL(订单申请明细)     
  ----SALE_DELIVERY_ORDER_DETAIL(出货单申请明细)
  ----SALE_TB_APPLY_DETAIL(调拨单申请明细)      
  ----SALE_RETURN_RECODER_DETAIL(退货单明细)    
  ----WH_BROKEN_RECODER_DETAIL(损毁单明细)      
  ----WH_CP_NOMATCH_DETAIL(盘点差错明细)        
  ----WH_CHECK_POINT_DETAIL(盘点结果明细)       
  ----WH_CHECK_POINT_DETAIL_BE(盘点前库存明细)
  ----add by dzg: 2015-9-11 
/**************************************************************************************************************************/
CREATE OR REPLACE FUNCTION f_get_detail_sequence_no_seq
   RETURN VARCHAR2 IS
BEGIN
   return lpad(seq_detail_sequence_no.nextval,24,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_eventid_seq.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_eventid_seq RETURN number IS
BEGIN
    return seq_sys_event_id.nextval;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_flow_agency_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于站点资金流水序号-----------------------------
  ----针对表flow_agency(站点资金流水)的AGENCY_FUND_FLOW字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_flow_agency_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'ZD'||lpad(seq_agency_fund_flow.nextval,22,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_flow_cancel_seq.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_flow_cancel_seq
/********************************************************************************/
  ------------------- 适用于退票记录序号----------------------------
  ----针对表FLOW_CANCEL(退票记录)的CANCEL_FLOW字段创建同一序列函数
  ----add by Chen Zhen: 2015/10/2
/********************************************************************************/
   RETURN VARCHAR2 IS
BEGIN
   return 'TP'||lpad(seq_cancel_flow.nextval,22,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_flow_gui_pay_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于资金管理序号-----------------------------
  ----针对表FLOW_GUI_PAY(GUI兑奖信息记录表)的FUND_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_flow_gui_pay_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'GD'||lpad(seq_fund_no.nextval,10,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_flow_market_manager_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于市场管理员资金流水序号-----------------------------
  ----针对表FLOW_MARKET_MANAGER(市场管理员资金流水)的MM_FUND_FLOW字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_flow_market_manager_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'MM'||lpad(seq_mm_fund_flow.nextval,22,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_flow_org_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于机构资金流水序号----------------------------
  ----针对表FLOW_ORG(机构资金流水)的ORG_FUND_FLOW字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_flow_org_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'JG'||lpad(seq_org_fund_flow.nextval,22,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_flow_pay_detail_no_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于兑奖记录序号----------------------------
  ----针对表FLOW_PAY(兑奖记录)的PAY_FLOW字段创建同一序列函数
  ----add by dzg: 2015-9-11
/********************************************************************************/

CREATE OR REPLACE FUNCTION f_get_flow_pay_detail_no_seq
   RETURN VARCHAR2 IS
BEGIN
   return seq_pay_flow.nextval;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_flow_pay_detail_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于兑奖记录序号----------------------------
  ----针对表FLOW_PAY(兑奖记录)的PAY_FLOW字段创建同一序列函数
  ----add by dzg: 2015-9-11
/********************************************************************************/

CREATE OR REPLACE FUNCTION f_get_flow_pay_detail_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'DX'||lpad(seq_pay_flow.nextval,22,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_flow_pay_org.sql ]...... 
create or replace function f_get_flow_pay_org(
   p_pay_flow in string --站点编码

) return string is
   /*-----------    变量定义     -----------------*/
   v_ret_code  string(8) := ''; -- 返回值
   v_record flow_pay%rowtype;

begin

   select * into v_record from flow_pay where pay_flow = p_pay_flow;

   case
      when v_record.is_center_paid = 1 then        -- 中心兑奖
         v_ret_code := f_get_admin_org(v_record.payer_admin);

      when v_record.is_center_paid = 2 then        -- 管理员兑奖
         v_ret_code := f_get_admin_org(v_record.payer_admin);

      when v_record.is_center_paid = 3 then        -- 销售站兑奖
         v_ret_code := f_get_agency_org(v_record.pay_agency);

      else
         return 'ERROR';
   end case;

   return v_ret_code;

end;
 
/ 
prompt 正在建立[FUNCTION -> f_get_flow_pay_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于兑奖记录序号----------------------------
  ----针对表FLOW_PAY(兑奖记录)的PAY_FLOW字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/

CREATE OR REPLACE FUNCTION f_get_flow_pay_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'DJ'||lpad(seq_pay_flow.nextval,22,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_flow_sale_seq.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_flow_sale_seq
/********************************************************************************/
  ------------------- 适用于销售记录序号----------------------------
  ----针对表FLOW_SALE(销售记录)的SALE_FLOW字段创建同一序列函数
  ----add by Chen Zhen: 2015/10/2
/********************************************************************************/
   RETURN VARCHAR2 IS
BEGIN
   return 'XS'||lpad(seq_sale_flow.nextval,22,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_fund_charge_cash_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于资金管理序号-----------------------------
  ----针对表FUND_CHARGE_CASH(销售站(机构)现金充值)的FUND_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_fund_charge_cash_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'FA'||lpad(seq_fund_no.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_fund_charge_center_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于资金管理序号-----------------------------
  ----针对表FUND_CHARGE_CENTER(销售站(机构)中心充值)的FUND_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_fund_charge_center_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'FC'||lpad(seq_fund_no.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_fund_mm_cash_repay_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于资金管理序号-----------------------------
  ----针对表FUND_MM_CASH_REPAY(市场管理员现金还款)的FUND_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_fund_mm_cash_repay_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'JK'||lpad(seq_fund_no.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_fund_tuning_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于资金管理序号-----------------------------
  ----针对表FUND_TUNING(销售站(机构)调账)的FUND_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_fund_tuning_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'FT'||lpad(seq_fund_no.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_fund_withdraw_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于资金管理序号-----------------------------
  ----针对表FUND_WITHDRAW(销售站(机构)提现)的FUND_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_fund_withdraw_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'FW'||lpad(seq_fund_no.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_game_current_issue.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_game_current_issue(p_game_code number)
   RETURN number IS
   v_issue_current number(12);
   v_cnt           number(2);
BEGIN
   begin
      SELECT issue_number
        INTO v_issue_current
        FROM iss_game_issue
       WHERE game_code = p_game_code
         AND real_start_time IS NOT NULL
         AND real_close_time IS NULL;
   exception
      when no_data_found then
         -- 无当前期时，找到最后结束的期次，获取issue_seq号码
         select max(issue_seq)
           into v_issue_current
           from iss_game_issue
          WHERE game_code = p_game_code
            AND real_close_time IS NOT NULL;

         select count(*)
           into v_cnt
           from iss_game_issue
          where game_code = p_game_code
            and issue_seq = v_issue_current + 1;
         if v_cnt <> 0 then
            select issue_number
              into v_issue_current
              from iss_game_issue
             where game_code = p_game_code
               and issue_seq = v_issue_current + 1;
         else
            v_issue_current := 0 - (v_issue_current + 1);
         end if;
   end;

   return v_issue_current;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_game_flow_seq.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_game_flow_seq RETURN number IS
BEGIN
    return seq_game_flow.nextval;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_game_his_code_seq.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_game_his_code_seq RETURN number IS
BEGIN
    return seq_game_his_code.nextval;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_game_name.sql ]...... 
/********************************************************************************/
  ------------------- 返回游戏名称 -----------------------------
  ----add by 孔维鑫: 2016/8/2
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_game_name(
   p_game_code IN number -- 游戏编号

) RETURN STRING IS
   /*-----------    变量定义     -----------------*/
   v_ret_code STRING(64) := ''; -- 返回值

BEGIN
    select SHORT_NAME
         into v_ret_code
           from inf_games
          where game_code = p_game_code;

   return v_ret_code;

END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_his_cancel_seq.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_his_cancel_seq RETURN number IS
BEGIN
    return seq_his_cancel.nextval;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_his_pay_seq.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_his_pay_seq RETURN number IS
BEGIN
    return seq_his_pay.nextval;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_his_sell_seq.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_his_sell_seq RETURN number IS
BEGIN
    return seq_his_sell.nextval;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_his_settle_seq.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_his_settle_seq RETURN number IS
BEGIN
    return seq_his_settle.nextval;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_his_win_seq.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_his_win_seq RETURN number IS
BEGIN
    return seq_his_win.nextval;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_inf_agency_delete_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于资金管理序号-----------------------------
  ----针对表INF_AGENCY_DELETE(售站清退)的FUND_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_inf_agency_delete_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'QT'||lpad(seq_fund_no.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_item_code_seq.sql ]...... 
  ------------------- 适用于物品序号-----------------------------
  ----针对表ITEM_ITEMS(物品) 的ITEM_CODE字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_item_code_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'IT'||lpad(seq_item_code.nextval,6,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_item_detail_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于物品出入库及盘点明细的序号发生器----------------------------
  ----add by 陈震: 2015/9/24
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_item_detail_seq
   RETURN NUMBER IS
BEGIN
   return seq_item_sequence_no.nextval;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_item_ic_no_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于物品盘点序号----------------------------
  ----针对表ITEM_CHECK的ic_no字段创建同一序列函数
  ----add by 陈震: 2015/10/16
/********************************************************************************/
create or replace function f_get_item_ic_no_seq
   return varchar2 is
begin
   return 'IC'||lpad(seq_item_no.nextval,8,'0');
end;
 
/ 
prompt 正在建立[FUNCTION -> f_get_item_id_no_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于物品损毁序号----------------------------
  ----针对表ITEM_DAMAGE的id_no字段创建同一序列函数
  ----add by 陈震: 2015/10/16
/********************************************************************************/
create or replace function f_get_item_id_no_seq
   return varchar2 is
begin
   return 'ID'||lpad(seq_item_no.nextval,8,'0');
end;
 
/ 
prompt 正在建立[FUNCTION -> f_get_item_ii_no_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于物品入库序号----------------------------
  ----针对表item_issue的ii_no字段创建同一序列函数
  ----add by 陈震: 2015/10/16
/********************************************************************************/
create or replace function f_get_item_ii_no_seq
   return varchar2 is
begin
   return 'II'||lpad(seq_item_no.nextval,8,'0');
end;
 
/ 
prompt 正在建立[FUNCTION -> f_get_item_ir_no_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于物品入库序号----------------------------
  ----针对表item_receipt的ir_no字段创建同一序列函数
  ----add by 陈震: 2015/10/16
/********************************************************************************/
create or replace function f_get_item_ir_no_seq
   return varchar2 is
begin
   return 'IR'||lpad(seq_item_no.nextval,8,'0');
end;
 
/ 
prompt 正在建立[FUNCTION -> f_get_lottery_info.sql ]...... 
create or replace function f_get_lottery_info
------------------- 适用于获取彩票对象的各种信息-----------------------------
   -- add by 陈震 @ 2015/9/19
   -- 根据 “箱”“盒”“本”计算指定批次的 “箱”“盒”开始“本”、结束“本”号码
   -- 输入参数
   --    1、方案
   --    2、批次
   --    3、有效位数
   --    4、号码
/********************************************************************************/
(
   p_plan              in char,                -- 方案
   p_batch             in char,                -- 批次
   p_valid_number      in number,              -- 有效位数
   p_value             in char                 -- “箱”“盒”“本”号码
)
return type_lottery_info
is
   v_collect_batch_param   game_batch_import_detail%rowtype;               -- 批次参数
   v_plan_publish          number(1);                                      -- 印制厂商编号
   v_box_number            number(9);                                      -- 第几盒
   v_packs_every_box       number(10);                                     -- 每“盒”中包含多少“本”
   v_tickets_every_trunk   number(10);                                     -- 每“箱”票数
   v_rtv                   type_lottery_info;                              -- 返回值

begin
   v_rtv := type_lottery_info(p_plan,p_batch,p_valid_number,null,null,null,null,null,null);

   -- 获取印制厂商信息
   select plan_flow
     into v_plan_publish
     from inf_publishers
    where publisher_code =
          (select publisher_code from game_plans where plan_code = p_plan);

   -- 获取保存的参数
   select * into v_collect_batch_param from game_batch_import_detail where plan_code = p_plan and batch_no = p_batch;

   -- 每“盒”中包含多少“本”
   v_packs_every_box := v_collect_batch_param.packs_every_trunk / v_collect_batch_param.boxes_every_trunk;
   v_tickets_every_trunk := v_collect_batch_param.packs_every_trunk * v_collect_batch_param.tickets_every_pack;

   -- 校验输入的参数内容
   case
      when p_valid_number = evalid_number.trunk then
         if to_number(p_value) > v_collect_batch_param.tickets_every_batch / v_collect_batch_param.packs_every_trunk / v_collect_batch_param.tickets_every_pack then
            raise_application_error(-20001, dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || dbtool.format_line(p_value) || error_msg.err_f_get_lottery_info_1);  -- 输入的“箱”号超出合法的范围
         end if;
      when p_valid_number = evalid_number.box then
         v_box_number := substr(p_value, epublisher_sjz.len_trunk + 2, epublisher_sjz.len_box);
         if v_box_number > v_collect_batch_param.packs_every_trunk / v_packs_every_box then
            raise_application_error(-20001, dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || dbtool.format_line(p_value) || error_msg.err_f_get_lottery_info_2);  -- 输入的“盒”号超出合法的范围
         end if;
      when p_valid_number = evalid_number.pack then
         if to_number(p_value) > v_collect_batch_param.tickets_every_batch / v_collect_batch_param.tickets_every_pack then
            raise_application_error(-20001, dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || dbtool.format_line(p_value) || error_msg.err_f_get_lottery_info_3);  -- 输入的“本”号超出合法的范围
         end if;
   end case;

   -- 计算
   case
      when p_valid_number = evalid_number.trunk then
         v_rtv.trunk_no := p_value;
         v_rtv.box_no := p_value || '-' || lpad(1, epublisher_sjz.len_box, '0');
         v_rtv.box_no_e := p_value || '-' || lpad(to_number(v_collect_batch_param.boxes_every_trunk), epublisher_sjz.len_box, '0');
         v_rtv.package_no := lpad((to_number(p_value) - 1) * v_collect_batch_param.packs_every_trunk + 1, epublisher_sjz.len_package, '0');
         v_rtv.package_no_e := lpad(to_number(p_value) * v_collect_batch_param.packs_every_trunk, epublisher_sjz.len_package, '0');

      when p_valid_number = evalid_number.box then
         v_rtv.trunk_no := substr(p_value, 1, epublisher_sjz.len_trunk);
         v_box_number := substr(p_value, epublisher_sjz.len_trunk + 2, epublisher_sjz.len_box);
         v_rtv.box_no := p_value;
         v_rtv.package_no := lpad((to_number(v_rtv.trunk_no) - 1) * v_collect_batch_param.packs_every_trunk + v_packs_every_box * (v_box_number - 1) + 1, epublisher_sjz.len_package, '0');
         v_rtv.package_no_e := lpad(to_number(v_rtv.package_no) + v_packs_every_box - 1, epublisher_sjz.len_package, '0');

      when p_valid_number = evalid_number.pack then
         v_rtv.trunk_no := lpad(ceil(p_value / v_collect_batch_param.packs_every_trunk), epublisher_sjz.len_trunk, '0');
         v_rtv.box_no := v_rtv.trunk_no || '-' || lpad(ceil((to_number(p_value) - (to_number(v_rtv.trunk_no) - 1) * v_collect_batch_param.PACKS_EVERY_TRUNK) / v_packs_every_box), epublisher_sjz.len_box, '0');
         v_rtv.package_no := p_value;

   end case;

   -- 计算奖组
   v_rtv.reward_group := ceil(to_number(v_rtv.trunk_no) * (v_collect_batch_param.PACKS_EVERY_TRUNK * v_collect_batch_param.TICKETS_EVERY_PACK) / (v_collect_batch_param.tickets_every_group));

   return v_rtv;

end;
 
/ 
prompt 正在建立[FUNCTION -> f_get_old_plan_name.sql ]...... 
/********************************************************************************/
  ------------------- 返回方案的名称（包含旧票） -----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_old_plan_name(
   p_plan IN STRING, -- 方案
   p_batch in string -- 批次

) RETURN STRING IS
   /*-----------    变量定义     -----------------*/
   v_ret_code STRING(64) := ''; -- 返回值

BEGIN
   case
      when (p_plan = 'J0002' or (p_plan = 'J2015' and p_batch = '00001')) then
         return 'Iphone';
      when (p_plan = 'J0003' or (p_plan = 'J2015' and p_batch = '00002')) then
         return 'Ball';
      when (p_plan = 'J0004') then
         return 'GongXi';
      when (p_plan = 'J0005') then
         return 'DGL';
      when (p_plan = 'J2014') then
         return 'Love';
      else
         select SHORT_NAME
           into v_ret_code
           from game_plans
          where PLAN_CODE = p_plan;

   end case;

   return v_ret_code;

END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_org_comm_rate.sql ]...... 
/********************************************************************************/
  ------------------- 获取组织机构的佣金比例 -----------------------------
  ----add by 陈震: 2015-12-20
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_org_comm_rate(
   p_org    IN STRING,        -- 站点编码
   p_plan   in string,        -- 方案
   p_batch  in string,        -- 批次
   p_type   in number         -- 佣金类型 （1=销售、2=兑奖）

) RETURN number IS
   /*-----------    变量定义     -----------------*/
   v_rtv number; -- 返回值

   v_plan            varchar2(50);
   v_sale_comm       number(10);
   v_pay_comm        number(10);

BEGIN
   -- 按照方案设置对应的佣金
   case
      -- Iphone
      when (p_plan = 'J0002' or (p_plan = 'J2015' and p_batch = '00001')) then
         v_plan := 'J0002';

      -- Ball
      when (p_plan = 'J0003' or (p_plan = 'J2015' and p_batch = '00002')) then
         v_plan := 'J0003';

      -- GongXi
      when (p_plan = 'J0004') then
         v_plan := 'J0004';

      -- DGL
      when (p_plan = 'J0005') then
         v_plan := 'J0005';

      -- Love
      when (p_plan = 'J2014') then
         -- 爱心没有销售佣金，所以这里要注意
         if p_type = 1 then
            return -1;
         end if;

         v_rtv := to_number(f_get_sys_param(12));
         return v_rtv;

      else
         v_plan := p_plan;

   end case;

   -- 检索相应的佣金比例，如果未查询到，则返回 -1
   begin
      select sale_comm, pay_comm into v_sale_comm, v_pay_comm  from game_org_comm_rate where org_code = p_org and plan_code = v_plan;
   exception
      when no_data_found then
         return -1;
   end;

   if p_type = 1 then
      v_rtv := v_sale_comm;
   else
      v_rtv := v_pay_comm;
   end if;

   return v_rtv;

END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_org_comm_rate_by_name.sql ]...... 
/********************************************************************************/
  ------------------- 获取组织机构的佣金比例 -----------------------------
  ----add by 陈震: 2015-12-20
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_org_comm_rate_by_name(
   p_org    IN STRING,        -- 站点编码
   p_plan   in string,        -- 方案名称
   p_type   in number         -- 佣金类型 （1=销售、2=兑奖）

) RETURN number IS
   /*-----------    变量定义     -----------------*/
   v_rtv number; -- 返回值

   v_plan            varchar2(50);
   v_sale_comm       number(10);
   v_pay_comm        number(10);

BEGIN
   -- 按照方案设置对应的佣金
   case
      -- Iphone
      when (p_plan = 'Iphone') then
         v_plan := 'J0002';

      -- Ball
      when (p_plan = 'Ball') then
         v_plan := 'J0003';

      -- GongXi
      when (p_plan = 'GongXi') then
         v_plan := 'J0004';

      -- DGL
      when (p_plan = 'DGL') then
         v_plan := 'J0005';

      -- Love
      when (p_plan = 'Love') then
         -- 爱心没有销售佣金，所以这里要注意
         if p_type = 1 then
            return -1;
         end if;

         v_rtv := to_number(f_get_sys_param(12));
         return v_rtv;

      else
         v_plan := p_plan;

   end case;

   -- 检索相应的佣金比例，如果未查询到，则返回 -1
   begin
      select sale_comm, pay_comm into v_sale_comm, v_pay_comm  from game_org_comm_rate where org_code = p_org and plan_code = v_plan;
   exception
      when no_data_found then
         return -1;
   end;

   if p_type = 1 then
      v_rtv := v_sale_comm;
   else
      v_rtv := v_pay_comm;
   end if;

   return v_rtv;

END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_org_game_comm.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_org_game_comm(
   p_org_code IN STRING,     --站点编码
   p_game_code in number,    -- 游戏编码
   p_comm_type in number     -- 代销费类型（ecomm_type）

) RETURN number IS
   /*-----------    变量定义     -----------------*/
   v_ret_code number(8);   -- 返回值
   v_org_type number(1);   -- 组织机构类型

BEGIN

   -- 检测组织机构类型
   select org_type
     into v_org_type
     from inf_orgs
    where org_code = p_org_code;

   if v_org_type = eorg_type.company then
      v_ret_code := 0;
      return v_ret_code;
   end if;

   case p_comm_type
      when ecomm_type.sale then
         begin
            select sale_commission_rate into v_ret_code
              from auth_org
             where org_code = p_org_code
               and game_code = p_game_code;
         exception
            when no_data_found then
               v_ret_code := 0;
         end;

      when ecomm_type.pay then
         begin
            select pay_commission_rate into v_ret_code
              from auth_org
             where org_code = p_org_code
               and game_code = p_game_code;
         exception
            when no_data_found then
               v_ret_code := 0;
         end;
   end case;

   return v_ret_code;

END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_org_type.sql ]...... 
/********************************************************************************/
  ------------------- 返回组织机构类型-----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
create or replace function f_get_org_type(
   p_org in char --站点编码

) return number is
   /*-----------    变量定义     -----------------*/
   v_ret_code number(1); -- 返回值

begin

   select org_type
     into v_ret_code
     from inf_orgs
    where org_code = p_org;

   return v_ret_code;

end;
 
/ 
prompt 正在建立[FUNCTION -> f_get_plan_code_by_name.sql ]...... 
/********************************************************************************/
  ------------------- 返回方案的名称（包含旧票） -----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_plan_code_by_name(
   p_plan_name IN STRING

) RETURN STRING IS
   /*-----------    变量定义     -----------------*/
   v_ret_code STRING(4000) := ''; -- 返回值

BEGIN

   case
      when p_plan_name = 'Iphone' then
         return 'J0002';

      when p_plan_name = 'Ball' then
         return 'J0003';

      when p_plan_name = 'GongXi' then
         return 'J0004';

      when p_plan_name = 'DGL' then
         return 'J0005';

      when p_plan_name = 'Love' then
         return 'J2014';

      else
         begin
            select plan_code into v_ret_code from game_plans where SHORT_NAME = p_plan_name;
         exception
            when no_data_found then
               v_ret_code := '[NO NAME]';
         end;
         return v_ret_code;
   end case;

   return v_ret_code;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_plan_name.sql ]...... 
/********************************************************************************/
  ------------------- 返回方案的名称-----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_plan_name(
   p_plan IN STRING --站点编码

) RETURN STRING IS
   /*-----------    变量定义     -----------------*/
   v_ret_code STRING(64) := ''; -- 返回值

BEGIN

   select SHORT_NAME
     into v_ret_code
     from game_plans
    where PLAN_CODE = p_plan;

   return v_ret_code;

END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_plan_publisher.sql ]...... 
/********************************************************************************/
  ------------------- 获取方案对应的印制厂商 ----------------------------
  ---- add by 陈震: 2015/9/16
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_plan_publisher(
   p_plan in varchar2
)
   RETURN number

 IS
   v_publish number;

BEGIN
   select PUBLISHER_CODE into v_publish from GAME_PLANS where PLAN_CODE = p_plan;

   return v_publish;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_reward_ticket_ver.sql ]...... 
/********************************************************************************/
  ------------------- 返回彩票是否旧票（1-是，0-不是）-----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_reward_ticket_ver(
  p_plan                               in char,                               -- 方案编号
  p_batch                              in char,                               -- 批次编号
  p_package_no                         in varchar2                            -- 彩票本号

) RETURN number IS
   /*-----------    变量定义     -----------------*/
   v_count number(1);

BEGIN

   -- 票是否在系统库存中存在
   select count(*) into v_count from dual where exists(select 1 from wh_ticket_package where plan_code = p_plan and batch_no = p_batch and package_no = p_package_no);
   return 1 - v_count;

END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_right_issue.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_right_issue(p_game_code number, p_issue_seq number)
   RETURN number IS
   v_issue_current number(12);
   v_cnt           number(2);
BEGIN
   if p_issue_seq >= 0 then
      return p_issue_seq;
   end if;
   begin
      SELECT issue_number
        INTO v_issue_current
        FROM iss_game_issue
       WHERE game_code = p_game_code
         AND issue_seq = abs(p_issue_seq)
         and issue_status > egame_issue_status.prearrangement;
   exception
      when no_data_found then
         v_issue_current := p_issue_seq;
   end;

   return v_issue_current;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_sale_ai_seq.sql ]...... 
/**************************************************************************************************************************/
  ------------------- 站点退货单序号发生器---------------------------
  ----针对表 SALE_AGENCY_RETURN (订单)的AI_NO字段创建同一序列函数
  ----add by 陈震: 2015/9/22
/**************************************************************************************************************************/
CREATE OR REPLACE FUNCTION f_get_sale_ai_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'AI'||lpad(seq_order_no.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_sale_ar_seq.sql ]...... 
/**************************************************************************************************************************/
  ------------------- 适用于订单、出货单、调拨单、退货单、损毁单、盘点单和批次入库单编号的序列---------------------------
  ----针对表 SALE_AGENCY_RECEIPT (订单)的AR_NO字段创建同一序列函数
  ----add by 陈震: 2015/9/22
/**************************************************************************************************************************/
CREATE OR REPLACE FUNCTION f_get_sale_ar_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'AR'||lpad(seq_order_no.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_sale_delivery_order_seq.sql ]...... 
/**************************************************************************************************************************/
  ------------------- 适用于订单、出货单、调拨单、退货单、损毁单、盘点单和批次入库单编号的序列---------------------------
  ----针对表SALE_DELIVERY_ORDER(出货单)的DO_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/**************************************************************************************************************************/
CREATE OR REPLACE FUNCTION f_get_sale_delivery_order_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'CH'||lpad(seq_order_no.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_sale_guicancel_seq.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_sale_guicancel_seq(agency_code NUMBER)
   RETURN VARCHAR2 IS
   /****************************************************************/
   ------------------- 适用于生成兑奖、取消流水--------------------
   -------add by 陈震 2014-7-12 格式 十二位terminal_code+六位日期+六位序列号-------
   /*************************************************************/
   v_date_str   CHAR(6); --日期格式字符串
   v_seq_str    CHAR(6); --序号字符串
   v_temp_count NUMBER := 0; --临时变量

BEGIN
   v_temp_count := seq_sale_gui_cancel.nextval;
   v_date_str   := to_char(SYSDATE, 'yymmdd');
   v_seq_str    := to_char(lpad(v_temp_count, 6, '0'));

   RETURN to_char(rpad(agency_code, 12, '0')) || v_date_str || v_seq_str;
END; 
/ 
prompt 正在建立[FUNCTION -> f_get_sale_guipay_seq.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_sale_guipay_seq(agency_code NUMBER)
   RETURN VARCHAR2 IS
   /****************************************************************/
   ------------------- 适用于生成兑奖、取消流水--------------------
   -------add by 陈震 2014-7-12 格式 十二位terminal_code+六位日期+六位序列号-------
   /*************************************************************/
   v_date_str        CHAR(6);       --日期格式字符串
   v_seq_str         CHAR(6);       --序号字符串
   v_temp_count      NUMBER := 0;   --临时变量

BEGIN
   v_temp_count := seq_sale_gui_pay.nextval;
   v_date_str := to_char(SYSDATE, 'yymmdd');
   v_seq_str  := to_char(lpad(v_temp_count, 6, '0'));

   RETURN to_char(rpad(agency_code, 12, '0')) || v_date_str || v_seq_str;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_sale_order_seq.sql ]...... 
/**************************************************************************************************************************/
  ------------------- 适用于订单、出货单、调拨单、退货单、损毁单、盘点单和批次入库单编号的序列---------------------------
  ----针对表SALE_ORDER(订单)的ORDER_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11
/**************************************************************************************************************************/
CREATE OR REPLACE FUNCTION f_get_sale_order_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'DD'||lpad(seq_order_no.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_sale_return_recoder_seq.sql ]...... 
/**************************************************************************************************************************/
  ------------------- 适用于订单、出货单、调拨单、退货单、损毁单、盘点单和批次入库单编号的序列---------------------------
  ----针对表SALE_RETURN_RECODER(退货单)的RETURN_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/**************************************************************************************************************************/
CREATE OR REPLACE FUNCTION f_get_sale_return_recoder_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'TH'||lpad(seq_order_no.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_sale_transfer_bill_seq.sql ]...... 
/**************************************************************************************************************************/
  ------------------- 适用于订单、出货单、调拨单、退货单、损毁单、盘点单和批次入库单编号的序列---------------------------
  ----针对表SALE_TRANSFER_BILL(调拨单)的STB_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/**************************************************************************************************************************/
CREATE OR REPLACE FUNCTION f_get_sale_transfer_bill_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'DB'||lpad(seq_order_no.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_switch_no_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于验奖记录序号----------------------------
  ----add by 陈震: 2015-12-16
/********************************************************************************/

CREATE OR REPLACE FUNCTION f_get_switch_no_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'SW'||lpad(seq_switch_flow.nextval,22,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_switch_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于验奖记录序号----------------------------
  ----add by 陈震: 2015-12-16
/********************************************************************************/

CREATE OR REPLACE FUNCTION f_get_switch_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'WS'||lpad(seq_switch_flow.nextval,22,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_sys_clog_info_seq.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_sys_clog_info_seq RETURN number IS
BEGIN
    return seq_sys_clog_info.nextval;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_sys_hostlogid_seq.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_sys_hostlogid_seq RETURN number IS
BEGIN
    return seq_upg_schedule_id.nextval;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_sys_noticeid_seq.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_sys_noticeid_seq RETURN number IS
BEGIN
    return seq_sys_host_logid.nextval;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_sys_param.sql ]...... 
create or replace function f_get_sys_param
/*******************************************************************************/
  ----- 获取系统参数
  ----- add by 陈震 @ 2016-04-19
  -----
/*******************************************************************************/
(
  p_param in number
)
  return varchar2
  result_cache
  relies_on(inf_agencys)
is
  v_rtv varchar2(4000);
begin
  begin
    select sys_default_value into v_rtv from sys_parameter where sys_default_seq = p_param;
  exception
    when no_data_found then
      raise_application_error(-20001, error_msg.err_f_get_sys_param_1);
      return '';
  end;

  return v_rtv;
end;
 
/ 
prompt 正在建立[FUNCTION -> f_get_teller_role.sql ]...... 
/********************************************************************************/
  ------------------- 返回teller类型-----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
create or replace function f_get_teller_role(
  p_teller in number --站点编码

) return number
  result_cache
  relies_on(inf_tellers)

is
  /*-----------    变量定义     -----------------*/
  v_ret_code number(2); -- 返回值

begin

    select teller_type
      into v_ret_code
      from inf_tellers
     where teller_code = p_teller;

  return v_ret_code;

end;
 
/ 
prompt 正在建立[FUNCTION -> f_get_teller_static.sql ]...... 
create or replace function f_get_teller_static(
  p_teller in number -- 销售员编码

) return number
  result_cache
  relies_on(inf_tellers)

is
  /*-----------    变量定义     -----------------*/
  v_ret_code number(2); -- 返回值

begin
  begin
    select status
      into v_ret_code
      from inf_tellers
     where teller_code = p_teller;

   exception
      when no_data_found then
      return 13;
   end;
   
   return v_ret_code;
 
end;
 
/ 
prompt 正在建立[FUNCTION -> f_get_ticket_memo.sql ]...... 
create or replace function f_get_ticket_memo
(
/*******************************************************************************/
  ----- 获取票面宣传语
  ----- add by Chen Zhen @ 2016-04-20

/*******************************************************************************/
  p_game_code in number       -- 游戏编码，0表示所有游戏
)
  return varchar2
  result_cache
  relies_on(sys_ticket_memo)
is
  v_ret_str varchar2(4000);
begin
  begin
    select ticket_memo
      into v_ret_str
      from sys_ticket_memo
     where game_code = p_game_code
       and his_code = (select max(his_code)
                         from sys_ticket_memo
                        where game_code = p_game_code);
  exception
    when no_data_found then
      v_ret_str := '';
  end;

  return v_ret_str;
end;
 
/ 
prompt 正在建立[FUNCTION -> f_get_upg_schedule_seq.sql ]...... 
CREATE OR REPLACE FUNCTION f_get_upg_schedule_seq RETURN number IS
BEGIN
    return seq_sys_noticeid.nextval;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_warehouse_code.sql ]...... 
/********************************************************************************/
  ------------------- 适用于仓库编号的生成 ----------------------------
  ----针对表WH_GOODS_RECEIPT_DETAIL(入库单明细)的SGI_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_warehouse_code(p_org_code in char)
   RETURN VARCHAR2

 IS
   v_max_code char(4);
BEGIN
   -- 查找此部门的最大仓库编号
   select max(WAREHOUSE_CODE)
     into v_max_code
     from WH_INFO
    where org_code = p_org_code;
   if v_max_code is null then
      return p_org_code || '01';
   end if;

   return p_org_code || lpad(to_number(substr(v_max_code, 3, 2)) + 1, 2, '0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_whgoodsreceipt_detai_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于出库单入库单明细序号----------------------------
  ----针对表WH_GOODS_RECEIPT_DETAIL(入库单明细)的SGI_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_whgoodsreceipt_detai_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'RK'||lpad(seq_wh_sgi_sgr_detail_no.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_wh_batch_end_seq.sql ]...... 
/**************************************************************************************************************************/
  ------------------- 适用于订单、出货单、调拨单、退货单、损毁单、盘点单和批次入库单编号的序列---------------------------
  ----针对表 批次终结（WH_BATCH_END） 的BE_NO字段创建序列函数
  ----add by 陈震: 2015/9/21
/**************************************************************************************************************************/
CREATE OR REPLACE FUNCTION f_get_wh_batch_end_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'ZJ'||lpad(seq_order_no.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_wh_batch_inbound_seq.sql ]...... 
/**************************************************************************************************************************/
  ------------------- 适用于订单、出货单、调拨单、退货单、损毁单、盘点单和批次入库单编号的序列---------------------------
  ----针对表wh_batch_inbound(批次入库)的INBOUND_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/**************************************************************************************************************************/
CREATE OR REPLACE FUNCTION f_get_wh_batch_inbound_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'BI'||lpad(seq_order_no.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_wh_broken_recoder_seq.sql ]...... 
/**************************************************************************************************************************/
  ------------------- 适用于订单、出货单、调拨单、退货单、损毁单、盘点单和批次入库单编号的序列---------------------------
  ----针对表WH_BROKEN_RECODER(损毁单)的BROKEN_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/**************************************************************************************************************************/
CREATE OR REPLACE FUNCTION f_get_wh_broken_recoder_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'SH'||lpad(seq_order_no.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_wh_check_point_seq.sql ]...... 
/**************************************************************************************************************************/
  ------------------- 适用于订单、出货单、调拨单、退货单、损毁单、盘点单和批次入库单编号的序列---------------------------
  ----针对表WH_CHECK_POINT(盘点单)的CP_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/**************************************************************************************************************************/
CREATE OR REPLACE FUNCTION f_get_wh_check_point_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'PD'||lpad(seq_order_no.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_wh_goodsissue_detail_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于出库单入库单明细序号----------------------------
  ----针对表WH_GOODS_ISSUE_DETAIL(出库单明细) 的SGI_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_wh_goodsissue_detail_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'CK'||lpad(seq_wh_sgi_sgr_detail_no.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_wh_goods_issue_detai_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于出库单入库单明细序号----------------------------
  ----针对表WH_GOODS_ISSUE_DETAIL(出库单明细) 的SGI_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_wh_goods_issue_detai_seq
   RETURN NUMBER IS
BEGIN
   return seq_wh_sgi_sgr_detail_no.nextval;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_wh_goods_issue_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于出库单入库单序号----------------------------
  ----针对表WH_GOODS_ISSUE(出库单) 的SGI_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_wh_goods_issue_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'CK'||lpad(seq_wh_sgi_sgr_no.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_wh_goods_receipt_detai_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于出库单入库单明细序号----------------------------
  ----针对表WH_GOODS_RECEIPT_DETAIL(入库单明细)的SGI_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_wh_goods_receipt_det_seq
   RETURN NUMBER IS
BEGIN
   return seq_wh_sgi_sgr_detail_no.nextval;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_get_wh_goods_receipt_seq.sql ]...... 
/********************************************************************************/
  ------------------- 适用于出库单入库单序号----------------------------
  ----针对表WH_GOODS_RECEIPT(入库单) 的SGR_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11 
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_wh_goods_receipt_seq
   RETURN VARCHAR2 IS
BEGIN
   return 'RK'||lpad(seq_wh_sgi_sgr_no.nextval,8,'0');
END;
 
/ 
prompt 正在建立[FUNCTION -> f_lottery_print.sql ]...... 
CREATE OR REPLACE function f_print_lottery
/****************************************************************/
  ------------------- 适用返回彩票信息 -------------------
  ---- 创建系统用户
  ---- add by 陈震: 2015/9/29
/*************************************************************/
(
 --------------输入----------------
   p_lot             in type_lottery_info
) return varchar2 IS
   v_rtv varchar2(4000);

BEGIN
   v_rtv :=    dbtool.format_line('PLAN: ' || p_lot.plan_code)
            || dbtool.format_line('PLAN: ' || p_lot.batch_no)
            || dbtool.format_line('TRUNK: ' || p_lot.trunk_no)
            || dbtool.format_line('BOX: ' || nvl(p_lot.box_no, '-'))
            || dbtool.format_line('PACKAGE: ' || nvl(p_lot.package_no, '-'));
   return v_rtv;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_print_lottery_info.sql ]...... 
CREATE OR REPLACE function f_print_lottery
/****************************************************************/
  ------------------- 适用返回彩票信息 -------------------
  ---- 创建系统用户
  ---- add by 陈震: 2015/9/29
/*************************************************************/
(
 --------------输入----------------
   p_lot             in type_lottery_info
) return varchar2 IS
   v_rtv varchar2(4000);

BEGIN
   v_rtv :=    dbtool.format_line(p_lot.plan_code)
            || dbtool.format_line(p_lot.batch_no)
            || dbtool.format_line(p_lot.trunk_no)
            || dbtool.format_line(nvl(p_lot.box_no, '-'))
            || dbtool.format_line(nvl(p_lot.package_no, '-'));
   return v_rtv;
END;
 
/ 
prompt 正在建立[FUNCTION -> f_set_auth.sql ]...... 
create or replace function f_set_auth
/*******************************************************************************/
  ----- 主机：终端认证
  ----- add by 陈震 @ 2016-04-19
  -----
/*******************************************************************************/
(
  p_mac in string, --登录的终端机mac地址
  p_ver in string  --登录的终端机软件版本号

) return string
  result_cache
  relies_on(inf_agencys, saler_terminal, upg_package)
is
  v_agency_code inf_agencys.agency_code%type;
  v_org inf_orgs.org_code%type;

  v_terminal_code saler_terminal.terminal_code%type;
  v_term_type   saler_terminal.term_type_id%type;

  v_count number := 0;
begin

  --检查终端机对应的销售站是否存在
  begin
    -- 检查mac地址对应的终端机是否存在且有效
    select agency_code, terminal_code, term_type_id
      into v_agency_code, v_terminal_code, v_term_type
      from saler_terminal
     where mac_address = upper(p_mac)
       and status = eterminal_status.enabled;

    -- 检查对应的销售站状态是否有效
    select agency_code, org_code
      into v_agency_code, v_org
      from inf_agencys
     where agency_code = v_agency_code
       and status = eagency_status.enabled;

    -- 检查对应的部门状态是否有效
    select org_code
      into v_org
      from inf_orgs
     where org_code = v_org
       and org_status = eorg_status.available;

  exception
    when no_data_found then
      return 'null, null, null, ' || ehost_error.host_t_authenticate_err;
  end;

  -- 检查版本是否可用
  select count(*)
    into v_count
    from dual
   where exists(select 1
                  from upg_package
                 where pkg_ver = p_ver
                   and adapt_term_type = v_term_type
                   and is_valid = eboolean.yesorenabled);
  if v_count = 0 then
    return 'null, null, null, ' || ehost_error.host_version_not_available_err;
  end if;

  return v_agency_code || ',' || to_char(v_terminal_code) || ',' || v_org || ',0';
end;
 
/ 
prompt 正在建立[FUNCTION -> f_set_check_game_auth.sql ]...... 
create or replace function f_set_check_game_auth
/*******************************************************************************/
  ----- 主机：游戏授权检查（销售站+机构）
  ----- add by 陈震 @ 2016-04-19
  -----
/*******************************************************************************/
(
  p_agency in inf_agencys.agency_code%type,        -- 登录销售站
  p_game   in inf_games.game_code%type,            -- 游戏编码
  p_type   in number                               -- 检查类型（1-销售，2-兑奖，3-退票）

) return number
  result_cache
  relies_on(auth_org, auth_agency)
is
  v_org inf_orgs.org_code%type;
  v_count number(1);

begin
  -- 检查销售站游戏授权
  case p_type
    when 1 then                                    	-- 销售
      select count(*)
        into v_count
        from dual
       where exists(select 1
                      from AUTH_AGENCY
                     where AGENCY_CODE = p_agency
                       and game_code = p_game
                       and ALLOW_SALE = eboolean.yesorenabled);

    when 2 then                                     -- 兑奖
      select count(*)
        into v_count
        from dual
       where exists(select 1
                      from AUTH_AGENCY
                     where AGENCY_CODE = p_agency
                       and game_code = p_game
                       and ALLOW_pay = eboolean.yesorenabled);

    when 3 then                                     -- 退票
      select count(*)
        into v_count
        from dual
       where exists(select 1
                      from AUTH_AGENCY
                     where AGENCY_CODE = p_agency
                       and game_code = p_game
                       and ALLOW_cancel = eboolean.yesorenabled);

  end case;

  if v_count = 0 then
    return 0;
  end if;

  -- 获取组织机构编码
  v_org := f_get_agency_org(p_agency);

  -- 检查组织机构游戏授权
  case p_type
    when 1 then                                    	-- 销售
      select count(*)
        into v_count
        from dual
       where exists(select 1
                      from AUTH_ORG
                     where ORG_CODE = v_org
                       and game_code = p_game
                       and ALLOW_SALE = eboolean.yesorenabled);

    when 2 then                                     -- 兑奖
      select count(*)
        into v_count
        from dual
       where exists(select 1
                      from AUTH_ORG
                     where ORG_CODE = v_org
                       and game_code = p_game
                       and ALLOW_pay = eboolean.yesorenabled);

    when 3 then                                     -- 退票
      select count(*)
        into v_count
        from dual
       where exists(select 1
                      from AUTH_ORG
                     where ORG_CODE = v_org
                       and game_code = p_game
                       and ALLOW_cancel = eboolean.yesorenabled);

  end case;

  return v_count;
end;
 
/ 
prompt 正在建立[FUNCTION -> f_set_check_general.sql ]...... 
create or replace function f_set_check_general
/*******************************************************************************/
  ----- add by 孔维鑫 @ 2016-04-19
  -----
  /*******************************************************************************/
(
  p_terminal_code in char,
  p_teller_code   in number,
  p_agency_code   in char,
  p_org_code      in char
) return number
  result_cache
  relies_on(saler_terminal,inf_tellers,inf_agencys,inf_orgs)
is
  v_terminal_code saler_terminal.terminal_code%type;
  v_teller_code   inf_tellers.teller_code%type;
  v_agency_code   inf_agencys.agency_code%type;
  v_org_code      inf_orgs.org_code%type;

  v_count number := 0;
begin
  begin
    --检查对应的终端机是否存在,且可用
    select terminal_code
      into v_terminal_code
      from saler_terminal
     where terminal_code = p_terminal_code
       and status = eterminal_status.enabled;

    --检查对应的销售员是否存在,且可用
    select teller_code
      into v_teller_code
      from inf_tellers
     where teller_code = p_teller_code
       and status = eteller_status.enabled;

    --检查对应的销售站是否存在,且可用
    select agency_code
      into v_agency_code
      from inf_agencys
     where agency_code = p_agency_code
       and status = eagency_status.enabled;

    --检查对应的部门是否存在，且可用
    select org_code
      into v_org_code
      from inf_orgs
     where org_code = p_org_code
       and org_status = eorg_status.available;

  exception
    when no_data_found then
      return ehost_error.host_t_token_expired_err;
  end;

  --检查培训员是否登录
  select count(*)
    into v_count
    from dual
   where exists (select 1
            from inf_tellers
           where teller_code = p_teller_code
             and LATEST_TERMINAL_CODE = p_terminal_code
             and is_online = eboolean.yesorenabled);
  if v_count = 0 then
    return ehost_error.host_t_teller_signout_err;
  end if;
  return 0;
end;
 
/ 
prompt 正在建立[FUNCTION -> f_set_check_pay_level.sql ]...... 
create or replace function f_set_check_pay_level
/*******************************************************************************/
  ----- 主机：判断兑奖销售站是否在兑奖范围内
  ----- add by 陈震 @ 2016-04-19
  -----
/*******************************************************************************/
(
  p_pay_agency    in inf_agencys.agency_code%type,       -- 兑奖销售站
  p_sale_agency   in inf_agencys.agency_code%type,       -- 售票销售站
  p_game_code     in inf_games.game_code%type            -- 游戏

) return number
  result_cache
  relies_on(auth_agency)
is
  v_claiming_scope auth_agency.claiming_scope%type;    -- 兑奖范围

begin
  -- 获取兑奖销售站兑奖范围
  select claiming_scope
    into v_claiming_scope
    from auth_agency
   where agency_code = p_pay_agency
     and game_code = p_game_code;

  case v_claiming_scope
    when eclaiming_scope.center then
      return 1;

    when eclaiming_scope.org then
      if f_get_agency_org(p_pay_agency) = f_get_agency_org(p_sale_agency) then
        return 1;
      else
        return 0;
      end if;

    when eclaiming_scope.agency then
      if p_pay_agency = p_sale_agency then
        return 1;
      else
        return 0;
      end if;

  end case;
end;
 
/ 
prompt 正在建立[FUNCTION -> f_set_login.sql ]...... 
create or replace function f_set_login
/*******************************************************************************/
  ----- 主机：teller 登录
  ----- add by 陈震 @ 2016-04-19
  -----
/*******************************************************************************/
(
  p_teller in inf_tellers.teller_code%type,       -- 登录销售员
  p_term   in inf_terminal.terminal_code%type,    -- 登录终端
  p_agency in inf_agencys.agency_code%type,       -- 登录销售站
  p_pass   in varchar2                            -- 登录密码

) return string
  result_cache
  relies_on(inf_tellers, inf_agencys, saler_terminal, upg_package)
is
  v_teller_info inf_tellers%rowtype;
  v_term_info saler_terminal%rowtype;
  v_agency_info inf_agencys%rowtype;

  v_org inf_orgs.org_code%type;
  v_balance acc_agency_account.account_balance%type;
  v_credit acc_agency_account.credit_limit%type;

begin

  --检查终端机对应的销售站是否存在
  begin
    -- 检查mac地址对应的终端机是否存在且有效
    select *
      into v_teller_info
      from inf_tellers
     where teller_code = p_teller
       and status = eteller_status.enabled
       and password = p_pass;
  exception
    when no_data_found then
      return 'null, null, null, null, ' || ehost_error.host_t_namepwd_err;
  end;

  begin
    -- 检查mac地址对应的终端机是否存在且有效
    select *
      into v_term_info
      from saler_terminal
     where terminal_code = p_term
       and status = eterminal_status.enabled;

    -- 检查对应的销售站状态是否有效
    select *
      into v_agency_info
      from inf_agencys
     where agency_code = v_term_info.agency_code
       and status = eagency_status.enabled;

    -- 检查对应的部门状态是否有效
    select org_code
      into v_org
      from inf_orgs
     where org_code = v_agency_info.org_code
       and org_status = eorg_status.available;

  exception
    when no_data_found then
      return 'null, null, null, null, ' || ehost_error.host_t_token_expired_err;
  end;
  -- modify by kwx 2016-06-21 当销售员不在所属的站点登录的时候会在终端机界面不停的reset,因此改成5
  if not(v_teller_info.agency_code = v_term_info.agency_code and v_term_info.agency_code = p_agency) then
    return 'null, null, null, null, ' || ehost_error.host_t_namepwd_err;
  end if;

  begin
    select account_balance, credit_limit
      into v_balance, v_credit
      from acc_agency_account
     where ACC_TYPE = eacc_type.main_account
       and AGENCY_CODE = v_agency_info.agency_code;
  exception
    when no_data_found then
      raise_application_error(-20001, '没有找到销售站' || v_agency_info.agency_code || '对应的账户');
  end;

  -- 返回 teller type、流水号、余额、信用额度
  return v_teller_info.teller_type || ',' || v_term_info.trans_seq || ',' ||  to_char(v_balance) || ',' || to_char(v_credit) || ',0';
end;
 
/ 
prompt 正在建立[PROCEDURE -> p_admin_create.sql ]...... 
CREATE OR REPLACE PROCEDURE p_admin_create
/****************************************************************/
  ------------------- 适用创建系统用户-------------------
  ----创建系统用户
  ----add by dzg: 2015-9-17
  ----业务流程：先插入主表，如果是市场管理员，则插入市场管理员账户
  ----modify by dzg 2015-9-24 发现少操作一张表 inf_market_admin
  /*************************************************************/
(
 --------------输入----------------
 p_admin_realname    IN STRING, --真实姓名
 p_admin_loginid     IN STRING, --登录名
 p_admin_password    IN STRING, --默认密码
 p_admin_gender      IN NUMBER, --性别
 p_admin_insticode   IN STRING, --所属部门编码
 p_admin_birthday    IN Date, --出生日期
 p_admin_mobilephone IN STRING, --移动电话
 p_admin_officephone IN STRING, --办公电话
 p_admin_homephone   IN STRING, --家庭电话
 p_admin_email       IN STRING, --电子邮件
 p_admin_address     IN STRING, --家庭住址
 p_admin_remark      IN STRING, --备注信息
 p_admin_ismarketm   IN NUMBER, --是否市场管理员
 
 ---------出口参数---------
 c_admin_id  OUT NUMBER, -- 登陆用户ID
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 
 ) IS

  v_count_temp NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --真实姓名不能为空
  IF ((p_admin_realname IS NULL) OR length(p_admin_realname) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_ADMIN_CREATE_1;
    RETURN;
  END IF;

  --登陆名称不能为空
  IF ((p_admin_loginid IS NULL) OR length(p_admin_loginid) <= 0) THEN
    c_errorcode := 2;
    c_errormesg := error_msg.ERR_P_ADMIN_CREATE_2;
    RETURN;
  END IF;

  --登陆名称不能重复
  v_count_temp := 0;
  SELECT count(o.admin_id)
    INTO v_count_temp
    FROM adm_info o
   WHERE o.admin_login = p_admin_loginid
     AND o.admin_status <> eadmin_status.DELETED;

  IF v_count_temp > 0 THEN
    c_errorcode := 3;
    c_errormesg := error_msg.ERR_P_ADMIN_CREATE_3;
    RETURN;
  END IF;

  /*----------- 数据校验   -----------------*/
  --插入基本信息
  v_count_temp := f_get_adm_id_seq();

  insert into adm_info
    (admin_id,
     admin_realname,
     admin_login,
     admin_password,
     admin_gender,
     admin_email,
     admin_birthday,
     admin_tel,
     admin_mobile,
     admin_phone,
     admin_org,
     admin_address,
     admin_remark,
     admin_status,
     admin_create_time,
     create_admin_id,
     is_collecter)
  values
    (v_count_temp,
     p_admin_realname,
     p_admin_loginid,
     p_admin_password,
     P_admin_gender,
     P_admin_email,
     P_admin_birthday,
     p_admin_officephone,
     p_admin_mobilephone,
     p_admin_homephone,
     p_admin_insticode,
     p_admin_address,
     p_admin_remark,
     eadmin_status.AVAILIBLE,
     sysdate,
     0,
     p_admin_ismarketm);

  --循环的插入管理员信息，并更新权限信息表
  --先清理原有数据

  IF p_admin_ismarketm = eboolean.yesorenabled THEN
  
    ---插入市场管理员账户
    insert into acc_mm_account
      (market_admin,
       acc_type,
       acc_name,
       acc_status,
       acc_no,
       credit_limit,
       account_balance,
       check_code)
    values
      (v_count_temp,
       eacc_type.main_account,
       p_admin_realname,
       eacc_status.available,
       f_get_acc_no(v_count_temp, 'MM'),
       0,
       0,
       '-');
    --插入市场管理账户
    insert into inf_market_admin
      (market_admin, trans_pass, credit_by_tran, max_amount_ticketss)
    values
      (v_count_temp,
       p_admin_password,
       0,
       0);
  
  END IF;
  c_admin_id := v_count_temp;
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END p_admin_create;
/
 
/ 
prompt 正在建立[PROCEDURE -> p_admin_modify.sql ]...... 
CREATE OR REPLACE PROCEDURE p_admin_modify
/****************************************************************/
  ------------------- 适用修改系统用户-------------------
  ----创建系统用户
  ----add by dzg: 2015-11-10
  ----业务流程：修改用户
  /*************************************************************/
(
 --------------输入----------------
 p_admin_id          IN NUMBER, --ID
 p_admin_realname    IN STRING, --真实姓名
 p_admin_loginid     IN STRING, --登录名
 p_admin_gender      IN NUMBER, --性别
 p_admin_insticode   IN STRING, --所属部门编码
 p_admin_birthday    IN Date, --出生日期
 p_admin_mobilephone IN STRING, --移动电话
 p_admin_officephone IN STRING, --办公电话
 p_admin_homephone   IN STRING, --家庭电话
 p_admin_email       IN STRING, --电子邮件
 p_admin_address     IN STRING, --家庭住址
 p_admin_remark      IN STRING, --备注信息
 p_admin_defaultpwd  IN STRING, --默认密码
 p_admin_ismarketm   IN NUMBER, --是否市场管理员
 
 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 
 ) IS

  v_count_temp NUMBER := 0; --临时变量
  v_temp_str   varchar(100) := ''; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --真实姓名不能为空
  IF ((p_admin_realname IS NULL) OR length(p_admin_realname) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_ADMIN_CREATE_1;
    RETURN;
  END IF;

  --登陆名称不能为空
  IF ((p_admin_loginid IS NULL) OR length(p_admin_loginid) <= 0) THEN
    c_errorcode := 2;
    c_errormesg := error_msg.ERR_P_ADMIN_CREATE_2;
    RETURN;
  END IF;

  --用户已存在
  v_count_temp := 0;
  SELECT count(o.admin_id)
    INTO v_count_temp
    FROM adm_info o
   WHERE o.admin_id = p_admin_id
     AND o.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 3;
    c_errormesg := error_msg.err_p_outlet_topup_2;
    RETURN;
  END IF;

  /*----------- 数据校验   -----------------*/
  --基本信息
  update adm_info
     set admin_realname    = p_admin_realname,
         admin_login       = p_admin_loginid,
         admin_gender      = P_admin_gender,
         admin_email       = P_admin_email,
         admin_birthday    = P_admin_birthday,
         admin_tel         = p_admin_officephone,
         admin_mobile      = p_admin_mobilephone,
         admin_phone       = p_admin_homephone,
         admin_org         = p_admin_insticode,
         admin_address     = p_admin_address,
         admin_remark      = p_admin_remark,
         admin_update_time = sysdate,
         is_collecter      = p_admin_ismarketm
   where admin_id = p_admin_id;

  --循环的插入管理员信息，并更新权限信息表
  --先清理原有数据

  IF p_admin_ismarketm = eboolean.yesorenabled THEN
  
    v_count_temp := 0;
    SELECT count(o.acc_no)
      INTO v_count_temp
      FROM acc_mm_account o
     WHERE o.market_admin = p_admin_id;
  
    IF v_count_temp <= 0 THEN
      --新增
      v_temp_str := f_get_acc_no(p_admin_id, 'MM');
      ---插入市场管理员账户
      insert into acc_mm_account
        (market_admin,
         acc_type,
         acc_name,
         acc_status,
         acc_no,
         credit_limit,
         account_balance,
         check_code)
      values
        (p_admin_id,
         eacc_type.main_account,
         p_admin_realname,
         eacc_status.available,
         v_temp_str,
         0,
         0,
         '-');
      --插入市场管理账户
      insert into inf_market_admin
        (market_admin, trans_pass, credit_by_tran, max_amount_ticketss)
      values
        (p_admin_id, p_admin_defaultpwd, 0, 0);
    ELSE
      --编辑
      update acc_mm_account
         set acc_mm_account.acc_status = eacc_status.available
       where acc_mm_account.market_admin = p_admin_id;
    
    END IF;
  
  ELSE
    update acc_mm_account
       set acc_mm_account.acc_status = eacc_status.stoped
     where acc_mm_account.market_admin = p_admin_id;
  
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END p_admin_modify;
/
 
/ 
prompt 正在建立[PROCEDURE -> p_agency_fund_change.sql ]...... 
create or replace procedure p_agency_fund_change
/****************************************************************/
   ------------------- 销售站资金处理（不提交） -------------------
   ---- 按照输入类型，处理销售站资金，同时增加相应的资金流水
   ---- add by 陈震: 2015/9/24

   /*************************************************************/
(
   --------------输入----------------
   p_agency                            in char,          -- 销售站
   p_type                              in char,          -- 资金类型
   p_amount                            in char,          -- 调整金额
   p_frozen                            in number,        -- 冻结金额
   p_ref_no                            in varchar2,      -- 参考业务编号

   --------------输入----------------
   c_balance                           out number,        -- 账户余额
   c_f_balance                         out number         -- 冻结账户余额

 ) is

   v_acc_no                char(12);                                       -- 账户编码
   v_balance               number(28);                                     -- 账户余额
   v_frozen_balance        number(28);                                     -- 账户冻结余额
   v_credit_limit          number(28);                                     -- 信用额度
   v_amount                number(28);                                     -- 账户调整金额
   v_frozen                number(28);                                     -- 冻结账户调整金额

begin
   -- 按照类型，处理正负号
   case
      when p_type in (eflow_type.charge, eflow_type.paid, eflow_type.sale_comm,
                      eflow_type.pay_comm, eflow_type.agency_return,
                      eflow_type.lottery_sale_comm, eflow_type.lottery_pay_comm,
                      eflow_type.lottery_pay, eflow_type.lottery_cancel,
                      eflow_type.lottery_fail_sale, eflow_type.lottery_fail_cancel_comm) then
         v_amount := p_amount;
         v_frozen := 0;

      when p_type in (eflow_type.withdraw, eflow_type.sale, eflow_type.cancel_comm,
                      eflow_type.lottery_sale, eflow_type.lottery_cancel_comm,
                      eflow_type.lottery_fail_sale_comm, eflow_type.lottery_fail_pay_comm,
                      eflow_type.lottery_fail_pay, eflow_type.lottery_fail_cancel) then
         v_amount := 0 - p_amount;
         v_frozen := 0;

      else
         raise_application_error(-20001, dbtool.format_line(p_type) || error_msg.err_p_fund_change_2);            -- 资金类型不合法

   end case;

   -- 更新余额
   update acc_agency_account
      set account_balance = account_balance + v_amount,
          frozen_balance = frozen_balance + v_frozen
    where agency_code = p_agency
      and acc_type = eacc_type.main_account
      and acc_status = eacc_status.available
   returning
      acc_no,   credit_limit,   account_balance, frozen_balance
   into
      v_acc_no, v_credit_limit, v_balance,       v_frozen_balance;
   if sql%rowcount = 0 then
      raise_application_error(-20001, dbtool.format_line(p_agency) || error_msg.err_p_fund_change_3);            -- 未发现销售站的账户，或者账户状态不正确
   end if;

   -- 失败的各种操作，都不检查余额
   if p_type not in (eflow_type.lottery_fail_sale_comm, eflow_type.lottery_fail_pay_comm, eflow_type.lottery_fail_sale, eflow_type.lottery_fail_pay, eflow_type.lottery_fail_cancel, eflow_type.lottery_fail_cancel_comm) then
      if v_credit_limit + v_balance < 0 then
         raise_application_error(-20101, error_msg.err_p_fund_change_1);            -- 账户余额不足
      end if;
   end if;

   insert into flow_agency
      (agency_fund_flow,      ref_no,   flow_type, agency_code, acc_no,   change_amount, be_account_balance,   af_account_balance, be_frozen_balance,           af_frozen_balance, frozen_amount)
   values
      (f_get_flow_agency_seq, p_ref_no, p_type,    p_agency,    v_acc_no, p_amount,      v_balance - v_amount, v_balance,          v_frozen_balance - v_frozen, v_frozen_balance,  p_frozen);

   c_balance := v_balance;
   c_f_balance := v_frozen_balance;
end;
 
/ 
prompt 正在建立[PROCEDURE -> p_agency_fund_change_manual.sql ]...... 
CREATE OR REPLACE procedure p_agency_fund_change_manual
/****************************************************************/
   --站点手工调账
/*************************************************************/
(
  --------------输入----------------
  p_agency                            in char,          -- 销售站
  p_type                              in char,          -- 资金类型
  p_amount                            in char,          -- 调整金额
  p_frozen                            in number,        -- 冻结金额
  p_oper                              in number,        -- 操作人员
  p_reason                            in varchar2,      -- 调账原因

  --------------输入----------------
  c_flow_no                           out varchar2,      -- 主键
  c_error_code                        out number,        -- 账户余额
  c_error_msg                         out varchar2       -- 冻结账户余额

 ) is

  v_acc_no                char(12);                                       -- 账户编码
  v_agency_name           varchar2(4000);                                 -- 销售站名称
  v_balance               number(28);                                     -- 账户余额
  v_frozen_balance        number(28);                                     -- 账户冻结余额
  v_credit_limit          number(28);                                     -- 信用额度
  v_amount                number(28);                                     -- 账户调整金额
  v_frozen                number(28);                                     -- 冻结账户调整金额
  v_ref_no                char(10);                                       -- 调账编号（FT12345678）

begin

  dbtool.set_success(errcode => c_error_code, errmesg => c_error_msg);
  -- 按照类型，处理正负号
  case
     when p_type in (eflow_type.charge, eflow_type.paid, eflow_type.sale_comm, eflow_type.pay_comm, eflow_type.agency_return) then
        v_amount := p_amount;
        v_frozen := 0;

     when p_type in (eflow_type.withdraw, eflow_type.sale, eflow_type.cancel_comm) then
        v_amount := 0 - p_amount;
        v_frozen := 0;

     else
        c_error_code := 1;
        c_error_msg := error_msg.err_p_fund_change_2;
        return;
  end case;

  -- 更新余额
  update acc_agency_account
     set account_balance = account_balance + v_amount,
         frozen_balance = frozen_balance + v_frozen
   where agency_code = p_agency
     and acc_type = eacc_type.main_account
     and acc_status = eacc_status.available
  returning
     acc_no,   credit_limit,   account_balance, frozen_balance
  into
     v_acc_no, v_credit_limit, v_balance,       v_frozen_balance;
  if sql%rowcount = 0 then
    c_error_code := 2;    -- 未发现销售站的账户，或者账户状态不正确
    c_error_msg := error_msg.err_p_fund_change_2;
    return;
  end if;
  
  select agency_name
    into v_agency_name
    from inf_agencys
   where agency_code = p_agency;

  insert into fund_tuning
    (fund_no,                 account_type,                  ao_code,  
     ao_name,                 acc_no,                        change_amount, 
     be_account_balance,      af_account_balance,            oper_time, 
     oper_admin,              tuning_reason)
  values
    (f_get_fund_tuning_seq,   eaccount_type.agency,          p_agency, 
     v_agency_name,           v_acc_no,                      v_amount, 
     v_balance - v_amount,    v_balance,                     sysdate, 
     p_oper,                  p_reason)
  returning
     fund_no
  into
     v_ref_no;

  insert into flow_agency
    (agency_fund_flow,        ref_no,                        flow_type, 
     agency_code,             acc_no,                        change_amount,                 
     be_account_balance,      af_account_balance,            be_frozen_balance,             
     af_frozen_balance,       frozen_amount)
  values
    (f_get_flow_agency_seq,   v_ref_no,                      p_type,    
     p_agency,                v_acc_no,                      p_amount,            
     v_balance - v_amount,    v_balance,                     v_frozen_balance - v_frozen,   
     v_frozen_balance,        p_frozen);

  c_flow_no := v_ref_no;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_error_code := 3;
    c_error_msg := error_msg.ERR_COMMON_1 || SQLERRM;

end;
 
/ 
prompt 正在建立[PROCEDURE -> p_ar_inbound.sql ]...... 
create or replace procedure p_ar_inbound
/****************************************************************/
   ------------------- 站点入库单入库 -------------------
   ---- 站点入库单入库。一次性完成彩票入库。
   ----     创建“入库单”；
   ----     按照传递的入库对象（箱、盒、包）更新彩票数据，同时也要在入库单明细中记录入库对象；
   ----     根据彩票统计数据，更新“入库单”和“站点入库单”记录；
   ----     修改“市场管理员”的库存彩票状态；
   ----     修改“站点”余额

   ---- add by 陈震: 2015/9/21
   ---- 涉及的业务表：
   ----     2.1.6.10 站点入库单（sale_agency_receipt）                     -- 新增
   ----     2.1.5.10 入库单                                                -- 新增
   ----     2.1.5.11 入库单明细                                            -- 新增
   ----     2.1.5.3 即开票信息（箱）                                       -- 更新
   ----     2.1.5.4 即开票信息（盒）                                       -- 更新
   ----     2.1.5.5 即开票信息（本）                                       -- 更新

   ---- 业务流程：
   ----     1、校验输入参数。（仓库是否存在；操作人是否合法；输入的彩票对象，是否有自包含的情况）
   ----     2、按照出库明细，更新“即开票信息”表中各个对象的属性;
   ----     3、循环出库明细
   ----        记录彩票统计信息（入库票数、入库金额、佣金金额）；
   ----        写入入库明细数组，准备后续插入“入库明细表”；
   ----        按照方案和批次，更新仓库管理员持票信息；
   ----        检查是否包含已经兑奖的彩票；
   ----     4、新增“站点退货单”信息，新增“入库单”和“入货单明细”，获取主键值；
   ----     5、扣减站点资金，类型为“站点入库”，同时也要增加资金，类型为“销售代销费”；
   ----     6、更新“站点入库单”中的“入库前站点余额”和“入库后站点余额”

   /*************************************************************/
(
 --------------输入----------------
  p_agency                           in char,                              -- 收货销售站
  p_oper                             in number,                            -- 操作人
  p_array_lotterys                   in type_lottery_list,                 -- 入库的彩票对象

 ---------出口参数---------
  c_errorcode                        out number,                           -- 错误编码
  c_errormesg                        out string                            -- 错误原因

 ) is

   v_ar_no                 char(10);                                       -- 站点入库单编号
   v_sgr_no                char(10);                                       -- 入库单编号
   v_org                   char(2);                                        -- 销售站所属机构
   v_loop_i                number(10);                                     -- 循环使用的参数
   v_area_code             char(4);                                        -- 销售站所属区域

   v_balance               number(28);                                     -- 账户余额
   v_f_balance             number(28);                                     -- 冻结账户余额

   v_detail_list           type_lottery_detail_list;                       -- 彩票对象明细
   v_stat_list             type_lottery_statistics_list;                   -- 按照方案和批次统计的金额和票数
   type type_detail        is table of wh_goods_receipt_detail%rowtype;
   v_insert_detail         type_detail;                                    -- 插入入库明细的数组

   v_sale_info             flow_sale%rowtype;                              -- 销售明细
   type type_sale          is table of flow_sale%rowtype;
   v_sale_list             type_sale;                                      -- 销售明细数组

   v_total_tickets         number(20);                                     -- 当此入库的总票数
   v_total_amount          number(28);                                     -- 当此入库的总金额
   v_plan_publish          number(1);                                      -- 印制厂商编号

   v_comm_amount           number(18);                                     -- 销售佣金
   v_comm_rate             number(18);                                     -- 销售佣金比例

   v_err_code              number(10);                                     -- 调用存储过程时，返回值
   v_err_msg               varchar2(4000);                                 -- 调用存储过程时，返回错误信息
   v_temp_tickets          number(18);                                     -- 临时变量。削减管理员库存时，判断是否削减到负值
   v_temp_amount           number(28);                                     -- 临时变量。削减管理员库存时，判断是否削减到负值

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;

   -- 检查是否输入了彩票对象
   if p_array_lotterys.count = 0 then
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_109; -- 输入参数中，没有发现彩票对象
      return;
   end if;

   -- 检查输入的参数是否有“自包含”的情况
   if f_check_ticket_perfect(p_array_lotterys) then
      c_errorcode := 3;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_103; -- 彩票对象，存在“自包含”的情况
      return;
   end if;

   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* 获取已经保存的参数。（方案批次的包装信息-bulk方式获取；） *************************/

   -- 获取印制厂商信息
/*   select plan_flow
     into v_plan_publish
     from inf_publishers
    where publisher_code =
          (select publisher_code from game_plans where plan_code = p_plan);
*/
   /********************************************************************************************************************************************************************/
   /******************* 按照入库明细，更新“即开票信息”表中各个对象的属性；同时统计彩票统计信息 *************************/

   -- 初始化数组
   v_insert_detail := type_detail();
   v_total_tickets := 0;
   v_total_amount := 0;
   v_comm_amount := 0;

   v_sale_list := type_sale();

   -- 根据明细数据，更新“即开票”状态
   p_ticket_perferm(p_array_lotterys, p_oper, eticket_status.in_mm, eticket_status.saled, p_oper, p_agency, v_err_code, v_err_msg);
   if v_err_code <> 0 then
      rollback;
      c_errorcode := 1;
      c_errormesg := error_msg.err_common_104 || v_err_msg; -- 更新“即开票”状态时，出现错误
      return;
   end if;

   -- 统计入库对象的票数据
   p_lottery_detail_stat(p_array_lotterys, v_detail_list, v_stat_list, v_total_tickets, v_total_amount);

   -- 循环统计结果，按照方案批次，更新库管员库存，同时计算站点佣金
   for v_loop_i in 1 .. v_stat_list.count loop

      -- 更新仓库管理员库存信息
      update acc_mm_tickets
         set tickets = tickets - v_stat_list(v_loop_i).tickets,
             amount = amount - v_stat_list(v_loop_i).amount
       where market_admin = p_oper
         and plan_code = v_stat_list(v_loop_i).plan_code
         and batch_no = v_stat_list(v_loop_i).batch_no
      returning
         tickets, amount
      into
         v_temp_tickets, v_temp_amount;
      if sql%rowcount = 0 or v_temp_tickets < 0 or v_temp_amount < 0 then
         rollback;
         c_errorcode := 14;
         c_errormesg := dbtool.format_line(p_oper) || dbtool.format_line(v_stat_list(v_loop_i).plan_code) || dbtool.format_line(v_stat_list(v_loop_i).batch_no) || error_msg.err_p_ar_inbound_14; -- 仓库管理员的库存中，没有此方案和批次的库存信息
         return;
      end if;

      -- 获取站点的佣金比例
      begin
         select sale_comm into v_comm_rate from game_agency_comm_rate where agency_code = p_agency and plan_code = v_stat_list(v_loop_i).plan_code;
      exception
         when no_data_found then
            rollback;
            c_errorcode := 15;
            c_errormesg := dbtool.format_line(p_agency) || dbtool.format_line(v_stat_list(v_loop_i).plan_code) || error_msg.err_p_ar_inbound_15; -- 该销售站未设置此方案对应的销售佣金比例
            return;
      end;

      v_comm_amount := v_comm_amount + trunc(v_stat_list(v_loop_i).amount * v_comm_rate / 1000);

      -- 记录销售记录
      v_sale_info.sale_flow := f_get_flow_sale_seq;
      v_sale_info.agency_code := p_agency;
      v_sale_info.area_code := null;
      v_sale_info.org_code := null;
      v_sale_info.plan_code := v_stat_list(v_loop_i).plan_code;
      v_sale_info.batch_no := v_stat_list(v_loop_i).batch_no;
      v_sale_info.trunks := v_stat_list(v_loop_i).trunks;
      v_sale_info.boxes := v_stat_list(v_loop_i).boxes;
      v_sale_info.packages := v_stat_list(v_loop_i).packages;
      v_sale_info.tickets := v_stat_list(v_loop_i).tickets;
      v_sale_info.sale_amount := v_stat_list(v_loop_i).amount;
      v_sale_info.comm_amount := trunc(v_stat_list(v_loop_i).amount * v_comm_rate / 1000);
      v_sale_info.comm_rate := v_comm_rate;
      v_sale_info.sale_time := sysdate;
      v_sale_info.ar_no := null;
      v_sale_info.sgr_no := null;

      v_sale_list.extend;
      v_sale_list(v_sale_list.count) := v_sale_info;

   end loop;


   /********************************************************************************************************************************************************************/
   /******************* 新增“站点入库单”信息，新增“入库单”，获取主键值； *************************/
   select org_code
     into v_org
     from inf_agencys
    where agency_code = p_agency;

   select area_code
     into v_area_code
     from INF_AGENCYS
    where agency_code = p_agency;

   -- 创建“站点入库单”
   insert into sale_agency_receipt
      (ar_no,              ar_admin, ar_date, ar_agency,  tickets,         amount)
   values
      (f_get_sale_ar_seq,  p_oper,   sysdate, p_agency,   v_total_tickets, v_total_amount)
   returning
      ar_no
   into
      v_ar_no;

   -- 创建“入库单”
   insert into wh_goods_receipt
      (sgr_no,                      create_admin,              receipt_end_time,          receipt_amount,            receipt_tickets,
       act_receipt_amount,          act_receipt_tickets,       receipt_type,              ref_no,                    status,
       receive_org,                 receive_wh,                send_admin)
   values
      (f_get_wh_goods_receipt_seq,  p_oper,                    sysdate,                   v_total_amount,            v_total_tickets,
       v_total_amount,              v_total_tickets,           ereceipt_type.agency,      v_ar_no,                   eboolean.yesorenabled,
       v_org,                       p_agency,                  p_oper)
   returning
      sgr_no
   into
      v_sgr_no;

   -- 插入入库明细
   for v_loop_i in 1 .. v_detail_list.count loop
      v_insert_detail.extend;
      v_insert_detail(v_loop_i).sgr_no := v_sgr_no;
      v_insert_detail(v_loop_i).ref_no := v_ar_no;
      v_insert_detail(v_loop_i).sequence_no := f_get_wh_goods_receipt_det_seq;
      v_insert_detail(v_loop_i).receipt_type := ereceipt_type.agency;

      v_insert_detail(v_loop_i).valid_number := v_detail_list(v_loop_i).valid_number;
      v_insert_detail(v_loop_i).plan_code := v_detail_list(v_loop_i).plan_code;
      v_insert_detail(v_loop_i).batch_no := v_detail_list(v_loop_i).batch_no;
      v_insert_detail(v_loop_i).amount := v_detail_list(v_loop_i).amount;
      v_insert_detail(v_loop_i).trunk_no := v_detail_list(v_loop_i).trunk_no;
      v_insert_detail(v_loop_i).box_no := v_detail_list(v_loop_i).box_no;
      v_insert_detail(v_loop_i).package_no := v_detail_list(v_loop_i).package_no;
      v_insert_detail(v_loop_i).tickets := v_detail_list(v_loop_i).tickets;
   end loop;

   forall v_loop_i in 1 .. v_insert_detail.count
      insert into wh_goods_receipt_detail values v_insert_detail(v_loop_i);

   -- 补充销售记录明细，然后生成销售记录
   for v_loop_i in 1 .. v_sale_list.count loop
      v_sale_list(v_loop_i).area_code := v_area_code;
      v_sale_list(v_loop_i).org_code := v_org;
      v_sale_list(v_loop_i).ar_no := v_ar_no;
      v_sale_list(v_loop_i).sgr_no := v_sgr_no;
   end loop;

   forall v_loop_i in 1 .. v_sale_list.count
      insert into flow_sale values v_sale_list(v_loop_i);

   /********************************************************************************************************************************************************************/
   /******************* 执行资金扣减操作，如果余额不足，则报错，返回 *************************/
   /******************* 增加账户流水，类型为“销售”，同时增加账户流水，类型为“销售代销费”； *************************/
   -- 增加账户流水，类型为“销售”
   p_agency_fund_change(p_agency, eflow_type.sale, v_total_amount, 0, v_ar_no, v_balance, v_f_balance);

   -- 增加账户流水，类型为“销售代销费”
   p_agency_fund_change(p_agency, eflow_type.sale_comm, v_comm_amount, 0, v_ar_no, v_balance, v_f_balance);

   update sale_agency_receipt
      set before_balance = v_balance + v_total_amount - v_comm_amount,
          after_balance = v_balance
    where ar_no = v_ar_no;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;

 
/ 
prompt 正在建立[PROCEDURE -> p_ar_outbound.sql ]...... 
create or replace procedure p_ar_outbound
/****************************************************************/
   ------------------- 站点退货 -------------------
   ---- 站点一次性完成退货工作
   ----     创建“出库单”；
   ----     按照传递的出库对象（箱、盒、包）更新彩票数据，同时也要在出库单明细中记录出库对象；
   ----     退货的明细中，检查是否包含已经兑奖的彩票；
   ----     修改“市场管理员”的库存彩票数据；
   ----     修改“站点”余额

   ---- add by 陈震: 2015/9/21
   ---- 涉及的业务表：
   ----     2.1.6.10 站点退货单（sale_agency_return）                      -- 新增
   ----     2.1.5.10 出库单                                                -- 新增
   ----     2.1.5.11 出库单明细                                            -- 新增
   ----     2.1.5.3 即开票信息（箱）                                       -- 更新
   ----     2.1.5.4 即开票信息（盒）                                       -- 更新
   ----     2.1.5.5 即开票信息（本）                                       -- 更新

   ---- 业务流程：
   ----     1、校验输入参数。（仓库是否存在；操作人是否合法；输入的彩票对象，是否有自包含的情况）
   ----     2、按照出库明细，更新“即开票信息”表中各个对象的属性;
   ----     3、循环出库明细
   ----        记录彩票统计信息（出库票数、出库金额、佣金金额）；
   ----        写入入库明细数组，准备后续插入“出库明细表”；
   ----        按照方案和批次，更新仓库管理员持票信息；
   ----        检查是否包含已经兑奖的彩票；
   ----     4、新增“站点退货单”信息，新增“出库单”和“出货单明细”，获取主键值；
   ----     5、为站点增加资金，类型为“站点退货”，同时也要减少资金，类型为“销售代销费”，但是传递的参数应该为负值；
   ----     6、更新“站点退货单”中的“退货前站点余额”和“退货后站点余额”

   /*************************************************************/
(
 --------------输入----------------
  p_agency                           in char,                              -- 退货销售站
  p_oper                             in number,                            -- 市场管理员
  p_array_lotterys                   in type_lottery_list,                 -- 退库的彩票对象

 ---------出口参数---------
  c_errorcode                        out number,                           -- 错误编码
  c_errormesg                        out string                            -- 错误原因

 ) is

   v_ai_no                 char(10);                                       -- 站点退货单编号
   v_sgi_no                char(10);                                       -- 出库单编号
   v_sgr_no                char(10);                                       -- 入库单编号
   v_org                   char(2);                                        -- 销售站所属机构
   v_loop_i                number(10);                                     -- 循环使用的参数
   v_loop_j                number(10);                                     -- 循环使用的参数2
   v_found                 boolean;                                        -- 是否找到相应记录
   v_area_code             char(4);                                        -- 销售站所属区域
   v_count                 number(3);                                      -- 检测记录是否存在

   v_balance               number(28);                                     -- 账户余额
   v_f_balance             number(28);                                     -- 冻结账户余额

   v_detail_list           type_lottery_detail_list;                       -- 退票明细
   v_stat_list             type_lottery_statistics_list;                   -- 按照方案和批次统计的金额和票数

   type type_detail        is table of wh_goods_issue_detail%rowtype;
   v_insert_detail         type_detail;                                    -- 插入出库明细的数组

   v_cancel_info           flow_cancel%rowtype;                            -- 退票流水
   type type_cancel        is table of flow_cancel%rowtype;
   v_cancel_list           type_cancel;                                    -- 退票明细数组
   v_lottery_info          type_lottery_detail_info;                       -- 参数退票的单个彩票对象

   v_total_tickets         number(20);                                     -- 当此出库的总票数
   v_total_amount          number(28);                                     -- 当此出库的总金额
   v_plan_publish          number(1);                                      -- 印制厂商编号

   v_total_comm_amount     number(18);                                     -- 销售佣金
   v_comm_rate             number(18);                                     -- 销售佣金比例
   v_single_ticket_amount  number(18);                                     -- 单票金额

   v_delivery_amount       number(28);                                     -- 市场管理员当前持票金额

   v_lottery_object_info   type_lottery_info;                              -- 退票对象，用于检查此对象是否进行过兑奖

   v_err_code              number(10);                                     -- 调用存储过程时，返回值
   v_err_msg               varchar2(4000);                                 -- 调用存储过程时，返回错误信息

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;

   -- 检查输入的参数是否有“自包含”的情况
   if f_check_ticket_perfect(p_array_lotterys) then
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_103; -- 彩票对象，存在“自包含”的情况
      return;
   end if;

   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* 获取已经保存的参数。（方案批次的包装信息-bulk方式获取；） *************************/

   -- 获取印制厂商信息
/*   select plan_flow
     into v_plan_publish
     from inf_publishers
    where publisher_code =
          (select publisher_code from game_plans where plan_code = p_plan);
*/

   /********************************************************************************************************************************************************************/
   /******************* 按照出库明细，更新“即开票信息”表中各个对象的属性；同时统计彩票统计信息 *************************/

   -- 根据明细数据，更新“即开票”状态
   p_ticket_perferm(p_array_lotterys, p_oper, eticket_status.saled, eticket_status.in_mm, p_agency, p_oper, v_err_code, v_err_msg);
   if v_err_code <> 0 then
      rollback;
      c_errorcode := 1;
      c_errormesg := error_msg.err_common_104 || v_err_msg; -- 更新“即开票”状态时，出现错误
      return;
   end if;

   -- 统计入库对象的票数据
   p_lottery_detail_stat(p_array_lotterys, v_detail_list, v_stat_list, v_total_tickets, v_total_amount);

   /*******************************************************************************************************************************************************************/
   /********* 循环所有退票的彩票对象，找到对应的入库单，然后找到对应的销售记录，获取单票金额和佣金，然后按照这个值，计算退票金额和退的佣金   **************************/
   v_total_tickets := 0;
   v_total_amount := 0;
   v_total_comm_amount := 0;
   v_cancel_list := type_cancel();

   for v_loop_i in 1 .. v_detail_list.count loop

      v_lottery_info := v_detail_list(v_loop_i);

      -- 查找当时的入库记录
      case
         when v_detail_list(v_loop_i).valid_number = evalid_number.trunk then
            -- 检查此箱票，是否兑过奖
            v_lottery_object_info := f_get_lottery_info(v_lottery_info.plan_code, v_lottery_info.batch_no, evalid_number.trunk, v_lottery_info.trunk_no);
            select count(*)
              into v_count
              from dual
             where exists(select 1 from flow_pay
                                  where plan_code = v_lottery_info.plan_code
                                    and batch_no = v_lottery_info.batch_no
                                    and package_no >= v_lottery_object_info.package_no
                                    and package_no <= v_lottery_object_info.package_no_e);
            if v_count > 0 then
               rollback;
               c_errorcode := 1;
               c_errormesg := error_msg.err_p_ar_outbound_10; -- 有彩票已经兑奖，不能退票
               return;
            end if;

            -- 整“箱”退票，这个比较容易找，因为他没有被拆封过
            select max(sgr_no)
              into v_sgr_no
              from wh_goods_receipt_detail
             where plan_code = v_lottery_info.plan_code
               and batch_no = v_lottery_info.batch_no
               and valid_number = evalid_number.trunk
               and trunk_no = v_lottery_info.trunk_no
               and receipt_type = ereceipt_type.agency;
            if v_sgr_no is null then
                  rollback;
                  c_errorcode := 1;
                  c_errormesg := error_msg.err_p_ar_outbound_20; -- 对应的箱数据，没有在入库单中找到
                  return;
            end if;

         when v_detail_list(v_loop_i).valid_number = evalid_number.box then
            -- 检查此箱票，是否兑过奖
            v_lottery_object_info := f_get_lottery_info(v_lottery_info.plan_code, v_lottery_info.batch_no, evalid_number.box, v_lottery_info.box_no);
            select count(*)
              into v_count
              from dual
             where exists(select 1 from flow_pay
                                  where plan_code = v_lottery_info.plan_code
                                    and batch_no = v_lottery_info.batch_no
                                    and package_no >= v_lottery_object_info.package_no
                                    and package_no <= v_lottery_object_info.package_no_e);
            if v_count > 0 then
               rollback;
               c_errorcode := 1;
               c_errormesg := error_msg.err_p_ar_outbound_10; -- 有彩票已经兑奖，不能退票
               return;
            end if;

            -- 整“盒”退票，首先需要找这一盒，如果没有找到，那就找“箱”，因为有可能是整“箱”入库，拆开以后退
            select max(sgr_no)
              into v_sgr_no
              from wh_goods_receipt_detail
             where plan_code = v_lottery_info.plan_code
               and batch_no = v_lottery_info.batch_no
               and receipt_type = ereceipt_type.agency
               and valid_number = evalid_number.box
               and box_no = v_lottery_info.box_no;
            if v_sgr_no is null then
               select max(sgr_no)
                 into v_sgr_no
                 from wh_goods_receipt_detail
                where plan_code = v_lottery_info.plan_code
                  and batch_no = v_lottery_info.batch_no
                  and receipt_type = ereceipt_type.agency
                  and valid_number = evalid_number.trunk
                  and trunk_no = v_lottery_info.trunk_no;
               if v_sgr_no is null then
                  rollback;
                  c_errorcode := 1;
                  c_errormesg := error_msg.err_p_ar_outbound_30; -- 对应的盒数据，没有在入库单中找到
                  return;
               end if;
            end if;

         when v_detail_list(v_loop_i).valid_number = evalid_number.pack then
            -- 检查此箱票，是否兑过奖
            select count(*)
              into v_count
              from dual
             where exists(select 1 from flow_pay
                                  where plan_code = v_lottery_info.plan_code
                                    and batch_no = v_lottery_info.batch_no
                                    and package_no = v_lottery_info.package_no);
            if v_count > 0 then
               rollback;
               c_errorcode := 1;
               c_errormesg := error_msg.err_p_ar_outbound_10; -- 有彩票已经兑奖，不能退票
               return;
            end if;

            -- 首先找“本”，没有再找“盒”，再没有，就找“箱”
            select max(sgr_no)
              into v_sgr_no
              from wh_goods_receipt_detail
             where plan_code = v_lottery_info.plan_code
               and batch_no = v_lottery_info.batch_no
               and receipt_type = ereceipt_type.agency
               and valid_number = evalid_number.pack
               and package_no = v_lottery_info.package_no;
            if v_sgr_no is null then
               select max(sgr_no)
                 into v_sgr_no
                 from wh_goods_receipt_detail
                where plan_code = v_lottery_info.plan_code
                  and batch_no = v_lottery_info.batch_no
                  and receipt_type = ereceipt_type.agency
                  and valid_number = evalid_number.box
                  and box_no = v_lottery_info.box_no;
               if v_sgr_no is null then
                  select max(sgr_no)
                    into v_sgr_no
                    from wh_goods_receipt_detail
                   where plan_code = v_lottery_info.plan_code
                     and batch_no = v_lottery_info.batch_no
                     and receipt_type = ereceipt_type.agency
                     and valid_number = evalid_number.trunk
                     and trunk_no = v_lottery_info.trunk_no;
                  if v_sgr_no is null then
                     rollback;
                     c_errorcode := 1;
                     c_errormesg := error_msg.err_p_ar_outbound_40; -- 对应的本数据，没有在入库单中找到
                     return;
                  end if;
               end if;
            end if;

      end case;

      -- 校验找到的入库数据，是否已经售出到这个销售站
      select count(*)
        into v_count
        from dual
       where exists(select 1
                      from wh_goods_receipt tab
                     where receipt_type = ereceipt_type.agency
                       and receive_wh = p_agency
                       and sgr_no = v_sgr_no);
      if v_count = 0 then
         rollback;
         c_errorcode := 1;
         c_errormesg := error_msg.err_p_ar_outbound_50; -- 对应的箱数据已经在入库单中找到，但是状态或者所属站点信息不正确
         return;
      end if;

      -- 查找销售记录，获取历史单票金额和代销费比率
      begin
         select trunc(sale_amount/tickets), comm_rate
           into v_single_ticket_amount, v_comm_rate
           from flow_sale
          where sgr_no = v_sgr_no
            and plan_code = v_lottery_info.plan_code
            and batch_no = v_lottery_info.batch_no;
      exception
         when no_data_found then
            rollback;
            c_errorcode := 1;
            c_errormesg := error_msg.err_p_ar_outbound_60; -- 未查询到待退票的售票记录
            return;
      end;

      -- 记录退票数据，同一个方案、批次、佣金比例的数据，会被合并记录
      v_found := false;
      for v_loop_j in 1 .. v_cancel_list.count loop
         -- 检查是否已经存在同一个方案、批次、佣金比例的数据
         if v_cancel_list(v_loop_j).plan_code = v_lottery_info.plan_code and v_cancel_list(v_loop_j).batch_no = v_lottery_info.batch_no and v_cancel_list(v_loop_j).comm_rate = v_comm_rate then
            v_cancel_list(v_loop_j).tickets := v_cancel_list(v_loop_j).tickets +  v_lottery_info.tickets;
            v_cancel_list(v_loop_j).sale_amount := v_cancel_list(v_loop_j).sale_amount + v_lottery_info.amount;
            v_cancel_list(v_loop_j).comm_amount := v_cancel_list(v_loop_j).comm_amount + v_lottery_info.amount * v_comm_rate / 1000;

            case
               when v_detail_list(v_loop_i).valid_number = evalid_number.trunk then
                  v_cancel_list(v_loop_j).trunks := v_cancel_list(v_loop_j).trunks + 1;

               when v_detail_list(v_loop_i).valid_number = evalid_number.box then
                  v_cancel_list(v_loop_j).boxes := v_cancel_list(v_loop_j).boxes + 1;

               when v_detail_list(v_loop_i).valid_number = evalid_number.pack then
                  v_cancel_list(v_loop_j).packages := v_cancel_list(v_loop_j).packages + 1;

            end case;

            v_found := true;
            exit;
         end if;
      end loop;
      if not v_found then
         v_cancel_info.plan_code := v_lottery_info.plan_code;
         v_cancel_info.batch_no := v_lottery_info.batch_no;
         v_cancel_info.comm_rate := v_comm_rate;
         v_cancel_info.tickets := v_lottery_info.tickets;
         v_cancel_info.sale_amount := v_lottery_info.amount;
         v_cancel_info.comm_amount := v_lottery_info.amount * v_comm_rate / 1000;

         case
            when v_detail_list(v_loop_i).valid_number = evalid_number.trunk then
               v_cancel_info.trunks := 1;
               v_cancel_info.boxes := 0;
               v_cancel_info.packages := 0;

            when v_detail_list(v_loop_i).valid_number = evalid_number.box then
               v_cancel_info.trunks := 0;
               v_cancel_info.boxes := 1;
               v_cancel_info.packages := 0;

            when v_detail_list(v_loop_i).valid_number = evalid_number.pack then
               v_cancel_info.trunks := 0;
               v_cancel_info.boxes := 0;
               v_cancel_info.packages := 1;

         end case;

         v_cancel_list.extend;
         v_cancel_list(v_cancel_list.count) := v_cancel_info;
      end if;

      -- 统计数据
      v_total_tickets := v_total_tickets + v_lottery_info.tickets;
      v_total_amount := v_total_amount + v_lottery_info.amount;
      v_total_comm_amount := v_total_comm_amount + v_lottery_info.amount * v_comm_rate / 1000;

   end loop;

   /********************************************************************************************************************************************************************/
   /******************* 更新管理员持票库存，判断是否超过管理员最大限额； *************************/
   for v_list_count in 1 .. v_stat_list.count loop
      merge into acc_mm_tickets tgt
      using (select p_oper market_admin, v_stat_list(v_list_count).plan_code plan_code, v_stat_list(v_list_count).batch_no batch_no from dual) tab
         on (tgt.market_admin = tab.market_admin and tgt.plan_code = tab.plan_code and tgt.batch_no = tab.batch_no)
       when matched then
         update set tgt.tickets = tgt.tickets + v_stat_list(v_list_count).tickets,
                    tgt.amount = tgt.amount + v_stat_list(v_list_count).amount
       when not matched then
         insert values (p_oper, v_stat_list(v_list_count).plan_code, v_stat_list(v_list_count).batch_no, v_stat_list(v_list_count).tickets, v_stat_list(v_list_count).amount);
   end loop;

   -- 获取管理员当前最大持票金额
   select sum(tickets)
     into v_delivery_amount
     from acc_mm_tickets
    where market_admin = p_oper;

   -- 判断是否超过最大持票金额
   select count(*)
     into v_count
     from dual
    where exists(select 1 from inf_market_admin
                  where market_admin = p_oper
                    and max_amount_ticketss < nvl(v_delivery_amount, 0));
   if v_count = 1 then
      rollback;
      c_errorcode := 17;
      c_errormesg := dbtool.format_line(p_oper) || dbtool.format_line(v_delivery_amount) || error_msg.err_p_ar_outbound_70; -- 超过此管理员允许持有的“最高赊票金额”
      return;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* 更新“出库单”的“实际出库金额合计”和“实际出库张数”,“站点退货单”的“实际处理票数”和“实际处理票数涉及金额”记录 *************************/
   select org_code
     into v_org
     from inf_agencys
    where agency_code = p_agency;

   select area_code
     into v_area_code
     from inf_agencys
    where agency_code = p_agency;

   -- 创建“站点退货单”
   insert into sale_agency_return
      (ai_no,              ai_mm_admin, ai_date, ai_agency, tickets,         amount)
   values
      (f_get_sale_ai_seq,  p_oper,      sysdate, p_agency,  v_total_tickets, v_total_amount)
   returning
      ai_no
   into
      v_ai_no;

   -- 创建“出库单”
   insert into wh_goods_issue
      (sgi_no,                      create_admin,              issue_end_time,
       issue_amount,                issue_tickets,             act_issue_amount,
       act_issue_tickets,           issue_type,                ref_no,
       status,                      send_org,                  send_wh,
       receive_admin)
   values
      (f_get_wh_goods_issue_seq,  p_oper,                    sysdate,
       v_total_amount,              v_total_tickets,           v_total_amount,
       v_total_tickets,             eissue_type.agency_return, v_ai_no,
       eboolean.yesorenabled,       v_org,                     p_agency,
       p_oper)
   returning
      sgi_no
   into
      v_sgi_no;

   -- 初始化数组
   v_insert_detail := type_detail();

   -- 插入出库明细
   for v_loop_i in 1 .. v_detail_list.count loop
      v_insert_detail.extend;
      v_insert_detail(v_loop_i).sgi_no := v_sgi_no;
      v_insert_detail(v_loop_i).ref_no := v_ai_no;
      v_insert_detail(v_loop_i).sequence_no := f_get_wh_goods_issue_detai_seq;
      v_insert_detail(v_loop_i).issue_type := eissue_type.agency_return;

      v_insert_detail(v_loop_i).valid_number := v_detail_list(v_loop_i).valid_number;
      v_insert_detail(v_loop_i).plan_code := v_detail_list(v_loop_i).plan_code;
      v_insert_detail(v_loop_i).batch_no := v_detail_list(v_loop_i).batch_no;
      v_insert_detail(v_loop_i).trunk_no := v_detail_list(v_loop_i).trunk_no;
      v_insert_detail(v_loop_i).box_no := v_detail_list(v_loop_i).box_no;
      v_insert_detail(v_loop_i).package_no := v_detail_list(v_loop_i).package_no;
      v_insert_detail(v_loop_i).tickets := v_detail_list(v_loop_i).tickets;
      v_insert_detail(v_loop_i).amount := v_detail_list(v_loop_i).amount;
   end loop;

   forall v_loop_i in 1 .. v_insert_detail.count
      insert into wh_goods_issue_detail values v_insert_detail(v_loop_i);

   -- 插入退票流水
   for v_loop_i in 1 .. v_cancel_list.count loop
      v_cancel_list(v_loop_i).cancel_flow := f_get_flow_cancel_seq;
      v_cancel_list(v_loop_i).agency_code := p_agency;
      v_cancel_list(v_loop_i).area_code := v_area_code;
      v_cancel_list(v_loop_i).org_code := v_org;
      v_cancel_list(v_loop_i).cancel_time := sysdate;
      v_cancel_list(v_loop_i).ai_no := v_ai_no;
      v_cancel_list(v_loop_i).sgi_no := v_sgi_no;
   end loop;

   forall v_loop_i in 1 .. v_cancel_list.count
      insert into flow_cancel values v_cancel_list(v_loop_i);

   /********************************************************************************************************************************************************************/
   /******************* 为站点增加资金，类型为“站点退货”，同时也要减少资金，类型为“销售代销费”； *************************/
   -- 增加销售站账户余额，类型为“站点退货”
   p_agency_fund_change(p_agency, eflow_type.agency_return, v_total_amount, 0, v_ai_no, v_balance, v_f_balance);

   -- 减少销售站账户余额，类型为“撤销代销费”
   p_agency_fund_change(p_agency, eflow_type.cancel_comm, v_total_comm_amount, 0, v_ai_no, v_balance, v_f_balance);

   -- 更新“站点退货单”中的“退货前站点余额”和“退货后站点余额”
   update sale_agency_return
      set before_balance = v_balance - v_total_amount + v_total_comm_amount,
          after_balance = v_balance
    where ai_no = v_ai_no;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
 
/ 
prompt 正在建立[PROCEDURE -> p_batch_close.sql ]...... 
create or replace procedure p_batch_end
/****************************************************************/
   ------------------- 批次终结 -------------------
   ---- 批次终结。
   ----     查询各种彩票的状态，如果都处于“11-在库、31-已销售、41-被盗、42-损坏、43-丢失”状态时，就可以进行批次终结。
   ----     终结时
   ----        1、需要设置“2.1.4.5 批次信息导入之包装（game_batch_import_detail）”中的状态为“退市”
   ----        2、统计销售金额、兑奖金额、库存张数
   ----        3、插入批次终结表，统计数据
   ---- add by 陈震: 2015/9/19
   ---- 涉及的业务表：
   ----     2.1.4.5 批次信息导入之包装（game_batch_import_detail）   -- 更新
   ----     2.1.5.18 批次终结（wh_batch_end）                        -- 新增
   ----     2.1.5.3 即开票信息（箱）            -- 更新
   ----     2.1.5.4 即开票信息（盒）            -- 更新
   ----     2.1.5.5 即开票信息（本）            -- 更新
   ---- 业务流程：
   ----     1、校验输入参数。（操作人是否合法；）
   ----     2、查询各种彩票的状态，合法时，就可以进行批次终结。
   ----     3、统计销售金额、兑奖金额、库存张数
   ----     4、插入批次终结表，统计数据

   /*************************************************************/
(
   --------------输入----------------
   p_plan          in varchar2,                                                -- 方案号码
   p_batch         in varchar2,                                              -- 批次号码
   p_oper          in number,                                              -- 操作人

   ---------出口参数---------
   c_errorcode out number,                                                 --错误编码
   c_errormesg out string                                                  --错误原因

 ) is

   v_count                 number(5);                                      -- 求记录数的临时变量
   v_collect_batch_end     wh_batch_end%rowtype;                           -- 批次终结表行结果集
   v_collect_batch_param   game_batch_import_detail%rowtype;               -- 批次参数

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_p_batch_end_1; -- 无此人
      return;
   end if;

   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* 查询各种彩票的状态，合法时，就可以进行批次终结。 *************************/

   -- 获取批次参数
   select * into v_collect_batch_param from game_batch_import_detail where plan_code = p_plan and batch_no = p_batch;

   -- 统计销售金额、兑奖金额、库存张数
   select count(*)
     into v_collect_batch_end.sale_amount
     from wh_ticket_package
    where plan_code = p_plan
     and batch_no = p_batch
     and status = eticket_status.saled;

   -- 统计兑奖金额
   select nvl(sum(pay_amount), 0)
     into v_collect_batch_end.pay_amount
     from flow_pay
    where plan_code = p_plan
      and batch_no = p_batch;

   -- 统计库存张数
   select nvl(sum(packs), 0) * v_collect_batch_param.tickets_every_pack
     into v_collect_batch_end.inventory_tickets
     from (
            select (to_number(package_no_end) - to_number(package_no_start)) packs from wh_ticket_trunk  where plan_code = p_plan and batch_no = p_batch and status = eticket_status.in_warehouse
            union all
            select (to_number(package_no_end) - to_number(package_no_start)) packs from wh_ticket_box  where plan_code = p_plan and batch_no = p_batch and status = eticket_status.in_warehouse
            union all
            select count(*) packs from wh_ticket_box  where plan_code = p_plan and batch_no = p_batch and status = eticket_status.in_warehouse
          );

   -- 插入数据
   insert into wh_batch_end
      (be_no,                             plan_code,                      batch_no,                               tickets,
       sale_amount,                       pay_amount,                     inventory_tickets,                      create_admin,                                create_date)
   values
      (f_get_wh_batch_end_seq,            p_plan,                         p_batch,                                v_collect_batch_param.tickets_every_batch,
       v_collect_batch_end.sale_amount,   v_collect_batch_end.pay_amount, v_collect_batch_end.inventory_tickets,  p_oper,                                      sysdate);

   -- 修改状态
   update game_batch_import_detail
      set status = ebatch_item_status.quited
    where plan_code = p_plan
      and batch_no = p_batch;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;
end;

 
/ 
prompt 正在建立[PROCEDURE -> p_batch_inbound.sql ]...... 
create or replace procedure p_batch_inbound
/****************************************************************/
   ------------------- 彩票批次入库 -------------------
   ---- 彩票入库。支持新入库，继续入库，入库完结。
   ----     新入库：  创建“批次入库”记录；创建入库单；按照传递的入库对象（箱、盒、包）记录彩票数据，同时也要在入库单明细中记录入库对象；
   ----     继续入库：按照传递的入库对象（箱、盒、包）更新彩票数据，同时也要在入库单明细中记录入库对象；更新批次入库记录，修改增加的彩票统计数据；
   ----     入库完结：按照传递的入库对象（箱、盒、包）更新彩票数据，同时也要在入库单明细中记录入库对象；更新批次入库记录，修改增加的彩票统计数据，完结批次入库状态。
   ---- add by 陈震: 2015/9/15
   ---- 涉及的业务表：
   ----     2.1.5.7 批次入库（wh_batch_inbound）
   ----     2.1.5.10 入库单（wh_goods_receipt）
   ----     2.1.5.11 入库单明细（wh_goods_receipt_detail）
   ----     2.1.5.3 即开票信息（箱）（wh_ticket_trunk）
   ----     2.1.5.4 即开票信息（盒）（wh_ticket_box）
   ----     2.1.5.5 即开票信息（本）（wh_ticket_package）
   ---- 业务流程：
   ----     1、校验输入参数。（方案、批次是否存在；仓库是否存在；操作类型是否为新、继续、完结；操作人是否合法；当操作类型是继续、完结时，需要检查批次入库单编号是否存在）
   ----     2、操作类型为“完结”时，更新 批次入库（wh_batch_inbound）、入库单（wh_goods_receipt），结束运行，返回。
   ----     3、获取已经保存的参数。（方案批次的包装信息-bulk方式获取；）
   ----     4、首先插入“即开票”表，同时统计插入的数据
   ----     5、判断操作类型。
   ----          新入库：    插入 批次入库（wh_batch_inbound）、入库单（wh_goods_receipt）
   ----          继续入库：  更新 批次入库（wh_batch_inbound）、入库单（wh_goods_receipt）
   ----                   以上两个操作，都需要 插入 “入库明细”

   /*************************************************************/
(
 --------------输入----------------
 p_inbound_no        in varchar2,            -- 批次入库单编号（新增情况下，忽略此参数，否则为必录项）
 p_plan              in char,                -- 方案
 p_batch             in char,                -- 批次
 p_warehouse         in char,                -- 仓库
 p_oper_type         in number,              -- 操作类型(1-新增，2-继续，3-完结)
 p_oper              in number,              -- 操作人
 p_array_lotterys    in type_lottery_list,   -- 入库的彩票对象

 ---------出口参数---------
 c_inbound_no out varchar2,
 c_errorcode out number,                     --错误编码
 c_errormesg out string                      --错误原因

 ) is

   v_count                 number(5);                                      -- 求记录数的临时变量
   v_collect_batch_param   game_batch_import_detail%rowtype;               -- 批次参数
   v_bi_no                 char(10);                                       -- 批次入库单编号(bi12345678)
   v_sgr_no                char(10);                                       -- 入库单编号（rk12345678）
   v_array_lottery         type_lottery_info;                              -- 单张彩票
   v_lottery_detail        type_lottery_info;                              -- 彩票对象详细信息
   v_format_lotterys       type_lottery_list;

   v_list_count            number(10);                                     -- 入库明细总数
   v_trunk_count           number(10);                                     -- 入库“箱”数
   v_box_count             number(10);                                     -- 入库“盒”数
   v_pack_count            number(10);                                     -- 入库“本”数
   v_scan_count_trunk      number(10);                                     -- 扫描的“箱”数
   v_scan_count_box        number(10);                                     -- 扫描的“盒”数
   v_scan_count_pack       number(10);                                     -- 扫描的“本”数

   type type_trunk         is table of wh_ticket_trunk%rowtype;
   type type_box           is table of wh_ticket_box%rowtype;
   type type_pack          is table of wh_ticket_package%rowtype;
   type type_detail        is table of wh_goods_receipt_detail%rowtype;
   v_insert_trunks         type_trunk;                                     -- 插入盒的数据
   v_insert_boxes          type_box;                                       -- 插入盒的数据
   v_insert_packs          type_pack;                                      -- 插入本的数组
   v_insert_detail         type_detail;                                    -- 插入入库明细的数组
   v_trunk                 wh_ticket_trunk%rowtype;
   v_box                   wh_ticket_box%rowtype;
   v_pack                  wh_ticket_package%rowtype;

   v_loop_i                number(10);                                     -- 循环使用的参数
   v_loop_j                number(10);                                     -- 循环使用的参数

   v_packs_every_box       number(10);                                     -- 每“盒”中包含多少“本”
   v_total_tickets         number(20);                                     -- 当此入库的总票数
   v_plan_publish          number(1);                                      -- 印制厂商编号
   v_single_ticket_amount  number(10);                                     -- 每张票的价格

   v_all_lottery_list      type_lottery_list;                              -- 拿去计算包含关系的数组

   v_detail_list           type_lottery_detail_list;                       -- 入库明细
   v_stat_list             type_lottery_statistics_list;                   -- 按照方案和批次统计的金额和票数
   v_total_amount          number(28);                                     -- 当此入库的总金额

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;

   if not f_check_warehouse(p_warehouse) then
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_warehouse) || error_msg.err_common_101; -- 无此仓库
      return;
   end if;

   if not f_check_plan_batch(p_plan,p_batch) then
      c_errorcode := 3;
      c_errormesg := dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || error_msg.err_common_102; -- 无此批次
      return;
   end if;

   if not p_oper_type in (1,2,3) then
      c_errorcode := 4;
      c_errormesg := dbtool.format_line(p_oper_type) || error_msg.err_p_batch_inbound_4; -- 操作类型参数错误，应该为1，2，3
      return;
   end if;

   if p_oper_type in (2,3) then
      select count(*) into v_count from dual where exists(select 1 from wh_batch_inbound where bi_no = p_inbound_no);
      if v_count = 0 then
         c_errorcode := 5;
         c_errormesg := dbtool.format_line(p_inbound_no) || error_msg.err_p_batch_inbound_5; -- 在进行继续入库和完结入库操作时，输入的批次入库单错误，未发现此批次入库单
         return;
      end if;
   end if;

   -- 继续入库时，判断是否已经完结
   if p_oper_type = 2 then
      select count(*) into v_count from dual where exists(select 1 from wh_goods_receipt where ref_no = p_inbound_no and status = ework_status.working);
      if v_count = 0 then
         c_errorcode := 6;
         c_errormesg := dbtool.format_line(p_inbound_no) || error_msg.err_p_batch_inbound_6; -- 在进行继续入库时，输入的批次入库单错误，或者此批次入库单已经完结
         return;
      end if;
   end if;
   /*----------- 业务逻辑   -----------------*/
   /**********************************************************/
   /******************* 获取参数信息 *************************/

   -- 获取印制厂商信息
   select plan_flow
     into v_plan_publish
     from inf_publishers
    where publisher_code =
          (select publisher_code from game_plans where plan_code = p_plan);

   -- 获取保存的参数
   select * into v_collect_batch_param from game_batch_import_detail where plan_code = p_plan and batch_no = p_batch;

   -- 获取单张票金额
   select ticket_amount into v_single_ticket_amount from game_plans where plan_code = p_plan;

   -- 初始化数组
   v_insert_trunks := type_trunk();
   v_insert_boxes  := type_box();
   v_insert_packs  := type_pack();
   v_trunk_count   := 0;
   v_box_count     := 0;
   v_pack_count    := 0;
   v_scan_count_trunk := 0;
   v_scan_count_box   := 0;
   v_scan_count_pack  := 0;

   -- 每“盒”中包含多少“本”
   v_packs_every_box := v_collect_batch_param.packs_every_trunk / v_collect_batch_param.boxes_every_trunk;

   /********************************************************************/
   /******************* 先处理完结入库这种情况 *************************/
   -- 完结入库：  更新 批次入库（wh_batch_inbound）、入库单（wh_goods_receipt）
   if p_oper_type = 3 then
      update wh_batch_inbound
         set damaged_tickets = batch_tickets - act_tickets,
             damaged_amount = batch_amount - act_amount,
             discrepancy_tickets = batch_tickets - act_tickets,
             discrepancy_amount = batch_amount - act_amount,
             oper_admin = p_oper,
             oper_date = sysdate
       where bi_no = p_inbound_no;

      update wh_goods_receipt
         set status = ework_status.done,
             receipt_end_time = sysdate
       where ref_no = p_inbound_no;

      commit;
      return;
   end if;

   /************************************************************************************/
   /******************* 检查输入的入库对象是否合法 *************************/
   v_format_lotterys := type_lottery_list();
   for v_list_count in 1 .. p_array_lotterys.count loop
      v_array_lottery := p_array_lotterys(v_list_count);
      case
         when v_array_lottery.valid_number = evalid_number.trunk then
            v_array_lottery.box_no := '-';
            v_array_lottery.package_no := '-';

         when v_array_lottery.valid_number = evalid_number.box then
            v_lottery_detail := f_get_lottery_info(p_plan, p_batch, v_array_lottery.valid_number, v_array_lottery.box_no);
            v_array_lottery.trunk_no := v_lottery_detail.trunk_no;
            v_array_lottery.package_no := '-';

         when v_array_lottery.valid_number = evalid_number.pack then
            v_lottery_detail := f_get_lottery_info(p_plan, p_batch, v_array_lottery.valid_number, v_array_lottery.package_no);
            v_array_lottery.trunk_no := v_lottery_detail.trunk_no;
            v_array_lottery.box_no := v_lottery_detail.box_no;

      end case;
      v_array_lottery.plan_code := p_plan;
      v_array_lottery.batch_no := p_batch;

      v_format_lotterys.extend;
      v_format_lotterys(v_format_lotterys.count) := v_array_lottery;
   end loop;

   if p_oper_type = 2 then
      -- 判断入库对象有没有与已经入库的内容重复，或者存在交叉的对象（例如：已经入整箱，再入箱中的一本彩票）
      select type_lottery_info(plan_code, batch_no, valid_number, trunk_no, box_no, '', package_no, '', 0)
        bulk collect into v_all_lottery_list
        from wh_goods_receipt_detail
       where sgr_no = (select sgr_no from wh_goods_receipt where ref_no = p_inbound_no);

      -- 合并当前数组
      v_all_lottery_list := v_all_lottery_list multiset union v_format_lotterys;

   else
      v_all_lottery_list := v_format_lotterys;

   end if;

   if f_check_ticket_perfect(v_all_lottery_list) then
      rollback;
      c_errorcode := 6;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_103; -- 彩票对象，存在“自包含”的情况
      return;
   end if;

   /************************************************************************************/
   /******************* 先入“箱”数据，并获取入库数据统计值 *************************/
   -- 先入“箱”数据
   for v_list_count in 1 .. v_format_lotterys.count loop
      v_array_lottery := v_format_lotterys(v_list_count);

      -- 统计扫描的对象
      case
         when v_array_lottery.valid_number = evalid_number.trunk then
            v_scan_count_trunk := v_scan_count_trunk + 1;

         when v_array_lottery.valid_number = evalid_number.box then
            v_scan_count_box := v_scan_count_box + 1;

         when v_array_lottery.valid_number = evalid_number.pack then
            v_scan_count_pack := v_scan_count_pack + 1;

      end case;

      -- 明细为 “箱”，需要在 箱、盒、本 上都插入记录
      if v_array_lottery.valid_number = evalid_number.trunk then
         -- 获取彩票的明细数据
         v_lottery_detail := f_get_lottery_info(p_plan, p_batch, v_array_lottery.valid_number, v_array_lottery.trunk_no);

         -- 计算奖组编号
         v_trunk.reward_group := v_lottery_detail.reward_group;

         -- “箱”号
         v_trunk.trunk_no := v_array_lottery.trunk_no;

         -- “箱”开始“本”号
         v_trunk.package_no_start := v_lottery_detail.package_no;

         -- “箱”结束“本”号
         v_trunk.package_no_end := v_lottery_detail.package_no_e;

         -- 扩展“箱”数组
         v_insert_trunks.extend;
         v_trunk_count := v_trunk_count + 1;
         v_insert_trunks(v_trunk_count) := v_trunk;

         -- 检查箱是否已经入库
         if f_check_trunk(p_plan, p_batch, v_trunk.trunk_no) then
            rollback;
            c_errorcode := 26;
            c_errormesg := dbtool.format_line(v_array_lottery.trunk_no) || error_msg.err_p_batch_inbound_1; -- 此箱已经入库
            return;
         end if;

         -- 计算有几盒，给每盒编号，并生成相关数组数据
         for v_loop_i in 1 .. to_number(v_collect_batch_param.boxes_every_trunk) loop

            -- “盒”的“箱”号
            v_box.trunk_no := v_array_lottery.trunk_no;

            -- 奖组
            v_box.reward_group := v_trunk.reward_group;

            -- “盒”的“盒”号
            v_box.box_no := v_array_lottery.trunk_no || '-' || lpad(v_loop_i, epublisher_sjz.len_box, '0');

            -- “盒”的开始“本”号
            v_box.package_no_start := lpad(to_number(v_trunk.package_no_start) + v_packs_every_box * (v_loop_i - 1), epublisher_sjz.len_package, '0');
            v_box.package_no_end   := lpad(v_box.package_no_start + v_packs_every_box - 1, epublisher_sjz.len_package, '0');

            -- 扩展“盒”数组
            v_insert_boxes.extend;
            v_box_count := v_box_count + 1;
            v_insert_boxes(v_box_count) := v_box;

            -- 填充“本”数据
            for v_loop_j in 1 .. v_packs_every_box loop
               -- “本”的“箱”号
               v_pack.trunk_no := v_array_lottery.trunk_no;

               -- 奖组
               v_pack.reward_group := v_trunk.reward_group;

               -- “本”的“盒”号
               v_pack.box_no := v_box.box_no;

               -- “本”号
               v_pack.package_no := lpad(to_number(v_box.package_no_start) + v_loop_j - 1, epublisher_sjz.len_package, '0');

               -- “本”的开始票号
               v_pack.ticket_no_start := epublisher_sjz.ticket_start;

               -- “本”的结束票号
               v_pack.ticket_no_end := epublisher_sjz.ticket_start + v_collect_batch_param.tickets_every_pack - 1;

               -- 扩展“本”数组
               v_insert_packs.extend;
               v_pack_count := v_pack_count + 1;
               v_insert_packs(v_pack_count) := v_pack;
            end loop;
         end loop;
      end if;
   end loop;

   -- 插入“箱”数据
   forall v_loop_i in 1 .. v_trunk_count
      insert into wh_ticket_trunk
         (plan_code,                                  batch_no,                                    reward_group,
          trunk_no,                                   package_no_start,                            package_no_end,
          current_warehouse,                          create_admin)
      values
         (p_plan,                                     p_batch,                                     v_insert_trunks(v_loop_i).reward_group,
          v_insert_trunks(v_loop_i).trunk_no,         v_insert_trunks(v_loop_i).package_no_start,  v_insert_trunks(v_loop_i).package_no_end,
          p_warehouse,                                p_oper);

   /************************************************************************************/
   /******************* 再入“盒”数据，并获取入库数据统计值 *************************/

   -- 入“盒”的数据
   for v_list_count in 1 .. v_format_lotterys.count loop
      v_array_lottery := v_format_lotterys(v_list_count);
      -- 明细为 “箱”，需要在 箱、盒、本 上都插入记录
      if v_array_lottery.valid_number = evalid_number.box then
         -- 获取彩票的明细数据
         v_lottery_detail := f_get_lottery_info(p_plan, p_batch, v_array_lottery.valid_number, v_array_lottery.box_no);

         /******************* 处理“盒”对应的“箱”，如果“箱”存在，就没什么，否则就要不足这个虚拟的“箱” *****************/
         -- 获取“箱”号
         v_trunk.trunk_no := v_lottery_detail.trunk_no;

         -- 计算“箱”的奖组编号
         v_trunk.reward_group := v_lottery_detail.reward_group;

         -- 检查此箱是否存在，不存在则插入“箱”
         select count(*) into v_count
           from dual
          where exists(
                        select 1 from wh_ticket_trunk
                         where trunk_no = v_trunk.trunk_no
                           and plan_code = p_plan
                           and batch_no = p_batch);
         if v_count = 0 then
            -- 计算“箱”的开始“本”号
            v_trunk.package_no_start := lpad((to_number(v_trunk.trunk_no) - 1) * v_collect_batch_param.packs_every_trunk + 1, epublisher_sjz.len_package, '0');

            -- 计算“箱”的结束“本”号
            v_trunk.package_no_end := lpad((to_number(v_trunk.trunk_no)) * v_collect_batch_param.packs_every_trunk, epublisher_sjz.len_package, '0');

            -- 插入记录
            insert into wh_ticket_trunk
               (plan_code,          batch_no,                  reward_group,
                trunk_no,           package_no_start,          package_no_end,
                current_warehouse,  create_admin,              is_full)
            values
               (p_plan,             p_batch,                   v_trunk.reward_group,
                v_trunk.trunk_no,   v_trunk.package_no_start,  v_trunk.package_no_end,
                p_warehouse,        p_oper,                    eboolean.noordisabled);
         end if;

         -- “盒”的“箱”号
         v_box.trunk_no := v_trunk.trunk_no;

         -- 奖组
         v_box.reward_group := v_trunk.reward_group;

         -- “盒”的“盒”号
         v_box.box_no := v_array_lottery.box_no;

         -- “盒”的开始“本”号
         v_box.package_no_start := v_lottery_detail.package_no;
         v_box.package_no_end   := v_lottery_detail.package_no_e;

         -- 扩展“盒”数组
         v_insert_boxes.extend;
         v_box_count := v_box_count + 1;
         v_insert_boxes(v_box_count) := v_box;

         -- 填充“本”数据
         for v_loop_j in 1 .. v_packs_every_box loop
            -- “本”的“箱”号
            v_pack.trunk_no := v_box.trunk_no;

            -- 奖组
            v_pack.reward_group := v_box.reward_group;

            -- “本”的“盒”号
            v_pack.box_no := v_box.box_no;

            -- “本”号
            v_pack.package_no := lpad(to_number(v_box.package_no_start) + v_loop_j - 1, epublisher_sjz.len_package, '0');

            -- “本”的开始票号
            v_pack.ticket_no_start := epublisher_sjz.ticket_start;

            -- “本”的结束票号
            v_pack.ticket_no_end := epublisher_sjz.ticket_start + v_collect_batch_param.tickets_every_pack - 1;

            -- 扩展“本”数组
            v_insert_packs.extend;
            v_pack_count := v_pack_count + 1;
            v_insert_packs(v_pack_count) := v_pack;
         end loop;
      end if;
   end loop;

   -- 插入“盒”数据
   forall v_loop_i in 1 .. v_box_count
      insert into wh_ticket_box
         (plan_code,                               batch_no,                        reward_group,
          trunk_no,                                box_no,                          package_no_start,
          package_no_end,                          current_warehouse,               create_admin)
      values
         (p_plan,                                  p_batch,                         v_insert_boxes(v_loop_i).reward_group,
          v_insert_boxes(v_loop_i).trunk_no,       v_insert_boxes(v_loop_i).box_no, v_insert_boxes(v_loop_i).package_no_start,
          v_insert_boxes(v_loop_i).package_no_end, p_warehouse,                     p_oper);

   /************************************************************************************/
   /******************* 再入“本”数据，并获取入库数据统计值 *************************/
   for v_list_count in 1 .. v_format_lotterys.count loop
      v_array_lottery := v_format_lotterys(v_list_count);
      if v_array_lottery.valid_number = evalid_number.pack then
         -- 获取彩票的明细数据
         v_lottery_detail := f_get_lottery_info(p_plan, p_batch, v_array_lottery.valid_number, v_array_lottery.package_no);

         /*- 明细为 “本”，需要视情况在 箱、盒、本 上插入记录
          * 首先应该明确“本”的编号，应该不在以前所入库的整“箱”中包含；同时也不能在非整“箱”的整“盒”中包含。如果出现包含，就是数据错误。
          * 然后计算“本”所在和“箱”、“盒”，依次写入数据
         */

         -- 计算“本”所在的“箱”号、“盒”号和奖组编号
         v_pack.trunk_no := v_lottery_detail.trunk_no;
         v_pack.box_no := v_lottery_detail.box_no;
         v_pack.reward_group := v_lottery_detail.reward_group;

         -- 查看“箱”是否存在，不存在，就增加（insert）。这时候，增加的记录，“是否完整”应该为“否”
         select count(*) into v_count
           from dual
          where exists(
                        select 1 from wh_ticket_trunk
                         where trunk_no = v_pack.trunk_no
                           and plan_code = p_plan
                           and batch_no = p_batch);
         if v_count = 0 then
            -- 计算“箱”的开始“本”号
            v_trunk.package_no_start := lpad((to_number(v_pack.trunk_no) - 1) * v_collect_batch_param.packs_every_trunk + 1, epublisher_sjz.len_package, '0') ;

            -- 计算“箱”的结束“本”号
            v_trunk.package_no_end := lpad((to_number(v_pack.trunk_no)) * v_collect_batch_param.packs_every_trunk, epublisher_sjz.len_package, '0') ;

            -- 插入记录
            insert into wh_ticket_trunk
               (plan_code,          batch_no,                  reward_group,
                trunk_no,           package_no_start,          package_no_end,
                current_warehouse,  create_admin,              is_full)
            values
               (p_plan,             p_batch,                   v_pack.reward_group,
                v_pack.trunk_no,    v_trunk.package_no_start,  v_trunk.package_no_end,
                p_warehouse,        p_oper,                    eboolean.noordisabled);
         end if;


         -- 查看“盒”是否存在，不存在，就增加（insert）。这时候，增加的记录，“是否完整”应该为“否”
         select count(*) into v_count
           from dual
          where exists(
                        select 1 from wh_ticket_box
                         where box_no = v_pack.box_no
                           and plan_code = p_plan
                           and batch_no = p_batch);
         if v_count = 0 then
            -- 计算“箱”的开始“本”号
            v_trunk.package_no_start := lpad((to_number(v_pack.trunk_no) - 1) * v_collect_batch_param.packs_every_trunk + 1, epublisher_sjz.len_package, '0') ;

            -- 计算“盒”的开始“本”号
            v_box.package_no_start := lpad(to_number(v_trunk.package_no_start) + (to_number(substr(v_pack.box_no, 7, 2)) - 1) * v_packs_every_box, epublisher_sjz.len_package, '0') ;

            -- 计算“盒”的结束“本”号
            v_box.package_no_end := lpad(v_box.package_no_start + v_packs_every_box - 1, epublisher_sjz.len_package, '0') ;

            -- 插入记录
            insert into wh_ticket_box
               (plan_code,          batch_no,                  reward_group,
                trunk_no,           package_no_start,          package_no_end,
                current_warehouse,  create_admin,              is_full,
                box_no)
            values
               (p_plan,             p_batch,                   v_pack.reward_group,
                v_pack.trunk_no,    v_box.package_no_start,    v_box.package_no_end,
                p_warehouse,        p_oper,                    eboolean.noordisabled,
                v_pack.box_no);
         end if;

         -- “本”号
         v_pack.package_no := v_array_lottery.package_no;

         -- “本”的开始票号
         v_pack.ticket_no_start := epublisher_sjz.ticket_start;

         -- “本”的结束票号
         v_pack.ticket_no_end := epublisher_sjz.ticket_start + v_collect_batch_param.tickets_every_pack - 1;

         -- 扩展“本”数组
         v_insert_packs.extend;
         v_pack_count := v_pack_count + 1;
         v_insert_packs(v_pack_count) := v_pack;

      end if;
   end loop;

   -- 插入“本”数据
   forall v_loop_i in 1 .. v_pack_count
      insert into wh_ticket_package
         (plan_code,                                  batch_no,                                 reward_group,
          trunk_no,                                   box_no,                                   package_no,
          ticket_no_start,                            ticket_no_end,                            current_warehouse,               create_admin)
      values
         (p_plan,                                     p_batch,                                  v_insert_packs(v_loop_i).reward_group,
          v_insert_packs(v_loop_i).trunk_no,          v_insert_packs(v_loop_i).box_no,          v_insert_packs(v_loop_i).package_no,
          v_insert_packs(v_loop_i).ticket_no_start,   v_insert_packs(v_loop_i).ticket_no_end,   p_warehouse,                     p_oper);

   -- 统计票数
   v_total_tickets := v_pack_count * v_collect_batch_param.tickets_every_pack;



   /****************************************************************************/
   /******************* 判断操作类型。插入和更新数据 ***************************/
   case
      when p_oper_type = 1 then
         -- 创建“批次入库”记录
         insert into wh_batch_inbound
           (bi_no,                      plan_code,                                  batch_no,
            create_admin,               batch_tickets,                              batch_amount,
            act_tickets,                act_amount,
            trunks,                     boxes,                                      packages)
         values
           (f_get_wh_batch_inbound_seq, p_plan,                                     p_batch,
            p_oper,                     v_collect_batch_param.tickets_every_batch,  v_collect_batch_param.tickets_every_batch * v_single_ticket_amount,
            v_total_tickets,            v_total_tickets * v_single_ticket_amount,
            v_scan_count_trunk,         v_scan_count_box,                           v_scan_count_pack)
         returning
            bi_no
         into
            v_bi_no;

         insert into wh_goods_receipt
            (sgr_no,                                                             receive_wh,                                  create_admin,
             receipt_amount,                                                     receipt_tickets,
             act_receipt_amount,                                                 act_receipt_tickets,                         receipt_type,        ref_no)
         values
            (f_get_wh_goods_receipt_seq,                                         p_warehouse,                                 p_oper,
             v_collect_batch_param.tickets_every_batch * v_single_ticket_amount, v_collect_batch_param.tickets_every_batch,
             v_total_tickets * v_single_ticket_amount,                           v_total_tickets,                             ereceipt_type.batch, v_bi_no)
         returning
            sgr_no
         into
            v_sgr_no;

      when p_oper_type = 2 then
         update wh_batch_inbound
            set act_tickets = act_tickets + v_total_tickets,
                act_amount = act_amount + v_total_tickets * v_single_ticket_amount,
                trunks = trunks + v_scan_count_trunk,
                boxes = boxes + v_scan_count_box,
                packages = packages + v_scan_count_pack
          where bi_no = p_inbound_no
         returning
                bi_no
           into
                v_bi_no;

         update wh_goods_receipt
            set act_receipt_amount = act_receipt_amount + v_total_tickets * v_single_ticket_amount,
                act_receipt_tickets = act_receipt_tickets + v_total_tickets
          where ref_no = p_inbound_no
                returning sgr_no into v_sgr_no;
   end case;

   if p_oper_type in (1, 2) then
      -- 插入 入库明细
      p_lottery_detail_stat(v_format_lotterys, v_detail_list, v_stat_list, v_total_tickets, v_total_amount);

      v_insert_detail := type_detail();
      for v_loop_i in 1 .. v_detail_list.count loop
         v_insert_detail.extend;
         v_insert_detail(v_loop_i).sgr_no := v_sgr_no;
         v_insert_detail(v_loop_i).ref_no := v_bi_no;
         v_insert_detail(v_loop_i).sequence_no := f_get_wh_goods_receipt_det_seq;
         v_insert_detail(v_loop_i).receipt_type := ereceipt_type.batch;
         v_insert_detail(v_loop_i).create_admin := p_oper;
         v_insert_detail(v_loop_i).create_date := sysdate;

         v_insert_detail(v_loop_i).valid_number := v_detail_list(v_loop_i).valid_number;
         v_insert_detail(v_loop_i).plan_code := v_detail_list(v_loop_i).plan_code;
         v_insert_detail(v_loop_i).batch_no := v_detail_list(v_loop_i).batch_no;
         v_insert_detail(v_loop_i).amount := v_detail_list(v_loop_i).amount;
         v_insert_detail(v_loop_i).trunk_no := v_detail_list(v_loop_i).trunk_no;
         v_insert_detail(v_loop_i).box_no := v_detail_list(v_loop_i).box_no;
         v_insert_detail(v_loop_i).package_no := v_detail_list(v_loop_i).package_no;
         v_insert_detail(v_loop_i).tickets := v_detail_list(v_loop_i).tickets;
      end loop;

      forall v_loop_i in 1 .. v_insert_detail.count
         insert into wh_goods_receipt_detail values v_insert_detail(v_loop_i);
   end if;

   if p_oper_type = 1 then
      c_inbound_no := v_bi_no;
   end if;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
 
/ 
prompt 正在建立[PROCEDURE -> p_batch_inbound_all.sql ]...... 
create or replace procedure p_batch_inbound_all
/****************************************************************/
   ------------------- 彩票批量批次入库 -------------------
   ---- 彩票批量批次入库。用于系统初始上线时，从各个分公司入库的情形。
   ----     通过循环调用p_batch_inbound来实现。
   ----     输出结果中，会显示未正确入库的对象，以及对应的错误信息。
   ---- 执行过程：
   ----     1、对输入的彩票类型进行排序操作，对每一个方案进行循环调用存储过程
   ----     2、调用存储过程之前，需要检查这个方案是否已经有相应的批次入库信息，如果有就设置类型为新增，否则为追加

   /*************************************************************/
(
 --------------输入----------------
 p_warehouse         in char,                               -- 仓库
 p_oper              in number,                             -- 操作人
 p_array_lotterys    in type_lottery_list,                  -- 入库的彩票对象

 ---------出口参数---------
 c_err_list          out type_lottery_import_err_list,      -- 批次错误列表
 c_errorcode         out number,                            -- 错误编码
 c_errormesg         out string                             -- 错误原因

 ) is

   v_err_info              type_lottery_import_err_info;
   v_err_list              type_lottery_import_err_list;

   v_plan_objs             type_lottery_list;

   v_bi_no                 char(10);                                       -- 批次入库单编号(bi12345678)
   v_oper_type             number(1);                                      -- 操作类型(1-新增，2-继续)

   v_err_code              number(10);
   v_err_msg               varchar2(4000);

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;

   if not f_check_warehouse(p_warehouse) then
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_warehouse) || error_msg.err_common_101; -- 无此仓库
      return;
   end if;

   /*----------- 业务逻辑   -----------------*/
   for lottery_plan in (select distinct plan_code,batch_no from table(p_array_lotterys) order by plan_code,batch_no) loop
      v_oper_type := 0;
      begin
         select bi_no
           into v_bi_no
           from wh_batch_inbound
          where plan_code = lottery_plan.plan_code
            and batch_no = lottery_plan.batch_no;
      exception
         when no_data_found then
            v_bi_no := null;
            v_oper_type := 1;
      end;
      if v_bi_no is not null then
         v_oper_type := 2;
      end if;

     -- 确定入库的对象
     select type_lottery_info(plan_code ,batch_no ,valid_number,trunk_no ,box_no ,box_no_e ,package_no ,package_no_e, reward_group)
       bulk collect into v_plan_objs
       from table(p_array_lotterys)
      where plan_code = lottery_plan.plan_code
        and batch_no = lottery_plan.batch_no;

      -- 调用存储过程
      p_batch_inbound(p_inbound_no => v_bi_no,
                      p_plan => lottery_plan.plan_code,
                      p_batch => lottery_plan.batch_no,
                      p_warehouse => p_warehouse,
                      p_oper_type => v_oper_type,
                      p_oper => p_oper,
                      p_array_lotterys => v_plan_objs,
                      c_inbound_no => v_bi_no,
                      c_errorcode => v_err_code,
                      c_errormesg => v_err_msg);
      if v_err_code <> 0 then
         v_err_info := type_lottery_import_err_info(lottery_plan.plan_code, lottery_plan.batch_no, v_err_code, v_err_msg);
         v_err_list.extend;
         v_err_list(v_err_list.count) := v_err_info;
      end if;
   end loop;

   c_err_list := v_err_list;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
 
/ 
prompt 正在建立[PROCEDURE -> p_get_lottery_history.sql ]...... 
create or replace procedure p_get_lottery_history
/****************************************************************/
   ------------------- 物流明细查询 -------------------
   ---- 查询输入彩票对象的物流流转明细
   ----     原则上，查询以下表，获取流转信息
   ----         2.1.5.11 入库单明细（wh_goods_receipt_detail）
   ----         2.1.5.9 出库单明细（wh_goods_issue_detail）
   ----         2.1.7.2 兑奖记录（flow_pay）
   ----
   ----     针对彩票对象的查询原则如下：
   ----     箱：不需要回溯。直接查询
   ----     盒：首先查询“盒”的信息，然后回溯到对应的“箱”，之后将数据进行合并排序
   ----     本：首先查询“本”的信息，然后回溯到对应的“箱”和“盒”，之后将数据进行合并排序
   ----     票：查询票是否中奖；后续按照“本”来处理
   ----
   ----     返回结果集：[时间][仓库/销售站/销售员][类型][仓库/销售站/销售员][类型][即开票状态值]
   ---- add by 陈震: 2015/9/21
   ---- 业务流程：
   ----     1、校验输入参数。（方案批次是否存在，有效位数是否正确；）
   ----     2、按照有效位数进行分情况处理：
   ----        票：查询是否兑奖，显示兑奖金额
   ----        箱：查询“箱”记录；
   ----        盒：首先查询“盒”的信息，然后回溯到对应的“箱”，之后将数据进行合并排序
   ----        本：首先查询“本”的信息，然后回溯到对应的“箱”和“盒”，之后将数据进行合并排序

   /*************************************************************/
(
 --------------输入----------------
 p_plan                 in char,                         -- 方案编号
 p_batch                in char,                         -- 批次编号
 p_valid_number         in number,                       -- 有效位数(1-箱，2-盒，3-本，4-票)
 p_value                in varchar2,                     -- “箱”、“盒”、“本”号。如果查询票的物流信息，必须输入“本”号
 p_ticket_no            in varchar2,                     -- 票号

 ---------出口参数---------
 c_reward_amount        out number,                      -- 兑奖金额
 c_reward_time          out date,                        -- 兑奖时间
 c_result               out type_logistics_list,         -- 结果集
 c_errorcode            out number,                      -- 错误编码
 c_errormesg            out string                       -- 错误原因

 ) is

   v_lottery_detail        type_lottery_info;                              -- 彩票对象详细信息
   v_lottery_batch         type_logistics_list;                            -- 批次入库
   v_rtv                   type_logistics_list;                            -- 批次入库

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_plan_batch(p_plan, p_batch) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || error_msg.err_p_rr_inbound_1; -- 无此方案和批次
      return;
   end if;

   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* 判断类型，按照不同类型进行处理。*************************/
   if p_valid_number = evalid_number.ticket then
      -- 查询彩票是否中奖
      begin
      select pay_amount, pay_time
        into c_reward_amount, c_reward_time
        from flow_pay
       where plan_code = p_plan
         and batch_no = p_batch
         and package_no = p_value
         and ticket_no = p_ticket_no;
      exception
         when no_data_found then
            c_reward_amount := 0;
      end;
   end if;

   case
      -- “箱”
      when p_valid_number = evalid_number.trunk then
         -- 先找批次入库记录
         select type_logistics_info(create_date, ereceipt_type.batch + 10, (select receive_wh from wh_goods_receipt where sgr_no = wh_goods_receipt_detail.sgr_no), create_admin)
           bulk collect into v_lottery_batch
           from wh_goods_receipt_detail
          where plan_code = p_plan
            and batch_no = p_batch
            and valid_number = evalid_number.trunk
            and receipt_type = ereceipt_type.batch
            and trunk_no = p_value
            and box_no = '-'
            and package_no = '-';

         -- 其他记录
         with
            detail_issue as (
               -- 出库明细
               select sgi_no
                 from wh_goods_issue_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.trunk
                  and trunk_no = p_value
                  and box_no = '-'
                  and package_no = '-'),
            detail_receipt as (
               -- 入库明细
               select sgr_no
                 from wh_goods_receipt_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.trunk
                  and trunk_no = p_value
                  and box_no = '-'
                  and package_no = '-'),
            result_issue as (
               -- 出库记录
               select issue_end_time, issue_type, send_wh, receive_admin from wh_goods_issue where sgi_no in (select sgi_no from detail_issue)),
            result_receipt as (
               -- 入库记录（排除批次入库，单独处理）
               select receipt_end_time, receipt_type, receive_wh, send_admin from wh_goods_receipt where sgr_no in (select sgr_no from detail_receipt) and receipt_type not in (ereceipt_type.batch)),
            result as (
               select issue_end_time, issue_type, send_wh, receive_admin from result_issue
               union
               select receipt_end_time, receipt_type + 10, receive_wh, send_admin from result_receipt)
         select type_logistics_info(issue_end_time, issue_type, send_wh, receive_admin)
           bulk collect into c_result
           from result;

      -- “盒”
      when p_valid_number = evalid_number.box then
         v_lottery_detail := f_get_lottery_info(p_plan, p_batch, p_valid_number, p_value);

         -- 先找批次入库记录（总有一款适合批次入库，这里是排他的，所以连续三个sql。但是最终，只有一个sql会有结果，所以数据是正确的）
         select type_logistics_info(create_date, ttype, rwh, create_admin)
           bulk collect into v_lottery_batch
           from
               (
                  select create_date, ereceipt_type.batch + 10 ttype, (select receive_wh from wh_goods_receipt where sgr_no = wh_goods_receipt_detail.sgr_no) rwh, create_admin
                    from wh_goods_receipt_detail
                   where plan_code = p_plan
                     and batch_no = p_batch
                     and receipt_type = ereceipt_type.batch
                     and valid_number = evalid_number.trunk
                     and trunk_no = v_lottery_detail.trunk_no
                     and box_no = '-'
                     and package_no = '-'
                  union
                  select create_date, ereceipt_type.batch + 10 ttype, (select receive_wh from wh_goods_receipt where sgr_no = wh_goods_receipt_detail.sgr_no) rwh, create_admin
                    from wh_goods_receipt_detail
                   where plan_code = p_plan
                     and batch_no = p_batch
                     and receipt_type = ereceipt_type.batch
                     and valid_number = evalid_number.box
                     and trunk_no = v_lottery_detail.trunk_no
                     and box_no = p_value
                     and package_no = '-'
               );

         with
            detail_issue as (
               -- 出库明细（盒）
               select sgi_no
                 from wh_goods_issue_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.box
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = p_value
                  and package_no = '-'),
            detail_issue_trunk as (
               -- 出库明细（箱）
               select sgi_no
                 from wh_goods_issue_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.trunk
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = '-'
                  and package_no = '-'),
            detail_receipt as (
               -- 入库明细（盒）
               select sgr_no
                 from wh_goods_receipt_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.box
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = p_value
                  and package_no = '-'),
            detail_receipt_trunk as (
               -- 入库明细（箱）
               select sgr_no
                 from wh_goods_receipt_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.trunk
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = '-'
                  and package_no = '-'),
            result_issue as (
               -- 出库记录
               select issue_end_time, issue_type, send_wh, receive_admin
                 from wh_goods_issue
                where sgi_no in (select sgi_no from detail_issue
                                 union all
                                 select sgi_no from detail_issue_trunk
                                )),
            result_receipt as (
               -- 入库记录
               select receipt_end_time, receipt_type, receive_wh, send_admin
                 from wh_goods_receipt
                where receipt_type not in (ereceipt_type.batch)
                  and sgr_no in (select sgr_no from detail_receipt
                                 union all
                                 select sgr_no from detail_receipt_trunk
                                )),
            result as (
               select issue_end_time, issue_type, send_wh, receive_admin from result_issue
               union
               select receipt_end_time, receipt_type + 10, receive_wh, send_admin from result_receipt)
         select type_logistics_info(issue_end_time, issue_type, send_wh, receive_admin)
           bulk collect into c_result
           from result;

      -- “本”
      when p_valid_number = evalid_number.pack or p_valid_number = evalid_number.ticket then
         v_lottery_detail := f_get_lottery_info(p_plan, p_batch, evalid_number.pack, p_value);

         -- 先找批次入库记录（总有一款适合批次入库，这里是排他的，所以连续三个sql。但是最终，只有一个sql会有结果，所以数据是正确的）
         select type_logistics_info(create_date, ttype, rwh, create_admin)
           bulk collect into v_lottery_batch
           from
               (
                  select create_date, ereceipt_type.batch + 10 ttype, (select receive_wh from wh_goods_receipt where sgr_no = wh_goods_receipt_detail.sgr_no) rwh, create_admin
                    from wh_goods_receipt_detail
                   where plan_code = p_plan
                     and batch_no = p_batch
                     and receipt_type = ereceipt_type.batch
                     and valid_number = evalid_number.trunk
                     and trunk_no = v_lottery_detail.trunk_no
                     and box_no = '-'
                     and package_no = '-'
                  union
                  select create_date, ereceipt_type.batch + 10 ttype, (select receive_wh from wh_goods_receipt where sgr_no = wh_goods_receipt_detail.sgr_no) rwh, create_admin
                    from wh_goods_receipt_detail
                   where plan_code = p_plan
                     and batch_no = p_batch
                     and receipt_type = ereceipt_type.batch
                     and valid_number = evalid_number.box
                     and trunk_no = v_lottery_detail.trunk_no
                     and box_no = v_lottery_detail.box_no
                     and package_no = '-'
                  union
                  select create_date, ereceipt_type.batch + 10 ttype, (select receive_wh from wh_goods_receipt where sgr_no = wh_goods_receipt_detail.sgr_no) rwh, create_admin
                    from wh_goods_receipt_detail
                   where plan_code = p_plan
                     and batch_no = p_batch
                     and receipt_type = ereceipt_type.batch
                     and valid_number = evalid_number.pack
                     and trunk_no = v_lottery_detail.trunk_no
                     and box_no = v_lottery_detail.box_no
                     and package_no = p_value
               );

         with
            detail_issue as (
               -- 出库明细（本）
               select sgi_no
                 from wh_goods_issue_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.pack
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = v_lottery_detail.box_no
                  and package_no = p_value),
            detail_issue_box as (
               -- 出库明细（盒）
               select sgi_no
                 from wh_goods_issue_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.box
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = v_lottery_detail.box_no
                  and package_no = '-'),
            detail_issue_trunk as (
               -- 出库明细（箱）
               select sgi_no
                 from wh_goods_issue_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.trunk
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = '-'
                  and package_no = '-'),
            detail_receipt as (
               -- 入库明细（本）
               select sgr_no
                 from wh_goods_receipt_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.pack
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = v_lottery_detail.box_no
                  and package_no = p_value),
            detail_receipt_box as (
               -- 入库明细（盒）
               select sgr_no
                 from wh_goods_receipt_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.box
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = v_lottery_detail.box_no
                  and package_no = '-'),
            detail_receipt_trunk as (
               -- 入库明细（箱）
               select sgr_no
                 from wh_goods_receipt_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.trunk
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = '-'
                  and package_no = '-'),
            result_issue as (
               -- 出库记录
               select issue_end_time, issue_type, send_wh, receive_admin
                 from wh_goods_issue
                where sgi_no in (select sgi_no from detail_issue
                                 union all
                                 select sgi_no from detail_issue_trunk
                                 union all
                                 select sgi_no from detail_issue_box
                                )),
            result_receipt as (
               -- 入库记录
               select receipt_end_time, receipt_type, receive_wh, send_admin
                 from wh_goods_receipt
                where receipt_type not in (ereceipt_type.batch)
                  and sgr_no in (select sgr_no from detail_receipt
                                 union all
                                 select sgr_no from detail_receipt_trunk
                                 union all
                                 select sgr_no from detail_receipt_box
                                )),
            result as (
               select issue_end_time, issue_type, send_wh, receive_admin from result_issue
               union
               select receipt_end_time, receipt_type + 10, receive_wh, send_admin from result_receipt)
         select type_logistics_info(issue_end_time, issue_type, send_wh, receive_admin)
           bulk collect into c_result
           from result;
   end case;

   -- 拼接查询结果
   c_result := v_lottery_batch multiset union c_result;

   with
      base as (
         select ttime, obj_type,
                'Outlet [' || obj_object_s || ']' obj_object_s,
                obj_object_t
           from table(c_result) t
          where obj_type in (4, 14)
         union all
         select ttime, obj_type,
                (select warehouse_name from wh_info where warehouse_code = t.obj_object_s) obj_object_s,
                obj_object_t
           from table(c_result) t
          where obj_type not in (4, 14)),
      base_with_name as (
         select ttime, obj_type, obj_object_s,
                (select admin_realname from adm_info where admin_id = base.obj_object_t) obj_object_t
           from base
      )
   select type_logistics_info(ttime, obj_type, obj_object_s, obj_object_t)
     bulk collect into v_rtv
     from base_with_name
    order by ttime desc;

   c_result := v_rtv;

exception
   when others then
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
 
/ 
prompt 正在建立[PROCEDURE -> p_get_lottery_reward.sql ]...... 
create or replace procedure p_get_lottery_reward
/****************************************************************/
   ------------------- 彩票中奖查询 -------------------
   ---- 查询输入的彩票是否中奖，并且返回中奖信息
   ---- add by 陈震: 2015/9/21
   ---- 业务流程：
   ----     1、校验输入参数。（方案批次是否存在，有效位数是否正确；）
   ----     2、查询2.1.4.7 批次信息导入之中奖明细（game_batch_reward_detail）表，是否有记录，有则中奖
   ----     3、截取奖符，去2.1.4.6 批次信息导入之奖符（game_batch_import_reward）中进行查询，获取中奖等级和中奖金额
   ---- modify by dzg :2015/10/21
   ---- 返回一个结果 : 0中奖 1大奖 2 未中奖 3 已兑奖 4 未销售或无效
   ---- 未销售没有返回4
   ---- modify by dzg: 2016/4/4 逻辑错误

   /*************************************************************/
(
 --------------输入----------------
  p_plan                               in char,             -- 方案编号
  p_batch                              in char,             -- 批次编号
  p_package_no                         in varchar2,         -- 彩票本号
  p_security_string                    in char,             -- 保安区码（21位）
  p_level                              in number,           -- 兑奖级别（1=站点、2=分公司、3=总公司）
 ---------出口参数---------
  c_reward_level                       out number,          -- 中奖奖级
  c_reward_amount                      out number,          -- 中奖金额
  c_reward_result                      out number,          -- 票中奖结果，用于POS端使用
  c_errorcode                          out number,          -- 错误编码
  c_errormesg                          out string           -- 错误原因

 ) is

   v_count                             number(2);           -- 记录数
   v_safe_code                         varchar2(50);        -- 兑奖码
   v_publisher                         number(2);           -- 厂商编码

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   c_reward_level := 0;
   c_reward_amount := 0;
   c_reward_result := 2;

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if f_get_reward_ticket_ver(p_plan, p_batch, p_package_no) = 0 then
      if not f_check_plan_batch(p_plan, p_batch) then
         c_errorcode := 1;
         c_errormesg := dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || error_msg.err_common_102; -- 无此方案和批次
         return;
      end if;

      -- 判断彩票是否销售
      v_count := 0;
      select count(*)
        into v_count
        from wh_ticket_package
       where plan_code = p_plan
         and batch_no = p_batch
         and package_no = p_package_no
         and status = eticket_status.saled;
      if v_count <= 0 then
         c_reward_result := 4;
         return;
      end if;
   end if;
   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* 查询2.1.4.7 批次信息导入之中奖明细（game_batch_reward_detail）表，是否有记录，有则中奖 *************************/
   if f_get_reward_ticket_ver(p_plan, p_batch, p_package_no) = 1 then
      v_publisher := epublisher_code.sjz;
   else
      v_publisher := f_get_plan_publisher(p_plan);
   end if;

   case v_publisher
      when epublisher_code.sjz then
         begin
            select safe_code
              into v_safe_code
              from game_batch_reward_detail
             where plan_code = p_plan
               and batch_no = p_batch
               and safe_code = p_security_string;

               v_count := 1;
         exception
            when no_data_found then
               v_count := 0;
         end;

      when epublisher_code.zc3c then
         begin
            select safe_code
              into v_safe_code
              from game_batch_reward_detail
             where plan_code = p_plan
               and batch_no = p_batch
               and pre_safe_code = substr(p_security_string, 1, 16);

               v_count := 1;

         exception
            when no_data_found then
               v_count := 0;
         end;

   end case;

   if v_count = 1 then
      --已中奖
      c_reward_result := 0;

      select reward_no, single_reward_amount
        into c_reward_level, c_reward_amount
        from game_batch_import_reward
       where plan_code = p_plan
         and batch_no = p_batch
         and instr(fast_identity_code, substr(v_safe_code, epublisher_sjz.fast_identity_code_pos, epublisher_sjz.len_fast_identity_code)) > 0;

      --判断是否已兑奖
      select count(*)
        into v_count
        from flow_pay
       where plan_code = p_plan
         and batch_no = p_batch
         and security_code = p_security_string;
      if v_count = 1 then
         c_reward_result := 3;
      else
        --大奖
        case
           -- 兑奖级别（1=站点、2=分公司、3=总公司）
           when p_level = 1 then
              if c_reward_amount >= to_number(f_get_sys_param(5)) then
                 c_reward_result := 1;
              end if;

           when p_level = 2 then
              if c_reward_amount >= to_number(f_get_sys_param(6)) then
                 if f_get_sys_param(7) = '1' then
                    c_reward_result := 1;
                 end if;
              end if;
           when p_level = 3 then
              return;
           else
              c_errorcode := 1;
              c_errormesg := error_msg.err_common_106;
              return;
        end case;
      end if;
   end if;

exception
   when others then
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
 
/ 
prompt 正在建立[PROCEDURE -> p_gi_outbound.sql ]...... 
create or replace procedure p_gi_outbound
/****************************************************************/
   ------------------- 出货单出库 -------------------
   ---- 出货单出库。支持新出库，继续出库，出库完结。
   ----     状态必须是“已提交”，才能进行操作
   ----     新出库：  更新“出货单”的出货仓库信息、状态值；
   ----               创建“出库单”；按照传递的出库对象（箱、盒、包）更新彩票数据，同时也要在出库单明细中记录出库对象；
   ----               根据彩票统计数据，更新管理员持票库存，判断是否超过管理员最大限额，更新“出库单”和“出货单”实际出票记录；
   ----
   ----     继续出库：按照传递的出库对象（箱、盒、包）更新彩票数据，同时也要在出库单明细中记录出库对象；
   ----               根据彩票统计数据，更新管理员持票库存，判断是否超过管理员最大限额，更新“出库单”和“出货单”实际出票记录；
   ----
   ----     出库完结：更新“出货单”和“出库单”时间和状态信息，同时更新相关“订单”的状态。
   ---- add by 陈震: 2015/9/19
   ---- 涉及的业务表：
   ----     2.1.6.6 出货单（sale_delivery_order）                    -- 更新
   ----     2.1.5.10 出库单（wh_goods_receipt）                      -- 新增、更新
   ----     2.1.5.11 出库单明细（wh_goods_receipt_detail）           -- 新增、更新
   ----     2.1.5.3 即开票信息（箱）（wh_ticket_trunk）              -- 更新
   ----     2.1.5.4 即开票信息（盒）（wh_ticket_box）                -- 更新
   ----     2.1.5.5 即开票信息（本）（wh_ticket_package）            -- 更新
   ---- 业务流程：
   ----     1、校验输入参数。（仓库是否存在；操作类型是否为新、继续、完结；操作人是否合法；）
   ----     2、操作类型为“完结”时，
   ----        更新“出货单”的“出货日期”和“状态”，
   ----        更新“出库单”的“出库时间”和“状态”；
   ----        更新“出货单”相关“订单”的状态；
   ----        结束运行，返回
   ----     3、获取已经保存的参数。（方案批次的包装信息-bulk方式获取；）
   ----     3、操作类型为“新建”时，更新“出货单”发货仓库信息和状态，条件中要加入“状态”，“状态”必须为“已提交”；创建“出库单”；
   ----     4、按照出库明细，更新“即开票信息”表中各个对象的属性，条件中必须加入“状态”和“所在仓库”条件，并且检查更新记录数量，如果出现无更新记录情况，则报错；同时统计彩票统计信息；
   ----     5、更新管理员持票库存，判断是否超过管理员最大限额；
   ----     6、更新“出库单”的“实际出库金额合计”和“实际出库张数”,“出货单”的“实际调拨票数”和“实际调拨票数涉及金额”记录；

/*************************************************************/
(
 --------------输入----------------
 p_do_no             in char,                -- 出货单编号
 p_warehouse         in char,                -- 发货仓库
 p_oper_type         in number,              -- 操作类型(1-新增，2-继续，3-完结)
 p_oper              in number,              -- 操作人
 p_remark            in varchar2,            -- 备注
 p_array_lotterys    in type_lottery_list,   -- 出库的彩票对象

 ---------出口参数---------
 c_errorcode out number,                     --错误编码
 c_errormesg out string                      --错误原因

 ) is

   v_count                 number(5);                                      -- 求记录数的临时变量
   v_wh_org                char(2);                                        -- 仓库所在部门
   v_plan_tickets          number(18);                                     -- 计划出库票数
   v_plan_amount           number(28);                                     -- 计划出库金额

   v_sgi_no                char(10);                                       -- 出库单编号
   v_list_count            number(10);                                     -- 出库明细总数

   type type_detail        is table of wh_goods_issue_detail%rowtype;
   v_insert_detail         type_detail;                                    -- 插入出库明细的数组
   v_detail_list           type_lottery_detail_list;                       -- 出库明细
   v_stat_list             type_lottery_statistics_list;                   -- 按照方案和批次统计的金额和票数

   v_total_tickets         number(20);                                     -- 当此出库的总票数
   v_total_amount          number(28);                                     -- 当此出库的总金额
   v_plan_publish          number(1);                                      -- 印制厂商编号
   v_delivery_mm           number(4);                                      -- 出货单对应的市场管理员

   v_delivery_amount       number(28);                                     -- 持票金额

   v_err_code              number(10);                                     -- 调用存储过程时，返回值
   v_err_msg               varchar2(4000);                                 -- 调用存储过程时，返回错误信息

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;

   if not f_check_warehouse(p_warehouse) then
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_warehouse) || error_msg.err_common_101; -- 无此仓库
      return;
   end if;

   if not p_oper_type in (1,2,3) then
      c_errorcode := 3;
      c_errormesg := dbtool.format_line(p_oper_type) || error_msg.err_common_105; -- 操作类型参数错误，应该为1，2，3
      return;
   end if;

   -- 检查是否输入了彩票对象
   if p_array_lotterys.count = 0 and p_oper_type in (1,2) then
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_109; -- 输入参数中，没有发现彩票对象
      return;
   end if;

   -- 继续出库时，判断是否已经完结
   if p_oper_type = 2 then
      select count(*) into v_count from dual where exists(select 1 from wh_goods_issue where ref_no = p_do_no and status = ework_status.working);
      if v_count = 0 then
         c_errorcode := 4;
         c_errormesg := dbtool.format_line(p_do_no) || error_msg.err_p_gi_outbound_3; -- 在进行继续出库时，输入的调拨单号错误，或者此调拨单对应的出库单，出库已经完结
         return;
      end if;
   end if;

   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* 操作类型为“完结”时，更新“出货单”的“发货时间”和“状态”，更新“出库单”的“出库时间”和“状态”，结束运行，返回。 *************************/
   if p_oper_type = 3 then
      -- 更新“出货单”的“发货时间”和“状态”
      update sale_delivery_order
         set out_date = sysdate,
             status = eorder_status.sent
       where do_no = p_do_no
         and status = eorder_status.agreed
      returning
         status, apply_admin
      into
         v_count, v_delivery_mm;
      if sql%rowcount = 0 then
         rollback;
         c_errorcode := 4;
         c_errormesg := dbtool.format_line(p_do_no) || dbtool.format_line(v_count) || error_msg.err_p_gi_outbound_4; -- 出货单出库完结时，出货单状态不合法
         return;
      end if;

      -- 更新“出库单”的“出库时间”和“状态”
      update wh_goods_issue
         set status = ework_status.done,
             remark = p_remark,
             issue_end_time = sysdate
       where ref_no = p_do_no
         and status = ework_status.working;

      -- 更新“订单”状态  （BUG 208，订单状态知道已受理，就完毕了，不需要后续再更新）
      /*update sale_order
         set status = eorder_status.sent,
             sender_admin = v_delivery_mm,
             send_warehouse = p_warehouse,
             send_date = sysdate
       where order_no in (select order_no from sale_delivery_order_all where do_no = p_do_no); */

      commit;
      return;
   end if;

   /**********************************************************************************************/
   /******************* 检查输入的出库对象以及已经提交的出库对象是否合法 *************************/
   if f_check_import_ticket(p_do_no, 2, p_array_lotterys) then
      c_errorcode := 6;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_103; -- 彩票对象，存在“自包含”的情况
      return;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* 获取已经保存的参数。（方案批次的包装信息-bulk方式获取；） *************************/

   -- 获取印制厂商信息
/*   select plan_flow
     into v_plan_publish
     from inf_publishers
    where publisher_code =
          (select publisher_code from game_plans where plan_code = p_plan);
*/
   -- 仓库所在部门
   select org_code into v_wh_org from wh_info where warehouse_code = p_warehouse;

   /********************************************************************************************************************************************************************/
   /******************* 操作类型为“新建”时，更新“出货单”发货信息，条件中要加入“状态”，“状态”必须为“已审批”；创建“出库单” *************************/
   if p_oper_type = 1 then
      -- 更新“出货单”发货信息
      update sale_delivery_order
         set wh_org = v_wh_org,
             wh_code = p_warehouse,
             wh_admin = p_oper,
             status = eorder_status.agreed
       where do_no = p_do_no
         and status = eorder_status.applyed
      returning
         status, tickets, apply_admin, amount
      into
         v_count, v_plan_tickets, v_delivery_mm, v_plan_amount;
      if sql%rowcount = 0 then
         rollback;
         c_errorcode := 5;
         c_errormesg := dbtool.format_line(p_do_no) || dbtool.format_line(v_count) || error_msg.err_p_gi_outbound_5; -- 进行出货单出库时，出货单状态不合法
         return;
      end if;

      -- 创建“出库单”
      insert into wh_goods_issue
         (sgi_no,                    create_admin,                issue_amount,
          issue_tickets,             issue_type,                  ref_no,
          send_org,                  send_wh,                     receive_admin)
      values
         (f_get_wh_goods_issue_seq,  p_oper,                      v_plan_amount,
          v_plan_tickets,            eissue_type.delivery_order,  p_do_no,
          v_wh_org,                  p_warehouse,                 v_delivery_mm)
      returning
         sgi_no
      into
         v_sgi_no;
   else
      -- 获取出库单编号
      begin
         select sgi_no into v_sgi_no from wh_goods_issue where ref_no = p_do_no;
      exception
         when no_data_found then
            rollback;
            c_errorcode := 6;
            c_errormesg := dbtool.format_line(p_do_no) || error_msg.err_p_gi_outbound_6; -- 不能获得出库单编号
            return;
      end;

      -- 获取市场管理员编号
      select apply_admin
        into v_delivery_mm
        from sale_delivery_order
       where do_no = p_do_no;

   end if;

   /********************************************************************************************************************************************************************/
   /******************* 按照出库明细，更新“即开票信息”表中各个对象的属性；同时统计彩票统计信息 *************************/

   -- 初始化数组
   v_insert_detail := type_detail();
   v_total_tickets := 0;

   -- 根据明细数据，更新“即开票”状态
   p_ticket_perferm(p_array_lotterys, p_oper, eticket_status.in_warehouse, eticket_status.in_mm, p_warehouse, v_delivery_mm, v_err_code, v_err_msg);
   if v_err_code <> 0 then
      rollback;
      c_errorcode := 1;
      c_errormesg := error_msg.err_common_104 || v_err_msg; -- 更新“即开票”状态时，出现错误
      return;
   end if;

   -- 统计出库对象的票数据
   p_lottery_detail_stat(p_array_lotterys, v_detail_list, v_stat_list, v_total_tickets, v_total_amount);

   -- 插入出库明细
   for v_list_count in 1 .. v_detail_list.count loop
      v_insert_detail.extend;
      v_insert_detail(v_list_count).sgi_no := v_sgi_no;
      v_insert_detail(v_list_count).ref_no := p_do_no;
      v_insert_detail(v_list_count).sequence_no := f_get_wh_goods_issue_detai_seq;
      v_insert_detail(v_list_count).issue_type := eissue_type.delivery_order;

      v_insert_detail(v_list_count).valid_number := v_detail_list(v_list_count).valid_number;
      v_insert_detail(v_list_count).plan_code := v_detail_list(v_list_count).plan_code;
      v_insert_detail(v_list_count).batch_no := v_detail_list(v_list_count).batch_no;
      v_insert_detail(v_list_count).amount := v_detail_list(v_list_count).amount;
      v_insert_detail(v_list_count).trunk_no := v_detail_list(v_list_count).trunk_no;
      v_insert_detail(v_list_count).box_no := v_detail_list(v_list_count).box_no;
      v_insert_detail(v_list_count).package_no := v_detail_list(v_list_count).package_no;
      v_insert_detail(v_list_count).tickets := v_detail_list(v_list_count).tickets;
   end loop;

   forall v_list_count in 1 .. v_insert_detail.count
      insert into wh_goods_issue_detail values v_insert_detail(v_list_count);

   /********************************************************************************************************************************************************************/
   /******************* 更新管理员持票库存，判断是否超过管理员最大限额； *************************/
   for v_list_count in 1 .. v_stat_list.count loop
      merge into acc_mm_tickets tgt
      using (select v_delivery_mm market_admin, v_stat_list(v_list_count).plan_code plan_code, v_stat_list(v_list_count).batch_no batch_no from dual) tab
         on (tgt.market_admin = tab.market_admin and tgt.plan_code = tab.plan_code and tgt.batch_no = tab.batch_no)
       when matched then
         update set tgt.tickets = tgt.tickets + v_stat_list(v_list_count).tickets,
                    tgt.amount = tgt.amount + v_stat_list(v_list_count).amount
       when not matched then
         insert values (v_delivery_mm, v_stat_list(v_list_count).plan_code, v_stat_list(v_list_count).batch_no, v_stat_list(v_list_count).tickets, v_stat_list(v_list_count).amount);
   end loop;

   -- 获取管理员当前最大持票金额
   select sum(tickets)
     into v_delivery_amount
     from acc_mm_tickets
    where market_admin = v_delivery_mm;

   -- 判断是否超过最大持票金额
   select count(*)
     into v_count
     from dual
    where exists(select 1 from inf_market_admin
                  where market_admin = v_delivery_mm
                    and max_amount_ticketss < nvl(v_delivery_amount, 0));
   if v_count = 1 then
      rollback;
      c_errorcode := 17;
      c_errormesg := dbtool.format_line(v_delivery_mm) || dbtool.format_line(v_delivery_amount) || error_msg.err_p_gi_outbound_17; -- 超过此管理员允许持有的“最高赊票金额”
      return;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* 更新“出库单”的“实际出库金额合计”和“实际出库张数”,“出货单”的“实际调拨票数”和“实际调拨票数涉及金额”记录 *************************/
   update wh_goods_issue
      set act_issue_tickets = nvl(act_issue_tickets, 0) + v_total_tickets,
          act_issue_amount = nvl(act_issue_amount, 0) + v_total_amount
    where sgi_no = v_sgi_no;

   update sale_delivery_order
      set act_tickets = nvl(act_tickets, 0) + v_total_tickets,
          act_amount = nvl(act_amount, 0) + v_total_amount
    where do_no = p_do_no;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;
end;
 
/ 
prompt 正在建立[PROCEDURE -> p_import_batch_file.sql ]...... 
CREATE OR REPLACE PROCEDURE p_import_batch_file
/****************************************************************/
   ------------------- 适用于导入批次数据文件 -------------------
   ---- 导入批次数据文件
   ---- add by 陈震: 2015/9/9
   ---- 业务流程：页面中保存数据以后，调用此存储过程，用来导入数据文件
   ----           1、查找  批次信息导入（GAME_BATCH_IMPORT）表，获取文件名
   ----           2、建立扩展表，包装信息、奖符信息、中奖明细信息，
   /*************************************************************/
(
 --------------输入----------------
 p_plan_code in varchar2, -- 方案代码
 p_batch_no  in varchar2, -- 生产批次
 p_oper      IN number,   -- 操作人

 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因

 ) AUTHID CURRENT_USER IS

   v_count number(5);

   v_file_name_package VARCHAR2(500); -- 包装信息文件名
   v_file_name_map     VARCHAR2(500); -- 奖符信息文件名
   v_file_name_reward  VARCHAR2(500); -- 中奖明细信息文件名
   v_import_no         VARCHAR2(12); -- 数据导入编号

   v_table_name varchar2(100); -- 导数据的临时表
   v_sql        varchar2(10000); -- 动态SQL语句

   v_file_plan  varchar2(100); -- 第1行方案代码
   v_file_batch varchar2(100); -- 第5行生产批次

   v_bind_1  varchar2(100); -- 第1行方案代码
   v_bind_2  varchar2(100); -- 第2行彩票分类
   v_bind_3  varchar2(100); -- 第3行彩票名称
   v_bind_4  varchar2(100); -- 第4行单票金额（没有实际用途，不参与计算，也不导入数据库）
   v_bind_5  varchar2(100); -- 第5行生产批次
   v_bind_6  varchar2(100); -- 第6行每组箱数
   v_bind_7  varchar2(100); -- 第7行每箱本数
   v_bind_8  varchar2(100); -- 第8行每本张数
   v_bind_9  varchar2(100); -- 第9行奖组张数（万张）
   v_bind_10 varchar2(100); -- 第10行首分组号
   v_bind_11 varchar2(100); -- 第11行生产厂家（没有实际用途，不参与计算，也不导入数据库）
   v_bind_12 varchar2(100); -- 第12行单箱重量（没有实际用途，不参与计算，也不导入数据库）
   v_bind_13 varchar2(100); -- 第13行总票数
   v_bind_14 varchar2(100); -- 第14行首箱编号（例如“00001”）
   v_bind_15 varchar2(100); -- 第15行每箱盒数

   v_plan_publish          number(1);                                      -- 印制厂商编号

   v_tab_reward            game_batch_import_reward%rowtype;
   v_first_line            boolean;

BEGIN

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   select count(*)
     into v_count
     from dual
    where exists (select 1
             from GAME_BATCH_IMPORT
            where PLAN_CODE = p_plan_code
              and BATCH_NO = p_batch_no);
   IF v_count = 1 THEN
      c_errorcode := 1;
      c_errormesg := error_msg.ERR_P_IMPORT_BATCH_FILE_1; -- 批次数据信息已经存在
      RETURN;
   END IF;

   /**********************************************************/
   /******************* 插入导入信息表 *************************/
   v_file_name_package := 'PACKAGE-' || p_plan_code || '_' || p_batch_no || '.imp';
   v_file_name_map     := 'MAP-' || p_plan_code || '_' || p_batch_no || '.imp';
   v_file_name_reward  := 'REWARD-' || p_plan_code || '_' || p_batch_no || '.imp';

   insert into game_batch_import
      (import_no,
       plan_code,
       batch_no,
       package_file,
       reward_map_file,
       reward_detail_file,
       start_date,
       end_date,
       import_admin)
   values
      (f_get_batch_import_seq,
       p_plan_code,
       p_batch_no,
       v_file_name_package,
       v_file_name_map,
       v_file_name_reward,
       sysdate,
       null,
       p_oper)
   returning import_no into v_import_no;

   /**********************************************************/
   /******************* 导入包装信息 *************************/
   -- 删除原有数据
   -- delete from GAME_BATCH_IMPORT_DETAIL where PLAN_CODE = p_plan_code and BATCH_NO = p_batch_no;

   -- 建立外部表，使用统一的表名 ext_kws_import。导入之前，确定是否存在这张表，存在就删除。
   v_table_name := 'ext_kws_import';
   SELECT COUNT(*)
     INTO v_count
     FROM user_tables
    WHERE table_name = upper(v_table_name);
   IF v_count = 1 THEN
      v_sql := 'drop table ' || v_table_name;
      EXECUTE IMMEDIATE v_sql;
   END IF;

   -- 拼接导入SQL，并开始导入数据
   v_sql := 'create table ' || v_table_name || ' (tmp_col VARCHAR2(100)) ';
   v_sql := v_sql || 'ORGANIZATION EXTERNAL';
   v_sql := v_sql || '  (TYPE ORACLE_LOADER ';
   v_sql := v_sql || '   DEFAULT DIRECTORY impdir';
   v_sql := v_sql || '   ACCESS PARAMETERS ';
   v_sql := v_sql || '      (RECORDS DELIMITED BY NEWLINE';
   v_sql := v_sql || '       LOAD WHEN (tmp_col != BLANKS))';
   v_sql := v_sql || '   LOCATION (''' || v_file_name_package || ''')';
   v_sql := v_sql || '  )';
   EXECUTE IMMEDIATE v_sql;

   -- 先获取包装文件中的所含数据内容
   -- 以下内容，摘自 “SVN\doc\11Reference\现场包装编码规则\说明文件.docx”
   v_sql := 'select * from (select rownum cnt, tmp_col from ext_kws_import) pivot(max(tmp_col) for cnt in(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15))';
   EXECUTE IMMEDIATE v_sql
      into v_bind_1, v_bind_2, v_bind_3, v_bind_4, v_bind_5, v_bind_6, v_bind_7, v_bind_8, v_bind_9, v_bind_10, v_bind_11, v_bind_12, v_bind_13, v_bind_14, v_bind_15;

  -- 去掉该死的DOS回车
  v_bind_1  := replace(v_bind_1  ,chr(13),'');
  v_bind_2  := replace(v_bind_2  ,chr(13),'');
  v_bind_3  := replace(v_bind_3  ,chr(13),'');
  v_bind_4  := replace(v_bind_4  ,chr(13),'');
  v_bind_5  := replace(v_bind_5  ,chr(13),'');
  v_bind_6  := replace(v_bind_6  ,chr(13),'');
  v_bind_7  := replace(v_bind_7  ,chr(13),'');
  v_bind_8  := replace(v_bind_8  ,chr(13),'');
  v_bind_9  := replace(v_bind_9  ,chr(13),'');
  v_bind_10 := replace(v_bind_10 ,chr(13),'');
  v_bind_11 := replace(v_bind_11 ,chr(13),'');
  v_bind_12 := replace(v_bind_12 ,chr(13),'');
  v_bind_13 := replace(v_bind_13 ,chr(13),'');
  v_bind_14 := replace(v_bind_14 ,chr(13),'');
  v_bind_15 := replace(v_bind_15 ,chr(13),'');


   -- 判断文件中的数据，与待导入的数据是否一致
   v_file_plan := v_bind_1;
   v_file_batch := v_bind_5;
   if v_file_plan is null or v_file_batch is null or (v_file_plan <> p_plan_code) or (v_file_batch <> p_batch_no) then
      rollback;
      c_errorcode := 2;
      c_errormesg := error_msg.ERR_P_IMPORT_BATCH_FILE_2; -- 文件中的方案与批次信息同导入记录中内容不符
      delete game_batch_import where plan_code = p_plan_code and batch_no=p_batch_no;
      commit;
      RETURN;
   end if;
   
   -- 判断逻辑关系。
   -- 1、每箱本数/每箱盒数 应该是一个整数
   if to_number(v_bind_7) / to_number(v_bind_15) <> trunc(to_number(v_bind_7) / to_number(v_bind_15)) then
      rollback;
      c_errorcode := 2;
      c_errormesg := error_msg.ERR_P_IMPORT_BATCH_FILE_3; -- 批次导入文件（包装参数）出现逻辑关系错误：{每箱本数/每箱盒数} 的结果不是一个整数
      delete game_batch_import where plan_code = p_plan_code and batch_no=p_batch_no;
      commit;
      RETURN;
   end if;

   -- 插入数据
   insert into GAME_BATCH_IMPORT_DETAIL
      (IMPORT_NO,
       PLAN_CODE,
       BATCH_NO,
       LOTTERY_TYPE,
       LOTTERY_NAME,
       BOXES_EVERY_TRUNK,
       TRUNKS_EVERY_GROUP,
       PACKS_EVERY_TRUNK,
       TICKETS_EVERY_PACK,
       TICKETS_EVERY_GROUP,
       FIRST_REWARD_GROUP_NO,
       TICKETS_EVERY_BATCH,
       FIRST_TRUNK_BATCH,
       STATUS)
   values
      (v_import_no,
       p_plan_code,
       p_batch_no,
       v_bind_2,
       v_bind_3,
       to_number(v_bind_15),
       to_number(v_bind_6),
       to_number(v_bind_7),
       to_number(v_bind_8),
       to_number(v_bind_9) * 10000,
       to_number(v_bind_10),
       to_number(v_bind_13),
       to_number(v_bind_14),
       ebatch_item_status.working);

   -- 删除临时表
   v_sql := 'drop table ' || v_table_name;
   EXECUTE IMMEDIATE v_sql;

   /**********************************************************/
   /******************* 导入奖符信息 *************************/
   -- 删除原有数据
   delete from GAME_BATCH_IMPORT_REWARD where PLAN_CODE = p_plan_code and BATCH_NO = p_batch_no;

   -- 拼接导入SQL，并开始导入数据
   v_sql := 'create table ' || v_table_name ||
            ' (REWARD_NO VARCHAR2(10),FAST_IDENTITY_CODE VARCHAR2(20),SINGLE_REWARD_AMOUNT VARCHAR2(10),COUNTS VARCHAR2(10)) ';
   v_sql := v_sql || 'ORGANIZATION EXTERNAL';
   v_sql := v_sql || '  (TYPE ORACLE_LOADER ';
   v_sql := v_sql || '   DEFAULT DIRECTORY impdir';
   v_sql := v_sql || '   ACCESS PARAMETERS ';
   v_sql := v_sql ||
            '      (RECORDS DELIMITED BY NEWLINE  LOAD WHEN (FAST_IDENTITY_CODE != BLANKS) fields terminated by 0X''09'' missing field values are null )';
   v_sql := v_sql || '   LOCATION (''' || v_file_name_map || ''')';
   v_sql := v_sql || '  )';
   EXECUTE IMMEDIATE v_sql;

   v_sql := 'truncate table tmp_batch_reward';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'insert into tmp_batch_reward select to_number(replace(REWARD_NO,chr(13),'''')),trim(FAST_IDENTITY_CODE),to_number(replace(SINGLE_REWARD_AMOUNT,chr(13),'''')),to_number(replace(COUNTS,chr(13),'''')) from ' || v_table_name;
   EXECUTE IMMEDIATE v_sql;

   -- 循环外部表，生成数据
   v_first_line := true;
   v_tab_reward.IMPORT_NO := v_import_no;
   v_tab_reward.PLAN_CODE := p_plan_code;
   v_tab_reward.BATCH_NO := p_batch_no;

   for loop_tab in (select * from tmp_batch_reward) loop
      if loop_tab.REWARD_NO is not null then
         if not v_first_line then
            -- 插入上次获取的数据
            insert into GAME_BATCH_IMPORT_REWARD values v_tab_reward;
         end if;

         -- 确保导入的数据，都是瑞尔
         if loop_tab.SINGLE_REWARD_AMOUNT < 1000 then
            rollback;
            delete GAME_BATCH_IMPORT_DETAIL where plan_code = p_plan_code and batch_no=p_batch_no;
            delete GAME_BATCH_IMPORT_REWARD where PLAN_CODE = p_plan_code and BATCH_NO = p_batch_no;
            delete game_batch_import where plan_code = p_plan_code and batch_no=p_batch_no;
            commit;
            raise_application_error(-20001, 'User define error: SINGLE_REWARD_AMOUNT must great 1000');
            return;
         end if;

         v_tab_reward.REWARD_NO := loop_tab.REWARD_NO;
         v_tab_reward.SINGLE_REWARD_AMOUNT := loop_tab.SINGLE_REWARD_AMOUNT;
         v_tab_reward.COUNTS := loop_tab.COUNTS;
         v_tab_reward.FAST_IDENTITY_CODE := loop_tab.FAST_IDENTITY_CODE;
      else
         v_tab_reward.FAST_IDENTITY_CODE := v_tab_reward.FAST_IDENTITY_CODE || ',' || loop_tab.FAST_IDENTITY_CODE;
      end if;

      v_first_line := false;
   end loop;
   -- 处理最后一行数据
   insert into GAME_BATCH_IMPORT_REWARD values v_tab_reward;

   -- 删除临时表
   v_sql := 'drop table ext_kws_import';
   EXECUTE IMMEDIATE v_sql;

   /**********************************************************/
   /******************* 导入奖级信息 *************************/
   -- 删除原有数据
   delete from GAME_BATCH_REWARD_DETAIL where PLAN_CODE = p_plan_code and BATCH_NO = p_batch_no;

   -- 拼接导入SQL，并开始导入数据
   v_sql := 'create table ' || v_table_name || ' (tmp_col VARCHAR2(4000)) ';
   v_sql := v_sql || 'ORGANIZATION EXTERNAL';
   v_sql := v_sql || '  (TYPE ORACLE_LOADER ';
   v_sql := v_sql || '   DEFAULT DIRECTORY impdir';
   v_sql := v_sql || '   ACCESS PARAMETERS ';
   v_sql := v_sql || '      (RECORDS DELIMITED BY NEWLINE' ;
   v_sql := v_sql || '       LOAD WHEN (tmp_col != BLANKS) ';
   v_sql := v_sql || '       fields (';
   v_sql := v_sql || '          tmp_col CHAR(4000) ';
   v_sql := v_sql || '       )';
   v_sql := v_sql || '      )';
   v_sql := v_sql || '   LOCATION (''' || v_file_name_reward || ''')';
   v_sql := v_sql || '  )';
   EXECUTE IMMEDIATE v_sql;

   -- 插入数据
   v_sql := 'insert into GAME_BATCH_REWARD_DETAIL (IMPORT_NO, PLAN_CODE, BATCH_NO, SAFE_CODE) ';
   v_sql := v_sql || 'select ''' || v_import_no || ''',';
   v_sql := v_sql || '       ''' || p_plan_code || ''',';
   v_sql := v_sql || '       ''' || p_batch_no || ''',';
   v_sql := v_sql || '       tmp_col from ext_kws_import';
   EXECUTE IMMEDIATE v_sql;

   -- 设置结束时间字段
   update GAME_BATCH_IMPORT
      set END_DATE = sysdate
    where IMPORT_NO = v_import_no;

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      delete GAME_BATCH_IMPORT_DETAIL where plan_code = p_plan_code and batch_no=p_batch_no;
      delete GAME_BATCH_IMPORT_REWARD where PLAN_CODE = p_plan_code and BATCH_NO = p_batch_no;
      delete GAME_BATCH_REWARD_DETAIL where PLAN_CODE = p_plan_code and BATCH_NO = p_batch_no;
      delete game_batch_import where plan_code = p_plan_code and batch_no=p_batch_no;
      commit;
      c_errorcode := 1;
      c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_institutions_create.sql ]...... 
CREATE OR REPLACE PROCEDURE p_institutions_create
/****************************************************************/
  ------------------- 适用于创建组织机构-------------------
  ----创建组织结构
  ----add by dzg: 2015-9-8
  ----业务流程：先插入主表，依次对象字表中
  ----modify by dzg 2015-9-9 表调整状态，增加初始化状态
  ----modify by dzg 2015-9-12 发现bug，address的值保存成额id列表
  ----modify by dzg 2015-9-16 增加功能，新增时创建账户
  ----modify by dzg 2015-10-22 处理部门人数的问题：默认为0
  ----modify by dzg 2015-11-12 检测机构是否重复管辖区域
  /*************************************************************/
(
 --------------输入----------------
 p_institutions_code  IN STRING, --机构编码
 p_institutions_name  IN STRING, --机构名称
 p_institutions_type  IN STRING, --机构类型  1 公司  2 代理
 p_institutions_pare  IN STRING, --上级结构
 p_institutions_head  IN NUMBER, --部门负责人
 p_institutions_phone IN STRING, --部门电话
 p_institutions_emps  IN NUMBER, --部门人数
 p_institutions_adds  IN STRING, --部门地址
 p_institutions_areas IN STRING, --管辖区域列表,使用“,”分割的多个字符串

 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因

 ) IS

  v_count_temp NUMBER := 0; --临时变量
  v_insti_pnum NUMBER := 0; --部门人数

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  IF ((p_institutions_emps IS NULL) OR length(p_institutions_emps) <= 0) THEN
    v_insti_pnum := 0;
  ELSE
    v_insti_pnum := p_institutions_emps;
  END IF;

  /*----------- 数据校验   -----------------*/
  --部门编码不能为空
  IF ((p_institutions_code IS NULL) OR length(p_institutions_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_1;
    RETURN;
  END IF;

  --部门名称不能为空
  IF ((p_institutions_name IS NULL) OR length(p_institutions_name) <= 0) THEN
    c_errorcode := 2;
    c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_2;
    RETURN;
  END IF;

  --部门负责人不存在
  SELECT count(u.admin_id)
    INTO v_count_temp
    FROM adm_info u
   WHERE u.admin_id = p_institutions_head
     And u.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 3;
    c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_3;
    RETURN;
  END IF;

  --部门名称不能为空
  IF ((p_institutions_phone IS NULL) OR length(p_institutions_phone) <= 0) THEN
    c_errorcode := 4;
    c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_4;
    RETURN;
  END IF;

  --部门编码重复
  v_count_temp := 0;

  SELECT count(u.org_code)
    INTO v_count_temp
    FROM inf_orgs u
   WHERE u.org_code = p_institutions_code;

  IF v_count_temp > 0 THEN
    c_errorcode := 5;
    c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_5;
    RETURN;
  END IF;


 --检测区域被重复管辖
  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_institutions_areas))) LOOP
    dbms_output.put_line(i.column_value);

    IF length(i.column_value) > 0 THEN

       v_count_temp := 0;
        SELECT count(*)
          INTO v_count_temp
          FROM inf_org_area u
         WHERE u.area_code = i.column_value;

        IF v_count_temp > 0 THEN
          c_errorcode := 6;
          c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_6;
          RETURN;
        END IF;

    END IF;
  END LOOP;


  --插入基本信息
  insert into inf_orgs
    (org_code,
     org_name,
     org_type,
     super_org,
     phone,
     director_admin,
     persons,
     address,
     org_status)
  values
    (p_institutions_code,
     p_institutions_name,
     p_institutions_type,
     p_institutions_pare,
     p_institutions_phone,
     p_institutions_head,
     v_insti_pnum,
     p_institutions_adds,
     eorg_status.available);

  --循环插入管辖区域
  --先清理原有数据
  delete from inf_org_area
   where inf_org_area.org_code = p_institutions_code;

  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_institutions_areas))) LOOP
    dbms_output.put_line(i.column_value);

    IF length(i.column_value) > 0 THEN

      insert into inf_org_area
        (org_code, area_code)
      values
        (p_institutions_code, i.column_value);

    END IF;
  END LOOP;

  --创建账户
  insert into acc_org_account
    (org_code,
     acc_type,
     acc_name,
     acc_status,
     acc_no,
     credit_limit,
     account_balance,
     frozen_balance,
     check_code)
  values
    (p_institutions_code,
     eacc_type.main_account,
     p_institutions_name,
     eacc_status.available,
     f_get_acc_no(p_institutions_code,'JG'),
     0,
     0,
     0,
     '-');


  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END p_institutions_create;
 
/ 
prompt 正在建立[PROCEDURE -> p_institutions_modify.sql ]...... 
CREATE OR REPLACE PROCEDURE p_institutions_modify
/****************************************************************/
  ------------------- 适用于修改组织机构-------------------
  ----修改组织结构
  ----add by dzg: 2015-9-8 
  ----业务流程：判断是否修改编码，如果修改编码，则机构有除
  ----领导之外的其他人员的时候，则不能修改
  ----modify by dzg 2015-9-28 bug修改的时候编码不能重复
  ----modify by dzg 2015-11-13 检测区域重复
  /*************************************************************/
(
 --------------输入----------------
 p_institutions_code_o IN STRING, --机构原编码
 p_institutions_code   IN STRING, --机构编码
 p_institutions_name   IN STRING, --机构名称
 p_institutions_type   IN STRING, --机构类型  1 公司  2 代理
 p_institutions_pare   IN STRING, --上级结构
 p_institutions_head   IN NUMBER, --部门负责人
 p_institutions_phone  IN STRING, --部门电话
 p_institutions_emps   IN NUMBER, --部门人数
 p_institutions_adds   IN STRING, --部门地址
 p_institutions_areas  IN STRING, --管辖区域列表,使用“,”分割的多个字符串
 
 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 
 ) IS

  v_count_temp NUMBER := 0; --临时变量
  v_insti_pnum NUMBER := 0; --部门人数

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;
  
  IF ((p_institutions_emps IS NULL) OR length(p_institutions_emps) <= 0) THEN
    v_insti_pnum := 0;
  ELSE
    v_insti_pnum := p_institutions_emps; 
  END IF;

  /*----------- 数据校验   -----------------*/

  --部门原编码不能为空
  IF ((p_institutions_code_o IS NULL) OR length(p_institutions_code_o) <= 0) THEN
    c_errorcode := 5;
    c_errormesg := error_msg.ERR_P_INSTITUTIONS_MODIFY_1;
    RETURN;
  END IF;

  --部门编码不能为空
  IF ((p_institutions_code IS NULL) OR length(p_institutions_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_1;
    RETURN;
  END IF;

  --如果原编码和新编码不一致
  IF (p_institutions_code_o <> p_institutions_code) THEN
  
    v_count_temp := 0;
    --检测原部门下是不是挂有除负责人外的其他人员
    SELECT count(u.admin_id)
      INTO v_count_temp
      FROM adm_info u
     WHERE u.admin_id in
           (select inf_orgs.director_admin
              from inf_orgs
             where inf_orgs.org_code = p_institutions_code_o);
  
    IF v_count_temp > 0 THEN
      c_errorcode := 6;
      c_errormesg := error_msg.ERR_P_INSTITUTIONS_MODIFY_2;
      RETURN;
    END IF;
  
  END IF;

  --部门名称不能为空
  IF ((p_institutions_name IS NULL) OR length(p_institutions_name) <= 0) THEN
    c_errorcode := 2;
    c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_2;
    RETURN;
  END IF;

  --部门负责人不存在
  v_count_temp := 0;

  IF p_institutions_head > 0 THEN
    SELECT count(u.admin_id)
      INTO v_count_temp
      FROM adm_info u
     WHERE u.admin_id = p_institutions_head
       And u.admin_status <> eadmin_status.DELETED;
  
    IF v_count_temp <= 0 THEN
      c_errorcode := 3;
      c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_3;
      RETURN;
    END IF;
  END IF;

  --部门名称不能为空
  IF ((p_institutions_phone IS NULL) OR length(p_institutions_phone) <= 0) THEN
    c_errorcode := 4;
    c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_4;
    RETURN;
  END IF;

  --部门编码重复

  IF (p_institutions_code_o <> p_institutions_code) THEN
    v_count_temp := 0;
  
    SELECT count(u.org_code)
      INTO v_count_temp
      FROM inf_orgs u
     WHERE u.org_code = p_institutions_code;
  
    IF v_count_temp > 0 THEN
      c_errorcode := 5;
      c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_5;
      RETURN;
    END IF;
  END IF;
  
   --检测区域被重复管辖
  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_institutions_areas))) LOOP
    dbms_output.put_line(i.column_value);
  
    IF length(i.column_value) > 0 THEN
        
       v_count_temp := 0;
        SELECT count(*)
          INTO v_count_temp
          FROM inf_org_area u
         WHERE u.area_code = i.column_value
         and u.org_code != p_institutions_code;

        IF v_count_temp > 0 THEN
          c_errorcode := 6;
          c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_6;
          RETURN;
        END IF;
    
    END IF;
  END LOOP;

  --插入基本信息
  update inf_orgs
     set org_code       = p_institutions_code,
         org_name       = p_institutions_name,
         org_type       = p_institutions_type,
         super_org      = p_institutions_pare,
         phone          = p_institutions_phone,
         director_admin = p_institutions_head,
         persons        = p_institutions_emps,
         address        = p_institutions_adds
   where org_code = p_institutions_code_o;

  --循环插入管辖区域
  --先清理原有数据
  delete from inf_org_area
   where inf_org_area.org_code = p_institutions_code
      or inf_org_area.org_code = p_institutions_code_o;

  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_institutions_areas))) LOOP
    dbms_output.put_line(i.column_value);
  
    IF length(i.column_value) > 0 THEN
    
      insert into inf_org_area
        (org_code, area_code)
      values
        (p_institutions_code, i.column_value);
    
    END IF;
  END LOOP;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END p_institutions_modify;
/
 
/ 
prompt 正在建立[PROCEDURE -> p_institutions_topup.sql ]...... 
CREATE OR REPLACE PROCEDURE p_institutions_topup
/****************************************************************/
   ------------------- 适用于机构充值-------------------
   ----机构充值
   ----add by dzg: 2015-9-25
   ----业务流程：插入申请表，插入流水，更新账户
   --- POS:outletCode  amount  admin transPassword（市场管理员）
   --- OMS 参数相同
   ----需要调用陈震存储过程
   /*************************************************************/
(
 --------------输入----------------

 p_org_code IN STRING, --机构编码
 p_amount   IN NUMBER, --充值金额
 p_admin_id IN NUMBER, --操作人员

 ---------出口参数---------
 c_flow_code  OUT STRING, --申请流水
 c_bef_amount OUT NUMBER, --充值前金额
 c_aft_amount OUT NUMBER, --充值后金额
 c_errorcode  OUT NUMBER, --错误编码
 c_errormesg  OUT STRING --错误原因

 ) IS

   v_count_temp NUMBER := 0; --临时变量
   v_org_name   varchar2(500) := ''; --站点名称
   v_org_accno  varchar2(50) := ''; --站点账户编号

BEGIN

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   v_count_temp := 0;

   /*----------- 数据校验   -----------------*/
   --编码不能为空
   IF ((p_org_code IS NULL) OR length(p_org_code) <= 0) THEN
      c_errorcode := 1;
      c_errormesg := error_msg.err_p_institutions_topup_1;
      RETURN;
   END IF;

   --用户不存在或者无效
   SELECT count(u.admin_id)
     INTO v_count_temp
     FROM adm_info u
    WHERE u.admin_id = p_admin_id
      And u.admin_status <> eadmin_status.DELETED;

   IF v_count_temp <= 0 THEN
      c_errorcode := 2;
      c_errormesg := error_msg.err_p_institutions_topup_2;
      RETURN;
   END IF;

   --密码无效
   v_count_temp := 0;
   SELECT count(u.org_code)
     INTO v_count_temp
     FROM inf_orgs u
    WHERE u.org_code = p_org_code;

   IF v_count_temp <= 0 THEN
      c_errorcode := 3;
      c_errormesg := error_msg.err_p_institutions_topup_3;
      RETURN;
   END IF;

   --初始化

   select a.org_name, b.acc_no
     INTO v_org_name, v_org_accno
     from inf_orgs a
     left join acc_org_account b
       on a.org_code = b.org_code
    where a.org_code = p_org_code;

   --先生成编码
   c_flow_code := f_get_fund_charge_cash_seq();

   --插入资金流水相关信息
   p_org_fund_change(p_org_code,
                     eflow_type.charge,
                     p_amount,
                     0,
                     c_flow_code,
                     c_aft_amount,
                     v_count_temp);

   -- 计算之前金额
   c_bef_amount := c_aft_amount - p_amount;

   insert into fund_charge_center
      (fund_no,
       account_type,
       ao_code,
       ao_name,
       acc_no,
       OPER_AMOUNT,
       BE_ACCOUNT_BALANCE,
       AF_ACCOUNT_BALANCE,
       OPER_TIME,
       OPER_ADMIN)
   values
      (c_flow_code,
       eaccount_type.org,
       p_org_code,
       v_org_name,
       v_org_accno,
       p_amount,
       c_bef_amount,
       c_aft_amount,
       sysdate,
       p_admin_id);

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      c_errorcode := 1;
      c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_item_check_step1.sql ]...... 
CREATE OR REPLACE PROCEDURE p_item_check_step1
/****************************************************************/
  ------------------- 适用于仓库物品盘点-------------------
  ----第一步：新建盘点单
  ----add by dzg: 2015-10-13
  ----业务流程：当仓库正在盘点时，不能盘点，盘点时生成当前库房实际量
  ----如果不选任何物品，则默认盘点所有
  ----数据库定义序号生成函数修订
  ----增加逻辑修改仓库正在盘点中
  ----modify by dzg :2015-11-22 物品盘点删除更新仓库状态，因为和彩票冲突
  /*************************************************************/
(
 --------------输入----------------
 p_warehouse_opr  IN NUMBER, --盘点人
 p_check_name     IN STRING, --盘点名称
 p_warehouse_code IN STRING, --库房编码
 p_item_codes     IN STRING, --盘点物品列表，以“,"分割
 
 ---------出口参数---------
 c_check_code OUT STRING, --返回盘点单编号
 c_errorcode  OUT NUMBER, --错误编码
 c_errormesg  OUT STRING --错误原因
 
 ) IS

  v_count_temp NUMBER := 0; --临时变量
  v_count_tick NUMBER := 0; --存放临时库存总量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --名称不能为空
  IF ((p_check_name IS NULL) OR length(p_check_name) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_warehouse_check_step1_1;
    RETURN;
  END IF;

  --库房不能为空
  IF ((p_warehouse_code IS NULL) OR length(p_warehouse_code) <= 0) THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_warehouse_check_step1_2;
    RETURN;
  END IF;

  --盘点人无效
  v_count_temp := 0;
  SELECT count(o.admin_id)
    INTO v_count_temp
    FROM adm_info o
   WHERE o.admin_id = p_warehouse_opr
     AND o.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 3;
    c_errormesg := error_msg.err_p_warehouse_check_step1_3;
    RETURN;
  END IF;

  --仓库无效或者正在盘点中
  v_count_temp := 0;
  SELECT count(o.warehouse_code)
    INTO v_count_temp
    FROM wh_info o
   WHERE o.warehouse_code = p_warehouse_code;
    -- AND o.status = ewarehouse_status.working;

  IF v_count_temp <= 0 THEN
    c_errorcode := 4;
    c_errormesg := error_msg.err_p_warehouse_check_step1_4;
    RETURN;
  END IF;

  --如果没有物品列表，则默认盘点所有

  /*----------- 插入数据  -----------------*/
  --插入基本信息
  c_check_code := f_get_item_ic_no_seq();

  insert into item_check
    (check_no,
     check_name,
     check_date,
     check_admin,
     check_warehouse,
     status,
     remark)
  values
    (c_check_code,
     p_check_name,
     sysdate,
     p_warehouse_opr,
     p_warehouse_code,
     ecp_status.working,
     '');
     
   --更新仓库状态
   
   --update wh_info set wh_info.status = ewarehouse_status.checking
   -- where wh_info.warehouse_code = p_warehouse_code;

  --插入盘点前记录
  IF ((p_item_codes IS NULL) OR length(p_item_codes) < 0) THEN
  
    insert into item_check_detail_be
      select c_check_code, q.item_code, q.quantity
        from item_quantity q
       where q.warehouse_code = p_warehouse_code;
  
  ELSE
    FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_item_codes))) LOOP
      dbms_output.put_line(i.column_value);
    
      IF length(i.column_value) > 0 THEN
      
        insert into item_check_detail_be
          select c_check_code, q.item_code, q.quantity
            from item_quantity q
           where q.warehouse_code = p_warehouse_code
             and q.item_code = i.column_value;
      
      END IF;
      
    END LOOP;
  
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END;
 
/ 
prompt 正在建立[PROCEDURE -> p_item_check_step2.sql ]...... 
CREATE OR REPLACE PROCEDURE p_item_check_step2
/****************************************************************/
  ------------------- 适用于仓库物品盘点-------------------
  ----第二步：继续盘点 或者 盘点完成
  ----add by dzg: 2015-10-13
  ----业务流程：根据操作状态来定义是否盘点完成，还是继续盘点
  ----modify by dzg :2015-10-26 增加remark 待处理陈震修改完表结构后继续....
  ----更新完毕后重置仓库状态
  /*************************************************************/
(
 --------------输入----------------
 p_warehouse_opr  IN NUMBER, --盘点人
 p_check_code     IN STRING, --盘点单编号
 p_warehouse_code IN STRING, --库房编码
 p_check_opr      IN NUMBER, --盘点操作 ：1 保存  2 保存且完成
 p_remark         IN STRING, --盘点结果备注
 p_items          IN type_item_list, -- 入库的物品对象
 
 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 
 ) IS

  v_count_temp  NUMBER := 0; --临时变量,用于存放盘点前数量
  v_count_temp1 NUMBER := 0; --临时变量,用于存放盘点结果
  v_item        type_item_info; --循环变量的当前值
BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --编码不能为空
  IF ((p_check_code IS NULL) OR length(p_check_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_warehouse_check_step2_1;
    RETURN;
  END IF;

  --编码无效
  v_count_temp := 0;
  SELECT count(o.check_no)
    INTO v_count_temp
    FROM item_check o
   WHERE o.check_no = p_check_code
     AND o.status <> ecp_status.done;

  IF v_count_temp <= 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_warehouse_check_step2_2;
    RETURN;
  END IF;

  --遍历p_items插入盘点后的数据，将采用覆盖式，先删除后插入方式

  for i in 1 .. p_items.count loop
    v_item := p_items(i);
  
    v_count_temp  := 0;
    v_count_temp1 := ecp_result.same;
  
    select be.quantity
      into v_count_temp
      from item_check_detail_be be
     where be.check_no = p_check_code
       and be.item_code = v_item.item_code;
  
    IF (v_count_temp > v_item.quantity) THEN
      v_count_temp1 := ecp_result.less;
    ELSIF (v_count_temp < v_item.quantity) THEN
      v_count_temp1 := ecp_result.more;
    END IF;
  
    delete from item_check_detail_af
     where check_no = p_check_code
       and item_code = v_item.item_code;
  
    insert into item_check_detail_af
      (check_no, item_code, quantity, change_quantity, result)
    values
      (p_check_code,
       v_item.item_code,
       v_item.quantity,
       v_item.quantity - v_count_temp,
       v_count_temp1);
  end loop;
  
  --更新盘点结果备注
  update item_check
     set remark = p_remark
   where check_no = p_check_code;

  --完成则更新状态
  IF ((p_check_opr IS NOT NULL) AND (p_check_opr = 2)) THEN
    
    update item_check
       set status = ecp_status.done
     where check_no = p_check_code;
  
    --更新仓库状态 
    update wh_info
       set wh_info.status = ewarehouse_status.working
     where wh_info.warehouse_code = p_warehouse_code;
  
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END;
 
/ 
prompt 正在建立[PROCEDURE -> p_item_damage_register.sql ]...... 
create or replace procedure p_item_damage_register
/****************************************************************/
--Desc:
--Call to register a damaged item

--Log:
--Added by Wang Qingxiang @2015-11-06

--Proc
--1. Deny when p_item_code is null or empty string;
--2. Deny when p_warehouse_code is null or empty string;
--3. Deny when p_quantity is not positive;
--4. Deny when p_check_admin does not exist in ADM_INFO;
--5. Deny when p_item_code does not have a valid record in ITEM_ITEMS;
--6. Deny when p_warehouse_code does not have a valid record in WH_INFO;
--7. Deny when p_item_code does not exist in p_warehouse_code;
--8. Deny when quantity of p_item_code in p_warehouse_code is less than input quantity;
--9. insert a record into ITEM_DAMAGE;
--10. update quantity in ITEM_QUANTITY;
--11. Rollback when exception occurs.
/****************************************************************/
(
--input params
  p_item_code         in string,    --item to be register
  p_warehouse_code    in string,    --warehouse where the item is registered
  p_quantity          in number,    --damage quantity of the item
  p_check_admin       in number,    --registration operator
  p_remark            in string,    --remark
--output params
  c_errorcode         out number,   --error code
  c_errormesg         out string,   --error message
  c_id_no             out string    --item check code
) is

  v_count number := 0;
  v_quantity number := 0;

begin

  --initializing data
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count := 0;
  v_quantity := 0;
  
  --step 1: p_item_code is null or empty string
  if ((p_item_code is null) or length(p_item_code) <= 0) then
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_item_damage_1;
    return;
  end if;
  
  --step 2: p_warehouse_code is null or empty string
  if ((p_warehouse_code is null) or length(p_warehouse_code) <= 0) then
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_item_damage_2;
    return;
  end if;
  
  --step 3: p_quantity is not positive
  if (p_quantity <= 0) then
    c_errorcode := 3;
    c_errormesg := error_msg.err_p_item_damage_3;
    return;
  end if;
  
  --step 4: p_check_admin does not exist in ADM_INFO
  if not f_check_admin(p_check_admin) then
    c_errorcode := 4;
    c_errormesg := error_msg.err_p_item_damage_4;
    return;
  end if;
  
  --step 5: p_item_code does not have a valid record in ITEM_ITEMS
  v_count := 0;
  select count(item_code)
    into v_count
    from ITEM_ITEMS
   where item_code = p_item_code
     and status = 1;
  
  if v_count = 0 then
    c_errorcode := 5;
    c_errormesg := error_msg.err_p_item_damage_5;
    return;
  end if;
  
  --step 6: p_warehouse_code does not have a valid record in WH_INFO
  v_count := 0;
  select count(warehouse_code)
    into v_count
    from WH_INFO
   where warehouse_code = p_warehouse_code
     and (status = 1 or status = 3);
  
  if v_count = 0 then
    c_errorcode := 6;
    c_errormesg := error_msg.err_p_item_damage_6;
    return;
  end if;
  
  --step 7: p_item_code does not exist in p_warehouse_code
  v_count := 0;
  select count(item_code)
    into v_count
    from ITEM_QUANTITY
   where item_code = p_item_code
     and warehouse_code = p_warehouse_code;
  
  if v_count = 0 then
    c_errorcode := 7;
    c_errormesg := error_msg.err_p_item_damage_7;
    return;
  end if;
  
  --step 8: quantity of p_item_code in p_warehouse_code is less than input quantity
  v_quantity := 0;
  select quantity
    into v_quantity
    from ITEM_QUANTITY
   where item_code = p_item_code
     and warehouse_code = p_warehouse_code;
  
  if v_quantity < p_quantity then
    c_errorcode := 8;
    c_errormesg := error_msg.err_p_item_damage_8;
    return;
  end if;
  
  --step 9: insert a record into ITEM_DAMAGE
  c_id_no := f_get_item_id_no_seq();
  
  insert into ITEM_DAMAGE
    (ID_NO,
     DAMAGE_DATE,
     ITEM_CODE,
     QUANTITY,
     CHECK_ADMIN,
     REMARK,
     WAREHOUSE_CODE)
  values
    (c_id_no,
     sysdate,
     p_item_code,
     p_quantity,
     p_check_admin,
     p_remark,
     p_warehouse_code);
  
  --step 10: update quantity in ITEM_QUANTITY
  update ITEM_QUANTITY
     set quantity = quantity - p_quantity
   where item_code = p_item_code
     and warehouse_code = p_warehouse_code;
  
  commit;

exception
  when others then
    rollback;
    c_errorcode := 100;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

end p_item_damage_register; 
/ 
prompt 正在建立[PROCEDURE -> p_item_delete.sql ]...... 
create or replace procedure p_item_delete
/****************************************************************/
--Desc:
--Call to delete an item

--Log:
--Added by Wang Qingxiang @2015-10-13

--Proc:
--1. Deny when p_item_code is null or empty string;
--2. Deny when p_item_code's item does not exist in ITEM_ITEMS;
--3. Deny when p_item_code's item exists in ITEM_QUANTITY;
--4. Delete p_item_code from ITEM_QUANTITY if it has '0' quantity in the table;
--5. Change p_item_code's status to 2 (deleted);
--6. Rollback when exception occurs.
/****************************************************************/
(
--input params
  p_item_code in string,    --item code to be deleted

--output params
  c_errorcode out number,   --error code
  c_errormesg out string    --error message
) is

  v_count_temp number := 0; --temp variable

begin

  --initializing data
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  --step 1: p_item_code is null or empty string
  if ((p_item_code is null) or length(p_item_code) <= 0) then
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_item_delete_1;
    return;
  end if;

  --step 2: p_item_code's item does not exist in ITEM_ITEMS
  v_count_temp := 0;
  select count(item_code)
    into v_count_temp
    from ITEM_ITEMS
   where item_code = p_item_code;

  if v_count_temp = 0 then
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_item_delete_2;
    return;
  end if;

  --step 3: p_item_code's item exists in ITEM_QUANTITY
  v_count_temp := 0;
  select count(1)
    into v_count_temp
    from dual
   where
    exists(
      select 1
        from ITEM_QUANTITY
       where item_code = p_item_code
         and QUANTITY > 0
    );

  if v_count_temp > 0 then
    c_errorcode := 3;
    c_errormesg := error_msg.err_p_item_delete_3;
    return;
  end if;
  
  --step 4: Delete p_item_code from ITEM_QUANTITY if it has '0' quantity in the table
  delete from item_quantity
  where item_code = p_item_code
    and quantity = 0;

  --step 5: Change p_item_code's status to 2 (deleted)
  update ITEM_ITEMS
     set status = 2
   where item_code = p_item_code;

  commit;

exception
  when others then
    rollback;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

end p_item_delete;
 
/ 
prompt 正在建立[PROCEDURE -> p_item_inbound.sql ]...... 
create or replace procedure p_item_inbound
/****************************************************************/
   ------------------- 物品入库 -------------------
   ---- 用于物品入库。
   ---- create by 陈震 @ 2015/10/13
   ---- in param 'p_remark' added by WangQingxiang on 2015-12-31
   /*************************************************************/
(
 --------------输入----------------
   p_oper              in number,              -- 操作人
   p_warehouse         in char,                -- 入库仓库
   p_items             in type_item_list,      -- 入库的物品对象
   p_remark            in string,              -- remark

 ---------出口参数---------
   c_ir_no     out string,                     -- 物品入库单编号
   c_errorcode out number,                     -- 错误编码
   c_errormesg out string                      -- 错误原因

 ) is

   v_wh_org                char(2);                                        -- 仓库所在部门
   v_ir_no                 char(10);                                       -- 入库单编号

   v_list_count            number(10);                                     -- 入库明细总数

   type type_detail        is table of item_receipt_detail%rowtype;
   v_insert_detail         type_detail;                                    -- 插入入库明细的数组

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   v_insert_detail := new type_detail();

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;

   -- 检查此仓库是否存在
   if not f_check_warehouse(p_warehouse) then
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_warehouse) || error_msg.err_common_101; -- 无此仓库
      return;
   end if;

   -- 查询仓库所属部门
   select org_code
     into v_wh_org
     from wh_info
    where warehouse_code = p_warehouse;

   -- 记录物品入库和明细
   insert into item_receipt (ir_no,                create_admin, receive_org, receive_wh,  receive_date, remark)
                     values (f_get_item_ir_no_seq, p_oper,       v_wh_org,    p_warehouse, sysdate,      p_remark)
                  returning ir_no
                  into      v_ir_no;

   for v_list_count in 1 .. p_items.count loop
      v_insert_detail.extend;
      v_insert_detail(v_insert_detail.count).ir_no := v_ir_no;
      v_insert_detail(v_insert_detail.count).item_code := p_items(v_list_count).item_code;
      v_insert_detail(v_insert_detail.count).quantity := p_items(v_list_count).quantity;
   end loop;

   forall v_list_count in 1 .. v_insert_detail.count
      insert into item_receipt_detail values v_insert_detail(v_list_count);

   /****************/
   /* 修改物品库存 */
   -- 查找库存中，是否存在此种物品，如果没有，就增加；如果有，增加库存
   forall v_list_count in 1 .. p_items.count
      merge into item_quantity dest
      using (select p_items(v_list_count).item_code item_code, p_warehouse warehouse_code from dual) src
         on (dest.item_code = src.item_code and dest.warehouse_code = src.warehouse_code)
       when matched then
          update set dest.quantity = dest.quantity + p_items(v_list_count).quantity
       when not matched then
          insert values (p_items(v_list_count).item_code, p_warehouse   , (select item_name from item_items where item_code = p_items(v_list_count).item_code), p_items(v_list_count).quantity);

   c_ir_no := v_ir_no;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;


 
/ 
prompt 正在建立[PROCEDURE -> p_item_outbound.sql ]...... 
create or replace procedure p_item_outbound
/****************************************************************/
   ------------------- 物品出库 -------------------
   ---- 用于物品出库。
   ---- create by 陈震 @ 2015/10/13
   ---- in param 'p_remark' added by WangQingxiang on 2015-12-31
   /*************************************************************/
(
 --------------输入----------------
   p_oper              in number,              -- 操作人
   p_warehouse         in char,                -- 出库仓库
   p_receive_org       in char,                -- 收货单位
   p_items             in type_item_list,      -- 出库的物品对象
   p_remark            in string,              -- remark

 ---------出口参数---------
   c_ii_no     out string,                     -- 物品出库单编号
   c_errorcode out number,                     -- 错误编码
   c_errormesg out string                      -- 错误原因

 ) is

   v_wh_org                char(2);                                        -- 仓库所在部门
   v_ii_no                 char(10);                                       -- 出库单编号
   v_quantity              number(18);                                     -- 库存数量
   v_count                 number(18);                                     -- 计数器

   v_list_count            number(10);                                     -- 出库明细总数

   type type_detail        is table of ITEM_ISSUE_DETAIL%rowtype;
   v_insert_detail         type_detail;                                    -- 插入出库明细的数组

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   v_insert_detail := new type_detail();

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;

   -- 检查此仓库是否存在
   if not f_check_warehouse(p_warehouse) then
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_warehouse) || error_msg.err_common_101; -- 无此仓库
      return;
   end if;

   -- 检查机构是否存在
   if not f_check_org(p_receive_org) then
      c_errorcode := 3;
      c_errormesg := dbtool.format_line(p_receive_org) || error_msg.err_p_institutions_topup_3; -- 无此机构
      return;
   end if;


   -- 查询仓库所属部门
   select org_code
     into v_wh_org
     from wh_info
    where warehouse_code = p_warehouse;

   -- 记录物品出库和明细
   insert into ITEM_ISSUE (II_NO,                OPER_ADMIN, ISSUE_DATE, RECEIVE_ORG,   SEND_ORG, SEND_WH,     REMARK)
                   values (f_get_item_ii_no_seq, p_oper,     sysdate,    p_receive_org, v_wh_org, p_warehouse, p_remark)
                returning ii_no
                into      v_ii_no;

   for v_list_count in 1 .. p_items.count loop
      v_insert_detail.extend;
      v_insert_detail(v_insert_detail.count).ii_no := v_ii_no;
      v_insert_detail(v_insert_detail.count).item_code := p_items(v_list_count).item_code;
      v_insert_detail(v_insert_detail.count).quantity := p_items(v_list_count).quantity;
   end loop;

   forall v_list_count in 1 .. v_insert_detail.count
      insert into ITEM_ISSUE_DETAIL values v_insert_detail(v_list_count);

   /****************/
   /* 修改物品库存 */
   -- 查找库存中，是否存在此种物品，如果没有，就报错；如果有，减少库存
   for v_list_count in 1 .. p_items.count loop
      select count(*)
        into v_count
        from item_quantity
       where ITEM_CODE = p_items(v_list_count).item_code;
      if v_count = 0 then
         rollback;
         c_errorcode := 4;
         c_errormesg := dbtool.format_line(p_items(v_list_count).item_code) || error_msg.err_p_item_delete_2; -- 不存在此物品
         return;
      end if;

      select count(*)
        into v_count
        from item_quantity
       where ITEM_CODE = p_items(v_list_count).item_code
         and WAREHOUSE_CODE = p_warehouse;
      if v_count = 0 then
         rollback;
         c_errorcode := 5;
         c_errormesg := dbtool.format_line(p_items(v_list_count).item_code) || dbtool.format_line(p_warehouse) || error_msg.err_p_item_outbound_1; -- 仓库中无此物品
         return;
      end if;

      update item_quantity
         set quantity = quantity - p_items(v_list_count).quantity
       where item_code = p_items(v_list_count).item_code
         and WAREHOUSE_CODE = p_warehouse
      returning quantity
            into v_quantity;
      if v_quantity < 0 then
         rollback;
         c_errorcode := 6;
         c_errormesg := dbtool.format_line(p_items(v_list_count).item_code) || dbtool.format_line(p_warehouse) || error_msg.err_p_item_outbound_2; -- 仓库中此物品数量不足
         return;
      end if;

   end loop;

   c_ii_no := v_ii_no;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;


 
/ 
prompt 正在建立[PROCEDURE -> p_lottery_reward.sql ]...... 
create or replace procedure p_lottery_reward
/****************************************************************/
   ------------------- 兑奖 -------------------
   ---- 兑奖
   ----     判断此张彩票是否已经销售，没有的话，就不能兑奖；
   ----     查询兑奖记录，判断此张彩票是否已经进行过兑奖，如果已经兑奖，返回失败；
   ----     更新“2.1.4.7 批次信息导入之中奖明细（game_batch_reward_detail）”，更新“2.1.4.6 批次信息导入之奖符（game_batch_import_reward）”，计数器+1；
   ----     获取此彩票的彩票包装信息和奖组，以及此彩票的中奖金额，还有彩票的销售站点；
   ----     新建“兑奖记录”，如果兑奖方式为“1=中心兑奖，2=手工兑奖”时，还需要新建“2.1.7.1 gui兑奖信息记录表（flow_gui_pay）”
   ----     如果是“站点兑奖”，那么，按照单票金额计算兑奖代销费，给兑奖站点加“兑奖金额”和“兑奖佣金”；如果是“中心兑奖”，那么要视系统参数（2），决定是否给销售彩票的销售站增加“兑奖佣金”；


   ---- add by 陈震: 2015/9/21
   ---- 涉及的业务表：
   ----     2.1.4.6 批次信息导入之奖符（game_batch_import_reward）                     -- 更新
   ----     2.1.4.7 批次信息导入之中奖明细（game_batch_reward_detail）                 -- 更新
   ----     2.1.7.1 gui兑奖信息记录表（flow_gui_pay）                                  -- 新增
   ----     2.1.7.2 兑奖记录（flow_pay）                                               -- 新增
   ----     2.1.7.4 站点资金流水（flow_agency）                                        -- 新增

   ---- 业务流程：
   ----     1、校验输入参数。（仓库是否存在；操作类型是否为新、继续、完结；操作人是否合法；）
   ----     2、判断此张彩票是否已经销售，没有的话，就不能兑奖；
   ----     3、查询兑奖记录，判断此张彩票是否已经进行过兑奖，如果已经兑奖，返回失败；
   ----     4、更新

   ---- modify by 陈震 2016-01-22
   ---- 1、增加兑奖机构佣金表，保存兑奖时，产生的机构佣金数据
   ---- 2、站点兑奖和一级机构兑奖，无条件加佣金，总机构不计算佣金
   ---- 3、是否产生兑奖佣金，要看系统参数 16 是否计算分公司中心兑奖佣金（1=计算，2=不计算）；针对代理商的销售站，必须产生机构佣金记录

   ---- modify by 陈震 2016-02-26
   ---- 1、增加印制厂商判断。当方案为石家庄时，录入的安全码为全部安全码，可以直接在数据库中查询；如果方案为中彩三场，那么录入的安全码只获取前16位，然后查询其中奖标示，获取奖等。

   /*************************************************************/
(
  --------------输入----------------
  p_security_string                    in char,                               -- 保安区码（21位）
  p_name                               in char,                               -- 中奖人姓名
  p_contact                            in char,                               -- 中奖人联系方式
  p_id                                 in char,                               -- 中奖人证件号码
  p_age                                in number,                             -- 年龄
  p_sex                                in number,                             -- 性别(1-男，2-女)
  p_paid_type                          in number,                             -- 兑奖方式（1=中心兑奖，2=手工兑奖，3=站点兑奖）
  p_plan                               in char,                               -- 方案编号
  p_batch                              in char,                               -- 批次编号
  p_package_no                         in varchar2,                           -- 彩票本号
  p_ticket_no                          in varchar2,                           -- 票号
  p_oper                               in number,                             -- 操作人
  p_pay_agency                         in char,                               -- 兑奖销售站
  p_pay_time                           in date,                               -- 兑奖时间

  ---------出口参数---------
  c_reward_amount                      out number,                           -- 兑奖金额
  c_pay_flow                           out char,                             -- 兑奖序号
  c_errorcode                          out number,                           -- 错误编码
  c_errormesg                          out string                            -- 错误原因

 ) is

   v_count                 number(5);                                      -- 求记录数的临时变量
   v_agency                char(8);                                        -- 售票销售站

   v_reward_amount         number(18);                                     -- 奖金
   v_reward_level          number(2);                                      -- 奖级
   v_pay_flow              char(24);                                       -- 兑奖流水号

   v_comm_amount           number(18);                                     -- 彩票销售，销售站兑奖佣金
   v_comm_rate             number(18);                                     -- 彩票销售，销售站兑奖佣金比例

   v_single_ticket_amount  number(10);                                     -- 单票金额
   v_lottery_detail        type_lottery_info;                              -- 彩票对象详细信息

   v_area_code             char(4);                                        -- 站点所属区域
   v_admin_realname        varchar2(1000);                                 -- 操作人员名称

   v_sys_param             varchar2(10);                                   -- 系统参数值

   v_balance               number(28);                                     -- 账户余额
   v_f_balance             number(28);                                     -- 冻结账户余额

   v_pay_time              date;                                           -- 兑奖时间
   v_is_new_ticket         number(1);                                      -- 是否新票

   v_org                   char(2);                                        -- 组织结构代码
   v_org_type              number(2);                                      -- 组织机构类型

   v_security_string       varchar2(50);                                   -- 安全区码

   v_publisher             number(2);                                      -- 印制厂商

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   c_reward_amount := 0;
   v_is_new_ticket := eboolean.noordisabled;

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;

   -- 如果是“爱心方案”，按照系统参数判断是否可用
   if p_plan = 'J2014' and f_get_sys_param(15) <> '1' then
      c_errorcode := 3;
      c_errormesg := dbtool.format_line(p_plan) || dbtool.format_line('00001') || error_msg.err_p_ticket_perferm_5; -- 此批次的彩票方案已经停用
      return;
   end if;

   -- 如果是新票，那么需要检查以下数据
   if f_get_reward_ticket_ver(p_plan, p_batch, p_package_no) = 0 then

      -- 检查批次是否正确
      if not f_check_plan_batch(p_plan, p_batch) then
         c_errorcode := 2;
         c_errormesg := dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || error_msg.err_common_102; -- 无此方案和批次
         return;
      end if;

      -- 检查方案批次是否有效
      if not f_check_plan_batch_status(p_plan, p_batch) then
         c_errorcode := 3;
         c_errormesg := dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || error_msg.err_p_ticket_perferm_5; -- 此批次的彩票方案已经停用
         return;
      end if;

      v_is_new_ticket := eboolean.yesorenabled;

   end if;
   /*----------- 业务逻辑   -----------------*/
   -- 设置默认的兑奖时间
   if p_pay_time is null then
      v_pay_time := sysdate;
   else
      v_pay_time := p_pay_time;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* 判断此张彩票是否已经销售，没有的话，就不能兑奖 *************************/

   -- 获取彩票详细信息
   if v_is_new_ticket = eboolean.yesorenabled then
      v_lottery_detail := f_get_lottery_info(p_plan, p_batch, evalid_number.pack, p_package_no);
   else
      -- 针对旧票，数据统一填写“-”
      v_lottery_detail := type_lottery_info(p_plan, p_batch, evalid_number.pack, '-', '-', '-', p_package_no, p_package_no, 0);
   end if;

   -- 如果是新票，那么需要检查以下数据
   if v_is_new_ticket = eboolean.yesorenabled then

      -- 判断彩票是否销售
      begin
         select current_warehouse
           into v_agency
           from wh_ticket_package
          where plan_code = p_plan
            and batch_no = p_batch
            and package_no = p_package_no
            and p_ticket_no >= ticket_no_start
            and p_ticket_no <= ticket_no_end
            and status = eticket_status.saled;
      exception
         when no_data_found then
            c_errorcode := 4;
            c_errormesg := dbtool.format_line(p_package_no) || error_msg.err_p_lottery_reward_3;                       -- 彩票未被销售
            return;
      end;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* 查询兑奖记录，判断此张彩票是否已经进行过兑奖，如果已经兑奖，返回失败 *************************/
   select count(*)
     into v_count
     from flow_pay
    where plan_code = p_plan
      and batch_no = p_batch
      and security_code = p_security_string;
   if v_count = 1 then
      c_errorcode := 5;
      c_errormesg := dbtool.format_line(p_ticket_no) || error_msg.err_p_lottery_reward_4;                       -- 彩票已兑奖
      return;
   end if;

   /********************************************************************************************************************************************************************/
   if f_get_reward_ticket_ver(p_plan, p_batch, p_package_no) = 1 then
      v_publisher := epublisher_code.sjz;
   else
      v_publisher := f_get_plan_publisher(p_plan);
   end if;

   case v_publisher
      when epublisher_code.sjz then
         -- 更新计数器和标志
         update game_batch_reward_detail
            set is_paid = eboolean.yesorenabled
          where plan_code = p_plan
            and batch_no = p_batch
            and safe_code = p_security_string;

         -- 获取奖级和奖金
         select single_reward_amount, reward_no
           into v_reward_amount, v_reward_level
           from game_batch_import_reward
          where plan_code = p_plan
            and batch_no = p_batch
            and instr(fast_identity_code, substr(p_security_string, epublisher_sjz.fast_identity_code_pos, epublisher_sjz.len_fast_identity_code)) > 0;

      when epublisher_code.zc3c then
         -- 更新计数器和标志
         update game_batch_reward_detail
            set is_paid = eboolean.yesorenabled
          where plan_code = p_plan
            and batch_no = p_batch
            and pre_safe_code = substr(p_security_string, 1, 16)
         returning safe_code into v_security_string;

         -- 获取奖级和奖金
         select single_reward_amount, reward_no
           into v_reward_amount, v_reward_level
           from game_batch_import_reward
          where plan_code = p_plan
            and batch_no = p_batch
            and instr(fast_identity_code, substr(v_security_string, epublisher_sjz.fast_identity_code_pos, epublisher_sjz.len_fast_identity_code)) > 0;

   end case;




   /********************************************************************************************************************************************************************/
   /******************* 进入数据计算 *************************/
   -- 获取单票金额
   begin
      select ticket_amount
        into v_single_ticket_amount
        from game_plans
       where plan_code = p_plan;
   exception
      when no_data_found then
         v_single_ticket_amount := 0;
   end;

   -- 获取操作人员名字
   begin
      select admin_realname into v_admin_realname from adm_info where admin_id = p_oper;
   exception
      when no_data_found then
         v_admin_realname := '';
   end;

   -- 获取系统参数2（中心兑奖，代销费属于“1-销售站点，2-不计算”）
   v_sys_param := f_get_sys_param(2);
   if v_sys_param not in ('1', '2') then
      rollback;
      c_errorcode := 6;
      c_errormesg := dbtool.format_line(v_agency) || dbtool.format_line(p_plan) || error_msg.err_p_lottery_reward_5; -- 系统参数值不正确，请联系管理员，重新设置
      return;
   end if;

   -- 中心兑奖不需要销售站
   if p_paid_type <> 1 then
      -- 获取站点的兑奖佣金比例
      v_comm_rate := f_get_agency_comm_rate(p_pay_agency, p_plan, p_batch, 2);
      if v_comm_rate = -1 then
         rollback;
         c_errorcode := 7;
         c_errormesg := dbtool.format_line(p_pay_agency) || dbtool.format_line(p_plan) || error_msg.err_p_lottery_reward_6; -- 该销售站未设置此方案对应的兑奖佣金比例
         return;
      end if;
   end if;

   case p_paid_type
      when 3 then                                                       -- 销售站兑奖
         -- 计算兑奖代销费
         v_comm_amount := trunc(v_reward_amount * v_comm_rate / 1000);

         -- 获取销售站对应的区域码
         select area_code into v_area_code from inf_agencys where agency_code = p_pay_agency;

         -- 建立兑奖记录
         insert into flow_pay
           (pay_flow,                  pay_agency,              area_code,                      pay_comm,       pay_comm_rate,
            plan_code,                 batch_no,                reward_group,
            trunk_no,                  box_no,                  package_no,                     ticket_no,      security_code,
            pay_amount,                lottery_amount,          pay_time,                       is_center_paid,
            comm_amount,               comm_rate,               reward_no)
         values
           (f_get_flow_pay_seq,        p_pay_agency,            v_area_code,                    v_comm_amount,  v_comm_rate,
            p_plan,                    p_batch,                 v_lottery_detail.reward_group,
            v_lottery_detail.trunk_no, v_lottery_detail.box_no, p_package_no,                   p_ticket_no,    p_security_string,
            v_reward_amount,           v_single_ticket_amount,  v_pay_time,                     p_paid_type,
            v_comm_amount,             v_comm_rate,             v_reward_level)
         returning
            pay_flow
         into
            v_pay_flow;

         -- 给兑奖销售站加“奖金”和“兑奖代销费”
         p_agency_fund_change(p_pay_agency, eflow_type.paid, v_reward_amount, 0, v_pay_flow, v_balance, v_balance);
         p_agency_fund_change(p_pay_agency, eflow_type.pay_comm, v_comm_amount, 0, v_pay_flow, v_balance, v_f_balance);


         -- add @ 2016-01-22 by 陈震
         -- 机构佣金记录
         /** 机构所属销售站兑奖，需要按照兑奖销售站所属机构级别来计算是否给机构佣金  **/
         /** 对于机构类型是总机构的，一概不给于任何佣金和奖金                        **/
         /** 对于机构类型是分公司的，按照系统参数（16）确定是否给于佣金和奖金        **/
         /** 对于机构类型是代理商的，需要给于佣金和奖金                              **/
         v_org := f_get_flow_pay_org(v_pay_flow);
         v_org_type := f_get_org_type(v_org);
         if (v_org_type <> '00' and v_org_type = eorg_type.company and f_get_sys_param(16) = '1') or (v_org_type = eorg_type.agent) then

            v_comm_rate := f_get_org_comm_rate(v_org, p_plan, p_batch, 2);

            if v_comm_rate = -1 then
               v_comm_rate := 0;
            end if;

            v_comm_amount := v_reward_amount * v_comm_rate / 1000;

            insert into flow_pay_org_comm
              (pay_flow,                  pay_agency,              area_code,
               org_code,                  org_type,                org_pay_comm,                   org_pay_comm_rate,
               plan_code,                 batch_no,                reward_group,                   reward_no,
               trunk_no,                  box_no,                  package_no,                     ticket_no,           security_code,
               pay_amount,                lottery_amount,          pay_time,                       is_center_paid)
            values
              (v_pay_flow,                p_pay_agency,            v_area_code,
               v_org,                     v_org_type,              v_comm_amount,                  v_comm_rate,
               p_plan,                    p_batch,                 v_lottery_detail.reward_group,  v_reward_level,
               v_lottery_detail.trunk_no, v_lottery_detail.box_no, p_package_no,                   p_ticket_no,         p_security_string,
               v_reward_amount,           v_single_ticket_amount,  v_pay_time,                     p_paid_type);

            -- 组织机构增加流水
            -- 奖金
            p_org_fund_change(v_org, eflow_type.org_agency_pay, v_reward_amount, 0, v_pay_flow, v_balance, v_balance);

            -- 佣金
            if v_comm_amount > 0 then
               p_org_fund_change(v_org, eflow_type.org_agency_pay_comm, v_comm_amount, 0, v_pay_flow, v_balance, v_balance);
            end if;

         end if;

      when 2 then                                                       -- 管理员手持机现场兑奖（因为没有现场实际应用，所以一下内容未必正确）

         if v_sys_param = '1' then
            -- 计算兑奖代销费
            v_comm_amount := trunc(v_reward_amount * v_comm_rate / 1000);

            -- 获取销售站对应的区域码
            select area_code into v_area_code from inf_agencys where agency_code = p_pay_agency;

            -- 建立兑奖记录
            insert into flow_pay
              (pay_flow,                  pay_agency,              area_code,                      pay_comm,       pay_comm_rate,
               plan_code,                 batch_no,                reward_group,
               trunk_no,                  box_no,                  package_no,                     ticket_no,      security_code,
               pay_amount,                lottery_amount,          pay_time,                       payer_admin,    payer_name,
               is_center_paid,            comm_amount,             comm_rate,                      reward_no)
            values
              (f_get_flow_pay_seq,        v_agency,                v_area_code,                    v_comm_amount,  v_comm_rate,
               p_plan,                    p_batch,                 v_lottery_detail.reward_group,
               v_lottery_detail.trunk_no, v_lottery_detail.box_no, p_package_no,                   p_ticket_no,    p_security_string,
               v_reward_amount,           v_single_ticket_amount,  v_pay_time,                     p_oper,         v_admin_realname,
               p_paid_type,               v_comm_amount,           v_comm_rate,                    v_reward_level)
            returning
               pay_flow
            into
               v_pay_flow;

            -- 给卖票销售站加“兑奖代销费”
            p_agency_fund_change(v_agency, eflow_type.pay_comm, v_comm_amount, 0, v_pay_flow, v_balance, v_f_balance);

            -- 扣减管理员账户金额，因为管理员已经将奖金直接给付彩民

         else
            -- 建立兑奖记录，不填写站点和佣金相关信息
            insert into flow_pay
              (pay_flow,                 plan_code,               batch_no,     reward_group,
               trunk_no,                 box_no,                  package_no,   ticket_no,      security_code,       reward_no,
               pay_amount,               lottery_amount,          pay_time,     payer_admin,    payer_name,          is_center_paid)
            values
              (f_get_flow_pay_seq,       p_plan,                  p_batch,      v_lottery_detail.reward_group,
              v_lottery_detail.trunk_no, v_lottery_detail.box_no, p_package_no, p_ticket_no,    p_security_string,   v_reward_level,
              v_reward_amount,           v_single_ticket_amount,  v_pay_time,   p_oper,         v_admin_realname,    p_paid_type)
            returning
               pay_flow
            into
               v_pay_flow;
         end if;

      when 1 then                                                       -- 中心兑奖

         -- 增加兑奖记录
         insert into flow_pay
           (pay_flow,                  plan_code,               batch_no,     reward_group,
            trunk_no,                  box_no,                  package_no,   ticket_no,      security_code,       reward_no,
            pay_amount,                lottery_amount,          pay_time,     payer_admin,    payer_name,          is_center_paid)
         values
           (f_get_flow_pay_seq,        p_plan,                  p_batch,      v_lottery_detail.reward_group,
            v_lottery_detail.trunk_no, v_lottery_detail.box_no, p_package_no, p_ticket_no,    p_security_string,   v_reward_level,
            v_reward_amount,           v_single_ticket_amount,  v_pay_time,   p_oper,         v_admin_realname,    p_paid_type)
         returning
            pay_flow
         into
            v_pay_flow;

         -- 新增“中心兑奖记录”
         insert into flow_gui_pay
           (gui_pay_no,             winnername,          gender,                    contact,                   age,
            cert_number,            pay_amount,          pay_time,                  payer_admin,               payer_name,
            plan_code,              batch_no,            trunk_no,                  box_no,                    package_no,
            ticket_no,              security_code,       is_manual,                 pay_flow)
         values
           (f_get_flow_gui_pay_seq, p_name,              p_sex,                     p_contact,                 p_age,
            p_id,                   v_reward_amount,     v_pay_time,                p_oper,                    v_admin_realname,
            p_plan,                 p_batch,             v_lottery_detail.trunk_no, v_lottery_detail.box_no,   p_package_no,
            p_ticket_no,            p_security_string,   eboolean.noordisabled,     v_pay_flow);

         -- add @ 2016-01-22 by 陈震
         /** 中心兑奖，需要按照兑奖的机构级别来计算是否给机构佣金                    **/
         /** 对于机构类型是总机构的，一概不给于任何佣金和奖金                        **/
         /** 对于机构类型是分公司的，按照系统参数（16）确定是否给于佣金              **/
         /** 对于机构类型是代理商的，需要给于佣金和奖金                              **/

         -- 获取兑奖机构
         v_org := f_get_flow_pay_org(v_pay_flow);

         -- 奖金
         p_org_fund_change(v_org, eflow_type.org_center_pay, v_reward_amount, 0, v_pay_flow, v_balance, v_balance);

         v_org_type := f_get_org_type(v_org);
         if (v_org_type <> '00' and v_org_type = eorg_type.company and f_get_sys_param(16) = '1') or (v_org_type = eorg_type.agent) then

            -- 获取机构佣金比例
            v_comm_rate := f_get_org_comm_rate(v_org, p_plan, p_batch, 2);

            if v_comm_rate = -1 then
               v_comm_rate := 0;
            end if;

            -- 计算机构佣金金额
            v_comm_amount := v_reward_amount * v_comm_rate / 1000;

            insert into flow_pay_org_comm
              (pay_flow,                  plan_code,               batch_no,                       reward_group,
               org_code,                  org_type,                org_pay_comm,                   org_pay_comm_rate,
               trunk_no,                  box_no,                  package_no,                     ticket_no,
               pay_amount,                lottery_amount,          pay_time,                       is_center_paid,
               security_code,             reward_no,               payer_admin,                    payer_name)
            values
              (v_pay_flow,                p_plan,                  p_batch,                        v_lottery_detail.reward_group,
               v_org,                     v_org_type,              v_comm_amount,                  v_comm_rate,
               v_lottery_detail.trunk_no, v_lottery_detail.box_no, p_package_no,                   p_ticket_no,
               v_reward_amount,           v_single_ticket_amount,  v_pay_time,                     p_paid_type,
               p_security_string,         v_reward_level,          p_oper,                         v_admin_realname);

            -- 佣金
            if v_comm_amount > 0 then
               p_org_fund_change(v_org, eflow_type.org_center_pay_comm, v_comm_amount, 0, v_pay_flow, v_balance, v_balance);
            end if;
         end if;

   end case;

   c_reward_amount := v_reward_amount;
   c_pay_flow := v_pay_flow;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
 
/ 
prompt 正在建立[PROCEDURE -> p_lottery_reward2.sql ]...... 
create or replace procedure p_lottery_reward2
/****************************************************************/
   ------------------- 旧票验奖 -------------------
   ---- 功能说明
   ----     输入待演讲的数组、兑奖人，输出兑奖不成功的数组、提交票数、失败的新票数、成功验奖票数、成功验奖金额；
   ----
   ----     检查兑奖人的合法性
   ----     循环
   ----         检查是否为新票。检查wh_ticket_package中是否存在相应的package
   ----         检索保安区码，确定是那种情况。通过方案、批次和安全码，匹配数据
   ----             判断是否中奖。记录是否存在
   ----             判断是否已经兑奖。is_paid字段值是否为1
   ----             处理验奖流程。更新is_paid字段值，插入数据，检索中奖金额

   ---- add by 陈震: 2015-12-16
   ---- 涉及的业务表：
   ----     2.1.9.1 旧票兑奖主表（SWITCH_SCAN）                                        -- 新增
   ----     2.1.9.2 旧票兑奖子表（SWITCH_SCAN_DETAIL）                                 -- 新增
   ----     2.1.4.6 批次信息导入之奖符（GAME_BATCH_IMPORT_REWARD）                     -- 检索
   ----     2.1.4.7 批次信息导入之中奖明细（GAME_BATCH_REWARD_DETAIL）                 -- 更新

   ---- 业务流程：
   ----     1、

   /*************************************************************/
(
  --------------输入----------------
  p_oper                               in number,                             -- 操作人
  p_array_lotterys                     in type_lottery_reward_list,           -- 验奖的彩票对象

  ---------出口参数---------
  c_check_result                       out type_mm_check_lottery_list,        -- 验奖失败对象列表
  c_apply_tickets                      out number,                            -- 提交票数
  c_fail_tickets_new                   out number,                            -- 失败的新票数
  c_reward_tickets                     out number,                            -- 完成验奖票数
  c_reward_amount                      out number,                            -- 完成验奖金额
  c_pay_flow                           out varchar2,                          -- 验奖序号
  c_errorcode                          out number,                            -- 错误编码
  c_errormesg                          out string                             -- 错误原因

 ) is

   v_count                             number(5);                             -- 求记录数的临时变量
   v_old_pay_flow                      char(24);                              -- 旧票验奖记录数
   v_oper_org                          char(2);                               -- 操作人员所属机构
   v_reward_info                       game_batch_reward_detail%rowtype;      -- 兑奖票信息
   v_return_ticket_info                type_mm_check_lottery_info;            -- 返回的彩票对象

   v_apply_tickets                     number(18);
   v_fail_new_tickets                  number(18);
   v_succ_tickets                      number(18);
   v_succ_amount                       number(28);

   v_reward_amount                     number(18);                            -- 奖金
   v_reward_level                      number(2);                             -- 奖级
   v_pay_time                          date;                                  -- 兑奖时间

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   c_reward_amount := 0;

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;


   /*----------- 业务逻辑   -----------------*/
   -- 设置默认的兑奖时间
   v_pay_time := sysdate;

   -- 获取操作人员所属机构
   v_oper_org := f_get_admin_org(p_oper);

   -- 插入主表
   insert into SWITCH_SCAN (old_pay_flow,        paid_time,  paid_admin, paid_org,   apply_tickets, fail_new_tickets, succ_tickets, succ_amount)
                    values (f_get_switch_no_seq, v_pay_time, p_oper,     v_oper_org, 0,             0,                0,            0)
              returning old_pay_flow into v_old_pay_flow;

   -- 计数器初始化置零
   v_apply_tickets := 0;
   v_fail_new_tickets := 0;
   v_succ_tickets := 0;
   v_succ_amount := 0;
   c_check_result := type_mm_check_lottery_list();

   -- 循环开始
   for itab in (select * from table(p_array_lotterys)) loop
      -- 累计票数
      v_apply_tickets := v_apply_tickets + 1;

      -- 如果是“爱心方案”，按照系统参数判断是否可用
      if itab.plan_code = 'J2014' and f_get_sys_param(15) <> '1' then
         insert into switch_scan_detail (old_pay_flow,           old_pay_seq,      paid_time,             paid_admin,      paid_org,
                                         plan_code,              batch_no,         package_no,            ticket_no,       security_code,
                                         paid_status,            reward_amount,    is_new_ticket)
         values                         (v_old_pay_flow,         f_get_switch_seq, v_pay_time,            p_oper,          v_oper_org,
                                         itab.plan_code,         itab.batch_no,    itab.package_no,       itab.ticket_no,  itab.security_code,
                                         epaid_status.terminate, 0,                eboolean.noordisabled);

         v_return_ticket_info := type_mm_check_lottery_info(itab.plan_code, itab.batch_no, evalid_number.ticket, null, null, itab.package_no, 1, epaid_status.terminate);
         c_check_result.extend;
         c_check_result(c_check_result.count) := v_return_ticket_info;

         continue;
      end if;

      -- 检查是否为新票
      select count(*) into v_count from dual where exists(select 1 from wh_ticket_package where plan_code = itab.plan_code and batch_no = itab.batch_no and package_no = itab.package_no);
      if v_count = 1 then
         v_fail_new_tickets := v_fail_new_tickets + 1;
         insert into switch_scan_detail (old_pay_flow,           old_pay_seq,      paid_time,             paid_admin,      paid_org,
                                         plan_code,              batch_no,         package_no,            ticket_no,       security_code,
                                         paid_status,            reward_amount,    is_new_ticket)
         values                         (v_old_pay_flow,         f_get_switch_seq, v_pay_time,            p_oper,          v_oper_org,
                                         itab.plan_code,         itab.batch_no,    itab.package_no,       itab.ticket_no,  itab.security_code,
                                         epaid_status.newticket, 0,                eboolean.yesorenabled);

         v_return_ticket_info := type_mm_check_lottery_info(itab.plan_code, itab.batch_no, evalid_number.ticket, null, null, itab.package_no, 1, epaid_status.newticket);
         c_check_result.extend;
         c_check_result(c_check_result.count) := v_return_ticket_info;

         continue;
      end if;

      -- 检索相应的兑奖信息
      begin
         select * into v_reward_info from game_batch_reward_detail where plan_code = itab.plan_code and batch_no = itab.batch_no and safe_code = itab.security_code;
       exception
         when no_data_found then
            -- 没有中奖
            insert into switch_scan_detail (old_pay_flow,           old_pay_seq,      paid_time,             paid_admin,      paid_org,
                                            plan_code,              batch_no,         package_no,            ticket_no,       security_code,
                                            paid_status,            reward_amount,    is_new_ticket)
            values                         (v_old_pay_flow,         f_get_switch_seq, v_pay_time,            p_oper,          v_oper_org,
                                            itab.plan_code,         itab.batch_no,    itab.package_no,       itab.ticket_no,  itab.security_code,
                                            epaid_status.nowin,     0,                eboolean.noordisabled);

            v_return_ticket_info := type_mm_check_lottery_info(itab.plan_code, itab.batch_no, evalid_number.ticket, null, null, itab.package_no, 1, epaid_status.nowin);
            c_check_result.extend;
            c_check_result(c_check_result.count) := v_return_ticket_info;

            continue;
       end;

      -- 已经兑奖
      if v_reward_info.IS_PAID = eboolean.yesorenabled then

         -- 获取中奖信息
         select single_reward_amount, reward_no
           into v_reward_amount, v_reward_level
           from game_batch_import_reward
          where plan_code = itab.plan_code
            and batch_no = itab.batch_no
            and instr(fast_identity_code, substr(itab.security_code, epublisher_sjz.fast_identity_code_pos, epublisher_sjz.len_fast_identity_code)) > 0;

         insert into switch_scan_detail (old_pay_flow,           old_pay_seq,      paid_time,             paid_admin,      paid_org,
                                         plan_code,              batch_no,         package_no,            ticket_no,       security_code,
                                         paid_status,            reward_amount,    is_new_ticket)
         values                         (v_old_pay_flow,         f_get_switch_seq, v_pay_time,            p_oper,          v_oper_org,
                                         itab.plan_code,         itab.batch_no,    itab.package_no,       itab.ticket_no,  itab.security_code,
                                         epaid_status.paid,      v_reward_amount,  eboolean.noordisabled);

         -- 更新返回结果集（复用box_no作为中奖金额）
         v_return_ticket_info := type_mm_check_lottery_info(itab.plan_code, itab.batch_no, evalid_number.ticket, null, v_reward_amount, itab.package_no, 1, epaid_status.paid);
         c_check_result.extend;
         c_check_result(c_check_result.count) := v_return_ticket_info;

         continue;
      end if;

      -- 更新中奖标志
      update game_batch_reward_detail
         set is_paid = eboolean.yesorenabled
       where plan_code = itab.plan_code
         and batch_no = itab.batch_no
         and safe_code = itab.security_code;

      -- 获取中奖信息
      select single_reward_amount, reward_no
        into v_reward_amount, v_reward_level
        from game_batch_import_reward
       where plan_code = itab.plan_code
         and batch_no = itab.batch_no
         and instr(fast_identity_code, substr(itab.security_code, epublisher_sjz.fast_identity_code_pos, epublisher_sjz.len_fast_identity_code)) > 0;

      -- 插入中奖纪录
      insert into switch_scan_detail (old_pay_flow,           old_pay_seq,      paid_time,             paid_admin,      paid_org,
                                      plan_code,              batch_no,         package_no,            ticket_no,       security_code,
                                      paid_status,            reward_amount,    is_new_ticket)
      values                         (v_old_pay_flow,         f_get_switch_seq, v_pay_time,            p_oper,          v_oper_org,
                                      itab.plan_code,         itab.batch_no,    itab.package_no,       itab.ticket_no,  itab.security_code,
                                      epaid_status.succed,    v_reward_amount,  eboolean.noordisabled);

      -- 更新统计值
      v_succ_tickets := v_succ_tickets + 1;
      v_succ_amount := v_succ_amount + v_reward_amount;

      -- 更新返回结果集（复用box_no作为中奖金额）
      v_return_ticket_info := type_mm_check_lottery_info(itab.plan_code, itab.batch_no, evalid_number.ticket, null, v_reward_amount, itab.package_no, 1, epaid_status.succed);
      c_check_result.extend;
      c_check_result(c_check_result.count) := v_return_ticket_info;

   end loop;

   c_apply_tickets := v_apply_tickets;
   c_fail_tickets_new := v_fail_new_tickets;
   c_reward_tickets := v_succ_tickets;
   c_reward_amount := v_succ_amount;
   c_pay_flow := v_old_pay_flow;

   update SWITCH_SCAN
      set apply_tickets = v_apply_tickets,
          fail_new_tickets = v_fail_new_tickets,
          succ_tickets = v_succ_tickets,
          succ_amount = v_succ_amount
    where old_pay_flow = v_old_pay_flow;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
 
/ 
prompt 正在建立[PROCEDURE -> p_lottery_reward_all.sql ]...... 
create or replace procedure p_lottery_reward_all
/****************************************************************/
   ------------------- 批量兑奖 -------------------
   ---- 兑奖
   ----     判断销售站是否设置过代销费比率
   ----     循环调用兑奖存储过程，完成兑奖操作

   ---- add by 陈震: 2015-12-07
   ---- 涉及的业务表：
   ----     2.1.4.6 批次信息导入之奖符（game_batch_import_reward）                     -- 更新
   ----     2.1.4.7 批次信息导入之中奖明细（game_batch_reward_detail）                 -- 更新
   ----     2.1.7.1 gui兑奖信息记录表（flow_gui_pay）                                  -- 新增
   ----     2.1.7.2 兑奖记录（flow_pay）                                               -- 新增
   ----     2.1.7.4 站点资金流水（flow_agency）                                        -- 新增

   ---- 业务流程：
   ----     1、校验输入参数。（仓库是否存在；操作类型是否为新、继续、完结；操作人是否合法；）
   ----     2、判断此张彩票是否已经销售，没有的话，就不能兑奖；
   ----     3、查询兑奖记录，判断此张彩票是否已经进行过兑奖，如果已经兑奖，返回失败；
   ----     4、更新

   /*************************************************************/
(
  --------------输入----------------
  p_oper                               in number,                          -- 操作人
  p_pay_agency                         in char,                            -- 兑奖销售站
  p_array_lotterys                     in type_lottery_reward_list,        -- 兑奖的彩票对象

  ---------出口参数---------
  c_seq_no                             out string,                         -- 兑奖序号
  c_errorcode                          out number,                         -- 错误编码
  c_errormesg                          out string                          -- 错误原因

 ) is

   v_count                 number(5);                                      -- 求记录数的临时变量

   v_djxq_no               char(24);                                       -- 兑奖详情主键
   v_seq_no                number(24);                                     -- 兑奖字表主键

   v_reward_amount         number(18);                                     -- 奖金
   v_pay_flow              char(24);                                       -- 兑奖流水号
   v_c_err_code            number(3);                                      -- 错误代码
   v_c_err_msg             varchar2(4000);                                 -- 错误消息

   v_area_code             char(4);                                        -- 站点所属区域
   v_total_reward_amount   number(28);                                     -- 总奖金

   v_safe_code             varchar2(50);                                   -- 安全码

   v_publisher             number(2);                                      -- 印制厂商

   v_temp_string           varchar2(4000);

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;

   v_temp_string := f_get_sys_param(2);
   if v_temp_string not in ('1', '2') then
      rollback;
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_pay_agency) || error_msg.err_p_lottery_reward_5; -- 系统参数值不正确，请联系管理员，重新设置
      return;
   end if;

   /*-- 检查站点的兑奖佣金比例
   with
      save_comm as (
         select plan_code,1 cnt from game_agency_comm_rate where agency_code = p_pay_agency),
      all_comm as (
         select distinct plan_code from table(p_array_lotterys)),
      result_tab as (
         select plan_code, cnt from all_comm left join save_comm using(plan_code))
   select count(*) into v_count from result_tab where cnt is null;
   if v_count > 0 then
      with
         save_comm as (
            select plan_code,1 cnt from game_agency_comm_rate where agency_code = p_pay_agency),
         all_comm as (
            select distinct plan_code from table(p_array_lotterys)),
         result_tab as (
            select plan_code, cnt from all_comm left join save_comm using(plan_code))
      select plan_code into v_plan from result_tab where cnt is null and rownum = 1;

      c_errorcode := 3;
      c_errormesg := dbtool.format_line(p_pay_agency) || dbtool.format_line(v_plan) || error_msg.err_p_lottery_reward_6; -- 该销售站未设置此方案对应的兑奖佣金比例
      return;
   end if; */

   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* 开始兑奖 *************************/
   -- 获取销售站对应的区域码
   select area_code into v_area_code from inf_agencys where agency_code = p_pay_agency;

   -- 插入兑奖详情主表，提交
   v_count := p_array_lotterys.count;
   insert into sale_paid (djxq_no, pay_agency, area_code, payer_admin, plan_tickets)
                  values (f_get_flow_pay_detail_seq, p_pay_agency, v_area_code, p_oper, v_count)
                  returning djxq_no into v_djxq_no;

   v_total_reward_amount := 0;

   -- 循环输入记录
   for itab in (select * from table(p_array_lotterys)) loop
      -- 插入兑奖详情子表，并提交
      insert into sale_paid_detail (djxq_no, djxq_seq_no, plan_code, batch_no, package_no, ticket_no, security_code,
                                    is_old_ticket)
                            values (v_djxq_no, f_get_flow_pay_detail_no_seq, itab.plan_code, itab.batch_no, itab.package_no, itab.ticket_no, itab.security_code,
                                    f_get_reward_ticket_ver(itab.plan_code, itab.batch_no, itab.package_no))
                         returning djxq_seq_no into v_seq_no;

      -- 检查是否销售，检查的同时需要考虑新旧票
      begin
         select status into v_count from wh_ticket_package where plan_code = itab.plan_code and batch_no = itab.batch_no and package_no = itab.package_no;
      exception
         when no_data_found then
            -- 没有查询到记录，表示是旧票，旧票以已经销售论处
            v_count := eticket_status.saled;
      end;

      if v_count <> eticket_status.saled then
         update sale_paid_detail
            set paid_status = epaid_status.nosale
          where djxq_seq_no = v_seq_no;
         commit;
         continue;
      end if;

      -- 按照厂商，获取对应的安全码
      if f_get_reward_ticket_ver(itab.plan_code, itab.batch_no, itab.package_no) = 1 then
         v_publisher := epublisher_code.sjz;
      else
         v_publisher := f_get_plan_publisher(itab.plan_code);
      end if;

      case v_publisher
         when epublisher_code.sjz then

            -- 检查票是否中奖
            begin
               select single_reward_amount
                 into v_reward_amount
                 from game_batch_import_reward
                where plan_code = itab.plan_code
                  and batch_no = itab.batch_no
                  and instr(fast_identity_code, substr(itab.security_code, epublisher_sjz.fast_identity_code_pos, epublisher_sjz.len_fast_identity_code)) > 0;
            exception
               when no_data_found then
                  update sale_paid_detail
                     set paid_status = epaid_status.nowin
                   where djxq_seq_no = v_seq_no;
                  commit;
                  continue;
            end;

            if v_reward_amount >= to_number(f_get_sys_param(5)) then
               update sale_paid_detail
                  set paid_status = epaid_status.bigreward,
                      reward_amount = v_reward_amount
                where djxq_seq_no = v_seq_no;
               commit;
               continue;
            end if;

         when epublisher_code.zc3c then
            begin
               select safe_code
                 into v_safe_code
                 from game_batch_reward_detail
                where plan_code = itab.plan_code
                  and batch_no = itab.batch_no
                  and pre_safe_code = substr(itab.security_code, 1, 16);

               -- 已经中奖，再检索中奖级别和中奖金额
               select single_reward_amount
                 into v_reward_amount
                 from game_batch_import_reward
                where plan_code = itab.plan_code
                  and batch_no = itab.batch_no
                  and instr(fast_identity_code, substr(v_safe_code, epublisher_sjz.fast_identity_code_pos, epublisher_sjz.len_fast_identity_code)) > 0;

               if v_reward_amount >= to_number(f_get_sys_param(5)) then
                  update sale_paid_detail
                     set paid_status = epaid_status.bigreward,
                         reward_amount = v_reward_amount
                   where djxq_seq_no = v_seq_no;
                  commit;
                  continue;
               end if;
            exception
               when no_data_found then
                  update sale_paid_detail
                     set paid_status = epaid_status.nowin
                   where djxq_seq_no = v_seq_no;
                  commit;
                  continue;
            end;

      end case;

      -- 调用存储过程
      p_lottery_reward(itab.security_code, null, null, null, null, null, 3, itab.plan_code, itab.batch_no, itab.package_no, itab.ticket_no, p_oper, p_pay_agency, sysdate,
                       v_reward_amount, v_pay_flow, v_c_err_code, v_c_err_msg);

      -- 根据存储过程返回结果，更新兑奖详情子表，并提交
      case
         -- 成功
         when v_c_err_code in (0) then
            update sale_paid_detail
               set paid_status = epaid_status.succed,
                   pay_flow = v_pay_flow,
                   reward_amount = v_reward_amount
             where djxq_seq_no = v_seq_no;
            update sale_paid
               set succ_tickets = succ_tickets + 1
             where djxq_no = v_djxq_no;

             v_total_reward_amount := v_total_reward_amount + v_reward_amount;

         -- 非法票
         when v_c_err_code in (2) then
            update sale_paid_detail
               set paid_status = epaid_status.invalid
             where djxq_seq_no = v_seq_no;

         -- 非法票
         when v_c_err_code in (3) then
            update sale_paid_detail
               set paid_status = epaid_status.terminate
             where djxq_seq_no = v_seq_no;

         -- 已兑奖
         when v_c_err_code in (5) then
            update sale_paid_detail
               set paid_status = epaid_status.paid
             where djxq_seq_no = v_seq_no;

         -- 未销售
         when v_c_err_code in (4) then
            update sale_paid_detail
               set paid_status = epaid_status.nosale
             where djxq_seq_no = v_seq_no;

         -- 系统错误
         else
            c_errorcode := 100;
            c_errormesg := v_c_err_msg;
            return;

      end case;

      commit;

   end loop;

   update sale_paid set succ_amount = v_total_reward_amount where djxq_no = v_djxq_no;
   commit;

   c_seq_no := v_djxq_no;

exception
   when others then
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
 
/ 
prompt 正在建立[PROCEDURE -> p_lotter_detail_stat.sql ]...... 
create or replace procedure p_lottery_detail_stat
/***************************************************************************/
------------- 统计入库或者出库的彩票明细，并生成入库明细数组 ----------------
/***************************************************************************/
(
 --------------输入----------------
   p_array_lotterys                   in type_lottery_list,                 -- 待查询的彩票对象

 ---------出口参数---------
   c_detail_list                      out type_lottery_detail_list,         -- 明细
   c_stat_list                        out type_lottery_statistics_list,     -- 按照方案和批次统计的金额和票数
   c_total_tickets                    out number,                           -- 总票数
   c_total_amount                     out number                            -- 总金额

 ) is

   v_detail                type_lottery_detail_info;                       -- 单条明细
   v_collect_batch_param   game_batch_import_detail%rowtype;               -- 批次参数
   v_stat_info             type_lottery_statistics_info;                   -- 单条统计信息
   v_found                 boolean;                                        -- 是否已经存在统计信息

   v_array_lottery         type_lottery_info;                              -- 单张彩票
   v_lottery_detail        type_lottery_info;                              -- 彩票对象详细信息
   v_single_ticket_amount  number(10);                                     -- 每张票的价格
   v_packs_every_box       number(10);                                     -- 每“盒”中包含多少“本”

   v_loop_i                number(10);                                     -- 循环使用的参数

begin

   -- 初始化数组
   c_detail_list := type_lottery_detail_list();
   c_stat_list := type_lottery_statistics_list();
   v_detail := type_lottery_detail_info(null,null,null,null,null,null,null,null);
   v_stat_info := type_lottery_statistics_info(null,null,null,null,null,null,null);
   c_total_tickets := 0;
   c_total_amount := 0;

   -- 循环处理明细数据，统计入库票数据
   for v_list_count in 1 .. p_array_lotterys.count loop
      v_array_lottery := p_array_lotterys(v_list_count);

      -- 判断期次和批次是否为空
      if v_array_lottery.plan_code is null or v_array_lottery.batch_no is null then
         raise_application_error(-20001, dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || error_msg.err_common_108);
      end if;

      -- 获取保存的参数
      select * into v_collect_batch_param from game_batch_import_detail where plan_code = v_array_lottery.plan_code and batch_no = v_array_lottery.batch_no;

      -- 获取单张票金额
      select ticket_amount into v_single_ticket_amount from game_plans where plan_code = v_array_lottery.plan_code;

      -- 每“盒”中包含多少“本”
      v_packs_every_box := v_collect_batch_param.packs_every_trunk / v_collect_batch_param.boxes_every_trunk;

      case
         when v_array_lottery.valid_number = evalid_number.trunk then
            -- 获取彩票对象的详细信息
            v_lottery_detail := f_get_lottery_info(v_array_lottery.plan_code, v_array_lottery.batch_no, v_array_lottery.valid_number, v_array_lottery.trunk_no);

            -- 明细数组中，记录相应数据
            v_detail.trunk_no := v_array_lottery.trunk_no;
            v_detail.box_no := '-';
            v_detail.package_no := '-';
            v_detail.tickets := v_collect_batch_param.packs_every_trunk * v_collect_batch_param.tickets_every_pack;

         when v_array_lottery.valid_number = evalid_number.box then
            -- 获取彩票对象的详细信息
            v_lottery_detail := f_get_lottery_info(v_array_lottery.plan_code, v_array_lottery.batch_no, v_array_lottery.valid_number, v_array_lottery.box_no);

            -- 明细数组中，记录相应数据
            v_detail.trunk_no := v_lottery_detail.trunk_no;
            v_detail.box_no := v_array_lottery.box_no;
            v_detail.package_no := '-';
            v_detail.tickets := v_packs_every_box * v_collect_batch_param.tickets_every_pack;

         when v_array_lottery.valid_number = evalid_number.pack then
            -- 获取彩票对象的详细信息
            v_lottery_detail := f_get_lottery_info(v_array_lottery.plan_code, v_array_lottery.batch_no, v_array_lottery.valid_number, v_array_lottery.package_no);

            -- 明细数组中，记录相应数据
            v_detail.trunk_no := v_lottery_detail.trunk_no;
            v_detail.box_no := v_lottery_detail.box_no;
            v_detail.package_no := v_array_lottery.package_no;
            v_detail.tickets := v_collect_batch_param.tickets_every_pack;


      end case;

      -- 填充公用字段
      v_detail.valid_number := v_array_lottery.valid_number;
      v_detail.plan_code := v_array_lottery.plan_code;
      v_detail.batch_no := v_array_lottery.batch_no;
      v_detail.amount := v_detail.tickets * v_single_ticket_amount;
      v_detail.plan_code := v_array_lottery.plan_code;
      v_detail.batch_no := v_array_lottery.batch_no;

      -- 扩展数组
      c_detail_list.extend;
      c_detail_list(c_detail_list.count) := v_detail;

      -- 记录统计值
      c_total_tickets := c_total_tickets + v_detail.tickets;
      c_total_amount := c_total_amount + v_detail.tickets * v_single_ticket_amount;

      -- 以方案和期次统计
      v_found := false;
      for v_loop_i in 1 .. c_stat_list.count loop
         if c_stat_list(v_loop_i).plan_code = v_detail.plan_code and c_stat_list(v_loop_i).batch_no = v_detail.batch_no then
            v_found := true;
            c_stat_list(v_loop_i).tickets := c_stat_list(v_loop_i).tickets + v_detail.tickets;
            c_stat_list(v_loop_i).amount := c_stat_list(v_loop_i).amount + v_detail.tickets * v_single_ticket_amount;

            case
               when v_array_lottery.valid_number = evalid_number.trunk then
                  c_stat_list(v_loop_i).trunks := c_stat_list(v_loop_i).trunks + 1;

               when v_array_lottery.valid_number = evalid_number.box then
                  c_stat_list(v_loop_i).boxes := c_stat_list(v_loop_i).boxes + 1;

               when v_array_lottery.valid_number = evalid_number.pack then
                  c_stat_list(v_loop_i).packages := c_stat_list(v_loop_i).packages + 1;

            end case;

         end if;
      end loop;
      if not v_found then
         v_stat_info.plan_code := v_array_lottery.plan_code;
         v_stat_info.batch_no := v_array_lottery.batch_no;
         v_stat_info.tickets := v_detail.tickets;
         v_stat_info.amount := v_detail.amount;
         case
            when v_array_lottery.valid_number = evalid_number.trunk then
               v_stat_info.trunks := 1;
               v_stat_info.boxes := 0;
               v_stat_info.packages := 0;

            when v_array_lottery.valid_number = evalid_number.box then
               v_stat_info.trunks := 0;
               v_stat_info.boxes := 1;
               v_stat_info.packages := 0;

            when v_array_lottery.valid_number = evalid_number.pack then
               v_stat_info.trunks := 0;
               v_stat_info.boxes := 0;
               v_stat_info.packages := 1;

         end case;

         c_stat_list.extend;
         c_stat_list(c_stat_list.count) := v_stat_info;


      end if;
   end loop;

   -- 检查这些票所对应的方案是否有效
   for v_loop_i in 1 .. c_stat_list.count loop
      if not f_check_plan_batch_status(v_stat_info.plan_code, v_stat_info.batch_no) then
         raise_application_error(-20001, dbtool.format_line(v_stat_info.plan_code) || dbtool.format_line(v_stat_info.batch_no) || error_msg.err_common_107);
      end if;
   end loop;

end;
 
/ 
prompt 正在建立[PROCEDURE -> p_mis_abandon_out.sql ]...... 
CREATE OR REPLACE PROCEDURE p_mis_abandon_out
/*****************************************************************/
   ----------- 弃奖金额处理（MIS调用） ---------------
   ----------- modify by dzg 本地化修改78行
   /*****************************************************************/
(
 --------------输入----------------
 p_game_code      IN NUMBER, --游戏编码
 p_issue_number   IN NUMBER, --期次编码
 p_abandon_amount IN NUMBER --弃奖金额
 ) IS
   v_game_param NUMBER(1); -- 游戏参数

   v_before_amount NUMBER(18); -- 调整之前金额
   v_after_amount  NUMBER(18); -- 调整之后金额
   v_curr_issue    NUMBER(18); -- 当前期次

BEGIN
   -- 获取游戏参数
   SELECT abandon_reward_collect
     INTO v_game_param
     FROM gp_static
    WHERE game_code = p_game_code;

   -- 获取此游戏的最近未开奖的游戏期次。如果没有合适的记录，那么获取最后一个开奖期次的下一个有效期次序号。
   -- 因为弃奖必须隶属于一个游戏期次，用来生成 奖金动态分配表，给钱一个归处。
   -- 这个最近的游戏期次，就是最后一次开奖的那个游戏期次的下一个。同时这个“下一个”还不能是一个游戏状态为 “预排 prearrangement ”的期次，因为这个期次随时可能被删掉，重新来过。
   begin
      SELECT min(issue_number)
        INTO v_curr_issue
        FROM iss_game_issue
       WHERE game_code = p_game_code
         AND REAL_REWARD_TIME IS NULL
         and issue_status <> egame_issue_status.prearrangement;
      if v_curr_issue is null then
         SELECT max(issue_seq)
           INTO v_curr_issue
           FROM iss_game_issue
          WHERE game_code = p_game_code
            AND REAL_REWARD_TIME IS NOT NULL
            and issue_status <> egame_issue_status.prearrangement;

         begin
            select issue_number
              into v_curr_issue
              from iss_game_issue
             where game_code = p_game_code
               and issue_seq = v_curr_issue + 1
               and issue_status <> egame_issue_status.prearrangement;
         exception
            when no_data_found then
               v_curr_issue := 0 - (v_curr_issue + 1);
         end;
      end if;
   end;

   CASE v_game_param
   /* 进入调节基金 */
      WHEN eabandon_reward_collect.adj THEN
         -- 首先更新余额，获得之前和之后的金额；然后再入历史表
         UPDATE adj_game_current
            SET pool_amount_before = pool_amount_after,
                pool_amount_after  = pool_amount_after + p_abandon_amount
          WHERE game_code = p_game_code
         RETURNING pool_amount_before, pool_amount_after INTO v_before_amount, v_after_amount;

         -- 插入历史表
         INSERT INTO adj_game_his
            (his_code,
             game_code,
             issue_number,
             adj_change_type,
             adj_amount,
             adj_amount_before,
             adj_amount_after,
             adj_time,
             adj_reason)
         VALUES
            (f_get_game_his_code_seq,
             p_game_code,
             v_curr_issue,
             eadj_change_type.in_issue_abandon,
             p_abandon_amount,
             v_before_amount,
             v_after_amount,
             SYSDATE,
             error_msg.MSG0001 || ', Original ISSUE NUMBER is [' ||
             p_issue_number || ']');

   /* 进入奖池 */
      WHEN eabandon_reward_collect.pool THEN
         -- 首先更新余额，获得之前和之后的金额；然后再入历史表
         UPDATE iss_game_pool
            SET pool_amount_before = pool_amount_after,
                pool_amount_after  = pool_amount_after + p_abandon_amount,
                adj_time           = SYSDATE
          WHERE game_code = p_game_code
            AND pool_code = 0
         RETURNING pool_amount_before, pool_amount_after INTO v_before_amount, v_after_amount;

         -- 插入历史记录
         INSERT INTO iss_game_pool_his -- 奖池（期次开奖滚入）
            (his_code,
             game_code,
             issue_number,
             pool_code,
             change_amount,
             pool_amount_before,
             pool_amount_after,
             adj_time,
             pool_adj_type,
             adj_reason)
         VALUES
            (f_get_game_his_code_seq,
             p_game_code,
             v_curr_issue,
             0,
             p_abandon_amount,
             v_before_amount,
             v_after_amount,
             SYSDATE,
             epool_change_type.in_issue_abandon,
             error_msg.MSG0001 || ', Original ISSUE NUMBER is [' ||
             p_issue_number || ']');

   /* 进入公益金 */
      WHEN eabandon_reward_collect.fund THEN
         -- 插入记录
         INSERT INTO commonweal_fund -- 公益金
            (his_code,
             game_code,
             issue_number,
             cwfund_change_type,
             adj_amount,
             adj_amount_before,
             adj_amount_after,
             adj_time,
             adj_reason)
         VALUES
            (f_get_game_his_code_seq,
             p_game_code,
             v_curr_issue,
             ecwfund_change_type.in_from_abandon,
             p_abandon_amount,
             (SELECT adj_amount_after
                FROM commonweal_fund
               WHERE game_code = p_game_code
                 AND his_code = (SELECT MAX(his_code)
                                   FROM commonweal_fund
                                  WHERE game_code = p_game_code)),
             (SELECT adj_amount_after
                FROM commonweal_fund
               WHERE game_code = p_game_code
                 AND his_code = (SELECT MAX(his_code)
                                   FROM commonweal_fund
                                  WHERE game_code = p_game_code)) +
             p_abandon_amount,
             SYSDATE,
             error_msg.MSG0001 || ', Original ISSUE NUMBER is [' ||
             p_issue_number || ']');

   END CASE;
END;
 
/ 
prompt 正在建立[PROCEDURE -> p_mis_dss_00_prepare.sql ]...... 
CREATE OR REPLACE PROCEDURE p_mis_dss_00_prepare IS
   v_sql VARCHAR2(100);
BEGIN
   -- 清空临时表
   v_sql := 'truncate table tmp_all_issue';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table TMP_SELL_ISSUE';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table TMP_WIN_ISSUE';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table TMP_ABAND_ISSUE';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table TMP_AGENCY';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_multi_cancel';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_multi_pay';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_multi_sell';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_rst_3111';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_rst_3112';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_rst_3113';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_rst_3116';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_rst_3121';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_rst_3122';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_rst_3124';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_rst_3125';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_rst_aband';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_rst_ncp';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_rst_win';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_src_abandon';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_src_abandon_detail';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_src_cancel';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_src_pay';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_src_sell';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_src_sell_detail';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'truncate table tmp_src_win';
   EXECUTE IMMEDIATE v_sql;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_mis_dss_05_gen_winning.sql ]...... 
create or replace procedure p_mis_dss_05_gen_winning
  (p_settle_id    number,
   p_is_maintance NUMBER default 0)
is
  start_seq number(10);
  end_seq number(10);
  v_set_day date;

begin
  select win_seq, settle_date into end_seq, v_set_day from his_day_settle where settle_id=p_settle_id;
  select max(win_seq) into start_seq from his_day_settle where settle_id<p_settle_id;

  -- 考虑到多期票的问题，
  -- 1、获取今天开奖的期次列表
  -- 2、根据开奖期次获知对应的销售票（his_selltickt中的end_issue）,获知这些票的 请求流水
  -- 3、根据请求流水，将中奖票入库。

  insert into tmp_src_win
    (applyflow_sell,                  winning_time,
     terminal_code,                   teller_code,                      agency_code,
     game_code,                       issue_number,                     is_big_prize,
     ticket_amount,
     win_amount_without_tax,          win_amount,           tax_amount,            win_bets,
     hd_win_amount_without_tax,       hd_win_amount,        hd_tax_amount,         hd_win_bets,
     ld_win_amount_without_tax,       ld_win_amount,        ld_tax_amount,         ld_win_bets)
  with
    -- 当天发布的中奖期次
    winning_issue as (
      select game_code, issue_number from iss_game_issue where real_reward_time >= v_set_day and real_reward_time < v_set_day + 1),
    -- 中奖期次对应的销售票
    sell as (
      select applyflow_sell, terminal_code, teller_code, agency_code, issue_number, game_code, ticket_amount
        from his_sellticket
       where (game_code, end_issue) in (select game_code, issue_number from winning_issue)),
    -- 销售票对应的中奖明细
    win as (
      select applyflow_sell,            max(winnning_time) as winnning_time,
             sum(winningamounttax)                                            as win_amount,                                -- 税前奖金
             sum(winningamount)                                               as win_amount_without_tax,                    -- 税后奖金
             sum(taxamount)                                                   as tax_amount,                                -- 缴税额
             sum(prize_count)                                                 as win_bets,                                  -- 中奖注数
             sum(case when is_hd_prize = 1 then winningamounttax else 0 end)  as hd_win_amount,                             -- 税前奖金（高等奖）
             sum(case when is_hd_prize = 1 then winningamount    else 0 end)  as hd_win_amount_without_tax,                 -- 税后奖金（高等奖）
             sum(case when is_hd_prize = 1 then taxamount        else 0 end)  as hd_tax_amount,                             -- 缴税额  （高等奖）
             sum(case when is_hd_prize = 1 then prize_count      else 0 end)  as hd_win_bets,                               -- 中奖注数（高等奖）
             sum(case when is_hd_prize = 0 then winningamounttax else 0 end)  as ld_win_amount,                             -- 税前奖金（低等奖）
             sum(case when is_hd_prize = 0 then winningamount    else 0 end)  as ld_win_amount_without_tax,                 -- 税后奖金（低等奖）
             sum(case when is_hd_prize = 0 then taxamount        else 0 end)  as ld_tax_amount,                             -- 缴税额  （低等奖）
             sum(case when is_hd_prize = 0 then prize_count      else 0 end)  as ld_win_bets                                -- 中奖注数（低等奖）
        from his_win_ticket_detail
       where applyflow_sell in (select applyflow_sell from sell)
       group by applyflow_sell)
  select applyflow_sell,     win.winnning_time,
         terminal_code,      teller_code,           agency_code,
         game_code,          sell.issue_number,
         (case
              when win_amount_without_tax >= limit_big_prize then 1
              when win_amount_without_tax < limit_big_prize then 0
              else null
          end),
         sell.ticket_amount,
         win.win_amount_without_tax,             win.win_amount,             win.tax_amount,            win.win_bets,
         win.hd_win_amount_without_tax,          win.hd_win_amount,          win.hd_tax_amount,         win.hd_win_bets,
         win.ld_win_amount_without_tax,          win.ld_win_amount,          win.ld_tax_amount,         win.ld_win_bets
    from win
    join sell using(applyflow_sell)
    join gp_static using(game_code);
  
  
  if p_is_maintance <> 0 then
    delete from his_win_ticket where winning_time = v_set_day;
  end if;
  
  insert into his_win_ticket select * from tmp_src_win;

  commit;

end;

 
/ 
prompt 正在建立[PROCEDURE -> p_mis_dss_10_gen_abandon.sql ]...... 
CREATE OR REPLACE PROCEDURE p_mis_dss_10_gen_abandon(p_settle_id    IN NUMBER,
                                                     p_is_maintance IN NUMBER default 0) IS
   v_date date;
BEGIN
   select SETTLE_DATE
     into v_date
     from HIS_DAY_SETTLE
    where SETTLE_ID = p_settle_id;

   INSERT INTO tmp_src_abandon
      (applyflow_sell,
       abandon_time,
       winning_time,
       terminal_code,
       teller_code,
       agency_code,
       game_code,
       issue_number,
       ticket_amount,
       is_big_prize,
       win_amount,
       win_amount_without_tax, -- 中奖金额（税后）
       tax_amount,
       win_bets,
       hd_win_amount,
       hd_win_amount_without_tax, -- 高等奖中奖金额（税后）
       hd_tax_amount,
       hd_win_bets,
       ld_win_amount,
       ld_win_amount_without_tax, -- 低等奖中奖金额（税后）
       ld_tax_amount,
       ld_win_bets)
      WITH abandon_issue AS
       ( /* 凌晨弃奖游戏期次（昨天是兑奖的最后一天，今天形成弃奖） */
        SELECT game_code, issue_number
          FROM iss_game_issue
         WHERE pay_end_day = to_number(to_char(v_date, 'yyyymmdd'))),
      all_abandon_flow AS
       ( /* 所有满足弃奖期次的票号 */
        SELECT applyflow_sell
          FROM his_sellticket
         where (game_code, end_issue) in
               (select game_code, issue_number from abandon_issue)
       )
      SELECT applyflow_sell,
             v_date + 1,
             winning_time,
             terminal_code,
             teller_code,
             agency_code,
             game_code,
             issue_number,
             ticket_amount,
             is_big_prize,
             win_amount,
             win_amount_without_tax, -- 中奖金额（税后）
             tax_amount,
             win_bets,
             hd_win_amount,
             hd_win_amount_without_tax, -- 高等奖中奖金额（税后）
             hd_tax_amount,
             hd_win_bets,
             ld_win_amount,
             ld_win_amount_without_tax, -- 低等奖中奖金额（税后）
             ld_tax_amount,
             ld_win_bets
        FROM all_abandon_flow
        JOIN his_win_ticket
       USING (applyflow_sell)
	    where applyflow_sell not in (SELECT applyflow_sell from his_payticket where applyflow_sell in (select applyflow_sell from his_sellticket where (game_code, issue_number) in (select game_code, issue_number from abandon_issue)));

   COMMIT;

   -- 弃奖主表
   delete his_abandon_ticket where abandon_time = v_date + 1;
   insert into his_abandon_ticket select * from tmp_src_abandon;
   commit;

   -- 弃奖明细表
   delete his_abandon_ticket_detail where abandon_time = v_date + 1;
   insert into his_abandon_ticket_detail
      (applyflow_sell,
       abandon_time,
       winning_time,
       game_code,
       issue_number,
       prize_level,
       prize_count,
       is_hd_prize,
       winningamounttax,
       winningamount,
       taxamount)
      select applyflow_sell,
             v_date + 1,
             winnning_time,
             game_code,
             issue_number,
             prize_level,
             prize_count,
             is_hd_prize,
             winningamounttax,
             winningamount,
             taxamount
        from his_win_ticket_detail
       where applyflow_sell in (select applyflow_sell from tmp_src_abandon);
   commit;

   if p_is_maintance = 0 then
      -- 弃奖资金进入调节基金
      -- 想法：
      -- 1、计算出弃奖资金
      -- 2、在调节基金中新增一条记录
      -- 3、修改当前的调节基金余额
      -- TAISHAN用户下新建SP，入口参数：
      -- 游戏、期次、弃奖金额
      for v_game_code in 1 .. 20 loop
         for detail in (select issue_number, sum(win_amount) as amount
                          from tmp_src_abandon
                         where game_code = v_game_code
                         group by issue_number
                         order by issue_number) loop
            p_mis_abandon_out(v_game_code,
                              detail.issue_number,
                              detail.amount);
         end loop;
      end loop;
      commit;
   end if;

   -- 重新写临时表内容。这是因为，弃奖日期aband_day和最后兑奖截止日pay_end_day，之间有一天的差距。
   -- 在计算弃奖时，会使用【最后兑奖截止日pay_end_day】来进行。因为当前MIS的计算在凌晨进行，所以计算的结果，就是当天产生的弃奖，也就是【弃奖日期aband_day】为计算日。
   -- 这与MIS报表中所体现的日期标准有差距。MIS报表中（销售、兑奖）所体现的是前一天发生的行为。
   delete tmp_src_abandon;
   insert into tmp_src_abandon
      (applyflow_sell,
       abandon_time,
       winning_time,
       terminal_code,
       teller_code,
       agency_code,
       game_code,
       issue_number,
       ticket_amount,
       is_big_prize,
       win_amount,
       win_amount_without_tax, -- 中奖金额（税后）
       tax_amount,
       win_bets,
       hd_win_amount,
       hd_win_amount_without_tax, -- 高等奖中奖金额（税后）
       hd_tax_amount,
       hd_win_bets,
       ld_win_amount,
       ld_win_amount_without_tax, -- 低等奖中奖金额（税后）
       ld_tax_amount,
       ld_win_bets)
      select applyflow_sell,
             abandon_time,
             winning_time,
             terminal_code,
             teller_code,
             agency_code,
             game_code,
             issue_number,
             ticket_amount,
             is_big_prize,
             win_amount,
             win_amount_without_tax, -- 中奖金额（税后）
             tax_amount,
             win_bets,
             hd_win_amount,
             hd_win_amount_without_tax, -- 高等奖中奖金额（税后）
             hd_tax_amount,
             hd_win_bets,
             ld_win_amount,
             ld_win_amount_without_tax, -- 低等奖中奖金额（税后）
             ld_tax_amount,
             ld_win_bets
        from his_abandon_ticket
       where abandon_time = v_date;

   COMMIT;
END; 
/ 
prompt 正在建立[PROCEDURE -> p_mis_dss_13_gen_his_dict.sql ]...... 
CREATE OR REPLACE PROCEDURE p_mis_dss_13_gen_his_dict(p_settle_id IN NUMBER) IS
  v_count NUMBER(10);
BEGIN
  -- 保存日结时候的销售站历史
  SELECT COUNT(*)
    INTO v_count
    FROM his_saler_agency
   WHERE settle_id = p_settle_id;
  IF v_count = 0 THEN
    insert into his_saler_agency
      (settle_id,
       agency_code,
       agency_name,
       storetype_id,
       status,
       agency_type,
       bank_id,
       bank_account,
       telephone,
       contact_person,
       address,
       agency_add_time,
       quit_time,
       org_code,
       area_code,
       market_manager_id)
      SELECT p_settle_id,
             agency_code,
             agency_name,
             storetype_id,
             status,
             agency_type,
             bank_id,
             bank_account,
             telephone,
             contact_person,
             address,
             agency_add_time,
             quit_time,
             org_code,
             area_code,
             market_manager_id
        FROM inf_agencys;
    COMMIT;
  END IF;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_mis_dss_20_gen_tmp_src.sql ]...... 
create or replace procedure p_mis_dss_20_gen_tmp_src(p_settle_id in number) is
  pre_settle his_day_settle%rowtype;
  now_settle his_day_settle%rowtype;

begin
  -- 获取当前日结信息和最近一次的日结信息
  select *
    into now_settle
    from his_day_settle
   where settle_id = p_settle_id;
  select *
    into pre_settle
    from his_day_settle
   where settle_id = (select max(settle_id)
                        from his_day_settle
                       where settle_id < p_settle_id);

  -- 所有游戏期次进临时表
  insert into tmp_all_issue
    select game_code,
           issue_number,
           issue_seq,
           trunc(real_start_time),
           trunc(real_close_time),
           trunc(real_reward_time),
           real_start_time,
           real_close_time,
           real_reward_time
      from iss_game_issue;
  dbms_output.put_line('p_mis_dss_20_gen_tmp_src->游戏期次:' || sql%rowcount);

  -- 销售期次
  insert into tmp_sell_issue
    (game_code, issue_number, issue_seq)
    select game_code, issue_number, issue_seq
      from tmp_all_issue
     where (start_time > pre_settle.opt_date and
           start_time <= now_settle.opt_date) -- 第一种情况，时间段往左偏
        or (close_time > pre_settle.opt_date and
           close_time <= now_settle.opt_date) -- 第二种情况，时间段往右偏
        or (start_time < pre_settle.opt_date and
           (close_time > now_settle.opt_date or close_time is null)); -- 第三种情况，时间段包含统计时间段
  dbms_output.put_line('p_mis_dss_20_gen_tmp_src->销售期次:' || sql%rowcount);

  -- 开奖期次
  insert into tmp_win_issue
    (game_code, issue_number, issue_seq)
    select game_code, issue_number, issue_seq
      from tmp_all_issue
     where reward_time > pre_settle.opt_date
       and reward_time <= now_settle.opt_date;
  dbms_output.put_line('p_mis_dss_20_gen_tmp_src->开奖期次:' || sql%rowcount);

  -- 弃奖期次
  insert into tmp_aband_issue
    (game_code, issue_number, real_reward_time)
    select game_code, issue_number, trunc(real_reward_time)
      from iss_game_issue
     where pay_end_day =
           to_number(to_char(now_settle.settle_date - 1, 'yyyymmdd'));
  dbms_output.put_line('p_mis_dss_20_gen_tmp_src->弃奖期次:' || sql%rowcount);

  commit;

  -- 销售站
  insert into tmp_agency
    (agency_code,
     agency_name,
     storetype_id,
     org_code,
     area_code,
     status,
     agency_type,
     bank_id,
     bank_account,
     marginal_credit,
     available_credit,
     telephone,
     contact_person,
     address,
     agency_add_time)
    select agency_code,
           agency_name,
           storetype_id,
           org_code,
           area_code,
           status,
           agency_type,
           bank_id,
           bank_account,
           credit_limit,
           account_balance,
           telephone,
           contact_person,
           address,
           agency_add_time
      from his_saler_agency
      join acc_agency_account
     using (agency_code)
     where settle_id = now_settle.settle_id
       and acc_type = 1;
  dbms_output.put_line('p_mis_dss_20_gen_tmp_src->销售站:' || sql%rowcount);

  /* 弃奖和中奖的临时表已经在10和15中形成 */
  -- 卖票表
  insert into tmp_src_sell
    (applyflow_sell,
     saletime,
     terminal_code,
     teller_code,
     agency_code,
     game_code,
     issue_number,
     start_issue,
     end_issue,
     issue_count,
     ticket_amount,
     ticket_bet_count,
     salecommissionrate,
     commissionamount,
     bet_methold,
     bet_line,
     loyalty_code,
     result_code)
    select applyflow_sell,
           saletime,
           terminal_code,
           teller_code,
           agency_code,
           game_code,
           issue_number,
           start_issue,
           end_issue,
           issue_count,
           ticket_amount,
           ticket_bet_count,
           salecommissionrate,
           commissionamount,
           bet_methold,
           bet_line,
           loyalty_code,
           result_code
      from his_sellticket
     where sell_seq > pre_settle.sell_seq
       and sell_seq <= now_settle.sell_seq;
  dbms_output.put_line('p_mis_dss_20_gen_tmp_src->卖票表:' || sql%rowcount);
  commit;

  --兑奖表
  insert into tmp_src_pay
    (applyflow_pay,
     applyflow_sell,
     game_code,
     issue_number,
     pay_issue_number,
     terminal_code,
     teller_code,
     agency_code,
     org_code,
     paytime,
     winningamounttax,
     winningamount,
     taxamount,
     paycommissionrate,
     commissionamount,
     winningcount,
     hd_winning,
     hd_count,
     ld_winning,
     ld_count,
     loyalty_code,
     is_big_prize,
     is_center)
    select applyflow_pay,
           applyflow_sell,
           game_code,
           (select issue_number from his_sellticket where applyflow_sell= his_payticket.applyflow_sell),
           issue_number,
           terminal_code,
           teller_code,
           agency_code,
           org_code,
           paytime,
           winningamounttax,
           winningamount,
           taxamount,
           (case when is_center=1 then paycommissionrate_o else paycommissionrate end) paycommissionrate,
           (case when is_center=1 then commissionamount_o else commissionamount end) commissionamount,
           winningcount,
           hd_winning,
           hd_count,
           ld_winning,
           ld_count,
           nvl(loyalty_code, 'no_loyalty_code'),
           is_big_prize,
           is_center
      from his_payticket
     where pay_seq > pre_settle.pay_seq
       and pay_seq <= now_settle.pay_seq;
  dbms_output.put_line('p_mis_dss_20_gen_tmp_src->兑奖表:' || sql%rowcount);
  commit;

  -- 退票表
  insert into tmp_src_cancel
    (applyflow_cancel,
     canceltime,
     applyflow_sell,
     c_terminal_code,
     c_teller_code,
     c_agency_code,
     c_org_code,
     saletime,
     terminal_code,
     teller_code,
     agency_code,
     game_code,
     issue_number,
     ticket_amount,
     ticket_bet_count,
     salecommissionrate,
     commissionamount,
     bet_methold,
     bet_line,
     loyalty_code,
     is_center)
    with cancel as
     (select /*+ materialize */
       applyflow_cancel,
       canceltime,
       applyflow_sell,
       terminal_code,
       teller_code,
       agency_code,
       org_code,
       is_center
        from his_cancelticket
       where cancel_seq > pre_settle.cancel_seq
         and cancel_seq <= now_settle.cancel_seq),
    sell as
     (select applyflow_sell,
             saletime,
             terminal_code,
             teller_code,
             agency_code,
             game_code,
             issue_number,
             ticket_amount,
             ticket_bet_count,
             salecommissionrate,
             commissionamount,
             bet_methold,
             bet_line,
             loyalty_code
        from his_sellticket
       where applyflow_sell in (select applyflow_sell from cancel))
    select cancel.applyflow_cancel,
           cancel.canceltime,
           applyflow_sell,
           cancel.terminal_code,
           cancel.teller_code,
           cancel.agency_code,
           org_code,
           sell.saletime,
           sell.terminal_code,
           sell.teller_code,
           sell.agency_code,
           sell.game_code,
           sell.issue_number,
           sell.ticket_amount,
           sell.ticket_bet_count,
           sell.salecommissionrate,
           sell.commissionamount,
           sell.bet_methold,
           sell.bet_line,
           sell.loyalty_code,
           is_center
      from cancel
      join sell
     using (applyflow_sell);
  dbms_output.put_line('p_mis_dss_20_gen_tmp_src->退票表:' || sql%rowcount);
  commit;
end; 
/ 
prompt 正在建立[PROCEDURE -> p_mis_dss_30_gen_multi_issue.sql ]...... 
CREATE OR REPLACE PROCEDURE p_mis_dss_30_gen_multi_issue IS
   v_issue_count NUMBER(10); -- 多期票的总期数
   v_loop        NUMBER(10); -- 循环中的期次变量
   v_issue       NUMBER(10); -- 计算获得的期次编号
   v_issue_seq   NUMBER(10); -- 期次序号

   v_sell his_sellticket%ROWTYPE; -- 销售期次的内容

BEGIN
  
  -- 计算获得的结果为 单期票+多期拆分为单期记录
  -- 在每个日结区间产生的销售、退票和兑奖记录中，找出多期票的部分进行拆分，获得同单期票一样的结果，然后再拼接上单期票，形成待统计数据
   /********************      销售票      *********************/
   -- 买票的多期
   FOR table_sell IN (SELECT *
                        FROM tmp_src_sell
                       WHERE issue_count > 1) LOOP
      v_issue_count := table_sell.issue_count;

      -- 获取多期票
      SELECT issue_seq
        INTO v_issue_seq
        FROM tmp_all_issue
       WHERE game_code = table_sell.game_code
         AND issue_number = table_sell.issue_number;

      FOR v_loop IN 1 .. v_issue_count LOOP
         -- 计算期次编号

         SELECT issue_number
           INTO v_issue
           FROM tmp_all_issue
          WHERE game_code = table_sell.game_code
            AND issue_seq = v_issue_seq + v_loop - 1;

         -- 插入
         INSERT INTO tmp_multi_sell
            (applyflow_sell,
             saletime,
             terminal_code,
             teller_code,
             agency_code,
             game_code,
             issue_number,
             ticket_amount,
             ticket_bet_count,
             salecommissionrate,
             commissionamount,
             bet_methold,
             bet_line,
             loyalty_code,
             result_code)
         VALUES
            (table_sell.applyflow_sell,
             table_sell.saletime,
             table_sell.terminal_code,
             table_sell.teller_code,
             table_sell.agency_code,
             table_sell.game_code,
             v_issue,
             table_sell.ticket_amount / v_issue_count,
             table_sell.ticket_bet_count / v_issue_count,
             table_sell.salecommissionrate,
             table_sell.commissionamount / v_issue_count,
             table_sell.bet_methold,
             table_sell.bet_line,
             table_sell.loyalty_code,
             table_sell.result_code);

      END LOOP;
   END LOOP;

   -- 算完多期，再合并上单期票，全活
   INSERT INTO tmp_multi_sell
      (applyflow_sell,
       saletime,
       terminal_code,
       teller_code,
       agency_code,
       game_code,
       issue_number,
       ticket_amount,
       ticket_bet_count,
       salecommissionrate,
       commissionamount,
       bet_methold,
       bet_line,
       loyalty_code,
       result_code)
      SELECT applyflow_sell,
             saletime,
             terminal_code,
             teller_code,
             agency_code,
             game_code,
             issue_number,
             ticket_amount,
             ticket_bet_count,
             salecommissionrate,
             commissionamount,
             bet_methold,
             bet_line,
             loyalty_code,
             result_code
        FROM tmp_src_sell
       WHERE issue_count = 1;

   /********************      兑奖票      *********************/
   -- 多期票兑奖，兑奖期、销售期、票面期次这些应该怎么办？？ 跨天多期怎么办？（规则上没有跨天多期）
   -- 兑奖多期
/*   FOR table_pay IN (SELECT *
                       FROM tmp_src_pay
                      WHERE applyflow_sell IN (SELECT applyflow_sell
                                                 FROM his_sellticket_multi_issue)) LOOP
      -- 获取中奖期次的信息
      for table_win in (
                        SELECT ISSUE_NUMBER,
                               sum(WINNINGAMOUNTTAX) WINNINGAMOUNTTAX,
                               sum(WINNINGAMOUNT) WINNINGAMOUNT,
                               sum(TAXAMOUNT) TAXAMOUNT,
                               sum(PRIZE_COUNT) PRIZE_COUNT,
                               max(IS_HD_PRIZE) IS_HD_PRIZE
                          FROM HIS_WIN_TICKET_DETAIL
                         WHERE applyflow_sell = table_pay.applyflow_sell
                         group by ISSUE_NUMBER) loop

         INSERT INTO tmp_multi_pay
            (applyflow_pay,
             applyflow_sell,
             game_code,
             pay_issue_number,
             terminal_code,
             teller_code,
             agency_code,
             org_code,
             is_center,
             paytime,
             paycommissionrate,
             -- 某一个中奖期次
             issue_number,
             winningamounttax,
             winningamount,
             taxamount,
             commissionamount,
             winningcount,
             hd_winning,
             hd_count,
             ld_winning,
             ld_count,
             loyalty_code,
             is_big_prize)
         VALUES
            (table_pay.applyflow_pay,
             table_pay.applyflow_sell,
             table_pay.game_code,
             table_pay.issue_number,          -- 兑奖期次
             table_pay.terminal_code,         -- 兑奖的
             table_pay.teller_code,           -- 兑奖的
             table_pay.agency_code,           -- 兑奖的
             table_pay.org_code,              -- 兑奖的
             table_pay.is_center,
             table_pay.paytime,
             table_pay.paycommissionrate,
             -- 某一个中奖期次
             table_win.issue_number,
             table_win.winningamounttax,
             table_win.winningamount,
             table_win.taxamount,
             table_pay.paycommissionrate * table_win.winningamounttax / 1000,
             table_win.PRIZE_COUNT,
             (case when table_win.IS_HD_PRIZE = 1 then table_win.winningamounttax else 0 end),
             (case when table_win.IS_HD_PRIZE = 1 then table_win.PRIZE_COUNT else 0 end),
             (case when table_win.IS_HD_PRIZE = 0 then table_win.winningamounttax else 0 end),
             (case when table_win.IS_HD_PRIZE = 0 then table_win.PRIZE_COUNT else 0 end),
             table_pay.loyalty_code,
             table_pay.is_big_prize);

      END LOOP;
   END LOOP;
*/
   -- 拼上单期票
   INSERT INTO tmp_multi_pay
      (applyflow_pay,
       applyflow_sell,
       game_code,
       issue_number,
       pay_issue_number,
       terminal_code,
       teller_code,
       agency_code,
       org_code,
       is_center,
       paytime,
       winningamounttax,
       winningamount,
       taxamount,
       paycommissionrate,
       commissionamount,
       winningcount,
       hd_winning,
       hd_count,
       ld_winning,
       ld_count,
       loyalty_code,
       is_big_prize)
      SELECT applyflow_pay,
             applyflow_sell,
             game_code,
             issue_number,
             pay_issue_number,
             terminal_code,
             teller_code,
             agency_code,
             org_code,
             is_center,
             paytime,
             winningamounttax,
             winningamount,
             taxamount,
             paycommissionrate,
             commissionamount,
             winningcount,
             hd_winning,
             hd_count,
             ld_winning,
             ld_count,
             loyalty_code,
             is_big_prize
        FROM tmp_src_pay
       WHERE applyflow_sell NOT IN (SELECT applyflow_sell
                                      FROM his_sellticket_multi_issue);

   /********************      取消票      *********************/
   -- 退票多期
   FOR table_cancel IN (SELECT *
                          FROM tmp_src_cancel
                         WHERE applyflow_sell IN (SELECT applyflow_sell
                                                    FROM his_sellticket_multi_issue)) LOOP
      -- 获取销售期的信息
      SELECT *
        INTO v_sell
        FROM his_sellticket
       WHERE applyflow_sell = table_cancel.applyflow_sell;
      FOR v_loop IN 1 .. v_sell.issue_count LOOP
         -- 计算期次编号
         SELECT issue_seq
           INTO v_issue_seq
           FROM tmp_all_issue
          WHERE game_code = v_sell.game_code
            AND issue_number = v_sell.issue_number;
         SELECT issue_number
           INTO v_issue
           FROM tmp_all_issue
          WHERE game_code = v_sell.game_code
            AND issue_seq = v_issue_seq + v_loop - 1;

         INSERT INTO tmp_multi_cancel
            (applyflow_cancel,
             canceltime,
             applyflow_sell,
             c_terminal_code,
             c_teller_code,
             c_agency_code,
             c_org_code,
             is_center,
             saletime,
             terminal_code,
             teller_code,
             agency_code,
             game_code,
             issue_number,
             ticket_amount,
             ticket_bet_count,
             salecommissionrate,
             commissionamount,
             bet_methold,
             bet_line,
             loyalty_code)
         VALUES
            (table_cancel.applyflow_cancel,
             table_cancel.canceltime,
             table_cancel.applyflow_sell,
             table_cancel.c_terminal_code,
             table_cancel.c_teller_code,
             table_cancel.c_agency_code,
             table_cancel.c_org_code,
             table_cancel.is_center,
             table_cancel.saletime,
             table_cancel.terminal_code,
             table_cancel.teller_code,
             table_cancel.agency_code,
             table_cancel.game_code,
             v_issue,
             table_cancel.ticket_amount / v_issue_count,
             table_cancel.ticket_bet_count / v_issue_count,
             table_cancel.salecommissionrate,
             table_cancel.commissionamount / v_issue_count,
             table_cancel.bet_methold,
             table_cancel.bet_line,
             table_cancel.loyalty_code);

      END LOOP;
   END LOOP;
   COMMIT;

   -- 拼单期
   INSERT INTO tmp_multi_cancel
      (applyflow_cancel,
       canceltime,
       applyflow_sell,
       c_terminal_code,
       c_teller_code,
       c_agency_code,
       c_org_code,
       is_center,
       saletime,
       terminal_code,
       teller_code,
       agency_code,
       game_code,
       issue_number,
       ticket_amount,
       ticket_bet_count,
       salecommissionrate,
       commissionamount,
       bet_methold,
       bet_line,
       loyalty_code)
      SELECT applyflow_cancel,
             canceltime,
             applyflow_sell,
             c_terminal_code,
             c_teller_code,
             c_agency_code,
             c_org_code,
             is_center,
             saletime,
             terminal_code,
             teller_code,
             agency_code,
             game_code,
             issue_number,
             ticket_amount,
             ticket_bet_count,
             salecommissionrate,
             commissionamount,
             bet_methold,
             bet_line,
             loyalty_code
        FROM tmp_src_cancel
       WHERE applyflow_sell NOT IN (SELECT applyflow_sell
                                      FROM his_sellticket_multi_issue);

  commit;
END;
 
/ 
prompt 正在建立[PROCEDURE -> p_mis_dss_40_gen_fact.sql ]...... 
CREATE OR REPLACE PROCEDURE p_mis_dss_40_gen_fact(p_settle_id IN NUMBER) IS
   v_rpt_day DATE;
BEGIN
   -- 2015/3/3 his_payticket 兑奖表中，入库的issue_number字段，是兑奖期，不再是买票期
   SELECT settle_date
     INTO v_rpt_day
     FROM his_day_settle
    WHERE settle_id = p_settle_id;
   /*****************************************************/
   /*******************  销售主题统计  ******************/
   -- 退票不能跨天出现，因此这里不考虑跨天出现退票的情况
   dbms_output.put_line('Calc sell ....');
   DELETE FROM sub_sell
    WHERE sale_date = to_char(v_rpt_day, 'yyyy-mm-dd');
   INSERT INTO sub_sell
      (sale_date,
       sale_week,
       sale_month,
       sale_quarter,
       sale_year,
       game_code,
       issue_number,
       sale_agency,
       sale_area,
       sale_teller,
       sale_terminal,
       bet_methold,
       loyalty_code,
       result_code,
       sale_amount,
       sale_bets,
       sale_commission,
       sale_tickets,
       sale_lines,
       pure_amount,
       pure_bets,
       pure_commission,
       pure_tickets,
       pure_lines,
       sale_amount_single_issue,
       sale_bets_single_issue,
       sale_commision_single_issue,
       pure_amount_single_issue,
       pure_bets_single_issue,
       pure_commision_single_issue)
      WITH
      /* 针对不区分多期，统计销售情况 */
      normal AS
       (SELECT sell.terminal_code,
               sell.teller_code,
               sell.agency_code,
               sell.game_code,
               sell.issue_number,
               sell.bet_methold,
               sell.loyalty_code,
               sell.result_code,
               -- 单期票
               nvl(SUM(sell.ticket_amount), 0)     AS sale_amount,
               nvl(SUM(sell.ticket_bet_count), 0)  AS sale_bets,
               nvl(SUM(sell.commissionamount), 0)  AS sale_commission,
               COUNT(applyflow_sell)               AS sale_tickets,
               nvl(SUM(sell.bet_line), 0)          AS sale_lines,
               -- 净销售额
               SUM(CASE WHEN can.applyflow_cancel IS NULL THEN sell.ticket_amount    ELSE 0 END) AS pure_amount,
               SUM(CASE WHEN can.applyflow_cancel IS NULL THEN sell.ticket_bet_count ELSE 0 END) AS pure_bets,
               SUM(CASE WHEN can.applyflow_cancel IS NULL THEN sell.commissionamount ELSE 0 END) AS pure_commission,
               SUM(CASE WHEN can.applyflow_cancel IS NULL THEN 1                     ELSE 0 END) AS pure_tickets,
               SUM(CASE WHEN can.applyflow_cancel IS NULL THEN sell.bet_line         ELSE 0 END) AS pure_lines,
               -- 多期票
               0                       AS sale_amount_single_issue,
               0                       AS sale_bets_single_issue,
               0                       AS sale_commision_single_issue,
               0                       AS PURE_AMOUNT_SINGLE_ISSUE,
               0                       AS PURE_BETS_SINGLE_ISSUE,
               0                       AS PURE_commision_SINGLE_ISSUE
          FROM tmp_src_sell sell
          LEFT JOIN tmp_src_cancel can
         USING (applyflow_sell)
         GROUP BY sell.terminal_code,
                  sell.teller_code,
                  sell.agency_code,
                  sell.game_code,
                  sell.issue_number,
                  sell.salecommissionrate,
                  sell.bet_methold,
                  sell.loyalty_code,
                  sell.result_code),
      /* 针对多期统计每一期销售 */
      multi AS
       (SELECT sell.terminal_code,
               sell.teller_code,
               sell.agency_code,
               game_code,
               issue_number,
               sell.bet_methold,
               sell.loyalty_code,
               sell.result_code,
               -- 单期票
               0 AS sale_amount,
               0 AS sale_bets,
               0 AS sale_commission,
               0 AS sale_tickets,
               0 AS sale_lines,
               0 AS pure_amount,
               0 AS pure_bets,
               0 AS pure_commission,
               0 AS pure_tickets,
               0 AS pure_lines,
               -- 多期票
               nvl(SUM(sell.ticket_amount), 0)           AS sale_amount_single_issue,
               nvl(SUM(sell.ticket_bet_count), 0)        AS sale_bets_single_issue,
               nvl(SUM(sell.commissionamount), 0)        AS sale_commision_single_issue,
               SUM(CASE WHEN can.applyflow_cancel IS NULL THEN sell.ticket_amount         ELSE 0 END)  AS PURE_AMOUNT_SINGLE_ISSUE,
               SUM(CASE WHEN can.applyflow_cancel IS NULL THEN sell.ticket_bet_count      ELSE 0 END)  AS PURE_BETS_SINGLE_ISSUE,
               SUM(CASE WHEN can.applyflow_cancel IS NULL THEN sell.commissionamount      ELSE 0 END)  AS PURE_commision_SINGLE_ISSUE
          FROM tmp_multi_sell sell
          LEFT JOIN tmp_multi_cancel can
         USING (applyflow_sell, game_code, issue_number)
         GROUP BY sell.terminal_code,
                  sell.teller_code,
                  sell.agency_code,
                  game_code,
                  issue_number,
                  sell.bet_methold,
                  sell.loyalty_code,
                  sell.result_code),
      /* 普通期统计结果与多期票统计结果合并 */
      total_data AS
       (SELECT game_code,
               issue_number,
               agency_code,
               area.agency_area_code AS area_code,
               teller_code,
               terminal_code,
               bet_methold,
               loyalty_code,
               result_code,
               SUM(sale_amount) AS sale_amount,
               SUM(sale_bets) AS sale_bets,
               SUM(sale_commission) AS sale_commission,
               SUM(sale_tickets) AS sale_tickets,
               SUM(sale_lines) AS sale_lines,
               SUM(pure_amount) AS pure_amount,
               SUM(pure_bets) AS pure_bets,
               SUM(pure_commission) AS pure_commission,
               SUM(pure_tickets) AS pure_tickets,
               SUM(pure_lines) AS pure_lines,
               SUM(sale_amount_single_issue) AS sale_amount_single_issue,
               SUM(sale_bets_single_issue) AS sale_bets_single_issue,
               SUM(sale_commision_single_issue) AS sale_commision_single_issue,
               SUM(PURE_AMOUNT_SINGLE_ISSUE) AS PURE_AMOUNT_SINGLE_ISSUE,
               SUM(PURE_BETS_SINGLE_ISSUE) AS PURE_BETS_SINGLE_ISSUE,
               SUM(pure_commision_single_issue) AS pure_commision_single_issue
          FROM (SELECT *
                  FROM normal
                UNION ALL
                SELECT *
                  FROM multi)
          JOIN v_mis_agency area
         USING (agency_code)
         GROUP BY game_code, issue_number, agency_code, area.agency_area_code, teller_code, terminal_code, bet_methold, loyalty_code, result_code)
      SELECT to_char(v_rpt_day, 'yyyy-mm-dd') AS sale_date,
             to_char(v_rpt_day, 'yyyy-ww') AS sale_week,
             to_char(v_rpt_day, 'yyyy-mm') AS sale_month,
             to_char(v_rpt_day, 'yyyy-q') AS sale_quarter,
             to_char(v_rpt_day, 'yyyy') AS sale_year,
             game_code,
             issue_number,
             agency_code,
             area_code,
             teller_code,
             terminal_code,
             bet_methold,
             loyalty_code,
             result_code,
             nvl(sale_amount, 0),
             nvl(sale_bets, 0),
             nvl(sale_commission, 0),
             nvl(sale_tickets, 0),
             nvl(sale_lines, 0),
             nvl(pure_amount, 0),
             nvl(pure_bets, 0),
             nvl(pure_commission, 0),
             nvl(pure_tickets, 0),
             nvl(pure_lines, 0),
             nvl(sale_amount_single_issue, 0),
             nvl(sale_bets_single_issue, 0),
             nvl(sale_commision_single_issue, 0),
             nvl(pure_amount_single_issue, 0),
             nvl(pure_bets_single_issue, 0),
             nvl(pure_commision_single_issue, 0)
        FROM total_data;
  dbms_output.put_line('p_mis_dss_40_gen_fact->sub_sell:' || sql%rowcount);
  COMMIT;

--modify by kwx 2016-5-12 将"ISSUE_NUMBER as pay_issue"修改为"PAY_ISSUE_NUMBER as pay_issue"
   /*****************************************************/
   /******************* 兑奖主题统计 ******************/
   dbms_output.put_line('Calc pay ....');
   DELETE FROM sub_pay
    WHERE pay_date = to_char(v_rpt_day, 'yyyy-mm-dd');
   INSERT INTO sub_pay
      (pay_date,
       pay_week,
       pay_month,
       pay_quarter,
       pay_year,
       game_code,
       issue_number,
       pay_issue,
       pay_agency,
       pay_area,
       pay_teller,
       pay_terminal,
       loyalty_code,
       is_gui_pay,
       is_big_one,
       pay_amount,
       pay_amount_without_tax,
       tax_amount,
       pay_bets,
       hd_pay_amount,
       hd_pay_amount_without_tax,
       hd_tax_amount,
       hd_pay_bets,
       ld_pay_amount,
       ld_pay_amount_without_tax,
       ld_tax_amount,
       ld_pay_bets,
       pay_commission,
       pay_tickets)
      WITH
      win_detail as
      (select applyflow_sell,
              SUM(hd_win_amount) AS hd_win_amount,
              SUM(hd_win_amount_without_tax) AS hd_win_amount_without_tax,
              SUM(hd_tax_amount) AS hd_tax_amount,
              SUM(hd_win_bets) AS hd_win_bets,
              SUM(ld_win_amount) AS ld_win_amount,
              SUM(ld_win_amount_without_tax) AS ld_win_amount_without_tax,
              SUM(ld_tax_amount) AS ld_tax_amount,
              SUM(ld_win_bets) AS ld_win_bets
         from his_win_ticket
        where applyflow_sell in (select applyflow_sell from tmp_src_pay)
        group by applyflow_sell),
      pay_detail as
      (select APPLYFLOW_PAY,
              APPLYFLOW_SELL,
              GAME_CODE,
              (select issue_number from his_sellticket where APPLYFLOW_SELL=main.APPLYFLOW_SELL) as ISSUE_NUMBER,
              ORG_CODE,
              TERMINAL_CODE,
              TELLER_CODE,
              AGENCY_CODE,
              PAYTIME,
              WINNINGAMOUNTTAX,
              WINNINGAMOUNT,
              TAXAMOUNT,
              PAYCOMMISSIONRATE,
              COMMISSIONAMOUNT,
              WINNINGCOUNT,
              HD_WINNING,
              HD_COUNT,
              LD_WINNING,
              LD_COUNT,
              LOYALTY_CODE,
              IS_BIG_PRIZE,
              PAY_ISSUE_NUMBER as pay_issue
         from tmp_src_pay main
      ),
      total_data AS
       (SELECT main.game_code,
               main.issue_number,
               main.pay_issue,
               main.agency_code,
               main.org_code,
               main.teller_code,
               main.terminal_code,
               main.loyalty_code,
               nvl2(gui.gui_pay_flow, 1, 0) AS is_gui_pay,
               main.is_big_prize AS is_big_one,
               SUM(winningamounttax) AS pay_amount,
               SUM(winningamount) AS pay_amount_without_tax,
               SUM(taxamount) AS tax_amount,
               SUM(winningcount) AS pay_bets,
               SUM(detail.hd_win_amount) AS hd_pay_amount,
               SUM(detail.hd_win_amount_without_tax) AS hd_pay_amount_without_tax,
               SUM(detail.hd_tax_amount) AS hd_tax_amount,
               SUM(detail.hd_win_bets) AS hd_pay_bets,
               SUM(detail.ld_win_amount) AS ld_pay_amount,
               SUM(detail.ld_win_amount_without_tax) AS ld_pay_amount_without_tax,
               SUM(detail.ld_tax_amount) AS ld_tax_amount,
               SUM(detail.ld_win_bets) AS ld_pay_bets,
               SUM(main.commissionamount) AS pay_commission,
               COUNT(main.applyflow_sell) AS pay_tickets
          FROM pay_detail main
          JOIN win_detail detail
            ON (main.applyflow_sell = detail.applyflow_sell)
          LEFT JOIN sale_gamepayinfo gui
            ON (main.applyflow_sell = gui.applyflow_sale AND gui.is_success = 1)
         GROUP BY main.game_code,
                  main.issue_number,
                  main.pay_issue,
                  main.terminal_code,
                  main.teller_code,
                  main.agency_code,
                  main.org_code,
                  main.loyalty_code,
                  nvl2(gui.gui_pay_flow, 1, 0),
                  main.is_big_prize)
      SELECT to_char(v_rpt_day, 'yyyy-mm-dd') AS pay_date,
             to_char(v_rpt_day, 'yyyy-ww') AS pay_week,
             to_char(v_rpt_day, 'yyyy-mm') AS pay_month,
             to_char(v_rpt_day, 'yyyy-q') AS pay_quarter,
             to_char(v_rpt_day, 'yyyy') AS pay_year,
             game_code,
             issue_number,
             pay_issue,
             agency_code,
             org_code,
             teller_code,
             terminal_code,
             loyalty_code,
             is_gui_pay,
             is_big_one,
             nvl(pay_amount, 0),
             nvl(pay_amount_without_tax, 0),
             nvl(tax_amount, 0),
             nvl(pay_bets, 0),
             nvl(hd_pay_amount, 0),
             nvl(hd_pay_amount_without_tax, 0),
             nvl(hd_tax_amount, 0),
             nvl(hd_pay_bets, 0),
             nvl(ld_pay_amount, 0),
             nvl(ld_pay_amount_without_tax, 0),
             nvl(ld_tax_amount, 0),
             nvl(ld_pay_bets, 0),
             nvl(pay_commission, 0),
             nvl(pay_tickets, 0)
        FROM total_data;
   dbms_output.put_line('p_mis_dss_40_gen_fact->sub_pay:' || sql%rowcount);
   COMMIT;

   /*****************************************************/
   /******************* 退票主题统计 ******************/
   dbms_output.put_line('Calc cancel ....');
   DELETE FROM sub_cancel
    WHERE cancel_date = to_char(v_rpt_day, 'yyyy-mm-dd');
   INSERT INTO sub_cancel
      (cancel_date,
       cancel_week,
       cancel_month,
       cancel_quarter,
       cancel_year,
       game_code,
       issue_number,
       cancel_agency,
       cancel_area,
       cancel_teller,
       cancel_terminal,
       SALE_AGENCY,
       SALE_AREA,
       SALE_TELLER,
       SALE_TERMINAL,
       loyalty_code,
       is_gui_pay,
       cancel_amount,
       cancel_bets,
       cancel_tickets,
       cancel_commission,
       cancel_lines)
      WITH
      total_data_detail AS
       (SELECT game_code,
               issue_number,
               c_agency_code AS CANCEL_AGENCY,
               c_org_code as cancel_area,
               c_teller_code AS CANCEL_TELLER,
               c_terminal_code AS CANCEL_TERMINAL,
               AGENCY_CODE as SALE_AGENCY,
               (select agency_area_code from v_mis_agency where can.agency_code = agency_code) as sale_area,
               teller_code as SALE_TELLER,
               terminal_code as SALE_TERMINAL,
               loyalty_code,
               (case when exists(select 1 from sale_cancelinfo where gui_cancel_flow=can.applyflow_sell AND is_success = 1) then 1 else 0 end) AS is_gui_pay,
               ticket_amount,
               ticket_bet_count,
               commissionamount,
               bet_line
          FROM tmp_src_cancel can),
      total_data as
      (select game_code,issue_number,cancel_agency,cancel_area,cancel_teller,cancel_terminal,sale_agency,sale_area,sale_teller,sale_terminal,loyalty_code,is_gui_pay,
              SUM(ticket_amount) AS cancel_amount,
              SUM(ticket_bet_count) AS cancel_bets,
              COUNT(*) AS cancel_tickets,
              SUM(commissionamount) AS cancel_commission,
              SUM(bet_line) AS cancel_lines
         from total_data_detail
        group by game_code,issue_number,cancel_agency,cancel_area,cancel_teller,cancel_terminal,sale_agency,sale_area,sale_teller,sale_terminal,loyalty_code,is_gui_pay
      )
      SELECT to_char(v_rpt_day, 'yyyy-mm-dd') AS cancel_date,
             to_char(v_rpt_day, 'yyyy-ww') AS cancel_week,
             to_char(v_rpt_day, 'yyyy-mm') AS cancel_month,
             to_char(v_rpt_day, 'yyyy-q') AS cancel_quarter,
             to_char(v_rpt_day, 'yyyy') AS cancel_year,
             game_code ,
             issue_number,
             cancel_agency  ,
             cancel_area  ,
             cancel_teller  ,
             cancel_terminal  ,
             sale_agency,
             sale_area,
             sale_teller,
             sale_terminal,
             loyalty_code,
             is_gui_pay,
             nvl(cancel_amount, 0),
             nvl(cancel_bets, 0),
             nvl(cancel_tickets, 0),
             nvl(cancel_commission, 0),
             nvl(cancel_lines, 0)
        FROM total_data;
  dbms_output.put_line('p_mis_dss_40_gen_fact->sub_cancel:' || sql%rowcount);
  COMMIT;

   /*****************************************************/
   /******************* 中奖主题统计 ******************/
   dbms_output.put_line('Calc win ....');
   DELETE FROM sub_win
    WHERE winning_date = to_char(v_rpt_day, 'yyyy-mm-dd');
   INSERT INTO sub_win
      (winning_date,
       winning_week,
       winning_month,
       winning_quarter,
       winning_year,
       game_code,
       issue_number,
       sale_agency,
       sale_area,
       sale_teller,
       sale_terminal,
       bet_methold,
       loyalty_code,
       is_big_one,
       win_amount,
       win_amount_without_tax,
       tax_amount,
       win_bets,
       hd_win_amount,
       hd_win_amount_without_tax,
       hd_tax_amount,
       hd_win_bets,
       ld_win_amount,
       ld_win_amount_without_tax,
       ld_tax_amount,
       ld_win_bets)
      WITH
      total_data AS
       (SELECT win.game_code,
               win.issue_number,
               win.agency_code,
               area.agency_area_code AS area_code,
               win.teller_code,
               win.terminal_code,
               sell.bet_methold,
               sell.loyalty_code,
               win.is_big_prize AS is_big_one,
               SUM(win_amount) AS win_amount,
               SUM(win_amount_without_tax) AS win_amount_without_tax,
               SUM(tax_amount) AS tax_amount,
               SUM(win_bets) AS win_bets,
               SUM(hd_win_amount) AS hd_win_amount,
               SUM(hd_win_amount_without_tax) AS hd_win_amount_without_tax,
               SUM(hd_tax_amount) AS hd_tax_amount,
               SUM(hd_win_bets) AS hd_win_bets,
               SUM(ld_win_amount) AS ld_win_amount,
               SUM(ld_win_amount_without_tax) AS ld_win_amount_without_tax,
               SUM(ld_tax_amount) AS ld_tax_amount,
               SUM(ld_win_bets) AS ld_win_bets
          FROM tmp_src_win win, his_sellticket sell, v_mis_agency area
         WHERE win.applyflow_sell = sell.applyflow_sell
           AND win.agency_code = area.agency_code
         GROUP BY win.game_code,
                  win.issue_number,
                  win.terminal_code,
                  win.teller_code,
                  win.agency_code,
                  area.agency_area_code,
                  sell.bet_methold,
                  sell.loyalty_code,
                  win.is_big_prize)
      SELECT to_char(v_rpt_day, 'yyyy-mm-dd') AS winning_date,
             to_char(v_rpt_day, 'yyyy-ww') AS winning_week,
             to_char(v_rpt_day, 'yyyy-mm') AS winning_month,
             to_char(v_rpt_day, 'yyyy-q') AS winning_quarter,
             to_char(v_rpt_day, 'yyyy') AS winning_year,
             game_code,
             issue_number,
             agency_code,
             area_code,
             teller_code,
             terminal_code,
             bet_methold,
             loyalty_code,
             is_big_one,
             nvl(win_amount, 0),
             nvl(win_amount_without_tax, 0),
             nvl(tax_amount, 0),
             nvl(win_bets, 0),
             nvl(hd_win_amount, 0),
             nvl(hd_win_amount_without_tax, 0),
             nvl(hd_tax_amount, 0),
             nvl(hd_win_bets, 0),
             nvl(ld_win_amount, 0),
             nvl(ld_win_amount_without_tax, 0),
             nvl(ld_tax_amount, 0),
             nvl(ld_win_bets, 0)
        FROM total_data;
  dbms_output.put_line('p_mis_dss_40_gen_fact->sub_win:' || sql%rowcount);
  COMMIT;

   /*****************************************************/
   /******************* 弃奖主题统计 ******************/
   dbms_output.put_line('Calc abandon ....');
   DELETE FROM sub_abandon
    WHERE abandon_date = to_char(v_rpt_day, 'yyyy-mm-dd');
   INSERT INTO sub_abandon
      (abandon_date,
       abandon_week,
       abandon_month,
       abandon_quarter,
       abandon_year,
       game_code,
       sale_issue,
       winning_issue,
       winning_date,
       sale_agency,
       sale_area,
       sale_teller,
       sale_terminal,
       bet_methold,
       loyalty_code,
       is_big_one,
       win_amount,
       win_amount_without_tax,
       tax_amount,
       win_bets,
       hd_win_amount,
       hd_win_amount_without_tax,
       hd_tax_amount,
       hd_win_bets,
       ld_win_amount,
       ld_win_amount_without_tax,
       ld_tax_amount,
       ld_win_bets)
      WITH
      total_data AS
       (SELECT sell.game_code,
               sell.issue_number as sale_issue,
               win_detail.issue_number as winning_issue,
               trunc(winning_time) as winning_date,
               sell.agency_code,
               area.org_code as area_code,
               sell.teller_code,
               sell.terminal_code,
               sell.bet_methold,
               sell.loyalty_code,
               sum(win_amount) as win_amount,
               sum(win_amount_without_tax) as win_amount_without_tax,
               sum(tax_amount) as tax_amount,
               sum(prize_count) as win_bets,
               sum(case when is_hd_prize = 1 then winningamounttax else 0 end)  as hd_win_amount,                             -- 税前奖金（高等奖）
               sum(case when is_hd_prize = 1 then winningamount    else 0 end)  as hd_win_amount_without_tax,                 -- 税后奖金（高等奖）
               sum(case when is_hd_prize = 1 then taxamount        else 0 end)  as hd_tax_amount,                             -- 缴税额  （高等奖）
               sum(case when is_hd_prize = 1 then prize_count      else 0 end)  as hd_win_bets,                               -- 中奖注数（高等奖）
               sum(case when is_hd_prize = 0 then winningamounttax else 0 end)  as ld_win_amount,                             -- 税前奖金（低等奖）
               sum(case when is_hd_prize = 0 then winningamount    else 0 end)  as ld_win_amount_without_tax,                 -- 税后奖金（低等奖）
               sum(case when is_hd_prize = 0 then taxamount        else 0 end)  as ld_tax_amount,                             -- 缴税额  （低等奖）
               sum(case when is_hd_prize = 0 then prize_count      else 0 end)  as ld_win_bets                                -- 中奖注数（低等奖）
          FROM tmp_src_abandon
          join his_sellticket sell using(applyflow_sell)
          join inf_agencys area on (sell.agency_code=area.agency_code)
          join his_win_ticket_detail win_detail using(applyflow_sell)
         GROUP BY sell.game_code,
                  sell.issue_number,
                  win_detail.issue_number,
                  trunc(winning_time),
                  sell.agency_code,
                  area.org_code,
                  sell.teller_code,
                  sell.terminal_code,
                  sell.bet_methold,
                  sell.loyalty_code)
      SELECT to_char(v_rpt_day, 'yyyy-mm-dd'),
             to_char(v_rpt_day, 'yyyy-ww'),
             to_char(v_rpt_day, 'yyyy-mm'),
             to_char(v_rpt_day, 'yyyy-q'),
             to_char(v_rpt_day, 'yyyy'),
             total_data.game_code,
             sale_issue,
             winning_issue,
             winning_date,
             agency_code,
             area_code,
             teller_code,
             terminal_code,
             bet_methold,
             loyalty_code,
             0,
             nvl(win_amount, 0),
             nvl(win_amount_without_tax, 0),
             nvl(tax_amount, 0),
             nvl(win_bets, 0),
             nvl(hd_win_amount, 0),
             nvl(hd_win_amount_without_tax, 0),
             nvl(hd_tax_amount, 0),
             nvl(hd_win_bets, 0),
             nvl(ld_win_amount, 0),
             nvl(ld_win_amount_without_tax, 0),
             nvl(ld_tax_amount, 0),
             nvl(ld_win_bets, 0)
        FROM total_data;
    dbms_output.put_line('p_mis_dss_40_gen_fact->sub_abandon:' || sql%rowcount);
  COMMIT;
END;
 
/ 
prompt 正在建立[PROCEDURE -> p_mis_dss_50_gen_rpt_3112.sql ]...... 
CREATE OR REPLACE PROCEDURE p_mis_dss_50_gen_rpt_3112(p_settle_id IN NUMBER) IS
   v_rpt_day DATE;
BEGIN
   SELECT settle_date
     INTO v_rpt_day
     FROM his_day_settle
    WHERE settle_id = p_settle_id;
   INSERT INTO tmp_rst_3112
      (purged_date, game_code, issue_number, winning_sum, hd_purged_amount, ld_purged_amount, hd_purged_sum, ld_purged_sum, purged_amount)
      WITH game_issue AS
       (
        /* 确定指定日期的弃奖游戏期次 */
        SELECT game_code, issue_number
          FROM tmp_aband_issue),
      abandon AS
       (
        /* 弃奖 */
        SELECT game_code,
                sale_issue issue_number,
                SUM(win_amount) AS win_amount,
                SUM(hd_win_amount) AS hd_win_amount,
                SUM(hd_win_bets) AS hd_win_bets,
                SUM(ld_win_amount) AS ld_win_amount,
                SUM(ld_win_bets) AS ld_win_bets
          FROM sub_abandon
         WHERE (game_code, sale_issue) IN (SELECT game_code, issue_number
                                               FROM game_issue)
         GROUP BY game_code, sale_issue),
      win AS
       (
        /* 中奖 */
        SELECT game_code, issue_number, SUM(win_amount) AS win_amount
          FROM sub_win
         WHERE (game_code, issue_number) IN (SELECT game_code, issue_number
                                               FROM game_issue)
         GROUP BY game_code, issue_number)
      /* 拼起来，插入数据 */
      SELECT trunc(v_rpt_day),
             game_code,
             issue_number,
             win.win_amount,
             abandon.hd_win_amount,
             abandon.ld_win_amount,
             abandon.hd_win_bets,
             abandon.ld_win_bets,
             abandon.win_amount
        FROM abandon
        JOIN win
       USING (game_code, issue_number);

   COMMIT;
END;
 
/ 
prompt 正在建立[PROCEDURE -> p_mis_dss_50_gen_rpt_3113.sql ]...... 
create or replace procedure p_mis_dss_50_gen_rpt_3113(p_settle_id in number) is
   v_rpt_day date;
begin
   select settle_date
     into v_rpt_day
     from his_day_settle
    where settle_id = p_settle_id;

   insert into tmp_rst_3113
      (game_code, issue_number, area_code, sale_sum, hd_winning_sum, hd_winning_amount, ld_winning_sum, ld_winning_amount, winning_sum)
      with game_issue as
       (
        /* 确定指定日期的中奖游戏期次 */
        select game_code, issue_number
          from tmp_win_issue),
      win_agency as
       ( /* 期次内的中奖统计，按照销售站统计 */
        select game_code,
               issue_number,
               sale_agency agency_code,
               sum(winningamounttax) as win_amount,
               sum(case when is_hd_prize = 1 then winningamounttax else 0 end) as hd_amount,
               sum(case when is_hd_prize = 1 then prize_count      else 0 end) as hd_bets,
               sum(case when is_hd_prize = 0 then winningamounttax else 0 end) as ld_amount,
               sum(case when is_hd_prize = 0 then prize_count      else 0 end) as ld_bets
          from his_win_ticket_detail
         where (game_code, issue_number) in (select game_code, issue_number
                                               from game_issue)
         group by game_code, issue_number, sale_agency),
      win as
      ( /* 期次内中奖，按照部门统计 */
       select game_code, issue_number, org_code sale_area, sum(win_amount) win_amount, sum(hd_amount) as hd_amount, sum(hd_bets) as hd_bets, sum(ld_amount) as ld_amount, sum(ld_bets) as ld_bets
         from win_agency
         join inf_agencys using (agency_code)
        group by game_code, issue_number, org_code),
      sell as
       ( /* 期次内的期销售额统计（多期票被拆分） */
        select game_code, issue_number, sale_area, sum(pure_amount_single_issue) as sale_amount
          from sub_sell
         where (game_code, issue_number) in (select game_code, issue_number from game_issue)
         group by game_code, issue_number, sale_area)
      select game_code,
             issue_number,
             sale_area,
             nvl(sell.sale_amount,0) sale_amount,
             nvl(win.hd_amount,0) hd_amount,
             nvl(win.hd_bets,0) hd_bets,
             nvl(win.ld_amount,0) ld_amount,
             nvl(win.ld_bets,0) ld_bets,
             nvl(win.win_amount,0) win_amount
        from sell
        left join win
       using (game_code, issue_number, sale_area);
   commit;

   -- 计算区域汇总数据
      insert into tmp_rst_3113
         (game_code,
          issue_number,
          area_code,
          sale_sum,
          hd_winning_sum,
          hd_winning_amount,
          ld_winning_sum,
          ld_winning_amount,
          winning_sum)
         select game_code,
                issue_number,
                area.father_area       as area,
                sum(sale_sum)          as sale_sum,
                sum(hd_winning_sum)    as hd_winning_sum,
                sum(hd_winning_amount) as hd_winning_amount,
                sum(ld_winning_sum)    as ld_winning_sum,
                sum(ld_winning_amount) as ld_winning_amount,
                sum(winning_sum)       as winning_sum
           from tmp_rst_3113 tab, v_mis_area area
          where tab.area_code = area.area_code
            and area.area_type = 1
          group by game_code, issue_number, area.father_area;
   commit;

   -- 更新区域名称
   update tmp_rst_3113
      set area_name =
          (select area_name
             from v_mis_area
            where area_code = tmp_rst_3113.area_code),
          winning_rate = winning_sum / (case when sale_sum=0 then 1 else sale_sum end ) * 10000;
   commit;
end; 
/ 
prompt 正在建立[PROCEDURE -> p_mis_dss_50_gen_rpt_3116.sql ]...... 
CREATE OR REPLACE PROCEDURE p_mis_dss_50_gen_rpt_3116(p_settle_id IN NUMBER) IS
   v_rpt_day DATE;
BEGIN
   SELECT settle_date
     INTO v_rpt_day
     FROM his_day_settle
    WHERE settle_id = p_settle_id;

   INSERT INTO TMP_RST_3116
      (count_date,
       agency_code,
       agency_type,
       area_code,
       area_name,
       game_code,
       issue_number,
       sale_sum,
       sale_comm_sum)
      WITH sell AS
       (
        /* 今天的销售站销售额 */
        SELECT sale_agency AS agency_code,
                game_code,
                issue_number,
                SUM(pure_amount_single_issue) AS sale_amount,
                SUM(pure_commision_single_issue) AS sale_commission
          FROM sub_sell
         WHERE sale_date = to_char(v_rpt_day, 'yyyy-mm-dd')
           and issue_number > 0
         GROUP BY sale_agency, game_code, issue_number),
      agency AS
       (SELECT agency_code, agency_type, agency_area_code, agency_area_name, game_code
          FROM v_mis_agency, inf_games)
      SELECT trunc(v_rpt_day),
             agency_code,
             agency.agency_type,
             agency.agency_area_code,
             agency.agency_area_name,
             game_code,
             nvl(issue_number, 0) as issue_number,
             nvl(sale_amount, 0) as sale_amount,
             nvl(sale_commission, 0) as sale_commission
        FROM agency
        LEFT JOIN sell
       USING (agency_code, game_code);

   COMMIT;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_mis_dss_50_gen_rpt_3117.sql ]...... 
create or replace procedure p_mis_dss_50_gen_rpt_3117
(p_settle_id       in number)
is
   v_rpt_day   date;

begin
   select settle_date into v_rpt_day from his_day_settle where settle_id=p_settle_id;

   -- 2.1.16.6 大奖兑付明细报表（mis_report_3117）
   delete from mis_report_3117
    where pay_time >= to_date(to_char(v_rpt_day,'yyyy-mm-dd')||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
      and pay_time < to_date(to_char(v_rpt_day+1,'yyyy-mm-dd')||' 00:00:00','yyyy-mm-dd hh24:mi:ss');

   insert into mis_report_3117 (pay_time,          game_code,              issue_number,
                                pay_amount,        pay_tax,                pay_amount_after_tax,
                                pay_tsn,           sale_tsn,               gui_pay_flow,
                                applyflow_sale,    winnername,             cert_type,
                                cert_no,           agency_code,            payer_admin)
   select pay_time,           game_code,           (select issue_number from his_sellticket where applyflow_sell = sale_gamepayinfo.applyflow_sale) as issue_number,
          pay_amount,         pay_tax,             pay_amount_after_tax,
          pay_tsn,            sale_tsn,            gui_pay_flow,
          applyflow_sale,     winnername,          cert_type,
          cert_no,            org_code,            payer_admin
     from sale_gamepayinfo
     join gp_static using(game_code)
    where is_success = 1
      and pay_time >= to_date(to_char(v_rpt_day,'yyyy-mm-dd')||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
      and pay_time < to_date(to_char(v_rpt_day+1,'yyyy-mm-dd')||' 00:00:00','yyyy-mm-dd hh24:mi:ss')
      and pay_amount >= limit_big_prize;

   insert into mis_report_3117 (
          pay_time, game_code, issue_number, pay_amount, pay_tax, pay_amount_after_tax,
          pay_tsn, sale_tsn, gui_pay_flow, applyflow_sale,
          winnername, cert_type, cert_no, agency_code, payer_admin)
   select paytime as pay_time, game_code, (select issue_number from his_sellticket where applyflow_sell = tmp_src_pay.applyflow_sell) as issue_number,
          winningamounttax as pay_amount, taxamount as pay_tax, winningamount as pay_amount_after_tax,
          null as pay_tsn, null as sale_tsn, applyflow_pay as gui_pay_flow, applyflow_sell as applyflow_sale,
          null as winnername, null as cert_type, null as cert_no, agency_code, null as payer_admin
     from tmp_src_pay
    where is_big_prize = 1
      and applyflow_sell not in (select applyflow_sale from mis_report_3117);
   commit;

end;
 
/ 
prompt 正在建立[PROCEDURE -> p_mis_dss_50_gen_rpt_3121.sql ]...... 
CREATE OR REPLACE PROCEDURE p_mis_dss_50_gen_rpt_3121(p_settle_id IN NUMBER) IS
   v_rpt_day DATE;
BEGIN
   SELECT settle_date
     INTO v_rpt_day
     FROM his_day_settle
    WHERE settle_id = p_settle_id;

   INSERT INTO tmp_rst_3121
      (sale_year, game_code, area_code, sale_sum)
      SELECT to_number(to_char(v_rpt_day, 'yyyy')), game_code, sale_area, SUM(pure_amount)
        FROM sub_sell
       WHERE sale_date = to_char(v_rpt_day, 'yyyy-mm-dd')
       GROUP BY game_code, sale_area;
   COMMIT;

   
/*   -- 计算区域汇总数据
   FOR v_n_area_type IN REVERSE 1 .. 2 LOOP
      INSERT INTO tmp_rst_3121
         (sale_year, game_code, area_code, sale_sum)
         SELECT sale_year, game_code, area.father_area, SUM(sale_sum)
           FROM tmp_rst_3121 tab, v_mis_area area
          WHERE tab.area_code = area.area_code
            AND area.area_type = v_n_area_type
          GROUP BY sale_year, game_code, area.father_area;
   END LOOP;
   COMMIT;*/

   -- 计算区域汇总数据
      INSERT INTO tmp_rst_3121
         (sale_year, game_code, area_code, sale_sum)
         SELECT sale_year, game_code, area.father_area, SUM(sale_sum)
           FROM tmp_rst_3121 tab, v_mis_area area
          WHERE tab.area_code = area.area_code
          GROUP BY sale_year, game_code, area.father_area;
   COMMIT;
   
   
   -- 按照月份做update
   CASE to_number(to_char(v_rpt_day, 'mm'))
      WHEN 1 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_1 = sale_sum;
      WHEN 2 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_2 = sale_sum;
      WHEN 3 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_3 = sale_sum;
      WHEN 4 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_4 = sale_sum;
      WHEN 5 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_5 = sale_sum;
      WHEN 6 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_6 = sale_sum;
      WHEN 7 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_7 = sale_sum;
      WHEN 8 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_8 = sale_sum;
      WHEN 9 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_9 = sale_sum;
      WHEN 10 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_10 = sale_sum;
      WHEN 11 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_11 = sale_sum;
      WHEN 12 THEN
         UPDATE tmp_rst_3121
            SET sale_sum_12 = sale_sum;
   END CASE;
   COMMIT;

   -- 更新区域名称
   UPDATE tmp_rst_3121
      SET area_name =
          (SELECT area_name
             FROM v_mis_area
            WHERE area_code = tmp_rst_3121.area_code);
   COMMIT;

END; 
/ 
prompt 正在建立[PROCEDURE -> p_mis_dss_50_gen_rpt_3122.sql ]...... 
CREATE OR REPLACE PROCEDURE p_mis_dss_50_gen_rpt_3122(p_settle_id IN NUMBER) IS
   v_rpt_day DATE;
BEGIN
   SELECT settle_date
     INTO v_rpt_day
     FROM his_day_settle
    WHERE settle_id = p_settle_id;

   INSERT INTO tmp_rst_3122
      (game_code, issue_number, area_code, sale_sum, cancel_sum, win_sum)
      WITH sell AS
       (
        /* 今天的销售站销售额 */
        SELECT game_code, issue_number, sale_area AS area_code, SUM(pure_amount_single_issue) AS sale_amount
          FROM sub_sell
         WHERE sale_date = to_char(v_rpt_day, 'yyyy-mm-dd')
         GROUP BY game_code, issue_number, sale_area),
      win AS
       (
        /* 今天的中奖 */
        SELECT game_code, issue_number, sale_area AS area_code, SUM(win_amount) AS win_amount
          FROM sub_win
         WHERE winning_date = to_char(v_rpt_day, 'yyyy-mm-dd')
         GROUP BY game_code, issue_number, sale_area),
      cancel AS
       (
        /* 今天的退票 */
        SELECT game_code, issue_number, sale_area AS area_code, SUM(cancel_amount) AS cancel_amount
          FROM sub_cancel
         WHERE cancel_date = to_char(v_rpt_day, 'yyyy-mm-dd')
         GROUP BY game_code, issue_number, sale_area)
      SELECT game_code, issue_number, area_code, nvl(sale_amount, 0), nvl(cancel_amount, 0), nvl(win_amount, 0)
        FROM sell
        FULL JOIN win
       USING (game_code, issue_number, area_code)
        FULL OUTER JOIN cancel
       USING (game_code, issue_number, area_code);

   COMMIT;

/*   -- 计算区域汇总数据
   FOR v_n_area_type IN REVERSE 1 .. 2 LOOP
      INSERT INTO tmp_rst_3122
         (game_code, issue_number, area_code, sale_sum, cancel_sum, win_sum)
         SELECT game_code, issue_number, area.father_area, SUM(sale_sum), SUM(cancel_sum), SUM(win_sum)
           FROM tmp_rst_3122 tab, v_mis_area area
          WHERE tab.area_code = area.area_code
            AND area.area_type = v_n_area_type
          GROUP BY game_code, issue_number, area.father_area;
   END LOOP;
   COMMIT;*/


   -- 计算区域汇总数据
      INSERT INTO tmp_rst_3122
         (game_code, issue_number, area_code, sale_sum, cancel_sum, win_sum)
         SELECT game_code, issue_number, area.father_area, SUM(sale_sum), SUM(cancel_sum), SUM(win_sum)
           FROM tmp_rst_3122 tab, v_mis_area area
          WHERE tab.area_code = area.area_code
            AND area.area_type = 1
          GROUP BY game_code, issue_number, area.father_area;
   COMMIT;
   
   
   -- 更新区域名称
   UPDATE tmp_rst_3122
      SET area_name =
          (SELECT area_name
             FROM v_mis_area
            WHERE area_code = tmp_rst_3122.area_code);
   COMMIT;
END; 
/ 
prompt 正在建立[PROCEDURE -> p_mis_dss_50_gen_rpt_3124.sql ]...... 
CREATE OR REPLACE PROCEDURE p_mis_dss_50_gen_rpt_3124(p_settle_id IN NUMBER) IS
  v_rpt_day DATE;
BEGIN
  SELECT settle_date
    INTO v_rpt_day
    FROM his_day_settle
   WHERE settle_id = p_settle_id;

  INSERT INTO tmp_rst_3124
    (game_code,
     pay_date,
     area_code,
     hd_payment_sum,
     hd_payment_amount,
     hd_payment_tax,
     ld_payment_sum,
     ld_payment_amount,
     ld_payment_tax,
     payment_sum)
    SELECT game_code,
           v_rpt_day,
           pay_area,
           SUM(hd_pay_amount_without_tax) AS h_amount,
           SUM(hd_pay_bets) AS h_bets,
           SUM(hd_tax_amount) AS h_tax,
           SUM(ld_pay_amount_without_tax) AS l_amount,
           SUM(ld_pay_bets) AS l_bets,
           SUM(ld_tax_amount) AS l_tax,
           SUM(pay_amount_without_tax) AS amount
      FROM sub_pay
     WHERE pay_date = to_char(v_rpt_day, 'yyyy-mm-dd')
     GROUP BY game_code, pay_area;

  -- 计算区域汇总数据
  merge into tmp_rst_3124 dest
  using (SELECT game_code,
                pay_date,
                '00' area_code,
                SUM(hd_payment_sum) hd_payment_sum,
                SUM(hd_payment_amount) hd_payment_amount,
                SUM(hd_payment_tax) hd_payment_tax,
                SUM(ld_payment_sum) ld_payment_sum,
                SUM(ld_payment_amount) ld_payment_amount,
                SUM(ld_payment_tax) ld_payment_tax,
                SUM(payment_sum) payment_sum
           FROM tmp_rst_3124
          WHERE area_code <> '00'
          GROUP BY game_code, pay_date) src
  on (dest.game_code = src.game_code and dest.pay_date = src.pay_date and dest.area_code = src.area_code)
  when matched then
    update
       set hd_payment_sum    = dest.hd_payment_sum + src.hd_payment_sum,
           hd_payment_amount = src.hd_payment_amount +
                               dest.hd_payment_amount,
           hd_payment_tax    = src.hd_payment_tax + dest.hd_payment_tax,
           ld_payment_sum    = src.ld_payment_sum + dest.ld_payment_sum,
           ld_payment_amount = src.ld_payment_amount +
                               dest.ld_payment_amount,
           ld_payment_tax    = src.ld_payment_tax + dest.ld_payment_tax,
           payment_sum       = src.payment_sum + dest.payment_sum
  when not matched then
    insert
      (game_code,
       pay_date,
       area_code,
       hd_payment_sum,
       hd_payment_amount,
       hd_payment_tax,
       ld_payment_sum,
       ld_payment_amount,
       ld_payment_tax,
       payment_sum)
    values
      (src.game_code,
       src.pay_date,
       src.area_code,
       src.hd_payment_sum,
       src.hd_payment_amount,
       src.hd_payment_tax,
       src.ld_payment_sum,
       src.ld_payment_amount,
       src.ld_payment_tax,
       src.payment_sum);

  COMMIT;

  -- 更新区域名称
  UPDATE tmp_rst_3124
     SET area_name =
         (SELECT area_name
            FROM v_mis_area
           WHERE area_code = tmp_rst_3124.area_code);
  COMMIT;
END;
 
/ 
prompt 正在建立[PROCEDURE -> p_mis_dss_50_gen_rpt_3125.sql ]...... 
CREATE OR REPLACE PROCEDURE p_mis_dss_50_gen_rpt_3125(p_settle_id IN NUMBER) IS
   v_rpt_day DATE;
BEGIN
   SELECT settle_date
     INTO v_rpt_day
     FROM his_day_settle
    WHERE settle_id = p_settle_id;

   INSERT INTO tmp_rst_3125
      (sale_date, game_code, area_code, sale_sum, sale_count, sale_bet)
      SELECT v_rpt_day, game_code, sale_area, SUM(pure_amount), SUM(pure_tickets), SUM(pure_bets)
        FROM sub_sell
       WHERE sale_date = to_char(v_rpt_day, 'yyyy-mm-dd')
       GROUP BY game_code, sale_area;
   COMMIT;

/*   -- 计算区域汇总数据
   FOR v_n_area_type IN REVERSE 1 .. 2 LOOP
      INSERT INTO tmp_rst_3125
         (sale_date, game_code, area_code, sale_sum, sale_count, sale_bet)
         SELECT sale_date, game_code, area.father_area, SUM(sale_sum), SUM(sale_count), SUM(sale_bet)
           FROM tmp_rst_3125 tab, v_mis_area area
          WHERE tab.area_code = area.area_code
            AND area.area_type = v_n_area_type
          GROUP BY sale_date, game_code, area.father_area;
   END LOOP;
   COMMIT;
*/
   
      -- 计算区域汇总数据
      INSERT INTO tmp_rst_3125
         (sale_date, game_code, area_code, sale_sum, sale_count, sale_bet)
         SELECT sale_date, game_code, area.father_area, SUM(sale_sum), SUM(sale_count), SUM(sale_bet)
           FROM tmp_rst_3125 tab, v_mis_area area
          WHERE tab.area_code = area.area_code
            AND area.area_type = 1
          GROUP BY sale_date, game_code, area.father_area;
   COMMIT;
   
   

   -- 更新区域名称
   UPDATE tmp_rst_3125
      SET area_name           =
          (SELECT area_name
             FROM v_mis_area
            WHERE area_code = tmp_rst_3125.area_code),
          single_ticket_amount = (case when sale_count=0 then 0 else sale_sum / sale_count end);
   COMMIT;
END; 
/ 
prompt 正在建立[PROCEDURE -> p_mis_dss_50_gen_rpt_aband.sql ]...... 
CREATE OR REPLACE PROCEDURE p_mis_dss_50_gen_rpt_aband(p_settle_id IN NUMBER) IS
   v_rpt_day DATE;
BEGIN
   SELECT settle_date
     INTO v_rpt_day
     FROM his_day_settle
    WHERE settle_id = p_settle_id;

   -- 奖等为-1的列，记录这个期次的弃奖总注数、总张数、金额；非-1时，记录各个奖等的注数和金额

   DELETE mis_report_gui_aband
    WHERE pay_date = v_rpt_day;
   INSERT INTO mis_report_gui_aband
      (pay_date, game_code, issue_number, prize_level, is_hd_prize, prize_bet_count, prize_ticket_count, winningamounttax, winningamount, taxamount)
      WITH issue AS
       ( -- 获取弃奖日的期次列表
        SELECT game_code, issue_number
          FROM TMP_ABAND_ISSUE),
      aband_data AS
       (
        -- 这一期的弃奖明细数据
        SELECT /*+ materialize */
         *
          FROM his_win_ticket_detail
         WHERE applyflow_sell IN (SELECT applyflow_sell
                                    FROM his_abandon_ticket
                                   where (game_code, issue_number) in (select game_code, issue_number from issue))),
      issue_data AS
       ( -- 期次弃奖数据
        SELECT trunc(v_rpt_day) AS pay_date,
                game_code,
                issue_number,
                -1 AS prize_level,
                0 AS is_hd_prize,
                SUM(prize_count) AS prize_bet_count,
                COUNT(DISTINCT applyflow_sell) AS prize_ticket_count,
                SUM(winningamounttax) AS winningamounttax,
                SUM(winningamount) AS winningamount,
                SUM(taxamount) AS taxamount
          FROM aband_data
         GROUP BY game_code, issue_number),
      prize_data AS
       ( -- 期次弃奖明细
        SELECT trunc(v_rpt_day) AS pay_date,
                game_code,
                issue_number,
                prize_level,
                is_hd_prize,
                SUM(prize_count) AS prize_bet_count,
                0 AS prize_ticket_count,
                SUM(winningamounttax) AS winningamounttax,
                SUM(winningamount) AS winningamount,
                SUM(taxamount) AS taxamount
          FROM aband_data
         GROUP BY game_code, issue_number, prize_level, is_hd_prize)
      -- 主查询
      SELECT nvl(pay_date, trunc(v_rpt_day)),
             game_code,
             issue_number,
             nvl(prize_level, -1),
             nvl(is_hd_prize, 0),
             nvl(prize_bet_count, 0),
             nvl(prize_ticket_count, 0),
             nvl(winningamounttax, 0),
             nvl(winningamount, 0),
             nvl(taxamount, 0)
        FROM issue
        LEFT JOIN issue_data
       USING (game_code, issue_number)
      UNION ALL
      SELECT pay_date,
             game_code,
             issue_number,
             prize_level,
             is_hd_prize,
             prize_bet_count,
             prize_ticket_count,
             winningamounttax,
             winningamount,
             taxamount
        FROM prize_data;
   COMMIT;
END;
 
/ 
prompt 正在建立[PROCEDURE -> p_mis_dss_50_gen_rpt_ncp.sql ]...... 
CREATE OR REPLACE PROCEDURE p_mis_dss_50_gen_rpt_ncp(p_settle_id IN NUMBER) IS
   v_rpt_day DATE;
BEGIN
   SELECT settle_date
     INTO v_rpt_day
     FROM his_day_settle
    WHERE settle_id = p_settle_id;

   INSERT INTO tmp_rst_ncp
      (count_date,
       agency_code,
       agency_type,
       area_code,
       area_name,
       game_code,
       issue_number,
       sale_sum,
       sale_count,
       cancel_sum,
       cancel_count,
       pay_sum,
       pay_count,
       sale_comm_sum,
       pay_comm_count)
      WITH sell AS
       (
        /* 今天的销售站销售额 */
        SELECT sale_agency AS agency_code,
                game_code,
                issue_number,
                SUM(pure_amount) AS sale_amount,
                SUM(pure_commission) AS sale_commission,
                SUM(pure_tickets) AS sale_tickets
          FROM sub_sell
         WHERE sale_date = to_char(v_rpt_day, 'yyyy-mm-dd')
           and issue_number > 0
         GROUP BY sale_agency, game_code, issue_number),
      pay AS
       (
        /* 今天的兑奖 */
        SELECT pay_agency AS agency_code,
                game_code,
                issue_number,
                SUM(pay_amount_without_tax) AS pay_amount,
                SUM(pay_commission) AS pay_commission,
                SUM(pay_tickets) AS pay_tickets
          FROM sub_pay
         WHERE pay_date = to_char(v_rpt_day, 'yyyy-mm-dd')
           and issue_number > 0
         GROUP BY pay_agency, game_code, issue_number),
      cancel AS
       (
        /* 今天的退票 */
        SELECT cancel_agency AS agency_code,
                game_code,
                issue_number,
                SUM(cancel_amount) AS cancel_amount,
                SUM(cancel_tickets) AS cancel_tickets
          FROM sub_cancel
         WHERE cancel_date = to_char(v_rpt_day, 'yyyy-mm-dd')
           and issue_number > 0
         GROUP BY cancel_agency, game_code, issue_number),
      agency AS
       (SELECT agency_code, agency_type, agency_area_code, agency_area_name, game_code
          FROM v_mis_agency, inf_games)
      SELECT trunc(v_rpt_day),
             agency_code,
             agency.agency_type,
             agency.agency_area_code,
             agency.agency_area_name,
             game_code,
             nvl(issue_number, 0),
             nvl(sale_amount, 0),
             nvl(sale_tickets, 0),
             nvl(cancel_amount, 0),
             nvl(cancel_tickets, 0),
             nvl(pay_amount, 0),
             nvl(pay_tickets, 0),
             nvl(sale_commission, 0),
             nvl(pay_commission, 0)
        FROM agency
        LEFT JOIN (SELECT agency_code,
                          game_code,
                          issue_number,
                          sale_amount,
                          sale_tickets,
                          cancel_amount,
                          cancel_tickets,
                          pay_amount,
                          pay_tickets,
                          sale_commission,
                          pay_commission
                     FROM sell
                     FULL OUTER JOIN pay
                    USING (agency_code, game_code, issue_number)
                     FULL OUTER JOIN cancel
                    USING (agency_code, game_code, issue_number))
       USING (agency_code, game_code);

   COMMIT;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_mis_dss_60_gen_rpt_merge_all.sql ]...... 
CREATE OR REPLACE PROCEDURE p_mis_dss_60_gen_rpt_merge_all(p_settle_id IN NUMBER) IS
   v_rpt_day DATE;
   v_exists  NUMBER(1);
   v_lastday_year number(4);
   v_lastday_mon  number(2);
   v_lastday_day  number(2);

   -- 发送消息内容
   v_sale number(28);
   v_pay number(28);
   v_aband number(28);

   v_sql varchar2(4000);
   v_msg varchar2(4000);

   -- for debug
   v_cnt number(10);

BEGIN
   SELECT settle_date
     INTO v_rpt_day
     FROM his_day_settle
    WHERE settle_id = p_settle_id;

   v_lastday_year := to_number(to_char(v_rpt_day,'yyyy'));
   v_lastday_mon := to_number(to_char(v_rpt_day,'mm'));
   v_lastday_day := to_number(to_char(v_rpt_day + 1,'dd'));

   -- 2.1.17.1 区域游戏销售统计表（MIS_REPORT_3111）
   DELETE FROM mis_report_3111
    WHERE sale_date = v_rpt_day;
   INSERT INTO mis_report_3111
      SELECT *
        FROM tmp_rst_3111;
   COMMIT;

   -- 2.1.17.2 弃奖统计日报表（MIS_REPORT_3112）
   DELETE FROM mis_report_3112
    WHERE purged_date = v_rpt_day;
   INSERT INTO mis_report_3112
      SELECT *
        FROM tmp_rst_3112;
   COMMIT;

   -- 2.1.17.3 区域中奖统计表（MIS_REPORT_3113）
   SELECT COUNT(*)
     INTO v_exists
     FROM dual
    WHERE EXISTS (SELECT 1
             FROM calc_rst_3113
            WHERE calc_date = v_rpt_day);
   IF v_exists = 1 THEN
      UPDATE mis_report_3113 dest
         SET sale_sum          = sale_sum - nvl((SELECT sale_sum
                                                  FROM calc_rst_3113
                                                 WHERE dest.game_code = game_code
                                                   AND dest.issue_number = issue_number
                                                   AND dest.area_code = area_code
                                                   AND calc_date = v_rpt_day),
                                                0),
             hd_winning_sum    = hd_winning_sum - nvl((SELECT hd_winning_sum
                                                        FROM calc_rst_3113
                                                       WHERE dest.game_code = game_code
                                                         AND dest.issue_number = issue_number
                                                         AND dest.area_code = area_code
                                                         AND calc_date = v_rpt_day),
                                                      0),
             hd_winning_amount = hd_winning_sum - nvl((SELECT hd_winning_sum
                                                        FROM calc_rst_3113
                                                       WHERE dest.game_code = game_code
                                                         AND dest.issue_number = issue_number
                                                         AND dest.area_code = area_code
                                                         AND calc_date = v_rpt_day),
                                                      0),
             ld_winning_sum    = hd_winning_sum - nvl((SELECT hd_winning_sum
                                                        FROM calc_rst_3113
                                                       WHERE dest.game_code = game_code
                                                         AND dest.issue_number = issue_number
                                                         AND dest.area_code = area_code
                                                         AND calc_date = v_rpt_day),
                                                      0),
             ld_winning_amount = hd_winning_sum - nvl((SELECT hd_winning_sum
                                                        FROM calc_rst_3113
                                                       WHERE dest.game_code = game_code
                                                         AND dest.issue_number = issue_number
                                                         AND dest.area_code = area_code
                                                         AND calc_date = v_rpt_day),
                                                      0),
             winning_sum       = winning_sum - nvl((SELECT hd_winning_sum
                                                        FROM calc_rst_3113
                                                       WHERE dest.game_code = game_code
                                                         AND dest.issue_number = issue_number
                                                         AND dest.area_code = area_code
                                                         AND calc_date = v_rpt_day),
                                                      0),
             winning_rate     =
             (CASE
                WHEN nvl((sale_sum - nvl((SELECT sale_sum
                                           FROM calc_rst_3113
                                          WHERE dest.game_code = game_code
                                            AND dest.issue_number = issue_number
                                            AND dest.area_code = area_code
                                            AND calc_date = v_rpt_day),
                                         0)),
                         0) = 0 THEN
                 0
                ELSE
                 (winning_sum - nvl((SELECT winning_sum
                                         FROM calc_rst_3113
                                        WHERE dest.game_code = game_code
                                          AND dest.issue_number = issue_number
                                          AND dest.area_code = area_code
                                          AND calc_date = v_rpt_day),
                                       0)) / nvl((sale_sum - nvl((SELECT sale_sum
                                                                   FROM calc_rst_3113
                                                                  WHERE dest.game_code = game_code
                                                                    AND dest.issue_number = issue_number
                                                                    AND dest.area_code = area_code
                                                                    AND calc_date = v_rpt_day),
                                                                 0)),
                                                 0)
             END) * 10000
       WHERE (game_code, issue_number, area_code) IN (SELECT game_code, issue_number, area_code
                                                        FROM calc_rst_3113
                                                       WHERE calc_date = v_rpt_day);
      DELETE FROM calc_rst_3113
       WHERE calc_date = v_rpt_day;
   END IF;
   MERGE INTO mis_report_3113 dest
   USING tmp_rst_3113 src
   ON (dest.game_code = src.game_code AND dest.issue_number = src.issue_number AND dest.area_code = src.area_code)
   WHEN MATCHED THEN
      UPDATE
         SET sale_sum          = dest.sale_sum + src.sale_sum,
             hd_winning_sum    = dest.hd_winning_sum + src.hd_winning_sum,
             hd_winning_amount = dest.hd_winning_amount + src.hd_winning_amount,
             ld_winning_sum    = dest.ld_winning_sum + src.ld_winning_sum,
             ld_winning_amount = dest.ld_winning_amount + src.ld_winning_amount,
             winning_sum       = dest.winning_sum + src.winning_sum,
             winning_rate     =
             (CASE
                WHEN (dest.sale_sum + src.sale_sum) = 0 THEN
                 0
                ELSE
                 (dest.winning_sum + src.winning_sum) / (dest.sale_sum + src.sale_sum)
             END) * 10000
   WHEN NOT MATCHED THEN
      INSERT(game_code, issue_number, area_code, area_name, sale_sum, hd_winning_sum, hd_winning_amount, ld_winning_sum, ld_winning_amount, winning_sum, winning_rate)
      VALUES(src.game_code, src.issue_number, src.area_code, src.area_name, src.sale_sum, src.hd_winning_sum, src.hd_winning_amount, src.ld_winning_sum, src.ld_winning_amount, src.winning_sum, src.winning_rate);
   COMMIT;
   INSERT INTO calc_rst_3113
      SELECT game_code,
             issue_number,
             area_code,
             area_name,
             sale_sum,
             hd_winning_sum,
             hd_winning_amount,
             ld_winning_sum,
             ld_winning_amount,
             winning_sum,
             winning_rate,
             v_rpt_day
        FROM tmp_rst_3113;
   COMMIT;

   -- 2.1.17.6 销售站游戏期次报表（MIS_REPORT_NCP）
   DELETE FROM mis_report_ncp
    WHERE count_date = v_rpt_day;
   INSERT INTO mis_report_ncp
      SELECT *
        FROM tmp_rst_ncp;
   COMMIT;

   -- 2.1.17.7 销售年报（MIS_REPORT_3121）
   SELECT COUNT(*)
     INTO v_exists
     FROM dual
    WHERE EXISTS (SELECT 1
             FROM calc_rst_3121
            WHERE calc_date = v_rpt_day);
   IF v_exists = 1 THEN
      UPDATE mis_report_3121 dest
         SET sale_sum    = sale_sum - nvl((SELECT sale_sum
                                            FROM calc_rst_3121 src
                                           WHERE dest.game_code = src.game_code
                                             AND dest.area_code = src.area_code
                                             AND dest.sale_year = src.sale_year
                                             AND src.calc_date = v_rpt_day),
                                          0),
             sale_sum_1  = sale_sum_1 - nvl((SELECT sale_sum_1
                                              FROM calc_rst_3121 src
                                             WHERE dest.game_code = src.game_code
                                               AND dest.area_code = src.area_code
                                               AND dest.sale_year = src.sale_year
                                               AND src.calc_date = v_rpt_day),
                                            0),
             sale_sum_2  = sale_sum_2 - nvl((SELECT sale_sum_2
                                              FROM calc_rst_3121 src
                                             WHERE dest.game_code = src.game_code
                                               AND dest.area_code = src.area_code
                                               AND dest.sale_year = src.sale_year
                                               AND src.calc_date = v_rpt_day),
                                            0),
             sale_sum_3  = sale_sum_3 - nvl((SELECT sale_sum_3
                                              FROM calc_rst_3121 src
                                             WHERE dest.game_code = src.game_code
                                               AND dest.area_code = src.area_code
                                               AND dest.sale_year = src.sale_year
                                               AND src.calc_date = v_rpt_day),
                                            0),
             sale_sum_4  = sale_sum_4 - nvl((SELECT sale_sum_4
                                              FROM calc_rst_3121 src
                                             WHERE dest.game_code = src.game_code
                                               AND dest.area_code = src.area_code
                                               AND dest.sale_year = src.sale_year
                                               AND src.calc_date = v_rpt_day),
                                            0),
             sale_sum_5  = sale_sum_5 - nvl((SELECT sale_sum_5
                                              FROM calc_rst_3121 src
                                             WHERE dest.game_code = src.game_code
                                               AND dest.area_code = src.area_code
                                               AND dest.sale_year = src.sale_year
                                               AND src.calc_date = v_rpt_day),
                                            0),
             sale_sum_6  = sale_sum_6 - nvl((SELECT sale_sum_6
                                              FROM calc_rst_3121 src
                                             WHERE dest.game_code = src.game_code
                                               AND dest.area_code = src.area_code
                                               AND dest.sale_year = src.sale_year
                                               AND src.calc_date = v_rpt_day),
                                            0),
             sale_sum_7  = sale_sum_7 - nvl((SELECT sale_sum_7
                                              FROM calc_rst_3121 src
                                             WHERE dest.game_code = src.game_code
                                               AND dest.area_code = src.area_code
                                               AND dest.sale_year = src.sale_year
                                               AND src.calc_date = v_rpt_day),
                                            0),
             sale_sum_8  = sale_sum_8 - nvl((SELECT sale_sum_8
                                              FROM calc_rst_3121 src
                                             WHERE dest.game_code = src.game_code
                                               AND dest.area_code = src.area_code
                                               AND dest.sale_year = src.sale_year
                                               AND src.calc_date = v_rpt_day),
                                            0),
             sale_sum_9  = sale_sum_9 - nvl((SELECT sale_sum_9
                                              FROM calc_rst_3121 src
                                             WHERE dest.game_code = src.game_code
                                               AND dest.area_code = src.area_code
                                               AND dest.sale_year = src.sale_year
                                               AND src.calc_date = v_rpt_day),
                                            0),
             sale_sum_10 = sale_sum_10 - nvl((SELECT sale_sum_10
                                               FROM calc_rst_3121 src
                                              WHERE dest.game_code = src.game_code
                                                AND dest.area_code = src.area_code
                                                AND dest.sale_year = src.sale_year
                                                AND src.calc_date = v_rpt_day),
                                             0),
             sale_sum_11 = sale_sum_11 - nvl((SELECT sale_sum_11
                                               FROM calc_rst_3121 src
                                              WHERE dest.game_code = src.game_code
                                                AND dest.area_code = src.area_code
                                                AND dest.sale_year = src.sale_year
                                                AND src.calc_date = v_rpt_day),
                                             0),
             sale_sum_12 = sale_sum_12 - nvl((SELECT sale_sum_12
                                               FROM calc_rst_3121 src
                                              WHERE dest.game_code = src.game_code
                                                AND dest.area_code = src.area_code
                                                AND dest.sale_year = src.sale_year
                                                AND src.calc_date = v_rpt_day),
                                             0)
       WHERE (game_code, area_code, sale_year) IN (SELECT game_code, area_code, sale_year
                                                     FROM calc_rst_3121
                                                    WHERE calc_date = v_rpt_day);
      DELETE FROM calc_rst_3121
       WHERE calc_date = v_rpt_day;
   END IF;

   select count(*) into v_cnt from tmp_rst_3121 where sale_sum > 0;
   dbms_output.put_line('tmp_rst_3121 count is  '||v_cnt);
   select count(*) into v_cnt from mis_report_3121 where sale_sum > 0;
   dbms_output.put_line('mis_report_3121 count is  '||v_cnt);

   MERGE INTO mis_report_3121 dest
   USING tmp_rst_3121 src
   ON (dest.game_code = src.game_code AND dest.area_code = src.area_code AND dest.sale_year = src.sale_year)
   WHEN MATCHED THEN
      UPDATE
         SET sale_sum    = dest.sale_sum + src.sale_sum,
             sale_sum_1  = dest.sale_sum_1 + src.sale_sum_1,
             sale_sum_2  = dest.sale_sum_2 + src.sale_sum_2,
             sale_sum_3  = dest.sale_sum_3 + src.sale_sum_3,
             sale_sum_4  = dest.sale_sum_4 + src.sale_sum_4,
             sale_sum_5  = dest.sale_sum_5 + src.sale_sum_5,
             sale_sum_6  = dest.sale_sum_6 + src.sale_sum_6,
             sale_sum_7  = dest.sale_sum_7 + src.sale_sum_7,
             sale_sum_8  = dest.sale_sum_8 + src.sale_sum_8,
             sale_sum_9  = dest.sale_sum_9 + src.sale_sum_9,
             sale_sum_10 = dest.sale_sum_10 + src.sale_sum_10,
             sale_sum_11 = dest.sale_sum_11 + src.sale_sum_11,
             sale_sum_12 = dest.sale_sum_12 + src.sale_sum_12
   WHEN NOT MATCHED THEN
      INSERT
         (game_code,
          area_code,
          sale_year,
          area_name,
          sale_sum,
          sale_sum_1,
          sale_sum_2,
          sale_sum_3,
          sale_sum_4,
          sale_sum_5,
          sale_sum_6,
          sale_sum_7,
          sale_sum_8,
          sale_sum_9,
          sale_sum_10,
          sale_sum_11,
          sale_sum_12)
      VALUES
         (src.game_code,
          src.area_code,
          src.sale_year,
          src.area_name,
          src.sale_sum,
          src.sale_sum_1,
          src.sale_sum_2,
          src.sale_sum_3,
          src.sale_sum_4,
          src.sale_sum_5,
          src.sale_sum_6,
          src.sale_sum_7,
          src.sale_sum_8,
          src.sale_sum_9,
          src.sale_sum_10,
          src.sale_sum_11,
          src.sale_sum_12);
   COMMIT;

   select count(*) into v_cnt from mis_report_3121 where sale_sum > 0;
   dbms_output.put_line('mis_report_3121 count is  '||v_cnt);

   INSERT INTO calc_rst_3121
      SELECT sale_year,
             game_code,
             area_code,
             area_name,
             sale_sum,
             sale_sum_1,
             sale_sum_2,
             sale_sum_3,
             sale_sum_4,
             sale_sum_5,
             sale_sum_6,
             sale_sum_7,
             sale_sum_8,
             sale_sum_9,
             sale_sum_10,
             sale_sum_11,
             sale_sum_12,
             v_rpt_day
        FROM tmp_rst_3121;
   COMMIT;

   -- 2.1.17.8 区域游戏期销售、退票与中奖表（MIS_REPORT_3122）
   SELECT COUNT(*)
     INTO v_exists
     FROM dual
    WHERE EXISTS (SELECT 1
             FROM calc_rst_3122
            WHERE calc_date = v_rpt_day);
   IF v_exists = 1 THEN
      UPDATE mis_report_3122 dest
         SET sale_sum   = sale_sum - nvl((SELECT sale_sum
                                           FROM calc_rst_3122
                                          WHERE calc_date = v_rpt_day
                                            AND dest.game_code = game_code
                                            AND dest.issue_number = issue_number
                                            AND dest.area_code = area_code),
                                         0),
             cancel_sum = cancel_sum - nvl((SELECT cancel_sum
                                             FROM calc_rst_3122
                                            WHERE calc_date = v_rpt_day
                                              AND dest.game_code = game_code
                                              AND dest.issue_number = issue_number
                                              AND dest.area_code = area_code),
                                           0),
             win_sum    = win_sum - nvl((SELECT win_sum
                                          FROM calc_rst_3122
                                         WHERE calc_date = v_rpt_day
                                           AND dest.game_code = game_code
                                           AND dest.issue_number = issue_number
                                           AND dest.area_code = area_code),
                                        0)
       WHERE (game_code, issue_number, area_code) IN (SELECT game_code, issue_number, area_code
                                                        FROM calc_rst_3122
                                                       WHERE calc_date = v_rpt_day);
      DELETE calc_rst_3122
       WHERE calc_date = v_rpt_day;
   END IF;
   MERGE INTO mis_report_3122 dest
   USING tmp_rst_3122 src
   ON (dest.game_code = src.game_code AND dest.issue_number = src.issue_number AND dest.area_code = src.area_code)
   WHEN MATCHED THEN
      UPDATE
         SET sale_sum = dest.sale_sum + src.sale_sum, cancel_sum = dest.cancel_sum + src.cancel_sum, win_sum = dest.win_sum + src.win_sum
   WHEN NOT MATCHED THEN
      INSERT
         (game_code, issue_number, area_code, area_name, sale_sum, cancel_sum, win_sum)
      VALUES
         (src.game_code, src.issue_number, src.area_code, src.area_name, src.sale_sum, src.cancel_sum, src.win_sum);
   COMMIT;
   INSERT INTO calc_rst_3122
      SELECT game_code, issue_number, area_code, area_name, sale_sum, cancel_sum, win_sum, v_rpt_day
        FROM tmp_rst_3122;
   COMMIT;

   -- 2.1.17.9 区域游戏兑奖统计日报表（MIS_REPORT_3123）
   DELETE FROM mis_report_3123
    WHERE pay_date = v_rpt_day;
   INSERT INTO mis_report_3123
      SELECT *
        FROM tmp_rst_3123;
   COMMIT;

   -- 2.1.17.10 高等奖兑奖统计表（MIS_REPORT_3124）
   DELETE FROM mis_report_3124
    WHERE pay_date = v_rpt_day;
   INSERT INTO mis_report_3124
      SELECT *
        FROM tmp_rst_3124;
   COMMIT;

   -- 2.1.17.11 区域游戏销售汇总表（MIS_REPORT_3125）
   DELETE FROM mis_report_3125
    WHERE sale_date = v_rpt_day;
   INSERT INTO mis_report_3125
      SELECT *
        FROM tmp_rst_3125;
   COMMIT;

   -- 当天销售情况发送
   select sum(SALE_SUM) into v_sale from tmp_rst_3111 where area_code=0;
   v_sale := nvl(v_sale,0);
   select sum(PAYMENT_SUM) into v_pay from tmp_rst_3123 where area_code=0;
   v_pay := nvl(v_pay,0);
   select sum(PURGED_AMOUNT) into v_aband from tmp_rst_3112;
   v_aband := nvl(v_aband,0);

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_mis_dss_run.sql ]...... 
create or replace procedure p_mis_dss_run(
   p_settle_id NUMBER,
   p_is_maintance NUMBER default 0
) is
   v_desc varchar2(1000);
   v_rec_date date;
   v_rpt_day DATE;
begin
  SELECT settle_date
    INTO v_rpt_day
    FROM his_day_settle
   WHERE settle_id = p_settle_id;

  v_rec_date := sysdate;
  v_desc := 'MIS开始日结. SettleID ['||p_settle_id||'] Settle Target Date ['||to_char(v_rpt_day,'yyyy-mm-dd')||'] Start time: ['||to_char(v_rec_date, 'yyyy-mm-dd hh24:mi:ss')||']';
  p_mis_set_log(1,v_desc);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_00_prepare]';
  dbms_output.put_line(v_desc);
  p_mis_dss_00_prepare;

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_05_gen_winning]';
  dbms_output.put_line(v_desc);
  p_mis_dss_05_gen_winning(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_10_gen_abandon]';
  dbms_output.put_line(v_desc);
  p_mis_dss_10_gen_abandon(p_settle_id, p_is_maintance);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_13_gen_his_dict]';
  dbms_output.put_line(v_desc);
  p_mis_dss_13_gen_his_dict(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_20_gen_tmp_src]';
  dbms_output.put_line(v_desc);
  p_mis_dss_20_gen_tmp_src(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_30_gen_multi_issue]';
  dbms_output.put_line(v_desc);
  p_mis_dss_30_gen_multi_issue;

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_40_gen_fact]';
  dbms_output.put_line(v_desc);
  p_mis_dss_40_gen_fact(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_50_gen_rpt_3112]';
  dbms_output.put_line(v_desc);
  p_mis_dss_50_gen_rpt_3112(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_50_gen_rpt_3113]';
  dbms_output.put_line(v_desc);
  p_mis_dss_50_gen_rpt_3113(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_50_gen_rpt_3116]';
  dbms_output.put_line(v_desc);
  p_mis_dss_50_gen_rpt_3116(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_50_gen_rpt_3117]';
  dbms_output.put_line(v_desc);
  p_mis_dss_50_gen_rpt_3117(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_50_gen_rpt_3121]';
  dbms_output.put_line(v_desc);
  p_mis_dss_50_gen_rpt_3121(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_50_gen_rpt_3122]';
  dbms_output.put_line(v_desc);
  p_mis_dss_50_gen_rpt_3122(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_50_gen_rpt_3124]';
  dbms_output.put_line(v_desc);
  p_mis_dss_50_gen_rpt_3124(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_50_gen_rpt_3125]';
  dbms_output.put_line(v_desc);
  p_mis_dss_50_gen_rpt_3125(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_50_gen_rpt_aband]';
  dbms_output.put_line(v_desc);
  p_mis_dss_50_gen_rpt_aband(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_50_gen_rpt_ncp]';
  dbms_output.put_line(v_desc);
  p_mis_dss_50_gen_rpt_ncp(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_60_gen_rpt_merge_all]';
  dbms_output.put_line(v_desc);
  p_mis_dss_60_gen_rpt_merge_all(p_settle_id);

  p_mis_set_log(1,'MIS日结成功. 执行时长: [ '||trunc((sysdate-v_rec_date)*24*60*60)||'秒 ]');

exception
  when others then
    p_mis_set_log(1,'MIS日结失败. 停止在步骤 ['||v_desc||']. 执行时长: [ '||trunc((sysdate-v_rec_date)*24*60*60)||'秒 ] 失败原因: '||sqlerrm);
    dbms_output.put_line('MIS日结失败. 停止在步骤 ['||v_desc||']. 执行时长: [ '||trunc((sysdate-v_rec_date)*24*60*60)||'秒 ] 失败原因: '||sqlerrm);
end;
 
/ 
prompt 正在建立[PROCEDURE -> p_mis_set_day_close.sql ]...... 
CREATE OR REPLACE PROCEDURE p_mis_set_day_close
/***************************************************************
   ------------------- 设置日结标志 -------------------
   ************************************************************/
(
 --------------输入----------------
 p_settle_day IN DATE, --日结日期
 ---------出口参数---------
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述
 ) IS
   v_now_settle_id NUMBER(10);
   v_sql    VARCHAR2(1000);

   v_desc varchar2(1000);
   v_rec_date date;

BEGIN
   --初始化数据
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   INSERT INTO his_day_settle
      (settle_id, opt_date, settle_date, sell_seq, cancel_seq, pay_seq, win_seq)
   VALUES
      (f_get_his_settle_seq, SYSDATE, p_settle_day, f_get_his_sell_seq, f_get_his_cancel_seq, f_get_his_pay_seq, f_get_his_win_seq)
   RETURNING settle_id INTO v_now_settle_id;
   COMMIT;

   -- 拼接SQL，调用存储过程运行
   v_sql := 'begin p_mis_dss_run('||to_char(v_now_settle_id)||'); p_time_gen_by_day; end;';

   -- 开启job任务
   v_desc := '调用 [日结任务]';
   p_mis_set_log(1,'日结-----] '||v_desc||'.......');
   v_rec_date := sysdate;
   dbms_scheduler.create_job(job_name   => 'JOB_MIS_DAY_SETTLE_'||to_char(p_settle_day,'yyyymmdd'),
                             job_type   => 'PLSQL_BLOCK',
--                             job_class  => 'MIS_JOB_CLASS',
                             job_action => v_sql,
                             enabled    => TRUE);
   


   p_mis_set_log(1,'日结-----] '||v_desc||'成功. 执行时长: [ '||trunc((sysdate-v_rec_date)*24*60*60)||'秒 ]');

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);
      if v_desc is not null then
         p_mis_set_log(1,'日结-----] '||v_desc||'失败. 执行时长: [ '||trunc((sysdate-v_rec_date)*24*60*60)||'秒 ] 失败原因: '||sqlerrm);
      end if;

END; 
/ 
prompt 正在建立[PROCEDURE -> p_mis_set_log.sql ]...... 
CREATE OR REPLACE PROCEDURE p_mis_set_log
/***************************************************************
   ------------------- 记录日志 -------------------
   ************************************************************/
(
 --------------输入----------------
 p_log_type in number, -- 日志类型
 p_desc IN varchar2    -- 描述
 ) IS

   -- 同步数据
   v_param     VARCHAR2(200);
   v_ip        VARCHAR2(200);
   v_user      VARCHAR2(200);
   v_pass      VARCHAR2(200);
   v_url       VARCHAR2(200);
   v_c_errorcode NUMBER(10);
   v_c_errormesg VARCHAR2(1000);


   v_log_id    number(28);
   v_log_log_time varchar2(50);

   v_log_desc  varchar2(4000);

BEGIN

   v_log_desc := p_desc;

   -- 本地化
   v_log_desc := replace(v_log_desc, '中奖明细数据入库', 'insert the winning data to DB');
   v_log_desc := replace(v_log_desc, '开始日结', 'Daily Settlement Started');
   v_log_desc := replace(v_log_desc, '日结任务', 'Daily Settlement Job');
   v_log_desc := replace(v_log_desc, '调用', 'Call');
   v_log_desc := replace(v_log_desc, '期结', 'End-of-Issue');
   v_log_desc := replace(v_log_desc, '日结', 'Daily Settlement');
   v_log_desc := replace(v_log_desc, '执行时长', 'Duration');
   v_log_desc := replace(v_log_desc, '任务', 'Task');
   v_log_desc := replace(v_log_desc, '成功', 'Success');
   v_log_desc := replace(v_log_desc, '失败原因', 'Fail');
   v_log_desc := replace(v_log_desc, '失败', 'Fail');
   v_log_desc := replace(v_log_desc, '秒', 'second');
   v_log_desc := replace(v_log_desc, '停止在步骤', 'Stop at the step of ');


   INSERT INTO SYS_INTERNAL_LOG
      (LOG_ID,LOG_TYPE,LOG_DATE,LOG_DESC)
   VALUES
      (seq_his_logid.nextval, p_log_type, current_timestamp, v_log_desc)
   return LOG_ID, to_char(current_timestamp,'yyyy-mm-dd hh24:mi:ss.ff') into v_log_id, v_log_log_time;

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
END;
 
/ 
prompt 正在建立[PROCEDURE -> p_mis_trans_win_data.sql ]...... 
CREATE OR REPLACE PROCEDURE p_mis_trans_win_data
/***************************************************************
   ------------------- 中奖明细数据入库 -------------------
   ************************************************************/
(
 --------------输入----------------
 p_game_code      IN NUMBER, -- 游戏编码
 p_issue_number   IN NUMBER, -- 期次编码
 p_data_file_name IN STRING, -- 数据文件名称

 ---------出口参数---------
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述

 ) Authid Current_User IS
   v_sql        VARCHAR2(1000); --执行的SQL
   v_count      INTEGER; --记录行数
   v_table_name VARCHAR2(100); --外部表名称
   v_file_name  VARCHAR2(100); --数据文件名称

   v_reward_time DATE; --开奖时间
   v_cnt         number(1); -- 是否存在记录

   v_desc varchar2(1000);
   v_rec_date date;

BEGIN
   -- 初始化数据
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   -- 检查 iss_prize 表是否有数据
   select count(*)
     into v_cnt
     from dual
    where exists(select 1 from iss_prize where game_code=p_game_code and issue_number=p_issue_number);

   if v_cnt = 0 then
      c_errorcode := 1;
      c_errormesg := 'iss_prize is no data. game_code ['||p_game_code||'] issue_number ['||p_issue_number||']';
      return;
   end if;

   -- 拼接外部表名称
   v_table_name := 'ext_win_data_' || p_game_code || '_' || p_issue_number;

   -- 看看之前是不是建立过外部表，如果有，就删除
   SELECT COUNT(*)
     INTO v_count
     FROM user_tables
    WHERE table_name = upper(v_table_name);
   IF v_count = 1 THEN
      v_sql := 'drop table ' || v_table_name;
      EXECUTE IMMEDIATE v_sql;
   END IF;

   -- 去掉数据文件名的路径
   v_file_name := substr(p_data_file_name, instr(p_data_file_name, '/', -1) + 1);

   -- 通过动态SQL建立外部表，准备导入数据
   v_sql := 'create table ' || v_table_name || ' (';
   v_sql := v_sql || '    APPLYFLOW_SELL  CHAR(24),';
   v_sql := v_sql || '    SALE_AGENCY NUMBER(10),';
   v_sql := v_sql || '    PRIZE_LEVEL NUMBER(3),';
   v_sql := v_sql || '    PRIZE_COUNT NUMBER(16),';
   v_sql := v_sql || '    WINNINGAMOUNTTAX NUMBER(16),';
   v_sql := v_sql || '    WINNINGAMOUNT NUMBER(16),';
   v_sql := v_sql || '    TAXAMOUNT NUMBER(16))';
   v_sql := v_sql || 'ORGANIZATION EXTERNAL ';
   v_sql := v_sql || '  (TYPE ORACLE_LOADER ';
   v_sql := v_sql || '   DEFAULT DIRECTORY windir';
   v_sql := v_sql || '   ACCESS PARAMETERS ';
   v_sql := v_sql || '      (RECORDS DELIMITED BY NEWLINE logfile bkdir:''ext_table_%a_%p.log''';
   v_sql := v_sql || '       FIELDS (APPLYFLOW_SELL  CHAR(24),';
   v_sql := v_sql || '               SALE_AGENCY CHAR(10),';
   v_sql := v_sql || '               PRIZE_LEVEL CHAR(3),';
   v_sql := v_sql || '               PRIZE_COUNT CHAR(16),';
   v_sql := v_sql || '               WINNINGAMOUNTTAX CHAR(16),';
   v_sql := v_sql || '               WINNINGAMOUNT CHAR(16),';
   v_sql := v_sql || '               TAXAMOUNT CHAR(16)';
   v_sql := v_sql || '              )';
   v_sql := v_sql || '      )';
   v_sql := v_sql || '   LOCATION (''' || v_file_name || ''')';
   v_sql := v_sql || '  ) PARALLEL';
   EXECUTE IMMEDIATE v_sql;

   -- 清除一下现有数据
   DELETE his_win_ticket_detail
    WHERE game_code = p_game_code
      AND issue_number = p_issue_number;
   COMMIT;
   DELETE his_win_ticket
    WHERE game_code = p_game_code
      AND issue_number = p_issue_number;
   COMMIT;

   -- 获得插入所需要的必备数据（开奖时间）
   SELECT real_reward_time
     INTO v_reward_time
     FROM iss_game_issue
    WHERE game_code = p_game_code
      AND issue_number = p_issue_number;

   -- 拼SQL，插入数据库，先插入deltail表
   v_sql := 'begin INSERT ';
   v_sql := v_sql || '   INTO his_win_ticket_detail';
   v_sql := v_sql || '      (applyflow_sell,';
   v_sql := v_sql || '       winnning_time,';
   v_sql := v_sql || '       game_code,';
   v_sql := v_sql || '       issue_number,';
   v_sql := v_sql || '       sale_agency,';
   v_sql := v_sql || '       prize_level,';
   v_sql := v_sql || '       prize_count,';
   v_sql := v_sql || '       is_hd_prize,';
   v_sql := v_sql || '       winningamounttax,';
   v_sql := v_sql || '       winningamount,';
   v_sql := v_sql || '       taxamount, win_seq)';
   v_sql := v_sql || '      SELECT applyflow_sell,';
   v_sql := v_sql || '             to_date(''' || to_char(v_reward_time, 'yyyy-mm-dd') || ''',''yyyy-mm-dd''),';
   v_sql := v_sql || '             ' || p_game_code || ',';
   v_sql := v_sql || '             ' || p_issue_number || ',';
   v_sql := v_sql || '             lpad(to_char(sale_agency),8,''0''),';
   v_sql := v_sql || '             prize_level,';
   v_sql := v_sql || '             prize_count,';
   v_sql := v_sql || '             (SELECT is_hd_prize';
   v_sql := v_sql || '                FROM iss_prize';
   v_sql := v_sql || '               WHERE game_code = ' || p_game_code;
   v_sql := v_sql || '                 AND issue_number = ' || p_issue_number;
   v_sql := v_sql || '                 and prize_level = df.prize_level),';
   v_sql := v_sql || '             winningamounttax,';
   v_sql := v_sql || '             winningamount,';
   v_sql := v_sql || '             taxamount, f_get_his_win_seq';
   v_sql := v_sql || '        FROM ' || v_table_name || ' df; commit; end;';
   EXECUTE IMMEDIATE v_sql;

   -- 删除外部表
   v_sql := 'drop table ' || v_table_name;
   EXECUTE IMMEDIATE v_sql;

   -- 统计期次中奖表
   DELETE mis_agency_win_stat
    WHERE game_code = p_game_code
      AND issue_number = p_issue_number;

   -- 需要在开奖公告之后执行
   INSERT INTO mis_agency_win_stat
      (agency_code, game_code, issue_number, prize_level, prize_name, is_hd_prize, winning_count, single_bet_reward)
      SELECT agency_code, game_code, issue_number, prize_level, prize_name, is_hd_prize, winning_count, single_bet_reward
        FROM (SELECT sale_agency AS agency_code, game_code, issue_number, prize_level, SUM(prize_count) AS winning_count
                FROM his_win_ticket_detail
               WHERE game_code = p_game_code
                 AND issue_number = p_issue_number
               GROUP BY sale_agency, game_code, issue_number, prize_level) win
        JOIN iss_prize
       USING (game_code, issue_number, prize_level);
   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      rollback;
      c_errorcode := 1;
      c_errormesg := 'Import winning data is failed. GAME_CODE ['||p_game_code||'] ISSUE_NUMBER ['||p_issue_number||'] Errmsg : ' || sqlerrm;
      return;
END;
 
/ 
prompt 正在建立[PROCEDURE -> p_mm_fund_change.sql ]...... 
create or replace procedure p_mm_fund_change
/****************************************************************/
   ------------------- 市场管理员资金处理（不提交） -------------------
   ---- 按照输入类型，处理市场管理员资金，同时增加相应的资金流水
   ---- add by 陈震: 2015/9/24

   /*************************************************************/
(
   --------------输入----------------
   p_mm                                in number,        -- 市场管理员
   p_type                              in char,          -- 资金类型
   p_amount                            in char,          -- 调整金额
   p_ref_no                            in varchar2,      -- 参考业务编号

   --------------输入----------------
   c_balance                           out number         -- 账户余额

 ) is

   v_acc_no                char(12);                                       -- 账户编码
   v_balance               number(28);                                     -- 账户余额
   v_credit_limit          number(28);                                     -- 信用额度
   v_amount                number(28);                                     -- 账户调整金额

begin
   -- 按照类型，处理正负号
   case
      when p_type in (eflow_type.charge_for_agency) then
         v_amount := 0 - p_amount;

      when p_type in (eflow_type.fund_return, eflow_type.withdraw_for_agency) then
         v_amount := p_amount;

      else
         raise_application_error(-20001, dbtool.format_line(p_type) || error_msg.err_p_fund_change_2);            -- 资金类型不合法

   end case;

   -- 更新余额
   update acc_mm_account
      set account_balance = account_balance + v_amount
    where market_admin = p_mm
      and acc_type = eacc_type.main_account
      and acc_status = eacc_status.available
   returning
      acc_no,   credit_limit,   account_balance
   into
      v_acc_no, v_credit_limit, v_balance;

   if v_credit_limit + v_balance < 0 then
      raise_application_error(-20001, error_msg.err_p_fund_change_1);            -- 账户余额不足
   end if;

   insert into flow_market_manager
      (mm_fund_flow,          ref_no,   flow_type, market_admin, acc_no,   change_amount, be_account_balance,   af_account_balance)
   values
      (f_get_flow_agency_seq, p_ref_no, p_type,    p_mm,         v_acc_no, p_amount,      v_balance - v_amount, v_balance);

   c_balance := v_balance;

end;
 
/ 
prompt 正在建立[PROCEDURE -> p_mm_fund_repay.sql ]...... 
CREATE OR REPLACE PROCEDURE p_mm_fund_repay
/****************************************************************/
  ------------------- 适用于市场专员还款-------------------
  ----市场专员还款
  ----add by dzg: 2015-9-28
  ----业务流程：插入申请表，插入流水，更新账户
  ----modify by dzg:2015-10-26 修改表结构导致存储过程异常
  /*************************************************************/
(
 --------------输入----------------

 p_amount   IN NUMBER, --充值金额
 p_mm_id    IN NUMBER, --市场管理人员
 p_admin_id IN NUMBER, --当前操作人员
 p_remark   in varchar2, -- 注释。只有在负值还款时使用

 ---------出口参数---------
 c_flow_code  OUT STRING, --申请流水
 c_bef_amount OUT NUMBER, --还款前金额
 c_aft_amount OUT NUMBER, --还款后金额
 c_errorcode  OUT NUMBER, --错误编码
 c_errormesg  OUT STRING --错误原因

 ) IS

  v_count_temp NUMBER := 0; --临时变量
  v_flow_code  varchar2(50) := ''; --临时变量流水
  v_acc_code   varchar2(50) := ''; --账户编号

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --编码不能为空
  IF ((p_mm_id IS NULL) OR (p_mm_id <= 0)) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_mm_fund_repay_1;
    RETURN;
  END IF;

  --用户不存在或者无效
  SELECT count(u.admin_id)
    INTO v_count_temp
    FROM adm_info u
   WHERE u.admin_id = p_mm_id
     And u.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_mm_fund_repay_2;
    RETURN;
  END IF;

  --当前操作人不能为空
  IF (p_admin_id IS NULL) THEN
    c_errorcode := 3;
    c_errormesg := error_msg.err_p_mm_fund_repay_3;
    RETURN;
  END IF;

  --操作人无效
  v_count_temp := 0;
  SELECT count(u.admin_id)
    INTO v_count_temp
    FROM adm_info u
   WHERE u.admin_id = p_mm_id
     And u.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 4;
    c_errormesg := error_msg.err_p_mm_fund_repay_4;
    RETURN;
  END IF;

  --金额无效
  IF ((p_amount IS NULL) OR (p_amount = 0)) THEN
    c_errorcode := 5;
    c_errormesg := error_msg.err_p_mm_fund_repay_5;
    RETURN;
  END IF;

  -- 获取初始化信息
  select acc.acc_no, acc.account_balance
    into v_acc_code, c_bef_amount
    from acc_mm_account acc
   where acc.market_admin = p_mm_id;

  --插入基本信息
  v_flow_code := f_get_fund_mm_cash_repay_seq();

  insert into fund_mm_cash_repay
    (mcr_no, market_admin, repay_amount, repay_time, repay_admin, remark)
  values
    (v_flow_code, p_mm_id, p_amount, sysdate, p_admin_id, p_remark);

  p_mm_fund_change(p_mm_id, eflow_type.fund_return, p_amount, v_flow_code, c_aft_amount);

  c_flow_code  := v_flow_code;
  c_bef_amount := c_bef_amount - p_amount;
  c_aft_amount := c_bef_amount;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END p_mm_fund_repay;
 
/ 
prompt 正在建立[PROCEDURE -> p_mm_inv_check.sql ]...... 
create or replace procedure p_mm_inv_check
/****************************************************************/
   ------------------- 市场管理员库存盘点 -------------------
   ---- 输入一个彩票数组，确定出市场管理员的库存情况（以本为单位），返回两个数组。
   ---- 1、显示彩票不在这个管理员手中的；
   ---- 2、应该在管理员库存，但是未扫描的彩票

   ---- add by 陈震: 2015-12-08

   /*************************************************************/
(
 --------------输入----------------
  p_oper                               in number,                             -- 市场管理员
  p_array_lotterys                     in type_mm_check_lottery_list,         -- 输入的彩票对象

  ---------出口参数---------
  c_array_lotterys                     out type_mm_check_lottery_list,        -- 输出的彩票对象
  c_inv_tickets                        out number,                            -- 库存数量
  c_check_tickets                      out number,                            -- 盘点数量
  c_diff_tickets                       out number,                            -- 差异数量
  c_errorcode                          out number,                            -- 错误编码
  c_errormesg                          out string                             -- 错误原因

 ) is

   v_tmp_lotterys                      type_mm_check_lottery_list;            -- 库存彩票对象
   v_out_lotterys                      type_mm_check_lottery_list;            -- 临时彩票对象
   v_s1_lotterys                       type_mm_check_lottery_list;            -- 临时彩票对象
   v_s2_lotterys                       type_mm_check_lottery_list;            -- 临时彩票对象

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   c_inv_tickets := 0;
   c_check_tickets := 0;
   c_diff_tickets := 0;

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;

   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   -- 获取管理员所有彩票对象（本）
   select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, (ticket_no_end - ticket_no_start + 1), 0)
     bulk collect into v_tmp_lotterys
     from wh_ticket_package
    where status = 21
      and CURRENT_WAREHOUSE = p_oper;

   -- 生成管理员库存数量
   select sum(tickets)
     into c_inv_tickets
     from table(v_tmp_lotterys);
   c_inv_tickets := nvl(c_inv_tickets, 0);

   /********************************************************************************************************************************************************************/
   -- 看看输入的彩票中，有多少本是在库存管理员手中的.统计交集的票数量，为盘点数量
   select sum(src.tickets)
     into c_check_tickets
     from table(p_array_lotterys) dest
     join table(v_tmp_lotterys) src
    using (plan_code, batch_no, package_no);
   c_check_tickets := nvl(c_check_tickets, 0);

   -- 库存 减去 盘点，结果为差异
   c_diff_tickets := nvl(c_inv_tickets - c_check_tickets, 0);

   /********************************************************************************************************************************************************************/
   -- 获取未扫描的票
   select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, 0, 2)
     bulk collect into v_s2_lotterys
     from (
         select plan_code, batch_no, package_no from table(v_tmp_lotterys)
         minus
         select plan_code, batch_no, package_no from table(p_array_lotterys));

   -- 显示不在管理员手中的票
   select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, 0, 1)
     bulk collect into v_s1_lotterys
     from (
         select plan_code, batch_no, package_no from table(p_array_lotterys)
         minus
         select plan_code, batch_no, package_no from table(v_tmp_lotterys));

   -- 合并结果
   select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, tickets, status)
     bulk collect into v_out_lotterys
     from (
         select plan_code, batch_no, package_no, tickets, status from table(v_s1_lotterys)
         union all
         select plan_code, batch_no, package_no, tickets, status from table(v_s2_lotterys));

   c_array_lotterys := v_out_lotterys;

exception
   when others then
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;

 
/ 
prompt 正在建立[PROCEDURE -> p_om_add_pool.sql ]...... 
CREATE OR REPLACE PROCEDURE p_om_add_pool
/****************************************************************/
   ------------------- 适用于向奖池中加钱，手工的 -------------------
   ---- NEW by 陈震 2014.7.7
   ---  modify by dzg 2014.10.20 本地化
   ---  modify by dzg 2014.12.08 修改到和adjfund提示一致验证为0不让提交
   ---  modify by 陈震 2015.4.10 BUG。修复 【调节基金入奖池时，调节基金表中写入正值，导致金额变化和期初期末不符】
   /*************************************************************/
(
 --------------输入----------------
 p_game_code  IN NUMBER, --游戏编码
 p_adj_type   IN NUMBER, --变更类型
 p_adj_amount IN NUMBER, --变更金额
 p_adj_desc   IN VARCHAR2, --变更备注
 p_adj_admin  IN NUMBER, --变更人员
 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING, --错误原因
 c_add_now   OUT NUMBER  --作为返回参数表示“是否立即增加”
 ) IS
   v_issue_current NUMBER(12);   -- 当前期
   v_issue_status  NUMBER(2);    -- 期次状态
   v_has_curr_issue BOOLEAN;      -- 是否存在当前期(true表示有当前期)

   v_amount_before NUMBER(18);   -- 更改前奖池余额
   v_amount_after  NUMBER(18);   -- 更改后奖池余额
   v_pool_flow     CHAR(32);     -- 变更流水号

BEGIN

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   -- 检查输入参数
   IF p_adj_amount IS NULL THEN
      c_errorcode := 1;
      --c_errormesg := '输入参数【调整金额】为空值，程序无法计算';
      c_errormesg := error_msg.MSG0025;
      RETURN;
   END IF;
   IF p_adj_amount = 0 THEN
      c_errorcode := 1;
      --c_errormesg := '调整金额为0没有必要计算';
      c_errormesg := error_msg.MSG0026;
      RETURN;
   END IF;

   /*----------- 检查调整类型   -----------------*/
   -- 针对 “调节基金手动拨入奖池”、“发行费手动拨入奖池”和“其他进入奖池”的方式
   IF p_adj_type NOT IN (epool_change_type.in_issue_pool_manual,
                         epool_change_type.in_commission,
                         epool_change_type.in_other) THEN
      c_errorcode := 1;
      --c_errormesg := '未知的奖池调整类型【' || p_adj_type || '】';
      c_errormesg := error_msg.MSG0002;
      RETURN;
   END IF;

   /*----------- 获得游戏当前期状态   -----------------*/
   v_issue_current := f_get_game_current_issue(p_game_code);
   v_has_curr_issue := true;
   begin
      SELECT issue_status
        INTO v_issue_status
        FROM iss_game_issue
       WHERE game_code = p_game_code
         AND real_start_time IS NOT NULL
         AND real_close_time IS NULL;
   exception
      when no_data_found then
         -- 无当前期
         v_has_curr_issue := false;
   end;

   /*----------- 期状态为（6=开奖号码已录入；7=销售已经匹配；8=已录入奖级奖金；9=本地算奖完成；10=奖级已确认；11=开奖确认；12=中奖数据已录入数据库；）状态时，不能立即生效，只保存   -----------------*/
   IF v_issue_status IN
      (egame_issue_status.enteringdrawcodes,
       egame_issue_status.drawcodesmatchingcompleted,
       egame_issue_status.prizepoolentered,
       egame_issue_status.localprizecalculationdone,
       egame_issue_status.prizeleveladjustmentdone,
       egame_issue_status.prizeleveladjustmentconfirmed,
       egame_issue_status.issuedatastoragecompleted) and v_has_curr_issue THEN
      INSERT INTO iss_game_pool_adj
         (pool_flow,
          game_code,
          pool_code,
          pool_adj_type,
          adj_amount,
          pool_amount_before,
          pool_amount_after,
          adj_desc,
          adj_time,
          adj_admin,
          is_adj)
      VALUES
         (f_get_game_flow_seq,
          p_game_code,
          0,
          p_adj_type,
          p_adj_amount,
          NULL,
          NULL,
          p_adj_desc,
          SYSDATE,
          p_adj_admin,
          eboolean.noordisabled);

      c_add_now := 0;
   ELSE
      -- 更新奖池余额，同时获得调整之前和之后的奖池余额
      UPDATE iss_game_pool
         SET pool_amount_before = pool_amount_after,
             pool_amount_after = pool_amount_after + p_adj_amount,
             adj_time = SYSDATE
       WHERE game_code = p_game_code
         AND pool_code = 0
   returning pool_amount_before, pool_amount_after
        into v_amount_before, v_amount_after;

      /*----------- 期状态为（1=预售；2=游戏期开始；3=期即将关闭；4=游戏期关闭；5=数据封存完毕；13=期结全部完成）状态时，可以立即生效   -----------------*/
      INSERT INTO iss_game_pool_adj
         (pool_flow,
          game_code,
          pool_code,
          pool_adj_type,
          adj_amount,
          pool_amount_before,
          pool_amount_after,
          adj_desc,
          adj_time,
          adj_admin,
          is_adj)
      VALUES
         (f_get_game_flow_seq,
          p_game_code,
          0,
          p_adj_type,
          p_adj_amount,
          v_amount_before,
          v_amount_after,
          p_adj_desc,
          SYSDATE,
          p_adj_admin,
          eboolean.yesorenabled)
      RETURNING pool_flow INTO v_pool_flow;

      -- 加奖池流水
      INSERT INTO iss_game_pool_his
         (his_code,
          game_code,
          issue_number,
          pool_code,
          change_amount,
          pool_amount_before,
          pool_amount_after,
          adj_time,
          pool_adj_type,
          adj_reason,
          pool_flow)
      VALUES
         (f_get_game_his_code_seq,
          p_game_code,
          v_issue_current,
          0,
          p_adj_amount,
          v_amount_before,
          v_amount_after,
          SYSDATE,
          p_adj_type,
          p_adj_desc,
          v_pool_flow);

      /*----------- 针对变更类型做后续的事情（都是减钱的买卖） -----------------*/
      CASE p_adj_type
         WHEN epool_change_type.in_issue_pool_manual THEN
            -- 修改余额，同时获得调整之前余额和调整之后余额
            UPDATE adj_game_current
               SET pool_amount_before = pool_amount_after,
                   pool_amount_after = pool_amount_after - p_adj_amount
             WHERE game_code = p_game_code
         returning pool_amount_before, pool_amount_after
              into v_amount_before, v_amount_after;

            -- 类型为 4、调节基金手动拨入
            INSERT INTO adj_game_his
               (his_code,
                game_code,
                issue_number,
                adj_change_type,
                adj_amount,
                adj_amount_before,
                adj_amount_after,
                adj_time,
                adj_reason)
            VALUES
               (f_get_game_his_code_seq,
                p_game_code,
                v_issue_current,
                eadj_change_type.out_issue_pool_manual,
                0 - p_adj_amount,                                -- 调节基金拨入奖池，对于调节基金来说是 减少，因此需要写入负值
                v_amount_before,
                v_amount_after,
                SYSDATE,
                p_adj_desc);

         WHEN epool_change_type.in_commission THEN
            -- 类型为 5、发行费手动拨入
            INSERT INTO gov_commision
               (his_code,
                game_code,
                issue_number,
                comm_change_type,
                adj_amount,
                adj_amount_before,
                adj_amount_after,
                adj_time,
                adj_reason)
            VALUES
               (f_get_game_his_code_seq,
                p_game_code,
                v_issue_current,
                ecomm_change_type.out_to_pool,
                0 - p_adj_amount,                                  -- 发行费入奖池，对于发行费来说是 减少，因此应该为负值
                nvl((SELECT adj_amount_after
                      FROM gov_commision
                     WHERE game_code = p_game_code
                       AND his_code =
                           (SELECT MAX(his_code)
                              FROM gov_commision
                             WHERE game_code = p_game_code)),
                    0),
                nvl((SELECT adj_amount_after
                      FROM gov_commision
                     WHERE game_code = p_game_code
                       AND his_code =
                           (SELECT MAX(his_code)
                              FROM gov_commision
                             WHERE game_code = p_game_code)),
                    0) - p_adj_amount,
                SYSDATE,
                p_adj_desc);
         WHEN epool_change_type.in_other THEN
            -- 什么都不做
            select 1 into v_amount_before from dual;

         ELSE
            ROLLBACK;
            c_errorcode := 1;
            --c_errormesg := '未知的奖池调整类型【' || p_adj_type || '】';
            c_errormesg := error_msg.MSG0002;
      END CASE;
      c_add_now := 1;
   END IF;

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      c_errorcode := 1;
      c_errormesg := error_msg.MSG0004 || SQLERRM;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_om_agbroadcast_create.sql ]...... 
CREATE OR REPLACE PROCEDURE p_om_agbroadcast_create
/****************************************************************/
  ------------------- 适用于创建站点通知-------------------
  ----add by dzg: 2014-07-15 创建站点通知
  ----业务流程：先插入主表，依次对象字表中
  ---- modify by dzg 2014.10.20 修改支持本地化
  ---- modify by dzg 2015.03.02  修改异常退出是赋值输出为0
  /*************************************************************/
(
 --------------输入----------------
 p_resv_objs         IN STRING, --接收对象,格式如中国（0），北京（10），朝阳（1001），站点A(1001000002)
 p_resv_obj_ids      IN STRING, --接收对象ID列表,使用“,”分割的多个字符串
 p_sender_id         IN NUMBER, --发送人ID
 p_broadcast_title   IN STRING, --通知标题
 p_broadcast_content IN STRING, --通知内容
 p_send_time         IN DATE, --发送时间，类似于生效时间
 ---------出口参数---------
 c_errorcode    OUT NUMBER, --错误编码
 c_errormesg    OUT STRING, --错误原因
 c_broadcast_id OUT NUMBER --通知编号
 
 ) IS

  v_broadcast_id   NUMBER := 0; --临时变量
  v_count_temp     NUMBER := 0; --临时变量
  v_is_con_country NUMBER := 0; --临时变量(是否包含全国)

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_broadcast_id := 0;
  v_count_temp   := 0;
  /*----------- 数据校验   -----------------*/

  /*----------- 检测名称重复 ---------------*/

  IF ( (p_resv_obj_ids is null) 
    OR (p_broadcast_title is null) 
    OR length(p_resv_obj_ids) <= 0 
    OR length(p_broadcast_title) <= 0) THEN
    c_broadcast_id := 0;
    c_errorcode := 1;
    --c_errormesg := '接收对象或标题不能为空';
    c_errormesg := error_msg.MSG0003;
    RETURN;
  END IF;

  /*----------- 循环插入数据  -----------------*/

  --插入公告
  v_broadcast_id := f_get_sys_noticeid_seq();

  INSERT INTO msg_agency_brocast
    (notice_id,
     cast_string,
     send_admin,
     title,
     content,
     create_time,
     send_time)
  VALUES
    (v_broadcast_id,
     p_resv_objs,
     p_sender_id,
     p_broadcast_title,
     p_broadcast_content,
     SYSDATE,
     p_send_time);

  --循环更新子对象

  DELETE FROM msg_agency_brocast_detail
   WHERE msg_agency_brocast_detail.notice_id = v_broadcast_id;

  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_resv_obj_ids))) LOOP
    dbms_output.put_line(i.column_value);
    v_count_temp := f_get_sys_noticeid_seq();
    IF length(i.column_value) > 0 THEN
    
      INSERT INTO msg_agency_brocast_detail
        (detail_id, notice_id, cast_code)
      VALUES
        (v_count_temp, v_broadcast_id, to_number(i.column_value));
    
    END IF;
  END LOOP;

  c_broadcast_id := v_broadcast_id;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.MSG0004 || SQLERRM;
    c_broadcast_id := 0;
  
END p_om_agbroadcast_create;
/
 
/ 
prompt 正在建立[PROCEDURE -> p_om_agency_auth.sql ]...... 
create or replace procedure p_om_agency_auth
/***************************************************************
  ------------------- 销售站游戏批量授权 -------------------
  ---------add by dzg  2014-8-28 单个站点的游戏授权
  ---------处理逻辑：同单个区域的游戏授权，先去授权，然后依次授权
  ---------modify by dzg 2014.10.20 修改支持本地化
  ---------modify by dzg 2014.11.13 检测发行费用配置不能超出父级定义
  ************************************************************/
(

 --------------输入----------------

 p_game_auth_list in type_game_auth_list_ts, --授权游戏

 --------------出口参数----------------
 c_errorcode out number, --错误编码
 c_errormesg out string --错误原因

 ) is

begin
  /*-----------    初始化数据    -----------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  if p_game_auth_list.count = 0 then
    return;
  end if;

  -- 先清空该销售站的已经授权信息，然后按照录入数组重新进行设置
  delete from auth_agency where agency_code = p_game_auth_list(1).objcode;

  /*----------- 选择销售站循环插入 -----------*/

    insert into auth_agency
      (agency_code,             game_code,          pay_commission_rate,
       sale_commission_rate,    allow_pay,          allow_sale,         allow_cancel,
       claiming_scope,          auth_time)
    select
       objcode,                 gamecode,           paycommissionrate,
       salecommissionrate,      isallowpay,         isallowsale,        isallowcancel,
       claimingscope,           sysdate
    from table(p_game_auth_list);

  commit;

exception
  when others then
    rollback;
    c_errorcode := 1;
    c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
 
/ 
prompt 正在建立[PROCEDURE -> p_om_agency_status_ctrl.sql ]...... 
CREATE OR REPLACE PROCEDURE p_om_agency_status_ctrl
/****************************************************************/
  ------------------- 适用于控制销售站状态 --------------------
  -------add by dzg 2014-9-19 由于监控延迟可能导致状态更新问题
  -------修订前台对关键对象操作采用存储过程，以便统一入口校验
  -------modify by dzg 2014.10.20 修改支持本地化
  /*************************************************************/
(

 --------------输入----------------
 p_agengcycode  IN NUMBER, --销售站编号
 p_agencystatus IN NUMBER, --销售站状态

 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 ) IS

  v_temp NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);



  /*-------检查状态有效-----*/
  IF(p_agencystatus < eagency_status.enabled or p_agencystatus >eagency_status.cancelled) THEN
     c_errorcode := 1;
     --c_errormesg := '无效的状态值';
     c_errormesg := error_msg.MSG0006;
    RETURN;
  END IF;

  /*-------检查是否存在------*/

  v_temp := 0;

  SELECT COUNT(inf_agencys.agency_code)
    INTO v_temp
    FROM inf_agencys
   WHERE inf_agencys.agency_code = p_agengcycode;

  IF v_temp <= 0 THEN
    c_errorcode := 1;
    --c_errormesg := '无效的销售站';
    c_errormesg := error_msg.MSG0023;
    RETURN;
  END IF;

  /*-------检查当前状态是否一致,如果清退则提示已经清退-----*/
  v_temp := 0;

  SELECT inf_agencys.status
    INTO v_temp
    FROM inf_agencys
   WHERE inf_agencys.agency_code = p_agengcycode;

  IF v_temp = p_agencystatus THEN
    c_errorcode := 1;
    --c_errormesg := '数据库中已经是当前状态';
    c_errormesg := error_msg.MSG0007;
    RETURN;
  END IF;

  IF v_temp = eagency_status.cancelled THEN
    c_errorcode := 1;
    --c_errormesg := '站点已经清退不能执行当前操作';
    c_errormesg := error_msg.MSG0008;
    RETURN;
  END IF;

  /*-----------    更新数据  -----------------*/

  UPDATE inf_agencys
     SET status = p_agencystatus
   WHERE agency_code = p_agengcycode;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    --c_errormesg := '数据库异常' || SQLERRM;
    c_errormesg := error_msg.MSG0004 || SQLERRM;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_om_area_auth.sql ]...... 
CREATE OR REPLACE PROCEDURE p_om_area_auth
/***************************************************************
  ------------------- 区域游戏游戏授权 -------------------
  ----处理逻辑是：先把所有无效，依次循环当前授权信息，如果有删除插入。
  ---------add by dzg  2014-8-27 单个区域的游戏授权
  ---------modify by dzg 2014.10.20 修改支持本地化
  ---------modify by dzg 2014.11.13 检测发行费用配置不能超出父级定义
  ---------modify by dzg 2014.12.10 还得比较下级不能比他大
  ---------modify by dzg 2014.12.23 修改bug应该<100比较区域，100以上比站

  ---------migrate by Chen Zhen @ 2016-04-14
  ************************************************************/
(

 --------------输入----------------

 p_game_auth_list IN type_game_auth_list_ts, --授权游戏

 --------------出口参数----------------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因

 ) IS

BEGIN
  /*-----------    初始化数据    -----------*/

  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  if p_game_auth_list.count = 0 then
    return;
  end if;

  -- 先清空该区域的已经授权信息，然后按照录入数组重新进行设置
  delete from auth_org where org_code = p_game_auth_list(1).objcode;

  /*-----------选择区域循环插入----------*/
  insert into auth_org
    (org_code, game_code,  pay_commission_rate, sale_commission_rate, auth_time, allow_pay,  allow_sale,  allow_cancel)
  select
     objcode,  gamecode,   paycommissionrate,   salecommissionrate,   sysdate,   isallowpay, isallowsale, isallowcancel
   from table(p_game_auth_list);

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.msg0004 || SQLERRM;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_om_game_prize_batchinsert.sql ]...... 
CREATE OR REPLACE PROCEDURE p_om_game_prize_batchinsert
/***************************************************************
  ------------------- 游戏奖级批量处理  -------------------
  ---------add by dzg  2014-8-4 批量更新奖级 
  ---------modify by dzg 2014.10.20 修改支持本地化
  ************************************************************/
(
 
 --------------输入----------------
 
 p_game_prize_list IN type_game_prize_list, --游戏奖级信息
 
 --------------出口参数----------------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 
 ) IS

  v_his_code                   NUMBER := 0; --历史编号，从0开始
  v_cur_prize_info    type_game_prize_info; --当前奖级信息

BEGIN
  /*-----------    初始化数据    -----------*/

  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  /*-----------  输入数据校验    ----------*/
  IF p_game_prize_list.count < 0 THEN
    c_errorcode := 1;
    --c_errormesg := '输入授权游戏不能为空';
    c_errormesg := error_msg.MSG0005;
    RETURN;
  END IF;

  v_cur_prize_info := p_game_prize_list(1);
  SELECT nvl(MAX(his_prize_code), 0)+1
    INTO v_his_code
    FROM gp_prize_rule
   WHERE gp_prize_rule.game_code = v_cur_prize_info.GAMECODE;

  /*-----------选择游戏循环插入----------*/

  FOR i IN 1 .. p_game_prize_list.count LOOP
  
    v_cur_prize_info := p_game_prize_list(i);
  
    ---插入所有奖级
    INSERT INTO gp_prize_rule
      (his_prize_code,
       his_modify_date,
       game_code,
       prule_level,
       prule_name,
       prule_desc,
       level_prize)
    VALUES
      (v_his_code,
       SYSDATE,
       v_cur_prize_info.GAMECODE,
       v_cur_prize_info.RULELEVEL,
       v_cur_prize_info.RULENAME,
       v_cur_prize_info.RULEDESC,
       v_cur_prize_info.RULEAMOUNT);  
  
  END LOOP;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    --c_errormesg := '数据库异常' || SQLERRM;
    c_errormesg := error_msg.MSG0004 || SQLERRM;
  
END;
/
 
/ 
prompt 正在建立[PROCEDURE -> p_om_issue_adjfund_modify.sql ]...... 
CREATE OR REPLACE PROCEDURE p_om_issue_adjfund_modify
/*****************************************************************/
   ----------- 适用于oms调用手工调整调节资金 ---------------
   ----------- add by dzg 2014-07-16
   ----------- 支持三种模式：
   ----------- 拨出到奖池 4 out_issue_pool_manual （已经废弃，通过奖池调整功能来实现）
   ----------- 发行费拨入 5 in_commission
   ----------- 其他来源拨入 6、 in_other
   ----------- modify by dzg 2014.10.20 修改支持本地化
   /*****************************************************************/
(
 --------------输入----------------
 p_game_code  IN NUMBER, --游戏编码
 p_adj_amount IN NUMBER, --调整金额
 p_adj_type   IN NUMBER, --调整类型
 p_remark     IN STRING, --调整备注
 p_admin_id   IN NUMBER, --操作人员
 ---------出口参数---------
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述
 ) IS

   v_amount        NUMBER(28); -- 调整金额
   v_amount_before NUMBER(28); -- 调整前金额
   v_amount_after  NUMBER(28); -- 调整后金额
   v_adj_flow      CHAR(32); -- 当前调节流水
   --v_pool_flow     CHAR(32); -- 当前奖池流水
   v_curr_issue    NUMBER; -- 当期期次

BEGIN

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   -- 检查输入参数
   IF p_adj_amount IS NULL THEN
      c_errorcode := 1;
      --c_errormesg := '输入参数【调整金额】为空值，程序无法计算';
      c_errormesg := error_msg.MSG0025;
      RETURN;
   END IF;
   IF p_adj_amount = 0 THEN
      c_errorcode := 1;
      --c_errormesg := '调整金额为0没有必要计算';
      c_errormesg := error_msg.MSG0026;
      RETURN;
   END IF;

   -- 按照类型确定数据金额是否为负值
   if p_adj_type in (eadj_change_type.out_issue_pool_manual) then
      v_amount := 0 - p_adj_amount;
   else
      v_amount := p_adj_amount;
   end if;

   --获取当前期次
   v_curr_issue := f_get_game_current_issue(p_game_code);

   -- 更新当前调节基金余额，同时获取调整之前和调整之后的金额
   UPDATE adj_game_current
      SET pool_amount_before = pool_amount_after,
          pool_amount_after  = pool_amount_after + p_adj_amount
    WHERE game_code = p_game_code
   returning pool_amount_before, pool_amount_after into v_amount_before, v_amount_after;

   -- 插入调整申请
   INSERT INTO adj_game_change
      (adj_flow,
       game_code,
       adj_amount,
       adj_amount_before,
       adj_amount_after,
       adj_change_type,
       adj_desc,
       adj_time,
       adj_admin)
   VALUES
      (f_get_game_flow_seq,
       p_game_code,
       p_adj_amount,
       v_amount_before,
       v_amount_after,
       p_adj_type,
       p_remark,
       sysdate,
       p_admin_id)
   RETURNING adj_flow INTO v_adj_flow;

   -- 3)插入流水
   INSERT INTO adj_game_his
      (his_code,
       game_code,
       issue_number,
       adj_change_type,
       adj_amount,
       adj_amount_before,
       adj_amount_after,
       adj_time,
       adj_reason,
       adj_flow)
   VALUES
      (f_get_game_his_code_seq,
       p_game_code,
       v_curr_issue,
       p_adj_type,
       p_adj_amount,
       v_amount_before,
       v_amount_after,
       sysdate,
       p_remark,
       v_adj_flow);

   /*-----------    更新数据    -----------------*/
   -- 根据不同的调节类型进行不同的处置
   CASE p_adj_type
      WHEN eadj_change_type.out_issue_pool_manual THEN

         -- 如果：拨出到奖池 4 out_issue_pool_manual，可以调用存储过程 p_om_add_pool 实现
         select 1 into v_amount from dual;

      WHEN eadj_change_type.in_commission THEN
         -- 如果：发行费拨入 5 in_commission
         -- 则减少发行费，减少流水
         -- 插入调节资金流水，更新总额
         -- 插入发行费流水
         INSERT INTO gov_commision
            (his_code,
             game_code,
             issue_number,
             comm_change_type,
             adj_amount,
             adj_amount_before,
             adj_amount_after,
             adj_time,
             adj_reason)
         VALUES
            (f_get_game_his_code_seq,
             p_game_code,
             v_curr_issue,
             ecomm_change_type.out_to_adj,
             p_adj_amount,
             (SELECT adj_amount_after
                FROM gov_commision
               WHERE game_code = p_game_code
                 AND his_code = (SELECT MAX(his_code)
                                   FROM gov_commision
                                  WHERE game_code = p_game_code)),
             (SELECT adj_amount_after
                FROM gov_commision
               WHERE game_code = p_game_code
                 AND his_code = (SELECT MAX(his_code)
                                   FROM gov_commision
                                  WHERE game_code = p_game_code)) -
             p_adj_amount,
             sysdate,
             p_remark);

   -- 其他来源拨入 6、 in_other
      WHEN eadj_change_type.in_other THEN
         -- 什么都不做
         select 1 into v_amount from dual;
   END CASE;
   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_om_issue_create.sql ]...... 
CREATE OR REPLACE PROCEDURE p_om_issue_create
/****************************************************************/
   ------------------- 适用于新增期次 ---------------------------
   -------modify by dzg 2014-6-21 增加期次序号控制，检查时间是否有重复--------
   -------modify by Chen Zhen 2014-7-5 根据柬埔寨表结构修改 --------
   -------modify by dzg 2014.10.20 修改支持本地化
   -------modify by dzg 2015.06.10 检测期号是否递增
   -------modify by dzg 2015.07.06 修改copy奖级和玩法的排序字段
   /*************************************************************/
(
 --------------输入----------------
 p_issue_list IN type_game_issue_list, --期次列表
 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因

 ) IS
   v_cur_game_code     NUMBER := 0; --当前游戏编号
   v_cur_issue_code    NUMBER := 0; --当前期次编号，用于2015.5.10修改验证期号递增
   v_cur_base_code     NUMBER := 0; --当前配置基础信息编号
   v_cur_plcy_code     NUMBER := 0; --当前政策参数编号
   v_cur_rule_code     NUMBER := 0; --当前玩法编号
   v_cur_win_code      NUMBER := 0; --当前中奖编号
   v_cur_prize_code    NUMBER := 0; --当前奖级编号
   v_count_temp        NUMBER := 0; --临时计数器
   v_cur_max_seq       NUMBER := 0; --当期游戏最大seq,初始值从db中获取
   v_is_time_contain   NUMBER := 0; --检测系统中是否已经包含当前期，检测时间交叉
   v_calc_winning_code VARCHAR2(100); --当前算奖规则

   v_cur_issue type_game_issue_info; --当前期

   -- 同步数据
   v_param     VARCHAR2(200);
   v_ip        VARCHAR2(200);
   v_user      VARCHAR2(200);
   v_pass      VARCHAR2(200);
   v_url       VARCHAR2(200);

   v_c_errorcode NUMBER(10);
   v_c_errormesg VARCHAR2(1000);

   v_risk_status        number(1);
   v_mysql_issue_list   type_game_issue_list_mon;
   v_mysql_issue_date   type_game_issue_info_mon;

BEGIN

   /*-----------------   初始化数据基础信息    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   v_mysql_issue_list := type_game_issue_list_mon();

   /*----------------- 输入数据校验  -----------------*/
   IF p_issue_list.count < 0 THEN
      c_errorcode := 1;
      --c_errormesg := '输入期次数据不能为空';
      c_errormesg := error_msg.MSG0027;
      RETURN;
   END IF;

   /*-------游戏有效性校验 -------*/
   v_cur_game_code := p_issue_list(1).gamecode;
   IF v_cur_game_code < 0 THEN
      c_errorcode := 1;
      --c_errormesg := '无效的游戏编码';
      c_errormesg := error_msg.MSG0028;
      RETURN;
   END IF;

   SELECT COUNT(inf_games.game_code)
     INTO v_count_temp
     FROM inf_games
    WHERE inf_games.game_code = v_cur_game_code;

   IF v_count_temp < 0 THEN
      c_errorcode := 1;
      --c_errormesg := '游戏不存在，或游戏编码异常';
      c_errormesg := error_msg.MSG0029;
      RETURN;
   END IF;
   v_count_temp := 0;

   /*-------游戏历史参数并校验 -------*/

   SELECT DISTINCT his_his_code
     INTO v_cur_base_code
     FROM v_gp_his_current
    WHERE game_code = v_cur_game_code;

   IF v_cur_base_code < 0 THEN
      c_errorcode := 1;
      --c_errormesg := '游戏' || v_cur_game_code || '基础信息配置信息为空';
      c_errormesg := error_msg.MSG0030;
      RETURN;
   END IF;

   /*-------初始化政策参数并校验 -------*/

   SELECT DISTINCT his_policy_code
     INTO v_cur_plcy_code
     FROM v_gp_policy_current
    WHERE game_code = v_cur_game_code;

   IF v_cur_plcy_code < 0 THEN
      c_errorcode := 1;
      --c_errormesg := '游戏政策参数配置信息为空';
      c_errormesg := error_msg.MSG0031;
      RETURN;
   END IF;

   /*-------初始化奖级参数并校验 -------*/
   SELECT DISTINCT his_prize_code
     INTO v_cur_prize_code
     FROM v_gp_prize_rule_current
    WHERE game_code = v_cur_game_code;

   IF v_cur_prize_code < 0 THEN
      c_errorcode := 1;
      --c_errormesg := '游戏奖级参数配置信息为空';
      c_errormesg := error_msg.MSG0032;
      RETURN;
   END IF;

   /*-------初始化玩法参数并校验 -------*/
   SELECT DISTINCT his_rule_code
     INTO v_cur_rule_code
     FROM v_gp_rule_current
    WHERE game_code = v_cur_game_code;

   IF v_cur_rule_code < 0 THEN
      c_errorcode := 1;
      --c_errormesg := '游戏玩法参数配置信息为空';
      c_errormesg := error_msg.MSG0033;
      RETURN;
   END IF;

   /*-------初始化中奖参数并校验 -------*/
   SELECT DISTINCT his_win_code
     INTO v_cur_win_code
     FROM v_gp_win_rule_current
    WHERE game_code = v_cur_game_code;

   IF v_cur_win_code < 0 THEN
      c_errorcode := 1;
      --c_errormesg := '游戏中奖参数配置信息为空';
      c_errormesg := error_msg.MSG0034;
      RETURN;
   END IF;

   /*-------获取算奖规则-------*/
   SELECT calc_winning_code
     INTO v_calc_winning_code
     FROM gp_dynamic
    WHERE game_code = v_cur_game_code;

   /*-------获取最大seq-------*/
   SELECT nvl(MAX(iss_game_issue.issue_seq), 0)
     INTO v_cur_max_seq
     FROM iss_game_issue
    WHERE iss_game_issue.game_code = v_cur_game_code;

   /*----------------- 循环插入数据  -----------------*/
   FOR i IN 1 .. p_issue_list.count LOOP

      v_cur_issue  := p_issue_list(i);
      v_count_temp := 0;

      /*-------如下检测第一次执行-------*/
      IF i = 1 THEN

         --初始化当前期次
         v_cur_issue_code := v_cur_issue.issuenumber;

         /*-----检测期次号重复 -----*/
         SELECT COUNT(iss_game_issue.issue_number)
           INTO v_count_temp
           FROM iss_game_issue
          WHERE iss_game_issue.game_code = v_cur_game_code
            AND iss_game_issue.issue_number >= v_cur_issue.issuenumber;

         IF v_count_temp > 0 THEN
            raise_application_error(-20010, error_msg.MSG0035);
         END IF;

         /*-------检测时间重复-------*/
         SELECT COUNT(iss_game_issue.issue_number)
           INTO v_is_time_contain
           FROM iss_game_issue
          WHERE iss_game_issue.game_code = v_cur_game_code
            AND iss_game_issue.plan_close_time >
                v_cur_issue.planstarttime ;

         IF v_is_time_contain > 0 THEN
            raise_application_error(-20011, error_msg.MSG0036);
            RETURN;
         END IF;
      END IF;

      /*-------如下检测期号递增-------*/
      IF i > 1 THEN
        IF v_cur_issue.issuenumber <= v_cur_issue_code THEN
           raise_application_error(-1, 'Invalid issue number:'||v_cur_issue.issuenumber);
           RETURN;
        END IF;

        IF v_cur_issue.issuenumber > v_cur_issue_code THEN
           v_cur_issue_code := v_cur_issue.issuenumber;
        END IF;
      END IF;

      /*-----插入期次 -----*/
      INSERT INTO iss_game_issue
         (game_code, issue_number, issue_seq, issue_status, is_publish, plan_start_time, plan_close_time, plan_reward_time, calc_winning_code)
      VALUES
         (v_cur_game_code,
          v_cur_issue.issuenumber,
          v_cur_max_seq + i,
          egame_issue_status.prearrangement,
          eboolean.noordisabled,
          v_cur_issue.planstarttime,
          v_cur_issue.planclosetime,
          v_cur_issue.planrewardtime,
          v_calc_winning_code);

      -- 准备同步的数据
      select is_open_risk into v_risk_status from v_gp_his_current where game_code=v_cur_game_code;
      v_mysql_issue_date := new type_game_issue_info_mon(
                                                         v_cur_game_code,                          --游戏编号
                                                         v_cur_issue.issuenumber,                  --期次号
                                                         egame_issue_status.prearrangement,        --期次状态
                                                         v_risk_status,                            --风控状态
                                                         to_char(v_cur_issue.planstarttime,  'yyyy-mm-dd hh24:mi:ss'),                                     --实际期次开始时间
                                                         to_char(v_cur_issue.planclosetime,  'yyyy-mm-dd hh24:mi:ss'),                                     --实际期次关闭时间
                                                         to_char(v_cur_issue.planrewardtime, 'yyyy-mm-dd hh24:mi:ss'),                                     --实际期次开奖时间
                                                         null,                                     --实际期次结束时间
                                                         0,                                        --期初奖池
                                                         null,                                     --第一次开奖用户
                                                         null,                                     --第二次开奖用户
                                                         0);                                       --期末奖池
      v_mysql_issue_list.extend;
      v_mysql_issue_list(i) := v_mysql_issue_date;

      /*-----插入期次游戏参数 -----*/
      INSERT INTO iss_current_param
         (game_code, issue_number, his_his_code, his_policy_code, his_rule_code, his_win_code, his_prize_code)
      VALUES
         (v_cur_game_code, v_cur_issue.issuenumber, v_cur_base_code, v_cur_plcy_code, v_cur_rule_code, v_cur_win_code, v_cur_prize_code);

      /*-----插入期次奖级-----*/
      ---modify by dzg 2015.07.06
      INSERT INTO iss_game_prize_rule
         (game_code, issue_number, prize_level, prize_name, level_prize,disp_order)
         SELECT game_code, v_cur_issue.issuenumber, prule_level, prule_name, level_prize,disp_order
           FROM v_gp_prize_rule_current
          WHERE game_code = v_cur_game_code
            AND his_prize_code = v_cur_prize_code;

      /*-----插入期次XML-----*/
      INSERT INTO iss_game_issue_xml
         (game_code, issue_number)
      VALUES
         (v_cur_game_code, v_cur_issue.issuenumber);

   END LOOP;

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      c_errorcode := 1;
      --c_errormesg := '数据库异常' || SQLERRM;
      c_errormesg := error_msg.MSG0004 || SQLERRM;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_om_issue_delete.sql ]...... 
CREATE OR REPLACE PROCEDURE p_om_issue_delete
/****************************************************************/
  ------------------- 适用于删除期次 -------------------
  ----add by dzg 2014-07-10 删除期次及其相关数据。
  ----删除当前期次之后所有期次及其相关内容
  ----如果当前期次已经发布，则撤销
  ----modify by dzg 2014-07-14 增加期次删除时，删除开奖公告内容
  ----modify by dzg 2014.10.20 修改支持本地化
  /*************************************************************/
(
 --------------输入----------------
 p_game_code     IN NUMBER, --游戏编号
 p_issue_numuber IN NUMBER, --期次号
 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 ) IS

   -- 同步数据
   v_param     VARCHAR2(200);
   v_ip        VARCHAR2(200);
   v_user      VARCHAR2(200);
   v_pass      VARCHAR2(200);
   v_url       VARCHAR2(200);

   v_c_errorcode NUMBER(10);
   v_c_errormesg VARCHAR2(1000);

   v_mysql_issue_list   type_game_issue_list_mon;
   v_mysql_issue_date   type_game_issue_info_mon;
   v_count              number(10);

BEGIN

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   v_mysql_issue_list := type_game_issue_list_mon();

   /*-----------    删除期次     -----------------*/

   -- 删除前，先保存需要删除的数据，准备同步用
   v_count := 0;
   for tab_del_issue in (select game_code, issue_number from iss_game_issue WHERE iss_game_issue.game_code = p_game_code AND iss_game_issue.issue_number >= p_issue_numuber) loop
      v_mysql_issue_date := new type_game_issue_info_mon(
                                                         tab_del_issue.game_code,             --游戏编号
                                                         tab_del_issue.issue_number,          --期次号
                                                         0,                       --期次状态
                                                         0,                       --风控状态
                                                         null,                    --实际期次开始时间
                                                         null,                    --实际期次关闭时间
                                                         null,                    --实际期次开奖时间
                                                         null,                    --实际期次结束时间
                                                         0,                       --期初奖池
                                                         null,                    --第一次开奖用户
                                                         null,                    --第二次开奖用户
                                                         0);                      --期末奖池
      v_mysql_issue_list.extend;
      v_count := v_count + 1;
      v_mysql_issue_list(v_count) := v_mysql_issue_date;
   end loop;

   /*-----删除期表内容-----*/
   DELETE FROM iss_game_issue
   WHERE iss_game_issue.game_code = p_game_code
     AND iss_game_issue.issue_number >= p_issue_numuber;

   /*-----删除参数表数据-----*/

   DELETE FROM iss_current_param
   WHERE iss_current_param.game_code = p_game_code
     AND iss_current_param.issue_number >= p_issue_numuber;

   /*-----删除期次奖级-----*/

   DELETE FROM iss_game_prize_rule
   WHERE iss_game_prize_rule.game_code = p_game_code
     AND iss_game_prize_rule.issue_number >= p_issue_numuber;

   /*-----删除期次开奖公告-----*/
   DELETE FROM iss_game_issue_xml
    WHERE iss_game_issue_xml.game_code = p_game_code
      AND iss_game_issue_xml.issue_number >= p_issue_numuber;

   COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    --c_errormesg := '数据库异常' || SQLERRM;
    c_errormesg := error_msg.MSG0004 || SQLERRM;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_om_modify_teller_pwd.sql ]...... 
CREATE OR REPLACE PROCEDURE p_om_modify_teller_pwd
/***************************************************************
  ------------------- 修改teller口令 -------------------
  ----- modify by dzg 2014.10.20 修改支持本地化
  ************************************************************/
(
 --------------输入----------------
 p_teller_code  IN NUMBER, --销售员code
 p_old_password IN STRING, --旧口令
 p_new_password IN STRING, --新口令
 ---------出口参数---------
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述
 ) IS
  v_pwd VARCHAR2(32);
BEGIN

  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  --获得销售员旧密码
  SELECT t.password
    INTO v_pwd
    FROM inf_tellers t
   WHERE t.teller_code = p_teller_code;

  --如果旧密码不一致
  IF v_pwd <> p_old_password THEN
    c_errorcode := 1;
    --c_errormesg := '不一样的旧密码';
    c_errormesg := error_msg.MSG0037;
    RETURN;
  END IF;

  --修改密码
  UPDATE inf_tellers t
     SET t.password = p_new_password
   WHERE t.teller_code = p_teller_code;

  IF SQL%NOTFOUND THEN
    c_errorcode := 1;
    --c_errormesg := '更新销售员密码失败';
    c_errormesg := error_msg.MSG0038;
    RETURN;
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_om_modify_teller_signoff.sql ]...... 
CREATE OR REPLACE PROCEDURE p_om_modify_teller_signoff
/***************************************************************
  ------------------- 销售员签出终端 -------------------
  ---- modify by dzg 2014.10.20 修改支持本地化
  ************************************************************/
(
 --------------输入----------------
 p_teller_code          IN NUMBER, --销售员id
 p_latest_sign_off_time IN DATE, --最后签出日期时间
 ---------出口参数---------
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述
 ) IS
BEGIN

  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  --更新销售员签入信息
  UPDATE inf_tellers t
     SET t.latest_sign_off_time = p_latest_sign_off_time,
         t.is_online = eboolean.noordisabled
   WHERE t.teller_code = p_teller_code;

  IF SQL%NOTFOUND THEN
    c_errorcode := 1;
    --c_errormesg := '更新销售员签出信息失败';
    c_errormesg := error_msg.MSG0039;
    RETURN;
  END IF;

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_om_modify_teller_signon.sql ]...... 
CREATE OR REPLACE PROCEDURE p_om_modify_teller_signon
/***************************************************************
  ------------------- 销售员签入终端 -------------------
  ---- modify by dzg 2014.10.20 修改支持本地化
  -------migrate by Chen Zhen @ 2016-04-18

  ************************************************************/
(
 --------------输入----------------
 p_teller_code          IN NUMBER, --销售员id
 p_latest_terminal_code IN NUMBER, --最近签入的销售终端编码
 p_latest_sign_on_time  IN DATE, --最近签入日期时间
 ---------出口参数---------
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述
 ) IS
BEGIN

  -- 初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  -- 更新销售员签入信息
  UPDATE inf_tellers t
     SET t.latest_terminal_code = p_latest_terminal_code,
         t.latest_sign_on_time = p_latest_sign_on_time,
         t.is_online = eboolean.yesorenabled
   WHERE t.teller_code = p_teller_code;

  IF SQL%NOTFOUND THEN
    c_errorcode := 1;
    --c_errormesg := '更新销售员签入信息失败';
    c_errormesg := error_msg.MSG0040;
    RETURN;
  END IF;

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_om_set_day_close.sql ]...... 
CREATE OR REPLACE PROCEDURE p_om_set_day_close
/*****************************************************************/
  ----------- 日结OMS操作  ---------------
  ----------- add by dzg 2014-10-15
  ----------- 日结清零，两件事：
  ----------- 1、对临时信用额度清零，
  ----------- 2、重置终端销售seq
  ----------- modify by dzg 2014-12-03 新增对资金管理缴款专员日结
  ----------- modify by CZ. 2016-02-26 按照KPW情况进行调整，取消针对销售站的数据调整。
  /*****************************************************************/
(

 --------------输入----------------
 p_day_code IN NUMBER, --日结期限

 -----------出口参数--------------
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述
 ) IS

  v_errorcode  NUMBER(10);  -- 错误编号
  v_errormesg  CHAR(32);    -- 错误信息

BEGIN

  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  --对临时信用额度清零
  --UPDATE saler_agency SET saler_agency.temp_credit = 0;

  -- 重置终端销售seq
  -- modify by ChenZhen @2016-06-11 重置终端登录状态
  update saler_terminal
     set trans_seq = 1,
         latest_login_teller_code = null,
         is_logging = eboolean.noordisabled;

  -- add by chenzhen @2016-06-11 重置teller的登录状态
  update inf_tellers
     set latest_terminal_code = null,
         latest_sign_on_time = null,
         latest_sign_off_time = null,
         is_online = eboolean.noordisabled;

  commit;

  -- 调用MIS日结
  p_mis_set_day_close(to_date(to_char(p_day_code),'yyyymmdd'), v_errorcode, v_errormesg);


  --异常处理
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_om_tds_issue_draw_notice.sql ]...... 
create or replace procedure p_om_tds_issue_draw_notice
/*****************************************************************/
   ----------- 生成json TDS开奖公告 ---------------
   ----- created by chen zhen @ 2016-04-18
/*****************************************************************/

(
   p_game_code    in number,    --游戏编码
   p_issue_number in number,    --期次编码

   c_json         out clob,     --返回值
   c_errorcode    out number,   --业务错误编码
   c_errormesg    out string    --错误信息描述
) is

   tempclob clob;
   tempobj json;
   tempobj_list json_list;

   v_issue_number        iss_game_issue.issue_number%type;
   v_draw_code           iss_game_issue.final_draw_number%type;
   v_sale_amount		 iss_game_issue.issue_sale_amount%type;
   v_winning_amount		 iss_game_issue.winning_amount%type;

begin
  -- 初始化变量
  c_errorcode := 0;

  -- 临时的json和json list变量
  tempobj := json();
  tempobj_list := json_list();

  if p_issue_number = 0 then
     -- 开奖号码
    begin
       select issue_number,final_draw_number, issue_sale_amount, winning_amount
         into v_issue_number, v_draw_code, v_sale_amount, v_winning_amount
         from iss_game_issue
        where issue_number in  (select max(issue_number) from iss_game_issue where game_code = p_game_code and issue_status >= egame_issue_status.issuedatastoragecompleted)
          and game_code = p_game_code;
    exception
       when no_data_found then
       c_errorcode := 11;
       c_errormesg := error_msg.err_p_set_json_issue_draw_n_1;               -- 游戏期次不存在，或者未开奖
       return;
    end;
  else
    v_issue_number := p_issue_number;
  end if;

  begin
    select json_winning_brodcast
      into tempclob
      from iss_game_issue_xml
     where game_code = p_game_code
       and issue_number = v_issue_number;
  exception
     when no_data_found then
     c_errorcode := 12;
     c_errormesg := error_msg.err_p_set_json_issue_draw_n_1;               -- 游戏期次不存在，或者未开奖
     return;
  end;

  if tempclob is null then
     c_errorcode := 13;
     c_errormesg := error_msg.err_p_set_json_issue_draw_n_1;               -- 游戏期次不存在，或者未开奖
     return;
  end if;

  c_json := tempclob;

exception
  when others then
      dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

end; 
/ 
prompt 正在建立[PROCEDURE -> p_om_teller_create.sql ]...... 
CREATE OR REPLACE PROCEDURE p_om_teller_create
/***************************************************************
  ------------------- 新增teller -------------------
  ---------modify by dzg  2014-7-8 增加返回值
  ---------modify by dzg  2014-8-11 增加插入编号
  ---------modify by dzg  2014-8-31 增加限制值检测
  ---------modify by dzg  2014-9-15 增加限制中心直属站不可增加
  ---------modify by dzg  2014-9-23 增加检测重复，删除也不可以重用那是主键
  ---------modify by dzg 2014.10.20 修改支持本地化
  ---------modify by dzg 2015.03.02 增加异常退出时输出默认值0

  ---------migrate from Taishan by Chen Zhen @ 2016-03-21
  ************************************************************/
(
 --------------输入----------------
 p_teller_code   IN NUMBER, -- 销售员编号
 p_agency_code   IN STRING, -- 销售站编码
 p_teller_name   IN STRING, -- 销售员名称
 p_teller_type   IN NUMBER, -- 销售员类型
 p_teller_status IN NUMBER, -- 销售员状态
 p_password      IN STRING, -- 销售员密码
 ---------出口参数---------
 c_errorcode   OUT NUMBER, --错误编码
 c_errormesg   OUT STRING, --错误原因
 c_teller_code OUT NUMBER -- 销售员编码
 ) IS
  v_temp         NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  /*-------检测所属站点编码的有效性-------*/
  SELECT COUNT(inf_agencys.agency_code)
    INTO v_temp
    FROM inf_agencys
   WHERE agency_code = p_agency_code
     AND status != eagency_status.cancelled;

  IF v_temp <= 0 THEN
    c_errorcode := 1;
    c_errormesg   := error_msg.err_p_teller_create_1;                                              -- 无效的销售站
    c_teller_code := 0;
    RETURN;
  END IF;

  /*-------检测重复 -------*/
  v_temp := 0;
  SELECT COUNT(teller_code)
    INTO v_temp
    FROM inf_tellers
   WHERE teller_code = p_teller_code;

  IF v_temp > 0 THEN
    c_errorcode := 1;
    c_errormesg   := error_msg.err_p_teller_create_2;                                              -- 销售员编号重复
    c_teller_code := 0;
    RETURN;
  END IF;

  -- 超出系统预设范围
  v_temp := 99999999;
  IF p_teller_code > v_temp THEN
    c_errorcode := 1;
    c_errormesg   := error_msg.err_p_teller_create_3;                                              -- 输入的编码超出范围！
    c_teller_code := 0;
    RETURN;
  END IF;

  /* 插入数据，注意最后三项为NULL */

  c_teller_code := p_teller_code;

  INSERT INTO inf_tellers
    (teller_code, agency_code, teller_name, teller_type, status, password)
  VALUES
    (p_teller_code,
     p_agency_code,
     p_teller_name,
     p_teller_type,
     p_teller_status,
     lower(p_password));

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg   := error_msg.err_common_1 || SQLERRM;
    c_teller_code := 0;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_om_teller_status_ctrl.sql ]...... 
CREATE OR REPLACE PROCEDURE p_om_teller_status_ctrl
/****************************************************************/
  ------------------- 适用于控制销售员状态 --------------------
  -------add by dzg 2014-9-19 由于监控延迟可能导致状态更新问题
  -------修订前台对关键对象操作采用存储过程，以便统一入口校验
  -------modify by dzg 2014.10.20 修改支持本地化

  ---------migrate from Taishan by Chen Zhen @ 2016-03-21

  /*************************************************************/
(

 --------------输入----------------
 p_tellercode   IN NUMBER, --销售员编号
 p_tellerstatus IN NUMBER, --销售员状态

 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 ) IS

  v_temp NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);


   /*-------检查状态有效-----*/
   IF p_tellerstatus not in (eteller_status.enabled, eteller_status.disabled, eteller_status.deleted) THEN
     c_errorcode := 1;
     c_errormesg := error_msg.err_p_teller_status_change_1;                                     -- 无效的状态值
    RETURN;
  END IF;

  /*-------检查是否存在------*/

  v_temp := 0;
  SELECT COUNT(teller_code)
    INTO v_temp
    FROM inf_tellers
   WHERE teller_code = p_tellercode;

  IF v_temp <= 0 THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_teller_status_change_2;                                      -- 销售员不存在
    RETURN;
  END IF;

  /*-----------    更新数据  -----------------*/

  UPDATE inf_tellers
     SET status = p_tellerstatus
   WHERE teller_code = p_tellercode;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg   := error_msg.err_common_1 || SQLERRM;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_om_terminal_create.sql ]...... 
CREATE OR REPLACE PROCEDURE p_om_terminal_create
/***************************************************************
  ------------------- 新增terminal -------------------
  ---------modify by dzg  2014-7-8 增加返回值
  ---------modify by dzg  2014-7-10 插入默认终端版本1.0.0
  ---------modify by dzg  2014-8-11 修改增输入终端编码
  ---------modify by dzg  2014-8-30 修改bug版本号为1.0.00
  ---------modify by dzg  2014-8-31 修改bug插入时增加限制检测是否已经超过限制
  ---------modify by dzg  2014-9-11 增加检测限制销售站类型为4中心站不可以增加终端机
  ---------modify by dzg  2014-9-18 修改插入终端版本时候多插入了3个字段。
  ---------modify by dzg 2014.10.20 修改支持本地化
  ---------modify by dzg 2014.10.27 修改bug检测所属站点编码的有效性 =0未判断。
  ---------modify by dzg 2015.03.02 增加其他异常退出时对默认输出值赋默认值
  ---------modify by dzg 2015.04.13 增加输入版本
  ---------migrate by Chen Zhen @ 2016-04-18
  ---------modify by Chen Zhen @ 2016-04-19 删除训练模式入口参数；写入数据库的mac地址，均为大写

  ************************************************************/
(
 --------------输入----------------
 p_term_code     IN CHAR, --终端编码
 p_agency_code   IN CHAR, --销售站编码
 p_status        IN NUMBER, --状态
 p_mac_address   IN STRING, --终端MAC
 p_unique_code   IN STRING, --唯一标识码
 p_terminal_type IN NUMBER, --终端机型号
 p_terminal_ver  IN STRING, --终端版本

 ---------出口参数---------
 c_errorcode     OUT NUMBER, --错误编码
 c_errormesg     OUT STRING, --错误原因
 c_terminal_code OUT NUMBER --终端编码

 ) IS

  v_terminal_code   CHAR(10); --终端编码，临时变量
  v_temp_agency     CHAR(8); --临时变量用于比较终端
  v_count           NUMBER(5); --临时变量
  v_default_version VARCHAR(10); --默认终端版本。

BEGIN

  /*-----------    初始化数据   ------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_default_version := '1.0.00';

  IF p_terminal_ver is not null THEN
    IF trim(p_terminal_ver) is not null THEN
      v_default_version := trim(p_terminal_ver);
    END IF;
  END IF;

  /*-------检测所属站点编码的有效性-------*/
  SELECT COUNT(inf_agencys.agency_code)
    INTO v_count
    FROM inf_agencys
   WHERE inf_agencys.agency_code = p_agency_code
     AND inf_agencys.status != eagency_status.cancelled;

  IF v_count <= 0 THEN
    c_errorcode := 1;
    --c_errormesg := '无效的销售站';
    c_errormesg     := error_msg.msg0023;
    c_terminal_code := 0;
    RETURN;
  END IF;

  /*-------检测终端编码的有效性 ------*/
  v_temp_agency := substr(p_term_code, 1, 8);
  IF v_temp_agency != p_agency_code THEN
    c_errorcode := 1;
    --c_errormesg := '终端编码不符合规范';
    c_errormesg := error_msg.msg0049;
    RETURN;
  END IF;

  /*-------检测MAC是否重复-------*/
  v_count := 0;
  SELECT COUNT(saler_terminal.terminal_code)
    INTO v_count
    FROM saler_terminal
   WHERE upper(mac_address) = upper(p_mac_address)
     AND saler_terminal.status != eterminal_status.cancelled;

  IF v_count > 0 THEN
    c_errorcode := 1;
    --c_errormesg := 'MAC地址重复';
    c_errormesg     := error_msg.msg0050;
    c_terminal_code := 0;
    RETURN;
  END IF;

  /*-------检测MAC是否有效-------*/
  select count(*)
    into v_count
    from dual
   where regexp_like(upper(p_mac_address), '[0-9||A-Z][0-9||A-Z]:[0-9||A-Z][0-9||A-Z]:[0-9||A-Z][0-9||A-Z]:[0-9||A-Z][0-9||A-Z]:[0-9||A-Z][0-9||A-Z]:[0-9||A-Z][0-9||A-Z]');

  IF v_count = 0 THEN
    c_errorcode := 1;
    --c_errormesg := 'MAC地址不是有效格式';
    c_errormesg     := error_msg.msg0048;
    c_terminal_code := 0;
    RETURN;
  END IF;

  /*-----------   插入数据  ------------*/
  v_terminal_code := p_term_code;
  c_terminal_code := v_terminal_code;

  INSERT INTO saler_terminal
    (terminal_code,
     agency_code,
     unique_code,
     term_type_id,
     mac_address,
     status)
  VALUES
    (v_terminal_code,
     p_agency_code,
     p_unique_code,
     p_terminal_type,
     upper(p_mac_address),
     p_status);

  --插入终端版本
  INSERT INTO upg_term_software
    (terminal_code, term_type, running_pkg_ver, downing_pkg_ver)
  VALUES
    (v_terminal_code, p_terminal_type, v_default_version, '-');

  --提交
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    --c_errormesg := '数据库异常' || SQLERRM;
    c_errormesg     := error_msg.msg0004 || SQLERRM;
    c_terminal_code := 0;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_om_terminal_modify.sql ]...... 
CREATE OR REPLACE PROCEDURE p_om_terminal_modify
/***************************************************************
  ------------------- 修改terminal -------------------
  ---------create by dzg  2014-9-24 为了减少前端验证采用存储过程
  ---------date 2014-10-23 居然发现该存储过程在svn库中消失了。重新恢复并加注本地化

  ---------migrate by Chen Zhen @ 2016-04-07 KPW 2.0 版本移植
  ************************************************************/
(
 --------------输入----------------
 p_term_code     IN char, --终端编码
 p_mac_address   IN STRING, --终端MAC
 p_unique_code   IN STRING, --唯一标识码
 p_terminal_type IN NUMBER, --终端机型号

 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因

 ) IS

  v_count NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据   ------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count := 0;

  /*-------检测终端是否有效性-------*/
  SELECT COUNT(saler_terminal.terminal_code)
    INTO v_count
    FROM saler_terminal
   WHERE saler_terminal.terminal_code = p_term_code
     AND saler_terminal.status != eterminal_status.cancelled;

  IF v_count < 0 THEN
    c_errorcode := 1;
    c_errormesg := error_msg.MSG0053;
    RETURN;
  END IF;

  /*-------检测MAC有效性是否重复-------*/
  v_count := 0;
  SELECT COUNT(saler_terminal.terminal_code)
    INTO v_count
    FROM saler_terminal
   WHERE upper(mac_address) = upper(p_mac_address)
     AND saler_terminal.terminal_code != p_term_code
     AND saler_terminal.status != eterminal_status.cancelled;

  IF v_count > 0 THEN
    c_errorcode := 1;
    c_errormesg := error_msg.MSG0050;
    RETURN;
  END IF;

  /*-------检测MAC是否有效-------*/
  select count(*)
    into v_count
    from dual
   where regexp_like(upper(p_mac_address), '[0-9||A-Z][0-9||A-Z]:[0-9||A-Z][0-9||A-Z]:[0-9||A-Z][0-9||A-Z]:[0-9||A-Z][0-9||A-Z]:[0-9||A-Z][0-9||A-Z]:[0-9||A-Z][0-9||A-Z]');

  IF v_count = 0 THEN
    c_errorcode := 1;
    --c_errormesg := 'MAC地址不是有效格式';
    c_errormesg := error_msg.msg0048;
    RETURN;
  END IF;

  /*-------更新数据------*/
  UPDATE saler_terminal
     SET unique_code   = p_unique_code,
         term_type_id  = p_terminal_type,
         mac_address   = upper(p_mac_address)
   WHERE terminal_code = p_term_code;

  --提交
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.MSG0004 || SQLERRM;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_om_terminal_status_ctrl.sql ]...... 
CREATE OR REPLACE PROCEDURE p_om_terminal_status_ctrl
/****************************************************************/
  ------------------- 适用于控制终端机状态 --------------------
  -------add by dzg 2014-9-19 由于监控延迟可能导致状态更新问题
  -------修订前台对关键对象操作采用存储过程，以便统一入口校验
  -------modify by dzg 2014.10.20 修改支持本地化

  ---------migrate by Chen Zhen @ 2016-04-07 KPW 2.0 版本移植
  /*************************************************************/
(

 --------------输入----------------
 p_terminalcode   IN char, --终端编号
 p_terminalstatus IN NUMBER, --终端机状态

 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 ) IS

  v_temp NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  /*-------检查状态有效-----*/
  IF (p_terminalstatus < eterminal_status.enabled or
     p_terminalstatus > eterminal_status.cancelled) THEN
    c_errorcode := 1;
    --c_errormesg := '无效的状态值';
    c_errormesg := error_msg.MSG0006;
    RETURN;
  END IF;

  /*-------检查是否存在------*/
  v_temp := 0;

  SELECT COUNT(saler_terminal.terminal_code)
    INTO v_temp
    FROM saler_terminal
   WHERE saler_terminal.terminal_code = p_terminalcode;

  IF v_temp <= 0 THEN
    c_errorcode := 1;
    --c_errormesg := '无效的终端机';
    c_errormesg := error_msg.MSG0053;
    RETURN;
  END IF;

  /*-------检查当前状态是否一致,如果清退则提示已经清退-----*/
  v_temp := 0;

  SELECT saler_terminal.status
    INTO v_temp
    FROM saler_terminal
   WHERE saler_terminal.terminal_code = p_terminalcode;

  IF v_temp = p_terminalstatus THEN
    c_errorcode := 1;
    --c_errormesg := '数据库中已经是当前状态';
    c_errormesg := error_msg.MSG0007;
    RETURN;
  END IF;

  IF v_temp = eterminal_status.cancelled THEN
    c_errorcode := 1;
    --c_errormesg := '终端已退机不能执行当前操作';
    c_errormesg := error_msg.MSG0054;
    RETURN;
  END IF;

  /*-----------    更新数据  -----------------*/

  UPDATE saler_terminal
     SET status = p_terminalstatus
   WHERE terminal_code = p_terminalcode;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    --c_errormesg := '数据库异常' || SQLERRM;
    c_errormesg := error_msg.MSG0004 || SQLERRM;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_om_update_sysparam.sql ]...... 
CREATE OR REPLACE PROCEDURE p_om_update_sysparam
/****************************************************************/
  ------------------- 适用于更新系统参数 -------------------
  ----add by dzg 2014-07-21 基于分割符号
  ----传入参数格式： 1-1111#2-20000
  ----modify by dzg 2014.10.20 修改支持本地化
  /*************************************************************/
(
 --------------输入----------------
 p_params IN STRING, --参数，格式1-1111#2-20000

 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 ) IS

  v_split_kv     STRING(1); --分割符号
  v_split_values STRING(1); --分割符号
  v_key          STRING(3); --key
  v_value        STRING(20); --value
  v_temp         STRING(25); --key-value

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_split_kv     := '-';
  v_split_values := '#';

  /*-----------    删除期次   -----------------*/
  IF length(p_params) <= 0 THEN
    c_errorcode := 1;
    --c_errormesg := '无效的参数对象';
    c_errormesg := error_msg.MSG0055;

    RETURN;
  END IF;

  /*-----------  循环更新 ---------------*/
  IF length(p_params) > 0 THEN

    FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_params, v_split_values))) LOOP
      dbms_output.put_line(i.column_value);
      v_temp  := '';
      v_key   := '';
      v_value := '';
      IF length(i.column_value) > 0 THEN
        v_temp  := i.column_value;
        v_key   := substr(v_temp, 0, instr(v_temp, v_split_kv) - 1);
        v_value := substr(v_temp, instr(v_temp, v_split_kv) + 1);

        UPDATE sys_parameter
           SET sys_parameter.sys_default_value = v_value
         WHERE sys_parameter.sys_default_seq = v_key;

      END IF;
    END LOOP;

  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    --c_errormesg := '数据库异常' || SQLERRM;
    c_errormesg := error_msg.MSG0004 || SQLERRM;

END p_om_update_sysparam;
 
/ 
prompt 正在建立[PROCEDURE -> p_om_updplan_create.sql ]...... 
CREATE OR REPLACE PROCEDURE p_om_updplan_create
/****************************************************************/
  ------------------- 适用于创建升级计划 -------------------
  ----add by dzg: 2014-07-14 创建升级计划
  ----业务流程：先插入计划表，依次更新对应范围的区域
  ----modify by dzg 2014-08-07 修该bug当区域和站点交叉时distinct
  ----否则不能插入数据到过程表
  ----modify by dzg 2014-09-17 增加检查终端是否存在
  ----modify by dzg 2014.10.20 修改支持本地化
  ----modify by dzg 2015.03.02 增加其他默认值的异常退出输出值
  ----migrate by Chen Zhen @ 2016-04-14
  /*************************************************************/
(
 --------------输入----------------
 p_plan_name         IN STRING, --计划名称
 p_terminal_type     IN NUMBER, --终端机型
 p_terminal_version  IN STRING, --终端机版本
 p_update_time       IN STRING, --升级时间
 p_update_area_scope IN STRING, --区域升级范围，使用“,”分割的多个字符串
 p_update_terms      IN STRING, --区域终端列表，使用“,”分割的多个字符串
 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING, --错误原因
 c_plan_id   OUT NUMBER --计划编号

 ) IS

  v_plan_id        NUMBER := 0; --临时变量
  v_count_temp     NUMBER := 0; --临时变量
  v_is_con_country NUMBER := 0; --临时变量(是否包含全国)

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_plan_id    := 0;
  v_count_temp := 0;
  /*----------- 数据校验   -----------------*/

  /*----------- 检测名称重复 ---------------*/

  SELECT COUNT(u.schedule_id)
    INTO v_count_temp
    FROM upg_upgradeplan u
   WHERE u.schedule_name = p_plan_name;
  IF v_count_temp > 0 THEN
    c_errorcode := 1;
    --c_errormesg := '升级计划名称重复';
    c_errormesg := error_msg.msg0056;
    c_plan_id   := 0;
    RETURN;
  END IF;

  IF (length(p_update_terms) <= 0 AND length(p_update_area_scope) <= 0) THEN
    c_errorcode := 1;
    --c_errormesg := '无效的升级对象';
    c_errormesg := error_msg.msg0057;
    c_plan_id   := 0;
    RETURN;
  END IF;

  /*----------- 检测升级终端是否机型一致 ---------------*/
  IF length(p_update_terms) > 0 THEN

    FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_update_terms))) LOOP
      dbms_output.put_line(i.column_value);
      v_count_temp := 0;
      IF length(i.column_value) > 0 THEN

        --检测是否存在
        SELECT COUNT(saler_terminal.terminal_code)
          INTO v_count_temp
          FROM saler_terminal
         WHERE saler_terminal.terminal_code = trim(i.column_value);

        IF v_count_temp < 0 THEN
          c_errorcode := 1;
          --c_errormesg := '终端(' || i.column_value || ')不存在';
          c_errormesg := error_msg.msg0058 || '(' || i.column_value || ')' ||
                         error_msg.msg0059;
          c_plan_id   := 0;
          RETURN;
        END IF;

        --检测是否型号一致
        v_count_temp := 0;

        SELECT COUNT(saler_terminal.terminal_code)
          INTO v_count_temp
          FROM saler_terminal
         WHERE saler_terminal.terminal_code = trim(i.column_value)
           AND saler_terminal.term_type_id = p_terminal_type;

        IF v_count_temp < 0 THEN
          c_errorcode := 1;
          --c_errormesg := '终端(' || i.column_value || ')机型和升级版本要求不匹配';
          c_errormesg := error_msg.msg0058 || '(' || i.column_value || ')' ||
                         error_msg.msg0060;
          c_plan_id   := 0;
          RETURN;
        END IF;

      END IF;
    END LOOP;

  END IF;

  /*----------- 检测是否包含 总公司 ---------------*/
  SELECT count(*)
    into v_is_con_country
    FROM TABLE(dbtool.strsplit(p_update_area_scope))
   where column_value = '00';

  /*----------- 插入数据  -----------------*/

  --插入计划
  v_plan_id := f_get_upg_schedule_seq();
  INSERT INTO upg_upgradeplan
    (schedule_id,
     schedule_name,
     pkg_ver,
     term_type,
     schedule_status,
     schedule_sw_date,
     schedule_cr_date)
  VALUES
    (v_plan_id,
     p_plan_name,
     p_terminal_version,
     p_terminal_type,
     eschedule_status.planning,
     to_date(p_update_time, 'yyyy-mm-dd hh24:mi:ss'),
     SYSDATE);

  --更新终端

  IF v_is_con_country = 1 THEN

    INSERT INTO upg_upgradeproc
      SELECT saler_terminal.terminal_code,
             v_plan_id,
             p_terminal_version,
             0,
             NULL,
             NULL,
             NULL,
             NULL
        FROM saler_terminal
       WHERE saler_terminal.status != eterminal_status.cancelled
         AND saler_terminal.term_type_id = p_terminal_type;
  ELSE
    IF (length(p_update_terms) > 0 AND length(p_update_area_scope) > 0) THEN

      INSERT INTO upg_upgradeproc
        (terminal_code, schedule_id, pkg_ver, is_comp_dl)
        SELECT DISTINCT saler_terminal.terminal_code,
                        v_plan_id,
                        p_terminal_version,
                        0
          FROM saler_terminal, inf_agencys, inf_orgs
         WHERE saler_terminal.agency_code = inf_agencys.agency_code
           AND inf_agencys.org_code = inf_orgs.org_code
           AND saler_terminal.status != eterminal_status.cancelled
           AND saler_terminal.term_type_id = p_terminal_type
           AND ((inf_orgs.org_code IN
               (SELECT * FROM TABLE(dbtool.strsplit(p_update_area_scope)))) OR
               saler_terminal.terminal_code IN
               (SELECT * FROM TABLE(dbtool.strsplit(p_update_terms))));
    ELSE
      IF (length(p_update_terms) > 0) THEN
        INSERT INTO upg_upgradeproc
          (terminal_code, schedule_id, pkg_ver, is_comp_dl)
          SELECT DISTINCT saler_terminal.terminal_code,
                          v_plan_id,
                          p_terminal_version,
                          0
            FROM saler_terminal
           WHERE saler_terminal.status != eterminal_status.cancelled
             AND saler_terminal.term_type_id = p_terminal_type
             AND saler_terminal.terminal_code IN
                 (SELECT * FROM TABLE(dbtool.strsplit(p_update_terms)));
      ELSE
        INSERT INTO upg_upgradeproc
          (terminal_code, schedule_id, pkg_ver, is_comp_dl)
          SELECT DISTINCT saler_terminal.terminal_code,
                          v_plan_id,
                          p_terminal_version,
                          0
            FROM saler_terminal, inf_agencys, inf_orgs
           WHERE saler_terminal.agency_code = inf_agencys.agency_code
             AND inf_agencys.org_code = inf_orgs.org_code
             AND saler_terminal.status != eterminal_status.cancelled
             AND saler_terminal.term_type_id = p_terminal_type
             AND (inf_orgs.org_code IN
                 (SELECT * FROM TABLE(dbtool.strsplit(p_update_area_scope))));
      END IF;
    END IF;
  END IF;
  c_plan_id := v_plan_id;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    --c_errormesg := '数据库异常' || SQLERRM;
    c_errormesg := error_msg.msg0004 || SQLERRM;
    c_plan_id   := 0;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_om_updplan_modify.sql ]...... 
CREATE OR REPLACE PROCEDURE p_om_updplan_modify
/****************************************************************/
  ------------------- 适用于修改升级计划 -------------------
  ----create by dzg 2014-09-17 增加检查终端是否存在
  ----modify by dzg 2014.10.20 修改支持本地化
  /*************************************************************/
(
 --------------输入----------------
 p_plan_id          IN NUMBER, --计划编号
 p_plan_name        IN STRING, --计划名称
 p_terminal_version IN STRING, --终端机版本
 p_update_time      IN STRING, --升级时间
 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因

 ) IS

  v_count_temp NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  /*----------- 数据校验   -----------------*/

  /*----------- 检测名称重复 ---------------*/

  v_count_temp := 0;

  SELECT COUNT(u.schedule_id)
    INTO v_count_temp
    FROM upg_upgradeplan u
   WHERE u.schedule_name = p_plan_name
     AND u.schedule_id != p_plan_id;
  IF v_count_temp > 0 THEN
    c_errorcode := 1;
    --c_errormesg := '升级计划名称重复';
    c_errormesg := error_msg.MSG0056;
    RETURN;
  END IF;

  /*----------- 更新计划 -----------------*/

  UPDATE upg_upgradeplan
     SET schedule_name = p_plan_name, pkg_ver = p_terminal_version,
         schedule_sw_date = to_date(p_update_time, 'yyyy-mm-dd hh24:mi:ss')
   WHERE schedule_id = p_plan_id;

  -------更新升级过程

  UPDATE upg_upgradeproc
     SET pkg_ver = p_terminal_version
   WHERE schedule_id = p_plan_id;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    --c_errormesg := '数据库异常' || SQLERRM;
    c_errormesg := error_msg.MSG0004 || SQLERRM;

END p_om_updplan_modify;
 
/ 
prompt 正在建立[PROCEDURE -> p_org_fund_change.sql ]...... 
create or replace procedure p_org_fund_change
/****************************************************************/
   ------------------- 机构资金处理（不提交） -------------------
   ---- 按照输入类型，处理机构资金，同时增加相应的资金流水
   ---- add by 陈震: 2015/9/24

   /*************************************************************/
(
   --------------输入----------------
   p_org                               in char,           -- 机构
   p_type                              in char,           -- 资金类型
   p_amount                            in char,           -- 调整金额
   p_frozen                            in number,         -- 冻结金额
   p_ref_no                            in varchar2,       -- 参考业务编号

   --------------输入----------------
   c_balance                           out number,        -- 账户余额
   c_f_balance                         out number         -- 冻结账户余额

 ) is

   v_acc_no                char(12);                      -- 账户编码
   v_balance               number(28);                    -- 账户余额
   v_frozen_balance        number(28);                    -- 账户冻结余额
   v_credit_limit          number(28);                    -- 信用额度
   v_amount                number(28);                    -- 账户调整金额
   v_frozen                number(28);                    -- 冻结账户调整金额

begin
   -- 按照类型，处理正负号
   case
      when p_type in (eflow_type.charge, eflow_type.org_comm, eflow_type.org_return,
                      eflow_type.org_agency_pay_comm, eflow_type.org_agency_pay,
                      eflow_type.org_center_pay_comm, eflow_type.org_center_pay,eflow_type.org_center_pay,
                      eflow_type.org_lottery_center_cancel, eflow_type.org_lottery_center_pay, eflow_type.org_lottery_center_pay_comm,
                      eflow_type.org_lottery_agency_pay_comm, eflow_type.org_lottery_agency_pay, eflow_type.org_lottery_agency_sale_comm, eflow_type.org_lottery_agency_cancel) then
         v_amount := p_amount;
         v_frozen := 0;

      when p_type in (eflow_type.withdraw, eflow_type.carry, eflow_type.org_comm_org_return, eflow_type.org_lottery_agency_sale ,eflow_type.org_lottery_cancel_comm) then
         v_amount := 0 - p_amount;
         v_frozen := 0;

      else
         raise_application_error(-20001, dbtool.format_line(p_type) || error_msg.err_p_fund_change_2);            -- 资金类型不合法

   end case;

   -- 更新余额
   update ACC_ORG_ACCOUNT
      set account_balance = account_balance + v_amount,
          frozen_balance = frozen_balance + v_frozen
    where ORG_CODE = p_org
      and acc_type = eacc_type.main_account
      and acc_status = eacc_status.available
   returning
      acc_no,   credit_limit,   account_balance, frozen_balance
   into
      v_acc_no, v_credit_limit, v_balance,       v_frozen_balance;

   if v_credit_limit + v_balance < 0 then
      raise_application_error(-20102, dbtool.format_line(p_org) || error_msg.err_p_fund_change_1);            -- 账户余额不足
   end if;

   insert into flow_org
      (org_fund_flow,      ref_no,   flow_type, acc_no,   org_code, change_amount, be_account_balance,   af_account_balance, be_frozen_balance,           af_frozen_balance, frozen_amount)
   values
      (f_get_flow_org_seq, p_ref_no, p_type,    v_acc_no, p_org,    p_amount,      v_balance - v_amount, v_balance,          v_frozen_balance - v_frozen, v_frozen_balance,  p_frozen);

   c_balance := v_balance;
   c_f_balance := v_frozen_balance;
end; 
/ 
prompt 正在建立[PROCEDURE -> p_org_plan_auth.sql ]...... 
CREATE OR REPLACE PROCEDURE p_org_plan_auth
/***************************************************************
  ------------------- 组织机构方案批量授权 -------------------
  ---------add by dzg  2015-9-16 组织机构的方案授权
  ----modify by dzg 2015-9-17 写错了销售佣金额度
  ************************************************************/
(
 
 --------------输入----------------
 p_org_code       IN STRING, --机构编号
 p_org_credit     IN NUMBER, --机构信用额度
 p_game_auth_list IN type_game_auth_list, --授权方案列表
 
 --------------出口参数----------------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 
 ) IS

  v_cur_auth_info type_game_auth_info; --当前授权信息，用于循环遍历
  v_temp          NUMBER := 0; --临时变量，发行费用

BEGIN
  /*-----------    初始化数据    -----------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  /*-----------  输入数据校验    ----------*/
  IF p_game_auth_list.count < 0 THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_ORG_PLAN_AUTH_1;
    RETURN;
  END IF;

  /*-----------  校验发行费用    ----------*/
  FOR i IN 1 .. p_game_auth_list.count LOOP
  
    v_cur_auth_info := p_game_auth_list(i);
    ---比较值
    IF 1000 < v_cur_auth_info.salecommissionrate THEN
      c_errorcode := 1;
      --c_errormesg := '发行费用超出范围';
      c_errormesg := error_msg.ERR_P_ORG_PLAN_AUTH_2;
      RETURN;
    END IF;
  
  END LOOP;

  /*-----------  更新信用额度       -----------*/

  update acc_org_account
     set credit_limit = p_org_credit
   where org_code = p_org_code
     and acc_type = eacc_type.main_account;

  v_cur_auth_info := NULL;

  /*----------- 选择销售站循环插入 -----------*/

  FOR i IN 1 .. p_game_auth_list.count LOOP
  
    v_cur_auth_info := p_game_auth_list(i);
  
    ---先清除
    DELETE FROM game_org_comm_rate au
     WHERE au.plan_code = v_cur_auth_info.plancode
       AND au.org_code = p_org_code;
  
    ---后插入
    insert into game_org_comm_rate
      (org_code, plan_code, sale_comm, pay_comm)
    values
      (p_org_code,
       v_cur_auth_info.plancode,
       v_cur_auth_info.salecommissionrate,
       v_cur_auth_info.paycommissionrate);
  
  END LOOP;
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END;
 
/ 
prompt 正在建立[PROCEDURE -> p_outlet_create.sql ]...... 
CREATE OR REPLACE PROCEDURE p_outlet_create
/****************************************************************/
  ------------------- 适用于新增站点-------------------
  ----创建组织结构
  ----add by dzg: 2015-9-12
  ----业务流程：先插入主表，插入附属表，默认状态为可用
  ----编码自动生成，返回站点编码
  ----modify by dzg        2015-9-15   增加功能，在新增时创建账户
  ----modify by chenzhen   2016-03-17  增加功能，在新增时创建teller
  /*************************************************************/
(
 --------------输入----------------

 p_outlet_name      IN STRING, --站点名称
 p_outlet_person    IN STRING, --站点联系人
 p_outlet_phone     IN STRING, --站点联系人电话
 p_outlet_bankid    IN NUMBER, --关联银行
 p_outlet_bankacc   IN STRING, --关联银行账号
 p_outlet_pid       IN STRING, --证件号码
 p_outlet_cno       IN STRING, --合同编码
 p_area_code        IN STRING, --所属区域
 p_Institution_code IN STRING, --所属部门
 p_outlet_address   IN STRING, --所属区域
 p_outlet_stype     IN NUMBER, --店面类型
 p_outlet_type      IN NUMBER, --站点类型
 p_outlet_admin     IN NUMBER, --站点管理人员
 p_outlet_g_n       IN STRING, --站点经度
 p_outlet_g_e       IN STRING, --站点维度
 p_outlet_pwd       IN STRING, --站点默认密码

 ---------出口参数---------
 c_outlet_code OUT STRING, --站点编码
 c_errorcode   OUT NUMBER, --错误编码
 c_errormesg   OUT STRING --错误原因

 ) IS

  v_count_temp NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  c_outlet_code := '';
  v_count_temp  := 0;

  /*----------- 数据校验   -----------------*/
  --部门编码不能为空
  IF ((p_Institution_code IS NULL) OR length(p_Institution_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_OUTLET_CREATE_1;
    RETURN;
  END IF;

  --部门无效
  SELECT count(u.org_code)
    INTO v_count_temp
    FROM inf_orgs u
   WHERE u.org_code = p_Institution_code
     And u.org_status = eorg_status.available;

  IF v_count_temp <= 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.ERR_P_OUTLET_CREATE_2;
    RETURN;
  END IF;

  --区域不能为空
  IF ((p_area_code IS NULL) OR length(p_area_code) <= 0) THEN
    c_errorcode := 3;
    c_errormesg := error_msg.ERR_P_OUTLET_CREATE_3;
    RETURN;
  END IF;

  --区域无效

  v_count_temp := 0;
  SELECT count(u.area_code)
    INTO v_count_temp
    FROM inf_areas u
   WHERE u.area_code = p_area_code;

  IF v_count_temp <= 0 THEN
    c_errorcode := 4;
    c_errormesg := error_msg.ERR_P_OUTLET_CREATE_4;
    RETURN;
  END IF;

  --插入基本信息

  --先生成编码
  c_outlet_code := f_get_agency_code_by_area(p_area_code);

  insert into inf_agencys
    (agency_code,
     agency_name,
     storetype_id,
     status,
     agency_type,
     bank_id,
     bank_account,
     telephone,
     contact_person,
     address,
     agency_add_time,
     org_code,
     area_code,
     login_pass,
     trade_pass,
     market_manager_id)
  values
    (c_outlet_code,
     p_outlet_name,
     p_outlet_stype,
     eagency_status.enabled,
     p_outlet_type,
     p_outlet_bankid,
     p_outlet_bankacc,
     p_outlet_phone,
     p_outlet_person,
     p_outlet_address,
     sysdate,
     p_Institution_code,
     p_area_code,
     p_outlet_pwd,
     p_outlet_pwd,
     p_outlet_admin);

  --插入扩展信息

  insert into inf_agency_ext
    (agency_code, personal_id, contract_no, glatlng_n, glatlng_e)
  values
    (c_outlet_code, p_outlet_pid, p_outlet_cno, p_outlet_g_n, p_outlet_g_e);

  --生成账户信息
  insert into acc_agency_account
    (agency_code,
     acc_type,
     acc_name,
     acc_status,
     acc_no,
     credit_limit,
     account_balance,
     frozen_balance,
     check_code)
  values
    (c_outlet_code,
     eacc_type.main_account,
     p_outlet_name,
     eacc_status.available,
     f_get_acc_no(c_outlet_code, 'ZD'),
     0,
     0,
     0,
     '-');

  --生成teller信息
  insert into inf_tellers
    (teller_code,
     agency_code,
     teller_name,
     teller_type,
     status,
     password)
  values
    (to_number(c_outlet_code),
     c_outlet_code,
     p_outlet_person,
     eteller_type.manager,
     eteller_status.enabled,
     p_outlet_pwd);

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END p_outlet_create;
 
/ 
prompt 正在建立[PROCEDURE -> p_outlet_modify.sql ]...... 
CREATE OR REPLACE PROCEDURE p_outlet_modify
/****************************************************************/
  ------------------- 适用于修改站点-------------------
  ----修改站点信息
  ----如果编码不能修改，就把新旧的编码都设成一样的
  ----修改会检测p_outlet_code 是否已经存在
  ----如果修改同时修改扩展，账户编号；如果发现有充值或者预订信息则编码不能修改
  ----add by dzg: 2015-9-12
  ----modify by dzg:2015-9-15 增加修改经纬度
  /*************************************************************/
(
 --------------输入----------------
 p_outlet_code_o    IN STRING, --站点原编码
 p_outlet_code      IN STRING, --站点新编码
 p_outlet_name      IN STRING, --站点名称
 p_outlet_person    IN STRING, --站点联系人
 p_outlet_phone     IN STRING, --站点联系人电话
 p_outlet_bankid    IN NUMBER, --关联银行
 p_outlet_bankacc   IN STRING, --关联银行账号
 p_outlet_pid       IN STRING, --证件号码
 p_outlet_cno       IN STRING, --合同编码
 p_area_code        IN STRING, --所属区域
 p_Institution_code IN STRING, --所属部门
 p_outlet_address   IN STRING, --站点地址
 p_outlet_stype     IN NUMBER, --店面类型
 p_outlet_type      IN NUMBER, --站点类型
 p_outlet_admin     IN NUMBER, --站点管理人员
 p_outlet_g_n       IN STRING, --站点经度
 p_outlet_g_e       IN STRING, --站点维度

 ---------出口参数---------
 c_outlet_code OUT STRING, --站点编码
 c_errorcode   OUT NUMBER, --错误编码
 c_errormesg   OUT STRING --错误原因

 ) IS

  v_count_temp NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  c_outlet_code := p_outlet_code;
  v_count_temp  := 0;

  /*----------- 数据校验   -----------------*/
  --部门编码不能为空
  IF ((p_Institution_code IS NULL) OR length(p_Institution_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_OUTLET_CREATE_1;
    RETURN;
  END IF;

  --部门无效
  SELECT count(u.org_code)
    INTO v_count_temp
    FROM inf_orgs u
   WHERE u.org_code = p_Institution_code
     And u.org_status = eorg_status.available;

  IF v_count_temp <= 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.ERR_P_OUTLET_CREATE_2;
    RETURN;
  END IF;

  --区域不能为空
  IF ((p_area_code IS NULL) OR length(p_area_code) <= 0) THEN
    c_errorcode := 3;
    c_errormesg := error_msg.ERR_P_OUTLET_CREATE_3;
    RETURN;
  END IF;

  --区域无效

  v_count_temp := 0;
  SELECT count(u.area_code)
    INTO v_count_temp
    FROM inf_areas u
   WHERE u.area_code = p_area_code;

  IF v_count_temp <= 0 THEN
    c_errorcode := 4;
    c_errormesg := error_msg.ERR_P_OUTLET_CREATE_4;
    RETURN;
  END IF;

  --检测站点编码
  IF p_outlet_code <> p_outlet_code_o THEN

    --非空
    IF ((p_outlet_code IS NULL) OR length(p_outlet_code) <= 0) THEN
      c_errorcode := 6;
      c_errormesg := error_msg.ERR_P_OUTLET_MODIFY_2;
      RETURN;
    END IF;

    --长度
    IF (length(p_outlet_code) <> 8) THEN
      c_errorcode := 6;
      c_errormesg := error_msg.ERR_P_OUTLET_MODIFY_2;
      RETURN;
    END IF;

    v_count_temp := substr(p_outlet_code, 0, 4);
    --前四位区域编码
    IF (p_area_code <> v_count_temp) THEN
      c_errorcode := 6;
      c_errormesg := error_msg.ERR_P_OUTLET_MODIFY_2;
      RETURN;
    END IF;

    --编码重复
    v_count_temp := 0;
    SELECT count(u.agency_code)
      INTO v_count_temp
      FROM inf_agencys u
     WHERE u.agency_code = p_outlet_code;

    IF v_count_temp > 0 THEN
      c_errorcode := 5;
      c_errormesg := error_msg.ERR_P_OUTLET_MODIFY_2;
      RETURN;
    END IF;

    --有资金业务
    v_count_temp := 0;
    SELECT count(a.agency_fund_flow)
      INTO v_count_temp
      FROM flow_agency a, acc_agency_account c
     WHERE a.acc_no = c.acc_no
       AND c.agency_code = p_outlet_code;

    IF v_count_temp > 0 THEN
      c_errorcode := 6;
      c_errormesg := error_msg.ERR_P_OUTLET_MODIFY_3;
      RETURN;
    END IF;

    --有订单业务
    v_count_temp := 0;
    SELECT count(u.order_no)
      INTO v_count_temp
      FROM sale_order u
     WHERE u.apply_agency = p_outlet_code;

    IF v_count_temp > 0 THEN
      c_errorcode := 5;
      c_errormesg := error_msg.ERR_P_OUTLET_CREATE_1;
      RETURN;
    END IF;

  END IF;

  --基本信息
  update inf_agencys
     set agency_code       = c_outlet_code,
         agency_name       = p_outlet_name,
         storetype_id      = p_outlet_stype,
         agency_type       = p_outlet_type,
         bank_id           = p_outlet_bankid,
         bank_account      = p_outlet_bankacc,
         telephone         = p_outlet_phone,
         contact_person    = p_outlet_person,
         address           = p_outlet_address,
         org_code          = p_Institution_code,
         area_code         = p_area_code,
         market_manager_id = p_outlet_admin
   where agency_code = p_outlet_code_o;

  --扩展信息
  update inf_agency_ext
     set agency_code = c_outlet_code,
         personal_id = p_outlet_pid,
         contract_no = p_outlet_cno,
         glatlng_n   = p_outlet_g_n,
         glatlng_e   = p_outlet_g_e
   where agency_code = p_outlet_code_o;

  IF p_outlet_code_o <> p_outlet_code_o THEN
    --更新账户
    update acc_agency_account
       set agency_code = c_outlet_code
     where agency_code = p_outlet_code_o;

    --变更资金结算率
    update game_agency_comm_rate
       set agency_code = c_outlet_code
     where agency_code = p_outlet_code_o;
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END p_outlet_modify;
 
/ 
prompt 正在建立[PROCEDURE -> p_outlet_plan_auth.sql ]...... 
CREATE OR REPLACE PROCEDURE p_outlet_plan_auth
/***************************************************************
  ------------------- 销售站方案批量授权 -------------------
  ---------add by dzg  2015-9-15 单个站点的方案授权
  ---------modify by dzg 2015-11-27 修改站点信用额度，只有代销商时才比较值
  ************************************************************/
(

 --------------输入----------------
 p_outlet_code    IN STRING, --站点编号
 p_outlet_credit  IN NUMBER, --站点信用额度
 p_game_auth_list IN type_game_auth_list, --授权方案列表

 --------------出口参数----------------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因

 ) IS

  v_cur_auth_info type_game_auth_info; --当前授权信息，用于循环遍历
  v_temp          NUMBER := 0; --临时变量，发行费用

BEGIN
  /*-----------    初始化数据    -----------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  /*-----------  输入数据校验    ----------*/
  IF p_game_auth_list.count < 0 THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_OUTLET_PLAN_AUTH_1;
    RETURN;
  END IF;

  /*-----------  校验发行费用    ----------*/


select g.org_type
  into v_temp
  from inf_orgs g
 where g.org_code in (select a.org_code
                        from inf_agencys a
                       where a.agency_code = p_outlet_code);

  if(v_temp is not null and v_temp = eorg_type.agent) then


  FOR i IN 1 .. p_game_auth_list.count LOOP

    v_cur_auth_info := p_game_auth_list(i);
    v_temp          := 0;

    ---获取父区域游戏授权信息

    begin
      SELECT game_org_comm_rate.sale_comm
        INTO v_temp
        FROM game_org_comm_rate
       WHERE game_org_comm_rate.plan_code = v_cur_auth_info.plancode
         AND game_org_comm_rate.org_code IN
             (SELECT inf_agencys.org_code
                FROM inf_agencys
               WHERE inf_agencys.agency_code = v_cur_auth_info.agencycode);

    exception
      when no_data_found then
        v_temp := 0;
    end;

    ---比较值
    IF v_temp < v_cur_auth_info.salecommissionrate THEN
      c_errorcode := 1;
      c_errormesg := error_msg.ERR_P_OUTLET_PLAN_AUTH_2;
      RETURN;
    END IF;

  END LOOP;

  end if;

  /*-----------  更新信用额度       -----------*/

  update acc_agency_account
     set credit_limit = p_outlet_credit
   where agency_code = p_outlet_code
     and acc_type = eacc_type.main_account;

  v_cur_auth_info := NULL;

  /*----------- 选择销售站循环插入 -----------*/

  FOR i IN 1 .. p_game_auth_list.count LOOP

    v_cur_auth_info := p_game_auth_list(i);

    ---先清除
    DELETE FROM game_agency_comm_rate au
     WHERE au.plan_code = v_cur_auth_info.plancode
       AND au.agency_code = v_cur_auth_info.agencycode;

    ---后插入
    insert into game_agency_comm_rate
      (agency_code, plan_code, sale_comm, pay_comm)
    values
      (p_outlet_code,
       v_cur_auth_info.plancode,
       v_cur_auth_info.salecommissionrate,
       v_cur_auth_info.paycommissionrate);

  END LOOP;
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_outlet_topup.sql ]...... 
CREATE OR REPLACE PROCEDURE p_outlet_topup
/****************************************************************/
   ------------------- 适用于站点充值-------------------
   ----站点充值
   ----add by dzg: 2015-9-24
   ----业务流程：插入申请表，插入流水，更新账户
   --- POS:outletCode  amount  admin transPassword（市场管理员）
   --- OMS 参数相同
   ----需要调用陈震存储过程
   ----修改输出的时候初始化返回值
   /*************************************************************/
(
 --------------输入----------------

 p_outlet_code IN STRING, --站点编码
 p_amount      IN NUMBER, --充值金额
 p_admin_id    IN NUMBER, --市场管理人员
 p_admin_tpwd  IN STRING, --市场管理交易密码

 ---------出口参数---------
 c_flow_code  OUT STRING, --申请流水
 c_bef_amount OUT NUMBER, --充值前金额
 c_aft_amount OUT NUMBER, --充值后金额
 c_errorcode  OUT NUMBER, --错误编码
 c_errormesg  OUT STRING --错误原因

 ) IS

   v_count_temp   NUMBER := 0; --临时变量
   v_outlet_name  varchar2(500) := ''; --站点名称
   v_outlet_accno varchar2(50) := ''; --站点账户编号

BEGIN

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   v_count_temp := 0;
   c_flow_code  := '-';
   c_bef_amount := 0;
   c_aft_amount := 0;

   /*----------- 数据校验   -----------------*/
   --编码不能为空
   IF ((p_outlet_code IS NULL) OR length(p_outlet_code) <= 0) THEN
      c_errorcode := 1;
      c_errormesg := error_msg.ERR_P_OUTLET_TOPUP_1;
      RETURN;
   END IF;

   --用户不存在或者无效
   SELECT count(u.admin_id)
     INTO v_count_temp
     FROM adm_info u
    WHERE u.admin_id = p_admin_id
      And u.admin_status <> eadmin_status.DELETED;

   IF v_count_temp <= 0 THEN
      c_errorcode := 2;
      c_errormesg := error_msg.ERR_P_OUTLET_TOPUP_2;
      RETURN;
   END IF;

   --密码不能为空
   IF ((p_admin_tpwd IS NULL) OR length(p_admin_tpwd) <= 0) THEN
      c_errorcode := 3;
      c_errormesg := error_msg.ERR_P_OUTLET_TOPUP_3;
      RETURN;
   END IF;

   --密码无效
   v_count_temp := 0;
   SELECT count(u.market_admin)
     INTO v_count_temp
     FROM inf_market_admin u
    WHERE u.market_admin = p_admin_id
      AND u.trans_pass = p_admin_tpwd;

   IF v_count_temp <= 0 THEN
      c_errorcode := 4;
      c_errormesg := error_msg.ERR_P_OUTLET_TOPUP_4;
      RETURN;
   END IF;

   --插入基本信息

   select a.agency_name, b.acc_no
     INTO v_outlet_name, v_outlet_accno
     from inf_agencys a
     left join acc_agency_account b
       on a.agency_code = b.agency_code
    where a.agency_code = p_outlet_code;

   --先生成编码
   c_flow_code := f_get_fund_charge_cash_seq();

   --插入资金流水相关信息
   p_agency_fund_change(p_outlet_code,
                        eflow_type.charge,
                        p_amount,
                        0,
                        c_flow_code,
                        c_aft_amount,
                        v_count_temp);

   insert into fund_charge_center
      (fund_no,
       account_type,
       ao_code,
       ao_name,
       acc_no,
       oper_amount,
       be_account_balance,
       af_account_balance,
       oper_time,
       oper_admin)
   values
      (c_flow_code,
       eaccount_type.agency,
       p_outlet_code,
       v_outlet_name,
       v_outlet_accno,
       p_amount,
       c_aft_amount - p_amount,
       c_aft_amount,
       sysdate,
       p_admin_id);

   --插入市场管理人员信息
   p_mm_fund_change(p_admin_id,
                    eflow_type.charge_for_agency,
                    p_amount,
                    c_flow_code,
                    v_count_temp);

   c_bef_amount := c_aft_amount - p_amount;

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      c_errorcode := 1;
      c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_outlet_withdraw_app.sql ]...... 
CREATE OR REPLACE PROCEDURE p_outlet_withdraw_app
/****************************************************************/
  ------------------- 适用于站点提现申请-------------------
  ----站点提现
  ----add by dzg: 2015-9-24
  ----业务流程：插入申请表
  --- POS:outletCode  amount  admin （市场管理员）
  --- OMS 参数相同
  --- modify by dzg 2015-10-22 增加验证站点密码
  --- 修改逻辑判断错误：账户金额<申请金额不能提现
  /*************************************************************/
(
 --------------输入----------------
 
 p_outlet_code      IN STRING, --站点编码
 p_password         IN STRING, --站点密码
 p_amount           IN NUMBER, --提现金额
 p_admin_id         IN NUMBER, --市场管理人员

 
 ---------出口参数---------
 c_flow_code   OUT STRING,     --申请流水
 c_errorcode   OUT NUMBER,     --错误编码
 c_errormesg   OUT STRING      --错误原因
 
 ) IS

  v_count_temp     NUMBER := 0; --临时变量
  v_outlet_name    varchar2(500) := ''; --站点名称
  v_outlet_accno   varchar2(50) := ''; --站点账户编号

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp  := 0;

  /*----------- 数据校验   -----------------*/
  --编码不能为空
  IF ((p_outlet_code IS NULL) OR length(p_outlet_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_OUTLET_TOPUP_1;
    RETURN;
  END IF;

  --用户不存在或者无效
  SELECT count(u.admin_id)
    INTO v_count_temp
    FROM adm_info u
   WHERE u.admin_id = p_admin_id
     And u.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.ERR_P_OUTLET_TOPUP_2;
    RETURN;
  END IF;


  --检测金额
  v_count_temp := 0;
  SELECT nvl(u.account_balance,0)
    INTO v_count_temp
    FROM acc_agency_account u
   WHERE u.agency_code=p_outlet_code;

  IF v_count_temp < p_amount THEN
    c_errorcode := 3;
    c_errormesg := error_msg.err_p_outlet_withdraw_app_1;
    RETURN;
  END IF;
  
  --检测站点或密码
  v_count_temp := 0;
  SELECT count(*)
    INTO v_count_temp
    FROM inf_agencys u
   WHERE u.agency_code=p_outlet_code
   And u.login_pass = p_password ;

  IF v_count_temp <= 0 THEN
    c_errorcode := 4;
    c_errormesg := error_msg.err_p_outlet_withdraw_con_3;
    RETURN;
  END IF;

  --插入基本信息
  
  select a.agency_name, b.acc_no
    INTO v_outlet_name, v_outlet_accno
    from inf_agencys a
    left join acc_agency_account b
      on a.agency_code = b.agency_code
      where a.agency_code =p_outlet_code;

  --先生成编码
  c_flow_code := f_get_fund_charge_cash_seq();
  
  insert into fund_withdraw
  (fund_no,
   account_type,
   ao_code,
   ao_name,
   acc_no,
   apply_amount,
   apply_admin,
   apply_date,
   market_admin,
   apply_status,
   apply_memo)
values
  (c_flow_code,
   eaccount_type.agency,
   p_outlet_code,
   v_outlet_name,
   v_outlet_accno,
   p_amount,
   p_admin_id,
   sysdate,
   p_admin_id,
   eapply_status.applyed,
   '');

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END p_outlet_withdraw_app;
/
 
/ 
prompt 正在建立[PROCEDURE -> p_outlet_withdraw_con.sql ]...... 
CREATE OR REPLACE PROCEDURE p_outlet_withdraw_con
/****************************************************************/
  ------------------- 适用于站点提现确认-------------------
  ----站点提现确认
  ----add by dzg: 2015-9-24
  --- POS:outletCode  amount  admin （市场管理员）
  --- OMS 验证一些密码后则更新状态
  --- 状态值 修订最后一步枚举是提现确认
  /*************************************************************/
(
 --------------输入----------------

 p_outlet_code      IN STRING, --站点编码
 p_password         IN STRING, --站点密码
 p_app_flow         IN STRING, --申请单编号
 p_admin_id         IN NUMBER, --市场管理人员


 ---------出口参数---------
 c_errorcode   OUT NUMBER,     --错误编码
 c_errormesg   OUT STRING      --错误原因

 ) IS

  v_count_temp     NUMBER := 0; --临时变量
  v_outlet_name    varchar2(500) := ''; --站点名称
  v_outlet_accno   varchar2(50) := ''; --站点账户编号

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp  := 0;

  /*----------- 数据校验   -----------------*/
  --编码不能为空
  IF ((p_outlet_code IS NULL) OR length(p_outlet_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_OUTLET_TOPUP_1;
    RETURN;
  END IF;

   --编码不能为空
  IF ((p_app_flow IS NULL) OR length(p_app_flow) <= 0) THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_outlet_withdraw_con_1;
    RETURN;
  END IF;

  --用户不存在或者无效
  SELECT count(u.admin_id)
    INTO v_count_temp
    FROM adm_info u
   WHERE u.admin_id = p_admin_id
     And u.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 3;
    c_errormesg := error_msg.ERR_P_OUTLET_TOPUP_2;
    RETURN;
  END IF;


  --检测申请单检测
  v_count_temp := 0;
  SELECT count(u.fund_no)
    INTO v_count_temp
    FROM fund_withdraw u
   WHERE u.fund_no=p_app_flow
   And u.apply_status = eapply_status.audited ;

  IF v_count_temp <= 0 THEN
    c_errorcode := 4;
    c_errormesg := error_msg.err_p_outlet_withdraw_con_2;
    RETURN;
  END IF;

  --检测站点或密码
  v_count_temp := 0;
  SELECT count(*)
    INTO v_count_temp
    FROM inf_agencys u
   WHERE u.agency_code=p_outlet_code
   And u.login_pass = p_password ;

  IF v_count_temp <= 0 THEN
    c_errorcode := 5;
    c_errormesg := error_msg.err_p_outlet_withdraw_con_3;
    RETURN;
  END IF;


  --插入基本信息
   update fund_withdraw
      set apply_status = eapply_status.withdraw
    where fund_no = p_app_flow;


  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_plan_batch_auth.sql ]...... 
CREATE OR REPLACE PROCEDURE p_plan_batch_auth
/***************************************************************
  ------------------- 新增方案，批量授权 -------------------
  --------- add by Chen Zhen  2016-03-30 新增
  ---------
  ************************************************************/
(

 --------------输入----------------
 p_plan_code         IN STRING, -- 新方案编号
 p_ref_plan          IN STRING, -- 参考方案编号

 --------------出口参数----------------
 c_errorcode         OUT NUMBER, --错误编码
 c_errormesg         OUT STRING --错误原因

 ) IS

BEGIN
  /*-----------    初始化数据    -----------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  insert into game_org_comm_rate select org_code, p_plan_code, sale_comm, pay_comm from game_org_comm_rate where plan_code = p_ref_plan;
  insert into game_agency_comm_rate select agency_code, p_plan_code, sale_comm, pay_comm from game_agency_comm_rate where plan_code = p_ref_plan;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_roleprivilege_create.sql ]...... 
CREATE OR REPLACE PROCEDURE p_roleprivilege_create
/****************************************************************/
  ------------------- 适用于创建角色权限-------------------
  ----创建角色权限
  ----add by dzg: 2015-9-19 
  ----业务流程：先删除原来用户权限，然后插入新的角色权限
  /*************************************************************/
(
 --------------输入----------------
 p_role_id      IN NUMBER, --角色ID
 p_role_privileges   IN STRING, --权限列表,使用“,”分割的多个字符串
 
 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 
 ) IS

  v_count_temp NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --角色编码异常
  IF (p_role_id < 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_1;
    RETURN;
  END IF;

  --循环插入角色用户
  --先清理原有数据
  
  delete from adm_role_privilege
   where adm_role_privilege.role_id = p_role_id;

  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_role_privileges))) LOOP
    dbms_output.put_line(i.column_value);
  
    IF length(i.column_value) > 0 THEN
      
    insert into adm_role_privilege
      (role_id, privilege_id)
    values
      (p_role_id,i.column_value);
  
    
    END IF;
  END LOOP;
  

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END p_roleprivilege_create;
/
 
/ 
prompt 正在建立[PROCEDURE -> p_roleuser_create.sql ]...... 
CREATE OR REPLACE PROCEDURE p_roleuser_create
/****************************************************************/
  ------------------- 适用于创建角色用户-------------------
  ----创建角色用户
  ----add by dzg: 2015-9-19 
  ----业务流程：先删除原来用户角色，然后插入新的角色
  /*************************************************************/
(
 --------------输入----------------
 p_role_id      IN NUMBER, --角色ID
 p_role_users   IN STRING, --用户列表,使用“,”分割的多个字符串
 
 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 
 ) IS

  v_count_temp NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --角色编码异常
  IF (p_role_id <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_1;
    RETURN;
  END IF;

  --循环插入角色用户
  --先清理原有数据
  delete from adm_role_admin
   where adm_role_admin.role_id = p_role_id;

  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_role_users))) LOOP
    dbms_output.put_line(i.column_value);
  
    IF length(i.column_value) > 0 THEN
    
    insert into adm_role_admin
      (admin_id, role_id)
    values
      (i.column_value, p_role_id);
  
    
    END IF;
  END LOOP;
  

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END p_roleuser_create;
/
 
/ 
prompt 正在建立[PROCEDURE -> p_rr_inbound.sql ]...... 
create or replace procedure p_rr_inbound
/****************************************************************/
   ------------------- 还货单入库 -------------------
   ---- 还货单入库。支持新入库，继续入库，入库完结。
   ----     状态必须是“已审批”，才能进行操作
   ----     新入库：  更新“还货单”收货信息；
   ----               创建“入库单”；
   ----               按照传递的入库对象（箱、盒、包）更新彩票数据，同时也要在入库单明细中记录入库对象；
   ----               根据彩票统计数据，更新“入库单”和“还货单”记录；
   ----               修改“市场管理员”的库存彩票状态；
   ----     继续入库：按照传递的入库对象（箱、盒、包）更新彩票数据，同时也要在入库单明细中记录入库对象；
   ----               根据彩票统计数据，更新“入库单”和“还货单”记录；
   ----               修改“市场管理员”的库存彩票状态；
   ----     入库完结：更新“还货单”和“入库单”时间和状态信息。
   ---- add by 陈震: 2015/9/21
   ---- 涉及的业务表：
   ----     2.1.6.6 还货单                      -- 更新
   ----     2.1.5.10 入库单                     -- 新增、更新
   ----     2.1.5.11 入库单明细                 -- 新增、更新
   ----     2.1.5.3 即开票信息（箱）            -- 更新
   ----     2.1.5.4 即开票信息（盒）            -- 更新
   ----     2.1.5.5 即开票信息（本）            -- 更新
   ---- 业务流程：
   ----     1、校验输入参数。（仓库是否存在；操作类型是否为新、继续、完结；操作人是否合法；）
   ----     2、操作类型为“完结”时，更新“还货单”的“收货时间”和“状态（5-已收货）”，更新“入库单”的“入库时间”和“状态”，结束运行，返回。
   ----     3、获取已经保存的参数。（方案批次的包装信息-bulk方式获取；）
   ----     4、操作类型为“新建”时，更新“还货单”收货信息，条件中要加入“状态”，值必须为“已审批”；创建“入库单”；
   ----     5、按照入库明细，更新“即开票信息”表中各个对象的属性，条件中必须加入“状态”和“所在仓库”条件，并且检查更新记录数量，如果出现无更新记录情况，则报错；
   ----        同时统计彩票统计信息；
   ----     6、更新“入库单”的“实际入库金额合计”和“实际入库张数”,“还货单”的“实际调拨票数”和“实际调拨票数涉及金额”记录；
   ----        更新市场管理员的库存；

   /*************************************************************/
(
 --------------输入----------------
 p_r_no              in char,                -- 还货单编号
 p_warehouse         in char,                -- 收货仓库
 p_oper_type         in number,              -- 操作类型(1-新增，2-继续，3-完结)
 p_oper              in number,              -- 操作人
 p_remark            in varchar2,            -- 备注
 p_array_lotterys    in type_lottery_list,   -- 入库的彩票对象

 ---------出口参数---------
 c_errorcode out number,                     --错误编码
 c_errormesg out string                      --错误原因

 ) is

   v_count                 number(5);                                      -- 求记录数的临时变量
   v_wh_org                char(2);                                        -- 仓库所在部门
   v_plan_tickets          number(18);                                     -- 计划入库票数
   v_plan_amount           number(18);                                     -- 计划入库金额
   v_mm                    number(4);                                      -- 市场管理员
   v_sgr_no                char(10);                                       -- 入库单编号

   v_list_count            number(10);                                     -- 入库明细总数

   type type_detail        is table of wh_goods_receipt_detail%rowtype;
   v_insert_detail         type_detail;                                    -- 插入入库明细的数组
   v_detail_list           type_lottery_detail_list;                       -- 入库明细
   v_stat_list             type_lottery_statistics_list;                   -- 按照方案和批次统计的金额和票数

   v_total_tickets         number(20);                                     -- 当此出库的总票数
   v_total_amount          number(28);                                     -- 当此出库的总金额
   v_plan_publish          number(1);                                      -- 印制厂商编号
   v_temp_tickets          number(20);                                     -- 当此出库的总票数
   v_temp_amount           number(28);                                     -- 当此出库的总金额

   v_err_code              number(10);                                     -- 调用存储过程时，返回值
   v_err_msg               varchar2(4000);                                 -- 调用存储过程时，返回错误信息

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;

   if not f_check_warehouse(p_warehouse) then
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_warehouse) || error_msg.err_common_101; -- 无此仓库
      return;
   end if;

   if not p_oper_type in (1,2,3) then
      c_errorcode := 3;
      c_errormesg := dbtool.format_line(p_oper_type) || error_msg.err_common_105; -- 操作类型参数错误，应该为1，2，3
      return;
   end if;

   -- 继续入库时，判断是否已经完结
   if p_oper_type = 2 then
      select count(*) into v_count from dual where exists(select 1 from wh_goods_receipt where ref_no = p_r_no and status = ework_status.working);
      if v_count = 0 then
         c_errorcode := 4;
         c_errormesg := dbtool.format_line(p_r_no) || error_msg.err_p_tb_inbound_3; -- 在进行继续入库时，输入的调拨单号错误，或者此调拨单对应的入库单，入库已经完结
         return;
      end if;
   end if;
   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* 操作类型为“完结”时，更新“还货单”的“收货时间”和“状态”，更新“入库单”的“入库时间”和“状态”，结束运行，返回。 *************************/
   if p_oper_type = 3 then
      -- 更新“还货单”的“收货时间”和“状态”
      update sale_return_recoder
         set receive_date = sysdate,
             status = eorder_status.received
       where return_no = p_r_no
         and status = eorder_status.receiving
      returning
         status
      into
         v_count;
      if sql%rowcount = 0 then
         rollback;

         begin
            select status into v_count from sale_return_recoder where return_no = p_r_no;
         exception
            when no_data_found then
               c_errorcode := 24;
               c_errormesg := dbtool.format_line(p_r_no) || error_msg.err_p_rr_inbound_24; -- 换货单编号不合法，未查询到此换货单
               return;
         end;

         c_errorcode := 4;
         c_errormesg := dbtool.format_line(p_r_no) || dbtool.format_line(v_count) || error_msg.err_p_rr_inbound_4; -- 还货单入库完结时，还货单状态不合法，期望的还货单状态应该为[收货中]
         return;
      end if;

      -- 更新“入库单”的“入库时间”和“状态”
      update wh_goods_receipt
         set status = ework_status.done,
             receipt_end_time = sysdate,
             send_admin = p_oper,
             remark = p_remark
       where ref_no = p_r_no
         and status = ework_status.working;

      commit;
      return;
   end if;

   /**********************************************************************************************/
   /******************* 检查输入的入库对象以及已经提交的入库对象是否合法 *************************/
   if f_check_import_ticket(p_r_no, 1, p_array_lotterys) then
      c_errorcode := 6;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_103; -- 彩票对象，存在“自包含”的情况
      return;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* 获取已经保存的参数。（方案批次的包装信息-bulk方式获取；） *************************/

   -- 获取印制厂商信息
/*   select plan_flow
     into v_plan_publish
     from inf_publishers
    where publisher_code =
          (select publisher_code from game_plans where plan_code = p_plan);
*/
   -- 仓库所在部门
   select org_code into v_wh_org from wh_info where warehouse_code = p_warehouse;

   /********************************************************************************************************************************************************************/
   /******************* 操作类型为“新建”时，更新“还货单”收货信息，条件中要加入“状态”，“状态”必须为“已发货”；创建“入库单” *************************/
   if p_oper_type = 1 then
      -- 更新“还货单”收货信息
      update sale_return_recoder
         set receive_org = v_wh_org,
             receive_wh = p_warehouse,
             receive_manager = p_oper,
             status = eorder_status.receiving
       where return_no = p_r_no
         and status = eorder_status.audited
      returning
         status, apply_tickets, apply_amount, market_manager_admin
      into
         v_count, v_plan_tickets, v_plan_amount, v_mm;
      if sql%rowcount = 0 then
         rollback;

         begin
            select status into v_count from sale_return_recoder where return_no = p_r_no;
         exception
            when no_data_found then
               c_errorcode := 24;
               c_errormesg := dbtool.format_line(p_r_no) || error_msg.err_p_rr_inbound_24; -- 换货单编号不合法，未查询到此换货单
               return;
         end;

         c_errorcode := 5;
         c_errormesg := dbtool.format_line(p_r_no) || dbtool.format_line(v_count) || error_msg.err_p_rr_inbound_5; -- 还货单入库完结时，还货单状态不合法，期望的换货单状态应该为[已审批]
         return;
      end if;

      -- 创建“入库单”
      insert into wh_goods_receipt
         (sgr_no,                      create_admin,              receipt_amount,
          receipt_tickets,             receipt_type,              ref_no,
          receive_wh,                  RECEIVE_ORG)
      values
         (f_get_wh_goods_receipt_seq,  p_oper,                    v_plan_amount,
          v_plan_tickets,              ereceipt_type.return_back, p_r_no,
          p_warehouse,                 v_wh_org)
      returning
         sgr_no
      into
         v_sgr_no;
   else
      -- 获取入库单编号
      begin
         select sgr_no into v_sgr_no from wh_goods_receipt where ref_no = p_r_no;
      exception
         when no_data_found then
            rollback;
            c_errorcode := 6;
            c_errormesg := dbtool.format_line(p_r_no) || error_msg.err_p_tb_inbound_6; -- 不能获得入库单编号
            return;
      end;

      -- 获取市场管理员编号
      begin
         select market_manager_admin, status
           into v_mm, v_count
           from sale_return_recoder
          where return_no = p_r_no;
      exception
         when no_data_found then
            rollback;
            c_errorcode := 24;
            c_errormesg := dbtool.format_line(p_r_no) || error_msg.err_p_rr_inbound_24; -- 换货单编号不合法，未查询到此换货单
            return;
      end;

      if v_count <> eorder_status.receiving then
         rollback;
         c_errorcode := 15;
         c_errormesg := dbtool.format_line(p_r_no) || dbtool.format_line(v_count) || error_msg.err_p_rr_inbound_15; -- 还货单继续入库时，还货单状态不合法，期望的换货单状态应该为[接收中]
      end if;

   end if;

   /********************************************************************************************************************************************************************/
   /******************* 按照入库明细，更新“即开票信息”表中各个对象的属性；同时统计彩票统计信息 *************************/

   -- 初始化数组
   v_insert_detail := type_detail();
   v_total_tickets := 0;

   -- 根据明细数据，更新“即开票”状态
   p_ticket_perferm(p_array_lotterys, p_oper, eticket_status.in_mm, eticket_status.in_warehouse, v_mm, p_warehouse, v_err_code, v_err_msg);
   if v_err_code <> 0 then
      rollback;
      c_errorcode := 1;
      c_errormesg := error_msg.err_common_104 || v_err_msg; -- 更新“即开票”状态时，出现错误
      return;
   end if;

   -- 统计入库对象的票数据
   p_lottery_detail_stat(p_array_lotterys, v_detail_list, v_stat_list, v_total_tickets, v_total_amount);

   -- 插入出库明细
   for v_list_count in 1 .. v_detail_list.count loop
      v_insert_detail.extend;
      v_insert_detail(v_list_count).sgr_no := v_sgr_no;
      v_insert_detail(v_list_count).ref_no := p_r_no;
      v_insert_detail(v_list_count).sequence_no := f_get_wh_goods_receipt_det_seq;
      v_insert_detail(v_list_count).receipt_type := ereceipt_type.return_back;

      v_insert_detail(v_list_count).valid_number := v_detail_list(v_list_count).valid_number;
      v_insert_detail(v_list_count).plan_code := v_detail_list(v_list_count).plan_code;
      v_insert_detail(v_list_count).batch_no := v_detail_list(v_list_count).batch_no;
      v_insert_detail(v_list_count).amount := v_detail_list(v_list_count).amount;
      v_insert_detail(v_list_count).trunk_no := v_detail_list(v_list_count).trunk_no;
      v_insert_detail(v_list_count).box_no := v_detail_list(v_list_count).box_no;
      v_insert_detail(v_list_count).package_no := v_detail_list(v_list_count).package_no;
      v_insert_detail(v_list_count).tickets := v_detail_list(v_list_count).tickets;
   end loop;

   forall v_list_count in 1 .. v_insert_detail.count
      insert into wh_goods_receipt_detail values v_insert_detail(v_list_count);

   -- 循环统计结果，按照方案批次，更新库管员库存
   for v_loop_i in 1 .. v_stat_list.count loop

      -- 更新仓库管理员库存信息。这里与出货单出库不同，不允许仓库管理员在没有对应方案批次库存的情况下，退此批次的彩票
      update acc_mm_tickets
         set tickets = tickets - v_stat_list(v_loop_i).tickets,
             amount = amount - v_stat_list(v_loop_i).amount
       where market_admin = v_mm
         and plan_code = v_stat_list(v_loop_i).plan_code
         and batch_no = v_stat_list(v_loop_i).batch_no
      returning
         tickets, amount
      into
         v_temp_tickets, v_temp_amount;
      if sql%rowcount = 0 or v_temp_tickets < 0 or v_temp_amount < 0 then
         rollback;
         c_errorcode := 14;
         c_errormesg := dbtool.format_line(p_oper) || dbtool.format_line(v_stat_list(v_loop_i).plan_code) || dbtool.format_line(v_stat_list(v_loop_i).batch_no) || error_msg.err_p_ar_inbound_14; -- 仓库管理员的库存中，没有此方案和批次的库存信息
         return;
      end if;

   end loop;
   /********************************************************************************************************************************************************************/
   /******************* 更新“入库单”的“实际入库金额合计”和“实际入库张数”,“还货单”的“实际调拨票数”和“实际调拨票数涉及金额”记录 *************************/
   update wh_goods_receipt
      set act_receipt_tickets = act_receipt_tickets + v_total_tickets,
          act_receipt_amount = act_receipt_amount + v_total_amount
    where sgr_no = v_sgr_no;

   update sale_return_recoder
      set act_tickets = act_tickets + v_total_tickets,
          act_amount = act_amount + v_total_amount
    where return_no = p_r_no;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
 
/ 
prompt 正在建立[PROCEDURE -> p_set_auth.sql ]...... 
create or replace procedure p_set_auth
/*******************************************************************************/
  ----- add by 陈震 @ 2016-04-19
  -----
  /*******************************************************************************/
(
  p_json       in string,  --登录的终端机mac地址
  c_json       out string, --登录的终端机软件版本号
  c_errorcode  out number, --错误编码
  c_errormesg  out string --错误原因

)
is
  v_mac varchar2(100);
  v_ver varchar2(100);

  v_input_json            json;
  v_out_json              json;

  v_ret_string varchar2(4000);

begin
  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  v_input_json := json(p_json);

  -- 获取入口参数
  v_mac := v_input_json.get('mac').get_string;
  v_ver := v_input_json.get('version').get_string;

  -- 调用函数
  v_ret_string := f_set_auth(v_mac, v_ver);

  -- 构造返回json
  v_out_json := json();

  for tab in (select rownum cnt, column_value from table(dbtool.strsplit(v_ret_string))) loop
    case tab.cnt
      when 1 then
        v_out_json.put('agency_code', tab.column_value);
      when 2 then
        v_out_json.put('term_code', tab.column_value);
      when 3 then
        v_out_json.put('org_code', tab.column_value);
      when 4 then
        v_out_json.put('rc', to_number(tab.column_value));
    end case;
  end loop;

  c_json := v_out_json.to_char;

exception
   when others then
      c_errorcode := 1;
      c_errormesg := error_msg.err_common_1 || sqlerrm;
end;
 
/ 
prompt 正在建立[PROCEDURE -> p_set_cancel.sql ]...... 
CREATE OR REPLACE PROCEDURE p_set_cancel
/*****************************************************************/
   ----------- 主机退票 ---------------
/*****************************************************************/
(
   p_input_json            in varchar2,                           -- 入口参数
   c_out_json              out varchar2,                          -- 出口参数
   c_errorcode             out number,                            -- 业务错误编码
   c_errormesg             out varchar2                           -- 错误信息描述
) IS
  v_input_json            json;
  v_out_json              json;
  temp_json               json;

  v_sale_ticket           his_sellticket%rowtype;
  v_is_center             number(1);                              -- 是否中心退票

  -- 报文内数据对象
  v_cancel_apply_flow     char(24);                               -- 退票请求流水
  v_sale_apply_flow       char(24);                               -- 售票请求流水
  v_cancel_agency_code    inf_agencys.agency_code%type;           -- 退票销售站
  v_cancel_terminal       saler_terminal.terminal_code%type;      -- 退票终端
  v_cancel_teller         inf_tellers.teller_code%type;           -- 退票销售员
  v_org_code              inf_orgs.org_code%type;                 -- 中心退票机构代码
  v_org_type              number(1);
  v_sale_org              inf_agencys.org_code%type;                 --销售站对应的中心机构代码

  -- 退代销费计算
  v_sale_comm             number(28);                             -- 站点销售代销费金额
  v_sale_org_comm         number(28);                             -- 代理商销售代销费金额
  v_sale_amount           number(28);                             -- 销售金额

  -- 加减钱的操作
  v_out_balance           number(28);                             -- 传出的销售站余额
  v_temp_balance          number(28);                             -- 临时金额

  v_is_train              number(1);                              -- 是否培训票
  v_loyalty_code          his_sellticket.loyalty_code%type;       -- 彩民卡号码
  v_ret_num               number(10);                             -- 临时返回值
  v_flownum               number(18);                             -- 终端机交易序号
  v_count                 number(1);                              -- 临时变量，判断存在

BEGIN
  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  v_input_json := json(p_input_json);
  v_out_json := json();


  -- 确认来的报文，是否是退票
  if v_input_json.get('type').get_number not in (2, 4) then
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_set_cancel_1 || v_input_json.get('type').get_number;             -- 报文输入有错，非退票报文。类型为：
    return;
  end if;

  -- 确定退票模式
  if v_input_json.get('type').get_number = 4 then
    v_is_center := 1;
  else
    v_is_center := 0;
  end if;

  -- 是否培训票退票
  v_is_train := v_input_json.get('is_train').get_number;

  -- 获取两个流水号
  v_cancel_apply_flow := v_input_json.get('applyflow_cancel').get_string;
  v_sale_apply_flow := json(v_input_json.get('ticket')).get('applyflow_sell').get_string;

  -- 判断此票是否已经退票
  -- modify by kwx 2016-05-30 按照退票来源（销售站、中心）返回不同的错误编码
  select count(*)
    into v_count
    from dual
   where exists(select 1 from his_cancelticket where APPLYFLOW_SELL = v_sale_apply_flow);
  if v_count = 1 then
    if v_is_center = 0 then
      v_out_json.put('rc', ehost_error.host_cancel_again_err);
      c_out_json := v_out_json.to_char();
    else
      v_out_json.put('rc', ehost_error.oms_result_cancel_again_err);
      c_out_json := v_out_json.to_char();
    end if;
    return;
  end if;

  -- 获取彩民卡编号
  v_loyalty_code := v_input_json.get('loyalty_code').get_number;

  -- 获取原来的售票信息
  begin
    select * into v_sale_ticket from his_sellticket where applyflow_sell = v_sale_apply_flow;
  exception
    when no_data_found then
      c_errorcode := 1;
      c_errormesg := error_msg.err_p_set_cancel_2 || v_sale_apply_flow;                            -- 未找到对应的售票信息。输入的流水号为：
      rollback;
      return;
  end;

  -- 获取之前的金额数据
  v_sale_amount := v_sale_ticket.ticket_amount;
  v_sale_comm := v_sale_ticket.commissionamount;
  v_sale_org_comm := v_sale_ticket.commissionamount_o;

  --modify by kwx 2016-05-30,如果是中心退票,减去中心佣金
  v_sale_org := f_get_agency_org(v_sale_ticket.agency_code);

  -- 根据退票类型，确定数据插入内容
  if v_is_center = 1 then

    if v_is_train = eboolean.yesorenabled then
      rollback;
      c_errorcode := 1;
      c_errormesg := '中心退票不能退培训票';
      return;
    end if;

    v_org_code := v_input_json.get('org_code').get_string;

    -- 判断机构是否有效、存在
    select count(*)
      into v_count
      from dual
     where exists(select 1 from inf_orgs where org_code = v_org_code and org_status = eorg_status.available);
    if v_count = 0 then
      v_out_json.put('rc', ehost_error.host_t_token_expired_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

  --modify by kwx 2016-05-18 增加game_code判断游戏授权

    -- 判断机构是否可以退票
    select count(*)
      into v_count
      from dual
     where exists(select 1 from auth_org where org_code = v_org_code and game_code = v_sale_ticket.game_code and allow_cancel = eboolean.yesorenabled);
    if v_count = 0 then
      -- modify by ChenZhen 2016-05-19 按照退票来源（销售站、中心）返回不同的错误编码
      if v_is_center = 0 then
        v_out_json.put('rc', ehost_error.host_t_teller_unauthen_err);
        c_out_json := v_out_json.to_char();
      else
        v_out_json.put('rc', ehost_error.oms_org_not_auth_cancel_err);
        c_out_json := v_out_json.to_char();
      end if;
      return;
    end if;

    -- 退票金额判断(退票级别)，这里还要判断是否启用此限制
    if v_sale_amount >= to_number(f_get_sys_param(1015)) and f_get_sys_param(1016) = '1' and v_org_code <> '00' then
      rollback;
      v_out_json.put('rc', ehost_error.oms_cancel_money_limit_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- 因为退票，所以给中心加钱
    p_org_fund_change(v_org_code, eflow_type.org_lottery_center_cancel, v_sale_amount, 0, v_cancel_apply_flow, v_temp_balance, v_temp_balance);


    -- 因为退票，所以给中心扣佣金
    if (v_sale_org <> '00' and v_sale_org_comm > 0) then
       p_org_fund_change(v_sale_org, eflow_type.org_lottery_cancel_comm, v_sale_org_comm, 0, v_cancel_apply_flow, v_temp_balance, v_temp_balance);
    end if;

    --因为退票,扣除销售站点的退票佣金
    p_agency_fund_change(v_sale_ticket.agency_code, eflow_type.lottery_cancel_comm, v_sale_comm, 0, v_cancel_apply_flow, v_out_balance, v_temp_balance);

    insert into his_cancelticket
      (applyflow_cancel, canceltime, applyflow_sell, is_center, org_code, cancel_seq)
    values
      (v_cancel_apply_flow, sysdate, v_sale_apply_flow, 1, v_org_code, f_get_his_cancel_seq);

  else
    v_cancel_agency_code := v_input_json.get('agency_code').get_string;
    v_cancel_terminal := v_input_json.get('term_code').get_string;
    v_cancel_teller := v_input_json.get('teller_code').get_number;
    v_org_code := f_get_agency_org(v_cancel_agency_code);
    v_org_type := f_get_org_type(v_org_code);

    -- 通用校验
    v_ret_num := f_set_check_general(v_cancel_terminal, v_cancel_teller, v_cancel_agency_code, v_org_code);
    if v_ret_num <> 0 then
      rollback;
      v_out_json.put('rc', v_ret_num);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- 判断站点 和 部门 的游戏销售授权可用
    if f_set_check_game_auth(v_cancel_agency_code, v_sale_ticket.game_code, 3) = 0 then
      rollback;
      v_out_json.put('rc', ehost_error.host_cancel_disable_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- 校验teller角色，退票员与退票票必须同时是培训模式
    if v_is_train = eboolean.yesorenabled and f_get_teller_role(v_cancel_teller) <> eteller_type.trainner then
      rollback;
      v_out_json.put('rc', ehost_error.host_t_teller_unauthen_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- 判断退票范围
    if f_set_check_pay_level(v_cancel_agency_code, v_sale_ticket.agency_code, v_sale_ticket.game_code) = 0 then
      rollback;
      v_out_json.put('rc', ehost_error.host_claiming_scope_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- 退票金额判断(退票级别)
    if v_sale_amount >= to_number(f_get_sys_param(1014)) then
      rollback;
      v_out_json.put('rc', ehost_error.host_cancel_moneylimit_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- 非培训票，才会有关于资金的操作 add by Chen Zhen @2016-07-06
    if v_is_train <> eboolean.yesorenabled then

      -- 给销售站退钱，同时扣除已经派赴的佣金
      p_agency_fund_change(v_cancel_agency_code, eflow_type.lottery_cancel, v_sale_amount, 0, v_cancel_apply_flow, v_out_balance, v_temp_balance);
      p_agency_fund_change(v_sale_ticket.agency_code, eflow_type.lottery_cancel_comm, v_sale_comm, 0, v_cancel_apply_flow, v_out_balance, v_temp_balance);

      -- 如果之前有代理商的钱，那就要退回来
      if v_sale_org_comm > 0 then
         p_org_fund_change(v_sale_org, eflow_type.org_lottery_cancel_comm, v_sale_org_comm, 0, v_cancel_apply_flow, v_temp_balance, v_temp_balance);
      end if;

      -- 如果是代理商,给代理商增加退票金额
      if (v_org_type = eorg_type.agent) then
           p_org_fund_change(v_org_code, eflow_type.org_lottery_agency_cancel, v_sale_amount, 0, v_cancel_apply_flow, v_temp_balance, v_temp_balance);
        end if;

      -- modify by Chen Zhen @2016-07-06
      -- 序号+1
      update saler_terminal
         set trans_seq = nvl(trans_seq, 0) + 1
       where terminal_code = v_cancel_terminal
      returning
        trans_seq
      into
        v_flownum;

      insert into his_cancelticket
        (applyflow_cancel, canceltime, applyflow_sell, terminal_code, teller_code, agency_code, is_center, org_code, cancel_seq, trans_seq)
      values
        (v_cancel_apply_flow, sysdate, v_sale_apply_flow, v_cancel_terminal, v_cancel_teller, v_cancel_agency_code, 0, v_org_code, f_get_his_cancel_seq, v_flownum);
    end if;
  end if;

  /************************ 构造返回参数 *******************************/
  v_out_json.put('type', v_input_json.get('type').get_number);
  v_out_json.put('rc', 0);

  if v_is_center <> 1 then
    v_out_json.put('account_balance', v_out_balance);
    v_out_json.put('marginal_credit', f_get_agency_credit(v_cancel_agency_code));
    v_out_json.put('flownum', v_flownum);
  end if;

  c_out_json := v_out_json.to_char();

  commit;

exception
  when others then
    c_errorcode := sqlcode;
    c_errormesg := sqlerrm;

    rollback;

    case c_errorcode
      when -20101 then
        c_errorcode := 25;
        c_errormesg := error_msg.err_common_1 || c_errormesg;

      when -20102 then
        c_errorcode := 25;
        c_errormesg := error_msg.err_common_1 || c_errormesg;

      else
        c_errorcode := 1;
        c_errormesg := error_msg.err_common_1 || c_errormesg;
    end case;
END;
 
/ 
prompt 正在建立[PROCEDURE -> p_set_get_accinfo.sql ]...... 
create or replace procedure p_set_get_accinfo
/*******************************************************************************/
  ----- 主机：账户余额查询
  ----- add by Chen Zhen @ 2016-04-20
  -----
/*******************************************************************************/
(
  p_json       in string,  --登录的终端机mac地址
  c_json       out string, --登录的终端机软件版本号
  c_errorcode  out number, --错误编码
  c_errormesg  out string  --错误原因

)
is
  v_teller      inf_tellers.teller_code%type;
  v_term        saler_terminal.terminal_code%type;
  v_agency      inf_agencys.agency_code%type;
  v_org         inf_orgs.org_code%type;

  v_input_json  json;
  v_out_json    json;

  v_balance     acc_agency_account.account_balance%type;
  v_credit      acc_agency_account.credit_limit%type;

  v_ret_num     number(3);

begin
  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  v_input_json := json(p_json);
  v_out_json := json();

  -- 解析参数
  v_teller := v_input_json.get('teller_code').get_number;
  v_term := v_input_json.get('term_code').get_string;
  v_agency := v_input_json.get('agency_code').get_string;
  v_org := f_get_agency_org(v_agency);

  -- 通用校验
  v_ret_num := f_set_check_general(v_term, v_teller, v_agency, v_org);
  if v_ret_num <> 0 then
    v_out_json.put('rc', v_ret_num);
    c_json := v_out_json.to_char;
    return;
  end if;

  -- 检索需要的信息
  begin
    select account_balance, credit_limit
      into v_balance, v_credit
      from acc_agency_account
     where agency_code = v_agency
       and acc_type = eacc_type.main_account;
  exception
    when no_data_found then
      v_balance := 0;
      v_credit := 0;
  end;

  v_out_json.put('account_balance', v_balance);
  v_out_json.put('marginal_credit', v_credit);
  v_out_json.put('rc', 0);

  c_json := v_out_json.to_char;

exception
  when others then
    c_errorcode := 1;
    c_errormesg := error_msg.err_common_1 || sqlerrm;
end;
 
/ 
prompt 正在建立[PROCEDURE -> p_set_get_gameinfo.sql ]...... 
create or replace procedure p_set_get_gameinfo
/*******************************************************************************/
  ----- 主机：游戏信息请求
  ----- add by Chen Zhen @ 2016-04-20
  -----
/*******************************************************************************/
(
  p_json       in string,  --登录的终端机mac地址
  c_json       out string, --登录的终端机软件版本号
  c_errorcode  out number, --错误编码
  c_errormesg  out string  --错误原因

)
is
  v_teller      inf_tellers.teller_code%type;
  v_term        saler_terminal.terminal_code%type;
  v_agency      inf_agencys.agency_code%type;
  v_org         inf_orgs.org_code%type;

  v_input_json  json;
  v_out_json    json;

  v_ret_num     number(3);
  v_ret_str     varchar2(4000);

begin
  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  v_input_json := json(p_json);
  v_out_json := json();

  -- 解析参数
  v_teller := v_input_json.get('teller_code').get_number;
  v_term := v_input_json.get('term_code').get_string;
  v_agency := v_input_json.get('agency_code').get_string;
  v_org := f_get_agency_org(v_agency);

  -- 通用校验
  v_ret_num := f_set_check_general(v_term, v_teller, v_agency, v_org);
  if v_ret_num <> 0 then
    v_out_json.put('rc', v_ret_num);
    c_json := v_out_json.to_char;
    return;
  end if;

  -- 检索需要的信息
  v_ret_str := f_get_agency_info(v_agency);
  if length(v_ret_str) <> 0 then
    for tab in (select rownum cnt, column_value from table(dbtool.strsplit(v_ret_str, '^'))) loop
      case tab.cnt
        when 1 then
          v_out_json.put('contact_address', tab.column_value);
        when 2 then
          v_out_json.put('contact_phone', tab.column_value);
      end case;
    end loop;

  end if;

  -- 获取票面宣传语，系统参数
  v_ret_str := f_get_ticket_memo(0);
  v_out_json.put('ticket_slogan', v_ret_str);

  v_out_json.put('rc', 0);

  c_json := v_out_json.to_char;

exception
  when others then
    c_errorcode := 1;
    c_errormesg := error_msg.err_common_1 || sqlerrm;
end;

 
/ 
prompt 正在建立[PROCEDURE -> p_set_get_lotinfo.sql ]...... 
create or replace procedure p_set_get_lotinfo
/*******************************************************************************/
  ----- 主机：彩票查询请求
  ----- add by Chen Zhen @ 2016-04-20
  -----
/*******************************************************************************/
(
  p_json       in string,  --登录的终端机mac地址
  c_json       out string, --登录的终端机软件版本号
  c_errorcode  out number, --错误编码
  c_errormesg  out string  --错误原因

)
is
  v_teller      inf_tellers.teller_code%type;
  v_term        saler_terminal.terminal_code%type;
  v_agency      inf_agencys.agency_code%type;
  v_org         inf_orgs.org_code%type;

  v_input_json  json;
  v_out_json    json;

  v_ret_num     number(3);

begin
  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  v_input_json := json(p_json);
  v_out_json := json();

  -- 解析参数
  v_teller := v_input_json.get('teller_code').get_number;
  v_term := v_input_json.get('term_code').get_string;
  v_agency := v_input_json.get('agency_code').get_string;
  v_org := f_get_agency_org(v_agency);

  -- 通用校验
  v_ret_num := f_set_check_general(v_term, v_teller, v_agency, v_org);
  if v_ret_num <> 0 then
    v_out_json.put('rc', v_ret_num);
    c_json := v_out_json.to_char;
    return;
  end if;

  v_out_json.put('rc', 0);

  c_json := v_out_json.to_char;

exception
  when others then
    c_errorcode := 1;
    c_errormesg := error_msg.err_common_1 || sqlerrm;
end;
 
/ 
prompt 正在建立[PROCEDURE -> p_set_issue_draw_notice.sql ]...... 
CREATE OR REPLACE PROCEDURE p_set_issue_draw_notice
/*****************************************************************/
  ----------- 生成开奖公告 ---------------
  ---- migrate by Chen Zhen @ 2016-04-18
/*****************************************************************/

(p_game_code    IN NUMBER, --游戏编码
 p_issue_number IN NUMBER, --期次编码
 --p_draw_nocite  OUT CLOB, --开奖公告字符串
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述
 ) IS

  -- 高等奖中奖销售站统计
  v_clob                CLOB; -- confirm XML
  v_draw_info           xmltype;
  v_prize_info          xmltype; --
  v_single_prize        xmltype;
  v_single_prize_agency xmltype;

  v_draw_result        VARCHAR2(100); -- 开奖号码
  v_prize_total_amount VARCHAR2(100); -- 中奖总额

  v_count INTEGER;

  -- 外层循环用
  doc      dbms_xmldom.domdocument;
  buf      VARCHAR2(4000);
  docelem  dbms_xmldom.domelement;
  nodelist dbms_xmldom.domnodelist;
  node     dbms_xmldom.domnode;
  v_size   NUMBER;

  -- 内层循环用
  doc_agency      dbms_xmldom.domdocument;
  buf_agency      VARCHAR2(4000);
  docelem_agency  dbms_xmldom.domelement;
  nodelist_agency dbms_xmldom.domnodelist;
  node_agency     dbms_xmldom.domnode;
  v_size_agency   NUMBER;

  v_prize_level           NUMBER(3); -- 奖级
  v_prize_name            VARCHAR2(100); -- 奖级名称
  v_is_hd_prize           NUMBER(1); -- 是否高等奖
  v_prize_count           NUMBER(16); -- 中奖注数
  v_single_bet_reward     NUMBER(28); -- 单注金额
  v_single_bet_reward_tax NUMBER(28); -- 单注税后中奖金额
  v_tax                   NUMBER(28); -- 单注税金
  v_agency_code           NUMBER(16); -- 销售站编号
  v_win_count             NUMBER(28); -- 注数
  v_sale_amount           NUMBER(28); -- 销售总额

  v_rtv      xmltype;
  v_area     xmltype;
  v_loop_xml xmltype;
  v_agency   xmltype;

  -- 调用获取系统参数存储过程用
  v_param_code    NUMBER(10);
  v_c_param_value VARCHAR2(100);
  v_c_errorcode   NUMBER(10);
  v_c_errormesg   VARCHAR2(1000);

  -- 发SMS
  v_max_single_reward NUMBER(28); -- 单注最高奖金

BEGIN
  -- 初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  --v_area := xmltype('');

  -- 从gameissues中获取XML文件内容
  SELECT winner_confirm_info
    INTO v_clob
    FROM iss_game_issue_xml
   WHERE game_code = p_game_code
     AND issue_number = p_issue_number;
  v_draw_info := xmltype(v_clob);

  /*----------------- 解析XML中的开奖信息，先处理非奖等部分 -----------------*/
  -- 开奖号码
  SELECT xmlcast(xmlquery('/game_draw/draw_result/text()' passing
                          v_draw_info RETURNING content) AS VARCHAR2(100))
    INTO v_draw_result
    FROM dual;

  -- 中奖总额
  SELECT xmlcast(xmlquery('/game_draw/prize_total_amount/text()' passing
                          v_draw_info RETURNING content) AS VARCHAR2(100))
    INTO v_prize_total_amount
    FROM dual;

  -- 先更新gameissue表（开奖号码、销售总额、中奖总额）
  UPDATE iss_game_issue
     SET final_draw_number = v_draw_result
   WHERE game_code = p_game_code
     AND issue_number = p_issue_number;

  /*----------------- 解析XML中的开奖信息，奖级部分先入库 -----------------*/
  -- 获得奖级部分XML文件，
  SELECT xmlquery('/game_draw/prizes' passing v_draw_info RETURNING content)
    INTO v_prize_info
    FROM dual;
  doc := dbms_xmldom.newdomdocument(v_prize_info);

  docelem  := dbms_xmldom.getdocumentelement(doc);
  nodelist := dbms_xmldom.getelementsbytagname(docelem, 'prize');

  v_size := dbms_xmldom.getlength(nodelist);

  -- 获得confirm中的中奖统计信息，入库
  v_max_single_reward := 0;
  FOR v IN 1 .. v_size LOOP
    node := dbms_xmldom.getfirstchild(dbms_xmldom.item(nodelist, v - 1));
    dbms_xmldom.writetobuffer(dbms_xmldom.item(nodelist, v - 1), buf);
    v_single_prize := xmltype(buf);
    SELECT xmlcast(xmlquery('/prize/prize_level/text()' passing
                            v_single_prize RETURNING content) AS NUMBER(3))
      INTO v_prize_level
      FROM dual;
    SELECT xmlcast(xmlquery('/prize/is_high_prize/text()' passing
                            v_single_prize RETURNING content) AS NUMBER(1))
      INTO v_is_hd_prize
      FROM dual;
    SELECT xmlcast(xmlquery('/prize/prize_num/text()' passing
                            v_single_prize RETURNING content) AS NUMBER(16))
      INTO v_prize_count
      FROM dual;
    SELECT xmlcast(xmlquery('/prize/prize_amount/text()' passing
                            v_single_prize RETURNING content) AS NUMBER(28))
      INTO v_single_bet_reward
      FROM dual;
    SELECT xmlcast(xmlquery('/prize/prize_after_tax_amount/text()' passing
                            v_single_prize RETURNING content) AS NUMBER(28))
      INTO v_single_bet_reward_tax
      FROM dual;
    SELECT xmlcast(xmlquery('/prize/prize_tax_amount/text()' passing
                            v_single_prize RETURNING content) AS NUMBER(28))
      INTO v_tax
      FROM dual;

    BEGIN
      SELECT prize_name
        INTO v_prize_name
        FROM iss_game_prize_rule
       WHERE game_code = p_game_code
         AND issue_number = p_issue_number
         AND prize_level = v_prize_level;
    EXCEPTION
      WHEN no_data_found THEN
        v_prize_name := '[UNKNOWN Prize Level] GameCode:' || p_game_code ||
                        ' IssueNumber:' || p_issue_number ||
                        ' Prize Level:' || v_prize_level;
    END;

    -- 考虑重新开奖，做之前，看看数据库里面有没有奖级
    SELECT COUNT(*)
      INTO v_count
      FROM dual
     WHERE EXISTS (SELECT 1
              FROM iss_prize
             WHERE game_code = p_game_code
               AND issue_number = p_issue_number
               AND prize_level = v_prize_level);
    IF v_count = 0 THEN
      INSERT INTO iss_prize
        (game_code,
         issue_number,
         prize_level,
         prize_name,
         is_hd_prize,
         prize_count,
         single_bet_reward,
         single_bet_reward_tax,
         tax)
      VALUES
        (p_game_code,
         p_issue_number,
         v_prize_level,
         v_prize_name,
         v_is_hd_prize,
         v_prize_count,
         v_single_bet_reward,
         v_single_bet_reward_tax,
         v_tax);
    ELSE
      UPDATE iss_prize
         SET prize_name            = v_prize_name,
             is_hd_prize           = v_is_hd_prize,
             prize_count           = v_prize_count,
             single_bet_reward     = v_single_bet_reward,
             single_bet_reward_tax = v_single_bet_reward_tax,
             tax                   = v_tax
       WHERE game_code = p_game_code
         AND issue_number = p_issue_number
         AND prize_level = v_prize_level;
    END IF;

    -- 获取最高单注奖金
    if v_max_single_reward < v_single_bet_reward then
      v_max_single_reward := v_single_bet_reward;
    end if;
  END LOOP;

  /*----------------- 解析XML中的开奖信息，处理高等奖销售站中奖注数 -----------------*/
  SELECT xmlquery('/game_draw/high_prizes' passing v_draw_info RETURNING
                  content)
    INTO v_prize_info
    FROM dual;
  doc := dbms_xmldom.newdomdocument(v_prize_info);

  docelem  := dbms_xmldom.getdocumentelement(doc);
  nodelist := dbms_xmldom.getelementsbytagname(docelem, 'high_prize');
  v_size   := dbms_xmldom.getlength(nodelist);

  FOR v IN 1 .. v_size LOOP
    node := dbms_xmldom.getfirstchild(dbms_xmldom.item(nodelist, v - 1));
    dbms_xmldom.writetobuffer(dbms_xmldom.item(nodelist, v - 1), buf);
    v_single_prize := xmltype(buf);

    -- 获取奖级
    SELECT xmlcast(xmlquery('/high_prize/prize_level/text()' passing
                            v_single_prize RETURNING content) AS NUMBER(3))
      INTO v_prize_level
      FROM dual;

    -- 再对奖级下面的信息进行解析
    SELECT xmlquery('/high_prize/locations' passing v_single_prize
                    RETURNING content)
      INTO v_agency
      FROM dual;

    doc_agency      := dbms_xmldom.newdomdocument(v_agency);
    docelem_agency  := dbms_xmldom.getdocumentelement(doc_agency);
    nodelist_agency := dbms_xmldom.getelementsbytagname(docelem_agency,
                                                        'location');
    v_size_agency   := dbms_xmldom.getlength(nodelist_agency);
    FOR vv IN 1 .. v_size_agency LOOP
      node_agency := dbms_xmldom.getfirstchild(dbms_xmldom.item(nodelist_agency,
                                                                vv - 1));
      dbms_xmldom.writetobuffer(dbms_xmldom.item(nodelist_agency, vv - 1),
                                buf_agency);
      v_single_prize_agency := xmltype(buf_agency);

      -- 销售站
      SELECT xmlcast(xmlquery('/location/agency_code/text()' passing
                              v_single_prize_agency RETURNING content) AS
                     NUMBER(16))
        INTO v_agency_code
        FROM dual;

      -- 中奖注数
      SELECT xmlcast(xmlquery('/location/count/text()' passing
                              v_single_prize_agency RETURNING content) AS
                     NUMBER(28))
        INTO v_win_count
        FROM dual;

      -- 插入临时表，用于后续统计
      INSERT INTO tmp_calc_issue_broadcast
        (agency_code, prize_level, winning_count)
      VALUES
        (v_agency_code, v_prize_level, v_win_count);
    END LOOP;
  END LOOP;

  /*----------------- 按照销售站统计区域中奖信息，生成高等奖中奖分布的XML -----------------*/
  -- 生成 高等奖统计信息
  FOR parea IN (SELECT DISTINCT org_code
                  FROM inf_agencys
                 WHERE agency_code IN
                       (SELECT agency_code FROM tmp_calc_issue_broadcast)) LOOP

    -- 先生成统计此区域下各个奖等的统计值
    SELECT xmlagg(xmlelement("areaLotteryDetail",
                             xmlconcat(xmlelement("prizeLevel", prize_name),
                                       xmlelement("betCount",
                                                  SUM(winning_count)))))
      INTO v_loop_xml
      FROM (SELECT (SELECT prize_name
                      FROM iss_game_prize_rule
                     WHERE game_code = p_game_code
                       AND issue_number = p_issue_number
                       AND prize_level = calc.prize_level) prize_name,
                   winning_count
              FROM tmp_calc_issue_broadcast calc
             WHERE agency_code IN
                   (SELECT agency_code
                      FROM inf_agencys
                     WHERE area_code = parea.org_code))
     GROUP BY prize_name;

    -- 合并上区域的信息
    SELECT xmlelement("Area",
                      xmlconcat(xmlelement("areaCode", org_code),
                                xmlelement("areaName", org_name),
                                v_loop_xml))
      INTO v_loop_xml
      FROM inf_orgs
     WHERE org_code = parea.org_code;

    -- 累加
    SELECT xmlconcat(v_area, v_loop_xml) INTO v_area FROM dual;
  END LOOP;

  -- 套上一个套套，生成“高等奖统计信息”
  SELECT xmlelement("highPrizeAreas", v_area) INTO v_area FROM dual;

  /*----------------- 生成最终的开奖公告XML -----------------*/
  -- 获取各个游戏的开奖公告时间描述
  CASE p_game_code
    WHEN egame.koc6hc THEN
      -- 七龙星
      v_param_code := 1009;
    WHEN egame.kocssc THEN
      -- 天天赢
      v_param_code := 1010;
    WHEN egame.ssc THEN
      -- 时时彩
      v_param_code := 1011;
    WHEN egame.kk3 THEN
      -- 快三
      v_param_code := 1012;
    WHEN egame.s11q5 THEN
      -- 11选5
      v_param_code := 1013;
    ELSE
      v_param_code := 9999;
  END CASE;

  p_sys_get_parameter(p_param_code  => v_param_code,
                      c_param_value => v_c_param_value,
                      c_errorcode   => v_c_errorcode,
                      c_errormesg   => v_c_errormesg);
  IF v_c_errorcode <> 0 THEN
    c_errorcode := 1;
    c_errormesg := '获取系统参数错误，参数序号【' || v_param_code || '】。错误名称：' ||
                   v_c_errormesg;
    ROLLBACK;
    RETURN;
  END IF;

  -- 生成最终的XML
  SELECT xmlelement("announcement",
         /* 开奖公告综述部分 */ xmlattributes(p_game_code AS "gameCode", (SELECT full_name
                                                              FROM inf_games
                                                             WHERE game_code =
                                                                   p_game_code) AS "gameName", p_issue_number AS "periodIssue", nvl(to_char(real_reward_time, 'yyyy-mm-dd'), ' ') AS "dperdLevel", nvl(pay_end_day, 0) AS "overDual", nvl(final_draw_number, ' ') AS "codeResult", nvl(issue_sale_amount, 0) AS "saleAmount",(CASE
           WHEN EXISTS
            (SELECT 1
                   FROM iss_game_pool
                  WHERE game_code =
                        p_game_code) THEN
            1
           ELSE
            0
         END) AS "hasPool", nvl(pool_close_amount, 0) AS "poolScroll", v_c_param_value AS "drawCycle"),
         /* 奖级奖金部分 */(with orderd_level as (select game_code,
                                             issue_number,
                                             prize_level,
                                             disp_order
                                        from iss_game_prize_rule
                                       where game_code = p_game_code
                                         and issue_number =
                                             p_issue_number), now_prize as (select game_code,
                                                                             issue_number,
                                                                             prize_level,
                                                                             prize_name,
                                                                             is_hd_prize,
                                                                             prize_count,
                                                                             single_bet_reward,
                                                                             single_bet_reward_tax,
                                                                             tax
                                                                        from iss_prize
                                                                       where game_code =
                                                                             p_game_code
                                                                         and issue_number =
                                                                             p_issue_number), orderd_prize as (select game_code,
                                                                                                                issue_number,
                                                                                                                prize_level,
                                                                                                                prize_name,
                                                                                                                is_hd_prize,
                                                                                                                prize_count,
                                                                                                                single_bet_reward,
                                                                                                                single_bet_reward_tax,
                                                                                                                tax,
                                                                                                                disp_order
                                                                                                           from orderd_level
                                                                                                           join now_prize
                                                                                                          using (game_code, issue_number, prize_level)
                                                                                                          order by disp_order)
           select xmlagg(xmlelement("lotteryDetail",
                                    xmlconcat(xmlelement("prizeLevel",
                                                         prize_name),
                                              xmlelement("betCount",
                                                         prize_count),
                                              xmlelement("awardAmount",
                                                         single_bet_reward),
                                              xmlelement("amountAftertax",
                                                         single_bet_reward_tax),
                                              xmlelement("amountTotal",
                                                         prize_count *
                                                         single_bet_reward))))
             from orderd_prize),
           /* 高等奖区域分布部分 */
           v_area), issue_sale_amount
             INTO v_rtv, v_sale_amount
             FROM iss_game_issue tab
            WHERE game_code = p_game_code
              AND issue_number = p_issue_number;


  -- 更新数据库
  UPDATE iss_game_issue_xml
     SET winning_brodcast = v_rtv.getclobval()
   WHERE game_code = p_game_code
     AND issue_number = p_issue_number;

  -- 更新 ISS_GAME_POLICY_FUND
  SELECT COUNT(*)
    INTO v_count
    FROM dual
   WHERE EXISTS (SELECT 1
            FROM iss_game_policy_fund
           WHERE game_code = p_game_code
             AND issue_number = p_issue_number);
  IF v_count = 1 THEN
    DELETE FROM iss_game_policy_fund
     WHERE game_code = p_game_code
       AND issue_number = p_issue_number;
  END IF;
  INSERT INTO iss_game_policy_fund
    (game_code,
     issue_number,
     sale_amount,
     theory_win_amount,
     fund_amount,
     comm_amount,
     adj_fund)
    SELECT p_game_code,
           p_issue_number,
           v_sale_amount,
           v_sale_amount / 1000 * theory_rate,
           v_sale_amount / 1000 * fund_rate,
           v_sale_amount / 1000 *
           (1000 - fund_rate - adj_rate - theory_rate),
           v_sale_amount / 1000 * adj_rate
      FROM gp_policy
     WHERE (game_code, his_policy_code) =
           (SELECT game_code, his_policy_code
              FROM iss_current_param
             WHERE game_code = p_game_code
               AND issue_number = p_issue_number);

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_set_issue_error_info.sql ]...... 
CREATE OR REPLACE PROCEDURE p_set_issue_error_info
/*****************************************************************/
  ----------- 设置开奖过程中错误信息（主机调用） ---------------
  ----- modify by dzg 2014-06-21 修改不区分具体错误代码，只要错误代码就是1
  ----- 所以也不用传入错误代码 和 错误原因
  /*****************************************************************/
(
  p_game_code            IN NUMBER, --游戏编码
  p_issue_number         IN NUMBER, --期次编码
  c_errorcode            OUT NUMBER, --业务错误编码
  c_errormesg            OUT STRING --错误信息描述
) IS
BEGIN

  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  --更新期次开奖过程错误编码和描述
  UPDATE iss_game_issue g
     SET g.rewarding_error_code = 1
   WHERE g.game_code = p_game_code
     AND g.issue_number = p_issue_number;

  IF SQL%NOTFOUND THEN
    c_errorcode := 1;
    c_errormesg := '更新期次开奖过程错误编码和描述失败'||sqlerrm;
    RETURN;
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);
END;
/
 
/ 
prompt 正在建立[PROCEDURE -> p_set_issue_pool_get.sql ]...... 
CREATE OR REPLACE PROCEDURE p_set_issue_pool_get
/*****************************************************************/
   ----------- 获得游戏的奖池名称和余额（主机调用） ---------------
   /*****************************************************************/
(
   p_game_code   IN NUMBER, --游戏编码
   c_errorcode   OUT NUMBER, --业务错误编码
   c_errormesg   OUT STRING, --错误信息描述
   c_pool_name   OUT STRING, --奖池名称
   c_pool_amount OUT NUMBER --奖池金额
) IS

BEGIN
   --初始化数据
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   SELECT pool_name,
          nvl(pool_amount_after, 0)
     INTO c_pool_name,
          c_pool_amount
     FROM iss_game_pool
    WHERE game_code = p_game_code
      AND pool_code = 0;

EXCEPTION
   WHEN no_data_found THEN
      c_errorcode := 1;
      c_errormesg := '没有找到游戏[' || p_game_code || ']的奖池.';
   WHEN OTHERS THEN
      dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);
END;
/
 
/ 
prompt 正在建立[PROCEDURE -> p_set_issue_pool_modify.sql ]...... 
CREATE OR REPLACE PROCEDURE p_set_issue_pool_modify
/*****************************************************************/
   ----------- 设置游戏期次奖池金额（主机调用） ---------------
   ----------- 主机调用，变更方式——>期次变更,变更类型——>期次滚动
   /*****************************************************************/
(
 --------------输入----------------
 p_game_code    IN NUMBER, --游戏编码
 p_issue_number IN NUMBER, --期次编码
 p_pool_amount  IN NUMBER, --滚入的奖池金额
 p_adj_amount   IN NUMBER, --期次奖金抹零
 ---------出口参数---------
 c_errorcode OUT NUMBER,   --业务错误编码
 c_errormesg OUT STRING    --错误信息描述
 ) IS
   v_issue_sale_amount NUMBER(18); -- 期次销售金额

   v_adj_rate  NUMBER(10,6); -- 调节基金比率
   v_gov_rate  NUMBER(10,6); -- 公益金比率
   v_comm_rate NUMBER(10,6); -- 发行费比率

   v_adj_amount_before    NUMBER(28); -- 调整前金额（调节基金）
   v_adj_amount_after     NUMBER(28); -- 调整后金额（调节基金）
   v_pool_amount_before   NUMBER(28); -- 调整前金额（奖池）
   v_pool_amount_after    NUMBER(28); -- 调整后金额（奖池）

BEGIN
   --初始化数据
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   -- 检查输入参数
   IF p_pool_amount IS NULL THEN
      c_errorcode := 1;
      --c_errormesg := '输入参数【滚入的奖池金额】为空值，程序无法计算';
      c_errormesg := error_msg.MSG0064;
      RETURN;
   END IF;
   IF p_adj_amount IS NULL THEN
      c_errorcode := 1;
      --c_errormesg := '输入参数【期次奖金抹零】为空值，程序无法计算';
      c_errormesg := error_msg.MSG0065;
      RETURN;
   END IF;

   -- 获取各种比率
   BEGIN
      SELECT 1000 - theory_rate - fund_rate - adj_rate, fund_rate, adj_rate
        INTO v_comm_rate, v_gov_rate, v_adj_rate
        FROM gp_policy
       WHERE game_code = p_game_code
         AND his_policy_code =
             (SELECT his_policy_code
                FROM iss_current_param
               WHERE game_code = p_game_code
                 AND issue_number = p_issue_number);
   EXCEPTION
      WHEN no_data_found THEN
         c_errorcode := 1;
         --c_errormesg := '无法获取政策参数，程序无法计算。游戏：【' || p_game_code || '】期次：【' ||
         --              p_issue_number || '】';
         c_errormesg := error_msg.MSG0066 ||p_game_code||'-'||p_issue_number;
         RETURN;
   END;
   v_comm_rate := v_comm_rate / 1000;
   v_gov_rate  := v_gov_rate / 1000;
   v_adj_rate  := v_adj_rate / 1000;

   -- 获得期次销售金额
   SELECT issue_sale_amount
     INTO v_issue_sale_amount
     FROM iss_game_issue
    WHERE game_code = p_game_code
      AND issue_number = p_issue_number;
   IF v_issue_sale_amount IS NULL THEN
      c_errorcode := 1;
      --c_errormesg := '期次销售金额为空值，程序无法计算';
      c_errormesg := error_msg.MSG0067;
      RETURN;
   END IF;
   IF v_issue_sale_amount <= 0
      AND p_pool_amount > 0 THEN
      c_errorcode := 1;
      --c_errormesg := '期次销售金额为0，但是输入的奖池金额大于0，出现逻辑错误，程序无法计算';
      c_errormesg := error_msg.MSG0068;
      RETURN;
   END IF;

   -- 设置期初奖池金额
   UPDATE iss_game_issue
      SET pool_start_amount = (select pool_amount_after from iss_game_pool where game_code = p_game_code and pool_code = 0)
    WHERE game_code = p_game_code
      AND issue_number = p_issue_number;

   /*** 入调节基金、发行费、公益金流水 ***/
   INSERT INTO gov_commision -- 发行费
      (his_code,
       game_code,
       issue_number,
       comm_change_type,
       adj_amount,
       adj_amount_before,
       adj_amount_after,
       adj_time,
       adj_reason)
   VALUES
      (f_get_game_his_code_seq,
       p_game_code,
       p_issue_number,
       ecomm_change_type.in_from_issue_reward,
       v_issue_sale_amount * v_comm_rate,
       nvl((SELECT adj_amount_after
        FROM gov_commision
       WHERE game_code = p_game_code
         AND his_code = (SELECT MAX(his_code)
                           FROM gov_commision
                          WHERE game_code = p_game_code)),0),
       nvl((SELECT adj_amount_after
        FROM gov_commision
       WHERE game_code = p_game_code
         AND his_code = (SELECT MAX(his_code)
                           FROM gov_commision
                          WHERE game_code = p_game_code)),0) + v_issue_sale_amount * v_comm_rate,
       SYSDATE,
       '');

   INSERT INTO commonweal_fund -- 公益金
      (his_code,
       game_code,
       issue_number,
       cwfund_change_type,
       adj_amount,
       adj_amount_before,
       adj_amount_after,
       adj_time,
       adj_reason)
   VALUES
      (f_get_game_his_code_seq,
       p_game_code,
       p_issue_number,
       ecwfund_change_type.in_from_issue_reward,
       v_issue_sale_amount * v_gov_rate,
       nvl((SELECT adj_amount_after
        FROM commonweal_fund
       WHERE game_code = p_game_code
         AND his_code = (SELECT MAX(his_code)
                           FROM commonweal_fund
                          WHERE game_code = p_game_code)),0),
       nvl((SELECT adj_amount_after
        FROM commonweal_fund
       WHERE game_code = p_game_code
         AND his_code = (SELECT MAX(his_code)
                           FROM commonweal_fund
                          WHERE game_code = p_game_code)),0) + v_issue_sale_amount * v_gov_rate,
       SYSDATE,
       '');

   -- 更新调节基金当前信息，同时获得调整之前和之后的余额
   UPDATE adj_game_current
      SET pool_amount_before = pool_amount_after,
          pool_amount_after = pool_amount_after + v_issue_sale_amount * v_adj_rate
    WHERE game_code = p_game_code
          returning pool_amount_before, pool_amount_after
               into v_adj_amount_before, v_adj_amount_after;

   INSERT INTO adj_game_his -- 调节基金(期次开奖滚入)
      (his_code,
       game_code,
       issue_number,
       adj_change_type,
       adj_amount,
       adj_amount_before,
       adj_amount_after,
       adj_time)
   VALUES
      (f_get_game_his_code_seq,
       p_game_code,
       p_issue_number,
       eadj_change_type.in_issue_reward,
       v_issue_sale_amount * v_adj_rate,
       v_adj_amount_before,
       v_adj_amount_after,
       SYSDATE);

   -- 期次奖金抹零进入调节基金
   IF p_adj_amount > 0 THEN
      -- 更新调节基金当前信息，同时获得调整之前和之后的余额
      UPDATE adj_game_current
         SET pool_amount_before = pool_amount_after,
             pool_amount_after = pool_amount_after + p_adj_amount
       WHERE game_code = p_game_code
             returning pool_amount_before, pool_amount_after
                  into v_adj_amount_before, v_adj_amount_after;

      INSERT INTO adj_game_his -- 调节基金(期次奖金抹零滚入)
         (his_code,
          game_code,
          issue_number,
          adj_change_type,
          adj_amount,
          adj_amount_before,
          adj_amount_after,
          adj_time)
      VALUES
         (f_get_game_his_code_seq,
          p_game_code,
          p_issue_number,
          eadj_change_type.in_issue_trunc_winning,
          p_adj_amount,
          v_adj_amount_before,
          v_adj_amount_after,
          SYSDATE);

   END IF;

   -- 更新奖池余额，同时获得调整之前和之后的奖池余额
   UPDATE iss_game_pool
      SET pool_amount_before = pool_amount_after,
          pool_amount_after = pool_amount_after + p_pool_amount,
          adj_time = SYSDATE
    WHERE game_code = p_game_code
      AND pool_code = 0
returning pool_amount_before, pool_amount_after
     into v_pool_amount_before, v_pool_amount_after;

   -- 如果调整之后，奖池为负值，那么需要调节基金不足
   /**为负数（指的是，主机在经过计算以后，奖池已经被掏空），
      需要使用调节基金的余额补齐，如果调节基金不够，再用发行费补齐，发行费不够，设置调节基金余额为负值，发行费为0；
      然后再设置当前奖池金额为0。*/
   IF v_pool_amount_after < 0 THEN
      --调节基金够补充完毕奖池亏空
      -- 更新调节基金当前信息，同时获得调整之前和之后的余额
      UPDATE adj_game_current
         SET pool_amount_before = pool_amount_after,
             pool_amount_after = pool_amount_after + v_pool_amount_after         -- 奖池的负数，通过调节基金补足
       WHERE game_code = p_game_code
             returning pool_amount_before, pool_amount_after
                  into v_adj_amount_before, v_adj_amount_after;

      INSERT INTO adj_game_his -- 调节基金(填补奖池)
         (his_code,
          game_code,
          issue_number,
          adj_change_type,
          adj_amount,
          adj_amount_before,
          adj_amount_after,
          adj_time,
          adj_reason)
      VALUES
         (f_get_game_his_code_seq,
          p_game_code,
          p_issue_number,
          eadj_change_type.out_issue_pool,
          v_pool_amount_after,
          v_adj_amount_before,
          v_adj_amount_after,
          SYSDATE,
          --'期次奖池不足，调节基金补充'
          error_msg.MSG0069
          );

      INSERT INTO iss_game_pool_his -- 奖池（期次开奖滚入）
         (his_code,
          game_code,
          issue_number,
          pool_code,
          change_amount,
          pool_amount_before,
          pool_amount_after,
          adj_time,
          pool_adj_type,
          adj_reason,
          pool_flow)
      VALUES
         (f_get_game_his_code_seq,
          p_game_code,
          p_issue_number,
          0,
          0 - v_pool_amount_after,        -- 变化金额就是那个负数，这里写绝对值
          v_pool_amount_after,            -- 变化前奖池余额是负数，变化后，应该是0
          0,
          SYSDATE,
          epool_change_type.in_issue_pool_auto,
          --'期次奖池不足，调节基金补充'
          error_msg.MSG0069,
          NULL);

      -- 更新奖池余额，设置期末余额为0（这是因为奖池期末余额不能为【负值】）
      UPDATE iss_game_pool
         SET pool_amount_after = 0
       WHERE game_code = p_game_code
         AND pool_code = 0;
      v_pool_amount_after := 0;

   end if;

   INSERT INTO iss_game_pool_his -- 奖池（期次开奖滚入）
      (his_code,
       game_code,
       issue_number,
       pool_code,
       change_amount,
       pool_amount_before,
       pool_amount_after,
       adj_time,
       pool_adj_type,
       adj_reason,
       pool_flow)
   VALUES
      (f_get_game_his_code_seq,
       p_game_code,
       p_issue_number,
       0,
       p_pool_amount,
       v_pool_amount_before,
       v_pool_amount_after,
       SYSDATE,
       epool_change_type.in_issue_reward,
       --'期次开奖滚入',
       error_msg.MSG0070,
       NULL);

   -- 更新期次统计数据
   UPDATE iss_game_issue
      SET pool_close_amount = v_pool_amount_after
    WHERE game_code = p_game_code
      AND issue_number = p_issue_number;

   COMMIT;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);
END;
 
/ 
prompt 正在建立[PROCEDURE -> p_set_issue_risk_stat.sql ]...... 
CREATE OR REPLACE PROCEDURE p_set_issue_risk_stat
/******************************************************************************/
------------------- 适用于设置游戏期次风险控制相关统计数值 -------------------
/******************************************************************************/
(
 --------------输入----------------
 p_game_code                  IN NUMBER, --游戏编码
 p_issue_number               IN NUMBER, --期次编码
 p_risk_amount                IN NUMBER, --总共被拒绝金额
 p_risk_ticket_count          IN NUMBER, --总共被拒绝票数
 
 ---------出口参数---------
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述
 ) IS
BEGIN

  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  --更新期次票数统计
  UPDATE iss_game_issue
     SET ISSUE_RICK_AMOUNT = p_risk_amount,
         ISSUE_RICK_TICKETS = p_risk_ticket_count
   WHERE game_code = p_game_code
     AND issue_number = p_issue_number;

  IF SQL%NOTFOUND THEN
    c_errorcode := 1;
    c_errormesg := '期次风险控制相关统计数值失败';
    RETURN;
  END IF;
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);
  
END;
 
/ 
prompt 正在建立[PROCEDURE -> p_set_issue_status.sql ]...... 
CREATE OR REPLACE PROCEDURE p_set_issue_status
/****************************************************************/
   ------------------适用于:主机更新期次状态 -------------------
   /*************************************************************/
(
 --------------输入----------------
 p_game_code    IN NUMBER, --游戏编码
 p_issue_number IN NUMBER, --期次编码
 p_status       IN NUMBER, --期次状态
 p_hosttime     IN DATE, --主机时间
 ---------出口参数---------
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述
 ) IS

   v_temp_count     NUMBER := 0; --临时数据用于验证初始化
   v_draw_limit_day NUMBER(10); --兑奖期限（设置值）

   v_pool_amount_before NUMBER(18); --奖池调整前的金额
   v_pool_amount_after  NUMBER(18); --奖池调整后的金额
   v_adj_amount_before  NUMBER(18); --调节基金调整前的金额
   v_adj_amount_after   NUMBER(18); --调节基金调整后的金额

   v_now_date           date;
   v_rest_day           number(10);

BEGIN
   --初始化数据
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   ------------校验有效性
   -----状态有效性校验
   IF p_status < 0
      OR p_status > egame_issue_status.issuecompleted THEN
      c_errorcode := 1;
      c_errormesg := '输入的期次状态无效！';
      RETURN;
   END IF;

   -----期次数据有效性校验
   SELECT COUNT(iss_game_issue.issue_number)
     INTO v_temp_count
     FROM iss_game_issue
    WHERE iss_game_issue.game_code = p_game_code
      AND iss_game_issue.issue_number = p_issue_number
      AND iss_game_issue.issue_status < egame_issue_status.issuecompleted;

   IF v_temp_count <= 0 THEN
      c_errorcode := 1;
      c_errormesg := '期次不存在或期次已完结！';
      RETURN;
   END IF;

   IF v_temp_count > 1 THEN
      c_errorcode := 1;
      c_errormesg := '系统中存在重复的期次！';
      RETURN;
   END IF;

   --------------- 更新开奖状态
   CASE p_status
   --期次开始，更新实际开始时间
      WHEN egame_issue_status.issueopen THEN
         UPDATE iss_game_issue g
            SET g.real_start_time = p_hosttime, g.issue_status = p_status
          WHERE g.game_code = p_game_code
            AND g.issue_number = p_issue_number;

   --更新期次实际结束时间
      WHEN egame_issue_status.issueclosed THEN
         UPDATE iss_game_issue g
            SET g.real_close_time = p_hosttime, g.issue_status = p_status
          WHERE g.game_code = p_game_code
            AND g.issue_number = p_issue_number;

   --更新期次实际开奖时间,输入开奖号码时间
   -- 2014.7.7 陈震 增加计算弃奖时间
      WHEN egame_issue_status.enteringdrawcodes THEN
         -- 根据期次，获取政策参数中的“兑奖期”
         BEGIN
            SELECT draw_limit_day
              INTO v_draw_limit_day
              FROM gp_policy
             WHERE his_policy_code = (SELECT DISTINCT his_policy_code
                                        FROM iss_current_param
                                       WHERE game_code = p_game_code
                                         AND issue_number = p_issue_number)
               AND game_code = p_game_code;
         EXCEPTION
            WHEN no_data_found THEN
               c_errorcode := 1;
               c_errormesg := '无法获取“政策参数”中的“兑奖期”！';
               ROLLBACK;
               RETURN;
         END;
         IF v_draw_limit_day IS NULL THEN
            c_errorcode := 1;
            c_errormesg := '无法获取“政策参数”中的“兑奖期”！';
            ROLLBACK;
            RETURN;
         END IF;

         -- 根据当前日期，检查是否有节假日顺延设置
         -- 1、确定当前日期是否在节假日设置中；
         -- 2、循环数日期，确定一个计数器。遇到节假日时，跳过不累计，直到累计数达到兑奖期的数字
         select trunc(SYSDATE,'dd') into v_now_date from dual;
         v_rest_day := v_draw_limit_day;
         for tab_delay in (select h_day_start, h_day_end
                             from sys_calendar
                            where H_DAY_CODE >=
                                  (select min(H_DAY_CODE)
                                     from sys_calendar
                                    where h_day_start > v_now_date)) loop
            v_rest_day := v_rest_day - (tab_delay.h_day_start - 1 - v_now_date);
            if v_rest_day = 0 then
               v_now_date := tab_delay.h_day_start - 1;
               exit;
            end if;

            if v_rest_day < 0 then
               v_now_date := tab_delay.h_day_start - 1 + v_rest_day;
               exit;
            end if;

            v_now_date := tab_delay.h_day_end;
         end loop;
         if v_rest_day > 0 then
            v_now_date := v_now_date + v_rest_day;
         end if;

         -- 计算弃奖日期，写入 "兑奖截止日期（天） PAY_END_DAY"
         UPDATE iss_game_issue g
            SET g.real_reward_time = p_hosttime,
                g.issue_status     = p_status,
                g.pay_end_day      = to_number(to_char(v_now_date, 'yyyymmdd'))
          WHERE g.game_code = p_game_code
            AND g.issue_number = p_issue_number;

   --期次封存，初始化数据
      WHEN egame_issue_status.issuesealed THEN
         UPDATE iss_game_issue g
            SET g.draw_state           = edraw_state.edraw_ready,
                g.issue_status         = p_status,
                g.first_draw_number    = NULL,
                g.first_draw_user_id   = NULL,
                g.code_input_methold   = NULL,
                g.second_draw_number   = NULL,
                g.second_draw_user_id  = NULL,
                g.final_draw_number    = NULL,
                g.final_draw_user_id   = NULL,
                g.rewarding_error_code = NULL,
                g.rewarding_error_mesg = NULL,
                g.pool_start_amount   = NULL
          WHERE g.game_code = p_game_code
            AND g.issue_number = p_issue_number;

   --期次状态:本地算奖完成; 开奖状态:派奖检索完成
      WHEN egame_issue_status.localprizecalculationdone THEN
         UPDATE iss_game_issue g
            SET g.draw_state = edraw_state.edraw_prize_collected, g.issue_status = p_status
          WHERE g.game_code = p_game_code
            AND g.issue_number = p_issue_number;

   --期次状态:奖级调整完毕; 开奖状态:中奖统计完成
      WHEN egame_issue_status.prizeleveladjustmentdone THEN
         UPDATE iss_game_issue g
            SET g.draw_state = edraw_state.edraw_prize_stated, g.issue_status = p_status
          WHERE g.game_code = p_game_code
            AND g.issue_number = p_issue_number;

   --期次状态:期结完成; 开奖状态:开奖完成
   --modify by dzg 2014-6-19 修订增加更新期结时间
   --modify by 陈震 2014-07-08 手工修改奖池生效
      WHEN egame_issue_status.issuecompleted THEN
         UPDATE iss_game_issue g
            SET g.draw_state = edraw_state.edraw_draw_finish, g.issue_end_time = p_hosttime, g.issue_status = p_status
          WHERE g.game_code = p_game_code
            AND g.issue_number = p_issue_number;

         -- 针对未生效的奖池调整
         FOR tab_pool_adj IN (SELECT pool_flow, pool_adj_type, adj_amount, adj_desc
                                FROM iss_game_pool_adj
                               WHERE game_code = p_game_code
                                 AND pool_code = 0
                                 AND is_adj = eboolean.noordisabled) LOOP
            -- 更新奖池余额
            -- 更新奖池余额，同时获得调整之前和之后的奖池余额
            UPDATE iss_game_pool
               SET pool_amount_before = pool_amount_after, pool_amount_after = pool_amount_after + tab_pool_adj.adj_amount, adj_time = SYSDATE
             WHERE game_code = p_game_code
               AND pool_code = 0
            RETURNING pool_amount_before, pool_amount_after INTO v_pool_amount_before, v_pool_amount_after;

            -- 加奖池流水
            INSERT INTO iss_game_pool_his
               (his_code,
                game_code,
                issue_number,
                pool_code,
                change_amount,
                pool_amount_before,
                pool_amount_after,
                adj_time,
                pool_adj_type,
                adj_reason,
                pool_flow)
            VALUES
               (f_get_game_his_code_seq,
                p_game_code,
                p_issue_number,
                0,
                tab_pool_adj.adj_amount,
                v_pool_amount_before,
                v_pool_amount_after,
                SYSDATE,
                tab_pool_adj.pool_adj_type,
                tab_pool_adj.adj_desc,
                tab_pool_adj.pool_flow);

            /*----------- 针对变更类型做后续的事情 -----------------*/
            CASE tab_pool_adj.pool_adj_type
               WHEN epool_change_type.in_issue_pool_manual THEN
                  -- 类型为 4、调节基金手动拨入
                  -- 修改余额，同时获得调整之前余额和调整之后余额
                  UPDATE adj_game_current
                     SET pool_amount_before = pool_amount_after, pool_amount_after = pool_amount_after + tab_pool_adj.adj_amount
                   WHERE game_code = p_game_code
                  RETURNING pool_amount_before, pool_amount_after INTO v_adj_amount_before, v_adj_amount_after;

                  -- 插入调整历史
                  INSERT INTO adj_game_his
                     (his_code, game_code, issue_number, adj_change_type, adj_amount, adj_amount_before, adj_amount_after, adj_time)
                  VALUES
                     (f_get_game_his_code_seq,
                      p_game_code,
                      p_issue_number,
                      eadj_change_type.out_issue_pool_manual,
                      tab_pool_adj.adj_amount,
                      v_adj_amount_before,
                      v_adj_amount_after,
                      SYSDATE)
                  RETURNING adj_amount_after INTO v_adj_amount_after;

               WHEN epool_change_type.in_commission THEN
                  -- 类型为 5、发行费手动拨入
                  INSERT INTO gov_commision
                     (his_code, game_code, issue_number, comm_change_type, adj_amount, adj_amount_before, adj_amount_after, adj_time, adj_reason)
                  VALUES
                     (f_get_game_his_code_seq,
                      p_game_code,
                      p_issue_number,
                      ecomm_change_type.out_to_pool,
                      tab_pool_adj.adj_amount,
                      nvl((SELECT adj_amount_after
                            FROM gov_commision
                           WHERE game_code = p_game_code
                             AND his_code = (SELECT MAX(his_code)
                                               FROM gov_commision
                                              WHERE game_code = p_game_code)),
                          0),
                      nvl((SELECT adj_amount_after
                            FROM gov_commision
                           WHERE game_code = p_game_code
                             AND his_code = (SELECT MAX(his_code)
                                               FROM gov_commision
                                              WHERE game_code = p_game_code)),
                          0) - tab_pool_adj.adj_amount,
                      SYSDATE,
                      tab_pool_adj.adj_desc);
            END CASE;
         END LOOP;

   --默认状态
      ELSE
         UPDATE iss_game_issue g
            SET g.issue_status = p_status
          WHERE g.game_code = p_game_code
            AND g.issue_number = p_issue_number;
   END CASE;

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);
END;
 
/ 
prompt 正在建立[PROCEDURE -> p_set_issue_ticket_stat.sql ]...... 
CREATE OR REPLACE PROCEDURE p_set_issue_ticket_stat
/****************************************************************/
------------------- 适用于设置游戏期次统计数值 -------------------
/*************************************************************/
(
 --------------输入----------------
 p_game_code                 IN NUMBER, --游戏编码
 p_issue_number              IN NUMBER, --期次编码
 p_total_sale_amount         IN NUMBER, --总共销售金额
 p_total_sale_ticket_count   IN NUMBER, --总共销售票数
 p_total_sale_bet_count      IN NUMBER, --总共销售注数
 p_total_cancel_amount       IN NUMBER, --总共取消金额
 p_total_cancel_ticket_count IN NUMBER, --总共取消票数
 p_total_cancel_bet_count    IN NUMBER, --总共取消注数

 ---------出口参数---------
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述
 ) IS
   -- 同步数据
   v_param VARCHAR2(200);
   v_ip    VARCHAR2(200);
   v_user  VARCHAR2(200);
   v_pass  VARCHAR2(200);
   v_url   VARCHAR2(200);
   v_c_errorcode NUMBER(10);
   v_c_errormesg VARCHAR2(1000);

BEGIN

  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  --更新期次票数统计
  UPDATE iss_game_issue
     SET issue_sale_amount = p_total_sale_amount,
         issue_sale_tickets = p_total_sale_ticket_count,
         issue_sale_bets = p_total_sale_bet_count,
         issue_cancel_amount = p_total_cancel_amount,
         issue_cancel_tickets = p_total_cancel_ticket_count,
         issue_cancel_bets = p_total_cancel_bet_count
   WHERE game_code = p_game_code
     AND issue_number = p_issue_number;

  IF SQL%NOTFOUND THEN
    c_errorcode := 1;
    c_errormesg := '更新期次票数统计失败';
    RETURN;
  END IF;
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

END;
/
 
/ 
prompt 正在建立[PROCEDURE -> p_set_issue_winning_stat.sql ]...... 
CREATE OR REPLACE PROCEDURE p_set_issue_winning_stat
(
  p_game_code                  IN NUMBER,   --游戏id
  p_issue_number               IN NUMBER,   --期次编码
  p_total_winning_ticket_count IN NUMBER,   --总共中奖票数
  p_total_winning_amount       IN NUMBER,   --总共中奖金额
  p_total_winning_bet_count    IN NUMBER,   --总共中奖注数
  p_big_winning_ticket_count   IN NUMBER,   --大奖中奖票数
  p_big_winning_amount         IN NUMBER,   --大奖中奖金额

  ---------出口参数---------
  c_errorcode                  OUT NUMBER,  --业务错误编码
  c_errormesg                  OUT STRING   --错误信息描述
) IS
BEGIN

  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  --更新期次中奖统计信息
  UPDATE iss_game_issue g
     SET g.winning_amount = p_total_winning_amount,
         g.winning_bets = p_total_winning_bet_count,
         g.winning_tickets = p_total_winning_ticket_count,
         g.winning_amount_big = p_big_winning_amount,
         g.winning_tickets_big = p_big_winning_ticket_count
   WHERE g.game_code = p_game_code
     AND g.issue_number = p_issue_number;

  IF SQL%NOTFOUND THEN
    c_errorcode := 1;
    c_errormesg := '更新期次中奖统计信息失败'||sqlerrm;
    RETURN;
  END IF;

  commit;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);
  
END;
/
 
/ 
prompt 正在建立[PROCEDURE -> p_set_login.sql ]...... 
create or replace procedure p_set_login
/*******************************************************************************/
  ----- add by Chen Zhen @ 2016-04-20
  -----
  /*******************************************************************************/
(
  p_json       in string,  --入口json
  c_json       out string, --出口json
  c_errorcode  out number, --错误编码
  c_errormesg  out string  --错误原因

)
is
  v_teller      inf_tellers.teller_code%type;
  v_term        saler_terminal.terminal_code%type;
  v_last_teller inf_tellers.teller_code%type;
  v_agency_code inf_agencys.agency_code%type;

  v_password    varchar2(32);


  v_input_json  json;
  v_out_json    json;

  v_ret_string  varchar2(4000);
  v_ret_num     number(3);

begin
  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  v_input_json := json(p_json);

  -- 构造返回json
  v_out_json := json();

  -- 调用函数
  v_teller := v_input_json.get('teller_code').get_number;
  v_term := v_input_json.get('term_code').get_string;
  v_agency_code := v_input_json.get('agency_code').get_string;
  v_password := v_input_json.get('password').get_string;


  v_ret_num := f_get_teller_static(v_teller);
  
  -- modify by kwx 2016-06-15 判断销售员不存在
  if v_ret_num = 13 then
    v_out_json.put('rc', ehost_error.host_t_teller_unexist);
    c_json := v_out_json.to_char;
    return;
  -- 判断销售员是否可用	
  elsif v_ret_num = eteller_status.disabled  or  v_ret_num = eteller_status.deleted  then
    v_out_json.put('rc', ehost_error.host_t_teller_disable_err);
    c_json := v_out_json.to_char;
    return;
  end if;

  v_ret_string := f_set_login(p_teller => v_teller,
                              p_term => v_term,
                              p_agency => v_agency_code,
                              p_pass => v_password);


  for tab in (select rownum cnt, column_value from table(dbtool.strsplit(v_ret_string))) loop
    v_ret_string := trim(tab.column_value);
    case tab.cnt
      when 1 then
        v_out_json.put('teller_type', to_number(nullif(v_ret_string, 'null')));
      when 2 then
        v_out_json.put('flownum', to_number(nullif(v_ret_string, 'null')));
      when 3 then
        v_out_json.put('account_balance', to_number(nullif(v_ret_string, 'null')));
      when 4 then
        v_out_json.put('marginal_credit', to_number(nullif(v_ret_string, 'null')));
      when 5 then
        v_out_json.put('rc', to_number(tab.column_value));
    end case;
  end loop;

  c_json := v_out_json.to_char;

  -- 找到原来终端机上原来的销售员
  select latest_login_teller_code
    into v_last_teller
    from saler_terminal
   where terminal_code = v_term;

  -- 强制更新销售员状态为未登录
  if v_last_teller is not null then
    update inf_tellers
       set latest_terminal_code = null,
           latest_sign_off_time = sysdate,
           is_online = eboolean.noordisabled
     where teller_code = v_teller;
  end if;

  -- 更新登录信息
  update saler_terminal
     set is_logging = eboolean.yesorenabled,
         latest_login_teller_code = v_teller
   where terminal_code = v_term;

  update inf_tellers
     set latest_terminal_code = v_term,
         latest_sign_on_time = sysdate,
         is_online = eboolean.yesorenabled
   where teller_code = v_teller;

  commit;
exception
  when others then
    rollback;
    c_errorcode := 1;
    c_errormesg := error_msg.err_common_1 || sqlerrm;
end;
 
/ 
prompt 正在建立[PROCEDURE -> p_set_logoff.sql ]...... 
create or replace procedure p_set_logoff
/*******************************************************************************/
  ----- add by chen zhen @ 2016-04-20
  -----
  /*******************************************************************************/
(
  p_json       in string,  -- 入口json
  c_json       out string, -- 出口json
  c_errorcode  out number, -- 错误编码
  c_errormesg  out string  -- 错误原因

)
is
  v_teller      inf_tellers.teller_code%type;
  v_term        saler_terminal.terminal_code%type;

  v_input_json  json;
  v_out_json    json;

begin
  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  v_input_json := json(p_json);
  v_out_json := json();

  -- 获取入口参数
  v_teller := v_input_json.get('teller_code').get_number;
  v_term := v_input_json.get('term_code').get_string;

  -- 更新teller状态，
  update inf_tellers
     set latest_terminal_code = null,
         latest_sign_off_time = sysdate,
         is_online = eboolean.noordisabled
   where teller_code = v_teller;

  -- 更新term状态
  update saler_terminal
     set latest_login_teller_code = null,
         is_logging = eboolean.noordisabled
   where terminal_code = v_term;

  commit;

  v_out_json.put('rc', 0);

  c_json := v_out_json.to_char;

exception
  when others then
    rollback;
    c_errorcode := 1;
    c_errormesg := error_msg.err_common_1 || sqlerrm;
end;
 
/ 
prompt 正在建立[PROCEDURE -> p_set_modify_pass.sql ]...... 
create or replace procedure p_set_modify_pass
/*******************************************************************************/
  ----- 主机：修改密码
  ----- add by Chen Zhen @ 2016-04-20
  -----
/*******************************************************************************/
(
  p_json       in string,  --登录的终端机mac地址
  c_json       out string, --登录的终端机软件版本号
  c_errorcode  out number, --错误编码
  c_errormesg  out string  --错误原因

)
is
  v_teller      inf_tellers.teller_code%type;
  v_term        saler_terminal.terminal_code%type;
  v_agency      inf_agencys.agency_code%type;
  v_org         inf_orgs.org_code%type;

  v_input_json  json;
  v_out_json    json;

  v_new_pass    inf_tellers.password%type;
  v_old_pass    inf_tellers.password%type;

  v_ret_num     number(3);

begin
  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  v_input_json := json(p_json);
  v_out_json := json();

  -- 解析参数
  v_teller := v_input_json.get('teller_code').get_number;
  v_term := v_input_json.get('term_code').get_string;
  v_agency := v_input_json.get('agency_code').get_string;
  v_org := f_get_agency_org(v_agency);
  v_new_pass := v_input_json.get('new_password').get_string;
  v_old_pass := v_input_json.get('old_password').get_string;

  -- 通用校验
  v_ret_num := f_set_check_general(v_term, v_teller, v_agency, v_org);
  if v_ret_num <> 0 then
    v_out_json.put('rc', v_ret_num);
    c_json := v_out_json.to_char;
    return;
  end if;

  -- 修改密码
  update INF_TELLERS
     set PASSWORD = lower(v_new_pass)
   where teller_code = v_teller
     and password = v_old_pass;
  if sql%rowcount = 0 then
    v_out_json.put('rc', 5);
    c_json := v_out_json.to_char;
    return;
  end if;

  v_out_json.put('rc', 0);
  c_json := v_out_json.to_char;

exception
  when others then
    c_errorcode := 1;
    c_errormesg := error_msg.err_common_1 || sqlerrm;
end;
 
/ 
prompt 正在建立[PROCEDURE -> p_set_pay.sql ]...... 
CREATE OR REPLACE PROCEDURE p_set_pay
/*****************************************************************/
   ----------- 主机兑奖 ---------------
/*****************************************************************/
(
  p_input_json   in varchar2,                                         -- 入口参数

  c_out_json    out varchar2,                                         -- 出口参数
  c_errorcode   out number,                                           -- 业务错误编码
  c_errormesg   out varchar2                                          -- 错误信息描述
) IS
  v_input_json                json;
  v_out_json                  json;
  temp_json                   json;

  v_is_center                 number(1);                              -- 是否中心兑奖

  -- 报文内数据对象
  v_pay_apply_flow            char(24);                               -- 兑奖请求流水
  v_sale_apply_flow           char(24);                               -- 售票请求流水
  v_pay_agency_code           inf_agencys.agency_code%type;           -- 兑奖销售站
  v_sale_agency_code          inf_agencys.agency_code%type;           -- 售票销售站
  v_pay_terminal              saler_terminal.terminal_code%type;      -- 兑奖终端
  v_pay_teller                inf_tellers.teller_code%type;           -- 兑奖销售员
  v_org_code                  inf_orgs.org_code%type;                 -- 中心兑奖机构代码或者兑奖销售站对应的机构代码
  v_org_type                  number(1);

  -- 兑奖代销费计算
  v_pay_comm                  number(28);                             -- 站点兑奖代销费金额
  v_pay_comm_r                number(28);                             -- 站点兑奖代销费比例
  v_pay_org_comm              number(28);                             -- 代理商兑奖代销费金额
  v_pay_org_comm_r            number(28);                             -- 代理商兑奖代销费比例
  v_pay_amount                number(28);                             -- 中奖金额
  v_game_code                 number(3);                              -- 游戏ID


  -- 加减钱的操作
  v_out_balance               number(28);                             -- 传出的销售站余额
  v_temp_balance              number(28);                             -- 临时金额

  v_is_train                  number(1);                              -- 是否培训票
  v_loyalty_code              his_sellticket.loyalty_code%type;       -- 彩民卡号码
  v_ret_num                   number(10);                             -- 临时返回值
  v_flownum                   number(18);                             -- 终端机交易序号
  v_count                     number(1);                              -- 临时变量，判断存在

BEGIN
  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  v_input_json := json(p_input_json);
  v_out_json := json();
  v_flownum := 0;

  -- 确认来的报文，是否是兑奖
  if v_input_json.get('type').get_number not in (3, 5) then
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_set_pay_1 || v_input_json.get('type').get_number;             -- 报文输入有错，非兑奖报文。类型为：
    return;
  end if;

  -- 是否培训票兑奖
  v_is_train := v_input_json.get('is_train').get_number;

  -- 确定兑奖模式
  if v_input_json.get('type').get_number = 5 then
     v_is_center := 1;
  else
     v_is_center := 0;
  end if;

  -- 获取两个流水号
  v_pay_apply_flow := v_input_json.get('applyflow_pay').get_string;
  v_sale_apply_flow := json(v_input_json.get('ticket')).get('applyflow_sell').get_string;

  -- 判断此票是否已经兑奖
  select count(*)
    into v_count
    from dual
   where exists(select 1 from his_payticket where APPLYFLOW_SELL = v_sale_apply_flow);
  if v_count = 1 then
    v_out_json.put('rc', ehost_error.host_pay_paid_err);
    c_out_json := v_out_json.to_char();
    return;
  end if;

  -- 获取彩民卡编号
  v_loyalty_code := v_input_json.get('loyalty_code').get_number;

  -- 获取票对象
  temp_json := json();
  temp_json := json(v_input_json.get('ticket'));

  -- 获取中奖金额、游戏，准备计算代销费
  v_pay_amount := temp_json.get('winningamounttax').get_number;
  v_game_code := temp_json.get('game_code').get_number;

  -- 根据兑奖类型，获取兑奖销售站、终端、销售员、兑奖金额
  if v_is_center = 1 then

    if v_is_train = eboolean.yesorenabled then
      c_errorcode := 1;
      c_errormesg := '中心兑奖不能兑培训票';
      return;
    end if;

    v_org_code := v_input_json.get('org_code').get_string;

    -- 判断机构是否有效、存在
    select count(*)
      into v_count
      from dual
     where exists(select 1 from inf_orgs where org_code = v_org_code and org_status = eorg_status.available);
    if v_count = 0 then
      v_out_json.put('rc', ehost_error.host_t_token_expired_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- 判断机构是否可以兑奖
    select count(*)
      into v_count
      from dual
     where exists(select 1 from auth_org where org_code = v_org_code and game_code = v_game_code and allow_pay = eboolean.yesorenabled);
    if v_count = 0 then
      -- modify by ChenZhen 2016-05-19 按照兑奖来源（销售站、中心）返回不同的错误编码
      if v_is_center = 0 then
        v_out_json.put('rc', ehost_error.host_pay_disable_err);
        c_out_json := v_out_json.to_char();
      else
        v_out_json.put('rc', ehost_error.oms_org_not_auth_pay_err);
        c_out_json := v_out_json.to_char();
      end if;

      return;
    end if;

    -- 兑奖金额判断(兑奖级别)，这里还要判断是否启用此限制
    if v_pay_amount >= to_number(f_get_sys_param(1018)) and f_get_sys_param(7) = '1' and v_org_code <> '00' then
      v_out_json.put('rc', ehost_error.oms_pay_money_limit_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;


    -- 给机构加钱
    p_org_fund_change(v_org_code, eflow_type.org_lottery_center_pay, v_pay_amount, 0, v_pay_apply_flow, v_temp_balance, v_temp_balance);

    -- 获取组织机构的代销费比例
    v_pay_org_comm_r := f_get_org_game_comm(v_org_code, v_game_code, ecomm_type.pay);

    v_pay_org_comm := v_pay_amount * v_pay_org_comm_r / 1000;

    v_org_type := f_get_org_type(v_org_code);

    -- 通过系统参数，确定是否给组织机构代销费
    if (v_pay_org_comm >0 ) and ((v_org_type <> '00' and v_org_type = eorg_type.company and f_get_sys_param(16) = '1') or (v_org_type = eorg_type.agent)) then
      p_org_fund_change(v_org_code, eflow_type.org_lottery_center_pay_comm, v_pay_org_comm, 0, v_pay_apply_flow, v_temp_balance, v_temp_balance);
    end if;

  else
    v_pay_agency_code := v_input_json.get('agency_code').get_string;
    v_pay_terminal := v_input_json.get('term_code').get_string;
    v_pay_teller := v_input_json.get('teller_code').get_number;
    v_org_code := f_get_agency_org(v_pay_agency_code);

    -- 通用校验
    v_ret_num := f_set_check_general(v_pay_terminal, v_pay_teller, v_pay_agency_code, v_org_code);
    if v_ret_num <> 0 then
      v_out_json.put('rc', v_ret_num);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- 判断站点 和 部门 的游戏销售授权可用
    if f_set_check_game_auth(v_pay_agency_code, v_game_code, 2) = 0 then
      v_out_json.put('rc', ehost_error.host_pay_disable_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- 校验teller角色，兑奖员与兑奖票必须同时是培训模式
    if v_is_train = eboolean.yesorenabled and f_get_teller_role(v_pay_teller) <> eteller_type.trainner then
      v_out_json.put('rc', ehost_error.host_t_teller_unauthen_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- 判断兑奖范围
    v_sale_agency_code := v_input_json.get('sale_agency').get_string;
    if f_set_check_pay_level(v_pay_agency_code, v_sale_agency_code, v_game_code) = 0 then
      v_out_json.put('rc', ehost_error.host_claiming_scope_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- 兑奖金额判断(兑奖级别)
    if v_pay_amount >= to_number(f_get_sys_param(1017)) then
      v_out_json.put('rc', ehost_error.host_teller_pay_limit_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    if v_is_train <> eboolean.yesorenabled then

      -- 给销售站加钱
      p_agency_fund_change(v_pay_agency_code, eflow_type.lottery_pay, v_pay_amount, 0, v_pay_apply_flow, v_out_balance, v_temp_balance);

      -- 获取销售站的代销费比例
      v_pay_comm_r := f_get_agency_game_comm(v_pay_agency_code, v_game_code, ecomm_type.pay);

      v_pay_comm := v_pay_amount * v_pay_comm_r / 1000;

      -- 给销售站加代销费
      if v_pay_comm > 0 then
        p_agency_fund_change(v_pay_agency_code, eflow_type.lottery_pay_comm, v_pay_comm, 0, v_pay_apply_flow, v_out_balance, v_temp_balance);
      end if;

      -- 获取兑奖销售站对应的组织机构类型
      v_org_type := f_get_org_type(v_org_code);

      -- 获取组织机构的代销费比例
      v_pay_org_comm_r := f_get_org_game_comm(v_org_code, v_game_code, ecomm_type.pay);
      v_pay_org_comm := v_pay_amount * v_pay_org_comm_r / 1000;

      --给代销商加钱
      if v_org_type = eorg_type.agent then
        p_org_fund_change(v_org_code, eflow_type.org_lottery_agency_pay, v_pay_amount, 0, v_pay_apply_flow, v_temp_balance, v_temp_balance);
      end if;


      -- 通过系统参数，确定是否给组织机构代销费
      if ((v_org_code <> '00' and v_org_type = eorg_type.company and f_get_sys_param(16) = '1') or (v_org_type = eorg_type.agent)) then
        if v_pay_org_comm > 0 then
          p_org_fund_change(v_org_code, eflow_type.org_lottery_agency_pay_comm, v_pay_org_comm, 0, v_pay_apply_flow, v_temp_balance, v_temp_balance);
        end if;
      end if;
    end if;
  end if;

  -- 不是培训票，才入库
  if v_is_train <> eboolean.yesorenabled then
    -- modify by Chen Zhen @2016-07-06
    -- 序号+1
    if v_is_center <> 1 then
      update saler_terminal
         set trans_seq = nvl(trans_seq, 0) + 1
       where terminal_code = v_pay_terminal
      returning
        trans_seq
      into
        v_flownum;
    end if;

    insert into his_payticket
      (applyflow_pay,                                              applyflow_sell,
       game_code,                                                  issue_number,
       terminal_code,                                              teller_code,                           agency_code,
       is_center,                                                  org_code,
       paytime,                                                    winningamounttax,
       winningamount,                                              taxamount,
       paycommissionrate,                                          commissionamount,
       paycommissionrate_o,                                        commissionamount_o,
       winningcount,                                               hd_winning,
       hd_count,                                                   ld_winning,
       ld_count,                                                   loyalty_code,
       is_big_prize,                                               pay_seq,
       trans_seq)
    values
      (v_pay_apply_flow,                                           v_sale_apply_flow,
       v_game_code,                                                temp_json.get('issue_number').get_number,         -- 期次为当前期
       v_pay_terminal,                                             v_pay_teller,                          v_pay_agency_code,
       v_is_center,                                                v_org_code,
       sysdate,                                                    v_pay_amount,
       temp_json.get('winningamount').get_number,                  temp_json.get('taxamount').get_number,
       nvl(v_pay_comm_r, 0),                                       nvl(v_pay_comm, 0),
       nvl(v_pay_org_comm_r, 0),                                   nvl(v_pay_org_comm, 0),
       temp_json.get('winningcount').get_number,                   temp_json.get('hd_winning').get_number,
       temp_json.get('hd_count').get_number,                       temp_json.get('ld_winning').get_number,
       temp_json.get('ld_count').get_number,                       v_loyalty_code,
       temp_json.get('is_big_prize').get_number,                   f_get_his_pay_seq,
       v_flownum);
  end if;

  /************************ 构造返回参数 *******************************/
  v_out_json.put('type', v_input_json.get('type').get_number);
  v_out_json.put('rc', 0);

  if v_is_center <> 1 then
    v_out_json.put('account_balance', v_out_balance);
    v_out_json.put('marginal_credit', f_get_agency_credit(v_pay_agency_code));
    v_out_json.put('flownum', v_flownum);
  end if;

  c_out_json := v_out_json.to_char();

  commit;

exception
  when others then
    c_errorcode := sqlcode;
    c_errormesg := sqlerrm;

    rollback;

    case c_errorcode
      when -20101 then
        c_errorcode := 25;
        c_errormesg := error_msg.err_common_1 || c_errormesg;

      when -20102 then
        c_errorcode := 25;
        c_errormesg := error_msg.err_common_1 || c_errormesg;

      else
        c_errorcode := 1;
        c_errormesg := error_msg.err_common_1 || c_errormesg;
    end case;
END; 
/ 
prompt 正在建立[PROCEDURE -> p_set_sale.sql ]...... 
create or replace procedure p_set_sale
/*****************************************************************/
   ----------- 主机售票 ---------------
/*****************************************************************/
(
   p_input_json   in varchar2,                           --入口参数

   c_out_json    out varchar2,                           --出口参数
   c_errorcode   out number,                             --业务错误编码
   c_errormesg   out varchar2                            --错误信息描述
) is

  v_loop_i                number(5);

  v_input_json            json;
  v_out_json              json;

  -- 票面信息json临时对象
  temp_json               json;
  temp_json_list          json_list;

  -- 入库对象
  v_apply_flow            char(24);                     -- 请求流水

  -- 代销费计算
  v_agency_code           inf_agencys.agency_code%type;
  v_org_code              inf_orgs.org_code%type;
  v_teller_code           inf_tellers.teller_code%type;
  v_term_code             saler_terminal.terminal_code%type;

  v_org_type              number(1);
  v_game_code             number(3);
  v_sale_comm_r           number(28);                   -- 站点销售代销费比例
  v_sale_org_comm_r       number(28);                   -- 代理商销售代销费比例
  v_sale_comm             number(28);                   -- 站点销售代销费金额
  v_sale_org_comm         number(28);                   -- 代理商销售代销费金额
  v_sale_amount           number(28);                   -- 销售金额

  -- 加减钱的操作
  v_out_balance           number(28);                   -- 传出的销售站余额
  v_temp_balance          number(28);                   -- 临时金额

  v_iss_count             number(8);                    -- 多期票期数
  v_ret_num               number(3);                    -- 临时返回值
  v_is_train              number(1);                    -- 是否培训票
  v_flownum               number(18);                   -- 终端机交易序号

begin
  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  v_input_json := json(p_input_json);
  v_out_json := json();

  -- 确认来的报文，是否是售票
  if v_input_json.get('type').get_number <> 1 then
     c_errorcode := 1;
     c_errormesg := error_msg.err_p_set_sale_1 || v_input_json.get('type').get_number;             -- 报文输入有错，非售票报文。类型为：
     return;
  end if;

  temp_json := json(v_input_json.get('ticket'));
  temp_json_list := json_list(temp_json.get('bet_detail'));

  -- 获取票面信息，防止重复计算
  v_apply_flow := v_input_json.get('applyflow_sell').get_string;
  v_iss_count := temp_json.get('issue_count').get_number;

  -- 计算代销费
  v_agency_code := v_input_json.get('agency_code').get_string;
  v_teller_code := v_input_json.get('teller_code').get_number;
  v_term_code := v_input_json.get('term_code').get_string;
  v_org_code := f_get_agency_org(v_agency_code);

  -- 通用校验
  v_ret_num := f_set_check_general(v_term_code, v_teller_code, v_agency_code, v_org_code);
  if v_ret_num <> 0 then
    v_out_json.put('rc', v_ret_num);
    c_out_json := v_out_json.to_char();
    return;
  end if;

  v_game_code := temp_json.get('game_code').get_number;

  -- 判断站点 和 部门 的游戏销售授权可用
  if f_set_check_game_auth(v_agency_code, v_game_code, 1) = 0 then
    v_out_json.put('rc', ehost_error.host_sell_disable_err);
    c_out_json := v_out_json.to_char();
    return;
  end if;

  -- 校验teller角色
  v_is_train := eboolean.noordisabled;
  if f_get_teller_role(v_teller_code) = eteller_type.trainner then
    v_is_train := eboolean.yesorenabled;
  end if;

  -- 培训票，流水号置0
  v_flownum := 0;

  if v_is_train = eboolean.noordisabled then
    -- 计算销售佣金
    v_sale_amount := temp_json.get('ticket_amount').get_number;
    v_sale_comm_r := f_get_agency_game_comm(v_agency_code, v_game_code, ecomm_type.sale);
    v_sale_org_comm_r := f_get_org_game_comm(v_org_code, v_game_code, ecomm_type.sale);
    v_sale_comm := v_sale_amount * v_sale_comm_r / 1000;
    v_sale_org_comm := v_sale_amount * v_sale_org_comm_r / 1000;

    -- 调整终端机交易序号  modify by Chen Zhen @2016-07-06
    update saler_terminal
       set trans_seq = nvl(trans_seq, 0) + 1
     where terminal_code = v_term_code
    returning
      trans_seq
    into
      v_flownum;

    -- 插入数据
    insert into his_sellticket
      (applyflow_sell,                                             saletime,
       terminal_code,                                              teller_code,
       agency_code,
       -- 票面信息
       game_code,                                                  issue_number,
       start_issue,                                                end_issue,
       issue_count,                                                ticket_amount,
       ticket_bet_count,
       salecommissionrate,                                         commissionamount,
       salecommissionrate_o,                                       commissionamount_o,
       bet_methold,                                                bet_line,
       loyalty_code,
       -- 系统信息
       result_code,                                                sell_seq,
       trans_seq)
    values
      (v_apply_flow,                                               sysdate,
       v_term_code,                                                v_teller_code,
       v_agency_code,
       -- 票面信息
       v_game_code,                                                temp_json.get('issue_number').get_number,
       temp_json.get('start_issue').get_number,                    temp_json.get('end_issue').get_number,
       v_iss_count,                                                v_sale_amount,
       temp_json.get('ticket_bet_count').get_number,
       v_sale_comm_r,                                              v_sale_comm,
       v_sale_org_comm_r,                                          v_sale_org_comm,
       temp_json.get('bet_methold').get_number,                    temp_json.get('bet_line').get_number,
       v_input_json.get('loyalty_code').get_string,
       -- 系统信息
       0,                                                          f_get_his_sell_seq,
       v_flownum);

    -- 插入明细数据
    for v_loop_i in 1..temp_json_list.count loop
      temp_json := json(temp_json_list.get(v_loop_i));

      insert into his_sellticket_detail
        (applyflow_sell,                                          saletime,
         line_no,                                                 bet_type,
         subtype,                                                 oper_type,
         section,                                                 bet_amount,
         bet_count,                                               line_amount)
      values
        (v_apply_flow,                                            sysdate,
         temp_json.get('line_no').get_number,                     temp_json.get('bet_type').get_number,
         temp_json.get('subtype').get_number,                     temp_json.get('oper_type').get_number,
         temp_json.get('section').get_string,                     temp_json.get('bet_times').get_number,
         temp_json.get('bet_count').get_number,                   temp_json.get('bet_amount').get_number);

    end loop;

    -- 是否多期票
    if v_iss_count > 1 then
      insert into his_sellticket_multi_issue (applyflow_sell) values (v_apply_flow);
    end if;

    -- 给销售站扣钱
    p_agency_fund_change(v_agency_code, eflow_type.lottery_sale, v_sale_amount, 0, v_apply_flow, v_out_balance, v_temp_balance);

    -- 给销售站加佣金
    p_agency_fund_change(v_agency_code, eflow_type.lottery_sale_comm, v_sale_comm, 0, v_apply_flow, v_out_balance, v_temp_balance);

    --给代销商扣钱
    v_org_type := f_get_org_type(v_org_code);
    if v_org_type = eorg_type.agent then
      p_org_fund_change(v_org_code, eflow_type.org_lottery_agency_sale, v_sale_amount, 0, v_apply_flow, v_temp_balance, v_temp_balance);
    end if;

    -- 按照区域类型（是否代销商）和系统参数决定是否给机构佣金
    if v_sale_org_comm > 0 then
      if (v_org_code <> '00' and v_org_type = eorg_type.company and f_get_sys_param(16) = '1') or (v_org_type = eorg_type.agent) then
        p_org_fund_change(v_org_code, eflow_type.org_lottery_agency_sale_comm, v_sale_org_comm, 0, v_apply_flow, v_temp_balance, v_temp_balance);
      end if;
    end if;
  end if;

  /************************ 构造返回参数 *******************************/
  v_out_json := json();

  v_out_json.put('type', 1);
  v_out_json.put('rc', 0);
  v_out_json.put('applyflow_sell', v_apply_flow);
  v_out_json.put('agency_code', v_agency_code);
  v_out_json.put('is_train', v_is_train);
  v_out_json.put('account_balance', v_out_balance);
  v_out_json.put('marginal_credit', f_get_agency_credit(v_agency_code));
  v_out_json.put('flownum', v_flownum);
  v_out_json.put('commission_amount',v_sale_comm);
  c_out_json := v_out_json.to_char();

  commit;

exception
   when others then
      c_errorcode := sqlcode;
      c_errormesg := sqlerrm;

      rollback;

      case c_errorcode
         when -20101 then
            c_errorcode := ehost_error.host_sell_lack_amount_err;
            c_errormesg := error_msg.err_common_1 || c_errormesg;

         when -20102 then
            c_errorcode := ehost_error.host_sell_lack_amount_err;
            c_errormesg := error_msg.err_common_1 || c_errormesg;

         else
            c_errorcode := 1;
            c_errormesg := error_msg.err_common_1 || c_errormesg;
      end case;
end; 
/ 
prompt 正在建立[PROCEDURE -> p_set_tds_issue_draw_notice.sql ]...... 
create or replace procedure p_set_tds_issue_draw_notice
/*****************************************************************/
   ----------- 生成 TDS json开奖公告 ---------------
   ----- created by chen zhen @ 2016-04-18
/*****************************************************************/

(
   p_game_code    in number, --游戏编码
   p_issue_number in number, --期次编码

   c_errorcode out number,   --业务错误编码
   c_errormesg out string    --错误信息描述
) is

   all_json_obj json;
   second_json  json;
   draw_json    json;
   draw_json_list json_list;

   v_rank1_json json_list;
   v_rank2_json json_list;
   v_rank3_json json_list;
   v_rank4_json json_list;
   v_rank5_json json_list;
   v_rank_json  json_list;

   -- 临时的json和json list变量
   tempobj json;
   tempobj_list json_list;

   v_draw_code            varchar2(200);
   v_winning_amount       number(28);
   v_sale_amount          number(28);
   v_issue_number         iss_game_issue.issue_number%type;

   -- 最近100期的开奖号码
   type draw_record is record(issue_number number(28), final_draw_number varchar2(200));
   type draw_collect is table of draw_record;
   v_array_draw_code draw_collect;

   v_loop_i number(2);

   -- 开奖结果，每个小球对应的数字
   draw_number number(3);

   -- 临时clob对象，用于入库
   temp_clob clob;

begin
  -- 初始化变量
  c_errorcode := 0;
  all_json_obj := json();
  second_json := json();
  v_array_draw_code := draw_collect();
  draw_json := json();
  draw_json_list := json_list();

  -- 临时的json和json list变量
  tempobj := json();
  tempobj_list := json_list();

  v_rank1_json := json_list();
  v_rank2_json := json_list();
  v_rank3_json := json_list();
  v_rank4_json := json_list();
  v_rank5_json := json_list();
  v_rank_json := json_list();

  -- TDS动画，只做了11选5的，其他的没有做
  if p_game_code <> 12 then
    return;
  end if;

  -- 11选5，所有要先开五个坑
  for v_loop_i in 1 .. 11 loop
     v_rank1_json.append(0);
     v_rank2_json.append(0);
     v_rank3_json.append(0);
     v_rank4_json.append(0);
     v_rank5_json.append(0);
     v_rank_json.append(0);
  end loop;

  all_json_obj.put('cmd', 8193);
  all_json_obj.put('game', p_game_code);
  all_json_obj.put('issue', p_issue_number);

  -- 开奖号码
  begin
     select issue_number,final_draw_number, issue_sale_amount, winning_amount
       into v_issue_number, v_draw_code, v_sale_amount, v_winning_amount
       from iss_game_issue
      where game_code=p_game_code
        and issue_number=p_issue_number;
  exception
     when no_data_found then
     c_errorcode := 1;
     c_errormesg := error_msg.err_p_set_json_issue_draw_n_1;               -- 游戏期次不存在，或者未开奖
     return;
  end;

  if v_winning_amount is null then
     c_errorcode := 10;
     c_errormesg := error_msg.err_p_set_json_issue_draw_n_1;               -- 游戏期次不存在，或者未开奖
     return;
  end if;

  all_json_obj.put('draw_code', v_draw_code);

  -- 销售和中奖金额
  second_json.put('sale_amount', v_sale_amount);
  second_json.put('win_amount', v_winning_amount);

  -- 奖级奖金表
  for tab in (select prize_level, prize_name, prize_count*single_bet_reward amount, prize_count from iss_prize where game_code=p_game_code and issue_number=v_issue_number order by prize_level) loop
     tempobj := json();
     tempobj.put('name', tab.prize_name);
     tempobj.put('amount', tab.amount);
     tempobj.put('bets', tab.prize_count);
     tempobj_list.append(tempobj.to_json_value);
  end loop;

  second_json.put('prize_level',tempobj_list.to_json_value);
  all_json_obj.put('win_info', second_json.to_json_value);

  -- 中大奖的销售站
  -- modify by ChenZhen @2016-06-17 修改SQL。倒排单票中奖金额
  tempobj_list := json_list();
  for tab in (
              with sa as
               (select agency_code, address from inf_agencys),
              single_ticket_reward as (
                select applyflow_sell, sale_agency, sum(winningamount) amount
                  from his_win_ticket_detail hwt
                 where game_code = p_game_code
                   and issue_number= v_issue_number
                 group by applyflow_sell, sale_agency
         order by amount desc),
              top_10_win as
               (select sale_agency agency_code, amount from single_ticket_reward where rownum <= 10)
              select agency_code, amount, address
                from top_10_win
                join sa
               using(agency_code) order by amount desc
             ) loop
     tempobj := json();
     tempobj.put('agency_code', tab.agency_code);
     tempobj.put('win_amount', tab.amount);
     tempobj.put('agency_adderss',tab.address);
     tempobj_list.append(tempobj.to_json_value);
  end loop;
  all_json_obj.put('big_win', tempobj_list.to_json_value);



  -- 先获取最近100期的开奖号码
  with tab as (
     select issue_number, final_draw_number
       from iss_game_issue
      where game_code=p_game_code
        and final_draw_number is not null
        -- 如果期次编号为0，就把最近的开奖号码发回去
        and issue_number <= v_issue_number
      order by issue_number desc)
  select issue_number, final_draw_number bulk collect into v_array_draw_code
    from tab
   where rownum <= 100;
  dbms_output.put_line(v_array_draw_code.count);

  -- 最近20期分析
  second_json := json();
  for v_loop_i in 1 .. 40 loop
     exit when v_loop_i > v_array_draw_code.count;
     draw_json.put('issue', v_array_draw_code(v_loop_i).issue_number);
     draw_json.put('drawcode', v_array_draw_code(v_loop_i).final_draw_number);
     draw_json_list.append(draw_json.to_json_value);

     -- 每个坑都走一遍
     v_draw_code := replace(v_array_draw_code(v_loop_i).final_draw_number, '+', ',');
     for tab in (select rownum,column_value from table(dbtool.strsplit(v_draw_code))) loop
        draw_number := tab.column_value;
        case tab.rownum
           when 1 then v_rank1_json.replace(draw_number, v_rank1_json.get(draw_number).get_number + 1);
           when 2 then v_rank2_json.replace(draw_number, v_rank2_json.get(draw_number).get_number + 1);
           when 3 then v_rank3_json.replace(draw_number, v_rank3_json.get(draw_number).get_number + 1);
           when 4 then v_rank4_json.replace(draw_number, v_rank4_json.get(draw_number).get_number + 1);
           when 5 then v_rank5_json.replace(draw_number, v_rank5_json.get(draw_number).get_number + 1);
        end case;
        v_rank_json.replace(draw_number, v_rank_json.get(draw_number).get_number + 1);
     end loop;

     exit when v_array_draw_code.count = v_loop_i;
  end loop;
  second_json.put('draw_code', draw_json_list.to_json_value);
  second_json.put('rank_1st', v_rank1_json.to_json_value);
  second_json.put('rank_2st', v_rank2_json.to_json_value);
  second_json.put('rank_3st', v_rank3_json.to_json_value);
  second_json.put('rank_4st', v_rank4_json.to_json_value);
  second_json.put('rank_5st', v_rank5_json.to_json_value);
  second_json.put('rank_total', v_rank_json.to_json_value);

  all_json_obj.put('last_issue_40', second_json.to_json_value);

  -- 冷热号分析（20、50、100期）
  v_rank_json := json_list();
  for v_loop_i in 1 .. 11 loop
     v_rank_json.append(0);
  end loop;
  for v_loop_i in 1 .. 20 loop
     -- 每个坑都走一遍
     exit when v_loop_i > v_array_draw_code.count;
     v_draw_code := replace(v_array_draw_code(v_loop_i).final_draw_number, '+', ',');
     for tab in (select rownum,column_value from table(dbtool.strsplit(v_draw_code))) loop
        draw_number := tab.column_value;
        v_rank_json.replace(draw_number, v_rank_json.get(draw_number).get_number + 1);
     end loop;

     exit when v_array_draw_code.count = v_loop_i;
  end loop;
  all_json_obj.put('hot_cool_20', v_rank_json.to_json_value);

  v_rank_json := json_list();
  for v_loop_i in 1 .. 11 loop
     v_rank_json.append(0);
  end loop;
  for v_loop_i in 1 .. 50 loop
     -- 每个坑都走一遍
     exit when v_loop_i > v_array_draw_code.count;
     v_draw_code := replace(v_array_draw_code(v_loop_i).final_draw_number, '+', ',');
     for tab in (select rownum,column_value from table(dbtool.strsplit(v_draw_code))) loop
        draw_number := tab.column_value;
        v_rank_json.replace(draw_number, v_rank_json.get(draw_number).get_number + 1);
     end loop;

     exit when v_array_draw_code.count = v_loop_i;
  end loop;
  all_json_obj.put('hot_cool_50', v_rank_json.to_json_value);

  v_rank_json := json_list();
  for v_loop_i in 1 .. 11 loop
     v_rank_json.append(0);
  end loop;
  for v_loop_i in 1 .. 100 loop
     -- 每个坑都走一遍
     exit when v_loop_i > v_array_draw_code.count;
     v_draw_code := replace(v_array_draw_code(v_loop_i).final_draw_number, '+', ',');
     for tab in (select rownum,column_value from table(dbtool.strsplit(v_draw_code))) loop
        draw_number := tab.column_value;
        v_rank_json.replace(draw_number, v_rank_json.get(draw_number).get_number + 1);
     end loop;

     exit when v_array_draw_code.count = v_loop_i;
  end loop;
  all_json_obj.put('hot_cool_100', v_rank_json.to_json_value);

  if f_get_sys_param('1105') = '0' then
    all_json_obj.put('roll_text_1', nvl(f_get_sys_param('1101'), ''));
    all_json_obj.put('roll_text_2', nvl(f_get_sys_param('1102'), ''));
    all_json_obj.put('roll_text_3', nvl(f_get_sys_param('1103'), ''));

  else
    -- 7天内中大奖的销售站
    all_json_obj.put('roll_text_1', '');
    all_json_obj.put('roll_text_2', '');
    all_json_obj.put('roll_text_3', '');

    -- modify by kwx @2016-07-05 7天内中大奖前三名大奖信息
    for tab in (with
                sa as (
                  select agency_code, address from inf_agencys),
                single_ticket_reward as (
                  select applyflow_sell, sale_agency, issue_number, sum(winningamount) amount
                    from his_win_ticket_detail hwt
                   where game_code = 12
                     and winnning_time >= trunc(sysdate) - 6
                   group by applyflow_sell, sale_agency, issue_number
                   order by amount desc),
                top_10_win as
                 (select sale_agency agency_code, amount,issue_number from single_ticket_reward where rownum <= 3)
                select rownum, agency_code, amount, address, issue_number
                  from top_10_win
                  join sa
                 using(agency_code) order by amount desc
               ) loop
      all_json_obj.put('roll_text_' || to_char(tab.rownum), to_char(tab.agency_code) || ' ' || to_char(tab.address) || '. ' || to_char(tab.issue_number) || '( ' || to_char(tab.amount) || ' ??? )');
    end loop;
  end if;

  all_json_obj.put('errorCode', 5000);

  temp_clob := empty_clob();
  dbms_lob.createtemporary(temp_clob, true);
  all_json_obj.to_clob(temp_clob);
  update iss_game_issue_xml set json_winning_brodcast = temp_clob where game_code = p_game_code and issue_number = p_issue_number;
  dbms_lob.freetemporary(temp_clob);

  commit;

exception
  when others then
    rollback;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

end;
 
/ 
prompt 正在建立[PROCEDURE -> p_set_term_online.sql ]...... 
create or replace procedure p_set_term_online
/*******************************************************************************/
  ----- 记录终端机在线时长 add by Chen Zhen @ 2016-07-21
  ----- 请求JSON:
  ----- 
  ----- {
  ----- "type":1002,
  ----- "term_code":"0101000101",
  ----- "current_time":1469066100,
  ----- "online_seconds":1200
  ----- }
  ----- 
  ----- term_code 字符串类型，
  ----- current_time：数字类型，表示当前系统时间的时间戳
  ----- online_seconds：数字类型，表示到curr_time 为止，此终端机已经在线多少秒（累计值）
  ----- 
  ----- 响应JSON
  ----- {
  ----- "type":1002,
  ----- "rc":0
  ----- }

  /*******************************************************************************/
(
  p_json       in string,  --入口json
  c_json       out string, --出口json
  c_errorcode  out number, --错误编码
  c_errormesg  out string  --错误原因

)
is
  v_term            saler_terminal.terminal_code%type;
  v_host_stamp      sys_terminal_online_time.host_begin_time_stamp%type;
  v_online_time     sys_terminal_online_time.online_time%type;
  v_trade_type      number(10);

  v_input_json      json;
  v_out_json        json;

  v_ret_string      varchar2(4000);

begin
  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_input_json := json(p_json);
  v_out_json := json();

  -- 获取输入值
  v_trade_type := v_input_json.get('type').get_number;
  v_term := v_input_json.get('term_code').get_string;
  v_host_stamp := v_input_json.get('begin_time').get_number;
  v_online_time := v_input_json.get('online_seconds').get_number;

  if v_trade_type <> 1002 then
    c_errorcode := 1;
    c_errormesg := error_msg.err_comm_trade_type_error || 'Want->1002 Real->' || v_trade_type;             -- 报文输入有错
    return;
  end if;

  insert into SYS_TERMINAL_ONLINE_TIME (
              TERMINAL_CODE, HOST_BEGIN_TIME_STAMP, ONLINE_TIME,    RECORD_TIME, RECORD_DAY) 
       values (
              v_term,        v_host_stamp,          v_online_time,  sysdate,     to_char(sysdate, 'yyyy-mm-dd')
              );

  v_out_json.put('type', v_trade_type);
  v_out_json.put('rc', 0);
  c_json := v_out_json.to_char;

  commit;
exception
  when others then
    rollback;
    c_errorcode := 1;
    c_errormesg := error_msg.err_common_1 || sqlerrm;
end;
 
/ 
prompt 正在建立[PROCEDURE -> p_sys_get_parameter.sql ]...... 
CREATE OR REPLACE PROCEDURE p_sys_get_parameter
/****************************************************************/
   ------------------适用于:主机更新期次状态 -------------------
   /*************************************************************/
(
 --------------输入----------------
 p_param_code IN NUMBER, --参数编号
 ---------出口参数---------
 c_param_value OUT STRING, --参数内容
 c_errorcode   OUT NUMBER, --业务错误编码
 c_errormesg   OUT STRING --错误信息描述
 ) IS

BEGIN
   -- 初始化数据
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   -- 校验参数合法性
   IF p_param_code IS NULL THEN
      c_errorcode := -1;
      c_errormesg := '参数编号为空';
      RETURN;
   END IF;

   BEGIN
      SELECT sys_default_value
        INTO c_param_value
        FROM sys_parameter
       WHERE sys_default_seq = p_param_code;
   EXCEPTION
      WHEN no_data_found THEN
         c_errorcode := -1;
         c_errormesg := '无此参数。参数编号【' || p_param_code || '】';
   END;
EXCEPTION
   WHEN OTHERS THEN
      dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);
END;
 
/ 
prompt 正在建立[PROCEDURE -> p_sys_update_negative_issue.sql ]...... 
CREATE OR REPLACE PROCEDURE p_sys_update_negative_issue
/****************************************************************/
------------------适用于: 刷新以下表中期次为负值的数据 ----------
----------------- adj_game_his
----------------- iss_game_pool_his
/****************************************************************/
IS
   v_cnt    number(10);
BEGIN
   update adj_game_his
      set issue_number = f_get_right_issue(game_code, issue_number)
    where issue_number < 0;

   update iss_game_pool_his
      set issue_number = f_get_right_issue(game_code, issue_number)
    where issue_number < 0;

   commit;
END;
 
/ 
prompt 正在建立[PROCEDURE -> p_tb_inbound.sql ]...... 
create or replace procedure p_tb_inbound
/****************************************************************/
   ------------------- 调拨单入库 -------------------
   ---- 调拨单入库。支持新入库，继续入库，入库完结。
   ----     状态必须是“已发货”，才能进行操作
   ----     新入库：  更新“调拨单”收货信息；创建“入库单”；按照传递的入库对象（箱、盒、包）更新彩票数据，同时也要在入库单明细中记录入库对象；根据彩票统计数据，更新“入库单”和“调拨单”记录；
   ----     继续入库：按照传递的入库对象（箱、盒、包）更新彩票数据，同时也要在入库单明细中记录入库对象；根据彩票统计数据，更新“入库单”和“调拨单”记录；
   ----     入库完结：更新“调拨单”和“入库单”时间和状态信息。
   ---- add by 陈震: 2015/9/19
   ---- 涉及的业务表：
   ----     2.1.6.6 调拨单                      -- 更新
   ----     2.1.5.10 入库单                     -- 新增、更新
   ----     2.1.5.11 入库单明细                 -- 新增、更新
   ----     2.1.5.3 即开票信息（箱）            -- 更新
   ----     2.1.5.4 即开票信息（盒）            -- 更新
   ----     2.1.5.5 即开票信息（本）            -- 更新
   ---- 业务流程：
   ----     1、校验输入参数。（仓库是否存在；操作类型是否为新、继续、完结；操作人是否合法；）
   ----     2、操作类型为“完结”时，更新“调拨单”的“收货时间”和“状态”，更新“入库单”的“入库时间”和“状态”，结束运行，返回。
   ----     3、获取已经保存的参数。（方案批次的包装信息-bulk方式获取；）
   ----     3、操作类型为“新建”时，更新“调拨单”收货信息，条件中要加入“状态”，“状态”必须为“已审批”；创建“入库单”；
   ----     4、按照入库明细，更新“即开票信息”表中各个对象的属性，条件中必须加入“状态”和“所在仓库”条件，并且检查更新记录数量，如果出现无更新记录情况，则报错；同时统计彩票统计信息；
   ----     5、更新“入库单”的“实际入库金额合计”和“实际入库张数”,“调拨单”的“实际调拨票数”和“实际调拨票数涉及金额”记录；

   /*************************************************************/
(
 --------------输入----------------
 p_stb_no            in char,                -- 调拨单编号
 p_warehouse         in char,                -- 收货仓库
 p_oper_type         in number,              -- 操作类型(1-新增，2-继续，3-完结)
 p_oper              in number,              -- 操作人
 p_remark            in varchar2,            -- 备注
 p_array_lotterys    in type_lottery_list,   -- 入库的彩票对象

 ---------出口参数---------
 c_errorcode out number,                     --错误编码
 c_errormesg out string                      --错误原因

 ) is

   v_count                 number(5);                                      -- 求记录数的临时变量
   v_wh_org                char(2);                                        -- 仓库所在部门
   v_plan_tickets          number(18);                                     -- 计划出库票数
   v_plan_amount           number(28);                                     -- 计划出库金额
   v_sgr_no                char(10);                                       -- 出库单编号

   v_list_count            number(10);                                     -- 出库明细总数

   type type_detail        is table of wh_goods_receipt_detail%rowtype;
   v_insert_detail         type_detail;                                    -- 插入出库明细的数组
   v_detail_list           type_lottery_detail_list;                       -- 入库明细
   v_stat_list             type_lottery_statistics_list;                   -- 按照方案和批次统计的金额和票数

   v_total_tickets         number(20);                                     -- 当此出库的总票数
   v_total_amount          number(28);                                     -- 当此出库的总金额
   v_plan_publish          number(1);                                      -- 印制厂商编号

   v_err_code              number(10);                                     -- 调用存储过程时，返回值
   v_err_msg               varchar2(4000);                                 -- 调用存储过程时，返回错误信息

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;

   if not f_check_warehouse(p_warehouse) then
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_warehouse) || error_msg.err_common_101; -- 无此仓库
      return;
   end if;

   if not p_oper_type in (1,2,3) then
      c_errorcode := 3;
      c_errormesg := dbtool.format_line(p_oper_type) || error_msg.err_common_105; -- 操作类型参数错误，应该为1，2，3
      return;
   end if;

   -- 检查入库仓库的组织结构，是否与调拨单中的一致
   with
      wh_org as (select org_code from wh_info where warehouse_code = p_warehouse),
      tgt_org as (select receive_org from sale_transfer_bill where stb_no = p_stb_no)
   select count(*) into v_count from dual where exists(select 1 from wh_org, tgt_org where tgt_org.receive_org = wh_org.org_code);
   if v_count = 0 then
      c_errorcode := 14;
      c_errormesg := dbtool.format_line(p_stb_no) || error_msg.err_p_tb_inbound_2; -- 输入的仓库所属机构，与调拨单中标明的接收机构不符
      return;
   end if;

   -- 继续入库时，判断是否已经完结
   if p_oper_type = 2 then
      select count(*) into v_count from dual where exists(select 1 from wh_goods_receipt where ref_no = p_stb_no and status = ework_status.working);
      if v_count = 0 then
         c_errorcode := 4;
         c_errormesg := dbtool.format_line(p_stb_no) || error_msg.err_p_tb_inbound_3; -- 在进行继续入库时，输入的调拨单号错误，或者此调拨单对应的入库单，入库已经完结
         return;
      end if;
   end if;

   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* 操作类型为“完结”时，更新“调拨单”的“收货时间”和“状态”，更新“入库单”的“入库时间”和“状态”，结束运行，返回。 *************************/
   if p_oper_type = 3 then
      -- 检查入库的内容与申请的内容，是否相符
      with
         act as (
            select plan_code, sum(tickets) alltickets
              from wh_goods_receipt_detail
             where ref_no = p_stb_no
             group by plan_code),
         plan as (
            select plan_code, sum(tickets) alltickets
              from sale_tb_apply_detail
             where stb_no = p_stb_no
             group by plan_code),
         detail as (
            select plan_code, alltickets as act_tickets, 0 as plan_tickets from act
            union all
            select plan_code, 0 as act_tickets, alltickets as plan_tickets from plan),
         result as (
            select plan_code,sum(act_tickets) act_tickets, sum(plan_tickets) plan_tickets from detail group by plan_code),
         not_rule_list as (
            select plan_code, act_tickets, plan_tickets from result where act_tickets > plan_tickets)
      select count(*) into v_count from dual where exists(select 1 from not_rule_list);
      if v_count > 0 then
         rollback;
         c_errorcode := 6;
         c_errormesg := error_msg.err_p_tb_inbound_7; -- 实际调拨票数，应该小于或者等于申请调拨票数
         return;
      end if;


      -- 更新“调拨单”的“收货时间”和“状态”
      update sale_transfer_bill
         set receive_date = sysdate,
             status = eorder_status.received
       where stb_no = p_stb_no
         and status = eorder_status.receiving
      returning
         status
      into
         v_count;
      if sql%rowcount = 0 then
         rollback;

         begin
            select status into v_count from sale_transfer_bill where stb_no = p_stb_no;
         exception
            when no_data_found then
               c_errorcode := 5;
               c_errormesg := dbtool.format_line(p_stb_no) || error_msg.err_p_tb_inbound_25; -- 未查询到此调拨单
               return;
         end;

         c_errorcode := 5;
         c_errormesg := dbtool.format_line(p_stb_no) || dbtool.format_line(v_count) || error_msg.err_p_tb_inbound_4; -- 调拨单入库完结时，调拨单状态与预期值不符
         return;
      end if;

      -- 更新“入库单”的“入库时间”和“状态”
      update wh_goods_receipt
         set status = ework_status.done,
             receipt_end_time = sysdate,
             send_admin = create_admin,
             remark = p_remark
       where ref_no = p_stb_no
         and status = ework_status.working;

      commit;
      return;
   end if;

   /**********************************************************************************************/
   /******************* 检查输入的入库对象以及已经提交的入库对象是否合法 *************************/
   if f_check_import_ticket(p_stb_no, 1, p_array_lotterys) then
      c_errorcode := 6;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_103; -- 彩票对象，存在“自包含”的情况
      return;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* 获取已经保存的参数。（方案批次的包装信息-bulk方式获取；） *************************/

   -- 获取印制厂商信息
/*   select plan_flow
     into v_plan_publish
     from inf_publishers
    where publisher_code =
          (select publisher_code from game_plans where plan_code = p_plan);
*/
   -- 仓库所在部门
   select org_code into v_wh_org from wh_info where warehouse_code = p_warehouse;

   /********************************************************************************************************************************************************************/
   /******************* 操作类型为“新建”时，更新“调拨单”收货信息，条件中要加入“状态”，“状态”必须为“已发货”；创建“入库单” *************************/
   if p_oper_type = 1 then
      -- 更新“调拨单”收货信息
      update sale_transfer_bill
         set receive_org = v_wh_org,
             receive_wh = p_warehouse,
             receive_manager = p_oper,
             status = eorder_status.receiving
       where stb_no = p_stb_no
         and status = eorder_status.sent
      returning
         status, tickets, amount
      into
         v_count, v_plan_tickets, v_plan_amount;
      if sql%rowcount = 0 then
         rollback;
         begin
            select status into v_count from sale_transfer_bill where stb_no = p_stb_no;
         exception
            when no_data_found then
               c_errorcode := 5;
               c_errormesg := dbtool.format_line(p_stb_no) || error_msg.err_p_tb_inbound_25; -- 未查询到此调拨单
               return;
         end;

         c_errorcode := 5;
         c_errormesg := dbtool.format_line(p_stb_no) || dbtool.format_line(v_count) || error_msg.err_p_tb_inbound_4; -- 调拨单入库完结时，调拨单状态与预期值不符
         return;
      end if;

      -- 创建“入库单”
      insert into wh_goods_receipt
         (sgr_no,                      create_admin,             receipt_amount,
          receipt_tickets,             receipt_type,             ref_no,
          receive_org,                 receive_wh)
      values
         (f_get_wh_goods_receipt_seq,  p_oper,                   v_plan_amount,
          v_plan_tickets,              ereceipt_type.trans_bill, p_stb_no,
          v_wh_org,                    p_warehouse)
      returning
         sgr_no
      into
         v_sgr_no;
   else
      -- 获取入库单编号
      begin
         select sgr_no into v_sgr_no from wh_goods_receipt where ref_no = p_stb_no;
      exception
         when no_data_found then
            rollback;
            c_errorcode := 6;
            c_errormesg := dbtool.format_line(p_stb_no) || error_msg.err_p_tb_inbound_6; -- 继续添加彩票时，未能按照输入的调拨单编号，查询到相应的入库单编号。可能传入了错误的调拨单编号
            return;
      end;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* 按照入库明细，更新“即开票信息”表中各个对象的属性；同时统计彩票统计信息 *************************/

   -- 初始化数组
   v_insert_detail := type_detail();
   v_total_tickets := 0;

   -- 根据明细数据，更新“即开票”状态
   p_ticket_perferm(p_array_lotterys, p_oper, eticket_status.on_way, eticket_status.in_warehouse, null, p_warehouse, v_err_code, v_err_msg);
   if v_err_code <> 0 then
      rollback;
      c_errorcode := 1;
      c_errormesg := error_msg.err_common_104 || v_err_msg; -- 更新“即开票”状态时，出现错误
      return;
   end if;

   -- 统计入库对象的票数据
   p_lottery_detail_stat(p_array_lotterys, v_detail_list, v_stat_list, v_total_tickets, v_total_amount);

   -- 插入出库明细
   for v_list_count in 1 .. v_detail_list.count loop
      v_insert_detail.extend;
      v_insert_detail(v_list_count).sgr_no := v_sgr_no;
      v_insert_detail(v_list_count).ref_no := p_stb_no;
      v_insert_detail(v_list_count).sequence_no := f_get_wh_goods_receipt_det_seq;
      v_insert_detail(v_list_count).receipt_type := ereceipt_type.trans_bill;

      v_insert_detail(v_list_count).valid_number := v_detail_list(v_list_count).valid_number;
      v_insert_detail(v_list_count).plan_code := v_detail_list(v_list_count).plan_code;
      v_insert_detail(v_list_count).batch_no := v_detail_list(v_list_count).batch_no;
      v_insert_detail(v_list_count).amount := v_detail_list(v_list_count).amount;
      v_insert_detail(v_list_count).trunk_no := v_detail_list(v_list_count).trunk_no;
      v_insert_detail(v_list_count).box_no := v_detail_list(v_list_count).box_no;
      v_insert_detail(v_list_count).package_no := v_detail_list(v_list_count).package_no;
      v_insert_detail(v_list_count).tickets := v_detail_list(v_list_count).tickets;
   end loop;

   forall v_list_count in 1 .. v_insert_detail.count
      insert into wh_goods_receipt_detail values v_insert_detail(v_list_count);

   /********************************************************************************************************************************************************************/
   /******************* 更新“入库单”的“实际入库金额合计”和“实际入库张数”,“调拨单”的“实际调拨票数”和“实际调拨票数涉及金额”记录 *************************/
   update wh_goods_receipt
      set act_receipt_tickets = nvl(act_receipt_tickets, 0) + v_total_tickets,
          act_receipt_amount = nvl(act_receipt_amount, 0) + v_total_amount
    where sgr_no = v_sgr_no;

   update sale_transfer_bill
      set act_tickets = nvl(act_tickets, 0) + v_total_tickets,
          act_amount = nvl(act_amount, 0) + v_total_amount
    where stb_no = p_stb_no
   returning tickets, act_tickets
        into v_plan_tickets, v_total_tickets;

   -- 检查入库的内容与申请的内容，是否相符
   with
      act as (
         select plan_code, sum(tickets) alltickets
           from wh_goods_receipt_detail
          where ref_no = p_stb_no
          group by plan_code),
      plan as (
         select plan_code, sum(tickets) alltickets
           from sale_tb_apply_detail
          where stb_no = p_stb_no
          group by plan_code),
      detail as (
         select plan_code, alltickets as act_tickets, 0 as plan_tickets from act
         union all
         select plan_code, 0 as act_tickets, alltickets as plan_tickets from plan),
      result as (
         select plan_code,sum(act_tickets) act_tickets, sum(plan_tickets) plan_tickets from detail group by plan_code),
      not_rule_list as (
         select plan_code, act_tickets, plan_tickets from result where act_tickets > plan_tickets)
   select count(*) into v_count from dual where exists(select 1 from not_rule_list);

   if v_count > 0 then
      rollback;
      c_errorcode := 6;
      c_errormesg := error_msg.err_p_tb_inbound_7; -- 实际调拨票数，应该小于或者等于申请调拨票数
      return;
   end if;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
 
/ 
prompt 正在建立[PROCEDURE -> p_tb_outbound.sql ]...... 
create or replace procedure p_tb_outbound
/****************************************************************/
   ------------------- 调拨单出库 -------------------
   ---- 调拨单出库。支持新出库，继续出库，出库完结。
   ----     状态必须是“已审批”，才能进行操作
   ----     新出库：  更新“调拨单”发货信息；创建“出库单”；按照传递的出库对象（箱、盒、包）更新彩票数据，同时也要在出库单明细中记录出库对象；根据彩票统计数据，更新“出库单”和“调拨单”记录；
   ----     继续出库：按照传递的出库对象（箱、盒、包）更新彩票数据，同时也要在出库单明细中记录出库对象；根据彩票统计数据，更新“出库单”和“调拨单”记录；
   ----     出库完结：更新“调拨单”和“出库单”时间和状态信息。
   ---- add by 陈震: 2015/9/19
   ---- 涉及的业务表：
   ----     2.1.6.6 调拨单（sale_transfer_bill）                     -- 更新
   ----     2.1.5.10 出库单（wh_goods_receipt）                      -- 新增、更新
   ----     2.1.5.11 出库单明细（wh_goods_receipt_detail）           -- 新增、更新
   ----     2.1.5.3 即开票信息（箱）（wh_ticket_trunk）              -- 更新
   ----     2.1.5.4 即开票信息（盒）（wh_ticket_box）                -- 更新
   ----     2.1.5.5 即开票信息（本）（wh_ticket_package）            -- 更新
   ---- 业务流程：
   ----     1、校验输入参数。（仓库是否存在；操作类型是否为新、继续、完结；操作人是否合法；）
   ----     2、操作类型为“完结”时，更新“调拨单”的“发货时间”和“状态”，更新“出库单”的“出库时间”和“状态”，结束运行，返回。
   ----     3、获取已经保存的参数。（方案批次的包装信息-bulk方式获取；）
   ----     3、操作类型为“新建”时，更新“调拨单”发货信息，条件中要加入“状态”，“状态”必须为“已审批”；创建“出库单”；
   ----     4、按照出库明细，更新“即开票信息”表中各个对象的属性，条件中必须加入“状态”和“所在仓库”条件，并且检查更新记录数量，如果出现无更新记录情况，则报错；同时统计彩票统计信息；
   ----     5、更新“出库单”的“实际出库金额合计”和“实际出库张数”,“调拨单”的“实际调拨票数”和“实际调拨票数涉及金额”记录；

   /*************************************************************/
(
 --------------输入----------------
 p_stb_no            in char,                -- 调拨单编号
 p_warehouse         in char,                -- 发货仓库
 p_oper_type         in number,              -- 操作类型(1-新增，2-继续，3-完结)
 p_oper              in number,              -- 操作人
 p_remark            in varchar2,            -- 备注
 p_array_lotterys    in type_lottery_list,   -- 出库的彩票对象

 ---------出口参数---------
 c_errorcode out number,                     --错误编码
 c_errormesg out string                      --错误原因

 ) is

   v_count                 number(5);                                      -- 求记录数的临时变量
   v_wh_org                char(2);                                        -- 仓库所在部门
   v_plan_tickets          number(18);                                     -- 计划出库票数
   v_plan_amount           number(28);                                     -- 计划出库金额
   v_sgi_no                char(10);                                       -- 出库单编号
   v_list_count            number(10);                                     -- 出库明细总数

   type type_detail        is table of wh_goods_issue_detail%rowtype;
   v_insert_detail         type_detail;                                    -- 插入出库明细的数组
   v_detail_list           type_lottery_detail_list;                       -- 入库明细
   v_stat_list             type_lottery_statistics_list;                   -- 按照方案和批次统计的金额和票数

   v_total_tickets         number(20);                                     -- 当此出库的总票数
   v_total_amount          number(28);                                     -- 当此出库的总金额
   v_plan_publish          number(1);                                      -- 印制厂商编号

   v_err_code              number(10);                                     -- 调用存储过程时，返回值
   v_err_msg               varchar2(4000);                                 -- 调用存储过程时，返回错误信息

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;

   if not f_check_warehouse(p_warehouse) then
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_warehouse) || error_msg.err_common_101; -- 无此仓库
      return;
   end if;

   if not p_oper_type in (1,2,3) then
      c_errorcode := 3;
      c_errormesg := dbtool.format_line(p_oper_type) || error_msg.err_common_105; -- 操作类型参数错误，应该为1，2，3
      return;
   end if;

   -- 继续入库时，判断是否已经完结
   if p_oper_type = 2 then
      select count(*) into v_count from dual where exists(select 1 from wh_goods_issue where ref_no = p_stb_no and status = ework_status.working);
      if v_count = 0 then
         c_errorcode := 4;
         c_errormesg := dbtool.format_line(p_stb_no) || error_msg.err_p_tb_outbound_3; -- 在进行继续出库时，输入的调拨单号错误，或者此调拨单对应的出库单，出库已经完结
         return;
      end if;
   end if;

   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* 操作类型为“完结”时，更新“调拨单”的“发货时间”和“状态”，更新“出库单”的“出库时间”和“状态”，结束运行，返回。 *************************/
   if p_oper_type = 3 then
      -- 更新“调拨单”的“发货时间”和“状态”
      update sale_transfer_bill
         set send_date = sysdate,
             status = eorder_status.sent
       where stb_no = p_stb_no
         and status = eorder_status.agreed
      returning
         status
      into
         v_count;
      if sql%rowcount = 0 then
         select status into v_count from sale_transfer_bill where stb_no = p_stb_no;
         rollback;
         c_errorcode := 5;
         c_errormesg := dbtool.format_line(p_stb_no) || dbtool.format_line(v_count) || error_msg.err_p_tb_outbound_4; -- 调拨单出库完结时，调拨单状态不合法
         return;
      end if;

      -- 更新“出库单”的“出库时间”和“状态”
      update wh_goods_issue
         set status = ework_status.done,
             issue_end_time = sysdate,
             receive_admin = create_admin,
             remark = p_remark
       where ref_no = p_stb_no
         and status = ework_status.working
       returning issue_tickets,  issue_amount,  act_issue_tickets, act_issue_amount
            into v_plan_tickets, v_plan_amount, v_total_tickets,   v_total_amount;

      -- 检查入库的内容与申请的内容，是否相符
      with
         act as (
            select plan_code, sum(tickets) alltickets
              from wh_goods_issue_detail
             where ref_no = p_stb_no
             group by plan_code),
         plan as (
            select plan_code, sum(tickets) alltickets
              from sale_tb_apply_detail
             where stb_no = p_stb_no
             group by plan_code),
         detail as (
            select plan_code, alltickets as act_tickets, 0 as plan_tickets from act
            union all
            select plan_code, 0 as act_tickets, alltickets as plan_tickets from plan),
         result as (
            select plan_code,sum(act_tickets) act_tickets, sum(plan_tickets) plan_tickets from detail group by plan_code),
         not_rule_list as (
            select plan_code, act_tickets, plan_tickets from result where act_tickets <> plan_tickets)
      select count(*) into v_count from dual where exists(select 1 from not_rule_list);
      if v_count > 0 then
         rollback;
         c_errorcode := 5;
         c_errormesg := error_msg.err_p_tb_outbound_14; -- 调拨单实际出库数量与申请数量不符
         return;
      end if;

      commit;
      return;
   end if;

   /************************************************************************************/
   /******************* 检查输入的入库对象是否合法 *************************/
   if f_check_import_ticket(p_stb_no, 2, p_array_lotterys) then
      c_errorcode := 6;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_103; -- 彩票对象，存在“自包含”的情况
      return;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* 获取已经保存的参数。（方案批次的包装信息-bulk方式获取；） *************************/

   -- 获取印制厂商信息
/*   select plan_flow
     into v_plan_publish
     from inf_publishers
    where publisher_code =
          (select publisher_code from game_plans where plan_code = p_plan);
*/

   -- 仓库所在部门
   select org_code into v_wh_org from wh_info where warehouse_code = p_warehouse;

   /********************************************************************************************************************************************************************/
   /******************* 操作类型为“新建”时，更新“调拨单”发货信息，条件中要加入“状态”，“状态”必须为“已审批”；创建“出库单” *************************/
   if p_oper_type = 1 then
      -- 更新“调拨单”发货信息
      update sale_transfer_bill
         set send_org = v_wh_org,
             send_wh = p_warehouse,
             send_manager = p_oper,
             status = eorder_status.agreed
       where stb_no = p_stb_no
         and status = eorder_status.audited
      returning
         status, tickets, amount
      into
         v_count, v_plan_tickets, v_plan_amount;
      if sql%rowcount = 0 then
         rollback;
         c_errorcode := 5;
         c_errormesg := dbtool.format_line(p_stb_no) || dbtool.format_line(v_count) || error_msg.err_p_tb_outbound_5; -- 进行调拨单出库时，调拨单状态不合法
         return;
      end if;

      -- 创建“出库单”
      insert into wh_goods_issue
         (sgi_no,                    create_admin,           issue_amount,
          issue_tickets,             issue_type,             ref_no,
          send_org,                  send_wh)
      values
         (f_get_wh_goods_issue_seq,  p_oper,                 v_plan_amount,
          v_plan_tickets,            eissue_type.trans_bill, p_stb_no,
          v_wh_org,                  p_warehouse)
      returning
         sgi_no
      into
         v_sgi_no;
   else
      -- 获取出库单编号
      begin
         select sgi_no into v_sgi_no from wh_goods_issue where ref_no = p_stb_no;
      exception
         when no_data_found then
            rollback;
            c_errorcode := 6;
            c_errormesg := dbtool.format_line(p_stb_no) || error_msg.err_p_tb_outbound_6; -- 不能获得出库单编号
            return;
      end;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* 按照出库明细，更新“即开票信息”表中各个对象的属性；同时统计彩票统计信息 *************************/

   -- 初始化数组
   v_insert_detail := type_detail();
   v_total_tickets := 0;


   -- 根据明细数据，更新“即开票”状态
   p_ticket_perferm(p_array_lotterys, p_oper, eticket_status.in_warehouse, eticket_status.on_way, p_warehouse, null, v_err_code, v_err_msg);
   if v_err_code <> 0 then
      rollback;
      c_errorcode := 1;
      c_errormesg := error_msg.err_common_104 || v_err_msg; -- 更新“即开票”状态时，出现错误
      return;
   end if;

   -- 统计入库对象的票数据
   p_lottery_detail_stat(p_array_lotterys, v_detail_list, v_stat_list, v_total_tickets, v_total_amount);

   -- 插入出库明细
   for v_list_count in 1 .. v_detail_list.count loop
      v_insert_detail.extend;
      v_insert_detail(v_list_count).sgi_no := v_sgi_no;
      v_insert_detail(v_list_count).ref_no := p_stb_no;
      v_insert_detail(v_list_count).sequence_no := f_get_wh_goods_issue_detai_seq;
      v_insert_detail(v_list_count).issue_type := eissue_type.trans_bill;

      v_insert_detail(v_list_count).valid_number := v_detail_list(v_list_count).valid_number;
      v_insert_detail(v_list_count).plan_code := v_detail_list(v_list_count).plan_code;
      v_insert_detail(v_list_count).batch_no := v_detail_list(v_list_count).batch_no;
      v_insert_detail(v_list_count).amount := v_detail_list(v_list_count).amount;
      v_insert_detail(v_list_count).trunk_no := v_detail_list(v_list_count).trunk_no;
      v_insert_detail(v_list_count).box_no := v_detail_list(v_list_count).box_no;
      v_insert_detail(v_list_count).package_no := v_detail_list(v_list_count).package_no;
      v_insert_detail(v_list_count).tickets := v_detail_list(v_list_count).tickets;
   end loop;

   forall v_list_count in 1 .. v_insert_detail.count
      insert into wh_goods_issue_detail values v_insert_detail(v_list_count);

   /********************************************************************************************************************************************************************/
   /******************* 更新“出库单”的“实际出库金额合计”和“实际出库张数”,“调拨单”的“实际调拨票数”和“实际调拨票数涉及金额”记录 *************************/
   update wh_goods_issue
      set act_issue_tickets = act_issue_tickets + v_total_tickets,
          act_issue_amount = act_issue_amount + v_total_amount
    where sgi_no = v_sgi_no
   returning issue_tickets, act_issue_tickets
        into v_plan_amount, v_total_amount;

   -- 检查入库的内容与申请的内容，是否相符
   with
      act as (
         select plan_code, sum(tickets) alltickets
           from wh_goods_issue_detail
          where ref_no = p_stb_no
          group by plan_code),
      plan as (
         select plan_code, sum(tickets) alltickets
           from sale_tb_apply_detail
          where stb_no = p_stb_no
          group by plan_code),
      detail as (
         select plan_code, alltickets as act_tickets, 0 as plan_tickets from act
         union all
         select plan_code, 0 as act_tickets, alltickets as plan_tickets from plan),
      result as (
         select plan_code,sum(act_tickets) act_tickets, sum(plan_tickets) plan_tickets from detail group by plan_code),
      not_rule_list as (
         select plan_code, act_tickets, plan_tickets from result where act_tickets > plan_tickets)
   select count(*) into v_count from dual where exists(select 1 from not_rule_list);
   if v_count > 0 then
      rollback;
      c_errorcode := 5;
      c_errormesg := error_msg.err_p_tb_outbound_14; -- 调拨单实际出库数量与申请数量不符
      return;
   end if;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;
end;

 
/ 
prompt 正在建立[PROCEDURE -> p_ticket_perferm.sql ]...... 
create or replace procedure p_ticket_perferm
/*********************************************************************************/
   ------------- 按照输入的数组和参数，处理“即开票”数据（不提交） ---------------
   ---- add by 陈震: 2015/9/25
   ---- 涉及的业务表：
   ----     2.1.5.3 即开票信息（箱）（wh_ticket_trunk）
   ----     2.1.5.4 即开票信息（盒）（wh_ticket_box）
   ----     2.1.5.5 即开票信息（本）（wh_ticket_package）

/*********************************************************************************/
(
 --------------输入----------------
 p_array_lotterys    in type_lottery_list,   -- 入库的彩票对象
 p_oper              in number,              -- 操作人
 p_be_status         in number,              -- 之前的状态
 p_af_status         in number,              -- 之后的状态
 p_last_wh           in varchar2,            -- 之前仓库
 p_current_wh        in varchar2,            -- 之前仓库
 ---------出口参数---------
 c_errorcode out number,                     --错误编码
 c_errormesg out string                      --错误原因

 ) is

   v_array_lottery         type_lottery_info;                              -- 单张彩票
   v_lottery_detail        type_lottery_info;                              -- 彩票对象详细信息
   v_single_ticket_amount  number(10);                                     -- 每张票的价格
   v_packs_every_box       number(10);                                     -- 每“盒”中包含多少“本”
   v_collect_batch_param   game_batch_import_detail%rowtype;               -- 批次参数

   v_trunck_info           wh_ticket_trunk%rowtype;                        -- 箱信息
   v_box_info              wh_ticket_box%rowtype;                          -- 箱信息
   v_package_info          wh_ticket_package%rowtype;                      -- 箱信息

   v_wh_status             number(2);

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   -- 判断源端和目标端的仓库是否正在盘点，如果是，就不允许做操作
   if (p_be_status in (eticket_status.in_warehouse) or p_af_status in (eticket_status.in_warehouse)) then
      if p_be_status in (eticket_status.in_warehouse) then
         select STATUS
           into v_wh_status
           from WH_INFO
          where WAREHOUSE_CODE = p_last_wh;
         if v_wh_status <> ewarehouse_status.working then
            c_errorcode := 1;
            c_errormesg := dbtool.format_line(p_last_wh) || error_msg.err_p_ticket_perferm_1; -- 此仓库状态处于盘点或停用状态，不能进行出入库操作
            return;
         end if;
      end if;
      if p_af_status in (eticket_status.in_warehouse) then
         select STATUS
           into v_wh_status
           from WH_INFO
          where WAREHOUSE_CODE = p_current_wh;
      end if;
      if v_wh_status <> ewarehouse_status.working then
         c_errorcode := 1;
         c_errormesg := dbtool.format_line(p_current_wh) || error_msg.err_p_ticket_perferm_1; -- 此仓库状态处于盘点或停用状态，不能进行出入库操作
         return;
      end if;
   end if;

   -- 循环处理明细数据
   for v_list_count in 1 .. p_array_lotterys.count loop
      v_array_lottery := p_array_lotterys(v_list_count);

      -- 获取保存的参数
      select * into v_collect_batch_param from game_batch_import_detail where plan_code = v_array_lottery.plan_code and batch_no = v_array_lottery.batch_no;

      -- 检查方案批次是否存在
      if not f_check_plan_batch(v_array_lottery.plan_code, v_array_lottery.batch_no) then
         c_errorcode := 3;
         c_errormesg := dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || error_msg.err_p_ticket_perferm_3; -- 系统中不存在此批次的彩票方案
         return;
      end if;

      -- 检查方案批次是否有效
      if not f_check_plan_batch_status(v_array_lottery.plan_code, v_array_lottery.batch_no) then
         c_errorcode := 5;
         c_errormesg := dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || error_msg.err_p_ticket_perferm_5; -- 此批次的彩票方案已经停用
         return;
      end if;

      -- 获取单张票金额
      select ticket_amount into v_single_ticket_amount from game_plans where plan_code = v_array_lottery.plan_code;

      -- 每“盒”中包含多少“本”
      v_packs_every_box := v_collect_batch_param.packs_every_trunk / v_collect_batch_param.boxes_every_trunk;

      case
         when v_array_lottery.valid_number = evalid_number.trunk then
            -- 更新“箱”位置
            update wh_ticket_trunk
               set status = p_af_status,
                   last_warehouse = p_last_wh,
                   current_warehouse = p_current_wh,
                   change_admin = p_oper,
                   change_date = sysdate
             where status = p_be_status
               and is_full = eboolean.yesorenabled
               and nvl(current_warehouse, 'NULL') = nvl(p_last_wh, 'NULL')
               and plan_code = v_array_lottery.plan_code
               and batch_no = v_array_lottery.batch_no
               and trunk_no = v_array_lottery.trunk_no;

            if sql%rowcount = 0 then
               rollback;

               begin
                  select * into v_trunck_info
                    from wh_ticket_trunk
                   where plan_code = v_array_lottery.plan_code
                     and batch_no = v_array_lottery.batch_no
                     and trunk_no = v_array_lottery.trunk_no;
               exception
                  when no_data_found then
                     c_errorcode := 1;
                     c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.trunk_no)
                                    || error_msg.err_p_ticket_perferm_10; -- 此箱彩票不存在
                     return;
               end;

               if v_trunck_info.status <> p_be_status then
                  c_errorcode := 2;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.trunk_no)
                                 || error_msg.err_p_ticket_perferm_20 || dbtool.format_line(v_trunck_info.status); -- 此“箱”彩票的状态与预期不符，当前状态为
                  return;
               end if;

               if v_trunck_info.is_full <> eboolean.yesorenabled then
                  c_errorcode := 3;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.trunk_no)
                                 || error_msg.err_p_ticket_perferm_30; -- 此“箱”彩票在系统中处于开箱状态，因此不能进行整箱处理
                  return;
               end if;

               if nvl(v_trunck_info.current_warehouse, 'NULL') <> nvl(p_last_wh, 'NULL') then
                  c_errorcode := 4;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.trunk_no)
                                 || error_msg.err_p_ticket_perferm_40; -- 此“箱”彩票库存信息可能存在错误，请查询以后再进行操作
                  return;
               end if;

               c_errorcode := 5;
               c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.trunk_no)
                              || error_msg.err_p_ticket_perferm_50; -- 处理彩票时，出现数据异常，请联系系统人员
               return;
            end if;

            -- 更新“箱”对应的“盒”的信息
            update wh_ticket_box
               set status = p_af_status,
                   current_warehouse = p_current_wh,
                   last_warehouse = p_last_wh,
                   change_admin = p_oper,
                   change_date = sysdate
             where status = p_be_status
               and is_full = eboolean.yesorenabled
               and nvl(current_warehouse, 'NULL') = nvl(p_last_wh, 'NULL')
               and plan_code = v_array_lottery.plan_code
               and batch_no = v_array_lottery.batch_no
               and trunk_no = v_array_lottery.trunk_no;
            if sql%rowcount <> v_collect_batch_param.boxes_every_trunk then
               rollback;
               c_errorcode := 6;
               c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.trunk_no)
                              || error_msg.err_p_ticket_perferm_60; -- 处理“箱”时，“盒”数据出现异常。可能的错误为：1-此箱对应的某些盒已经被拆开使用，2-此箱对应的某些盒已经被转移，3-此箱对应的某些盒的状态与预期状态不符
               return;
            end if;

            -- 更新“箱”对应的“本”的信息
            update wh_ticket_package
               set status = p_af_status,
                   current_warehouse = p_current_wh,
                   last_warehouse = p_last_wh,
                   change_admin = p_oper,
                   change_date = sysdate
             where status = p_be_status
               and nvl(current_warehouse, 'NULL') = nvl(p_last_wh, 'NULL')
               and plan_code = v_array_lottery.plan_code
               and batch_no = v_array_lottery.batch_no
               and trunk_no = v_array_lottery.trunk_no;
            if sql%rowcount <> v_collect_batch_param.packs_every_trunk then
               rollback;
               c_errorcode := 7;
               c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.trunk_no)
                              || error_msg.err_p_ticket_perferm_70; -- 处理“箱”时，“盒”数据出现异常。可能的错误为：1-此箱对应的某些本已经被转移，2-此箱对应的某些本的状态与预期状态不符
               return;
            end if;

         when v_array_lottery.valid_number = evalid_number.box then
            -- 校验是否存在此类数据
            v_lottery_detail := f_get_lottery_info(v_array_lottery.plan_code, v_array_lottery.batch_no, v_array_lottery.valid_number, v_array_lottery.box_no);

            -- 更新“箱”位置
            update wh_ticket_trunk
               set is_full = eboolean.noordisabled
             where plan_code = v_array_lottery.plan_code
               and batch_no = v_array_lottery.batch_no
               and trunk_no = v_lottery_detail.trunk_no;

            -- 进入主题，更新“盒”位置
            update wh_ticket_box
               set status = p_af_status,
                   current_warehouse = p_current_wh,
                   last_warehouse = p_last_wh,
                   change_admin = p_oper,
                   change_date = sysdate
             where status = p_be_status
               and is_full = eboolean.yesorenabled
               and nvl(current_warehouse, 'NULL') = nvl(p_last_wh, 'NULL')
               and plan_code = v_array_lottery.plan_code
               and batch_no = v_array_lottery.batch_no
               and trunk_no = v_lottery_detail.trunk_no
               and box_no = v_array_lottery.box_no;
            if sql%rowcount = 0 then
               rollback;

               begin
                  select * into v_box_info
                    from wh_ticket_box
                   where plan_code = v_array_lottery.plan_code
                     and batch_no = v_array_lottery.batch_no
                     and trunk_no = v_lottery_detail.trunk_no
                     and box_no = v_array_lottery.box_no;
               exception
                  when no_data_found then
                     c_errorcode := 1;
                     c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.box_no)
                                    || error_msg.err_p_ticket_perferm_110; -- 此盒彩票不存在
                     return;
               end;

               if v_box_info.status <> p_be_status then
                  c_errorcode := 2;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.box_no)
                                 || error_msg.err_p_ticket_perferm_120 || dbtool.format_line(v_box_info.status); -- 此“盒”彩票的状态与预期不符，当前状态为
                  return;
               end if;

               if v_box_info.is_full <> eboolean.yesorenabled then
                  c_errorcode := 3;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.box_no)
                                 || error_msg.err_p_ticket_perferm_130; -- 此“盒”彩票在系统中处于开箱状态，因此不能进行整箱处理
                  return;
               end if;

               if nvl(v_box_info.current_warehouse, 'NULL') <> nvl(p_last_wh, 'NULL') then
                  c_errorcode := 4;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.box_no)
                                 || error_msg.err_p_ticket_perferm_140; -- 此“盒”彩票库存信息可能存在错误，请查询以后再进行操作
                  return;
               end if;

               c_errorcode := 5;
               c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.box_no)
                              || error_msg.err_p_ticket_perferm_150; -- 处理彩票时，出现数据异常，请联系系统人员
               return;

            end if;

            -- 更新“盒”对应的“本”的信息
            update wh_ticket_package
               set status = p_af_status,
                   current_warehouse = p_current_wh,
                   last_warehouse = p_last_wh,
                   change_admin = p_oper,
                   change_date = sysdate
             where status = p_be_status
               and nvl(current_warehouse, 'NULL') = nvl(p_last_wh, 'NULL')
               and plan_code = v_array_lottery.plan_code
               and batch_no = v_array_lottery.batch_no
               and trunk_no = v_lottery_detail.trunk_no
               and box_no = v_array_lottery.box_no;
            if sql%rowcount <> v_packs_every_box then
               rollback;
               c_errorcode := 5;
               c_errormesg :=    dbtool.format_line('p_ticket_perferm') || dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.trunk_no)
                              || error_msg.err_p_ticket_perferm_160; -- 处理“盒”时，“本”数据出现异常。可能的错误为：1-此盒对应的某些本已经被转移，2-此盒对应的某些本的状态与预期状态不符
               return;
            end if;

         when v_array_lottery.valid_number = evalid_number.pack then
            v_lottery_detail := f_get_lottery_info(v_array_lottery.plan_code, v_array_lottery.batch_no, v_array_lottery.valid_number, v_array_lottery.package_no);

            -- 更新“本”位置
            update wh_ticket_trunk
               set is_full = eboolean.noordisabled
             where plan_code = v_array_lottery.plan_code
               and batch_no = v_array_lottery.batch_no
               and trunk_no = v_lottery_detail.trunk_no;

            update wh_ticket_box
               set is_full = eboolean.noordisabled
             where plan_code = v_array_lottery.plan_code
               and batch_no = v_array_lottery.batch_no
               and trunk_no = v_lottery_detail.trunk_no
               and box_no = v_lottery_detail.box_no;

            update wh_ticket_package
               set status = p_af_status,
                   current_warehouse = p_current_wh,
                   last_warehouse = p_last_wh,
                   change_admin = p_oper,
                   change_date = sysdate
             where status = p_be_status
               and nvl(current_warehouse, 'NULL') = nvl(p_last_wh, 'NULL')
               and plan_code = v_array_lottery.plan_code
               and batch_no = v_array_lottery.batch_no
               and trunk_no = v_lottery_detail.trunk_no
               and box_no = v_lottery_detail.box_no
               and package_no = v_array_lottery.package_no;
            if sql%rowcount = 0 then
               rollback;
               begin
                  select * into v_package_info
                    from wh_ticket_package
                   where plan_code = v_array_lottery.plan_code
                     and batch_no = v_array_lottery.batch_no
                     and trunk_no = v_lottery_detail.trunk_no
                     and box_no = v_lottery_detail.box_no
                     and package_no = v_array_lottery.package_no;
               exception
                  when no_data_found then
                     c_errorcode := 1;
                     c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.package_no)
                                    || error_msg.err_p_ticket_perferm_210; -- 此本彩票不存在
                     return;
               end;

               if v_package_info.status <> p_be_status then
                  c_errorcode := 2;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.package_no)
                                 || error_msg.err_p_ticket_perferm_220 || dbtool.format_line(v_package_info.status); -- 此“本”彩票的状态与预期不符，当前状态为
                  return;
               end if;

               if nvl(v_package_info.current_warehouse, 'NULL') <> nvl(p_last_wh, 'NULL') then
                  c_errorcode := 4;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.package_no)
                                 || error_msg.err_p_ticket_perferm_230; -- 此“本”彩票库存信息可能存在错误，请查询以后再进行操作
                  return;
               end if;

               c_errorcode := 5;
               c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.package_no)
                              || error_msg.err_p_ticket_perferm_240; -- 处理彩票时，出现数据异常，请联系系统人员
               return;
            end if;

      end case;
   end loop;

exception
   when others then
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;
end;
 
/ 
prompt 正在建立[PROCEDURE -> p_time_gen_by_day.sql ]...... 
create or replace procedure p_time_gen_by_day (
   p_curr_date       date        default sysdate,
   p_maintance_mod   number      default 0
)
/****************************************************************/
   ------------------- 仅用于统计数据（每日0点执行） -------------------
   ---- add by 陈震: 2015/10/14
   /*************************************************************/
is
   v_temp1        number(28);
   v_temp2        number(28);

   v_max_org_pay_flow char(24);

begin

   if p_maintance_mod = 0 then
      -- 活动加送的佣金
      if to_char(sysdate, 'dd') = '01' then
        v_temp1 := '';
        --p_time_lot_promotion;
      end if;

      -- 库存信息
      insert into his_lottery_inventory
         (calc_date,
          plan_code,
          batch_no,
          reward_group,
          status,
          warehouse,
          tickets,
          amount)
         with total as
          (select to_char(p_curr_date - 1,'yyyy-mm-dd') calc_date,
                  plan_code,
                  batch_no,
                  reward_group,
                  tab.status,
                  nvl(current_warehouse, '[null]') warehouse,
                  sum(tickets_every_pack) tickets
             from wh_ticket_package tab
             join game_batch_import_detail
            using (plan_code, batch_no)
            group by plan_code,
                     batch_no,
                     reward_group,
                     tab.status,
                     nvl(current_warehouse, '[null]'))
         select calc_date,
                plan_code,
                batch_no,
                reward_group,
                status,
                to_char(warehouse),
                tickets,
                tickets * ticket_amount
           from total
           join game_plans
          using (plan_code);

      commit;

      -- 站点资金日结
      insert into his_agency_fund (calc_date, agency_code, flow_type, amount, be_account_balance, af_account_balance)
      with last_day as
       (select agency_code, af_account_balance be_account_balance
          from his_agency_fund
         where calc_date = to_char(p_curr_date - 2, 'yyyy-mm-dd')
           and flow_type = 0),
      this_day as
       (select agency_code, account_balance af_account_balance
          from acc_agency_account
         where acc_type = 1),
      now_fund as
       (select agency_code, flow_type, sum(change_amount) as amount
          from flow_agency
         where trade_time >= trunc(p_curr_date - 1)
           and trade_time < trunc(p_curr_date)
         group by agency_code, flow_type),
      agency_balance as
       (select agency_code, be_account_balance, 0 as af_account_balance from last_day
         union all
        select agency_code, 0 as be_account_balance, af_account_balance from this_day),
      ab as
       (select agency_code, sum(be_account_balance) be_account_balance, sum(af_account_balance) af_account_balance from agency_balance group by agency_code)
      select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
             agency_code,
             flow_type,
             amount,
             0 be_account_balance,
             0 af_account_balance
        from now_fund
      union all
      select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
             agency_code,
             0,
             0,
             be_account_balance,
             af_account_balance
        from ab;

      commit;
   end if;

   -- 站点库存日结
   insert into his_agency_inv
     (calc_date, agency_code, plan_code, oper_type, amount, tickets)
   with base as (
   -- 站点退货
   select SEND_WH agency_code,plan_code,10 inv_type,sum(AMOUNT) amount, sum(TICKETS) tickets
     from WH_GOODS_ISSUE mm join WH_GOODS_ISSUE_detail detail using(SGI_NO)
    where detail.ISSUE_TYPE = 4
      and ISSUE_END_TIME >= trunc(p_curr_date) - 1
      and ISSUE_END_TIME < trunc(p_curr_date)
   group by SEND_WH,plan_code
   union all
   -- 站点收货
   select RECEIVE_WH,plan_code,20 inv_type,sum(AMOUNT) amount, sum(TICKETS) tickets
    from WH_GOODS_RECEIPT mm join WH_GOODS_RECEIPT_detail detail using(sgr_no)
    where detail.RECEIPT_TYPE = 4
      and RECEIPT_END_TIME >= trunc(p_curr_date) - 1
      and RECEIPT_END_TIME < trunc(p_curr_date)
   group by RECEIVE_WH,plan_code
   union all
   -- 站点期初
   select WAREHOUSE,plan_code,88 inv_type,sum(AMOUNT) amount, sum(TICKETS) tickets
     from HIS_LOTTERY_INVENTORY
    where STATUS = 31
      and CALC_DATE = to_char(trunc(p_curr_date) - 2,'yyyy-mm-dd')
   group by WAREHOUSE,plan_code
   union all
   -- 站点期末
   select WAREHOUSE,plan_code,99 inv_type,sum(AMOUNT) amount, sum(TICKETS) tickets
     from HIS_LOTTERY_INVENTORY
    where STATUS = 31
      and CALC_DATE = to_char(trunc(p_curr_date) - 1,'yyyy-mm-dd')
   group by WAREHOUSE,plan_code)
   select to_char(trunc(p_curr_date) - 1,'yyyy-mm-dd'),agency_code, plan_code, inv_type, amount, tickets from base;

   commit;


    -- 销量按部门分方案监控
   insert into his_sale_org (calc_date, org_code, plan_code, sale_amount, sale_comm, cancel_amount, cancel_comm, paid_amount, paid_comm, incoming)
   with time_con as
    (select (trunc(p_curr_date) - 1) s_time, trunc(p_curr_date) e_time from dual),
   sale_stat as
    (select org_code, plan_code, sum(sale_amount) amount, sum(comm_amount) comm
       from flow_sale, time_con
      where sale_time >= s_time
        and sale_time < e_time
      group by org_code, plan_code),
   cancel_stat as
    (select org_code, plan_code, sum(sale_amount) amount, sum(comm_amount) comm
       from flow_cancel, time_con
      where cancel_time >= s_time
        and cancel_time < e_time
      group by org_code, plan_code),
   pay_stat as
    (select f_get_flow_pay_org(pay_flow) org_code, plan_code, nvl(sum(pay_amount),0) amount, nvl(sum(pay_comm),0) comm
       from flow_pay, time_con
      where pay_time >= s_time
        and pay_time < e_time
        and is_center_paid = 3
      group by f_get_flow_pay_org(pay_flow), plan_code),
  /* --modify by kwx 2016-06-01 flow_pay里不记录代理商，而flow_pay_org_comm里不记录分公司,因此在做中心兑奖统计时需要将代理商和分公司的合并起来统计 */
    pay_center_stat as
    (select org_code, plan_code, nvl(sum(pay_amount),0) amount, nvl(sum(org_pay_comm),0) comm
       from flow_pay_org_comm, time_con
      where pay_time >= s_time
        and pay_time < e_time
        and is_center_paid = 1
    and f_get_org_type(org_code)=2
      group by org_code, plan_code
    union all
    select f_get_flow_pay_org(pay_flow) org_code, plan_code, nvl(sum(pay_amount),0) amount, nvl(sum(pay_comm),0) comm
       from flow_pay, time_con
      where pay_time >= s_time
        and pay_time < e_time
        and is_center_paid = 1
    and f_get_org_type(f_get_flow_pay_org(pay_flow))=1
      group by f_get_flow_pay_org(pay_flow), plan_code),
    lot_sale_stat as
      (select SALE_AREA org_code, game_code, sum(sale_amount) amount, sum(sale_commission) comm
         from sub_sell, time_con
        where SALE_DATE >= to_char(s_time,'yyyy-mm-dd')
          and SALE_DATE < to_char(e_time,'yyyy-mm-dd')
        group by SALE_AREA, game_code),
  /* --modify by kwx 2016-06-01 目前电脑票没有销售站票退票,但是中心退票会给销售站退佣金,因此暂时统计销售站退票的金额为0 */
     lot_cancel_stat as
      (select SALE_AREA org_code, game_code, 0 amount, sum(CANCEL_COMMISSION) comm
         from sub_cancel, inf_orgs, time_con
        where CANCEL_DATE >= to_char(s_time,'yyyy-mm-dd')
          and CANCEL_DATE < to_char(e_time,'yyyy-mm-dd')
      and SALE_AREA = org_code
          and org_type = 1
        group by SALE_AREA, game_code),
     lot_pay_stat as
      (select PAY_AREA org_code, game_code, sum(PAY_AMOUNT) amount, sum(PAY_COMMISSION) comm
         from sub_pay, time_con
        where PAY_AGENCY is not null and PAY_DATE >= to_char(s_time,'yyyy-mm-dd')
          and PAY_DATE < to_char(e_time,'yyyy-mm-dd')
        group by PAY_AREA, game_code),
      lot_pay_center_stat as
      (select org_code,plan_code,sum(amount) amount,sum(comm) comm from (
      select org_code,
              (case when flow_type=36 then (select game_code from his_sellticket where APPLYFLOW_sell=(select APPLYFLOW_sell from his_payticket where APPLYFLOW_PAY=flow_org.ref_no))
                    when flow_type=37 then (select game_code from his_sellticket where APPLYFLOW_sell=(select APPLYFLOW_sell from his_payticket where APPLYFLOW_PAY=flow_org.ref_no))
              end) plan_code,
              (case when flow_type=37 then change_amount else 0 end) amount,(case when flow_type=36 then change_amount else 0 end) comm
           from flow_org , time_con
       where flow_type in (36,37)
          and trade_time >= s_time
          and trade_time < e_time) group by plan_code,org_code),
      lot_cancel_center_stat as
       (select org_code,plan_code,sum(amount) amount,sum(comm) comm from (
         select org_code,
               (case when flow_type=35 then (select game_code from his_sellticket where APPLYFLOW_sell=(select APPLYFLOW_sell from his_cancelticket where APPLYFLOW_CANCEL=flow_org.ref_no))
                     when flow_type=38 then (select game_code from his_sellticket where APPLYFLOW_sell=(select APPLYFLOW_sell from his_cancelticket where APPLYFLOW_CANCEL=flow_org.ref_no))
                end) plan_code,
               (case when flow_type=38 then change_amount else 0 end) amount,(case when flow_type=35 then change_amount else 0 end) comm
           from flow_org , time_con
        where flow_type in (35,38)
           and trade_time >= s_time
           and trade_time < e_time)
    group by plan_code,org_code),
     pre_detail as
    (select * from  (select org_code, plan_code, 1 ftype, amount, comm from sale_stat
                     union all
                     select org_code, plan_code, 2 ftype, amount, comm from cancel_stat
                     union all
                     select org_code, plan_code, 3 ftype, amount, comm from pay_stat
                     union all
                     select org_code, plan_code, 4 ftype, amount, comm from pay_center_stat
                     union all
                     select org_code, to_char(game_code), 5 ftype, amount, comm from lot_sale_stat
                     union all
                     select org_code, to_char(game_code), 6 ftype, amount, comm from lot_cancel_stat
                     union all
                     select org_code, to_char(game_code), 7 ftype, amount, comm from lot_pay_stat
                     union all
                     select org_code, to_char(plan_code), 8 ftype, amount, comm from lot_pay_center_stat
                     union all
                     select org_code, to_char(plan_code), 9 ftype, amount, comm from lot_cancel_center_stat)
      pivot (sum(amount) as amount, sum(comm) as comm for ftype in (1 as sale, 2 as cancel, 3 as pay, 4 as pay_center, 5 as lot_sale, 6 as lot_cancel, 7 as lot_pay, 8 as lot_pay_center, 9 as lot_cancel_center))
    ),
   no_null as (
   select to_char(time_con.s_time, 'yyyy-mm-dd') calc_date,
          org_code,
          plan_code,
          nvl(sale_amount, 0) sale_amount,
          nvl(sale_comm, 0) sale_comm,
          nvl(pay_amount, 0) pay_amount,
          nvl(pay_comm, 0) pay_comm,
          nvl(pay_center_amount, 0) pay_center_amount,
          nvl(pay_center_comm, 0) pay_center_comm,
          nvl(cancel_amount, 0) cancel_amount,
          nvl(cancel_comm, 0) cancel_comm,
          nvl(lot_sale_amount, 0) lot_sale_amount,
          nvl(lot_sale_comm, 0) lot_sale_comm,
          nvl(lot_pay_amount, 0) lot_pay_amount,
          nvl(lot_pay_comm, 0) lot_pay_comm,
          nvl(lot_pay_center_amount, 0) lot_pay_center_amount,
          nvl(lot_pay_center_comm, 0) lot_pay_center_comm,
          nvl(lot_cancel_amount, 0) lot_cancel_amount,
          nvl(lot_cancel_comm, 0) lot_cancel_comm,
      nvl(lot_cancel_center_amount,0) lot_cancel_center_amount,
      nvl(lot_cancel_center_comm,0) lot_cancel_center_comm
     from pre_detail, time_con)
     select calc_date,
       org_code,
       plan_code,
       (sale_amount + lot_sale_amount) as sale_amount,
       (sale_comm + lot_sale_comm) as sale_comm,
       (cancel_amount + lot_cancel_amount + lot_cancel_center_amount) as cancel_amount,
       (cancel_comm + lot_cancel_comm + lot_cancel_center_comm) as cancel_comm,
       (pay_amount + pay_center_amount + lot_pay_amount + lot_pay_center_amount) as pay_amount,
       (pay_comm + pay_center_comm + lot_pay_comm + lot_pay_center_comm) as pay_comm,
          (sale_amount + lot_sale_amount - sale_comm - lot_sale_comm - pay_amount - lot_pay_amount - pay_comm  - lot_pay_comm - pay_center_amount - lot_pay_center_amount - pay_center_comm - lot_pay_center_comm - cancel_amount - lot_cancel_amount + cancel_comm + lot_cancel_comm - lot_cancel_center_amount + lot_cancel_center_comm) incoming
     from no_null;

   commit;

   -- 3.17.1.1  部门资金报表（institution fund reports）
   insert into his_org_fund_report
      (calc_date,       org_code,
       -- 通用
       be_account_balance,  af_account_balance,     charge,    withdraw,     incoming,  pay_up,
       -- 即开票
       sale,                sale_comm,              paid,      pay_comm,     rtv,       rtv_comm,     center_pay,     center_pay_comm,
       -- 电脑票
       lot_sale,            lot_sale_comm,          lot_paid,  lot_pay_comm, lot_rtv,   lot_rtv_comm, lot_center_pay, lot_center_pay_comm,  lot_center_rtv, lot_center_rtv_comm
       )
   with base as
    (select org_code,
            flow_type,
            sum(amount) as amount,
            sum(be_account_balance) as be_account_balance,
            sum(af_account_balance) as af_account_balance
       from his_agency_fund
       join inf_agencys
      using (agency_code)
      where calc_date = to_char(p_curr_date - 1, 'yyyy-mm-dd')
      group by org_code, flow_type),
   center_pay as
    (select f_get_flow_pay_org(pay_flow) org_code, 24 flow_type, sum(pay_amount) amount
       from flow_pay
      where pay_time >= trunc(p_curr_date) - 1
        and pay_time < trunc(p_curr_date)
        and is_center_paid = 1
      group by f_get_flow_pay_org(pay_flow)),
   center_pay_comm as
    (select org_code, flow_type, sum(change_amount) amount
       from flow_org
      where trade_time >= trunc(p_curr_date) - 1
        and trade_time < trunc(p_curr_date)
        and flow_type in (23,35,36,37,38)
      group by org_code, flow_type),
   agency_balance as
    (select * from (select org_code, be_account_balance, af_account_balance
       from base
      where flow_type = 0)
      unpivot (amount for flow_type in (be_account_balance as 88, af_account_balance as 99))),
   fund as
    (select *
       from (select org_code, flow_type, amount from base
             union all
             select org_code, flow_type, amount from center_pay_comm
             union all
             select org_code, flow_type, amount from agency_balance
             union all
             select org_code, flow_type, amount from center_pay) pivot(sum(amount) for flow_type in(1 as charge,
                                                                   2  as withdraw,
                                                                   5  as sale_comm,
                                                                   6  as pay_comm,
                                                                   7  as sale,
                                                                   8  as paid,
                                                                   11 as rtv,
                                                                   13 as rtv_comm,
                                                                   24 as center_pay,
                                                                   23 as center_pay_comm,
                                                                   45 as lot_sale,
                                                                   43 as lot_sale_comm,
                                                                   41 as lot_paid,
                                                                   44 as lot_pay_comm,
                                                                   42 as lot_rtv,
                                                                   47 as lot_rtv_comm,
                                                                   37 as lot_center_pay,
                                                                   36 as lot_center_pay_comm,
                                                                   38 as lot_center_rtv,
                                                                   35 as lot_center_rtv_comm,
                                                                   88 as be,
                                                                   99 as af))),
   pre_detail as
    (select org_code,
            nvl(be, 0) be_account_balance,
            nvl(charge, 0) charge,
            nvl(withdraw, 0) withdraw,
            nvl(sale, 0) sale,
            nvl(sale_comm, 0) sale_comm,
            nvl(paid, 0) paid,
            nvl(pay_comm, 0) pay_comm,
            nvl(rtv, 0) rtv,
            nvl(rtv_comm, 0) rtv_comm,
            nvl(center_pay, 0) center_pay,
            nvl(center_pay_comm, 0) center_pay_comm,
            nvl(lot_sale, 0) lot_sale,
            nvl(lot_sale_comm, 0) lot_sale_comm,
            nvl(lot_paid, 0) lot_paid,
            nvl(lot_pay_comm, 0) lot_pay_comm,
            nvl(lot_rtv, 0) lot_rtv,
            nvl(lot_rtv_comm, 0) lot_rtv_comm,
            nvl(lot_center_pay, 0) lot_center_pay,
            nvl(lot_center_pay_comm, 0) lot_center_pay_comm,
            nvl(lot_center_rtv, 0) lot_center_rtv,
            (case 2 when (select org_type from inf_orgs where org_code=fund.org_code) then (nvl(lot_center_rtv_comm, 0) - nvl(lot_rtv_comm, 0))  else nvl(lot_center_rtv_comm, 0) end) lot_center_rtv_comm,
            nvl(af, 0) af_account_balance
       from fund),
   will_write as
   (select org_code,
           -- 通用
           be_account_balance, af_account_balance,          charge,          withdraw,
           -- 销售金额-销售佣金-兑奖-兑奖佣金-中心兑奖-中心兑奖佣金+退货佣金-退货金额 -中心退票+中心退票佣金
           (sale - sale_comm - paid - pay_comm - center_pay - center_pay_comm + rtv_comm - rtv
            + lot_sale - lot_sale_comm - lot_paid - lot_pay_comm - lot_center_pay - lot_center_pay_comm - lot_rtv + lot_rtv_comm
            - lot_center_rtv + lot_center_rtv_comm) incoming,
           (charge - withdraw - center_pay - center_pay_comm - lot_center_pay - lot_center_pay_comm  - lot_rtv - lot_rtv_comm - lot_center_rtv - lot_center_rtv_comm) pay_up,
           -- 即开票
           sale,                sale_comm,              paid,      pay_comm,     rtv,       rtv_comm,     center_pay,     center_pay_comm,
           -- 电脑票
           lot_sale,            lot_sale_comm,          lot_paid,  lot_pay_comm, lot_rtv,   lot_rtv_comm, lot_center_pay, lot_center_pay_comm, lot_center_rtv,lot_center_rtv_comm
      from pre_detail)
   select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
          org_code,
          nvl(be_account_balance , 0),   nvl(af_account_balance , 0),   nvl(charge , 0),      nvl(withdraw , 0),          nvl(incoming , 0),    nvl(pay_up , 0),
          nvl(sale , 0),                 nvl(sale_comm , 0),            nvl(paid , 0),        nvl(pay_comm , 0),          nvl(rtv , 0),         nvl(rtv_comm , 0),      nvl(center_pay , 0),     nvl(center_pay_comm , 0),
          nvl(lot_sale , 0),             nvl(lot_sale_comm , 0),        nvl(lot_paid , 0),    nvl(lot_pay_comm , 0),      nvl(lot_rtv , 0),     nvl(lot_rtv_comm , 0),  nvl(lot_center_pay , 0), nvl(lot_center_pay_comm , 0),   nvl(lot_center_rtv , 0),   nvl(lot_center_rtv_comm , 0)
     from will_write right join inf_orgs using (org_code);

    commit;

    if p_maintance_mod = 0 then
       -- 管理员资金日结
       insert into HIS_MM_FUND (calc_date, MARKET_ADMIN, flow_type, amount, be_account_balance, af_account_balance)
         with last_day as
          (select MARKET_ADMIN, af_account_balance be_account_balance
             from his_mm_fund
            where calc_date = to_char(p_curr_date - 2, 'yyyy-mm-dd')
              and flow_type = 0),
         this_day as
          (select MARKET_ADMIN, account_balance af_account_balance
             from acc_mm_account
            where acc_type = 1),
         mm_balance as
          (select MARKET_ADMIN, be_account_balance, 0 as af_account_balance
             from last_day
           union all
           select MARKET_ADMIN, 0 as be_account_balance, af_account_balance
             from this_day),
         mb as
          (select MARKET_ADMIN,
                  sum(be_account_balance) be_account_balance,
                  sum(af_account_balance) af_account_balance
             from mm_balance
            group by MARKET_ADMIN),
         now_fund as
          (select MARKET_ADMIN, flow_type, sum(change_amount) as amount
             from flow_market_manager
            where trade_time >= trunc(p_curr_date - 1)
              and trade_time < trunc(p_curr_date)
            group by MARKET_ADMIN, flow_type)
         select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
                MARKET_ADMIN,
                flow_type,
                amount,
                0 be_account_balance,
                0 af_account_balance
           from now_fund
         union all
         select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
                MARKET_ADMIN,
                0,
                0,
                be_account_balance,
                af_account_balance
           from mb;

      commit;
   end if;

   -- 管理员库存日结
   insert into HIS_MM_INVENTORY (CALC_DATE, MARKET_ADMIN, PLAN_CODE, OPEN_INV, CLOSE_INV, GOT_TICKETS, SALED_TICKETS, CANCELED_TICKETS, RETURN_TICKETS, BROKEN_TICKETS)
      with
      -- 期初
      open_inv as
       (select WAREHOUSE MARKET_ADMIN, PLAN_CODE, sum(TICKETS) open_INV
          from HIS_LOTTERY_INVENTORY
         where CALC_DATE = to_char(trunc(p_curr_date) - 2, 'yyyy-mm-dd')
           and status = 21
         group by WAREHOUSE, PLAN_CODE),
      -- 期末
      close_inv as
       (select WAREHOUSE MARKET_ADMIN, PLAN_CODE, sum(TICKETS) CLOSE_INV
          from HIS_LOTTERY_INVENTORY
         where CALC_DATE = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
           and status = 21
         group by WAREHOUSE, PLAN_CODE),
      -- 收货
      got as
       (select apply_admin, plan_code, sum(detail.tickets) TICKETS
          from SALE_DELIVERY_ORDER mm
          join wh_goods_issue_detail detail
            on (mm.do_no = detail.ref_no)
         where status = 4
           and OUT_DATE >= trunc(p_curr_date - 1)
           and OUT_DATE < trunc(p_curr_date)
         group by apply_admin, plan_code),
      -- 销售
      saled as
       (select AR_ADMIN, plan_code, sum(detail.TICKETS) TICKETS
          from SALE_AGENCY_RECEIPT mm
          join wh_goods_receipt_detail detail
            on (mm.AR_NO = detail.ref_no)
         where AR_DATE >= trunc(p_curr_date - 1)
           and AR_DATE < trunc(p_curr_date)
         group by AR_ADMIN, plan_code),
      -- 退货
      canceled as
       (select AI_MM_ADMIN, plan_code, sum(detail.TICKETS) TICKETS
          from SALE_AGENCY_RETURN mm
          join wh_goods_issue_detail detail
            on (mm.AI_NO = detail.ref_no)
         where Ai_DATE >= trunc(p_curr_date - 1)
           and Ai_DATE < trunc(p_curr_date)
         group by AI_MM_ADMIN, plan_code),
      -- 还货
      returned as
       (select MARKET_MANAGER_ADMIN, plan_code, sum(detail.TICKETS) TICKETS
          from SALE_RETURN_RECODER mm
          join wh_goods_receipt_detail detail
            on (mm.RETURN_NO = detail.ref_no)
         where status = 6
           and RECEIVE_DATE >= trunc(p_curr_date - 1)
           and RECEIVE_DATE < trunc(p_curr_date)
         group by MARKET_MANAGER_ADMIN, plan_code),
      -- 损毁
      broken_detail as
       (select BROKEN_NO,
               plan_code,
               PACKAGES * (select TICKETS_EVERY_PACK
                             from GAME_BATCH_IMPORT_DETAIL
                            where plan_code = tt.plan_code
                              and batch_no = tt.batch_no) tickets
          from WH_BROKEN_RECODER_DETAIL tt),
      broken as
       (select APPLY_ADMIN, plan_code, sum(TICKETS) TICKETS
          from WH_BROKEN_RECODER
          join broken_detail
         using (BROKEN_NO)
         where APPLY_DATE >= trunc(p_curr_date - 1)
           and APPLY_DATE < trunc(p_curr_date)
         group by APPLY_ADMIN, plan_code),
      total_detail as
       (select apply_admin MARKET_ADMIN,
               plan_code,
               0           as open_inv,
               0           as CLOSE_INV,
               TICKETS     GOT_TICKETS,
               0           as SALED_TICKETS,
               0           as canceled_tickets,
               0           as RETURN_TICKETS,
               0           as BROKEN_TICKETS
          from got
        union all
        select AR_ADMIN  MARKET_ADMIN,
               plan_code,
               0         as open_inv,
               0         as CLOSE_INV,
               0         as GOT_TICKETS,
               TICKETS   as SALED_TICKETS,
               0         as canceled_tickets,
               0         as RETURN_TICKETS,
               0         as BROKEN_TICKETS
          from saled
        union all
        select AI_MM_ADMIN MARKET_ADMIN,
               plan_code,
               0           as open_inv,
               0           as CLOSE_INV,
               0           as GOT_TICKETS,
               0           as SALED_TICKETS,
               tickets     as canceled_tickets,
               0           as RETURN_TICKETS,
               0           as BROKEN_TICKETS
          from canceled
        union all
        select MARKET_MANAGER_ADMIN MARKET_ADMIN,
               plan_code,
               0                    as open_inv,
               0                    as CLOSE_INV,
               0                    as GOT_TICKETS,
               0                    as SALED_TICKETS,
               0                    as canceled_tickets,
               TICKETS              as RETURN_TICKETS,
               0                    as BROKEN_TICKETS
          from returned
        union all
        select APPLY_ADMIN MARKET_ADMIN,
               plan_code,
               0           as open_inv,
               0           as CLOSE_INV,
               0           as GOT_TICKETS,
               0           as SALED_TICKETS,
               0           as canceled_tickets,
               0           as RETURN_TICKETS,
               TICKETS     as BROKEN_TICKETS
          from broken
        union all
        select to_number(MARKET_ADMIN) MARKET_ADMIN,
               PLAN_CODE,
               open_inv,
               0 as CLOSE_INV,
               0 as GOT_TICKETS,
               0 as SALED_TICKETS,
               0 as canceled_tickets,
               0 as RETURN_TICKETS,
               0 as BROKEN_TICKETS
          from open_inv
        union all
        select to_number(MARKET_ADMIN) MARKET_ADMIN,
               PLAN_CODE,
               0 as open_inv,
               CLOSE_INV,
               0 as GOT_TICKETS,
               0 as SALED_TICKETS,
               0 as canceled_tickets,
               0 as RETURN_TICKETS,
               0 as BROKEN_TICKETS
          from close_inv),
      total_sum as
       (select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
               MARKET_ADMIN,
               PLAN_CODE,
               sum(open_inv) as open_inv,
               sum(CLOSE_INV) as CLOSE_INV,
               sum(GOT_TICKETS) GOT_TICKETS,
               sum(SALED_TICKETS) as SALED_TICKETS,
               sum(canceled_tickets) as canceled_tickets,
               sum(RETURN_TICKETS) as RETURN_TICKETS,
               sum(BROKEN_TICKETS) as BROKEN_TICKETS
          from total_detail
         group by MARKET_ADMIN, PLAN_CODE)
      -- 限制人员为市场管理员
      select * from total_sum where exists(select 1 from INF_MARKET_ADMIN where MARKET_ADMIN = total_sum.MARKET_ADMIN);

   commit;

   -- 3.17.1.4  部门应缴款报表（Institution Payable Report）
   insert into his_org_fund
     (calc_date, org_code, charge, withdraw, center_paid, center_paid_comm, pay_up)
   with base as
    (select org_code, FLOW_TYPE, sum(AMOUNT) as amount
       from his_agency_fund
       join inf_agencys
      using (agency_code)
      where CALC_DATE = to_char(p_curr_date - 1, 'yyyy-mm-dd')
        and FLOW_TYPE in (1, 2)
        and org_code in (select org_code from inf_orgs where ORG_TYPE = 1)
      group by org_code, FLOW_TYPE),
   center_pay as
    (select org_code, sum(change_amount) amount
       from flow_org
      where TRADE_TIME >= trunc(p_curr_date) - 1
        and TRADE_TIME < trunc(p_curr_date)
        and FLOW_TYPE = eflow_type.org_center_pay
      group by org_code),
   center_pay_comm as
    (select org_code, sum(change_amount) amount
       from flow_org
      where TRADE_TIME >= trunc(p_curr_date) - 1
        and TRADE_TIME < trunc(p_curr_date)
        and FLOW_TYPE = eflow_type.org_center_pay_comm
      group by org_code),
   fund as
    (select *
       from (select org_code, FLOW_TYPE, AMOUNT from base
             union all
             select org_code, 8 FLOW_TYPE, AMOUNT from center_pay
             union all
             select org_code, 21 FLOW_TYPE, AMOUNT from center_pay_comm
            ) pivot(sum(amount) for FLOW_TYPE in(1 as charge, 2 as withdraw, 8 as paid, 21 as paid_comm)))
   select to_char(p_curr_date - 1, 'yyyy-mm-dd') CALC_DATE,
          org_code,nvl(charge, 0) charge,
          nvl(withdraw, 0) withdraw,
          nvl(paid, 0) CENTER_PAID,
          nvl(paid_comm, 0) center_paid_comm,
          (nvl(charge, 0) - nvl(withdraw, 0) - nvl(paid, 0) + nvl(paid_comm, 0)) pay_up
     from inf_orgs left join fund using (org_code);

   commit;

   -- 部门库存日结
   insert into HIS_ORG_INV_REPORT (calc_date, org_code, oper_type, plan_code, amount, tickets)
   with base as (
      -- 调拨出库、站点退货
      select SEND_ORG org_code,wgid.ISSUE_TYPE do_type ,plan_code,sum(amount) amount, sum(tickets) tickets
        from WH_GOODS_ISSUE_DETAIL wgid
        join WH_GOODS_ISSUE wgi
       using (SGI_NO)
       where ISSUE_END_TIME >= trunc(p_curr_date) - 1
         and ISSUE_END_TIME < trunc(p_curr_date)
         and wgid.ISSUE_TYPE in (1,4)
         group by SEND_ORG,wgid.ISSUE_TYPE,plan_code
      union all
      -- 调拨入库，取计划入库数量（需要先找到调拨单，然后找到调拨单对应的出库单，获取实际出库明细）
      select wri.RECEIVE_ORG org_code, 12 do_type,plan_code,sum(wgid.amount) amount, sum(wgid.tickets) tickets
        from WH_GOODS_ISSUE_DETAIL wgid
        join SALE_TRANSFER_BILL stb
          on (wgid.REF_NO = stb.STB_NO)
        join WH_GOODS_receipt wri
          on (wri.REF_NO = stb.STB_NO)
       where receipt_END_TIME >= trunc(p_curr_date) - 1
         and receipt_END_TIME < trunc(p_curr_date)
         and (wri.receipt_TYPE = 2 or (wri.receipt_TYPE = 1 and wri.RECEIVE_ORG = '00'))
         group by wri.RECEIVE_ORG,wri.receipt_TYPE + 10,plan_code
      union all
      -- 站点入库销售
      select RECEIVE_ORG org_code,wgid.receipt_TYPE + 10 do_type,plan_code,sum(amount) amount, sum(tickets) tickets
        from WH_GOODS_receipt_DETAIL wgid
        join WH_GOODS_receipt wgi
       using (SGR_NO)
       where receipt_END_TIME >= trunc(p_curr_date) - 1
         and receipt_END_TIME < trunc(p_curr_date)
         and wgid.receipt_TYPE = 4
         group by RECEIVE_ORG,wgid.receipt_TYPE + 10,plan_code
      union all
      -- 损毁
      select f_get_admin_org(APPLY_ADMIN) org_code, 20 do_type,PLAN_CODE,
             sum(amount) amount, sum(WH_BROKEN_RECODER_DETAIL.packages) * 100
        from WH_BROKEN_RECODER join WH_BROKEN_RECODER_DETAIL using(BROKEN_NO)
       where APPLY_DATE >= trunc(p_curr_date) - 1
         and APPLY_DATE < trunc(p_curr_date)
       group by f_get_admin_org(APPLY_ADMIN),PLAN_CODE
      union all
      -- 期初库存
      select substr(WAREHOUSE,1,2) org_code,88 do_type,PLAN_CODE,sum(AMOUNT) AMOUNT,sum(TICKETS) TICKETS
        from HIS_LOTTERY_INVENTORY
       where calc_date = to_char(trunc(p_curr_date) - 2, 'yyyy-mm-dd')
         and STATUS = 11
       group by substr(WAREHOUSE,1,2),PLAN_CODE
      union all
      -- 期末库存
      select substr(WAREHOUSE,1,2) org_code,99 do_type,PLAN_CODE,sum(AMOUNT) AMOUNT,sum(TICKETS) TICKETS
        from HIS_LOTTERY_INVENTORY
       where calc_date = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
         and STATUS = 11
       group by substr(WAREHOUSE,1,2),PLAN_CODE
      union all
      select f_get_admin_org(market_admin) org, 66 do_type, PLAN_CODE,
             sum(OPEN_INV) * (select TICKET_AMOUNT from game_plans where plan_code = tt.plan_code),
             sum(OPEN_INV)
        from his_mm_inventory tt
       where calc_date = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
       group by f_get_admin_org(market_admin),plan_code
       union all
       select f_get_admin_org(market_admin) org, 77 do_type, PLAN_CODE,
              sum(CLOSE_INV) * (select TICKET_AMOUNT from game_plans where plan_code = tt.plan_code),
              sum(CLOSE_INV)
        from his_mm_inventory tt
       where calc_date = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
       group by f_get_admin_org(market_admin),plan_code
      )
   select to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd'), org_code, do_type, PLAN_CODE,amount, tickets
     from base;

   commit;

   if p_maintance_mod = 0 then
      -- 代理商资金报表（Agent Fund Report）
      insert into his_agent_fund_report (calc_date, org_code, flow_type, amount)
      with
         agent_org as (
            select org_code from inf_orgs where org_type = 2),
         base as (
            select org_code, flow_type, sum(change_amount) amount
              from flow_org
             where trade_time >= trunc(p_curr_date) - 1
               and trade_time < trunc(p_curr_date)
               and org_code in (select org_code from agent_org)
             group by org_code, flow_type),
         last_day as (
            select org_code, 88 as flow_type, amount
              from his_agent_fund_report
             where org_code in (select org_code from agent_org)
               and flow_type = 99
               and calc_date = to_char(trunc(p_curr_date) - 2, 'yyyy-mm-dd')),
         today as (
            select org_code, 99 as flow_type, account_balance amount
              from acc_org_account
             where org_code in (select org_code from agent_org)),
         plus_result as (
            select org_code, flow_type, amount from base
            union all
            select org_code, flow_type, amount from last_day
            union all
            select org_code, flow_type, amount from today)
      select to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd'), org_code, flow_type, amount
        from plus_result;

      commit;
   end if;

  -- 销售、退票和兑奖统计
  insert into his_sale_pay_cancel
    (sale_date, sale_month, area_code, org_code, plan_code, sale_amount, sale_comm, cancel_amount, cancel_comm, pay_amount, pay_comm, incoming)
  -- 即开票
  with sale as
   (select to_char(sale_time, 'yyyy-mm-dd') sale_day,
           to_char(sale_time, 'yyyy-mm') sale_month,
           area_code,
           org_code,
           f_get_old_plan_name(plan_code, batch_no) plan_code,
           sum(sale_amount) sale_amount,
           sum(comm_amount) as sale_comm
      from flow_sale
     where sale_time >= trunc(p_curr_date) - 1
       and sale_time <  trunc(p_curr_date)
     group by area_code,
              org_code,
              f_get_old_plan_name(plan_code, batch_no),
              to_char(sale_time, 'yyyy-mm-dd'),
              to_char(sale_time, 'yyyy-mm')),
  cancel as
   (select to_char(cancel_time, 'yyyy-mm-dd') sale_day,
           to_char(cancel_time, 'yyyy-mm') sale_month,
           area_code,
           org_code,
           f_get_old_plan_name(plan_code, batch_no) plan_code,
           sum(sale_amount) cancel_amount,
           sum(comm_amount) as cancel_comm
      from flow_cancel
     where cancel_time >= trunc(p_curr_date) - 1
       and cancel_time <  trunc(p_curr_date)
     group by area_code,
              org_code,
              f_get_old_plan_name(plan_code, batch_no),
              to_char(cancel_time, 'yyyy-mm-dd'),
              to_char(cancel_time, 'yyyy-mm')),
  pay_detail as
   (select to_char(pay_time, 'yyyy-mm-dd') sale_day,
           to_char(pay_time, 'yyyy-mm') sale_month,
           area_code,
           f_get_flow_pay_org(pay_flow) org_code,
           f_get_old_plan_name(plan_code, batch_no) plan_code,
           pay_amount,
           nvl(comm_amount, 0) comm_amount
      from flow_pay
     where pay_time >= trunc(p_curr_date) - 1
       and pay_time <  trunc(p_curr_date) ),
  pay as
   (select sale_day,
           sale_month,
           area_code,
           org_code,
           plan_code,
           sum(pay_amount) pay_amount,
           sum(comm_amount) as pay_comm
      from pay_detail
     group by sale_day, sale_month, area_code, org_code, plan_code),
  pre_detail as (
     select sale_day, sale_month, area_code, org_code, plan_code, sale_amount, sale_comm, 0 as cancel_amount, 0 as cancel_comm, 0 as pay_amount, 0 as pay_comm from sale
      union all
     select sale_day, sale_month, area_code, org_code, plan_code, 0 as sale_amount, 0 as sale_comm, cancel_amount, cancel_comm, 0 as pay_amount, 0 as pay_comm from cancel
      union all
     select sale_day, sale_month, area_code, org_code, plan_code, 0 as sale_amount, 0 as sale_comm, 0 as cancel_amount, 0 as cancel_comm, pay_amount, pay_comm from pay
  ),
  -- 电脑票
  lot_sale as
   (select to_char(SALETIME, 'yyyy-mm-dd') sale_day,
           to_char(SALETIME, 'yyyy-mm') sale_month,
           area_code,
           org_code,
           f_get_game_name(game_code) plan_code,
           sum(TICKET_AMOUNT) lot_sale_amount,
           sum(COMMISSIONAMOUNT) as lot_sale_comm
      from his_sellticket join inf_agencys
        on his_sellticket.agency_code=inf_agencys.agency_code
        and SALETIME >= trunc(p_curr_date) - 1
        and SALETIME <  trunc(p_curr_date) 
        group by area_code,
              org_code,
              f_get_game_name(game_code),
              to_char(SALETIME, 'yyyy-mm-dd'),
              to_char(SALETIME, 'yyyy-mm')),
  lot_cancel as
   (select to_char(CANCELTIME, 'yyyy-mm-dd') sale_day,
           to_char(CANCELTIME, 'yyyy-mm') sale_month,
       f_get_agency_area(his_cancelticket.applyflow_sell) area_code,
           org_code,
           f_get_game_name(game_code) plan_code,
           sum(TICKET_AMOUNT) lot_cancel_amount,
           sum(COMMISSIONAMOUNT) as lot_cancel_comm
      from his_cancelticket join his_sellticket
        on his_cancelticket.applyflow_sell=his_sellticket.applyflow_sell
        and  CANCELTIME >= trunc(p_curr_date) - 1
        and CANCELTIME <  trunc(p_curr_date) 
        group by f_get_agency_area(his_cancelticket.applyflow_sell),
              org_code,
              f_get_game_name(game_code),
              to_char(CANCELTIME, 'yyyy-mm-dd'),
              to_char(CANCELTIME, 'yyyy-mm')),    
  lot_pay as
   (select to_char(PAYTIME, 'yyyy-mm-dd') sale_day,
           to_char(PAYTIME, 'yyyy-mm') sale_month,
           f_get_agency_area(applyflow_sell) area_code,
           org_code,
           f_get_game_name(game_code) plan_code,
           sum(winningamount) lot_pay_amount,
           sum(commissionamount) lot_pay_comm
      from his_payticket
     where PAYTIME >= trunc(p_curr_date) - 1
       and PAYTIME <  trunc(p_curr_date)
     group by to_char(PAYTIME, 'yyyy-mm-dd'),
              to_char(PAYTIME, 'yyyy-mm'),
              f_get_agency_area(applyflow_sell),
              org_code,
              f_get_game_name(game_code)),
  lot_pre_detail as (
     select sale_day, sale_month, area_code, org_code, plan_code, lot_sale_amount, lot_sale_comm, 0 as lot_cancel_amount, 0 as lot_cancel_comm, 0 as lot_pay_amount, 0 as lot_pay_comm from lot_sale
      union all
     select sale_day, sale_month, area_code, org_code, plan_code, 0 as lot_sale_amount, 0 as lot_sale_comm, lot_cancel_amount, lot_cancel_comm, 0 as lot_pay_amount, 0 as lot_pay_comm from lot_cancel
      union all
     select sale_day, sale_month, area_code, org_code, plan_code, 0 as lot_sale_amount, 0 as lot_sale_comm, 0 as lot_cancel_amount, 0 as lot_cancel_comm, lot_pay_amount, lot_pay_comm from lot_pay
  )
  --计开票
  select sale_day, sale_month, nvl(area_code, 'NONE') area_code, org_code, plan_code,
         nvl(sum(sale_amount), 0) sale_amount,
         nvl(sum(sale_comm), 0) sale_comm,
         nvl(sum(cancel_amount), 0) cancel_amount,
         nvl(sum(cancel_comm), 0) cancel_comm,
         nvl(sum(pay_amount), 0) pay_amount,
         nvl(sum(pay_comm), 0) pay_comm,
         (nvl(sum(sale_amount), 0) - nvl(sum(sale_comm), 0) - nvl(sum(pay_amount), 0) - nvl(sum(pay_comm), 0) - nvl(sum(cancel_amount), 0) + nvl(sum(cancel_comm), 0)) incoming
    from pre_detail
   group by sale_day, sale_month, area_code, org_code, plan_code
  union all
  --电脑票
  select sale_day, sale_month, nvl(area_code, 'NONE') area_code, org_code, to_char(plan_code),
         nvl(sum(lot_sale_amount), 0) sale_amount,
         nvl(sum(lot_sale_comm), 0) sale_comm,
         nvl(sum(lot_cancel_amount), 0) cancel_amount,
         nvl(sum(lot_cancel_comm), 0) cancel_comm,
         nvl(sum(lot_pay_amount), 0) pay_amount,
         nvl(sum(lot_pay_comm), 0) pay_comm,
         (nvl(sum(lot_sale_amount), 0) - nvl(sum(lot_sale_comm), 0) - nvl(sum(lot_pay_amount), 0) - nvl(sum(lot_pay_comm), 0) - nvl(sum(lot_cancel_amount), 0) + nvl(sum(lot_cancel_comm), 0)) incoming
    from lot_pre_detail
   group by sale_day, sale_month, area_code, org_code, plan_code;
  
  commit;

  insert into his_pay_level
    (sale_date, sale_month, org_code, plan_code, level_1, level_2, level_3, level_4, level_5, level_6, level_7, level_8, level_other, total)
  with
  pay_detail as
     (select to_char(pay_time, 'yyyy-mm-dd') sale_day,
             to_char(pay_time, 'yyyy-mm') sale_month,
             f_get_old_plan_name(plan_code,batch_no) plan_code,
             (case when reward_no = 1 then pay_amount else 0 end) level_1,
             (case when reward_no = 2 then pay_amount else 0 end) level_2,
             (case when reward_no = 3 then pay_amount else 0 end) level_3,
             (case when reward_no = 4 then pay_amount else 0 end) level_4,
             (case when reward_no = 5 then pay_amount else 0 end) level_5,
             (case when reward_no = 6 then pay_amount else 0 end) level_6,
             (case when reward_no = 7 then pay_amount else 0 end) level_7,
             (case when reward_no = 8 then pay_amount else 0 end) level_8,
             (case when reward_no in (9,10,11,12,13) then pay_amount else 0 end) level_other,
             pay_amount,
             f_get_flow_pay_org(pay_flow) org_code
        from flow_pay
     where pay_time >= trunc(p_curr_date) - 1
       and pay_time <  trunc(p_curr_date))
  select sale_day,
         sale_month,
         org_code,
         plan_code,
         sum(level_1) as level_1,
         sum(level_2) as level_2,
         sum(level_3) as level_3,
         sum(level_4) as level_4,
         sum(level_5) as level_5,
         sum(level_6) as level_6,
         sum(level_7) as level_7,
         sum(level_8) as level_8,
         sum(level_other) as level_other,
         sum(pay_amount) as total
    from pay_detail
   group by sale_day,
            sale_month,
            org_code,
            plan_code;
  commit;

end;
 
/ 
prompt 正在建立[PROCEDURE -> p_time_gen_by_hour.sql ]...... 
create or replace procedure p_time_gen_by_hour
/****************************************************************/
   ------------------- 仅用于统计数据（以当前时间为结束时间，统计上一个间隔的时间） -------------------
   ---- add by 陈震: 2015/10/14
   /*************************************************************/
is
   v_start_time         date;                -- 统计开始时间
   v_end_time           date;                -- 统计结束时间
   v_now_seq            number(10);          -- 当前的序列号

   v_step_minutes       number(10);          -- 统计间隔时间（分钟）

begin
   v_step_minutes := 5;

   -- 计算统计开始时间和结束时间
   v_end_time := sysdate;
   v_start_time := sysdate - v_step_minutes / 24 / 60;
   v_now_seq := to_number(to_char(v_end_time, 'hh24')) * 60 / v_step_minutes + trunc(to_number(to_char(v_end_time, 'mi')) / v_step_minutes) + 1;

   -- 按小时统计销量
   insert into his_sale_hour
      (calc_date, calc_time, plan_code, org_code, sale_amount, cancel_amount, pay_amount,day_sale_amount,day_cancel_amount,day_pay_amount)
   with time_con as
    (select v_start_time s_time,
            v_end_time e_time,
            trunc(sysdate) this_day
       from dual),
   /**  时段统计值  **/
   sale_stat as
    (select plan_code, org_code, sum(sale_amount) sale_amount
       from flow_sale, time_con
      where sale_time >= s_time
        and sale_time < e_time
      group by plan_code, org_code
     union all
     -- 电脑票
     select to_char(game_code), org_code, sum(TICKET_AMOUNT)
       from his_sellticket
       join time_con on (1=1)
       join inf_agencys using(agency_code)
      where SALETIME >= s_time
        and SALETIME < e_time
      group by game_code, org_code
     ),
   cancel_stat as
    (select plan_code, org_code, sum(sale_amount) cancel_amount
       from flow_cancel, time_con
      where cancel_time >= s_time
        and cancel_time < e_time
      group by plan_code, org_code
     union all
     -- 电脑票
     select to_char(game_code), org_code, sum(ticket_amount)
       from his_cancelticket
       join time_con on (1=1)
       join his_sellticket using(applyflow_sell)
      where canceltime >= s_time
        and canceltime < e_time
      group by game_code, org_code
     ),
   pay_detail as
    (select plan_code,
            f_get_flow_pay_org(pay_flow) org_code,
            pay_amount
       from flow_pay, time_con
      where pay_time >= s_time
        and pay_time < e_time),
   pay_stat as
    (select plan_code, org_code, sum(pay_amount) pay_amount
       from pay_detail
      group by plan_code, org_code
     union all
     -- 电脑票
     select to_char(game_code), org_code, sum(winningamounttax)
       from HIS_PAYTICKET, time_con
      where PAYTIME >= s_time
        and PAYTIME < e_time
      group by game_code, org_code
     ),
   /**  时段累计值  **/
   day_sale_stat as
    (select plan_code, org_code, sum(sale_amount) day_sale_amount
       from flow_sale, time_con
      where sale_time >= this_day
        and sale_time < e_time
      group by plan_code, org_code
     union all
     -- 电脑票
     select to_char(game_code), org_code, sum(TICKET_AMOUNT)
       from his_sellticket
       join time_con on (1=1)
       join inf_agencys using(agency_code)
      where SALETIME >= this_day
        and SALETIME < e_time
      group by game_code, org_code
     ),
   day_cancel_stat as
    (select plan_code, org_code, sum(sale_amount) day_cancel_amount
       from flow_cancel, time_con
      where cancel_time >= this_day
        and cancel_time < e_time
      group by plan_code, org_code
     union all
     -- 电脑票
     select to_char(game_code), org_code, sum(ticket_amount)
       from his_cancelticket
       join time_con on (1=1)
       join his_sellticket using(applyflow_sell)
      where canceltime >= this_day
        and canceltime < e_time
      group by game_code, org_code
    ),
   day_pay_detail as
    (select plan_code,
            f_get_flow_pay_org(pay_flow) org_code,
            pay_amount
       from flow_pay, time_con
      where pay_time >= this_day
        and pay_time < e_time),
   day_pay_stat as
    (select plan_code, org_code, sum(pay_amount) day_pay_amount
       from day_pay_detail
      group by plan_code, org_code
     union all
     -- 电脑票
     select to_char(game_code), org_code, sum(winningamounttax)
       from HIS_PAYTICKET, time_con
      where PAYTIME >= this_day
        and PAYTIME < e_time
      group by game_code, org_code
    ),
   hour_detail as
     (select plan_code, org_code, sale_amount, 0 as cancel_amount, 0 as pay_amount, 0 as day_sale_amount, 0 as day_cancel_amount, 0 as day_pay_amount
        from sale_stat
      union all
      select plan_code, org_code, 0 as sale_amount, cancel_amount, 0 as pay_amount, 0 as day_sale_amount, 0 as day_cancel_amount, 0 as day_pay_amount
        from cancel_stat
      union all
      select plan_code, org_code, 0 as sale_amount, 0 as cancel_amount, pay_amount, 0 as day_sale_amount, 0 as day_cancel_amount, 0 as day_pay_amount
        from pay_stat
      union all
      select plan_code, org_code, 0 as sale_amount, 0 as cancel_amount, 0 as pay_amount, day_sale_amount, 0 as day_cancel_amount, 0 as day_pay_amount
        from day_sale_stat
      union all
      select plan_code, org_code, 0 as sale_amount, 0 as cancel_amount, 0 as pay_amount, 0 as day_sale_amount, day_cancel_amount, 0 as day_pay_amount
        from day_cancel_stat
      union all
      select plan_code, org_code, 0 as sale_amount, 0 as cancel_amount, 0 as pay_amount, 0 as day_sale_amount, 0 as day_cancel_amount, day_pay_amount
        from day_pay_stat),
   hour_stats as
     (select plan_code, org_code,
             sum(sale_amount) as sale_amount, sum(cancel_amount) as cancel_amount, sum(pay_amount) as pay_amount,
             sum(day_sale_amount) as day_sale_amount, sum(day_cancel_amount) as day_cancel_amount, sum(day_pay_amount) as day_pay_amount
        from hour_detail
       group by plan_code, org_code)
   select to_char(e_time,'yyyy-mm-dd'), v_now_seq, plan_code, org_code,
          nvl(sale_amount, 0) as sale_amount, nvl(cancel_amount, 0) as cancel_amount, nvl(pay_amount, 0) as pay_amount,
          nvl(day_sale_amount, 0) as day_sale_amount, nvl(day_cancel_amount, 0) as day_cancel_amount, nvl(day_pay_amount, 0) as day_pay_amount
     from time_con, hour_stats;

   commit;

   -- 按小时统计销售站排行
   insert into his_sale_hour_agency
      (calc_date, calc_time, plan_code, agency_code, area_code, sale_amount, cancel_amount, pay_amount, day_sale_amount, day_cancel_amount, day_pay_amount)
   with time_con as
    (select v_start_time s_time,
            v_end_time e_time,
            trunc(sysdate) this_day
       from dual),
   /**  时段统计值  **/
   sale_stat as
    (select plan_code, agency_code, sum(sale_amount) sale_amount
       from flow_sale, time_con
      where sale_time >= s_time
        and sale_time < e_time
      group by plan_code, agency_code
     union all
     -- 电脑票
     select to_char(game_code), agency_code, sum(TICKET_AMOUNT)
       from his_sellticket, time_con
      where SALETIME >= s_time
        and SALETIME < e_time
      group by game_code, agency_code
     ),
   cancel_stat as
    (select plan_code, agency_code, sum(sale_amount) cancel_amount
       from flow_cancel, time_con
      where cancel_time >= s_time
        and cancel_time < e_time
      group by plan_code, agency_code
     union all
     -- 电脑票
     select to_char(game_code), his_cancelticket.agency_code, sum(ticket_amount)
       from his_cancelticket
       join time_con on (1=1)
       join his_sellticket using(applyflow_sell)
      where his_cancelticket.is_center = 0
	    and canceltime >= s_time
        and canceltime < e_time
      group by game_code, his_cancelticket.agency_code
     ),
   pay_stat as
    (select plan_code, pay_agency as agency_code, sum(pay_amount) pay_amount
       from flow_pay, time_con
      where is_center_paid = 3
	    and pay_time >= s_time
        and pay_time < e_time
        and pay_agency is not null
      group by plan_code, pay_agency
     union all
     -- 电脑票
     select to_char(game_code), agency_code, sum(winningamounttax)
       from HIS_PAYTICKET, time_con
      where is_center = 0
	    and PAYTIME >= s_time
        and PAYTIME < e_time
      group by game_code, agency_code
     ),
   /**  时段累计值  **/
   day_sale_stat as
    (select plan_code, agency_code, sum(sale_amount) day_sale_amount
       from flow_sale, time_con
      where sale_time >= this_day
        and sale_time < e_time
      group by plan_code, agency_code
     union all
     -- 电脑票
     select to_char(game_code), agency_code, sum(TICKET_AMOUNT)
       from his_sellticket, time_con
      where SALETIME >= this_day
        and SALETIME < e_time
      group by game_code, agency_code
     ),
   day_cancel_stat as
    (select plan_code, agency_code, sum(sale_amount) day_cancel_amount
       from flow_cancel, time_con
      where cancel_time >= this_day
        and cancel_time < e_time
      group by plan_code, agency_code
     union all
     -- 电脑票
     select to_char(game_code), his_cancelticket.agency_code, sum(ticket_amount)
       from his_cancelticket
       join time_con on (1=1)
       join his_sellticket using(applyflow_sell)
      where his_cancelticket.is_center = 0
	    and canceltime >= s_time
        and canceltime < e_time
      group by game_code, his_cancelticket.agency_code
     ),
   day_pay_stat as
    (select plan_code, pay_agency as agency_code, sum(pay_amount) day_pay_amount
       from flow_pay, time_con
      where is_center_paid = 3
	    and pay_time >= this_day
        and pay_time < e_time
        and pay_agency is not null
      group by plan_code, pay_agency
     union all
     -- 电脑票
     select to_char(game_code), agency_code, sum(winningamounttax)
       from HIS_PAYTICKET, time_con
      where is_center = 0
	    and PAYTIME >= s_time
        and PAYTIME < e_time
      group by game_code, agency_code
     ),
   hour_detail as
     (select plan_code, agency_code, sale_amount, 0 as cancel_amount, 0 as pay_amount, 0 as day_sale_amount, 0 as day_cancel_amount, 0 as day_pay_amount
        from sale_stat
      union all
      select plan_code, agency_code, 0 as sale_amount, cancel_amount, 0 as pay_amount, 0 as day_sale_amount, 0 as day_cancel_amount, 0 as day_pay_amount
        from cancel_stat
      union all
      select plan_code, agency_code, 0 as sale_amount, 0 as cancel_amount, pay_amount, 0 as day_sale_amount, 0 as day_cancel_amount, 0 as day_pay_amount
        from pay_stat
      union all
      select plan_code, agency_code, 0 as sale_amount, 0 as cancel_amount, 0 as pay_amount, day_sale_amount, 0 as day_cancel_amount, 0 as day_pay_amount
        from day_sale_stat
      union all
      select plan_code, agency_code, 0 as sale_amount, 0 as cancel_amount, 0 as pay_amount, 0 as day_sale_amount, day_cancel_amount, 0 as day_pay_amount
        from day_cancel_stat
      union all
      select plan_code, agency_code, 0 as sale_amount, 0 as cancel_amount, 0 as pay_amount, 0 as day_sale_amount, 0 as day_cancel_amount, day_pay_amount
        from day_pay_stat),
   hour_stats as
     (select plan_code, agency_code,
             sum(sale_amount) as sale_amount, sum(cancel_amount) as cancel_amount, sum(pay_amount) as pay_amount,
             sum(day_sale_amount) as day_sale_amount, sum(day_cancel_amount) as day_cancel_amount, sum(day_pay_amount) as day_pay_amount
        from hour_detail
       group by plan_code, agency_code)
   select to_char(e_time,'yyyy-mm-dd'), v_now_seq, plan_code, agency_code, (select area_code from inf_agencys where agency_code = hour_stats.agency_code) as area_code,
          nvl(sale_amount, 0) as sale_amount, nvl(cancel_amount, 0) as cancel_amount, nvl(pay_amount, 0) as pay_amount,
          nvl(day_sale_amount, 0) as day_sale_amount, nvl(day_cancel_amount, 0) as day_cancel_amount, nvl(day_pay_amount, 0) as day_pay_amount
     from time_con, hour_stats;
	commit;

    insert into his_terminal_online (
	 CALC_DATE,  CALC_TIME,  ORG_CODE,  ORG_NAME,  TOTAL_COUNT,  ONLINE_COUNT)
    select to_char(v_end_time,'yyyy-mm-dd'),v_now_seq,org_code,org_name,count(*),sum(is_logging) cnt
     from saler_terminal join inf_agencys using(agency_code) join inf_orgs using(org_code)
    where saler_terminal.status = 1 and org_code<>'00' group by org_code,org_name;
    commit;

end; 
/ 
prompt 正在建立[PROCEDURE -> p_time_lot_promotion.sql ]...... 
create or replace procedure p_time_lot_promotion (
   p_curr_date       date        default sysdate
)
/****************************************************************/
-------- 电脑票按月进行佣金奖励（每月1日0点执行） ----
---- 站点销售电脑票佣金设置：初始新建站点后电脑票销售佣金比例为7%；
---- 电脑票月销售额在1200万瑞尔（含1200万）以下，销售佣金为全部销售额的7%；
---- 电脑票月销售额在1200万—2400万瑞尔的，销售佣金为全部销售额的8%；
---- 电脑票月销售额在2400万以上的，销售佣金为全部销售额的9%；
---- 每日电脑票佣金均按7%计算统计，当截止到每月的最后一天，结算这一月的销售佣金；
---- 例，电脑票月销售额：2500万瑞尔，月末这一天所获佣金=7%*当天的销售额+2500*（8%-7%）

---- add by 陈震: 2016-05-21
--- modify by kwx: 2016-08-02 佣金比例为零时不结算
/****************************************************************/
is
  -- 加减钱的操作
  v_out_balance           number(28);                   -- 传出的销售站余额
  v_temp_balance          number(28);                   -- 临时金额
  v_sale_commission_rate  AUTH_AGENCY.SALE_COMMISSION_RATE%type;   --临时销售佣金比例
begin

  for tab in (select sale_agency, game_code, sum(pure_amount) amount from sub_sell where sale_month = to_char(p_curr_date - 1, 'yyyy-mm') group by sale_agency, game_code having sum(pure_amount) >= 1200*10000) loop
    
	select SALE_COMMISSION_RATE into  v_sale_commission_rate from AUTH_AGENCY where agency_code=tab.sale_agency and game_code=tab.game_code;

    if v_sale_commission_rate > 0 then
      if tab.amount >= 2400 * 10000 then
        p_agency_fund_change(tab.sale_agency, eflow_type.lottery_sale_comm, (tab.amount * 0.02), 0, 0, v_out_balance, v_temp_balance);
        continue;
      end if;

      p_agency_fund_change(tab.sale_agency, eflow_type.lottery_sale_comm, (tab.amount * 0.01), 0, 0, v_out_balance, v_temp_balance);
    end if;
  end loop;

  commit;
end; 
/ 
prompt 正在建立[PROCEDURE -> p_warehouse_check_step1.sql ]...... 
CREATE OR REPLACE PROCEDURE p_warehouse_check_step1
/****************************************************************/
  ------------------- 适用于仓库盘点-------------------
  ----盘点第一步：新建盘点单
  ----add by dzg: 2015-9-25
  ----业务流程：当仓库正在盘点时，不能盘点，盘点时生成当前库房实际量
  ----检查发现问题：数据中包含重复数据，没有检测盒子和箱等的包容关系
  ----更新仓库状态盘点中...
  ----更新本地没有盒签......modify by dzg 2016-01-16 in pp
  ----2016/3/18 修改新建盘点单默认值为有差异

  /*************************************************************/
(
 --------------输入----------------
 p_warehouse_opr  IN NUMBER, --盘点人
 p_check_name     IN STRING, --盘点方案名称
 p_warehouse_code IN STRING, --库房编码
 p_plan_code      IN STRING, --盘点方案（可选）
 p_batch_code     IN STRING, --盘点批次（可选）

 ---------出口参数---------
 c_check_code OUT STRING, --返回盘点单编号
 c_errorcode  OUT NUMBER, --错误编码
 c_errormesg  OUT STRING --错误原因

 ) IS

  v_count_temp NUMBER := 0; --临时变量
  v_count_tick NUMBER := 0; --存放临时库存总量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --名称不能为空
  IF ((p_check_name IS NULL) OR length(p_check_name) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_warehouse_check_step1_1;
    RETURN;
  END IF;

  --库房不能为空
  IF ((p_warehouse_code IS NULL) OR length(p_warehouse_code) <= 0) THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_warehouse_check_step1_2;
    RETURN;
  END IF;

  --盘点人无效
  v_count_temp := 0;
  SELECT count(o.admin_id)
    INTO v_count_temp
    FROM adm_info o
   WHERE o.admin_id = p_warehouse_opr
     AND o.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 3;
    c_errormesg := error_msg.err_p_warehouse_check_step1_3;
    RETURN;
  END IF;

  --仓库无效或者正在盘点中
  v_count_temp := 0;
  SELECT count(o.warehouse_code)
    INTO v_count_temp
    FROM wh_info o
   WHERE o.warehouse_code = p_warehouse_code
     AND o.status = ewarehouse_status.working;

  IF v_count_temp <= 0 THEN
    c_errorcode := 4;
    c_errormesg := error_msg.err_p_warehouse_check_step1_4;
    RETURN;
  END IF;

  --仓库无任何相关物品没有必要盘点
  v_count_temp := 0;

  ---箱检测
  --如下的业务逻辑，基于有批次一定有方案的业务关系
  IF ((p_batch_code IS NOT NULL) OR length(p_batch_code) > 0) THEN
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_trunk o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse
       AND o.plan_code = p_plan_code
       AND o.batch_no = p_batch_code;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;

  ELSIF ((p_plan_code IS NOT NULL) OR length(p_plan_code) > 0) THEN
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_trunk o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse
       AND o.plan_code = p_plan_code;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;
  ELSE
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_trunk o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;
  END IF;

  ---盒子检测
  --如下的业务逻辑，基于有批次一定有方案的业务关系
  IF ((p_batch_code IS NOT NULL) OR length(p_batch_code) > 0) THEN
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_box o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse
       AND o.plan_code = p_plan_code
       AND o.batch_no = p_batch_code;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;

  ELSIF ((p_plan_code IS NOT NULL) OR length(p_plan_code) > 0) THEN
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_box o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse
       AND o.plan_code = p_plan_code;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;
  ELSE
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_box o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;
  END IF;

  ---本检测
  --如下的业务逻辑，基于有批次一定有方案的业务关系
  IF ((p_batch_code IS NOT NULL) OR length(p_batch_code) > 0) THEN
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_package o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse
       AND o.plan_code = p_plan_code
       AND o.batch_no = p_batch_code;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;

  ELSIF ((p_plan_code IS NOT NULL) OR length(p_plan_code) > 0) THEN
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_package o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse
       AND o.plan_code = p_plan_code;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;
  ELSE
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_package o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;
  END IF;

  IF v_count_tick <= 0 THEN
    c_errorcode := 5;
    c_errormesg := error_msg.err_p_warehouse_check_step1_5;
    RETURN;
  END IF;

  /*----------- 插入数据  -----------------*/
  --插入基本信息
  c_check_code := f_get_wh_check_point_seq();

  insert into wh_check_point
    (cp_no,
     warehouse_code,
     cp_name,
     plan_code,
     batch_no,
     status,
     result,
     nomatch_tickets,
     nomatch_amount,
     cp_admin,
     cp_date,
     remark)
  values
    (c_check_code,
     p_warehouse_code,
     p_check_name,
     p_plan_code,
     p_batch_code,
     ecp_status.working,
     ecp_result.less,
     0,
     0,
     p_warehouse_opr,
     sysdate,
     '--');

  --插入盘点前记录
  ---箱
  --同检测一样依赖条件
  IF ((p_batch_code IS NOT NULL) OR length(p_batch_code) > 0) THEN

    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.trunk,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             '-',
             '-',
             d.packs_every_trunk,
             d.tickets_every_pack * d.packs_every_trunk * g.ticket_amount
        FROM wh_ticket_trunk o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND o.status = eticket_status.in_warehouse
         AND o.plan_code = p_plan_code
         AND o.batch_no = p_batch_code;

  ELSIF ((p_plan_code IS NOT NULL) OR length(p_plan_code) > 0) THEN
    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.trunk,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             '-',
             '-',
             d.packs_every_trunk,
             d.tickets_every_pack * d.packs_every_trunk * g.ticket_amount
        FROM wh_ticket_trunk o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND o.status = eticket_status.in_warehouse
         AND o.plan_code = p_plan_code;

  ELSE
    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.trunk,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             '-',
             '-',
             d.packs_every_trunk,
             d.tickets_every_pack * d.packs_every_trunk * g.ticket_amount
        FROM wh_ticket_trunk o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND o.status = eticket_status.in_warehouse;
  END IF;

  ---盒子检测
  IF ((p_batch_code IS NOT NULL) OR length(p_batch_code) > 0) THEN

    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.pack,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             o.box_no,
             p.package_no,
             1,
             d.tickets_every_pack * g.ticket_amount
        FROM wh_ticket_box o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
        Left Join wh_ticket_trunk t
          on (o.plan_code = t.plan_code and o.batch_no = t.batch_no and
             t.trunk_no = o.trunk_no)
        left join wh_ticket_package p
          on (o.plan_code = p.plan_code and o.batch_no = p.batch_no and
           o.box_no = p.box_no)
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND o.status = eticket_status.in_warehouse
         AND t.is_full = eboolean.noordisabled
         AND o.plan_code = p_plan_code
         AND o.batch_no = p_batch_code;

  ELSIF ((p_plan_code IS NOT NULL) OR length(p_plan_code) > 0) THEN
    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.pack,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             o.box_no,
             p.package_no,
             1,
             d.tickets_every_pack * g.ticket_amount
        FROM wh_ticket_box o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
        Left Join wh_ticket_trunk t
          on (o.plan_code = t.plan_code and o.batch_no = t.batch_no and
             t.trunk_no = o.trunk_no)
        left join wh_ticket_package p
          on (o.plan_code = p.plan_code and o.batch_no = p.batch_no and
           o.box_no = p.box_no)
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND t.is_full = eboolean.noordisabled
         AND o.status = eticket_status.in_warehouse
         AND o.plan_code = p_plan_code;

  ELSE
    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.pack,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             o.box_no,
             p.package_no,
             1,
             d.tickets_every_pack * g.ticket_amount
        FROM wh_ticket_box o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
        Left Join wh_ticket_trunk t
          on (o.plan_code = t.plan_code and o.batch_no = t.batch_no and
             t.trunk_no = o.trunk_no)
        left join wh_ticket_package p
          on (o.plan_code = p.plan_code and o.batch_no = p.batch_no and
           o.box_no = p.box_no)
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND t.is_full = eboolean.noordisabled
         AND o.status = eticket_status.in_warehouse;
  END IF;

  ---本检测
  IF ((p_batch_code IS NOT NULL) OR length(p_batch_code) > 0) THEN

    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.pack,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             o.box_no,
             o.package_no,
             1,
             d.tickets_every_pack * g.ticket_amount
        FROM wh_ticket_package o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
        Left Join wh_ticket_box b
          on (o.plan_code = b.plan_code and o.batch_no = b.batch_no and
             o.box_no = b.box_no)
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND o.status = eticket_status.in_warehouse
         AND b.is_full = eboolean.noordisabled
         AND o.plan_code = p_plan_code
         AND o.batch_no = p_batch_code;

  ELSIF ((p_plan_code IS NOT NULL) OR length(p_plan_code) > 0) THEN
    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.pack,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             o.box_no,
             o.package_no,
             1,
             d.tickets_every_pack * g.ticket_amount
        FROM wh_ticket_package o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
        Left Join wh_ticket_box b
          on (o.plan_code = b.plan_code and o.batch_no = b.batch_no and
             o.box_no = b.box_no)
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND b.is_full = eboolean.noordisabled
         AND o.status = eticket_status.in_warehouse
         AND o.plan_code = p_plan_code;

  ELSE
    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.pack,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             o.box_no,
             o.package_no,
             1,
             d.tickets_every_pack * g.ticket_amount
        FROM wh_ticket_package o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
        Left Join wh_ticket_box b
          on (o.plan_code = b.plan_code and o.batch_no = b.batch_no and
             o.box_no = b.box_no)
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND b.is_full = eboolean.noordisabled
         AND o.status = eticket_status.in_warehouse;
  END IF;

  --更新仓库状态
  update wh_info
     set wh_info.status = ewarehouse_status.checking
   where wh_info.warehouse_code = p_warehouse_code;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_warehouse_check_step2.sql ]...... 
CREATE OR REPLACE PROCEDURE p_warehouse_check_step2
/****************************************************************/
  ------------------- 适用于仓库盘点-------------------
  ----盘点第二步：扫描入库
  ----add by dzg: 2015-9-25
  ----modify by dzg:2015-10-27增加重复检测功能
  ----modify by dzg:2016-01-16 in pp 暂时不支持本签
  /*************************************************************/
(
 --------------输入----------------
 p_check_code     IN STRING, --盘点单
 p_array_lotterys IN type_lottery_list, -- 入库的彩票对象

 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因

 ) IS

  v_count_temp   NUMBER := 0; --临时变量
  v_count_pack   NUMBER := 0; --总包数
  v_count_tick   NUMBER := 0; --总票数
  v_amount_tatal NUMBER := 0; --总额
  v_total_tickets      NUMBER := 0; --纯变量
  v_total_amount       NUMBER := 0; --纯变量
  v_detail_list           type_lottery_detail_list;                       -- 彩票对象明细
  v_stat_list             type_lottery_statistics_list;                   -- 按照方案和批次统计的金额和票数

  v_item         type_lottery_info; --循环变量的当前值

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --编号不能为空
  IF ((p_check_code IS NULL) OR length(p_check_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_warehouse_check_step2_1;
    RETURN;
  END IF;

  --编号不存在或者已经完结
  v_count_temp := 0;
  SELECT count(o.cp_no)
    INTO v_count_temp
    FROM wh_check_point o
   WHERE o.cp_no = p_check_code
     AND o.status <> ecp_status.done;

  IF v_count_temp <= 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_warehouse_check_step2_2;
    RETURN;
  END IF;

  --记录不能为空
  IF (p_array_lotterys is null or p_array_lotterys.count < 0) THEN
    c_errorcode := 3;
    c_errormesg := error_msg.err_p_warehouse_check_step2_3;
    RETURN;
  END IF;

  --重复检测
  IF (f_check_import_ticket(p_check_code,3,p_array_lotterys)) THEN
    c_errorcode := 4;
    c_errormesg := error_msg.err_p_ar_inbound_3;
    RETURN;
  END IF;


  /*----------- 插入数据  -----------------*/

  --使用陈震函数初始化对象
  p_lottery_detail_stat(p_array_lotterys, v_detail_list, v_stat_list, v_total_tickets, v_total_amount);

  ---循环插入数据
  FOR i IN 1 .. p_array_lotterys.count LOOP

    if( v_detail_list(i).valid_number = evalid_number.box) then
        RAISE_APPLICATION_ERROR(-20123, 'System not support the barcode of box.', TRUE);
    end if;
    v_item := p_array_lotterys(i);
    v_count_pack := 0;
    v_count_tick:= 0;

    p_warehouse_get_sum_info(v_item,
                             v_count_pack,
                             v_count_tick,
                             v_amount_tatal);



    ---后插入 wh_check_point_detail
    insert into wh_check_point_detail
      (cp_no,
       sequence_no,
       valid_number,
       plan_code,
       batch_no,
       trunk_no,
       box_no,
       package_no,
       packages,
       amount)
    values
      (p_check_code,
       f_get_detail_sequence_no_seq(),
       v_detail_list(i).valid_number,
       v_detail_list(i).plan_code,
       v_detail_list(i).batch_no,
       v_detail_list(i).trunk_no,
       v_detail_list(i).box_no,
       v_detail_list(i).package_no,
       v_count_pack,
       v_amount_tatal);

  END LOOP;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_warehouse_check_step3.sql ]...... 
CREATE OR REPLACE PROCEDURE p_warehouse_check_step3
/****************************************************************/
  ------------------- 适用于仓库盘点-------------------
  ----盘点第三步：确认完成，并生成结果
  ----add by dzg: 2015-9-25
  ----业务流程：根据对比前的数据和实际扫库数据，进行计算结果
  ----目前只有可能少，或者一致，多属于其他异常
  ----modify by dzg 2015-10-23 增加备注
  ----修改使得第三步和完成都可以使用同一个过程
  ----modify by dzg 2015-11-12 修改计算已盘点数据错误，sql错误，inner没加匹配条件...依旧需要补充其他逻辑
  /*************************************************************/
(
 --------------输入----------------
 p_check_code IN STRING, --盘点单
 p_remark     IN STRING, --盘点备注
 p_isfinish   IN NUMBER, --完成标志
 
 ---------出口参数---------
 c_before_num    OUT NUMBER, --盘点前总数
 c_before_amount OUT NUMBER, --盘点前总额
 c_after_num     OUT NUMBER, --盘点后总数
 c_after_amount  OUT NUMBER, --盘点后总额
 c_result        OUT NUMBER, --盘点结果
 c_errorcode     OUT NUMBER, --错误编码
 c_errormesg     OUT STRING --错误原因
 
 ) IS

  v_count_temp NUMBER := 0; --临时变量
  c_isfinish NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;
  
  --初始化默认输出值，否则mybatis会有异常提示
  c_before_num    := 0;
  c_before_amount := 0;
  c_after_num     := 0;
  c_after_amount  := 0;
  c_result        := ecp_result.same;
  c_isfinish      := ecp_status.working;

  /*----------- 数据校验   -----------------*/
  --编号不能为空
  IF ((p_check_code IS NULL) OR length(p_check_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_warehouse_check_step2_1;
    RETURN;
  END IF;

  --编号不存在或者已经完结
  IF (p_isfinish > 0 ) THEN
    c_isfinish      := ecp_status.done;
    v_count_temp := 0;
    SELECT count(o.cp_no)
      INTO v_count_temp
      FROM wh_check_point o
     WHERE o.cp_no = p_check_code
       AND o.status <> ecp_status.done;

    IF v_count_temp <= 0 THEN
      c_errorcode := 2;
      c_errormesg := error_msg.err_p_warehouse_check_step2_2;
      RETURN;
    END IF;
  END IF;

  /*----------- 插入数据  -----------------*/
  --入库前总数和金额及其入库金额总数
  --根据总数判断
  
  --多次调用考虑使用先清除
   delete from wh_cp_nomatch_detail 
    where wh_cp_nomatch_detail.cp_no= p_check_code;
 
  select sum(nd.packages * gd.tickets_every_pack), sum(nd.amount)
    into c_before_num, c_before_amount
    from wh_check_point_detail_be nd
    left join game_batch_import_detail gd
      on (nd.plan_code = gd.plan_code and nd.batch_no = gd.batch_no)
   where nd.cp_no = p_check_code;

  select sum(nd.packages * gd.tickets_every_pack), sum(nd.amount)
    into c_after_num, c_after_amount
    from wh_check_point_detail nd
    left join game_batch_import_detail gd
      on (nd.plan_code = gd.plan_code and nd.batch_no = gd.batch_no)
   inner join wh_check_point_detail_be bf
      on (nd.plan_code = bf.plan_code and nd.batch_no = bf.batch_no and
         nd.valid_number = bf.valid_number and nd.trunk_no = bf.trunk_no and
         nd.box_no = bf.box_no and nd.package_no = bf.package_no)
   where nd.cp_no = p_check_code
   and bf.cp_no =p_check_code;

  IF ((c_before_num IS NULL) OR length(c_before_num) <= 0) THEN
    c_before_num    := 0;
    c_before_amount := 0;
  END IF;

  IF ((c_after_num IS NULL) OR length(c_after_num) <= 0) THEN
    c_after_num    := 0;
    c_after_amount := 0;
  END IF;

  IF (c_before_num = c_after_num) THEN
  
    update wh_check_point
       set status          = c_isfinish,
           result          = ecp_result.same,
           nomatch_tickets = 0,
           remark          = p_remark,
           nomatch_amount  = 0
     where cp_no = p_check_code;
  
  ELSE
    ---生成未匹配数据
    c_result        := ecp_result.less;
    insert into wh_cp_nomatch_detail
      select t.cp_no,
             t.sequence_no,
             t.valid_number,
             t.plan_code,
             t.batch_no,
             t.trunk_no,
             t.box_no,
             t.package_no,
             t.packages,
             t.amount
        from (
              
              select a1.cp_no,
                      a1.sequence_no,
                      a1.valid_number,
                      a1.plan_code,
                      a1.batch_no,
                      a1.trunk_no,
                      a1.box_no,
                      a1.package_no,
                      a1.packages,
                      a1.amount,
                      nvl2(b1.trunk_no, 0, 1) vsign
                from wh_check_point_detail_be a1
                left join wh_check_point_detail b1
                  on (a1.cp_no = b1.cp_no and
                     a1.valid_number = b1.valid_number and
                     a1.trunk_no = b1.trunk_no)
               where a1.cp_no = p_check_code
                 and a1.valid_number = 1
              
              union
              
              select a2.cp_no,
                      a2.sequence_no,
                      a2.valid_number,
                      a2.plan_code,
                      a2.batch_no,
                      a2.trunk_no,
                      a2.box_no,
                      a2.package_no,
                      a2.packages,
                      a2.amount,
                      nvl2(b2.trunk_no, 0, 1) vsign
                from wh_check_point_detail_be a2
                left join wh_check_point_detail b2
                  on (a2.cp_no = b2.cp_no and
                     a2.valid_number = b2.valid_number and
                     a2.box_no = b2.box_no)
               where a2.cp_no = p_check_code
                 and a2.valid_number = 2
              
              union
              
              select a3.cp_no,
                      a3.sequence_no,
                      a3.valid_number,
                      a3.plan_code,
                      a3.batch_no,
                      a3.trunk_no,
                      a3.box_no,
                      a3.package_no,
                      a3.packages,
                      a3.amount,
                      nvl2(b3.trunk_no, 0, 1) vsign
                from wh_check_point_detail_be a3
                left join wh_check_point_detail b3
                  on (a3.cp_no = b3.cp_no and
                     a3.valid_number = b3.valid_number and
                     a3.package_no = b3.package_no)
               where a3.cp_no = p_check_code
                 and a3.valid_number = 3) t
       where t.vsign = 0;
  
    update wh_check_point
       set status          = c_isfinish,
           result          = ecp_result.less,
           remark          = p_remark,
           nomatch_tickets = c_before_num - c_after_num,
           nomatch_amount  = c_before_amount - c_after_amount
     where cp_no = p_check_code;
  
  END IF;
  
  --结束的解除
  IF (p_isfinish > 0 ) THEN
     update wh_info
        set wh_info.status = ewarehouse_status.working
      where wh_info.warehouse_code in
            (select wh_check_point.warehouse_code
               from wh_check_point
              where wh_check_point.cp_no = p_check_code);
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END;
 
/ 
prompt 正在建立[PROCEDURE -> p_warehouse_create.sql ]...... 
CREATE OR REPLACE PROCEDURE p_warehouse_create
/****************************************************************/
  ------------------- 适用于创建仓库-------------------
  ----创建仓库
  ----add by dzg: 2015-9-17
  ----业务流程：先插入仓库表，依次仓库管理员，同时更新用户管理对应字段
  /*************************************************************/
(
 --------------输入----------------
 p_warehouse_code     IN STRING, --库房编码
 p_warehouse_name     IN STRING, --库房名称
 p_org_code           IN STRING, --机构编码
 p_warehouse_adds     IN STRING, --库房地址
 p_warehouse_phone    IN STRING, --库房电话
 p_warehouse_admin    IN NUMBER, --库房负责人
 p_warehouse_create   IN NUMBER, --创建人
 p_warehouse_managers IN STRING, --库房管理人员列表,使用“,”分割的多个字符串
 
 ---------出口参数---------
 
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 
 ) IS

  v_count_temp NUMBER := 0; --临时变量
  v_str_temp  varchar(200); --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --编码不能为空
  IF ((p_warehouse_code IS NULL) OR length(p_warehouse_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_WAREHOUSE_CREATE_1;
    RETURN;
  END IF;

  --编码不能重复
  v_count_temp := 0;
  SELECT count(o.warehouse_code)
    INTO v_count_temp
    FROM wh_info o
   WHERE o.warehouse_code = p_warehouse_code
     AND o.org_code = p_org_code;

  IF v_count_temp > 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.ERR_P_WAREHOUSE_CREATE_2;
    RETURN;
  END IF;

  --名称不能为空
  IF ((p_warehouse_name IS NULL) OR length(p_warehouse_name) <= 0) THEN
    c_errorcode := 3;
    c_errormesg := error_msg.ERR_P_WAREHOUSE_CREATE_3;
    RETURN;
  END IF;

  --地址不能为空
  IF ((p_warehouse_adds IS NULL) OR length(p_warehouse_adds) <= 0) THEN
    c_errorcode := 4;
    c_errormesg := error_msg.ERR_P_WAREHOUSE_CREATE_4;
    RETURN;
  END IF;

  --负责人不存在
  v_count_temp := 0;
  SELECT count(u.admin_id)
    INTO v_count_temp
    FROM adm_info u
   WHERE u.admin_id = p_warehouse_admin
     And u.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 5;
    c_errormesg := error_msg.ERR_P_WAREHOUSE_CREATE_5;
    RETURN;
  END IF;

  --编码重复管辖
  v_count_temp := 0;

  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_warehouse_managers))) LOOP
    dbms_output.put_line(i.column_value);
  
    IF length(i.column_value) > 0 THEN
    
      v_count_temp := 0;
      SELECT count(u.warehouse_code)
        INTO v_count_temp
        FROM wh_manager u
       WHERE u.manager_id = i.column_value
         And u.is_valid = eboolean.yesorenabled;
    
      IF v_count_temp > 0 THEN
        
        select adm_info.admin_realname
          into v_str_temp from adm_info
         where adm_info.admin_id = i.column_value;
        c_errorcode := 6;
        c_errormesg := v_str_temp ||
                       error_msg.ERR_P_WAREHOUSE_CREATE_6;
        RETURN;
      END IF;
    
    END IF;
  END LOOP;

  /*----------- 数据校验   -----------------*/
  --插入基本信息
  insert into wh_info
    (warehouse_code,
     warehouse_name,
     org_code,
     address,
     phone,
     director_admin,
     status,
     create_admin,
     create_date)
  values
    (p_warehouse_code,
     p_warehouse_name,
     p_org_code,
     p_warehouse_adds,
     p_warehouse_phone,
     p_warehouse_admin,
     ewarehouse_status.working,
     p_warehouse_create,
     sysdate);

  --循环的插入管理员信息，并更新权限信息表
  --先清理原有数据

  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_warehouse_managers))) LOOP
    dbms_output.put_line(i.column_value);
  
    IF length(i.column_value) > 0 THEN
    
      ---插入账户
      insert into wh_manager
        (warehouse_code, org_code, manager_id, is_valid, start_time)
      values
        (p_warehouse_code,
         p_org_code,
         i.column_value,
         eboolean.yesorenabled,
         sysdate);
    
      ---更新状态
      update adm_info
         set adm_info.is_warehouse_m = eboolean.yesorenabled
       where adm_info.admin_id = i.column_value;
    
    END IF;
  END LOOP;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END p_warehouse_create;
/
 
/ 
prompt 正在建立[PROCEDURE -> p_warehouse_damage_register.sql ]...... 
CREATE OR REPLACE PROCEDURE p_warehouse_damage_register
/****************************************************************/
  ------------------- 适用于仓库损毁登记-------------------
  ----add by dzg: 2015-10-29
  ----业务流程：损毁登记
  ----modify by dzg:2015-10-31
  ----修改：批次入库损毁插入一个包，否则查询有异常
  ----modify by dzg:2015-11-02
  ----修改：增加其他类型的备注更新
  ----modify by dzg:2015-11-10修改调拨没有考虑拆箱情况
  ----modify by dzg:2015-11-21重复操作检测
  /*************************************************************/
(
 --------------输入----------------
 p_opr_admin   IN NUMBER, --操作人
 p_check_type  IN NUMBER, --操作类型：1 批次入库损毁 2 调拨损毁 3 盘点损毁
 p_ref_code    IN STRING, --参考编号
 p_remark      IN STRING, --损毁备注
 p_extend_arg1 IN STRING, --扩展参数1，用盘点损毁具体编号数据
 
 ---------出口参数---------
 c_register_code OUT STRING, --返回盘点单编号
 c_errorcode     OUT NUMBER, --错误编码
 c_errormesg     OUT STRING --错误原因
 
 ) IS

  v_count_temp     NUMBER := 0; --临时变量
  v_count_tick     NUMBER := 0; --存放临时库存总量
  v_pack_type      NUMBER := 0; --包装类型用于枚举
  v_total_pack     NUMBER := 0; --总本数
  v_total_amount   NUMBER := 0; --总金额
  v_total_pack_t   NUMBER := 0; --总本数-临时变量用于盘点
  v_total_amount_t NUMBER := 0; --总金额-临时变量用于盘点
  v_face_value     NUMBER := 0; --票面金额
  v_packnum_p_truk NUMBER := 0; --每箱本数
  v_boxnum_p_truk  NUMBER := 0; --每箱盒数
  v_packnum_p_box  NUMBER := 0; --每盒本数
  v_ticknum_p_pack NUMBER := 0; --每本张数

  type type_detail is table of wh_check_point_detail_be%rowtype;
  v_insert_detail type_detail;

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp    := 0;
  v_insert_detail := type_detail();
  /*----------- 数据校验   -----------------*/
  --编码不能为空
  IF ((p_ref_code IS NULL) OR length(p_ref_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_warehouse_create_1;
    RETURN;
  END IF;

  --人无效
  v_count_temp := 0;
  SELECT count(o.admin_id)
    INTO v_count_temp
    FROM adm_info o
   WHERE o.admin_id = p_opr_admin
     AND o.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_mm_fund_repay_4;
    RETURN;
  END IF;
  
  --重复检测
  v_count_temp := 0;

  SELECT count(wh_broken_recoder.broken_no)
    INTO v_count_temp
    FROM wh_broken_recoder
   WHERE wh_broken_recoder.stb_no = p_ref_code
     OR wh_broken_recoder.cp_no = p_ref_code;

  IF v_count_temp > 0 THEN
    c_errorcode := 3;
    c_errormesg := error_msg.err_common_8;
    RETURN;
  END IF;

  ---插入数据

  --生成单号
  c_register_code := f_get_wh_broken_recoder_seq();

  case p_check_type
    when 1 then
      --批次损毁
      begin
      
        -- 初始化数据
        select b.damaged_tickets / d.tickets_every_pack, b.damaged_amount
          into v_total_pack, v_total_amount
          from wh_batch_inbound b
          left join game_batch_import_detail d
            on b.plan_code = d.plan_code
           and b.batch_no = d.batch_no
         where b.bi_no = p_ref_code;
      
        -- 插入主表  
        insert into wh_broken_recoder
          (broken_no,
           apply_admin,
           apply_date,
           source,
           stb_no,
           cp_no,
           packages,
           total_amount,
           reason,
           remark)
        values
          (c_register_code,
           p_opr_admin,
           sysdate,
           p_check_type,
           p_ref_code,
           p_ref_code,
           v_total_pack,
           v_total_amount,
           eticket_status.broken,
           p_remark);
      
        --插入详表-否则损毁有异常
        insert into wh_broken_recoder_detail
          (broken_no,
           sequence_no,
           valid_number,
           plan_code,
           batch_no,
           trunk_no,
           box_no,
           package_no,
           packages,
           amount)
          select c_register_code,
                 f_get_detail_sequence_no_seq(),
                 evalid_number.pack,
                 wh_batch_inbound.plan_code,
                 wh_batch_inbound.batch_no,
                 '-',
                 '-',
                 '-',
                 v_total_pack,
                 v_total_amount
            from wh_batch_inbound
           where wh_batch_inbound.bi_no = p_ref_code;
      
        --插入备注
        --update wh_batch_inbound 
        --set wh_batch_inbound.remark =p_remark
        --where wh_batch_inbound.bi_no=p_ref_code;
        update wh_goods_receipt
           set wh_goods_receipt.remark = p_remark
         where wh_goods_receipt.ref_no = p_ref_code;
      
      end;
    
    when 2 then
      --调拨损毁
      begin
        v_total_pack   := 0;
        v_total_amount := 0;
      
        --循环插入详情
        for xx in (select ref_no,
                          plan_code,
                          batch_no,
                          valid_number,
                          trunk_no,
                          box_no,
                          package_no,
                          nvl(bf.tickets, af.tickets) tickets,
                          nvl(bf.amount, af.amount) amount,
                          bf.sequence_no bno,
                          af.sequence_no ano
                     from wh_goods_issue_detail bf
                     full join wh_goods_receipt_detail af
                    using (ref_no, plan_code, batch_no, valid_number, trunk_no, box_no, package_no)
                    where ref_no = p_ref_code) loop
                    
          --ano 入库标志，出入库没有入库的
          if (xx.ano is null  and xx.tickets > 0) then
          
            --初始化基础金额等计算数据
            v_face_value     := 0;
            v_packnum_p_truk := 0;
            v_boxnum_p_truk  := 0;
            v_packnum_p_box  := 0;
            v_ticknum_p_pack := 0;
            select game_plans.ticket_amount,
                   game_batch_import_detail.packs_every_trunk,
                   game_batch_import_detail.boxes_every_trunk,
                   game_batch_import_detail.packs_every_trunk /
                   game_batch_import_detail.boxes_every_trunk,
                   game_batch_import_detail.tickets_every_pack
              into v_face_value,
                   v_packnum_p_truk,
                   v_boxnum_p_truk,
                   v_packnum_p_box,
                   v_ticknum_p_pack
              from game_batch_import_detail
              left join game_plans
                on game_batch_import_detail.plan_code =
                   game_plans.plan_code
             where game_batch_import_detail.plan_code = xx.plan_code
               and game_batch_import_detail.batch_no = xx.batch_no;
          
            --检测是否包含并拆包等处理
            case xx.valid_number
              when evalid_number.trunk then
                begin
                  v_count_temp := 0;
                  select count(*)
                    into v_count_temp
                    from wh_goods_receipt_detail
                   where wh_goods_receipt_detail.plan_code = xx.plan_code
                     and wh_goods_receipt_detail.batch_no = xx.batch_no
                     and wh_goods_receipt_detail.trunk_no = xx.trunk_no
                     and wh_goods_receipt_detail.ref_no = p_ref_code;
                
                  ---需要拆箱检测
                  if (v_count_temp > 0) then
                    for b2xx in (select bf2.plan_code,
                                        bf2.batch_no,
                                        bf2.trunk_no,
                                        bf2.box_no,
                                        bf2.box_no      bno,
                                        af2.sequence_no ano
                                   from wh_ticket_box bf2
                                   left join wh_goods_receipt_detail af2
                                     on (bf2.plan_code = af2.plan_code and
                                        bf2.batch_no = af2.batch_no and
                                        af2.trunk_no = bf2.trunk_no and
                                        af2.box_no = bf2.box_no and 
                                        af2.ref_no = p_ref_code and 
                                        af2.valid_number = evalid_number.box)
                                  where bf2.plan_code = xx.plan_code
                                    and bf2.batch_no = xx.batch_no
                                    and bf2.trunk_no = xx.trunk_no ) loop
                    
                      if (b2xx.ano is null) then
                        --如果收货单没有箱的定义，则检测是否有本
                        v_count_temp := 0;
                        select count(*)
                          into v_count_temp
                          from wh_goods_receipt_detail
                         where wh_goods_receipt_detail.plan_code = b2xx.plan_code
                           and wh_goods_receipt_detail.batch_no = b2xx.batch_no
                           and wh_goods_receipt_detail.box_no = b2xx.box_no
                           and wh_goods_receipt_detail.valid_number = evalid_number.pack
                           and wh_goods_receipt_detail.ref_no = p_ref_code;
                      
                        if v_count_temp > 0 then
                          --有则，继续拆成本检测
                          for b3xx in (select bf3.plan_code,
                                              bf3.batch_no,
                                              bf3.trunk_no,
                                              bf3.box_no,
                                              bf3.package_no,
                                              bf3.box_no      bno,
                                              af3.sequence_no ano
                                         from wh_ticket_package bf3
                                         left join wh_goods_receipt_detail af3
                                           on (bf3.plan_code = af3.plan_code and
                                              bf3.batch_no = af3.batch_no and
                                              af3.trunk_no = bf3.trunk_no and
                                              af3.package_no = bf3.package_no and 
                                              af3.ref_no = p_ref_code and
                                              af3.valid_number =evalid_number.pack)
                                        where bf3.plan_code = xx.plan_code
                                          and bf3.batch_no = xx.batch_no
                                          and bf3.box_no = b2xx.box_no ) loop
                          
                            if (b3xx.ano is null) then
                              --没有则，损毁登记
                              v_total_pack_t := 1;
                              v_total_pack   := v_total_pack +
                                                v_total_pack_t;
                              v_total_amount := v_total_amount +
                                                (v_ticknum_p_pack *
                                                v_face_value);
                            
                              insert into wh_broken_recoder_detail
                                (broken_no,
                                 sequence_no,
                                 valid_number,
                                 plan_code,
                                 batch_no,
                                 trunk_no,
                                 box_no,
                                 package_no,
                                 packages,
                                 amount)
                              values
                                (c_register_code,
                                 f_get_detail_sequence_no_seq(),
                                 evalid_number.pack,
                                 b3xx.plan_code,
                                 b3xx.batch_no,
                                 b3xx.trunk_no,
                                 b3xx.box_no,
                                 b3xx.package_no,
                                 1,
                                 v_ticknum_p_pack * v_face_value);
                            
                              --损毁票状态更新
                              p_wh_ticket_damage(p_opr_admin,
                                                 b3xx.plan_code,
                                                 b3xx.batch_no,
                                                 evalid_number.pack,
                                                 b3xx.trunk_no,
                                                 b3xx.box_no,
                                                 b3xx.package_no);
                            end if;
                          end loop;
                        
                        else
                          --无则(box)，插入损毁登记
                          v_total_pack_t := v_packnum_p_box;
                          v_total_pack   := v_total_pack + v_total_pack_t;
                          v_total_amount := v_total_amount + (v_total_pack_t *
                                            v_ticknum_p_pack *
                                            v_face_value);
                          insert into wh_broken_recoder_detail
                            (broken_no,
                             sequence_no,
                             valid_number,
                             plan_code,
                             batch_no,
                             trunk_no,
                             box_no,
                             package_no,
                             packages,
                             amount)
                          values
                            (c_register_code,
                             f_get_detail_sequence_no_seq(),
                             evalid_number.box,
                             b2xx.plan_code,
                             b2xx.batch_no,
                             b2xx.trunk_no,
                             b2xx.box_no,
                             '-',
                             v_total_pack_t,
                             v_total_pack_t * v_ticknum_p_pack *
                             v_face_value);
                        
                          --损毁票状态更新
                          p_wh_ticket_damage(p_opr_admin,
                                             b2xx.plan_code,
                                             b2xx.batch_no,
                                             evalid_number.box,
                                             b2xx.trunk_no,
                                             b2xx.box_no,
                                             '-');
                        
                        end if;
                      end if;
                    
                    end loop;
                  else
                    --直接损毁(trunk)
                    v_total_pack_t := v_packnum_p_truk;
                    v_total_pack   := v_total_pack + v_total_pack_t;
                    v_total_amount := v_total_amount +
                                      (v_total_pack_t * v_ticknum_p_pack *
                                      v_face_value);
                    insert into wh_broken_recoder_detail
                      (broken_no,
                       sequence_no,
                       valid_number,
                       plan_code,
                       batch_no,
                       trunk_no,
                       box_no,
                       package_no,
                       packages,
                       amount)
                    values
                      (c_register_code,
                       f_get_detail_sequence_no_seq(),
                       evalid_number.trunk,
                       xx.plan_code,
                       xx.batch_no,
                       xx.trunk_no,
                       '-',
                       '-',
                       v_total_pack_t,
                       v_total_pack_t * v_ticknum_p_pack * v_face_value);
                  
                    --损毁票状态更新
                    p_wh_ticket_damage(p_opr_admin,
                                       xx.plan_code,
                                       xx.batch_no,
                                       evalid_number.trunk,
                                       xx.trunk_no,
                                       '-',
                                       '-');
                  
                  end if;
                
                end;
              when evalid_number.box then
                begin
                  v_count_temp := 0;
                  select count(*)
                    into v_count_temp
                    from wh_goods_receipt_detail
                   where wh_goods_receipt_detail.plan_code = xx.plan_code
                     and wh_goods_receipt_detail.batch_no = xx.batch_no
                     and wh_goods_receipt_detail.box_no = xx.box_no
                     and wh_goods_receipt_detail.ref_no = p_ref_code;
                
                  ---拆包检测
                  if (v_count_temp > 0) then
                    for b1xx in (select bf4.plan_code,
                                        bf4.batch_no,
                                        bf4.trunk_no,
                                        bf4.box_no,
                                        bf4.package_no,
                                        bf4.box_no      bno,
                                        af4.sequence_no ano
                                   from wh_ticket_package bf4
                                   left join wh_goods_receipt_detail af4
                                     on (bf4.plan_code = af4.plan_code and
                                        bf4.batch_no = af4.batch_no and
                                        af4.trunk_no = bf4.trunk_no and
                                        af4.package_no = bf4.package_no and 
                                        af4.ref_no = p_ref_code and 
                                        af4.valid_number = evalid_number.pack )
                                  where bf4.plan_code = xx.plan_code
                                    and bf4.batch_no = xx.batch_no
                                    and bf4.box_no = xx.box_no ) loop
                    
                      if (b1xx.ano is null) then
                        v_total_pack_t := 1;
                        v_total_pack   := v_total_pack + v_total_pack_t;
                        v_total_amount := v_total_amount +
                                          (v_ticknum_p_pack * v_face_value);
                      
                        insert into wh_broken_recoder_detail
                          (broken_no,
                           sequence_no,
                           valid_number,
                           plan_code,
                           batch_no,
                           trunk_no,
                           box_no,
                           package_no,
                           packages,
                           amount)
                        values
                          (c_register_code,
                           f_get_detail_sequence_no_seq(),
                           evalid_number.pack,
                           b1xx.plan_code,
                           b1xx.batch_no,
                           b1xx.trunk_no,
                           b1xx.box_no,
                           b1xx.package_no,
                           1,
                           v_ticknum_p_pack * v_face_value);
                      
                        --损毁票状态更新
                        p_wh_ticket_damage(p_opr_admin,
                                           b1xx.plan_code,
                                           b1xx.batch_no,
                                           evalid_number.pack,
                                           b1xx.trunk_no,
                                           b1xx.box_no,
                                           b1xx.package_no);
                      
                      end if;
                    
                    end loop;
                  
                  else
                    --直接损毁
                    v_count_temp := 0;
                    select de.tickets_every_pack
                      into v_count_temp
                      from game_batch_import_detail de
                     where de.plan_code = xx.plan_code
                       and de.batch_no = xx.batch_no;
                    if v_count_temp > 0 then
                      v_total_pack_t := xx.tickets / v_count_temp;
                      v_total_pack   := v_total_pack + v_total_pack_t;
                      v_total_amount := v_total_amount + xx.amount;
                      insert into wh_broken_recoder_detail
                        (broken_no,
                         sequence_no,
                         valid_number,
                         plan_code,
                         batch_no,
                         trunk_no,
                         box_no,
                         package_no,
                         packages,
                         amount)
                      values
                        (c_register_code,
                         f_get_detail_sequence_no_seq(),
                         xx.valid_number,
                         xx.plan_code,
                         xx.batch_no,
                         xx.trunk_no,
                         xx.box_no,
                         xx.package_no,
                         v_total_pack_t,
                         xx.amount);
                    
                      --损毁票状态更新
                      p_wh_ticket_damage(p_opr_admin,
                                         xx.plan_code,
                                         xx.batch_no,
                                         xx.valid_number,
                                         xx.trunk_no,
                                         xx.box_no,
                                         '-');
                    
                    end if;
                  
                  end if;
                end;
              when evalid_number.pack then
                begin
                  --直接损毁
                  v_count_temp := 0;
                  select de.tickets_every_pack
                    into v_count_temp
                    from game_batch_import_detail de
                   where de.plan_code = xx.plan_code
                     and de.batch_no = xx.batch_no;
                  if v_count_temp > 0 then
                    v_total_pack_t := xx.tickets / v_count_temp;
                    v_total_pack   := v_total_pack + v_total_pack_t;
                    v_total_amount := v_total_amount + xx.amount;
                    insert into wh_broken_recoder_detail
                      (broken_no,
                       sequence_no,
                       valid_number,
                       plan_code,
                       batch_no,
                       trunk_no,
                       box_no,
                       package_no,
                       packages,
                       amount)
                    values
                      (c_register_code,
                       f_get_detail_sequence_no_seq(),
                       xx.valid_number,
                       xx.plan_code,
                       xx.batch_no,
                       xx.trunk_no,
                       xx.box_no,
                       xx.package_no,
                       v_total_pack_t,
                       xx.amount);
                  
                    --损毁票状态更新
                    p_wh_ticket_damage(p_opr_admin,
                                       xx.plan_code,
                                       xx.batch_no,
                                       xx.valid_number,
                                       xx.trunk_no,
                                       xx.box_no,
                                       xx.package_no);
                  
                  end if;
                end;
            end case;
          
          end if;
        end loop;
      
        --插入主表
        IF v_total_pack > 0 THEN
          insert into wh_broken_recoder
            (broken_no,
             apply_admin,
             apply_date,
             source,
             stb_no,
             cp_no,
             packages,
             total_amount,
             reason,
             remark)
          values
            (c_register_code,
             p_opr_admin,
             sysdate,
             p_check_type,
             '',
             p_ref_code,
             v_total_pack,
             v_total_amount,
             eticket_status.broken,
             p_remark);
        end if;
      
        --插入备注
        update wh_goods_receipt
           set wh_goods_receipt.remark = p_remark
         where wh_goods_receipt.ref_no = p_ref_code;
      
      end;
    when 3 then
      --盘点损毁
      begin
        v_total_pack   := 0;
        v_total_amount := 0;
      
        --循环遍历扩展-插入详情表
        FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_extend_arg1))) LOOP
          dbms_output.put_line(i.column_value);
          IF length(i.column_value) > 0 THEN
            v_total_pack_t   := 0;
            v_total_amount_t := 0;
          
            select cbe.packages, cbe.amount
              into v_total_pack_t, v_total_amount_t
              from wh_check_point_detail_be cbe
             where cbe.cp_no = p_ref_code
               and cbe.sequence_no = i.column_value;
          
            IF v_total_pack_t > 0 THEN
              v_total_pack   := v_total_pack + v_total_pack_t;
              v_total_amount := v_total_amount + v_total_amount_t;
            
              --Insert Detail
            
              for yy in (select *
                           from wh_check_point_detail_be
                          where cp_no = p_ref_code
                            and sequence_no = i.column_value) loop
              
                insert into wh_broken_recoder_detail
                  (broken_no,
                   sequence_no,
                   valid_number,
                   plan_code,
                   batch_no,
                   trunk_no,
                   box_no,
                   package_no,
                   packages,
                   amount)
                values
                  (c_register_code,
                   f_get_detail_sequence_no_seq(),
                   yy.valid_number,
                   yy.plan_code,
                   yy.batch_no,
                   yy.trunk_no,
                   yy.box_no,
                   yy.package_no,
                   v_total_pack_t,
                   yy.amount);
              
                --损毁票状态更新
                p_wh_ticket_damage(p_opr_admin,
                                   yy.plan_code,
                                   yy.batch_no,
                                   yy.valid_number,
                                   yy.trunk_no,
                                   yy.box_no,
                                   yy.package_no);
              
              end loop;
            
            END IF;
          END IF;
        END LOOP;
      
        --插入主表
        IF v_total_pack > 0 THEN
          insert into wh_broken_recoder
            (broken_no,
             apply_admin,
             apply_date,
             source,
             stb_no,
             cp_no,
             packages,
             total_amount,
             reason,
             remark)
          values
            (c_register_code,
             p_opr_admin,
             sysdate,
             p_check_type,
             '',
             p_ref_code,
             v_total_pack,
             v_total_amount,
             eticket_status.broken,
             p_remark);
        
          --更新盘点单备注
        
          update wh_check_point
             set wh_check_point.remark = p_remark
           where wh_check_point.cp_no = p_ref_code;
        
        end if;
      
      end;
  end case;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END;
 
/ 
prompt 正在建立[PROCEDURE -> p_warehouse_delete.sql ]...... 
CREATE OR REPLACE PROCEDURE p_warehouse_delete
/****************************************************************/
  ------------------- 适用于删除仓库-------------------
  ----修改仓库
  ----add by dzg: 2015-9-17
  ----业务流程：  当该仓库中有库存时，不可进行时删除；
  /*************************************************************/
(
 --------------输入----------------
 p_warehouse_code IN STRING, --库房编码
 p_warehouse_opr  IN NUMBER, --当前操作人
 
 ---------出口参数---------
 
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 
 ) IS

  v_count_temp NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --编码不能为空
  IF ((p_warehouse_code IS NULL) OR length(p_warehouse_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_WAREHOUSE_CREATE_1;
    RETURN;
  END IF;

  --检测是否有库存彩票-trunk
  v_count_temp := 0;
  SELECT count(o.plan_code)
    INTO v_count_temp
    FROM wh_ticket_trunk o
   WHERE o.current_warehouse = p_warehouse_code
     AND o.is_full = eboolean.yesorenabled
     AND o.status = eticket_status.in_warehouse;

  IF v_count_temp > 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_warehouse_delete_1;
    RETURN;
  END IF;

  --检测是否有库存彩票-box
  v_count_temp := 0;
  SELECT count(o.plan_code)
    INTO v_count_temp
    FROM wh_ticket_box o
   WHERE o.current_warehouse = p_warehouse_code
     AND o.is_full = eboolean.yesorenabled
     AND o.status = eticket_status.in_warehouse;

  IF v_count_temp > 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_warehouse_delete_1;
    RETURN;
  END IF;

  --检测是否有库存彩票-package
  v_count_temp := 0;
  SELECT count(o.plan_code)
    INTO v_count_temp
    FROM wh_ticket_package o
   WHERE o.current_warehouse = p_warehouse_code
     AND o.is_full = eboolean.yesorenabled
     AND o.status = eticket_status.in_warehouse;

  IF v_count_temp > 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_warehouse_delete_1;
    RETURN;
  END IF;

  --检测是否有物品在库

  v_count_temp := 0;
  SELECT count(u.item_code)
    INTO v_count_temp
    FROM item_quantity u
   WHERE u.warehouse_code = p_warehouse_code;

  IF v_count_temp > 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_warehouse_delete_1;
    RETURN;
  END IF;

  /*----------- 插入数据  -----------------*/

  update wh_info
     set status     = ewarehouse_status.stoped,
         stop_admin = p_warehouse_opr,
         stop_date  = sysdate
   where warehouse_code = p_warehouse_code;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END p_warehouse_delete;
/
 
/ 
prompt 正在建立[PROCEDURE -> p_warehouse_get_sum_info.sql ]...... 
CREATE OR REPLACE PROCEDURE p_warehouse_get_sum_info
/****************************************************************/
  -----适用采用陈震数据结构计算总票数，金额等信息-----------
  --add by dzg: 2015-9-26
  /*************************************************************/
(
 --------------输入----------------
 p_good_info IN type_lottery_info, -- 入库的彩票对象
 
 ---------出口参数---------
 c_total_pack   OUT NUMBER, --总包数
 c_total_ticket OUT NUMBER, --总票数
 c_total_amount OUT NUMBER  --总金额
 
 ) IS

  v_tn_per_trunk      NUMBER := 0; --每箱票数
  v_tn_per_box        NUMBER := 0; --每盒票数
  v_tn_per_package    NUMBER := 0; --每本票数
  v_amount_per_ticket NUMBER := 0; --单票金额

BEGIN

  /*----------- 数据校验   -----------------*/
  IF (p_good_info IS NULL) THEN
    c_total_ticket := 0;
    c_total_amount := 0;
    c_total_pack   := 0;
    RETURN;
  END IF;

  select d.packs_every_trunk * d.tickets_every_pack,
         (d.packs_every_trunk / d.boxes_every_trunk) * d.tickets_every_pack,
         d.tickets_every_pack,
         p.ticket_amount  
    into v_tn_per_trunk,
         v_tn_per_box,
         v_tn_per_package,
         v_amount_per_ticket 
    FROM game_batch_import_detail d
    left join game_plans p
      ON d.plan_code = p.plan_code
   WHERE d.plan_code = p_good_info.plan_code
     And d.batch_no = p_good_info.batch_no;

  CASE p_good_info.valid_number
    WHEN 1 THEN
      c_total_ticket := v_tn_per_trunk;
      c_total_amount := v_tn_per_trunk * v_amount_per_ticket;
      c_total_pack   := v_tn_per_trunk/v_tn_per_package;
    WHEN 2 THEN
      c_total_ticket := v_tn_per_box;
      c_total_amount := v_tn_per_box * v_amount_per_ticket;
      c_total_pack   := v_tn_per_box/v_tn_per_package;
    WHEN 3 THEN
      c_total_ticket := v_tn_per_package;
      c_total_amount := v_tn_per_package * v_amount_per_ticket;
      c_total_pack   := 1;
    ELSE
      c_total_ticket := 0;
      c_total_amount := 0;
      c_total_pack   := 0;
  END CASE;
  
  EXCEPTION WHEN OTHERS THEN 
    c_total_ticket := 0;
    c_total_amount := 0;
    c_total_pack   := 0;

END;
 
/ 
prompt 正在建立[PROCEDURE -> p_warehouse_modify.sql ]...... 
CREATE OR REPLACE PROCEDURE p_warehouse_modify
/****************************************************************/
  ------------------- 适用于修改仓库-------------------
  ----修改仓库
  ----add by dzg: 2015-9-17
  ----业务流程：先更新仓库表，依次判断仓库管理员，存在跳过，不存在则同新增同操作
  /*************************************************************/
(
 --------------输入----------------
 p_warehouse_code     IN STRING, --库房编码
 p_warehouse_name     IN STRING, --库房名称
 p_org_code           IN STRING, --机构编码
 p_warehouse_adds     IN STRING, --库房地址
 p_warehouse_phone    IN STRING, --库房电话
 p_warehouse_admin    IN NUMBER, --库房负责人
 p_warehouse_managers IN STRING, --库房管理人员列表,使用“,”分割的多个字符串
 
 ---------出口参数---------
 
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 
 ) IS

  v_count_temp NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --编码不能为空
  IF ((p_warehouse_code IS NULL) OR length(p_warehouse_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_WAREHOUSE_CREATE_1;
    RETURN;
  END IF;

  --编码不能重复
  v_count_temp := 0;
  SELECT count(o.warehouse_code)
    INTO v_count_temp
    FROM wh_info o
   WHERE o.warehouse_code = p_warehouse_code
     AND o.org_code = p_org_code;

  IF v_count_temp <= 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.ERR_P_WAREHOUSE_MODIFY_1;
    RETURN;
  END IF;

  --名称不能为空
  IF ((p_warehouse_name IS NULL) OR length(p_warehouse_name) <= 0) THEN
    c_errorcode := 3;
    c_errormesg := error_msg.ERR_P_WAREHOUSE_CREATE_3;
    RETURN;
  END IF;

  --地址不能为空
  IF ((p_warehouse_adds IS NULL) OR length(p_warehouse_adds) <= 0) THEN
    c_errorcode := 4;
    c_errormesg := error_msg.ERR_P_WAREHOUSE_CREATE_4;
    RETURN;
  END IF;

  --负责人不存在
  v_count_temp := 0;
  SELECT count(u.admin_id)
    INTO v_count_temp
    FROM adm_info u
   WHERE u.admin_id = p_warehouse_admin
     And u.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 5;
    c_errormesg := error_msg.ERR_P_WAREHOUSE_CREATE_5;
    RETURN;
  END IF;

  --编码重复管辖
  v_count_temp := 0;

  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_warehouse_managers))) LOOP
    dbms_output.put_line(i.column_value);
  
    IF length(i.column_value) > 0 THEN
    
      v_count_temp := 0;
      SELECT count(u.warehouse_code)
        INTO v_count_temp
        FROM wh_manager u
       WHERE u.manager_id = i.column_value
         And u.is_valid = eboolean.yesorenabled
         And u.warehouse_code <> p_warehouse_code;
    
      IF v_count_temp > 0 THEN
        c_errorcode := 6;
        c_errormesg := i.column_value || error_msg.ERR_P_WAREHOUSE_CREATE_6;
        RETURN;
      END IF;
    
    END IF;
  END LOOP;

  /*----------- 插入数据  -----------------*/
  --update基本信息

  update wh_info
     set warehouse_name = p_warehouse_name,
         org_code       = p_org_code,
         address        = p_warehouse_adds,
         phone          = p_warehouse_phone,
         director_admin = p_warehouse_admin
   where warehouse_code = p_warehouse_code;

  ---更新原来的数据为无效
  update wh_manager
     set is_valid = eboolean.noordisabled
   where warehouse_code = p_warehouse_code;
  update adm_info
     set adm_info.is_warehouse_m = eboolean.noordisabled
   where adm_info.admin_id in
         (select wh_manager.manager_id
            from wh_manager
           where wh_manager.warehouse_code = p_warehouse_code);

  --循环的更新管理员信息，并更新权限信息表
  --原来数据存在则跳过
  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_warehouse_managers))) LOOP
    dbms_output.put_line(i.column_value);
  
    IF length(i.column_value) > 0 THEN
    
      v_count_temp := 0;
    
      SELECT count(u.warehouse_code)
        INTO v_count_temp
        FROM wh_manager u
       WHERE u.manager_id = i.column_value;
    
      IF v_count_temp > 0 THEN
        ---更新账户
        update wh_manager
           set warehouse_code = p_warehouse_code,
               org_code       = p_org_code,
               is_valid       = eboolean.yesorenabled,
               start_time     = sysdate
         where manager_id = i.column_value;
      
      END IF;
    
      IF v_count_temp <= 0 THEN
        ---插入账户
        insert into wh_manager
          (warehouse_code, org_code, manager_id, is_valid, start_time)
        values
          (p_warehouse_code,
           p_org_code,
           i.column_value,
           eboolean.yesorenabled,
           sysdate);
      END IF;
    
      ---更新状态
      update adm_info
         set adm_info.is_warehouse_m = eboolean.yesorenabled
       where adm_info.admin_id = i.column_value;
    
    END IF;
  END LOOP;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END p_warehouse_modify;
/
 
/ 
prompt 正在建立[PROCEDURE -> p_wh_ticket_damage.sql ]...... 
create or replace procedure p_wh_ticket_damage
/****************************************************************/
   ------------------- 票损毁状态更新 -------------------
   ---- add by dzg: 2015/10/29
   ---- 本存储过程不提交，只在最后提交
   ---- modify by dzg :2015/10/31 修改箱子更新bug
   ---- modify by dzg :2015/11/13 更新档损毁子级别，把父级别完整状态拆包
   /*************************************************************/
(
   --------------输入----------------
   p_admin_id        in number,        --操作人员
   p_plan_code       in String,        --方案编号
   p_batch_no        in String,        --批次号
   p_valid_number    in number,        --型号
   p_trunk_no        in String,        --箱号
   p_box_no          in String,        --盒号
   p_package_no      in String         --本号

 ) is


begin
   -- 按照类型，处理正负号
   case
      when p_valid_number in (evalid_number.trunk) then
        
         --更新箱子状态
         update wh_ticket_trunk
            set status = eticket_status.broken,
                change_admin = p_admin_id,
                change_date = sysdate
          where plan_code = p_plan_code
            and batch_no = p_batch_no
            and trunk_no = p_trunk_no;
          
         --盒
         update wh_ticket_box
            set status = eticket_status.broken,
                change_admin = p_admin_id,
                change_date = sysdate
          where plan_code = p_plan_code
            and batch_no = p_batch_no
            and trunk_no = p_trunk_no;
            
            
         --本
         update wh_ticket_package
            set status = eticket_status.broken,
                change_admin = p_admin_id,
                change_date = sysdate
          where plan_code = p_plan_code
            and batch_no = p_batch_no
            and trunk_no = p_trunk_no;
         

      when p_valid_number in (evalid_number.box) then
         
         --更新箱子不完整
         update wh_ticket_trunk
            set is_full      = eboolean.noordisabled,
                change_admin = p_admin_id,
                change_date  = sysdate
          where plan_code = p_plan_code
            and batch_no = p_batch_no
            and trunk_no = p_trunk_no;
         --盒
         update wh_ticket_box
            set status = eticket_status.broken,
                change_admin = p_admin_id,
                change_date = sysdate
          where plan_code = p_plan_code
            and batch_no = p_batch_no
            and box_no = p_box_no;
            
         --本  
         update wh_ticket_package
            set status = eticket_status.broken,
                change_admin = p_admin_id,
                change_date = sysdate
          where plan_code = p_plan_code
            and batch_no = p_batch_no
            and box_no = p_box_no;
         

      when p_valid_number in (evalid_number.pack) then
        
        
         --更新箱子不完整
         update wh_ticket_trunk
            set is_full      = eboolean.noordisabled,
                change_admin = p_admin_id,
                change_date  = sysdate
          where plan_code = p_plan_code
            and batch_no = p_batch_no
            and trunk_no = p_trunk_no;
            
         --更新盒子不完整
         update wh_ticket_box
            set is_full      = eboolean.noordisabled,
                change_admin = p_admin_id,
                change_date = sysdate
          where plan_code = p_plan_code
            and batch_no = p_batch_no
            and box_no = p_box_no;
        
         --本  
         update wh_ticket_package
            set status = eticket_status.broken,
                change_admin = p_admin_id,
                change_date = sysdate
          where plan_code = p_plan_code
            and batch_no = p_batch_no
            and package_no = p_package_no;         

   end case; 

end;
 
/ 
prompt 正在建立[PROCEDURE -> p_withdraw_approve.sql ]...... 
create or replace procedure p_withdraw_approve
/****************************************************************/
   ------------------- 适用财务提现订单财务审批------------------
   ---- 提现审批
   ---- add by dzg: 2015-10-13
   ---- modify 陈震 2015-12-10。 修复bug，去掉销售站余额检查功能
   ---- modify dzg  2016-01-21。 修改bug，增加计入销售员欠款
   ---- 后来发现需要使用申请人，因为管理平台申请时没有填写申请人
   /*************************************************************/
(
 --------------输入----------------

 p_fund_no  in string, --资金编号
 p_admin_id in number, --审批人
 p_result   in number, --审批结果 1 通过 2 拒绝
 p_remark   in string, --审批备注

 ---------出口参数---------
 c_errorcode out number, --错误编码
 c_errormesg out string --错误原因

 ) is

   v_count_temp  number := 0;                                              -- 临时变量
   v_org_code    varchar2(100) := '';                                      -- 机构编码
   v_org_type    number := 0;                                              -- 结构类型
   v_wd_money    number := 0;                                              -- 提现金额
   v_count_temp1 number := 0;                                              -- 临时变量
   v_count_temp2 number := 0;                                              -- 临时变量

   v_acc_no                char(12);                                       -- 账户编码
   v_credit_limit          number(28);                                     -- 信用额度
   v_balance               number(28);                                     -- 账户余额
   v_mm_id                 number:= 0;                                     -- 市场管理员

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   v_count_temp := 0;

   /*----------- 数据校验   -----------------*/

   -- 申请编码不能为空
   if ((p_fund_no is null) or length(p_fund_no) <= 0) then
      c_errorcode := 1;
      c_errormesg := error_msg.err_p_withdraw_approve_1;
      return;
   end if;

   -- 审批结果无效，输入参数不合法
   if not (p_result = 1 or p_result = 2) then
      c_errorcode := 3;
      c_errormesg := error_msg.err_p_withdraw_approve_3;
      return;
   end if;

   -- 编码不存在或者状态无效（如已审批）
   select count(u.fund_no)
     into v_count_temp
     from fund_withdraw u
    where u.fund_no = p_fund_no
      and u.apply_status = eapply_status.applyed;

   if v_count_temp <= 0 then
      c_errorcode := 2;
      c_errormesg := error_msg.err_p_withdraw_approve_2;
      return;
   end if;

   -- 审批不通过，直接处理，然后返回
   if p_result = 2 then
      update fund_withdraw
         set apply_check_time = sysdate,
             check_admin_id   = p_admin_id,
             apply_status     = eapply_status.resused,
             apply_memo       = p_remark
       where fund_no = p_fund_no;

   end if;

   -- 审批通过以后，接着处理后续数据
   if p_result = 1 then

      select w.ao_code, w.account_type, w.apply_amount,w.apply_admin
        into v_org_code, v_org_type, v_wd_money,v_mm_id
        from fund_withdraw w
       where w.fund_no = p_fund_no;
       

      --更新状态
      update fund_withdraw
         set apply_check_time = sysdate,
             check_admin_id   = p_admin_id,
             apply_status     = eapply_status.withdraw,
             apply_memo       = p_remark
       where fund_no = p_fund_no;

      --更新各种账户流水
      case
         when v_org_type = eaccount_type.org then
            p_org_fund_change(v_org_code,
                              eflow_type.withdraw,
                              v_wd_money,
                              0,
                              p_fund_no,
                              v_count_temp1,
                              v_count_temp2);

         when v_org_type = eaccount_type.agency then
            -- 更新余额
            update acc_agency_account
               set account_balance = account_balance - v_wd_money
             where agency_code = v_org_code
               and acc_type = eacc_type.main_account
               and acc_status = eacc_status.available
            returning
               acc_no,   credit_limit,   account_balance
            into
               v_acc_no, v_credit_limit, v_balance;
            if sql%rowcount = 0 then
               raise_application_error(-20001, dbtool.format_line(v_org_code) || error_msg.err_p_fund_change_3);            -- 未发现销售站的账户，或者账户状态不正确
            end if;

            insert into flow_agency
               (agency_fund_flow,      ref_no,    flow_type,           agency_code, acc_no,   change_amount, be_account_balance,     af_account_balance, be_frozen_balance, af_frozen_balance, frozen_amount)
            values
               (f_get_flow_agency_seq, p_fund_no, eflow_type.withdraw, v_org_code,  v_acc_no, v_wd_money,    v_balance + v_wd_money, v_balance,          0,                 0,                 0);
               
            -- 更新市场管理员账户欠款金额
            p_mm_fund_change(v_mm_id, eflow_type.withdraw_for_agency, v_wd_money, p_fund_no, v_count_temp);

      end case;
   end if;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 1;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
 
/ 
prompt 正在建立[PROCEDURE -> p_withdraw_approve_mm.sql ]...... 
CREATE OR REPLACE PROCEDURE p_withdraw_approve_mm
/****************************************************************/
   ------------------- 适用站点提现------------------
   ---- 站点审批，扣减管理员账户欠款
   ---- add by Chen Zhen: 2015-10-13
   /*************************************************************/
(
 --------------输入----------------

 p_fund_no  IN STRING, -- 提现申请编号

 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因

 ) IS

   v_agency_code varchar2(100); -- 销售站
   v_mm_code     number; -- 管理员编码
   v_wd_money    NUMBER; -- 提现金额
   v_count_temp1 NUMBER; -- 临时变量
   v_count_temp2 NUMBER; -- 临时变量

BEGIN

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- 数据校验   -----------------*/

   --申请编码不能为空
   IF ((p_fund_no IS NULL) OR length(p_fund_no) <= 0) THEN
      c_errorcode := 1;
      c_errormesg := error_msg.err_p_withdraw_approve_1;
      RETURN;
   END IF;

   --编码不存在或者状态无效（如已审批）
   begin
      SELECT AO_CODE, APPLY_AMOUNT, MARKET_ADMIN
        INTO v_agency_code, v_wd_money, v_mm_code
        FROM fund_withdraw
       WHERE fund_no = p_fund_no
         And apply_status = eapply_status.applyed;
   exception
      when no_data_found then
         c_errorcode := 2;
         c_errormesg := error_msg.err_p_withdraw_approve_2;
         RETURN;

   end;

   -- 扣减销售站余额
   p_agency_fund_change(v_agency_code,
                        eflow_type.withdraw,
                        v_wd_money,
                        0,
                        p_fund_no,
                        v_count_temp1,
                        v_count_temp2);

   -- 检查余额是否足够
   IF v_count_temp1 < 0 THEN

      update fund_withdraw
         set apply_check_time = sysdate,
             check_admin_id   = v_mm_code,
             apply_status     = eapply_status.resused,
             apply_memo       = 'Sorry, agency[' || v_agency_code || '] balance has been insufficient. [AUTO Apply]'
       where fund_no = p_fund_no;

      c_errorcode := 4;
      c_errormesg := error_msg.err_p_withdraw_approve_4;

      rollback;
      RETURN;
   END IF;

   --更新审批状态
   update fund_withdraw
      set apply_check_time = sysdate,
          check_admin_id   = v_mm_code,
          apply_status     = eapply_status.withdraw,
          apply_memo       = '[AUTO Apply]'
    where fund_no = p_fund_no;

   -- 更新市场管理员账户欠款金额
   p_mm_fund_change(v_mm_code, eflow_type.withdraw_for_agency, v_wd_money, p_fund_no, v_count_temp1);

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      c_errorcode := 1;
      c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
 
/ 
prompt 正在建立[TRIGGER -> trig_in_af_inf_agencys.sql ]...... 
CREATE OR REPLACE TRIGGER trig_in_af_inf_agencys
  AFTER INSERT
    ON inf_agencys
  FOR EACH ROW
DECLARE
BEGIN
  -- 增加游戏授权
  insert into auth_agency
    (agency_code, game_code, pay_commission_rate, sale_commission_rate, allow_pay, allow_sale, allow_cancel, claiming_scope)
  select
    :new.agency_code, game_code, 0, 0, 0, 0, 0, 1
  from inf_games;

  RETURN;
exception
   when others then
      return;
END;
 
/ 
prompt 正在建立[TRIGGER -> trig_in_af_inf_orgs.sql ]...... 
CREATE OR REPLACE TRIGGER trig_in_af_inf_orgs
  AFTER INSERT
    ON inf_orgs
  FOR EACH ROW
DECLARE
BEGIN
  -- 增加游戏授权
  insert into auth_org
    (org_code, game_code, pay_commission_rate, sale_commission_rate, auth_time, allow_pay, allow_sale, allow_cancel)
  select
    :new.org_code, game_code, 0, 0, sysdate, 0, 0, 0
  from inf_games;

  RETURN;
exception
   when others then
      return;
END;
 
/ 
prompt 正在建立视图view ...... 01_create_view_kws.sql 
/**************************************************************************/
/*************************    字典视图     *************************/
/**************************************************************************/
create or replace view v_dict_all_game as
-- 即开票
select plan_code, SHORT_NAME, FULL_NAME, 1 sys_type from game_plans
union all
-- 电脑票
select to_char(game_code), SHORT_NAME, FULL_NAME, 2 sys_type from inf_games
--增加爱心
union all 
select 'J2014' as plan_code,'Love','Love',1 sys_type from dual;

/**************************************************************************/
/*************************    数据视图     *************************/
/**************************************************************************/
-- 《即开票管理系统需求分析说明书》 3.17.3.1	部门销售报表(Institution Sales Reports)
-- Sales Report + Institution Sales Reports
create or replace view v_report_sale_pay as
-- 即开票
with sale as
 (select to_char(sale_time, 'yyyy-mm-dd') sale_day,
         to_char(sale_time, 'yyyy-mm') sale_month,
         area_code,
         org_code,
         f_get_old_plan_name(plan_code, batch_no) plan_code,
         sum(sale_amount) sale_amount,
         sum(comm_amount) as sale_comm
    from flow_sale
   where sale_time >= trunc(sysdate)
     and sale_time <  trunc(sysdate) + 1
   group by area_code,
            org_code,
            f_get_old_plan_name(plan_code, batch_no),
            to_char(sale_time, 'yyyy-mm-dd'),
            to_char(sale_time, 'yyyy-mm')),
cancel as
 (select to_char(cancel_time, 'yyyy-mm-dd') sale_day,
         to_char(cancel_time, 'yyyy-mm') sale_month,
         area_code,
         org_code,
         f_get_old_plan_name(plan_code, batch_no) plan_code,
         sum(sale_amount) cancel_amount,
         sum(comm_amount) as cancel_comm
    from flow_cancel
   where cancel_time >= trunc(sysdate)
     and cancel_time <  trunc(sysdate) + 1
   group by area_code,
            org_code,
            f_get_old_plan_name(plan_code, batch_no),
            to_char(cancel_time, 'yyyy-mm-dd'),
            to_char(cancel_time, 'yyyy-mm')),
pay_detail as
 (select to_char(pay_time, 'yyyy-mm-dd') sale_day,
         to_char(pay_time, 'yyyy-mm') sale_month,
         area_code,
         f_get_flow_pay_org(pay_flow) org_code,
         f_get_old_plan_name(plan_code, batch_no) plan_code,
         pay_amount,
         nvl(comm_amount, 0) comm_amount
    from flow_pay
   where pay_time >= trunc(sysdate)
     and pay_time <  trunc(sysdate) + 1),
pay as
 (select sale_day,
         sale_month,
         area_code,
         org_code,
         plan_code,
         sum(pay_amount) pay_amount,
         sum(comm_amount) as pay_comm
    from pay_detail
   group by sale_day, sale_month, area_code, org_code, plan_code),
pre_detail as (
   select sale_day, sale_month, area_code, org_code, plan_code, sale_amount, sale_comm, 0 as cancel_amount, 0 as cancel_comm, 0 as pay_amount, 0 as pay_comm from sale
    union all
   select sale_day, sale_month, area_code, org_code, plan_code, 0 as sale_amount, 0 as sale_comm, cancel_amount, cancel_comm, 0 as pay_amount, 0 as pay_comm from cancel
    union all
   select sale_day, sale_month, area_code, org_code, plan_code, 0 as sale_amount, 0 as sale_comm, 0 as cancel_amount, 0 as cancel_comm, pay_amount, pay_comm from pay
),
-- 电脑票
lot_sale as
 (select to_char(SALETIME, 'yyyy-mm-dd') sale_day,
         to_char(SALETIME, 'yyyy-mm') sale_month,
         area_code,
         org_code,
         f_get_game_name(game_code) plan_code,
         sum(TICKET_AMOUNT) lot_sale_amount,
         sum(COMMISSIONAMOUNT) as lot_sale_comm
    from his_sellticket join inf_agencys
      on his_sellticket.agency_code=inf_agencys.agency_code
      and SALETIME >= trunc(sysdate)
      and SALETIME <  trunc(sysdate) + 1
      group by area_code,
            org_code,
            f_get_game_name(game_code),
            to_char(SALETIME, 'yyyy-mm-dd'),
            to_char(SALETIME, 'yyyy-mm')),
lot_cancel as
 (select to_char(CANCELTIME, 'yyyy-mm-dd') sale_day,
         to_char(CANCELTIME, 'yyyy-mm') sale_month,
     f_get_agency_area(his_cancelticket.applyflow_sell) area_code,
         org_code,
         f_get_game_name(game_code) plan_code,
         sum(TICKET_AMOUNT) lot_cancel_amount,
         sum(COMMISSIONAMOUNT) as lot_cancel_comm
    from his_cancelticket join his_sellticket
      on his_cancelticket.applyflow_sell=his_sellticket.applyflow_sell
      and  CANCELTIME >= trunc(sysdate)
      and CANCELTIME <  trunc(sysdate) + 1  
      group by f_get_agency_area(his_cancelticket.applyflow_sell),
            org_code,
            f_get_game_name(game_code),
            to_char(CANCELTIME, 'yyyy-mm-dd'),
            to_char(CANCELTIME, 'yyyy-mm')),    
lot_pay as
 (select to_char(PAYTIME, 'yyyy-mm-dd') sale_day,
         to_char(PAYTIME, 'yyyy-mm') sale_month,
         f_get_agency_area(applyflow_sell) area_code,
         org_code,
         f_get_game_name(game_code) plan_code,
         sum(winningamount) lot_pay_amount,
         sum(commissionamount) lot_pay_comm
    from his_payticket
   where PAYTIME >= trunc(sysdate)
     and PAYTIME <  trunc(sysdate) + 1
   group by to_char(PAYTIME, 'yyyy-mm-dd'),
            to_char(PAYTIME, 'yyyy-mm'),
            f_get_agency_area(applyflow_sell),
            org_code,
            f_get_game_name(game_code)),
lot_pre_detail as (
   select sale_day, sale_month, area_code, org_code, plan_code, lot_sale_amount, lot_sale_comm, 0 as lot_cancel_amount, 0 as lot_cancel_comm, 0 as lot_pay_amount, 0 as lot_pay_comm from lot_sale
    union all
   select sale_day, sale_month, area_code, org_code, plan_code, 0 as lot_sale_amount, 0 as lot_sale_comm, lot_cancel_amount, lot_cancel_comm, 0 as lot_pay_amount, 0 as lot_pay_comm from lot_cancel
    union all
   select sale_day, sale_month, area_code, org_code, plan_code, 0 as lot_sale_amount, 0 as lot_sale_comm, 0 as lot_cancel_amount, 0 as lot_cancel_comm, lot_pay_amount, lot_pay_comm from lot_pay
)
--计开票
select sale_day, sale_month, nvl(area_code, 'NONE') area_code, org_code, plan_code,
       nvl(sum(sale_amount), 0) sale_amount,
       nvl(sum(sale_comm), 0) sale_comm,
       nvl(sum(cancel_amount), 0) cancel_amount,
       nvl(sum(cancel_comm), 0) cancel_comm,
       nvl(sum(pay_amount), 0) pay_amount,
       nvl(sum(pay_comm), 0) pay_comm,
       (nvl(sum(sale_amount), 0) - nvl(sum(sale_comm), 0) - nvl(sum(pay_amount), 0) - nvl(sum(pay_comm), 0) - nvl(sum(cancel_amount), 0) + nvl(sum(cancel_comm), 0)) incoming
  from pre_detail
 group by sale_day, sale_month, area_code, org_code, plan_code
union all
--电脑票
select sale_day, sale_month, nvl(area_code, 'NONE') area_code, org_code, to_char(plan_code),
       nvl(sum(lot_sale_amount), 0) sale_amount,
       nvl(sum(lot_sale_comm), 0) sale_comm,
       nvl(sum(lot_cancel_amount), 0) cancel_amount,
       nvl(sum(lot_cancel_comm), 0) cancel_comm,
       nvl(sum(lot_pay_amount), 0) pay_amount,
       nvl(sum(lot_pay_comm), 0) pay_comm,
       (nvl(sum(lot_sale_amount), 0) - nvl(sum(lot_sale_comm), 0) - nvl(sum(lot_pay_amount), 0) - nvl(sum(lot_pay_comm), 0) - nvl(sum(lot_cancel_amount), 0) + nvl(sum(lot_cancel_comm), 0)) incoming
  from lot_pre_detail
 group by sale_day, sale_month, area_code, org_code, plan_code
union all
select SALE_DATE, SALE_MONTH, (case when AREA_CODE='NULL' then null else AREA_CODE end) AREA_CODE, ORG_CODE, PLAN_CODE, SALE_AMOUNT, SALE_COMM, CANCEL_AMOUNT, CANCEL_COMM, PAY_AMOUNT, PAY_COMM, INCOMING from his_sale_pay_cancel;

-- 《即开票管理系统需求分析说明书》 3.17.3.3 兑奖统计报表(Payout Reports)
-- Payout Reports
create or replace view v_report_pay_level as
with
pay_detail as
   (select to_char(sysdate, 'yyyy-mm-dd') sale_day,
           to_char(sysdate, 'yyyy-mm') sale_month,
           f_get_old_plan_name(plan_code,batch_no) PLAN_CODE,
           (case when REWARD_NO = 1 then PAY_AMOUNT else 0 end) level_1,
           (case when REWARD_NO = 2 then PAY_AMOUNT else 0 end) level_2,
           (case when REWARD_NO = 3 then PAY_AMOUNT else 0 end) level_3,
           (case when REWARD_NO = 4 then PAY_AMOUNT else 0 end) level_4,
           (case when REWARD_NO = 5 then PAY_AMOUNT else 0 end) level_5,
           (case when REWARD_NO = 6 then PAY_AMOUNT else 0 end) level_6,
           (case when REWARD_NO = 7 then PAY_AMOUNT else 0 end) level_7,
           (case when REWARD_NO = 8 then PAY_AMOUNT else 0 end) level_8,
           (case when REWARD_NO in (9,10,11,12,13) then PAY_AMOUNT else 0 end) level_other,
           PAY_AMOUNT,
           f_get_flow_pay_org(PAY_FLOW) ORG_CODE
      from FLOW_PAY
	 where PAY_TIME >= trunc(sysdate)
       and PAY_TIME < trunc(sysdate+1))
select sale_day,
       sale_month,
       ORG_CODE,
       PLAN_CODE,
       sum(level_1) as level_1,
       sum(level_2) as level_2,
       sum(level_3) as level_3,
       sum(level_4) as level_4,
       sum(level_5) as level_5,
       sum(level_6) as level_6,
       sum(level_7) as level_7,
       sum(level_8) as level_8,
       sum(level_other) as level_other,
       sum(PAY_AMOUNT) as total
  from pay_detail
 group by sale_day,
          sale_month,
          ORG_CODE,
          PLAN_CODE
union all
select * from HIS_PAY_LEVEL;

-- 《即开票管理系统需求分析说明书》 3.17.4.1 仓库库存报表(Wareahouse Inventory Reports)
create or replace view v_report_lot_inventory as
with total as
 (select to_char(sysdate, 'yyyy-mm-dd') calc_date,
         plan_code,
         batch_no,
         reward_group,
         tab.status,
         nvl(current_warehouse, '[null]') warehouse,
         sum(tickets_every_pack) tickets
    from wh_ticket_package tab
    join game_batch_import_detail
   using (plan_code, batch_no)
   group by plan_code,
            batch_no,
            reward_group,
            tab.status,
            nvl(current_warehouse, '[null]')),
today as
 (select calc_date,
         plan_code,
         batch_no,
         reward_group,
         status,
         warehouse,
         tickets,
         tickets * ticket_amount amount
    from total
    join game_plans
   using (plan_code)),
today_stat as
 (select CALC_DATE,
         PLAN_CODE,
         f_get_plan_name(plan_code) plan_name,
         WAREHOUSE,
         sum(TICKETS) tickets,
         sum(amount) amount
    from today
   where status = 11
   group by CALC_DATE, PLAN_CODE, WAREHOUSE),
his_stat as
 (select CALC_DATE,
         PLAN_CODE,
         f_get_plan_name(plan_code) plan_name,
         WAREHOUSE,
         sum(TICKETS) tickets,
         sum(amount) amount
    from HIS_LOTTERY_INVENTORY
   where status = 11
   group by CALC_DATE, PLAN_CODE, WAREHOUSE),
all_stat as
 (select CALC_DATE, PLAN_CODE, plan_name, WAREHOUSE, tickets, amount
    from today_stat
  union all
  select CALC_DATE, PLAN_CODE, plan_name, WAREHOUSE, tickets, amount
    from his_stat)
select CALC_DATE, PLAN_CODE, plan_name, WAREHOUSE, tickets, amount
  from all_stat
 order by CALC_DATE desc;

-- 《即开票管理系统需求分析说明书》 3.17.1.1 部门资金统计报表(Institution Fund Statistics Reports)
-- 机构资金历史报表(历史+实时)
create or replace view v_his_org_fund_report as
with today_flow as
 (select AGENCY_CODE,
         FLOW_TYPE,
         sum(CHANGE_AMOUNT) amount,
         0 as BE_ACCOUNT_BALANCE,
         0 as AF_ACCOUNT_BALANCE
    from flow_agency
   where TRADE_TIME >= trunc(sysdate)
     and TRADE_TIME < trunc(sysdate) + 1
   group by AGENCY_CODE, FLOW_TYPE),
today_balance as
 (select AGENCY_CODE,
         0 as FLOW_TYPE,
         0 as amount,
         sum(BE_ACCOUNT_BALANCE) BE_ACCOUNT_BALANCE,
         sum(AF_ACCOUNT_BALANCE) AF_ACCOUNT_BALANCE
    from (select AGENCY_CODE,
                 0               as BE_ACCOUNT_BALANCE,
                 ACCOUNT_BALANCE as AF_ACCOUNT_BALANCE
            from acc_agency_account
          union all
          select AGENCY_CODE,
                 AF_ACCOUNT_BALANCE as BE_ACCOUNT_BALANCE,
                 0                  as AF_ACCOUNT_BALANCE
            from his_agency_fund
           where CALC_DATE = to_char(sysdate - 1, 'yyyy-mm-dd'))
   group by AGENCY_CODE),
agency_fund as
 (select AGENCY_CODE,
         FLOW_TYPE,
         amount,
         BE_ACCOUNT_BALANCE,
         AF_ACCOUNT_BALANCE
    from today_flow
  union all
  select AGENCY_CODE,
         FLOW_TYPE,
         amount,
         BE_ACCOUNT_BALANCE,
         AF_ACCOUNT_BALANCE
    from today_balance),
base as
 (select org_code,
         FLOW_TYPE,
         sum(AMOUNT) as amount,
         sum(BE_ACCOUNT_BALANCE) as BE_ACCOUNT_BALANCE,
         sum(AF_ACCOUNT_BALANCE) as AF_ACCOUNT_BALANCE
    from agency_fund
    join inf_agencys
   using (agency_code)
   group by org_code, FLOW_TYPE),
center_pay as
 (select f_get_flow_pay_org(pay_flow) org_code, sum(pay_amount) amount
       from flow_pay
      where pay_time >= trunc(sysdate)
        and pay_time < trunc(sysdate) + 1
        and is_center_paid = 1
      group by f_get_flow_pay_org(pay_flow)),
center_pay_comm as
 (select org_code, FLOW_TYPE, sum(change_amount) amount
    from flow_org
   where TRADE_TIME >= trunc(sysdate)
     and TRADE_TIME < trunc(sysdate) + 1
     and FLOW_TYPE in (23, 35, 36, 37, 38)
   group by org_code, FLOW_TYPE),
agency_balance as
 (select * from (select org_code, BE_ACCOUNT_BALANCE, AF_ACCOUNT_BALANCE
    from base
   where flow_type = 0)
   unpivot (amount for flow_type in (BE_ACCOUNT_BALANCE as 88, AF_ACCOUNT_BALANCE as 99))),
fund as
 (select *
    from (select org_code, FLOW_TYPE, AMOUNT from base
             union all
             select org_code, FLOW_TYPE, AMOUNT from agency_balance
             union all
             select org_code, FLOW_TYPE, AMOUNT from center_pay_comm
             union all
             select org_code, 20 FLOW_TYPE, AMOUNT from center_pay)
  pivot(sum(amount)
     for FLOW_TYPE in(1 as charge,
                     2 as withdraw,
                     5 as sale_comm,
                     6 as pay_comm,
                     7 as sale,
                     8 as paid,
                     11 as rtv,
                     13 as rtv_comm,
                     20 as center_pay,
                     23 as center_pay_comm,
                     45 as lot_sale,
                     43 as lot_sale_comm,
                     41 as lot_paid,
                     44 as lot_pay_comm,
                     42 as lot_rtv,
                     47 as lot_rtv_comm,
                     36 as lot_center_pay_comm,
                     37 as lot_center_pay,
                     38 as lot_center_rtv,
					 35 as lot_center_rtv_comm,
                     88 as be,
                     99 as af))),
pre_detail as
 (select org_code,
         nvl(be, 0) be_account_balance,
         nvl(charge, 0) charge,
         nvl(withdraw, 0) withdraw,
         nvl(sale, 0) sale,
         nvl(sale_comm, 0) sale_comm,
         nvl(paid, 0) paid,
         nvl(pay_comm, 0) pay_comm,
         nvl(rtv, 0) rtv,
         nvl(rtv_comm, 0) rtv_comm,
         nvl(center_pay, 0) center_pay,
         nvl(center_pay_comm, 0) center_pay_comm,
         nvl(lot_sale, 0) lot_sale,
         nvl(lot_sale_comm, 0) lot_sale_comm,
         nvl(lot_paid, 0) lot_paid,
         nvl(lot_pay_comm, 0) lot_pay_comm,
         nvl(lot_rtv, 0) lot_rtv,
         nvl(lot_rtv_comm, 0) lot_rtv_comm,
         nvl(lot_center_pay, 0) lot_center_pay,
         nvl(lot_center_pay_comm, 0) lot_center_pay_comm,
         nvl(lot_center_rtv, 0) lot_center_rtv,
		 (case 2 when (select org_type from inf_orgs where org_code=fund.org_code) then (nvl(lot_center_rtv_comm, 0) - nvl(lot_rtv_comm, 0))  else nvl(lot_center_rtv_comm, 0) end) lot_center_rtv_comm,
         nvl(af, 0) af_account_balance
    from fund),
today_result as (
select to_char(sysdate, 'yyyy-mm-dd') CALC_DATE,
       org_code,
          -- 通用
          be_account_balance, af_account_balance,          charge,          withdraw,
          (sale - sale_comm - paid - pay_comm - rtv + rtv_comm - center_pay - center_pay_comm + lot_sale - lot_sale_comm - lot_paid - lot_pay_comm - lot_rtv + lot_rtv_comm - lot_center_pay - lot_center_pay_comm - lot_center_rtv + lot_center_rtv_comm) incoming,
          (charge - withdraw - center_pay - center_pay_comm - lot_center_pay - lot_center_pay_comm  - lot_rtv - lot_rtv_comm - lot_center_rtv - lot_center_rtv_comm) pay_up,
          -- 即开票
          sale,                sale_comm,              paid,      pay_comm,     rtv,       rtv_comm,     center_pay,     center_pay_comm,
          -- 电脑票
          lot_sale,            lot_sale_comm,          lot_paid,  lot_pay_comm, lot_rtv,   lot_rtv_comm, lot_center_pay, lot_center_pay_comm, lot_center_rtv, 
		  lot_center_rtv_comm
  from pre_detail)
select calc_date, org_code, be_account_balance, charge, withdraw, sale, sale_comm, paid, pay_comm, rtv, rtv_comm, center_pay, center_pay_comm, lot_sale, lot_sale_comm, lot_paid, lot_pay_comm, lot_rtv, lot_rtv_comm, lot_center_pay, lot_center_pay_comm, lot_center_rtv, lot_center_rtv_comm, af_account_balance, incoming, pay_up from his_org_fund_report
union all
select calc_date, org_code, be_account_balance, charge, withdraw, sale, sale_comm, paid, pay_comm, rtv, rtv_comm, center_pay, center_pay_comm, lot_sale, lot_sale_comm, lot_paid, lot_pay_comm, lot_rtv, lot_rtv_comm, lot_center_pay, lot_center_pay_comm, lot_center_rtv, lot_center_rtv_comm, af_account_balance, incoming, pay_up from today_result
;


-- 销售与退货明细
create or replace view v_trade_detail as
with sales_flow as
 (select 7 as trade_type, agency_code, trade_time, ref_no
    from flow_agency
   where flow_type = 7),
sales_detail as
 (select SEQUENCE_NO,
         trade_type,
         agency_code,
         trade_time,
         plan_code,
         batch_no,
         TRUNK_NO,
         BOX_NO,
         PACKAGE_NO,
         TICKETS,
         AMOUNT
    from WH_GOODS_RECEIPT_DETAIL
    join sales_flow
   using (ref_no)),
return_flow as
 (select 11 as trade_type, agency_code, trade_time, ref_no
    from flow_agency
   where flow_type = 11),
return_detail as
 (select SEQUENCE_NO,
         trade_type,
         agency_code,
         trade_time,
         plan_code,
         batch_no,
         TRUNK_NO,
         BOX_NO,
         PACKAGE_NO,
         TICKETS,
         AMOUNT
    from WH_GOODS_issue_DETAIL
    join return_flow
   using (ref_no)),
all_detail as
 (select * from sales_detail union all select * from return_detail)
select trade_type,
       agency_code,
       trade_time,
       plan_code,
       batch_no,
       TRUNK_NO,
       BOX_NO,
       PACKAGE_NO,
       TICKETS,
       AMOUNT
  from all_detail
 order by SEQUENCE_NO;

 -- 《即开票管理系统需求分析说明书》 3.17.4.2 市场管理员库存日结报表(MM Inventory Daily Report)
 -- 市场管理员库存日结
 create or replace view v_his_mm_inventory as
 select CALC_DATE,
       WAREHOUSE MARKET_ADMIN,
       PLAN_CODE,
       BATCH_NO,
       sum(TICKETS) TICKETS,
       sum(AMOUNT) AMOUNT
  from his_lottery_inventory
 where STATUS = 21
 group by CALC_DATE, WAREHOUSE, PLAN_CODE, BATCH_NO;

 -- 市场管理员库存状态实时查询
create or replace view v_now_mm_inventory as
select current_warehouse market_admin,
       plan_code,
       sum(ticket_no_end - ticket_no_start + 1) tickets,
       count(*) packages
  from wh_ticket_package
 where status = 21
 group by current_warehouse, plan_code;

-- 《即开票管理系统需求分析说明书》 3.17.4.3 部门库存日结报表(Institution Daily Report)
-- 部门库存查询
create or replace view v_his_org_inventory as
with base as (
  select *
  from his_org_inv_report),
base_t as (
   select * from base
   pivot(sum(tickets) as tickets, sum(amount) as amount
      for oper_type in(1 as tb_out,
                       4 as agency_return,
                       12 as tb_in,
                       14 as agency_sale,
                       20 as broken,
                       66 as mm_open,
                       77 as mm_close,
                       88 as opening,
                       99 as closing))),
base_no_null as (
   select calc_date, org_code, plan_code,
          nvl(tb_out_tickets, 0) tb_out_tickets,
          nvl(tb_out_amount, 0) tb_out_amount,
          nvl(agency_return_tickets, 0) agency_return_tickets,
          nvl(agency_return_amount, 0) agency_return_amount,
          nvl(tb_in_tickets, 0) tb_in_tickets,
          nvl(tb_in_amount, 0) tb_in_amount,
          nvl(agency_sale_tickets, 0) agency_sale_tickets,
          nvl(agency_sale_amount, 0) agency_sale_amount,
          nvl(broken_tickets, 0) broken_tickets,
          nvl(broken_amount, 0) broken_amount,
          nvl(opening_tickets, 0) opening_tickets,
          nvl(opening_amount, 0) opening_amount,
          nvl(closing_tickets, 0) closing_tickets,
          nvl(closing_amount, 0) closing_amount,
          nvl(mm_open_tickets, 0) mm_open_tickets,
          nvl(mm_open_amount, 0) mm_open_amount,
          nvl(mm_close_tickets, 0) mm_close_tickets,
          nvl(mm_close_amount, 0) mm_close_amount
     from base_t)
select calc_date, org_code, plan_code,
       tb_out_tickets,
       tb_out_amount,
       agency_return_tickets,
       agency_return_amount,
       tb_in_tickets,
       tb_in_amount,
       agency_sale_tickets,
       agency_sale_amount,
       broken_tickets,
       broken_amount,
       opening_tickets + mm_open_tickets   opening_tickets,
       opening_amount + mm_open_amount     opening_amount,
       closing_tickets + mm_close_tickets     closing_tickets,
       closing_amount + mm_close_amount       closing_amount
  from base_no_null;

--《即开票管理系统需求分析说明书》 3.17.1.4 部门应缴款报表(Institution Payable Report)
-- 部门应缴明细
create or replace view v_his_fund_pay_up as
   with base as
    (select f_get_agency_org(AGENCY_CODE) org_code,flow_type ,sum(CHANGE_AMOUNT) amount
       from flow_agency
      where FLOW_TYPE in (1, 2)
        and TRADE_TIME >= trunc(sysdate) and TRADE_TIME < trunc(sysdate) + 1
      group by  f_get_agency_org(AGENCY_CODE) ,flow_type),
   center_pay as
    (select f_get_flow_pay_org(pay_flow) org_code, sum(pay_amount) amount
       from flow_pay
      where pay_time >= trunc(sysdate)
        and pay_time < trunc(sysdate) + 1
        and is_center_paid = 1
      group by f_get_flow_pay_org(pay_flow)),
   center_pay_comm as
    (select org_code, sum(change_amount) amount
       from flow_org
      where TRADE_TIME >= trunc(sysdate)
        and TRADE_TIME < trunc(sysdate) + 1
        and FLOW_TYPE = 23
      group by org_code),
   fund as
    (select *
       from (select org_code, FLOW_TYPE, AMOUNT from base
             union all
             select org_code, 8 FLOW_TYPE, AMOUNT from center_pay
             union all
             select org_code, 21 FLOW_TYPE, AMOUNT from center_pay_comm
            ) pivot(sum(amount) for FLOW_TYPE in(1 as charge, 2 as withdraw, 8 as paid, 21 as paid_comm)))
   select to_char(sysdate, 'yyyy-mm-dd') CALC_DATE,
          org_code,nvl(charge, 0) charge,
          nvl(withdraw, 0) withdraw,
          nvl(paid, 0) CENTER_PAID,
          nvl(paid_comm, 0) center_paid_comm,
          (nvl(charge, 0) - nvl(withdraw, 0) - nvl(paid, 0) + nvl(paid_comm, 0)) pay_up
     from inf_orgs left join fund using (org_code)
union all
select calc_date,org_code,charge,withdraw,center_paid,center_paid_comm,pay_up from his_org_fund;

--《即开票管理系统需求分析说明书》3.17.1.5 代理商资金报表(Agent Fund Report)
-- 代理商资金报表 
create or replace view v_his_agent_fund_report as
with
   agent_org as (
      select org_code from inf_orgs where org_type = 2),
   today as (
      select org_code, flow_type, sum(change_amount) amount
        from flow_org
       where trade_time >= trunc(sysdate)
         and trade_time < trunc(sysdate) + 1
         and org_code in (select org_code from agent_org)
       group by org_code, flow_type),
   last_day as (
      select org_code, 88 as flow_type, amount
        from his_agent_fund_report
       where org_code in (select org_code from agent_org)
         and flow_type = 99
         and calc_date = to_char(trunc(sysdate) - 1, 'yyyy-mm-dd')),
   nowf as (
      select org_code, 99 as flow_type, account_balance amount
        from acc_org_account
       where org_code in (select org_code from agent_org)),
   all_result as (
      select to_char(trunc(sysdate), 'yyyy-mm-dd') calc_date, org_code, flow_type, amount from today
      union all
      select to_char(trunc(sysdate), 'yyyy-mm-dd') calc_date, org_code, flow_type, amount from last_day
      union all
      select to_char(trunc(sysdate), 'yyyy-mm-dd') calc_date, org_code, flow_type, amount from nowf
      union all
      select calc_date, org_code, flow_type, amount from his_agent_fund_report),
   turn_result as (
      select *
        from all_result pivot(
                                         sum(amount) as amount for FLOW_TYPE in (1  as charge             ,
                                                                                 2  as withdraw           ,
                                                                                 3  as sale               ,
                                                                                 4  as org_comm           ,
                                                                                 12 as org_return         ,
                                                                                 25 as org_comm_org_return,
                                                                                 -- 即开票
                                                                                 21 as org_agency_pay_comm,
                                                                                 22 as org_agency_pay     ,
                                                                                 23 as org_center_pay_comm,
                                                                                 24 as org_center_pay     ,
                                                                                 -- 电脑票
                                                                                 30 as lot_agency_sale,
                                                                                 32 as lot_org_agency_pay_comm,
                                                                                 33 as lot_org_agency_pay     ,
                                                                                 36 as lot_org_center_pay_comm,
                                                                                 37 as lot_org_center_pay     ,
                                                                                 38 as lot_org_center_cancel,
                                                                                 34 as lot_agency_sale_comm,
                                                                                 35 as lot_agency_cancel_comm,
                                                                                 -- 余额
                                                                                 88 as begining,
                                                                                 99 as ending
                                                                                )
                                        )
                  )
select * from turn_result;
prompt 正在建立视图view ...... 02_create_view_taishan.sql 
/******************************************/
/** 创建普通功能视图 **/

-- 获取当前正在生效的游戏历史参数
create or replace view v_gp_his_current
as
select his_his_code, game_code, is_open_risk, risk_param
  from gp_history
 where (his_his_code, game_code) in
       (select max(his_his_code), game_code
          from gp_history
         group by game_code);

-- 获取当前正在生效的游戏政策参数
create or replace view v_gp_policy_current
as
select his_policy_code,
       game_code,
       theory_rate,
       fund_rate,
       adj_rate,
       tax_threshold,
       tax_rate,
       draw_limit_day
  from gp_policy
 where (his_policy_code, game_code) in
       (select max(his_policy_code), game_code
          from gp_policy
         group by game_code);

-- 获取当前正在生效的游戏玩法规则
create or replace view v_gp_rule_current
as
select his_rule_code,
       game_code,
       rule_code,
       rule_name,
       rule_desc,
       rule_enable
  from gp_rule
 where (his_rule_code, game_code, rule_code) in
       (select max(his_rule_code), game_code, rule_code
          from gp_rule
         group by game_code, rule_code);

-- 获取当前正在生效的游戏中奖规则
create or replace view v_gp_win_rule_current
as
select his_win_code, game_code, wrule_code, wrule_name, wrule_desc
  from gp_win_rule
 where (his_win_code, game_code, wrule_code) in
       (select max(his_win_code), game_code, wrule_code
          from gp_win_rule
         group by game_code, wrule_code);

-- 获取当前正在生效的游戏奖级规则
create or replace view v_gp_prize_rule_current
as
select his_prize_code,
       game_code,
       prule_level,
       prule_name,
       prule_desc,
       level_prize,
       disp_order
  from gp_prize_rule
 where (his_prize_code, game_code, prule_level) in
       (select max(his_prize_code), game_code, prule_level
          from gp_prize_rule
         group by game_code, prule_level);

-- 游戏普通规则参数
create or replace view v_gp_normal_rule
as
select gps.game_code,
       draw_mode,
       singlebet_amount,
       singleticket_max_issues,
       singleline_max_amount,
       singleticket_max_line,
       singleticket_max_amount,
       abandon_reward_collect
  from gp_static gps, gp_dynamic gpd
 where gps.game_code=gpd.game_code;

-- 游戏控制参数
create or replace view v_gp_control
as
select gps.game_code,
       limit_big_prize,
       limit_payment,
       limit_payment2,
       limit_cancel2,
       cancel_sec,
       saler_pay_limit,
       saler_cancel_limit,
       issue_close_alert_time
  from gp_static gps, gp_dynamic gpd
 where gps.game_code=gpd.game_code;

-- 期次列表中奖信息详情
create or replace view v_game_issue_prize_detail
as
select agency_code,
       agency_name,
       org_code area_code,
       org_name area_name,
       game_code,
       issue_number,
       prize_level,
       prize_name,
       is_hd_prize,
       winning_count,
       single_bet_reward
  from mis_agency_win_stat detail
  left join inf_agencys using(agency_code)
  left join inf_orgs using(org_code);

-- 监控用的期次列表
create or replace view v_mon_game_issue as
select game_code,
       issue_number,
       issue_status,
       (case
           when plan_start_time is null then
            null
           when real_start_time is null then
            plan_start_time
           else
            real_start_time
        end) as real_start_time,
       (case
           when plan_close_time is null then
            null
           when real_close_time is null then
            plan_close_time
           else
            real_close_time
        end) as real_close_time,
       (case
           when plan_reward_time is null then
            null
           when real_reward_time is null then
            plan_reward_time
           else
            real_reward_time
        end) as real_reward_time,
       issue_end_time,
       (select is_open_risk
          from gp_history
         where his_his_code = (select his_his_code
                                 from iss_current_param
                                where game_code = iss_game_issue.game_code
                                  and issue_number = iss_game_issue.issue_number)
           and game_code = iss_game_issue.game_code) as risk_status,
       (select risk_param
          from gp_history
         where his_his_code = (select his_his_code
                                 from iss_current_param
                                where game_code = iss_game_issue.game_code
                                  and issue_number = iss_game_issue.issue_number)
           and game_code = iss_game_issue.game_code) as risk_param,
       pool_start_amount,
       (select admin_realname
          from adm_info
         where admin_id = first_draw_user_id) first_draw_user,
       (select admin_realname
          from adm_info
         where admin_id = second_draw_user_id) second_draw_user,
       pool_close_amount,
       final_draw_number,
       issue_sale_amount,
       issue_sale_tickets,
       issue_cancel_amount,
       issue_cancel_tickets,
       winning_amount
  from iss_game_issue;

---------------------------------------------------------------------------
------------                  mis报表用               ---------------------
---------------------------------------------------------------------------

-- 多期票销售视图
create or replace view v_multi_sell
as
select applyflow_sell,
       saletime,
       terminal_code,
       teller_code,
       agency_code,
       game_code,
       issue_number,
       start_issue,
       end_issue,
       issue_count,
       ticket_amount,
       ticket_bet_count,
       salecommissionrate,
       commissionamount,
       bet_methold,
       bet_line,
       loyalty_code,
       result_code,
       sell_seq
  from his_sellticket
 where applyflow_sell in
       (select applyflow_sell from his_sellticket_multi_issue);

-- 销售站以及所属区域，含上级区域
create or replace view v_mis_agency as
select agency_code, ab.org_code agency_area_code,
       ab.org_name agency_area_name, aa.agency_type, aa.available_credit
  from tmp_agency aa, inf_orgs ab
 where aa.org_code = ab.org_code;

-- 本级区域和上级区域名称
create or replace view v_mis_area_farther as
select org_code area_code,
       org_name area_name,
       org_type area_type,
       super_org father_area,
       (select org_name from inf_orgs where org_code = tab.super_org) father_area_name
  from inf_orgs tab;

-- mis统计用区域，含99-直属统计区域
create or replace view v_mis_area as
select area_code,
       area_name,
       area_type,
       father_area,
       father_area_name
  from v_mis_area_farther;

-- 兑奖票显示买票期次和兑奖期次
create or replace view v_mis_pay_sell_issue as
select applyflow_pay,
       applyflow_sell,
       pay.game_code,
       pay.issue_number as pay_issue,
       sell.issue_number as sell_issue,
       pay.terminal_code,
       pay.teller_code,
       pay.agency_code,
       paytime,
       winningamounttax,
       winningamount,
       taxamount,
       paycommissionrate,
       pay.commissionamount,
       winningcount,
       hd_winning,
       hd_count,
       ld_winning,
       ld_count,
       pay.loyalty_code,
       is_big_prize,
       pay_seq
  from his_payticket pay
  join his_sellticket sell using(applyflow_sell);

-- 退票数据明细
create or replace view v_cancel_detail as
select sale.applyflow_sell,
       sale.saletime,
       sale.terminal_code,
       sale.teller_code,
       sale.agency_code,
       sale.game_code,
       sale.issue_number,
       sale.start_issue,
       sale.end_issue,
       sale.issue_count,
       sale.ticket_amount,
       sale.ticket_bet_count,
       sale.salecommissionrate,
       sale.commissionamount,
       sale.bet_methold,
       sale.bet_line,
       sale.loyalty_code,
       sale.result_code,
       sale.sell_seq,
       cancel.applyflow_cancel,
       cancel.canceltime,
       cancel.terminal_code as cancel_terminal,
       cancel.teller_code as cancel_teller,
       cancel.agency_code as cancel_agency,
       cancel.cancel_seq
  from his_sellticket sale, his_cancelticket cancel
 where sale.applyflow_sell = cancel.applyflow_sell;

---------------------------------------------------------------------------
------------                  新mis报表               ---------------------
---------------------------------------------------------------------------
-- 游戏销售及资金分配表 (佟琳说这个报表已经取掉了)
create or replace view mis_report_new_1 as
with all_comm as
 (select game_code, issue_number, sum(sale_comm + pay_comm) as agency_comm
    from (select game_code,
                 issue_number,
                 sum(pure_commission) as sale_comm,
                 0 as pay_comm
            from sub_sell
           group by game_code, issue_number
          union
          select game_code,
                 pay_issue,
                 0 as sale_comm,
                 sum(pay_commission) as pay_comm
            from sub_pay
           group by game_code, pay_issue)
   group by game_code, issue_number),
base as
 (select game_code,
         issue_number,
         sale_amount,
         (sale_amount - theory_win_amount - adj_fund) as sale_incoming,
         theory_win_amount,
         adj_fund,
         theory_win_amount + adj_fund as win_sum,
         agency_comm,
         0 as saler_comm,
         trunc(sale_amount * (case
                 when game_code = 6 then
                  0.05
                 when game_code = 7 then
                  0.07
                 else
                  0
               end)) as sp_comm
    from iss_game_policy_fund
    join all_comm
   using (game_code, issue_number))
select game_code,
       issue_number,
       sale_amount,
       sale_incoming,
       theory_win_amount,
       adj_fund,
       win_sum,
       agency_comm,
       saler_comm,
       sp_comm,
       (agency_comm + saler_comm + sp_comm) as comm_sum,
       trunc(sale_incoming * 0.1) as fee,
       sale_incoming - (agency_comm + saler_comm + sp_comm) -
       (trunc(sale_incoming * 0.1)) as gross_profit
  from base;

-- 《新电脑票2.0基本功能需求说明书》 3.6.1.1 中奖统计表
-- 中奖统计表
create or replace view mis_report_new_2 as
with base as
 (select game_code,
         issue_number,
         sum(sale_sum) as sale_amount,
         sum(hd_winning_sum) as hd_winning_sum,
         sum(hd_winning_amount) as hd_winning_amount,
         sum(ld_winning_sum) as ld_winning_sum,
         sum(ld_winning_amount) as ld_winning_amount,
         sum(winning_sum) as winning_sum
    from mis_report_3113 where area_code <> '00' group by game_code, issue_number)
select game_code,
       issue_number,
       sale_amount,
       hd_winning_sum,
       hd_winning_amount,
       ld_winning_sum,
       ld_winning_amount,
       winning_sum,
       trunc((case
               when sale_amount = 0 then
                0
               else
                (winning_sum / sale_amount) * 10000
             end)) as winning_rate
  from base;

-- 《新电脑票2.0基本功能需求说明书》 3.6.1.4 弃奖统计表
-- 弃奖统计表
create or replace view mis_report_new_5 as
select game_code,
       issue_number,
       sum(hd_purged_amount) as hd_purged_amount,
       sum(ld_purged_amount) as ld_purged_amount,
       sum(hd_purged_sum) as hd_purged_sum,
       sum(ld_purged_sum) as ld_purged_sum,
       sum(purged_amount) as purged_amount
  from mis_report_3112
 group by game_code, issue_number;


create or replace view mis_report_new_7 as
with all_comm as
 (select game_code, issue_number, sum(sale_comm + pay_comm) as agency_comm
    from (select game_code,
                 issue_number,
                 sum(pure_commission) as sale_comm,
                 0 as pay_comm
            from sub_sell
           group by game_code, issue_number
          union
          select game_code,
                 issue_number,
                 0 as sale_comm,
                 sum(pay_commission) as pay_comm
            from sub_pay
           group by game_code, issue_number)
   group by game_code, issue_number),
base as
 (select game_code,
         issue_number,
         sale_amount,
         (sale_amount - theory_win_amount - adj_fund) as sale_incoming
    from iss_game_policy_fund
    left join all_comm
   using (game_code, issue_number))
select game_code,
       issue_number,
       sale_amount,
       sale_incoming,
       10 as fee_rate,
       trunc(sale_incoming * 0.1) as fee_amount
  from base;

-- 兑奖统计表（按照奖等统计）分天
create or replace view mis_report_new_3_day as
with pay as
 (select game_code,
         pay_date,
         sum(hd_pay_amount) as hd_pay_amount,
         sum(hd_pay_bets) as hd_pay_bets,
         sum(ld_pay_amount) as ld_pay_amount,
         sum(ld_pay_bets) as ld_pay_bets,
         sum(pay_amount) as pay_amount
    from sub_pay
   group by game_code, pay_date),
sell as
 (select game_code, sale_date as pay_date, sum(pure_amount) as sale_amount
    from sub_sell
   group by game_code, sale_date)
select game_code,
       pay_date,
       sale_amount,
       nvl(hd_pay_amount, 0) as hd_pay_amount,
       nvl(hd_pay_bets, 0) as hd_pay_bets,
       nvl(ld_pay_amount, 0) as ld_pay_amount,
       nvl(ld_pay_bets, 0) as ld_pay_bets,
       nvl(pay_amount, 0) as pay_amount
  from sell
  left join pay
 using (game_code, pay_date);

-- 《新电脑票2.0基本功能需求说明书》 3.6.1.2 兑奖统计表（按奖等统计）
-- 兑奖统计表（按照奖等统计）分期次
create or replace view mis_report_new_3_issue as
with pay as
 (select game_code,
         pay_issue,
         sum(hd_pay_amount) as hd_pay_amount,
         sum(hd_pay_bets) as hd_pay_bets,
         sum(ld_pay_amount) as ld_pay_amount,
         sum(ld_pay_bets) as ld_pay_bets,
         sum(pay_amount) as pay_amount
    from sub_pay
   group by game_code, pay_issue),
sell as
 (select game_code, issue_number as pay_issue, sum(pure_amount) as sale_amount
    from sub_sell
   group by game_code, issue_number)
select game_code,
       pay_issue,
       nvl(sale_amount,0) as sale_amount,
       nvl(hd_pay_amount, 0) as hd_pay_amount,
       nvl(hd_pay_bets, 0) as hd_pay_bets,
       nvl(ld_pay_amount, 0) as ld_pay_amount,
       nvl(ld_pay_bets, 0) as ld_pay_bets,
       nvl(pay_amount, 0) as pay_amount
  from sell
  right join pay
 using (game_code, pay_issue);


-- 兑奖统计表（按照奖金统计）分天
create or replace view mis_report_new_4_day as
with pay_limit as
 (select game_code, limit_big_prize, limit_payment2 from gp_static),
pay_detail as
 (select game_code,
         trunc(paytime) as pay_date,
         winningamounttax,
         (case
           when winningamounttax >= pay_limit.limit_big_prize then
            winningamounttax
           else
            0
         end) as big_pay_amount,
         (case
           when winningamounttax >= pay_limit.limit_big_prize then
            winningcount
           else
            0
         end) as big_pay_count,
         (case
           when winningamounttax < pay_limit.limit_big_prize and
                winningamounttax >= pay_limit.limit_payment2 then
            winningamounttax
           else
            0
         end) as mid_pay_amount,
         (case
           when winningamounttax < pay_limit.limit_big_prize and
                winningamounttax >= pay_limit.limit_payment2 then
            winningcount
           else
            0
         end) as mid_pay_count,
         (case
           when winningamounttax < pay_limit.limit_payment2 then
            winningamounttax
           else
            0
         end) as small_pay_amount,
         (case
           when winningamounttax < pay_limit.limit_payment2 then
            winningcount
           else
            0
         end) as small_pay_count
    from his_payticket
    join pay_limit
   using (game_code)),
pay as
 (select game_code,
         pay_date,
         sum(big_pay_amount) as big_pay_amount,
         sum(big_pay_count) as big_pay_count,
         sum(mid_pay_amount) as mid_pay_amount,
         sum(mid_pay_count) as mid_pay_count,
         sum(small_pay_amount) as small_pay_amount,
         sum(small_pay_count) as small_pay_count,
         sum(winningamounttax) as pay_sum
    from pay_detail
   group by game_code, pay_date),
sell_notform as
 (select game_code, sale_date as pay_date, sum(pure_amount) as sale_amount
    from sub_sell
   group by game_code, sale_date),
sell as
 (select game_code, to_date(pay_date, 'yyyy-mm-dd') as pay_date, sale_amount
    from sell_notform)
select game_code,
       pay_date,
       sale_amount,
       nvl(big_pay_amount, 0) as big_pay_amount,
       nvl(big_pay_count, 0) as big_pay_count,
       nvl(mid_pay_amount, 0) as mid_pay_amount,
       nvl(mid_pay_count, 0) as mid_pay_count,
       nvl(small_pay_amount, 0) as small_pay_amount,
       nvl(small_pay_count, 0) as small_pay_count,
       nvl(pay_sum, 0) as pay_sum
  from sell
  left join pay
 using (game_code, pay_date);

-- 兑奖统计表（按照奖金统计）分期次
create or replace view mis_report_new_4_issue as
with pay_limit as
 (select game_code, limit_big_prize, limit_payment2 from gp_static),
pay_detail as
 (select game_code,
         issue_number as pay_issue,
         winningamounttax,
         (case
           when winningamounttax >= pay_limit.limit_big_prize then
            winningamounttax
           else
            0
         end) as big_pay_amount,
         (case
           when winningamounttax >= pay_limit.limit_big_prize then
            winningcount
           else
            0
         end) as big_pay_count,
         (case
           when winningamounttax < pay_limit.limit_big_prize and
                winningamounttax >= pay_limit.limit_payment2 then
            winningamounttax
           else
            0
         end) as mid_pay_amount,
         (case
           when winningamounttax < pay_limit.limit_big_prize and
                winningamounttax >= pay_limit.limit_payment2 then
            winningcount
           else
            0
         end) as mid_pay_count,
         (case
           when winningamounttax < pay_limit.limit_payment2 then
            winningamounttax
           else
            0
         end) as small_pay_amount,
         (case
           when winningamounttax < pay_limit.limit_payment2 then
            winningcount
           else
            0
         end) as small_pay_count
    from his_payticket
    join pay_limit
   using (game_code)),
pay as
 (select game_code,
         pay_issue,
         sum(big_pay_amount) as big_pay_amount,
         sum(big_pay_count) as big_pay_count,
         sum(mid_pay_amount) as mid_pay_amount,
         sum(mid_pay_count) as mid_pay_count,
         sum(small_pay_amount) as small_pay_amount,
         sum(small_pay_count) as small_pay_count,
         sum(winningamounttax) as pay_sum
    from pay_detail
   group by game_code, pay_issue),
sell as
 (select game_code,
         issue_number as pay_issue,
         sum(pure_amount) as sale_amount
    from sub_sell
   group by game_code, issue_number)
select game_code,
       pay_issue,
       sale_amount,
       nvl(big_pay_amount, 0) as big_pay_amount,
       nvl(big_pay_count, 0) as big_pay_count,
       nvl(mid_pay_amount, 0) as mid_pay_amount,
       nvl(mid_pay_count, 0) as mid_pay_count,
       nvl(small_pay_amount, 0) as small_pay_amount,
       nvl(small_pay_count, 0) as small_pay_count,
       nvl(pay_sum, 0) as pay_sum
  from sell
  left join pay
 using (game_code, pay_issue);

 
-- 《新电脑票2.0基本功能需求说明书》 3.6.1.3 兑奖统计表（按奖金统计）
create or replace view mis_report_new_9_issue as
with pay as
 (select game_code,
         pay_issue,
         sum(big_amount) as big_amount,
         sum(big_count) as big_count,
         sum(sml_amount) as sml_amount,
         sum(sml_count) as sml_count
    from (select game_code,
                 pay_issue,
                 sum(pay_amount) as big_amount,
                 sum(pay_tickets) as big_count,
                 0 as sml_amount,
                 0 as sml_count
            from sub_pay
           where is_big_one = 1
           group by game_code, pay_issue
          union all
          select game_code,
                 pay_issue,
                 0 as big_amount,
                 0 as big_count,
                 sum(pay_amount) as sml_amount,
                 sum(pay_tickets) as sml_count
            from sub_pay
           where is_big_one = 0
           group by game_code, pay_issue)
   group by game_code, pay_issue
  ),
sell as
 (select game_code,
         issue_number as pay_issue,
         sum(pure_amount) as sale_amount
    from sub_sell
   group by game_code, issue_number)
select game_code,
       pay_issue,
       nvl(sale_amount,0) as sale_amount,
       nvl(big_amount, 0) as big_amount,
       nvl(big_count, 0) as big_count,
       nvl(sml_amount, 0) as sml_amount,
       nvl(sml_count, 0) as sml_count,
       (nvl(big_amount, 0) + nvl(sml_amount, 0)) as pay_amount
  from sell
  right join pay
 using (game_code, pay_issue);

create or replace view mis_report_new_9_day as
with pay as
 (select game_code,
         pay_date,
         sum(big_amount) as big_amount,
         sum(big_count) as big_count,
         sum(sml_amount) as sml_amount,
         sum(sml_count) as sml_count
    from (select game_code,
                 pay_date,
                 sum(pay_amount) as big_amount,
                 sum(pay_tickets) as big_count,
                 0 as sml_amount,
                 0 as sml_count
            from sub_pay
           where is_big_one = 1
           group by game_code, pay_date
          union all
          select game_code,
                 pay_date,
                 0 as big_amount,
                 0 as big_count,
                 sum(pay_amount) as sml_amount,
                 sum(pay_tickets) as sml_count
            from sub_pay
           where is_big_one = 0
           group by game_code, pay_date)
   group by game_code, pay_date
  ),
sell as
 (select game_code,
         sale_date as pay_date,
         sum(pure_amount) as sale_amount
    from sub_sell
   group by game_code, sale_date)
select game_code,
       pay_date,
       sale_amount,
       nvl(big_amount, 0) as big_amount,
       nvl(big_count, 0) as big_count,
       nvl(sml_amount, 0) as sml_amount,
       nvl(sml_count, 0) as sml_count,
       (nvl(big_amount, 0) + nvl(sml_amount, 0)) as pay_amount
  from sell
  left join pay
 using (game_code, pay_date);


create or replace view mis_report_new_6 as
with pool_his as
 (select game_code,
         nvl((select issue_number
               from iss_game_issue
              where game_code = tab.game_code
                and issue_seq = (0 - tab.issue_number)),
             tab.issue_number) issue_number,
         his_code,
         pool_code,
         change_amount,
         pool_amount_before,
         pool_amount_after,
         adj_time,
         pool_adj_type,
         adj_reason,
         pool_flow
    from iss_game_pool_his tab
   where issue_number < 0
  union all
  select game_code,
         issue_number,
         his_code,
         pool_code,
         change_amount,
         pool_amount_before,
         pool_amount_after,
         adj_time,
         pool_adj_type,
         adj_reason,
         pool_flow
    from iss_game_pool_his
   where issue_number > 0),
adj_his as
 (select game_code,
         nvl((select issue_number
               from iss_game_issue
              where game_code = tab.game_code
                and issue_seq = (0 - tab.issue_number)),
             tab.issue_number) issue_number,
         his_code,
         adj_change_type,
         adj_amount,
         adj_amount_before,
         adj_amount_after,
         adj_time,
         adj_reason,
         adj_flow
    from adj_game_his tab
   where issue_number < 0
  union all
  select game_code,
         issue_number,
         his_code,
         adj_change_type,
         adj_amount,
         adj_amount_before,
         adj_amount_after,
         adj_time,
         adj_reason,
         adj_flow
    from adj_game_his
   where issue_number > 0),
theory_fund as
 (select game_code, issue_number, THEORY_WIN_AMOUNT, ADJ_FUND
    from ISS_GAME_POLICY_FUND),
adj_before as
 (select game_code, issue_number, adj_amount_after
    from adj_his
   where (game_code, issue_number, his_code) in
         (select game_code, issue_number, max(his_code)
            from adj_his
           group by game_code, issue_number)),
adj_after as
 (select game_code, issue_number, adj_amount_before
    from adj_his
   where (game_code, issue_number, his_code) in
         (select game_code, issue_number, min(his_code)
            from adj_his
           group by game_code, issue_number)),
adj_other as
 (select game_code,
         issue_number,
         sum(pool_amount) as pool_amount,
         sum(aband_amount) as aband_amount
    from (select game_code,
                 issue_number,
                 adj_amount   as pool_amount,
                 0            as aband_amount
            from adj_his
           where adj_change_type in (3,4)
          union all
          select game_code,
                 issue_number,
                 0            as pool_amount,
                 adj_amount   as aband_amount
            from adj_his tab
           where adj_change_type = 2)
   group by game_code, issue_number),
adj_base as
 (select game_code,
         issue_number,
         adj_amount_before as adj_before,
         nvl(aband_amount, 0) as ADJ_ABANDON,
         0 - nvl(pool_amount, 0) as ADJ_POOL,
         0 as adj_spec,
         adj_amount_after as adj_after
    from adj_before
    join adj_after
   using (game_code, issue_number)
    left join adj_other
   using (game_code, issue_number)),
pool_before as
 (select game_code, issue_number, pool_amount_after
    from pool_his
   where (game_code, issue_number, his_code) in
         (select game_code, issue_number, max(his_code)
            from pool_his
           where pool_adj_type <> 3
           group by game_code, issue_number)),
pool_after as
 (select game_code, issue_number, pool_amount_before
    from pool_his
   where (game_code, issue_number, his_code) in
         (select game_code, issue_number, min(his_code)
            from pool_his
           where pool_adj_type <> 3
           group by game_code, issue_number)),
hd_reward as
 (select game_code,
         issue_number,
         sum(PRIZE_COUNT * SINGLE_BET_REWARD) as reward
    from ISS_PRIZE
   where is_hd_prize = 1
   group by game_code, issue_number),
pool_base as
 (select game_code,
         issue_number,
         pool_amount_before as POOL_BEFORE,
         nvl(reward, 0) as POOL_HD_REWARD,
         pool_amount_after as POOL_AFTER
    from pool_before
    join pool_after
   using (game_code, issue_number)
   right join hd_reward
   using (game_code, issue_number))
select GAME_CODE,
       ISSUE_NUMBER,
       ADJ_BEFORE,
       ADJ_FUND          as ADJ_ISSUE,
       ADJ_ABANDON,
       ADJ_POOL,
       ADJ_SPEC,
       ADJ_AFTER,
       POOL_BEFORE,
       THEORY_WIN_AMOUNT as POOL_ISSUE,
       ADJ_POOL          as POOL_ADJ,
       POOL_HD_REWARD,
       POOL_AFTER
  from theory_fund
  left join pool_base
 using (game_code, issue_number)
  left join adj_base
 using (game_code, issue_number)
 where issue_number > 0;
 
exit; 
