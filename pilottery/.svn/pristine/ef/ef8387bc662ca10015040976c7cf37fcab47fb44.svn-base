rem Differences between KWS@192.168.26.111/TAISHAN and KWS@192.168.26.115/TAISHAN, created on 2016/6/3
rem Press Apply button, or run in Command Window or SQL*Plus connected as KWS@192.168.26.115/TAISHAN

---------------------------------
--  New table adj_game_change  --
---------------------------------
-- Create table
create table ADJ_GAME_CHANGE
(
  adj_flow          CHAR(32) not null,
  game_code         NUMBER(3) not null,
  adj_amount        NUMBER(28) not null,
  adj_amount_before NUMBER(28) not null,
  adj_amount_after  NUMBER(28) not null,
  adj_change_type   NUMBER(1) not null,
  adj_desc          VARCHAR2(1000),
  adj_time          DATE not null,
  adj_admin         NUMBER(4) not null
)
;
-- Add comments to the table 
comment on table ADJ_GAME_CHANGE
  is '调节基金手工调整信息';
-- Add comments to the columns 
comment on column ADJ_GAME_CHANGE.adj_flow
  is '调整流水';
comment on column ADJ_GAME_CHANGE.game_code
  is '游戏编码';
comment on column ADJ_GAME_CHANGE.adj_amount
  is '变更金额';
comment on column ADJ_GAME_CHANGE.adj_amount_before
  is '变更前金额';
comment on column ADJ_GAME_CHANGE.adj_amount_after
  is '变更后金额';
comment on column ADJ_GAME_CHANGE.adj_change_type
  is '调节基金变更类型（1、期次开奖滚入；2、弃奖滚入；3、期次开奖自动拨出；4、手工拨出到奖池；5、发行费手工拨入调节基金； 6、其他金额手工拨入调节基金；7、期次开奖抹零滚入；8、初始化设置。）';
comment on column ADJ_GAME_CHANGE.adj_desc
  is '变更备注';
comment on column ADJ_GAME_CHANGE.adj_time
  is '变更时间';
comment on column ADJ_GAME_CHANGE.adj_admin
  is '变更人员';
-- Create/Recreate primary, unique and foreign key constraints 
alter table ADJ_GAME_CHANGE
  add constraint PK_ADJ_GAME_CHANGE primary key (ADJ_FLOW);

----------------------------------
--  New table adj_game_current  --
----------------------------------
-- Create table
create table ADJ_GAME_CURRENT
(
  game_code          NUMBER(3) not null,
  pool_amount_before NUMBER(28),
  pool_amount_after  NUMBER(28)
)
;
-- Add comments to the table 
comment on table ADJ_GAME_CURRENT
  is '游戏当前调节基金信息';
-- Add comments to the columns 
comment on column ADJ_GAME_CURRENT.game_code
  is '游戏编码';
comment on column ADJ_GAME_CURRENT.pool_amount_before
  is '前次调整余额';
comment on column ADJ_GAME_CURRENT.pool_amount_after
  is '调节基金余额';
-- Create/Recreate primary, unique and foreign key constraints 
alter table ADJ_GAME_CURRENT
  add constraint PK_ADJ_GAME_CURRENT primary key (GAME_CODE);

------------------------------
--  New table adj_game_his  --
------------------------------
-- Create table
create table ADJ_GAME_HIS
(
  his_code          NUMBER(8) not null,
  game_code         NUMBER(3) not null,
  issue_number      NUMBER(12) not null,
  adj_change_type   NUMBER(1) not null,
  adj_amount        NUMBER(28) not null,
  adj_amount_before NUMBER(28) not null,
  adj_amount_after  NUMBER(28) not null,
  adj_time          DATE default sysdate not null,
  adj_reason        VARCHAR2(1000),
  adj_flow          CHAR(32)
)
;
-- Add comments to the table 
comment on table ADJ_GAME_HIS
  is '游戏调节基金历史';
-- Add comments to the columns 
comment on column ADJ_GAME_HIS.his_code
  is '历史序号';
comment on column ADJ_GAME_HIS.game_code
  is '游戏编码';
comment on column ADJ_GAME_HIS.issue_number
  is '游戏期号（为负数时，保存的内容是期次序号。仅用于无当前期的情形）';
comment on column ADJ_GAME_HIS.adj_change_type
  is '调节基金变更类型（1、期次开奖滚入；2、弃奖滚入；3、期次开奖自动拨出；4、手工拨出到奖池；5、发行费手工拨入调节基金； 6、其他金额手工拨入调节基金；7、期次开奖抹零滚入；8、初始化设置。）';
comment on column ADJ_GAME_HIS.adj_amount
  is '调节基金调整金额';
comment on column ADJ_GAME_HIS.adj_amount_before
  is '变更前调节基金';
comment on column ADJ_GAME_HIS.adj_amount_after
  is '变更后调节基金';
comment on column ADJ_GAME_HIS.adj_time
  is '变更时间';
comment on column ADJ_GAME_HIS.adj_reason
  is '变更原因';
comment on column ADJ_GAME_HIS.adj_flow
  is '手工变更流水（当调节基金变更类型为弃奖滚入时，此字段记录【弃奖产生时所对应的期次序号】）';
-- Create/Recreate primary, unique and foreign key constraints 
alter table ADJ_GAME_HIS
  add constraint PK_ADJ_GAME_HIS primary key (HIS_CODE);

-----------------------------
--  New table auth_agency  --
-----------------------------
-- Create table
create table AUTH_AGENCY
(
  agency_code          CHAR(8) not null,
  game_code            NUMBER(3) not null,
  pay_commission_rate  NUMBER(8) default 0 not null,
  sale_commission_rate NUMBER(8) default 0 not null,
  allow_pay            NUMBER(1) default 1 not null,
  allow_sale           NUMBER(1) default 1 not null,
  allow_cancel         NUMBER(1) default 0 not null,
  claiming_scope       NUMBER(1),
  auth_time            DATE default sysdate not null
)
;
-- Add comments to the table 
comment on table AUTH_AGENCY
  is '销售站游戏授权';
-- Add comments to the columns 
comment on column AUTH_AGENCY.agency_code
  is '销售站编码';
comment on column AUTH_AGENCY.game_code
  is '游戏CODE';
comment on column AUTH_AGENCY.pay_commission_rate
  is '兑奖佣金比例（千分位）';
comment on column AUTH_AGENCY.sale_commission_rate
  is '销售佣金比例（千分位）';
comment on column AUTH_AGENCY.allow_pay
  is '是否可兑奖（1=是；0=否）';
comment on column AUTH_AGENCY.allow_sale
  is '是否允许销售（1=是；0=否）';
comment on column AUTH_AGENCY.allow_cancel
  is '是否允许退票（1=是；0=否）';
comment on column AUTH_AGENCY.claiming_scope
  is '兑奖范围（1=中心、2=一级区域、3=二级区域、4=销售站）';
comment on column AUTH_AGENCY.auth_time
  is '授权时间';
-- Create/Recreate primary, unique and foreign key constraints 
alter table AUTH_AGENCY
  add constraint PK_AUTH_AGENCY primary key (AGENCY_CODE, GAME_CODE);

--------------------------
--  New table auth_org  --
--------------------------
-- Create table
create table AUTH_ORG
(
  org_code             CHAR(2) not null,
  game_code            NUMBER(3) not null,
  pay_commission_rate  NUMBER(8) default 0 not null,
  sale_commission_rate NUMBER(8) default 0 not null,
  auth_time            DATE default sysdate not null,
  allow_pay            NUMBER(1) default 1 not null,
  allow_sale           NUMBER(1) default 1 not null,
  allow_cancel         NUMBER(1) default 0 not null
)
;
-- Add comments to the table 
comment on table AUTH_ORG
  is '区域游戏授权';
-- Add comments to the columns 
comment on column AUTH_ORG.org_code
  is '区域编码';
comment on column AUTH_ORG.game_code
  is '游戏CODE';
comment on column AUTH_ORG.pay_commission_rate
  is '兑奖佣金比例（千分位）';
comment on column AUTH_ORG.sale_commission_rate
  is '销售佣金比例（千分位）';
comment on column AUTH_ORG.auth_time
  is '授权时间';
comment on column AUTH_ORG.allow_pay
  is '是否可兑奖（1=是；0=否）';
comment on column AUTH_ORG.allow_sale
  is '是否允许销售（1=是；0=否）';
comment on column AUTH_ORG.allow_cancel
  is '是否允许退票（1=是；0=否）';
-- Create/Recreate primary, unique and foreign key constraints 
alter table AUTH_ORG
  add constraint PK_AUTH_ORG primary key (ORG_CODE, GAME_CODE);

-------------------------------
--  New table calc_rst_3113  --
-------------------------------
-- Create table
create table CALC_RST_3113
(
  game_code         NUMBER(3) not null,
  issue_number      NUMBER(12) not null,
  area_code         CHAR(2) not null,
  area_name         VARCHAR2(4000),
  sale_sum          NUMBER(28) default 0 not null,
  hd_winning_sum    NUMBER(28) default 0 not null,
  hd_winning_amount NUMBER(28) default 0 not null,
  ld_winning_sum    NUMBER(28) default 0 not null,
  ld_winning_amount NUMBER(28) default 0 not null,
  winning_sum       NUMBER(28) default 0 not null,
  winning_rate      NUMBER(28) default 0 not null,
  calc_date         DATE not null
)
;
-- Create/Recreate primary, unique and foreign key constraints 
alter table CALC_RST_3113
  add constraint PK_CALC_REPORT_3113 primary key (GAME_CODE, ISSUE_NUMBER, AREA_CODE, CALC_DATE);

-------------------------------
--  New table calc_rst_3121  --
-------------------------------
-- Create table
create table CALC_RST_3121
(
  sale_year   NUMBER(4) not null,
  game_code   NUMBER(3) not null,
  area_code   CHAR(2) not null,
  area_name   VARCHAR2(4000),
  sale_sum    NUMBER(28) default 0 not null,
  sale_sum_1  NUMBER(28) default 0 not null,
  sale_sum_2  NUMBER(28) default 0 not null,
  sale_sum_3  NUMBER(28) default 0 not null,
  sale_sum_4  NUMBER(28) default 0 not null,
  sale_sum_5  NUMBER(28) default 0 not null,
  sale_sum_6  NUMBER(28) default 0 not null,
  sale_sum_7  NUMBER(28) default 0 not null,
  sale_sum_8  NUMBER(28) default 0 not null,
  sale_sum_9  NUMBER(28) default 0 not null,
  sale_sum_10 NUMBER(28) default 0 not null,
  sale_sum_11 NUMBER(28) default 0 not null,
  sale_sum_12 NUMBER(28) default 0 not null,
  calc_date   DATE not null
)
;
-- Create/Recreate primary, unique and foreign key constraints 
alter table CALC_RST_3121
  add constraint PK_CALC_REPORT_3121 primary key (SALE_YEAR, GAME_CODE, AREA_CODE, CALC_DATE);

-------------------------------
--  New table calc_rst_3122  --
-------------------------------
-- Create table
create table CALC_RST_3122
(
  game_code    NUMBER(3) not null,
  issue_number NUMBER(12) not null,
  area_code    CHAR(2) not null,
  area_name    VARCHAR2(4000),
  sale_sum     NUMBER(28) default 0 not null,
  cancel_sum   NUMBER(28) default 0 not null,
  win_sum      NUMBER(28) default 0 not null,
  calc_date    DATE not null
)
;
-- Create/Recreate primary, unique and foreign key constraints 
alter table CALC_RST_3122
  add constraint PK_CALC_REPORT_3122 primary key (GAME_CODE, ISSUE_NUMBER, AREA_CODE, CALC_DATE);

---------------------------------
--  New table commonweal_fund  --
---------------------------------
-- Create table
create table COMMONWEAL_FUND
(
  his_code           NUMBER(8) not null,
  game_code          NUMBER(3) not null,
  issue_number       NUMBER(12) not null,
  cwfund_change_type NUMBER(1) not null,
  adj_amount         NUMBER(28) not null,
  adj_amount_before  NUMBER(28) not null,
  adj_amount_after   NUMBER(28) not null,
  adj_time           DATE default sysdate not null,
  adj_reason         VARCHAR2(1000)
)
;
-- Add comments to the table 
comment on table COMMONWEAL_FUND
  is '游戏发行费历史';
-- Add comments to the columns 
comment on column COMMONWEAL_FUND.his_code
  is '历史序号';
comment on column COMMONWEAL_FUND.game_code
  is '游戏编码';
comment on column COMMONWEAL_FUND.issue_number
  is '游戏期号';
comment on column COMMONWEAL_FUND.cwfund_change_type
  is '公益金变更类型（1、期次开奖滚入；2、弃奖滚入；）';
comment on column COMMONWEAL_FUND.adj_amount
  is '调整金额';
comment on column COMMONWEAL_FUND.adj_amount_before
  is '变更前金额';
comment on column COMMONWEAL_FUND.adj_amount_after
  is '变更后金额';
comment on column COMMONWEAL_FUND.adj_time
  is '变更时间';
comment on column COMMONWEAL_FUND.adj_reason
  is '变更原因';
-- Create/Recreate primary, unique and foreign key constraints 
alter table COMMONWEAL_FUND
  add constraint PK_GOV_PUB_FUND primary key (HIS_CODE);

---------------------------------
--  Changed table flow_agency  --
---------------------------------
-- Create/Recreate indexes 
create index IDX_FLOW_AGENCY_TIME on FLOW_AGENCY (TRADE_TIME);
-----------------------------------------
--  Changed table flow_market_manager  --
-----------------------------------------
-- Add comments to the columns 
comment on column FLOW_MARKET_MANAGER.flow_type
  is '资金类型（9-为站点充值，10-现金上缴，14-为站点提现）';
------------------------------
--  Changed table flow_org  --
------------------------------
-- Add comments to the columns 
comment on column FLOW_ORG.flow_type
  is '资金类型（1-充值，2-提现，3-彩票调拨入库（机构）、4-彩票调拨入库佣金（机构）、12-彩票调拨出库（机构）、21-站点兑奖导致机构佣金（机构）、22-站点兑奖导致机构增加资金（机构）、23-中心兑奖导致机构佣金（机构）、24-中心兑奖导致机构增加资金（机构）、31-彩票调拨出库退佣金（机构））';
----------------------------------------
--  Changed table fund_mm_cash_repay  --
----------------------------------------
-- Add comments to the columns 
comment on column FUND_MM_CASH_REPAY.remark
  is '备注';
----------------------------------------------
--  Changed table game_batch_reward_detail  --
----------------------------------------------
-- Add comments to the columns 
comment on column GAME_BATCH_REWARD_DETAIL.pre_safe_code
  is '安全码前缀';
-- Drop indexes 
drop index IDX_GAME_BATCH_REWARD_DETAIL_M;
-- Create/Recreate indexes 
create index IDX_GAME_BATCH_REWARD_PBS on GAME_BATCH_REWARD_DETAIL (PLAN_CODE, BATCH_NO, SAFE_CODE);
--------------------------------
--  Changed table game_plans  --
--------------------------------
-- Add comments to the columns 
comment on column GAME_PLANS.publisher_code
  is '印制厂商（1=石家庄，3=中彩三场）';
-------------------------------
--  New table gov_commision  --
-------------------------------
-- Create table
create table GOV_COMMISION
(
  his_code          NUMBER(8) not null,
  game_code         NUMBER(3) not null,
  issue_number      NUMBER(12) not null,
  comm_change_type  NUMBER(1) not null,
  adj_amount        NUMBER(28) not null,
  adj_amount_before NUMBER(28) not null,
  adj_amount_after  NUMBER(28) not null,
  adj_time          DATE default sysdate not null,
  adj_reason        VARCHAR2(1000)
)
;
-- Add comments to the table 
comment on table GOV_COMMISION
  is '游戏发行费历史';
-- Add comments to the columns 
comment on column GOV_COMMISION.his_code
  is '历史序号';
comment on column GOV_COMMISION.game_code
  is '游戏编码';
comment on column GOV_COMMISION.issue_number
  is '游戏期号';
comment on column GOV_COMMISION.comm_change_type
  is '发行费变更类型（1、期次开奖滚入；2、发行费手动拨出到奖池；3、发行费手动拨出到调节基金；）';
comment on column GOV_COMMISION.adj_amount
  is '调整金额';
comment on column GOV_COMMISION.adj_amount_before
  is '变更前金额';
comment on column GOV_COMMISION.adj_amount_after
  is '变更后金额';
comment on column GOV_COMMISION.adj_time
  is '变更时间';
comment on column GOV_COMMISION.adj_reason
  is '变更原因';
-- Create/Recreate primary, unique and foreign key constraints 
alter table GOV_COMMISION
  add constraint PK_GOV_COMMISION primary key (HIS_CODE);

----------------------------
--  New table gp_dynamic  --
----------------------------
-- Create table
create table GP_DYNAMIC
(
  game_code                  NUMBER(3) not null,
  singleline_max_amount      NUMBER(16) not null,
  singleticket_max_line      NUMBER(16) not null,
  singleticket_max_amount    NUMBER(16) not null,
  cancel_sec                 NUMBER(8) not null,
  saler_pay_limit            NUMBER(16),
  saler_cancel_limit         NUMBER(16),
  issue_close_alert_time     NUMBER(16),
  is_pay                     NUMBER(1) default 1 not null,
  is_sale                    NUMBER(1) default 1 not null,
  is_cancel                  NUMBER(1) default 1 not null,
  is_auto_draw               NUMBER(1) default 1 not null,
  service_time_1             VARCHAR2(20),
  service_time_2             VARCHAR2(20),
  audit_single_ticket_sale   NUMBER(28),
  audit_single_ticket_pay    NUMBER(28),
  audit_single_ticket_cancel NUMBER(28),
  calc_winning_code          VARCHAR2(1000)
)
;
-- Add comments to the table 
comment on table GP_DYNAMIC
  is '游戏动态参数';
-- Add comments to the columns 
comment on column GP_DYNAMIC.game_code
  is '游戏编码';
comment on column GP_DYNAMIC.singleline_max_amount
  is '单行最大倍数';
comment on column GP_DYNAMIC.singleticket_max_line
  is '单票最大投注行数';
comment on column GP_DYNAMIC.singleticket_max_amount
  is '单票最大销售限额（单位分）';
comment on column GP_DYNAMIC.cancel_sec
  is '允许退票时间（单位秒）';
comment on column GP_DYNAMIC.saler_pay_limit
  is '普通销售员兑奖限额（单位分）';
comment on column GP_DYNAMIC.saler_cancel_limit
  is '普通销售员退票限额（单位分）';
comment on column GP_DYNAMIC.issue_close_alert_time
  is '销售关闭倒数时间（单位秒）';
comment on column GP_DYNAMIC.is_pay
  is '是否可兑奖';
comment on column GP_DYNAMIC.is_sale
  is '是否可销售';
comment on column GP_DYNAMIC.is_cancel
  is '是否可取消';
comment on column GP_DYNAMIC.is_auto_draw
  is '是否自动开奖';
comment on column GP_DYNAMIC.service_time_1
  is '游戏每日服务时间段一';
comment on column GP_DYNAMIC.service_time_2
  is '游戏每日服务时间段二';
comment on column GP_DYNAMIC.audit_single_ticket_sale
  is '单票销售金额告警阈值';
comment on column GP_DYNAMIC.audit_single_ticket_pay
  is '单票兑奖金额告警阈值';
comment on column GP_DYNAMIC.audit_single_ticket_cancel
  is '单票退票金额告警阈值';
comment on column GP_DYNAMIC.calc_winning_code
  is '算奖字符串';
-- Create/Recreate primary, unique and foreign key constraints 
alter table GP_DYNAMIC
  add constraint PK_GP_DYNAMIC primary key (GAME_CODE);

----------------------------
--  New table gp_history  --
----------------------------
-- Create table
create table GP_HISTORY
(
  his_his_code    NUMBER(8) not null,
  his_modify_date DATE default sysdate not null,
  game_code       NUMBER(3) not null,
  is_open_risk    NUMBER(1),
  risk_param      VARCHAR2(1000)
)
;
-- Add comments to the table 
comment on table GP_HISTORY
  is '游戏历史参数';
-- Add comments to the columns 
comment on column GP_HISTORY.his_his_code
  is '历史编号';
comment on column GP_HISTORY.his_modify_date
  is '修改时间';
comment on column GP_HISTORY.game_code
  is '游戏编码';
comment on column GP_HISTORY.is_open_risk
  is '是否开启风险控制开关';
comment on column GP_HISTORY.risk_param
  is '风险控制参数';
-- Create/Recreate primary, unique and foreign key constraints 
alter table GP_HISTORY
  add constraint PK_GP_HISTORY primary key (HIS_HIS_CODE, GAME_CODE);

---------------------------
--  New table gp_policy  --
---------------------------
-- Create table
create table GP_POLICY
(
  his_policy_code NUMBER(8) not null,
  his_modify_date DATE,
  game_code       NUMBER(3) not null,
  theory_rate     NUMBER(10) not null,
  fund_rate       NUMBER(10) not null,
  adj_rate        NUMBER(10) not null,
  tax_threshold   NUMBER(10) not null,
  tax_rate        NUMBER(10) not null,
  draw_limit_day  NUMBER(10) not null
)
;
-- Add comments to the table 
comment on table GP_POLICY
  is '游戏政策参数';
-- Add comments to the columns 
comment on column GP_POLICY.his_policy_code
  is '历史编号';
comment on column GP_POLICY.his_modify_date
  is '修改时间';
comment on column GP_POLICY.game_code
  is '游戏编码';
comment on column GP_POLICY.theory_rate
  is '游戏理论返奖率';
comment on column GP_POLICY.fund_rate
  is '公益金比例';
comment on column GP_POLICY.adj_rate
  is '调节基金比例';
comment on column GP_POLICY.tax_threshold
  is '中奖缴税起征点';
comment on column GP_POLICY.tax_rate
  is '中奖缴税比例';
comment on column GP_POLICY.draw_limit_day
  is '兑奖期';
-- Create/Recreate primary, unique and foreign key constraints 
alter table GP_POLICY
  add constraint PK_GP_POLICY primary key (HIS_POLICY_CODE, GAME_CODE);

-------------------------------
--  New table gp_prize_rule  --
-------------------------------
-- Create table
create table GP_PRIZE_RULE
(
  his_prize_code  NUMBER(8) not null,
  his_modify_date DATE,
  game_code       NUMBER(3) not null,
  prule_level     NUMBER(3) not null,
  prule_name      VARCHAR2(1000),
  prule_desc      VARCHAR2(4000),
  level_prize     NUMBER(16),
  disp_order      NUMBER(2)
)
;
-- Add comments to the table 
comment on table GP_PRIZE_RULE
  is '游戏奖级规则';
-- Add comments to the columns 
comment on column GP_PRIZE_RULE.his_prize_code
  is '历史编号';
comment on column GP_PRIZE_RULE.his_modify_date
  is '修改时间';
comment on column GP_PRIZE_RULE.game_code
  is '游戏编码';
comment on column GP_PRIZE_RULE.prule_level
  is '奖等';
comment on column GP_PRIZE_RULE.prule_name
  is '奖级名称';
comment on column GP_PRIZE_RULE.prule_desc
  is '描述';
comment on column GP_PRIZE_RULE.level_prize
  is '金额';
comment on column GP_PRIZE_RULE.disp_order
  is '显示顺序';
-- Create/Recreate primary, unique and foreign key constraints 
alter table GP_PRIZE_RULE
  add constraint PK_GP_PRIZE_RULE primary key (HIS_PRIZE_CODE, GAME_CODE, PRULE_LEVEL);

-------------------------
--  New table gp_rule  --
-------------------------
-- Create table
create table GP_RULE
(
  his_rule_code   NUMBER(8) not null,
  his_modify_date DATE,
  game_code       NUMBER(3) not null,
  rule_code       NUMBER(3) not null,
  rule_name       VARCHAR2(1000) not null,
  rule_desc       VARCHAR2(4000) not null,
  rule_enable     NUMBER(1) default 1 not null
)
;
-- Add comments to the table 
comment on table GP_RULE
  is '游戏玩法规则';
-- Add comments to the columns 
comment on column GP_RULE.his_rule_code
  is '历史编号';
comment on column GP_RULE.his_modify_date
  is '修改时间';
comment on column GP_RULE.game_code
  is '游戏编码';
comment on column GP_RULE.rule_code
  is '玩法编码';
comment on column GP_RULE.rule_name
  is '玩法名称';
comment on column GP_RULE.rule_desc
  is '玩法描述（包括投注方式等内容）';
comment on column GP_RULE.rule_enable
  is '是否启用（0-禁用，1-启用）';
-- Create/Recreate primary, unique and foreign key constraints 
alter table GP_RULE
  add constraint PK_GP_RULE primary key (HIS_RULE_CODE, GAME_CODE, RULE_CODE);

---------------------------
--  New table gp_static  --
---------------------------
-- Create table
create table GP_STATIC
(
  game_code               NUMBER(3) not null,
  draw_mode               NUMBER(1) not null,
  singlebet_amount        NUMBER(16) not null,
  singleticket_max_issues NUMBER(2) not null,
  limit_big_prize         NUMBER(16) not null,
  limit_payment           NUMBER(16) not null,
  limit_payment2          NUMBER(16) not null,
  limit_cancel2           NUMBER(16) not null,
  abandon_reward_collect  NUMBER(1) not null
)
;
-- Add comments to the table 
comment on table GP_STATIC
  is '游戏只读参数';
-- Add comments to the columns 
comment on column GP_STATIC.game_code
  is '游戏编码';
comment on column GP_STATIC.draw_mode
  is '开奖模式（1=快开、2=内部算奖、3=外部算奖）';
comment on column GP_STATIC.singlebet_amount
  is '单注投注金额（单位分）';
comment on column GP_STATIC.singleticket_max_issues
  is '多期销售期数限制（1-20）';
comment on column GP_STATIC.limit_big_prize
  is '大奖金额（单位分）';
comment on column GP_STATIC.limit_payment
  is '游戏兑奖保护限额（系统兑奖业务上限）（单位分）';
comment on column GP_STATIC.limit_payment2
  is '“一级区域”兑奖金额上限（单位分）';
comment on column GP_STATIC.limit_cancel2
  is '“一级区域”退票金额上限（单位分）';
comment on column GP_STATIC.abandon_reward_collect
  is '弃奖去处（1=奖池、2=调节基金、3=公益金）';
-- Create/Recreate primary, unique and foreign key constraints 
alter table GP_STATIC
  add constraint PK_GP_STATIC primary key (GAME_CODE);

-----------------------------
--  New table gp_win_rule  --
-----------------------------
-- Create table
create table GP_WIN_RULE
(
  his_win_code    NUMBER(8) not null,
  his_modify_date DATE,
  game_code       NUMBER(3) not null,
  wrule_code      NUMBER(3) not null,
  wrule_name      VARCHAR2(1000) not null,
  wrule_desc      VARCHAR2(4000) not null
)
;
-- Add comments to the table 
comment on table GP_WIN_RULE
  is '游戏中奖规则';
-- Add comments to the columns 
comment on column GP_WIN_RULE.his_win_code
  is '历史编号';
comment on column GP_WIN_RULE.his_modify_date
  is '修改时间';
comment on column GP_WIN_RULE.game_code
  is '游戏编码';
comment on column GP_WIN_RULE.wrule_code
  is '中奖规则';
comment on column GP_WIN_RULE.wrule_name
  is '规则名称';
comment on column GP_WIN_RULE.wrule_desc
  is '规则描述';
-- Create/Recreate primary, unique and foreign key constraints 
alter table GP_WIN_RULE
  add constraint PK_GP_WRULE primary key (HIS_WIN_CODE, GAME_CODE, WRULE_CODE);

------------------------------------
--  New table his_abandon_ticket  --
------------------------------------
-- Create table
create table HIS_ABANDON_TICKET
(
  applyflow_sell            CHAR(24) not null,
  abandon_time              DATE not null,
  winning_time              DATE not null,
  terminal_code             CHAR(10) not null,
  teller_code               NUMBER(8) not null,
  agency_code               CHAR(8) not null,
  game_code                 NUMBER(3) not null,
  issue_number              NUMBER(12) not null,
  ticket_amount             NUMBER(16) not null,
  is_big_prize              NUMBER(1) not null,
  win_amount                NUMBER(28) default 0,
  win_amount_without_tax    NUMBER(28) default 0,
  tax_amount                NUMBER(28) default 0,
  win_bets                  NUMBER(28) default 0,
  hd_win_amount             NUMBER(28) default 0,
  hd_win_amount_without_tax NUMBER(28) default 0,
  hd_tax_amount             NUMBER(28) default 0,
  hd_win_bets               NUMBER(28) default 0,
  ld_win_amount             NUMBER(28) default 0,
  ld_win_amount_without_tax NUMBER(28) default 0,
  ld_tax_amount             NUMBER(28) default 0,
  ld_win_bets               NUMBER(28) default 0
)
;
-- Add comments to the table 
comment on table HIS_ABANDON_TICKET
  is '彩票弃奖信息';
-- Add comments to the columns 
comment on column HIS_ABANDON_TICKET.applyflow_sell
  is '售票请求流水号';
comment on column HIS_ABANDON_TICKET.abandon_time
  is '弃奖时间';
comment on column HIS_ABANDON_TICKET.winning_time
  is '开奖时间';
comment on column HIS_ABANDON_TICKET.terminal_code
  is '销售终端编码';
comment on column HIS_ABANDON_TICKET.teller_code
  is '销售员编码';
comment on column HIS_ABANDON_TICKET.agency_code
  is '销售站编码';
comment on column HIS_ABANDON_TICKET.game_code
  is '游戏编码';
comment on column HIS_ABANDON_TICKET.issue_number
  is '游戏期号';
comment on column HIS_ABANDON_TICKET.ticket_amount
  is '票面销售金额';
comment on column HIS_ABANDON_TICKET.is_big_prize
  is '是否大奖';
comment on column HIS_ABANDON_TICKET.win_amount
  is '中奖金额（税前）';
comment on column HIS_ABANDON_TICKET.win_amount_without_tax
  is '中奖金额（税后）';
comment on column HIS_ABANDON_TICKET.tax_amount
  is '税额';
comment on column HIS_ABANDON_TICKET.win_bets
  is '中奖注数';
comment on column HIS_ABANDON_TICKET.hd_win_amount
  is '高等奖中奖金额（税前）';
comment on column HIS_ABANDON_TICKET.hd_win_amount_without_tax
  is '高等奖中奖金额（税后）';
comment on column HIS_ABANDON_TICKET.hd_tax_amount
  is '高等奖税额';
comment on column HIS_ABANDON_TICKET.hd_win_bets
  is '高等奖中奖注数';
comment on column HIS_ABANDON_TICKET.ld_win_amount
  is '固定奖中奖金额（税前）';
comment on column HIS_ABANDON_TICKET.ld_win_amount_without_tax
  is '固定奖中奖金额（税后）';
comment on column HIS_ABANDON_TICKET.ld_tax_amount
  is '固定奖税额';
comment on column HIS_ABANDON_TICKET.ld_win_bets
  is '固定奖中奖注数';
-- Create/Recreate primary, unique and foreign key constraints 
alter table HIS_ABANDON_TICKET
  add constraint PK_HIS_GIVEUP primary key (APPLYFLOW_SELL, GAME_CODE, ISSUE_NUMBER);

-------------------------------------------
--  New table his_abandon_ticket_detail  --
-------------------------------------------
-- Create table
create table HIS_ABANDON_TICKET_DETAIL
(
  applyflow_sell   CHAR(24) not null,
  abandon_time     DATE not null,
  winning_time     DATE not null,
  game_code        NUMBER(3) not null,
  issue_number     NUMBER(12) not null,
  prize_level      NUMBER(3) not null,
  prize_count      NUMBER(16),
  is_hd_prize      NUMBER(1),
  winningamounttax NUMBER(16),
  winningamount    NUMBER(16),
  taxamount        NUMBER(16)
)
;
-- Add comments to the table 
comment on table HIS_ABANDON_TICKET_DETAIL
  is '弃奖信息明细';
-- Add comments to the columns 
comment on column HIS_ABANDON_TICKET_DETAIL.applyflow_sell
  is '售票请求流水';
comment on column HIS_ABANDON_TICKET_DETAIL.abandon_time
  is '弃奖时间';
comment on column HIS_ABANDON_TICKET_DETAIL.winning_time
  is '开奖时间';
comment on column HIS_ABANDON_TICKET_DETAIL.game_code
  is '游戏编码';
comment on column HIS_ABANDON_TICKET_DETAIL.issue_number
  is '游戏期号';
comment on column HIS_ABANDON_TICKET_DETAIL.prize_level
  is '奖等';
comment on column HIS_ABANDON_TICKET_DETAIL.prize_count
  is '中奖注数';
comment on column HIS_ABANDON_TICKET_DETAIL.is_hd_prize
  is '是否高等奖';
comment on column HIS_ABANDON_TICKET_DETAIL.winningamounttax
  is '中奖金额(税前)';
comment on column HIS_ABANDON_TICKET_DETAIL.winningamount
  is '中奖金额(税后)';
comment on column HIS_ABANDON_TICKET_DETAIL.taxamount
  is '税额';
-- Create/Recreate primary, unique and foreign key constraints 
alter table HIS_ABANDON_TICKET_DETAIL
  add constraint PK_HIS_GIVEUP_DETAIL primary key (APPLYFLOW_SELL, GAME_CODE, ISSUE_NUMBER, PRIZE_LEVEL);

----------------------------------
--  New table his_cancelticket  --
----------------------------------
-- Create table
create table HIS_CANCELTICKET
(
  applyflow_cancel CHAR(24) not null,
  canceltime       DATE not null,
  applyflow_sell   CHAR(32) not null,
  terminal_code    CHAR(10),
  teller_code      NUMBER(8),
  agency_code      CHAR(8),
  is_center        NUMBER(1) not null,
  org_code         CHAR(2),
  cancel_seq       NUMBER(18) not null
)
;
-- Add comments to the table 
comment on table HIS_CANCELTICKET
  is '彩票取消信息';
-- Add comments to the columns 
comment on column HIS_CANCELTICKET.applyflow_cancel
  is '退票请求流水号';
comment on column HIS_CANCELTICKET.canceltime
  is '退票时间';
comment on column HIS_CANCELTICKET.applyflow_sell
  is '售票请求流水号';
comment on column HIS_CANCELTICKET.terminal_code
  is '退票终端编码';
comment on column HIS_CANCELTICKET.teller_code
  is '退票销售员编码';
comment on column HIS_CANCELTICKET.agency_code
  is '退票销售站编码';
comment on column HIS_CANCELTICKET.is_center
  is '是否中心退票';
comment on column HIS_CANCELTICKET.org_code
  is '退票机构代码';
comment on column HIS_CANCELTICKET.cancel_seq
  is '退票递增序号';
-- Create/Recreate indexes 
create index IDX_HIS_CANCEL_SEQ on HIS_CANCELTICKET (CANCEL_SEQ);
-- Create/Recreate primary, unique and foreign key constraints 
alter table HIS_CANCELTICKET
  add constraint PK_HIS_CANCEL primary key (APPLYFLOW_CANCEL);

--------------------------------
--  New table his_day_settle  --
--------------------------------
-- Create table
create table HIS_DAY_SETTLE
(
  settle_id   NUMBER(10) not null,
  opt_date    DATE not null,
  settle_date DATE not null,
  sell_seq    NUMBER(18) not null,
  cancel_seq  NUMBER(18) not null,
  pay_seq     NUMBER(18) not null,
  win_seq     NUMBER(18) not null
)
;
-- Add comments to the table 
comment on table HIS_DAY_SETTLE
  is '日结信息';
-- Add comments to the columns 
comment on column HIS_DAY_SETTLE.settle_id
  is '日结序号';
comment on column HIS_DAY_SETTLE.opt_date
  is '操作日期（系统当前时间）';
comment on column HIS_DAY_SETTLE.settle_date
  is '统计日期（通过主机传递过来）';
comment on column HIS_DAY_SETTLE.sell_seq
  is 'SELL_SEQ';
comment on column HIS_DAY_SETTLE.cancel_seq
  is 'CANCEL_SEQ';
comment on column HIS_DAY_SETTLE.pay_seq
  is 'PAY_SEQ';
comment on column HIS_DAY_SETTLE.win_seq
  is 'WIN_SEQ';
-- Create/Recreate indexes 
create index IDX_HIS_DAY_CANCEL on HIS_DAY_SETTLE (CANCEL_SEQ);
create index IDX_HIS_DAY_PAY on HIS_DAY_SETTLE (PAY_SEQ);
create index IDX_HIS_DAY_SELL on HIS_DAY_SETTLE (SELL_SEQ);
create index IDX_HIS_DAY_WIN on HIS_DAY_SETTLE (WIN_SEQ);
-- Create/Recreate primary, unique and foreign key constraints 
alter table HIS_DAY_SETTLE
  add constraint PK_HIS_DAY_SETTLE primary key (SETTLE_ID);

-----------------------------------------
--  Changed table his_org_fund_report  --
-----------------------------------------
-- Add/modify columns 
alter table HIS_ORG_FUND_REPORT add lot_sale NUMBER(28) default 0 not null;
alter table HIS_ORG_FUND_REPORT add lot_sale_comm NUMBER(28) default 0 not null;
alter table HIS_ORG_FUND_REPORT add lot_paid NUMBER(28) default 0 not null;
alter table HIS_ORG_FUND_REPORT add lot_pay_comm NUMBER(28) default 0 not null;
alter table HIS_ORG_FUND_REPORT add lot_rtv NUMBER(28) default 0 not null;
alter table HIS_ORG_FUND_REPORT add lot_rtv_comm NUMBER(28) default 0 not null;
alter table HIS_ORG_FUND_REPORT add lot_center_pay NUMBER(28) default 0 not null;
alter table HIS_ORG_FUND_REPORT add lot_center_pay_comm NUMBER(28) default 0 not null;
alter table HIS_ORG_FUND_REPORT add lot_center_rtv NUMBER(28) default 0 not null;
alter table HIS_ORG_FUND_REPORT add lot_center_rtv_comm NUMBER(28) default 0 not null;
-- Add comments to the table 
comment on table HIS_ORG_FUND_REPORT
  is '部门资金报表';
-- Add comments to the columns 
comment on column HIS_ORG_FUND_REPORT.lot_sale
  is '销售';
comment on column HIS_ORG_FUND_REPORT.lot_sale_comm
  is '销售佣金';
comment on column HIS_ORG_FUND_REPORT.lot_paid
  is '兑奖';
comment on column HIS_ORG_FUND_REPORT.lot_pay_comm
  is '兑奖佣金';
comment on column HIS_ORG_FUND_REPORT.lot_rtv
  is '站点退货';
comment on column HIS_ORG_FUND_REPORT.lot_rtv_comm
  is '退货佣金';
comment on column HIS_ORG_FUND_REPORT.lot_center_pay
  is '中心兑奖';
comment on column HIS_ORG_FUND_REPORT.lot_center_pay_comm
  is '中心兑奖佣金';
comment on column HIS_ORG_FUND_REPORT.lot_center_rtv
  is '中心退票';
comment on column HIS_ORG_FUND_REPORT.lot_center_rtv_comm
  is '中心退票佣金';
-------------------------------
--  New table his_payticket  --
-------------------------------
-- Create table
create table HIS_PAYTICKET
(
  applyflow_pay       CHAR(24) not null,
  applyflow_sell      CHAR(24),
  game_code           NUMBER(3) not null,
  issue_number        NUMBER(12) not null,
  terminal_code       CHAR(10),
  teller_code         NUMBER(8),
  agency_code         CHAR(8),
  is_center           NUMBER(1) not null,
  org_code            CHAR(2),
  paytime             DATE not null,
  winningamounttax    NUMBER(16) not null,
  winningamount       NUMBER(16) not null,
  taxamount           NUMBER(16) not null,
  paycommissionrate   NUMBER(4) not null,
  commissionamount    NUMBER(16) not null,
  paycommissionrate_o NUMBER(4) not null,
  commissionamount_o  NUMBER(16) not null,
  winningcount        NUMBER(8) not null,
  hd_winning          NUMBER(16) not null,
  hd_count            NUMBER(8) not null,
  ld_winning          NUMBER(16) not null,
  ld_count            NUMBER(8) not null,
  loyalty_code        VARCHAR2(50),
  is_big_prize        NUMBER(1) not null,
  pay_seq             NUMBER(18) not null
)
;
-- Add comments to the table 
comment on table HIS_PAYTICKET
  is '彩票兑奖信息';
-- Add comments to the columns 
comment on column HIS_PAYTICKET.applyflow_pay
  is '兑奖请求流水号';
comment on column HIS_PAYTICKET.applyflow_sell
  is '售票请求流水号';
comment on column HIS_PAYTICKET.game_code
  is '游戏编码';
comment on column HIS_PAYTICKET.issue_number
  is '兑奖游戏期号';
comment on column HIS_PAYTICKET.terminal_code
  is '终端编码';
comment on column HIS_PAYTICKET.teller_code
  is '销售员编码';
comment on column HIS_PAYTICKET.agency_code
  is '销售站编码';
comment on column HIS_PAYTICKET.is_center
  is '是否中心兑奖';
comment on column HIS_PAYTICKET.org_code
  is '兑奖机构编码';
comment on column HIS_PAYTICKET.paytime
  is '兑奖时间';
comment on column HIS_PAYTICKET.winningamounttax
  is '中奖金额(税前)';
comment on column HIS_PAYTICKET.winningamount
  is '中奖金额(税后)';
comment on column HIS_PAYTICKET.taxamount
  is '税额';
comment on column HIS_PAYTICKET.paycommissionrate
  is '兑奖佣金返还比例';
comment on column HIS_PAYTICKET.commissionamount
  is '兑奖佣金返还金额（厘）';
comment on column HIS_PAYTICKET.paycommissionrate_o
  is '兑奖佣金返还比例（代理商）';
comment on column HIS_PAYTICKET.commissionamount_o
  is '兑奖佣金返还金额（代理商）';
comment on column HIS_PAYTICKET.winningcount
  is '兑奖注数';
comment on column HIS_PAYTICKET.hd_winning
  is '高等奖兑奖金额';
comment on column HIS_PAYTICKET.hd_count
  is '高等奖兑奖注数';
comment on column HIS_PAYTICKET.ld_winning
  is '低等奖兑奖金额';
comment on column HIS_PAYTICKET.ld_count
  is '低等奖兑奖注数';
comment on column HIS_PAYTICKET.loyalty_code
  is '彩民卡编号';
comment on column HIS_PAYTICKET.is_big_prize
  is '是否大奖';
comment on column HIS_PAYTICKET.pay_seq
  is '兑奖递增序号';
-- Create/Recreate indexes 
create index IDX_HIS_PAY_SEQ on HIS_PAYTICKET (PAY_SEQ);
-- Create/Recreate primary, unique and foreign key constraints 
alter table HIS_PAYTICKET
  add constraint PK_HIS_PAY_TSN primary key (APPLYFLOW_PAY);

-----------------------------------
--  Changed table his_pay_level  --
-----------------------------------
-- Drop columns 
alter table HIS_PAY_LEVEL drop column level_10;
alter table HIS_PAY_LEVEL rename column level_9 to LEVEL_OTHER;
-- Add comments to the columns 
comment on column HIS_PAY_LEVEL.level_other
  is '其他奖级奖金';
----------------------------------
--  New table his_saler_agency  --
----------------------------------
-- Create table
create table HIS_SALER_AGENCY
(
  settle_id         NUMBER(10) not null,
  agency_code       CHAR(8) not null,
  agency_name       VARCHAR2(1000),
  storetype_id      NUMBER(2),
  status            NUMBER(1),
  agency_type       NUMBER(1),
  bank_id           NUMBER(4),
  bank_account      VARCHAR2(32),
  telephone         VARCHAR2(100),
  contact_person    VARCHAR2(500),
  address           VARCHAR2(4000),
  agency_add_time   DATE,
  quit_time         DATE,
  org_code          CHAR(2),
  area_code         CHAR(4),
  market_manager_id NUMBER(4)
)
;
-- Add comments to the table 
comment on table HIS_SALER_AGENCY
  is '销售站历史';
-- Add comments to the columns 
comment on column HIS_SALER_AGENCY.settle_id
  is '日结序号';
comment on column HIS_SALER_AGENCY.agency_code
  is '销售站编码（4位区域编码+4位顺序号）';
comment on column HIS_SALER_AGENCY.agency_name
  is '销售站名称';
comment on column HIS_SALER_AGENCY.storetype_id
  is '店面类型ID';
comment on column HIS_SALER_AGENCY.status
  is '销售站状态（1=可用；2=已禁用；3=已清退）';
comment on column HIS_SALER_AGENCY.agency_type
  is '销售站类型（1=传统终端(预付费)；2=受信终端(后付费)；3=无纸化；4=中心销售站）';
comment on column HIS_SALER_AGENCY.bank_id
  is '银行ID';
comment on column HIS_SALER_AGENCY.bank_account
  is '银行账号';
comment on column HIS_SALER_AGENCY.telephone
  is '销售站电话';
comment on column HIS_SALER_AGENCY.contact_person
  is '销售站联系人';
comment on column HIS_SALER_AGENCY.address
  is '销售站地址';
comment on column HIS_SALER_AGENCY.agency_add_time
  is '销售站添加时间';
comment on column HIS_SALER_AGENCY.quit_time
  is '清退时间';
comment on column HIS_SALER_AGENCY.org_code
  is '所属部门编码';
comment on column HIS_SALER_AGENCY.area_code
  is '所属区域编码';
comment on column HIS_SALER_AGENCY.market_manager_id
  is '市场管理员编码';
-- Create/Recreate primary, unique and foreign key constraints 
alter table HIS_SALER_AGENCY
  add constraint PK_HIS_SALER_AGENCY primary key (AGENCY_CODE, SETTLE_ID);

--------------------------------
--  New table his_sellticket  --
--------------------------------
-- Create table
create table HIS_SELLTICKET
(
  applyflow_sell       CHAR(24) not null,
  saletime             DATE not null,
  terminal_code        CHAR(10) not null,
  teller_code          NUMBER(8) not null,
  agency_code          CHAR(8) not null,
  game_code            NUMBER(3) not null,
  issue_number         NUMBER(12) not null,
  start_issue          NUMBER(12) not null,
  end_issue            NUMBER(12) not null,
  issue_count          NUMBER(8) not null,
  ticket_amount        NUMBER(16) not null,
  ticket_bet_count     NUMBER(8) not null,
  salecommissionrate   NUMBER(8) not null,
  commissionamount     NUMBER(16) not null,
  salecommissionrate_o NUMBER(8) not null,
  commissionamount_o   NUMBER(16) not null,
  bet_methold          NUMBER(4) not null,
  bet_line             NUMBER(4) not null,
  loyalty_code         VARCHAR2(50),
  result_code          NUMBER(4) not null,
  sale_tsn             VARCHAR2(24),
  sell_seq             NUMBER(18) not null
)
;
-- Add comments to the table 
comment on table HIS_SELLTICKET
  is '售票信息';
-- Add comments to the columns 
comment on column HIS_SELLTICKET.applyflow_sell
  is '售票请求流水';
comment on column HIS_SELLTICKET.saletime
  is '交易时间';
comment on column HIS_SELLTICKET.terminal_code
  is '终端编码';
comment on column HIS_SELLTICKET.teller_code
  is '销售员编码';
comment on column HIS_SELLTICKET.agency_code
  is '销售站编码';
comment on column HIS_SELLTICKET.game_code
  is '游戏编码';
comment on column HIS_SELLTICKET.issue_number
  is '游戏期号';
comment on column HIS_SELLTICKET.start_issue
  is '开始游戏期号';
comment on column HIS_SELLTICKET.end_issue
  is '截止游戏期号';
comment on column HIS_SELLTICKET.issue_count
  is '连续购买期数';
comment on column HIS_SELLTICKET.ticket_amount
  is '票面销售金额';
comment on column HIS_SELLTICKET.ticket_bet_count
  is '票总注数';
comment on column HIS_SELLTICKET.salecommissionrate
  is '售票佣金返还比例';
comment on column HIS_SELLTICKET.commissionamount
  is '售票佣金返还金额（厘）';
comment on column HIS_SELLTICKET.salecommissionrate_o
  is '售票佣金返还比例（代理商）';
comment on column HIS_SELLTICKET.commissionamount_o
  is '售票佣金返还金额（代理商）';
comment on column HIS_SELLTICKET.bet_methold
  is '投注方法（1=键盘、2=投注单、3=重玩）';
comment on column HIS_SELLTICKET.bet_line
  is '投注行数量';
comment on column HIS_SELLTICKET.loyalty_code
  is '彩民卡编号';
comment on column HIS_SELLTICKET.result_code
  is '处理结果(0=正常，28=超过风险控制)';
comment on column HIS_SELLTICKET.sale_tsn
  is '售票TSN';
comment on column HIS_SELLTICKET.sell_seq
  is '销售递增序号';
-- Create/Recreate indexes 
create index IDX_HIS_SELL_SEQ on HIS_SELLTICKET (SELL_SEQ);
-- Create/Recreate primary, unique and foreign key constraints 
alter table HIS_SELLTICKET
  add constraint PK_HIS_SELL primary key (APPLYFLOW_SELL);

---------------------------------------
--  New table his_sellticket_detail  --
---------------------------------------
-- Create table
create table HIS_SELLTICKET_DETAIL
(
  applyflow_sell CHAR(24) not null,
  saletime       DATE not null,
  line_no        NUMBER(2) not null,
  bet_type       NUMBER(4) not null,
  subtype        NUMBER(8) not null,
  oper_type      NUMBER(4) not null,
  section        VARCHAR2(500) not null,
  bet_amount     NUMBER(8) not null,
  bet_count      NUMBER(8) not null,
  line_amount    NUMBER(16) not null
)
;
-- Add comments to the table 
comment on table HIS_SELLTICKET_DETAIL
  is '售票明细信息';
-- Add comments to the columns 
comment on column HIS_SELLTICKET_DETAIL.applyflow_sell
  is '售票请求流水';
comment on column HIS_SELLTICKET_DETAIL.saletime
  is '交易时间';
comment on column HIS_SELLTICKET_DETAIL.line_no
  is '票面行号';
comment on column HIS_SELLTICKET_DETAIL.bet_type
  is '投注方式（1=单式、2=复式、3=胆拖、4=包胆、5=和值、6=包串、7=包号、8=有序复式、9=范围（天天赢））';
comment on column HIS_SELLTICKET_DETAIL.subtype
  is '玩法（1-前后二（2D-C）、2-前后三（3D-C）、3-直选（4D）、4-前二（2D-A）、5-后二（2D-B）、6-前三（3D-A）、7-后三（3D-B））';
comment on column HIS_SELLTICKET_DETAIL.oper_type
  is '操作方式（机选、手选）';
comment on column HIS_SELLTICKET_DETAIL.section
  is '投注区内容';
comment on column HIS_SELLTICKET_DETAIL.bet_amount
  is '投注倍数';
comment on column HIS_SELLTICKET_DETAIL.bet_count
  is '投注注数';
comment on column HIS_SELLTICKET_DETAIL.line_amount
  is '投注行金额';
-- Create/Recreate primary, unique and foreign key constraints 
alter table HIS_SELLTICKET_DETAIL
  add constraint PK_HIS_SELL_DETAIL primary key (APPLYFLOW_SELL, LINE_NO);

--------------------------------------------
--  New table his_sellticket_multi_issue  --
--------------------------------------------
-- Create table
create table HIS_SELLTICKET_MULTI_ISSUE
(
  applyflow_sell CHAR(24) not null
)
;
-- Add comments to the table 
comment on table HIS_SELLTICKET_MULTI_ISSUE
  is '多期票售票信息';
-- Add comments to the columns 
comment on column HIS_SELLTICKET_MULTI_ISSUE.applyflow_sell
  is '售票请求流水';
-- Create/Recreate primary, unique and foreign key constraints 
alter table HIS_SELLTICKET_MULTI_ISSUE
  add constraint PK_HIS_SELL_MULTI_ISSUE primary key (APPLYFLOW_SELL);

-------------------------------------
--  New table his_terminal_online  --
-------------------------------------
-- Create table
create table HIS_TERMINAL_ONLINE
(
  calc_date    VARCHAR2(10) not null,
  calc_time    NUMBER(10) not null,
  org_code     VARCHAR2(10) not null,
  org_name     VARCHAR2(4000) not null,
  total_count  NUMBER(28) not null,
  online_count NUMBER(28) default 0 not null
)
;
-- Add comments to the table 
comment on table HIS_TERMINAL_ONLINE
  is '销量按时间段监控之销售站排行';
-- Add comments to the columns 
comment on column HIS_TERMINAL_ONLINE.calc_date
  is '统计日期';
comment on column HIS_TERMINAL_ONLINE.calc_time
  is '统计时间（24小时，每10分钟一个间隔，从1-144）';
comment on column HIS_TERMINAL_ONLINE.org_code
  is '机构编码';
comment on column HIS_TERMINAL_ONLINE.org_name
  is '机构名称';
comment on column HIS_TERMINAL_ONLINE.total_count
  is '终端总数量';
comment on column HIS_TERMINAL_ONLINE.online_count
  is '上线终端数量';
-- Create/Recreate primary, unique and foreign key constraints 
alter table HIS_TERMINAL_ONLINE
  add constraint PK_HIS_TERMINAL_ONLINE primary key (CALC_DATE, CALC_TIME, ORG_CODE);

--------------------------------
--  New table his_win_ticket  --
--------------------------------
-- Create table
create table HIS_WIN_TICKET
(
  applyflow_sell            CHAR(24) not null,
  winning_time              DATE not null,
  terminal_code             CHAR(10),
  teller_code               NUMBER(8),
  agency_code               CHAR(8),
  game_code                 NUMBER(3) not null,
  issue_number              NUMBER(12) not null,
  ticket_amount             NUMBER(16),
  is_big_prize              NUMBER(1),
  win_amount                NUMBER(28) default 0,
  win_amount_without_tax    NUMBER(28) default 0,
  tax_amount                NUMBER(28) default 0,
  win_bets                  NUMBER(28) default 0,
  hd_win_amount             NUMBER(28) default 0,
  hd_win_amount_without_tax NUMBER(28) default 0,
  hd_tax_amount             NUMBER(28) default 0,
  hd_win_bets               NUMBER(28) default 0,
  ld_win_amount             NUMBER(28) default 0,
  ld_win_amount_without_tax NUMBER(28) default 0,
  ld_tax_amount             NUMBER(28) default 0,
  ld_win_bets               NUMBER(28) default 0
)
;
-- Add comments to the table 
comment on table HIS_WIN_TICKET
  is '中奖信息';
-- Add comments to the columns 
comment on column HIS_WIN_TICKET.applyflow_sell
  is '售票请求流水';
comment on column HIS_WIN_TICKET.winning_time
  is '开奖时间';
comment on column HIS_WIN_TICKET.terminal_code
  is '销售终端编码';
comment on column HIS_WIN_TICKET.teller_code
  is '销售员编码';
comment on column HIS_WIN_TICKET.agency_code
  is '销售站编码';
comment on column HIS_WIN_TICKET.game_code
  is '游戏编码';
comment on column HIS_WIN_TICKET.issue_number
  is '游戏期号';
comment on column HIS_WIN_TICKET.ticket_amount
  is '票面销售金额';
comment on column HIS_WIN_TICKET.is_big_prize
  is '是否大奖';
comment on column HIS_WIN_TICKET.win_amount
  is '中奖金额（税前）';
comment on column HIS_WIN_TICKET.win_amount_without_tax
  is '中奖金额（税后）';
comment on column HIS_WIN_TICKET.tax_amount
  is '税额';
comment on column HIS_WIN_TICKET.win_bets
  is '中奖注数';
comment on column HIS_WIN_TICKET.hd_win_amount
  is '高等奖中奖金额（税前）';
comment on column HIS_WIN_TICKET.hd_win_amount_without_tax
  is '高等奖中奖金额（税后）';
comment on column HIS_WIN_TICKET.hd_tax_amount
  is '高等奖税额';
comment on column HIS_WIN_TICKET.hd_win_bets
  is '高等奖中奖注数';
comment on column HIS_WIN_TICKET.ld_win_amount
  is '固定奖中奖金额（税前）';
comment on column HIS_WIN_TICKET.ld_win_amount_without_tax
  is '固定奖中奖金额（税后）';
comment on column HIS_WIN_TICKET.ld_tax_amount
  is '固定奖税额';
comment on column HIS_WIN_TICKET.ld_win_bets
  is '固定奖中奖注数';
-- Create/Recreate primary, unique and foreign key constraints 
alter table HIS_WIN_TICKET
  add constraint PK_HIS_WIN primary key (APPLYFLOW_SELL, GAME_CODE, ISSUE_NUMBER);

---------------------------------------
--  New table his_win_ticket_detail  --
---------------------------------------
-- Create table
create table HIS_WIN_TICKET_DETAIL
(
  applyflow_sell   CHAR(24) not null,
  winnning_time    DATE not null,
  game_code        NUMBER(3) not null,
  issue_number     NUMBER(12) not null,
  sale_agency      CHAR(8) not null,
  prize_level      NUMBER(3) not null,
  prize_count      NUMBER(16) not null,
  is_hd_prize      NUMBER(1) not null,
  winningamounttax NUMBER(16) not null,
  winningamount    NUMBER(16) not null,
  taxamount        NUMBER(16) not null,
  win_seq          NUMBER(18) not null
)
;
-- Add comments to the table 
comment on table HIS_WIN_TICKET_DETAIL
  is '中奖信息';
-- Add comments to the columns 
comment on column HIS_WIN_TICKET_DETAIL.applyflow_sell
  is '售票请求流水';
comment on column HIS_WIN_TICKET_DETAIL.winnning_time
  is '开奖时间';
comment on column HIS_WIN_TICKET_DETAIL.game_code
  is '游戏编码';
comment on column HIS_WIN_TICKET_DETAIL.issue_number
  is '游戏期号';
comment on column HIS_WIN_TICKET_DETAIL.sale_agency
  is '售票销售站';
comment on column HIS_WIN_TICKET_DETAIL.prize_level
  is '奖等';
comment on column HIS_WIN_TICKET_DETAIL.prize_count
  is '中奖注数';
comment on column HIS_WIN_TICKET_DETAIL.is_hd_prize
  is '是否高等奖';
comment on column HIS_WIN_TICKET_DETAIL.winningamounttax
  is '中奖金额(税前)';
comment on column HIS_WIN_TICKET_DETAIL.winningamount
  is '中奖金额(税后)';
comment on column HIS_WIN_TICKET_DETAIL.taxamount
  is '税额';
comment on column HIS_WIN_TICKET_DETAIL.win_seq
  is '中奖递增序号';
-- Create/Recreate indexes 
create index IDX_HIS_WIN_DETAIL_G_I on HIS_WIN_TICKET_DETAIL (GAME_CODE, ISSUE_NUMBER);
create index IDX_HIS_WIN_DETAIL_RPT on HIS_WIN_TICKET_DETAIL (GAME_CODE, ISSUE_NUMBER, PRIZE_LEVEL, SALE_AGENCY);
create index IDX_HIS_WIN_DETAIL_SEQ on HIS_WIN_TICKET_DETAIL (WIN_SEQ);
-- Create/Recreate primary, unique and foreign key constraints 
alter table HIS_WIN_TICKET_DETAIL
  add constraint PK_HIS_WIN_DETAIL primary key (APPLYFLOW_SELL, GAME_CODE, ISSUE_NUMBER, PRIZE_LEVEL);

-----------------------------
--  New table inf_devices  --
-----------------------------
-- Create table
create table INF_DEVICES
(
  device_id     NUMBER(8) not null,
  device_name   VARCHAR2(100) not null,
  ip_addr       VARCHAR2(50),
  device_status NUMBER(1) not null,
  device_type   NUMBER(1) not null,
  game_code     NUMBER(3)
)
;
-- Add comments to the table 
comment on table INF_DEVICES
  is '系统设备';
-- Add comments to the columns 
comment on column INF_DEVICES.device_id
  is '设备编号';
comment on column INF_DEVICES.device_name
  is '设备名称';
comment on column INF_DEVICES.ip_addr
  is 'IP地址';
comment on column INF_DEVICES.device_status
  is '设备状态（0=未连接；1=已连接；2=正在使用）';
comment on column INF_DEVICES.device_type
  is '设备类型（1=RNG）';
comment on column INF_DEVICES.game_code
  is '游戏编码(0=所有快开游戏，其他数值对应游戏)';
-- Create/Recreate primary, unique and foreign key constraints 
alter table INF_DEVICES
  add constraint PK_INF_DEVICES primary key (DEVICE_ID);

---------------------------
--  New table inf_games  --
---------------------------
-- Create table
create table INF_GAMES
(
  game_code            NUMBER(3) not null,
  game_mark            VARCHAR2(10) not null,
  basic_type           NUMBER(1) not null,
  full_name            VARCHAR2(500) not null,
  short_name           VARCHAR2(500) not null,
  issuing_organization VARCHAR2(1000)
)
;
-- Add comments to the table 
comment on table INF_GAMES
  is '游戏基本信息';
-- Add comments to the columns 
comment on column INF_GAMES.game_code
  is '游戏编码（1=双色球；2=3D；4=七乐彩；5=时时彩；6=幸运农场；12=六合彩；13=K时时彩；14=K基诺）';
comment on column INF_GAMES.game_mark
  is '游戏标识';
comment on column INF_GAMES.basic_type
  is '游戏类型（1=基诺,2=乐透,3=数字）';
comment on column INF_GAMES.full_name
  is '游戏名称';
comment on column INF_GAMES.short_name
  is '游戏缩写';
comment on column INF_GAMES.issuing_organization
  is '发行单位';
-- Create/Recreate indexes 
create index UDX_INF_GAMES_MARK on INF_GAMES (GAME_MARK);
-- Create/Recreate primary, unique and foreign key constraints 
alter table INF_GAMES
  add constraint PK_INF_GAMES primary key (GAME_CODE);

------------------------------
--  Changed table inf_orgs  --
------------------------------
-- Add comments to the columns 
comment on column INF_ORGS.org_code
  is '机构编码（00代表总公司，01代表分公司）';
comment on column INF_ORGS.org_name
  is '机构名称';
comment on column INF_ORGS.org_type
  is '机构类别（1-公司,2-代理）';
-----------------------------
--  New table inf_tellers  --
-----------------------------
-- Create table
create table INF_TELLERS
(
  teller_code          NUMBER(8) not null,
  agency_code          CHAR(8) not null,
  teller_name          VARCHAR2(1000),
  teller_type          NUMBER(1) not null,
  status               NUMBER(1),
  password             VARCHAR2(32),
  latest_terminal_code CHAR(10),
  latest_sign_on_time  DATE,
  latest_sign_off_time DATE,
  is_online            NUMBER(1)
)
;
-- Add comments to the table 
comment on table INF_TELLERS
  is '销售员';
-- Add comments to the columns 
comment on column INF_TELLERS.teller_code
  is '销售员编码';
comment on column INF_TELLERS.agency_code
  is '销售站编码';
comment on column INF_TELLERS.teller_name
  is '销售员名称';
comment on column INF_TELLERS.teller_type
  is '销售员类型（1=普通销售员； 2=销售站经理；3=培训员）';
comment on column INF_TELLERS.status
  is '销售员状态（1=可用；2=已禁用；3=已删除）';
comment on column INF_TELLERS.password
  is '口令';
comment on column INF_TELLERS.latest_terminal_code
  is '最近签入的销售终端编码';
comment on column INF_TELLERS.latest_sign_on_time
  is '最近签入日期时间';
comment on column INF_TELLERS.latest_sign_off_time
  is '最后签出日期时间';
comment on column INF_TELLERS.is_online
  is '是否在线';
-- Create/Recreate primary, unique and foreign key constraints 
alter table INF_TELLERS
  add constraint PK_INF_TELLER primary key (TELLER_CODE);

------------------------------------
--  New table inf_terminal_types  --
------------------------------------
-- Create table
create table INF_TERMINAL_TYPES
(
  term_type_id   NUMBER(4) not null,
  term_type_desc VARCHAR2(1000) not null
)
;
-- Add comments to the table 
comment on table INF_TERMINAL_TYPES
  is '终端机类型';
-- Add comments to the columns 
comment on column INF_TERMINAL_TYPES.term_type_id
  is '类型编码';
comment on column INF_TERMINAL_TYPES.term_type_desc
  is '类型描述';
-- Create/Recreate primary, unique and foreign key constraints 
alter table INF_TERMINAL_TYPES
  add constraint PK_INF_TERM_TYPES primary key (TERM_TYPE_ID);

-----------------------------------
--  New table iss_current_param  --
-----------------------------------
-- Create table
create table ISS_CURRENT_PARAM
(
  game_code       NUMBER(3) not null,
  issue_number    NUMBER(12) not null,
  his_his_code    NUMBER(8) not null,
  his_policy_code NUMBER(8) not null,
  his_rule_code   NUMBER(8) not null,
  his_win_code    NUMBER(8) not null,
  his_prize_code  NUMBER(8) not null
)
;
-- Add comments to the table 
comment on table ISS_CURRENT_PARAM
  is '游戏期次参数';
-- Add comments to the columns 
comment on column ISS_CURRENT_PARAM.game_code
  is '游戏编码';
comment on column ISS_CURRENT_PARAM.issue_number
  is '游戏期号';
comment on column ISS_CURRENT_PARAM.his_his_code
  is '动态参数当前历史编号';
comment on column ISS_CURRENT_PARAM.his_policy_code
  is '政策参数当前历史编号';
comment on column ISS_CURRENT_PARAM.his_rule_code
  is '玩法规则当前历史编号';
comment on column ISS_CURRENT_PARAM.his_win_code
  is '中奖规则当前历史编号';
comment on column ISS_CURRENT_PARAM.his_prize_code
  is '奖级规则当前历史编号';
-- Create/Recreate primary, unique and foreign key constraints 
alter table ISS_CURRENT_PARAM
  add constraint PK_ISS_CP primary key (GAME_CODE, ISSUE_NUMBER);

--------------------------------
--  New table iss_game_issue  --
--------------------------------
-- Create table
create table ISS_GAME_ISSUE
(
  game_code            NUMBER(3) not null,
  issue_number         NUMBER(12) not null,
  issue_seq            NUMBER(12),
  issue_status         NUMBER(2) not null,
  is_publish           NUMBER(2),
  draw_state           NUMBER(2),
  plan_start_time      DATE,
  plan_close_time      DATE,
  plan_reward_time     DATE,
  real_start_time      DATE,
  real_close_time      DATE,
  real_reward_time     DATE,
  issue_end_time       DATE,
  code_input_methold   NUMBER(1),
  first_draw_user_id   NUMBER(10),
  first_draw_number    VARCHAR2(100),
  second_draw_user_id  NUMBER(10),
  second_draw_number   VARCHAR2(100),
  final_draw_number    VARCHAR2(100),
  final_draw_user_id   NUMBER(10),
  pay_end_day          NUMBER(16),
  pool_start_amount    NUMBER(16),
  pool_close_amount    NUMBER(16),
  issue_sale_amount    NUMBER(16),
  issue_sale_tickets   NUMBER(16),
  issue_sale_bets      NUMBER(16),
  issue_cancel_amount  NUMBER(16),
  issue_cancel_tickets NUMBER(16),
  issue_cancel_bets    NUMBER(16),
  winning_amount       NUMBER(16),
  winning_bets         NUMBER(16),
  winning_tickets      NUMBER(16),
  winning_amount_big   NUMBER(16),
  winning_tickets_big  NUMBER(16),
  issue_rick_amount    NUMBER(16),
  issue_rick_tickets   NUMBER(16),
  winning_result       VARCHAR2(200),
  rewarding_error_code NUMBER(4),
  rewarding_error_mesg VARCHAR2(200),
  calc_winning_code    VARCHAR2(100)
)
;
-- Add comments to the table 
comment on table ISS_GAME_ISSUE
  is '游戏期次管理';
-- Add comments to the columns 
comment on column ISS_GAME_ISSUE.game_code
  is '游戏编码';
comment on column ISS_GAME_ISSUE.issue_number
  is '游戏期号';
comment on column ISS_GAME_ISSUE.issue_seq
  is '期次序号';
comment on column ISS_GAME_ISSUE.issue_status
  is '期次状态（1=预售；2=游戏期开始；3=期即将关闭；4=游戏期关闭；5=数据封存完毕；6=开奖号码已录入；7=销售已经匹配；8=已录入奖级奖金；9=本地算奖完成；10=奖级已确认；11=开奖确认；12=中奖数据已录入数据库；13=期结全部完成）';
comment on column ISS_GAME_ISSUE.is_publish
  is '是否已发布';
comment on column ISS_GAME_ISSUE.draw_state
  is '期次开奖状态（0=不能开奖状态；1=开奖准备状态；2=数据整理状态；3=备份状态；4=备份完成；5=第一次输入完成；6=第二次输入完成；7=开奖号码审批通过；8=开奖号码审批失败；9=开奖号码已发送；10=派奖检索完成；11=派奖输入已发送；12=中奖统计完成；13=数据稽核已发送 ；14=数据稽核完成；15=期结确认已发送；16=开奖完成）';
comment on column ISS_GAME_ISSUE.plan_start_time
  is '开始时间（预计）';
comment on column ISS_GAME_ISSUE.plan_close_time
  is '关闭时间（预计）';
comment on column ISS_GAME_ISSUE.plan_reward_time
  is '开奖时间（预计）';
comment on column ISS_GAME_ISSUE.real_start_time
  is '开始时间（实际）';
comment on column ISS_GAME_ISSUE.real_close_time
  is '关闭时间（实际）';
comment on column ISS_GAME_ISSUE.real_reward_time
  is '开奖时间（实际）';
comment on column ISS_GAME_ISSUE.issue_end_time
  is '期结时间';
comment on column ISS_GAME_ISSUE.code_input_methold
  is '开奖号码输入模式（1=手工；2=光盘）';
comment on column ISS_GAME_ISSUE.first_draw_user_id
  is '第一次开奖用户';
comment on column ISS_GAME_ISSUE.first_draw_number
  is '第一次开奖号码';
comment on column ISS_GAME_ISSUE.second_draw_user_id
  is '第二次开奖用户';
comment on column ISS_GAME_ISSUE.second_draw_number
  is '第二次开奖号码';
comment on column ISS_GAME_ISSUE.final_draw_number
  is '最终开奖号码';
comment on column ISS_GAME_ISSUE.final_draw_user_id
  is '开奖号码审批人';
comment on column ISS_GAME_ISSUE.pay_end_day
  is '兑奖截止日期（天）';
comment on column ISS_GAME_ISSUE.pool_start_amount
  is '期初奖池';
comment on column ISS_GAME_ISSUE.pool_close_amount
  is '期末奖池';
comment on column ISS_GAME_ISSUE.issue_sale_amount
  is '销售金额';
comment on column ISS_GAME_ISSUE.issue_sale_tickets
  is '销售票数';
comment on column ISS_GAME_ISSUE.issue_sale_bets
  is '销售注数';
comment on column ISS_GAME_ISSUE.issue_cancel_amount
  is '退票总额';
comment on column ISS_GAME_ISSUE.issue_cancel_tickets
  is '退票张数';
comment on column ISS_GAME_ISSUE.issue_cancel_bets
  is '退票住数';
comment on column ISS_GAME_ISSUE.winning_amount
  is '中奖总额';
comment on column ISS_GAME_ISSUE.winning_bets
  is '中奖注数';
comment on column ISS_GAME_ISSUE.winning_tickets
  is '中奖票数';
comment on column ISS_GAME_ISSUE.winning_amount_big
  is '大奖金额';
comment on column ISS_GAME_ISSUE.winning_tickets_big
  is '大奖票数';
comment on column ISS_GAME_ISSUE.issue_rick_amount
  is '风控拒绝金额';
comment on column ISS_GAME_ISSUE.issue_rick_tickets
  is '风控拒绝票数';
comment on column ISS_GAME_ISSUE.winning_result
  is '开奖号码';
comment on column ISS_GAME_ISSUE.rewarding_error_code
  is '开奖过程错误编码';
comment on column ISS_GAME_ISSUE.rewarding_error_mesg
  is '开奖过程错误描述';
comment on column ISS_GAME_ISSUE.calc_winning_code
  is '算奖字符串';
-- Create/Recreate indexes 
create index IDX_ISS_GAME_ISSUE_CLOSE on ISS_GAME_ISSUE (REAL_CLOSE_TIME);
create index IDX_ISS_GAME_ISSUE_PAYEND on ISS_GAME_ISSUE (PAY_END_DAY);
create index IDX_ISS_GAME_ISSUE_START on ISS_GAME_ISSUE (REAL_START_TIME);
create index IDX_ISS_GAME_ISSUE_WIN on ISS_GAME_ISSUE (REAL_REWARD_TIME);
-- Create/Recreate primary, unique and foreign key constraints 
alter table ISS_GAME_ISSUE
  add constraint PK_ISS_GAME_ISSUE primary key (GAME_CODE, ISSUE_NUMBER);

---------------------------------------
--  New table iss_game_issue_module  --
---------------------------------------
-- Create table
create table ISS_GAME_ISSUE_MODULE
(
  game_code    NUMBER(3) not null,
  xml_content  VARCHAR2(4000),
  issue_number NUMBER(12)
)
;
-- Add comments to the table 
comment on table ISS_GAME_ISSUE_MODULE
  is '游戏期次模板';
-- Add comments to the columns 
comment on column ISS_GAME_ISSUE_MODULE.game_code
  is '游戏编码';
comment on column ISS_GAME_ISSUE_MODULE.xml_content
  is '模板XML';
comment on column ISS_GAME_ISSUE_MODULE.issue_number
  is '期次编号';
-- Create/Recreate primary, unique and foreign key constraints 
alter table ISS_GAME_ISSUE_MODULE
  add constraint PK_ISS_GAME_ISSUE_MODULE primary key (GAME_CODE);

------------------------------------
--  New table iss_game_issue_xml  --
------------------------------------
-- Create table
create table ISS_GAME_ISSUE_XML
(
  game_code           NUMBER(3) not null,
  issue_number        NUMBER(12) not null,
  winning_brodcast    CLOB,
  winner_local_info   CLOB,
  winner_confirm_info CLOB,
  winning_process     VARCHAR2(100)
)
;
-- Add comments to the table 
comment on table ISS_GAME_ISSUE_XML
  is '游戏期次XML';
-- Add comments to the columns 
comment on column ISS_GAME_ISSUE_XML.game_code
  is '游戏编码';
comment on column ISS_GAME_ISSUE_XML.issue_number
  is '游戏期号';
comment on column ISS_GAME_ISSUE_XML.winning_brodcast
  is '期次开奖公告';
comment on column ISS_GAME_ISSUE_XML.winner_local_info
  is '本系统的算奖结果信息';
comment on column ISS_GAME_ISSUE_XML.winner_confirm_info
  is '确认后的算奖结果信息';
comment on column ISS_GAME_ISSUE_XML.winning_process
  is '算奖进度';
-- Create/Recreate primary, unique and foreign key constraints 
alter table ISS_GAME_ISSUE_XML
  add constraint PK_ISS_GAME_ISSUE_XML primary key (GAME_CODE, ISSUE_NUMBER);

--------------------------------------
--  New table iss_game_policy_fund  --
--------------------------------------
-- Create table
create table ISS_GAME_POLICY_FUND
(
  game_code         NUMBER(3) not null,
  issue_number      NUMBER(12) not null,
  sale_amount       NUMBER(28),
  theory_win_amount NUMBER(28),
  fund_amount       NUMBER(28),
  comm_amount       NUMBER(28),
  adj_fund          NUMBER(28)
)
;
-- Add comments to the table 
comment on table ISS_GAME_POLICY_FUND
  is '游戏期次政策资金表';
-- Add comments to the columns 
comment on column ISS_GAME_POLICY_FUND.game_code
  is '游戏编码';
comment on column ISS_GAME_POLICY_FUND.issue_number
  is '游戏期号';
comment on column ISS_GAME_POLICY_FUND.sale_amount
  is '销售金额';
comment on column ISS_GAME_POLICY_FUND.theory_win_amount
  is '理论返奖';
comment on column ISS_GAME_POLICY_FUND.fund_amount
  is '公益金';
comment on column ISS_GAME_POLICY_FUND.comm_amount
  is '发行费';
comment on column ISS_GAME_POLICY_FUND.adj_fund
  is '调节基金';
-- Create/Recreate primary, unique and foreign key constraints 
alter table ISS_GAME_POLICY_FUND
  add constraint PK_ISS_GAME_POLICY_FUND primary key (GAME_CODE, ISSUE_NUMBER);

-------------------------------
--  New table iss_game_pool  --
-------------------------------
-- Create table
create table ISS_GAME_POOL
(
  game_code          NUMBER(3) not null,
  pool_code          NUMBER(1) not null,
  pool_name          VARCHAR2(1000),
  pool_amount_before NUMBER(28),
  pool_amount_after  NUMBER(28),
  adj_time           DATE,
  pool_desc          VARCHAR2(4000)
)
;
-- Add comments to the table 
comment on table ISS_GAME_POOL
  is '游戏当前奖池信息';
-- Add comments to the columns 
comment on column ISS_GAME_POOL.game_code
  is '游戏编码';
comment on column ISS_GAME_POOL.pool_code
  is '奖池编号';
comment on column ISS_GAME_POOL.pool_name
  is '奖池名称';
comment on column ISS_GAME_POOL.pool_amount_before
  is '前次调整余额';
comment on column ISS_GAME_POOL.pool_amount_after
  is '奖池金额';
comment on column ISS_GAME_POOL.adj_time
  is '最后变更时间';
comment on column ISS_GAME_POOL.pool_desc
  is '奖池描述';
-- Create/Recreate primary, unique and foreign key constraints 
alter table ISS_GAME_POOL
  add constraint PK_ISS_GAME_POOL primary key (GAME_CODE, POOL_CODE);

-----------------------------------
--  New table iss_game_pool_adj  --
-----------------------------------
-- Create table
create table ISS_GAME_POOL_ADJ
(
  pool_flow          CHAR(32) not null,
  game_code          NUMBER(3) not null,
  pool_code          NUMBER(1) not null,
  pool_adj_type      NUMBER(1) not null,
  adj_amount         NUMBER(28) not null,
  pool_amount_before NUMBER(28),
  pool_amount_after  NUMBER(28),
  adj_desc           VARCHAR2(1000),
  adj_time           DATE,
  adj_admin          NUMBER(4) not null,
  is_adj             NUMBER(1) default 1 not null
)
;
-- Add comments to the table 
comment on table ISS_GAME_POOL_ADJ
  is '游戏奖池手工调整信息';
-- Add comments to the columns 
comment on column ISS_GAME_POOL_ADJ.pool_flow
  is '变更流水';
comment on column ISS_GAME_POOL_ADJ.game_code
  is '游戏编码';
comment on column ISS_GAME_POOL_ADJ.pool_code
  is '奖池编号';
comment on column ISS_GAME_POOL_ADJ.pool_adj_type
  is '奖池变更类型（1、期次开奖滚入；2、弃奖滚入；3、调节基金自动拨入；4、调节基金手动拨入；5、发行费手动拨入；6、其他来源手动拨入；7、奖池初始化设置。）';
comment on column ISS_GAME_POOL_ADJ.adj_amount
  is '变更金额';
comment on column ISS_GAME_POOL_ADJ.pool_amount_before
  is '变更前奖池金额';
comment on column ISS_GAME_POOL_ADJ.pool_amount_after
  is '变更后奖池金额';
comment on column ISS_GAME_POOL_ADJ.adj_desc
  is '变更备注';
comment on column ISS_GAME_POOL_ADJ.adj_time
  is '变更时间';
comment on column ISS_GAME_POOL_ADJ.adj_admin
  is '变更人员';
comment on column ISS_GAME_POOL_ADJ.is_adj
  is '变更是否已生效';
-- Create/Recreate primary, unique and foreign key constraints 
alter table ISS_GAME_POOL_ADJ
  add constraint PK_ISS_GAME_POOL_ADJ primary key (POOL_FLOW);

-----------------------------------
--  New table iss_game_pool_his  --
-----------------------------------
-- Create table
create table ISS_GAME_POOL_HIS
(
  his_code           NUMBER(8) not null,
  game_code          NUMBER(3) not null,
  issue_number       NUMBER(12) not null,
  pool_code          NUMBER(1) not null,
  change_amount      NUMBER(28) not null,
  pool_amount_before NUMBER(28) not null,
  pool_amount_after  NUMBER(28) not null,
  adj_time           DATE default sysdate not null,
  pool_adj_type      NUMBER(1) not null,
  adj_reason         VARCHAR2(1000),
  pool_flow          CHAR(32)
)
;
-- Add comments to the table 
comment on table ISS_GAME_POOL_HIS
  is '游戏奖池历史信息';
-- Add comments to the columns 
comment on column ISS_GAME_POOL_HIS.his_code
  is '历史序号';
comment on column ISS_GAME_POOL_HIS.game_code
  is '游戏编码';
comment on column ISS_GAME_POOL_HIS.issue_number
  is '游戏期号（为负数时，保存的内容是期次序号。仅用于无当前期的情形）';
comment on column ISS_GAME_POOL_HIS.pool_code
  is '奖池编号';
comment on column ISS_GAME_POOL_HIS.change_amount
  is '奖池调整金额';
comment on column ISS_GAME_POOL_HIS.pool_amount_before
  is '变更前金额';
comment on column ISS_GAME_POOL_HIS.pool_amount_after
  is '变更后金额';
comment on column ISS_GAME_POOL_HIS.adj_time
  is '变更时间';
comment on column ISS_GAME_POOL_HIS.pool_adj_type
  is '奖池变更类型（1、期次开奖滚入；2、弃奖滚入；3、调节基金自动拨入；4、调节基金手动拨入；5、发行费手动拨入；6、其他来源手动拨入；7、奖池初始化设置。）';
comment on column ISS_GAME_POOL_HIS.adj_reason
  is '变更原因';
comment on column ISS_GAME_POOL_HIS.pool_flow
  is '手工变更流水';
-- Create/Recreate primary, unique and foreign key constraints 
alter table ISS_GAME_POOL_HIS
  add constraint PK_ISS_GAME_POOL_HIS primary key (HIS_CODE);

-------------------------------------
--  New table iss_game_prize_rule  --
-------------------------------------
-- Create table
create table ISS_GAME_PRIZE_RULE
(
  game_code    NUMBER(3) not null,
  issue_number NUMBER(12) not null,
  prize_level  NUMBER(3) not null,
  prize_name   VARCHAR2(1000),
  level_prize  NUMBER(16) not null,
  disp_order   NUMBER(2)
)
;
-- Add comments to the table 
comment on table ISS_GAME_PRIZE_RULE
  is '游戏期次奖金规则';
-- Add comments to the columns 
comment on column ISS_GAME_PRIZE_RULE.game_code
  is '游戏编码';
comment on column ISS_GAME_PRIZE_RULE.issue_number
  is '游戏期号';
comment on column ISS_GAME_PRIZE_RULE.prize_level
  is '奖等';
comment on column ISS_GAME_PRIZE_RULE.prize_name
  is '奖等名称';
comment on column ISS_GAME_PRIZE_RULE.level_prize
  is '奖级奖金';
comment on column ISS_GAME_PRIZE_RULE.disp_order
  is '显示顺序';
-- Create/Recreate primary, unique and foreign key constraints 
alter table ISS_GAME_PRIZE_RULE
  add constraint PK_ISS_GAME_PRIZE_RULE primary key (GAME_CODE, ISSUE_NUMBER, PRIZE_LEVEL);

---------------------------
--  New table iss_prize  --
---------------------------
-- Create table
create table ISS_PRIZE
(
  game_code             NUMBER(3) not null,
  issue_number          NUMBER(12) not null,
  prize_level           NUMBER(3) not null,
  prize_name            VARCHAR2(1000),
  is_hd_prize           NUMBER(1) not null,
  prize_count           NUMBER(8) not null,
  single_bet_reward     NUMBER(16) not null,
  single_bet_reward_tax NUMBER(16),
  tax                   NUMBER(16)
)
;
-- Add comments to the table 
comment on table ISS_PRIZE
  is '游戏期次奖级奖金';
-- Add comments to the columns 
comment on column ISS_PRIZE.game_code
  is '游戏编码';
comment on column ISS_PRIZE.issue_number
  is '游戏期号';
comment on column ISS_PRIZE.prize_level
  is '奖等';
comment on column ISS_PRIZE.prize_name
  is '奖等名称';
comment on column ISS_PRIZE.is_hd_prize
  is '是否高等奖';
comment on column ISS_PRIZE.prize_count
  is '中奖注数';
comment on column ISS_PRIZE.single_bet_reward
  is '单注奖金';
comment on column ISS_PRIZE.single_bet_reward_tax
  is '税后单注奖金';
comment on column ISS_PRIZE.tax
  is '税金';
-- Create/Recreate primary, unique and foreign key constraints 
alter table ISS_PRIZE
  add constraint PK_ISS_PRIZE primary key (GAME_CODE, ISSUE_NUMBER, PRIZE_LEVEL);

--------------------------------
--  Changed table item_issue  --
--------------------------------
-- Add comments to the columns 
comment on column ITEM_ISSUE.remark
  is '备注';
----------------------------------
--  Changed table item_receipt  --
----------------------------------
-- Add comments to the columns 
comment on column ITEM_RECEIPT.remark
  is '备注';
-------------------------------------
--  New table mis_agency_win_stat  --
-------------------------------------
-- Create table
create table MIS_AGENCY_WIN_STAT
(
  agency_code       CHAR(8) not null,
  game_code         NUMBER(3) not null,
  issue_number      NUMBER(12) not null,
  prize_level       NUMBER(3) not null,
  prize_name        VARCHAR2(1000) not null,
  is_hd_prize       NUMBER(1) default 0 not null,
  winning_count     NUMBER(16) default 0 not null,
  single_bet_reward NUMBER(16) default 0 not null
)
;
-- Add comments to the table 
comment on table MIS_AGENCY_WIN_STAT
  is '销售站期次中奖统计表';
-- Add comments to the columns 
comment on column MIS_AGENCY_WIN_STAT.agency_code
  is '销售站编码';
comment on column MIS_AGENCY_WIN_STAT.game_code
  is '游戏编码';
comment on column MIS_AGENCY_WIN_STAT.issue_number
  is '游戏期号';
comment on column MIS_AGENCY_WIN_STAT.prize_level
  is '奖等';
comment on column MIS_AGENCY_WIN_STAT.prize_name
  is '奖等名称';
comment on column MIS_AGENCY_WIN_STAT.is_hd_prize
  is '是否高等奖';
comment on column MIS_AGENCY_WIN_STAT.winning_count
  is '中奖注数';
comment on column MIS_AGENCY_WIN_STAT.single_bet_reward
  is '单注奖金';
-- Create/Recreate primary, unique and foreign key constraints 
alter table MIS_AGENCY_WIN_STAT
  add constraint PK_MIS_AGENCY_WIN_STAT primary key (AGENCY_CODE, GAME_CODE, ISSUE_NUMBER, PRIZE_LEVEL);

---------------------------------
--  New table mis_report_3111  --
---------------------------------
-- Create table
create table MIS_REPORT_3111
(
  sale_date    DATE not null,
  area_code    CHAR(2) not null,
  area_name    VARCHAR2(1000) not null,
  sale_sum     NUMBER(28) default 0 not null,
  sale_koc6hc  NUMBER(28) default 0 not null,
  sale_kocssc  NUMBER(28) default 0 not null,
  sale_kockeno NUMBER(28) default 0 not null,
  sale_kocq2   NUMBER(28) default 0 not null
)
;
-- Add comments to the table 
comment on table MIS_REPORT_3111
  is '区域游戏销售统计表';
-- Add comments to the columns 
comment on column MIS_REPORT_3111.sale_date
  is '销售日期';
comment on column MIS_REPORT_3111.area_code
  is '区域编码';
comment on column MIS_REPORT_3111.area_name
  is '区域名称';
comment on column MIS_REPORT_3111.sale_sum
  is '销售额';
comment on column MIS_REPORT_3111.sale_koc6hc
  is '天天赢';
comment on column MIS_REPORT_3111.sale_kocssc
  is '七龙星';
comment on column MIS_REPORT_3111.sale_kockeno
  is 'KENO';
comment on column MIS_REPORT_3111.sale_kocq2
  is '快2';
-- Create/Recreate primary, unique and foreign key constraints 
alter table MIS_REPORT_3111
  add constraint PK_MIS_REPORT_3111 primary key (SALE_DATE, AREA_CODE);

---------------------------------
--  New table mis_report_3112  --
---------------------------------
-- Create table
create table MIS_REPORT_3112
(
  purged_date      DATE not null,
  game_code        NUMBER(3) not null,
  issue_number     NUMBER(12) not null,
  winning_sum      NUMBER(28) default 0 not null,
  hd_purged_amount NUMBER(28) default 0 not null,
  ld_purged_amount NUMBER(28) default 0 not null,
  hd_purged_sum    NUMBER(28) default 0 not null,
  ld_purged_sum    NUMBER(28) default 0 not null,
  purged_amount    NUMBER(28) default 0 not null,
  purged_rate      NUMBER(18) default 0 not null
)
;
-- Add comments to the table 
comment on table MIS_REPORT_3112
  is '弃奖统计日报表';
-- Add comments to the columns 
comment on column MIS_REPORT_3112.purged_date
  is '弃奖日期';
comment on column MIS_REPORT_3112.game_code
  is '游戏';
comment on column MIS_REPORT_3112.issue_number
  is '游戏期次';
comment on column MIS_REPORT_3112.winning_sum
  is '中奖总额';
comment on column MIS_REPORT_3112.hd_purged_amount
  is '高等奖弃奖金额';
comment on column MIS_REPORT_3112.ld_purged_amount
  is '低等奖弃奖金额';
comment on column MIS_REPORT_3112.hd_purged_sum
  is '高等奖弃奖注数';
comment on column MIS_REPORT_3112.ld_purged_sum
  is '低等奖弃奖注数';
comment on column MIS_REPORT_3112.purged_amount
  is '合计弃奖金额';
comment on column MIS_REPORT_3112.purged_rate
  is '弃奖百分比（万分位）';
-- Create/Recreate indexes 
create index IDX_MIS_RPT_3112_GAME_ISS on MIS_REPORT_3112 (GAME_CODE, ISSUE_NUMBER);
-- Create/Recreate primary, unique and foreign key constraints 
alter table MIS_REPORT_3112
  add constraint PK_MIS_REPORT_3112 primary key (PURGED_DATE, GAME_CODE, ISSUE_NUMBER);

---------------------------------
--  New table mis_report_3113  --
---------------------------------
-- Create table
create table MIS_REPORT_3113
(
  game_code         NUMBER(3) not null,
  issue_number      NUMBER(12) not null,
  area_code         CHAR(2) not null,
  area_name         VARCHAR2(1000) not null,
  sale_sum          NUMBER(28) default 0 not null,
  hd_winning_sum    NUMBER(28) default 0 not null,
  hd_winning_amount NUMBER(28) default 0 not null,
  ld_winning_sum    NUMBER(28) default 0 not null,
  ld_winning_amount NUMBER(28) default 0 not null,
  winning_sum       NUMBER(28) default 0 not null,
  winning_rate      NUMBER(28) default 0 not null
)
;
-- Add comments to the table 
comment on table MIS_REPORT_3113
  is '区域中奖统计表';
-- Add comments to the columns 
comment on column MIS_REPORT_3113.game_code
  is '游戏';
comment on column MIS_REPORT_3113.issue_number
  is '游戏期次';
comment on column MIS_REPORT_3113.area_code
  is '区域编码';
comment on column MIS_REPORT_3113.area_name
  is '区域名称';
comment on column MIS_REPORT_3113.sale_sum
  is '销售总额';
comment on column MIS_REPORT_3113.hd_winning_sum
  is '高等奖中奖金额';
comment on column MIS_REPORT_3113.hd_winning_amount
  is '高等奖中奖注数';
comment on column MIS_REPORT_3113.ld_winning_sum
  is '固定奖中奖金额';
comment on column MIS_REPORT_3113.ld_winning_amount
  is '固定奖中奖注数';
comment on column MIS_REPORT_3113.winning_sum
  is '中奖金额合计';
comment on column MIS_REPORT_3113.winning_rate
  is '本期中奖率';
-- Create/Recreate primary, unique and foreign key constraints 
alter table MIS_REPORT_3113
  add constraint PK_MIS_REPORT_3113 primary key (GAME_CODE, ISSUE_NUMBER, AREA_CODE);

---------------------------------
--  New table mis_report_3116  --
---------------------------------
-- Create table
create table MIS_REPORT_3116
(
  count_date    DATE not null,
  agency_code   CHAR(8) not null,
  agency_type   NUMBER(4) not null,
  area_code     CHAR(2) not null,
  area_name     VARCHAR2(1000) not null,
  game_code     NUMBER(3) not null,
  issue_number  NUMBER(12) not null,
  sale_sum      NUMBER(28) default 0 not null,
  sale_comm_sum NUMBER(28) default 0 not null
)
;
-- Add comments to the table 
comment on table MIS_REPORT_3116
  is '销售站游戏期次报表';
-- Add comments to the columns 
comment on column MIS_REPORT_3116.count_date
  is '统计日期';
comment on column MIS_REPORT_3116.agency_code
  is '销售站';
comment on column MIS_REPORT_3116.agency_type
  is '销售站类型';
comment on column MIS_REPORT_3116.area_code
  is '区域编码';
comment on column MIS_REPORT_3116.area_name
  is '区域名称';
comment on column MIS_REPORT_3116.game_code
  is '游戏';
comment on column MIS_REPORT_3116.issue_number
  is '游戏期次';
comment on column MIS_REPORT_3116.sale_sum
  is '销售总额';
comment on column MIS_REPORT_3116.sale_comm_sum
  is '销售代销费金额';
-- Create/Recreate primary, unique and foreign key constraints 
alter table MIS_REPORT_3116
  add constraint PK_MIS_REPORT_3116 primary key (COUNT_DATE, AGENCY_CODE, GAME_CODE, ISSUE_NUMBER);

---------------------------------
--  New table mis_report_3117  --
---------------------------------
-- Create table
create table MIS_REPORT_3117
(
  pay_time             DATE not null,
  game_code            NUMBER(3) not null,
  issue_number         NUMBER(12) not null,
  pay_amount           NUMBER(28) not null,
  pay_tax              NUMBER(28),
  pay_amount_after_tax NUMBER(28) not null,
  pay_tsn              CHAR(24),
  sale_tsn             CHAR(24),
  gui_pay_flow         CHAR(24) not null,
  applyflow_sale       CHAR(24) not null,
  winnername           VARCHAR2(1000),
  cert_type            NUMBER(2) default 0,
  cert_no              VARCHAR2(50),
  agency_code          NUMBER(10) not null,
  payer_admin          NUMBER(4)
)
;
-- Add comments to the table 
comment on table MIS_REPORT_3117
  is '大奖兑付明细报表';
-- Add comments to the columns 
comment on column MIS_REPORT_3117.pay_time
  is '兑付日期';
comment on column MIS_REPORT_3117.game_code
  is '游戏编码';
comment on column MIS_REPORT_3117.issue_number
  is '游戏期号';
comment on column MIS_REPORT_3117.pay_amount
  is '兑付金额';
comment on column MIS_REPORT_3117.pay_tax
  is '缴税金额';
comment on column MIS_REPORT_3117.pay_amount_after_tax
  is '实付金额';
comment on column MIS_REPORT_3117.pay_tsn
  is '兑奖tsn';
comment on column MIS_REPORT_3117.sale_tsn
  is '售票tsn';
comment on column MIS_REPORT_3117.gui_pay_flow
  is '兑奖请求流水号';
comment on column MIS_REPORT_3117.applyflow_sale
  is '售票请求流水号';
comment on column MIS_REPORT_3117.winnername
  is '中奖人姓名';
comment on column MIS_REPORT_3117.cert_type
  is '中奖人证件类型(10=身份证、20=护照、30=军官证、40=士兵证、50=回乡证、90=其他证件)';
comment on column MIS_REPORT_3117.cert_no
  is '中奖人证件号码 ';
comment on column MIS_REPORT_3117.agency_code
  is '兑奖销售站编码';
comment on column MIS_REPORT_3117.payer_admin
  is '兑奖操作员编号';
-- Create/Recreate indexes 
create index IDX_MIS_RPT_3117_P_DATE on MIS_REPORT_3117 (PAY_TIME);
-- Create/Recreate primary, unique and foreign key constraints 
alter table MIS_REPORT_3117
  add constraint PK_MIS_REPORT_3117 primary key (GUI_PAY_FLOW);

---------------------------------
--  New table mis_report_3121  --
---------------------------------
-- Create table
create table MIS_REPORT_3121
(
  sale_year   NUMBER(4) not null,
  game_code   NUMBER(3) not null,
  area_code   CHAR(2) not null,
  area_name   VARCHAR2(1000) not null,
  sale_sum    NUMBER(28) default 0 not null,
  sale_sum_1  NUMBER(28) default 0 not null,
  sale_sum_2  NUMBER(28) default 0 not null,
  sale_sum_3  NUMBER(28) default 0 not null,
  sale_sum_4  NUMBER(28) default 0 not null,
  sale_sum_5  NUMBER(28) default 0 not null,
  sale_sum_6  NUMBER(28) default 0 not null,
  sale_sum_7  NUMBER(28) default 0 not null,
  sale_sum_8  NUMBER(28) default 0 not null,
  sale_sum_9  NUMBER(28) default 0 not null,
  sale_sum_10 NUMBER(28) default 0 not null,
  sale_sum_11 NUMBER(28) default 0 not null,
  sale_sum_12 NUMBER(28) default 0 not null
)
;
-- Add comments to the table 
comment on table MIS_REPORT_3121
  is '销售年报';
-- Add comments to the columns 
comment on column MIS_REPORT_3121.sale_year
  is '销售年度';
comment on column MIS_REPORT_3121.game_code
  is '游戏';
comment on column MIS_REPORT_3121.area_code
  is '区域编码';
comment on column MIS_REPORT_3121.area_name
  is '区域名称';
comment on column MIS_REPORT_3121.sale_sum
  is '销售总额';
comment on column MIS_REPORT_3121.sale_sum_1
  is '1月销售额';
comment on column MIS_REPORT_3121.sale_sum_2
  is '2月销售额';
comment on column MIS_REPORT_3121.sale_sum_3
  is '3月销售额';
comment on column MIS_REPORT_3121.sale_sum_4
  is '4月销售额';
comment on column MIS_REPORT_3121.sale_sum_5
  is '5月销售额';
comment on column MIS_REPORT_3121.sale_sum_6
  is '6月销售额';
comment on column MIS_REPORT_3121.sale_sum_7
  is '7月销售额';
comment on column MIS_REPORT_3121.sale_sum_8
  is '8月销售额';
comment on column MIS_REPORT_3121.sale_sum_9
  is '9月销售额';
comment on column MIS_REPORT_3121.sale_sum_10
  is '10月销售额';
comment on column MIS_REPORT_3121.sale_sum_11
  is '11月销售额';
comment on column MIS_REPORT_3121.sale_sum_12
  is '12月销售额';
-- Create/Recreate primary, unique and foreign key constraints 
alter table MIS_REPORT_3121
  add constraint PK_MIS_REPORT_3121 primary key (SALE_YEAR, GAME_CODE, AREA_CODE);

---------------------------------
--  New table mis_report_3122  --
---------------------------------
-- Create table
create table MIS_REPORT_3122
(
  game_code    NUMBER(3) not null,
  issue_number NUMBER(12) not null,
  area_code    CHAR(2) not null,
  area_name    VARCHAR2(1000) not null,
  sale_sum     NUMBER(28) default 0 not null,
  cancel_sum   NUMBER(28) default 0 not null,
  win_sum      NUMBER(28) default 0 not null
)
;
-- Add comments to the table 
comment on table MIS_REPORT_3122
  is '区域游戏期销售、退票与中奖表';
-- Add comments to the columns 
comment on column MIS_REPORT_3122.game_code
  is '游戏';
comment on column MIS_REPORT_3122.issue_number
  is '游戏期次';
comment on column MIS_REPORT_3122.area_code
  is '区域编码';
comment on column MIS_REPORT_3122.area_name
  is '区域名称';
comment on column MIS_REPORT_3122.sale_sum
  is '销售金额';
comment on column MIS_REPORT_3122.cancel_sum
  is '退票金额';
comment on column MIS_REPORT_3122.win_sum
  is '中奖金额';
-- Create/Recreate primary, unique and foreign key constraints 
alter table MIS_REPORT_3122
  add constraint PK_MIS_REPORT_3122 primary key (GAME_CODE, ISSUE_NUMBER, AREA_CODE);

---------------------------------
--  New table mis_report_3123  --
---------------------------------
-- Create table
create table MIS_REPORT_3123
(
  pay_date               DATE not null,
  area_code              CHAR(2) not null,
  area_name              VARCHAR2(1000) not null,
  koc6hc_payment_sum     NUMBER(28) default 0 not null,
  koc6hc_payment_ticket  NUMBER(28) default 0 not null,
  kocssc_payment_sum     NUMBER(28) default 0 not null,
  kocssc_payment_ticket  NUMBER(28) default 0 not null,
  kockeno_payment_sum    NUMBER(28) default 0 not null,
  kockeno_payment_ticket NUMBER(28) default 0 not null,
  kocq2_payment_sum      NUMBER(28) default 0 not null,
  kocq2_payment_ticket   NUMBER(28) default 0 not null,
  payment_sum            NUMBER(28) default 0 not null
)
;
-- Add comments to the table 
comment on table MIS_REPORT_3123
  is '区域游戏兑奖统计日报表';
-- Add comments to the columns 
comment on column MIS_REPORT_3123.pay_date
  is '兑奖日期';
comment on column MIS_REPORT_3123.area_code
  is '区域编码';
comment on column MIS_REPORT_3123.area_name
  is '区域名称';
comment on column MIS_REPORT_3123.koc6hc_payment_sum
  is '天天赢兑奖金额';
comment on column MIS_REPORT_3123.koc6hc_payment_ticket
  is '天天赢兑奖票数';
comment on column MIS_REPORT_3123.kocssc_payment_sum
  is '七龙星兑奖金额';
comment on column MIS_REPORT_3123.kocssc_payment_ticket
  is '七龙星兑奖票数';
comment on column MIS_REPORT_3123.kockeno_payment_sum
  is 'KENO兑奖金额';
comment on column MIS_REPORT_3123.kockeno_payment_ticket
  is 'KENO兑奖票数';
comment on column MIS_REPORT_3123.kocq2_payment_sum
  is '快2兑奖金额';
comment on column MIS_REPORT_3123.kocq2_payment_ticket
  is '快2兑奖票数';
comment on column MIS_REPORT_3123.payment_sum
  is '兑奖金额合计';
-- Create/Recreate primary, unique and foreign key constraints 
alter table MIS_REPORT_3123
  add constraint PK_MIS_REPORT_3123 primary key (PAY_DATE, AREA_CODE);

---------------------------------
--  New table mis_report_3124  --
---------------------------------
-- Create table
create table MIS_REPORT_3124
(
  game_code         NUMBER(3) not null,
  pay_date          DATE not null,
  area_code         CHAR(2) not null,
  area_name         VARCHAR2(1000) not null,
  hd_payment_sum    NUMBER(28) default 0 not null,
  hd_payment_amount NUMBER(28) default 0 not null,
  hd_payment_tax    NUMBER(28) default 0 not null,
  ld_payment_sum    NUMBER(28) default 0 not null,
  ld_payment_amount NUMBER(28) default 0 not null,
  ld_payment_tax    NUMBER(28) default 0 not null,
  payment_sum       NUMBER(28) default 0 not null
)
;
-- Add comments to the table 
comment on table MIS_REPORT_3124
  is '高等奖兑奖统计表';
-- Add comments to the columns 
comment on column MIS_REPORT_3124.game_code
  is '游戏';
comment on column MIS_REPORT_3124.pay_date
  is '兑奖日期';
comment on column MIS_REPORT_3124.area_code
  is '区域编码';
comment on column MIS_REPORT_3124.area_name
  is '区域名称';
comment on column MIS_REPORT_3124.hd_payment_sum
  is '高等奖兑奖金额';
comment on column MIS_REPORT_3124.hd_payment_amount
  is '高等奖兑奖注数';
comment on column MIS_REPORT_3124.hd_payment_tax
  is '高等奖兑奖缴税额';
comment on column MIS_REPORT_3124.ld_payment_sum
  is '低等奖兑奖金额';
comment on column MIS_REPORT_3124.ld_payment_amount
  is '低等奖兑奖注数';
comment on column MIS_REPORT_3124.ld_payment_tax
  is '低等奖兑奖缴税额';
comment on column MIS_REPORT_3124.payment_sum
  is '兑奖金额合计';
-- Create/Recreate primary, unique and foreign key constraints 
alter table MIS_REPORT_3124
  add constraint PK_MIS_REPORT_3124 primary key (GAME_CODE, PAY_DATE, AREA_CODE);

---------------------------------
--  New table mis_report_3125  --
---------------------------------
-- Create table
create table MIS_REPORT_3125
(
  sale_date            DATE not null,
  game_code            NUMBER(3) not null,
  area_code            CHAR(2) not null,
  area_name            VARCHAR2(1000) not null,
  sale_sum             NUMBER(28) default 0 not null,
  sale_count           NUMBER(28) default 0 not null,
  sale_bet             NUMBER(28) default 0 not null,
  single_ticket_amount NUMBER(28) default 0 not null
)
;
-- Add comments to the table 
comment on table MIS_REPORT_3125
  is '区域游戏销售汇总表';
-- Add comments to the columns 
comment on column MIS_REPORT_3125.sale_date
  is '销售日期';
comment on column MIS_REPORT_3125.game_code
  is '游戏';
comment on column MIS_REPORT_3125.area_code
  is '区域编码';
comment on column MIS_REPORT_3125.area_name
  is '区域名称';
comment on column MIS_REPORT_3125.sale_sum
  is '销售总额';
comment on column MIS_REPORT_3125.sale_count
  is '销售票数';
comment on column MIS_REPORT_3125.sale_bet
  is '销售注数';
comment on column MIS_REPORT_3125.single_ticket_amount
  is '平均单票投注额';
-- Create/Recreate primary, unique and foreign key constraints 
alter table MIS_REPORT_3125
  add constraint PK_MIS_REPORT_3125 primary key (SALE_DATE, GAME_CODE, AREA_CODE);

--------------------------------------
--  New table mis_report_gui_aband  --
--------------------------------------
-- Create table
create table MIS_REPORT_GUI_ABAND
(
  pay_date           DATE not null,
  game_code          NUMBER(3) not null,
  issue_number       NUMBER(12) not null,
  prize_level        NUMBER(3) not null,
  prize_bet_count    NUMBER(16),
  prize_ticket_count NUMBER(16),
  is_hd_prize        NUMBER(1),
  winningamounttax   NUMBER(16),
  winningamount      NUMBER(16),
  taxamount          NUMBER(16)
)
;
-- Add comments to the table 
comment on table MIS_REPORT_GUI_ABAND
  is '弃奖统计GUI报表';
-- Add comments to the columns 
comment on column MIS_REPORT_GUI_ABAND.pay_date
  is '弃奖日期';
comment on column MIS_REPORT_GUI_ABAND.game_code
  is '游戏';
comment on column MIS_REPORT_GUI_ABAND.issue_number
  is '游戏期次';
comment on column MIS_REPORT_GUI_ABAND.prize_level
  is '奖等';
comment on column MIS_REPORT_GUI_ABAND.prize_bet_count
  is '弃奖注数';
comment on column MIS_REPORT_GUI_ABAND.prize_ticket_count
  is '弃奖票数';
comment on column MIS_REPORT_GUI_ABAND.is_hd_prize
  is '是否高等奖';
comment on column MIS_REPORT_GUI_ABAND.winningamounttax
  is '弃奖金额(税前)';
comment on column MIS_REPORT_GUI_ABAND.winningamount
  is '弃奖金额(税后)';
comment on column MIS_REPORT_GUI_ABAND.taxamount
  is '税额';
-- Create/Recreate primary, unique and foreign key constraints 
alter table MIS_REPORT_GUI_ABAND
  add constraint PK_MIS_REPORT_GUI_ABANDON primary key (PAY_DATE, GAME_CODE, ISSUE_NUMBER, PRIZE_LEVEL);

--------------------------------
--  New table mis_report_ncp  --
--------------------------------
-- Create table
create table MIS_REPORT_NCP
(
  count_date     DATE not null,
  agency_code    CHAR(8) not null,
  agency_type    NUMBER(4) not null,
  area_code      CHAR(2) not null,
  area_name      VARCHAR2(1000) not null,
  game_code      NUMBER(3) not null,
  issue_number   NUMBER(12) not null,
  sale_sum       NUMBER(28) default 0 not null,
  sale_count     NUMBER(28) default 0 not null,
  cancel_sum     NUMBER(28) default 0 not null,
  cancel_count   NUMBER(28) default 0 not null,
  pay_sum        NUMBER(28) default 0 not null,
  pay_count      NUMBER(28) default 0 not null,
  sale_comm_sum  NUMBER(28) default 0 not null,
  pay_comm_count NUMBER(28) default 0 not null
)
;
-- Add comments to the table 
comment on table MIS_REPORT_NCP
  is '销售站游戏期次报表';
-- Add comments to the columns 
comment on column MIS_REPORT_NCP.count_date
  is '统计日期';
comment on column MIS_REPORT_NCP.agency_code
  is '销售站';
comment on column MIS_REPORT_NCP.agency_type
  is '销售站类型';
comment on column MIS_REPORT_NCP.area_code
  is '区域编码';
comment on column MIS_REPORT_NCP.area_name
  is '区域名称';
comment on column MIS_REPORT_NCP.game_code
  is '游戏';
comment on column MIS_REPORT_NCP.issue_number
  is '游戏期次';
comment on column MIS_REPORT_NCP.sale_sum
  is '销售总额';
comment on column MIS_REPORT_NCP.sale_count
  is '销售票数';
comment on column MIS_REPORT_NCP.cancel_sum
  is '退票总额';
comment on column MIS_REPORT_NCP.cancel_count
  is '退票票数';
comment on column MIS_REPORT_NCP.pay_sum
  is '兑奖总额';
comment on column MIS_REPORT_NCP.pay_count
  is '兑奖票数';
comment on column MIS_REPORT_NCP.sale_comm_sum
  is '销售代销费金额';
comment on column MIS_REPORT_NCP.pay_comm_count
  is '兑奖代销费金额';
-- Create/Recreate primary, unique and foreign key constraints 
alter table MIS_REPORT_NCP
  add constraint PK_MIS_REPORT_NCP primary key (COUNT_DATE, AGENCY_CODE, GAME_CODE, ISSUE_NUMBER);

------------------------------------
--  New table msg_agency_brocast  --
------------------------------------
-- Create table
create table MSG_AGENCY_BROCAST
(
  notice_id   NUMBER(8) not null,
  cast_string VARCHAR2(4000) not null,
  send_admin  NUMBER(8) not null,
  title       VARCHAR2(400) not null,
  content     VARCHAR2(4000) not null,
  create_time DATE not null,
  send_time   DATE
)
;
-- Add comments to the table 
comment on table MSG_AGENCY_BROCAST
  is '销售站公告';
-- Add comments to the columns 
comment on column MSG_AGENCY_BROCAST.notice_id
  is '消息ID';
comment on column MSG_AGENCY_BROCAST.cast_string
  is '接收对象编码';
comment on column MSG_AGENCY_BROCAST.send_admin
  is '发送人编号';
comment on column MSG_AGENCY_BROCAST.title
  is '标题';
comment on column MSG_AGENCY_BROCAST.content
  is '消息内容';
comment on column MSG_AGENCY_BROCAST.create_time
  is '创建时间';
comment on column MSG_AGENCY_BROCAST.send_time
  is '发送时间';
-- Create/Recreate primary, unique and foreign key constraints 
alter table MSG_AGENCY_BROCAST
  add constraint PK_MSG_AGENCY_BROCAST primary key (NOTICE_ID);

-------------------------------------------
--  New table msg_agency_brocast_detail  --
-------------------------------------------
-- Create table
create table MSG_AGENCY_BROCAST_DETAIL
(
  detail_id NUMBER(18) not null,
  notice_id NUMBER(8) not null,
  cast_code NUMBER(12) not null
)
;
-- Add comments to the table 
comment on table MSG_AGENCY_BROCAST_DETAIL
  is '销售站公告子表';
-- Add comments to the columns 
comment on column MSG_AGENCY_BROCAST_DETAIL.detail_id
  is '细目ID';
comment on column MSG_AGENCY_BROCAST_DETAIL.notice_id
  is '消息ID';
comment on column MSG_AGENCY_BROCAST_DETAIL.cast_code
  is '接收对象编码';
-- Create/Recreate primary, unique and foreign key constraints 
alter table MSG_AGENCY_BROCAST_DETAIL
  add constraint PK_MSG_AGENCY_BROCAST_DETAIL primary key (DETAIL_ID);

-----------------------------
--  New table msg_instant  --
-----------------------------
-- Create table
create table MSG_INSTANT
(
  notice_id   NUMBER(8) not null,
  cast_string VARCHAR2(4000) not null,
  send_admin  NUMBER(8) not null,
  content     VARCHAR2(4000) not null,
  disp_second NUMBER(4) not null,
  disp_loc    NUMBER(1) not null,
  create_time DATE not null,
  send_time   DATE
)
;
-- Add comments to the table 
comment on table MSG_INSTANT
  is '终端即时消息表';
-- Add comments to the columns 
comment on column MSG_INSTANT.notice_id
  is '消息ID';
comment on column MSG_INSTANT.cast_string
  is '接收主体';
comment on column MSG_INSTANT.send_admin
  is '发送人';
comment on column MSG_INSTANT.content
  is '消息内容';
comment on column MSG_INSTANT.disp_second
  is '显示时间（秒）';
comment on column MSG_INSTANT.disp_loc
  is '显示位置（1=主屏、2=TDS、3=打印机）';
comment on column MSG_INSTANT.create_time
  is '创建时间';
comment on column MSG_INSTANT.send_time
  is '发送时间';
-- Create/Recreate primary, unique and foreign key constraints 
alter table MSG_INSTANT
  add constraint PK_MSG_INSTANT primary key (NOTICE_ID);

-----------------------------------
--  New table saler_agency_icon  --
-----------------------------------
-- Create table
create table SALER_AGENCY_ICON
(
  id    NUMBER(16) not null,
  icon  VARCHAR2(20),
  admin VARCHAR2(4000)
)
;
-- Add comments to the table 
comment on table SALER_AGENCY_ICON
  is '销售站图例';
-- Add comments to the columns 
comment on column SALER_AGENCY_ICON.id
  is '图例编号';
comment on column SALER_AGENCY_ICON.icon
  is '图例服务器路径';
comment on column SALER_AGENCY_ICON.admin
  is '专管员';
-- Create/Recreate primary, unique and foreign key constraints 
alter table SALER_AGENCY_ICON
  add constraint PK_SALER_AGENCY_ICON primary key (ID);

-----------------------------------
--  New table saler_agency_site  --
-----------------------------------
-- Create table
create table SALER_AGENCY_SITE
(
  agency_code CHAR(8) not null,
  agency_icon NUMBER(16),
  glatlng_n   VARCHAR2(20),
  glatlng_e   VARCHAR2(20),
  agency_part NUMBER(1)
)
;
-- Add comments to the table 
comment on table SALER_AGENCY_SITE
  is '销售站扩展';
-- Add comments to the columns 
comment on column SALER_AGENCY_SITE.agency_code
  is '销售站编码';
comment on column SALER_AGENCY_SITE.agency_icon
  is '图例编号';
comment on column SALER_AGENCY_SITE.glatlng_n
  is '销售站经度';
comment on column SALER_AGENCY_SITE.glatlng_e
  is '销售站维度';
comment on column SALER_AGENCY_SITE.agency_part
  is '销售站区域（2=南区、1=北区）';
-- Create/Recreate primary, unique and foreign key constraints 
alter table SALER_AGENCY_SITE
  add constraint PK_SALER_AGENCY_SITE primary key (AGENCY_CODE);

--------------------------------
--  New table saler_terminal  --
--------------------------------
-- Create table
create table SALER_TERMINAL
(
  terminal_code            CHAR(10) not null,
  agency_code              CHAR(8) not null,
  unique_code              VARCHAR2(20),
  term_type_id             NUMBER(4),
  mac_address              VARCHAR2(20) not null,
  security_id              VARCHAR2(32),
  status                   NUMBER(1) default 0 not null,
  terminal_for_payment     NUMBER(1) default 0 not null,
  is_logging               NUMBER(1) default 0 not null,
  latest_login_teller_code NUMBER(10),
  trans_seq                NUMBER(18) default 1 not null
)
;
-- Add comments to the table 
comment on table SALER_TERMINAL
  is '销售终端';
-- Add comments to the columns 
comment on column SALER_TERMINAL.terminal_code
  is '终端编码';
comment on column SALER_TERMINAL.agency_code
  is '销售站编码';
comment on column SALER_TERMINAL.unique_code
  is '销售终端标识码';
comment on column SALER_TERMINAL.term_type_id
  is '销售终端型号';
comment on column SALER_TERMINAL.mac_address
  is 'MAC地址';
comment on column SALER_TERMINAL.security_id
  is '终端安全卡ID';
comment on column SALER_TERMINAL.status
  is '销售终端状态（1=可用；2=禁用；3=退机）';
comment on column SALER_TERMINAL.terminal_for_payment
  is '是否兑奖机（1=是；0=否）';
comment on column SALER_TERMINAL.is_logging
  is '是否已登录（1=是；0=否）';
comment on column SALER_TERMINAL.latest_login_teller_code
  is '最近登录的销售员编码';
comment on column SALER_TERMINAL.trans_seq
  is '终端交易序号（流水号）';
-- Create/Recreate indexes 
create index IDX_SALER_TERMINAL_AGENCY on SALER_TERMINAL (AGENCY_CODE);
-- Create/Recreate primary, unique and foreign key constraints 
alter table SALER_TERMINAL
  add constraint PK_SALER_TERMINAL primary key (TERMINAL_CODE);

--------------------------------------
--  New table saler_terminal_check  --
--------------------------------------
-- Create table
create table SALER_TERMINAL_CHECK
(
  term_check_id  NUMBER(8) not null,
  terminal_code  CHAR(10) not null,
  collecter_id   NUMBER(4) not null,
  check_time     DATE not null,
  agency_balance NUMBER(12) not null,
  check_balance  NUMBER(1) not null,
  check_terminal NUMBER(1) not null
)
;
-- Add comments to the table 
comment on table SALER_TERMINAL_CHECK
  is '销售终端巡检';
-- Add comments to the columns 
comment on column SALER_TERMINAL_CHECK.term_check_id
  is '巡检ID';
comment on column SALER_TERMINAL_CHECK.terminal_code
  is '终端编码';
comment on column SALER_TERMINAL_CHECK.collecter_id
  is '缴款专员ID';
comment on column SALER_TERMINAL_CHECK.check_time
  is '巡检时间';
comment on column SALER_TERMINAL_CHECK.agency_balance
  is '站点余额';
comment on column SALER_TERMINAL_CHECK.check_balance
  is '站点余额检查是否正常';
comment on column SALER_TERMINAL_CHECK.check_terminal
  is '站点终端检查是否正常';
-- Create/Recreate primary, unique and foreign key constraints 
alter table SALER_TERMINAL_CHECK
  add constraint PK_SALER_TERMINAL_CHECK primary key (TERM_CHECK_ID);

---------------------------------
--  New table sale_cancelinfo  --
---------------------------------
-- Create table
create table SALE_CANCELINFO
(
  gui_cancel_flow  CHAR(24) not null,
  sale_tsn         CHAR(24) not null,
  applyflow_sell   CHAR(24) not null,
  cancel_tsn       CHAR(24),
  sale_agency_code CHAR(8) not null,
  cancel_org_code  CHAR(2) not null,
  game_code        NUMBER(3) not null,
  issue_number     NUMBER(12) not null,
  cancel_amount    NUMBER(28) not null,
  cancel_comm      NUMBER(28) not null,
  canceler_admin   NUMBER(4) not null,
  canceler_name    VARCHAR2(1000),
  cancel_time      DATE not null,
  is_success       NUMBER(1) default 0 not null,
  html_text        VARCHAR2(4000)
)
;
-- Add comments to the table 
comment on table SALE_CANCELINFO
  is 'GUI取消信息记录表';
-- Add comments to the columns 
comment on column SALE_CANCELINFO.gui_cancel_flow
  is '退票请求流水';
comment on column SALE_CANCELINFO.sale_tsn
  is '销售TSN';
comment on column SALE_CANCELINFO.applyflow_sell
  is '售票请求流水号';
comment on column SALE_CANCELINFO.cancel_tsn
  is '退票TSN';
comment on column SALE_CANCELINFO.sale_agency_code
  is '售票销售站';
comment on column SALE_CANCELINFO.cancel_org_code
  is '退票机构';
comment on column SALE_CANCELINFO.game_code
  is '游戏编码';
comment on column SALE_CANCELINFO.issue_number
  is '游戏期号 ';
comment on column SALE_CANCELINFO.cancel_amount
  is '取消金额';
comment on column SALE_CANCELINFO.cancel_comm
  is '佣金';
comment on column SALE_CANCELINFO.canceler_admin
  is '取消操作员编号';
comment on column SALE_CANCELINFO.canceler_name
  is '取消操作员姓名';
comment on column SALE_CANCELINFO.cancel_time
  is '取消时间';
comment on column SALE_CANCELINFO.is_success
  is '是否成功';
comment on column SALE_CANCELINFO.html_text
  is '原始凭证';
-- Create/Recreate primary, unique and foreign key constraints 
alter table SALE_CANCELINFO
  add constraint PK_SALE_CANCELINFO primary key (GUI_CANCEL_FLOW);

----------------------------------
--  New table sale_gamepayinfo  --
----------------------------------
-- Create table
create table SALE_GAMEPAYINFO
(
  gui_pay_flow         CHAR(24) not null,
  pay_tsn              CHAR(24),
  sale_tsn             CHAR(24) not null,
  applyflow_sale       CHAR(24) not null,
  game_code            NUMBER(3) not null,
  issue_number         NUMBER(12) not null,
  issue_number_end     NUMBER(12),
  pay_amount           NUMBER(28) not null,
  pay_tax              NUMBER(28) not null,
  pay_amount_after_tax NUMBER(28) not null,
  winnername           VARCHAR2(1000),
  gender               NUMBER(1),
  cert_type            NUMBER(2),
  cert_no              VARCHAR2(50),
  age                  NUMBER(2),
  birthdate            VARCHAR2(12),
  contact              VARCHAR2(4000),
  org_code             CHAR(2),
  payer_admin          NUMBER(4),
  payer_name           VARCHAR2(1000),
  pay_time             DATE,
  pay_addr             VARCHAR2(4000),
  is_success           NUMBER(1) default 0 not null,
  html_text            VARCHAR2(4000)
)
;
-- Add comments to the table 
comment on table SALE_GAMEPAYINFO
  is 'GUI兑奖信息记录表';
-- Add comments to the columns 
comment on column SALE_GAMEPAYINFO.gui_pay_flow
  is '兑奖请求流水';
comment on column SALE_GAMEPAYINFO.pay_tsn
  is '兑奖TSN';
comment on column SALE_GAMEPAYINFO.sale_tsn
  is '售票TSN';
comment on column SALE_GAMEPAYINFO.applyflow_sale
  is '售票请求流水号';
comment on column SALE_GAMEPAYINFO.game_code
  is '游戏编码';
comment on column SALE_GAMEPAYINFO.issue_number
  is '游戏期号';
comment on column SALE_GAMEPAYINFO.issue_number_end
  is '游戏期号（结束）';
comment on column SALE_GAMEPAYINFO.pay_amount
  is '中奖金额';
comment on column SALE_GAMEPAYINFO.pay_tax
  is '税金';
comment on column SALE_GAMEPAYINFO.pay_amount_after_tax
  is '税后奖金';
comment on column SALE_GAMEPAYINFO.winnername
  is '中奖人姓名';
comment on column SALE_GAMEPAYINFO.gender
  is '中奖人性别(1=男、2=女)';
comment on column SALE_GAMEPAYINFO.cert_type
  is '中奖人证件类型(10=身份证、20=护照、30=军官证、40=士兵证、50=回乡证、90=其他证件)';
comment on column SALE_GAMEPAYINFO.cert_no
  is '中奖人证件号码 ';
comment on column SALE_GAMEPAYINFO.age
  is '中奖人年龄';
comment on column SALE_GAMEPAYINFO.birthdate
  is '中奖人出生日期';
comment on column SALE_GAMEPAYINFO.contact
  is '中奖人联系方式';
comment on column SALE_GAMEPAYINFO.org_code
  is '兑奖部门编码';
comment on column SALE_GAMEPAYINFO.payer_admin
  is '兑奖操作员编号';
comment on column SALE_GAMEPAYINFO.payer_name
  is '兑奖操作员名称';
comment on column SALE_GAMEPAYINFO.pay_time
  is '兑奖时间';
comment on column SALE_GAMEPAYINFO.pay_addr
  is '兑奖地点';
comment on column SALE_GAMEPAYINFO.is_success
  is '是否成功';
comment on column SALE_GAMEPAYINFO.html_text
  is '原始凭证';
-- Create/Recreate indexes 
create index IDX_SALE_GAMEPAY_PAY_TSN on SALE_GAMEPAYINFO (PAY_TSN);
create index IDX_SALE_GAMEPAY_SELL_FLOW on SALE_GAMEPAYINFO (APPLYFLOW_SALE);
create index IDX_SALE_GAMEPAY_SELL_TSN on SALE_GAMEPAYINFO (SALE_TSN);
-- Create/Recreate primary, unique and foreign key constraints 
alter table SALE_GAMEPAYINFO
  add constraint PK_SALE_GAMEPAYINFO primary key (GUI_PAY_FLOW);

--------------------------------------
--  Changed table sale_paid_detail  --
--------------------------------------
-- Add comments to the columns 
comment on column SALE_PAID_DETAIL.paid_status
  is '兑奖状态（1-成功、2-非法票、3-已兑奖、4-中大奖、5-未中奖、6-未销售、8-批次终结）';
-----------------------------
--  New table sub_abandon  --
-----------------------------
-- Create table
create table SUB_ABANDON
(
  abandon_date              CHAR(10) not null,
  abandon_week              CHAR(7) not null,
  abandon_month             CHAR(7) not null,
  abandon_quarter           CHAR(6) not null,
  abandon_year              CHAR(4) not null,
  game_code                 NUMBER(3) not null,
  issue_number              NUMBER(12) not null,
  winning_date              DATE not null,
  sale_agency               CHAR(8) not null,
  sale_area                 CHAR(2) not null,
  sale_teller               NUMBER(8) not null,
  sale_terminal             CHAR(10) not null,
  bet_methold               NUMBER(4) not null,
  loyalty_code              VARCHAR2(50) not null,
  is_big_one                NUMBER(1) not null,
  win_amount                NUMBER(28) default 0,
  win_amount_without_tax    NUMBER(28) default 0,
  tax_amount                NUMBER(28) default 0,
  win_bets                  NUMBER(28) default 0,
  hd_win_amount             NUMBER(28) default 0,
  hd_win_amount_without_tax NUMBER(28) default 0,
  hd_tax_amount             NUMBER(28) default 0,
  hd_win_bets               NUMBER(28) default 0,
  ld_win_amount             NUMBER(28) default 0,
  ld_win_amount_without_tax NUMBER(28) default 0,
  ld_tax_amount             NUMBER(28) default 0,
  ld_win_bets               NUMBER(28) default 0
)
;
-- Add comments to the table 
comment on table SUB_ABANDON
  is '弃奖主题';
-- Add comments to the columns 
comment on column SUB_ABANDON.abandon_date
  is '弃奖日期（YYYY-MM-DD）';
comment on column SUB_ABANDON.abandon_week
  is '弃奖周（YYYY-WK）';
comment on column SUB_ABANDON.abandon_month
  is '弃奖月（YYYY-MM）';
comment on column SUB_ABANDON.abandon_quarter
  is '弃奖季（YYYY-Q）';
comment on column SUB_ABANDON.abandon_year
  is '弃奖年（YYYY）';
comment on column SUB_ABANDON.game_code
  is '游戏';
comment on column SUB_ABANDON.issue_number
  is '销售期次';
comment on column SUB_ABANDON.winning_date
  is '开奖时间';
comment on column SUB_ABANDON.sale_agency
  is '售票销售站';
comment on column SUB_ABANDON.sale_area
  is '售票销售站所在区域';
comment on column SUB_ABANDON.sale_teller
  is '售票销售员';
comment on column SUB_ABANDON.sale_terminal
  is '售票终端';
comment on column SUB_ABANDON.bet_methold
  is '投注方法';
comment on column SUB_ABANDON.loyalty_code
  is '彩民卡编号';
comment on column SUB_ABANDON.is_big_one
  is '是否大奖';
comment on column SUB_ABANDON.win_amount
  is '中奖金额（税前）';
comment on column SUB_ABANDON.win_amount_without_tax
  is '中奖金额（税后）';
comment on column SUB_ABANDON.tax_amount
  is '税额';
comment on column SUB_ABANDON.win_bets
  is '中奖注数';
comment on column SUB_ABANDON.hd_win_amount
  is '高等奖中奖金额（税前）';
comment on column SUB_ABANDON.hd_win_amount_without_tax
  is '高等奖中奖金额（税后）';
comment on column SUB_ABANDON.hd_tax_amount
  is '高等奖税额';
comment on column SUB_ABANDON.hd_win_bets
  is '高等奖中奖注数';
comment on column SUB_ABANDON.ld_win_amount
  is '固定奖中奖金额（税前）';
comment on column SUB_ABANDON.ld_win_amount_without_tax
  is '固定奖中奖金额（税后）';
comment on column SUB_ABANDON.ld_tax_amount
  is '固定奖税额';
comment on column SUB_ABANDON.ld_win_bets
  is '固定奖中奖注数';
-- Create/Recreate indexes 
create index IDX_SUB_ABANDON_AGENCY on SUB_ABANDON (SALE_AGENCY);
create index IDX_SUB_ABANDON_AREA on SUB_ABANDON (SALE_AREA);
create index IDX_SUB_ABANDON_DATE on SUB_ABANDON (ABANDON_DATE);
create index IDX_SUB_ABANDON_GAME_ISS on SUB_ABANDON (GAME_CODE, ISSUE_NUMBER);
create index IDX_SUB_ABANDON_MONTH on SUB_ABANDON (ABANDON_MONTH);
create index IDX_SUB_ABANDON_QUARTER on SUB_ABANDON (ABANDON_QUARTER);
create index IDX_SUB_ABANDON_TELLER on SUB_ABANDON (SALE_TELLER);
create index IDX_SUB_ABANDON_TERMINAL on SUB_ABANDON (SALE_TERMINAL);
create index IDX_SUB_ABANDON_WEEK on SUB_ABANDON (ABANDON_WEEK);
create index IDX_SUB_ABANDON_YEAR on SUB_ABANDON (ABANDON_YEAR);
-- Create/Recreate primary, unique and foreign key constraints 
alter table SUB_ABANDON
  add constraint PK_SUB_ABANDON primary key (ABANDON_DATE, GAME_CODE, ISSUE_NUMBER, WINNING_DATE, SALE_AREA, SALE_AGENCY, SALE_TELLER, SALE_TERMINAL, BET_METHOLD, LOYALTY_CODE, IS_BIG_ONE);

----------------------------
--  New table sub_agency  --
----------------------------
-- Create table
create table SUB_AGENCY
(
  calc_date                  CHAR(10) not null,
  calc_week                  CHAR(7) not null,
  calc_month                 CHAR(7) not null,
  calc_quarter               CHAR(6) not null,
  calc_year                  CHAR(4) not null,
  agency_code                CHAR(8) not null,
  area_code                  CHAR(2) not null,
  sale_amount                NUMBER(28) default 0,
  sale_amount_without_cancel NUMBER(28) default 0,
  cancel_amount              NUMBER(28) default 0,
  pay_amount                 NUMBER(28) default 0,
  sale_commission            NUMBER(28) default 0,
  pay_commission             NUMBER(28) default 0,
  return_amount              NUMBER(28) default 0,
  charge_amount              NUMBER(28) default 0
)
;
-- Add comments to the table 
comment on table SUB_AGENCY
  is '销售站资金主题';
-- Add comments to the columns 
comment on column SUB_AGENCY.calc_date
  is '统计日期（YYYY-MM-DD）';
comment on column SUB_AGENCY.calc_week
  is '统计周（YYYY-WK）';
comment on column SUB_AGENCY.calc_month
  is '统计月（YYYY-MM）';
comment on column SUB_AGENCY.calc_quarter
  is '统计季（YYYY-Q）';
comment on column SUB_AGENCY.calc_year
  is '统计年（YYYY）';
comment on column SUB_AGENCY.agency_code
  is '销售站';
comment on column SUB_AGENCY.area_code
  is '售票销售站所在区域';
comment on column SUB_AGENCY.sale_amount
  is '销售额（含退票）';
comment on column SUB_AGENCY.sale_amount_without_cancel
  is '销售额（不含退票）';
comment on column SUB_AGENCY.cancel_amount
  is '退票额';
comment on column SUB_AGENCY.pay_amount
  is '兑奖额';
comment on column SUB_AGENCY.sale_commission
  is '销售代销费';
comment on column SUB_AGENCY.pay_commission
  is '兑奖代销费';
comment on column SUB_AGENCY.return_amount
  is '清退金额';
comment on column SUB_AGENCY.charge_amount
  is '充值金额';
-- Create/Recreate indexes 
create index IDX_SUB_AGENCY_AGENCY on SUB_AGENCY (AGENCY_CODE);
create index IDX_SUB_AGENCY_AREA on SUB_AGENCY (AREA_CODE);
create index IDX_SUB_AGENCY_DATE on SUB_AGENCY (CALC_DATE);
create index IDX_SUB_AGENCY_MONTH on SUB_AGENCY (CALC_MONTH);
create index IDX_SUB_AGENCY_QUARTER on SUB_AGENCY (CALC_QUARTER);
create index IDX_SUB_AGENCY_WEEK on SUB_AGENCY (CALC_WEEK);
create index IDX_SUB_AGENCY_YEAR on SUB_AGENCY (CALC_YEAR);
-- Create/Recreate primary, unique and foreign key constraints 
alter table SUB_AGENCY
  add constraint PK_SUB_AGENCY primary key (CALC_DATE, AGENCY_CODE);

-----------------------------------
--  New table sub_agency_action  --
-----------------------------------
-- Create table
create table SUB_AGENCY_ACTION
(
  calc_date   CHAR(10) not null,
  agency_code CHAR(8) not null,
  is_saled    NUMBER(1) not null,
  is_logined  NUMBER(1) not null,
  is_paid     NUMBER(1) not null,
  is_charged  NUMBER(1) not null
)
;
-- Add comments to the table 
comment on table SUB_AGENCY_ACTION
  is '销售站动态主题';
-- Add comments to the columns 
comment on column SUB_AGENCY_ACTION.calc_date
  is '统计日期（YYYY-MM-DD）';
comment on column SUB_AGENCY_ACTION.agency_code
  is '销售站';
comment on column SUB_AGENCY_ACTION.is_saled
  is '今日是否销售';
comment on column SUB_AGENCY_ACTION.is_logined
  is '今日是否登录';
comment on column SUB_AGENCY_ACTION.is_paid
  is '今日是否兑奖';
comment on column SUB_AGENCY_ACTION.is_charged
  is '今日是否充值';
-- Create/Recreate indexes 
create index IDX_SUB_AGENCY_AC_AGENCY on SUB_AGENCY_ACTION (AGENCY_CODE);
create index IDX_SUB_AGENCY_AC_DATE on SUB_AGENCY_ACTION (CALC_DATE);
-- Create/Recreate primary, unique and foreign key constraints 
alter table SUB_AGENCY_ACTION
  add constraint PK_SUB_AGENCY_ACTION primary key (CALC_DATE, AGENCY_CODE);

----------------------------
--  New table sub_cancel  --
----------------------------
-- Create table
create table SUB_CANCEL
(
  cancel_date       CHAR(10) not null,
  cancel_week       CHAR(7) not null,
  cancel_month      CHAR(7) not null,
  cancel_quarter    CHAR(6) not null,
  cancel_year       CHAR(4) not null,
  game_code         NUMBER(3) not null,
  issue_number      NUMBER(12) not null,
  cancel_agency     CHAR(8),
  cancel_area       CHAR(2),
  cancel_teller     NUMBER(8),
  cancel_terminal   CHAR(10),
  sale_agency       CHAR(8),
  sale_area         CHAR(2),
  sale_teller       NUMBER(8),
  sale_terminal     CHAR(10),
  loyalty_code      VARCHAR2(50) not null,
  is_gui_pay        NUMBER(1) not null,
  cancel_amount     NUMBER(28) default 0,
  cancel_bets       NUMBER(28) default 0,
  cancel_tickets    NUMBER(28) default 0,
  cancel_commission NUMBER(28) default 0,
  cancel_lines      NUMBER(28) default 0
)
;
-- Add comments to the table 
comment on table SUB_CANCEL
  is '退票主题';
-- Add comments to the columns 
comment on column SUB_CANCEL.cancel_date
  is '退票日期（YYYY-MM-DD）';
comment on column SUB_CANCEL.cancel_week
  is '退票周（YYYY-WK）';
comment on column SUB_CANCEL.cancel_month
  is '退票月（YYYY-MM）';
comment on column SUB_CANCEL.cancel_quarter
  is '退票季（YYYY-Q）';
comment on column SUB_CANCEL.cancel_year
  is '退票年（YYYY）';
comment on column SUB_CANCEL.game_code
  is '游戏';
comment on column SUB_CANCEL.issue_number
  is '销售期次';
comment on column SUB_CANCEL.cancel_agency
  is '退票销售站';
comment on column SUB_CANCEL.cancel_area
  is '退票销售站所属区域';
comment on column SUB_CANCEL.cancel_teller
  is '退票销售员';
comment on column SUB_CANCEL.cancel_terminal
  is '退票终端';
comment on column SUB_CANCEL.sale_agency
  is '“销售”销售站';
comment on column SUB_CANCEL.sale_area
  is '“销售”销售站区域';
comment on column SUB_CANCEL.sale_teller
  is '“销售”销售员';
comment on column SUB_CANCEL.sale_terminal
  is '“销售”销售终端';
comment on column SUB_CANCEL.loyalty_code
  is '彩民卡编号';
comment on column SUB_CANCEL.is_gui_pay
  is '是否GUI退票';
comment on column SUB_CANCEL.cancel_amount
  is '退票涉及金额';
comment on column SUB_CANCEL.cancel_bets
  is '退票涉及注数';
comment on column SUB_CANCEL.cancel_tickets
  is '退票票数';
comment on column SUB_CANCEL.cancel_commission
  is '退票涉及佣金';
comment on column SUB_CANCEL.cancel_lines
  is '退票涉及投注行数量';
-- Create/Recreate indexes 
create index IDX_SUB_CANCEL_AGENCY on SUB_CANCEL (CANCEL_AGENCY);
create index IDX_SUB_CANCEL_AGENCY_S on SUB_CANCEL (SALE_AGENCY);
create index IDX_SUB_CANCEL_AREA on SUB_CANCEL (CANCEL_AREA);
create index IDX_SUB_CANCEL_AREA_S on SUB_CANCEL (SALE_AREA);
create index IDX_SUB_CANCEL_DATE on SUB_CANCEL (CANCEL_DATE);
create index IDX_SUB_CANCEL_GAME_ISS on SUB_CANCEL (GAME_CODE, ISSUE_NUMBER);
create index IDX_SUB_CANCEL_MONTH on SUB_CANCEL (CANCEL_MONTH);
create index IDX_SUB_CANCEL_QUARTER on SUB_CANCEL (CANCEL_QUARTER);
create index IDX_SUB_CANCEL_TELLER on SUB_CANCEL (CANCEL_TELLER);
create index IDX_SUB_CANCEL_TELLER_S on SUB_CANCEL (SALE_TELLER);
create index IDX_SUB_CANCEL_TERMINAL on SUB_CANCEL (CANCEL_TERMINAL);
create index IDX_SUB_CANCEL_TERMINAL_S on SUB_CANCEL (SALE_TERMINAL);
create index IDX_SUB_CANCEL_WEEK on SUB_CANCEL (CANCEL_WEEK);
create index IDX_SUB_CANCEL_YEAR on SUB_CANCEL (CANCEL_YEAR);

-------------------------
--  New table sub_pay  --
-------------------------
-- Create table
create table SUB_PAY
(
  pay_date                  CHAR(10) not null,
  pay_week                  CHAR(7) not null,
  pay_month                 CHAR(7) not null,
  pay_quarter               CHAR(6) not null,
  pay_year                  CHAR(4) not null,
  game_code                 NUMBER(3) not null,
  issue_number              NUMBER(12) not null,
  pay_agency                CHAR(8),
  pay_issue                 NUMBER(12),
  pay_area                  CHAR(2),
  pay_teller                NUMBER(8),
  pay_terminal              CHAR(10),
  loyalty_code              VARCHAR2(50) not null,
  is_gui_pay                NUMBER(1) not null,
  is_big_one                NUMBER(1) not null,
  pay_amount                NUMBER(28) default 0,
  pay_amount_without_tax    NUMBER(28) default 0,
  tax_amount                NUMBER(28) default 0,
  pay_bets                  NUMBER(28) default 0,
  hd_pay_amount             NUMBER(28) default 0,
  hd_pay_amount_without_tax NUMBER(28) default 0,
  hd_tax_amount             NUMBER(28) default 0,
  hd_pay_bets               NUMBER(28) default 0,
  ld_pay_amount             NUMBER(28) default 0,
  ld_pay_amount_without_tax NUMBER(28) default 0,
  ld_tax_amount             NUMBER(28) default 0,
  ld_pay_bets               NUMBER(28) default 0,
  pay_commission            NUMBER(28) default 0,
  pay_tickets               NUMBER(28) default 0
)
;
-- Add comments to the table 
comment on table SUB_PAY
  is '兑奖主题';
-- Add comments to the columns 
comment on column SUB_PAY.pay_date
  is '兑奖日期（YYYY-MM-DD）';
comment on column SUB_PAY.pay_week
  is '兑奖周（YYYY-WK）';
comment on column SUB_PAY.pay_month
  is '兑奖月（YYYY-MM）';
comment on column SUB_PAY.pay_quarter
  is '兑奖季（YYYY-Q）';
comment on column SUB_PAY.pay_year
  is '兑奖年（YYYY）';
comment on column SUB_PAY.game_code
  is '游戏';
comment on column SUB_PAY.issue_number
  is '销售期次';
comment on column SUB_PAY.pay_agency
  is '兑奖销售站';
comment on column SUB_PAY.pay_issue
  is '兑奖期次';
comment on column SUB_PAY.pay_area
  is '兑奖销售所在区域';
comment on column SUB_PAY.pay_teller
  is '兑奖销售员';
comment on column SUB_PAY.pay_terminal
  is '兑奖终端';
comment on column SUB_PAY.loyalty_code
  is '彩民卡编号';
comment on column SUB_PAY.is_gui_pay
  is '是否GUI兑奖';
comment on column SUB_PAY.is_big_one
  is '是否大奖';
comment on column SUB_PAY.pay_amount
  is '兑奖金额（税前）';
comment on column SUB_PAY.pay_amount_without_tax
  is '兑奖金额（税后）';
comment on column SUB_PAY.tax_amount
  is '税额';
comment on column SUB_PAY.pay_bets
  is '兑奖注数';
comment on column SUB_PAY.hd_pay_amount
  is '高等奖兑奖金额（税前）';
comment on column SUB_PAY.hd_pay_amount_without_tax
  is '高等奖兑奖金额（税后）';
comment on column SUB_PAY.hd_tax_amount
  is '高等奖税额';
comment on column SUB_PAY.hd_pay_bets
  is '高等奖兑奖注数';
comment on column SUB_PAY.ld_pay_amount
  is '固定奖兑奖金额（税前）';
comment on column SUB_PAY.ld_pay_amount_without_tax
  is '固定奖兑奖金额（税后）';
comment on column SUB_PAY.ld_tax_amount
  is '固定奖税额';
comment on column SUB_PAY.ld_pay_bets
  is '固定奖兑奖注数';
comment on column SUB_PAY.pay_commission
  is '兑奖佣金';
comment on column SUB_PAY.pay_tickets
  is '兑奖票数';
-- Create/Recreate indexes 
create index IDX_SUB_PAY_AGENCY on SUB_PAY (PAY_AGENCY);
create index IDX_SUB_PAY_AREA on SUB_PAY (PAY_AREA);
create index IDX_SUB_PAY_DATE on SUB_PAY (PAY_DATE);
create index IDX_SUB_PAY_GAME_ISS on SUB_PAY (GAME_CODE, ISSUE_NUMBER);
create index IDX_SUB_PAY_GAME_PAY on SUB_PAY (GAME_CODE, PAY_ISSUE);
create index IDX_SUB_PAY_MONTH on SUB_PAY (PAY_MONTH);
create index IDX_SUB_PAY_QUARTER on SUB_PAY (PAY_QUARTER);
create index IDX_SUB_PAY_TELLER on SUB_PAY (PAY_TELLER);
create index IDX_SUB_PAY_TERMINAL on SUB_PAY (PAY_TERMINAL);
create index IDX_SUB_PAY_WEEK on SUB_PAY (PAY_WEEK);
create index IDX_SUB_PAY_YEAR on SUB_PAY (PAY_YEAR);

--------------------------
--  New table sub_sell  --
--------------------------
-- Create table
create table SUB_SELL
(
  sale_date                   CHAR(10) not null,
  sale_week                   CHAR(7) not null,
  sale_month                  CHAR(7) not null,
  sale_quarter                CHAR(6) not null,
  sale_year                   CHAR(4) not null,
  game_code                   NUMBER(3) not null,
  issue_number                NUMBER(12) not null,
  sale_agency                 CHAR(8) not null,
  sale_area                   CHAR(2) not null,
  sale_teller                 NUMBER(8) not null,
  sale_terminal               CHAR(10) not null,
  bet_methold                 NUMBER(4) not null,
  loyalty_code                VARCHAR2(50) not null,
  result_code                 NUMBER(4) not null,
  sale_amount                 NUMBER(28) default 0,
  sale_bets                   NUMBER(28) default 0,
  sale_commission             NUMBER(28) default 0,
  sale_tickets                NUMBER(28) default 0,
  sale_lines                  NUMBER(28) default 0,
  pure_amount                 NUMBER(28) default 0,
  pure_bets                   NUMBER(28) default 0,
  pure_commission             NUMBER(28) default 0,
  pure_tickets                NUMBER(28) default 0,
  pure_lines                  NUMBER(28) default 0,
  sale_amount_single_issue    NUMBER(28) default 0,
  sale_bets_single_issue      NUMBER(28) default 0,
  pure_amount_single_issue    NUMBER(28) default 0,
  pure_bets_single_issue      NUMBER(28) default 0,
  sale_commision_single_issue NUMBER(28) default 0,
  pure_commision_single_issue NUMBER(28) default 0
)
;
-- Add comments to the table 
comment on table SUB_SELL
  is '销售主题';
-- Add comments to the columns 
comment on column SUB_SELL.sale_date
  is '销售日期（YYYY-MM-DD）';
comment on column SUB_SELL.sale_week
  is '销售周（YYYY-WK）';
comment on column SUB_SELL.sale_month
  is '销售月（YYYY-MM）';
comment on column SUB_SELL.sale_quarter
  is '销售季（YYYY-Q）';
comment on column SUB_SELL.sale_year
  is '销售年（YYYY）';
comment on column SUB_SELL.game_code
  is '游戏';
comment on column SUB_SELL.issue_number
  is '销售期次';
comment on column SUB_SELL.sale_agency
  is '售票销售站';
comment on column SUB_SELL.sale_area
  is '售票销售站所在区域';
comment on column SUB_SELL.sale_teller
  is '售票销售员';
comment on column SUB_SELL.sale_terminal
  is '售票终端';
comment on column SUB_SELL.bet_methold
  is '投注方法';
comment on column SUB_SELL.loyalty_code
  is '彩民卡编号';
comment on column SUB_SELL.result_code
  is '票处理结果';
comment on column SUB_SELL.sale_amount
  is '销售金额（多期票销售算作销售期）';
comment on column SUB_SELL.sale_bets
  is '销售注数（多期票销售算作销售期）';
comment on column SUB_SELL.sale_commission
  is '销售佣金';
comment on column SUB_SELL.sale_tickets
  is '销售票数';
comment on column SUB_SELL.sale_lines
  is '投注行数量';
comment on column SUB_SELL.pure_amount
  is '净销售额';
comment on column SUB_SELL.pure_bets
  is '净销售注数';
comment on column SUB_SELL.pure_commission
  is '净销售佣金';
comment on column SUB_SELL.pure_tickets
  is '净销售票数';
comment on column SUB_SELL.pure_lines
  is '净投注行数量';
comment on column SUB_SELL.sale_amount_single_issue
  is '当期销售额（多期票被拆分后计算当前期）';
comment on column SUB_SELL.sale_bets_single_issue
  is '当期销售注数（多期票被拆分后计算当前期）';
comment on column SUB_SELL.pure_amount_single_issue
  is '当期净销售额（多期票被拆分后计算当前期）';
comment on column SUB_SELL.pure_bets_single_issue
  is '当期净销售注数（多期票被拆分后计算当前期）';
comment on column SUB_SELL.sale_commision_single_issue
  is '当期销售额对应的佣金（多期票被拆分后计算当前期）';
comment on column SUB_SELL.pure_commision_single_issue
  is '当期净销售对应的佣金（多期票被拆分后计算当前期）';
-- Create/Recreate indexes 
create index IDX_SUB_SELL_AGENCY on SUB_SELL (SALE_AGENCY);
create index IDX_SUB_SELL_AREA on SUB_SELL (SALE_AREA);
create index IDX_SUB_SELL_DATE on SUB_SELL (SALE_DATE);
create index IDX_SUB_SELL_GAME_ISS on SUB_SELL (GAME_CODE, ISSUE_NUMBER);
create index IDX_SUB_SELL_MONTH on SUB_SELL (SALE_MONTH);
create index IDX_SUB_SELL_QUARTER on SUB_SELL (SALE_QUARTER);
create index IDX_SUB_SELL_TELLER on SUB_SELL (SALE_TELLER);
create index IDX_SUB_SELL_TERMINAL on SUB_SELL (SALE_TERMINAL);
create index IDX_SUB_SELL_WEEK on SUB_SELL (SALE_WEEK);
create index IDX_SUB_SELL_YEAR on SUB_SELL (SALE_YEAR);
-- Create/Recreate primary, unique and foreign key constraints 
alter table SUB_SELL
  add constraint PK_SUB_SELL primary key (SALE_DATE, SALE_WEEK, SALE_MONTH, SALE_QUARTER, SALE_YEAR, GAME_CODE, ISSUE_NUMBER, SALE_AREA, SALE_AGENCY, SALE_TELLER, SALE_TERMINAL, BET_METHOLD, LOYALTY_CODE, RESULT_CODE);

-------------------------
--  New table sub_win  --
-------------------------
-- Create table
create table SUB_WIN
(
  winning_date              CHAR(10) not null,
  winning_week              CHAR(7) not null,
  winning_month             CHAR(7) not null,
  winning_quarter           CHAR(6) not null,
  winning_year              CHAR(4) not null,
  game_code                 NUMBER(3) not null,
  issue_number              NUMBER(12) not null,
  sale_agency               CHAR(8) not null,
  sale_area                 CHAR(2) not null,
  sale_teller               NUMBER(8) not null,
  sale_terminal             CHAR(10) not null,
  bet_methold               NUMBER(4) not null,
  loyalty_code              VARCHAR2(50) not null,
  is_big_one                NUMBER(1) not null,
  win_amount                NUMBER(28) default 0,
  win_amount_without_tax    NUMBER(28) default 0,
  tax_amount                NUMBER(28) default 0,
  win_bets                  NUMBER(28) default 0,
  hd_win_amount             NUMBER(28) default 0,
  hd_win_amount_without_tax NUMBER(28) default 0,
  hd_tax_amount             NUMBER(28) default 0,
  hd_win_bets               NUMBER(28) default 0,
  ld_win_amount             NUMBER(28) default 0,
  ld_win_amount_without_tax NUMBER(28) default 0,
  ld_tax_amount             NUMBER(28) default 0,
  ld_win_bets               NUMBER(28) default 0
)
;
-- Add comments to the table 
comment on table SUB_WIN
  is '中奖主题';
-- Add comments to the columns 
comment on column SUB_WIN.winning_date
  is '开奖日期（YYYY-MM-DD）';
comment on column SUB_WIN.winning_week
  is '开奖周（YYYY-WK）';
comment on column SUB_WIN.winning_month
  is '开奖月（YYYY-MM）';
comment on column SUB_WIN.winning_quarter
  is '开奖季（YYYY-Q）';
comment on column SUB_WIN.winning_year
  is '开奖年（YYYY）';
comment on column SUB_WIN.game_code
  is '游戏';
comment on column SUB_WIN.issue_number
  is '销售期次';
comment on column SUB_WIN.sale_agency
  is '售票销售站';
comment on column SUB_WIN.sale_area
  is '售票销售站所在区域';
comment on column SUB_WIN.sale_teller
  is '售票销售员';
comment on column SUB_WIN.sale_terminal
  is '售票终端';
comment on column SUB_WIN.bet_methold
  is '投注方法';
comment on column SUB_WIN.loyalty_code
  is '彩民卡编号';
comment on column SUB_WIN.is_big_one
  is '是否大奖';
comment on column SUB_WIN.win_amount
  is '中奖金额（税前）';
comment on column SUB_WIN.win_amount_without_tax
  is '中奖金额（税后）';
comment on column SUB_WIN.tax_amount
  is '税额';
comment on column SUB_WIN.win_bets
  is '中奖注数';
comment on column SUB_WIN.hd_win_amount
  is '高等奖中奖金额（税前）';
comment on column SUB_WIN.hd_win_amount_without_tax
  is '高等奖中奖金额（税后）';
comment on column SUB_WIN.hd_tax_amount
  is '高等奖税额';
comment on column SUB_WIN.hd_win_bets
  is '高等奖中奖注数';
comment on column SUB_WIN.ld_win_amount
  is '固定奖中奖金额（税前）';
comment on column SUB_WIN.ld_win_amount_without_tax
  is '固定奖中奖金额（税后）';
comment on column SUB_WIN.ld_tax_amount
  is '固定奖税额';
comment on column SUB_WIN.ld_win_bets
  is '固定奖中奖注数';
-- Create/Recreate indexes 
create index IDX_SUB_WIN_AGENCY on SUB_WIN (SALE_AGENCY);
create index IDX_SUB_WIN_AREA on SUB_WIN (SALE_AREA);
create index IDX_SUB_WIN_DATE on SUB_WIN (WINNING_DATE);
create index IDX_SUB_WIN_GAME_ISS on SUB_WIN (GAME_CODE, ISSUE_NUMBER);
create index IDX_SUB_WIN_MONTH on SUB_WIN (WINNING_MONTH);
create index IDX_SUB_WIN_QUARTER on SUB_WIN (WINNING_QUARTER);
create index IDX_SUB_WIN_TELLER on SUB_WIN (SALE_TELLER);
create index IDX_SUB_WIN_TERMINAL on SUB_WIN (SALE_TERMINAL);
create index IDX_SUB_WIN_WEEK on SUB_WIN (WINNING_WEEK);
create index IDX_SUB_WIN_YEAR on SUB_WIN (WINNING_YEAR);
-- Create/Recreate primary, unique and foreign key constraints 
alter table SUB_WIN
  add constraint PK_SUB_WIN primary key (WINNING_DATE, WINNING_WEEK, WINNING_MONTH, WINNING_QUARTER, WINNING_YEAR, GAME_CODE, ISSUE_NUMBER, SALE_AREA, SALE_AGENCY, SALE_TELLER, SALE_TERMINAL, BET_METHOLD, LOYALTY_CODE, IS_BIG_ONE);

------------------------------
--  New table sys_calendar  --
------------------------------
-- Create table
create table SYS_CALENDAR
(
  h_day_code  NUMBER(8) not null,
  h_day_start DATE not null,
  h_day_end   DATE not null,
  h_day_desc  VARCHAR2(1000)
)
;
-- Add comments to the table 
comment on table SYS_CALENDAR
  is '节假日日历';
-- Add comments to the columns 
comment on column SYS_CALENDAR.h_day_code
  is '假日序号';
comment on column SYS_CALENDAR.h_day_start
  is '假日开始时间（含）';
comment on column SYS_CALENDAR.h_day_end
  is '假日结束时间（含）';
comment on column SYS_CALENDAR.h_day_desc
  is '假日描述';
-- Create/Recreate primary, unique and foreign key constraints 
alter table SYS_CALENDAR
  add constraint PK_SYS_CALENDAR primary key (H_DAY_CODE);

-------------------------------
--  New table sys_clog_info  --
-------------------------------
-- Create table
create table SYS_CLOG_INFO
(
  sys_clog_seq          NUMBER(16) not null,
  terminal_code         CHAR(10) not null,
  sys_clog_apply_time   DATE not null,
  sys_clog_apply_type   NUMBER(1) not null,
  sys_clog_apply_arg1   VARCHAR2(500) not null,
  sys_clog_apply_status NUMBER(1) default 1 not null,
  sys_clog_succ_time    DATE,
  sys_clog_upload_file  VARCHAR2(500)
)
;
-- Add comments to the table 
comment on table SYS_CLOG_INFO
  is '终端日志采集系统';
-- Add comments to the columns 
comment on column SYS_CLOG_INFO.sys_clog_seq
  is '编号';
comment on column SYS_CLOG_INFO.terminal_code
  is '终端编号';
comment on column SYS_CLOG_INFO.sys_clog_apply_time
  is '申请日期';
comment on column SYS_CLOG_INFO.sys_clog_apply_type
  is '申请类型（1-terminal-server日志、2-terminal-gui日志、3-指定目录文件、4-指定目录）';
comment on column SYS_CLOG_INFO.sys_clog_apply_arg1
  is '申请扩展参数';
comment on column SYS_CLOG_INFO.sys_clog_apply_status
  is '申请状态(1-待处理、2-已完成)';
comment on column SYS_CLOG_INFO.sys_clog_succ_time
  is '完成时间';
comment on column SYS_CLOG_INFO.sys_clog_upload_file
  is '上传文件描述';
-- Create/Recreate primary, unique and foreign key constraints 
alter table SYS_CLOG_INFO
  add constraint PK_SYS_CLOG_INFO primary key (SYS_CLOG_SEQ);

----------------------------
--  New table sys_events  --
----------------------------
-- Create table
create table SYS_EVENTS
(
  event_id      NUMBER(16) not null,
  server_addr   VARCHAR2(50) not null,
  event_type    NUMBER(1) not null,
  event_level   NUMBER(1) not null,
  event_content VARCHAR2(4000) not null,
  event_time    DATE default sysdate not null
)
;
-- Add comments to the table 
comment on table SYS_EVENTS
  is '系统事件';
-- Add comments to the columns 
comment on column SYS_EVENTS.event_id
  is '事件id';
comment on column SYS_EVENTS.server_addr
  is '服务器ip';
comment on column SYS_EVENTS.event_type
  is '事件类型';
comment on column SYS_EVENTS.event_level
  is '事件级别（1=信息；2=警告；3=错误；4=致命）';
comment on column SYS_EVENTS.event_content
  is '事件内容';
comment on column SYS_EVENTS.event_time
  is '事件发生时间';
-- Create/Recreate primary, unique and foreign key constraints 
alter table SYS_EVENTS
  add constraint PK_SYS_EVENTS primary key (EVENT_ID);

-----------------------------------
--  New table sys_host_comm_log  --
-----------------------------------
-- Create table
create table SYS_HOST_COMM_LOG
(
  log_id     NUMBER(18) not null,
  log_time   DATE default Sysdate not null,
  log_info   VARCHAR2(4000) not null,
  log_status NUMBER(1) default 0 not null
)
;
-- Add comments to the table 
comment on table SYS_HOST_COMM_LOG
  is '主机通讯日志';
-- Add comments to the columns 
comment on column SYS_HOST_COMM_LOG.log_id
  is '日志id';
comment on column SYS_HOST_COMM_LOG.log_time
  is '时间戳';
comment on column SYS_HOST_COMM_LOG.log_info
  is '消息体';
comment on column SYS_HOST_COMM_LOG.log_status
  is '主机通讯状态(0=新增、1=主机已经读取)';
-- Create/Recreate primary, unique and foreign key constraints 
alter table SYS_HOST_COMM_LOG
  add constraint PK_SYS_HOST_COMM_LOG primary key (LOG_ID);

----------------------------------
--  New table sys_internal_log  --
----------------------------------
-- Create table
create table SYS_INTERNAL_LOG
(
  log_id   NUMBER(28) not null,
  log_type NUMBER(1) not null,
  log_date TIMESTAMP(6) not null,
  log_desc VARCHAR2(4000) not null
)
;
-- Add comments to the table 
comment on table SYS_INTERNAL_LOG
  is '系统内部日志';
-- Add comments to the columns 
comment on column SYS_INTERNAL_LOG.log_id
  is '日志编号';
comment on column SYS_INTERNAL_LOG.log_type
  is '日志类型(1=日结、2=期结)';
comment on column SYS_INTERNAL_LOG.log_date
  is '生成时间';
comment on column SYS_INTERNAL_LOG.log_desc
  is '描述';
-- Create/Recreate primary, unique and foreign key constraints 
alter table SYS_INTERNAL_LOG
  add constraint PK_SYS_INTERNAL_LOG primary key (LOG_ID);

---------------------------------
--  New table sys_ticket_memo  --
---------------------------------
-- Create table
create table SYS_TICKET_MEMO
(
  his_code    NUMBER(8) not null,
  game_code   NUMBER(3) not null,
  ticket_memo VARCHAR2(1000) not null,
  set_admin   NUMBER(4) not null,
  set_time    DATE default sysdate not null
)
;
-- Add comments to the table 
comment on table SYS_TICKET_MEMO
  is '彩票票面信息';
-- Add comments to the columns 
comment on column SYS_TICKET_MEMO.his_code
  is '历史编号';
comment on column SYS_TICKET_MEMO.game_code
  is '游戏编码';
comment on column SYS_TICKET_MEMO.ticket_memo
  is '票面信息';
comment on column SYS_TICKET_MEMO.set_admin
  is '设置人';
comment on column SYS_TICKET_MEMO.set_time
  is '设置日期';
-- Create/Recreate primary, unique and foreign key constraints 
alter table SYS_TICKET_MEMO
  add constraint PK_SYS_TICKET_MEMO primary key (HIS_CODE, GAME_CODE);

---------------------------------
--  New table tmp_aband_issue  --
---------------------------------
-- Create table
create global temporary table TMP_ABAND_ISSUE
(
  game_code        NUMBER(3) not null,
  issue_number     NUMBER(12) not null,
  real_reward_time DATE,
  issue_seq        NUMBER(12)
)
on commit preserve rows;

----------------------------
--  New table tmp_agency  --
----------------------------
-- Create table
create global temporary table TMP_AGENCY
(
  agency_code      CHAR(8) not null,
  agency_name      VARCHAR2(4000),
  storetype_id     NUMBER(2),
  org_code         CHAR(2),
  area_code        CHAR(4),
  status           NUMBER(1),
  agency_type      NUMBER(1),
  bank_id          NUMBER(4),
  bank_account     VARCHAR2(32),
  marginal_credit  NUMBER(28),
  available_credit NUMBER(28),
  telephone        VARCHAR2(40),
  contact_person   VARCHAR2(200),
  address          VARCHAR2(500),
  agency_add_time  DATE
)
on commit preserve rows;
-- Create/Recreate primary, unique and foreign key constraints 
alter table TMP_AGENCY
  add constraint PK_TMP_AGENCY primary key (AGENCY_CODE);

-------------------------------
--  New table tmp_all_issue  --
-------------------------------
-- Create table
create global temporary table TMP_ALL_ISSUE
(
  game_code        NUMBER(3) not null,
  issue_number     NUMBER(12) not null,
  issue_seq        NUMBER(12),
  real_start_time  DATE,
  real_close_time  DATE,
  real_reward_time DATE,
  start_time       DATE,
  close_time       DATE,
  reward_time      DATE
)
on commit preserve rows;

------------------------------------------
--  New table tmp_calc_issue_broadcast  --
------------------------------------------
-- Create table
create global temporary table TMP_CALC_ISSUE_BROADCAST
(
  agency_code   CHAR(8),
  prize_level   NUMBER(3),
  winning_count NUMBER(16)
)
on commit delete rows;

----------------------------------
--  New table tmp_multi_cancel  --
----------------------------------
-- Create table
create global temporary table TMP_MULTI_CANCEL
(
  applyflow_cancel   CHAR(24) not null,
  canceltime         DATE not null,
  applyflow_sell     CHAR(24),
  c_terminal_code    CHAR(10),
  c_teller_code      NUMBER(8),
  c_agency_code      CHAR(8),
  c_org_code         CHAR(2),
  is_center          NUMBER(1),
  saletime           DATE not null,
  terminal_code      CHAR(10),
  teller_code        NUMBER(8),
  agency_code        CHAR(8),
  game_code          NUMBER(3) not null,
  issue_number       NUMBER(12) not null,
  ticket_amount      NUMBER(28) not null,
  ticket_bet_count   NUMBER(8) not null,
  salecommissionrate NUMBER(4) not null,
  commissionamount   NUMBER(28) not null,
  bet_methold        NUMBER(4) not null,
  bet_line           NUMBER(4) not null,
  loyalty_code       VARCHAR2(50)
)
on commit preserve rows;

-------------------------------
--  New table tmp_multi_pay  --
-------------------------------
-- Create table
create global temporary table TMP_MULTI_PAY
(
  applyflow_pay     CHAR(24) not null,
  applyflow_sell    CHAR(24),
  game_code         NUMBER(3) not null,
  issue_number      NUMBER(12),
  terminal_code     CHAR(10),
  teller_code       NUMBER(8),
  agency_code       CHAR(8),
  org_code          CHAR(2),
  is_center         NUMBER(1),
  paytime           DATE not null,
  winningamounttax  NUMBER(28) not null,
  winningamount     NUMBER(28) not null,
  taxamount         NUMBER(28) not null,
  paycommissionrate NUMBER(4) not null,
  commissionamount  NUMBER(28) not null,
  winningcount      NUMBER(8) not null,
  hd_winning        NUMBER(28) not null,
  hd_count          NUMBER(8) not null,
  ld_winning        NUMBER(28) default 0 not null,
  ld_count          NUMBER(8) not null,
  loyalty_code      VARCHAR2(50),
  is_big_prize      NUMBER(1) not null,
  pay_issue_number  NUMBER(12)
)
on commit preserve rows;

--------------------------------
--  New table tmp_multi_sell  --
--------------------------------
-- Create table
create global temporary table TMP_MULTI_SELL
(
  applyflow_sell       CHAR(24) not null,
  saletime             DATE not null,
  terminal_code        CHAR(10) not null,
  teller_code          NUMBER(8) not null,
  agency_code          CHAR(8) not null,
  game_code            NUMBER(3) not null,
  issue_number         NUMBER(12) not null,
  ticket_amount        NUMBER(28) not null,
  ticket_bet_count     NUMBER(8) not null,
  salecommissionrate   NUMBER(4) not null,
  commissionamount     NUMBER(28) not null,
  salecommissionrate_o NUMBER(4),
  commissionamount_o   NUMBER(28),
  bet_methold          NUMBER(4) not null,
  bet_line             NUMBER(4) not null,
  loyalty_code         VARCHAR2(50),
  result_code          NUMBER(4) not null
)
on commit preserve rows;

------------------------------
--  New table tmp_rst_3111  --
------------------------------
-- Create table
create global temporary table TMP_RST_3111
(
  sale_date    DATE not null,
  area_code    CHAR(2) not null,
  area_name    VARCHAR2(4000),
  sale_sum     NUMBER(28) default 0 not null,
  sale_koc6hc  NUMBER(28) default 0 not null,
  sale_kocssc  NUMBER(28) default 0 not null,
  sale_kockeno NUMBER(28) default 0 not null,
  sale_kocq2   NUMBER(28) default 0 not null
)
on commit preserve rows;
-- Create/Recreate primary, unique and foreign key constraints 
alter table TMP_RST_3111
  add constraint PK_TMP_REPORT_3111 primary key (SALE_DATE, AREA_CODE);

------------------------------
--  New table tmp_rst_3112  --
------------------------------
-- Create table
create global temporary table TMP_RST_3112
(
  purged_date      DATE not null,
  game_code        NUMBER(3) not null,
  issue_number     NUMBER(12) not null,
  winning_sum      NUMBER(28) default 0 not null,
  hd_purged_amount NUMBER(28) default 0 not null,
  ld_purged_amount NUMBER(28) default 0 not null,
  hd_purged_sum    NUMBER(28) default 0 not null,
  ld_purged_sum    NUMBER(28) default 0 not null,
  purged_amount    NUMBER(28) default 0 not null,
  purged_rate      NUMBER(18) default 0 not null
)
on commit preserve rows;
-- Create/Recreate primary, unique and foreign key constraints 
alter table TMP_RST_3112
  add constraint PK_TMP_REPORT_3112 primary key (PURGED_DATE, GAME_CODE, ISSUE_NUMBER);

------------------------------
--  New table tmp_rst_3113  --
------------------------------
-- Create table
create global temporary table TMP_RST_3113
(
  game_code         NUMBER(3) not null,
  issue_number      NUMBER(12) not null,
  area_code         CHAR(2) not null,
  area_name         VARCHAR2(4000),
  sale_sum          NUMBER(28) default 0 not null,
  hd_winning_sum    NUMBER(28) default 0 not null,
  hd_winning_amount NUMBER(28) default 0 not null,
  ld_winning_sum    NUMBER(28) default 0 not null,
  ld_winning_amount NUMBER(28) default 0 not null,
  winning_sum       NUMBER(28) default 0 not null,
  winning_rate      NUMBER(28) default 0 not null
)
on commit preserve rows;
-- Create/Recreate primary, unique and foreign key constraints 
alter table TMP_RST_3113
  add constraint PK_TMP_REPORT_3113 primary key (GAME_CODE, ISSUE_NUMBER, AREA_CODE);

------------------------------
--  New table tmp_rst_3115  --
------------------------------
-- Create table
create global temporary table TMP_RST_3115
(
  count_date    DATE not null,
  count_month   NUMBER(2) not null,
  count_year    NUMBER(4) not null,
  agency_code   CHAR(8) not null,
  agency_type   NUMBER(4) not null,
  area_code     CHAR(2) not null,
  area_name     VARCHAR2(1000) not null,
  before_amount NUMBER(28) default 0 not null,
  sale_sum      NUMBER(28) default 0 not null,
  pure_sum      NUMBER(28) default 0 not null,
  cancel_out    NUMBER(28) default 0 not null,
  cancel_in     NUMBER(28) default 0 not null,
  cancel_other  NUMBER(28) default 0 not null,
  pay_sum       NUMBER(28) default 0 not null,
  charge_sum    NUMBER(28) default 0 not null,
  pure_comm_sum NUMBER(28) default 0 not null,
  settle_sum    NUMBER(28) default 0 not null,
  after_amount  NUMBER(28) default 0 not null
)
on commit preserve rows;
-- Create/Recreate primary, unique and foreign key constraints 
alter table TMP_RST_3115
  add constraint PK_TMP_REPORT_3115 primary key (COUNT_DATE, COUNT_MONTH, COUNT_YEAR, AGENCY_CODE);

------------------------------
--  New table tmp_rst_3116  --
------------------------------
-- Create table
create global temporary table TMP_RST_3116
(
  count_date    DATE not null,
  agency_code   CHAR(8) not null,
  agency_type   NUMBER(4) not null,
  area_code     CHAR(2) not null,
  area_name     VARCHAR2(1000) not null,
  game_code     NUMBER(3) not null,
  issue_number  NUMBER(12) not null,
  sale_sum      NUMBER(28) default 0 not null,
  sale_comm_sum NUMBER(28) default 0 not null
)
on commit preserve rows;
-- Create/Recreate primary, unique and foreign key constraints 
alter table TMP_RST_3116
  add constraint PK_TMP_REPORT_3116 primary key (COUNT_DATE, AGENCY_CODE, GAME_CODE, ISSUE_NUMBER);

------------------------------
--  New table tmp_rst_3121  --
------------------------------
-- Create table
create global temporary table TMP_RST_3121
(
  sale_year   NUMBER(4) not null,
  game_code   NUMBER(3) not null,
  area_code   CHAR(2) not null,
  area_name   VARCHAR2(4000),
  sale_sum    NUMBER(28) default 0 not null,
  sale_sum_1  NUMBER(28) default 0 not null,
  sale_sum_2  NUMBER(28) default 0 not null,
  sale_sum_3  NUMBER(28) default 0 not null,
  sale_sum_4  NUMBER(28) default 0 not null,
  sale_sum_5  NUMBER(28) default 0 not null,
  sale_sum_6  NUMBER(28) default 0 not null,
  sale_sum_7  NUMBER(28) default 0 not null,
  sale_sum_8  NUMBER(28) default 0 not null,
  sale_sum_9  NUMBER(28) default 0 not null,
  sale_sum_10 NUMBER(28) default 0 not null,
  sale_sum_11 NUMBER(28) default 0 not null,
  sale_sum_12 NUMBER(28) default 0 not null
)
on commit preserve rows;
-- Create/Recreate primary, unique and foreign key constraints 
alter table TMP_RST_3121
  add constraint PK_TMP_REPORT_3121 primary key (SALE_YEAR, GAME_CODE, AREA_CODE);

------------------------------
--  New table tmp_rst_3122  --
------------------------------
-- Create table
create global temporary table TMP_RST_3122
(
  game_code    NUMBER(3) not null,
  issue_number NUMBER(12) not null,
  area_code    CHAR(2) not null,
  area_name    VARCHAR2(4000),
  sale_sum     NUMBER(28) default 0 not null,
  cancel_sum   NUMBER(28) default 0 not null,
  win_sum      NUMBER(28) default 0 not null
)
on commit preserve rows;
-- Create/Recreate primary, unique and foreign key constraints 
alter table TMP_RST_3122
  add constraint PK_TMP_REPORT_3122 primary key (GAME_CODE, ISSUE_NUMBER, AREA_CODE);

------------------------------
--  New table tmp_rst_3123  --
------------------------------
-- Create table
create global temporary table TMP_RST_3123
(
  pay_date               DATE not null,
  area_code              CHAR(2) not null,
  area_name              VARCHAR2(4000),
  koc6hc_payment_sum     NUMBER(28) default 0 not null,
  koc6hc_payment_ticket  NUMBER(28) default 0 not null,
  kocssc_payment_sum     NUMBER(28) default 0 not null,
  kocssc_payment_ticket  NUMBER(28) default 0 not null,
  kockeno_payment_sum    NUMBER(28) default 0 not null,
  kockeno_payment_ticket NUMBER(28) default 0 not null,
  kocq2_payment_sum      NUMBER(28) default 0 not null,
  kocq2_payment_ticket   NUMBER(28) default 0 not null,
  payment_sum            NUMBER(28) default 0 not null
)
on commit preserve rows;
-- Create/Recreate primary, unique and foreign key constraints 
alter table TMP_RST_3123
  add constraint PK_TMP_REPORT_3123 primary key (PAY_DATE, AREA_CODE);

------------------------------
--  New table tmp_rst_3124  --
------------------------------
-- Create table
create global temporary table TMP_RST_3124
(
  game_code         NUMBER(3) not null,
  pay_date          DATE not null,
  area_code         CHAR(2) not null,
  area_name         VARCHAR2(4000),
  hd_payment_sum    NUMBER(28) default 0 not null,
  hd_payment_amount NUMBER(28) default 0 not null,
  hd_payment_tax    NUMBER(28) default 0 not null,
  ld_payment_sum    NUMBER(28) default 0 not null,
  ld_payment_amount NUMBER(28) default 0 not null,
  ld_payment_tax    NUMBER(28) default 0 not null,
  payment_sum       NUMBER(28) default 0 not null
)
on commit preserve rows;
-- Create/Recreate primary, unique and foreign key constraints 
alter table TMP_RST_3124
  add constraint PK_TMP_REPORT_3124 primary key (GAME_CODE, PAY_DATE, AREA_CODE);

------------------------------
--  New table tmp_rst_3125  --
------------------------------
-- Create table
create global temporary table TMP_RST_3125
(
  sale_date            DATE not null,
  game_code            NUMBER(3) not null,
  area_code            CHAR(2) not null,
  area_name            VARCHAR2(4000),
  sale_sum             NUMBER(28) default 0 not null,
  sale_count           NUMBER(28) default 0 not null,
  sale_bet             NUMBER(28) default 0 not null,
  single_ticket_amount NUMBER(28) default 0 not null
)
on commit preserve rows;
-- Create/Recreate primary, unique and foreign key constraints 
alter table TMP_RST_3125
  add constraint PK_TMP_REPORT_3125 primary key (SALE_DATE, GAME_CODE, AREA_CODE);

-------------------------------
--  New table tmp_rst_aband  --
-------------------------------
-- Create table
create global temporary table TMP_RST_ABAND
(
  pay_date           DATE not null,
  game_code          NUMBER(3) not null,
  issue_number       NUMBER(12) not null,
  prize_level        NUMBER(3) not null,
  prize_bet_count    NUMBER(28),
  prize_ticket_count NUMBER(28),
  is_hd_prize        NUMBER(1),
  winningamounttax   NUMBER(28),
  winningamount      NUMBER(28),
  taxamount          NUMBER(28)
)
on commit preserve rows;
-- Create/Recreate primary, unique and foreign key constraints 
alter table TMP_RST_ABAND
  add constraint PK_TMP_REPORT_GUI_ABANDON primary key (PAY_DATE, GAME_CODE, ISSUE_NUMBER, PRIZE_LEVEL);

-----------------------------
--  New table tmp_rst_ncp  --
-----------------------------
-- Create table
create global temporary table TMP_RST_NCP
(
  count_date     DATE not null,
  agency_code    CHAR(8) not null,
  agency_type    NUMBER(4) not null,
  area_code      CHAR(2) not null,
  area_name      VARCHAR2(4000),
  game_code      NUMBER(3) not null,
  issue_number   NUMBER(12) not null,
  sale_sum       NUMBER(28) default 0 not null,
  sale_count     NUMBER(28) default 0 not null,
  cancel_sum     NUMBER(28) default 0 not null,
  cancel_count   NUMBER(28) default 0 not null,
  pay_sum        NUMBER(28) default 0 not null,
  pay_count      NUMBER(28) default 0 not null,
  sale_comm_sum  NUMBER(28) default 0 not null,
  pay_comm_count NUMBER(28) default 0 not null
)
on commit preserve rows;
-- Create/Recreate primary, unique and foreign key constraints 
alter table TMP_RST_NCP
  add constraint PK_TMP_REPORT_NCP primary key (COUNT_DATE, AGENCY_CODE, GAME_CODE, ISSUE_NUMBER);

-----------------------------
--  New table tmp_rst_win  --
-----------------------------
-- Create table
create global temporary table TMP_RST_WIN
(
  agency_code       CHAR(8) not null,
  game_code         NUMBER(3) not null,
  issue_number      NUMBER(12) not null,
  prize_level       NUMBER(3) not null,
  prize_name        VARCHAR2(4000) not null,
  is_hd_prize       NUMBER(1) default 0 not null,
  winning_count     NUMBER(28) default 0 not null,
  single_bet_reward NUMBER(28) default 0 not null
)
on commit preserve rows;
-- Create/Recreate primary, unique and foreign key constraints 
alter table TMP_RST_WIN
  add constraint PK_TMP_AGENCY_WIN_STAT primary key (AGENCY_CODE, GAME_CODE, ISSUE_NUMBER, PRIZE_LEVEL);

--------------------------------
--  New table tmp_sell_issue  --
--------------------------------
-- Create table
create global temporary table TMP_SELL_ISSUE
(
  game_code    NUMBER(3) not null,
  issue_number NUMBER(12) not null,
  issue_seq    NUMBER(12)
)
on commit preserve rows;

---------------------------------
--  New table tmp_src_abandon  --
---------------------------------
-- Create table
create global temporary table TMP_SRC_ABANDON
(
  applyflow_sell            CHAR(24) not null,
  abandon_time              DATE not null,
  winning_time              DATE not null,
  terminal_code             CHAR(10) not null,
  teller_code               NUMBER(8) not null,
  agency_code               CHAR(8) not null,
  game_code                 NUMBER(3) not null,
  issue_number              NUMBER(12) not null,
  ticket_amount             NUMBER(28) not null,
  is_big_prize              NUMBER(1) not null,
  win_amount                NUMBER(28) default 0,
  win_amount_without_tax    NUMBER(28) default 0,
  tax_amount                NUMBER(28) default 0,
  win_bets                  NUMBER(28) default 0,
  hd_win_amount             NUMBER(28) default 0,
  hd_win_amount_without_tax NUMBER(28) default 0,
  hd_tax_amount             NUMBER(28) default 0,
  hd_win_bets               NUMBER(28) default 0,
  ld_win_amount             NUMBER(28) default 0,
  ld_win_amount_without_tax NUMBER(28) default 0,
  ld_tax_amount             NUMBER(28) default 0,
  ld_win_bets               NUMBER(28) default 0
)
on commit preserve rows;

----------------------------------------
--  New table tmp_src_abandon_detail  --
----------------------------------------
-- Create table
create global temporary table TMP_SRC_ABANDON_DETAIL
(
  applyflow_sell   CHAR(24) not null,
  abandon_time     DATE not null,
  winning_time     DATE not null,
  game_code        NUMBER(3) not null,
  issue_number     NUMBER(12) not null,
  prize_level      NUMBER(3),
  prize_count      NUMBER(28),
  is_hd_prize      NUMBER(1),
  winningamounttax NUMBER(28),
  winningamount    NUMBER(28),
  taxamount        NUMBER(28)
)
on commit preserve rows;

--------------------------------
--  New table tmp_src_cancel  --
--------------------------------
-- Create table
create global temporary table TMP_SRC_CANCEL
(
  applyflow_cancel   CHAR(24) not null,
  canceltime         DATE not null,
  applyflow_sell     CHAR(24) not null,
  c_terminal_code    CHAR(10),
  c_teller_code      NUMBER(8),
  c_agency_code      CHAR(8),
  c_org_code         CHAR(2),
  is_center          NUMBER(1),
  saletime           DATE not null,
  terminal_code      CHAR(10),
  teller_code        NUMBER(8),
  agency_code        CHAR(8),
  game_code          NUMBER(3) not null,
  issue_number       NUMBER(12) not null,
  ticket_amount      NUMBER(28) not null,
  ticket_bet_count   NUMBER(8) not null,
  salecommissionrate NUMBER(4) not null,
  commissionamount   NUMBER(28) not null,
  bet_methold        NUMBER(4) not null,
  bet_line           NUMBER(4) not null,
  loyalty_code       VARCHAR2(50)
)
on commit preserve rows;

-----------------------------
--  New table tmp_src_pay  --
-----------------------------
-- Create table
create global temporary table TMP_SRC_PAY
(
  applyflow_pay     CHAR(24) not null,
  applyflow_sell    CHAR(24),
  game_code         NUMBER(3) not null,
  issue_number      NUMBER(12),
  terminal_code     CHAR(10),
  teller_code       NUMBER(8),
  agency_code       CHAR(8),
  org_code          CHAR(2),
  is_center         NUMBER(1),
  paytime           DATE not null,
  winningamounttax  NUMBER(28) not null,
  winningamount     NUMBER(28) not null,
  taxamount         NUMBER(28) not null,
  paycommissionrate NUMBER(4) not null,
  commissionamount  NUMBER(28) not null,
  winningcount      NUMBER(8) not null,
  hd_winning        NUMBER(28) not null,
  hd_count          NUMBER(8) not null,
  ld_winning        NUMBER(28) default 0 not null,
  ld_count          NUMBER(8) not null,
  loyalty_code      VARCHAR2(50),
  is_big_prize      NUMBER(1) not null,
  pay_issue_number  NUMBER(12)
)
on commit preserve rows;

------------------------------
--  New table tmp_src_sell  --
------------------------------
-- Create table
create global temporary table TMP_SRC_SELL
(
  applyflow_sell       CHAR(24) not null,
  saletime             DATE not null,
  terminal_code        CHAR(10) not null,
  teller_code          NUMBER(8) not null,
  agency_code          CHAR(8) not null,
  game_code            NUMBER(3) not null,
  issue_number         NUMBER(12) not null,
  start_issue          NUMBER(12) not null,
  end_issue            NUMBER(12) not null,
  issue_count          NUMBER(8) not null,
  ticket_amount        NUMBER(28) not null,
  ticket_bet_count     NUMBER(8) not null,
  salecommissionrate   NUMBER(8) not null,
  commissionamount     NUMBER(28) not null,
  salecommissionrate_o NUMBER(8),
  commissionamount_o   NUMBER(28),
  bet_methold          NUMBER(4) not null,
  bet_line             NUMBER(4) not null,
  loyalty_code         VARCHAR2(50),
  result_code          NUMBER(4) not null
)
on commit preserve rows;

-------------------------------------
--  New table tmp_src_sell_detail  --
-------------------------------------
-- Create table
create global temporary table TMP_SRC_SELL_DETAIL
(
  applyflow_sell CHAR(24) not null,
  saletime       DATE not null,
  line_no        NUMBER(2) not null,
  bet_type       NUMBER(4) not null,
  subtype        NUMBER(8) not null,
  oper_type      NUMBER(4) not null,
  section        VARCHAR2(500) not null,
  bet_amount     NUMBER(8) not null,
  bet_count      NUMBER(8) not null,
  line_amount    NUMBER(28) not null
)
on commit preserve rows;

-----------------------------
--  New table tmp_src_win  --
-----------------------------
-- Create table
create global temporary table TMP_SRC_WIN
(
  applyflow_sell            CHAR(24) not null,
  winning_time              DATE not null,
  terminal_code             CHAR(10),
  teller_code               NUMBER(8),
  agency_code               CHAR(8),
  game_code                 NUMBER(3),
  issue_number              NUMBER(12),
  ticket_amount             NUMBER(28),
  is_big_prize              NUMBER(1),
  win_amount                NUMBER(28) default 0,
  win_amount_without_tax    NUMBER(28) default 0,
  tax_amount                NUMBER(28) default 0,
  win_bets                  NUMBER(28) default 0,
  hd_win_amount             NUMBER(28) default 0,
  hd_win_amount_without_tax NUMBER(28) default 0,
  hd_tax_amount             NUMBER(28) default 0,
  hd_win_bets               NUMBER(28) default 0,
  ld_win_amount             NUMBER(28) default 0,
  ld_win_amount_without_tax NUMBER(28) default 0,
  ld_tax_amount             NUMBER(28) default 0,
  ld_win_bets               NUMBER(28) default 0
)
on commit preserve rows;

-------------------------------
--  New table tmp_win_issue  --
-------------------------------
-- Create table
create global temporary table TMP_WIN_ISSUE
(
  game_code    NUMBER(3) not null,
  issue_number NUMBER(12) not null,
  issue_seq    NUMBER(12)
)
on commit preserve rows;

-----------------------------
--  New table upg_package  --
-----------------------------
-- Create table
create table UPG_PACKAGE
(
  pkg_ver         VARCHAR2(20) not null,
  adapt_term_type NUMBER(4) not null,
  pkg_desc        VARCHAR2(1000),
  release_date    DATE,
  is_valid        NUMBER(1) default 0 not null
)
;
-- Add comments to the table 
comment on table UPG_PACKAGE
  is '软件包';
-- Add comments to the columns 
comment on column UPG_PACKAGE.pkg_ver
  is '软件包版本号';
comment on column UPG_PACKAGE.adapt_term_type
  is '适用终端机型';
comment on column UPG_PACKAGE.pkg_desc
  is '软件包描述';
comment on column UPG_PACKAGE.release_date
  is '发布日期';
comment on column UPG_PACKAGE.is_valid
  is '是否可用';
-- Create/Recreate primary, unique and foreign key constraints 
alter table UPG_PACKAGE
  add constraint PK_UPG_PACKAGE primary key (PKG_VER, ADAPT_TERM_TYPE);

---------------------------------
--  New table upg_pkg_context  --
---------------------------------
-- Create table
create table UPG_PKG_CONTEXT
(
  pkg_ver         VARCHAR2(20) not null,
  soft_id         NUMBER(8) not null,
  soft_ver        VARCHAR2(20) not null,
  adapt_term_type NUMBER(4) not null
)
;
-- Add comments to the table 
comment on table UPG_PKG_CONTEXT
  is '软件包内容';
-- Add comments to the columns 
comment on column UPG_PKG_CONTEXT.pkg_ver
  is '软件包版本号';
comment on column UPG_PKG_CONTEXT.soft_id
  is '软件ID';
comment on column UPG_PKG_CONTEXT.soft_ver
  is '软件版本号';
comment on column UPG_PKG_CONTEXT.adapt_term_type
  is '适用终端机型';
-- Create/Recreate primary, unique and foreign key constraints 
alter table UPG_PKG_CONTEXT
  add constraint PK_UPG_PKG_CONTEXT primary key (PKG_VER, SOFT_ID, SOFT_VER, ADAPT_TERM_TYPE);

------------------------------
--  New table upg_software  --
------------------------------
-- Create table
create table UPG_SOFTWARE
(
  soft_id       NUMBER(8) not null,
  soft_name     VARCHAR2(1000),
  soft_describe VARCHAR2(1000),
  create_date   DATE
)
;
-- Add comments to the table 
comment on table UPG_SOFTWARE
  is '软件';
-- Add comments to the columns 
comment on column UPG_SOFTWARE.soft_id
  is '软件ID';
comment on column UPG_SOFTWARE.soft_name
  is '软件名称';
comment on column UPG_SOFTWARE.soft_describe
  is '软件描述';
comment on column UPG_SOFTWARE.create_date
  is '建立日期';
-- Create/Recreate primary, unique and foreign key constraints 
alter table UPG_SOFTWARE
  add constraint PK_UPG_SOFTWARE primary key (SOFT_ID);

----------------------------------
--  New table upg_software_ver  --
----------------------------------
-- Create table
create table UPG_SOFTWARE_VER
(
  soft_ver        VARCHAR2(20) not null,
  soft_id         NUMBER(8) not null,
  adapt_term_type NUMBER(4) not null,
  release_date    DATE,
  ver_desc        VARCHAR2(1000),
  ver_size        NUMBER(16),
  ver_md5         VARCHAR2(32)
)
;
-- Add comments to the table 
comment on table UPG_SOFTWARE_VER
  is '软件版本';
-- Add comments to the columns 
comment on column UPG_SOFTWARE_VER.soft_ver
  is '软件版本号';
comment on column UPG_SOFTWARE_VER.soft_id
  is '软件ID';
comment on column UPG_SOFTWARE_VER.adapt_term_type
  is '适用终端机型';
comment on column UPG_SOFTWARE_VER.release_date
  is '发布日期';
comment on column UPG_SOFTWARE_VER.ver_desc
  is '软件版本描述';
comment on column UPG_SOFTWARE_VER.ver_size
  is '软件包大小（字节）';
comment on column UPG_SOFTWARE_VER.ver_md5
  is 'MD5值';
-- Create/Recreate primary, unique and foreign key constraints 
alter table UPG_SOFTWARE_VER
  add constraint PK_UPG_SOFTWARE_VER primary key (SOFT_VER, SOFT_ID, ADAPT_TERM_TYPE);

-----------------------------------
--  New table upg_term_software  --
-----------------------------------
-- Create table
create table UPG_TERM_SOFTWARE
(
  terminal_code     CHAR(10) not null,
  term_type         NUMBER(4) not null,
  running_pkg_ver   VARCHAR2(20),
  downing_pkg_ver   VARCHAR2(20),
  last_upgrade_date DATE,
  last_report_date  DATE
)
;
-- Add comments to the table 
comment on table UPG_TERM_SOFTWARE
  is '终端软件信息';
-- Add comments to the columns 
comment on column UPG_TERM_SOFTWARE.terminal_code
  is '终端编码';
comment on column UPG_TERM_SOFTWARE.term_type
  is '终端机型';
comment on column UPG_TERM_SOFTWARE.running_pkg_ver
  is '运行软件包版本号';
comment on column UPG_TERM_SOFTWARE.downing_pkg_ver
  is '正在下载的软件包版本号';
comment on column UPG_TERM_SOFTWARE.last_upgrade_date
  is '最近升级日期';
comment on column UPG_TERM_SOFTWARE.last_report_date
  is '最近上报日期';
-- Create/Recreate primary, unique and foreign key constraints 
alter table UPG_TERM_SOFTWARE
  add constraint PK_UPG_TERM_SOFTWARE primary key (TERMINAL_CODE, TERM_TYPE);

---------------------------------
--  New table upg_upgradeplan  --
---------------------------------
-- Create table
create table UPG_UPGRADEPLAN
(
  schedule_id          NUMBER(8) not null,
  schedule_name        VARCHAR2(4000),
  pkg_ver              VARCHAR2(20) not null,
  term_type            NUMBER(4) not null,
  schedule_status      NUMBER(1) not null,
  schedule_sw_date     DATE,
  schedule_cr_date     DATE not null,
  schedule_exec_date   DATE,
  schedule_cancel_date DATE
)
;
-- Add comments to the table 
comment on table UPG_UPGRADEPLAN
  is '升级计划';
-- Add comments to the columns 
comment on column UPG_UPGRADEPLAN.schedule_id
  is '计划ID';
comment on column UPG_UPGRADEPLAN.schedule_name
  is '计划名称';
comment on column UPG_UPGRADEPLAN.pkg_ver
  is '软件包版本号';
comment on column UPG_UPGRADEPLAN.term_type
  is '终端机型';
comment on column UPG_UPGRADEPLAN.schedule_status
  is '计划状态（1=计划中、2=已执行、3=已取消）';
comment on column UPG_UPGRADEPLAN.schedule_sw_date
  is '计划更新时间';
comment on column UPG_UPGRADEPLAN.schedule_cr_date
  is '建立时间';
comment on column UPG_UPGRADEPLAN.schedule_exec_date
  is '执行时间';
comment on column UPG_UPGRADEPLAN.schedule_cancel_date
  is '取消时间';
-- Create/Recreate primary, unique and foreign key constraints 
alter table UPG_UPGRADEPLAN
  add constraint PK_UPG_UPGRADEPLAN primary key (SCHEDULE_ID);

---------------------------------
--  New table upg_upgradeproc  --
---------------------------------
-- Create table
create table UPG_UPGRADEPROC
(
  terminal_code CHAR(10) not null,
  schedule_id   NUMBER(8) not null,
  pkg_ver       VARCHAR2(20) not null,
  is_comp_dl    NUMBER(1) default 0 not null,
  dl_start_date DATE,
  dl_end_date   DATE,
  dl_proc       VARCHAR2(20),
  dl_filename   VARCHAR2(30)
)
;
-- Add comments to the table 
comment on table UPG_UPGRADEPROC
  is '升级过程';
-- Add comments to the columns 
comment on column UPG_UPGRADEPROC.terminal_code
  is '终端编码';
comment on column UPG_UPGRADEPROC.schedule_id
  is '计划ID';
comment on column UPG_UPGRADEPROC.pkg_ver
  is '软件包版本号';
comment on column UPG_UPGRADEPROC.is_comp_dl
  is '是否已经完成下载';
comment on column UPG_UPGRADEPROC.dl_start_date
  is '开始下载时间';
comment on column UPG_UPGRADEPROC.dl_end_date
  is '完成下载时间';
comment on column UPG_UPGRADEPROC.dl_proc
  is '当前文件下载进度';
comment on column UPG_UPGRADEPROC.dl_filename
  is '当前下载文件名称';
-- Create/Recreate primary, unique and foreign key constraints 
alter table UPG_UPGRADEPROC
  add constraint PK_UPG_UPGRADEPROC primary key (TERMINAL_CODE, SCHEDULE_ID);

-------------------------------------------
--  Changed table wh_goods_issue_detail  --
-------------------------------------------
-- Add comments to the columns 
comment on column WH_GOODS_ISSUE_DETAIL.issue_type
  is '出库类型（1-调拨出库、2-出货单出库，3-损毁出库，4-站点退货）';
-----------------------------------------
--  New sequence seq_collect_apply_id  --
-----------------------------------------
-- Create sequence 
create sequence SEQ_COLLECT_APPLY_ID
minvalue 1
maxvalue 99999999999
start with 1
increment by 1
cache 20
order;

----------------------------------
--  New sequence seq_game_flow  --
----------------------------------
-- Create sequence 
create sequence SEQ_GAME_FLOW
minvalue 1
maxvalue 9999999999999999999999999999
start with 261
increment by 1
cache 20
order;

--------------------------------------
--  New sequence seq_game_his_code  --
--------------------------------------
-- Create sequence 
create sequence SEQ_GAME_HIS_CODE
minvalue 1
maxvalue 9999999999999999999999999999
start with 4301
increment by 1
cache 20
order;

-----------------------------------
--  New sequence seq_his_cancel  --
-----------------------------------
-- Create sequence 
create sequence SEQ_HIS_CANCEL
minvalue 1
maxvalue 9999999999999999999999999999
start with 941
increment by 1
cache 20
order;

----------------------------------
--  New sequence seq_his_logid  --
----------------------------------
-- Create sequence 
create sequence SEQ_HIS_LOGID
minvalue 1
maxvalue 9999999999999999999999999999
start with 4401
increment by 1
cache 20
order;

--------------------------------
--  New sequence seq_his_pay  --
--------------------------------
-- Create sequence 
create sequence SEQ_HIS_PAY
minvalue 1
maxvalue 9999999999999999999999999999
start with 44001
increment by 1
cache 1000
order;

---------------------------------
--  New sequence seq_his_sell  --
---------------------------------
-- Create sequence 
create sequence SEQ_HIS_SELL
minvalue 1
maxvalue 9999999999999999999999999999
start with 43001
increment by 1
cache 1000
order;

-----------------------------------
--  New sequence seq_his_settle  --
-----------------------------------
-- Create sequence 
create sequence SEQ_HIS_SETTLE
minvalue 1
maxvalue 9999999999999999999999999999
start with 701
increment by 1
cache 20
order;

--------------------------------
--  New sequence seq_his_win  --
--------------------------------
-- Create sequence 
create sequence SEQ_HIS_WIN
minvalue 1
maxvalue 9999999999999999999999999999
start with 45001
increment by 1
cache 1000
order;

----------------------------------------
--  New sequence seq_sale_gui_cancel  --
----------------------------------------
-- Create sequence 
create sequence SEQ_SALE_GUI_CANCEL
minvalue 1
maxvalue 999999
start with 641
increment by 1
cache 20
cycle
order;

-------------------------------------
--  New sequence seq_sale_gui_pay  --
-------------------------------------
-- Create sequence 
create sequence SEQ_SALE_GUI_PAY
minvalue 1
maxvalue 999999
start with 501
increment by 1
cache 20
cycle
order;

--------------------------------------
--  New sequence seq_sys_clog_info  --
--------------------------------------
-- Create sequence 
create sequence SEQ_SYS_CLOG_INFO
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20
order;

-------------------------------------
--  New sequence seq_sys_event_id  --
-------------------------------------
-- Create sequence 
create sequence SEQ_SYS_EVENT_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 12301
increment by 1
cache 20
order;

---------------------------------------
--  New sequence seq_sys_host_logid  --
---------------------------------------
-- Create sequence 
create sequence SEQ_SYS_HOST_LOGID
minvalue 1
maxvalue 9999999999999999999999999999
start with 121
increment by 1
cache 20
order;

-------------------------------------
--  New sequence seq_sys_noticeid  --
-------------------------------------
-- Create sequence 
create sequence SEQ_SYS_NOTICEID
minvalue 1
maxvalue 9999999999999999999999999999
start with 161
increment by 1
cache 20
order;

----------------------------------------
--  New sequence seq_upg_schedule_id  --
----------------------------------------
-- Create sequence 
create sequence SEQ_UPG_SCHEDULE_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1961
increment by 1
cache 20
order;

---------------------------------
--  New view mis_report_new_1  --
---------------------------------
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

---------------------------------
--  New view mis_report_new_2  --
---------------------------------
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

-------------------------------------
--  New view mis_report_new_3_day  --
-------------------------------------
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

---------------------------------------
--  New view mis_report_new_3_issue  --
---------------------------------------
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
       sale_amount,
       nvl(hd_pay_amount, 0) as hd_pay_amount,
       nvl(hd_pay_bets, 0) as hd_pay_bets,
       nvl(ld_pay_amount, 0) as ld_pay_amount,
       nvl(ld_pay_bets, 0) as ld_pay_bets,
       nvl(pay_amount, 0) as pay_amount
  from sell
  left join pay
 using (game_code, pay_issue);

-------------------------------------
--  New view mis_report_new_4_day  --
-------------------------------------
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

---------------------------------------
--  New view mis_report_new_4_issue  --
---------------------------------------
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

---------------------------------
--  New view mis_report_new_5  --
---------------------------------
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

---------------------------------
--  New view mis_report_new_6  --
---------------------------------
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

---------------------------------
--  New view mis_report_new_7  --
---------------------------------
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

-------------------------------------
--  New view mis_report_new_9_day  --
-------------------------------------
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

---------------------------------------
--  New view mis_report_new_9_issue  --
---------------------------------------
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
       sale_amount,
       nvl(big_amount, 0) as big_amount,
       nvl(big_count, 0) as big_count,
       nvl(sml_amount, 0) as sml_amount,
       nvl(sml_count, 0) as sml_count,
       (nvl(big_amount, 0) + nvl(sml_amount, 0)) as pay_amount
  from sell
  left join pay
 using (game_code, pay_issue);

--------------------------------
--  New view v_cancel_detail  --
--------------------------------
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

--------------------------------
--  New view v_dict_all_game  --
--------------------------------
create or replace view v_dict_all_game as
select plan_code, SHORT_NAME, FULL_NAME, 1 sys_type from game_plans
union all
-- 电脑票
select to_char(game_code), SHORT_NAME, FULL_NAME, 2 sys_type from inf_games
;

------------------------------------------
--  New view v_game_issue_prize_detail  --
------------------------------------------
create or replace view v_game_issue_prize_detail as
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

-----------------------------
--  New view v_gp_control  --
-----------------------------
create or replace view v_gp_control as
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

---------------------------------
--  New view v_gp_his_current  --
---------------------------------
create or replace view v_gp_his_current as
select his_his_code, game_code, is_open_risk, risk_param
  from gp_history
 where (his_his_code, game_code) in
       (select max(his_his_code), game_code
          from gp_history
         group by game_code);

---------------------------------
--  New view v_gp_normal_rule  --
---------------------------------
create or replace view v_gp_normal_rule as
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

------------------------------------
--  New view v_gp_policy_current  --
------------------------------------
create or replace view v_gp_policy_current as
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

----------------------------------------
--  New view v_gp_prize_rule_current  --
----------------------------------------
create or replace view v_gp_prize_rule_current as
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

----------------------------------
--  New view v_gp_rule_current  --
----------------------------------
create or replace view v_gp_rule_current as
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

--------------------------------------
--  New view v_gp_win_rule_current  --
--------------------------------------
create or replace view v_gp_win_rule_current as
select his_win_code, game_code, wrule_code, wrule_name, wrule_desc
  from gp_win_rule
 where (his_win_code, game_code, wrule_code) in
       (select max(his_win_code), game_code, wrule_code
          from gp_win_rule
         group by game_code, wrule_code);

--------------------------------------------
--  Changed view v_his_agent_fund_report  --
--------------------------------------------
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

select "CALC_DATE","ORG_CODE","CHARGE_AMOUNT","WITHDRAW_AMOUNT","SALE_AMOUNT","ORG_COMM_AMOUNT","ORG_RETURN_AMOUNT","ORG_COMM_ORG_RETURN_AMOUNT","ORG_AGENCY_PAY_COMM_AMOUNT","ORG_AGENCY_PAY_AMOUNT","ORG_CENTER_PAY_COMM_AMOUNT","ORG_CENTER_PAY_AMOUNT","LOT_AGENCY_SALE_AMOUNT","LOT_ORG_AGENCY_PAY_COMM_AMOUNT","LOT_ORG_AGENCY_PAY_AMOUNT","LOT_ORG_CENTER_PAY_COMM_AMOUNT","LOT_ORG_CENTER_PAY_AMOUNT","LOT_ORG_CENTER_CANCEL_AMOUNT","LOT_AGENCY_SALE_COMM_AMOUNT","LOT_AGENCY_CANCEL_COMM_AMOUNT","BEGINING_AMOUNT","ENDING_AMOUNT"  from turn_result
;
-----------------------------------------
--  Changed function f_get_agency_org  --
-----------------------------------------
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
------------------------------------------
--  Changed view v_his_org_fund_report  --
------------------------------------------
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
          (charge - withdraw - center_pay - lot_center_pay - lot_rtv - lot_center_rtv) pay_up,
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
-----------------------------
--  New view v_mis_agency  --
-----------------------------
create or replace view v_mis_agency as
select agency_code, ab.org_code agency_area_code,
       ab.org_name agency_area_name, aa.agency_type, aa.available_credit
  from tmp_agency aa, inf_orgs ab
 where aa.org_code = ab.org_code;

-----------------------------------
--  New view v_mis_area_farther  --
-----------------------------------
create or replace view v_mis_area_farther as
select org_code area_code,
       org_name area_name,
       org_type area_type,
       super_org father_area,
       (select org_name from inf_orgs where org_code = tab.super_org) father_area_name
  from inf_orgs tab;

---------------------------
--  New view v_mis_area  --
---------------------------
create or replace view v_mis_area as
select area_code,
       area_name,
       area_type,
       father_area,
       father_area_name
  from v_mis_area_farther;

-------------------------------------
--  New view v_mis_pay_sell_issue  --
-------------------------------------
create or replace view v_mis_pay_sell_issue as
select applyflow_pay,
       applyflow_sell,
       game_code,
       issue_number as pay_issue,
       (select issue_number from his_sellticket where applyflow_sell=tab.applyflow_sell) as sell_issue,
       terminal_code,
       teller_code,
       agency_code,
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
       pay_seq
  from his_payticket tab;

---------------------------------
--  New view v_mon_game_issue  --
---------------------------------
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

-----------------------------
--  New view v_multi_sell  --
-----------------------------
create or replace view v_multi_sell as
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

---------------------------------------
--  Changed view v_report_pay_level  --
---------------------------------------
create or replace view v_report_pay_level as
with
pay_detail as
   (select to_char(PAY_TIME, 'yyyy-mm-dd') sale_day,
           to_char(PAY_TIME, 'yyyy-mm') sale_month,
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
      from FLOW_PAY)
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
select "SALE_DATE","SALE_MONTH","ORG_CODE","PLAN_CODE","LEVEL_1","LEVEL_2","LEVEL_3","LEVEL_4","LEVEL_5","LEVEL_6","LEVEL_7","LEVEL_8","LEVEL_OTHER","TOTAL" from HIS_PAY_LEVEL;
-----------------------------------
--  New view v_report_sale_pay1  --
-----------------------------------
create or replace view v_report_sale_pay1 as
with sale as
 (select to_char(sale_time, 'yyyy-mm-dd') sale_day,
         to_char(sale_time, 'yyyy-mm') sale_month,
         area_code,
         org_code,
         f_get_old_plan_name(plan_code, batch_no) plan_code,
         sum(sale_amount) sale_amount,
         sum(comm_amount) as sale_comm
    from flow_sale
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
    from flow_pay),
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
)
select sale_day, sale_month, area_code, org_code, plan_code,
       nvl(sum(sale_amount), 0) sale_amount,
       nvl(sum(sale_comm), 0) sale_comm,
       nvl(sum(cancel_amount), 0) cancel_amount,
       nvl(sum(cancel_comm), 0) cancel_comm,
       nvl(sum(pay_amount), 0) pay_amount,
       nvl(sum(pay_comm), 0) pay_comm,
       (nvl(sum(sale_amount), 0) - nvl(sum(sale_comm), 0) - nvl(sum(pay_amount), 0) - nvl(sum(pay_comm), 0) - nvl(sum(cancel_amount), 0) + nvl(sum(cancel_comm), 0)) incoming
  from pre_detail
 group by sale_day, sale_month, area_code, org_code, plan_code;

-------------------------------------------
--  New view v_today_cancel_by_area_org  --
-------------------------------------------
create or replace view v_today_cancel_by_area_org as
select to_char(cancel_time, 'yyyy-mm-dd') sale_day,
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
            to_char(cancel_time, 'yyyy-mm');

----------------------------------------------
--  New view v_today_plan_sale_by_area_org  --
----------------------------------------------
create or replace view v_today_plan_sale_by_area_org as
select to_char(sale_time, 'yyyy-mm-dd') sale_day,
         to_char(sale_time, 'yyyy-mm') sale_month,
         area_code,
         org_code,
         plan_code,
         batch_no,
         sum(sale_amount) sale_amount,
         sum(comm_amount) as sale_comm
    from flow_sale
   where sale_time >= trunc(sysdate)
     and sale_time <  trunc(sysdate) + 1
   group by area_code,
            org_code,
            plan_code,
            batch_no,
            to_char(sale_time, 'yyyy-mm-dd'),
            to_char(sale_time, 'yyyy-mm');

-----------------------------------------
--  New view v_today_sale_by_area_org  --
-----------------------------------------
create or replace view v_today_sale_by_area_org as
select to_char(sale_time, 'yyyy-mm-dd') sale_day,
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
            to_char(sale_time, 'yyyy-mm');

--------------------------------------
--  Changed type type_lottery_info  --
--------------------------------------
create or replace type type_lottery_info as object
/*********************************************************************/
------------ 适用于: 批量入库的彩票对象   ----------------
------------ add by 陈震 2015/9/17        ----------------
/*********************************************************************/
(
  -----------    实体字段定义    -----------------
  plan_code    varchar2(10),         -- 方案编码
  batch_no     varchar2(10),         -- 批次
  valid_number number(1),            -- 有效位数（1-箱号、2-盒号、3-本号）
  trunk_no     varchar2(10),         -- 箱号
  box_no       varchar2(20),         -- 开始盒号（箱号+盒子顺序号）
  box_no_e     varchar2(20),         -- 结束盒号（箱号+盒子顺序号）
  package_no   varchar2(10),         -- 开始本号（当有效位数是箱和盒时，此为首本号）
  package_no_e varchar2(10),         -- 结束本号（当有效位数是箱和盒时，此为末本号）
  reward_group number(2)             -- 奖组
)
/
--------------------------------------
--  Changed type type_lottery_list  --
--------------------------------------
create or replace type type_lottery_list as table of type_lottery_info
/*********************************************************************/
------------ 数组定义: 用于记录扫描入库的彩票对象   -------------
/*********************************************************************/
/
---------------------------------
--  Changed package error_msg  --
---------------------------------
create or replace package error_msg is
   /****************************************************/
   /****** Error Messages - Multi-lingual Version ******/
   /****************************************************/

   /*----- Common ------*/
   err_comm_password_not_match constant  varchar2(4000) := '{"en":"Password error.","zh":"用户密码错误"}';

   /*----- Procedure ------*/
   -- err_p_cxxxxx_1
   -- err_p_cxxxxx_2
   -- err_f_cxxxxx_1
   -- err_f_cxxxxx_2

   err_p_import_batch_file_1  constant varchar2(4000) := '{"en":"The batch information already exists.","zh":"批次数据信息已经存在"}';
   err_p_import_batch_file_2  constant varchar2(4000) := '{"en":"The plan and batch information in the data file are inconsistent with the user input.","zh":"数据文件中所记录的方案与批次信息，与界面输入的方案和批次不符"}';

   err_p_batch_inbound_1 constant varchar2(4000) := '{"en":"The trunk has already been received.","zh":"此箱已经入库"}';
   err_p_batch_inbound_2 constant varchar2(4000) := '{"en":"The warehouse does not exist.","zh":"无此仓库"}';
   err_p_batch_inbound_3 constant varchar2(4000) := '{"en":"The batch does not exist.","zh":"无此批次"}';
   err_p_batch_inbound_4 constant varchar2(4000) := '{"en":"Wrong operation parameter, must be 1, 2 or 3.","zh":"操作类型参数错误，应该为1，2，3"}';
   err_p_batch_inbound_5 constant varchar2(4000) := '{"en":"Batch receipt code error occurred when continuing or completing lottery receipt. Receipt code does not exist.","zh":"在进行继续入库和完结入库操作时，输入的批次入库单错误，未发现此批次入库单"}';
   err_p_batch_inbound_6 constant varchar2(4000) := '{"en":"Batch receipt code error occurred when continuing lottery receipt, or this batch receipt has already completed.","zh":"在进行继续入库时，输入的批次入库单错误，或者此批次入库单已经完结"}';
   err_p_batch_inbound_7 constant varchar2(4000) := '{"en":"The batch receipt has already completed, please do not repeat the process.","zh":"此批次的方案已经入库完毕，请不要重复进行"}';

   err_f_get_warehouse_code_1 constant varchar2(4000) := '{"en":"The input account type is not \"jg\", \"zd\" or \"mm\".","zh":"输入的账户类型不是“jg”,“zd”,“mm”"}';

   err_f_get_lottery_info_1 constant varchar2(4000) := '{"en":"The input \"Trunk\" code is out of the valid range.","zh":"输入的“箱”号超出合法的范围"}';
   err_f_get_lottery_info_2 constant varchar2(4000) := '{"en":"The input \"Box\" code is out of the valid range.","zh":"输入的“盒”号超出合法的范围"}';
   err_f_get_lottery_info_3 constant varchar2(4000) := '{"en":"The input \"Pack\" code is out of the valid range.","zh":"输入的“本”号超出合法的范围"}';

   err_p_tb_outbound_3  constant varchar2(4000) := '{"en":"Transfer code error occurred when continuing lottery issue, or the corresponding delivery order has completed.","zh":"在进行继续出库时，输入的调拨单号错误，或者此调拨单对应的出库单，出库已经完结"}';
   err_p_tb_outbound_4  constant varchar2(4000) := '{"en":"The transfer order status is incorrect when the transfer issue has completed.","zh":"调拨单出库完结时，调拨单状态不合法"}';
   err_p_tb_outbound_14 constant varchar2(4000) := '{"en":"The actual issued quantity for this transfer order is inconsistent with the applied quantity.","zh":"调拨单实际出库数量与申请数量不符"}';
   err_p_tb_outbound_5  constant varchar2(4000) := '{"en":"The transfer order status is incorrect when the transfer issue is being processed.","zh":"进行调拨单出库时，调拨单状态不合法"}';
   err_p_tb_outbound_6  constant varchar2(4000) := '{"en":"Cannot obtain the delivery code.","zh":"不能获得出库单编号"}';
   err_p_tb_outbound_7  constant varchar2(4000) := '{"en":"The actual number of tickets being delivered should not be larger than the number as specified in the transfer order.","zh":"实际出库票数不应该大于调拨单计划出库票数"}';

   err_p_tb_inbound_2  constant varchar2(4000) := '{"en":"The input parent institution of the warehouse is inconsistent with that as specified in the transfer order.","zh":"输入的仓库所属机构，与调拨单中标明的接收机构不符"}';
   err_p_tb_inbound_3  constant varchar2(4000) := '{"en":"Transfer code error occurred when continuing lottery receipt, or the corresponding receipt order has completed.","zh":"在进行继续入库时，输入的调拨单号错误，或者此调拨单对应的入库单，入库已经完结"}';
   err_p_tb_inbound_4  constant varchar2(4000) := '{"en":"The transfer order status is not as expected when the transfer receipt has completed.","zh":"调拨单入库完结时，调拨单状态与预期值不符"}';
   err_p_tb_inbound_5  constant varchar2(4000) := '{"en":"The transfer order status is incorrect when the transfer receipt is being processed.","zh":"进行调拨单入库时，调拨单状态不合法"}';
   err_p_tb_inbound_6  constant varchar2(4000) := '{"en":"Cannot find the corresponding receipt code with respect to the input transfer code when adding lottery tickets. It may be caused by having entered a wrong transfer code.","zh":"继续添加彩票时，未能按照输入的调拨单编号，查询到相应的入库单编号。可能传入了错误的调拨单编号"}';
   err_p_tb_inbound_25 constant varchar2(4000) := '{"en":"The transfer order does not exist.","zh":"未查询到此调拨单"}';
   err_p_tb_inbound_7  constant varchar2(4000) := '{"en":"The actual number of tickets being transferred should be smaller than or equal to the applied quantity.","zh":"实际调拨票数，应该小于或者等于申请调拨票数"}';

   err_p_batch_end_1 constant varchar2(4000) := '{"en":"The person does not exist.","zh":"无此人"}';
   err_p_batch_end_2 constant varchar2(4000) := '{"en":"The plan is disabled.","zh":"此方案已经不可用"}';
   err_p_batch_end_3 constant varchar2(4000) := '{"en":"Cannot terminate this batch because \"in transit\" or \"in outlet\" lottery ticket may exist.","zh":"存在“在途”和“在站点”的彩票，不能执行批次终结"}';
   err_p_batch_end_4 constant varchar2(4000) := '{"en":"Cannot terminate this batch because \"in transit\" or \"in outlet\" lottery ticket may exist.","zh":"存在“在途”和“在站点”的彩票，不能执行批次终结"}';
   err_p_batch_end_5 constant varchar2(4000) := '{"en":"Cannot terminate this batch because \"in transit\" or \"in outlet\" lottery ticket may exist.","zh":"存在“在途”和“在站点”的彩票，不能执行批次终结"}';


   err_p_gi_outbound_4  constant varchar2(4000) := '{"en":"The delivery order status is incorrect when the delivery issue has completed.","zh":"出货单出库完结时，出货单状态不合法"}';
   err_p_gi_outbound_5  constant varchar2(4000) := '{"en":"The delivery order status is incorrect when the delivery issue is being processed.","zh":"进行出货单出库时，出货单状态不合法"}';
   err_p_gi_outbound_6  constant varchar2(4000) := '{"en":"Cannot obtain the issue code.","zh":"不能获得出库单编号"}';
   err_p_gi_outbound_1  constant varchar2(4000) := '{"en":"The person does not exist.","zh":"无此人"}';
   err_p_gi_outbound_3  constant varchar2(4000) := '{"en":"Transfer code error occurred when continuing lottery issue, or the corresponding delivery order has completed.","zh":"在进行继续出库时，输入的调拨单号错误，或者此调拨单对应的出库单，出库已经完结"}';
   err_p_gi_outbound_10 constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when transferring a \"Trunk\".","zh":"调拨“箱”时，“本”数据出现异常"}';
   err_p_gi_outbound_12 constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Box\". Or the trunk status may be incorrect.","zh":"调拨“盒”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
   err_p_gi_outbound_13 constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when transferring a \"Box\".","zh":"调拨“盒”时，对应的“本”数据异常"}';
   err_p_gi_outbound_16 constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Pack\". Or the trunk status may be incorrect.","zh":"调拨“本”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
   err_p_gi_outbound_7  constant varchar2(4000) := '{"en":"Repeated items found for issue.","zh":"出现重复的出库物品"}';
   err_p_gi_outbound_8  constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Trunk\". Or the trunk status may be incorrect.","zh":"调拨“箱”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
   err_p_gi_outbound_9  constant varchar2(4000) := '{"en":"Exception occurred in \"Box\" data when transferring a \"Trunk\".","zh":"调拨“箱”时，“盒”数据出现异常"}';
   err_p_gi_outbound_2  constant varchar2(4000) := '{"en":"The warehouse does not exist.","zh":"无此仓库"}';
   err_p_gi_outbound_11 constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the box is already inside the issue details.","zh":"盒对应的箱已经出现在出库明细中，逻辑校验失败"}';
   err_p_gi_outbound_14 constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the issue details.","zh":"本对应的箱已经出现在出库明细中，逻辑校验失败"}';
   err_p_gi_outbound_15 constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the issue details.","zh":"本对应的箱已经出现在出库明细中，逻辑校验失败"}';
   err_p_gi_outbound_17 constant varchar2(4000) := '{"en":"Exceeds the \"maximum allowable credit\" as held by this manager.","zh":"超过此管理员允许持有的“最高赊票金额”"}';

   err_p_rr_inbound_1  constant varchar2(4000) := '{"en":"The person does not exist.","zh":"无此人"}';
   err_p_rr_inbound_2  constant varchar2(4000) := '{"en":"The warehouse does not exist.","zh":"无此仓库"}';
   err_p_rr_inbound_3  constant varchar2(4000) := '{"en":"Wrong operation parameter, must be 1, 2 or 3.","zh":"操作类型参数错误，应该为1，2，3"}';
   err_p_rr_inbound_4  constant varchar2(4000) := '{"en":"The return delivery status is incorrect when the return delivery receipt has completed. Expected status: [Receiving].","zh":"还货单入库完结时，还货单状态不合法，期望的换货单状态应该为[收货中]"}';
   err_p_rr_inbound_24 constant varchar2(4000) := '{"en":"Cannot find the return delivery due to incorrect return code.","zh":"还货单编号不合法，未查询到此换货单"}';
   err_p_rr_inbound_5  constant varchar2(4000) := '{"en":"The return delivery status is incorrect when the return delivery receipt has completed. Expected status: [Approved].","zh":"还货单入库完结时，还货单状态不合法，期望的换货单状态应该为[已审批]"}';
   err_p_rr_inbound_15 constant varchar2(4000) := '{"en":"The return delivery status is incorrect when the return delivery receipt is being processed. Expected status: [Receiving].","zh":"还货单继续入库时，还货单状态不合法，期望的换货单状态应该为[接收中]"}';
   err_p_rr_inbound_6  constant varchar2(4000) := '{"en":"Cannot obtain the receipt code.","zh":"不能获得入库单编号"}';
   err_p_rr_inbound_7  constant varchar2(4000) := '{"en":"Repeated items found for receipt.","zh":"出现重复的入库物品"}';
   err_p_rr_inbound_8  constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when transferring a \"Box\".","zh":"调拨“盒”时，“本”数据出现异常"}';
   err_p_rr_inbound_18 constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when transferring a \"Trunk\".","zh":"调拨“箱”时，“本”数据出现异常"}';
   err_p_rr_inbound_28 constant varchar2(4000) := '{"en":"Exception occurred in \"Box\" data when transferring a \"Trunk\".","zh":"调拨“箱”时，“盒”数据出现异常"}';
   err_p_rr_inbound_38 constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Trunk\". Or the trunk status may be incorrect.","zh":"调拨“箱”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
   err_p_rr_inbound_9  constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the box is already inside the receipt details.","zh":"盒对应的箱已经出现在入库明细中，逻辑校验失败"}';
   err_p_rr_inbound_10 constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Box\". Or the trunk status may be incorrect.","zh":"调拨“盒”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
   err_p_rr_inbound_11 constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the receipt details.","zh":"本对应的箱已经出现在入库明细中，逻辑校验失败"}';
   err_p_rr_inbound_12 constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the receipt details.","zh":"本对应的箱已经出现在入库明细中，逻辑校验失败"}';
   err_p_rr_inbound_13 constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when transferring a \"Pack\". Or the trunk status may be incorrect.","zh":"调拨“本”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
   err_p_rr_inbound_14 constant varchar2(4000) := '{"en":"There is no information on this plan and batch in the warehouse manager inventory.","zh":"仓库管理员的库存中，没有此方案和批次的库存信息"}';

   err_p_ar_inbound_1  constant varchar2(4000) := '{"en":"The person does not exist.","zh":"无此人"}';
   err_p_ar_inbound_3  constant varchar2(4000) := '{"en":"Repeated items found for receipt.","zh":"出现重复的入库物品"}';
   err_p_ar_inbound_4  constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when processing a \"Trunk\". Or the trunk status may be incorrect.","zh":"处理“箱”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
   err_p_ar_inbound_5  constant varchar2(4000) := '{"en":"Exception occurred in \"Box\" data when processing a \"Trunk\".","zh":"处理“箱”时，“盒”数据出现异常"}';
   err_p_ar_inbound_6  constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when processing a \"Trunk\".","zh":"处理“箱”时，“本”数据出现异常"}';
   err_p_ar_inbound_7  constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the box is already inside the receipt details.","zh":"盒对应的箱已经出现在入库明细中，逻辑校验失败"}';
   err_p_ar_inbound_10 constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when processing a \"Box\". Or the trunk status may be incorrect.","zh":"处理“盒”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
   err_p_ar_inbound_38 constant varchar2(4000) := '{"en":"Exception occurred in \"Pack\" data when processing a \"Box\".","zh":"处理“盒”时，“本”数据出现异常"}';
   err_p_ar_inbound_11 constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the receipt details.","zh":"本对应的箱已经出现在入库明细中，逻辑校验失败"}';
   err_p_ar_inbound_12 constant varchar2(4000) := '{"en":"Validation failure: the corresponding trunk of the pack is already inside the receipt details.","zh":"本对应的箱已经出现在入库明细中，逻辑校验失败"}';
   err_p_ar_inbound_13 constant varchar2(4000) := '{"en":"Cannot find relevant information in inventory when processing a \"Pack\". Or the trunk status may be incorrect.","zh":"处理“本”时，未在库存中找到相关信息。也可能是箱的状态不正确"}';
   err_p_ar_inbound_14 constant varchar2(4000) := '{"en":"There is no information on this plan and batch in the warehouse manager inventory.","zh":"仓库管理员的库存中，没有此方案和批次的库存信息"}';
   err_p_ar_inbound_15 constant varchar2(4000) := '{"en":"The outlet has not set up the sales commission rate of this lottery plan.","zh":"该销售站未设置此方案对应的销售佣金比例"}';
   err_p_ar_inbound_16 constant varchar2(4000) := '{"en":"The outlet does not have an account or the account status is incorrect.","zh":"销售站无账户或相应账户状态不正确"}';
   err_p_ar_inbound_17 constant varchar2(4000) := '{"en":"Insufficient outlet balance.","zh":"销售站余额不足"}';


   err_p_institutions_create_1 constant varchar2(4000) := '{"en":"Institution code cannot be empty.","zh":"部门编码不能为空！"}';
   err_p_institutions_create_2 constant varchar2(4000) := '{"en":"Institution name cannot be empty.","zh":"部门名称不能为空！"}';
   err_p_institutions_create_3 constant varchar2(4000) := '{"en":"Insittution director does not exist.","zh":"部门负责人不存在！"}';
   err_p_institutions_create_4 constant varchar2(4000) := '{"en":"Contact phone cannot be empty.","zh":"部门联系电话不能为空！"}';
   err_p_institutions_create_5 constant varchar2(4000) := '{"en":"This institution code already exists in the system.","zh":"部门编码在系统中已经存在！"}';
   err_p_institutions_create_6 constant varchar2(4000) := '{"en":"Area has been repeatedly governed by other insittution.","zh":"选择区域已经被其他部门管辖！"}';

   err_p_institutions_modify_1 constant varchar2(4000) := '{"en":"Original institution code cannot be empty.","zh":"部门原编码不能为空！"}';
   err_p_institutions_modify_2 constant varchar2(4000) := '{"en":"Other relevant staff in this institution cannot change the institution code.","zh":"部门关联其他人员不能修改编码！"}';

   err_p_outlet_create_1 constant varchar2(4000) := '{"en":"Institution code cannot be empty.","zh":"部门编码不能为空！"}';
   err_p_outlet_create_2 constant varchar2(4000) := '{"en":"The institution is disabled.","zh":"部门无效！"}';
   err_p_outlet_create_3 constant varchar2(4000) := '{"en":"Area code cannot be empty.","zh":"区域编码不能为空！"}';
   err_p_outlet_create_4 constant varchar2(4000) := '{"en":"The area is disabled.","zh":"区域无效！"}';

   err_p_outlet_modify_1 constant varchar2(4000) := '{"en":"The outlet code already exists.","zh":"站点编码已存在！"}';
   err_p_outlet_modify_2 constant varchar2(4000) := '{"en":"The outlet code is invalid.","zh":"站点编码不符合规范！"}';
   err_p_outlet_modify_3 constant varchar2(4000) := '{"en":"Cannot modify outlet code when there is a transaction.","zh":"站点有缴款业务不能变更编码！"}';
   err_p_outlet_modify_4 constant varchar2(4000) := '{"en":"Cannot modify outlet code when there is an order.","zh":"站点有订单业务不能变更编码！"}';

   err_p_outlet_plan_auth_1 constant varchar2(4000) := '{"en":"The delegated plan cannot be empty.","zh":"授权方案不能为空！"}';
   err_p_outlet_plan_auth_2 constant varchar2(4000) := '{"en":"The commission rate of the delegated plan cannot exceed the commission rate of the parent institution.","zh":"授权方案代销费率不能超出所属机构代销费率！"}';

   err_p_org_plan_auth_1 constant varchar2(4000) := '{"en":"The delegated plan cannot be empty.","zh":"授权方案不能为空！"}';
   err_p_org_plan_auth_2 constant varchar2(4000) := '{"en":"The commission rate of the delegated plan cannot exceed 1000.","zh":"授权方案代销费率不能超出1000！"}';

   err_p_warehouse_create_1 constant varchar2(4000) := '{"en":"Warehouse code cannot be empty.","zh":"编码不能为空！"}';
   err_p_warehouse_create_2 constant varchar2(4000) := '{"en":"Warehouse code cannot repeat.","zh":"编码不能重复！"}';
   err_p_warehouse_create_3 constant varchar2(4000) := '{"en":"Warehouse name cannot be empty.","zh":"名称不能为空！"}';
   err_p_warehouse_create_4 constant varchar2(4000) := '{"en":"Warehouse address cannot be empty.","zh":"地址不能为空！"}';
   err_p_warehouse_create_5 constant varchar2(4000) := '{"en":"Warehouse director does not exist.","zh":"负责人不存在！"}';
   err_p_warehouse_create_6 constant varchar2(4000) := '{"en":" has already had administering warehouse.","zh":"-已经有管辖仓库！"}';

   err_p_warehouse_modify_1 constant varchar2(4000) := '{"en":"Warehouse code does not exist.","zh":"编码不存在！"}';

   err_p_admin_create_1 constant varchar2(4000) := '{"en":"Real name cannot be empty.","zh":"真实姓名不能为空！"}';
   err_p_admin_create_2 constant varchar2(4000) := '{"en":"Login name cannot be empty.","zh":"登录名不能为空！"}';
   err_p_admin_create_3 constant varchar2(4000) := '{"en":"Login name already exists.","zh":"登录名已存在！"}';

   err_p_outlet_topup_1 constant varchar2(4000) := '{"en":"Outlet code cannot be empty.","zh":"站点编码不能为空！"}';
   err_p_outlet_topup_2 constant varchar2(4000) := '{"en":"User does not exist or is disabled.","zh":"用户不存在或者无效！"}';
   err_p_outlet_topup_3 constant varchar2(4000) := '{"en":"Password cannot be empty.","zh":"密码不能为空！"}';
   err_p_outlet_topup_4 constant varchar2(4000) := '{"en":"Password is invalid.","zh":"密码无效！"}';

   err_p_institutions_topup_1 constant varchar2(4000) := '{"en":"Institution code cannot be empty.","zh":"机构编码不能为空！"}';
   err_p_institutions_topup_2 constant varchar2(4000) := '{"en":"The current user is disabled.","zh":"当前用户无效！"}';
   err_p_institutions_topup_3 constant varchar2(4000) := '{"en":"The current institution is disabled.","zh":"当前机构无效！"}';

   err_p_outlet_withdraw_app_1 constant varchar2(4000) := '{"en":"Insufficient balance for cash withdraw.","zh":"提现金额不足！"}';
   err_p_outlet_withdraw_con_1 constant varchar2(4000) := '{"en":"Application form cannot be empty.","zh":"申请单不能为空！"}';
   err_p_outlet_withdraw_con_2 constant varchar2(4000) := '{"en":"Application form does not exist or is not approved.","zh":"申请单不存在或状态非审批通过！"}';
   err_p_outlet_withdraw_con_3 constant varchar2(4000) := '{"en":"The outlet does not exist or the password is incorrect.","zh":"站点不存在或密码无效！"}';

   err_p_warehouse_delete_1 constant varchar2(4000) := '{"en":"Cannot delete a warehouse with item inventory.","zh":"仓库中有库存物品，不可进行删除！"}';

   err_p_warehouse_check_step1_1 constant varchar2(4000) := '{"en":"The inventory check name cannot be empty.","zh":"盘点名称不能为空！"}';
   err_p_warehouse_check_step1_2 constant varchar2(4000) := '{"en":"The warehouse for check cannot be empty.","zh":"库房不能为空！"}';
   err_p_warehouse_check_step1_3 constant varchar2(4000) := '{"en":"The check operator is disabled.","zh":"盘点人无效！"}';
   err_p_warehouse_check_step1_4 constant varchar2(4000) := '{"en":"The warehouse is disabled or is in checking.","zh":"仓库无效或者正在盘点中！"}';
   err_p_warehouse_check_step1_5 constant varchar2(4000) := '{"en":"There are no lottery tickets or items for check in this warehouse.","zh":"仓库无彩票物品，没有必要盘点！"}';

   err_p_warehouse_check_step2_1 constant varchar2(4000) := '{"en":"The inventory check code cannot be empty.","zh":"盘点单不能为空！"}';
   err_p_warehouse_check_step2_2 constant varchar2(4000) := '{"en":"The inventory check does not exist or has completed.","zh":"盘点单不存在或已完结！"}';
   err_p_warehouse_check_step2_3 constant varchar2(4000) := '{"en":"The scanned information cannot be empty.","zh":"扫描信息不能为空！"}';

   err_p_mm_fund_repay_1 constant varchar2(4000) := '{"en":"Market manager cannot be empty.","zh":"市场管理员不能为空！"}';
   err_p_mm_fund_repay_2 constant varchar2(4000) := '{"en":"Market manager does not exist or is deleted.","zh":"市场管理员已经删除或不存在！"}';
   err_p_mm_fund_repay_3 constant varchar2(4000) := '{"en":"Current operator cannot be empty.","zh":"当前操作人不能为空！"}';
   err_p_mm_fund_repay_4 constant varchar2(4000) := '{"en":"Current operator does not exist or is deleted.","zh":"当前操作人已经删除或不存在！"}';
   err_p_mm_fund_repay_5 constant varchar2(4000) := '{"en":"The repayment amount is invalid.","zh":"还款金额无效！"}';

   err_common_1 constant varchar2(4000) := '{"en":"Database error.","zh":"数据库操作异常"}';
   err_common_2 constant varchar2(4000) := '{"en":"Invalid status.","zh":"无效的状态值"}';
   err_common_3 constant varchar2(4000) := '{"en":"Object does not exist.","zh":"对象不存在"}';
   err_common_4 constant varchar2(4000) := '{"en":"Parameter name error.","zh":"参数名称错误"}';
   err_common_5 constant varchar2(4000) := '{"en":"Invalid parameter.","zh":"无效的参数"}';
   err_common_6 constant varchar2(4000) := '{"en":"Invalid code.","zh":"编码不符合规范"}';
   err_common_7 constant varchar2(4000) := '{"en":"Code overflow.","zh":"编码溢出"}';
   err_common_8 constant varchar2(4000) := '{"en":"The data is being processed by others.","zh":"数据正在被别人处理中"}';
   err_common_9 constant varchar2(4000) := '{"en":"The deletion requrement cannot be satisfied.","zh":"不符合删除条件"}';

   err_p_fund_change_1 constant varchar2(4000) := '{"en":"Insufficient account balance.","zh":"账户余额不足"}';
   err_p_fund_change_2 constant varchar2(4000) := '{"en":"Incorrect fund type.","zh":"资金类型不合法"}';
   err_p_fund_change_3 constant varchar2(4000) := '{"en":"The outlet account does not exist, or the account status is incorrect.","zh":"未发现销售站的账户，或者账户状态不正确"}';

   err_p_lottery_reward_3 constant varchar2(4000) := '{"en":"This lottery ticket has not been on sale yet.","zh":"彩票未被销售"}';
   err_p_lottery_reward_4 constant varchar2(4000) := '{"en":"This lottery ticket has already been paid.","zh":"彩票已兑奖"}';
   err_p_lottery_reward_5 constant varchar2(4000) := '{"en":"Incorrect system parameter, please contact system administrator for recalibration.","zh":"系统参数值不正确，请联系管理员，重新设置"}';
   err_p_lottery_reward_6 constant varchar2(4000) := '{"en":"The outlet has not set up the payout commission rate of this lottery plan.","zh":"该销售站未设置此方案对应的兑奖佣金比例"}';
   err_p_lottery_reward_7 constant varchar2(4000) := '{"en":"The outlet has not set up the payout commission rate of this lottery plan.","zh":"该销售站未设置此方案对应的兑奖佣金比例"}';

   err_f_check_import_ticket constant varchar2(4000) := '{"en":"Wrong input parameter, must be 1 or 2.","zh":"输入参数错误，应该为1或者2"}';

   err_common_100 constant varchar2(4000) := '{"en":"The person does not exist.","zh":"无此人"}';
   err_common_101 constant varchar2(4000) := '{"en":"The warehouse does not exist.","zh":"无此仓库"}';
   err_common_102 constant varchar2(4000) := '{"en":"There is no batch in this plan.","zh":"无此方案批次"}';
   err_common_103 constant varchar2(4000) := '{"en":"Self-reference exists in the input lottery object.","zh":"输入的彩票对象中，存在自包含的现象"}';
   err_common_104 constant varchar2(4000) := '{"en":"Error occurred when updating the lottery status.","zh":"更新“即开票”状态时，出现错误"}';
   err_common_105 constant varchar2(4000) := '{"en":"Wrong operation parameter, must be 1, 2 or 3.","zh":"操作类型参数错误，应该为1，2，3"}';
   err_common_106 constant varchar2(4000) := '{"en":"Wrong operation parameter, must be 1, 2 or 3.","zh":"操作类型参数错误，应该为1，2，3"}';
   err_common_107 constant varchar2(4000) := '{"en":"The batches of this plan are disabled.","zh":"此方案的批次处于非可用状态"}';
   err_common_108 constant varchar2(4000) := '{"en":"The plan or batch data is empty.","zh":"方案或批次数据为空"}';
   err_common_109 constant varchar2(4000) := '{"en":"No lottery object found in the input parameters.","zh":"输入参数中，没有发现彩票对象"}';

   err_f_check_ticket_include_1 constant varchar2(4000) := '{"en":"This lottery trunk has already been processed.","zh":"此箱彩票已经被处理"}';
   err_f_check_ticket_include_2 constant varchar2(4000) := '{"en":"This lottery box has already been processed.","zh":"此盒彩票已经被处理"}';
   err_f_check_ticket_include_3 constant varchar2(4000) := '{"en":"This lottery pack has already been processed.","zh":"此本彩票已经被处理"}';

   err_p_item_delete_1 constant varchar2(4000) := '{"en":"Item code cannot be empty.","zh":"物品编码不能为空"}';
   err_p_item_delete_2 constant varchar2(4000) := '{"en":"The item does not exist.","zh":"不存在此物品"}';
   err_p_item_delete_3 constant varchar2(4000) := '{"en":"This item currently exists in inventory.","zh":"该物品当前有库存"}';

   err_p_withdraw_approve_1 constant varchar2(4000) := '{"en":"Withdraw code cannot be empty.","zh":"提现编码不能为空"}';
   err_p_withdraw_approve_2 constant varchar2(4000) := '{"en":"The withdraw code does not exist or the withdraw record is disabled.","zh":"提现编码不存在或单据状态无效！"}';
   err_p_withdraw_approve_3 constant varchar2(4000) := '{"en":"Permission denied for cash withdraw approval.","zh":"审批结果超出定义范围！"}';
   err_p_withdraw_approve_4 constant varchar2(4000) := '{"en":"Insufficient balance.","zh":"余额不足！"}';
   err_p_withdraw_approve_5 constant varchar2(4000) := '{"en":"outlet cash withdraw failure.","zh":"销售站资金处理失败！"}';

   err_p_item_outbound_1 constant varchar2(4000) := '{"en":"This item currently does not exist in inventory.","zh":"该物品当前无库存"}';
   err_p_item_outbound_2 constant varchar2(4000) := '{"en":"This item is not enough in inventory.","zh":"该物品在库存不足"}';

   err_p_item_damage_1 constant varchar2(4000) := '{"en":"Item code cannot be empty.","zh":"物品编码不能为空"}';
   err_p_item_damage_2 constant varchar2(4000) := '{"en":"Warehouse code cannot be empty.","zh":"仓库编码不能为空"}';
   err_p_item_damage_3 constant varchar2(4000) := '{"en":"Damage quantity must be positive.","zh":"损毁物品数量必须为正数"}';
   err_p_item_damage_4 constant varchar2(4000) := '{"en":"The operator does not exist.","zh":"损毁登记人不存在"}';
   err_p_item_damage_5 constant varchar2(4000) := '{"en":"The item does not exist or is deleted.","zh":"该物品不存在或已删除"}';
   err_p_item_damage_6 constant varchar2(4000) := '{"en":"The warehouse does not exist or is deleted.","zh":"该仓库不存在或已删除"}';
   err_p_item_damage_7 constant varchar2(4000) := '{"en":"The item does not exist in this warehouse.","zh":"该仓库中不存在此物品"}';
   err_p_item_damage_8 constant varchar2(4000) := '{"en":"The item quantity in this warehouse is less than the input damage quantity.","zh":"该仓库中此物品的数量小于登记损毁的数量"}';

   err_p_ar_outbound_10 constant varchar2(4000) := '{"en":"Cannot refund this ticket because paid tickets may exist.","zh":"有彩票已经兑奖，不能退票"}';
   err_p_ar_outbound_20 constant varchar2(4000) := '{"en":"The corresponding trunk data is missing from the lottery receipt.","zh":"对应的箱数据，没有在入库单中找到"}';
   err_p_ar_outbound_30 constant varchar2(4000) := '{"en":"The corresponding box data is missing from the lottery receipt.","zh":"对应的盒数据，没有在入库单中找到"}';
   err_p_ar_outbound_40 constant varchar2(4000) := '{"en":"The corresponding pack data is missing from the lottery receipt.","zh":"对应的本数据，没有在入库单中找到"}';
   err_p_ar_outbound_50 constant varchar2(4000) := '{"en":"The corresponding trunk data has been found in the receipt, but its status or its outlet information is incorrect.","zh":"对应的箱数据已经在入库单中找到，但是状态或者所属站点信息不正确"}';
   err_p_ar_outbound_60 constant varchar2(4000) := '{"en":"Cannot find the sales record of the refunding ticket.","zh":"未查询到待退票的售票记录"}';
   err_p_ar_outbound_70 constant varchar2(4000) := '{"en":"Exceeds the \"maximum allowable credit\" as held by this manager.","zh":"超过此管理员允许持有的“最高赊票金额”"}';

   err_p_ticket_perferm_1   constant varchar2(4000) := '{"en":"This warehouse is stopped or is in checking. This operation is denied.","zh":"此仓库状态处于盘点或停用状态，不能进行出入库操作"}';
   err_p_ticket_perferm_3   constant varchar2(4000) := '{"en":"The plan of this batch does not exist in the system.","zh":"系统中不存在此批次的彩票方案"}';
   err_p_ticket_perferm_5   constant varchar2(4000) := '{"en":"The plan of this batch has already been disabled.","zh":"此批次的彩票方案已经停用"}';
   err_p_ticket_perferm_10  constant varchar2(4000) := '{"en":"This lottery trunk does not exist.","zh":"此箱彩票不存在"}';
   err_p_ticket_perferm_110 constant varchar2(4000) := '{"en":"This lottery box does not exist.","zh":"此盒彩票不存在"}';
   err_p_ticket_perferm_120 constant varchar2(4000) := '{"en":"The status of this lottery \"Box\" is not as expected, current status: ","zh":"此“盒”彩票的状态与预期不符，当前状态为"}';
   err_p_ticket_perferm_130 constant varchar2(4000) := '{"en":"The system status of this lottery \"Box\" is OPEN, therefore trunk-wise processing is not allowed.","zh":"此“盒”彩票在系统中处于开箱状态，因此不能进行整箱处理"}';
   err_p_ticket_perferm_140 constant varchar2(4000) := '{"en":"Error may exist in the inventory information of this lottery \"Box\", please double-check before proceed.","zh":"此“盒”彩票库存信息可能存在错误，请查询以后再进行操作"}';
   err_p_ticket_perferm_150 constant varchar2(4000) := '{"en":"Exception occurred during lottery processing, please contact the system maintenance for support.","zh":"处理彩票时，出现数据异常，请联系系统人员"}';
   err_p_ticket_perferm_160 constant varchar2(4000) := '{"en":"Exception occurred in the \"Pack\" data when processing a \"Box\". Possible errors include: 1-Some packs in this box have been removed, 2-The status of some packs in this box is not as expected.","zh":"处理“盒”时，“本”数据出现异常。可能的错误为：1-此盒对应的某些本已经被转移，2-此盒对应的某些本的状态与预期状态不符"}';
   err_p_ticket_perferm_20  constant varchar2(4000) := '{"en":"The status of this lottery \"Trunk\" is not as expected, current status: ","zh":"此“箱”彩票的状态与预期不符，当前状态为"}';
   err_p_ticket_perferm_210 constant varchar2(4000) := '{"en":"This lottery pack does not exist.","zh":"此本彩票不存在"}';
   err_p_ticket_perferm_220 constant varchar2(4000) := '{"en":"The status of this lottery \"Pack\" is not as expected, current status: ","zh":"此“本”彩票的状态与预期不符，当前状态为"}';
   err_p_ticket_perferm_230 constant varchar2(4000) := '{"en":"Error may exist in the inventory information of this lottery \"Pack\", please double-check before proceed.","zh":"此“本”彩票库存信息可能存在错误，请查询以后再进行操作"}';
   err_p_ticket_perferm_240 constant varchar2(4000) := '{"en":"Exception occurred during lottery processing, please contact the system maintenance for support.","zh":"处理彩票时，出现数据异常，请联系系统人员"}';
   err_p_ticket_perferm_30  constant varchar2(4000) := '{"en":"The system status of this lottery \"Trunk\" is OPEN, therefore trunk-wise processing is not allowed.","zh":"此“箱”彩票在系统中处于开箱状态，因此不能进行整箱处理"}';
   err_p_ticket_perferm_40  constant varchar2(4000) := '{"en":"Error may exist in the inventory information of this lottery \"Trunk\", please double-check before proceed.","zh":"此“箱”彩票库存信息可能存在错误，请查询以后再进行操作"}';
   err_p_ticket_perferm_50  constant varchar2(4000) := '{"en":"Exception occurred during lottery processing, please contact the system maintenance for support.","zh":"处理彩票时，出现数据异常，请联系系统人员"}';
   err_p_ticket_perferm_60  constant varchar2(4000) := '{"en":"Exception occurred in the \"Box\" data when processing a \"Trunk\". Possible errors include: 1-Some boxes in this trunk have been opened for use, 2-Some boxes in this trunk have been removed, 3-The status of some boxes in this trunk is not as expected.","zh":"处理“箱”时，“盒”数据出现异常。可能的错误为：1-此箱对应的某些盒已经被拆开使用，2-此箱对应的某些盒已经被转移，3-此箱对应的某些盒的状态与预期状态不符"}';
   err_p_ticket_perferm_70  constant varchar2(4000) := '{"en":"Exception occurred in the \"Box\" data when processing a \"Trunk\". Possible errors include: 1-Some packs in this trunk have been removed, 2-The status of some packs in this trunk is not as expected.","zh":"处理“箱”时，“盒”数据出现异常。可能的错误为：1-此箱对应的某些本已经被转移，2-此箱对应的某些本的状态与预期状态不符"}';

   err_f_get_sys_param_1    constant varchar2(4000) := '{"en":"The system parameter is not set. parameter: ","zh":"系统参数未被设置，参数编号为："}';

   err_p_teller_create_1    constant varchar2(4000) := '{"en":"Invalid Agency Code!","zh":"无效的销售站"}';
   err_p_teller_create_2    constant varchar2(4000) := '{"en":"The teller code is already used.","zh":"销售员编号重复"}';
   err_p_teller_create_3    constant varchar2(4000) := '{"en":"The teller code is out of the range.","zh":"输入的编码超出范围！"}';

   err_f_gen_teller_term_code_1  constant varchar2(4000) := '{"en":"The teller code is out of the range.","zh":"编码超出范围！"}';

   err_p_teller_status_change_1  constant varchar2(4000) := '{"en":"Invalid teller status!","zh":"无效的状态值"}';
   err_p_teller_status_change_2  constant varchar2(4000) := '{"en":"Invalid teller Code!","zh":"销售员不存在"}';
   err_p_set_sale_1              constant varchar2(4000) := '{"en":"Invalid TYPE(should BE 1) from the input parameter. Type is :","zh":"报文输入有错，非售票报文。类型为："}';
   err_p_set_cancel_1            constant varchar2(4000) := '{"en":"Invalid TYPE(should BE 2, 4) from the input parameter. Type is :","zh":"报文输入有错，非退票报文。类型为："}';
   err_p_set_cancel_2            constant varchar2(4000) := '{"en":"Can not find this ticket. ticket flow No. is ","zh":"未找到对应的售票信息。输入的流水号为："}';
   err_p_set_pay_1               constant varchar2(4000) := '{"en":"Invalid TYPE(should BE 3, 5) from the input parameter. Type is :","zh":"报文输入有错，非兑奖报文。类型为："}';

   err_p_om_agency_auth_1        constant varchar2(4000) := '{"en":"The sales commission rate of the outlet that belong in some agents can not be large than the sales commission rate of its agent","zh":"代理商所属销售站销售代销费比例不能大于代理商的销售代销费比例"}';
   err_p_om_agency_auth_2        constant varchar2(4000) := '{"en":"The payout commission rate of the outlet that belong in some agents can not be large than the payout commission rate of its agent","zh":"代理商所属销售站销售代销费比例不能大于代理商的销售代销费比例"}';

  MSG0001 CONSTANT VARCHAR2(4000) := '{"en":"Rolling in from abandoned award","zh":"弃奖滚入"}';
  MSG0002 CONSTANT VARCHAR2(4000) := '{"en":"Unknown pool adjustment type","zh":"未知的奖池调整类型"}';
  MSG0003 CONSTANT VARCHAR2(4000) := '{"en":"Receiving object or title can not be empty","zh":"接收对象或标题不能为空"}';
  MSG0004 CONSTANT VARCHAR2(4000) := '{"en":"Abnormal database operation","zh":"数据库操作异常"}';
  MSG0005 CONSTANT VARCHAR2(4000) := '{"en":"The games being authorized can not be empty","zh":"授权游戏不能为空"}';
  MSG0006 CONSTANT VARCHAR2(4000) := '{"en":"Invalid status","zh":"无效的状态值"}';
  MSG0007 CONSTANT VARCHAR2(4000) := '{"en":"Already at the current state in the database","zh":"数据库中已经是当前状态"}';
  MSG0008 CONSTANT VARCHAR2(4000) := '{"en":"This agency has been removed","zh":"站点已经清退"}';
  MSG0009 CONSTANT VARCHAR2(4000) := '{"en":"Repeating code","zh":"编号重复"}';
  MSG0010 CONSTANT VARCHAR2(4000) := '{"en":"Using 99 in area code is not allowed","zh":"区域编码中不允许使用[99]"}';
  MSG0011 CONSTANT VARCHAR2(4000) := '{"en":"The code of the national center must be 0","zh":"全国区域编码必须为[0]"}';
  MSG0012 CONSTANT VARCHAR2(4000) := '{"en":"The code of this type of region must be from [00-99]","zh":"此类型区域编码必须为[00-99]"}';
  MSG0013 CONSTANT VARCHAR2(4000) := '{"en":"The code of this type of region must be from [0100-9999]","zh":"此类型区域编码必须为[0100-9999]"}';
  MSG0014 CONSTANT VARCHAR2(4000) := '{"en":"Format error: the parent code is inconsistent with the parent region","zh":"编码格式错误:父区域编码部分和所属父区域不一致"}';
  MSG0015 CONSTANT VARCHAR2(4000) := '{"en":"Number of agencies exceeds the limit of the parent region","zh":"销售站数量限制大于父区域数量限制"}';
  MSG0016 CONSTANT VARCHAR2(4000) := '{"en":"Number of tellers exceeds the limit of the parent region","zh":"销售员数量限制大于父区域数量限制"}';
  MSG0017 CONSTANT VARCHAR2(4000) := '{"en":"Number of terminals exceeds the limit of the parent region","zh":"终端机数量限制大于父区域数量限制"}';
  MSG0018 CONSTANT VARCHAR2(4000) := '{"en":"Central agency","zh":"直属站"}';
  MSG0019 CONSTANT VARCHAR2(4000) := '{"en":"The national center cannot be deleted","zh":"中心是系统内置不能删除"}';
  MSG0020 CONSTANT VARCHAR2(4000) := '{"en":"The deleting region has affiliated sub-level regions","zh":"该区域有关联子区域不能删除"}';
  MSG0021 CONSTANT VARCHAR2(4000) := '{"en":"The deleting region has affiliated agencies","zh":"该区域有关联站点不能删除"}';
  MSG0022 CONSTANT VARCHAR2(4000) := '{"en":"The deleting region has affiliated tellers","zh":"该区域有关联用户不能删除"}';
  MSG0023 CONSTANT VARCHAR2(4000) := '{"en":"Invalid agency","zh":"无效的销售站点"}';
  MSG0024 CONSTANT VARCHAR2(4000) := '{"en":"Invalid operator","zh":"无效的操作人"}';
  MSG0025 CONSTANT VARCHAR2(4000) := '{"en":"The adjustment amount cannot be empty","zh":"调整金额不能为空"}';
  MSG0026 CONSTANT VARCHAR2(4000) := '{"en":"The adjustment amount is zero, it is not necessary to calculate","zh":"调整金额为0没有必要计算"}';
  MSG0027 CONSTANT VARCHAR2(4000) := '{"en":"The issue cannot be empty","zh":"期次不能为空"}';
  MSG0028 CONSTANT VARCHAR2(4000) := '{"en":"Invalid game code","zh":"无效的游戏编码"}';
  MSG0029 CONSTANT VARCHAR2(4000) := '{"en":"The game is invalid","zh":"游戏无效"}';
  MSG0030 CONSTANT VARCHAR2(4000) := '{"en":"The basic parameters are empty","zh":"游戏基础信息配置信息为空"}';
  MSG0031 CONSTANT VARCHAR2(4000) := '{"en":"The policy parameters are empty","zh":"游戏政策参数配置信息为空"}';
  MSG0032 CONSTANT VARCHAR2(4000) := '{"en":"The prize parameters are empty","zh":"游戏奖级参数配置信息为空"}';
  MSG0033 CONSTANT VARCHAR2(4000) := '{"en":"The game subtype parameters are empty","zh":"游戏玩法参数配置信息为空"}';
  MSG0034 CONSTANT VARCHAR2(4000) := '{"en":"The winning parameters are empty","zh":"游戏中奖参数配置信息为空"}';
  MSG0035 CONSTANT VARCHAR2(4000) := '{"en":"Cannot arrange additional issues on the selected date","zh":"所选日期无法补充排期"}';
  MSG0036 CONSTANT VARCHAR2(4000) := '{"en":"There is a time conflict in the issue arrangement","zh":"排期存在时间交叉"}';
  MSG0037 CONSTANT VARCHAR2(4000) := '{"en":"Incorrect password","zh":"密码不正确"}';
  MSG0038 CONSTANT VARCHAR2(4000) := '{"en":"Failed to update the teller''s password","zh":"更新销售员密码失败"}';
  MSG0039 CONSTANT VARCHAR2(4000) := '{"en":"Failed to update the teller''s sign-out information","zh":"更新销售员签出信息失败"}';
  MSG0040 CONSTANT VARCHAR2(4000) := '{"en":"Failed to update the teller''s sign-in information","zh":"更新销售员签入信息失败"}';
  MSG0041 CONSTANT VARCHAR2(4000) := '{"en":"The teller code can not be repeated","zh":"销售员编号不能重复"}';
  MSG0042 CONSTANT VARCHAR2(4000) := '{"en":"Cannot add tellers in a central agency","zh":"中心站不可以配置销售员"}';
  MSG0043 CONSTANT VARCHAR2(4000) := '{"en":"The number of tellers is out of range","zh":"销售员数量超出范围"}';
  MSG0044 CONSTANT VARCHAR2(4000) := '{"en":"The number of tellers has exceeded the limit of the current region","zh":"销售员数量已经超过当前区域限制值"}';
  MSG0045 CONSTANT VARCHAR2(4000) := '{"en":"The number of tellers has exceeded the limit of the parent region","zh":"销售员数量已经超过父区域限制值"}';
  MSG0046 CONSTANT VARCHAR2(4000) := '{"en":"Invalid teller","zh":"无效的销售员"}';
  MSG0047 CONSTANT VARCHAR2(4000) := '{"en":"The teller has been deleted","zh":"销售员已删除"}';
  MSG0048 CONSTANT VARCHAR2(4000) := '{"en":"Format of the MAC address is invalid","zh":"MAC地址格式不正确"}';
  MSG0049 CONSTANT VARCHAR2(4000) := '{"en":"The terminal code does not meet the specification","zh":"终端编码不符合规范"}';
  MSG0050 CONSTANT VARCHAR2(4000) := '{"en":"The MAC can not be repeated","zh":"MAC地址不能重复"}';
  MSG0051 CONSTANT VARCHAR2(4000) := '{"en":"The number of terminals has exceeded the limit of the current region","zh":"终端数量已经超过当前区域限制值"}';
  MSG0052 CONSTANT VARCHAR2(4000) := '{"en":"The number of terminals has exceeded the limit of the parent region","zh":"终端数量已经超过父区域限制值"}';
  MSG0053 CONSTANT VARCHAR2(4000) := '{"en":"Invalid terminal","zh":"无效的终端机"}';
  MSG0054 CONSTANT VARCHAR2(4000) := '{"en":"The terminal has been deleted","zh":"终端已退机"}';
  MSG0055 CONSTANT VARCHAR2(4000) := '{"en":"Invalid parameter","zh":"无效的参数对象"}';
  MSG0056 CONSTANT VARCHAR2(4000) := '{"en":"The name of the upgrade plan can not be repeated","zh":"升级计划名称不能重复"}';
  MSG0057 CONSTANT VARCHAR2(4000) := '{"en":"Invalid upgrade object","zh":"无效的升级对象"}';
  MSG0058 CONSTANT VARCHAR2(4000) := '{"en":"Terminal","zh":"终端机"}';
  MSG0059 CONSTANT VARCHAR2(4000) := '{"en":"does not exist","zh":"不存在"}';
  MSG0060 CONSTANT VARCHAR2(4000) := '{"en":"The machine type does not match the upgrading version","zh":"机型和升级版本要求不匹配"}';
  MSG0061 CONSTANT VARCHAR2(4000) := '{"en":"The parameter name is wrong","zh":"参数名称错误"}';
  MSG0062 CONSTANT VARCHAR2(4000) := '{"en":"Failed to update the error code and description of the drawing process","zh":"更新期次开奖过程错误编码和描述失败"}';
  MSG0063 CONSTANT VARCHAR2(4000) := '{"en":"The pool is not found","zh":"没有找到游戏的奖池"}';
  MSG0064 CONSTANT VARCHAR2(4000) := '{"en":"The amount rolling in from the pool cannot be empty","zh":"滚入的奖池金额不能为空"}';
  MSG0065 CONSTANT VARCHAR2(4000) := '{"en":"Chump changes cannot be empty","zh":"期次奖金抹零不能为空"}';
  MSG0066 CONSTANT VARCHAR2(4000) := '{"en":"Failed to get the policy parameters","zh":"无法获取政策参数"}';
  MSG0067 CONSTANT VARCHAR2(4000) := '{"en":"The sales amount cannot be empty","zh":"期次销售金额不能为空值"}';
  MSG0068 CONSTANT VARCHAR2(4000) := '{"en":"Logical error: the amount of sales is 0, but the input pool amount is greater than 0","zh":"逻辑错误：期次销售金额为0，但是输入的奖池金额大于0"}';
  MSG0069 CONSTANT VARCHAR2(4000) := '{"en":"The pool amount is insufficient, supplemented from the adjustment fund","zh":"期次奖池不足，调节基金补充"}';
  MSG0070 CONSTANT VARCHAR2(4000) := '{"en":"Rolling in from drawing","zh":"期次开奖滚入"}';
  MSG0071 CONSTANT VARCHAR2(4000) := '{"en":"Failed to process the risk-control related statistics","zh":"期次风险控制相关统计数值失败"}';
  MSG0072 CONSTANT VARCHAR2(4000) := '{"en":"The issue status is invalid","zh":"期次状态无效"}';
  MSG0073 CONSTANT VARCHAR2(4000) := '{"en":"The issue does not exist or has completed","zh":"期次不存在或期次已完结"}';
  MSG0074 CONSTANT VARCHAR2(4000) := '{"en":"The issue can not be repeated","zh":"期次不能重复"}';
  MSG0075 CONSTANT VARCHAR2(4000) := '{"en":"Failed to get the payout period from the policy parameters","zh":"无法获取政策参数中的兑奖期"}';
  MSG0076 CONSTANT VARCHAR2(4000) := '{"en":"Failed to update the ticket number statistics","zh":"更新期次票数统计失败"}';
  MSG0077 CONSTANT VARCHAR2(4000) := '{"en":"Failed to update the winnings statistics","zh":"更新期次中奖统计信息失败"}';
  MSG0078 CONSTANT VARCHAR2(4000) := '{"en":"The parameter code can not be empty","zh":"参数编号不能为空"}';
  MSG0079 CONSTANT VARCHAR2(4000) := '{"en":"Invalid parameter","zh":"无效参数"}';
  MSG0080 CONSTANT VARCHAR2(4000) := '{"en":"The agency code does not meet the specification","zh":"站点编码不符合规范"}';
  MSG0081 CONSTANT VARCHAR2(4000) := '{"en":"Agency code overflow","zh":"编码溢出"}';
  MSG0082 CONSTANT VARCHAR2(4000) := '{"en":"Error occurred when obtaining the system parameters","zh":"获取系统参数时出现错误"}';
  MSG0083 CONSTANT VARCHAR2(4000) := '{"en":"Bank account cannot be repeated","zh":"银行账号不能重复"}';
  MSG0084 CONSTANT VARCHAR2(4000) := '{"en":"The issuance fee is out of range","zh":"游戏发行费用超出范围"}';
  MSG0085 CONSTANT VARCHAR2(4000) := '{"en":"The data are being processed by others","zh":"数据正在被别人处理中"}';
  MSG0086 CONSTANT VARCHAR2(4000) := '{"en":"Deleting condition not satisfied","zh":"不符合删除条件"}';

end;
/
------------------------------
--  Changed type tabletype  --
------------------------------
create or replace type tabletype as table of varchar2(32676)
/*********************************************************************/
------------ 数组定义: table函数返回值   -------------
/*********************************************************************/
/
------------------------------------------
--  Changed package ebatch_item_status  --
------------------------------------------
CREATE OR REPLACE PACKAGE ebatch_item_status IS
   /****** 适用于以下表：                                                                              ******/
   /******    2.1.4.5 批次信息导入之包装（GAME_BATCH_IMPORT_DETAIL）   状态（1-启用，2-暂停，3-退市）  status   ******/
   /******    2.1.10.1 物品（item_items）                              状态（1-启用，2-暂停，3-退市） status   ******/

   /****** 状态（1-启用，2-停用） ******/
   working                   /* 1-启用 */                  CONSTANT NUMBER := 1;
   pause                     /* 2-暂停 */                  CONSTANT NUMBER := 2;
   quited                    /* 3-退市 */                  CONSTANT NUMBER := 3;
END;
/
----------------------------------------
--  Changed function f_get_sys_param  --
----------------------------------------
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
----------------------------------------
--  New function f_get_agency_credit  --
----------------------------------------
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

------------------------------
--  New package ecomm_type  --
------------------------------
CREATE OR REPLACE PACKAGE ecomm_type IS
   /****** 发行费类型（1、销售；2、兑奖；） ******/
   sale     /* 1=销售         */          CONSTANT NUMBER := 1;
   pay      /* 2=兑奖         */          CONSTANT NUMBER := 2;
END;
/

-------------------------------------------
--  New function f_get_agency_game_comm  --
-------------------------------------------
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

--------------------------------------
--  New function f_get_agency_info  --
--------------------------------------
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
    select nvl(address, '') || ',' || nvl(telephone, '')
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

---------------------------------------
--  New function f_get_area_display  --
---------------------------------------
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

--------------------------------------
--  New function f_get_eventid_seq  --
--------------------------------------
CREATE OR REPLACE FUNCTION f_get_eventid_seq RETURN number IS
BEGIN
    return seq_sys_event_id.nextval;
END;
/

---------------------------------------------
--  New function f_get_game_current_issue  --
---------------------------------------------
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

----------------------------------------
--  New function f_get_game_flow_seq  --
----------------------------------------
CREATE OR REPLACE FUNCTION f_get_game_flow_seq RETURN number IS
BEGIN
    return seq_game_flow.nextval;
END;
/

--------------------------------------------
--  New function f_get_game_his_code_seq  --
--------------------------------------------
CREATE OR REPLACE FUNCTION f_get_game_his_code_seq RETURN number IS
BEGIN
    return seq_game_his_code.nextval;
END;
/

-----------------------------------------
--  New function f_get_his_cancel_seq  --
-----------------------------------------
CREATE OR REPLACE FUNCTION f_get_his_cancel_seq RETURN number IS
BEGIN
    return seq_his_cancel.nextval;
END;
/

--------------------------------------
--  New function f_get_his_pay_seq  --
--------------------------------------
CREATE OR REPLACE FUNCTION f_get_his_pay_seq RETURN number IS
BEGIN
    return seq_his_pay.nextval;
END;
/

---------------------------------------
--  New function f_get_his_sell_seq  --
---------------------------------------
CREATE OR REPLACE FUNCTION f_get_his_sell_seq RETURN number IS
BEGIN
    return seq_his_sell.nextval;
END;
/

-----------------------------------------
--  New function f_get_his_settle_seq  --
-----------------------------------------
CREATE OR REPLACE FUNCTION f_get_his_settle_seq RETURN number IS
BEGIN
    return seq_his_settle.nextval;
END;
/

--------------------------------------
--  New function f_get_his_win_seq  --
--------------------------------------
CREATE OR REPLACE FUNCTION f_get_his_win_seq RETURN number IS
BEGIN
    return seq_his_win.nextval;
END;
/

----------------------------------------
--  New function f_get_org_game_comm  --
----------------------------------------
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

--------------------------------------
--  New package egame_issue_status  --
--------------------------------------
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

--------------------------------------
--  New function f_get_right_issue  --
--------------------------------------
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

---------------------------------------------
--  New function f_get_sale_guicancel_seq  --
---------------------------------------------
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

------------------------------------------
--  New function f_get_sale_guipay_seq  --
------------------------------------------
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

--------------------------------------------
--  New function f_get_sys_clog_info_seq  --
--------------------------------------------
CREATE OR REPLACE FUNCTION f_get_sys_clog_info_seq RETURN number IS
BEGIN
    return seq_sys_clog_info.nextval;
END;
/

--------------------------------------------
--  New function f_get_sys_hostlogid_seq  --
--------------------------------------------
CREATE OR REPLACE FUNCTION f_get_sys_hostlogid_seq RETURN number IS
BEGIN
    return seq_upg_schedule_id.nextval;
END;
/

-------------------------------------------
--  New function f_get_sys_noticeid_seq  --
-------------------------------------------
CREATE OR REPLACE FUNCTION f_get_sys_noticeid_seq RETURN number IS
BEGIN
    return seq_sys_host_logid.nextval;
END;
/

--------------------------------------
--  New function f_get_teller_role  --
--------------------------------------
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

----------------------------------------
--  New function f_get_teller_static  --
----------------------------------------
create or replace function f_get_teller_static(
  p_teller in number -- 销售员编码

) return number
  result_cache
  relies_on(inf_tellers)

is
  /*-----------    变量定义     -----------------*/
  v_ret_code number(2); -- 返回值

begin

    select status
      into v_ret_code
      from inf_tellers
     where teller_code = p_teller;

  return v_ret_code;

end;
/

--------------------------------------
--  New function f_get_ticket_memo  --
--------------------------------------
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

-------------------------------------------
--  New function f_get_upg_schedule_seq  --
-------------------------------------------
CREATE OR REPLACE FUNCTION f_get_upg_schedule_seq RETURN number IS
BEGIN
    return seq_sys_noticeid.nextval;
END;
/

-------------------------------
--  New package ehost_error  --
-------------------------------
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

-------------------------------
--  New package eorg_status  --
-------------------------------
CREATE OR REPLACE PACKAGE eorg_status IS
   /****** 部门状态（1-可用，2-删除） ******/
   available                  /* 1-可用 */                CONSTANT NUMBER := 1;
   deleted                    /* 2-删除 */                CONSTANT NUMBER := 2;
END;
/

------------------------------------
--  New package eterminal_status  --
------------------------------------
CREATE OR REPLACE PACKAGE eterminal_status IS
   /****** 终端状态(1=可用/2=禁用/3=退机) ******/
   enabled                  /* 1=可用 */                CONSTANT NUMBER := 1;
   disabled                 /* 2=禁用 */                CONSTANT NUMBER := 2;
   cancelled                /* 3=退机 */                CONSTANT NUMBER := 3;
END;
/

-------------------------------
--  New function f_set_auth  --
-------------------------------
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

------------------------------------------
--  New function f_set_check_game_auth  --
------------------------------------------
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
    when 1 then                                      -- 销售
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
    when 1 then                                      -- 销售
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

----------------------------------
--  New package eteller_status  --
----------------------------------
CREATE OR REPLACE PACKAGE eteller_status IS
   /****** 销售员状态（1=可用；2=已禁用；3=已删除） ******/
   enabled                 /* 1-可用 */                    CONSTANT NUMBER := 1;
   disabled                /* 2-已禁用 */                  CONSTANT NUMBER := 2;
   deleted                 /* 3-已删除 */                  CONSTANT NUMBER := 3;
END;
/

----------------------------------------
--  New function f_set_check_general  --
----------------------------------------
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

-----------------------------------
--  New package eclaiming_scope  --
-----------------------------------
CREATE OR REPLACE PACKAGE eclaiming_scope IS
   /****** 兑奖范围（1=中心通兑、2=机构通兑、4=本站自兑） ******/
   center          /* 1=中心通兑 */      CONSTANT NUMBER := 1;
   org             /* 2=机构通兑 */      CONSTANT NUMBER := 2;
   agency          /* 4=本站自兑 */      CONSTANT NUMBER := 4;
END;
/

------------------------------------------
--  New function f_set_check_pay_level  --
------------------------------------------
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

--------------------------------
--  New function f_set_login  --
--------------------------------
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

  if not(v_teller_info.agency_code = v_term_info.agency_code and v_term_info.agency_code = p_agency) then
    return 'null, null, null, null, ' || ehost_error.host_t_token_expired_err;
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

----------------------------------
--  Changed package eflow_type  --
----------------------------------
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
----------------------------------------------
--  Changed procedure p_agency_fund_change  --
----------------------------------------------
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
-----------------------------------------------------
--  Changed procedure p_agency_fund_change_manual  --
-----------------------------------------------------
create or replace procedure p_agency_fund_change_manual
/****************************************************************/
   --站点手工调账
/*************************************************************/
(
   --------------输入----------------
   p_agency                            in char,          -- 销售站
   p_type                              in char,          -- 资金类型
   p_amount                            in char,          -- 调整金额
   p_frozen                            in number,        -- 冻结金额
   p_ref_no                            in varchar2,      -- 参考业务编号

   --------------输入----------------
   c_error_code                        out number,        -- 账户余额
   c_error_msg                         out varchar2         -- 冻结账户余额

 ) is

   v_acc_no                char(12);                                       -- 账户编码
   v_balance               number(28);                                     -- 账户余额
   v_frozen_balance        number(28);                                     -- 账户冻结余额
   v_credit_limit          number(28);                                     -- 信用额度
   v_amount                number(28);                                     -- 账户调整金额
   v_frozen                number(28);                                     -- 冻结账户调整金额

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

   insert into flow_agency
      (agency_fund_flow,      ref_no,   flow_type, agency_code, acc_no,   change_amount, be_account_balance,   af_account_balance, be_frozen_balance,           af_frozen_balance, frozen_amount)
   values
      (f_get_flow_agency_seq, p_ref_no, p_type,    p_agency,    v_acc_no, p_amount,      v_balance - v_amount, v_balance,          v_frozen_balance - v_frozen, v_frozen_balance,  p_frozen);

   COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_error_code := 3;
    c_error_msg := error_msg.ERR_COMMON_1 || SQLERRM;

end;
/
---------------------------------------------
--  Changed type type_lottery_detail_info  --
---------------------------------------------
create or replace type type_lottery_detail_info is object
/*********************************************************************/
------------ 适用于: 出入库明细处理的存储过程   ----------------
------------ add by 陈震 2015/9/25        ----------------
/*********************************************************************/
(
  -----------    实体字段定义    -----------------
  plan_code       varchar2(10),        -- 方案编码
  batch_no        varchar2(10),        -- 批次
  valid_number    number(1),           -- 有效位数（1-箱号、2-盒号、3-本号）
  trunk_no        varchar2(10),        -- 箱号
  box_no          varchar2(20),        -- 盒号（箱号+盒子顺序号）
  package_no      varchar2(10),        -- 本号
  tickets         number(18),          -- 票数
  amount          number(28)           -- 金额
)
/
---------------------------------------------
--  Changed type type_lottery_detail_list  --
---------------------------------------------
create or replace type type_lottery_detail_list as table of type_lottery_detail_info
/*****************************************************************************/
------------ 数组定义: 用于记录即将被保存的彩票入库或者出库明细   -------------
/*****************************************************************************/
/
-------------------------------------------------
--  Changed type type_lottery_statistics_info  --
-------------------------------------------------
create or replace type type_lottery_statistics_info is object
/******************************************************************************/
------------ 适用于: 按照方案和批次统计出入库明细的票数和金额   ----------------
------------ add by 陈震 2015/9/25        ----------------
/******************************************************************************/
(
  -----------    实体字段定义    -----------------
  plan_code       varchar2(10),        -- 方案编码
  batch_no        varchar2(10),        -- 批次
  tickets         number(18),          -- 票数
  amount          number(28),          -- 金额
  trunks          number(10),          -- 箱数
  boxes           number(10),          -- 盒数
  packages        number(10)           -- 本数
)
/
-------------------------------------------------
--  Changed type type_lottery_statistics_list  --
-------------------------------------------------
create or replace type type_lottery_statistics_list as table of type_lottery_statistics_info
/***************************************************************************************/
------------ 数组定义: 用于按方案和批次记录出入库明细中所包含的票数和金额   -------------
/***************************************************************************************/
/
-------------------------------------
--  Changed package ereceipt_type  --
-------------------------------------
CREATE OR REPLACE PACKAGE ereceipt_type IS
   /****** 适用于以下表：                                                                    ******/
   /****** 2.1.5.10 入库单（wh_goods_receipt）                                               ******/
   /******     入库类型（1-批次入库、2-调拨单入库、3-退货入库、4-站点入库） receipt_type   ******/

   batch                     /* 1-批次入库   */                  CONSTANT NUMBER := 1;
   trans_bill                /* 2-调拨单入库 */                  CONSTANT NUMBER := 2;
   return_back               /* 3-退货入库   */                  CONSTANT NUMBER := 3;
   agency                    /* 4-站点入库   */                  CONSTANT NUMBER := 4;
END;
/
-----------------------------------
--  Changed package eissue_type  --
-----------------------------------
CREATE OR REPLACE PACKAGE eissue_type IS
   /******适用于以下表：                                                  ******/
   /******   2.1.5.8 出库单（wh_goods_issue）                             ******/
   /******       出库类型（1-调拨出库、2-出货单出库，3-损毁出库，4-站点退货） issue_type ******/

   trans_bill                     /* 1-调拨出库   */                  CONSTANT NUMBER := 1;
   delivery_order                 /* 2-出货单出库 */                  CONSTANT NUMBER := 2;
   broken                         /* 3-损毁出库   */                  CONSTANT NUMBER := 3;
   agency_return                  /* 4-站点退货   */                  CONSTANT NUMBER := 4;
END;
/
------------------------------------
--  Changed package ework_status  --
------------------------------------
CREATE OR REPLACE PACKAGE ework_status IS
   /****** 适用于以下表：                                                 ******/
   /****** 出库单（wh_goods_issue）   状态（1-未完成，2-已完成）  status  ******/
   /****** 物品入库（item_receipt）   状态（1-未完成，2-已完成） status  ******/
   /****** 入库单—WH_GOODS_RECEIPT(STATUS)                               ******/
   /****** 状态（1-未完成，2-已完成） ******/
   working                /* 1-未完成 */                  CONSTANT NUMBER := 1;
   done                   /* 2-已完成 */                  CONSTANT NUMBER := 2;
END;
/
-------------------------------------------------
--  Changed type type_lottery_import_err_info  --
-------------------------------------------------
create or replace type type_lottery_import_err_info as object
/*********************************************************************/
------------ 适用于: 批量入库的彩票对象错误信息   ----------------
------------ add by 陈震 2015/9/17        ----------------
/*********************************************************************/
(
  -----------    实体字段定义    -----------------
  plan_code    varchar2(10),         -- 方案编码
  batch_no     varchar2(10),         -- 批次
  err_code     number(10),           -- 不能入库的错误提示编号
  err_msg      varchar2(20000)       -- 不能入库的错误提示信息
)
/
-------------------------------------------------
--  Changed type type_lottery_import_err_list  --
-------------------------------------------------
create or replace type type_lottery_import_err_list as table of type_lottery_import_err_info
/*********************************************************************/
------------ 数组定义: 用于记录扫描入库的彩票对象   -------------
/*********************************************************************/
/
----------------------------------------
--  Changed type type_logistics_info  --
----------------------------------------
create or replace type type_logistics_info is object
/*********************************************************************/
------------ 适用于: 物流查询   ----------------
------------ add by 陈震 2015/9/22        ----------------
/*********************************************************************/
(
  -----------    实体字段定义    -----------------
  ttime          date,              -- 变化时间
  obj_type        number(2),         -- 出入库类型（入库类型=入库类型+10）
  obj_object_s    varchar2(4000),       -- 仓库
  obj_object_t    varchar2(4000)        -- 人员
)
/
----------------------------------------
--  Changed type type_logistics_list  --
----------------------------------------
create or replace type type_logistics_list as table of type_logistics_info
/*********************************************************************/
------------ 数组定义: 用于记录彩票的物流信息   -------------
/*********************************************************************/
/
-----------------------------------------------
--  Changed procedure p_institutions_create  --
-----------------------------------------------
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
-------------------------------------------
--  Changed procedure p_org_fund_change  --
-------------------------------------------
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
-------------------------------------
--  Changed package eaccount_type  --
-------------------------------------
CREATE OR REPLACE PACKAGE eaccount_type IS
   /****** 适用于以下表：(账户类型（1-机构，2-站点）  account_type)  ******/
   /******    2.1.9.1 销售站（机构）中心充值（fund_charge_center）   ******/
   /******    2.1.9.2 销售站（机构）现金充值（FUND_CHARGE_CASH）     ******/
   /******    2.1.9.3 销售站（机构）提现（FUND_WITHDRAW）            ******/
   /******    2.1.9.4 销售站（机构）调账（FUND_TUNING）              ******/

   org                      /* 1-机构 */                  CONSTANT NUMBER := 1;
   agency                   /* 2-站点 */                  CONSTANT NUMBER := 2;
END;
/
----------------------------------
--  Changed package ecp_result  --
----------------------------------
CREATE OR REPLACE PACKAGE ecp_result IS
   /****** 适用于以下表：                                                                        ******/
   /******    2.1.5.12 盘点单（wh_check_point）   盘点结果（1-一致，2-盘亏，3-盘盈） result    ******/
   /******    2.1.10.7 物品盘点（item_check）     盘点结果（1-一致，2-盘亏，3-盘盈）  result    ******/

   /****** 盘点结果（1-一致，2-盘亏，3-盘盈） ******/
   same                   /* 1-一致 */                  CONSTANT NUMBER := 1;
   less                   /* 2-盘亏 */                  CONSTANT NUMBER := 2;
   more                   /* 3-盘盈 */                  CONSTANT NUMBER := 3;
END;
/
-----------------------------------
--  Changed type type_item_info  --
-----------------------------------
create or replace type type_item_info is object
/******************************************************************************/
------------ 适用于: 物品出入库明细   ----------------
------------ add by 陈震 2015/10/13        ----------------
/******************************************************************************/
(
  -----------    实体字段定义    -----------------
  item_code char(8),                   -- 物品编码（IT123456）
  quantity  number(10)                 -- 数量
)
/
-----------------------------------
--  Changed type type_item_list  --
-----------------------------------
create or replace type type_item_list as table of type_item_info
/***************************************************************************************/
------------ 数组定义: 用于物品出入库明细   -------------
/***************************************************************************************/
/
---------------------------------------------
--  Changed type type_lottery_reward_info  --
---------------------------------------------
create or replace type type_lottery_reward_info as object
/*********************************************************************/
------------ 适用于: 批量入库的彩票对象错误信息   ----------------
------------ add by 陈震 2015/9/17        ----------------
/*********************************************************************/
(
  -----------    实体字段定义    -----------------
  plan_code       varchar2(10),        -- 方案编码
  batch_no        varchar2(10),        -- 批次
  package_no      varchar2(10),        -- 本号
  ticket_no       number(5),           -- 票号
  security_code   VARCHAR2(50)         -- 安全码
)
/
---------------------------------------------
--  Changed type type_lottery_reward_list  --
---------------------------------------------
create or replace type type_lottery_reward_list as table of type_lottery_reward_info
/*********************************************************************/
------------ 数组定义: 用于记录扫描入库的彩票对象   -------------
/*********************************************************************/
/
-----------------------------------------------
--  Changed type type_mm_check_lottery_info  --
-----------------------------------------------
create or replace type type_mm_check_lottery_info as object
/*********************************************************************/
------------ 适用于: 管理员库存盘点的彩票对象   ----------------
------------ add by 陈震 2015-12-08             ----------------
/*********************************************************************/
(
  -----------    实体字段定义    -----------------
  plan_code    varchar2(10),         -- 方案编码
  batch_no     varchar2(10),         -- 批次
  valid_number number(1),            -- 有效位数（1-箱号、2-盒号、3-本号）
  trunk_no     varchar2(10),         -- 箱号
  box_no       varchar2(20),         -- 盒号（结构用于验奖程序时，此字段用于显示中奖金额）
  package_no   varchar2(10),         -- 本号
  tickets      number(28),           -- 张数
  status       number(1)             -- 管理员彩票库存状态（1-不在库、2-未扫描）
)
/
-----------------------------------------------
--  Changed type type_mm_check_lottery_list  --
-----------------------------------------------
create or replace type type_mm_check_lottery_list as table of type_mm_check_lottery_info
/*********************************************************************/
------------ 数组定义: 管理员库存盘点的彩票对象   -------------
/*********************************************************************/
/
-------------------------------------------
--  New package eabandon_reward_collect  --
-------------------------------------------
CREATE OR REPLACE PACKAGE eabandon_reward_collect IS
   /****** 弃奖方向 ******/
   pool                /* 1=奖池 */                  CONSTANT NUMBER := 1;
   adj                 /* 2=调节基金 */              CONSTANT NUMBER := 2;
   fund                /* 3=公益金 */                CONSTANT NUMBER := 3;
END;
/

------------------------------------
--  New package eadj_change_type  --
------------------------------------
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

---------------------------------------
--  New package ecwfund_change_type  --
---------------------------------------
CREATE OR REPLACE PACKAGE ecwfund_change_type IS
   /****** 公益金变更类型（1、期次开奖滚入；2、弃奖滚入；） ******/
   in_from_issue_reward     /* 1=期次开奖滚入             */         CONSTANT NUMBER := 1;
   in_from_abandon          /* 2=弃奖滚入             */             CONSTANT NUMBER := 2;
END;
/

-------------------------------------
--  New package epool_change_type  --
-------------------------------------
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

---------------------------------------
--  New procedure p_mis_abandon_out  --
---------------------------------------
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

------------------------------------------
--  New procedure p_mis_dss_00_prepare  --
------------------------------------------
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

----------------------------------------------
--  New procedure p_mis_dss_10_gen_abandon  --
----------------------------------------------
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
       ( /* 凌晨弃奖游戏期次 */
        SELECT game_code, issue_number
          FROM iss_game_issue
         WHERE pay_end_day = to_number(to_char(v_date, 'yyyymmdd'))),
      all_abandon_flow AS
       ( /* 所有满足弃奖期次的票号 */
        SELECT applyflow_sell
          FROM his_sellticket
         WHERE (game_code, issue_number) IN
               (SELECT game_code, issue_number FROM abandon_issue)
        minus
        SELECT applyflow_sell
          FROM v_mis_pay_sell_issue
         WHERE (game_code, sell_issue) IN
               (SELECT game_code, issue_number FROM abandon_issue))
      SELECT applyflow_sell,
             v_date,
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
        JOIN(his_win_ticket)
       USING (applyflow_sell);

   COMMIT;

   -- 弃奖主表
   delete his_abandon_ticket
    where applyflow_sell IN (SELECT applyflow_sell FROM tmp_src_abandon);
   INSERT INTO his_abandon_ticket
      SELECT * FROM tmp_src_abandon;
   COMMIT;

   -- 弃奖明细表
   delete his_abandon_ticket_detail
    where applyflow_sell IN (SELECT applyflow_sell FROM tmp_src_abandon);
   INSERT INTO his_abandon_ticket_detail
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
      SELECT applyflow_sell,
             v_date,
             winnning_time,
             game_code,
             issue_number,
             prize_level,
             prize_count,
             is_hd_prize,
             winningamounttax,
             winningamount,
             taxamount
        FROM his_win_ticket_detail
       WHERE applyflow_sell IN (SELECT applyflow_sell FROM tmp_src_abandon);
   COMMIT;

   if p_is_maintance <> 1 then
      -- 弃奖资金进入调节基金
      -- 想法：
      -- 1、计算出弃奖资金
      -- 2、在调节基金中新增一条记录
      -- 3、修改当前的调节基金余额
      -- TAISHAN用户下新建SP，入口参数：
      -- 游戏、期次、弃奖金额
      for v_game_code in 6 .. 12 loop
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
   execute immediate 'truncate table tmp_src_abandon';
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
       where (game_code, issue_number) in
             (SELECT game_code, issue_number
                FROM iss_game_issue
               WHERE pay_end_day =
                     to_number(to_char(v_date - 1, 'yyyymmdd')));

   COMMIT;
END;
/

-----------------------------------------------
--  New procedure p_mis_dss_13_gen_his_dict  --
-----------------------------------------------
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

----------------------------------------------
--  New procedure p_mis_dss_15_gen_winning  --
----------------------------------------------
create or replace procedure p_mis_dss_15_gen_winning
(p_settle_id       in number)
is
  start_seq number(10);
  end_seq number(10);
begin
   select win_seq into end_seq from his_day_settle where settle_id=p_settle_id;
   select max(win_seq) into start_seq from his_day_settle where settle_id<p_settle_id;

   -- 因为通常进行mis操作时候，没有业务发生，因此不考虑 “一张票，部分中奖信息入库“的问题

   insert into tmp_src_win
     (applyflow_sell,                  winning_time,
      terminal_code,                   teller_code,                      agency_code,
      game_code,                       issue_number,                     is_big_prize,
      ticket_amount,
      win_amount_without_tax,          win_amount,           tax_amount,            win_bets,
      hd_win_amount_without_tax,       hd_win_amount,        hd_tax_amount,         hd_win_bets,
      ld_win_amount_without_tax,       ld_win_amount,        ld_tax_amount,         ld_win_bets)
   with win as
    (select applyflow_sell,winnning_time, game_code, issue_number,
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
      where win_seq > start_seq
        and win_seq <= end_seq
      group by applyflow_sell, winnning_time, game_code, issue_number),
   sell as
    (select applyflow_sell,
            terminal_code,
            teller_code,
            agency_code,
            ticket_amount
       from his_sellticket
      where applyflow_sell in (select applyflow_sell from win))
   select applyflow_sell,     win.winnning_time,
          terminal_code,      teller_code,           agency_code,
          game_code,          win.issue_number,
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

   commit;

   delete from his_win_ticket where applyflow_sell in (select applyflow_sell from tmp_src_win);
   insert into his_win_ticket select * from tmp_src_win;
   commit;

end;
/

----------------------------------------------
--  New procedure p_mis_dss_20_gen_tmp_src  --
----------------------------------------------
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
           (case when is_center=1 then PAYCOMMISSIONRATE_O else PAYCOMMISSIONRATE end) paycommissionrate,
           (case when is_center=1 then COMMISSIONAMOUNT_O else COMMISSIONAMOUNT end) commissionamount,
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

--------------------------------------------------
--  New procedure p_mis_dss_30_gen_multi_issue  --
--------------------------------------------------
CREATE OR REPLACE PROCEDURE p_mis_dss_30_gen_multi_issue IS
   v_issue_count NUMBER(10); -- 多期票的总期数
   v_loop        NUMBER(10); -- 循环中的期次变量
   v_issue       NUMBER(10); -- 计算获得的期次编号
   v_issue_seq   NUMBER(10); -- 期次序号

   v_sell his_sellticket%ROWTYPE; -- 销售期次的内容

BEGIN
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
/*   FOR table_cancel IN (SELECT *
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
*/
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

-------------------------------------------
--  New procedure p_mis_dss_40_gen_fact  --
-------------------------------------------
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
       issue_number,
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
      aband_issue AS
       (SELECT game_code, issue_number, real_reward_time
          FROM tmp_aband_issue),
      total_data AS
       (SELECT sell.game_code,
               sell.issue_number,
               trunc(winning_time) AS winning_date,
               sell.agency_code,
               area.agency_area_code AS area_code,
               sell.teller_code,
               sell.terminal_code,
               sell.bet_methold,
               sell.loyalty_code,
               is_big_prize AS is_big_one,
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
          FROM tmp_src_abandon, his_sellticket sell, v_mis_agency area
         WHERE tmp_src_abandon.applyflow_sell = sell.applyflow_sell
           AND sell.agency_code = area.agency_code
         GROUP BY sell.game_code,
                  sell.issue_number,
                  trunc(winning_time),
                  sell.agency_code,
                  area.agency_area_code,
                  sell.teller_code,
                  sell.terminal_code,
                  sell.bet_methold,
                  sell.loyalty_code,
                  is_big_prize)
      SELECT to_char(v_rpt_day, 'yyyy-mm-dd'),
             to_char(v_rpt_day, 'yyyy-ww'),
             to_char(v_rpt_day, 'yyyy-mm'),
             to_char(v_rpt_day, 'yyyy-q'),
             to_char(v_rpt_day, 'yyyy'),
             game_code,
             issue_number,
             real_reward_time,
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
        FROM total_data
        join tmp_aband_issue using (game_code, issue_number);
  dbms_output.put_line('p_mis_dss_40_gen_fact->sub_abandon:' || sql%rowcount);
  COMMIT;
END;
/

-----------------------------------------------
--  New procedure p_mis_dss_50_gen_rpt_3112  --
-----------------------------------------------
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
                issue_number,
                SUM(win_amount) AS win_amount,
                SUM(hd_win_amount) AS hd_win_amount,
                SUM(hd_win_bets) AS hd_win_bets,
                SUM(ld_win_amount) AS ld_win_amount,
                SUM(ld_win_bets) AS ld_win_bets
          FROM sub_abandon
         WHERE (game_code, issue_number) IN (SELECT game_code, issue_number
                                               FROM game_issue)
         GROUP BY game_code, issue_number),
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

-----------------------------------------------
--  New procedure p_mis_dss_50_gen_rpt_3113  --
-----------------------------------------------
CREATE OR REPLACE PROCEDURE p_mis_dss_50_gen_rpt_3113(p_settle_id IN NUMBER) IS
   v_rpt_day DATE;
BEGIN
   SELECT settle_date
     INTO v_rpt_day
     FROM his_day_settle
    WHERE settle_id = p_settle_id;

   INSERT INTO tmp_rst_3113
      (game_code, issue_number, area_code, sale_sum, hd_winning_sum, hd_winning_amount, ld_winning_sum, ld_winning_amount, winning_sum)
      WITH game_issue AS
       (
        /* 确定指定日期的中奖游戏期次 */
        SELECT game_code, issue_number
          FROM TMP_WIN_ISSUE),
      win AS
       ( /* 期次内的中奖统计 */
        SELECT game_code,
               issue_number,
               sale_area,
               SUM(win_amount) AS win_amount,
               SUM(hd_win_amount) AS hd_amount,
               SUM(hd_win_bets) AS hd_bets,
               SUM(ld_win_amount) AS ld_amount,
               SUM(ld_win_bets) AS ld_bets
          FROM sub_win
         WHERE (game_code, issue_number) IN (SELECT game_code, issue_number
                                               FROM game_issue)
         GROUP BY game_code, issue_number, sale_area),
      sell AS
       ( /* 期次内的期销售额统计（多期票被拆分） */
        SELECT game_code, issue_number, sale_area, SUM(pure_amount_single_issue) AS sale_amount
          FROM sub_sell
         WHERE (game_code, issue_number) IN (SELECT game_code, issue_number FROM game_issue)
         GROUP BY game_code, issue_number, sale_area)
      SELECT game_code,
             issue_number,
             sale_area,
             nvl(sell.sale_amount,0) sale_amount,
             nvl(win.hd_amount,0) hd_amount,
             nvl(win.hd_bets,0) hd_bets,
             nvl(win.ld_amount,0) ld_amount,
             nvl(win.ld_bets,0) ld_bets,
             nvl(win.win_amount,0) win_amount
        FROM sell
        LEFT JOIN win
       USING (game_code, issue_number, sale_area);
   COMMIT;

   -- 计算区域汇总数据
      INSERT INTO tmp_rst_3113
         (game_code,
          issue_number,
          area_code,
          sale_sum,
          hd_winning_sum,
          hd_winning_amount,
          ld_winning_sum,
          ld_winning_amount,
          winning_sum)
         SELECT game_code,
                issue_number,
                area.father_area       as area,
                SUM(sale_sum)          as sale_sum,
                SUM(hd_winning_sum)    as hd_winning_sum,
                SUM(hd_winning_amount) as hd_winning_amount,
                SUM(ld_winning_sum)    as ld_winning_sum,
                SUM(ld_winning_amount) as ld_winning_amount,
                SUM(winning_sum)       as winning_sum
           FROM tmp_rst_3113 tab, v_mis_area area
          WHERE tab.area_code = area.area_code
            AND area.area_type = 1
          GROUP BY game_code, issue_number, area.father_area;
   COMMIT;

   -- 更新区域名称
   UPDATE tmp_rst_3113
      SET area_name =
          (SELECT area_name
             FROM v_mis_area
            WHERE area_code = tmp_rst_3113.area_code),
          winning_rate = winning_sum / (case when sale_sum=0 then 1 else sale_sum end ) * 10000;
   COMMIT;
END;
/

-----------------------------------------------
--  New procedure p_mis_dss_50_gen_rpt_3116  --
-----------------------------------------------
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

-----------------------------------------------
--  New procedure p_mis_dss_50_gen_rpt_3117  --
-----------------------------------------------
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

-----------------------------------------------
--  New procedure p_mis_dss_50_gen_rpt_3121  --
-----------------------------------------------
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

-----------------------------------------------
--  New procedure p_mis_dss_50_gen_rpt_3122  --
-----------------------------------------------
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

-----------------------------------------------
--  New procedure p_mis_dss_50_gen_rpt_3124  --
-----------------------------------------------
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

-----------------------------------------------
--  New procedure p_mis_dss_50_gen_rpt_3125  --
-----------------------------------------------
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

------------------------------------------------
--  New procedure p_mis_dss_50_gen_rpt_aband  --
------------------------------------------------
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

----------------------------------------------
--  New procedure p_mis_dss_50_gen_rpt_ncp  --
----------------------------------------------
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

----------------------------------------------------
--  New procedure p_mis_dss_60_gen_rpt_merge_all  --
----------------------------------------------------
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

   -- 发送销售额短信
   begin
      v_msg := to_char(v_rpt_day,'yyyy-mm-dd') || 'Sales: '||to_char(v_sale/4000)||'$ Paid: '||to_char(v_pay/4000)||'$ Abandon:'||to_char(v_aband/4000)||'$';
      v_sql := 'begin p_set_send_day_msg('''||v_msg||'''); end;';
      dbms_scheduler.create_job(job_name   => 'SMS_DAY_JOB_SALE_'||to_char(systimestamp,'hh24missff3'),
                             job_type   => 'PLSQL_BLOCK',
                             job_class  => 'MIS_JOB_CLASS',
                             job_action => v_sql,
                             start_date => TO_TIMESTAMP_TZ(to_char(sysdate,'yyyy-mm-dd')||' 08:00:00 +7:00', 'YYYY-MM-DD HH:MI:SS TZH:TZM'),
                             enabled    => TRUE);

/*      -- 发送兑奖额短信
      v_msg := to_char(v_rpt_day,'yyyy-mm-dd') || '. the amount for paid is '||to_char(v_pay)||' riels.';
      v_sql := 'begin p_set_send_day_msg('''||v_msg||'''); end;';
      dbms_scheduler.create_job(job_name   => 'SMS_DAY_JOB_PAY_'||to_char(systimestamp,'hh24missff3'),
                             job_type   => 'PLSQL_BLOCK',
                             job_class  => 'MIS_JOB_CLASS',
                             job_action => v_sql,
                             enabled    => TRUE);

      -- 发送弃奖额短信
      v_msg := to_char(v_rpt_day,'yyyy-mm-dd') || '. the amount for abandon reward is '||to_char(v_aband)||' riels.';
      v_sql := 'begin p_set_send_day_msg('''||v_msg||'''); end;';
      dbms_scheduler.create_job(job_name   => 'SMS_DAY_JOB_ABAND_'||to_char(systimestamp,'hh24missff3'),
                             job_type   => 'PLSQL_BLOCK',
                             job_class  => 'MIS_JOB_CLASS',
                             job_action => v_sql,
                             enabled    => TRUE);
*/
   exception
      when others then
         select count(*) into v_cnt from dual;
   end;

END;
/

-----------------------------------
--  New procedure p_mis_set_log  --
-----------------------------------
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

-----------------------------------
--  New procedure p_mis_dss_run  --
-----------------------------------
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
   v_desc := '开始日结. SettleID ['||p_settle_id||'] Settle Target Date ['||to_char(v_rpt_day,'yyyy-mm-dd')||'] Start time: ['||to_char(v_rec_date, 'yyyy-mm-dd hh24:mi:ss')||']';
   p_mis_set_log(1,v_desc);

   v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_00_prepare]';
   dbms_output.put_line(v_desc);
   p_mis_dss_00_prepare;

   v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_10_gen_abandon]';
   dbms_output.put_line(v_desc);
   p_mis_dss_10_gen_abandon(p_settle_id, p_is_maintance);

   v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_13_gen_his_dict]';
   dbms_output.put_line(v_desc);
   p_mis_dss_13_gen_his_dict(p_settle_id);

   v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_15_gen_winning]';
   dbms_output.put_line(v_desc);
   p_mis_dss_15_gen_winning(p_settle_id);

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

   p_mis_set_log(1,'日结成功. 执行时长: [ '||trunc((sysdate-v_rec_date)*24*60*60)||'秒 ]');

exception
   when others then
      p_mis_set_log(1,'日结失败. 停止在步骤 ['||v_desc||']. 执行时长: [ '||trunc((sysdate-v_rec_date)*24*60*60)||'秒 ] 失败原因: '||sqlerrm);
      dbms_output.put_line('日结失败. 停止在步骤 ['||v_desc||']. 执行时长: [ '||trunc((sysdate-v_rec_date)*24*60*60)||'秒 ] 失败原因: '||sqlerrm);
--      RAISE_APPLICATION_ERROR(-20001, '日结失败. 停止在步骤 ['||v_desc||']. 执行时长: [ '||trunc((sysdate-v_rec_date)*24*60*60)||'秒 ] 失败原因: '||sqlerrm);
end;
/

-----------------------------------------
--  New procedure p_mis_set_day_close  --
-----------------------------------------
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

------------------------------------------
--  New procedure p_mis_trans_win_data  --
------------------------------------------
CREATE OR REPLACE PROCEDURE p_mis_trans_win_data
/***************************************************************
   ------------------- 中奖明细数据入库 -------------------
   ************************************************************/
(
 --------------输入----------------
 p_game_code      IN NUMBER, -- 游戏编码
 p_issue_number   IN NUMBER, -- 期次编码
 p_data_file_name IN STRING -- 数据文件名称
 ) AUTHID CURRENT_USER IS
   v_sql        VARCHAR2(1000); --执行的SQL
   v_count      INTEGER; --记录行数
   v_table_name VARCHAR2(100); --外部表名称
   v_file_name  VARCHAR2(100); --数据文件名称

   v_reward_time DATE; --开奖时间
   v_cnt         number(1); -- 是否存在记录

   v_desc varchar2(1000);
   v_rec_date date;

BEGIN
   v_desc := '调用 [中奖明细数据入库] game_code ['||p_game_code||'] issue_number ['||p_issue_number||']';
   p_mis_set_log(2,'期结-----] '||v_desc||'.......');
   v_rec_date := sysdate;

   -- 检查 iss_prize 表是否有数据
   select count(*)
     into v_cnt
     from dual
    where exists(select 1 from iss_prize where game_code=p_game_code and issue_number=p_issue_number);

   if v_cnt = 0 then
      RAISE_APPLICATION_ERROR(-20001, 'iss_prize is no data. game_code ['||p_game_code||'] issue_number ['||p_issue_number||']');
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

   p_mis_set_log(2,'期结-----] '||v_desc||'成功. 执行时长: [ '||trunc((sysdate-v_rec_date)*24*60*60)||'秒 ]');

EXCEPTION
   WHEN OTHERS THEN
      rollback;
      if v_desc is not null then
         p_mis_set_log(1,'日结-----] '||v_desc||'失败. 执行时长: [ '||trunc((sysdate-v_rec_date)*24*60*60)||'秒 ] 失败原因: '||sqlerrm);
      end if;
      raise;
END;
/

----------------------------------------------
--  New procedure p_mis_trans_win_data_job  --
----------------------------------------------
CREATE OR REPLACE PROCEDURE p_mis_trans_win_data_job
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
   v_sql    VARCHAR2(1000);

   v_desc varchar2(1000);
   v_rec_date date;

BEGIN
   -- 初始化数据
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   -- 拼接SQL，调用存储过程运行
   v_sql := 'begin p_mis_trans_win_data(' || p_game_code || ',' || p_issue_number ||
            ',''' || p_data_file_name || '''); end;';

   -- 开启job任务
   v_desc := '调用 [中奖明细数据入库任务]';
   p_mis_set_log(2,'期结-----] '||v_desc||'.......');
   v_rec_date := sysdate;
   dbms_scheduler.create_job(job_name   => 'JOB_WIN_'||p_game_code||'_'||p_issue_number||'_'||to_char(sysdate,'hh24miss'),
                             job_type   => 'PLSQL_BLOCK',
--                             job_class  => 'MIS_JOB_CLASS',
                             job_action => v_sql,
                             enabled    => TRUE);
   p_mis_set_log(2,'期结-----] '||v_desc||'成功. 执行时长: [ '||trunc((sysdate-v_rec_date)*24*60*60)||'秒 ]');

EXCEPTION
   WHEN OTHERS THEN
      dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);
      if v_desc is not null then
         p_mis_set_log(1,'日结-----] '||v_desc||'失败. 执行时长: [ '||trunc((sysdate-v_rec_date)*24*60*60)||'秒 ] 失败原因: '||sqlerrm);
      end if;

END;
/

-------------------------------------
--  New package ecomm_change_type  --
-------------------------------------
CREATE OR REPLACE PACKAGE ecomm_change_type IS
   /****** 发行费变更类型（1、期次开奖滚入；2、发行费到奖池；3、发行费到调节基金；） ******/
   in_from_issue_reward     /* 1=期次开奖滚入             */          CONSTANT NUMBER := 1;
   out_to_pool              /* 2=发行费到奖池             */          CONSTANT NUMBER := 2;
   out_to_adj               /* 3=发行费到调节基金         */          CONSTANT NUMBER := 3;
END;
/

-----------------------------------
--  New procedure p_om_add_pool  --
-----------------------------------
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

---------------------------------------------
--  New procedure p_om_agbroadcast_create  --
---------------------------------------------
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

---------------------------------------
--  New type type_game_auth_info_ts  --
---------------------------------------
create or replace type type_game_auth_info_ts is object
/*********************************************************************/
------------ 适用于: 批量插入区域和销售站授权游戏信息  ---------------
/*********************************************************************/
(

-----------    实体字段定义    -----------------
  gamecode                number(5),          --游戏编号
  objcode                 varchar2(8),        --区域或者销售站编码
  isenabled               number(5),          --是否有效
  paycommissionrate       number(8),          --兑奖代销费比率
  salecommissionrate      number(8),          --销售代销费比率
  roundingcommissionrate  number(8),          --发行费比率
  isallowpay              number(5),          --是否可兑奖
  isallowsale             number(5),          --是否可销售
  isallowcancel           number(5),          --是否可退票
  claimingscope           number(5)           --兑奖范围
);
/

---------------------------------------
--  New type type_game_auth_list_ts  --
---------------------------------------
create or replace type type_game_auth_list_ts as table of type_game_auth_info_ts;
/*********************************************************************/
------------ 适用于: 批量插入游戏授权，入口参数实体数组定义   -------------
/*********************************************************************/
/

--------------------------------------
--  New procedure p_om_agency_auth  --
--------------------------------------
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

---------------------------------------------
--  New procedure p_om_agency_status_ctrl  --
---------------------------------------------
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

------------------------------------
--  New procedure p_om_area_auth  --
------------------------------------
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

-------------------------------------
--  New type type_game_prize_info  --
-------------------------------------
create or replace type type_game_prize_info is object
/*********************************************************************/
------------ 适用于: 批量插入游戏奖级  ---------------
/*********************************************************************/
(

-----------    实体字段定义    -----------------
  gamecode                    number(5),          --游戏编号
  rulelevel                   number(5),          --奖级级别
  rulename                varchar2(1000),     --奖级名称
  ruledesc                varchar2(400),      --奖级描述
  ruleamount              number(16)          --奖级金额
);
/

-------------------------------------
--  New type type_game_prize_list  --
-------------------------------------
create or replace type type_game_prize_list as table of type_game_prize_info;
/*********************************************************************/
------------ 适用于: 批量插入游戏奖级   -------------
/*********************************************************************/
/

-------------------------------------------------
--  New procedure p_om_game_prize_batchinsert  --
-------------------------------------------------
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

-----------------------------------------------
--  New procedure p_om_issue_adjfund_modify  --
-----------------------------------------------
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

-------------------------------------
--  New type type_game_issue_info  --
-------------------------------------
create or replace type type_game_issue_info is object
/*********************************************************************/
------------ 适用于: 批量插入期次，入口参数实体定义   ----------------
/*********************************************************************/
(

-----------    实体字段定义    -----------------
  gamecode       number(3),          --游戏编号
  issuenumber    number(12),         --期次号
  planstarttime  date,               --预计开始时间
  planclosetime  date,               --预计结束时间
  planrewardtime date                --预计开奖时间
);
/

-----------------------------------------
--  New type type_game_issue_info_mon  --
-----------------------------------------
create or replace type type_game_issue_info_mon is object
/*********************************************************************/
------------ 适用于监控: 批量插入期次，入口参数实体定义（监控） ------
/*********************************************************************/
(

-------------    实体字段定义    -----------------
   gamecode                number(3),           --游戏编号
   issuenumber             number(12),          --期次号
   issue_status            number(2),           --期次状态
   risk_status             number(1),           --风控状态
   real_start_time         varchar2(19),        --实际期次开始时间
   real_close_time         varchar2(19),        --实际期次关闭时间
   real_reward_time        varchar2(19),        --实际期次开奖时间
   issue_end_time          varchar2(19),        --实际期次结束时间
   pool_start_amount       number(28),          --期初奖池
   first_draw_user         varchar2(40),        --第一次开奖用户
   second_draw_user        varchar2(40),        --第二次开奖用户
   pool_close_amount       number(28)           --期末奖池
);
/

-------------------------------------
--  New type type_game_issue_list  --
-------------------------------------
create or replace type type_game_issue_list as table of type_game_issue_info;
/*********************************************************************/
------------ 适用于: 批量插入期次，入口参数实体数组定义   ------------
/*********************************************************************/
/

-----------------------------------------
--  New type type_game_issue_list_mon  --
-----------------------------------------
create or replace type type_game_issue_list_mon as table of type_game_issue_info_mon;
/*********************************************************************/
---------- 适用于: 批量插入期次，入口参数实体数组定义（监控）---------
/*********************************************************************/
/

---------------------------------------
--  New procedure p_om_issue_create  --
---------------------------------------
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

---------------------------------------
--  New procedure p_om_issue_delete  --
---------------------------------------
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

--------------------------------------------
--  New procedure p_om_modify_teller_pwd  --
--------------------------------------------
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

------------------------------------------------
--  New procedure p_om_modify_teller_signoff  --
------------------------------------------------
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

-----------------------------------------------
--  New procedure p_om_modify_teller_signon  --
-----------------------------------------------
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

----------------------------------------
--  New procedure p_om_set_day_close  --
----------------------------------------
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

  --重置终端销售seq
  UPDATE saler_terminal SET trans_seq = 1;

  COMMIT;

  -- 调用MIS日结
  p_mis_set_day_close(to_date(to_char(p_day_code),'yyyymmdd'), v_errorcode, v_errormesg);


  --异常处理
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

END;
/

----------------------------------------
--  New procedure p_om_teller_create  --
----------------------------------------
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
  ---------migrate by Chen Zhen @ 2016-04-18

  ************************************************************/
(
 --------------输入----------------
 p_teller_code   IN NUMBER, -- 销售员编号
 p_agency_code   IN char,   -- 销售站编码
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
  v_curr_area    NUMBER := 0; --当前区域
  v_pare_area    NUMBER := 0; --父区域
  v_area_type    NUMBER := 0; --所属区域类型
  v_curr_limit   NUMBER := 0; --当前级别限制
  v_pare_limit   NUMBER := 0; --父亲级别限制
  v_crr_tell_num NUMBER := 0; --当前区域实际销售员数量
  v_par_tell_num NUMBER := 0; --当前父区域销售员数量
  v_agency_type  NUMBER := 0; --站点类型

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  /*-------检测所属站点编码的有效性-------*/
  SELECT COUNT(inf_agencys.agency_code)
    INTO v_temp
    FROM inf_agencys
   WHERE inf_agencys.agency_code = p_agency_code
     AND inf_agencys.status != eagency_status.cancelled;

  IF v_temp <= 0 THEN
    c_errorcode := 1;
    --c_errormesg := '无效的销售站';
    c_errormesg   := error_msg.msg0023;
    c_teller_code := 0;
    RETURN;
  END IF;

  /*-------检测重复 -------*/
  v_temp := 0;
  SELECT COUNT(inf_tellers.teller_code)
    INTO v_temp
    FROM inf_tellers
   WHERE inf_tellers.teller_code = p_teller_code;

  IF v_temp > 0 THEN
    c_errorcode := 1;
    --c_errormesg := '销售员编号重复';
    c_errormesg   := error_msg.msg0041;
    c_teller_code := 0;
    RETURN;
  END IF;

  /*-------检测站点类型-------*/
  SELECT inf_agencys.agency_type
    INTO v_agency_type
    FROM inf_agencys
   WHERE inf_agencys.agency_code = p_agency_code
     AND inf_agencys.status != eagency_status.cancelled;

  IF v_agency_type = eagency_type.center_agency THEN
    c_errorcode := 1;
    --c_errormesg := '中心站不可以配置销售员';
    c_errormesg   := error_msg.msg0042;
    c_teller_code := 0;
    RETURN;
  END IF;

  -- 超出系统预设范围
  v_temp := 999999;
  IF p_teller_code > v_temp THEN
    c_errorcode := 1;
    --c_errormesg := '销售员数量超出范围！';
    c_errormesg   := error_msg.msg0043;
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
     p_password);

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    --c_errormesg := '数据库异常' || SQLERRM;
    c_errormesg   := error_msg.msg0004 || SQLERRM;
    c_teller_code := 0;

END;
/

---------------------------------------------
--  New procedure p_om_teller_status_ctrl  --
---------------------------------------------
CREATE OR REPLACE PROCEDURE p_om_teller_status_ctrl
/****************************************************************/
  ------------------- 适用于控制销售员状态 --------------------
  -------add by dzg 2014-9-19 由于监控延迟可能导致状态更新问题
  -------修订前台对关键对象操作采用存储过程，以便统一入口校验
  -------modify by dzg 2014.10.20 修改支持本地化

  -------migrate by Chen Zhen @ 2016-04-14
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
   IF(p_tellerstatus < eteller_status.enabled or p_tellerstatus >eteller_status.deleted) THEN
     c_errorcode := 1;
     --c_errormesg := '无效的状态值';
     c_errormesg := error_msg.MSG0006;
    RETURN;
  END IF;

  /*-------检查是否存在------*/

  v_temp := 0;
  SELECT COUNT(inf_tellers.teller_code)
    INTO v_temp
    FROM inf_tellers
   WHERE inf_tellers.teller_code = p_tellercode;

  IF v_temp <= 0 THEN
    c_errorcode := 1;
    --c_errormesg := '无效的销售员';
    c_errormesg := error_msg.MSG0046;
    RETURN;
  END IF;

  /*-------检查当前状态是否一致,如果清退则提示已经清退-----*/
  v_temp := 0;

  SELECT inf_tellers.status
    INTO v_temp
    FROM inf_tellers
   WHERE inf_tellers.teller_code = p_tellercode;

  IF v_temp = p_tellerstatus THEN
    c_errorcode := 1;
    --c_errormesg := '数据库中已经是当前状态';
    c_errormesg := error_msg.MSG0007;
    RETURN;
  END IF;


  IF v_temp = eteller_status.deleted THEN
    c_errorcode := 1;
    --c_errormesg := '销售员已删除不能执行当前操作';
    c_errormesg := error_msg.MSG0047;
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
    --c_errormesg := '数据库异常' || SQLERRM;
    c_errormesg := error_msg.MSG0004 || SQLERRM;

END;
/

------------------------------------------
--  New procedure p_om_terminal_create  --
------------------------------------------
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

------------------------------------------
--  New procedure p_om_terminal_modify  --
------------------------------------------
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

-----------------------------------------------
--  New procedure p_om_terminal_status_ctrl  --
-----------------------------------------------
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

------------------------------------------
--  New procedure p_om_update_sysparam  --
------------------------------------------
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

------------------------------------
--  New package eschedule_status  --
------------------------------------
CREATE OR REPLACE PACKAGE eschedule_status IS
   /****** 终端升级计划状态(1=计划中/2=已执行/3=已取消) ******/
   planning         /* 1=计划中 */      CONSTANT NUMBER := 1;
   executed         /* 2=已执行 */      CONSTANT NUMBER := 2;
   cancelled        /* 3=已取消 */      CONSTANT NUMBER := 3;
END;
/

-----------------------------------------
--  New procedure p_om_updplan_create  --
-----------------------------------------
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

-----------------------------------------
--  New procedure p_om_updplan_modify  --
-----------------------------------------
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

----------------------------------------
--  Changed type type_game_auth_info  --
----------------------------------------
create or replace type type_game_auth_info is object
/*********************************************************************/
------------ add by dzg 适用于: 批量插入站点授权游戏信息  ---------------
/*********************************************************************/
(
  -----------    实体字段定义    -----------------
  agencycode              varchar(8),          --站点编号
  plancode                varchar(10),         --区域或者销售站编码
  salecommissionrate      number(8),           --销售代销费比率
  paycommissionrate       number(8)            --兑奖代销费比率

)
/
----------------------------------------
--  Changed type type_game_auth_list  --
----------------------------------------
create or replace type type_game_auth_list as table of type_game_auth_info;
/*********************************************************************/
------------ 适用于: 批量插入游戏授权，入口参数实体数组定义   -------------
/*********************************************************************/
/
--------------------------------
--  New package eteller_type  --
--------------------------------
CREATE OR REPLACE PACKAGE eteller_type IS
   /****** 销售员类型（1=普通销售员； 2=销售站经理；3=培训员） ******/
   employee                /* 1-普通销售员 */              CONSTANT NUMBER := 1;
   manager                 /* 2-销售站经理 */              CONSTANT NUMBER := 2;
   trainner                /* 3-培训员 */                  CONSTANT NUMBER := 3;
END;
/

-----------------------------------------
--  Changed procedure p_outlet_create  --
-----------------------------------------
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
-----------------------------------------
--  Changed procedure p_outlet_modify  --
-----------------------------------------
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
---------------------------
--  New type json_value  --
---------------------------
create or replace type json_value as object
(
  /*
  Copyright (c) 2010 Jonas Krogsboell

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  */

  typeval number(1), /* 1 = object, 2 = array, 3 = string, 4 = number, 5 = bool, 6 = null */
  str varchar2(32767),
  num number, /* store 1 as true, 0 as false */
  object_or_array sys.anydata, /* object or array in here */
  extended_str clob,

  /* mapping */
  mapname varchar2(4000),
  mapindx number(32),

  constructor function json_value(object_or_array sys.anydata) return self as result,
  constructor function json_value(str varchar2, esc boolean default true) return self as result,
  constructor function json_value(str clob, esc boolean default true) return self as result,
  constructor function json_value(num number) return self as result,
  constructor function json_value(b boolean) return self as result,
  constructor function json_value return self as result,
  static function makenull return json_value,

  member function get_type return varchar2,
  member function get_string(max_byte_size number default null, max_char_size number default null) return varchar2,
  member procedure get_string(self in json_value, buf in out nocopy clob),
  member function get_number return number,
  member function get_bool return boolean,
  member function get_null return varchar2,

  member function is_object return boolean,
  member function is_array return boolean,
  member function is_string return boolean,
  member function is_number return boolean,
  member function is_bool return boolean,
  member function is_null return boolean,

  /* Output methods */
  member function to_char(spaces boolean default true, chars_per_line number default 0) return varchar2,
  member procedure to_clob(self in json_value, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true),
  member procedure print(self in json_value, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null), --32512 is maximum
  member procedure htp(self in json_value, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null),

  member function value_of(self in json_value, max_byte_size number default null, max_char_size number default null) return varchar2

) not final;
/

---------------------------------
--  New type json_value_array  --
---------------------------------
create or replace type json_value_array as table of json_value;
/

--------------------------
--  New type json_list  --
--------------------------
create or replace type json_list as object (
  /*
  Copyright (c) 2010 Jonas Krogsboell

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  */

  list_data json_value_array,
  constructor function json_list return self as result,
  constructor function json_list(str varchar2) return self as result,
  constructor function json_list(str clob) return self as result,
  constructor function json_list(cast json_value) return self as result,

  member procedure append(self in out nocopy json_list, elem json_value, position pls_integer default null),
  member procedure append(self in out nocopy json_list, elem varchar2, position pls_integer default null),
  member procedure append(self in out nocopy json_list, elem number, position pls_integer default null),
  member procedure append(self in out nocopy json_list, elem boolean, position pls_integer default null),
  member procedure append(self in out nocopy json_list, elem json_list, position pls_integer default null),

  member procedure replace(self in out nocopy json_list, position pls_integer, elem json_value),
  member procedure replace(self in out nocopy json_list, position pls_integer, elem varchar2),
  member procedure replace(self in out nocopy json_list, position pls_integer, elem number),
  member procedure replace(self in out nocopy json_list, position pls_integer, elem boolean),
  member procedure replace(self in out nocopy json_list, position pls_integer, elem json_list),

  member function count return number,
  member procedure remove(self in out nocopy json_list, position pls_integer),
  member procedure remove_first(self in out nocopy json_list),
  member procedure remove_last(self in out nocopy json_list),
  member function get(position pls_integer) return json_value,
  member function head return json_value,
  member function last return json_value,
  member function tail return json_list,

  /* Output methods */
  member function to_char(spaces boolean default true, chars_per_line number default 0) return varchar2,
  member procedure to_clob(self in json_list, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true),
  member procedure print(self in json_list, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null), --32512 is maximum
  member procedure htp(self in json_list, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null),

  /* json path */
  member function path(json_path varchar2, base number default 1) return json_value,
  /* json path_put */
  member procedure path_put(self in out nocopy json_list, json_path varchar2, elem json_value, base number default 1),
  member procedure path_put(self in out nocopy json_list, json_path varchar2, elem varchar2  , base number default 1),
  member procedure path_put(self in out nocopy json_list, json_path varchar2, elem number    , base number default 1),
  member procedure path_put(self in out nocopy json_list, json_path varchar2, elem boolean   , base number default 1),
  member procedure path_put(self in out nocopy json_list, json_path varchar2, elem json_list , base number default 1),

  /* json path_remove */
  member procedure path_remove(self in out nocopy json_list, json_path varchar2, base number default 1),

  member function to_json_value return json_value
  /* --backwards compatibility
  ,
  member procedure add_elem(self in out nocopy json_list, elem json_value, position pls_integer default null),
  member procedure add_elem(self in out nocopy json_list, elem varchar2, position pls_integer default null),
  member procedure add_elem(self in out nocopy json_list, elem number, position pls_integer default null),
  member procedure add_elem(self in out nocopy json_list, elem boolean, position pls_integer default null),
  member procedure add_elem(self in out nocopy json_list, elem json_list, position pls_integer default null),

  member procedure set_elem(self in out nocopy json_list, position pls_integer, elem json_value),
  member procedure set_elem(self in out nocopy json_list, position pls_integer, elem varchar2),
  member procedure set_elem(self in out nocopy json_list, position pls_integer, elem number),
  member procedure set_elem(self in out nocopy json_list, position pls_integer, elem boolean),
  member procedure set_elem(self in out nocopy json_list, position pls_integer, elem json_list),

  member procedure remove_elem(self in out nocopy json_list, position pls_integer),
  member function get_elem(position pls_integer) return json_value,
  member function get_first return json_value,
  member function get_last return json_value
--  */

) not final;
/

---------------------
--  New type json  --
---------------------
create or replace type json as object (
  /*
  Copyright (c) 2010 Jonas Krogsboell

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  */

  /* Variables */
  json_data json_value_array,
  check_for_duplicate number,

  /* Constructors */
  constructor function json return self as result,
  constructor function json(str varchar2) return self as result,
  constructor function json(str in clob) return self as result,
  constructor function json(cast json_value) return self as result,
  constructor function json(l in out nocopy json_list) return self as result,

  /* Member setter methods */
  member procedure remove(pair_name varchar2),
  member procedure put(self in out nocopy json, pair_name varchar2, pair_value json_value, position pls_integer default null),
  member procedure put(self in out nocopy json, pair_name varchar2, pair_value varchar2, position pls_integer default null),
  member procedure put(self in out nocopy json, pair_name varchar2, pair_value number, position pls_integer default null),
  member procedure put(self in out nocopy json, pair_name varchar2, pair_value boolean, position pls_integer default null),
  member procedure check_duplicate(self in out nocopy json, v_set boolean),
  member procedure remove_duplicates(self in out nocopy json),

  /* deprecated putter use json_value */
  member procedure put(self in out nocopy json, pair_name varchar2, pair_value json, position pls_integer default null),
  member procedure put(self in out nocopy json, pair_name varchar2, pair_value json_list, position pls_integer default null),

  /* Member getter methods */
  member function count return number,
  member function get(pair_name varchar2) return json_value,
  member function get(position pls_integer) return json_value,
  member function index_of(pair_name varchar2) return number,
  member function exist(pair_name varchar2) return boolean,

  /* Output methods */
  member function to_char(spaces boolean default true, chars_per_line number default 0) return varchar2,
  member procedure to_clob(self in json, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true),
  member procedure print(self in json, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null), --32512 is maximum
  member procedure htp(self in json, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null),

  member function to_json_value return json_value,
  /* json path */
  member function path(json_path varchar2, base number default 1) return json_value,

  /* json path_put */
  member procedure path_put(self in out nocopy json, json_path varchar2, elem json_value, base number default 1),
  member procedure path_put(self in out nocopy json, json_path varchar2, elem varchar2  , base number default 1),
  member procedure path_put(self in out nocopy json, json_path varchar2, elem number    , base number default 1),
  member procedure path_put(self in out nocopy json, json_path varchar2, elem boolean   , base number default 1),
  member procedure path_put(self in out nocopy json, json_path varchar2, elem json_list , base number default 1),
  member procedure path_put(self in out nocopy json, json_path varchar2, elem json      , base number default 1),

  /* json path_remove */
  member procedure path_remove(self in out nocopy json, json_path varchar2, base number default 1),

  /* map functions */
  member function get_values return json_list,
  member function get_keys return json_list

) not final;
/

--------------------------------
--  New procedure p_set_auth  --
--------------------------------
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

----------------------------------
--  New procedure p_set_cancel  --
----------------------------------
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

    insert into his_cancelticket
      (applyflow_cancel, canceltime, applyflow_sell, terminal_code, teller_code, agency_code, is_center, org_code, cancel_seq)
    values
      (v_cancel_apply_flow, sysdate, v_sale_apply_flow, v_cancel_terminal, v_cancel_teller, v_cancel_agency_code, 0, v_org_code, f_get_his_cancel_seq);

  end if;

  /************************ 构造返回参数 *******************************/
  v_out_json.put('type', v_input_json.get('type').get_number);
  v_out_json.put('rc', 0);

  if v_is_center <> 1 then
    v_out_json.put('account_balance', v_out_balance);
    v_out_json.put('marginal_credit', f_get_agency_credit(v_cancel_agency_code));
    update saler_terminal
       set trans_seq = nvl(trans_seq, 0) + 1
     where terminal_code = v_cancel_terminal
    returning
      trans_seq
    into
      v_flownum;

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

---------------------------------------
--  New procedure p_set_get_accinfo  --
---------------------------------------
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

----------------------------------------
--  New procedure p_set_get_gameinfo  --
----------------------------------------
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
    return;
  end if;

  -- 检索需要的信息
  v_ret_str := f_get_agency_info(v_agency);
  if length(v_ret_str) <> 0 then
    for tab in (select rownum cnt, column_value from table(dbtool.strsplit(v_ret_str))) loop
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

---------------------------------------
--  New procedure p_set_get_lotinfo  --
---------------------------------------
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

-----------------------------------------
--  New procedure p_sys_get_parameter  --
-----------------------------------------
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

-------------------------
--  New package egame  --
-------------------------
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

---------------------------------------------
--  New procedure p_set_issue_draw_notice  --
---------------------------------------------
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
  FOR parea IN (SELECT DISTINCT area_code
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
                     WHERE area_code = parea.area_code))
     GROUP BY prize_name;

    -- 合并上区域的信息
    SELECT xmlelement("Area",
                      xmlconcat(xmlelement("areaCode", org_code),
                                xmlelement("areaName", org_name),
                                v_loop_xml))
      INTO v_loop_xml
      FROM inf_orgs
     WHERE org_code = parea.area_code;

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

--------------------------------------------
--  New procedure p_set_issue_error_info  --
--------------------------------------------
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

------------------------------------------
--  New procedure p_set_issue_pool_get  --
------------------------------------------
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

---------------------------------------------
--  New procedure p_set_issue_pool_modify  --
---------------------------------------------
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

-------------------------------------------
--  New procedure p_set_issue_risk_stat  --
-------------------------------------------
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

-------------------------------
--  New package edraw_state  --
-------------------------------
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

----------------------------------------
--  New procedure p_set_issue_status  --
----------------------------------------
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

---------------------------------------------
--  New procedure p_set_issue_ticket_stat  --
---------------------------------------------
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

----------------------------------------------
--  New procedure p_set_issue_winning_stat  --
----------------------------------------------
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

--------------------------------------------------
--  New procedure p_set_json_issue_draw_notice  --
--------------------------------------------------
create or replace procedure p_set_json_issue_draw_notice
/*****************************************************************/
   ----------- 生成json开奖公告 ---------------
   ----- created by chen zhen @ 2016-04-18
/*****************************************************************/

(
   p_game_code    in number, --游戏编码
   p_issue_number in number, --期次编码

   c_json      out string,   --返回值
   c_errorcode out number,   --业务错误编码
   c_errormesg out string    --错误信息描述
) is

   all_json_obj json;
   second_json json;
   draw_json json;
   draw_json_list json_list;

   v_rank1_json json_list;
   v_rank2_json json_list;
   v_rank3_json json_list;
   v_rank4_json json_list;
   v_rank5_json json_list;
   v_rank_json json_list;

   -- 临时的json和json list变量
   tempobj json;
   tempobj_list json_list;

   v_draw_code            varchar2(200);
   v_winning_amount       number(28);
   v_sale_amount          number(28);

   -- 最近100期的开奖号码
   type draw_record is record(issue_number number(28), final_draw_number varchar2(200));
   type draw_collect is table of draw_record;
   v_array_draw_code draw_collect;

   v_loop_i number(2);

   -- 开奖结果，每个小球对应的数字
   draw_number number(3);

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

   -- 11选5，所有要先开五个坑
   for v_loop_i in 1 .. 11 loop
      v_rank1_json.append(0);
      v_rank2_json.append(0);
      v_rank3_json.append(0);
      v_rank4_json.append(0);
      v_rank5_json.append(0);
      v_rank_json.append(0);
   end loop;

   all_json_obj.put('cmd', 12500);
   all_json_obj.put('game', p_game_code);
   all_json_obj.put('issue', p_issue_number);

   if p_issue_number <> 0 then
     -- 开奖号码
     begin
        select final_draw_number, issue_sale_amount, winning_amount
          into v_draw_code, v_sale_amount, v_winning_amount
          from iss_game_issue
         where game_code=p_game_code
           and issue_number=p_issue_number
           and issue_status >= egame_issue_status.issuedatastoragecompleted;
     exception
        when no_data_found then
        c_errorcode := 1;
  --      c_errormesg := error_msg.err_p_set_json_issue_draw_n_1;               -- 游戏期次不存在，或者未开奖
        return;
     end;

     all_json_obj.put('draw_code', v_draw_code);

     -- 销售和中奖金额
     second_json.put('sale_amount', v_sale_amount);
     second_json.put('win_amount', v_winning_amount);

     -- 奖级奖金表
     for tab in (select prize_level,prize_name , prize_count*single_bet_reward amount,prize_count from iss_prize where game_code=p_game_code and issue_number=p_issue_number order by prize_level) loop
        tempobj := json();
        tempobj.put('name', tab.prize_name);
        tempobj.put('amount', tab.amount);
        tempobj.put('bets', tab.prize_count);
        tempobj_list.append(tempobj.to_json_value);
     end loop;

     second_json.put('prize_level',tempobj_list.to_json_value);
     all_json_obj.put('win_info', second_json.to_json_value);

     -- 中大奖的销售站
     tempobj_list := json_list();
     for tab in (
                 with sa as
                  (select agency_code, address from inf_agencys),
                 big_win_limit as
                  (select limit_big_prize from gp_static gs where game_code = p_game_code),
                 hwtd_gs as
                  (select agency_code, win_amount amount
                     from his_win_ticket hwt, big_win_limit
                    where game_code = p_game_code
                      and issue_number= p_issue_number
                      and win_amount > big_win_limit.limit_big_prize
                    order by win_amount desc),
                 top_10_win as
                  (select agency_code, amount from hwtd_gs where rownum <= 10)
                 select agency_code, amount, address
                   from top_10_win
                   join sa
                  using(agency_code)
                ) loop
        tempobj := json();
        tempobj.put('agency_code', tab.agency_code);
        tempobj.put('win_amount', tab.amount);
        tempobj.put('agency_adderss',tab.address);
        tempobj_list.append(tempobj.to_json_value);
     end loop;
     all_json_obj.put('big_win', tempobj_list.to_json_value);

   end if;

   -- 先获取最近100期的开奖号码
   with tab as (
      select issue_number, final_draw_number
        from iss_game_issue
       where game_code=p_game_code and issue_status > 12
         and final_draw_number is not null
         -- 如果期次编号为0，就把最近的开奖号码发回去
         and issue_number <= (case when p_issue_number = 0 then 999999999 else p_issue_number end)
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

   --all_json_obj.print;

   all_json_obj.put('roll_text_1', nvl(f_get_sys_param('1101'), ''));
   all_json_obj.put('roll_text_2', nvl(f_get_sys_param('1102'), ''));
   all_json_obj.put('roll_text_3', nvl(f_get_sys_param('1103'), ''));

   all_json_obj.put('errorCode', 5000);

   c_json := all_json_obj.to_char(false,0);

exception
   when others then
      dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

end;
/

---------------------------------
--  New procedure p_set_login  --
---------------------------------
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

  -- 判断销售员是否可用
  v_ret_num := f_get_teller_static(v_teller);
  if v_ret_num <> eteller_status.enabled then
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

----------------------------------
--  New procedure p_set_logoff  --
----------------------------------
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

---------------------------------------
--  New procedure p_set_modify_pass  --
---------------------------------------
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

-------------------------------
--  New procedure p_set_pay  --
-------------------------------
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
    if v_pay_amount >= to_number(f_get_sys_param(6)) and f_get_sys_param(7) = '1' and v_org_code <> '00' then
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
    if v_pay_amount >= to_number(f_get_sys_param(5)) then
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

  -- 培训票，不入库
  if v_is_train <> eboolean.yesorenabled then
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
       is_big_prize,                                               pay_seq)
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
       temp_json.get('is_big_prize').get_number,                   f_get_his_pay_seq);
  end if;

  /************************ 构造返回参数 *******************************/
  v_out_json.put('type', v_input_json.get('type').get_number);
  v_out_json.put('rc', 0);

  if v_is_center <> 1 then
    v_out_json.put('account_balance', v_out_balance);
    v_out_json.put('marginal_credit', f_get_agency_credit(v_pay_agency_code));
    update saler_terminal
       set trans_seq = nvl(trans_seq, 0) + 1
     where terminal_code = v_pay_terminal
    returning
      trans_seq
    into
      v_flownum;

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

--------------------------------
--  New procedure p_set_sale  --
--------------------------------
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

  if v_is_train = eboolean.noordisabled then

    -- 计算销售佣金
    v_sale_amount := temp_json.get('ticket_amount').get_number;
    v_sale_comm_r := f_get_agency_game_comm(v_agency_code, v_game_code, ecomm_type.sale);
    v_sale_org_comm_r := f_get_org_game_comm(v_org_code, v_game_code, ecomm_type.sale);
    v_sale_comm := v_sale_amount * v_sale_comm_r / 1000;
    v_sale_org_comm := v_sale_amount * v_sale_org_comm_r / 1000;

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
       result_code,                                                sell_seq)
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
       0,                                                          f_get_his_sell_seq);

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

  -- 调整终端机交易序号
  update saler_terminal
     set trans_seq = nvl(trans_seq, 0) + 1
   where terminal_code = v_term_code
  returning
    trans_seq
  into
    v_flownum;

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

----------------------------------------
--  New procedure p_set_send_day_msg  --
----------------------------------------
CREATE OR REPLACE PROCEDURE p_set_send_day_msg
/*****************************************************************/
   ----------- 日结消息发布 ---------------
   /*****************************************************************/

(
   p_msg    IN varchar2
) AUTHID CURRENT_USER IS
   v_param VARCHAR2(200);
   v_ip    VARCHAR2(200);
   v_user  VARCHAR2(200);

   v_send_string VARCHAR2(2000);

   v_c_errorcode NUMBER(10);
   v_c_errormesg VARCHAR2(1000);

begin
   if p_msg is null then
      return;
   end if;

   -- 获取系统参数
   p_sys_get_parameter(p_param_code => 1017, c_param_value => v_param, c_errorcode => v_c_errorcode, c_errormesg => v_c_errormesg);      -- 获取消息网关IP地址
   IF v_c_errorcode <> 0 THEN
      RETURN;
   END IF;
   v_ip := trim(v_param);

   p_sys_get_parameter(p_param_code => 1019, c_param_value => v_param, c_errorcode => v_c_errorcode, c_errormesg => v_c_errormesg);      -- 获取消息组ID
   IF v_c_errorcode <> 0 THEN
      RETURN;
   END IF;
   v_user := trim(v_param);

   -- 调用网关，发送消息
   v_send_string := 'http://' || v_ip || '/mailsmsnotify/notifyC.do?method=sendMsg' || chr(38) || 'subject=' || chr(38) || 'content=' || p_msg || chr(38) || 'serviceTypeId=' || v_user;
   -- http://172.16.33.3:8080/mailsmsnotify/notifyC.do?method=sendTD&info=verifyCodeis7788&phoneNum=089304531

   -- 替换掉消息里面的空格
   v_send_string := replace(v_send_string,' ','%20');

   dbms_output.put_line(v_send_string);
   select utl_http.request(v_send_string) into v_c_errorcode from dual;

end;
/

------------------------------------------
--  New procedure p_set_send_issue_msg  --
------------------------------------------
CREATE OR REPLACE PROCEDURE p_set_send_issue_msg
/*****************************************************************/
   ----------- 期结消息发布 ---------------
   /*****************************************************************/

(p_msg IN VARCHAR2) AUTHID CURRENT_USER IS
   v_param VARCHAR2(200);
   v_ip    VARCHAR2(200);
   v_user  VARCHAR2(200);
   v_msg   VARCHAR2(4000);

   v_c_errorcode NUMBER(10);
   v_c_errormesg VARCHAR2(4000);

BEGIN
   IF p_msg IS NULL THEN
      raise_application_error(-20123, 'p_msg IS NULL', TRUE);
      RETURN;
   END IF;

   v_msg := REPLACE(p_msg, ' ', '%20');

   -- 获取系统参数
   p_sys_get_parameter(p_param_code  => 1017,
                       c_param_value => v_param,
                       c_errorcode   => v_c_errorcode,
                       c_errormesg   => v_c_errormesg); -- 获取消息网关IP地址
   IF v_c_errorcode <> 0 THEN
      raise_application_error(-20123, 'p_param_code => 17', TRUE);
      RETURN;
   END IF;
   v_ip := TRIM(v_param);

   p_sys_get_parameter(p_param_code  => 1018,
                       c_param_value => v_param,
                       c_errorcode   => v_c_errorcode,
                       c_errormesg   => v_c_errormesg); -- 获取消息组ID
   IF v_c_errorcode <> 0 THEN
      raise_application_error(-20123, 'p_param_code => 18', TRUE);
      RETURN;
   END IF;
   v_user := TRIM(v_param);

   -- 调用网关，发送消息
   SELECT utl_http.request('http://'||v_ip||'/mailsmsnotify/notifyC.do?method=sendMsg'||chr(38)||'subject='||chr(38)||'content='||v_msg||chr(38)||'serviceTypeId='||v_user)
     INTO v_c_errormesg
     FROM dual;

   p_sys_get_parameter(p_param_code  => 1019,
                       c_param_value => v_param,
                       c_errorcode   => v_c_errorcode,
                       c_errormesg   => v_c_errormesg); -- 获取消息组ID
   IF v_c_errorcode <> 0 THEN
      raise_application_error(-20123, 'p_param_code => 19', TRUE);
      RETURN;
   END IF;
   v_user := TRIM(v_param);

   -- 调用网关，发送邮件
   SELECT utl_http.request('http://'||v_ip||'/mailsmsnotify/notifyC.do?method=sendMsg'||chr(38)||'subject='||chr(38)||'content='||v_msg||chr(38)||'serviceTypeId='||v_user)
     INTO v_c_errormesg
     FROM dual;

END;
/

-------------------------------------------------
--  New procedure p_sys_update_negative_issue  --
-------------------------------------------------
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

-------------------------------------
--  New procedure p_teller_create  --
-------------------------------------
CREATE OR REPLACE PROCEDURE p_teller_create
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

--------------------------------------------
--  New procedure p_teller_status_change  --
--------------------------------------------
CREATE OR REPLACE PROCEDURE p_teller_status_change
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

------------------------------------------
--  New procedure p_time_lot_promotion  --
------------------------------------------
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

---- add by 陈震: 2015/10/14
/****************************************************************/
is
  -- 加减钱的操作
  v_out_balance           number(28);                   -- 传出的销售站余额
  v_temp_balance          number(28);                   -- 临时金额

begin

  for tab in (select sale_agency, sum(pure_amount) amount from sub_sell where sale_month = to_char(p_curr_date - 1, 'yyyy-mm') group by sale_agency having sum(pure_amount) >= 1200*10000) loop
    if tab.amount >= 2400 * 10000 then
      p_agency_fund_change(tab.sale_agency, eflow_type.lottery_sale_comm, (tab.amount * 0.02), 0, 0, v_out_balance, v_temp_balance);
      continue;
    end if;

    p_agency_fund_change(tab.sale_agency, eflow_type.lottery_sale_comm, (tab.amount * 0.01), 0, 0, v_out_balance, v_temp_balance);
  end loop;

  commit;
end;
/

---------------------------------------
--  New procedure p_time_gen_by_day  --
---------------------------------------
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
      --if to_char(sysdate, 'dd') = '01' then
        p_time_lot_promotion;
      --end if;

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
       from fund)
   select to_char(p_curr_date - 1, 'yyyy-mm-dd'),          org_code,
          -- 通用
          be_account_balance, af_account_balance,          charge,          withdraw,
          -- 销售金额-销售佣金-兑奖-兑奖佣金-中心兑奖-中心兑奖佣金+退货佣金-退货金额 -中心退票+中心退票佣金
          (sale - sale_comm - paid - pay_comm - center_pay - center_pay_comm + rtv_comm - rtv
           + lot_sale - lot_sale_comm - lot_paid - lot_pay_comm - lot_center_pay - lot_center_pay_comm - lot_rtv + lot_rtv_comm
           - lot_center_rtv + lot_center_rtv_comm) incoming,
          (charge - withdraw - center_pay - lot_center_pay) pay_up,
          -- 即开票
          sale,                sale_comm,              paid,      pay_comm,     rtv,       rtv_comm,     center_pay,     center_pay_comm,
          -- 电脑票
          lot_sale,            lot_sale_comm,          lot_paid,  lot_pay_comm, lot_rtv,   lot_rtv_comm, lot_center_pay, lot_center_pay_comm, lot_center_rtv,lot_center_rtv_comm
     from pre_detail;

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
          (nvl(charge, 0) - nvl(withdraw, 0) - nvl(paid, 0) + nvl(paid_comm, 0)) pay_up from inf_orgs left join fund using (org_code);

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
   select to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd'), org_code, do_type, PLAN_CODE,amount, tickets from base;

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
       and pay_time <  trunc(p_curr_date)),
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
  )
  select sale_day, sale_month, nvl(area_code, 'NULL'), org_code, plan_code,
         nvl(sum(sale_amount), 0) sale_amount,
         nvl(sum(sale_comm), 0) sale_comm,
         nvl(sum(cancel_amount), 0) cancel_amount,
         nvl(sum(cancel_comm), 0) cancel_comm,
         nvl(sum(pay_amount), 0) pay_amount,
         nvl(sum(pay_comm), 0) pay_comm,
         (nvl(sum(sale_amount), 0) - nvl(sum(sale_comm), 0) - nvl(sum(pay_amount), 0) - nvl(sum(pay_comm), 0) - nvl(sum(cancel_amount), 0) + nvl(sum(cancel_comm), 0)) incoming
    from pre_detail
   group by sale_day, sale_month, area_code, org_code, plan_code;

  insert into his_pay_level
    (sale_date, sale_month, org_code, plan_code, level_1, level_2, level_3, level_4, level_5, level_6, level_7, level_8, level_other, total)
  with
  pay_detail as
     (select to_char(PAY_TIME, 'yyyy-mm-dd') sale_day,
             to_char(PAY_TIME, 'yyyy-mm') sale_month,
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
     where pay_time >= trunc(p_curr_date) - 1
       and pay_time <  trunc(p_curr_date))
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
            PLAN_CODE;
  commit;

end;
/

----------------------------------------
--  New procedure p_time_gen_by_hour  --
----------------------------------------
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
   v_now_seq := to_number(to_char(v_end_time, 'hh24')) * 60 / v_step_minutes + trunc(to_number(to_char(v_end_time, 'mi')) / v_step_minutes);

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

----------------------------------------
--  New package echarity_change_type  --
----------------------------------------
CREATE OR REPLACE PACKAGE echarity_change_type IS
   /****** 公益金变更类型（1、期次开奖滚入；2、弃奖滚入；） ******/
   in_from_issue_reward     /* 1=期次开奖滚入             */          CONSTANT NUMBER := 1;
   in_from_abandon          /* 2=发行费到奖池             */          CONSTANT NUMBER := 2;
END;
/

----------------------------------
--  New package edevice_status  --
----------------------------------
CREATE OR REPLACE PACKAGE edevice_status IS
   /****** 设备状态(1=启用/2=暂停/3=停用) ******/
   enabled                  /* 1=启用 */                CONSTANT NUMBER := 1;
   disabled                 /* 2=暂停 */                CONSTANT NUMBER := 2;
   cancelled                /* 3=停用 */                CONSTANT NUMBER := 3;
END;
/

--------------------------------
--  New package edevice_type  --
--------------------------------
CREATE OR REPLACE PACKAGE edevice_type IS
   /****** 设备类型（1=RNG） ******/
   rng                  /* 1=RNG */                CONSTANT NUMBER := 1;
END;
/

-----------------------------
--  New package egametype  --
-----------------------------
CREATE OR REPLACE PACKAGE egametype IS
   /****** 游戏类型(1=基诺/2=乐透/3=数字) ******/
   keno                     /* 1=基诺 */                CONSTANT NUMBER := 1;
   lotto                    /* 2=乐透 */                CONSTANT NUMBER := 2;
   digit                    /* 3=数字 */                CONSTANT NUMBER := 3;
END;
/

-----------------------------------
--  New package egame_open_type  --
-----------------------------------
CREATE OR REPLACE PACKAGE egame_open_type IS
   /****** 游戏开奖模式（1=快开、2=内部算奖、3=外部算奖）******/
   autolotterydraw                  /* 1=快开 */            CONSTANT NUMBER := 1;
   manuallotterydraw                /* 2=内部算奖 */        CONSTANT NUMBER := 2;
   inputlotterydraw                 /* 3=外部算奖 */        CONSTANT NUMBER := 3;
END;
/

--------------------------------
--  New package egame_status  --
--------------------------------
CREATE OR REPLACE PACKAGE egame_status IS
   /****** 游戏状态(1=启用/2=暂停/3=停用) ******/
   enabled      /* 1=启用 */   CONSTANT NUMBER := 1;
   paused       /* 2=暂停 */   CONSTANT NUMBER := 2;
   cancelled    /* 3=停用 */   CONSTANT NUMBER := 3;
END;
/

-------------------------------
--  New package eidcardtype  --
-------------------------------
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

---------------------------------
--  New package emsg_disp_loc  --
---------------------------------
CREATE OR REPLACE PACKAGE emsg_disp_loc IS
   /****** 终端即时消息显示位置（1=主屏、2=TDS、3=打印机） ******/
   main_screen        /* 1=主屏 */          CONSTANT NUMBER := 1;
   tds                /* 2=TDS */           CONSTANT NUMBER := 2;
   printer            /* 3=打印机 */        CONSTANT NUMBER := 3;

END;
/

------------------------------------
--  New package emsg_send_object  --
------------------------------------
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

----------------------------------
--  Changed package eplan_flow  --
----------------------------------
CREATE OR REPLACE PACKAGE eplan_flow IS
   /****** 方案应对的处理流程（1-a计划，2-b计划） plan_flow ******/
   plan_a          /* 1-a计划 */                  CONSTANT NUMBER := 1;
   plan_b          /* 2-b计划 */                  CONSTANT NUMBER := 2;
END;
/
----------------------------------------------
--  New package ereward_code_input_methold  --
----------------------------------------------
CREATE OR REPLACE PACKAGE ereward_code_input_methold IS
   /****** 开奖号码输入模式（1=手工；2=光盘） ******/
   manual     /* 1=手工 */          CONSTANT NUMBER := 1;
   cdrom      /* 2=光盘 */          CONSTANT NUMBER := 2;
END;
/

----------------------------------------
--  New package esys_comm_log_status  --
----------------------------------------
CREATE OR REPLACE PACKAGE esys_comm_log_status IS
   /****** 主机通讯状态(0=新增、1=主机已经读取) ******/
   new                  /* 1=可用 */                CONSTANT NUMBER := 1;
   read                 /* 2=已禁用 */              CONSTANT NUMBER := 2;
END;
/

---------------------------
--  New package json_ac  --
---------------------------
create or replace package json_ac as
  --json type methods

  procedure object_remove(p_self in out nocopy json, pair_name varchar2);
  procedure object_put(p_self in out nocopy json, pair_name varchar2, pair_value json_value, position pls_integer default null);
  procedure object_put(p_self in out nocopy json, pair_name varchar2, pair_value varchar2, position pls_integer default null);
  procedure object_put(p_self in out nocopy json, pair_name varchar2, pair_value number, position pls_integer default null);
  procedure object_put(p_self in out nocopy json, pair_name varchar2, pair_value boolean, position pls_integer default null);
  procedure object_check_duplicate(p_self in out nocopy json, v_set boolean);
  procedure object_remove_duplicates(p_self in out nocopy json);

  procedure object_put(p_self in out nocopy json, pair_name varchar2, pair_value json, position pls_integer default null);
  procedure object_put(p_self in out nocopy json, pair_name varchar2, pair_value json_list, position pls_integer default null);

  function object_count(p_self in json) return number;
  function object_get(p_self in json, pair_name varchar2) return json_value;
  function object_get(p_self in json, position pls_integer) return json_value;
  function object_index_of(p_self in json, pair_name varchar2) return number;
  function object_exist(p_self in json, pair_name varchar2) return boolean;

  function object_to_char(p_self in json, spaces boolean default true, chars_per_line number default 0) return varchar2;
  procedure object_to_clob(p_self in json, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true);
  procedure object_print(p_self in json, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null);
  procedure object_htp(p_self in json, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null);

  function object_to_json_value(p_self in json) return json_value;
  function object_path(p_self in json, json_path varchar2, base number default 1) return json_value;

  procedure object_path_put(p_self in out nocopy json, json_path varchar2, elem json_value, base number default 1);
  procedure object_path_put(p_self in out nocopy json, json_path varchar2, elem varchar2  , base number default 1);
  procedure object_path_put(p_self in out nocopy json, json_path varchar2, elem number    , base number default 1);
  procedure object_path_put(p_self in out nocopy json, json_path varchar2, elem boolean   , base number default 1);
  procedure object_path_put(p_self in out nocopy json, json_path varchar2, elem json_list , base number default 1);
  procedure object_path_put(p_self in out nocopy json, json_path varchar2, elem json      , base number default 1);

  procedure object_path_remove(p_self in out nocopy json, json_path varchar2, base number default 1);

  function object_get_values(p_self in json) return json_list;
  function object_get_keys(p_self in json) return json_list;

  --json_list type methods
  procedure array_append(p_self in out nocopy json_list, elem json_value, position pls_integer default null);
  procedure array_append(p_self in out nocopy json_list, elem varchar2, position pls_integer default null);
  procedure array_append(p_self in out nocopy json_list, elem number, position pls_integer default null);
  procedure array_append(p_self in out nocopy json_list, elem boolean, position pls_integer default null);
  procedure array_append(p_self in out nocopy json_list, elem json_list, position pls_integer default null);

  procedure array_replace(p_self in out nocopy json_list, position pls_integer, elem json_value);
  procedure array_replace(p_self in out nocopy json_list, position pls_integer, elem varchar2);
  procedure array_replace(p_self in out nocopy json_list, position pls_integer, elem number);
  procedure array_replace(p_self in out nocopy json_list, position pls_integer, elem boolean);
  procedure array_replace(p_self in out nocopy json_list, position pls_integer, elem json_list);

  function array_count(p_self in json_list) return number;
  procedure array_remove(p_self in out nocopy json_list, position pls_integer);
  procedure array_remove_first(p_self in out nocopy json_list);
  procedure array_remove_last(p_self in out nocopy json_list);
  function array_get(p_self in json_list, position pls_integer) return json_value;
  function array_head(p_self in json_list) return json_value;
  function array_last(p_self in json_list) return json_value;
  function array_tail(p_self in json_list) return json_list;

  function array_to_char(p_self in json_list, spaces boolean default true, chars_per_line number default 0) return varchar2;
  procedure array_to_clob(p_self in json_list, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true);
  procedure array_print(p_self in json_list, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null);
  procedure array_htp(p_self in json_list, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null);

  function array_path(p_self in json_list, json_path varchar2, base number default 1) return json_value;
  procedure array_path_put(p_self in out nocopy json_list, json_path varchar2, elem json_value, base number default 1);
  procedure array_path_put(p_self in out nocopy json_list, json_path varchar2, elem varchar2  , base number default 1);
  procedure array_path_put(p_self in out nocopy json_list, json_path varchar2, elem number    , base number default 1);
  procedure array_path_put(p_self in out nocopy json_list, json_path varchar2, elem boolean   , base number default 1);
  procedure array_path_put(p_self in out nocopy json_list, json_path varchar2, elem json_list , base number default 1);

  procedure array_path_remove(p_self in out nocopy json_list, json_path varchar2, base number default 1);

  function array_to_json_value(p_self in json_list) return json_value;

  --json_value


  function jv_get_type(p_self in json_value) return varchar2;
  function jv_get_string(p_self in json_value, max_byte_size number default null, max_char_size number default null) return varchar2;
  procedure jv_get_string(p_self in json_value, buf in out nocopy clob);
  function jv_get_number(p_self in json_value) return number;
  function jv_get_bool(p_self in json_value) return boolean;
  function jv_get_null(p_self in json_value) return varchar2;

  function jv_is_object(p_self in json_value) return boolean;
  function jv_is_array(p_self in json_value) return boolean;
  function jv_is_string(p_self in json_value) return boolean;
  function jv_is_number(p_self in json_value) return boolean;
  function jv_is_bool(p_self in json_value) return boolean;
  function jv_is_null(p_self in json_value) return boolean;

  function jv_to_char(p_self in json_value, spaces boolean default true, chars_per_line number default 0) return varchar2;
  procedure jv_to_clob(p_self in json_value, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true);
  procedure jv_print(p_self in json_value, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null);
  procedure jv_htp(p_self in json_value, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null);

  function jv_value_of(p_self in json_value, max_byte_size number default null, max_char_size number default null) return varchar2;


end json_ac;
/

----------------------------
--  New package json_dyn  --
----------------------------
create or replace package json_dyn authid current_user as
 /*
  Copyright (c) 2010 Jonas Krogsboell

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  */

  null_as_empty_string   boolean not null := true;  --varchar2
  include_dates          boolean not null := true;  --date
  include_clobs          boolean not null := true;
  include_blobs          boolean not null := false;

  /* list with objects */
  function executeList(stmt varchar2, bindvar json default null, cur_num number default null) return json_list;

  /* object with lists */
  function executeObject(stmt varchar2, bindvar json default null, cur_num number default null) return json;


  /* usage example:
   * declare
   *   res json_list;
   * begin
   *   res := json_dyn.executeList(
   *            'select :bindme as one, :lala as two from dual where dummy in :arraybind',
   *            json('{bindme:"4", lala:123, arraybind:[1,2,3,"X"]}')
   *          );
   *   res.print;
   * end;
   */

/* --11g functions
  function executeList(stmt in out sys_refcursor) return json_list;
  function executeObject(stmt in out sys_refcursor) return json;
*/
end json_dyn;
/

----------------------------
--  New package json_ext  --
----------------------------
create or replace package json_ext as
  /*
  Copyright (c) 2009 Jonas Krogsboell

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  */

  /* This package contains extra methods to lookup types and
     an easy way of adding date values in json - without changing the structure */
  function parsePath(json_path varchar2, base number default 1) return json_list;

  --JSON Path getters
  function get_json_value(obj json, v_path varchar2, base number default 1) return json_value;
  function get_string(obj json, path varchar2,       base number default 1) return varchar2;
  function get_number(obj json, path varchar2,       base number default 1) return number;
  function get_json(obj json, path varchar2,         base number default 1) return json;
  function get_json_list(obj json, path varchar2,    base number default 1) return json_list;
  function get_bool(obj json, path varchar2,         base number default 1) return boolean;

  --JSON Path putters
  procedure put(obj in out nocopy json, path varchar2, elem varchar2,   base number default 1);
  procedure put(obj in out nocopy json, path varchar2, elem number,     base number default 1);
  procedure put(obj in out nocopy json, path varchar2, elem json,       base number default 1);
  procedure put(obj in out nocopy json, path varchar2, elem json_list,  base number default 1);
  procedure put(obj in out nocopy json, path varchar2, elem boolean,    base number default 1);
  procedure put(obj in out nocopy json, path varchar2, elem json_value, base number default 1);

  procedure remove(obj in out nocopy json, path varchar2, base number default 1);

  --Pretty print with JSON Path - obsolete in 0.9.4 - obj.path(v_path).(to_char,print,htp)
  function pp(obj json, v_path varchar2) return varchar2;
  procedure pp(obj json, v_path varchar2); --using dbms_output.put_line
  procedure pp_htp(obj json, v_path varchar2); --using htp.print

  --extra function checks if number has no fraction
  function is_integer(v json_value) return boolean;

  format_string varchar2(30 char) := 'yyyy-mm-dd hh24:mi:ss';
  --extension enables json to store dates without comprimising the implementation
  function to_json_value(d date) return json_value;
  --notice that a date type in json is also a varchar2
  function is_date(v json_value) return boolean;
  --convertion is needed to extract dates
  --(json_ext.to_date will not work along with the normal to_date function - any fix will be appreciated)
  function to_date2(v json_value) return date;
  --JSON Path with date
  function get_date(obj json, path varchar2, base number default 1) return date;
  procedure put(obj in out nocopy json, path varchar2, elem date, base number default 1);

  --experimental support of binary data with base64
  function base64(binarydata blob) return json_list;
  function base64(l json_list) return blob;

  function encode(binarydata blob) return json_value;
  function decode(v json_value) return blob;

end json_ext;
/

-------------------------------
--  New package json_helper  --
-------------------------------
create or replace package json_helper as
  /* Example:
  set serveroutput on;
  declare
    v_a json;
    v_b json;
  begin
    v_a := json('{a:1, b:{a:null}, e:false}');
    v_b := json('{c:3, e:{}, b:{b:2}}');
    json_helper.merge(v_a, v_b).print(false);
  end;
  --
  {"a":1,"b":{"a":null,"b":2},"e":{},"c":3}
  */
  -- Recursive merge
  -- Courtesy of Matt Nolan - edited by Jonas Krogsb縧l
  function merge( p_a_json json, p_b_json json) return json;

  -- Join two lists
  -- json_helper.join(json_list('[1,2,3]'),json_list('[4,5,6]')) -> [1,2,3,4,5,6]
  function join( p_a_list json_list, p_b_list json_list) return json_list;

  -- keep only specific keys in json object
  -- json_helper.keep(json('{a:1,b:2,c:3,d:4,e:5,f:6}'),json_list('["a","f","c"]')) -> {"a":1,"f":6,"c":3}
  function keep( p_json json, p_keys json_list) return json;

  -- remove specific keys in json object
  -- json_helper.remove(json('{a:1,b:2,c:3,d:4,e:5,f:6}'),json_list('["a","f","c"]')) -> {"b":2,"d":4,"e":5}
  function remove( p_json json, p_keys json_list) return json;

  --equals
  function equals(p_v1 json_value, p_v2 json_value, exact boolean default true) return boolean;
  function equals(p_v1 json_value, p_v2 json, exact boolean default true) return boolean;
  function equals(p_v1 json_value, p_v2 json_list, exact boolean default true) return boolean;
  function equals(p_v1 json_value, p_v2 number) return boolean;
  function equals(p_v1 json_value, p_v2 varchar2) return boolean;
  function equals(p_v1 json_value, p_v2 boolean) return boolean;
  function equals(p_v1 json_value, p_v2 clob) return boolean;
  function equals(p_v1 json, p_v2 json, exact boolean default true) return boolean;
  function equals(p_v1 json_list, p_v2 json_list, exact boolean default true) return boolean;

  --contains json, json_value
  --contains json_list, json_value
  function contains(p_v1 json, p_v2 json_value, exact boolean default false) return boolean;
  function contains(p_v1 json, p_v2 json, exact boolean default false) return boolean;
  function contains(p_v1 json, p_v2 json_list, exact boolean default false) return boolean;
  function contains(p_v1 json, p_v2 number, exact boolean default false) return boolean;
  function contains(p_v1 json, p_v2 varchar2, exact boolean default false) return boolean;
  function contains(p_v1 json, p_v2 boolean, exact boolean default false) return boolean;
  function contains(p_v1 json, p_v2 clob, exact boolean default false) return boolean;

  function contains(p_v1 json_list, p_v2 json_value, exact boolean default false) return boolean;
  function contains(p_v1 json_list, p_v2 json, exact boolean default false) return boolean;
  function contains(p_v1 json_list, p_v2 json_list, exact boolean default false) return boolean;
  function contains(p_v1 json_list, p_v2 number, exact boolean default false) return boolean;
  function contains(p_v1 json_list, p_v2 varchar2, exact boolean default false) return boolean;
  function contains(p_v1 json_list, p_v2 boolean, exact boolean default false) return boolean;
  function contains(p_v1 json_list, p_v2 clob, exact boolean default false) return boolean;

end json_helper;
/

---------------------------
--  New package json_ml  --
---------------------------
create or replace package json_ml as
  /*
  Copyright (c) 2010 Jonas Krogsboell

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  */

  /* This package contains extra methods to lookup types and
     an easy way of adding date values in json - without changing the structure */

  jsonml_stylesheet xmltype := null;

  function xml2json(xml in xmltype) return json_list;
  function xmlstr2json(xmlstr in varchar2) return json_list;

end json_ml;
/

-------------------------------
--  New package json_parser  --
-------------------------------
create or replace package json_parser as
  /*
  Copyright (c) 2010 Jonas Krogsboell

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  */
  /* scanner tokens:
    '{', '}', ',', ':', '[', ']', STRING, NUMBER, TRUE, FALSE, NULL
  */
  type rToken IS RECORD (
    type_name VARCHAR2(7),
    line PLS_INTEGER,
    col PLS_INTEGER,
    data VARCHAR2(32767),
    data_overflow clob); -- max_string_size

  type lTokens is table of rToken index by pls_integer;
  type json_src is record (len number, offset number, src varchar2(32767), s_clob clob);

  json_strict boolean not null := false;

  function next_char(indx number, s in out nocopy json_src) return varchar2;
  function next_char2(indx number, s in out nocopy json_src, amount number default 1) return varchar2;

  function prepareClob(buf in clob) return json_parser.json_src;
  function prepareVarchar2(buf in varchar2) return json_parser.json_src;
  function lexer(jsrc in out nocopy json_src) return lTokens;
  procedure print_token(t rToken);

  function parser(str varchar2) return json;
  function parse_list(str varchar2) return json_list;
  function parse_any(str varchar2) return json_value;
  function parser(str clob) return json;
  function parse_list(str clob) return json_list;
  function parse_any(str clob) return json_value;
  procedure remove_duplicates(obj in out nocopy json);
  function get_version return varchar2;

end json_parser;
/

--------------------------------
--  New package json_printer  --
--------------------------------
create or replace package json_printer as
  /*
  Copyright (c) 2010 Jonas Krogsboell

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  */
  indent_string varchar2(10 char) := '  '; --chr(9); for tab
  newline_char varchar2(2 char)   := chr(13)||chr(10); -- Windows style
  --newline_char varchar2(2) := chr(10); -- Mac style
  --newline_char varchar2(2) := chr(13); -- Linux style
  ascii_output boolean    not null := true;
  escape_solidus boolean  not null := false;

  function pretty_print(obj json, spaces boolean default true, line_length number default 0) return varchar2;
  function pretty_print_list(obj json_list, spaces boolean default true, line_length number default 0) return varchar2;
  function pretty_print_any(json_part json_value, spaces boolean default true, line_length number default 0) return varchar2;
  procedure pretty_print(obj json, spaces boolean default true, buf in out nocopy clob, line_length number default 0, erase_clob boolean default true);
  procedure pretty_print_list(obj json_list, spaces boolean default true, buf in out nocopy clob, line_length number default 0, erase_clob boolean default true);
  procedure pretty_print_any(json_part json_value, spaces boolean default true, buf in out nocopy clob, line_length number default 0, erase_clob boolean default true);

  procedure dbms_output_clob(my_clob clob, delim varchar2, jsonp varchar2 default null);
  procedure htp_output_clob(my_clob clob, jsonp varchar2 default null);
end json_printer;
/

---------------------------------
--  New package json_util_pkg  --
---------------------------------
create or replace package json_util_pkg authid current_user as

  /*

  Purpose:    JSON utilities for PL/SQL
  see http://ora-00001.blogspot.com/

  Remarks:

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     30.01.2010  Created
  JKR     01.05.2010  Edited to fit in PL/JSON
  JKR     19.01.2011  Newest stylesheet + bugfix handling

  */

  -- generate JSON from REF Cursor
  function ref_cursor_to_json (p_ref_cursor in sys_refcursor,
                               p_max_rows in number := null,
                               p_skip_rows in number := null) return json_list;

  -- generate JSON from SQL statement
  function sql_to_json (p_sql in varchar2,
                        p_max_rows in number := null,
                        p_skip_rows in number := null) return json_list;


end json_util_pkg;
/

----------------------------
--  New package json_xml  --
----------------------------
create or replace package json_xml as
  /*
  Copyright (c) 2010 Jonas Krogsboell

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  */

  /*
  declare
    obj json := json('{a:1,b:[2,3,4],c:true}');
    x xmltype;
  begin
    obj.print;
    x := json_xml.json_to_xml(obj);
    dbms_output.put_line(x.getclobval());
  end;
  */

  function json_to_xml(obj json, tagname varchar2 default 'root') return xmltype;

end json_xml;
/

--------------------------------
--  New package body json_ac  --
--------------------------------
create or replace package body json_ac as
  procedure object_remove(p_self in out nocopy json, pair_name varchar2) as
  begin p_self.remove(pair_name); end;
  procedure object_put(p_self in out nocopy json, pair_name varchar2, pair_value json_value, position pls_integer default null) as
  begin p_self.put(pair_name, pair_value, position); end;
  procedure object_put(p_self in out nocopy json, pair_name varchar2, pair_value varchar2, position pls_integer default null) as
  begin p_self.put(pair_name, pair_value, position); end;
  procedure object_put(p_self in out nocopy json, pair_name varchar2, pair_value number, position pls_integer default null) as
  begin p_self.put(pair_name, pair_value, position); end;
  procedure object_put(p_self in out nocopy json, pair_name varchar2, pair_value boolean, position pls_integer default null) as
  begin p_self.put(pair_name, pair_value, position); end;
  procedure object_check_duplicate(p_self in out nocopy json, v_set boolean) as
  begin p_self.check_duplicate(v_set); end;
  procedure object_remove_duplicates(p_self in out nocopy json) as
  begin p_self.remove_duplicates; end;

  procedure object_put(p_self in out nocopy json, pair_name varchar2, pair_value json, position pls_integer default null) as
  begin p_self.put(pair_name, pair_value, position); end;
  procedure object_put(p_self in out nocopy json, pair_name varchar2, pair_value json_list, position pls_integer default null) as
  begin p_self.put(pair_name, pair_value, position); end;

  function object_count(p_self in json) return number as
  begin return p_self.count; end;
  function object_get(p_self in json, pair_name varchar2) return json_value as
  begin return p_self.get(pair_name); end;
  function object_get(p_self in json, position pls_integer) return json_value as
  begin return p_self.get(position); end;
  function object_index_of(p_self in json, pair_name varchar2) return number as
  begin return p_self.index_of(pair_name); end;
  function object_exist(p_self in json, pair_name varchar2) return boolean as
  begin return p_self.exist(pair_name); end;

  function object_to_char(p_self in json, spaces boolean default true, chars_per_line number default 0) return varchar2 as
  begin return p_self.to_char(spaces, chars_per_line); end;
  procedure object_to_clob(p_self in json, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true) as
  begin p_self.to_clob(buf, spaces, chars_per_line, erase_clob); end;
  procedure object_print(p_self in json, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null) as
  begin p_self.print(spaces, chars_per_line, jsonp); end;
  procedure object_htp(p_self in json, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null) as
  begin p_self.htp(spaces, chars_per_line, jsonp); end;

  function object_to_json_value(p_self in json) return json_value as
  begin return p_self.to_json_value; end;
  function object_path(p_self in json, json_path varchar2, base number default 1) return json_value as
  begin return p_self.path(json_path, base); end;

  procedure object_path_put(p_self in out nocopy json, json_path varchar2, elem json_value, base number default 1) as
  begin p_self.path_put(json_path, elem, base); end;
  procedure object_path_put(p_self in out nocopy json, json_path varchar2, elem varchar2  , base number default 1) as
  begin p_self.path_put(json_path, elem, base); end;
  procedure object_path_put(p_self in out nocopy json, json_path varchar2, elem number    , base number default 1) as
  begin p_self.path_put(json_path, elem, base); end;
  procedure object_path_put(p_self in out nocopy json, json_path varchar2, elem boolean   , base number default 1) as
  begin p_self.path_put(json_path, elem, base); end;
  procedure object_path_put(p_self in out nocopy json, json_path varchar2, elem json_list , base number default 1) as
  begin p_self.path_put(json_path, elem, base); end;
  procedure object_path_put(p_self in out nocopy json, json_path varchar2, elem json      , base number default 1) as
  begin p_self.path_put(json_path, elem, base); end;

  procedure object_path_remove(p_self in out nocopy json, json_path varchar2, base number default 1) as
  begin p_self.path_remove(json_path, base); end;

  function object_get_values(p_self in json) return json_list as
  begin return p_self.get_values; end;
  function object_get_keys(p_self in json) return json_list as
  begin return p_self.get_keys; end;

  --json_list type
  procedure array_append(p_self in out nocopy json_list, elem json_value, position pls_integer default null) as
  begin p_self.append(elem, position); end;
  procedure array_append(p_self in out nocopy json_list, elem varchar2, position pls_integer default null) as
  begin p_self.append(elem, position); end;
  procedure array_append(p_self in out nocopy json_list, elem number, position pls_integer default null) as
  begin p_self.append(elem, position); end;
  procedure array_append(p_self in out nocopy json_list, elem boolean, position pls_integer default null) as
  begin p_self.append(elem, position); end;
  procedure array_append(p_self in out nocopy json_list, elem json_list, position pls_integer default null) as
  begin p_self.append(elem, position); end;

  procedure array_replace(p_self in out nocopy json_list, position pls_integer, elem json_value) as
  begin p_self.replace(position, elem); end;
  procedure array_replace(p_self in out nocopy json_list, position pls_integer, elem varchar2) as
  begin p_self.replace(position, elem); end;
  procedure array_replace(p_self in out nocopy json_list, position pls_integer, elem number) as
  begin p_self.replace(position, elem); end;
  procedure array_replace(p_self in out nocopy json_list, position pls_integer, elem boolean) as
  begin p_self.replace(position, elem); end;
  procedure array_replace(p_self in out nocopy json_list, position pls_integer, elem json_list) as
  begin p_self.replace(position, elem); end;

  function array_count(p_self in json_list) return number as
  begin return p_self.count; end;
  procedure array_remove(p_self in out nocopy json_list, position pls_integer) as
  begin p_self.remove(position); end;
  procedure array_remove_first(p_self in out nocopy json_list) as
  begin p_self.remove_first; end;
  procedure array_remove_last(p_self in out nocopy json_list) as
  begin p_self.remove_last; end;
  function array_get(p_self in json_list, position pls_integer) return json_value as
  begin return p_self.get(position); end;
  function array_head(p_self in json_list) return json_value as
  begin return p_self.head; end;
  function array_last(p_self in json_list) return json_value as
  begin return p_self.last; end;
  function array_tail(p_self in json_list) return json_list as
  begin return p_self.tail; end;

  function array_to_char(p_self in json_list, spaces boolean default true, chars_per_line number default 0) return varchar2 as
  begin return p_self.to_char(spaces, chars_per_line); end;
  procedure array_to_clob(p_self in json_list, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true) as
  begin p_self.to_clob(buf, spaces, chars_per_line, erase_clob); end;
  procedure array_print(p_self in json_list, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null) as
  begin p_self.print(spaces, chars_per_line, jsonp); end;
  procedure array_htp(p_self in json_list, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null) as
  begin p_self.htp(spaces, chars_per_line, jsonp); end;

  function array_path(p_self in json_list, json_path varchar2, base number default 1) return json_value as
  begin return p_self.path(json_path, base); end;
  procedure array_path_put(p_self in out nocopy json_list, json_path varchar2, elem json_value, base number default 1) as
  begin p_self.path_put(json_path, elem, base); end;
  procedure array_path_put(p_self in out nocopy json_list, json_path varchar2, elem varchar2  , base number default 1) as
  begin p_self.path_put(json_path, elem, base); end;
  procedure array_path_put(p_self in out nocopy json_list, json_path varchar2, elem number    , base number default 1) as
  begin p_self.path_put(json_path, elem, base); end;
  procedure array_path_put(p_self in out nocopy json_list, json_path varchar2, elem boolean   , base number default 1) as
  begin p_self.path_put(json_path, elem, base); end;
  procedure array_path_put(p_self in out nocopy json_list, json_path varchar2, elem json_list , base number default 1) as
  begin p_self.path_put(json_path, elem, base); end;

  procedure array_path_remove(p_self in out nocopy json_list, json_path varchar2, base number default 1) as
  begin p_self.path_remove(json_path, base); end;

  function array_to_json_value(p_self in json_list) return json_value as
  begin return p_self.to_json_value; end;

  --json_value


  function jv_get_type(p_self in json_value) return varchar2 as
  begin return p_self.get_type; end;
  function jv_get_string(p_self in json_value, max_byte_size number default null, max_char_size number default null) return varchar2 as
  begin return p_self.get_string(max_byte_size, max_char_size); end;
  procedure jv_get_string(p_self in json_value, buf in out nocopy clob) as
  begin p_self.get_string(buf); end;
  function jv_get_number(p_self in json_value) return number as
  begin return p_self.get_number; end;
  function jv_get_bool(p_self in json_value) return boolean as
  begin return p_self.get_bool; end;
  function jv_get_null(p_self in json_value) return varchar2 as
  begin return p_self.get_null; end;

  function jv_is_object(p_self in json_value) return boolean as
  begin return p_self.is_object; end;
  function jv_is_array(p_self in json_value) return boolean as
  begin return p_self.is_array; end;
  function jv_is_string(p_self in json_value) return boolean as
  begin return p_self.is_string; end;
  function jv_is_number(p_self in json_value) return boolean as
  begin return p_self.is_number; end;
  function jv_is_bool(p_self in json_value) return boolean as
  begin return p_self.is_bool; end;
  function jv_is_null(p_self in json_value) return boolean as
  begin return p_self.is_null; end;

  function jv_to_char(p_self in json_value, spaces boolean default true, chars_per_line number default 0) return varchar2 as
  begin return p_self.to_char(spaces, chars_per_line); end;
  procedure jv_to_clob(p_self in json_value, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true) as
  begin p_self.to_clob(buf, spaces, chars_per_line, erase_clob); end;
  procedure jv_print(p_self in json_value, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null) as
  begin p_self.print(spaces, chars_per_line, jsonp); end;
  procedure jv_htp(p_self in json_value, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null) as
  begin p_self.htp(spaces, chars_per_line, jsonp); end;

  function jv_value_of(p_self in json_value, max_byte_size number default null, max_char_size number default null) return varchar2 as
  begin return p_self.value_of(max_byte_size, max_char_size); end;

end json_ac;
/

---------------------------------
--  New package body json_dyn  --
---------------------------------
create or replace package body json_dyn as
/*
  -- 11gR2
  function executeList(stmt in out sys_refcursor) return json_list as
    l_cur number;
  begin
    l_cur := dbms_sql.to_cursor_number(stmt);
    return json_dyn.executeList(null, null, l_cur);
  end;

  -- 11gR2
  function executeObject(stmt in out sys_refcursor) return json as
    l_cur number;
  begin
    l_cur := dbms_sql.to_cursor_number(stmt);
    return json_dyn.executeObject(null, null, l_cur);
  end;
*/

  procedure bind_json(l_cur number, bindvar json) as
    keylist json_list := bindvar.get_keys();
  begin
    for i in 1 .. keylist.count loop
      if(bindvar.get(i).get_type = 'number') then
        dbms_sql.bind_variable(l_cur, ':'||keylist.get(i).get_string, bindvar.get(i).get_number);
      elsif(bindvar.get(i).get_type = 'array') then
        declare
          v_bind dbms_sql.varchar2_table;
          v_arr  json_list := json_list(bindvar.get(i));
        begin
          for j in 1 .. v_arr.count loop
            v_bind(j) := v_arr.get(j).value_of;
          end loop;
          dbms_sql.bind_array(l_cur, ':'||keylist.get(i).get_string, v_bind);
        end;
      else
        dbms_sql.bind_variable(l_cur, ':'||keylist.get(i).get_string, bindvar.get(i).value_of());
      end if;
    end loop;
  end bind_json;

  /* list with objects */
  function executeList(stmt varchar2, bindvar json, cur_num number) return json_list as
    l_cur number;
    l_dtbl dbms_sql.desc_tab;
    l_cnt number;
    l_status number;
    l_val varchar2(4000);
    outer_list json_list := json_list();
    inner_obj json;
    conv number;
    read_date date;
    read_clob clob;
    read_blob blob;
    col_type number;
  begin
    if(cur_num is not null) then
      l_cur := cur_num;
    else
      l_cur := dbms_sql.open_cursor;
      dbms_sql.parse(l_cur, stmt, dbms_sql.native);
      if(bindvar is not null) then bind_json(l_cur, bindvar); end if;
    end if;
    dbms_sql.describe_columns(l_cur, l_cnt, l_dtbl);
    for i in 1..l_cnt loop
      col_type := l_dtbl(i).col_type;
      --dbms_output.put_line(col_type);
      if(col_type = 12) then
        dbms_sql.define_column(l_cur,i,read_date);
      elsif(col_type = 112) then
        dbms_sql.define_column(l_cur,i,read_clob);
      elsif(col_type = 113) then
        dbms_sql.define_column(l_cur,i,read_blob);
      elsif(col_type in (1,2,96)) then
        dbms_sql.define_column(l_cur,i,l_val,4000);
      end if;
    end loop;

    if(cur_num is null) then l_status := dbms_sql.execute(l_cur); end if;

    --loop through rows
    while ( dbms_sql.fetch_rows(l_cur) > 0 ) loop
      inner_obj := json(); --init for each row
      --loop through columns
      for i in 1..l_cnt loop
        case true
        --handling string types
        when l_dtbl(i).col_type in (1,96) then -- varchar2
          dbms_sql.column_value(l_cur,i,l_val);
          if(l_val is null) then
            if(null_as_empty_string) then
              inner_obj.put(l_dtbl(i).col_name, ''); --treatet as emptystring?
            else
              inner_obj.put(l_dtbl(i).col_name, json_value.makenull); --null
            end if;
          else
            inner_obj.put(l_dtbl(i).col_name, json_value(l_val)); --null
          end if;
          --dbms_output.put_line(l_dtbl(i).col_name||' --> '||l_val||'varchar2' ||l_dtbl(i).col_type);
        --handling number types
        when l_dtbl(i).col_type = 2 then -- number
          dbms_sql.column_value(l_cur,i,l_val);
          conv := l_val;
          inner_obj.put(l_dtbl(i).col_name, conv);
          -- dbms_output.put_line(l_dtbl(i).col_name||' --> '||l_val||'number ' ||l_dtbl(i).col_type);
        when l_dtbl(i).col_type = 12 then -- date
          if(include_dates) then
            dbms_sql.column_value(l_cur,i,read_date);
            inner_obj.put(l_dtbl(i).col_name, json_ext.to_json_value(read_date));
          end if;
          --dbms_output.put_line(l_dtbl(i).col_name||' --> '||l_val||'date ' ||l_dtbl(i).col_type);
        when l_dtbl(i).col_type = 112 then --clob
          if(include_clobs) then
            dbms_sql.column_value(l_cur,i,read_clob);
            inner_obj.put(l_dtbl(i).col_name, json_value(read_clob));
          end if;
        when l_dtbl(i).col_type = 113 then --blob
          if(include_blobs) then
            dbms_sql.column_value(l_cur,i,read_blob);
            if(dbms_lob.getlength(read_blob) > 0) then
              inner_obj.put(l_dtbl(i).col_name, json_ext.encode(read_blob));
            else
              inner_obj.put(l_dtbl(i).col_name, json_value.makenull);
            end if;
          end if;

        else null; --discard other types
        end case;
      end loop;
      outer_list.append(inner_obj.to_json_value);
    end loop;
    dbms_sql.close_cursor(l_cur);
    return outer_list;
  end executeList;

  /* object with lists */
  function executeObject(stmt varchar2, bindvar json, cur_num number) return json as
    l_cur number;
    l_dtbl dbms_sql.desc_tab;
    l_cnt number;
    l_status number;
    l_val varchar2(4000);
    inner_list_names json_list := json_list();
    inner_list_data json_list := json_list();
    data_list json_list;
    outer_obj json := json();
    conv number;
    read_date date;
    read_clob clob;
    read_blob blob;
    col_type number;
  begin
    if(cur_num is not null) then
      l_cur := cur_num;
    else
      l_cur := dbms_sql.open_cursor;
      dbms_sql.parse(l_cur, stmt, dbms_sql.native);
      if(bindvar is not null) then bind_json(l_cur, bindvar); end if;
    end if;
    dbms_sql.describe_columns(l_cur, l_cnt, l_dtbl);
    for i in 1..l_cnt loop
      col_type := l_dtbl(i).col_type;
      if(col_type = 12) then
        dbms_sql.define_column(l_cur,i,read_date);
      elsif(col_type = 112) then
        dbms_sql.define_column(l_cur,i,read_clob);
      elsif(col_type = 113) then
        dbms_sql.define_column(l_cur,i,read_blob);
      elsif(col_type in (1,2,96)) then
        dbms_sql.define_column(l_cur,i,l_val,4000);
      end if;
    end loop;
    if(cur_num is null) then l_status := dbms_sql.execute(l_cur); end if;

    --build up name_list
    for i in 1..l_cnt loop
      case l_dtbl(i).col_type
        when 1 then inner_list_names.append(l_dtbl(i).col_name);
        when 96 then inner_list_names.append(l_dtbl(i).col_name);
        when 2 then inner_list_names.append(l_dtbl(i).col_name);
        when 12 then if(include_dates) then inner_list_names.append(l_dtbl(i).col_name); end if;
        when 112 then if(include_clobs) then inner_list_names.append(l_dtbl(i).col_name); end if;
        when 113 then if(include_blobs) then inner_list_names.append(l_dtbl(i).col_name); end if;
        else null;
      end case;
    end loop;

    --loop through rows
    while ( dbms_sql.fetch_rows(l_cur) > 0 ) loop
      data_list := json_list();
      --loop through columns
      for i in 1..l_cnt loop
        case true
        --handling string types
        when l_dtbl(i).col_type in (1,96) then -- varchar2
          dbms_sql.column_value(l_cur,i,l_val);
          if(l_val is null) then
            if(null_as_empty_string) then
              data_list.append(''); --treatet as emptystring?
            else
              data_list.append(json_value.makenull); --null
            end if;
          else
            data_list.append(json_value(l_val)); --null
          end if;
          --dbms_output.put_line(l_dtbl(i).col_name||' --> '||l_val||'varchar2' ||l_dtbl(i).col_type);
        --handling number types
        when l_dtbl(i).col_type = 2 then -- number
          dbms_sql.column_value(l_cur,i,l_val);
          conv := l_val;
          data_list.append(conv);
          -- dbms_output.put_line(l_dtbl(i).col_name||' --> '||l_val||'number ' ||l_dtbl(i).col_type);
        when l_dtbl(i).col_type = 12 then -- date
          if(include_dates) then
            dbms_sql.column_value(l_cur,i,read_date);
            data_list.append(json_ext.to_json_value(read_date));
          end if;
          --dbms_output.put_line(l_dtbl(i).col_name||' --> '||l_val||'date ' ||l_dtbl(i).col_type);
        when l_dtbl(i).col_type = 112 then --clob
          if(include_clobs) then
            dbms_sql.column_value(l_cur,i,read_clob);
            data_list.append(json_value(read_clob));
          end if;
        when l_dtbl(i).col_type = 113 then --blob
          if(include_blobs) then
            dbms_sql.column_value(l_cur,i,read_blob);
            if(dbms_lob.getlength(read_blob) > 0) then
              data_list.append(json_ext.encode(read_blob));
            else
              data_list.append(json_value.makenull);
            end if;
          end if;
        else null; --discard other types
        end case;
      end loop;
      inner_list_data.append(data_list);
    end loop;

    outer_obj.put('names', inner_list_names.to_json_value);
    outer_obj.put('data', inner_list_data.to_json_value);
    dbms_sql.close_cursor(l_cur);
    return outer_obj;
  end executeObject;

end json_dyn;
/

---------------------------------
--  New package body json_ext  --
---------------------------------
create or replace package body json_ext as
  scanner_exception exception;
  pragma exception_init(scanner_exception, -20100);
  parser_exception exception;
  pragma exception_init(parser_exception, -20101);
  jext_exception exception;
  pragma exception_init(jext_exception, -20110);

  --extra function checks if number has no fraction
  function is_integer(v json_value) return boolean as
    myint number(38); --the oracle way to specify an integer
  begin
    if(v.is_number) then
      myint := v.get_number;
      return (myint = v.get_number); --no rounding errors?
    else
      return false;
    end if;
  end;

  --extension enables json to store dates without comprimising the implementation
  function to_json_value(d date) return json_value as
  begin
    return json_value(to_char(d, format_string));
  end;

  --notice that a date type in json is also a varchar2
  function is_date(v json_value) return boolean as
    temp date;
  begin
    temp := json_ext.to_date2(v);
    return true;
  exception
    when others then
      return false;
  end;

  --convertion is needed to extract dates
  function to_date2(v json_value) return date as
  begin
    if(v.is_string) then
      return to_date(v.get_string, format_string);
    else
      raise_application_error(-20110, 'Anydata did not contain a date-value');
    end if;
  exception
    when others then
      raise_application_error(-20110, 'Anydata did not contain a date on the format: '||format_string);
  end;

  --Json Path parser
  function parsePath(json_path varchar2, base number default 1) return json_list as
    build_path varchar2(32767) := '[';
    buf varchar2(4);
    endstring varchar2(1);
    indx number := 1;
    ret json_list;

    procedure next_char as
    begin
      if(indx <= length(json_path)) then
        buf := substr(json_path, indx, 1);
        indx := indx + 1;
      else
        buf := null;
      end if;
    end;
    --skip ws
    procedure skipws as begin while(buf in (chr(9),chr(10),chr(13),' ')) loop next_char; end loop; end;

  begin
    next_char();
    while(buf is not null) loop
      if(buf = '.') then
        next_char();
        if(buf is null) then raise_application_error(-20110, 'JSON Path parse error: . is not a valid json_path end'); end if;
        if(not regexp_like(buf, '^[[:alnum:]\_ ]+', 'c') ) then
          raise_application_error(-20110, 'JSON Path parse error: alpha-numeric character or space expected at position '||indx);
        end if;

        if(build_path != '[') then build_path := build_path || ','; end if;
        build_path := build_path || '"';
        while(regexp_like(buf, '^[[:alnum:]\_ ]+', 'c') ) loop
          build_path := build_path || buf;
          next_char();
        end loop;
        build_path := build_path || '"';
      elsif(buf = '[') then
        next_char();
        skipws();
        if(buf is null) then raise_application_error(-20110, 'JSON Path parse error: [ is not a valid json_path end'); end if;
        if(buf in ('1','2','3','4','5','6','7','8','9') or (buf = '0' and base = 0)) then
          if(build_path != '[') then build_path := build_path || ','; end if;
          while(buf in ('0','1','2','3','4','5','6','7','8','9')) loop
            build_path := build_path || buf;
            next_char();
          end loop;
        elsif (regexp_like(buf, '^(\"|\'')', 'c')) then
          endstring := buf;
          if(build_path != '[') then build_path := build_path || ','; end if;
          build_path := build_path || '"';
          next_char();
          if(buf is null) then raise_application_error(-20110, 'JSON Path parse error: premature json_path end'); end if;
          while(buf != endstring) loop
            build_path := build_path || buf;
            next_char();
            if(buf is null) then raise_application_error(-20110, 'JSON Path parse error: premature json_path end'); end if;
            if(buf = '\') then
              next_char();
              build_path := build_path || '\' || buf;
              next_char();
            end if;
          end loop;
          build_path := build_path || '"';
          next_char();
        else
          raise_application_error(-20110, 'JSON Path parse error: expected a string or an positive integer at '||indx);
        end if;
        skipws();
        if(buf is null) then raise_application_error(-20110, 'JSON Path parse error: premature json_path end'); end if;
        if(buf != ']') then raise_application_error(-20110, 'JSON Path parse error: no array ending found. found: '|| buf); end if;
        next_char();
        skipws();
      elsif(build_path = '[') then
        if(not regexp_like(buf, '^[[:alnum:]\_ ]+', 'c') ) then
          raise_application_error(-20110, 'JSON Path parse error: alpha-numeric character or space expected at position '||indx);
        end if;
        build_path := build_path || '"';
        while(regexp_like(buf, '^[[:alnum:]\_ ]+', 'c') ) loop
          build_path := build_path || buf;
          next_char();
        end loop;
        build_path := build_path || '"';
      else
        raise_application_error(-20110, 'JSON Path parse error: expected . or [ found '|| buf || ' at position '|| indx);
      end if;

    end loop;

    build_path := build_path || ']';
    build_path := replace(replace(replace(replace(replace(build_path, chr(9), '\t'), chr(10), '\n'), chr(13), '\f'), chr(8), '\b'), chr(14), '\r');

    ret := json_list(build_path);
    if(base != 1) then
      --fix base 0 to base 1
      declare
        elem json_value;
      begin
        for i in 1 .. ret.count loop
          elem := ret.get(i);
          if(elem.is_number) then
            ret.replace(i,elem.get_number()+1);
          end if;
        end loop;
      end;
    end if;

    return ret;
  end parsePath;

  --JSON Path getters
  function get_json_value(obj json, v_path varchar2, base number default 1) return json_value as
    path json_list;
    ret json_value;
    o json; l json_list;
  begin
    path := parsePath(v_path, base);
    ret := obj.to_json_value;
    if(path.count = 0) then return ret; end if;

    for i in 1 .. path.count loop
      if(path.get(i).is_string()) then
        --string fetch only on json
        o := json(ret);
        ret := o.get(path.get(i).get_string());
      else
        --number fetch on json and json_list
        if(ret.is_array()) then
          l := json_list(ret);
          ret := l.get(path.get(i).get_number());
        else
          o := json(ret);
          l := o.get_values();
          ret := l.get(path.get(i).get_number());
        end if;
      end if;
    end loop;

    return ret;
  exception
    when scanner_exception then raise;
    when parser_exception then raise;
    when jext_exception then raise;
    when others then return null;
  end get_json_value;

  --JSON Path getters
  function get_string(obj json, path varchar2, base number default 1) return varchar2 as
    temp json_value;
  begin
    temp := get_json_value(obj, path, base);
    if(temp is null or not temp.is_string) then
      return null;
    else
      return temp.get_string;
    end if;
  end;

  function get_number(obj json, path varchar2, base number default 1) return number as
    temp json_value;
  begin
    temp := get_json_value(obj, path, base);
    if(temp is null or not temp.is_number) then
      return null;
    else
      return temp.get_number;
    end if;
  end;

  function get_json(obj json, path varchar2, base number default 1) return json as
    temp json_value;
  begin
    temp := get_json_value(obj, path, base);
    if(temp is null or not temp.is_object) then
      return null;
    else
      return json(temp);
    end if;
  end;

  function get_json_list(obj json, path varchar2, base number default 1) return json_list as
    temp json_value;
  begin
    temp := get_json_value(obj, path, base);
    if(temp is null or not temp.is_array) then
      return null;
    else
      return json_list(temp);
    end if;
  end;

  function get_bool(obj json, path varchar2, base number default 1) return boolean as
    temp json_value;
  begin
    temp := get_json_value(obj, path, base);
    if(temp is null or not temp.is_bool) then
      return null;
    else
      return temp.get_bool;
    end if;
  end;

  function get_date(obj json, path varchar2, base number default 1) return date as
    temp json_value;
  begin
    temp := get_json_value(obj, path, base);
    if(temp is null or not is_date(temp)) then
      return null;
    else
      return json_ext.to_date2(temp);
    end if;
  end;

  /* JSON Path putter internal function */
  procedure put_internal(obj in out nocopy json, v_path varchar2, elem json_value, base number) as
    val json_value := elem;
    path json_list;
    backreference json_list := json_list();

    keyval json_value; keynum number; keystring varchar2(4000);
    temp json_value := obj.to_json_value;
    obj_temp  json;
    list_temp json_list;
    inserter json_value;
  begin
    path := json_ext.parsePath(v_path, base);
    if(path.count = 0) then raise_application_error(-20110, 'JSON_EXT put error: cannot put with empty string.'); end if;

    --build backreference
    for i in 1 .. path.count loop
      --backreference.print(false);
      keyval := path.get(i);
      if (keyval.is_number()) then
        --nummer index
        keynum := keyval.get_number();
        if((not temp.is_object()) and (not temp.is_array())) then
          if(val is null) then return; end if;
          backreference.remove_last;
          temp := json_list().to_json_value();
          backreference.append(temp);
        end if;

        if(temp.is_object()) then
          obj_temp := json(temp);
          if(obj_temp.count < keynum) then
            if(val is null) then return; end if;
            raise_application_error(-20110, 'JSON_EXT put error: access object with to few members.');
          end if;
          temp := obj_temp.get(keynum);
        else
          list_temp := json_list(temp);
          if(list_temp.count < keynum) then
            if(val is null) then return; end if;
            --raise error or quit if val is null
            for i in list_temp.count+1 .. keynum loop
              list_temp.append(json_value.makenull);
            end loop;
            backreference.remove_last;
            backreference.append(list_temp);
          end if;

          temp := list_temp.get(keynum);
        end if;
      else
        --streng index
        keystring := keyval.get_string();
        if(not temp.is_object()) then
          --backreference.print;
          if(val is null) then return; end if;
          backreference.remove_last;
          temp := json().to_json_value();
          backreference.append(temp);
          --raise_application_error(-20110, 'JSON_ext put error: trying to access a non object with a string.');
        end if;
        obj_temp := json(temp);
        temp := obj_temp.get(keystring);
      end if;

      if(temp is null) then
        if(val is null) then return; end if;
        --what to expect?
        keyval := path.get(i+1);
        if(keyval is not null and keyval.is_number()) then
          temp := json_list().to_json_value;
        else
          temp := json().to_json_value;
        end if;
      end if;
      backreference.append(temp);
    end loop;

  --  backreference.print(false);
  --  path.print(false);

    --use backreference and path together
    inserter := val;
    for i in reverse 1 .. backreference.count loop
  --    inserter.print(false);
      if( i = 1 ) then
        keyval := path.get(1);
        if(keyval.is_string()) then
          keystring := keyval.get_string();
        else
          keynum := keyval.get_number();
          declare
            t1 json_value := obj.get(keynum);
          begin
            keystring := t1.mapname;
          end;
        end if;
        if(inserter is null) then obj.remove(keystring); else obj.put(keystring, inserter); end if;
      else
        temp := backreference.get(i-1);
        if(temp.is_object()) then
          keyval := path.get(i);
          obj_temp := json(temp);
          if(keyval.is_string()) then
            keystring := keyval.get_string();
          else
            keynum := keyval.get_number();
            declare
              t1 json_value := obj_temp.get(keynum);
            begin
              keystring := t1.mapname;
            end;
          end if;
          if(inserter is null) then
            obj_temp.remove(keystring);
            if(obj_temp.count > 0) then inserter := obj_temp.to_json_value; end if;
          else
            obj_temp.put(keystring, inserter);
            inserter := obj_temp.to_json_value;
          end if;
        else
          --array only number
          keynum := path.get(i).get_number();
          list_temp := json_list(temp);
          list_temp.remove(keynum);
          if(not inserter is null) then
            list_temp.append(inserter, keynum);
            inserter := list_temp.to_json_value;
          else
            if(list_temp.count > 0) then inserter := list_temp.to_json_value; end if;
          end if;
        end if;
      end if;

    end loop;

  end put_internal;

  /* JSON Path putters */
  procedure put(obj in out nocopy json, path varchar2, elem varchar2, base number default 1) as
  begin
    put_internal(obj, path, json_value(elem), base);
  end;

  procedure put(obj in out nocopy json, path varchar2, elem number, base number default 1) as
  begin
    if(elem is null) then raise_application_error(-20110, 'Cannot put null-value'); end if;
    put_internal(obj, path, json_value(elem), base);
  end;

  procedure put(obj in out nocopy json, path varchar2, elem json, base number default 1) as
  begin
    if(elem is null) then raise_application_error(-20110, 'Cannot put null-value'); end if;
    put_internal(obj, path, elem.to_json_value, base);
  end;

  procedure put(obj in out nocopy json, path varchar2, elem json_list, base number default 1) as
  begin
    if(elem is null) then raise_application_error(-20110, 'Cannot put null-value'); end if;
    put_internal(obj, path, elem.to_json_value, base);
  end;

  procedure put(obj in out nocopy json, path varchar2, elem boolean, base number default 1) as
  begin
    if(elem is null) then raise_application_error(-20110, 'Cannot put null-value'); end if;
    put_internal(obj, path, json_value(elem), base);
  end;

  procedure put(obj in out nocopy json, path varchar2, elem json_value, base number default 1) as
  begin
    if(elem is null) then raise_application_error(-20110, 'Cannot put null-value'); end if;
    put_internal(obj, path, elem, base);
  end;

  procedure put(obj in out nocopy json, path varchar2, elem date, base number default 1) as
  begin
    if(elem is null) then raise_application_error(-20110, 'Cannot put null-value'); end if;
    put_internal(obj, path, json_ext.to_json_value(elem), base);
  end;

  procedure remove(obj in out nocopy json, path varchar2, base number default 1) as
  begin
    json_ext.put_internal(obj,path,null,base);
--    if(json_ext.get_json_value(obj,path) is not null) then
--    end if;
  end remove;

    --Pretty print with JSON Path
  function pp(obj json, v_path varchar2) return varchar2 as
    json_part json_value;
  begin
    json_part := json_ext.get_json_value(obj, v_path);
    if(json_part is null) then
      return '';
    else
      return json_printer.pretty_print_any(json_part); --escapes a possible internal string
    end if;
  end pp;

  procedure pp(obj json, v_path varchar2) as --using dbms_output.put_line
  begin
    dbms_output.put_line(pp(obj, v_path));
  end pp;

  -- spaces = false!
  procedure pp_htp(obj json, v_path varchar2) as --using htp.print
    json_part json_value;
  begin
    json_part := json_ext.get_json_value(obj, v_path);
    if(json_part is null) then htp.print; else
      htp.print(json_printer.pretty_print_any(json_part, false));
    end if;
  end pp_htp;

  function base64(binarydata blob) return json_list as
    obj json_list := json_list();
    c clob := empty_clob();
    benc blob;

    v_blob_offset NUMBER := 1;
    v_clob_offset NUMBER := 1;
    v_lang_context NUMBER := DBMS_LOB.DEFAULT_LANG_CTX;
    v_warning NUMBER;
    v_amount PLS_INTEGER;
--    temp varchar2(32767);

    FUNCTION encodeBlob2Base64(pBlobIn IN BLOB) RETURN BLOB IS
      vAmount NUMBER := 45;
      vBlobEnc BLOB := empty_blob();
      vBlobEncLen NUMBER := 0;
      vBlobInLen NUMBER := 0;
      vBuffer RAW(45);
      vOffset NUMBER := 1;
    BEGIN
--      dbms_output.put_line('Start base64 encoding.');
      vBlobInLen := dbms_lob.getlength(pBlobIn);
--      dbms_output.put_line('<BlobInLength>' || vBlobInLen);
      dbms_lob.createtemporary(vBlobEnc, TRUE);
      LOOP
        IF vOffset >= vBlobInLen THEN
          EXIT;
        END IF;
        dbms_lob.read(pBlobIn, vAmount, vOffset, vBuffer);
        BEGIN
          dbms_lob.append(vBlobEnc, utl_encode.base64_encode(vBuffer));
        EXCEPTION
          WHEN OTHERS THEN
          dbms_output.put_line('<vAmount>' || vAmount || '<vOffset>' || vOffset || '<vBuffer>' || vBuffer);
          dbms_output.put_line('ERROR IN append: ' || SQLERRM);
          RAISE;
        END;
        vOffset := vOffset + vAmount;
      END LOOP;
      vBlobEncLen := dbms_lob.getlength(vBlobEnc);
--      dbms_output.put_line('<BlobEncLength>' || vBlobEncLen);
--      dbms_output.put_line('Finshed base64 encoding.');
      RETURN vBlobEnc;
    END encodeBlob2Base64;
  begin
    benc := encodeBlob2Base64(binarydata);
    dbms_lob.createtemporary(c, TRUE);
    v_amount := DBMS_LOB.GETLENGTH(benc);
    DBMS_LOB.CONVERTTOCLOB(c, benc, v_amount, v_clob_offset, v_blob_offset, 1, v_lang_context, v_warning);

    v_amount := DBMS_LOB.GETLENGTH(c);
    v_clob_offset := 1;
    --dbms_output.put_line('V amount: '||v_amount);
    while(v_clob_offset < v_amount) loop
      --dbms_output.put_line(v_offset);
      --temp := ;
      --dbms_output.put_line('size: '||length(temp));
      obj.append(dbms_lob.SUBSTR(c, 4000,v_clob_offset));
      v_clob_offset := v_clob_offset + 4000;
    end loop;
    dbms_lob.freetemporary(benc);
    dbms_lob.freetemporary(c);
  --dbms_output.put_line(obj.count);
  --dbms_output.put_line(obj.get_last().to_char);
    return obj;

  end base64;


  function base64(l json_list) return blob as
    c clob := empty_clob();
    b blob := empty_blob();
    bret blob;

    v_blob_offset NUMBER := 1;
    v_clob_offset NUMBER := 1;
    v_lang_context NUMBER := 0; --DBMS_LOB.DEFAULT_LANG_CTX;
    v_warning NUMBER;
    v_amount PLS_INTEGER;

    FUNCTION decodeBase642Blob(pBlobIn IN BLOB) RETURN BLOB IS
      vAmount NUMBER := 256;--32;
      vBlobDec BLOB := empty_blob();
      vBlobDecLen NUMBER := 0;
      vBlobInLen NUMBER := 0;
      vBuffer RAW(256);--32);
      vOffset NUMBER := 1;
    BEGIN
--      dbms_output.put_line('Start base64 decoding.');
      vBlobInLen := dbms_lob.getlength(pBlobIn);
--      dbms_output.put_line('<BlobInLength>' || vBlobInLen);
      dbms_lob.createtemporary(vBlobDec, TRUE);
      LOOP
        IF vOffset >= vBlobInLen THEN
          EXIT;
        END IF;
        dbms_lob.read(pBlobIn, vAmount, vOffset, vBuffer);
        BEGIN
          dbms_lob.append(vBlobDec, utl_encode.base64_decode(vBuffer));
        EXCEPTION
          WHEN OTHERS THEN
          dbms_output.put_line('<vAmount>' || vAmount || '<vOffset>' || vOffset || '<vBuffer>' || vBuffer);
          dbms_output.put_line('ERROR IN append: ' || SQLERRM);
          RAISE;
        END;
        vOffset := vOffset + vAmount;
      END LOOP;
      vBlobDecLen := dbms_lob.getlength(vBlobDec);
--      dbms_output.put_line('<BlobDecLength>' || vBlobDecLen);
--      dbms_output.put_line('Finshed base64 decoding.');
      RETURN vBlobDec;
    END decodeBase642Blob;
  begin
    dbms_lob.createtemporary(c, TRUE);
    for i in 1 .. l.count loop
      dbms_lob.append(c, l.get(i).get_string());
    end loop;
    v_amount := DBMS_LOB.GETLENGTH(c);
--    dbms_output.put_line('L C'||v_amount);

    dbms_lob.createtemporary(b, TRUE);
    DBMS_LOB.CONVERTTOBLOB(b, c, dbms_lob.lobmaxsize, v_clob_offset, v_blob_offset, 1, v_lang_context, v_warning);
    dbms_lob.freetemporary(c);
    v_amount := DBMS_LOB.GETLENGTH(b);
--    dbms_output.put_line('L B'||v_amount);

    bret := decodeBase642Blob(b);
    dbms_lob.freetemporary(b);
    return bret;

  end base64;

  function encode(binarydata blob) return json_value as
    obj json_value;
    c clob := empty_clob();
    benc blob;

    v_blob_offset NUMBER := 1;
    v_clob_offset NUMBER := 1;
    v_lang_context NUMBER := DBMS_LOB.DEFAULT_LANG_CTX;
    v_warning NUMBER;
    v_amount PLS_INTEGER;
--    temp varchar2(32767);

    FUNCTION encodeBlob2Base64(pBlobIn IN BLOB) RETURN BLOB IS
      vAmount NUMBER := 45;
      vBlobEnc BLOB := empty_blob();
      vBlobEncLen NUMBER := 0;
      vBlobInLen NUMBER := 0;
      vBuffer RAW(45);
      vOffset NUMBER := 1;
    BEGIN
--      dbms_output.put_line('Start base64 encoding.');
      vBlobInLen := dbms_lob.getlength(pBlobIn);
--      dbms_output.put_line('<BlobInLength>' || vBlobInLen);
      dbms_lob.createtemporary(vBlobEnc, TRUE);
      LOOP
        IF vOffset >= vBlobInLen THEN
          EXIT;
        END IF;
        dbms_lob.read(pBlobIn, vAmount, vOffset, vBuffer);
        BEGIN
          dbms_lob.append(vBlobEnc, utl_encode.base64_encode(vBuffer));
        EXCEPTION
          WHEN OTHERS THEN
          dbms_output.put_line('<vAmount>' || vAmount || '<vOffset>' || vOffset || '<vBuffer>' || vBuffer);
          dbms_output.put_line('ERROR IN append: ' || SQLERRM);
          RAISE;
        END;
        vOffset := vOffset + vAmount;
      END LOOP;
      vBlobEncLen := dbms_lob.getlength(vBlobEnc);
--      dbms_output.put_line('<BlobEncLength>' || vBlobEncLen);
--      dbms_output.put_line('Finshed base64 encoding.');
      RETURN vBlobEnc;
    END encodeBlob2Base64;
  begin
    benc := encodeBlob2Base64(binarydata);
    dbms_lob.createtemporary(c, TRUE);
    v_amount := DBMS_LOB.GETLENGTH(benc);
    DBMS_LOB.CONVERTTOCLOB(c, benc, v_amount, v_clob_offset, v_blob_offset, 1, v_lang_context, v_warning);

    obj := json_value(c);

    dbms_lob.freetemporary(benc);
    dbms_lob.freetemporary(c);
  --dbms_output.put_line(obj.count);
  --dbms_output.put_line(obj.get_last().to_char);
    return obj;

  end encode;

  function decode(v json_value) return blob as
    c clob := empty_clob();
    b blob := empty_blob();
    bret blob;

    v_blob_offset NUMBER := 1;
    v_clob_offset NUMBER := 1;
    v_lang_context NUMBER := 0; --DBMS_LOB.DEFAULT_LANG_CTX;
    v_warning NUMBER;
    v_amount PLS_INTEGER;

    FUNCTION decodeBase642Blob(pBlobIn IN BLOB) RETURN BLOB IS
      vAmount NUMBER := 256;--32;
      vBlobDec BLOB := empty_blob();
      vBlobDecLen NUMBER := 0;
      vBlobInLen NUMBER := 0;
      vBuffer RAW(256);--32);
      vOffset NUMBER := 1;
    BEGIN
--      dbms_output.put_line('Start base64 decoding.');
      vBlobInLen := dbms_lob.getlength(pBlobIn);
--      dbms_output.put_line('<BlobInLength>' || vBlobInLen);
      dbms_lob.createtemporary(vBlobDec, TRUE);
      LOOP
        IF vOffset >= vBlobInLen THEN
          EXIT;
        END IF;
        dbms_lob.read(pBlobIn, vAmount, vOffset, vBuffer);
        BEGIN
          dbms_lob.append(vBlobDec, utl_encode.base64_decode(vBuffer));
        EXCEPTION
          WHEN OTHERS THEN
          dbms_output.put_line('<vAmount>' || vAmount || '<vOffset>' || vOffset || '<vBuffer>' || vBuffer);
          dbms_output.put_line('ERROR IN append: ' || SQLERRM);
          RAISE;
        END;
        vOffset := vOffset + vAmount;
      END LOOP;
      vBlobDecLen := dbms_lob.getlength(vBlobDec);
--      dbms_output.put_line('<BlobDecLength>' || vBlobDecLen);
--      dbms_output.put_line('Finshed base64 decoding.');
      RETURN vBlobDec;
    END decodeBase642Blob;
  begin
    dbms_lob.createtemporary(c, TRUE);
    v.get_string(c);
    v_amount := DBMS_LOB.GETLENGTH(c);
--    dbms_output.put_line('L C'||v_amount);

    dbms_lob.createtemporary(b, TRUE);
    DBMS_LOB.CONVERTTOBLOB(b, c, dbms_lob.lobmaxsize, v_clob_offset, v_blob_offset, 1, v_lang_context, v_warning);
    dbms_lob.freetemporary(c);
    v_amount := DBMS_LOB.GETLENGTH(b);
--    dbms_output.put_line('L B'||v_amount);

    bret := decodeBase642Blob(b);
    dbms_lob.freetemporary(b);
    return bret;

  end decode;


end json_ext;
/

------------------------------------
--  New package body json_helper  --
------------------------------------
create or replace package body json_helper as

  --recursive merge
  function merge( p_a_json json, p_b_json json) return json as
    l_json    JSON;
    l_jv      json_value;
    l_indx    number;
    l_recursive json_value;
  begin
    --
    -- Initialize our return object
    --
    l_json := p_a_json;

    -- loop through p_b_json
    l_indx := p_b_json.json_data.first;
    loop
      exit when l_indx is null;
      l_jv   := p_b_json.json_data(l_indx);
      if(l_jv.is_object) then
        --recursive
        l_recursive := l_json.get(l_jv.mapname);
        if(l_recursive is not null and l_recursive.is_object) then
          l_json.put(l_jv.mapname, merge(json(l_recursive), json(l_jv)));
        else
          l_json.put(l_jv.mapname, l_jv);
        end if;
      else
        l_json.put(l_jv.mapname, l_jv);
      end if;

      --increment
      l_indx := p_b_json.json_data.next(l_indx);
    end loop;

    return l_json;

  end merge;

  -- join two lists
  function join( p_a_list json_list, p_b_list json_list) return json_list as
    l_json_list json_list := p_a_list;
  begin
    for indx in 1 .. p_b_list.count loop
      l_json_list.append(p_b_list.get(indx));
    end loop;

    return l_json_list;

  end join;

  -- keep keys.
  function keep( p_json json, p_keys json_list) return json as
    l_json json := json();
    mapname varchar2(4000);
  begin
    for i in 1 .. p_keys.count loop
      mapname := p_keys.get(i).get_string;
      if(p_json.exist(mapname)) then
        l_json.put(mapname, p_json.get(mapname));
      end if;
    end loop;

    return l_json;
  end keep;

  -- drop keys.
  function remove( p_json json, p_keys json_list) return json as
    l_json json := p_json;
  begin
    for i in 1 .. p_keys.count loop
      l_json.remove(p_keys.get(i).get_string);
    end loop;

    return l_json;
  end remove;

  --equals functions

  function equals(p_v1 json_value, p_v2 number) return boolean as
  begin
    if(p_v2 is null) then
      return p_v1.is_null;
    end if;

    if(not p_v1.is_number) then
      return false;
    end if;

    return p_v2 = p_v1.get_number;
  end;

  function equals(p_v1 json_value, p_v2 boolean) return boolean as
  begin
    if(p_v2 is null) then
      return p_v1.is_null;
    end if;

    if(not p_v1.is_bool) then
      return false;
    end if;

    return p_v2 = p_v1.get_bool;
  end;

  function equals(p_v1 json_value, p_v2 varchar2) return boolean as
  begin
    if(p_v2 is null) then
      return p_v1.is_null;
    end if;

    if(not p_v1.is_string) then
      return false;
    end if;

    return p_v2 = p_v1.get_string;
  end;

  function equals(p_v1 json_value, p_v2 clob) return boolean as
    my_clob clob;
    res boolean;
  begin
    if(p_v2 is null) then
      return p_v1.is_null;
    end if;

    if(not p_v1.is_string) then
      return false;
    end if;

    my_clob := empty_clob();
    dbms_lob.createtemporary(my_clob, true);
    p_v1.get_string(my_clob);

    res := dbms_lob.compare(p_v2, my_clob) = 0;
    dbms_lob.freetemporary(my_clob);
  end;

  function equals(p_v1 json_value, p_v2 json_value, exact boolean) return boolean as
  begin
    if(p_v2 is null) then
      return p_v1.is_null;
    end if;

    if(p_v2.is_number) then return equals(p_v1, p_v2.get_number); end if;
    if(p_v2.is_bool) then return equals(p_v1, p_v2.get_bool); end if;
    if(p_v2.is_object) then return equals(p_v1, json(p_v2), exact); end if;
    if(p_v2.is_array) then return equals(p_v1, json_list(p_v2), exact); end if;
    if(p_v2.is_string) then
      if(p_v2.extended_str is null) then
        return equals(p_v1, p_v2.get_string);
      else
        declare
          my_clob clob; res boolean;
        begin
          my_clob := empty_clob();
          dbms_lob.createtemporary(my_clob, true);
          p_v2.get_string(my_clob);
          res := equals(p_v1, my_clob);
          dbms_lob.freetemporary(my_clob);
          return res;
        end;
      end if;
    end if;

    return false; --should never happen
  end;

  function equals(p_v1 json_value, p_v2 json_list, exact boolean) return boolean as
    cmp json_list;
    res boolean := true;
  begin
--  p_v1.print(false);
--  p_v2.print(false);
--  dbms_output.put_line('labc1'||case when exact then 'X' else 'U' end);

    if(p_v2 is null) then
      return p_v1.is_null;
    end if;

    if(not p_v1.is_array) then
      return false;
    end if;

--  dbms_output.put_line('labc2'||case when exact then 'X' else 'U' end);

    cmp := json_list(p_v1);
    if(cmp.count != p_v2.count and exact) then return false; end if;

--  dbms_output.put_line('labc3'||case when exact then 'X' else 'U' end);

    if(exact) then
      for i in 1 .. cmp.count loop
        res := equals(cmp.get(i), p_v2.get(i), exact);
        if(not res) then return res; end if;
      end loop;
    else
--  dbms_output.put_line('labc4'||case when exact then 'X' else 'U' end);
      if(p_v2.count > cmp.count) then return false; end if;
--  dbms_output.put_line('labc5'||case when exact then 'X' else 'U' end);

      --match sublist here!
      for x in 0 .. (cmp.count-p_v2.count) loop
--  dbms_output.put_line('labc7'||x);

        for i in 1 .. p_v2.count loop
          res := equals(cmp.get(x+i), p_v2.get(i), exact);
          if(not res) then
            goto next_index;
          end if;
        end loop;
        return true;

        <<next_index>>
        null;
      end loop;

--  dbms_output.put_line('labc7'||case when exact then 'X' else 'U' end);

    return false; --no match

    end if;

    return res;
  end;

  function equals(p_v1 json_value, p_v2 json, exact boolean) return boolean as
    cmp json;
    res boolean := true;
  begin
--  p_v1.print(false);
--  p_v2.print(false);
--  dbms_output.put_line('abc1');

    if(p_v2 is null) then
      return p_v1.is_null;
    end if;

    if(not p_v1.is_object) then
      return false;
    end if;

    cmp := json(p_v1);

--  dbms_output.put_line('abc2');

    if(cmp.count != p_v2.count and exact) then return false; end if;

--  dbms_output.put_line('abc3');
    declare
      k1 json_list := p_v2.get_keys;
      key_index number;
    begin
      for i in 1 .. k1.count loop
        key_index := cmp.index_of(k1.get(i).get_string);
        if(key_index = -1) then return false; end if;
        if(exact) then
          if(not equals(p_v2.get(i), cmp.get(key_index),true)) then return false; end if;
        else
          --non exact
          declare
            v1 json_value := cmp.get(key_index);
            v2 json_value := p_v2.get(i);
          begin
--  dbms_output.put_line('abc3 1/2');
--            v1.print(false);
--            v2.print(false);

            if(v1.is_object and v2.is_object) then
              if(not equals(v1, v2, false)) then return false; end if;
            elsif(v1.is_array and v2.is_array) then
              if(not equals(v1, v2, false)) then return false; end if;
            else
              if(not equals(v1, v2, true)) then return false; end if;
            end if;
          end;

        end if;
      end loop;
    end;

--  dbms_output.put_line('abc4');

    return true;
  end;

  function equals(p_v1 json, p_v2 json, exact boolean) return boolean as
  begin
    return equals(p_v1.to_json_value, p_v2, exact);
  end;

  function equals(p_v1 json_list, p_v2 json_list, exact boolean) return boolean as
  begin
    return equals(p_v1.to_json_value, p_v2, exact);
  end;

  --contain
  function contains(p_v1 json, p_v2 json_value, exact boolean) return boolean as
    v_values json_list;
  begin
    if(equals(p_v1.to_json_value, p_v2, exact)) then return true; end if;

    v_values := p_v1.get_values;

    for i in 1 .. v_values.count loop
      declare
        v_val json_value := v_values.get(i);
      begin
        if(v_val.is_object) then
          if(contains(json(v_val),p_v2,exact)) then return true; end if;
        end if;
        if(v_val.is_array) then
          if(contains(json_list(v_val),p_v2, exact)) then return true; end if;
        end if;

        if(equals(v_val, p_v2, exact)) then return true; end if;
      end;

    end loop;

    return false;
  end;

  function contains(p_v1 json_list, p_v2 json_value, exact boolean) return boolean as
  begin
    if(equals(p_v1.to_json_value, p_v2, exact)) then return true; end if;

    for i in 1 .. p_v1.count loop
      declare
        v_val json_value := p_v1.get(i);
      begin
        if(v_val.is_object) then
          if(contains(json(v_val),p_v2, exact)) then return true; end if;
        end if;
        if(v_val.is_array) then
          if(contains(json_list(v_val),p_v2, exact)) then return true; end if;
        end if;

        if(equals(v_val, p_v2, exact)) then return true; end if;
      end;

    end loop;

    return false;
  end;

  function contains(p_v1 json, p_v2 json, exact boolean ) return boolean as
  begin return contains(p_v1, p_v2.to_json_value,exact); end;
  function contains(p_v1 json, p_v2 json_list, exact boolean ) return boolean as
  begin return contains(p_v1, p_v2.to_json_value,exact); end;
  function contains(p_v1 json, p_v2 number, exact boolean ) return boolean as begin
  return contains(p_v1, json_value(p_v2),exact); end;
  function contains(p_v1 json, p_v2 varchar2, exact boolean ) return boolean as begin
  return contains(p_v1, json_value(p_v2),exact); end;
  function contains(p_v1 json, p_v2 boolean, exact boolean ) return boolean as begin
  return contains(p_v1, json_value(p_v2),exact); end;
  function contains(p_v1 json, p_v2 clob, exact boolean ) return boolean as begin
  return contains(p_v1, json_value(p_v2),exact); end;

  function contains(p_v1 json_list, p_v2 json, exact boolean ) return boolean as begin
  return contains(p_v1, p_v2.to_json_value,exact); end;
  function contains(p_v1 json_list, p_v2 json_list, exact boolean ) return boolean as begin
  return contains(p_v1, p_v2.to_json_value,exact); end;
  function contains(p_v1 json_list, p_v2 number, exact boolean ) return boolean as begin
  return contains(p_v1, json_value(p_v2),exact); end;
  function contains(p_v1 json_list, p_v2 varchar2, exact boolean ) return boolean as begin
  return contains(p_v1, json_value(p_v2),exact); end;
  function contains(p_v1 json_list, p_v2 boolean, exact boolean ) return boolean as begin
  return contains(p_v1, json_value(p_v2),exact); end;
  function contains(p_v1 json_list, p_v2 clob, exact boolean ) return boolean as begin
  return contains(p_v1, json_value(p_v2),exact); end;


end json_helper;
/

--------------------------------
--  New package body json_ml  --
--------------------------------
create or replace package body json_ml as
  function get_jsonml_stylesheet return xmltype;

  function xml2json(xml in xmltype) return json_list as
    l_json        xmltype;
    l_returnvalue clob;
  begin
    l_json := xml.transform (get_jsonml_stylesheet);
    l_returnvalue := l_json.getclobval();
    l_returnvalue := dbms_xmlgen.convert (l_returnvalue, dbms_xmlgen.entity_decode);
    --dbms_output.put_line(l_returnvalue);
    return json_list(l_returnvalue);
  end xml2json;

  function xmlstr2json(xmlstr in varchar2) return json_list as
  begin
    return xml2json(xmltype(xmlstr));
  end xmlstr2json;

  function get_jsonml_stylesheet return xmltype as
  begin
    if(jsonml_stylesheet is null) then
    jsonml_stylesheet := xmltype('<?xml version="1.0" encoding="UTF-8"?>
<!--
		JsonML.xslt

		Created: 2006-11-15-0551
		Modified: 2009-02-14-0927

		Released under an open-source license:
		http://jsonml.org/License.htm

		This transformation converts any XML document into JsonML.
		It omits processing-instructions and comment-nodes.

		To enable comment-nodes to be emitted as JavaScript comments,
		uncomment the Comment() template.
-->
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="text"
				media-type="application/json"
				encoding="UTF-8"
				indent="no"
				omit-xml-declaration="yes" />

	<!-- constants -->
	<xsl:variable name="XHTML"
				  select="''http://www.w3.org/1999/xhtml''" />

	<xsl:variable name="START_ELEM"
				  select="''[''" />

	<xsl:variable name="END_ELEM"
				  select="'']''" />

	<xsl:variable name="VALUE_DELIM"
				  select="'',''" />

	<xsl:variable name="START_ATTRIB"
				  select="''{''" />

	<xsl:variable name="END_ATTRIB"
				  select="''}''" />

	<xsl:variable name="NAME_DELIM"
				  select="'':''" />

	<xsl:variable name="STRING_DELIM"
				  select="''&#x22;''" />

	<xsl:variable name="START_COMMENT"
				  select="''/*''" />

	<xsl:variable name="END_COMMENT"
				  select="''*/''" />

	<!-- root-node -->
	<xsl:template match="/">
		<xsl:apply-templates select="*" />
	</xsl:template>

	<!-- comments -->
	<xsl:template match="comment()">
	<!-- uncomment to support JSON comments -->
	<!--
		<xsl:value-of select="$START_COMMENT" />

		<xsl:value-of select="."
					  disable-output-escaping="yes" />

		<xsl:value-of select="$END_COMMENT" />
	-->
	</xsl:template>

	<!-- elements -->
	<xsl:template match="*">
		<xsl:value-of select="$START_ELEM" />

		<!-- tag-name string -->
		<xsl:value-of select="$STRING_DELIM" />
		<xsl:choose>
			<xsl:when test="namespace-uri()=$XHTML">
				<xsl:value-of select="local-name()" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="name()" />
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$STRING_DELIM" />

		<!-- attribute object -->
		<xsl:if test="count(@*)>0">
			<xsl:value-of select="$VALUE_DELIM" />
			<xsl:value-of select="$START_ATTRIB" />
			<xsl:for-each select="@*">
				<xsl:if test="position()>1">
					<xsl:value-of select="$VALUE_DELIM" />
				</xsl:if>
				<xsl:apply-templates select="." />
			</xsl:for-each>
			<xsl:value-of select="$END_ATTRIB" />
		</xsl:if>

		<!-- child elements and text-nodes -->
		<xsl:for-each select="*|text()">
			<xsl:value-of select="$VALUE_DELIM" />
			<xsl:apply-templates select="." />
		</xsl:for-each>

		<xsl:value-of select="$END_ELEM" />
	</xsl:template>

	<!-- text-nodes -->
	<xsl:template match="text()">
		<xsl:call-template name="escape-string">
			<xsl:with-param name="value"
							select="." />
		</xsl:call-template>
	</xsl:template>

	<!-- attributes -->
	<xsl:template match="@*">
		<xsl:value-of select="$STRING_DELIM" />
		<xsl:choose>
			<xsl:when test="namespace-uri()=$XHTML">
				<xsl:value-of select="local-name()" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="name()" />
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="$STRING_DELIM" />

		<xsl:value-of select="$NAME_DELIM" />

		<xsl:call-template name="escape-string">
			<xsl:with-param name="value"
							select="." />
		</xsl:call-template>

	</xsl:template>

	<!-- escape-string: quotes and escapes -->
	<xsl:template name="escape-string">
		<xsl:param name="value" />

		<xsl:value-of select="$STRING_DELIM" />

		<xsl:if test="string-length($value)>0">
			<xsl:variable name="escaped-whacks">
				<!-- escape backslashes -->
				<xsl:call-template name="string-replace">
					<xsl:with-param name="value"
									select="$value" />
					<xsl:with-param name="find"
									select="''\''" />
					<xsl:with-param name="replace"
									select="''\\''" />
				</xsl:call-template>
			</xsl:variable>

			<xsl:variable name="escaped-LF">
				<!-- escape line feeds -->
				<xsl:call-template name="string-replace">
					<xsl:with-param name="value"
									select="$escaped-whacks" />
					<xsl:with-param name="find"
									select="''&#x0A;''" />
					<xsl:with-param name="replace"
									select="''\n''" />
				</xsl:call-template>
			</xsl:variable>

			<xsl:variable name="escaped-CR">
				<!-- escape carriage returns -->
				<xsl:call-template name="string-replace">
					<xsl:with-param name="value"
									select="$escaped-LF" />
					<xsl:with-param name="find"
									select="''&#x0D;''" />
					<xsl:with-param name="replace"
									select="''\r''" />
				</xsl:call-template>
			</xsl:variable>

			<xsl:variable name="escaped-tabs">
				<!-- escape tabs -->
				<xsl:call-template name="string-replace">
					<xsl:with-param name="value"
									select="$escaped-CR" />
					<xsl:with-param name="find"
									select="''&#x09;''" />
					<xsl:with-param name="replace"
									select="''\t''" />
				</xsl:call-template>
			</xsl:variable>

			<!-- escape quotes -->
			<xsl:call-template name="string-replace">
				<xsl:with-param name="value"
								select="$escaped-tabs" />
				<xsl:with-param name="find"
								select="''&quot;''" />
				<xsl:with-param name="replace"
								select="''\&quot;''" />
			</xsl:call-template>
		</xsl:if>

		<xsl:value-of select="$STRING_DELIM" />
	</xsl:template>

	<!-- string-replace: replaces occurances of one string with another -->
	<xsl:template name="string-replace">
		<xsl:param name="value" />
		<xsl:param name="find" />
		<xsl:param name="replace" />

		<xsl:choose>
			<xsl:when test="contains($value,$find)">
				<!-- replace and call recursively on next -->
				<xsl:value-of select="substring-before($value,$find)"
							  disable-output-escaping="yes" />
				<xsl:value-of select="$replace"
							  disable-output-escaping="yes" />
				<xsl:call-template name="string-replace">
					<xsl:with-param name="value"
									select="substring-after($value,$find)" />
					<xsl:with-param name="find"
									select="$find" />
					<xsl:with-param name="replace"
									select="$replace" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- no replacement necessary -->
				<xsl:value-of select="$value"
							  disable-output-escaping="yes" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>');
    end if;
    return jsonml_stylesheet;
  end get_jsonml_stylesheet;

end json_ml;
/

------------------------------------
--  New package body json_parser  --
------------------------------------
CREATE OR REPLACE PACKAGE BODY "JSON_PARSER" as
  /*
  Copyright (c) 2009 Jonas Krogsboell

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  */

  decimalpoint varchar2(1 char) := '.';

  procedure updateDecimalPoint as
  begin
    SELECT substr(VALUE,1,1) into decimalpoint FROM NLS_SESSION_PARAMETERS WHERE PARAMETER = 'NLS_NUMERIC_CHARACTERS';
  end updateDecimalPoint;

  /*type json_src is record (len number, offset number, src varchar2(10), s_clob clob); */
  function next_char(indx number, s in out nocopy json_src) return varchar2 as
  begin
    if(indx > s.len) then return null; end if;
    --right offset?
    if(indx > 4000 + s.offset or indx < s.offset) then
    --load right offset
      s.offset := indx - (indx mod 4000);
      s.src := dbms_lob.substr(s.s_clob, 4000, s.offset+1);
    end if;
    --read from s.src
    return substr(s.src, indx-s.offset, 1);
  end;

  function next_char2(indx number, s in out nocopy json_src, amount number default 1) return varchar2 as
    buf varchar2(32767) := '';
  begin
    for i in 1..amount loop
      buf := buf || next_char(indx-1+i,s);
    end loop;
    return buf;
  end;

  function prepareClob(buf clob) return json_parser.json_src as
    temp json_parser.json_src;
  begin
    temp.s_clob := buf;
    temp.offset := 0;
    temp.src := dbms_lob.substr(buf, 4000, temp.offset+1);
    temp.len := dbms_lob.getlength(buf);
    return temp;
  end;

  function prepareVarchar2(buf varchar2) return json_parser.json_src as
    temp json_parser.json_src;
  begin
    temp.s_clob := buf;
    temp.offset := 0;
    temp.src := substr(buf, 1, 4000);
    temp.len := length(buf);
    return temp;
  end;

  procedure debug(text varchar2) as
  begin
    dbms_output.put_line(text);
  end;

  procedure print_token(t rToken) as
  begin
    dbms_output.put_line('Line: '||t.line||' - Column: '||t.col||' - Type: '||t.type_name||' - Content: '||t.data);
  end print_token;

  /* SCANNER FUNCTIONS START */
  procedure s_error(text varchar2, line number, col number) as
  begin
    raise_application_error(-20100, 'JSON Scanner exception @ line: '||line||' column: '||col||' - '||text);
  end;

  procedure s_error(text varchar2, tok rToken) as
  begin
    raise_application_error(-20100, 'JSON Scanner exception @ line: '||tok.line||' column: '||tok.col||' - '||text);
  end;

  function mt(t varchar2, l pls_integer, c pls_integer, d varchar2) return rToken as
    token rToken;
  begin
    token.type_name := t;
    token.line := l;
    token.col := c;
    token.data := d;
    return token;
  end;

  function lexNumber(jsrc in out nocopy json_src, tok in out nocopy rToken, indx in out nocopy pls_integer) return pls_integer as
    numbuf varchar2(4000) := '';
    buf varchar2(4);
    checkLoop boolean;
  begin
    buf := next_char(indx, jsrc);
    if(buf = '-') then numbuf := '-'; indx := indx + 1; end if;
    buf := next_char(indx, jsrc);
    --0 or [1-9]([0-9])*
    if(buf = '0') then
      numbuf := numbuf || '0'; indx := indx + 1;
      buf := next_char(indx, jsrc);
    elsif(buf >= '1' and buf <= '9') then
      numbuf := numbuf || buf; indx := indx + 1;
      --read digits
      buf := next_char(indx, jsrc);
      while(buf >= '0' and buf <= '9') loop
        numbuf := numbuf || buf; indx := indx + 1;
        buf := next_char(indx, jsrc);
      end loop;
    end if;
    --fraction
    if(buf = '.') then
      numbuf := numbuf || buf; indx := indx + 1;
      buf := next_char(indx, jsrc);
      checkLoop := FALSE;
      while(buf >= '0' and buf <= '9') loop
        checkLoop := TRUE;
        numbuf := numbuf || buf; indx := indx + 1;
        buf := next_char(indx, jsrc);
      end loop;
      if(not checkLoop) then
        s_error('Expected: digits in fraction', tok);
      end if;
    end if;
    --exp part
    if(buf in ('e', 'E')) then
      numbuf := numbuf || buf; indx := indx + 1;
      buf := next_char(indx, jsrc);
      if(buf = '+' or buf = '-') then
        numbuf := numbuf || buf; indx := indx + 1;
        buf := next_char(indx, jsrc);
      end if;
      checkLoop := FALSE;
      while(buf >= '0' and buf <= '9') loop
        checkLoop := TRUE;
        numbuf := numbuf || buf; indx := indx + 1;
        buf := next_char(indx, jsrc);
      end loop;
      if(not checkLoop) then
        s_error('Expected: digits in exp', tok);
      end if;
    end if;

    tok.data := numbuf;
    return indx;
  end lexNumber;

  -- [a-zA-Z]([a-zA-Z0-9])*
  function lexName(jsrc in out nocopy json_src, tok in out nocopy rToken, indx in out nocopy pls_integer) return pls_integer as
    varbuf varchar2(32767) := '';
    buf varchar(4);
    num number;
  begin
    buf := next_char(indx, jsrc);
    while(REGEXP_LIKE(buf, '^[[:alnum:]\_]$', 'i')) loop
      varbuf := varbuf || buf;
      indx := indx + 1;
      buf := next_char(indx, jsrc);
      if (buf is null) then
        goto retname;
        --debug('Premature string ending');
      end if;
    end loop;
    <<retname>>

    --could check for reserved keywords here

    --debug(varbuf);
    tok.data := varbuf;
    return indx-1;
  end lexName;

  procedure updateClob(v_extended in out nocopy clob, v_str varchar2) as
  begin
    dbms_lob.writeappend(v_extended, length(v_str), v_str);
  end updateClob;

  function lexString(jsrc in out nocopy json_src, tok in out nocopy rToken, indx in out nocopy pls_integer, endChar char) return pls_integer as
    v_extended clob := null; v_count number := 0;
    varbuf varchar2(32767) := '';
    buf varchar(4);
    wrong boolean;
  begin
    indx := indx +1;
    buf := next_char(indx, jsrc);
    while(buf != endChar) loop
      --clob control
      if(v_count > 8191) then --crazy oracle error (16383 is the highest working length with unistr - 8192 choosen to be safe)
        if(v_extended is null) then
          v_extended := empty_clob();
          dbms_lob.createtemporary(v_extended, true);
        end if;
        updateClob(v_extended, unistr(varbuf));
        varbuf := ''; v_count := 0;
      end if;
      if(buf = Chr(13) or buf = CHR(9) or buf = CHR(10)) then
        s_error('Control characters not allowed (CHR(9),CHR(10)CHR(13))', tok);
      end if;
      if(buf = '\') then
        --varbuf := varbuf || buf;
        indx := indx + 1;
        buf := next_char(indx, jsrc);
        case
          when buf in ('\') then
            varbuf := varbuf || buf || buf; v_count := v_count + 2;
            indx := indx + 1;
            buf := next_char(indx, jsrc);
          when buf in ('"', '/') then
            varbuf := varbuf || buf; v_count := v_count + 1;
            indx := indx + 1;
            buf := next_char(indx, jsrc);
          when buf = '''' then
            if(json_strict = false) then
              varbuf := varbuf || buf; v_count := v_count + 1;
              indx := indx + 1;
              buf := next_char(indx, jsrc);
            else
              s_error('strictmode - expected: " \ / b f n r t u ', tok);
            end if;
          when buf in ('b', 'f', 'n', 'r', 't') then
            --backspace b = U+0008
            --formfeed  f = U+000C
            --newline   n = U+000A
            --carret    r = U+000D
            --tabulator t = U+0009
            case buf
            when 'b' then varbuf := varbuf || chr(8);
            when 'f' then varbuf := varbuf || chr(12);
            when 'n' then varbuf := varbuf || chr(10);
            when 'r' then varbuf := varbuf || chr(13);
            when 't' then varbuf := varbuf || chr(9);
            end case;
            --varbuf := varbuf || buf;
            v_count := v_count + 1;
            indx := indx + 1;
            buf := next_char(indx, jsrc);
          when buf = 'u' then
            --four hexidecimal chars
            declare
              four varchar2(4);
            begin
              four := next_char2(indx+1, jsrc, 4);
              wrong := FALSE;
              if(upper(substr(four, 1,1)) not in ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','a','b','c','d','e','f')) then wrong := TRUE; end if;
              if(upper(substr(four, 2,1)) not in ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','a','b','c','d','e','f')) then wrong := TRUE; end if;
              if(upper(substr(four, 3,1)) not in ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','a','b','c','d','e','f')) then wrong := TRUE; end if;
              if(upper(substr(four, 4,1)) not in ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','a','b','c','d','e','f')) then wrong := TRUE; end if;
              if(wrong) then
                s_error('expected: " \u([0-9][A-F]){4}', tok);
              end if;
--              varbuf := varbuf || buf || four;
              varbuf := varbuf || '\'||four;--chr(to_number(four,'XXXX'));
               v_count := v_count + 5;
              indx := indx + 5;
              buf := next_char(indx, jsrc);
              end;
          else
            s_error('expected: " \ / b f n r t u ', tok);
        end case;
      else
        varbuf := varbuf || buf; v_count := v_count + 1;
        indx := indx + 1;
        buf := next_char(indx, jsrc);
      end if;
    end loop;

    if (buf is null) then
      s_error('string ending not found', tok);
      --debug('Premature string ending');
    end if;

    --debug(varbuf);
    --dbms_output.put_line(varbuf);
    if(v_extended is not null) then
      updateClob(v_extended, unistr(varbuf));
      tok.data_overflow := v_extended;
      tok.data := dbms_lob.substr(v_extended, 1, 32767);
    else
      tok.data := unistr(varbuf);
    end if;
    return indx;
  end lexString;

  /* scanner tokens:
    '{', '}', ',', ':', '[', ']', STRING, NUMBER, TRUE, FALSE, NULL
  */
  function lexer(jsrc in out nocopy json_src) return lTokens as
    tokens lTokens;
    indx pls_integer := 1;
    tok_indx pls_integer := 1;
    buf varchar2(4);
    lin_no number := 1;
    col_no number := 0;
  begin
    while (indx <= jsrc.len) loop
      --read into buf
      buf := next_char(indx, jsrc);
      col_no := col_no + 1;
      --convert to switch case
      case
        when buf = '{' then tokens(tok_indx) := mt('{', lin_no, col_no, null); tok_indx := tok_indx + 1;
        when buf = '}' then tokens(tok_indx) := mt('}', lin_no, col_no, null); tok_indx := tok_indx + 1;
        when buf = ',' then tokens(tok_indx) := mt(',', lin_no, col_no, null); tok_indx := tok_indx + 1;
        when buf = ':' then tokens(tok_indx) := mt(':', lin_no, col_no, null); tok_indx := tok_indx + 1;
        when buf = '[' then tokens(tok_indx) := mt('[', lin_no, col_no, null); tok_indx := tok_indx + 1;
        when buf = ']' then tokens(tok_indx) := mt(']', lin_no, col_no, null); tok_indx := tok_indx + 1;
        when buf = 't' then
          if(next_char2(indx, jsrc, 4) != 'true') then
            if(json_strict = false and REGEXP_LIKE(buf, '^[[:alpha:]]$', 'i')) then
              tokens(tok_indx) := mt('STRING', lin_no, col_no, null);
              indx := lexName(jsrc, tokens(tok_indx), indx);
              col_no := col_no + length(tokens(tok_indx).data) + 1;
              tok_indx := tok_indx + 1;
            else
              s_error('Expected: ''true''', lin_no, col_no);
            end if;
          else
            tokens(tok_indx) := mt('TRUE', lin_no, col_no, null); tok_indx := tok_indx + 1;
            indx := indx + 3;
            col_no := col_no + 3;
          end if;
        when buf = 'n' then
          if(next_char2(indx, jsrc, 4) != 'null') then
            if(json_strict = false and REGEXP_LIKE(buf, '^[[:alpha:]]$', 'i')) then
              tokens(tok_indx) := mt('STRING', lin_no, col_no, null);
              indx := lexName(jsrc, tokens(tok_indx), indx);
              col_no := col_no + length(tokens(tok_indx).data) + 1;
              tok_indx := tok_indx + 1;
            else
              s_error('Expected: ''null''', lin_no, col_no);
            end if;
          else
            tokens(tok_indx) := mt('NULL', lin_no, col_no, null); tok_indx := tok_indx + 1;
            indx := indx + 3;
            col_no := col_no + 3;
          end if;
        when buf = 'f' then
          if(next_char2(indx, jsrc, 5) != 'false') then
            if(json_strict = false and REGEXP_LIKE(buf, '^[[:alpha:]]$', 'i')) then
              tokens(tok_indx) := mt('STRING', lin_no, col_no, null);
              indx := lexName(jsrc, tokens(tok_indx), indx);
              col_no := col_no + length(tokens(tok_indx).data) + 1;
              tok_indx := tok_indx + 1;
            else
              s_error('Expected: ''false''', lin_no, col_no);
            end if;
          else
            tokens(tok_indx) := mt('FALSE', lin_no, col_no, null); tok_indx := tok_indx + 1;
            indx := indx + 4;
            col_no := col_no + 4;
          end if;
        /*   -- 9 = TAB, 10 = \n, 13 = \r (Linux = \n, Windows = \r\n, Mac = \r */
        when (buf = Chr(10)) then --linux newlines
          lin_no := lin_no + 1;
          col_no := 0;

        when (buf = Chr(13)) then --Windows or Mac way
          lin_no := lin_no + 1;
          col_no := 0;
          if(jsrc.len >= indx +1) then -- better safe than sorry
            buf := next_char(indx+1, jsrc);
            if(buf = Chr(10)) then --\r\n
              indx := indx + 1;
            end if;
          end if;

        when (buf = CHR(9)) then null; --tabbing
        when (buf in ('-', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9')) then --number
          tokens(tok_indx) := mt('NUMBER', lin_no, col_no, null);
          indx := lexNumber(jsrc, tokens(tok_indx), indx)-1;
          col_no := col_no + length(tokens(tok_indx).data);
          tok_indx := tok_indx + 1;
        when buf = '"' then --number
          tokens(tok_indx) := mt('STRING', lin_no, col_no, null);
          indx := lexString(jsrc, tokens(tok_indx), indx, '"');
          col_no := col_no + length(tokens(tok_indx).data) + 1;
          tok_indx := tok_indx + 1;
        when buf = '''' and json_strict = false then --number
          tokens(tok_indx) := mt('STRING', lin_no, col_no, null);
          indx := lexString(jsrc, tokens(tok_indx), indx, '''');
          col_no := col_no + length(tokens(tok_indx).data) + 1; --hovsa her
          tok_indx := tok_indx + 1;
        when json_strict = false and REGEXP_LIKE(buf, '^[[:alpha:]]$', 'i') then
          tokens(tok_indx) := mt('STRING', lin_no, col_no, null);
          indx := lexName(jsrc, tokens(tok_indx), indx);
          if(tokens(tok_indx).data_overflow is not null) then
            col_no := col_no + dbms_lob.getlength(tokens(tok_indx).data_overflow) + 1;
          else
            col_no := col_no + length(tokens(tok_indx).data) + 1;
          end if;
          tok_indx := tok_indx + 1;
        when json_strict = false and buf||next_char(indx+1, jsrc) = '/*' then --strip comments
          declare
            saveindx number := indx;
            un_esc clob;
          begin
            indx := indx + 1;
            loop
              indx := indx + 1;
              buf := next_char(indx, jsrc)||next_char(indx+1, jsrc);
              exit when buf = '*/';
              exit when buf is null;
            end loop;

            if(indx = saveindx+2) then
              --enter unescaped mode
              --dbms_output.put_line('Entering unescaped mode');
              un_esc := empty_clob();
              dbms_lob.createtemporary(un_esc, true);
              indx := indx + 1;
              loop
                indx := indx + 1;
                buf := next_char(indx, jsrc)||next_char(indx+1, jsrc)||next_char(indx+2, jsrc)||next_char(indx+3, jsrc);
                exit when buf = '/**/';
                if buf is null then
                  s_error('Unexpected sequence /**/ to end unescaped data: '||buf, lin_no, col_no);
                end if;
                buf := next_char(indx, jsrc);
                dbms_lob.writeappend(un_esc, length(buf), buf);
              end loop;
              tokens(tok_indx) := mt('ESTRING', lin_no, col_no, null);
              tokens(tok_indx).data_overflow := un_esc;
              col_no := col_no + dbms_lob.getlength(un_esc) + 1; --note: line count won't work properly
              tok_indx := tok_indx + 1;
              indx := indx + 2;
            end if;

            indx := indx + 1;
          end;
        when buf = ' ' then null; --space
        else
          s_error('Unexpected char: '||buf, lin_no, col_no);
      end case;

      indx := indx + 1;
    end loop;

    return tokens;
  end lexer;

  /* SCANNER END */

  /* PARSER FUNCTIONS START*/
  procedure p_error(text varchar2, tok rToken) as
  begin
    raise_application_error(-20101, 'JSON Parser exception @ line: '||tok.line||' column: '||tok.col||' - '||text);
  end;

  function parseObj(tokens lTokens, indx in out nocopy pls_integer) return json;

  function parseArr(tokens lTokens, indx in out nocopy pls_integer) return json_list as
    e_arr json_value_array := json_value_array();
    ret_list json_list := json_list();
    v_count number := 0;
    tok rToken;
  begin
    --value, value, value ]
    if(indx > tokens.count) then p_error('more elements in array was excepted', tok); end if;
    tok := tokens(indx);
    while(tok.type_name != ']') loop
      e_arr.extend;
      v_count := v_count + 1;
      case tok.type_name
        when 'TRUE' then e_arr(v_count) := json_value(true);
        when 'FALSE' then e_arr(v_count) := json_value(false);
        when 'NULL' then e_arr(v_count) := json_value;
        when 'STRING' then e_arr(v_count) := case when tok.data_overflow is not null then json_value(tok.data_overflow) else json_value(tok.data) end;
        when 'ESTRING' then e_arr(v_count) := json_value(tok.data_overflow, false);
        when 'NUMBER' then e_arr(v_count) := json_value(to_number(replace(tok.data, '.', decimalpoint)));
        when '[' then
          declare e_list json_list; begin
            indx := indx + 1;
            e_list := parseArr(tokens, indx);
            e_arr(v_count) := e_list.to_json_value;
          end;
        when '{' then
          indx := indx + 1;
          e_arr(v_count) := parseObj(tokens, indx).to_json_value;
        else
          p_error('Expected a value', tok);
      end case;
      indx := indx + 1;
      if(indx > tokens.count) then p_error('] not found', tok); end if;
      tok := tokens(indx);
      if(tok.type_name = ',') then --advance
        indx := indx + 1;
        if(indx > tokens.count) then p_error('more elements in array was excepted', tok); end if;
        tok := tokens(indx);
        if(tok.type_name = ']') then --premature exit
          p_error('Premature exit in array', tok);
        end if;
      elsif(tok.type_name != ']') then --error
        p_error('Expected , or ]', tok);
      end if;

    end loop;
    ret_list.list_data := e_arr;
    return ret_list;
  end parseArr;

  function parseMem(tokens lTokens, indx in out pls_integer, mem_name varchar2, mem_indx number) return json_value as
    mem json_value;
    tok rToken;
  begin
    tok := tokens(indx);
    case tok.type_name
      when 'TRUE' then mem := json_value(true);
      when 'FALSE' then mem := json_value(false);
      when 'NULL' then mem := json_value;
      when 'STRING' then mem := case when tok.data_overflow is not null then json_value(tok.data_overflow) else json_value(tok.data) end;
      when 'ESTRING' then mem := json_value(tok.data_overflow, false);
      when 'NUMBER' then mem := json_value(to_number(replace(tok.data, '.', decimalpoint)));
      when '[' then
        declare
          e_list json_list;
        begin
          indx := indx + 1;
          e_list := parseArr(tokens, indx);
          mem := e_list.to_json_value;
        end;
      when '{' then
        indx := indx + 1;
        mem := parseObj(tokens, indx).to_json_value;
      else
        p_error('Found '||tok.type_name, tok);
    end case;
    mem.mapname := mem_name;
    mem.mapindx := mem_indx;

    indx := indx + 1;
    return mem;
  end parseMem;

  /*procedure test_duplicate_members(arr in json_member_array, mem_name in varchar2, wheretok rToken) as
  begin
    for i in 1 .. arr.count loop
      if(arr(i).member_name = mem_name) then
        p_error('Duplicate member name', wheretok);
      end if;
    end loop;
  end test_duplicate_members;*/

  function parseObj(tokens lTokens, indx in out nocopy pls_integer) return json as
    type memmap is table of number index by varchar2(4000); -- i've read somewhere that this is not possible - but it is!
    mymap memmap;
    nullelemfound boolean := false;

    obj json;
    tok rToken;
    mem_name varchar(4000);
    arr json_value_array := json_value_array();
  begin
    --what to expect?
    while(indx <= tokens.count) loop
      tok := tokens(indx);
      --debug('E: '||tok.type_name);
      case tok.type_name
      when 'STRING' then
        --member
        mem_name := substr(tok.data, 1, 4000);
        begin
          if(mem_name is null) then
            if(nullelemfound) then
              p_error('Duplicate empty member: ', tok);
            else
              nullelemfound := true;
            end if;
          elsif(mymap(mem_name) is not null) then
            p_error('Duplicate member name: '||mem_name, tok);
          end if;
        exception
          when no_data_found then mymap(mem_name) := 1;
        end;

        indx := indx + 1;
        if(indx > tokens.count) then p_error('Unexpected end of input', tok); end if;
        tok := tokens(indx);
        indx := indx + 1;
        if(indx > tokens.count) then p_error('Unexpected end of input', tok); end if;
        if(tok.type_name = ':') then
          --parse
          declare
            jmb json_value;
            x number;
          begin
            x := arr.count + 1;
            jmb := parseMem(tokens, indx, mem_name, x);
            arr.extend;
            arr(x) := jmb;
          end;
        else
          p_error('Expected '':''', tok);
        end if;
        --move indx forward if ',' is found
        if(indx > tokens.count) then p_error('Unexpected end of input', tok); end if;

        tok := tokens(indx);
        if(tok.type_name = ',') then
          --debug('found ,');
          indx := indx + 1;
          tok := tokens(indx);
          if(tok.type_name = '}') then --premature exit
            p_error('Premature exit in json object', tok);
          end if;
        elsif(tok.type_name != '}') then
           p_error('A comma seperator is probably missing', tok);
        end if;
      when '}' then
        obj := json();
        obj.json_data := arr;
        return obj;
      else
        p_error('Expected string or }', tok);
      end case;
    end loop;

    p_error('} not found', tokens(indx-1));

    return obj;

  end;

  function parser(str varchar2) return json as
    tokens lTokens;
    obj json;
    indx pls_integer := 1;
    jsrc json_src;
  begin
    updateDecimalPoint();
    jsrc := prepareVarchar2(str);
    tokens := lexer(jsrc);
    if(tokens(indx).type_name = '{') then
      indx := indx + 1;
      obj := parseObj(tokens, indx);
    else
      raise_application_error(-20101, 'JSON Parser exception - no { start found');
    end if;
    if(tokens.count != indx) then
      p_error('} should end the JSON object', tokens(indx));
    end if;

    return obj;
  end parser;

  function parse_list(str varchar2) return json_list as
    tokens lTokens;
    obj json_list;
    indx pls_integer := 1;
    jsrc json_src;
  begin
    updateDecimalPoint();
    jsrc := prepareVarchar2(str);
    tokens := lexer(jsrc);
    if(tokens(indx).type_name = '[') then
      indx := indx + 1;
      obj := parseArr(tokens, indx);
    else
      raise_application_error(-20101, 'JSON List Parser exception - no [ start found');
    end if;
    if(tokens.count != indx) then
      p_error('] should end the JSON List object', tokens(indx));
    end if;

    return obj;
  end parse_list;

  function parse_list(str clob) return json_list as
    tokens lTokens;
    obj json_list;
    indx pls_integer := 1;
    jsrc json_src;
  begin
    updateDecimalPoint();
    jsrc := prepareClob(str);
    tokens := lexer(jsrc);
    if(tokens(indx).type_name = '[') then
      indx := indx + 1;
      obj := parseArr(tokens, indx);
    else
      raise_application_error(-20101, 'JSON List Parser exception - no [ start found');
    end if;
    if(tokens.count != indx) then
      p_error('] should end the JSON List object', tokens(indx));
    end if;

    return obj;
  end parse_list;

  function parser(str clob) return json as
    tokens lTokens;
    obj json;
    indx pls_integer := 1;
    jsrc json_src;
  begin
    updateDecimalPoint();
    --dbms_output.put_line('Using clob');
    jsrc := prepareClob(str);
    tokens := lexer(jsrc);
    if(tokens(indx).type_name = '{') then
      indx := indx + 1;
      obj := parseObj(tokens, indx);
    else
      raise_application_error(-20101, 'JSON Parser exception - no { start found');
    end if;
    if(tokens.count != indx) then
      p_error('} should end the JSON object', tokens(indx));
    end if;

    return obj;
  end parser;

  function parse_any(str varchar2) return json_value as
    tokens lTokens;
    obj json_list;
    ret json_value;
    indx pls_integer := 1;
    jsrc json_src;
  begin
    updateDecimalPoint();
    jsrc := prepareVarchar2(str);
    tokens := lexer(jsrc);
    tokens(tokens.count+1).type_name := ']';
    obj := parseArr(tokens, indx);
    if(tokens.count != indx) then
      p_error('] should end the JSON List object', tokens(indx));
    end if;

    return obj.head();
  end parse_any;

  function parse_any(str clob) return json_value as
    tokens lTokens;
    obj json_list;
    indx pls_integer := 1;
    jsrc json_src;
  begin
    jsrc := prepareClob(str);
    tokens := lexer(jsrc);
    tokens(tokens.count+1).type_name := ']';
    obj := parseArr(tokens, indx);
    if(tokens.count != indx) then
      p_error('] should end the JSON List object', tokens(indx));
    end if;

    return obj.head();
  end parse_any;

  /* last entry is the one to keep */
  procedure remove_duplicates(obj in out nocopy json) as
    type memberlist is table of json_value index by varchar2(4000);
    members memberlist;
    nulljsonvalue json_value := null;
    validated json := json();
    indx varchar2(4000);
  begin
    for i in 1 .. obj.count loop
      if(obj.get(i).mapname is null) then
        nulljsonvalue := obj.get(i);
      else
        members(obj.get(i).mapname) := obj.get(i);
      end if;
    end loop;

    validated.check_duplicate(false);
    indx := members.first;
    loop
      exit when indx is null;
      validated.put(indx, members(indx));
      indx := members.next(indx);
    end loop;
    if(nulljsonvalue is not null) then
      validated.put('', nulljsonvalue);
    end if;

    validated.check_for_duplicate := obj.check_for_duplicate;

    obj := validated;
  end;

  function get_version return varchar2 as
  begin
    return 'PL/JSON v1.0.4';
  end get_version;

end json_parser;
/

-------------------------------------
--  New package body json_printer  --
-------------------------------------
create or replace package body "JSON_PRINTER" as
  max_line_len number := 0;
  cur_line_len number := 0;

  function llcheck(str in varchar2) return varchar2 as
  begin
    --dbms_output.put_line(cur_line_len || ' : '|| str);
    if(max_line_len > 0 and length(str)+cur_line_len > max_line_len) then
      cur_line_len := length(str);
      return newline_char || str;
    else
      cur_line_len := cur_line_len + length(str);
      return str;
    end if;
  end llcheck;

  function escapeString(str varchar2) return varchar2 as
    sb varchar2(32767) := '';
    buf varchar2(40);
    num number;
  begin
    if(str is null) then return ''; end if;
    for i in 1 .. length(str) loop
      buf := substr(str, i, 1);
      --backspace b = U+0008
      --formfeed  f = U+000C
      --newline   n = U+000A
      --carret    r = U+000D
      --tabulator t = U+0009
      case buf
      when chr( 8) then buf := '\b';
      when chr( 9) then buf := '\t';
      when chr(10) then buf := '\n';
      when chr(12) then buf := '\f';
      when chr(13) then buf := '\r';
      when chr(34) then buf := '\"';
      when chr(47) then if(escape_solidus) then buf := '\/'; end if;
      when chr(92) then buf := '\\';
      else
        if(ascii(buf) < 32) then
          buf := '\u'||replace(substr(to_char(ascii(buf), 'XXXX'),2,4), ' ', '0');
        elsif (ascii_output) then
          buf := replace(asciistr(buf), '\', '\u');
        end if;
      end case;

      sb := sb || buf;
    end loop;

    return sb;
  end escapeString;

  function newline(spaces boolean) return varchar2 as
  begin
    cur_line_len := 0;
    if(spaces) then return newline_char; else return ''; end if;
  end;

/*  function get_schema return varchar2 as
  begin
    return sys_context('userenv', 'current_schema');
  end;
*/
  function tab(indent number, spaces boolean) return varchar2 as
    i varchar(200) := '';
  begin
    if(not spaces) then return ''; end if;
    for x in 1 .. indent loop i := i || indent_string; end loop;
    return i;
  end;

  function getCommaSep(spaces boolean) return varchar2 as
  begin
    if(spaces) then return ', '; else return ','; end if;
  end;

  function getMemName(mem json_value, spaces boolean) return varchar2 as
  begin
    if(spaces) then
      return llcheck('"'||escapeString(mem.mapname)||'"') || llcheck(' : ');
    else
      return llcheck('"'||escapeString(mem.mapname)||'"') || llcheck(':');
    end if;
  end;

/* Clob method start here */
  procedure add_to_clob(buf_lob in out nocopy clob, buf_str in out nocopy varchar2, str varchar2) as
  begin
    if(lengthb(str) > 32767 - lengthb(buf_str)) then
--      dbms_lob.append(buf_lob, buf_str);
      dbms_lob.writeappend(buf_lob, length(buf_str), buf_str);
      buf_str := str;
    else
      buf_str := buf_str || str;
    end if;
  end add_to_clob;

  procedure flush_clob(buf_lob in out nocopy clob, buf_str in out nocopy varchar2) as
  begin
--    dbms_lob.append(buf_lob, buf_str);
    dbms_lob.writeappend(buf_lob, length(buf_str), buf_str);
  end flush_clob;

  procedure ppObj(obj json, indent number, buf in out nocopy clob, spaces boolean, buf_str in out nocopy varchar2);

  procedure ppEA(input json_list, indent number, buf in out nocopy clob, spaces boolean, buf_str in out nocopy varchar2) as
    elem json_value;
    arr json_value_array := input.list_data;
    numbuf varchar2(4000);
  begin
    for y in 1 .. arr.count loop
      elem := arr(y);
      if(elem is not null) then
      case elem.get_type
        when 'number' then
          numbuf := '';
          if (elem.get_number < 1 and elem.get_number > 0) then numbuf := '0'; end if;
          if (elem.get_number < 0 and elem.get_number > -1) then
            numbuf := '-0';
            numbuf := numbuf || substr(to_char(elem.get_number, 'TM9', 'NLS_NUMERIC_CHARACTERS=''.,'''),2);
          else
            numbuf := numbuf || to_char(elem.get_number, 'TM9', 'NLS_NUMERIC_CHARACTERS=''.,''');
          end if;
          add_to_clob(buf, buf_str, llcheck(numbuf));
        when 'string' then
          if(elem.extended_str is not null) then --clob implementation
            add_to_clob(buf, buf_str, case when elem.num = 1 then '"' else '/**/' end);
            declare
              offset number := 1;
              v_str varchar(32767);
              amount number := 32767;
            begin
              while(offset <= dbms_lob.getlength(elem.extended_str)) loop
                dbms_lob.read(elem.extended_str, amount, offset, v_str);
                if(elem.num = 1) then
                  add_to_clob(buf, buf_str, escapeString(v_str));
                else
                  add_to_clob(buf, buf_str, v_str);
                end if;
                offset := offset + amount;
              end loop;
            end;
            add_to_clob(buf, buf_str, case when elem.num = 1 then '"' else '/**/' end || newline_char);
          else
            if(elem.num = 1) then
              add_to_clob(buf, buf_str, llcheck('"'||escapeString(elem.get_string)||'"'));
            else
              add_to_clob(buf, buf_str, llcheck('/**/'||elem.get_string||'/**/'));
            end if;
          end if;
        when 'bool' then
          if(elem.get_bool) then
            add_to_clob(buf, buf_str, llcheck('true'));
          else
            add_to_clob(buf, buf_str, llcheck('false'));
          end if;
        when 'null' then
          add_to_clob(buf, buf_str, llcheck('null'));
        when 'array' then
          add_to_clob(buf, buf_str, llcheck('['));
          ppEA(json_list(elem), indent, buf, spaces, buf_str);
          add_to_clob(buf, buf_str, llcheck(']'));
        when 'object' then
          ppObj(json(elem), indent, buf, spaces, buf_str);
        else add_to_clob(buf, buf_str, llcheck(elem.get_type));
      end case;
      end if;
      if(y != arr.count) then add_to_clob(buf, buf_str, llcheck(getCommaSep(spaces))); end if;
    end loop;
  end ppEA;

  procedure ppMem(mem json_value, indent number, buf in out nocopy clob, spaces boolean, buf_str in out nocopy varchar2) as
    numbuf varchar2(4000);
  begin
    add_to_clob(buf, buf_str, llcheck(tab(indent, spaces)) || llcheck(getMemName(mem, spaces)));
    case mem.get_type
      when 'number' then
        if (mem.get_number < 1 and mem.get_number > 0) then numbuf := '0'; end if;
        if (mem.get_number < 0 and mem.get_number > -1) then
          numbuf := '-0';
          numbuf := numbuf || substr(to_char(mem.get_number, 'TM9', 'NLS_NUMERIC_CHARACTERS=''.,'''),2);
        else
          numbuf := numbuf || to_char(mem.get_number, 'TM9', 'NLS_NUMERIC_CHARACTERS=''.,''');
        end if;
        add_to_clob(buf, buf_str, llcheck(numbuf));
      when 'string' then
        if(mem.extended_str is not null) then --clob implementation
          add_to_clob(buf, buf_str, case when mem.num = 1 then '"' else '/**/' end);
          declare
            offset number := 1;
            v_str varchar(32767);
            amount number := 32767;
          begin
--            dbms_output.put_line('SIZE:'||dbms_lob.getlength(mem.extended_str));
            while(offset <= dbms_lob.getlength(mem.extended_str)) loop
--            dbms_output.put_line('OFFSET:'||offset);
 --             v_str := dbms_lob.substr(mem.extended_str, 8192, offset);
              dbms_lob.read(mem.extended_str, amount, offset, v_str);
--            dbms_output.put_line('VSTR_SIZE:'||length(v_str));
              if(mem.num = 1) then
                add_to_clob(buf, buf_str, escapeString(v_str));
              else
                add_to_clob(buf, buf_str, v_str);
              end if;
              offset := offset + amount;
            end loop;
          end;
          add_to_clob(buf, buf_str, case when mem.num = 1 then '"' else '/**/' end || newline_char);
        else
          if(mem.num = 1) then
            add_to_clob(buf, buf_str, llcheck('"'||escapeString(mem.get_string)||'"'));
          else
            add_to_clob(buf, buf_str, llcheck('/**/'||mem.get_string||'/**/'));
          end if;
        end if;
      when 'bool' then
        if(mem.get_bool) then
          add_to_clob(buf, buf_str, llcheck('true'));
        else
          add_to_clob(buf, buf_str, llcheck('false'));
        end if;
      when 'null' then
        add_to_clob(buf, buf_str, llcheck('null'));
      when 'array' then
        add_to_clob(buf, buf_str, llcheck('['));
        ppEA(json_list(mem), indent, buf, spaces, buf_str);
        add_to_clob(buf, buf_str, llcheck(']'));
      when 'object' then
        ppObj(json(mem), indent, buf, spaces, buf_str);
      else add_to_clob(buf, buf_str, llcheck(mem.get_type));
    end case;
  end ppMem;

  procedure ppObj(obj json, indent number, buf in out nocopy clob, spaces boolean, buf_str in out nocopy varchar2) as
  begin
    add_to_clob(buf, buf_str, llcheck('{') || newline(spaces));
    for m in 1 .. obj.json_data.count loop
      ppMem(obj.json_data(m), indent+1, buf, spaces, buf_str);
      if(m != obj.json_data.count) then
        add_to_clob(buf, buf_str, llcheck(',') || newline(spaces));
      else
        add_to_clob(buf, buf_str, newline(spaces));
      end if;
    end loop;
    add_to_clob(buf, buf_str, llcheck(tab(indent, spaces)) || llcheck('}')); -- || chr(13);
  end ppObj;

  procedure pretty_print(obj json, spaces boolean default true, buf in out nocopy clob, line_length number default 0, erase_clob boolean default true) as
    buf_str varchar2(32767);
    amount number := dbms_lob.getlength(buf);
  begin
    if(erase_clob and amount > 0) then dbms_lob.trim(buf, 0); dbms_lob.erase(buf, amount); end if;

    max_line_len := line_length;
    cur_line_len := 0;
    ppObj(obj, 0, buf, spaces, buf_str);
    flush_clob(buf, buf_str);
  end;

  procedure pretty_print_list(obj json_list, spaces boolean default true, buf in out nocopy clob, line_length number default 0, erase_clob boolean default true) as
    buf_str varchar2(32767);
    amount number := dbms_lob.getlength(buf);
  begin
    if(erase_clob and amount > 0) then dbms_lob.trim(buf, 0); dbms_lob.erase(buf, amount); end if;

    max_line_len := line_length;
    cur_line_len := 0;
    add_to_clob(buf, buf_str, llcheck('['));
    ppEA(obj, 0, buf, spaces, buf_str);
    add_to_clob(buf, buf_str, llcheck(']'));
    flush_clob(buf, buf_str);
  end;

  procedure pretty_print_any(json_part json_value, spaces boolean default true, buf in out nocopy clob, line_length number default 0, erase_clob boolean default true) as
    buf_str varchar2(32767) := '';
    numbuf varchar2(4000);
    amount number := dbms_lob.getlength(buf);
  begin
    if(erase_clob and amount > 0) then dbms_lob.trim(buf, 0); dbms_lob.erase(buf, amount); end if;

    case json_part.get_type
      when 'number' then
        if (json_part.get_number < 1 and json_part.get_number > 0) then numbuf := '0'; end if;
        if (json_part.get_number < 0 and json_part.get_number > -1) then
          numbuf := '-0';
          numbuf := numbuf || substr(to_char(json_part.get_number, 'TM9', 'NLS_NUMERIC_CHARACTERS=''.,'''),2);
        else
          numbuf := numbuf || to_char(json_part.get_number, 'TM9', 'NLS_NUMERIC_CHARACTERS=''.,''');
        end if;
        add_to_clob(buf, buf_str, numbuf);
      when 'string' then
        if(json_part.extended_str is not null) then --clob implementation
          add_to_clob(buf, buf_str, case when json_part.num = 1 then '"' else '/**/' end);
          declare
            offset number := 1;
            v_str varchar(32767);
            amount number := 32767;
          begin
            while(offset <= dbms_lob.getlength(json_part.extended_str)) loop
              dbms_lob.read(json_part.extended_str, amount, offset, v_str);
              if(json_part.num = 1) then
                add_to_clob(buf, buf_str, escapeString(v_str));
              else
                add_to_clob(buf, buf_str, v_str);
              end if;
              offset := offset + amount;
            end loop;
          end;
          add_to_clob(buf, buf_str, case when json_part.num = 1 then '"' else '/**/' end);
        else
          if(json_part.num = 1) then
            add_to_clob(buf, buf_str, llcheck('"'||escapeString(json_part.get_string)||'"'));
          else
            add_to_clob(buf, buf_str, llcheck('/**/'||json_part.get_string||'/**/'));
          end if;
        end if;
      when 'bool' then
	      if(json_part.get_bool) then
          add_to_clob(buf, buf_str, 'true');
        else
          add_to_clob(buf, buf_str, 'false');
        end if;
      when 'null' then
        add_to_clob(buf, buf_str, 'null');
      when 'array' then
        pretty_print_list(json_list(json_part), spaces, buf, line_length);
        return;
      when 'object' then
        pretty_print(json(json_part), spaces, buf, line_length);
        return;
      else add_to_clob(buf, buf_str, 'unknown type:'|| json_part.get_type);
    end case;
    flush_clob(buf, buf_str);
  end;

/* Clob method end here */

/* Varchar2 method start here */

  procedure ppObj(obj json, indent number, buf in out nocopy varchar2, spaces boolean);

  procedure ppEA(input json_list, indent number, buf in out varchar2, spaces boolean) as
    elem json_value;
    arr json_value_array := input.list_data;
    str varchar2(400);
  begin
    for y in 1 .. arr.count loop
      elem := arr(y);
      if(elem is not null) then
      case elem.get_type
        when 'number' then
          str := '';
          if (elem.get_number < 1 and elem.get_number > 0) then str := '0'; end if;
          if (elem.get_number < 0 and elem.get_number > -1) then
            str := '-0' || substr(to_char(elem.get_number, 'TM9', 'NLS_NUMERIC_CHARACTERS=''.,'''),2);
          else
            str := str || to_char(elem.get_number, 'TM9', 'NLS_NUMERIC_CHARACTERS=''.,''');
          end if;
          buf := buf || llcheck(str);
        when 'string' then
          if(elem.num = 1) then
            buf := buf || llcheck('"'||escapeString(elem.get_string)||'"');
          else
            buf := buf || llcheck('/**/'||elem.get_string||'/**/');
          end if;
        when 'bool' then
          if(elem.get_bool) then
            buf := buf || llcheck('true');
          else
            buf := buf || llcheck('false');
          end if;
        when 'null' then
          buf := buf || llcheck('null');
        when 'array' then
          buf := buf || llcheck('[');
          ppEA(json_list(elem), indent, buf, spaces);
          buf := buf || llcheck(']');
        when 'object' then
          ppObj(json(elem), indent, buf, spaces);
        else buf := buf || llcheck(elem.get_type); /* should never happen */
      end case;
      end if;
      if(y != arr.count) then buf := buf || llcheck(getCommaSep(spaces)); end if;
    end loop;
  end ppEA;

  procedure ppMem(mem json_value, indent number, buf in out nocopy varchar2, spaces boolean) as
    str varchar2(400) := '';
  begin
    buf := buf || llcheck(tab(indent, spaces)) || getMemName(mem, spaces);
    case mem.get_type
      when 'number' then
        if (mem.get_number < 1 and mem.get_number > 0) then str := '0'; end if;
        if (mem.get_number < 0 and mem.get_number > -1) then
          str := '-0' || substr(to_char(mem.get_number, 'TM9', 'NLS_NUMERIC_CHARACTERS=''.,'''),2);
        else
          str := str || to_char(mem.get_number, 'TM9', 'NLS_NUMERIC_CHARACTERS=''.,''');
        end if;
        buf := buf || llcheck(str);
      when 'string' then
        if(mem.num = 1) then
          buf := buf || llcheck('"'||escapeString(mem.get_string)||'"');
        else
          buf := buf || llcheck('/**/'||mem.get_string||'/**/');
        end if;
      when 'bool' then
        if(mem.get_bool) then
          buf := buf || llcheck('true');
        else
          buf := buf || llcheck('false');
        end if;
      when 'null' then
        buf := buf || llcheck('null');
      when 'array' then
        buf := buf || llcheck('[');
        ppEA(json_list(mem), indent, buf, spaces);
        buf := buf || llcheck(']');
      when 'object' then
        ppObj(json(mem), indent, buf, spaces);
      else buf := buf || llcheck(mem.get_type); /* should never happen */
    end case;
  end ppMem;

  procedure ppObj(obj json, indent number, buf in out nocopy varchar2, spaces boolean) as
  begin
    buf := buf || llcheck('{') || newline(spaces);
    for m in 1 .. obj.json_data.count loop
      ppMem(obj.json_data(m), indent+1, buf, spaces);
      if(m != obj.json_data.count) then buf := buf || llcheck(',') || newline(spaces);
      else buf := buf || newline(spaces); end if;
    end loop;
    buf := buf || llcheck(tab(indent, spaces)) || llcheck('}'); -- || chr(13);
  end ppObj;

  function pretty_print(obj json, spaces boolean default true, line_length number default 0) return varchar2 as
    buf varchar2(32767) := '';
  begin
    max_line_len := line_length;
    cur_line_len := 0;
    ppObj(obj, 0, buf, spaces);
    return buf;
  end pretty_print;

  function pretty_print_list(obj json_list, spaces boolean default true, line_length number default 0) return varchar2 as
    buf varchar2(32767);
  begin
    max_line_len := line_length;
    cur_line_len := 0;
    buf := llcheck('[');
    ppEA(obj, 0, buf, spaces);
    buf := buf || llcheck(']');
    return buf;
  end;

  function pretty_print_any(json_part json_value, spaces boolean default true, line_length number default 0) return varchar2 as
    buf varchar2(32767) := '';
  begin
    case json_part.get_type
      when 'number' then
        if (json_part.get_number() < 1 and json_part.get_number() > 0) then buf := buf || '0'; end if;
        if (json_part.get_number() < 0 and json_part.get_number() > -1) then
          buf := buf || '-0';
          buf := buf || substr(to_char(json_part.get_number(), 'TM9', 'NLS_NUMERIC_CHARACTERS=''.,'''),2);
        else
          buf := buf || to_char(json_part.get_number(), 'TM9', 'NLS_NUMERIC_CHARACTERS=''.,''');
        end if;
      when 'string' then
        if(json_part.num = 1) then
          buf := buf || '"'||escapeString(json_part.get_string)||'"';
        else
          buf := buf || '/**/'||json_part.get_string||'/**/';
        end if;
      when 'bool' then
      	if(json_part.get_bool) then buf := 'true'; else buf := 'false'; end if;
      when 'null' then
        buf := 'null';
      when 'array' then
        buf := pretty_print_list(json_list(json_part), spaces, line_length);
      when 'object' then
        buf := pretty_print(json(json_part), spaces, line_length);
      else buf := 'weird error: '|| json_part.get_type;
    end case;
    return buf;
  end;

  procedure dbms_output_clob(my_clob clob, delim varchar2, jsonp varchar2 default null) as
    prev number := 1;
    indx number := 1;
    size_of_nl number := lengthb(delim);
    v_str varchar2(32767);
    amount number := 32767;
  begin
    if(jsonp is not null) then dbms_output.put_line(jsonp||'('); end if;
    while(indx != 0) loop
      --read every line
      indx := dbms_lob.instr(my_clob, delim, prev+1);
 --     dbms_output.put_line(prev || ' to ' || indx);

      if(indx = 0) then
        --emit from prev to end;
        amount := 32767;
 --       dbms_output.put_line(' mycloblen ' || dbms_lob.getlength(my_clob));
        loop
          dbms_lob.read(my_clob, amount, prev, v_str);
          dbms_output.put_line(v_str);
          prev := prev+amount-1;
          exit when prev >= dbms_lob.getlength(my_clob);
        end loop;
      else
        amount := indx - prev;
        if(amount > 32767) then
          amount := 32767;
--          dbms_output.put_line(' mycloblen ' || dbms_lob.getlength(my_clob));
          loop
            dbms_lob.read(my_clob, amount, prev, v_str);
            dbms_output.put_line(v_str);
            prev := prev+amount-1;
            amount := indx - prev;
            exit when prev >= indx - 1;
            if(amount > 32767) then amount := 32767; end if;
          end loop;
          prev := indx + size_of_nl;
        else
          dbms_lob.read(my_clob, amount, prev, v_str);
          dbms_output.put_line(v_str);
          prev := indx + size_of_nl;
        end if;
      end if;

    end loop;
    if(jsonp is not null) then dbms_output.put_line(')'); end if;

/*    while (amount != 0) loop
      indx := dbms_lob.instr(my_clob, delim, prev+1);

--      dbms_output.put_line(prev || ' to ' || indx);
      if(indx = 0) then
        indx := dbms_lob.getlength(my_clob)+1;
      end if;

      if(indx-prev > 32767) then
        indx := prev+32767;
      end if;
--      dbms_output.put_line(prev || ' to ' || indx);
      --substr doesnt work properly on all platforms! (come on oracle - error on Oracle VM for virtualbox)
--        dbms_output.put_line(dbms_lob.substr(my_clob, indx-prev, prev));
      amount := indx-prev;
--        dbms_output.put_line('amount'||amount);
      dbms_lob.read(my_clob, amount, prev, v_str);
      dbms_output.put_line(v_str);
      prev := indx+size_of_nl;
      if(amount = 32767) then prev := prev-size_of_nl-1; end if;
    end loop;
    if(jsonp is not null) then dbms_output.put_line(')'); end if;*/
  end;


/*  procedure dbms_output_clob(my_clob clob, delim varchar2, jsonp varchar2 default null) as
    prev number := 1;
    indx number := 1;
    size_of_nl number := lengthb(delim);
    v_str varchar2(32767);
    amount number;
  begin
    if(jsonp is not null) then dbms_output.put_line(jsonp||'('); end if;
    while (indx != 0) loop
      indx := dbms_lob.instr(my_clob, delim, prev+1);

--      dbms_output.put_line(prev || ' to ' || indx);
      if(indx-prev > 32767) then
        indx := prev+32767;
      end if;
--      dbms_output.put_line(prev || ' to ' || indx);
      --substr doesnt work properly on all platforms! (come on oracle - error on Oracle VM for virtualbox)
      if(indx = 0) then
--        dbms_output.put_line(dbms_lob.substr(my_clob, dbms_lob.getlength(my_clob)-prev+size_of_nl, prev));
        amount := dbms_lob.getlength(my_clob)-prev+size_of_nl;
        dbms_lob.read(my_clob, amount, prev, v_str);
      else
--        dbms_output.put_line(dbms_lob.substr(my_clob, indx-prev, prev));
        amount := indx-prev;
--        dbms_output.put_line('amount'||amount);
        dbms_lob.read(my_clob, amount, prev, v_str);
      end if;
      dbms_output.put_line(v_str);
      prev := indx+size_of_nl;
      if(amount = 32767) then prev := prev-size_of_nl-1; end if;
    end loop;
    if(jsonp is not null) then dbms_output.put_line(')'); end if;
  end;
*/
  procedure htp_output_clob(my_clob clob, jsonp varchar2 default null) as
    /*amount number := 4096;
    pos number := 1;
    len number;
    */
    l_amt    number default 30;
    l_off   number default 1;
    l_str   varchar2(4096);

  begin
    if(jsonp is not null) then htp.prn(jsonp||'('); end if;

    begin
      loop
        dbms_lob.read( my_clob, l_amt, l_off, l_str );

        -- it is vital to use htp.PRN to avoid
        -- spurious line feeds getting added to your
        -- document
        htp.prn( l_str  );
        l_off := l_off+l_amt;
        l_amt := 4096;
      end loop;
    exception
      when no_data_found then NULL;
    end;

    /*
    len := dbms_lob.getlength(my_clob);

    while(pos < len) loop
      htp.prn(dbms_lob.substr(my_clob, amount, pos)); -- should I replace substr with dbms_lob.read?
      --dbms_output.put_line(dbms_lob.substr(my_clob, amount, pos));
      pos := pos + amount;
    end loop;
    */
    if(jsonp is not null) then htp.prn(')'); end if;
  end;

end json_printer;
/

--------------------------------------
--  New package body json_util_pkg  --
--------------------------------------
create or replace package body json_util_pkg
as
  scanner_exception exception;
  pragma exception_init(scanner_exception, -20100);
  parser_exception exception;
  pragma exception_init(parser_exception, -20101);

  /*

  Purpose:    JSON utilities for PL/SQL

  Remarks:

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     30.01.2010  Created

  */


  g_json_null_object             constant varchar2(20) := '{ }';


function get_xml_to_json_stylesheet return varchar2
as
begin

  /*

  Purpose:    return XSLT stylesheet for XML to JSON transformation

  Remarks:    see http://code.google.com/p/xml2json-xslt/

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     30.01.2010  Created
  MBR     30.01.2010  Added fix for nulls

  */


  return q'^<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!--
  Copyright (c) 2006,2008 Doeke Zanstra
  All rights reserved.

  Redistribution and use in source and binary forms, with or without modification,
  are permitted provided that the following conditions are met:

  Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer. Redistributions in binary
  form must reproduce the above copyright notice, this list of conditions and the
  following disclaimer in the documentation and/or other materials provided with
  the distribution.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
  THE POSSIBILITY OF SUCH DAMAGE.
-->

  <xsl:output indent="no" omit-xml-declaration="yes" method="text" encoding="UTF-8" media-type="text/x-json"/>
        <xsl:strip-space elements="*"/>
  <!--contant-->
  <xsl:variable name="d">0123456789</xsl:variable>

  <!-- ignore document text -->
  <xsl:template match="text()[preceding-sibling::node() or following-sibling::node()]"/>

  <!-- string -->
  <xsl:template match="text()">
    <xsl:call-template name="escape-string">
      <xsl:with-param name="s" select="."/>
    </xsl:call-template>
  </xsl:template>

  <!-- Main template for escaping strings; used by above template and for object-properties
       Responsibilities: placed quotes around string, and chain up to next filter, escape-bs-string -->
  <xsl:template name="escape-string">
    <xsl:param name="s"/>
    <xsl:text>"</xsl:text>
    <xsl:call-template name="escape-bs-string">
      <xsl:with-param name="s" select="$s"/>
    </xsl:call-template>
    <xsl:text>"</xsl:text>
  </xsl:template>

  <!-- Escape the backslash (\) before everything else. -->
  <xsl:template name="escape-bs-string">
    <xsl:param name="s"/>
    <xsl:choose>
      <xsl:when test="contains($s,'\')">
        <xsl:call-template name="escape-quot-string">
          <xsl:with-param name="s" select="concat(substring-before($s,'\'),'\\')"/>
        </xsl:call-template>
        <xsl:call-template name="escape-bs-string">
          <xsl:with-param name="s" select="substring-after($s,'\')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="escape-quot-string">
          <xsl:with-param name="s" select="$s"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Escape the double quote ("). -->
  <xsl:template name="escape-quot-string">
    <xsl:param name="s"/>
    <xsl:choose>
      <xsl:when test="contains($s,'&quot;')">
        <xsl:call-template name="encode-string">
          <xsl:with-param name="s" select="concat(substring-before($s,'&quot;'),'\&quot;')"/>
        </xsl:call-template>
        <xsl:call-template name="escape-quot-string">
          <xsl:with-param name="s" select="substring-after($s,'&quot;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="encode-string">
          <xsl:with-param name="s" select="$s"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Replace tab, line feed and/or carriage return by its matching escape code. Can't escape backslash
       or double quote here, because they don't replace characters (&#x0; becomes \t), but they prefix
       characters (\ becomes \\). Besides, backslash should be seperate anyway, because it should be
       processed first. This function can't do that. -->
  <xsl:template name="encode-string">
    <xsl:param name="s"/>
    <xsl:choose>
      <!-- tab -->
      <xsl:when test="contains($s,'&#x9;')">
        <xsl:call-template name="encode-string">
          <xsl:with-param name="s" select="concat(substring-before($s,'&#x9;'),'\t',substring-after($s,'&#x9;'))"/>
        </xsl:call-template>
      </xsl:when>
      <!-- line feed -->
      <xsl:when test="contains($s,'&#xA;')">
        <xsl:call-template name="encode-string">
          <xsl:with-param name="s" select="concat(substring-before($s,'&#xA;'),'\n',substring-after($s,'&#xA;'))"/>
        </xsl:call-template>
      </xsl:when>
      <!-- carriage return -->
      <xsl:when test="contains($s,'&#xD;')">
        <xsl:call-template name="encode-string">
          <xsl:with-param name="s" select="concat(substring-before($s,'&#xD;'),'\r',substring-after($s,'&#xD;'))"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$s"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- number (no support for javascript mantissa) -->
  <xsl:template match="text()[not(string(number())='NaN' or
                      (starts-with(.,'0' ) and . != '0' and
not(starts-with(.,'0.' ))) or
                      (starts-with(.,'-0' ) and . != '-0' and
not(starts-with(.,'-0.' )))
                      )]">
    <xsl:value-of select="."/>
  </xsl:template>

  <!-- boolean, case-insensitive -->
  <xsl:template match="text()[translate(.,'TRUE','true')='true']">true</xsl:template>
  <xsl:template match="text()[translate(.,'FALSE','false')='false']">false</xsl:template>

  <!-- object -->
  <xsl:template match="*" name="base">
    <xsl:if test="not(preceding-sibling::*)">{</xsl:if>
    <xsl:call-template name="escape-string">
      <xsl:with-param name="s" select="name()"/>
    </xsl:call-template>
    <xsl:text>:</xsl:text>
    <!-- check type of node -->
    <xsl:choose>
      <!-- null nodes -->
      <xsl:when test="count(child::node())=0">null</xsl:when>
      <!-- other nodes -->
      <xsl:otherwise>
        <xsl:apply-templates select="child::node()"/>
      </xsl:otherwise>
    </xsl:choose>
    <!-- end of type check -->
    <xsl:if test="following-sibling::*">,</xsl:if>
    <xsl:if test="not(following-sibling::*)">}</xsl:if>
  </xsl:template>

  <!-- array -->
  <xsl:template match="*[count(../*[name(../*)=name(.)])=count(../*) and count(../*)&gt;1]">
    <xsl:if test="not(preceding-sibling::*)">[</xsl:if>
    <xsl:choose>
      <xsl:when test="not(child::node())">
        <xsl:text>null</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="child::node()"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="following-sibling::*">,</xsl:if>
    <xsl:if test="not(following-sibling::*)">]</xsl:if>
  </xsl:template>

  <!-- convert root element to an anonymous container -->
  <xsl:template match="/">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

</xsl:stylesheet>^';

end get_xml_to_json_stylesheet;


function ref_cursor_to_json (p_ref_cursor in sys_refcursor,
                             p_max_rows in number := null,
                             p_skip_rows in number := null) return json_list
as
  l_ctx         dbms_xmlgen.ctxhandle;
  l_num_rows    pls_integer;
  l_xml         xmltype;
  l_json        xmltype;
  l_returnvalue clob;
begin

  /*

  Purpose:    generate JSON from REF Cursor

  Remarks:

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     30.01.2010  Created
  JKR     01.05.2010  Edited to fit in PL/JSON

  */

  l_ctx := dbms_xmlgen.newcontext (p_ref_cursor);

  dbms_xmlgen.setnullhandling (l_ctx, dbms_xmlgen.empty_tag);

  -- for pagination

  if p_max_rows is not null then
    dbms_xmlgen.setmaxrows (l_ctx, p_max_rows);
  end if;

  if p_skip_rows is not null then
    dbms_xmlgen.setskiprows (l_ctx, p_skip_rows);
  end if;

  -- get the XML content
  l_xml := dbms_xmlgen.getxmltype (l_ctx, dbms_xmlgen.none);

  l_num_rows := dbms_xmlgen.getnumrowsprocessed (l_ctx);

  dbms_xmlgen.closecontext (l_ctx);

  close p_ref_cursor;

  if l_num_rows > 0 then
    -- perform the XSL transformation
    l_json := l_xml.transform (xmltype(get_xml_to_json_stylesheet));
    l_returnvalue := l_json.getclobval();
  else
    l_returnvalue := g_json_null_object;
  end if;

  l_returnvalue := dbms_xmlgen.convert (l_returnvalue, dbms_xmlgen.entity_decode);

  if(l_num_rows = 0) then
    return json_list();
  else
    if(l_num_rows = 1) then
      declare ret json_list := json_list();
      begin
        ret.append(
          json(
            json(l_returnvalue).get('ROWSET')
          ).get('ROW')
        );
        return ret;
      end;
    else
      return json_list(json(l_returnvalue).get('ROWSET'));
    end if;
  end if;

exception
  when scanner_exception then
    dbms_output.put('Scanner problem with the following input: ');
    dbms_output.put_line(l_returnvalue);
    raise;
  when parser_exception then
    dbms_output.put('Parser problem with the following input: ');
    dbms_output.put_line(l_returnvalue);
    raise;
  when others then raise;
end ref_cursor_to_json;

function sql_to_json (p_sql in varchar2,
                      p_max_rows in number := null,
                      p_skip_rows in number := null) return json_list
as
  v_cur sys_refcursor;
begin
  open v_cur for p_sql;
  return ref_cursor_to_json(v_cur, p_max_rows, p_skip_rows);

end sql_to_json;


end json_util_pkg;
/

---------------------------------
--  New package body json_xml  --
---------------------------------
create or replace package body json_xml as

  function escapeStr(str varchar2) return varchar2 as
    buf varchar2(32767) := '';
    ch varchar2(4);
  begin
    for i in 1 .. length(str) loop
      ch := substr(str, i, 1);
      case ch
      when '&' then buf := buf || '&amp;';
      when '<' then buf := buf || '&lt;';
      when '>' then buf := buf || '&gt;';
      when '"' then buf := buf || '&quot;';
      else buf := buf || ch;
      end case;
    end loop;
    return buf;
  end escapeStr;

/* Clob methods from printer */
  procedure add_to_clob(buf_lob in out nocopy clob, buf_str in out nocopy varchar2, str varchar2) as
  begin
    if(length(str) > 32767 - length(buf_str)) then
      dbms_lob.append(buf_lob, buf_str);
      buf_str := str;
    else
      buf_str := buf_str || str;
    end if;
  end add_to_clob;

  procedure flush_clob(buf_lob in out nocopy clob, buf_str in out nocopy varchar2) as
  begin
    dbms_lob.append(buf_lob, buf_str);
  end flush_clob;

  procedure toString(obj json_value, tagname in varchar2, xmlstr in out nocopy clob, xmlbuf in out nocopy varchar2) as
    v_obj json;
    v_list json_list;

    v_keys json_list;
    v_value json_value;
    key_str varchar2(4000);
  begin
    if (obj.is_object()) then
      add_to_clob(xmlstr, xmlbuf, '<' || tagname || '>');
      v_obj := json(obj);

      v_keys := v_obj.get_keys();
      for i in 1 .. v_keys.count loop
        v_value := v_obj.get(i);
        key_str := v_keys.get(i).str;

        if(key_str = 'content') then
          if(v_value.is_array()) then
            declare
              v_l json_list := json_list(v_value);
            begin
              for j in 1 .. v_l.count loop
                if(j > 1) then add_to_clob(xmlstr, xmlbuf, chr(13)||chr(10)); end if;
                add_to_clob(xmlstr, xmlbuf, escapeStr(v_l.get(j).to_char()));
              end loop;
            end;
          else
            add_to_clob(xmlstr, xmlbuf, escapeStr(v_value.to_char()));
          end if;
        elsif(v_value.is_array()) then
          declare
            v_l json_list := json_list(v_value);
          begin
            for j in 1 .. v_l.count loop
              v_value := v_l.get(j);
              if(v_value.is_array()) then
                add_to_clob(xmlstr, xmlbuf, '<' || key_str || '>');
                add_to_clob(xmlstr, xmlbuf, escapeStr(v_value.to_char()));
                add_to_clob(xmlstr, xmlbuf, '</' || key_str || '>');
              else
                toString(v_value, key_str, xmlstr, xmlbuf);
              end if;
            end loop;
          end;
        elsif(v_value.is_null() or (v_value.is_string and v_value.get_string = '')) then
          add_to_clob(xmlstr, xmlbuf, '<' || key_str || '/>');
        else
          toString(v_value, key_str, xmlstr, xmlbuf);
        end if;
      end loop;

      add_to_clob(xmlstr, xmlbuf, '</' || tagname || '>');
    elsif (obj.is_array()) then
      v_list := json_list(obj);
      for i in 1 .. v_list.count loop
        v_value := v_list.get(i);
        toString(v_value, nvl(tagname, 'array'), xmlstr, xmlbuf);
      end loop;
    else
      add_to_clob(xmlstr, xmlbuf, '<' || tagname || '>'||escapeStr(obj.to_char())||'</' || tagname || '>');
    end if;
  end toString;

  function json_to_xml(obj json, tagname varchar2 default 'root') return xmltype as
    xmlstr clob := empty_clob();
    xmlbuf varchar2(32767) := '';
    returnValue xmltype;
  begin
    dbms_lob.createtemporary(xmlstr, true);

    toString(obj.to_json_value(), tagname, xmlstr, xmlbuf);

    flush_clob(xmlstr, xmlbuf);
    returnValue := xmltype('<?xml version="1.0"?>'||xmlstr);
    dbms_lob.freetemporary(xmlstr);
    return returnValue;
  end;

end json_xml;
/

----------------------------------------
--  New type type_agency_amount_info  --
----------------------------------------
create or replace type type_agency_amount_info is object
/*********************************************************************/
----------------- 实体定义: 批量更新销售站余额    --------------------
/*********************************************************************/
(

-----------    实体字段定义    -----------------
  agency_code       char(2),         --游戏编号
  amount            number(12)          --调增金额
);
/

----------------------------------------
--  New type type_agency_amount_list  --
----------------------------------------
create or replace type type_agency_amount_list as table of type_agency_amount_info
/*********************************************************************/
------------ 数组定义: 批量更新销售站余额   -------------
/*********************************************************************/
/

-----------------------------------------------
--  New type type_agency_game_auth_info_mon  --
-----------------------------------------------
create or replace type type_agency_game_auth_info_mon is object
/*********************************************************************/
------------ 适用于: 批量销售站授权游戏信息（监控）  ---------------
/*********************************************************************/
(

-----------    实体字段定义    -----------------
  gamecode                number(5),          --游戏编号
  agencycode              char(8),         --销售站编码
  isenabled               number(1)           --是否有效
);
/

-----------------------------------------------
--  New type type_agency_game_auth_list_mon  --
-----------------------------------------------
create or replace type type_agency_game_auth_list_mon as table of type_agency_game_auth_info_mon;
/*********************************************************************/
------------ 适用于: 批量销售站游戏授权数组定义（监控）   -------------
/*********************************************************************/
/

----------------------------------------
--  New type type_game_auth_info_mon  --
----------------------------------------
create or replace type type_game_auth_info_mon is object
/*********************************************************************/
--------- 适用于: 批量插入区域和销售站授权游戏信息（监控）  ----------
/*********************************************************************/
(

-----------    实体字段定义    -----------------
  gamecode                number(3),          --游戏编号
  enabled                 number(1)           --是否有效
);
/

----------------------------------------
--  New type type_game_auth_list_mon  --
----------------------------------------
create or replace type type_game_auth_list_mon as table of type_game_auth_info_mon;
/*********************************************************************/
-------- 适用于: 批量插入游戏授权，入口参数实体数组定义（监控）--------
/*********************************************************************/
/

--------------------------
--  New type body json  --
--------------------------
create or replace type body json as

  /* Constructors */
  constructor function json return self as result as
  begin
    self.json_data := json_value_array();
    self.check_for_duplicate := 1;
    return;
  end;

  constructor function json(str varchar2) return self as result as
  begin
    self := json_parser.parser(str);
    self.check_for_duplicate := 1;
    return;
  end;

  constructor function json(str in clob) return self as result as
  begin
    self := json_parser.parser(str);
    self.check_for_duplicate := 1;
    return;
  end;

  constructor function json(cast json_value) return self as result as
    x number;
  begin
    x := cast.object_or_array.getobject(self);
    self.check_for_duplicate := 1;
    return;
  end;

  constructor function json(l in out nocopy json_list) return self as result as
  begin
    for i in 1 .. l.list_data.count loop
      if(l.list_data(i).mapname is null or l.list_data(i).mapname like 'row%') then
      l.list_data(i).mapname := 'row'||i;
      end if;
      l.list_data(i).mapindx := i;
    end loop;

    self.json_data := l.list_data;
    self.check_for_duplicate := 1;
    return;
  end;

  /* Member setter methods */
  member procedure remove(self in out nocopy json, pair_name varchar2) as
    temp json_value;
    indx pls_integer;

    function get_member(pair_name varchar2) return json_value as
      indx pls_integer;
    begin
      indx := json_data.first;
      loop
        exit when indx is null;
        if(pair_name is null and json_data(indx).mapname is null) then return json_data(indx); end if;
        if(json_data(indx).mapname = pair_name) then return json_data(indx); end if;
        indx := json_data.next(indx);
      end loop;
      return null;
    end;
  begin
    temp := get_member(pair_name);
    if(temp is null) then return; end if;

    indx := json_data.next(temp.mapindx);
    loop
      exit when indx is null;
      json_data(indx).mapindx := indx - 1;
      json_data(indx-1) := json_data(indx);
      indx := json_data.next(indx);
    end loop;
    json_data.trim(1);
    --num_elements := num_elements - 1;
  end;

  member procedure put(self in out nocopy json, pair_name varchar2, pair_value json_value, position pls_integer default null) as
    insert_value json_value := nvl(pair_value, json_value.makenull);
    indx pls_integer; x number;
    temp json_value;
    function get_member(pair_name varchar2) return json_value as
      indx pls_integer;
    begin
      indx := json_data.first;
      loop
        exit when indx is null;
        if(pair_name is null and json_data(indx).mapname is null) then return json_data(indx); end if;
        if(json_data(indx).mapname = pair_name) then return json_data(indx); end if;
        indx := json_data.next(indx);
      end loop;
      return null;
    end;
  begin
    --dbms_output.put_line('PN '||pair_name);

--    if(pair_name is null) then
--      raise_application_error(-20102, 'JSON put-method type error: name cannot be null');
--    end if;
    insert_value.mapname := pair_name;
--    self.remove(pair_name);
    if(self.check_for_duplicate = 1) then temp := get_member(pair_name); else temp := null; end if;
    if(temp is not null) then
      insert_value.mapindx := temp.mapindx;
      json_data(temp.mapindx) := insert_value;
      return;
    elsif(position is null or position > self.count) then
      --insert at the end of the list
      --dbms_output.put_line('Test');
--      indx := self.count + 1;
      json_data.extend(1);
      json_data(json_data.count) := insert_value;
--      insert_value.mapindx := json_data.count;
      json_data(json_data.count).mapindx := json_data.count;
--      dbms_output.put_line('Test2'||insert_value.mapindx);
--      dbms_output.put_line('Test2'||insert_value.mapname);
--      insert_value.print(false);
--      self.print;
    elsif(position < 2) then
      --insert at the start of the list
      indx := json_data.last;
      json_data.extend;
      loop
        exit when indx is null;
        temp := json_data(indx);
        temp.mapindx := indx+1;
        json_data(temp.mapindx) := temp;
        indx := json_data.prior(indx);
      end loop;
      json_data(1) := insert_value;
      insert_value.mapindx := 1;
    else
      --insert somewhere in the list
      indx := json_data.last;
--      dbms_output.put_line('Test '||indx);
      json_data.extend;
--      dbms_output.put_line('Test '||indx);
      loop
--        dbms_output.put_line('Test '||indx);
        temp := json_data(indx);
        temp.mapindx := indx + 1;
        json_data(temp.mapindx) := temp;
        exit when indx = position;
        indx := json_data.prior(indx);
      end loop;
      json_data(position) := insert_value;
      json_data(position).mapindx := position;
    end if;
--    num_elements := num_elements + 1;
  end;

  member procedure put(self in out nocopy json, pair_name varchar2, pair_value varchar2, position pls_integer default null) as
  begin
    put(pair_name, json_value(pair_value), position);
  end;

  member procedure put(self in out nocopy json, pair_name varchar2, pair_value number, position pls_integer default null) as
  begin
    if(pair_value is null) then
      put(pair_name, json_value(), position);
    else
      put(pair_name, json_value(pair_value), position);
    end if;
  end;

  member procedure put(self in out nocopy json, pair_name varchar2, pair_value boolean, position pls_integer default null) as
  begin
    if(pair_value is null) then
      put(pair_name, json_value(), position);
    else
      put(pair_name, json_value(pair_value), position);
    end if;
  end;

  member procedure check_duplicate(self in out nocopy json, v_set boolean) as
  begin
    if(v_set) then
      check_for_duplicate := 1;
    else
      check_for_duplicate := 0;
    end if;
  end;

  /* deprecated putters */

  member procedure put(self in out nocopy json, pair_name varchar2, pair_value json, position pls_integer default null) as
  begin
    if(pair_value is null) then
      put(pair_name, json_value(), position);
    else
      put(pair_name, pair_value.to_json_value, position);
    end if;
  end;

  member procedure put(self in out nocopy json, pair_name varchar2, pair_value json_list, position pls_integer default null) as
  begin
    if(pair_value is null) then
      put(pair_name, json_value(), position);
    else
      put(pair_name, pair_value.to_json_value, position);
    end if;
  end;

  /* Member getter methods */
  member function count return number as
  begin
    return self.json_data.count;
  end;

  member function get(pair_name varchar2) return json_value as
    indx pls_integer;
  begin
    indx := json_data.first;
    loop
      exit when indx is null;
      if(pair_name is null and json_data(indx).mapname is null) then return json_data(indx); end if;
      if(json_data(indx).mapname = pair_name) then return json_data(indx); end if;
      indx := json_data.next(indx);
    end loop;
    return null;
  end;

  member function get(position pls_integer) return json_value as
  begin
    if(self.count >= position and position > 0) then
      return self.json_data(position);
    end if;
    return null; -- do not throw error, just return null
  end;

  member function index_of(pair_name varchar2) return number as
    indx pls_integer;
  begin
    indx := json_data.first;
    loop
      exit when indx is null;
      if(pair_name is null and json_data(indx).mapname is null) then return indx; end if;
      if(json_data(indx).mapname = pair_name) then return indx; end if;
      indx := json_data.next(indx);
    end loop;
    return -1;
  end;

  member function exist(pair_name varchar2) return boolean as
  begin
    return (self.get(pair_name) is not null);
  end;

  /* Output methods */
  member function to_char(spaces boolean default true, chars_per_line number default 0) return varchar2 as
  begin
    if(spaces is null) then
      return json_printer.pretty_print(self, line_length => chars_per_line);
    else
      return json_printer.pretty_print(self, spaces, line_length => chars_per_line);
    end if;
  end;

  member procedure to_clob(self in json, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true) as
  begin
    if(spaces is null) then
      json_printer.pretty_print(self, false, buf, line_length => chars_per_line, erase_clob => erase_clob);
    else
      json_printer.pretty_print(self, spaces, buf, line_length => chars_per_line, erase_clob => erase_clob);
    end if;
  end;

  member procedure print(self in json, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null) as --32512 is the real maximum in sqldeveloper
    my_clob clob;
  begin
    my_clob := empty_clob();
    dbms_lob.createtemporary(my_clob, true);
    json_printer.pretty_print(self, spaces, my_clob, case when (chars_per_line>32512) then 32512 else chars_per_line end);
    json_printer.dbms_output_clob(my_clob, json_printer.newline_char, jsonp);
    dbms_lob.freetemporary(my_clob);
  end;

  member procedure htp(self in json, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null) as
    my_clob clob;
  begin
    my_clob := empty_clob();
    dbms_lob.createtemporary(my_clob, true);
    json_printer.pretty_print(self, spaces, my_clob, chars_per_line);
    json_printer.htp_output_clob(my_clob, jsonp);
    dbms_lob.freetemporary(my_clob);
  end;

  member function to_json_value return json_value as
  begin
    return json_value(sys.anydata.convertobject(self));
  end;

  /* json path */
  member function path(json_path varchar2, base number default 1) return json_value as
  begin
    return json_ext.get_json_value(self, json_path, base);
  end path;

  /* json path_put */
  member procedure path_put(self in out nocopy json, json_path varchar2, elem json_value, base number default 1) as
  begin
    json_ext.put(self, json_path, elem, base);
  end path_put;

  member procedure path_put(self in out nocopy json, json_path varchar2, elem varchar2, base number default 1) as
  begin
    json_ext.put(self, json_path, elem, base);
  end path_put;

  member procedure path_put(self in out nocopy json, json_path varchar2, elem number, base number default 1) as
  begin
    if(elem is null) then
      json_ext.put(self, json_path, json_value(), base);
    else
      json_ext.put(self, json_path, elem, base);
    end if;
  end path_put;

  member procedure path_put(self in out nocopy json, json_path varchar2, elem boolean, base number default 1) as
  begin
    if(elem is null) then
      json_ext.put(self, json_path, json_value(), base);
    else
      json_ext.put(self, json_path, elem, base);
    end if;
  end path_put;

  member procedure path_put(self in out nocopy json, json_path varchar2, elem json_list, base number default 1) as
  begin
    if(elem is null) then
      json_ext.put(self, json_path, json_value(), base);
    else
      json_ext.put(self, json_path, elem, base);
    end if;
  end path_put;

  member procedure path_put(self in out nocopy json, json_path varchar2, elem json, base number default 1) as
  begin
    if(elem is null) then
      json_ext.put(self, json_path, json_value(), base);
    else
      json_ext.put(self, json_path, elem, base);
    end if;
  end path_put;

  member procedure path_remove(self in out nocopy json, json_path varchar2, base number default 1) as
  begin
    json_ext.remove(self, json_path, base);
  end path_remove;

  /* Thanks to Matt Nolan */
  member function get_keys return json_list as
    keys json_list;
    indx pls_integer;
  begin
    keys := json_list();
    indx := json_data.first;
    loop
      exit when indx is null;
      keys.append(json_data(indx).mapname);
      indx := json_data.next(indx);
    end loop;
    return keys;
  end;

  member function get_values return json_list as
    vals json_list := json_list();
  begin
    vals.list_data := self.json_data;
    return vals;
  end;

  member procedure remove_duplicates(self in out nocopy json) as
  begin
    json_parser.remove_duplicates(self);
  end remove_duplicates;


end;
/

-------------------------------
--  New type body json_list  --
-------------------------------
create or replace type body json_list as

  constructor function json_list return self as result as
  begin
    self.list_data := json_value_array();
    return;
  end;

  constructor function json_list(str varchar2) return self as result as
  begin
    self := json_parser.parse_list(str);
    return;
  end;

  constructor function json_list(str clob) return self as result as
  begin
    self := json_parser.parse_list(str);
    return;
  end;

  constructor function json_list(cast json_value) return self as result as
    x number;
  begin
    x := cast.object_or_array.getobject(self);
    return;
  end;


  member procedure append(self in out nocopy json_list, elem json_value, position pls_integer default null) as
    indx pls_integer;
    insert_value json_value := NVL(elem, json_value);
  begin
    if(position is null or position > self.count) then --end of list
      indx := self.count + 1;
      self.list_data.extend(1);
      self.list_data(indx) := insert_value;
    elsif(position < 1) then --new first
      indx := self.count;
      self.list_data.extend(1);
      for x in reverse 1 .. indx loop
        self.list_data(x+1) := self.list_data(x);
      end loop;
      self.list_data(1) := insert_value;
    else
      indx := self.count;
      self.list_data.extend(1);
      for x in reverse position .. indx loop
        self.list_data(x+1) := self.list_data(x);
      end loop;
      self.list_data(position) := insert_value;
    end if;

  end;

  member procedure append(self in out nocopy json_list, elem varchar2, position pls_integer default null) as
  begin
    append(json_value(elem), position);
  end;

  member procedure append(self in out nocopy json_list, elem number, position pls_integer default null) as
  begin
    if(elem is null) then
      append(json_value(), position);
    else
      append(json_value(elem), position);
    end if;
  end;

  member procedure append(self in out nocopy json_list, elem boolean, position pls_integer default null) as
  begin
    if(elem is null) then
      append(json_value(), position);
    else
      append(json_value(elem), position);
    end if;
  end;

  member procedure append(self in out nocopy json_list, elem json_list, position pls_integer default null) as
  begin
    if(elem is null) then
      append(json_value(), position);
    else
      append(elem.to_json_value, position);
    end if;
  end;

 member procedure replace(self in out nocopy json_list, position pls_integer, elem json_value) as
    insert_value json_value := NVL(elem, json_value);
    indx number;
  begin
    if(position > self.count) then --end of list
      indx := self.count + 1;
      self.list_data.extend(1);
      self.list_data(indx) := insert_value;
    elsif(position < 1) then --maybe an error message here
      null;
    else
      self.list_data(position) := insert_value;
    end if;
  end;

  member procedure replace(self in out nocopy json_list, position pls_integer, elem varchar2) as
  begin
    replace(position, json_value(elem));
  end;

  member procedure replace(self in out nocopy json_list, position pls_integer, elem number) as
  begin
    if(elem is null) then
      replace(position, json_value());
    else
      replace(position, json_value(elem));
    end if;
  end;

  member procedure replace(self in out nocopy json_list, position pls_integer, elem boolean) as
  begin
    if(elem is null) then
      replace(position, json_value());
    else
      replace(position, json_value(elem));
    end if;
  end;

  member procedure replace(self in out nocopy json_list, position pls_integer, elem json_list) as
  begin
    if(elem is null) then
      replace(position, json_value());
    else
      replace(position, elem.to_json_value);
    end if;
  end;

  member function count return number as
  begin
    return self.list_data.count;
  end;

  member procedure remove(self in out nocopy json_list, position pls_integer) as
  begin
    if(position is null or position < 1 or position > self.count) then return; end if;
    for x in (position+1) .. self.count loop
      self.list_data(x-1) := self.list_data(x);
    end loop;
    self.list_data.trim(1);
  end;

  member procedure remove_first(self in out nocopy json_list) as
  begin
    for x in 2 .. self.count loop
      self.list_data(x-1) := self.list_data(x);
    end loop;
    if(self.count > 0) then
      self.list_data.trim(1);
    end if;
  end;

  member procedure remove_last(self in out nocopy json_list) as
  begin
    if(self.count > 0) then
      self.list_data.trim(1);
    end if;
  end;

  member function get(position pls_integer) return json_value as
  begin
    if(self.count >= position and position > 0) then
      return self.list_data(position);
    end if;
    return null; -- do not throw error, just return null
  end;

  member function head return json_value as
  begin
    if(self.count > 0) then
      return self.list_data(self.list_data.first);
    end if;
    return null; -- do not throw error, just return null
  end;

  member function last return json_value as
  begin
    if(self.count > 0) then
      return self.list_data(self.list_data.last);
    end if;
    return null; -- do not throw error, just return null
  end;

  member function tail return json_list as
    t json_list;
  begin
    if(self.count > 0) then
      t := json_list(self.list_data);
      t.remove(1);
      return t;
    else return json_list(); end if;
  end;

  member function to_char(spaces boolean default true, chars_per_line number default 0) return varchar2 as
  begin
    if(spaces is null) then
      return json_printer.pretty_print_list(self, line_length => chars_per_line);
    else
      return json_printer.pretty_print_list(self, spaces, line_length => chars_per_line);
    end if;
  end;

  member procedure to_clob(self in json_list, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true) as
  begin
    if(spaces is null) then
      json_printer.pretty_print_list(self, false, buf, line_length => chars_per_line, erase_clob => erase_clob);
    else
      json_printer.pretty_print_list(self, spaces, buf, line_length => chars_per_line, erase_clob => erase_clob);
    end if;
  end;

  member procedure print(self in json_list, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null) as --32512 is the real maximum in sqldeveloper
    my_clob clob;
  begin
    my_clob := empty_clob();
    dbms_lob.createtemporary(my_clob, true);
    json_printer.pretty_print_list(self, spaces, my_clob, case when (chars_per_line>32512) then 32512 else chars_per_line end);
    json_printer.dbms_output_clob(my_clob, json_printer.newline_char, jsonp);
    dbms_lob.freetemporary(my_clob);
  end;

  member procedure htp(self in json_list, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null) as
    my_clob clob;
  begin
    my_clob := empty_clob();
    dbms_lob.createtemporary(my_clob, true);
    json_printer.pretty_print_list(self, spaces, my_clob, chars_per_line);
    json_printer.htp_output_clob(my_clob, jsonp);
    dbms_lob.freetemporary(my_clob);
  end;

  /* json path */
  member function path(json_path varchar2, base number default 1) return json_value as
    cp json_list := self;
  begin
    return json_ext.get_json_value(json(cp), json_path, base);
  end path;


  /* json path_put */
  member procedure path_put(self in out nocopy json_list, json_path varchar2, elem json_value, base number default 1) as
    objlist json;
    jp json_list := json_ext.parsePath(json_path, base);
  begin
    while(jp.head().get_number() > self.count) loop
      self.append(json_value());
    end loop;

    objlist := json(self);
    json_ext.put(objlist, json_path, elem, base);
    self := objlist.get_values;
  end path_put;

  member procedure path_put(self in out nocopy json_list, json_path varchar2, elem varchar2, base number default 1) as
    objlist json;
    jp json_list := json_ext.parsePath(json_path, base);
  begin
    while(jp.head().get_number() > self.count) loop
      self.append(json_value());
    end loop;

    objlist := json(self);
    json_ext.put(objlist, json_path, elem, base);
    self := objlist.get_values;
  end path_put;

  member procedure path_put(self in out nocopy json_list, json_path varchar2, elem number, base number default 1) as
    objlist json;
    jp json_list := json_ext.parsePath(json_path, base);
  begin
    while(jp.head().get_number() > self.count) loop
      self.append(json_value());
    end loop;

    objlist := json(self);

    if(elem is null) then
      json_ext.put(objlist, json_path, json_value, base);
    else
      json_ext.put(objlist, json_path, elem, base);
    end if;
    self := objlist.get_values;
  end path_put;

  member procedure path_put(self in out nocopy json_list, json_path varchar2, elem boolean, base number default 1) as
    objlist json;
    jp json_list := json_ext.parsePath(json_path, base);
  begin
    while(jp.head().get_number() > self.count) loop
      self.append(json_value());
    end loop;

    objlist := json(self);
    if(elem is null) then
      json_ext.put(objlist, json_path, json_value, base);
    else
      json_ext.put(objlist, json_path, elem, base);
    end if;
    self := objlist.get_values;
  end path_put;

  member procedure path_put(self in out nocopy json_list, json_path varchar2, elem json_list, base number default 1) as
    objlist json;
    jp json_list := json_ext.parsePath(json_path, base);
  begin
    while(jp.head().get_number() > self.count) loop
      self.append(json_value());
    end loop;

    objlist := json(self);
    if(elem is null) then
      json_ext.put(objlist, json_path, json_value, base);
    else
      json_ext.put(objlist, json_path, elem, base);
    end if;
    self := objlist.get_values;
  end path_put;

  /* json path_remove */
  member procedure path_remove(self in out nocopy json_list, json_path varchar2, base number default 1) as
    objlist json := json(self);
  begin
    json_ext.remove(objlist, json_path, base);
    self := objlist.get_values;
  end path_remove;


  member function to_json_value return json_value as
  begin
    return json_value(sys.anydata.convertobject(self));
  end;

  /*--backwards compatibility
  member procedure add_elem(self in out nocopy json_list, elem json_value, position pls_integer default null) as begin append(elem,position); end;
  member procedure add_elem(self in out nocopy json_list, elem varchar2, position pls_integer default null) as begin append(elem,position); end;
  member procedure add_elem(self in out nocopy json_list, elem number, position pls_integer default null) as begin append(elem,position); end;
  member procedure add_elem(self in out nocopy json_list, elem boolean, position pls_integer default null) as begin append(elem,position); end;
  member procedure add_elem(self in out nocopy json_list, elem json_list, position pls_integer default null) as begin append(elem,position); end;

  member procedure set_elem(self in out nocopy json_list, position pls_integer, elem json_value) as begin replace(position,elem); end;
  member procedure set_elem(self in out nocopy json_list, position pls_integer, elem varchar2) as begin replace(position,elem); end;
  member procedure set_elem(self in out nocopy json_list, position pls_integer, elem number) as begin replace(position,elem); end;
  member procedure set_elem(self in out nocopy json_list, position pls_integer, elem boolean) as begin replace(position,elem); end;
  member procedure set_elem(self in out nocopy json_list, position pls_integer, elem json_list) as begin replace(position,elem); end;

  member procedure remove_elem(self in out nocopy json_list, position pls_integer) as begin remove(position); end;
  member function get_elem(position pls_integer) return json_value as begin return get(position); end;
  member function get_first return json_value as begin return head(); end;
  member function get_last return json_value as begin return last(); end;
--  */

end;
/

--------------------------------
--  New type body json_value  --
--------------------------------
create or replace type body json_value as

  constructor function json_value(object_or_array sys.anydata) return self as result as
  begin
    case object_or_array.gettypename
      when sys_context('userenv', 'current_schema')||'.JSON_LIST' then self.typeval := 2;
      when sys_context('userenv', 'current_schema')||'.JSON' then self.typeval := 1;
      else raise_application_error(-20102, 'JSON_Value init error (JSON or JSON\_List allowed)');
    end case;
    self.object_or_array := object_or_array;
    if(self.object_or_array is null) then self.typeval := 6; end if;

    return;
  end json_value;

  constructor function json_value(str varchar2, esc boolean default true) return self as result as
  begin
    self.typeval := 3;
    if(esc) then self.num := 1; else self.num := 0; end if; --message to pretty printer
    self.str := str;
    return;
  end json_value;

  constructor function json_value(str clob, esc boolean default true) return self as result as
    amount number := 32767;
  begin
    self.typeval := 3;
    if(esc) then self.num := 1; else self.num := 0; end if; --message to pretty printer
    if(dbms_lob.getlength(str) > 32767) then
      extended_str := str;
    end if;
    dbms_lob.read(str, amount, 1, self.str);
    return;
  end json_value;

  constructor function json_value(num number) return self as result as
  begin
    self.typeval := 4;
    self.num := num;
    if(self.num is null) then self.typeval := 6; end if;
    return;
  end json_value;

  constructor function json_value(b boolean) return self as result as
  begin
    self.typeval := 5;
    self.num := 0;
    if(b) then self.num := 1; end if;
    if(b is null) then self.typeval := 6; end if;
    return;
  end json_value;

  constructor function json_value return self as result as
  begin
    self.typeval := 6; /* for JSON null */
    return;
  end json_value;

  static function makenull return json_value as
  begin
    return json_value;
  end makenull;

  member function get_type return varchar2 as
  begin
    case self.typeval
    when 1 then return 'object';
    when 2 then return 'array';
    when 3 then return 'string';
    when 4 then return 'number';
    when 5 then return 'bool';
    when 6 then return 'null';
    end case;

    return 'unknown type';
  end get_type;

  member function get_string(max_byte_size number default null, max_char_size number default null) return varchar2 as
  begin
    if(self.typeval = 3) then
      if(max_byte_size is not null) then
        return substrb(self.str,1,max_byte_size);
      elsif (max_char_size is not null) then
        return substr(self.str,1,max_char_size);
      else
        return self.str;
      end if;
    end if;
    return null;
  end get_string;

  member procedure get_string(self in json_value, buf in out nocopy clob) as
  begin
    if(self.typeval = 3) then
      if(extended_str is not null) then
        dbms_lob.copy(buf, extended_str, dbms_lob.getlength(extended_str));
      else
        dbms_lob.writeappend(buf, length(self.str), self.str);
      end if;
    end if;
  end get_string;


  member function get_number return number as
  begin
    if(self.typeval = 4) then
      return self.num;
    end if;
    return null;
  end get_number;

  member function get_bool return boolean as
  begin
    if(self.typeval = 5) then
      return self.num = 1;
    end if;
    return null;
  end get_bool;

  member function get_null return varchar2 as
  begin
    if(self.typeval = 6) then
      return 'null';
    end if;
    return null;
  end get_null;

  member function is_object return boolean as begin return self.typeval = 1; end;
  member function is_array return boolean as begin return self.typeval = 2; end;
  member function is_string return boolean as begin return self.typeval = 3; end;
  member function is_number return boolean as begin return self.typeval = 4; end;
  member function is_bool return boolean as begin return self.typeval = 5; end;
  member function is_null return boolean as begin return self.typeval = 6; end;

  /* Output methods */
  member function to_char(spaces boolean default true, chars_per_line number default 0) return varchar2 as
  begin
    if(spaces is null) then
      return json_printer.pretty_print_any(self, line_length => chars_per_line);
    else
      return json_printer.pretty_print_any(self, spaces, line_length => chars_per_line);
    end if;
  end;

  member procedure to_clob(self in json_value, buf in out nocopy clob, spaces boolean default false, chars_per_line number default 0, erase_clob boolean default true) as
  begin
    if(spaces is null) then
      json_printer.pretty_print_any(self, false, buf, line_length => chars_per_line, erase_clob => erase_clob);
    else
      json_printer.pretty_print_any(self, spaces, buf, line_length => chars_per_line, erase_clob => erase_clob);
    end if;
  end;

  member procedure print(self in json_value, spaces boolean default true, chars_per_line number default 8192, jsonp varchar2 default null) as --32512 is the real maximum in sqldeveloper
    my_clob clob;
  begin
    my_clob := empty_clob();
    dbms_lob.createtemporary(my_clob, true);
    json_printer.pretty_print_any(self, spaces, my_clob, case when (chars_per_line>32512) then 32512 else chars_per_line end);
    json_printer.dbms_output_clob(my_clob, json_printer.newline_char, jsonp);
    dbms_lob.freetemporary(my_clob);
  end;

  member procedure htp(self in json_value, spaces boolean default false, chars_per_line number default 0, jsonp varchar2 default null) as
    my_clob clob;
  begin
    my_clob := empty_clob();
    dbms_lob.createtemporary(my_clob, true);
    json_printer.pretty_print_any(self, spaces, my_clob, chars_per_line);
    json_printer.htp_output_clob(my_clob, jsonp);
    dbms_lob.freetemporary(my_clob);
  end;

  member function value_of(self in json_value, max_byte_size number default null, max_char_size number default null) return varchar2 as
  begin
    case self.typeval
    when 1 then return 'json object';
    when 2 then return 'json array';
    when 3 then return self.get_string(max_byte_size,max_char_size);
    when 4 then return self.get_number();
    when 5 then if(self.get_bool()) then return 'true'; else return 'false'; end if;
    else return null;
    end case;
  end;

end;
/

------------------------------------------
--  New trigger trig_in_af_inf_agencys  --
------------------------------------------
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

---------------------------------------
--  New trigger trig_in_af_inf_orgs  --
---------------------------------------
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
