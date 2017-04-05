CREATE OR REPLACE FUNCTION f_check_import_ticket(
/***************************************************************************************************/
  ----------------- ���ڼ������Ʊ��ϸ֮�䣬�Ƿ���ڹ�����ϵ -------------------------------------
  ---- add by ����: 2015/9/28
  ---- modify by dzg :2015/10/27 �����̵�У��
/********************************************************************************/
   p_sn                    in char,
   p_type                  in number,                 -- ���ͣ�1-��⣬2-���⣬ 3-�̵㣩
   p_lot_array             in type_lottery_list
)
   RETURN BOOLEAN
IS
   v_lottery_detail        type_lottery_info;                              -- ���Ų�Ʊ
   v_array_lottery         type_lottery_info;                              -- ȥ���Լ��Ժ������
   v_format_lotterys       type_lottery_list;
   v_all_lottery_list      type_lottery_list;

BEGIN
   /************************************************************************************/
   /******************* �������ĳ��������Ƿ�Ϸ� *************************/
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
         -- �ж���������û�����Ѿ����������ظ������ߴ��ڽ���Ķ������磺�Ѿ������䣬�������е�һ����Ʊ��
         select type_lottery_info(plan_code, batch_no, valid_number, trunk_no, box_no, '', package_no, '', 0)
           bulk collect into v_all_lottery_list
           from wh_goods_receipt_detail
          where ref_no = p_sn;

      when p_type = 2 then
         -- �жϳ��������û�����Ѿ�����������ظ������ߴ��ڽ���Ķ������磺�Ѿ������䣬�������е�һ����Ʊ��
         select type_lottery_info(plan_code, batch_no, valid_number, trunk_no, box_no, '', package_no, '', 0)
           bulk collect into v_all_lottery_list
           from wh_goods_issue_detail
          where ref_no = p_sn;
          
       when p_type = 3 then
         --�̵����鵥���
         select type_lottery_info(plan_code, batch_no, valid_number, trunk_no, box_no, '', package_no, '', 0)
          bulk collect into v_all_lottery_list
          from wh_check_point_detail
         where cp_no = p_sn;
          
      else
         raise_application_error(-20001, error_msg.err_f_check_import_ticket);
   end case;

   -- �ϲ���ǰ����
   v_all_lottery_list := v_all_lottery_list multiset union v_format_lotterys;

   if f_check_ticket_perfect(v_all_lottery_list) then
      return true;
   end if;

   return false;
END;
