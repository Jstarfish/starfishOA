create or replace function f_get_flow_pay_org(
   p_pay_flow in string --站点编码

) return string is
   /*-----------    变量定义     -----------------*/
   v_ret_code  string(8) := ''; -- 返回值
   v_record flow_pay%rowtype;

begin

   -- modify by Chen Zhen @2017/2/22  修改中心兑奖的机构获取方式。因为增加了一个兑奖机构字段

   select * into v_record from flow_pay where pay_flow = p_pay_flow;

   case
      when v_record.is_center_paid = 1 then        -- 中心兑奖
         select pay_org into v_ret_code
           from flow_gui_pay
          where pay_flow = p_pay_flow;
         if v_ret_code is null then
            v_ret_code := f_get_admin_org(v_record.payer_admin);
         end if;
  
      when v_record.is_center_paid = 2 then        -- 管理员兑奖
         v_ret_code := f_get_admin_org(v_record.payer_admin);

      when v_record.is_center_paid = 3 then        -- 销售站兑奖
         v_ret_code := f_get_agency_org(v_record.pay_agency);

      else
         return 'ERROR';
   end case;

   return v_ret_code;

end;
