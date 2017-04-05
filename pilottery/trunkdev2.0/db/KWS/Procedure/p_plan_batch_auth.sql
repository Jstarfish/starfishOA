CREATE OR REPLACE PROCEDURE p_plan_batch_auth
/***************************************************************
  ------------------- 新增方案，批量授权 -------------------
  --------- add by Chen Zhen  2016-03-30 新增
  ---------
  ************************************************************/
(

 --------------输入----------------
 p_plan_code         IN STRING, -- 新方案编号
 p_ref_plan          IN STRING, -- 参考方案编号

 --------------出口参数----------------
 c_errorcode         OUT NUMBER, --错误编码
 c_errormesg         OUT STRING --错误原因

 ) IS

BEGIN
  /*-----------    初始化数据    -----------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  insert into game_org_comm_rate select org_code, p_plan_code, sale_comm, pay_comm from game_org_comm_rate where plan_code = p_ref_plan;
  insert into game_agency_comm_rate select agency_code, p_plan_code, sale_comm, pay_comm from game_agency_comm_rate where plan_code = p_ref_plan;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
