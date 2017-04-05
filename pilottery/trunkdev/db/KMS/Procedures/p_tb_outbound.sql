create or replace procedure p_tb_outbound
/****************************************************************/
   ------------------- ���������� -------------------
   ---- ���������⡣֧���³��⣬�������⣬������ᡣ
   ----     ״̬�����ǡ��������������ܽ��в���
   ----     �³��⣺  ���¡���������������Ϣ�����������ⵥ�������մ��ݵĳ�������䡢�С��������²�Ʊ���ݣ�ͬʱҲҪ�ڳ��ⵥ��ϸ�м�¼������󣻸��ݲ�Ʊͳ�����ݣ����¡����ⵥ���͡�����������¼��
   ----     �������⣺���մ��ݵĳ�������䡢�С��������²�Ʊ���ݣ�ͬʱҲҪ�ڳ��ⵥ��ϸ�м�¼������󣻸��ݲ�Ʊͳ�����ݣ����¡����ⵥ���͡�����������¼��
   ----     ������᣺���¡����������͡����ⵥ��ʱ���״̬��Ϣ��
   ---- add by ����: 2015/9/19
   ---- �漰��ҵ���
   ----     2.1.6.6 ��������sale_transfer_bill��                     -- ����
   ----     2.1.5.10 ���ⵥ��wh_goods_receipt��                      -- ����������
   ----     2.1.5.11 ���ⵥ��ϸ��wh_goods_receipt_detail��           -- ����������
   ----     2.1.5.3 ����Ʊ��Ϣ���䣩��wh_ticket_trunk��              -- ����
   ----     2.1.5.4 ����Ʊ��Ϣ���У���wh_ticket_box��                -- ����
   ----     2.1.5.5 ����Ʊ��Ϣ��������wh_ticket_package��            -- ����
   ---- ҵ�����̣�
   ----     1��У��������������ֿ��Ƿ���ڣ����������Ƿ�Ϊ�¡���������᣻�������Ƿ�Ϸ�����
   ----     2����������Ϊ����ᡱʱ�����¡����������ġ�����ʱ�䡱�͡�״̬�������¡����ⵥ���ġ�����ʱ�䡱�͡�״̬�����������У����ء�
   ----     3����ȡ�Ѿ�����Ĳ��������������εİ�װ��Ϣ-bulk��ʽ��ȡ����
   ----     3����������Ϊ���½���ʱ�����¡���������������Ϣ��������Ҫ���롰״̬������״̬������Ϊ���������������������ⵥ����
   ----     4�����ճ�����ϸ�����¡�����Ʊ��Ϣ�����и�����������ԣ������б�����롰״̬���͡����ڲֿ⡱���������Ҽ����¼�¼��������������޸��¼�¼������򱨴�ͬʱͳ�Ʋ�Ʊͳ����Ϣ��
   ----     5�����¡����ⵥ���ġ�ʵ�ʳ�����ϼơ��͡�ʵ�ʳ���������,�����������ġ�ʵ�ʵ���Ʊ�����͡�ʵ�ʵ���Ʊ���漰����¼��

   /*************************************************************/
(
 --------------����----------------
 p_stb_no            in char,                -- ���������
 p_warehouse         in char,                -- �����ֿ�
 p_oper_type         in number,              -- ��������(1-������2-������3-���)
 p_oper              in number,              -- ������
 p_remark            in varchar2,            -- ��ע
 p_array_lotterys    in type_lottery_list,   -- ����Ĳ�Ʊ����

 ---------���ڲ���---------
 c_errorcode out number,                     --�������
 c_errormesg out string                      --����ԭ��

 ) is

   v_count                 number(5);                                      -- ���¼������ʱ����
   v_wh_org                char(2);                                        -- �ֿ����ڲ���
   v_plan_tickets          number(18);                                     -- �ƻ�����Ʊ��
   v_plan_amount           number(28);                                     -- �ƻ�������
   v_sgi_no                char(10);                                       -- ���ⵥ���
   v_list_count            number(10);                                     -- ������ϸ����

   type type_detail        is table of wh_goods_issue_detail%rowtype;
   v_insert_detail         type_detail;                                    -- ���������ϸ������
   v_detail_list           type_lottery_detail_list;                       -- �����ϸ
   v_stat_list             type_lottery_statistics_list;                   -- ���շ���������ͳ�ƵĽ���Ʊ��

   v_total_tickets         number(20);                                     -- ���˳������Ʊ��
   v_total_amount          number(28);                                     -- ���˳�����ܽ��
   v_plan_publish          number(1);                                      -- ӡ�Ƴ��̱��

   v_err_code              number(10);                                     -- ���ô洢����ʱ������ֵ
   v_err_msg               varchar2(4000);                                 -- ���ô洢����ʱ�����ش�����Ϣ

begin

   /*-----------    ��ʼ������    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- ����У��   -----------------*/
   -- У����ڲ����Ƿ���ȷ����Ӧ�����ݼ�¼�Ƿ����
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- �޴���
      return;
   end if;

   if not f_check_warehouse(p_warehouse) then
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_warehouse) || error_msg.err_common_101; -- �޴˲ֿ�
      return;
   end if;

   if not p_oper_type in (1,2,3) then
      c_errorcode := 3;
      c_errormesg := dbtool.format_line(p_oper_type) || error_msg.err_common_105; -- �������Ͳ�������Ӧ��Ϊ1��2��3
      return;
   end if;

   -- �������ʱ���ж��Ƿ��Ѿ����
   if p_oper_type = 2 then
      select count(*) into v_count from dual where exists(select 1 from wh_goods_issue where ref_no = p_stb_no and status = ework_status.working);
      if v_count = 0 then
         c_errorcode := 4;
         c_errormesg := dbtool.format_line(p_stb_no) || error_msg.err_p_tb_outbound_3; -- �ڽ��м�������ʱ������ĵ������Ŵ��󣬻��ߴ˵�������Ӧ�ĳ��ⵥ�������Ѿ����
         return;
      end if;
   end if;

   /*----------- ҵ���߼�   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* ��������Ϊ����ᡱʱ�����¡����������ġ�����ʱ�䡱�͡�״̬�������¡����ⵥ���ġ�����ʱ�䡱�͡�״̬�����������У����ء� *************************/
   if p_oper_type = 3 then
      -- ���¡����������ġ�����ʱ�䡱�͡�״̬��
      update sale_transfer_bill
         set send_date = sysdate,
             status = eorder_status.sent
       where stb_no = p_stb_no
         and status = eorder_status.agreed
      returning
         status
      into
         v_count;
      if sql%rowcount = 0 then
         select status into v_count from sale_transfer_bill where stb_no = p_stb_no;
         rollback;
         c_errorcode := 5;
         c_errormesg := dbtool.format_line(p_stb_no) || dbtool.format_line(v_count) || error_msg.err_p_tb_outbound_4; -- �������������ʱ��������״̬���Ϸ�
         return;
      end if;

      -- ���¡����ⵥ���ġ�����ʱ�䡱�͡�״̬��
      update wh_goods_issue
         set status = ework_status.done,
             issue_end_time = sysdate,
             receive_admin = create_admin,
             remark = p_remark
       where ref_no = p_stb_no
         and status = ework_status.working
       returning issue_tickets,  issue_amount,  act_issue_tickets, act_issue_amount
            into v_plan_tickets, v_plan_amount, v_total_tickets,   v_total_amount;

      -- ���������������������ݣ��Ƿ����
      with
         act as (
            select plan_code, sum(tickets) alltickets
              from wh_goods_issue_detail
             where ref_no = p_stb_no
             group by plan_code),
         plan as (
            select plan_code, sum(tickets) alltickets
              from sale_tb_apply_detail
             where stb_no = p_stb_no
             group by plan_code),
         detail as (
            select plan_code, alltickets as act_tickets, 0 as plan_tickets from act
            union all
            select plan_code, 0 as act_tickets, alltickets as plan_tickets from plan),
         result as (
            select plan_code,sum(act_tickets) act_tickets, sum(plan_tickets) plan_tickets from detail group by plan_code),
         not_rule_list as (
            select plan_code, act_tickets, plan_tickets from result where act_tickets <> plan_tickets)
      select count(*) into v_count from dual where exists(select 1 from not_rule_list);
      if v_count > 0 then
         rollback;
         c_errorcode := 5;
         c_errormesg := error_msg.err_p_tb_outbound_14; -- ������ʵ�ʳ���������������������
         return;
      end if;

      commit;
      return;
   end if;

   /************************************************************************************/
   /******************* ���������������Ƿ�Ϸ� *************************/
   if f_check_import_ticket(p_stb_no, 2, p_array_lotterys) then
      c_errorcode := 6;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_103; -- ��Ʊ���󣬴��ڡ��԰����������
      return;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* ��ȡ�Ѿ�����Ĳ��������������εİ�װ��Ϣ-bulk��ʽ��ȡ���� *************************/

   -- ��ȡӡ�Ƴ�����Ϣ
/*   select plan_flow
     into v_plan_publish
     from inf_publishers
    where publisher_code =
          (select publisher_code from game_plans where plan_code = p_plan);
*/

   -- �ֿ����ڲ���
   select org_code into v_wh_org from wh_info where warehouse_code = p_warehouse;

   /********************************************************************************************************************************************************************/
   /******************* ��������Ϊ���½���ʱ�����¡���������������Ϣ��������Ҫ���롰״̬������״̬������Ϊ���������������������ⵥ�� *************************/
   if p_oper_type = 1 then
      -- ���¡���������������Ϣ
      update sale_transfer_bill
         set send_org = v_wh_org,
             send_wh = p_warehouse,
             send_manager = p_oper,
             status = eorder_status.agreed
       where stb_no = p_stb_no
         and status = eorder_status.audited
      returning
         status, tickets, amount
      into
         v_count, v_plan_tickets, v_plan_amount;
      if sql%rowcount = 0 then
         rollback;
         c_errorcode := 5;
         c_errormesg := dbtool.format_line(p_stb_no) || dbtool.format_line(v_count) || error_msg.err_p_tb_outbound_5; -- ���е���������ʱ��������״̬���Ϸ�
         return;
      end if;

      -- ���������ⵥ��
      insert into wh_goods_issue
         (sgi_no,                    create_admin,           issue_amount,
          issue_tickets,             issue_type,             ref_no,
          send_org,                  send_wh)
      values
         (f_get_wh_goods_issue_seq,  p_oper,                 v_plan_amount,
          v_plan_tickets,            eissue_type.trans_bill, p_stb_no,
          v_wh_org,                  p_warehouse)
      returning
         sgi_no
      into
         v_sgi_no;
   else
      -- ��ȡ���ⵥ���
      begin
         select sgi_no into v_sgi_no from wh_goods_issue where ref_no = p_stb_no;
      exception
         when no_data_found then
            rollback;
            c_errorcode := 6;
            c_errormesg := dbtool.format_line(p_stb_no) || error_msg.err_p_tb_outbound_6; -- ���ܻ�ó��ⵥ���
            return;
      end;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* ���ճ�����ϸ�����¡�����Ʊ��Ϣ�����и�����������ԣ�ͬʱͳ�Ʋ�Ʊͳ����Ϣ *************************/

   -- ��ʼ������
   v_insert_detail := type_detail();
   v_total_tickets := 0;


   -- ������ϸ���ݣ����¡�����Ʊ��״̬
   p_ticket_perferm(p_array_lotterys, p_oper, eticket_status.in_warehouse, eticket_status.on_way, p_warehouse, null, v_err_code, v_err_msg);
   if v_err_code <> 0 then
      rollback;
      c_errorcode := 1;
      c_errormesg := error_msg.err_common_104 || v_err_msg; -- ���¡�����Ʊ��״̬ʱ�����ִ���
      return;
   end if;

   -- ͳ���������Ʊ����
   p_lottery_detail_stat(p_array_lotterys, v_detail_list, v_stat_list, v_total_tickets, v_total_amount);

   -- ���������ϸ
   for v_list_count in 1 .. v_detail_list.count loop
      v_insert_detail.extend;
      v_insert_detail(v_list_count).sgi_no := v_sgi_no;
      v_insert_detail(v_list_count).ref_no := p_stb_no;
      v_insert_detail(v_list_count).sequence_no := f_get_wh_goods_issue_detai_seq;
      v_insert_detail(v_list_count).issue_type := eissue_type.trans_bill;

      v_insert_detail(v_list_count).valid_number := v_detail_list(v_list_count).valid_number;
      v_insert_detail(v_list_count).plan_code := v_detail_list(v_list_count).plan_code;
      v_insert_detail(v_list_count).batch_no := v_detail_list(v_list_count).batch_no;
      v_insert_detail(v_list_count).amount := v_detail_list(v_list_count).amount;
      v_insert_detail(v_list_count).trunk_no := v_detail_list(v_list_count).trunk_no;
      v_insert_detail(v_list_count).box_no := v_detail_list(v_list_count).box_no;
      v_insert_detail(v_list_count).package_no := v_detail_list(v_list_count).package_no;
      v_insert_detail(v_list_count).tickets := v_detail_list(v_list_count).tickets;
   end loop;

   forall v_list_count in 1 .. v_insert_detail.count
      insert into wh_goods_issue_detail values v_insert_detail(v_list_count);

   /********************************************************************************************************************************************************************/
   /******************* ���¡����ⵥ���ġ�ʵ�ʳ�����ϼơ��͡�ʵ�ʳ���������,�����������ġ�ʵ�ʵ���Ʊ�����͡�ʵ�ʵ���Ʊ���漰����¼ *************************/
   update wh_goods_issue
      set act_issue_tickets = act_issue_tickets + v_total_tickets,
          act_issue_amount = act_issue_amount + v_total_amount
    where sgi_no = v_sgi_no
   returning issue_tickets, act_issue_tickets
        into v_plan_amount, v_total_amount;

   -- ���������������������ݣ��Ƿ����
   with
      act as (
         select plan_code, sum(tickets) alltickets
           from wh_goods_issue_detail
          where ref_no = p_stb_no
          group by plan_code),
      plan as (
         select plan_code, sum(tickets) alltickets
           from sale_tb_apply_detail
          where stb_no = p_stb_no
          group by plan_code),
      detail as (
         select plan_code, alltickets as act_tickets, 0 as plan_tickets from act
         union all
         select plan_code, 0 as act_tickets, alltickets as plan_tickets from plan),
      result as (
         select plan_code,sum(act_tickets) act_tickets, sum(plan_tickets) plan_tickets from detail group by plan_code),
      not_rule_list as (
         select plan_code, act_tickets, plan_tickets from result where act_tickets > plan_tickets)
   select count(*) into v_count from dual where exists(select 1 from not_rule_list);
   if v_count > 0 then
      rollback;
      c_errorcode := 5;
      c_errormesg := error_msg.err_p_tb_outbound_14; -- ������ʵ�ʳ���������������������
      return;
   end if;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;
end;

