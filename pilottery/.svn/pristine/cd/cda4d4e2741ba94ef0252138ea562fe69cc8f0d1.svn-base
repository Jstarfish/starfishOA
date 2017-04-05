create or replace procedure p_mm_inv_check
/****************************************************************/
   ------------------- 市场管理员库存盘点 -------------------
   ---- add by 陈震: 2015-12-08
   ----   输入一个彩票数组，确定出市场管理员的库存情况（以本为单位），返回两个数组。
   ----   1、显示彩票不在这个管理员手中的；
   ----   2、应该在管理员库存，但是未扫描的彩票

   ---- modify by 陈震: 2016-10-13
   ----   修改盘点 结果为是否一致。1=一致，0=不一致

   /*************************************************************/
(
 --------------输入----------------
  p_oper                               in number,                             -- 市场管理员
  p_array_lotterys                     in type_mm_check_lottery_list,         -- 输入的彩票对象

  ---------出口参数---------
  c_array_lotterys                     out type_mm_check_lottery_list,        -- 输出的彩票对象
  c_inv_tickets                        out number,                            -- 管理员库存彩票数量
  c_check_tickets                      out number,                            -- 本次盘点中，属于管理员的彩票数量
  c_diff_tickets                       out number,                            -- 未盘点的管理员彩票数量
  c_scan_tickets                       out number,                            -- 本次扫描数量
  c_errorcode                          out number,                            -- 错误编码
  c_errormesg                          out string                             -- 错误原因

 ) is

   v_tmp_lotterys                      type_mm_check_lottery_list;            -- 库存彩票对象
   v_out_lotterys                      type_mm_check_lottery_list;            -- 临时彩票对象
   v_s1_lotterys                       type_mm_check_lottery_list;            -- 临时彩票对象
   v_s2_lotterys                       type_mm_check_lottery_list;            -- 临时彩票对象

   v_cp_no                             char(10);

begin

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  c_inv_tickets := 0;
  c_check_tickets := 0;
  c_diff_tickets := 0;

  /*----------- 数据校验   -----------------*/
  -- 校验入口参数是否正确，对应的数据记录是否存在
  if not f_check_admin(p_oper) then
    c_errorcode := 1;
    c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
    return;
  end if;

  /*----------- 业务逻辑   -----------------*/
  /********************************************************************************************************************************************************************/
  -- 获取管理员所有彩票对象（本）
  select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, (ticket_no_end - ticket_no_start + 1), 0)
    bulk collect into v_tmp_lotterys
    from wh_ticket_package
   where status = 21
     and current_warehouse = p_oper;

  -- 生成管理员库存数量
  select sum(tickets)
    into c_inv_tickets
    from table(v_tmp_lotterys);
  c_inv_tickets := nvl(c_inv_tickets, 0);

  -- 生成本次扫描数量
  c_scan_tickets := p_array_lotterys.count;

  /********************************************************************************************************************************************************************/
  -- 看看输入的彩票中，有多少本是在库存管理员手中的.统计交集的票数量，为盘点数量
  select sum(src.tickets)
    into c_check_tickets
    from table(p_array_lotterys) dest
    join table(v_tmp_lotterys) src
   using (plan_code, batch_no, package_no);
  c_check_tickets := nvl(c_check_tickets, 0);

  -- 本次盘点后，管理员有多少票没有被盘点
  c_diff_tickets := nvl(c_inv_tickets,0) - nvl(c_check_tickets, 0);

  /********************************************************************************************************************************************************************/
  -- 获取未扫描的票
  select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, 0, 2)
   bulk collect into v_s2_lotterys
   from (
       select plan_code, batch_no, package_no from table(v_tmp_lotterys)
       minus
       select plan_code, batch_no, package_no from table(p_array_lotterys));

  -- 显示不在管理员手中的票
  select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, 0, 1)
   bulk collect into v_s1_lotterys
   from (
       select plan_code, batch_no, package_no from table(p_array_lotterys)
       minus
       select plan_code, batch_no, package_no from table(v_tmp_lotterys));

  -- 合并结果
  select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, tickets, status)
   bulk collect into v_out_lotterys
   from (
       select plan_code, batch_no, package_no, tickets, status from table(v_s1_lotterys)
       union all
       select plan_code, batch_no, package_no, tickets, status from table(v_s2_lotterys));

  c_array_lotterys := v_out_lotterys;

  -- 插入数据库
  v_cp_no := f_get_wh_check_point_seq;

  insert into wh_mm_check
    (cp_no,              manager_id,           result,
     inv_tickets,        check_tickets,        diff_tickets,
     scan_tickets,       cp_date)
  values
    (v_cp_no,            p_oper,               (case when c_diff_tickets = 0 then 1 else 0 end ),
     c_inv_tickets,      c_check_tickets,      c_diff_tickets,
     c_scan_tickets,     sysdate);

  if c_array_lotterys.count > 0 then
    forall i in 1 .. c_array_lotterys.count
      insert into wh_mm_check_detail
        (cp_detail_no,                      cp_no,                        manager_id,
         plan_code,                         batch_no,                     valid_number,
         trunk_no,                          box_no,                       package_no,
         tickets,                           status)
      values
        (f_get_wh_check_point_seq,          v_cp_no,                      p_oper,
         c_array_lotterys(i).plan_code,     c_array_lotterys(i).batch_no, c_array_lotterys(i).valid_number,
         c_array_lotterys(i).trunk_no,      c_array_lotterys(i).box_no,   c_array_lotterys(i).package_no,
         c_array_lotterys(i).tickets,       c_array_lotterys(i).status);

  end if;

  commit;

exception
  when others then
    c_errorcode := 100;
    c_errormesg := error_msg.err_common_1 || sqlerrm;
    rollback;
end;
