create or replace procedure p_mm_inv_check
/****************************************************************/
   ------------------- �г�����Ա����̵� -------------------
   ---- ����һ����Ʊ���飬ȷ�����г�����Ա�Ŀ��������Ա�Ϊ��λ���������������顣
   ---- 1����ʾ��Ʊ�����������Ա���еģ�
   ---- 2��Ӧ���ڹ���Ա��棬����δɨ��Ĳ�Ʊ

   ---- add by ����: 2015-12-08

   /*************************************************************/
(
 --------------����----------------
  p_oper                               in number,                             -- �г�����Ա
  p_array_lotterys                     in type_mm_check_lottery_list,         -- ����Ĳ�Ʊ����

  ---------���ڲ���---------
  c_array_lotterys                     out type_mm_check_lottery_list,        -- ����Ĳ�Ʊ����
  c_inv_tickets                        out number,                            -- �������
  c_check_tickets                      out number,                            -- �̵�����
  c_diff_tickets                       out number,                            -- ��������
  c_errorcode                          out number,                            -- �������
  c_errormesg                          out string                             -- ����ԭ��

 ) is

   v_tmp_lotterys                      type_mm_check_lottery_list;            -- ����Ʊ����
   v_out_lotterys                      type_mm_check_lottery_list;            -- ��ʱ��Ʊ����
   v_s1_lotterys                       type_mm_check_lottery_list;            -- ��ʱ��Ʊ����
   v_s2_lotterys                       type_mm_check_lottery_list;            -- ��ʱ��Ʊ����

begin

   /*-----------    ��ʼ������    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   c_inv_tickets := 0;
   c_check_tickets := 0;
   c_diff_tickets := 0;

   /*----------- ����У��   -----------------*/
   -- У����ڲ����Ƿ���ȷ����Ӧ�����ݼ�¼�Ƿ����
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- �޴���
      return;
   end if;

   /*----------- ҵ���߼�   -----------------*/
   /********************************************************************************************************************************************************************/
   -- ��ȡ����Ա���в�Ʊ���󣨱���
   select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, (ticket_no_end - ticket_no_start + 1), 0)
     bulk collect into v_tmp_lotterys
     from wh_ticket_package
    where status = 21
      and CURRENT_WAREHOUSE = p_oper;

   -- ���ɹ���Ա�������
   select sum(tickets)
     into c_inv_tickets
     from table(v_tmp_lotterys);
   c_inv_tickets := nvl(c_inv_tickets, 0);

   /********************************************************************************************************************************************************************/
   -- ��������Ĳ�Ʊ�У��ж��ٱ����ڿ�����Ա���е�.ͳ�ƽ�����Ʊ������Ϊ�̵�����
   select sum(src.tickets)
     into c_check_tickets
     from table(p_array_lotterys) dest
     join table(v_tmp_lotterys) src
    using (plan_code, batch_no, package_no);
   c_check_tickets := nvl(c_check_tickets, 0);

   -- ��� ��ȥ �̵㣬���Ϊ����
   c_diff_tickets := nvl(c_inv_tickets - c_check_tickets, 0);

   /********************************************************************************************************************************************************************/
   -- ��ȡδɨ���Ʊ
   select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, 0, 2)
     bulk collect into v_s2_lotterys
     from (
         select plan_code, batch_no, package_no from table(v_tmp_lotterys)
         minus
         select plan_code, batch_no, package_no from table(p_array_lotterys));

   -- ��ʾ���ڹ���Ա���е�Ʊ
   select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, 0, 1)
     bulk collect into v_s1_lotterys
     from (
         select plan_code, batch_no, package_no from table(p_array_lotterys)
         minus
         select plan_code, batch_no, package_no from table(v_tmp_lotterys));

   -- �ϲ����
   select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, tickets, status)
     bulk collect into v_out_lotterys
     from (
         select plan_code, batch_no, package_no, tickets, status from table(v_s1_lotterys)
         union all
         select plan_code, batch_no, package_no, tickets, status from table(v_s2_lotterys));

   c_array_lotterys := v_out_lotterys;

exception
   when others then
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;

