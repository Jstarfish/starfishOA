create table SYS_TERMINAL_ONLINE_TIME(
	TERMINAL_CODE CHAR(10)  not null,
	HOST_BEGIN_TIME_STAMP NUMBER(10)  not null,
	ONLINE_TIME NUMBER(10)  not null,
	RECORD_TIME DATE default sysdate not null,
	RECORD_DAY VARCHAR2(10)  not null,
	constraint PK_SYS_TERM_ONLINE_TIME primary Key (TERMINAL_CODE,HOST_BEGIN_TIME_STAMP,RECORD_TIME)
);
comment on table SYS_TERMINAL_ONLINE_TIME is '终端机在线时长';
comment on column SYS_TERMINAL_ONLINE_TIME.TERMINAL_CODE is '终端编号';
comment on column SYS_TERMINAL_ONLINE_TIME.HOST_BEGIN_TIME_STAMP is '主机上报时间戳（开始记录时间）';
comment on column SYS_TERMINAL_ONLINE_TIME.ONLINE_TIME is '在线时长';
comment on column SYS_TERMINAL_ONLINE_TIME.RECORD_TIME is '记录时间';
comment on column SYS_TERMINAL_ONLINE_TIME.RECORD_DAY is '记录日期';

alter table fund_tuning add TUNING_REASON VARCHAR2(4000);
alter table fund_tuning drop column TUNING_TYPE;
comment on column FUND_TUNING.tuning_reason  is '调账原因';

comment on column HIS_WIN_TICKET.ISSUE_NUMBER is '游戏期号（销售）';
comment on column HIS_WIN_TICKET_DETAIL.ISSUE_NUMBER is '游戏期号（中奖）';

create table ADM_ORG_RELATE
(
  admin_id NUMBER(4) not null,
  org_code CHAR(2) not null,
  constraint PK_ADM_ORG_RELATE primary key (ADMIN_ID, ORG_CODE)  using index tablespace TS_KWS_TAB
);

comment on table ADM_ORG_RELATE  is '用户部门关系表';
comment on column ADM_ORG_RELATE.admin_id  is '用户ID';
comment on column ADM_ORG_RELATE.org_code  is '机构编码（00代表总公司，01代表分公司）';

