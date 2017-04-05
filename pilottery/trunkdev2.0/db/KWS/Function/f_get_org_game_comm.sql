CREATE OR REPLACE FUNCTION f_get_org_game_comm(
   p_org_code IN STRING,     --站点编码
   p_game_code in number,    -- 游戏编码
   p_comm_type in number     -- 代销费类型（ecomm_type）

) RETURN number IS
   /*-----------    变量定义     -----------------*/
   v_ret_code number(8);   -- 返回值
   v_org_type number(1);   -- 组织机构类型

BEGIN

   -- 检测组织机构类型
   select org_type
     into v_org_type
     from inf_orgs
    where org_code = p_org_code;

   if v_org_type = eorg_type.company then
      v_ret_code := 0;
      return v_ret_code;
   end if;

   case p_comm_type
      when ecomm_type.sale then
         begin
            select sale_commission_rate into v_ret_code
              from auth_org
             where org_code = p_org_code
               and game_code = p_game_code;
         exception
            when no_data_found then
               v_ret_code := 0;
         end;

      when ecomm_type.pay then
         begin
            select pay_commission_rate into v_ret_code
              from auth_org
             where org_code = p_org_code
               and game_code = p_game_code;
         exception
            when no_data_found then
               v_ret_code := 0;
         end;
   end case;

   return v_ret_code;

END;
