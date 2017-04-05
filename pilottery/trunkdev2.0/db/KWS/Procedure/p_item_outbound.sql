create or replace procedure p_item_outbound
/****************************************************************/
   ------------------- 物品出库 -------------------
   ---- 用于物品出库。
   ---- create by 陈震 @ 2015/10/13
   ---- in param 'p_remark' added by WangQingxiang on 2015-12-31
   /*************************************************************/
(
 --------------输入----------------
   p_oper              in number,              -- 操作人
   p_warehouse         in char,                -- 出库仓库
   p_receive_org       in char,                -- 收货单位
   p_items             in type_item_list,      -- 出库的物品对象
   p_remark            in string,              -- remark

 ---------出口参数---------
   c_ii_no     out string,                     -- 物品出库单编号
   c_errorcode out number,                     -- 错误编码
   c_errormesg out string                      -- 错误原因

 ) is

   v_wh_org                char(2);                                        -- 仓库所在部门
   v_ii_no                 char(10);                                       -- 出库单编号
   v_quantity              number(18);                                     -- 库存数量
   v_count                 number(18);                                     -- 计数器

   v_list_count            number(10);                                     -- 出库明细总数

   type type_detail        is table of ITEM_ISSUE_DETAIL%rowtype;
   v_insert_detail         type_detail;                                    -- 插入出库明细的数组

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   v_insert_detail := new type_detail();

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   if not f_check_admin(p_oper) then
      c_errorcode := 1;
      c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
      return;
   end if;

   -- 检查此仓库是否存在
   if not f_check_warehouse(p_warehouse) then
      c_errorcode := 2;
      c_errormesg := dbtool.format_line(p_warehouse) || error_msg.err_common_101; -- 无此仓库
      return;
   end if;

   -- 检查机构是否存在
   if not f_check_org(p_receive_org) then
      c_errorcode := 3;
      c_errormesg := dbtool.format_line(p_receive_org) || error_msg.err_p_institutions_topup_3; -- 无此机构
      return;
   end if;


   -- 查询仓库所属部门
   select org_code
     into v_wh_org
     from wh_info
    where warehouse_code = p_warehouse;

   -- 记录物品出库和明细
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
   /* 修改物品库存 */
   -- 查找库存中，是否存在此种物品，如果没有，就报错；如果有，减少库存
   for v_list_count in 1 .. p_items.count loop
      select count(*)
        into v_count
        from item_quantity
       where ITEM_CODE = p_items(v_list_count).item_code;
      if v_count = 0 then
         rollback;
         c_errorcode := 4;
         c_errormesg := dbtool.format_line(p_items(v_list_count).item_code) || error_msg.err_p_item_delete_2; -- 不存在此物品
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
         c_errormesg := dbtool.format_line(p_items(v_list_count).item_code) || dbtool.format_line(p_warehouse) || error_msg.err_p_item_outbound_1; -- 仓库中无此物品
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
         c_errormesg := dbtool.format_line(p_items(v_list_count).item_code) || dbtool.format_line(p_warehouse) || error_msg.err_p_item_outbound_2; -- 仓库中此物品数量不足
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


