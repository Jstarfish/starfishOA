/********************************************************************************/
  ------------------- 适用于三种账户编码的生成 ----------------------------
  ---- add by 陈震: 2015/9/16
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_acc_no(p_org_code in char,
                                        p_acc_type in char)
   RETURN VARCHAR2

 IS
   v_max_code varchar2(20);
BEGIN
   -- 判断机构编码是否正确
   if p_acc_type not in ('JG', 'ZD', 'MM') then
      raise_application_error(-20001, error_msg.ERR_F_GET_WAREHOUSE_CODE_1); -- 输入的账户类型不是“JG”,“ZD”,“MM”
   end if;

   -- 查找此部门的最大仓库编号
   case
      when p_acc_type = 'JG' then
         select max(ACC_NO)
           into v_max_code
           from ACC_ORG_ACCOUNT
          where ORG_CODE = p_org_code;
         if v_max_code is null then
            return p_acc_type || p_org_code || lpad(1, 8, '0');
         end if;
         return p_acc_type || p_org_code || lpad(to_number(substr(v_max_code, 5, 8)) + 1, 8, '0');

      when p_acc_type = 'ZD' then
         select max(ACC_NO)
           into v_max_code
           from ACC_AGENCY_ACCOUNT
          where AGENCY_CODE = p_org_code;
         if v_max_code is null then
            return p_acc_type || p_org_code || '01';
         end if;
         return p_acc_type || p_org_code || lpad(to_number(substr(v_max_code, 11, 2)) + 1, 2, '0');

      when p_acc_type = 'MM' then
         select max(ACC_NO)
           into v_max_code
           from ACC_MM_ACCOUNT
          where MARKET_ADMIN = to_number(p_org_code);
         if v_max_code is null then
            return p_acc_type || p_org_code || lpad(1, 6, '0');
         end if;
         return p_acc_type || p_org_code || lpad(to_number(substr(v_max_code, 7, 6)) + 1, 6, '0');

   end case;
END;
