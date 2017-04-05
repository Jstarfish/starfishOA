create or replace procedure p_tb_outbound
/****************************************************************/
   ------------------- 调拨单出库 -------------------
   ---- 调拨单出库。支持新出库，继续出库，出库完结。
   ----     状态必须是“已审批”，才能进行操作
   ----     新出库：  更新“调拨单”发货信息；创建“出库单”；按照传递的出库对象（箱、盒、包）更新彩票数据，同时也要在出库单明细中记录出库对象；根据彩票统计数据，更新“出库单”和“调拨单”记录；
   ----     继续出库：按照传递的出库对象（箱、盒、包）更新彩票数据，同时也要在出库单明细中记录出库对象；根据彩票统计数据，更新“出库单”和“调拨单”记录；
   ----     出库完结：更新“调拨单”和“出库单”时间和状态信息。
   ---- add by 陈震: 2015/9/19
   ---- 涉及的业务表：
   ----     2.1.6.6 调拨单（sale_transfer_bill）                     -- 更新
   ----     2.1.5.10 出库单（wh_goods_receipt）                      -- 新增、更新
   ----     2.1.5.11 出库单明细（wh_goods_receipt_detail）           -- 新增、更新
   ----     2.1.5.3 即开票信息（箱）（wh_ticket_trunk）              -- 更新
   ----     2.1.5.4 即开票信息（盒）（wh_ticket_box）                -- 更新
   ----     2.1.5.5 即开票信息（本）（wh_ticket_package）            -- 更新
   ---- 业务流程：
   ----     1、校验输入参数。（仓库是否存在；操作类型是否为新、继续、完结；操作人是否合法；）
   ----     2、操作类型为“完结”时，更新“调拨单”的“发货时间”和“状态”，更新“出库单”的“出库时间”和“状态”，结束运行，返回。
   ----     3、获取已经保存的参数。（方案批次的包装信息-bulk方式获取；）
   ----     3、操作类型为“新建”时，更新“调拨单”发货信息，条件中要加入“状态”，“状态”必须为“已审批”；创建“出库单”；
   ----     4、按照出库明细，更新“即开票信息”表中各个对象的属性，条件中必须加入“状态”和“所在仓库”条件，并且检查更新记录数量，如果出现无更新记录情况，则报错；同时统计彩票统计信息；
   ----     5、更新“出库单”的“实际出库金额合计”和“实际出库张数”,“调拨单”的“实际调拨票数”和“实际调拨票数涉及金额”记录；

   /*************************************************************/
(
 --------------输入----------------
 p_stb_no            in char,                -- 调拨单编号
 p_warehouse         in char,                -- 发货仓库
 p_oper_type         in number,              -- 操作类型(1-新增，2-继续，3-完结)
 p_oper              in number,              -- 操作人
 p_remark            in varchar2,            -- 备注
 p_array_lotterys    in type_lottery_list,   -- 出库的彩票对象

 ---------出口参数---------
 c_errorcode out number,                     --错误编码
 c_errormesg out string                      --错误原因

 ) is

   v_count                 number(5);                                      -- 求记录数的临时变量
   v_wh_org                char(2);                                        -- 仓库所在部门
   v_plan_tickets          number(18);                                     -- 计划出库票数
   v_plan_amount           number(28);                                     -- 计划出库金额
   v_sgi_no                char(10);                                       -- 出库单编号
   v_list_count            number(10);                                     -- 出库明细总数

   type type_detail        is table of wh_goods_issue_detail%rowtype;
   v_insert_detail         type_detail;                                    -- 插入出库明细的数组
   v_detail_list           type_lottery_detail_list;                       -- 入库明细
   v_stat_list             type_lottery_statistics_list;                   -- 按照方案和批次统计的金额和票数

   v_total_tickets         number(20);                                     -- 当此出库的总票数
   v_total_amount          number(28);                                     -- 当此出库的总金额
   v_plan_publish          number(1);                                      -- 印制厂商编号

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
      select count(*) into v_count from dual where exists(select 1 from wh_goods_issue where ref_no = p_stb_no and status = ework_status.working);
      if v_count = 0 then
         c_errorcode := 4;
         c_errormesg := dbtool.format_line(p_stb_no) || error_msg.err_p_tb_outbound_3; -- 在进行继续出库时，输入的调拨单号错误，或者此调拨单对应的出库单，出库已经完结
         return;
      end if;
   end if;

   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* 操作类型为“完结”时，更新“调拨单”的“发货时间”和“状态”，更新“出库单”的“出库时间”和“状态”，结束运行，返回。 *************************/
   if p_oper_type = 3 then
      -- 更新“调拨单”的“发货时间”和“状态”
      update sale_transfer_bill
         set send_date = sysdate,
             status = eorder_status.sent
       where stb_no = p_stb_no
         and status = eorder_status.agreed
      returning
         status
      into
         v_count;
      if sql%rowcount = 0 then
         select status into v_count from sale_transfer_bill where stb_no = p_stb_no;
         rollback;
         c_errorcode := 5;
         c_errormesg := dbtool.format_line(p_stb_no) || dbtool.format_line(v_count) || error_msg.err_p_tb_outbound_4; -- 调拨单出库完结时，调拨单状态不合法
         return;
      end if;

      -- 更新“出库单”的“出库时间”和“状态”
      update wh_goods_issue
         set status = ework_status.done,
             issue_end_time = sysdate,
             receive_admin = create_admin,
             remark = p_remark
       where ref_no = p_stb_no
         and status = ework_status.working
       returning issue_tickets,  issue_amount,  act_issue_tickets, act_issue_amount
            into v_plan_tickets, v_plan_amount, v_total_tickets,   v_total_amount;

      -- 检查入库的内容与申请的内容，是否相符
      with
         act as (
            select plan_code, sum(tickets) alltickets
              from wh_goods_issue_detail
             where ref_no = p_stb_no
             group by plan_code),
         plan as (
            select plan_code, sum(tickets) alltickets
              from sale_tb_apply_detail
             where stb_no = p_stb_no
             group by plan_code),
         detail as (
            select plan_code, alltickets as act_tickets, 0 as plan_tickets from act
            union all
            select plan_code, 0 as act_tickets, alltickets as plan_tickets from plan),
         result as (
            select plan_code,sum(act_tickets) act_tickets, sum(plan_tickets) plan_tickets from detail group by plan_code),
         not_rule_list as (
            select plan_code, act_tickets, plan_tickets from result where act_tickets <> plan_tickets)
      select count(*) into v_count from dual where exists(select 1 from not_rule_list);
      if v_count > 0 then
         rollback;
         c_errorcode := 5;
         c_errormesg := error_msg.err_p_tb_outbound_14; -- 调拨单实际出库数量与申请数量不符
         return;
      end if;

      commit;
      return;
   end if;

   /************************************************************************************/
   /******************* 检查输入的入库对象是否合法 *************************/
   if f_check_import_ticket(p_stb_no, 2, p_array_lotterys) then
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
   /******************* 操作类型为“新建”时，更新“调拨单”发货信息，条件中要加入“状态”，“状态”必须为“已审批”；创建“出库单” *************************/
   if p_oper_type = 1 then
      -- 更新“调拨单”发货信息
      update sale_transfer_bill
         set send_org = v_wh_org,
             send_wh = p_warehouse,
             send_manager = p_oper,
             status = eorder_status.agreed
       where stb_no = p_stb_no
         and status = eorder_status.audited
      returning
         status, tickets, amount
      into
         v_count, v_plan_tickets, v_plan_amount;
      if sql%rowcount = 0 then
         rollback;
         c_errorcode := 5;
         c_errormesg := dbtool.format_line(p_stb_no) || dbtool.format_line(v_count) || error_msg.err_p_tb_outbound_5; -- 进行调拨单出库时，调拨单状态不合法
         return;
      end if;

      -- 创建“出库单”
      insert into wh_goods_issue
         (sgi_no,                    create_admin,           issue_amount,
          issue_tickets,             issue_type,             ref_no,
          send_org,                  send_wh)
      values
         (f_get_wh_goods_issue_seq,  p_oper,                 v_plan_amount,
          v_plan_tickets,            eissue_type.trans_bill, p_stb_no,
          v_wh_org,                  p_warehouse)
      returning
         sgi_no
      into
         v_sgi_no;
   else
      -- 获取出库单编号
      begin
         select sgi_no into v_sgi_no from wh_goods_issue where ref_no = p_stb_no;
      exception
         when no_data_found then
            rollback;
            c_errorcode := 6;
            c_errormesg := dbtool.format_line(p_stb_no) || error_msg.err_p_tb_outbound_6; -- 不能获得出库单编号
            return;
      end;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* 按照出库明细，更新“即开票信息”表中各个对象的属性；同时统计彩票统计信息 *************************/

   -- 初始化数组
   v_insert_detail := type_detail();
   v_total_tickets := 0;


   -- 根据明细数据，更新“即开票”状态
   p_ticket_perferm(p_array_lotterys, p_oper, eticket_status.in_warehouse, eticket_status.on_way, p_warehouse, null, v_err_code, v_err_msg);
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
      v_insert_detail(v_list_count).sgi_no := v_sgi_no;
      v_insert_detail(v_list_count).ref_no := p_stb_no;
      v_insert_detail(v_list_count).sequence_no := f_get_wh_goods_issue_detai_seq;
      v_insert_detail(v_list_count).issue_type := eissue_type.trans_bill;

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
   /******************* 更新“出库单”的“实际出库金额合计”和“实际出库张数”,“调拨单”的“实际调拨票数”和“实际调拨票数涉及金额”记录 *************************/
   update wh_goods_issue
      set act_issue_tickets = act_issue_tickets + v_total_tickets,
          act_issue_amount = act_issue_amount + v_total_amount
    where sgi_no = v_sgi_no
   returning issue_tickets, act_issue_tickets
        into v_plan_amount, v_total_amount;

   -- 检查入库的内容与申请的内容，是否相符
   with
      act as (
         select plan_code, sum(tickets) alltickets
           from wh_goods_issue_detail
          where ref_no = p_stb_no
          group by plan_code),
      plan as (
         select plan_code, sum(tickets) alltickets
           from sale_tb_apply_detail
          where stb_no = p_stb_no
          group by plan_code),
      detail as (
         select plan_code, alltickets as act_tickets, 0 as plan_tickets from act
         union all
         select plan_code, 0 as act_tickets, alltickets as plan_tickets from plan),
      result as (
         select plan_code,sum(act_tickets) act_tickets, sum(plan_tickets) plan_tickets from detail group by plan_code),
      not_rule_list as (
         select plan_code, act_tickets, plan_tickets from result where act_tickets > plan_tickets)
   select count(*) into v_count from dual where exists(select 1 from not_rule_list);
   if v_count > 0 then
      rollback;
      c_errorcode := 5;
      c_errormesg := error_msg.err_p_tb_outbound_14; -- 调拨单实际出库数量与申请数量不符
      return;
   end if;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;
end;

