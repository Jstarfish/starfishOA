-- 用于计算开奖公告的临时表
create global temporary table tmp_calc_issue_broadcast (
   AGENCY_CODE  CHAR(8),
   PRIZE_LEVEL  NUMBER(3),
   WINNING_COUNT  NUMBER(16)
)
on commit delete rows;

/*****************************************************************/
/************************  MIS系统用   ***************************/

-- 包含所有期次的临时表（统计多期票时使用）
create global temporary table TMP_ALL_ISSUE(
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
  ISSUE_SEQ NUMBER(12)  ,
	REAL_START_TIME DATE  ,
	REAL_CLOSE_TIME DATE  ,
	REAL_REWARD_TIME DATE ,
	START_TIME DATE  ,            -- 包含时分秒的字段
	CLOSE_TIME DATE  ,            -- 包含时分秒的字段
	REWARD_TIME DATE              -- 包含时分秒的字段
)
on commit preserve rows;

-- 当天的销售期次（退票也是这个）
create global temporary table TMP_SELL_ISSUE(
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
   ISSUE_SEQ NUMBER(12)
)
on commit preserve rows;

-- 当天的开奖期次
create global temporary table TMP_WIN_ISSUE(
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
  ISSUE_SEQ NUMBER(12)
)
on commit preserve rows;

-- 当天的弃奖期次
create global temporary table TMP_ABAND_ISSUE(
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
  ISSUE_END_TIME DATE,
  ISSUE_SEQ NUMBER(12)
)
on commit preserve rows;

/******************************************************************************************************/
/*****************************          时段数据                               ************************/
/******************************************************************************************************/
create global temporary table TMP_SRC_SELL(
	APPLYFLOW_SELL CHAR(24)  not null,
	SALETIME DATE  not null,
	TERMINAL_CODE CHAR(10)  not null,
	teller_code number(8)  not null,
	AGENCY_CODE  CHAR(8)  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	START_ISSUE NUMBER(12)  not null,
	END_ISSUE NUMBER(12)  not null,
	ISSUE_COUNT NUMBER(8)  not null,
	TICKET_AMOUNT NUMBER(28)  not null,
	TICKET_BET_COUNT NUMBER(8)  not null,
	SALECOMMISSIONRATE NUMBER(8)  not null,
	COMMISSIONAMOUNT NUMBER(28)  not null,
	SALECOMMISSIONRATE_O NUMBER(8),
	COMMISSIONAMOUNT_O NUMBER(28),
	BET_METHOLD NUMBER(4)  not null,
	BET_LINE NUMBER(4)  not null,
	LOYALTY_CODE VARCHAR2(50)  ,
	RESULT_CODE NUMBER(4)  not null
)
on commit preserve rows;

create global temporary table TMP_SRC_SELL_DETAIL(
	APPLYFLOW_SELL CHAR(24)  not null,
	SALETIME DATE  not null,
	LINE_NO NUMBER(2)  not null,
	BET_TYPE NUMBER(4)  not null,
	SUBTYPE NUMBER(8)  not null,
	OPER_TYPE NUMBER(4)  not null,
	SECTION VARCHAR2(500)  not null,
	BET_AMOUNT NUMBER(8)  not null,
	BET_COUNT NUMBER(8)  not null,
	LINE_AMOUNT NUMBER(28)  not null
)
on commit preserve rows;

create global temporary table TMP_SRC_CANCEL(
	APPLYFLOW_CANCEL CHAR(24)  not null,
	CANCELTIME DATE  not null,
	APPLYFLOW_SELL CHAR(24)  not null,
	C_TERMINAL_CODE CHAR(10),
	C_teller_code number(8),
	C_AGENCY_CODE  CHAR(8),
  C_ORG_CODE  CHAR(2),
  IS_CENTER NUMBER(1),
	SALETIME DATE  not null,
	TERMINAL_CODE CHAR(10),
	teller_code number(8),
	AGENCY_CODE  CHAR(8),
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	TICKET_AMOUNT NUMBER(28)  not null,
	TICKET_BET_COUNT NUMBER(8)  not null,
	SALECOMMISSIONRATE NUMBER(4)  not null,
	COMMISSIONAMOUNT NUMBER(28)  not null,
	BET_METHOLD NUMBER(4)  not null,
	BET_LINE NUMBER(4)  not null,
	LOYALTY_CODE VARCHAR2(50)
)
on commit preserve rows;

create global temporary table TMP_SRC_WIN(
	APPLYFLOW_SELL CHAR(24)  not null,
	WINNING_TIME DATE  not null,
	TERMINAL_CODE CHAR(10)  ,
	teller_code number(8)  ,
	AGENCY_CODE  CHAR(8)  ,
	GAME_CODE NUMBER(3)  ,
	ISSUE_NUMBER NUMBER(12)  ,
	TICKET_AMOUNT NUMBER(28)  ,
	IS_BIG_PRIZE NUMBER(1)  ,
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
	LD_WIN_BETS NUMBER(28) default 0
)
on commit preserve rows;

create global temporary table TMP_SRC_PAY(
	APPLYFLOW_PAY CHAR(24)  not null,
	APPLYFLOW_SELL CHAR(24)  ,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12),
  PAY_ISSUE_NUMBER NUMBER(12),
	TERMINAL_CODE CHAR(10),
	teller_code number(8),
	AGENCY_CODE  CHAR(8),
  org_code char(2),
  IS_CENTER NUMBER(1),
	PAYTIME DATE  not null,
	WINNINGAMOUNTTAX NUMBER(28)  not null,
	WINNINGAMOUNT NUMBER(28)  not null,
	TAXAMOUNT NUMBER(28)  not null,
	PAYCOMMISSIONRATE NUMBER(4)  not null,
	COMMISSIONAMOUNT NUMBER(28)  not null,
	WINNINGCOUNT NUMBER(8)  not null,
	HD_WINNING NUMBER(28)  not null,
	HD_COUNT NUMBER(8)  not null,
	LD_WINNING NUMBER(28) default 0 not null,
	LD_COUNT NUMBER(8)  not null,
	LOYALTY_CODE VARCHAR2(50)  ,
	IS_BIG_PRIZE NUMBER(1)  not null
)
on commit preserve rows;

create global temporary table TMP_SRC_ABANDON(
	APPLYFLOW_SELL CHAR(24)  not null,
	ABANDON_TIME DATE  not null,
	WINNING_TIME DATE  not null,
	TERMINAL_CODE CHAR(10)  not null,
	teller_code number(8)  not null,
	AGENCY_CODE  CHAR(8)  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	TICKET_AMOUNT NUMBER(28)  not null,
	IS_BIG_PRIZE NUMBER(1)  not null,
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
	LD_WIN_BETS NUMBER(28) default 0
)
on commit preserve rows;

create global temporary table TMP_SRC_ABANDON_DETAIL(
	APPLYFLOW_SELL CHAR(24)  not null,
	ABANDON_TIME DATE  not null,
	WINNING_TIME DATE  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	PRIZE_LEVEL NUMBER(3)  ,
	PRIZE_COUNT NUMBER(28)  ,
	IS_HD_PRIZE NUMBER(1)  ,
	WINNINGAMOUNTTAX NUMBER(28)  ,
	WINNINGAMOUNT NUMBER(28)  ,
	TAXAMOUNT NUMBER(28)
)
on commit preserve rows;

create global temporary table TMP_AGENCY(
   AGENCY_CODE  CHAR(8)  not null,
   AGENCY_NAME VARCHAR2(4000)  ,
   STORETYPE_ID NUMBER(2)  ,
   org_CODE CHAR(2)  ,
   AREA_CODE CHAR(4)  ,
   STATUS NUMBER(1)  ,
   AGENCY_TYPE NUMBER(1)  ,
   BANK_ID NUMBER(4)  ,
   BANK_ACCOUNT VARCHAR2(32)  ,
   MARGINAL_CREDIT NUMBER(28)  ,
   AVAILABLE_CREDIT NUMBER(28)  ,
   TELEPHONE VARCHAR2(40)  ,
   CONTACT_PERSON VARCHAR2(200)  ,
   ADDRESS VARCHAR2(500)  ,
   AGENCY_ADD_TIME DATE,
   constraint PK_TMP_AGENCY primary Key (AGENCY_CODE)
)
on commit preserve rows;

/******************************************************************************************************/
/*****************************          多期票中间结果表                       ************************/
/******************************************************************************************************/
create global temporary table tmp_multi_sell(
	APPLYFLOW_SELL CHAR(24)  not null,
	SALETIME DATE  not null,
	TERMINAL_CODE CHAR(10)  not null,
	teller_code number(8)  not null,
	AGENCY_CODE  CHAR(8)  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	TICKET_AMOUNT NUMBER(28)  not null,
	TICKET_BET_COUNT NUMBER(8)  not null,
	SALECOMMISSIONRATE NUMBER(4)  not null,
	COMMISSIONAMOUNT NUMBER(28)  not null,
	SALECOMMISSIONRATE_O NUMBER(4),
	COMMISSIONAMOUNT_O NUMBER(28),
	BET_METHOLD NUMBER(4)  not null,
	BET_LINE NUMBER(4)  not null,
	LOYALTY_CODE VARCHAR2(50)  ,
	RESULT_CODE NUMBER(4)  not null
)
on commit preserve rows;

create global temporary table tmp_multi_pay(
	APPLYFLOW_PAY CHAR(24)  not null,
	APPLYFLOW_SELL CHAR(24)  ,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12),
  PAY_ISSUE_NUMBER NUMBER(12),
	TERMINAL_CODE CHAR(10),
	teller_code number(8),
	AGENCY_CODE  CHAR(8),
  org_code char(2),
  IS_CENTER NUMBER(1),
	PAYTIME DATE  not null,
	WINNINGAMOUNTTAX NUMBER(28)  not null,
	WINNINGAMOUNT NUMBER(28)  not null,
	TAXAMOUNT NUMBER(28)  not null,
	PAYCOMMISSIONRATE NUMBER(4)  not null,
	COMMISSIONAMOUNT NUMBER(28)  not null,
	WINNINGCOUNT NUMBER(8)  not null,
	HD_WINNING NUMBER(28)  not null,
	HD_COUNT NUMBER(8)  not null,
	LD_WINNING NUMBER(28) default 0 not null,
	LD_COUNT NUMBER(8)  not null,
	LOYALTY_CODE VARCHAR2(50)  ,
	IS_BIG_PRIZE NUMBER(1)  not null
)
on commit preserve rows;

create global temporary table tmp_multi_cancel(
	APPLYFLOW_CANCEL CHAR(24)  not null,
	CANCELTIME DATE  not null,
	APPLYFLOW_SELL CHAR(24),
	C_TERMINAL_CODE CHAR(10),
	C_teller_code number(8),
	C_AGENCY_CODE  CHAR(8),
  c_org_code char(2),
  IS_CENTER NUMBER(1),
	SALETIME DATE  not null,
	TERMINAL_CODE CHAR(10),
	teller_code number(8),
	AGENCY_CODE  CHAR(8),
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	TICKET_AMOUNT NUMBER(28)  not null,
	TICKET_BET_COUNT NUMBER(8)  not null,
	SALECOMMISSIONRATE NUMBER(4)  not null,
	COMMISSIONAMOUNT NUMBER(28)  not null,
	BET_METHOLD NUMBER(4)  not null,
	BET_LINE NUMBER(4)  not null,
	LOYALTY_CODE VARCHAR2(50)
)
on commit preserve rows;

/******************************************************************************************************/
/*****************************          统计结果                               ************************/
/******************************************************************************************************/

create global temporary table TMP_RST_3111(
	SALE_DATE DATE  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME VARCHAR2(4000),
	SALE_SUM NUMBER(28) default 0 not null,
	SALE_KOC6HC NUMBER(28) default 0 not null,
	SALE_KOCSSC NUMBER(28) default 0 not null,
	SALE_KOCKENO NUMBER(28) default 0 not null,
	SALE_KOCQ2 NUMBER(28) default 0 not null,
	constraint PK_TMP_REPORT_3111 primary Key (SALE_DATE,AREA_CODE)
)
on commit preserve rows;

create global temporary table TMP_RST_3112(
	PURGED_DATE DATE  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	WINNING_SUM NUMBER(28) default 0 not null,
	HD_PURGED_AMOUNT NUMBER(28) default 0 not null,
	LD_PURGED_AMOUNT NUMBER(28) default 0 not null,
	HD_PURGED_SUM NUMBER(28) default 0 not null,
	LD_PURGED_SUM NUMBER(28) default 0 not null,
	PURGED_AMOUNT NUMBER(28) default 0 not null,
	PURGED_RATE NUMBER(18) default 0 not null,
	constraint PK_TMP_REPORT_3112 primary Key (PURGED_DATE,GAME_CODE,ISSUE_NUMBER)
)
on commit preserve rows;

create global temporary table TMP_RST_3113(
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME VARCHAR2(4000),
	SALE_SUM NUMBER(28) default 0 not null,
	HD_WINNING_SUM NUMBER(28) default 0 not null,
	HD_WINNING_AMOUNT NUMBER(28) default 0 not null,
	LD_WINNING_SUM NUMBER(28) default 0 not null,
	LD_WINNING_AMOUNT NUMBER(28) default 0 not null,
	WINNING_SUM NUMBER(28) default 0 not null,
	WINNING_RATE NUMBER(28) default 0 not null,
	constraint PK_TMP_REPORT_3113 primary Key (GAME_CODE,ISSUE_NUMBER,AREA_CODE)
)
on commit preserve rows;

create global temporary table TMP_RST_3115(
	COUNT_DATE DATE  not null,
	COUNT_MONTH NUMBER(2)  ,
	COUNT_YEAR NUMBER(4)  ,
	AGENCY_CODE  CHAR(8)  not null,
	AGENCY_TYPE NUMBER(4)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME VARCHAR2(1000)  not null,
	BEFORE_AMOUNT NUMBER(28) default 0 not null,
	SALE_SUM NUMBER(28) default 0 not null,
	PURE_SUM NUMBER(28) default 0 not null,
	CANCEL_OUT NUMBER(28) default 0 not null,
	CANCEL_IN NUMBER(28) default 0 not null,
	CANCEL_OTHER NUMBER(28) default 0 not null,
	PAY_SUM NUMBER(28) default 0 not null,
	CHARGE_SUM NUMBER(28) default 0 not null,
	PURE_COMM_SUM NUMBER(28) default 0 not null,
	SETTLE_SUM NUMBER(28) default 0 not null,
	AFTER_AMOUNT NUMBER(28) default 0 not null,
	constraint PK_TMP_REPORT_3115 primary Key (COUNT_DATE,COUNT_MONTH,COUNT_YEAR,AGENCY_CODE)
)
on commit preserve rows;

create global temporary table TMP_RST_3116(
	COUNT_DATE DATE  not null,
	AGENCY_CODE  CHAR(8)  not null,
	AGENCY_TYPE NUMBER(4)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME VARCHAR2(1000)  not null,
	GAME_CODE NUMBER(3)  ,
	ISSUE_NUMBER NUMBER(12)  ,
	SALE_SUM NUMBER(28) default 0 not null,
	SALE_COMM_SUM NUMBER(28) default 0 not null,
	constraint PK_TMP_REPORT_3116 primary Key (COUNT_DATE,AGENCY_CODE,GAME_CODE,ISSUE_NUMBER)
)
on commit preserve rows;

create global temporary table TMP_RST_NCP(
	COUNT_DATE DATE  not null,
	AGENCY_CODE  CHAR(8)  not null,
	AGENCY_TYPE NUMBER(4)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME VARCHAR2(4000),
	GAME_CODE NUMBER(3),
	ISSUE_NUMBER NUMBER(12),
	SALE_SUM NUMBER(28) default 0 not null,
	SALE_COUNT NUMBER(28) default 0 not null,
	CANCEL_SUM NUMBER(28) default 0 not null,
	CANCEL_COUNT NUMBER(28) default 0 not null,
	PAY_SUM NUMBER(28) default 0 not null,
	PAY_COUNT NUMBER(28) default 0 not null,
	SALE_COMM_SUM NUMBER(28) default 0 not null,
	PAY_COMM_COUNT NUMBER(28) default 0 not null,
	constraint PK_TMP_REPORT_NCP primary Key (COUNT_DATE,AGENCY_CODE,GAME_CODE,ISSUE_NUMBER)
)
on commit preserve rows;

create global temporary table TMP_RST_3121(
	SALE_YEAR NUMBER(4)  not null,
	GAME_CODE NUMBER(3)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME VARCHAR2(4000),
	SALE_SUM NUMBER(28) default 0 not null,
	SALE_SUM_1 NUMBER(28) default 0 not null,
	SALE_SUM_2 NUMBER(28) default 0 not null,
	SALE_SUM_3 NUMBER(28) default 0 not null,
	SALE_SUM_4 NUMBER(28) default 0 not null,
	SALE_SUM_5 NUMBER(28) default 0 not null,
	SALE_SUM_6 NUMBER(28) default 0 not null,
	SALE_SUM_7 NUMBER(28) default 0 not null,
	SALE_SUM_8 NUMBER(28) default 0 not null,
	SALE_SUM_9 NUMBER(28) default 0 not null,
	SALE_SUM_10 NUMBER(28) default 0 not null,
	SALE_SUM_11 NUMBER(28) default 0 not null,
	SALE_SUM_12 NUMBER(28) default 0 not null,
	constraint PK_TMP_REPORT_3121 primary Key (SALE_YEAR,GAME_CODE,AREA_CODE)
)
on commit preserve rows;

create global temporary table TMP_RST_3122(
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME VARCHAR2(4000),
	SALE_SUM NUMBER(28) default 0 not null,
	CANCEL_SUM NUMBER(28) default 0 not null,
	WIN_SUM NUMBER(28) default 0 not null,
	constraint PK_TMP_REPORT_3122 primary Key (GAME_CODE,ISSUE_NUMBER,AREA_CODE)
)
on commit preserve rows;

create global temporary table TMP_RST_3123(
	PAY_DATE DATE  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME VARCHAR2(4000),
	KOC6HC_PAYMENT_SUM NUMBER(28) default 0 not null,
	KOC6HC_PAYMENT_TICKET NUMBER(28) default 0 not null,
	KOCSSC_PAYMENT_SUM NUMBER(28) default 0 not null,
	KOCSSC_PAYMENT_TICKET NUMBER(28) default 0 not null,
	KOCKENO_PAYMENT_SUM NUMBER(28) default 0 not null,
	KOCKENO_PAYMENT_TICKET NUMBER(28) default 0 not null,
	KOCQ2_PAYMENT_SUM NUMBER(28) default 0 not null,
	KOCQ2_PAYMENT_TICKET NUMBER(28) default 0 not null,
	PAYMENT_SUM NUMBER(28) default 0 not null,
	constraint PK_TMP_REPORT_3123 primary Key (PAY_DATE,AREA_CODE)
)
on commit preserve rows;

create global temporary table TMP_RST_3124(
	GAME_CODE NUMBER(3)  not null,
	PAY_DATE DATE  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME VARCHAR2(4000),
	HD_PAYMENT_SUM NUMBER(28) default 0 not null,
	HD_PAYMENT_AMOUNT NUMBER(28) default 0 not null,
	HD_PAYMENT_TAX NUMBER(28) default 0 not null,
	LD_PAYMENT_SUM NUMBER(28) default 0 not null,
	LD_PAYMENT_AMOUNT NUMBER(28) default 0 not null,
	LD_PAYMENT_TAX NUMBER(28) default 0 not null,
	PAYMENT_SUM NUMBER(28) default 0 not null,
	constraint PK_TMP_REPORT_3124 primary Key (GAME_CODE,PAY_DATE,AREA_CODE)
)
on commit preserve rows;

create global temporary table TMP_RST_3125(
	SALE_DATE DATE  not null,
	GAME_CODE NUMBER(3)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME VARCHAR2(4000),
	SALE_SUM NUMBER(28) default 0 not null,
	SALE_COUNT NUMBER(28) default 0 not null,
	SALE_BET NUMBER(28) default 0 not null,
	SINGLE_TICKET_AMOUNT NUMBER(28) default 0 not null,
	constraint PK_TMP_REPORT_3125 primary Key (SALE_DATE,GAME_CODE,AREA_CODE)
)
on commit preserve rows;

create global temporary table TMP_RST_WIN(
	AGENCY_CODE  CHAR(8)  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	PRIZE_LEVEL NUMBER(3)  not null,
	PRIZE_NAME VARCHAR2(4000)  not null,
	IS_HD_PRIZE NUMBER(1) default 0 not null,
	WINNING_COUNT NUMBER(28) default 0 not null,
	SINGLE_BET_REWARD NUMBER(28) default 0 not null,
	constraint PK_TMP_AGENCY_WIN_STAT primary Key (AGENCY_CODE,GAME_CODE,ISSUE_NUMBER,PRIZE_LEVEL)
)
on commit preserve rows;

create global temporary table TMP_RST_ABAND(
	PAY_DATE DATE  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	PRIZE_LEVEL NUMBER(3)  ,
	PRIZE_BET_COUNT NUMBER(28)  ,
	PRIZE_TICKET_COUNT NUMBER(28)  ,
	IS_HD_PRIZE NUMBER(1)  ,
	WINNINGAMOUNTTAX NUMBER(28)  ,
	WINNINGAMOUNT NUMBER(28)  ,
	TAXAMOUNT NUMBER(28)  ,
	constraint PK_TMP_REPORT_GUI_ABANDON primary Key (PAY_DATE,GAME_CODE,ISSUE_NUMBER,PRIZE_LEVEL)
)
on commit preserve rows;

