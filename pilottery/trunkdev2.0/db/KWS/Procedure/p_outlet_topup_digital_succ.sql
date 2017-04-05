create or replace procedure p_outlet_topup_digital_succ
/****************************************************************/
   ------------------- 适用于站点充值（电子） -------------------
   ----站点充值成功
   ----add by Chen Zhen: 2017/3/21
   ----业务流程：修改日志表，插入申请表，插入流水，更新账户
   /*************************************************************/
(
 --------------输入----------------

 p_trans_no       in varchar2,          -- 电子交易流水号
 p_digital_flow   in varchar2,          -- 银行系统交易编号
 p_fee            in number,            -- 交易费用
 p_exchange_rate  in varchar2,          -- 汇率信息
 p_json_data      in varchar2,          -- 附加数据
 p_admin_id       in number,            -- 操作人员

 ---------出口参数---------
 c_balance        out number,           -- 账户余额
 c_errorcode      out number,           -- 错误编码
 c_errormesg      out string            -- 错误原因

 ) is

   v_agency       inf_agencys.agency_code%type;
   v_acc_no       acc_agency_account.acc_no%type;
   v_amount       fund_digital_translog.apply_amount%type;
   
   v_balance      number(28);
   v_frozen       number(28);
   
   v_flow_no      char(10);

begin

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   c_balance := 0;

   /*----------- 数据校验   -----------------*/
   --先生成编码
   v_flow_no := f_get_fund_charge_cash_seq();

   begin
     update fund_digital_translog
        set trans_fee = p_fee,
            ref_no = v_flow_no,
            digital_trans_status = edigital_trans_status.succ,
            digital_acc_flow = p_digital_flow,
            exchange_context = p_exchange_rate,
            res_time = sysdate,
            res_json_data = p_json_data
      where digital_trans_no = p_trans_no
        and digital_trans_type = eflow_type.charge
        and digital_trans_status <> edigital_trans_status.succ
        returning agency_code,acc_no,apply_amount
        into v_agency,v_acc_no,v_amount;
   exception
     when no_data_found then
       c_errorcode := 1;
       c_errormesg := error_msg.err_p_outlettopup_digital_suc;
       rollback;
       return;
   end;
   
   --插入资金流水相关信息
   p_agency_fund_change(v_agency,
                        eflow_type.charge,
                        v_amount,
                        0,
                        v_flow_no,
                        v_balance,
                        v_frozen);

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
      (v_flow_no,
       eaccount_type.agency,
       v_agency,
       f_get_agency_name(v_agency),
       v_acc_no,
       v_amount,
       v_balance - v_amount,
       v_balance,
       sysdate,
       p_admin_id);

   commit;

exception
   when others then
      rollback;
      c_errorcode := 1;
      c_errormesg := error_msg.err_common_1 || sqlerrm;

end;
