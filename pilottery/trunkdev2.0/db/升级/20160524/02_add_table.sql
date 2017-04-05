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
  is '兑奖范围（0=中心通兑、1=区域通兑、4=本站自兑）';
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
  applyflow_sell   CHAR(24) not null,
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
create table ISS_GAME_ISSUE_XML(
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	WINNING_BRODCAST CLOB  ,
	WINNER_LOCAL_INFO CLOB  ,
	WINNER_CONFIRM_INFO CLOB  ,
  JSON_WINNING_BRODCAST CLOB,
	WINNING_PROCESS VARCHAR2(100)  ,
	constraint PK_ISS_GAME_ISSUE_XML primary Key (GAME_CODE,ISSUE_NUMBER)
);
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
comment on column ISS_GAME_ISSUE_XML.JSON_WINNING_BRODCAST 
  is 'JSON开奖公告';  
comment on column ISS_GAME_ISSUE_XML.winning_process
  is '算奖进度';

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

-----------------------------
--  New table sub_abandon  --
-----------------------------
-- Create table
create table SUB_ABANDON(
	ABANDON_DATE CHAR(10)  not null,
	ABANDON_WEEK CHAR(7)  not null,
	ABANDON_MONTH CHAR(7)  not null,
	ABANDON_QUARTER CHAR(6)  not null,
	ABANDON_YEAR CHAR(4)  not null,
	GAME_CODE NUMBER(3)  not null,
	SALE_ISSUE NUMBER(12)  not null,
  WINNING_ISSUE NUMBER(12)  not null,
	WINNING_DATE DATE  ,
	SALE_AGENCY CHAR(8)  not null,
	SALE_AREA CHAR(2)  not null,
	SALE_TELLER NUMBER(8)  not null,
	SALE_TERMINAL CHAR(10)  not null,
	BET_METHOLD NUMBER(4)  not null,
	LOYALTY_CODE VARCHAR2(50)  not null,
	IS_BIG_ONE NUMBER(1)  not null,
	WIN_AMOUNT NUMBER(28) default 0 ,
	WIN_AMOUNT_WITHOUT_TAX NUMBER(28) default 0 ,
	TAX_AMOUNT NUMBER(28) default 0 ,
	WIN_BETS NUMBER(28) default 0 ,
	HD_WIN_AMOUNT NUMBER(28) default 0 ,
	HD_WIN_AMOUNT_WITHOUT_TAX NUMBER(28) default 0 ,
	HD_TAX_AMOUNT NUMBER(28) default 0 ,
	HD_WIN_BETS NUMBER(28) default 0 ,
	LD_WIN_AMOUNT NUMBER(28) default 0 ,
	LD_WIN_AMOUNT_WITHOUT_TAX NUMBER(28) default 0 ,
	LD_TAX_AMOUNT NUMBER(28) default 0 ,
	LD_WIN_BETS NUMBER(28) default 0 ,
	constraint PK_SUB_ABANDON primary Key (ABANDON_DATE,GAME_CODE,SALE_ISSUE,WINNING_ISSUE,WINNING_DATE,SALE_AREA,SALE_AGENCY,SALE_TELLER,SALE_TERMINAL,BET_METHOLD,LOYALTY_CODE,IS_BIG_ONE)
);
comment on table SUB_ABANDON is '弃奖主题';
comment on column SUB_ABANDON.ABANDON_DATE is '弃奖日期（YYYY-MM-DD）';
comment on column SUB_ABANDON.ABANDON_WEEK is '弃奖周（YYYY-WK）';
comment on column SUB_ABANDON.ABANDON_MONTH is '弃奖月（YYYY-MM）';
comment on column SUB_ABANDON.ABANDON_QUARTER is '弃奖季（YYYY-Q）';
comment on column SUB_ABANDON.ABANDON_YEAR is '弃奖年（YYYY）';
comment on column SUB_ABANDON.GAME_CODE is '游戏';
comment on column SUB_ABANDON.SALE_ISSUE is '销售期次';
comment on column SUB_ABANDON.WINNING_ISSUE is '中奖期次';
comment on column SUB_ABANDON.WINNING_DATE is '开奖时间';
comment on column SUB_ABANDON.SALE_AGENCY is '售票销售站';
comment on column SUB_ABANDON.SALE_AREA is '售票销售站所在区域';
comment on column SUB_ABANDON.SALE_TELLER is '售票销售员';
comment on column SUB_ABANDON.SALE_TERMINAL is '售票终端';
comment on column SUB_ABANDON.BET_METHOLD is '投注方法';
comment on column SUB_ABANDON.LOYALTY_CODE is '彩民卡编号';
comment on column SUB_ABANDON.IS_BIG_ONE is '是否大奖';
comment on column SUB_ABANDON.WIN_AMOUNT is '中奖金额（税前）';
comment on column SUB_ABANDON.WIN_AMOUNT_WITHOUT_TAX is '中奖金额（税后）';
comment on column SUB_ABANDON.TAX_AMOUNT is '税额';
comment on column SUB_ABANDON.WIN_BETS is '中奖注数';
comment on column SUB_ABANDON.HD_WIN_AMOUNT is '高等奖中奖金额（税前）';
comment on column SUB_ABANDON.HD_WIN_AMOUNT_WITHOUT_TAX is '高等奖中奖金额（税后）';
comment on column SUB_ABANDON.HD_TAX_AMOUNT is '高等奖税额';
comment on column SUB_ABANDON.HD_WIN_BETS is '高等奖中奖注数';
comment on column SUB_ABANDON.LD_WIN_AMOUNT is '固定奖中奖金额（税前）';
comment on column SUB_ABANDON.LD_WIN_AMOUNT_WITHOUT_TAX is '固定奖中奖金额（税后）';
comment on column SUB_ABANDON.LD_TAX_AMOUNT is '固定奖税额';
comment on column SUB_ABANDON.LD_WIN_BETS is '固定奖中奖注数';
create index IDX_SUB_ABANDON_DATE on SUB_ABANDON(ABANDON_DATE);
create index IDX_SUB_ABANDON_WEEK on SUB_ABANDON(ABANDON_WEEK);
create index IDX_SUB_ABANDON_MONTH on SUB_ABANDON(ABANDON_MONTH);
create index IDX_SUB_ABANDON_QUARTER on SUB_ABANDON(ABANDON_QUARTER);
create index IDX_SUB_ABANDON_YEAR on SUB_ABANDON(ABANDON_YEAR);
create index IDX_SUB_ABANDON_GAME_ISS on SUB_ABANDON(GAME_CODE,SALE_ISSUE);
create index IDX_SUB_ABANDON_AGENCY on SUB_ABANDON(SALE_AGENCY);
create index IDX_SUB_ABANDON_AREA on SUB_ABANDON(SALE_AREA);
create index IDX_SUB_ABANDON_TELLER on SUB_ABANDON(SALE_TELLER);
create index IDX_SUB_ABANDON_TERMINAL on SUB_ABANDON(SALE_TERMINAL);
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
create table SUB_CANCEL(
	CANCEL_DATE CHAR(10),
	CANCEL_WEEK CHAR(7),
	CANCEL_MONTH CHAR(7),
	CANCEL_QUARTER CHAR(6),
	CANCEL_YEAR CHAR(4),
	GAME_CODE NUMBER(3),
	ISSUE_NUMBER NUMBER(12),
	CANCEL_AGENCY CHAR(8),
	CANCEL_AREA CHAR(2),
	CANCEL_TELLER NUMBER(8),
	CANCEL_TERMINAL CHAR(10),
	SALE_AGENCY CHAR(8),
	SALE_AREA CHAR(2),
	SALE_TELLER NUMBER(8),
	SALE_TERMINAL CHAR(10),
	LOYALTY_CODE VARCHAR2(50),
	IS_GUI_PAY NUMBER(1),
	CANCEL_AMOUNT NUMBER(28) default 0 ,
	CANCEL_BETS NUMBER(28) default 0 ,
	CANCEL_TICKETS NUMBER(28) default 0 ,
	CANCEL_COMMISSION NUMBER(28) default 0 ,
	CANCEL_LINES NUMBER(28) default 0 
);
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
create table SUB_PAY(
	PAY_DATE CHAR(10),
	PAY_WEEK CHAR(7),
	PAY_MONTH CHAR(7),
	PAY_QUARTER CHAR(6),
	PAY_YEAR CHAR(4),
	GAME_CODE NUMBER(3),
	ISSUE_NUMBER NUMBER(12),
	PAY_AGENCY CHAR(8),
	PAY_ISSUE NUMBER(12),
	PAY_AREA CHAR(2),
	PAY_TELLER NUMBER(8),
	PAY_TERMINAL CHAR(10),
	LOYALTY_CODE VARCHAR2(50),
	IS_GUI_PAY NUMBER(1),
	IS_BIG_ONE NUMBER(1),
	PAY_AMOUNT NUMBER(28) default 0 ,
	PAY_AMOUNT_WITHOUT_TAX NUMBER(28) default 0 ,
	TAX_AMOUNT NUMBER(28) default 0 ,
	PAY_BETS NUMBER(28) default 0 ,
	HD_PAY_AMOUNT NUMBER(28) default 0 ,
	HD_PAY_AMOUNT_WITHOUT_TAX NUMBER(28) default 0 ,
	HD_TAX_AMOUNT NUMBER(28) default 0 ,
	HD_PAY_BETS NUMBER(28) default 0 ,
	LD_PAY_AMOUNT NUMBER(28) default 0 ,
	LD_PAY_AMOUNT_WITHOUT_TAX NUMBER(28) default 0 ,
	LD_TAX_AMOUNT NUMBER(28) default 0 ,
	LD_PAY_BETS NUMBER(28) default 0 ,
	PAY_COMMISSION NUMBER(28) default 0 ,
	PAY_TICKETS NUMBER(28) default 0 
);
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