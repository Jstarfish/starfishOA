create table FLOW_PAY_ORG_COMM(
	PAY_FLOW CHAR(24)  not null,
	PAY_AGENCY CHAR(8)  ,
	AREA_CODE CHAR(4)  ,
	ORG_CODE CHAR(2)  not null,
	ORG_TYPE NUMBER(1)  not null,
	ORG_PAY_COMM NUMBER(18)  ,
	ORG_PAY_COMM_RATE NUMBER(8)  ,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	REWARD_GROUP NUMBER(2)  not null,
	TRUNK_NO VARCHAR2(10)  not null,
	BOX_NO VARCHAR2(20)  not null,
	PACKAGE_NO VARCHAR2(10)  not null,
	TICKET_NO NUMBER(5)  not null,
	SECURITY_CODE VARCHAR2(50)  ,
	IDENTITY_CODE VARCHAR2(50)  ,
	PAY_AMOUNT NUMBER(28)  not null,
	REWARD_NO NUMBER(3)  ,
	LOTTERY_AMOUNT NUMBER(18)  not null,
	PAY_TIME DATE  not null,
	PAYER_ADMIN NUMBER(4)  ,
	PAYER_NAME VARCHAR2(1000)  ,
	IS_CENTER_PAID NUMBER(1) default 0 not null,
	constraint PK_FLOW_PAY_ORG_COMM primary Key (PAY_FLOW)
);
comment on table FLOW_PAY_ORG_COMM is '兑奖资金流水—机构佣金';
comment on column FLOW_PAY_ORG_COMM.PAY_FLOW is '兑奖流水（DJ123456789012345678901234）';
comment on column FLOW_PAY_ORG_COMM.PAY_AGENCY is '兑奖站点';
comment on column FLOW_PAY_ORG_COMM.AREA_CODE is '区域编码';
comment on column FLOW_PAY_ORG_COMM.ORG_CODE is '组织机构';
comment on column FLOW_PAY_ORG_COMM.ORG_TYPE is '机构类别（1-公司,2-代理）';
comment on column FLOW_PAY_ORG_COMM.ORG_PAY_COMM is '机构兑奖佣金';
comment on column FLOW_PAY_ORG_COMM.ORG_PAY_COMM_RATE is '机构兑奖佣金比例（千分位）';
comment on column FLOW_PAY_ORG_COMM.PLAN_CODE is '方案编码';
comment on column FLOW_PAY_ORG_COMM.BATCH_NO is '批次';
comment on column FLOW_PAY_ORG_COMM.REWARD_GROUP is '奖组';
comment on column FLOW_PAY_ORG_COMM.TRUNK_NO is '箱号';
comment on column FLOW_PAY_ORG_COMM.BOX_NO is '盒号（箱号+盒子顺序号）';
comment on column FLOW_PAY_ORG_COMM.PACKAGE_NO is '本号';
comment on column FLOW_PAY_ORG_COMM.TICKET_NO is '票号';
comment on column FLOW_PAY_ORG_COMM.SECURITY_CODE is '保安区码';
comment on column FLOW_PAY_ORG_COMM.IDENTITY_CODE is '物流区码';
comment on column FLOW_PAY_ORG_COMM.PAY_AMOUNT is '中奖金额';
comment on column FLOW_PAY_ORG_COMM.REWARD_NO is '中奖等级';
comment on column FLOW_PAY_ORG_COMM.LOTTERY_AMOUNT is '彩票金额';
comment on column FLOW_PAY_ORG_COMM.PAY_TIME is '兑奖时间';
comment on column FLOW_PAY_ORG_COMM.PAYER_ADMIN is '兑奖操作员编号';
comment on column FLOW_PAY_ORG_COMM.PAYER_NAME is '兑奖操作员名称';
comment on column FLOW_PAY_ORG_COMM.IS_CENTER_PAID is '兑奖方式（1=中心兑奖，2=手工兑奖，3=站点兑奖）';
create index UDX_FLOW_PAY_ORG_TICKET on FLOW_PAY_ORG_COMM(PLAN_CODE,BATCH_NO,TRUNK_NO,BOX_NO,PACKAGE_NO,TICKET_NO);

create table FLOW_SALE_ORG_COMM(
	SALE_FLOW CHAR(24)  not null,
	AGENCY_CODE CHAR(8)  not null,
	AREA_CODE CHAR(4)  not null,
	ORG_CODE CHAR(2)  not null,
	ORG_TYPE NUMBER(1)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNKS NUMBER(18)  not null,
	BOXES NUMBER(18)  not null,
	PACKAGES NUMBER(18)  not null,
	TICKETS NUMBER(18)  not null,
	SALE_AMOUNT NUMBER(28)  not null,
	ORG_COMM_AMOUNT NUMBER(18)  not null,
	ORG_COMM_RATE NUMBER(8)  not null,
	SALE_TIME DATE  not null,
	AR_NO CHAR(10)  not null,
	SGR_NO CHAR(10)  not null,
	constraint PK_FLOW_SALE_ORG_COMM primary Key (SALE_FLOW)
);
comment on table FLOW_SALE_ORG_COMM is '销售记录—机构佣金';
comment on column FLOW_SALE_ORG_COMM.SALE_FLOW is '销售流水（XS1234567890123456789012）';
comment on column FLOW_SALE_ORG_COMM.AGENCY_CODE is '销售站点';
comment on column FLOW_SALE_ORG_COMM.AREA_CODE is '区域编码';
comment on column FLOW_SALE_ORG_COMM.ORG_CODE is '组织机构';
comment on column FLOW_SALE_ORG_COMM.ORG_TYPE is '机构类别（1-公司,2-代理）';
comment on column FLOW_SALE_ORG_COMM.PLAN_CODE is '方案编码';
comment on column FLOW_SALE_ORG_COMM.BATCH_NO is '批次';
comment on column FLOW_SALE_ORG_COMM.TRUNKS is '箱';
comment on column FLOW_SALE_ORG_COMM.BOXES is '盒数';
comment on column FLOW_SALE_ORG_COMM.PACKAGES is '本数';
comment on column FLOW_SALE_ORG_COMM.TICKETS is '销售张数';
comment on column FLOW_SALE_ORG_COMM.SALE_AMOUNT is '销售金额';
comment on column FLOW_SALE_ORG_COMM.ORG_COMM_AMOUNT is '机构销售佣金';
comment on column FLOW_SALE_ORG_COMM.ORG_COMM_RATE is '机构销售佣金比例（千分位）';
comment on column FLOW_SALE_ORG_COMM.SALE_TIME is '销售时间';
comment on column FLOW_SALE_ORG_COMM.AR_NO is '站点入库单编号';
comment on column FLOW_SALE_ORG_COMM.SGR_NO is '入库单编号';
create index IDX_FLOW_SALE_ORG_AGENCY on FLOW_SALE_ORG_COMM(AGENCY_CODE);
create index IDX_FLOW_SALE_ORG_AREA on FLOW_SALE_ORG_COMM(AREA_CODE);
create index IDX_FLOW_SALE_ORG_GAME on FLOW_SALE_ORG_COMM(PLAN_CODE,BATCH_NO);

create table FLOW_CANCEL_ORG_COMM(
	CANCEL_FLOW CHAR(24)  not null,
	AGENCY_CODE CHAR(8)  not null,
	AREA_CODE CHAR(4)  not null,
	ORG_CODE CHAR(2)  not null,
	ORG_TYPE NUMBER(1)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNKS NUMBER(18)  not null,
	BOXES NUMBER(18)  not null,
	PACKAGES NUMBER(18)  not null,
	TICKETS NUMBER(18)  not null,
	SALE_AMOUNT NUMBER(28)  not null,
	COMM_AMOUNT NUMBER(18)  not null,
	COMM_RATE NUMBER(8)  not null,
	CANCEL_TIME DATE  not null,
	AI_NO CHAR(10)  not null,
	SGI_NO CHAR(10)  not null,
	constraint PK_FLOW_CANCEL_ORG_COMM primary Key (CANCEL_FLOW)
);
comment on table FLOW_CANCEL_ORG_COMM is '退票记录—机构佣金';
comment on column FLOW_CANCEL_ORG_COMM.CANCEL_FLOW is '退票流水（TP1234567890123456789012）';
comment on column FLOW_CANCEL_ORG_COMM.AGENCY_CODE is '退票站点';
comment on column FLOW_CANCEL_ORG_COMM.AREA_CODE is '区域编码';
comment on column FLOW_CANCEL_ORG_COMM.ORG_CODE is '组织机构';
comment on column FLOW_CANCEL_ORG_COMM.ORG_TYPE is '机构类别（1-公司,2-代理）';
comment on column FLOW_CANCEL_ORG_COMM.PLAN_CODE is '方案编码';
comment on column FLOW_CANCEL_ORG_COMM.BATCH_NO is '批次';
comment on column FLOW_CANCEL_ORG_COMM.TRUNKS is '箱数';
comment on column FLOW_CANCEL_ORG_COMM.BOXES is '盒数';
comment on column FLOW_CANCEL_ORG_COMM.PACKAGES is '本数';
comment on column FLOW_CANCEL_ORG_COMM.TICKETS is '退票张数';
comment on column FLOW_CANCEL_ORG_COMM.SALE_AMOUNT is '退票金额';
comment on column FLOW_CANCEL_ORG_COMM.COMM_AMOUNT is '涉及机构佣金';
comment on column FLOW_CANCEL_ORG_COMM.COMM_RATE is '涉及机构佣金比例（千分位）';
comment on column FLOW_CANCEL_ORG_COMM.CANCEL_TIME is '退票时间';
comment on column FLOW_CANCEL_ORG_COMM.AI_NO is '站点退货单编号';
comment on column FLOW_CANCEL_ORG_COMM.SGI_NO is '出库单编号';
create index IDX_FLOW_CANCEL_ORG_AGENCY on FLOW_CANCEL_ORG_COMM(AGENCY_CODE);
create index IDX_FLOW_CANCEL_ORG_AREA on FLOW_CANCEL_ORG_COMM(AREA_CODE);
create index IDX_FLOW_CANCEL_ORG_GAME on FLOW_CANCEL_ORG_COMM(PLAN_CODE,BATCH_NO);

create table HIS_AGENT_FUND_REPORT(
	CALC_DATE VARCHAR2(10)  not null,
	ORG_CODE CHAR(2)  not null,
	FLOW_TYPE NUMBER(2)  not null,
	AMOUNT NUMBER(28)  not null,
	constraint PK_HIS_AGENT_FUND_REPORT primary Key (CALC_DATE,ORG_CODE,FLOW_TYPE)
);
comment on table HIS_AGENT_FUND_REPORT is '代理商资金报表';
comment on column HIS_AGENT_FUND_REPORT.CALC_DATE is '统计日期';
comment on column HIS_AGENT_FUND_REPORT.ORG_CODE is '代理商';
comment on column HIS_AGENT_FUND_REPORT.FLOW_TYPE is '资金类型（1-充值，2-提现，5-销售佣金，6-兑奖佣金，7-销售，8-兑奖，11-站点退货，13-撤销佣金，）';
comment on column HIS_AGENT_FUND_REPORT.AMOUNT is '发生金额';
create index IDX_HIS_AGENT_FUND_RP_CALC on HIS_AGENT_FUND_REPORT(CALC_DATE);
