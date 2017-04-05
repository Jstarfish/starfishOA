/********** ���Զ����ų�����ã�������webncp6������ ***********/

-- ÿ������
with base as
 (select plan_code,
         round(sum(SALE_AMOUNT) / 4000, 2) sale,
         round(sum(PAID_AMOUNT) / 4000, 2) pay,
         round(sum(CANCEL_AMOUNT) / 4000, 2) cancel
    from HIS_SALE_ORG t
   where CALC_DATE = to_char(trunc(sysdate - 1), 'yyyy-mm-dd')
   group by plan_code)
select plan_code, SHORT_NAME, sys_type, sale, pay, cancel
  from base
  join v_dict_all_game
 using (plan_code)

-- �¶�����
with base as (
  select plan_code,
         sum(sale_amount) sale_amount,
         sum(cancel_amount) cancel_amount
    from his_sale_org t
   where calc_date like to_char(sysdate - 1, 'yyyy-mm') || '%'
   group by plan_code)
select to_char(sysdate - 1,'yyyy') year,
       to_char(sysdate - 1,'mm') month,
       sum(case when plan_code = '12' then sale_amount - cancel_amount else 0 end) puresale_reil_ctg,
       sum(case when plan_code = '12' then sale_amount - cancel_amount else 0 end)/4000 puresale_dollar_ctg,
       sum(case when plan_code = '12' then 0 else sale_amount - cancel_amount end) puresale_reil_pil,
       sum(case when plan_code = '12' then 0 else sale_amount - cancel_amount end)/4000 puresale_dollar_pil
  from base;

-- ����վ����
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
     and CANCEL_TIME < trunc(sysdate)
  union all
  select distinct agency_code
    from his_sellticket t
   where SALETIME >= trunc(sysdate - 1)
     and SALETIME < trunc(sysdate)
  union all
  select distinct AGENCY_CODE agency_code
    from his_payticket t
   where PAYTIME >= trunc(sysdate - 1)
     and PAYTIME < trunc(sysdate)
  union all
  select distinct AGENCY_CODE
    from his_cancelticket t
   where CANCELTIME >= trunc(sysdate - 1)
     and CANCELTIME < trunc(sysdate))
select count(distinct agency_code) cnt from base;

-- վ������
select count(*) cnt from INF_AGENCYS where STATUS = 1;

-- ��������ͳ��
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
