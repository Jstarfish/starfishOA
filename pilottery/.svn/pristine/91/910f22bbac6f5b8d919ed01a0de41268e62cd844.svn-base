CREATE OR REPLACE PROCEDURE p_om_update_sysparam
/****************************************************************/
  ------------------- 适用于更新系统参数 -------------------
  ----add by dzg 2014-07-21 基于分割符号
  ----传入参数格式： 1-1111#2-20000
  ----modify by dzg 2014.10.20 修改支持本地化
  /*************************************************************/
(
 --------------输入----------------
 p_params IN STRING, --参数，格式1-1111#2-20000

 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 ) IS

  v_split_kv     STRING(1); --分割符号
  v_split_values STRING(1); --分割符号
  v_key          STRING(3); --key
  v_value        STRING(20); --value
  v_temp         STRING(25); --key-value

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_split_kv     := '-';
  v_split_values := '#';

  /*-----------    删除期次   -----------------*/
  IF length(p_params) <= 0 THEN
    c_errorcode := 1;
    --c_errormesg := '无效的参数对象';
    c_errormesg := error_msg.MSG0055;

    RETURN;
  END IF;

  /*-----------  循环更新 ---------------*/
  IF length(p_params) > 0 THEN

    FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_params, v_split_values))) LOOP
      dbms_output.put_line(i.column_value);
      v_temp  := '';
      v_key   := '';
      v_value := '';
      IF length(i.column_value) > 0 THEN
        v_temp  := i.column_value;
        v_key   := substr(v_temp, 0, instr(v_temp, v_split_kv) - 1);
        v_value := substr(v_temp, instr(v_temp, v_split_kv) + 1);

        UPDATE sys_parameter
           SET sys_parameter.sys_default_value = v_value
         WHERE sys_parameter.sys_default_seq = v_key;

      END IF;
    END LOOP;

  END IF;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    --c_errormesg := '数据库异常' || SQLERRM;
    c_errormesg := error_msg.MSG0004 || SQLERRM;

END p_om_update_sysparam;
