create or replace function f_get_lottery_info
------------------- 适用于获取彩票对象的各种信息-----------------------------
   -- add by 陈震 @ 2015/9/19
   -- 根据 “箱”“盒”“本”计算指定批次的 “箱”“盒”开始“本”、结束“本”号码
   -- 输入参数
   --    1、方案
   --    2、批次
   --    3、有效位数
   --    4、号码
/********************************************************************************/
(
   p_plan              in char,                -- 方案
   p_batch             in char,                -- 批次
   p_valid_number      in number,              -- 有效位数
   p_value             in char                 -- “箱”“盒”“本”号码
)
return type_lottery_info
is
   v_collect_batch_param   game_batch_import_detail%rowtype;               -- 批次参数
   v_plan_publish          number(1);                                      -- 印制厂商编号
   v_box_number            number(9);                                      -- 第几盒
   v_packs_every_box       number(10);                                     -- 每“盒”中包含多少“本”
   v_tickets_every_trunk   number(10);                                     -- 每“箱”票数
   v_rtv                   type_lottery_info;                              -- 返回值

begin
   v_rtv := type_lottery_info(p_plan,p_batch,p_valid_number,null,null,null,null,null,null);

   -- 获取印制厂商信息
   select plan_flow
     into v_plan_publish
     from inf_publishers
    where publisher_code =
          (select publisher_code from game_plans where plan_code = p_plan);

   -- 获取保存的参数
   select * into v_collect_batch_param from game_batch_import_detail where plan_code = p_plan and batch_no = p_batch;

   -- 每“盒”中包含多少“本”
   v_packs_every_box := v_collect_batch_param.packs_every_trunk / v_collect_batch_param.boxes_every_trunk;
   v_tickets_every_trunk := v_collect_batch_param.packs_every_trunk * v_collect_batch_param.tickets_every_pack;

   -- 校验输入的参数内容
   case
      when p_valid_number = evalid_number.trunk then
         if to_number(p_value) > v_collect_batch_param.tickets_every_batch / v_collect_batch_param.packs_every_trunk / v_collect_batch_param.tickets_every_pack then
            raise_application_error(-20001, dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || dbtool.format_line(p_value) || error_msg.err_f_get_lottery_info_1);  -- 输入的“箱”号超出合法的范围
         end if;
      when p_valid_number = evalid_number.box then
         v_box_number := substr(p_value, epublisher_sjz.len_trunk + 2, epublisher_sjz.len_box);
         if v_box_number > v_collect_batch_param.packs_every_trunk / v_packs_every_box then
            raise_application_error(-20001, dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || dbtool.format_line(p_value) || error_msg.err_f_get_lottery_info_2);  -- 输入的“盒”号超出合法的范围
         end if;
      when p_valid_number = evalid_number.pack then
         if to_number(p_value) > v_collect_batch_param.tickets_every_batch / v_collect_batch_param.tickets_every_pack then
            raise_application_error(-20001, dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || dbtool.format_line(p_value) || error_msg.err_f_get_lottery_info_3);  -- 输入的“本”号超出合法的范围
         end if;
   end case;

   -- 计算
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

   -- 计算奖组
   v_rtv.reward_group := ceil(to_number(v_rtv.trunk_no) * (v_collect_batch_param.PACKS_EVERY_TRUNK * v_collect_batch_param.TICKETS_EVERY_PACK) / (v_collect_batch_param.tickets_every_group));

   return v_rtv;

end;
