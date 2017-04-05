CREATE OR REPLACE PROCEDURE p_warehouse_check_step3
/****************************************************************/
  ------------------- �����ڲֿ��̵�-------------------
  ----�̵��������ȷ����ɣ������ɽ��
  ----add by dzg: 2015-9-25
  ----ҵ�����̣����ݶԱ�ǰ�����ݺ�ʵ��ɨ�����ݣ����м�����
  ----Ŀǰֻ�п����٣�����һ�£������������쳣
  ----modify by dzg 2015-10-23 ���ӱ�ע
  ----�޸�ʹ�õ���������ɶ�����ʹ��ͬһ������
  ----modify by dzg 2015-11-12 �޸ļ������̵����ݴ���sql����innerû��ƥ������...������Ҫ���������߼�
  /*************************************************************/
(
 --------------����----------------
 p_check_code IN STRING, --�̵㵥
 p_remark     IN STRING, --�̵㱸ע
 p_isfinish   IN NUMBER, --��ɱ�־
 
 ---------���ڲ���---------
 c_before_num    OUT NUMBER, --�̵�ǰ����
 c_before_amount OUT NUMBER, --�̵�ǰ�ܶ�
 c_after_num     OUT NUMBER, --�̵������
 c_after_amount  OUT NUMBER, --�̵���ܶ�
 c_result        OUT NUMBER, --�̵���
 c_errorcode     OUT NUMBER, --�������
 c_errormesg     OUT STRING --����ԭ��
 
 ) IS

  v_count_temp NUMBER := 0; --��ʱ����
  c_isfinish NUMBER := 0; --��ʱ����

BEGIN

  /*-----------    ��ʼ������    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;
  
  --��ʼ��Ĭ�����ֵ������mybatis�����쳣��ʾ
  c_before_num    := 0;
  c_before_amount := 0;
  c_after_num     := 0;
  c_after_amount  := 0;
  c_result        := ecp_result.same;
  c_isfinish      := ecp_status.working;

  /*----------- ����У��   -----------------*/
  --��Ų���Ϊ��
  IF ((p_check_code IS NULL) OR length(p_check_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_warehouse_check_step2_1;
    RETURN;
  END IF;

  --��Ų����ڻ����Ѿ����
  IF (p_isfinish > 0 ) THEN
    c_isfinish      := ecp_status.done;
    v_count_temp := 0;
    SELECT count(o.cp_no)
      INTO v_count_temp
      FROM wh_check_point o
     WHERE o.cp_no = p_check_code
       AND o.status <> ecp_status.done;

    IF v_count_temp <= 0 THEN
      c_errorcode := 2;
      c_errormesg := error_msg.err_p_warehouse_check_step2_2;
      RETURN;
    END IF;
  END IF;

  /*----------- ��������  -----------------*/
  --���ǰ�����ͽ������������
  --���������ж�
  
  --��ε��ÿ���ʹ�������
   delete from wh_cp_nomatch_detail 
    where wh_cp_nomatch_detail.cp_no= p_check_code;
 
  select sum(nd.packages * gd.tickets_every_pack), sum(nd.amount)
    into c_before_num, c_before_amount
    from wh_check_point_detail_be nd
    left join game_batch_import_detail gd
      on (nd.plan_code = gd.plan_code and nd.batch_no = gd.batch_no)
   where nd.cp_no = p_check_code;

  select sum(nd.packages * gd.tickets_every_pack), sum(nd.amount)
    into c_after_num, c_after_amount
    from wh_check_point_detail nd
    left join game_batch_import_detail gd
      on (nd.plan_code = gd.plan_code and nd.batch_no = gd.batch_no)
   inner join wh_check_point_detail_be bf
      on (nd.plan_code = bf.plan_code and nd.batch_no = bf.batch_no and
         nd.valid_number = bf.valid_number and nd.trunk_no = bf.trunk_no and
         nd.box_no = bf.box_no and nd.package_no = bf.package_no)
   where nd.cp_no = p_check_code
   and bf.cp_no =p_check_code;

  IF ((c_before_num IS NULL) OR length(c_before_num) <= 0) THEN
    c_before_num    := 0;
    c_before_amount := 0;
  END IF;

  IF ((c_after_num IS NULL) OR length(c_after_num) <= 0) THEN
    c_after_num    := 0;
    c_after_amount := 0;
  END IF;

  IF (c_before_num = c_after_num) THEN
  
    update wh_check_point
       set status          = c_isfinish,
           result          = ecp_result.same,
           nomatch_tickets = 0,
           remark          = p_remark,
           nomatch_amount  = 0
     where cp_no = p_check_code;
  
  ELSE
    ---����δƥ������
    c_result        := ecp_result.less;
    insert into wh_cp_nomatch_detail
      select t.cp_no,
             t.sequence_no,
             t.valid_number,
             t.plan_code,
             t.batch_no,
             t.trunk_no,
             t.box_no,
             t.package_no,
             t.packages,
             t.amount
        from (
              
              select a1.cp_no,
                      a1.sequence_no,
                      a1.valid_number,
                      a1.plan_code,
                      a1.batch_no,
                      a1.trunk_no,
                      a1.box_no,
                      a1.package_no,
                      a1.packages,
                      a1.amount,
                      nvl2(b1.trunk_no, 0, 1) vsign
                from wh_check_point_detail_be a1
                left join wh_check_point_detail b1
                  on (a1.cp_no = b1.cp_no and
                     a1.valid_number = b1.valid_number and
                     a1.trunk_no = b1.trunk_no)
               where a1.cp_no = p_check_code
                 and a1.valid_number = 1
              
              union
              
              select a2.cp_no,
                      a2.sequence_no,
                      a2.valid_number,
                      a2.plan_code,
                      a2.batch_no,
                      a2.trunk_no,
                      a2.box_no,
                      a2.package_no,
                      a2.packages,
                      a2.amount,
                      nvl2(b2.trunk_no, 0, 1) vsign
                from wh_check_point_detail_be a2
                left join wh_check_point_detail b2
                  on (a2.cp_no = b2.cp_no and
                     a2.valid_number = b2.valid_number and
                     a2.box_no = b2.box_no)
               where a2.cp_no = p_check_code
                 and a2.valid_number = 2
              
              union
              
              select a3.cp_no,
                      a3.sequence_no,
                      a3.valid_number,
                      a3.plan_code,
                      a3.batch_no,
                      a3.trunk_no,
                      a3.box_no,
                      a3.package_no,
                      a3.packages,
                      a3.amount,
                      nvl2(b3.trunk_no, 0, 1) vsign
                from wh_check_point_detail_be a3
                left join wh_check_point_detail b3
                  on (a3.cp_no = b3.cp_no and
                     a3.valid_number = b3.valid_number and
                     a3.package_no = b3.package_no)
               where a3.cp_no = p_check_code
                 and a3.valid_number = 3) t
       where t.vsign = 0;
  
    update wh_check_point
       set status          = c_isfinish,
           result          = ecp_result.less,
           remark          = p_remark,
           nomatch_tickets = c_before_num - c_after_num,
           nomatch_amount  = c_before_amount - c_after_amount
     where cp_no = p_check_code;
  
  END IF;
  
  --�����Ľ��
  IF (p_isfinish > 0 ) THEN
     update wh_info
        set wh_info.status = ewarehouse_status.working
      where wh_info.warehouse_code in
            (select wh_check_point.warehouse_code
               from wh_check_point
              where wh_check_point.cp_no = p_check_code);
  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END;
