-- 《即开票管理系统软件需求规格说明书》 3.17.2.1 站点综合查询报表
with base as
 (select * from his_agency_fund 
   where CALC_DATE >= to_char(to_date('2016-07'||'01','yyyy-mm-dd'),'yyyy-mm-dd')
    and CALC_DATE < to_char(add_months(to_date('2016-07','yyyy-mm'),1),'yyyy-mm-dd')),
agency as (select agency_code,org_code, org_name,admin_realname from inf_agencys join inf_orgs using(org_code) join adm_info on market_manager_id=admin_id),
fund as
 (select * from base pivot(sum(amount)
     for FLOW_TYPE in(1 as charge,
                     2 as withdraw,
                     7 as sale,
                     8 as paid,
                     11 as rtv,
					 45 as lot_sale,
                     41 as lot_paid,
                     42 as lot_rtv))),
--计开票
pil_fund as (
select calc_date, agency_code, admin_realname, org_code, org_name, 1 as type, sum(nvl(charge,0)) as charge, sum(nvl(withdraw,0)) as withdraw, 
        sum(nvl(sale,0)) as sale_amount, sum(nvl(paid,0)) as paid_amount, sum(nvl(rtv,0)) as rtv_amount,
	   (sum(nvl(sale,0)) - sum(nvl(rtv,0))) as incoming 
   from fund join agency using (agency_code) group by calc_date,agency_code,admin_realname,org_code,org_name),
--电脑票
lot_fund as (
select calc_date, agency_code, admin_realname, org_code, org_name, 2 as type, sum(nvl(charge,0)) as charge, sum(nvl(withdraw,0)) as withdraw, 
       sum(nvl(lot_sale,0)) as sale_amount, sum(nvl(lot_paid,0)) as paid_amount, sum(nvl(lot_rtv,0)) as rtv_amount,
	   (sum(nvl(lot_sale,0)) - sum(nvl(lot_rtv,0))) as incoming 
   from fund join agency using (agency_code) group by calc_date,agency_code,admin_realname,org_code,org_name),
--计开票+电脑票
total_fund as (
select calc_date, agency_code, admin_realname, org_code, org_name, 0 as type, sum(nvl(charge,0)) as charge, sum(nvl(withdraw,0)) as withdraw, 
       (sum(nvl(sale,0)) + sum(nvl(lot_sale,0))) as sale_amount, 
	   (sum(nvl(paid,0)) + sum(nvl(lot_paid,0))) as paid_amount, 
	   (sum(nvl(rtv,0)) + sum(nvl(lot_rtv,0))) as rtv_amount,
	   (sum(nvl(sale,0)) + sum(nvl(lot_sale,0)) - sum(nvl(rtv,0)) - sum(nvl(lot_rtv,0))) as incoming 
	from fund join agency using (agency_code) group by calc_date,agency_code,admin_realname,org_code,org_name),
funds as (
select calc_date, agency_code, org_code, org_name, admin_realname, type, charge, withdraw, sale_amount, paid_amount, rtv_amount, incoming from pil_fund
union all                                          
select calc_date, agency_code, org_code, org_name, admin_realname, type, charge, withdraw, sale_amount, paid_amount, rtv_amount, incoming from lot_fund
union all                                          
select calc_date, agency_code, org_code, org_name, admin_realname, type, charge, withdraw, sale_amount, paid_amount, rtv_amount, incoming from total_fund
)                                                  
select calc_date, agency_code, org_code, org_name, admin_realname, type, charge, withdraw, sale_amount, paid_amount, rtv_amount, incoming from funds;

  
-- 《即开票管理系统软件需求规格说明书》 3.17.2.2 部门销售月报表
with base as
 (select substr(calc_date,0,7) as calc_month,org_code, sum(charge) as charge, sum(withdraw) as withdraw, 
       sum(sale) as sale, sum(paid) as paid, sum(center_pay) as center_pay, sum(rtv) as rtv,
       sum(lot_sale) as lot_sale, sum(lot_paid) as lot_paid, sum(lot_center_pay) as lot_center_pay, sum(lot_rtv) as lot_rtv, sum(lot_center_rtv) as lot_center_rtv 
    from his_org_fund_report 
	  where CALC_DATE >= to_char(to_date('2016-07'||'01','yyyy-mm-dd'),'yyyy-mm-dd')
        and CALC_DATE < to_char(add_months(to_date('2016-07','yyyy-mm'),1),'yyyy-mm-dd')
	   group by substr(calc_date,0,7),org_code 
    ),
--计开票	
pil_fund as (
  select calc_month, org_code, org_name, 1 as type, charge charge, withdraw, sale as sale_amount, (paid + center_pay) as paid_amount, rtv as rtv_amount,(sale - rtv) as incoming 
	 from base join inf_orgs using (org_code) 
),
--电脑票
lot_fund as (
  select calc_month, org_code, org_name, 2 as type, charge, withdraw, 
       lot_sale as sale_amount, (lot_paid + lot_center_pay) as paid_amount, (lot_rtv + lot_center_rtv) as rtv_amount, (lot_sale - lot_rtv + lot_center_rtv) as incoming 
	   from base join inf_orgs using (org_code)),
--计开票+电脑票
total_fund as (
  select calc_month, org_code, org_name, 0 as type, charge, withdraw, (sale + lot_sale) as sale_amount, 
         (paid + center_pay + lot_paid + lot_center_pay) as paid_amount, 
		 (rtv + lot_rtv + lot_center_rtv) as  rtv_amount,
         (sale + lot_sale - rtv - lot_rtv - lot_center_rtv) as incoming from base join inf_orgs using (org_code)
),
funds as 
(select calc_month, org_code, org_name, type, charge, withdraw, sale_amount, paid_amount, rtv_amount, incoming from pil_fund
 union all 
 select calc_month, org_code, org_name, type, charge, withdraw, sale_amount, paid_amount, rtv_amount, incoming from lot_fund
 union all 
 select calc_month, org_code, org_name, type, charge, withdraw, sale_amount, paid_amount, rtv_amount, incoming from total_fund
 )
select calc_month, org_code, org_name, type, charge, withdraw, sale_amount, paid_amount, rtv_amount, incoming from funds;

-- 《即开票管理系统软件需求规格说明书》 3.17.2.3 站点销售月报表
with base as
 (select * from his_agency_fund 
   where CALC_DATE >= to_char(to_date('2016-07'||'01','yyyy-mm-dd'),'yyyy-mm-dd')
    and CALC_DATE < to_char(add_months(to_date('2016-07','yyyy-mm'),1),'yyyy-mm-dd')),
agency as (select agency_code,org_code,org_name from inf_agencys join inf_orgs using(org_code)),
fund as
 (select * from base pivot(sum(amount)
     for FLOW_TYPE in(1 as charge,
                     2 as withdraw,
                     7 as sale,
                     8 as paid,
                     11 as rtv,
					 45 as lot_sale,
                     41 as lot_paid,
                     42 as lot_rtv))),

--计开票
pil_fund as (
select substr(calc_date,0,7) as calc_month, agency_code, org_code, org_name, 1 as type, sum(nvl(charge,0)) as charge, sum(nvl(withdraw,0)) as withdraw, 
        sum(nvl(sale,0)) as sale_amount, sum(nvl(paid,0)) as paid_amount, sum(nvl(rtv,0)) as rtv_amount,
	   (sum(nvl(sale,0)) - sum(nvl(rtv,0))) as incoming 
   from fund join agency using (agency_code) group by substr(calc_date,0,7),agency_code,org_code,org_name),
--电脑票
lot_fund as (
select substr(calc_date,0,7) as calc_month, agency_code, org_code, org_name, 2 as type, sum(nvl(charge,0)) as charge, sum(nvl(withdraw,0)) as withdraw, 
       sum(nvl(lot_sale,0)) as sale_amount, sum(nvl(lot_paid,0)) as paid_amount, sum(nvl(lot_rtv,0)) as rtv_amount,
	   (sum(nvl(lot_sale,0)) - sum(nvl(lot_rtv,0))) as incoming 
   from fund join agency using (agency_code) group by substr(calc_date,0,7),agency_code,org_code,org_name),
--计开票+电脑票
total_fund as (
select substr(calc_date,0,7) as calc_month, agency_code, org_code, org_name, 0 as type, sum(nvl(charge,0)) as charge, sum(nvl(withdraw,0)) as withdraw, 
       (sum(nvl(sale,0)) + sum(nvl(lot_sale,0))) as sale_amount, 
	   (sum(nvl(paid,0)) + sum(nvl(lot_paid,0))) as paid_amount, 
	   (sum(nvl(rtv,0)) + sum(nvl(lot_rtv,0))) as rtv_amount,
	   (sum(nvl(sale,0)) + sum(nvl(lot_sale,0)) - sum(nvl(rtv,0)) - sum(nvl(lot_rtv,0))) as incoming 
	from fund join agency using (agency_code) group by substr(calc_date,0,7),agency_code,org_code,org_name),
funds as (
select calc_month, agency_code, org_code, org_name, type, charge, withdraw, sale_amount, paid_amount, rtv_amount, incoming from pil_fund
union all                                           
select calc_month, agency_code, org_code, org_name, type, charge, withdraw, sale_amount, paid_amount, rtv_amount, incoming from lot_fund
union all                                           
select calc_month, agency_code, org_code, org_name, type, charge, withdraw, sale_amount, paid_amount, rtv_amount, incoming from total_fund
)                                                   
select calc_month, agency_code, org_code, org_name, type, charge, withdraw, sale_amount, paid_amount, rtv_amount, incoming from funds;					 

  
-- 《即开票管理系统软件需求规格说明书》3.17.2.4	市场管理员销售月报表
with base as
 (select * from his_agency_fund 
   where CALC_DATE >= to_char(to_date('2016-07'||'01','yyyy-mm-dd'),'yyyy-mm-dd')
    and CALC_DATE < to_char(add_months(to_date('2016-07','yyyy-mm'),1),'yyyy-mm-dd')),
agency as (select agency_code,org_code, org_name,admin_realname from inf_agencys join inf_orgs using(org_code) join adm_info on market_manager_id=admin_id),
fund as
 (select * from base pivot(sum(amount)
     for FLOW_TYPE in(1 as charge,
                     2 as withdraw,
                     7 as sale,
                     8 as paid,
                     11 as rtv,
					 45 as lot_sale,
                     41 as lot_paid,
                     42 as lot_rtv))),
--计开票
pil_fund as (
select substr(calc_date,0,7) as calc_month, admin_realname, org_code, org_name, 1 as type, sum(nvl(charge,0)) as charge, sum(nvl(withdraw,0)) as withdraw, 
        sum(nvl(sale,0)) as sale_amount, sum(nvl(paid,0)) as paid_amount, sum(nvl(rtv,0)) as rtv_amount,
	   (sum(nvl(sale,0)) - sum(nvl(rtv,0))) as incoming 
   from fund join agency using (agency_code) group by substr(calc_date,0,7),admin_realname,org_code,org_name),
--电脑票
lot_fund as (
select substr(calc_date,0,7) as calc_month, admin_realname, org_code, org_name, 2 as type, sum(nvl(charge,0)) as charge, sum(nvl(withdraw,0)) as withdraw, 
       sum(nvl(lot_sale,0)) as sale_amount, sum(nvl(lot_paid,0)) as paid_amount, sum(nvl(lot_rtv,0)) as rtv_amount,
	   (sum(nvl(lot_sale,0)) - sum(nvl(lot_rtv,0))) as incoming 
   from fund join agency using (agency_code) group by substr(calc_date,0,7),admin_realname,org_code,org_name),
--计开票+电脑票
total_fund as (
select substr(calc_date,0,7) as calc_month, admin_realname, org_code, org_name, 0 as type, sum(nvl(charge,0)) as charge, sum(nvl(withdraw,0)) as withdraw, 
       (sum(nvl(sale,0)) + sum(nvl(lot_sale,0))) as sale_amount, 
	   (sum(nvl(paid,0)) + sum(nvl(lot_paid,0))) as paid_amount, 
	   (sum(nvl(rtv,0)) + sum(nvl(lot_rtv,0))) as rtv_amount,
	   (sum(nvl(sale,0)) + sum(nvl(lot_sale,0)) - sum(nvl(rtv,0)) - sum(nvl(lot_rtv,0))) as incoming 
	from fund join agency using (agency_code) group by substr(calc_date,0,7),admin_realname,org_code,org_name),
funds as (
select calc_month, admin_realname, org_code, org_name, type, charge, withdraw, sale_amount, paid_amount, rtv_amount, incoming from pil_fund
union all                                           
select calc_month, admin_realname, org_code, org_name, type, charge, withdraw, sale_amount, paid_amount, rtv_amount, incoming from lot_fund
union all                                           
select calc_month, admin_realname, org_code, org_name, type, charge, withdraw, sale_amount, paid_amount, rtv_amount, incoming from total_fund
)                                                   
select calc_month, admin_realname, org_code, org_name, type, charge, withdraw, sale_amount, paid_amount, rtv_amount, incoming from funds;						 
