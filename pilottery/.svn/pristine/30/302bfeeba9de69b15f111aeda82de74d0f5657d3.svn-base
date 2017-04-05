/********************************************************************************/
  ------------------- 返回站点所属组织机构代码-----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_agency_org(
   p_agency IN STRING --站点编码

) RETURN STRING IS
   /*-----------    变量定义     -----------------*/
   v_ret_code STRING(8) := ''; -- 返回值

BEGIN

   select ORG_CODE
     into v_ret_code
     from INF_AGENCYS
    where AGENCY_CODE = p_agency;

   return v_ret_code;

END;
