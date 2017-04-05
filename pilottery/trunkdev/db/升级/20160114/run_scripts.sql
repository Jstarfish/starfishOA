insert into SYS_PARAMETER (SYS_DEFAULT_SEQ, SYS_DEFAULT_DESC, SYS_DEFAULT_VALUE) values (16, '�Ƿ������������Ķҽ�Ӷ��1=���㣬2=�����㣩', '2');
commit;

Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (10, 'SALES', '10000000', 0, '���۹���',
    '#', 0, 1, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (11, 'DATA', '11000000', 0, '����ά��',
    '#', 0, 1, 6);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (12, 'INVENTORY', '12000000', 0, '������',
    '#', 0, 1, 9);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (13, 'PAYOUT', '13000000', 0, '�ҽ�',
    '#', 0, 1, 12);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (14, 'CAPITAL', '14000000', 0, '�ʽ����',
    '#', 0, 1, 15);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (15, 'MARKET MANAGER', '15000000', 0, '�г�����Ա�˻�',
    '#', 0, 1, 18);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (16, 'REPORT', '16000000', 0, '����',
    '#', 0, 1, 21);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (17, 'OUTLET SERVICE', '17000000', 0, 'վ�����',
    '#', 0, 1, 24);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (18, 'SYSTEM', '18000000', 0, 'ϵͳ����',
    '#', 0, 1, 27);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (19, 'MONITOR', '19000000', 0, 'ϵͳ����', '#', 0, 1, 26);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1001, 'Purchase Order Apply', '10010000', 0, '��������',
    '/order.do?method=listOrderByApplyUser', 10, 2, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1002, 'Purchase Order Inquery', '10020000', 0, '������ѯ',
    '/order.do?method=listOrderForInquery', 10, 2, 6);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1003, 'Stock Transfer Apply', '10030000', 0, '����������',
    '/transfer.do?method=listTransferByApplyUser', 10, 2, 9);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1004, 'Stock Transfer Approval', '10040000', 0, '����������',
    '/transfer.do?method=listTransferForInquery', 10, 2, 12);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1005, 'Delivery Order Apply', '10050000', 0, '����������',
    '/delivery.do?method=listDeliveryByApplyUser', 10, 2, 15);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1006, 'Delivery Order Inquery', '10060000', 0, '��������ѯ',
    '/delivery.do?method=listDeliveryForInquery', 10, 2, 18);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1101, 'Administrative Areas', '11010000', 0, '�����������',
    '/areas.do?method=listAreas', 11, 2, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1102, 'Institutions', '11020000', 0, '�����̹���',
    '/institutions.do?method=listInstitutions', 11, 2, 6);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1103, 'Outlets', '11030000', 0, 'վ�����',
    '/outlets.do?method=listOutlets', 11, 2, 9);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1201, 'Plans', '12010000', 0, '��������',
    '/plans.do?method=listPlans', 12, 2, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1202, 'Warehouses', '12020000', 0, '�ֿ����',
    '/warehouses.do?method=listWarehouses', 12, 2, 6);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1203, 'Goods Receipts', '12030000', 0, '������',
    '#', 12, 2, 9);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1204, 'Goods Issues', '12040000', 0, '�������',
    '#', 12, 2, 12);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1205, 'Inventory', '12050000', 0, '������',
    '#', 12, 2, 15);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1206, 'Damaged Goods', '12060000', 0, '��ٹ���',
    '/damagedGoods.do?method=listDamagedGoods', 12, 2, 18);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1207, 'Logistics Information', '12070000', 0, '������ѯ',
    '/logistics.do?method=initLogistics', 12, 2, 21);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1208, 'Batch Termination', '12080000', 0, '�����ս�',
    '/termination.do?method=initBathTermination', 12, 2, 24);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1209, 'Item Maintenance', '12090000', 0, '��Ʒ����',
    '#', 12, 2, 27);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1301, 'Process Payout', '13010000', 0, '���Ķҽ�',
    '/payout.do?method=initProcessPayout', 13, 2, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1303, 'Payout Records', '13030000', 0, '�ҽ���ѯ',
    '/payout.do?method=listPayout', 13, 2, 9);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1401, 'Institution Capital', '14010000', 0, '�����ʽ����',
    '#', 14, 2, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1402, 'Account Maintenance', '14020000', 0, '�ʽ��˻�����',
    '#', 14, 2, 6);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1403, 'Cash Withdrawn Approval', '14030000', 0, '���ֹ���',
    '/cashWithdrawn.do?method=listCashWithdrawn', 14, 2, 9);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1404, 'Return Deliveries', '14040000', 0, '��������',
    '/return.do?method=listReturnDeliveries', 14, 2, 12);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1405, 'Repayment', '14050000', 0, '�������',
    '/repayment.do?method=listRepayment', 14, 2, 15);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1501, 'Return Delivery', '15010000', 0, '��������',
    '/returnDelivery.do?method=listReturnDeliveries', 15, 2, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1502, 'Inventory Information', '15020000', 0, '����ѯ',
    '/repaymentRecord.do?method=listInventory', 15, 2, 6);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1503, 'Register Damaged Goods', '15030000', 0, '��ٵǼ�',
    '/damegeGood.do?method=initDamageGood', 15, 2, 9);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1504, 'Account Balance', '15040000', 0, '�˻�����ѯ',
    '/marketManagerBalance.do?method=queryAccountBalance', 15, 2, 12);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1505, 'Repayment Records', '15050000', 0, '�����¼',
    '/repaymentRecord.do?method=listRepaymentRecords', 15, 2, 15);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1506, 'MM Transaction Records', '15060000', 0, '�г�����Ա���׼�¼��ѯ',
    '/transferRecord.do?method=listMMTransferRecords', 15, 2, 18);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
(1601, 'Fund Report', '16010000', 0, '�ʽ𱨱�', '#', 16, 2, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1602, 'Sales Report', '16020000', 0, '���۱���', '#', 16, 2, 6);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1603, 'Inventory Report', '16030000', 0, '��汨��', '#', 16, 2, 9);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1604, 'Charts', '16040000', 0, 'ͳ��ͼ��', '#', 16, 2, 12);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (160101, 'Institution Fund Report', '16010100', 0, '�����ʽ𱨱�',
    '/saleReport.do?method=institutionFundReport', 1601, 3, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (160102, 'Outlet Fund Report', '16010200', 0, 'վ���ʽ𱨱�',
    '/saleReport.do?method=outletFundReport', 1601, 3, 6);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (160103, 'Institution Report(USD)', '16010300', 0, '�����ʽ𱨱�(��Ԫ)',
    '/saleReport.do?method=institutionFundReportUSD', 1601, 3, 9);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (160104, 'Outlet Fund Report(USD)', '16010400', 0, 'վ���ʽ𱨱�(��Ԫ)',
    '/saleReport.do?method=outletFundReportUSD', 1601, 3, 12);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (160105, 'MM Capital Daliy Report', '16010500', 0, '�г�����Ա�ʽ��սᱨ��',
    '/saleReport.do?method=mmCapitalDaliyReport', 1601, 3, 15);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (160201, 'Sales Reports', '16020100', 0, '��Ϸ���۱���',
    '/saleReport.do?method=initGameSalesReport', 1602, 3, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (160202, 'Institution Sales Reports', '16020200', 0, '�������۱���',
    '/saleReport.do?method=initInstitutionSalesReport', 1602, 3, 6);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (160203, 'Payout Reports', '16020300', 0, '�ҽ�����',
    '/report.do?method=initPayoutReports', 1602, 3, 9);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (160301, 'Inventory Reports', '16030100', 0, '��汨��',
    '/saleReport.do?method=initInventoryReports', 1603, 3, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (160302, 'MM Inventory Daliy Report', '16030200', 0, '�г�����Ա����սᱨ��',
    '/saleReport.do?method=mmInventoryDaliyReport', 1603, 3, 6);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (160401, 'Institution Sales', '16040100', 0, '���ż��ͳ��',
    '/monitor.do?method=institutionSales', 1604, 3, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (160402, 'Sales Statistics', '16040200', 0, '��Ϸ���ۼ��',
    '/monitor.do?method=salesStatistics', 1604, 3, 6);

Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1701, 'Outlet Information', '17010000', 0, 'վ����Ϣ��ѯ',
    '/outletInfo.do?method=listOutletInfo', 17, 2, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1702, 'Transaction Records', '17020000', 0, '������ˮ��ѯ',
    '/outlets.do?method=agencyDealRecord', 17, 2, 6);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1703, 'Return Delivery Records', '17030000', 0, '�˻���ѯ',
    '/returnedGoods.do?method=returnGoodsList', 17, 2, 9);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1704, 'Fund Daliy Record', '17040000', 0, '�ʽ��ս�',
    '/outlets.do?method=fundDailyRecord', 17, 2, 12);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1705, 'Sales Records', '17050000', 0, '������ۼ�¼',
    '/outletGoods.do?method=outletGoodsList', 17, 2, 15);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1706, 'Cash Withdrawn Records', '17060000', 0, '���ּ�¼',
    '/withdrawnRecords.do?method=listWithdrawnRecords', 17, 2, 18);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1801, 'Users', '18010000', 0, '�û�����',
    '/user.do?method=listUsers', 18, 2, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1802, 'Roles', '18020000', 0, '��ɫ����',
    '/role.do?method=listRoles', 18, 2, 6);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1803, 'Change Password', '18030000', 0, '�޸�����',
    '/user.do?method=initChangePwd', 18, 2, 9);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1804, 'Change Trans Password', '18040000', 0, '�޸Ľ�������',
    '/marketManagerPwd.do?method=changeMarketManagerPwd', 18, 2, 12);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1805, 'System Parameter', '18050000', 0, 'ϵͳ��������',
    '/sysParameter.do?method=sysParameterList', 18, 2, 15);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1901, 'Summary Statistics', '19010000', 0, '���ͳ��ͼ����',
    '/monitor.do?method=summaryStatistics', 19, 2, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1902, 'Real-Time Sales', '19020000', 0, '��Ϸ�������',
    '/monitor.do?method=salesRealTime', 19, 2, 6);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1905, 'Outlet Rankings', '19050000', 0, 'վ����������',
    '/monitor.do?method=outletRankings', 19, 2, 15);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (120301, 'Goods Receipts Information', '12030100', 0, '����ѯ',
    '/goodsReceipts.do?method=listGoodsReceipts', 1203, 3, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (120302, 'Goods Receipt by Batch', '12030200', 0, '�������',
    '/goodsReceipts.do?method=receiptByBatch', 1203, 3, 6);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (120303, 'Goods Receipt by Stock Transfer', '12030300', 0, '���������',
    '/goodsReceipts.do?method=receiptByStockTransfer', 1203, 3, 9);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (120304, 'Goods Receipt by Return Delivery', '12030400', 0, '�������',
    '/goodsReceipts.do?method=receiptByRetrunDelevery', 1203, 3, 12);

Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (120401, 'Goods Issue Information', '12040100', 0, '�����ѯ',
    '/goodsIssues.do?method=listGoodsIssues', 1204, 3, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (120402, 'Goods Issue by Stock Transfer', '12040200', 0, '����������',
    '/goodsIssues.do?method=issueByStockTransfer', 1204, 3, 6);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (120403, 'Goods Issue by Delivery Order', '12040300', 0, '����������',
    '/goodsIssues.do?method=issueByDeliveryOrder', 1204, 3, 9);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (120501, 'Inventory Information', '12050100', 0, '����ѯ',
    '/inventory.do?method=listInventoryInfo', 1205, 3, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (120502, 'Process Inventory Check', '12050200', 0, '����̵�',
    '/inventory.do?method=listInventoryCheck', 1205, 3, 6);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (120901, 'Item Types', '12090100', 0, '������',
    '/item.do?method=listItemTypes', 1209, 3, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (120902, 'Item Receipts', '12090200', 0, '������',
    '/item.do?method=listGoodsReceipts', 1209, 3, 6);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (120903, 'Item Issues', '12090300', 0, '�������',
    '/item.do?method=listGoodsIssues', 1209, 3, 9);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (120904, 'Inventory Information', '12090400', 0, '����ѯ',
    '/item.do?method=listInventoryInfo', 1209, 3, 12);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (120905, 'Process Inventory Check', '12090500', 0, '����̵�',
    '/item.do?method=listInventoryCheck', 1209, 3, 15);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (120906, 'Damaged Items', '12090600', 0, '��Ʒ���',
    '/item.do?method=listDamagedItems', 1209, 3, 18);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (140101, 'Top Ups', '14010100', 0, '��ֵ',
    '/topUps.do?method=listTopUps', 1401, 3, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (140102, 'Cash Withdrawn', '14010200', 0, '��������',
    '/orgsWithdrawnRecords.do?method=listRecords', 1401, 3, 6);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (140103, 'Account Balance', '14010300', 0, '�˻����',
    '/accountBalance.do?method=listAccountBalance', 1401, 3, 9);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (140201, 'Outlet Accounts', '14020100', 0, 'վ���˻�����',
    '/account.do?method=listOutletAccounts', 1402, 3, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (140202, 'Institution Accounts', '14020200', 0, '�������˻�����',
    '/account.do?method=listInstitutionAccounts', 1402, 3, 6);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (140203, 'Market Managers Accounts', '14020300', 0, '�г�����Ա�˻�����',
    '/account.do?method=listMarketManagersAccounts', 1402, 3, 9);



----��Ʊ����˵�
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (44, 'VALIDATE', '44000000', 0, '��Ʊ����', '#', 0, 1, 44);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)

Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (4401, 'Scan Tickets', '44010000', 0, 'ɨƱ��Ʊ',
    '/checktickets.do?method=scanTickets', 44, 2, 1);

Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (4403, 'Inquiry', '44030000', 0, '��Ʊ��ѯ',
    '/checktickets.do?method=inquiryCheckedTickets', 44, 2, 3);

Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (4405, 'Statistical Reports', '44050000', 0, 'ͳ�Ʊ���',
    '/checktickets.do?method=statisticalReports', 44, 2, 5);

Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (4407, 'Refused Records', '44070000', 0, '�ܾ��ҽ�ͳ��',
    '/checktickets.do?method=refusedRecords', 44, 2, 7);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (160204, 'Validate Winning Report', '16020400', 0, '�齱ͳ�Ʊ���',
    '/checktickets.do?method=statisticalReports', 1602, 3, 12);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (1406, 'Outlet Adjustment', '14060000', 0, 'վ�����',
    '/account.do?method=getOutletInfo', 14, 2, 18);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (160106, 'Inst Payable Report', '16010600', 0, '����Ӧ�ɿ��',
    '/saleReport.do?method=institutionPayableReport', 1601, 3, 18);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (160107, 'Inst Payable Report(USD)', '16010700', 0, '����Ӧ�ɿ��(��Ԫ)',
    '/saleReport.do?method=institutionPayableReportUSD', 1601, 3, 21);
insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
values
   (160305, 'HQ Item Issue Report', '16030500', 0, '�ܲ���Ʒ���ⱨ��',
    '/hqItemIssueReport.do?method=initHQItemIssueReport', 1603, 3, 15);
insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
values
   (160306, 'HQ Issue Statistics', '16030600', 0, '�ܲ��������ⱨ��',
    '/goodsReceiptsReport.do?method=initGoodsReceiptsReport', 1603, 3, 18);
insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_REMARK,
    PRIVILEGE_URL, PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
values
   (160307, 'HQ Receipt Statistics', '16030700', 0, '�ܲ�����������',
    '/goodsReceiptsReport.do?method=initGoodsOutReport', 1603, 3, 21);
COMMIT;

delete adm_role_privilege where ROLE_ID=0;
insert into adm_role_privilege select 0,p.privilege_id from adm_privilege p;
commit;

alter table ITEM_ISSUE add remark VARCHAR2(4000);
alter table ITEM_RECEIPT add remark VARCHAR2(4000);

update wh_goods_receipt tt set RECEIVE_ORG=(select org_code from wh_info where warehouse_code = tt.receive_wh) where RECEIVE_ORG is null and receive_wh is not null;
commit;

create or replace procedure p_rr_inbound
/****************************************************************/
   ------------------- ��������� -------------------
   ---- ��������⡣֧������⣬������⣬�����ᡣ
   ----     ״̬�����ǡ��������������ܽ��в���
   ----     ����⣺  ���¡����������ջ���Ϣ��
   ----               ��������ⵥ����
   ----               ���մ��ݵ��������䡢�С��������²�Ʊ���ݣ�ͬʱҲҪ����ⵥ��ϸ�м�¼������
   ----               ���ݲ�Ʊͳ�����ݣ����¡���ⵥ���͡�����������¼��
   ----               �޸ġ��г�����Ա���Ŀ���Ʊ״̬��
   ----     ������⣺���մ��ݵ��������䡢�С��������²�Ʊ���ݣ�ͬʱҲҪ����ⵥ��ϸ�м�¼������
   ----               ���ݲ�Ʊͳ�����ݣ����¡���ⵥ���͡�����������¼��
   ----               �޸ġ��г�����Ա���Ŀ���Ʊ״̬��
   ----     �����᣺���¡����������͡���ⵥ��ʱ���״̬��Ϣ��
   ---- add by ����: 2015/9/21
   ---- �漰��ҵ���
   ----     2.1.6.6 ������                      -- ����
   ----     2.1.5.10 ��ⵥ                     -- ����������
   ----     2.1.5.11 ��ⵥ��ϸ                 -- ����������
   ----     2.1.5.3 ����Ʊ��Ϣ���䣩            -- ����
   ----     2.1.5.4 ����Ʊ��Ϣ���У�            -- ����
   ----     2.1.5.5 ����Ʊ��Ϣ������            -- ����
   ---- ҵ�����̣�
   ----     1��У��������������ֿ��Ƿ���ڣ����������Ƿ�Ϊ�¡���������᣻�������Ƿ�Ϸ�����
   ----     2����������Ϊ����ᡱʱ�����¡����������ġ��ջ�ʱ�䡱�͡�״̬��5-���ջ����������¡���ⵥ���ġ����ʱ�䡱�͡�״̬�����������У����ء�
   ----     3����ȡ�Ѿ�����Ĳ��������������εİ�װ��Ϣ-bulk��ʽ��ȡ����
   ----     4����������Ϊ���½���ʱ�����¡����������ջ���Ϣ��������Ҫ���롰״̬����ֵ����Ϊ��������������������ⵥ����
   ----     5�����������ϸ�����¡�����Ʊ��Ϣ�����и�����������ԣ������б�����롰״̬���͡����ڲֿ⡱���������Ҽ����¼�¼��������������޸��¼�¼������򱨴�
   ----        ͬʱͳ�Ʋ�Ʊͳ����Ϣ��
   ----     6�����¡���ⵥ���ġ�ʵ�������ϼơ��͡�ʵ�����������,�����������ġ�ʵ�ʵ���Ʊ�����͡�ʵ�ʵ���Ʊ���漰����¼��
   ----        �����г�����Ա�Ŀ�棻

   /*************************************************************/
(
 --------------����----------------
 p_r_no              in char,                -- ���������
 p_warehouse         in char,                -- �ջ��ֿ�
 p_oper_type         in number,              -- ��������(1-������2-������3-���)
 p_oper              in number,              -- ������
 p_remark            in varchar2,            -- ��ע
 p_array_lotterys    in type_lottery_list,   -- ���Ĳ�Ʊ����

 ---------���ڲ���---------
 c_errorcode out number,                     --�������
 c_errormesg out string                      --����ԭ��

 ) is

   v_count                 number(5);                                      -- ���¼������ʱ����
   v_wh_org                char(2);                                        -- �ֿ����ڲ���
   v_plan_tickets          number(18);                                     -- �ƻ����Ʊ��
   v_plan_amount           number(18);                                     -- �ƻ������
   v_mm                    number(4);                                      -- �г�����Ա
   v_sgr_no                char(10);                                       -- ��ⵥ���

   v_list_count            number(10);                                     -- �����ϸ����

   type type_detail        is table of wh_goods_receipt_detail%rowtype;
   v_insert_detail         type_detail;                                    -- ���������ϸ������
   v_detail_list           type_lottery_detail_list;                       -- �����ϸ
   v_stat_list             type_lottery_statistics_list;                   -- ���շ���������ͳ�ƵĽ���Ʊ��

   v_total_tickets         number(20);                                     -- ���˳������Ʊ��
   v_total_amount          number(28);                                     -- ���˳�����ܽ��
   v_plan_publish          number(1);                                      -- ӡ�Ƴ��̱��
   v_temp_tickets          number(20);                                     -- ���˳������Ʊ��
   v_temp_amount           number(28);                                     -- ���˳�����ܽ��

   v_err_code              number(10);                                     -- ���ô洢����ʱ������ֵ
   v_err_msg               varchar2(4000);                                 -- ���ô洢����ʱ�����ش�����Ϣ

begin

   /*-----------    ��ʼ������    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- ����У��   -----------------*/
   -- У����ڲ����Ƿ���ȷ����Ӧ�����ݼ�¼�Ƿ����
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- �޴���
      return;
   end if;

   if not f_check_warehouse(p_warehouse) then
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_warehouse) || error_msg.err_common_101; -- �޴˲ֿ�
      return;
   end if;

   if not p_oper_type in (1,2,3) then
      c_errorcode := 3;
      c_errormesg := dbtool.format_line(p_oper_type) || error_msg.err_common_105; -- �������Ͳ�������Ӧ��Ϊ1��2��3
      return;
   end if;

   -- �������ʱ���ж��Ƿ��Ѿ����
   if p_oper_type = 2 then
      select count(*) into v_count from dual where exists(select 1 from wh_goods_receipt where ref_no = p_r_no and status = ework_status.working);
      if v_count = 0 then
         c_errorcode := 4;
         c_errormesg := dbtool.format_line(p_r_no) || error_msg.err_p_tb_inbound_3; -- �ڽ��м������ʱ������ĵ������Ŵ��󣬻��ߴ˵�������Ӧ����ⵥ������Ѿ����
         return;
      end if;
   end if;
   /*----------- ҵ���߼�   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* ��������Ϊ����ᡱʱ�����¡����������ġ��ջ�ʱ�䡱�͡�״̬�������¡���ⵥ���ġ����ʱ�䡱�͡�״̬�����������У����ء� *************************/
   if p_oper_type = 3 then
      -- ���¡����������ġ��ջ�ʱ�䡱�͡�״̬��
      update sale_return_recoder
         set receive_date = sysdate,
             status = eorder_status.received
       where return_no = p_r_no
         and status = eorder_status.receiving
      returning
         status
      into
         v_count;
      if sql%rowcount = 0 then
         rollback;

         begin
            select status into v_count from sale_return_recoder where return_no = p_r_no;
         exception
            when no_data_found then
               c_errorcode := 24;
               c_errormesg := dbtool.format_line(p_r_no) || error_msg.err_p_rr_inbound_24; -- ��������Ų��Ϸ���δ��ѯ���˻�����
               return;
         end;

         c_errorcode := 4;
         c_errormesg := dbtool.format_line(p_r_no) || dbtool.format_line(v_count) || error_msg.err_p_rr_inbound_4; -- ������������ʱ��������״̬���Ϸ��������Ļ�����״̬Ӧ��Ϊ[�ջ���]
         return;
      end if;

      -- ���¡���ⵥ���ġ����ʱ�䡱�͡�״̬��
      update wh_goods_receipt
         set status = ework_status.done,
             receipt_end_time = sysdate,
             send_admin = p_oper,
             remark = p_remark
       where ref_no = p_r_no
         and status = ework_status.working;

      commit;
      return;
   end if;

   /**********************************************************************************************/
   /******************* ���������������Լ��Ѿ��ύ���������Ƿ�Ϸ� *************************/
   if f_check_import_ticket(p_r_no, 1, p_array_lotterys) then
      c_errorcode := 6;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_103; -- ��Ʊ���󣬴��ڡ��԰����������
      return;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* ��ȡ�Ѿ�����Ĳ��������������εİ�װ��Ϣ-bulk��ʽ��ȡ���� *************************/

   -- ��ȡӡ�Ƴ�����Ϣ
/*   select plan_flow
     into v_plan_publish
     from inf_publishers
    where publisher_code =
          (select publisher_code from game_plans where plan_code = p_plan);
*/
   -- �ֿ����ڲ���
   select org_code into v_wh_org from wh_info where warehouse_code = p_warehouse;

   /********************************************************************************************************************************************************************/
   /******************* ��������Ϊ���½���ʱ�����¡����������ջ���Ϣ��������Ҫ���롰״̬������״̬������Ϊ���ѷ���������������ⵥ�� *************************/
   if p_oper_type = 1 then
      -- ���¡����������ջ���Ϣ
      update sale_return_recoder
         set receive_org = v_wh_org,
             receive_wh = p_warehouse,
             receive_manager = p_oper,
             status = eorder_status.receiving
       where return_no = p_r_no
         and status = eorder_status.audited
      returning
         status, apply_tickets, apply_amount, market_manager_admin
      into
         v_count, v_plan_tickets, v_plan_amount, v_mm;
      if sql%rowcount = 0 then
         rollback;

         begin
            select status into v_count from sale_return_recoder where return_no = p_r_no;
         exception
            when no_data_found then
               c_errorcode := 24;
               c_errormesg := dbtool.format_line(p_r_no) || error_msg.err_p_rr_inbound_24; -- ��������Ų��Ϸ���δ��ѯ���˻�����
               return;
         end;

         c_errorcode := 5;
         c_errormesg := dbtool.format_line(p_r_no) || dbtool.format_line(v_count) || error_msg.err_p_rr_inbound_5; -- ������������ʱ��������״̬���Ϸ��������Ļ�����״̬Ӧ��Ϊ[������]
         return;
      end if;

      -- ��������ⵥ��
      insert into wh_goods_receipt
         (sgr_no,                      create_admin,              receipt_amount,
          receipt_tickets,             receipt_type,              ref_no,
          receive_wh,                  RECEIVE_ORG)
      values
         (f_get_wh_goods_receipt_seq,  p_oper,                    v_plan_amount,
          v_plan_tickets,              ereceipt_type.return_back, p_r_no,
          p_warehouse,                 v_wh_org)
      returning
         sgr_no
      into
         v_sgr_no;
   else
      -- ��ȡ��ⵥ���
      begin
         select sgr_no into v_sgr_no from wh_goods_receipt where ref_no = p_r_no;
      exception
         when no_data_found then
            rollback;
            c_errorcode := 6;
            c_errormesg := dbtool.format_line(p_r_no) || error_msg.err_p_tb_inbound_6; -- ���ܻ����ⵥ���
            return;
      end;

      -- ��ȡ�г�����Ա���
      begin
         select market_manager_admin, status
           into v_mm, v_count
           from sale_return_recoder
          where return_no = p_r_no;
      exception
         when no_data_found then
            rollback;
            c_errorcode := 24;
            c_errormesg := dbtool.format_line(p_r_no) || error_msg.err_p_rr_inbound_24; -- ��������Ų��Ϸ���δ��ѯ���˻�����
            return;
      end;

      if v_count <> eorder_status.receiving then
         rollback;
         c_errorcode := 15;
         c_errormesg := dbtool.format_line(p_r_no) || dbtool.format_line(v_count) || error_msg.err_p_rr_inbound_15; -- �������������ʱ��������״̬���Ϸ��������Ļ�����״̬Ӧ��Ϊ[������]
      end if;

   end if;

   /********************************************************************************************************************************************************************/
   /******************* ���������ϸ�����¡�����Ʊ��Ϣ�����и�����������ԣ�ͬʱͳ�Ʋ�Ʊͳ����Ϣ *************************/

   -- ��ʼ������
   v_insert_detail := type_detail();
   v_total_tickets := 0;

   -- ������ϸ���ݣ����¡�����Ʊ��״̬
   p_ticket_perferm(p_array_lotterys, p_oper, eticket_status.in_mm, eticket_status.in_warehouse, v_mm, p_warehouse, v_err_code, v_err_msg);
   if v_err_code <> 0 then
      rollback;
      c_errorcode := 1;
      c_errormesg := error_msg.err_common_104 || v_err_msg; -- ���¡�����Ʊ��״̬ʱ�����ִ���
      return;
   end if;

   -- ͳ���������Ʊ����
   p_lottery_detail_stat(p_array_lotterys, v_detail_list, v_stat_list, v_total_tickets, v_total_amount);

   -- ���������ϸ
   for v_list_count in 1 .. v_detail_list.count loop
      v_insert_detail.extend;
      v_insert_detail(v_list_count).sgr_no := v_sgr_no;
      v_insert_detail(v_list_count).ref_no := p_r_no;
      v_insert_detail(v_list_count).sequence_no := f_get_wh_goods_receipt_det_seq;
      v_insert_detail(v_list_count).receipt_type := ereceipt_type.return_back;

      v_insert_detail(v_list_count).valid_number := v_detail_list(v_list_count).valid_number;
      v_insert_detail(v_list_count).plan_code := v_detail_list(v_list_count).plan_code;
      v_insert_detail(v_list_count).batch_no := v_detail_list(v_list_count).batch_no;
      v_insert_detail(v_list_count).amount := v_detail_list(v_list_count).amount;
      v_insert_detail(v_list_count).trunk_no := v_detail_list(v_list_count).trunk_no;
      v_insert_detail(v_list_count).box_no := v_detail_list(v_list_count).box_no;
      v_insert_detail(v_list_count).package_no := v_detail_list(v_list_count).package_no;
      v_insert_detail(v_list_count).tickets := v_detail_list(v_list_count).tickets;
   end loop;

   forall v_list_count in 1 .. v_insert_detail.count
      insert into wh_goods_receipt_detail values v_insert_detail(v_list_count);

   -- ѭ��ͳ�ƽ�������շ������Σ����¿��Ա���
   for v_loop_i in 1 .. v_stat_list.count loop

      -- ���²ֿ����Ա�����Ϣ����������������ⲻͬ��������ֿ����Ա��û�ж�Ӧ�������ο�������£��˴����εĲ�Ʊ
      update acc_mm_tickets
         set tickets = tickets - v_stat_list(v_loop_i).tickets,
             amount = amount - v_stat_list(v_loop_i).amount
       where market_admin = v_mm
         and plan_code = v_stat_list(v_loop_i).plan_code
         and batch_no = v_stat_list(v_loop_i).batch_no
      returning
         tickets, amount
      into
         v_temp_tickets, v_temp_amount;
      if sql%rowcount = 0 or v_temp_tickets < 0 or v_temp_amount < 0 then
         rollback;
         c_errorcode := 14;
         c_errormesg := dbtool.format_line(p_oper) || dbtool.format_line(v_stat_list(v_loop_i).plan_code) || dbtool.format_line(v_stat_list(v_loop_i).batch_no) || error_msg.err_p_ar_inbound_14; -- �ֿ����Ա�Ŀ���У�û�д˷��������εĿ����Ϣ
         return;
      end if;

   end loop;
   /********************************************************************************************************************************************************************/
   /******************* ���¡���ⵥ���ġ�ʵ�������ϼơ��͡�ʵ�����������,�����������ġ�ʵ�ʵ���Ʊ�����͡�ʵ�ʵ���Ʊ���漰����¼ *************************/
   update wh_goods_receipt
      set act_receipt_tickets = act_receipt_tickets + v_total_tickets,
          act_receipt_amount = act_receipt_amount + v_total_amount
    where sgr_no = v_sgr_no;

   update sale_return_recoder
      set act_tickets = act_tickets + v_total_tickets,
          act_amount = act_amount + v_total_amount
    where return_no = p_r_no;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
/

create or replace procedure p_his_gen_by_day (
   p_curr_date       date        default sysdate,
   p_maintance_mod   number      default 0
)
/****************************************************************/
   ------------------- ������ͳ�����ݣ�ÿ��0��ִ�У� -------------------
   ---- add by ����: 2015/10/14
   /*************************************************************/
is
   v_temp1        number(28);
   v_temp2        number(28);

   v_max_org_pay_flow char(24);

begin

   if p_maintance_mod = 0 then
      -- �����Ϣ
      insert into his_lottery_inventory
         (calc_date,
          plan_code,
          batch_no,
          reward_group,
          status,
          warehouse,
          tickets,
          amount)
         with total as
          (select to_char(p_curr_date - 1,'yyyy-mm-dd') calc_date,
                  plan_code,
                  batch_no,
                  reward_group,
                  tab.status,
                  nvl(current_warehouse, '[null]') warehouse,
                  sum(tickets_every_pack) tickets
             from wh_ticket_package tab
             join game_batch_import_detail
            using (plan_code, batch_no)
            group by plan_code,
                     batch_no,
                     reward_group,
                     tab.status,
                     nvl(current_warehouse, '[null]'))
         select calc_date,
                plan_code,
                batch_no,
                reward_group,
                status,
                to_char(warehouse),
                tickets,
                tickets * ticket_amount
           from total
           join game_plans
          using (plan_code);

      commit;

      -- վ���ʽ��ս�
      insert into his_agency_fund (calc_date, agency_code, flow_type, amount, be_account_balance, af_account_balance)
      with last_day as
       (select agency_code, af_account_balance be_account_balance
          from his_agency_fund
         where calc_date = to_char(p_curr_date - 2, 'yyyy-mm-dd')
           and flow_type = 0),
      this_day as
       (select agency_code, account_balance af_account_balance
          from acc_agency_account
         where acc_type = 1),
      now_fund as
       (select agency_code, flow_type, sum(change_amount) as amount
          from flow_agency
         where trade_time >= trunc(p_curr_date - 1)
           and trade_time < trunc(p_curr_date)
         group by agency_code, flow_type),
      agency_balance as
       (select agency_code, be_account_balance, 0 as af_account_balance from last_day
         union all
        select agency_code, 0 as be_account_balance, af_account_balance from this_day),
      ab as
       (select agency_code, sum(be_account_balance) be_account_balance, sum(af_account_balance) af_account_balance from agency_balance group by agency_code)
      select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
             agency_code,
             flow_type,
             amount,
             0 be_account_balance,
             0 af_account_balance
        from now_fund
      union all
      select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
             agency_code,
             0,
             0,
             be_account_balance,
             af_account_balance
        from ab;

      commit;
   end if;

   -- վ�����ս�
   insert into his_agency_inv
     (calc_date, agency_code, plan_code, oper_type, amount, tickets)
   with base as (
   -- վ���˻�
   select SEND_WH agency_code,plan_code,10 inv_type,sum(AMOUNT) amount, sum(TICKETS) tickets
     from WH_GOODS_ISSUE mm join WH_GOODS_ISSUE_detail detail using(SGI_NO)
    where detail.ISSUE_TYPE = 4
      and ISSUE_END_TIME >= trunc(p_curr_date) - 1
      and ISSUE_END_TIME < trunc(p_curr_date)
   group by SEND_WH,plan_code
   union all
   -- վ���ջ�
   select RECEIVE_WH,plan_code,20 inv_type,sum(AMOUNT) amount, sum(TICKETS) tickets
    from WH_GOODS_RECEIPT mm join WH_GOODS_RECEIPT_detail detail using(sgr_no)
    where detail.RECEIPT_TYPE = 4
      and RECEIPT_END_TIME >= trunc(p_curr_date) - 1
      and RECEIPT_END_TIME < trunc(p_curr_date)
   group by RECEIVE_WH,plan_code
   union all
   -- վ���ڳ�
   select WAREHOUSE,plan_code,88 inv_type,sum(AMOUNT) amount, sum(TICKETS) tickets
     from HIS_LOTTERY_INVENTORY
    where STATUS = 31
      and CALC_DATE = to_char(trunc(p_curr_date) - 2,'yyyy-mm-dd')
   group by WAREHOUSE,plan_code
   union all
   -- վ����ĩ
   select WAREHOUSE,plan_code,99 inv_type,sum(AMOUNT) amount, sum(TICKETS) tickets
     from HIS_LOTTERY_INVENTORY
    where STATUS = 31
      and CALC_DATE = to_char(trunc(p_curr_date) - 1,'yyyy-mm-dd')
   group by WAREHOUSE,plan_code)
   select to_char(trunc(p_curr_date) - 1,'yyyy-mm-dd'),agency_code, plan_code, inv_type, amount, tickets from base;

   commit;

   -- ���������ż��
   insert into his_sale_org (calc_date, org_code, plan_code, sale_amount, sale_comm, cancel_amount, cancel_comm, paid_amount, paid_comm, incoming)
   with time_con as
    (select (trunc(p_curr_date) - 1) s_time, trunc(p_curr_date) e_time from dual),
   sale_stat as
    (select org_code,
            plan_code,
            sum(sale_amount) sale_amount,
            sum(COMM_AMOUNT) sale_comm
       from flow_sale, time_con
      where sale_time >= s_time
        and sale_time < e_time
      group by org_code, plan_code),
   cancel_stat as
    (select org_code,
            plan_code,
            sum(sale_amount) cancel_amount,
            sum(COMM_AMOUNT) cancel_comm
       from flow_cancel, time_con
      where cancel_time >= s_time
        and cancel_time < e_time
      group by org_code, plan_code),
   pay_stat as
    (select f_get_flow_pay_org(PAY_FLOW) org_code,
            plan_code,
            nvl(sum(PAY_AMOUNT),0) PAY_AMOUNT,
            nvl(sum(PAY_COMM),0) PAY_COMM
       from flow_pay, time_con
      where PAY_TIME >= s_time
        and PAY_TIME < e_time
      group by f_get_flow_pay_org(PAY_FLOW), plan_code),
   pre_detail as
    (select org_code,
            plan_code,
            sale_amount,
            sale_comm,
            0           as cancel_amount,
            0           as cancel_comm,
            0           as PAY_AMOUNT,
            0           as PAY_COMM
       from sale_stat
     union all
     select org_code,
            plan_code,
            0             as sale_amount,
            0             as sale_comm,
            cancel_amount,
            cancel_comm,
            0             as PAY_AMOUNT,
            0             as PAY_COMM
       from cancel_stat
     union all
     select org_code,
            plan_code,
            0          as sale_amount,
            0          as sale_comm,
            0          as cancel_amount,
            0          as cancel_comm,
            PAY_AMOUNT,
            PAY_COMM
       from pay_stat)
   select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
          org_code,
          plan_code,
          sum(sale_amount) sale_amount,
          sum(sale_comm) sale_comm,
          sum(cancel_amount) cancel_amount,
          sum(cancel_comm) cancel_comm,
          sum(PAY_AMOUNT) PAY_AMOUNT,
          sum(PAY_COMM) PAY_COMM,
          sum(sale_amount - sale_comm - PAY_AMOUNT - PAY_COMM - cancel_amount +
              cancel_comm) incoming
     from pre_detail
    group by org_code, plan_code;

   commit;

   -- 3.17.1.1  �����ʽ𱨱�Institution Fund Reports��
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
       pay_up,center_pay,center_pay_comm)
   with base as
    (select org_code,
            FLOW_TYPE,
            sum(AMOUNT) as amount,
            sum(BE_ACCOUNT_BALANCE) as BE_ACCOUNT_BALANCE,
            sum(AF_ACCOUNT_BALANCE) as AF_ACCOUNT_BALANCE
       from his_agency_fund
       join inf_agencys
      using (agency_code)
      where CALC_DATE = to_char(p_curr_date - 1, 'yyyy-mm-dd')
      group by org_code, FLOW_TYPE),
   center_pay_comm as
    (select f_get_flow_pay_org(PAY_FLOW) org_code,
            21 FLOW_TYPE,
            sum(PAY_AMOUNT * (case
                  when f_get_org_comm_rate(f_get_flow_pay_org(PAY_FLOW),
                                           plan_code,
                                           batch_no,
                                           2) = -1 then
                   0
                  else
                   f_get_org_comm_rate(f_get_flow_pay_org(PAY_FLOW),
                                       plan_code,
                                       batch_no,
                                       2)
                end) / 1000) AMOUNT
       from flow_pay
      where IS_CENTER_PAID = 1
        and PAY_TIME >= trunc(p_curr_date) - 1
        and PAY_TIME < trunc(p_curr_date)
        and '1' = f_get_sys_param('16')
        and f_get_flow_pay_org(PAY_FLOW) in (select ORG_CODE from INF_ORGS where ORG_TYPE = 2)
      group by f_get_flow_pay_org(PAY_FLOW)),
   center_pay as
    (select f_get_flow_pay_org(PAY_FLOW) org_code,
            20 FLOW_TYPE,
            sum(PAY_AMOUNT) AMOUNT
       from flow_pay
      where IS_CENTER_PAID = 1
        and PAY_TIME >= trunc(p_curr_date) - 1
        and PAY_TIME < trunc(p_curr_date)
      group by f_get_flow_pay_org(PAY_FLOW)),
   fund as
    (select *
       from (select org_code, FLOW_TYPE, AMOUNT from base
             union all
             select org_code, FLOW_TYPE, AMOUNT from center_pay_comm
             union all
             select org_code, FLOW_TYPE, AMOUNT from center_pay) pivot(sum(amount) for FLOW_TYPE in(1 as charge,
                                                                   2 as
                                                                   withdraw,
                                                                   5 as
                                                                   sale_comm,
                                                                   6 as
                                                                   pay_comm,
                                                                   7 as sale,
                                                                   8 as paid,
                                                                   11 as rtv,
                                                                   13 as
                                                                   rtv_comm,
                                                                   20 as
                                                                   center_pay,
                                                                   21 as
                                                                   center_pay_comm))),
   agency_ava as
    (select org_code, BE_ACCOUNT_BALANCE, AF_ACCOUNT_BALANCE
       from base
      where flow_type = 0),
   pre_detail as
    (select org_code,
            nvl(be_account_balance, 0) be_account_balance,
            nvl(charge, 0) charge,
            nvl(withdraw, 0) withdraw,
            nvl(sale, 0) sale,
            nvl(sale_comm, 0) sale_comm,
            nvl(paid, 0) paid,
            nvl(pay_comm, 0) pay_comm,
            nvl(rtv, 0) rtv,
            nvl(rtv_comm, 0) rtv_comm,
            nvl(center_pay, 0) center_pay,
            nvl(center_pay_comm, 0) center_pay_comm,
            nvl(af_account_balance, 0) af_account_balance
       from fund
       join agency_ava
      using (org_code))
   select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
          org_code,
          BE_ACCOUNT_BALANCE,
          charge,
          withdraw,
          sale,
          sale_comm,
          paid,
          pay_comm,
          rtv,
          rtv_comm,
          AF_ACCOUNT_BALANCE,
          (sale - sale_comm - paid - pay_comm - rtv + rtv_comm - center_pay - center_pay_comm) incoming,
          (sale - sale_comm - paid - pay_comm - rtv + rtv_comm - center_pay - center_pay_comm + af_account_balance - be_account_balance) pay_up,
          center_pay,
          center_pay_comm
     from pre_detail;

    commit;

    if p_maintance_mod = 0 then
       -- ����Ա�ʽ��ս�
       insert into HIS_MM_FUND (calc_date, MARKET_ADMIN, flow_type, amount, be_account_balance, af_account_balance)
         with last_day as
          (select MARKET_ADMIN, af_account_balance be_account_balance
             from his_mm_fund
            where calc_date = to_char(p_curr_date - 2, 'yyyy-mm-dd')
              and flow_type = 0),
         this_day as
          (select MARKET_ADMIN, account_balance af_account_balance
             from acc_mm_account
            where acc_type = 1),
         mm_balance as
          (select MARKET_ADMIN, be_account_balance, 0 as af_account_balance
             from last_day
           union all
           select MARKET_ADMIN, 0 as be_account_balance, af_account_balance
             from this_day),
         mb as
          (select MARKET_ADMIN,
                  sum(be_account_balance) be_account_balance,
                  sum(af_account_balance) af_account_balance
             from mm_balance
            group by MARKET_ADMIN),
         now_fund as
          (select MARKET_ADMIN, flow_type, sum(change_amount) as amount
             from flow_market_manager
            where trade_time >= trunc(p_curr_date - 1)
              and trade_time < trunc(p_curr_date)
            group by MARKET_ADMIN, flow_type)
         select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
                MARKET_ADMIN,
                flow_type,
                amount,
                0 be_account_balance,
                0 af_account_balance
           from now_fund
         union all
         select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
                MARKET_ADMIN,
                0,
                0,
                be_account_balance,
                af_account_balance
           from mb;

      commit;
   end if;

   -- ����Ա����ս�
   insert into HIS_MM_INVENTORY (CALC_DATE, MARKET_ADMIN, PLAN_CODE, OPEN_INV, CLOSE_INV, GOT_TICKETS, SALED_TICKETS, CANCELED_TICKETS, RETURN_TICKETS, BROKEN_TICKETS)
      with
      -- �ڳ�
      open_inv as
       (select WAREHOUSE MARKET_ADMIN, PLAN_CODE, sum(TICKETS) open_INV
          from HIS_LOTTERY_INVENTORY
         where CALC_DATE = to_char(trunc(p_curr_date) - 2, 'yyyy-mm-dd')
           and status = 21
         group by WAREHOUSE, PLAN_CODE),
      -- ��ĩ
      close_inv as
       (select WAREHOUSE MARKET_ADMIN, PLAN_CODE, sum(TICKETS) CLOSE_INV
          from HIS_LOTTERY_INVENTORY
         where CALC_DATE = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
           and status = 21
         group by WAREHOUSE, PLAN_CODE),
      -- �ջ�
      got as
       (select apply_admin, plan_code, sum(detail.tickets) TICKETS
          from SALE_DELIVERY_ORDER mm
          join wh_goods_issue_detail detail
            on (mm.do_no = detail.ref_no)
         where status = 4
           and OUT_DATE >= trunc(p_curr_date - 1)
           and OUT_DATE < trunc(p_curr_date)
         group by apply_admin, plan_code),
      -- ����
      saled as
       (select AR_ADMIN, plan_code, sum(detail.TICKETS) TICKETS
          from SALE_AGENCY_RECEIPT mm
          join wh_goods_receipt_detail detail
            on (mm.AR_NO = detail.ref_no)
         where AR_DATE >= trunc(p_curr_date - 1)
           and AR_DATE < trunc(p_curr_date)
         group by AR_ADMIN, plan_code),
      -- �˻�
      canceled as
       (select AI_MM_ADMIN, plan_code, sum(detail.TICKETS) TICKETS
          from SALE_AGENCY_RETURN mm
          join wh_goods_issue_detail detail
            on (mm.AI_NO = detail.ref_no)
         where Ai_DATE >= trunc(p_curr_date - 1)
           and Ai_DATE < trunc(p_curr_date)
         group by AI_MM_ADMIN, plan_code),
      -- ����
      returned as
       (select MARKET_MANAGER_ADMIN, plan_code, sum(detail.TICKETS) TICKETS
          from SALE_RETURN_RECODER mm
          join wh_goods_receipt_detail detail
            on (mm.RETURN_NO = detail.ref_no)
         where status = 6
           and RECEIVE_DATE >= trunc(p_curr_date - 1)
           and RECEIVE_DATE < trunc(p_curr_date)
         group by MARKET_MANAGER_ADMIN, plan_code),
      -- ���
      broken_detail as
       (select BROKEN_NO,
               plan_code,
               PACKAGES * (select TICKETS_EVERY_PACK
                             from GAME_BATCH_IMPORT_DETAIL
                            where plan_code = tt.plan_code
                              and batch_no = tt.batch_no) tickets
          from WH_BROKEN_RECODER_DETAIL tt),
      broken as
       (select APPLY_ADMIN, plan_code, sum(TICKETS) TICKETS
          from WH_BROKEN_RECODER
          join broken_detail
         using (BROKEN_NO)
         where APPLY_DATE >= trunc(p_curr_date - 1)
           and APPLY_DATE < trunc(p_curr_date)
         group by APPLY_ADMIN, plan_code),
      total_detail as
       (select apply_admin MARKET_ADMIN,
               plan_code,
               0           as open_inv,
               0           as CLOSE_INV,
               TICKETS     GOT_TICKETS,
               0           as SALED_TICKETS,
               0           as canceled_tickets,
               0           as RETURN_TICKETS,
               0           as BROKEN_TICKETS
          from got
        union all
        select AR_ADMIN  MARKET_ADMIN,
               plan_code,
               0         as open_inv,
               0         as CLOSE_INV,
               0         as GOT_TICKETS,
               TICKETS   as SALED_TICKETS,
               0         as canceled_tickets,
               0         as RETURN_TICKETS,
               0         as BROKEN_TICKETS
          from saled
        union all
        select AI_MM_ADMIN MARKET_ADMIN,
               plan_code,
               0           as open_inv,
               0           as CLOSE_INV,
               0           as GOT_TICKETS,
               0           as SALED_TICKETS,
               tickets     as canceled_tickets,
               0           as RETURN_TICKETS,
               0           as BROKEN_TICKETS
          from canceled
        union all
        select MARKET_MANAGER_ADMIN MARKET_ADMIN,
               plan_code,
               0                    as open_inv,
               0                    as CLOSE_INV,
               0                    as GOT_TICKETS,
               0                    as SALED_TICKETS,
               0                    as canceled_tickets,
               TICKETS              as RETURN_TICKETS,
               0                    as BROKEN_TICKETS
          from returned
        union all
        select APPLY_ADMIN MARKET_ADMIN,
               plan_code,
               0           as open_inv,
               0           as CLOSE_INV,
               0           as GOT_TICKETS,
               0           as SALED_TICKETS,
               0           as canceled_tickets,
               0           as RETURN_TICKETS,
               TICKETS     as BROKEN_TICKETS
          from broken
        union all
        select to_number(MARKET_ADMIN) MARKET_ADMIN,
               PLAN_CODE,
               open_inv,
               0 as CLOSE_INV,
               0 as GOT_TICKETS,
               0 as SALED_TICKETS,
               0 as canceled_tickets,
               0 as RETURN_TICKETS,
               0 as BROKEN_TICKETS
          from open_inv
        union all
        select to_number(MARKET_ADMIN) MARKET_ADMIN,
               PLAN_CODE,
               0 as open_inv,
               CLOSE_INV,
               0 as GOT_TICKETS,
               0 as SALED_TICKETS,
               0 as canceled_tickets,
               0 as RETURN_TICKETS,
               0 as BROKEN_TICKETS
          from close_inv),
      total_sum as
       (select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
               MARKET_ADMIN,
               PLAN_CODE,
               sum(open_inv) as open_inv,
               sum(CLOSE_INV) as CLOSE_INV,
               sum(GOT_TICKETS) GOT_TICKETS,
               sum(SALED_TICKETS) as SALED_TICKETS,
               sum(canceled_tickets) as canceled_tickets,
               sum(RETURN_TICKETS) as RETURN_TICKETS,
               sum(BROKEN_TICKETS) as BROKEN_TICKETS
          from total_detail
         group by MARKET_ADMIN, PLAN_CODE)
      -- ������ԱΪ�г�����Ա
      select * from total_sum where exists(select 1 from INF_MARKET_ADMIN where MARKET_ADMIN = total_sum.MARKET_ADMIN);

   commit;

   if p_maintance_mod = 0 then
      -- ���ֹ�˾��Ӷ��
      for itab in ( with proxy as
                      (
                       -- ����˾
                       select ORG_CODE from INF_ORGS where ORG_TYPE = 2),
                     agencys as
                      (select agency_code, org_code
                         from inf_agencys
                        where ORG_CODE in (select ORG_CODE from proxy)),
                     all_fund as
                      (select AGENCY_CODE,
                              1 fund_type,
                              f_get_old_plan_name(plan_code,batch_no) plan_code,
                              COMM_RATE,
                              sum(SALE_AMOUNT) amount,
                              sum(COMM_AMOUNT) comm
                         from FLOW_SALE
                         join agencys
                        using (AGENCY_CODE)
                        where SALE_TIME >= p_curr_date - 1
                          and SALE_TIME < trunc(p_curr_date)
                        group by AGENCY_CODE, COMM_RATE, f_get_old_plan_name(plan_code,batch_no)
                       union all
                       select AGENCY_CODE,
                              2 fund_type,
                              f_get_old_plan_name(plan_code,batch_no) plan_code,
                              COMM_RATE,
                              sum(SALE_AMOUNT) amount,
                              sum(COMM_AMOUNT) comm
                         from FLOW_CANCEL
                         join agencys
                        using (AGENCY_CODE)
                        where CANCEL_TIME >= p_curr_date - 1
                          and CANCEL_TIME < trunc(p_curr_date)
                        group by AGENCY_CODE, COMM_RATE, f_get_old_plan_name(plan_code,batch_no)
                       union all
                       select AGENCY_CODE,
                              3 fund_type,
                              f_get_old_plan_name(plan_code,batch_no) plan_code,
                              COMM_RATE,
                              sum(PAY_AMOUNT) amount,
                              sum(COMM_AMOUNT) comm
                         from FLOW_PAY
                         join agencys
                           on (agencys.AGENCY_CODE = FLOW_PAY.PAY_AGENCY)
                        where PAY_TIME >= p_curr_date - 1
                          and PAY_TIME < trunc(p_curr_date)
                        group by AGENCY_CODE, COMM_RATE, f_get_old_plan_name(plan_code,batch_no)),
                     data_flow as
                      (select *
                         from all_fund
                       pivot(sum(amount) amount, sum(comm) comm, sum(comm_rate) rate
                          for fund_type in(1 as sale, 2 as cancel, 3 as pay))),
                     base as
                      (select agency_code,
                              plan_code,
                              agencys.ORG_CODE,
                              case when f_get_org_comm_rate_by_name(agencys.ORG_CODE,data_flow.plan_code,1) = -1 then 0 else f_get_org_comm_rate_by_name(agencys.ORG_CODE,data_flow.plan_code,1) end o_sale_rate,
                              case when f_get_org_comm_rate_by_name(agencys.ORG_CODE,data_flow.plan_code,2) = -1 then 0 else f_get_org_comm_rate_by_name(agencys.ORG_CODE,data_flow.plan_code,2) end o_pay_rate,
                              nvl(SALE_AMOUNT, 0) SALE_AMOUNT,
                              nvl(SALE_comm, 0) SALE_comm,
                              nvl(SALE_RATE, 0) SALE_RATE,
                              nvl(CANCEL_AMOUNT, 0) CANCEL_AMOUNT,
                              nvl(CANCEL_comm, 0) CANCEL_comm,
                              nvl(CANCEL_RATE, 0) CANCEL_RATE,
                              nvl(PAY_AMOUNT, 0) PAY_AMOUNT,
                              nvl(PAY_comm, 0) PAY_comm,
                              nvl(PAY_RATE, 0) PAY_RATE
                         from data_flow
                         join agencys
                      using (agency_code)),
                     to_be_insert as (
                     select ORG_CODE,
                            AGENCY_CODE,
                            plan_code,
                            SALE_RATE,
                            CANCEL_RATE,
                            PAY_RATE,
                            o_sale_rate,
                            o_pay_rate,
                            sum(SALE_AMOUNT) SALE_AMOUNT,
                            sum(CANCEL_AMOUNT) CANCEL_AMOUNT,
                            sum(PAY_AMOUNT) PAY_AMOUNT
                       from base
                      group by ORG_CODE,
                               AGENCY_CODE,
                               plan_code,
                               SALE_RATE,
                               CANCEL_RATE,
                               PAY_RATE,
                               o_sale_rate,
                               o_pay_rate)
                     select ORG_CODE,
                            sum((SALE_AMOUNT - CANCEL_AMOUNT) * (o_sale_rate - SALE_RATE)/1000 + PAY_AMOUNT * (o_pay_rate - PAY_RATE)/1000) amount
                       from to_be_insert
                       join ACC_AGENCY_ACCOUNT
                       using (AGENCY_CODE)
                       group by ORG_CODE
                  ) loop

         -- �ֹ�˾��Ǯ
         p_org_fund_change(itab.org_code, eflow_type.org_comm, itab.amount, 0, 'RZ'||to_char(p_curr_date,'yyyymmdd'), v_temp1, v_temp2);

         -- ��ȡ�ʽ���ˮ����¼��
         select max(ORG_FUND_FLOW)
           into v_max_org_pay_flow
           from FLOW_ORG
          where org_code = itab.org_code;

         -- ������ϸ����
         insert into FLOW_ORG_COMM_DETAIL
            (ORG_FUND_COMM_FLOW, ORG_FUND_FLOW, AGENCY_CODE, PLAN_NAME, ACC_NO, ORG_CODE,
             TRADE_AMOUNT,
             AGENCY_SALE_AMOUNT, ORG_SALE_COMM,
             AGENCY_SALE_COMM_RATE, ORG_SALE_COMM_RATE,
             AGENCY_CANCEL_AMOUNT, ORG_CANCEL_COMM,
             AGENCY_CANCEL_COMM_RATE, ORG_CANCEL_COMM_RATE,
             AGENCY_PAY_AMOUNT, ORG_PAY_AMOUNT,
             AGENCY_PAY_COMM_RATE, ORG_PAY_COMM_RATE)
               with proxy as
                (
                 -- ����˾
                 select ORG_CODE from INF_ORGS where ORG_TYPE = 2),
               agencys as
                (select agency_code, org_code
                   from inf_agencys
                  where ORG_CODE in (select ORG_CODE from proxy)),
               all_fund as (
                  -- ����
                  select AGENCY_CODE,
                        1 fund_type,
                        f_get_old_plan_name(plan_code,batch_no) plan_code,
                        COMM_RATE,
                        sum(SALE_AMOUNT) amount,
                        sum(COMM_AMOUNT) comm
                   from FLOW_SALE
                   join agencys
                  using (AGENCY_CODE)
                  where SALE_TIME >= p_curr_date - 1
                    and SALE_TIME < trunc(p_curr_date)
                  group by AGENCY_CODE, COMM_RATE, f_get_old_plan_name(plan_code,batch_no)
                  union all
                  -- ��Ʊ
                  select AGENCY_CODE,
                        2 fund_type,
                        f_get_old_plan_name(plan_code,batch_no) plan_code,
                        COMM_RATE,
                        sum(SALE_AMOUNT) amount,
                        sum(COMM_AMOUNT) comm
                   from FLOW_CANCEL
                   join agencys
                  using (AGENCY_CODE)
                  where CANCEL_TIME >= p_curr_date - 1
                    and CANCEL_TIME < trunc(p_curr_date)
                  group by AGENCY_CODE, COMM_RATE, f_get_old_plan_name(plan_code,batch_no)
                  union all
                  -- �ҽ�
                  select AGENCY_CODE,
                        3 fund_type,
                        f_get_old_plan_name(plan_code,batch_no) plan_code,
                        COMM_RATE,
                        sum(PAY_AMOUNT) amount,
                        sum(COMM_AMOUNT) comm
                   from FLOW_PAY
                   join agencys
                     on (agencys.AGENCY_CODE = FLOW_PAY.PAY_AGENCY)
                  where PAY_TIME >= p_curr_date - 1
                    and PAY_TIME < trunc(p_curr_date)
                  group by AGENCY_CODE, COMM_RATE, f_get_old_plan_name(plan_code,batch_no)),
               data_flow as ��
                  select *
                    from all_fund
                   pivot (sum(amount) amount, sum(comm) comm, sum(comm_rate) rate
                          for fund_type in(1 as sale, 2 as cancel, 3 as pay))),
               base as ��
                  select agency_code,
                        plan_code,
                        agencys.ORG_CODE,
                        case when f_get_org_comm_rate_by_name(agencys.ORG_CODE,data_flow.plan_code,1) = -1 then 0 else f_get_org_comm_rate_by_name(agencys.ORG_CODE,data_flow.plan_code,1) end o_sale_rate,
                        case when f_get_org_comm_rate_by_name(agencys.ORG_CODE,data_flow.plan_code,2) = -1 then 0 else f_get_org_comm_rate_by_name(agencys.ORG_CODE,data_flow.plan_code,2) end o_pay_rate,
                        nvl(SALE_AMOUNT, 0) SALE_AMOUNT,
                        nvl(SALE_comm, 0) SALE_comm,
                        nvl(SALE_RATE, 0) SALE_RATE,
                        nvl(CANCEL_AMOUNT, 0) CANCEL_AMOUNT,
                        nvl(CANCEL_comm, 0) CANCEL_comm,
                        nvl(CANCEL_RATE, 0) CANCEL_RATE,
                        nvl(PAY_AMOUNT, 0) PAY_AMOUNT,
                        nvl(PAY_comm, 0) PAY_comm,
                        nvl(PAY_RATE, 0) PAY_RATE
                   from data_flow
                   join agencys
                  using (agency_code)),
               to_be_insert as (
               select ORG_CODE,
                      AGENCY_CODE,
                      plan_code,
                      SALE_RATE,
                      CANCEL_RATE,
                      PAY_RATE,
                      o_sale_rate,
                      o_pay_rate,
                      sum(SALE_AMOUNT) SALE_AMOUNT,
                      sum(CANCEL_AMOUNT) CANCEL_AMOUNT,
                      sum(PAY_AMOUNT) PAY_AMOUNT
                 from base
                group by ORG_CODE,
                         AGENCY_CODE,
                         plan_code,
                         SALE_RATE,
                         CANCEL_RATE,
                         PAY_RATE,
                         o_sale_rate,
                         o_pay_rate)
         select v_max_org_pay_flow, f_get_comm_flow_org_seq, AGENCY_CODE,plan_code, ACC_NO,ORG_CODE,
                ((SALE_AMOUNT - CANCEL_AMOUNT) * (o_sale_rate - SALE_RATE)/1000 + PAY_AMOUNT * (o_pay_rate - PAY_RATE)/1000),
                SALE_AMOUNT, SALE_AMOUNT * (o_sale_rate - SALE_RATE)/1000,
                SALE_RATE, o_sale_rate,
                CANCEL_AMOUNT, CANCEL_AMOUNT * (o_sale_rate - CANCEL_RATE)/1000,
                CANCEL_RATE, o_sale_rate,
                PAY_AMOUNT, PAY_AMOUNT * (o_pay_rate - PAY_RATE)/1000,
                PAY_RATE, o_pay_rate
           from to_be_insert
           join ACC_AGENCY_ACCOUNT
           using (AGENCY_CODE)
          where org_code = itab.org_code;

      end loop;

      commit;
   end if;

   -- 3.17.1.4  ����Ӧ�ɿ��Institution Payable Report��
   insert into his_org_fund
     (calc_date, org_code, charge, withdraw, center_paid, center_paid_comm, pay_up)
   with base as
    (select org_code, FLOW_TYPE, sum(AMOUNT) as amount
       from his_agency_fund
       join inf_agencys
      using (agency_code)
      where CALC_DATE = to_char(p_curr_date - 1, 'yyyy-mm-dd')
        and FLOW_TYPE in (1, 2)
      group by org_code, FLOW_TYPE),
   center_pay as
    (select f_get_flow_pay_org(PAY_FLOW) org_code, sum(PAY_AMOUNT) AMOUNT
       from flow_pay
      where PAY_TIME >= trunc(p_curr_date) - 1
        and PAY_TIME < trunc(p_curr_date)
        and IS_CENTER_PAID = 1
      group by f_get_flow_pay_org(PAY_FLOW)),
   center_pay_comm as
    (select f_get_flow_pay_org(PAY_FLOW) org_code,
            21 FLOW_TYPE,
            sum(PAY_AMOUNT * (case
                  when f_get_org_comm_rate(f_get_flow_pay_org(PAY_FLOW),
                                           plan_code,
                                           batch_no,
                                           2) = -1 then
                   0
                  else
                   f_get_org_comm_rate(f_get_flow_pay_org(PAY_FLOW),
                                       plan_code,
                                       batch_no,
                                       2)
                end) / 1000) AMOUNT
       from flow_pay
      where IS_CENTER_PAID = 1
        and PAY_TIME >= trunc(p_curr_date) - 1
        and PAY_TIME < trunc(p_curr_date)
        and '1' = f_get_sys_param('16')
        and f_get_flow_pay_org(PAY_FLOW) in (select ORG_CODE from INF_ORGS where ORG_TYPE = 2)
      group by f_get_flow_pay_org(PAY_FLOW)),
   fund as
    (select *
       from (select org_code, FLOW_TYPE, AMOUNT from base
             union all
             select org_code, 8 FLOW_TYPE, AMOUNT from center_pay
             union all
             select org_code, 21 FLOW_TYPE, AMOUNT from center_pay_comm
            ) pivot(sum(amount) for FLOW_TYPE in(1 as charge, 2 as withdraw, 8 as paid, 21 as paid_comm)))
   select to_char(p_curr_date - 1, 'yyyy-mm-dd') CALC_DATE,
          org_code,nvl(charge, 0) charge,
          nvl(withdraw, 0) withdraw,
          nvl(paid, 0) CENTER_PAID,
          nvl(paid_comm, 0) center_paid_comm,
          (nvl(charge, 0) - nvl(withdraw, 0) - nvl(paid, 0) + nvl(paid_comm, 0)) pay_up from inf_orgs left join fund using (org_code);

   commit;

   -- ���ſ���ս�
   insert into HIS_ORG_INV_REPORT (calc_date, org_code, oper_type, plan_code, amount, tickets)
   with base as (
      -- �������⡢վ���˻�
      select SEND_ORG org_code,wgid.ISSUE_TYPE do_type ,plan_code,sum(amount) amount, sum(tickets) tickets
        from WH_GOODS_ISSUE_DETAIL wgid
        join WH_GOODS_ISSUE wgi
       using (SGI_NO)
       where ISSUE_END_TIME >= trunc(p_curr_date) - 1
         and ISSUE_END_TIME < trunc(p_curr_date)
         and wgid.ISSUE_TYPE in (1,4)
         group by SEND_ORG,wgid.ISSUE_TYPE,plan_code
      union all
      -- ������⣬ȡ�ƻ������������Ҫ���ҵ���������Ȼ���ҵ���������Ӧ�ĳ��ⵥ����ȡʵ�ʳ�����ϸ��
      select wri.RECEIVE_ORG org_code, 12 do_type,plan_code,sum(wgid.amount) amount, sum(wgid.tickets) tickets
        from WH_GOODS_ISSUE_DETAIL wgid
        join SALE_TRANSFER_BILL stb
          on (wgid.REF_NO = stb.STB_NO)
        join WH_GOODS_receipt wri
          on (wri.REF_NO = stb.STB_NO)
       where receipt_END_TIME >= trunc(p_curr_date) - 1
         and receipt_END_TIME < trunc(p_curr_date)
         and (wri.receipt_TYPE = 2 or (wri.receipt_TYPE = 1 and wri.RECEIVE_ORG = '00'))
         group by wri.RECEIVE_ORG,wri.receipt_TYPE + 10,plan_code
      union all
      -- վ���������
      select RECEIVE_ORG org_code,wgid.receipt_TYPE + 10 do_type,plan_code,sum(amount) amount, sum(tickets) tickets
        from WH_GOODS_receipt_DETAIL wgid
        join WH_GOODS_receipt wgi
       using (SGR_NO)
       where receipt_END_TIME >= trunc(p_curr_date) - 1
         and receipt_END_TIME < trunc(p_curr_date)
         and wgid.receipt_TYPE = 4
         group by RECEIVE_ORG,wgid.receipt_TYPE + 10,plan_code
      union all
      -- ���
      select f_get_admin_org(APPLY_ADMIN) org_code, 20 do_type,PLAN_CODE,
             sum(amount) amount, sum(WH_BROKEN_RECODER_DETAIL.packages) * 100
        from WH_BROKEN_RECODER join WH_BROKEN_RECODER_DETAIL using(BROKEN_NO)
       where APPLY_DATE >= trunc(p_curr_date) - 1
         and APPLY_DATE < trunc(p_curr_date)
       group by f_get_admin_org(APPLY_ADMIN),PLAN_CODE
      union all
      -- �ڳ����
      select substr(WAREHOUSE,1,2) org_code,88 do_type,PLAN_CODE,sum(AMOUNT) AMOUNT,sum(TICKETS) TICKETS
        from HIS_LOTTERY_INVENTORY
       where calc_date = to_char(trunc(p_curr_date) - 2, 'yyyy-mm-dd')
         and STATUS = 11
       group by substr(WAREHOUSE,1,2),PLAN_CODE
      union all
      -- ��ĩ���
      select substr(WAREHOUSE,1,2) org_code,99 do_type,PLAN_CODE,sum(AMOUNT) AMOUNT,sum(TICKETS) TICKETS
        from HIS_LOTTERY_INVENTORY
       where calc_date = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
         and STATUS = 11
       group by substr(WAREHOUSE,1,2),PLAN_CODE
      union all
      select f_get_admin_org(market_admin) org, 66 do_type, PLAN_CODE,
             sum(OPEN_INV) * (select TICKET_AMOUNT from game_plans where plan_code = tt.plan_code),
             sum(OPEN_INV)
        from his_mm_inventory tt
       where calc_date = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
       group by f_get_admin_org(market_admin),plan_code
       union all
       select f_get_admin_org(market_admin) org, 77 do_type, PLAN_CODE,
              sum(CLOSE_INV) * (select TICKET_AMOUNT from game_plans where plan_code = tt.plan_code),
              sum(CLOSE_INV)
        from his_mm_inventory tt
       where calc_date = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
       group by f_get_admin_org(market_admin),plan_code
      )
   select to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd'), org_code, do_type, PLAN_CODE,amount, tickets from base;

   commit;

end;
/


truncate table HIS_ORG_INV_REPORT;

declare
    p_curr_date date;
begin
    for i in 1 .. 46 loop
        p_curr_date := trunc(sysdate) - i + 1;
        dbms_output.put_line(to_char(p_curr_date,'yyyy-mm-dd'));

        insert into HIS_ORG_INV_REPORT (calc_date, org_code, oper_type, plan_code, amount, tickets)
        with base as (
          -- �������⡢վ���˻�
          select SEND_ORG org_code,wgid.ISSUE_TYPE do_type ,plan_code,sum(amount) amount, sum(tickets) tickets
            from WH_GOODS_ISSUE_DETAIL wgid
            join WH_GOODS_ISSUE wgi
           using (SGI_NO)
           where ISSUE_END_TIME >= trunc(p_curr_date) - 1
             and ISSUE_END_TIME < trunc(p_curr_date)
             and wgid.ISSUE_TYPE in (1,4)
             group by SEND_ORG,wgid.ISSUE_TYPE,plan_code
          union all
          -- ������⣬ȡ�ƻ������������Ҫ���ҵ���������Ȼ���ҵ���������Ӧ�ĳ��ⵥ����ȡʵ�ʳ�����ϸ��
          select wri.RECEIVE_ORG org_code, 12 do_type,plan_code,sum(wgid.amount) amount, sum(wgid.tickets) tickets
            from WH_GOODS_ISSUE_DETAIL wgid
            join SALE_TRANSFER_BILL stb
              on (wgid.REF_NO = stb.STB_NO)
            join WH_GOODS_receipt wri
              on (wri.REF_NO = stb.STB_NO)
           where receipt_END_TIME >= trunc(p_curr_date) - 1
             and receipt_END_TIME < trunc(p_curr_date)
             and (wri.receipt_TYPE = 2 or (wri.receipt_TYPE = 1 and wri.RECEIVE_ORG = '00'))
             group by wri.RECEIVE_ORG,wri.receipt_TYPE + 10,plan_code
          union all
          -- վ���������
          select RECEIVE_ORG org_code,wgid.receipt_TYPE + 10 do_type,plan_code,sum(amount) amount, sum(tickets) tickets
            from WH_GOODS_receipt_DETAIL wgid
            join WH_GOODS_receipt wgi
           using (SGR_NO)
           where receipt_END_TIME >= trunc(p_curr_date) - 1
             and receipt_END_TIME < trunc(p_curr_date)
             and wgid.receipt_TYPE = 4
             group by RECEIVE_ORG,wgid.receipt_TYPE + 10,plan_code
          union all
          -- ���
          select f_get_admin_org(APPLY_ADMIN) org_code, 20 do_type,PLAN_CODE,
                 sum(amount) amount, sum(WH_BROKEN_RECODER_DETAIL.packages) * 100
            from WH_BROKEN_RECODER join WH_BROKEN_RECODER_DETAIL using(BROKEN_NO)
           where APPLY_DATE >= trunc(p_curr_date) - 1
             and APPLY_DATE < trunc(p_curr_date)
           group by f_get_admin_org(APPLY_ADMIN),PLAN_CODE
          union all
          -- �ڳ����
          select substr(WAREHOUSE,1,2) org_code,88 do_type,PLAN_CODE,sum(AMOUNT) AMOUNT,sum(TICKETS) TICKETS
            from HIS_LOTTERY_INVENTORY
           where calc_date = to_char(trunc(p_curr_date) - 2, 'yyyy-mm-dd')
             and STATUS = 11
           group by substr(WAREHOUSE,1,2),PLAN_CODE
          union all
          -- ��ĩ���
          select substr(WAREHOUSE,1,2) org_code,99 do_type,PLAN_CODE,sum(AMOUNT) AMOUNT,sum(TICKETS) TICKETS
            from HIS_LOTTERY_INVENTORY
           where calc_date = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
             and STATUS = 11
           group by substr(WAREHOUSE,1,2),PLAN_CODE
          union all
          select f_get_admin_org(market_admin) org, 66 do_type, PLAN_CODE,
                 sum(OPEN_INV) * (select TICKET_AMOUNT from game_plans where plan_code = tt.plan_code),
                 sum(OPEN_INV)
            from his_mm_inventory tt
           where calc_date = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
           group by f_get_admin_org(market_admin),plan_code
           union all
           select f_get_admin_org(market_admin) org, 77 do_type, PLAN_CODE,
                  sum(CLOSE_INV) * (select TICKET_AMOUNT from game_plans where plan_code = tt.plan_code),
                  sum(CLOSE_INV)
            from his_mm_inventory tt
           where calc_date = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
           group by f_get_admin_org(market_admin),plan_code
          )
        select to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd'), org_code, do_type, PLAN_CODE,amount, tickets from base;

     end loop;
end;
/
