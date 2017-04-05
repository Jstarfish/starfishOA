insert into INF_GAMES (GAME_CODE,GAME_MARK,BASIC_TYPE,FULL_NAME,SHORT_NAME,ISSUING_ORGANIZATION) values (11,11,1,'Quick3','K3','CLS');

insert into GP_STATIC (GAME_CODE,DRAW_MODE,SINGLEBET_AMOUNT,SINGLETICKET_MAX_ISSUES,LIMIT_BIG_PRIZE,LIMIT_PAYMENT,LIMIT_PAYMENT2,LIMIT_CANCEL2,ABANDON_REWARD_COLLECT) values (11,1,1000,1,2000000,200000000000,40000000,40000000,2);

insert into GP_DYNAMIC (GAME_CODE,SINGLELINE_MAX_AMOUNT,SINGLETICKET_MAX_LINE,SINGLETICKET_MAX_AMOUNT,CANCEL_SEC,SALER_PAY_LIMIT,SALER_CANCEL_LIMIT,ISSUE_CLOSE_ALERT_TIME,IS_PAY,IS_SALE,IS_CANCEL,IS_AUTO_DRAW,SERVICE_TIME_1,SERVICE_TIME_2,AUDIT_SINGLE_TICKET_SALE,AUDIT_SINGLE_TICKET_PAY,AUDIT_SINGLE_TICKET_CANCEL,CALC_WINNING_CODE) values (7,100,5,2000000,0,2000000,0,300,1,1,1,0,'6:00-22:00','-',200000,400000,0,'FDBD:48000000#FDFD:0#FDMIN:100');
insert into GP_DYNAMIC (GAME_CODE,SINGLELINE_MAX_AMOUNT,SINGLETICKET_MAX_LINE,SINGLETICKET_MAX_AMOUNT,CANCEL_SEC,
                        SALER_PAY_LIMIT,SALER_CANCEL_LIMIT,ISSUE_CLOSE_ALERT_TIME,IS_PAY,IS_SALE,IS_CANCEL,IS_AUTO_DRAW,
                        SERVICE_TIME_1,SERVICE_TIME_2,AUDIT_SINGLE_TICKET_SALE,AUDIT_SINGLE_TICKET_PAY,
                        AUDIT_SINGLE_TICKET_CANCEL,CALC_WINNING_CODE)
               values  (11,100,5,2000000,0,2000000,0,300,1,1,1,0,'6:00-22:00','-',200000,400000,0,'');

insert into GP_HISTORY (HIS_HIS_CODE,HIS_MODIFY_DATE,GAME_CODE,IS_OPEN_RISK,RISK_PARAM) values (0,sysdate,11,0,'-');

insert into GP_POLICY (HIS_POLICY_CODE,HIS_MODIFY_DATE,GAME_CODE,THEORY_RATE,FUND_RATE,ADJ_RATE,TAX_THRESHOLD,TAX_RATE,DRAW_LIMIT_DAY) values (0,sysdate,11,720,0,30,0,0,30);



insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,11,1,'Sum','Quick3 Sum',0);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,11,2,'Triple All','Quick3 Triple All',0);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,11,3,'Triple','Quick3 Triple',0);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,11,4,'Chain','Quick3 Chain',0);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,11,5,'ABC','Quick3 ABC',0);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,11,6,'Pair Combo','Quick3 Pair Combo',0);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,11,7,'Pair','Quick3 Pair',0);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,11,8,'AB','Quick3 AB',0);



insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,11,1,'Sum','Quick3 Sum');
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,11,2,'Triple All','Quick3 Triple All');
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,11,3,'Triple','Quick3 Triple');
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,11,4,'Chain','Quick3 Chain');
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,11,5,'ABC','Quick3 ABC');
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,11,6,'Pair Combo','Quick3 Pair Combo');
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,11,7,'Pair','Quick3 Pair');
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,11,8,'AB','Quick3 AB');




insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,11, 1,'Triple','Quick3 Triple',240 , 1);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,11, 2,'Sum 3 and 18','Quick3 Sum 3 and 18',240 , 2);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,11, 3,'Pair','Quick3 Pair',80  , 3);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,11, 4,'Sum 4 and 17','Quick3 Sum 4 and 17',80  , 4);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,11, 5,'Triple All','Quick3 Triple All',40  , 5);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,11, 6,'Sum 5 and 16','Quick3 Sum 5 and 16',40  , 6);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,11, 7,'ABC','Quick3 ABC',40  , 7);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,11, 8,'Sum 6 and 15','Quick3 Sum 6 and 15',25  , 8);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,11, 9,'Sum 7 and 14','Quick3 Sum 7 and 14',16  , 9);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,11,10,'Pair Combo','Quick3 Pair Combo',15  ,10);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,11,11,'Sum 8 and 13','Quick3 Sum 8 and 13',12  ,11);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,11,12,'Chain','Quick3 Chain',10  ,12);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,11,13,'Sum 9 and 12','Quick3 Sum 9 and 12',10  ,13);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,11,14,'Sum 10 and 11','Quick3 Sum 10 and 11',9   ,14);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,11,15,'AB','Quick3 AB',8   ,15);


insert into iss_game_pool (game_code, pool_code, pool_amount_after, adj_time, pool_desc, pool_name) values (11, 0, 0, sysdate, 'Quick3', 'Quick3');
insert into iss_game_pool_his (his_code, game_code, issue_number, pool_code, change_amount, pool_amount_before, pool_amount_after, adj_time, pool_adj_type, adj_reason, pool_flow) values (F_GET_GAME_HIS_CODE_SEQ, 11, 0, 0, 0, 0, 0, sysdate, 7, 'Initialization', null);

insert into adj_game_current (game_code, pool_amount_before, pool_amount_after) values (11, 0, 0);
insert into adj_game_his (his_code, game_code, issue_number, adj_change_type, adj_amount, adj_amount_before, adj_amount_after, adj_time) values (F_GET_GAME_HIS_CODE_SEQ, 11, 0, 8, 0, 0, 0, sysdate);

commit;
