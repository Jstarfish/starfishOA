/********************************************************************************/
  ------------------- ������֯��������-----------------------------
  ----add by ����: 2015/10/14
/********************************************************************************/
create or replace function f_get_org_type(
   p_org in char --վ�����

) return number is
   /*-----------    ��������     -----------------*/
   v_ret_code number(1); -- ����ֵ

begin

   select org_type
     into v_ret_code
     from inf_orgs
    where org_code = p_org;

   return v_ret_code;

end;
