/********** 由自动发信程序调用，部署在webncp6主机上 ***********/

-- 每日销量
select plan_code,
       nvl(f_get_plan_name(plan_code),'-') plan_name,
       round(sum(SALE_AMOUNT)/4000,2) sale,
       round(sum(PAID_AMOUNT)/4000,2) pay,
       round(sum(CANCEL_AMOUNT)/4000,2) cancel
  from HIS_SALE_ORG t
 where CALC_DATE = to_char(trunc(sysdate - 1),'yyyy-mm-dd')
 group by plan_code

-- 月度销量
select to_char(sysdate,'yyyy') year,
       to_char(sysdate,'mm') month,
       sum(SALE_AMOUNT - CANCEL_AMOUNT) puresale_reil,
       round(sum(SALE_AMOUNT - CANCEL_AMOUNT)/4000,2) puresale_dollar
  from HIS_SALE_ORG t
 where CALC_DATE like to_char(sysdate,'yyyy-mm') || '%'

-- 交易站点数
with base as
 (select distinct agency_code
    from FLOW_SALE t
   where SALE_TIME >= trunc(sysdate - 1)
     and SALE_TIME < trunc(sysdate)
  union all
  select distinct PAY_AGENCY agency_code
    from FLOW_PAY t
   where PAY_TIME >= trunc(sysdate - 1)
     and PAY_TIME < trunc(sysdate)
  union all
  select distinct agency_code
    from FLOW_CANCEL t
   where CANCEL_TIME >= trunc(sysdate - 1)
     and CANCEL_TIME < trunc(sysdate))
select count(distinct agency_code) cnt
  from base;

-- 站点总数
select count(*) cnt from INF_AGENCYS where STATUS = 1;

-- 部门数据统计
with
fund_data as
 (select ORG_CODE,
       round(sum(SALE_AMOUNT)/4000,2) sale,
       round(sum(PAID_AMOUNT)/4000,2) pay,
       round(sum(CANCEL_AMOUNT)/4000,2) cancel
  from HIS_SALE_ORG t
 where CALC_DATE = to_char(trunc(sysdate - 1),'yyyy-mm-dd')
 group by ORG_CODE),
org_data as
 (select ORG_CODE, count(agency_code) cnt
    from INF_AGENCYS
   where STATUS = 1
   group by ORG_CODE),
rtv as
 (select ORG_CODE,
         nvl(sale, 0) sale,
         nvl(pay, 0) pay,
         nvl(cancel, 0) cancel,
         cnt
    from org_data
    left join fund_data
   using (ORG_CODE))
select ORG_CODE, ORG_name, sale, pay, cancel, cnt
  from rtv
  join inf_orgs
 using (org_code)
 order by org_code;
