CREATE OR REPLACE PROCEDURE p_warehouse_check_step2
/****************************************************************/
  ------------------- 适用于仓库盘点-------------------
  ----盘点第二步：扫描入库
  ----add by dzg: 2015-9-25
  ----modify by dzg:2015-10-27增加重复检测功能
  ----modify by dzg:2016-01-16 in pp 暂时不支持本签
  /*************************************************************/
(
 --------------输入----------------
 p_check_code     IN STRING, --盘点单
 p_array_lotterys IN type_lottery_list, -- 入库的彩票对象

 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因

 ) IS

  v_count_temp   NUMBER := 0; --临时变量
  v_count_pack   NUMBER := 0; --总包数
  v_count_tick   NUMBER := 0; --总票数
  v_amount_tatal NUMBER := 0; --总额
  v_total_tickets      NUMBER := 0; --纯变量
  v_total_amount       NUMBER := 0; --纯变量
  v_detail_list           type_lottery_detail_list;                       -- 彩票对象明细
  v_stat_list             type_lottery_statistics_list;                   -- 按照方案和批次统计的金额和票数

  v_item         type_lottery_info; --循环变量的当前值

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --编号不能为空
  IF ((p_check_code IS NULL) OR length(p_check_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_warehouse_check_step2_1;
    RETURN;
  END IF;

  --编号不存在或者已经完结
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

  --记录不能为空
  IF (p_array_lotterys is null or p_array_lotterys.count < 0) THEN
    c_errorcode := 3;
    c_errormesg := error_msg.err_p_warehouse_check_step2_3;
    RETURN;
  END IF;

  --重复检测
  IF (f_check_import_ticket(p_check_code,3,p_array_lotterys)) THEN
    c_errorcode := 4;
    c_errormesg := error_msg.err_p_ar_inbound_3;
    RETURN;
  END IF;


  /*----------- 插入数据  -----------------*/

  --使用陈震函数初始化对象
  p_lottery_detail_stat(p_array_lotterys, v_detail_list, v_stat_list, v_total_tickets, v_total_amount);

  ---循环插入数据
  FOR i IN 1 .. p_array_lotterys.count LOOP

    if( v_detail_list(i).valid_number = evalid_number.box) then
        RAISE_APPLICATION_ERROR(-20123, 'System not support the barcode of box.', TRUE);
    end if;
    v_item := p_array_lotterys(i);
    v_count_pack := 0;
    v_count_tick:= 0;

    p_warehouse_get_sum_info(v_item,
                             v_count_pack,
                             v_count_tick,
                             v_amount_tatal);



    ---后插入 wh_check_point_detail
    insert into wh_check_point_detail
      (cp_no,
       sequence_no,
       valid_number,
       plan_code,
       batch_no,
       trunk_no,
       box_no,
       package_no,
       packages,
       amount)
    values
      (p_check_code,
       f_get_detail_sequence_no_seq(),
       v_detail_list(i).valid_number,
       v_detail_list(i).plan_code,
       v_detail_list(i).batch_no,
       v_detail_list(i).trunk_no,
       v_detail_list(i).box_no,
       v_detail_list(i).package_no,
       v_count_pack,
       v_amount_tatal);

  END LOOP;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
