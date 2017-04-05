--���ӻ���ע��
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
comment on table SALE_PAID is '�ҽ���������';
comment on column SALE_PAID.DJXQ_NO is '�ҽ������ţ�DX1234��';
comment on column SALE_PAID.PAY_AGENCY is '�ҽ�վ��';
comment on column SALE_PAID.AREA_CODE is '�������';
comment on column SALE_PAID.PAYER_ADMIN is '�ҽ�����Ա���';
comment on column SALE_PAID.IS_CENTER_PAID is '�ҽ���ʽ��1=���Ķҽ���2=�ֹ��ҽ���3=վ��ҽ���';
comment on column SALE_PAID.PLAN_TICKETS is '�ύ�ҽ�Ʊ��';
comment on column SALE_PAID.SUCC_TICKETS is '�ɹ��ҽ�Ʊ��';
comment on column SALE_PAID.SUCC_AMOUNT is '�ɹ��ҽ����';
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
comment on table SALE_PAID_DETAIL is '�ҽ������ӱ�';
comment on column SALE_PAID_DETAIL.DJXQ_NO is '�ҽ������ţ�DX12345678��';
comment on column SALE_PAID_DETAIL.DJXQ_SEQ_NO is '˳���';
comment on column SALE_PAID_DETAIL.PLAN_CODE is '��������';
comment on column SALE_PAID_DETAIL.BATCH_NO is '����';
comment on column SALE_PAID_DETAIL.PACKAGE_NO is '����';
comment on column SALE_PAID_DETAIL.TICKET_NO is 'Ʊ��';
comment on column SALE_PAID_DETAIL.SECURITY_CODE is '��������';
comment on column SALE_PAID_DETAIL.PAID_STATUS is '�ҽ�״̬��1-�ɹ���2-�Ƿ�Ʊ��3-�Ѷҽ���4-�д󽱡�5-δ�н���6-δ���ۣ�';
comment on column SALE_PAID_DETAIL.PAY_FLOW is '�ҽ���ˮ��';
comment on column SALE_PAID_DETAIL.REWARD_AMOUNT is '�н����';
create index IDX_SALE_PAID_DETAIL_DJXQ on SALE_PAID_DETAIL(DJXQ_NO);
create index IDX_SALE_PAID_DETAIL_TICKET on SALE_PAID_DETAIL(PLAN_CODE,BATCH_NO,PACKAGE_NO,TICKET_NO);
create index IDX_SALE_PAID_DETAIL_FLOW on SALE_PAID_DETAIL(PAY_FLOW);

-- ��������
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
comment on table HIS_MM_FUND is '�г�����Ա�ʽ���ʷ';
comment on column HIS_MM_FUND.CALC_DATE is 'ͳ������';
comment on column HIS_MM_FUND.MARKET_ADMIN is '�г�����Ա';
comment on column HIS_MM_FUND.FLOW_TYPE is '�ʽ����ͣ�9-Ϊվ���ֵ��10-�ֽ��Ͻɣ�14-Ϊվ�����֣�0-��������ʾ�����ڳ�����ĩ��';
comment on column HIS_MM_FUND.AMOUNT is '�������';
comment on column HIS_MM_FUND.BE_ACCOUNT_BALANCE is '�ڳ����';
comment on column HIS_MM_FUND.AF_ACCOUNT_BALANCE is '��ĩ���';
create index IDX_HIS_MM_FUND_CALC on HIS_MM_FUND(CALC_DATE);
create index IDX_HIS_MM_FUND_MM_FLOW on HIS_MM_FUND(MARKET_ADMIN,FLOW_TYPE);

--------------------------------------------------------------------------------------

-- �����л��õ����к�
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
comment on table SWITCH_SCAN is '��Ʊ�ҽ�����';
comment on column SWITCH_SCAN.OLD_PAY_FLOW is '��Ʊ�ҽ����';
comment on column SWITCH_SCAN.PAID_TIME is '�ҽ�ʱ��';
comment on column SWITCH_SCAN.PAID_ADMIN is '�ҽ���';
comment on column SWITCH_SCAN.PAID_ORG is '��������';
comment on column SWITCH_SCAN.APPLY_TICKETS is '�ύƱ��';
comment on column SWITCH_SCAN.FAIL_NEW_TICKETS is 'ʧ����ƱƱ��';
comment on column SWITCH_SCAN.SUCC_TICKETS is '�ɹ��ҽ�Ʊ��';
comment on column SWITCH_SCAN.SUCC_AMOUNT is '�ɹ��ҽ����';

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
comment on table SWITCH_SCAN_DETAIL is '��Ʊ�ҽ��ӱ�';
comment on column SWITCH_SCAN_DETAIL.OLD_PAY_FLOW is '��Ʊ�ҽ����';
comment on column SWITCH_SCAN_DETAIL.OLD_PAY_SEQ is '��Ʊ��ϸ���';
comment on column SWITCH_SCAN_DETAIL.PAID_TIME is '�ҽ�ʱ��';
comment on column SWITCH_SCAN_DETAIL.PAID_ADMIN is '�ҽ���';
comment on column SWITCH_SCAN_DETAIL.PAID_ORG is '��������';
comment on column SWITCH_SCAN_DETAIL.PLAN_CODE is '��������';
comment on column SWITCH_SCAN_DETAIL.BATCH_NO is '����';
comment on column SWITCH_SCAN_DETAIL.PACKAGE_NO is '����';
comment on column SWITCH_SCAN_DETAIL.TICKET_NO is 'Ʊ��';
comment on column SWITCH_SCAN_DETAIL.SECURITY_CODE is '��������';
comment on column SWITCH_SCAN_DETAIL.PAID_STATUS is '�ҽ�״̬��1-�ɹ���3-�Ѷҽ���5-δ�н���7-��Ʊ��';
comment on column SWITCH_SCAN_DETAIL.REWARD_AMOUNT is '�н����';
comment on column SWITCH_SCAN_DETAIL.IS_NEW_TICKET is '�Ƿ���Ʊ';

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
comment on table HIS_ORG_INV_REPORT is '���������ʷ����';
comment on column HIS_ORG_INV_REPORT.CALC_DATE is 'ͳ������';
comment on column HIS_ORG_INV_REPORT.ORG_CODE is '���ű���';
comment on column HIS_ORG_INV_REPORT.PLAN_CODE is '����';
comment on column HIS_ORG_INV_REPORT.OPER_TYPE is '�������ͣ�1=�������⡢4=վ���˻���12=������⡢14=վ�����ۡ�20=��١�88=�ڳ���99=��ĩ��';
comment on column HIS_ORG_INV_REPORT.TICKETS is 'Ʊ��';
comment on column HIS_ORG_INV_REPORT.AMOUNT is '���';
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
comment on table HIS_AGENCY_INV is 'վ������ʷ';
comment on column HIS_AGENCY_INV.CALC_DATE is 'ͳ������';
comment on column HIS_AGENCY_INV.AGENCY_CODE is '����վ��';
comment on column HIS_AGENCY_INV.PLAN_CODE is '����';
comment on column HIS_AGENCY_INV.OPER_TYPE is '�ʽ����ͣ�10-�˻���20-���ۣ�88-�ڳ���99-��ĩ��';
comment on column HIS_AGENCY_INV.TICKETS is 'Ʊ��';
comment on column HIS_AGENCY_INV.AMOUNT is '���';
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
comment on table FLOW_ORG_COMM_DETAIL is '����Ӷ����ˮ';
comment on column FLOW_ORG_COMM_DETAIL.ORG_FUND_COMM_FLOW is '��ˮ�ţ�JGYJ12345678901234567890��';
comment on column FLOW_ORG_COMM_DETAIL.ORG_FUND_FLOW is '�ʽ���ˮ���';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_CODE is '����վ���';
comment on column FLOW_ORG_COMM_DETAIL.PLAN_NAME is '��������';
comment on column FLOW_ORG_COMM_DETAIL.ACC_NO is '�˻�����';
comment on column FLOW_ORG_COMM_DETAIL.ORG_CODE is '���ű���';
comment on column FLOW_ORG_COMM_DETAIL.TRADE_TIME is '����ʱ��';
comment on column FLOW_ORG_COMM_DETAIL.TRADE_AMOUNT is '���׽��';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_SALE_AMOUNT is 'վ�����۽��';
comment on column FLOW_ORG_COMM_DETAIL.ORG_SALE_COMM is '��������Ӷ��';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_CANCEL_AMOUNT is 'վ���˻����';
comment on column FLOW_ORG_COMM_DETAIL.ORG_CANCEL_COMM is '�����˻�Ӷ��';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_SALE_COMM_RATE is 'վ������Ӷ�����';
comment on column FLOW_ORG_COMM_DETAIL.ORG_SALE_COMM_RATE is '��������Ӷ�����';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_PAY_AMOUNT is 'վ��ҽ����';
comment on column FLOW_ORG_COMM_DETAIL.ORG_PAY_AMOUNT is '�����ҽ�Ӷ��';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_PAY_COMM_RATE is 'վ��ҽ�Ӷ�����';
comment on column FLOW_ORG_COMM_DETAIL.ORG_PAY_COMM_RATE is '�����ҽ�Ӷ�����';
create index IDX_FLOW_ORG_COMM_AGENCY on FLOW_ORG_COMM_DETAIL(ACC_NO);
create index IDX_FLOW_ORG_COMM_FLOW on FLOW_ORG_COMM_DETAIL(ORG_FUND_COMM_FLOW);

insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (11, 'վ�㰮�Ķҽ�Ӷ��ǧ��λ��', '10');
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (12, '�������Ķҽ�Ӷ��ǧ��λ��', '10');
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (15, '������Ϸ�Ƿ񿪷ţ�1=���ţ�2=�رգ�', '1');
commit;

CREATE OR REPLACE PACKAGE epaid_status IS
   /****** �ҽ�״̬��1-�ɹ���2-�Ƿ�Ʊ��3-�Ѷҽ���4-�д󽱡�5-δ�н���6-δ���ۡ�7-��Ʊ��	status  ******/
   succed               /* 1-�ɹ� */                    CONSTANT NUMBER := 1;
   invalid              /* 2-�Ƿ�Ʊ */                  CONSTANT NUMBER := 2;
   paid                 /* 3-�Ѷҽ� */                  CONSTANT NUMBER := 3;
   bigreward            /* 4-�д� */                  CONSTANT NUMBER := 4;
   nowin                /* 5-δ�н� */                  CONSTANT NUMBER := 5;
   nosale               /* 6-δ���� */                  CONSTANT NUMBER := 6;
   newticket            /* 7-��Ʊ   */                  CONSTANT NUMBER := 7;
   terminate            /* 8-�����ս� */                CONSTANT NUMBER := 8;
END;
/
