/********************************************************************************/
  ------------------- 适用于检查盒是否存在 ----------------------------
  ---- add by 陈震: 2015/10/29
/********************************************************************************/
create or replace function f_check_box(p_plan varchar2, p_batch varchar2, p_box varchar2)
   return boolean
 is
   v_count number(1);
begin
   select count(*) into v_count from dual where exists(select 1 from wh_ticket_box where plan_code=p_plan and batch_no=p_batch and box_no=p_box);
   if v_count = 1 then
      return true;
   else
      return false;
   end if;
end;
