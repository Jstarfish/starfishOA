create or replace procedure p_batch_inbound
/****************************************************************/
   ------------------- ��Ʊ������� -------------------
   ---- ��Ʊ��⡣֧������⣬������⣬�����ᡣ
   ----     ����⣺  ������������⡱��¼��������ⵥ�����մ��ݵ��������䡢�С�������¼��Ʊ���ݣ�ͬʱҲҪ����ⵥ��ϸ�м�¼������
   ----     ������⣺���մ��ݵ��������䡢�С��������²�Ʊ���ݣ�ͬʱҲҪ����ⵥ��ϸ�м�¼�����󣻸�����������¼���޸����ӵĲ�Ʊͳ�����ݣ�
   ----     �����᣺���մ��ݵ��������䡢�С��������²�Ʊ���ݣ�ͬʱҲҪ����ⵥ��ϸ�м�¼�����󣻸�����������¼���޸����ӵĲ�Ʊͳ�����ݣ�����������״̬��
   ---- add by ����: 2015/9/15
   ---- �漰��ҵ���
   ----     2.1.5.7 ������⣨wh_batch_inbound��
   ----     2.1.5.10 ��ⵥ��wh_goods_receipt��
   ----     2.1.5.11 ��ⵥ��ϸ��wh_goods_receipt_detail��
   ----     2.1.5.3 ����Ʊ��Ϣ���䣩��wh_ticket_trunk��
   ----     2.1.5.4 ����Ʊ��Ϣ���У���wh_ticket_box��
   ----     2.1.5.5 ����Ʊ��Ϣ��������wh_ticket_package��
   ---- ҵ�����̣�
   ----     1��У������������������������Ƿ���ڣ��ֿ��Ƿ���ڣ����������Ƿ�Ϊ�¡���������᣻�������Ƿ�Ϸ��������������Ǽ��������ʱ����Ҫ���������ⵥ����Ƿ���ڣ�
   ----     2����������Ϊ����ᡱʱ������ ������⣨wh_batch_inbound������ⵥ��wh_goods_receipt�����������У����ء�
   ----     3����ȡ�Ѿ�����Ĳ��������������εİ�װ��Ϣ-bulk��ʽ��ȡ����
   ----     4�����Ȳ��롰����Ʊ����ͬʱͳ�Ʋ��������
   ----     5���жϲ������͡�
   ----          ����⣺    ���� ������⣨wh_batch_inbound������ⵥ��wh_goods_receipt��
   ----          ������⣺  ���� ������⣨wh_batch_inbound������ⵥ��wh_goods_receipt��
   ----                   ������������������Ҫ ���� �������ϸ��

   /*************************************************************/
(
 --------------����----------------
 p_inbound_no        in varchar2,            -- ������ⵥ��ţ���������£����Դ˲���������Ϊ��¼�
 p_plan              in char,                -- ����
 p_batch             in char,                -- ����
 p_warehouse         in char,                -- �ֿ�
 p_oper_type         in number,              -- ��������(1-������2-������3-���)
 p_oper              in number,              -- ������
 p_array_lotterys    in type_lottery_list,   -- ���Ĳ�Ʊ����

 ---------���ڲ���---------
 c_inbound_no out varchar2,
 c_errorcode out number,                     --�������
 c_errormesg out string                      --����ԭ��

 ) is

   v_count                 number(5);                                      -- ���¼������ʱ����
   v_collect_batch_param   game_batch_import_detail%rowtype;               -- ���β���
   v_bi_no                 char(10);                                       -- ������ⵥ���(bi12345678)
   v_sgr_no                char(10);                                       -- ��ⵥ��ţ�rk12345678��
   v_array_lottery         type_lottery_info;                              -- ���Ų�Ʊ
   v_lottery_detail        type_lottery_info;                              -- ��Ʊ������ϸ��Ϣ
   v_format_lotterys       type_lottery_list;

   v_list_count            number(10);                                     -- �����ϸ����
   v_trunk_count           number(10);                                     -- ��⡰�䡱��
   v_box_count             number(10);                                     -- ��⡰�С���
   v_pack_count            number(10);                                     -- ��⡰������
   v_scan_count_trunk      number(10);                                     -- ɨ��ġ��䡱��
   v_scan_count_box        number(10);                                     -- ɨ��ġ��С���
   v_scan_count_pack       number(10);                                     -- ɨ��ġ�������

   type type_trunk         is table of wh_ticket_trunk%rowtype;
   type type_box           is table of wh_ticket_box%rowtype;
   type type_pack          is table of wh_ticket_package%rowtype;
   type type_detail        is table of wh_goods_receipt_detail%rowtype;
   v_insert_trunks         type_trunk;                                     -- ����е�����
   v_insert_boxes          type_box;                                       -- ����е�����
   v_insert_packs          type_pack;                                      -- ���뱾������
   v_insert_detail         type_detail;                                    -- ���������ϸ������
   v_trunk                 wh_ticket_trunk%rowtype;
   v_box                   wh_ticket_box%rowtype;
   v_pack                  wh_ticket_package%rowtype;

   v_loop_i                number(10);                                     -- ѭ��ʹ�õĲ���
   v_loop_j                number(10);                                     -- ѭ��ʹ�õĲ���

   v_packs_every_box       number(10);                                     -- ÿ���С��а������١�����
   v_total_tickets         number(20);                                     -- ����������Ʊ��
   v_plan_publish          number(1);                                      -- ӡ�Ƴ��̱��
   v_single_ticket_amount  number(10);                                     -- ÿ��Ʊ�ļ۸�

   v_all_lottery_list      type_lottery_list;                              -- ��ȥ���������ϵ������

   v_detail_list           type_lottery_detail_list;                       -- �����ϸ
   v_stat_list             type_lottery_statistics_list;                   -- ���շ���������ͳ�ƵĽ���Ʊ��
   v_total_amount          number(28);                                     -- ���������ܽ��

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

   if not f_check_plan_batch(p_plan,p_batch) then
      c_errorcode := 3;
      c_errormesg := dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || error_msg.err_common_102; -- �޴�����
      return;
   end if;

   if not p_oper_type in (1,2,3) then
      c_errorcode := 4;
      c_errormesg := dbtool.format_line(p_oper_type) || error_msg.err_p_batch_inbound_4; -- �������Ͳ�������Ӧ��Ϊ1��2��3
      return;
   end if;

   if p_oper_type in (2,3) then
      select count(*) into v_count from dual where exists(select 1 from wh_batch_inbound where bi_no = p_inbound_no);
      if v_count = 0 then
         c_errorcode := 5;
         c_errormesg := dbtool.format_line(p_inbound_no) || error_msg.err_p_batch_inbound_5; -- �ڽ��м����������������ʱ�������������ⵥ����δ���ִ�������ⵥ
         return;
      end if;
   end if;

   -- �������ʱ���ж��Ƿ��Ѿ����
   if p_oper_type = 2 then
      select count(*) into v_count from dual where exists(select 1 from wh_goods_receipt where ref_no = p_inbound_no and status = ework_status.working);
      if v_count = 0 then
         c_errorcode := 6;
         c_errormesg := dbtool.format_line(p_inbound_no) || error_msg.err_p_batch_inbound_6; -- �ڽ��м������ʱ�������������ⵥ���󣬻��ߴ�������ⵥ�Ѿ����
         return;
      end if;
   end if;
   /*----------- ҵ���߼�   -----------------*/
   /**********************************************************/
   /******************* ��ȡ������Ϣ *************************/

   -- ��ȡӡ�Ƴ�����Ϣ
   select plan_flow
     into v_plan_publish
     from inf_publishers
    where publisher_code =
          (select publisher_code from game_plans where plan_code = p_plan);

   -- ��ȡ����Ĳ���
   select * into v_collect_batch_param from game_batch_import_detail where plan_code = p_plan and batch_no = p_batch;

   -- ��ȡ����Ʊ���
   select ticket_amount into v_single_ticket_amount from game_plans where plan_code = p_plan;

   -- ��ʼ������
   v_insert_trunks := type_trunk();
   v_insert_boxes  := type_box();
   v_insert_packs  := type_pack();
   v_trunk_count   := 0;
   v_box_count     := 0;
   v_pack_count    := 0;
   v_scan_count_trunk := 0;
   v_scan_count_box   := 0;
   v_scan_count_pack  := 0;

   -- ÿ���С��а������١�����
   v_packs_every_box := v_collect_batch_param.packs_every_trunk / v_collect_batch_param.boxes_every_trunk;

   /********************************************************************/
   /******************* �ȴ���������������� *************************/
   -- �����⣺  ���� ������⣨wh_batch_inbound������ⵥ��wh_goods_receipt��
   if p_oper_type = 3 then
      update wh_batch_inbound
         set damaged_tickets = batch_tickets - act_tickets,
             damaged_amount = batch_amount - act_amount,
             discrepancy_tickets = batch_tickets - act_tickets,
             discrepancy_amount = batch_amount - act_amount,
             oper_admin = p_oper,
             oper_date = sysdate
       where bi_no = p_inbound_no;

      update wh_goods_receipt
         set status = ework_status.done,
             receipt_end_time = sysdate
       where ref_no = p_inbound_no;

      commit;
      return;
   end if;

   /************************************************************************************/
   /******************* ���������������Ƿ�Ϸ� *************************/
   v_format_lotterys := type_lottery_list();
   for v_list_count in 1 .. p_array_lotterys.count loop
      v_array_lottery := p_array_lotterys(v_list_count);
      case
         when v_array_lottery.valid_number = evalid_number.trunk then
            v_array_lottery.box_no := '-';
            v_array_lottery.package_no := '-';

         when v_array_lottery.valid_number = evalid_number.box then
            v_lottery_detail := f_get_lottery_info(p_plan, p_batch, v_array_lottery.valid_number, v_array_lottery.box_no);
            v_array_lottery.trunk_no := v_lottery_detail.trunk_no;
            v_array_lottery.package_no := '-';

         when v_array_lottery.valid_number = evalid_number.pack then
            v_lottery_detail := f_get_lottery_info(p_plan, p_batch, v_array_lottery.valid_number, v_array_lottery.package_no);
            v_array_lottery.trunk_no := v_lottery_detail.trunk_no;
            v_array_lottery.box_no := v_lottery_detail.box_no;

      end case;
      v_array_lottery.plan_code := p_plan;
      v_array_lottery.batch_no := p_batch;

      v_format_lotterys.extend;
      v_format_lotterys(v_format_lotterys.count) := v_array_lottery;
   end loop;

   if p_oper_type = 2 then
      -- �ж���������û�����Ѿ����������ظ������ߴ��ڽ���Ķ������磺�Ѿ������䣬�������е�һ����Ʊ��
      select type_lottery_info(plan_code, batch_no, valid_number, trunk_no, box_no, '', package_no, '', 0)
        bulk collect into v_all_lottery_list
        from wh_goods_receipt_detail
       where sgr_no = (select sgr_no from wh_goods_receipt where ref_no = p_inbound_no);

      -- �ϲ���ǰ����
      v_all_lottery_list := v_all_lottery_list multiset union v_format_lotterys;

   else
      v_all_lottery_list := v_format_lotterys;

   end if;

   if f_check_ticket_perfect(v_all_lottery_list) then
      rollback;
      c_errorcode := 6;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_103; -- ��Ʊ���󣬴��ڡ��԰����������
      return;
   end if;

   /************************************************************************************/
   /******************* ���롰�䡱���ݣ�����ȡ�������ͳ��ֵ *************************/
   -- ���롰�䡱����
   for v_list_count in 1 .. v_format_lotterys.count loop
      v_array_lottery := v_format_lotterys(v_list_count);

      -- ͳ��ɨ��Ķ���
      case
         when v_array_lottery.valid_number = evalid_number.trunk then
            v_scan_count_trunk := v_scan_count_trunk + 1;

         when v_array_lottery.valid_number = evalid_number.box then
            v_scan_count_box := v_scan_count_box + 1;

         when v_array_lottery.valid_number = evalid_number.pack then
            v_scan_count_pack := v_scan_count_pack + 1;

      end case;

      -- ��ϸΪ ���䡱����Ҫ�� �䡢�С��� �϶������¼
      if v_array_lottery.valid_number = evalid_number.trunk then
         -- ��ȡ��Ʊ����ϸ����
         v_lottery_detail := f_get_lottery_info(p_plan, p_batch, v_array_lottery.valid_number, v_array_lottery.trunk_no);

         -- ���㽱����
         v_trunk.reward_group := v_lottery_detail.reward_group;

         -- ���䡱��
         v_trunk.trunk_no := v_array_lottery.trunk_no;

         -- ���䡱��ʼ��������
         v_trunk.package_no_start := v_lottery_detail.package_no;

         -- ���䡱������������
         v_trunk.package_no_end := v_lottery_detail.package_no_e;

         -- ��չ���䡱����
         v_insert_trunks.extend;
         v_trunk_count := v_trunk_count + 1;
         v_insert_trunks(v_trunk_count) := v_trunk;

         -- ������Ƿ��Ѿ����
         if f_check_trunk(p_plan, p_batch, v_trunk.trunk_no) then
            rollback;
            c_errorcode := 26;
            c_errormesg := dbtool.format_line(v_array_lottery.trunk_no) || error_msg.err_p_batch_inbound_1; -- �����Ѿ����
            return;
         end if;

         -- �����м��У���ÿ�б�ţ������������������
         for v_loop_i in 1 .. to_number(v_collect_batch_param.boxes_every_trunk) loop

            -- ���С��ġ��䡱��
            v_box.trunk_no := v_array_lottery.trunk_no;

            -- ����
            v_box.reward_group := v_trunk.reward_group;

            -- ���С��ġ��С���
            v_box.box_no := v_array_lottery.trunk_no || '-' || lpad(v_loop_i, epublisher_sjz.len_box, '0');

            -- ���С��Ŀ�ʼ��������
            v_box.package_no_start := lpad(to_number(v_trunk.package_no_start) + v_packs_every_box * (v_loop_i - 1), epublisher_sjz.len_package, '0');
            v_box.package_no_end   := lpad(v_box.package_no_start + v_packs_every_box - 1, epublisher_sjz.len_package, '0');

            -- ��չ���С�����
            v_insert_boxes.extend;
            v_box_count := v_box_count + 1;
            v_insert_boxes(v_box_count) := v_box;

            -- ��䡰��������
            for v_loop_j in 1 .. v_packs_every_box loop
               -- �������ġ��䡱��
               v_pack.trunk_no := v_array_lottery.trunk_no;

               -- ����
               v_pack.reward_group := v_trunk.reward_group;

               -- �������ġ��С���
               v_pack.box_no := v_box.box_no;

               -- ��������
               v_pack.package_no := lpad(to_number(v_box.package_no_start) + v_loop_j - 1, epublisher_sjz.len_package, '0');

               -- �������Ŀ�ʼƱ��
               v_pack.ticket_no_start := epublisher_sjz.ticket_start;

               -- �������Ľ���Ʊ��
               v_pack.ticket_no_end := epublisher_sjz.ticket_start + v_collect_batch_param.tickets_every_pack - 1;

               -- ��չ����������
               v_insert_packs.extend;
               v_pack_count := v_pack_count + 1;
               v_insert_packs(v_pack_count) := v_pack;
            end loop;
         end loop;
      end if;
   end loop;

   -- ���롰�䡱����
   forall v_loop_i in 1 .. v_trunk_count
      insert into wh_ticket_trunk
         (plan_code,                                  batch_no,                                    reward_group,
          trunk_no,                                   package_no_start,                            package_no_end,
          current_warehouse,                          create_admin)
      values
         (p_plan,                                     p_batch,                                     v_insert_trunks(v_loop_i).reward_group,
          v_insert_trunks(v_loop_i).trunk_no,         v_insert_trunks(v_loop_i).package_no_start,  v_insert_trunks(v_loop_i).package_no_end,
          p_warehouse,                                p_oper);

   /************************************************************************************/
   /******************* ���롰�С����ݣ�����ȡ�������ͳ��ֵ *************************/

   -- �롰�С�������
   for v_list_count in 1 .. v_format_lotterys.count loop
      v_array_lottery := v_format_lotterys(v_list_count);
      -- ��ϸΪ ���䡱����Ҫ�� �䡢�С��� �϶������¼
      if v_array_lottery.valid_number = evalid_number.box then
         -- ��ȡ��Ʊ����ϸ����
         v_lottery_detail := f_get_lottery_info(p_plan, p_batch, v_array_lottery.valid_number, v_array_lottery.box_no);

         /******************* �����С���Ӧ�ġ��䡱��������䡱���ڣ���ûʲô�������Ҫ�����������ġ��䡱 *****************/
         -- ��ȡ���䡱��
         v_trunk.trunk_no := v_lottery_detail.trunk_no;

         -- ���㡰�䡱�Ľ�����
         v_trunk.reward_group := v_lottery_detail.reward_group;

         -- �������Ƿ���ڣ�����������롰�䡱
         select count(*) into v_count
           from dual
          where exists(
                        select 1 from wh_ticket_trunk
                         where trunk_no = v_trunk.trunk_no
                           and plan_code = p_plan
                           and batch_no = p_batch);
         if v_count = 0 then
            -- ���㡰�䡱�Ŀ�ʼ��������
            v_trunk.package_no_start := lpad((to_number(v_trunk.trunk_no) - 1) * v_collect_batch_param.packs_every_trunk + 1, epublisher_sjz.len_package, '0');

            -- ���㡰�䡱�Ľ�����������
            v_trunk.package_no_end := lpad((to_number(v_trunk.trunk_no)) * v_collect_batch_param.packs_every_trunk, epublisher_sjz.len_package, '0');

            -- �����¼
            insert into wh_ticket_trunk
               (plan_code,          batch_no,                  reward_group,
                trunk_no,           package_no_start,          package_no_end,
                current_warehouse,  create_admin,              is_full)
            values
               (p_plan,             p_batch,                   v_trunk.reward_group,
                v_trunk.trunk_no,   v_trunk.package_no_start,  v_trunk.package_no_end,
                p_warehouse,        p_oper,                    eboolean.noordisabled);
         end if;

         -- ���С��ġ��䡱��
         v_box.trunk_no := v_trunk.trunk_no;

         -- ����
         v_box.reward_group := v_trunk.reward_group;

         -- ���С��ġ��С���
         v_box.box_no := v_array_lottery.box_no;

         -- ���С��Ŀ�ʼ��������
         v_box.package_no_start := v_lottery_detail.package_no;
         v_box.package_no_end   := v_lottery_detail.package_no_e;

         -- ��չ���С�����
         v_insert_boxes.extend;
         v_box_count := v_box_count + 1;
         v_insert_boxes(v_box_count) := v_box;

         -- ��䡰��������
         for v_loop_j in 1 .. v_packs_every_box loop
            -- �������ġ��䡱��
            v_pack.trunk_no := v_box.trunk_no;

            -- ����
            v_pack.reward_group := v_box.reward_group;

            -- �������ġ��С���
            v_pack.box_no := v_box.box_no;

            -- ��������
            v_pack.package_no := lpad(to_number(v_box.package_no_start) + v_loop_j - 1, epublisher_sjz.len_package, '0');

            -- �������Ŀ�ʼƱ��
            v_pack.ticket_no_start := epublisher_sjz.ticket_start;

            -- �������Ľ���Ʊ��
            v_pack.ticket_no_end := epublisher_sjz.ticket_start + v_collect_batch_param.tickets_every_pack - 1;

            -- ��չ����������
            v_insert_packs.extend;
            v_pack_count := v_pack_count + 1;
            v_insert_packs(v_pack_count) := v_pack;
         end loop;
      end if;
   end loop;

   -- ���롰�С�����
   forall v_loop_i in 1 .. v_box_count
      insert into wh_ticket_box
         (plan_code,                               batch_no,                        reward_group,
          trunk_no,                                box_no,                          package_no_start,
          package_no_end,                          current_warehouse,               create_admin)
      values
         (p_plan,                                  p_batch,                         v_insert_boxes(v_loop_i).reward_group,
          v_insert_boxes(v_loop_i).trunk_no,       v_insert_boxes(v_loop_i).box_no, v_insert_boxes(v_loop_i).package_no_start,
          v_insert_boxes(v_loop_i).package_no_end, p_warehouse,                     p_oper);

   /************************************************************************************/
   /******************* ���롰�������ݣ�����ȡ�������ͳ��ֵ *************************/
   for v_list_count in 1 .. v_format_lotterys.count loop
      v_array_lottery := v_format_lotterys(v_list_count);
      if v_array_lottery.valid_number = evalid_number.pack then
         -- ��ȡ��Ʊ����ϸ����
         v_lottery_detail := f_get_lottery_info(p_plan, p_batch, v_array_lottery.valid_number, v_array_lottery.package_no);

         /*- ��ϸΪ ����������Ҫ������� �䡢�С��� �ϲ����¼
          * ����Ӧ����ȷ�������ı�ţ�Ӧ�ò�����ǰ�����������䡱�а�����ͬʱҲ�����ڷ������䡱�������С��а�����������ְ������������ݴ���
          * Ȼ����㡰�������ں͡��䡱�����С�������д������
         */

         -- ���㡰�������ڵġ��䡱�š����С��źͽ�����
         v_pack.trunk_no := v_lottery_detail.trunk_no;
         v_pack.box_no := v_lottery_detail.box_no;
         v_pack.reward_group := v_lottery_detail.reward_group;

         -- �鿴���䡱�Ƿ���ڣ������ڣ������ӣ�insert������ʱ�����ӵļ�¼�����Ƿ�������Ӧ��Ϊ����
         select count(*) into v_count
           from dual
          where exists(
                        select 1 from wh_ticket_trunk
                         where trunk_no = v_pack.trunk_no
                           and plan_code = p_plan
                           and batch_no = p_batch);
         if v_count = 0 then
            -- ���㡰�䡱�Ŀ�ʼ��������
            v_trunk.package_no_start := lpad((to_number(v_pack.trunk_no) - 1) * v_collect_batch_param.packs_every_trunk + 1, epublisher_sjz.len_package, '0') ;

            -- ���㡰�䡱�Ľ�����������
            v_trunk.package_no_end := lpad((to_number(v_pack.trunk_no)) * v_collect_batch_param.packs_every_trunk, epublisher_sjz.len_package, '0') ;

            -- �����¼
            insert into wh_ticket_trunk
               (plan_code,          batch_no,                  reward_group,
                trunk_no,           package_no_start,          package_no_end,
                current_warehouse,  create_admin,              is_full)
            values
               (p_plan,             p_batch,                   v_pack.reward_group,
                v_pack.trunk_no,    v_trunk.package_no_start,  v_trunk.package_no_end,
                p_warehouse,        p_oper,                    eboolean.noordisabled);
         end if;


         -- �鿴���С��Ƿ���ڣ������ڣ������ӣ�insert������ʱ�����ӵļ�¼�����Ƿ�������Ӧ��Ϊ����
         select count(*) into v_count
           from dual
          where exists(
                        select 1 from wh_ticket_box
                         where box_no = v_pack.box_no
                           and plan_code = p_plan
                           and batch_no = p_batch);
         if v_count = 0 then
            -- ���㡰�䡱�Ŀ�ʼ��������
            v_trunk.package_no_start := lpad((to_number(v_pack.trunk_no) - 1) * v_collect_batch_param.packs_every_trunk + 1, epublisher_sjz.len_package, '0') ;

            -- ���㡰�С��Ŀ�ʼ��������
            v_box.package_no_start := lpad(to_number(v_trunk.package_no_start) + (to_number(substr(v_pack.box_no, 7, 2)) - 1) * v_packs_every_box, epublisher_sjz.len_package, '0') ;

            -- ���㡰�С��Ľ�����������
            v_box.package_no_end := lpad(v_box.package_no_start + v_packs_every_box - 1, epublisher_sjz.len_package, '0') ;

            -- �����¼
            insert into wh_ticket_box
               (plan_code,          batch_no,                  reward_group,
                trunk_no,           package_no_start,          package_no_end,
                current_warehouse,  create_admin,              is_full,
                box_no)
            values
               (p_plan,             p_batch,                   v_pack.reward_group,
                v_pack.trunk_no,    v_box.package_no_start,    v_box.package_no_end,
                p_warehouse,        p_oper,                    eboolean.noordisabled,
                v_pack.box_no);
         end if;

         -- ��������
         v_pack.package_no := v_array_lottery.package_no;

         -- �������Ŀ�ʼƱ��
         v_pack.ticket_no_start := epublisher_sjz.ticket_start;

         -- �������Ľ���Ʊ��
         v_pack.ticket_no_end := epublisher_sjz.ticket_start + v_collect_batch_param.tickets_every_pack - 1;

         -- ��չ����������
         v_insert_packs.extend;
         v_pack_count := v_pack_count + 1;
         v_insert_packs(v_pack_count) := v_pack;

      end if;
   end loop;

   -- ���롰��������
   forall v_loop_i in 1 .. v_pack_count
      insert into wh_ticket_package
         (plan_code,                                  batch_no,                                 reward_group,
          trunk_no,                                   box_no,                                   package_no,
          ticket_no_start,                            ticket_no_end,                            current_warehouse,               create_admin)
      values
         (p_plan,                                     p_batch,                                  v_insert_packs(v_loop_i).reward_group,
          v_insert_packs(v_loop_i).trunk_no,          v_insert_packs(v_loop_i).box_no,          v_insert_packs(v_loop_i).package_no,
          v_insert_packs(v_loop_i).ticket_no_start,   v_insert_packs(v_loop_i).ticket_no_end,   p_warehouse,                     p_oper);

   -- ͳ��Ʊ��
   v_total_tickets := v_pack_count * v_collect_batch_param.tickets_every_pack;



   /****************************************************************************/
   /******************* �жϲ������͡�����͸������� ***************************/
   case
      when p_oper_type = 1 then
         -- ������������⡱��¼
         insert into wh_batch_inbound
           (bi_no,                      plan_code,                                  batch_no,
            create_admin,               batch_tickets,                              batch_amount,
            act_tickets,                act_amount,
            trunks,                     boxes,                                      packages)
         values
           (f_get_wh_batch_inbound_seq, p_plan,                                     p_batch,
            p_oper,                     v_collect_batch_param.tickets_every_batch,  v_collect_batch_param.tickets_every_batch * v_single_ticket_amount,
            v_total_tickets,            v_total_tickets * v_single_ticket_amount,
            v_scan_count_trunk,         v_scan_count_box,                           v_scan_count_pack)
         returning
            bi_no
         into
            v_bi_no;

         insert into wh_goods_receipt
            (sgr_no,                                                             receive_wh,                                  create_admin,
             receipt_amount,                                                     receipt_tickets,
             act_receipt_amount,                                                 act_receipt_tickets,                         receipt_type,        ref_no)
         values
            (f_get_wh_goods_receipt_seq,                                         p_warehouse,                                 p_oper,
             v_collect_batch_param.tickets_every_batch * v_single_ticket_amount, v_collect_batch_param.tickets_every_batch,
             v_total_tickets * v_single_ticket_amount,                           v_total_tickets,                             ereceipt_type.batch, v_bi_no)
         returning
            sgr_no
         into
            v_sgr_no;

      when p_oper_type = 2 then
         update wh_batch_inbound
            set act_tickets = act_tickets + v_total_tickets,
                act_amount = act_amount + v_total_tickets * v_single_ticket_amount,
                trunks = trunks + v_scan_count_trunk,
                boxes = boxes + v_scan_count_box,
                packages = packages + v_scan_count_pack
          where bi_no = p_inbound_no
         returning
                bi_no
           into
                v_bi_no;

         update wh_goods_receipt
            set act_receipt_amount = act_receipt_amount + v_total_tickets * v_single_ticket_amount,
                act_receipt_tickets = act_receipt_tickets + v_total_tickets
          where ref_no = p_inbound_no
                returning sgr_no into v_sgr_no;
   end case;

   if p_oper_type in (1, 2) then
      -- ���� �����ϸ
      p_lottery_detail_stat(v_format_lotterys, v_detail_list, v_stat_list, v_total_tickets, v_total_amount);

      v_insert_detail := type_detail();
      for v_loop_i in 1 .. v_detail_list.count loop
         v_insert_detail.extend;
         v_insert_detail(v_loop_i).sgr_no := v_sgr_no;
         v_insert_detail(v_loop_i).ref_no := v_bi_no;
         v_insert_detail(v_loop_i).sequence_no := f_get_wh_goods_receipt_det_seq;
         v_insert_detail(v_loop_i).receipt_type := ereceipt_type.batch;
         v_insert_detail(v_loop_i).create_admin := p_oper;
         v_insert_detail(v_loop_i).create_date := sysdate;

         v_insert_detail(v_loop_i).valid_number := v_detail_list(v_loop_i).valid_number;
         v_insert_detail(v_loop_i).plan_code := v_detail_list(v_loop_i).plan_code;
         v_insert_detail(v_loop_i).batch_no := v_detail_list(v_loop_i).batch_no;
         v_insert_detail(v_loop_i).amount := v_detail_list(v_loop_i).amount;
         v_insert_detail(v_loop_i).trunk_no := v_detail_list(v_loop_i).trunk_no;
         v_insert_detail(v_loop_i).box_no := v_detail_list(v_loop_i).box_no;
         v_insert_detail(v_loop_i).package_no := v_detail_list(v_loop_i).package_no;
         v_insert_detail(v_loop_i).tickets := v_detail_list(v_loop_i).tickets;
      end loop;

      forall v_loop_i in 1 .. v_insert_detail.count
         insert into wh_goods_receipt_detail values v_insert_detail(v_loop_i);
   end if;

   if p_oper_type = 1 then
      c_inbound_no := v_bi_no;
   end if;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
