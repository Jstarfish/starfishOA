CREATE OR REPLACE PROCEDURE p_om_updplan_modify
/****************************************************************/
  ------------------- 适用于修改升级计划 -------------------
  ----create by dzg 2014-09-17 增加检查终端是否存在
  ----modify by dzg 2014.10.20 修改支持本地化
  /*************************************************************/
(
 --------------输入----------------
 p_plan_id          IN NUMBER, --计划编号
 p_plan_name        IN STRING, --计划名称
 p_terminal_version IN STRING, --终端机版本
 p_update_time      IN STRING, --升级时间
 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因

 ) IS

  v_count_temp NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  /*----------- 数据校验   -----------------*/

  /*----------- 检测名称重复 ---------------*/

  v_count_temp := 0;

  SELECT COUNT(u.schedule_id)
    INTO v_count_temp
    FROM upg_upgradeplan u
   WHERE u.schedule_name = p_plan_name
     AND u.schedule_id != p_plan_id;
  IF v_count_temp > 0 THEN
    c_errorcode := 1;
    --c_errormesg := '升级计划名称重复';
    c_errormesg := error_msg.MSG0056;
    RETURN;
  END IF;

  /*----------- 更新计划 -----------------*/

  UPDATE upg_upgradeplan
     SET schedule_name = p_plan_name, pkg_ver = p_terminal_version,
         schedule_sw_date = to_date(p_update_time, 'yyyy-mm-dd hh24:mi:ss')
   WHERE schedule_id = p_plan_id;

  -------更新升级过程

  UPDATE upg_upgradeproc
     SET pkg_ver = p_terminal_version
   WHERE schedule_id = p_plan_id;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    --c_errormesg := '数据库异常' || SQLERRM;
    c_errormesg := error_msg.MSG0004 || SQLERRM;

END p_om_updplan_modify;
