/********************************************************************************/
  ------------------- 适用于仓库编号的生成 ----------------------------
  ----针对表WH_GOODS_RECEIPT_DETAIL(入库单明细)的SGI_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_warehouse_code(p_org_code in char)
   RETURN VARCHAR2

 IS
   v_max_code char(4);
BEGIN
   -- 查找此部门的最大仓库编号
   select max(WAREHOUSE_CODE)
     into v_max_code
     from WH_INFO
    where org_code = p_org_code;
   if v_max_code is null then
      return p_org_code || '01';
   end if;

   return p_org_code || lpad(to_number(substr(v_max_code, 3, 2)) + 1, 2, '0');
END;
