-- 用于获得权限中用户和角色ID
create sequence seq_adm_id order;

-- 用于资金管理序号
create sequence seq_fund_no order;

-- 用于批次信息导入序号
create sequence seq_batch_imp order;

-- 用于物品序号
create sequence seq_item_code order;

-- 用于物品出入库及盘点序号
create sequence seq_item_no order;

-- 用于物品出入库及盘点明细的序号
create sequence seq_item_sequence_no order;

-- 用于出库单入库单序号
create sequence seq_wh_sgi_sgr_no order;

-- 用于出库单入库单明细序号
create sequence seq_wh_sgi_sgr_detail_no order;

-- 订单、出货单、调拨单、退货单、损毁单、盘点单和批次入库单编号的序列
create sequence seq_order_no order;

-- 订单收货明细、订单申请明细、出货单申请明细、调拨单申请明细、退货单明细、损毁单明细、盘点差错明细、盘点结果明细、盘点前库存明细的序列
create sequence seq_detail_sequence_no order;

-- 用于站点资金流水序号
create sequence seq_agency_fund_flow order;

-- 用于市场管理员资金流水序号
create sequence seq_mm_fund_flow order;

-- 用于机构资金流水序号
create sequence seq_org_fund_flow order;

-- 用于兑奖记录序号
create sequence seq_pay_flow order;

-- 用于销售记录序号
create sequence seq_sale_flow order;

-- 用于退票记录序号
create sequence seq_cancel_flow order;

-- 用于切换用的序列号
create sequence seq_switch_flow order;



/*************** 泰山系统 ******************/
-- 用于游戏的各种历史值ID
create sequence seq_game_his_code order;

-- 用于游戏类流水序号
create sequence seq_game_flow order;

-- 用于软件升级计划ID
create sequence seq_upg_schedule_id order;

-- 用于系统管理中的主机通讯日志ID
create sequence seq_sys_host_logid order;

-- 用于通知系统的各种ID
create sequence seq_sys_noticeid order;

-- GUI兑奖请求流水（SEQ_SALE_GUI_PAY）
create sequence SEQ_SALE_GUI_PAY
maxvalue 999999
cycle order;

-- GUI退票请求流水（SEQ_SALE_GUI_CANCEL）
create sequence SEQ_SALE_GUI_CANCEL
maxvalue 999999
cycle order;

-- SYS_INTERNAL日志ID
create sequence seq_his_logid order;

-- 缴款员系统申请ID
create sequence seq_collect_apply_id maxvalue 99999999999 order;

-- 终端日志采集编号
create sequence seq_sys_clog_info order;

-- 终端日志采集编号
create sequence seq_sys_event_id order;

-- MIS历史表SEQ
create sequence seq_his_sell order;
create sequence seq_his_cancel order;
create sequence seq_his_pay order;
create sequence seq_his_settle order;
create sequence seq_his_win order;

-- 用于job任务创建时候的序号
create sequence seq_job order;

-- 操作日志编号
create sequence seq_sys_log_id order;

-- 操作日志类型编号
create sequence seq_sys_log_mode_id order;
