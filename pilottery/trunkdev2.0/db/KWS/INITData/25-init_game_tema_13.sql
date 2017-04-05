SET DEFINE OFF;

insert into INF_GAMES (GAME_CODE,GAME_MARK,BASIC_TYPE,FULL_NAME,SHORT_NAME,ISSUING_ORGANIZATION) values (13,13,2,'Extra Win','Extra Win','CLS');


insert into GP_STATIC (GAME_CODE,DRAW_MODE,SINGLEBET_AMOUNT,SINGLETICKET_MAX_ISSUES,LIMIT_BIG_PRIZE,LIMIT_PAYMENT,LIMIT_PAYMENT2,LIMIT_CANCEL2,ABANDON_REWARD_COLLECT)
               values (13,2,1000,1,2000000,200000000000,400000000000,400000000000,2);

insert into GP_DYNAMIC (GAME_CODE,SINGLELINE_MAX_AMOUNT,SINGLETICKET_MAX_LINE,SINGLETICKET_MAX_AMOUNT,CANCEL_SEC,
                        SALER_PAY_LIMIT,SALER_CANCEL_LIMIT,ISSUE_CLOSE_ALERT_TIME,IS_PAY,IS_SALE,IS_CANCEL,IS_AUTO_DRAW,
                        SERVICE_TIME_1,SERVICE_TIME_2,AUDIT_SINGLE_TICKET_SALE,AUDIT_SINGLE_TICKET_PAY,
                        AUDIT_SINGLE_TICKET_CANCEL,CALC_WINNING_CODE)
               values  (13,100,5,200000,0,400000,0,300,1,0,0,0,'00:00-00:00','00:00-00:00',200000,400000,0,'FDBD:48000000#FDFD:0#FDMIN:100');

insert into GP_HISTORY (HIS_HIS_CODE,HIS_MODIFY_DATE,GAME_CODE,IS_OPEN_RISK,RISK_PARAM) values (0,sysdate,13,0,'0:800000000');

insert into GP_POLICY (HIS_POLICY_CODE,HIS_MODIFY_DATE,GAME_CODE,THEORY_RATE,FUND_RATE,ADJ_RATE,TAX_THRESHOLD,TAX_RATE,DRAW_LIMIT_DAY) values (0,sysdate,13,800,0,20,0,0,30);

insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,13,1, 'DG','Extra Win DG',1);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,13,2, 'WH','Extra Win WH',1);


insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,13, 1,'DG','TEMA DG');
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,13, 2,'WH','TEMA WH');

insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,13, 1,'DG','Extra Win DG',32000  , 1);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,13, 2,'WH','Extra Win WH',3000 , 2);

commit;

-- 奖池初始化
insert into iss_game_pool (game_code, pool_code, pool_amount_after, adj_time, pool_desc, pool_name) values (13, 0, 0, sysdate, 'Pool for Extra Win', 'Pool for Extra Win');
insert into iss_game_pool_his (his_code, game_code, issue_number, pool_code, change_amount, pool_amount_before, pool_amount_after, adj_time, pool_adj_type, adj_reason, pool_flow) values (F_GET_GAME_HIS_CODE_SEQ, 13, 0, 0, 0, 0, 0, sysdate, 7, 'Initialization', null);

-- 调节基金初始化
insert into adj_game_current (game_code, pool_amount_before, pool_amount_after) values (13, 0, 0);
insert into adj_game_his (his_code, game_code, issue_number, adj_change_type, adj_amount, adj_amount_before, adj_amount_after, adj_time) values (F_GET_GAME_HIS_CODE_SEQ, 13, 0, 8, 0, 0, 0, sysdate);

commit;