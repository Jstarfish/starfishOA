create or replace procedure p_get_lottery_history
/****************************************************************/
   ------------------- ������ϸ��ѯ -------------------
   ---- ��ѯ�����Ʊ�����������ת��ϸ
   ----     ԭ���ϣ���ѯ���±���ȡ��ת��Ϣ
   ----         2.1.5.11 ��ⵥ��ϸ��wh_goods_receipt_detail��
   ----         2.1.5.9 ���ⵥ��ϸ��wh_goods_issue_detail��
   ----         2.1.7.2 �ҽ���¼��flow_pay��
   ----
   ----     ��Բ�Ʊ����Ĳ�ѯԭ�����£�
   ----     �䣺����Ҫ���ݡ�ֱ�Ӳ�ѯ
   ----     �У����Ȳ�ѯ���С�����Ϣ��Ȼ����ݵ���Ӧ�ġ��䡱��֮�����ݽ��кϲ�����
   ----     �������Ȳ�ѯ����������Ϣ��Ȼ����ݵ���Ӧ�ġ��䡱�͡��С���֮�����ݽ��кϲ�����
   ----     Ʊ����ѯƱ�Ƿ��н����������ա�����������
   ----
   ----     ���ؽ������[ʱ��][�ֿ�/����վ/����Ա][����][�ֿ�/����վ/����Ա][����][����Ʊ״ֵ̬]
   ---- add by ����: 2015/9/21
   ---- ҵ�����̣�
   ----     1��У����������������������Ƿ���ڣ���Чλ���Ƿ���ȷ����
   ----     2��������Чλ�����з��������
   ----        Ʊ����ѯ�Ƿ�ҽ�����ʾ�ҽ����
   ----        �䣺��ѯ���䡱��¼��
   ----        �У����Ȳ�ѯ���С�����Ϣ��Ȼ����ݵ���Ӧ�ġ��䡱��֮�����ݽ��кϲ�����
   ----        �������Ȳ�ѯ����������Ϣ��Ȼ����ݵ���Ӧ�ġ��䡱�͡��С���֮�����ݽ��кϲ�����

   /*************************************************************/
(
 --------------����----------------
 p_plan                 in char,                         -- �������
 p_batch                in char,                         -- ���α��
 p_valid_number         in number,                       -- ��Чλ��(1-�䣬2-�У�3-����4-Ʊ)
 p_value                in varchar2,                     -- ���䡱�����С����������š������ѯƱ��������Ϣ���������롰������
 p_ticket_no            in varchar2,                     -- Ʊ��

 ---------���ڲ���---------
 c_reward_amount        out number,                      -- �ҽ����
 c_reward_time          out date,                        -- �ҽ�ʱ��
 c_result               out type_logistics_list,         -- �����
 c_errorcode            out number,                      -- �������
 c_errormesg            out string                       -- ����ԭ��

 ) is

   v_lottery_detail        type_lottery_info;                              -- ��Ʊ������ϸ��Ϣ
   v_lottery_batch         type_logistics_list;                            -- �������
   v_rtv                   type_logistics_list;                            -- �������

begin

   /*-----------    ��ʼ������    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- ����У��   -----------------*/
   -- У����ڲ����Ƿ���ȷ����Ӧ�����ݼ�¼�Ƿ����
   if not f_check_plan_batch(p_plan, p_batch) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_plan) || dbtool.format_line(p_batch) || error_msg.err_p_rr_inbound_1; -- �޴˷���������
      return;
   end if;

   /*----------- ҵ���߼�   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* �ж����ͣ����ղ�ͬ���ͽ��д���*************************/
   if p_valid_number = evalid_number.ticket then
      -- ��ѯ��Ʊ�Ƿ��н�
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
      -- ���䡱
      when p_valid_number = evalid_number.trunk then
         -- ������������¼
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

         -- ������¼
         with
            detail_issue as (
               -- ������ϸ
               select sgi_no
                 from wh_goods_issue_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.trunk
                  and trunk_no = p_value
                  and box_no = '-'
                  and package_no = '-'),
            detail_receipt as (
               -- �����ϸ
               select sgr_no
                 from wh_goods_receipt_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.trunk
                  and trunk_no = p_value
                  and box_no = '-'
                  and package_no = '-'),
            result_issue as (
               -- �����¼
               select issue_end_time, issue_type, send_wh, receive_admin from wh_goods_issue where sgi_no in (select sgi_no from detail_issue)),
            result_receipt as (
               -- ����¼���ų�������⣬��������
               select receipt_end_time, receipt_type, receive_wh, send_admin from wh_goods_receipt where sgr_no in (select sgr_no from detail_receipt) and receipt_type not in (ereceipt_type.batch)),
            result as (
               select issue_end_time, issue_type, send_wh, receive_admin from result_issue
               union
               select receipt_end_time, receipt_type + 10, receive_wh, send_admin from result_receipt)
         select type_logistics_info(issue_end_time, issue_type, send_wh, receive_admin)
           bulk collect into c_result
           from result;

      -- ���С�
      when p_valid_number = evalid_number.box then
         v_lottery_detail := f_get_lottery_info(p_plan, p_batch, p_valid_number, p_value);

         -- ������������¼������һ���ʺ�������⣬�����������ģ�������������sql���������գ�ֻ��һ��sql���н����������������ȷ�ģ�
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
               -- ������ϸ���У�
               select sgi_no
                 from wh_goods_issue_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.box
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = p_value
                  and package_no = '-'),
            detail_issue_trunk as (
               -- ������ϸ���䣩
               select sgi_no
                 from wh_goods_issue_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.trunk
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = '-'
                  and package_no = '-'),
            detail_receipt as (
               -- �����ϸ���У�
               select sgr_no
                 from wh_goods_receipt_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.box
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = p_value
                  and package_no = '-'),
            detail_receipt_trunk as (
               -- �����ϸ���䣩
               select sgr_no
                 from wh_goods_receipt_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.trunk
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = '-'
                  and package_no = '-'),
            result_issue as (
               -- �����¼
               select issue_end_time, issue_type, send_wh, receive_admin
                 from wh_goods_issue
                where sgi_no in (select sgi_no from detail_issue
                                 union all
                                 select sgi_no from detail_issue_trunk
                                )),
            result_receipt as (
               -- ����¼
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

      -- ������
      when p_valid_number = evalid_number.pack or p_valid_number = evalid_number.ticket then
         v_lottery_detail := f_get_lottery_info(p_plan, p_batch, evalid_number.pack, p_value);

         -- ������������¼������һ���ʺ�������⣬�����������ģ�������������sql���������գ�ֻ��һ��sql���н����������������ȷ�ģ�
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
               -- ������ϸ������
               select sgi_no
                 from wh_goods_issue_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.pack
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = v_lottery_detail.box_no
                  and package_no = p_value),
            detail_issue_box as (
               -- ������ϸ���У�
               select sgi_no
                 from wh_goods_issue_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.box
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = v_lottery_detail.box_no
                  and package_no = '-'),
            detail_issue_trunk as (
               -- ������ϸ���䣩
               select sgi_no
                 from wh_goods_issue_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.trunk
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = '-'
                  and package_no = '-'),
            detail_receipt as (
               -- �����ϸ������
               select sgr_no
                 from wh_goods_receipt_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.pack
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = v_lottery_detail.box_no
                  and package_no = p_value),
            detail_receipt_box as (
               -- �����ϸ���У�
               select sgr_no
                 from wh_goods_receipt_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.box
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = v_lottery_detail.box_no
                  and package_no = '-'),
            detail_receipt_trunk as (
               -- �����ϸ���䣩
               select sgr_no
                 from wh_goods_receipt_detail
                where plan_code = p_plan
                  and batch_no = p_batch
                  and valid_number = evalid_number.trunk
                  and trunk_no = v_lottery_detail.trunk_no
                  and box_no = '-'
                  and package_no = '-'),
            result_issue as (
               -- �����¼
               select issue_end_time, issue_type, send_wh, receive_admin
                 from wh_goods_issue
                where sgi_no in (select sgi_no from detail_issue
                                 union all
                                 select sgi_no from detail_issue_trunk
                                 union all
                                 select sgi_no from detail_issue_box
                                )),
            result_receipt as (
               -- ����¼
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

   -- ƴ�Ӳ�ѯ���
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
