CREATE OR REPLACE TRIGGER trig_in_af_inf_agencys
  AFTER INSERT
    ON inf_agencys
  FOR EACH ROW
DECLARE
BEGIN
  -- 增加游戏授权
  insert into auth_agency
    (agency_code, game_code, pay_commission_rate, sale_commission_rate, allow_pay, allow_sale, allow_cancel, claiming_scope)
  select
    :new.agency_code, game_code, 0, 0, 0, 0, 0, 1
  from inf_games;

  RETURN;
exception
   when others then
      return;
END;
