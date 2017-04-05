create table SYS_TERMINAL_ONLINE_TIME(
	TERMINAL_CODE CHAR(10)  not null,
	HOST_BEGIN_TIME_STAMP NUMBER(10)  not null,
	ONLINE_TIME NUMBER(10)  not null,
	RECORD_TIME DATE default sysdate not null,
	RECORD_DAY VARCHAR2(10)  not null,
	constraint PK_SYS_TERM_ONLINE_TIME primary Key (TERMINAL_CODE,HOST_BEGIN_TIME_STAMP,RECORD_TIME)
);
comment on table SYS_TERMINAL_ONLINE_TIME is '�ն˻�����ʱ��';
comment on column SYS_TERMINAL_ONLINE_TIME.TERMINAL_CODE is '�ն˱��';
comment on column SYS_TERMINAL_ONLINE_TIME.HOST_BEGIN_TIME_STAMP is '�����ϱ�ʱ�������ʼ��¼ʱ�䣩';
comment on column SYS_TERMINAL_ONLINE_TIME.ONLINE_TIME is '����ʱ��';
comment on column SYS_TERMINAL_ONLINE_TIME.RECORD_TIME is '��¼ʱ��';
comment on column SYS_TERMINAL_ONLINE_TIME.RECORD_DAY is '��¼����';

alter table fund_tuning add TUNING_REASON VARCHAR2(4000);
alter table fund_tuning drop column TUNING_TYPE;
comment on column FUND_TUNING.tuning_reason  is '����ԭ��';

comment on column HIS_WIN_TICKET.ISSUE_NUMBER is '��Ϸ�ںţ����ۣ�';
comment on column HIS_WIN_TICKET_DETAIL.ISSUE_NUMBER is '��Ϸ�ںţ��н���';

create table ADM_ORG_RELATE
(
  admin_id NUMBER(4) not null,
  org_code CHAR(2) not null,
  constraint PK_ADM_ORG_RELATE primary key (ADMIN_ID, ORG_CODE)  using index tablespace TS_KWS_TAB
);

comment on table ADM_ORG_RELATE  is '�û����Ź�ϵ��';
comment on column ADM_ORG_RELATE.admin_id  is '�û�ID';
comment on column ADM_ORG_RELATE.org_code  is '�������루00�����ܹ�˾��01����ֹ�˾��';

