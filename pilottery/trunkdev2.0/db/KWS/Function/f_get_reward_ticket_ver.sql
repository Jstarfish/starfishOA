/********************************************************************************/
  ------------------- 返回彩票是否旧票（1-是，0-不是）-----------------------------
  ----add by 陈震: 2015/10/14
/********************************************************************************/
CREATE OR REPLACE FUNCTION f_get_reward_ticket_ver(
  p_plan                               in char,                               -- 方案编号
  p_batch                              in char,                               -- 批次编号
  p_package_no                         in varchar2                            -- 彩票本号

) RETURN number IS
   /*-----------    变量定义     -----------------*/
   v_count number(1);

BEGIN

   -- 票是否在系统库存中存在
   select count(*) into v_count from dual where exists(select 1 from wh_ticket_package where plan_code = p_plan and batch_no = p_batch and package_no = p_package_no);
   return 1 - v_count;

END;
