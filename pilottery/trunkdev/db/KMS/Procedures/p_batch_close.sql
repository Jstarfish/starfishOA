create or replace procedure p_batch_end
/****************************************************************/
   ------------------- �����ս� -------------------
   ---- �����սᡣ
   ----     ��ѯ���ֲ�Ʊ��״̬����������ڡ�11-�ڿ⡢31-�����ۡ�41-������42-�𻵡�43-��ʧ��״̬ʱ���Ϳ��Խ��������սᡣ
   ----     �ս�ʱ
   ----        1����Ҫ���á�2.1.4.5 ������Ϣ����֮��װ��game_batch_import_detail�����е�״̬Ϊ�����С�
   ----        2��ͳ�����۽��ҽ����������
   ----        3�����������ս��ͳ������
   ---- add by ����: 2015/9/19
   ---- �漰��ҵ���
   ----     2.1.4.5 ������Ϣ����֮��װ��game_batch_import_detail��   -- ����
   ----     2.1.5.18 �����սᣨwh_batch_end��                        -- ����
   ----     2.1.5.3 ����Ʊ��Ϣ���䣩            -- ����
   ----     2.1.5.4 ����Ʊ��Ϣ���У�            -- ����
   ----     2.1.5.5 ����Ʊ��Ϣ������            -- ����
   ---- ҵ�����̣�
   ----     1��У��������������������Ƿ�Ϸ�����
   ----     2����ѯ���ֲ�Ʊ��״̬���Ϸ�ʱ���Ϳ��Խ��������սᡣ
   ----     3��ͳ�����۽��ҽ����������
   ----     4�����������ս��ͳ������

   /*************************************************************/
(
   --------------����----------------
   p_plan          in varchar2,                                                -- ��������
   p_batch         in varchar2,                                              -- ���κ���
   p_oper          in number,                                              -- ������

   ---------���ڲ���---------
   c_errorcode out number,                                                 --�������
   c_errormesg out string                                                  --����ԭ��

 ) is

   v_count                 number(5);                                      -- ���¼������ʱ����
   v_collect_batch_end     wh_batch_end%rowtype;                           -- �����ս���н����
   v_collect_batch_param   game_batch_import_detail%rowtype;               -- ���β���

begin

   /*-----------    ��ʼ������    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- ����У��   -----------------*/
   -- У����ڲ����Ƿ���ȷ����Ӧ�����ݼ�¼�Ƿ����
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_p_batch_end_1; -- �޴���
      return;
   end if;

   /*----------- ҵ���߼�   -----------------*/
   /********************************************************************************************************************************************************************/
   /******************* ��ѯ���ֲ�Ʊ��״̬���Ϸ�ʱ���Ϳ��Խ��������սᡣ *************************/

   -- ��ȡ���β���
   select * into v_collect_batch_param from game_batch_import_detail where plan_code = p_plan and batch_no = p_batch;

   -- ͳ�����۽��ҽ����������
   select count(*)
     into v_collect_batch_end.sale_amount
     from wh_ticket_package
    where plan_code = p_plan
     and batch_no = p_batch
     and status = eticket_status.saled;

   -- ͳ�ƶҽ����
   select nvl(sum(pay_amount), 0)
     into v_collect_batch_end.pay_amount
     from flow_pay
    where plan_code = p_plan
      and batch_no = p_batch;

   -- ͳ�ƿ������
   select nvl(sum(packs), 0) * v_collect_batch_param.tickets_every_pack
     into v_collect_batch_end.inventory_tickets
     from (
            select (to_number(package_no_end) - to_number(package_no_start)) packs from wh_ticket_trunk  where plan_code = p_plan and batch_no = p_batch and status = eticket_status.in_warehouse
            union all
            select (to_number(package_no_end) - to_number(package_no_start)) packs from wh_ticket_box  where plan_code = p_plan and batch_no = p_batch and status = eticket_status.in_warehouse
            union all
            select count(*) packs from wh_ticket_box  where plan_code = p_plan and batch_no = p_batch and status = eticket_status.in_warehouse
          );

   -- ��������
   insert into wh_batch_end
      (be_no,                             plan_code,                      batch_no,                               tickets,
       sale_amount,                       pay_amount,                     inventory_tickets,                      create_admin,                                create_date)
   values
      (f_get_wh_batch_end_seq,            p_plan,                         p_batch,                                v_collect_batch_param.tickets_every_batch,
       v_collect_batch_end.sale_amount,   v_collect_batch_end.pay_amount, v_collect_batch_end.inventory_tickets,  p_oper,                                      sysdate);

   -- �޸�״̬
   update game_batch_import_detail
      set status = ebatch_item_status.quited
    where plan_code = p_plan
      and batch_no = p_batch;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;
end;

