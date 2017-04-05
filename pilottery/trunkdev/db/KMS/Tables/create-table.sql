create table ADM_INFO(
	ADMIN_ID NUMBER(4)  not null,
	ADMIN_REALNAME VARCHAR2(1000)  not null,
	ADMIN_LOGIN VARCHAR2(32)  not null,
	ADMIN_PASSWORD CHAR(32)  not null,
	ADMIN_GENDER NUMBER(1)  not null,
	ADMIN_EMAIL VARCHAR2(100)  ,
	ADMIN_BIRTHDAY DATE  ,
	ADMIN_TEL VARCHAR2(50)  ,
	ADMIN_MOBILE VARCHAR2(50)  ,
	ADMIN_PHONE VARCHAR2(50)  ,
	ADMIN_ORG CHAR(2)  ,
	ADMIN_ADDRESS VARCHAR2(4000)  ,
	ADMIN_REMARK VARCHAR2(4000)  ,
	ADMIN_STATUS NUMBER(1) default 1 not null,
	ADMIN_CREATE_TIME DATE default sysdate ,
	ADMIN_UPDATE_TIME DATE default sysdate ,
	ADMIN_LOGIN_TIME DATE default sysdate ,
	ADMIN_LOGIN_COUNT NUMBER(10) default 0 ,
	ADMIN_AGREEDAY VARCHAR2(7)  ,
	ADMIN_LOGIN_BEGIN VARCHAR2(15)  ,
	ADMIN_LOGIN_END VARCHAR2(15)  ,
	CREATE_ADMIN_ID NUMBER(4) default 0 ,
	ADMIN_IP_LIMIT VARCHAR2(200)  ,
	LOGIN_STATUS NUMBER(1) default 0 not null,
	IS_COLLECTER NUMBER(1) default 0 not null,
	IS_WAREHOUSE_M NUMBER(1) default 0 not null,
	constraint PK_ADM_INFO primary Key (ADMIN_ID)
);
comment on table ADM_INFO is '�û���Ϣ��';
comment on column ADM_INFO.ADMIN_ID is '�û�ID';
comment on column ADM_INFO.ADMIN_REALNAME is '��ʵ����';
comment on column ADM_INFO.ADMIN_LOGIN is '��¼��';
comment on column ADM_INFO.ADMIN_PASSWORD is '����';
comment on column ADM_INFO.ADMIN_GENDER is '�Ա�(1-�У�2-Ů)';
comment on column ADM_INFO.ADMIN_EMAIL is 'EMAIL��ַ';
comment on column ADM_INFO.ADMIN_BIRTHDAY is '����';
comment on column ADM_INFO.ADMIN_TEL is '�칫�绰';
comment on column ADM_INFO.ADMIN_MOBILE is '�ƶ��绰';
comment on column ADM_INFO.ADMIN_PHONE is 'סլ�绰';
comment on column ADM_INFO.ADMIN_ORG is '��������';
comment on column ADM_INFO.ADMIN_ADDRESS is '��ͥ��ַ';
comment on column ADM_INFO.ADMIN_REMARK is '��ע';
comment on column ADM_INFO.ADMIN_STATUS is '�û�״̬(1-���ã�2-ɾ����3-��������ԭ��ͣ��)';
comment on column ADM_INFO.ADMIN_CREATE_TIME is '����ʱ��';
comment on column ADM_INFO.ADMIN_UPDATE_TIME is '����ʱ��';
comment on column ADM_INFO.ADMIN_LOGIN_TIME is '��½ʱ��';
comment on column ADM_INFO.ADMIN_LOGIN_COUNT is '��½����';
comment on column ADM_INFO.ADMIN_AGREEDAY is '��һ��֮�ڵĿ���ʱ�䣨����Ϊ��λ��';
comment on column ADM_INFO.ADMIN_LOGIN_BEGIN is 'ÿ��ɵ�½�Ŀ�ʼʱ��';
comment on column ADM_INFO.ADMIN_LOGIN_END is 'ÿ��ɵ�½�Ľ���ʱ��';
comment on column ADM_INFO.CREATE_ADMIN_ID is '������ID';
comment on column ADM_INFO.ADMIN_IP_LIMIT is '�ɵ�½��IP��Χ';
comment on column ADM_INFO.LOGIN_STATUS is '�û�����״̬(1-���ߣ�2-����)';
comment on column ADM_INFO.IS_COLLECTER is '�Ƿ�ɿ�Ա';
comment on column ADM_INFO.IS_WAREHOUSE_M is '�Ƿ�ֿ����Ա';

create table ADM_ROLE(
	ROLE_ID NUMBER(4) default 0 not null,
	ROLE_NAME VARCHAR2(1000)  not null,
	IS_ACTIVE NUMBER(1) default 0 not null,
	ROLE_COMMENT VARCHAR2(4000)  ,
	ROLE_CODE VARCHAR2(50)  ,
	constraint PK_ADM_ROLE primary Key (ROLE_ID)
);
comment on table ADM_ROLE is '��ɫ��Ϣ��';
comment on column ADM_ROLE.ROLE_ID is '��ɫid';
comment on column ADM_ROLE.ROLE_NAME is '��ɫ����';
comment on column ADM_ROLE.IS_ACTIVE is '��ɫ�Ƿ�ͨ (0=�رա�1=��ͨ)';
comment on column ADM_ROLE.ROLE_COMMENT is '��ע';
comment on column ADM_ROLE.ROLE_CODE is '��ɫ����';

create table ADM_ROLE_ADMIN(
	ADMIN_ID NUMBER(4)  not null,
	ROLE_ID NUMBER(4)  not null,
	constraint PK_ADM_ROLE_ADMIN primary Key (ADMIN_ID,ROLE_ID)
);
comment on table ADM_ROLE_ADMIN is '����Ա��ɫ��Ϣ��';
comment on column ADM_ROLE_ADMIN.ADMIN_ID is '�û�ID';
comment on column ADM_ROLE_ADMIN.ROLE_ID is '��ɫID';

create table ADM_PRIVILEGE(
	PRIVILEGE_ID NUMBER(6)  not null,
	PRIVILEGE_NAME VARCHAR2(1000)  not null,
	PRIVILEGE_CODE VARCHAR2(500)  not null,
	PRIVILEGE_SYSTEM NUMBER(1)  not null,
	PRIVILEGE_IS_CENTER NUMBER(1)  ,
	PRIVILEGE_AGREEDAY VARCHAR2(7)  ,
	PRIVILEGE_LOGINBEGIN VARCHAR2(10)  ,
	PRIVILEGE_LOGINEND VARCHAR2(10)  ,
	PRIVILEGE_REMARK VARCHAR2(4000)  ,
	PRIVILEGE_URL VARCHAR2(200)  ,
	PRIVILEGE_PARENT NUMBER(8) default 0 ,
	PRIVILEGE_LEVEL NUMBER(8) default 0 ,
	PRIVILEGE_ORDER NUMBER(2) default 0 ,
	constraint PK_ADM_PRIVILEGE primary Key (PRIVILEGE_ID)
);
comment on table ADM_PRIVILEGE is '����ģ�飨�˵����б�';
comment on column ADM_PRIVILEGE.PRIVILEGE_ID is '����ģ��id';
comment on column ADM_PRIVILEGE.PRIVILEGE_NAME is '����ģ������';
comment on column ADM_PRIVILEGE.PRIVILEGE_CODE is '����ģ��ϵͳ��ʶ';
comment on column ADM_PRIVILEGE.PRIVILEGE_SYSTEM is '������ϵͳ';
comment on column ADM_PRIVILEGE.PRIVILEGE_IS_CENTER is '�Ƿ�����ר��';
comment on column ADM_PRIVILEGE.PRIVILEGE_AGREEDAY is '����ģ����һ��֮�ڵĿ���ʱ�䣨����Ϊ��λ��';
comment on column ADM_PRIVILEGE.PRIVILEGE_LOGINBEGIN is '����ģ������ʼ��ʱ��';
comment on column ADM_PRIVILEGE.PRIVILEGE_LOGINEND is '����ģ�����������ʱ��';
comment on column ADM_PRIVILEGE.PRIVILEGE_REMARK is '����ģ������';
comment on column ADM_PRIVILEGE.PRIVILEGE_URL is '�˵�URL��ַ';
comment on column ADM_PRIVILEGE.PRIVILEGE_PARENT is '������ģ��';
comment on column ADM_PRIVILEGE.PRIVILEGE_LEVEL is '����ģ�鼶��';
comment on column ADM_PRIVILEGE.PRIVILEGE_ORDER is '����';

create table ADM_ROLE_PRIVILEGE(
	ROLE_ID NUMBER(4)  not null,
	PRIVILEGE_ID NUMBER(6)  not null,
	constraint PK_ADM_ROLE_PRIVILEGE primary Key (ROLE_ID,PRIVILEGE_ID)
);
comment on table ADM_ROLE_PRIVILEGE is '��ɫ���ܶ�Ӧ��';
comment on column ADM_ROLE_PRIVILEGE.ROLE_ID is '��ɫ����';
comment on column ADM_ROLE_PRIVILEGE.PRIVILEGE_ID is '����ģ��id';

create table INF_AREAS(
	AREA_CODE CHAR(4)  not null,
	AREA_NAME VARCHAR2(500)  not null,
	SUPER_AREA CHAR(4)  not null,
	STATUS NUMBER(1)  not null,
	AREA_TYPE NUMBER(1)  not null,
	constraint PK_INF_AREAS primary Key (AREA_CODE)
);
comment on table INF_AREAS is '���������Ϣ';
comment on column INF_AREAS.AREA_CODE is '������루0000����ȫ����0100����ʡ��0101��������';
comment on column INF_AREAS.AREA_NAME is '��������';
comment on column INF_AREAS.SUPER_AREA is '���������';
comment on column INF_AREAS.STATUS is '����״̬��1=��Ч��2=��Ч��';
comment on column INF_AREAS.AREA_TYPE is '�������ͣ�0=ȫ����1=ʡ��2=�У�';

create table INF_ORGS(
	ORG_CODE CHAR(2)  not null,
	ORG_NAME VARCHAR2(4000)  not null,
	ORG_TYPE NUMBER(1)  not null,
	ORG_STATUS NUMBER(1)  not null,
	SUPER_ORG CHAR(2)  not null,
	PHONE VARCHAR2(100)  ,
	DIRECTOR_ADMIN NUMBER(4)  ,
	PERSONS NUMBER(6) default 0 not null,
	ADDRESS VARCHAR2(4000)  ,
	constraint PK_INF_ORGS primary Key (ORG_CODE)
);
comment on table INF_ORGS is '��֯����������Ϣ';
comment on column INF_ORGS.ORG_CODE is '�������루00�����ܹ�˾��01����ֹ�˾��';
comment on column INF_ORGS.ORG_NAME is '��������';
comment on column INF_ORGS.ORG_TYPE is '�������1-��˾,2-����';
comment on column INF_ORGS.ORG_STATUS is '����״̬��1-���ã�2-ɾ����';
comment on column INF_ORGS.SUPER_ORG is '�����ϼ�';
comment on column INF_ORGS.PHONE is '������ϵ�绰';
comment on column INF_ORGS.DIRECTOR_ADMIN is '������';
comment on column INF_ORGS.PERSONS is '��������';
comment on column INF_ORGS.ADDRESS is '��ַ';

create table INF_ORG_AREA(
	ORG_CODE CHAR(2)  not null,
	AREA_CODE CHAR(4)  not null,
	constraint PK_INF_ORG_AREA primary Key (ORG_CODE,AREA_CODE)
);
comment on table INF_ORG_AREA is '��֯������������';
comment on column INF_ORG_AREA.ORG_CODE is '���ű���';
comment on column INF_ORG_AREA.AREA_CODE is '�������';
create index UDX_INF_ORG_AREA on INF_ORG_AREA(AREA_CODE);

create table INF_AGENCYS(
	AGENCY_CODE CHAR(8)  not null,
	AGENCY_NAME VARCHAR2(1000)  not null,
	STORETYPE_ID NUMBER(2)  not null,
	STATUS NUMBER(1)  not null,
	AGENCY_TYPE NUMBER(1) default 1 not null,
	BANK_ID NUMBER(4)  ,
	BANK_ACCOUNT VARCHAR2(32)  ,
	TELEPHONE VARCHAR2(100)  ,
	CONTACT_PERSON VARCHAR2(500)  ,
	ADDRESS VARCHAR2(4000)  ,
	AGENCY_ADD_TIME DATE default sysdate not null,
	QUIT_TIME DATE  ,
	ORG_CODE CHAR(2)  not null,
	AREA_CODE CHAR(4)  not null,
	LOGIN_PASS VARCHAR2(32)  ,
	TRADE_PASS VARCHAR2(32)  ,
	MARKET_MANAGER_ID NUMBER(4)  ,
	constraint PK_INF_AGENCYS primary Key (AGENCY_CODE)
);
comment on table INF_AGENCYS is 'վ�������Ϣ';
comment on column INF_AGENCYS.AGENCY_CODE is '����վ���루4λ�������+4λ˳��ţ�';
comment on column INF_AGENCYS.AGENCY_NAME is '����վ����';
comment on column INF_AGENCYS.STORETYPE_ID is '��������ID';
comment on column INF_AGENCYS.STATUS is '����վ״̬��1=���ã�2=�ѽ��ã�3=�����ˣ�';
comment on column INF_AGENCYS.AGENCY_TYPE is '����վ���ͣ�1=��ͳ�ն�(Ԥ����)��2=�����ն�(�󸶷�)��3=��ֽ����4=��������վ��';
comment on column INF_AGENCYS.BANK_ID is '����ID';
comment on column INF_AGENCYS.BANK_ACCOUNT is '�����˺�';
comment on column INF_AGENCYS.TELEPHONE is '����վ�绰';
comment on column INF_AGENCYS.CONTACT_PERSON is '����վ��ϵ��';
comment on column INF_AGENCYS.ADDRESS is '����վ��ַ';
comment on column INF_AGENCYS.AGENCY_ADD_TIME is '����վ���ʱ��';
comment on column INF_AGENCYS.QUIT_TIME is '����ʱ��';
comment on column INF_AGENCYS.ORG_CODE is '�������ű���';
comment on column INF_AGENCYS.AREA_CODE is '�����������';
comment on column INF_AGENCYS.LOGIN_PASS is '��¼����';
comment on column INF_AGENCYS.TRADE_PASS is '��������';
comment on column INF_AGENCYS.MARKET_MANAGER_ID is '�г�����Ա����';
create index IDX_SALER_AGENCY_AREA on INF_AGENCYS(AREA_CODE);

create table INF_AGENCY_EXT(
	AGENCY_CODE CHAR(8)  not null,
	PERSONAL_ID VARCHAR2(100)  ,
	CONTRACT_NO VARCHAR2(100)  ,
	GLATLNG_N VARCHAR2(20)  ,
	GLATLNG_E VARCHAR2(20)  ,
	constraint PK_INF_AGENCY_EXT primary Key (AGENCY_CODE)
);
comment on table INF_AGENCY_EXT is 'վ����չ��Ϣ';
comment on column INF_AGENCY_EXT.AGENCY_CODE is '����վ����';
comment on column INF_AGENCY_EXT.PERSONAL_ID is '֤������';
comment on column INF_AGENCY_EXT.CONTRACT_NO is '��ͬ���';
comment on column INF_AGENCY_EXT.GLATLNG_N is '����վ����';
comment on column INF_AGENCY_EXT.GLATLNG_E is '����վά��';

create table INF_AGENCY_DELETE(
	DELETE_NO CHAR(10)  not null,
	AGENCY_CODE CHAR(8)  not null,
	AGENCY_NAME VARCHAR2(1000)  ,
	AVAILABLE_CREDIT NUMBER(28)  not null,
	TEMP_CREDIT NUMBER(28)  not null,
	MARGINAL_CREDIT NUMBER(28)  not null,
	OPER_TIME DATE  not null,
	OPER_ADMIN NUMBER(4)  not null,
	constraint PK_INF_AGENCY_DELETE primary Key (DELETE_NO)
);
comment on table INF_AGENCY_DELETE is '����վ����';
comment on column INF_AGENCY_DELETE.DELETE_NO is '���˱�ţ�QT12345678��';
comment on column INF_AGENCY_DELETE.AGENCY_CODE is '����վ����';
comment on column INF_AGENCY_DELETE.AGENCY_NAME is '����վ����';
comment on column INF_AGENCY_DELETE.AVAILABLE_CREDIT is '����վ���';
comment on column INF_AGENCY_DELETE.TEMP_CREDIT is '��ʱ���ö��';
comment on column INF_AGENCY_DELETE.MARGINAL_CREDIT is '�������ö��';
comment on column INF_AGENCY_DELETE.OPER_TIME is '����ʱ��';
comment on column INF_AGENCY_DELETE.OPER_ADMIN is '�����˱���';

create table INF_MARKET_ADMIN(
	MARKET_ADMIN NUMBER(4)  ,
	TRANS_PASS VARCHAR2(32)  ,
	CREDIT_BY_TRAN NUMBER(28)  ,
	MAX_AMOUNT_TICKETSS NUMBER(28)  ,
	constraint PK_INF_MARKET_ADMIN primary Key (MARKET_ADMIN)
);
comment on table INF_MARKET_ADMIN is '�ɿ�רԱ';
comment on column INF_MARKET_ADMIN.MARKET_ADMIN is '�г�����Ա';
comment on column INF_MARKET_ADMIN.TRANS_PASS is '��������';
comment on column INF_MARKET_ADMIN.CREDIT_BY_TRAN is 'ÿ�ʽ����޶�';
comment on column INF_MARKET_ADMIN.MAX_AMOUNT_TICKETSS is '�����Ʊ���';

create table INF_BANKS(
	BANK_ID NUMBER(4)  not null,
	BANK_NAME VARCHAR2(200)  ,
	constraint PK_INF_BANKS primary Key (BANK_ID)
);
comment on table INF_BANKS is '���л�����Ϣ';
comment on column INF_BANKS.BANK_ID is '����ID';
comment on column INF_BANKS.BANK_NAME is '��������';

create table INF_STORETYPES(
	STORETYPE_ID NUMBER(2)  not null,
	STORETYPE_NAME VARCHAR2(4000)  not null,
	IS_VALID NUMBER(1)  not null,
	constraint PK_INF_STORETYPES primary Key (STORETYPE_ID)
);
comment on table INF_STORETYPES is '�������ͻ�����Ϣ';
comment on column INF_STORETYPES.STORETYPE_ID is '����ID';
comment on column INF_STORETYPES.STORETYPE_NAME is '��������';
comment on column INF_STORETYPES.IS_VALID is '�Ƿ�����';

create table INF_PUBLISHERS(
	PUBLISHER_CODE NUMBER(2)  not null,
	PUBLISHER_NAME VARCHAR2(500)  not null,
	IS_VALID NUMBER(1) default 1 not null,
	PLAN_FLOW NUMBER(1)  ,
	constraint PK_INF_PUBLISHERS primary Key (PUBLISHER_CODE)
);
comment on table INF_PUBLISHERS is 'ӡ�Ƴ��̻�����Ϣ';
comment on column INF_PUBLISHERS.PUBLISHER_CODE is 'ӡ�Ƴ��̱���';
comment on column INF_PUBLISHERS.PUBLISHER_NAME is 'ӡ�Ƴ�������';
comment on column INF_PUBLISHERS.IS_VALID is '�Ƿ���Ч��1-��Ч��0-��Ч��';
comment on column INF_PUBLISHERS.PLAN_FLOW is 'Ӧ�ԵĴ������̣�1-A�ƻ���2-B�ƻ���';

create table INF_TERMINAL(
	TERMINAL_CODE CHAR(8)  not null,
	TERM_IDENTITY_CODE VARCHAR2(100)  ,
	constraint PK_INF_TERMINAL primary Key (TERMINAL_CODE)
);
comment on table INF_TERMINAL is '�ն˻�����';
comment on column INF_TERMINAL.TERMINAL_CODE is '�ն˻�����';
comment on column INF_TERMINAL.TERM_IDENTITY_CODE is '�ն˻�Ψһ��ʶ';

create table ACC_ORG_ACCOUNT(
	ORG_CODE CHAR(2)  not null,
	ACC_TYPE NUMBER(1) default 1 not null,
	ACC_NAME VARCHAR2(4000)  not null,
	ACC_STATUS NUMBER(1)  not null,
	ACC_NO CHAR(12)  not null,
	CREDIT_LIMIT NUMBER(28) default 0 not null,
	ACCOUNT_BALANCE NUMBER(28) default 0 not null,
	FROZEN_BALANCE NUMBER(28) default 0 not null,
	CHECK_CODE VARCHAR2(40)  not null,
	constraint PK_ACC_ORG_ACCOUNT primary Key (ACC_NO)
);
comment on table ACC_ORG_ACCOUNT is '��֯�����˻���Ϣ';
comment on column ACC_ORG_ACCOUNT.ORG_CODE is '���ű���';
comment on column ACC_ORG_ACCOUNT.ACC_TYPE is '�˻����ͣ�1-��Ҫ�˻���';
comment on column ACC_ORG_ACCOUNT.ACC_NAME is '�˻�����';
comment on column ACC_ORG_ACCOUNT.ACC_STATUS is '�˻�״̬��1-���ã�2-ͣ�ã�3-�쳣��';
comment on column ACC_ORG_ACCOUNT.ACC_NO is '�˻����루JG+2λ����+8λ˳��';
comment on column ACC_ORG_ACCOUNT.CREDIT_LIMIT is '���ö��';
comment on column ACC_ORG_ACCOUNT.ACCOUNT_BALANCE is '�������';
comment on column ACC_ORG_ACCOUNT.FROZEN_BALANCE is '������';
comment on column ACC_ORG_ACCOUNT.CHECK_CODE is 'У���루ȫ����';

create table ACC_AGENCY_ACCOUNT(
	AGENCY_CODE CHAR(8)  not null,
	ACC_TYPE NUMBER(1) default 1 not null,
	ACC_NAME VARCHAR2(4000)  not null,
	ACC_STATUS NUMBER(1)  not null,
	ACC_NO CHAR(12)  not null,
	CREDIT_LIMIT NUMBER(28) default 0 not null,
	ACCOUNT_BALANCE NUMBER(28) default 0 not null,
	FROZEN_BALANCE NUMBER(28) default 0 not null,
	CHECK_CODE VARCHAR2(40)  not null,
	constraint PK_ACC_AGENCY_ACCOUNT primary Key (ACC_NO)
);
comment on table ACC_AGENCY_ACCOUNT is 'վ���˻���Ϣ';
comment on column ACC_AGENCY_ACCOUNT.AGENCY_CODE is '����վ����';
comment on column ACC_AGENCY_ACCOUNT.ACC_TYPE is '�˻����ͣ�1-��Ҫ�˻���';
comment on column ACC_AGENCY_ACCOUNT.ACC_NAME is '�˻�����';
comment on column ACC_AGENCY_ACCOUNT.ACC_STATUS is '�˻�״̬��1-���ã�2-ͣ�ã�3-�쳣��';
comment on column ACC_AGENCY_ACCOUNT.ACC_NO is '�˻����루ZD+8λվ��+2λ˳��';
comment on column ACC_AGENCY_ACCOUNT.CREDIT_LIMIT is '���ö��';
comment on column ACC_AGENCY_ACCOUNT.ACCOUNT_BALANCE is '�������';
comment on column ACC_AGENCY_ACCOUNT.FROZEN_BALANCE is '������';
comment on column ACC_AGENCY_ACCOUNT.CHECK_CODE is 'У���루ȫ����';

create table ACC_MM_ACCOUNT(
	MARKET_ADMIN NUMBER(4)  not null,
	ACC_TYPE NUMBER(1) default 1 not null,
	ACC_NAME VARCHAR2(4000)  not null,
	ACC_STATUS NUMBER(1)  not null,
	ACC_NO CHAR(12)  not null,
	CREDIT_LIMIT NUMBER(28) default 0 not null,
	ACCOUNT_BALANCE NUMBER(28) default 0 not null,
	CHECK_CODE VARCHAR2(40)  not null,
	constraint PK_ACC_MM_ACCOUNT primary Key (ACC_NO)
);
comment on table ACC_MM_ACCOUNT is '�г�����Ա�˻���Ϣ';
comment on column ACC_MM_ACCOUNT.MARKET_ADMIN is '�г�����Ա';
comment on column ACC_MM_ACCOUNT.ACC_TYPE is '�˻����ͣ�1-��Ҫ�˻���';
comment on column ACC_MM_ACCOUNT.ACC_NAME is '�˻�����';
comment on column ACC_MM_ACCOUNT.ACC_STATUS is '�˻�״̬��1-���ã�2-ͣ�ã�3-�쳣��';
comment on column ACC_MM_ACCOUNT.ACC_NO is '�˻����루MM+4λ�û����+6λ˳��';
comment on column ACC_MM_ACCOUNT.CREDIT_LIMIT is '���ö��';
comment on column ACC_MM_ACCOUNT.ACCOUNT_BALANCE is '�������';
comment on column ACC_MM_ACCOUNT.CHECK_CODE is 'У���루ȫ����';

create table ACC_MM_TICKETS(
	MARKET_ADMIN NUMBER(4)  ,
	PLAN_CODE VARCHAR2(10)  ,
	BATCH_NO VARCHAR2(10)  not null,
	TICKETS NUMBER(20)  ,
	AMOUNT NUMBER(28)  ,
	constraint PK_ACC_MM_TICKETS primary Key (MARKET_ADMIN,PLAN_CODE,BATCH_NO)
);
comment on table ACC_MM_TICKETS is '�г�����Ա��Ʊ��';
comment on column ACC_MM_TICKETS.MARKET_ADMIN is '�г�����ԱID';
comment on column ACC_MM_TICKETS.PLAN_CODE is '����';
comment on column ACC_MM_TICKETS.BATCH_NO is '����';
comment on column ACC_MM_TICKETS.TICKETS is 'Ʊ��';
comment on column ACC_MM_TICKETS.AMOUNT is '���';

create table GAME_PLANS(
	PLAN_CODE VARCHAR2(10)  not null,
	FULL_NAME VARCHAR2(4000)  not null,
	SHORT_NAME VARCHAR2(4000)  not null,
	TICKET_AMOUNT NUMBER(10) default 0 not null,
	PUBLISHER_CODE NUMBER(2)  not null,
	LOTTERY_TYPE NUMBER(1) default 1 not null,
	constraint PK_GAME_PLANS primary Key (PLAN_CODE)
);
comment on table GAME_PLANS is '����������Ϣ';
comment on column GAME_PLANS.PLAN_CODE is '��������';
comment on column GAME_PLANS.FULL_NAME is '��������';
comment on column GAME_PLANS.SHORT_NAME is '������д';
comment on column GAME_PLANS.TICKET_AMOUNT is '��Ʊ����ֵ��';
comment on column GAME_PLANS.PUBLISHER_CODE is 'ӡ�Ƴ���';
comment on column GAME_PLANS.LOTTERY_TYPE is '��Ʊ���ͣ�1-��׼��2-�����ԣ�';

create table GAME_ORG_COMM_RATE(
	ORG_CODE CHAR(2)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	SALE_COMM NUMBER(8)  not null,
	PAY_COMM NUMBER(8)  not null,
	constraint PK_GAME_ORG_COMM_RATE primary Key (ORG_CODE,PLAN_CODE)
);
comment on table GAME_ORG_COMM_RATE is '��������Ӷ��';
comment on column GAME_ORG_COMM_RATE.ORG_CODE is '���ű���';
comment on column GAME_ORG_COMM_RATE.PLAN_CODE is '��������';
comment on column GAME_ORG_COMM_RATE.SALE_COMM is '����Ӷ�����';
comment on column GAME_ORG_COMM_RATE.PAY_COMM is '�ҽ�Ӷ�����';

create table GAME_AGENCY_COMM_RATE(
	AGENCY_CODE CHAR(8)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	SALE_COMM NUMBER(8)  not null,
	PAY_COMM NUMBER(8)  not null,
	constraint PK_GAME_AGENCY_COMM_RATE primary Key (AGENCY_CODE,PLAN_CODE)
);
comment on table GAME_AGENCY_COMM_RATE is 'վ�㷽��Ӷ��';
comment on column GAME_AGENCY_COMM_RATE.AGENCY_CODE is '����վ����';
comment on column GAME_AGENCY_COMM_RATE.PLAN_CODE is '��������';
comment on column GAME_AGENCY_COMM_RATE.SALE_COMM is '����Ӷ�����';
comment on column GAME_AGENCY_COMM_RATE.PAY_COMM is '�ҽ�Ӷ�����';

create table GAME_BATCH_IMPORT(
	IMPORT_NO CHAR(12)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	PACKAGE_FILE VARCHAR2(500)  not null,
	REWARD_MAP_FILE VARCHAR2(500)  not null,
	REWARD_DETAIL_FILE VARCHAR2(500)  not null,
	START_DATE DATE  ,
	END_DATE DATE  ,
	IMPORT_ADMIN NUMBER(4)  not null,
	constraint PK_GAME_BATCH_IMPORT primary Key (IMPORT_NO)
);
comment on table GAME_BATCH_IMPORT is '������Ϣ����';
comment on column GAME_BATCH_IMPORT.IMPORT_NO is '���ݵ�����ţ�IMP-12345678��';
comment on column GAME_BATCH_IMPORT.PLAN_CODE is '��������';
comment on column GAME_BATCH_IMPORT.BATCH_NO is '��������';
comment on column GAME_BATCH_IMPORT.PACKAGE_FILE is '��װ��Ϣ�ļ�';
comment on column GAME_BATCH_IMPORT.REWARD_MAP_FILE is '�������ɱ��ļ�';
comment on column GAME_BATCH_IMPORT.REWARD_DETAIL_FILE is '�н���ϸ�ļ�';
comment on column GAME_BATCH_IMPORT.START_DATE is '���뿪ʼʱ��';
comment on column GAME_BATCH_IMPORT.END_DATE is '�������ʱ��';
comment on column GAME_BATCH_IMPORT.IMPORT_ADMIN is '������';
create index UDX_GAME_BATCH_IMPORT on GAME_BATCH_IMPORT(PLAN_CODE,BATCH_NO);

create table GAME_BATCH_IMPORT_DETAIL(
	IMPORT_NO CHAR(12)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	LOTTERY_TYPE VARCHAR2(500)  not null,
	LOTTERY_NAME VARCHAR2(500)  not null,
	BOXES_EVERY_TRUNK NUMBER(10)  not null,
	TRUNKS_EVERY_GROUP NUMBER(10)  not null,
	PACKS_EVERY_TRUNK NUMBER(10)  not null,
	TICKETS_EVERY_PACK NUMBER(10)  not null,
	TICKETS_EVERY_GROUP NUMBER(18)  not null,
	FIRST_REWARD_GROUP_NO NUMBER(10)  not null,
	TICKETS_EVERY_BATCH NUMBER(18)  not null,
	FIRST_TRUNK_BATCH NUMBER(18)  not null,
	STATUS NUMBER(1)  not null,
	constraint PK_GAME_BATCH_IMPORT_DETAIL primary Key (IMPORT_NO)
);
comment on table GAME_BATCH_IMPORT_DETAIL is '������Ϣ����֮��װ';
comment on column GAME_BATCH_IMPORT_DETAIL.IMPORT_NO is '���ݵ�����ţ�IMP-12345678��';
comment on column GAME_BATCH_IMPORT_DETAIL.PLAN_CODE is '��������';
comment on column GAME_BATCH_IMPORT_DETAIL.BATCH_NO is '��������';
comment on column GAME_BATCH_IMPORT_DETAIL.LOTTERY_TYPE is '��Ʊ����';
comment on column GAME_BATCH_IMPORT_DETAIL.LOTTERY_NAME is '��Ʊ����';
comment on column GAME_BATCH_IMPORT_DETAIL.BOXES_EVERY_TRUNK is 'ÿ�����';
comment on column GAME_BATCH_IMPORT_DETAIL.TRUNKS_EVERY_GROUP is 'ÿ������';
comment on column GAME_BATCH_IMPORT_DETAIL.PACKS_EVERY_TRUNK is 'ÿ�䱾��';
comment on column GAME_BATCH_IMPORT_DETAIL.TICKETS_EVERY_PACK is 'ÿ������';
comment on column GAME_BATCH_IMPORT_DETAIL.TICKETS_EVERY_GROUP is '�������������ţ�';
comment on column GAME_BATCH_IMPORT_DETAIL.FIRST_REWARD_GROUP_NO is '�׷����';
comment on column GAME_BATCH_IMPORT_DETAIL.TICKETS_EVERY_BATCH is '��������';
comment on column GAME_BATCH_IMPORT_DETAIL.FIRST_TRUNK_BATCH is '����������';
comment on column GAME_BATCH_IMPORT_DETAIL.STATUS is '״̬��1-���ã�2-��ͣ��3-���У�';
create index UDX_GAME_BATCH_IMPORT_DETAIL on GAME_BATCH_IMPORT_DETAIL(PLAN_CODE,BATCH_NO);

create table GAME_BATCH_IMPORT_REWARD(
	IMPORT_NO CHAR(12)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	REWARD_NO NUMBER(3)  not null,
	FAST_IDENTITY_CODE VARCHAR2(4000)  not null,
	SINGLE_REWARD_AMOUNT NUMBER(18)  not null,
	COUNTS NUMBER(18)  not null,
	constraint PK_GAME_BATCH_IMPORT_REWARD primary Key (IMPORT_NO,REWARD_NO)
);
comment on table GAME_BATCH_IMPORT_REWARD is '������Ϣ����֮����';
comment on column GAME_BATCH_IMPORT_REWARD.IMPORT_NO is '���ݵ�����ţ�IMP-12345678��';
comment on column GAME_BATCH_IMPORT_REWARD.PLAN_CODE is '��������';
comment on column GAME_BATCH_IMPORT_REWARD.BATCH_NO is '��������';
comment on column GAME_BATCH_IMPORT_REWARD.REWARD_NO is '����';
comment on column GAME_BATCH_IMPORT_REWARD.FAST_IDENTITY_CODE is '��������ʶ���루����ͨ�����Ž��зָ';
comment on column GAME_BATCH_IMPORT_REWARD.SINGLE_REWARD_AMOUNT is '��ע�н����';
comment on column GAME_BATCH_IMPORT_REWARD.COUNTS is '������';
create index IDX_GAME_BATCH_REWARD_GAME on GAME_BATCH_IMPORT_REWARD(PLAN_CODE,BATCH_NO,REWARD_NO);

create table GAME_BATCH_REWARD_DETAIL(
	IMPORT_NO CHAR(12)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	SAFE_CODE VARCHAR2(50)  not null,
	IS_PAID NUMBER(1) default 0 not null,
   pre_safe_code generated always as (substr(SAFE_CODE,1,16)),
	constraint PK_GAME_BATCH_REWARD_DETAIL primary Key (IMPORT_NO,PLAN_CODE,BATCH_NO,SAFE_CODE)
);
comment on table GAME_BATCH_REWARD_DETAIL is '������Ϣ����֮�н���ϸ';
comment on column GAME_BATCH_REWARD_DETAIL.IMPORT_NO is '���ݵ�����ţ�IMP-12345678��';
comment on column GAME_BATCH_REWARD_DETAIL.PLAN_CODE is '��������';
comment on column GAME_BATCH_REWARD_DETAIL.BATCH_NO is '��������';
comment on column GAME_BATCH_REWARD_DETAIL.SAFE_CODE is '��ȫ��';
comment on column GAME_BATCH_REWARD_DETAIL.IS_PAID is '�Ƿ��Ѿ��ҽ�';
create index idx_GAME_BATCH_REWARD_pbs on game_batch_reward_detail(PLAN_CODE,BATCH_NO,SAFE_CODE);
create index idx_GAME_BATCH_REWARD_pre on game_batch_reward_detail(PLAN_CODE,BATCH_NO,pre_safe_code);

create table WH_INFO(
	WAREHOUSE_CODE CHAR(4)  not null,
	WAREHOUSE_NAME VARCHAR2(4000)  not null,
	ORG_CODE CHAR(2)  not null,
	ADDRESS VARCHAR2(4000)  not null,
	PHONE VARCHAR2(100)  not null,
	DIRECTOR_ADMIN NUMBER(4)  not null,
	STATUS NUMBER(1)  not null,
	CREATE_ADMIN NUMBER(4)  not null,
	CREATE_DATE DATE  not null,
	STOP_ADMIN NUMBER(4)  ,
	STOP_DATE DATE  ,
	constraint PK_WH_INFO primary Key (WAREHOUSE_CODE)
);
comment on table WH_INFO is '�ֿ������Ϣ';
comment on column WH_INFO.WAREHOUSE_CODE is '�ֿ��ţ�����+��ţ�';
comment on column WH_INFO.WAREHOUSE_NAME is '�ֿ�����';
comment on column WH_INFO.ORG_CODE is '��������';
comment on column WH_INFO.ADDRESS is '�ֿ��ַ';
comment on column WH_INFO.PHONE is '��ϵ�绰';
comment on column WH_INFO.DIRECTOR_ADMIN is '������';
comment on column WH_INFO.STATUS is '״̬��1-���ã�2-ͣ�ã�3-�̵��У�';
comment on column WH_INFO.CREATE_ADMIN is '������';
comment on column WH_INFO.CREATE_DATE is '����ʱ��';
comment on column WH_INFO.STOP_ADMIN is 'ͣ����';
comment on column WH_INFO.STOP_DATE is 'ͣ��ʱ��';

create table WH_MANAGER(
	WAREHOUSE_CODE CHAR(4)  not null,
	ORG_CODE CHAR(2)  not null,
	MANAGER_ID NUMBER(4)  not null,
	IS_VALID NUMBER(1)  not null,
	START_TIME DATE  ,
	END_TIME DATE  ,
	constraint PK_WH_MANAGER primary Key (WAREHOUSE_CODE,MANAGER_ID)
);
comment on table WH_MANAGER is '�ֿ����Ա��Ϣ';
comment on column WH_MANAGER.WAREHOUSE_CODE is '�ֿ���';
comment on column WH_MANAGER.ORG_CODE is '��������';
comment on column WH_MANAGER.MANAGER_ID is '����Ա';
comment on column WH_MANAGER.IS_VALID is '�Ƿ���Ч��1-��Ч��0-��Ч��';
comment on column WH_MANAGER.START_TIME is '��Чʱ��';
comment on column WH_MANAGER.END_TIME is 'ͣ��ʱ��';

create table WH_TICKET_TRUNK(
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	REWARD_GROUP NUMBER(2)  ,
	TRUNK_NO VARCHAR2(10)  not null,
	PACKAGE_NO_START VARCHAR2(10)  not null,
	PACKAGE_NO_END VARCHAR2(10)  not null,
	IS_FULL NUMBER(1) default 1 not null,
	STATUS NUMBER(2) default 11 not null,
	CURRENT_WAREHOUSE VARCHAR2(8)  ,
	LAST_WAREHOUSE VARCHAR2(8)  ,
	CREATE_DATE DATE default sysdate not null,
	CREATE_ADMIN NUMBER(4)  not null,
	CHANGE_ADMIN NUMBER(4)  ,
	CHANGE_DATE DATE  ,
	constraint PK_WH_TICKET_TRUNK primary Key (PLAN_CODE,BATCH_NO,TRUNK_NO)
);
comment on table WH_TICKET_TRUNK is '����Ʊ��Ϣ���䣩';
comment on column WH_TICKET_TRUNK.PLAN_CODE is '����';
comment on column WH_TICKET_TRUNK.BATCH_NO is '����';
comment on column WH_TICKET_TRUNK.REWARD_GROUP is '����';
comment on column WH_TICKET_TRUNK.TRUNK_NO is '���';
comment on column WH_TICKET_TRUNK.PACKAGE_NO_START is '����������';
comment on column WH_TICKET_TRUNK.PACKAGE_NO_END is '��������ֹ';
comment on column WH_TICKET_TRUNK.IS_FULL is '�Ƿ�����';
comment on column WH_TICKET_TRUNK.STATUS is '״̬��11-�ڿ⡢12-��վ�㣬20-��;��21-����Ա���У�31-�����ۡ�41-������42-�𻵡�43-��ʧ��';
comment on column WH_TICKET_TRUNK.CURRENT_WAREHOUSE is '���ڲֿ⣨ֻ��������������£���ֵ����Ч��';
comment on column WH_TICKET_TRUNK.LAST_WAREHOUSE is '������ڲֿ⣨ֻ��������������£���ֵ����Ч��';
comment on column WH_TICKET_TRUNK.CREATE_DATE is '����ʱ��';
comment on column WH_TICKET_TRUNK.CREATE_ADMIN is '������';
comment on column WH_TICKET_TRUNK.CHANGE_ADMIN is '����䶯��';
comment on column WH_TICKET_TRUNK.CHANGE_DATE is '����䶯ʱ��';

create table WH_TICKET_BOX(
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	REWARD_GROUP NUMBER(2)  not null,
	TRUNK_NO VARCHAR2(10)  not null,
	BOX_NO VARCHAR2(20)  not null,
	PACKAGE_NO_START VARCHAR2(10)  not null,
	PACKAGE_NO_END VARCHAR2(10)  not null,
	IS_FULL NUMBER(1) default 1 not null,
	STATUS NUMBER(2) default 11 not null,
	CURRENT_WAREHOUSE VARCHAR2(8)  ,
	LAST_WAREHOUSE VARCHAR2(8)  ,
	CREATE_DATE DATE default sysdate not null,
	CREATE_ADMIN NUMBER(4)  not null,
	CHANGE_ADMIN NUMBER(4)  ,
	CHANGE_DATE DATE  ,
	constraint PK_WH_TICKET_BOX primary Key (PLAN_CODE,BATCH_NO,TRUNK_NO,BOX_NO)
);
comment on table WH_TICKET_BOX is '����Ʊ��Ϣ���У�';
comment on column WH_TICKET_BOX.PLAN_CODE is '����';
comment on column WH_TICKET_BOX.BATCH_NO is '����';
comment on column WH_TICKET_BOX.REWARD_GROUP is '����';
comment on column WH_TICKET_BOX.TRUNK_NO is '���';
comment on column WH_TICKET_BOX.BOX_NO is '�кţ����+����˳��ţ�';
comment on column WH_TICKET_BOX.PACKAGE_NO_START is '����������';
comment on column WH_TICKET_BOX.PACKAGE_NO_END is '��������ֹ';
comment on column WH_TICKET_BOX.IS_FULL is '�Ƿ�����';
comment on column WH_TICKET_BOX.STATUS is '״̬��11-�ڿ⡢12-��վ�㣬20-��;��21-����Ա���У�31-�����ۡ�41-������42-�𻵡�43-��ʧ��';
comment on column WH_TICKET_BOX.CURRENT_WAREHOUSE is '���ڲֿ⣨ֻ��������������£���ֵ����Ч��';
comment on column WH_TICKET_BOX.LAST_WAREHOUSE is '������ڲֿ⣨ֻ��������������£���ֵ����Ч��';
comment on column WH_TICKET_BOX.CREATE_DATE is '����ʱ��';
comment on column WH_TICKET_BOX.CREATE_ADMIN is '������';
comment on column WH_TICKET_BOX.CHANGE_ADMIN is '����䶯��';
comment on column WH_TICKET_BOX.CHANGE_DATE is '����䶯ʱ��';

create table WH_TICKET_PACKAGE(
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	REWARD_GROUP NUMBER(2)  not null,
	TRUNK_NO VARCHAR2(10)  not null,
	BOX_NO VARCHAR2(20)  not null,
	PACKAGE_NO VARCHAR2(10)  not null,
	TICKET_NO_START VARCHAR2(10)  not null,
	TICKET_NO_END VARCHAR2(10)  not null,
	IS_FULL NUMBER(1) default 1 not null,
	STATUS NUMBER(2) default 11 not null,
	CURRENT_WAREHOUSE VARCHAR2(8)  ,
	LAST_WAREHOUSE VARCHAR2(8)  ,
	CREATE_DATE DATE default sysdate not null,
	CREATE_ADMIN NUMBER(4)  not null,
	CHANGE_ADMIN NUMBER(4)  ,
	CHANGE_DATE DATE  ,
	constraint PK_WH_TICKET_PACKAGE primary Key (PLAN_CODE,BATCH_NO,TRUNK_NO,BOX_NO,PACKAGE_NO)
);
comment on table WH_TICKET_PACKAGE is '����Ʊ��Ϣ������';
comment on column WH_TICKET_PACKAGE.PLAN_CODE is '����';
comment on column WH_TICKET_PACKAGE.BATCH_NO is '����';
comment on column WH_TICKET_PACKAGE.REWARD_GROUP is '����';
comment on column WH_TICKET_PACKAGE.TRUNK_NO is '���';
comment on column WH_TICKET_PACKAGE.BOX_NO is '�кţ����+����˳��ţ�';
comment on column WH_TICKET_PACKAGE.PACKAGE_NO is '����';
comment on column WH_TICKET_PACKAGE.TICKET_NO_START is '����Ʊ����';
comment on column WH_TICKET_PACKAGE.TICKET_NO_END is '����Ʊ��ֹ';
comment on column WH_TICKET_PACKAGE.IS_FULL is '�Ƿ�����';
comment on column WH_TICKET_PACKAGE.STATUS is '״̬��11-�ڿ⡢12-��վ�㣬20-��;��21-����Ա���У�31-�����ۡ�41-������42-�𻵡�43-��ʧ��';
comment on column WH_TICKET_PACKAGE.CURRENT_WAREHOUSE is '���ڲֿ⣨ֻ��������������£���ֵ����Ч��';
comment on column WH_TICKET_PACKAGE.LAST_WAREHOUSE is '������ڲֿ⣨ֻ��������������£���ֵ����Ч��';
comment on column WH_TICKET_PACKAGE.CREATE_DATE is '����ʱ��';
comment on column WH_TICKET_PACKAGE.CREATE_ADMIN is '������';
comment on column WH_TICKET_PACKAGE.CHANGE_ADMIN is '����䶯��';
comment on column WH_TICKET_PACKAGE.CHANGE_DATE is '����䶯ʱ��';

create table WH_BATCH_INBOUND(
	BI_NO CHAR(10)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	BATCH_TICKETS NUMBER(18)  not null,
	BATCH_AMOUNT NUMBER(28)  not null,
	ACT_TICKETS NUMBER(18) default 0 not null,
	ACT_AMOUNT NUMBER(28) default 0 not null,
	DISCREPANCY_TICKETS NUMBER(18) default 0 not null,
	DISCREPANCY_AMOUNT NUMBER(28) default 0 not null,
	DAMAGED_TICKETS NUMBER(18) default 0 not null,
	DAMAGED_AMOUNT NUMBER(28) default 0 not null,
	TRUNKS NUMBER(18) default 0 not null,
	BOXES NUMBER(18) default 0 not null,
	PACKAGES NUMBER(18) default 0 not null,
	CREATE_ADMIN NUMBER(4)  not null,
	CREATE_DATE DATE default sysdate not null,
	OPER_ADMIN NUMBER(4)  ,
	OPER_DATE DATE  ,
	constraint PK_WH_INBOUND primary Key (PLAN_CODE,BATCH_NO)
);
comment on table WH_BATCH_INBOUND is '�������';
comment on column WH_BATCH_INBOUND.BI_NO is '��ⵥ���(BI12345678)';
comment on column WH_BATCH_INBOUND.PLAN_CODE is '��������';
comment on column WH_BATCH_INBOUND.BATCH_NO is '����';
comment on column WH_BATCH_INBOUND.BATCH_TICKETS is '����Ӧ���Ʊ��';
comment on column WH_BATCH_INBOUND.BATCH_AMOUNT is '����Ӧ�����';
comment on column WH_BATCH_INBOUND.ACT_TICKETS is 'ʵ�����Ʊ��';
comment on column WH_BATCH_INBOUND.ACT_AMOUNT is 'ʵ�ʿ���';
comment on column WH_BATCH_INBOUND.DISCREPANCY_TICKETS is '��������';
comment on column WH_BATCH_INBOUND.DISCREPANCY_AMOUNT is '������';
comment on column WH_BATCH_INBOUND.DAMAGED_TICKETS is '�������';
comment on column WH_BATCH_INBOUND.DAMAGED_AMOUNT is '��ٽ��';
comment on column WH_BATCH_INBOUND.TRUNKS is '�������';
comment on column WH_BATCH_INBOUND.BOXES is '������';
comment on column WH_BATCH_INBOUND.PACKAGES is '��Ȿ��';
comment on column WH_BATCH_INBOUND.CREATE_ADMIN is '������';
comment on column WH_BATCH_INBOUND.CREATE_DATE is '����ʱ��';
comment on column WH_BATCH_INBOUND.OPER_ADMIN is '���ղ�����';
comment on column WH_BATCH_INBOUND.OPER_DATE is '���ղ���ʱ��';
create index IDX_WH_INBOUND_NO on WH_BATCH_INBOUND(BI_NO);

create table WH_GOODS_ISSUE(
	SGI_NO CHAR(10)  not null,
	CREATE_ADMIN NUMBER(4)  not null,
	CREATE_DATE DATE default sysdate not null,
	ISSUE_END_TIME DATE  ,
	ISSUE_AMOUNT NUMBER(28) default 0 not null,
	ISSUE_TICKETS NUMBER(18) default 0 not null,
	ACT_ISSUE_AMOUNT NUMBER(28) default 0 not null,
	ACT_ISSUE_TICKETS NUMBER(18) default 0 not null,
	ISSUE_TYPE NUMBER(1)  not null,
	REF_NO CHAR(10)  not null,
	STATUS NUMBER(1) default 1 not null,
	CARRIER VARCHAR2(500)  ,
	CARRY_DATE DATE  ,
	CARRIER_CONTACT VARCHAR2(500)  ,
	SEND_ORG CHAR(2)  ,
	SEND_WH VARCHAR2(8)  ,
	RECEIVE_ADMIN NUMBER(4)  ,
	REMARK VARCHAR2(4000)  ,
	constraint PK_WH_GOODS_ISSUE primary Key (SGI_NO)
);
comment on table WH_GOODS_ISSUE is '�������������Ķ���';
comment on column WH_GOODS_ISSUE.SGI_NO is '���ⵥ��ţ�CK12345678��';
comment on column WH_GOODS_ISSUE.CREATE_ADMIN is '������';
comment on column WH_GOODS_ISSUE.CREATE_DATE is '����ʱ��';
comment on column WH_GOODS_ISSUE.ISSUE_END_TIME is '��������ʱ��';
comment on column WH_GOODS_ISSUE.ISSUE_AMOUNT is '������ϼ�';
comment on column WH_GOODS_ISSUE.ISSUE_TICKETS is '���������ϼ�';
comment on column WH_GOODS_ISSUE.ACT_ISSUE_AMOUNT is 'ʵ�ʳ�����ϼ�';
comment on column WH_GOODS_ISSUE.ACT_ISSUE_TICKETS is 'ʵ�ʳ��������ϼ�';
comment on column WH_GOODS_ISSUE.ISSUE_TYPE is '�������ͣ�1-�������⡢2-���������⣬3-��ٳ��⣬4-վ���˻���';
comment on column WH_GOODS_ISSUE.REF_NO is '�ο����';
comment on column WH_GOODS_ISSUE.STATUS is '״̬��1-δ��ɣ�2-����ɣ�';
comment on column WH_GOODS_ISSUE.CARRIER is '�����';
comment on column WH_GOODS_ISSUE.CARRY_DATE is '���ʱ��';
comment on column WH_GOODS_ISSUE.CARRIER_CONTACT is '�������ϵ��ʽ';
comment on column WH_GOODS_ISSUE.SEND_ORG is '����ֿ�������λ';
comment on column WH_GOODS_ISSUE.SEND_WH is '����ֿ�';
comment on column WH_GOODS_ISSUE.RECEIVE_ADMIN is '������';
comment on column WH_GOODS_ISSUE.REMARK is '��ע';

create table WH_GOODS_ISSUE_DETAIL(
	SGI_NO CHAR(10)  not null,
	SEQUENCE_NO NUMBER(24)  not null,
	ISSUE_TYPE NUMBER(1)  ,
	REF_NO CHAR(10)  ,
	VALID_NUMBER NUMBER(1)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNK_NO VARCHAR2(10)  not null,
	BOX_NO VARCHAR2(20)  not null,
	PACKAGE_NO VARCHAR2(10)  not null,
	TICKETS NUMBER(18)  not null,
	AMOUNT NUMBER(28)  not null,
	constraint PK_WH_GOODS_ISSUE_DETAIL primary Key (SEQUENCE_NO)
);
comment on table WH_GOODS_ISSUE_DETAIL is '���ⵥ��ϸ';
comment on column WH_GOODS_ISSUE_DETAIL.SGI_NO is '���ⵥ��ţ�CK12345678��';
comment on column WH_GOODS_ISSUE_DETAIL.SEQUENCE_NO is '˳���';
comment on column WH_GOODS_ISSUE_DETAIL.ISSUE_TYPE is '�������ͣ�1-�������⡢2-���������⣬3-��ٳ��⣬4-վ���˻���';
comment on column WH_GOODS_ISSUE_DETAIL.REF_NO is '�����ο����';
comment on column WH_GOODS_ISSUE_DETAIL.VALID_NUMBER is '��Чλ����1-��š�2-�кš�3-���ţ�';
comment on column WH_GOODS_ISSUE_DETAIL.PLAN_CODE is '��������';
comment on column WH_GOODS_ISSUE_DETAIL.BATCH_NO is '����';
comment on column WH_GOODS_ISSUE_DETAIL.TRUNK_NO is '���';
comment on column WH_GOODS_ISSUE_DETAIL.BOX_NO is '�кţ����+����˳��ţ�';
comment on column WH_GOODS_ISSUE_DETAIL.PACKAGE_NO is '����';
comment on column WH_GOODS_ISSUE_DETAIL.TICKETS is 'Ʊ��';
comment on column WH_GOODS_ISSUE_DETAIL.AMOUNT is '���';
create index IDX_WH_GI_DETAIL_SGI on WH_GOODS_ISSUE_DETAIL(SGI_NO);
create index IDX_WH_GI_DETAIL_ALL on WH_GOODS_ISSUE_DETAIL(PLAN_CODE,BATCH_NO,TRUNK_NO,BOX_NO,PACKAGE_NO);
create index IDX_WH_GI_DETAIL_REF on WH_GOODS_ISSUE_DETAIL(REF_NO);

create table WH_GOODS_RECEIPT(
	SGR_NO CHAR(10)  not null,
	CREATE_ADMIN NUMBER(4)  not null,
	CREATE_DATE DATE default sysdate not null,
	RECEIPT_END_TIME DATE  ,
	RECEIPT_AMOUNT NUMBER(28) default 0 not null,
	RECEIPT_TICKETS NUMBER(18) default 0 not null,
	ACT_RECEIPT_AMOUNT NUMBER(28) default 0 not null,
	ACT_RECEIPT_TICKETS NUMBER(18) default 0 not null,
	RECEIPT_TYPE NUMBER(1)  not null,
	REF_NO CHAR(10)  not null,
	STATUS NUMBER(1) default 1 not null,
	CARRIER VARCHAR2(500)  ,
	CARRY_DATE DATE  ,
	CARRIER_CONTACT VARCHAR2(500)  ,
	RECEIVE_ORG CHAR(2)  ,
	RECEIVE_WH VARCHAR2(8)  not null,
	SEND_ADMIN NUMBER(4)  ,
	REMARK VARCHAR2(4000)  ,
	constraint PK_WH_GOODS_RECEIPT primary Key (SGR_NO)
);
comment on table WH_GOODS_RECEIPT is '��ⵥ';
comment on column WH_GOODS_RECEIPT.SGR_NO is '��ⵥ��ţ�RK12345678��';
comment on column WH_GOODS_RECEIPT.CREATE_ADMIN is '������';
comment on column WH_GOODS_RECEIPT.CREATE_DATE is '����ʱ��';
comment on column WH_GOODS_RECEIPT.RECEIPT_END_TIME is '�������ʱ��';
comment on column WH_GOODS_RECEIPT.RECEIPT_AMOUNT is '�����ϼ�';
comment on column WH_GOODS_RECEIPT.RECEIPT_TICKETS is '��������ϼ�';
comment on column WH_GOODS_RECEIPT.ACT_RECEIPT_AMOUNT is 'ʵ�������ϼ�';
comment on column WH_GOODS_RECEIPT.ACT_RECEIPT_TICKETS is 'ʵ����������ϼ�';
comment on column WH_GOODS_RECEIPT.RECEIPT_TYPE is '������ͣ�1-������⡢2-��������⡢3-������⡢4-վ����⣩';
comment on column WH_GOODS_RECEIPT.REF_NO is '�ο����';
comment on column WH_GOODS_RECEIPT.STATUS is '״̬��1-δ��ɣ�2-����ɣ�';
comment on column WH_GOODS_RECEIPT.CARRIER is '�ͻ���';
comment on column WH_GOODS_RECEIPT.CARRY_DATE is '�ͻ�ʱ��';
comment on column WH_GOODS_RECEIPT.CARRIER_CONTACT is '�ͻ�����ϵ��ʽ';
comment on column WH_GOODS_RECEIPT.RECEIVE_ORG is '���ֿ�������λ';
comment on column WH_GOODS_RECEIPT.RECEIVE_WH is '���ֿ�';
comment on column WH_GOODS_RECEIPT.SEND_ADMIN is '������Ա';
comment on column WH_GOODS_RECEIPT.REMARK is '��ע';

create table WH_GOODS_RECEIPT_DETAIL(
	SGR_NO CHAR(10)  not null,
	SEQUENCE_NO NUMBER(24)  not null,
	RECEIPT_TYPE NUMBER(1)  ,
	REF_NO CHAR(10)  ,
	VALID_NUMBER NUMBER(1)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNK_NO VARCHAR2(10)  ,
	BOX_NO VARCHAR2(20)  ,
	PACKAGE_NO VARCHAR2(10)  ,
	TICKETS NUMBER(18)  not null,
	AMOUNT NUMBER(28)  not null,
	CREATE_ADMIN NUMBER(4)  ,
	CREATE_DATE DATE  ,
	constraint PK_WH_GOODS_RECEIPT_DETAIL primary Key (SEQUENCE_NO)
);
comment on table WH_GOODS_RECEIPT_DETAIL is '��ⵥ��ϸ';
comment on column WH_GOODS_RECEIPT_DETAIL.SGR_NO is '��ⵥ���';
comment on column WH_GOODS_RECEIPT_DETAIL.SEQUENCE_NO is '˳���';
comment on column WH_GOODS_RECEIPT_DETAIL.RECEIPT_TYPE is '������ͣ�1-������⡢2-��������⡢3-�˻���⡢4-վ����⣩';
comment on column WH_GOODS_RECEIPT_DETAIL.REF_NO is '�ο����';
comment on column WH_GOODS_RECEIPT_DETAIL.VALID_NUMBER is '��Чλ����1-��š�2-�кš�3-���ţ�';
comment on column WH_GOODS_RECEIPT_DETAIL.PLAN_CODE is '��������';
comment on column WH_GOODS_RECEIPT_DETAIL.BATCH_NO is '����';
comment on column WH_GOODS_RECEIPT_DETAIL.TRUNK_NO is '���';
comment on column WH_GOODS_RECEIPT_DETAIL.BOX_NO is '�кţ����+����˳��ţ�';
comment on column WH_GOODS_RECEIPT_DETAIL.PACKAGE_NO is '����';
comment on column WH_GOODS_RECEIPT_DETAIL.TICKETS is 'Ʊ��';
comment on column WH_GOODS_RECEIPT_DETAIL.AMOUNT is '���';
comment on column WH_GOODS_RECEIPT_DETAIL.CREATE_ADMIN is '������';
comment on column WH_GOODS_RECEIPT_DETAIL.CREATE_DATE is '����ʱ��';
create index IDX_WH_GR_DETAIL_SGR on WH_GOODS_RECEIPT_DETAIL(SGR_NO);
create index IDX_WH_GR_DETAIL_ALL on WH_GOODS_RECEIPT_DETAIL(PLAN_CODE,BATCH_NO,TRUNK_NO,BOX_NO,PACKAGE_NO);
create index IDX_WH_GR_DETAIL_REF on WH_GOODS_RECEIPT_DETAIL(REF_NO);

create table WH_CHECK_POINT(
	CP_NO CHAR(10)  not null,
	WAREHOUSE_CODE CHAR(4)  not null,
	CP_NAME VARCHAR2(4000)  not null,
	PLAN_CODE VARCHAR2(10)  ,
	BATCH_NO VARCHAR2(10)  ,
	STATUS NUMBER(1)  not null,
	RESULT NUMBER(1)  not null,
	NOMATCH_TICKETS NUMBER(18)  ,
	NOMATCH_AMOUNT NUMBER(28)  ,
	CP_ADMIN NUMBER(4)  not null,
	CP_DATE DATE  not null,
	REMARK VARCHAR2(4000)  ,
	constraint PK_WH_CHECK_POINT primary Key (CP_NO)
);
comment on table WH_CHECK_POINT is '�̵㵥';
comment on column WH_CHECK_POINT.CP_NO is '�̵㵥��ţ�PD12345678��';
comment on column WH_CHECK_POINT.WAREHOUSE_CODE is '�ֿ�����';
comment on column WH_CHECK_POINT.CP_NAME is '�̵�����';
comment on column WH_CHECK_POINT.PLAN_CODE is '��������';
comment on column WH_CHECK_POINT.BATCH_NO is '����';
comment on column WH_CHECK_POINT.STATUS is '�̵�״̬��1-�̵��У�2-�̵������';
comment on column WH_CHECK_POINT.RESULT is '�̵�����1-һ�£�2-�̿���3-��ӯ��';
comment on column WH_CHECK_POINT.NOMATCH_TICKETS is '���Ʊ��';
comment on column WH_CHECK_POINT.NOMATCH_AMOUNT is '�����';
comment on column WH_CHECK_POINT.CP_ADMIN is '�̵���';
comment on column WH_CHECK_POINT.CP_DATE is '�̵�����';
comment on column WH_CHECK_POINT.REMARK is '��ע';

create table WH_CHECK_POINT_DETAIL_BE(
	CP_NO CHAR(10)  not null,
	SEQUENCE_NO NUMBER(24)  not null,
	VALID_NUMBER NUMBER(1)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNK_NO VARCHAR2(10)  not null,
	BOX_NO VARCHAR2(20)  ,
	PACKAGE_NO VARCHAR2(10)  ,
	PACKAGES NUMBER(4)  not null,
	AMOUNT NUMBER(18)  not null,
	constraint PK_WH_CHECK_POINT_DETAIL_BE primary Key (SEQUENCE_NO)
);
comment on table WH_CHECK_POINT_DETAIL_BE is '�̵�ǰ�����ϸ';
comment on column WH_CHECK_POINT_DETAIL_BE.CP_NO is '�̵㵥��ţ�PD12345678��';
comment on column WH_CHECK_POINT_DETAIL_BE.SEQUENCE_NO is '˳���';
comment on column WH_CHECK_POINT_DETAIL_BE.VALID_NUMBER is '��Чλ����1-��š�2-�кš�3-���ţ�';
comment on column WH_CHECK_POINT_DETAIL_BE.PLAN_CODE is '��������';
comment on column WH_CHECK_POINT_DETAIL_BE.BATCH_NO is '����';
comment on column WH_CHECK_POINT_DETAIL_BE.TRUNK_NO is '���';
comment on column WH_CHECK_POINT_DETAIL_BE.BOX_NO is '�кţ����+����˳��ţ�';
comment on column WH_CHECK_POINT_DETAIL_BE.PACKAGE_NO is '����';
comment on column WH_CHECK_POINT_DETAIL_BE.PACKAGES is '����';
comment on column WH_CHECK_POINT_DETAIL_BE.AMOUNT is '���';
create index IDX_WH_CP_DETAIL_BE_CP on WH_CHECK_POINT_DETAIL_BE(CP_NO);

create table WH_CHECK_POINT_DETAIL(
	CP_NO CHAR(10)  not null,
	SEQUENCE_NO NUMBER(24)  not null,
	VALID_NUMBER NUMBER(1)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNK_NO VARCHAR2(10)  not null,
	BOX_NO VARCHAR2(20)  ,
	PACKAGE_NO VARCHAR2(10)  ,
	PACKAGES NUMBER(4)  not null,
	AMOUNT NUMBER(18)  not null,
	constraint PK_WH_CHECK_POINT_DETAIL primary Key (SEQUENCE_NO)
);
comment on table WH_CHECK_POINT_DETAIL is '�̵�����ϸ';
comment on column WH_CHECK_POINT_DETAIL.CP_NO is '�̵㵥��ţ�PD12345678��';
comment on column WH_CHECK_POINT_DETAIL.SEQUENCE_NO is '˳���';
comment on column WH_CHECK_POINT_DETAIL.VALID_NUMBER is '��Чλ����1-��š�2-�кš�3-���ţ�';
comment on column WH_CHECK_POINT_DETAIL.PLAN_CODE is '��������';
comment on column WH_CHECK_POINT_DETAIL.BATCH_NO is '����';
comment on column WH_CHECK_POINT_DETAIL.TRUNK_NO is '���';
comment on column WH_CHECK_POINT_DETAIL.BOX_NO is '�кţ����+����˳��ţ�';
comment on column WH_CHECK_POINT_DETAIL.PACKAGE_NO is '����';
comment on column WH_CHECK_POINT_DETAIL.PACKAGES is '����';
comment on column WH_CHECK_POINT_DETAIL.AMOUNT is '���';
create index IDX_WH_CP_DETAIL_CP on WH_CHECK_POINT_DETAIL(CP_NO);

create table WH_CP_NOMATCH_DETAIL(
	CP_NO CHAR(10)  not null,
	SEQUENCE_NO NUMBER(24)  not null,
	VALID_NUMBER NUMBER(1)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNK_NO VARCHAR2(10)  not null,
	BOX_NO VARCHAR2(20)  ,
	PACKAGE_NO VARCHAR2(10)  ,
	PACKAGES NUMBER(4)  not null,
	AMOUNT NUMBER(18)  not null,
	constraint PK_WH_CP_NOMATCH_DETAIL primary Key (SEQUENCE_NO)
);
comment on table WH_CP_NOMATCH_DETAIL is '�̵�����ϸ';
comment on column WH_CP_NOMATCH_DETAIL.CP_NO is '�̵㵥��ţ�PD12345678��';
comment on column WH_CP_NOMATCH_DETAIL.SEQUENCE_NO is '˳���';
comment on column WH_CP_NOMATCH_DETAIL.VALID_NUMBER is '��Чλ����1-��š�2-�кš�3-���ţ�';
comment on column WH_CP_NOMATCH_DETAIL.PLAN_CODE is '��������';
comment on column WH_CP_NOMATCH_DETAIL.BATCH_NO is '����';
comment on column WH_CP_NOMATCH_DETAIL.TRUNK_NO is '���';
comment on column WH_CP_NOMATCH_DETAIL.BOX_NO is '�кţ����+����˳��ţ�';
comment on column WH_CP_NOMATCH_DETAIL.PACKAGE_NO is '����';
comment on column WH_CP_NOMATCH_DETAIL.PACKAGES is '����';
comment on column WH_CP_NOMATCH_DETAIL.AMOUNT is '���';
create index IDX_WH_CPN_DETAIL_CP on WH_CP_NOMATCH_DETAIL(CP_NO);

create table WH_BROKEN_RECODER(
	BROKEN_NO CHAR(10)  not null,
	APPLY_ADMIN NUMBER(4)  ,
	APPLY_DATE DATE  not null,
	SOURCE NUMBER(1)  not null,
	STB_NO CHAR(10)  ,
	CP_NO CHAR(10)  ,
	PACKAGES NUMBER(18)  ,
	TOTAL_AMOUNT NUMBER(28)  ,
	REASON NUMBER(2)  ,
	REMARK VARCHAR2(4000)  ,
	constraint PK_WH_BROKEN_RECODER primary Key (BROKEN_NO)
);
comment on table WH_BROKEN_RECODER is '��ٵ�';
comment on column WH_BROKEN_RECODER.BROKEN_NO is '��ٵ���ţ�SH12345678��';
comment on column WH_BROKEN_RECODER.APPLY_ADMIN is '���';
comment on column WH_BROKEN_RECODER.APPLY_DATE is '�����';
comment on column WH_BROKEN_RECODER.SOURCE is '������Դ��1-�˹�¼�룬2-���������ɣ�3-�̵����ɣ�';
comment on column WH_BROKEN_RECODER.STB_NO is '���������';
comment on column WH_BROKEN_RECODER.CP_NO is '�̵㵥���';
comment on column WH_BROKEN_RECODER.PACKAGES is '�漰����';
comment on column WH_BROKEN_RECODER.TOTAL_AMOUNT is '�漰���';
comment on column WH_BROKEN_RECODER.REASON is '���ԭ��41-������42-�𻵡�43-��ʧ��';
comment on column WH_BROKEN_RECODER.REMARK is '��ע';

create table WH_BROKEN_RECODER_DETAIL(
	BROKEN_NO CHAR(10)  not null,
	SEQUENCE_NO NUMBER(24)  not null,
	VALID_NUMBER NUMBER(1)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNK_NO VARCHAR2(10)  not null,
	BOX_NO VARCHAR2(20)  ,
	PACKAGE_NO VARCHAR2(10)  ,
	PACKAGES NUMBER(18)  not null,
	AMOUNT NUMBER(28)  not null,
	constraint PK_WH_BROKEN_RECODER_DETAIL primary Key (SEQUENCE_NO)
);
comment on table WH_BROKEN_RECODER_DETAIL is '��ٵ���ϸ';
comment on column WH_BROKEN_RECODER_DETAIL.BROKEN_NO is '��ٵ���ţ�SH12345678��';
comment on column WH_BROKEN_RECODER_DETAIL.SEQUENCE_NO is '˳���';
comment on column WH_BROKEN_RECODER_DETAIL.VALID_NUMBER is '��Чλ����1-��š�2-�кš�3-���ţ�';
comment on column WH_BROKEN_RECODER_DETAIL.PLAN_CODE is '��������';
comment on column WH_BROKEN_RECODER_DETAIL.BATCH_NO is '����';
comment on column WH_BROKEN_RECODER_DETAIL.TRUNK_NO is '���';
comment on column WH_BROKEN_RECODER_DETAIL.BOX_NO is '�кţ����+����˳��ţ�';
comment on column WH_BROKEN_RECODER_DETAIL.PACKAGE_NO is '����';
comment on column WH_BROKEN_RECODER_DETAIL.PACKAGES is '����';
comment on column WH_BROKEN_RECODER_DETAIL.AMOUNT is '���';
create index IDX_WH_BR_DETAIL_BR on WH_BROKEN_RECODER_DETAIL(BROKEN_NO);

create table WH_BATCH_END(
	BE_NO CHAR(10)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TICKETS NUMBER(28)  not null,
	SALE_AMOUNT NUMBER(28)  not null,
	PAY_AMOUNT NUMBER(28)  not null,
	INVENTORY_TICKETS NUMBER(28)  not null,
	CREATE_ADMIN NUMBER(4)  not null,
	CREATE_DATE DATE  not null,
	constraint PK_WH_BATCH_END primary Key (BE_NO)
);
comment on table WH_BATCH_END is '�����ս�';
comment on column WH_BATCH_END.BE_NO is '�����ս��ţ�ZJ12345678��';
comment on column WH_BATCH_END.PLAN_CODE is '��������';
comment on column WH_BATCH_END.BATCH_NO is '����';
comment on column WH_BATCH_END.TICKETS is '�����������ţ�';
comment on column WH_BATCH_END.SALE_AMOUNT is '�����������ţ�';
comment on column WH_BATCH_END.PAY_AMOUNT is '�ҽ��������';
comment on column WH_BATCH_END.INVENTORY_TICKETS is '����������ţ�';
comment on column WH_BATCH_END.CREATE_ADMIN is '���';
comment on column WH_BATCH_END.CREATE_DATE is '�����';
create index UDX_WH_BATCH_END on WH_BATCH_END(PLAN_CODE,BATCH_NO);

create table SALE_ORDER(
	ORDER_NO CHAR(10)  not null,
	APPLY_ADMIN NUMBER(4)  ,
	APPLY_DATE DATE  not null,
	APPLY_AGENCY CHAR(8)  not null,
	SENDER_ADMIN NUMBER(4)  ,
	SEND_WAREHOUSE CHAR(4)  ,
	SEND_DATE DATE  ,
	CARRIER_ADMIN NUMBER(4)  ,
	CARRY_DATE DATE  ,
	APPLY_CONTACT VARCHAR2(50)  ,
	STATUS NUMBER(1) default 1 not null,
	IS_INSTANT_ORDER NUMBER(1) default 0 not null,
	APPLY_TICKETS NUMBER(16) default 0 not null,
	APPLY_AMOUNT NUMBER(28) default 0 not null,
	GOODS_TICKETS NUMBER(16) default 0 ,
	GOODS_AMOUNT NUMBER(28) default 0 ,
	REMARK VARCHAR2(4000)  ,
	constraint PK_SALE_ORDER primary Key (ORDER_NO)
);
comment on table SALE_ORDER is '����';
comment on column SALE_ORDER.ORDER_NO is '������ţ�DD 12345678��';
comment on column SALE_ORDER.APPLY_ADMIN is '�����ˣ�վ���������ն˻����룬����Ϊ�գ�';
comment on column SALE_ORDER.APPLY_DATE is '����ʱ��';
comment on column SALE_ORDER.APPLY_AGENCY is '����վ��';
comment on column SALE_ORDER.SENDER_ADMIN is '������';
comment on column SALE_ORDER.SEND_WAREHOUSE is '�����ֿ�';
comment on column SALE_ORDER.SEND_DATE is '����ʱ��';
comment on column SALE_ORDER.CARRIER_ADMIN is '������';
comment on column SALE_ORDER.CARRY_DATE is '����ʱ��';
comment on column SALE_ORDER.APPLY_CONTACT is 'վ����ϵ��ʽ';
comment on column SALE_ORDER.STATUS is '״̬��1-���ύ��2-�ѳ�����3-������4-�ѷ�����5-���ջ���6-��������7-�Ѿܾ���';
comment on column SALE_ORDER.IS_INSTANT_ORDER is '�Ƿ�ʱ��������ʱ���������ɡ�����������ϸ����ֱ�����ɡ������ջ���ϸ����';
comment on column SALE_ORDER.APPLY_TICKETS is '������Ʊ��';
comment on column SALE_ORDER.APPLY_AMOUNT is '�����ܽ��';
comment on column SALE_ORDER.GOODS_TICKETS is '�ջ���Ʊ��';
comment on column SALE_ORDER.GOODS_AMOUNT is '�ջ��ܽ��';
comment on column SALE_ORDER.REMARK is '��ע';

create table SALE_ORDER_APPLY_DETAIL(
	ORDER_NO CHAR(10)  not null,
	SEQUENCE_NO NUMBER(24)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	TICKETS NUMBER(18) default 0 not null,
	PACKAGES NUMBER(18) default 0 not null,
	AMOUNT NUMBER(28) default 0 not null,
	REMARK VARCHAR2(4000)  ,
	constraint PK_SALE_ORDER_APPLY_DETAIL primary Key (SEQUENCE_NO)
);
comment on table SALE_ORDER_APPLY_DETAIL is '����������ϸ';
comment on column SALE_ORDER_APPLY_DETAIL.ORDER_NO is '������ţ�DD 12345678��';
comment on column SALE_ORDER_APPLY_DETAIL.SEQUENCE_NO is '˳���';
comment on column SALE_ORDER_APPLY_DETAIL.PLAN_CODE is '��������';
comment on column SALE_ORDER_APPLY_DETAIL.TICKETS is 'Ʊ��';
comment on column SALE_ORDER_APPLY_DETAIL.PACKAGES is '����';
comment on column SALE_ORDER_APPLY_DETAIL.AMOUNT is '���';
comment on column SALE_ORDER_APPLY_DETAIL.REMARK is '��ע';

create table SALE_DELIVERY_ORDER(
	DO_NO CHAR(10)  not null,
	APPLY_ADMIN NUMBER(4)  not null,
	APPLY_DATE DATE  not null,
	WH_CODE CHAR(4)  ,
	WH_ORG CHAR(2)  ,
	WH_ADMIN NUMBER(4)  ,
	OUT_DATE DATE  ,
	STATUS NUMBER(1) default 1 not null,
	TICKETS NUMBER(18) default 0 not null,
	AMOUNT NUMBER(28) default 0 not null,
	ACT_TICKETS NUMBER(18) default 0 ,
	ACT_AMOUNT NUMBER(28) default 0 ,
	REMARK VARCHAR2(4000)  ,
	constraint PK_SALE_DELIVERY_ORDER primary Key (DO_NO)
);
comment on table SALE_DELIVERY_ORDER is ' ������';
comment on column SALE_DELIVERY_ORDER.DO_NO is '��������ţ�CH12345678��';
comment on column SALE_DELIVERY_ORDER.APPLY_ADMIN is '������';
comment on column SALE_DELIVERY_ORDER.APPLY_DATE is '��������';
comment on column SALE_DELIVERY_ORDER.WH_CODE is '�����ֿ�';
comment on column SALE_DELIVERY_ORDER.WH_ORG is '�ֿ���������';
comment on column SALE_DELIVERY_ORDER.WH_ADMIN is '�ֿ����Ա';
comment on column SALE_DELIVERY_ORDER.OUT_DATE is '��������';
comment on column SALE_DELIVERY_ORDER.STATUS is '״̬��1-���ύ��2-�ѳ�����3-������4-�ѷ�����5-�ջ��У�6-���ջ���7-��������8-�Ѿܾ���';
comment on column SALE_DELIVERY_ORDER.TICKETS is 'Ӧ����Ʊ��';
comment on column SALE_DELIVERY_ORDER.AMOUNT is 'Ӧ�������';
comment on column SALE_DELIVERY_ORDER.ACT_TICKETS is 'ʵ�ʳ���Ʊ��';
comment on column SALE_DELIVERY_ORDER.ACT_AMOUNT is 'ʵ�ʳ������';
comment on column SALE_DELIVERY_ORDER.REMARK is '��ע';

create table SALE_DELIVERY_ORDER_DETAIL(
	DO_NO CHAR(10)  not null,
	SEQUENCE_NO NUMBER(24)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	TICKETS NUMBER(18) default 0 not null,
	PACKAGES NUMBER(18) default 0 not null,
	AMOUNT NUMBER(28) default 0 not null,
	constraint PK_SALE_DELIVERY_ORDER_DETAIL primary Key (SEQUENCE_NO)
);
comment on table SALE_DELIVERY_ORDER_DETAIL is '������������ϸ';
comment on column SALE_DELIVERY_ORDER_DETAIL.DO_NO is '��������ţ�CH12345678��';
comment on column SALE_DELIVERY_ORDER_DETAIL.SEQUENCE_NO is '˳���';
comment on column SALE_DELIVERY_ORDER_DETAIL.PLAN_CODE is '��������';
comment on column SALE_DELIVERY_ORDER_DETAIL.TICKETS is 'Ʊ��';
comment on column SALE_DELIVERY_ORDER_DETAIL.PACKAGES is '����';
comment on column SALE_DELIVERY_ORDER_DETAIL.AMOUNT is '���';

create table SALE_DELIVERY_ORDER_ALL(
	DO_NO CHAR(10)  not null,
	ORDER_NO CHAR(10)  not null,
	constraint PK_SALE_DELIVERY_ORDER_ALL primary Key (DO_NO,ORDER_NO)
);
comment on table SALE_DELIVERY_ORDER_ALL is '�������������Ķ���';
comment on column SALE_DELIVERY_ORDER_ALL.DO_NO is '��������ţ�CH12345678��';
comment on column SALE_DELIVERY_ORDER_ALL.ORDER_NO is '������ţ�DD12345678��';

create table SALE_TRANSFER_BILL(
	STB_NO CHAR(10)  not null,
	APPLY_ADMIN NUMBER(4)  not null,
	APPLY_DATE DATE  not null,
	APPROVE_ADMIN NUMBER(4)  ,
	APPROVE_DATE DATE  ,
	SEND_ORG CHAR(2)  ,
	SEND_WH CHAR(4)  ,
	SEND_MANAGER NUMBER(4)  ,
	SEND_DATE DATE  ,
	RECEIVE_ORG CHAR(2)  ,
	RECEIVE_WH CHAR(4)  ,
	RECEIVE_MANAGER NUMBER(4)  ,
	RECEIVE_DATE DATE  ,
	TICKETS NUMBER(18) default 0 ,
	AMOUNT NUMBER(28) default 0 ,
	ACT_TICKETS NUMBER(18) default 0 ,
	ACT_AMOUNT NUMBER(28) default 0 ,
	STATUS NUMBER(1) default 1 not null,
	IS_MATCH NUMBER(1) default 0 not null,
	REMARK VARCHAR2(4000)  ,
	constraint PK_SALE_TRANSFER_BILL primary Key (STB_NO)
);
comment on table SALE_TRANSFER_BILL is '������';
comment on column SALE_TRANSFER_BILL.STB_NO is '��������ţ�DB12345678��';
comment on column SALE_TRANSFER_BILL.APPLY_ADMIN is '�ύ��';
comment on column SALE_TRANSFER_BILL.APPLY_DATE is '��������';
comment on column SALE_TRANSFER_BILL.APPROVE_ADMIN is '������';
comment on column SALE_TRANSFER_BILL.APPROVE_DATE is '��������';
comment on column SALE_TRANSFER_BILL.SEND_ORG is '������λ';
comment on column SALE_TRANSFER_BILL.SEND_WH is '�����ֿ�';
comment on column SALE_TRANSFER_BILL.SEND_MANAGER is '�����ֿ����Ա';
comment on column SALE_TRANSFER_BILL.SEND_DATE is '����ʱ��';
comment on column SALE_TRANSFER_BILL.RECEIVE_ORG is '�ջ���λ';
comment on column SALE_TRANSFER_BILL.RECEIVE_WH is '�ջ��ֿ�';
comment on column SALE_TRANSFER_BILL.RECEIVE_MANAGER is '�ջ��ֿ����Ա';
comment on column SALE_TRANSFER_BILL.RECEIVE_DATE is '�ջ�ʱ��';
comment on column SALE_TRANSFER_BILL.TICKETS is 'Ӧ����Ʊ��';
comment on column SALE_TRANSFER_BILL.AMOUNT is 'Ӧ����Ʊ���漰���';
comment on column SALE_TRANSFER_BILL.ACT_TICKETS is 'ʵ�ʵ���Ʊ��';
comment on column SALE_TRANSFER_BILL.ACT_AMOUNT is 'ʵ�ʵ���Ʊ���漰���';
comment on column SALE_TRANSFER_BILL.STATUS is '״̬��1-���ύ��2-�ѳ�����3-������4-�ѷ�����5-�ջ��У�6-���ջ���7-��������8-�Ѿܾ���';
comment on column SALE_TRANSFER_BILL.IS_MATCH is '�ջ��Ƿ��в��1-�޲��0-�в��';
comment on column SALE_TRANSFER_BILL.REMARK is '��ע';

create table SALE_TB_APPLY_DETAIL(
	STB_NO CHAR(10)  not null,
	SEQUENCE_NO NUMBER(24)  ,
	PLAN_CODE VARCHAR2(10)  not null,
	TICKETS NUMBER(18) default 0 not null,
	PACKAGES NUMBER(18) default 0 not null,
	AMOUNT NUMBER(28) default 0 not null,
	REMARK VARCHAR2(4000)  ,
	constraint PK_SALE_TB_APPLY_DETAIL primary Key (SEQUENCE_NO)
);
comment on table SALE_TB_APPLY_DETAIL is '������������ϸ';
comment on column SALE_TB_APPLY_DETAIL.STB_NO is '��������ţ�DB12345678��';
comment on column SALE_TB_APPLY_DETAIL.SEQUENCE_NO is '˳���';
comment on column SALE_TB_APPLY_DETAIL.PLAN_CODE is '��������';
comment on column SALE_TB_APPLY_DETAIL.TICKETS is 'Ʊ��';
comment on column SALE_TB_APPLY_DETAIL.PACKAGES is '����';
comment on column SALE_TB_APPLY_DETAIL.AMOUNT is '���';
comment on column SALE_TB_APPLY_DETAIL.REMARK is '��ע';

create table SALE_RETURN_RECODER(
	RETURN_NO CHAR(10)  not null,
	MARKET_MANAGER_ADMIN NUMBER(4)  not null,
	APPLY_DATE DATE  not null,
	APPLY_TICKETS NUMBER(10) default 0 not null,
	APPLY_AMOUNT NUMBER(18) default 0 not null,
	FINANCE_ADMIN NUMBER(4)  ,
	APPROVE_DATE DATE  ,
	APPROVE_REMARK VARCHAR2(4000)  ,
	ACT_TICKETS NUMBER(10) default 0 ,
	ACT_AMOUNT NUMBER(18) default 0 ,
	STATUS  NUMBER(1)  not null,
	IS_DIRECT_AUDITED NUMBER(1) default 0 not null,
	DIRECT_AMOUNT NUMBER(18)  ,
	RECEIVE_ORG CHAR(2)  ,
	RECEIVE_WH CHAR(4)  ,
	RECEIVE_MANAGER NUMBER(4)  ,
	RECEIVE_DATE DATE  ,
	constraint PK_SALE_RETURN_RECODER primary Key (RETURN_NO)
);
comment on table SALE_RETURN_RECODER is '������';
comment on column SALE_RETURN_RECODER.RETURN_NO is '�˻���ţ�TH12345678��';
comment on column SALE_RETURN_RECODER.MARKET_MANAGER_ADMIN is '�г�����Ա';
comment on column SALE_RETURN_RECODER.APPLY_DATE is '��������';
comment on column SALE_RETURN_RECODER.APPLY_TICKETS is '�����˻���������Ʊ����';
comment on column SALE_RETURN_RECODER.APPLY_AMOUNT is '�����˻��ܽ��';
comment on column SALE_RETURN_RECODER.FINANCE_ADMIN is '����������';
comment on column SALE_RETURN_RECODER.APPROVE_DATE is '��������';
comment on column SALE_RETURN_RECODER.APPROVE_REMARK is '�������';
comment on column SALE_RETURN_RECODER.ACT_TICKETS is 'ʵ���˻���������Ʊ����';
comment on column SALE_RETURN_RECODER.ACT_AMOUNT is 'ʵ���˻��ܽ��';
comment on column SALE_RETURN_RECODER.STATUS  is '״̬��1-���ύ��2-�ѳ�����3-������4-�ѷ�����5-�ջ��У�6-���ջ���7-��������8-�Ѿܾ���';
comment on column SALE_RETURN_RECODER.IS_DIRECT_AUDITED is '�Ƿ�ֱ������ͨ��';
comment on column SALE_RETURN_RECODER.DIRECT_AMOUNT is 'ֱ������ͨ���޶�';
comment on column SALE_RETURN_RECODER.RECEIVE_ORG is '�ջ���λ';
comment on column SALE_RETURN_RECODER.RECEIVE_WH is '�ջ��ֿ�';
comment on column SALE_RETURN_RECODER.RECEIVE_MANAGER is '�ջ��ֿ����Ա';
comment on column SALE_RETURN_RECODER.RECEIVE_DATE is '�ջ�ʱ��';

create table SALE_RETURN_APPLY_DETAIL(
	RETURN_NO CHAR(10)  not null,
	SEQUENCE_NO NUMBER(24)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	TICKETS NUMBER(18)  not null,
	PACKAGES NUMBER(18)  not null,
	AMOUNT NUMBER(28)  not null,
	constraint PK_SALE_RA_DETAIL primary Key (SEQUENCE_NO)
);
comment on table SALE_RETURN_APPLY_DETAIL is '������������ϸ';
comment on column SALE_RETURN_APPLY_DETAIL.RETURN_NO is '�˻���ţ�TH12345678��';
comment on column SALE_RETURN_APPLY_DETAIL.SEQUENCE_NO is '˳���';
comment on column SALE_RETURN_APPLY_DETAIL.PLAN_CODE is '��������';
comment on column SALE_RETURN_APPLY_DETAIL.TICKETS is 'Ʊ��';
comment on column SALE_RETURN_APPLY_DETAIL.PACKAGES is '����';
comment on column SALE_RETURN_APPLY_DETAIL.AMOUNT is '���';

create table SALE_AGENCY_RECEIPT(
	AR_NO CHAR(10)  not null,
	AR_ADMIN NUMBER(4)  not null,
	AR_DATE DATE  not null,
	AR_AGENCY CHAR(8)  not null,
	BEFORE_BALANCE NUMBER(28) default 0 not null,
	AFTER_BALANCE NUMBER(28) default 0 not null,
	TICKETS NUMBER(16) default 0 not null,
	AMOUNT NUMBER(28) default 0 not null,
	constraint PK_SALE_AGENCY_RECEIPT primary Key (AR_NO)
);
comment on table SALE_AGENCY_RECEIPT is 'վ����ⵥ';
comment on column SALE_AGENCY_RECEIPT.AR_NO is 'վ����ⵥ��ţ�AR12345678��';
comment on column SALE_AGENCY_RECEIPT.AR_ADMIN is '�г�����Ա';
comment on column SALE_AGENCY_RECEIPT.AR_DATE is '�ջ�ʱ��';
comment on column SALE_AGENCY_RECEIPT.AR_AGENCY is '�ջ�վ��';
comment on column SALE_AGENCY_RECEIPT.BEFORE_BALANCE is '�ջ�ǰվ�����';
comment on column SALE_AGENCY_RECEIPT.AFTER_BALANCE is '�ջ���վ�����';
comment on column SALE_AGENCY_RECEIPT.TICKETS is '�ջ���Ʊ��';
comment on column SALE_AGENCY_RECEIPT.AMOUNT is '�ջ��ܽ��';

create table SALE_AGENCY_RETURN(
	AI_NO CHAR(10)  not null,
	AI_MM_ADMIN NUMBER(4)  not null,
	AI_DATE DATE  not null,
	AI_AGENCY CHAR(8)  not null,
	BEFORE_BALANCE NUMBER(28) default 0 not null,
	AFTER_BALANCE NUMBER(28) default 0 not null,
	TICKETS NUMBER(16) default 0 not null,
	AMOUNT NUMBER(28) default 0 not null,
	constraint PK_SALE_AGENCY_RETURN primary Key (AI_NO)
);
comment on table SALE_AGENCY_RETURN is 'վ���˻���';
comment on column SALE_AGENCY_RETURN.AI_NO is 'վ���˻�����ţ�AI12345678��';
comment on column SALE_AGENCY_RETURN.AI_MM_ADMIN is '�г�����Ա';
comment on column SALE_AGENCY_RETURN.AI_DATE is '�˻�ʱ��';
comment on column SALE_AGENCY_RETURN.AI_AGENCY is '�˻�վ��';
comment on column SALE_AGENCY_RETURN.BEFORE_BALANCE is '�˻�ǰվ�����';
comment on column SALE_AGENCY_RETURN.AFTER_BALANCE is '�˻���վ�����';
comment on column SALE_AGENCY_RETURN.TICKETS is '�˻���Ʊ��';
comment on column SALE_AGENCY_RETURN.AMOUNT is '�˻��ܽ��';

create table SALE_PAID(
	DJXQ_NO CHAR(24)  not null,
	PAY_AGENCY CHAR(8)  not null,
	AREA_CODE CHAR(4)  ,
	PAYER_ADMIN NUMBER(4)  not null,
	IS_CENTER_PAID NUMBER(1) default 3 not null,
	PLAN_TICKETS NUMBER(28) default 0 not null,
	SUCC_TICKETS NUMBER(28) default 0 not null,
	SUCC_AMOUNT NUMBER(28) default 0 not null,
	PAY_TIME DATE default sysdate not null,
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
comment on column SALE_PAID.PAY_TIME is '�ҽ�ʱ��';
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
	PAY_TIME DATE default sysdate not null,
	IS_OLD_TICKET NUMBER(1) default 0 not null,
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
comment on column SALE_PAID_DETAIL.PAID_STATUS is '�ҽ�״̬��1-�ɹ���2-�Ƿ�Ʊ��3-�Ѷҽ���4-�д󽱡�5-δ�н���6-δ���ۡ�8-�����սᣩ';
comment on column SALE_PAID_DETAIL.PAY_FLOW is '�ҽ���ˮ��';
comment on column SALE_PAID_DETAIL.REWARD_AMOUNT is '�н����';
comment on column SALE_PAID_DETAIL.PAY_TIME is '�ҽ�ʱ��';
comment on column SALE_PAID_DETAIL.IS_OLD_TICKET is '�Ƿ��Ʊ';
create index IDX_SALE_PAID_DETAIL_DJXQ on SALE_PAID_DETAIL(DJXQ_NO);
create index IDX_SALE_PAID_DETAIL_TICKET on SALE_PAID_DETAIL(PLAN_CODE,BATCH_NO,PACKAGE_NO,TICKET_NO);
create index IDX_SALE_PAID_DETAIL_FLOW on SALE_PAID_DETAIL(PAY_FLOW);

create table FLOW_GUI_PAY(
	GUI_PAY_NO CHAR(12)  not null,
	WINNERNAME VARCHAR2(1000)  ,
	GENDER NUMBER(1)  ,
	CONTACT VARCHAR2(4000)  ,
	AGE NUMBER(3)  ,
	CERT_NUMBER VARCHAR2(50)  ,
	REWARD_NO NUMBER(3)  ,
	PAY_AMOUNT NUMBER(28)  not null,
	PAY_TIME DATE  not null,
	PAYER_ADMIN NUMBER(4)  not null,
	PAYER_NAME VARCHAR2(1000)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNK_NO VARCHAR2(10)  not null,
	BOX_NO VARCHAR2(20)  not null,
	PACKAGE_NO VARCHAR2(10)  not null,
	TICKET_NO NUMBER(5)  not null,
	SECURITY_CODE VARCHAR2(50)  ,
	IS_MANUAL NUMBER(1)  ,
	PAY_FLOW CHAR(24)  not null,
   REMARK VARCHAR2(4000),
	constraint PK_FLOW_GUI_PAY primary Key (GUI_PAY_NO)
);
comment on table FLOW_GUI_PAY is 'GUI�ҽ���Ϣ��¼��';
comment on column FLOW_GUI_PAY.GUI_PAY_NO is '���Ķҽ���ţ�GD1234567890��';
comment on column FLOW_GUI_PAY.WINNERNAME is '�н�������';
comment on column FLOW_GUI_PAY.GENDER is '�н����Ա�(1=�С�2=Ů)';
comment on column FLOW_GUI_PAY.CONTACT is '�н�����ϵ��ʽ';
comment on column FLOW_GUI_PAY.AGE is '�н�������';
comment on column FLOW_GUI_PAY.CERT_NUMBER is '�н���֤������';
comment on column FLOW_GUI_PAY.REWARD_NO is '�н��ȼ�';
comment on column FLOW_GUI_PAY.PAY_AMOUNT is '�н����';
comment on column FLOW_GUI_PAY.PAY_TIME is '�ҽ�ʱ��';
comment on column FLOW_GUI_PAY.PAYER_ADMIN is '�ҽ�����Ա���';
comment on column FLOW_GUI_PAY.PAYER_NAME is '�ҽ�����Ա����';
comment on column FLOW_GUI_PAY.PLAN_CODE is '��������';
comment on column FLOW_GUI_PAY.BATCH_NO is '����';
comment on column FLOW_GUI_PAY.TRUNK_NO is '���';
comment on column FLOW_GUI_PAY.BOX_NO is '�кţ����+����˳��ţ�';
comment on column FLOW_GUI_PAY.PACKAGE_NO is '����';
comment on column FLOW_GUI_PAY.TICKET_NO is 'Ʊ��';
comment on column FLOW_GUI_PAY.SECURITY_CODE is '��������';
comment on column FLOW_GUI_PAY.IS_MANUAL is '�Ƿ��ֶ��ҽ���1-�ǣ�0-��';
comment on column FLOW_GUI_PAY.PAY_FLOW is '�ҽ���ˮ';
comment on column FLOW_GUI_PAY.REMARK is '�ҽ���ע';
create index UDX_FLOW_GUI_PAY_TICKET on FLOW_GUI_PAY(PLAN_CODE,BATCH_NO,TRUNK_NO,BOX_NO,PACKAGE_NO,TICKET_NO);

create table FLOW_PAY(
	PAY_FLOW CHAR(24)  not null,
	PAY_AGENCY CHAR(8)  ,
	AREA_CODE CHAR(4)  ,
	PAY_COMM NUMBER(18)  ,
	PAY_COMM_RATE NUMBER(8)  ,
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
	COMM_AMOUNT NUMBER(18)  ,
	COMM_RATE NUMBER(8)  ,
	PAY_TIME DATE  not null,
	PAYER_ADMIN NUMBER(4)  ,
	PAYER_NAME VARCHAR2(1000)  ,
	IS_CENTER_PAID NUMBER(1) default 0 not null,
	constraint PK_FLOW_PAY primary Key (PAY_FLOW)
);
comment on table FLOW_PAY is '�ҽ��ʽ���ˮ';
comment on column FLOW_PAY.PAY_FLOW is '�ҽ���ˮ��DJ123456789012345678901234��';
comment on column FLOW_PAY.PAY_AGENCY is '�ҽ�վ��';
comment on column FLOW_PAY.AREA_CODE is '�������';
comment on column FLOW_PAY.PAY_COMM is '�ҽ�Ӷ��';
comment on column FLOW_PAY.PAY_COMM_RATE is '�ҽ�Ӷ�������ǧ��λ��';
comment on column FLOW_PAY.PLAN_CODE is '��������';
comment on column FLOW_PAY.BATCH_NO is '����';
comment on column FLOW_PAY.REWARD_GROUP is '����';
comment on column FLOW_PAY.TRUNK_NO is '���';
comment on column FLOW_PAY.BOX_NO is '�кţ����+����˳��ţ�';
comment on column FLOW_PAY.PACKAGE_NO is '����';
comment on column FLOW_PAY.TICKET_NO is 'Ʊ��';
comment on column FLOW_PAY.SECURITY_CODE is '��������';
comment on column FLOW_PAY.IDENTITY_CODE is '��������';
comment on column FLOW_PAY.PAY_AMOUNT is '�н����';
comment on column FLOW_PAY.REWARD_NO is '�н��ȼ�';
comment on column FLOW_PAY.LOTTERY_AMOUNT is '��Ʊ���';
comment on column FLOW_PAY.COMM_AMOUNT is '�ҽ�Ӷ��';
comment on column FLOW_PAY.COMM_RATE is '�ҽ�Ӷ�����';
comment on column FLOW_PAY.PAY_TIME is '�ҽ�ʱ��';
comment on column FLOW_PAY.PAYER_ADMIN is '�ҽ�����Ա���';
comment on column FLOW_PAY.PAYER_NAME is '�ҽ�����Ա����';
comment on column FLOW_PAY.IS_CENTER_PAID is '�ҽ���ʽ��1=���Ķҽ���2=�ֹ��ҽ���3=վ��ҽ���';
create index UDX_FLOW_PAY_TICKET on FLOW_PAY(PLAN_CODE,BATCH_NO,TRUNK_NO,BOX_NO,PACKAGE_NO,TICKET_NO);

create table FLOW_SALE(
	SALE_FLOW CHAR(24)  not null,
	AGENCY_CODE CHAR(8)  not null,
	AREA_CODE CHAR(4)  not null,
	ORG_CODE CHAR(2)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNKS NUMBER(18)  not null,
	BOXES NUMBER(18)  not null,
	PACKAGES NUMBER(18)  not null,
	TICKETS NUMBER(18)  not null,
	SALE_AMOUNT NUMBER(28)  not null,
	COMM_AMOUNT NUMBER(18)  not null,
	COMM_RATE NUMBER(8)  not null,
	SALE_TIME DATE  not null,
	AR_NO CHAR(10)  not null,
	SGR_NO CHAR(10)  not null,
	constraint PK_FLOW_SALE primary Key (SALE_FLOW)
);
comment on table FLOW_SALE is '���ۼ�¼';
comment on column FLOW_SALE.SALE_FLOW is '������ˮ��XS1234567890123456789012��';
comment on column FLOW_SALE.AGENCY_CODE is '����վ��';
comment on column FLOW_SALE.AREA_CODE is '�������';
comment on column FLOW_SALE.ORG_CODE is '��֯����';
comment on column FLOW_SALE.PLAN_CODE is '��������';
comment on column FLOW_SALE.BATCH_NO is '����';
comment on column FLOW_SALE.TRUNKS is '��';
comment on column FLOW_SALE.BOXES is '����';
comment on column FLOW_SALE.PACKAGES is '����';
comment on column FLOW_SALE.TICKETS is '��������';
comment on column FLOW_SALE.SALE_AMOUNT is '���۽��';
comment on column FLOW_SALE.COMM_AMOUNT is '����Ӷ��';
comment on column FLOW_SALE.COMM_RATE is '����Ӷ�������ǧ��λ��';
comment on column FLOW_SALE.SALE_TIME is '����ʱ��';
comment on column FLOW_SALE.AR_NO is 'վ����ⵥ���';
comment on column FLOW_SALE.SGR_NO is '��ⵥ���';
create index IDX_FLOW_SALE_AGENCY on FLOW_SALE(AGENCY_CODE);
create index IDX_FLOW_SALE_AREA on FLOW_SALE(AREA_CODE);
create index IDX_FLOW_SALE_GAME on FLOW_SALE(PLAN_CODE,BATCH_NO);

create table FLOW_CANCEL(
	CANCEL_FLOW CHAR(24)  not null,
	AGENCY_CODE CHAR(8)  not null,
	AREA_CODE CHAR(4)  not null,
	ORG_CODE CHAR(2)  not null,
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
	constraint PK_FLOW_CANCEL primary Key (CANCEL_FLOW)
);
comment on table FLOW_CANCEL is '��Ʊ��¼';
comment on column FLOW_CANCEL.CANCEL_FLOW is '��Ʊ��ˮ��TP1234567890123456789012��';
comment on column FLOW_CANCEL.AGENCY_CODE is '��Ʊվ��';
comment on column FLOW_CANCEL.AREA_CODE is '�������';
comment on column FLOW_CANCEL.ORG_CODE is '��֯����';
comment on column FLOW_CANCEL.PLAN_CODE is '��������';
comment on column FLOW_CANCEL.BATCH_NO is '����';
comment on column FLOW_CANCEL.TRUNKS is '����';
comment on column FLOW_CANCEL.BOXES is '����';
comment on column FLOW_CANCEL.PACKAGES is '����';
comment on column FLOW_CANCEL.TICKETS is '��Ʊ����';
comment on column FLOW_CANCEL.SALE_AMOUNT is '��Ʊ���';
comment on column FLOW_CANCEL.COMM_AMOUNT is '�漰Ӷ��';
comment on column FLOW_CANCEL.COMM_RATE is 'Ӷ�������ǧ��λ��';
comment on column FLOW_CANCEL.CANCEL_TIME is '��Ʊʱ��';
comment on column FLOW_CANCEL.AI_NO is 'վ���˻������';
comment on column FLOW_CANCEL.SGI_NO is '���ⵥ���';
create index IDX_FLOW_CANCEL_AGENCY on FLOW_CANCEL(AGENCY_CODE);
create index IDX_FLOW_CANCEL_AREA on FLOW_CANCEL(AREA_CODE);
create index IDX_FLOW_CANCEL_GAME on FLOW_CANCEL(PLAN_CODE,BATCH_NO);

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
comment on table FLOW_PAY_ORG_COMM is '�ҽ��ʽ���ˮ������Ӷ��';
comment on column FLOW_PAY_ORG_COMM.PAY_FLOW is '�ҽ���ˮ��DJ123456789012345678901234��';
comment on column FLOW_PAY_ORG_COMM.PAY_AGENCY is '�ҽ�վ��';
comment on column FLOW_PAY_ORG_COMM.AREA_CODE is '�������';
comment on column FLOW_PAY_ORG_COMM.ORG_CODE is '��֯����';
comment on column FLOW_PAY_ORG_COMM.ORG_TYPE is '�������1-��˾,2-����';
comment on column FLOW_PAY_ORG_COMM.ORG_PAY_COMM is '�����ҽ�Ӷ��';
comment on column FLOW_PAY_ORG_COMM.ORG_PAY_COMM_RATE is '�����ҽ�Ӷ�������ǧ��λ��';
comment on column FLOW_PAY_ORG_COMM.PLAN_CODE is '��������';
comment on column FLOW_PAY_ORG_COMM.BATCH_NO is '����';
comment on column FLOW_PAY_ORG_COMM.REWARD_GROUP is '����';
comment on column FLOW_PAY_ORG_COMM.TRUNK_NO is '���';
comment on column FLOW_PAY_ORG_COMM.BOX_NO is '�кţ����+����˳��ţ�';
comment on column FLOW_PAY_ORG_COMM.PACKAGE_NO is '����';
comment on column FLOW_PAY_ORG_COMM.TICKET_NO is 'Ʊ��';
comment on column FLOW_PAY_ORG_COMM.SECURITY_CODE is '��������';
comment on column FLOW_PAY_ORG_COMM.IDENTITY_CODE is '��������';
comment on column FLOW_PAY_ORG_COMM.PAY_AMOUNT is '�н����';
comment on column FLOW_PAY_ORG_COMM.REWARD_NO is '�н��ȼ�';
comment on column FLOW_PAY_ORG_COMM.LOTTERY_AMOUNT is '��Ʊ���';
comment on column FLOW_PAY_ORG_COMM.PAY_TIME is '�ҽ�ʱ��';
comment on column FLOW_PAY_ORG_COMM.PAYER_ADMIN is '�ҽ�����Ա���';
comment on column FLOW_PAY_ORG_COMM.PAYER_NAME is '�ҽ�����Ա����';
comment on column FLOW_PAY_ORG_COMM.IS_CENTER_PAID is '�ҽ���ʽ��1=���Ķҽ���2=�ֹ��ҽ���3=վ��ҽ���';
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
comment on table FLOW_SALE_ORG_COMM is '���ۼ�¼������Ӷ��';
comment on column FLOW_SALE_ORG_COMM.SALE_FLOW is '������ˮ��XS1234567890123456789012��';
comment on column FLOW_SALE_ORG_COMM.AGENCY_CODE is '����վ��';
comment on column FLOW_SALE_ORG_COMM.AREA_CODE is '�������';
comment on column FLOW_SALE_ORG_COMM.ORG_CODE is '��֯����';
comment on column FLOW_SALE_ORG_COMM.ORG_TYPE is '�������1-��˾,2-����';
comment on column FLOW_SALE_ORG_COMM.PLAN_CODE is '��������';
comment on column FLOW_SALE_ORG_COMM.BATCH_NO is '����';
comment on column FLOW_SALE_ORG_COMM.TRUNKS is '��';
comment on column FLOW_SALE_ORG_COMM.BOXES is '����';
comment on column FLOW_SALE_ORG_COMM.PACKAGES is '����';
comment on column FLOW_SALE_ORG_COMM.TICKETS is '��������';
comment on column FLOW_SALE_ORG_COMM.SALE_AMOUNT is '���۽��';
comment on column FLOW_SALE_ORG_COMM.ORG_COMM_AMOUNT is '��������Ӷ��';
comment on column FLOW_SALE_ORG_COMM.ORG_COMM_RATE is '��������Ӷ�������ǧ��λ��';
comment on column FLOW_SALE_ORG_COMM.SALE_TIME is '����ʱ��';
comment on column FLOW_SALE_ORG_COMM.AR_NO is 'վ����ⵥ���';
comment on column FLOW_SALE_ORG_COMM.SGR_NO is '��ⵥ���';
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
comment on table FLOW_CANCEL_ORG_COMM is '��Ʊ��¼������Ӷ��';
comment on column FLOW_CANCEL_ORG_COMM.CANCEL_FLOW is '��Ʊ��ˮ��TP1234567890123456789012��';
comment on column FLOW_CANCEL_ORG_COMM.AGENCY_CODE is '��Ʊվ��';
comment on column FLOW_CANCEL_ORG_COMM.AREA_CODE is '�������';
comment on column FLOW_CANCEL_ORG_COMM.ORG_CODE is '��֯����';
comment on column FLOW_CANCEL_ORG_COMM.ORG_TYPE is '�������1-��˾,2-����';
comment on column FLOW_CANCEL_ORG_COMM.PLAN_CODE is '��������';
comment on column FLOW_CANCEL_ORG_COMM.BATCH_NO is '����';
comment on column FLOW_CANCEL_ORG_COMM.TRUNKS is '����';
comment on column FLOW_CANCEL_ORG_COMM.BOXES is '����';
comment on column FLOW_CANCEL_ORG_COMM.PACKAGES is '����';
comment on column FLOW_CANCEL_ORG_COMM.TICKETS is '��Ʊ����';
comment on column FLOW_CANCEL_ORG_COMM.SALE_AMOUNT is '��Ʊ���';
comment on column FLOW_CANCEL_ORG_COMM.COMM_AMOUNT is '�漰����Ӷ��';
comment on column FLOW_CANCEL_ORG_COMM.COMM_RATE is '�漰����Ӷ�������ǧ��λ��';
comment on column FLOW_CANCEL_ORG_COMM.CANCEL_TIME is '��Ʊʱ��';
comment on column FLOW_CANCEL_ORG_COMM.AI_NO is 'վ���˻������';
comment on column FLOW_CANCEL_ORG_COMM.SGI_NO is '���ⵥ���';
create index IDX_FLOW_CANCEL_ORG_AGENCY on FLOW_CANCEL_ORG_COMM(AGENCY_CODE);
create index IDX_FLOW_CANCEL_ORG_AREA on FLOW_CANCEL_ORG_COMM(AREA_CODE);
create index IDX_FLOW_CANCEL_ORG_GAME on FLOW_CANCEL_ORG_COMM(PLAN_CODE,BATCH_NO);

create table FLOW_ORG(
	ORG_FUND_FLOW CHAR(24)  not null,
	REF_NO VARCHAR2(30)  not null,
	FLOW_TYPE NUMBER(2)  not null,
	ACC_NO CHAR(12)  not null,
	ORG_CODE CHAR(2)  not null,
	CHANGE_AMOUNT NUMBER(28)  not null,
	FROZEN_AMOUNT NUMBER(28) default 0 not null,
	BE_ACCOUNT_BALANCE NUMBER(28)  not null,
	BE_FROZEN_BALANCE NUMBER(28)  not null,
	AF_ACCOUNT_BALANCE NUMBER(28)  not null,
	AF_FROZEN_BALANCE NUMBER(28)  not null,
	TRADE_TIME DATE default sysdate not null,
	constraint PK_FLOW_ORG primary Key (ORG_FUND_FLOW)
);
comment on table FLOW_ORG is '�����ʽ���ˮ';
comment on column FLOW_ORG.ORG_FUND_FLOW is '��ˮ�ţ�JG123456789012345678901234��';
comment on column FLOW_ORG.REF_NO is '�ο�ҵ����';
comment on column FLOW_ORG.FLOW_TYPE is '�ʽ����ͣ�1-��ֵ��2-���֣�3-��Ʊ������⣨��������4-��Ʊ�������Ӷ�𣨻�������12-��Ʊ�������⣨��������21-վ��ҽ����»���Ӷ�𣨻�������22-վ��ҽ����»��������ʽ𣨻�������23-���Ķҽ����»���Ӷ�𣨻�������24-���Ķҽ����»��������ʽ𣨻�������31-��Ʊ����������Ӷ�𣨻�������';
comment on column FLOW_ORG.ACC_NO is '�˻�����';
comment on column FLOW_ORG.ORG_CODE is '���ű���';
comment on column FLOW_ORG.CHANGE_AMOUNT is '������';
comment on column FLOW_ORG.FROZEN_AMOUNT is '������';
comment on column FLOW_ORG.BE_ACCOUNT_BALANCE is '���ǰ�������';
comment on column FLOW_ORG.BE_FROZEN_BALANCE is '���ǰ�������';
comment on column FLOW_ORG.AF_ACCOUNT_BALANCE is '�����������';
comment on column FLOW_ORG.AF_FROZEN_BALANCE is '����󶳽����';
comment on column FLOW_ORG.TRADE_TIME is '����ʱ��';
create index IDX_FLOW_ORG_ACC on FLOW_ORG(ACC_NO);
create index IDX_FLOW_ORG_ORG on FLOW_ORG(ORG_CODE);

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
	AGENCY_SALE_COMM_RATE NUMBER(28) default 0 not null,
	ORG_SALE_COMM_RATE NUMBER(28) default 0 not null,
	AGENCY_CANCEL_AMOUNT NUMBER(28) default 0 not null,
	ORG_CANCEL_COMM NUMBER(28) default 0 not null,
	AGENCY_CANCEL_COMM_RATE NUMBER(28) default 0 not null,
	ORG_CANCEL_COMM_RATE NUMBER(28) default 0 not null,
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
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_SALE_COMM_RATE is 'վ������Ӷ�����';
comment on column FLOW_ORG_COMM_DETAIL.ORG_SALE_COMM_RATE is '��������Ӷ�����';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_CANCEL_AMOUNT is 'վ���˻����';
comment on column FLOW_ORG_COMM_DETAIL.ORG_CANCEL_COMM is '�����˻�Ӷ��';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_CANCEL_COMM_RATE is 'վ���˻�Ӷ�����';
comment on column FLOW_ORG_COMM_DETAIL.ORG_CANCEL_COMM_RATE is '�����˻�Ӷ�����';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_PAY_AMOUNT is 'վ��ҽ����';
comment on column FLOW_ORG_COMM_DETAIL.ORG_PAY_AMOUNT is '�����ҽ�Ӷ��';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_PAY_COMM_RATE is 'վ��ҽ�Ӷ�����';
comment on column FLOW_ORG_COMM_DETAIL.ORG_PAY_COMM_RATE is '�����ҽ�Ӷ�����';
create index IDX_FLOW_ORG_COMM_AGENCY on FLOW_ORG_COMM_DETAIL(ACC_NO);
create index IDX_FLOW_ORG_COMM_FLOW on FLOW_ORG_COMM_DETAIL(ORG_FUND_COMM_FLOW);

create table FLOW_AGENCY(
	AGENCY_FUND_FLOW CHAR(24)  not null,
	REF_NO VARCHAR2(24)  not null,
	FLOW_TYPE NUMBER(2)  not null,
	ACC_NO CHAR(12)  not null,
	AGENCY_CODE CHAR(8)  not null,
	CHANGE_AMOUNT NUMBER(28)  not null,
	FROZEN_AMOUNT NUMBER(28) default 0 not null,
	BE_ACCOUNT_BALANCE NUMBER(28) default 0 not null,
	BE_FROZEN_BALANCE NUMBER(28) default 0 not null,
	AF_ACCOUNT_BALANCE NUMBER(28) default 0 not null,
	AF_FROZEN_BALANCE NUMBER(28) default 0 not null,
	TRADE_TIME DATE default sysdate not null,
	constraint PK_FLOW_AGENCY primary Key (AGENCY_FUND_FLOW)
);
comment on table FLOW_AGENCY is 'վ���ʽ���ˮ';
comment on column FLOW_AGENCY.AGENCY_FUND_FLOW is '��ˮ�ţ�ZD123456789012345678901234��';
comment on column FLOW_AGENCY.REF_NO is '�ο�ҵ����';
comment on column FLOW_AGENCY.FLOW_TYPE is '�ʽ����ͣ�1-��ֵ��2-���֣�5-����Ӷ��6-�ҽ�Ӷ��7-���ۣ�8-�ҽ���11-վ���˻���13-����Ӷ��';
comment on column FLOW_AGENCY.ACC_NO is '�˻�����';
comment on column FLOW_AGENCY.AGENCY_CODE is '����վ���';
comment on column FLOW_AGENCY.CHANGE_AMOUNT is '������';
comment on column FLOW_AGENCY.FROZEN_AMOUNT is '������';
comment on column FLOW_AGENCY.BE_ACCOUNT_BALANCE is '���ǰ�������';
comment on column FLOW_AGENCY.BE_FROZEN_BALANCE is '���ǰ�������';
comment on column FLOW_AGENCY.AF_ACCOUNT_BALANCE is '�����������';
comment on column FLOW_AGENCY.AF_FROZEN_BALANCE is '����󶳽����';
comment on column FLOW_AGENCY.TRADE_TIME is '����ʱ��';
create index IDX_FLOW_AGENCY_ACC on FLOW_AGENCY(ACC_NO);
create index IDX_FLOW_AGENCY_ORG on FLOW_AGENCY(AGENCY_CODE);
create index IDX_FLOW_AGENCY_TIME on FLOW_AGENCY(TRADE_TIME);
create index IDX_FLOW_AGENCY_ERF_NO on FLOW_AGENCY(REF_NO);

create table FLOW_MARKET_MANAGER(
	MM_FUND_FLOW CHAR(24)  not null,
	REF_NO CHAR(10)  not null,
	FLOW_TYPE NUMBER(2)  not null,
	ACC_NO CHAR(12)  not null,
	MARKET_ADMIN NUMBER(4)  not null,
	CHANGE_AMOUNT NUMBER(28)  not null,
	BE_ACCOUNT_BALANCE NUMBER(28)  not null,
	AF_ACCOUNT_BALANCE NUMBER(28)  not null,
	TRADE_TIME DATE default sysdate not null,
	constraint PK_FLOW_MARKET_MANAGER primary Key (MM_FUND_FLOW)
);
comment on table FLOW_MARKET_MANAGER is '�г�����Ա�ʽ���ˮ';
comment on column FLOW_MARKET_MANAGER.MM_FUND_FLOW is '��ˮ�ţ�MM123456789012345678901234��';
comment on column FLOW_MARKET_MANAGER.REF_NO is '�ο�ҵ����';
comment on column FLOW_MARKET_MANAGER.FLOW_TYPE is '�ʽ����ͣ�9-Ϊվ���ֵ��10-�ֽ��Ͻɣ�14-Ϊվ�����֣�';
comment on column FLOW_MARKET_MANAGER.ACC_NO is '�˻�����';
comment on column FLOW_MARKET_MANAGER.MARKET_ADMIN is '�г�����Ա';
comment on column FLOW_MARKET_MANAGER.CHANGE_AMOUNT is '������';
comment on column FLOW_MARKET_MANAGER.BE_ACCOUNT_BALANCE is '���ǰ�������';
comment on column FLOW_MARKET_MANAGER.AF_ACCOUNT_BALANCE is '�����������';
comment on column FLOW_MARKET_MANAGER.TRADE_TIME is '����ʱ��';

create table SYS_PARAMETER(
	SYS_DEFAULT_SEQ NUMBER(12)  not null,
	SYS_DEFAULT_DESC VARCHAR2(1000)  not null,
	SYS_DEFAULT_VALUE VARCHAR2(1000)  not null,
	constraint PK_SYS_PARAMETER primary Key (SYS_DEFAULT_SEQ)
);
comment on table SYS_PARAMETER is 'ϵͳ������';
comment on column SYS_PARAMETER.SYS_DEFAULT_SEQ is 'ϵͳ�������';
comment on column SYS_PARAMETER.SYS_DEFAULT_DESC is 'ϵͳ��������';
comment on column SYS_PARAMETER.SYS_DEFAULT_VALUE is 'ϵͳ����ֵ';

create table SYS_OPER_LOG(
	OPER_NO CHAR(10)  not null,
	OPER_PRIVILEGE NUMBER(4)  not null,
	OPER_ADMIN NUMBER(4)  not null,
	OPER_TIME DATE  not null,
	OPER_MODE NUMBER(1)  not null,
	OPER_CONTENTS VARCHAR2(4000)  ,
	constraint PK_SYS_OPER_LOG primary Key (OPER_NO)
);
comment on table SYS_OPER_LOG is 'ϵͳ������־';
comment on column SYS_OPER_LOG.OPER_NO is '������־��ţ�RZ 12345678��';
comment on column SYS_OPER_LOG.OPER_PRIVILEGE is '����ģ����루�˵����ƣ�';
comment on column SYS_OPER_LOG.OPER_ADMIN is '������';
comment on column SYS_OPER_LOG.OPER_TIME is '����ʱ��';
comment on column SYS_OPER_LOG.OPER_MODE is '�������ͣ�1=������2=ɾ����3=���ģ�';
comment on column SYS_OPER_LOG.OPER_CONTENTS is '��������';

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

create table FUND_CHARGE_CENTER(
	FUND_NO CHAR(10)  not null,
	ACCOUNT_TYPE NUMBER(1)  not null,
	AO_CODE VARCHAR2(8)  not null,
	AO_NAME VARCHAR2(4000)  ,
	ACC_NO CHAR(12)  not null,
	OPER_AMOUNT NUMBER(28)  not null,
	BE_ACCOUNT_BALANCE NUMBER(28)  not null,
	AF_ACCOUNT_BALANCE NUMBER(28)  not null,
	OPER_TIME DATE  not null,
	OPER_ADMIN NUMBER(4)  not null,
	constraint PK_FUND_CHARGE_CENTER primary Key (FUND_NO)
);
comment on table FUND_CHARGE_CENTER is '����վ�����������ĳ�ֵ';
comment on column FUND_CHARGE_CENTER.FUND_NO is '��ֵ��ţ�FC12345678��';
comment on column FUND_CHARGE_CENTER.ACCOUNT_TYPE is '�˻����ͣ�1-������2-վ�㣩';
comment on column FUND_CHARGE_CENTER.AO_CODE is '����վ������������';
comment on column FUND_CHARGE_CENTER.AO_NAME is '����վ������������';
comment on column FUND_CHARGE_CENTER.ACC_NO is '�˻�����';
comment on column FUND_CHARGE_CENTER.OPER_AMOUNT is '�ɿ���';
comment on column FUND_CHARGE_CENTER.BE_ACCOUNT_BALANCE is '�ɿ�ǰ����վ���';
comment on column FUND_CHARGE_CENTER.AF_ACCOUNT_BALANCE is '�ɿ������վ���';
comment on column FUND_CHARGE_CENTER.OPER_TIME is '����ʱ��';
comment on column FUND_CHARGE_CENTER.OPER_ADMIN is '�����˱���';

create table FUND_WITHDRAW(
	FUND_NO CHAR(10)  not null,
	ACCOUNT_TYPE NUMBER(1)  not null,
	AO_CODE VARCHAR2(8)  not null,
	AO_NAME VARCHAR2(4000)  ,
	ACC_NO CHAR(12)  not null,
	APPLY_AMOUNT NUMBER(16)  not null,
	APPLY_ADMIN NUMBER(4)  not null,
	APPLY_DATE DATE  not null,
	MARKET_ADMIN NUMBER(4)  ,
	APPLY_CHECK_TIME DATE  ,
	CHECK_ADMIN_ID NUMBER(4)  ,
	APPLY_STATUS NUMBER(1)  not null,
	APPLY_MEMO VARCHAR2(4000)  ,
	TERMINAL_CODE CHAR(8)  ,
	constraint PK_FUND_WITHDRAW primary Key (FUND_NO)
);
comment on table FUND_WITHDRAW is '����վ������������';
comment on column FUND_WITHDRAW.FUND_NO is '���ֱ�ţ�FW12345678��';
comment on column FUND_WITHDRAW.ACCOUNT_TYPE is '�˻����ͣ�1-������2-վ�㣩';
comment on column FUND_WITHDRAW.AO_CODE is '����վ������������';
comment on column FUND_WITHDRAW.AO_NAME is '����վ������������';
comment on column FUND_WITHDRAW.ACC_NO is '�˻�����';
comment on column FUND_WITHDRAW.APPLY_AMOUNT is '���ֽ��';
comment on column FUND_WITHDRAW.APPLY_ADMIN is '����������';
comment on column FUND_WITHDRAW.APPLY_DATE is '��������ʱ��';
comment on column FUND_WITHDRAW.MARKET_ADMIN is '�г�����Ա';
comment on column FUND_WITHDRAW.APPLY_CHECK_TIME is '�������ʱ��';
comment on column FUND_WITHDRAW.CHECK_ADMIN_ID is '���������';
comment on column FUND_WITHDRAW.APPLY_STATUS is '�����¼״̬��1=���ύ��2=�ѳ�����3=����ˡ�4=�Ѿܾ���5-�����֡�6=�ɿ�ɹ���';
comment on column FUND_WITHDRAW.APPLY_MEMO is '��ע';
comment on column FUND_WITHDRAW.TERMINAL_CODE is '�����ն˻�����';

create table FUND_TUNING(
	FUND_NO CHAR(10)  not null,
	ACCOUNT_TYPE NUMBER(1)  not null,
	AO_CODE VARCHAR2(8)  not null,
	AO_NAME VARCHAR2(4000)  ,
	ACC_NO CHAR(12)  not null,
	TUNING_TYPE NUMBER(1)  not null,
	CHANGE_AMOUNT NUMBER(28)  not null,
	BE_ACCOUNT_BALANCE NUMBER(28)  not null,
	AF_ACCOUNT_BALANCE NUMBER(28)  not null,
	OPER_TIME DATE  not null,
	OPER_ADMIN NUMBER(4)  not null,
	constraint PK_FUND_TUNING primary Key (FUND_NO)
);
comment on table FUND_TUNING is '����վ������������';
comment on column FUND_TUNING.FUND_NO is '���˱�ţ�FT12345678��';
comment on column FUND_TUNING.ACCOUNT_TYPE is '�˻����ͣ�1-������2-վ�㣩';
comment on column FUND_TUNING.AO_CODE is '����վ������������';
comment on column FUND_TUNING.AO_NAME is '����վ������������';
comment on column FUND_TUNING.ACC_NO is '�˻�����';
comment on column FUND_TUNING.TUNING_TYPE is '�������ͣ�1-������2-������';
comment on column FUND_TUNING.CHANGE_AMOUNT is '����������Ϊ����������Ϊ������';
comment on column FUND_TUNING.BE_ACCOUNT_BALANCE is '���ǰ�������';
comment on column FUND_TUNING.AF_ACCOUNT_BALANCE is '�����������';
comment on column FUND_TUNING.OPER_TIME is '����ʱ��';
comment on column FUND_TUNING.OPER_ADMIN is '�����˱���';

create table FUND_MM_CASH_REPAY(
	MCR_NO CHAR(10)  not null,
	MARKET_ADMIN NUMBER(4)  not null,
	REPAY_AMOUNT NUMBER(16)  ,
	REPAY_TIME DATE  ,
	REPAY_ADMIN NUMBER(4)  not null,
	REMARK VARCHAR2(4000)  ,
	constraint PK_FUND_MM_CASH_REPAY primary Key (MCR_NO)
);
comment on table FUND_MM_CASH_REPAY is '�ֽ��Ͻ�';
comment on column FUND_MM_CASH_REPAY.MCR_NO is '�Ͻ���ˮ��JK12345678��';
comment on column FUND_MM_CASH_REPAY.MARKET_ADMIN is '�г�����Ա';
comment on column FUND_MM_CASH_REPAY.REPAY_AMOUNT is '������';
comment on column FUND_MM_CASH_REPAY.REPAY_TIME is '��������';
comment on column FUND_MM_CASH_REPAY.REPAY_ADMIN is '�տ���';
comment on column FUND_MM_CASH_REPAY.REMARK is '��ע';
create index IDX_FUND_MM_CR_MM on FUND_MM_CASH_REPAY(MARKET_ADMIN);
create index IDX_FUND_MM_CR_DATE on FUND_MM_CASH_REPAY(REPAY_TIME);

create table ITEM_ITEMS(
	ITEM_CODE CHAR(8)  not null,
	ITEM_NAME VARCHAR2(4000)  not null,
	BASE_UNIT_NAME VARCHAR2(500)  not null,
	STATUS NUMBER(1) default 1 not null,
	constraint PK_ITEM_ITEMS primary Key (ITEM_CODE)
);
comment on table ITEM_ITEMS is '��Ʒ';
comment on column ITEM_ITEMS.ITEM_CODE is '��Ʒ���루IT123456��';
comment on column ITEM_ITEMS.ITEM_NAME is '��Ʒ����';
comment on column ITEM_ITEMS.BASE_UNIT_NAME is '��λ����';
comment on column ITEM_ITEMS.STATUS is '״̬��1-���ã�2-ɾ����';

create table ITEM_QUANTITY(
	ITEM_CODE CHAR(8)  not null,
	WAREHOUSE_CODE CHAR(4)  not null,
	ITEM_NAME VARCHAR2(4000)  not null,
	QUANTITY NUMBER(10)  not null,
	constraint PK_ITEM_QUANTITY primary Key (ITEM_CODE,WAREHOUSE_CODE)
);
comment on table ITEM_QUANTITY is '��Ʒ���';
comment on column ITEM_QUANTITY.ITEM_CODE is '��Ʒ���루IT123456��';
comment on column ITEM_QUANTITY.WAREHOUSE_CODE is '���ڲֿ�';
comment on column ITEM_QUANTITY.ITEM_NAME is '��Ʒ����';
comment on column ITEM_QUANTITY.QUANTITY is '��Ʒ����';

create table ITEM_RECEIPT(
	IR_NO CHAR(10)  not null,
	CREATE_ADMIN NUMBER(4)  ,
	RECEIVE_ORG CHAR(2)  ,
	RECEIVE_WH CHAR(4)  ,
	RECEIVE_DATE DATE  ,
	REMARK VARCHAR2(4000)  ,
	constraint PK_ITEM_RECEIPT primary Key (IR_NO)
);
comment on table ITEM_RECEIPT is '��Ʒ���';
comment on column ITEM_RECEIPT.IR_NO is '��ⵥ��ţ�IR12345678��';
comment on column ITEM_RECEIPT.CREATE_ADMIN is '������';
comment on column ITEM_RECEIPT.RECEIVE_ORG is '���ֿ�������λ';
comment on column ITEM_RECEIPT.RECEIVE_WH is '���ֿ�';
comment on column ITEM_RECEIPT.RECEIVE_DATE is '���ʱ��';
comment on column ITEM_RECEIPT.REMARK is '��ע';

create table ITEM_RECEIPT_DETAIL(
	IR_NO CHAR(10)  not null,
	ITEM_CODE CHAR(8)  ,
	QUANTITY NUMBER(10)  ,
	constraint PK_ITEM_RECEIPT_DETAIL primary Key (IR_NO,ITEM_CODE)
);
comment on table ITEM_RECEIPT_DETAIL is '��Ʒ�����ϸ';
comment on column ITEM_RECEIPT_DETAIL.IR_NO is '��ⵥ��ţ�IR12345678��';
comment on column ITEM_RECEIPT_DETAIL.ITEM_CODE is '��Ʒ���루IT123456��';
comment on column ITEM_RECEIPT_DETAIL.QUANTITY is '����';

create table ITEM_ISSUE(
	II_NO CHAR(10)  not null,
	OPER_ADMIN NUMBER(4)  not null,
	ISSUE_DATE DATE  ,
	RECEIVE_ORG CHAR(2)  ,
	SEND_ORG CHAR(2)  ,
	SEND_WH CHAR(4)  ,
	REMARK VARCHAR2(4000)  ,
	constraint PK_ITEM_ISSUE primary Key (II_NO)
);
comment on table ITEM_ISSUE is '��Ʒ����';
comment on column ITEM_ISSUE.II_NO is '���ⵥ��ţ�II12345678��';
comment on column ITEM_ISSUE.OPER_ADMIN is '������';
comment on column ITEM_ISSUE.ISSUE_DATE is '����ʱ��';
comment on column ITEM_ISSUE.RECEIVE_ORG is '�ջ���λ';
comment on column ITEM_ISSUE.SEND_ORG is '������λ';
comment on column ITEM_ISSUE.SEND_WH is '�����ֿ�';
comment on column ITEM_ISSUE.REMARK is '��ע';

create table ITEM_ISSUE_DETAIL(
	II_NO CHAR(10)  not null,
	ITEM_CODE CHAR(8)  ,
	QUANTITY NUMBER(10)  ,
	constraint PK_ITEM_ISSUE_DETAIL primary Key (II_NO,ITEM_CODE)
);
comment on table ITEM_ISSUE_DETAIL is '��Ʒ������ϸ';
comment on column ITEM_ISSUE_DETAIL.II_NO is '���ⵥ��ţ�II12345678��';
comment on column ITEM_ISSUE_DETAIL.ITEM_CODE is '��Ʒ���루IT123456��';
comment on column ITEM_ISSUE_DETAIL.QUANTITY is '����';

create table ITEM_CHECK(
	CHECK_NO CHAR(10)  not null,
	CHECK_NAME VARCHAR2(500)  ,
	CHECK_DATE DATE  ,
	CHECK_ADMIN NUMBER(4)  not null,
	CHECK_WAREHOUSE CHAR(4)  ,
	STATUS NUMBER(1)  not null,
	REMARK VARCHAR2(4000)  ,
	constraint PK_ITEM_CHECK primary Key (CHECK_NO)
);
comment on table ITEM_CHECK is '��Ʒ�̵�';
comment on column ITEM_CHECK.CHECK_NO is '�̵��ţ�IC12345678��';
comment on column ITEM_CHECK.CHECK_NAME is '�̵�����';
comment on column ITEM_CHECK.CHECK_DATE is '�̵�����';
comment on column ITEM_CHECK.CHECK_ADMIN is '������';
comment on column ITEM_CHECK.CHECK_WAREHOUSE is '�̵�ֿ�';
comment on column ITEM_CHECK.STATUS is '״̬��1-δ��ɣ�2-����ɣ�';
comment on column ITEM_CHECK.REMARK is '��ע';

create table ITEM_CHECK_DETAIL_BE(
	CHECK_NO CHAR(10)  not null,
	ITEM_CODE CHAR(8)  ,
	QUANTITY NUMBER(10)  ,
	constraint PK_ITEM_CHECK_DETAIL_BE primary Key (CHECK_NO,ITEM_CODE)
);
comment on table ITEM_CHECK_DETAIL_BE is '��Ʒ�̵�ǰ��ϸ';
comment on column ITEM_CHECK_DETAIL_BE.CHECK_NO is '�̵��ţ�IC12345678��';
comment on column ITEM_CHECK_DETAIL_BE.ITEM_CODE is '��Ʒ���루IT123456��';
comment on column ITEM_CHECK_DETAIL_BE.QUANTITY is '����';

create table ITEM_CHECK_DETAIL_AF(
	CHECK_NO CHAR(10)  not null,
	ITEM_CODE CHAR(8)  ,
	QUANTITY NUMBER(10)  ,
	CHANGE_QUANTITY NUMBER(10)  ,
	RESULT NUMBER(1)  not null,
	constraint PK_ITEM_CHECK_DETAIL_AF primary Key (CHECK_NO,ITEM_CODE)
);
comment on table ITEM_CHECK_DETAIL_AF is '��Ʒ�̵����ϸ';
comment on column ITEM_CHECK_DETAIL_AF.CHECK_NO is '�̵��ţ�IC12345678��';
comment on column ITEM_CHECK_DETAIL_AF.ITEM_CODE is '��Ʒ���루IT123456��';
comment on column ITEM_CHECK_DETAIL_AF.QUANTITY is '����';
comment on column ITEM_CHECK_DETAIL_AF.CHANGE_QUANTITY is '������';
comment on column ITEM_CHECK_DETAIL_AF.RESULT is '�̵�����1-һ�£�2-�̿���3-��ӯ��';

create table ITEM_DAMAGE(
	ID_NO CHAR(10)  not null,
	DAMAGE_DATE DATE  not null,
	WAREHOUSE_CODE CHAR(4)  not null,
	ITEM_CODE CHAR(8)  not null,
	QUANTITY NUMBER(10)  not null,
	CHECK_ADMIN NUMBER(4)  not null,
	REMARK VARCHAR2(2000)  ,
	constraint PK_ITEM_DAMAGE primary Key (ID_NO,ITEM_CODE)
);
comment on table ITEM_DAMAGE is '��Ʒ��ٵǼ�';
comment on column ITEM_DAMAGE.ID_NO is '��ٵǼǱ�ţ�ID12345678��';
comment on column ITEM_DAMAGE.DAMAGE_DATE is '�������';
comment on column ITEM_DAMAGE.WAREHOUSE_CODE is '�ֿ���';
comment on column ITEM_DAMAGE.ITEM_CODE is '��Ʒ���루IT123456��';
comment on column ITEM_DAMAGE.QUANTITY is '��� ����';
comment on column ITEM_DAMAGE.CHECK_ADMIN is '������';
comment on column ITEM_DAMAGE.REMARK is '��ע';

create table HIS_LOTTERY_INVENTORY(
	CALC_DATE VARCHAR2(10)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	REWARD_GROUP NUMBER(2)  not null,
	STATUS NUMBER(2) default 1 not null,
	WAREHOUSE VARCHAR2(8)  ,
	TICKETS NUMBER(28)  not null,
	AMOUNT NUMBER(28)  not null,
	constraint PK_HIS_LOTTERY_INVENTORY primary Key (CALC_DATE,PLAN_CODE,BATCH_NO,REWARD_GROUP,STATUS, WAREHOUSE)
);
comment on table HIS_LOTTERY_INVENTORY is '�����ʷ';
comment on column HIS_LOTTERY_INVENTORY.CALC_DATE is 'ͳ������';
comment on column HIS_LOTTERY_INVENTORY.PLAN_CODE is '����';
comment on column HIS_LOTTERY_INVENTORY.BATCH_NO is '����';
comment on column HIS_LOTTERY_INVENTORY.REWARD_GROUP is '����';
comment on column HIS_LOTTERY_INVENTORY.STATUS is '״̬��11-�ڿ⡢12-��վ�㣬20-��;��21-����Ա���У�31-�����ۡ�41-������42-�𻵡�43-��ʧ��';
comment on column HIS_LOTTERY_INVENTORY.WAREHOUSE is '���ڲֿ�';
comment on column HIS_LOTTERY_INVENTORY.TICKETS is 'Ʊ����';
comment on column HIS_LOTTERY_INVENTORY.AMOUNT is '���';

create table HIS_AGENCY_FUND(
	CALC_DATE VARCHAR2(10)  not null,
	AGENCY_CODE CHAR(8)  not null,
	FLOW_TYPE NUMBER(2)  not null,
	AMOUNT NUMBER(28)  not null,
	BE_ACCOUNT_BALANCE NUMBER(28) default 1 not null,
	AF_ACCOUNT_BALANCE NUMBER(28)  not null,
	constraint PK_HIS_AGENCY_FUND primary Key (CALC_DATE,AGENCY_CODE,FLOW_TYPE)
);
comment on table HIS_AGENCY_FUND is 'վ���ʽ���ʷ';
comment on column HIS_AGENCY_FUND.CALC_DATE is 'ͳ������';
comment on column HIS_AGENCY_FUND.AGENCY_CODE is '����վ��';
comment on column HIS_AGENCY_FUND.FLOW_TYPE is '�ʽ����ͣ�1-��ֵ��2-���֣�5-����Ӷ��6-�ҽ�Ӷ��7-���ۣ�8-�ҽ���11-վ���˻���13-����Ӷ��0-��������ʾ�����ڳ�����ĩ��';
comment on column HIS_AGENCY_FUND.AMOUNT is '�������';
comment on column HIS_AGENCY_FUND.BE_ACCOUNT_BALANCE is '�ڳ����';
comment on column HIS_AGENCY_FUND.AF_ACCOUNT_BALANCE is '��ĩ���';
create index IDX_HIS_AGENCY_FUND_CALC on HIS_AGENCY_FUND(CALC_DATE);

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

create table HIS_MM_INVENTORY(
	CALC_DATE VARCHAR2(10)  not null,
	MARKET_ADMIN NUMBER(4)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	OPEN_INV NUMBER(28)  not null,
	CLOSE_INV NUMBER(28)  not null,
	GOT_TICKETS NUMBER(28)  not null,
	SALED_TICKETS NUMBER(28)  not null,
	CANCELED_TICKETS NUMBER(28)  not null,
	RETURN_TICKETS NUMBER(28)  not null,
	BROKEN_TICKETS NUMBER(28)  not null,
	constraint PK_HIS_MM_INVENTORY primary Key (CALC_DATE,MARKET_ADMIN,PLAN_CODE)
);
comment on table HIS_MM_INVENTORY is '�г�����Ա�����ʷ';
comment on column HIS_MM_INVENTORY.CALC_DATE is 'ͳ������';
comment on column HIS_MM_INVENTORY.MARKET_ADMIN is '�г�����Ա';
comment on column HIS_MM_INVENTORY.PLAN_CODE is '����';
comment on column HIS_MM_INVENTORY.OPEN_INV is '�ڳ����';
comment on column HIS_MM_INVENTORY.CLOSE_INV is '��ĩ���';
comment on column HIS_MM_INVENTORY.GOT_TICKETS is '�ջ�����';
comment on column HIS_MM_INVENTORY.SALED_TICKETS is '��������';
comment on column HIS_MM_INVENTORY.CANCELED_TICKETS is '�˻�����';
comment on column HIS_MM_INVENTORY.RETURN_TICKETS is '��������';
comment on column HIS_MM_INVENTORY.BROKEN_TICKETS is '�������';
create index IDX_HIS_MM_INV_CALC on HIS_MM_INVENTORY(CALC_DATE);
create index IDX_HIS_MM_INV_MM_FLOW on HIS_MM_INVENTORY(MARKET_ADMIN,PLAN_CODE);

create table HIS_ORG_FUND_REPORT(
	CALC_DATE VARCHAR2(10)  not null,
	ORG_CODE CHAR(2)  not null,
	BE_ACCOUNT_BALANCE NUMBER(28) default 0 not null,
	CHARGE NUMBER(28) default 0 not null,
	WITHDRAW NUMBER(28) default 0 not null,
	SALE NUMBER(28) default 0 not null,
	SALE_COMM NUMBER(28) default 0 not null,
	PAID NUMBER(28) default 0 not null,
	PAY_COMM NUMBER(28) default 0 not null,
	RTV NUMBER(28) default 0 not null,
	RTV_COMM NUMBER(28) default 0 not null,
	AF_ACCOUNT_BALANCE NUMBER(28) default 0 not null,
	INCOMING NUMBER(28) default 0 not null,
	PAY_UP NUMBER(28) default 0 not null,
	CENTER_PAY NUMBER(28) default 0 not null,
	CENTER_PAY_COMM NUMBER(28) default 0 not null,
	constraint PK_HIS_ORG_FUND_REPORT primary Key (CALC_DATE,ORG_CODE)
);
comment on table HIS_ORG_FUND_REPORT is '��������Ͻ����վ����ʷ����';
comment on column HIS_ORG_FUND_REPORT.CALC_DATE is 'ͳ������';
comment on column HIS_ORG_FUND_REPORT.ORG_CODE is '���ű���';
comment on column HIS_ORG_FUND_REPORT.BE_ACCOUNT_BALANCE is '�ڳ����';
comment on column HIS_ORG_FUND_REPORT.CHARGE is '��ֵ';
comment on column HIS_ORG_FUND_REPORT.WITHDRAW is '����';
comment on column HIS_ORG_FUND_REPORT.SALE is '����';
comment on column HIS_ORG_FUND_REPORT.SALE_COMM is '����Ӷ��';
comment on column HIS_ORG_FUND_REPORT.PAID is '�ҽ�';
comment on column HIS_ORG_FUND_REPORT.PAY_COMM is '�ҽ�Ӷ��';
comment on column HIS_ORG_FUND_REPORT.RTV is 'վ���˻�';
comment on column HIS_ORG_FUND_REPORT.RTV_COMM is '�˻�Ӷ��';
comment on column HIS_ORG_FUND_REPORT.AF_ACCOUNT_BALANCE is '��ĩ���';
comment on column HIS_ORG_FUND_REPORT.INCOMING is '����';
comment on column HIS_ORG_FUND_REPORT.PAY_UP is 'Ӧ���ֽ�';
comment on column HIS_ORG_FUND_REPORT.CENTER_PAY is '���Ķҽ�';
comment on column HIS_ORG_FUND_REPORT.CENTER_PAY_COMM is '���Ķҽ�Ӷ��';
create index IDX_HIS_ORG_FUND_CALC on HIS_ORG_FUND_REPORT(CALC_DATE);

create table HIS_ORG_FUND(
	CALC_DATE VARCHAR2(10)  not null,
	ORG_CODE CHAR(2)  not null,
	CHARGE NUMBER(28) default 0 not null,
	WITHDRAW NUMBER(28) default 0 not null,
	CENTER_PAID NUMBER(28) default 0 not null,
	CENTER_PAID_COMM NUMBER(28) default 0 not null,
	PAY_UP NUMBER(28) default 0 not null,
	constraint PK_HIS_ORG_FUND primary Key (CALC_DATE,ORG_CODE)
);
comment on table HIS_ORG_FUND is '�����ʽ���ʷ����';
comment on column HIS_ORG_FUND.CALC_DATE is 'ͳ������';
comment on column HIS_ORG_FUND.ORG_CODE is '���ű���';
comment on column HIS_ORG_FUND.CHARGE is '��ֵ';
comment on column HIS_ORG_FUND.WITHDRAW is '����';
comment on column HIS_ORG_FUND.CENTER_PAID is '���Ķҽ�';
comment on column HIS_ORG_FUND.CENTER_PAID_COMM is '���Ķҽ�Ӷ��';
comment on column HIS_ORG_FUND.PAY_UP is 'Ӧ���ֽ�';
create index IDX_HIS_ORG_FUND_DATE on HIS_ORG_FUND(CALC_DATE);

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

create table HIS_SALE_ORG(
	CALC_DATE VARCHAR2(10)  not null,
	ORG_CODE CHAR(2)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	SALE_AMOUNT NUMBER(28) default 0 not null,
	SALE_COMM NUMBER(28) default 0 not null,
	CANCEL_AMOUNT NUMBER(28) default 0 not null,
	CANCEL_COMM NUMBER(28) default 0 not null,
	PAID_AMOUNT NUMBER(28) default 0 not null,
	PAID_COMM NUMBER(28) default 0 not null,
	INCOMING NUMBER(28) default 0 not null,
	constraint PK_HIS_SALE_ORG primary Key (CALC_DATE,PLAN_CODE,ORG_CODE)
);
comment on table HIS_SALE_ORG is '���������ż��';
comment on column HIS_SALE_ORG.CALC_DATE is 'ͳ������';
comment on column HIS_SALE_ORG.ORG_CODE is '���ű���';
comment on column HIS_SALE_ORG.PLAN_CODE is '��������';
comment on column HIS_SALE_ORG.SALE_AMOUNT is '���۽��';
comment on column HIS_SALE_ORG.SALE_COMM is '����Ӷ��';
comment on column HIS_SALE_ORG.CANCEL_AMOUNT is '��Ʊ���';
comment on column HIS_SALE_ORG.CANCEL_COMM is '��ƱӶ��';
comment on column HIS_SALE_ORG.PAID_AMOUNT is '��������վ�ҽ����';
comment on column HIS_SALE_ORG.PAID_COMM is '��������վ�ҽ�Ӷ��';
comment on column HIS_SALE_ORG.INCOMING is '��������';

create table HIS_AGENT_FUND_REPORT(
	CALC_DATE VARCHAR2(10)  not null,
	ORG_CODE CHAR(2)  not null,
	FLOW_TYPE NUMBER(2)  not null,
	AMOUNT NUMBER(28)  not null,
	constraint PK_HIS_AGENT_FUND_REPORT primary Key (CALC_DATE,ORG_CODE,FLOW_TYPE)
);
comment on table HIS_AGENT_FUND_REPORT is '�������ʽ𱨱�';
comment on column HIS_AGENT_FUND_REPORT.CALC_DATE is 'ͳ������';
comment on column HIS_AGENT_FUND_REPORT.ORG_CODE is '������';
comment on column HIS_AGENT_FUND_REPORT.FLOW_TYPE is '�ʽ����ͣ�1-��ֵ��2-���֣�5-����Ӷ��6-�ҽ�Ӷ��7-���ۣ�8-�ҽ���11-վ���˻���13-����Ӷ�𣬣�';
comment on column HIS_AGENT_FUND_REPORT.AMOUNT is '�������';
create index IDX_HIS_AGENCT_FUND_CALC on HIS_AGENT_FUND_REPORT(CALC_DATE);

create table HIS_SALE_HOUR(
	CALC_DATE VARCHAR2(10)  not null,
	CALC_TIME NUMBER(10)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	ORG_CODE CHAR(2)  not null,
	SALE_AMOUNT NUMBER(28) default 0 not null,
	CANCEL_AMOUNT NUMBER(28) default 0 not null,
	PAY_AMOUNT NUMBER(28) default 0 not null,
	DAY_SALE_AMOUNT NUMBER(28) default 0 not null,
	DAY_CANCEL_AMOUNT NUMBER(28) default 0 not null,
	DAY_PAY_AMOUNT NUMBER(28) default 0 not null,
	constraint PK_HIS_SALE_HOUR primary Key (CALC_DATE,CALC_TIME,PLAN_CODE,ORG_CODE)
);
comment on table HIS_SALE_HOUR is '������ʱ��μ��';
comment on column HIS_SALE_HOUR.CALC_DATE is 'ͳ������';
comment on column HIS_SALE_HOUR.CALC_TIME is 'ͳ��ʱ�䣨24Сʱ��';
comment on column HIS_SALE_HOUR.PLAN_CODE is '��������';
comment on column HIS_SALE_HOUR.ORG_CODE is '���ű���';
comment on column HIS_SALE_HOUR.SALE_AMOUNT is '���۽��';
comment on column HIS_SALE_HOUR.CANCEL_AMOUNT is '��Ʊ���';
comment on column HIS_SALE_HOUR.PAY_AMOUNT is '�ҽ����';
comment on column HIS_SALE_HOUR.DAY_SALE_AMOUNT is '���ۼ����۽��';
comment on column HIS_SALE_HOUR.DAY_CANCEL_AMOUNT is '���ۼ���Ʊ���';
comment on column HIS_SALE_HOUR.DAY_PAY_AMOUNT is '���ۼƶҽ����';

create table HIS_SALE_HOUR_AGENCY(
	CALC_DATE VARCHAR2(10)  not null,
	CALC_TIME NUMBER(10)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	AGENCY_CODE CHAR(8)  not null,
	AREA_CODE CHAR(4)  not null,
	SALE_AMOUNT NUMBER(28) default 0 not null,
	CANCEL_AMOUNT NUMBER(28) default 0 not null,
	PAY_AMOUNT NUMBER(28) default 0 not null,
	DAY_SALE_AMOUNT NUMBER(28) default 0 not null,
	DAY_CANCEL_AMOUNT NUMBER(28) default 0 not null,
	DAY_PAY_AMOUNT NUMBER(28) default 0 not null,
	constraint PK_HIS_SALE_HOUR_AGENCY primary Key (CALC_DATE,CALC_TIME,PLAN_CODE,AGENCY_CODE)
);
comment on table HIS_SALE_HOUR_AGENCY is '������ʱ��μ��֮����վ����';
comment on column HIS_SALE_HOUR_AGENCY.CALC_DATE is 'ͳ������';
comment on column HIS_SALE_HOUR_AGENCY.CALC_TIME is 'ͳ��ʱ�䣨24Сʱ��';
comment on column HIS_SALE_HOUR_AGENCY.PLAN_CODE is '��������';
comment on column HIS_SALE_HOUR_AGENCY.AGENCY_CODE is '����վ����';
comment on column HIS_SALE_HOUR_AGENCY.AREA_CODE is '�����������';
comment on column HIS_SALE_HOUR_AGENCY.SALE_AMOUNT is '���۽��';
comment on column HIS_SALE_HOUR_AGENCY.CANCEL_AMOUNT is '��Ʊ���';
comment on column HIS_SALE_HOUR_AGENCY.PAY_AMOUNT is '�ҽ����';
comment on column HIS_SALE_HOUR_AGENCY.DAY_SALE_AMOUNT is '���ۼ����۽��';
comment on column HIS_SALE_HOUR_AGENCY.DAY_CANCEL_AMOUNT is '���ۼ���Ʊ���';
comment on column HIS_SALE_HOUR_AGENCY.DAY_PAY_AMOUNT is '���ۼƶҽ����';

create table HIS_DIM_DWM(
	D_YEAR CHAR(4)  not null,
	D_MONTH CHAR(7)  not null,
	D_WEEK CHAR(2)  not null,
	D_DAY CHAR(10)  not null,
	constraint PK_HIS_DIM_DM primary Key (D_YEAR,D_MONTH,D_DAY)
);
comment on table HIS_DIM_DWM is '����ά��';
comment on column HIS_DIM_DWM.D_YEAR is '��ά��';
comment on column HIS_DIM_DWM.D_MONTH is '��ά��';
comment on column HIS_DIM_DWM.D_WEEK is '��ά��';
comment on column HIS_DIM_DWM.D_DAY is '��ά��';

create table HIS_SALE_PAY_CANCEL(
	SALE_DATE VARCHAR2(10)  not null,
	SALE_MONTH VARCHAR2(10)  not null,
	AREA_CODE CHAR(4)  ,
	ORG_CODE CHAR(2)  not null,
	PLAN_CODE VARCHAR2(4000)  not null,
	SALE_AMOUNT NUMBER(28)  ,
	SALE_COMM NUMBER(28)  ,
	CANCEL_AMOUNT NUMBER(28)  ,
	CANCEL_COMM NUMBER(28)  ,
	PAY_AMOUNT NUMBER(28)  ,
	PAY_COMM NUMBER(28)  ,
	INCOMING NUMBER(28)  ,
	constraint PK_HIS_SALE_PAY_CANCEL primary Key (SALE_DATE,SALE_MONTH,AREA_CODE,ORG_CODE,PLAN_CODE)
);
comment on table HIS_SALE_PAY_CANCEL is '�����۶ҽ���Ʊͳ��';
comment on column HIS_SALE_PAY_CANCEL.SALE_DATE is 'ͳ������';
comment on column HIS_SALE_PAY_CANCEL.SALE_MONTH is 'ͳ���·�';
comment on column HIS_SALE_PAY_CANCEL.AREA_CODE is '�������';
comment on column HIS_SALE_PAY_CANCEL.ORG_CODE is '���ű���';
comment on column HIS_SALE_PAY_CANCEL.PLAN_CODE is '�������루����������ƣ�';
comment on column HIS_SALE_PAY_CANCEL.SALE_AMOUNT is '���۽��';
comment on column HIS_SALE_PAY_CANCEL.SALE_COMM is '����Ӷ��';
comment on column HIS_SALE_PAY_CANCEL.CANCEL_AMOUNT is '�˻����';
comment on column HIS_SALE_PAY_CANCEL.CANCEL_COMM is '�˻�Ӷ��';
comment on column HIS_SALE_PAY_CANCEL.PAY_AMOUNT is '�ҽ����';
comment on column HIS_SALE_PAY_CANCEL.PAY_COMM is '�ҽ�Ӷ��';
comment on column HIS_SALE_PAY_CANCEL.INCOMING is '����';

create table HIS_PAY_LEVEL(
	SALE_DATE VARCHAR2(10)  not null,
	SALE_MONTH VARCHAR2(10)  not null,
	ORG_CODE CHAR(2)  not null,
	PLAN_CODE VARCHAR2(4000)  not null,
	LEVEL_1 NUMBER(28)  ,
	LEVEL_2 NUMBER(28)  ,
	LEVEL_3 NUMBER(28)  ,
	LEVEL_4 NUMBER(28)  ,
	LEVEL_5 NUMBER(28)  ,
	LEVEL_6 NUMBER(28)  ,
	LEVEL_7 NUMBER(28)  ,
	LEVEL_8 NUMBER(28)  ,
	LEVEL_9 NUMBER(28)  ,
	LEVEL_10 NUMBER(28)  ,
	TOTAL NUMBER(28)  ,
	constraint PK_HIS_PAY_LEVEL primary Key (SALE_DATE,SALE_MONTH,ORG_CODE,PLAN_CODE)
);
comment on table HIS_PAY_LEVEL is '�նҽ�������ͳ��';
comment on column HIS_PAY_LEVEL.SALE_DATE is 'ͳ������';
comment on column HIS_PAY_LEVEL.SALE_MONTH is 'ͳ���·�';
comment on column HIS_PAY_LEVEL.ORG_CODE is '���ű���';
comment on column HIS_PAY_LEVEL.PLAN_CODE is '�������루����������ƣ�';
comment on column HIS_PAY_LEVEL.LEVEL_1 is 'һ�Ƚ�����';
comment on column HIS_PAY_LEVEL.LEVEL_2 is '���Ƚ�����';
comment on column HIS_PAY_LEVEL.LEVEL_3 is '���Ƚ�����';
comment on column HIS_PAY_LEVEL.LEVEL_4 is '�ĵȽ�����';
comment on column HIS_PAY_LEVEL.LEVEL_5 is '��Ƚ�����';
comment on column HIS_PAY_LEVEL.LEVEL_6 is '���Ƚ�����';
comment on column HIS_PAY_LEVEL.LEVEL_7 is '�ߵȽ�����';
comment on column HIS_PAY_LEVEL.LEVEL_8 is '�˵Ƚ�����';
comment on column HIS_PAY_LEVEL.LEVEL_9 is '�ŵȽ�����';
comment on column HIS_PAY_LEVEL.LEVEL_10 is 'ʮ�Ƚ�����';
comment on column HIS_PAY_LEVEL.TOTAL is '����';
create index IDX_HIS_PAY_LEVEL_DAY on HIS_PAY_LEVEL(SALE_DATE);
