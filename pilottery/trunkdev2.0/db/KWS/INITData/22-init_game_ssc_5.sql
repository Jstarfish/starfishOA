insert into INF_GAMES (GAME_CODE,GAME_MARK,BASIC_TYPE,FULL_NAME,SHORT_NAME,ISSUING_ORGANIZATION) values (5,5,1,'HourLucks','SSC','CLS');

insert into GP_STATIC (GAME_CODE,DRAW_MODE,SINGLEBET_AMOUNT,SINGLETICKET_MAX_ISSUES,LIMIT_BIG_PRIZE,LIMIT_PAYMENT,LIMIT_PAYMENT2,LIMIT_CANCEL2,ABANDON_REWARD_COLLECT) values (5,1,1000,1,2000000,200000000000,40000000,40000000,2);

insert into GP_DYNAMIC (GAME_CODE,SINGLELINE_MAX_AMOUNT,SINGLETICKET_MAX_LINE,SINGLETICKET_MAX_AMOUNT,CANCEL_SEC,
                        SALER_PAY_LIMIT,SALER_CANCEL_LIMIT,ISSUE_CLOSE_ALERT_TIME,IS_PAY,IS_SALE,IS_CANCEL,IS_AUTO_DRAW,
                        SERVICE_TIME_1,SERVICE_TIME_2,AUDIT_SINGLE_TICKET_SALE,AUDIT_SINGLE_TICKET_PAY,
                        AUDIT_SINGLE_TICKET_CANCEL,CALC_WINNING_CODE)
               values  (5,100,5,2000000,0,2000000,0,300,1,1,1,0,'6:00-22:00','-',200000,400000,0,'');

insert into GP_HISTORY (HIS_HIS_CODE,HIS_MODIFY_DATE,GAME_CODE,IS_OPEN_RISK,RISK_PARAM) values (0,sysdate,5,0,'0.5;1:50000,2:5000,4:5000,5:500,8:781,9:1562,10:50,12:50,13:100000');

insert into GP_POLICY (HIS_POLICY_CODE,HIS_MODIFY_DATE,GAME_CODE,THEORY_RATE,FUND_RATE,ADJ_RATE,TAX_THRESHOLD,TAX_RATE,DRAW_LIMIT_DAY) values (0,sysdate,5,720,0,30,0,0,30);

insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,5, 1,'Straight 1','Lucky Hour Straight 1' ,0);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,5, 2,'Straight 2','Lucky Hour Straight 2' ,0);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,5, 3,'Combo 2','Lucky Hour Combo 2' ,0);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,5, 4,'Sum 2','Lucky Hour Sum 2' ,0);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,5, 5,'Straight 3','Lucky Hour Straight 3' ,0);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,5, 6,'Combo 3','Lucky Hour Combo 3' ,0);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,5, 7,'Sum 3','Lucky Hour Sum 3' ,0);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,5, 8,'Box 3','Lucky Hour Box 3' ,0);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,5, 9,'Box 6','Lucky Hour Box 6' ,0);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,5,10,'Straight 5','Lucky Hour Straight 5' ,0);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,5,11,'Combo 5','Lucky Hour Combo 5' ,0);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,5,12,'Two-way Combo 5','Lucky Hour Two-way Combo 5' ,0);
insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,5,13,'Big Small Odd Even','Lucky Hour Big Small Odd Even' ,0);

insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,5, 1,'Straight 1','Lucky Hour Straight 1');
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,5, 2,'Straight 2','Lucky Hour Straight 2');
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,5, 3,'Combo 2','Lucky Hour Combo 2');
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,5, 4,'Sum 2','Lucky Hour Sum 2');
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,5, 5,'Straight 3','Lucky Hour Straight 3');
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,5, 6,'Combo 3','Lucky Hour Combo 3');
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,5, 7,'Sum 3','Lucky Hour Sum 3');
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,5, 8,'Box 3','Lucky Hour Box 3');
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,5, 9,'Box 6','Lucky Hour Box 6');
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,5,10,'Straight 5','Lucky Hour Straight 5');
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,5,11,'Combo 5','Lucky Hour Combo 5');
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,5,12,'Two-way Combo 5','Lucky Hour Two-way Combo 5');
insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,5,13,'Big Small Odd Even','Lucky Hour Big Small Odd Even');

insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,5, 1,'Straight 1','Lucky Hour Straight 1',1000          , 1);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,5, 2,'Straight 2','Lucky Hour Straight 2',10000         , 2);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,5, 3,'Straight 3','Lucky Hour Straight 3',100000        , 3);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,5, 4,'Straight 5','Lucky Hour Straight 5',10000000      , 4);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,5, 5,'Big Small Odd Even','Lucky Hour Big Small Odd Even',400           , 5);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,5, 6,'Sum 2-Pair','Lucky Hour Sum 2-Pair',10000   ,6);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,5, 7,'Sum 2-AB','Lucky Hour Sum 2-AB',5000    ,7);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,5, 8,'Sum 3-Triple','Lucky Hour Sum 3-Triple',100000, 8);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,5, 9,'Sum 3-Double','Lucky Hour Sum 3-Double',32000 , 9);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,5,10,'Sum 3-ABC','Lucky Hour Sum 3-ABC',16000         ,10);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,5,11,'Box 3','Lucky Hour Box 3',32000                 ,11);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,5,12,'Box 6','Lucky Hour Box 6',16000                 ,12);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,5,13,'Two-way Combo 5-1st Prize','Lucky Hour Two-way Combo 5-1st Prize',2000000 ,13);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,5,14,'Two-way Combo 5-2nd Prize','Lucky Hour Two-way Combo 5-2nd Prize',20000   ,14);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,5,15,'Two-way Combo 5-3rd Prize','Lucky Hour Two-way Combo 5-3rd Prize',2000    ,15);

insert into iss_game_pool (game_code, pool_code, pool_amount_after, adj_time, pool_desc, pool_name) values (5, 0, 0, sysdate, 'HourLucks', 'HourLucks');
insert into iss_game_pool_his (his_code, game_code, issue_number, pool_code, change_amount, pool_amount_before, pool_amount_after, adj_time, pool_adj_type, adj_reason, pool_flow) values (F_GET_GAME_HIS_CODE_SEQ, 5, 0, 0, 0, 0, 0, sysdate, 7, 'Initialization', null);

insert into adj_game_current (game_code, pool_amount_before, pool_amount_after) values (5, 0, 0);
insert into adj_game_his (his_code, game_code, issue_number, adj_change_type, adj_amount, adj_amount_before, adj_amount_after, adj_time) values (F_GET_GAME_HIS_CODE_SEQ, 5, 0, 8, 0, 0, 0, sysdate);

commit;
