create or replace procedure p_lottery_check_valid
/***************************************************************************/
  ------------- 盘点入库重复验证，主要用于验证重复数据 ----------------
  /***************************************************************************/
(
 --------------输入----------------
 p_array_lotterys IN type_lottery_detail_list, -- 待查询的彩票对象
 p_check_code     IN STRING -- 总金额
 
 ) is

  type t_detail is table of wh_check_point_detail%rowtype; -- 盘点定义表
  v_detail  t_detail; -- 盘点检测详情表
  v_lottery type_lottery_detail_info; -- 单张彩票

  v_is_full number(2); -- 是否完整

begin

  -- 检测包装中箱号是否完整
  IF (p_array_lotterys is null or p_array_lotterys.count <= 0) THEN
    RETURN;
  END IF;

  for v_index1 in 1 .. p_array_lotterys.count loop
    v_lottery := p_array_lotterys(v_index1);
    v_is_full := 0;
    if v_lottery.valid_number = evalid_number.trunk then
      select nvl(is_full, 0)
        into v_is_full
        from wh_ticket_trunk t
       where t.status < 30
         and t.plan_code = v_lottery.plan_code
         and t.batch_no = v_lottery.batch_no
         and t.trunk_no = v_lottery.trunk_no;
    
      if v_is_full = 0 then
        raise_application_error(-20001,
                                dbtool.format_line(v_lottery.plan_code) ||
                                dbtool.format_line(v_lottery.batch_no) ||
                                dbtool.format_line(v_lottery.trunk_no) ||
                                error_msg.err_p_ar_inbound_4);
      end if;
    end if;
  end loop;

  -- 初始化数组
  select * bulk collect
    into v_detail
    from wh_check_point_detail
   where cp_no = p_check_code;

  --没有历史记录直接返回
  IF (v_detail is null or v_detail.count <= 0) THEN
    RETURN;
  END IF;

  -- 循环检测历史数据是否重复
  for v_index2 in 1 .. p_array_lotterys.count loop
    v_lottery := p_array_lotterys(v_index2);
  
    for v_index3 in 1 .. v_detail.count loop
      if v_detail(v_index3).plan_code = v_lottery.plan_code and v_detail(v_index3)
         .batch_no = v_lottery.batch_no then
      
        case
          when v_lottery.valid_number = evalid_number.trunk then
            if v_detail(v_index3).trunk_no = v_lottery.trunk_no then
              raise_application_error(-20001,
                                      dbtool.format_line(v_lottery.plan_code) ||
                                      dbtool.format_line(v_lottery.batch_no) ||
                                      'Trunk:' ||
                                      dbtool.format_line(v_lottery.trunk_no) ||
                                      error_msg.msg0009);
            end if;
          
          when v_lottery.valid_number = evalid_number.box then
            if v_detail(v_index3)
             .box_no = v_lottery.box_no or
                (v_detail(v_index3).valid_number = evalid_number.trunk and v_detail(v_index3)
                 .trunk_no = v_lottery.trunk_no) then
              raise_application_error(-20001,
                                      dbtool.format_line(v_lottery.plan_code) ||
                                      dbtool.format_line(v_lottery.batch_no) ||
                                      'Box:' ||
                                      dbtool.format_line(v_lottery.box_no) ||
                                      error_msg.msg0009);
            end if;
          when v_lottery.valid_number = evalid_number.pack or
               (v_detail(v_index3).valid_number = evalid_number.trunk and v_detail(v_index3)
               .trunk_no = v_lottery.trunk_no) or
               (v_detail(v_index3).valid_number = evalid_number.box and v_detail(v_index3)
               .box_no = v_lottery.box_no) then
            if v_detail(v_index3).package_no = v_lottery.package_no then
              raise_application_error(-20001,
                                      dbtool.format_line(v_lottery.plan_code) ||
                                      dbtool.format_line(v_lottery.batch_no) ||
                                      'Package:' ||
                                      dbtool.format_line(v_lottery.package_no) ||
                                      error_msg.msg0009);
            end if;
        end case;
      
      end if;
    
    end loop;
  
  end loop;

end;
