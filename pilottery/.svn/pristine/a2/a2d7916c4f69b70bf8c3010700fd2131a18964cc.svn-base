create table HIS_SELLTICKET(
	APPLYFLOW_SELL CHAR(24)  not null,
	SALETIME DATE  not null,
	TERMINAL_CODE CHAR(10)  not null,
	TELLER_CODE NUMBER(8)  not null,
	AGENCY_CODE CHAR(8)  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	START_ISSUE NUMBER(12)  not null,
	END_ISSUE NUMBER(12)  not null,
	ISSUE_COUNT NUMBER(8)  not null,
	TICKET_AMOUNT NUMBER(16)  not null,
	TICKET_BET_COUNT NUMBER(8)  not null,
	SALECOMMISSIONRATE NUMBER(8)  not null,
	COMMISSIONAMOUNT NUMBER(16)  not null,
	SALECOMMISSIONRATE_O NUMBER(8)  not null,
	COMMISSIONAMOUNT_O NUMBER(16)  not null,
	BET_METHOLD NUMBER(4)  not null,
	BET_LINE NUMBER(4)  not null,
	LOYALTY_CODE VARCHAR2(50)  ,
	RESULT_CODE NUMBER(4)  not null,
	SALE_TSN VARCHAR2(24)  ,
	SELL_SEQ NUMBER(18) not null,
  TRANS_SEQ NUMBER(18) default 0 not null,
	constraint PK_HIS_SELL primary Key (APPLYFLOW_SELL)
);
comment on table HIS_SELLTICKET is '售票信息';
comment on column HIS_SELLTICKET.APPLYFLOW_SELL is '售票请求流水';
comment on column HIS_SELLTICKET.SALETIME is '交易时间';
comment on column HIS_SELLTICKET.TERMINAL_CODE is '终端编码';
comment on column HIS_SELLTICKET.TELLER_CODE is '销售员编码';
comment on column HIS_SELLTICKET.AGENCY_CODE is '销售站编码';
comment on column HIS_SELLTICKET.GAME_CODE is '游戏编码';
comment on column HIS_SELLTICKET.ISSUE_NUMBER is '游戏期号';
comment on column HIS_SELLTICKET.START_ISSUE is '开始游戏期号';
comment on column HIS_SELLTICKET.END_ISSUE is '截止游戏期号';
comment on column HIS_SELLTICKET.ISSUE_COUNT is '连续购买期数';
comment on column HIS_SELLTICKET.TICKET_AMOUNT is '票面销售金额';
comment on column HIS_SELLTICKET.TICKET_BET_COUNT is '票总注数';
comment on column HIS_SELLTICKET.SALECOMMISSIONRATE is '售票佣金返还比例';
comment on column HIS_SELLTICKET.COMMISSIONAMOUNT is '售票佣金返还金额（厘）';
comment on column HIS_SELLTICKET.SALECOMMISSIONRATE_O is '售票佣金返还比例（代理商）';
comment on column HIS_SELLTICKET.COMMISSIONAMOUNT_O is '售票佣金返还金额（代理商）';
comment on column HIS_SELLTICKET.BET_METHOLD is '投注方法（1=键盘、2=投注单、3=重玩）';
comment on column HIS_SELLTICKET.BET_LINE is '投注行数量';
comment on column HIS_SELLTICKET.LOYALTY_CODE is '彩民卡编号';
comment on column HIS_SELLTICKET.RESULT_CODE is '处理结果(0=正常，28=超过风险控制)';
comment on column HIS_SELLTICKET.SALE_TSN is '售票TSN';
comment on column HIS_SELLTICKET.SELL_SEQ is '销售递增序号';
comment on column HIS_SELLTICKET.TRANS_SEQ is '交易序号';
create index IDX_HIS_SELL_SEQ on HIS_SELLTICKET(SELL_SEQ);

create table HIS_SELLTICKET_DETAIL(
	APPLYFLOW_SELL CHAR(24)  not null,
	SALETIME DATE  not null,
	LINE_NO NUMBER(2)  not null,
	BET_TYPE NUMBER(4)  not null,
	SUBTYPE NUMBER(8)  not null,
	OPER_TYPE NUMBER(4)  not null,
	SECTION VARCHAR2(500)  not null,
	BET_AMOUNT NUMBER(8)  not null,
	BET_COUNT NUMBER(8)  not null,
	LINE_AMOUNT NUMBER(16)  not null,
	constraint PK_HIS_SELL_DETAIL primary Key (APPLYFLOW_SELL,LINE_NO)
);
comment on table HIS_SELLTICKET_DETAIL is '售票明细信息';
comment on column HIS_SELLTICKET_DETAIL.APPLYFLOW_SELL is '售票请求流水';
comment on column HIS_SELLTICKET_DETAIL.SALETIME is '交易时间';
comment on column HIS_SELLTICKET_DETAIL.LINE_NO is '票面行号';
comment on column HIS_SELLTICKET_DETAIL.BET_TYPE is '投注方式（1=单式、2=复式、3=胆拖、4=包胆、5=和值、6=包串、7=包号、8=有序复式、9=范围（天天赢））';
comment on column HIS_SELLTICKET_DETAIL.SUBTYPE is '玩法（1-前后二（2D-C）、2-前后三（3D-C）、3-直选（4D）、4-前二（2D-A）、5-后二（2D-B）、6-前三（3D-A）、7-后三（3D-B））';
comment on column HIS_SELLTICKET_DETAIL.OPER_TYPE is '操作方式（机选、手选）';
comment on column HIS_SELLTICKET_DETAIL.SECTION is '投注区内容';
comment on column HIS_SELLTICKET_DETAIL.BET_AMOUNT is '投注倍数';
comment on column HIS_SELLTICKET_DETAIL.BET_COUNT is '投注注数';
comment on column HIS_SELLTICKET_DETAIL.LINE_AMOUNT is '投注行金额';

create table HIS_SELLTICKET_MULTI_ISSUE(
	APPLYFLOW_SELL CHAR(24)  not null,
	constraint PK_HIS_SELL_MULTI_ISSUE primary Key (APPLYFLOW_SELL)
);
comment on table HIS_SELLTICKET_MULTI_ISSUE is '多期票售票信息';
comment on column HIS_SELLTICKET_MULTI_ISSUE.APPLYFLOW_SELL is '售票请求流水';

create table HIS_CANCELTICKET(
	APPLYFLOW_CANCEL CHAR(24)  not null,
	CANCELTIME DATE  not null,
	APPLYFLOW_SELL CHAR(24)  not null,
	TERMINAL_CODE CHAR(10)  ,
	TELLER_CODE NUMBER(8)  ,
	AGENCY_CODE CHAR(8)  ,
	IS_CENTER NUMBER(1)  not null,
	ORG_CODE CHAR(2)  ,
	CANCEL_SEQ NUMBER(18) not null,
  TRANS_SEQ NUMBER(18) default 0 not null,
	constraint PK_HIS_CANCEL primary Key (APPLYFLOW_CANCEL)
);
comment on table HIS_CANCELTICKET is '彩票取消信息';
comment on column HIS_CANCELTICKET.APPLYFLOW_CANCEL is '退票请求流水号';
comment on column HIS_CANCELTICKET.CANCELTIME is '退票时间';
comment on column HIS_CANCELTICKET.APPLYFLOW_SELL is '售票请求流水号';
comment on column HIS_CANCELTICKET.TERMINAL_CODE is '退票终端编码';
comment on column HIS_CANCELTICKET.TELLER_CODE is '退票销售员编码';
comment on column HIS_CANCELTICKET.AGENCY_CODE is '退票销售站编码';
comment on column HIS_CANCELTICKET.IS_CENTER is '是否中心退票';
comment on column HIS_CANCELTICKET.ORG_CODE is '退票机构代码';
comment on column HIS_CANCELTICKET.CANCEL_SEQ is '退票递增序号';
comment on column HIS_CANCELTICKET.TRANS_SEQ is '交易序号';
create index IDX_HIS_CANCEL_SEQ on HIS_CANCELTICKET(CANCEL_SEQ);

create table HIS_WIN_TICKET(
	APPLYFLOW_SELL CHAR(24)  not null,
	WINNING_TIME DATE  not null,
	TERMINAL_CODE CHAR(10)  ,
	TELLER_CODE NUMBER(8)  ,
	AGENCY_CODE CHAR(8)  ,
	GAME_CODE NUMBER(3)  ,
	ISSUE_NUMBER NUMBER(12)  ,
	TICKET_AMOUNT NUMBER(16)  ,
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
	LD_WIN_BETS NUMBER(28) default 0 ,
	constraint PK_HIS_WIN primary Key (APPLYFLOW_SELL,GAME_CODE,ISSUE_NUMBER)
);
comment on table HIS_WIN_TICKET is '中奖信息';
comment on column HIS_WIN_TICKET.APPLYFLOW_SELL is '售票请求流水';
comment on column HIS_WIN_TICKET.WINNING_TIME is '开奖时间';
comment on column HIS_WIN_TICKET.TERMINAL_CODE is '销售终端编码';
comment on column HIS_WIN_TICKET.TELLER_CODE is '销售员编码';
comment on column HIS_WIN_TICKET.AGENCY_CODE is '销售站编码';
comment on column HIS_WIN_TICKET.GAME_CODE is '游戏编码';
comment on column HIS_WIN_TICKET.ISSUE_NUMBER is '游戏期号（销售）';
comment on column HIS_WIN_TICKET.TICKET_AMOUNT is '票面销售金额';
comment on column HIS_WIN_TICKET.IS_BIG_PRIZE is '是否大奖';
comment on column HIS_WIN_TICKET.WIN_AMOUNT is '中奖金额（税前）';
comment on column HIS_WIN_TICKET.WIN_AMOUNT_WITHOUT_TAX is '中奖金额（税后）';
comment on column HIS_WIN_TICKET.TAX_AMOUNT is '税额';
comment on column HIS_WIN_TICKET.WIN_BETS is '中奖注数';
comment on column HIS_WIN_TICKET.HD_WIN_AMOUNT is '高等奖中奖金额（税前）';
comment on column HIS_WIN_TICKET.HD_WIN_AMOUNT_WITHOUT_TAX is '高等奖中奖金额（税后）';
comment on column HIS_WIN_TICKET.HD_TAX_AMOUNT is '高等奖税额';
comment on column HIS_WIN_TICKET.HD_WIN_BETS is '高等奖中奖注数';
comment on column HIS_WIN_TICKET.LD_WIN_AMOUNT is '固定奖中奖金额（税前）';
comment on column HIS_WIN_TICKET.LD_WIN_AMOUNT_WITHOUT_TAX is '固定奖中奖金额（税后）';
comment on column HIS_WIN_TICKET.LD_TAX_AMOUNT is '固定奖税额';
comment on column HIS_WIN_TICKET.LD_WIN_BETS is '固定奖中奖注数';

create table HIS_WIN_TICKET_DETAIL(
	APPLYFLOW_SELL CHAR(24)  not null,
	WINNNING_TIME DATE  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	SALE_AGENCY CHAR(8)  not null,
	PRIZE_LEVEL NUMBER(3)  not null,
	PRIZE_COUNT NUMBER(16)  not null,
	IS_HD_PRIZE NUMBER(1)  not null,
	WINNINGAMOUNTTAX NUMBER(16)  not null,
	WINNINGAMOUNT NUMBER(16)  not null,
	TAXAMOUNT NUMBER(16)  not null,
	WIN_SEQ NUMBER(18)  not null,
	constraint PK_HIS_WIN_DETAIL primary Key (APPLYFLOW_SELL,GAME_CODE,ISSUE_NUMBER,PRIZE_LEVEL)
);
comment on table HIS_WIN_TICKET_DETAIL is '中奖信息';
comment on column HIS_WIN_TICKET_DETAIL.APPLYFLOW_SELL is '售票请求流水';
comment on column HIS_WIN_TICKET_DETAIL.WINNNING_TIME is '开奖时间';
comment on column HIS_WIN_TICKET_DETAIL.GAME_CODE is '游戏编码';
comment on column HIS_WIN_TICKET_DETAIL.ISSUE_NUMBER is '游戏期号（中奖）';
comment on column HIS_WIN_TICKET_DETAIL.SALE_AGENCY is '售票销售站';
comment on column HIS_WIN_TICKET_DETAIL.PRIZE_LEVEL is '奖等';
comment on column HIS_WIN_TICKET_DETAIL.PRIZE_COUNT is '中奖注数';
comment on column HIS_WIN_TICKET_DETAIL.IS_HD_PRIZE is '是否高等奖';
comment on column HIS_WIN_TICKET_DETAIL.WINNINGAMOUNTTAX is '中奖金额(税前)';
comment on column HIS_WIN_TICKET_DETAIL.WINNINGAMOUNT is '中奖金额(税后)';
comment on column HIS_WIN_TICKET_DETAIL.TAXAMOUNT is '税额';
comment on column HIS_WIN_TICKET_DETAIL.WIN_SEQ is '中奖递增序号';
create index IDX_HIS_WIN_DETAIL_SEQ on HIS_WIN_TICKET_DETAIL(WIN_SEQ);
create index IDX_HIS_WIN_DETAIL_RPT on HIS_WIN_TICKET_DETAIL(GAME_CODE,ISSUE_NUMBER,PRIZE_LEVEL,SALE_AGENCY);
create index IDX_HIS_WIN_DETAIL_G_I on HIS_WIN_TICKET_DETAIL(GAME_CODE,ISSUE_NUMBER);

create table HIS_PAYTICKET(
	APPLYFLOW_PAY CHAR(24)  not null,
	APPLYFLOW_SELL CHAR(24)  ,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	TERMINAL_CODE CHAR(10)  ,
	TELLER_CODE NUMBER(8)  ,
	AGENCY_CODE CHAR(8)  ,
	IS_CENTER NUMBER(1)  not null,
	ORG_CODE CHAR(2)  ,
	PAYTIME DATE  not null,
	WINNINGAMOUNTTAX NUMBER(16)  not null,
	WINNINGAMOUNT NUMBER(16)  not null,
	TAXAMOUNT NUMBER(16)  not null,
	PAYCOMMISSIONRATE NUMBER(4)  not null,
	COMMISSIONAMOUNT NUMBER(16)  not null,
	PAYCOMMISSIONRATE_O NUMBER(4)  not null,
	COMMISSIONAMOUNT_O NUMBER(16)  not null,
	WINNINGCOUNT NUMBER(8)  not null,
	HD_WINNING NUMBER(16)  not null,
	HD_COUNT NUMBER(8)  not null,
	LD_WINNING NUMBER(16)  not null,
	LD_COUNT NUMBER(8)  not null,
	LOYALTY_CODE VARCHAR2(50)  ,
	IS_BIG_PRIZE NUMBER(1)  not null,
	PAY_SEQ NUMBER(18)  not null,
  TRANS_SEQ NUMBER(18) default 0 not null,
	constraint PK_HIS_PAY_TSN primary Key (APPLYFLOW_PAY)
);
comment on table HIS_PAYTICKET is '彩票兑奖信息';
comment on column HIS_PAYTICKET.APPLYFLOW_PAY is '兑奖请求流水号';
comment on column HIS_PAYTICKET.APPLYFLOW_SELL is '售票请求流水号';
comment on column HIS_PAYTICKET.GAME_CODE is '游戏编码';
comment on column HIS_PAYTICKET.ISSUE_NUMBER is '兑奖游戏期号';
comment on column HIS_PAYTICKET.TERMINAL_CODE is '终端编码';
comment on column HIS_PAYTICKET.TELLER_CODE is '销售员编码';
comment on column HIS_PAYTICKET.AGENCY_CODE is '销售站编码';
comment on column HIS_PAYTICKET.IS_CENTER is '是否中心兑奖';
comment on column HIS_PAYTICKET.ORG_CODE is '兑奖机构编码';
comment on column HIS_PAYTICKET.PAYTIME is '兑奖时间';
comment on column HIS_PAYTICKET.WINNINGAMOUNTTAX is '中奖金额(税前)';
comment on column HIS_PAYTICKET.WINNINGAMOUNT is '中奖金额(税后)';
comment on column HIS_PAYTICKET.TAXAMOUNT is '税额';
comment on column HIS_PAYTICKET.PAYCOMMISSIONRATE is '兑奖佣金返还比例';
comment on column HIS_PAYTICKET.COMMISSIONAMOUNT is '兑奖佣金返还金额（厘）';
comment on column HIS_PAYTICKET.PAYCOMMISSIONRATE_O is '兑奖佣金返还比例（代理商）';
comment on column HIS_PAYTICKET.COMMISSIONAMOUNT_O is '兑奖佣金返还金额（代理商）';
comment on column HIS_PAYTICKET.WINNINGCOUNT is '兑奖注数';
comment on column HIS_PAYTICKET.HD_WINNING is '高等奖兑奖金额';
comment on column HIS_PAYTICKET.HD_COUNT is '高等奖兑奖注数';
comment on column HIS_PAYTICKET.LD_WINNING is '低等奖兑奖金额';
comment on column HIS_PAYTICKET.LD_COUNT is '低等奖兑奖注数';
comment on column HIS_PAYTICKET.LOYALTY_CODE is '彩民卡编号';
comment on column HIS_PAYTICKET.IS_BIG_PRIZE is '是否大奖';
comment on column HIS_PAYTICKET.PAY_SEQ is '兑奖递增序号';
comment on column HIS_PAYTICKET.TRANS_SEQ is '交易序号';
create index IDX_HIS_PAY_SEQ on HIS_PAYTICKET(PAY_SEQ);

create table HIS_ABANDON_TICKET(
	APPLYFLOW_SELL CHAR(24)  not null,
	ABANDON_TIME DATE  not null,
	WINNING_TIME DATE  not null,
	TERMINAL_CODE CHAR(10)  not null,
	TELLER_CODE NUMBER(8)  not null,
	AGENCY_CODE CHAR(8)  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	TICKET_AMOUNT NUMBER(16)  not null,
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
	LD_WIN_BETS NUMBER(28) default 0 ,
	constraint PK_HIS_GIVEUP primary Key (APPLYFLOW_SELL,GAME_CODE,ISSUE_NUMBER)
);
comment on table HIS_ABANDON_TICKET is '彩票弃奖信息';
comment on column HIS_ABANDON_TICKET.APPLYFLOW_SELL is '售票请求流水号';
comment on column HIS_ABANDON_TICKET.ABANDON_TIME is '弃奖时间';
comment on column HIS_ABANDON_TICKET.WINNING_TIME is '开奖时间';
comment on column HIS_ABANDON_TICKET.TERMINAL_CODE is '销售终端编码';
comment on column HIS_ABANDON_TICKET.TELLER_CODE is '销售员编码';
comment on column HIS_ABANDON_TICKET.AGENCY_CODE is '销售站编码';
comment on column HIS_ABANDON_TICKET.GAME_CODE is '游戏编码';
comment on column HIS_ABANDON_TICKET.ISSUE_NUMBER is '游戏期号（销售）';
comment on column HIS_ABANDON_TICKET.TICKET_AMOUNT is '票面销售金额';
comment on column HIS_ABANDON_TICKET.IS_BIG_PRIZE is '是否大奖';
comment on column HIS_ABANDON_TICKET.WIN_AMOUNT is '中奖金额（税前）';
comment on column HIS_ABANDON_TICKET.WIN_AMOUNT_WITHOUT_TAX is '中奖金额（税后）';
comment on column HIS_ABANDON_TICKET.TAX_AMOUNT is '税额';
comment on column HIS_ABANDON_TICKET.WIN_BETS is '中奖注数';
comment on column HIS_ABANDON_TICKET.HD_WIN_AMOUNT is '高等奖中奖金额（税前）';
comment on column HIS_ABANDON_TICKET.HD_WIN_AMOUNT_WITHOUT_TAX is '高等奖中奖金额（税后）';
comment on column HIS_ABANDON_TICKET.HD_TAX_AMOUNT is '高等奖税额';
comment on column HIS_ABANDON_TICKET.HD_WIN_BETS is '高等奖中奖注数';
comment on column HIS_ABANDON_TICKET.LD_WIN_AMOUNT is '固定奖中奖金额（税前）';
comment on column HIS_ABANDON_TICKET.LD_WIN_AMOUNT_WITHOUT_TAX is '固定奖中奖金额（税后）';
comment on column HIS_ABANDON_TICKET.LD_TAX_AMOUNT is '固定奖税额';
comment on column HIS_ABANDON_TICKET.LD_WIN_BETS is '固定奖中奖注数';

create table HIS_ABANDON_TICKET_DETAIL(
	APPLYFLOW_SELL CHAR(24)  not null,
	ABANDON_TIME DATE  not null,
	WINNING_TIME DATE  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	PRIZE_LEVEL NUMBER(3)  ,
	PRIZE_COUNT NUMBER(16)  ,
	IS_HD_PRIZE NUMBER(1)  ,
	WINNINGAMOUNTTAX NUMBER(16)  ,
	WINNINGAMOUNT NUMBER(16)  ,
	TAXAMOUNT NUMBER(16)  ,
	constraint PK_HIS_GIVEUP_DETAIL primary Key (APPLYFLOW_SELL,GAME_CODE,ISSUE_NUMBER,PRIZE_LEVEL)
);
comment on table HIS_ABANDON_TICKET_DETAIL is '弃奖信息明细';
comment on column HIS_ABANDON_TICKET_DETAIL.APPLYFLOW_SELL is '售票请求流水';
comment on column HIS_ABANDON_TICKET_DETAIL.ABANDON_TIME is '弃奖时间';
comment on column HIS_ABANDON_TICKET_DETAIL.WINNING_TIME is '开奖时间';
comment on column HIS_ABANDON_TICKET_DETAIL.GAME_CODE is '游戏编码';
comment on column HIS_ABANDON_TICKET_DETAIL.ISSUE_NUMBER is '游戏期号';
comment on column HIS_ABANDON_TICKET_DETAIL.PRIZE_LEVEL is '奖等';
comment on column HIS_ABANDON_TICKET_DETAIL.PRIZE_COUNT is '中奖注数';
comment on column HIS_ABANDON_TICKET_DETAIL.IS_HD_PRIZE is '是否高等奖';
comment on column HIS_ABANDON_TICKET_DETAIL.WINNINGAMOUNTTAX is '中奖金额(税前)';
comment on column HIS_ABANDON_TICKET_DETAIL.WINNINGAMOUNT is '中奖金额(税后)';
comment on column HIS_ABANDON_TICKET_DETAIL.TAXAMOUNT is '税额';

create table HIS_DAY_SETTLE(
	SETTLE_ID NUMBER(10)  not null,
	OPT_DATE DATE  not null,
	SETTLE_DATE DATE  not null,
	SELL_SEQ NUMBER(18)  not null,
	CANCEL_SEQ NUMBER(18)  not null,
	PAY_SEQ NUMBER(18)  not null,
	WIN_SEQ NUMBER(18)  not null,
	constraint PK_HIS_DAY_SETTLE primary Key (SETTLE_ID)
);
comment on table HIS_DAY_SETTLE is '日结信息';
comment on column HIS_DAY_SETTLE.SETTLE_ID is '日结序号';
comment on column HIS_DAY_SETTLE.OPT_DATE is '操作日期（系统当前时间）';
comment on column HIS_DAY_SETTLE.SETTLE_DATE is '统计日期（通过主机传递过来）';
comment on column HIS_DAY_SETTLE.SELL_SEQ is 'SELL_SEQ';
comment on column HIS_DAY_SETTLE.CANCEL_SEQ is 'CANCEL_SEQ';
comment on column HIS_DAY_SETTLE.PAY_SEQ is 'PAY_SEQ';
comment on column HIS_DAY_SETTLE.WIN_SEQ is 'WIN_SEQ';
create index IDX_HIS_DAY_SELL on HIS_DAY_SETTLE(SELL_SEQ);
create index IDX_HIS_DAY_CANCEL on HIS_DAY_SETTLE(CANCEL_SEQ);
create index IDX_HIS_DAY_PAY on HIS_DAY_SETTLE(PAY_SEQ);
create index IDX_HIS_DAY_WIN on HIS_DAY_SETTLE(WIN_SEQ);

create table HIS_SALER_AGENCY(
	SETTLE_ID NUMBER(10)  not null,
	AGENCY_CODE CHAR(8)  ,
	AGENCY_NAME VARCHAR2(1000)  ,
	STORETYPE_ID NUMBER(2)  ,
	STATUS NUMBER(1)  ,
	AGENCY_TYPE NUMBER(1)  ,
	BANK_ID NUMBER(4)  ,
	BANK_ACCOUNT VARCHAR2(32)  ,
	TELEPHONE VARCHAR2(100)  ,
	CONTACT_PERSON VARCHAR2(500)  ,
	ADDRESS VARCHAR2(4000)  ,
	AGENCY_ADD_TIME DATE  ,
	QUIT_TIME DATE  ,
	ORG_CODE CHAR(2)  ,
	AREA_CODE CHAR(4)  ,
	MARKET_MANAGER_ID NUMBER(4)  ,
	constraint PK_HIS_SALER_AGENCY primary Key (AGENCY_CODE,SETTLE_ID)
);
comment on table HIS_SALER_AGENCY is '销售站历史';
comment on column HIS_SALER_AGENCY.SETTLE_ID is '日结序号';
comment on column HIS_SALER_AGENCY.AGENCY_CODE is '销售站编码（4位区域编码+4位顺序号）';
comment on column HIS_SALER_AGENCY.AGENCY_NAME is '销售站名称';
comment on column HIS_SALER_AGENCY.STORETYPE_ID is '店面类型ID';
comment on column HIS_SALER_AGENCY.STATUS is '销售站状态（1=可用；2=已禁用；3=已清退）';
comment on column HIS_SALER_AGENCY.AGENCY_TYPE is '销售站类型（1=传统终端(预付费)；2=受信终端(后付费)；3=无纸化；4=中心销售站）';
comment on column HIS_SALER_AGENCY.BANK_ID is '银行ID';
comment on column HIS_SALER_AGENCY.BANK_ACCOUNT is '银行账号';
comment on column HIS_SALER_AGENCY.TELEPHONE is '销售站电话';
comment on column HIS_SALER_AGENCY.CONTACT_PERSON is '销售站联系人';
comment on column HIS_SALER_AGENCY.ADDRESS is '销售站地址';
comment on column HIS_SALER_AGENCY.AGENCY_ADD_TIME is '销售站添加时间';
comment on column HIS_SALER_AGENCY.QUIT_TIME is '清退时间';
comment on column HIS_SALER_AGENCY.ORG_CODE is '所属部门编码';
comment on column HIS_SALER_AGENCY.AREA_CODE is '所属区域编码';
comment on column HIS_SALER_AGENCY.MARKET_MANAGER_ID is '市场管理员编码';

create table SUB_SELL(
	SALE_DATE CHAR(10)  not null,
	SALE_WEEK CHAR(7)  not null,
	SALE_MONTH CHAR(7)  not null,
	SALE_QUARTER CHAR(6)  not null,
	SALE_YEAR CHAR(4)  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	SALE_AGENCY CHAR(8)  not null,
	SALE_AREA CHAR(2)  not null,
	SALE_TELLER NUMBER(8)  not null,
	SALE_TERMINAL CHAR(10)  not null,
	BET_METHOLD NUMBER(4)  not null,
	LOYALTY_CODE VARCHAR2(50)  not null,
	RESULT_CODE NUMBER(4)  not null,
	SALE_AMOUNT NUMBER(28) default 0 ,
	SALE_BETS NUMBER(28) default 0 ,
	SALE_COMMISSION NUMBER(28) default 0 ,
	SALE_TICKETS NUMBER(28) default 0 ,
	SALE_LINES NUMBER(28) default 0 ,
	PURE_AMOUNT NUMBER(28) default 0 ,
	PURE_BETS NUMBER(28) default 0 ,
	PURE_COMMISSION NUMBER(28) default 0 ,
	PURE_TICKETS NUMBER(28) default 0 ,
	PURE_LINES NUMBER(28) default 0 ,
	SALE_AMOUNT_SINGLE_ISSUE NUMBER(28) default 0 ,
	SALE_BETS_SINGLE_ISSUE NUMBER(28) default 0 ,
	PURE_AMOUNT_SINGLE_ISSUE NUMBER(28) default 0 ,
	PURE_BETS_SINGLE_ISSUE NUMBER(28) default 0 ,
  SALE_COMMISION_SINGLE_ISSUE NUMBER(28) default 0 ,
  PURE_COMMISION_SINGLE_ISSUE NUMBER(28) default 0 ,
  constraint PK_SUB_SELL primary Key (SALE_DATE,SALE_WEEK,SALE_MONTH,SALE_QUARTER,SALE_YEAR,GAME_CODE,ISSUE_NUMBER,SALE_AREA,SALE_AGENCY,SALE_TELLER,SALE_TERMINAL,BET_METHOLD,LOYALTY_CODE,RESULT_CODE)
);
comment on table SUB_SELL is '销售主题';
comment on column SUB_SELL.SALE_DATE is '销售日期（YYYY-MM-DD）';
comment on column SUB_SELL.SALE_WEEK is '销售周（YYYY-WK）';
comment on column SUB_SELL.SALE_MONTH is '销售月（YYYY-MM）';
comment on column SUB_SELL.SALE_QUARTER is '销售季（YYYY-Q）';
comment on column SUB_SELL.SALE_YEAR is '销售年（YYYY）';
comment on column SUB_SELL.GAME_CODE is '游戏';
comment on column SUB_SELL.ISSUE_NUMBER is '销售期次';
comment on column SUB_SELL.SALE_AGENCY is '售票销售站';
comment on column SUB_SELL.SALE_AREA is '售票销售站所在区域';
comment on column SUB_SELL.SALE_TELLER is '售票销售员';
comment on column SUB_SELL.SALE_TERMINAL is '售票终端';
comment on column SUB_SELL.BET_METHOLD is '投注方法';
comment on column SUB_SELL.LOYALTY_CODE is '彩民卡编号';
comment on column SUB_SELL.RESULT_CODE is '票处理结果';
comment on column SUB_SELL.SALE_AMOUNT is '销售金额（多期票销售算作销售期）';
comment on column SUB_SELL.SALE_BETS is '销售注数（多期票销售算作销售期）';
comment on column SUB_SELL.SALE_COMMISSION is '销售佣金';
comment on column SUB_SELL.SALE_TICKETS is '销售票数';
comment on column SUB_SELL.SALE_LINES is '投注行数量';
comment on column SUB_SELL.PURE_AMOUNT is '净销售额';
comment on column SUB_SELL.PURE_BETS is '净销售注数';
comment on column SUB_SELL.PURE_COMMISSION is '净销售佣金';
comment on column SUB_SELL.PURE_TICKETS is '净销售票数';
comment on column SUB_SELL.PURE_LINES is '净投注行数量';
comment on column SUB_SELL.SALE_AMOUNT_SINGLE_ISSUE is '当期销售额（多期票被拆分后计算当前期）';
comment on column SUB_SELL.SALE_BETS_SINGLE_ISSUE is '当期销售注数（多期票被拆分后计算当前期）';
comment on column SUB_SELL.PURE_AMOUNT_SINGLE_ISSUE is '当期净销售额（多期票被拆分后计算当前期）';
comment on column SUB_SELL.PURE_BETS_SINGLE_ISSUE is '当期净销售注数（多期票被拆分后计算当前期）';
comment on column SUB_SELL.SALE_COMMISION_SINGLE_ISSUE is '当期销售额对应的佣金（多期票被拆分后计算当前期）';
comment on column SUB_SELL.PURE_COMMISION_SINGLE_ISSUE is '当期净销售对应的佣金（多期票被拆分后计算当前期）';
create index IDX_SUB_SELL_DATE on SUB_SELL(SALE_DATE);
create index IDX_SUB_SELL_WEEK on SUB_SELL(SALE_WEEK);
create index IDX_SUB_SELL_MONTH on SUB_SELL(SALE_MONTH);
create index IDX_SUB_SELL_QUARTER on SUB_SELL(SALE_QUARTER);
create index IDX_SUB_SELL_YEAR on SUB_SELL(SALE_YEAR);
create index IDX_SUB_SELL_GAME_ISS on SUB_SELL(GAME_CODE,ISSUE_NUMBER);
create index IDX_SUB_SELL_AGENCY on SUB_SELL(SALE_AGENCY);
create index IDX_SUB_SELL_AREA on SUB_SELL(SALE_AREA);
create index IDX_SUB_SELL_TELLER on SUB_SELL(SALE_TELLER);
create index IDX_SUB_SELL_TERMINAL on SUB_SELL(SALE_TERMINAL);

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
comment on table SUB_PAY is '兑奖主题';
comment on column SUB_PAY.PAY_DATE is '兑奖日期（YYYY-MM-DD）';
comment on column SUB_PAY.PAY_WEEK is '兑奖周（YYYY-WK）';
comment on column SUB_PAY.PAY_MONTH is '兑奖月（YYYY-MM）';
comment on column SUB_PAY.PAY_QUARTER is '兑奖季（YYYY-Q）';
comment on column SUB_PAY.PAY_YEAR is '兑奖年（YYYY）';
comment on column SUB_PAY.GAME_CODE is '游戏';
comment on column SUB_PAY.ISSUE_NUMBER is '销售期次';
comment on column SUB_PAY.PAY_AGENCY is '兑奖销售站';
comment on column SUB_PAY.PAY_ISSUE is '兑奖期次';
comment on column SUB_PAY.PAY_AREA is '兑奖销售所在区域';
comment on column SUB_PAY.PAY_TELLER is '兑奖销售员';
comment on column SUB_PAY.PAY_TERMINAL is '兑奖终端';
comment on column SUB_PAY.LOYALTY_CODE is '彩民卡编号';
comment on column SUB_PAY.IS_GUI_PAY is '是否GUI兑奖';
comment on column SUB_PAY.IS_BIG_ONE is '是否大奖';
comment on column SUB_PAY.PAY_AMOUNT is '兑奖金额（税前）';
comment on column SUB_PAY.PAY_AMOUNT_WITHOUT_TAX is '兑奖金额（税后）';
comment on column SUB_PAY.TAX_AMOUNT is '税额';
comment on column SUB_PAY.PAY_BETS is '兑奖注数';
comment on column SUB_PAY.HD_PAY_AMOUNT is '高等奖兑奖金额（税前）';
comment on column SUB_PAY.HD_PAY_AMOUNT_WITHOUT_TAX is '高等奖兑奖金额（税后）';
comment on column SUB_PAY.HD_TAX_AMOUNT is '高等奖税额';
comment on column SUB_PAY.HD_PAY_BETS is '高等奖兑奖注数';
comment on column SUB_PAY.LD_PAY_AMOUNT is '固定奖兑奖金额（税前）';
comment on column SUB_PAY.LD_PAY_AMOUNT_WITHOUT_TAX is '固定奖兑奖金额（税后）';
comment on column SUB_PAY.LD_TAX_AMOUNT is '固定奖税额';
comment on column SUB_PAY.LD_PAY_BETS is '固定奖兑奖注数';
comment on column SUB_PAY.PAY_COMMISSION is '兑奖佣金';
comment on column SUB_PAY.PAY_TICKETS is '兑奖票数';
create index IDX_SUB_PAY_DATE on SUB_PAY(PAY_DATE);
create index IDX_SUB_PAY_WEEK on SUB_PAY(PAY_WEEK);
create index IDX_SUB_PAY_MONTH on SUB_PAY(PAY_MONTH);
create index IDX_SUB_PAY_QUARTER on SUB_PAY(PAY_QUARTER);
create index IDX_SUB_PAY_YEAR on SUB_PAY(PAY_YEAR);
create index IDX_SUB_PAY_GAME_ISS on SUB_PAY(GAME_CODE,ISSUE_NUMBER);
create index IDX_SUB_PAY_AGENCY on SUB_PAY(PAY_AGENCY);
create index IDX_SUB_PAY_AREA on SUB_PAY(PAY_AREA);
create index IDX_SUB_PAY_TELLER on SUB_PAY(PAY_TELLER);
create index IDX_SUB_PAY_TERMINAL on SUB_PAY(PAY_TERMINAL);
create index IDX_SUB_PAY_GAME_PAY on SUB_PAY(GAME_CODE, PAY_ISSUE);

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
comment on table SUB_CANCEL is '退票主题';
comment on column SUB_CANCEL.CANCEL_DATE is '退票日期（YYYY-MM-DD）';
comment on column SUB_CANCEL.CANCEL_WEEK is '退票周（YYYY-WK）';
comment on column SUB_CANCEL.CANCEL_MONTH is '退票月（YYYY-MM）';
comment on column SUB_CANCEL.CANCEL_QUARTER is '退票季（YYYY-Q）';
comment on column SUB_CANCEL.CANCEL_YEAR is '退票年（YYYY）';
comment on column SUB_CANCEL.GAME_CODE is '游戏';
comment on column SUB_CANCEL.ISSUE_NUMBER is '销售期次';
comment on column SUB_CANCEL.CANCEL_AGENCY is '退票销售站';
comment on column SUB_CANCEL.CANCEL_AREA is '退票销售站所属区域';
comment on column SUB_CANCEL.CANCEL_TELLER is '退票销售员';
comment on column SUB_CANCEL.CANCEL_TERMINAL is '退票终端';
comment on column SUB_CANCEL.SALE_AGENCY is '“销售”销售站';
comment on column SUB_CANCEL.SALE_AREA is '“销售”销售站区域';
comment on column SUB_CANCEL.SALE_TELLER is '“销售”销售员';
comment on column SUB_CANCEL.SALE_TERMINAL is '“销售”销售终端';
comment on column SUB_CANCEL.LOYALTY_CODE is '彩民卡编号';
comment on column SUB_CANCEL.IS_GUI_PAY is '是否GUI退票';
comment on column SUB_CANCEL.CANCEL_AMOUNT is '退票涉及金额';
comment on column SUB_CANCEL.CANCEL_BETS is '退票涉及注数';
comment on column SUB_CANCEL.CANCEL_TICKETS is '退票票数';
comment on column SUB_CANCEL.CANCEL_COMMISSION is '退票涉及佣金';
comment on column SUB_CANCEL.CANCEL_LINES is '退票涉及投注行数量';
create index IDX_SUB_CANCEL_DATE on SUB_CANCEL(CANCEL_DATE);
create index IDX_SUB_CANCEL_WEEK on SUB_CANCEL(CANCEL_WEEK);
create index IDX_SUB_CANCEL_MONTH on SUB_CANCEL(CANCEL_MONTH);
create index IDX_SUB_CANCEL_QUARTER on SUB_CANCEL(CANCEL_QUARTER);
create index IDX_SUB_CANCEL_YEAR on SUB_CANCEL(CANCEL_YEAR);
create index IDX_SUB_CANCEL_GAME_ISS on SUB_CANCEL(GAME_CODE,ISSUE_NUMBER);
create index IDX_SUB_CANCEL_AGENCY on SUB_CANCEL(CANCEL_AGENCY);
create index IDX_SUB_CANCEL_AREA on SUB_CANCEL(CANCEL_AREA);
create index IDX_SUB_CANCEL_TELLER on SUB_CANCEL(CANCEL_TELLER);
create index IDX_SUB_CANCEL_TERMINAL on SUB_CANCEL(CANCEL_TERMINAL);
create index IDX_SUB_CANCEL_AGENCY_S on SUB_CANCEL(SALE_AGENCY);
create index IDX_SUB_CANCEL_AREA_S on SUB_CANCEL(SALE_AREA);
create index IDX_SUB_CANCEL_TELLER_S on SUB_CANCEL(SALE_TELLER);
create index IDX_SUB_CANCEL_TERMINAL_S on SUB_CANCEL(SALE_TERMINAL);

create table SUB_WIN(
	WINNING_DATE CHAR(10)  not null,
	WINNING_WEEK CHAR(7)  not null,
	WINNING_MONTH CHAR(7)  not null,
	WINNING_QUARTER CHAR(6)  not null,
	WINNING_YEAR CHAR(4)  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
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
	constraint PK_SUB_WIN primary Key (WINNING_DATE,WINNING_WEEK,WINNING_MONTH,WINNING_QUARTER,WINNING_YEAR,GAME_CODE,ISSUE_NUMBER,SALE_AREA,SALE_AGENCY,SALE_TELLER,SALE_TERMINAL,BET_METHOLD,LOYALTY_CODE,IS_BIG_ONE)
);
comment on table SUB_WIN is '中奖主题';
comment on column SUB_WIN.WINNING_DATE is '开奖日期（YYYY-MM-DD）';
comment on column SUB_WIN.WINNING_WEEK is '开奖周（YYYY-WK）';
comment on column SUB_WIN.WINNING_MONTH is '开奖月（YYYY-MM）';
comment on column SUB_WIN.WINNING_QUARTER is '开奖季（YYYY-Q）';
comment on column SUB_WIN.WINNING_YEAR is '开奖年（YYYY）';
comment on column SUB_WIN.GAME_CODE is '游戏';
comment on column SUB_WIN.ISSUE_NUMBER is '销售期次';
comment on column SUB_WIN.SALE_AGENCY is '售票销售站';
comment on column SUB_WIN.SALE_AREA is '售票销售站所在区域';
comment on column SUB_WIN.SALE_TELLER is '售票销售员';
comment on column SUB_WIN.SALE_TERMINAL is '售票终端';
comment on column SUB_WIN.BET_METHOLD is '投注方法';
comment on column SUB_WIN.LOYALTY_CODE is '彩民卡编号';
comment on column SUB_WIN.IS_BIG_ONE is '是否大奖';
comment on column SUB_WIN.WIN_AMOUNT is '中奖金额（税前）';
comment on column SUB_WIN.WIN_AMOUNT_WITHOUT_TAX is '中奖金额（税后）';
comment on column SUB_WIN.TAX_AMOUNT is '税额';
comment on column SUB_WIN.WIN_BETS is '中奖注数';
comment on column SUB_WIN.HD_WIN_AMOUNT is '高等奖中奖金额（税前）';
comment on column SUB_WIN.HD_WIN_AMOUNT_WITHOUT_TAX is '高等奖中奖金额（税后）';
comment on column SUB_WIN.HD_TAX_AMOUNT is '高等奖税额';
comment on column SUB_WIN.HD_WIN_BETS is '高等奖中奖注数';
comment on column SUB_WIN.LD_WIN_AMOUNT is '固定奖中奖金额（税前）';
comment on column SUB_WIN.LD_WIN_AMOUNT_WITHOUT_TAX is '固定奖中奖金额（税后）';
comment on column SUB_WIN.LD_TAX_AMOUNT is '固定奖税额';
comment on column SUB_WIN.LD_WIN_BETS is '固定奖中奖注数';
create index IDX_SUB_WIN_DATE on SUB_WIN(WINNING_DATE);
create index IDX_SUB_WIN_WEEK on SUB_WIN(WINNING_WEEK);
create index IDX_SUB_WIN_MONTH on SUB_WIN(WINNING_MONTH);
create index IDX_SUB_WIN_QUARTER on SUB_WIN(WINNING_QUARTER);
create index IDX_SUB_WIN_YEAR on SUB_WIN(WINNING_YEAR);
create index IDX_SUB_WIN_GAME_ISS on SUB_WIN(GAME_CODE,ISSUE_NUMBER);
create index IDX_SUB_WIN_AGENCY on SUB_WIN(SALE_AGENCY);
create index IDX_SUB_WIN_AREA on SUB_WIN(SALE_AREA);
create index IDX_SUB_WIN_TELLER on SUB_WIN(SALE_TELLER);
create index IDX_SUB_WIN_TERMINAL on SUB_WIN(SALE_TERMINAL);

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

create table SUB_AGENCY(
	CALC_DATE CHAR(10)  not null,
	CALC_WEEK CHAR(7)  not null,
	CALC_MONTH CHAR(7)  not null,
	CALC_QUARTER CHAR(6)  not null,
	CALC_YEAR CHAR(4)  not null,
	AGENCY_CODE CHAR(8)  not null,
	AREA_CODE CHAR(2)  not null,
	SALE_AMOUNT NUMBER(28) default 0 ,
	SALE_AMOUNT_WITHOUT_CANCEL NUMBER(28) default 0 ,
	CANCEL_AMOUNT NUMBER(28) default 0 ,
	PAY_AMOUNT NUMBER(28) default 0 ,
	SALE_COMMISSION NUMBER(28) default 0 ,
	PAY_COMMISSION NUMBER(28) default 0 ,
	RETURN_AMOUNT NUMBER(28) default 0 ,
	CHARGE_AMOUNT NUMBER(28) default 0 ,
	constraint PK_SUB_AGENCY primary Key (CALC_DATE,AGENCY_CODE)
);
comment on table SUB_AGENCY is '销售站资金主题';
comment on column SUB_AGENCY.CALC_DATE is '统计日期（YYYY-MM-DD）';
comment on column SUB_AGENCY.CALC_WEEK is '统计周（YYYY-WK）';
comment on column SUB_AGENCY.CALC_MONTH is '统计月（YYYY-MM）';
comment on column SUB_AGENCY.CALC_QUARTER is '统计季（YYYY-Q）';
comment on column SUB_AGENCY.CALC_YEAR is '统计年（YYYY）';
comment on column SUB_AGENCY.AGENCY_CODE is '销售站';
comment on column SUB_AGENCY.AREA_CODE is '售票销售站所在区域';
comment on column SUB_AGENCY.SALE_AMOUNT is '销售额（含退票）';
comment on column SUB_AGENCY.SALE_AMOUNT_WITHOUT_CANCEL is '销售额（不含退票）';
comment on column SUB_AGENCY.CANCEL_AMOUNT is '退票额';
comment on column SUB_AGENCY.PAY_AMOUNT is '兑奖额';
comment on column SUB_AGENCY.SALE_COMMISSION is '销售代销费';
comment on column SUB_AGENCY.PAY_COMMISSION is '兑奖代销费';
comment on column SUB_AGENCY.RETURN_AMOUNT is '清退金额';
comment on column SUB_AGENCY.CHARGE_AMOUNT is '充值金额';
create index IDX_SUB_AGENCY_DATE on SUB_AGENCY(CALC_DATE);
create index IDX_SUB_AGENCY_WEEK on SUB_AGENCY(CALC_WEEK);
create index IDX_SUB_AGENCY_MONTH on SUB_AGENCY(CALC_MONTH);
create index IDX_SUB_AGENCY_QUARTER on SUB_AGENCY(CALC_QUARTER);
create index IDX_SUB_AGENCY_YEAR on SUB_AGENCY(CALC_YEAR);
create index IDX_SUB_AGENCY_AGENCY on SUB_AGENCY(AGENCY_CODE);
create index IDX_SUB_AGENCY_AREA on SUB_AGENCY(AREA_CODE);

create table SUB_AGENCY_ACTION(
	CALC_DATE CHAR(10)  not null,
	AGENCY_CODE CHAR(8)  not null,
	IS_SALED NUMBER(1)  not null,
	IS_LOGINED NUMBER(1)  not null,
	IS_PAID NUMBER(1)  not null,
	IS_CHARGED NUMBER(1)  not null,
	constraint PK_SUB_AGENCY_ACTION primary Key (CALC_DATE,AGENCY_CODE)
);
comment on table SUB_AGENCY_ACTION is '销售站动态主题';
comment on column SUB_AGENCY_ACTION.CALC_DATE is '统计日期（YYYY-MM-DD）';
comment on column SUB_AGENCY_ACTION.AGENCY_CODE is '销售站';
comment on column SUB_AGENCY_ACTION.IS_SALED is '今日是否销售';
comment on column SUB_AGENCY_ACTION.IS_LOGINED is '今日是否登录';
comment on column SUB_AGENCY_ACTION.IS_PAID is '今日是否兑奖';
comment on column SUB_AGENCY_ACTION.IS_CHARGED is '今日是否充值';
create index IDX_SUB_AGENCY_AC_DATE on SUB_AGENCY_ACTION(CALC_DATE);
create index IDX_SUB_AGENCY_AC_AGENCY on SUB_AGENCY_ACTION(AGENCY_CODE);

create table MIS_REPORT_3111(
	SALE_DATE DATE  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME VARCHAR2(1000)  not null,
	SALE_SUM NUMBER(28) default 0 not null,
	SALE_KOC6HC NUMBER(28) default 0 not null,
	SALE_KOCSSC NUMBER(28) default 0 not null,
	SALE_KOCKENO NUMBER(28) default 0 not null,
	SALE_KOCQ2 NUMBER(28) default 0 not null,
	constraint PK_MIS_REPORT_3111 primary Key (SALE_DATE,AREA_CODE)
);
comment on table MIS_REPORT_3111 is '区域游戏销售统计表';
comment on column MIS_REPORT_3111.SALE_DATE is '销售日期';
comment on column MIS_REPORT_3111.AREA_CODE is '区域编码';
comment on column MIS_REPORT_3111.AREA_NAME is '区域名称';
comment on column MIS_REPORT_3111.SALE_SUM is '销售额';
comment on column MIS_REPORT_3111.SALE_KOC6HC is '天天赢';
comment on column MIS_REPORT_3111.SALE_KOCSSC is '七龙星';
comment on column MIS_REPORT_3111.SALE_KOCKENO is 'KENO';
comment on column MIS_REPORT_3111.SALE_KOCQ2 is '快2';

create table MIS_REPORT_3112(
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
	constraint PK_MIS_REPORT_3112 primary Key (PURGED_DATE,GAME_CODE,ISSUE_NUMBER)
);
comment on table MIS_REPORT_3112 is '弃奖统计日报表';
comment on column MIS_REPORT_3112.PURGED_DATE is '弃奖日期';
comment on column MIS_REPORT_3112.GAME_CODE is '游戏';
comment on column MIS_REPORT_3112.ISSUE_NUMBER is '游戏期次';
comment on column MIS_REPORT_3112.WINNING_SUM is '中奖总额';
comment on column MIS_REPORT_3112.HD_PURGED_AMOUNT is '高等奖弃奖金额';
comment on column MIS_REPORT_3112.LD_PURGED_AMOUNT is '低等奖弃奖金额';
comment on column MIS_REPORT_3112.HD_PURGED_SUM is '高等奖弃奖注数';
comment on column MIS_REPORT_3112.LD_PURGED_SUM is '低等奖弃奖注数';
comment on column MIS_REPORT_3112.PURGED_AMOUNT is '合计弃奖金额';
comment on column MIS_REPORT_3112.PURGED_RATE is '弃奖百分比（万分位）';
create index IDX_MIS_RPT_3112_GAME_ISS on MIS_REPORT_3112(GAME_CODE,ISSUE_NUMBER);

create table MIS_REPORT_3113(
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME VARCHAR2(1000)  not null,
	SALE_SUM NUMBER(28) default 0 not null,
	HD_WINNING_SUM NUMBER(28) default 0 not null,
	HD_WINNING_AMOUNT NUMBER(28) default 0 not null,
	LD_WINNING_SUM NUMBER(28) default 0 not null,
	LD_WINNING_AMOUNT NUMBER(28) default 0 not null,
	WINNING_SUM NUMBER(28) default 0 not null,
	WINNING_RATE NUMBER(28) default 0 not null,
	constraint PK_MIS_REPORT_3113 primary Key (GAME_CODE,ISSUE_NUMBER,AREA_CODE)
);
comment on table MIS_REPORT_3113 is '区域中奖统计表';
comment on column MIS_REPORT_3113.GAME_CODE is '游戏';
comment on column MIS_REPORT_3113.ISSUE_NUMBER is '游戏期次';
comment on column MIS_REPORT_3113.AREA_CODE is '区域编码';
comment on column MIS_REPORT_3113.AREA_NAME is '区域名称';
comment on column MIS_REPORT_3113.SALE_SUM is '销售总额';
comment on column MIS_REPORT_3113.HD_WINNING_SUM is '高等奖中奖金额';
comment on column MIS_REPORT_3113.HD_WINNING_AMOUNT is '高等奖中奖注数';
comment on column MIS_REPORT_3113.LD_WINNING_SUM is '固定奖中奖金额';
comment on column MIS_REPORT_3113.LD_WINNING_AMOUNT is '固定奖中奖注数';
comment on column MIS_REPORT_3113.WINNING_SUM is '中奖金额合计';
comment on column MIS_REPORT_3113.WINNING_RATE is '本期中奖率';

create table MIS_REPORT_3116(
	COUNT_DATE DATE  not null,
	AGENCY_CODE CHAR(8)  not null,
	AGENCY_TYPE NUMBER(4)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME VARCHAR2(1000)  not null,
	GAME_CODE NUMBER(3)  ,
	ISSUE_NUMBER NUMBER(12)  ,
	SALE_SUM NUMBER(28) default 0 not null,
	SALE_COMM_SUM NUMBER(28) default 0 not null,
	constraint PK_MIS_REPORT_3116 primary Key (COUNT_DATE,AGENCY_CODE,GAME_CODE,ISSUE_NUMBER)
);
comment on table MIS_REPORT_3116 is '销售站游戏期次报表';
comment on column MIS_REPORT_3116.COUNT_DATE is '统计日期';
comment on column MIS_REPORT_3116.AGENCY_CODE is '销售站';
comment on column MIS_REPORT_3116.AGENCY_TYPE is '销售站类型';
comment on column MIS_REPORT_3116.AREA_CODE is '区域编码';
comment on column MIS_REPORT_3116.AREA_NAME is '区域名称';
comment on column MIS_REPORT_3116.GAME_CODE is '游戏';
comment on column MIS_REPORT_3116.ISSUE_NUMBER is '游戏期次';
comment on column MIS_REPORT_3116.SALE_SUM is '销售总额';
comment on column MIS_REPORT_3116.SALE_COMM_SUM is '销售代销费金额';

create table MIS_REPORT_3117(
	PAY_TIME DATE  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	PAY_AMOUNT NUMBER(28)  not null,
	PAY_TAX NUMBER(28)  ,
	PAY_AMOUNT_AFTER_TAX NUMBER(28)  not null,
	PAY_TSN CHAR(24)  ,
	SALE_TSN CHAR(24)  ,
	GUI_PAY_FLOW CHAR(24)  not null,
	APPLYFLOW_SALE CHAR(24)  not null,
	WINNERNAME VARCHAR2(1000)  ,
	CERT_TYPE NUMBER(2) default 0 ,
	CERT_NO VARCHAR2(50)  ,
	AGENCY_CODE NUMBER(10)  not null,
	PAYER_ADMIN NUMBER(4)  ,
	constraint PK_MIS_REPORT_3117 primary Key (GUI_PAY_FLOW)
);
comment on table MIS_REPORT_3117 is '大奖兑付明细报表';
comment on column MIS_REPORT_3117.PAY_TIME is '兑付日期';
comment on column MIS_REPORT_3117.GAME_CODE is '游戏编码';
comment on column MIS_REPORT_3117.ISSUE_NUMBER is '游戏期号';
comment on column MIS_REPORT_3117.PAY_AMOUNT is '兑付金额';
comment on column MIS_REPORT_3117.PAY_TAX is '缴税金额';
comment on column MIS_REPORT_3117.PAY_AMOUNT_AFTER_TAX is '实付金额';
comment on column MIS_REPORT_3117.PAY_TSN is '兑奖tsn';
comment on column MIS_REPORT_3117.SALE_TSN is '售票tsn';
comment on column MIS_REPORT_3117.GUI_PAY_FLOW is '兑奖请求流水号';
comment on column MIS_REPORT_3117.APPLYFLOW_SALE is '售票请求流水号';
comment on column MIS_REPORT_3117.WINNERNAME is '中奖人姓名';
comment on column MIS_REPORT_3117.CERT_TYPE is '中奖人证件类型(10=身份证、20=护照、30=军官证、40=士兵证、50=回乡证、90=其他证件)';
comment on column MIS_REPORT_3117.CERT_NO is '中奖人证件号码 ';
comment on column MIS_REPORT_3117.AGENCY_CODE is '兑奖销售站编码';
comment on column MIS_REPORT_3117.PAYER_ADMIN is '兑奖操作员编号';
create index IDX_MIS_RPT_3117_P_DATE on MIS_REPORT_3117(PAY_TIME);

create table MIS_REPORT_NCP(
	COUNT_DATE DATE  not null,
	AGENCY_CODE CHAR(8)  not null,
	AGENCY_TYPE NUMBER(4)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME VARCHAR2(1000)  not null,
	GAME_CODE NUMBER(3)  ,
	ISSUE_NUMBER NUMBER(12)  ,
	SALE_SUM NUMBER(28) default 0 not null,
	SALE_COUNT NUMBER(28) default 0 not null,
	CANCEL_SUM NUMBER(28) default 0 not null,
	CANCEL_COUNT NUMBER(28) default 0 not null,
	PAY_SUM NUMBER(28) default 0 not null,
	PAY_COUNT NUMBER(28) default 0 not null,
	SALE_COMM_SUM NUMBER(28) default 0 not null,
	PAY_COMM_COUNT NUMBER(28) default 0 not null,
	constraint PK_MIS_REPORT_NCP primary Key (COUNT_DATE,AGENCY_CODE,GAME_CODE,ISSUE_NUMBER)
);
comment on table MIS_REPORT_NCP is '销售站游戏期次报表';
comment on column MIS_REPORT_NCP.COUNT_DATE is '统计日期';
comment on column MIS_REPORT_NCP.AGENCY_CODE is '销售站';
comment on column MIS_REPORT_NCP.AGENCY_TYPE is '销售站类型';
comment on column MIS_REPORT_NCP.AREA_CODE is '区域编码';
comment on column MIS_REPORT_NCP.AREA_NAME is '区域名称';
comment on column MIS_REPORT_NCP.GAME_CODE is '游戏';
comment on column MIS_REPORT_NCP.ISSUE_NUMBER is '游戏期次';
comment on column MIS_REPORT_NCP.SALE_SUM is '销售总额';
comment on column MIS_REPORT_NCP.SALE_COUNT is '销售票数';
comment on column MIS_REPORT_NCP.CANCEL_SUM is '退票总额';
comment on column MIS_REPORT_NCP.CANCEL_COUNT is '退票票数';
comment on column MIS_REPORT_NCP.PAY_SUM is '兑奖总额';
comment on column MIS_REPORT_NCP.PAY_COUNT is '兑奖票数';
comment on column MIS_REPORT_NCP.SALE_COMM_SUM is '销售代销费金额';
comment on column MIS_REPORT_NCP.PAY_COMM_COUNT is '兑奖代销费金额';

create table MIS_REPORT_3121(
	SALE_YEAR NUMBER(4)  not null,
	GAME_CODE NUMBER(3)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME VARCHAR2(1000)  not null,
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
	constraint PK_MIS_REPORT_3121 primary Key (SALE_YEAR,GAME_CODE,AREA_CODE)
);
comment on table MIS_REPORT_3121 is '销售年报';
comment on column MIS_REPORT_3121.SALE_YEAR is '销售年度';
comment on column MIS_REPORT_3121.GAME_CODE is '游戏';
comment on column MIS_REPORT_3121.AREA_CODE is '区域编码';
comment on column MIS_REPORT_3121.AREA_NAME is '区域名称';
comment on column MIS_REPORT_3121.SALE_SUM is '销售总额';
comment on column MIS_REPORT_3121.SALE_SUM_1 is '1月销售额';
comment on column MIS_REPORT_3121.SALE_SUM_2 is '2月销售额';
comment on column MIS_REPORT_3121.SALE_SUM_3 is '3月销售额';
comment on column MIS_REPORT_3121.SALE_SUM_4 is '4月销售额';
comment on column MIS_REPORT_3121.SALE_SUM_5 is '5月销售额';
comment on column MIS_REPORT_3121.SALE_SUM_6 is '6月销售额';
comment on column MIS_REPORT_3121.SALE_SUM_7 is '7月销售额';
comment on column MIS_REPORT_3121.SALE_SUM_8 is '8月销售额';
comment on column MIS_REPORT_3121.SALE_SUM_9 is '9月销售额';
comment on column MIS_REPORT_3121.SALE_SUM_10 is '10月销售额';
comment on column MIS_REPORT_3121.SALE_SUM_11 is '11月销售额';
comment on column MIS_REPORT_3121.SALE_SUM_12 is '12月销售额';

create table MIS_REPORT_3122(
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME VARCHAR2(1000)  not null,
	SALE_SUM NUMBER(28) default 0 not null,
	CANCEL_SUM NUMBER(28) default 0 not null,
	WIN_SUM NUMBER(28) default 0 not null,
	constraint PK_MIS_REPORT_3122 primary Key (GAME_CODE,ISSUE_NUMBER,AREA_CODE)
);
comment on table MIS_REPORT_3122 is '区域游戏期销售、退票与中奖表';
comment on column MIS_REPORT_3122.GAME_CODE is '游戏';
comment on column MIS_REPORT_3122.ISSUE_NUMBER is '游戏期次';
comment on column MIS_REPORT_3122.AREA_CODE is '区域编码';
comment on column MIS_REPORT_3122.AREA_NAME is '区域名称';
comment on column MIS_REPORT_3122.SALE_SUM is '销售金额';
comment on column MIS_REPORT_3122.CANCEL_SUM is '退票金额';
comment on column MIS_REPORT_3122.WIN_SUM is '中奖金额';

create table MIS_REPORT_3123(
	PAY_DATE DATE  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME VARCHAR2(1000)  not null,
	KOC6HC_PAYMENT_SUM NUMBER(28) default 0 not null,
	KOC6HC_PAYMENT_TICKET NUMBER(28) default 0 not null,
	KOCSSC_PAYMENT_SUM NUMBER(28) default 0 not null,
	KOCSSC_PAYMENT_TICKET NUMBER(28) default 0 not null,
	KOCKENO_PAYMENT_SUM NUMBER(28) default 0 not null,
	KOCKENO_PAYMENT_TICKET NUMBER(28) default 0 not null,
	KOCQ2_PAYMENT_SUM NUMBER(28) default 0 not null,
	KOCQ2_PAYMENT_TICKET NUMBER(28) default 0 not null,
	PAYMENT_SUM NUMBER(28) default 0 not null,
	constraint PK_MIS_REPORT_3123 primary Key (PAY_DATE,AREA_CODE)
);
comment on table MIS_REPORT_3123 is '区域游戏兑奖统计日报表';
comment on column MIS_REPORT_3123.PAY_DATE is '兑奖日期';
comment on column MIS_REPORT_3123.AREA_CODE is '区域编码';
comment on column MIS_REPORT_3123.AREA_NAME is '区域名称';
comment on column MIS_REPORT_3123.KOC6HC_PAYMENT_SUM is '天天赢兑奖金额';
comment on column MIS_REPORT_3123.KOC6HC_PAYMENT_TICKET is '天天赢兑奖票数';
comment on column MIS_REPORT_3123.KOCSSC_PAYMENT_SUM is '七龙星兑奖金额';
comment on column MIS_REPORT_3123.KOCSSC_PAYMENT_TICKET is '七龙星兑奖票数';
comment on column MIS_REPORT_3123.KOCKENO_PAYMENT_SUM is 'KENO兑奖金额';
comment on column MIS_REPORT_3123.KOCKENO_PAYMENT_TICKET is 'KENO兑奖票数';
comment on column MIS_REPORT_3123.KOCQ2_PAYMENT_SUM is '快2兑奖金额';
comment on column MIS_REPORT_3123.KOCQ2_PAYMENT_TICKET is '快2兑奖票数';
comment on column MIS_REPORT_3123.PAYMENT_SUM is '兑奖金额合计';

create table MIS_REPORT_3124(
	GAME_CODE NUMBER(3)  not null,
	PAY_DATE DATE  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME VARCHAR2(1000)  not null,
	HD_PAYMENT_SUM NUMBER(28) default 0 not null,
	HD_PAYMENT_AMOUNT NUMBER(28) default 0 not null,
	HD_PAYMENT_TAX NUMBER(28) default 0 not null,
	LD_PAYMENT_SUM NUMBER(28) default 0 not null,
	LD_PAYMENT_AMOUNT NUMBER(28) default 0 not null,
	LD_PAYMENT_TAX NUMBER(28) default 0 not null,
	PAYMENT_SUM NUMBER(28) default 0 not null,
	constraint PK_MIS_REPORT_3124 primary Key (GAME_CODE,PAY_DATE,AREA_CODE)
);
comment on table MIS_REPORT_3124 is '高等奖兑奖统计表';
comment on column MIS_REPORT_3124.GAME_CODE is '游戏';
comment on column MIS_REPORT_3124.PAY_DATE is '兑奖日期';
comment on column MIS_REPORT_3124.AREA_CODE is '区域编码';
comment on column MIS_REPORT_3124.AREA_NAME is '区域名称';
comment on column MIS_REPORT_3124.HD_PAYMENT_SUM is '高等奖兑奖金额';
comment on column MIS_REPORT_3124.HD_PAYMENT_AMOUNT is '高等奖兑奖注数';
comment on column MIS_REPORT_3124.HD_PAYMENT_TAX is '高等奖兑奖缴税额';
comment on column MIS_REPORT_3124.LD_PAYMENT_SUM is '低等奖兑奖金额';
comment on column MIS_REPORT_3124.LD_PAYMENT_AMOUNT is '低等奖兑奖注数';
comment on column MIS_REPORT_3124.LD_PAYMENT_TAX is '低等奖兑奖缴税额';
comment on column MIS_REPORT_3124.PAYMENT_SUM is '兑奖金额合计';

create table MIS_REPORT_3125(
	SALE_DATE DATE  not null,
	GAME_CODE NUMBER(3)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME VARCHAR2(1000)  not null,
	SALE_SUM NUMBER(28) default 0 not null,
	SALE_COUNT NUMBER(28) default 0 not null,
	SALE_BET NUMBER(28) default 0 not null,
	SINGLE_TICKET_AMOUNT NUMBER(28) default 0 not null,
	constraint PK_MIS_REPORT_3125 primary Key (SALE_DATE,GAME_CODE,AREA_CODE)
);
comment on table MIS_REPORT_3125 is '区域游戏销售汇总表';
comment on column MIS_REPORT_3125.SALE_DATE is '销售日期';
comment on column MIS_REPORT_3125.GAME_CODE is '游戏';
comment on column MIS_REPORT_3125.AREA_CODE is '区域编码';
comment on column MIS_REPORT_3125.AREA_NAME is '区域名称';
comment on column MIS_REPORT_3125.SALE_SUM is '销售总额';
comment on column MIS_REPORT_3125.SALE_COUNT is '销售票数';
comment on column MIS_REPORT_3125.SALE_BET is '销售注数';
comment on column MIS_REPORT_3125.SINGLE_TICKET_AMOUNT is '平均单票投注额';

create table MIS_AGENCY_WIN_STAT(
	AGENCY_CODE CHAR(8)  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	PRIZE_LEVEL NUMBER(3)  not null,
	PRIZE_NAME VARCHAR2(1000)  not null,
	IS_HD_PRIZE NUMBER(1) default 0 not null,
	WINNING_COUNT NUMBER(16) default 0 not null,
	SINGLE_BET_REWARD NUMBER(16) default 0 not null,
	constraint PK_MIS_AGENCY_WIN_STAT primary Key (AGENCY_CODE,GAME_CODE,ISSUE_NUMBER,PRIZE_LEVEL)
);
comment on table MIS_AGENCY_WIN_STAT is '销售站期次中奖统计表';
comment on column MIS_AGENCY_WIN_STAT.AGENCY_CODE is '销售站编码';
comment on column MIS_AGENCY_WIN_STAT.GAME_CODE is '游戏编码';
comment on column MIS_AGENCY_WIN_STAT.ISSUE_NUMBER is '游戏期号';
comment on column MIS_AGENCY_WIN_STAT.PRIZE_LEVEL is '奖等';
comment on column MIS_AGENCY_WIN_STAT.PRIZE_NAME is '奖等名称';
comment on column MIS_AGENCY_WIN_STAT.IS_HD_PRIZE is '是否高等奖';
comment on column MIS_AGENCY_WIN_STAT.WINNING_COUNT is '中奖注数';
comment on column MIS_AGENCY_WIN_STAT.SINGLE_BET_REWARD is '单注奖金';

create table MIS_REPORT_GUI_ABAND(
	PAY_DATE DATE  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	PRIZE_LEVEL NUMBER(3)  ,
	PRIZE_BET_COUNT NUMBER(16)  ,
	PRIZE_TICKET_COUNT NUMBER(16)  ,
	IS_HD_PRIZE NUMBER(1)  ,
	WINNINGAMOUNTTAX NUMBER(16)  ,
	WINNINGAMOUNT NUMBER(16)  ,
	TAXAMOUNT NUMBER(16)  ,
	constraint PK_MIS_REPORT_GUI_ABANDON primary Key (PAY_DATE,GAME_CODE,ISSUE_NUMBER,PRIZE_LEVEL)
);
comment on table MIS_REPORT_GUI_ABAND is '弃奖统计GUI报表';
comment on column MIS_REPORT_GUI_ABAND.PAY_DATE is '弃奖日期';
comment on column MIS_REPORT_GUI_ABAND.GAME_CODE is '游戏';
comment on column MIS_REPORT_GUI_ABAND.ISSUE_NUMBER is '游戏期次';
comment on column MIS_REPORT_GUI_ABAND.PRIZE_LEVEL is '奖等';
comment on column MIS_REPORT_GUI_ABAND.PRIZE_BET_COUNT is '弃奖注数';
comment on column MIS_REPORT_GUI_ABAND.PRIZE_TICKET_COUNT is '弃奖票数';
comment on column MIS_REPORT_GUI_ABAND.IS_HD_PRIZE is '是否高等奖';
comment on column MIS_REPORT_GUI_ABAND.WINNINGAMOUNTTAX is '弃奖金额(税前)';
comment on column MIS_REPORT_GUI_ABAND.WINNINGAMOUNT is '弃奖金额(税后)';
comment on column MIS_REPORT_GUI_ABAND.TAXAMOUNT is '税额';

/******************************************************************************************************/
/*****************************          统计结果（每日统计结果记录）           ************************/
/******************************************************************************************************/
-- 区域中奖统计表（MIS_REPORT_3113）
create table CALC_RST_3113(
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
   CALC_DATE date not null,
	constraint PK_CALC_REPORT_3113 primary Key (GAME_CODE,ISSUE_NUMBER,AREA_CODE,CALC_DATE)
);

-- 2.1.17.7 销售年报（MIS_REPORT_3121）
create table CALC_RST_3121(
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
   CALC_DATE date not null,
	constraint PK_CALC_REPORT_3121 primary Key (SALE_YEAR,GAME_CODE,AREA_CODE,CALC_DATE)
);

-- 2.1.17.8 区域游戏期销售、退票与中奖表（MIS_REPORT_3122）
create table CALC_RST_3122(
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	AREA_CODE CHAR(2)  not null,
	AREA_NAME VARCHAR2(4000),
	SALE_SUM NUMBER(28) default 0 not null,
	CANCEL_SUM NUMBER(28) default 0 not null,
	WIN_SUM NUMBER(28) default 0 not null,
   CALC_DATE date not null,
	constraint PK_CALC_REPORT_3122 primary Key (GAME_CODE,ISSUE_NUMBER,AREA_CODE,CALC_DATE)
);
