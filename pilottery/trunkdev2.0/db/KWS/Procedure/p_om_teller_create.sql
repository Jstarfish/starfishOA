CREATE OR REPLACE PROCEDURE p_om_teller_create
/***************************************************************
  ------------------- 新增teller -------------------
  ---------modify by dzg  2014-7-8 增加返回值
  ---------modify by dzg  2014-8-11 增加插入编号
  ---------modify by dzg  2014-8-31 增加限制值检测
  ---------modify by dzg  2014-9-15 增加限制中心直属站不可增加
  ---------modify by dzg  2014-9-23 增加检测重复，删除也不可以重用那是主键
  ---------modify by dzg 2014.10.20 修改支持本地化
  ---------modify by dzg 2015.03.02 增加异常退出时输出默认值0

  ---------migrate from Taishan by Chen Zhen @ 2016-03-21
  ************************************************************/
(
 --------------输入----------------
 p_teller_code   IN NUMBER, -- 销售员编号
 p_agency_code   IN STRING, -- 销售站编码
 p_teller_name   IN STRING, -- 销售员名称
 p_teller_type   IN NUMBER, -- 销售员类型
 p_teller_status IN NUMBER, -- 销售员状态
 p_password      IN STRING, -- 销售员密码
 ---------出口参数---------
 c_errorcode   OUT NUMBER, --错误编码
 c_errormesg   OUT STRING, --错误原因
 c_teller_code OUT NUMBER -- 销售员编码
 ) IS
  v_temp         NUMBER := 0; --临时变量

BEGIN

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  /*-------检测所属站点编码的有效性-------*/
  SELECT COUNT(inf_agencys.agency_code)
    INTO v_temp
    FROM inf_agencys
   WHERE agency_code = p_agency_code
     AND status != eagency_status.cancelled;

  IF v_temp <= 0 THEN
    c_errorcode := 1;
    c_errormesg   := error_msg.err_p_teller_create_1;                                              -- 无效的销售站
    c_teller_code := 0;
    RETURN;
  END IF;

  /*-------检测重复 -------*/
  v_temp := 0;
  SELECT COUNT(teller_code)
    INTO v_temp
    FROM inf_tellers
   WHERE teller_code = p_teller_code;

  IF v_temp > 0 THEN
    c_errorcode := 1;
    c_errormesg   := error_msg.err_p_teller_create_2;                                              -- 销售员编号重复
    c_teller_code := 0;
    RETURN;
  END IF;

  -- 超出系统预设范围
  v_temp := 99999999;
  IF p_teller_code > v_temp THEN
    c_errorcode := 1;
    c_errormesg   := error_msg.err_p_teller_create_3;                                              -- 输入的编码超出范围！
    c_teller_code := 0;
    RETURN;
  END IF;

  /* 插入数据，注意最后三项为NULL */

  c_teller_code := p_teller_code;

  INSERT INTO inf_tellers
    (teller_code, agency_code, teller_name, teller_type, status, password)
  VALUES
    (p_teller_code,
     p_agency_code,
     p_teller_name,
     p_teller_type,
     p_teller_status,
     lower(p_password));

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg   := error_msg.err_common_1 || SQLERRM;
    c_teller_code := 0;

END;
