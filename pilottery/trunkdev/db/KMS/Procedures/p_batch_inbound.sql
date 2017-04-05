create or replace procedure p_batch_inbound
/****************************************************************/
   ------------------- 彩票批次入库 -------------------
   ---- 彩票入库。支持新入库，继续入库，入库完结。
   ----     新入库：  创建“批次入库”记录；创建入库单；按照传递的入库对象（箱、盒、包）记录彩票数据，同时也要在入库单明细中记录入库对象；
   ----     继续入库：按照传递的入库对象（箱、盒、包）更新彩票数据，同时也要在入库单明细中记录入库对象；更新批次入库记录，修改增加的彩票统计数据；
   ----     入库完结：按照传递的入库对象（箱、盒、包）更新彩票数据，同时也要在入库单明细中记录入库对象；更新批次入库记录，修改增加的彩票统计数据，完结批次入库状态。
   ---- add by 陈震: 2015/9/15
   ---- 涉及的业务表：
   ----     2.1.5.7 批次入库（wh_batch_inbound）
   ----     2.1.5.10 入库单（wh_goods_receipt）
   ----     2.1.5.11 入库单明细（wh_goods_receipt_detail）
   ----     2.1.5.3 即开票信息（箱）（wh_ticket_trunk）
   ----     2.1.5.4 即开票信息（盒）（wh_ticket_box）
   ----     2.1.5.5 即开票信息（本）（wh_ticket_package）
   ---- 业务流程：
   ----     1、校验输入参数。（方案、批次是否存在；仓库是否存在；操作类型是否为新、继续、完结；操作人是否合法；当操作类型是继续、完结时，需要检查批次入库单编号是否存在）
   ----     2、操作类型为“完结”时，更新 批次入库（wh_batch_inbound）、入库单（wh_goods_receipt），结束运行，返回。
   ----     3、获取已经保存的参数。（方案批次的包装信息-bulk方式获取；）
   ----     4、首先插入“即开票”表，同时统计插入的数据
   ----     5、判断操作类型。
   ----          新入库：    插入 批次入库（wh_batch_inbound）、入库单（wh_goods_receipt）
   ----          继续入库：  更新 批次入库（wh_batch_inbound）、入库单（wh_goods_receipt）
   ----                   以上两个操作，都需要 插入 “入库明细”

   /*************************************************************/
(
 --------------输入----------------
 p_inbound_no        in varchar2,            -- 批次入库单编号（新增情况下，忽略此参数，否则为必录项）
 p_plan              in char,                -- 方案
 p_batch             in char,                -- 批次
 p_warehouse         in char,                -- 仓库
 p_oper_type         in number,              -- 操作类型(1-新增，2-继续，3-完结)
 p_oper              in number,              -- 操作人
 p_array_lotterys    in type_lottery_list,   -- 入库的彩票对象

 ---------出口参数---------
 c_inbound_no out varchar2,
 c_errorcode out number,                     --错误编码
 c_errormesg out string                      --错误原因

 ) is

   v_count                 number(5);                                      -- 求记录数的临时变量
   v_collect_batch_param   game_batch_import_detail%rowtype;               -- 批次参数
   v_bi_no                 char(10);                                       -- 批次入库单编号(bi12345678)
   v_sgr_no                char(10);                                       -- 入库单编号（rk12345678）
   v_array_lottery         type_lottery_info;                              -- 单张彩票
   v_lottery_detail        type_lottery_info;                              -- 彩票对象详细信息
   v_format_lotterys       type_lottery_list;

   v_list_count            number(10);                                     -- 入库明细总数
   v_trunk_count           number(10);                                     -- 入库“箱”数
   v_box_count             number(10);                                     -- 入库“盒”数
   v_pack_count            number(10);                                     -- 入库“本”数
   v_scan_count_trunk      number(10);                                     -- 扫描的“箱”数
   v_scan_count_box        number(10);                                     -- 扫描的“盒”数
   v_scan_count_pack       number(10);                                     -- 扫描的“本”数

   type type_trunk         is table of wh_ticket_trunk%rowtype;
   type type_box           is table of wh_ticket_box%rowtype;
   type type_pack          is table of wh_ticket_package%rowtype;
   type type_detail        is table of wh_goods_receipt_detail%rowtype;
   v_insert_trunks         type_trunk;                                     -- 插入盒的数据
   v_insert_boxes          type_box;                                       -- 插入盒的数据
   v_insert_packs          type_pack;                                      -- 插入本的数组
   v_insert_detail         type_detail;                                    -- 插入入库明细的数组
   v_trunk                 wh_ticket_trunk%rowtype;
   v_box                   wh_ticket_box%rowtype;
   v_pack                  wh_ticket_package%rowtype;

   v_loop_i                number(10);                                     -- 循环使用的参数
   v_loop_j                number(10);                                     -- 循环使用的参数

   v_packs_every_box       number(10);                                     -- 每“盒”中包含多少“本”
   v_total_tickets         number(20);                                     -- 当此入库的总票数
   v_plan_publish          number(1);                                      -- 印制厂商编号
   v_single_ticket_amount  number(10);                                     -- 每张票的价格

   v_all_lottery_list      type_lottery_list;                              -- 拿去计算包含关系的数组

   v_detail_list           type_lottery_detail_list;                       -- 入库明细
   v_stat_list             type_lottery_statistics_list;                   -- 按照方案和批次统计的金额和票数
   v_total_amount          number(28);                                     -- 当此入库的总金额

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;

   if not f_check_warehouse(p_warehouse) then
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_warehouse) || error_msg.err_common_101; -- 无此仓库
      return;
   end if;

   if not f_check_plan_batch(p_plan,p_batch) then
      c_errorcode := 3;
      c_errormesg := dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || error_msg.err_common_102; -- 无此批次
      return;
   end if;

   if not p_oper_type in (1,2,3) then
      c_errorcode := 4;
      c_errormesg := dbtool.format_line(p_oper_type) || error_msg.err_p_batch_inbound_4; -- 操作类型参数错误，应该为1，2，3
      return;
   end if;

   if p_oper_type in (2,3) then
      select count(*) into v_count from dual where exists(select 1 from wh_batch_inbound where bi_no = p_inbound_no);
      if v_count = 0 then
         c_errorcode := 5;
         c_errormesg := dbtool.format_line(p_inbound_no) || error_msg.err_p_batch_inbound_5; -- 在进行继续入库和完结入库操作时，输入的批次入库单错误，未发现此批次入库单
         return;
      end if;
   end if;

   -- 继续入库时，判断是否已经完结
   if p_oper_type = 2 then
      select count(*) into v_count from dual where exists(select 1 from wh_goods_receipt where ref_no = p_inbound_no and status = ework_status.working);
      if v_count = 0 then
         c_errorcode := 6;
         c_errormesg := dbtool.format_line(p_inbound_no) || error_msg.err_p_batch_inbound_6; -- 在进行继续入库时，输入的批次入库单错误，或者此批次入库单已经完结
         return;
      end if;
   end if;
   /*----------- 业务逻辑   -----------------*/
   /**********************************************************/
   /******************* 获取参数信息 *************************/

   -- 获取印制厂商信息
   select plan_flow
     into v_plan_publish
     from inf_publishers
    where publisher_code =
          (select publisher_code from game_plans where plan_code = p_plan);

   -- 获取保存的参数
   select * into v_collect_batch_param from game_batch_import_detail where plan_code = p_plan and batch_no = p_batch;

   -- 获取单张票金额
   select ticket_amount into v_single_ticket_amount from game_plans where plan_code = p_plan;

   -- 初始化数组
   v_insert_trunks := type_trunk();
   v_insert_boxes  := type_box();
   v_insert_packs  := type_pack();
   v_trunk_count   := 0;
   v_box_count     := 0;
   v_pack_count    := 0;
   v_scan_count_trunk := 0;
   v_scan_count_box   := 0;
   v_scan_count_pack  := 0;

   -- 每“盒”中包含多少“本”
   v_packs_every_box := v_collect_batch_param.packs_every_trunk / v_collect_batch_param.boxes_every_trunk;

   /********************************************************************/
   /******************* 先处理完结入库这种情况 *************************/
   -- 完结入库：  更新 批次入库（wh_batch_inbound）、入库单（wh_goods_receipt）
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
   /******************* 检查输入的入库对象是否合法 *************************/
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
      -- 判断入库对象有没有与已经入库的内容重复，或者存在交叉的对象（例如：已经入整箱，再入箱中的一本彩票）
      select type_lottery_info(plan_code, batch_no, valid_number, trunk_no, box_no, '', package_no, '', 0)
        bulk collect into v_all_lottery_list
        from wh_goods_receipt_detail
       where sgr_no = (select sgr_no from wh_goods_receipt where ref_no = p_inbound_no);

      -- 合并当前数组
      v_all_lottery_list := v_all_lottery_list multiset union v_format_lotterys;

   else
      v_all_lottery_list := v_format_lotterys;

   end if;

   if f_check_ticket_perfect(v_all_lottery_list) then
      rollback;
      c_errorcode := 6;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_103; -- 彩票对象，存在“自包含”的情况
      return;
   end if;

   /************************************************************************************/
   /******************* 先入“箱”数据，并获取入库数据统计值 *************************/
   -- 先入“箱”数据
   for v_list_count in 1 .. v_format_lotterys.count loop
      v_array_lottery := v_format_lotterys(v_list_count);

      -- 统计扫描的对象
      case
         when v_array_lottery.valid_number = evalid_number.trunk then
            v_scan_count_trunk := v_scan_count_trunk + 1;

         when v_array_lottery.valid_number = evalid_number.box then
            v_scan_count_box := v_scan_count_box + 1;

         when v_array_lottery.valid_number = evalid_number.pack then
            v_scan_count_pack := v_scan_count_pack + 1;

      end case;

      -- 明细为 “箱”，需要在 箱、盒、本 上都插入记录
      if v_array_lottery.valid_number = evalid_number.trunk then
         -- 获取彩票的明细数据
         v_lottery_detail := f_get_lottery_info(p_plan, p_batch, v_array_lottery.valid_number, v_array_lottery.trunk_no);

         -- 计算奖组编号
         v_trunk.reward_group := v_lottery_detail.reward_group;

         -- “箱”号
         v_trunk.trunk_no := v_array_lottery.trunk_no;

         -- “箱”开始“本”号
         v_trunk.package_no_start := v_lottery_detail.package_no;

         -- “箱”结束“本”号
         v_trunk.package_no_end := v_lottery_detail.package_no_e;

         -- 扩展“箱”数组
         v_insert_trunks.extend;
         v_trunk_count := v_trunk_count + 1;
         v_insert_trunks(v_trunk_count) := v_trunk;

         -- 检查箱是否已经入库
         if f_check_trunk(p_plan, p_batch, v_trunk.trunk_no) then
            rollback;
            c_errorcode := 26;
            c_errormesg := dbtool.format_line(v_array_lottery.trunk_no) || error_msg.err_p_batch_inbound_1; -- 此箱已经入库
            return;
         end if;

         -- 计算有几盒，给每盒编号，并生成相关数组数据
         for v_loop_i in 1 .. to_number(v_collect_batch_param.boxes_every_trunk) loop

            -- “盒”的“箱”号
            v_box.trunk_no := v_array_lottery.trunk_no;

            -- 奖组
            v_box.reward_group := v_trunk.reward_group;

            -- “盒”的“盒”号
            v_box.box_no := v_array_lottery.trunk_no || '-' || lpad(v_loop_i, epublisher_sjz.len_box, '0');

            -- “盒”的开始“本”号
            v_box.package_no_start := lpad(to_number(v_trunk.package_no_start) + v_packs_every_box * (v_loop_i - 1), epublisher_sjz.len_package, '0');
            v_box.package_no_end   := lpad(v_box.package_no_start + v_packs_every_box - 1, epublisher_sjz.len_package, '0');

            -- 扩展“盒”数组
            v_insert_boxes.extend;
            v_box_count := v_box_count + 1;
            v_insert_boxes(v_box_count) := v_box;

            -- 填充“本”数据
            for v_loop_j in 1 .. v_packs_every_box loop
               -- “本”的“箱”号
               v_pack.trunk_no := v_array_lottery.trunk_no;

               -- 奖组
               v_pack.reward_group := v_trunk.reward_group;

               -- “本”的“盒”号
               v_pack.box_no := v_box.box_no;

               -- “本”号
               v_pack.package_no := lpad(to_number(v_box.package_no_start) + v_loop_j - 1, epublisher_sjz.len_package, '0');

               -- “本”的开始票号
               v_pack.ticket_no_start := epublisher_sjz.ticket_start;

               -- “本”的结束票号
               v_pack.ticket_no_end := epublisher_sjz.ticket_start + v_collect_batch_param.tickets_every_pack - 1;

               -- 扩展“本”数组
               v_insert_packs.extend;
               v_pack_count := v_pack_count + 1;
               v_insert_packs(v_pack_count) := v_pack;
            end loop;
         end loop;
      end if;
   end loop;

   -- 插入“箱”数据
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
   /******************* 再入“盒”数据，并获取入库数据统计值 *************************/

   -- 入“盒”的数据
   for v_list_count in 1 .. v_format_lotterys.count loop
      v_array_lottery := v_format_lotterys(v_list_count);
      -- 明细为 “箱”，需要在 箱、盒、本 上都插入记录
      if v_array_lottery.valid_number = evalid_number.box then
         -- 获取彩票的明细数据
         v_lottery_detail := f_get_lottery_info(p_plan, p_batch, v_array_lottery.valid_number, v_array_lottery.box_no);

         /******************* 处理“盒”对应的“箱”，如果“箱”存在，就没什么，否则就要不足这个虚拟的“箱” *****************/
         -- 获取“箱”号
         v_trunk.trunk_no := v_lottery_detail.trunk_no;

         -- 计算“箱”的奖组编号
         v_trunk.reward_group := v_lottery_detail.reward_group;

         -- 检查此箱是否存在，不存在则插入“箱”
         select count(*) into v_count
           from dual
          where exists(
                        select 1 from wh_ticket_trunk
                         where trunk_no = v_trunk.trunk_no
                           and plan_code = p_plan
                           and batch_no = p_batch);
         if v_count = 0 then
            -- 计算“箱”的开始“本”号
            v_trunk.package_no_start := lpad((to_number(v_trunk.trunk_no) - 1) * v_collect_batch_param.packs_every_trunk + 1, epublisher_sjz.len_package, '0');

            -- 计算“箱”的结束“本”号
            v_trunk.package_no_end := lpad((to_number(v_trunk.trunk_no)) * v_collect_batch_param.packs_every_trunk, epublisher_sjz.len_package, '0');

            -- 插入记录
            insert into wh_ticket_trunk
               (plan_code,          batch_no,                  reward_group,
                trunk_no,           package_no_start,          package_no_end,
                current_warehouse,  create_admin,              is_full)
            values
               (p_plan,             p_batch,                   v_trunk.reward_group,
                v_trunk.trunk_no,   v_trunk.package_no_start,  v_trunk.package_no_end,
                p_warehouse,        p_oper,                    eboolean.noordisabled);
         end if;

         -- “盒”的“箱”号
         v_box.trunk_no := v_trunk.trunk_no;

         -- 奖组
         v_box.reward_group := v_trunk.reward_group;

         -- “盒”的“盒”号
         v_box.box_no := v_array_lottery.box_no;

         -- “盒”的开始“本”号
         v_box.package_no_start := v_lottery_detail.package_no;
         v_box.package_no_end   := v_lottery_detail.package_no_e;

         -- 扩展“盒”数组
         v_insert_boxes.extend;
         v_box_count := v_box_count + 1;
         v_insert_boxes(v_box_count) := v_box;

         -- 填充“本”数据
         for v_loop_j in 1 .. v_packs_every_box loop
            -- “本”的“箱”号
            v_pack.trunk_no := v_box.trunk_no;

            -- 奖组
            v_pack.reward_group := v_box.reward_group;

            -- “本”的“盒”号
            v_pack.box_no := v_box.box_no;

            -- “本”号
            v_pack.package_no := lpad(to_number(v_box.package_no_start) + v_loop_j - 1, epublisher_sjz.len_package, '0');

            -- “本”的开始票号
            v_pack.ticket_no_start := epublisher_sjz.ticket_start;

            -- “本”的结束票号
            v_pack.ticket_no_end := epublisher_sjz.ticket_start + v_collect_batch_param.tickets_every_pack - 1;

            -- 扩展“本”数组
            v_insert_packs.extend;
            v_pack_count := v_pack_count + 1;
            v_insert_packs(v_pack_count) := v_pack;
         end loop;
      end if;
   end loop;

   -- 插入“盒”数据
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
   /******************* 再入“本”数据，并获取入库数据统计值 *************************/
   for v_list_count in 1 .. v_format_lotterys.count loop
      v_array_lottery := v_format_lotterys(v_list_count);
      if v_array_lottery.valid_number = evalid_number.pack then
         -- 获取彩票的明细数据
         v_lottery_detail := f_get_lottery_info(p_plan, p_batch, v_array_lottery.valid_number, v_array_lottery.package_no);

         /*- 明细为 “本”，需要视情况在 箱、盒、本 上插入记录
          * 首先应该明确“本”的编号，应该不在以前所入库的整“箱”中包含；同时也不能在非整“箱”的整“盒”中包含。如果出现包含，就是数据错误。
          * 然后计算“本”所在和“箱”、“盒”，依次写入数据
         */

         -- 计算“本”所在的“箱”号、“盒”号和奖组编号
         v_pack.trunk_no := v_lottery_detail.trunk_no;
         v_pack.box_no := v_lottery_detail.box_no;
         v_pack.reward_group := v_lottery_detail.reward_group;

         -- 查看“箱”是否存在，不存在，就增加（insert）。这时候，增加的记录，“是否完整”应该为“否”
         select count(*) into v_count
           from dual
          where exists(
                        select 1 from wh_ticket_trunk
                         where trunk_no = v_pack.trunk_no
                           and plan_code = p_plan
                           and batch_no = p_batch);
         if v_count = 0 then
            -- 计算“箱”的开始“本”号
            v_trunk.package_no_start := lpad((to_number(v_pack.trunk_no) - 1) * v_collect_batch_param.packs_every_trunk + 1, epublisher_sjz.len_package, '0') ;

            -- 计算“箱”的结束“本”号
            v_trunk.package_no_end := lpad((to_number(v_pack.trunk_no)) * v_collect_batch_param.packs_every_trunk, epublisher_sjz.len_package, '0') ;

            -- 插入记录
            insert into wh_ticket_trunk
               (plan_code,          batch_no,                  reward_group,
                trunk_no,           package_no_start,          package_no_end,
                current_warehouse,  create_admin,              is_full)
            values
               (p_plan,             p_batch,                   v_pack.reward_group,
                v_pack.trunk_no,    v_trunk.package_no_start,  v_trunk.package_no_end,
                p_warehouse,        p_oper,                    eboolean.noordisabled);
         end if;


         -- 查看“盒”是否存在，不存在，就增加（insert）。这时候，增加的记录，“是否完整”应该为“否”
         select count(*) into v_count
           from dual
          where exists(
                        select 1 from wh_ticket_box
                         where box_no = v_pack.box_no
                           and plan_code = p_plan
                           and batch_no = p_batch);
         if v_count = 0 then
            -- 计算“箱”的开始“本”号
            v_trunk.package_no_start := lpad((to_number(v_pack.trunk_no) - 1) * v_collect_batch_param.packs_every_trunk + 1, epublisher_sjz.len_package, '0') ;

            -- 计算“盒”的开始“本”号
            v_box.package_no_start := lpad(to_number(v_trunk.package_no_start) + (to_number(substr(v_pack.box_no, 7, 2)) - 1) * v_packs_every_box, epublisher_sjz.len_package, '0') ;

            -- 计算“盒”的结束“本”号
            v_box.package_no_end := lpad(v_box.package_no_start + v_packs_every_box - 1, epublisher_sjz.len_package, '0') ;

            -- 插入记录
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

         -- “本”号
         v_pack.package_no := v_array_lottery.package_no;

         -- “本”的开始票号
         v_pack.ticket_no_start := epublisher_sjz.ticket_start;

         -- “本”的结束票号
         v_pack.ticket_no_end := epublisher_sjz.ticket_start + v_collect_batch_param.tickets_every_pack - 1;

         -- 扩展“本”数组
         v_insert_packs.extend;
         v_pack_count := v_pack_count + 1;
         v_insert_packs(v_pack_count) := v_pack;

      end if;
   end loop;

   -- 插入“本”数据
   forall v_loop_i in 1 .. v_pack_count
      insert into wh_ticket_package
         (plan_code,                                  batch_no,                                 reward_group,
          trunk_no,                                   box_no,                                   package_no,
          ticket_no_start,                            ticket_no_end,                            current_warehouse,               create_admin)
      values
         (p_plan,                                     p_batch,                                  v_insert_packs(v_loop_i).reward_group,
          v_insert_packs(v_loop_i).trunk_no,          v_insert_packs(v_loop_i).box_no,          v_insert_packs(v_loop_i).package_no,
          v_insert_packs(v_loop_i).ticket_no_start,   v_insert_packs(v_loop_i).ticket_no_end,   p_warehouse,                     p_oper);

   -- 统计票数
   v_total_tickets := v_pack_count * v_collect_batch_param.tickets_every_pack;



   /****************************************************************************/
   /******************* 判断操作类型。插入和更新数据 ***************************/
   case
      when p_oper_type = 1 then
         -- 创建“批次入库”记录
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
      -- 插入 入库明细
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
