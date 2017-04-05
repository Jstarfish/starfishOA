create or replace procedure p_item_outbound
/****************************************************************/
   ------------------- ��Ʒ���� -------------------
   ---- ������Ʒ���⡣
   ---- create by ���� @ 2015/10/13
   ---- in param 'p_remark' added by WangQingxiang on 2015-12-31
   /*************************************************************/
(
 --------------����----------------
   p_oper              in number,              -- ������
   p_warehouse         in char,                -- ����ֿ�
   p_receive_org       in char,                -- �ջ���λ
   p_items             in type_item_list,      -- �������Ʒ����
   p_remark            in string,              -- remark

 ---------���ڲ���---------
   c_ii_no     out string,                     -- ��Ʒ���ⵥ���
   c_errorcode out number,                     -- �������
   c_errormesg out string                      -- ����ԭ��

 ) is

   v_wh_org                char(2);                                        -- �ֿ����ڲ���
   v_ii_no                 char(10);                                       -- ���ⵥ���
   v_quantity              number(18);                                     -- �������
   v_count                 number(18);                                     -- ������

   v_list_count            number(10);                                     -- ������ϸ����

   type type_detail        is table of ITEM_ISSUE_DETAIL%rowtype;
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

   -- �������Ƿ����
   if not f_check_org(p_receive_org) then
      c_errorcode := 3;
      c_errormesg := dbtool.format_line(p_receive_org) || error_msg.err_p_institutions_topup_3; -- �޴˻���
      return;
   end if;


   -- ��ѯ�ֿ���������
   select org_code
     into v_wh_org
     from wh_info
    where warehouse_code = p_warehouse;

   -- ��¼��Ʒ�������ϸ
   insert into ITEM_ISSUE (II_NO,                OPER_ADMIN, ISSUE_DATE, RECEIVE_ORG,   SEND_ORG, SEND_WH,     REMARK)
                   values (f_get_item_ii_no_seq, p_oper,     sysdate,    p_receive_org, v_wh_org, p_warehouse, p_remark)
                returning ii_no
                into      v_ii_no;

   for v_list_count in 1 .. p_items.count loop
      v_insert_detail.extend;
      v_insert_detail(v_insert_detail.count).ii_no := v_ii_no;
      v_insert_detail(v_insert_detail.count).item_code := p_items(v_list_count).item_code;
      v_insert_detail(v_insert_detail.count).quantity := p_items(v_list_count).quantity;
   end loop;

   forall v_list_count in 1 .. v_insert_detail.count
      insert into ITEM_ISSUE_DETAIL values v_insert_detail(v_list_count);

   /****************/
   /* �޸���Ʒ��� */
   -- ���ҿ���У��Ƿ���ڴ�����Ʒ�����û�У��ͱ�������У����ٿ��
   for v_list_count in 1 .. p_items.count loop
      select count(*)
        into v_count
        from item_quantity
       where ITEM_CODE = p_items(v_list_count).item_code;
      if v_count = 0 then
         rollback;
         c_errorcode := 4;
         c_errormesg := dbtool.format_line(p_items(v_list_count).item_code) || error_msg.err_p_item_delete_2; -- �����ڴ���Ʒ
         return;
      end if;

      select count(*)
        into v_count
        from item_quantity
       where ITEM_CODE = p_items(v_list_count).item_code
         and WAREHOUSE_CODE = p_warehouse;
      if v_count = 0 then
         rollback;
         c_errorcode := 5;
         c_errormesg := dbtool.format_line(p_items(v_list_count).item_code) || dbtool.format_line(p_warehouse) || error_msg.err_p_item_outbound_1; -- �ֿ����޴���Ʒ
         return;
      end if;

      update item_quantity
         set quantity = quantity - p_items(v_list_count).quantity
       where item_code = p_items(v_list_count).item_code
         and WAREHOUSE_CODE = p_warehouse
      returning quantity
            into v_quantity;
      if v_quantity < 0 then
         rollback;
         c_errorcode := 6;
         c_errormesg := dbtool.format_line(p_items(v_list_count).item_code) || dbtool.format_line(p_warehouse) || error_msg.err_p_item_outbound_2; -- �ֿ��д���Ʒ��������
         return;
      end if;

   end loop;

   c_ii_no := v_ii_no;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 100;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;


