create or replace procedure p_lottery_reward
/****************************************************************/
   ------------------- 兑奖 -------------------
   ---- 兑奖
   ----     判断此张彩票是否已经销售，没有的话，就不能兑奖；
   ----     查询兑奖记录，判断此张彩票是否已经进行过兑奖，如果已经兑奖，返回失败；
   ----     更新“2.1.4.7 批次信息导入之中奖明细（game_batch_reward_detail）”，更新“2.1.4.6 批次信息导入之奖符（game_batch_import_reward）”，计数器+1；
   ----     获取此彩票的彩票包装信息和奖组，以及此彩票的中奖金额，还有彩票的销售站点；
   ----     新建“兑奖记录”，如果兑奖方式为“1=中心兑奖，2=手工兑奖”时，还需要新建“2.1.7.1 gui兑奖信息记录表（flow_gui_pay）”
   ----     如果是“站点兑奖”，那么，按照单票金额计算兑奖代销费，给兑奖站点加“兑奖金额”和“兑奖佣金”；如果是“中心兑奖”，那么要视系统参数（2），决定是否给销售彩票的销售站增加“兑奖佣金”；


   ---- add by 陈震: 2015/9/21
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

   ---- modify by 陈震 2016-01-22
   ---- 1、增加兑奖机构佣金表，保存兑奖时，产生的机构佣金数据
   ---- 2、站点兑奖和一级机构兑奖，无条件加佣金，总机构不计算佣金
   ---- 3、是否产生兑奖佣金，要看系统参数 16 是否计算分公司中心兑奖佣金（1=计算，2=不计算）；针对代理商的销售站，必须产生机构佣金记录

   ---- modify by 陈震 2016-02-26
   ---- 1、增加印制厂商判断。当方案为石家庄时，录入的安全码为全部安全码，可以直接在数据库中查询；如果方案为中彩三场，那么录入的安全码只获取前16位，然后查询其中奖标示，获取奖等。

   /*************************************************************/
(
  --------------输入----------------
  p_security_string                    in char,                               -- 保安区码（21位）
  p_name                               in char,                               -- 中奖人姓名
  p_contact                            in char,                               -- 中奖人联系方式
  p_id                                 in char,                               -- 中奖人证件号码
  p_age                                in number,                             -- 年龄
  p_sex                                in number,                             -- 性别(1-男，2-女)
  p_paid_type                          in number,                             -- 兑奖方式（1=中心兑奖，2=手工兑奖，3=站点兑奖）
  p_plan                               in char,                               -- 方案编号
  p_batch                              in char,                               -- 批次编号
  p_package_no                         in varchar2,                           -- 彩票本号
  p_ticket_no                          in varchar2,                           -- 票号
  p_oper                               in number,                             -- 操作人
  p_pay_agency                         in char,                               -- 兑奖销售站
  p_pay_time                           in date,                               -- 兑奖时间

  ---------出口参数---------
  c_reward_amount                      out number,                           -- 兑奖金额
  c_pay_flow                           out char,                             -- 兑奖序号
  c_errorcode                          out number,                           -- 错误编码
  c_errormesg                          out string                            -- 错误原因

 ) is

   v_count                 number(5);                                      -- 求记录数的临时变量
   v_agency                char(8);                                        -- 售票销售站

   v_reward_amount         number(18);                                     -- 奖金
   v_reward_level          number(2);                                      -- 奖级
   v_pay_flow              char(24);                                       -- 兑奖流水号

   v_comm_amount           number(18);                                     -- 彩票销售，销售站兑奖佣金
   v_comm_rate             number(18);                                     -- 彩票销售，销售站兑奖佣金比例

   v_single_ticket_amount  number(10);                                     -- 单票金额
   v_lottery_detail        type_lottery_info;                              -- 彩票对象详细信息

   v_area_code             char(4);                                        -- 站点所属区域
   v_admin_realname        varchar2(1000);                                 -- 操作人员名称

   v_sys_param             varchar2(10);                                   -- 系统参数值

   v_balance               number(28);                                     -- 账户余额
   v_f_balance             number(28);                                     -- 冻结账户余额

   v_pay_time              date;                                           -- 兑奖时间
   v_is_new_ticket         number(1);                                      -- 是否新票

   v_org                   char(2);                                        -- 组织结构代码
   v_org_type              number(2);                                      -- 组织机构类型

   v_security_string       varchar2(50);                                   -- 安全区码

   v_publisher             number(2);                                      -- 印制厂商

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   c_reward_amount := 0;
   v_is_new_ticket := eboolean.noordisabled;

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;

   -- 如果是“爱心方案”，按照系统参数判断是否可用
   if p_plan = 'J2014' and f_get_sys_param(15) <> '1' then
      c_errorcode := 3;
      c_errormesg := dbtool.format_line(p_plan) || dbtool.format_line('00001') || error_msg.err_p_ticket_perferm_5; -- 此批次的彩票方案已经停用
      return;
   end if;

   -- 如果是新票，那么需要检查以下数据
   if f_get_reward_ticket_ver(p_plan, p_batch, p_package_no) = 0 then

      -- 检查批次是否正确
      if not f_check_plan_batch(p_plan, p_batch) then
         c_errorcode := 2;
         c_errormesg := dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || error_msg.err_common_102; -- 无此方案和批次
         return;
      end if;

      -- 检查方案批次是否有效
      if not f_check_plan_batch_status(p_plan, p_batch) then
         c_errorcode := 3;
         c_errormesg := dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || error_msg.err_p_ticket_perferm_5; -- 此批次的彩票方案已经停用
         return;
      end if;

      v_is_new_ticket := eboolean.yesorenabled;

   end if;
   /*----------- 业务逻辑   -----------------*/
   -- 设置默认的兑奖时间
   if p_pay_time is null then
      v_pay_time := sysdate;
   else
      v_pay_time := p_pay_time;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* 判断此张彩票是否已经销售，没有的话，就不能兑奖 *************************/

   -- 获取彩票详细信息
   if v_is_new_ticket = eboolean.yesorenabled then
      v_lottery_detail := f_get_lottery_info(p_plan, p_batch, evalid_number.pack, p_package_no);
   else
      -- 针对旧票，数据统一填写“-”
      v_lottery_detail := type_lottery_info(p_plan, p_batch, evalid_number.pack, '-', '-', '-', p_package_no, p_package_no, 0);
   end if;

   -- 如果是新票，那么需要检查以下数据
   if v_is_new_ticket = eboolean.yesorenabled then

      -- 判断彩票是否销售
      begin
         select current_warehouse
           into v_agency
           from wh_ticket_package
          where plan_code = p_plan
            and batch_no = p_batch
            and package_no = p_package_no
            and p_ticket_no >= ticket_no_start
            and p_ticket_no <= ticket_no_end
            and status = eticket_status.saled;
      exception
         when no_data_found then
            c_errorcode := 4;
            c_errormesg := dbtool.format_line(p_package_no) || error_msg.err_p_lottery_reward_3;                       -- 彩票未被销售
            return;
      end;
   end if;

   /********************************************************************************************************************************************************************/
   /******************* 查询兑奖记录，判断此张彩票是否已经进行过兑奖，如果已经兑奖，返回失败 *************************/
   select count(*)
     into v_count
     from flow_pay
    where plan_code = p_plan
      and batch_no = p_batch
      and security_code = p_security_string;
   if v_count = 1 then
      c_errorcode := 5;
      c_errormesg := dbtool.format_line(p_ticket_no) || error_msg.err_p_lottery_reward_4;                       -- 彩票已兑奖
      return;
   end if;

   /********************************************************************************************************************************************************************/
   if f_get_reward_ticket_ver(p_plan, p_batch, p_package_no) = 1 then
      v_publisher := epublisher_code.sjz;
   else
      v_publisher := f_get_plan_publisher(p_plan);
   end if;

   case v_publisher
      when epublisher_code.sjz then
         -- 更新计数器和标志
         update game_batch_reward_detail
            set is_paid = eboolean.yesorenabled
          where plan_code = p_plan
            and batch_no = p_batch
            and safe_code = p_security_string;

         -- 获取奖级和奖金
         select single_reward_amount, reward_no
           into v_reward_amount, v_reward_level
           from game_batch_import_reward
          where plan_code = p_plan
            and batch_no = p_batch
            and instr(fast_identity_code, substr(p_security_string, epublisher_sjz.fast_identity_code_pos, epublisher_sjz.len_fast_identity_code)) > 0;

      when epublisher_code.zc3c then
         -- 更新计数器和标志
         update game_batch_reward_detail
            set is_paid = eboolean.yesorenabled
          where plan_code = p_plan
            and batch_no = p_batch
            and pre_safe_code = substr(p_security_string, 1, 16)
         returning safe_code into v_security_string;

         -- 获取奖级和奖金
         select single_reward_amount, reward_no
           into v_reward_amount, v_reward_level
           from game_batch_import_reward
          where plan_code = p_plan
            and batch_no = p_batch
            and instr(fast_identity_code, substr(v_security_string, epublisher_sjz.fast_identity_code_pos, epublisher_sjz.len_fast_identity_code)) > 0;

   end case;




   /********************************************************************************************************************************************************************/
   /******************* 进入数据计算 *************************/
   -- 获取单票金额
   begin
      select ticket_amount
        into v_single_ticket_amount
        from game_plans
       where plan_code = p_plan;
   exception
      when no_data_found then
         v_single_ticket_amount := 0;
   end;

   -- 获取操作人员名字
   begin
      select admin_realname into v_admin_realname from adm_info where admin_id = p_oper;
   exception
      when no_data_found then
         v_admin_realname := '';
   end;

   -- 获取系统参数2（中心兑奖，代销费属于“1-销售站点，2-不计算”）
   v_sys_param := f_get_sys_param(2);
   if v_sys_param not in ('1', '2') then
      rollback;
      c_errorcode := 6;
      c_errormesg := dbtool.format_line(v_agency) || dbtool.format_line(p_plan) || error_msg.err_p_lottery_reward_5; -- 系统参数值不正确，请联系管理员，重新设置
      return;
   end if;

   -- 中心兑奖不需要销售站
   if p_paid_type <> 1 then
      -- 获取站点的兑奖佣金比例
      v_comm_rate := f_get_agency_comm_rate(p_pay_agency, p_plan, p_batch, 2);
      if v_comm_rate = -1 then
         rollback;
         c_errorcode := 7;
         c_errormesg := dbtool.format_line(p_pay_agency) || dbtool.format_line(p_plan) || error_msg.err_p_lottery_reward_6; -- 该销售站未设置此方案对应的兑奖佣金比例
         return;
      end if;
   end if;

   case p_paid_type
      when 3 then                                                       -- 销售站兑奖
         -- 计算兑奖代销费
         v_comm_amount := trunc(v_reward_amount * v_comm_rate / 1000);

         -- 获取销售站对应的区域码
         select area_code into v_area_code from inf_agencys where agency_code = p_pay_agency;

         -- 建立兑奖记录
         insert into flow_pay
           (pay_flow,                  pay_agency,              area_code,                      pay_comm,       pay_comm_rate,
            plan_code,                 batch_no,                reward_group,
            trunk_no,                  box_no,                  package_no,                     ticket_no,      security_code,
            pay_amount,                lottery_amount,          pay_time,                       is_center_paid,
            comm_amount,               comm_rate,               reward_no)
         values
           (f_get_flow_pay_seq,        p_pay_agency,            v_area_code,                    v_comm_amount,  v_comm_rate,
            p_plan,                    p_batch,                 v_lottery_detail.reward_group,
            v_lottery_detail.trunk_no, v_lottery_detail.box_no, p_package_no,                   p_ticket_no,    p_security_string,
            v_reward_amount,           v_single_ticket_amount,  v_pay_time,                     p_paid_type,
            v_comm_amount,             v_comm_rate,             v_reward_level)
         returning
            pay_flow
         into
            v_pay_flow;

         -- 给兑奖销售站加“奖金”和“兑奖代销费”
         p_agency_fund_change(p_pay_agency, eflow_type.paid, v_reward_amount, 0, v_pay_flow, v_balance, v_balance);
         p_agency_fund_change(p_pay_agency, eflow_type.pay_comm, v_comm_amount, 0, v_pay_flow, v_balance, v_f_balance);


         -- add @ 2016-01-22 by 陈震
         -- 机构佣金记录
         /** 机构所属销售站兑奖，需要按照兑奖销售站所属机构级别来计算是否给机构佣金  **/
         /** 对于机构类型是总机构的，一概不给于任何佣金和奖金                        **/
         /** 对于机构类型是分公司的，按照系统参数（16）确定是否给于佣金和奖金        **/
         /** 对于机构类型是代理商的，需要给于佣金和奖金                              **/
         v_org := f_get_flow_pay_org(v_pay_flow);
         v_org_type := f_get_org_type(v_org);
         if (v_org_type <> '00' and v_org_type = eorg_type.company and f_get_sys_param(16) = '1') or (v_org_type = eorg_type.agent) then

            v_comm_rate := f_get_org_comm_rate(v_org, p_plan, p_batch, 2);

            if v_comm_rate = -1 then
               v_comm_rate := 0;
            end if;

            v_comm_amount := v_reward_amount * v_comm_rate / 1000;

            insert into flow_pay_org_comm
              (pay_flow,                  pay_agency,              area_code,
               org_code,                  org_type,                org_pay_comm,                   org_pay_comm_rate,
               plan_code,                 batch_no,                reward_group,                   reward_no,
               trunk_no,                  box_no,                  package_no,                     ticket_no,           security_code,
               pay_amount,                lottery_amount,          pay_time,                       is_center_paid)
            values
              (v_pay_flow,                p_pay_agency,            v_area_code,
               v_org,                     v_org_type,              v_comm_amount,                  v_comm_rate,
               p_plan,                    p_batch,                 v_lottery_detail.reward_group,  v_reward_level,
               v_lottery_detail.trunk_no, v_lottery_detail.box_no, p_package_no,                   p_ticket_no,         p_security_string,
               v_reward_amount,           v_single_ticket_amount,  v_pay_time,                     p_paid_type);

            -- 组织机构增加流水
            -- 奖金
            p_org_fund_change(v_org, eflow_type.org_agency_pay, v_reward_amount, 0, v_pay_flow, v_balance, v_balance);

            -- 佣金
            if v_comm_amount > 0 then
               p_org_fund_change(v_org, eflow_type.org_agency_pay_comm, v_comm_amount, 0, v_pay_flow, v_balance, v_balance);
            end if;

         end if;

      when 2 then                                                       -- 管理员手持机现场兑奖（因为没有现场实际应用，所以一下内容未必正确）

         if v_sys_param = '1' then
            -- 计算兑奖代销费
            v_comm_amount := trunc(v_reward_amount * v_comm_rate / 1000);

            -- 获取销售站对应的区域码
            select area_code into v_area_code from inf_agencys where agency_code = p_pay_agency;

            -- 建立兑奖记录
            insert into flow_pay
              (pay_flow,                  pay_agency,              area_code,                      pay_comm,       pay_comm_rate,
               plan_code,                 batch_no,                reward_group,
               trunk_no,                  box_no,                  package_no,                     ticket_no,      security_code,
               pay_amount,                lottery_amount,          pay_time,                       payer_admin,    payer_name,
               is_center_paid,            comm_amount,             comm_rate,                      reward_no)
            values
              (f_get_flow_pay_seq,        v_agency,                v_area_code,                    v_comm_amount,  v_comm_rate,
               p_plan,                    p_batch,                 v_lottery_detail.reward_group,
               v_lottery_detail.trunk_no, v_lottery_detail.box_no, p_package_no,                   p_ticket_no,    p_security_string,
               v_reward_amount,           v_single_ticket_amount,  v_pay_time,                     p_oper,         v_admin_realname,
               p_paid_type,               v_comm_amount,           v_comm_rate,                    v_reward_level)
            returning
               pay_flow
            into
               v_pay_flow;

            -- 给卖票销售站加“兑奖代销费”
            p_agency_fund_change(v_agency, eflow_type.pay_comm, v_comm_amount, 0, v_pay_flow, v_balance, v_f_balance);

            -- 扣减管理员账户金额，因为管理员已经将奖金直接给付彩民

         else
            -- 建立兑奖记录，不填写站点和佣金相关信息
            insert into flow_pay
              (pay_flow,                 plan_code,               batch_no,     reward_group,
               trunk_no,                 box_no,                  package_no,   ticket_no,      security_code,       reward_no,
               pay_amount,               lottery_amount,          pay_time,     payer_admin,    payer_name,          is_center_paid)
            values
              (f_get_flow_pay_seq,       p_plan,                  p_batch,      v_lottery_detail.reward_group,
              v_lottery_detail.trunk_no, v_lottery_detail.box_no, p_package_no, p_ticket_no,    p_security_string,   v_reward_level,
              v_reward_amount,           v_single_ticket_amount,  v_pay_time,   p_oper,         v_admin_realname,    p_paid_type)
            returning
               pay_flow
            into
               v_pay_flow;
         end if;

      when 1 then                                                       -- 中心兑奖

         -- 增加兑奖记录
         insert into flow_pay
           (pay_flow,                  plan_code,               batch_no,     reward_group,
            trunk_no,                  box_no,                  package_no,   ticket_no,      security_code,       reward_no,
            pay_amount,                lottery_amount,          pay_time,     payer_admin,    payer_name,          is_center_paid)
         values
           (f_get_flow_pay_seq,        p_plan,                  p_batch,      v_lottery_detail.reward_group,
            v_lottery_detail.trunk_no, v_lottery_detail.box_no, p_package_no, p_ticket_no,    p_security_string,   v_reward_level,
            v_reward_amount,           v_single_ticket_amount,  v_pay_time,   p_oper,         v_admin_realname,    p_paid_type)
         returning
            pay_flow
         into
            v_pay_flow;

         -- 新增“中心兑奖记录”
         insert into flow_gui_pay
           (gui_pay_no,             winnername,          gender,                    contact,                   age,
            cert_number,            pay_amount,          pay_time,                  payer_admin,               payer_name,
            plan_code,              batch_no,            trunk_no,                  box_no,                    package_no,
            ticket_no,              security_code,       is_manual,                 pay_flow)
         values
           (f_get_flow_gui_pay_seq, p_name,              p_sex,                     p_contact,                 p_age,
            p_id,                   v_reward_amount,     v_pay_time,                p_oper,                    v_admin_realname,
            p_plan,                 p_batch,             v_lottery_detail.trunk_no, v_lottery_detail.box_no,   p_package_no,
            p_ticket_no,            p_security_string,   eboolean.noordisabled,     v_pay_flow);

         -- add @ 2016-01-22 by 陈震
         /** 中心兑奖，需要按照兑奖的机构级别来计算是否给机构佣金                    **/
         /** 对于机构类型是总机构的，一概不给于任何佣金和奖金                        **/
         /** 对于机构类型是分公司的，按照系统参数（16）确定是否给于佣金              **/
         /** 对于机构类型是代理商的，需要给于佣金和奖金                              **/

         -- 获取兑奖机构
         v_org := f_get_flow_pay_org(v_pay_flow);

         -- 奖金
         p_org_fund_change(v_org, eflow_type.org_center_pay, v_reward_amount, 0, v_pay_flow, v_balance, v_balance);

         v_org_type := f_get_org_type(v_org);
         if (v_org_type <> '00' and v_org_type = eorg_type.company and f_get_sys_param(16) = '1') or (v_org_type = eorg_type.agent) then

            -- 获取机构佣金比例
            v_comm_rate := f_get_org_comm_rate(v_org, p_plan, p_batch, 2);

            if v_comm_rate = -1 then
               v_comm_rate := 0;
            end if;

            -- 计算机构佣金金额
            v_comm_amount := v_reward_amount * v_comm_rate / 1000;

            insert into flow_pay_org_comm
              (pay_flow,                  plan_code,               batch_no,                       reward_group,
               org_code,                  org_type,                org_pay_comm,                   org_pay_comm_rate,
               trunk_no,                  box_no,                  package_no,                     ticket_no,
               pay_amount,                lottery_amount,          pay_time,                       is_center_paid,
               security_code,             reward_no,               payer_admin,                    payer_name)
            values
              (v_pay_flow,                p_plan,                  p_batch,                        v_lottery_detail.reward_group,
               v_org,                     v_org_type,              v_comm_amount,                  v_comm_rate,
               v_lottery_detail.trunk_no, v_lottery_detail.box_no, p_package_no,                   p_ticket_no,
               v_reward_amount,           v_single_ticket_amount,  v_pay_time,                     p_paid_type,
               p_security_string,         v_reward_level,          p_oper,                         v_admin_realname);

            -- 佣金
            if v_comm_amount > 0 then
               p_org_fund_change(v_org, eflow_type.org_center_pay_comm, v_comm_amount, 0, v_pay_flow, v_balance, v_balance);
            end if;
         end if;

   end case;

   c_reward_amount := v_reward_amount;
   c_pay_flow := v_pay_flow;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
