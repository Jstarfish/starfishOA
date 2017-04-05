CREATE OR REPLACE PROCEDURE p_set_cancel
/*****************************************************************/
   ----------- ������Ʊ ---------------
/*****************************************************************/
(
   p_input_json            in varchar2,                           -- ��ڲ���
   c_out_json              out varchar2,                          -- ���ڲ���
   c_errorcode             out number,                            -- ҵ��������
   c_errormesg             out varchar2                           -- ������Ϣ����
) IS
  v_input_json            json;
  v_out_json              json;
  temp_json               json;

  v_sale_ticket           his_sellticket%rowtype;
  v_is_center             number(1);                              -- �Ƿ�������Ʊ

  -- ���������ݶ���
  v_cancel_apply_flow     char(24);                               -- ��Ʊ������ˮ
  v_sale_apply_flow       char(24);                               -- ��Ʊ������ˮ
  v_cancel_agency_code    inf_agencys.agency_code%type;           -- ��Ʊ����վ
  v_cancel_terminal       saler_terminal.terminal_code%type;      -- ��Ʊ�ն�
  v_cancel_teller         inf_tellers.teller_code%type;           -- ��Ʊ����Ա
  v_org_code              inf_orgs.org_code%type;                 -- ������Ʊ��������
  v_org_type              number(1);
  v_sale_org              inf_agencys.org_code%type;                 --����վ��Ӧ�����Ļ�������

  -- �˴����Ѽ���
  v_sale_comm             number(28);                             -- վ�����۴����ѽ��
  v_sale_org_comm         number(28);                             -- ���������۴����ѽ��
  v_sale_amount           number(28);                             -- ���۽��

  -- �Ӽ�Ǯ�Ĳ���
  v_out_balance           number(28);                             -- ����������վ���
  v_temp_balance          number(28);                             -- ��ʱ���

  v_is_train              number(1);                              -- �Ƿ���ѵƱ
  v_loyalty_code          his_sellticket.loyalty_code%type;       -- ���񿨺���
  v_ret_num               number(10);                             -- ��ʱ����ֵ
  v_flownum               number(18);                             -- �ն˻��������
  v_count                 number(1);                              -- ��ʱ�������жϴ���

BEGIN
  --��ʼ������
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  v_input_json := json(p_input_json);
  v_out_json := json();


  -- ȷ�����ı��ģ��Ƿ�����Ʊ
  if v_input_json.get('type').get_number not in (2, 4) then
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_set_cancel_1 || v_input_json.get('type').get_number;             -- ���������д�����Ʊ���ġ�����Ϊ��
    return;
  end if;

  -- ȷ����Ʊģʽ
  if v_input_json.get('type').get_number = 4 then
    v_is_center := 1;
  else
    v_is_center := 0;
  end if;

  -- �Ƿ���ѵƱ��Ʊ
  v_is_train := v_input_json.get('is_train').get_number;

  -- ��ȡ������ˮ��
  v_cancel_apply_flow := v_input_json.get('applyflow_cancel').get_string;
  v_sale_apply_flow := json(v_input_json.get('ticket')).get('applyflow_sell').get_string;

  -- �жϴ�Ʊ�Ƿ��Ѿ���Ʊ
  -- modify by kwx 2016-05-30 ������Ʊ��Դ������վ�����ģ����ز�ͬ�Ĵ������
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

  -- ��ȡ���񿨱��
  v_loyalty_code := v_input_json.get('loyalty_code').get_number;

  -- ��ȡԭ������Ʊ��Ϣ
  begin
    select * into v_sale_ticket from his_sellticket where applyflow_sell = v_sale_apply_flow;
  exception
    when no_data_found then
      c_errorcode := 1;
      c_errormesg := error_msg.err_p_set_cancel_2 || v_sale_apply_flow;                            -- δ�ҵ���Ӧ����Ʊ��Ϣ���������ˮ��Ϊ��
      rollback;
      return;
  end;

  -- ��ȡ֮ǰ�Ľ������
  v_sale_amount := v_sale_ticket.ticket_amount;
  v_sale_comm := v_sale_ticket.commissionamount;
  v_sale_org_comm := v_sale_ticket.commissionamount_o;

  --modify by kwx 2016-05-30,�����������Ʊ,��ȥ����Ӷ��
  v_sale_org := f_get_agency_org(v_sale_ticket.agency_code);

  -- ������Ʊ���ͣ�ȷ�����ݲ�������
  if v_is_center = 1 then

    if v_is_train = eboolean.yesorenabled then
      rollback;
      c_errorcode := 1;
      c_errormesg := '������Ʊ��������ѵƱ';
      return;
    end if;

    v_org_code := v_input_json.get('org_code').get_string;

    -- �жϻ����Ƿ���Ч������
    select count(*)
      into v_count
      from dual
     where exists(select 1 from inf_orgs where org_code = v_org_code and org_status = eorg_status.available);
    if v_count = 0 then
      v_out_json.put('rc', ehost_error.host_t_token_expired_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

  --modify by kwx 2016-05-18 ����game_code�ж���Ϸ��Ȩ

    -- �жϻ����Ƿ������Ʊ
    select count(*)
      into v_count
      from dual
     where exists(select 1 from auth_org where org_code = v_org_code and game_code = v_sale_ticket.game_code and allow_cancel = eboolean.yesorenabled);
    if v_count = 0 then
      -- modify by ChenZhen 2016-05-19 ������Ʊ��Դ������վ�����ģ����ز�ͬ�Ĵ������
      if v_is_center = 0 then
        v_out_json.put('rc', ehost_error.host_t_teller_unauthen_err);
        c_out_json := v_out_json.to_char();
      else
        v_out_json.put('rc', ehost_error.oms_org_not_auth_cancel_err);
        c_out_json := v_out_json.to_char();
      end if;
      return;
    end if;

    -- ��Ʊ����ж�(��Ʊ����)�����ﻹҪ�ж��Ƿ����ô�����
    if v_sale_amount >= to_number(f_get_sys_param(1015)) and f_get_sys_param(1016) = '1' and v_org_code <> '00' then
      rollback;
      v_out_json.put('rc', ehost_error.oms_cancel_money_limit_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- ��Ϊ��Ʊ�����Ը����ļ�Ǯ
    p_org_fund_change(v_org_code, eflow_type.org_lottery_center_cancel, v_sale_amount, 0, v_cancel_apply_flow, v_temp_balance, v_temp_balance);


    -- ��Ϊ��Ʊ�����Ը����Ŀ�Ӷ��
    if (v_sale_org <> '00' and v_sale_org_comm > 0) then
       p_org_fund_change(v_sale_org, eflow_type.org_lottery_cancel_comm, v_sale_org_comm, 0, v_cancel_apply_flow, v_temp_balance, v_temp_balance);
    end if;

    --��Ϊ��Ʊ,�۳�����վ�����ƱӶ��
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

    -- ͨ��У��
    v_ret_num := f_set_check_general(v_cancel_terminal, v_cancel_teller, v_cancel_agency_code, v_org_code);
    if v_ret_num <> 0 then
      rollback;
      v_out_json.put('rc', v_ret_num);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- �ж�վ�� �� ���� ����Ϸ������Ȩ����
    if f_set_check_game_auth(v_cancel_agency_code, v_sale_ticket.game_code, 3) = 0 then
      rollback;
      v_out_json.put('rc', ehost_error.host_cancel_disable_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- У��teller��ɫ����ƱԱ����ƱƱ����ͬʱ����ѵģʽ
    if v_is_train = eboolean.yesorenabled and f_get_teller_role(v_cancel_teller) <> eteller_type.trainner then
      rollback;
      v_out_json.put('rc', ehost_error.host_t_teller_unauthen_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- �ж���Ʊ��Χ
    if f_set_check_pay_level(v_cancel_agency_code, v_sale_ticket.agency_code, v_sale_ticket.game_code) = 0 then
      rollback;
      v_out_json.put('rc', ehost_error.host_claiming_scope_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- ��Ʊ����ж�(��Ʊ����)
    if v_sale_amount >= to_number(f_get_sys_param(1014)) then
      rollback;
      v_out_json.put('rc', ehost_error.host_cancel_moneylimit_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- ����ѵƱ���Ż��й����ʽ�Ĳ��� add by Chen Zhen @2016-07-06
    if v_is_train <> eboolean.yesorenabled then

      -- ������վ��Ǯ��ͬʱ�۳��Ѿ��ɸ���Ӷ��
      p_agency_fund_change(v_cancel_agency_code, eflow_type.lottery_cancel, v_sale_amount, 0, v_cancel_apply_flow, v_out_balance, v_temp_balance);
      p_agency_fund_change(v_sale_ticket.agency_code, eflow_type.lottery_cancel_comm, v_sale_comm, 0, v_cancel_apply_flow, v_out_balance, v_temp_balance);

      -- ���֮ǰ�д����̵�Ǯ���Ǿ�Ҫ�˻���
      if v_sale_org_comm > 0 then
         p_org_fund_change(v_sale_org, eflow_type.org_lottery_cancel_comm, v_sale_org_comm, 0, v_cancel_apply_flow, v_temp_balance, v_temp_balance);
      end if;

      -- ����Ǵ�����,��������������Ʊ���
      if (v_org_type = eorg_type.agent) then
           p_org_fund_change(v_org_code, eflow_type.org_lottery_agency_cancel, v_sale_amount, 0, v_cancel_apply_flow, v_temp_balance, v_temp_balance);
        end if;

      -- modify by Chen Zhen @2016-07-06
      -- ���+1
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

  /************************ ���췵�ز��� *******************************/
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
