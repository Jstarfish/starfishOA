CREATE OR REPLACE PROCEDURE p_set_pay
/*****************************************************************/
   ----------- �����ҽ� ---------------
/*****************************************************************/
(
  p_input_json   in varchar2,                                         -- ��ڲ���

  c_out_json    out varchar2,                                         -- ���ڲ���
  c_errorcode   out number,                                           -- ҵ��������
  c_errormesg   out varchar2                                          -- ������Ϣ����
) IS
  v_input_json                json;
  v_out_json                  json;
  temp_json                   json;

  v_is_center                 number(1);                              -- �Ƿ����Ķҽ�

  -- ���������ݶ���
  v_pay_apply_flow            char(24);                               -- �ҽ�������ˮ
  v_sale_apply_flow           char(24);                               -- ��Ʊ������ˮ
  v_pay_agency_code           inf_agencys.agency_code%type;           -- �ҽ�����վ
  v_sale_agency_code          inf_agencys.agency_code%type;           -- ��Ʊ����վ
  v_pay_terminal              saler_terminal.terminal_code%type;      -- �ҽ��ն�
  v_pay_teller                inf_tellers.teller_code%type;           -- �ҽ�����Ա
  v_org_code                  inf_orgs.org_code%type;                 -- ���Ķҽ�����������߶ҽ�����վ��Ӧ�Ļ�������
  v_org_type                  number(1);

  -- �ҽ������Ѽ���
  v_pay_comm                  number(28);                             -- վ��ҽ������ѽ��
  v_pay_comm_r                number(28);                             -- վ��ҽ������ѱ���
  v_pay_org_comm              number(28);                             -- �����̶ҽ������ѽ��
  v_pay_org_comm_r            number(28);                             -- �����̶ҽ������ѱ���
  v_pay_amount                number(28);                             -- �н����
  v_game_code                 number(3);                              -- ��ϷID


  -- �Ӽ�Ǯ�Ĳ���
  v_out_balance               number(28);                             -- ����������վ���
  v_temp_balance              number(28);                             -- ��ʱ���

  v_is_train                  number(1);                              -- �Ƿ���ѵƱ
  v_loyalty_code              his_sellticket.loyalty_code%type;       -- ���񿨺���
  v_ret_num                   number(10);                             -- ��ʱ����ֵ
  v_flownum                   number(18);                             -- �ն˻��������
  v_count                     number(1);                              -- ��ʱ�������жϴ���

BEGIN
  --��ʼ������
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  v_input_json := json(p_input_json);
  v_out_json := json();
  v_flownum := 0;

  -- ȷ�����ı��ģ��Ƿ��Ƕҽ�
  if v_input_json.get('type').get_number not in (3, 5) then
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_set_pay_1 || v_input_json.get('type').get_number;             -- ���������д��Ƕҽ����ġ�����Ϊ��
    return;
  end if;

  -- �Ƿ���ѵƱ�ҽ�
  v_is_train := v_input_json.get('is_train').get_number;

  -- ȷ���ҽ�ģʽ
  if v_input_json.get('type').get_number = 5 then
     v_is_center := 1;
  else
     v_is_center := 0;
  end if;

  -- ��ȡ������ˮ��
  v_pay_apply_flow := v_input_json.get('applyflow_pay').get_string;
  v_sale_apply_flow := json(v_input_json.get('ticket')).get('applyflow_sell').get_string;

  -- �жϴ�Ʊ�Ƿ��Ѿ��ҽ�
  select count(*)
    into v_count
    from dual
   where exists(select 1 from his_payticket where APPLYFLOW_SELL = v_sale_apply_flow);
  if v_count = 1 then
    v_out_json.put('rc', ehost_error.host_pay_paid_err);
    c_out_json := v_out_json.to_char();
    return;
  end if;

  -- ��ȡ���񿨱��
  v_loyalty_code := v_input_json.get('loyalty_code').get_number;

  -- ��ȡƱ����
  temp_json := json();
  temp_json := json(v_input_json.get('ticket'));

  -- ��ȡ�н�����Ϸ��׼�����������
  v_pay_amount := temp_json.get('winningamounttax').get_number;
  v_game_code := temp_json.get('game_code').get_number;

  -- ���ݶҽ����ͣ���ȡ�ҽ�����վ���նˡ�����Ա���ҽ����
  if v_is_center = 1 then

    if v_is_train = eboolean.yesorenabled then
      c_errorcode := 1;
      c_errormesg := '���Ķҽ����ܶ���ѵƱ';
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

    -- �жϻ����Ƿ���Զҽ�
    select count(*)
      into v_count
      from dual
     where exists(select 1 from auth_org where org_code = v_org_code and game_code = v_game_code and allow_pay = eboolean.yesorenabled);
    if v_count = 0 then
      -- modify by ChenZhen 2016-05-19 ���նҽ���Դ������վ�����ģ����ز�ͬ�Ĵ������
      if v_is_center = 0 then
        v_out_json.put('rc', ehost_error.host_pay_disable_err);
        c_out_json := v_out_json.to_char();
      else
        v_out_json.put('rc', ehost_error.oms_org_not_auth_pay_err);
        c_out_json := v_out_json.to_char();
      end if;

      return;
    end if;

    -- �ҽ�����ж�(�ҽ�����)�����ﻹҪ�ж��Ƿ����ô�����
    if v_pay_amount >= to_number(f_get_sys_param(6)) and f_get_sys_param(7) = '1' and v_org_code <> '00' then
      v_out_json.put('rc', ehost_error.oms_pay_money_limit_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;


    -- ��������Ǯ
    p_org_fund_change(v_org_code, eflow_type.org_lottery_center_pay, v_pay_amount, 0, v_pay_apply_flow, v_temp_balance, v_temp_balance);

    -- ��ȡ��֯�����Ĵ����ѱ���
    v_pay_org_comm_r := f_get_org_game_comm(v_org_code, v_game_code, ecomm_type.pay);

    v_pay_org_comm := v_pay_amount * v_pay_org_comm_r / 1000;

    v_org_type := f_get_org_type(v_org_code);

    -- ͨ��ϵͳ������ȷ���Ƿ����֯����������
    if (v_pay_org_comm >0 ) and ((v_org_type <> '00' and v_org_type = eorg_type.company and f_get_sys_param(16) = '1') or (v_org_type = eorg_type.agent)) then
      p_org_fund_change(v_org_code, eflow_type.org_lottery_center_pay_comm, v_pay_org_comm, 0, v_pay_apply_flow, v_temp_balance, v_temp_balance);
    end if;

  else
    v_pay_agency_code := v_input_json.get('agency_code').get_string;
    v_pay_terminal := v_input_json.get('term_code').get_string;
    v_pay_teller := v_input_json.get('teller_code').get_number;
    v_org_code := f_get_agency_org(v_pay_agency_code);

    -- ͨ��У��
    v_ret_num := f_set_check_general(v_pay_terminal, v_pay_teller, v_pay_agency_code, v_org_code);
    if v_ret_num <> 0 then
      v_out_json.put('rc', v_ret_num);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- �ж�վ�� �� ���� ����Ϸ������Ȩ����
    if f_set_check_game_auth(v_pay_agency_code, v_game_code, 2) = 0 then
      v_out_json.put('rc', ehost_error.host_pay_disable_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- У��teller��ɫ���ҽ�Ա��ҽ�Ʊ����ͬʱ����ѵģʽ
    if v_is_train = eboolean.yesorenabled and f_get_teller_role(v_pay_teller) <> eteller_type.trainner then
      v_out_json.put('rc', ehost_error.host_t_teller_unauthen_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- �ж϶ҽ���Χ
    v_sale_agency_code := v_input_json.get('sale_agency').get_string;
    if f_set_check_pay_level(v_pay_agency_code, v_sale_agency_code, v_game_code) = 0 then
      v_out_json.put('rc', ehost_error.host_claiming_scope_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    -- �ҽ�����ж�(�ҽ�����)
    if v_pay_amount >= to_number(f_get_sys_param(5)) then
      v_out_json.put('rc', ehost_error.host_teller_pay_limit_err);
      c_out_json := v_out_json.to_char();
      return;
    end if;

    if v_is_train <> eboolean.yesorenabled then

      -- ������վ��Ǯ
      p_agency_fund_change(v_pay_agency_code, eflow_type.lottery_pay, v_pay_amount, 0, v_pay_apply_flow, v_out_balance, v_temp_balance);

      -- ��ȡ����վ�Ĵ����ѱ���
      v_pay_comm_r := f_get_agency_game_comm(v_pay_agency_code, v_game_code, ecomm_type.pay);

      v_pay_comm := v_pay_amount * v_pay_comm_r / 1000;

      -- ������վ�Ӵ�����
      if v_pay_comm > 0 then
        p_agency_fund_change(v_pay_agency_code, eflow_type.lottery_pay_comm, v_pay_comm, 0, v_pay_apply_flow, v_out_balance, v_temp_balance);
      end if;

      -- ��ȡ�ҽ�����վ��Ӧ����֯��������
      v_org_type := f_get_org_type(v_org_code);

      -- ��ȡ��֯�����Ĵ����ѱ���
      v_pay_org_comm_r := f_get_org_game_comm(v_org_code, v_game_code, ecomm_type.pay);
      v_pay_org_comm := v_pay_amount * v_pay_org_comm_r / 1000;

      --�������̼�Ǯ
      if v_org_type = eorg_type.agent then
        p_org_fund_change(v_org_code, eflow_type.org_lottery_agency_pay, v_pay_amount, 0, v_pay_apply_flow, v_temp_balance, v_temp_balance);
      end if;


      -- ͨ��ϵͳ������ȷ���Ƿ����֯����������
      if ((v_org_code <> '00' and v_org_type = eorg_type.company and f_get_sys_param(16) = '1') or (v_org_type = eorg_type.agent)) then
        if v_pay_org_comm > 0 then
          p_org_fund_change(v_org_code, eflow_type.org_lottery_agency_pay_comm, v_pay_org_comm, 0, v_pay_apply_flow, v_temp_balance, v_temp_balance);
        end if;
      end if;
    end if;
  end if;

  -- ������ѵƱ�������
  if v_is_train <> eboolean.yesorenabled then
    -- modify by Chen Zhen @2016-07-06
    -- ���+1
    if v_is_center <> 1 then
      update saler_terminal
         set trans_seq = nvl(trans_seq, 0) + 1
       where terminal_code = v_pay_terminal
      returning
        trans_seq
      into
        v_flownum;
    end if;

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
       v_game_code,                                                temp_json.get('issue_number').get_number,         -- �ڴ�Ϊ��ǰ��
       v_pay_terminal,                                             v_pay_teller,                          v_pay_agency_code,
       v_is_center,                                                v_org_code,
       sysdate,                                                    v_pay_amount,
       temp_json.get('winningamount').get_number,                  temp_json.get('taxamount').get_number,
       nvl(v_pay_comm_r, 0),                                       nvl(v_pay_comm, 0),
       nvl(v_pay_org_comm_r, 0),                                   nvl(v_pay_org_comm, 0),
       temp_json.get('winningcount').get_number,                   temp_json.get('hd_winning').get_number,
       temp_json.get('hd_count').get_number,                       temp_json.get('ld_winning').get_number,
       temp_json.get('ld_count').get_number,                       v_loyalty_code,
       temp_json.get('is_big_prize').get_number,                   f_get_his_pay_seq,
       v_flownum);
  end if;

  /************************ ���췵�ز��� *******************************/
  v_out_json.put('type', v_input_json.get('type').get_number);
  v_out_json.put('rc', 0);

  if v_is_center <> 1 then
    v_out_json.put('account_balance', v_out_balance);
    v_out_json.put('marginal_credit', f_get_agency_credit(v_pay_agency_code));
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