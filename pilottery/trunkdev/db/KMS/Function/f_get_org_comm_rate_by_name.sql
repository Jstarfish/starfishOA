/********************************************************************************/
  ------------------- ��ȡ��֯������Ӷ����� -----------------------------
  ----add by ����: 2015-12-20
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_org_comm_rate_by_name(
   p_org    IN STRING,        -- վ�����
   p_plan   in string,        -- ��������
   p_type   in number         -- Ӷ������ ��1=���ۡ�2=�ҽ���

) RETURN number IS
   /*-----------    ��������     -----------------*/
   v_rtv number; -- ����ֵ

   v_plan            varchar2(50);
   v_sale_comm       number(10);
   v_pay_comm        number(10);

BEGIN
   -- ���շ������ö�Ӧ��Ӷ��
   case
      -- Iphone
      when (p_plan = 'Iphone') then
         v_plan := 'J0002';

      -- Ball
      when (p_plan = 'Ball') then
         v_plan := 'J0003';

      -- GongXi
      when (p_plan = 'GongXi') then
         v_plan := 'J0004';

      -- DGL
      when (p_plan = 'DGL') then
         v_plan := 'J0005';

      -- Love
      when (p_plan = 'Love') then
         -- ����û������Ӷ����������Ҫע��
         if p_type = 1 then
            return -1;
         end if;

         v_rtv := to_number(f_get_sys_param(12));
         return v_rtv;

      else
         v_plan := p_plan;

   end case;

   -- ������Ӧ��Ӷ����������δ��ѯ�����򷵻� -1
   begin
      select sale_comm, pay_comm into v_sale_comm, v_pay_comm  from game_org_comm_rate where org_code = p_org and plan_code = v_plan;
   exception
      when no_data_found then
         return -1;
   end;

   if p_type = 1 then
      v_rtv := v_sale_comm;
   else
      v_rtv := v_pay_comm;
   end if;

   return v_rtv;

END;
