create or replace procedure p_ticket_perferm
/*********************************************************************************/
   ------------- �������������Ͳ�������������Ʊ�����ݣ����ύ�� ---------------
   ---- add by ����: 2015/9/25
   ---- �漰��ҵ���
   ----     2.1.5.3 ����Ʊ��Ϣ���䣩��wh_ticket_trunk��
   ----     2.1.5.4 ����Ʊ��Ϣ���У���wh_ticket_box��
   ----     2.1.5.5 ����Ʊ��Ϣ��������wh_ticket_package��

/*********************************************************************************/
(
 --------------����----------------
 p_array_lotterys    in type_lottery_list,   -- ���Ĳ�Ʊ����
 p_oper              in number,              -- ������
 p_be_status         in number,              -- ֮ǰ��״̬
 p_af_status         in number,              -- ֮���״̬
 p_last_wh           in varchar2,            -- ֮ǰ�ֿ�
 p_current_wh        in varchar2,            -- ֮ǰ�ֿ�
 ---------���ڲ���---------
 c_errorcode out number,                     --�������
 c_errormesg out string                      --����ԭ��

 ) is

   v_array_lottery         type_lottery_info;                              -- ���Ų�Ʊ
   v_lottery_detail        type_lottery_info;                              -- ��Ʊ������ϸ��Ϣ
   v_single_ticket_amount  number(10);                                     -- ÿ��Ʊ�ļ۸�
   v_packs_every_box       number(10);                                     -- ÿ���С��а������١�����
   v_collect_batch_param   game_batch_import_detail%rowtype;               -- ���β���

   v_trunck_info           wh_ticket_trunk%rowtype;                        -- ����Ϣ
   v_box_info              wh_ticket_box%rowtype;                          -- ����Ϣ
   v_package_info          wh_ticket_package%rowtype;                      -- ����Ϣ

   v_wh_status             number(2);

begin

   /*-----------    ��ʼ������    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   -- �ж�Դ�˺�Ŀ��˵Ĳֿ��Ƿ������̵㣬����ǣ��Ͳ�����������
   if (p_be_status in (eticket_status.in_warehouse) or p_af_status in (eticket_status.in_warehouse)) then
      if p_be_status in (eticket_status.in_warehouse) then
         select STATUS
           into v_wh_status
           from WH_INFO
          where WAREHOUSE_CODE = p_last_wh;
         if v_wh_status <> ewarehouse_status.working then
            c_errorcode := 1;
            c_errormesg := dbtool.format_line(p_last_wh) || error_msg.err_p_ticket_perferm_1; -- �˲ֿ�״̬�����̵��ͣ��״̬�����ܽ��г�������
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
         c_errormesg := dbtool.format_line(p_current_wh) || error_msg.err_p_ticket_perferm_1; -- �˲ֿ�״̬�����̵��ͣ��״̬�����ܽ��г�������
         return;
      end if;
   end if;

   -- ѭ��������ϸ����
   for v_list_count in 1 .. p_array_lotterys.count loop
      v_array_lottery := p_array_lotterys(v_list_count);

      -- ��ȡ����Ĳ���
      select * into v_collect_batch_param from game_batch_import_detail where plan_code = v_array_lottery.plan_code and batch_no = v_array_lottery.batch_no;

      -- ��鷽�������Ƿ����
      if not f_check_plan_batch(v_array_lottery.plan_code, v_array_lottery.batch_no) then
         c_errorcode := 3;
         c_errormesg := dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || error_msg.err_p_ticket_perferm_3; -- ϵͳ�в����ڴ����εĲ�Ʊ����
         return;
      end if;

      -- ��鷽�������Ƿ���Ч
      if not f_check_plan_batch_status(v_array_lottery.plan_code, v_array_lottery.batch_no) then
         c_errorcode := 5;
         c_errormesg := dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || error_msg.err_p_ticket_perferm_5; -- �����εĲ�Ʊ�����Ѿ�ͣ��
         return;
      end if;

      -- ��ȡ����Ʊ���
      select ticket_amount into v_single_ticket_amount from game_plans where plan_code = v_array_lottery.plan_code;

      -- ÿ���С��а������١�����
      v_packs_every_box := v_collect_batch_param.packs_every_trunk / v_collect_batch_param.boxes_every_trunk;

      case
         when v_array_lottery.valid_number = evalid_number.trunk then
            -- ���¡��䡱λ��
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
                                    || error_msg.err_p_ticket_perferm_10; -- �����Ʊ������
                     return;
               end;

               if v_trunck_info.status <> p_be_status then
                  c_errorcode := 2;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.trunk_no)
                                 || error_msg.err_p_ticket_perferm_20 || dbtool.format_line(v_trunck_info.status); -- �ˡ��䡱��Ʊ��״̬��Ԥ�ڲ�������ǰ״̬Ϊ
                  return;
               end if;

               if v_trunck_info.is_full <> eboolean.yesorenabled then
                  c_errorcode := 3;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.trunk_no)
                                 || error_msg.err_p_ticket_perferm_30; -- �ˡ��䡱��Ʊ��ϵͳ�д��ڿ���״̬����˲��ܽ������䴦��
                  return;
               end if;

               if nvl(v_trunck_info.current_warehouse, 'NULL') <> nvl(p_last_wh, 'NULL') then
                  c_errorcode := 4;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.trunk_no)
                                 || error_msg.err_p_ticket_perferm_40; -- �ˡ��䡱��Ʊ�����Ϣ���ܴ��ڴ������ѯ�Ժ��ٽ��в���
                  return;
               end if;

               c_errorcode := 5;
               c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.trunk_no)
                              || error_msg.err_p_ticket_perferm_50; -- �����Ʊʱ�����������쳣������ϵϵͳ��Ա
               return;
            end if;

            -- ���¡��䡱��Ӧ�ġ��С�����Ϣ
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
                              || error_msg.err_p_ticket_perferm_60; -- �����䡱ʱ�����С����ݳ����쳣�����ܵĴ���Ϊ��1-�����Ӧ��ĳЩ���Ѿ�����ʹ�ã�2-�����Ӧ��ĳЩ���Ѿ���ת�ƣ�3-�����Ӧ��ĳЩ�е�״̬��Ԥ��״̬����
               return;
            end if;

            -- ���¡��䡱��Ӧ�ġ���������Ϣ
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
                              || error_msg.err_p_ticket_perferm_70; -- �����䡱ʱ�����С����ݳ����쳣�����ܵĴ���Ϊ��1-�����Ӧ��ĳЩ���Ѿ���ת�ƣ�2-�����Ӧ��ĳЩ����״̬��Ԥ��״̬����
               return;
            end if;

         when v_array_lottery.valid_number = evalid_number.box then
            -- У���Ƿ���ڴ�������
            v_lottery_detail := f_get_lottery_info(v_array_lottery.plan_code, v_array_lottery.batch_no, v_array_lottery.valid_number, v_array_lottery.box_no);

            -- ���¡��䡱λ��
            update wh_ticket_trunk
               set is_full = eboolean.noordisabled
             where plan_code = v_array_lottery.plan_code
               and batch_no = v_array_lottery.batch_no
               and trunk_no = v_lottery_detail.trunk_no;

            -- �������⣬���¡��С�λ��
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
                                    || error_msg.err_p_ticket_perferm_110; -- �˺в�Ʊ������
                     return;
               end;

               if v_box_info.status <> p_be_status then
                  c_errorcode := 2;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.box_no)
                                 || error_msg.err_p_ticket_perferm_120 || dbtool.format_line(v_box_info.status); -- �ˡ��С���Ʊ��״̬��Ԥ�ڲ�������ǰ״̬Ϊ
                  return;
               end if;

               if v_box_info.is_full <> eboolean.yesorenabled then
                  c_errorcode := 3;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.box_no)
                                 || error_msg.err_p_ticket_perferm_130; -- �ˡ��С���Ʊ��ϵͳ�д��ڿ���״̬����˲��ܽ������䴦��
                  return;
               end if;

               if nvl(v_box_info.current_warehouse, 'NULL') <> nvl(p_last_wh, 'NULL') then
                  c_errorcode := 4;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.box_no)
                                 || error_msg.err_p_ticket_perferm_140; -- �ˡ��С���Ʊ�����Ϣ���ܴ��ڴ������ѯ�Ժ��ٽ��в���
                  return;
               end if;

               c_errorcode := 5;
               c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.box_no)
                              || error_msg.err_p_ticket_perferm_150; -- �����Ʊʱ�����������쳣������ϵϵͳ��Ա
               return;

            end if;

            -- ���¡��С���Ӧ�ġ���������Ϣ
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
                              || error_msg.err_p_ticket_perferm_160; -- �����С�ʱ�����������ݳ����쳣�����ܵĴ���Ϊ��1-�˺ж�Ӧ��ĳЩ���Ѿ���ת�ƣ�2-�˺ж�Ӧ��ĳЩ����״̬��Ԥ��״̬����
               return;
            end if;

         when v_array_lottery.valid_number = evalid_number.pack then
            v_lottery_detail := f_get_lottery_info(v_array_lottery.plan_code, v_array_lottery.batch_no, v_array_lottery.valid_number, v_array_lottery.package_no);

            -- ���¡�����λ��
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
                                    || error_msg.err_p_ticket_perferm_210; -- �˱���Ʊ������
                     return;
               end;

               if v_package_info.status <> p_be_status then
                  c_errorcode := 2;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.package_no)
                                 || error_msg.err_p_ticket_perferm_220 || dbtool.format_line(v_package_info.status); -- �ˡ�������Ʊ��״̬��Ԥ�ڲ�������ǰ״̬Ϊ
                  return;
               end if;

               if nvl(v_package_info.current_warehouse, 'NULL') <> nvl(p_last_wh, 'NULL') then
                  c_errorcode := 4;
                  c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.package_no)
                                 || error_msg.err_p_ticket_perferm_230; -- �ˡ�������Ʊ�����Ϣ���ܴ��ڴ������ѯ�Ժ��ٽ��в���
                  return;
               end if;

               c_errorcode := 5;
               c_errormesg :=    dbtool.format_line(v_array_lottery.plan_code) || dbtool.format_line(v_array_lottery.batch_no) || dbtool.format_line(v_array_lottery.package_no)
                              || error_msg.err_p_ticket_perferm_240; -- �����Ʊʱ�����������쳣������ϵϵͳ��Ա
               return;
            end if;

      end case;
   end loop;

exception
   when others then
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;
end;
