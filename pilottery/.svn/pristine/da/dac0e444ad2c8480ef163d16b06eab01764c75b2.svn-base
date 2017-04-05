create or replace procedure p_lottery_reward_all
/****************************************************************/
   ------------------- 批量兑奖 -------------------
   ---- 兑奖
   ----     判断销售站是否设置过代销费比率
   ----     循环调用兑奖存储过程，完成兑奖操作

   ---- add by 陈震: 2015-12-07
   ---- 涉及的业务表：
   ----     2.1.4.6 批次信息导入之奖符（game_batch_import_reward）                     -- 更新
   ----     2.1.4.7 批次信息导入之中奖明细（game_batch_reward_detail）                 -- 更新
   ----     2.1.7.1 gui兑奖信息记录表（flow_gui_pay）                                  -- 新增
   ----     2.1.7.2 兑奖记录（flow_pay）                                               -- 新增
   ----     2.1.7.4 站点资金流水（flow_agency）                                        -- 新增

   ---- 业务流程：
   ----     1、校验输入参数。（仓库是否存在；操作类型是否为新、继续、完结；操作人是否合法；）
   ----     2、判断此张彩票是否已经销售，没有的话，就不能兑奖；
   ----     3、查询兑奖记录，判断此张彩票是否已经进行过兑奖，如果已经兑奖，返回失败；
   ----     4、更新

   /*************************************************************/
(
  --------------输入----------------
  p_oper                               in number,                          -- 操作人
  p_pay_agency                         in char,                            -- 兑奖销售站
  p_array_lotterys                     in type_lottery_reward_list,        -- 兑奖的彩票对象

  ---------出口参数---------
  c_seq_no                             out string,                         -- 兑奖序号
  c_errorcode                          out number,                         -- 错误编码
  c_errormesg                          out string                          -- 错误原因

 ) is

   v_count                 number(5);                                      -- 求记录数的临时变量

   v_djxq_no               char(24);                                       -- 兑奖详情主键
   v_seq_no                number(24);                                     -- 兑奖字表主键

   v_reward_amount         number(18);                                     -- 奖金
   v_pay_flow              char(24);                                       -- 兑奖流水号
   v_c_err_code            number(3);                                      -- 错误代码
   v_c_err_msg             varchar2(4000);                                 -- 错误消息

   v_area_code             char(4);                                        -- 站点所属区域
   v_total_reward_amount   number(28);                                     -- 总奖金

   v_safe_code             varchar2(50);                                   -- 安全码

   v_publisher             number(2);                                      -- 印制厂商

   v_temp_string           varchar2(4000);

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

   v_temp_string := f_get_sys_param(2);
   if v_temp_string not in ('1', '2') then
      rollback;
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_pay_agency) || error_msg.err_p_lottery_reward_5; -- 系统参数值不正确，请联系管理员，重新设置
      return;
   end if;

   /*-- 检查站点的兑奖佣金比例
   with
      save_comm as (
         select plan_code,1 cnt from game_agency_comm_rate where agency_code = p_pay_agency),
      all_comm as (
         select distinct plan_code from table(p_array_lotterys)),
      result_tab as (
         select plan_code, cnt from all_comm left join save_comm using(plan_code))
   select count(*) into v_count from result_tab where cnt is null;
   if v_count > 0 then
      with
         save_comm as (
            select plan_code,1 cnt from game_agency_comm_rate where agency_code = p_pay_agency),
         all_comm as (
            select distinct plan_code from table(p_array_lotterys)),
         result_tab as (
            select plan_code, cnt from all_comm left join save_comm using(plan_code))
      select plan_code into v_plan from result_tab where cnt is null and rownum = 1;

      c_errorcode := 3;
      c_errormesg := dbtool.format_line(p_pay_agency) || dbtool.format_line(v_plan) || error_msg.err_p_lottery_reward_6; -- 该销售站未设置此方案对应的兑奖佣金比例
      return;
   end if; */

   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* 开始兑奖 *************************/
   -- 获取销售站对应的区域码
   select area_code into v_area_code from inf_agencys where agency_code = p_pay_agency;

   -- 插入兑奖详情主表，提交
   v_count := p_array_lotterys.count;
   insert into sale_paid (djxq_no, pay_agency, area_code, payer_admin, plan_tickets)
                  values (f_get_flow_pay_detail_seq, p_pay_agency, v_area_code, p_oper, v_count)
                  returning djxq_no into v_djxq_no;

   v_total_reward_amount := 0;

   -- 循环输入记录
   for itab in (select * from table(p_array_lotterys)) loop
      -- 插入兑奖详情子表，并提交
      insert into sale_paid_detail (djxq_no, djxq_seq_no, plan_code, batch_no, package_no, ticket_no, security_code,
                                    is_old_ticket)
                            values (v_djxq_no, f_get_flow_pay_detail_no_seq, itab.plan_code, itab.batch_no, itab.package_no, itab.ticket_no, itab.security_code,
                                    f_get_reward_ticket_ver(itab.plan_code, itab.batch_no, itab.package_no))
                         returning djxq_seq_no into v_seq_no;

      -- 检查是否销售，检查的同时需要考虑新旧票
      begin
         select status into v_count from wh_ticket_package where plan_code = itab.plan_code and batch_no = itab.batch_no and package_no = itab.package_no;
      exception
         when no_data_found then
            -- 没有查询到记录，表示是旧票，旧票以已经销售论处
            v_count := eticket_status.saled;
      end;

      if v_count <> eticket_status.saled then
         update sale_paid_detail
            set paid_status = epaid_status.nosale
          where djxq_seq_no = v_seq_no;
         commit;
         continue;
      end if;

      -- 按照厂商，获取对应的安全码
      if f_get_reward_ticket_ver(itab.plan_code, itab.batch_no, itab.package_no) = 1 then
         v_publisher := epublisher_code.sjz;
      else
         v_publisher := f_get_plan_publisher(itab.plan_code);
      end if;

      case v_publisher
         when epublisher_code.sjz then

            -- 检查票是否中奖
            begin
               select single_reward_amount
                 into v_reward_amount
                 from game_batch_import_reward
                where plan_code = itab.plan_code
                  and batch_no = itab.batch_no
                  and instr(fast_identity_code, substr(itab.security_code, epublisher_sjz.fast_identity_code_pos, epublisher_sjz.len_fast_identity_code)) > 0;
            exception
               when no_data_found then
                  update sale_paid_detail
                     set paid_status = epaid_status.nowin
                   where djxq_seq_no = v_seq_no;
                  commit;
                  continue;
            end;

            if v_reward_amount >= to_number(f_get_sys_param(5)) then
               update sale_paid_detail
                  set paid_status = epaid_status.bigreward,
                      reward_amount = v_reward_amount
                where djxq_seq_no = v_seq_no;
               commit;
               continue;
            end if;

         when epublisher_code.zc3c then
            begin
               select safe_code
                 into v_safe_code
                 from game_batch_reward_detail
                where plan_code = itab.plan_code
                  and batch_no = itab.batch_no
                  and pre_safe_code = substr(itab.security_code, 1, 16);

               -- 已经中奖，再检索中奖级别和中奖金额
               select single_reward_amount
                 into v_reward_amount
                 from game_batch_import_reward
                where plan_code = itab.plan_code
                  and batch_no = itab.batch_no
                  and instr(fast_identity_code, substr(v_safe_code, epublisher_sjz.fast_identity_code_pos, epublisher_sjz.len_fast_identity_code)) > 0;

               if v_reward_amount >= to_number(f_get_sys_param(5)) then
                  update sale_paid_detail
                     set paid_status = epaid_status.bigreward,
                         reward_amount = v_reward_amount
                   where djxq_seq_no = v_seq_no;
                  commit;
                  continue;
               end if;
            exception
               when no_data_found then
                  update sale_paid_detail
                     set paid_status = epaid_status.nowin
                   where djxq_seq_no = v_seq_no;
                  commit;
                  continue;
            end;

      end case;

      -- 调用存储过程
      p_lottery_reward(itab.security_code, null, null, null, null, null, 3, itab.plan_code, itab.batch_no, itab.package_no, itab.ticket_no, p_oper, p_pay_agency, sysdate,
                       v_reward_amount, v_pay_flow, v_c_err_code, v_c_err_msg);

      -- 根据存储过程返回结果，更新兑奖详情子表，并提交
      case
         -- 成功
         when v_c_err_code in (0) then
            update sale_paid_detail
               set paid_status = epaid_status.succed,
                   pay_flow = v_pay_flow,
                   reward_amount = v_reward_amount
             where djxq_seq_no = v_seq_no;
            update sale_paid
               set succ_tickets = succ_tickets + 1
             where djxq_no = v_djxq_no;

             v_total_reward_amount := v_total_reward_amount + v_reward_amount;

         -- 非法票
         when v_c_err_code in (2) then
            update sale_paid_detail
               set paid_status = epaid_status.invalid
             where djxq_seq_no = v_seq_no;

         -- 非法票
         when v_c_err_code in (3) then
            update sale_paid_detail
               set paid_status = epaid_status.terminate
             where djxq_seq_no = v_seq_no;

         -- 已兑奖
         when v_c_err_code in (5) then
            update sale_paid_detail
               set paid_status = epaid_status.paid
             where djxq_seq_no = v_seq_no;

         -- 未销售
         when v_c_err_code in (4) then
            update sale_paid_detail
               set paid_status = epaid_status.nosale
             where djxq_seq_no = v_seq_no;

         -- 系统错误
         else
            c_errorcode := 100;
            c_errormesg := v_c_err_msg;
            return;

      end case;

      commit;

   end loop;

   update sale_paid set succ_amount = v_total_reward_amount where djxq_no = v_djxq_no;
   commit;

   c_seq_no := v_djxq_no;

exception
   when others then
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
