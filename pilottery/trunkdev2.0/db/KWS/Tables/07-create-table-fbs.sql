create table FBS_COUNTRY(
	COUNTRY_CODE NUMBER(10)  not null,
	COUNTRY_NAME VARCHAR2(4000)  not null,
	REMARK VARCHAR2(4000)  ,
	constraint PK_COUNTRY_CODE primary Key (COUNTRY_CODE)
);
comment on table FBS_COUNTRY is '国家信息表';
comment on column FBS_COUNTRY.COUNTRY_CODE is '国家编码';
comment on column FBS_COUNTRY.COUNTRY_NAME is '国家名称';
comment on column FBS_COUNTRY.REMARK is '备注';

create table FBS_COMPETITION(
	COMPETITION_CODE NUMBER(10)  not null,
	COMPETITION_ABBR VARCHAR2(4000)  not null,
	COMPETITION_NAME VARCHAR2(4000)  ,
	COMPETITION_DESC VARCHAR2(4000)  ,
	constraint PK_FBS_COMPETITION primary Key (COMPETITION_CODE)
);
comment on table FBS_COMPETITION is '足球联赛信息';
comment on column FBS_COMPETITION.COMPETITION_CODE is '联赛编码';
comment on column FBS_COMPETITION.COMPETITION_ABBR is '联赛简称';
comment on column FBS_COMPETITION.COMPETITION_NAME is '联赛名称';
comment on column FBS_COMPETITION.COMPETITION_DESC is '联赛描述';

create table FBS_COMPETITION_TEAM(
	TEAM_CODE NUMBER(10)  not null,
	COUNTRY_CODE NUMBER(10)  ,
	FULL_NAME VARCHAR2(4000)  not null,
	SHORT_NAME VARCHAR2(4000)  ,
	REMARK VARCHAR2(4000)  ,
	constraint PK_FBS_COMPETITION_TEAM primary Key (TEAM_CODE)
);
comment on table FBS_COMPETITION_TEAM is '足球球队信息';
comment on column FBS_COMPETITION_TEAM.TEAM_CODE is '球队编码';
comment on column FBS_COMPETITION_TEAM.COUNTRY_CODE is '国家编码';
comment on column FBS_COMPETITION_TEAM.FULL_NAME is '球队名称';
comment on column FBS_COMPETITION_TEAM.SHORT_NAME is '球队简称';
comment on column FBS_COMPETITION_TEAM.REMARK is '球队备注';

create table FBS_ISSUE(
	FBS_ISSUE_NUMBER NUMBER(10)  not null,
	GAME_CODE NUMBER(3)  not null,
	FBS_ISSUE_START DATE  ,
	FBS_ISSUE_END DATE  ,
	PUBLISH_TIME DATE  not null,
	PUBLISH_STATUS NUMBER(2)  not null,
	FBS_ISSUE_DATE NUMBER(8)  not null,
	constraint PK_FBS_ISSUE primary Key (FBS_ISSUE_NUMBER,GAME_CODE)
);
comment on table FBS_ISSUE is '足彩期次';
comment on column FBS_ISSUE.FBS_ISSUE_NUMBER is '期次编号';
comment on column FBS_ISSUE.GAME_CODE is '游戏编码';
comment on column FBS_ISSUE.FBS_ISSUE_START is '期次开始时间';
comment on column FBS_ISSUE.FBS_ISSUE_END is '期次结束时间';
comment on column FBS_ISSUE.PUBLISH_TIME is '发布时间';
comment on column FBS_ISSUE.PUBLISH_STATUS is '发布状态（0=未发布，1=已发布）';
comment on column FBS_ISSUE.FBS_ISSUE_DATE is '期次日期（YYYYMMDD）';

create table FBS_CURRENT_PARAM(
	GAME_CODE NUMBER(3)  not null,
	ISSUE_NUMBER NUMBER(12)  not null,
	HIS_HIS_CODE NUMBER(8)  not null,
	HIS_POLICY_CODE NUMBER(8)  not null,
	constraint PK_FBS_CURRENT_PARAM primary Key (GAME_CODE,ISSUE_NUMBER)
);
comment on table FBS_CURRENT_PARAM is '足彩期次参数';
comment on column FBS_CURRENT_PARAM.GAME_CODE is '游戏编码';
comment on column FBS_CURRENT_PARAM.ISSUE_NUMBER is '游戏期号';
comment on column FBS_CURRENT_PARAM.HIS_HIS_CODE is '动态参数当前历史编号';
comment on column FBS_CURRENT_PARAM.HIS_POLICY_CODE is '政策参数当前历史编号';

create table FBS_MATCH(
	MATCH_CODE NUMBER(9)  not null,
	GAME_CODE NUMBER(3)  not null,
	MATCH_SEQ NUMBER(4)  not null,
	MATCH_DESC VARCHAR2(1000)  ,
	IS_SALE NUMBER(1)  not null,
	FBS_ISSUE_NUMBER NUMBER(10)  not null,
	COMPETITION NUMBER(10)  not null,
	COMPETITION_ROUND NUMBER(10) default 0 not null,
	HOME_TEAM_CODE NUMBER(10)  not null,
	GUEST_TEAM_CODE NUMBER(10)  not null,
	MATCH_DATE DATE  ,
	LOCATION VARCHAR2(4000)  ,
	MATCH_START_DATE DATE  not null,
	MATCH_END_DATE DATE  not null,
	BEGIN_SALE_TIME DATE  not null,
	END_SALE_TIME DATE  not null,
	MATCH_RESULT_TIME DATE  ,
	REWARD_TIME DATE  ,
	STATUS NUMBER(2)  not null,
	DRAW_STATE NUMBER(2)  not null,
	WIN_LEVEL_LOS_SCORE NUMBER(2)  ,
	WIN_LOS_SCORE NUMBER(2,1)  ,
	constraint PK_FBS_MATCH primary Key (MATCH_CODE)
);
comment on table FBS_MATCH is '足球赛事表';
comment on column FBS_MATCH.MATCH_CODE is '比赛编码';
comment on column FBS_MATCH.GAME_CODE is '游戏编码';
comment on column FBS_MATCH.MATCH_SEQ is '期比赛序号';
comment on column FBS_MATCH.MATCH_DESC is '比赛内容描述';
comment on column FBS_MATCH.IS_SALE is '是否可销售';
comment on column FBS_MATCH.FBS_ISSUE_NUMBER is '所属期次';
comment on column FBS_MATCH.COMPETITION is '所属联赛';
comment on column FBS_MATCH.COMPETITION_ROUND is '联赛第几轮';
comment on column FBS_MATCH.HOME_TEAM_CODE is '主队编码';
comment on column FBS_MATCH.GUEST_TEAM_CODE is '客队编码';
comment on column FBS_MATCH.MATCH_DATE is '比赛日期';
comment on column FBS_MATCH.LOCATION is '比赛地点';
comment on column FBS_MATCH.MATCH_START_DATE is '比赛开始时间';
comment on column FBS_MATCH.MATCH_END_DATE is '比赛结束时间';
comment on column FBS_MATCH.BEGIN_SALE_TIME is '开始销售时间';
comment on column FBS_MATCH.END_SALE_TIME is '截止销售时间';
comment on column FBS_MATCH.MATCH_RESULT_TIME is '得到比赛结果时间';
comment on column FBS_MATCH.REWARD_TIME is '比赛开奖完成时间';
comment on column FBS_MATCH.STATUS is '比赛状态（1=比赛排期；2=销售开始；3=销售结束；4=输入开奖结果；5=算奖完成；6=开奖完成）';
comment on column FBS_MATCH.DRAW_STATE is '期次开奖状态（0=不能开奖状态；1=开奖准备状态；2=数据整理状态；3=备份状态；4=备份完成；5=第一次输入完成；6=第二次输入完成；7=开奖号码审批通过；8=开奖号码审批失败；9=开奖号码已发送；10=派奖检索完成；11=派奖输入已发送；12=中奖统计完成；13=数据稽核已发送 ；14=数据稽核完成；15=期结确认已发送；16=开奖完成）';
comment on column FBS_MATCH.WIN_LEVEL_LOS_SCORE is '胜平负让球数';
comment on column FBS_MATCH.WIN_LOS_SCORE is '胜负让球数';

create table FBS_MATCH_RESULT(
	MATCH_CODE NUMBER(9)  not null,
	GAME_CODE NUMBER(3)  not null,
	FBS_ISSUE_NUMBER NUMBER(10)  ,
	COMPETITION_CODE NUMBER(10)  not null,
	FIRST_DRAW_USER_ID NUMBER(10)  ,
	SECOND_DRAW_USER_ID NUMBER(10)  ,
	FIRST_FH_HOME_SCORE VARCHAR2(100)  ,
	FIRST_FH_GUEST_SCORE VARCHAR2(100)  ,
	SECOND_FH_HOME_SCORE VARCHAR2(100)  ,
	SECOND_FH_GUEST_SCORE VARCHAR2(100)  ,
	FIRST_SH_HOME_SCORE VARCHAR2(100)  ,
	FIRST_SH_GUEST_SCORE VARCHAR2(100)  ,
	SECOND_SH_HOME_SCORE VARCHAR2(100)  ,
	SECOND_SH_GUEST_SCORE VARCHAR2(100)  ,
	FULL_HOME_SCORE NUMBER(3)  ,
	FULL_GUEST_SCORE NUMBER(3)  ,
	FIRST_SCORE_TEAM NUMBER(10)  ,
	SECOND_SCORE_TEAM NUMBER(10)  ,
	FINAL_SCORE_TEAM NUMBER(10)  ,
	MATCH_REAL_TIME_INFO VARCHAR2(4000)  ,
	constraint PK_FBS_MATCH_RESULT primary Key (MATCH_CODE)
);
comment on table FBS_MATCH_RESULT is '足球赛事结果表';
comment on column FBS_MATCH_RESULT.MATCH_CODE is '比赛编码';
comment on column FBS_MATCH_RESULT.GAME_CODE is '游戏编码';
comment on column FBS_MATCH_RESULT.FBS_ISSUE_NUMBER is '所属期次';
comment on column FBS_MATCH_RESULT.COMPETITION_CODE is '联赛编码';
comment on column FBS_MATCH_RESULT.FIRST_DRAW_USER_ID is '第一次开奖用户';
comment on column FBS_MATCH_RESULT.SECOND_DRAW_USER_ID is '第二次开奖用户';
comment on column FBS_MATCH_RESULT.FIRST_FH_HOME_SCORE is '第一次上半场主队进球数';
comment on column FBS_MATCH_RESULT.FIRST_FH_GUEST_SCORE is '第一次上半场客队进球数';
comment on column FBS_MATCH_RESULT.SECOND_FH_HOME_SCORE is '第二次上半场主队进球数';
comment on column FBS_MATCH_RESULT.SECOND_FH_GUEST_SCORE is '第二次上半场客队进球数';
comment on column FBS_MATCH_RESULT.FIRST_SH_HOME_SCORE is '第一次下半场主队进球数';
comment on column FBS_MATCH_RESULT.FIRST_SH_GUEST_SCORE is '第一次下半场客队进球数';
comment on column FBS_MATCH_RESULT.SECOND_SH_HOME_SCORE is '第二次下半场主队进球数';
comment on column FBS_MATCH_RESULT.SECOND_SH_GUEST_SCORE is '第二次下半场客队进球数';
comment on column FBS_MATCH_RESULT.FULL_HOME_SCORE is '全场主队进球数';
comment on column FBS_MATCH_RESULT.FULL_GUEST_SCORE is '全场客队进球数';
comment on column FBS_MATCH_RESULT.FIRST_SCORE_TEAM is '第一次先进球队伍';
comment on column FBS_MATCH_RESULT.SECOND_SCORE_TEAM is '第二次先进球队伍';
comment on column FBS_MATCH_RESULT.FINAL_SCORE_TEAM is '最终先进球队伍';
comment on column FBS_MATCH_RESULT.MATCH_REAL_TIME_INFO is '比赛实时信息';

create table FBS_MATCH_WIN_RESULT(
	MATCH_CODE NUMBER(9)  not null,
	GAME_CODE NUMBER(3)  not null,
	MATCH_SUBTYPE_CODE NUMBER(9)  not null,
	MATCH_RESULT VARCHAR2(100)  ,
	MATCH_RESULT_ENUM NUMBER(2)  ,
	BET_AMOUNT NUMBER(28) default 0 not null,
	SINGLE_BET_AMOUNT NUMBER(28) default 0 not null,
	MULTIPLE_BET_AMOUNT NUMBER(28) default 0 not null,
	RESULT_AMOUNT NUMBER(28) default 0 not null,
	SINGLE_RESULT_AMOUNT NUMBER(28) default 0 not null,
	MULTIPLE_RESULT_AMOUNT NUMBER(28) default 0 not null,
	REF_SP_VALUE NUMBER(8,3) default 0 not null,
	WIN_AMOUNT NUMBER(28) default 0 not null,
	SINGLE_WIN_AMOUNT NUMBER(28) default 0 not null,
	MULTIPLE_WIN_AMOUNT NUMBER(28) default 0 not null,
	constraint PK_FBS_MATCH_WIN_RESULT primary Key (MATCH_CODE,GAME_CODE,MATCH_SUBTYPE_CODE)
);
comment on table FBS_MATCH_WIN_RESULT is '足球赛事开奖结果表';
comment on column FBS_MATCH_WIN_RESULT.MATCH_CODE is '比赛编码';
comment on column FBS_MATCH_WIN_RESULT.GAME_CODE is '游戏编码';
comment on column FBS_MATCH_WIN_RESULT.MATCH_SUBTYPE_CODE is '比赛玩法';
comment on column FBS_MATCH_WIN_RESULT.MATCH_RESULT is '比赛结果';
comment on column FBS_MATCH_WIN_RESULT.MATCH_RESULT_ENUM is '比赛结果（枚举）';
comment on column FBS_MATCH_WIN_RESULT.BET_AMOUNT is '玩法投注金额';
comment on column FBS_MATCH_WIN_RESULT.SINGLE_BET_AMOUNT is '投注金额（单关）';
comment on column FBS_MATCH_WIN_RESULT.MULTIPLE_BET_AMOUNT is '投注金额（过关）';
comment on column FBS_MATCH_WIN_RESULT.RESULT_AMOUNT is '赛果投注金额';
comment on column FBS_MATCH_WIN_RESULT.SINGLE_RESULT_AMOUNT is '赛果投注金额（单关玩法）';
comment on column FBS_MATCH_WIN_RESULT.MULTIPLE_RESULT_AMOUNT is '赛果投注金额（过关玩法）';
comment on column FBS_MATCH_WIN_RESULT.REF_SP_VALUE is '终场SP值';
comment on column FBS_MATCH_WIN_RESULT.WIN_AMOUNT is '中奖金额';
comment on column FBS_MATCH_WIN_RESULT.SINGLE_WIN_AMOUNT is '中奖金额（单关玩法）';
comment on column FBS_MATCH_WIN_RESULT.MULTIPLE_WIN_AMOUNT is '中奖金额（过关玩法）';