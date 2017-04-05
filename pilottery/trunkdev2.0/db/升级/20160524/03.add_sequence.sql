prompt 正在建立[SEQUENCE]...... 

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
create sequence seq_his_sell cache 1000 order;
create sequence seq_his_cancel order;
create sequence seq_his_pay cache 1000 order;
create sequence seq_his_settle order;
create sequence seq_his_win cache 1000 order;