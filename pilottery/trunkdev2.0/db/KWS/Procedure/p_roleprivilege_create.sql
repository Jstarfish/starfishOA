CREATE OR REPLACE PROCEDURE p_roleprivilege_create
/****************************************************************/
  ------------------- 适用于创建角色权限-------------------
  ----创建角色权限
  ----add by dzg: 2015-9-19 
  ----业务流程：先删除原来用户权限，然后插入新的角色权限
  /*************************************************************/
(
 --------------输入----------------
 p_role_id      IN NUMBER, --角色ID
 p_role_privileges   IN STRING, --权限列表,使用“,”分割的多个字符串
 
 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 
 ) IS

  v_count_temp NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_count_temp := 0;

  /*----------- 数据校验   -----------------*/
  --角色编码异常
  IF (p_role_id < 0) THEN
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_P_INSTITUTIONS_CREATE_1;
    RETURN;
  END IF;

  --循环插入角色用户
  --先清理原有数据
  
  delete from adm_role_privilege
   where adm_role_privilege.role_id = p_role_id;

  FOR i IN (SELECT * FROM TABLE(dbtool.strsplit(p_role_privileges))) LOOP
    dbms_output.put_line(i.column_value);
  
    IF length(i.column_value) > 0 THEN
      
    insert into adm_role_privilege
      (role_id, privilege_id)
    values
      (p_role_id,i.column_value);
  
    
    END IF;
  END LOOP;
  

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;
  
END p_roleprivilege_create;
/
