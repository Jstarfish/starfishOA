set feedback off 

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
