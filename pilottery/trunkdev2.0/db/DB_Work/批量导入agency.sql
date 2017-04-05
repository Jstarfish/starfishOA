set serveroutput on
declare
   v_code number(10);
   v_msg varchar2(4000);

   v_agency_code varchar2(4000);
begin
   p_outlet_create();
   if v_code <> 0 then
     dbms_output.put_line(v_msg);
   end if;
end;
/