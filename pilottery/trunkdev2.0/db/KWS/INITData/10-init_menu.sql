SET DEFINE OFF;

insert into ADM_PRIVILEGE values (120503, 'Inventory Check Inquiry', '12050300', 0, null, null, null, null, '库存盘点查询', '/inventory.do?method=listInventoryCheckInquiry', 1205, 3, 9);
insert into ADM_PRIVILEGE values (160502, 'No Sale Outlets Statistics', '16050200', 0, null, null, null, null, '未销售站点统计', '/analysis.do?method=getNoSaleOutlets', 1605, 3, 6);
insert into ADM_PRIVILEGE values (10, 'SALES', '10000000', 0, null, null, null, null, '销售管理', '#', 0, 1, 3);
insert into ADM_PRIVILEGE values (11, 'DATA', '11000000', 0, null, null, null, null, '数据维护', '#', 0, 1, 6);
insert into ADM_PRIVILEGE values (12, 'INVENTORY', '12000000', 0, null, null, null, null, '库存管理', '#', 0, 1, 9);
insert into ADM_PRIVILEGE values (13, 'PAYOUT', '13000000', 0, null, null, null, null, '兑奖', '#', 0, 1, 12);
insert into ADM_PRIVILEGE values (14, 'CAPITAL', '14000000', 0, null, null, null, null, '资金管理', '#', 0, 1, 15);
insert into ADM_PRIVILEGE values (15, 'MARKET MANAGER', '15000000', 0, null, null, null, null, '市场管理员账户', '#', 0, 1, 18);
insert into ADM_PRIVILEGE values (16, 'REPORT', '16000000', 0, null, null, null, null, '报表', '#', 0, 1, 21);
insert into ADM_PRIVILEGE values (17, 'OUTLET SERVICE', '17000000', 0, null, null, null, null, '站点服务', '#', 0, 1, 24);
insert into ADM_PRIVILEGE values (18, 'SYSTEM', '18000000', 0, null, null, null, null, '系统管理', '#', 0, 1, 27);
insert into ADM_PRIVILEGE values (19, 'MONITOR', '19000000', 0, null, null, null, null, '监控', '#', 0, 1, 26);
insert into ADM_PRIVILEGE values (1001, 'Purchase Order Apply', '10010000', 0, null, null, null, null, '订单申请', '/order.do?method=listOrderByApplyUser', 10, 2, 3);
insert into ADM_PRIVILEGE values (1002, 'Purchase Order Inquery', '10020000', 0, null, null, null, null, '订单查询', '/order.do?method=listOrderForInquery', 10, 2, 6);
insert into ADM_PRIVILEGE values (1003, 'Stock Transfer Apply', '10030000', 0, null, null, null, null, '调拨单申请', '/transfer.do?method=listTransferByApplyUser', 10, 2, 9);
insert into ADM_PRIVILEGE values (1004, 'Stock Transfer Approval', '10040000', 0, null, null, null, null, '调拨单审批', '/transfer.do?method=listTransferForInquery', 10, 2, 12);
insert into ADM_PRIVILEGE values (1005, 'Delivery Order Apply', '10050000', 0, null, null, null, null, '出货单申请', '/delivery.do?method=listDeliveryByApplyUser', 10, 2, 15);
insert into ADM_PRIVILEGE values (1006, 'Delivery Order Inquery', '10060000', 0, null, null, null, null, '出货单查询', '/delivery.do?method=listDeliveryForInquery', 10, 2, 18);
insert into ADM_PRIVILEGE values (1101, 'Administrative Areas', '11010000', 0, null, null, null, null, '行政区域管理', '/areas.do?method=listAreas', 11, 2, 3);
insert into ADM_PRIVILEGE values (1102, 'Institutions', '11020000', 0, null, null, null, null, '代理商管理', '/institutions.do?method=listInstitutions', 11, 2, 6);
insert into ADM_PRIVILEGE values (1103, 'Outlets', '11030000', 0, null, null, null, null, '站点管理', '/outlets.do?method=listOutlets', 11, 2, 9);
insert into ADM_PRIVILEGE values (1201, 'Plans', '12010000', 0, null, null, null, null, '方案管理', '/plans.do?method=listPlans', 12, 2, 3);
insert into ADM_PRIVILEGE values (1202, 'Warehouses', '12020000', 0, null, null, null, null, '仓库管理', '/warehouses.do?method=listWarehouses', 12, 2, 6);
insert into ADM_PRIVILEGE values (1203, 'Goods Receipts', '12030000', 0, null, null, null, null, '入库管理', '#', 12, 2, 9);
insert into ADM_PRIVILEGE values (120301, 'Goods Receipts Information', '12030100', 0, null, null, null, null, '入库查询', '/goodsReceipts.do?method=listGoodsReceipts', 1203, 3, 3);
insert into ADM_PRIVILEGE values (120302, 'Goods Receipt by Batch', '12030200', 0, null, null, null, null, '批次入库', '/goodsReceipts.do?method=receiptByBatch', 1203, 3, 6);
insert into ADM_PRIVILEGE values (120303, 'Goods Receipt by Stock Transfer', '12030300', 0, null, null, null, null, '调拨单入库', '/goodsReceipts.do?method=receiptByStockTransfer', 1203, 3, 9);
insert into ADM_PRIVILEGE values (120304, 'Goods Receipt by Return Delivery', '12030400', 0, null, null, null, null, '还货入库', '/goodsReceipts.do?method=receiptByRetrunDelevery', 1203, 3, 12);
insert into ADM_PRIVILEGE values (1204, 'Goods Issues', '12040000', 0, null, null, null, null, '出库管理', '#', 12, 2, 12);
insert into ADM_PRIVILEGE values (1205, 'Inventory', '12050000', 0, null, null, null, null, '库存管理', '#', 12, 2, 15);
insert into ADM_PRIVILEGE values (1206, 'Damaged Goods', '12060000', 0, null, null, null, null, '损毁管理', '/damagedGoods.do?method=listDamagedGoods', 12, 2, 18);
insert into ADM_PRIVILEGE values (1207, 'Logistics Information', '12070000', 0, null, null, null, null, '物流查询', '/logistics.do?method=initLogistics', 12, 2, 21);
insert into ADM_PRIVILEGE values (1208, 'Batch Termination', '12080000', 0, null, null, null, null, '批次终结', '/termination.do?method=initBathTermination', 12, 2, 24);
insert into ADM_PRIVILEGE values (1209, 'Item Maintenance', '12090000', 0, null, null, null, null, '物品管理', '#', 12, 2, 27);
insert into ADM_PRIVILEGE values (1301, 'Process Payout', '13010000', 0, null, null, null, null, '中心兑奖', '/payout.do?method=initProcessPayout', 13, 2, 3);
insert into ADM_PRIVILEGE values (1303, 'Payout Records', '13030000', 0, null, null, null, null, '兑奖查询', '/payout.do?method=listPayout', 13, 2, 9);
insert into ADM_PRIVILEGE values (1401, 'Institution Capital', '14010000', 0, null, null, null, null, '部门资金管理', '#', 14, 2, 3);
insert into ADM_PRIVILEGE values (140101, 'Top Ups', '14010100', 0, null, null, null, null, '充值', '/topUps.do?method=listTopUps', 1401, 3, 3);
insert into ADM_PRIVILEGE values (140102, 'Cash Withdrawn', '14010200', 0, null, null, null, null, '提现申请', '/orgsWithdrawnRecords.do?method=listRecords', 1401, 3, 6);
insert into ADM_PRIVILEGE values (140103, 'Account Balance', '14010300', 0, null, null, null, null, '账户余额', '/accountBalance.do?method=listAccountBalance', 1401, 3, 9);
insert into ADM_PRIVILEGE values (140104, 'Capital Record', '14010400', 0, null, null, null, null, '部门资金流水', '/capitalRecord.do?method=listCapitalRecords', 1401, 3, 1);
insert into ADM_PRIVILEGE values (1402, 'Account Maintenance', '14020000', 0, null, null, null, null, '资金账户管理', '#', 14, 2, 6);
insert into ADM_PRIVILEGE values (1403, 'Cash Withdrawn Approval', '14030000', 0, null, null, null, null, '提现管理', '/cashWithdrawn.do?method=listCashWithdrawn', 14, 2, 9);
insert into ADM_PRIVILEGE values (1404, 'Return Deliveries', '14040000', 0, null, null, null, null, '还货管理', '/return.do?method=listReturnDeliveries', 14, 2, 12);
insert into ADM_PRIVILEGE values (1405, 'Repayment', '14050000', 0, null, null, null, null, '还款管理', '/repayment.do?method=listRepayment', 14, 2, 15);
insert into ADM_PRIVILEGE values (1501, 'Return Delivery', '15010000', 0, null, null, null, null, '还货申请', '/returnDelivery.do?method=listReturnDeliveries', 15, 2, 3);
insert into ADM_PRIVILEGE values (1502, 'Inventory Information', '15020000', 0, null, null, null, null, '库存查询', '/repaymentRecord.do?method=listInventory', 15, 2, 6);
insert into ADM_PRIVILEGE values (1503, 'Register Damaged Goods', '15030000', 0, null, null, null, null, '损毁登记', '/damegeGood.do?method=initDamageGood', 15, 2, 9);
insert into ADM_PRIVILEGE values (1504, 'Account Balance', '15040000', 0, null, null, null, null, '账户余额查询', '/marketManagerBalance.do?method=queryAccountBalance', 15, 2, 12);
insert into ADM_PRIVILEGE values (1505, 'Repayment Records', '15050000', 0, null, null, null, null, '还款记录', '/repaymentRecord.do?method=listRepaymentRecords', 15, 2, 15);
insert into ADM_PRIVILEGE values (1506, 'MM Transaction Records', '15060000', 0, null, null, null, null, '市场管理员交易记录查询', '/transferRecord.do?method=listMMTransferRecords', 15, 2, 18);
insert into ADM_PRIVILEGE values (1601, 'Fund Report', '16010000', 0, null, null, null, null, '资金报表', '#', 16, 2, 3);
insert into ADM_PRIVILEGE values (1602, 'Sales Report', '16020000', 0, null, null, null, null, '销售报表', '#', 16, 2, 6);
insert into ADM_PRIVILEGE values (1603, 'Inventory Report', '16030000', 0, null, null, null, null, '库存报表', '#', 16, 2, 9);
insert into ADM_PRIVILEGE values (1604, 'Charts', '16040000', 0, null, null, null, null, '统计图表', '#', 16, 2, 12);
insert into ADM_PRIVILEGE values (160101, 'Inst Outlets Statistics', '16010100', 0, null, null, null, null, '部门站点统计', '/saleReport.do?method=institutionFundReport', 1601, 3, 3);
insert into ADM_PRIVILEGE values (160102, 'Outlet Fund Report', '16010200', 0, null, null, null, null, '站点资金报表', '/saleReport.do?method=outletFundReport', 1601, 3, 6);
insert into ADM_PRIVILEGE values (160103, 'Inst Outlets Statistics(USD)', '16010300', 0, null, null, null, null, '部门站点统计(美金)', '/saleReport.do?method=institutionFundReportUSD', 1601, 3, 9);
insert into ADM_PRIVILEGE values (160104, 'Outlet Fund Report(USD)', '16010400', 0, null, null, null, null, '站点资金报表(美元)', '/saleReport.do?method=outletFundReportUSD', 1601, 3, 12);
insert into ADM_PRIVILEGE values (160105, 'MM Capital Daliy Report', '16010500', 0, null, null, null, null, '市场管理员资金日结报表', '/saleReport.do?method=mmCapitalDaliyReport', 1601, 3, 15);
insert into ADM_PRIVILEGE values (160201, 'Sales Reports', '16020100', 0, null, null, null, null, '游戏销售报表', '/saleReport.do?method=initGameSalesReport', 1602, 3, 3);
insert into ADM_PRIVILEGE values (160202, 'Institution Sales Reports', '16020200', 0, null, null, null, null, '部门销售报表', '/saleReport.do?method=initInstitutionSalesReport', 1602, 3, 6);
insert into ADM_PRIVILEGE values (160203, 'Payout Reports', '16020300', 0, null, null, null, null, '兑奖报表', '/report.do?method=initPayoutReports', 1602, 3, 9);
insert into ADM_PRIVILEGE values (160301, 'Inventory Reports', '16030100', 0, null, null, null, null, '库存报表', '/saleReport.do?method=initInventoryReports', 1603, 3, 3);
insert into ADM_PRIVILEGE values (160302, 'MM Inventory Daliy Report', '16030200', 0, null, null, null, null, '市场管理员库存日结报表', '/saleReport.do?method=mmInventoryDaliyReport', 1603, 3, 6);
insert into ADM_PRIVILEGE values (160401, 'Institution Sales', '16040100', 0, null, null, null, null, '部门监控统计', '/monitor.do?method=institutionSales', 1604, 3, 3);
insert into ADM_PRIVILEGE values (160402, 'Sales Statistics', '16040200', 0, null, null, null, null, '游戏销售监控', '/monitor.do?method=salesStatistics', 1604, 3, 6);
insert into ADM_PRIVILEGE values (1701, 'Outlet Information', '17010000', 0, null, null, null, null, '站点信息查询', '/outletInfo.do?method=listOutletInfo', 17, 2, 3);
insert into ADM_PRIVILEGE values (1702, 'Transaction Records', '17020000', 0, null, null, null, null, '交易流水查询', '/outlets.do?method=agencyDealRecord', 17, 2, 6);
insert into ADM_PRIVILEGE values (1703, 'Return Delivery Records', '17030000', 0, null, null, null, null, '退货查询', '/returnedGoods.do?method=returnGoodsList', 17, 2, 9);
insert into ADM_PRIVILEGE values (1704, 'Fund Daliy Record', '17040000', 0, null, null, null, null, '资金日结', '/outlets.do?method=fundDailyRecord', 17, 2, 12);
insert into ADM_PRIVILEGE values (1705, 'Sales Records', '17050000', 0, null, null, null, null, '入库销售记录', '/outletGoods.do?method=outletGoodsList', 17, 2, 15);
insert into ADM_PRIVILEGE values (1706, 'Cash Withdrawn Records', '17060000', 0, null, null, null, null, '提现记录', '/withdrawnRecords.do?method=listWithdrawnRecords', 17, 2, 18);
insert into ADM_PRIVILEGE values (1801, 'Users', '18010000', 0, null, null, null, null, '用户管理', '/user.do?method=listUsers', 18, 2, 3);
insert into ADM_PRIVILEGE values (1802, 'Roles', '18020000', 0, null, null, null, null, '角色管理', '/role.do?method=listRoles', 18, 2, 6);
insert into ADM_PRIVILEGE values (1803, 'Change Password', '18030000', 0, null, null, null, null, '修改密码', '/user.do?method=initChangePwd', 18, 2, 9);
insert into ADM_PRIVILEGE values (1804, 'Change Trans Password', '18040000', 0, null, null, null, null, '修改交易密码', '/marketManagerPwd.do?method=changeMarketManagerPwd', 18, 2, 12);
insert into ADM_PRIVILEGE values (1805, 'System Parameter', '18050000', 0, null, null, null, null, '系统参数配置', '/sysParameter.do?method=sysParameterList', 18, 2, 15);
insert into ADM_PRIVILEGE values (1901, 'Summary Statistics', '19010000', 0, null, null, null, null, '监控统计图汇总', '/monitor.do?method=summaryStatistics', 19, 2, 3);
insert into ADM_PRIVILEGE values (1902, 'Real-Time Sales', '19020000', 0, null, null, null, null, '游戏销量监控', '/monitor.do?method=salesRealTime', 19, 2, 6);
insert into ADM_PRIVILEGE values (1905, 'Outlet Rankings', '19050000', 0, null, null, null, null, '站点销售排行', '/monitor.do?method=outletRankings', 19, 2, 15);
insert into ADM_PRIVILEGE values (120401, 'Goods Issue Information', '12040100', 0, null, null, null, null, '出库查询', '/goodsIssues.do?method=listGoodsIssues', 1204, 3, 3);
insert into ADM_PRIVILEGE values (120402, 'Goods Issue by Stock Transfer', '12040200', 0, null, null, null, null, '调拨单出库', '/goodsIssues.do?method=issueByStockTransfer', 1204, 3, 6);
insert into ADM_PRIVILEGE values (120403, 'Goods Issue by Delivery Order', '12040300', 0, null, null, null, null, '出货单出库', '/goodsIssues.do?method=issueByDeliveryOrder', 1204, 3, 9);
insert into ADM_PRIVILEGE values (120501, 'Inventory Information', '12050100', 0, null, null, null, null, '库存查询', '/inventory.do?method=listInventoryInfo', 1205, 3, 3);
insert into ADM_PRIVILEGE values (120502, 'Process Inventory Check', '12050200', 0, null, null, null, null, '库存盘点', '/inventory.do?method=listInventoryCheck', 1205, 3, 6);
insert into ADM_PRIVILEGE values (120901, 'Item Types', '12090100', 0, null, null, null, null, '类别管理', '/item.do?method=listItemTypes', 1209, 3, 3);
insert into ADM_PRIVILEGE values (120902, 'Item Receipts', '12090200', 0, null, null, null, null, '入库管理', '/item.do?method=listGoodsReceipts', 1209, 3, 6);
insert into ADM_PRIVILEGE values (120903, 'Item Issues', '12090300', 0, null, null, null, null, '出库管理', '/item.do?method=listGoodsIssues', 1209, 3, 9);
insert into ADM_PRIVILEGE values (120904, 'Inventory Information', '12090400', 0, null, null, null, null, '库存查询', '/item.do?method=listInventoryInfo', 1209, 3, 12);
insert into ADM_PRIVILEGE values (120905, 'Process Inventory Check', '12090500', 0, null, null, null, null, '库存盘点', '/item.do?method=listInventoryCheck', 1209, 3, 15);
insert into ADM_PRIVILEGE values (120906, 'Damaged Items', '12090600', 0, null, null, null, null, '物品损毁', '/item.do?method=listDamagedItems', 1209, 3, 18);
insert into ADM_PRIVILEGE values (140201, 'Outlet Accounts', '14020100', 0, null, null, null, null, '站点账户管理', '/account.do?method=listOutletAccounts', 1402, 3, 3);
insert into ADM_PRIVILEGE values (140202, 'Institution Accounts', '14020200', 0, null, null, null, null, '部门账户管理', '/account.do?method=listInstitutionAccounts', 1402, 3, 6);
insert into ADM_PRIVILEGE values (140203, 'Market Managers Accounts', '14020300', 0, null, null, null, null, '市场管理员账户管理', '/account.do?method=listMarketManagersAccounts', 1402, 3, 9);
insert into ADM_PRIVILEGE values (44, 'VALIDATE', '44000000', 0, null, null, null, null, '验票管理', '#', 0, 1, 44);
insert into ADM_PRIVILEGE values (4401, 'Scan Tickets', '44010000', 0, null, null, null, null, '扫票验票', '/checktickets.do?method=scanTickets', 44, 2, 1);
insert into ADM_PRIVILEGE values (4403, 'Inquiry', '44030000', 0, null, null, null, null, '验票查询', '/checktickets.do?method=inquiryCheckedTickets', 44, 2, 3);
insert into ADM_PRIVILEGE values (4405, 'Statistical Reports', '44050000', 0, null, null, null, null, '统计报表', '/checktickets.do?method=statisticalReports', 44, 2, 5);
insert into ADM_PRIVILEGE values (4407, 'Refused Records', '44070000', 0, null, null, null, null, '拒绝兑奖统计', '/checktickets.do?method=refusedRecords', 44, 2, 7);
insert into ADM_PRIVILEGE values (160204, 'Validate Winning Report', '16020400', 0, null, null, null, null, '验奖统计报表', '/checktickets.do?method=statisticalReports', 1602, 3, 12);
insert into ADM_PRIVILEGE values (1406, 'Outlet Adjustment', '14060000', 0, null, null, null, null, '站点调账', '#', 14, 2, 18);
insert into ADM_PRIVILEGE values (160106, 'Inst Payable Report', '16010600', 0, null, null, null, null, '部门应缴款报表', '/saleReport.do?method=institutionPayableReport', 1601, 3, 18);
insert into ADM_PRIVILEGE values (160107, 'Inst Payable Report(USD)', '16010700', 0, null, null, null, null, '部门应缴款报表(美元)', '/saleReport.do?method=institutionPayableReportUSD', 1601, 3, 21);
insert into ADM_PRIVILEGE values (160303, 'Institution Daliy Report', '16030300', 0, null, null, null, null, '部门库存日结报表', '/saleReport.do?method=institutionInventoryDaliyReport', 1603, 3, 9);
insert into ADM_PRIVILEGE values (160304, 'Outlet Daliy Report', '16030400', 0, null, null, null, null, '站点库存日结报表', '/saleReport.do?method=outletInventoryDaliyReport', 1603, 3, 12);
insert into ADM_PRIVILEGE values (160305, 'HQ Item Issue Report', '16030500', 0, null, null, null, null, '总部物品出库报表', '/hqItemIssueReport.do?method=initHQItemIssueReport', 1603, 3, 15);
insert into ADM_PRIVILEGE values (160306, 'HQ Issue Statistics', '16030600', 0, null, null, null, null, '总部方案出库报表', '/goodsReceiptsReport.do?method=initGoodsOutReport', 1603, 3, 18);
insert into ADM_PRIVILEGE values (160307, 'HQ Receipt Statistics', '16030700', 0, null, null, null, null, '总部方案入库汇总', '/goodsReceiptsReport.do?method=initGoodsReceiptsReport', 1603, 3, 21);
insert into ADM_PRIVILEGE values (160108, 'Agent Fund Report', '16010800', 0, null, null, null, null, '代理商资金报表', '/saleReport.do?method=agentFundReport', 1601, 3, 24);
insert into ADM_PRIVILEGE values (160109, 'Agent Fund Report(USD)', '16010900', 0, null, null, null, null, '代理商资金报表(美金)', '/saleReport.do?method=agentFundReportUSD', 1601, 3, 27);
insert into ADM_PRIVILEGE values (1605, 'Analysis', '160450000', 0, null, null, null, null, '数据分析报表', '#', 16, 2, 15);
insert into ADM_PRIVILEGE values (160501, 'Outlets Info Statistics', '16050100', 0, null, null, null, null, '站点信息统计', '/analysis.do?method=outletStatistics', 1605, 3, 3);
insert into ADM_PRIVILEGE values (3704, 'Online Time Statistics', '00370400', 1, 1, '1111111', '00:00:00', '23:59:00', '在线时长统计', '/onlineStatistics.do?method=listOnlineRecords', 37, 2, 12);
insert into ADM_PRIVILEGE values (3705, 'Terminal Check Record', '00370500', 1, 1, '1111111', '00:00:00', '23:59:00', '终端机巡检记录', '/terminalCheck.do?method=listCheckRecords', 37, 2, 15);
insert into ADM_PRIVILEGE values (1606, 'Monthly Report', '16060000', 0, null, null, null, null, '月报', '#', 16, 2, 18);
insert into ADM_PRIVILEGE values (160601, 'Inst Monthly Report ', '16060100', 0, null, null, null, null, '机构月度报表', '/monthlyReport.do?method=listInstMonthlyReport', 1606, 3, 3);
insert into ADM_PRIVILEGE values (160602, 'MM Monthly Report ', '16060200', 0, null, null, null, null, '市场管理员月报', '/monthlyReport.do?method=listMktManagerMonthlyReport', 1606, 3, 6);
insert into ADM_PRIVILEGE values (160603, 'Outlet Monthly Report ', '16060300', 0, null, null, null, null, '站点月度报表', '/monthlyReport.do?method=listOutletMonthlyReport', 1606, 3, 9);
insert into ADM_PRIVILEGE values (160110, 'Outlet Integrated Query', '16011000', 0, null, null, null, null, '站点综合查询', '/saleReport.do?method=listOutletIntegrated', 1601, 3, 30);
insert into ADM_PRIVILEGE values (140601, 'Adjustment', '14060100', 0, null, null, null, null, '调账', '/account.do?method=getOutletInfo', 1406, 3, 3);
insert into ADM_PRIVILEGE values (140602, 'Adjustment Records', '14060200', 0, null, null, null, null, '调账记录', '/account.do?method=listAdjustmentRecords', 1406, 3, 6);
insert into ADM_PRIVILEGE values (1906, 'History Rankings', '19060000', 0, null, null, null, null, '站点历史销售排行', '/monitor.do?method=historyRankings', 19, 2, 18);
insert into ADM_PRIVILEGE values (160205, 'Net Sales Statistics', '16020500', 0, null, null, null, null, '净销售统计报表', '/analysis.do?method=netSalesStatistcs', 1602, 3, 15);
insert into ADM_PRIVILEGE values (120504, 'MM Inventory Check', '12050400', 0, null, null, null, null, '市场管理员库存盘点查询', '/inventory.do?method=listMMInventoryCheck', 1205, 3, 12);
insert into ADM_PRIVILEGE values (30, 'GAME', '0102000000', 1, 1, '1111111', '00:00:00', '23:59:00', '游戏管理', '/gameManagement.do?method=param', 0, 1, 3);
insert into ADM_PRIVILEGE values (31, 'ISSUE', '0103000000', 1, 1, '1111111', '00:00:00', '23:59:00', '期次管理', '/issueManagement.do?method=issueManagementTabs', 0, 1, 6);
insert into ADM_PRIVILEGE values (32, 'MANAGEMENT', '0105000000', 1, 0, '1111111', '00:00:00', '23:59:00', '业务管理', '#', 0, 1, 9);
insert into ADM_PRIVILEGE values (34, 'TICKET', '0107000000', 1, 0, '1111111', '00:00:00', '23:59:00', '彩票管理', '#', 0, 1, 15);
insert into ADM_PRIVILEGE values (36, 'REPORT', '00360000', 1, 1, '1111111', '00:00:00', '23:59:00', '报表', '#', 0, 1, 21);
insert into ADM_PRIVILEGE values (37, 'MONIOTR', '00370000', 1, 1, '1111111', '00:00:00', '23:59:00', '监控', '#', 0, 1, 24);
insert into ADM_PRIVILEGE values (1104, 'Teller', '11040000', 0, null, null, null, null, '销售员管理', '/teller.do?method=listTeller', 11, 2, 12);
insert into ADM_PRIVILEGE values (3001, 'Game Parameter', '0102010000', 1, 1, '1111111', '00:00:00', '23:59:00', '游戏参数', '/gameManagement.do?method=param', 30, 2, 3);
insert into ADM_PRIVILEGE values (3002, 'Game Control', '0102030000', 1, 1, '1111111', '00:00:00', '23:59:00', '游戏控制', '/gameManagement.do?method=control', 30, 2, 6);
insert into ADM_PRIVILEGE values (3003, 'Prize Pool', '0102040000', 1, 1, '1111111', '00:00:00', '23:59:00', '奖池管理', '#', 30, 2, 9);
insert into ADM_PRIVILEGE values (3004, 'Adjustment Fund', '0102050000', 1, 1, '1111111', '00:00:00', '23:59:00', '调节基金管理', '#', 30, 2, 12);
insert into ADM_PRIVILEGE values (3005, 'Issuance Fee', '0102050000', 1, 1, '1111111', '00:00:00', '23:59:00', '发行费管理', '/fundManagement.do?method=govCommision', 30, 2, 15);
insert into ADM_PRIVILEGE values (3101, 'Issue Inquiry', '0103010000', 1, 1, '1111111', '00:00:00', '23:59:00', '期次查询', '/issueManagement.do?method=issueManagementTabs', 31, 2, 3);
insert into ADM_PRIVILEGE values (3102, 'Game Drawing', '0103020000', 1, 1, '1111111', '00:00:00', '23:59:00', '游戏开奖', '/gameDraw.do?method=manualDraw', 31, 2, 6);
insert into ADM_PRIVILEGE values (3103, 'NewIssue-manual', '0103030000', 1, 1, '1111111', '00:00:00', '23:59:00', '手工排期', '/issueManagement.do?method=preArrangementTabs', 31, 2, 9);
insert into ADM_PRIVILEGE values (3104, 'Newissue-templet', '0103040000', 1, 1, '1111111', '00:00:00', '23:59:00', '模版排期', '/issueManagement.do?method=pre_qlx_tty', 31, 2, 12);
insert into ADM_PRIVILEGE values (3201, 'Institution', '0105010000', 1, 1, '1111111', '00:00:00', '23:59:00', '机构管理', '/omsarea.do?method=listOMSArea', 32, 2, 3);
insert into ADM_PRIVILEGE values (3202, 'Outlet', '0105020000', 1, 0, '1111111', '00:00:00', '23:59:00', '销售站管理', '/agency.do?method=listAgency', 32, 2, 6);
insert into ADM_PRIVILEGE values (3203, 'Terminal', '0105030000', 1, 0, '1111111', '00:00:00', '23:59:00', '终端机管理', '/terminal.do?method=listTerminal', 32, 2, 9);
insert into ADM_PRIVILEGE values (3205, 'Notice', '0105050000', 1, 0, '1111111', '00:00:00', '23:59:00', '通知管理', '#', 32, 2, 15);
insert into ADM_PRIVILEGE values (3206, 'Version', '0105060000', 1, 1, '1111111', '00:00:00', '23:59:00', '版本管理', '#', 32, 2, 18);
insert into ADM_PRIVILEGE values (3401, 'Ticket Inquiry', '0107010000', 1, 1, '1111111', '00:00:00', '23:59:00', '彩票查询', '/centerSelect.do?method=centerSelect', 34, 2, 3);
insert into ADM_PRIVILEGE values (3402, 'Ticket Payout', '0107020000', 1, 0, '1111111', '00:00:00', '23:59:00', '彩票兑奖', '/centerSelect.do?method=expirydateint', 34, 2, 6);
insert into ADM_PRIVILEGE values (3403, 'Payout Records', '0107030000', 1, 0, '1111111', '00:00:00', '23:59:00', '兑奖记录查询', '/expirydate.do?method=list', 34, 2, 9);
insert into ADM_PRIVILEGE values (3404, 'Ticket Refund', '0107040000', 1, 0, '1111111', '00:00:00', '23:59:00', '彩票退票', '/refundquery.do?method=refundInit', 34, 2, 12);
insert into ADM_PRIVILEGE values (3405, 'Refund Records', '0107050000', 1, 0, '1111111', '00:00:00', '23:59:00', '退票记录查询', '/refundquery.do?method=list', 34, 2, 15);
insert into ADM_PRIVILEGE values (3406, 'Abandoned Award Inquiry', '00003406', 1, 1, '1111111', '00:00:00', '23:59:00', '弃奖查询', '/abandon.do?method=abandonAward', 34, 2, 18);
insert into ADM_PRIVILEGE values (3407, 'Broken Ticket Inquiry', '34070000', 1, 1, '1111111', '00:00:00', '23:59:00', '残票查询', '/badticketquery.do?method=badticketlist', 34, 2, 21);
insert into ADM_PRIVILEGE values (3601, 'Lottery Winning Statistics', '36010000', 1, 1, '1111111', '00:00:00', '23:59:00', '中奖统计表', '/misReport.do?method=misReport3132', 36, 2, 3);
insert into ADM_PRIVILEGE values (3602, 'Prize Payout Statistics (By Issue and Prize Level)', '36020000', 1, 1, '1111111', '00:00:00', '23:59:00', '兑奖统计表(按奖等统计)', '/misReport.do?method=misReport3133', 36, 2, 6);
insert into ADM_PRIVILEGE values (3603, 'Prize Payout Statistics (By Issue and Prize)', '36030000', 1, 1, '1111111', '00:00:00', '23:59:00', '兑奖统计表(按奖金统计)', '/misReport.do?method=misReport3134', 36, 2, 9);
insert into ADM_PRIVILEGE values (3604, 'Abandoned Award Statistics', '36040000', 1, 1, '1111111', '00:00:00', '23:59:00', '弃奖统计表', '/misReport.do?method=misReport3135', 36, 2, 12);
insert into ADM_PRIVILEGE values (3605, 'Dynamic Prize Table', '36050000', 1, 1, '1111111', '00:00:00', '23:59:00', '奖金动态表', '/misReport.do?method=misReport3136', 36, 2, 15);
insert into ADM_PRIVILEGE values (3701, 'ISSUES', '37010000', 1, 1, '1111111', '00:00:00', '23:59:00', '期次监控', '/gameIssue.do?method=listGameIssue', 37, 2, 3);
insert into ADM_PRIVILEGE values (3702, 'ONLINE TERMINALS', '37020000', 1, 1, '1111111', '00:00:00', '23:59:00', '上线终端机', '#', 37, 2, 6);
insert into ADM_PRIVILEGE values (3703, 'Event Management', '00370100', 1, 1, '1111111', '00:00:00', '23:59:00', '事件控制台', '#', 37, 2, 9);
insert into ADM_PRIVILEGE values (160503, 'Inst Outlets Statistcs(By Lottery Type)', '16050300', 0, null, null, null, null, '部门站点统计(按彩票类型)', '/analysis.do?method=instFundReportByLotType', 1605, 3, 9);
insert into ADM_PRIVILEGE values (160504, 'Agent Fund Report(By Lottery Type)', '16050400', 0, null, null, null, null, '代理商资金报表(按彩票类型)', '/analysis.do?method=agentFundReportByLotType', 1605, 3, 12);
insert into ADM_PRIVILEGE values (300301, 'Pool by Item', '0102040100', 1, 1, '1111111', '00:00:00', '23:59:00', '奖池流水', '/gameManagement.do?method=poolAdj', 3003, 3, 3);
insert into ADM_PRIVILEGE values (300302, 'Pool by Issue', '0102040200', 1, 1, '1111111', '00:00:00', '23:59:00', '期次奖池', '/gameManagement.do?method=poolManagement', 3003, 3, 6);
insert into ADM_PRIVILEGE values (300303, 'Pool Adjustment', '0102040300', 1, 1, '1111111', '00:00:00', '23:59:00', '奖池调整', '/gameManagement.do?method=createPoolAdj', 3003, 3, 9);
insert into ADM_PRIVILEGE values (300401, 'Adjustment Fund by Item', '0102050100', 1, 1, '1111111', '00:00:00', '23:59:00', '调节基金流水', '/fundManagement.do?method=fundList', 3004, 3, 3);
insert into ADM_PRIVILEGE values (300402, 'Adjustment Fund by Issue', '0102050200', 1, 1, '1111111', '00:00:00', '23:59:00', '期次调节基金', '/fundManagement.do?method=issueFundInfo', 3004, 3, 6);
insert into ADM_PRIVILEGE values (300403, 'Change Adjustment Fund', '0102050300', 1, 1, '1111111', '00:00:00', '23:59:00', '调节基金调整', '/fundManagement.do?method=createFundAdj', 3004, 3, 9);
insert into ADM_PRIVILEGE values (320501, 'Outlet Notice', '0105050100', 1, 0, '1111111', '00:00:00', '23:59:00', '销售站公告', '/tmnotice.do?method=notifyList', 3205, 3, 3);
insert into ADM_PRIVILEGE values (320503, 'Ticket Slogan', '0105050300', 1, 1, '1111111', '00:00:00', '23:59:00', '票面宣传语', '/tmnotice.do?method=sendTicketInfo', 3205, 3, 9);
insert into ADM_PRIVILEGE values (320504, 'Scrolling Notice', '00320504', 1, 1, '1111111', '00:00:00', '23:59:00', '滚动字幕', '/tmnotice.do?method=getScrollingNotice', 3205, 3, 12);
insert into ADM_PRIVILEGE values (320601, 'Software Package', '0105060200', 1, 1, '1111111', '00:00:00', '23:59:00', '软件包管理', '/tmversionPackage.do?method=listSoftPackage', 3206, 3, 3);
insert into ADM_PRIVILEGE values (320602, 'Upgrade Plan', '0105060300', 1, 1, '1111111', '00:00:00', '23:59:00', '升级计划', '/updatePlan.do?method=updatePlanList', 3206, 3, 6);
insert into ADM_PRIVILEGE values (320603, 'Software Inquiry', '0105060400', 1, 1, '1111111', '00:00:00', '23:59:00', '软件查询', '/terminalSoftWare.do?method=terminalSoftWareList', 3206, 3, 9);
insert into ADM_PRIVILEGE values (370201, 'Online Distribution', '37020100', 1, 1, '1111111', '00:00:00', '23:59:00', '上线数量监控', '/areaTerminal.do?method=areaTerminalCulumn', 3702, 3, 3);
insert into ADM_PRIVILEGE values (370202, 'Online Percentage', '37020200', 1, 1, '1111111', '00:00:00', '23:59:00', '上线占比图', '/areaTerminal.do?method=areaTerminalPie', 3702, 3, 6);
insert into ADM_PRIVILEGE values (370203, 'Online Ratio', '37020300', 1, 1, '1111111', '00:00:00', '23:59:00', '上线率曲线图', '/areaTerminal.do?method=areaTerminalLine', 3702, 3, 9);
insert into ADM_PRIVILEGE values (370301, 'Event List Inquiry', '00370100', 1, 1, '1111111', '00:00:00', '23:59:00', '事件列表查询', '/event.do?method=listEvents', 3703, 3, 3);
insert into ADM_PRIVILEGE values (370302, 'Settlement Logs', '37030200', 1, 1, '1111111', '00:00:00', '23:59:00', '结算日志', '/taishanLog.do?method=listLog', 3703, 3, 6);
insert into ADM_PRIVILEGE values (370303, 'Data Collection', '37030300', 1, 1, '1111111', '00:00:00', '23:59:00', '上传日志', '/trace.do?method=listTrace', 3703, 3, 9);
insert into ADM_PRIVILEGE values (1406, 'Outlet Adjustment', '14060000', 0, null, null, null, null, '站点调账', '#', 14, 2, 18);
insert into ADM_PRIVILEGE values (1606, 'Monthly Report', '16060000', 0, null, null, null, null, '月报', '#', 16, 2, 18);
insert into ADM_PRIVILEGE values (1906, 'History Rankings', '19060000', 0, null, null, null, null, '站点历史销售排行', '/monitor.do?method=historyRankings', 19, 2, 18);
insert into ADM_PRIVILEGE values (3704, 'Online Time Statistics', '00370400', 1, 1, '1111111', '00:00:00', '23:59:00', '在线时长统计', '/onlineStatistics.do?method=listOnlineRecords', 37, 2, 12);
insert into ADM_PRIVILEGE values (3705, 'Terminal Check Record', '00370500', 1, 1, '1111111', '00:00:00', '23:59:00', '终端机巡检记录', '/terminalCheck.do?method=listCheckRecords', 37, 2, 15);
insert into ADM_PRIVILEGE values (140601, 'Adjustment', '14060100', 0, null, null, null, null, '调账', '/account.do?method=getOutletInfo', 1406, 3, 3);
insert into ADM_PRIVILEGE values (140602, 'Adjustment Records', '14060200', 0, null, null, null, null, '调账记录', '/account.do?method=listAdjustmentRecords', 1406, 3, 6);
insert into ADM_PRIVILEGE values (160110, 'Outlet Integrated Query', '16011000', 0, null, null, null, null, '站点综合查询', '/saleReport.do?method=listOutletIntegrated', 1601, 3, 30);
insert into ADM_PRIVILEGE values (160205, 'Net Sales Statistics', '16020500', 0, null, null, null, null, '净销售统计报表', '/analysis.do?method=netSalesStatistcs', 1602, 3, 15);
insert into ADM_PRIVILEGE values (160601, 'Inst Monthly Report ', '16060100', 0, null, null, null, null, '机构月度报表', '/monthlyReport.do?method=listInstMonthlyReport', 1606, 3, 3);
insert into ADM_PRIVILEGE values (160602, 'MM Monthly Report ', '16060200', 0, null, null, null, null, '市场管理员月报', '/monthlyReport.do?method=listMktManagerMonthlyReport', 1606, 3, 6);
insert into ADM_PRIVILEGE values (160603, 'Outlet Monthly Report ', '16060300', 0, null, null, null, null, '站点月度报表', '/monthlyReport.do?method=listOutletMonthlyReport', 1606, 3, 9);

-- 足彩
Insert into ADM_PRIVILEGE Values (33, 'FBS MANAGEMENT', '33000000', 1, 0, '1111111', '00:00:00', '23:59:00', 'FBS管理', '#', 0, 1, 12);
Insert into ADM_PRIVILEGE Values (3301, 'League', '0107010000', 1, 1, '1111111', '00:00:00', '23:59:00', '游戏', '#', 33, 2, 3);
Insert into ADM_PRIVILEGE Values (330101, 'League', '0107010000', 1, 1, '1111111', '00:00:00', '23:59:00', '联赛管理', '/league.do?method=listLeagues', 3301, 3, 3);
Insert into ADM_PRIVILEGE Values (330102, 'Team', '0107020000', 1, 0, '1111111', '00:00:00', '23:59:00', '球队管理', '/team.do?method=listTeams', 3301, 3, 6);
Insert into ADM_PRIVILEGE Values (3302, 'Issue', '0107010000', 1, 1, '1111111', '00:00:00', '23:59:00', '期次', '#', 33, 2, 6);
Insert into ADM_PRIVILEGE Values (330201, 'Issue Information', '0107010000', 1, 1, '1111111', '00:00:00', '23:59:00', '期次信息', '/fbsIssue.do?method=listFbsIssue', 3302, 3, 3);
Insert into ADM_PRIVILEGE Values (330202, 'Match', '0107020000', 1, 0, '1111111', '00:00:00', '23:59:00', '比赛列表', '/fbsGame.do?method=listFbsMatch', 3302, 3, 6);
Insert into ADM_PRIVILEGE Values (330203, 'Game Drawing', '0107020000', 1, 0, '1111111', '00:00:00', '23:59:00', '游戏开奖', '/fbsDraw.do?method=initFbsDraw', 3302, 3, 9);

Insert into ADM_PRIVILEGE  (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_IS_CENTER, 
    PRIVILEGE_AGREEDAY, PRIVILEGE_LOGINBEGIN, PRIVILEGE_LOGINEND, PRIVILEGE_REMARK, PRIVILEGE_URL, 
    PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (3706, 'Operate Log', '00370600', 1, 1, 
    '1111111', '00:00:00', '23:59:00', '操作日志', '#', 
    37, 2, 18);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_IS_CENTER, 
    PRIVILEGE_AGREEDAY, PRIVILEGE_LOGINBEGIN, PRIVILEGE_LOGINEND, PRIVILEGE_REMARK, PRIVILEGE_URL, 
    PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (370601, 'Operate Log Inquiry', '00370601', 1, 1, 
    '1111111', '00:00:00', '23:59:00', '操作日志查询', '/operateLog.do?method=listOperateLog', 
    3706, 3, 3);
Insert into ADM_PRIVILEGE
   (PRIVILEGE_ID, PRIVILEGE_NAME, PRIVILEGE_CODE, PRIVILEGE_SYSTEM, PRIVILEGE_IS_CENTER, 
    PRIVILEGE_AGREEDAY, PRIVILEGE_LOGINBEGIN, PRIVILEGE_LOGINEND, PRIVILEGE_REMARK, PRIVILEGE_URL, 
    PRIVILEGE_PARENT, PRIVILEGE_LEVEL, PRIVILEGE_ORDER)
 Values
   (370602, 'Operate Type Management', '00370601', 1, 1, 
    '1111111', '00:00:00', '23:59:00', '操作类型管理', '/operateLog.do?method=listOperateType', 
    3706, 3, 6);
COMMIT;
--站点银行资金管理

insert into ADM_PRIVILEGE values (1407, 'Outlet Bank Management', '14070000', 0, null, null, null, null, '站点银行管理', '#', 14, 2, 19);
insert into ADM_PRIVILEGE values (140701, 'Outlet Bank Account', '14070100', 0, null, null, null, null, '站点银行账户', '/outletBank.do?method=listOutletAcc', 1407, 3, 1);
insert into ADM_PRIVILEGE values (140702, 'Outlet Topup Records', '14070200', 0, null, null, null, null, '站点充值记录', '/outletBank.do?method=listTopupRecords', 1407, 3, 2);
insert into ADM_PRIVILEGE values (140703, 'Outlet Withdrawn Records', '14070300', 0, null, null, null, null, '站点提现记录', '/outletBank.do?method=listWithdrawRecords', 1407, 3, 3);

COMMIT;
