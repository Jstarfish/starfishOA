/********************************************************************************/
  ------------------- 返回方案的名称-----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_plan_name(
   p_plan IN STRING --站点编码

) RETURN STRING IS
   /*-----------    变量定义     -----------------*/
   v_ret_code STRING(64) := ''; -- 返回值

BEGIN

   select SHORT_NAME
     into v_ret_code
     from game_plans
    where PLAN_CODE = p_plan;

   return v_ret_code;

END;
