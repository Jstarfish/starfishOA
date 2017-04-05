-- 区域游戏授权
insert into auth_org
  (org_code, game_code, pay_commission_rate, sale_commission_rate, auth_time, allow_pay, allow_sale, allow_cancel)
select
  org_code, game_code, 0, 0, sysdate, 1, 1, 0
from inf_games,inf_orgs
where org_code not in (select org_code from auth_org);

-- 代理商不做游戏授权
update auth_org set allow_pay = 0,allow_sale = 0 where org_code in (select org_code from inf_orgs where org_type = 2);
commit;

-- 销售站游戏授权
  insert into auth_agency
    (agency_code, game_code, pay_commission_rate, sale_commission_rate, allow_pay, allow_sale, allow_cancel, claiming_scope)
  select
    agency_code, game_code, 0, 0, 0, 0, 0, 1
  from inf_games,inf_agencys
where agency_code not in (select agency_code from auth_agency);

commit;

declare
  v_count number(10);
begin
  for tab_date in (select distinct calc_date from his_org_fund) loop
    for tab_org in (select distinct org_code from his_org_fund where calc_date = tab_date.calc_date) loop
      select count(*) into v_count from his_org_fund_report where calc_date = tab_date.calc_date and org_code = tab_org.org_code;
      if v_count = 0 then
         insert into his_org_fund_report (calc_date, org_code) values (tab_date.calc_date, tab_org.org_code);
      end if;
    end loop;
  end loop;
end;
/

commit;


delete from ADM_ROLE_PRIVILEGE where privilege_id in (44,4401,4403,4405,4407,3605);
commit;
