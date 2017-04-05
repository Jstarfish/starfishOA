create public database link scxt connect to kws identified by oracle 
 using '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=172.16.34.5)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=taishan)))';

create or replace procedure p_tax_report (p_date date default sysdate) is
begin
  delete his_agency_fund
   where calc_date = to_char(p_date - 1, 'yyyy-mm-dd');

  insert into his_agency_fund
    (calc_date,
     agency_code,
     flow_type,
     amount,
     be_account_balance,
     af_account_balance)
    select calc_date,
           agency_code,
           flow_type,
           (case when flow_type in (1, 11 , 2, 8, 41, 45, 7, 0) then dbtool.trunc_div_100(amount) else dbtool.trunc_div_10(amount) end),
           dbtool.trunc_div_100(be_account_balance),
           dbtool.trunc_div_100(af_account_balance)
      from his_agency_fund@scxt
     where calc_date = to_char(p_date - 1, 'yyyy-mm-dd');

  delete his_org_fund where calc_date = to_char(p_date - 1, 'yyyy-mm-dd');
  insert into his_org_fund
    (calc_date,
     org_code,
     charge,
     withdraw,
     center_paid,
     pay_up,
     center_paid_comm)
    select calc_date,
           org_code,
           dbtool.trunc_div_100(charge),
           dbtool.trunc_div_100(withdraw),
           dbtool.trunc_div_100(center_paid),
           dbtool.trunc_div_100(pay_up),
           dbtool.trunc_div_10(center_paid_comm)
      from his_org_fund@scxt
     where calc_date = to_char(p_date - 1, 'yyyy-mm-dd');

  delete his_org_fund_report
   where calc_date = to_char(p_date - 1, 'yyyy-mm-dd');
  insert into his_org_fund_report
    (calc_date,
     org_code,
     be_account_balance,
     charge,
     withdraw,
     sale,
     sale_comm,
     paid,
     pay_comm,
     rtv,
     rtv_comm,
     af_account_balance,
     incoming,
     pay_up,
     center_pay,
     center_pay_comm,
     lot_sale,
     lot_sale_comm,
     lot_paid,
     lot_pay_comm,
     lot_rtv,
     lot_rtv_comm,
     lot_center_pay,
     lot_center_pay_comm,
     lot_center_rtv,
     lot_center_rtv_comm)
    select calc_date,
           org_code,
           dbtool.trunc_div_100(be_account_balance),
           dbtool.trunc_div_100(charge),
           dbtool.trunc_div_100(withdraw),
           dbtool.trunc_div_100(sale),
           dbtool.trunc_div_10(sale_comm),
           dbtool.trunc_div_100(paid),
           dbtool.trunc_div_10(pay_comm),
           dbtool.trunc_div_100(rtv),
           dbtool.trunc_div_10(rtv_comm),
           dbtool.trunc_div_100(af_account_balance),
           dbtool.trunc_div_100(incoming),
           dbtool.trunc_div_100(pay_up),
           dbtool.trunc_div_100(center_pay),
           dbtool.trunc_div_10(center_pay_comm),
           dbtool.trunc_div_100(lot_sale),
           dbtool.trunc_div_10(lot_sale_comm),
           dbtool.trunc_div_100(lot_paid),
           dbtool.trunc_div_10(lot_pay_comm),
           dbtool.trunc_div_100(lot_rtv),
           dbtool.trunc_div_10(lot_rtv_comm),
           dbtool.trunc_div_100(lot_center_pay),
           dbtool.trunc_div_10(lot_center_pay_comm),
           dbtool.trunc_div_100(lot_center_rtv),
           dbtool.trunc_div_10(lot_center_rtv_comm)
      from his_org_fund_report@scxt
     where calc_date = to_char(p_date - 1, 'yyyy-mm-dd');

  delete his_sale_org where calc_date = to_char(p_date - 1, 'yyyy-mm-dd');
  insert into his_sale_org
    (calc_date,
     org_code,
     plan_code,
     sale_amount,
     sale_comm,
     cancel_amount,
     cancel_comm,
     paid_amount,
     paid_comm,
     incoming)
    select calc_date,
           org_code,
           plan_code,
           dbtool.trunc_div_100(sale_amount),
           dbtool.trunc_div_10(sale_comm),
           dbtool.trunc_div_100(cancel_amount),
           dbtool.trunc_div_10(cancel_comm),
           dbtool.trunc_div_100(paid_amount),
           dbtool.trunc_div_10(paid_comm),
           dbtool.trunc_div_100(incoming)
      from his_sale_org@scxt
     where calc_date = to_char(p_date - 1, 'yyyy-mm-dd')
       and plan_code = (select SHORT_NAME from V_DICT_ALL_GAME);

  delete his_sale_pay_cancel
   where sale_date = to_char(p_date - 1, 'yyyy-mm-dd');
  insert into his_sale_pay_cancel
    (sale_date,
     sale_month,
     area_code,
     org_code,
     plan_code,
     sale_amount,
     sale_comm,
     cancel_amount,
     cancel_comm,
     pay_amount,
     pay_comm,
     incoming)
    select sale_date,
           sale_month,
           area_code,
           org_code,
           plan_code,
           dbtool.trunc_div_100(sale_amount),
           dbtool.trunc_div_10(sale_comm),
           dbtool.trunc_div_100(cancel_amount),
           dbtool.trunc_div_10(cancel_comm),
           dbtool.trunc_div_100(pay_amount),
           dbtool.trunc_div_10(pay_comm),
           dbtool.trunc_div_100(incoming)
      from his_sale_pay_cancel@scxt
     where sale_date = to_char(p_date - 1, 'yyyy-mm-dd')
       and plan_code = (select SHORT_NAME from V_DICT_ALL_GAME);

  delete his_pay_level
   where sale_date = to_char(p_date - 1, 'yyyy-mm-dd');
  insert into his_pay_level
    (sale_date,
     sale_month,
     org_code,
     plan_code,
     level_1,
     level_2,
     level_3,
     level_4,
     level_5,
     level_6,
     level_7,
     level_8,
     level_other,
     total)
    select sale_date,
           sale_month,
           org_code,
           plan_code,
           dbtool.trunc_div_100(level_1),
           dbtool.trunc_div_100(level_2),
           dbtool.trunc_div_100(level_3),
           dbtool.trunc_div_100(level_4),
           dbtool.trunc_div_100(level_5),
           dbtool.trunc_div_100(level_6),
           dbtool.trunc_div_100(level_7),
           dbtool.trunc_div_100(level_8),
           dbtool.trunc_div_100(level_other),
           dbtool.trunc_div_100(total)
      from his_pay_level@scxt
     where sale_date = to_char(p_date - 1, 'yyyy-mm-dd')
       and plan_code = (select SHORT_NAME from V_DICT_ALL_GAME);

  commit;
end;
/

begin
   dbms_scheduler.create_schedule (
     schedule_name     => 'schu_every_day',
     start_date        => to_timestamp_tz(to_char(trunc(sysdate),'yyyy-mm-dd') || ' 12:01:00 am +7:00', 'yyyy-mm-dd hh:mi:ss am tzh:tzm'),
     repeat_interval   => 'freq = DAILY;byhour=5;byminute=0;bysecond=0;',
     comments          => '每天5点，需要执行的程序');

   dbms_scheduler.create_program (
      program_name           => 'prog_his_day',
      program_action         => 'p_tax_report',
      program_type           => 'stored_procedure',
      comments               => 'Daily generate the statictics of all lotteries',
      enabled                => true);

   dbms_scheduler.create_job (
      job_name           =>  'job_refresh_day',
      program_name       =>  'prog_his_day',
      schedule_name      =>  'schu_every_day',
      enabled            =>  true);
end;
/

-- 保留60个销售站
-- 通过以下SQL生成钱60个
-- select distinct agency_code from flow_agency where agency_code in (select agency_code from inf_agencys where area_code like '01%' ) and TRADE_TIME > sysdate - 1 and flow_type=7
truncate table inf_agencys;
insert into inf_agencys select * from inf_agencys@scxt where agency_code in ('01010053','01060011','01070389','01070427','01070430','01070445','01110143','01080309','01080313','01030129','01040075','01140010','01060207','01020002','01020100','01060166','01070207','01070231','01070328','01070416','01110156','01080237','01030079','01030164','01040092','01040174','01040196','01130033','01060202','01060174','01070323','01110017','01110039','01110125','01080310','01030188','01040070','01110169','01110256','01110259','01070060','01020107','01050050','01050055','01070193','01070209','01070293','01070386','01070406','01070421','01110077','01080293','01080311','01080312','01030147','01130013','01060220','01010081','01020124','01060001');

-- 修改公司名称
update inf_orgs set org_name='PP-BTMD' where org_code='11';
update inf_orgs set org_name='PP-TAK' where org_code='14';
update inf_orgs set org_name='PP-KPC' where org_code='18';
update inf_orgs set org_name='PP-KPG' where org_code='16';
update inf_orgs set org_name='PP-KMP' where org_code='17';
update inf_orgs set org_name='PP-POP' where org_code='22';
update inf_orgs set org_name='PP-BTM' where org_code='23';
update inf_orgs set org_name='PP-KPD' where org_code='19';
update inf_orgs set org_name='PP-KPSP' where org_code='2';
update inf_orgs set org_name='PP-SR' where org_code='3';
update inf_orgs set org_name='PP-BMG' where org_code='5';
update inf_orgs set org_name='PP-POPD' where org_code='12';
update inf_orgs set org_name='PP-KPTCC' where org_code='26';
update inf_orgs set org_name='PP-SVRCC' where org_code='31';
update inf_orgs set org_name='PP-OMP' where org_code='34';
update inf_orgs set org_name='PP-SVR' where org_code='30';
update inf_orgs set org_name='PP-PRV' where org_code='32';
update inf_orgs set org_name='PP-PRVCC' where org_code='33';
update inf_orgs set org_name='PP-PVH' where org_code='29';
update inf_orgs set org_name='PP-PST' where org_code='36';
update inf_orgs set org_name='PP-SRMCC' where org_code='27';
update inf_orgs set org_name='PP-BTBCC' where org_code='28';
update inf_orgs set org_name='PP-STP' where org_code='35';

-- 删除即开票方案编号
truncate table game_plans;

-- 修改视图
create or replace view v_dict_all_game as
-- 电脑票
select to_char(game_code) plan_code, SHORT_NAME, FULL_NAME, 2 sys_type from inf_games;

-- 裁剪菜单
truncate table ADM_PRIVILEGE;
insert into ADM_PRIVILEGE values (16, 'REPORT', '16000000', 0, null, null, null, null, '报表', '#', 0, 1, 21);
insert into ADM_PRIVILEGE values (11, 'SYSTEM', '18000000', 0, null, null, null, null, '系统管理', '#', 0, 1, 27);

insert into ADM_PRIVILEGE values (1601, 'Inst Outlets Statistics', '16010100', 0, null, null, null, null, '部门站点统计', '/saleReport.do?method=institutionFundReport', 16, 2, 1);
insert into ADM_PRIVILEGE values (1602, 'Sales Reports', '16020100', 0, null, null, null, null, '游戏销售报表', '/saleReport.do?method=initGameSalesReport', 16, 2, 2);
insert into ADM_PRIVILEGE values (1603, 'Institution Sales Reports', '16020200', 0, null, null, null, null, '部门销售报表', '/saleReport.do?method=initInstitutionSalesReport', 16, 2, 3);
insert into ADM_PRIVILEGE values (1604, 'Inst Monthly Report ', '16060100', 0, null, null, null, null, '机构月度报表', '/monthlyReport.do?method=listInstMonthlyReport', 16, 2, 4);

insert into ADM_PRIVILEGE values (1102, 'Institutions', '11020000', 0, null, null, null, null, '代理商管理', '/institutions.do?method=listInstitutions', 11, 2, 2);
insert into ADM_PRIVILEGE values (1103, 'Outlets', '11030000', 0, null, null, null, null, '站点管理', '/outlets.do?method=listOutlets', 11, 2, 3);
commit;

truncate table adm_role_privilege;
insert into adm_role_privilege select 0,p.privilege_id from adm_privilege p;
commit;


/*
-- 销售站清单
create table fake_ahency as select agency_code from inf_agencys where 
agency_code in ('01010002','01010068','01010069','01010072','01010077','01010080','01019004','01119007','01119009','01119010','01119021','01119022','04000296','04000297','04000316','04000341','04000347','04009002','04009005','04009006','06000004','06000102','06000128','06000161','06000173','06000174','06000175','06000179','06000181','08000062','08000093','08000159','08000160','08000187','08000188','08009002','08009003','16000184','16000213','16000230','16000235','16000242','16009002','21990004','21990010','21990011','21990013','21990017','21990018','21990019','21990020','21990022','21990023','24000016','24000103','24000108','24000113','24000125','24000126','24009003');

-- 生成销售站数据
-- 1、找出当天的销量
-- 2、循环，随机获取一个销售站的销量（用总销量为随机数的上界，取第一个销量，然后上界减去这个销量，产生下一个）
-- 3、根据销量，产生佣金
-- 4、根据总充值，随机产生充值金额；
-- 5、根据总提现，随机产生提现金额；
-- 6、计算总的提现值（实际的数据-随机生成的数据），随机5%的几率分布提现值
-- 7、计算期初和期末余额


create or replace procedure p_tax_report (p_date date default sysdate) is
  v_total_sale_amount number(28);  -- 实际总销量
begin
  select sum()
end;
/
*/


declare
  v_dd date;
begin
  v_dd := trunc(sysdate) - 30;
  while 1=1 loop
    p_tax_report(v_dd);
    v_dd := v_dd + 1;
    exit when v_dd = trunc(sysdate);
  end loop;
end;
/