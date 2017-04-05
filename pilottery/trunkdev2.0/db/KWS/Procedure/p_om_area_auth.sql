CREATE OR REPLACE PROCEDURE p_om_area_auth
/***************************************************************
  ------------------- 区域游戏游戏授权 -------------------
  ----处理逻辑是：先把所有无效，依次循环当前授权信息，如果有删除插入。
  ---------add by dzg  2014-8-27 单个区域的游戏授权
  ---------modify by dzg 2014.10.20 修改支持本地化
  ---------modify by dzg 2014.11.13 检测发行费用配置不能超出父级定义
  ---------modify by dzg 2014.12.10 还得比较下级不能比他大
  ---------modify by dzg 2014.12.23 修改bug应该<100比较区域，100以上比站

  ---------migrate by Chen Zhen @ 2016-04-14
  ************************************************************/
(

 --------------输入----------------

 p_game_auth_list IN type_game_auth_list_ts, --授权游戏

 --------------出口参数----------------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因

 ) IS

BEGIN
  /*-----------    初始化数据    -----------*/

  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  if p_game_auth_list.count = 0 then
    return;
  end if;

  -- 先清空该区域的已经授权信息，然后按照录入数组重新进行设置
  delete from auth_org where org_code = p_game_auth_list(1).objcode;

  /*-----------选择区域循环插入----------*/
  insert into auth_org
    (org_code, game_code,  pay_commission_rate, sale_commission_rate, auth_time, allow_pay,  allow_sale,  allow_cancel)
  select
     objcode,  gamecode,   paycommissionrate,   salecommissionrate,   sysdate,   isallowpay, isallowsale, isallowcancel
   from table(p_game_auth_list);

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    c_errormesg := error_msg.msg0004 || SQLERRM;

END;
