/********************************************************************************/
  ------------------- 返回组织机构类型-----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
create or replace function f_get_org_type(
   p_org in char --站点编码

) return number is
   /*-----------    变量定义     -----------------*/
   v_ret_code number(1); -- 返回值

begin

   select org_type
     into v_ret_code
     from inf_orgs
    where org_code = p_org;

   return v_ret_code;

end;
