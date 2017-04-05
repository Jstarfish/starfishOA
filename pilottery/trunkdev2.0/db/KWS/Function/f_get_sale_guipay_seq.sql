CREATE OR REPLACE FUNCTION f_get_sale_guipay_seq(agency_code NUMBER)
   RETURN VARCHAR2 IS
   /****************************************************************/
   ------------------- 适用于生成兑奖、取消流水--------------------
   -------add by 陈震 2014-7-12 格式 十二位terminal_code+六位日期+六位序列号-------
   /*************************************************************/
   v_date_str        CHAR(6);       --日期格式字符串
   v_seq_str         CHAR(6);       --序号字符串
   v_temp_count      NUMBER := 0;   --临时变量

BEGIN
   v_temp_count := seq_sale_gui_pay.nextval;
   v_date_str := to_char(SYSDATE, 'yymmdd');
   v_seq_str  := to_char(lpad(v_temp_count, 6, '0'));

   RETURN to_char(rpad(agency_code, 12, '0')) || v_date_str || v_seq_str;
END;
