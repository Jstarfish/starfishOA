use KPW;
go

set ansi_nulls on
go

set quoted_identifier on
go

drop schema tkws;
go

create schema tkws;
go

create table tkws.ADM_INFO(
	ADMIN_ID numeric(4)  not null,
	ADMIN_REALNAME NVARCHAR(1000)  not null,
	ADMIN_LOGIN NVARCHAR(32)  not null,
	ADMIN_PASSWORD CHAR(32)  not null,
	ADMIN_GENDER numeric(1)  not null,
	ADMIN_EMAIL NVARCHAR(100)  ,
	ADMIN_BIRTHDAY DATETIME  ,
	ADMIN_TEL NVARCHAR(50)  ,
	ADMIN_MOBILE NVARCHAR(50)  ,
	ADMIN_PHONE NVARCHAR(50)  ,
	ADMIN_ORG CHAR(2)  ,
	ADMIN_ADDRESS NVARCHAR(4000)  ,
	ADMIN_REMARK NVARCHAR(4000)  ,
	ADMIN_STATUS numeric(1) default 1 not null,
	ADMIN_CREATE_TIME DATETIME ,
	ADMIN_UPDATE_TIME DATETIME ,
	ADMIN_LOGIN_TIME DATETIME ,
	ADMIN_LOGIN_COUNT numeric(10) default 0 ,
	ADMIN_AGREEDAY NVARCHAR(7)  ,
	ADMIN_LOGIN_BEGIN NVARCHAR(15)  ,
	ADMIN_LOGIN_END NVARCHAR(15)  ,
	CREATE_ADMIN_ID numeric(4) default 0 ,
	ADMIN_IP_LIMIT NVARCHAR(200)  ,
	LOGIN_STATUS numeric(1) default 0 not null,
	IS_COLLECTER numeric(1) default 0 not null,
	IS_WAREHOUSE_M numeric(1) default 0 not null,
	constraint PK_ADM_INFO primary Key (ADMIN_ID)
);
create table tkws.ADM_ROLE(
	ROLE_ID numeric(4) default 0 not null,
	ROLE_NAME NVARCHAR(1000)  not null,
	IS_ACTIVE numeric(1) default 0 not null,
	ROLE_COMMENT NVARCHAR(4000)  ,
	ROLE_CODE NVARCHAR(50)  ,
	constraint PK_ADM_ROLE primary Key (ROLE_ID)
);
create table tkws.ADM_ROLE_ADMIN(
	ADMIN_ID numeric(4)  not null,
	ROLE_ID numeric(4)  not null,
	constraint PK_ADM_ROLE_ADMIN primary Key (ADMIN_ID,ROLE_ID)
);
create table tkws.ADM_PRIVILEGE(
	PRIVILEGE_ID numeric(6)  not null,
	PRIVILEGE_NAME NVARCHAR(1000)  not null,
	PRIVILEGE_CODE NVARCHAR(500)  not null,
	PRIVILEGE_SYSTEM numeric(1)  not null,
	PRIVILEGE_IS_CENTER numeric(1)  ,
	PRIVILEGE_AGREEDAY NVARCHAR(7)  ,
	PRIVILEGE_LOGINBEGIN NVARCHAR(10)  ,
	PRIVILEGE_LOGINEND NVARCHAR(10)  ,
	PRIVILEGE_REMARK NVARCHAR(4000)  ,
	PRIVILEGE_URL NVARCHAR(200)  ,
	PRIVILEGE_PARENT numeric(8) default 0 ,
	PRIVILEGE_LEVEL numeric(8) default 0 ,
	PRIVILEGE_ORDER numeric(2) default 0 ,
	constraint PK_ADM_PRIVILEGE primary Key (PRIVILEGE_ID)
);
create table tkws.ADM_ROLE_PRIVILEGE(
	ROLE_ID numeric(4)  not null,
	PRIVILEGE_ID numeric(6)  not null,
	constraint PK_ADM_ROLE_PRIVILEGE primary Key (ROLE_ID,PRIVILEGE_ID)
);
create table tkws.INF_AREAS(
	AREA_CODE CHAR(4)  not null,
	AREA_NAME NVARCHAR(500)  not null,
	SUPER_AREA CHAR(4)  not null,
	STATUS numeric(1)  not null,
	AREA_TYPE numeric(1)  not null,
	constraint PK_INF_AREAS primary Key (AREA_CODE)
);
create table tkws.INF_ORGS(
	ORG_CODE CHAR(2)  not null,
	ORG_NAME NVARCHAR(4000)  not null,
	ORG_TYPE numeric(1)  not null,
	ORG_STATUS numeric(1)  not null,
	SUPER_ORG CHAR(2)  not null,
	PHONE NVARCHAR(100)  ,
	DIRECTOR_ADMIN numeric(4)  ,
	PERSONS numeric(6) default 0 not null,
	ADDRESS NVARCHAR(4000)  ,
	constraint PK_INF_ORGS primary Key (ORG_CODE)
);
create table tkws.INF_ORG_AREA(
	ORG_CODE CHAR(2)  not null,
	AREA_CODE CHAR(4)  not null,
	constraint PK_INF_ORG_AREA primary Key (ORG_CODE,AREA_CODE)
);
create table tkws.INF_AGENCYS(
	AGENCY_CODE CHAR(8)  not null,
	AGENCY_NAME NVARCHAR(1000)  not null,
	STORETYPE_ID numeric(2)  not null,
	STATUS numeric(1)  not null,
	AGENCY_TYPE numeric(1) default 1 not null,
	BANK_ID numeric(4)  ,
	BANK_ACCOUNT NVARCHAR(32)  ,
	TELEPHONE NVARCHAR(100)  ,
	CONTACT_PERSON NVARCHAR(500)  ,
	ADDRESS NVARCHAR(4000)  ,
	AGENCY_ADD_TIME DATETIME ,
	QUIT_TIME DATETIME  ,
	ORG_CODE CHAR(2)  not null,
	AREA_CODE CHAR(4)  not null,
	LOGIN_PASS NVARCHAR(32)  ,
	TRADE_PASS NVARCHAR(32)  ,
	MARKET_MANAGER_ID numeric(4)  ,
	constraint PK_INF_AGENCYS primary Key (AGENCY_CODE)
);
create table tkws.INF_AGENCY_EXT(
	AGENCY_CODE CHAR(8)  not null,
	PERSONAL_ID NVARCHAR(100)  ,
	CONTRACT_NO NVARCHAR(100)  ,
	GLATLNG_N NVARCHAR(20)  ,
	GLATLNG_E NVARCHAR(20)  ,
	constraint PK_INF_AGENCY_EXT primary Key (AGENCY_CODE)
);
create table tkws.INF_AGENCY_DELETE(
	DELETE_NO CHAR(10)  not null,
	AGENCY_CODE CHAR(8)  not null,
	AGENCY_NAME NVARCHAR(1000)  ,
	AVAILABLE_CREDIT numeric(28)  not null,
	TEMP_CREDIT numeric(28)  not null,
	MARGINAL_CREDIT numeric(28)  not null,
	OPER_TIME DATETIME not null,
	OPER_ADMIN numeric(4)  not null,
	constraint PK_INF_AGENCY_DELETE primary Key (DELETE_NO)
);
create table tkws.INF_MARKET_ADMIN(
	MARKET_ADMIN numeric(4)  ,
	TRANS_PASS NVARCHAR(32)  ,
	CREDIT_BY_TRAN numeric(28)  ,
	MAX_AMOUNT_TICKETSS numeric(28)  ,
	constraint PK_INF_MARKET_ADMIN primary Key (MARKET_ADMIN)
);
create table tkws.INF_BANKS(
	BANK_ID numeric(4)  not null,
	BANK_NAME NVARCHAR(200)  ,
	constraint PK_INF_BANKS primary Key (BANK_ID)
);
create table tkws.INF_STORETYPES(
	STORETYPE_ID numeric(2)  not null,
	STORETYPE_NAME NVARCHAR(4000)  not null,
	IS_VALID numeric(1)  not null,
	constraint PK_INF_STORETYPES primary Key (STORETYPE_ID)
);
create table tkws.INF_PUBLISHERS(
	PUBLISHER_CODE numeric(2)  not null,
	PUBLISHER_NAME NVARCHAR(500)  not null,
	IS_VALID numeric(1) default 1 not null,
	PLAN_FLOW numeric(1)  ,
	constraint PK_INF_PUBLISHERS primary Key (PUBLISHER_CODE)
);
create table tkws.INF_TERMINAL(
	TERMINAL_CODE CHAR(8)  not null,
	TERM_IDENTITY_CODE NVARCHAR(100)  ,
	constraint PK_INF_TERMINAL primary Key (TERMINAL_CODE)
);
create table tkws.INF_TELLERS(
	TELLER_CODE numeric(8)  not null,
	AGENCY_CODE CHAR(8)  not null,
	TELLER_NAME NVARCHAR(1000)  ,
	TELLER_TYPE numeric(1)  not null,
	STATUS numeric(1)  ,
	PASSWORD NVARCHAR(32)  ,
	LATEST_TERMINAL_CODE CHAR(10)  ,
	LATEST_SIGN_ON_TIME DATETIME ,
	LATEST_SIGN_OFF_TIME DATETIME ,
	IS_ONLINE numeric(1)  ,
	constraint PK_INF_TELLER primary Key (TELLER_CODE)
);
create table tkws.ACC_ORG_ACCOUNT(
	ORG_CODE CHAR(2)  not null,
	ACC_TYPE numeric(1) default 1 not null,
	ACC_NAME NVARCHAR(4000)  not null,
	ACC_STATUS numeric(1)  not null,
	ACC_NO CHAR(12)  not null,
	CREDIT_LIMIT numeric(28) default 0 not null,
	ACCOUNT_BALANCE numeric(28) default 0 not null,
	FROZEN_BALANCE numeric(28) default 0 not null,
	CHECK_CODE NVARCHAR(40)  not null,
	constraint PK_ACC_ORG_ACCOUNT primary Key (ACC_NO)
);
create table tkws.ACC_AGENCY_ACCOUNT(
	AGENCY_CODE CHAR(8)  not null,
	ACC_TYPE numeric(1) default 1 not null,
	ACC_NAME NVARCHAR(4000)  not null,
	ACC_STATUS numeric(1)  not null,
	ACC_NO CHAR(12)  not null,
	CREDIT_LIMIT numeric(28) default 0 not null,
	ACCOUNT_BALANCE numeric(28) default 0 not null,
	FROZEN_BALANCE numeric(28) default 0 not null,
	CHECK_CODE NVARCHAR(40)  not null,
	constraint PK_ACC_AGENCY_ACCOUNT primary Key (ACC_NO)
);
create table tkws.ACC_MM_ACCOUNT(
	MARKET_ADMIN numeric(4)  not null,
	ACC_TYPE numeric(1) default 1 not null,
	ACC_NAME NVARCHAR(4000)  not null,
	ACC_STATUS numeric(1)  not null,
	ACC_NO CHAR(12)  not null,
	CREDIT_LIMIT numeric(28) default 0 not null,
	ACCOUNT_BALANCE numeric(28) default 0 not null,
	CHECK_CODE NVARCHAR(40)  not null,
	constraint PK_ACC_MM_ACCOUNT primary Key (ACC_NO)
);
create table tkws.ACC_MM_TICKETS(
	MARKET_ADMIN numeric(4)  ,
	PLAN_CODE NVARCHAR(10)  ,
	BATCH_NO NVARCHAR(10)  not null,
	TICKETS numeric(20)  ,
	AMOUNT numeric(28)  ,
	constraint PK_ACC_MM_TICKETS primary Key (MARKET_ADMIN,PLAN_CODE,BATCH_NO)
);
create table tkws.GAME_PLANS(
	PLAN_CODE NVARCHAR(10)  not null,
	FULL_NAME NVARCHAR(4000)  not null,
	SHORT_NAME NVARCHAR(4000)  not null,
	TICKET_AMOUNT numeric(10) default 0 not null,
	PUBLISHER_CODE numeric(2)  not null,
	LOTTERY_TYPE numeric(1) default 1 not null,
	constraint PK_GAME_PLANS primary Key (PLAN_CODE)
);
create table tkws.GAME_ORG_COMM_RATE(
	ORG_CODE CHAR(2)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	SALE_COMM numeric(8)  not null,
	PAY_COMM numeric(8)  not null,
	constraint PK_GAME_ORG_COMM_RATE primary Key (ORG_CODE,PLAN_CODE)
);
create table tkws.GAME_AGENCY_COMM_RATE(
	AGENCY_CODE CHAR(8)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	SALE_COMM numeric(8)  not null,
	PAY_COMM numeric(8)  not null,
	constraint PK_GAME_AGENCY_COMM_RATE primary Key (AGENCY_CODE,PLAN_CODE)
);
create table tkws.GAME_BATCH_IMPORT(
	IMPORT_NO CHAR(12)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	PACKAGE_FILE NVARCHAR(500)  not null,
	REWARD_MAP_FILE NVARCHAR(500)  not null,
	REWARD_DETAIL_FILE NVARCHAR(500)  not null,
	START_DATE DATETIME ,
	END_DATE DATETIME ,
	IMPORT_ADMIN numeric(4)  not null,
	constraint PK_GAME_BATCH_IMPORT primary Key (IMPORT_NO)
);
create table tkws.GAME_BATCH_IMPORT_DETAIL(
	IMPORT_NO CHAR(12)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	LOTTERY_TYPE NVARCHAR(500)  not null,
	LOTTERY_NAME NVARCHAR(500)  not null,
	BOXES_EVERY_TRUNK numeric(10)  not null,
	TRUNKS_EVERY_GROUP numeric(10)  not null,
	PACKS_EVERY_TRUNK numeric(10)  not null,
	TICKETS_EVERY_PACK numeric(10)  not null,
	TICKETS_EVERY_GROUP numeric(18)  not null,
	FIRST_REWARD_GROUP_NO numeric(10)  not null,
	TICKETS_EVERY_BATCH numeric(18)  not null,
	FIRST_TRUNK_BATCH numeric(18)  not null,
	STATUS numeric(1)  not null,
	constraint PK_GAME_BATCH_IMPORT_DETAIL primary Key (IMPORT_NO)
);
create table tkws.GAME_BATCH_IMPORT_REWARD(
	IMPORT_NO CHAR(12)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	REWARD_NO numeric(3)  not null,
	FAST_IDENTITY_CODE NVARCHAR(4000)  not null,
	SINGLE_REWARD_AMOUNT numeric(18)  not null,
	COUNTS numeric(18)  not null,
	constraint PK_GAME_BATCH_IMPORT_REWARD primary Key (IMPORT_NO,REWARD_NO)
);
create table tkws.GAME_BATCH_REWARD_DETAIL(
	IMPORT_NO CHAR(12)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	SAFE_CODE NVARCHAR(50)  not null,
	IS_PAID numeric(1) default 0 not null,
  pre_safe_code NVARCHAR(16)  not null,
	constraint PK_GAME_BATCH_REWARD_DETAIL primary Key (IMPORT_NO,PLAN_CODE,BATCH_NO,SAFE_CODE)
);
create table tkws.WH_INFO(
	WAREHOUSE_CODE CHAR(4)  not null,
	WAREHOUSE_NAME NVARCHAR(4000)  not null,
	ORG_CODE CHAR(2)  not null,
	ADDRESS NVARCHAR(4000)  not null,
	PHONE NVARCHAR(100)  not null,
	DIRECTOR_ADMIN numeric(4)  not null,
	STATUS numeric(1)  not null,
	CREATE_ADMIN numeric(4)  not null,
	CREATE_DATE DATETIME  not null,
	STOP_ADMIN numeric(4)  ,
	STOP_DATE DATETIME  ,
	constraint PK_WH_INFO primary Key (WAREHOUSE_CODE)
);
create table tkws.WH_MANAGER(
	WAREHOUSE_CODE CHAR(4)  not null,
	ORG_CODE CHAR(2)  not null,
	MANAGER_ID numeric(4)  not null,
	IS_VALID numeric(1)  not null,
	START_TIME DATETIME  ,
	END_TIME DATETIME  ,
	constraint PK_WH_MANAGER primary Key (WAREHOUSE_CODE,MANAGER_ID)
);
create table tkws.WH_TICKET_TRUNK(
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	REWARD_GROUP numeric(2)  ,
	TRUNK_NO NVARCHAR(10)  not null,
	PACKAGE_NO_START NVARCHAR(10)  not null,
	PACKAGE_NO_END NVARCHAR(10)  not null,
	IS_FULL numeric(1) default 1 not null,
	STATUS numeric(2) default 11 not null,
	CURRENT_WAREHOUSE NVARCHAR(8)  ,
	LAST_WAREHOUSE NVARCHAR(8)  ,
	CREATE_DATE DATETIME ,
	CREATE_ADMIN numeric(4)  not null,
	CHANGE_ADMIN numeric(4)  ,
	CHANGE_DATE DATETIME  ,
	constraint PK_WH_TICKET_TRUNK primary Key (PLAN_CODE,BATCH_NO,TRUNK_NO)
);
create table tkws.WH_TICKET_BOX(
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	REWARD_GROUP numeric(2)  not null,
	TRUNK_NO NVARCHAR(10)  not null,
	BOX_NO NVARCHAR(20)  not null,
	PACKAGE_NO_START NVARCHAR(10)  not null,
	PACKAGE_NO_END NVARCHAR(10)  not null,
	IS_FULL numeric(1) default 1 not null,
	STATUS numeric(2) default 11 not null,
	CURRENT_WAREHOUSE NVARCHAR(8)  ,
	LAST_WAREHOUSE NVARCHAR(8)  ,
	CREATE_DATE DATETIME ,
	CREATE_ADMIN numeric(4)  not null,
	CHANGE_ADMIN numeric(4)  ,
	CHANGE_DATE DATETIME  ,
	constraint PK_WH_TICKET_BOX primary Key (PLAN_CODE,BATCH_NO,TRUNK_NO,BOX_NO)
);
create table tkws.WH_TICKET_PACKAGE(
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	REWARD_GROUP numeric(2)  not null,
	TRUNK_NO NVARCHAR(10)  not null,
	BOX_NO NVARCHAR(20)  not null,
	PACKAGE_NO NVARCHAR(10)  not null,
	TICKET_NO_START NVARCHAR(10)  not null,
	TICKET_NO_END NVARCHAR(10)  not null,
	IS_FULL numeric(1) default 1 not null,
	STATUS numeric(2) default 11 not null,
	CURRENT_WAREHOUSE NVARCHAR(8)  ,
	LAST_WAREHOUSE NVARCHAR(8)  ,
	CREATE_DATE DATETIME ,
	CREATE_ADMIN numeric(4)  not null,
	CHANGE_ADMIN numeric(4)  ,
	CHANGE_DATE DATETIME  ,
	constraint PK_WH_TICKET_PACKAGE primary Key (PLAN_CODE,BATCH_NO,TRUNK_NO,BOX_NO,PACKAGE_NO)
);
create table tkws.WH_BATCH_INBOUND(
	BI_NO CHAR(10)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	BATCH_TICKETS numeric(18)  not null,
	BATCH_AMOUNT numeric(28)  not null,
	ACT_TICKETS numeric(18) default 0 not null,
	ACT_AMOUNT numeric(28) default 0 not null,
	DISCREPANCY_TICKETS numeric(18) default 0 not null,
	DISCREPANCY_AMOUNT numeric(28) default 0 not null,
	DAMAGED_TICKETS numeric(18) default 0 not null,
	DAMAGED_AMOUNT numeric(28) default 0 not null,
	TRUNKS numeric(18) default 0 not null,
	BOXES numeric(18) default 0 not null,
	PACKAGES numeric(18) default 0 not null,
	CREATE_ADMIN numeric(4)  not null,
	CREATE_DATE DATETIME ,
	OPER_ADMIN numeric(4)  ,
	OPER_DATE DATETIME  ,
	constraint PK_WH_INBOUND primary Key (PLAN_CODE,BATCH_NO)
);
create table tkws.WH_GOODS_ISSUE(
	SGI_NO CHAR(10)  not null,
	CREATE_ADMIN numeric(4)  not null,
	CREATE_DATE DATETIME ,
	ISSUE_END_TIME DATETIME  ,
	ISSUE_AMOUNT numeric(28) default 0 not null,
	ISSUE_TICKETS numeric(18) default 0 not null,
	ACT_ISSUE_AMOUNT numeric(28) default 0 not null,
	ACT_ISSUE_TICKETS numeric(18) default 0 not null,
	ISSUE_TYPE numeric(1)  not null,
	REF_NO CHAR(10)  not null,
	STATUS numeric(1) default 1 not null,
	CARRIER NVARCHAR(500)  ,
	CARRY_DATE DATETIME  ,
	CARRIER_CONTACT NVARCHAR(500)  ,
	SEND_ORG CHAR(2)  ,
	SEND_WH NVARCHAR(8)  ,
	RECEIVE_ADMIN numeric(4)  ,
	REMARK NVARCHAR(4000)  ,
	constraint PK_WH_GOODS_ISSUE primary Key (SGI_NO)
);
create table tkws.WH_GOODS_ISSUE_DETAIL(
	SGI_NO CHAR(10)  not null,
	SEQUENCE_NO numeric(24)  not null,
	ISSUE_TYPE numeric(1)  ,
	REF_NO CHAR(10)  ,
	VALID_NUMBER numeric(1)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	TRUNK_NO NVARCHAR(10)  not null,
	BOX_NO NVARCHAR(20)  not null,
	PACKAGE_NO NVARCHAR(10)  not null,
	TICKETS numeric(18)  not null,
	AMOUNT numeric(28)  not null,
	constraint PK_WH_GOODS_ISSUE_DETAIL primary Key (SEQUENCE_NO)
);
create table tkws.WH_GOODS_RECEIPT(
	SGR_NO CHAR(10)  not null,
	CREATE_ADMIN numeric(4)  not null,
	CREATE_DATE DATETIME ,
	RECEIPT_END_TIME DATETIME  ,
	RECEIPT_AMOUNT numeric(28) default 0 not null,
	RECEIPT_TICKETS numeric(18) default 0 not null,
	ACT_RECEIPT_AMOUNT numeric(28) default 0 not null,
	ACT_RECEIPT_TICKETS numeric(18) default 0 not null,
	RECEIPT_TYPE numeric(1)  not null,
	REF_NO CHAR(10)  not null,
	STATUS numeric(1) default 1 not null,
	CARRIER NVARCHAR(500)  ,
	CARRY_DATE DATETIME  ,
	CARRIER_CONTACT NVARCHAR(500)  ,
	RECEIVE_ORG CHAR(2)  ,
	RECEIVE_WH NVARCHAR(8)  not null,
	SEND_ADMIN numeric(4)  ,
	REMARK NVARCHAR(4000)  ,
	constraint PK_WH_GOODS_RECEIPT primary Key (SGR_NO)
);
create table tkws.WH_GOODS_RECEIPT_DETAIL(
	SGR_NO CHAR(10)  not null,
	SEQUENCE_NO numeric(24)  not null,
	RECEIPT_TYPE numeric(1)  ,
	REF_NO CHAR(10)  ,
	VALID_NUMBER numeric(1)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	TRUNK_NO NVARCHAR(10)  ,
	BOX_NO NVARCHAR(20)  ,
	PACKAGE_NO NVARCHAR(10)  ,
	TICKETS numeric(18)  not null,
	AMOUNT numeric(28)  not null,
	CREATE_ADMIN numeric(4)  ,
	CREATE_DATE DATETIME  ,
	constraint PK_WH_GOODS_RECEIPT_DETAIL primary Key (SEQUENCE_NO)
);
create table tkws.WH_CHECK_POINT(
	CP_NO CHAR(10)  not null,
	WAREHOUSE_CODE CHAR(4)  not null,
	CP_NAME NVARCHAR(4000)  not null,
	PLAN_CODE NVARCHAR(10)  ,
	BATCH_NO NVARCHAR(10)  ,
	STATUS numeric(1)  not null,
	RESULT numeric(1)  not null,
	NOMATCH_TICKETS numeric(18)  ,
	NOMATCH_AMOUNT numeric(28)  ,
	CP_ADMIN numeric(4)  not null,
	CP_DATE DATETIME  not null,
	REMARK NVARCHAR(4000)  ,
	constraint PK_WH_CHECK_POINT primary Key (CP_NO)
);
create table tkws.WH_CHECK_POINT_DETAIL_BE(
	CP_NO CHAR(10)  not null,
	SEQUENCE_NO numeric(24)  not null,
	VALID_NUMBER numeric(1)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	TRUNK_NO NVARCHAR(10)  not null,
	BOX_NO NVARCHAR(20)  ,
	PACKAGE_NO NVARCHAR(10)  ,
	PACKAGES numeric(4)  not null,
	AMOUNT numeric(18)  not null,
	constraint PK_WH_CHECK_POINT_DETAIL_BE primary Key (SEQUENCE_NO)
);
create table tkws.WH_CHECK_POINT_DETAIL(
	CP_NO CHAR(10)  not null,
	SEQUENCE_NO numeric(24)  not null,
	VALID_NUMBER numeric(1)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	TRUNK_NO NVARCHAR(10)  not null,
	BOX_NO NVARCHAR(20)  ,
	PACKAGE_NO NVARCHAR(10)  ,
	PACKAGES numeric(4)  not null,
	AMOUNT numeric(18)  not null,
	constraint PK_WH_CHECK_POINT_DETAIL primary Key (SEQUENCE_NO)
);
create table tkws.WH_CP_NOMATCH_DETAIL(
	CP_NO CHAR(10)  not null,
	SEQUENCE_NO numeric(24)  not null,
	VALID_NUMBER numeric(1)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	TRUNK_NO NVARCHAR(10)  not null,
	BOX_NO NVARCHAR(20)  ,
	PACKAGE_NO NVARCHAR(10)  ,
	PACKAGES numeric(4)  not null,
	AMOUNT numeric(18)  not null,
	constraint PK_WH_CP_NOMATCH_DETAIL primary Key (SEQUENCE_NO)
);
create table tkws.WH_BROKEN_RECODER(
	BROKEN_NO CHAR(10)  not null,
	APPLY_ADMIN numeric(4)  ,
	APPLY_DATE DATETIME  not null,
	SOURCE numeric(1)  not null,
	STB_NO CHAR(10)  ,
	CP_NO CHAR(10)  ,
	PACKAGES numeric(18)  ,
	TOTAL_AMOUNT numeric(28)  ,
	REASON numeric(2)  ,
	REMARK NVARCHAR(4000)  ,
	constraint PK_WH_BROKEN_RECODER primary Key (BROKEN_NO)
);
create table tkws.WH_BROKEN_RECODER_DETAIL(
	BROKEN_NO CHAR(10)  not null,
	SEQUENCE_NO numeric(24)  not null,
	VALID_NUMBER numeric(1)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	TRUNK_NO NVARCHAR(10)  not null,
	BOX_NO NVARCHAR(20)  ,
	PACKAGE_NO NVARCHAR(10)  ,
	PACKAGES numeric(18)  not null,
	AMOUNT numeric(28)  not null,
	constraint PK_WH_BROKEN_RECODER_DETAIL primary Key (SEQUENCE_NO)
);
create table tkws.WH_BATCH_END(
	BE_NO CHAR(10)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	TICKETS numeric(28)  not null,
	SALE_AMOUNT numeric(28)  not null,
	PAY_AMOUNT numeric(28)  not null,
	INVENTORY_TICKETS numeric(28)  not null,
	CREATE_ADMIN numeric(4)  not null,
	CREATE_DATE DATETIME  not null,
	constraint PK_WH_BATCH_END primary Key (BE_NO)
);
create table tkws.SALE_ORDER(
	ORDER_NO CHAR(10)  not null,
	APPLY_ADMIN numeric(4)  ,
	APPLY_DATE DATETIME  not null,
	APPLY_AGENCY CHAR(8)  not null,
	SENDER_ADMIN numeric(4)  ,
	SEND_WAREHOUSE CHAR(4)  ,
	SEND_DATE DATETIME  ,
	CARRIER_ADMIN numeric(4)  ,
	CARRY_DATE DATETIME  ,
	APPLY_CONTACT NVARCHAR(50)  ,
	STATUS numeric(1) default 1 not null,
	IS_INSTANT_ORDER numeric(1) default 0 not null,
	APPLY_TICKETS numeric(16) default 0 not null,
	APPLY_AMOUNT numeric(28) default 0 not null,
	GOODS_TICKETS numeric(16) default 0 ,
	GOODS_AMOUNT numeric(28) default 0 ,
	REMARK NVARCHAR(4000)  ,
	constraint PK_SALE_ORDER primary Key (ORDER_NO)
);
create table tkws.SALE_ORDER_APPLY_DETAIL(
	ORDER_NO CHAR(10)  not null,
	SEQUENCE_NO numeric(24)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	TICKETS numeric(18) default 0 not null,
	PACKAGES numeric(18) default 0 not null,
	AMOUNT numeric(28) default 0 not null,
	REMARK NVARCHAR(4000)  ,
	constraint PK_SALE_ORDER_APPLY_DETAIL primary Key (SEQUENCE_NO)
);
create table tkws.SALE_DELIVERY_ORDER(
	DO_NO CHAR(10)  not null,
	APPLY_ADMIN numeric(4)  not null,
	APPLY_DATE DATETIME  not null,
	WH_CODE CHAR(4)  ,
	WH_ORG CHAR(2)  ,
	WH_ADMIN numeric(4)  ,
	OUT_DATE DATETIME  ,
	STATUS numeric(1) default 1 not null,
	TICKETS numeric(18) default 0 not null,
	AMOUNT numeric(28) default 0 not null,
	ACT_TICKETS numeric(18) default 0 ,
	ACT_AMOUNT numeric(28) default 0 ,
	REMARK NVARCHAR(4000)  ,
	constraint PK_SALE_DELIVERY_ORDER primary Key (DO_NO)
);
create table tkws.SALE_DELIVERY_ORDER_DETAIL(
	DO_NO CHAR(10)  not null,
	SEQUENCE_NO numeric(24)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	TICKETS numeric(18) default 0 not null,
	PACKAGES numeric(18) default 0 not null,
	AMOUNT numeric(28) default 0 not null,
	constraint PK_SALE_DELIVERY_ORDER_DETAIL primary Key (SEQUENCE_NO)
);
create table tkws.SALE_DELIVERY_ORDER_ALL(
	DO_NO CHAR(10)  not null,
	ORDER_NO CHAR(10)  not null,
	constraint PK_SALE_DELIVERY_ORDER_ALL primary Key (DO_NO,ORDER_NO)
);
create table tkws.SALE_TRANSFER_BILL(
	STB_NO CHAR(10)  not null,
	APPLY_ADMIN numeric(4)  not null,
	APPLY_DATE DATETIME  not null,
	APPROVE_ADMIN numeric(4)  ,
	APPROVE_DATE DATETIME  ,
	SEND_ORG CHAR(2)  ,
	SEND_WH CHAR(4)  ,
	SEND_MANAGER numeric(4)  ,
	SEND_DATE DATETIME  ,
	RECEIVE_ORG CHAR(2)  ,
	RECEIVE_WH CHAR(4)  ,
	RECEIVE_MANAGER numeric(4)  ,
	RECEIVE_DATE DATETIME  ,
	TICKETS numeric(18) default 0 ,
	AMOUNT numeric(28) default 0 ,
	ACT_TICKETS numeric(18) default 0 ,
	ACT_AMOUNT numeric(28) default 0 ,
	STATUS numeric(1) default 1 not null,
	IS_MATCH numeric(1) default 0 not null,
	REMARK NVARCHAR(4000)  ,
	constraint PK_SALE_TRANSFER_BILL primary Key (STB_NO)
);
create table tkws.SALE_TB_APPLY_DETAIL(
	STB_NO CHAR(10)  not null,
	SEQUENCE_NO numeric(24)  ,
	PLAN_CODE NVARCHAR(10)  not null,
	TICKETS numeric(18) default 0 not null,
	PACKAGES numeric(18) default 0 not null,
	AMOUNT numeric(28) default 0 not null,
	REMARK NVARCHAR(4000)  ,
	constraint PK_SALE_TB_APPLY_DETAIL primary Key (SEQUENCE_NO)
);
create table tkws.SALE_RETURN_RECODER(
	RETURN_NO CHAR(10)  not null,
	MARKET_MANAGER_ADMIN numeric(4)  not null,
	APPLY_DATE DATETIME  not null,
	APPLY_TICKETS numeric(10) default 0 not null,
	APPLY_AMOUNT numeric(18) default 0 not null,
	FINANCE_ADMIN numeric(4)  ,
	APPROVE_DATE DATETIME  ,
	APPROVE_REMARK NVARCHAR(4000)  ,
	ACT_TICKETS numeric(10) default 0 ,
	ACT_AMOUNT numeric(18) default 0 ,
	STATUS  numeric(1)  not null,
	IS_DIRECT_AUDITED numeric(1) default 0 not null,
	DIRECT_AMOUNT numeric(18)  ,
	RECEIVE_ORG CHAR(2)  ,
	RECEIVE_WH CHAR(4)  ,
	RECEIVE_MANAGER numeric(4)  ,
	RECEIVE_DATE DATETIME  ,
	constraint PK_SALE_RETURN_RECODER primary Key (RETURN_NO)
);
create table tkws.SALE_RETURN_APPLY_DETAIL(
	RETURN_NO CHAR(10)  not null,
	SEQUENCE_NO numeric(24)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	TICKETS numeric(18)  not null,
	PACKAGES numeric(18)  not null,
	AMOUNT numeric(28)  not null,
	constraint PK_SALE_RA_DETAIL primary Key (SEQUENCE_NO)
);
create table tkws.SALE_AGENCY_RECEIPT(
	AR_NO CHAR(10)  not null,
	AR_ADMIN numeric(4)  not null,
	AR_DATE DATETIME  not null,
	AR_AGENCY CHAR(8)  not null,
	BEFORE_BALANCE numeric(28) default 0 not null,
	AFTER_BALANCE numeric(28) default 0 not null,
	TICKETS numeric(16) default 0 not null,
	AMOUNT numeric(28) default 0 not null,
	constraint PK_SALE_AGENCY_RECEIPT primary Key (AR_NO)
);
create table tkws.SALE_AGENCY_RETURN(
	AI_NO CHAR(10)  not null,
	AI_MM_ADMIN numeric(4)  not null,
	AI_DATE DATETIME  not null,
	AI_AGENCY CHAR(8)  not null,
	BEFORE_BALANCE numeric(28) default 0 not null,
	AFTER_BALANCE numeric(28) default 0 not null,
	TICKETS numeric(16) default 0 not null,
	AMOUNT numeric(28) default 0 not null,
	constraint PK_SALE_AGENCY_RETURN primary Key (AI_NO)
);
create table tkws.SALE_PAID(
	DJXQ_NO CHAR(24)  not null,
	PAY_AGENCY CHAR(8)  not null,
	AREA_CODE CHAR(4)  ,
	PAYER_ADMIN numeric(4)  not null,
	IS_CENTER_PAID numeric(1) default 3 not null,
	PLAN_TICKETS numeric(28) default 0 not null,
	SUCC_TICKETS numeric(28) default 0 not null,
	SUCC_AMOUNT numeric(28) default 0 not null,
	PAY_TIME DATETIME not null,
	constraint PK_SALE_PAID primary Key (DJXQ_NO)
);
create table tkws.SALE_PAID_DETAIL(
	DJXQ_NO CHAR(24)  not null,
	DJXQ_SEQ_NO numeric(24)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	PACKAGE_NO NVARCHAR(10)  not null,
	TICKET_NO numeric(5) default 0 not null,
	SECURITY_CODE NVARCHAR(50) default 0 not null,
	PAID_STATUS numeric(1) default 0 not null,
	PAY_FLOW CHAR(24)  ,
	REWARD_AMOUNT numeric(28)  ,
	PAY_TIME DATETIME not null,
	IS_OLD_TICKET numeric(1) default 0 not null,
	constraint PK_SALE_PAID_DETAIL primary Key (DJXQ_SEQ_NO)
);
create table tkws.FLOW_GUI_PAY(
	GUI_PAY_NO CHAR(12)  not null,
	WINNERNAME NVARCHAR(1000)  ,
	GENDER numeric(1)  ,
	CONTACT NVARCHAR(4000)  ,
	AGE numeric(3)  ,
	CERT_NUMBER NVARCHAR(50)  ,
	REWARD_NO numeric(3)  ,
	PAY_AMOUNT numeric(28)  not null,
	PAY_TIME DATETIME  not null,
	PAYER_ADMIN numeric(4)  not null,
	PAYER_NAME NVARCHAR(1000)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	TRUNK_NO NVARCHAR(10)  not null,
	BOX_NO NVARCHAR(20)  not null,
	PACKAGE_NO NVARCHAR(10)  not null,
	TICKET_NO numeric(5)  not null,
	SECURITY_CODE NVARCHAR(50)  ,
	IS_MANUAL numeric(1)  ,
	PAY_FLOW CHAR(24)  not null,
   REMARK NVARCHAR(4000),
	constraint PK_FLOW_GUI_PAY primary Key (GUI_PAY_NO)
);
create table tkws.FLOW_PAY(
	PAY_FLOW CHAR(24)  not null,
	PAY_AGENCY CHAR(8)  ,
	AREA_CODE CHAR(4)  ,
	PAY_COMM numeric(18)  ,
	PAY_COMM_RATE numeric(8)  ,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	REWARD_GROUP numeric(2)  not null,
	TRUNK_NO NVARCHAR(10)  not null,
	BOX_NO NVARCHAR(20)  not null,
	PACKAGE_NO NVARCHAR(10)  not null,
	TICKET_NO numeric(5)  not null,
	SECURITY_CODE NVARCHAR(50)  ,
	IDENTITY_CODE NVARCHAR(50)  ,
	PAY_AMOUNT numeric(28)  not null,
	REWARD_NO numeric(3)  ,
	LOTTERY_AMOUNT numeric(18)  not null,
	COMM_AMOUNT numeric(18)  ,
	COMM_RATE numeric(8)  ,
	PAY_TIME DATETIME  not null,
	PAYER_ADMIN numeric(4)  ,
	PAYER_NAME NVARCHAR(1000)  ,
	IS_CENTER_PAID numeric(1) default 0 not null,
	constraint PK_FLOW_PAY primary Key (PAY_FLOW)
);
create table tkws.FLOW_SALE(
	SALE_FLOW CHAR(24)  not null,
	AGENCY_CODE CHAR(8)  not null,
	AREA_CODE CHAR(4)  not null,
	ORG_CODE CHAR(2)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	TRUNKS numeric(18)  not null,
	BOXES numeric(18)  not null,
	PACKAGES numeric(18)  not null,
	TICKETS numeric(18)  not null,
	SALE_AMOUNT numeric(28)  not null,
	COMM_AMOUNT numeric(18)  not null,
	COMM_RATE numeric(8)  not null,
	SALE_TIME DATETIME  not null,
	AR_NO CHAR(10)  not null,
	SGR_NO CHAR(10)  not null,
	constraint PK_FLOW_SALE primary Key (SALE_FLOW)
);
create table tkws.FLOW_CANCEL(
	CANCEL_FLOW CHAR(24)  not null,
	AGENCY_CODE CHAR(8)  not null,
	AREA_CODE CHAR(4)  not null,
	ORG_CODE CHAR(2)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	TRUNKS numeric(18)  not null,
	BOXES numeric(18)  not null,
	PACKAGES numeric(18)  not null,
	TICKETS numeric(18)  not null,
	SALE_AMOUNT numeric(28)  not null,
	COMM_AMOUNT numeric(18)  not null,
	COMM_RATE numeric(8)  not null,
	CANCEL_TIME DATETIME  not null,
	AI_NO CHAR(10)  not null,
	SGI_NO CHAR(10)  not null,
	constraint PK_FLOW_CANCEL primary Key (CANCEL_FLOW)
);
create table tkws.FLOW_PAY_ORG_COMM(
	PAY_FLOW CHAR(24)  not null,
	PAY_AGENCY CHAR(8)  ,
	AREA_CODE CHAR(4)  ,
	ORG_CODE CHAR(2)  not null,
	ORG_TYPE numeric(1)  not null,
	ORG_PAY_COMM numeric(18)  ,
	ORG_PAY_COMM_RATE numeric(8)  ,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	REWARD_GROUP numeric(2)  not null,
	TRUNK_NO NVARCHAR(10)  not null,
	BOX_NO NVARCHAR(20)  not null,
	PACKAGE_NO NVARCHAR(10)  not null,
	TICKET_NO numeric(5)  not null,
	SECURITY_CODE NVARCHAR(50)  ,
	IDENTITY_CODE NVARCHAR(50)  ,
	PAY_AMOUNT numeric(28)  not null,
	REWARD_NO numeric(3)  ,
	LOTTERY_AMOUNT numeric(18)  not null,
	PAY_TIME DATETIME  not null,
	PAYER_ADMIN numeric(4)  ,
	PAYER_NAME NVARCHAR(1000)  ,
	IS_CENTER_PAID numeric(1) default 0 not null,
	constraint PK_FLOW_PAY_ORG_COMM primary Key (PAY_FLOW)
);
create table tkws.FLOW_SALE_ORG_COMM(
	SALE_FLOW CHAR(24)  not null,
	AGENCY_CODE CHAR(8)  not null,
	AREA_CODE CHAR(4)  not null,
	ORG_CODE CHAR(2)  not null,
	ORG_TYPE numeric(1)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	TRUNKS numeric(18)  not null,
	BOXES numeric(18)  not null,
	PACKAGES numeric(18)  not null,
	TICKETS numeric(18)  not null,
	SALE_AMOUNT numeric(28)  not null,
	ORG_COMM_AMOUNT numeric(18)  not null,
	ORG_COMM_RATE numeric(8)  not null,
	SALE_TIME DATETIME  not null,
	AR_NO CHAR(10)  not null,
	SGR_NO CHAR(10)  not null,
	constraint PK_FLOW_SALE_ORG_COMM primary Key (SALE_FLOW)
);
create table tkws.FLOW_CANCEL_ORG_COMM(
	CANCEL_FLOW CHAR(24)  not null,
	AGENCY_CODE CHAR(8)  not null,
	AREA_CODE CHAR(4)  not null,
	ORG_CODE CHAR(2)  not null,
	ORG_TYPE numeric(1)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	TRUNKS numeric(18)  not null,
	BOXES numeric(18)  not null,
	PACKAGES numeric(18)  not null,
	TICKETS numeric(18)  not null,
	SALE_AMOUNT numeric(28)  not null,
	COMM_AMOUNT numeric(18)  not null,
	COMM_RATE numeric(8)  not null,
	CANCEL_TIME DATETIME  not null,
	AI_NO CHAR(10)  not null,
	SGI_NO CHAR(10)  not null,
	constraint PK_FLOW_CANCEL_ORG_COMM primary Key (CANCEL_FLOW)
);
create table tkws.FLOW_ORG(
	ORG_FUND_FLOW CHAR(24)  not null,
	REF_NO NVARCHAR(24)  not null,
	FLOW_TYPE numeric(2)  not null,
	ACC_NO CHAR(12)  not null,
	ORG_CODE CHAR(2)  not null,
	CHANGE_AMOUNT numeric(28)  not null,
	FROZEN_AMOUNT numeric(28) default 0 not null,
	BE_ACCOUNT_BALANCE numeric(28)  not null,
	BE_FROZEN_BALANCE numeric(28)  not null,
	AF_ACCOUNT_BALANCE numeric(28)  not null,
	AF_FROZEN_BALANCE numeric(28)  not null,
	TRADE_TIME DATETIME not null,
	constraint PK_FLOW_ORG primary Key (ORG_FUND_FLOW)
);
create table tkws.FLOW_ORG_COMM_DETAIL(
	ORG_FUND_COMM_FLOW CHAR(24)  not null,
	ORG_FUND_FLOW CHAR(24)  not null,
	AGENCY_CODE CHAR(8)  not null,
	PLAN_NAME NVARCHAR(100)  not null,
	ACC_NO CHAR(12)  not null,
	ORG_CODE CHAR(2)  not null,
	TRADE_TIME DATETIME not null,
	TRADE_AMOUNT numeric(28) default 0 not null,
	AGENCY_SALE_AMOUNT numeric(28) default 0 not null,
	ORG_SALE_COMM numeric(28) default 0 not null,
	AGENCY_SALE_COMM_RATE numeric(28) default 0 not null,
	ORG_SALE_COMM_RATE numeric(28) default 0 not null,
	AGENCY_CANCEL_AMOUNT numeric(28) default 0 not null,
	ORG_CANCEL_COMM numeric(28) default 0 not null,
	AGENCY_CANCEL_COMM_RATE numeric(28) default 0 not null,
	ORG_CANCEL_COMM_RATE numeric(28) default 0 not null,
	AGENCY_PAY_AMOUNT numeric(28) default 0 not null,
	ORG_PAY_AMOUNT numeric(28) default 0 not null,
	AGENCY_PAY_COMM_RATE numeric(28) default 0 not null,
	ORG_PAY_COMM_RATE numeric(28) default 0 not null,
	constraint PK_FLOW_ORG_COMM_DETAIL primary Key (ORG_FUND_FLOW)
);
create table tkws.FLOW_AGENCY(
	AGENCY_FUND_FLOW CHAR(24)  not null,
	REF_NO NVARCHAR(24)  not null,
	FLOW_TYPE numeric(2)  not null,
	ACC_NO CHAR(12)  not null,
	AGENCY_CODE CHAR(8)  not null,
	CHANGE_AMOUNT numeric(28)  not null,
	FROZEN_AMOUNT numeric(28) default 0 not null,
	BE_ACCOUNT_BALANCE numeric(28) default 0 not null,
	BE_FROZEN_BALANCE numeric(28) default 0 not null,
	AF_ACCOUNT_BALANCE numeric(28) default 0 not null,
	AF_FROZEN_BALANCE numeric(28) default 0 not null,
	TRADE_TIME DATETIME not null,
	constraint PK_FLOW_AGENCY primary Key (AGENCY_FUND_FLOW)
);
create table tkws.FLOW_MARKET_MANAGER(
	MM_FUND_FLOW CHAR(24)  not null,
	REF_NO CHAR(10)  not null,
	FLOW_TYPE numeric(2)  not null,
	ACC_NO CHAR(12)  not null,
	MARKET_ADMIN numeric(4)  not null,
	CHANGE_AMOUNT numeric(28)  not null,
	BE_ACCOUNT_BALANCE numeric(28)  not null,
	AF_ACCOUNT_BALANCE numeric(28)  not null,
	TRADE_TIME DATETIME not null,
	constraint PK_FLOW_MARKET_MANAGER primary Key (MM_FUND_FLOW)
);
create table tkws.SYS_PARAMETER(
	SYS_DEFAULT_SEQ numeric(12)  not null,
	SYS_DEFAULT_DESC NVARCHAR(1000)  not null,
	SYS_DEFAULT_VALUE NVARCHAR(1000)  not null,
	constraint PK_SYS_PARAMETER primary Key (SYS_DEFAULT_SEQ)
);
create table tkws.SYS_OPER_LOG(
	OPER_NO CHAR(10)  not null,
	OPER_PRIVILEGE numeric(4)  not null,
	OPER_ADMIN numeric(4)  not null,
	OPER_TIME DATETIME  not null,
	OPER_MODE numeric(1)  not null,
	OPER_CONTENTS NVARCHAR(4000)  ,
	constraint PK_SYS_OPER_LOG primary Key (OPER_NO)
);
create table tkws.SWITCH_SCAN(
	OLD_PAY_FLOW CHAR(24)  not null,
	PAID_TIME DATETIME  ,
	PAID_ADMIN numeric(4)  ,
	PAID_ORG CHAR(2)  ,
	APPLY_TICKETS numeric(28)  ,
	FAIL_NEW_TICKETS numeric(28)  ,
	SUCC_TICKETS numeric(28)  ,
	SUCC_AMOUNT numeric(28)  ,
	constraint PK_SWITCH_SCAN primary Key (OLD_PAY_FLOW)
);
create table tkws.SWITCH_SCAN_DETAIL(
	OLD_PAY_FLOW CHAR(24)  not null,
	OLD_PAY_SEQ CHAR(24)  not null,
	PAID_TIME DATETIME  not null,
	PAID_ADMIN numeric(4)  not null,
	PAID_ORG CHAR(2)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	PACKAGE_NO NVARCHAR(10)  not null,
	TICKET_NO numeric(5) default 0 not null,
	SECURITY_CODE NVARCHAR(50) default 0 not null,
	PAID_STATUS numeric(1) default 0 not null,
	REWARD_AMOUNT numeric(28)  not null,
	IS_NEW_TICKET numeric(1) default 0 not null,
	constraint PK_SWITCH_SCAN_DETAIL primary Key (OLD_PAY_SEQ)
);
create table tkws.FUND_CHARGE_CENTER(
	FUND_NO CHAR(10)  not null,
	ACCOUNT_TYPE numeric(1)  not null,
	AO_CODE NVARCHAR(8)  not null,
	AO_NAME NVARCHAR(4000)  ,
	ACC_NO CHAR(12)  not null,
	OPER_AMOUNT numeric(28)  not null,
	BE_ACCOUNT_BALANCE numeric(28)  not null,
	AF_ACCOUNT_BALANCE numeric(28)  not null,
	OPER_TIME DATETIME  not null,
	OPER_ADMIN numeric(4)  not null,
	constraint PK_FUND_CHARGE_CENTER primary Key (FUND_NO)
);
create table tkws.FUND_WITHDRAW(
	FUND_NO CHAR(10)  not null,
	ACCOUNT_TYPE numeric(1)  not null,
	AO_CODE NVARCHAR(8)  not null,
	AO_NAME NVARCHAR(4000)  ,
	ACC_NO CHAR(12)  not null,
	APPLY_AMOUNT numeric(16)  not null,
	APPLY_ADMIN numeric(4)  not null,
	APPLY_DATE DATETIME  not null,
	MARKET_ADMIN numeric(4)  ,
	APPLY_CHECK_TIME DATETIME  ,
	CHECK_ADMIN_ID numeric(4)  ,
	APPLY_STATUS numeric(1)  not null,
	APPLY_MEMO NVARCHAR(4000)  ,
	TERMINAL_CODE CHAR(8)  ,
	constraint PK_FUND_WITHDRAW primary Key (FUND_NO)
);
create table tkws.FUND_MM_CASH_REPAY(
	MCR_NO CHAR(10)  not null,
	MARKET_ADMIN numeric(4)  not null,
	REPAY_AMOUNT numeric(16)  ,
	REPAY_TIME DATETIME  ,
	REPAY_ADMIN numeric(4)  not null,
	REMARK NVARCHAR(4000)  ,
	constraint PK_FUND_MM_CASH_REPAY primary Key (MCR_NO)
);
create table tkws.ITEM_ITEMS(
	ITEM_CODE CHAR(8)  not null,
	ITEM_NAME NVARCHAR(4000)  not null,
	BASE_UNIT_NAME NVARCHAR(500)  not null,
	STATUS numeric(1) default 1 not null,
	constraint PK_ITEM_ITEMS primary Key (ITEM_CODE)
);
create table tkws.ITEM_QUANTITY(
	ITEM_CODE CHAR(8)  not null,
	WAREHOUSE_CODE CHAR(4)  not null,
	ITEM_NAME NVARCHAR(4000)  not null,
	QUANTITY numeric(10)  not null,
	constraint PK_ITEM_QUANTITY primary Key (ITEM_CODE,WAREHOUSE_CODE)
);
create table tkws.ITEM_RECEIPT(
	IR_NO CHAR(10)  not null,
	CREATE_ADMIN numeric(4)  ,
	RECEIVE_ORG CHAR(2)  ,
	RECEIVE_WH CHAR(4)  ,
	RECEIVE_DATE DATETIME  ,
	REMARK NVARCHAR(4000)  ,
	constraint PK_ITEM_RECEIPT primary Key (IR_NO)
);
create table tkws.ITEM_RECEIPT_DETAIL(
	IR_NO CHAR(10)  not null,
	ITEM_CODE CHAR(8)  ,
	QUANTITY numeric(10)  ,
	constraint PK_ITEM_RECEIPT_DETAIL primary Key (IR_NO,ITEM_CODE)
);
create table tkws.ITEM_ISSUE(
	II_NO CHAR(10)  not null,
	OPER_ADMIN numeric(4)  not null,
	ISSUE_DATE DATETIME  ,
	RECEIVE_ORG CHAR(2)  ,
	SEND_ORG CHAR(2)  ,
	SEND_WH CHAR(4)  ,
	REMARK NVARCHAR(4000)  ,
	constraint PK_ITEM_ISSUE primary Key (II_NO)
);
create table tkws.ITEM_ISSUE_DETAIL(
	II_NO CHAR(10)  not null,
	ITEM_CODE CHAR(8)  ,
	QUANTITY numeric(10)  ,
	constraint PK_ITEM_ISSUE_DETAIL primary Key (II_NO,ITEM_CODE)
);
create table tkws.ITEM_CHECK(
	CHECK_NO CHAR(10)  not null,
	CHECK_NAME NVARCHAR(500)  ,
	CHECK_DATE DATETIME  ,
	CHECK_ADMIN numeric(4)  not null,
	CHECK_WAREHOUSE CHAR(4)  ,
	STATUS numeric(1)  not null,
	REMARK NVARCHAR(4000)  ,
	constraint PK_ITEM_CHECK primary Key (CHECK_NO)
);
create table tkws.ITEM_CHECK_DETAIL_BE(
	CHECK_NO CHAR(10)  not null,
	ITEM_CODE CHAR(8)  ,
	QUANTITY numeric(10)  ,
	constraint PK_ITEM_CHECK_DETAIL_BE primary Key (CHECK_NO,ITEM_CODE)
);
create table tkws.ITEM_CHECK_DETAIL_AF(
	CHECK_NO CHAR(10)  not null,
	ITEM_CODE CHAR(8)  ,
	QUANTITY numeric(10)  ,
	CHANGE_QUANTITY numeric(10)  ,
	RESULT numeric(1)  not null,
	constraint PK_ITEM_CHECK_DETAIL_AF primary Key (CHECK_NO,ITEM_CODE)
);
create table tkws.ITEM_DAMAGE(
	ID_NO CHAR(10)  not null,
	DAMAGE_DATE DATETIME  not null,
	WAREHOUSE_CODE CHAR(4)  not null,
	ITEM_CODE CHAR(8)  not null,
	QUANTITY numeric(10)  not null,
	CHECK_ADMIN numeric(4)  not null,
	REMARK NVARCHAR(2000)  ,
	constraint PK_ITEM_DAMAGE primary Key (ID_NO,ITEM_CODE)
);
create table tkws.HIS_LOTTERY_INVENTORY(
	CALC_DATE NVARCHAR(10)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	BATCH_NO NVARCHAR(10)  not null,
	REWARD_GROUP numeric(2)  not null,
	STATUS numeric(2) default 1 not null,
	WAREHOUSE NVARCHAR(8)  ,
	TICKETS numeric(28)  not null,
	AMOUNT numeric(28)  not null,
	constraint PK_HIS_LOTTERY_INVENTORY primary Key (CALC_DATE,PLAN_CODE,BATCH_NO,REWARD_GROUP,STATUS, WAREHOUSE)
);
create table tkws.HIS_AGENCY_FUND(
	CALC_DATE NVARCHAR(10)  not null,
	AGENCY_CODE CHAR(8)  not null,
	FLOW_TYPE numeric(2)  not null,
	AMOUNT numeric(28)  not null,
	BE_ACCOUNT_BALANCE numeric(28) default 1 not null,
	AF_ACCOUNT_BALANCE numeric(28)  not null,
	constraint PK_HIS_AGENCY_FUND primary Key (CALC_DATE,AGENCY_CODE,FLOW_TYPE)
);
create table tkws.HIS_AGENCY_INV(
	CALC_DATE NVARCHAR(10)  not null,
	AGENCY_CODE CHAR(8)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	OPER_TYPE numeric(2)  not null,
	TICKETS numeric(28) default 0 not null,
	AMOUNT numeric(28) default 0 not null,
	constraint PK_HIS_AGENCY_INV primary Key (CALC_DATE,AGENCY_CODE,PLAN_CODE,OPER_TYPE)
);
create table tkws.HIS_MM_FUND(
	CALC_DATE NVARCHAR(10)  not null,
	MARKET_ADMIN numeric(4)  not null,
	FLOW_TYPE numeric(2)  not null,
	AMOUNT numeric(28)  not null,
	BE_ACCOUNT_BALANCE numeric(28)  not null,
	AF_ACCOUNT_BALANCE numeric(28)  not null,
	constraint PK_HIS_MM_FUND primary Key (CALC_DATE,MARKET_ADMIN,FLOW_TYPE)
);
create table tkws.HIS_MM_INVENTORY(
	CALC_DATE NVARCHAR(10)  not null,
	MARKET_ADMIN numeric(4)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	OPEN_INV numeric(28)  not null,
	CLOSE_INV numeric(28)  not null,
	GOT_TICKETS numeric(28)  not null,
	SALED_TICKETS numeric(28)  not null,
	CANCELED_TICKETS numeric(28)  not null,
	RETURN_TICKETS numeric(28)  not null,
	BROKEN_TICKETS numeric(28)  not null,
	constraint PK_HIS_MM_INVENTORY primary Key (CALC_DATE,MARKET_ADMIN,PLAN_CODE)
);
create table tkws.HIS_ORG_FUND_REPORT(
	CALC_DATE NVARCHAR(10)  not null,
	ORG_CODE CHAR(2)  not null,
	BE_ACCOUNT_BALANCE numeric(28) default 0 not null,
	CHARGE numeric(28) default 0 not null,
	WITHDRAW numeric(28) default 0 not null,
	SALE numeric(28) default 0 not null,
	SALE_COMM numeric(28) default 0 not null,
	PAID numeric(28) default 0 not null,
	PAY_COMM numeric(28) default 0 not null,
	RTV numeric(28) default 0 not null,
	RTV_COMM numeric(28) default 0 not null,
	CENTER_PAY numeric(28) default 0 not null,
	CENTER_PAY_COMM numeric(28) default 0 not null,
	LOT_SALE numeric(28) default 0 not null,
	LOT_SALE_COMM numeric(28) default 0 not null,
	LOT_PAID numeric(28) default 0 not null,
	LOT_PAY_COMM numeric(28) default 0 not null,
	LOT_RTV numeric(28) default 0 not null,
	LOT_RTV_COMM numeric(28) default 0 not null,
	LOT_CENTER_PAY numeric(28) default 0 not null,
	LOT_CENTER_PAY_COMM numeric(28) default 0 not null,
	LOT_CENTER_RTV numeric(28) default 0 not null,
	LOT_CENTER_RTV_COMM numeric(28) default 0 not null,
	AF_ACCOUNT_BALANCE numeric(28) default 0 not null,
	INCOMING numeric(28) default 0 not null,
	PAY_UP numeric(28) default 0 not null,
	constraint PK_HIS_ORG_FUND_REPORT primary Key (CALC_DATE,ORG_CODE)
);
create table tkws.HIS_ORG_FUND(
	CALC_DATE NVARCHAR(10)  not null,
	ORG_CODE CHAR(2)  not null,
	CHARGE numeric(28) default 0 not null,
	WITHDRAW numeric(28) default 0 not null,
	CENTER_PAID numeric(28) default 0 not null,
	CENTER_PAID_COMM numeric(28) default 0 not null,
	PAY_UP numeric(28) default 0 not null,
	constraint PK_HIS_ORG_FUND primary Key (CALC_DATE,ORG_CODE)
);
create table tkws.HIS_ORG_INV_REPORT(
	CALC_DATE NVARCHAR(10)  not null,
	ORG_CODE CHAR(2)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	OPER_TYPE numeric(2) default 0 not null,
	TICKETS numeric(28) default 0 not null,
	AMOUNT numeric(28) default 0 not null,
	constraint PK_HIS_ORG_INV_REPORT primary Key (CALC_DATE,ORG_CODE,PLAN_CODE,OPER_TYPE)
);
create table tkws.HIS_SALE_ORG(
	CALC_DATE NVARCHAR(10)  not null,
	ORG_CODE CHAR(2)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	SALE_AMOUNT numeric(28) default 0 not null,
	SALE_COMM numeric(28) default 0 not null,
	CANCEL_AMOUNT numeric(28) default 0 not null,
	CANCEL_COMM numeric(28) default 0 not null,
	PAID_AMOUNT numeric(28) default 0 not null,
	PAID_COMM numeric(28) default 0 not null,
	INCOMING numeric(28) default 0 not null,
	constraint PK_HIS_SALE_ORG primary Key (CALC_DATE,PLAN_CODE,ORG_CODE)
);
create table tkws.HIS_AGENT_FUND_REPORT(
	CALC_DATE NVARCHAR(10)  not null,
	ORG_CODE CHAR(2)  not null,
	FLOW_TYPE numeric(2)  not null,
	AMOUNT numeric(28)  not null,
	constraint PK_HIS_AGENT_FUND_REPORT primary Key (CALC_DATE,ORG_CODE,FLOW_TYPE)
);
create table tkws.HIS_SALE_HOUR(
	CALC_DATE NVARCHAR(10)  not null,
	CALC_TIME numeric(10)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	ORG_CODE CHAR(2)  not null,
	SALE_AMOUNT numeric(28) default 0 not null,
	CANCEL_AMOUNT numeric(28) default 0 not null,
	PAY_AMOUNT numeric(28) default 0 not null,
	DAY_SALE_AMOUNT numeric(28) default 0 not null,
	DAY_CANCEL_AMOUNT numeric(28) default 0 not null,
	DAY_PAY_AMOUNT numeric(28) default 0 not null,
	constraint PK_HIS_SALE_HOUR primary Key (CALC_DATE,CALC_TIME,PLAN_CODE,ORG_CODE)
);
create table tkws.HIS_SALE_HOUR_AGENCY(
	CALC_DATE NVARCHAR(10)  not null,
	CALC_TIME numeric(10)  not null,
	PLAN_CODE NVARCHAR(10)  not null,
	AGENCY_CODE CHAR(8)  not null,
	AREA_CODE CHAR(4)  not null,
	SALE_AMOUNT numeric(28) default 0 not null,
	CANCEL_AMOUNT numeric(28) default 0 not null,
	PAY_AMOUNT numeric(28) default 0 not null,
	DAY_SALE_AMOUNT numeric(28) default 0 not null,
	DAY_CANCEL_AMOUNT numeric(28) default 0 not null,
	DAY_PAY_AMOUNT numeric(28) default 0 not null,
	constraint PK_HIS_SALE_HOUR_AGENCY primary Key (CALC_DATE,CALC_TIME,PLAN_CODE,AGENCY_CODE)
);
create table tkws.HIS_TERMINAL_ONLINE(
	CALC_DATE NVARCHAR(10)  not null,
	CALC_TIME numeric(10)  not null,
	ORG_CODE NVARCHAR(10)  not null,
	ORG_NAME NVARCHAR(4000)  not null,
	TOTAL_COUNT numeric(28)  not null,
	ONLINE_COUNT numeric(28) default 0 not null,
	constraint PK_HIS_TERMINAL_ONLINE primary Key (CALC_DATE,CALC_TIME,ORG_CODE)
);
create table tkws.HIS_DIM_DWM(
	D_YEAR CHAR(4)  not null,
	D_MONTH CHAR(7)  not null,
	D_WEEK CHAR(2)  not null,
	D_DAY CHAR(10)  not null,
	constraint PK_HIS_DIM_DM primary Key (D_YEAR,D_MONTH,D_DAY)
);
create table tkws.HIS_SALE_PAY_CANCEL(
	SALE_DATE NVARCHAR(10)  not null,
	SALE_MONTH NVARCHAR(10)  not null,
	AREA_CODE CHAR(4)  ,
	ORG_CODE CHAR(2)  not null,
	PLAN_CODE NVARCHAR(4000)  not null,
	SALE_AMOUNT numeric(28)  ,
	SALE_COMM numeric(28)  ,
	CANCEL_AMOUNT numeric(28)  ,
	CANCEL_COMM numeric(28)  ,
	PAY_AMOUNT numeric(28)  ,
	PAY_COMM numeric(28)  ,
	INCOMING numeric(28)  ,
	constraint PK_HIS_SALE_PAY_CANCEL primary Key (SALE_DATE,SALE_MONTH,AREA_CODE,ORG_CODE,PLAN_CODE)
);
create table tkws.HIS_PAY_LEVEL(
	SALE_DATE NVARCHAR(10)  not null,
	SALE_MONTH NVARCHAR(10)  not null,
	ORG_CODE CHAR(2)  not null,
	PLAN_CODE NVARCHAR(4000)  not null,
	LEVEL_1 numeric(28)  ,
	LEVEL_2 numeric(28)  ,
	LEVEL_3 numeric(28)  ,
	LEVEL_4 numeric(28)  ,
	LEVEL_5 numeric(28)  ,
	LEVEL_6 numeric(28)  ,
	LEVEL_7 numeric(28)  ,
	LEVEL_8 numeric(28)  ,
  LEVEL_OTHER numeric(28)  ,
	TOTAL numeric(28)  ,
	constraint PK_HIS_PAY_LEVEL primary Key (SALE_DATE,SALE_MONTH,ORG_CODE,PLAN_CODE)
);
create table tkws.FUND_TUNING(
	FUND_NO CHAR(10)  not null,
	ACCOUNT_TYPE numeric(1)  not null,
	AO_CODE NVARCHAR(8)  not null,
	AO_NAME NVARCHAR(4000)  ,
	ACC_NO CHAR(12)  not null,
	CHANGE_AMOUNT numeric(28)  not null,
	BE_ACCOUNT_BALANCE numeric(28)  not null,
	AF_ACCOUNT_BALANCE numeric(28)  not null,
	OPER_TIME DATETIME  not null,
	OPER_ADMIN numeric(4)  not null,
	TUNING_REASON NVARCHAR(4000)  ,
	constraint PK_FUND_TUNING primary Key (FUND_NO)
);
create table tkws.ADM_ORG_RELATE
(
  ADMIN_ID numeric(4) not null,
  ORG_CODE CHAR(2) not null,
  constraint PK_ADM_ORG_RELATE primary key (ADMIN_ID, ORG_CODE)
);
create table tkws.WH_MM_CHECK(
  CP_NO CHAR(10)  not null,
  MANAGER_ID numeric(4)  not null,
  RESULT numeric(1)  not null,
  INV_TICKETS   numeric(18)  not null,
  CHECK_TICKETS numeric(18)  not null,
  DIFF_TICKETS  numeric(18)  not null,
  CP_DATE DATETIME  not null,
  constraint PK_WH_MM_CHECK primary Key (CP_NO)
);
create table tkws.WH_MM_CHECK_DETAIL(
  CP_DETAIL_NO CHAR(10)  not null,
  CP_NO CHAR(10)  not null,
  MANAGER_ID numeric(4)  not null,
  PLAN_CODE NVARCHAR(10)  not null,
  BATCH_NO NVARCHAR(10)  not null,
  VALID_NUMBER numeric(1)  not null,
  TRUNK_NO     NVARCHAR(10)  ,
  BOX_NO       NVARCHAR(20)  ,
  PACKAGE_NO   NVARCHAR(10)  ,
  TICKETS      numeric(28)  not null,
  STATUS       numeric(1)  not null,
  constraint PK_WH_MM_CHECK_DETAIL primary Key (CP_DETAIL_NO)
);
create table tkws.INF_GAMES(
	GAME_CODE numeric(3)  not null,
	GAME_MARK NVARCHAR(10)  not null,
	BASIC_TYPE numeric(1)  not null,
	FULL_NAME NVARCHAR(500)  not null,
	SHORT_NAME NVARCHAR(500)  not null,
	ISSUING_ORGANIZATION NVARCHAR(1000)  ,
	constraint PK_INF_GAMES primary Key (GAME_CODE)
);
create table tkws.INF_DEVICES(
	DEVICE_ID numeric(8)  not null,
	DEVICE_NAME NVARCHAR(100)  not null,
	IP_ADDR NVARCHAR(50)  ,
	DEVICE_STATUS numeric(1)  not null,
	DEVICE_TYPE numeric(1)  not null,
	GAME_CODE numeric(3)  ,
	constraint PK_INF_DEVICES primary Key (DEVICE_ID)
);
create table tkws.INF_TERMINAL_TYPES(
	TERM_TYPE_ID numeric(4)  not null,
	TERM_TYPE_DESC NVARCHAR(1000)  not null,
	constraint PK_INF_TERM_TYPES primary Key (TERM_TYPE_ID)
);
create table tkws.GP_STATIC(
	GAME_CODE numeric(3)  not null,
	DRAW_MODE numeric(1)  not null,
	SINGLEBET_AMOUNT numeric(16)  not null,
	SINGLETICKET_MAX_ISSUES numeric(2)  not null,
	LIMIT_BIG_PRIZE numeric(16)  not null,
	LIMIT_PAYMENT numeric(16)  not null,
	LIMIT_PAYMENT2 numeric(16)  not null,
	LIMIT_CANCEL2 numeric(16)  not null,
	ABANDON_REWARD_COLLECT numeric(1)  not null,
	constraint PK_GP_STATIC primary Key (GAME_CODE)
);
create table tkws.GP_DYNAMIC(
	GAME_CODE numeric(3)  not null,
	SINGLELINE_MAX_AMOUNT numeric(16)  not null,
	SINGLETICKET_MAX_LINE numeric(16)  not null,
	SINGLETICKET_MAX_AMOUNT numeric(16)  not null,
	CANCEL_SEC numeric(8)  not null,
	SALER_PAY_LIMIT numeric(16)  ,
	SALER_CANCEL_LIMIT numeric(16)  ,
	ISSUE_CLOSE_ALERT_TIME numeric(16)  ,
	IS_PAY numeric(1) default 1 not null,
	IS_SALE numeric(1) default 1 not null,
	IS_CANCEL numeric(1) default 1 not null,
	IS_AUTO_DRAW numeric(1) default 1 not null,
	SERVICE_TIME_1 NVARCHAR(20)  ,
	SERVICE_TIME_2 NVARCHAR(20)  ,
	AUDIT_SINGLE_TICKET_SALE numeric(28)  ,
	AUDIT_SINGLE_TICKET_PAY numeric(28)  ,
	AUDIT_SINGLE_TICKET_CANCEL numeric(28)  ,
	CALC_WINNING_CODE NVARCHAR(1000)  ,
	constraint PK_GP_DYNAMIC primary Key (GAME_CODE)
);
create table tkws.GP_HISTORY(
	HIS_HIS_CODE numeric(8)  not null,
	HIS_MODIFY_DATE DATETIME not null,
	GAME_CODE numeric(3)  not null,
	IS_OPEN_RISK numeric(1)  ,
	RISK_PARAM NVARCHAR(1000)  ,
	constraint PK_GP_HISTORY primary Key (HIS_HIS_CODE,GAME_CODE)
);
create table tkws.GP_POLICY(
	HIS_POLICY_CODE numeric(8)  not null,
	HIS_MODIFY_DATE DATETIME  ,
	GAME_CODE numeric(3)  not null,
	THEORY_RATE numeric(10)  not null,
	FUND_RATE numeric(10)  not null,
	ADJ_RATE numeric(10)  not null,
	TAX_THRESHOLD numeric(10)  not null,
	TAX_RATE numeric(10)  not null,
	DRAW_LIMIT_DAY numeric(10)  not null,
	constraint PK_GP_POLICY primary Key (HIS_POLICY_CODE,GAME_CODE)
);
create table tkws.GP_RULE(
	HIS_RULE_CODE numeric(8)  not null,
	HIS_MODIFY_DATE DATETIME  ,
	GAME_CODE numeric(3)  not null,
	RULE_CODE numeric(3)  not null,
	RULE_NAME NVARCHAR(1000)  not null,
	RULE_DESC NVARCHAR(4000)  not null,
	RULE_ENABLE numeric(1) default 1 not null,
	constraint PK_GP_RULE primary Key (HIS_RULE_CODE,GAME_CODE,RULE_CODE)
);
create table tkws.GP_WIN_RULE(
	HIS_WIN_CODE numeric(8)  not null,
	HIS_MODIFY_DATE DATETIME  ,
	GAME_CODE numeric(3)  not null,
	WRULE_CODE numeric(3)  not null,
	WRULE_NAME NVARCHAR(1000)  not null,
	WRULE_DESC NVARCHAR(4000)  not null,
	constraint PK_GP_WRULE primary Key (HIS_WIN_CODE,GAME_CODE,WRULE_CODE)
);
create table tkws.GP_PRIZE_RULE(
	HIS_PRIZE_CODE numeric(8)  not null,
	HIS_MODIFY_DATE DATETIME  ,
	GAME_CODE numeric(3)  not null,
	PRULE_LEVEL numeric(3)  not null,
	PRULE_NAME NVARCHAR(1000)  ,
	PRULE_DESC NVARCHAR(4000)  ,
	LEVEL_PRIZE numeric(16)  ,
	DISP_ORDER numeric(2)  ,
	constraint PK_GP_PRIZE_RULE primary Key (HIS_PRIZE_CODE,GAME_CODE,PRULE_LEVEL)
);
create table tkws.ISS_GAME_ISSUE(
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	ISSUE_SEQ numeric(12)  ,
	ISSUE_STATUS numeric(2)  not null,
	IS_PUBLISH numeric(2)  ,
	DRAW_STATE numeric(2)  ,
	PLAN_START_TIME DATETIME  ,
	PLAN_CLOSE_TIME DATETIME  ,
	PLAN_REWARD_TIME DATETIME  ,
	REAL_START_TIME DATETIME  ,
	REAL_CLOSE_TIME DATETIME  ,
	REAL_REWARD_TIME DATETIME  ,
	ISSUE_END_TIME DATETIME  ,
	CODE_INPUT_METHOLD numeric(1)  ,
	FIRST_DRAW_USER_ID numeric(10)  ,
	FIRST_DRAW_NUMBER NVARCHAR(100)  ,
	SECOND_DRAW_USER_ID numeric(10)  ,
	SECOND_DRAW_NUMBER NVARCHAR(100)  ,
	FINAL_DRAW_NUMBER NVARCHAR(100)  ,
	FINAL_DRAW_USER_ID numeric(10)  ,
	PAY_END_DAY numeric(16)  ,
	POOL_START_AMOUNT numeric(16)  ,
	POOL_CLOSE_AMOUNT numeric(16)  ,
	ISSUE_SALE_AMOUNT numeric(16)  ,
	ISSUE_SALE_TICKETS numeric(16)  ,
	ISSUE_SALE_BETS numeric(16)  ,
	ISSUE_CANCEL_AMOUNT numeric(16)  ,
	ISSUE_CANCEL_TICKETS numeric(16)  ,
	ISSUE_CANCEL_BETS numeric(16)  ,
	WINNING_AMOUNT numeric(16)  ,
	WINNING_BETS numeric(16)  ,
	WINNING_TICKETS numeric(16)  ,
	WINNING_AMOUNT_BIG numeric(16)  ,
	WINNING_TICKETS_BIG numeric(16)  ,
	ISSUE_RICK_AMOUNT numeric(16)  ,
	ISSUE_RICK_TICKETS numeric(16)  ,
	WINNING_RESULT NVARCHAR(200)  ,
	REWARDING_ERROR_CODE numeric(4)  ,
	REWARDING_ERROR_MESG NVARCHAR(200)  ,
	CALC_WINNING_CODE NVARCHAR(100)  ,
	constraint PK_ISS_GAME_ISSUE primary Key (GAME_CODE,ISSUE_NUMBER)
);
create table tkws.ISS_GAME_ISSUE_XML(
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	WINNING_BRODCAST TEXT ,
	WINNER_LOCAL_INFO TEXT  ,
	WINNER_CONFIRM_INFO TEXT  ,
   JSON_WINNING_BRODCAST TEXT,
	WINNING_PROCESS NVARCHAR(100)  ,
	constraint PK_ISS_GAME_ISSUE_XML primary Key (GAME_CODE,ISSUE_NUMBER)
);
create table tkws.ISS_GAME_ISSUE_MODULE(
	GAME_CODE numeric(3)  not null,
	XML_CONTENT NVARCHAR(4000)  ,
  ISSUE_NUMBER	numeric(12),
	constraint PK_ISS_GAME_ISSUE_MODULE primary Key (GAME_CODE)
);
create table tkws.ISS_CURRENT_PARAM(
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	HIS_HIS_CODE numeric(8)  not null,
	HIS_POLICY_CODE numeric(8)  not null,
	HIS_RULE_CODE numeric(8)  not null,
	HIS_WIN_CODE numeric(8)  not null,
	HIS_PRIZE_CODE numeric(8)  not null,
	constraint PK_ISS_CP primary Key (GAME_CODE,ISSUE_NUMBER)
);
create table tkws.ISS_GAME_PRIZE_RULE(
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	PRIZE_LEVEL numeric(3)  not null,
	PRIZE_NAME NVARCHAR(1000)  ,
	LEVEL_PRIZE numeric(16)  not null,
	DISP_ORDER numeric(2)  ,
	constraint PK_ISS_GAME_PRIZE_RULE primary Key (GAME_CODE,ISSUE_NUMBER,PRIZE_LEVEL)
);
create table tkws.ISS_PRIZE(
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	PRIZE_LEVEL numeric(3)  not null,
	PRIZE_NAME NVARCHAR(1000)  ,
	IS_HD_PRIZE numeric(1)  not null,
	PRIZE_COUNT numeric(8)  not null,
	SINGLE_BET_REWARD numeric(16)  not null,
	SINGLE_BET_REWARD_TAX numeric(16)  ,
	TAX numeric(16)  ,
	constraint PK_ISS_PRIZE primary Key (GAME_CODE,ISSUE_NUMBER,PRIZE_LEVEL)
);
create table tkws.ISS_GAME_POLICY_FUND(
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	SALE_AMOUNT numeric(28)  ,
	THEORY_WIN_AMOUNT numeric(28)  ,
	FUND_AMOUNT numeric(28)  ,
	COMM_AMOUNT numeric(28)  ,
	ADJ_FUND numeric(28)  ,
	constraint PK_ISS_GAME_POLICY_FUND primary Key (GAME_CODE,ISSUE_NUMBER)
);
create table tkws.ISS_GAME_POOL(
	GAME_CODE numeric(3)  not null,
	POOL_CODE numeric(1)  not null,
	POOL_NAME NVARCHAR(1000)  ,
	POOL_AMOUNT_BEFORE numeric(28)  ,
	POOL_AMOUNT_AFTER numeric(28)  ,
	ADJ_TIME DATETIME  ,
	POOL_DESC NVARCHAR(4000)  ,
	constraint PK_ISS_GAME_POOL primary Key (GAME_CODE,POOL_CODE)
);
create table tkws.ISS_GAME_POOL_ADJ(
	POOL_FLOW CHAR(32)  not null,
	GAME_CODE numeric(3)  not null,
	POOL_CODE numeric(1)  not null,
	POOL_ADJ_TYPE numeric(1)  not null,
	ADJ_AMOUNT numeric(28)  not null,
	POOL_AMOUNT_BEFORE numeric(28)  ,
	POOL_AMOUNT_AFTER numeric(28)  ,
	ADJ_DESC NVARCHAR(1000)  ,
	ADJ_TIME DATETIME  ,
	ADJ_ADMIN numeric(4)  not null,
	IS_ADJ numeric(1) default 1 not null,
	constraint PK_ISS_GAME_POOL_ADJ primary Key (POOL_FLOW)
);
create table tkws.ISS_GAME_POOL_HIS(
	HIS_CODE numeric(8)  not null,
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	POOL_CODE numeric(1)  not null,
	CHANGE_AMOUNT numeric(28)  not null,
	POOL_AMOUNT_BEFORE numeric(28)  not null,
	POOL_AMOUNT_AFTER numeric(28)  not null,
	ADJ_TIME DATETIME not null,
	POOL_ADJ_TYPE numeric(1)  not null,
	ADJ_REASON NVARCHAR(1000)  ,
	POOL_FLOW CHAR(32)  ,
	constraint PK_ISS_GAME_POOL_HIS primary Key (HIS_CODE)
);
create table tkws.ADJ_GAME_CURRENT(
	GAME_CODE numeric(3)  not null,
	POOL_AMOUNT_BEFORE numeric(28)  ,
	POOL_AMOUNT_AFTER numeric(28)  ,
	constraint PK_ADJ_GAME_CURRENT primary Key (GAME_CODE)
);
create table tkws.ADJ_GAME_CHANGE(
	ADJ_FLOW CHAR(32)  not null,
	GAME_CODE numeric(3)  not null,
	ADJ_AMOUNT numeric(28)  not null,
	ADJ_AMOUNT_BEFORE numeric(28)  not null,
	ADJ_AMOUNT_AFTER numeric(28)  not null,
	ADJ_CHANGE_TYPE numeric(1)  not null,
	ADJ_DESC NVARCHAR(1000)  ,
	ADJ_TIME DATETIME  not null,
	ADJ_ADMIN numeric(4)  not null,
	constraint PK_ADJ_GAME_CHANGE primary Key (ADJ_FLOW)
);
create table tkws.ADJ_GAME_HIS(
	HIS_CODE numeric(8)  not null,
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	ADJ_CHANGE_TYPE numeric(1)  not null,
	ADJ_AMOUNT numeric(28)  not null,
	ADJ_AMOUNT_BEFORE numeric(28)  not null,
	ADJ_AMOUNT_AFTER numeric(28)  not null,
	ADJ_TIME DATETIME not null,
	ADJ_REASON NVARCHAR(1000)  ,
	ADJ_FLOW CHAR(32)  ,
	constraint PK_ADJ_GAME_HIS primary Key (HIS_CODE)
);
create table tkws.GOV_COMMISION(
	HIS_CODE numeric(8)  not null,
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	COMM_CHANGE_TYPE numeric(1)  not null,
	ADJ_AMOUNT numeric(28)  not null,
	ADJ_AMOUNT_BEFORE numeric(28)  not null,
	ADJ_AMOUNT_AFTER numeric(28)  not null,
	ADJ_TIME DATETIME not null,
	ADJ_REASON NVARCHAR(1000)  ,
	constraint PK_GOV_COMMISION primary Key (HIS_CODE)
);
create table tkws.COMMONWEAL_FUND(
	HIS_CODE numeric(8)  not null,
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	CWFUND_CHANGE_TYPE numeric(1)  not null,
	ADJ_AMOUNT numeric(28)  not null,
	ADJ_AMOUNT_BEFORE numeric(28)  not null,
	ADJ_AMOUNT_AFTER numeric(28)  not null,
	ADJ_TIME DATETIME not null,
	ADJ_REASON NVARCHAR(1000)  ,
	constraint PK_GOV_PUB_FUND primary Key (HIS_CODE)
);
create table tkws.SALER_TERMINAL(
	TERMINAL_CODE CHAR(10)  not null,
	AGENCY_CODE CHAR(8)  not null,
	UNIQUE_CODE NVARCHAR(20)  ,
	TERM_TYPE_ID numeric(4)  ,
	MAC_ADDRESS NVARCHAR(20)  not null,
	SECURITY_ID NVARCHAR(32)  ,
	STATUS numeric(1) default 0 not null,
	TERMINAL_FOR_PAYMENT numeric(1) default 0 not null,
	IS_LOGGING numeric(1) default 0 not null,
	LATEST_LOGIN_TELLER_CODE numeric(10)  ,
	TRANS_SEQ numeric(18) default 1 not null,
	constraint PK_SALER_TERMINAL primary Key (TERMINAL_CODE)
);
create table tkws.SALER_AGENCY_ICON(
	ID numeric(16)  not null,
	ICON NVARCHAR(20)  ,
	ADMIN NVARCHAR(4000)  ,
	constraint PK_SALER_AGENCY_ICON primary Key (ID)
);
create table tkws.SALER_AGENCY_SITE(
	AGENCY_CODE CHAR(8)  not null,
	AGENCY_ICON numeric(16)  ,
	GLATLNG_N NVARCHAR(20)  ,
	GLATLNG_E NVARCHAR(20)  ,
	AGENCY_PART numeric(1)  ,
	constraint PK_SALER_AGENCY_SITE primary Key (AGENCY_CODE)
);
create table tkws.SALER_TERMINAL_CHECK(
	TERM_CHECK_ID numeric(8)  not null,
	TERMINAL_CODE CHAR(10)  not null,
	COLLECTER_ID numeric(4)  not null,
	CHECK_TIME DATETIME  not null,
	AGENCY_BALANCE numeric(12)  not null,
	CHECK_BALANCE numeric(1)  not null,
	CHECK_TERMINAL numeric(1)  not null,
	constraint PK_SALER_TERMINAL_CHECK primary Key (TERM_CHECK_ID)
);
create table tkws.AUTH_ORG(
	ORG_CODE CHAR(2)  not null,
	GAME_CODE numeric(3)  not null,
	PAY_COMMISSION_RATE numeric(8) default 0 not null,
	SALE_COMMISSION_RATE numeric(8) default 0 not null,
	AUTH_TIME DATETIME not null,
	ALLOW_PAY numeric(1) default 1 not null,
	ALLOW_SALE numeric(1) default 1 not null,
	ALLOW_CANCEL numeric(1) default 0 not null,
	constraint PK_AUTH_ORG primary Key (ORG_CODE,GAME_CODE)
);
create table tkws.AUTH_AGENCY(
	AGENCY_CODE CHAR(8)  not null,
	GAME_CODE numeric(3)  not null,
	PAY_COMMISSION_RATE numeric(8) default 0 not null,
	SALE_COMMISSION_RATE numeric(8) default 0 not null,
	ALLOW_PAY numeric(1) default 1 not null,
	ALLOW_SALE numeric(1) default 1 not null,
	ALLOW_CANCEL numeric(1) default 0 not null,
	CLAIMING_SCOPE numeric(1)  ,
	AUTH_TIME DATETIME not null,
	constraint PK_AUTH_AGENCY primary Key (AGENCY_CODE,GAME_CODE)
);
create table tkws.SALE_GAMEPAYINFO(
	GUI_PAY_FLOW CHAR(24)  not null,
	PAY_TSN CHAR(24)  ,
	SALE_TSN CHAR(24)  not null,
	APPLYFLOW_SALE CHAR(24)  not null,
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	ISSUE_NUMBER_END numeric(12)  ,
	PAY_AMOUNT numeric(28)  not null,
	PAY_TAX numeric(28)  not null,
	PAY_AMOUNT_AFTER_TAX numeric(28)  not null,
	WINNERNAME NVARCHAR(1000)  ,
	GENDER numeric(1)  ,
	CERT_TYPE numeric(2)  ,
	CERT_NO NVARCHAR(50)  ,
	AGE numeric(2)  ,
	BIRTHDATE NVARCHAR(12)  ,
	CONTACT NVARCHAR(4000)  ,
	ORG_CODE CHAR(2)  ,
	PAYER_ADMIN numeric(4)  ,
	PAYER_NAME NVARCHAR(1000)  ,
	PAY_TIME DATETIME  ,
	PAY_ADDR NVARCHAR(4000)  ,
	IS_SUCCESS numeric(1) default 0 not null,
	HTML_TEXT NVARCHAR(4000)  ,
	constraint PK_SALE_GAMEPAYINFO primary Key (GUI_PAY_FLOW)
);
create table tkws.SALE_CANCELINFO(
	GUI_CANCEL_FLOW CHAR(24)  not null,
	SALE_TSN CHAR(24)  not null,
	APPLYFLOW_SELL CHAR(24)  not null,
	CANCEL_TSN CHAR(24)  ,
	SALE_AGENCY_CODE CHAR(8)  not null,
	CANCEL_ORG_CODE CHAR(2)  not null,
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	CANCEL_AMOUNT numeric(28)  not null,
	CANCEL_COMM numeric(28)  not null,
	CANCELER_ADMIN numeric(4)  not null,
	CANCELER_NAME NVARCHAR(1000)  ,
	CANCEL_TIME DATETIME  not null,
	IS_SUCCESS numeric(1) default 0 not null,
	HTML_TEXT NVARCHAR(4000)  ,
	constraint PK_SALE_CANCELINFO primary Key (GUI_CANCEL_FLOW)
);
create table tkws.UPG_SOFTWARE(
	SOFT_ID numeric(8)  not null,
	SOFT_NAME NVARCHAR(1000)  ,
	SOFT_DESCRIBE NVARCHAR(1000)  ,
	CREATE_DATE DATETIME  ,
	constraint PK_UPG_SOFTWARE primary Key (SOFT_ID)
);
create table tkws.UPG_SOFTWARE_VER(
	SOFT_VER NVARCHAR(20)  not null,
	SOFT_ID numeric(8)  not null,
	ADAPT_TERM_TYPE numeric(4)  not null,
	RELEASE_DATE DATETIME  ,
	VER_DESC NVARCHAR(1000)  ,
	VER_SIZE numeric(16)  ,
	VER_MD5 NVARCHAR(32)  ,
	constraint PK_UPG_SOFTWARE_VER primary Key (SOFT_VER,SOFT_ID,ADAPT_TERM_TYPE)
);
create table tkws.UPG_PKG_CONTEXT(
	PKG_VER NVARCHAR(20)  not null,
	SOFT_ID numeric(8)  not null,
	SOFT_VER NVARCHAR(20)  not null,
	ADAPT_TERM_TYPE numeric(4)  not null,
	constraint PK_UPG_PKG_CONTEXT primary Key (PKG_VER,SOFT_ID,SOFT_VER,ADAPT_TERM_TYPE)
);
create table tkws.UPG_PACKAGE(
	PKG_VER NVARCHAR(20)  not null,
	ADAPT_TERM_TYPE numeric(4)  not null,
	PKG_DESC NVARCHAR(1000)  ,
	RELEASE_DATE DATETIME  ,
	IS_VALID numeric(1) default 0 not null,
	constraint PK_UPG_PACKAGE primary Key (PKG_VER,ADAPT_TERM_TYPE)
);
create table tkws.UPG_TERM_SOFTWARE(
	TERMINAL_CODE CHAR(10)  not null,
	TERM_TYPE numeric(4)  not null,
	RUNNING_PKG_VER NVARCHAR(20)  ,
	DOWNING_PKG_VER NVARCHAR(20)  ,
	LAST_UPGRADE_DATE DATETIME  ,
	LAST_REPORT_DATE DATETIME  ,
	constraint PK_UPG_TERM_SOFTWARE primary Key (TERMINAL_CODE,TERM_TYPE)
);
create table tkws.UPG_UPGRADEPLAN(
	SCHEDULE_ID numeric(8)  not null,
	SCHEDULE_NAME NVARCHAR(4000)  ,
	PKG_VER NVARCHAR(20)  not null,
	TERM_TYPE numeric(4)  not null,
	SCHEDULE_STATUS numeric(1)  not null,
	SCHEDULE_SW_DATE DATETIME  ,
	SCHEDULE_CR_DATE DATETIME  not null,
	SCHEDULE_EXEC_DATE DATETIME  ,
	SCHEDULE_CANCEL_DATE DATETIME  ,
	constraint PK_UPG_UPGRADEPLAN primary Key (SCHEDULE_ID)
);
create table tkws.UPG_UPGRADEPROC(
	TERMINAL_CODE CHAR(10)  not null,
	SCHEDULE_ID numeric(8)  not null,
	PKG_VER NVARCHAR(20)  not null,
	IS_COMP_DL numeric(1) default 0 not null,
	DL_START_DATE DATETIME  ,
	DL_END_DATE DATETIME  ,
	DL_PROC NVARCHAR(20)  ,
	DL_FILENAME NVARCHAR(30)  ,
	constraint PK_UPG_UPGRADEPROC primary Key (TERMINAL_CODE,SCHEDULE_ID)
);
create table tkws.SYS_HOST_COMM_LOG(
	LOG_ID numeric(18)  not null,
	LOG_TIME DATETIME not null,
	LOG_INFO NVARCHAR(4000)  not null,
	LOG_STATUS numeric(1) default 0 not null,
	constraint PK_SYS_HOST_COMM_LOG primary Key (LOG_ID)
);
create table tkws.SYS_CALENDAR(
	H_DAY_CODE numeric(8)  not null,
	H_DAY_START DATETIME  not null,
	H_DAY_END DATETIME  not null,
	H_DAY_DESC NVARCHAR(1000)  ,
	constraint PK_SYS_CALENDAR primary Key (H_DAY_CODE)
);
create table tkws.SYS_INTERNAL_LOG(
	LOG_ID numeric(28)  not null,
	LOG_TYPE numeric(1)  not null,
	LOG_DATE TIMESTAMP  not null,
	LOG_DESC NVARCHAR(4000)  not null,
	constraint PK_SYS_INTERNAL_LOG primary Key (LOG_ID)
);
create table tkws.SYS_CLOG_INFO(
	SYS_CLOG_SEQ numeric(16)  not null,
	TERMINAL_CODE CHAR(10)  not null,
	SYS_CLOG_APPLY_TIME DATETIME  not null,
	SYS_CLOG_APPLY_TYPE numeric(1)  not null,
	SYS_CLOG_APPLY_ARG1 NVARCHAR(500)  not null,
	SYS_CLOG_APPLY_STATUS numeric(1) default 1 not null,
	SYS_CLOG_SUCC_TIME DATETIME  ,
	SYS_CLOG_UPLOAD_FILE NVARCHAR(500)  ,
	constraint PK_SYS_CLOG_INFO primary Key (SYS_CLOG_SEQ)
);
create table tkws.SYS_EVENTS(
	EVENT_ID numeric(16)  not null,
	SERVER_ADDR NVARCHAR(50)  not null,
	EVENT_TYPE numeric(1)  not null,
	EVENT_LEVEL numeric(1)  not null,
	EVENT_CONTENT NVARCHAR(4000)  not null,
	EVENT_TIME DATETIME not null,
	constraint PK_SYS_EVENTS primary Key (EVENT_ID)
);
create table tkws.MSG_INSTANT(
	NOTICE_ID numeric(8)  not null,
	CAST_STRING NVARCHAR(4000)  not null,
	SEND_ADMIN numeric(8)  not null,
	CONTENT NVARCHAR(4000)  not null,
	DISP_SECOND numeric(4)  not null,
	DISP_LOC numeric(1)  not null,
	CREATE_TIME DATETIME  not null,
	SEND_TIME DATETIME  ,
	constraint PK_MSG_INSTANT primary Key (NOTICE_ID)
);
create table tkws.MSG_AGENCY_BROCAST(
	NOTICE_ID numeric(8)  not null,
	CAST_STRING NVARCHAR(4000)  not null,
	SEND_ADMIN numeric(8)  not null,
	TITLE NVARCHAR(400)  not null,
	CONTENT NVARCHAR(4000)  not null,
	CREATE_TIME DATETIME  not null,
	SEND_TIME DATETIME  ,
	constraint PK_MSG_AGENCY_BROCAST primary Key (NOTICE_ID)
);
create table tkws.MSG_AGENCY_BROCAST_DETAIL(
	DETAIL_ID numeric(18)  not null,
	NOTICE_ID numeric(8)  not null,
	CAST_CODE numeric(12)  not null,
	constraint PK_MSG_AGENCY_BROCAST_DETAIL primary Key (DETAIL_ID)
);
create table tkws.SYS_TICKET_MEMO(
	HIS_CODE numeric(8)  not null,
	GAME_CODE numeric(3)  not null,
	TICKET_MEMO NVARCHAR(1000)  not null,
	SET_ADMIN numeric(4)  not null,
	SET_TIME DATETIME not null,
	constraint PK_SYS_TICKET_MEMO primary Key (HIS_CODE,GAME_CODE)
);
create table tkws.SYS_TERMINAL_ONLINE_TIME(
	TERMINAL_CODE CHAR(10)  not null,
	HOST_BEGIN_TIME_STAMP numeric(10)  not null,
	ONLINE_TIME numeric(10)  not null,
	RECORD_TIME DATETIME not null,
	RECORD_DAY NVARCHAR(10)  not null,
	constraint PK_SYS_TERM_ONLINE_TIME primary Key (TERMINAL_CODE,HOST_BEGIN_TIME_STAMP,RECORD_TIME)
);
create table tkws.HIS_SELLTICKET(
	APPLYFLOW_SELL CHAR(24)  not null,
	SALETIME DATETIME  not null,
	TERMINAL_CODE CHAR(10)  not null,
	TELLER_CODE numeric(8)  not null,
	AGENCY_CODE CHAR(8)  not null,
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	START_ISSUE numeric(12)  not null,
	END_ISSUE numeric(12)  not null,
	ISSUE_COUNT numeric(8)  not null,
	TICKET_AMOUNT numeric(16)  not null,
	TICKET_BET_COUNT numeric(8)  not null,
	SALECOMMISSIONRATE numeric(8)  not null,
	COMMISSIONAMOUNT numeric(16)  not null,
	SALECOMMISSIONRATE_O numeric(8)  not null,
	COMMISSIONAMOUNT_O numeric(16)  not null,
	BET_METHOLD numeric(4)  not null,
	BET_LINE numeric(4)  not null,
	LOYALTY_CODE NVARCHAR(50)  ,
	RESULT_CODE numeric(4)  not null,
	SALE_TSN NVARCHAR(24)  ,
	SELL_SEQ numeric(18) not null,
  TRANS_SEQ numeric(18) default 0 not null,
	constraint PK_HIS_SELL primary Key (APPLYFLOW_SELL)
);
create table tkws.HIS_SELLTICKET_DETAIL(
	APPLYFLOW_SELL CHAR(24)  not null,
	SALETIME DATETIME  not null,
	LINE_NO numeric(2)  not null,
	BET_TYPE numeric(4)  not null,
	SUBTYPE numeric(8)  not null,
	OPER_TYPE numeric(4)  not null,
	SECTION NVARCHAR(500)  not null,
	BET_AMOUNT numeric(8)  not null,
	BET_COUNT numeric(8)  not null,
	LINE_AMOUNT numeric(16)  not null,
	constraint PK_HIS_SELL_DETAIL primary Key (APPLYFLOW_SELL,LINE_NO)
);
create table tkws.HIS_SELLTICKET_MULTI_ISSUE(
	APPLYFLOW_SELL CHAR(24)  not null,
	constraint PK_HIS_SELL_MULTI_ISSUE primary Key (APPLYFLOW_SELL)
);
create table tkws.HIS_CANCELTICKET(
	APPLYFLOW_CANCEL CHAR(24)  not null,
	CANCELTIME DATETIME  not null,
	APPLYFLOW_SELL CHAR(24)  not null,
	TERMINAL_CODE CHAR(10)  ,
	TELLER_CODE numeric(8)  ,
	AGENCY_CODE CHAR(8)  ,
	IS_CENTER numeric(1)  not null,
	ORG_CODE CHAR(2)  ,
	CANCEL_SEQ numeric(18) not null,
  TRANS_SEQ numeric(18) default 0 not null,
	constraint PK_HIS_CANCEL primary Key (APPLYFLOW_CANCEL)
);
create table tkws.HIS_WIN_TICKET(
	APPLYFLOW_SELL CHAR(24)  not null,
	WINNING_TIME DATETIME  not null,
	TERMINAL_CODE CHAR(10)  ,
	TELLER_CODE numeric(8)  ,
	AGENCY_CODE CHAR(8)  ,
	GAME_CODE numeric(3)  ,
	ISSUE_NUMBER numeric(12)  ,
	TICKET_AMOUNT numeric(16)  ,
	IS_BIG_PRIZE numeric(1)  ,
	WIN_AMOUNT numeric(28) default 0 ,
	WIN_AMOUNT_WITHOUT_TAX numeric(28) default 0 ,
	TAX_AMOUNT numeric(28) default 0 ,
	WIN_BETS numeric(28) default 0 ,
	HD_WIN_AMOUNT numeric(28) default 0 ,
	HD_WIN_AMOUNT_WITHOUT_TAX numeric(28) default 0 ,
	HD_TAX_AMOUNT numeric(28) default 0 ,
	HD_WIN_BETS numeric(28) default 0 ,
	LD_WIN_AMOUNT numeric(28) default 0 ,
	LD_WIN_AMOUNT_WITHOUT_TAX numeric(28) default 0 ,
	LD_TAX_AMOUNT numeric(28) default 0 ,
	LD_WIN_BETS numeric(28) default 0 ,
	constraint PK_HIS_WIN primary Key (APPLYFLOW_SELL,GAME_CODE,ISSUE_NUMBER)
);
create table tkws.HIS_WIN_TICKET_DETAIL(
	APPLYFLOW_SELL CHAR(24)  not null,
	WINNNING_TIME DATETIME  not null,
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	SALE_AGENCY CHAR(8)  not null,
	PRIZE_LEVEL numeric(3)  not null,
	PRIZE_COUNT numeric(16)  not null,
	IS_HD_PRIZE numeric(1)  not null,
	WINNINGAMOUNTTAX numeric(16)  not null,
	WINNINGAMOUNT numeric(16)  not null,
	TAXAMOUNT numeric(16)  not null,
	WIN_SEQ numeric(18)  not null,
	constraint PK_HIS_WIN_DETAIL primary Key (APPLYFLOW_SELL,GAME_CODE,ISSUE_NUMBER,PRIZE_LEVEL)
);
create table tkws.HIS_PAYTICKET(
	APPLYFLOW_PAY CHAR(24)  not null,
	APPLYFLOW_SELL CHAR(24)  ,
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	TERMINAL_CODE CHAR(10)  ,
	TELLER_CODE numeric(8)  ,
	AGENCY_CODE CHAR(8)  ,
	IS_CENTER numeric(1)  not null,
	ORG_CODE CHAR(2)  ,
	PAYTIME DATETIME  not null,
	WINNINGAMOUNTTAX numeric(16)  not null,
	WINNINGAMOUNT numeric(16)  not null,
	TAXAMOUNT numeric(16)  not null,
	PAYCOMMISSIONRATE numeric(4)  not null,
	COMMISSIONAMOUNT numeric(16)  not null,
	PAYCOMMISSIONRATE_O numeric(4)  not null,
	COMMISSIONAMOUNT_O numeric(16)  not null,
	WINNINGCOUNT numeric(8)  not null,
	HD_WINNING numeric(16)  not null,
	HD_COUNT numeric(8)  not null,
	LD_WINNING numeric(16)  not null,
	LD_COUNT numeric(8)  not null,
	LOYALTY_CODE NVARCHAR(50)  ,
	IS_BIG_PRIZE numeric(1)  not null,
	PAY_SEQ numeric(18)  not null,
  TRANS_SEQ numeric(18) default 0 not null,
	constraint PK_HIS_PAY_TSN primary Key (APPLYFLOW_PAY)
);
create table tkws.HIS_ABANDON_TICKET(
	APPLYFLOW_SELL CHAR(24)  not null,
	ABANDON_TIME DATETIME  not null,
	WINNING_TIME DATETIME  not null,
	TERMINAL_CODE CHAR(10)  not null,
	TELLER_CODE numeric(8)  not null,
	AGENCY_CODE CHAR(8)  not null,
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	TICKET_AMOUNT numeric(16)  not null,
	IS_BIG_PRIZE numeric(1)  not null,
	WIN_AMOUNT numeric(28) default 0 ,
	WIN_AMOUNT_WITHOUT_TAX numeric(28) default 0 ,
	TAX_AMOUNT numeric(28) default 0 ,
	WIN_BETS numeric(28) default 0 ,
	HD_WIN_AMOUNT numeric(28) default 0 ,
	HD_WIN_AMOUNT_WITHOUT_TAX numeric(28) default 0 ,
	HD_TAX_AMOUNT numeric(28) default 0 ,
	HD_WIN_BETS numeric(28) default 0 ,
	LD_WIN_AMOUNT numeric(28) default 0 ,
	LD_WIN_AMOUNT_WITHOUT_TAX numeric(28) default 0 ,
	LD_TAX_AMOUNT numeric(28) default 0 ,
	LD_WIN_BETS numeric(28) default 0 ,
	constraint PK_HIS_GIVEUP primary Key (APPLYFLOW_SELL,GAME_CODE,ISSUE_NUMBER)
);
create table tkws.HIS_ABANDON_TICKET_DETAIL(
	APPLYFLOW_SELL CHAR(24)  not null,
	ABANDON_TIME DATETIME  not null,
	WINNING_TIME DATETIME  not null,
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	PRIZE_LEVEL numeric(3)  ,
	PRIZE_COUNT numeric(16)  ,
	IS_HD_PRIZE numeric(1)  ,
	WINNINGAMOUNTTAX numeric(16)  ,
	WINNINGAMOUNT numeric(16)  ,
	TAXAMOUNT numeric(16)  ,
	constraint PK_HIS_GIVEUP_DETAIL primary Key (APPLYFLOW_SELL,GAME_CODE,ISSUE_NUMBER,PRIZE_LEVEL)
);
create table tkws.HIS_DAY_SETTLE(
	SETTLE_ID numeric(10)  not null,
	OPT_DATE DATETIME  not null,
	SETTLE_DATE DATETIME  not null,
	SELL_SEQ numeric(18)  not null,
	CANCEL_SEQ numeric(18)  not null,
	PAY_SEQ numeric(18)  not null,
	WIN_SEQ numeric(18)  not null,
	constraint PK_HIS_DAY_SETTLE primary Key (SETTLE_ID)
);
create table tkws.HIS_SALER_AGENCY(
	SETTLE_ID numeric(10)  not null,
	AGENCY_CODE CHAR(8)  ,
	AGENCY_NAME NVARCHAR(1000)  ,
	STORETYPE_ID numeric(2)  ,
	STATUS numeric(1)  ,
	AGENCY_TYPE numeric(1)  ,
	BANK_ID numeric(4)  ,
	BANK_ACCOUNT NVARCHAR(32)  ,
	TELEPHONE NVARCHAR(100)  ,
	CONTACT_PERSON NVARCHAR(500)  ,
	ADDRESS NVARCHAR(4000)  ,
	AGENCY_ADD_TIME DATETIME  ,
	QUIT_TIME DATETIME  ,
	ORG_CODE CHAR(2)  ,
	AREA_CODE CHAR(4)  ,
	MARKET_MANAGER_ID numeric(4)  ,
	constraint PK_HIS_SALER_AGENCY primary Key (AGENCY_CODE,SETTLE_ID)
);
create table tkws.SUB_SELL(
	SALE_DATE CHAR(10)  not null,
	SALE_WEEK CHAR(7)  not null,
	SALE_MONTH CHAR(7)  not null,
	SALE_QUARTER CHAR(6)  not null,
	SALE_YEAR CHAR(4)  not null,
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	SALE_AGENCY CHAR(8)  not null,
	SALE_AREA CHAR(2)  not null,
	SALE_TELLER numeric(8)  not null,
	SALE_TERMINAL CHAR(10)  not null,
	BET_METHOLD numeric(4)  not null,
	LOYALTY_CODE NVARCHAR(50)  not null,
	RESULT_CODE numeric(4)  not null,
	SALE_AMOUNT numeric(28) default 0 ,
	SALE_BETS numeric(28) default 0 ,
	SALE_COMMISSION numeric(28) default 0 ,
	SALE_TICKETS numeric(28) default 0 ,
	SALE_LINES numeric(28) default 0 ,
	PURE_AMOUNT numeric(28) default 0 ,
	PURE_BETS numeric(28) default 0 ,
	PURE_COMMISSION numeric(28) default 0 ,
	PURE_TICKETS numeric(28) default 0 ,
	PURE_LINES numeric(28) default 0 ,
	SALE_AMOUNT_SINGLE_ISSUE numeric(28) default 0 ,
	SALE_BETS_SINGLE_ISSUE numeric(28) default 0 ,
	PURE_AMOUNT_SINGLE_ISSUE numeric(28) default 0 ,
	PURE_BETS_SINGLE_ISSUE numeric(28) default 0 ,
  SALE_COMMISION_SINGLE_ISSUE numeric(28) default 0 ,
  PURE_COMMISION_SINGLE_ISSUE numeric(28) default 0 ,
  constraint PK_SUB_SELL primary Key (SALE_DATE,SALE_WEEK,SALE_MONTH,SALE_QUARTER,SALE_YEAR,GAME_CODE,ISSUE_NUMBER,SALE_AREA,SALE_AGENCY,SALE_TELLER,SALE_TERMINAL,BET_METHOLD,LOYALTY_CODE,RESULT_CODE)
);
create table tkws.SUB_PAY(
	PAY_DATE CHAR(10),
	PAY_WEEK CHAR(7),
	PAY_MONTH CHAR(7),
	PAY_QUARTER CHAR(6),
	PAY_YEAR CHAR(4),
	GAME_CODE numeric(3),
	ISSUE_NUMBER numeric(12),
	PAY_AGENCY CHAR(8),
	PAY_ISSUE numeric(12),
	PAY_AREA CHAR(2),
	PAY_TELLER numeric(8),
	PAY_TERMINAL CHAR(10),
	LOYALTY_CODE NVARCHAR(50),
	IS_GUI_PAY numeric(1),
	IS_BIG_ONE numeric(1),
	PAY_AMOUNT numeric(28) default 0 ,
	PAY_AMOUNT_WITHOUT_TAX numeric(28) default 0 ,
	TAX_AMOUNT numeric(28) default 0 ,
	PAY_BETS numeric(28) default 0 ,
	HD_PAY_AMOUNT numeric(28) default 0 ,
	HD_PAY_AMOUNT_WITHOUT_TAX numeric(28) default 0 ,
	HD_TAX_AMOUNT numeric(28) default 0 ,
	HD_PAY_BETS numeric(28) default 0 ,
	LD_PAY_AMOUNT numeric(28) default 0 ,
	LD_PAY_AMOUNT_WITHOUT_TAX numeric(28) default 0 ,
	LD_TAX_AMOUNT numeric(28) default 0 ,
	LD_PAY_BETS numeric(28) default 0 ,
	PAY_COMMISSION numeric(28) default 0 ,
	PAY_TICKETS numeric(28) default 0
);
create table tkws.SUB_CANCEL(
	CANCEL_DATE CHAR(10),
	CANCEL_WEEK CHAR(7),
	CANCEL_MONTH CHAR(7),
	CANCEL_QUARTER CHAR(6),
	CANCEL_YEAR CHAR(4),
	GAME_CODE numeric(3),
	ISSUE_NUMBER numeric(12),
	CANCEL_AGENCY CHAR(8),
	CANCEL_AREA CHAR(2),
	CANCEL_TELLER numeric(8),
	CANCEL_TERMINAL CHAR(10),
	SALE_AGENCY CHAR(8),
	SALE_AREA CHAR(2),
	SALE_TELLER numeric(8),
	SALE_TERMINAL CHAR(10),
	LOYALTY_CODE NVARCHAR(50),
	IS_GUI_PAY numeric(1),
	CANCEL_AMOUNT numeric(28) default 0 ,
	CANCEL_BETS numeric(28) default 0 ,
	CANCEL_TICKETS numeric(28) default 0 ,
	CANCEL_COMMISSION numeric(28) default 0 ,
	CANCEL_LINES numeric(28) default 0
);
create table tkws.SUB_WIN(
	WINNING_DATE CHAR(10)  not null,
	WINNING_WEEK CHAR(7)  not null,
	WINNING_MONTH CHAR(7)  not null,
	WINNING_QUARTER CHAR(6)  not null,
	WINNING_YEAR CHAR(4)  not null,
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	SALE_AGENCY CHAR(8)  not null,
	SALE_AREA CHAR(2)  not null,
	SALE_TELLER numeric(8)  not null,
	SALE_TERMINAL CHAR(10)  not null,
	BET_METHOLD numeric(4)  not null,
	LOYALTY_CODE NVARCHAR(50)  not null,
	IS_BIG_ONE numeric(1)  not null,
	WIN_AMOUNT numeric(28) default 0 ,
	WIN_AMOUNT_WITHOUT_TAX numeric(28) default 0 ,
	TAX_AMOUNT numeric(28) default 0 ,
	WIN_BETS numeric(28) default 0 ,
	HD_WIN_AMOUNT numeric(28) default 0 ,
	HD_WIN_AMOUNT_WITHOUT_TAX numeric(28) default 0 ,
	HD_TAX_AMOUNT numeric(28) default 0 ,
	HD_WIN_BETS numeric(28) default 0 ,
	LD_WIN_AMOUNT numeric(28) default 0 ,
	LD_WIN_AMOUNT_WITHOUT_TAX numeric(28) default 0 ,
	LD_TAX_AMOUNT numeric(28) default 0 ,
	LD_WIN_BETS numeric(28) default 0 ,
	constraint PK_SUB_WIN primary Key (WINNING_DATE,WINNING_WEEK,WINNING_MONTH,WINNING_QUARTER,WINNING_YEAR,GAME_CODE,ISSUE_NUMBER,SALE_AREA,SALE_AGENCY,SALE_TELLER,SALE_TERMINAL,BET_METHOLD,LOYALTY_CODE,IS_BIG_ONE)
);
create table tkws.SUB_ABANDON(
	ABANDON_DATE CHAR(10)  not null,
	ABANDON_WEEK CHAR(7)  not null,
	ABANDON_MONTH CHAR(7)  not null,
	ABANDON_QUARTER CHAR(6)  not null,
	ABANDON_YEAR CHAR(4)  not null,
	GAME_CODE numeric(3)  not null,
	SALE_ISSUE numeric(12)  not null,
  WINNING_ISSUE numeric(12)  not null,
	WINNING_DATE DATETIME  ,
	SALE_AGENCY CHAR(8)  not null,
	SALE_AREA CHAR(2)  not null,
	SALE_TELLER numeric(8)  not null,
	SALE_TERMINAL CHAR(10)  not null,
	BET_METHOLD numeric(4)  not null,
	LOYALTY_CODE NVARCHAR(50)  not null,
	IS_BIG_ONE numeric(1)  not null,
	WIN_AMOUNT numeric(28) default 0 ,
	WIN_AMOUNT_WITHOUT_TAX numeric(28) default 0 ,
	TAX_AMOUNT numeric(28) default 0 ,
	WIN_BETS numeric(28) default 0 ,
	HD_WIN_AMOUNT numeric(28) default 0 ,
	HD_WIN_AMOUNT_WITHOUT_TAX numeric(28) default 0 ,
	HD_TAX_AMOUNT numeric(28) default 0 ,
	HD_WIN_BETS numeric(28) default 0 ,
	LD_WIN_AMOUNT numeric(28) default 0 ,
	LD_WIN_AMOUNT_WITHOUT_TAX numeric(28) default 0 ,
	LD_TAX_AMOUNT numeric(28) default 0 ,
	LD_WIN_BETS numeric(28) default 0 ,
	constraint PK_SUB_ABANDON primary Key (ABANDON_DATE,GAME_CODE,SALE_ISSUE,WINNING_ISSUE,WINNING_DATE,SALE_AREA,SALE_AGENCY,SALE_TELLER,SALE_TERMINAL,BET_METHOLD,LOYALTY_CODE,IS_BIG_ONE)
);
create table tkws.SUB_AGENCY(
	CALC_DATE CHAR(10)  not null,
	CALC_WEEK CHAR(7)  not null,
	CALC_MONTH CHAR(7)  not null,
	CALC_QUARTER CHAR(6)  not null,
	CALC_YEAR CHAR(4)  not null,
	AGENCY_CODE CHAR(8)  not null,
	AREA_CODE CHAR(2)  not null,
	SALE_AMOUNT numeric(28) default 0 ,
	SALE_AMOUNT_WITHOUT_CANCEL numeric(28) default 0 ,
	CANCEL_AMOUNT numeric(28) default 0 ,
	PAY_AMOUNT numeric(28) default 0 ,
	SALE_COMMISSION numeric(28) default 0 ,
	PAY_COMMISSION numeric(28) default 0 ,
	RETURN_AMOUNT numeric(28) default 0 ,
	CHARGE_AMOUNT numeric(28) default 0 ,
	constraint PK_SUB_AGENCY primary Key (CALC_DATE,AGENCY_CODE)
);
create table tkws.SUB_AGENCY_ACTION(
	CALC_DATE CHAR(10)  not null,
	AGENCY_CODE CHAR(8)  not null,
	IS_SALED numeric(1)  not null,
	IS_LOGINED numeric(1)  not null,
	IS_PAID numeric(1)  not null,
	IS_CHARGED numeric(1)  not null,
	constraint PK_SUB_AGENCY_ACTION primary Key (CALC_DATE,AGENCY_CODE)
);
create table tkws.MIS_REPORT_3111(
	SALE_DATE DATETIME  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME NVARCHAR(1000)  not null,
	SALE_SUM numeric(28) default 0 not null,
	SALE_KOC6HC numeric(28) default 0 not null,
	SALE_KOCSSC numeric(28) default 0 not null,
	SALE_KOCKENO numeric(28) default 0 not null,
	SALE_KOCQ2 numeric(28) default 0 not null,
	constraint PK_MIS_REPORT_3111 primary Key (SALE_DATE,AREA_CODE)
);
create table tkws.MIS_REPORT_3112(
	PURGED_DATE DATETIME  not null,
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	WINNING_SUM numeric(28) default 0 not null,
	HD_PURGED_AMOUNT numeric(28) default 0 not null,
	LD_PURGED_AMOUNT numeric(28) default 0 not null,
	HD_PURGED_SUM numeric(28) default 0 not null,
	LD_PURGED_SUM numeric(28) default 0 not null,
	PURGED_AMOUNT numeric(28) default 0 not null,
	PURGED_RATE numeric(18) default 0 not null,
	constraint PK_MIS_REPORT_3112 primary Key (PURGED_DATE,GAME_CODE,ISSUE_NUMBER)
);
create table tkws.MIS_REPORT_3113(
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME NVARCHAR(1000)  not null,
	SALE_SUM numeric(28) default 0 not null,
	HD_WINNING_SUM numeric(28) default 0 not null,
	HD_WINNING_AMOUNT numeric(28) default 0 not null,
	LD_WINNING_SUM numeric(28) default 0 not null,
	LD_WINNING_AMOUNT numeric(28) default 0 not null,
	WINNING_SUM numeric(28) default 0 not null,
	WINNING_RATE numeric(28) default 0 not null,
	constraint PK_MIS_REPORT_3113 primary Key (GAME_CODE,ISSUE_NUMBER,AREA_CODE)
);
create table tkws.MIS_REPORT_3116(
	COUNT_DATE DATETIME  not null,
	AGENCY_CODE CHAR(8)  not null,
	AGENCY_TYPE numeric(4)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME NVARCHAR(1000)  not null,
	GAME_CODE numeric(3)  ,
	ISSUE_NUMBER numeric(12)  ,
	SALE_SUM numeric(28) default 0 not null,
	SALE_COMM_SUM numeric(28) default 0 not null,
	constraint PK_MIS_REPORT_3116 primary Key (COUNT_DATE,AGENCY_CODE,GAME_CODE,ISSUE_NUMBER)
);
create table tkws.MIS_REPORT_3117(
	PAY_TIME DATETIME  not null,
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	PAY_AMOUNT numeric(28)  not null,
	PAY_TAX numeric(28)  ,
	PAY_AMOUNT_AFTER_TAX numeric(28)  not null,
	PAY_TSN CHAR(24)  ,
	SALE_TSN CHAR(24)  ,
	GUI_PAY_FLOW CHAR(24)  not null,
	APPLYFLOW_SALE CHAR(24)  not null,
	WINNERNAME NVARCHAR(1000)  ,
	CERT_TYPE numeric(2) default 0 ,
	CERT_NO NVARCHAR(50)  ,
	AGENCY_CODE numeric(10)  not null,
	PAYER_ADMIN numeric(4)  ,
	constraint PK_MIS_REPORT_3117 primary Key (GUI_PAY_FLOW)
);
create table tkws.MIS_REPORT_NCP(
	COUNT_DATE DATETIME  not null,
	AGENCY_CODE CHAR(8)  not null,
	AGENCY_TYPE numeric(4)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME NVARCHAR(1000)  not null,
	GAME_CODE numeric(3)  ,
	ISSUE_NUMBER numeric(12)  ,
	SALE_SUM numeric(28) default 0 not null,
	SALE_COUNT numeric(28) default 0 not null,
	CANCEL_SUM numeric(28) default 0 not null,
	CANCEL_COUNT numeric(28) default 0 not null,
	PAY_SUM numeric(28) default 0 not null,
	PAY_COUNT numeric(28) default 0 not null,
	SALE_COMM_SUM numeric(28) default 0 not null,
	PAY_COMM_COUNT numeric(28) default 0 not null,
	constraint PK_MIS_REPORT_NCP primary Key (COUNT_DATE,AGENCY_CODE,GAME_CODE,ISSUE_NUMBER)
);
create table tkws.MIS_REPORT_3121(
	SALE_YEAR numeric(4)  not null,
	GAME_CODE numeric(3)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME NVARCHAR(1000)  not null,
	SALE_SUM numeric(28) default 0 not null,
	SALE_SUM_1 numeric(28) default 0 not null,
	SALE_SUM_2 numeric(28) default 0 not null,
	SALE_SUM_3 numeric(28) default 0 not null,
	SALE_SUM_4 numeric(28) default 0 not null,
	SALE_SUM_5 numeric(28) default 0 not null,
	SALE_SUM_6 numeric(28) default 0 not null,
	SALE_SUM_7 numeric(28) default 0 not null,
	SALE_SUM_8 numeric(28) default 0 not null,
	SALE_SUM_9 numeric(28) default 0 not null,
	SALE_SUM_10 numeric(28) default 0 not null,
	SALE_SUM_11 numeric(28) default 0 not null,
	SALE_SUM_12 numeric(28) default 0 not null,
	constraint PK_MIS_REPORT_3121 primary Key (SALE_YEAR,GAME_CODE,AREA_CODE)
);
create table tkws.MIS_REPORT_3122(
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME NVARCHAR(1000)  not null,
	SALE_SUM numeric(28) default 0 not null,
	CANCEL_SUM numeric(28) default 0 not null,
	WIN_SUM numeric(28) default 0 not null,
	constraint PK_MIS_REPORT_3122 primary Key (GAME_CODE,ISSUE_NUMBER,AREA_CODE)
);
create table tkws.MIS_REPORT_3123(
	PAY_DATE DATETIME  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME NVARCHAR(1000)  not null,
	KOC6HC_PAYMENT_SUM numeric(28) default 0 not null,
	KOC6HC_PAYMENT_TICKET numeric(28) default 0 not null,
	KOCSSC_PAYMENT_SUM numeric(28) default 0 not null,
	KOCSSC_PAYMENT_TICKET numeric(28) default 0 not null,
	KOCKENO_PAYMENT_SUM numeric(28) default 0 not null,
	KOCKENO_PAYMENT_TICKET numeric(28) default 0 not null,
	KOCQ2_PAYMENT_SUM numeric(28) default 0 not null,
	KOCQ2_PAYMENT_TICKET numeric(28) default 0 not null,
	PAYMENT_SUM numeric(28) default 0 not null,
	constraint PK_MIS_REPORT_3123 primary Key (PAY_DATE,AREA_CODE)
);
create table tkws.MIS_REPORT_3124(
	GAME_CODE numeric(3)  not null,
	PAY_DATE DATETIME  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME NVARCHAR(1000)  not null,
	HD_PAYMENT_SUM numeric(28) default 0 not null,
	HD_PAYMENT_AMOUNT numeric(28) default 0 not null,
	HD_PAYMENT_TAX numeric(28) default 0 not null,
	LD_PAYMENT_SUM numeric(28) default 0 not null,
	LD_PAYMENT_AMOUNT numeric(28) default 0 not null,
	LD_PAYMENT_TAX numeric(28) default 0 not null,
	PAYMENT_SUM numeric(28) default 0 not null,
	constraint PK_MIS_REPORT_3124 primary Key (GAME_CODE,PAY_DATE,AREA_CODE)
);
create table tkws.MIS_REPORT_3125(
	SALE_DATE DATETIME  not null,
	GAME_CODE numeric(3)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME NVARCHAR(1000)  not null,
	SALE_SUM numeric(28) default 0 not null,
	SALE_COUNT numeric(28) default 0 not null,
	SALE_BET numeric(28) default 0 not null,
	SINGLE_TICKET_AMOUNT numeric(28) default 0 not null,
	constraint PK_MIS_REPORT_3125 primary Key (SALE_DATE,GAME_CODE,AREA_CODE)
);
create table tkws.MIS_AGENCY_WIN_STAT(
	AGENCY_CODE CHAR(8)  not null,
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	PRIZE_LEVEL numeric(3)  not null,
	PRIZE_NAME NVARCHAR(1000)  not null,
	IS_HD_PRIZE numeric(1) default 0 not null,
	WINNING_COUNT numeric(16) default 0 not null,
	SINGLE_BET_REWARD numeric(16) default 0 not null,
	constraint PK_MIS_AGENCY_WIN_STAT primary Key (AGENCY_CODE,GAME_CODE,ISSUE_NUMBER,PRIZE_LEVEL)
);
create table tkws.MIS_REPORT_GUI_ABAND(
	PAY_DATE DATETIME  not null,
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	PRIZE_LEVEL numeric(3)  ,
	PRIZE_BET_COUNT numeric(16)  ,
	PRIZE_TICKET_COUNT numeric(16)  ,
	IS_HD_PRIZE numeric(1)  ,
	WINNINGAMOUNTTAX numeric(16)  ,
	WINNINGAMOUNT numeric(16)  ,
	TAXAMOUNT numeric(16)  ,
	constraint PK_MIS_REPORT_GUI_ABANDON primary Key (PAY_DATE,GAME_CODE,ISSUE_NUMBER,PRIZE_LEVEL)
);
create table tkws.CALC_RST_3113(
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME NVARCHAR(4000),
	SALE_SUM numeric(28) default 0 not null,
	HD_WINNING_SUM numeric(28) default 0 not null,
	HD_WINNING_AMOUNT numeric(28) default 0 not null,
	LD_WINNING_SUM numeric(28) default 0 not null,
	LD_WINNING_AMOUNT numeric(28) default 0 not null,
	WINNING_SUM numeric(28) default 0 not null,
	WINNING_RATE numeric(28) default 0 not null,
   CALC_DATE DATETIME not null,
	constraint PK_CALC_REPORT_3113 primary Key (GAME_CODE,ISSUE_NUMBER,AREA_CODE,CALC_DATE)
);
create table tkws.CALC_RST_3121(
	SALE_YEAR numeric(4)  not null,
	GAME_CODE numeric(3)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME NVARCHAR(4000),
	SALE_SUM numeric(28) default 0 not null,
	SALE_SUM_1 numeric(28) default 0 not null,
	SALE_SUM_2 numeric(28) default 0 not null,
	SALE_SUM_3 numeric(28) default 0 not null,
	SALE_SUM_4 numeric(28) default 0 not null,
	SALE_SUM_5 numeric(28) default 0 not null,
	SALE_SUM_6 numeric(28) default 0 not null,
	SALE_SUM_7 numeric(28) default 0 not null,
	SALE_SUM_8 numeric(28) default 0 not null,
	SALE_SUM_9 numeric(28) default 0 not null,
	SALE_SUM_10 numeric(28) default 0 not null,
	SALE_SUM_11 numeric(28) default 0 not null,
	SALE_SUM_12 numeric(28) default 0 not null,
   CALC_DATE DATETIME not null,
	constraint PK_CALC_REPORT_3121 primary Key (SALE_YEAR,GAME_CODE,AREA_CODE,CALC_DATE)
);
create table tkws.CALC_RST_3122(
	GAME_CODE numeric(3)  not null,
	ISSUE_NUMBER numeric(12)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME NVARCHAR(4000),
	SALE_SUM numeric(28) default 0 not null,
	CANCEL_SUM numeric(28) default 0 not null,
	WIN_SUM numeric(28) default 0 not null,
   CALC_DATE DATETIME not null,
	constraint PK_CALC_REPORT_3122 primary Key (GAME_CODE,ISSUE_NUMBER,AREA_CODE,CALC_DATE)
);
