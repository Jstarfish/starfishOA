/****************************************************/
/****************  修改说明  ************************/
-- created by 陈震 @ 2015/9/8
--       新增银行、销售站类型和印制厂商基本信息
/***************************************************/

-- 银行
insert into inf_banks(bank_id, bank_name) values (1,'Acleda Bank Plc.');
insert into inf_banks(bank_id, bank_name) values (2,'Canadia Bank Plc.');
insert into inf_banks(bank_id, bank_name) values (3,'Cambodian Public Bank');
insert into inf_banks(bank_id, bank_name) values (4,'ANZ Royal Bank (Cambodia) Ltd.');
insert into inf_banks(bank_id, bank_name) values (5,'ICBC Limited Phnom Penh Branch');
insert into inf_banks(bank_id, bank_name) values (6,'Bank for Investment and Development of Cambodia Plc.');
insert into inf_banks(bank_id, bank_name) values (7,'Foreign Trade Bank of Cambodia');
insert into inf_banks(bank_id, bank_name) values (8,'Bank of China Limited Phnom Penh Branch');
insert into inf_banks(bank_id, bank_name) values (9,'May Bank (Cambodia) Plc.');
insert into inf_banks(bank_id, bank_name) values (10,'Union Commercial Bank Plc.');

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

--系统参数
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (1, '还货单自动审批金额上限（瑞尔）', '999999999');
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (2, '管理员兑奖，代销费属于“1-销售站点，2-不计算”', '2');
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (3, '当前手持终端系统可用版本号', '1.0');
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (4, '手持终端系统下载URL', 'http://116.212.139.5:12884/download/pilottery_apk/AssistV1.0.apk');
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (5, '终端兑奖限额', '400000');
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (6, '分公司兑奖限额', '2800000');
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (7, '是否启用分公司兑奖限额（1=限制，2=不限制）', '1');
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (8, '手持终端系统下载URL用户名', 'tsuser');
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (9, '手持终端系统下载URL密码', '#taishan1371-CLS!');
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (10, '提现自动审批金额上限（瑞尔）', '999999999');
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (11, '站点爱心兑奖佣金（千分位）', '10');
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (12, '机构爱心兑奖佣金（千分位）', '10');
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (15, '爱心游戏是否开放（1=开放，2=关闭）', '1');
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (16, '是否计算分公司中心兑奖佣金（1=计算，2=不计算）', '2');
insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (100, '瑞尔与美元汇率', '4000');

commit;

--根组织
insert into inf_orgs
(org_code, org_name, org_type, org_status, super_org, phone, director_admin, persons, address)
values
('00', 'KPW Headquarter', 1, 1, '00', '089304541', 0, 1000, 'Naga World');

insert into inf_org_area (org_code, area_code)
values
('00', '0000');

insert into acc_org_account
  (org_code, acc_type, acc_name, acc_status, acc_no, credit_limit, account_balance, frozen_balance, check_code)
values
  ('00', 1, 'KPW Headquarter', 1, f_get_acc_no('00','JG'), 100000000000, 0, 0, '-');

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

