1、	按日销售汇总
按日销售汇总包括：日期、销售、中奖（应该中奖）、兑奖（已经兑奖）、充值

with sale as
  -- 销售
 (select to_char(saletime,'yyyy-mm-dd') cdate,sum(ticket_amount) s_amount from his_sellticket where agency_code = '01688880' group by to_char(saletime,'yyyy-mm-dd')),
win as
  -- 中奖
 (select to_char(WINNNING_TIME,'yyyy-mm-dd') cdate, sum(WINNINGAMOUNTTAX) w_amount from his_win_ticket_detail where SALE_AGENCY = '01688880' group by to_char(WINNNING_TIME,'yyyy-mm-dd')),
charge as
  -- 充值
 (select calc_date cdate, amount c_amount
    from his_agency_fund
   where agency_code = '01688880'
     and flow_type = 1),
pay as (
select to_char(saletime,'yyyy-mm-dd') cdate,sum(WINNINGAMOUNTTAX) P_AMOUNT from his_sellticket join his_payticket using(APPLYFLOW_SELL) where his_sellticket.agency_code = '01688880' group by to_char(saletime,'yyyy-mm-dd')
)
select *

  from sale
  full join win
 using (cdate)
  full join charge
 using (cdate)
  full join pay
 using (cdate)
 order by CDATE

2、	兑奖信息
具体的该站点销售票兑奖记录
票号、期号、中奖金额、兑奖时间、兑奖站点/分公司、兑奖人（如果站点兑奖，则显示站号）

with base as
 (select his_sellticket.SALE_TSN,
         his_sellticket.ISSUE_NUMBER,
         nvl(his_payticket.agency_code, his_payticket.ORG_CODE) aorg,
         PAYTIME,
         WINNINGAMOUNTTAX amount,
         WINNERNAME,
         PAYER_NAME
    from his_sellticket
    join his_payticket
   using (APPLYFLOW_SELL)
    left join SALE_GAMEPAYINFO
      on (SALE_GAMEPAYINFO.GUI_PAY_FLOW = his_payticket.APPLYFLOW_PAY)
   where his_sellticket.agency_code = '01688880')
select SALE_TSN,
       ISSUE_NUMBER,
       (case
         when aorg = '00' then
          '总公司'
         else
          (select agency_name from inf_agencys where agency_code = base.aorg)
       end),
       PAYTIME,
       AMOUNT,
       WINNERNAME,
       PAYER_NAME
  from base
 order by PAYTIME

3、	中奖未兑奖票列表
票号、期号、中奖额、销售时间
select SALE_TSN,sell.ISSUE_NUMBER,win.win_amount,saletime from his_sellticket sell join his_win_ticket win using (APPLYFLOW_SELL) where sell.agency_code = '01688880' and APPLYFLOW_SELL not in (select APPLYFLOW_SELL from his_payticket)
