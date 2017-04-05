select plan_code || batch_no || lpad(BOXES_EVERY_TRUNK, 3, '0') ||
       lpad(PACKS_EVERY_TRUNK, 3, '0') || lpad(TICKETS_EVERY_PACK, 3, '0') ||
       lpad(TICKET_NO_START, 7, '0') || lpad(TICKET_NO_END, 7, '0')
  from WH_TICKET_PACKAGE
  join GAME_BATCH_IMPORT_DETAIL
 using (plan_code, batch_no);


with agency as (
select agency_code,sum(GX) GX, sum(DGL) DGL,sum(BALL) BALL,sum(PHONE) PHONE from (
select current_warehouse agency_code,
       (case when plan_code='J0004' then (ticket_no_end - ticket_no_start + 1) else 0 end) GX,
       (case when plan_code='J0005' then (ticket_no_end - ticket_no_start + 1) else 0 end) DGL,
       (case when plan_code='J0003' then (ticket_no_end - ticket_no_start + 1) else 0 end) BALL,
       (case when plan_code='J0002' then (ticket_no_end - ticket_no_start + 1) else 0 end) PHONE
  from wh_ticket_package
 where status = 31) group by agency_code)
select agency_code,CONTRACT_NO,ACCOUNT_BALANCE,CREDIT_LIMIT,gx,dgl,ball,phone
from acc_agency_account join inf_agency_ext using(agency_code)
join agency using(agency_code)

with mm as (
select MM_CODE,sum(GX) GX, sum(DGL) DGL,sum(BALL) BALL,sum(PHONE) PHONE from (
select current_warehouse MM_CODE,
       (case when plan_code='J0004' then (ticket_no_end - ticket_no_start + 1) else 0 end) GX,
       (case when plan_code='J0005' then (ticket_no_end - ticket_no_start + 1) else 0 end) DGL,
       (case when plan_code='J0003' then (ticket_no_end - ticket_no_start + 1) else 0 end) BALL,
       (case when plan_code='J0002' then (ticket_no_end - ticket_no_start + 1) else 0 end) PHONE
  from wh_ticket_package
 where status = 21) group by MM_CODE)
select MARKET_ADMIN,gx,dgl,ball,phone,CREDIT_LIMIT,ACCOUNT_BALANCE
from acc_mm_account
join mm on (mm.mm_code=acc_mm_account.market_admin)



select admin_login,full_name,tickets from acc_mm_tickets join adm_info on(acc_mm_tickets.market_admin=adm_info.admin_id)
join game_plans using(plan_code)

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

-- 测试系统修改登录用户与口令
update adm_info set admin_login = admin_id, admin_password='e3ceb5881a0a1fdaad01296d7554868d';