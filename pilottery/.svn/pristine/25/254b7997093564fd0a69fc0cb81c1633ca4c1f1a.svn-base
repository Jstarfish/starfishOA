CREATE OR REPLACE PROCEDURE p_institutions_topup
/****************************************************************/
   ------------------- 适用于机构充值-------------------
   ----机构充值
   ----add by dzg: 2015-9-25
   ----业务流程：插入申请表，插入流水，更新账户
   --- POS:outletCode  amount  admin transPassword（市场管理员）
   --- OMS 参数相同
   ----需要调用陈震存储过程
   /*************************************************************/
(
 --------------输入----------------

 p_org_code IN STRING, --机构编码
 p_amount   IN NUMBER, --充值金额
 p_admin_id IN NUMBER, --操作人员

 ---------出口参数---------
 c_flow_code  OUT STRING, --申请流水
 c_bef_amount OUT NUMBER, --充值前金额
 c_aft_amount OUT NUMBER, --充值后金额
 c_errorcode  OUT NUMBER, --错误编码
 c_errormesg  OUT STRING --错误原因

 ) IS

   v_count_temp NUMBER := 0; --临时变量
   v_org_name   varchar2(500) := ''; --站点名称
   v_org_accno  varchar2(50) := ''; --站点账户编号

BEGIN

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   v_count_temp := 0;

   /*----------- 数据校验   -----------------*/
   --编码不能为空
   IF ((p_org_code IS NULL) OR length(p_org_code) <= 0) THEN
      c_errorcode := 1;
      c_errormesg := error_msg.err_p_institutions_topup_1;
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
      c_errormesg := error_msg.err_p_institutions_topup_2;
      RETURN;
   END IF;

   --密码无效
   v_count_temp := 0;
   SELECT count(u.org_code)
     INTO v_count_temp
     FROM inf_orgs u
    WHERE u.org_code = p_org_code;

   IF v_count_temp <= 0 THEN
      c_errorcode := 3;
      c_errormesg := error_msg.err_p_institutions_topup_3;
      RETURN;
   END IF;

   --初始化

   select a.org_name, b.acc_no
     INTO v_org_name, v_org_accno
     from inf_orgs a
     left join acc_org_account b
       on a.org_code = b.org_code
    where a.org_code = p_org_code;

   --先生成编码
   c_flow_code := f_get_fund_charge_cash_seq();

   --插入资金流水相关信息
   p_org_fund_change(p_org_code,
                     eflow_type.charge,
                     p_amount,
                     0,
                     c_flow_code,
                     c_aft_amount,
                     v_count_temp);

   -- 计算之前金额
   c_bef_amount := c_aft_amount - p_amount;

   insert into fund_charge_center
      (fund_no,
       account_type,
       ao_code,
       ao_name,
       acc_no,
       OPER_AMOUNT,
       BE_ACCOUNT_BALANCE,
       AF_ACCOUNT_BALANCE,
       OPER_TIME,
       OPER_ADMIN)
   values
      (c_flow_code,
       eaccount_type.org,
       p_org_code,
       v_org_name,
       v_org_accno,
       p_amount,
       c_bef_amount,
       c_aft_amount,
       sysdate,
       p_admin_id);

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      c_errorcode := 1;
      c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
