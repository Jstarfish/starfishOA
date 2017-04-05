CREATE OR REPLACE PROCEDURE p_org_plan_auth
/***************************************************************
  ------------------- 组织机构方案批量授权 -------------------
  ---------add by dzg  2015-9-16 组织机构的方案授权
  ----modify by dzg 2015-9-17 写错了销售佣金额度
  ************************************************************/
(
 
 --------------输入----------------
 p_org_code       IN STRING, --机构编号
 p_org_credit     IN NUMBER, --机构信用额度
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
    c_errormesg := error_msg.ERR_P_ORG_PLAN_AUTH_1;
    RETURN;
  END IF;

  /*-----------  校验发行费用    ----------*/
  FOR i IN 1 .. p_game_auth_list.count LOOP
  
    v_cur_auth_info := p_game_auth_list(i);
    ---比较值
    IF 1000 < v_cur_auth_info.salecommissionrate THEN
      c_errorcode := 1;
      --c_errormesg := '发行费用超出范围';
      c_errormesg := error_msg.ERR_P_ORG_PLAN_AUTH_2;
      RETURN;
    END IF;
  
  END LOOP;

  /*-----------  更新信用额度       -----------*/

  update acc_org_account
     set credit_limit = p_org_credit
   where org_code = p_org_code
     and acc_type = eacc_type.main_account;

  v_cur_auth_info := NULL;

  /*----------- 选择销售站循环插入 -----------*/

  FOR i IN 1 .. p_game_auth_list.count LOOP
  
    v_cur_auth_info := p_game_auth_list(i);
  
    ---先清除
    DELETE FROM game_org_comm_rate au
     WHERE au.plan_code = v_cur_auth_info.plancode
       AND au.org_code = p_org_code;
  
    ---后插入
    insert into game_org_comm_rate
      (org_code, plan_code, sale_comm, pay_comm)
    values
      (p_org_code,
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
