create or replace procedure p_lottery_detail_stat
/***************************************************************************/
------------- ͳ�������߳���Ĳ�Ʊ��ϸ�������������ϸ���� ----------------
/***************************************************************************/
(
 --------------����----------------
   p_array_lotterys                   in type_lottery_list,                 -- ����ѯ�Ĳ�Ʊ����

 ---------���ڲ���---------
   c_detail_list                      out type_lottery_detail_list,         -- ��ϸ
   c_stat_list                        out type_lottery_statistics_list,     -- ���շ���������ͳ�ƵĽ���Ʊ��
   c_total_tickets                    out number,                           -- ��Ʊ��
   c_total_amount                     out number                            -- �ܽ��

 ) is

   v_detail                type_lottery_detail_info;                       -- ������ϸ
   v_collect_batch_param   game_batch_import_detail%rowtype;               -- ���β���
   v_stat_info             type_lottery_statistics_info;                   -- ����ͳ����Ϣ
   v_found                 boolean;                                        -- �Ƿ��Ѿ�����ͳ����Ϣ

   v_array_lottery         type_lottery_info;                              -- ���Ų�Ʊ
   v_lottery_detail        type_lottery_info;                              -- ��Ʊ������ϸ��Ϣ
   v_single_ticket_amount  number(10);                                     -- ÿ��Ʊ�ļ۸�
   v_packs_every_box       number(10);                                     -- ÿ���С��а������١�����

   v_loop_i                number(10);                                     -- ѭ��ʹ�õĲ���

begin

   -- ��ʼ������
   c_detail_list := type_lottery_detail_list();
   c_stat_list := type_lottery_statistics_list();
   v_detail := type_lottery_detail_info(null,null,null,null,null,null,null,null);
   v_stat_info := type_lottery_statistics_info(null,null,null,null,null,null,null);
   c_total_tickets := 0;
   c_total_amount := 0;

   -- ѭ��������ϸ���ݣ�ͳ�����Ʊ����
   for v_list_count in 1 .. p_array_lotterys.count loop
      v_array_lottery := p_array_lotterys(v_list_count);

      -- �ж��ڴκ������Ƿ�Ϊ��
      if v_array_lottery.plan_code is null or v_array_lottery.batch_no is null then
         raise_application_error(-20001, dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || error_msg.err_common_108);
      end if;

      -- ��ȡ����Ĳ���
      select * into v_collect_batch_param from game_batch_import_detail where plan_code = v_array_lottery.plan_code and batch_no = v_array_lottery.batch_no;

      -- ��ȡ����Ʊ���
      select ticket_amount into v_single_ticket_amount from game_plans where plan_code = v_array_lottery.plan_code;

      -- ÿ���С��а������١�����
      v_packs_every_box := v_collect_batch_param.packs_every_trunk / v_collect_batch_param.boxes_every_trunk;

      case
         when v_array_lottery.valid_number = evalid_number.trunk then
            -- ��ȡ��Ʊ�������ϸ��Ϣ
            v_lottery_detail := f_get_lottery_info(v_array_lottery.plan_code, v_array_lottery.batch_no, v_array_lottery.valid_number, v_array_lottery.trunk_no);

            -- ��ϸ�����У���¼��Ӧ����
            v_detail.trunk_no := v_array_lottery.trunk_no;
            v_detail.box_no := '-';
            v_detail.package_no := '-';
            v_detail.tickets := v_collect_batch_param.packs_every_trunk * v_collect_batch_param.tickets_every_pack;

         when v_array_lottery.valid_number = evalid_number.box then
            -- ��ȡ��Ʊ�������ϸ��Ϣ
            v_lottery_detail := f_get_lottery_info(v_array_lottery.plan_code, v_array_lottery.batch_no, v_array_lottery.valid_number, v_array_lottery.box_no);

            -- ��ϸ�����У���¼��Ӧ����
            v_detail.trunk_no := v_lottery_detail.trunk_no;
            v_detail.box_no := v_array_lottery.box_no;
            v_detail.package_no := '-';
            v_detail.tickets := v_packs_every_box * v_collect_batch_param.tickets_every_pack;

         when v_array_lottery.valid_number = evalid_number.pack then
            -- ��ȡ��Ʊ�������ϸ��Ϣ
            v_lottery_detail := f_get_lottery_info(v_array_lottery.plan_code, v_array_lottery.batch_no, v_array_lottery.valid_number, v_array_lottery.package_no);

            -- ��ϸ�����У���¼��Ӧ����
            v_detail.trunk_no := v_lottery_detail.trunk_no;
            v_detail.box_no := v_lottery_detail.box_no;
            v_detail.package_no := v_array_lottery.package_no;
            v_detail.tickets := v_collect_batch_param.tickets_every_pack;


      end case;

      -- ��乫���ֶ�
      v_detail.valid_number := v_array_lottery.valid_number;
      v_detail.plan_code := v_array_lottery.plan_code;
      v_detail.batch_no := v_array_lottery.batch_no;
      v_detail.amount := v_detail.tickets * v_single_ticket_amount;
      v_detail.plan_code := v_array_lottery.plan_code;
      v_detail.batch_no := v_array_lottery.batch_no;

      -- ��չ����
      c_detail_list.extend;
      c_detail_list(c_detail_list.count) := v_detail;

      -- ��¼ͳ��ֵ
      c_total_tickets := c_total_tickets + v_detail.tickets;
      c_total_amount := c_total_amount + v_detail.tickets * v_single_ticket_amount;

      -- �Է������ڴ�ͳ��
      v_found := false;
      for v_loop_i in 1 .. c_stat_list.count loop
         if c_stat_list(v_loop_i).plan_code = v_detail.plan_code and c_stat_list(v_loop_i).batch_no = v_detail.batch_no then
            v_found := true;
            c_stat_list(v_loop_i).tickets := c_stat_list(v_loop_i).tickets + v_detail.tickets;
            c_stat_list(v_loop_i).amount := c_stat_list(v_loop_i).amount + v_detail.tickets * v_single_ticket_amount;

            case
               when v_array_lottery.valid_number = evalid_number.trunk then
                  c_stat_list(v_loop_i).trunks := c_stat_list(v_loop_i).trunks + 1;

               when v_array_lottery.valid_number = evalid_number.box then
                  c_stat_list(v_loop_i).boxes := c_stat_list(v_loop_i).boxes + 1;

               when v_array_lottery.valid_number = evalid_number.pack then
                  c_stat_list(v_loop_i).packages := c_stat_list(v_loop_i).packages + 1;

            end case;

         end if;
      end loop;
      if not v_found then
         v_stat_info.plan_code := v_array_lottery.plan_code;
         v_stat_info.batch_no := v_array_lottery.batch_no;
         v_stat_info.tickets := v_detail.tickets;
         v_stat_info.amount := v_detail.amount;
         case
            when v_array_lottery.valid_number = evalid_number.trunk then
               v_stat_info.trunks := 1;
               v_stat_info.boxes := 0;
               v_stat_info.packages := 0;

            when v_array_lottery.valid_number = evalid_number.box then
               v_stat_info.trunks := 0;
               v_stat_info.boxes := 1;
               v_stat_info.packages := 0;

            when v_array_lottery.valid_number = evalid_number.pack then
               v_stat_info.trunks := 0;
               v_stat_info.boxes := 0;
               v_stat_info.packages := 1;

         end case;

         c_stat_list.extend;
         c_stat_list(c_stat_list.count) := v_stat_info;


      end if;
   end loop;

   -- �����ЩƱ����Ӧ�ķ����Ƿ���Ч
   for v_loop_i in 1 .. c_stat_list.count loop
      if not f_check_plan_batch_status(v_stat_info.plan_code, v_stat_info.batch_no) then
         raise_application_error(-20001, dbtool.format_line(v_stat_info.plan_code) || dbtool.format_line(v_stat_info.batch_no) || error_msg.err_common_107);
      end if;
   end loop;

end;
