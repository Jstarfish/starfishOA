/********************************************************************************/
  ------------------- 适用于检查箱是否存在 ----------------------------
  ---- add by 陈震: 2015/10/29
/********************************************************************************/
create or replace function f_check_trunk(p_plan varchar2, p_batch varchar2, p_trunk varchar2)
   return boolean
 is
   v_count number(1);
begin
   select count(*) into v_count from dual where exists(select 1 from wh_ticket_trunk where plan_code=p_plan and batch_no=p_batch and trunk_no=p_trunk);
   if v_count = 1 then
      return true;
   else
      return false;
   end if;
end;
