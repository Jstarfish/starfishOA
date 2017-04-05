/********************************************************************************/
  ------------------- 适用于检查批次是否可用 ----------------------------
  ---- add by 陈震: 2015/9/17
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_check_plan_batch_status(p_plan in varchar2, p_batch in varchar2)
   RETURN BOOLEAN
 IS
   v_count number(1);
BEGIN
   select count(*) into v_count from dual where exists(select 1 from GAME_BATCH_IMPORT_DETAIL where PLAN_CODE=p_plan and BATCH_NO=p_batch and STATUS = ebatch_item_status.working);
   if v_count = 1 then
      return true;
   else
      return false;
   end if;
END;
