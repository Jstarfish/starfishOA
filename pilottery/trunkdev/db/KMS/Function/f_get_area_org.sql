/********************************************************************************/
  ------------------- 返回区域所属组织机构代码-----------------------------
  ----add by 陈震: 2015/11/10
/********************************************************************************/
create or replace function f_get_area_org(
   p_area in string --站点编码

) return string is
   /*-----------    变量定义     -----------------*/
   v_ret_code string(8) := ''; -- 返回值

begin

   select org_code
     into v_ret_code
     from inf_org_area
    where area_code = p_area;

   return v_ret_code;

end;
