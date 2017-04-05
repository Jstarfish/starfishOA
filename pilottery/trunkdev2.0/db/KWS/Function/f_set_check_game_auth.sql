create or replace function f_set_check_game_auth
/*******************************************************************************/
  ----- 主机：游戏授权检查（销售站+机构）
  ----- add by 陈震 @ 2016-04-19
  -----
/*******************************************************************************/
(
  p_agency in inf_agencys.agency_code%type,        -- 登录销售站
  p_game   in inf_games.game_code%type,            -- 游戏编码
  p_type   in number                               -- 检查类型（1-销售，2-兑奖，3-退票）

) return number
  result_cache
  relies_on(auth_org, auth_agency)
is
  v_org inf_orgs.org_code%type;
  v_count number(1);

begin
  -- 检查销售站游戏授权
  case p_type
    when 1 then                                    	-- 销售
      select count(*)
        into v_count
        from dual
       where exists(select 1
                      from AUTH_AGENCY
                     where AGENCY_CODE = p_agency
                       and game_code = p_game
                       and ALLOW_SALE = eboolean.yesorenabled);

    when 2 then                                     -- 兑奖
      select count(*)
        into v_count
        from dual
       where exists(select 1
                      from AUTH_AGENCY
                     where AGENCY_CODE = p_agency
                       and game_code = p_game
                       and ALLOW_pay = eboolean.yesorenabled);

    when 3 then                                     -- 退票
      select count(*)
        into v_count
        from dual
       where exists(select 1
                      from AUTH_AGENCY
                     where AGENCY_CODE = p_agency
                       and game_code = p_game
                       and ALLOW_cancel = eboolean.yesorenabled);

  end case;

  if v_count = 0 then
    return 0;
  end if;

  -- 获取组织机构编码
  v_org := f_get_agency_org(p_agency);

  -- 检查组织机构游戏授权
  case p_type
    when 1 then                                    	-- 销售
      select count(*)
        into v_count
        from dual
       where exists(select 1
                      from AUTH_ORG
                     where ORG_CODE = v_org
                       and game_code = p_game
                       and ALLOW_SALE = eboolean.yesorenabled);

    when 2 then                                     -- 兑奖
      select count(*)
        into v_count
        from dual
       where exists(select 1
                      from AUTH_ORG
                     where ORG_CODE = v_org
                       and game_code = p_game
                       and ALLOW_pay = eboolean.yesorenabled);

    when 3 then                                     -- 退票
      select count(*)
        into v_count
        from dual
       where exists(select 1
                      from AUTH_ORG
                     where ORG_CODE = v_org
                       and game_code = p_game
                       and ALLOW_cancel = eboolean.yesorenabled);

  end case;

  return v_count;
end;
