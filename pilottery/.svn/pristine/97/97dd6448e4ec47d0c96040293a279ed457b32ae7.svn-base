CREATE OR REPLACE PROCEDURE p_outlet_plan_auth
/***************************************************************
  ------------------- 销售站方案批量授权 -------------------
  ---------add by dzg  2015-9-15 单个站点的方案授权
  ---------modify by dzg 2015-11-27 修改站点信用额度，只有代销商时才比较值
  ************************************************************/
(

 --------------输入----------------
 p_outlet_code    IN STRING, --站点编号
 p_outlet_credit  IN NUMBER, --站点信用额度
 p_game_auth_list IN type_game_auth_list, --授权方案列表

 --------------出口参数----------------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因

 ) IS

  v_cur_auth_info type_game_auth_info; --当前授权信息，用于循环遍历
  v_temp          NUMBER := 0; --临时变量，发行费用

BEGIN
  /*-----------    初始化数据    -----------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  /*-----------  输入数据校验    ----------*/
  IF p_game_auth_list.count < 0 THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_OUTLET_PLAN_AUTH_1;
    RETURN;
  END IF;

  /*-----------  校验发行费用    ----------*/


select g.org_type
  into v_temp
  from inf_orgs g
 where g.org_code in (select a.org_code
                        from inf_agencys a
                       where a.agency_code = p_outlet_code);

  if(v_temp is not null and v_temp = eorg_type.agent) then


  FOR i IN 1 .. p_game_auth_list.count LOOP

    v_cur_auth_info := p_game_auth_list(i);
    v_temp          := 0;

    ---获取父区域游戏授权信息

    begin
      SELECT game_org_comm_rate.sale_comm
        INTO v_temp
        FROM game_org_comm_rate
       WHERE game_org_comm_rate.plan_code = v_cur_auth_info.plancode
         AND game_org_comm_rate.org_code IN
             (SELECT inf_agencys.org_code
                FROM inf_agencys
               WHERE inf_agencys.agency_code = v_cur_auth_info.agencycode);

    exception
      when no_data_found then
        v_temp := 0;
    end;

    ---比较值
    IF v_temp < v_cur_auth_info.salecommissionrate THEN
      c_errorcode := 1;
      c_errormesg := error_msg.ERR_P_OUTLET_PLAN_AUTH_2;
      RETURN;
    END IF;

  END LOOP;

  end if;

  /*-----------  更新信用额度       -----------*/

  update acc_agency_account
     set credit_limit = p_outlet_credit
   where agency_code = p_outlet_code
     and acc_type = eacc_type.main_account;

  v_cur_auth_info := NULL;

  /*----------- 选择销售站循环插入 -----------*/

  FOR i IN 1 .. p_game_auth_list.count LOOP

    v_cur_auth_info := p_game_auth_list(i);

    ---先清除
    DELETE FROM game_agency_comm_rate au
     WHERE au.plan_code = v_cur_auth_info.plancode
       AND au.agency_code = v_cur_auth_info.agencycode;

    ---后插入
    insert into game_agency_comm_rate
      (agency_code, plan_code, sale_comm, pay_comm)
    values
      (p_outlet_code,
       v_cur_auth_info.plancode,
       v_cur_auth_info.salecommissionrate,
       v_cur_auth_info.paycommissionrate);

  END LOOP;
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
