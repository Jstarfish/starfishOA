create or replace procedure p_get_lottery_reward
/****************************************************************/
   ------------------- 彩票中奖查询 -------------------
   ---- 查询输入的彩票是否中奖，并且返回中奖信息
   ---- add by 陈震: 2015/9/21
   ---- 业务流程：
   ----     1、校验输入参数。（方案批次是否存在，有效位数是否正确；）
   ----     2、查询2.1.4.7 批次信息导入之中奖明细（game_batch_reward_detail）表，是否有记录，有则中奖
   ----     3、截取奖符，去2.1.4.6 批次信息导入之奖符（game_batch_import_reward）中进行查询，获取中奖等级和中奖金额
   ---- modify by dzg :2015/10/21
   ---- 返回一个结果 : 0中奖 1大奖 2 未中奖 3 已兑奖 4 未销售或无效
   ---- 未销售没有返回4
   ---- modify by dzg: 2016/4/4 逻辑错误

   /*************************************************************/
(
 --------------输入----------------
  p_plan                               in char,             -- 方案编号
  p_batch                              in char,             -- 批次编号
  p_package_no                         in varchar2,         -- 彩票本号
  p_security_string                    in char,             -- 保安区码（21位）
  p_level                              in number,           -- 兑奖级别（1=站点、2=分公司、3=总公司）
 ---------出口参数---------
  c_reward_level                       out number,          -- 中奖奖级
  c_reward_amount                      out number,          -- 中奖金额
  c_reward_result                      out number,          -- 票中奖结果，用于POS端使用
  c_errorcode                          out number,          -- 错误编码
  c_errormesg                          out string           -- 错误原因

 ) is

   v_count                             number(2);           -- 记录数
   v_safe_code                         varchar2(50);        -- 兑奖码
   v_publisher                         number(2);           -- 厂商编码

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   c_reward_level := 0;
   c_reward_amount := 0;
   c_reward_result := 2;

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if f_get_reward_ticket_ver(p_plan, p_batch, p_package_no) = 0 then
      if not f_check_plan_batch(p_plan, p_batch) then
         c_errorcode := 1;
         c_errormesg := dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || error_msg.err_common_102; -- 无此方案和批次
         return;
      end if;

      -- 判断彩票是否销售
      v_count := 0;
      select count(*)
        into v_count
        from wh_ticket_package
       where plan_code = p_plan
         and batch_no = p_batch
         and package_no = p_package_no
         and status = eticket_status.saled;
      if v_count <= 0 then
         c_reward_result := 4;
         return;
      end if;
   end if;
   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* 查询2.1.4.7 批次信息导入之中奖明细（game_batch_reward_detail）表，是否有记录，有则中奖 *************************/
   if f_get_reward_ticket_ver(p_plan, p_batch, p_package_no) = 1 then
      v_publisher := epublisher_code.sjz;
   else
      v_publisher := f_get_plan_publisher(p_plan);
   end if;

   case v_publisher
      when epublisher_code.sjz then
         begin
            select safe_code
              into v_safe_code
              from game_batch_reward_detail
             where plan_code = p_plan
               and batch_no = p_batch
               and safe_code = p_security_string;

               v_count := 1;
         exception
            when no_data_found then
               v_count := 0;
         end;

      when epublisher_code.zc3c then
         begin
            select safe_code
              into v_safe_code
              from game_batch_reward_detail
             where plan_code = p_plan
               and batch_no = p_batch
               and pre_safe_code = substr(p_security_string, 1, 16);

               v_count := 1;

         exception
            when no_data_found then
               v_count := 0;
         end;

   end case;

   if v_count = 1 then
      --已中奖
      c_reward_result := 0;

      select reward_no, single_reward_amount
        into c_reward_level, c_reward_amount
        from game_batch_import_reward
       where plan_code = p_plan
         and batch_no = p_batch
         and instr(fast_identity_code, substr(v_safe_code, epublisher_sjz.fast_identity_code_pos, epublisher_sjz.len_fast_identity_code)) > 0;

      --判断是否已兑奖
      select count(*)
        into v_count
        from flow_pay
       where plan_code = p_plan
         and batch_no = p_batch
         and security_code = p_security_string;
      if v_count = 1 then
         c_reward_result := 3;
      else
        --大奖
        case
           -- 兑奖级别（1=站点、2=分公司、3=总公司）
           when p_level = 1 then
              if c_reward_amount >= to_number(f_get_sys_param(5)) then
                 c_reward_result := 1;
              end if;

           when p_level = 2 then
              if c_reward_amount >= to_number(f_get_sys_param(6)) then
                 if f_get_sys_param(7) = '1' then
                    c_reward_result := 1;
                 end if;
              end if;
           when p_level = 3 then
              return;
           else
              c_errorcode := 1;
              c_errormesg := error_msg.err_common_106;
              return;
        end case;
      end if;
   end if;

exception
   when others then
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
