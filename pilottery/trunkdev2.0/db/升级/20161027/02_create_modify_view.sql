set feedback off 
prompt 正在建立[VIEW -> v_his_org_fund_report.sql ]...... 
create or replace view v_his_org_fund_report as
with today_flow as
 (select AGENCY_CODE,
         FLOW_TYPE,
         sum(CHANGE_AMOUNT) amount,
         0 as BE_ACCOUNT_BALANCE,
         0 as AF_ACCOUNT_BALANCE
    from flow_agency
   where TRADE_TIME >= trunc(sysdate)
     and TRADE_TIME < trunc(sysdate) + 1
   group by AGENCY_CODE, FLOW_TYPE),
today_balance as
 (select AGENCY_CODE,
         0 as FLOW_TYPE,
         0 as amount,
         sum(BE_ACCOUNT_BALANCE) BE_ACCOUNT_BALANCE,
         sum(AF_ACCOUNT_BALANCE) AF_ACCOUNT_BALANCE
    from (select AGENCY_CODE,
                 0               as BE_ACCOUNT_BALANCE,
                 ACCOUNT_BALANCE as AF_ACCOUNT_BALANCE
            from acc_agency_account
          union all
          select AGENCY_CODE,
                 AF_ACCOUNT_BALANCE as BE_ACCOUNT_BALANCE,
                 0                  as AF_ACCOUNT_BALANCE
            from his_agency_fund
           where CALC_DATE = to_char(sysdate - 1, 'yyyy-mm-dd'))
   group by AGENCY_CODE),
agency_fund as
 (select AGENCY_CODE,
         FLOW_TYPE,
         amount,
         BE_ACCOUNT_BALANCE,
         AF_ACCOUNT_BALANCE
    from today_flow
  union all
  select AGENCY_CODE,
         FLOW_TYPE,
         amount,
         BE_ACCOUNT_BALANCE,
         AF_ACCOUNT_BALANCE
    from today_balance),
base as
 (select org_code,
         FLOW_TYPE,
         sum(AMOUNT) as amount,
         sum(BE_ACCOUNT_BALANCE) as BE_ACCOUNT_BALANCE,
         sum(AF_ACCOUNT_BALANCE) as AF_ACCOUNT_BALANCE
    from agency_fund
    join inf_agencys
   using (agency_code)
   group by org_code, FLOW_TYPE),
center_pay as
 (select f_get_flow_pay_org(pay_flow) org_code, sum(pay_amount) amount
       from flow_pay
      where pay_time >= trunc(sysdate)
        and pay_time < trunc(sysdate) + 1
        and is_center_paid = 1
      group by f_get_flow_pay_org(pay_flow)),
center_pay_comm as
 (select org_code, FLOW_TYPE, sum(change_amount) amount
    from flow_org
   where TRADE_TIME >= trunc(sysdate)
     and TRADE_TIME < trunc(sysdate) + 1
     and FLOW_TYPE in (23, 35, 36, 37, 38)
   group by org_code, FLOW_TYPE),
agency_balance as
 (select * from (select org_code, BE_ACCOUNT_BALANCE, AF_ACCOUNT_BALANCE
    from base
   where flow_type = 0)
   unpivot (amount for flow_type in (BE_ACCOUNT_BALANCE as 88, AF_ACCOUNT_BALANCE as 99))),
fund as
 (select *
    from (select org_code, FLOW_TYPE, AMOUNT from base
             union all
             select org_code, FLOW_TYPE, AMOUNT from agency_balance
             union all
             select org_code, FLOW_TYPE, AMOUNT from center_pay_comm
             union all
             select org_code, 20 FLOW_TYPE, AMOUNT from center_pay)
  pivot(sum(amount)
     for FLOW_TYPE in(1 as charge,
                     2 as withdraw,
                     5 as sale_comm,
                     6 as pay_comm,
                     7 as sale,
                     8 as paid,
                     11 as rtv,
                     13 as rtv_comm,
                     20 as center_pay,
                     23 as center_pay_comm,
                     45 as lot_sale,
                     43 as lot_sale_comm,
                     41 as lot_paid,
                     44 as lot_pay_comm,
                     42 as lot_rtv,
                     47 as lot_rtv_comm,
                     36 as lot_center_pay_comm,
                     37 as lot_center_pay,
                     38 as lot_center_rtv,
					 35 as lot_center_rtv_comm,
                     88 as be,
                     99 as af))),
pre_detail as
 (select org_code,
         nvl(be, 0) be_account_balance,
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
         nvl(lot_sale, 0) lot_sale,
         nvl(lot_sale_comm, 0) lot_sale_comm,
         nvl(lot_paid, 0) lot_paid,
         nvl(lot_pay_comm, 0) lot_pay_comm,
         nvl(lot_rtv, 0) lot_rtv,
         nvl(lot_rtv_comm, 0) lot_rtv_comm,
         nvl(lot_center_pay, 0) lot_center_pay,
         nvl(lot_center_pay_comm, 0) lot_center_pay_comm,
         nvl(lot_center_rtv, 0) lot_center_rtv,
		 (case 2 when (select org_type from inf_orgs where org_code=fund.org_code) then (nvl(lot_center_rtv_comm, 0) - nvl(lot_rtv_comm, 0))  else nvl(lot_center_rtv_comm, 0) end) lot_center_rtv_comm,
         nvl(af, 0) af_account_balance
    from fund),
will_write as (
select   org_code,
          -- 通用
          be_account_balance, af_account_balance,          charge,          withdraw,
          (sale - sale_comm - paid - pay_comm - rtv + rtv_comm - center_pay - center_pay_comm + lot_sale - lot_sale_comm - lot_paid - lot_pay_comm - lot_rtv + lot_rtv_comm - lot_center_pay - lot_center_pay_comm - lot_center_rtv + lot_center_rtv_comm) incoming,
          (charge - withdraw - center_pay - center_pay_comm - lot_center_pay - lot_center_pay_comm  - lot_rtv - lot_rtv_comm - lot_center_rtv - lot_center_rtv_comm) pay_up,
          -- 即开票
          sale,                sale_comm,              paid,      pay_comm,     rtv,       rtv_comm,     center_pay,     center_pay_comm,
          -- 电脑票
          lot_sale,            lot_sale_comm,          lot_paid,  lot_pay_comm, lot_rtv,   lot_rtv_comm, lot_center_pay, lot_center_pay_comm, lot_center_rtv,
		  lot_center_rtv_comm
  from pre_detail),
today_result as (
  select to_char(sysdate, 'yyyy-mm-dd') CALC_DATE, org_code, nvl(be_account_balance,0) be_account_balance, nvl(charge,0) charge, nvl(withdraw,0) withdraw, nvl(sale,0) sale, nvl(sale_comm,0) sale_comm, nvl(paid,0) paid, nvl(pay_comm,0) pay_comm, nvl(rtv,0) rtv, nvl(rtv_comm,0) rtv_comm, nvl(center_pay,0) center_pay, nvl(center_pay_comm,0) center_pay_comm, nvl(lot_sale,0) lot_sale, nvl(lot_sale_comm,0) lot_sale_comm, nvl(lot_paid,0) lot_paid, nvl(lot_pay_comm,0) lot_pay_comm, nvl(lot_rtv,0) lot_rtv, nvl(lot_rtv_comm,0) lot_rtv_comm, nvl(lot_center_pay,0) lot_center_pay, nvl(lot_center_pay_comm,0) lot_center_pay_comm, nvl(lot_center_rtv,0) lot_center_rtv, nvl(lot_center_rtv_comm,0) lot_center_rtv_comm, nvl(af_account_balance,0) af_account_balance, nvl(incoming,0) incoming, nvl(pay_up,0) pay_up from  will_write right join inf_orgs using (org_code))
select calc_date, org_code, be_account_balance, charge, withdraw, sale, sale_comm, paid, pay_comm, rtv, rtv_comm, center_pay, center_pay_comm, lot_sale, lot_sale_comm, lot_paid, lot_pay_comm, lot_rtv, lot_rtv_comm, lot_center_pay, lot_center_pay_comm, lot_center_rtv, lot_center_rtv_comm, af_account_balance, incoming, pay_up from his_org_fund_report
union all
select calc_date, org_code, be_account_balance, charge, withdraw, sale, sale_comm, paid, pay_comm, rtv, rtv_comm, center_pay, center_pay_comm, lot_sale, lot_sale_comm, lot_paid, lot_pay_comm, lot_rtv, lot_rtv_comm, lot_center_pay, lot_center_pay_comm, lot_center_rtv, lot_center_rtv_comm, af_account_balance, incoming, pay_up from today_result;
;


