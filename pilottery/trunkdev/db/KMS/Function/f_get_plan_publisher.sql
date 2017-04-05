/********************************************************************************/
  ------------------- 获取方案对应的印制厂商 ----------------------------
  ---- add by 陈震: 2015/9/16
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_plan_publisher(
   p_plan in varchar2
)
   RETURN number

 IS
   v_publish number;

BEGIN
   select PUBLISHER_CODE into v_publish from GAME_PLANS where PLAN_CODE = p_plan;

   return v_publish;
END;
