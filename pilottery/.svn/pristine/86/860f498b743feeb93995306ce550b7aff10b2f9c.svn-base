create or replace function f_set_check_pay_level
/*******************************************************************************/
  ----- 主机：判断兑奖销售站是否在兑奖范围内
  ----- add by 陈震 @ 2016-04-19
  -----
/*******************************************************************************/
(
  p_pay_agency    in inf_agencys.agency_code%type,       -- 兑奖销售站
  p_sale_agency   in inf_agencys.agency_code%type,       -- 售票销售站
  p_game_code     in inf_games.game_code%type            -- 游戏

) return number
  result_cache
  relies_on(auth_agency)
is
  v_claiming_scope auth_agency.claiming_scope%type;    -- 兑奖范围

begin
  -- 获取兑奖销售站兑奖范围
  select claiming_scope
    into v_claiming_scope
    from auth_agency
   where agency_code = p_pay_agency
     and game_code = p_game_code;

  case v_claiming_scope
    when eclaiming_scope.center then
      return 1;

    when eclaiming_scope.org then
      if f_get_agency_org(p_pay_agency) = f_get_agency_org(p_sale_agency) then
        return 1;
      else
        return 0;
      end if;

    when eclaiming_scope.agency then
      if p_pay_agency = p_sale_agency then
        return 1;
      else
        return 0;
      end if;

  end case;
end;
