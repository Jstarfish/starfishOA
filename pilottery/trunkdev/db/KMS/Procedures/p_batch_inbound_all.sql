create or replace procedure p_batch_inbound_all
/****************************************************************/
   ------------------- ��Ʊ����������� -------------------
   ---- ��Ʊ����������⡣����ϵͳ��ʼ����ʱ���Ӹ����ֹ�˾�������Ρ�
   ----     ͨ��ѭ������p_batch_inbound��ʵ�֡�
   ----     �������У�����ʾδ��ȷ���Ķ����Լ���Ӧ�Ĵ�����Ϣ��
   ---- ִ�й��̣�
   ----     1��������Ĳ�Ʊ���ͽ��������������ÿһ����������ѭ�����ô洢����
   ----     2�����ô洢����֮ǰ����Ҫ�����������Ƿ��Ѿ�����Ӧ�����������Ϣ������о���������Ϊ����������Ϊ׷��

   /*************************************************************/
(
 --------------����----------------
 p_warehouse         in char,                               -- �ֿ�
 p_oper              in number,                             -- ������
 p_array_lotterys    in type_lottery_list,                  -- ���Ĳ�Ʊ����

 ---------���ڲ���---------
 c_err_list          out type_lottery_import_err_list,      -- ���δ����б�
 c_errorcode         out number,                            -- �������
 c_errormesg         out string                             -- ����ԭ��

 ) is

   v_err_info              type_lottery_import_err_info;
   v_err_list              type_lottery_import_err_list;

   v_plan_objs             type_lottery_list;

   v_bi_no                 char(10);                                       -- ������ⵥ���(bi12345678)
   v_oper_type             number(1);                                      -- ��������(1-������2-����)

   v_err_code              number(10);
   v_err_msg               varchar2(4000);

begin

   /*-----------    ��ʼ������    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- ����У��   -----------------*/
   -- У����ڲ����Ƿ���ȷ����Ӧ�����ݼ�¼�Ƿ����
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- �޴���
      return;
   end if;

   if not f_check_warehouse(p_warehouse) then
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_warehouse) || error_msg.err_common_101; -- �޴˲ֿ�
      return;
   end if;

   /*----------- ҵ���߼�   -----------------*/
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

     -- ȷ�����Ķ���
     select type_lottery_info(plan_code ,batch_no ,valid_number,trunk_no ,box_no ,box_no_e ,package_no ,package_no_e, reward_group)
       bulk collect into v_plan_objs
       from table(p_array_lotterys)
      where plan_code = lottery_plan.plan_code
        and batch_no = lottery_plan.batch_no;

      -- ���ô洢����
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
