create table INF_GAMES(
	GAME_CODE NUMBER(3)  not null,
	GAME_MARK VARCHAR2(10)  not null,
	BASIC_TYPE NUMBER(1)  not null,
	FULL_NAME VARCHAR2(500)  not null,
	SHORT_NAME VARCHAR2(500)  not null,
	ISSUING_ORGANIZATION VARCHAR2(1000)  ,
	constraint PK_INF_GAMES primary Key (GAME_CODE)
);
comment on table INF_GAMES is '游戏基本信息';
comment on column INF_GAMES.GAME_CODE is '游戏编码（1=双色球,2=3D,4=七乐彩,5=时时彩,6=天天赢,7=七龙星,11=快三,12=11选5,13=K时时彩,14=K基诺）';
comment on column INF_GAMES.GAME_MARK is '游戏标识';
comment on column INF_GAMES.BASIC_TYPE is '游戏类型（1=基诺,2=乐透,3=数字,4=竞彩）';
comment on column INF_GAMES.FULL_NAME is '游戏名称';
comment on column INF_GAMES.SHORT_NAME is '游戏缩写';
comment on column INF_GAMES.ISSUING_ORGANIZATION is '发行单位';
create index UDX_INF_GAMES_MARK on INF_GAMES(GAME_MARK);

create table INF_DEVICES(
	DEVICE_ID NUMBER(8)  not null,
	DEVICE_NAME VARCHAR2(100)  not null,
	IP_ADDR VARCHAR2(50)  ,
	DEVICE_STATUS NUMBER(1)  not null,
	DEVICE_TYPE NUMBER(1)  not null,
	GAME_CODE NUMBER(3)  ,
	constraint PK_INF_DEVICES primary Key (DEVICE_ID)
);
comment on table INF_DEVICES is '系统设备';
comment on column INF_DEVICES.DEVICE_ID is '设备编号';
comment on column INF_DEVICES.DEVICE_NAME is '设备名称';
comment on column INF_DEVICES.IP_ADDR is 'IP地址';
comment on column INF_DEVICES.DEVICE_STATUS is '设备状态（0=未连接；1=已连接；2=正在使用）';
comment on column INF_DEVICES.DEVICE_TYPE is '设备类型（1=RNG）';
comment on column INF_DEVICES.GAME_CODE is '游戏编码(0=所有快开游戏，其他数值对应游戏)';

create table INF_TERMINAL_TYPES(
	TERM_TYPE_ID NUMBER(4)  not null,
	TERM_TYPE_DESC VARCHAR2(1000)  not null,
	constraint PK_INF_TERM_TYPES primary Key (TERM_TYPE_ID)
);
comment on table INF_TERMINAL_TYPES is '终端机类型';
comment on column INF_TERMINAL_TYPES.TERM_TYPE_ID is '类型编码';
comment on column INF_TERMINAL_TYPES.TERM_TYPE_DESC is '类型描述';

create table GP_STATIC(
	GAME_CODE NUMBER(3)  not null,
	DRAW_MODE NUMBER(1)  not null,
	SINGLEBET_AMOUNT NUMBER(16)  not null,
	SINGLETICKET_MAX_ISSUES NUMBER(2)  not null,
	LIMIT_BIG_PRIZE NUMBER(16)  not null,
	LIMIT_PAYMENT NUMBER(16)  not null,
	LIMIT_PAYMENT2 NUMBER(16)  not null,
	LIMIT_CANCEL2 NUMBER(16)  not null,
	ABANDON_REWARD_COLLECT NUMBER(1)  not null,
	constraint PK_GP_STATIC primary Key (GAME_CODE)
);
comment on table GP_STATIC is '游戏只读参数';
comment on column GP_STATIC.GAME_CODE is '游戏编码';
comment on column GP_STATIC.DRAW_MODE is '开奖模式（1=快开、2=内部算奖、3=外部算奖）';
comment on column GP_STATIC.SINGLEBET_AMOUNT is '单注投注金额（单位分）';
comment on column GP_STATIC.SINGLETICKET_MAX_ISSUES is '多期销售期数限制（1-20）';
comment on column GP_STATIC.LIMIT_BIG_PRIZE is '大奖金额（单位分）';
comment on column GP_STATIC.LIMIT_PAYMENT is '游戏兑奖保护限额（系统兑奖业务上限）（单位分）';
comment on column GP_STATIC.LIMIT_PAYMENT2 is '“一级区域”兑奖金额上限（单位分）';
comment on column GP_STATIC.LIMIT_CANCEL2 is '“一级区域”退票金额上限（单位分）';
comment on column GP_STATIC.ABANDON_REWARD_COLLECT is '弃奖去处（1=奖池、2=调节基金、3=公益金）';

create table GP_DYNAMIC(
	GAME_CODE NUMBER(3)  not null,
	SINGLELINE_MAX_AMOUNT NUMBER(16)  not null,
	SINGLETICKET_MAX_LINE NUMBER(16)  not null,
	SINGLETICKET_MAX_AMOUNT NUMBER(16)  not null,
	CANCEL_SEC NUMBER(8)  not null,
	SALER_PAY_LIMIT NUMBER(16)  ,
	SALER_CANCEL_LIMIT NUMBER(16)  ,
	ISSUE_CLOSE_ALERT_TIME NUMBER(16)  ,
	IS_PAY NUMBER(1) default 1 not null,
	IS_SALE NUMBER(1) default 1 not null,
	IS_CANCEL NUMBER(1) default 1 not null,
	IS_AUTO_DRAW NUMBER(1) default 1 not null,
	SERVICE_TIME_1 VARCHAR2(20)  ,
	SERVICE_TIME_2 VARCHAR2(20)  ,
	AUDIT_SINGLE_TICKET_SALE NUMBER(28)  ,
	AUDIT_SINGLE_TICKET_PAY NUMBER(28)  ,
	AUDIT_SINGLE_TICKET_CANCEL NUMBER(28)  ,
	CALC_WINNING_CODE VARCHAR2(1000)  ,
	constraint PK_GP_DYNAMIC primary Key (GAME_CODE)
);
comment on table GP_DYNAMIC is '游戏动态参数';
comment on column GP_DYNAMIC.GAME_CODE is '游戏编码';
comment on column GP_DYNAMIC.SINGLELINE_MAX_AMOUNT is '单行最大倍数';
comment on column GP_DYNAMIC.SINGLETICKET_MAX_LINE is '单票最大投注行数';
comment on column GP_DYNAMIC.SINGLETICKET_MAX_AMOUNT is '单票最大销售限额（单位分）';
comment on column GP_DYNAMIC.CANCEL_SEC is '允许退票时间（单位秒）';
comment on column GP_DYNAMIC.SALER_PAY_LIMIT is '普通销售员兑奖限额（单位分）';
comment on column GP_DYNAMIC.SALER_CANCEL_LIMIT is '普通销售员退票限额（单位分）';
comment on column GP_DYNAMIC.ISSUE_CLOSE_ALERT_TIME is '销售关闭倒数时间（单位秒）';
comment on column GP_DYNAMIC.IS_PAY is '是否可兑奖';
comment on column GP_DYNAMIC.IS_SALE is '是否可销售';
comment on column GP_DYNAMIC.IS_CANCEL is '是否可取消';
comment on column GP_DYNAMIC.IS_AUTO_DRAW is '是否自动开奖';
comment on column GP_DYNAMIC.SERVICE_TIME_1 is '游戏每日服务时间段一';
comment on column GP_DYNAMIC.SERVICE_TIME_2 is '游戏每日服务时间段二';
comment on column GP_DYNAMIC.AUDIT_SINGLE_TICKET_SALE is '单票销售金额告警阈值';
comment on column GP_DYNAMIC.AUDIT_SINGLE_TICKET_PAY is '单票兑奖金额告警阈值';
comment on column GP_DYNAMIC.AUDIT_SINGLE_TICKET_CANCEL is '单票退票金额告警阈值';
comment on column GP_DYNAMIC.CALC_WINNING_CODE is '算奖字符串';

create table GP_HISTORY(
	HIS_HIS_CODE NUMBER(8)  not null,
	HIS_MODIFY_DATE DATE default sysdate not null,
	GAME_CODE NUMBER(3)  not null,
	IS_OPEN_RISK NUMBER(1)  ,
	RISK_PARAM VARCHAR2(1000)  ,
	constraint PK_GP_HISTORY primary Key (HIS_HIS_CODE,GAME_CODE)
);
comment on table GP_HISTORY is '游戏历史参数';
comment on column GP_HISTORY.HIS_HIS_CODE is '历史编号';
comment on column GP_HISTORY.HIS_MODIFY_DATE is '修改时间';
comment on column GP_HISTORY.GAME_CODE is '游戏编码';
comment on column GP_HISTORY.IS_OPEN_RISK is '是否开启风险控制开关';
comment on column GP_HISTORY.RISK_PARAM is '风险控制参数';

create table GP_POLICY(
	HIS_POLICY_CODE NUMBER(8)  not null,
	HIS_MODIFY_DATE DATE  ,
	GAME_CODE NUMBER(3)  not null,
	THEORY_RATE NUMBER(10)  not null,
	FUND_RATE NUMBER(10)  not null,
	ADJ_RATE NUMBER(10)  not null,
	TAX_THRESHOLD NUMBER(10)  not null,
	TAX_RATE NUMBER(10)  not null,
	DRAW_LIMIT_DAY NUMBER(10)  not null,
	constraint PK_GP_POLICY primary Key (HIS_POLICY_CODE,GAME_CODE)
);
comment on table GP_POLICY is '游戏政策参数';
comment on column GP_POLICY.HIS_POLICY_CODE is '历史编号';
comment on column GP_POLICY.HIS_MODIFY_DATE is '修改时间';
comment on column GP_POLICY.GAME_CODE is '游戏编码';
comment on column GP_POLICY.THEORY_RATE is '游戏理论返奖率';
comment on column GP_POLICY.FUND_RATE is '公益金比例';
comment on column GP_POLICY.ADJ_RATE is '调节基金比例';
comment on column GP_POLICY.TAX_THRESHOLD is '中奖缴税起征点';
comment on column GP_POLICY.TAX_RATE is '中奖缴税比例';
comment on column GP_POLICY.DRAW_LIMIT_DAY is '兑奖期';

create table GP_RULE(
	HIS_RULE_CODE NUMBER(8)  not null,
	HIS_MODIFY_DATE DATE  ,
	GAME_CODE NUMBER(3)  not null,
	RULE_CODE NUMBER(3)  not null,
	RULE_NAME VARCHAR2(1000)  not null,
	RULE_DESC VARCHAR2(4000)  not null,
	RULE_ENABLE NUMBER(1) default 1 not null,
	constraint PK_GP_RULE primary Key (HIS_RULE_CODE,GAME_CODE,RULE_CODE)
);
comment on table GP_RULE is '游戏玩法规则';
comment on column GP_RULE.HIS_RULE_CODE is '历史编号';
comment on column GP_RULE.HIS_MODIFY_DATE is '修改时间';
comment on column GP_RULE.GAME_CODE is '游戏编码';
comment on column GP_RULE.RULE_CODE is '玩法编码';
comment on column GP_RULE.RULE_NAME is '玩法名称';
comment on column GP_RULE.RULE_DESC is '玩法描述（包括投注方式等内容）';
comment on column GP_RULE.RULE_ENABLE is '是否启用（0-禁用，1-启用）';

create table GP_WIN_RULE(
	HIS_WIN_CODE NUMBER(8)  not null,
	HIS_MODIFY_DATE DATE  ,
	GAME_CODE NUMBER(3)  not null,
	WRULE_CODE NUMBER(3)  not null,
	WRULE_NAME VARCHAR2(1000)  not null,
	WRULE_DESC VARCHAR2(4000)  not null,
	constraint PK_GP_WRULE primary Key (HIS_WIN_CODE,GAME_CODE,WRULE_CODE)
);
comment on table GP_WIN_RULE is '游戏中奖规则';
comment on column GP_WIN_RULE.HIS_WIN_CODE is '历史编号';
comment on column GP_WIN_RULE.HIS_MODIFY_DATE is '修改时间';
comment on column GP_WIN_RULE.GAME_CODE is '游戏编码';
comment on column GP_WIN_RULE.WRULE_CODE is '中奖规则';
comment on column GP_WIN_RULE.WRULE_NAME is '规则名称';
comment on column GP_WIN_RULE.WRULE_DESC is '规则描述';

create table GP_PRIZE_RULE(
	HIS_PRIZE_CODE NUMBER(8)  not null,
	HIS_MODIFY_DATE DATE  ,
	GAME_CODE NUMBER(3)  not null,
	PRULE_LEVEL NUMBER(3)  not null,
	PRULE_NAME VARCHAR2(1000)  ,
	PRULE_DESC VARCHAR2(4000)  ,
	LEVEL_PRIZE NUMBER(16)  ,
	DISP_ORDER NUMBER(2)  ,
	constraint PK_GP_PRIZE_RULE primary Key (HIS_PRIZE_CODE,GAME_CODE,PRULE_LEVEL)
);
comment on table GP_PRIZE_RULE is '游戏奖级规则';
comment on column GP_PRIZE_RULE.HIS_PRIZE_CODE is '历史编号';
comment on column GP_PRIZE_RULE.HIS_MODIFY_DATE is '修改时间';
comment on column GP_PRIZE_RULE.GAME_CODE is '游戏编码';
comment on column GP_PRIZE_RULE.PRULE_LEVEL is '奖等';
comment on column GP_PRIZE_RULE.PRULE_NAME is '奖级名称';
comment on column GP_PRIZE_RULE.PRULE_DESC is '描述';
comment on column GP_PRIZE_RULE.LEVEL_PRIZE is '金额';
comment on column GP_PRIZE_RULE.DISP_ORDER is '显示顺序';

create table ISS_GAME_ISSUE(
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	ISSUE_SEQ NUMBER(12)  ,
	ISSUE_STATUS NUMBER(2)  not null,
	IS_PUBLISH NUMBER(2)  ,
	DRAW_STATE NUMBER(2)  ,
	PLAN_START_TIME DATE  ,
	PLAN_CLOSE_TIME DATE  ,
	PLAN_REWARD_TIME DATE  ,
	REAL_START_TIME DATE  ,
	REAL_CLOSE_TIME DATE  ,
	REAL_REWARD_TIME DATE  ,
	ISSUE_END_TIME DATE  ,
	CODE_INPUT_METHOLD NUMBER(1)  ,
	FIRST_DRAW_USER_ID NUMBER(10)  ,
	FIRST_DRAW_NUMBER VARCHAR2(100)  ,
	SECOND_DRAW_USER_ID NUMBER(10)  ,
	SECOND_DRAW_NUMBER VARCHAR2(100)  ,
	FINAL_DRAW_NUMBER VARCHAR2(100)  ,
	FINAL_DRAW_USER_ID NUMBER(10)  ,
	PAY_END_DAY NUMBER(16)  ,
	POOL_START_AMOUNT NUMBER(16)  ,
	POOL_CLOSE_AMOUNT NUMBER(16)  ,
	ISSUE_SALE_AMOUNT NUMBER(16)  ,
	ISSUE_SALE_TICKETS NUMBER(16)  ,
	ISSUE_SALE_BETS NUMBER(16)  ,
	ISSUE_CANCEL_AMOUNT NUMBER(16)  ,
	ISSUE_CANCEL_TICKETS NUMBER(16)  ,
	ISSUE_CANCEL_BETS NUMBER(16)  ,
	WINNING_AMOUNT NUMBER(16)  ,
	WINNING_BETS NUMBER(16)  ,
	WINNING_TICKETS NUMBER(16)  ,
	WINNING_AMOUNT_BIG NUMBER(16)  ,
	WINNING_TICKETS_BIG NUMBER(16)  ,
	ISSUE_RICK_AMOUNT NUMBER(16)  ,
	ISSUE_RICK_TICKETS NUMBER(16)  ,
	WINNING_RESULT VARCHAR2(200)  ,
	REWARDING_ERROR_CODE NUMBER(4)  ,
	REWARDING_ERROR_MESG VARCHAR2(200)  ,
	CALC_WINNING_CODE VARCHAR2(100)  ,
	constraint PK_ISS_GAME_ISSUE primary Key (GAME_CODE,ISSUE_NUMBER)
);
comment on table ISS_GAME_ISSUE is '游戏期次管理';
comment on column ISS_GAME_ISSUE.GAME_CODE is '游戏编码';
comment on column ISS_GAME_ISSUE.ISSUE_NUMBER is '游戏期号';
comment on column ISS_GAME_ISSUE.ISSUE_SEQ is '期次序号';
comment on column ISS_GAME_ISSUE.ISSUE_STATUS is '期次状态（1=预售；2=游戏期开始；3=期即将关闭；4=游戏期关闭；5=数据封存完毕；6=开奖号码已录入；7=销售已经匹配；8=已录入奖级奖金；9=本地算奖完成；10=奖级已确认；11=开奖确认；12=中奖数据已录入数据库；13=期结全部完成）';
comment on column ISS_GAME_ISSUE.IS_PUBLISH is '是否已发布';
comment on column ISS_GAME_ISSUE.DRAW_STATE is '期次开奖状态（0=不能开奖状态；1=开奖准备状态；2=数据整理状态；3=备份状态；4=备份完成；5=第一次输入完成；6=第二次输入完成；7=开奖号码审批通过；8=开奖号码审批失败；9=开奖号码已发送；10=派奖检索完成；11=派奖输入已发送；12=中奖统计完成；13=数据稽核已发送 ；14=数据稽核完成；15=期结确认已发送；16=开奖完成）';
comment on column ISS_GAME_ISSUE.PLAN_START_TIME is '开始时间（预计）';
comment on column ISS_GAME_ISSUE.PLAN_CLOSE_TIME is '关闭时间（预计）';
comment on column ISS_GAME_ISSUE.PLAN_REWARD_TIME is '开奖时间（预计）';
comment on column ISS_GAME_ISSUE.REAL_START_TIME is '开始时间（实际）';
comment on column ISS_GAME_ISSUE.REAL_CLOSE_TIME is '关闭时间（实际）';
comment on column ISS_GAME_ISSUE.REAL_REWARD_TIME is '开奖时间（实际）';
comment on column ISS_GAME_ISSUE.ISSUE_END_TIME is '期结时间';
comment on column ISS_GAME_ISSUE.CODE_INPUT_METHOLD is '开奖号码输入模式（1=手工；2=光盘）';
comment on column ISS_GAME_ISSUE.FIRST_DRAW_USER_ID is '第一次开奖用户';
comment on column ISS_GAME_ISSUE.FIRST_DRAW_NUMBER is '第一次开奖号码';
comment on column ISS_GAME_ISSUE.SECOND_DRAW_USER_ID is '第二次开奖用户';
comment on column ISS_GAME_ISSUE.SECOND_DRAW_NUMBER is '第二次开奖号码';
comment on column ISS_GAME_ISSUE.FINAL_DRAW_NUMBER is '最终开奖号码';
comment on column ISS_GAME_ISSUE.FINAL_DRAW_USER_ID is '开奖号码审批人';
comment on column ISS_GAME_ISSUE.PAY_END_DAY is '兑奖截止日期（天）';
comment on column ISS_GAME_ISSUE.POOL_START_AMOUNT is '期初奖池';
comment on column ISS_GAME_ISSUE.POOL_CLOSE_AMOUNT is '期末奖池';
comment on column ISS_GAME_ISSUE.ISSUE_SALE_AMOUNT is '销售金额';
comment on column ISS_GAME_ISSUE.ISSUE_SALE_TICKETS is '销售票数';
comment on column ISS_GAME_ISSUE.ISSUE_SALE_BETS is '销售注数';
comment on column ISS_GAME_ISSUE.ISSUE_CANCEL_AMOUNT is '退票总额';
comment on column ISS_GAME_ISSUE.ISSUE_CANCEL_TICKETS is '退票张数';
comment on column ISS_GAME_ISSUE.ISSUE_CANCEL_BETS is '退票住数';
comment on column ISS_GAME_ISSUE.WINNING_AMOUNT is '中奖总额';
comment on column ISS_GAME_ISSUE.WINNING_BETS is '中奖注数';
comment on column ISS_GAME_ISSUE.WINNING_TICKETS is '中奖票数';
comment on column ISS_GAME_ISSUE.WINNING_AMOUNT_BIG is '大奖金额';
comment on column ISS_GAME_ISSUE.WINNING_TICKETS_BIG is '大奖票数';
comment on column ISS_GAME_ISSUE.ISSUE_RICK_AMOUNT is '风控拒绝金额';
comment on column ISS_GAME_ISSUE.ISSUE_RICK_TICKETS is '风控拒绝票数';
comment on column ISS_GAME_ISSUE.WINNING_RESULT is '开奖号码';
comment on column ISS_GAME_ISSUE.REWARDING_ERROR_CODE is '开奖过程错误编码';
comment on column ISS_GAME_ISSUE.REWARDING_ERROR_MESG is '开奖过程错误描述';
comment on column ISS_GAME_ISSUE.CALC_WINNING_CODE is '算奖字符串';
create index IDX_ISS_GAME_ISSUE_START on ISS_GAME_ISSUE(REAL_START_TIME);
create index IDX_ISS_GAME_ISSUE_CLOSE on ISS_GAME_ISSUE(REAL_CLOSE_TIME);
create index IDX_ISS_GAME_ISSUE_WIN on ISS_GAME_ISSUE(REAL_REWARD_TIME);
create index IDX_ISS_GAME_ISSUE_PAYEND on ISS_GAME_ISSUE(PAY_END_DAY);

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
comment on table ISS_GAME_ISSUE_XML is '游戏期次XML';
comment on column ISS_GAME_ISSUE_XML.GAME_CODE is '游戏编码';
comment on column ISS_GAME_ISSUE_XML.ISSUE_NUMBER is '游戏期号';
comment on column ISS_GAME_ISSUE_XML.WINNING_BRODCAST is '期次开奖公告';
comment on column ISS_GAME_ISSUE_XML.WINNER_LOCAL_INFO is '本系统的算奖结果信息';
comment on column ISS_GAME_ISSUE_XML.WINNER_CONFIRM_INFO is '确认后的算奖结果信息';
comment on column ISS_GAME_ISSUE_XML.JSON_WINNING_BRODCAST is 'JSON开奖公告';
comment on column ISS_GAME_ISSUE_XML.WINNING_PROCESS is '算奖进度';

create table ISS_GAME_ISSUE_MODULE(
	GAME_CODE NUMBER(3)  not null,
	XML_CONTENT VARCHAR2(4000)  ,
  ISSUE_NUMBER	NUMBER(12),
	constraint PK_ISS_GAME_ISSUE_MODULE primary Key (GAME_CODE)
);
comment on table ISS_GAME_ISSUE_MODULE is '游戏期次模板';
comment on column ISS_GAME_ISSUE_MODULE.GAME_CODE is '游戏编码';
comment on column ISS_GAME_ISSUE_MODULE.XML_CONTENT is '模板XML';
comment on column ISS_GAME_ISSUE_MODULE.ISSUE_NUMBER is '期次编号';

create table ISS_CURRENT_PARAM(
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	HIS_HIS_CODE NUMBER(8)  not null,
	HIS_POLICY_CODE NUMBER(8)  not null,
	HIS_RULE_CODE NUMBER(8)  not null,
	HIS_WIN_CODE NUMBER(8)  not null,
	HIS_PRIZE_CODE NUMBER(8)  not null,
	constraint PK_ISS_CP primary Key (GAME_CODE,ISSUE_NUMBER)
);
comment on table ISS_CURRENT_PARAM is '游戏期次参数';
comment on column ISS_CURRENT_PARAM.GAME_CODE is '游戏编码';
comment on column ISS_CURRENT_PARAM.ISSUE_NUMBER is '游戏期号';
comment on column ISS_CURRENT_PARAM.HIS_HIS_CODE is '动态参数当前历史编号';
comment on column ISS_CURRENT_PARAM.HIS_POLICY_CODE is '政策参数当前历史编号';
comment on column ISS_CURRENT_PARAM.HIS_RULE_CODE is '玩法规则当前历史编号';
comment on column ISS_CURRENT_PARAM.HIS_WIN_CODE is '中奖规则当前历史编号';
comment on column ISS_CURRENT_PARAM.HIS_PRIZE_CODE is '奖级规则当前历史编号';

create table ISS_GAME_PRIZE_RULE(
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	PRIZE_LEVEL NUMBER(3)  not null,
	PRIZE_NAME VARCHAR2(1000)  ,
	LEVEL_PRIZE NUMBER(16)  not null,
	DISP_ORDER NUMBER(2)  ,
	constraint PK_ISS_GAME_PRIZE_RULE primary Key (GAME_CODE,ISSUE_NUMBER,PRIZE_LEVEL)
);
comment on table ISS_GAME_PRIZE_RULE is '游戏期次奖金规则';
comment on column ISS_GAME_PRIZE_RULE.GAME_CODE is '游戏编码';
comment on column ISS_GAME_PRIZE_RULE.ISSUE_NUMBER is '游戏期号';
comment on column ISS_GAME_PRIZE_RULE.PRIZE_LEVEL is '奖等';
comment on column ISS_GAME_PRIZE_RULE.PRIZE_NAME is '奖等名称';
comment on column ISS_GAME_PRIZE_RULE.LEVEL_PRIZE is '奖级奖金';
comment on column ISS_GAME_PRIZE_RULE.DISP_ORDER is '显示顺序';

create table ISS_PRIZE(
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	PRIZE_LEVEL NUMBER(3)  not null,
	PRIZE_NAME VARCHAR2(1000)  ,
	IS_HD_PRIZE NUMBER(1)  not null,
	PRIZE_COUNT NUMBER(8)  not null,
	SINGLE_BET_REWARD NUMBER(16)  not null,
	SINGLE_BET_REWARD_TAX NUMBER(16)  ,
	TAX NUMBER(16)  ,
	constraint PK_ISS_PRIZE primary Key (GAME_CODE,ISSUE_NUMBER,PRIZE_LEVEL)
);
comment on table ISS_PRIZE is '游戏期次奖级奖金';
comment on column ISS_PRIZE.GAME_CODE is '游戏编码';
comment on column ISS_PRIZE.ISSUE_NUMBER is '游戏期号';
comment on column ISS_PRIZE.PRIZE_LEVEL is '奖等';
comment on column ISS_PRIZE.PRIZE_NAME is '奖等名称';
comment on column ISS_PRIZE.IS_HD_PRIZE is '是否高等奖';
comment on column ISS_PRIZE.PRIZE_COUNT is '中奖注数';
comment on column ISS_PRIZE.SINGLE_BET_REWARD is '单注奖金';
comment on column ISS_PRIZE.SINGLE_BET_REWARD_TAX is '税后单注奖金';
comment on column ISS_PRIZE.TAX is '税金';

create table ISS_GAME_POLICY_FUND(
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	SALE_AMOUNT NUMBER(28)  ,
	THEORY_WIN_AMOUNT NUMBER(28)  ,
	FUND_AMOUNT NUMBER(28)  ,
	COMM_AMOUNT NUMBER(28)  ,
	ADJ_FUND NUMBER(28)  ,
	constraint PK_ISS_GAME_POLICY_FUND primary Key (GAME_CODE,ISSUE_NUMBER)
);
comment on table ISS_GAME_POLICY_FUND is '游戏期次政策资金表';
comment on column ISS_GAME_POLICY_FUND.GAME_CODE is '游戏编码';
comment on column ISS_GAME_POLICY_FUND.ISSUE_NUMBER is '游戏期号';
comment on column ISS_GAME_POLICY_FUND.SALE_AMOUNT is '销售金额';
comment on column ISS_GAME_POLICY_FUND.THEORY_WIN_AMOUNT is '理论返奖';
comment on column ISS_GAME_POLICY_FUND.FUND_AMOUNT is '公益金';
comment on column ISS_GAME_POLICY_FUND.COMM_AMOUNT is '发行费';
comment on column ISS_GAME_POLICY_FUND.ADJ_FUND is '调节基金';

create table ISS_GAME_POOL(
	GAME_CODE NUMBER(3)  not null,
	POOL_CODE NUMBER(1)  not null,
	POOL_NAME VARCHAR2(1000)  ,
	POOL_AMOUNT_BEFORE NUMBER(28)  ,
	POOL_AMOUNT_AFTER NUMBER(28)  ,
	ADJ_TIME DATE  ,
	POOL_DESC VARCHAR2(4000)  ,
	constraint PK_ISS_GAME_POOL primary Key (GAME_CODE,POOL_CODE)
);
comment on table ISS_GAME_POOL is '游戏当前奖池信息';
comment on column ISS_GAME_POOL.GAME_CODE is '游戏编码';
comment on column ISS_GAME_POOL.POOL_CODE is '奖池编号';
comment on column ISS_GAME_POOL.POOL_NAME is '奖池名称';
comment on column ISS_GAME_POOL.POOL_AMOUNT_BEFORE is '前次调整余额';
comment on column ISS_GAME_POOL.POOL_AMOUNT_AFTER is '奖池金额';
comment on column ISS_GAME_POOL.ADJ_TIME is '最后变更时间';
comment on column ISS_GAME_POOL.POOL_DESC is '奖池描述';

create table ISS_GAME_POOL_ADJ(
	POOL_FLOW CHAR(32)  not null,
	GAME_CODE NUMBER(3)  not null,
	POOL_CODE NUMBER(1)  not null,
	POOL_ADJ_TYPE NUMBER(1)  not null,
	ADJ_AMOUNT NUMBER(28)  not null,
	POOL_AMOUNT_BEFORE NUMBER(28)  ,
	POOL_AMOUNT_AFTER NUMBER(28)  ,
	ADJ_DESC VARCHAR2(1000)  ,
	ADJ_TIME DATE  ,
	ADJ_ADMIN NUMBER(4)  not null,
	IS_ADJ NUMBER(1) default 1 not null,
	constraint PK_ISS_GAME_POOL_ADJ primary Key (POOL_FLOW)
);
comment on table ISS_GAME_POOL_ADJ is '游戏奖池手工调整信息';
comment on column ISS_GAME_POOL_ADJ.POOL_FLOW is '变更流水';
comment on column ISS_GAME_POOL_ADJ.GAME_CODE is '游戏编码';
comment on column ISS_GAME_POOL_ADJ.POOL_CODE is '奖池编号';
comment on column ISS_GAME_POOL_ADJ.POOL_ADJ_TYPE is '奖池变更类型（1、期次开奖滚入；2、弃奖滚入；3、调节基金自动拨入；4、调节基金手动拨入；5、发行费手动拨入；6、其他来源手动拨入；7、奖池初始化设置。）';
comment on column ISS_GAME_POOL_ADJ.ADJ_AMOUNT is '变更金额';
comment on column ISS_GAME_POOL_ADJ.POOL_AMOUNT_BEFORE is '变更前奖池金额';
comment on column ISS_GAME_POOL_ADJ.POOL_AMOUNT_AFTER is '变更后奖池金额';
comment on column ISS_GAME_POOL_ADJ.ADJ_DESC is '变更备注';
comment on column ISS_GAME_POOL_ADJ.ADJ_TIME is '变更时间';
comment on column ISS_GAME_POOL_ADJ.ADJ_ADMIN is '变更人员';
comment on column ISS_GAME_POOL_ADJ.IS_ADJ is '变更是否已生效';

create table ISS_GAME_POOL_HIS(
	HIS_CODE NUMBER(8)  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	POOL_CODE NUMBER(1)  not null,
	CHANGE_AMOUNT NUMBER(28)  not null,
	POOL_AMOUNT_BEFORE NUMBER(28)  not null,
	POOL_AMOUNT_AFTER NUMBER(28)  not null,
	ADJ_TIME DATE default sysdate not null,
	POOL_ADJ_TYPE NUMBER(1)  not null,
	ADJ_REASON VARCHAR2(1000)  ,
	POOL_FLOW CHAR(32)  ,
	constraint PK_ISS_GAME_POOL_HIS primary Key (HIS_CODE)
);
comment on table ISS_GAME_POOL_HIS is '游戏奖池历史信息';
comment on column ISS_GAME_POOL_HIS.HIS_CODE is '历史序号';
comment on column ISS_GAME_POOL_HIS.GAME_CODE is '游戏编码';
comment on column ISS_GAME_POOL_HIS.ISSUE_NUMBER is '游戏期号（为负数时，保存的内容是期次序号。仅用于无当前期的情形）';
comment on column ISS_GAME_POOL_HIS.POOL_CODE is '奖池编号';
comment on column ISS_GAME_POOL_HIS.CHANGE_AMOUNT is '奖池调整金额';
comment on column ISS_GAME_POOL_HIS.POOL_AMOUNT_BEFORE is '变更前金额';
comment on column ISS_GAME_POOL_HIS.POOL_AMOUNT_AFTER is '变更后金额';
comment on column ISS_GAME_POOL_HIS.ADJ_TIME is '变更时间';
comment on column ISS_GAME_POOL_HIS.POOL_ADJ_TYPE is '奖池变更类型（1、期次开奖滚入；2、弃奖滚入；3、调节基金自动拨入；4、调节基金手动拨入；5、发行费手动拨入；6、其他来源手动拨入；7、奖池初始化设置。）';
comment on column ISS_GAME_POOL_HIS.ADJ_REASON is '变更原因';
comment on column ISS_GAME_POOL_HIS.POOL_FLOW is '手工变更流水';

create table ADJ_GAME_CURRENT(
	GAME_CODE NUMBER(3)  not null,
	POOL_AMOUNT_BEFORE NUMBER(28)  ,
	POOL_AMOUNT_AFTER NUMBER(28)  ,
	constraint PK_ADJ_GAME_CURRENT primary Key (GAME_CODE)
);
comment on table ADJ_GAME_CURRENT is '游戏当前调节基金信息';
comment on column ADJ_GAME_CURRENT.GAME_CODE is '游戏编码';
comment on column ADJ_GAME_CURRENT.POOL_AMOUNT_BEFORE is '前次调整余额';
comment on column ADJ_GAME_CURRENT.POOL_AMOUNT_AFTER is '调节基金余额';

create table ADJ_GAME_CHANGE(
	ADJ_FLOW CHAR(32)  not null,
	GAME_CODE NUMBER(3)  not null,
	ADJ_AMOUNT NUMBER(28)  not null,
	ADJ_AMOUNT_BEFORE NUMBER(28)  not null,
	ADJ_AMOUNT_AFTER NUMBER(28)  not null,
	ADJ_CHANGE_TYPE NUMBER(1)  not null,
	ADJ_DESC VARCHAR2(1000)  ,
	ADJ_TIME DATE  not null,
	ADJ_ADMIN NUMBER(4)  not null,
	constraint PK_ADJ_GAME_CHANGE primary Key (ADJ_FLOW)
);
comment on table ADJ_GAME_CHANGE is '调节基金手工调整信息';
comment on column ADJ_GAME_CHANGE.ADJ_FLOW is '调整流水';
comment on column ADJ_GAME_CHANGE.GAME_CODE is '游戏编码';
comment on column ADJ_GAME_CHANGE.ADJ_AMOUNT is '变更金额';
comment on column ADJ_GAME_CHANGE.ADJ_AMOUNT_BEFORE is '变更前金额';
comment on column ADJ_GAME_CHANGE.ADJ_AMOUNT_AFTER is '变更后金额';
comment on column ADJ_GAME_CHANGE.ADJ_CHANGE_TYPE is '调节基金变更类型（1、期次开奖滚入；2、弃奖滚入；3、期次开奖自动拨出；4、手工拨出到奖池；5、发行费手工拨入调节基金； 6、其他金额手工拨入调节基金；7、期次开奖抹零滚入；8、初始化设置。）';
comment on column ADJ_GAME_CHANGE.ADJ_DESC is '变更备注';
comment on column ADJ_GAME_CHANGE.ADJ_TIME is '变更时间';
comment on column ADJ_GAME_CHANGE.ADJ_ADMIN is '变更人员';

create table ADJ_GAME_HIS(
	HIS_CODE NUMBER(8)  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	ADJ_CHANGE_TYPE NUMBER(1)  not null,
	ADJ_AMOUNT NUMBER(28)  not null,
	ADJ_AMOUNT_BEFORE NUMBER(28)  not null,
	ADJ_AMOUNT_AFTER NUMBER(28)  not null,
	ADJ_TIME DATE default sysdate not null,
	ADJ_REASON VARCHAR2(1000)  ,
	ADJ_FLOW CHAR(32)  ,
	constraint PK_ADJ_GAME_HIS primary Key (HIS_CODE)
);
comment on table ADJ_GAME_HIS is '游戏调节基金历史';
comment on column ADJ_GAME_HIS.HIS_CODE is '历史序号';
comment on column ADJ_GAME_HIS.GAME_CODE is '游戏编码';
comment on column ADJ_GAME_HIS.ISSUE_NUMBER is '游戏期号（为负数时，保存的内容是期次序号。仅用于无当前期的情形）';
comment on column ADJ_GAME_HIS.ADJ_CHANGE_TYPE is '调节基金变更类型（1、期次开奖滚入；2、弃奖滚入；3、期次开奖自动拨出；4、手工拨出到奖池；5、发行费手工拨入调节基金； 6、其他金额手工拨入调节基金；7、期次开奖抹零滚入；8、初始化设置。）';
comment on column ADJ_GAME_HIS.ADJ_AMOUNT is '调节基金调整金额';
comment on column ADJ_GAME_HIS.ADJ_AMOUNT_BEFORE is '变更前调节基金';
comment on column ADJ_GAME_HIS.ADJ_AMOUNT_AFTER is '变更后调节基金';
comment on column ADJ_GAME_HIS.ADJ_TIME is '变更时间';
comment on column ADJ_GAME_HIS.ADJ_REASON is '变更原因';
comment on column ADJ_GAME_HIS.ADJ_FLOW is '手工变更流水（当调节基金变更类型为弃奖滚入时，此字段记录【弃奖产生时所对应的期次序号】）';

create table GOV_COMMISION(
	HIS_CODE NUMBER(8)  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	COMM_CHANGE_TYPE NUMBER(1)  not null,
	ADJ_AMOUNT NUMBER(28)  not null,
	ADJ_AMOUNT_BEFORE NUMBER(28)  not null,
	ADJ_AMOUNT_AFTER NUMBER(28)  not null,
	ADJ_TIME DATE default sysdate not null,
	ADJ_REASON VARCHAR2(1000)  ,
	constraint PK_GOV_COMMISION primary Key (HIS_CODE)
);
comment on table GOV_COMMISION is '游戏发行费历史';
comment on column GOV_COMMISION.HIS_CODE is '历史序号';
comment on column GOV_COMMISION.GAME_CODE is '游戏编码';
comment on column GOV_COMMISION.ISSUE_NUMBER is '游戏期号';
comment on column GOV_COMMISION.COMM_CHANGE_TYPE is '发行费变更类型（1、期次开奖滚入；2、发行费手动拨出到奖池；3、发行费手动拨出到调节基金；9、初始化设置）';
comment on column GOV_COMMISION.ADJ_AMOUNT is '调整金额';
comment on column GOV_COMMISION.ADJ_AMOUNT_BEFORE is '变更前金额';
comment on column GOV_COMMISION.ADJ_AMOUNT_AFTER is '变更后金额';
comment on column GOV_COMMISION.ADJ_TIME is '变更时间';
comment on column GOV_COMMISION.ADJ_REASON is '变更原因';

create table COMMONWEAL_FUND(
	HIS_CODE NUMBER(8)  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	CWFUND_CHANGE_TYPE NUMBER(1)  not null,
	ADJ_AMOUNT NUMBER(28)  not null,
	ADJ_AMOUNT_BEFORE NUMBER(28)  not null,
	ADJ_AMOUNT_AFTER NUMBER(28)  not null,
	ADJ_TIME DATE default sysdate not null,
	ADJ_REASON VARCHAR2(1000)  ,
	constraint PK_GOV_PUB_FUND primary Key (HIS_CODE)
);
comment on table COMMONWEAL_FUND is '游戏公益金历史';
comment on column COMMONWEAL_FUND.HIS_CODE is '历史序号';
comment on column COMMONWEAL_FUND.GAME_CODE is '游戏编码';
comment on column COMMONWEAL_FUND.ISSUE_NUMBER is '游戏期号';
comment on column COMMONWEAL_FUND.CWFUND_CHANGE_TYPE is '公益金变更类型（1、期次开奖滚入；2、弃奖滚入；9、初始化设置）';
comment on column COMMONWEAL_FUND.ADJ_AMOUNT is '调整金额';
comment on column COMMONWEAL_FUND.ADJ_AMOUNT_BEFORE is '变更前金额';
comment on column COMMONWEAL_FUND.ADJ_AMOUNT_AFTER is '变更后金额';
comment on column COMMONWEAL_FUND.ADJ_TIME is '变更时间';
comment on column COMMONWEAL_FUND.ADJ_REASON is '变更原因';

create table SALER_TERMINAL(
	TERMINAL_CODE CHAR(10)  not null,
	AGENCY_CODE CHAR(8)  not null,
	UNIQUE_CODE VARCHAR2(20)  ,
	TERM_TYPE_ID NUMBER(4)  ,
	MAC_ADDRESS VARCHAR2(20)  not null,
	SECURITY_ID VARCHAR2(32)  ,
	STATUS NUMBER(1) default 0 not null,
	TERMINAL_FOR_PAYMENT NUMBER(1) default 0 not null,
	IS_LOGGING NUMBER(1) default 0 not null,
	LATEST_LOGIN_TELLER_CODE NUMBER(10)  ,
	TRANS_SEQ NUMBER(18) default 1 not null,
	constraint PK_SALER_TERMINAL primary Key (TERMINAL_CODE)
);
comment on table SALER_TERMINAL is '销售终端';
comment on column SALER_TERMINAL.TERMINAL_CODE is '终端编码';
comment on column SALER_TERMINAL.AGENCY_CODE is '销售站编码';
comment on column SALER_TERMINAL.UNIQUE_CODE is '销售终端标识码';
comment on column SALER_TERMINAL.TERM_TYPE_ID is '销售终端型号';
comment on column SALER_TERMINAL.MAC_ADDRESS is 'MAC地址';
comment on column SALER_TERMINAL.SECURITY_ID is '终端安全卡ID';
comment on column SALER_TERMINAL.STATUS is '销售终端状态（1=可用；2=禁用；3=退机）';
comment on column SALER_TERMINAL.TERMINAL_FOR_PAYMENT is '是否兑奖机（1=是；0=否）';
comment on column SALER_TERMINAL.IS_LOGGING is '是否已登录（1=是；0=否）';
comment on column SALER_TERMINAL.LATEST_LOGIN_TELLER_CODE is '最近登录的销售员编码';
comment on column SALER_TERMINAL.TRANS_SEQ is '终端交易序号（流水号）';
create index IDX_SALER_TERMINAL_AGENCY on SALER_TERMINAL(AGENCY_CODE);

create table SALER_AGENCY_ICON(
	ID NUMBER(16)  not null,
	ICON VARCHAR2(20)  ,
	ADMIN VARCHAR2(4000)  ,
	constraint PK_SALER_AGENCY_ICON primary Key (ID)
);
comment on table SALER_AGENCY_ICON is '销售站图例';
comment on column SALER_AGENCY_ICON.ID is '图例编号';
comment on column SALER_AGENCY_ICON.ICON is '图例服务器路径';
comment on column SALER_AGENCY_ICON.ADMIN is '专管员';

create table SALER_AGENCY_SITE(
	AGENCY_CODE CHAR(8)  not null,
	AGENCY_ICON NUMBER(16)  ,
	GLATLNG_N VARCHAR2(20)  ,
	GLATLNG_E VARCHAR2(20)  ,
	AGENCY_PART NUMBER(1)  ,
	constraint PK_SALER_AGENCY_SITE primary Key (AGENCY_CODE)
);
comment on table SALER_AGENCY_SITE is '销售站扩展';
comment on column SALER_AGENCY_SITE.AGENCY_CODE is '销售站编码';
comment on column SALER_AGENCY_SITE.AGENCY_ICON is '图例编号';
comment on column SALER_AGENCY_SITE.GLATLNG_N is '销售站经度';
comment on column SALER_AGENCY_SITE.GLATLNG_E is '销售站维度';
comment on column SALER_AGENCY_SITE.AGENCY_PART is '销售站区域（2=南区、1=北区）';

create table SALER_TERMINAL_CHECK(
	TERM_CHECK_ID NUMBER(8)  not null,
	TERMINAL_CODE CHAR(10)  not null,
	COLLECTER_ID NUMBER(4)  not null,
	CHECK_TIME DATE  not null,
	AGENCY_BALANCE NUMBER(12)  not null,
	CHECK_BALANCE NUMBER(1)  not null,
	CHECK_TERMINAL NUMBER(1)  not null,
	constraint PK_SALER_TERMINAL_CHECK primary Key (TERM_CHECK_ID)
);
comment on table SALER_TERMINAL_CHECK is '销售终端巡检';
comment on column SALER_TERMINAL_CHECK.TERM_CHECK_ID is '巡检ID';
comment on column SALER_TERMINAL_CHECK.TERMINAL_CODE is '终端编码';
comment on column SALER_TERMINAL_CHECK.COLLECTER_ID is '缴款专员ID';
comment on column SALER_TERMINAL_CHECK.CHECK_TIME is '巡检时间';
comment on column SALER_TERMINAL_CHECK.AGENCY_BALANCE is '站点余额';
comment on column SALER_TERMINAL_CHECK.CHECK_BALANCE is '站点余额检查是否正常';
comment on column SALER_TERMINAL_CHECK.CHECK_TERMINAL is '站点终端检查是否正常';

create table AUTH_ORG(
	ORG_CODE CHAR(2)  not null,
	GAME_CODE NUMBER(3)  not null,
	PAY_COMMISSION_RATE NUMBER(8) default 0 not null,
	SALE_COMMISSION_RATE NUMBER(8) default 0 not null,
	AUTH_TIME DATE default sysdate not null,
	ALLOW_PAY NUMBER(1) default 1 not null,
	ALLOW_SALE NUMBER(1) default 1 not null,
	ALLOW_CANCEL NUMBER(1) default 0 not null,
	constraint PK_AUTH_ORG primary Key (ORG_CODE,GAME_CODE)
);
comment on table AUTH_ORG is '区域游戏授权';
comment on column AUTH_ORG.ORG_CODE is '区域编码';
comment on column AUTH_ORG.GAME_CODE is '游戏CODE';
comment on column AUTH_ORG.PAY_COMMISSION_RATE is '兑奖佣金比例（千分位）';
comment on column AUTH_ORG.SALE_COMMISSION_RATE is '销售佣金比例（千分位）';
comment on column AUTH_ORG.AUTH_TIME is '授权时间';
comment on column AUTH_ORG.ALLOW_PAY is '是否可兑奖（1=是；0=否）';
comment on column AUTH_ORG.ALLOW_SALE is '是否允许销售（1=是；0=否）';
comment on column AUTH_ORG.ALLOW_CANCEL is '是否允许退票（1=是；0=否）';

create table AUTH_AGENCY(
	AGENCY_CODE CHAR(8)  not null,
	GAME_CODE NUMBER(3)  not null,
	PAY_COMMISSION_RATE NUMBER(8) default 0 not null,
	SALE_COMMISSION_RATE NUMBER(8) default 0 not null,
	ALLOW_PAY NUMBER(1) default 1 not null,
	ALLOW_SALE NUMBER(1) default 1 not null,
	ALLOW_CANCEL NUMBER(1) default 0 not null,
	CLAIMING_SCOPE NUMBER(1)  ,
	AUTH_TIME DATE default sysdate not null,
	constraint PK_AUTH_AGENCY primary Key (AGENCY_CODE,GAME_CODE)
);
comment on table AUTH_AGENCY is '销售站游戏授权';
comment on column AUTH_AGENCY.AGENCY_CODE is '销售站编码';
comment on column AUTH_AGENCY.GAME_CODE is '游戏CODE';
comment on column AUTH_AGENCY.PAY_COMMISSION_RATE is '兑奖佣金比例（千分位）';
comment on column AUTH_AGENCY.SALE_COMMISSION_RATE is '销售佣金比例（千分位）';
comment on column AUTH_AGENCY.ALLOW_PAY is '是否可兑奖（1=是；0=否）';
comment on column AUTH_AGENCY.ALLOW_SALE is '是否允许销售（1=是；0=否）';
comment on column AUTH_AGENCY.ALLOW_CANCEL is '是否允许退票（1=是；0=否）';
comment on column AUTH_AGENCY.CLAIMING_SCOPE is '兑奖范围（0=中心通兑、1=区域通兑、4=本站自兑）';
comment on column AUTH_AGENCY.AUTH_TIME is '授权时间';

create table SALE_GAMEPAYINFO(
	GUI_PAY_FLOW CHAR(24)  not null,
	PAY_TSN CHAR(24)  ,
	SALE_TSN CHAR(24)  not null,
	APPLYFLOW_SALE CHAR(24)  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	ISSUE_NUMBER_END NUMBER(12)  ,
	PAY_AMOUNT NUMBER(28)  not null,
	PAY_TAX NUMBER(28)  not null,
	PAY_AMOUNT_AFTER_TAX NUMBER(28)  not null,
	WINNERNAME VARCHAR2(1000)  ,
	GENDER NUMBER(1)  ,
	CERT_TYPE NUMBER(2)  ,
	CERT_NO VARCHAR2(50)  ,
	AGE NUMBER(2)  ,
	BIRTHDATE VARCHAR2(12)  ,
	CONTACT VARCHAR2(4000)  ,
	ORG_CODE CHAR(2)  ,
	PAYER_ADMIN NUMBER(4)  ,
	PAYER_NAME VARCHAR2(1000)  ,
	PAY_TIME DATE  ,
	PAY_ADDR VARCHAR2(4000)  ,
	IS_SUCCESS NUMBER(1) default 0 not null,
	HTML_TEXT VARCHAR2(4000)  ,
	constraint PK_SALE_GAMEPAYINFO primary Key (GUI_PAY_FLOW)
);
comment on table SALE_GAMEPAYINFO is 'GUI兑奖信息记录表';
comment on column SALE_GAMEPAYINFO.GUI_PAY_FLOW is '兑奖请求流水';
comment on column SALE_GAMEPAYINFO.PAY_TSN is '兑奖TSN';
comment on column SALE_GAMEPAYINFO.SALE_TSN is '售票TSN';
comment on column SALE_GAMEPAYINFO.APPLYFLOW_SALE is '售票请求流水号';
comment on column SALE_GAMEPAYINFO.GAME_CODE is '游戏编码';
comment on column SALE_GAMEPAYINFO.ISSUE_NUMBER is '游戏期号';
comment on column SALE_GAMEPAYINFO.ISSUE_NUMBER_END is '游戏期号（结束）';
comment on column SALE_GAMEPAYINFO.PAY_AMOUNT is '中奖金额';
comment on column SALE_GAMEPAYINFO.PAY_TAX is '税金';
comment on column SALE_GAMEPAYINFO.PAY_AMOUNT_AFTER_TAX is '税后奖金';
comment on column SALE_GAMEPAYINFO.WINNERNAME is '中奖人姓名';
comment on column SALE_GAMEPAYINFO.GENDER is '中奖人性别(1=男、2=女)';
comment on column SALE_GAMEPAYINFO.CERT_TYPE is '中奖人证件类型(10=身份证、20=护照、30=军官证、40=士兵证、50=回乡证、90=其他证件)';
comment on column SALE_GAMEPAYINFO.CERT_NO is '中奖人证件号码 ';
comment on column SALE_GAMEPAYINFO.AGE is '中奖人年龄';
comment on column SALE_GAMEPAYINFO.BIRTHDATE is '中奖人出生日期';
comment on column SALE_GAMEPAYINFO.CONTACT is '中奖人联系方式';
comment on column SALE_GAMEPAYINFO.ORG_CODE is '兑奖部门编码';
comment on column SALE_GAMEPAYINFO.PAYER_ADMIN is '兑奖操作员编号';
comment on column SALE_GAMEPAYINFO.PAYER_NAME is '兑奖操作员名称';
comment on column SALE_GAMEPAYINFO.PAY_TIME is '兑奖时间';
comment on column SALE_GAMEPAYINFO.PAY_ADDR is '兑奖地点';
comment on column SALE_GAMEPAYINFO.IS_SUCCESS is '是否成功';
comment on column SALE_GAMEPAYINFO.HTML_TEXT is '原始凭证';
create index IDX_SALE_GAMEPAY_SELL_FLOW on SALE_GAMEPAYINFO(APPLYFLOW_SALE);
create index IDX_SALE_GAMEPAY_SELL_TSN on SALE_GAMEPAYINFO(SALE_TSN);
create index IDX_SALE_GAMEPAY_PAY_TSN on SALE_GAMEPAYINFO(PAY_TSN);

create table SALE_CANCELINFO(
	GUI_CANCEL_FLOW CHAR(24)  not null,
	SALE_TSN CHAR(24)  not null,
	APPLYFLOW_SELL CHAR(24)  not null,
	CANCEL_TSN CHAR(24)  ,
	SALE_AGENCY_CODE CHAR(8)  not null,
	CANCEL_ORG_CODE CHAR(2)  not null,
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	CANCEL_AMOUNT NUMBER(28)  not null,
	CANCEL_COMM NUMBER(28)  not null,
	CANCELER_ADMIN NUMBER(4)  not null,
	CANCELER_NAME VARCHAR2(1000)  ,
	CANCEL_TIME DATE  not null,
	IS_SUCCESS NUMBER(1) default 0 not null,
	HTML_TEXT VARCHAR2(4000)  ,
	constraint PK_SALE_CANCELINFO primary Key (GUI_CANCEL_FLOW)
);
comment on table SALE_CANCELINFO is 'GUI取消信息记录表';
comment on column SALE_CANCELINFO.GUI_CANCEL_FLOW is '退票请求流水';
comment on column SALE_CANCELINFO.SALE_TSN is '销售TSN';
comment on column SALE_CANCELINFO.APPLYFLOW_SELL is '售票请求流水号';
comment on column SALE_CANCELINFO.CANCEL_TSN is '退票TSN';
comment on column SALE_CANCELINFO.SALE_AGENCY_CODE is '售票销售站';
comment on column SALE_CANCELINFO.CANCEL_ORG_CODE is '退票机构';
comment on column SALE_CANCELINFO.GAME_CODE is '游戏编码';
comment on column SALE_CANCELINFO.ISSUE_NUMBER is '游戏期号 ';
comment on column SALE_CANCELINFO.CANCEL_AMOUNT is '取消金额';
comment on column SALE_CANCELINFO.CANCEL_COMM is '佣金';
comment on column SALE_CANCELINFO.CANCELER_ADMIN is '取消操作员编号';
comment on column SALE_CANCELINFO.CANCELER_NAME is '取消操作员姓名';
comment on column SALE_CANCELINFO.CANCEL_TIME is '取消时间';
comment on column SALE_CANCELINFO.IS_SUCCESS is '是否成功';
comment on column SALE_CANCELINFO.HTML_TEXT is '原始凭证';

create table UPG_SOFTWARE(
	SOFT_ID NUMBER(8)  not null,
	SOFT_NAME VARCHAR2(1000)  ,
	SOFT_DESCRIBE VARCHAR2(1000)  ,
	CREATE_DATE DATE  ,
	constraint PK_UPG_SOFTWARE primary Key (SOFT_ID)
);
comment on table UPG_SOFTWARE is '软件';
comment on column UPG_SOFTWARE.SOFT_ID is '软件ID';
comment on column UPG_SOFTWARE.SOFT_NAME is '软件名称';
comment on column UPG_SOFTWARE.SOFT_DESCRIBE is '软件描述';
comment on column UPG_SOFTWARE.CREATE_DATE is '建立日期';

create table UPG_SOFTWARE_VER(
	SOFT_VER VARCHAR2(20)  not null,
	SOFT_ID NUMBER(8)  not null,
	ADAPT_TERM_TYPE NUMBER(4)  not null,
	RELEASE_DATE DATE  ,
	VER_DESC VARCHAR2(1000)  ,
	VER_SIZE NUMBER(16)  ,
	VER_MD5 VARCHAR2(32)  ,
	constraint PK_UPG_SOFTWARE_VER primary Key (SOFT_VER,SOFT_ID,ADAPT_TERM_TYPE)
);
comment on table UPG_SOFTWARE_VER is '软件版本';
comment on column UPG_SOFTWARE_VER.SOFT_VER is '软件版本号';
comment on column UPG_SOFTWARE_VER.SOFT_ID is '软件ID';
comment on column UPG_SOFTWARE_VER.ADAPT_TERM_TYPE is '适用终端机型';
comment on column UPG_SOFTWARE_VER.RELEASE_DATE is '发布日期';
comment on column UPG_SOFTWARE_VER.VER_DESC is '软件版本描述';
comment on column UPG_SOFTWARE_VER.VER_SIZE is '软件包大小（字节）';
comment on column UPG_SOFTWARE_VER.VER_MD5 is 'MD5值';

create table UPG_PKG_CONTEXT(
	PKG_VER VARCHAR2(20)  not null,
	SOFT_ID NUMBER(8)  not null,
	SOFT_VER VARCHAR2(20)  not null,
	ADAPT_TERM_TYPE NUMBER(4)  not null,
	constraint PK_UPG_PKG_CONTEXT primary Key (PKG_VER,SOFT_ID,SOFT_VER,ADAPT_TERM_TYPE)
);
comment on table UPG_PKG_CONTEXT is '软件包内容';
comment on column UPG_PKG_CONTEXT.PKG_VER is '软件包版本号';
comment on column UPG_PKG_CONTEXT.SOFT_ID is '软件ID';
comment on column UPG_PKG_CONTEXT.SOFT_VER is '软件版本号';
comment on column UPG_PKG_CONTEXT.ADAPT_TERM_TYPE is '适用终端机型';

create table UPG_PACKAGE(
	PKG_VER VARCHAR2(20)  not null,
	ADAPT_TERM_TYPE NUMBER(4)  not null,
	PKG_DESC VARCHAR2(1000)  ,
	RELEASE_DATE DATE  ,
	IS_VALID NUMBER(1) default 0 not null,
	constraint PK_UPG_PACKAGE primary Key (PKG_VER,ADAPT_TERM_TYPE)
);
comment on table UPG_PACKAGE is '软件包';
comment on column UPG_PACKAGE.PKG_VER is '软件包版本号';
comment on column UPG_PACKAGE.ADAPT_TERM_TYPE is '适用终端机型';
comment on column UPG_PACKAGE.PKG_DESC is '软件包描述';
comment on column UPG_PACKAGE.RELEASE_DATE is '发布日期';
comment on column UPG_PACKAGE.IS_VALID is '是否可用';

create table UPG_TERM_SOFTWARE(
	TERMINAL_CODE CHAR(10)  not null,
	TERM_TYPE NUMBER(4)  not null,
	RUNNING_PKG_VER VARCHAR2(20)  ,
	DOWNING_PKG_VER VARCHAR2(20)  ,
	LAST_UPGRADE_DATE DATE  ,
	LAST_REPORT_DATE DATE  ,
	constraint PK_UPG_TERM_SOFTWARE primary Key (TERMINAL_CODE,TERM_TYPE)
);
comment on table UPG_TERM_SOFTWARE is '终端软件信息';
comment on column UPG_TERM_SOFTWARE.TERMINAL_CODE is '终端编码';
comment on column UPG_TERM_SOFTWARE.TERM_TYPE is '终端机型';
comment on column UPG_TERM_SOFTWARE.RUNNING_PKG_VER is '运行软件包版本号';
comment on column UPG_TERM_SOFTWARE.DOWNING_PKG_VER is '正在下载的软件包版本号';
comment on column UPG_TERM_SOFTWARE.LAST_UPGRADE_DATE is '最近升级日期';
comment on column UPG_TERM_SOFTWARE.LAST_REPORT_DATE is '最近上报日期';

create table UPG_UPGRADEPLAN(
	SCHEDULE_ID NUMBER(8)  not null,
	SCHEDULE_NAME VARCHAR2(4000)  ,
	PKG_VER VARCHAR2(20)  not null,
	TERM_TYPE NUMBER(4)  not null,
	SCHEDULE_STATUS NUMBER(1)  not null,
	SCHEDULE_SW_DATE DATE  ,
	SCHEDULE_CR_DATE DATE  not null,
	SCHEDULE_EXEC_DATE DATE  ,
	SCHEDULE_CANCEL_DATE DATE  ,
	constraint PK_UPG_UPGRADEPLAN primary Key (SCHEDULE_ID)
);
comment on table UPG_UPGRADEPLAN is '升级计划';
comment on column UPG_UPGRADEPLAN.SCHEDULE_ID is '计划ID';
comment on column UPG_UPGRADEPLAN.SCHEDULE_NAME is '计划名称';
comment on column UPG_UPGRADEPLAN.PKG_VER is '软件包版本号';
comment on column UPG_UPGRADEPLAN.TERM_TYPE is '终端机型';
comment on column UPG_UPGRADEPLAN.SCHEDULE_STATUS is '计划状态（1=计划中、2=已执行、3=已取消）';
comment on column UPG_UPGRADEPLAN.SCHEDULE_SW_DATE is '计划更新时间';
comment on column UPG_UPGRADEPLAN.SCHEDULE_CR_DATE is '建立时间';
comment on column UPG_UPGRADEPLAN.SCHEDULE_EXEC_DATE is '执行时间';
comment on column UPG_UPGRADEPLAN.SCHEDULE_CANCEL_DATE is '取消时间';

create table UPG_UPGRADEPROC(
	TERMINAL_CODE CHAR(10)  not null,
	SCHEDULE_ID NUMBER(8)  not null,
	PKG_VER VARCHAR2(20)  not null,
	IS_COMP_DL NUMBER(1) default 0 not null,
	DL_START_DATE DATE  ,
	DL_END_DATE DATE  ,
	DL_PROC VARCHAR2(20)  ,
	DL_FILENAME VARCHAR2(30)  ,
	constraint PK_UPG_UPGRADEPROC primary Key (TERMINAL_CODE,SCHEDULE_ID)
);
comment on table UPG_UPGRADEPROC is '升级过程';
comment on column UPG_UPGRADEPROC.TERMINAL_CODE is '终端编码';
comment on column UPG_UPGRADEPROC.SCHEDULE_ID is '计划ID';
comment on column UPG_UPGRADEPROC.PKG_VER is '软件包版本号';
comment on column UPG_UPGRADEPROC.IS_COMP_DL is '是否已经完成下载';
comment on column UPG_UPGRADEPROC.DL_START_DATE is '开始下载时间';
comment on column UPG_UPGRADEPROC.DL_END_DATE is '完成下载时间';
comment on column UPG_UPGRADEPROC.DL_PROC is '当前文件下载进度';
comment on column UPG_UPGRADEPROC.DL_FILENAME is '当前下载文件名称';

create table SYS_HOST_COMM_LOG(
	LOG_ID NUMBER(18)  not null,
	LOG_TIME DATE default Sysdate not null,
	LOG_INFO VARCHAR2(4000)  not null,
	LOG_STATUS NUMBER(1) default 0 not null,
	constraint PK_SYS_HOST_COMM_LOG primary Key (LOG_ID)
);
comment on table SYS_HOST_COMM_LOG is '主机通讯日志';
comment on column SYS_HOST_COMM_LOG.LOG_ID is '日志id';
comment on column SYS_HOST_COMM_LOG.LOG_TIME is '时间戳';
comment on column SYS_HOST_COMM_LOG.LOG_INFO is '消息体';
comment on column SYS_HOST_COMM_LOG.LOG_STATUS is '主机通讯状态(0=新增、1=主机已经读取)';

create table SYS_CALENDAR(
	H_DAY_CODE NUMBER(8)  not null,
	H_DAY_START DATE  not null,
	H_DAY_END DATE  not null,
	H_DAY_DESC VARCHAR2(1000)  ,
	constraint PK_SYS_CALENDAR primary Key (H_DAY_CODE)
);
comment on table SYS_CALENDAR is '节假日日历';
comment on column SYS_CALENDAR.H_DAY_CODE is '假日序号';
comment on column SYS_CALENDAR.H_DAY_START is '假日开始时间（含）';
comment on column SYS_CALENDAR.H_DAY_END is '假日结束时间（含）';
comment on column SYS_CALENDAR.H_DAY_DESC is '假日描述';

create table SYS_INTERNAL_LOG(
	LOG_ID NUMBER(28)  not null,
	LOG_TYPE NUMBER(1)  not null,
	LOG_DATE TIMESTAMP  not null,
	LOG_DESC VARCHAR2(4000)  not null,
	constraint PK_SYS_INTERNAL_LOG primary Key (LOG_ID)
);
comment on table SYS_INTERNAL_LOG is '系统内部日志';
comment on column SYS_INTERNAL_LOG.LOG_ID is '日志编号';
comment on column SYS_INTERNAL_LOG.LOG_TYPE is '日志类型(1=日结、2=期结)';
comment on column SYS_INTERNAL_LOG.LOG_DATE is '生成时间';
comment on column SYS_INTERNAL_LOG.LOG_DESC is '描述';

create table SYS_CLOG_INFO(
	SYS_CLOG_SEQ NUMBER(16)  not null,
	TERMINAL_CODE CHAR(10)  not null,
	SYS_CLOG_APPLY_TIME DATE  not null,
	SYS_CLOG_APPLY_TYPE NUMBER(1)  not null,
	SYS_CLOG_APPLY_ARG1 VARCHAR2(500)  not null,
	SYS_CLOG_APPLY_STATUS NUMBER(1) default 1 not null,
	SYS_CLOG_SUCC_TIME DATE  ,
	SYS_CLOG_UPLOAD_FILE VARCHAR2(500)  ,
	constraint PK_SYS_CLOG_INFO primary Key (SYS_CLOG_SEQ)
);
comment on table SYS_CLOG_INFO is '终端日志采集系统';
comment on column SYS_CLOG_INFO.SYS_CLOG_SEQ is '编号';
comment on column SYS_CLOG_INFO.TERMINAL_CODE is '终端编号';
comment on column SYS_CLOG_INFO.SYS_CLOG_APPLY_TIME is '申请日期';
comment on column SYS_CLOG_INFO.SYS_CLOG_APPLY_TYPE is '申请类型（1-terminal-server日志、2-terminal-gui日志、3-指定目录文件、4-指定目录）';
comment on column SYS_CLOG_INFO.SYS_CLOG_APPLY_ARG1 is '申请扩展参数';
comment on column SYS_CLOG_INFO.SYS_CLOG_APPLY_STATUS is '申请状态(1-待处理、2-已完成)';
comment on column SYS_CLOG_INFO.SYS_CLOG_SUCC_TIME is '完成时间';
comment on column SYS_CLOG_INFO.SYS_CLOG_UPLOAD_FILE is '上传文件描述';

create table SYS_EVENTS(
	EVENT_ID NUMBER(16)  not null,
	SERVER_ADDR VARCHAR2(50)  not null,
	EVENT_TYPE NUMBER(1)  not null,
	EVENT_LEVEL NUMBER(1)  not null,
	EVENT_CONTENT VARCHAR2(4000)  not null,
	EVENT_TIME DATE default sysdate not null,
	constraint PK_SYS_EVENTS primary Key (EVENT_ID)
);
comment on table SYS_EVENTS is '系统事件';
comment on column SYS_EVENTS.EVENT_ID is '事件id';
comment on column SYS_EVENTS.SERVER_ADDR is '服务器ip';
comment on column SYS_EVENTS.EVENT_TYPE is '事件类型';
comment on column SYS_EVENTS.EVENT_LEVEL is '事件级别（1=信息；2=警告；3=错误；4=致命）';
comment on column SYS_EVENTS.EVENT_CONTENT is '事件内容';
comment on column SYS_EVENTS.EVENT_TIME is '事件发生时间';

create table MSG_INSTANT(
	NOTICE_ID NUMBER(8)  not null,
	CAST_STRING VARCHAR2(4000)  not null,
	SEND_ADMIN NUMBER(8)  not null,
	CONTENT VARCHAR2(4000)  not null,
	DISP_SECOND NUMBER(4)  not null,
	DISP_LOC NUMBER(1)  not null,
	CREATE_TIME DATE  not null,
	SEND_TIME DATE  ,
	constraint PK_MSG_INSTANT primary Key (NOTICE_ID)
);
comment on table MSG_INSTANT is '终端即时消息表';
comment on column MSG_INSTANT.NOTICE_ID is '消息ID';
comment on column MSG_INSTANT.CAST_STRING is '接收主体';
comment on column MSG_INSTANT.SEND_ADMIN is '发送人';
comment on column MSG_INSTANT.CONTENT is '消息内容';
comment on column MSG_INSTANT.DISP_SECOND is '显示时间（秒）';
comment on column MSG_INSTANT.DISP_LOC is '显示位置（1=主屏、2=TDS、3=打印机）';
comment on column MSG_INSTANT.CREATE_TIME is '创建时间';
comment on column MSG_INSTANT.SEND_TIME is '发送时间';

create table MSG_AGENCY_BROCAST(
	NOTICE_ID NUMBER(8)  not null,
	CAST_STRING VARCHAR2(4000)  not null,
	SEND_ADMIN NUMBER(8)  not null,
	TITLE VARCHAR2(400)  not null,
	CONTENT VARCHAR2(4000)  not null,
	CREATE_TIME DATE  not null,
	SEND_TIME DATE  ,
	constraint PK_MSG_AGENCY_BROCAST primary Key (NOTICE_ID)
);
comment on table MSG_AGENCY_BROCAST is '销售站公告';
comment on column MSG_AGENCY_BROCAST.NOTICE_ID is '消息ID';
comment on column MSG_AGENCY_BROCAST.CAST_STRING is '接收对象编码';
comment on column MSG_AGENCY_BROCAST.SEND_ADMIN is '发送人编号';
comment on column MSG_AGENCY_BROCAST.TITLE is '标题';
comment on column MSG_AGENCY_BROCAST.CONTENT is '消息内容';
comment on column MSG_AGENCY_BROCAST.CREATE_TIME is '创建时间';
comment on column MSG_AGENCY_BROCAST.SEND_TIME is '发送时间';

create table MSG_AGENCY_BROCAST_DETAIL(
	DETAIL_ID NUMBER(18)  not null,
	NOTICE_ID NUMBER(8)  not null,
	CAST_CODE NUMBER(12)  not null,
	constraint PK_MSG_AGENCY_BROCAST_DETAIL primary Key (DETAIL_ID)
);
comment on table MSG_AGENCY_BROCAST_DETAIL is '销售站公告子表';
comment on column MSG_AGENCY_BROCAST_DETAIL.DETAIL_ID is '细目ID';
comment on column MSG_AGENCY_BROCAST_DETAIL.NOTICE_ID is '消息ID';
comment on column MSG_AGENCY_BROCAST_DETAIL.CAST_CODE is '接收对象编码';

create table SYS_TICKET_MEMO(
	HIS_CODE NUMBER(8)  not null,
	GAME_CODE NUMBER(3)  not null,
	TICKET_MEMO VARCHAR2(1000)  not null,
	SET_ADMIN NUMBER(4)  not null,
	SET_TIME DATE default sysdate not null,
	constraint PK_SYS_TICKET_MEMO primary Key (HIS_CODE,GAME_CODE)
);
comment on table SYS_TICKET_MEMO is '彩票票面信息';
comment on column SYS_TICKET_MEMO.HIS_CODE is '历史编号';
comment on column SYS_TICKET_MEMO.GAME_CODE is '游戏编码';
comment on column SYS_TICKET_MEMO.TICKET_MEMO is '票面信息';
comment on column SYS_TICKET_MEMO.SET_ADMIN is '设置人';
comment on column SYS_TICKET_MEMO.SET_TIME is '设置日期';

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
