CREATE OR REPLACE PROCEDURE p_sys_get_parameter
/****************************************************************/
   ------------------适用于:主机更新期次状态 -------------------
   /*************************************************************/
(
 --------------输入----------------
 p_param_code IN NUMBER, --参数编号
 ---------出口参数---------
 c_param_value OUT STRING, --参数内容
 c_errorcode   OUT NUMBER, --业务错误编码
 c_errormesg   OUT STRING --错误信息描述
 ) IS

BEGIN
   -- 初始化数据
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   -- 校验参数合法性
   IF p_param_code IS NULL THEN
      c_errorcode := -1;
      c_errormesg := '参数编号为空';
      RETURN;
   END IF;

   BEGIN
      SELECT sys_default_value
        INTO c_param_value
        FROM sys_parameter
       WHERE sys_default_seq = p_param_code;
   EXCEPTION
      WHEN no_data_found THEN
         c_errorcode := -1;
         c_errormesg := '无此参数。参数编号【' || p_param_code || '】';
   END;
EXCEPTION
   WHEN OTHERS THEN
      dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);
END;
