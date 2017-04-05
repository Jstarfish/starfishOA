/********************************************************************************/
  ------------------- 适用于检查本是否存在 ----------------------------
  ---- add by 陈震: 2015/10/29
/********************************************************************************/
create or replace function f_check_pack(p_plan varchar2, p_batch varchar2, p_pack varchar2)
   return boolean
 is
   v_count number(1);
begin
   select count(*) into v_count from dual where exists(select 1 from wh_ticket_package where plan_code=p_plan and batch_no=p_batch and package_no=p_pack);
   if v_count = 1 then
      return true;
   else
      return false;
   end if;
end;
