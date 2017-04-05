create or replace procedure p_lottery_reward2
/****************************************************************/
   ------------------- 旧票验奖 -------------------
   ---- 功能说明
   ----     输入待演讲的数组、兑奖人，输出兑奖不成功的数组、提交票数、失败的新票数、成功验奖票数、成功验奖金额；
   ----
   ----     检查兑奖人的合法性
   ----     循环
   ----         检查是否为新票。检查wh_ticket_package中是否存在相应的package
   ----         检索保安区码，确定是那种情况。通过方案、批次和安全码，匹配数据
   ----             判断是否中奖。记录是否存在
   ----             判断是否已经兑奖。is_paid字段值是否为1
   ----             处理验奖流程。更新is_paid字段值，插入数据，检索中奖金额

   ---- add by 陈震: 2015-12-16
   ---- 涉及的业务表：
   ----     2.1.9.1 旧票兑奖主表（SWITCH_SCAN）                                        -- 新增
   ----     2.1.9.2 旧票兑奖子表（SWITCH_SCAN_DETAIL）                                 -- 新增
   ----     2.1.4.6 批次信息导入之奖符（GAME_BATCH_IMPORT_REWARD）                     -- 检索
   ----     2.1.4.7 批次信息导入之中奖明细（GAME_BATCH_REWARD_DETAIL）                 -- 更新

   ---- 业务流程：
   ----     1、

   /*************************************************************/
(
  --------------输入----------------
  p_oper                               in number,                             -- 操作人
  p_array_lotterys                     in type_lottery_reward_list,           -- 验奖的彩票对象

  ---------出口参数---------
  c_check_result                       out type_mm_check_lottery_list,        -- 验奖失败对象列表
  c_apply_tickets                      out number,                            -- 提交票数
  c_fail_tickets_new                   out number,                            -- 失败的新票数
  c_reward_tickets                     out number,                            -- 完成验奖票数
  c_reward_amount                      out number,                            -- 完成验奖金额
  c_pay_flow                           out varchar2,                          -- 验奖序号
  c_errorcode                          out number,                            -- 错误编码
  c_errormesg                          out string                             -- 错误原因

 ) is

   v_count                             number(5);                             -- 求记录数的临时变量
   v_old_pay_flow                      char(24);                              -- 旧票验奖记录数
   v_oper_org                          char(2);                               -- 操作人员所属机构
   v_reward_info                       game_batch_reward_detail%rowtype;      -- 兑奖票信息
   v_return_ticket_info                type_mm_check_lottery_info;            -- 返回的彩票对象

   v_apply_tickets                     number(18);
   v_fail_new_tickets                  number(18);
   v_succ_tickets                      number(18);
   v_succ_amount                       number(28);

   v_reward_amount                     number(18);                            -- 奖金
   v_reward_level                      number(2);                             -- 奖级
   v_pay_time                          date;                                  -- 兑奖时间

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   c_reward_amount := 0;

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;


   /*----------- 业务逻辑   -----------------*/
   -- 设置默认的兑奖时间
   v_pay_time := sysdate;

   -- 获取操作人员所属机构
   v_oper_org := f_get_admin_org(p_oper);

   -- 插入主表
   insert into SWITCH_SCAN (old_pay_flow,        paid_time,  paid_admin, paid_org,   apply_tickets, fail_new_tickets, succ_tickets, succ_amount)
                    values (f_get_switch_no_seq, v_pay_time, p_oper,     v_oper_org, 0,             0,                0,            0)
              returning old_pay_flow into v_old_pay_flow;

   -- 计数器初始化置零
   v_apply_tickets := 0;
   v_fail_new_tickets := 0;
   v_succ_tickets := 0;
   v_succ_amount := 0;
   c_check_result := type_mm_check_lottery_list();

   -- 循环开始
   for itab in (select * from table(p_array_lotterys)) loop
      -- 累计票数
      v_apply_tickets := v_apply_tickets + 1;

      -- 如果是“爱心方案”，按照系统参数判断是否可用
      if itab.plan_code = 'J2014' and f_get_sys_param(15) <> '1' then
         insert into switch_scan_detail (old_pay_flow,           old_pay_seq,      paid_time,             paid_admin,      paid_org,
                                         plan_code,              batch_no,         package_no,            ticket_no,       security_code,
                                         paid_status,            reward_amount,    is_new_ticket)
         values                         (v_old_pay_flow,         f_get_switch_seq, v_pay_time,            p_oper,          v_oper_org,
                                         itab.plan_code,         itab.batch_no,    itab.package_no,       itab.ticket_no,  itab.security_code,
                                         epaid_status.terminate, 0,                eboolean.noordisabled);

         v_return_ticket_info := type_mm_check_lottery_info(itab.plan_code, itab.batch_no, evalid_number.ticket, null, null, itab.package_no, 1, epaid_status.terminate);
         c_check_result.extend;
         c_check_result(c_check_result.count) := v_return_ticket_info;

         continue;
      end if;

      -- 检查是否为新票
      select count(*) into v_count from dual where exists(select 1 from wh_ticket_package where plan_code = itab.plan_code and batch_no = itab.batch_no and package_no = itab.package_no);
      if v_count = 1 then
         v_fail_new_tickets := v_fail_new_tickets + 1;
         insert into switch_scan_detail (old_pay_flow,           old_pay_seq,      paid_time,             paid_admin,      paid_org,
                                         plan_code,              batch_no,         package_no,            ticket_no,       security_code,
                                         paid_status,            reward_amount,    is_new_ticket)
         values                         (v_old_pay_flow,         f_get_switch_seq, v_pay_time,            p_oper,          v_oper_org,
                                         itab.plan_code,         itab.batch_no,    itab.package_no,       itab.ticket_no,  itab.security_code,
                                         epaid_status.newticket, 0,                eboolean.yesorenabled);

         v_return_ticket_info := type_mm_check_lottery_info(itab.plan_code, itab.batch_no, evalid_number.ticket, null, null, itab.package_no, 1, epaid_status.newticket);
         c_check_result.extend;
         c_check_result(c_check_result.count) := v_return_ticket_info;

         continue;
      end if;

      -- 检索相应的兑奖信息
      begin
         select * into v_reward_info from game_batch_reward_detail where plan_code = itab.plan_code and batch_no = itab.batch_no and safe_code = itab.security_code;
       exception
         when no_data_found then
            -- 没有中奖
            insert into switch_scan_detail (old_pay_flow,           old_pay_seq,      paid_time,             paid_admin,      paid_org,
                                            plan_code,              batch_no,         package_no,            ticket_no,       security_code,
                                            paid_status,            reward_amount,    is_new_ticket)
            values                         (v_old_pay_flow,         f_get_switch_seq, v_pay_time,            p_oper,          v_oper_org,
                                            itab.plan_code,         itab.batch_no,    itab.package_no,       itab.ticket_no,  itab.security_code,
                                            epaid_status.nowin,     0,                eboolean.noordisabled);

            v_return_ticket_info := type_mm_check_lottery_info(itab.plan_code, itab.batch_no, evalid_number.ticket, null, null, itab.package_no, 1, epaid_status.nowin);
            c_check_result.extend;
            c_check_result(c_check_result.count) := v_return_ticket_info;

            continue;
       end;

      -- 已经兑奖
      if v_reward_info.IS_PAID = eboolean.yesorenabled then

         -- 获取中奖信息
         select single_reward_amount, reward_no
           into v_reward_amount, v_reward_level
           from game_batch_import_reward
          where plan_code = itab.plan_code
            and batch_no = itab.batch_no
            and instr(fast_identity_code, substr(itab.security_code, epublisher_sjz.fast_identity_code_pos, epublisher_sjz.len_fast_identity_code)) > 0;

         insert into switch_scan_detail (old_pay_flow,           old_pay_seq,      paid_time,             paid_admin,      paid_org,
                                         plan_code,              batch_no,         package_no,            ticket_no,       security_code,
                                         paid_status,            reward_amount,    is_new_ticket)
         values                         (v_old_pay_flow,         f_get_switch_seq, v_pay_time,            p_oper,          v_oper_org,
                                         itab.plan_code,         itab.batch_no,    itab.package_no,       itab.ticket_no,  itab.security_code,
                                         epaid_status.paid,      v_reward_amount,  eboolean.noordisabled);

         -- 更新返回结果集（复用box_no作为中奖金额）
         v_return_ticket_info := type_mm_check_lottery_info(itab.plan_code, itab.batch_no, evalid_number.ticket, null, v_reward_amount, itab.package_no, 1, epaid_status.paid);
         c_check_result.extend;
         c_check_result(c_check_result.count) := v_return_ticket_info;

         continue;
      end if;

      -- 更新中奖标志
      update game_batch_reward_detail
         set is_paid = eboolean.yesorenabled
       where plan_code = itab.plan_code
         and batch_no = itab.batch_no
         and safe_code = itab.security_code;

      -- 获取中奖信息
      select single_reward_amount, reward_no
        into v_reward_amount, v_reward_level
        from game_batch_import_reward
       where plan_code = itab.plan_code
         and batch_no = itab.batch_no
         and instr(fast_identity_code, substr(itab.security_code, epublisher_sjz.fast_identity_code_pos, epublisher_sjz.len_fast_identity_code)) > 0;

      -- 插入中奖纪录
      insert into switch_scan_detail (old_pay_flow,           old_pay_seq,      paid_time,             paid_admin,      paid_org,
                                      plan_code,              batch_no,         package_no,            ticket_no,       security_code,
                                      paid_status,            reward_amount,    is_new_ticket)
      values                         (v_old_pay_flow,         f_get_switch_seq, v_pay_time,            p_oper,          v_oper_org,
                                      itab.plan_code,         itab.batch_no,    itab.package_no,       itab.ticket_no,  itab.security_code,
                                      epaid_status.succed,    v_reward_amount,  eboolean.noordisabled);

      -- 更新统计值
      v_succ_tickets := v_succ_tickets + 1;
      v_succ_amount := v_succ_amount + v_reward_amount;

      -- 更新返回结果集（复用box_no作为中奖金额）
      v_return_ticket_info := type_mm_check_lottery_info(itab.plan_code, itab.batch_no, evalid_number.ticket, null, v_reward_amount, itab.package_no, 1, epaid_status.succed);
      c_check_result.extend;
      c_check_result(c_check_result.count) := v_return_ticket_info;

   end loop;

   c_apply_tickets := v_apply_tickets;
   c_fail_tickets_new := v_fail_new_tickets;
   c_reward_tickets := v_succ_tickets;
   c_reward_amount := v_succ_amount;
   c_pay_flow := v_old_pay_flow;

   update SWITCH_SCAN
      set apply_tickets = v_apply_tickets,
          fail_new_tickets = v_fail_new_tickets,
          succ_tickets = v_succ_tickets,
          succ_amount = v_succ_amount
    where old_pay_flow = v_old_pay_flow;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
