CREATE OR REPLACE PROCEDURE p_om_terminal_create
/***************************************************************
  ------------------- 新增terminal -------------------
  ---------modify by dzg  2014-7-8 增加返回值
  ---------modify by dzg  2014-7-10 插入默认终端版本1.0.0
  ---------modify by dzg  2014-8-11 修改增输入终端编码
  ---------modify by dzg  2014-8-30 修改bug版本号为1.0.00
  ---------modify by dzg  2014-8-31 修改bug插入时增加限制检测是否已经超过限制
  ---------modify by dzg  2014-9-11 增加检测限制销售站类型为4中心站不可以增加终端机
  ---------modify by dzg  2014-9-18 修改插入终端版本时候多插入了3个字段。
  ---------modify by dzg 2014.10.20 修改支持本地化
  ---------modify by dzg 2014.10.27 修改bug检测所属站点编码的有效性 =0未判断。
  ---------modify by dzg 2015.03.02 增加其他异常退出时对默认输出值赋默认值
  ---------modify by dzg 2015.04.13 增加输入版本
  ---------migrate by Chen Zhen @ 2016-04-18
  ---------modify by Chen Zhen @ 2016-04-19 删除训练模式入口参数；写入数据库的mac地址，均为大写

  ************************************************************/
(
 --------------输入----------------
 p_term_code     IN CHAR, --终端编码
 p_agency_code   IN CHAR, --销售站编码
 p_status        IN NUMBER, --状态
 p_mac_address   IN STRING, --终端MAC
 p_unique_code   IN STRING, --唯一标识码
 p_terminal_type IN NUMBER, --终端机型号
 p_terminal_ver  IN STRING, --终端版本

 ---------出口参数---------
 c_errorcode     OUT NUMBER, --错误编码
 c_errormesg     OUT STRING, --错误原因
 c_terminal_code OUT NUMBER --终端编码

 ) IS

  v_terminal_code   CHAR(10); --终端编码，临时变量
  v_temp_agency     CHAR(8); --临时变量用于比较终端
  v_count           NUMBER(5); --临时变量
  v_default_version VARCHAR(10); --默认终端版本。

BEGIN

  /*-----------    初始化数据   ------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_default_version := '1.0.00';

  IF p_terminal_ver is not null THEN
    IF trim(p_terminal_ver) is not null THEN
      v_default_version := trim(p_terminal_ver);
    END IF;
  END IF;

  /*-------检测所属站点编码的有效性-------*/
  SELECT COUNT(inf_agencys.agency_code)
    INTO v_count
    FROM inf_agencys
   WHERE inf_agencys.agency_code = p_agency_code
     AND inf_agencys.status != eagency_status.cancelled;

  IF v_count <= 0 THEN
    c_errorcode := 1;
    --c_errormesg := '无效的销售站';
    c_errormesg     := error_msg.msg0023;
    c_terminal_code := 0;
    RETURN;
  END IF;

  /*-------检测终端编码的有效性 ------*/
  v_temp_agency := substr(p_term_code, 1, 8);
  IF v_temp_agency != p_agency_code THEN
    c_errorcode := 1;
    --c_errormesg := '终端编码不符合规范';
    c_errormesg := error_msg.msg0049;
    RETURN;
  END IF;

  /*-------检测MAC是否重复-------*/
  v_count := 0;
  SELECT COUNT(saler_terminal.terminal_code)
    INTO v_count
    FROM saler_terminal
   WHERE upper(mac_address) = upper(p_mac_address)
     AND saler_terminal.status != eterminal_status.cancelled;

  IF v_count > 0 THEN
    c_errorcode := 1;
    --c_errormesg := 'MAC地址重复';
    c_errormesg     := error_msg.msg0050;
    c_terminal_code := 0;
    RETURN;
  END IF;

  /*-------检测MAC是否有效-------*/
  select count(*)
    into v_count
    from dual
   where regexp_like(upper(p_mac_address), '[0-9||A-Z][0-9||A-Z]:[0-9||A-Z][0-9||A-Z]:[0-9||A-Z][0-9||A-Z]:[0-9||A-Z][0-9||A-Z]:[0-9||A-Z][0-9||A-Z]:[0-9||A-Z][0-9||A-Z]');

  IF v_count = 0 THEN
    c_errorcode := 1;
    --c_errormesg := 'MAC地址不是有效格式';
    c_errormesg     := error_msg.msg0048;
    c_terminal_code := 0;
    RETURN;
  END IF;

  /*-----------   插入数据  ------------*/
  v_terminal_code := p_term_code;
  c_terminal_code := v_terminal_code;

  INSERT INTO saler_terminal
    (terminal_code,
     agency_code,
     unique_code,
     term_type_id,
     mac_address,
     status)
  VALUES
    (v_terminal_code,
     p_agency_code,
     p_unique_code,
     p_terminal_type,
     upper(p_mac_address),
     p_status);

  --插入终端版本
  INSERT INTO upg_term_software
    (terminal_code, term_type, running_pkg_ver, downing_pkg_ver)
  VALUES
    (v_terminal_code, p_terminal_type, v_default_version, '-');

  --提交
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    --c_errormesg := '数据库异常' || SQLERRM;
    c_errormesg     := error_msg.msg0004 || SQLERRM;
    c_terminal_code := 0;

END;
