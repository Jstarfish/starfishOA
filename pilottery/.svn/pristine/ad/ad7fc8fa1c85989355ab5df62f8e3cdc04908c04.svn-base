create or replace procedure p_get_lottery_history
/****************************************************************/
   ------------------- 物流明细查询 -------------------
   ---- 查询输入彩票对象的物流流转明细
   ----     原则上，查询以下表，获取流转信息
   ----         2.1.5.11 入库单明细（wh_goods_receipt_detail）
   ----         2.1.5.9 出库单明细（wh_goods_issue_detail）
   ----         2.1.7.2 兑奖记录（flow_pay）
   ----
   ----     针对彩票对象的查询原则如下：
   ----     箱：不需要回溯。直接查询
   ----     盒：首先查询“盒”的信息，然后回溯到对应的“箱”，之后将数据进行合并排序
   ----     本：首先查询“本”的信息，然后回溯到对应的“箱”和“盒”，之后将数据进行合并排序
   ----     票：查询票是否中奖；后续按照“本”来处理
   ----
   ----     返回结果集：[时间][仓库/销售站/销售员][类型][仓库/销售站/销售员][类型][即开票状态值]
   ---- add by 陈震: 2015/9/21
   ---- 业务流程：
   ----     1、校验输入参数。（方案批次是否存在，有效位数是否正确；）
   ----     2、按照有效位数进行分情况处理：
   ----        票：查询是否兑奖，显示兑奖金额
   ----        箱：查询“箱”记录；
   ----        盒：首先查询“盒”的信息，然后回溯到对应的“箱”，之后将数据进行合并排序
   ----        本：首先查询“本”的信息，然后回溯到对应的“箱”和“盒”，之后将数据进行合并排序

   /*************************************************************/
(
 --------------输入----------------
 p_plan                 in char,                         -- 方案编号
 p_batch                in char,                         -- 批次编号
 p_valid_number         in number,                       -- 有效位数(1-箱，2-盒，3-本，4-票)
 p_value                in varchar2,                     -- “箱”、“盒”、“本”号。如果查询票的物流信息，必须输入“本”号
 p_ticket_no            in varchar2,                     -- 票号

 ---------出口参数---------
 c_reward_amount        out number,                      -- 兑奖金额
 c_reward_time          out date,                        -- 兑奖时间
 c_result               out type_logistics_list,         -- 结果集
 c_errorcode            out number,                      -- 错误编码
 c_errormesg            out string                       -- 错误原因

 ) is

   v_lottery_detail        type_lottery_info;                              -- 彩票对象详细信息
   v_lottery_batch         type_logistics_list;                            -- 批次入库
   v_rtv                   type_logistics_list;                            -- 批次入库

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_plan_batch(p_plan, p_batch) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || error_msg.err_p_rr_inbound_1; -- 无此方案和批次
      return;
   end if;

   /*----------- 业务逻辑   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* 判断类型，按照不同类型进行处理。*************************/
   if p_valid_number = evalid_number.ticket then
      -- 查询彩票是否中奖
      begin
      select pay_amount, pay_time
        into c_reward_amount, c_reward_time
        from flow_pay
       where plan_code = p_plan
         and batch_no = p_batch
         and package_no = p_value
         and ticket_no = p_ticket_no;
      exception
         when no_data_found then
            c_reward_amount := 0;
      end;
   end if;

   case
      -- “箱”
      when p_valid_number = evalid_number.trunk then
         -- 先找批次入库记录
         select type_logistics_info(create_date, ereceipt_type.batch + 10, (select receive_wh from wh_goods_receipt where sgr_no = wh_goods_receipt_detail.sgr_no), create_admin)
           bulk collect into v_lottery_batch
           from wh_goods_receipt_detail
          where plan_code = p_plan
            and batch_no = p_batch
            and valid_number = evalid_number.trunk
            and receipt_type = ereceipt_type.batch
            and trunk_no = p_value
            and box_no = '-'
            and package_no = '-';

         -- 其他记录
         with
            detail_issue as (
               -- 出库明细
               select sgi_no
                 from wh_goods_issue_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.trunk
                  and trunk_no = p_value
                  and box_no = '-'
                  and package_no = '-'),
            detail_receipt as (
               -- 入库明细
               select sgr_no
                 from wh_goods_receipt_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.trunk
                  and trunk_no = p_value
                  and box_no = '-'
                  and package_no = '-'),
            result_issue as (
               -- 出库记录
               select issue_end_time, issue_type, send_wh, receive_admin from wh_goods_issue where sgi_no in (select sgi_no from detail_issue)),
            result_receipt as (
               -- 入库记录（排除批次入库，单独处理）
               select receipt_end_time, receipt_type, receive_wh, send_admin from wh_goods_receipt where sgr_no in (select sgr_no from detail_receipt) and receipt_type not in (ereceipt_type.batch)),
            result as (
               select issue_end_time, issue_type, send_wh, receive_admin from result_issue
               union
               select receipt_end_time, receipt_type + 10, receive_wh, send_admin from result_receipt)
         select type_logistics_info(issue_end_time, issue_type, send_wh, receive_admin)
           bulk collect into c_result
           from result;

      -- “盒”
      when p_valid_number = evalid_number.box then
         v_lottery_detail := f_get_lottery_info(p_plan, p_batch, p_valid_number, p_value);

         -- 先找批次入库记录（总有一款适合批次入库，这里是排他的，所以连续三个sql。但是最终，只有一个sql会有结果，所以数据是正确的）
         select type_logistics_info(create_date, ttype, rwh, create_admin)
           bulk collect into v_lottery_batch
           from
               (
                  select create_date, ereceipt_type.batch + 10 ttype, (select receive_wh from wh_goods_receipt where sgr_no = wh_goods_receipt_detail.sgr_no) rwh, create_admin
                    from wh_goods_receipt_detail
                   where plan_code = p_plan
                     and batch_no = p_batch
                     and receipt_type = ereceipt_type.batch
                     and valid_number = evalid_number.trunk
                     and trunk_no = v_lottery_detail.trunk_no
                     and box_no = '-'
                     and package_no = '-'
                  union
                  select create_date, ereceipt_type.batch + 10 ttype, (select receive_wh from wh_goods_receipt where sgr_no = wh_goods_receipt_detail.sgr_no) rwh, create_admin
                    from wh_goods_receipt_detail
                   where plan_code = p_plan
                     and batch_no = p_batch
                     and receipt_type = ereceipt_type.batch
                     and valid_number = evalid_number.box
                     and trunk_no = v_lottery_detail.trunk_no
                     and box_no = p_value
                     and package_no = '-'
               );

         with
            detail_issue as (
               -- 出库明细（盒）
               select sgi_no
                 from wh_goods_issue_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.box
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = p_value
                  and package_no = '-'),
            detail_issue_trunk as (
               -- 出库明细（箱）
               select sgi_no
                 from wh_goods_issue_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.trunk
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = '-'
                  and package_no = '-'),
            detail_receipt as (
               -- 入库明细（盒）
               select sgr_no
                 from wh_goods_receipt_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.box
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = p_value
                  and package_no = '-'),
            detail_receipt_trunk as (
               -- 入库明细（箱）
               select sgr_no
                 from wh_goods_receipt_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.trunk
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = '-'
                  and package_no = '-'),
            result_issue as (
               -- 出库记录
               select issue_end_time, issue_type, send_wh, receive_admin
                 from wh_goods_issue
                where sgi_no in (select sgi_no from detail_issue
                                 union all
                                 select sgi_no from detail_issue_trunk
                                )),
            result_receipt as (
               -- 入库记录
               select receipt_end_time, receipt_type, receive_wh, send_admin
                 from wh_goods_receipt
                where receipt_type not in (ereceipt_type.batch)
                  and sgr_no in (select sgr_no from detail_receipt
                                 union all
                                 select sgr_no from detail_receipt_trunk
                                )),
            result as (
               select issue_end_time, issue_type, send_wh, receive_admin from result_issue
               union
               select receipt_end_time, receipt_type + 10, receive_wh, send_admin from result_receipt)
         select type_logistics_info(issue_end_time, issue_type, send_wh, receive_admin)
           bulk collect into c_result
           from result;

      -- “本”
      when p_valid_number = evalid_number.pack or p_valid_number = evalid_number.ticket then
         v_lottery_detail := f_get_lottery_info(p_plan, p_batch, evalid_number.pack, p_value);

         -- 先找批次入库记录（总有一款适合批次入库，这里是排他的，所以连续三个sql。但是最终，只有一个sql会有结果，所以数据是正确的）
         select type_logistics_info(create_date, ttype, rwh, create_admin)
           bulk collect into v_lottery_batch
           from
               (
                  select create_date, ereceipt_type.batch + 10 ttype, (select receive_wh from wh_goods_receipt where sgr_no = wh_goods_receipt_detail.sgr_no) rwh, create_admin
                    from wh_goods_receipt_detail
                   where plan_code = p_plan
                     and batch_no = p_batch
                     and receipt_type = ereceipt_type.batch
                     and valid_number = evalid_number.trunk
                     and trunk_no = v_lottery_detail.trunk_no
                     and box_no = '-'
                     and package_no = '-'
                  union
                  select create_date, ereceipt_type.batch + 10 ttype, (select receive_wh from wh_goods_receipt where sgr_no = wh_goods_receipt_detail.sgr_no) rwh, create_admin
                    from wh_goods_receipt_detail
                   where plan_code = p_plan
                     and batch_no = p_batch
                     and receipt_type = ereceipt_type.batch
                     and valid_number = evalid_number.box
                     and trunk_no = v_lottery_detail.trunk_no
                     and box_no = v_lottery_detail.box_no
                     and package_no = '-'
                  union
                  select create_date, ereceipt_type.batch + 10 ttype, (select receive_wh from wh_goods_receipt where sgr_no = wh_goods_receipt_detail.sgr_no) rwh, create_admin
                    from wh_goods_receipt_detail
                   where plan_code = p_plan
                     and batch_no = p_batch
                     and receipt_type = ereceipt_type.batch
                     and valid_number = evalid_number.pack
                     and trunk_no = v_lottery_detail.trunk_no
                     and box_no = v_lottery_detail.box_no
                     and package_no = p_value
               );

         with
            detail_issue as (
               -- 出库明细（本）
               select sgi_no
                 from wh_goods_issue_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.pack
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = v_lottery_detail.box_no
                  and package_no = p_value),
            detail_issue_box as (
               -- 出库明细（盒）
               select sgi_no
                 from wh_goods_issue_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.box
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = v_lottery_detail.box_no
                  and package_no = '-'),
            detail_issue_trunk as (
               -- 出库明细（箱）
               select sgi_no
                 from wh_goods_issue_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.trunk
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = '-'
                  and package_no = '-'),
            detail_receipt as (
               -- 入库明细（本）
               select sgr_no
                 from wh_goods_receipt_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.pack
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = v_lottery_detail.box_no
                  and package_no = p_value),
            detail_receipt_box as (
               -- 入库明细（盒）
               select sgr_no
                 from wh_goods_receipt_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.box
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = v_lottery_detail.box_no
                  and package_no = '-'),
            detail_receipt_trunk as (
               -- 入库明细（箱）
               select sgr_no
                 from wh_goods_receipt_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.trunk
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = '-'
                  and package_no = '-'),
            result_issue as (
               -- 出库记录
               select issue_end_time, issue_type, send_wh, receive_admin
                 from wh_goods_issue
                where sgi_no in (select sgi_no from detail_issue
                                 union all
                                 select sgi_no from detail_issue_trunk
                                 union all
                                 select sgi_no from detail_issue_box
                                )),
            result_receipt as (
               -- 入库记录
               select receipt_end_time, receipt_type, receive_wh, send_admin
                 from wh_goods_receipt
                where receipt_type not in (ereceipt_type.batch)
                  and sgr_no in (select sgr_no from detail_receipt
                                 union all
                                 select sgr_no from detail_receipt_trunk
                                 union all
                                 select sgr_no from detail_receipt_box
                                )),
            result as (
               select issue_end_time, issue_type, send_wh, receive_admin from result_issue
               union
               select receipt_end_time, receipt_type + 10, receive_wh, send_admin from result_receipt)
         select type_logistics_info(issue_end_time, issue_type, send_wh, receive_admin)
           bulk collect into c_result
           from result;
   end case;

   -- 拼接查询结果
   c_result := v_lottery_batch multiset union c_result;

   with
      base as (
         select ttime, obj_type,
                'Outlet [' || obj_object_s || ']' obj_object_s,
                obj_object_t
           from table(c_result) t
          where obj_type in (4, 14)
         union all
         select ttime, obj_type,
                (select warehouse_name from wh_info where warehouse_code = t.obj_object_s) obj_object_s,
                obj_object_t
           from table(c_result) t
          where obj_type not in (4, 14)),
      base_with_name as (
         select ttime, obj_type, obj_object_s,
                (select admin_realname from adm_info where admin_id = base.obj_object_t) obj_object_t
           from base
      )
   select type_logistics_info(ttime, obj_type, obj_object_s, obj_object_t)
     bulk collect into v_rtv
     from base_with_name
    order by ttime desc;

   c_result := v_rtv;

exception
   when others then
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
