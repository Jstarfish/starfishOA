CREATE OR REPLACE PROCEDURE p_warehouse_damage_register
/****************************************************************/
  ------------------- 适用于仓库损毁登记-------------------
  ----add by dzg: 2015-10-29
  ----业务流程：损毁登记
  ----modify by dzg:2015-10-31
  ----修改：批次入库损毁插入一个包，否则查询有异常
  ----modify by dzg:2015-11-02
  ----修改：增加其他类型的备注更新
  ----modify by dzg:2015-11-10修改调拨没有考虑拆箱情况
  ----modify by dzg:2015-11-21重复操作检测
  /*************************************************************/
(
 --------------输入----------------
 p_opr_admin   IN NUMBER, --操作人
 p_check_type  IN NUMBER, --操作类型：1 批次入库损毁 2 调拨损毁 3 盘点损毁
 p_ref_code    IN STRING, --参考编号
 p_remark      IN STRING, --损毁备注
 p_extend_arg1 IN STRING, --扩展参数1，用盘点损毁具体编号数据
 
 ---------出口参数---------
 c_register_code OUT STRING, --返回盘点单编号
 c_errorcode     OUT NUMBER, --错误编码
 c_errormesg     OUT STRING --错误原因
 
 ) IS

  v_count_temp     NUMBER := 0; --临时变量
  v_count_tick     NUMBER := 0; --存放临时库存总量
  v_pack_type      NUMBER := 0; --包装类型用于枚举
  v_total_pack     NUMBER := 0; --总本数
  v_total_amount   NUMBER := 0; --总金额
  v_total_pack_t   NUMBER := 0; --总本数-临时变量用于盘点
  v_total_amount_t NUMBER := 0; --总金额-临时变量用于盘点
  v_face_value     NUMBER := 0; --票面金额
  v_packnum_p_truk NUMBER := 0; --每箱本数
  v_boxnum_p_truk  NUMBER := 0; --每箱盒数
  v_packnum_p_box  NUMBER := 0; --每盒本数
  v_ticknum_p_pack NUMBER := 0; --每本张数

  type type_detail is table of wh_check_point_detail_be%rowtype;
  v_insert_detail type_detail;

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp    := 0;
  v_insert_detail := type_detail();
  /*----------- 数据校验   -----------------*/
  --编码不能为空
  IF ((p_ref_code IS NULL) OR length(p_ref_code) <= 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.err_p_warehouse_create_1;
    RETURN;
  END IF;

  --人无效
  v_count_temp := 0;
  SELECT count(o.admin_id)
    INTO v_count_temp
    FROM adm_info o
   WHERE o.admin_id = p_opr_admin
     AND o.admin_status <> eadmin_status.DELETED;

  IF v_count_temp <= 0 THEN
    c_errorcode := 2;
    c_errormesg := error_msg.err_p_mm_fund_repay_4;
    RETURN;
  END IF;
  
  --重复检测
  v_count_temp := 0;

  SELECT count(wh_broken_recoder.broken_no)
    INTO v_count_temp
    FROM wh_broken_recoder
   WHERE wh_broken_recoder.stb_no = p_ref_code
     OR wh_broken_recoder.cp_no = p_ref_code;

  IF v_count_temp > 0 THEN
    c_errorcode := 3;
    c_errormesg := error_msg.err_common_8;
    RETURN;
  END IF;

  ---插入数据

  --生成单号
  c_register_code := f_get_wh_broken_recoder_seq();

  case p_check_type
    when 1 then
      --批次损毁
      begin
      
        -- 初始化数据
        select b.damaged_tickets / d.tickets_every_pack, b.damaged_amount
          into v_total_pack, v_total_amount
          from wh_batch_inbound b
          left join game_batch_import_detail d
            on b.plan_code = d.plan_code
           and b.batch_no = d.batch_no
         where b.bi_no = p_ref_code;
      
        -- 插入主表  
        insert into wh_broken_recoder
          (broken_no,
           apply_admin,
           apply_date,
           source,
           stb_no,
           cp_no,
           packages,
           total_amount,
           reason,
           remark)
        values
          (c_register_code,
           p_opr_admin,
           sysdate,
           p_check_type,
           p_ref_code,
           p_ref_code,
           v_total_pack,
           v_total_amount,
           eticket_status.broken,
           p_remark);
      
        --插入详表-否则损毁有异常
        insert into wh_broken_recoder_detail
          (broken_no,
           sequence_no,
           valid_number,
           plan_code,
           batch_no,
           trunk_no,
           box_no,
           package_no,
           packages,
           amount)
          select c_register_code,
                 f_get_detail_sequence_no_seq(),
                 evalid_number.pack,
                 wh_batch_inbound.plan_code,
                 wh_batch_inbound.batch_no,
                 '-',
                 '-',
                 '-',
                 v_total_pack,
                 v_total_amount
            from wh_batch_inbound
           where wh_batch_inbound.bi_no = p_ref_code;
      
        --插入备注
        --update wh_batch_inbound 
        --set wh_batch_inbound.remark =p_remark
        --where wh_batch_inbound.bi_no=p_ref_code;
        update wh_goods_receipt
           set wh_goods_receipt.remark = p_remark
         where wh_goods_receipt.ref_no = p_ref_code;
      
      end;
    
    when 2 then
      --调拨损毁
      begin
        v_total_pack   := 0;
        v_total_amount := 0;
      
        --循环插入详情
        for xx in (select ref_no,
                          plan_code,
                          batch_no,
                          valid_number,
                          trunk_no,
                          box_no,
                          package_no,
                          nvl(bf.tickets, af.tickets) tickets,
                          nvl(bf.amount, af.amount) amount,
                          bf.sequence_no bno,
                          af.sequence_no ano
                     from wh_goods_issue_detail bf
                     full join wh_goods_receipt_detail af
                    using (ref_no, plan_code, batch_no, valid_number, trunk_no, box_no, package_no)
                    where ref_no = p_ref_code) loop
                    
          --ano 入库标志，出入库没有入库的
          if (xx.ano is null  and xx.tickets > 0) then
          
            --初始化基础金额等计算数据
            v_face_value     := 0;
            v_packnum_p_truk := 0;
            v_boxnum_p_truk  := 0;
            v_packnum_p_box  := 0;
            v_ticknum_p_pack := 0;
            select game_plans.ticket_amount,
                   game_batch_import_detail.packs_every_trunk,
                   game_batch_import_detail.boxes_every_trunk,
                   game_batch_import_detail.packs_every_trunk /
                   game_batch_import_detail.boxes_every_trunk,
                   game_batch_import_detail.tickets_every_pack
              into v_face_value,
                   v_packnum_p_truk,
                   v_boxnum_p_truk,
                   v_packnum_p_box,
                   v_ticknum_p_pack
              from game_batch_import_detail
              left join game_plans
                on game_batch_import_detail.plan_code =
                   game_plans.plan_code
             where game_batch_import_detail.plan_code = xx.plan_code
               and game_batch_import_detail.batch_no = xx.batch_no;
          
            --检测是否包含并拆包等处理
            case xx.valid_number
              when evalid_number.trunk then
                begin
                  v_count_temp := 0;
                  select count(*)
                    into v_count_temp
                    from wh_goods_receipt_detail
                   where wh_goods_receipt_detail.plan_code = xx.plan_code
                     and wh_goods_receipt_detail.batch_no = xx.batch_no
                     and wh_goods_receipt_detail.trunk_no = xx.trunk_no
                     and wh_goods_receipt_detail.ref_no = p_ref_code;
                
                  ---需要拆箱检测
                  if (v_count_temp > 0) then
                    for b2xx in (select bf2.plan_code,
                                        bf2.batch_no,
                                        bf2.trunk_no,
                                        bf2.box_no,
                                        bf2.box_no      bno,
                                        af2.sequence_no ano
                                   from wh_ticket_box bf2
                                   left join wh_goods_receipt_detail af2
                                     on (bf2.plan_code = af2.plan_code and
                                        bf2.batch_no = af2.batch_no and
                                        af2.trunk_no = bf2.trunk_no and
                                        af2.box_no = bf2.box_no and 
                                        af2.ref_no = p_ref_code and 
                                        af2.valid_number = evalid_number.box)
                                  where bf2.plan_code = xx.plan_code
                                    and bf2.batch_no = xx.batch_no
                                    and bf2.trunk_no = xx.trunk_no ) loop
                    
                      if (b2xx.ano is null) then
                        --如果收货单没有箱的定义，则检测是否有本
                        v_count_temp := 0;
                        select count(*)
                          into v_count_temp
                          from wh_goods_receipt_detail
                         where wh_goods_receipt_detail.plan_code = b2xx.plan_code
                           and wh_goods_receipt_detail.batch_no = b2xx.batch_no
                           and wh_goods_receipt_detail.box_no = b2xx.box_no
                           and wh_goods_receipt_detail.valid_number = evalid_number.pack
                           and wh_goods_receipt_detail.ref_no = p_ref_code;
                      
                        if v_count_temp > 0 then
                          --有则，继续拆成本检测
                          for b3xx in (select bf3.plan_code,
                                              bf3.batch_no,
                                              bf3.trunk_no,
                                              bf3.box_no,
                                              bf3.package_no,
                                              bf3.box_no      bno,
                                              af3.sequence_no ano
                                         from wh_ticket_package bf3
                                         left join wh_goods_receipt_detail af3
                                           on (bf3.plan_code = af3.plan_code and
                                              bf3.batch_no = af3.batch_no and
                                              af3.trunk_no = bf3.trunk_no and
                                              af3.package_no = bf3.package_no and 
                                              af3.ref_no = p_ref_code and
                                              af3.valid_number =evalid_number.pack)
                                        where bf3.plan_code = xx.plan_code
                                          and bf3.batch_no = xx.batch_no
                                          and bf3.box_no = b2xx.box_no ) loop
                          
                            if (b3xx.ano is null) then
                              --没有则，损毁登记
                              v_total_pack_t := 1;
                              v_total_pack   := v_total_pack +
                                                v_total_pack_t;
                              v_total_amount := v_total_amount +
                                                (v_ticknum_p_pack *
                                                v_face_value);
                            
                              insert into wh_broken_recoder_detail
                                (broken_no,
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
                                (c_register_code,
                                 f_get_detail_sequence_no_seq(),
                                 evalid_number.pack,
                                 b3xx.plan_code,
                                 b3xx.batch_no,
                                 b3xx.trunk_no,
                                 b3xx.box_no,
                                 b3xx.package_no,
                                 1,
                                 v_ticknum_p_pack * v_face_value);
                            
                              --损毁票状态更新
                              p_wh_ticket_damage(p_opr_admin,
                                                 b3xx.plan_code,
                                                 b3xx.batch_no,
                                                 evalid_number.pack,
                                                 b3xx.trunk_no,
                                                 b3xx.box_no,
                                                 b3xx.package_no);
                            end if;
                          end loop;
                        
                        else
                          --无则(box)，插入损毁登记
                          v_total_pack_t := v_packnum_p_box;
                          v_total_pack   := v_total_pack + v_total_pack_t;
                          v_total_amount := v_total_amount + (v_total_pack_t *
                                            v_ticknum_p_pack *
                                            v_face_value);
                          insert into wh_broken_recoder_detail
                            (broken_no,
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
                            (c_register_code,
                             f_get_detail_sequence_no_seq(),
                             evalid_number.box,
                             b2xx.plan_code,
                             b2xx.batch_no,
                             b2xx.trunk_no,
                             b2xx.box_no,
                             '-',
                             v_total_pack_t,
                             v_total_pack_t * v_ticknum_p_pack *
                             v_face_value);
                        
                          --损毁票状态更新
                          p_wh_ticket_damage(p_opr_admin,
                                             b2xx.plan_code,
                                             b2xx.batch_no,
                                             evalid_number.box,
                                             b2xx.trunk_no,
                                             b2xx.box_no,
                                             '-');
                        
                        end if;
                      end if;
                    
                    end loop;
                  else
                    --直接损毁(trunk)
                    v_total_pack_t := v_packnum_p_truk;
                    v_total_pack   := v_total_pack + v_total_pack_t;
                    v_total_amount := v_total_amount +
                                      (v_total_pack_t * v_ticknum_p_pack *
                                      v_face_value);
                    insert into wh_broken_recoder_detail
                      (broken_no,
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
                      (c_register_code,
                       f_get_detail_sequence_no_seq(),
                       evalid_number.trunk,
                       xx.plan_code,
                       xx.batch_no,
                       xx.trunk_no,
                       '-',
                       '-',
                       v_total_pack_t,
                       v_total_pack_t * v_ticknum_p_pack * v_face_value);
                  
                    --损毁票状态更新
                    p_wh_ticket_damage(p_opr_admin,
                                       xx.plan_code,
                                       xx.batch_no,
                                       evalid_number.trunk,
                                       xx.trunk_no,
                                       '-',
                                       '-');
                  
                  end if;
                
                end;
              when evalid_number.box then
                begin
                  v_count_temp := 0;
                  select count(*)
                    into v_count_temp
                    from wh_goods_receipt_detail
                   where wh_goods_receipt_detail.plan_code = xx.plan_code
                     and wh_goods_receipt_detail.batch_no = xx.batch_no
                     and wh_goods_receipt_detail.box_no = xx.box_no
                     and wh_goods_receipt_detail.ref_no = p_ref_code;
                
                  ---拆包检测
                  if (v_count_temp > 0) then
                    for b1xx in (select bf4.plan_code,
                                        bf4.batch_no,
                                        bf4.trunk_no,
                                        bf4.box_no,
                                        bf4.package_no,
                                        bf4.box_no      bno,
                                        af4.sequence_no ano
                                   from wh_ticket_package bf4
                                   left join wh_goods_receipt_detail af4
                                     on (bf4.plan_code = af4.plan_code and
                                        bf4.batch_no = af4.batch_no and
                                        af4.trunk_no = bf4.trunk_no and
                                        af4.package_no = bf4.package_no and 
                                        af4.ref_no = p_ref_code and 
                                        af4.valid_number = evalid_number.pack )
                                  where bf4.plan_code = xx.plan_code
                                    and bf4.batch_no = xx.batch_no
                                    and bf4.box_no = xx.box_no ) loop
                    
                      if (b1xx.ano is null) then
                        v_total_pack_t := 1;
                        v_total_pack   := v_total_pack + v_total_pack_t;
                        v_total_amount := v_total_amount +
                                          (v_ticknum_p_pack * v_face_value);
                      
                        insert into wh_broken_recoder_detail
                          (broken_no,
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
                          (c_register_code,
                           f_get_detail_sequence_no_seq(),
                           evalid_number.pack,
                           b1xx.plan_code,
                           b1xx.batch_no,
                           b1xx.trunk_no,
                           b1xx.box_no,
                           b1xx.package_no,
                           1,
                           v_ticknum_p_pack * v_face_value);
                      
                        --损毁票状态更新
                        p_wh_ticket_damage(p_opr_admin,
                                           b1xx.plan_code,
                                           b1xx.batch_no,
                                           evalid_number.pack,
                                           b1xx.trunk_no,
                                           b1xx.box_no,
                                           b1xx.package_no);
                      
                      end if;
                    
                    end loop;
                  
                  else
                    --直接损毁
                    v_count_temp := 0;
                    select de.tickets_every_pack
                      into v_count_temp
                      from game_batch_import_detail de
                     where de.plan_code = xx.plan_code
                       and de.batch_no = xx.batch_no;
                    if v_count_temp > 0 then
                      v_total_pack_t := xx.tickets / v_count_temp;
                      v_total_pack   := v_total_pack + v_total_pack_t;
                      v_total_amount := v_total_amount + xx.amount;
                      insert into wh_broken_recoder_detail
                        (broken_no,
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
                        (c_register_code,
                         f_get_detail_sequence_no_seq(),
                         xx.valid_number,
                         xx.plan_code,
                         xx.batch_no,
                         xx.trunk_no,
                         xx.box_no,
                         xx.package_no,
                         v_total_pack_t,
                         xx.amount);
                    
                      --损毁票状态更新
                      p_wh_ticket_damage(p_opr_admin,
                                         xx.plan_code,
                                         xx.batch_no,
                                         xx.valid_number,
                                         xx.trunk_no,
                                         xx.box_no,
                                         '-');
                    
                    end if;
                  
                  end if;
                end;
              when evalid_number.pack then
                begin
                  --直接损毁
                  v_count_temp := 0;
                  select de.tickets_every_pack
                    into v_count_temp
                    from game_batch_import_detail de
                   where de.plan_code = xx.plan_code
                     and de.batch_no = xx.batch_no;
                  if v_count_temp > 0 then
                    v_total_pack_t := xx.tickets / v_count_temp;
                    v_total_pack   := v_total_pack + v_total_pack_t;
                    v_total_amount := v_total_amount + xx.amount;
                    insert into wh_broken_recoder_detail
                      (broken_no,
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
                      (c_register_code,
                       f_get_detail_sequence_no_seq(),
                       xx.valid_number,
                       xx.plan_code,
                       xx.batch_no,
                       xx.trunk_no,
                       xx.box_no,
                       xx.package_no,
                       v_total_pack_t,
                       xx.amount);
                  
                    --损毁票状态更新
                    p_wh_ticket_damage(p_opr_admin,
                                       xx.plan_code,
                                       xx.batch_no,
                                       xx.valid_number,
                                       xx.trunk_no,
                                       xx.box_no,
                                       xx.package_no);
                  
                  end if;
                end;
            end case;
          
          end if;
        end loop;
      
        --插入主表
        IF v_total_pack > 0 THEN
          insert into wh_broken_recoder
            (broken_no,
             apply_admin,
             apply_date,
             source,
             stb_no,
             cp_no,
             packages,
             total_amount,
             reason,
             remark)
          values
            (c_register_code,
             p_opr_admin,
             sysdate,
             p_check_type,
             '',
             p_ref_code,
             v_total_pack,
             v_total_amount,
             eticket_status.broken,
             p_remark);
        end if;
      
        --插入备注
        update wh_goods_receipt
           set wh_goods_receipt.remark = p_remark
         where wh_goods_receipt.ref_no = p_ref_code;
      
      end;
    when 3 then
      --盘点损毁
      begin
        v_total_pack   := 0;
        v_total_amount := 0;
      
        --循环遍历扩展-插入详情表
        FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_extend_arg1))) LOOP
          dbms_output.put_line(i.column_value);
          IF length(i.column_value) > 0 THEN
            v_total_pack_t   := 0;
            v_total_amount_t := 0;
          
            select cbe.packages, cbe.amount
              into v_total_pack_t, v_total_amount_t
              from wh_check_point_detail_be cbe
             where cbe.cp_no = p_ref_code
               and cbe.sequence_no = i.column_value;
          
            IF v_total_pack_t > 0 THEN
              v_total_pack   := v_total_pack + v_total_pack_t;
              v_total_amount := v_total_amount + v_total_amount_t;
            
              --Insert Detail
            
              for yy in (select *
                           from wh_check_point_detail_be
                          where cp_no = p_ref_code
                            and sequence_no = i.column_value) loop
              
                insert into wh_broken_recoder_detail
                  (broken_no,
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
                  (c_register_code,
                   f_get_detail_sequence_no_seq(),
                   yy.valid_number,
                   yy.plan_code,
                   yy.batch_no,
                   yy.trunk_no,
                   yy.box_no,
                   yy.package_no,
                   v_total_pack_t,
                   yy.amount);
              
                --损毁票状态更新
                p_wh_ticket_damage(p_opr_admin,
                                   yy.plan_code,
                                   yy.batch_no,
                                   yy.valid_number,
                                   yy.trunk_no,
                                   yy.box_no,
                                   yy.package_no);
              
              end loop;
            
            END IF;
          END IF;
        END LOOP;
      
        --插入主表
        IF v_total_pack > 0 THEN
          insert into wh_broken_recoder
            (broken_no,
             apply_admin,
             apply_date,
             source,
             stb_no,
             cp_no,
             packages,
             total_amount,
             reason,
             remark)
          values
            (c_register_code,
             p_opr_admin,
             sysdate,
             p_check_type,
             '',
             p_ref_code,
             v_total_pack,
             v_total_amount,
             eticket_status.broken,
             p_remark);
        
          --更新盘点单备注
        
          update wh_check_point
             set wh_check_point.remark = p_remark
           where wh_check_point.cp_no = p_ref_code;
        
        end if;
      
      end;
  end case;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END;
