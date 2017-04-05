CREATE OR REPLACE PROCEDURE p_outlet_topup
/****************************************************************/
   ------------------- 适用于站点充值-------------------
   ----站点充值
   ----add by dzg: 2015-9-24
   ----业务流程：插入申请表，插入流水，更新账户
   --- POS:outletCode  amount  admin transPassword（市场管理员）
   --- OMS 参数相同
   ----需要调用陈震存储过程
   ----修改输出的时候初始化返回值
   /*************************************************************/
(
 --------------输入----------------

 p_outlet_code IN STRING, --站点编码
 p_amount      IN NUMBER, --充值金额
 p_admin_id    IN NUMBER, --市场管理人员
 p_admin_tpwd  IN STRING, --市场管理交易密码

 ---------出口参数---------
 c_flow_code  OUT STRING, --申请流水
 c_bef_amount OUT NUMBER, --充值前金额
 c_aft_amount OUT NUMBER, --充值后金额
 c_errorcode  OUT NUMBER, --错误编码
 c_errormesg  OUT STRING --错误原因

 ) IS

   v_count_temp   NUMBER := 0; --临时变量
   v_outlet_name  varchar2(500) := ''; --站点名称
   v_outlet_accno varchar2(50) := ''; --站点账户编号

BEGIN

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   v_count_temp := 0;
   c_flow_code  := '-';
   c_bef_amount := 0;
   c_aft_amount := 0;

   /*----------- 数据校验   -----------------*/
   --编码不能为空
   IF ((p_outlet_code IS NULL) OR length(p_outlet_code) <= 0) THEN
      c_errorcode := 1;
      c_errormesg := error_msg.ERR_P_OUTLET_TOPUP_1;
      RETURN;
   END IF;

   --用户不存在或者无效
   SELECT count(u.admin_id)
     INTO v_count_temp
     FROM adm_info u
    WHERE u.admin_id = p_admin_id
      And u.admin_status <> eadmin_status.DELETED;

   IF v_count_temp <= 0 THEN
      c_errorcode := 2;
      c_errormesg := error_msg.ERR_P_OUTLET_TOPUP_2;
      RETURN;
   END IF;

   --密码不能为空
   IF ((p_admin_tpwd IS NULL) OR length(p_admin_tpwd) <= 0) THEN
      c_errorcode := 3;
      c_errormesg := error_msg.ERR_P_OUTLET_TOPUP_3;
      RETURN;
   END IF;

   --密码无效
   v_count_temp := 0;
   SELECT count(u.market_admin)
     INTO v_count_temp
     FROM inf_market_admin u
    WHERE u.market_admin = p_admin_id
      AND u.trans_pass = p_admin_tpwd;

   IF v_count_temp <= 0 THEN
      c_errorcode := 4;
      c_errormesg := error_msg.ERR_P_OUTLET_TOPUP_4;
      RETURN;
   END IF;

   --插入基本信息

   select a.agency_name, b.acc_no
     INTO v_outlet_name, v_outlet_accno
     from inf_agencys a
     left join acc_agency_account b
       on a.agency_code = b.agency_code
    where a.agency_code = p_outlet_code;

   --先生成编码
   c_flow_code := f_get_fund_charge_cash_seq();

   --插入资金流水相关信息
   p_agency_fund_change(p_outlet_code,
                        eflow_type.charge,
                        p_amount,
                        0,
                        c_flow_code,
                        c_aft_amount,
                        v_count_temp);

   insert into fund_charge_center
      (fund_no,
       account_type,
       ao_code,
       ao_name,
       acc_no,
       oper_amount,
       be_account_balance,
       af_account_balance,
       oper_time,
       oper_admin)
   values
      (c_flow_code,
       eaccount_type.agency,
       p_outlet_code,
       v_outlet_name,
       v_outlet_accno,
       p_amount,
       c_aft_amount - p_amount,
       c_aft_amount,
       sysdate,
       p_admin_id);

   --插入市场管理人员信息
   p_mm_fund_change(p_admin_id,
                    eflow_type.charge_for_agency,
                    p_amount,
                    c_flow_code,
                    v_count_temp);

   c_bef_amount := c_aft_amount - p_amount;

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      c_errorcode := 1;
      c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
