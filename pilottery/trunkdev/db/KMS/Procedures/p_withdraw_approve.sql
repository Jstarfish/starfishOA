create or replace procedure p_withdraw_approve
/****************************************************************/
   ------------------- 适用财务提现订单财务审批------------------
   ---- 提现审批
   ---- add by dzg: 2015-10-13
   ---- modify 陈震 2015-12-10。 修复bug，去掉销售站余额检查功能
   ---- modify dzg  2016-01-21。 修改bug，增加计入销售员欠款
   ---- 后来发现需要使用申请人，因为管理平台申请时没有填写申请人
   /*************************************************************/
(
 --------------输入----------------

 p_fund_no  in string, --资金编号
 p_admin_id in number, --审批人
 p_result   in number, --审批结果 1 通过 2 拒绝
 p_remark   in string, --审批备注

 ---------出口参数---------
 c_errorcode out number, --错误编码
 c_errormesg out string --错误原因

 ) is

   v_count_temp  number := 0;                                              -- 临时变量
   v_org_code    varchar2(100) := '';                                      -- 机构编码
   v_org_type    number := 0;                                              -- 结构类型
   v_wd_money    number := 0;                                              -- 提现金额
   v_count_temp1 number := 0;                                              -- 临时变量
   v_count_temp2 number := 0;                                              -- 临时变量

   v_acc_no                char(12);                                       -- 账户编码
   v_credit_limit          number(28);                                     -- 信用额度
   v_balance               number(28);                                     -- 账户余额
   v_mm_id                 number:= 0;                                     -- 市场管理员

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   v_count_temp := 0;

   /*----------- 数据校验   -----------------*/

   -- 申请编码不能为空
   if ((p_fund_no is null) or length(p_fund_no) <= 0) then
      c_errorcode := 1;
      c_errormesg := error_msg.err_p_withdraw_approve_1;
      return;
   end if;

   -- 审批结果无效，输入参数不合法
   if not (p_result = 1 or p_result = 2) then
      c_errorcode := 3;
      c_errormesg := error_msg.err_p_withdraw_approve_3;
      return;
   end if;

   -- 编码不存在或者状态无效（如已审批）
   select count(u.fund_no)
     into v_count_temp
     from fund_withdraw u
    where u.fund_no = p_fund_no
      and u.apply_status = eapply_status.applyed;

   if v_count_temp <= 0 then
      c_errorcode := 2;
      c_errormesg := error_msg.err_p_withdraw_approve_2;
      return;
   end if;

   -- 审批不通过，直接处理，然后返回
   if p_result = 2 then
      update fund_withdraw
         set apply_check_time = sysdate,
             check_admin_id   = p_admin_id,
             apply_status     = eapply_status.resused,
             apply_memo       = p_remark
       where fund_no = p_fund_no;

   end if;

   -- 审批通过以后，接着处理后续数据
   if p_result = 1 then

      select w.ao_code, w.account_type, w.apply_amount,w.apply_admin
        into v_org_code, v_org_type, v_wd_money,v_mm_id
        from fund_withdraw w
       where w.fund_no = p_fund_no;
       

      --更新状态
      update fund_withdraw
         set apply_check_time = sysdate,
             check_admin_id   = p_admin_id,
             apply_status     = eapply_status.withdraw,
             apply_memo       = p_remark
       where fund_no = p_fund_no;

      --更新各种账户流水
      case
         when v_org_type = eaccount_type.org then
            p_org_fund_change(v_org_code,
                              eflow_type.withdraw,
                              v_wd_money,
                              0,
                              p_fund_no,
                              v_count_temp1,
                              v_count_temp2);

         when v_org_type = eaccount_type.agency then
            -- 更新余额
            update acc_agency_account
               set account_balance = account_balance - v_wd_money
             where agency_code = v_org_code
               and acc_type = eacc_type.main_account
               and acc_status = eacc_status.available
            returning
               acc_no,   credit_limit,   account_balance
            into
               v_acc_no, v_credit_limit, v_balance;
            if sql%rowcount = 0 then
               raise_application_error(-20001, dbtool.format_line(v_org_code) || error_msg.err_p_fund_change_3);            -- 未发现销售站的账户，或者账户状态不正确
            end if;

            insert into flow_agency
               (agency_fund_flow,      ref_no,    flow_type,           agency_code, acc_no,   change_amount, be_account_balance,     af_account_balance, be_frozen_balance, af_frozen_balance, frozen_amount)
            values
               (f_get_flow_agency_seq, p_fund_no, eflow_type.withdraw, v_org_code,  v_acc_no, v_wd_money,    v_balance + v_wd_money, v_balance,          0,                 0,                 0);
               
            -- 更新市场管理员账户欠款金额
            p_mm_fund_change(v_mm_id, eflow_type.withdraw_for_agency, v_wd_money, p_fund_no, v_count_temp);

      end case;
   end if;

   commit;

exception
   when others then
      rollback;
      c_errorcode := 1;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
