SET DEFINE OFF;

insert into INF_GAMES (GAME_CODE,GAME_MARK,BASIC_TYPE,FULL_NAME,SHORT_NAME,ISSUING_ORGANIZATION) values (14,14,4,'FBS','FBS','CLS');


insert into GP_STATIC (GAME_CODE,DRAW_MODE,SINGLEBET_AMOUNT,SINGLETICKET_MAX_ISSUES,LIMIT_BIG_PRIZE,LIMIT_PAYMENT,LIMIT_PAYMENT2,LIMIT_CANCEL2,ABANDON_REWARD_COLLECT)
               values (14,2,1000,20,40000000,4000000000,4000000,1,2);

insert into GP_DYNAMIC (GAME_CODE,SINGLELINE_MAX_AMOUNT,SINGLETICKET_MAX_LINE,SINGLETICKET_MAX_AMOUNT,CANCEL_SEC,
                        SALER_PAY_LIMIT,SALER_CANCEL_LIMIT,ISSUE_CLOSE_ALERT_TIME,IS_PAY,IS_SALE,IS_CANCEL,IS_AUTO_DRAW,
                        SERVICE_TIME_1,SERVICE_TIME_2,AUDIT_SINGLE_TICKET_SALE,AUDIT_SINGLE_TICKET_PAY,
                        AUDIT_SINGLE_TICKET_CANCEL,CALC_WINNING_CODE)
               values  (14,100,20,800000,360,400000,1,0,1,1,0,1,'00:00-23:59','00:00-23:59',400000,400000,400000,'');


--游戏政策参数
insert into GP_POLICY (HIS_POLICY_CODE,HIS_MODIFY_DATE,GAME_CODE,THEORY_RATE,FUND_RATE,ADJ_RATE,TAX_THRESHOLD,TAX_RATE,DRAW_LIMIT_DAY) values (0,sysdate,14,750,0,30,100,200,30);

--游戏玩法规则
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,14,1, 'Result','FBS Result',1);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,14,2, 'ConcedeResult','FBS ConcedeResult',1);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,14,3, 'Fullscore','FBS Fullscore',1);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,14,4, 'Singlescore','FBS Singlescore',1);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,14,5, 'Half/Full310','FBS Half/Full310',1);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,14,6, 'Big/SmallS/D','FBS Big/SmallS/D',1);

--游戏中奖规则
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,14, 1,'FBS','The result of guessing is greater than or equal to the number of strings');

--BUG92
--游戏奖级规则
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0, sysdate, 14, 1,'FBS','FBS', 0, 1);

insert into GP_HISTORY (HIS_HIS_CODE,HIS_MODIFY_DATE,GAME_CODE,IS_OPEN_RISK,RISK_PARAM) values (0,sysdate,14,1,'0:800000000');

commit;

-- 奖池初始化
insert into iss_game_pool (game_code, pool_code, pool_amount_after, adj_time, pool_desc, pool_name) values (14, 0, 0, sysdate, 'FBS', 'FBS');
insert into iss_game_pool_his (his_code, game_code, issue_number, pool_code, change_amount, pool_amount_before, pool_amount_after, adj_time, pool_adj_type, adj_reason, pool_flow) values (F_GET_GAME_HIS_CODE_SEQ, 14, 0, 0, 0, 0, 0, sysdate, 7, 'Initialization', null);

-- 调节基金初始化
insert into adj_game_current (game_code, pool_amount_before, pool_amount_after) values (14, 0, 0);
insert into adj_game_his (his_code, game_code, issue_number, adj_change_type, adj_amount, adj_amount_before, adj_amount_after, adj_time) values (F_GET_GAME_HIS_CODE_SEQ, 14, 0, 8, 0, 0, 0, sysdate);

commit;

insert into AUTH_ORG (ORG_CODE, GAME_CODE, PAY_COMMISSION_RATE, SALE_COMMISSION_RATE, AUTH_TIME, ALLOW_PAY, ALLOW_SALE, ALLOW_CANCEL) select ORG_CODE, 14, 0, 0, sysdate, 0, 0, 0 from inf_orgs;
commit;

insert into AUTH_AGENCY (AGENCY_CODE, GAME_CODE, PAY_COMMISSION_RATE, SALE_COMMISSION_RATE, ALLOW_PAY, ALLOW_SALE, ALLOW_CANCEL, CLAIMING_SCOPE, AUTH_TIME) select AGENCY_CODE, 13, 0, 0, 0, 0, 0, 0, sysdate from inf_agencys;
commit;

--BUG 161
insert into FBS_COUNTRY (COUNTRY_CODE, COUNTRY_NAME, REMARK) values (1, 'China', null);
insert into FBS_COUNTRY (COUNTRY_CODE, COUNTRY_NAME, REMARK) values (2, 'England', null);
insert into FBS_COUNTRY (COUNTRY_CODE, COUNTRY_NAME, REMARK) values (3, 'Spain', null);
insert into FBS_COUNTRY (COUNTRY_CODE, COUNTRY_NAME, REMARK) values (4, 'Italy', null);
insert into FBS_COUNTRY (COUNTRY_CODE, COUNTRY_NAME, REMARK) values (5, 'Brazil', null);
insert into FBS_COUNTRY (COUNTRY_CODE, COUNTRY_NAME, REMARK) values (6, 'Germany', null);

commit;
