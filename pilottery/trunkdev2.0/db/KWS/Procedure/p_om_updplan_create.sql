CREATE OR REPLACE PROCEDURE p_om_updplan_create
/****************************************************************/
  ------------------- 适用于创建升级计划 -------------------
  ----add by dzg: 2014-07-14 创建升级计划
  ----业务流程：先插入计划表，依次更新对应范围的区域
  ----modify by dzg 2014-08-07 修该bug当区域和站点交叉时distinct
  ----否则不能插入数据到过程表
  ----modify by dzg 2014-09-17 增加检查终端是否存在
  ----modify by dzg 2014.10.20 修改支持本地化
  ----modify by dzg 2015.03.02 增加其他默认值的异常退出输出值
  ----migrate by Chen Zhen @ 2016-04-14
  /*************************************************************/
(
 --------------输入----------------
 p_plan_name         IN STRING, --计划名称
 p_terminal_type     IN NUMBER, --终端机型
 p_terminal_version  IN STRING, --终端机版本
 p_update_time       IN STRING, --升级时间
 p_update_area_scope IN STRING, --区域升级范围，使用“,”分割的多个字符串
 p_update_terms      IN STRING, --区域终端列表，使用“,”分割的多个字符串
 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING, --错误原因
 c_plan_id   OUT NUMBER --计划编号

 ) IS

  v_plan_id        NUMBER := 0; --临时变量
  v_count_temp     NUMBER := 0; --临时变量
  v_is_con_country NUMBER := 0; --临时变量(是否包含全国)

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_plan_id    := 0;
  v_count_temp := 0;
  /*----------- 数据校验   -----------------*/

  /*----------- 检测名称重复 ---------------*/

  SELECT COUNT(u.schedule_id)
    INTO v_count_temp
    FROM upg_upgradeplan u
   WHERE u.schedule_name = p_plan_name;
  IF v_count_temp > 0 THEN
    c_errorcode := 1;
    --c_errormesg := '升级计划名称重复';
    c_errormesg := error_msg.msg0056;
    c_plan_id   := 0;
    RETURN;
  END IF;

  IF (length(p_update_terms) <= 0 AND length(p_update_area_scope) <= 0) THEN
    c_errorcode := 1;
    --c_errormesg := '无效的升级对象';
    c_errormesg := error_msg.msg0057;
    c_plan_id   := 0;
    RETURN;
  END IF;

  /*----------- 检测升级终端是否机型一致 ---------------*/
  IF length(p_update_terms) > 0 THEN

    FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_update_terms))) LOOP
      dbms_output.put_line(i.column_value);
      v_count_temp := 0;
      IF length(i.column_value) > 0 THEN

        --检测是否存在
        SELECT COUNT(saler_terminal.terminal_code)
          INTO v_count_temp
          FROM saler_terminal
         WHERE saler_terminal.terminal_code = trim(i.column_value);

        IF v_count_temp < 0 THEN
          c_errorcode := 1;
          --c_errormesg := '终端(' || i.column_value || ')不存在';
          c_errormesg := error_msg.msg0058 || '(' || i.column_value || ')' ||
                         error_msg.msg0059;
          c_plan_id   := 0;
          RETURN;
        END IF;

        --检测是否型号一致
        v_count_temp := 0;

        SELECT COUNT(saler_terminal.terminal_code)
          INTO v_count_temp
          FROM saler_terminal
         WHERE saler_terminal.terminal_code = trim(i.column_value)
           AND saler_terminal.term_type_id = p_terminal_type;

        IF v_count_temp < 0 THEN
          c_errorcode := 1;
          --c_errormesg := '终端(' || i.column_value || ')机型和升级版本要求不匹配';
          c_errormesg := error_msg.msg0058 || '(' || i.column_value || ')' ||
                         error_msg.msg0060;
          c_plan_id   := 0;
          RETURN;
        END IF;

      END IF;
    END LOOP;

  END IF;

  /*----------- 检测是否包含 总公司 ---------------*/
  SELECT count(*)
    into v_is_con_country
    FROM TABLE(dbtool.strsplit(p_update_area_scope))
   where column_value = '00';

  /*----------- 插入数据  -----------------*/

  --插入计划
  v_plan_id := f_get_upg_schedule_seq();
  INSERT INTO upg_upgradeplan
    (schedule_id,
     schedule_name,
     pkg_ver,
     term_type,
     schedule_status,
     schedule_sw_date,
     schedule_cr_date)
  VALUES
    (v_plan_id,
     p_plan_name,
     p_terminal_version,
     p_terminal_type,
     eschedule_status.planning,
     to_date(p_update_time, 'yyyy-mm-dd hh24:mi:ss'),
     SYSDATE);

  --更新终端

  IF v_is_con_country = 1 THEN

    INSERT INTO upg_upgradeproc
      SELECT saler_terminal.terminal_code,
             v_plan_id,
             p_terminal_version,
             0,
             NULL,
             NULL,
             NULL,
             NULL
        FROM saler_terminal
       WHERE saler_terminal.status != eterminal_status.cancelled
         AND saler_terminal.term_type_id = p_terminal_type;
  ELSE
    IF (length(p_update_terms) > 0 AND length(p_update_area_scope) > 0) THEN

      INSERT INTO upg_upgradeproc
        (terminal_code, schedule_id, pkg_ver, is_comp_dl)
        SELECT DISTINCT saler_terminal.terminal_code,
                        v_plan_id,
                        p_terminal_version,
                        0
          FROM saler_terminal, inf_agencys, inf_orgs
         WHERE saler_terminal.agency_code = inf_agencys.agency_code
           AND inf_agencys.org_code = inf_orgs.org_code
           AND saler_terminal.status != eterminal_status.cancelled
           AND saler_terminal.term_type_id = p_terminal_type
           AND ((inf_orgs.org_code IN
               (SELECT * FROM TABLE(dbtool.strsplit(p_update_area_scope)))) OR
               saler_terminal.terminal_code IN
               (SELECT * FROM TABLE(dbtool.strsplit(p_update_terms))));
    ELSE
      IF (length(p_update_terms) > 0) THEN
        INSERT INTO upg_upgradeproc
          (terminal_code, schedule_id, pkg_ver, is_comp_dl)
          SELECT DISTINCT saler_terminal.terminal_code,
                          v_plan_id,
                          p_terminal_version,
                          0
            FROM saler_terminal
           WHERE saler_terminal.status != eterminal_status.cancelled
             AND saler_terminal.term_type_id = p_terminal_type
             AND saler_terminal.terminal_code IN
                 (SELECT * FROM TABLE(dbtool.strsplit(p_update_terms)));
      ELSE
        INSERT INTO upg_upgradeproc
          (terminal_code, schedule_id, pkg_ver, is_comp_dl)
          SELECT DISTINCT saler_terminal.terminal_code,
                          v_plan_id,
                          p_terminal_version,
                          0
            FROM saler_terminal, inf_agencys, inf_orgs
           WHERE saler_terminal.agency_code = inf_agencys.agency_code
             AND inf_agencys.org_code = inf_orgs.org_code
             AND saler_terminal.status != eterminal_status.cancelled
             AND saler_terminal.term_type_id = p_terminal_type
             AND (inf_orgs.org_code IN
                 (SELECT * FROM TABLE(dbtool.strsplit(p_update_area_scope))));
      END IF;
    END IF;
  END IF;
  c_plan_id := v_plan_id;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    --c_errormesg := '数据库异常' || SQLERRM;
    c_errormesg := error_msg.msg0004 || SQLERRM;
    c_plan_id   := 0;

END;
