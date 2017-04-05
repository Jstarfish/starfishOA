CREATE OR REPLACE FUNCTION f_check_ticket_perfect(
/***************************************************************************************************/
  ------------------- 检查彩票数组成员之间，是否存在相互包含的关系，同时也检查是否重复 --------------
  ------------------- 用于，入库明细和出库明细的嵌套检查 --------------------------------------------
  ---- add by 陈震: 2015/9/25
/********************************************************************************/
   p_lot_array             in type_lottery_list
)
   RETURN BOOLEAN
IS
   v_loop                  number(10);
   v_loop1                 number(10);
   v_lottery_info          type_lottery_info;                              -- 单张彩票
   v_array_lottery         type_lottery_list;                              -- 去掉自己以后的数组

BEGIN
   --p_debug_print_lottery(p_lot_array,'f_check_ticket_perfect parameter');
   for v_loop in 1 .. p_lot_array.count loop
      v_lottery_info := p_lot_array(v_loop);
      v_array_lottery := type_lottery_list();

      for v_loop1 in 1 .. p_lot_array.count loop
         continue when v_loop1 = v_loop;
         v_array_lottery.extend;
         v_array_lottery(v_array_lottery.count) := p_lot_array(v_loop1);
      end loop;

      if f_check_ticket_include(v_lottery_info, v_array_lottery) then
         return true;
      end if;

   end loop;

   -- 不包含
   return false;
END;
