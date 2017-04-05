-- SALE_AGENCY_RECEIPT :  AR00000050
-- WH_GOODS_RECEIPT_DETAIL : RK00000032

set serveroutput on
declare
   v_array_lotterys type_lottery_list;
   v_lottery_info type_lottery_info;

   v_c_balance      number(28);
   v_c_f_balance    number(28);
   v_c_errorcode  number(28);
   v_c_errormesg  varchar2(10000);

begin
   dbms_output.enable(100000000);
   v_array_lotterys := type_lottery_list();
   v_lottery_info := type_lottery_info('J0004','15905',3,null,null,null,'0009415',null,null);
   v_array_lotterys.extend;
   v_array_lotterys(v_array_lotterys.count) := v_lottery_info;

   -- ÍË»õ
   p_ar_outbound(p_agency => '01080067',
                p_oper => 12,
                p_array_lotterys => v_array_lotterys,
                c_errorcode => v_c_errorcode,
                c_errormesg => v_c_errormesg);
   if v_c_errorcode <> 0 then
      dbms_output.put_line('ÍË»õÊ§°Ü');
      dbms_output.put_line(v_c_errormesg);
      return;
   end if;

   -- ÌáÏÖ
   p_agency_fund_change(p_agency => '01080067',
                        p_type => eflow_type.withdraw,
                        p_amount => 200000,
                        p_frozen => 0,
                        p_ref_no => '20151129_DATABASE_JUDGE_',
                        c_balance => v_c_balance,
                        c_f_balance => v_c_f_balance);
   if v_c_errorcode <> 0 then
      dbms_output.put_line('Ê§°Ü2');
      dbms_output.put_line(v_c_errormesg);
      return;
   end if;

   -- ³äÖµ
   p_agency_fund_change(p_agency => '01080086',
                        p_type => eflow_type.charge,
                        p_amount => 200000,
                        p_frozen => 0,
                        p_ref_no => '20151129_DATABASE_JUDGE_',
                        c_balance => v_c_balance,
                        c_f_balance => v_c_f_balance);
   if v_c_errorcode <> 0 then
      dbms_output.put_line('Ê§°Ü3');
      dbms_output.put_line(v_c_errormesg);
      return;
   end if;

   -- ³ö»õ
   p_ar_inbound(p_agency => '01080086',
                p_oper => 12,
                p_array_lotterys => v_array_lotterys,
                c_errorcode => v_c_errorcode,
                c_errormesg => v_c_errormesg);
   if v_c_errorcode <> 0 then
      dbms_output.put_line('Ê§°Ü4');
      dbms_output.put_line(v_c_errormesg);
      return;
   end if;

end;
/

