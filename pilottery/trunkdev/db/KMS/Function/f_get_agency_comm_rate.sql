/********************************************************************************/
  ------------------- 获取站点的佣金比例 -----------------------------
  ----add by 陈震: 2015-12-20
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_agency_comm_rate(
   p_agency IN STRING,        -- 站点编码
   p_plan   in string,        -- 方案
   p_batch  in string,        -- 批次
   p_type   in number         -- 佣金类型 （1=销售、2=兑奖）

) RETURN number IS
   /*-----------    变量定义     -----------------*/
   v_rtv number; -- 返回值

   v_plan            varchar2(50);
   v_sale_comm       number(10);
   v_pay_comm        number(10);

BEGIN
   -- 按照方案设置对应的佣金
   case
      -- Iphone
      when (p_plan = 'J0002' or (p_plan = 'J2015' and p_batch = '00001')) then
         v_plan := 'J0002';

      -- Ball
      when (p_plan = 'J0003' or (p_plan = 'J2015' and p_batch = '00002')) then
         v_plan := 'J0003';

      -- GongXi
      when (p_plan = 'J0004') then
         v_plan := 'J0004';

      -- DGL
      when (p_plan = 'J0005') then
         v_plan := 'J0005';

      -- Love
      when (p_plan = 'J2014') then
         -- 爱心没有销售佣金，所以这里要注意
         if p_type = 1 then
            return -1;
         end if;

         v_rtv := to_number(f_get_sys_param(11));
         return v_rtv;

      else
         v_plan := p_plan;

   end case;

   -- 检索相应的佣金比例，如果未查询到，则返回 -1
   begin
      select sale_comm, pay_comm into v_sale_comm, v_pay_comm  from game_agency_comm_rate where agency_code = p_agency and plan_code = v_plan;
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
