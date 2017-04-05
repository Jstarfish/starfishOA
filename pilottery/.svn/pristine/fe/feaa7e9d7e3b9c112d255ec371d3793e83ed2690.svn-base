/********************************************************************************/
  ------------------- 适用于检查机构是否存在 ----------------------------
  ---- add by 陈震: 2015/10/13
/********************************************************************************/
create or replace function f_check_org(p_org in varchar2)
   return boolean
 is
   v_count number(1);
begin
   select count(*) into v_count from dual where exists(select 1 from inf_orgs where org_code=p_org);
   if v_count = 1 then
      return true;
   else
      return false;
   end if;
end;
