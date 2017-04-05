create or replace procedure p_batch_end
/****************************************************************/
   ------------------- 批次终结 -------------------
   ---- 批次终结。
   ----     查询各种彩票的状态，如果都处于“11-在库、31-已销售、41-被盗、42-损坏、43-丢失”状态时，就可以进行批次终结。
   ----     终结时
   ----        1、需要设置“2.1.4.5 批次信息导入之包装（game_batch_import_detail）”中的状态为“退市”
   ----        2、统计销售金额、兑奖金额、库存张数
   ----        3、插入批次终结表，统计数据
   ---- add by 陈震: 2015/9/19
   ---- 涉及的业务表：
   ----     2.1.4.5 批次信息导入之包装（game_batch_import_detail）   -- 更新
   ----     2.1.5.18 批次终结（wh_batch_end）                        -- 新增
   ----     2.1.5.3 即开票信息（箱）            -- 更新
   ----     2.1.5.4 即开票信息（盒）            -- 更新
   ----     2.1.5.5 即开票信息（本）            -- 更新
   ---- 业务流程：
   ----     1、校验输入参数。（操作人是否合法；）
   ----     2、查询各种彩票的状态，合法时，就可以进行批次终结。
   ----     3、统计销售金额、兑奖金额、库存张数
   ----     4、插入批次终结表，统计数据

   /*************************************************************/
(
   --------------输入----------------
   p_plan          in varchar2,                                                -- 方案号码
   p_batch         in varchar2,                                              -- 批次号码
   p_oper          in number,                                              -- 操作人

   ---------出口参数---------
   c_errorcode out number,                                                 --错误编码
   c_errormesg out string                                                  --错误原因

 ) is

   v_count                 number(5);                                      -- 求记录数的临时变量
   v_collect_batch_end     wh_batch_end%rowtype;                           -- 批次终结表行结果集
   v_collect_batch_param   game_batch_import_detail%rowtype;               -- 批次参数

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_p_batch_end_1; -- 无此人
      return;
   end if;

   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* 查询各种彩票的状态，合法时，就可以进行批次终结。 *************************/

   -- 获取批次参数
   select * into v_collect_batch_param from game_batch_import_detail where plan_code = p_plan and batch_no = p_batch;

   -- 统计销售金额、兑奖金额、库存张数
   select count(*)
     into v_collect_batch_end.sale_amount
     from wh_ticket_package
    where plan_code = p_plan
     and batch_no = p_batch
     and status = eticket_status.saled;

   -- 统计兑奖金额
   select nvl(sum(pay_amount), 0)
     into v_collect_batch_end.pay_amount
     from flow_pay
    where plan_code = p_plan
      and batch_no = p_batch;

   -- 统计库存张数
   select nvl(sum(packs), 0) * v_collect_batch_param.tickets_every_pack
     into v_collect_batch_end.inventory_tickets
     from (
            select (to_number(package_no_end) - to_number(package_no_start)) packs from wh_ticket_trunk  where plan_code = p_plan and batch_no = p_batch and status = eticket_status.in_warehouse
            union all
            select (to_number(package_no_end) - to_number(package_no_start)) packs from wh_ticket_box  where plan_code = p_plan and batch_no = p_batch and status = eticket_status.in_warehouse
            union all
            select count(*) packs from wh_ticket_box  where plan_code = p_plan and batch_no = p_batch and status = eticket_status.in_warehouse
          );

   -- 插入数据
   insert into wh_batch_end
      (be_no,                             plan_code,                      batch_no,                               tickets,
       sale_amount,                       pay_amount,                     inventory_tickets,                      create_admin,                                create_date)
   values
      (f_get_wh_batch_end_seq,            p_plan,                         p_batch,                                v_collect_batch_param.tickets_every_batch,
       v_collect_batch_end.sale_amount,   v_collect_batch_end.pay_amount, v_collect_batch_end.inventory_tickets,  p_oper,                                      sysdate);

   -- 修改状态
   update game_batch_import_detail
      set status = ebatch_item_status.quited
    where plan_code = p_plan
      and batch_no = p_batch;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;
end;

