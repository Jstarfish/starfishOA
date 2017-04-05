update SYS_PARAMETER set SYS_DEFAULT_DESC = '即开票终端兑奖限额' where SYS_DEFAULT_SEQ = 5;
update SYS_PARAMETER set SYS_DEFAULT_DESC = '即开票分公司兑奖限额' where SYS_DEFAULT_SEQ = 6;
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (1017, '电脑票终端兑奖限额', '2000000');
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (1018, '电脑票分公司兑奖限额', '8000000');

Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_IS_CENTER, 
    PRIVILEGE_AGREEDAY, PRIVILEGE_LOGINBEGIN, PRIVILEGE_LOGINEND, PRIVILEGE_REMARK, PRIVILEGE_URL, 
    PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (3704, 'Online Time Statistics', '00370400', 1, 1, 
    '1111111', '00:00:00', '23:59:00', '在线时长统计', '/onlineStatistics.do?method=listOnlineRecords', 
    37, 2, 12);    
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_IS_CENTER, 
    PRIVILEGE_AGREEDAY, PRIVILEGE_LOGINBEGIN, PRIVILEGE_LOGINEND, PRIVILEGE_REMARK, PRIVILEGE_URL, 
    PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (3705, 'Terminal Check Record', '00370500', 1, 1, 
    '1111111', '00:00:00', '23:59:00', '终端机巡检记录', '/terminalCheck.do?method=listCheckRecords', 
    37, 2, 15);	
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK, 
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1606, 'Monthly Report', '16060000', 0, '月报', 
    '#', 16, 2, 18);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK, 
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (160601, 'Inst Monthly Report ', '16060100', 0, '机构月度报表', 
    '/monthlyReport.do?method=listInstMonthlyReport', 1606, 3, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK, 
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (160602, 'MM Monthly Report ', '16060200', 0, '市场管理员月报', 
    '/monthlyReport.do?method=listMktManagerMonthlyReport', 1606, 3, 6);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK, 
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (160603, 'Outlet Monthly Report ', '16060300', 0, '站点月度报表', 
    '/monthlyReport.do?method=listOutletMonthlyReport', 1606, 3, 9);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK, 
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (160110, 'Outlet Integrated Query', '16011000', 0, '站点综合查询', 
    '/saleReport.do?method=listOutletIntegrated', 1601, 3, 30);
update ADM_PRIVILEGE set PRIVILEGE_URL = '#' where PRIVILEGE_ID = 1406;
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK, 
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (140601, 'Adjustment', '14060100', 0, '调账', 
    '/account.do?method=getOutletInfo', 1406, 3, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK, 
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (140602, 'Adjustment Records', '14060200', 0, '调账记录', 
    '/account.do?method=listAdjustmentRecords', 1406, 3, 6);
	Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK, 
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1906, 'History Rankings', '19060000', 0, '站点历史销售排行', 
    '/monitor.do?method=historyRankings', 19, 2, 18);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK, 
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (160205, 'Net Sales Statistics', '16020500', 0, '净销售统计报表', 
    '/analysis.do?method=netSalesStatistcs', 1602, 3, 15);


commit;


declare
  p_curr_date date;
  cnt number(10);
begin
  -- 从一个肯定没有数据的时候，开始刷数据
  p_curr_date := to_date('2016-05-01','yyyy-mm-dd');
  
  while 1=1 loop
    p_curr_date := p_curr_date + 1;
    
    insert into his_sale_pay_cancel
      (sale_date, sale_month, area_code, org_code, plan_code, sale_amount, sale_comm, cancel_amount, cancel_comm, pay_amount, pay_comm, incoming)
    with
    -- 电脑票
    lot_sale as
     (select to_char(SALETIME, 'yyyy-mm-dd') sale_day,
             to_char(SALETIME, 'yyyy-mm') sale_month,
             area_code,
             org_code,
             f_get_game_name(game_code) plan_code,
             sum(TICKET_AMOUNT) lot_sale_amount,
             sum(COMMISSIONAMOUNT) as lot_sale_comm
        from his_sellticket join inf_agencys
          on his_sellticket.agency_code=inf_agencys.agency_code
          and SALETIME >= trunc(p_curr_date) - 1
          and SALETIME <  trunc(p_curr_date) 
          group by area_code,
                org_code,
                f_get_game_name(game_code),
                to_char(SALETIME, 'yyyy-mm-dd'),
                to_char(SALETIME, 'yyyy-mm')),
    lot_cancel as
     (select to_char(CANCELTIME, 'yyyy-mm-dd') sale_day,
             to_char(CANCELTIME, 'yyyy-mm') sale_month,
         f_get_agency_area(his_cancelticket.applyflow_sell) area_code,
             org_code,
             f_get_game_name(game_code) plan_code,
             sum(TICKET_AMOUNT) lot_cancel_amount,
             sum(COMMISSIONAMOUNT) as lot_cancel_comm
        from his_cancelticket join his_sellticket
          on his_cancelticket.applyflow_sell=his_sellticket.applyflow_sell
          and  CANCELTIME >= trunc(p_curr_date) - 1
          and CANCELTIME <  trunc(p_curr_date) 
          group by f_get_agency_area(his_cancelticket.applyflow_sell),
                org_code,
                f_get_game_name(game_code),
                to_char(CANCELTIME, 'yyyy-mm-dd'),
                to_char(CANCELTIME, 'yyyy-mm')),    
    lot_pay as
     (select to_char(PAYTIME, 'yyyy-mm-dd') sale_day,
             to_char(PAYTIME, 'yyyy-mm') sale_month,
             f_get_agency_area(applyflow_sell) area_code,
             org_code,
             f_get_game_name(game_code) plan_code,
             sum(winningamount) lot_pay_amount,
             sum(commissionamount) lot_pay_comm
        from his_payticket
       where PAYTIME >= trunc(p_curr_date) - 1
         and PAYTIME <  trunc(p_curr_date)
       group by to_char(PAYTIME, 'yyyy-mm-dd'),
                to_char(PAYTIME, 'yyyy-mm'),
                f_get_agency_area(applyflow_sell),
                org_code,
                f_get_game_name(game_code)),
    lot_pre_detail as (
       select sale_day, sale_month, area_code, org_code, plan_code, lot_sale_amount, lot_sale_comm, 0 as lot_cancel_amount, 0 as lot_cancel_comm, 0 as lot_pay_amount, 0 as lot_pay_comm from lot_sale
        union all
       select sale_day, sale_month, area_code, org_code, plan_code, 0 as lot_sale_amount, 0 as lot_sale_comm, lot_cancel_amount, lot_cancel_comm, 0 as lot_pay_amount, 0 as lot_pay_comm from lot_cancel
        union all
       select sale_day, sale_month, area_code, org_code, plan_code, 0 as lot_sale_amount, 0 as lot_sale_comm, 0 as lot_cancel_amount, 0 as lot_cancel_comm, lot_pay_amount, lot_pay_comm from lot_pay
    )
      select sale_day, sale_month, nvl(area_code, 'NONE') area_code, org_code, to_char(plan_code),
           nvl(sum(lot_sale_amount), 0) sale_amount,
           nvl(sum(lot_sale_comm), 0) sale_comm,
           nvl(sum(lot_cancel_amount), 0) cancel_amount,
           nvl(sum(lot_cancel_comm), 0) cancel_comm,
           nvl(sum(lot_pay_amount), 0) pay_amount,
           nvl(sum(lot_pay_comm), 0) pay_comm,
           (nvl(sum(lot_sale_amount), 0) - nvl(sum(lot_sale_comm), 0) - nvl(sum(lot_pay_amount), 0) - nvl(sum(lot_pay_comm), 0) - nvl(sum(lot_cancel_amount), 0) + nvl(sum(lot_cancel_comm), 0)) incoming
      from lot_pre_detail
     group by sale_day, sale_month, area_code, org_code, plan_code;
     
     select count(*) into cnt from his_sale_pay_cancel where plan_code='Lucky5' and sale_date = to_char(p_curr_date, 'yyyy-mm-dd');
     exit when cnt > 0;
     
     exit when p_curr_date = trunc(sysdate);
   end loop;
   commit;
end;
/
