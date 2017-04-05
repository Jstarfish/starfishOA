CREATE OR REPLACE PROCEDURE p_set_cancel
/*****************************************************************/
   ----------- 主机退票 ---------------
/*****************************************************************/
(
   p_input_json            in varchar2,                           -- 入口参数
   c_out_json              out varchar2,                          -- 出口参数
   c_errorcode             out number,                            -- 业务错误编码
   c_errormesg             out varchar2                           -- 错误信息描述
) IS
  v_input_json            json;
  v_out_json              json;
  temp_json               json;

  v_sale_ticket           his_sellticket%rowtype;
  v_is_center             number(1);                              -- 是否中心退票

  -- 报文内数据对象
  v_cancel_apply_flow     char(24);                               -- 退票请求流水
  v_sale_apply_flow       char(24);                               -- 售票请求流水
  v_cancel_agency_code    inf_agencys.agency_code%type;           -- 退票销售站
  v_cancel_terminal       saler_terminal.terminal_code%type;      -- 退票终端
  v_cancel_teller         inf_tellers.teller_code%type;           -- 退票销售员
  v_org_code              inf_orgs.org_code%type;                 -- 中心退票机构代码
  v_org_type              number(1);
  v_sale_org              inf_agencys.org_code%type;                 --销售站对应的中心机构代码

  -- 退代销费计算
  v_sale_comm             number(28);                             -- 站点销售代销费金额
  v_sale_org_comm         number(28);                             -- 代理商销售代销费金额
  v_sale_amount           number(28);                             -- 销售金额

  -- 加减钱的操作
  v_out_balance           number(28);                             -- 传出的销售站余额
  v_temp_balance          number(28);                             -- 临时金额

  v_is_train              number(1);                              -- 是否培训票
  v_loyalty_code          his_sellticket.loyalty_code%type;       -- 彩民卡号码
  v_ret_num               number(10);                             -- 临时返回值
  v_flownum               number(18);                             -- 终端机交易序号
  v_count                 number(1);                              -- 临时变量，判断存在

BEGIN
  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  v_input_json := json(p_input_json);
  v_out_json := json();


  -- 确认来的报文，是否是退票
  if v_input_json.get('type').get_number not in (2, 4) then
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_set_cancel_1 || v_input_json.get('type').get_number;             -- 报文输入有错，非退票报文。类型为：
    return;
  end if;

  -- 确定退票模式
  if v_input_json.get('type').get_number = 4 then
    v_is_center := 1;
  else
    v_is_center := 0;
  end if;

  -- 是否培训票退票
  v_is_train := v_input_json.get('is_train').get_number;

  -- 获取两个流水号
  v_cancel_apply_flow := v_input_json.get('applyflow_cancel').get_string;
  v_sale_apply_flow := json(v_input_json.get('ticket')).get('applyflow_sell').get_string;

  -- 判断此票是否已经退票
  -- modify by kwx 2016-05-30 按照退票来源（销售站、中心）返回不同的错误编码
  select count(*)
    into v_count
    from dual
   where exists(select 1 from his_cancelticket where APPLYFLOW_SELL = v_sale_apply_flow);
  if v_count = 1 then
    if v_is_center = 0 then
      v_out_json.put('rc', ehost_error.host_cancel_again_err);
      c_out_json := v_out_json.to_char();
    else
      v_out_json.put('rc', ehost_error.oms_result_cancel_again_err);
      c_out_json := v_out_json.to_char();
    end if;
    return;
  end if;

  -- 获取彩民卡编号
  v_loyalty_code := v_input_json.get('loyalty_code').get_number;

  -- 获取原来的售票信息
  begin
    select * into v_sale_ticket from his_sellticket where applyflow_sell = v_sale_apply_flow;
  exception
    when no_data_found then
      c_errorcode := 1;
      c_errormesg := error_msg.err_p_set_cancel_2 || v_sale_apply_flow;                            -- 未找到对应的售票信息。输入的流水号为：
      rollback;
      return;
  end;

  -- 获取之前的金额数据
  v_sale_amount := v_sale_ticket.ticket_amount;
  v_sale_comm := v_sale_ticket.commissionamount;
  v_sale_org_comm := v_sale_ticket.commissionamount_o;

  --modify by kwx 2016-05-30,如果是中心退票,减去中心佣金
  v_sale_org := f_get_agency_org(v_sale_ticket.agency_code);

  -- 根据退票类型，确定数据插入内容
  if v_is_center = 1 then

    if v_is_train = eboolean.yesorenabled then
      rollback;
      c_errorcode := 1;
      c_errormesg := '中心退票不能退培训票';
      return;
    end if;

    v_org_code := v_input_json.get('org_code').get_string;

    -- 判断机构是否有效、存在
    select count(*)
      into v_count
      from dual
     where exists(select 1 from inf_orgs where org_code = v_org_code and org_status = eorg_status.available);
    if v_count = 0 then
      v_out_json.put('rc', ehost_error.host_t_token_expired_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

  --modify by kwx 2016-05-18 增加game_code判断游戏授权

    -- 判断机构是否可以退票
    select count(*)
      into v_count
      from dual
     where exists(select 1 from auth_org where org_code = v_org_code and game_code = v_sale_ticket.game_code and allow_cancel = eboolean.yesorenabled);
    if v_count = 0 then
      -- modify by ChenZhen 2016-05-19 按照退票来源（销售站、中心）返回不同的错误编码
      if v_is_center = 0 then
        v_out_json.put('rc', ehost_error.host_t_teller_unauthen_err);
        c_out_json := v_out_json.to_char();
      else
        v_out_json.put('rc', ehost_error.oms_org_not_auth_cancel_err);
        c_out_json := v_out_json.to_char();
      end if;
      return;
    end if;

    -- 退票金额判断(退票级别)，这里还要判断是否启用此限制
    if v_sale_amount >= to_number(f_get_sys_param(1015)) and f_get_sys_param(1016) = '1' and v_org_code <> '00' then
      rollback;
      v_out_json.put('rc', ehost_error.oms_cancel_money_limit_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- 因为退票，所以给中心加钱
    p_org_fund_change(v_org_code, eflow_type.org_lottery_center_cancel, v_sale_amount, 0, v_cancel_apply_flow, v_temp_balance, v_temp_balance);


    -- 因为退票，所以给中心扣佣金
    if (v_sale_org <> '00' and v_sale_org_comm > 0) then
       p_org_fund_change(v_sale_org, eflow_type.org_lottery_cancel_comm, v_sale_org_comm, 0, v_cancel_apply_flow, v_temp_balance, v_temp_balance);
    end if;

    --因为退票,扣除销售站点的退票佣金
    p_agency_fund_change(v_sale_ticket.agency_code, eflow_type.lottery_cancel_comm, v_sale_comm, 0, v_cancel_apply_flow, v_out_balance, v_temp_balance);

    insert into his_cancelticket
      (applyflow_cancel, canceltime, applyflow_sell, is_center, org_code, cancel_seq)
    values
      (v_cancel_apply_flow, sysdate, v_sale_apply_flow, 1, v_org_code, f_get_his_cancel_seq);

  else
    v_cancel_agency_code := v_input_json.get('agency_code').get_string;
    v_cancel_terminal := v_input_json.get('term_code').get_string;
    v_cancel_teller := v_input_json.get('teller_code').get_number;
    v_org_code := f_get_agency_org(v_cancel_agency_code);
    v_org_type := f_get_org_type(v_org_code);

    -- 通用校验
    v_ret_num := f_set_check_general(v_cancel_terminal, v_cancel_teller, v_cancel_agency_code, v_org_code);
    if v_ret_num <> 0 then
      rollback;
      v_out_json.put('rc', v_ret_num);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- 判断站点 和 部门 的游戏销售授权可用
    if f_set_check_game_auth(v_cancel_agency_code, v_sale_ticket.game_code, 3) = 0 then
      rollback;
      v_out_json.put('rc', ehost_error.host_cancel_disable_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- 校验teller角色，退票员与退票票必须同时是培训模式
    if v_is_train = eboolean.yesorenabled and f_get_teller_role(v_cancel_teller) <> eteller_type.trainner then
      rollback;
      v_out_json.put('rc', ehost_error.host_t_teller_unauthen_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- 判断退票范围
    if f_set_check_pay_level(v_cancel_agency_code, v_sale_ticket.agency_code, v_sale_ticket.game_code) = 0 then
      rollback;
      v_out_json.put('rc', ehost_error.host_claiming_scope_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- 退票金额判断(退票级别)
    if v_sale_amount >= to_number(f_get_sys_param(1014)) then
      rollback;
      v_out_json.put('rc', ehost_error.host_cancel_moneylimit_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- 非培训票，才会有关于资金的操作 add by Chen Zhen @2016-07-06
    if v_is_train <> eboolean.yesorenabled then

      -- 给销售站退钱，同时扣除已经派赴的佣金
      p_agency_fund_change(v_cancel_agency_code, eflow_type.lottery_cancel, v_sale_amount, 0, v_cancel_apply_flow, v_out_balance, v_temp_balance);
      p_agency_fund_change(v_sale_ticket.agency_code, eflow_type.lottery_cancel_comm, v_sale_comm, 0, v_cancel_apply_flow, v_out_balance, v_temp_balance);

      -- 如果之前有代理商的钱，那就要退回来
      if v_sale_org_comm > 0 then
         p_org_fund_change(v_sale_org, eflow_type.org_lottery_cancel_comm, v_sale_org_comm, 0, v_cancel_apply_flow, v_temp_balance, v_temp_balance);
      end if;

      -- 如果是代理商,给代理商增加退票金额
      if (v_org_type = eorg_type.agent) then
           p_org_fund_change(v_org_code, eflow_type.org_lottery_agency_cancel, v_sale_amount, 0, v_cancel_apply_flow, v_temp_balance, v_temp_balance);
        end if;

      -- modify by Chen Zhen @2016-07-06
      -- 序号+1
      update saler_terminal
         set trans_seq = nvl(trans_seq, 0) + 1
       where terminal_code = v_cancel_terminal
      returning
        trans_seq
      into
        v_flownum;

      insert into his_cancelticket
        (applyflow_cancel, canceltime, applyflow_sell, terminal_code, teller_code, agency_code, is_center, org_code, cancel_seq, trans_seq)
      values
        (v_cancel_apply_flow, sysdate, v_sale_apply_flow, v_cancel_terminal, v_cancel_teller, v_cancel_agency_code, 0, v_org_code, f_get_his_cancel_seq, v_flownum);
    end if;
  end if;

  /************************ 构造返回参数 *******************************/
  v_out_json.put('type', v_input_json.get('type').get_number);
  v_out_json.put('rc', 0);

  if v_is_center <> 1 then
    v_out_json.put('account_balance', v_out_balance);
    v_out_json.put('marginal_credit', f_get_agency_credit(v_cancel_agency_code));
    v_out_json.put('flownum', v_flownum);
  end if;

  c_out_json := v_out_json.to_char();

  commit;

exception
  when others then
    c_errorcode := sqlcode;
    c_errormesg := sqlerrm;

    rollback;

    case c_errorcode
      when -20101 then
        c_errorcode := 25;
        c_errormesg := error_msg.err_common_1 || c_errormesg;

      when -20102 then
        c_errorcode := 25;
        c_errormesg := error_msg.err_common_1 || c_errormesg;

      else
        c_errorcode := 1;
        c_errormesg := error_msg.err_common_1 || c_errormesg;
    end case;
END;
