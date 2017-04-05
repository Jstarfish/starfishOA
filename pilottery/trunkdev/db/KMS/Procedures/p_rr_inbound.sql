create or replace procedure p_rr_inbound
/****************************************************************/
   ------------------- ��������� -------------------
   ---- ��������⡣֧������⣬������⣬�����ᡣ
   ----     ״̬�����ǡ��������������ܽ��в���
   ----     ����⣺  ���¡����������ջ���Ϣ��
   ----               ��������ⵥ����
   ----               ���մ��ݵ��������䡢�С��������²�Ʊ���ݣ�ͬʱҲҪ����ⵥ��ϸ�м�¼������
   ----               ���ݲ�Ʊͳ�����ݣ����¡���ⵥ���͡�����������¼��
   ----               �޸ġ��г�����Ա���Ŀ���Ʊ״̬��
   ----     ������⣺���մ��ݵ��������䡢�С��������²�Ʊ���ݣ�ͬʱҲҪ����ⵥ��ϸ�м�¼������
   ----               ���ݲ�Ʊͳ�����ݣ����¡���ⵥ���͡�����������¼��
   ----               �޸ġ��г�����Ա���Ŀ���Ʊ״̬��
   ----     �����᣺���¡����������͡���ⵥ��ʱ���״̬��Ϣ��
   ---- add by ����: 2015/9/21
   ---- �漰��ҵ���
   ----     2.1.6.6 ������                      -- ����
   ----     2.1.5.10 ��ⵥ                     -- ����������
   ----     2.1.5.11 ��ⵥ��ϸ                 -- ����������
   ----     2.1.5.3 ����Ʊ��Ϣ���䣩            -- ����
   ----     2.1.5.4 ����Ʊ��Ϣ���У�            -- ����
   ----     2.1.5.5 ����Ʊ��Ϣ������            -- ����
   ---- ҵ�����̣�
   ----     1��У��������������ֿ��Ƿ���ڣ����������Ƿ�Ϊ�¡���������᣻�������Ƿ�Ϸ�����
   ----     2����������Ϊ����ᡱʱ�����¡����������ġ��ջ�ʱ�䡱�͡�״̬��5-���ջ����������¡���ⵥ���ġ����ʱ�䡱�͡�״̬�����������У����ء�
   ----     3����ȡ�Ѿ�����Ĳ��������������εİ�װ��Ϣ-bulk��ʽ��ȡ����
   ----     4����������Ϊ���½���ʱ�����¡����������ջ���Ϣ��������Ҫ���롰״̬����ֵ����Ϊ��������������������ⵥ����
   ----     5�����������ϸ�����¡�����Ʊ��Ϣ�����и�����������ԣ������б�����롰״̬���͡����ڲֿ⡱���������Ҽ����¼�¼��������������޸��¼�¼������򱨴�
   ----        ͬʱͳ�Ʋ�Ʊͳ����Ϣ��
   ----     6�����¡���ⵥ���ġ�ʵ�������ϼơ��͡�ʵ�����������,�����������ġ�ʵ�ʵ���Ʊ�����͡�ʵ�ʵ���Ʊ���漰����¼��
   ----        �����г�����Ա�Ŀ�棻

   /*************************************************************/
(
 --------------����----------------
 p_r_no              in char,                -- ���������
 p_warehouse         in char,                -- �ջ��ֿ�
 p_oper_type         in number,              -- ��������(1-������2-������3-���)
 p_oper              in number,              -- ������
 p_remark            in varchar2,            -- ��ע
 p_array_lotterys    in type_lottery_list,   -- ���Ĳ�Ʊ����

 ---------���ڲ���---------
 c_errorcode out number,                     --�������
 c_errormesg out string                      --����ԭ��

 ) is

   v_count                 number(5);                                      -- ���¼������ʱ����
   v_wh_org                char(2);                                        -- �ֿ����ڲ���
   v_plan_tickets          number(18);                                     -- �ƻ����Ʊ��
   v_plan_amount           number(18);                                     -- �ƻ������
   v_mm                    number(4);                                      -- �г�����Ա
   v_sgr_no                char(10);                                       -- ��ⵥ���

   v_list_count            number(10);                                     -- �����ϸ����

   type type_detail        is table of wh_goods_receipt_detail%rowtype;
   v_insert_detail         type_detail;                                    -- ���������ϸ������
   v_detail_list           type_lottery_detail_list;                       -- �����ϸ
   v_stat_list             type_lottery_statistics_list;                   -- ���շ���������ͳ�ƵĽ���Ʊ��

   v_total_tickets         number(20);                                     -- ���˳������Ʊ��
   v_total_amount          number(28);                                     -- ���˳�����ܽ��
   v_plan_publish          number(1);                                      -- ӡ�Ƴ��̱��
   v_temp_tickets          number(20);                                     -- ���˳������Ʊ��
   v_temp_amount           number(28);                                     -- ���˳�����ܽ��

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
      select count(*) into v_count from dual where exists(select 1 from wh_goods_receipt where ref_no = p_r_no and status = ework_status.working);
      if v_count = 0 then
         c_errorcode := 4;
         c_errormesg := dbtool.format_line(p_r_no) || error_msg.err_p_tb_inbound_3; -- �ڽ��м������ʱ������ĵ������Ŵ��󣬻��ߴ˵�������Ӧ����ⵥ������Ѿ����
         return;
      end if;
   end if;
   /*----------- ҵ���߼�   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* ��������Ϊ����ᡱʱ�����¡����������ġ��ջ�ʱ�䡱�͡�״̬�������¡���ⵥ���ġ����ʱ�䡱�͡�״̬�����������У����ء� *************************/
   if p_oper_type = 3 then
      -- ���¡����������ġ��ջ�ʱ�䡱�͡�״̬��
      update sale_return_recoder
         set receive_date = sysdate,
             status = eorder_status.received
       where return_no = p_r_no
         and status = eorder_status.receiving
      returning
         status
      into
         v_count;
      if sql%rowcount = 0 then
         rollback;

         begin
            select status into v_count from sale_return_recoder where return_no = p_r_no;
         exception
            when no_data_found then
               c_errorcode := 24;
               c_errormesg := dbtool.format_line(p_r_no) || error_msg.err_p_rr_inbound_24; -- ��������Ų��Ϸ���δ��ѯ���˻�����
               return;
         end;

         c_errorcode := 4;
         c_errormesg := dbtool.format_line(p_r_no) || dbtool.format_line(v_count) || error_msg.err_p_rr_inbound_4; -- ������������ʱ��������״̬���Ϸ��������Ļ�����״̬Ӧ��Ϊ[�ջ���]
         return;
      end if;

      -- ���¡���ⵥ���ġ����ʱ�䡱�͡�״̬��
      update wh_goods_receipt
         set status = ework_status.done,
             receipt_end_time = sysdate,
             send_admin = p_oper,
             remark = p_remark
       where ref_no = p_r_no
         and status = ework_status.working;

      commit;
      return;
   end if;

   /**********************************************************************************************/
   /******************* ���������������Լ��Ѿ��ύ���������Ƿ�Ϸ� *************************/
   if f_check_import_ticket(p_r_no, 1, p_array_lotterys) then
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
   /******************* ��������Ϊ���½���ʱ�����¡����������ջ���Ϣ��������Ҫ���롰״̬������״̬������Ϊ���ѷ���������������ⵥ�� *************************/
   if p_oper_type = 1 then
      -- ���¡����������ջ���Ϣ
      update sale_return_recoder
         set receive_org = v_wh_org,
             receive_wh = p_warehouse,
             receive_manager = p_oper,
             status = eorder_status.receiving
       where return_no = p_r_no
         and status = eorder_status.audited
      returning
         status, apply_tickets, apply_amount, market_manager_admin
      into
         v_count, v_plan_tickets, v_plan_amount, v_mm;
      if sql%rowcount = 0 then
         rollback;

         begin
            select status into v_count from sale_return_recoder where return_no = p_r_no;
         exception
            when no_data_found then
               c_errorcode := 24;
               c_errormesg := dbtool.format_line(p_r_no) || error_msg.err_p_rr_inbound_24; -- ��������Ų��Ϸ���δ��ѯ���˻�����
               return;
         end;

         c_errorcode := 5;
         c_errormesg := dbtool.format_line(p_r_no) || dbtool.format_line(v_count) || error_msg.err_p_rr_inbound_5; -- ������������ʱ��������״̬���Ϸ��������Ļ�����״̬Ӧ��Ϊ[������]
         return;
      end if;

      -- ��������ⵥ��
      insert into wh_goods_receipt
         (sgr_no,                      create_admin,              receipt_amount,
          receipt_tickets,             receipt_type,              ref_no,
          receive_wh,                  RECEIVE_ORG)
      values
         (f_get_wh_goods_receipt_seq,  p_oper,                    v_plan_amount,
          v_plan_tickets,              ereceipt_type.return_back, p_r_no,
          p_warehouse,                 v_wh_org)
      returning
         sgr_no
      into
         v_sgr_no;
   else
      -- ��ȡ��ⵥ���
      begin
         select sgr_no into v_sgr_no from wh_goods_receipt where ref_no = p_r_no;
      exception
         when no_data_found then
            rollback;
            c_errorcode := 6;
            c_errormesg := dbtool.format_line(p_r_no) || error_msg.err_p_tb_inbound_6; -- ���ܻ����ⵥ���
            return;
      end;

      -- ��ȡ�г�����Ա���
      begin
         select market_manager_admin, status
           into v_mm, v_count
           from sale_return_recoder
          where return_no = p_r_no;
      exception
         when no_data_found then
            rollback;
            c_errorcode := 24;
            c_errormesg := dbtool.format_line(p_r_no) || error_msg.err_p_rr_inbound_24; -- ��������Ų��Ϸ���δ��ѯ���˻�����
            return;
      end;

      if v_count <> eorder_status.receiving then
         rollback;
         c_errorcode := 15;
         c_errormesg := dbtool.format_line(p_r_no) || dbtool.format_line(v_count) || error_msg.err_p_rr_inbound_15; -- �������������ʱ��������״̬���Ϸ��������Ļ�����״̬Ӧ��Ϊ[������]
      end if;

   end if;

   /********************************************************************************************************************************************************************/
   /******************* ���������ϸ�����¡�����Ʊ��Ϣ�����и�����������ԣ�ͬʱͳ�Ʋ�Ʊͳ����Ϣ *************************/

   -- ��ʼ������
   v_insert_detail := type_detail();
   v_total_tickets := 0;

   -- ������ϸ���ݣ����¡�����Ʊ��״̬
   p_ticket_perferm(p_array_lotterys, p_oper, eticket_status.in_mm, eticket_status.in_warehouse, v_mm, p_warehouse, v_err_code, v_err_msg);
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
      v_insert_detail(v_list_count).sgr_no := v_sgr_no;
      v_insert_detail(v_list_count).ref_no := p_r_no;
      v_insert_detail(v_list_count).sequence_no := f_get_wh_goods_receipt_det_seq;
      v_insert_detail(v_list_count).receipt_type := ereceipt_type.return_back;

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
      insert into wh_goods_receipt_detail values v_insert_detail(v_list_count);

   -- ѭ��ͳ�ƽ�������շ������Σ����¿��Ա���
   for v_loop_i in 1 .. v_stat_list.count loop

      -- ���²ֿ����Ա�����Ϣ����������������ⲻͬ��������ֿ����Ա��û�ж�Ӧ�������ο�������£��˴����εĲ�Ʊ
      update acc_mm_tickets
         set tickets = tickets - v_stat_list(v_loop_i).tickets,
             amount = amount - v_stat_list(v_loop_i).amount
       where market_admin = v_mm
         and plan_code = v_stat_list(v_loop_i).plan_code
         and batch_no = v_stat_list(v_loop_i).batch_no
      returning
         tickets, amount
      into
         v_temp_tickets, v_temp_amount;
      if sql%rowcount = 0 or v_temp_tickets < 0 or v_temp_amount < 0 then
         rollback;
         c_errorcode := 14;
         c_errormesg := dbtool.format_line(p_oper) || dbtool.format_line(v_stat_list(v_loop_i).plan_code) || dbtool.format_line(v_stat_list(v_loop_i).batch_no) || error_msg.err_p_ar_inbound_14; -- �ֿ����Ա�Ŀ���У�û�д˷��������εĿ����Ϣ
         return;
      end if;

   end loop;
   /********************************************************************************************************************************************************************/
   /******************* ���¡���ⵥ���ġ�ʵ�������ϼơ��͡�ʵ�����������,�����������ġ�ʵ�ʵ���Ʊ�����͡�ʵ�ʵ���Ʊ���漰����¼ *************************/
   update wh_goods_receipt
      set act_receipt_tickets = act_receipt_tickets + v_total_tickets,
          act_receipt_amount = act_receipt_amount + v_total_amount
    where sgr_no = v_sgr_no;

   update sale_return_recoder
      set act_tickets = act_tickets + v_total_tickets,
          act_amount = act_amount + v_total_amount
    where return_no = p_r_no;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
