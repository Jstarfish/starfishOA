create or replace procedure p_om_agency_auth
/***************************************************************
  ------------------- 销售站游戏批量授权 -------------------
  ---------add by dzg  2014-8-28 单个站点的游戏授权
  ---------处理逻辑：同单个区域的游戏授权，先去授权，然后依次授权
  ---------modify by dzg 2014.10.20 修改支持本地化
  ---------modify by dzg 2014.11.13 检测发行费用配置不能超出父级定义
  ************************************************************/
(

 --------------输入----------------

 p_game_auth_list in type_game_auth_list_ts, --授权游戏

 --------------出口参数----------------
 c_errorcode out number, --错误编码
 c_errormesg out string --错误原因

 ) is

begin
  /*-----------    初始化数据    -----------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  if p_game_auth_list.count = 0 then
    return;
  end if;

  -- 先清空该销售站的已经授权信息，然后按照录入数组重新进行设置
  delete from auth_agency where agency_code = p_game_auth_list(1).objcode;

  /*----------- 选择销售站循环插入 -----------*/

    insert into auth_agency
      (agency_code,             game_code,          pay_commission_rate,
       sale_commission_rate,    allow_pay,          allow_sale,         allow_cancel,
       claiming_scope,          auth_time)
    select
       objcode,                 gamecode,           paycommissionrate,
       salecommissionrate,      isallowpay,         isallowsale,        isallowcancel,
       claimingscope,           sysdate
    from table(p_game_auth_list);

  commit;

exception
  when others then
    rollback;
    c_errorcode := 1;
    c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
