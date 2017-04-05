create or replace procedure p_rr_inbound
/****************************************************************/
   ------------------- 还货单入库 -------------------
   ---- 还货单入库。支持新入库，继续入库，入库完结。
   ----     状态必须是“已审批”，才能进行操作
   ----     新入库：  更新“还货单”收货信息；
   ----               创建“入库单”；
   ----               按照传递的入库对象（箱、盒、包）更新彩票数据，同时也要在入库单明细中记录入库对象；
   ----               根据彩票统计数据，更新“入库单”和“还货单”记录；
   ----               修改“市场管理员”的库存彩票状态；
   ----     继续入库：按照传递的入库对象（箱、盒、包）更新彩票数据，同时也要在入库单明细中记录入库对象；
   ----               根据彩票统计数据，更新“入库单”和“还货单”记录；
   ----               修改“市场管理员”的库存彩票状态；
   ----     入库完结：更新“还货单”和“入库单”时间和状态信息。
   ---- add by 陈震: 2015/9/21
   ---- 涉及的业务表：
   ----     2.1.6.6 还货单                      -- 更新
   ----     2.1.5.10 入库单                     -- 新增、更新
   ----     2.1.5.11 入库单明细                 -- 新增、更新
   ----     2.1.5.3 即开票信息（箱）            -- 更新
   ----     2.1.5.4 即开票信息（盒）            -- 更新
   ----     2.1.5.5 即开票信息（本）            -- 更新
   ---- 业务流程：
   ----     1、校验输入参数。（仓库是否存在；操作类型是否为新、继续、完结；操作人是否合法；）
   ----     2、操作类型为“完结”时，更新“还货单”的“收货时间”和“状态（5-已收货）”，更新“入库单”的“入库时间”和“状态”，结束运行，返回。
   ----     3、获取已经保存的参数。（方案批次的包装信息-bulk方式获取；）
   ----     4、操作类型为“新建”时，更新“还货单”收货信息，条件中要加入“状态”，值必须为“已审批”；创建“入库单”；
   ----     5、按照入库明细，更新“即开票信息”表中各个对象的属性，条件中必须加入“状态”和“所在仓库”条件，并且检查更新记录数量，如果出现无更新记录情况，则报错；
   ----        同时统计彩票统计信息；
   ----     6、更新“入库单”的“实际入库金额合计”和“实际入库张数”,“还货单”的“实际调拨票数”和“实际调拨票数涉及金额”记录；
   ----        更新市场管理员的库存；

   /*************************************************************/
(
 --------------输入----------------
 p_r_no              in char,                -- 还货单编号
 p_warehouse         in char,                -- 收货仓库
 p_oper_type         in number,              -- 操作类型(1-新增，2-继续，3-完结)
 p_oper              in number,              -- 操作人
 p_remark            in varchar2,            -- 备注
 p_array_lotterys    in type_lottery_list,   -- 入库的彩票对象

 ---------出口参数---------
 c_errorcode out number,                     --错误编码
 c_errormesg out string                      --错误原因

 ) is

   v_count                 number(5);                                      -- 求记录数的临时变量
   v_wh_org                char(2);                                        -- 仓库所在部门
   v_plan_tickets          number(18);                                     -- 计划入库票数
   v_plan_amount           number(18);                                     -- 计划入库金额
   v_mm                    number(4);                                      -- 市场管理员
   v_sgr_no                char(10);                                       -- 入库单编号

   v_list_count            number(10);                                     -- 入库明细总数

   type type_detail        is table of wh_goods_receipt_detail%rowtype;
   v_insert_detail         type_detail;                                    -- 插入入库明细的数组
   v_detail_list           type_lottery_detail_list;                       -- 入库明细
   v_stat_list             type_lottery_statistics_list;                   -- 按照方案和批次统计的金额和票数

   v_total_tickets         number(20);                                     -- 当此出库的总票数
   v_total_amount          number(28);                                     -- 当此出库的总金额
   v_plan_publish          number(1);                                      -- 印制厂商编号
   v_temp_tickets          number(20);                                     -- 当此出库的总票数
   v_temp_amount           number(28);                                     -- 当此出库的总金额

   v_err_code              number(10);                                     -- 调用存储过程时，返回值
   v_err_msg               varchar2(4000);                                 -- 调用存储过程时，返回错误信息

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

   if not p_oper_type in (1,2,3) then
      c_errorcode := 3;
      c_errormesg := dbtool.format_line(p_oper_type) || error_msg.err_common_105; -- 操作类型参数错误，应该为1，2，3
      return;
   end if;

   -- 继续入库时，判断是否已经完结
   if p_oper_type = 2 then
      select count(*) into v_count from dual where exists(select 1 from wh_goods_receipt where ref_no = p_r_no and status = ework_status.working);
      if v_count = 0 then
         c_errorcode := 4;
         c_errormesg := dbtool.format_line(p_r_no) || error_msg.err_p_tb_inbound_3; -- 在进行继续入库时，输入的调拨单号错误，或者此调拨单对应的入库单，入库已经完结
         return;
      end if;
   end if;
   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* 操作类型为“完结”时，更新“还货单”的“收货时间”和“状态”，更新“入库单”的“入库时间”和“状态”，结束运行，返回。 *************************/
   if p_oper_type = 3 then
      -- 更新“还货单”的“收货时间”和“状态”
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
               c_errormesg := dbtool.format_line(p_r_no) || error_msg.err_p_rr_inbound_24; -- 换货单编号不合法，未查询到此换货单
               return;
         end;

         c_errorcode := 4;
         c_errormesg := dbtool.format_line(p_r_no) || dbtool.format_line(v_count) || error_msg.err_p_rr_inbound_4; -- 还货单入库完结时，还货单状态不合法，期望的还货单状态应该为[收货中]
         return;
      end if;

      -- 更新“入库单”的“入库时间”和“状态”
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
   /******************* 检查输入的入库对象以及已经提交的入库对象是否合法 *************************/
   if f_check_import_ticket(p_r_no, 1, p_array_lotterys) then
      c_errorcode := 6;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_103; -- 彩票对象，存在“自包含”的情况
      return;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* 获取已经保存的参数。（方案批次的包装信息-bulk方式获取；） *************************/

   -- 获取印制厂商信息
/*   select plan_flow
     into v_plan_publish
     from inf_publishers
    where publisher_code =
          (select publisher_code from game_plans where plan_code = p_plan);
*/
   -- 仓库所在部门
   select org_code into v_wh_org from wh_info where warehouse_code = p_warehouse;

   /********************************************************************************************************************************************************************/
   /******************* 操作类型为“新建”时，更新“还货单”收货信息，条件中要加入“状态”，“状态”必须为“已发货”；创建“入库单” *************************/
   if p_oper_type = 1 then
      -- 更新“还货单”收货信息
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
               c_errormesg := dbtool.format_line(p_r_no) || error_msg.err_p_rr_inbound_24; -- 换货单编号不合法，未查询到此换货单
               return;
         end;

         c_errorcode := 5;
         c_errormesg := dbtool.format_line(p_r_no) || dbtool.format_line(v_count) || error_msg.err_p_rr_inbound_5; -- 还货单入库完结时，还货单状态不合法，期望的换货单状态应该为[已审批]
         return;
      end if;

      -- 创建“入库单”
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
      -- 获取入库单编号
      begin
         select sgr_no into v_sgr_no from wh_goods_receipt where ref_no = p_r_no;
      exception
         when no_data_found then
            rollback;
            c_errorcode := 6;
            c_errormesg := dbtool.format_line(p_r_no) || error_msg.err_p_tb_inbound_6; -- 不能获得入库单编号
            return;
      end;

      -- 获取市场管理员编号
      begin
         select market_manager_admin, status
           into v_mm, v_count
           from sale_return_recoder
          where return_no = p_r_no;
      exception
         when no_data_found then
            rollback;
            c_errorcode := 24;
            c_errormesg := dbtool.format_line(p_r_no) || error_msg.err_p_rr_inbound_24; -- 换货单编号不合法，未查询到此换货单
            return;
      end;

      if v_count <> eorder_status.receiving then
         rollback;
         c_errorcode := 15;
         c_errormesg := dbtool.format_line(p_r_no) || dbtool.format_line(v_count) || error_msg.err_p_rr_inbound_15; -- 还货单继续入库时，还货单状态不合法，期望的换货单状态应该为[接收中]
      end if;

   end if;

   /********************************************************************************************************************************************************************/
   /******************* 按照入库明细，更新“即开票信息”表中各个对象的属性；同时统计彩票统计信息 *************************/

   -- 初始化数组
   v_insert_detail := type_detail();
   v_total_tickets := 0;

   -- 根据明细数据，更新“即开票”状态
   p_ticket_perferm(p_array_lotterys, p_oper, eticket_status.in_mm, eticket_status.in_warehouse, v_mm, p_warehouse, v_err_code, v_err_msg);
   if v_err_code <> 0 then
      rollback;
      c_errorcode := 1;
      c_errormesg := error_msg.err_common_104 || v_err_msg; -- 更新“即开票”状态时，出现错误
      return;
   end if;

   -- 统计入库对象的票数据
   p_lottery_detail_stat(p_array_lotterys, v_detail_list, v_stat_list, v_total_tickets, v_total_amount);

   -- 插入出库明细
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

   -- 循环统计结果，按照方案批次，更新库管员库存
   for v_loop_i in 1 .. v_stat_list.count loop

      -- 更新仓库管理员库存信息。这里与出货单出库不同，不允许仓库管理员在没有对应方案批次库存的情况下，退此批次的彩票
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
         c_errormesg := dbtool.format_line(p_oper) || dbtool.format_line(v_stat_list(v_loop_i).plan_code) || dbtool.format_line(v_stat_list(v_loop_i).batch_no) || error_msg.err_p_ar_inbound_14; -- 仓库管理员的库存中，没有此方案和批次的库存信息
         return;
      end if;

   end loop;
   /********************************************************************************************************************************************************************/
   /******************* 更新“入库单”的“实际入库金额合计”和“实际入库张数”,“还货单”的“实际调拨票数”和“实际调拨票数涉及金额”记录 *************************/
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
