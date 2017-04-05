create or replace procedure p_ar_inbound
/****************************************************************/
   ------------------- 站点入库单入库 -------------------
   ---- 站点入库单入库。一次性完成彩票入库。
   ----     创建“入库单”；
   ----     按照传递的入库对象（箱、盒、包）更新彩票数据，同时也要在入库单明细中记录入库对象；
   ----     根据彩票统计数据，更新“入库单”和“站点入库单”记录；
   ----     修改“市场管理员”的库存彩票状态；
   ----     修改“站点”余额

   ---- add by 陈震: 2015/9/21
   ---- 涉及的业务表：
   ----     2.1.6.10 站点入库单（sale_agency_receipt）                     -- 新增
   ----     2.1.5.10 入库单                                                -- 新增
   ----     2.1.5.11 入库单明细                                            -- 新增
   ----     2.1.5.3 即开票信息（箱）                                       -- 更新
   ----     2.1.5.4 即开票信息（盒）                                       -- 更新
   ----     2.1.5.5 即开票信息（本）                                       -- 更新

   ---- 业务流程：
   ----     1、校验输入参数。（仓库是否存在；操作人是否合法；输入的彩票对象，是否有自包含的情况）
   ----     2、按照出库明细，更新“即开票信息”表中各个对象的属性;
   ----     3、循环出库明细
   ----        记录彩票统计信息（入库票数、入库金额、佣金金额）；
   ----        写入入库明细数组，准备后续插入“入库明细表”；
   ----        按照方案和批次，更新仓库管理员持票信息；
   ----        检查是否包含已经兑奖的彩票；
   ----     4、新增“站点退货单”信息，新增“入库单”和“入货单明细”，获取主键值；
   ----     5、扣减站点资金，类型为“站点入库”，同时也要增加资金，类型为“销售代销费”；
   ----     6、更新“站点入库单”中的“入库前站点余额”和“入库后站点余额”

   /*************************************************************/
(
 --------------输入----------------
  p_agency                           in char,                              -- 收货销售站
  p_oper                             in number,                            -- 操作人
  p_array_lotterys                   in type_lottery_list,                 -- 入库的彩票对象

 ---------出口参数---------
  c_errorcode                        out number,                           -- 错误编码
  c_errormesg                        out string                            -- 错误原因

 ) is

   v_ar_no                 char(10);                                       -- 站点入库单编号
   v_sgr_no                char(10);                                       -- 入库单编号
   v_org                   char(2);                                        -- 销售站所属机构
   v_loop_i                number(10);                                     -- 循环使用的参数
   v_area_code             char(4);                                        -- 销售站所属区域

   v_balance               number(28);                                     -- 账户余额
   v_f_balance             number(28);                                     -- 冻结账户余额

   v_detail_list           type_lottery_detail_list;                       -- 彩票对象明细
   v_stat_list             type_lottery_statistics_list;                   -- 按照方案和批次统计的金额和票数
   type type_detail        is table of wh_goods_receipt_detail%rowtype;
   v_insert_detail         type_detail;                                    -- 插入入库明细的数组

   v_sale_info             flow_sale%rowtype;                              -- 销售明细
   type type_sale          is table of flow_sale%rowtype;
   v_sale_list             type_sale;                                      -- 销售明细数组

   v_total_tickets         number(20);                                     -- 当此入库的总票数
   v_total_amount          number(28);                                     -- 当此入库的总金额
   v_plan_publish          number(1);                                      -- 印制厂商编号

   v_comm_amount           number(18);                                     -- 销售佣金
   v_comm_rate             number(18);                                     -- 销售佣金比例

   v_err_code              number(10);                                     -- 调用存储过程时，返回值
   v_err_msg               varchar2(4000);                                 -- 调用存储过程时，返回错误信息
   v_temp_tickets          number(18);                                     -- 临时变量。削减管理员库存时，判断是否削减到负值
   v_temp_amount           number(28);                                     -- 临时变量。削减管理员库存时，判断是否削减到负值

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

   -- 检查是否输入了彩票对象
   if p_array_lotterys.count = 0 then
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_109; -- 输入参数中，没有发现彩票对象
      return;
   end if;

   -- 检查输入的参数是否有“自包含”的情况
   if f_check_ticket_perfect(p_array_lotterys) then
      c_errorcode := 3;
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
   /******************* 按照入库明细，更新“即开票信息”表中各个对象的属性；同时统计彩票统计信息 *************************/

   -- 初始化数组
   v_insert_detail := type_detail();
   v_total_tickets := 0;
   v_total_amount := 0;
   v_comm_amount := 0;

   v_sale_list := type_sale();

   -- 根据明细数据，更新“即开票”状态
   p_ticket_perferm(p_array_lotterys, p_oper, eticket_status.in_mm, eticket_status.saled, p_oper, p_agency, v_err_code, v_err_msg);
   if v_err_code <> 0 then
      rollback;
      c_errorcode := 1;
      c_errormesg := error_msg.err_common_104 || v_err_msg; -- 更新“即开票”状态时，出现错误
      return;
   end if;

   -- 统计入库对象的票数据
   p_lottery_detail_stat(p_array_lotterys, v_detail_list, v_stat_list, v_total_tickets, v_total_amount);

   -- 循环统计结果，按照方案批次，更新库管员库存，同时计算站点佣金
   for v_loop_i in 1 .. v_stat_list.count loop

      -- 更新仓库管理员库存信息
      update acc_mm_tickets
         set tickets = tickets - v_stat_list(v_loop_i).tickets,
             amount = amount - v_stat_list(v_loop_i).amount
       where market_admin = p_oper
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

      -- 获取站点的佣金比例
      begin
         select sale_comm into v_comm_rate from game_agency_comm_rate where agency_code = p_agency and plan_code = v_stat_list(v_loop_i).plan_code;
      exception
         when no_data_found then
            rollback;
            c_errorcode := 15;
            c_errormesg := dbtool.format_line(p_agency) || dbtool.format_line(v_stat_list(v_loop_i).plan_code) || error_msg.err_p_ar_inbound_15; -- 该销售站未设置此方案对应的销售佣金比例
            return;
      end;

      v_comm_amount := v_comm_amount + trunc(v_stat_list(v_loop_i).amount * v_comm_rate / 1000);

      -- 记录销售记录
      v_sale_info.sale_flow := f_get_flow_sale_seq;
      v_sale_info.agency_code := p_agency;
      v_sale_info.area_code := null;
      v_sale_info.org_code := null;
      v_sale_info.plan_code := v_stat_list(v_loop_i).plan_code;
      v_sale_info.batch_no := v_stat_list(v_loop_i).batch_no;
      v_sale_info.trunks := v_stat_list(v_loop_i).trunks;
      v_sale_info.boxes := v_stat_list(v_loop_i).boxes;
      v_sale_info.packages := v_stat_list(v_loop_i).packages;
      v_sale_info.tickets := v_stat_list(v_loop_i).tickets;
      v_sale_info.sale_amount := v_stat_list(v_loop_i).amount;
      v_sale_info.comm_amount := trunc(v_stat_list(v_loop_i).amount * v_comm_rate / 1000);
      v_sale_info.comm_rate := v_comm_rate;
      v_sale_info.sale_time := sysdate;
      v_sale_info.ar_no := null;
      v_sale_info.sgr_no := null;

      v_sale_list.extend;
      v_sale_list(v_sale_list.count) := v_sale_info;

   end loop;


   /********************************************************************************************************************************************************************/
   /******************* 新增“站点入库单”信息，新增“入库单”，获取主键值； *************************/
   select org_code
     into v_org
     from inf_agencys
    where agency_code = p_agency;

   select area_code
     into v_area_code
     from INF_AGENCYS
    where agency_code = p_agency;

   -- 创建“站点入库单”
   insert into sale_agency_receipt
      (ar_no,              ar_admin, ar_date, ar_agency,  tickets,         amount)
   values
      (f_get_sale_ar_seq,  p_oper,   sysdate, p_agency,   v_total_tickets, v_total_amount)
   returning
      ar_no
   into
      v_ar_no;

   -- 创建“入库单”
   insert into wh_goods_receipt
      (sgr_no,                      create_admin,              receipt_end_time,          receipt_amount,            receipt_tickets,
       act_receipt_amount,          act_receipt_tickets,       receipt_type,              ref_no,                    status,
       receive_org,                 receive_wh,                send_admin)
   values
      (f_get_wh_goods_receipt_seq,  p_oper,                    sysdate,                   v_total_amount,            v_total_tickets,
       v_total_amount,              v_total_tickets,           ereceipt_type.agency,      v_ar_no,                   eboolean.yesorenabled,
       v_org,                       p_agency,                  p_oper)
   returning
      sgr_no
   into
      v_sgr_no;

   -- 插入入库明细
   for v_loop_i in 1 .. v_detail_list.count loop
      v_insert_detail.extend;
      v_insert_detail(v_loop_i).sgr_no := v_sgr_no;
      v_insert_detail(v_loop_i).ref_no := v_ar_no;
      v_insert_detail(v_loop_i).sequence_no := f_get_wh_goods_receipt_det_seq;
      v_insert_detail(v_loop_i).receipt_type := ereceipt_type.agency;

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

   -- 补充销售记录明细，然后生成销售记录
   for v_loop_i in 1 .. v_sale_list.count loop
      v_sale_list(v_loop_i).area_code := v_area_code;
      v_sale_list(v_loop_i).org_code := v_org;
      v_sale_list(v_loop_i).ar_no := v_ar_no;
      v_sale_list(v_loop_i).sgr_no := v_sgr_no;
   end loop;

   forall v_loop_i in 1 .. v_sale_list.count
      insert into flow_sale values v_sale_list(v_loop_i);

   /********************************************************************************************************************************************************************/
   /******************* 执行资金扣减操作，如果余额不足，则报错，返回 *************************/
   /******************* 增加账户流水，类型为“销售”，同时增加账户流水，类型为“销售代销费”； *************************/
   -- 增加账户流水，类型为“销售”
   p_agency_fund_change(p_agency, eflow_type.sale, v_total_amount, 0, v_ar_no, v_balance, v_f_balance);

   -- 增加账户流水，类型为“销售代销费”
   p_agency_fund_change(p_agency, eflow_type.sale_comm, v_comm_amount, 0, v_ar_no, v_balance, v_f_balance);

   update sale_agency_receipt
      set before_balance = v_balance + v_total_amount - v_comm_amount,
          after_balance = v_balance
    where ar_no = v_ar_no;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;

