/********************************************************************************/
  ------------------- 返回站点对应游戏的代销费比例-----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_agency_game_comm(
   p_agency IN STRING,     --站点编码
   p_game_code in number,  -- 游戏编码
   p_comm_type in number   -- 代销费类型（ecomm_type）

) RETURN number IS
   /*-----------    变量定义     -----------------*/
   v_ret_code number(8) := ''; -- 返回值

BEGIN

   case p_comm_type
      when ecomm_type.sale then
         begin
            select sale_commission_rate into v_ret_code
              from auth_agency
             where agency_code = p_agency
               and game_code = p_game_code;
         exception
            when no_data_found then
               v_ret_code := 0;
         end;

      when ecomm_type.pay then
         begin
            select pay_commission_rate into v_ret_code
              from auth_agency
             where agency_code = p_agency
               and game_code = p_game_code;
         exception
            when no_data_found then
               v_ret_code := 0;
         end;
   end case;

   return v_ret_code;

END;
