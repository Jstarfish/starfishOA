create table ADM_INFO(
	ADMIN_ID NUMBER(4)  not null,
	ADMIN_REALNAME VARCHAR2(1000)  not null,
	ADMIN_LOGIN VARCHAR2(32)  not null,
	ADMIN_PASSWORD CHAR(32)  not null,
	ADMIN_GENDER NUMBER(1)  not null,
	ADMIN_EMAIL VARCHAR2(100)  ,
	ADMIN_BIRTHDAY DATE  ,
	ADMIN_TEL VARCHAR2(50)  ,
	ADMIN_MOBILE VARCHAR2(50)  ,
	ADMIN_PHONE VARCHAR2(50)  ,
	ADMIN_ORG CHAR(2)  ,
	ADMIN_ADDRESS VARCHAR2(4000)  ,
	ADMIN_REMARK VARCHAR2(4000)  ,
	ADMIN_STATUS NUMBER(1) default 1 not null,
	ADMIN_CREATE_TIME DATE default sysdate ,
	ADMIN_UPDATE_TIME DATE default sysdate ,
	ADMIN_LOGIN_TIME DATE default sysdate ,
	ADMIN_LOGIN_COUNT NUMBER(10) default 0 ,
	ADMIN_AGREEDAY VARCHAR2(7)  ,
	ADMIN_LOGIN_BEGIN VARCHAR2(15)  ,
	ADMIN_LOGIN_END VARCHAR2(15)  ,
	CREATE_ADMIN_ID NUMBER(4) default 0 ,
	ADMIN_IP_LIMIT VARCHAR2(200)  ,
	LOGIN_STATUS NUMBER(1) default 0 not null,
	IS_COLLECTER NUMBER(1) default 0 not null,
	IS_WAREHOUSE_M NUMBER(1) default 0 not null,
	constraint PK_ADM_INFO primary Key (ADMIN_ID)
);
comment on table ADM_INFO is '用户信息表';
comment on column ADM_INFO.ADMIN_ID is '用户ID';
comment on column ADM_INFO.ADMIN_REALNAME is '真实姓名';
comment on column ADM_INFO.ADMIN_LOGIN is '登录名';
comment on column ADM_INFO.ADMIN_PASSWORD is '密码';
comment on column ADM_INFO.ADMIN_GENDER is '性别(1-男，2-女)';
comment on column ADM_INFO.ADMIN_EMAIL is 'EMAIL地址';
comment on column ADM_INFO.ADMIN_BIRTHDAY is '生日';
comment on column ADM_INFO.ADMIN_TEL is '办公电话';
comment on column ADM_INFO.ADMIN_MOBILE is '移动电话';
comment on column ADM_INFO.ADMIN_PHONE is '住宅电话';
comment on column ADM_INFO.ADMIN_ORG is '所属部门';
comment on column ADM_INFO.ADMIN_ADDRESS is '家庭地址';
comment on column ADM_INFO.ADMIN_REMARK is '备注';
comment on column ADM_INFO.ADMIN_STATUS is '用户状态(1-可用，2-删除，3-由于密码原因停用)';
comment on column ADM_INFO.ADMIN_CREATE_TIME is '创建时间';
comment on column ADM_INFO.ADMIN_UPDATE_TIME is '更新时间';
comment on column ADM_INFO.ADMIN_LOGIN_TIME is '登陆时间';
comment on column ADM_INFO.ADMIN_LOGIN_COUNT is '登陆次数';
comment on column ADM_INFO.ADMIN_AGREEDAY is '在一周之内的可用时间（以天为单位）';
comment on column ADM_INFO.ADMIN_LOGIN_BEGIN is '每天可登陆的开始时间';
comment on column ADM_INFO.ADMIN_LOGIN_END is '每天可登陆的结束时间';
comment on column ADM_INFO.CREATE_ADMIN_ID is '创建人ID';
comment on column ADM_INFO.ADMIN_IP_LIMIT is '可登陆的IP范围';
comment on column ADM_INFO.LOGIN_STATUS is '用户在线状态(1-在线，2-离线)';
comment on column ADM_INFO.IS_COLLECTER is '是否缴款员';
comment on column ADM_INFO.IS_WAREHOUSE_M is '是否仓库管理员';

create table ADM_ROLE(
	ROLE_ID NUMBER(4) default 0 not null,
	ROLE_NAME VARCHAR2(1000)  not null,
	IS_ACTIVE NUMBER(1) default 0 not null,
	ROLE_COMMENT VARCHAR2(4000)  ,
	ROLE_CODE VARCHAR2(50)  ,
	constraint PK_ADM_ROLE primary Key (ROLE_ID)
);
comment on table ADM_ROLE is '角色信息表';
comment on column ADM_ROLE.ROLE_ID is '角色id';
comment on column ADM_ROLE.ROLE_NAME is '角色名称';
comment on column ADM_ROLE.IS_ACTIVE is '角色是否开通 (0=关闭、1=开通)';
comment on column ADM_ROLE.ROLE_COMMENT is '备注';
comment on column ADM_ROLE.ROLE_CODE is '角色编码';

create table ADM_ROLE_ADMIN(
	ADMIN_ID NUMBER(4)  not null,
	ROLE_ID NUMBER(4)  not null,
	constraint PK_ADM_ROLE_ADMIN primary Key (ADMIN_ID,ROLE_ID)
);
comment on table ADM_ROLE_ADMIN is '管理员角色信息表';
comment on column ADM_ROLE_ADMIN.ADMIN_ID is '用户ID';
comment on column ADM_ROLE_ADMIN.ROLE_ID is '角色ID';

create table ADM_PRIVILEGE(
	PRIVILEGE_ID NUMBER(6)  not null,
	PRIVILEGE_NAME VARCHAR2(1000)  not null,
	PRIVILEGE_CODE VARCHAR2(500),
	PRIVILEGE_SYSTEM NUMBER(1) default 0 not null,
	PRIVILEGE_IS_CENTER NUMBER(1)  ,
	PRIVILEGE_AGREEDAY VARCHAR2(7)  ,
	PRIVILEGE_LOGINBEGIN VARCHAR2(10)  ,
	PRIVILEGE_LOGINEND VARCHAR2(10)  ,
	PRIVILEGE_REMARK VARCHAR2(4000)  ,
	PRIVILEGE_URL VARCHAR2(200)  ,
	PRIVILEGE_PARENT NUMBER(8) default 0 ,
	PRIVILEGE_LEVEL NUMBER(8) default 0 ,
	PRIVILEGE_ORDER NUMBER(2) default 0 ,
	constraint PK_ADM_PRIVILEGE primary Key (PRIVILEGE_ID)
);
comment on table ADM_PRIVILEGE is '功能模块（菜单）列表';
comment on column ADM_PRIVILEGE.PRIVILEGE_ID is '功能模块id';
comment on column ADM_PRIVILEGE.PRIVILEGE_NAME is '功能模块名称';
comment on column ADM_PRIVILEGE.PRIVILEGE_CODE is '功能模块系统标识';
comment on column ADM_PRIVILEGE.PRIVILEGE_SYSTEM is '所属子系统';
comment on column ADM_PRIVILEGE.PRIVILEGE_IS_CENTER is '是否中心专用';
comment on column ADM_PRIVILEGE.PRIVILEGE_AGREEDAY is '功能模块在一周之内的可用时间（以天为单位）';
comment on column ADM_PRIVILEGE.PRIVILEGE_LOGINBEGIN is '功能模块允许开始的时间';
comment on column ADM_PRIVILEGE.PRIVILEGE_LOGINEND is '功能模块允许结束的时间';
comment on column ADM_PRIVILEGE.PRIVILEGE_REMARK is '功能模块描述';
comment on column ADM_PRIVILEGE.PRIVILEGE_URL is '菜单URL地址';
comment on column ADM_PRIVILEGE.PRIVILEGE_PARENT is '父功能模块';
comment on column ADM_PRIVILEGE.PRIVILEGE_LEVEL is '功能模块级别';
comment on column ADM_PRIVILEGE.PRIVILEGE_ORDER is '排序';

create table ADM_ROLE_PRIVILEGE(
	ROLE_ID NUMBER(4)  not null,
	PRIVILEGE_ID NUMBER(6)  not null,
	constraint PK_ADM_ROLE_PRIVILEGE primary Key (ROLE_ID,PRIVILEGE_ID)
);
comment on table ADM_ROLE_PRIVILEGE is '角色功能对应表';
comment on column ADM_ROLE_PRIVILEGE.ROLE_ID is '角色名称';
comment on column ADM_ROLE_PRIVILEGE.PRIVILEGE_ID is '功能模块id';

create table INF_AREAS(
	AREA_CODE CHAR(4)  not null,
	AREA_NAME VARCHAR2(500)  not null,
	SUPER_AREA CHAR(4)  not null,
	STATUS NUMBER(1)  not null,
	AREA_TYPE NUMBER(1)  not null,
	constraint PK_INF_AREAS primary Key (AREA_CODE)
);
comment on table INF_AREAS is '区域基本信息';
comment on column INF_AREAS.AREA_CODE is '区域编码（0000代表全国、0100代表本省、0101代表区）';
comment on column INF_AREAS.AREA_NAME is '区域名称';
comment on column INF_AREAS.SUPER_AREA is '父区域编码';
comment on column INF_AREAS.STATUS is '区域状态（1=有效、2=无效）';
comment on column INF_AREAS.AREA_TYPE is '区域类型（0=全国；1=省；2=市）';

create table INF_ORGS(
	ORG_CODE CHAR(2)  not null,
	ORG_NAME VARCHAR2(4000)  not null,
	ORG_TYPE NUMBER(1)  not null,
	ORG_STATUS NUMBER(1)  not null,
	SUPER_ORG CHAR(2)  not null,
	PHONE VARCHAR2(100)  ,
	DIRECTOR_ADMIN NUMBER(4)  ,
	PERSONS NUMBER(6) default 0 not null,
	ADDRESS VARCHAR2(4000)  ,
	constraint PK_INF_ORGS primary Key (ORG_CODE)
);
comment on table INF_ORGS is '组织机构基本信息';
comment on column INF_ORGS.ORG_CODE is '机构编码（00代表总公司，01代表分公司）';
comment on column INF_ORGS.ORG_NAME is '机构名称';
comment on column INF_ORGS.ORG_TYPE is '机构类别（1-公司,2-代理）';
comment on column INF_ORGS.ORG_STATUS is '部门状态（1-可用，2-删除）';
comment on column INF_ORGS.SUPER_ORG is '所属上级';
comment on column INF_ORGS.PHONE is '部门联系电话';
comment on column INF_ORGS.DIRECTOR_ADMIN is '负责人';
comment on column INF_ORGS.PERSONS is '部门人数';
comment on column INF_ORGS.ADDRESS is '地址';

create table INF_ORG_AREA(
	ORG_CODE CHAR(2)  not null,
	AREA_CODE CHAR(4)  not null,
	constraint PK_INF_ORG_AREA primary Key (ORG_CODE,AREA_CODE)
);
comment on table INF_ORG_AREA is '组织机构管理区域';
comment on column INF_ORG_AREA.ORG_CODE is '部门编码';
comment on column INF_ORG_AREA.AREA_CODE is '区域编码';
create index UDX_INF_ORG_AREA on INF_ORG_AREA(AREA_CODE);

create table INF_AGENCYS(
	AGENCY_CODE CHAR(8)  not null,
	AGENCY_NAME VARCHAR2(1000)  not null,
	STORETYPE_ID NUMBER(2)  not null,
	STATUS NUMBER(1)  not null,
	AGENCY_TYPE NUMBER(1) default 1 not null,
	BANK_ID NUMBER(4)  ,
	BANK_ACCOUNT VARCHAR2(32)  ,
	TELEPHONE VARCHAR2(100)  ,
	CONTACT_PERSON VARCHAR2(500)  ,
	ADDRESS VARCHAR2(4000)  ,
	AGENCY_ADD_TIME DATE default sysdate not null,
	QUIT_TIME DATE  ,
	ORG_CODE CHAR(2)  not null,
	AREA_CODE CHAR(4)  not null,
	LOGIN_PASS VARCHAR2(32)  ,
	TRADE_PASS VARCHAR2(32)  ,
	MARKET_MANAGER_ID NUMBER(4)  ,
	constraint PK_INF_AGENCYS primary Key (AGENCY_CODE)
);
comment on table INF_AGENCYS is '站点基本信息';
comment on column INF_AGENCYS.AGENCY_CODE is '销售站编码（4位区域编码+4位顺序号）';
comment on column INF_AGENCYS.AGENCY_NAME is '销售站名称';
comment on column INF_AGENCYS.STORETYPE_ID is '店面类型ID';
comment on column INF_AGENCYS.STATUS is '销售站状态（1=可用；2=已禁用；3=已清退）';
comment on column INF_AGENCYS.AGENCY_TYPE is '销售站类型（1=传统终端(预付费)；2=受信终端(后付费)；3=无纸化；4=中心销售站）';
comment on column INF_AGENCYS.BANK_ID is '银行ID';
comment on column INF_AGENCYS.BANK_ACCOUNT is '银行账号';
comment on column INF_AGENCYS.TELEPHONE is '销售站电话';
comment on column INF_AGENCYS.CONTACT_PERSON is '销售站联系人';
comment on column INF_AGENCYS.ADDRESS is '销售站地址';
comment on column INF_AGENCYS.AGENCY_ADD_TIME is '销售站添加时间';
comment on column INF_AGENCYS.QUIT_TIME is '清退时间';
comment on column INF_AGENCYS.ORG_CODE is '所属部门编码';
comment on column INF_AGENCYS.AREA_CODE is '所属区域编码';
comment on column INF_AGENCYS.LOGIN_PASS is '登录密码';
comment on column INF_AGENCYS.TRADE_PASS is '交易密码';
comment on column INF_AGENCYS.MARKET_MANAGER_ID is '市场管理员编码';
create index IDX_SALER_AGENCY_AREA on INF_AGENCYS(AREA_CODE);

create table INF_AGENCY_EXT(
	AGENCY_CODE CHAR(8)  not null,
	PERSONAL_ID VARCHAR2(100)  ,
	CONTRACT_NO VARCHAR2(100)  ,
	GLATLNG_N VARCHAR2(20)  ,
	GLATLNG_E VARCHAR2(20)  ,
	constraint PK_INF_AGENCY_EXT primary Key (AGENCY_CODE)
);
comment on table INF_AGENCY_EXT is '站点扩展信息';
comment on column INF_AGENCY_EXT.AGENCY_CODE is '销售站编码';
comment on column INF_AGENCY_EXT.PERSONAL_ID is '证件号码';
comment on column INF_AGENCY_EXT.CONTRACT_NO is '合同编号';
comment on column INF_AGENCY_EXT.GLATLNG_N is '销售站经度';
comment on column INF_AGENCY_EXT.GLATLNG_E is '销售站维度';

create table INF_AGENCY_DELETE(
	DELETE_NO CHAR(10)  not null,
	AGENCY_CODE CHAR(8)  not null,
	AGENCY_NAME VARCHAR2(1000)  ,
	AVAILABLE_CREDIT NUMBER(28)  not null,
	CREDIT_LIMIT NUMBER(28)  not null,
	OPER_TIME DATE  not null,
	OPER_ADMIN NUMBER(4)  not null,
	constraint PK_INF_AGENCY_DELETE primary Key (DELETE_NO)
);
comment on table INF_AGENCY_DELETE is '销售站清退';
comment on column INF_AGENCY_DELETE.DELETE_NO is '清退编号（QT12345678）';
comment on column INF_AGENCY_DELETE.AGENCY_CODE is '销售站编码';
comment on column INF_AGENCY_DELETE.AGENCY_NAME is '销售站名称';
comment on column INF_AGENCY_DELETE.AVAILABLE_CREDIT is '销售站余额';
comment on column INF_AGENCY_DELETE.CREDIT_LIMIT is '信用额度';
comment on column INF_AGENCY_DELETE.OPER_TIME is '操作时间';
comment on column INF_AGENCY_DELETE.OPER_ADMIN is '操作人编码';

create table INF_MARKET_ADMIN(
	MARKET_ADMIN NUMBER(4)  ,
	TRANS_PASS VARCHAR2(32)  ,
	CREDIT_BY_TRAN NUMBER(28)  ,
	MAX_AMOUNT_TICKETSS NUMBER(28)  ,
	constraint PK_INF_MARKET_ADMIN primary Key (MARKET_ADMIN)
);
comment on table INF_MARKET_ADMIN is '缴款专员';
comment on column INF_MARKET_ADMIN.MARKET_ADMIN is '市场管理员';
comment on column INF_MARKET_ADMIN.TRANS_PASS is '交易密码';
comment on column INF_MARKET_ADMIN.CREDIT_BY_TRAN is '每笔交易限额';
comment on column INF_MARKET_ADMIN.MAX_AMOUNT_TICKETSS is '最高赊票金额';

create table INF_BANKS(
	BANK_ID NUMBER(4)  not null,
	BANK_NAME VARCHAR2(200)  ,
	constraint PK_INF_BANKS primary Key (BANK_ID)
);
comment on table INF_BANKS is '银行基本信息';
comment on column INF_BANKS.BANK_ID is '银行ID';
comment on column INF_BANKS.BANK_NAME is '银行名称';

create table INF_STORETYPES(
	STORETYPE_ID NUMBER(2)  not null,
	STORETYPE_NAME VARCHAR2(4000)  not null,
	IS_VALID NUMBER(1)  not null,
	constraint PK_INF_STORETYPES primary Key (STORETYPE_ID)
);
comment on table INF_STORETYPES is '店面类型基本信息';
comment on column INF_STORETYPES.STORETYPE_ID is '类型ID';
comment on column INF_STORETYPES.STORETYPE_NAME is '类型名称';
comment on column INF_STORETYPES.IS_VALID is '是否启用';

create table INF_PUBLISHERS(
	PUBLISHER_CODE NUMBER(2)  not null,
	PUBLISHER_NAME VARCHAR2(500)  not null,
	IS_VALID NUMBER(1) default 1 not null,
	PLAN_FLOW NUMBER(1)  ,
	constraint PK_INF_PUBLISHERS primary Key (PUBLISHER_CODE)
);
comment on table INF_PUBLISHERS is '印制厂商基本信息';
comment on column INF_PUBLISHERS.PUBLISHER_CODE is '印制厂商编码';
comment on column INF_PUBLISHERS.PUBLISHER_NAME is '印制厂商名称';
comment on column INF_PUBLISHERS.IS_VALID is '是否有效（1-有效、0-无效）';
comment on column INF_PUBLISHERS.PLAN_FLOW is '应对的处理流程（1-A计划，2-B计划）';

create table INF_TERMINAL(
	TERMINAL_CODE CHAR(8)  not null,
	TERM_IDENTITY_CODE VARCHAR2(100)  ,
	constraint PK_INF_TERMINAL primary Key (TERMINAL_CODE)
);
comment on table INF_TERMINAL is '终端机管理';
comment on column INF_TERMINAL.TERMINAL_CODE is '终端机编码';
comment on column INF_TERMINAL.TERM_IDENTITY_CODE is '终端机唯一标识';

create table INF_TELLERS(
	TELLER_CODE NUMBER(8)  not null,
	AGENCY_CODE CHAR(8)  not null,
	TELLER_NAME VARCHAR2(1000)  ,
	TELLER_TYPE NUMBER(1)  not null,
	STATUS NUMBER(1)  ,
	PASSWORD VARCHAR2(32)  ,
	LATEST_TERMINAL_CODE CHAR(10)  ,
	LATEST_SIGN_ON_TIME DATE  ,
	LATEST_SIGN_OFF_TIME DATE  ,
	IS_ONLINE NUMBER(1)  ,
	constraint PK_INF_TELLER primary Key (TELLER_CODE)
);
comment on table INF_TELLERS is '销售员';
comment on column INF_TELLERS.TELLER_CODE is '销售员编码';
comment on column INF_TELLERS.AGENCY_CODE is '销售站编码';
comment on column INF_TELLERS.TELLER_NAME is '销售员名称';
comment on column INF_TELLERS.TELLER_TYPE is '销售员类型（1=普通销售员； 2=销售站经理；3=培训员）';
comment on column INF_TELLERS.STATUS is '销售员状态（1=可用；2=已禁用；3=已删除）';
comment on column INF_TELLERS.PASSWORD is '口令';
comment on column INF_TELLERS.LATEST_TERMINAL_CODE is '最近签入的销售终端编码';
comment on column INF_TELLERS.LATEST_SIGN_ON_TIME is '最近签入日期时间';
comment on column INF_TELLERS.LATEST_SIGN_OFF_TIME is '最后签出日期时间';
comment on column INF_TELLERS.IS_ONLINE is '是否在线';

create table ACC_ORG_ACCOUNT(
	ORG_CODE CHAR(2)  not null,
	ACC_TYPE NUMBER(1) default 1 not null,
	ACC_NAME VARCHAR2(4000)  not null,
	ACC_STATUS NUMBER(1)  not null,
	ACC_NO CHAR(12)  not null,
	CREDIT_LIMIT NUMBER(28) default 0 not null,
	ACCOUNT_BALANCE NUMBER(28) default 0 not null,
	FROZEN_BALANCE NUMBER(28) default 0 not null,
	CHECK_CODE VARCHAR2(40)  not null,
	constraint PK_ACC_ORG_ACCOUNT primary Key (ACC_NO)
);
comment on table ACC_ORG_ACCOUNT is '组织机构账户信息';
comment on column ACC_ORG_ACCOUNT.ORG_CODE is '部门编码';
comment on column ACC_ORG_ACCOUNT.ACC_TYPE is '账户类型（1-主要账户）';
comment on column ACC_ORG_ACCOUNT.ACC_NAME is '账户名称';
comment on column ACC_ORG_ACCOUNT.ACC_STATUS is '账户状态（1-可用，2-停用，3-异常）';
comment on column ACC_ORG_ACCOUNT.ACC_NO is '账户编码（JG+2位部门+8位顺序）';
comment on column ACC_ORG_ACCOUNT.CREDIT_LIMIT is '信用额度';
comment on column ACC_ORG_ACCOUNT.ACCOUNT_BALANCE is '可用余额';
comment on column ACC_ORG_ACCOUNT.FROZEN_BALANCE is '冻结金额';
comment on column ACC_ORG_ACCOUNT.CHECK_CODE is '校验码（全部）';

create table ACC_AGENCY_ACCOUNT(
	AGENCY_CODE CHAR(8)  not null,
	ACC_TYPE NUMBER(1) default 1 not null,
	ACC_NAME VARCHAR2(4000)  not null,
	ACC_STATUS NUMBER(1)  not null,
	ACC_NO CHAR(12)  not null,
	CREDIT_LIMIT NUMBER(28) default 0 not null,
	ACCOUNT_BALANCE NUMBER(28) default 0 not null,
	FROZEN_BALANCE NUMBER(28) default 0 not null,
	CHECK_CODE VARCHAR2(40)  not null,
	constraint PK_ACC_AGENCY_ACCOUNT primary Key (ACC_NO)
);
comment on table ACC_AGENCY_ACCOUNT is '站点账户信息';
comment on column ACC_AGENCY_ACCOUNT.AGENCY_CODE is '销售站编码';
comment on column ACC_AGENCY_ACCOUNT.ACC_TYPE is '账户类型（1-主要账户）';
comment on column ACC_AGENCY_ACCOUNT.ACC_NAME is '账户名称';
comment on column ACC_AGENCY_ACCOUNT.ACC_STATUS is '账户状态（1-可用，2-停用，3-异常）';
comment on column ACC_AGENCY_ACCOUNT.ACC_NO is '账户编码（ZD+8位站点+2位顺序）';
comment on column ACC_AGENCY_ACCOUNT.CREDIT_LIMIT is '信用额度';
comment on column ACC_AGENCY_ACCOUNT.ACCOUNT_BALANCE is '可用余额';
comment on column ACC_AGENCY_ACCOUNT.FROZEN_BALANCE is '冻结金额';
comment on column ACC_AGENCY_ACCOUNT.CHECK_CODE is '校验码（全部）';

create table ACC_MM_ACCOUNT(
	MARKET_ADMIN NUMBER(4)  not null,
	ACC_TYPE NUMBER(1) default 1 not null,
	ACC_NAME VARCHAR2(4000)  not null,
	ACC_STATUS NUMBER(1)  not null,
	ACC_NO CHAR(12)  not null,
	CREDIT_LIMIT NUMBER(28) default 0 not null,
	ACCOUNT_BALANCE NUMBER(28) default 0 not null,
	CHECK_CODE VARCHAR2(40)  not null,
	constraint PK_ACC_MM_ACCOUNT primary Key (ACC_NO)
);
comment on table ACC_MM_ACCOUNT is '市场管理员账户信息';
comment on column ACC_MM_ACCOUNT.MARKET_ADMIN is '市场管理员';
comment on column ACC_MM_ACCOUNT.ACC_TYPE is '账户类型（1-主要账户）';
comment on column ACC_MM_ACCOUNT.ACC_NAME is '账户名称';
comment on column ACC_MM_ACCOUNT.ACC_STATUS is '账户状态（1-可用，2-停用，3-异常）';
comment on column ACC_MM_ACCOUNT.ACC_NO is '账户编码（MM+4位用户编号+6位顺序）';
comment on column ACC_MM_ACCOUNT.CREDIT_LIMIT is '信用额度';
comment on column ACC_MM_ACCOUNT.ACCOUNT_BALANCE is '可用余额';
comment on column ACC_MM_ACCOUNT.CHECK_CODE is '校验码（全部）';

create table ACC_MM_TICKETS(
	MARKET_ADMIN NUMBER(4)  ,
	PLAN_CODE VARCHAR2(10)  ,
	BATCH_NO VARCHAR2(10)  not null,
	TICKETS NUMBER(20)  ,
	AMOUNT NUMBER(28)  ,
	constraint PK_ACC_MM_TICKETS primary Key (MARKET_ADMIN,PLAN_CODE,BATCH_NO)
);
comment on table ACC_MM_TICKETS is '市场管理员持票数';
comment on column ACC_MM_TICKETS.MARKET_ADMIN is '市场管理员ID';
comment on column ACC_MM_TICKETS.PLAN_CODE is '方案';
comment on column ACC_MM_TICKETS.BATCH_NO is '批次';
comment on column ACC_MM_TICKETS.TICKETS is '票数';
comment on column ACC_MM_TICKETS.AMOUNT is '金额';

create table GAME_PLANS(
	PLAN_CODE VARCHAR2(10)  not null,
	FULL_NAME VARCHAR2(4000)  not null,
	SHORT_NAME VARCHAR2(4000)  not null,
	TICKET_AMOUNT NUMBER(10) default 0 not null,
	PUBLISHER_CODE NUMBER(2)  not null,
	LOTTERY_TYPE NUMBER(1) default 1 not null,
	constraint PK_GAME_PLANS primary Key (PLAN_CODE)
);
comment on table GAME_PLANS is '方案基本信息';
comment on column GAME_PLANS.PLAN_CODE is '方案编码';
comment on column GAME_PLANS.FULL_NAME is '方案名称';
comment on column GAME_PLANS.SHORT_NAME is '方案缩写';
comment on column GAME_PLANS.TICKET_AMOUNT is '单票金额（面值）';
comment on column GAME_PLANS.PUBLISHER_CODE is '印制厂商（1=石家庄，3=中彩三场）';
comment on column GAME_PLANS.LOTTERY_TYPE is '彩票类型（1-标准、2-主动性）';

create table GAME_ORG_COMM_RATE(
	ORG_CODE CHAR(2)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	SALE_COMM NUMBER(8)  not null,
	PAY_COMM NUMBER(8)  not null,
	constraint PK_GAME_ORG_COMM_RATE primary Key (ORG_CODE,PLAN_CODE)
);
comment on table GAME_ORG_COMM_RATE is '机构方案佣金';
comment on column GAME_ORG_COMM_RATE.ORG_CODE is '部门编码';
comment on column GAME_ORG_COMM_RATE.PLAN_CODE is '方案编码';
comment on column GAME_ORG_COMM_RATE.SALE_COMM is '销售佣金比例';
comment on column GAME_ORG_COMM_RATE.PAY_COMM is '兑奖佣金比例';

create table GAME_AGENCY_COMM_RATE(
	AGENCY_CODE CHAR(8)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	SALE_COMM NUMBER(8)  not null,
	PAY_COMM NUMBER(8)  not null,
	constraint PK_GAME_AGENCY_COMM_RATE primary Key (AGENCY_CODE,PLAN_CODE)
);
comment on table GAME_AGENCY_COMM_RATE is '站点方案佣金';
comment on column GAME_AGENCY_COMM_RATE.AGENCY_CODE is '销售站编码';
comment on column GAME_AGENCY_COMM_RATE.PLAN_CODE is '方案编码';
comment on column GAME_AGENCY_COMM_RATE.SALE_COMM is '销售佣金比例';
comment on column GAME_AGENCY_COMM_RATE.PAY_COMM is '兑奖佣金比例';

create table GAME_BATCH_IMPORT(
	IMPORT_NO CHAR(12)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	PACKAGE_FILE VARCHAR2(500)  not null,
	REWARD_MAP_FILE VARCHAR2(500)  not null,
	REWARD_DETAIL_FILE VARCHAR2(500)  not null,
	START_DATE DATE  ,
	END_DATE DATE  ,
	IMPORT_ADMIN NUMBER(4)  not null,
	constraint PK_GAME_BATCH_IMPORT primary Key (IMPORT_NO)
);
comment on table GAME_BATCH_IMPORT is '批次信息导入';
comment on column GAME_BATCH_IMPORT.IMPORT_NO is '数据导入序号（IMP-12345678）';
comment on column GAME_BATCH_IMPORT.PLAN_CODE is '方案编码';
comment on column GAME_BATCH_IMPORT.BATCH_NO is '生产批次';
comment on column GAME_BATCH_IMPORT.PACKAGE_FILE is '包装信息文件';
comment on column GAME_BATCH_IMPORT.REWARD_MAP_FILE is '奖符构成表文件';
comment on column GAME_BATCH_IMPORT.REWARD_DETAIL_FILE is '中奖明细文件';
comment on column GAME_BATCH_IMPORT.START_DATE is '导入开始时间';
comment on column GAME_BATCH_IMPORT.END_DATE is '导入完成时间';
comment on column GAME_BATCH_IMPORT.IMPORT_ADMIN is '导入人';
create index UDX_GAME_BATCH_IMPORT on GAME_BATCH_IMPORT(PLAN_CODE,BATCH_NO);

create table GAME_BATCH_IMPORT_DETAIL(
	IMPORT_NO CHAR(12)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	LOTTERY_TYPE VARCHAR2(500)  not null,
	LOTTERY_NAME VARCHAR2(500)  not null,
	BOXES_EVERY_TRUNK NUMBER(10)  not null,
	TRUNKS_EVERY_GROUP NUMBER(10)  not null,
	PACKS_EVERY_TRUNK NUMBER(10)  not null,
	TICKETS_EVERY_PACK NUMBER(10)  not null,
	TICKETS_EVERY_GROUP NUMBER(18)  not null,
	FIRST_REWARD_GROUP_NO NUMBER(10)  not null,
	TICKETS_EVERY_BATCH NUMBER(18)  not null,
	FIRST_TRUNK_BATCH NUMBER(18)  not null,
	STATUS NUMBER(1)  not null,
	constraint PK_GAME_BATCH_IMPORT_DETAIL primary Key (IMPORT_NO)
);
comment on table GAME_BATCH_IMPORT_DETAIL is '批次信息导入之包装';
comment on column GAME_BATCH_IMPORT_DETAIL.IMPORT_NO is '数据导入序号（IMP-12345678）';
comment on column GAME_BATCH_IMPORT_DETAIL.PLAN_CODE is '方案编码';
comment on column GAME_BATCH_IMPORT_DETAIL.BATCH_NO is '生产批次';
comment on column GAME_BATCH_IMPORT_DETAIL.LOTTERY_TYPE is '彩票分类';
comment on column GAME_BATCH_IMPORT_DETAIL.LOTTERY_NAME is '彩票名称';
comment on column GAME_BATCH_IMPORT_DETAIL.BOXES_EVERY_TRUNK is '每箱盒数';
comment on column GAME_BATCH_IMPORT_DETAIL.TRUNKS_EVERY_GROUP is '每组箱数';
comment on column GAME_BATCH_IMPORT_DETAIL.PACKS_EVERY_TRUNK is '每箱本数';
comment on column GAME_BATCH_IMPORT_DETAIL.TICKETS_EVERY_PACK is '每本张数';
comment on column GAME_BATCH_IMPORT_DETAIL.TICKETS_EVERY_GROUP is '奖组张数（万张）';
comment on column GAME_BATCH_IMPORT_DETAIL.FIRST_REWARD_GROUP_NO is '首分组号';
comment on column GAME_BATCH_IMPORT_DETAIL.TICKETS_EVERY_BATCH is '批次张数';
comment on column GAME_BATCH_IMPORT_DETAIL.FIRST_TRUNK_BATCH is '批次首箱编号';
comment on column GAME_BATCH_IMPORT_DETAIL.STATUS is '状态（1-启用，2-暂停，3-退市）';
create index UDX_GAME_BATCH_IMPORT_DETAIL on GAME_BATCH_IMPORT_DETAIL(PLAN_CODE,BATCH_NO);

create table GAME_BATCH_IMPORT_REWARD(
	IMPORT_NO CHAR(12)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	REWARD_NO NUMBER(3)  not null,
	FAST_IDENTITY_CODE VARCHAR2(4000)  not null,
	SINGLE_REWARD_AMOUNT NUMBER(18)  not null,
	COUNTS NUMBER(18)  not null,
	constraint PK_GAME_BATCH_IMPORT_REWARD primary Key (IMPORT_NO,REWARD_NO)
);
comment on table GAME_BATCH_IMPORT_REWARD is '批次信息导入之奖符';
comment on column GAME_BATCH_IMPORT_REWARD.IMPORT_NO is '数据导入序号（IMP-12345678）';
comment on column GAME_BATCH_IMPORT_REWARD.PLAN_CODE is '方案编码';
comment on column GAME_BATCH_IMPORT_REWARD.BATCH_NO is '生产批次';
comment on column GAME_BATCH_IMPORT_REWARD.REWARD_NO is '奖级';
comment on column GAME_BATCH_IMPORT_REWARD.FAST_IDENTITY_CODE is '奖符快速识别码（奖符通过逗号进行分割）';
comment on column GAME_BATCH_IMPORT_REWARD.SINGLE_REWARD_AMOUNT is '单注中奖金额';
comment on column GAME_BATCH_IMPORT_REWARD.COUNTS is '总数量';
create index IDX_GAME_BATCH_REWARD_GAME on GAME_BATCH_IMPORT_REWARD(PLAN_CODE,BATCH_NO,REWARD_NO);

create table GAME_BATCH_REWARD_DETAIL(
	IMPORT_NO CHAR(12)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	SAFE_CODE VARCHAR2(50)  not null,
	IS_PAID NUMBER(1) default 0 not null,
  pre_safe_code generated always as (substr(SAFE_CODE,1,16)),
	constraint PK_GAME_BATCH_REWARD_DETAIL primary Key (IMPORT_NO,PLAN_CODE,BATCH_NO,SAFE_CODE)
);
comment on table GAME_BATCH_REWARD_DETAIL is '批次信息导入之中奖明细';
comment on column GAME_BATCH_REWARD_DETAIL.IMPORT_NO is '数据导入序号（IMP-12345678）';
comment on column GAME_BATCH_REWARD_DETAIL.PLAN_CODE is '方案编码';
comment on column GAME_BATCH_REWARD_DETAIL.BATCH_NO is '生产批次';
comment on column GAME_BATCH_REWARD_DETAIL.SAFE_CODE is '安全码';
comment on column GAME_BATCH_REWARD_DETAIL.pre_safe_code is '安全码前缀';
comment on column GAME_BATCH_REWARD_DETAIL.IS_PAID is '是否已经兑奖';
create index idx_GAME_BATCH_REWARD_pbs on game_batch_reward_detail(PLAN_CODE,BATCH_NO,SAFE_CODE);
create index idx_GAME_BATCH_REWARD_pre on game_batch_reward_detail(PLAN_CODE,BATCH_NO,pre_safe_code);

create table WH_INFO(
	WAREHOUSE_CODE CHAR(4)  not null,
	WAREHOUSE_NAME VARCHAR2(4000)  not null,
	ORG_CODE CHAR(2)  not null,
	ADDRESS VARCHAR2(4000)  not null,
	PHONE VARCHAR2(100)  not null,
	DIRECTOR_ADMIN NUMBER(4)  not null,
	STATUS NUMBER(1)  not null,
	CREATE_ADMIN NUMBER(4)  not null,
	CREATE_DATE DATE  not null,
	STOP_ADMIN NUMBER(4)  ,
	STOP_DATE DATE  ,
	constraint PK_WH_INFO primary Key (WAREHOUSE_CODE)
);
comment on table WH_INFO is '仓库基本信息';
comment on column WH_INFO.WAREHOUSE_CODE is '仓库编号（部门+序号）';
comment on column WH_INFO.WAREHOUSE_NAME is '仓库名称';
comment on column WH_INFO.ORG_CODE is '所属部门';
comment on column WH_INFO.ADDRESS is '仓库地址';
comment on column WH_INFO.PHONE is '联系电话';
comment on column WH_INFO.DIRECTOR_ADMIN is '负责人';
comment on column WH_INFO.STATUS is '状态（1-启用，2-停用，3-盘点中）';
comment on column WH_INFO.CREATE_ADMIN is '创建人';
comment on column WH_INFO.CREATE_DATE is '创建时间';
comment on column WH_INFO.STOP_ADMIN is '停用人';
comment on column WH_INFO.STOP_DATE is '停用时间';

create table WH_MANAGER(
	WAREHOUSE_CODE CHAR(4)  not null,
	ORG_CODE CHAR(2)  not null,
	MANAGER_ID NUMBER(4)  not null,
	IS_VALID NUMBER(1)  not null,
	START_TIME DATE  ,
	END_TIME DATE  ,
	constraint PK_WH_MANAGER primary Key (WAREHOUSE_CODE,MANAGER_ID)
);
comment on table WH_MANAGER is '仓库管理员信息';
comment on column WH_MANAGER.WAREHOUSE_CODE is '仓库编号';
comment on column WH_MANAGER.ORG_CODE is '所属部门';
comment on column WH_MANAGER.MANAGER_ID is '管理员';
comment on column WH_MANAGER.IS_VALID is '是否有效（1-有效，0-无效）';
comment on column WH_MANAGER.START_TIME is '生效时间';
comment on column WH_MANAGER.END_TIME is '停用时间';

create table WH_TICKET_TRUNK(
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	REWARD_GROUP NUMBER(2)  ,
	TRUNK_NO VARCHAR2(10)  not null,
	PACKAGE_NO_START VARCHAR2(10)  not null,
	PACKAGE_NO_END VARCHAR2(10)  not null,
	IS_FULL NUMBER(1) default 1 not null,
	STATUS NUMBER(2) default 11 not null,
	CURRENT_WAREHOUSE VARCHAR2(8)  ,
	LAST_WAREHOUSE VARCHAR2(8)  ,
	CREATE_DATE DATE default sysdate not null,
	CREATE_ADMIN NUMBER(4)  not null,
	CHANGE_ADMIN NUMBER(4)  ,
	CHANGE_DATE DATE  ,
	constraint PK_WH_TICKET_TRUNK primary Key (PLAN_CODE,BATCH_NO,TRUNK_NO)
);
comment on table WH_TICKET_TRUNK is '即开票信息（箱）';
comment on column WH_TICKET_TRUNK.PLAN_CODE is '方案';
comment on column WH_TICKET_TRUNK.BATCH_NO is '批次';
comment on column WH_TICKET_TRUNK.REWARD_GROUP is '奖组';
comment on column WH_TICKET_TRUNK.TRUNK_NO is '箱号';
comment on column WH_TICKET_TRUNK.PACKAGE_NO_START is '所含本号起';
comment on column WH_TICKET_TRUNK.PACKAGE_NO_END is '所含本号止';
comment on column WH_TICKET_TRUNK.IS_FULL is '是否完整';
comment on column WH_TICKET_TRUNK.STATUS is '状态（11-在库、12-在站点，20-在途，21-管理员持有，31-已销售、41-被盗、42-损坏、43-丢失）';
comment on column WH_TICKET_TRUNK.CURRENT_WAREHOUSE is '所在仓库（只有在完整的情况下，此值才有效）';
comment on column WH_TICKET_TRUNK.LAST_WAREHOUSE is '最近所在仓库（只有在完整的情况下，此值才有效）';
comment on column WH_TICKET_TRUNK.CREATE_DATE is '创建时间';
comment on column WH_TICKET_TRUNK.CREATE_ADMIN is '创建人';
comment on column WH_TICKET_TRUNK.CHANGE_ADMIN is '最进变动人';
comment on column WH_TICKET_TRUNK.CHANGE_DATE is '最进变动时间';

create table WH_TICKET_BOX(
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	REWARD_GROUP NUMBER(2)  not null,
	TRUNK_NO VARCHAR2(10)  not null,
	BOX_NO VARCHAR2(20)  not null,
	PACKAGE_NO_START VARCHAR2(10)  not null,
	PACKAGE_NO_END VARCHAR2(10)  not null,
	IS_FULL NUMBER(1) default 1 not null,
	STATUS NUMBER(2) default 11 not null,
	CURRENT_WAREHOUSE VARCHAR2(8)  ,
	LAST_WAREHOUSE VARCHAR2(8)  ,
	CREATE_DATE DATE default sysdate not null,
	CREATE_ADMIN NUMBER(4)  not null,
	CHANGE_ADMIN NUMBER(4)  ,
	CHANGE_DATE DATE  ,
	constraint PK_WH_TICKET_BOX primary Key (PLAN_CODE,BATCH_NO,TRUNK_NO,BOX_NO)
);
comment on table WH_TICKET_BOX is '即开票信息（盒）';
comment on column WH_TICKET_BOX.PLAN_CODE is '方案';
comment on column WH_TICKET_BOX.BATCH_NO is '批次';
comment on column WH_TICKET_BOX.REWARD_GROUP is '奖组';
comment on column WH_TICKET_BOX.TRUNK_NO is '箱号';
comment on column WH_TICKET_BOX.BOX_NO is '盒号（箱号+盒子顺序号）';
comment on column WH_TICKET_BOX.PACKAGE_NO_START is '所含本号起';
comment on column WH_TICKET_BOX.PACKAGE_NO_END is '所含本号止';
comment on column WH_TICKET_BOX.IS_FULL is '是否完整';
comment on column WH_TICKET_BOX.STATUS is '状态（11-在库、12-在站点，20-在途，21-管理员持有，31-已销售、41-被盗、42-损坏、43-丢失）';
comment on column WH_TICKET_BOX.CURRENT_WAREHOUSE is '所在仓库（只有在完整的情况下，此值才有效）';
comment on column WH_TICKET_BOX.LAST_WAREHOUSE is '最近所在仓库（只有在完整的情况下，此值才有效）';
comment on column WH_TICKET_BOX.CREATE_DATE is '创建时间';
comment on column WH_TICKET_BOX.CREATE_ADMIN is '创建人';
comment on column WH_TICKET_BOX.CHANGE_ADMIN is '最进变动人';
comment on column WH_TICKET_BOX.CHANGE_DATE is '最进变动时间';

create table WH_TICKET_PACKAGE(
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	REWARD_GROUP NUMBER(2)  not null,
	TRUNK_NO VARCHAR2(10)  not null,
	BOX_NO VARCHAR2(20)  not null,
	PACKAGE_NO VARCHAR2(10)  not null,
	TICKET_NO_START VARCHAR2(10)  not null,
	TICKET_NO_END VARCHAR2(10)  not null,
	IS_FULL NUMBER(1) default 1 not null,
	STATUS NUMBER(2) default 11 not null,
	CURRENT_WAREHOUSE VARCHAR2(8)  ,
	LAST_WAREHOUSE VARCHAR2(8)  ,
	CREATE_DATE DATE default sysdate not null,
	CREATE_ADMIN NUMBER(4)  not null,
	CHANGE_ADMIN NUMBER(4)  ,
	CHANGE_DATE DATE  ,
	constraint PK_WH_TICKET_PACKAGE primary Key (PLAN_CODE,BATCH_NO,TRUNK_NO,BOX_NO,PACKAGE_NO)
);
comment on table WH_TICKET_PACKAGE is '即开票信息（本）';
comment on column WH_TICKET_PACKAGE.PLAN_CODE is '方案';
comment on column WH_TICKET_PACKAGE.BATCH_NO is '批次';
comment on column WH_TICKET_PACKAGE.REWARD_GROUP is '奖组';
comment on column WH_TICKET_PACKAGE.TRUNK_NO is '箱号';
comment on column WH_TICKET_PACKAGE.BOX_NO is '盒号（箱号+盒子顺序号）';
comment on column WH_TICKET_PACKAGE.PACKAGE_NO is '本号';
comment on column WH_TICKET_PACKAGE.TICKET_NO_START is '所含票号起';
comment on column WH_TICKET_PACKAGE.TICKET_NO_END is '所含票号止';
comment on column WH_TICKET_PACKAGE.IS_FULL is '是否完整';
comment on column WH_TICKET_PACKAGE.STATUS is '状态（11-在库、12-在站点，20-在途，21-管理员持有，31-已销售、41-被盗、42-损坏、43-丢失）';
comment on column WH_TICKET_PACKAGE.CURRENT_WAREHOUSE is '所在仓库（只有在完整的情况下，此值才有效）';
comment on column WH_TICKET_PACKAGE.LAST_WAREHOUSE is '最近所在仓库（只有在完整的情况下，此值才有效）';
comment on column WH_TICKET_PACKAGE.CREATE_DATE is '创建时间';
comment on column WH_TICKET_PACKAGE.CREATE_ADMIN is '创建人';
comment on column WH_TICKET_PACKAGE.CHANGE_ADMIN is '最进变动人';
comment on column WH_TICKET_PACKAGE.CHANGE_DATE is '最进变动时间';

create table WH_BATCH_INBOUND(
	BI_NO CHAR(10)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	BATCH_TICKETS NUMBER(18)  not null,
	BATCH_AMOUNT NUMBER(28)  not null,
	ACT_TICKETS NUMBER(18) default 0 not null,
	ACT_AMOUNT NUMBER(28) default 0 not null,
	DISCREPANCY_TICKETS NUMBER(18) default 0 not null,
	DISCREPANCY_AMOUNT NUMBER(28) default 0 not null,
	DAMAGED_TICKETS NUMBER(18) default 0 not null,
	DAMAGED_AMOUNT NUMBER(28) default 0 not null,
	TRUNKS NUMBER(18) default 0 not null,
	BOXES NUMBER(18) default 0 not null,
	PACKAGES NUMBER(18) default 0 not null,
	CREATE_ADMIN NUMBER(4)  not null,
	CREATE_DATE DATE default sysdate not null,
	OPER_ADMIN NUMBER(4)  ,
	OPER_DATE DATE  ,
	constraint PK_WH_INBOUND primary Key (PLAN_CODE,BATCH_NO)
);
comment on table WH_BATCH_INBOUND is '批次入库';
comment on column WH_BATCH_INBOUND.BI_NO is '入库单编号(BI12345678)';
comment on column WH_BATCH_INBOUND.PLAN_CODE is '方案编码';
comment on column WH_BATCH_INBOUND.BATCH_NO is '批次';
comment on column WH_BATCH_INBOUND.BATCH_TICKETS is '批次应入库票数';
comment on column WH_BATCH_INBOUND.BATCH_AMOUNT is '批次应入库金额';
comment on column WH_BATCH_INBOUND.ACT_TICKETS is '实际入库票数';
comment on column WH_BATCH_INBOUND.ACT_AMOUNT is '实际库金额';
comment on column WH_BATCH_INBOUND.DISCREPANCY_TICKETS is '差异数量';
comment on column WH_BATCH_INBOUND.DISCREPANCY_AMOUNT is '差异金额';
comment on column WH_BATCH_INBOUND.DAMAGED_TICKETS is '损毁数量';
comment on column WH_BATCH_INBOUND.DAMAGED_AMOUNT is '损毁金额';
comment on column WH_BATCH_INBOUND.TRUNKS is '入库箱数';
comment on column WH_BATCH_INBOUND.BOXES is '入库盒数';
comment on column WH_BATCH_INBOUND.PACKAGES is '入库本数';
comment on column WH_BATCH_INBOUND.CREATE_ADMIN is '创建人';
comment on column WH_BATCH_INBOUND.CREATE_DATE is '创建时间';
comment on column WH_BATCH_INBOUND.OPER_ADMIN is '最终操作人';
comment on column WH_BATCH_INBOUND.OPER_DATE is '最终操作时间';
create index IDX_WH_INBOUND_NO on WH_BATCH_INBOUND(BI_NO);

create table WH_GOODS_ISSUE(
	SGI_NO CHAR(10)  not null,
	CREATE_ADMIN NUMBER(4)  not null,
	CREATE_DATE DATE default sysdate not null,
	ISSUE_END_TIME DATE  ,
	ISSUE_AMOUNT NUMBER(28) default 0 not null,
	ISSUE_TICKETS NUMBER(18) default 0 not null,
	ACT_ISSUE_AMOUNT NUMBER(28) default 0 not null,
	ACT_ISSUE_TICKETS NUMBER(18) default 0 not null,
	ISSUE_TYPE NUMBER(1)  not null,
	REF_NO CHAR(10)  not null,
	STATUS NUMBER(1) default 1 not null,
	CARRIER VARCHAR2(500)  ,
	CARRY_DATE DATE  ,
	CARRIER_CONTACT VARCHAR2(500)  ,
	SEND_ORG CHAR(2)  ,
	SEND_WH VARCHAR2(8)  ,
	RECEIVE_ADMIN NUMBER(4)  ,
	REMARK VARCHAR2(4000)  ,
	constraint PK_WH_GOODS_ISSUE primary Key (SGI_NO)
);
comment on table WH_GOODS_ISSUE is '出货单所包含的订单';
comment on column WH_GOODS_ISSUE.SGI_NO is '出库单编号（CK12345678）';
comment on column WH_GOODS_ISSUE.CREATE_ADMIN is '建立人';
comment on column WH_GOODS_ISSUE.CREATE_DATE is '建立时间';
comment on column WH_GOODS_ISSUE.ISSUE_END_TIME is '结束出库时间';
comment on column WH_GOODS_ISSUE.ISSUE_AMOUNT is '出库金额合计';
comment on column WH_GOODS_ISSUE.ISSUE_TICKETS is '出库张数合计';
comment on column WH_GOODS_ISSUE.ACT_ISSUE_AMOUNT is '实际出库金额合计';
comment on column WH_GOODS_ISSUE.ACT_ISSUE_TICKETS is '实际出库张数合计';
comment on column WH_GOODS_ISSUE.ISSUE_TYPE is '出库类型（1-调拨出库、2-出货单出库，3-损毁出库，4-站点退货）';
comment on column WH_GOODS_ISSUE.REF_NO is '参考编号';
comment on column WH_GOODS_ISSUE.STATUS is '状态（1-未完成，2-已完成）';
comment on column WH_GOODS_ISSUE.CARRIER is '提货人';
comment on column WH_GOODS_ISSUE.CARRY_DATE is '提货时间';
comment on column WH_GOODS_ISSUE.CARRIER_CONTACT is '提货人联系方式';
comment on column WH_GOODS_ISSUE.SEND_ORG is '出库仓库所属单位';
comment on column WH_GOODS_ISSUE.SEND_WH is '出库仓库';
comment on column WH_GOODS_ISSUE.RECEIVE_ADMIN is '接收人';
comment on column WH_GOODS_ISSUE.REMARK is '备注';

create table WH_GOODS_ISSUE_DETAIL(
	SGI_NO CHAR(10)  not null,
	SEQUENCE_NO NUMBER(24)  not null,
	ISSUE_TYPE NUMBER(1)  ,
	REF_NO CHAR(10)  ,
	VALID_NUMBER NUMBER(1)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNK_NO VARCHAR2(10)  not null,
	BOX_NO VARCHAR2(20)  not null,
	PACKAGE_NO VARCHAR2(10)  not null,
	TICKETS NUMBER(18)  not null,
	AMOUNT NUMBER(28)  not null,
	constraint PK_WH_GOODS_ISSUE_DETAIL primary Key (SEQUENCE_NO)
);
comment on table WH_GOODS_ISSUE_DETAIL is '出库单明细';
comment on column WH_GOODS_ISSUE_DETAIL.SGI_NO is '出库单编号（CK12345678）';
comment on column WH_GOODS_ISSUE_DETAIL.SEQUENCE_NO is '顺序号';
comment on column WH_GOODS_ISSUE_DETAIL.ISSUE_TYPE is '出库类型（1-调拨出库、2-出货单出库，3-损毁出库，4-站点退货）';
comment on column WH_GOODS_ISSUE_DETAIL.REF_NO is '出货参考编号';
comment on column WH_GOODS_ISSUE_DETAIL.VALID_NUMBER is '有效位数（1-箱号、2-盒号、3-本号）';
comment on column WH_GOODS_ISSUE_DETAIL.PLAN_CODE is '方案编码';
comment on column WH_GOODS_ISSUE_DETAIL.BATCH_NO is '批次';
comment on column WH_GOODS_ISSUE_DETAIL.TRUNK_NO is '箱号';
comment on column WH_GOODS_ISSUE_DETAIL.BOX_NO is '盒号（箱号+盒子顺序号）';
comment on column WH_GOODS_ISSUE_DETAIL.PACKAGE_NO is '本号';
comment on column WH_GOODS_ISSUE_DETAIL.TICKETS is '票数';
comment on column WH_GOODS_ISSUE_DETAIL.AMOUNT is '金额';
create index IDX_WH_GI_DETAIL_SGI on WH_GOODS_ISSUE_DETAIL(SGI_NO);
create index IDX_WH_GI_DETAIL_ALL on WH_GOODS_ISSUE_DETAIL(PLAN_CODE,BATCH_NO,TRUNK_NO,BOX_NO,PACKAGE_NO);
create index IDX_WH_GI_DETAIL_REF on WH_GOODS_ISSUE_DETAIL(REF_NO);

create table WH_GOODS_RECEIPT(
	SGR_NO CHAR(10)  not null,
	CREATE_ADMIN NUMBER(4)  not null,
	CREATE_DATE DATE default sysdate not null,
	RECEIPT_END_TIME DATE  ,
	RECEIPT_AMOUNT NUMBER(28) default 0 not null,
	RECEIPT_TICKETS NUMBER(18) default 0 not null,
	ACT_RECEIPT_AMOUNT NUMBER(28) default 0 not null,
	ACT_RECEIPT_TICKETS NUMBER(18) default 0 not null,
	RECEIPT_TYPE NUMBER(1)  not null,
	REF_NO CHAR(10)  not null,
	STATUS NUMBER(1) default 1 not null,
	CARRIER VARCHAR2(500)  ,
	CARRY_DATE DATE  ,
	CARRIER_CONTACT VARCHAR2(500)  ,
	RECEIVE_ORG CHAR(2)  ,
	RECEIVE_WH VARCHAR2(8)  not null,
	SEND_ADMIN NUMBER(4)  ,
	REMARK VARCHAR2(4000)  ,
	constraint PK_WH_GOODS_RECEIPT primary Key (SGR_NO)
);
comment on table WH_GOODS_RECEIPT is '入库单';
comment on column WH_GOODS_RECEIPT.SGR_NO is '入库单编号（RK12345678）';
comment on column WH_GOODS_RECEIPT.CREATE_ADMIN is '建立人';
comment on column WH_GOODS_RECEIPT.CREATE_DATE is '建立时间';
comment on column WH_GOODS_RECEIPT.RECEIPT_END_TIME is '结束入库时间';
comment on column WH_GOODS_RECEIPT.RECEIPT_AMOUNT is '入库金额合计';
comment on column WH_GOODS_RECEIPT.RECEIPT_TICKETS is '入库张数合计';
comment on column WH_GOODS_RECEIPT.ACT_RECEIPT_AMOUNT is '实际入库金额合计';
comment on column WH_GOODS_RECEIPT.ACT_RECEIPT_TICKETS is '实际入库张数合计';
comment on column WH_GOODS_RECEIPT.RECEIPT_TYPE is '入库类型（1-批次入库、2-调拨单入库、3-还货入库、4-站点入库）';
comment on column WH_GOODS_RECEIPT.REF_NO is '参考编号';
comment on column WH_GOODS_RECEIPT.STATUS is '状态（1-未完成，2-已完成）';
comment on column WH_GOODS_RECEIPT.CARRIER is '送货人';
comment on column WH_GOODS_RECEIPT.CARRY_DATE is '送货时间';
comment on column WH_GOODS_RECEIPT.CARRIER_CONTACT is '送货人联系方式';
comment on column WH_GOODS_RECEIPT.RECEIVE_ORG is '入库仓库所属单位';
comment on column WH_GOODS_RECEIPT.RECEIVE_WH is '入库仓库';
comment on column WH_GOODS_RECEIPT.SEND_ADMIN is '发送人员';
comment on column WH_GOODS_RECEIPT.REMARK is '备注';

create table WH_GOODS_RECEIPT_DETAIL(
	SGR_NO CHAR(10)  not null,
	SEQUENCE_NO NUMBER(24)  not null,
	RECEIPT_TYPE NUMBER(1)  ,
	REF_NO CHAR(10)  ,
	VALID_NUMBER NUMBER(1)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNK_NO VARCHAR2(10)  ,
	BOX_NO VARCHAR2(20)  ,
	PACKAGE_NO VARCHAR2(10)  ,
	TICKETS NUMBER(18)  not null,
	AMOUNT NUMBER(28)  not null,
	CREATE_ADMIN NUMBER(4)  ,
	CREATE_DATE DATE  ,
	constraint PK_WH_GOODS_RECEIPT_DETAIL primary Key (SEQUENCE_NO)
);
comment on table WH_GOODS_RECEIPT_DETAIL is '入库单明细';
comment on column WH_GOODS_RECEIPT_DETAIL.SGR_NO is '入库单编号';
comment on column WH_GOODS_RECEIPT_DETAIL.SEQUENCE_NO is '顺序号';
comment on column WH_GOODS_RECEIPT_DETAIL.RECEIPT_TYPE is '入库类型（1-批次入库、2-调拨单入库、3-退货入库、4-站点入库）';
comment on column WH_GOODS_RECEIPT_DETAIL.REF_NO is '参考编号';
comment on column WH_GOODS_RECEIPT_DETAIL.VALID_NUMBER is '有效位数（1-箱号、2-盒号、3-本号）';
comment on column WH_GOODS_RECEIPT_DETAIL.PLAN_CODE is '方案编码';
comment on column WH_GOODS_RECEIPT_DETAIL.BATCH_NO is '批次';
comment on column WH_GOODS_RECEIPT_DETAIL.TRUNK_NO is '箱号';
comment on column WH_GOODS_RECEIPT_DETAIL.BOX_NO is '盒号（箱号+盒子顺序号）';
comment on column WH_GOODS_RECEIPT_DETAIL.PACKAGE_NO is '本号';
comment on column WH_GOODS_RECEIPT_DETAIL.TICKETS is '票数';
comment on column WH_GOODS_RECEIPT_DETAIL.AMOUNT is '金额';
comment on column WH_GOODS_RECEIPT_DETAIL.CREATE_ADMIN is '建立人';
comment on column WH_GOODS_RECEIPT_DETAIL.CREATE_DATE is '建立时间';
create index IDX_WH_GR_DETAIL_SGR on WH_GOODS_RECEIPT_DETAIL(SGR_NO);
create index IDX_WH_GR_DETAIL_ALL on WH_GOODS_RECEIPT_DETAIL(PLAN_CODE,BATCH_NO,TRUNK_NO,BOX_NO,PACKAGE_NO);
create index IDX_WH_GR_DETAIL_REF on WH_GOODS_RECEIPT_DETAIL(REF_NO);

create table WH_CHECK_POINT(
	CP_NO CHAR(10)  not null,
	WAREHOUSE_CODE CHAR(4)  not null,
	CP_NAME VARCHAR2(4000)  not null,
	PLAN_CODE VARCHAR2(10)  ,
	BATCH_NO VARCHAR2(10)  ,
	STATUS NUMBER(1)  not null,
	RESULT NUMBER(1)  not null,
	NOMATCH_TICKETS NUMBER(18)  ,
	NOMATCH_AMOUNT NUMBER(28)  ,
	CP_ADMIN NUMBER(4)  not null,
	CP_DATE DATE  not null,
	REMARK VARCHAR2(4000)  ,
	constraint PK_WH_CHECK_POINT primary Key (CP_NO)
);
comment on table WH_CHECK_POINT is '盘点单';
comment on column WH_CHECK_POINT.CP_NO is '盘点单编号（PD12345678）';
comment on column WH_CHECK_POINT.WAREHOUSE_CODE is '仓库名称';
comment on column WH_CHECK_POINT.CP_NAME is '盘点名称';
comment on column WH_CHECK_POINT.PLAN_CODE is '方案编码';
comment on column WH_CHECK_POINT.BATCH_NO is '批次';
comment on column WH_CHECK_POINT.STATUS is '盘点状态（1-盘点中，2-盘点结束）';
comment on column WH_CHECK_POINT.RESULT is '盘点结果（1-一致，2-盘亏，3-盘盈）';
comment on column WH_CHECK_POINT.NOMATCH_TICKETS is '差错票数';
comment on column WH_CHECK_POINT.NOMATCH_AMOUNT is '差错金额';
comment on column WH_CHECK_POINT.CP_ADMIN is '盘点人';
comment on column WH_CHECK_POINT.CP_DATE is '盘点日期';
comment on column WH_CHECK_POINT.REMARK is '备注';

create table WH_CHECK_POINT_DETAIL_BE(
	CP_NO CHAR(10)  not null,
	SEQUENCE_NO NUMBER(24)  not null,
	VALID_NUMBER NUMBER(1)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNK_NO VARCHAR2(10)  not null,
	BOX_NO VARCHAR2(20)  ,
	PACKAGE_NO VARCHAR2(10)  ,
	PACKAGES NUMBER(4)  not null,
	AMOUNT NUMBER(18)  not null,
	constraint PK_WH_CHECK_POINT_DETAIL_BE primary Key (SEQUENCE_NO)
);
comment on table WH_CHECK_POINT_DETAIL_BE is '盘点前库存明细';
comment on column WH_CHECK_POINT_DETAIL_BE.CP_NO is '盘点单编号（PD12345678）';
comment on column WH_CHECK_POINT_DETAIL_BE.SEQUENCE_NO is '顺序号';
comment on column WH_CHECK_POINT_DETAIL_BE.VALID_NUMBER is '有效位数（1-箱号、2-盒号、3-本号）';
comment on column WH_CHECK_POINT_DETAIL_BE.PLAN_CODE is '方案编码';
comment on column WH_CHECK_POINT_DETAIL_BE.BATCH_NO is '批次';
comment on column WH_CHECK_POINT_DETAIL_BE.TRUNK_NO is '箱号';
comment on column WH_CHECK_POINT_DETAIL_BE.BOX_NO is '盒号（箱号+盒子顺序号）';
comment on column WH_CHECK_POINT_DETAIL_BE.PACKAGE_NO is '本号';
comment on column WH_CHECK_POINT_DETAIL_BE.PACKAGES is '本数';
comment on column WH_CHECK_POINT_DETAIL_BE.AMOUNT is '金额';
create index IDX_WH_CP_DETAIL_BE_CP on WH_CHECK_POINT_DETAIL_BE(CP_NO);

create table WH_CHECK_POINT_DETAIL(
	CP_NO CHAR(10)  not null,
	SEQUENCE_NO NUMBER(24)  not null,
	VALID_NUMBER NUMBER(1)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNK_NO VARCHAR2(10)  not null,
	BOX_NO VARCHAR2(20)  ,
	PACKAGE_NO VARCHAR2(10)  ,
	PACKAGES NUMBER(4)  not null,
	AMOUNT NUMBER(18)  not null,
	constraint PK_WH_CHECK_POINT_DETAIL primary Key (SEQUENCE_NO)
);
comment on table WH_CHECK_POINT_DETAIL is '盘点结果明细';
comment on column WH_CHECK_POINT_DETAIL.CP_NO is '盘点单编号（PD12345678）';
comment on column WH_CHECK_POINT_DETAIL.SEQUENCE_NO is '顺序号';
comment on column WH_CHECK_POINT_DETAIL.VALID_NUMBER is '有效位数（1-箱号、2-盒号、3-本号）';
comment on column WH_CHECK_POINT_DETAIL.PLAN_CODE is '方案编码';
comment on column WH_CHECK_POINT_DETAIL.BATCH_NO is '批次';
comment on column WH_CHECK_POINT_DETAIL.TRUNK_NO is '箱号';
comment on column WH_CHECK_POINT_DETAIL.BOX_NO is '盒号（箱号+盒子顺序号）';
comment on column WH_CHECK_POINT_DETAIL.PACKAGE_NO is '本号';
comment on column WH_CHECK_POINT_DETAIL.PACKAGES is '本数';
comment on column WH_CHECK_POINT_DETAIL.AMOUNT is '金额';
create index IDX_WH_CP_DETAIL_CP on WH_CHECK_POINT_DETAIL(CP_NO);

create table WH_CP_NOMATCH_DETAIL(
	CP_NO CHAR(10)  not null,
	SEQUENCE_NO NUMBER(24)  not null,
	VALID_NUMBER NUMBER(1)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNK_NO VARCHAR2(10)  not null,
	BOX_NO VARCHAR2(20)  ,
	PACKAGE_NO VARCHAR2(10)  ,
	PACKAGES NUMBER(4)  not null,
	AMOUNT NUMBER(18)  not null,
	constraint PK_WH_CP_NOMATCH_DETAIL primary Key (SEQUENCE_NO)
);
comment on table WH_CP_NOMATCH_DETAIL is '盘点差错明细';
comment on column WH_CP_NOMATCH_DETAIL.CP_NO is '盘点单编号（PD12345678）';
comment on column WH_CP_NOMATCH_DETAIL.SEQUENCE_NO is '顺序号';
comment on column WH_CP_NOMATCH_DETAIL.VALID_NUMBER is '有效位数（1-箱号、2-盒号、3-本号）';
comment on column WH_CP_NOMATCH_DETAIL.PLAN_CODE is '方案编码';
comment on column WH_CP_NOMATCH_DETAIL.BATCH_NO is '批次';
comment on column WH_CP_NOMATCH_DETAIL.TRUNK_NO is '箱号';
comment on column WH_CP_NOMATCH_DETAIL.BOX_NO is '盒号（箱号+盒子顺序号）';
comment on column WH_CP_NOMATCH_DETAIL.PACKAGE_NO is '本号';
comment on column WH_CP_NOMATCH_DETAIL.PACKAGES is '本数';
comment on column WH_CP_NOMATCH_DETAIL.AMOUNT is '金额';
create index IDX_WH_CPN_DETAIL_CP on WH_CP_NOMATCH_DETAIL(CP_NO);

create table WH_BROKEN_RECODER(
	BROKEN_NO CHAR(10)  not null,
	APPLY_ADMIN NUMBER(4)  ,
	APPLY_DATE DATE  not null,
	SOURCE NUMBER(1)  not null,
	STB_NO CHAR(10)  ,
	CP_NO CHAR(10)  ,
	PACKAGES NUMBER(18)  ,
	TOTAL_AMOUNT NUMBER(28)  ,
	REASON NUMBER(2)  ,
	REMARK VARCHAR2(4000)  ,
	constraint PK_WH_BROKEN_RECODER primary Key (BROKEN_NO)
);
comment on table WH_BROKEN_RECODER is '损毁单';
comment on column WH_BROKEN_RECODER.BROKEN_NO is '损毁单编号（SH12345678）';
comment on column WH_BROKEN_RECODER.APPLY_ADMIN is '填报人';
comment on column WH_BROKEN_RECODER.APPLY_DATE is '填报日期';
comment on column WH_BROKEN_RECODER.SOURCE is '生成来源（1-人工录入，2-调拨单生成，3-盘点生成）';
comment on column WH_BROKEN_RECODER.STB_NO is '调拨单编号';
comment on column WH_BROKEN_RECODER.CP_NO is '盘点单编号';
comment on column WH_BROKEN_RECODER.PACKAGES is '涉及本数';
comment on column WH_BROKEN_RECODER.TOTAL_AMOUNT is '涉及金额';
comment on column WH_BROKEN_RECODER.REASON is '损毁原因（41-被盗、42-损坏、43-丢失）';
comment on column WH_BROKEN_RECODER.REMARK is '备注';

create table WH_BROKEN_RECODER_DETAIL(
	BROKEN_NO CHAR(10)  not null,
	SEQUENCE_NO NUMBER(24)  not null,
	VALID_NUMBER NUMBER(1)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNK_NO VARCHAR2(10)  not null,
	BOX_NO VARCHAR2(20)  ,
	PACKAGE_NO VARCHAR2(10)  ,
	PACKAGES NUMBER(18)  not null,
	AMOUNT NUMBER(28)  not null,
	constraint PK_WH_BROKEN_RECODER_DETAIL primary Key (SEQUENCE_NO)
);
comment on table WH_BROKEN_RECODER_DETAIL is '损毁单明细';
comment on column WH_BROKEN_RECODER_DETAIL.BROKEN_NO is '损毁单编号（SH12345678）';
comment on column WH_BROKEN_RECODER_DETAIL.SEQUENCE_NO is '顺序号';
comment on column WH_BROKEN_RECODER_DETAIL.VALID_NUMBER is '有效位数（1-箱号、2-盒号、3-本号）';
comment on column WH_BROKEN_RECODER_DETAIL.PLAN_CODE is '方案编码';
comment on column WH_BROKEN_RECODER_DETAIL.BATCH_NO is '批次';
comment on column WH_BROKEN_RECODER_DETAIL.TRUNK_NO is '箱号';
comment on column WH_BROKEN_RECODER_DETAIL.BOX_NO is '盒号（箱号+盒子顺序号）';
comment on column WH_BROKEN_RECODER_DETAIL.PACKAGE_NO is '本号';
comment on column WH_BROKEN_RECODER_DETAIL.PACKAGES is '本数';
comment on column WH_BROKEN_RECODER_DETAIL.AMOUNT is '金额';
create index IDX_WH_BR_DETAIL_BR on WH_BROKEN_RECODER_DETAIL(BROKEN_NO);

create table WH_BATCH_END(
	BE_NO CHAR(10)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TICKETS NUMBER(28)  not null,
	SALE_AMOUNT NUMBER(28)  not null,
	PAY_AMOUNT NUMBER(28)  not null,
	INVENTORY_TICKETS NUMBER(28)  not null,
	CREATE_ADMIN NUMBER(4)  not null,
	CREATE_DATE DATE  not null,
	constraint PK_WH_BATCH_END primary Key (BE_NO)
);
comment on table WH_BATCH_END is '批次终结';
comment on column WH_BATCH_END.BE_NO is '批次终结编号（ZJ12345678）';
comment on column WH_BATCH_END.PLAN_CODE is '方案编码';
comment on column WH_BATCH_END.BATCH_NO is '批次';
comment on column WH_BATCH_END.TICKETS is '批次总数（张）';
comment on column WH_BATCH_END.SALE_AMOUNT is '销售数量（张）';
comment on column WH_BATCH_END.PAY_AMOUNT is '兑奖金额（瑞尔）';
comment on column WH_BATCH_END.INVENTORY_TICKETS is '库存数量（张）';
comment on column WH_BATCH_END.CREATE_ADMIN is '填报人';
comment on column WH_BATCH_END.CREATE_DATE is '填报日期';
create index UDX_WH_BATCH_END on WH_BATCH_END(PLAN_CODE,BATCH_NO);

create table SALE_ORDER(
	ORDER_NO CHAR(10)  not null,
	APPLY_ADMIN NUMBER(4)  ,
	APPLY_DATE DATE  not null,
	APPLY_AGENCY CHAR(8)  not null,
	SENDER_ADMIN NUMBER(4)  ,
	SEND_WAREHOUSE CHAR(4)  ,
	SEND_DATE DATE  ,
	CARRIER_ADMIN NUMBER(4)  ,
	CARRY_DATE DATE  ,
	APPLY_CONTACT VARCHAR2(50)  ,
	STATUS NUMBER(1) default 1 not null,
	IS_INSTANT_ORDER NUMBER(1) default 0 not null,
	APPLY_TICKETS NUMBER(16) default 0 not null,
	APPLY_AMOUNT NUMBER(28) default 0 not null,
	GOODS_TICKETS NUMBER(16) default 0 ,
	GOODS_AMOUNT NUMBER(28) default 0 ,
	REMARK VARCHAR2(4000)  ,
	constraint PK_SALE_ORDER primary Key (ORDER_NO)
);
comment on table SALE_ORDER is '订单';
comment on column SALE_ORDER.ORDER_NO is '订单编号（DD 12345678）';
comment on column SALE_ORDER.APPLY_ADMIN is '申请人（站点自行在终端机申请，此项为空）';
comment on column SALE_ORDER.APPLY_DATE is '申请时间';
comment on column SALE_ORDER.APPLY_AGENCY is '订货站点';
comment on column SALE_ORDER.SENDER_ADMIN is '发货人';
comment on column SALE_ORDER.SEND_WAREHOUSE is '发货仓库';
comment on column SALE_ORDER.SEND_DATE is '发货时间';
comment on column SALE_ORDER.CARRIER_ADMIN is '配送人';
comment on column SALE_ORDER.CARRY_DATE is '配送时间';
comment on column SALE_ORDER.APPLY_CONTACT is '站点联系方式';
comment on column SALE_ORDER.STATUS is '状态（1-已提交，2-已撤销，3-已受理，4-已发货，5-已收货，6-已审批，7-已拒绝）';
comment on column SALE_ORDER.IS_INSTANT_ORDER is '是否即时订单（即时订单则不生成“订单申请明细”，直接生成“订单收货明细”）';
comment on column SALE_ORDER.APPLY_TICKETS is '申请总票数';
comment on column SALE_ORDER.APPLY_AMOUNT is '申请总金额';
comment on column SALE_ORDER.GOODS_TICKETS is '收货总票数';
comment on column SALE_ORDER.GOODS_AMOUNT is '收货总金额';
comment on column SALE_ORDER.REMARK is '备注';

create table SALE_ORDER_APPLY_DETAIL(
	ORDER_NO CHAR(10)  not null,
	SEQUENCE_NO NUMBER(24)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	TICKETS NUMBER(18) default 0 not null,
	PACKAGES NUMBER(18) default 0 not null,
	AMOUNT NUMBER(28) default 0 not null,
	REMARK VARCHAR2(4000)  ,
	constraint PK_SALE_ORDER_APPLY_DETAIL primary Key (SEQUENCE_NO)
);
comment on table SALE_ORDER_APPLY_DETAIL is '订单申请明细';
comment on column SALE_ORDER_APPLY_DETAIL.ORDER_NO is '订单编号（DD 12345678）';
comment on column SALE_ORDER_APPLY_DETAIL.SEQUENCE_NO is '顺序号';
comment on column SALE_ORDER_APPLY_DETAIL.PLAN_CODE is '方案编码';
comment on column SALE_ORDER_APPLY_DETAIL.TICKETS is '票数';
comment on column SALE_ORDER_APPLY_DETAIL.PACKAGES is '本数';
comment on column SALE_ORDER_APPLY_DETAIL.AMOUNT is '金额';
comment on column SALE_ORDER_APPLY_DETAIL.REMARK is '备注';

create table SALE_DELIVERY_ORDER(
	DO_NO CHAR(10)  not null,
	APPLY_ADMIN NUMBER(4)  not null,
	APPLY_DATE DATE  not null,
	WH_CODE CHAR(4)  ,
	WH_ORG CHAR(2)  ,
	WH_ADMIN NUMBER(4)  ,
	OUT_DATE DATE  ,
	STATUS NUMBER(1) default 1 not null,
	TICKETS NUMBER(18) default 0 not null,
	AMOUNT NUMBER(28) default 0 not null,
	ACT_TICKETS NUMBER(18) default 0 ,
	ACT_AMOUNT NUMBER(28) default 0 ,
	REMARK VARCHAR2(4000)  ,
	constraint PK_SALE_DELIVERY_ORDER primary Key (DO_NO)
);
comment on table SALE_DELIVERY_ORDER is ' 出货单';
comment on column SALE_DELIVERY_ORDER.DO_NO is '出货单编号（CH12345678）';
comment on column SALE_DELIVERY_ORDER.APPLY_ADMIN is '申请人';
comment on column SALE_DELIVERY_ORDER.APPLY_DATE is '申请日期';
comment on column SALE_DELIVERY_ORDER.WH_CODE is '出货仓库';
comment on column SALE_DELIVERY_ORDER.WH_ORG is '仓库所属部门';
comment on column SALE_DELIVERY_ORDER.WH_ADMIN is '仓库管理员';
comment on column SALE_DELIVERY_ORDER.OUT_DATE is '出货日期';
comment on column SALE_DELIVERY_ORDER.STATUS is '状态（1-已提交，2-已撤销，3-已受理，4-已发货，5-收货中，6-已收货，7-已审批，8-已拒绝）';
comment on column SALE_DELIVERY_ORDER.TICKETS is '应出货票数';
comment on column SALE_DELIVERY_ORDER.AMOUNT is '应出货金额';
comment on column SALE_DELIVERY_ORDER.ACT_TICKETS is '实际出货票数';
comment on column SALE_DELIVERY_ORDER.ACT_AMOUNT is '实际出货金额';
comment on column SALE_DELIVERY_ORDER.REMARK is '备注';

create table SALE_DELIVERY_ORDER_DETAIL(
	DO_NO CHAR(10)  not null,
	SEQUENCE_NO NUMBER(24)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	TICKETS NUMBER(18) default 0 not null,
	PACKAGES NUMBER(18) default 0 not null,
	AMOUNT NUMBER(28) default 0 not null,
	constraint PK_SALE_DELIVERY_ORDER_DETAIL primary Key (SEQUENCE_NO)
);
comment on table SALE_DELIVERY_ORDER_DETAIL is '出货单申请明细';
comment on column SALE_DELIVERY_ORDER_DETAIL.DO_NO is '出货单编号（CH12345678）';
comment on column SALE_DELIVERY_ORDER_DETAIL.SEQUENCE_NO is '顺序号';
comment on column SALE_DELIVERY_ORDER_DETAIL.PLAN_CODE is '方案编码';
comment on column SALE_DELIVERY_ORDER_DETAIL.TICKETS is '票数';
comment on column SALE_DELIVERY_ORDER_DETAIL.PACKAGES is '本数';
comment on column SALE_DELIVERY_ORDER_DETAIL.AMOUNT is '金额';

create table SALE_DELIVERY_ORDER_ALL(
	DO_NO CHAR(10)  not null,
	ORDER_NO CHAR(10)  not null,
	constraint PK_SALE_DELIVERY_ORDER_ALL primary Key (DO_NO,ORDER_NO)
);
comment on table SALE_DELIVERY_ORDER_ALL is '出货单所包含的订单';
comment on column SALE_DELIVERY_ORDER_ALL.DO_NO is '出货单编号（CH12345678）';
comment on column SALE_DELIVERY_ORDER_ALL.ORDER_NO is '订单编号（DD12345678）';

create table SALE_TRANSFER_BILL(
	STB_NO CHAR(10)  not null,
	APPLY_ADMIN NUMBER(4)  not null,
	APPLY_DATE DATE  not null,
	APPROVE_ADMIN NUMBER(4)  ,
	APPROVE_DATE DATE  ,
	SEND_ORG CHAR(2)  ,
	SEND_WH CHAR(4)  ,
	SEND_MANAGER NUMBER(4)  ,
	SEND_DATE DATE  ,
	RECEIVE_ORG CHAR(2)  ,
	RECEIVE_WH CHAR(4)  ,
	RECEIVE_MANAGER NUMBER(4)  ,
	RECEIVE_DATE DATE  ,
	TICKETS NUMBER(18) default 0 ,
	AMOUNT NUMBER(28) default 0 ,
	ACT_TICKETS NUMBER(18) default 0 ,
	ACT_AMOUNT NUMBER(28) default 0 ,
	STATUS NUMBER(1) default 1 not null,
	IS_MATCH NUMBER(1) default 0 not null,
	REMARK VARCHAR2(4000)  ,
	constraint PK_SALE_TRANSFER_BILL primary Key (STB_NO)
);
comment on table SALE_TRANSFER_BILL is '调拨单';
comment on column SALE_TRANSFER_BILL.STB_NO is '调拨单编号（DB12345678）';
comment on column SALE_TRANSFER_BILL.APPLY_ADMIN is '提交人';
comment on column SALE_TRANSFER_BILL.APPLY_DATE is '申请日期';
comment on column SALE_TRANSFER_BILL.APPROVE_ADMIN is '审批人';
comment on column SALE_TRANSFER_BILL.APPROVE_DATE is '审批日期';
comment on column SALE_TRANSFER_BILL.SEND_ORG is '发货单位';
comment on column SALE_TRANSFER_BILL.SEND_WH is '发货仓库';
comment on column SALE_TRANSFER_BILL.SEND_MANAGER is '发货仓库管理员';
comment on column SALE_TRANSFER_BILL.SEND_DATE is '发货时间';
comment on column SALE_TRANSFER_BILL.RECEIVE_ORG is '收货单位';
comment on column SALE_TRANSFER_BILL.RECEIVE_WH is '收货仓库';
comment on column SALE_TRANSFER_BILL.RECEIVE_MANAGER is '收货仓库管理员';
comment on column SALE_TRANSFER_BILL.RECEIVE_DATE is '收货时间';
comment on column SALE_TRANSFER_BILL.TICKETS is '应调拨票数';
comment on column SALE_TRANSFER_BILL.AMOUNT is '应调拨票数涉及金额';
comment on column SALE_TRANSFER_BILL.ACT_TICKETS is '实际调拨票数';
comment on column SALE_TRANSFER_BILL.ACT_AMOUNT is '实际调拨票数涉及金额';
comment on column SALE_TRANSFER_BILL.STATUS is '状态（1-已提交，2-已撤销，3-已受理，4-已发货，5-收货中，6-已收货，7-已审批，8-已拒绝）';
comment on column SALE_TRANSFER_BILL.IS_MATCH is '收货是否有差错（1-无差错，0-有差错）';
comment on column SALE_TRANSFER_BILL.REMARK is '备注';

create table SALE_TB_APPLY_DETAIL(
	STB_NO CHAR(10)  not null,
	SEQUENCE_NO NUMBER(24)  ,
	PLAN_CODE VARCHAR2(10)  not null,
	TICKETS NUMBER(18) default 0 not null,
	PACKAGES NUMBER(18) default 0 not null,
	AMOUNT NUMBER(28) default 0 not null,
	REMARK VARCHAR2(4000)  ,
	constraint PK_SALE_TB_APPLY_DETAIL primary Key (SEQUENCE_NO)
);
comment on table SALE_TB_APPLY_DETAIL is '调拨单申请明细';
comment on column SALE_TB_APPLY_DETAIL.STB_NO is '调拨单编号（DB12345678）';
comment on column SALE_TB_APPLY_DETAIL.SEQUENCE_NO is '顺序号';
comment on column SALE_TB_APPLY_DETAIL.PLAN_CODE is '方案编码';
comment on column SALE_TB_APPLY_DETAIL.TICKETS is '票数';
comment on column SALE_TB_APPLY_DETAIL.PACKAGES is '本数';
comment on column SALE_TB_APPLY_DETAIL.AMOUNT is '金额';
comment on column SALE_TB_APPLY_DETAIL.REMARK is '备注';

create table SALE_RETURN_RECODER(
	RETURN_NO CHAR(10)  not null,
	MARKET_MANAGER_ADMIN NUMBER(4)  not null,
	APPLY_DATE DATE  not null,
	APPLY_TICKETS NUMBER(10) default 0 not null,
	APPLY_AMOUNT NUMBER(18) default 0 not null,
	FINANCE_ADMIN NUMBER(4)  ,
	APPROVE_DATE DATE  ,
	APPROVE_REMARK VARCHAR2(4000)  ,
	ACT_TICKETS NUMBER(10) default 0 ,
	ACT_AMOUNT NUMBER(18) default 0 ,
	STATUS  NUMBER(1)  not null,
	IS_DIRECT_AUDITED NUMBER(1) default 0 not null,
	DIRECT_AMOUNT NUMBER(18)  ,
	RECEIVE_ORG CHAR(2)  ,
	RECEIVE_WH CHAR(4)  ,
	RECEIVE_MANAGER NUMBER(4)  ,
	RECEIVE_DATE DATE  ,
	constraint PK_SALE_RETURN_RECODER primary Key (RETURN_NO)
);
comment on table SALE_RETURN_RECODER is '还货单';
comment on column SALE_RETURN_RECODER.RETURN_NO is '退货编号（TH12345678）';
comment on column SALE_RETURN_RECODER.MARKET_MANAGER_ADMIN is '市场管理员';
comment on column SALE_RETURN_RECODER.APPLY_DATE is '申请日期';
comment on column SALE_RETURN_RECODER.APPLY_TICKETS is '申请退货总数量（票数）';
comment on column SALE_RETURN_RECODER.APPLY_AMOUNT is '申请退货总金额';
comment on column SALE_RETURN_RECODER.FINANCE_ADMIN is '财务审批人';
comment on column SALE_RETURN_RECODER.APPROVE_DATE is '审批日期';
comment on column SALE_RETURN_RECODER.APPROVE_REMARK is '审批意见';
comment on column SALE_RETURN_RECODER.ACT_TICKETS is '实际退货总数量（票数）';
comment on column SALE_RETURN_RECODER.ACT_AMOUNT is '实际退货总金额';
comment on column SALE_RETURN_RECODER.STATUS  is '状态（1-已提交，2-已撤销，3-已受理，4-已发货，5-收货中，6-已收货，7-已审批，8-已拒绝）';
comment on column SALE_RETURN_RECODER.IS_DIRECT_AUDITED is '是否直接审批通过';
comment on column SALE_RETURN_RECODER.DIRECT_AMOUNT is '直接审批通过限额';
comment on column SALE_RETURN_RECODER.RECEIVE_ORG is '收货单位';
comment on column SALE_RETURN_RECODER.RECEIVE_WH is '收货仓库';
comment on column SALE_RETURN_RECODER.RECEIVE_MANAGER is '收货仓库管理员';
comment on column SALE_RETURN_RECODER.RECEIVE_DATE is '收货时间';

create table SALE_RETURN_APPLY_DETAIL(
	RETURN_NO CHAR(10)  not null,
	SEQUENCE_NO NUMBER(24)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	TICKETS NUMBER(18)  not null,
	PACKAGES NUMBER(18)  not null,
	AMOUNT NUMBER(28)  not null,
	constraint PK_SALE_RA_DETAIL primary Key (SEQUENCE_NO)
);
comment on table SALE_RETURN_APPLY_DETAIL is '还货单申请明细';
comment on column SALE_RETURN_APPLY_DETAIL.RETURN_NO is '退货编号（TH12345678）';
comment on column SALE_RETURN_APPLY_DETAIL.SEQUENCE_NO is '顺序号';
comment on column SALE_RETURN_APPLY_DETAIL.PLAN_CODE is '方案编码';
comment on column SALE_RETURN_APPLY_DETAIL.TICKETS is '票数';
comment on column SALE_RETURN_APPLY_DETAIL.PACKAGES is '本数';
comment on column SALE_RETURN_APPLY_DETAIL.AMOUNT is '金额';

create table SALE_AGENCY_RECEIPT(
	AR_NO CHAR(10)  not null,
	AR_ADMIN NUMBER(4)  not null,
	AR_DATE DATE  not null,
	AR_AGENCY CHAR(8)  not null,
	BEFORE_BALANCE NUMBER(28) default 0 not null,
	AFTER_BALANCE NUMBER(28) default 0 not null,
	TICKETS NUMBER(16) default 0 not null,
	AMOUNT NUMBER(28) default 0 not null,
	constraint PK_SALE_AGENCY_RECEIPT primary Key (AR_NO)
);
comment on table SALE_AGENCY_RECEIPT is '站点入库单';
comment on column SALE_AGENCY_RECEIPT.AR_NO is '站点入库单编号（AR12345678）';
comment on column SALE_AGENCY_RECEIPT.AR_ADMIN is '市场管理员';
comment on column SALE_AGENCY_RECEIPT.AR_DATE is '收货时间';
comment on column SALE_AGENCY_RECEIPT.AR_AGENCY is '收货站点';
comment on column SALE_AGENCY_RECEIPT.BEFORE_BALANCE is '收货前站点余额';
comment on column SALE_AGENCY_RECEIPT.AFTER_BALANCE is '收货后站点余额';
comment on column SALE_AGENCY_RECEIPT.TICKETS is '收货总票数';
comment on column SALE_AGENCY_RECEIPT.AMOUNT is '收货总金额';

create table SALE_AGENCY_RETURN(
	AI_NO CHAR(10)  not null,
	AI_MM_ADMIN NUMBER(4)  not null,
	AI_DATE DATE  not null,
	AI_AGENCY CHAR(8)  not null,
	BEFORE_BALANCE NUMBER(28) default 0 not null,
	AFTER_BALANCE NUMBER(28) default 0 not null,
	TICKETS NUMBER(16) default 0 not null,
	AMOUNT NUMBER(28) default 0 not null,
	constraint PK_SALE_AGENCY_RETURN primary Key (AI_NO)
);
comment on table SALE_AGENCY_RETURN is '站点退货单';
comment on column SALE_AGENCY_RETURN.AI_NO is '站点退货单编号（AI12345678）';
comment on column SALE_AGENCY_RETURN.AI_MM_ADMIN is '市场管理员';
comment on column SALE_AGENCY_RETURN.AI_DATE is '退货时间';
comment on column SALE_AGENCY_RETURN.AI_AGENCY is '退货站点';
comment on column SALE_AGENCY_RETURN.BEFORE_BALANCE is '退货前站点余额';
comment on column SALE_AGENCY_RETURN.AFTER_BALANCE is '退货后站点余额';
comment on column SALE_AGENCY_RETURN.TICKETS is '退货总票数';
comment on column SALE_AGENCY_RETURN.AMOUNT is '退货总金额';

create table SALE_PAID(
	DJXQ_NO CHAR(24)  not null,
	PAY_AGENCY CHAR(8)  not null,
	AREA_CODE CHAR(4)  ,
	PAYER_ADMIN NUMBER(4)  not null,
	IS_CENTER_PAID NUMBER(1) default 3 not null,
	PLAN_TICKETS NUMBER(28) default 0 not null,
	SUCC_TICKETS NUMBER(28) default 0 not null,
	SUCC_AMOUNT NUMBER(28) default 0 not null,
	PAY_TIME DATE default sysdate not null,
	constraint PK_SALE_PAID primary Key (DJXQ_NO)
);
comment on table SALE_PAID is '兑奖详情主表';
comment on column SALE_PAID.DJXQ_NO is '兑奖详情编号（DX1234）';
comment on column SALE_PAID.PAY_AGENCY is '兑奖站点';
comment on column SALE_PAID.AREA_CODE is '区域编码';
comment on column SALE_PAID.PAYER_ADMIN is '兑奖操作员编号';
comment on column SALE_PAID.IS_CENTER_PAID is '兑奖方式（1=中心兑奖，2=手工兑奖，3=站点兑奖）';
comment on column SALE_PAID.PLAN_TICKETS is '提交兑奖票数';
comment on column SALE_PAID.SUCC_TICKETS is '成功兑奖票数';
comment on column SALE_PAID.SUCC_AMOUNT is '成功兑奖金额';
comment on column SALE_PAID.PAY_TIME is '兑奖时间';
create index IDX_SALE_PAID_ADMIN on SALE_PAID(PAYER_ADMIN);
create index IDX_SALE_PAID_AGENCY on SALE_PAID(PAY_AGENCY);

create table SALE_PAID_DETAIL(
	DJXQ_NO CHAR(24)  not null,
	DJXQ_SEQ_NO NUMBER(24)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	PACKAGE_NO VARCHAR2(10)  not null,
	TICKET_NO NUMBER(5) default 0 not null,
	SECURITY_CODE VARCHAR2(50) default 0 not null,
	PAID_STATUS NUMBER(1) default 0 not null,
	PAY_FLOW CHAR(24)  ,
	REWARD_AMOUNT NUMBER(28)  ,
	PAY_TIME DATE default sysdate not null,
	IS_OLD_TICKET NUMBER(1) default 0 not null,
	constraint PK_SALE_PAID_DETAIL primary Key (DJXQ_SEQ_NO)
);
comment on table SALE_PAID_DETAIL is '兑奖详情子表';
comment on column SALE_PAID_DETAIL.DJXQ_NO is '兑奖详情编号（DX12345678）';
comment on column SALE_PAID_DETAIL.DJXQ_SEQ_NO is '顺序号';
comment on column SALE_PAID_DETAIL.PLAN_CODE is '方案编码';
comment on column SALE_PAID_DETAIL.BATCH_NO is '批次';
comment on column SALE_PAID_DETAIL.PACKAGE_NO is '本号';
comment on column SALE_PAID_DETAIL.TICKET_NO is '票号';
comment on column SALE_PAID_DETAIL.SECURITY_CODE is '保安区码';
comment on column SALE_PAID_DETAIL.PAID_STATUS is '兑奖状态（1-成功、2-非法票、3-已兑奖、4-中大奖、5-未中奖、6-未销售、8-批次终结）';
comment on column SALE_PAID_DETAIL.PAY_FLOW is '兑奖流水号';
comment on column SALE_PAID_DETAIL.REWARD_AMOUNT is '中奖金额';
comment on column SALE_PAID_DETAIL.PAY_TIME is '兑奖时间';
comment on column SALE_PAID_DETAIL.IS_OLD_TICKET is '是否旧票';
create index IDX_SALE_PAID_DETAIL_DJXQ on SALE_PAID_DETAIL(DJXQ_NO);
create index IDX_SALE_PAID_DETAIL_TICKET on SALE_PAID_DETAIL(PLAN_CODE,BATCH_NO,PACKAGE_NO,TICKET_NO);
create index IDX_SALE_PAID_DETAIL_FLOW on SALE_PAID_DETAIL(PAY_FLOW);

create table FLOW_GUI_PAY(
	GUI_PAY_NO CHAR(12)  not null,
	WINNERNAME VARCHAR2(1000)  ,
	GENDER NUMBER(1)  ,
	CONTACT VARCHAR2(4000)  ,
	AGE NUMBER(3)  ,
	CERT_NUMBER VARCHAR2(50)  ,
	REWARD_NO NUMBER(3)  ,
	PAY_AMOUNT NUMBER(28)  not null,
	PAY_TIME DATE  not null,
	PAYER_ADMIN NUMBER(4)  not null,
	PAYER_NAME VARCHAR2(1000)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNK_NO VARCHAR2(10)  not null,
	BOX_NO VARCHAR2(20)  not null,
	PACKAGE_NO VARCHAR2(10)  not null,
	TICKET_NO NUMBER(5)  not null,
	SECURITY_CODE VARCHAR2(50)  ,
	IS_MANUAL NUMBER(1)  ,
	PAY_FLOW CHAR(24)  not null,
  REMARK VARCHAR2(4000),
  PAY_ORG CHAR(2),
	constraint PK_FLOW_GUI_PAY primary Key (GUI_PAY_NO)
);
comment on table FLOW_GUI_PAY is 'GUI兑奖信息记录表';
comment on column FLOW_GUI_PAY.GUI_PAY_NO is '中心兑奖编号（GD1234567890）';
comment on column FLOW_GUI_PAY.WINNERNAME is '中奖人姓名';
comment on column FLOW_GUI_PAY.GENDER is '中奖人性别(1=男、2=女)';
comment on column FLOW_GUI_PAY.CONTACT is '中奖人联系方式';
comment on column FLOW_GUI_PAY.AGE is '中奖人年龄';
comment on column FLOW_GUI_PAY.CERT_NUMBER is '中奖人证件号码';
comment on column FLOW_GUI_PAY.REWARD_NO is '中奖等级';
comment on column FLOW_GUI_PAY.PAY_AMOUNT is '中奖金额';
comment on column FLOW_GUI_PAY.PAY_TIME is '兑奖时间';
comment on column FLOW_GUI_PAY.PAYER_ADMIN is '兑奖操作员编号';
comment on column FLOW_GUI_PAY.PAYER_NAME is '兑奖操作员名称';
comment on column FLOW_GUI_PAY.PLAN_CODE is '方案编码';
comment on column FLOW_GUI_PAY.BATCH_NO is '批次';
comment on column FLOW_GUI_PAY.TRUNK_NO is '箱号';
comment on column FLOW_GUI_PAY.BOX_NO is '盒号（箱号+盒子顺序号）';
comment on column FLOW_GUI_PAY.PACKAGE_NO is '本号';
comment on column FLOW_GUI_PAY.TICKET_NO is '票号';
comment on column FLOW_GUI_PAY.SECURITY_CODE is '保安区码';
comment on column FLOW_GUI_PAY.IS_MANUAL is '是否手动兑奖（1-是，0-否）';
comment on column FLOW_GUI_PAY.PAY_FLOW is '兑奖流水';
comment on column FLOW_GUI_PAY.REMARK is '兑奖备注';
comment on column FLOW_GUI_PAY.PAY_ORG is '兑奖机构';
create index UDX_FLOW_GUI_PAY_TICKET on FLOW_GUI_PAY(PLAN_CODE,BATCH_NO,TRUNK_NO,BOX_NO,PACKAGE_NO,TICKET_NO);

create table FLOW_PAY(
	PAY_FLOW CHAR(24)  not null,
	PAY_AGENCY CHAR(8)  ,
	AREA_CODE CHAR(4)  ,
	PAY_COMM NUMBER(18)  ,
	PAY_COMM_RATE NUMBER(8)  ,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	REWARD_GROUP NUMBER(2)  not null,
	TRUNK_NO VARCHAR2(10)  not null,
	BOX_NO VARCHAR2(20)  not null,
	PACKAGE_NO VARCHAR2(10)  not null,
	TICKET_NO NUMBER(5)  not null,
	SECURITY_CODE VARCHAR2(50)  ,
	IDENTITY_CODE VARCHAR2(50)  ,
	PAY_AMOUNT NUMBER(28)  not null,
	REWARD_NO NUMBER(3)  ,
	LOTTERY_AMOUNT NUMBER(18)  not null,
	COMM_AMOUNT NUMBER(18)  ,
	COMM_RATE NUMBER(8)  ,
	PAY_TIME DATE  not null,
	PAYER_ADMIN NUMBER(4)  ,
	PAYER_NAME VARCHAR2(1000)  ,
	IS_CENTER_PAID NUMBER(1) default 0 not null,
	constraint PK_FLOW_PAY primary Key (PAY_FLOW)
);
comment on table FLOW_PAY is '兑奖资金流水';
comment on column FLOW_PAY.PAY_FLOW is '兑奖流水（DJ123456789012345678901234）';
comment on column FLOW_PAY.PAY_AGENCY is '兑奖站点';
comment on column FLOW_PAY.AREA_CODE is '区域编码';
comment on column FLOW_PAY.PAY_COMM is '兑奖佣金';
comment on column FLOW_PAY.PAY_COMM_RATE is '兑奖佣金比例（千分位）';
comment on column FLOW_PAY.PLAN_CODE is '方案编码';
comment on column FLOW_PAY.BATCH_NO is '批次';
comment on column FLOW_PAY.REWARD_GROUP is '奖组';
comment on column FLOW_PAY.TRUNK_NO is '箱号';
comment on column FLOW_PAY.BOX_NO is '盒号（箱号+盒子顺序号）';
comment on column FLOW_PAY.PACKAGE_NO is '本号';
comment on column FLOW_PAY.TICKET_NO is '票号';
comment on column FLOW_PAY.SECURITY_CODE is '保安区码';
comment on column FLOW_PAY.IDENTITY_CODE is '物流区码';
comment on column FLOW_PAY.PAY_AMOUNT is '中奖金额';
comment on column FLOW_PAY.REWARD_NO is '中奖等级';
comment on column FLOW_PAY.LOTTERY_AMOUNT is '彩票金额';
comment on column FLOW_PAY.COMM_AMOUNT is '兑奖佣金';
comment on column FLOW_PAY.COMM_RATE is '兑奖佣金比例';
comment on column FLOW_PAY.PAY_TIME is '兑奖时间';
comment on column FLOW_PAY.PAYER_ADMIN is '兑奖操作员编号';
comment on column FLOW_PAY.PAYER_NAME is '兑奖操作员名称';
comment on column FLOW_PAY.IS_CENTER_PAID is '兑奖方式（1=中心兑奖，2=手工兑奖，3=站点兑奖）';
create index UDX_FLOW_PAY_TICKET on FLOW_PAY(PLAN_CODE,BATCH_NO,TRUNK_NO,BOX_NO,PACKAGE_NO,TICKET_NO);
create index IDX_FLOW_PAY_SECURITY on FLOW_PAY (PLAN_CODE,BATCH_NO,SECURITY_CODE);
create index IDX_FLOW_PAY_TIME on FLOW_PAY (PAY_TIME);

create table FLOW_SALE(
	SALE_FLOW CHAR(24)  not null,
	AGENCY_CODE CHAR(8)  not null,
	AREA_CODE CHAR(4)  not null,
	ORG_CODE CHAR(2)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNKS NUMBER(18)  not null,
	BOXES NUMBER(18)  not null,
	PACKAGES NUMBER(18)  not null,
	TICKETS NUMBER(18)  not null,
	SALE_AMOUNT NUMBER(28)  not null,
	COMM_AMOUNT NUMBER(18)  not null,
	COMM_RATE NUMBER(8)  not null,
	SALE_TIME DATE  not null,
	AR_NO CHAR(10)  not null,
	SGR_NO CHAR(10)  not null,
	constraint PK_FLOW_SALE primary Key (SALE_FLOW)
);
comment on table FLOW_SALE is '销售记录';
comment on column FLOW_SALE.SALE_FLOW is '销售流水（XS1234567890123456789012）';
comment on column FLOW_SALE.AGENCY_CODE is '销售站点';
comment on column FLOW_SALE.AREA_CODE is '区域编码';
comment on column FLOW_SALE.ORG_CODE is '组织机构';
comment on column FLOW_SALE.PLAN_CODE is '方案编码';
comment on column FLOW_SALE.BATCH_NO is '批次';
comment on column FLOW_SALE.TRUNKS is '箱';
comment on column FLOW_SALE.BOXES is '盒数';
comment on column FLOW_SALE.PACKAGES is '本数';
comment on column FLOW_SALE.TICKETS is '销售张数';
comment on column FLOW_SALE.SALE_AMOUNT is '销售金额';
comment on column FLOW_SALE.COMM_AMOUNT is '销售佣金';
comment on column FLOW_SALE.COMM_RATE is '销售佣金比例（千分位）';
comment on column FLOW_SALE.SALE_TIME is '销售时间';
comment on column FLOW_SALE.AR_NO is '站点入库单编号';
comment on column FLOW_SALE.SGR_NO is '入库单编号';
create index IDX_FLOW_SALE_AGENCY on FLOW_SALE(AGENCY_CODE);
create index IDX_FLOW_SALE_AREA on FLOW_SALE(AREA_CODE);
create index IDX_FLOW_SALE_GAME on FLOW_SALE(PLAN_CODE,BATCH_NO);
create index IDX_FLOW_SALE_TIME on FLOW_SALE(SALE_TIME);

create table FLOW_CANCEL(
	CANCEL_FLOW CHAR(24)  not null,
	AGENCY_CODE CHAR(8)  not null,
	AREA_CODE CHAR(4)  not null,
	ORG_CODE CHAR(2)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNKS NUMBER(18)  not null,
	BOXES NUMBER(18)  not null,
	PACKAGES NUMBER(18)  not null,
	TICKETS NUMBER(18)  not null,
	SALE_AMOUNT NUMBER(28)  not null,
	COMM_AMOUNT NUMBER(18)  not null,
	COMM_RATE NUMBER(8)  not null,
	CANCEL_TIME DATE  not null,
	AI_NO CHAR(10)  not null,
	SGI_NO CHAR(10)  not null,
	constraint PK_FLOW_CANCEL primary Key (CANCEL_FLOW)
);
comment on table FLOW_CANCEL is '退票记录';
comment on column FLOW_CANCEL.CANCEL_FLOW is '退票流水（TP1234567890123456789012）';
comment on column FLOW_CANCEL.AGENCY_CODE is '退票站点';
comment on column FLOW_CANCEL.AREA_CODE is '区域编码';
comment on column FLOW_CANCEL.ORG_CODE is '组织机构';
comment on column FLOW_CANCEL.PLAN_CODE is '方案编码';
comment on column FLOW_CANCEL.BATCH_NO is '批次';
comment on column FLOW_CANCEL.TRUNKS is '箱数';
comment on column FLOW_CANCEL.BOXES is '盒数';
comment on column FLOW_CANCEL.PACKAGES is '本数';
comment on column FLOW_CANCEL.TICKETS is '退票张数';
comment on column FLOW_CANCEL.SALE_AMOUNT is '退票金额';
comment on column FLOW_CANCEL.COMM_AMOUNT is '涉及佣金';
comment on column FLOW_CANCEL.COMM_RATE is '佣金比例（千分位）';
comment on column FLOW_CANCEL.CANCEL_TIME is '退票时间';
comment on column FLOW_CANCEL.AI_NO is '站点退货单编号';
comment on column FLOW_CANCEL.SGI_NO is '出库单编号';
create index IDX_FLOW_CANCEL_AGENCY on FLOW_CANCEL(AGENCY_CODE);
create index IDX_FLOW_CANCEL_AREA on FLOW_CANCEL(AREA_CODE);
create index IDX_FLOW_CANCEL_GAME on FLOW_CANCEL(PLAN_CODE,BATCH_NO);
create index IDX_FLOW_CANCEL_TIME on FLOW_CANCEL(CANCEL_TIME);

create table FLOW_PAY_ORG_COMM(
	PAY_FLOW CHAR(24)  not null,
	PAY_AGENCY CHAR(8)  ,
	AREA_CODE CHAR(4)  ,
	ORG_CODE CHAR(2)  not null,
	ORG_TYPE NUMBER(1)  not null,
	ORG_PAY_COMM NUMBER(18)  ,
	ORG_PAY_COMM_RATE NUMBER(8)  ,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	REWARD_GROUP NUMBER(2)  not null,
	TRUNK_NO VARCHAR2(10)  not null,
	BOX_NO VARCHAR2(20)  not null,
	PACKAGE_NO VARCHAR2(10)  not null,
	TICKET_NO NUMBER(5)  not null,
	SECURITY_CODE VARCHAR2(50)  ,
	IDENTITY_CODE VARCHAR2(50)  ,
	PAY_AMOUNT NUMBER(28)  not null,
	REWARD_NO NUMBER(3)  ,
	LOTTERY_AMOUNT NUMBER(18)  not null,
	PAY_TIME DATE  not null,
	PAYER_ADMIN NUMBER(4)  ,
	PAYER_NAME VARCHAR2(1000)  ,
	IS_CENTER_PAID NUMBER(1) default 0 not null,
	constraint PK_FLOW_PAY_ORG_COMM primary Key (PAY_FLOW)
);
comment on table FLOW_PAY_ORG_COMM is '兑奖资金流水—机构佣金';
comment on column FLOW_PAY_ORG_COMM.PAY_FLOW is '兑奖流水（DJ123456789012345678901234）';
comment on column FLOW_PAY_ORG_COMM.PAY_AGENCY is '兑奖站点';
comment on column FLOW_PAY_ORG_COMM.AREA_CODE is '区域编码';
comment on column FLOW_PAY_ORG_COMM.ORG_CODE is '组织机构';
comment on column FLOW_PAY_ORG_COMM.ORG_TYPE is '机构类别（1-公司,2-代理）';
comment on column FLOW_PAY_ORG_COMM.ORG_PAY_COMM is '机构兑奖佣金';
comment on column FLOW_PAY_ORG_COMM.ORG_PAY_COMM_RATE is '机构兑奖佣金比例（千分位）';
comment on column FLOW_PAY_ORG_COMM.PLAN_CODE is '方案编码';
comment on column FLOW_PAY_ORG_COMM.BATCH_NO is '批次';
comment on column FLOW_PAY_ORG_COMM.REWARD_GROUP is '奖组';
comment on column FLOW_PAY_ORG_COMM.TRUNK_NO is '箱号';
comment on column FLOW_PAY_ORG_COMM.BOX_NO is '盒号（箱号+盒子顺序号）';
comment on column FLOW_PAY_ORG_COMM.PACKAGE_NO is '本号';
comment on column FLOW_PAY_ORG_COMM.TICKET_NO is '票号';
comment on column FLOW_PAY_ORG_COMM.SECURITY_CODE is '保安区码';
comment on column FLOW_PAY_ORG_COMM.IDENTITY_CODE is '物流区码';
comment on column FLOW_PAY_ORG_COMM.PAY_AMOUNT is '中奖金额';
comment on column FLOW_PAY_ORG_COMM.REWARD_NO is '中奖等级';
comment on column FLOW_PAY_ORG_COMM.LOTTERY_AMOUNT is '彩票金额';
comment on column FLOW_PAY_ORG_COMM.PAY_TIME is '兑奖时间';
comment on column FLOW_PAY_ORG_COMM.PAYER_ADMIN is '兑奖操作员编号';
comment on column FLOW_PAY_ORG_COMM.PAYER_NAME is '兑奖操作员名称';
comment on column FLOW_PAY_ORG_COMM.IS_CENTER_PAID is '兑奖方式（1=中心兑奖，2=手工兑奖，3=站点兑奖）';
create index UDX_FLOW_PAY_ORG_TICKET on FLOW_PAY_ORG_COMM(PLAN_CODE,BATCH_NO,TRUNK_NO,BOX_NO,PACKAGE_NO,TICKET_NO);

create table FLOW_SALE_ORG_COMM(
	SALE_FLOW CHAR(24)  not null,
	AGENCY_CODE CHAR(8)  not null,
	AREA_CODE CHAR(4)  not null,
	ORG_CODE CHAR(2)  not null,
	ORG_TYPE NUMBER(1)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNKS NUMBER(18)  not null,
	BOXES NUMBER(18)  not null,
	PACKAGES NUMBER(18)  not null,
	TICKETS NUMBER(18)  not null,
	SALE_AMOUNT NUMBER(28)  not null,
	ORG_COMM_AMOUNT NUMBER(18)  not null,
	ORG_COMM_RATE NUMBER(8)  not null,
	SALE_TIME DATE  not null,
	AR_NO CHAR(10)  not null,
	SGR_NO CHAR(10)  not null,
	constraint PK_FLOW_SALE_ORG_COMM primary Key (SALE_FLOW)
);
comment on table FLOW_SALE_ORG_COMM is '销售记录—机构佣金';
comment on column FLOW_SALE_ORG_COMM.SALE_FLOW is '销售流水（XS1234567890123456789012）';
comment on column FLOW_SALE_ORG_COMM.AGENCY_CODE is '销售站点';
comment on column FLOW_SALE_ORG_COMM.AREA_CODE is '区域编码';
comment on column FLOW_SALE_ORG_COMM.ORG_CODE is '组织机构';
comment on column FLOW_SALE_ORG_COMM.ORG_TYPE is '机构类别（1-公司,2-代理）';
comment on column FLOW_SALE_ORG_COMM.PLAN_CODE is '方案编码';
comment on column FLOW_SALE_ORG_COMM.BATCH_NO is '批次';
comment on column FLOW_SALE_ORG_COMM.TRUNKS is '箱';
comment on column FLOW_SALE_ORG_COMM.BOXES is '盒数';
comment on column FLOW_SALE_ORG_COMM.PACKAGES is '本数';
comment on column FLOW_SALE_ORG_COMM.TICKETS is '销售张数';
comment on column FLOW_SALE_ORG_COMM.SALE_AMOUNT is '销售金额';
comment on column FLOW_SALE_ORG_COMM.ORG_COMM_AMOUNT is '机构销售佣金';
comment on column FLOW_SALE_ORG_COMM.ORG_COMM_RATE is '机构销售佣金比例（千分位）';
comment on column FLOW_SALE_ORG_COMM.SALE_TIME is '销售时间';
comment on column FLOW_SALE_ORG_COMM.AR_NO is '站点入库单编号';
comment on column FLOW_SALE_ORG_COMM.SGR_NO is '入库单编号';
create index IDX_FLOW_SALE_ORG_AGENCY on FLOW_SALE_ORG_COMM(AGENCY_CODE);
create index IDX_FLOW_SALE_ORG_AREA on FLOW_SALE_ORG_COMM(AREA_CODE);
create index IDX_FLOW_SALE_ORG_GAME on FLOW_SALE_ORG_COMM(PLAN_CODE,BATCH_NO);

create table FLOW_CANCEL_ORG_COMM(
	CANCEL_FLOW CHAR(24)  not null,
	AGENCY_CODE CHAR(8)  not null,
	AREA_CODE CHAR(4)  not null,
	ORG_CODE CHAR(2)  not null,
	ORG_TYPE NUMBER(1)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	TRUNKS NUMBER(18)  not null,
	BOXES NUMBER(18)  not null,
	PACKAGES NUMBER(18)  not null,
	TICKETS NUMBER(18)  not null,
	SALE_AMOUNT NUMBER(28)  not null,
	COMM_AMOUNT NUMBER(18)  not null,
	COMM_RATE NUMBER(8)  not null,
	CANCEL_TIME DATE  not null,
	AI_NO CHAR(10)  not null,
	SGI_NO CHAR(10)  not null,
	constraint PK_FLOW_CANCEL_ORG_COMM primary Key (CANCEL_FLOW)
);
comment on table FLOW_CANCEL_ORG_COMM is '退票记录—机构佣金';
comment on column FLOW_CANCEL_ORG_COMM.CANCEL_FLOW is '退票流水（TP1234567890123456789012）';
comment on column FLOW_CANCEL_ORG_COMM.AGENCY_CODE is '退票站点';
comment on column FLOW_CANCEL_ORG_COMM.AREA_CODE is '区域编码';
comment on column FLOW_CANCEL_ORG_COMM.ORG_CODE is '组织机构';
comment on column FLOW_CANCEL_ORG_COMM.ORG_TYPE is '机构类别（1-公司,2-代理）';
comment on column FLOW_CANCEL_ORG_COMM.PLAN_CODE is '方案编码';
comment on column FLOW_CANCEL_ORG_COMM.BATCH_NO is '批次';
comment on column FLOW_CANCEL_ORG_COMM.TRUNKS is '箱数';
comment on column FLOW_CANCEL_ORG_COMM.BOXES is '盒数';
comment on column FLOW_CANCEL_ORG_COMM.PACKAGES is '本数';
comment on column FLOW_CANCEL_ORG_COMM.TICKETS is '退票张数';
comment on column FLOW_CANCEL_ORG_COMM.SALE_AMOUNT is '退票金额';
comment on column FLOW_CANCEL_ORG_COMM.COMM_AMOUNT is '涉及机构佣金';
comment on column FLOW_CANCEL_ORG_COMM.COMM_RATE is '涉及机构佣金比例（千分位）';
comment on column FLOW_CANCEL_ORG_COMM.CANCEL_TIME is '退票时间';
comment on column FLOW_CANCEL_ORG_COMM.AI_NO is '站点退货单编号';
comment on column FLOW_CANCEL_ORG_COMM.SGI_NO is '出库单编号';
create index IDX_FLOW_CANCEL_ORG_AGENCY on FLOW_CANCEL_ORG_COMM(AGENCY_CODE);
create index IDX_FLOW_CANCEL_ORG_AREA on FLOW_CANCEL_ORG_COMM(AREA_CODE);
create index IDX_FLOW_CANCEL_ORG_GAME on FLOW_CANCEL_ORG_COMM(PLAN_CODE,BATCH_NO);

create table FLOW_ORG(
	ORG_FUND_FLOW CHAR(24)  not null,
	REF_NO VARCHAR2(24)  not null,
	FLOW_TYPE NUMBER(2)  not null,
	ACC_NO CHAR(12)  not null,
	ORG_CODE CHAR(2)  not null,
	CHANGE_AMOUNT NUMBER(28)  not null,
	FROZEN_AMOUNT NUMBER(28) default 0 not null,
	BE_ACCOUNT_BALANCE NUMBER(28)  not null,
	BE_FROZEN_BALANCE NUMBER(28)  not null,
	AF_ACCOUNT_BALANCE NUMBER(28)  not null,
	AF_FROZEN_BALANCE NUMBER(28)  not null,
	TRADE_TIME DATE default sysdate not null,
	constraint PK_FLOW_ORG primary Key (ORG_FUND_FLOW)
);
comment on table FLOW_ORG is '机构资金流水';
comment on column FLOW_ORG.ORG_FUND_FLOW is '流水号（JG123456789012345678901234）';
comment on column FLOW_ORG.REF_NO is '参考业务编号';
comment on column FLOW_ORG.FLOW_TYPE is '资金类型（1-充值，2-提现，3-彩票调拨入库（机构）、4-彩票调拨入库佣金（机构）、12-彩票调拨出库（机构）、21-站点兑奖导致机构佣金（机构）、22-站点兑奖导致机构增加资金（机构）、23-中心兑奖导致机构佣金（机构）、24-中心兑奖导致机构增加资金（机构）、31-彩票调拨出库退佣金（机构））';
comment on column FLOW_ORG.ACC_NO is '账户编码';
comment on column FLOW_ORG.ORG_CODE is '部门编码';
comment on column FLOW_ORG.CHANGE_AMOUNT is '变更金额';
comment on column FLOW_ORG.FROZEN_AMOUNT is '冻结金额';
comment on column FLOW_ORG.BE_ACCOUNT_BALANCE is '变更前可用余额';
comment on column FLOW_ORG.BE_FROZEN_BALANCE is '变更前冻结余额';
comment on column FLOW_ORG.AF_ACCOUNT_BALANCE is '变更后可用余额';
comment on column FLOW_ORG.AF_FROZEN_BALANCE is '变更后冻结余额';
comment on column FLOW_ORG.TRADE_TIME is '交易时间';
create index IDX_FLOW_ORG_ACC on FLOW_ORG(ACC_NO);
create index IDX_FLOW_ORG_ORG on FLOW_ORG(ORG_CODE);

create table FLOW_ORG_COMM_DETAIL(
	ORG_FUND_COMM_FLOW CHAR(24)  not null,
	ORG_FUND_FLOW CHAR(24)  not null,
	AGENCY_CODE CHAR(8)  not null,
	PLAN_NAME VARCHAR2(100)  not null,
	ACC_NO CHAR(12)  not null,
	ORG_CODE CHAR(2)  not null,
	TRADE_TIME DATE default sysdate not null,
	TRADE_AMOUNT NUMBER(28) default 0 not null,
	AGENCY_SALE_AMOUNT NUMBER(28) default 0 not null,
	ORG_SALE_COMM NUMBER(28) default 0 not null,
	AGENCY_SALE_COMM_RATE NUMBER(28) default 0 not null,
	ORG_SALE_COMM_RATE NUMBER(28) default 0 not null,
	AGENCY_CANCEL_AMOUNT NUMBER(28) default 0 not null,
	ORG_CANCEL_COMM NUMBER(28) default 0 not null,
	AGENCY_CANCEL_COMM_RATE NUMBER(28) default 0 not null,
	ORG_CANCEL_COMM_RATE NUMBER(28) default 0 not null,
	AGENCY_PAY_AMOUNT NUMBER(28) default 0 not null,
	ORG_PAY_AMOUNT NUMBER(28) default 0 not null,
	AGENCY_PAY_COMM_RATE NUMBER(28) default 0 not null,
	ORG_PAY_COMM_RATE NUMBER(28) default 0 not null,
	constraint PK_FLOW_ORG_COMM_DETAIL primary Key (ORG_FUND_FLOW)
);
comment on table FLOW_ORG_COMM_DETAIL is '机构佣金流水';
comment on column FLOW_ORG_COMM_DETAIL.ORG_FUND_COMM_FLOW is '流水号（JGYJ12345678901234567890）';
comment on column FLOW_ORG_COMM_DETAIL.ORG_FUND_FLOW is '资金流水编号';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_CODE is '销售站编号';
comment on column FLOW_ORG_COMM_DETAIL.PLAN_NAME is '方案名称';
comment on column FLOW_ORG_COMM_DETAIL.ACC_NO is '账户编码';
comment on column FLOW_ORG_COMM_DETAIL.ORG_CODE is '部门编码';
comment on column FLOW_ORG_COMM_DETAIL.TRADE_TIME is '交易时间';
comment on column FLOW_ORG_COMM_DETAIL.TRADE_AMOUNT is '交易金额';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_SALE_AMOUNT is '站点销售金额';
comment on column FLOW_ORG_COMM_DETAIL.ORG_SALE_COMM is '机构销售佣金';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_SALE_COMM_RATE is '站点销售佣金比例';
comment on column FLOW_ORG_COMM_DETAIL.ORG_SALE_COMM_RATE is '机构销售佣金比例';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_CANCEL_AMOUNT is '站点退货金额';
comment on column FLOW_ORG_COMM_DETAIL.ORG_CANCEL_COMM is '机构退货佣金';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_CANCEL_COMM_RATE is '站点退货佣金比例';
comment on column FLOW_ORG_COMM_DETAIL.ORG_CANCEL_COMM_RATE is '机构退货佣金比例';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_PAY_AMOUNT is '站点兑奖金额';
comment on column FLOW_ORG_COMM_DETAIL.ORG_PAY_AMOUNT is '机构兑奖佣金';
comment on column FLOW_ORG_COMM_DETAIL.AGENCY_PAY_COMM_RATE is '站点兑奖佣金比例';
comment on column FLOW_ORG_COMM_DETAIL.ORG_PAY_COMM_RATE is '机构兑奖佣金比例';
create index IDX_FLOW_ORG_COMM_AGENCY on FLOW_ORG_COMM_DETAIL(ACC_NO);
create index IDX_FLOW_ORG_COMM_FLOW on FLOW_ORG_COMM_DETAIL(ORG_FUND_COMM_FLOW);

create table FLOW_AGENCY(
	AGENCY_FUND_FLOW CHAR(24)  not null,
	REF_NO VARCHAR2(24)  not null,
	FLOW_TYPE NUMBER(2)  not null,
	ACC_NO CHAR(12)  not null,
	AGENCY_CODE CHAR(8)  not null,
	CHANGE_AMOUNT NUMBER(28)  not null,
	FROZEN_AMOUNT NUMBER(28) default 0 not null,
	BE_ACCOUNT_BALANCE NUMBER(28) default 0 not null,
	BE_FROZEN_BALANCE NUMBER(28) default 0 not null,
	AF_ACCOUNT_BALANCE NUMBER(28) default 0 not null,
	AF_FROZEN_BALANCE NUMBER(28) default 0 not null,
	TRADE_TIME DATE default sysdate not null,
	constraint PK_FLOW_AGENCY primary Key (AGENCY_FUND_FLOW)
);
comment on table FLOW_AGENCY is '站点资金流水';
comment on column FLOW_AGENCY.AGENCY_FUND_FLOW is '流水号（ZD123456789012345678901234）';
comment on column FLOW_AGENCY.REF_NO is '参考业务编号';
comment on column FLOW_AGENCY.FLOW_TYPE is '资金类型（1-充值，2-提现，5-销售佣金，6-兑奖佣金，7-销售，8-兑奖，11-站点退货，13-撤销佣金）';
comment on column FLOW_AGENCY.ACC_NO is '账户编码';
comment on column FLOW_AGENCY.AGENCY_CODE is '销售站编号';
comment on column FLOW_AGENCY.CHANGE_AMOUNT is '变更金额';
comment on column FLOW_AGENCY.FROZEN_AMOUNT is '冻结金额';
comment on column FLOW_AGENCY.BE_ACCOUNT_BALANCE is '变更前可用余额';
comment on column FLOW_AGENCY.BE_FROZEN_BALANCE is '变更前冻结余额';
comment on column FLOW_AGENCY.AF_ACCOUNT_BALANCE is '变更后可用余额';
comment on column FLOW_AGENCY.AF_FROZEN_BALANCE is '变更后冻结余额';
comment on column FLOW_AGENCY.TRADE_TIME is '交易时间';
create index IDX_FLOW_AGENCY_ACC on FLOW_AGENCY(ACC_NO);
create index IDX_FLOW_AGENCY_ORG on FLOW_AGENCY(AGENCY_CODE);
create index IDX_FLOW_AGENCY_TIME on FLOW_AGENCY(TRADE_TIME);
create index IDX_FLOW_AGENCY_ERF_NO on FLOW_AGENCY(REF_NO);

create table FLOW_MARKET_MANAGER(
	MM_FUND_FLOW CHAR(24)  not null,
	REF_NO CHAR(10)  not null,
	FLOW_TYPE NUMBER(2)  not null,
	ACC_NO CHAR(12)  not null,
	MARKET_ADMIN NUMBER(4)  not null,
	CHANGE_AMOUNT NUMBER(28)  not null,
	BE_ACCOUNT_BALANCE NUMBER(28)  not null,
	AF_ACCOUNT_BALANCE NUMBER(28)  not null,
	TRADE_TIME DATE default sysdate not null,
	constraint PK_FLOW_MARKET_MANAGER primary Key (MM_FUND_FLOW)
);
comment on table FLOW_MARKET_MANAGER is '市场管理员资金流水';
comment on column FLOW_MARKET_MANAGER.MM_FUND_FLOW is '流水号（MM123456789012345678901234）';
comment on column FLOW_MARKET_MANAGER.REF_NO is '参考业务编号';
comment on column FLOW_MARKET_MANAGER.FLOW_TYPE is '资金类型（9-为站点充值，10-现金上缴，14-为站点提现）';
comment on column FLOW_MARKET_MANAGER.ACC_NO is '账户编码';
comment on column FLOW_MARKET_MANAGER.MARKET_ADMIN is '市场管理员';
comment on column FLOW_MARKET_MANAGER.CHANGE_AMOUNT is '变更金额';
comment on column FLOW_MARKET_MANAGER.BE_ACCOUNT_BALANCE is '变更前可用余额';
comment on column FLOW_MARKET_MANAGER.AF_ACCOUNT_BALANCE is '变更后可用余额';
comment on column FLOW_MARKET_MANAGER.TRADE_TIME is '交易时间';

create table SYS_PARAMETER(
	SYS_DEFAULT_SEQ NUMBER(12)  not null,
	SYS_DEFAULT_DESC VARCHAR2(1000)  not null,
	SYS_DEFAULT_VALUE VARCHAR2(1000)  not null,
  SYS_IS_VALID NUMBER(12) DEFAULT 1 not null,
	constraint PK_SYS_PARAMETER primary Key (SYS_DEFAULT_SEQ)
);
comment on table SYS_PARAMETER is '系统参数表';
comment on column SYS_PARAMETER.SYS_DEFAULT_SEQ is '系统参数序号';
comment on column SYS_PARAMETER.SYS_DEFAULT_DESC is '系统参数描述';
comment on column SYS_PARAMETER.SYS_DEFAULT_VALUE is '系统参数值';
comment on column SYS_PARAMETER.SYS_IS_VALID is '有效标志';

create table SYS_OPER_LOG(
  OPER_NO CHAR(10)  not null,
  OPER_PRIVILEGE NUMBER(4)  not null,
  OPER_ADMIN NUMBER(4)  not null,
  OPER_TIME DATE  not null,
  OPER_MODE_ID NUMBER(10)  not null,
  OPER_MODE_THRESHOLD VARCHAR2(400)  ,
  OPER_STATUS NUMBER(1)  ,
  ORG_CODE CHAR(2)  ,
  AGENCY_CODE CHAR(8)  ,
  MARKET_ADMIN NUMBER(4)  ,
  OPER_CONTENTS VARCHAR2(4000)  ,
  constraint PK_SYS_OPER_LOG primary Key (OPER_NO)
);
comment on table SYS_OPER_LOG is '系统操作日志';
comment on column SYS_OPER_LOG.OPER_NO is '操作日志编号（RZ12345678）';
comment on column SYS_OPER_LOG.OPER_PRIVILEGE is '功能模块代码';
comment on column SYS_OPER_LOG.OPER_ADMIN is '操作人';
comment on column SYS_OPER_LOG.OPER_TIME is '操作时间';
comment on column SYS_OPER_LOG.OPER_MODE_ID is '操作类型';
comment on column SYS_OPER_LOG.OPER_MODE_THRESHOLD is '操作类型阈值';
comment on column SYS_OPER_LOG.OPER_STATUS is '状态（1-正常，2-异常）';
comment on column SYS_OPER_LOG.ORG_CODE is '机构编码';
comment on column SYS_OPER_LOG.AGENCY_CODE is '销售站编码';
comment on column SYS_OPER_LOG.MARKET_ADMIN is '市场管理员';
comment on column SYS_OPER_LOG.OPER_CONTENTS is '操作内容描述';

create table SYS_OPER_MODE(
  OPER_MODE_ID NUMBER(10)  not null,
  OPER_MODE_NAME VARCHAR2(4000)  ,
  OPER_MODE_THRESHOLD VARCHAR2(400)  ,
  OPER_CONTENTS VARCHAR2(4000)  ,
  MODIFY_TIME DATE  ,
  constraint PK_SYS_OPER_MODE primary Key (OPER_MODE_ID)
);
comment on table SYS_OPER_MODE is '系统日志操作类型';
comment on column SYS_OPER_MODE.OPER_MODE_ID is '操作类型编号';
comment on column SYS_OPER_MODE.OPER_MODE_NAME is '操作类型名称';
comment on column SYS_OPER_MODE.OPER_MODE_THRESHOLD is '操作类型阈值';
comment on column SYS_OPER_MODE.OPER_CONTENTS is '操作内容描述';
comment on column SYS_OPER_MODE.MODIFY_TIME is '最近修改日期';

create table SWITCH_SCAN(
	OLD_PAY_FLOW CHAR(24)  not null,
	PAID_TIME DATE  ,
	PAID_ADMIN NUMBER(4)  ,
	PAID_ORG CHAR(2)  ,
	APPLY_TICKETS NUMBER(28)  ,
	FAIL_NEW_TICKETS NUMBER(28)  ,
	SUCC_TICKETS NUMBER(28)  ,
	SUCC_AMOUNT NUMBER(28)  ,
	constraint PK_SWITCH_SCAN primary Key (OLD_PAY_FLOW)
);
comment on table SWITCH_SCAN is '旧票兑奖主表';
comment on column SWITCH_SCAN.OLD_PAY_FLOW is '旧票兑奖序号';
comment on column SWITCH_SCAN.PAID_TIME is '兑奖时间';
comment on column SWITCH_SCAN.PAID_ADMIN is '兑奖人';
comment on column SWITCH_SCAN.PAID_ORG is '所属机构';
comment on column SWITCH_SCAN.APPLY_TICKETS is '提交票数';
comment on column SWITCH_SCAN.FAIL_NEW_TICKETS is '失败新票票数';
comment on column SWITCH_SCAN.SUCC_TICKETS is '成功兑奖票数';
comment on column SWITCH_SCAN.SUCC_AMOUNT is '成功兑奖金额';

create table SWITCH_SCAN_DETAIL(
	OLD_PAY_FLOW CHAR(24)  not null,
	OLD_PAY_SEQ CHAR(24)  not null,
	PAID_TIME DATE  not null,
	PAID_ADMIN NUMBER(4)  not null,
	PAID_ORG CHAR(2)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	PACKAGE_NO VARCHAR2(10)  not null,
	TICKET_NO NUMBER(5) default 0 not null,
	SECURITY_CODE VARCHAR2(50) default 0 not null,
	PAID_STATUS NUMBER(1) default 0 not null,
	REWARD_AMOUNT NUMBER(28)  not null,
	IS_NEW_TICKET NUMBER(1) default 0 not null,
	constraint PK_SWITCH_SCAN_DETAIL primary Key (OLD_PAY_SEQ)
);
comment on table SWITCH_SCAN_DETAIL is '旧票兑奖子表';
comment on column SWITCH_SCAN_DETAIL.OLD_PAY_FLOW is '旧票兑奖序号';
comment on column SWITCH_SCAN_DETAIL.OLD_PAY_SEQ is '旧票明细序号';
comment on column SWITCH_SCAN_DETAIL.PAID_TIME is '兑奖时间';
comment on column SWITCH_SCAN_DETAIL.PAID_ADMIN is '兑奖人';
comment on column SWITCH_SCAN_DETAIL.PAID_ORG is '所属机构';
comment on column SWITCH_SCAN_DETAIL.PLAN_CODE is '方案编码';
comment on column SWITCH_SCAN_DETAIL.BATCH_NO is '批次';
comment on column SWITCH_SCAN_DETAIL.PACKAGE_NO is '本号';
comment on column SWITCH_SCAN_DETAIL.TICKET_NO is '票号';
comment on column SWITCH_SCAN_DETAIL.SECURITY_CODE is '保安区码';
comment on column SWITCH_SCAN_DETAIL.PAID_STATUS is '兑奖状态（1-成功、3-已兑奖、5-未中奖、7-新票）';
comment on column SWITCH_SCAN_DETAIL.REWARD_AMOUNT is '中奖金额';
comment on column SWITCH_SCAN_DETAIL.IS_NEW_TICKET is '是否新票';

create table FUND_CHARGE_CENTER(
	FUND_NO CHAR(10)  not null,
	ACCOUNT_TYPE NUMBER(1)  not null,
	AO_CODE VARCHAR2(8)  not null,
	AO_NAME VARCHAR2(4000)  ,
	ACC_NO CHAR(12)  not null,
	OPER_AMOUNT NUMBER(28)  not null,
	BE_ACCOUNT_BALANCE NUMBER(28)  not null,
	AF_ACCOUNT_BALANCE NUMBER(28)  not null,
	OPER_TIME DATE  not null,
	OPER_ADMIN NUMBER(4)  not null,
	constraint PK_FUND_CHARGE_CENTER primary Key (FUND_NO)
);
comment on table FUND_CHARGE_CENTER is '销售站（机构）中心充值';
comment on column FUND_CHARGE_CENTER.FUND_NO is '充值编号（FC12345678）';
comment on column FUND_CHARGE_CENTER.ACCOUNT_TYPE is '账户类型（1-机构，2-站点）';
comment on column FUND_CHARGE_CENTER.AO_CODE is '销售站（机构）编码';
comment on column FUND_CHARGE_CENTER.AO_NAME is '销售站（机构）名称';
comment on column FUND_CHARGE_CENTER.ACC_NO is '账户编码';
comment on column FUND_CHARGE_CENTER.OPER_AMOUNT is '缴款金额';
comment on column FUND_CHARGE_CENTER.BE_ACCOUNT_BALANCE is '缴款前销售站余额';
comment on column FUND_CHARGE_CENTER.AF_ACCOUNT_BALANCE is '缴款后销售站余额';
comment on column FUND_CHARGE_CENTER.OPER_TIME is '操作时间';
comment on column FUND_CHARGE_CENTER.OPER_ADMIN is '操作人编码';

create table FUND_WITHDRAW(
	FUND_NO CHAR(10)  not null,
	ACCOUNT_TYPE NUMBER(1)  not null,
	AO_CODE VARCHAR2(8)  not null,
	AO_NAME VARCHAR2(4000)  ,
	ACC_NO CHAR(12)  not null,
	APPLY_AMOUNT NUMBER(16)  not null,
	APPLY_ADMIN NUMBER(4)  not null,
	APPLY_DATE DATE  not null,
	MARKET_ADMIN NUMBER(4)  ,
	APPLY_CHECK_TIME DATE  ,
	CHECK_ADMIN_ID NUMBER(4)  ,
	APPLY_STATUS NUMBER(1)  not null,
	APPLY_MEMO VARCHAR2(4000)  ,
	TERMINAL_CODE CHAR(8)  ,
  FUND_TYPE NUMBER(1),
	constraint PK_FUND_WITHDRAW primary Key (FUND_NO)
);
comment on table FUND_WITHDRAW is '销售站（机构）提现';
comment on column FUND_WITHDRAW.FUND_NO is '提现编号（FW12345678）';
comment on column FUND_WITHDRAW.ACCOUNT_TYPE is '账户类型（1-机构，2-站点）';
comment on column FUND_WITHDRAW.AO_CODE is '销售站（机构）编码';
comment on column FUND_WITHDRAW.AO_NAME is '销售站（机构）名称';
comment on column FUND_WITHDRAW.ACC_NO is '账户编码';
comment on column FUND_WITHDRAW.APPLY_AMOUNT is '提现金额';
comment on column FUND_WITHDRAW.APPLY_ADMIN is '提现申请人';
comment on column FUND_WITHDRAW.APPLY_DATE is '提现申请时间';
comment on column FUND_WITHDRAW.MARKET_ADMIN is '市场管理员';
comment on column FUND_WITHDRAW.APPLY_CHECK_TIME is '提现审核时间';
comment on column FUND_WITHDRAW.CHECK_ADMIN_ID is '提现审核人';
comment on column FUND_WITHDRAW.APPLY_STATUS is '申请记录状态（1=已提交、2=已撤销、3=已审核、4=已拒绝、5-已提现、6=缴款成功）';
comment on column FUND_WITHDRAW.APPLY_MEMO is '备注';
comment on column FUND_WITHDRAW.TERMINAL_CODE is '提现终端机编码';
comment on column FUND_WITHDRAW.FUND_TYPE is '提现类型（1=现金、2=Wing）';

create table FUND_MM_CASH_REPAY(
	MCR_NO CHAR(10)  not null,
	MARKET_ADMIN NUMBER(4)  not null,
	REPAY_AMOUNT NUMBER(16)  ,
	REPAY_TIME DATE  ,
	REPAY_ADMIN NUMBER(4)  not null,
	REMARK VARCHAR2(4000)  ,
	constraint PK_FUND_MM_CASH_REPAY primary Key (MCR_NO)
);
comment on table FUND_MM_CASH_REPAY is '现金上缴';
comment on column FUND_MM_CASH_REPAY.MCR_NO is '上缴流水（JK12345678）';
comment on column FUND_MM_CASH_REPAY.MARKET_ADMIN is '市场管理员';
comment on column FUND_MM_CASH_REPAY.REPAY_AMOUNT is '还款金额';
comment on column FUND_MM_CASH_REPAY.REPAY_TIME is '还款日期';
comment on column FUND_MM_CASH_REPAY.REPAY_ADMIN is '收款人';
comment on column FUND_MM_CASH_REPAY.REMARK is '备注';
create index IDX_FUND_MM_CR_MM on FUND_MM_CASH_REPAY(MARKET_ADMIN);
create index IDX_FUND_MM_CR_DATE on FUND_MM_CASH_REPAY(REPAY_TIME);

create table ITEM_ITEMS(
	ITEM_CODE CHAR(8)  not null,
	ITEM_NAME VARCHAR2(4000)  not null,
	BASE_UNIT_NAME VARCHAR2(500)  not null,
	STATUS NUMBER(1) default 1 not null,
	constraint PK_ITEM_ITEMS primary Key (ITEM_CODE)
);
comment on table ITEM_ITEMS is '物品';
comment on column ITEM_ITEMS.ITEM_CODE is '物品编码（IT123456）';
comment on column ITEM_ITEMS.ITEM_NAME is '物品名称';
comment on column ITEM_ITEMS.BASE_UNIT_NAME is '单位名称';
comment on column ITEM_ITEMS.STATUS is '状态（1-启用，2-删除）';

create table ITEM_QUANTITY(
	ITEM_CODE CHAR(8)  not null,
	WAREHOUSE_CODE CHAR(4)  not null,
	ITEM_NAME VARCHAR2(4000)  not null,
	QUANTITY NUMBER(10)  not null,
	constraint PK_ITEM_QUANTITY primary Key (ITEM_CODE,WAREHOUSE_CODE)
);
comment on table ITEM_QUANTITY is '物品库存';
comment on column ITEM_QUANTITY.ITEM_CODE is '物品编码（IT123456）';
comment on column ITEM_QUANTITY.WAREHOUSE_CODE is '所在仓库';
comment on column ITEM_QUANTITY.ITEM_NAME is '物品名称';
comment on column ITEM_QUANTITY.QUANTITY is '物品数量';

create table ITEM_RECEIPT(
	IR_NO CHAR(10)  not null,
	CREATE_ADMIN NUMBER(4)  ,
	RECEIVE_ORG CHAR(2)  ,
	RECEIVE_WH CHAR(4)  ,
	RECEIVE_DATE DATE  ,
	REMARK VARCHAR2(4000)  ,
	constraint PK_ITEM_RECEIPT primary Key (IR_NO)
);
comment on table ITEM_RECEIPT is '物品入库';
comment on column ITEM_RECEIPT.IR_NO is '入库单编号（IR12345678）';
comment on column ITEM_RECEIPT.CREATE_ADMIN is '建立人';
comment on column ITEM_RECEIPT.RECEIVE_ORG is '入库仓库所属单位';
comment on column ITEM_RECEIPT.RECEIVE_WH is '入库仓库';
comment on column ITEM_RECEIPT.RECEIVE_DATE is '入库时间';
comment on column ITEM_RECEIPT.REMARK is '备注';

create table ITEM_RECEIPT_DETAIL(
	IR_NO CHAR(10)  not null,
	ITEM_CODE CHAR(8)  ,
	QUANTITY NUMBER(10)  ,
	constraint PK_ITEM_RECEIPT_DETAIL primary Key (IR_NO,ITEM_CODE)
);
comment on table ITEM_RECEIPT_DETAIL is '物品入库明细';
comment on column ITEM_RECEIPT_DETAIL.IR_NO is '入库单编号（IR12345678）';
comment on column ITEM_RECEIPT_DETAIL.ITEM_CODE is '物品编码（IT123456）';
comment on column ITEM_RECEIPT_DETAIL.QUANTITY is '数量';

create table ITEM_ISSUE(
	II_NO CHAR(10)  not null,
	OPER_ADMIN NUMBER(4)  not null,
	ISSUE_DATE DATE  ,
	RECEIVE_ORG CHAR(2)  ,
	SEND_ORG CHAR(2)  ,
	SEND_WH CHAR(4)  ,
	REMARK VARCHAR2(4000)  ,
	constraint PK_ITEM_ISSUE primary Key (II_NO)
);
comment on table ITEM_ISSUE is '物品出库';
comment on column ITEM_ISSUE.II_NO is '出库单编号（II12345678）';
comment on column ITEM_ISSUE.OPER_ADMIN is '操作人';
comment on column ITEM_ISSUE.ISSUE_DATE is '出库时间';
comment on column ITEM_ISSUE.RECEIVE_ORG is '收货单位';
comment on column ITEM_ISSUE.SEND_ORG is '发货单位';
comment on column ITEM_ISSUE.SEND_WH is '发货仓库';
comment on column ITEM_ISSUE.REMARK is '备注';

create table ITEM_ISSUE_DETAIL(
	II_NO CHAR(10)  not null,
	ITEM_CODE CHAR(8)  ,
	QUANTITY NUMBER(10)  ,
	constraint PK_ITEM_ISSUE_DETAIL primary Key (II_NO,ITEM_CODE)
);
comment on table ITEM_ISSUE_DETAIL is '物品出库明细';
comment on column ITEM_ISSUE_DETAIL.II_NO is '出库单编号（II12345678）';
comment on column ITEM_ISSUE_DETAIL.ITEM_CODE is '物品编码（IT123456）';
comment on column ITEM_ISSUE_DETAIL.QUANTITY is '数量';

create table ITEM_CHECK(
	CHECK_NO CHAR(10)  not null,
	CHECK_NAME VARCHAR2(500)  ,
	CHECK_DATE DATE  ,
	CHECK_ADMIN NUMBER(4)  not null,
	CHECK_WAREHOUSE CHAR(4)  ,
	STATUS NUMBER(1)  not null,
	REMARK VARCHAR2(4000)  ,
	constraint PK_ITEM_CHECK primary Key (CHECK_NO)
);
comment on table ITEM_CHECK is '物品盘点';
comment on column ITEM_CHECK.CHECK_NO is '盘点编号（IC12345678）';
comment on column ITEM_CHECK.CHECK_NAME is '盘点名称';
comment on column ITEM_CHECK.CHECK_DATE is '盘点日期';
comment on column ITEM_CHECK.CHECK_ADMIN is '操作人';
comment on column ITEM_CHECK.CHECK_WAREHOUSE is '盘点仓库';
comment on column ITEM_CHECK.STATUS is '状态（1-未完成，2-已完成）';
comment on column ITEM_CHECK.REMARK is '备注';

create table ITEM_CHECK_DETAIL_BE(
	CHECK_NO CHAR(10)  not null,
	ITEM_CODE CHAR(8)  ,
	QUANTITY NUMBER(10)  ,
	constraint PK_ITEM_CHECK_DETAIL_BE primary Key (CHECK_NO,ITEM_CODE)
);
comment on table ITEM_CHECK_DETAIL_BE is '物品盘点前明细';
comment on column ITEM_CHECK_DETAIL_BE.CHECK_NO is '盘点编号（IC12345678）';
comment on column ITEM_CHECK_DETAIL_BE.ITEM_CODE is '物品编码（IT123456）';
comment on column ITEM_CHECK_DETAIL_BE.QUANTITY is '数量';

create table ITEM_CHECK_DETAIL_AF(
	CHECK_NO CHAR(10)  not null,
	ITEM_CODE CHAR(8)  ,
	QUANTITY NUMBER(10)  ,
	CHANGE_QUANTITY NUMBER(10)  ,
	RESULT NUMBER(1)  not null,
	constraint PK_ITEM_CHECK_DETAIL_AF primary Key (CHECK_NO,ITEM_CODE)
);
comment on table ITEM_CHECK_DETAIL_AF is '物品盘点后明细';
comment on column ITEM_CHECK_DETAIL_AF.CHECK_NO is '盘点编号（IC12345678）';
comment on column ITEM_CHECK_DETAIL_AF.ITEM_CODE is '物品编码（IT123456）';
comment on column ITEM_CHECK_DETAIL_AF.QUANTITY is '数量';
comment on column ITEM_CHECK_DETAIL_AF.CHANGE_QUANTITY is '调整量';
comment on column ITEM_CHECK_DETAIL_AF.RESULT is '盘点结果（1-一致，2-盘亏，3-盘盈）';

create table ITEM_DAMAGE(
	ID_NO CHAR(10)  not null,
	DAMAGE_DATE DATE  not null,
	WAREHOUSE_CODE CHAR(4)  not null,
	ITEM_CODE CHAR(8)  not null,
	QUANTITY NUMBER(10)  not null,
	CHECK_ADMIN NUMBER(4)  not null,
	REMARK VARCHAR2(2000)  ,
	constraint PK_ITEM_DAMAGE primary Key (ID_NO,ITEM_CODE)
);
comment on table ITEM_DAMAGE is '物品损毁登记';
comment on column ITEM_DAMAGE.ID_NO is '损毁登记编号（ID12345678）';
comment on column ITEM_DAMAGE.DAMAGE_DATE is '损毁日期';
comment on column ITEM_DAMAGE.WAREHOUSE_CODE is '仓库编号';
comment on column ITEM_DAMAGE.ITEM_CODE is '物品编码（IT123456）';
comment on column ITEM_DAMAGE.QUANTITY is '损毁 数量';
comment on column ITEM_DAMAGE.CHECK_ADMIN is '操作人';
comment on column ITEM_DAMAGE.REMARK is '备注';

create table HIS_LOTTERY_INVENTORY(
	CALC_DATE VARCHAR2(10)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	BATCH_NO VARCHAR2(10)  not null,
	REWARD_GROUP NUMBER(2)  not null,
	STATUS NUMBER(2) default 1 not null,
	WAREHOUSE VARCHAR2(8)  ,
	TICKETS NUMBER(28)  not null,
	AMOUNT NUMBER(28)  not null,
	constraint PK_HIS_LOTTERY_INVENTORY primary Key (CALC_DATE,PLAN_CODE,BATCH_NO,REWARD_GROUP,STATUS, WAREHOUSE)
);
comment on table HIS_LOTTERY_INVENTORY is '库存历史';
comment on column HIS_LOTTERY_INVENTORY.CALC_DATE is '统计日期';
comment on column HIS_LOTTERY_INVENTORY.PLAN_CODE is '方案';
comment on column HIS_LOTTERY_INVENTORY.BATCH_NO is '批次';
comment on column HIS_LOTTERY_INVENTORY.REWARD_GROUP is '奖组';
comment on column HIS_LOTTERY_INVENTORY.STATUS is '状态（11-在库、12-在站点，20-在途，21-管理员持有，31-已销售、41-被盗、42-损坏、43-丢失）';
comment on column HIS_LOTTERY_INVENTORY.WAREHOUSE is '所在仓库';
comment on column HIS_LOTTERY_INVENTORY.TICKETS is '票数量';
comment on column HIS_LOTTERY_INVENTORY.AMOUNT is '金额';

create table HIS_AGENCY_FUND(
	CALC_DATE VARCHAR2(10)  not null,
	AGENCY_CODE CHAR(8)  not null,
	FLOW_TYPE NUMBER(2)  not null,
	AMOUNT NUMBER(28)  not null,
	BE_ACCOUNT_BALANCE NUMBER(28) default 1 not null,
	AF_ACCOUNT_BALANCE NUMBER(28)  not null,
	constraint PK_HIS_AGENCY_FUND primary Key (CALC_DATE,AGENCY_CODE,FLOW_TYPE)
);
comment on table HIS_AGENCY_FUND is '站点资金历史';
comment on column HIS_AGENCY_FUND.CALC_DATE is '统计日期';
comment on column HIS_AGENCY_FUND.AGENCY_CODE is '销售站点';
comment on column HIS_AGENCY_FUND.FLOW_TYPE is '资金类型（1-充值，2-提现，5-销售佣金，6-兑奖佣金，7-销售，8-兑奖，11-站点退货，13-撤销佣金，0-仅用于显示当天期初和期末余额）';
comment on column HIS_AGENCY_FUND.AMOUNT is '发生金额';
comment on column HIS_AGENCY_FUND.BE_ACCOUNT_BALANCE is '期初余额';
comment on column HIS_AGENCY_FUND.AF_ACCOUNT_BALANCE is '期末余额';
create index IDX_HIS_AGENCY_FUND_CALC on HIS_AGENCY_FUND(CALC_DATE);

create table HIS_AGENCY_INV(
	CALC_DATE VARCHAR2(10)  not null,
	AGENCY_CODE CHAR(8)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	OPER_TYPE NUMBER(2)  not null,
	TICKETS NUMBER(28) default 0 not null,
	AMOUNT NUMBER(28) default 0 not null,
	constraint PK_HIS_AGENCY_INV primary Key (CALC_DATE,AGENCY_CODE,PLAN_CODE,OPER_TYPE)
);
comment on table HIS_AGENCY_INV is '站点库存历史';
comment on column HIS_AGENCY_INV.CALC_DATE is '统计日期';
comment on column HIS_AGENCY_INV.AGENCY_CODE is '销售站点';
comment on column HIS_AGENCY_INV.PLAN_CODE is '方案';
comment on column HIS_AGENCY_INV.OPER_TYPE is '资金类型（10-退货，20-销售，88-期初，99-期末）';
comment on column HIS_AGENCY_INV.TICKETS is '票数';
comment on column HIS_AGENCY_INV.AMOUNT is '金额';
create index IDX_HIS_AGENCY_INV_CALC on HIS_AGENCY_INV(CALC_DATE);
create index IDX_HIS_AGENCY_INV_AGENCY on HIS_AGENCY_INV(AGENCY_CODE);

create table HIS_MM_FUND(
	CALC_DATE VARCHAR2(10)  not null,
	MARKET_ADMIN NUMBER(4)  not null,
	FLOW_TYPE NUMBER(2)  not null,
	AMOUNT NUMBER(28)  not null,
	BE_ACCOUNT_BALANCE NUMBER(28)  not null,
	AF_ACCOUNT_BALANCE NUMBER(28)  not null,
	constraint PK_HIS_MM_FUND primary Key (CALC_DATE,MARKET_ADMIN,FLOW_TYPE)
);
comment on table HIS_MM_FUND is '市场管理员资金历史';
comment on column HIS_MM_FUND.CALC_DATE is '统计日期';
comment on column HIS_MM_FUND.MARKET_ADMIN is '市场管理员';
comment on column HIS_MM_FUND.FLOW_TYPE is '资金类型（9-为站点充值，10-现金上缴，14-为站点提现，0-仅用于显示当天期初和期末余额）';
comment on column HIS_MM_FUND.AMOUNT is '发生金额';
comment on column HIS_MM_FUND.BE_ACCOUNT_BALANCE is '期初余额';
comment on column HIS_MM_FUND.AF_ACCOUNT_BALANCE is '期末余额';
create index IDX_HIS_MM_FUND_CALC on HIS_MM_FUND(CALC_DATE);
create index IDX_HIS_MM_FUND_MM_FLOW on HIS_MM_FUND(MARKET_ADMIN,FLOW_TYPE);

create table HIS_MM_INVENTORY(
	CALC_DATE VARCHAR2(10)  not null,
	MARKET_ADMIN NUMBER(4)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	OPEN_INV NUMBER(28)  not null,
	CLOSE_INV NUMBER(28)  not null,
	GOT_TICKETS NUMBER(28)  not null,
	SALED_TICKETS NUMBER(28)  not null,
	CANCELED_TICKETS NUMBER(28)  not null,
	RETURN_TICKETS NUMBER(28)  not null,
	BROKEN_TICKETS NUMBER(28)  not null,
	constraint PK_HIS_MM_INVENTORY primary Key (CALC_DATE,MARKET_ADMIN,PLAN_CODE)
);
comment on table HIS_MM_INVENTORY is '市场管理员库存历史';
comment on column HIS_MM_INVENTORY.CALC_DATE is '统计日期';
comment on column HIS_MM_INVENTORY.MARKET_ADMIN is '市场管理员';
comment on column HIS_MM_INVENTORY.PLAN_CODE is '方案';
comment on column HIS_MM_INVENTORY.OPEN_INV is '期初库存';
comment on column HIS_MM_INVENTORY.CLOSE_INV is '期末库存';
comment on column HIS_MM_INVENTORY.GOT_TICKETS is '收货数量';
comment on column HIS_MM_INVENTORY.SALED_TICKETS is '销售数量';
comment on column HIS_MM_INVENTORY.CANCELED_TICKETS is '退货数量';
comment on column HIS_MM_INVENTORY.RETURN_TICKETS is '还货数量';
comment on column HIS_MM_INVENTORY.BROKEN_TICKETS is '损毁数量';
create index IDX_HIS_MM_INV_CALC on HIS_MM_INVENTORY(CALC_DATE);
create index IDX_HIS_MM_INV_MM_FLOW on HIS_MM_INVENTORY(MARKET_ADMIN,PLAN_CODE);

create table HIS_ORG_FUND_REPORT(
	CALC_DATE VARCHAR2(10)  not null,
	ORG_CODE CHAR(2)  not null,
	BE_ACCOUNT_BALANCE NUMBER(28) default 0 not null,
	CHARGE NUMBER(28) default 0 not null,
	WITHDRAW NUMBER(28) default 0 not null,
	SALE NUMBER(28) default 0 not null,
	SALE_COMM NUMBER(28) default 0 not null,
	PAID NUMBER(28) default 0 not null,
	PAY_COMM NUMBER(28) default 0 not null,
	RTV NUMBER(28) default 0 not null,
	RTV_COMM NUMBER(28) default 0 not null,
	CENTER_PAY NUMBER(28) default 0 not null,
	CENTER_PAY_COMM NUMBER(28) default 0 not null,
	LOT_SALE NUMBER(28) default 0 not null,
	LOT_SALE_COMM NUMBER(28) default 0 not null,
	LOT_PAID NUMBER(28) default 0 not null,
	LOT_PAY_COMM NUMBER(28) default 0 not null,
	LOT_RTV NUMBER(28) default 0 not null,
	LOT_RTV_COMM NUMBER(28) default 0 not null,
	LOT_CENTER_PAY NUMBER(28) default 0 not null,
	LOT_CENTER_PAY_COMM NUMBER(28) default 0 not null,
	LOT_CENTER_RTV NUMBER(28) default 0 not null,
	LOT_CENTER_RTV_COMM NUMBER(28) default 0 not null,
	AF_ACCOUNT_BALANCE NUMBER(28) default 0 not null,
	INCOMING NUMBER(28) default 0 not null,
	PAY_UP NUMBER(28) default 0 not null,
	constraint PK_HIS_ORG_FUND_REPORT primary Key (CALC_DATE,ORG_CODE)
);
comment on table HIS_ORG_FUND_REPORT is '部门资金报表';
comment on column HIS_ORG_FUND_REPORT.CALC_DATE is '统计日期';
comment on column HIS_ORG_FUND_REPORT.ORG_CODE is '部门编码';
comment on column HIS_ORG_FUND_REPORT.BE_ACCOUNT_BALANCE is '期初余额';
comment on column HIS_ORG_FUND_REPORT.CHARGE is '充值';
comment on column HIS_ORG_FUND_REPORT.WITHDRAW is '提现';
comment on column HIS_ORG_FUND_REPORT.SALE is '销售';
comment on column HIS_ORG_FUND_REPORT.SALE_COMM is '销售佣金';
comment on column HIS_ORG_FUND_REPORT.PAID is '兑奖';
comment on column HIS_ORG_FUND_REPORT.PAY_COMM is '兑奖佣金';
comment on column HIS_ORG_FUND_REPORT.RTV is '站点退货';
comment on column HIS_ORG_FUND_REPORT.RTV_COMM is '退货佣金';
comment on column HIS_ORG_FUND_REPORT.CENTER_PAY is '中心兑奖';
comment on column HIS_ORG_FUND_REPORT.CENTER_PAY_COMM is '中心兑奖佣金';
comment on column HIS_ORG_FUND_REPORT.LOT_SALE is '销售';
comment on column HIS_ORG_FUND_REPORT.LOT_SALE_COMM is '销售佣金';
comment on column HIS_ORG_FUND_REPORT.LOT_PAID is '兑奖';
comment on column HIS_ORG_FUND_REPORT.LOT_PAY_COMM is '兑奖佣金';
comment on column HIS_ORG_FUND_REPORT.LOT_RTV is '站点退货';
comment on column HIS_ORG_FUND_REPORT.LOT_RTV_COMM is '退货佣金';
comment on column HIS_ORG_FUND_REPORT.LOT_CENTER_PAY is '中心兑奖';
comment on column HIS_ORG_FUND_REPORT.LOT_CENTER_PAY_COMM is '中心兑奖佣金';
comment on column HIS_ORG_FUND_REPORT.LOT_CENTER_RTV is '中心退票';
comment on column HIS_ORG_FUND_REPORT.lot_center_rtv_comm  is '中心退票佣金';
comment on column HIS_ORG_FUND_REPORT.AF_ACCOUNT_BALANCE is '期末余额';
comment on column HIS_ORG_FUND_REPORT.INCOMING is '收入';
comment on column HIS_ORG_FUND_REPORT.PAY_UP is '应缴现金';
create index IDX_HIS_ORG_FUND_CALC on HIS_ORG_FUND_REPORT(CALC_DATE);


create table HIS_ORG_FUND(
	CALC_DATE VARCHAR2(10)  not null,
	ORG_CODE CHAR(2)  not null,
	CHARGE NUMBER(28) default 0 not null,
	WITHDRAW NUMBER(28) default 0 not null,
	CENTER_PAID NUMBER(28) default 0 not null,
	CENTER_PAID_COMM NUMBER(28) default 0 not null,
	PAY_UP NUMBER(28) default 0 not null,
	constraint PK_HIS_ORG_FUND primary Key (CALC_DATE,ORG_CODE)
);
comment on table HIS_ORG_FUND is '机构资金历史报表';
comment on column HIS_ORG_FUND.CALC_DATE is '统计日期';
comment on column HIS_ORG_FUND.ORG_CODE is '部门编码';
comment on column HIS_ORG_FUND.CHARGE is '充值';
comment on column HIS_ORG_FUND.WITHDRAW is '提现';
comment on column HIS_ORG_FUND.CENTER_PAID is '中心兑奖';
comment on column HIS_ORG_FUND.CENTER_PAID_COMM is '中心兑奖佣金';
comment on column HIS_ORG_FUND.PAY_UP is '应缴现金';
create index IDX_HIS_ORG_FUND_DATE on HIS_ORG_FUND(CALC_DATE);

create table HIS_ORG_INV_REPORT(
	CALC_DATE VARCHAR2(10)  not null,
	ORG_CODE CHAR(2)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	OPER_TYPE NUMBER(2) default 0 not null,
	TICKETS NUMBER(28) default 0 not null,
	AMOUNT NUMBER(28) default 0 not null,
	constraint PK_HIS_ORG_INV_REPORT primary Key (CALC_DATE,ORG_CODE,PLAN_CODE,OPER_TYPE)
);
comment on table HIS_ORG_INV_REPORT is '机构库存历史报表';
comment on column HIS_ORG_INV_REPORT.CALC_DATE is '统计日期';
comment on column HIS_ORG_INV_REPORT.ORG_CODE is '部门编码';
comment on column HIS_ORG_INV_REPORT.PLAN_CODE is '方案';
comment on column HIS_ORG_INV_REPORT.OPER_TYPE is '操作类型（1=调拨出库、4=站点退货、12=调拨入库、14=站点销售、20=损毁、88=期初、99=期末）';
comment on column HIS_ORG_INV_REPORT.TICKETS is '票数';
comment on column HIS_ORG_INV_REPORT.AMOUNT is '金额';
create index IDX_HIS_ORG_INV_ORG_PLAN on HIS_ORG_INV_REPORT(ORG_CODE,PLAN_CODE);

create table HIS_SALE_ORG(
	CALC_DATE VARCHAR2(10)  not null,
	ORG_CODE CHAR(2)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	SALE_AMOUNT NUMBER(28) default 0 not null,
	SALE_COMM NUMBER(28) default 0 not null,
	CANCEL_AMOUNT NUMBER(28) default 0 not null,
	CANCEL_COMM NUMBER(28) default 0 not null,
	PAID_AMOUNT NUMBER(28) default 0 not null,
	PAID_COMM NUMBER(28) default 0 not null,
	INCOMING NUMBER(28) default 0 not null,
	constraint PK_HIS_SALE_ORG primary Key (CALC_DATE,PLAN_CODE,ORG_CODE)
);
comment on table HIS_SALE_ORG is '销量按部门监控';
comment on column HIS_SALE_ORG.CALC_DATE is '统计日期';
comment on column HIS_SALE_ORG.ORG_CODE is '部门编码';
comment on column HIS_SALE_ORG.PLAN_CODE is '方案编码';
comment on column HIS_SALE_ORG.SALE_AMOUNT is '销售金额';
comment on column HIS_SALE_ORG.SALE_COMM is '销售佣金';
comment on column HIS_SALE_ORG.CANCEL_AMOUNT is '退票金额';
comment on column HIS_SALE_ORG.CANCEL_COMM is '退票佣金';
comment on column HIS_SALE_ORG.PAID_AMOUNT is '所属销售站兑奖金额';
comment on column HIS_SALE_ORG.PAID_COMM is '所属销售站兑奖佣金';
comment on column HIS_SALE_ORG.INCOMING is '部门收入';

create table HIS_AGENT_FUND_REPORT(
	CALC_DATE VARCHAR2(10)  not null,
	ORG_CODE CHAR(2)  not null,
	FLOW_TYPE NUMBER(2)  not null,
	AMOUNT NUMBER(28)  not null,
	constraint PK_HIS_AGENT_FUND_REPORT primary Key (CALC_DATE,ORG_CODE,FLOW_TYPE)
);
comment on table HIS_AGENT_FUND_REPORT is '代理商资金报表';
comment on column HIS_AGENT_FUND_REPORT.CALC_DATE is '统计日期';
comment on column HIS_AGENT_FUND_REPORT.ORG_CODE is '代理商';
comment on column HIS_AGENT_FUND_REPORT.FLOW_TYPE is '资金类型（1-充值，2-提现，5-销售佣金，6-兑奖佣金，7-销售，8-兑奖，11-站点退货，13-撤销佣金，）';
comment on column HIS_AGENT_FUND_REPORT.AMOUNT is '发生金额';
create index IDX_HIS_AGENCT_FUND_CALC on HIS_AGENT_FUND_REPORT(CALC_DATE);

create table HIS_SALE_HOUR(
	CALC_DATE VARCHAR2(10)  not null,
	CALC_TIME NUMBER(10)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	ORG_CODE CHAR(2)  not null,
	SALE_AMOUNT NUMBER(28) default 0 not null,
	CANCEL_AMOUNT NUMBER(28) default 0 not null,
	PAY_AMOUNT NUMBER(28) default 0 not null,
	DAY_SALE_AMOUNT NUMBER(28) default 0 not null,
	DAY_CANCEL_AMOUNT NUMBER(28) default 0 not null,
	DAY_PAY_AMOUNT NUMBER(28) default 0 not null,
	constraint PK_HIS_SALE_HOUR primary Key (CALC_DATE,CALC_TIME,PLAN_CODE,ORG_CODE)
);
comment on table HIS_SALE_HOUR is '销量按时间段监控';
comment on column HIS_SALE_HOUR.CALC_DATE is '统计日期';
comment on column HIS_SALE_HOUR.CALC_TIME is '统计时间（24小时）';
comment on column HIS_SALE_HOUR.PLAN_CODE is '方案编码';
comment on column HIS_SALE_HOUR.ORG_CODE is '部门编码';
comment on column HIS_SALE_HOUR.SALE_AMOUNT is '销售金额';
comment on column HIS_SALE_HOUR.CANCEL_AMOUNT is '退票金额';
comment on column HIS_SALE_HOUR.PAY_AMOUNT is '兑奖金额';
comment on column HIS_SALE_HOUR.DAY_SALE_AMOUNT is '日累计销售金额';
comment on column HIS_SALE_HOUR.DAY_CANCEL_AMOUNT is '日累计退票金额';
comment on column HIS_SALE_HOUR.DAY_PAY_AMOUNT is '日累计兑奖金额';

create table HIS_SALE_HOUR_AGENCY(
	CALC_DATE VARCHAR2(10)  not null,
	CALC_TIME NUMBER(10)  not null,
	PLAN_CODE VARCHAR2(10)  not null,
	AGENCY_CODE CHAR(8)  not null,
	AREA_CODE CHAR(4)  not null,
	SALE_AMOUNT NUMBER(28) default 0 not null,
	CANCEL_AMOUNT NUMBER(28) default 0 not null,
	PAY_AMOUNT NUMBER(28) default 0 not null,
	DAY_SALE_AMOUNT NUMBER(28) default 0 not null,
	DAY_CANCEL_AMOUNT NUMBER(28) default 0 not null,
	DAY_PAY_AMOUNT NUMBER(28) default 0 not null,
	constraint PK_HIS_SALE_HOUR_AGENCY primary Key (CALC_DATE,CALC_TIME,PLAN_CODE,AGENCY_CODE)
);
comment on table HIS_SALE_HOUR_AGENCY is '销量按时间段监控之销售站排行';
comment on column HIS_SALE_HOUR_AGENCY.CALC_DATE is '统计日期';
comment on column HIS_SALE_HOUR_AGENCY.CALC_TIME is '统计时间（24小时）';
comment on column HIS_SALE_HOUR_AGENCY.PLAN_CODE is '方案编码';
comment on column HIS_SALE_HOUR_AGENCY.AGENCY_CODE is '销售站编码';
comment on column HIS_SALE_HOUR_AGENCY.AREA_CODE is '所属区域编码';
comment on column HIS_SALE_HOUR_AGENCY.SALE_AMOUNT is '销售金额';
comment on column HIS_SALE_HOUR_AGENCY.CANCEL_AMOUNT is '退票金额';
comment on column HIS_SALE_HOUR_AGENCY.PAY_AMOUNT is '兑奖金额';
comment on column HIS_SALE_HOUR_AGENCY.DAY_SALE_AMOUNT is '日累计销售金额';
comment on column HIS_SALE_HOUR_AGENCY.DAY_CANCEL_AMOUNT is '日累计退票金额';
comment on column HIS_SALE_HOUR_AGENCY.DAY_PAY_AMOUNT is '日累计兑奖金额';

create table HIS_TERMINAL_ONLINE(
	CALC_DATE VARCHAR2(10)  not null,
	CALC_TIME NUMBER(10)  not null,
	ORG_CODE VARCHAR2(10)  not null,
	ORG_NAME VARCHAR2(4000)  not null,
	TOTAL_COUNT NUMBER(28)  not null,
	ONLINE_COUNT NUMBER(28) default 0 not null,
	constraint PK_HIS_TERMINAL_ONLINE primary Key (CALC_DATE,CALC_TIME,ORG_CODE)
);
comment on table HIS_TERMINAL_ONLINE is '销量按时间段监控之销售站排行';
comment on column HIS_TERMINAL_ONLINE.CALC_DATE is '统计日期';
comment on column HIS_TERMINAL_ONLINE.CALC_TIME is '统计时间（24小时，每10分钟一个间隔，从1-144）';
comment on column HIS_TERMINAL_ONLINE.ORG_CODE is '机构编码';
comment on column HIS_TERMINAL_ONLINE.ORG_NAME is '机构名称';
comment on column HIS_TERMINAL_ONLINE.TOTAL_COUNT is '终端总数量';
comment on column HIS_TERMINAL_ONLINE.ONLINE_COUNT is '上线终端数量';

create table HIS_DIM_DWM(
	D_YEAR CHAR(4)  not null,
	D_MONTH CHAR(7)  not null,
	D_WEEK CHAR(2)  not null,
	D_DAY CHAR(10)  not null,
	constraint PK_HIS_DIM_DM primary Key (D_YEAR,D_MONTH,D_DAY)
);
comment on table HIS_DIM_DWM is '日期维度';
comment on column HIS_DIM_DWM.D_YEAR is '年维度';
comment on column HIS_DIM_DWM.D_MONTH is '月维度';
comment on column HIS_DIM_DWM.D_WEEK is '周维度';
comment on column HIS_DIM_DWM.D_DAY is '日维度';

create table HIS_SALE_PAY_CANCEL(
	SALE_DATE VARCHAR2(10)  not null,
	SALE_MONTH VARCHAR2(10)  not null,
	AREA_CODE CHAR(4)  ,
	ORG_CODE CHAR(2)  not null,
	PLAN_CODE VARCHAR2(4000)  not null,
	SALE_AMOUNT NUMBER(28)  ,
	SALE_COMM NUMBER(28)  ,
	CANCEL_AMOUNT NUMBER(28)  ,
	CANCEL_COMM NUMBER(28)  ,
	PAY_AMOUNT NUMBER(28)  ,
	PAY_COMM NUMBER(28)  ,
	INCOMING NUMBER(28)  ,
	constraint PK_HIS_SALE_PAY_CANCEL primary Key (SALE_DATE,SALE_MONTH,AREA_CODE,ORG_CODE,PLAN_CODE)
);
comment on table HIS_SALE_PAY_CANCEL is '日销售兑奖退票统计';
comment on column HIS_SALE_PAY_CANCEL.SALE_DATE is '统计日期';
comment on column HIS_SALE_PAY_CANCEL.SALE_MONTH is '统计月份';
comment on column HIS_SALE_PAY_CANCEL.AREA_CODE is '区域编码';
comment on column HIS_SALE_PAY_CANCEL.ORG_CODE is '部门编码';
comment on column HIS_SALE_PAY_CANCEL.PLAN_CODE is '方案编码（保存的是名称）';
comment on column HIS_SALE_PAY_CANCEL.SALE_AMOUNT is '销售金额';
comment on column HIS_SALE_PAY_CANCEL.SALE_COMM is '销售佣金';
comment on column HIS_SALE_PAY_CANCEL.CANCEL_AMOUNT is '退货金额';
comment on column HIS_SALE_PAY_CANCEL.CANCEL_COMM is '退货佣金';
comment on column HIS_SALE_PAY_CANCEL.PAY_AMOUNT is '兑奖金额';
comment on column HIS_SALE_PAY_CANCEL.PAY_COMM is '兑奖佣金';
comment on column HIS_SALE_PAY_CANCEL.INCOMING is '收入';
create index IDX_HIS_SALE_PAY_CANCEL_DAY on HIS_SALE_PAY_CANCEL(SALE_DATE);

create table HIS_PAY_LEVEL(
	SALE_DATE VARCHAR2(10)  not null,
	SALE_MONTH VARCHAR2(10)  not null,
	ORG_CODE CHAR(2)  not null,
	PLAN_CODE VARCHAR2(4000)  not null,
	LEVEL_1 NUMBER(28)  ,
	LEVEL_2 NUMBER(28)  ,
	LEVEL_3 NUMBER(28)  ,
	LEVEL_4 NUMBER(28)  ,
	LEVEL_5 NUMBER(28)  ,
	LEVEL_6 NUMBER(28)  ,
	LEVEL_7 NUMBER(28)  ,
	LEVEL_8 NUMBER(28)  ,
  LEVEL_OTHER NUMBER(28)  ,
	TOTAL NUMBER(28)  ,
	constraint PK_HIS_PAY_LEVEL primary Key (SALE_DATE,SALE_MONTH,ORG_CODE,PLAN_CODE)
);
comment on table HIS_PAY_LEVEL is '日兑奖按奖级统计';
comment on column HIS_PAY_LEVEL.SALE_DATE is '统计日期';
comment on column HIS_PAY_LEVEL.SALE_MONTH is '统计月份';
comment on column HIS_PAY_LEVEL.ORG_CODE is '部门编码';
comment on column HIS_PAY_LEVEL.PLAN_CODE is '方案编码（保存的是名称）';
comment on column HIS_PAY_LEVEL.LEVEL_1 is '一等奖奖金';
comment on column HIS_PAY_LEVEL.LEVEL_2 is '二等奖奖金';
comment on column HIS_PAY_LEVEL.LEVEL_3 is '三等奖奖金';
comment on column HIS_PAY_LEVEL.LEVEL_4 is '四等奖奖金';
comment on column HIS_PAY_LEVEL.LEVEL_5 is '五等奖奖金';
comment on column HIS_PAY_LEVEL.LEVEL_6 is '六等奖奖金';
comment on column HIS_PAY_LEVEL.LEVEL_7 is '七等奖奖金';
comment on column HIS_PAY_LEVEL.LEVEL_8 is '八等奖奖金';
comment on column HIS_PAY_LEVEL.LEVEL_OTHER is '其他奖级奖金';
comment on column HIS_PAY_LEVEL.TOTAL is '奖金';
create index IDX_HIS_PAY_LEVEL_DAY on HIS_PAY_LEVEL(SALE_DATE);

create table FUND_TUNING(
	FUND_NO CHAR(10)  not null,
	ACCOUNT_TYPE NUMBER(1)  not null,
	AO_CODE VARCHAR2(8)  not null,
	AO_NAME VARCHAR2(4000)  ,
	ACC_NO CHAR(12)  not null,
	CHANGE_AMOUNT NUMBER(28)  not null,
	BE_ACCOUNT_BALANCE NUMBER(28)  not null,
	AF_ACCOUNT_BALANCE NUMBER(28)  not null,
	OPER_TIME DATE  not null,
	OPER_ADMIN NUMBER(4)  not null,
	TUNING_REASON VARCHAR2(4000)  ,
	constraint PK_FUND_TUNING primary Key (FUND_NO)
);
comment on table FUND_TUNING is '销售站（机构）调账';
comment on column FUND_TUNING.FUND_NO is '调账编号（FT12345678）';
comment on column FUND_TUNING.ACCOUNT_TYPE is '账户类型（1-机构，2-站点）';
comment on column FUND_TUNING.AO_CODE is '销售站（机构）编码';
comment on column FUND_TUNING.AO_NAME is '销售站（机构）名称';
comment on column FUND_TUNING.ACC_NO is '账户编码';
comment on column FUND_TUNING.CHANGE_AMOUNT is '调整金额（调增为正数，调减为负数）';
comment on column FUND_TUNING.BE_ACCOUNT_BALANCE is '变更前可用余额';
comment on column FUND_TUNING.AF_ACCOUNT_BALANCE is '变更后可用余额';
comment on column FUND_TUNING.OPER_TIME is '操作时间';
comment on column FUND_TUNING.OPER_ADMIN is '操作人编码';
comment on column FUND_TUNING.TUNING_REASON is '调账原因';

create table ADM_ORG_RELATE
(
  admin_id NUMBER(4) not null,
  org_code CHAR(2) not null,
  constraint PK_ADM_ORG_RELATE primary key (ADMIN_ID, ORG_CODE)  using index tablespace TS_KWS_TAB
);

comment on table ADM_ORG_RELATE  is '用户部门关系表';
comment on column ADM_ORG_RELATE.admin_id  is '用户ID';
comment on column ADM_ORG_RELATE.org_code  is '机构编码（00代表总公司，01代表分公司）';

create table WH_MM_CHECK(
  CP_NO CHAR(10)  not null,
  MANAGER_ID NUMBER(4)  not null,
  RESULT NUMBER(1)  not null,
  INV_TICKETS   NUMBER(18)  not null,
  CHECK_TICKETS NUMBER(18)  not null,
  DIFF_TICKETS  NUMBER(18)  not null,
  SCAN_TICKETS  NUMBER(18)  not null,
  CP_DATE DATE  not null,
  constraint PK_WH_MM_CHECK primary Key (CP_NO)
);
comment on table WH_MM_CHECK is '管理员盘点单';
comment on column WH_MM_CHECK.CP_NO is '盘点单编号（PD12345678）';
comment on column WH_MM_CHECK.MANAGER_ID is '管理员';
comment on column WH_MM_CHECK.RESULT is '盘点结果（1-一致，0-不一致）';
comment on column WH_MM_CHECK.INV_TICKETS   is '管理员库存彩票数量';
comment on column WH_MM_CHECK.CHECK_TICKETS is '本次盘点中，属于管理员的彩票数量';
comment on column WH_MM_CHECK.DIFF_TICKETS  is '未盘点的管理员彩票数量';
comment on column WH_MM_CHECK.SCAN_TICKETS  is '盘点扫描数量';
comment on column WH_MM_CHECK.CP_DATE is '盘点日期';
create index IDX_WH_MM_CHECK_MM on WH_MM_CHECK(MANAGER_ID);
create index IDX_WH_MM_CHECK_DATE on WH_MM_CHECK(CP_DATE);

create table WH_MM_CHECK_DETAIL(
  CP_DETAIL_NO CHAR(10)  not null,
  CP_NO CHAR(10)  not null,
  MANAGER_ID NUMBER(4)  not null,
  PLAN_CODE VARCHAR2(10)  not null,
  BATCH_NO VARCHAR2(10)  not null,
  VALID_NUMBER NUMBER(1)  not null,
  TRUNK_NO     VARCHAR2(10)  ,
  BOX_NO       VARCHAR2(20)  ,
  PACKAGE_NO   VARCHAR2(10)  ,
  TICKETS      NUMBER(28)  not null,
  STATUS       NUMBER(1)  not null,
  constraint PK_WH_MM_CHECK_DETAIL primary Key (CP_DETAIL_NO)
);
comment on table WH_MM_CHECK_DETAIL is '管理员盘点结果明细';
comment on column WH_MM_CHECK_DETAIL.CP_DETAIL_NO is '盘点明细编号（PD12345678）';
comment on column WH_MM_CHECK_DETAIL.CP_NO is '盘点单编号（PD12345678）';
comment on column WH_MM_CHECK_DETAIL.MANAGER_ID is '管理员';
comment on column WH_MM_CHECK_DETAIL.PLAN_CODE is '方案编码                                          ';
comment on column WH_MM_CHECK_DETAIL.BATCH_NO is '批次                                              ';
comment on column WH_MM_CHECK_DETAIL.VALID_NUMBER is '有效位数（1-箱号、2-盒号、3-本号）';
comment on column WH_MM_CHECK_DETAIL.TRUNK_NO     is '箱号                                              ';
comment on column WH_MM_CHECK_DETAIL.BOX_NO       is '盒号';
comment on column WH_MM_CHECK_DETAIL.PACKAGE_NO   is '本号                                              ';
comment on column WH_MM_CHECK_DETAIL.TICKETS      is '张数                                              ';
comment on column WH_MM_CHECK_DETAIL.STATUS       is '管理员彩票库存状态（1-不在库、2-未扫描）';
create index IDX_WH_MM_CHECKDETAIL_CPNO on WH_MM_CHECK_DETAIL(CP_NO);

create table FUND_DIGITAL_TRANSLOG(
  DIGITAL_TRANS_NO CHAR(24)  not null,
  REF_NO VARCHAR2(24)  not null,
  DIGITAL_TRANS_TYPE NUMBER(1)  not null,
  DIGITAL_ACC_TYPE NUMBER(1)  not null,
  AGENCY_CODE CHAR(8)  not null,
  ACC_NO CHAR(12)  not null,
  DIGITAL_ACC_SEQ CHAR(12)  not null,
  DIGITAL_ACC_NO VARCHAR2(50)  not null,
  DIGITAL_ACC_FLOW VARCHAR2(50)  ,
  TRANS_CURRENCY NUMBER(2) default 1 not null,
  APPLY_AMOUNT NUMBER(28)  not null,
  TRANS_FEE NUMBER(28)  ,
  EXCHANGE_CONTEXT VARCHAR2(50)  ,
  DIGITAL_TRANS_STATUS NUMBER(1)  not null,
  REQ_TIME DATE  not null,
  RES_TIME DATE  ,
  REQ_JSON_DATA VARCHAR2(1000)  ,
  RES_JSON_DATA VARCHAR2(1000)  ,
  FAIL_REASON VARCHAR2(1000)  ,
  constraint PK_FUND_DIGITAL_TRANSLOG primary Key (DIGITAL_TRANS_NO)
);
comment on table FUND_DIGITAL_TRANSLOG is '电子账户交易记录';
comment on column FUND_DIGITAL_TRANSLOG.DIGITAL_TRANS_NO is '交易流水号';
comment on column FUND_DIGITAL_TRANSLOG.REF_NO is '参考交易流水';
comment on column FUND_DIGITAL_TRANSLOG.DIGITAL_TRANS_TYPE is '交易类型（1=充值、2=提现）';
comment on column FUND_DIGITAL_TRANSLOG.DIGITAL_ACC_TYPE is '电子账户类型（2-Wing）';
comment on column FUND_DIGITAL_TRANSLOG.AGENCY_CODE is '销售站编码';
comment on column FUND_DIGITAL_TRANSLOG.ACC_NO is '账户编码';
comment on column FUND_DIGITAL_TRANSLOG.DIGITAL_ACC_SEQ is '电子账户序号';
comment on column FUND_DIGITAL_TRANSLOG.DIGITAL_ACC_NO is '电子账户编号';
comment on column FUND_DIGITAL_TRANSLOG.DIGITAL_ACC_FLOW is '银行系统交易编号';
comment on column FUND_DIGITAL_TRANSLOG.TRANS_CURRENCY is '交易币种（1=瑞尔，2=美元）';
comment on column FUND_DIGITAL_TRANSLOG.APPLY_AMOUNT is '交易金额';
comment on column FUND_DIGITAL_TRANSLOG.TRANS_FEE is '交易费用';
comment on column FUND_DIGITAL_TRANSLOG.EXCHANGE_CONTEXT is '费率转换公式';
comment on column FUND_DIGITAL_TRANSLOG.DIGITAL_TRANS_STATUS is '交易状态（1=发起，2=成功返回，3=失败返回，4=返回超时）';
comment on column FUND_DIGITAL_TRANSLOG.REQ_TIME is '交易发起时间';
comment on column FUND_DIGITAL_TRANSLOG.RES_TIME is '交易响应时间';
comment on column FUND_DIGITAL_TRANSLOG.REQ_JSON_DATA is '发起交易附加数据';
comment on column FUND_DIGITAL_TRANSLOG.RES_JSON_DATA is '响应交易附加数据';
comment on column FUND_DIGITAL_TRANSLOG.FAIL_REASON is '失败原因';

create table ACC_AGENCY_DIGITAL_LIMIT(
	AGENCY_CODE CHAR(8)  not null,
	SINGLE_WD_LIMIT NUMBER(28) default 0 not null,
	DAY_WD_LIMIT NUMBER(28) default 0 not null,
	constraint PK_ACC_AGENCY_DIGITAL_LIMIT primary Key (AGENCY_CODE)
);
comment on table ACC_AGENCY_DIGITAL_LIMIT is '站点电子账户交易限额';
comment on column ACC_AGENCY_DIGITAL_LIMIT.AGENCY_CODE is '销售站编码';
comment on column ACC_AGENCY_DIGITAL_LIMIT.SINGLE_WD_LIMIT is '单笔提现额度';
comment on column ACC_AGENCY_DIGITAL_LIMIT.DAY_WD_LIMIT is '日提现额度';

create table ACC_AGENCY_ACCOUNT_DIGITAL(
	AGENCY_CODE CHAR(8)  not null,
	DIGITAL_ACC_TYPE NUMBER(1) default 1 not null,
	ACC_STATUS NUMBER(1)  not null,
	IS_DEFAULT NUMBER(1) default 0 not null,
	ACC_NO CHAR(12)  not null,
	CURRENCY NUMBER(2) default 1 not null,
	DIGITAL_ACC_SEQ CHAR(12)  ,
	DIGITAL_ACC_NO VARCHAR2(50)  not null,
	DIGITAL_ACC_USERNAME NVARCHAR2(500)  ,
	constraint PK_ACC_AGENCY_ACCOUNT_DIG primary Key (DIGITAL_ACC_SEQ)
);
comment on table ACC_AGENCY_ACCOUNT_DIGITAL is '站点电子账户信息';
comment on column ACC_AGENCY_ACCOUNT_DIGITAL.AGENCY_CODE is '销售站编码';
comment on column ACC_AGENCY_ACCOUNT_DIGITAL.DIGITAL_ACC_TYPE is '电子银行类型（2-Wing）';
comment on column ACC_AGENCY_ACCOUNT_DIGITAL.ACC_STATUS is '账户状态（1-可用，2-停用，3-异常）';
comment on column ACC_AGENCY_ACCOUNT_DIGITAL.IS_DEFAULT is '是否默认';
comment on column ACC_AGENCY_ACCOUNT_DIGITAL.ACC_NO is '账户编码';
comment on column ACC_AGENCY_ACCOUNT_DIGITAL.CURRENCY is '币种（1=瑞尔，2=美元）';
comment on column ACC_AGENCY_ACCOUNT_DIGITAL.DIGITAL_ACC_SEQ is '电子账户序号（销售站编码+”D”+3位序号）';
comment on column ACC_AGENCY_ACCOUNT_DIGITAL.DIGITAL_ACC_NO is '电子账户编号';
comment on column ACC_AGENCY_ACCOUNT_DIGITAL.DIGITAL_ACC_USERNAME is '电子账户用户名称';
