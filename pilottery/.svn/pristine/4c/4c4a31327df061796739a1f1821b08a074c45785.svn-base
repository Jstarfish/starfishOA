--------------------------------
--  Changed table flow_agency  --
---------------------------------
-- Create/Recreate indexes 
create index IDX_FLOW_AGENCY_TIME on FLOW_AGENCY (TRADE_TIME);

----------------------------------------------
--  Changed table game_batch_reward_detail  --
----------------------------------------------
-- Add comments to the columns 
comment on column GAME_BATCH_REWARD_DETAIL.pre_safe_code is '安全码前缀';
-- Drop indexes 
drop index IDX_GAME_BATCH_REWARD_DETAIL_M;
-- Create/Recreate indexes 
create index IDX_GAME_BATCH_REWARD_PBS on GAME_BATCH_REWARD_DETAIL (PLAN_CODE, BATCH_NO, SAFE_CODE);

-----------------------------------------
--  Changed table flow_market_manager  --
-----------------------------------------
-- Add comments to the columns 
comment on column FLOW_MARKET_MANAGER.flow_type is '资金类型（9-为站点充值，10-现金上缴，14-为站点提现）';

----------------------------------------
--  Changed table fund_mm_cash_repay  --
----------------------------------------
-- Add comments to the columns 
comment on column FUND_MM_CASH_REPAY.remark is '备注';

------------------------------
--  Changed table inf_orgs  --
------------------------------
-- Add comments to the columns 
comment on column INF_ORGS.org_code is '机构编码（00代表总公司，01代表分公司）';
comment on column INF_ORGS.org_name is '机构名称';
comment on column INF_ORGS.org_type is '机构类别（1-公司,2-代理）';

--------------------------------
--  Changed table item_issue  --
--------------------------------
-- Add comments to the columns 
comment on column ITEM_ISSUE.remark is '备注';
----------------------------------
--  Changed table item_receipt  --
----------------------------------
-- Add comments to the columns 
comment on column ITEM_RECEIPT.remark is '备注';

--------------------------------------
--  Changed table sale_paid_detail  --
--------------------------------------
-- Add comments to the columns 
comment on column SALE_PAID_DETAIL.paid_status is '兑奖状态（1-成功、2-非法票、3-已兑奖、4-中大奖、5-未中奖、6-未销售、8-批次终结）';

-------------------------------------------
--  Changed table wh_goods_issue_detail  --
-------------------------------------------
-- Add comments to the columns 
comment on column WH_GOODS_ISSUE_DETAIL.issue_type is '出库类型（1-调拨出库、2-出货单出库，3-损毁出库，4-站点退货）';  

--------------------------------
--  Changed table game_plans  --
--------------------------------
-- Add comments to the columns 
comment on column GAME_PLANS.publisher_code is '印制厂商（1=石家庄，3=中彩三场）';
  
------------------------------
--  Changed table flow_org  --
------------------------------

-- Add comments to the columns 
comment on column FLOW_ORG.flow_type is '资金类型（1-充值，2-提现，3-彩票调拨入库（机构）、4-彩票调拨入库佣金（机构）、12-彩票调拨出库（机构）、21-站点兑奖导致机构佣金（机构）、22-站点兑奖导致机构增加资金（机构）、23-中心兑奖导致机构佣金（机构）、24-中心兑奖导致机构增加资金（机构）、31-彩票调拨出库退佣金（机构））';

 
-----------------------------------------
--  Changed table his_org_fund_report  --
-----------------------------------------
-- Add/modify columns 
alter table HIS_ORG_FUND_REPORT add lot_sale NUMBER(28) default 0 not null;
alter table HIS_ORG_FUND_REPORT add lot_sale_comm NUMBER(28) default 0 not null;
alter table HIS_ORG_FUND_REPORT add lot_paid NUMBER(28) default 0 not null;
alter table HIS_ORG_FUND_REPORT add lot_pay_comm NUMBER(28) default 0 not null;
alter table HIS_ORG_FUND_REPORT add lot_rtv NUMBER(28) default 0 not null;
alter table HIS_ORG_FUND_REPORT add lot_rtv_comm NUMBER(28) default 0 not null;
alter table HIS_ORG_FUND_REPORT add lot_center_pay NUMBER(28) default 0 not null;
alter table HIS_ORG_FUND_REPORT add lot_center_pay_comm NUMBER(28) default 0 not null;
alter table HIS_ORG_FUND_REPORT add lot_center_rtv NUMBER(28) default 0 not null;
alter table HIS_ORG_FUND_REPORT add lot_center_rtv_comm NUMBER(28) default 0 not null;

-- Add comments to the table 
comment on table HIS_ORG_FUND_REPORT is '部门资金报表';
-- Add comments to the columns 
comment on column HIS_ORG_FUND_REPORT.lot_sale is '销售';
comment on column HIS_ORG_FUND_REPORT.lot_sale_comm is '销售佣金';
comment on column HIS_ORG_FUND_REPORT.lot_paid is '兑奖';
comment on column HIS_ORG_FUND_REPORT.lot_pay_comm is '兑奖佣金';
comment on column HIS_ORG_FUND_REPORT.lot_rtv is '站点退货';
comment on column HIS_ORG_FUND_REPORT.lot_rtv_comm is '退货佣金';
comment on column HIS_ORG_FUND_REPORT.lot_center_pay is '中心兑奖';
comment on column HIS_ORG_FUND_REPORT.lot_center_pay_comm is '中心兑奖佣金';
comment on column HIS_ORG_FUND_REPORT.lot_center_rtv is '中心退票';
comment on column HIS_ORG_FUND_REPORT.lot_center_rtv_comm  is '中心退票佣金';
-----------------------------------
--  Changed table his_pay_level  --
-----------------------------------
-- create table HIS_PAY_LEVEL_BAK;
create table HIS_PAY_LEVEL_BAK as select * from HIS_PAY_LEVEL;
alter table HIS_PAY_LEVEL drop column level_10;
alter table HIS_PAY_LEVEL rename column level_9 to LEVEL_OTHER;
-- Add comments to the columns 
comment on column HIS_PAY_LEVEL.level_other is '其他奖级奖金';
delete from HIS_PAY_LEVEL;
insert into HIS_PAY_LEVEL (SALE_DATE,SALE_MONTH,ORG_CODE,PLAN_CODE,LEVEL_1,LEVEL_2,LEVEL_3,LEVEL_4,LEVEL_5,LEVEL_6,LEVEL_7,LEVEL_8,LEVEL_OTHER,TOTAL) select SALE_DATE,SALE_MONTH,ORG_CODE,PLAN_CODE,LEVEL_1,LEVEL_2,LEVEL_3,LEVEL_4,LEVEL_5,LEVEL_6,LEVEL_7,LEVEL_8,LEVEL_9+LEVEL_10,TOTAL from HIS_PAY_LEVEL_BAK;
commit;