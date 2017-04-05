--增加还款注释
alter table FUND_MM_CASH_REPAY add REMARK	VARCHAR2(4000);

--
create table SALE_PAID(
	DJXQ_NO CHAR(24)  not null,
	PAY_AGENCY CHAR(8)  not null,
	AREA_CODE CHAR(4)  ,
	PAYER_ADMIN NUMBER(4)  not null,
	IS_CENTER_PAID NUMBER(1) default 3 not null,
	PLAN_TICKETS NUMBER(28) default 0 not null,
	SUCC_TICKETS NUMBER(28) default 0 not null,
	SUCC_AMOUNT NUMBER(28) default 0 not null,
	constraint PK_SALE_PAID primary Key (DJXQ_NO)
);
comment on table SALE_PAID is '兑奖详情主表';
comment on column SALE_PAID.DJXQ_NO is '兑奖详情编号（DX1234）';
comment on column SALE_PAID.PAY_AGENCY is '兑奖站点';
comment on column SALE_PAID.AREA_CODE is '区域编码';
comment on column SALE_PAID.PAYER_ADMIN is '兑奖操作员编号';
comment on column SALE_PAID.IS_CENTER_PAID is '兑奖方式（1=中心兑奖，2=手工兑奖，3=站点兑奖）';
comment on column SALE_PAID.PLAN_TICKETS is '提交兑奖票数';
comment on column SALE_PAID.SUCC_TICKETS is '成功兑奖票数';
comment on column SALE_PAID.SUCC_AMOUNT is '成功兑奖金额';
create index IDX_SALE_PAID_ADMIN on SALE_PAID(PAYER_ADMIN);
create index IDX_SALE_PAID_AGENCY on SALE_PAID(PAY_AGENCY);

create table SALE_PAID_DETAIL(
	DJXQ_NO CHAR(24)  not null,
	DJXQ_SEQ_NO NUMBER(24)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	PACKAGE_NO VARCHAR2(10)  not null,
	TICKET_NO NUMBER(5) default 0 not null,
	SECURITY_CODE VARCHAR2(50) default 0 not null,
	PAID_STATUS NUMBER(1) default 0 not null,
	PAY_FLOW CHAR(24)  ,
	REWARD_AMOUNT NUMBER(28)  ,
	constraint PK_SALE_PAID_DETAIL primary Key (DJXQ_SEQ_NO)
);
comment on table SALE_PAID_DETAIL is '兑奖详情子表';
comment on column SALE_PAID_DETAIL.DJXQ_NO is '兑奖详情编号（DX12345678）';
comment on column SALE_PAID_DETAIL.DJXQ_SEQ_NO is '顺序号';
comment on column SALE_PAID_DETAIL.PLAN_CODE is '方案编码';
comment on column SALE_PAID_DETAIL.BATCH_NO is '批次';
comment on column SALE_PAID_DETAIL.PACKAGE_NO is '本号';
comment on column SALE_PAID_DETAIL.TICKET_NO is '票号';
comment on column SALE_PAID_DETAIL.SECURITY_CODE is '保安区码';
comment on column SALE_PAID_DETAIL.PAID_STATUS is '兑奖状态（1-成功、2-非法票、3-已兑奖、4-中大奖、5-未中奖、6-未销售）';
comment on column SALE_PAID_DETAIL.PAY_FLOW is '兑奖流水号';
comment on column SALE_PAID_DETAIL.REWARD_AMOUNT is '中奖金额';
create index IDX_SALE_PAID_DETAIL_DJXQ on SALE_PAID_DETAIL(DJXQ_NO);
create index IDX_SALE_PAID_DETAIL_TICKET on SALE_PAID_DETAIL(PLAN_CODE,BATCH_NO,PACKAGE_NO,TICKET_NO);
create index IDX_SALE_PAID_DETAIL_FLOW on SALE_PAID_DETAIL(PAY_FLOW);

-- 创建索引
create index IDX_FLOW_AGENCY_TIME on FLOW_AGENCY(TRADE_TIME);

--
create table HIS_MM_FUND(
	CALC_DATE VARCHAR2(10)  not null,
	MARKET_ADMIN NUMBER(4)  not null,
	FLOW_TYPE NUMBER(2)  not null,
	AMOUNT NUMBER(28)  not null,
	BE_ACCOUNT_BALANCE NUMBER(28)  not null,
	AF_ACCOUNT_BALANCE NUMBER(28)  not null,
	constraint PK_HIS_MM_FUND primary Key (CALC_DATE,MARKET_ADMIN,FLOW_TYPE)
);
comment on table HIS_MM_FUND is '市场管理员资金历史';
comment on column HIS_MM_FUND.CALC_DATE is '统计日期';
comment on column HIS_MM_FUND.MARKET_ADMIN is '市场管理员';
comment on column HIS_MM_FUND.FLOW_TYPE is '资金类型（9-为站点充值，10-现金上缴，14-为站点提现，0-仅用于显示当天期初和期末余额）';
comment on column HIS_MM_FUND.AMOUNT is '发生金额';
comment on column HIS_MM_FUND.BE_ACCOUNT_BALANCE is '期初余额';
comment on column HIS_MM_FUND.AF_ACCOUNT_BALANCE is '期末余额';
create index IDX_HIS_MM_FUND_CALC on HIS_MM_FUND(CALC_DATE);
create index IDX_HIS_MM_FUND_MM_FLOW on HIS_MM_FUND(MARKET_ADMIN,FLOW_TYPE);

--------------------------------------------------------------------------------------

-- 用于切换用的序列号
create sequence seq_switch_flow order;

create table SWITCH_SCAN(
	OLD_PAY_FLOW CHAR(24)  not null,
	PAID_TIME DATE  ,
	PAID_ADMIN NUMBER(4)  ,
	PAID_ORG CHAR(2)  ,
	APPLY_TICKETS NUMBER(28)  ,
	FAIL_NEW_TICKETS NUMBER(28)  ,
	SUCC_TICKETS NUMBER(28)  ,
	SUCC_AMOUNT NUMBER(28)  ,
	constraint PK_SWITCH_SCAN primary Key (OLD_PAY_FLOW)
);
comment on table SWITCH_SCAN is '旧票兑奖主表';
comment on column SWITCH_SCAN.OLD_PAY_FLOW is '旧票兑奖序号';
comment on column SWITCH_SCAN.PAID_TIME is '兑奖时间';
comment on column SWITCH_SCAN.PAID_ADMIN is '兑奖人';
comment on column SWITCH_SCAN.PAID_ORG is '所属机构';
comment on column SWITCH_SCAN.APPLY_TICKETS is '提交票数';
comment on column SWITCH_SCAN.FAIL_NEW_TICKETS is '失败新票票数';
comment on column SWITCH_SCAN.SUCC_TICKETS is '成功兑奖票数';
comment on column SWITCH_SCAN.SUCC_AMOUNT is '成功兑奖金额';

create table SWITCH_SCAN_DETAIL(
	OLD_PAY_FLOW CHAR(24)  not null,
	OLD_PAY_SEQ CHAR(24)  not null,
	PAID_TIME DATE  not null,
	PAID_ADMIN NUMBER(4)  not null,
	PAID_ORG CHAR(2)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	PACKAGE_NO VARCHAR2(10)  not null,
	TICKET_NO NUMBER(5) default 0 not null,
	SECURITY_CODE VARCHAR2(50) default 0 not null,
	PAID_STATUS NUMBER(1) default 0 not null,
	REWARD_AMOUNT NUMBER(28)  not null,
	IS_NEW_TICKET NUMBER(1) default 0 not null,
	constraint PK_SWITCH_SCAN_DETAIL primary Key (OLD_PAY_SEQ)
);
comment on table SWITCH_SCAN_DETAIL is '旧票兑奖子表';
comment on column SWITCH_SCAN_DETAIL.OLD_PAY_FLOW is '旧票兑奖序号';
comment on column SWITCH_SCAN_DETAIL.OLD_PAY_SEQ is '旧票明细序号';
comment on column SWITCH_SCAN_DETAIL.PAID_TIME is '兑奖时间';
comment on column SWITCH_SCAN_DETAIL.PAID_ADMIN is '兑奖人';
comment on column SWITCH_SCAN_DETAIL.PAID_ORG is '所属机构';
comment on column SWITCH_SCAN_DETAIL.PLAN_CODE is '方案编码';
comment on column SWITCH_SCAN_DETAIL.BATCH_NO is '批次';
comment on column SWITCH_SCAN_DETAIL.PACKAGE_NO is '本号';
comment on column SWITCH_SCAN_DETAIL.TICKET_NO is '票号';
comment on column SWITCH_SCAN_DETAIL.SECURITY_CODE is '保安区码';
comment on column SWITCH_SCAN_DETAIL.PAID_STATUS is '兑奖状态（1-成功、3-已兑奖、5-未中奖、7-新票）';
comment on column SWITCH_SCAN_DETAIL.REWARD_AMOUNT is '中奖金额';
comment on column SWITCH_SCAN_DETAIL.IS_NEW_TICKET is '是否新票';

-- 2015-12-19
create table HIS_ORG_INV_REPORT(
	CALC_DATE VARCHAR2(10)  not null,
	ORG_CODE CHAR(2)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	OPER_TYPE NUMBER(2) default 0 not null,
	TICKETS NUMBER(28) default 0 not null,
	AMOUNT NUMBER(28) default 0 not null,
	constraint PK_HIS_ORG_INV_REPORT primary Key (CALC_DATE,ORG_CODE,PLAN_CODE,OPER_TYPE)
);
comment on table HIS_ORG_INV_REPORT is '机构库存历史报表';
comment on column HIS_ORG_INV_REPORT.CALC_DATE is '统计日期';
comment on column HIS_ORG_INV_REPORT.ORG_CODE is '部门编码';
comment on column HIS_ORG_INV_REPORT.PLAN_CODE is '方案';
comment on column HIS_ORG_INV_REPORT.OPER_TYPE is '操作类型（1=调拨出库、4=站点退货、12=调拨入库、14=站点销售、20=损毁、88=期初、99=期末）';
comment on column HIS_ORG_INV_REPORT.TICKETS is '票数';
comment on column HIS_ORG_INV_REPORT.AMOUNT is '金额';
create index IDX_HIS_ORG_INV_ORG_PLAN on HIS_ORG_INV_REPORT(ORG_CODE,PLAN_CODE);

create table HIS_AGENCY_INV(
	CALC_DATE VARCHAR2(10)  not null,
	AGENCY_CODE CHAR(8)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	OPER_TYPE NUMBER(2)  not null,
	TICKETS NUMBER(28) default 0 not null,
	AMOUNT NUMBER(28) default 0 not null,
	constraint PK_HIS_AGENCY_INV primary Key (CALC_DATE,AGENCY_CODE,PLAN_CODE,OPER_TYPE)
);
comment on table HIS_AGENCY_INV is '站点库存历史';
comment on column HIS_AGENCY_INV.CALC_DATE is '统计日期';
comment on column HIS_AGENCY_INV.AGENCY_CODE is '销售站点';
comment on column HIS_AGENCY_INV.PLAN_CODE is '方案';
comment on column HIS_AGENCY_INV.OPER_TYPE is '资金类型（10-退货，20-销售，88-期初，99-期末）';
comment on column HIS_AGENCY_INV.TICKETS is '票数';
comment on column HIS_AGENCY_INV.AMOUNT is '金额';
create index IDX_HIS_AGENCY_INV_CALC on HIS_AGENCY_INV(CALC_DATE);
create index IDX_HIS_AGENCY_INV_AGENCY on HIS_AGENCY_INV(AGENCY_CODE);

create table FLOW_ORG_COMM_DETAIL(
	ORG_FUND_COMM_FLOW CHAR(24)  not null,
	ORG_FUND_FLOW CHAR(24)  not null,
	AGENCY_CODE CHAR(8)  not null,
	PLAN_NAME VARCHAR2(100)  not null,
	ACC_NO CHAR(12)  not null,
	ORG_CODE CHAR(2)  not null,
	TRADE_TIME DATE default sysdate not null,
	TRADE_AMOUNT NUMBER(28) default 0 not null,
	AGENCY_SALE_AMOUNT NUMBER(28) default 0 not null,
	ORG_SALE_COMM NUMBER(28) default 0 not null,
	AGENCY_CANCEL_AMOUNT NUMBER(28) default 0 not null,
	ORG_CANCEL_COMM NUMBER(28) default 0 not null,
	AGENCY_SALE_COMM_RATE NUMBER(28) default 0 not null,
	ORG_SALE_COMM_RATE NUMBER(28) default 0 not null,
	AGENCY_PAY_AMOUNT NUMBER(28) default 0 not null,
	ORG_PAY_AMOUNT NUMBER(28) default 0 not null,
	AGENCY_PAY_COMM_RATE NUMBER(28) default 0 not null,
	ORG_PAY_COMM_RATE NUMBER(28) default 0 not null,
	constraint PK_FLOW_ORG_COMM_DETAIL primary Key (ORG_FUND_FLOW)
);
comment on table FLOW_ORG_COMM_DETAIL is '机构佣金流水';
comment on column FLOW_ORG_COMM_DETAIL.ORG_FUND_COMM_FLOW is '流水号（JGYJ12345678901234567890）';
comment on column FLOW_ORG_COMM_DETAIL.ORG_FUND_FLOW is '资金流水编号';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_CODE is '销售站编号';
comment on column FLOW_ORG_COMM_DETAIL.PLAN_NAME is '方案名称';
comment on column FLOW_ORG_COMM_DETAIL.ACC_NO is '账户编码';
comment on column FLOW_ORG_COMM_DETAIL.ORG_CODE is '部门编码';
comment on column FLOW_ORG_COMM_DETAIL.TRADE_TIME is '交易时间';
comment on column FLOW_ORG_COMM_DETAIL.TRADE_AMOUNT is '交易金额';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_SALE_AMOUNT is '站点销售金额';
comment on column FLOW_ORG_COMM_DETAIL.ORG_SALE_COMM is '机构销售佣金';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_CANCEL_AMOUNT is '站点退货金额';
comment on column FLOW_ORG_COMM_DETAIL.ORG_CANCEL_COMM is '机构退货佣金';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_SALE_COMM_RATE is '站点销售佣金比例';
comment on column FLOW_ORG_COMM_DETAIL.ORG_SALE_COMM_RATE is '机构销售佣金比例';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_PAY_AMOUNT is '站点兑奖金额';
comment on column FLOW_ORG_COMM_DETAIL.ORG_PAY_AMOUNT is '机构兑奖佣金';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_PAY_COMM_RATE is '站点兑奖佣金比例';
comment on column FLOW_ORG_COMM_DETAIL.ORG_PAY_COMM_RATE is '机构兑奖佣金比例';
create index IDX_FLOW_ORG_COMM_AGENCY on FLOW_ORG_COMM_DETAIL(ACC_NO);
create index IDX_FLOW_ORG_COMM_FLOW on FLOW_ORG_COMM_DETAIL(ORG_FUND_COMM_FLOW);

insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (11, '站点爱心兑奖佣金（千分位）', '10');
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (12, '机构爱心兑奖佣金（千分位）', '10');
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (15, '爱心游戏是否开放（1=开放，2=关闭）', '1');
commit;

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
