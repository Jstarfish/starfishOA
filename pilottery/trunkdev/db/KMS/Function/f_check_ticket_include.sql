CREATE OR REPLACE FUNCTION f_check_ticket_include(
   p_lottery               in type_lottery_info,
   p_lot_array             in type_lottery_list
)
   RETURN BOOLEAN
IS
   v_loop                  number(10);
   v_array_lottery         type_lottery_info;                              -- 单张彩票

BEGIN

   --p_debug_print_lottery(p_lot_array, 'f_check_ticket_include parameter');
   --p_debug_print_lottery1(p_lottery);

   for v_loop in 1 .. p_lot_array.count loop
      v_array_lottery := p_lot_array(v_loop);

      -- 先匹配方案和批次，不属于同一个方案和批次，不用检查
      if not (p_lottery.plan_code = v_array_lottery.plan_code and p_lottery.batch_no = v_array_lottery.batch_no) then
         return false;
      end if;

      /**********************************************/
      /********-- 彩票的类型为“箱” --****/
      if p_lottery.valid_number = evalid_number.trunk then
         -- 对方只要包含这箱票，就出现错误，因为存在关联关系。不能在一个清单中，既处理父对象，又处理子对象
         if p_lottery.trunk_no = v_array_lottery.trunk_no then
            raise_application_error(-20001, f_print_lottery(p_lottery) || error_msg.err_f_check_ticket_include_1);
            return true;
         end if;

      end if;

      /**********************************************/
      /********-- 彩票的类型为“盒” --****/
      if p_lottery.valid_number = evalid_number.box then
         case
            when v_array_lottery.valid_number in (evalid_number.box, evalid_number.pack) then
               -- 对应数组中的对象为“盒”或者“票”时，判断“盒”号是否相同
               if p_lottery.box_no = v_array_lottery.box_no then
                  raise_application_error(-20001, f_print_lottery(p_lottery) || error_msg.err_f_check_ticket_include_2);
                  return true;
               end if;

            when v_array_lottery.valid_number = evalid_number.trunk then
               -- 对应数组中的对象为“箱”时，判断“盒”对应的箱号是否相同
               if p_lottery.trunk_no = v_array_lottery.trunk_no then
                  raise_application_error(-20001, f_print_lottery(p_lottery) || error_msg.err_f_check_ticket_include_2);
                  return true;
               end if;
         end case;
      end if;


      /**********************************************/
      /********-- 彩票的类型为“票” --****/
      if p_lottery.valid_number = evalid_number.pack then
         case
            when v_array_lottery.valid_number = evalid_number.pack then
               -- 对应数组中的对象为“票”时，判断票号是否相同
               if p_lottery.package_no = v_array_lottery.package_no then
                  raise_application_error(-20001, f_print_lottery(p_lottery) || error_msg.err_f_check_ticket_include_3);
                  return true;
               end if;

            when v_array_lottery.valid_number in (evalid_number.box, evalid_number.trunk) then
               -- 对应数组中的对象为“盒”或者“箱”时，判断票号是否包含在“盒”或者“箱”对应的票中
               if (p_lottery.package_no >= v_array_lottery.package_no) and (p_lottery.package_no <= v_array_lottery.package_no_e) then
                  raise_application_error(-20001, f_print_lottery(p_lottery) || error_msg.err_f_check_ticket_include_3);
                  return true;
               end if;
         end case;
      end if;

   end loop;

   -- 不包含
   return false;
END;
