-- 初始化授权
insert into inf_orgs (org_code, org_name, org_type, org_status, super_org, phone, director_admin, persons, address) values ('99', 'Paperless ORG', 1, 1, '00', '0', 0, 1000, '-');
insert into inf_org_area (org_code, area_code) values ('99', '9999');
insert into acc_org_account (org_code, acc_type, acc_name, acc_status, acc_no, credit_limit, account_balance, frozen_balance, check_code) values ('99', 1, 'Paperless ORG Account', 1, f_get_acc_no('99','JG'), 100000000000, 0, 0, '-');
commit;
