CREATE OR REPLACE FUNCTION f_check_import_ticket(
/***************************************************************************************************/
  ----------------- 用于检查出入库票明细之间，是否存在关联关系 -------------------------------------
  ---- add by 陈震: 2015/9/28
  ---- modify by dzg :2015/10/27 增加盘点校验
/********************************************************************************/
   p_sn                    in char,
   p_type                  in number,                 -- 类型（1-入库，2-出库， 3-盘点）
   p_lot_array             in type_lottery_list
)
   RETURN BOOLEAN
IS
   v_lottery_detail        type_lottery_info;                              -- 单张彩票
   v_array_lottery         type_lottery_info;                              -- 去掉自己以后的数组
   v_format_lotterys       type_lottery_list;
   v_all_lottery_list      type_lottery_list;

BEGIN
   /************************************************************************************/
   /******************* 检查输入的出入库对象是否合法 *************************/
   v_format_lotterys := type_lottery_list();
   for v_list_count in 1 .. p_lot_array.count loop
      v_array_lottery := p_lot_array(v_list_count);
      case
         when v_array_lottery.valid_number = evalid_number.trunk then
            v_array_lottery.box_no := '-';
            v_array_lottery.package_no := '-';

         when v_array_lottery.valid_number = evalid_number.box then
            v_lottery_detail := f_get_lottery_info(v_array_lottery.plan_code, v_array_lottery.batch_no, v_array_lottery.valid_number, v_array_lottery.box_no);
            v_array_lottery.trunk_no := v_lottery_detail.trunk_no;
            v_array_lottery.package_no := '-';

         when v_array_lottery.valid_number = evalid_number.pack then
            v_lottery_detail := f_get_lottery_info(v_array_lottery.plan_code, v_array_lottery.batch_no, v_array_lottery.valid_number, v_array_lottery.package_no);
            v_array_lottery.trunk_no := v_lottery_detail.trunk_no;
            v_array_lottery.box_no := v_lottery_detail.box_no;

      end case;

      v_format_lotterys.extend;
      v_format_lotterys(v_format_lotterys.count) := v_array_lottery;
   end loop;

   case
      when p_type = 1 then
         -- 判断入库对象有没有与已经入库的内容重复，或者存在交叉的对象（例如：已经入整箱，再入箱中的一本彩票）
         select type_lottery_info(plan_code, batch_no, valid_number, trunk_no, box_no, '', package_no, '', 0)
           bulk collect into v_all_lottery_list
           from wh_goods_receipt_detail
          where ref_no = p_sn;

      when p_type = 2 then
         -- 判断出库对象有没有与已经出库的内容重复，或者存在交叉的对象（例如：已经入整箱，再入箱中的一本彩票）
         select type_lottery_info(plan_code, batch_no, valid_number, trunk_no, box_no, '', package_no, '', 0)
           bulk collect into v_all_lottery_list
           from wh_goods_issue_detail
          where ref_no = p_sn;
          
       when p_type = 3 then
         --盘点详情单检测
         select type_lottery_info(plan_code, batch_no, valid_number, trunk_no, box_no, '', package_no, '', 0)
          bulk collect into v_all_lottery_list
          from wh_check_point_detail
         where cp_no = p_sn;
          
      else
         raise_application_error(-20001, error_msg.err_f_check_import_ticket);
   end case;

   -- 合并当前数组
   v_all_lottery_list := v_all_lottery_list multiset union v_format_lotterys;

   if f_check_ticket_perfect(v_all_lottery_list) then
      return true;
   end if;

   return false;
END;
