create or replace procedure p_ticket_perferm
/*********************************************************************************/
   ------------- 按照输入的数组和参数，处理“即开票”数据（不提交） ---------------
   ---- add by 陈震: 2015/9/25
   ---- 涉及的业务表：
   ----     2.1.5.3 即开票信息（箱）（wh_ticket_trunk）
   ----     2.1.5.4 即开票信息（盒）（wh_ticket_box）
   ----     2.1.5.5 即开票信息（本）（wh_ticket_package）

/*********************************************************************************/
(
 --------------输入----------------
 p_array_lotterys    in type_lottery_list,   -- 入库的彩票对象
 p_oper              in number,              -- 操作人
 p_be_status         in number,              -- 之前的状态
 p_af_status         in number,              -- 之后的状态
 p_last_wh           in varchar2,            -- 之前仓库
 p_current_wh        in varchar2,            -- 之前仓库
 ---------出口参数---------
 c_errorcode out number,                     --错误编码
 c_errormesg out string                      --错误原因

 ) is

   v_array_lottery         type_lottery_info;                              -- 单张彩票
   v_lottery_detail        type_lottery_info;                              -- 彩票对象详细信息
   v_single_ticket_amount  number(10);                                     -- 每张票的价格
   v_packs_every_box       number(10);                                     -- 每“盒”中包含多少“本”
   v_collect_batch_param   game_batch_import_detail%rowtype;               -- 批次参数

   v_trunck_info           wh_ticket_trunk%rowtype;                        -- 箱信息
   v_box_info              wh_ticket_box%rowtype;                          -- 箱信息
   v_package_info          wh_ticket_package%rowtype;                      -- 箱信息

   v_wh_status             number(2);

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   -- 判断源端和目标端的仓库是否正在盘点，如果是，就不允许做操作
   if (p_be_status in (eticket_status.in_warehouse) or p_af_status in (eticket_status.in_warehouse)) then
      if p_be_status in (eticket_status.in_warehouse) then
         select STATUS
           into v_wh_status
           from WH_INFO
          where WAREHOUSE_CODE = p_last_wh;
         if v_wh_status <> ewarehouse_status.working then
            c_errorcode := 1;
            c_errormesg := dbtool.format_line(p_last_wh) || error_msg.err_p_ticket_perferm_1; -- 此仓库状态处于盘点或停用状态，不能进行出入库操作
            return;
         end if;
      end if;
      if p_af_status in (eticket_status.in_warehouse) then
         select STATUS
           into v_wh_status
           from WH_INFO
          where WAREHOUSE_CODE = p_current_wh;
      end if;
      if v_wh_status <> ewarehouse_status.working then
         c_errorcode := 1;
         c_errormesg := dbtool.format_line(p_current_wh) || error_msg.err_p_ticket_perferm_1; -- 此仓库状态处于盘点或停用状态，不能进行出入库操作
         return;
      end if;
   end if;

   -- 循环处理明细数据
   for v_list_count in 1 .. p_array_lotterys.count loop
      v_array_lottery := p_array_lotterys(v_list_count);

      -- 获取保存的参数
      select * into v_collect_batch_param from game_batch_import_detail where plan_code = v_array_lottery.plan_code and batch_no = v_array_lottery.batch_no;

      -- 检查方案批次是否存在
      if not f_check_plan_batch(v_array_lottery.plan_code, v_array_lottery.batch_no) then
         c_errorcode := 3;
         c_errormesg := dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || error_msg.err_p_ticket_perferm_3; -- 系统中不存在此批次的彩票方案
         return;
      end if;

      -- 检查方案批次是否有效
      if not f_check_plan_batch_status(v_array_lottery.plan_code, v_array_lottery.batch_no) then
         c_errorcode := 5;
         c_errormesg := dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || error_msg.err_p_ticket_perferm_5; -- 此批次的彩票方案已经停用
         return;
      end if;

      -- 获取单张票金额
      select ticket_amount into v_single_ticket_amount from game_plans where plan_code = v_array_lottery.plan_code;

      -- 每“盒”中包含多少“本”
      v_packs_every_box := v_collect_batch_param.packs_every_trunk / v_collect_batch_param.boxes_every_trunk;

      case
         when v_array_lottery.valid_number = evalid_number.trunk then
            -- 更新“箱”位置
            update wh_ticket_trunk
               set status = p_af_status,
                   last_warehouse = p_last_wh,
                   current_warehouse = p_current_wh,
                   change_admin = p_oper,
                   change_date = sysdate
             where status = p_be_status
               and is_full = eboolean.yesorenabled
               and nvl(current_warehouse, 'NULL') = nvl(p_last_wh, 'NULL')
               and plan_code = v_array_lottery.plan_code
               and batch_no = v_array_lottery.batch_no
               and trunk_no = v_array_lottery.trunk_no;

            if sql%rowcount = 0 then
               rollback;

               begin
                  select * into v_trunck_info
                    from wh_ticket_trunk
                   where plan_code = v_array_lottery.plan_code
                     and batch_no = v_array_lottery.batch_no
                     and trunk_no = v_array_lottery.trunk_no;
               exception
                  when no_data_found then
                     c_errorcode := 1;
                     c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.trunk_no)
                                    || error_msg.err_p_ticket_perferm_10; -- 此箱彩票不存在
                     return;
               end;

               if v_trunck_info.status <> p_be_status then
                  c_errorcode := 2;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.trunk_no)
                                 || error_msg.err_p_ticket_perferm_20 || dbtool.format_line(v_trunck_info.status); -- 此“箱”彩票的状态与预期不符，当前状态为
                  return;
               end if;

               if v_trunck_info.is_full <> eboolean.yesorenabled then
                  c_errorcode := 3;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.trunk_no)
                                 || error_msg.err_p_ticket_perferm_30; -- 此“箱”彩票在系统中处于开箱状态，因此不能进行整箱处理
                  return;
               end if;

               if nvl(v_trunck_info.current_warehouse, 'NULL') <> nvl(p_last_wh, 'NULL') then
                  c_errorcode := 4;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.trunk_no)
                                 || error_msg.err_p_ticket_perferm_40; -- 此“箱”彩票库存信息可能存在错误，请查询以后再进行操作
                  return;
               end if;

               c_errorcode := 5;
               c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.trunk_no)
                              || error_msg.err_p_ticket_perferm_50; -- 处理彩票时，出现数据异常，请联系系统人员
               return;
            end if;

            -- 更新“箱”对应的“盒”的信息
            update wh_ticket_box
               set status = p_af_status,
                   current_warehouse = p_current_wh,
                   last_warehouse = p_last_wh,
                   change_admin = p_oper,
                   change_date = sysdate
             where status = p_be_status
               and is_full = eboolean.yesorenabled
               and nvl(current_warehouse, 'NULL') = nvl(p_last_wh, 'NULL')
               and plan_code = v_array_lottery.plan_code
               and batch_no = v_array_lottery.batch_no
               and trunk_no = v_array_lottery.trunk_no;
            if sql%rowcount <> v_collect_batch_param.boxes_every_trunk then
               rollback;
               c_errorcode := 6;
               c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.trunk_no)
                              || error_msg.err_p_ticket_perferm_60; -- 处理“箱”时，“盒”数据出现异常。可能的错误为：1-此箱对应的某些盒已经被拆开使用，2-此箱对应的某些盒已经被转移，3-此箱对应的某些盒的状态与预期状态不符
               return;
            end if;

            -- 更新“箱”对应的“本”的信息
            update wh_ticket_package
               set status = p_af_status,
                   current_warehouse = p_current_wh,
                   last_warehouse = p_last_wh,
                   change_admin = p_oper,
                   change_date = sysdate
             where status = p_be_status
               and nvl(current_warehouse, 'NULL') = nvl(p_last_wh, 'NULL')
               and plan_code = v_array_lottery.plan_code
               and batch_no = v_array_lottery.batch_no
               and trunk_no = v_array_lottery.trunk_no;
            if sql%rowcount <> v_collect_batch_param.packs_every_trunk then
               rollback;
               c_errorcode := 7;
               c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.trunk_no)
                              || error_msg.err_p_ticket_perferm_70; -- 处理“箱”时，“盒”数据出现异常。可能的错误为：1-此箱对应的某些本已经被转移，2-此箱对应的某些本的状态与预期状态不符
               return;
            end if;

         when v_array_lottery.valid_number = evalid_number.box then
            -- 校验是否存在此类数据
            v_lottery_detail := f_get_lottery_info(v_array_lottery.plan_code, v_array_lottery.batch_no, v_array_lottery.valid_number, v_array_lottery.box_no);

            -- 更新“箱”位置
            update wh_ticket_trunk
               set is_full = eboolean.noordisabled
             where plan_code = v_array_lottery.plan_code
               and batch_no = v_array_lottery.batch_no
               and trunk_no = v_lottery_detail.trunk_no;

            -- 进入主题，更新“盒”位置
            update wh_ticket_box
               set status = p_af_status,
                   current_warehouse = p_current_wh,
                   last_warehouse = p_last_wh,
                   change_admin = p_oper,
                   change_date = sysdate
             where status = p_be_status
               and is_full = eboolean.yesorenabled
               and nvl(current_warehouse, 'NULL') = nvl(p_last_wh, 'NULL')
               and plan_code = v_array_lottery.plan_code
               and batch_no = v_array_lottery.batch_no
               and trunk_no = v_lottery_detail.trunk_no
               and box_no = v_array_lottery.box_no;
            if sql%rowcount = 0 then
               rollback;

               begin
                  select * into v_box_info
                    from wh_ticket_box
                   where plan_code = v_array_lottery.plan_code
                     and batch_no = v_array_lottery.batch_no
                     and trunk_no = v_lottery_detail.trunk_no
                     and box_no = v_array_lottery.box_no;
               exception
                  when no_data_found then
                     c_errorcode := 1;
                     c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.box_no)
                                    || error_msg.err_p_ticket_perferm_110; -- 此盒彩票不存在
                     return;
               end;

               if v_box_info.status <> p_be_status then
                  c_errorcode := 2;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.box_no)
                                 || error_msg.err_p_ticket_perferm_120 || dbtool.format_line(v_box_info.status); -- 此“盒”彩票的状态与预期不符，当前状态为
                  return;
               end if;

               if v_box_info.is_full <> eboolean.yesorenabled then
                  c_errorcode := 3;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.box_no)
                                 || error_msg.err_p_ticket_perferm_130; -- 此“盒”彩票在系统中处于开箱状态，因此不能进行整箱处理
                  return;
               end if;

               if nvl(v_box_info.current_warehouse, 'NULL') <> nvl(p_last_wh, 'NULL') then
                  c_errorcode := 4;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.box_no)
                                 || error_msg.err_p_ticket_perferm_140; -- 此“盒”彩票库存信息可能存在错误，请查询以后再进行操作
                  return;
               end if;

               c_errorcode := 5;
               c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.box_no)
                              || error_msg.err_p_ticket_perferm_150; -- 处理彩票时，出现数据异常，请联系系统人员
               return;

            end if;

            -- 更新“盒”对应的“本”的信息
            update wh_ticket_package
               set status = p_af_status,
                   current_warehouse = p_current_wh,
                   last_warehouse = p_last_wh,
                   change_admin = p_oper,
                   change_date = sysdate
             where status = p_be_status
               and nvl(current_warehouse, 'NULL') = nvl(p_last_wh, 'NULL')
               and plan_code = v_array_lottery.plan_code
               and batch_no = v_array_lottery.batch_no
               and trunk_no = v_lottery_detail.trunk_no
               and box_no = v_array_lottery.box_no;
            if sql%rowcount <> v_packs_every_box then
               rollback;
               c_errorcode := 5;
               c_errormesg :=    dbtool.format_line('p_ticket_perferm') || dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.trunk_no)
                              || error_msg.err_p_ticket_perferm_160; -- 处理“盒”时，“本”数据出现异常。可能的错误为：1-此盒对应的某些本已经被转移，2-此盒对应的某些本的状态与预期状态不符
               return;
            end if;

         when v_array_lottery.valid_number = evalid_number.pack then
            v_lottery_detail := f_get_lottery_info(v_array_lottery.plan_code, v_array_lottery.batch_no, v_array_lottery.valid_number, v_array_lottery.package_no);

            -- 更新“本”位置
            update wh_ticket_trunk
               set is_full = eboolean.noordisabled
             where plan_code = v_array_lottery.plan_code
               and batch_no = v_array_lottery.batch_no
               and trunk_no = v_lottery_detail.trunk_no;

            update wh_ticket_box
               set is_full = eboolean.noordisabled
             where plan_code = v_array_lottery.plan_code
               and batch_no = v_array_lottery.batch_no
               and trunk_no = v_lottery_detail.trunk_no
               and box_no = v_lottery_detail.box_no;

            update wh_ticket_package
               set status = p_af_status,
                   current_warehouse = p_current_wh,
                   last_warehouse = p_last_wh,
                   change_admin = p_oper,
                   change_date = sysdate
             where status = p_be_status
               and nvl(current_warehouse, 'NULL') = nvl(p_last_wh, 'NULL')
               and plan_code = v_array_lottery.plan_code
               and batch_no = v_array_lottery.batch_no
               and trunk_no = v_lottery_detail.trunk_no
               and box_no = v_lottery_detail.box_no
               and package_no = v_array_lottery.package_no;
            if sql%rowcount = 0 then
               rollback;
               begin
                  select * into v_package_info
                    from wh_ticket_package
                   where plan_code = v_array_lottery.plan_code
                     and batch_no = v_array_lottery.batch_no
                     and trunk_no = v_lottery_detail.trunk_no
                     and box_no = v_lottery_detail.box_no
                     and package_no = v_array_lottery.package_no;
               exception
                  when no_data_found then
                     c_errorcode := 1;
                     c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.package_no)
                                    || error_msg.err_p_ticket_perferm_210; -- 此本彩票不存在
                     return;
               end;

               if v_package_info.status <> p_be_status then
                  c_errorcode := 2;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.package_no)
                                 || error_msg.err_p_ticket_perferm_220 || dbtool.format_line(v_package_info.status); -- 此“本”彩票的状态与预期不符，当前状态为
                  return;
               end if;

               if nvl(v_package_info.current_warehouse, 'NULL') <> nvl(p_last_wh, 'NULL') then
                  c_errorcode := 4;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.package_no)
                                 || error_msg.err_p_ticket_perferm_230; -- 此“本”彩票库存信息可能存在错误，请查询以后再进行操作
                  return;
               end if;

               c_errorcode := 5;
               c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.package_no)
                              || error_msg.err_p_ticket_perferm_240; -- 处理彩票时，出现数据异常，请联系系统人员
               return;
            end if;

      end case;
   end loop;

exception
   when others then
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;
end;
