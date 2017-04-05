create or replace procedure p_gi_outbound
/****************************************************************/
   ------------------- ���������� -------------------
   ---- ���������⡣֧���³��⣬�������⣬������ᡣ
   ----     ״̬�����ǡ����ύ�������ܽ��в���
   ----     �³��⣺  ���¡����������ĳ����ֿ���Ϣ��״ֵ̬��
   ----               ���������ⵥ�������մ��ݵĳ�������䡢�С��������²�Ʊ���ݣ�ͬʱҲҪ�ڳ��ⵥ��ϸ�м�¼�������
   ----               ���ݲ�Ʊͳ�����ݣ����¹���Ա��Ʊ��棬�ж��Ƿ񳬹�����Ա����޶���¡����ⵥ���͡���������ʵ�ʳ�Ʊ��¼��
   ----
   ----     �������⣺���մ��ݵĳ�������䡢�С��������²�Ʊ���ݣ�ͬʱҲҪ�ڳ��ⵥ��ϸ�м�¼�������
   ----               ���ݲ�Ʊͳ�����ݣ����¹���Ա��Ʊ��棬�ж��Ƿ񳬹�����Ա����޶���¡����ⵥ���͡���������ʵ�ʳ�Ʊ��¼��
   ----
   ----     ������᣺���¡����������͡����ⵥ��ʱ���״̬��Ϣ��ͬʱ������ء���������״̬��
   ---- add by ����: 2015/9/19
   ---- �漰��ҵ���
   ----     2.1.6.6 ��������sale_delivery_order��                    -- ����
   ----     2.1.5.10 ���ⵥ��wh_goods_receipt��                      -- ����������
   ----     2.1.5.11 ���ⵥ��ϸ��wh_goods_receipt_detail��           -- ����������
   ----     2.1.5.3 ����Ʊ��Ϣ���䣩��wh_ticket_trunk��              -- ����
   ----     2.1.5.4 ����Ʊ��Ϣ���У���wh_ticket_box��                -- ����
   ----     2.1.5.5 ����Ʊ��Ϣ��������wh_ticket_package��            -- ����
   ---- ҵ�����̣�
   ----     1��У��������������ֿ��Ƿ���ڣ����������Ƿ�Ϊ�¡���������᣻�������Ƿ�Ϸ�����
   ----     2����������Ϊ����ᡱʱ��
   ----        ���¡����������ġ��������ڡ��͡�״̬����
   ----        ���¡����ⵥ���ġ�����ʱ�䡱�͡�״̬����
   ----        ���¡�����������ء���������״̬��
   ----        �������У�����
   ----     3����ȡ�Ѿ�����Ĳ��������������εİ�װ��Ϣ-bulk��ʽ��ȡ����
   ----     3����������Ϊ���½���ʱ�����¡��������������ֿ���Ϣ��״̬��������Ҫ���롰״̬������״̬������Ϊ�����ύ�������������ⵥ����
   ----     4�����ճ�����ϸ�����¡�����Ʊ��Ϣ�����и�����������ԣ������б�����롰״̬���͡����ڲֿ⡱���������Ҽ����¼�¼��������������޸��¼�¼������򱨴�ͬʱͳ�Ʋ�Ʊͳ����Ϣ��
   ----     5�����¹���Ա��Ʊ��棬�ж��Ƿ񳬹�����Ա����޶
   ----     6�����¡����ⵥ���ġ�ʵ�ʳ�����ϼơ��͡�ʵ�ʳ���������,�����������ġ�ʵ�ʵ���Ʊ�����͡�ʵ�ʵ���Ʊ���漰����¼��

/*************************************************************/
(
 --------------����----------------
 p_do_no             in char,                -- ���������
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
   v_detail_list           type_lottery_detail_list;                       -- ������ϸ
   v_stat_list             type_lottery_statistics_list;                   -- ���շ���������ͳ�ƵĽ���Ʊ��

   v_total_tickets         number(20);                                     -- ���˳������Ʊ��
   v_total_amount          number(28);                                     -- ���˳�����ܽ��
   v_plan_publish          number(1);                                      -- ӡ�Ƴ��̱��
   v_delivery_mm           number(4);                                      -- ��������Ӧ���г�����Ա

   v_delivery_amount       number(28);                                     -- ��Ʊ���

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

   -- ����Ƿ������˲�Ʊ����
   if p_array_lotterys.count = 0 and p_oper_type in (1,2) then
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_109; -- ��������У�û�з��ֲ�Ʊ����
      return;
   end if;

   -- ��������ʱ���ж��Ƿ��Ѿ����
   if p_oper_type = 2 then
      select count(*) into v_count from dual where exists(select 1 from wh_goods_issue where ref_no = p_do_no and status = ework_status.working);
      if v_count = 0 then
         c_errorcode := 4;
         c_errormesg := dbtool.format_line(p_do_no) || error_msg.err_p_gi_outbound_3; -- �ڽ��м�������ʱ������ĵ������Ŵ��󣬻��ߴ˵�������Ӧ�ĳ��ⵥ�������Ѿ����
         return;
      end if;
   end if;

   /*----------- ҵ���߼�   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* ��������Ϊ����ᡱʱ�����¡����������ġ�����ʱ�䡱�͡�״̬�������¡����ⵥ���ġ�����ʱ�䡱�͡�״̬�����������У����ء� *************************/
   if p_oper_type = 3 then
      -- ���¡����������ġ�����ʱ�䡱�͡�״̬��
      update sale_delivery_order
         set out_date = sysdate,
             status = eorder_status.sent
       where do_no = p_do_no
         and status = eorder_status.agreed
      returning
         status, apply_admin
      into
         v_count, v_delivery_mm;
      if sql%rowcount = 0 then
         rollback;
         c_errorcode := 4;
         c_errormesg := dbtool.format_line(p_do_no) || dbtool.format_line(v_count) || error_msg.err_p_gi_outbound_4; -- �������������ʱ��������״̬���Ϸ�
         return;
      end if;

      -- ���¡����ⵥ���ġ�����ʱ�䡱�͡�״̬��
      update wh_goods_issue
         set status = ework_status.done,
             remark = p_remark,
             issue_end_time = sysdate
       where ref_no = p_do_no
         and status = ework_status.working;

      -- ���¡�������״̬  ��BUG 208������״̬֪��������������ˣ�����Ҫ�����ٸ��£�
      /*update sale_order
         set status = eorder_status.sent,
             sender_admin = v_delivery_mm,
             send_warehouse = p_warehouse,
             send_date = sysdate
       where order_no in (select order_no from sale_delivery_order_all where do_no = p_do_no); */

      commit;
      return;
   end if;

   /**********************************************************************************************/
   /******************* �������ĳ�������Լ��Ѿ��ύ�ĳ�������Ƿ�Ϸ� *************************/
   if f_check_import_ticket(p_do_no, 2, p_array_lotterys) then
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
      update sale_delivery_order
         set wh_org = v_wh_org,
             wh_code = p_warehouse,
             wh_admin = p_oper,
             status = eorder_status.agreed
       where do_no = p_do_no
         and status = eorder_status.applyed
      returning
         status, tickets, apply_admin, amount
      into
         v_count, v_plan_tickets, v_delivery_mm, v_plan_amount;
      if sql%rowcount = 0 then
         rollback;
         c_errorcode := 5;
         c_errormesg := dbtool.format_line(p_do_no) || dbtool.format_line(v_count) || error_msg.err_p_gi_outbound_5; -- ���г���������ʱ��������״̬���Ϸ�
         return;
      end if;

      -- ���������ⵥ��
      insert into wh_goods_issue
         (sgi_no,                    create_admin,                issue_amount,
          issue_tickets,             issue_type,                  ref_no,
          send_org,                  send_wh,                     receive_admin)
      values
         (f_get_wh_goods_issue_seq,  p_oper,                      v_plan_amount,
          v_plan_tickets,            eissue_type.delivery_order,  p_do_no,
          v_wh_org,                  p_warehouse,                 v_delivery_mm)
      returning
         sgi_no
      into
         v_sgi_no;
   else
      -- ��ȡ���ⵥ���
      begin
         select sgi_no into v_sgi_no from wh_goods_issue where ref_no = p_do_no;
      exception
         when no_data_found then
            rollback;
            c_errorcode := 6;
            c_errormesg := dbtool.format_line(p_do_no) || error_msg.err_p_gi_outbound_6; -- ���ܻ�ó��ⵥ���
            return;
      end;

      -- ��ȡ�г�����Ա���
      select apply_admin
        into v_delivery_mm
        from sale_delivery_order
       where do_no = p_do_no;

   end if;

   /********************************************************************************************************************************************************************/
   /******************* ���ճ�����ϸ�����¡�����Ʊ��Ϣ�����и�����������ԣ�ͬʱͳ�Ʋ�Ʊͳ����Ϣ *************************/

   -- ��ʼ������
   v_insert_detail := type_detail();
   v_total_tickets := 0;

   -- ������ϸ���ݣ����¡�����Ʊ��״̬
   p_ticket_perferm(p_array_lotterys, p_oper, eticket_status.in_warehouse, eticket_status.in_mm, p_warehouse, v_delivery_mm, v_err_code, v_err_msg);
   if v_err_code <> 0 then
      rollback;
      c_errorcode := 1;
      c_errormesg := error_msg.err_common_104 || v_err_msg; -- ���¡�����Ʊ��״̬ʱ�����ִ���
      return;
   end if;

   -- ͳ�Ƴ�������Ʊ����
   p_lottery_detail_stat(p_array_lotterys, v_detail_list, v_stat_list, v_total_tickets, v_total_amount);

   -- ���������ϸ
   for v_list_count in 1 .. v_detail_list.count loop
      v_insert_detail.extend;
      v_insert_detail(v_list_count).sgi_no := v_sgi_no;
      v_insert_detail(v_list_count).ref_no := p_do_no;
      v_insert_detail(v_list_count).sequence_no := f_get_wh_goods_issue_detai_seq;
      v_insert_detail(v_list_count).issue_type := eissue_type.delivery_order;

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
   /******************* ���¹���Ա��Ʊ��棬�ж��Ƿ񳬹�����Ա����޶ *************************/
   for v_list_count in 1 .. v_stat_list.count loop
      merge into acc_mm_tickets tgt
      using (select v_delivery_mm market_admin, v_stat_list(v_list_count).plan_code plan_code, v_stat_list(v_list_count).batch_no batch_no from dual) tab
         on (tgt.market_admin = tab.market_admin and tgt.plan_code = tab.plan_code and tgt.batch_no = tab.batch_no)
       when matched then
         update set tgt.tickets = tgt.tickets + v_stat_list(v_list_count).tickets,
                    tgt.amount = tgt.amount + v_stat_list(v_list_count).amount
       when not matched then
         insert values (v_delivery_mm, v_stat_list(v_list_count).plan_code, v_stat_list(v_list_count).batch_no, v_stat_list(v_list_count).tickets, v_stat_list(v_list_count).amount);
   end loop;

   -- ��ȡ����Ա��ǰ����Ʊ���
   select sum(tickets)
     into v_delivery_amount
     from acc_mm_tickets
    where market_admin = v_delivery_mm;

   -- �ж��Ƿ񳬹�����Ʊ���
   select count(*)
     into v_count
     from dual
    where exists(select 1 from inf_market_admin
                  where market_admin = v_delivery_mm
                    and max_amount_ticketss < nvl(v_delivery_amount, 0));
   if v_count = 1 then
      rollback;
      c_errorcode := 17;
      c_errormesg := dbtool.format_line(v_delivery_mm) || dbtool.format_line(v_delivery_amount) || error_msg.err_p_gi_outbound_17; -- �����˹���Ա������еġ������Ʊ��
      return;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* ���¡����ⵥ���ġ�ʵ�ʳ�����ϼơ��͡�ʵ�ʳ���������,�����������ġ�ʵ�ʵ���Ʊ�����͡�ʵ�ʵ���Ʊ���漰����¼ *************************/
   update wh_goods_issue
      set act_issue_tickets = nvl(act_issue_tickets, 0) + v_total_tickets,
          act_issue_amount = nvl(act_issue_amount, 0) + v_total_amount
    where sgi_no = v_sgi_no;

   update sale_delivery_order
      set act_tickets = nvl(act_tickets, 0) + v_total_tickets,
          act_amount = nvl(act_amount, 0) + v_total_amount
    where do_no = p_do_no;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;
end;
