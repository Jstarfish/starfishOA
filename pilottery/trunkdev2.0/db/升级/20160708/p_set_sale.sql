create or replace procedure p_set_sale
/*****************************************************************/
   ----------- ������Ʊ ---------------
/*****************************************************************/
(
   p_input_json   in varchar2,                           --��ڲ���

   c_out_json    out varchar2,                           --���ڲ���
   c_errorcode   out number,                             --ҵ��������
   c_errormesg   out varchar2                            --������Ϣ����
) is

  v_loop_i                number(5);

  v_input_json            json;
  v_out_json              json;

  -- Ʊ����Ϣjson��ʱ����
  temp_json               json;
  temp_json_list          json_list;

  -- ������
  v_apply_flow            char(24);                     -- ������ˮ

  -- �����Ѽ���
  v_agency_code           inf_agencys.agency_code%type;
  v_org_code              inf_orgs.org_code%type;
  v_teller_code           inf_tellers.teller_code%type;
  v_term_code             saler_terminal.terminal_code%type;

  v_org_type              number(1);
  v_game_code             number(3);
  v_sale_comm_r           number(28);                   -- վ�����۴����ѱ���
  v_sale_org_comm_r       number(28);                   -- ���������۴����ѱ���
  v_sale_comm             number(28);                   -- վ�����۴����ѽ��
  v_sale_org_comm         number(28);                   -- ���������۴����ѽ��
  v_sale_amount           number(28);                   -- ���۽��

  -- �Ӽ�Ǯ�Ĳ���
  v_out_balance           number(28);                   -- ����������վ���
  v_temp_balance          number(28);                   -- ��ʱ���

  v_iss_count             number(8);                    -- ����Ʊ����
  v_ret_num               number(3);                    -- ��ʱ����ֵ
  v_is_train              number(1);                    -- �Ƿ���ѵƱ
  v_flownum               number(18);                   -- �ն˻��������

begin
  --��ʼ������
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  v_input_json := json(p_input_json);
  v_out_json := json();

  -- ȷ�����ı��ģ��Ƿ�����Ʊ
  if v_input_json.get('type').get_number <> 1 then
     c_errorcode := 1;
     c_errormesg := error_msg.err_p_set_sale_1 || v_input_json.get('type').get_number;             -- ���������д�����Ʊ���ġ�����Ϊ��
     return;
  end if;

  temp_json := json(v_input_json.get('ticket'));
  temp_json_list := json_list(temp_json.get('bet_detail'));

  -- ��ȡƱ����Ϣ����ֹ�ظ�����
  v_apply_flow := v_input_json.get('applyflow_sell').get_string;
  v_iss_count := temp_json.get('issue_count').get_number;

  -- ���������
  v_agency_code := v_input_json.get('agency_code').get_string;
  v_teller_code := v_input_json.get('teller_code').get_number;
  v_term_code := v_input_json.get('term_code').get_string;
  v_org_code := f_get_agency_org(v_agency_code);

  -- ͨ��У��
  v_ret_num := f_set_check_general(v_term_code, v_teller_code, v_agency_code, v_org_code);
  if v_ret_num <> 0 then
    v_out_json.put('rc', v_ret_num);
    c_out_json := v_out_json.to_char();
    return;
  end if;

  v_game_code := temp_json.get('game_code').get_number;

  -- �ж�վ�� �� ���� ����Ϸ������Ȩ����
  if f_set_check_game_auth(v_agency_code, v_game_code, 1) = 0 then
    v_out_json.put('rc', ehost_error.host_sell_disable_err);
    c_out_json := v_out_json.to_char();
    return;
  end if;

  -- У��teller��ɫ
  v_is_train := eboolean.noordisabled;
  if f_get_teller_role(v_teller_code) = eteller_type.trainner then
    v_is_train := eboolean.yesorenabled;
  end if;

  -- ��ѵƱ����ˮ����0
  v_flownum := 0;

  if v_is_train = eboolean.noordisabled then
    -- ��������Ӷ��
    v_sale_amount := temp_json.get('ticket_amount').get_number;
    v_sale_comm_r := f_get_agency_game_comm(v_agency_code, v_game_code, ecomm_type.sale);
    v_sale_org_comm_r := f_get_org_game_comm(v_org_code, v_game_code, ecomm_type.sale);
    v_sale_comm := v_sale_amount * v_sale_comm_r / 1000;
    v_sale_org_comm := v_sale_amount * v_sale_org_comm_r / 1000;

    -- �����ն˻��������  modify by Chen Zhen @2016-07-06
    update saler_terminal
       set trans_seq = nvl(trans_seq, 0) + 1
     where terminal_code = v_term_code
    returning
      trans_seq
    into
      v_flownum;

    -- ��������
    insert into his_sellticket
      (applyflow_sell,                                             saletime,
       terminal_code,                                              teller_code,
       agency_code,
       -- Ʊ����Ϣ
       game_code,                                                  issue_number,
       start_issue,                                                end_issue,
       issue_count,                                                ticket_amount,
       ticket_bet_count,
       salecommissionrate,                                         commissionamount,
       salecommissionrate_o,                                       commissionamount_o,
       bet_methold,                                                bet_line,
       loyalty_code,
       -- ϵͳ��Ϣ
       result_code,                                                sell_seq,
       trans_seq)
    values
      (v_apply_flow,                                               sysdate,
       v_term_code,                                                v_teller_code,
       v_agency_code,
       -- Ʊ����Ϣ
       v_game_code,                                                temp_json.get('issue_number').get_number,
       temp_json.get('start_issue').get_number,                    temp_json.get('end_issue').get_number,
       v_iss_count,                                                v_sale_amount,
       temp_json.get('ticket_bet_count').get_number,
       v_sale_comm_r,                                              v_sale_comm,
       v_sale_org_comm_r,                                          v_sale_org_comm,
       temp_json.get('bet_methold').get_number,                    temp_json.get('bet_line').get_number,
       v_input_json.get('loyalty_code').get_string,
       -- ϵͳ��Ϣ
       0,                                                          f_get_his_sell_seq,
       v_flownum);

    -- ������ϸ����
    for v_loop_i in 1..temp_json_list.count loop
      temp_json := json(temp_json_list.get(v_loop_i));

      insert into his_sellticket_detail
        (applyflow_sell,                                          saletime,
         line_no,                                                 bet_type,
         subtype,                                                 oper_type,
         section,                                                 bet_amount,
         bet_count,                                               line_amount)
      values
        (v_apply_flow,                                            sysdate,
         temp_json.get('line_no').get_number,                     temp_json.get('bet_type').get_number,
         temp_json.get('subtype').get_number,                     temp_json.get('oper_type').get_number,
         temp_json.get('section').get_string,                     temp_json.get('bet_times').get_number,
         temp_json.get('bet_count').get_number,                   temp_json.get('bet_amount').get_number);

    end loop;

    -- �Ƿ����Ʊ
    if v_iss_count > 1 then
      insert into his_sellticket_multi_issue (applyflow_sell) values (v_apply_flow);
    end if;

    -- ������վ��Ǯ
    p_agency_fund_change(v_agency_code, eflow_type.lottery_sale, v_sale_amount, 0, v_apply_flow, v_out_balance, v_temp_balance);

    -- ������վ��Ӷ��
    p_agency_fund_change(v_agency_code, eflow_type.lottery_sale_comm, v_sale_comm, 0, v_apply_flow, v_out_balance, v_temp_balance);

    --�������̿�Ǯ
    v_org_type := f_get_org_type(v_org_code);
    if v_org_type = eorg_type.agent then
      p_org_fund_change(v_org_code, eflow_type.org_lottery_agency_sale, v_sale_amount, 0, v_apply_flow, v_temp_balance, v_temp_balance);
    end if;

    -- �����������ͣ��Ƿ�����̣���ϵͳ���������Ƿ������Ӷ��
    if v_sale_org_comm > 0 then
      if (v_org_code <> '00' and v_org_type = eorg_type.company and f_get_sys_param(16) = '1') or (v_org_type = eorg_type.agent) then
        p_org_fund_change(v_org_code, eflow_type.org_lottery_agency_sale_comm, v_sale_org_comm, 0, v_apply_flow, v_temp_balance, v_temp_balance);
      end if;
    end if;
  end if;

  /************************ ���췵�ز��� *******************************/
  v_out_json := json();

  v_out_json.put('type', 1);
  v_out_json.put('rc', 0);
  v_out_json.put('applyflow_sell', v_apply_flow);
  v_out_json.put('agency_code', v_agency_code);
  v_out_json.put('is_train', v_is_train);
  v_out_json.put('account_balance', v_out_balance);
  v_out_json.put('marginal_credit', f_get_agency_credit(v_agency_code));
  v_out_json.put('flownum', v_flownum);
  v_out_json.put('commission_amount',v_sale_comm);
  c_out_json := v_out_json.to_char();

  commit;

exception
   when others then
      c_errorcode := sqlcode;
      c_errormesg := sqlerrm;

      rollback;

      case c_errorcode
         when -20101 then
            c_errorcode := ehost_error.host_sell_lack_amount_err;
            c_errormesg := error_msg.err_common_1 || c_errormesg;

         when -20102 then
            c_errorcode := ehost_error.host_sell_lack_amount_err;
            c_errormesg := error_msg.err_common_1 || c_errormesg;

         else
            c_errorcode := 1;
            c_errormesg := error_msg.err_common_1 || c_errormesg;
      end case;
end;