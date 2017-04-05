-- 初始化授权
insert into auth_org (org_code, game_code, pay_commission_rate, sale_commission_rate, auth_time, allow_sale, allow_pay, allow_cancel) select org_code, game_code, 0, 0, sysdate, 1, 1, 0 from inf_orgs, inf_games;
commit;

insert into auth_agency (agency_code, game_code, pay_commission_rate, sale_commission_rate, allow_sale, allow_pay, allow_cancel, claiming_scope, auth_time) select agency_code, game_code, 1, 1, 0, 0, 0, 0, sysdate from inf_agencys, inf_games;
commit;

-- RNG Clients
insert into inf_devices
  (device_id, device_name, ip_addr, device_status, device_type, game_code)
values
  (1, 'RNG Device 1', '172.16.34.1', 0, 1, 12);
insert into inf_devices
  (device_id, device_name, ip_addr, device_status, device_type, game_code)
values
  (2, 'RNG Device 2', '172.16.34.2', 0, 1, 12);
commit;

-- MIS初始化一条日结记录，作为最初的内容
insert into his_day_settle (settle_id, opt_date, settle_date, sell_seq, cancel_seq, pay_seq, win_seq) values (0, to_date('2000-01-01','yyyy-mm-dd'), to_date('2000-01-01','yyyy-mm-dd'), 0, 0, 0, 0);
commit;

-- 票面欢迎语
insert into sys_ticket_memo (his_code, game_code, ticket_memo, set_admin, set_time) values (0, 0, 'Thanks for supporting!', 1, to_date('2010-01-01','yyyy-mm-dd'));
commit;

--终端类型
insert into inf_terminal_types (TERM_TYPE_ID,TERM_TYPE_DESC) values (1,'ST300');
insert into inf_terminal_types (TERM_TYPE_ID,TERM_TYPE_DESC) values (2,'GDS688-3');

--软件
insert into UPG_SOFTWARE (soft_id, soft_name, soft_describe, create_date) values (1, 'sbin', 'System Environment',sysdate);
insert into UPG_SOFTWARE (soft_id, soft_name, soft_describe, create_date) values (2, 'comm', 'Communication Service', sysdate);
insert into UPG_SOFTWARE (soft_id, soft_name, soft_describe, create_date) values (3, 'gui', 'GUI', sysdate);
insert into UPG_SOFTWARE (soft_id, soft_name, soft_describe, create_date) values (4, 'tds', 'Terminal Display System', sysdate);
insert into UPG_SOFTWARE (soft_id, soft_name, soft_describe, create_date) values (5, 'driver', 'Device Drivers', sysdate);
insert into UPG_SOFTWARE (soft_id, soft_name, soft_describe, create_date) values (6, 'resources', 'Service Repositories', sysdate);
insert into UPG_SOFTWARE (soft_id, soft_name, soft_describe, create_date) values (7, 'upgrade', 'Upgrade Service', sysdate);

commit;

--软件版本
insert into upg_software_ver
select '1.0.00',soft_id,1,sysdate,soft_name||' Initial Version',0,'96e79218965eb72c92a549dd5a330113' from UPG_SOFTWARE;

commit;

-- 银行
insert into inf_banks (bank_id, bank_name) values (1,'Acleda Bank Plc.');
insert into inf_banks (bank_id, bank_name) values (2,'Canadia Bank Plc.');
insert into inf_banks (bank_id, bank_name) values (3,'Cambodian Public Bank');
insert into inf_banks (bank_id, bank_name) values (4,'ANZ Royal Bank (Cambodia) Ltd.');
insert into inf_banks (bank_id, bank_name) values (5,'ICBC Limited Phnom Penh Branch');
insert into inf_banks (bank_id, bank_name) values (6,'Bank for Investment and Development of Cambodia Plc.');
insert into inf_banks (bank_id, bank_name) values (7,'Foreign Trade Bank of Cambodia');
insert into inf_banks (bank_id, bank_name) values (8,'Bank of China Limited Phnom Penh Branch');
insert into inf_banks (bank_id, bank_name) values (9,'May Bank (Cambodia) Plc.');
insert into inf_banks (bank_id, bank_name) values (10,'Union Commercial Bank Plc.');

commit;

-- 销售站类型
insert into INF_STORETYPES values (1,'Book shop/书店',1);
insert into INF_STORETYPES values (2,'Bus Station / 车站',1);
insert into INF_STORETYPES values (3,'Cafe Shop/咖啡店',1);
insert into INF_STORETYPES values (4,'Clothes Shop/服装店',1);
insert into INF_STORETYPES values (5,'Computer Shop / 电脑店',1);
insert into INF_STORETYPES values (6,'Fruit Shop / 水果店',1);
insert into INF_STORETYPES values (7,'Furniture/家具',1);
insert into INF_STORETYPES values (8,'Gold Shop / 金店',1);
insert into INF_STORETYPES values (9,'Grocery/杂货店',1);
insert into INF_STORETYPES values (10,'Guest House/客栈',1);
insert into INF_STORETYPES values (11,'Hotel / 旅店',1);
insert into INF_STORETYPES values (12,'Internet Shop / 网吧店',1);
insert into INF_STORETYPES values (13,'Laundry Shop/洗衣店',1);
insert into INF_STORETYPES values (14,'Machine Shop / 卖机器',1);
insert into INF_STORETYPES values (15,'Money Transfer /汇钱处',1);
insert into INF_STORETYPES values (16,'Phamacy/药店',1);
insert into INF_STORETYPES values (17,'Phone Shop/手机店',1);
insert into INF_STORETYPES values (18,'Photo Shop/照相馆',1);
insert into INF_STORETYPES values (19,'Printing House / 印刷',1);
insert into INF_STORETYPES values (20,'Restaurant / 餐厅',1);
insert into INF_STORETYPES values (21,'Salon / 理发店',1);
insert into INF_STORETYPES values (22,'Shoe Shop / 鞋店',1);
insert into INF_STORETYPES values (23,'Snooker / 台球店',1);
insert into INF_STORETYPES values (24,'VN Agency/越南彩票',1);
insert into INF_STORETYPES values (25,'Other/其他',1);

commit;

--印制厂商
insert into inf_publishers (publisher_code, publisher_name, is_valid, plan_flow) values (1, '石家庄', 1, 1);
insert into inf_publishers (publisher_code, publisher_name, is_valid, plan_flow) values (3, '中彩印制', 1, 2);
commit;

--根组织
insert into inf_orgs (org_code, org_name, org_type, org_status, super_org, phone, director_admin, persons, address) values ('00', 'KPW Headquarter', 1, 1, '00', '089304541', 0, 1000, 'Naga World');
insert into inf_org_area (org_code, area_code) values ('00', '0000');
insert into acc_org_account (org_code, acc_type, acc_name, acc_status, acc_no, credit_limit, account_balance, frozen_balance, check_code) values ('00', 1, 'KPW Headquarter', 1, f_get_acc_no('00','JG'), 100000000000, 0, 0, '-');

commit;


-- 初始化维度数据
insert into HIS_DIM_DWM
   (D_YEAR, D_MONTH, D_WEEK, D_DAY)
select to_char(days, 'yyyy'),
       to_char(days, 'yyyy-mm'),
       to_char(days, 'iw'),
       to_char(days, 'yyyy-mm-dd')
  from (select rownum + trunc(sysdate) days
          from dual
        connect by rownum < 365 * 5);

commit;

