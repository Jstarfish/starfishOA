create or replace procedure p_batch_inbound_all
/****************************************************************/
   ------------------- 彩票批量批次入库 -------------------
   ---- 彩票批量批次入库。用于系统初始上线时，从各个分公司入库的情形。
   ----     通过循环调用p_batch_inbound来实现。
   ----     输出结果中，会显示未正确入库的对象，以及对应的错误信息。
   ---- 执行过程：
   ----     1、对输入的彩票类型进行排序操作，对每一个方案进行循环调用存储过程
   ----     2、调用存储过程之前，需要检查这个方案是否已经有相应的批次入库信息，如果有就设置类型为新增，否则为追加

   /*************************************************************/
(
 --------------输入----------------
 p_warehouse         in char,                               -- 仓库
 p_oper              in number,                             -- 操作人
 p_array_lotterys    in type_lottery_list,                  -- 入库的彩票对象

 ---------出口参数---------
 c_err_list          out type_lottery_import_err_list,      -- 批次错误列表
 c_errorcode         out number,                            -- 错误编码
 c_errormesg         out string                             -- 错误原因

 ) is

   v_err_info              type_lottery_import_err_info;
   v_err_list              type_lottery_import_err_list;

   v_plan_objs             type_lottery_list;

   v_bi_no                 char(10);                                       -- 批次入库单编号(bi12345678)
   v_oper_type             number(1);                                      -- 操作类型(1-新增，2-继续)

   v_err_code              number(10);
   v_err_msg               varchar2(4000);

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

   /*----------- 业务逻辑   -----------------*/
   for lottery_plan in (select distinct plan_code,batch_no from table(p_array_lotterys) order by plan_code,batch_no) loop
      v_oper_type := 0;
      begin
         select bi_no
           into v_bi_no
           from wh_batch_inbound
          where plan_code = lottery_plan.plan_code
            and batch_no = lottery_plan.batch_no;
      exception
         when no_data_found then
            v_bi_no := null;
            v_oper_type := 1;
      end;
      if v_bi_no is not null then
         v_oper_type := 2;
      end if;

     -- 确定入库的对象
     select type_lottery_info(plan_code ,batch_no ,valid_number,trunk_no ,box_no ,box_no_e ,package_no ,package_no_e, reward_group)
       bulk collect into v_plan_objs
       from table(p_array_lotterys)
      where plan_code = lottery_plan.plan_code
        and batch_no = lottery_plan.batch_no;

      -- 调用存储过程
      p_batch_inbound(p_inbound_no => v_bi_no,
                      p_plan => lottery_plan.plan_code,
                      p_batch => lottery_plan.batch_no,
                      p_warehouse => p_warehouse,
                      p_oper_type => v_oper_type,
                      p_oper => p_oper,
                      p_array_lotterys => v_plan_objs,
                      c_inbound_no => v_bi_no,
                      c_errorcode => v_err_code,
                      c_errormesg => v_err_msg);
      if v_err_code <> 0 then
         v_err_info := type_lottery_import_err_info(lottery_plan.plan_code, lottery_plan.batch_no, v_err_code, v_err_msg);
         v_err_list.extend;
         v_err_list(v_err_list.count) := v_err_info;
      end if;
   end loop;

   c_err_list := v_err_list;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
