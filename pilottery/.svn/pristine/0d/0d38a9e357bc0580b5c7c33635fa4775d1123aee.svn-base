/********************************************************************************/
  ------------------- 返回方案的名称（包含旧票） -----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_plan_code_by_name(
   p_plan_name IN STRING

) RETURN STRING IS
   /*-----------    变量定义     -----------------*/
   v_ret_code STRING(4000) := ''; -- 返回值

BEGIN

   case
      when p_plan_name = 'Iphone' then
         return 'J0002';

      when p_plan_name = 'Ball' then
         return 'J0003';

      when p_plan_name = 'GongXi' then
         return 'J0004';

      when p_plan_name = 'DGL' then
         return 'J0005';

      when p_plan_name = 'Love' then
         return 'J2014';

      else
         begin
            select plan_code into v_ret_code from game_plans where SHORT_NAME = p_plan_name;
         exception
            when no_data_found then
               v_ret_code := '[NO NAME]';
         end;
         return v_ret_code;
   end case;

   return v_ret_code;
END;
