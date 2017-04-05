-- 从线上环境（34.5）导出数据到测试环境（32.181）后，需要执行此脚本
-- 1、替换随机数发生器的IP地址
-- 2、替换所有终端和销售员的用户名和密码。
-- 3、修改kws用户密码为oracletest
alter user kws identified by oracletest

truncate table inf_devices;
insert into inf_devices
  (device_id, device_name, ip_addr, device_status, device_type, game_code)
values
  (0, 'RNG Device 1', '192.168.26.158', 0, 1, 12);

-- all password will change to "111111"
update adm_info set admin_password = '96e79218965eb72c92a549dd5a330112';
update INF_AGENCYS set LOGIN_PASS = '96e79218965eb72c92a549dd5a330112', TRADE_PASS = '96e79218965eb72c92a549dd5a330112';
update INF_MARKET_ADMIN set TRANS_PASS = '96e79218965eb72c92a549dd5a330112';
update INF_TELLERS set PASSWORD = '96e79218965eb72c92a549dd5a330112';

commit;
