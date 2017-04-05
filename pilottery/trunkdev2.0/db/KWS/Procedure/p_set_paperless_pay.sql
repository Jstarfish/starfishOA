CREATE OR REPLACE PROCEDURE p_set_paperless_pay
/*****************************************************************/
   ----------- 无纸化主机兑奖 ---------------
   --- add by Chen Zhen @ 2017/1/12

/*****************************************************************/
(
  p_input_json   in varchar2,                                         -- 入口参数

  c_out_json    out varchar2,                                         -- 出口参数
  c_errorcode   out number,                                           -- 业务错误编码
  c_errormesg   out varchar2                                          -- 错误信息描述

) IS
  v_input_json                json;
  v_out_json                  json;
  temp_json                   json;

  -- 报文内数据对象
  v_pay_apply_flow            char(24);                               -- 兑奖请求流水
  v_sale_apply_flow           char(24);                               -- 售票请求流水
  v_pay_agency_code           inf_agencys.agency_code%type;           -- 兑奖销售站
  v_pay_terminal              saler_terminal.terminal_code%type;      -- 兑奖终端
  v_pay_teller                inf_tellers.teller_code%type;           -- 兑奖销售员
  v_org_code                  inf_orgs.org_code%type;                 -- 中心兑奖机构代码或者兑奖销售站对应的机构代码

  -- 兑奖代销费计算
  v_pay_comm                  number(28);                             -- 站点兑奖代销费金额
  v_pay_comm_r                number(28);                             -- 站点兑奖代销费比例
  v_pay_org_comm              number(28);                             -- 代理商兑奖代销费金额
  v_pay_org_comm_r            number(28);                             -- 代理商兑奖代销费比例
  v_pay_amount                number(28);                             -- 中奖金额
  v_game_code                 number(3);                              -- 游戏ID


  -- 加减钱的操作
  v_out_balance               number(28);                             -- 传出的销售站余额
  v_temp_balance              number(28);                             -- 临时金额

  v_loyalty_code              his_sellticket.loyalty_code%type;       -- 彩民卡号码
  v_flownum                   number(18);                             -- 终端机交易序号
  v_count                     number(1);                              -- 临时变量，判断存在

BEGIN
  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  v_input_json := json(p_input_json);
  v_out_json := json();
  v_flownum := 0;

  -- 确认来的报文，是否是兑奖
  if v_input_json.get('type').get_number not in (3) then
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_set_pay_1 || v_input_json.get('type').get_number || '（无纸化兑奖）';             -- 报文输入有错，非兑奖报文。类型为：
    return;
  end if;

  -- 获取两个流水号
  v_pay_apply_flow := v_input_json.get('applyflow_pay').get_string;
  v_sale_apply_flow := json(v_input_json.get('ticket')).get('applyflow_sell').get_string;
  
  -- 判断此票是否已经兑奖
  select count(*)
    into v_count
    from dual
   where exists(select 1 from his_payticket where APPLYFLOW_SELL = v_sale_apply_flow);
  if v_count = 1 then
    v_out_json.put('rc', ehost_error.host_pay_paid_err);
    c_out_json := v_out_json.to_char();
    return;
  end if;

  -- 获取彩民卡编号
  v_loyalty_code := v_input_json.get('loyalty_code').get_number;

  -- 获取票对象
  temp_json := json();
  temp_json := json(v_input_json.get('ticket'));

  -- 获取中奖金额、游戏，准备计算代销费
  v_pay_amount := temp_json.get('winningamounttax').get_number;
  v_game_code := temp_json.get('game_code').get_number;

  if v_pay_amount >= to_number(f_get_sys_param(2001)) then
    v_out_json.put('rc', ehost_error.host_teller_pay_limit_err);
    c_out_json := v_out_json.to_char();
    return;
  end if;

  v_pay_agency_code := v_input_json.get('agency_code').get_string;
    
  -- 判断此票是否为此无纸化销售站售出
  select count(*)
    into v_count
    from dual
   where exists(select 1 from his_sellticket where APPLYFLOW_SELL = v_sale_apply_flow and AGENCY_CODE = v_pay_agency_code);
  if v_count = 0 then
    c_errorcode := 1;
    c_errormesg := '此票非此无纸化销售站售出';
    rollback;
    return;
  end if;
  
  begin
    select max(TERMINAL_CODE) into v_pay_terminal from saler_terminal where AGENCY_CODE = v_pay_agency_code;
  exception
    when no_data_found then
      c_errorcode := 1;
      c_errormesg := '没有找到无纸化销售站对应的终端';
      rollback;
      return;
  end;
    
  begin
    select max(TELLER_CODE) into v_pay_teller from inf_tellers where AGENCY_CODE = v_pay_agency_code;
  exception
    when no_data_found then
      c_errorcode := 1;
      c_errormesg := '没有找到无纸化销售站对应的销售员';
      rollback;
      return;
  end;
    
  v_org_code := f_get_agency_org(v_pay_agency_code);

  -- 判断站点 和 部门 的游戏销售授权可用
  if f_set_check_game_auth(v_pay_agency_code, v_game_code, 2) = 0 then
    v_out_json.put('rc', ehost_error.host_pay_disable_err);
    c_out_json := v_out_json.to_char();
    return;
  end if;

  -- 给销售站加钱
  p_agency_fund_change(v_pay_agency_code, eflow_type.lottery_pay, v_pay_amount, 0, v_pay_apply_flow, v_out_balance, v_temp_balance);

  -- 获取销售站的代销费比例
  v_pay_comm_r := f_get_agency_game_comm(v_pay_agency_code, v_game_code, ecomm_type.pay);

  v_pay_comm := v_pay_amount * v_pay_comm_r / 1000;

  -- 给销售站加代销费
  if v_pay_comm > 0 then
    p_agency_fund_change(v_pay_agency_code, eflow_type.lottery_pay_comm, v_pay_comm, 0, v_pay_apply_flow, v_out_balance, v_temp_balance);
  end if;

-- 序号+1
  update saler_terminal
     set trans_seq = nvl(trans_seq, 0) + 1
   where terminal_code = v_pay_terminal
  returning
    trans_seq
  into
    v_flownum;

  insert into his_payticket
    (applyflow_pay,                                              applyflow_sell,
     game_code,                                                  issue_number,
     terminal_code,                                              teller_code,                           agency_code,
     is_center,                                                  org_code,
     paytime,                                                    winningamounttax,
     winningamount,                                              taxamount,
     paycommissionrate,                                          commissionamount,
     paycommissionrate_o,                                        commissionamount_o,
     winningcount,                                               hd_winning,
     hd_count,                                                   ld_winning,
     ld_count,                                                   loyalty_code,
     is_big_prize,                                               pay_seq,
     trans_seq)
  values
    (v_pay_apply_flow,                                           v_sale_apply_flow,
     v_game_code,                                                temp_json.get('issue_number').get_number,         -- 期次为当前期
     v_pay_terminal,                                             v_pay_teller,                          v_pay_agency_code,
     0,                                                          v_org_code,
     sysdate,                                                    v_pay_amount,
     temp_json.get('winningamount').get_number,                  temp_json.get('taxamount').get_number,
     nvl(v_pay_comm_r, 0),                                       nvl(v_pay_comm, 0),
     nvl(v_pay_org_comm_r, 0),                                   nvl(v_pay_org_comm, 0),
     temp_json.get('winningcount').get_number,                   temp_json.get('hd_winning').get_number,
     temp_json.get('hd_count').get_number,                       temp_json.get('ld_winning').get_number,
     temp_json.get('ld_count').get_number,                       v_loyalty_code,
     temp_json.get('is_big_prize').get_number,                   f_get_his_pay_seq,
     v_flownum);

  /************************ 构造返回参数 *******************************/
  v_out_json.put('type', v_input_json.get('type').get_number);
  v_out_json.put('rc', 0);

  v_out_json.put('account_balance', v_out_balance);
  v_out_json.put('marginal_credit', f_get_agency_credit(v_pay_agency_code));
  v_out_json.put('flownum', v_flownum);

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
