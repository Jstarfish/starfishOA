create or replace function f_get_lottery_info
------------------- �����ڻ�ȡ��Ʊ����ĸ�����Ϣ-----------------------------
   -- add by ���� @ 2015/9/19
   -- ���� ���䡱���С�����������ָ�����ε� ���䡱���С���ʼ����������������������
   -- �������
   --    1������
   --    2������
   --    3����Чλ��
   --    4������
/********************************************************************************/
(
   p_plan              in char,                -- ����
   p_batch             in char,                -- ����
   p_valid_number      in number,              -- ��Чλ��
   p_value             in char                 -- ���䡱���С�����������
)
return type_lottery_info
is
   v_collect_batch_param   game_batch_import_detail%rowtype;               -- ���β���
   v_plan_publish          number(1);                                      -- ӡ�Ƴ��̱��
   v_box_number            number(9);                                      -- �ڼ���
   v_packs_every_box       number(10);                                     -- ÿ���С��а������١�����
   v_tickets_every_trunk   number(10);                                     -- ÿ���䡱Ʊ��
   v_rtv                   type_lottery_info;                              -- ����ֵ

begin
   v_rtv := type_lottery_info(p_plan,p_batch,p_valid_number,null,null,null,null,null,null);

   -- ��ȡӡ�Ƴ�����Ϣ
   select plan_flow
     into v_plan_publish
     from inf_publishers
    where publisher_code =
          (select publisher_code from game_plans where plan_code = p_plan);

   -- ��ȡ����Ĳ���
   select * into v_collect_batch_param from game_batch_import_detail where plan_code = p_plan and batch_no = p_batch;

   -- ÿ���С��а������١�����
   v_packs_every_box := v_collect_batch_param.packs_every_trunk / v_collect_batch_param.boxes_every_trunk;
   v_tickets_every_trunk := v_collect_batch_param.packs_every_trunk * v_collect_batch_param.tickets_every_pack;

   -- У������Ĳ�������
   case
      when p_valid_number = evalid_number.trunk then
         if to_number(p_value) > v_collect_batch_param.tickets_every_batch / v_collect_batch_param.packs_every_trunk / v_collect_batch_param.tickets_every_pack then
            raise_application_error(-20001, dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || dbtool.format_line(p_value) || error_msg.err_f_get_lottery_info_1);  -- ����ġ��䡱�ų����Ϸ��ķ�Χ
         end if;
      when p_valid_number = evalid_number.box then
         v_box_number := substr(p_value, epublisher_sjz.len_trunk + 2, epublisher_sjz.len_box);
         if v_box_number > v_collect_batch_param.packs_every_trunk / v_packs_every_box then
            raise_application_error(-20001, dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || dbtool.format_line(p_value) || error_msg.err_f_get_lottery_info_2);  -- ����ġ��С��ų����Ϸ��ķ�Χ
         end if;
      when p_valid_number = evalid_number.pack then
         if to_number(p_value) > v_collect_batch_param.tickets_every_batch / v_collect_batch_param.tickets_every_pack then
            raise_application_error(-20001, dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || dbtool.format_line(p_value) || error_msg.err_f_get_lottery_info_3);  -- ����ġ������ų����Ϸ��ķ�Χ
         end if;
   end case;

   -- ����
   case
      when p_valid_number = evalid_number.trunk then
         v_rtv.trunk_no := p_value;
         v_rtv.box_no := p_value || '-' || lpad(1, epublisher_sjz.len_box, '0');
         v_rtv.box_no_e := p_value || '-' || lpad(to_number(v_collect_batch_param.boxes_every_trunk), epublisher_sjz.len_box, '0');
         v_rtv.package_no := lpad((to_number(p_value) - 1) * v_collect_batch_param.packs_every_trunk + 1, epublisher_sjz.len_package, '0');
         v_rtv.package_no_e := lpad(to_number(p_value) * v_collect_batch_param.packs_every_trunk, epublisher_sjz.len_package, '0');

      when p_valid_number = evalid_number.box then
         v_rtv.trunk_no := substr(p_value, 1, epublisher_sjz.len_trunk);
         v_box_number := substr(p_value, epublisher_sjz.len_trunk + 2, epublisher_sjz.len_box);
         v_rtv.box_no := p_value;
         v_rtv.package_no := lpad((to_number(v_rtv.trunk_no) - 1) * v_collect_batch_param.packs_every_trunk + v_packs_every_box * (v_box_number - 1) + 1, epublisher_sjz.len_package, '0');
         v_rtv.package_no_e := lpad(to_number(v_rtv.package_no) + v_packs_every_box - 1, epublisher_sjz.len_package, '0');

      when p_valid_number = evalid_number.pack then
         v_rtv.trunk_no := lpad(ceil(p_value / v_collect_batch_param.packs_every_trunk), epublisher_sjz.len_trunk, '0');
         v_rtv.box_no := v_rtv.trunk_no || '-' || lpad(ceil((to_number(p_value) - (to_number(v_rtv.trunk_no) - 1) * v_collect_batch_param.PACKS_EVERY_TRUNK) / v_packs_every_box), epublisher_sjz.len_box, '0');
         v_rtv.package_no := p_value;

   end case;

   -- ���㽱��
   v_rtv.reward_group := ceil(to_number(v_rtv.trunk_no) * (v_collect_batch_param.PACKS_EVERY_TRUNK * v_collect_batch_param.TICKETS_EVERY_PACK) / (v_collect_batch_param.tickets_every_group));

   return v_rtv;

end;
