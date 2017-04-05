CREATE OR REPLACE PACKAGE dbtool IS

   -- 设置数据库错误参数（初始化）
   PROCEDURE set_success (
      errcode IN OUT NUMBER,
      errmesg IN OUT STRING
   );

   -- 设置数据库错误参数（错误信息）
   PROCEDURE set_dberror
   (
      errcode IN OUT NUMBER,
      errmesg IN OUT STRING
   );

   -- 用法: select * from table(dbtool.strsplit('1,2,3,4,5'))
   FUNCTION strsplit
   (
      p_value VARCHAR2,
      p_split VARCHAR2 := ','
   ) RETURN tabletype
      PIPELINED;

   -- 输出“[value]”格式的字符串
   function format_line(p_value varchar2) return varchar2;

END;
/

CREATE OR REPLACE PACKAGE BODY dbtool IS
   -- 设置数据库错误参数（初始化）
   PROCEDURE set_success
   (
      errcode IN OUT NUMBER,
      errmesg IN OUT STRING
   ) IS
   BEGIN
      errcode := 0;
      errmesg := 'Success';
   END set_success;

   -- 设置数据库错误参数（错误信息）
   PROCEDURE set_dberror
   (
      errcode IN OUT NUMBER,
      errmesg IN OUT STRING
   ) IS
   BEGIN
      errcode := SQLCODE;
      errmesg := SQLERRM;
   END set_dberror;

   FUNCTION strsplit
   (
      p_value VARCHAR2,
      p_split VARCHAR2 := ','
   )
   -- 用法: select * from table(dbtool.strsplit('1,2,3,4,5'))
    RETURN tabletype
      PIPELINED IS
      v_idx       INTEGER;
      v_str       VARCHAR2(500);
      v_strs_last VARCHAR2(4000) := p_value;

   BEGIN
      v_strs_last := TRIM(v_strs_last);
      LOOP
         v_idx := instr(v_strs_last, p_split);
         v_idx := nvl(v_idx,0);
         EXIT WHEN v_idx = 0;
         v_str       := substr(v_strs_last, 1, v_idx - 1);
         v_strs_last := substr(v_strs_last, v_idx + 1);
         PIPE ROW(v_str);
      END LOOP;
      PIPE ROW(v_strs_last);
      RETURN;

   END strsplit;

   function format_line(p_value varchar2) return varchar2 is
   begin
      return '[' || nvl(p_value, 'NULL') || ']';
   end format_line;

BEGIN
   NULL;
END;
/