/********************************************************************************/
  ------------------- 适用于检查用户是否存在 ----------------------------
  ---- add by 陈震: 2015/9/17
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_check_admin(p_admin in number)
   RETURN BOOLEAN
 IS
   v_count number(1);
BEGIN
   select count(*) into v_count from dual where exists(select 1 from ADM_INFO where ADMIN_ID=p_admin);
   if v_count = 1 then
      return true;
   else
      return false;
   end if;
END;
