/********************************************************************************/
  ------------------- 返回人员所属组织机构代码-----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_admin_org(
   p_admin IN number -- 操作人员

) RETURN STRING IS
   /*-----------    变量定义     -----------------*/
   v_ret_code STRING(8) := ''; -- 返回值

BEGIN

   select ADMIN_ORG
     into v_ret_code
     from ADM_INFO
    where ADMIN_ID = p_admin;

   return v_ret_code;

END;
