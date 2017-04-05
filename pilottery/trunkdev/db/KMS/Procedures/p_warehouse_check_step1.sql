CREATE OR REPLACE PROCEDURE p_warehouse_check_step1
/****************************************************************/
  ------------------- �����ڲֿ��̵�-------------------
  ----�̵��һ�����½��̵㵥
  ----add by dzg: 2015-9-25
  ----ҵ�����̣����ֿ������̵�ʱ�������̵㣬�̵�ʱ���ɵ�ǰ�ⷿʵ����
  ----��鷢�����⣺�����а����ظ����ݣ�û�м����Ӻ���ȵİ��ݹ�ϵ
  ----���²ֿ�״̬�̵���...
  ----���±���û�к�ǩ......modify by dzg 2016-01-16 in pp
  ----2016/3/18 �޸��½��̵㵥Ĭ��ֵΪ�в���

  /*************************************************************/
(
 --------------����----------------
 p_warehouse_opr  IN NUMBER, --�̵���
 p_check_name     IN STRING, --�̵㷽������
 p_warehouse_code IN STRING, --�ⷿ����
 p_plan_code      IN STRING, --�̵㷽������ѡ��
 p_batch_code     IN STRING, --�̵����Σ���ѡ��

 ---------���ڲ���---------
 c_check_code OUT STRING, --�����̵㵥���
 c_errorcode  OUT NUMBER, --�������
 c_errormesg  OUT STRING --����ԭ��

 ) IS

  v_count_temp NUMBER := 0; --��ʱ����
  v_count_tick NUMBER := 0; --�����ʱ�������

BEGIN

  /*-----------    ��ʼ������    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- ����У��   -----------------*/
  --���Ʋ���Ϊ��
  IF ((p_check_name IS NULL) OR length(p_check_name) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_warehouse_check_step1_1;
    RETURN;
  END IF;

  --�ⷿ����Ϊ��
  IF ((p_warehouse_code IS NULL) OR length(p_warehouse_code) <= 0) THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_warehouse_check_step1_2;
    RETURN;
  END IF;

  --�̵�����Ч
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

  --�ֿ���Ч���������̵���
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

  --�ֿ����κ������Ʒû�б�Ҫ�̵�
  v_count_temp := 0;

  ---����
  --���µ�ҵ���߼�������������һ���з�����ҵ���ϵ
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

  ---���Ӽ��
  --���µ�ҵ���߼�������������һ���з�����ҵ���ϵ
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

  ---�����
  --���µ�ҵ���߼�������������һ���з�����ҵ���ϵ
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

  /*----------- ��������  -----------------*/
  --���������Ϣ
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

  --�����̵�ǰ��¼
  ---��
  --ͬ���һ����������
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

  ---���Ӽ��
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

  ---�����
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

  --���²ֿ�״̬
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
