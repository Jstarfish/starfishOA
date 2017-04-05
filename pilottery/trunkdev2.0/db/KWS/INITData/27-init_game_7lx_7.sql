insert into INF_GAMES (GAME_CODE,GAME_MARK,BASIC_TYPE,FULL_NAME,SHORT_NAME,ISSUING_ORGANIZATION) values (7,7,2,'Win 6+','Win 6+','Cambodia National Sports Lottery Center');

insert into GP_STATIC (GAME_CODE,DRAW_MODE,SINGLEBET_AMOUNT,SINGLETICKET_MAX_ISSUES,LIMIT_BIG_PRIZE,LIMIT_PAYMENT,LIMIT_PAYMENT2,LIMIT_CANCEL2,ABANDON_REWARD_COLLECT) values (7,2,1000,1,2000000,200000000000,40000000,40000000,2);
insert into gp_dynamic (GAME_CODE, SINGLELINE_MAX_AMOUNT, SINGLETICKET_MAX_LINE, SINGLETICKET_MAX_AMOUNT, CANCEL_SEC, SALER_PAY_LIMIT, SALER_CANCEL_LIMIT, ISSUE_CLOSE_ALERT_TIME, IS_PAY, IS_SALE, IS_CANCEL, IS_AUTO_DRAW, SERVICE_TIME_1, SERVICE_TIME_2, AUDIT_SINGLE_TICKET_SALE, AUDIT_SINGLE_TICKET_PAY, AUDIT_SINGLE_TICKET_CANCEL, CALC_WINNING_CODE)
values (7, 100, 5, 2000000, 0, 2000000, 0, 300, 1, 1, 1, 0, '00:00-00:00', '00:00-00:00', 200000, 400000, 0, 'FDBD:40000000#FDFD:0#FDMIN:100');
insert into GP_HISTORY (HIS_HIS_CODE,HIS_MODIFY_DATE,GAME_CODE,IS_OPEN_RISK,RISK_PARAM) values (0,sysdate,7,0,'-');

insert into GP_POLICY (HIS_POLICY_CODE,HIS_MODIFY_DATE,GAME_CODE,THEORY_RATE,FUND_RATE,ADJ_RATE,TAX_THRESHOLD,TAX_RATE,DRAW_LIMIT_DAY) values (0,sysdate,7,640,0,10,0,0,30);

insert into GP_RULE (HIS_RULE_CODE,HIS_MODIFY_DATE,GAME_CODE,RULE_CODE,RULE_NAME,RULE_DESC,RULE_ENABLE) values (0,sysdate,7,1,'Straight','Straight: Subtype code-ZX; Cost per bet 1000 riels (0.25 us dollar), Support single, compound, banker betting and betting with a multiplier;',0);

insert into GP_WIN_RULE (HIS_WIN_CODE,HIS_MODIFY_DATE,GAME_CODE,WRULE_CODE,WRULE_NAME,WRULE_DESC) values (0,sysdate,7,1,'Straight','The prize levels of Dragon Stars 7 are as follows: First prize: six of the basic numbers of the draw result are inside the bet (regardless of orders, the same below); Second prize: five of the basic numbers of the draw result and the special number of the draw result are inside the bet; Third prize: five of the basic numbers of the draw result are inside the bet; Fourth prize: four of the basic numbers of the draw result and the special number of the draw result are inside the bet; Fifth prize: four of the basic numbers of the draw result are inside a bet; Sixth prize: three of the basic numbers of the draw result and the special number of the draw result are inside the bet; Seventh prize: three of the basic numbers of the draw result are inside the bet.');

insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,7,1,'1st Prize','First Prize',0,1);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,7,2,'2nd Prize','Second Prize',20000000,2);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,7,3,'3rd Prize','Third Prize',2000000,3);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,7,4,'4th Prize','Fourth Prize',400000,4);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,7,5,'5th Prize','Fifth Prize',40000,5);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,7,6,'6th Prize','Sixth Prize',20000,6);
insert into GP_PRIZE_RULE (HIS_PRIZE_CODE,HIS_MODIFY_DATE,GAME_CODE,PRULE_LEVEL,PRULE_NAME,PRULE_DESC,LEVEL_PRIZE,DISP_ORDER) values (0,sysdate,7,7,'7th Prize','Seventh Prize',4000,7);

insert into iss_game_pool (game_code, pool_code, pool_amount_after, adj_time, pool_desc, pool_name) values (7, 0, 0, sysdate, 'Pool for Win 6+', 'Pool for Win 6+');
insert into iss_game_pool_his (his_code, game_code, issue_number, pool_code, change_amount, pool_amount_before, pool_amount_after, adj_time, pool_adj_type, adj_reason, pool_flow) values (F_GET_GAME_HIS_CODE_SEQ, 7, 0, 0, 0, 0, 0, sysdate, 7, 'Initialization', null);

insert into adj_game_current (game_code, pool_amount_before, pool_amount_after) values (7, 0, 0);
insert into adj_game_his (his_code, game_code, issue_number, adj_change_type, adj_amount, adj_amount_before, adj_amount_after, adj_time) values (F_GET_GAME_HIS_CODE_SEQ, 7, 0, 8, 0, 0, 0, sysdate);

commit;