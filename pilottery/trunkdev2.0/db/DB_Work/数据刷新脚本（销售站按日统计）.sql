set serveroutput on
declare
   v_calc_date date;

begin
   delete his_org_fund_report;
   delete his_agency_fund;

   v_calc_date := to_date('2015-11-26', 'yyyy-mm-dd');
   for loop_days in 1 .. 10 loop
      dbms_output.put_line(to_char(v_calc_date,'yyyy-mm-dd'));

      insert into his_agency_fund
         (calc_date,
          agency_code,
          flow_type,
          amount,
          be_account_balance,
          af_account_balance)
         with last_day as
          (select agency_code, af_account_balance be_account_balance
             from his_agency_fund
            where calc_date = to_char(v_calc_date - 1, 'yyyy-mm-dd')
              and flow_type = 0),
         accu_day as
          (select agency_code, AF_ACCOUNT_BALANCE
             from flow_agency
            where (agency_code, AGENCY_FUND_FLOW) in
                  (select agency_code, max(AGENCY_FUND_FLOW) AGENCY_FUND_FLOW
                     from flow_agency
                    where trade_time >= trunc(v_calc_date)
                      and trade_time < trunc(v_calc_date) + 1
                    group by agency_code)
           ),this_day as (
           select agency_code, AF_ACCOUNT_BALANCE from accu_day
           union
           select agency_code, af_account_balance
             from his_agency_fund
            where calc_date = to_char(v_calc_date - 1, 'yyyy-mm-dd')
              and flow_type = 0
              and agency_code not in (select agency_code from accu_day)
          ),
         now_fund as
          (select agency_code, flow_type, sum(change_amount) as amount
             from flow_agency
            where trade_time >= trunc(v_calc_date)
              and trade_time < trunc(v_calc_date) + 1
            group by agency_code, flow_type),
         agency_balance as
          (select agency_code, be_account_balance, 0 as af_account_balance
             from last_day
           union all
           select agency_code, 0 as be_account_balance, af_account_balance
             from this_day),
         ab as
          (select agency_code,
                  sum(be_account_balance) be_account_balance,
                  sum(af_account_balance) af_account_balance
             from agency_balance
            group by agency_code)
         select to_char(v_calc_date, 'yyyy-mm-dd'),
                agency_code,
                flow_type,
                amount,
                0 be_account_balance,
                0 af_account_balance
           from now_fund
         union all
         select to_char(v_calc_date, 'yyyy-mm-dd'),
                agency_code,
                0,
                0,
                be_account_balance,
                af_account_balance
           from ab;
          
      v_calc_date := v_calc_date + 1;
      if v_calc_date = trunc(sysdate) then
         exit;
      end if;
      
   end loop;

   v_calc_date := to_date('2015-11-26', 'yyyy-mm-dd');
   for loop_days in 1 .. 10 loop
      dbms_output.put_line(to_char(v_calc_date,'yyyy-mm-dd'));

      insert into his_org_fund_report
         (calc_date,
          org_code,
          be_account_balance,
          charge,
          withdraw,
          sale,
          sale_comm,
          paid,
          pay_comm,
          rtv,
          rtv_comm,
          af_account_balance,
          incoming,
          pay_up)
         with base as
          (select org_code,
                  FLOW_TYPE,
                  sum(AMOUNT) as amount,
                  sum(BE_ACCOUNT_BALANCE) as BE_ACCOUNT_BALANCE,
                  sum(AF_ACCOUNT_BALANCE) as AF_ACCOUNT_BALANCE
             from his_agency_fund
             join inf_agencys
            using (agency_code)
            where CALC_DATE = to_char(v_calc_date, 'yyyy-mm-dd')
            group by org_code, FLOW_TYPE),
         fund as
          (select *
             from (select org_code, FLOW_TYPE, AMOUNT from base)
           pivot(sum(amount)
              for FLOW_TYPE in(1 as charge,
                              2 as withdraw,
                              5 as sale_comm,
                              6 as pay_comm,
                              7 as sale,
                              8 as paid,
                              11 as rtv,
                              13 as rtv_comm))),
         agency_ava as
          (select org_code, BE_ACCOUNT_BALANCE, AF_ACCOUNT_BALANCE
             from base
            where flow_type = 0),
         pre_detail as
          (select org_code,
                  BE_ACCOUNT_BALANCE,
                  nvl(charge, 0) charge,
                  nvl(withdraw, 0) withdraw,
                  nvl(sale, 0) sale,
                  nvl(sale_comm, 0) sale_comm,
                  nvl(paid, 0) paid,
                  nvl(pay_comm, 0) pay_comm,
                  nvl(rtv, 0) rtv,
                  nvl(rtv_comm, 0) rtv_comm,
                  AF_ACCOUNT_BALANCE
             from fund
             join agency_ava
            using (org_code))
         select to_char(v_calc_date, 'yyyy-mm-dd'),
                org_code,
                BE_ACCOUNT_BALANCE,
                charge,
                withdraw,
                sale,
                sale_comm,
                paid,
                pay_comm,
                rtv,
                rtv_comm,
                AF_ACCOUNT_BALANCE,
                nvl((sale - sale_comm - paid - pay_comm - rtv + rtv_comm), 0) incoming,
                (nvl((sale - sale_comm - paid - pay_comm - rtv + rtv_comm), 0) +
                AF_ACCOUNT_BALANCE - BE_ACCOUNT_BALANCE) pay_up
           from pre_detail;
          
      v_calc_date := v_calc_date + 1;
      if v_calc_date = trunc(sysdate) then
         exit;
      end if;
      
   end loop;

end;
/
