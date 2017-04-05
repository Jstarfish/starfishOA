INSERT INTO ADM_PRIVILEGE T (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_IS_CENTER, PRIVILEGE_AGREEDAY, PRIVILEGE_LOGINBEGIN, PRIVILEGE_LOGINEND, PRIVILEGE_REMARK, PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
  VALUES (120504, 'MM Inventory Check', '12050400', 0, NULL, NULL, NULL, NULL, '市场管理员库存盘点查询', '/inventory.do?method=listMMInventoryCheck', 1205, 3, 12);
INSERT INTO ADM_ROLE_PRIVILEGE VALUES (0,120504);
COMMIT;

-- 修改所有销售站类型为标准型
update inf_agencys set AGENCY_TYPE=1;
commit;
