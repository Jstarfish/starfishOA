CREATE OR REPLACE function f_print_lottery
/****************************************************************/
  ------------------- 适用返回彩票信息 -------------------
  ---- 创建系统用户
  ---- add by 陈震: 2015/9/29
/*************************************************************/
(
 --------------输入----------------
   p_lot             in type_lottery_info
) return varchar2 IS
   v_rtv varchar2(4000);

BEGIN
   v_rtv :=    dbtool.format_line('PLAN: ' || p_lot.plan_code)
            || dbtool.format_line('PLAN: ' || p_lot.batch_no)
            || dbtool.format_line('TRUNK: ' || p_lot.trunk_no)
            || dbtool.format_line('BOX: ' || nvl(p_lot.box_no, '-'))
            || dbtool.format_line('PACKAGE: ' || nvl(p_lot.package_no, '-'));
   return v_rtv;
END;
