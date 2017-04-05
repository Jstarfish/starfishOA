-- 当日，销售前20的销售站，购票票数统计
with base as
 (select * from his_sellticket where saletime > trunc(sysdate)),
mid as
 (select AGENCY_CODE, sum(TICKET_AMOUNT)/4000 amount
    from base
   group by AGENCY_CODE),
high_sale as
 (select rownum, AGENCY_CODE, amount
    from (select * from mid order by amount desc)),
top_10_sale as
 (select * from high_sale where rownum < 20),
top_10_tickets as
 (select agency_code, count(*) cnt
    from base
   where agency_code in (select agency_code from top_10_sale)
   group by agency_code)
select agency_code, agency_name, area_name, org_name, amount, cnt, round(amount/cnt, 2) each_ticket_prize
  from top_10_sale
  join top_10_tickets
 using (agency_code)
  join inf_agencys
 using (agency_code)
 join inf_areas using(area_code)
 join inf_orgs using(org_code)
 order by amount desc;


-- 销售站增长
with base as
 (select trunc(AGENCY_ADD_TIME) add_date, count(*) cnt
    from inf_agencys
   where agency_code in
         (select agency_code from ttt.AUTH_agency where allow_sale > 0)
   group by trunc(AGENCY_ADD_TIME))
select add_date, sum(cnt) over(order by add_date) from base

-- 中奖与销售之间的关联关系


-- 即开票按月返奖率
with base as (
select to_number(substr(calc_date,6,2)) month,sum(SALE) SALE,sum(PAID+CENTER_PAY) pay from his_org_fund_report
where substr(calc_date,1,4)='2016'
 group by to_number(substr(calc_date,6,2))
)
select month, sale,pay, round(pay/sale,3) from base order by month;

-- 电脑票按月返奖率
with base as (
select to_number(substr(calc_date,6,2)) month,sum(LOT_SALE) SALE,sum(LOT_PAID + LOT_CENTER_PAY) pay from his_org_fund_report
where substr(calc_date,1,4)='2016'
 group by to_number(substr(calc_date,6,2))
)
select month, sale,pay, round(pay/(case when sale=0 then 1 else sale end),3) from base order by month;

-- 2016年，按月各机构收入与销售比例分析
with base as (
select to_number(substr(calc_date,6,2)) month,org_code,sum(SALE) SALE,sum(INCOMING) pay from his_org_fund_report
where substr(calc_date,1,4)='2016'
 group by to_number(substr(calc_date,6,2)),org_code
)
select 
ORG_name,
m1_pay/(case when  m1_sale =0  then 1 else  m1_sale end) m1_rate,    
m2_pay/(case when  m2_sale =0  then 1 else  m2_sale end) m2_rate,    
m3_pay/(case when  m3_sale =0  then 1 else  m3_sale end) m3_rate,    
m4_pay/(case when  m4_sale =0  then 1 else  m4_sale end) m4_rate,    
m5_pay/(case when  m5_sale =0  then 1 else  m5_sale end) m5_rate,    
m6_pay/(case when  m6_sale =0  then 1 else  m6_sale end) m6_rate,    
m7_pay/(case when  m7_sale =0  then 1 else  m7_sale end) m7_rate,    
m8_pay/(case when  m8_sale =0  then 1 else  m8_sale end) m8_rate,    
m9_pay/(case when  m9_sale =0  then 1 else  m9_sale end) m9_rate,    
m10_pay/(case when m10_sale=0 then 1 else m10_sale end)    m10_rate, 
m11_pay/(case when m11_sale=0 then 1 else m11_sale end)    m11_rate, 
m12_pay/(case when m12_sale=0 then 1 else m12_sale end)    m12_rate  

 from base join inf_orgs using(org_code)
pivot (sum(sale) as sale,sum(pay) as pay for month in 
(
1  as m1 ,
2  as m2 ,
3  as m3 ,
4  as m4 ,
5  as m5 ,
6  as m6 ,
7  as m7 ,
8  as m8 ,
9  as m9 ,
10 as m10,
11 as m11,
12 as m12
)
)



-- 佣金异常的销售站列表（销售佣金大于100，兑奖佣金大于10）
select agency_code, agency_name, plan_code,FULL_NAME, org_name, sale_comm, pay_comm
  from inf_agencys
  join GAME_AGENCY_COMM_RATE
 using (AGENCY_CODE)
  join inf_orgs
 using (org_code)
  join game_plans
 using (plan_code)
 where agency_code in
       (select distinct a.agency_code
          from GAME_AGENCY_COMM_RATE r, inf_agencys a
         where r.AGENCY_CODE = a.AGENCY_CODE
           and a.org_code in ('13', '09', '21', '20', '10', '01')
           and (sale_comm > 100 or pay_comm > 10))


-- XX公司，即开票按月返奖率(2016年)
with base as
 (select to_number(substr(calc_date, 6, 2)) month,
         sum(SALE) SALE,
         sum(incoming) pay
    from his_org_fund_report
   where substr(calc_date, 1, 4) = '2016'
     and org_code in ('13', '09',  '20', '10', '01')
   group by to_number(substr(calc_date, 6, 2)))
select month, sale, pay, round(pay / (case when sale=0 then 1 else sale end), 3) 
  from base 
 order by month;

-- 某公司兑奖销售列表（按照兑奖与销售差额倒排）
with base as
 (select agency_code, flow_type, sum(amount) amount
    from his_agency_fund
    join inf_agencys
   using (agency_code)
   where substr(calc_date, 1, 7) = '2016-12'
     and org_code in ('09')
     and flow_type in (7, 8, 45, 41)
   group by substr(calc_date, 1, 7), agency_code, flow_type),
result as
 (select *
    from base pivot(sum(amount) for flow_type in(7 as sale, 8 as paid, 45 as lot_sale, 41 as lot_paid)))
select agency_code, agency_name, TELEPHONE, address, nvl(sale, 0) sale, nvl(paid, 0) paid, nvl(lot_sale, 0) lot_sale, nvl(lot_paid, 0) Lot_paid
  from result join inf_agencys using(agency_code)
 order by nvl(paid, 0) + nvl(lot_paid, 0) - nvl(sale, 0) - nvl(lot_sale, 0) desc
