CREATE OR REPLACE FUNCTION f_get_area_display(p_area_code char) RETURN varchar2
IS
   v_display      varchar2(40);
   v_area_type    number(1);
BEGIN
   case
      when p_area_code = 0 then
         v_display := '0';
      when p_area_code > 0 and p_area_code <= 99 then
         v_display := lpad(to_char(p_area_code),2,'0');
      when p_area_code >= 100 and p_area_code <= 9999 then
         v_display := lpad(to_char(p_area_code),4,'0');
      when p_area_code >= 10000 and p_area_code <= 999999 then
         v_display := lpad(to_char(p_area_code),6,'0');
    end case;
    return v_display;
END;
