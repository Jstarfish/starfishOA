CREATE OR REPLACE PROCEDURE p_withdraw_approve_mm
/****************************************************************/
   ------------------- 适用站点提现------------------
   ---- 站点审批，扣减管理员账户欠款
   ---- add by Chen Zhen: 2015-10-13
   /*************************************************************/
(
 --------------输入----------------

 p_fund_no  IN STRING, -- 提现申请编号

 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因

 ) IS

   v_agency_code varchar2(100); -- 销售站
   v_mm_code     number; -- 管理员编码
   v_wd_money    NUMBER; -- 提现金额
   v_count_temp1 NUMBER; -- 临时变量
   v_count_temp2 NUMBER; -- 临时变量

BEGIN

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- 数据校验   -----------------*/

   --申请编码不能为空
   IF ((p_fund_no IS NULL) OR length(p_fund_no) <= 0) THEN
      c_errorcode := 1;
      c_errormesg := error_msg.err_p_withdraw_approve_1;
      RETURN;
   END IF;

   --编码不存在或者状态无效（如已审批）
   begin
      SELECT AO_CODE, APPLY_AMOUNT, MARKET_ADMIN
        INTO v_agency_code, v_wd_money, v_mm_code
        FROM fund_withdraw
       WHERE fund_no = p_fund_no
         And apply_status = eapply_status.applyed;
   exception
      when no_data_found then
         c_errorcode := 2;
         c_errormesg := error_msg.err_p_withdraw_approve_2;
         RETURN;

   end;

   -- 扣减销售站余额
   p_agency_fund_change(v_agency_code,
                        eflow_type.withdraw,
                        v_wd_money,
                        0,
                        p_fund_no,
                        v_count_temp1,
                        v_count_temp2);

   -- 检查余额是否足够
   IF v_count_temp1 < 0 THEN

      update fund_withdraw
         set apply_check_time = sysdate,
             check_admin_id   = v_mm_code,
             apply_status     = eapply_status.resused,
             apply_memo       = 'Sorry, agency[' || v_agency_code || '] balance has been insufficient. [AUTO Apply]'
       where fund_no = p_fund_no;

      c_errorcode := 4;
      c_errormesg := error_msg.err_p_withdraw_approve_4;

      rollback;
      RETURN;
   END IF;

   --更新审批状态
   update fund_withdraw
      set apply_check_time = sysdate,
          check_admin_id   = v_mm_code,
          apply_status     = eapply_status.withdraw,
          apply_memo       = '[AUTO Apply]'
    where fund_no = p_fund_no;

   -- 更新市场管理员账户欠款金额
   p_mm_fund_change(v_mm_code, eflow_type.withdraw_for_agency, v_wd_money, p_fund_no, v_count_temp1);

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      c_errorcode := 1;
      c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
