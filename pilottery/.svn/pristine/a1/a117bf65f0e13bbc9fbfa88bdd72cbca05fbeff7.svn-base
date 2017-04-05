/********************************************************************************/
  ------------------- 返回方案的名称（包含旧票） -----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_old_plan_name(
   p_plan IN STRING, -- 方案
   p_batch in string -- 批次

) RETURN STRING IS
   /*-----------    变量定义     -----------------*/
   v_ret_code STRING(64) := ''; -- 返回值

BEGIN
   case
      when (p_plan = 'J0002' or (p_plan = 'J2015' and p_batch = '00001')) then
         return 'Iphone';
      when (p_plan = 'J0003' or (p_plan = 'J2015' and p_batch = '00002')) then
         return 'Ball';
      when (p_plan = 'J0004') then
         return 'GongXi';
      when (p_plan = 'J0005') then
         return 'DGL';
      when (p_plan = 'J2014') then
         return 'Love';
      else
         select SHORT_NAME
           into v_ret_code
           from game_plans
          where PLAN_CODE = p_plan;

   end case;

   return v_ret_code;

END;
