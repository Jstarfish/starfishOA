/********************************************************************************/
  ------------------- 获取组织机构的佣金比例 -----------------------------
  ----add by 陈震: 2015-12-20
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_org_comm_rate_by_name(
   p_org    IN STRING,        -- 站点编码
   p_plan   in string,        -- 方案名称
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
         -- 爱心没有销售佣金，所以这里要注意
         if p_type = 1 then
            return -1;
         end if;

         v_rtv := to_number(f_get_sys_param(12));
         return v_rtv;

      else
         v_plan := p_plan;

   end case;

   -- 检索相应的佣金比例，如果未查询到，则返回 -1
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
