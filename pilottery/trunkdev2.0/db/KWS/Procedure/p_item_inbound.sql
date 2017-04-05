create or replace procedure p_item_inbound
/****************************************************************/
   ------------------- 物品入库 -------------------
   ---- 用于物品入库。
   ---- create by 陈震 @ 2015/10/13
   ---- in param 'p_remark' added by WangQingxiang on 2015-12-31
   /*************************************************************/
(
 --------------输入----------------
   p_oper              in number,              -- 操作人
   p_warehouse         in char,                -- 入库仓库
   p_items             in type_item_list,      -- 入库的物品对象
   p_remark            in string,              -- remark

 ---------出口参数---------
   c_ir_no     out string,                     -- 物品入库单编号
   c_errorcode out number,                     -- 错误编码
   c_errormesg out string                      -- 错误原因

 ) is

   v_wh_org                char(2);                                        -- 仓库所在部门
   v_ir_no                 char(10);                                       -- 入库单编号

   v_list_count            number(10);                                     -- 入库明细总数

   type type_detail        is table of item_receipt_detail%rowtype;
   v_insert_detail         type_detail;                                    -- 插入入库明细的数组

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

   -- 查询仓库所属部门
   select org_code
     into v_wh_org
     from wh_info
    where warehouse_code = p_warehouse;

   -- 记录物品入库和明细
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
   /* 修改物品库存 */
   -- 查找库存中，是否存在此种物品，如果没有，就增加；如果有，增加库存
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


