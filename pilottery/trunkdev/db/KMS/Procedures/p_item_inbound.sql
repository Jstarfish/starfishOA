create or replace procedure p_item_inbound
/****************************************************************/
   ------------------- ��Ʒ��� -------------------
   ---- ������Ʒ��⡣
   ---- create by ���� @ 2015/10/13
   ---- in param 'p_remark' added by WangQingxiang on 2015-12-31
   /*************************************************************/
(
 --------------����----------------
   p_oper              in number,              -- ������
   p_warehouse         in char,                -- ���ֿ�
   p_items             in type_item_list,      -- ������Ʒ����
   p_remark            in string,              -- remark

 ---------���ڲ���---------
   c_ir_no     out string,                     -- ��Ʒ��ⵥ���
   c_errorcode out number,                     -- �������
   c_errormesg out string                      -- ����ԭ��

 ) is

   v_wh_org                char(2);                                        -- �ֿ����ڲ���
   v_ir_no                 char(10);                                       -- ��ⵥ���

   v_list_count            number(10);                                     -- �����ϸ����

   type type_detail        is table of item_receipt_detail%rowtype;
   v_insert_detail         type_detail;                                    -- ���������ϸ������

begin

   /*-----------    ��ʼ������    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   v_insert_detail := new type_detail();

   /*----------- ����У��   -----------------*/
   -- У����ڲ����Ƿ���ȷ����Ӧ�����ݼ�¼�Ƿ����
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- �޴���
      return;
   end if;

   -- ���˲ֿ��Ƿ����
   if not f_check_warehouse(p_warehouse) then
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_warehouse) || error_msg.err_common_101; -- �޴˲ֿ�
      return;
   end if;

   -- ��ѯ�ֿ���������
   select org_code
     into v_wh_org
     from wh_info
    where warehouse_code = p_warehouse;

   -- ��¼��Ʒ������ϸ
   insert into item_receipt (ir_no,                create_admin, receive_org, receive_wh,  receive_date, remark)
                     values (f_get_item_ir_no_seq, p_oper,       v_wh_org,    p_warehouse, sysdate,      p_remark)
                  returning ir_no
                  into      v_ir_no;

   for v_list_count in 1 .. p_items.count loop
      v_insert_detail.extend;
      v_insert_detail(v_insert_detail.count).ir_no := v_ir_no;
      v_insert_detail(v_insert_detail.count).item_code := p_items(v_list_count).item_code;
      v_insert_detail(v_insert_detail.count).quantity := p_items(v_list_count).quantity;
   end loop;

   forall v_list_count in 1 .. v_insert_detail.count
      insert into item_receipt_detail values v_insert_detail(v_list_count);

   /****************/
   /* �޸���Ʒ��� */
   -- ���ҿ���У��Ƿ���ڴ�����Ʒ�����û�У������ӣ�����У����ӿ��
   forall v_list_count in 1 .. p_items.count
      merge into item_quantity dest
      using (select p_items(v_list_count).item_code item_code, p_warehouse warehouse_code from dual) src
         on (dest.item_code = src.item_code and dest.warehouse_code = src.warehouse_code)
       when matched then
          update set dest.quantity = dest.quantity + p_items(v_list_count).quantity
       when not matched then
          insert values (p_items(v_list_count).item_code, p_warehouse   , (select item_name from item_items where item_code = p_items(v_list_count).item_code), p_items(v_list_count).quantity);

   c_ir_no := v_ir_no;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;


