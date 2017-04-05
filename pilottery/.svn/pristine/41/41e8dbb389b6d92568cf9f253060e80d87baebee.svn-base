delete from GAME_BATCH_IMPORT where plan_code='J0001' and batch_no='14901';
delete from WH_GOODS_RECEIPT_DETAIL where plan_code='J0001' and batch_no='14901';
delete from WH_TICKET_TRUNK where plan_code='J0001' and batch_no='14901';
delete from WH_TICKET_BOX where plan_code='J0001' and batch_no='14901';
delete from WH_TICKET_PACKAGE where plan_code='J0001' and batch_no='14901';
delete from WH_GOODS_RECEIPT where sgr_no = (select sgr_no from WH_GOODS_RECEIPT_DETAIL where plan_code='J0001' and batch_no='14901');
delete from WH_BATCH_INBOUND where plan_code='J0001' and batch_no='14901';


-- 批次文件信息导入
set serveroutput on
declare
    c_err_code number(10);
    c_err_msg varchar2(4000);
begin
    p_import_batch_file('J0001', '14901', '0', c_err_code, c_err_msg);
    dbms_output.put_line(c_err_code);
    dbms_output.put_line(c_err_msg);
end;
/

-- 批次实体货物入库（新增）
set serveroutput on
declare
  -- Non-scalar parameters require additional processing
  p_array_lotterys type_lottery_list;
  v_lottery_info type_lottery_info;
  c_err_code number(10);
  c_err_msg varchar2(4000);
  c_inbound_no varchar2(100);
begin
  -- Call the procedure
  p_array_lotterys := type_lottery_list();
  v_lottery_info := type_lottery_info(null,null,1,'00001',null,null,null,null,null);
  p_array_lotterys.extend;
  p_array_lotterys(p_array_lotterys.count) := v_lottery_info;

  p_batch_inbound(p_inbound_no => '',
                  p_plan => 'J0001',
                  p_batch => '14901',
                  p_warehouse => '0001',
                  p_oper_type => 1,
                  p_oper => 0,
                  p_array_lotterys => p_array_lotterys,
                  c_inbound_no => c_inbound_no,
                  c_errorcode => c_err_code,
                  c_errormesg => c_err_msg);
    dbms_output.put_line(c_err_code);
    dbms_output.put_line(c_err_msg);
    dbms_output.put_line(c_inbound_no);
end;
/

-- 批次实体货物入库（继续）
set serveroutput on
declare
  -- Non-scalar parameters require additional processing
  p_array_lotterys type_lottery_list;
  v_lottery_info type_lottery_info;
  c_err_code number(10);
  c_err_msg varchar2(4000);
  c_inbound_no varchar2(100);
begin
  -- Call the procedure
  p_array_lotterys := type_lottery_list();
  v_lottery_info := type_lottery_info(null,null,1,'00002',null,null,null,null,null);
  p_array_lotterys.extend;
  p_array_lotterys(p_array_lotterys.count) := v_lottery_info;

  p_batch_inbound(p_inbound_no => 'BI00000182',
                  p_plan => 'J0001',
                  p_batch => '14901',
                  p_warehouse => '0001',
                  p_oper_type => 2,
                  p_oper => 0,
                  p_array_lotterys => p_array_lotterys,
                  c_inbound_no => c_inbound_no,
                  c_errorcode => c_err_code,
                  c_errormesg => c_err_msg);
    dbms_output.put_line(c_err_code);
    dbms_output.put_line(c_err_msg);
    dbms_output.put_line(c_inbound_no);
end;
/

-- 批次实体货物入库（终止）
set serveroutput on
declare
  -- Non-scalar parameters require additional processing
  p_array_lotterys type_lottery_list;
  v_lottery_info type_lottery_info;
  c_err_code number(10);
  c_err_msg varchar2(4000);
  c_inbound_no varchar2(100);
begin
  -- Call the procedure
  p_batch_inbound(p_inbound_no => 'BI00000182',
                  p_plan => 'J0001',
                  p_batch => '14901',
                  p_warehouse => '0001',
                  p_oper_type => 3,
                  p_oper => 0,
                  p_array_lotterys => p_array_lotterys,
                  c_inbound_no => c_inbound_no,
                  c_errorcode => c_err_code,
                  c_errormesg => c_err_msg);
    dbms_output.put_line(c_err_code);
    dbms_output.put_line(c_err_msg);
    dbms_output.put_line(c_inbound_no);
end;
/

-- 调拨单出库
set serveroutput on
declare
   -- Non-scalar parameters require additional processing
   p_array_lotterys type_lottery_list;
   v_lottery_info type_lottery_info;
   c_err_code number(10);
   c_err_msg varchar2(4000);
begin

   p_array_lotterys := type_lottery_list();
   v_lottery_info := type_lottery_info(null,null,1,'00002',null,null,null,null,null);
   p_array_lotterys.extend;
   p_array_lotterys(p_array_lotterys.count) := v_lottery_info;

   p_tb_outbound(p_stb_no => 'DB00000184',
                p_warehouse => '0001',
                p_oper_type => 1,
                p_oper => 0,
                p_remark => '',
                p_array_lotterys => p_array_lotterys,
                c_errorcode => c_err_code,
                c_errormesg => c_err_code);
   dbms_output.put_line(c_err_code);
   dbms_output.put_line(c_err_msg);

end;
/
declare
  -- Non-scalar parameters require additional processing
  p_array_lotterys type_lottery_list;
  v_lottery_info type_lottery_info;
begin
      p_array_lotterys := type_lottery_list();
   v_lottery_info := type_lottery_info('J0001','14901',1,'00002',null,null,null,null,null);
   p_array_lotterys.extend;
   p_array_lotterys(p_array_lotterys.count) := v_lottery_info;
  -- Call the procedure
  p_tb_outbound(p_stb_no => :p_stb_no,
                p_warehouse => :p_warehouse,
                p_oper_type => :p_oper_type,
                p_oper => :p_oper,
                p_remark => :p_remark,
                p_array_lotterys => p_array_lotterys,
                c_errorcode => :c_errorcode,
                c_errormesg => :c_errormesg);
end;



--- 生成 兑奖字符创
declare
    rec_string varchar2(4000);
    head_string varchar2(4000);
    security_string varchar2(4000);
    reward_string varchar2(4000);

    rand_number number(10);
begin
    for i_loop in (select package_no from WH_TICKET_package where plan_code='J0001' and batch_no='14901') loop
    rec_string := '';
    head_string := 'J000114901';
    security_string := lpad(to_char(trunc(dbms_random.value * power(10,16))), 16, '0');
    rec_string := head_string || i_loop.package_no || lpad((100 + trunc(dbms_random.value * 100)), 3, '0') || security_string;
    rand_number := trunc(dbms_random.value * 8);
    case
        when rand_number = 0 then
            reward_string := 'AA001';
        when rand_number = 1 then
            reward_string := 'AB002';
        when rand_number = 2 then
            reward_string := 'AC003';
        when rand_number = 3 then
            reward_string := 'AD004';
        when rand_number = 4 then
            reward_string := 'AE005';
        when rand_number = 5 then
            reward_string := 'AF006';
        when rand_number = 6 then
            reward_string := 'AG007';
        when rand_number = 7 then
            reward_string := 'AH008';

    end case;

    rec_string := rec_string || reward_string;

    insert into GAME_BATCH_REWARD_DETAIL values ('IMP-00000079', 'J0001', '14901', rec_string, 0);

    end loop;
end;
/


declare
  -- Non-scalar parameters require additional processing
  p_array_lotterys type_mm_check_lottery_list;
  c_array_lotterys type_mm_check_lottery_list;

  v_in type_mm_check_lottery_info;
  v_out type_mm_check_lottery_info;
begin
  p_array_lotterys := type_mm_check_lottery_list();
  v_in := type_mm_check_lottery_info('J0004','15905',3,null,null,'0019152',0,0);
  p_array_lotterys.extend;
  p_array_lotterys(p_array_lotterys.count) := v_in;
  v_in := type_mm_check_lottery_info('J0004','15905',3,null,null,'1019152',0,0);
  p_array_lotterys.extend;
  p_array_lotterys(p_array_lotterys.count) := v_in;
  -- Call the procedure
  p_mm_inv_check(p_oper => :p_oper,
                 p_array_lotterys => p_array_lotterys,
                 c_array_lotterys => c_array_lotterys,
                 c_inv_tickets => :c_inv_tickets,
                 c_check_tickets => :c_check_tickets,
                 c_diff_tickets => :c_diff_tickets,
                 c_errorcode => :c_errorcode,
                 c_errormesg => :c_errormesg);
   for itab in (select * from table(c_array_lotterys)) loop
      dbms_output.put(itab.plan_code);
      dbms_output.put(chr(9)||'|');
      dbms_output.put(itab.batch_no);
      dbms_output.put(chr(9)||'|');
      dbms_output.put(itab.package_no);
      dbms_output.put(chr(9)||'|');
      dbms_output.put_line(itab.status);
   end loop;
end;



declare
  -- Non-scalar parameters require additional processing
  p_array_lotterys type_lottery_reward_list;
  c_check_result type_mm_check_lottery_list;

  v_in type_lottery_reward_info;
  v_out type_mm_check_lottery_info;

begin
  p_array_lotterys := type_lottery_reward_list();
  v_in := type_lottery_reward_info('J0003','15907','0006805',123,'AJWZICJZVLGHOIRYAG016');
  p_array_lotterys.extend;
  p_array_lotterys(p_array_lotterys.count) := v_in;

  -- Call the procedure
  p_lottery_reward2(p_oper => :p_oper,
                    p_array_lotterys => p_array_lotterys,
                    c_check_result => c_check_result,
                    c_apply_tickets => :c_apply_tickets,
                    c_fail_tickets_new => :c_fail_tickets_new,
                    c_reward_tickets => :c_reward_tickets,
                    c_reward_amount => :c_reward_amount,
                    c_pay_flow => :c_pay_flow,
                    c_errorcode => :c_errorcode,
                    c_errormesg => :c_errormesg);
end;


declare
  -- Non-scalar parameters require additional processing
  p_array_lotterys type_lottery_reward_list;
  v_in type_lottery_reward_info;

begin
  p_array_lotterys := type_lottery_reward_list();
  v_in := type_lottery_reward_info('J0003', '15904', '0009041', 159, 'NVTZOBJTBDPVZHSZAG016');
  p_array_lotterys.extend;
  p_array_lotterys(p_array_lotterys.count) := v_in;

  -- Call the procedure
  p_lottery_reward_all(p_oper => :p_oper,
                       p_pay_agency => :p_pay_agency,
                       p_array_lotterys => p_array_lotterys,
                       c_seq_no => :c_seq_no,
                       c_errorcode => :c_errorcode,
                       c_errormesg => :c_errormesg);
end;


-- 物流查询
set serveroutput on
declare
   v_out type_logistics_list;
   v_1 number;
   v_2 date;
   v_e_1 number;
   v_e_2 string(10000);

   v_str string(1000);

   v_plan varchar2(100);
   v_batch varchar2(100);
   v_no varchar2(100);
   v_type number(10);
begin
   v_plan := 'J0004';
   v_batch := '15905';
   v_no := '0009260';
   v_type := 3;

   p_get_lottery_history(v_plan,v_batch,v_type,v_no,null,v_1,v_2,v_out,v_e_1,v_e_2);

   dbms_output.put_line('PLAN_CODE: [' || v_plan || '] BATCH_NO: [' || v_batch || '] VALUE: [' || v_no || ']');
   dbms_output.put_line(lpad('-',90,'-'));
   for itab in (select * from table(v_out) order by ttime desc) loop
      if itab.obj_type > 10 then
         case
            when itab.obj_type - 10 = ereceipt_type.batch then
               v_str := '批次入库';
            when itab.obj_type - 10 = ereceipt_type.trans_bill then
               v_str := '调拨单入库';
            when itab.obj_type - 10 = ereceipt_type.return_back then
               v_str := '退货入库';
            when itab.obj_type - 10 = ereceipt_type.agency then
               v_str := '站点入库';
            else
               v_str := itab.obj_type;
         end case;

      else
         case
            when itab.obj_type = eissue_type.trans_bill then
               v_str := '调拨出库';
            when itab.obj_type = eissue_type.delivery_order then
               v_str := '出货单出库';
            when itab.obj_type = eissue_type.broken then
               v_str := '损毁出库';
            when itab.obj_type = eissue_type.agency_return then
               v_str := '站点退货';
            else
               v_str := itab.obj_type;
         end case;
      end if;

      dbms_output.put(to_char(itab.ttime,'yyyy-mm-dd hh24:mi:ss'));
      dbms_output.put(' | ');
      dbms_output.put(lpad(v_str,10,' '));
      dbms_output.put(' | ');
      dbms_output.put(lpad(itab.obj_object_s,30,' '));
      dbms_output.put(' | ');
      dbms_output.put_line(lpad(itab.obj_object_t,20,' '));
      dbms_output.put_line(lpad('-',90,'-'));

   end loop;
end;
/

-- 重新刷新报表数据（因为基础库存、站点资金日结、管理员资金日结和分公司佣金计算是需要获取当前值，所以没有办法刷新）
declare
    v_now_date date;
begin
    for i in 1 .. 43 loop
        v_now_date := to_date('2015-12-01','yyyy-mm-dd') + i;
        dbms_output.put_line(to_char(v_now_date, 'yyyy-mm-dd'));

        delete his_agency_inv where calc_date = to_char(v_now_date - 1, 'yyyy-mm-dd');
        delete his_sale_org where calc_date = to_char(v_now_date - 1, 'yyyy-mm-dd');
        delete his_org_fund_report where calc_date = to_char(v_now_date - 1, 'yyyy-mm-dd');
        delete HIS_MM_INVENTORY where calc_date = to_char(v_now_date - 1, 'yyyy-mm-dd');
        delete his_org_fund where calc_date = to_char(v_now_date - 1, 'yyyy-mm-dd');
        delete HIS_ORG_INV_REPORT where calc_date = to_char(v_now_date - 1, 'yyyy-mm-dd');

        p_his_gen_by_day(v_now_date, 1);
    end loop;
end;
/











------- 线上调试退票语句，用来检查佣金问题


declare
  -- Non-scalar parameters require additional processing
  p_array_lotterys type_lottery_list;
  v_lottery_info type_lottery_info;
  v_count number(10);
  v_str string(1000);
begin
  update wh_ticket_package set STATUS=31, CURRENT_WAREHOUSE='01100101' where PLAN_CODE = 'J0003' and batch_no='15907' and PACKAGE_NO = '0012930';
  update wh_ticket_package set STATUS=31, CURRENT_WAREHOUSE='01100101' where PLAN_CODE = 'J0002' and batch_no='15906' and PACKAGE_NO = '0002782';
  update wh_ticket_package set STATUS=31, CURRENT_WAREHOUSE='01100101' where PLAN_CODE = 'J0003' and batch_no='15907' and PACKAGE_NO = '0014151';
  update wh_ticket_package set STATUS=31, CURRENT_WAREHOUSE='01100101' where PLAN_CODE = 'J0003' and batch_no='15907' and PACKAGE_NO = '0014153';
  update wh_ticket_package set STATUS=31, CURRENT_WAREHOUSE='01100101' where PLAN_CODE = 'J0003' and batch_no='15907' and PACKAGE_NO = '0014186';

  p_array_lotterys := type_lottery_list();
  v_lottery_info := type_lottery_info('J0003','15907',3,null,null,null,'0012930',null,null);
  p_array_lotterys.extend;
  p_array_lotterys(p_array_lotterys.count) := v_lottery_info;

  v_lottery_info := type_lottery_info('J0002','15906',3,null,null,null,'0002782',null,null);
  p_array_lotterys.extend;
  p_array_lotterys(p_array_lotterys.count) := v_lottery_info;

  v_lottery_info := type_lottery_info('J0003','15907',3,null,null,null,'0014151',null,null);
  p_array_lotterys.extend;
  p_array_lotterys(p_array_lotterys.count) := v_lottery_info;

  v_lottery_info := type_lottery_info('J0003','15907',3,null,null,null,'0014153',null,null);
  p_array_lotterys.extend;
  p_array_lotterys(p_array_lotterys.count) := v_lottery_info;

  v_lottery_info := type_lottery_info('J0003','15907',3,null,null,null,'0014186',null,null);
  p_array_lotterys.extend;
  p_array_lotterys(p_array_lotterys.count) := v_lottery_info;

  -- Call the procedure
  p_ar_outbound_bak(p_agency => :p_agency,
                    p_oper => :p_oper,
                    p_array_lotterys => p_array_lotterys,
                    c_errorcode => :c_errorcode,
                    c_errormesg => :c_errormesg);

  select wm_concat(change_amount) into v_str from flow_agency where agency_code='01100101' and trade_time > (trunc(sysdate) - 1) and flow_type=13 and AGENCY_FUND_FLOW > 'ZD0000000000000000537092';
  dbms_output.put_line(v_str);

                   rollback;

end;
