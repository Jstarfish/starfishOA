/********************************************************************************/
  ------------------- 适用于检查仓库是否存在 ----------------------------
  ---- add by 陈震: 2015/9/17
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_check_warehouse(p_wh in varchar2)
   RETURN BOOLEAN
 IS
   v_count number(1);
BEGIN
   select count(*) into v_count from dual where exists(select 1 from WH_INFO where WAREHOUSE_CODE=p_wh);
   if v_count = 1 then
      return true;
   else
      return false;
   end if;
END;
