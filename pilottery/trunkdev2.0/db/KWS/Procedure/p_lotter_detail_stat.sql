create or replace procedure p_lottery_detail_stat
/***************************************************************************/
------------- 统计入库或者出库的彩票明细，并生成入库明细数组 ----------------
/***************************************************************************/
(
 --------------输入----------------
   p_array_lotterys                   in type_lottery_list,                 -- 待查询的彩票对象

 ---------出口参数---------
   c_detail_list                      out type_lottery_detail_list,         -- 明细
   c_stat_list                        out type_lottery_statistics_list,     -- 按照方案和批次统计的金额和票数
   c_total_tickets                    out number,                           -- 总票数
   c_total_amount                     out number                            -- 总金额

 ) is

   v_detail                type_lottery_detail_info;                       -- 单条明细
   v_collect_batch_param   game_batch_import_detail%rowtype;               -- 批次参数
   v_stat_info             type_lottery_statistics_info;                   -- 单条统计信息
   v_found                 boolean;                                        -- 是否已经存在统计信息

   v_array_lottery         type_lottery_info;                              -- 单张彩票
   v_lottery_detail        type_lottery_info;                              -- 彩票对象详细信息
   v_single_ticket_amount  number(10);                                     -- 每张票的价格
   v_packs_every_box       number(10);                                     -- 每“盒”中包含多少“本”

   v_loop_i                number(10);                                     -- 循环使用的参数

begin

   -- 初始化数组
   c_detail_list := type_lottery_detail_list();
   c_stat_list := type_lottery_statistics_list();
   v_detail := type_lottery_detail_info(null,null,null,null,null,null,null,null);
   v_stat_info := type_lottery_statistics_info(null,null,null,null,null,null,null);
   c_total_tickets := 0;
   c_total_amount := 0;

   -- 循环处理明细数据，统计入库票数据
   for v_list_count in 1 .. p_array_lotterys.count loop
      v_array_lottery := p_array_lotterys(v_list_count);

      -- 判断期次和批次是否为空
      if v_array_lottery.plan_code is null or v_array_lottery.batch_no is null then
         raise_application_error(-20001, dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || error_msg.err_common_108);
      end if;

      -- 获取保存的参数
      select * into v_collect_batch_param from game_batch_import_detail where plan_code = v_array_lottery.plan_code and batch_no = v_array_lottery.batch_no;

      -- 获取单张票金额
      select ticket_amount into v_single_ticket_amount from game_plans where plan_code = v_array_lottery.plan_code;

      -- 每“盒”中包含多少“本”
      v_packs_every_box := v_collect_batch_param.packs_every_trunk / v_collect_batch_param.boxes_every_trunk;

      case
         when v_array_lottery.valid_number = evalid_number.trunk then
            -- 获取彩票对象的详细信息
            v_lottery_detail := f_get_lottery_info(v_array_lottery.plan_code, v_array_lottery.batch_no, v_array_lottery.valid_number, v_array_lottery.trunk_no);

            -- 明细数组中，记录相应数据
            v_detail.trunk_no := v_array_lottery.trunk_no;
            v_detail.box_no := '-';
            v_detail.package_no := '-';
            v_detail.tickets := v_collect_batch_param.packs_every_trunk * v_collect_batch_param.tickets_every_pack;

         when v_array_lottery.valid_number = evalid_number.box then
            -- 获取彩票对象的详细信息
            v_lottery_detail := f_get_lottery_info(v_array_lottery.plan_code, v_array_lottery.batch_no, v_array_lottery.valid_number, v_array_lottery.box_no);

            -- 明细数组中，记录相应数据
            v_detail.trunk_no := v_lottery_detail.trunk_no;
            v_detail.box_no := v_array_lottery.box_no;
            v_detail.package_no := '-';
            v_detail.tickets := v_packs_every_box * v_collect_batch_param.tickets_every_pack;

         when v_array_lottery.valid_number = evalid_number.pack then
            -- 获取彩票对象的详细信息
            v_lottery_detail := f_get_lottery_info(v_array_lottery.plan_code, v_array_lottery.batch_no, v_array_lottery.valid_number, v_array_lottery.package_no);

            -- 明细数组中，记录相应数据
            v_detail.trunk_no := v_lottery_detail.trunk_no;
            v_detail.box_no := v_lottery_detail.box_no;
            v_detail.package_no := v_array_lottery.package_no;
            v_detail.tickets := v_collect_batch_param.tickets_every_pack;


      end case;

      -- 填充公用字段
      v_detail.valid_number := v_array_lottery.valid_number;
      v_detail.plan_code := v_array_lottery.plan_code;
      v_detail.batch_no := v_array_lottery.batch_no;
      v_detail.amount := v_detail.tickets * v_single_ticket_amount;
      v_detail.plan_code := v_array_lottery.plan_code;
      v_detail.batch_no := v_array_lottery.batch_no;

      -- 扩展数组
      c_detail_list.extend;
      c_detail_list(c_detail_list.count) := v_detail;

      -- 记录统计值
      c_total_tickets := c_total_tickets + v_detail.tickets;
      c_total_amount := c_total_amount + v_detail.tickets * v_single_ticket_amount;

      -- 以方案和期次统计
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

   -- 检查这些票所对应的方案是否有效
   for v_loop_i in 1 .. c_stat_list.count loop
      if not f_check_plan_batch_status(v_stat_info.plan_code, v_stat_info.batch_no) then
         raise_application_error(-20001, dbtool.format_line(v_stat_info.plan_code) || dbtool.format_line(v_stat_info.batch_no) || error_msg.err_common_107);
      end if;
   end loop;

end;
