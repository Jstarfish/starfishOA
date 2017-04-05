create or replace procedure p_ar_outbound
/****************************************************************/
   ------------------- 站点退货 -------------------
   ---- 站点一次性完成退货工作
   ----     创建“出库单”；
   ----     按照传递的出库对象（箱、盒、包）更新彩票数据，同时也要在出库单明细中记录出库对象；
   ----     退货的明细中，检查是否包含已经兑奖的彩票；
   ----     修改“市场管理员”的库存彩票数据；
   ----     修改“站点”余额

   ---- add by 陈震: 2015/9/21
   ---- 涉及的业务表：
   ----     2.1.6.10 站点退货单（sale_agency_return）                      -- 新增
   ----     2.1.5.10 出库单                                                -- 新增
   ----     2.1.5.11 出库单明细                                            -- 新增
   ----     2.1.5.3 即开票信息（箱）                                       -- 更新
   ----     2.1.5.4 即开票信息（盒）                                       -- 更新
   ----     2.1.5.5 即开票信息（本）                                       -- 更新

   ---- 业务流程：
   ----     1、校验输入参数。（仓库是否存在；操作人是否合法；输入的彩票对象，是否有自包含的情况）
   ----     2、按照出库明细，更新“即开票信息”表中各个对象的属性;
   ----     3、循环出库明细
   ----        记录彩票统计信息（出库票数、出库金额、佣金金额）；
   ----        写入入库明细数组，准备后续插入“出库明细表”；
   ----        按照方案和批次，更新仓库管理员持票信息；
   ----        检查是否包含已经兑奖的彩票；
   ----     4、新增“站点退货单”信息，新增“出库单”和“出货单明细”，获取主键值；
   ----     5、为站点增加资金，类型为“站点退货”，同时也要减少资金，类型为“销售代销费”，但是传递的参数应该为负值；
   ----     6、更新“站点退货单”中的“退货前站点余额”和“退货后站点余额”

   /*************************************************************/
(
 --------------输入----------------
  p_agency                           in char,                              -- 退货销售站
  p_oper                             in number,                            -- 市场管理员
  p_array_lotterys                   in type_lottery_list,                 -- 退库的彩票对象

 ---------出口参数---------
  c_errorcode                        out number,                           -- 错误编码
  c_errormesg                        out string                            -- 错误原因

 ) is

   v_ai_no                 char(10);                                       -- 站点退货单编号
   v_sgi_no                char(10);                                       -- 出库单编号
   v_sgr_no                char(10);                                       -- 入库单编号
   v_org                   char(2);                                        -- 销售站所属机构
   v_loop_i                number(10);                                     -- 循环使用的参数
   v_loop_j                number(10);                                     -- 循环使用的参数2
   v_found                 boolean;                                        -- 是否找到相应记录
   v_area_code             char(4);                                        -- 销售站所属区域
   v_count                 number(3);                                      -- 检测记录是否存在

   v_balance               number(28);                                     -- 账户余额
   v_f_balance             number(28);                                     -- 冻结账户余额

   v_detail_list           type_lottery_detail_list;                       -- 退票明细
   v_stat_list             type_lottery_statistics_list;                   -- 按照方案和批次统计的金额和票数

   type type_detail        is table of wh_goods_issue_detail%rowtype;
   v_insert_detail         type_detail;                                    -- 插入出库明细的数组

   v_cancel_info           flow_cancel%rowtype;                            -- 退票流水
   type type_cancel        is table of flow_cancel%rowtype;
   v_cancel_list           type_cancel;                                    -- 退票明细数组
   v_lottery_info          type_lottery_detail_info;                       -- 参数退票的单个彩票对象

   v_total_tickets         number(20);                                     -- 当此出库的总票数
   v_total_amount          number(28);                                     -- 当此出库的总金额
   v_plan_publish          number(1);                                      -- 印制厂商编号

   v_total_comm_amount     number(18);                                     -- 销售佣金
   v_comm_rate             number(18);                                     -- 销售佣金比例
   v_single_ticket_amount  number(18);                                     -- 单票金额

   v_delivery_amount       number(28);                                     -- 市场管理员当前持票金额

   v_lottery_object_info   type_lottery_info;                              -- 退票对象，用于检查此对象是否进行过兑奖

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

   -- 检查输入的参数是否有“自包含”的情况
   if f_check_ticket_perfect(p_array_lotterys) then
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_103; -- 彩票对象，存在“自包含”的情况
      return;
   end if;

   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* 获取已经保存的参数。（方案批次的包装信息-bulk方式获取；） *************************/

   -- 获取印制厂商信息
/*   select plan_flow
     into v_plan_publish
     from inf_publishers
    where publisher_code =
          (select publisher_code from game_plans where plan_code = p_plan);
*/

   /********************************************************************************************************************************************************************/
   /******************* 按照出库明细，更新“即开票信息”表中各个对象的属性；同时统计彩票统计信息 *************************/

   -- 根据明细数据，更新“即开票”状态
   p_ticket_perferm(p_array_lotterys, p_oper, eticket_status.saled, eticket_status.in_mm, p_agency, p_oper, v_err_code, v_err_msg);
   if v_err_code <> 0 then
      rollback;
      c_errorcode := 1;
      c_errormesg := error_msg.err_common_104 || v_err_msg; -- 更新“即开票”状态时，出现错误
      return;
   end if;

   -- 统计入库对象的票数据
   p_lottery_detail_stat(p_array_lotterys, v_detail_list, v_stat_list, v_total_tickets, v_total_amount);

   /*******************************************************************************************************************************************************************/
   /********* 循环所有退票的彩票对象，找到对应的入库单，然后找到对应的销售记录，获取单票金额和佣金，然后按照这个值，计算退票金额和退的佣金   **************************/
   v_total_tickets := 0;
   v_total_amount := 0;
   v_total_comm_amount := 0;
   v_cancel_list := type_cancel();

   for v_loop_i in 1 .. v_detail_list.count loop

      v_lottery_info := v_detail_list(v_loop_i);

      -- 查找当时的入库记录
      case
         when v_detail_list(v_loop_i).valid_number = evalid_number.trunk then
            -- 检查此箱票，是否兑过奖
            v_lottery_object_info := f_get_lottery_info(v_lottery_info.plan_code, v_lottery_info.batch_no, evalid_number.trunk, v_lottery_info.trunk_no);
            select count(*)
              into v_count
              from dual
             where exists(select 1 from flow_pay
                                  where plan_code = v_lottery_info.plan_code
                                    and batch_no = v_lottery_info.batch_no
                                    and package_no >= v_lottery_object_info.package_no
                                    and package_no <= v_lottery_object_info.package_no_e);
            if v_count > 0 then
               rollback;
               c_errorcode := 1;
               c_errormesg := error_msg.err_p_ar_outbound_10; -- 有彩票已经兑奖，不能退票
               return;
            end if;

            -- 整“箱”退票，这个比较容易找，因为他没有被拆封过
            select max(sgr_no)
              into v_sgr_no
              from wh_goods_receipt_detail
             where plan_code = v_lottery_info.plan_code
               and batch_no = v_lottery_info.batch_no
               and valid_number = evalid_number.trunk
               and trunk_no = v_lottery_info.trunk_no
               and receipt_type = ereceipt_type.agency;
            if v_sgr_no is null then
                  rollback;
                  c_errorcode := 1;
                  c_errormesg := error_msg.err_p_ar_outbound_20; -- 对应的箱数据，没有在入库单中找到
                  return;
            end if;

         when v_detail_list(v_loop_i).valid_number = evalid_number.box then
            -- 检查此箱票，是否兑过奖
            v_lottery_object_info := f_get_lottery_info(v_lottery_info.plan_code, v_lottery_info.batch_no, evalid_number.box, v_lottery_info.box_no);
            select count(*)
              into v_count
              from dual
             where exists(select 1 from flow_pay
                                  where plan_code = v_lottery_info.plan_code
                                    and batch_no = v_lottery_info.batch_no
                                    and package_no >= v_lottery_object_info.package_no
                                    and package_no <= v_lottery_object_info.package_no_e);
            if v_count > 0 then
               rollback;
               c_errorcode := 1;
               c_errormesg := error_msg.err_p_ar_outbound_10; -- 有彩票已经兑奖，不能退票
               return;
            end if;

            -- 整“盒”退票，首先需要找这一盒，如果没有找到，那就找“箱”，因为有可能是整“箱”入库，拆开以后退
            select max(sgr_no)
              into v_sgr_no
              from wh_goods_receipt_detail
             where plan_code = v_lottery_info.plan_code
               and batch_no = v_lottery_info.batch_no
               and receipt_type = ereceipt_type.agency
               and valid_number = evalid_number.box
               and box_no = v_lottery_info.box_no;
            if v_sgr_no is null then
               select max(sgr_no)
                 into v_sgr_no
                 from wh_goods_receipt_detail
                where plan_code = v_lottery_info.plan_code
                  and batch_no = v_lottery_info.batch_no
                  and receipt_type = ereceipt_type.agency
                  and valid_number = evalid_number.trunk
                  and trunk_no = v_lottery_info.trunk_no;
               if v_sgr_no is null then
                  rollback;
                  c_errorcode := 1;
                  c_errormesg := error_msg.err_p_ar_outbound_30; -- 对应的盒数据，没有在入库单中找到
                  return;
               end if;
            end if;

         when v_detail_list(v_loop_i).valid_number = evalid_number.pack then
            -- 检查此箱票，是否兑过奖
            select count(*)
              into v_count
              from dual
             where exists(select 1 from flow_pay
                                  where plan_code = v_lottery_info.plan_code
                                    and batch_no = v_lottery_info.batch_no
                                    and package_no = v_lottery_info.package_no);
            if v_count > 0 then
               rollback;
               c_errorcode := 1;
               c_errormesg := error_msg.err_p_ar_outbound_10; -- 有彩票已经兑奖，不能退票
               return;
            end if;

            -- 首先找“本”，没有再找“盒”，再没有，就找“箱”
            select max(sgr_no)
              into v_sgr_no
              from wh_goods_receipt_detail
             where plan_code = v_lottery_info.plan_code
               and batch_no = v_lottery_info.batch_no
               and receipt_type = ereceipt_type.agency
               and valid_number = evalid_number.pack
               and package_no = v_lottery_info.package_no;
            if v_sgr_no is null then
               select max(sgr_no)
                 into v_sgr_no
                 from wh_goods_receipt_detail
                where plan_code = v_lottery_info.plan_code
                  and batch_no = v_lottery_info.batch_no
                  and receipt_type = ereceipt_type.agency
                  and valid_number = evalid_number.box
                  and box_no = v_lottery_info.box_no;
               if v_sgr_no is null then
                  select max(sgr_no)
                    into v_sgr_no
                    from wh_goods_receipt_detail
                   where plan_code = v_lottery_info.plan_code
                     and batch_no = v_lottery_info.batch_no
                     and receipt_type = ereceipt_type.agency
                     and valid_number = evalid_number.trunk
                     and trunk_no = v_lottery_info.trunk_no;
                  if v_sgr_no is null then
                     rollback;
                     c_errorcode := 1;
                     c_errormesg := error_msg.err_p_ar_outbound_40; -- 对应的本数据，没有在入库单中找到
                     return;
                  end if;
               end if;
            end if;

      end case;

      -- 校验找到的入库数据，是否已经售出到这个销售站
      select count(*)
        into v_count
        from dual
       where exists(select 1
                      from wh_goods_receipt tab
                     where receipt_type = ereceipt_type.agency
                       and receive_wh = p_agency
                       and sgr_no = v_sgr_no);
      if v_count = 0 then
         rollback;
         c_errorcode := 1;
         c_errormesg := error_msg.err_p_ar_outbound_50; -- 对应的箱数据已经在入库单中找到，但是状态或者所属站点信息不正确
         return;
      end if;

      -- 查找销售记录，获取历史单票金额和代销费比率
      begin
         select trunc(sale_amount/tickets), comm_rate
           into v_single_ticket_amount, v_comm_rate
           from flow_sale
          where sgr_no = v_sgr_no
            and plan_code = v_lottery_info.plan_code
            and batch_no = v_lottery_info.batch_no;
      exception
         when no_data_found then
            rollback;
            c_errorcode := 1;
            c_errormesg := error_msg.err_p_ar_outbound_60; -- 未查询到待退票的售票记录
            return;
      end;

      -- 记录退票数据，同一个方案、批次、佣金比例的数据，会被合并记录
      v_found := false;
      for v_loop_j in 1 .. v_cancel_list.count loop
         -- 检查是否已经存在同一个方案、批次、佣金比例的数据
         if v_cancel_list(v_loop_j).plan_code = v_lottery_info.plan_code and v_cancel_list(v_loop_j).batch_no = v_lottery_info.batch_no and v_cancel_list(v_loop_j).comm_rate = v_comm_rate then
            v_cancel_list(v_loop_j).tickets := v_cancel_list(v_loop_j).tickets +  v_lottery_info.tickets;
            v_cancel_list(v_loop_j).sale_amount := v_cancel_list(v_loop_j).sale_amount + v_lottery_info.amount;
            v_cancel_list(v_loop_j).comm_amount := v_cancel_list(v_loop_j).comm_amount + v_lottery_info.amount * v_comm_rate / 1000;

            case
               when v_detail_list(v_loop_i).valid_number = evalid_number.trunk then
                  v_cancel_list(v_loop_j).trunks := v_cancel_list(v_loop_j).trunks + 1;

               when v_detail_list(v_loop_i).valid_number = evalid_number.box then
                  v_cancel_list(v_loop_j).boxes := v_cancel_list(v_loop_j).boxes + 1;

               when v_detail_list(v_loop_i).valid_number = evalid_number.pack then
                  v_cancel_list(v_loop_j).packages := v_cancel_list(v_loop_j).packages + 1;

            end case;

            v_found := true;
            exit;
         end if;
      end loop;
      if not v_found then
         v_cancel_info.plan_code := v_lottery_info.plan_code;
         v_cancel_info.batch_no := v_lottery_info.batch_no;
         v_cancel_info.comm_rate := v_comm_rate;
         v_cancel_info.tickets := v_lottery_info.tickets;
         v_cancel_info.sale_amount := v_lottery_info.amount;
         v_cancel_info.comm_amount := v_lottery_info.amount * v_comm_rate / 1000;

         case
            when v_detail_list(v_loop_i).valid_number = evalid_number.trunk then
               v_cancel_info.trunks := 1;
               v_cancel_info.boxes := 0;
               v_cancel_info.packages := 0;

            when v_detail_list(v_loop_i).valid_number = evalid_number.box then
               v_cancel_info.trunks := 0;
               v_cancel_info.boxes := 1;
               v_cancel_info.packages := 0;

            when v_detail_list(v_loop_i).valid_number = evalid_number.pack then
               v_cancel_info.trunks := 0;
               v_cancel_info.boxes := 0;
               v_cancel_info.packages := 1;

         end case;

         v_cancel_list.extend;
         v_cancel_list(v_cancel_list.count) := v_cancel_info;
      end if;

      -- 统计数据
      v_total_tickets := v_total_tickets + v_lottery_info.tickets;
      v_total_amount := v_total_amount + v_lottery_info.amount;
      v_total_comm_amount := v_total_comm_amount + v_lottery_info.amount * v_comm_rate / 1000;

   end loop;

   /********************************************************************************************************************************************************************/
   /******************* 更新管理员持票库存，判断是否超过管理员最大限额； *************************/
   for v_list_count in 1 .. v_stat_list.count loop
      merge into acc_mm_tickets tgt
      using (select p_oper market_admin, v_stat_list(v_list_count).plan_code plan_code, v_stat_list(v_list_count).batch_no batch_no from dual) tab
         on (tgt.market_admin = tab.market_admin and tgt.plan_code = tab.plan_code and tgt.batch_no = tab.batch_no)
       when matched then
         update set tgt.tickets = tgt.tickets + v_stat_list(v_list_count).tickets,
                    tgt.amount = tgt.amount + v_stat_list(v_list_count).amount
       when not matched then
         insert values (p_oper, v_stat_list(v_list_count).plan_code, v_stat_list(v_list_count).batch_no, v_stat_list(v_list_count).tickets, v_stat_list(v_list_count).amount);
   end loop;

   -- 获取管理员当前最大持票金额
   select sum(tickets)
     into v_delivery_amount
     from acc_mm_tickets
    where market_admin = p_oper;

   -- 判断是否超过最大持票金额
   select count(*)
     into v_count
     from dual
    where exists(select 1 from inf_market_admin
                  where market_admin = p_oper
                    and max_amount_ticketss < nvl(v_delivery_amount, 0));
   if v_count = 1 then
      rollback;
      c_errorcode := 17;
      c_errormesg := dbtool.format_line(p_oper) || dbtool.format_line(v_delivery_amount) || error_msg.err_p_ar_outbound_70; -- 超过此管理员允许持有的“最高赊票金额”
      return;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* 更新“出库单”的“实际出库金额合计”和“实际出库张数”,“站点退货单”的“实际处理票数”和“实际处理票数涉及金额”记录 *************************/
   select org_code
     into v_org
     from inf_agencys
    where agency_code = p_agency;

   select area_code
     into v_area_code
     from inf_agencys
    where agency_code = p_agency;

   -- 创建“站点退货单”
   insert into sale_agency_return
      (ai_no,              ai_mm_admin, ai_date, ai_agency, tickets,         amount)
   values
      (f_get_sale_ai_seq,  p_oper,      sysdate, p_agency,  v_total_tickets, v_total_amount)
   returning
      ai_no
   into
      v_ai_no;

   -- 创建“出库单”
   insert into wh_goods_issue
      (sgi_no,                      create_admin,              issue_end_time,
       issue_amount,                issue_tickets,             act_issue_amount,
       act_issue_tickets,           issue_type,                ref_no,
       status,                      send_org,                  send_wh,
       receive_admin)
   values
      (f_get_wh_goods_issue_seq,    p_oper,                    sysdate,
       v_total_amount,              v_total_tickets,           v_total_amount,
       v_total_tickets,             eissue_type.agency_return, v_ai_no,
       eboolean.yesorenabled,       v_org,                     p_agency,
       p_oper)
   returning
      sgi_no
   into
      v_sgi_no;

   -- 初始化数组
   v_insert_detail := type_detail();

   -- 插入出库明细
   for v_loop_i in 1 .. v_detail_list.count loop
      v_insert_detail.extend;
      v_insert_detail(v_loop_i).sgi_no := v_sgi_no;
      v_insert_detail(v_loop_i).ref_no := v_ai_no;
      v_insert_detail(v_loop_i).sequence_no := f_get_wh_goods_issue_detai_seq;
      v_insert_detail(v_loop_i).issue_type := eissue_type.agency_return;

      v_insert_detail(v_loop_i).valid_number := v_detail_list(v_loop_i).valid_number;
      v_insert_detail(v_loop_i).plan_code := v_detail_list(v_loop_i).plan_code;
      v_insert_detail(v_loop_i).batch_no := v_detail_list(v_loop_i).batch_no;
      v_insert_detail(v_loop_i).trunk_no := v_detail_list(v_loop_i).trunk_no;
      v_insert_detail(v_loop_i).box_no := v_detail_list(v_loop_i).box_no;
      v_insert_detail(v_loop_i).package_no := v_detail_list(v_loop_i).package_no;
      v_insert_detail(v_loop_i).tickets := v_detail_list(v_loop_i).tickets;
      v_insert_detail(v_loop_i).amount := v_detail_list(v_loop_i).amount;
   end loop;

   forall v_loop_i in 1 .. v_insert_detail.count
      insert into wh_goods_issue_detail values v_insert_detail(v_loop_i);

   -- 插入退票流水
   for v_loop_i in 1 .. v_cancel_list.count loop
      v_cancel_list(v_loop_i).cancel_flow := f_get_flow_cancel_seq;
      v_cancel_list(v_loop_i).agency_code := p_agency;
      v_cancel_list(v_loop_i).area_code := v_area_code;
      v_cancel_list(v_loop_i).org_code := v_org;
      v_cancel_list(v_loop_i).cancel_time := sysdate;
      v_cancel_list(v_loop_i).ai_no := v_ai_no;
      v_cancel_list(v_loop_i).sgi_no := v_sgi_no;
   end loop;

   forall v_loop_i in 1 .. v_cancel_list.count
      insert into flow_cancel values v_cancel_list(v_loop_i);

   /********************************************************************************************************************************************************************/
   /******************* 为站点增加资金，类型为“站点退货”，同时也要减少资金，类型为“销售代销费”； *************************/
   -- 增加销售站账户余额，类型为“站点退货”
   p_agency_fund_change(p_agency, eflow_type.agency_return, v_total_amount, 0, v_ai_no, v_balance, v_f_balance);

   -- 减少销售站账户余额，类型为“撤销代销费”
   p_agency_fund_change(p_agency, eflow_type.cancel_comm, v_total_comm_amount, 0, v_ai_no, v_balance, v_f_balance);

   -- 更新“站点退货单”中的“退货前站点余额”和“退货后站点余额”
   update sale_agency_return
      set before_balance = v_balance - v_total_amount + v_total_comm_amount,
          after_balance = v_balance
    where ai_no = v_ai_no;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
