CREATE OR REPLACE TRIGGER trig_in_af_inf_orgs
  AFTER INSERT
    ON inf_orgs
  FOR EACH ROW
DECLARE
BEGIN
  -- 增加游戏授权
  insert into auth_org
    (org_code, game_code, pay_commission_rate, sale_commission_rate, auth_time, allow_pay, allow_sale, allow_cancel)
  select
    :new.org_code, game_code, 0, 0, sysdate, 0, 0, 0
  from inf_games;

  RETURN;
exception
   when others then
      return;
END;
