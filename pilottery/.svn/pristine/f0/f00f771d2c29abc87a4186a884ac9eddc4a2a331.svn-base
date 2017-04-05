CREATE OR REPLACE PROCEDURE p_om_set_day_close
/*****************************************************************/
  ----------- 日结OMS操作  ---------------
  ----------- add by dzg 2014-10-15
  ----------- 日结清零，两件事：
  ----------- 1、对临时信用额度清零，
  ----------- 2、重置终端销售seq
  ----------- modify by dzg 2014-12-03 新增对资金管理缴款专员日结
  ----------- modify by CZ. 2016-02-26 按照KPW情况进行调整，取消针对销售站的数据调整。
  /*****************************************************************/
(

 --------------输入----------------
 p_day_code IN NUMBER, --日结期限

 -----------出口参数--------------
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述
 ) IS

  v_errorcode  NUMBER(10);  -- 错误编号
  v_errormesg  CHAR(32);    -- 错误信息

BEGIN

  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  --对临时信用额度清零
  --UPDATE saler_agency SET saler_agency.temp_credit = 0;

  -- 重置终端销售seq
  -- modify by ChenZhen @2016-06-11 重置终端登录状态
  update saler_terminal
     set trans_seq = 1,
         latest_login_teller_code = null,
         is_logging = eboolean.noordisabled;

  -- add by chenzhen @2016-06-11 重置teller的登录状态
  update inf_tellers
     set latest_terminal_code = null,
         latest_sign_on_time = null,
         latest_sign_off_time = null,
         is_online = eboolean.noordisabled;

  commit;

  -- 调用MIS日结
  p_mis_set_day_close(to_date(to_char(p_day_code),'yyyymmdd'), v_errorcode, v_errormesg);


  --异常处理
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

END;
