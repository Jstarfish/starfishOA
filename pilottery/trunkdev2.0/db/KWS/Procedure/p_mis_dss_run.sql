create or replace procedure p_mis_dss_run(
   p_settle_id NUMBER,
   p_is_maintance NUMBER default 0
) is
   v_desc varchar2(1000);
   v_rec_date date;
   v_rpt_day DATE;
begin
  SELECT settle_date
    INTO v_rpt_day
    FROM his_day_settle
   WHERE settle_id = p_settle_id;

  v_rec_date := sysdate;
  v_desc := 'MIS开始日结. SettleID ['||p_settle_id||'] Settle Target Date ['||to_char(v_rpt_day,'yyyy-mm-dd')||'] Start time: ['||to_char(v_rec_date, 'yyyy-mm-dd hh24:mi:ss')||']';
  p_mis_set_log(1,v_desc);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_00_prepare]';
  dbms_output.put_line(v_desc);
  p_mis_dss_00_prepare;

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_05_gen_winning]';
  dbms_output.put_line(v_desc);
  p_mis_dss_05_gen_winning(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_10_gen_abandon]';
  dbms_output.put_line(v_desc);
  p_mis_dss_10_gen_abandon(p_settle_id, p_is_maintance);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_13_gen_his_dict]';
  dbms_output.put_line(v_desc);
  p_mis_dss_13_gen_his_dict(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_20_gen_tmp_src]';
  dbms_output.put_line(v_desc);
  p_mis_dss_20_gen_tmp_src(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_30_gen_multi_issue]';
  dbms_output.put_line(v_desc);
  p_mis_dss_30_gen_multi_issue;

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_40_gen_fact]';
  dbms_output.put_line(v_desc);
  p_mis_dss_40_gen_fact(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_50_gen_rpt_3112]';
  dbms_output.put_line(v_desc);
  p_mis_dss_50_gen_rpt_3112(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_50_gen_rpt_3113]';
  dbms_output.put_line(v_desc);
  p_mis_dss_50_gen_rpt_3113(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_50_gen_rpt_3116]';
  dbms_output.put_line(v_desc);
  p_mis_dss_50_gen_rpt_3116(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_50_gen_rpt_3117]';
  dbms_output.put_line(v_desc);
  p_mis_dss_50_gen_rpt_3117(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_50_gen_rpt_3121]';
  dbms_output.put_line(v_desc);
  p_mis_dss_50_gen_rpt_3121(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_50_gen_rpt_3122]';
  dbms_output.put_line(v_desc);
  p_mis_dss_50_gen_rpt_3122(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_50_gen_rpt_3124]';
  dbms_output.put_line(v_desc);
  p_mis_dss_50_gen_rpt_3124(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_50_gen_rpt_3125]';
  dbms_output.put_line(v_desc);
  p_mis_dss_50_gen_rpt_3125(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_50_gen_rpt_aband]';
  dbms_output.put_line(v_desc);
  p_mis_dss_50_gen_rpt_aband(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_50_gen_rpt_ncp]';
  dbms_output.put_line(v_desc);
  p_mis_dss_50_gen_rpt_ncp(p_settle_id);

  v_desc := 'SETTLE_ID is '||p_settle_id||'调用[p_mis_dss_60_gen_rpt_merge_all]';
  dbms_output.put_line(v_desc);
  p_mis_dss_60_gen_rpt_merge_all(p_settle_id);

  p_mis_set_log(1,'MIS日结成功. 执行时长: [ '||trunc((sysdate-v_rec_date)*24*60*60)||'秒 ]');

exception
  when others then
    p_mis_set_log(1,'MIS日结失败. 停止在步骤 ['||v_desc||']. 执行时长: [ '||trunc((sysdate-v_rec_date)*24*60*60)||'秒 ] 失败原因: '||sqlerrm);
    dbms_output.put_line('MIS日结失败. 停止在步骤 ['||v_desc||']. 执行时长: [ '||trunc((sysdate-v_rec_date)*24*60*60)||'秒 ] 失败原因: '||sqlerrm);
end;
