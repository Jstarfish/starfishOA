/********************************************************************************/
  ------------------- ��������������֯��������-----------------------------
  ----add by ����: 2015/11/10
/********************************************************************************/
create or replace function f_get_area_org(
   p_area in string --վ�����

) return string is
   /*-----------    ��������     -----------------*/
   v_ret_code string(8) := ''; -- ����ֵ

begin

   select org_code
     into v_ret_code
     from inf_org_area
    where area_code = p_area;

   return v_ret_code;

end;
