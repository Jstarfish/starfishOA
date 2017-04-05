create or replace function f_get_flow_pay_org(
   p_pay_flow in string --վ�����

) return string is
   /*-----------    ��������     -----------------*/
   v_ret_code  string(8) := ''; -- ����ֵ
   v_record flow_pay%rowtype;

begin

   select * into v_record from flow_pay where pay_flow = p_pay_flow;

   case
      when v_record.is_center_paid = 1 then        -- ���Ķҽ�
         v_ret_code := f_get_admin_org(v_record.payer_admin);

      when v_record.is_center_paid = 2 then        -- ����Ա�ҽ�
         v_ret_code := f_get_admin_org(v_record.payer_admin);

      when v_record.is_center_paid = 3 then        -- ����վ�ҽ�
         v_ret_code := f_get_agency_org(v_record.pay_agency);

      else
         return 'ERROR';
   end case;

   return v_ret_code;

end;
