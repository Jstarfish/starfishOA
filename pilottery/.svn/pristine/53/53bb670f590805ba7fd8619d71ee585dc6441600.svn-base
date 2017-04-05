CREATE OR REPLACE PROCEDURE p_warehouse_check_step1
/****************************************************************/
  ------------------- 适用于仓库盘点-------------------
  ----盘点第一步：新建盘点单
  ----add by dzg: 2015-9-25
  ----业务流程：当仓库正在盘点时，不能盘点，盘点时生成当前库房实际量
  ----检查发现问题：数据中包含重复数据，没有检测盒子和箱等的包容关系
  ----更新仓库状态盘点中...
  ----更新本地没有盒签......modify by dzg 2016-01-16 in pp
  ----2016/3/18 修改新建盘点单默认值为有差异

  /*************************************************************/
(
 --------------输入----------------
 p_warehouse_opr  IN NUMBER, --盘点人
 p_check_name     IN STRING, --盘点方案名称
 p_warehouse_code IN STRING, --库房编码
 p_plan_code      IN STRING, --盘点方案（可选）
 p_batch_code     IN STRING, --盘点批次（可选）

 ---------出口参数---------
 c_check_code OUT STRING, --返回盘点单编号
 c_errorcode  OUT NUMBER, --错误编码
 c_errormesg  OUT STRING --错误原因

 ) IS

  v_count_temp NUMBER := 0; --临时变量
  v_count_tick NUMBER := 0; --存放临时库存总量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --名称不能为空
  IF ((p_check_name IS NULL) OR length(p_check_name) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_warehouse_check_step1_1;
    RETURN;
  END IF;

  --库房不能为空
  IF ((p_warehouse_code IS NULL) OR length(p_warehouse_code) <= 0) THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_warehouse_check_step1_2;
    RETURN;
  END IF;

  --盘点人无效
  v_count_temp := 0;
  SELECT count(o.admin_id)
    INTO v_count_temp
    FROM adm_info o
   WHERE o.admin_id = p_warehouse_opr
     AND o.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 3;
    c_errormesg := error_msg.err_p_warehouse_check_step1_3;
    RETURN;
  END IF;

  --仓库无效或者正在盘点中
  v_count_temp := 0;
  SELECT count(o.warehouse_code)
    INTO v_count_temp
    FROM wh_info o
   WHERE o.warehouse_code = p_warehouse_code
     AND o.status = ewarehouse_status.working;

  IF v_count_temp <= 0 THEN
    c_errorcode := 4;
    c_errormesg := error_msg.err_p_warehouse_check_step1_4;
    RETURN;
  END IF;

  --仓库无任何相关物品没有必要盘点
  v_count_temp := 0;

  ---箱检测
  --如下的业务逻辑，基于有批次一定有方案的业务关系
  IF ((p_batch_code IS NOT NULL) OR length(p_batch_code) > 0) THEN
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_trunk o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse
       AND o.plan_code = p_plan_code
       AND o.batch_no = p_batch_code;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;

  ELSIF ((p_plan_code IS NOT NULL) OR length(p_plan_code) > 0) THEN
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_trunk o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse
       AND o.plan_code = p_plan_code;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;
  ELSE
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_trunk o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;
  END IF;

  ---盒子检测
  --如下的业务逻辑，基于有批次一定有方案的业务关系
  IF ((p_batch_code IS NOT NULL) OR length(p_batch_code) > 0) THEN
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_box o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse
       AND o.plan_code = p_plan_code
       AND o.batch_no = p_batch_code;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;

  ELSIF ((p_plan_code IS NOT NULL) OR length(p_plan_code) > 0) THEN
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_box o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse
       AND o.plan_code = p_plan_code;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;
  ELSE
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_box o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;
  END IF;

  ---本检测
  --如下的业务逻辑，基于有批次一定有方案的业务关系
  IF ((p_batch_code IS NOT NULL) OR length(p_batch_code) > 0) THEN
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_package o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse
       AND o.plan_code = p_plan_code
       AND o.batch_no = p_batch_code;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;

  ELSIF ((p_plan_code IS NOT NULL) OR length(p_plan_code) > 0) THEN
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_package o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse
       AND o.plan_code = p_plan_code;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;
  ELSE
    SELECT count(o.plan_code)
      INTO v_count_temp
      FROM wh_ticket_package o
     WHERE o.current_warehouse = p_warehouse_code
       AND o.is_full = eboolean.yesorenabled
       AND o.status = eticket_status.in_warehouse;

    IF v_count_temp > 0 THEN
      v_count_tick := v_count_tick + v_count_temp;
    END IF;
  END IF;

  IF v_count_tick <= 0 THEN
    c_errorcode := 5;
    c_errormesg := error_msg.err_p_warehouse_check_step1_5;
    RETURN;
  END IF;

  /*----------- 插入数据  -----------------*/
  --插入基本信息
  c_check_code := f_get_wh_check_point_seq();

  insert into wh_check_point
    (cp_no,
     warehouse_code,
     cp_name,
     plan_code,
     batch_no,
     status,
     result,
     nomatch_tickets,
     nomatch_amount,
     cp_admin,
     cp_date,
     remark)
  values
    (c_check_code,
     p_warehouse_code,
     p_check_name,
     p_plan_code,
     p_batch_code,
     ecp_status.working,
     ecp_result.less,
     0,
     0,
     p_warehouse_opr,
     sysdate,
     '--');

  --插入盘点前记录
  ---箱
  --同检测一样依赖条件
  IF ((p_batch_code IS NOT NULL) OR length(p_batch_code) > 0) THEN

    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.trunk,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             '-',
             '-',
             d.packs_every_trunk,
             d.tickets_every_pack * d.packs_every_trunk * g.ticket_amount
        FROM wh_ticket_trunk o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND o.status = eticket_status.in_warehouse
         AND o.plan_code = p_plan_code
         AND o.batch_no = p_batch_code;

  ELSIF ((p_plan_code IS NOT NULL) OR length(p_plan_code) > 0) THEN
    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.trunk,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             '-',
             '-',
             d.packs_every_trunk,
             d.tickets_every_pack * d.packs_every_trunk * g.ticket_amount
        FROM wh_ticket_trunk o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND o.status = eticket_status.in_warehouse
         AND o.plan_code = p_plan_code;

  ELSE
    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.trunk,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             '-',
             '-',
             d.packs_every_trunk,
             d.tickets_every_pack * d.packs_every_trunk * g.ticket_amount
        FROM wh_ticket_trunk o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND o.status = eticket_status.in_warehouse;
  END IF;

  ---盒子检测
  IF ((p_batch_code IS NOT NULL) OR length(p_batch_code) > 0) THEN

    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.pack,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             o.box_no,
             p.package_no,
             1,
             d.tickets_every_pack * g.ticket_amount
        FROM wh_ticket_box o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
        Left Join wh_ticket_trunk t
          on (o.plan_code = t.plan_code and o.batch_no = t.batch_no and
             t.trunk_no = o.trunk_no)
        left join wh_ticket_package p
          on (o.plan_code = p.plan_code and o.batch_no = p.batch_no and
           o.box_no = p.box_no)
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND o.status = eticket_status.in_warehouse
         AND t.is_full = eboolean.noordisabled
         AND o.plan_code = p_plan_code
         AND o.batch_no = p_batch_code;

  ELSIF ((p_plan_code IS NOT NULL) OR length(p_plan_code) > 0) THEN
    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.pack,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             o.box_no,
             p.package_no,
             1,
             d.tickets_every_pack * g.ticket_amount
        FROM wh_ticket_box o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
        Left Join wh_ticket_trunk t
          on (o.plan_code = t.plan_code and o.batch_no = t.batch_no and
             t.trunk_no = o.trunk_no)
        left join wh_ticket_package p
          on (o.plan_code = p.plan_code and o.batch_no = p.batch_no and
           o.box_no = p.box_no)
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND t.is_full = eboolean.noordisabled
         AND o.status = eticket_status.in_warehouse
         AND o.plan_code = p_plan_code;

  ELSE
    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.pack,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             o.box_no,
             p.package_no,
             1,
             d.tickets_every_pack * g.ticket_amount
        FROM wh_ticket_box o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
        Left Join wh_ticket_trunk t
          on (o.plan_code = t.plan_code and o.batch_no = t.batch_no and
             t.trunk_no = o.trunk_no)
        left join wh_ticket_package p
          on (o.plan_code = p.plan_code and o.batch_no = p.batch_no and
           o.box_no = p.box_no)
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND t.is_full = eboolean.noordisabled
         AND o.status = eticket_status.in_warehouse;
  END IF;

  ---本检测
  IF ((p_batch_code IS NOT NULL) OR length(p_batch_code) > 0) THEN

    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.pack,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             o.box_no,
             o.package_no,
             1,
             d.tickets_every_pack * g.ticket_amount
        FROM wh_ticket_package o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
        Left Join wh_ticket_box b
          on (o.plan_code = b.plan_code and o.batch_no = b.batch_no and
             o.box_no = b.box_no)
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND o.status = eticket_status.in_warehouse
         AND b.is_full = eboolean.noordisabled
         AND o.plan_code = p_plan_code
         AND o.batch_no = p_batch_code;

  ELSIF ((p_plan_code IS NOT NULL) OR length(p_plan_code) > 0) THEN
    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.pack,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             o.box_no,
             o.package_no,
             1,
             d.tickets_every_pack * g.ticket_amount
        FROM wh_ticket_package o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
        Left Join wh_ticket_box b
          on (o.plan_code = b.plan_code and o.batch_no = b.batch_no and
             o.box_no = b.box_no)
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND b.is_full = eboolean.noordisabled
         AND o.status = eticket_status.in_warehouse
         AND o.plan_code = p_plan_code;

  ELSE
    INSERT INTO wh_check_point_detail_be
      SELECT c_check_code,
             f_get_detail_sequence_no_seq(),
             evalid_number.pack,
             o.plan_code,
             o.batch_no,
             o.trunk_no,
             o.box_no,
             o.package_no,
             1,
             d.tickets_every_pack * g.ticket_amount
        FROM wh_ticket_package o
        left join game_batch_import_detail d
          on (o.plan_code = d.plan_code and o.batch_no = d.batch_no)
        Left Join game_plans g
          on o.plan_code = g.plan_code
        Left Join wh_ticket_box b
          on (o.plan_code = b.plan_code and o.batch_no = b.batch_no and
             o.box_no = b.box_no)
       WHERE o.current_warehouse = p_warehouse_code
         AND o.is_full = eboolean.yesorenabled
         AND b.is_full = eboolean.noordisabled
         AND o.status = eticket_status.in_warehouse;
  END IF;

  --更新仓库状态
  update wh_info
     set wh_info.status = ewarehouse_status.checking
   where wh_info.warehouse_code = p_warehouse_code;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
