create or replace procedure p_time_lot_promotion (
   p_curr_date       date        default sysdate
)
/****************************************************************/
-------- 电脑票按月进行佣金奖励（每月1日0点执行） ----
---- 1. 只对套餐一进行额外返点佣金的结算（即佣金设置为7%的站点）。其余套餐不给额外佣金，即使销售额度超过额外返奖佣金
---- 2.范围：                                                                                                        
----       0<月销售总额<3000$           7%                                                                           
----       3000<=月销售总额<6000$       8%                                                                           
----       6000<=月销售总额<9000$       9%                                                                           
---- 
---- add by 陈震: 2016-05-21
--- modify by kwx: 2016-08-02 佣金比例为零时不结算
--- modify by Chen Zhen: 2017/3/29 修改计算方法
/****************************************************************/
is
  -- 加减钱的操作
  v_out_balance           number(28);                   -- 传出的销售站余额
  v_temp_balance          number(28);                   -- 临时金额
begin

  for tab in (with agencys as (select distinct agency_code from AUTH_AGENCY where game_code=12 and SALE_COMMISSION_RATE = 70)
               select sale_agency, sum(pure_amount) amount 
                from sub_sell join agencys on (sub_sell.sale_agency = agencys.agency_code)
               where sale_month = to_char(p_curr_date - 1, 'yyyy-mm') 
                 and game_code = 12
               group by sale_agency
              having sum(pure_amount) >= 3000 * 4000
             ) loop
    
      if tab.amount >= 3000 * 4000 and tab.amount < 6000 * 4000 then
        p_agency_fund_change(tab.sale_agency, eflow_type.lottery_sale_comm, (tab.amount * 0.01), 0, 0, v_out_balance, v_temp_balance);
        continue;
      end if;

      if tab.amount >= 6000 * 4000 then
        p_agency_fund_change(tab.sale_agency, eflow_type.lottery_sale_comm, (tab.amount * 0.02), 0, 0, v_out_balance, v_temp_balance);
      end if;

  end loop;

  commit;
end;