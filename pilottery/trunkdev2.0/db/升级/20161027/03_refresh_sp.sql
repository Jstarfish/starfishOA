set feedback off 

create or replace package dbtool is

  -- 设置数据库错误参数（初始化）
  procedure set_success (
    errcode in out number,
    errmesg in out string
  );

  -- 设置数据库错误参数（错误信息）
  procedure set_dberror
  (
    errcode in out number,
    errmesg in out string
  );

  -- 用法: select * from table(dbtool.strsplit('1,2,3,4,5'))
  function strsplit
  (
    p_value varchar2,
    p_split varchar2 := ','
  ) return tabletype
    pipelined;

  -- 输出“[value]”格式的字符串
  function format_line(p_value varchar2) return varchar2;

  -- 调试打印输出
  procedure p(p_value varchar2);

  -- 日期转字符串(yyyy-mm-dd)
  function d2s(p_value date, p_format varchar2 default 'yyyy-mm-dd') return varchar2;

  -- 字符串转日期(yyyy-mm-dd)
  function s2d(p_value varchar2, p_format varchar2 default 'yyyy-mm-dd') return date;

  -- 时间转字符串
  function t2s(p_value date) return varchar2;

  -- 字符串转时间
  function s2t(p_value varchar2) return date;

  -- 校验余额
  --function check_balance(p_value varchar2, p_key varchar2, p_check_code varchar2) return number;

  -- 生成校验码
  --function gen_check_code(p_value varchar2, p_key varchar2) return varchar2;

end;
/

create or replace package body dbtool is
  -- 设置数据库错误参数（初始化）
  procedure set_success
  (
    errcode in out number,
    errmesg in out string
  ) is
  begin
    errcode := 0;
    errmesg := 'success';
  end set_success;

  -- 设置数据库错误参数（错误信息）
  procedure set_dberror
  (
    errcode in out number,
    errmesg in out string
  ) is
  begin
    errcode := sqlcode;
    errmesg := sqlerrm;
  end set_dberror;

  function strsplit
  (
    p_value varchar2,
    p_split varchar2 := ','
  )
  -- 用法: select * from table(dbtool.strsplit('1,2,3,4,5'))
  return tabletype
    pipelined is
    v_idx       integer;
    v_str       varchar2(500);
    v_strs_last varchar2(4000) := p_value;

  begin
    v_strs_last := trim(v_strs_last);
    loop
       v_idx := instr(v_strs_last, p_split);
       v_idx := nvl(v_idx,0);
       exit when v_idx = 0;
       v_str       := substr(v_strs_last, 1, v_idx - 1);
       v_strs_last := substr(v_strs_last, v_idx + 1);
       pipe row(v_str);
    end loop;
    pipe row(v_strs_last);
    return;

  end strsplit;

  function format_line(p_value varchar2) return varchar2 is
  begin
    return '[' || nvl(p_value, 'null') || ']';
  end format_line;

  procedure p(p_value varchar2) is
  begin
   dbms_output.put_line(format_line(p_value));
  end p;

  -- 日期转字符串(yyyy-mm-dd)
  function d2s(
    p_value date,
    p_format varchar2 default 'yyyy-mm-dd'
  )
  return varchar2
  is
  begin
    return to_char(p_value, p_format);
  end d2s;

  -- 字符串转日期(yyyy-mm-dd)
  function s2d(
    p_value varchar2,
    p_format varchar2 default 'yyyy-mm-dd'
  )
  return date
  is
  begin
    return to_date(p_value, p_format);
  end s2d;

  -- 时间转字符串(yyyy-mm-dd hh24:mi:ss)
  function t2s(
    p_value date
  )
  return varchar2
  is
  begin
    return d2s(p_value, 'yyyy-mm-dd hh24:mi:ss');
  end t2s;

  -- 字符串转时间(yyyy-mm-dd hh24:mi:ss)
  function s2t(
    p_value varchar2
  )
  return date
  is
  begin
    return s2d(p_value, 'yyyy-mm-dd hh24:mi:ss');
  end s2t;

  -- 校验余额
  --function check_balance(p_value varchar2, p_key varchar2, p_check_code varchar2) return number is
  --begin
  --  if gen_check_code(p_value, p_key) = p_check_code then
  --    return 1;
  --  else
  --    return 0;
  --  end if;
  --end check_balance;

  -- 生成校验码
  --function gen_check_code(p_value varchar2, p_key varchar2) return varchar2 is
  --  l_mac_val  raw(4000);
  --  l_key      raw(4000);
  --  l_mac_algo pls_integer;
  --  l_in       raw(4000);
  --  l_ret      varchar2(4000);
  --begin
  --  l_mac_algo := dbms_crypto.hmac_sh1;
  --  l_in       := utl_i18n.string_to_raw(p_value, 'al32utf8');
  --  l_key      := utl_i18n.string_to_raw(p_key, 'al32utf8');
  --  l_mac_val  := dbms_crypto.mac(src => l_in,
  --                                typ => l_mac_algo,
  --                                key => l_key);
  --  l_ret      := rawtohex(l_mac_val);
  --  return l_ret;
  --end gen_check_code;

begin
   null;
end;
/

prompt 正在建立[FUNCTION -> f_get_agency_area.sql ]...... 
------------------------------------------
--  Changed function f_get_agency_area  --
------------------------------------------
create or replace function f_get_agency_area(
  p_applyflow_sell in string --销售请流水

) return string
  result_cache
  relies_on(inf_agencys)

is
  /*-----------    变量定义     -----------------*/
  v_ret_code string(8) := ''; -- 返回值

begin

  select area_code
    into v_ret_code
    from his_sellticket join inf_agencys on his_sellticket.agency_code=inf_agencys.agency_code
	and applyflow_sell=p_applyflow_sell;

  return v_ret_code;

end;
/
prompt 正在建立[PROCEDURE -> p_mis_dss_05_gen_winning.sql ]...... 
--------------------------------------------------
--  Changed procedure p_mis_dss_05_gen_winning  --
--------------------------------------------------
create or replace procedure p_mis_dss_05_gen_winning
  (p_settle_id    number,
   p_is_maintance NUMBER default 0)
is
  start_seq number(10);
  end_seq number(10);
  v_set_day date;

begin
  select win_seq, settle_date into end_seq, v_set_day from his_day_settle where settle_id=p_settle_id;
  select max(win_seq) into start_seq from his_day_settle where settle_id<p_settle_id;

  -- 考虑到多期票的问题，
  -- 1、获取今天开奖的期次列表
  -- 2、根据开奖期次获知对应的销售票（his_selltickt中的end_issue）,获知这些票的 请求流水
  -- 3、根据请求流水，将中奖票入库。

  insert into tmp_src_win
    (applyflow_sell,                  winning_time,
     terminal_code,                   teller_code,                      agency_code,
     game_code,                       issue_number,                     is_big_prize,
     ticket_amount,
     win_amount_without_tax,          win_amount,           tax_amount,            win_bets,
     hd_win_amount_without_tax,       hd_win_amount,        hd_tax_amount,         hd_win_bets,
     ld_win_amount_without_tax,       ld_win_amount,        ld_tax_amount,         ld_win_bets)
  with
    -- 当天发布的中奖期次
    winning_issue as (
      select game_code, issue_number from iss_game_issue where real_reward_time >= v_set_day and real_reward_time < v_set_day + 1),
    -- 中奖期次对应的销售票
    sell as (
      select applyflow_sell, terminal_code, teller_code, agency_code, issue_number, game_code, ticket_amount
        from his_sellticket
       where (game_code, end_issue) in (select game_code, issue_number from winning_issue)),
    -- 销售票对应的中奖明细
    win as (
      select applyflow_sell,            max(winnning_time) as winnning_time,
             sum(winningamounttax)                                            as win_amount,                                -- 税前奖金
             sum(winningamount)                                               as win_amount_without_tax,                    -- 税后奖金
             sum(taxamount)                                                   as tax_amount,                                -- 缴税额
             sum(prize_count)                                                 as win_bets,                                  -- 中奖注数
             sum(case when is_hd_prize = 1 then winningamounttax else 0 end)  as hd_win_amount,                             -- 税前奖金（高等奖）
             sum(case when is_hd_prize = 1 then winningamount    else 0 end)  as hd_win_amount_without_tax,                 -- 税后奖金（高等奖）
             sum(case when is_hd_prize = 1 then taxamount        else 0 end)  as hd_tax_amount,                             -- 缴税额  （高等奖）
             sum(case when is_hd_prize = 1 then prize_count      else 0 end)  as hd_win_bets,                               -- 中奖注数（高等奖）
             sum(case when is_hd_prize = 0 then winningamounttax else 0 end)  as ld_win_amount,                             -- 税前奖金（低等奖）
             sum(case when is_hd_prize = 0 then winningamount    else 0 end)  as ld_win_amount_without_tax,                 -- 税后奖金（低等奖）
             sum(case when is_hd_prize = 0 then taxamount        else 0 end)  as ld_tax_amount,                             -- 缴税额  （低等奖）
             sum(case when is_hd_prize = 0 then prize_count      else 0 end)  as ld_win_bets                                -- 中奖注数（低等奖）
        from his_win_ticket_detail
       where applyflow_sell in (select applyflow_sell from sell)
       group by applyflow_sell)
  select applyflow_sell,     win.winnning_time,
         terminal_code,      teller_code,           agency_code,
         game_code,          sell.issue_number,
         (case
              when win_amount_without_tax >= limit_big_prize then 1
              when win_amount_without_tax < limit_big_prize then 0
              else null
          end),
         sell.ticket_amount,
         win.win_amount_without_tax,             win.win_amount,             win.tax_amount,            win.win_bets,
         win.hd_win_amount_without_tax,          win.hd_win_amount,          win.hd_tax_amount,         win.hd_win_bets,
         win.ld_win_amount_without_tax,          win.ld_win_amount,          win.ld_tax_amount,         win.ld_win_bets
    from win
    join sell using(applyflow_sell)
    join gp_static using(game_code);
  
  
  if p_is_maintance <> 0 then
    delete from his_win_ticket where winning_time >= v_set_day and winning_time < v_set_day + 1;
  end if;
  
  insert into his_win_ticket select * from tmp_src_win;

  commit;

end;
/
prompt 正在建立[PROCEDURE -> p_mis_trans_win_data.sql ]...... 
----------------------------------------------
--  Changed procedure p_mis_trans_win_data  --
----------------------------------------------
CREATE OR REPLACE PROCEDURE p_mis_trans_win_data
/***************************************************************
   ------------------- 中奖明细数据入库 -------------------
   ************************************************************/
(
 --------------输入----------------
 p_game_code      IN NUMBER, -- 游戏编码
 p_issue_number   IN NUMBER, -- 期次编码
 p_data_file_name IN STRING, -- 数据文件名称

 ---------出口参数---------
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述

 ) Authid Current_User IS
   v_sql        VARCHAR2(1000); --执行的SQL
   v_count      INTEGER; --记录行数
   v_table_name VARCHAR2(100); --外部表名称
   v_file_name  VARCHAR2(100); --数据文件名称

   v_reward_time DATE; --开奖时间
   v_cnt         number(1); -- 是否存在记录

BEGIN
   -- 初始化数据
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   -- 检查 iss_prize 表是否有数据
   select count(*)
     into v_cnt
     from dual
    where exists(select 1 from iss_prize where game_code=p_game_code and issue_number=p_issue_number);

   if v_cnt = 0 then
      c_errorcode := 1;
      c_errormesg := 'iss_prize is no data. game_code ['||p_game_code||'] issue_number ['||p_issue_number||']';
      return;
   end if;

   -- 拼接外部表名称
   v_table_name := 'ext_win_data_' || p_game_code || '_' || p_issue_number;

   -- 看看之前是不是建立过外部表，如果有，就删除
   SELECT COUNT(*)
     INTO v_count
     FROM user_tables
    WHERE table_name = upper(v_table_name);
   IF v_count = 1 THEN
      v_sql := 'drop table ' || v_table_name;
      EXECUTE IMMEDIATE v_sql;
   END IF;

   -- 去掉数据文件名的路径
   v_file_name := substr(p_data_file_name, instr(p_data_file_name, '/', -1) + 1);

   -- 通过动态SQL建立外部表，准备导入数据
   v_sql := 'create table ' || v_table_name || ' (';
   v_sql := v_sql || '    APPLYFLOW_SELL  CHAR(24),';
   v_sql := v_sql || '    SALE_AGENCY NUMBER(10),';
   v_sql := v_sql || '    PRIZE_LEVEL NUMBER(3),';
   v_sql := v_sql || '    PRIZE_COUNT NUMBER(16),';
   v_sql := v_sql || '    WINNINGAMOUNTTAX NUMBER(16),';
   v_sql := v_sql || '    WINNINGAMOUNT NUMBER(16),';
   v_sql := v_sql || '    TAXAMOUNT NUMBER(16))';
   v_sql := v_sql || 'ORGANIZATION EXTERNAL ';
   v_sql := v_sql || '  (TYPE ORACLE_LOADER ';
   v_sql := v_sql || '   DEFAULT DIRECTORY windir';
   v_sql := v_sql || '   ACCESS PARAMETERS ';
   v_sql := v_sql || '      (RECORDS DELIMITED BY NEWLINE logfile bkdir:''ext_table_%a_%p.log''';
   v_sql := v_sql || '       FIELDS (APPLYFLOW_SELL  CHAR(24),';
   v_sql := v_sql || '               SALE_AGENCY CHAR(10),';
   v_sql := v_sql || '               PRIZE_LEVEL CHAR(3),';
   v_sql := v_sql || '               PRIZE_COUNT CHAR(16),';
   v_sql := v_sql || '               WINNINGAMOUNTTAX CHAR(16),';
   v_sql := v_sql || '               WINNINGAMOUNT CHAR(16),';
   v_sql := v_sql || '               TAXAMOUNT CHAR(16)';
   v_sql := v_sql || '              )';
   v_sql := v_sql || '      )';
   v_sql := v_sql || '   LOCATION (''' || v_file_name || ''')';
   v_sql := v_sql || '  )';
   EXECUTE IMMEDIATE v_sql;

   -- 清除一下现有数据
   DELETE his_win_ticket_detail
    WHERE game_code = p_game_code
      AND issue_number = p_issue_number;
   COMMIT;
   DELETE his_win_ticket
    WHERE game_code = p_game_code
      AND issue_number = p_issue_number;
   COMMIT;

   -- 获得插入所需要的必备数据（开奖时间）
   SELECT real_reward_time
     INTO v_reward_time
     FROM iss_game_issue
    WHERE game_code = p_game_code
      AND issue_number = p_issue_number;

   -- 拼SQL，插入数据库，先插入deltail表
   v_sql := 'begin INSERT ';
   v_sql := v_sql || '   INTO his_win_ticket_detail';
   v_sql := v_sql || '      (applyflow_sell,';
   v_sql := v_sql || '       winnning_time,';
   v_sql := v_sql || '       game_code,';
   v_sql := v_sql || '       issue_number,';
   v_sql := v_sql || '       sale_agency,';
   v_sql := v_sql || '       prize_level,';
   v_sql := v_sql || '       prize_count,';
   v_sql := v_sql || '       is_hd_prize,';
   v_sql := v_sql || '       winningamounttax,';
   v_sql := v_sql || '       winningamount,';
   v_sql := v_sql || '       taxamount, win_seq)';
   v_sql := v_sql || '      SELECT applyflow_sell,';
   v_sql := v_sql || '             to_date(''' || to_char(v_reward_time, 'yyyy-mm-dd') || ''',''yyyy-mm-dd''),';
   v_sql := v_sql || '             ' || p_game_code || ',';
   v_sql := v_sql || '             ' || p_issue_number || ',';
   v_sql := v_sql || '             lpad(to_char(sale_agency),8,''0''),';
   v_sql := v_sql || '             prize_level,';
   v_sql := v_sql || '             prize_count,';
   v_sql := v_sql || '             (SELECT is_hd_prize';
   v_sql := v_sql || '                FROM iss_prize';
   v_sql := v_sql || '               WHERE game_code = ' || p_game_code;
   v_sql := v_sql || '                 AND issue_number = ' || p_issue_number;
   v_sql := v_sql || '                 and prize_level = df.prize_level),';
   v_sql := v_sql || '             winningamounttax,';
   v_sql := v_sql || '             winningamount,';
   v_sql := v_sql || '             taxamount, f_get_his_win_seq';
   v_sql := v_sql || '        FROM ' || v_table_name || ' df; commit; end;';
   EXECUTE IMMEDIATE v_sql;

   -- 删除外部表
   v_sql := 'drop table ' || v_table_name;
   EXECUTE IMMEDIATE v_sql;

   -- 统计期次中奖表
   DELETE mis_agency_win_stat
    WHERE game_code = p_game_code
      AND issue_number = p_issue_number;

   -- 需要在开奖公告之后执行
   INSERT INTO mis_agency_win_stat
      (agency_code, game_code, issue_number, prize_level, prize_name, is_hd_prize, winning_count, single_bet_reward)
      SELECT agency_code, game_code, issue_number, prize_level, prize_name, is_hd_prize, winning_count, single_bet_reward
        FROM (SELECT sale_agency AS agency_code, game_code, issue_number, prize_level, SUM(prize_count) AS winning_count
                FROM his_win_ticket_detail
               WHERE game_code = p_game_code
                 AND issue_number = p_issue_number
               GROUP BY sale_agency, game_code, issue_number, prize_level) win
        JOIN iss_prize
       USING (game_code, issue_number, prize_level);
   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      rollback;
      c_errorcode := 1;
      c_errormesg := 'Import winning data is failed. GAME_CODE ['||p_game_code||'] ISSUE_NUMBER ['||p_issue_number||'] Errmsg : ' || sqlerrm;
      return;
END;
/
create or replace procedure p_mm_inv_check
/****************************************************************/
   ------------------- 市场管理员库存盘点 -------------------
   ---- add by 陈震: 2015-12-08
   ----   输入一个彩票数组，确定出市场管理员的库存情况（以本为单位），返回两个数组。
   ----   1、显示彩票不在这个管理员手中的；
   ----   2、应该在管理员库存，但是未扫描的彩票

   ---- modify by 陈震: 2016-10-13
   ----   修改盘点 结果为是否一致。1=一致，0=不一致

   /*************************************************************/
(
 --------------输入----------------
  p_oper                               in number,                             -- 市场管理员
  p_array_lotterys                     in type_mm_check_lottery_list,         -- 输入的彩票对象

  ---------出口参数---------
  c_array_lotterys                     out type_mm_check_lottery_list,        -- 输出的彩票对象
  c_inv_tickets                        out number,                            -- 管理员库存彩票数量
  c_check_tickets                      out number,                            -- 本次盘点中，属于管理员的彩票数量
  c_diff_tickets                       out number,                            -- 未盘点的管理员彩票数量
  c_scan_tickets                       out number,                            -- 本次扫描数量
  c_errorcode                          out number,                            -- 错误编码
  c_errormesg                          out string                             -- 错误原因

 ) is

   v_tmp_lotterys                      type_mm_check_lottery_list;            -- 库存彩票对象
   v_out_lotterys                      type_mm_check_lottery_list;            -- 临时彩票对象
   v_s1_lotterys                       type_mm_check_lottery_list;            -- 临时彩票对象
   v_s2_lotterys                       type_mm_check_lottery_list;            -- 临时彩票对象

   v_cp_no                             char(10);

begin

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  c_inv_tickets := 0;
  c_check_tickets := 0;
  c_diff_tickets := 0;

  /*----------- 数据校验   -----------------*/
  -- 校验入口参数是否正确，对应的数据记录是否存在
  if not f_check_admin(p_oper) then
    c_errorcode := 1;
    c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
    return;
  end if;

  /*----------- 业务逻辑   -----------------*/
  /********************************************************************************************************************************************************************/
  -- 获取管理员所有彩票对象（本）
  select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, (ticket_no_end - ticket_no_start + 1), 0)
    bulk collect into v_tmp_lotterys
    from wh_ticket_package
   where status = 21
     and current_warehouse = p_oper;

  -- 生成管理员库存数量
  select sum(tickets)
    into c_inv_tickets
    from table(v_tmp_lotterys);
  c_inv_tickets := nvl(c_inv_tickets, 0);

  -- 生成本次扫描数量
  c_scan_tickets := p_array_lotterys.count;

  /********************************************************************************************************************************************************************/
  -- 看看输入的彩票中，有多少本是在库存管理员手中的.统计交集的票数量，为盘点数量
  select sum(src.tickets)
    into c_check_tickets
    from table(p_array_lotterys) dest
    join table(v_tmp_lotterys) src
   using (plan_code, batch_no, package_no);
  c_check_tickets := nvl(c_check_tickets, 0);

  -- 本次盘点后，管理员有多少票没有被盘点
  c_diff_tickets := nvl(c_inv_tickets,0) - nvl(c_check_tickets, 0);

  /********************************************************************************************************************************************************************/
  -- 获取未扫描的票
  select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, 0, 2)
   bulk collect into v_s2_lotterys
   from (
       select plan_code, batch_no, package_no from table(v_tmp_lotterys)
       minus
       select plan_code, batch_no, package_no from table(p_array_lotterys));

  -- 显示不在管理员手中的票
  select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, 0, 1)
   bulk collect into v_s1_lotterys
   from (
       select plan_code, batch_no, package_no from table(p_array_lotterys)
       minus
       select plan_code, batch_no, package_no from table(v_tmp_lotterys));

  -- 合并结果
  select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, tickets, status)
   bulk collect into v_out_lotterys
   from (
       select plan_code, batch_no, package_no, tickets, status from table(v_s1_lotterys)
       union all
       select plan_code, batch_no, package_no, tickets, status from table(v_s2_lotterys));

  c_array_lotterys := v_out_lotterys;

  -- 插入数据库
  v_cp_no := f_get_wh_check_point_seq;

  insert into wh_mm_check
    (cp_no,              manager_id,           result,
     inv_tickets,        check_tickets,        diff_tickets,
     scan_tickets,       cp_date)
  values
    (v_cp_no,            p_oper,               (case when c_diff_tickets = 0 then 1 else 0 end ),
     c_inv_tickets,      c_check_tickets,      c_diff_tickets,
     c_scan_tickets,     sysdate);

  if c_diff_tickets <> 0 then
    forall i in 1 .. c_array_lotterys.count
      insert into wh_mm_check_detail
        (cp_detail_no,                      cp_no,                        manager_id,
         plan_code,                         batch_no,                     valid_number,
         trunk_no,                          box_no,                       package_no,
         tickets,                           status)
      values
        (f_get_wh_check_point_seq,          v_cp_no,                      p_oper,
         c_array_lotterys(i).plan_code,     c_array_lotterys(i).batch_no, c_array_lotterys(i).valid_number,
         c_array_lotterys(i).trunk_no,      c_array_lotterys(i).box_no,   c_array_lotterys(i).package_no,
         c_array_lotterys(i).tickets,       c_array_lotterys(i).status);

  end if;

  commit;

exception
  when others then
    c_errorcode := 100;
    c_errormesg := error_msg.err_common_1 || sqlerrm;
    rollback;
end;
/
prompt 正在建立[PROCEDURE -> p_set_tds_issue_draw_notice.sql ]...... 
-----------------------------------------------------
--  Changed procedure p_set_tds_issue_draw_notice  --
-----------------------------------------------------
create or replace procedure p_set_tds_issue_draw_notice
/*****************************************************************/
   ----------- 生成 TDS json开奖公告 ---------------
   ----- created by chen zhen @ 2016-04-18
/*****************************************************************/

(
   p_game_code    in number, --游戏编码
   p_issue_number in number, --期次编码

   c_errorcode out number,   --业务错误编码
   c_errormesg out string    --错误信息描述
) is

   all_json_obj json;
   second_json  json;
   draw_json    json;
   draw_json_list json_list;

   v_rank1_json json_list;
   v_rank2_json json_list;
   v_rank3_json json_list;
   v_rank4_json json_list;
   v_rank5_json json_list;
   v_rank_json  json_list;

   -- 临时的json和json list变量
   tempobj json;
   tempobj_list json_list;

   v_draw_code            varchar2(200);
   v_winning_amount       number(28);
   v_sale_amount          number(28);
   v_issue_number         iss_game_issue.issue_number%type;

   -- 最近100期的开奖号码
   type draw_record is record(issue_number number(28), final_draw_number varchar2(200));
   type draw_collect is table of draw_record;
   v_array_draw_code draw_collect;

   v_loop_i number(2);

   -- 开奖结果，每个小球对应的数字
   draw_number number(3);

   -- 临时clob对象，用于入库
   temp_clob clob;

begin
  -- 初始化变量
  c_errorcode := 0;
  all_json_obj := json();
  second_json := json();
  v_array_draw_code := draw_collect();
  draw_json := json();
  draw_json_list := json_list();

  -- 临时的json和json list变量
  tempobj := json();
  tempobj_list := json_list();

  v_rank1_json := json_list();
  v_rank2_json := json_list();
  v_rank3_json := json_list();
  v_rank4_json := json_list();
  v_rank5_json := json_list();
  v_rank_json := json_list();
  
  -- TDS动画，只做了11选5的，其他的没有做
  if p_game_code <> 12 then
    return;
  end if;

  -- 11选5，所有要先开五个坑
  for v_loop_i in 1 .. 11 loop
     v_rank1_json.append(0);
     v_rank2_json.append(0);
     v_rank3_json.append(0);
     v_rank4_json.append(0);
     v_rank5_json.append(0);
     v_rank_json.append(0);
  end loop;

  all_json_obj.put('cmd', 8193);
  all_json_obj.put('game', p_game_code);
  all_json_obj.put('issue', p_issue_number);

  -- 开奖号码
  begin
     select issue_number,final_draw_number, issue_sale_amount, winning_amount
       into v_issue_number, v_draw_code, v_sale_amount, v_winning_amount
       from iss_game_issue
      where game_code=p_game_code
        and issue_number=p_issue_number;
  exception
     when no_data_found then
     c_errorcode := 1;
     c_errormesg := error_msg.err_p_set_json_issue_draw_n_1;               -- 游戏期次不存在，或者未开奖
     return;
  end;

  if v_winning_amount is null then
     c_errorcode := 10;
     c_errormesg := error_msg.err_p_set_json_issue_draw_n_1;               -- 游戏期次不存在，或者未开奖
     return;
  end if;

  all_json_obj.put('draw_code', v_draw_code);

  -- 销售和中奖金额
  second_json.put('sale_amount', v_sale_amount);
  second_json.put('win_amount', v_winning_amount);

  -- 奖级奖金表
  for tab in (select prize_level, prize_name, prize_count*single_bet_reward amount, prize_count from iss_prize where game_code=p_game_code and issue_number=v_issue_number order by prize_level) loop
     tempobj := json();
     tempobj.put('name', tab.prize_name);
     tempobj.put('amount', tab.amount);
     tempobj.put('bets', tab.prize_count);
     tempobj_list.append(tempobj.to_json_value);
  end loop;

  second_json.put('prize_level',tempobj_list.to_json_value);
  all_json_obj.put('win_info', second_json.to_json_value);

  -- 中大奖的销售站
  -- modify by ChenZhen @2016-06-17 修改SQL。倒排单票中奖金额
  tempobj_list := json_list();
  for tab in (
              with sa as
               (select agency_code, address from inf_agencys),
              single_ticket_reward as (
                select applyflow_sell, sale_agency, sum(winningamount) amount
                  from his_win_ticket_detail hwt
                 where game_code = p_game_code
                   and issue_number= v_issue_number
                 group by applyflow_sell, sale_agency
         order by amount desc),
              top_10_win as
               (select sale_agency agency_code, amount from single_ticket_reward where rownum <= 10)
              select agency_code, amount, address
                from top_10_win
                join sa
               using(agency_code) order by amount desc
             ) loop
     tempobj := json();
     tempobj.put('agency_code', tab.agency_code);
     tempobj.put('win_amount', tab.amount);
     tempobj.put('agency_adderss',tab.address);
     tempobj_list.append(tempobj.to_json_value);
  end loop;
  all_json_obj.put('big_win', tempobj_list.to_json_value);



  -- 先获取最近100期的开奖号码
  with tab as (
     select issue_number, final_draw_number
       from iss_game_issue
      where game_code=p_game_code
        and final_draw_number is not null
        -- 如果期次编号为0，就把最近的开奖号码发回去
        and issue_number <= v_issue_number
      order by issue_number desc)
  select issue_number, final_draw_number bulk collect into v_array_draw_code
    from tab
   where rownum <= 100;
  dbms_output.put_line(v_array_draw_code.count);

  -- 最近20期分析
  second_json := json();
  for v_loop_i in 1 .. 40 loop
     exit when v_loop_i > v_array_draw_code.count;
     draw_json.put('issue', v_array_draw_code(v_loop_i).issue_number);
     draw_json.put('drawcode', v_array_draw_code(v_loop_i).final_draw_number);
     draw_json_list.append(draw_json.to_json_value);

     -- 每个坑都走一遍
     v_draw_code := replace(v_array_draw_code(v_loop_i).final_draw_number, '+', ',');
     for tab in (select rownum,column_value from table(dbtool.strsplit(v_draw_code))) loop
        draw_number := tab.column_value;
        case tab.rownum
           when 1 then v_rank1_json.replace(draw_number, v_rank1_json.get(draw_number).get_number + 1);
           when 2 then v_rank2_json.replace(draw_number, v_rank2_json.get(draw_number).get_number + 1);
           when 3 then v_rank3_json.replace(draw_number, v_rank3_json.get(draw_number).get_number + 1);
           when 4 then v_rank4_json.replace(draw_number, v_rank4_json.get(draw_number).get_number + 1);
           when 5 then v_rank5_json.replace(draw_number, v_rank5_json.get(draw_number).get_number + 1);
        end case;
        v_rank_json.replace(draw_number, v_rank_json.get(draw_number).get_number + 1);
     end loop;

     exit when v_array_draw_code.count = v_loop_i;
  end loop;
  second_json.put('draw_code', draw_json_list.to_json_value);
  second_json.put('rank_1st', v_rank1_json.to_json_value);
  second_json.put('rank_2st', v_rank2_json.to_json_value);
  second_json.put('rank_3st', v_rank3_json.to_json_value);
  second_json.put('rank_4st', v_rank4_json.to_json_value);
  second_json.put('rank_5st', v_rank5_json.to_json_value);
  second_json.put('rank_total', v_rank_json.to_json_value);

  all_json_obj.put('last_issue_40', second_json.to_json_value);

  -- 冷热号分析（20、50、100期）
  v_rank_json := json_list();
  for v_loop_i in 1 .. 11 loop
     v_rank_json.append(0);
  end loop;
  for v_loop_i in 1 .. 20 loop
     -- 每个坑都走一遍
     exit when v_loop_i > v_array_draw_code.count;
     v_draw_code := replace(v_array_draw_code(v_loop_i).final_draw_number, '+', ',');
     for tab in (select rownum,column_value from table(dbtool.strsplit(v_draw_code))) loop
        draw_number := tab.column_value;
        v_rank_json.replace(draw_number, v_rank_json.get(draw_number).get_number + 1);
     end loop;

     exit when v_array_draw_code.count = v_loop_i;
  end loop;
  all_json_obj.put('hot_cool_20', v_rank_json.to_json_value);

  v_rank_json := json_list();
  for v_loop_i in 1 .. 11 loop
     v_rank_json.append(0);
  end loop;
  for v_loop_i in 1 .. 50 loop
     -- 每个坑都走一遍
     exit when v_loop_i > v_array_draw_code.count;
     v_draw_code := replace(v_array_draw_code(v_loop_i).final_draw_number, '+', ',');
     for tab in (select rownum,column_value from table(dbtool.strsplit(v_draw_code))) loop
        draw_number := tab.column_value;
        v_rank_json.replace(draw_number, v_rank_json.get(draw_number).get_number + 1);
     end loop;

     exit when v_array_draw_code.count = v_loop_i;
  end loop;
  all_json_obj.put('hot_cool_50', v_rank_json.to_json_value);

  v_rank_json := json_list();
  for v_loop_i in 1 .. 11 loop
     v_rank_json.append(0);
  end loop;
  for v_loop_i in 1 .. 100 loop
     -- 每个坑都走一遍
     exit when v_loop_i > v_array_draw_code.count;
     v_draw_code := replace(v_array_draw_code(v_loop_i).final_draw_number, '+', ',');
     for tab in (select rownum,column_value from table(dbtool.strsplit(v_draw_code))) loop
        draw_number := tab.column_value;
        v_rank_json.replace(draw_number, v_rank_json.get(draw_number).get_number + 1);
     end loop;

     exit when v_array_draw_code.count = v_loop_i;
  end loop;
  all_json_obj.put('hot_cool_100', v_rank_json.to_json_value);

  if f_get_sys_param('1105') = '0' then
    all_json_obj.put('roll_text_1', nvl(f_get_sys_param('1101'), ''));
    all_json_obj.put('roll_text_2', nvl(f_get_sys_param('1102'), ''));
    all_json_obj.put('roll_text_3', nvl(f_get_sys_param('1103'), ''));

  else
    -- 7天内中大奖的销售站
    all_json_obj.put('roll_text_1', '');
    all_json_obj.put('roll_text_2', '');
    all_json_obj.put('roll_text_3', '');

    -- modify by kwx @2016-07-05 7天内中大奖前三名大奖信息
    for tab in (with
                sa as (
                  select agency_code, address from inf_agencys),
                single_ticket_reward as (
                  select applyflow_sell, sale_agency, issue_number, sum(winningamount) amount
                    from his_win_ticket_detail hwt
                   where game_code = 12
                     and winnning_time >= sysdate - 1
                   group by applyflow_sell, sale_agency, issue_number
                   order by amount desc),
                top_10_win as
                 (select sale_agency agency_code, amount,issue_number from single_ticket_reward where rownum <= 3)
                select rownum, agency_code, amount, address, issue_number
                  from top_10_win
                  join sa
                 using(agency_code) order by amount desc
               ) loop
      all_json_obj.put('roll_text_' || to_char(tab.rownum), to_char(tab.agency_code) || ' ' || to_char(tab.address) || ', ' || to_char(tab.issue_number) || ':' || to_char(tab.amount));
    end loop;
  end if;

  all_json_obj.put('errorCode', 5000);

  temp_clob := empty_clob();
  dbms_lob.createtemporary(temp_clob, true);
  all_json_obj.to_clob(temp_clob);
  update iss_game_issue_xml set json_winning_brodcast = temp_clob where game_code = p_game_code and issue_number = p_issue_number;
  dbms_lob.freetemporary(temp_clob);

  commit;

exception
  when others then
    rollback;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

end;
/
prompt 正在建立[PROCEDURE -> p_set_term_online.sql ]...... 
-------------------------------------------
--  Changed procedure p_set_term_online  --
-------------------------------------------
create or replace procedure p_set_term_online
/*******************************************************************************/
  ----- 记录终端机在线时长 add by Chen Zhen @ 2016-07-21
  ----- 请求JSON:
  ----- 
  ----- {
  ----- "type":1002,
  ----- "term_code":"0101000101",
  ----- "current_time":1469066100,
  ----- "online_seconds":1200
  ----- }
  ----- 
  ----- term_code 字符串类型，
  ----- current_time：数字类型，表示当前系统时间的时间戳
  ----- online_seconds：数字类型，表示到curr_time 为止，此终端机已经在线多少秒（累计值）
  ----- 
  ----- 响应JSON
  ----- {
  ----- "type":1002,
  ----- "rc":0
  ----- }

  /*******************************************************************************/
(
  p_json       in string,  --入口json
  c_json       out string, --出口json
  c_errorcode  out number, --错误编码
  c_errormesg  out string  --错误原因

)
is
  v_term            saler_terminal.terminal_code%type;
  v_host_stamp      sys_terminal_online_time.HOST_BEGIN_TIME_STAMP%type;
  v_online_time     sys_terminal_online_time.online_time%type;
  v_trade_type      number(10);

  v_input_json      json;
  v_out_json        json;

  v_ret_string      varchar2(4000);

begin
  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  v_input_json := json(p_json);
  v_out_json := json();

  -- 获取输入值
  v_trade_type := v_input_json.get('type').get_number;
  v_term := v_input_json.get('term_code').get_string;
  v_host_stamp := v_input_json.get('begin_time').get_number;
  v_online_time := v_input_json.get('online_seconds').get_number;

  if v_trade_type <> 1002 then
    c_errorcode := 1;
    c_errormesg := error_msg.err_comm_trade_type_error || 'Want->1002 Real->' || v_trade_type;             -- 报文输入有错
    return;
  end if;

  insert into SYS_TERMINAL_ONLINE_TIME (
              TERMINAL_CODE, HOST_BEGIN_TIME_STAMP, ONLINE_TIME,    RECORD_TIME, RECORD_DAY) 
       values (
              v_term,        v_host_stamp,          v_online_time,  sysdate,     to_char(sysdate, 'yyyy-mm-dd')
              );

  v_out_json.put('type', v_trade_type);
  v_out_json.put('rc', 0);
  c_json := v_out_json.to_char;

  commit;
exception
  when others then
    rollback;
    c_errorcode := 1;
    c_errormesg := error_msg.err_common_1 || sqlerrm;
end;
/

prompt 正在建立[PROCEDURE -> p_time_gen_by_day.sql ]...... 
-------------------------------------------
--  Changed procedure p_time_gen_by_day  --
-------------------------------------------
create or replace procedure p_time_gen_by_day (
   p_curr_date       date        default sysdate,
   p_maintance_mod   number      default 0
)
/****************************************************************/
   ------------------- 仅用于统计数据（每日0点执行） -------------------
   ---- add by 陈震: 2015/10/14
   /*************************************************************/
is
   v_temp1        number(28);
   v_temp2        number(28);

   v_max_org_pay_flow char(24);

begin

   if p_maintance_mod = 0 then
      -- 活动加送的佣金
      if to_char(sysdate, 'dd') = '01' then
        p_time_lot_promotion;
      end if;

      -- 库存信息
      insert into his_lottery_inventory
         (calc_date,
          plan_code,
          batch_no,
          reward_group,
          status,
          warehouse,
          tickets,
          amount)
         with total as
          (select to_char(p_curr_date - 1,'yyyy-mm-dd') calc_date,
                  plan_code,
                  batch_no,
                  reward_group,
                  tab.status,
                  nvl(current_warehouse, '[null]') warehouse,
                  sum(tickets_every_pack) tickets
             from wh_ticket_package tab
             join game_batch_import_detail
            using (plan_code, batch_no)
            group by plan_code,
                     batch_no,
                     reward_group,
                     tab.status,
                     nvl(current_warehouse, '[null]'))
         select calc_date,
                plan_code,
                batch_no,
                reward_group,
                status,
                to_char(warehouse),
                tickets,
                tickets * ticket_amount
           from total
           join game_plans
          using (plan_code);

      commit;

      -- 站点资金日结
      insert into his_agency_fund (calc_date, agency_code, flow_type, amount, be_account_balance, af_account_balance)
      with last_day as
       (select agency_code, af_account_balance be_account_balance
          from his_agency_fund
         where calc_date = to_char(p_curr_date - 2, 'yyyy-mm-dd')
           and flow_type = 0),
      this_day as
       (select agency_code, account_balance af_account_balance
          from acc_agency_account
         where acc_type = 1),
      now_fund as
       (select agency_code, flow_type, sum(change_amount) as amount
          from flow_agency
         where trade_time >= trunc(p_curr_date - 1)
           and trade_time < trunc(p_curr_date)
         group by agency_code, flow_type),
      agency_balance as
       (select agency_code, be_account_balance, 0 as af_account_balance from last_day
         union all
        select agency_code, 0 as be_account_balance, af_account_balance from this_day),
      ab as
       (select agency_code, sum(be_account_balance) be_account_balance, sum(af_account_balance) af_account_balance from agency_balance group by agency_code)
      select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
             agency_code,
             flow_type,
             amount,
             0 be_account_balance,
             0 af_account_balance
        from now_fund
      union all
      select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
             agency_code,
             0,
             0,
             be_account_balance,
             af_account_balance
        from ab;

      commit;
   end if;

   -- 站点库存日结
   insert into his_agency_inv
     (calc_date, agency_code, plan_code, oper_type, amount, tickets)
   with base as (
   -- 站点退货
   select SEND_WH agency_code,plan_code,10 inv_type,sum(AMOUNT) amount, sum(TICKETS) tickets
     from WH_GOODS_ISSUE mm join WH_GOODS_ISSUE_detail detail using(SGI_NO)
    where detail.ISSUE_TYPE = 4
      and ISSUE_END_TIME >= trunc(p_curr_date) - 1
      and ISSUE_END_TIME < trunc(p_curr_date)
   group by SEND_WH,plan_code
   union all
   -- 站点收货
   select RECEIVE_WH,plan_code,20 inv_type,sum(AMOUNT) amount, sum(TICKETS) tickets
    from WH_GOODS_RECEIPT mm join WH_GOODS_RECEIPT_detail detail using(sgr_no)
    where detail.RECEIPT_TYPE = 4
      and RECEIPT_END_TIME >= trunc(p_curr_date) - 1
      and RECEIPT_END_TIME < trunc(p_curr_date)
   group by RECEIVE_WH,plan_code
   union all
   -- 站点期初
   select WAREHOUSE,plan_code,88 inv_type,sum(AMOUNT) amount, sum(TICKETS) tickets
     from HIS_LOTTERY_INVENTORY
    where STATUS = 31
      and CALC_DATE = to_char(trunc(p_curr_date) - 2,'yyyy-mm-dd')
   group by WAREHOUSE,plan_code
   union all
   -- 站点期末
   select WAREHOUSE,plan_code,99 inv_type,sum(AMOUNT) amount, sum(TICKETS) tickets
     from HIS_LOTTERY_INVENTORY
    where STATUS = 31
      and CALC_DATE = to_char(trunc(p_curr_date) - 1,'yyyy-mm-dd')
   group by WAREHOUSE,plan_code)
   select to_char(trunc(p_curr_date) - 1,'yyyy-mm-dd'),agency_code, plan_code, inv_type, amount, tickets from base;

   commit;


    -- 销量按部门分方案监控
   insert into his_sale_org (calc_date, org_code, plan_code, sale_amount, sale_comm, cancel_amount, cancel_comm, paid_amount, paid_comm, incoming)
   with time_con as
    (select (trunc(p_curr_date) - 1) s_time, trunc(p_curr_date) e_time from dual),
   sale_stat as
    (select org_code, plan_code, sum(sale_amount) amount, sum(comm_amount) comm
       from flow_sale, time_con
      where sale_time >= s_time
        and sale_time < e_time
      group by org_code, plan_code),
   cancel_stat as
    (select org_code, plan_code, sum(sale_amount) amount, sum(comm_amount) comm
       from flow_cancel, time_con
      where cancel_time >= s_time
        and cancel_time < e_time
      group by org_code, plan_code),
   pay_stat as
    (select f_get_flow_pay_org(pay_flow) org_code, plan_code, nvl(sum(pay_amount),0) amount, nvl(sum(pay_comm),0) comm
       from flow_pay, time_con
      where pay_time >= s_time
        and pay_time < e_time
        and is_center_paid = 3
      group by f_get_flow_pay_org(pay_flow), plan_code),
  /* --modify by kwx 2016-06-01 flow_pay里不记录代理商，而flow_pay_org_comm里不记录分公司,因此在做中心兑奖统计时需要将代理商和分公司的合并起来统计 */
    pay_center_stat as
    (select org_code, plan_code, nvl(sum(pay_amount),0) amount, nvl(sum(org_pay_comm),0) comm
       from flow_pay_org_comm, time_con
      where pay_time >= s_time
        and pay_time < e_time
        and is_center_paid = 1
    and f_get_org_type(org_code)=2
      group by org_code, plan_code
    union all
    select f_get_flow_pay_org(pay_flow) org_code, plan_code, nvl(sum(pay_amount),0) amount, nvl(sum(pay_comm),0) comm
       from flow_pay, time_con
      where pay_time >= s_time
        and pay_time < e_time
        and is_center_paid = 1
    and f_get_org_type(f_get_flow_pay_org(pay_flow))=1
      group by f_get_flow_pay_org(pay_flow), plan_code),
    lot_sale_stat as
      (select SALE_AREA org_code, game_code, sum(sale_amount) amount, sum(sale_commission) comm
         from sub_sell, time_con
        where SALE_DATE >= to_char(s_time,'yyyy-mm-dd')
          and SALE_DATE < to_char(e_time,'yyyy-mm-dd')
        group by SALE_AREA, game_code),
  /* --modify by kwx 2016-06-01 目前电脑票没有销售站票退票,但是中心退票会给销售站退佣金,因此暂时统计销售站退票的金额为0 */
     lot_cancel_stat as
      (select SALE_AREA org_code, game_code, 0 amount, sum(CANCEL_COMMISSION) comm
         from sub_cancel, inf_orgs, time_con
        where CANCEL_DATE >= to_char(s_time,'yyyy-mm-dd')
          and CANCEL_DATE < to_char(e_time,'yyyy-mm-dd')
      and SALE_AREA = org_code
          and org_type = 1
        group by SALE_AREA, game_code),
     lot_pay_stat as
      (select PAY_AREA org_code, game_code, sum(PAY_AMOUNT) amount, sum(PAY_COMMISSION) comm
         from sub_pay, time_con
        where PAY_AGENCY is not null and PAY_DATE >= to_char(s_time,'yyyy-mm-dd')
          and PAY_DATE < to_char(e_time,'yyyy-mm-dd')
        group by PAY_AREA, game_code),
      lot_pay_center_stat as
      (select org_code,plan_code,sum(amount) amount,sum(comm) comm from (
      select org_code,
              (case when flow_type=36 then (select game_code from his_sellticket where APPLYFLOW_sell=(select APPLYFLOW_sell from his_payticket where APPLYFLOW_PAY=flow_org.ref_no))
                    when flow_type=37 then (select game_code from his_sellticket where APPLYFLOW_sell=(select APPLYFLOW_sell from his_payticket where APPLYFLOW_PAY=flow_org.ref_no))
              end) plan_code,
              (case when flow_type=37 then change_amount else 0 end) amount,(case when flow_type=36 then change_amount else 0 end) comm
           from flow_org , time_con
       where flow_type in (36,37)
          and trade_time >= s_time
          and trade_time < e_time) group by plan_code,org_code),
      lot_cancel_center_stat as
       (select org_code,plan_code,sum(amount) amount,sum(comm) comm from (
         select org_code,
               (case when flow_type=35 then (select game_code from his_sellticket where APPLYFLOW_sell=(select APPLYFLOW_sell from his_cancelticket where APPLYFLOW_CANCEL=flow_org.ref_no))
                     when flow_type=38 then (select game_code from his_sellticket where APPLYFLOW_sell=(select APPLYFLOW_sell from his_cancelticket where APPLYFLOW_CANCEL=flow_org.ref_no))
                end) plan_code,
               (case when flow_type=38 then change_amount else 0 end) amount,(case when flow_type=35 then change_amount else 0 end) comm
           from flow_org , time_con
        where flow_type in (35,38)
           and trade_time >= s_time
           and trade_time < e_time)
    group by plan_code,org_code),
     pre_detail as
    (select * from  (select org_code, plan_code, 1 ftype, amount, comm from sale_stat
                     union all
                     select org_code, plan_code, 2 ftype, amount, comm from cancel_stat
                     union all
                     select org_code, plan_code, 3 ftype, amount, comm from pay_stat
                     union all
                     select org_code, plan_code, 4 ftype, amount, comm from pay_center_stat
                     union all
                     select org_code, to_char(game_code), 5 ftype, amount, comm from lot_sale_stat
                     union all
                     select org_code, to_char(game_code), 6 ftype, amount, comm from lot_cancel_stat
                     union all
                     select org_code, to_char(game_code), 7 ftype, amount, comm from lot_pay_stat
                     union all
                     select org_code, to_char(plan_code), 8 ftype, amount, comm from lot_pay_center_stat
                     union all
                     select org_code, to_char(plan_code), 9 ftype, amount, comm from lot_cancel_center_stat)
      pivot (sum(amount) as amount, sum(comm) as comm for ftype in (1 as sale, 2 as cancel, 3 as pay, 4 as pay_center, 5 as lot_sale, 6 as lot_cancel, 7 as lot_pay, 8 as lot_pay_center, 9 as lot_cancel_center))
    ),
   no_null as (
   select to_char(time_con.s_time, 'yyyy-mm-dd') calc_date,
          org_code,
          plan_code,
          nvl(sale_amount, 0) sale_amount,
          nvl(sale_comm, 0) sale_comm,
          nvl(pay_amount, 0) pay_amount,
          nvl(pay_comm, 0) pay_comm,
          nvl(pay_center_amount, 0) pay_center_amount,
          nvl(pay_center_comm, 0) pay_center_comm,
          nvl(cancel_amount, 0) cancel_amount,
          nvl(cancel_comm, 0) cancel_comm,
          nvl(lot_sale_amount, 0) lot_sale_amount,
          nvl(lot_sale_comm, 0) lot_sale_comm,
          nvl(lot_pay_amount, 0) lot_pay_amount,
          nvl(lot_pay_comm, 0) lot_pay_comm,
          nvl(lot_pay_center_amount, 0) lot_pay_center_amount,
          nvl(lot_pay_center_comm, 0) lot_pay_center_comm,
          nvl(lot_cancel_amount, 0) lot_cancel_amount,
          nvl(lot_cancel_comm, 0) lot_cancel_comm,
      nvl(lot_cancel_center_amount,0) lot_cancel_center_amount,
      nvl(lot_cancel_center_comm,0) lot_cancel_center_comm
     from pre_detail, time_con)
     select calc_date,
       org_code,
       plan_code,
       (sale_amount + lot_sale_amount) as sale_amount,
       (sale_comm + lot_sale_comm) as sale_comm,
       (cancel_amount + lot_cancel_amount + lot_cancel_center_amount) as cancel_amount,
       (cancel_comm + lot_cancel_comm + lot_cancel_center_comm) as cancel_comm,
       (pay_amount + pay_center_amount + lot_pay_amount + lot_pay_center_amount) as pay_amount,
       (pay_comm + pay_center_comm + lot_pay_comm + lot_pay_center_comm) as pay_comm,
          (sale_amount + lot_sale_amount - sale_comm - lot_sale_comm - pay_amount - lot_pay_amount - pay_comm  - lot_pay_comm - pay_center_amount - lot_pay_center_amount - pay_center_comm - lot_pay_center_comm - cancel_amount - lot_cancel_amount + cancel_comm + lot_cancel_comm - lot_cancel_center_amount + lot_cancel_center_comm) incoming
     from no_null;

   commit;

   -- 3.17.1.1  部门资金报表（institution fund reports）
   insert into his_org_fund_report
      (calc_date,       org_code,
       -- 通用
       be_account_balance,  af_account_balance,     charge,    withdraw,     incoming,  pay_up,
       -- 即开票
       sale,                sale_comm,              paid,      pay_comm,     rtv,       rtv_comm,     center_pay,     center_pay_comm,
       -- 电脑票
       lot_sale,            lot_sale_comm,          lot_paid,  lot_pay_comm, lot_rtv,   lot_rtv_comm, lot_center_pay, lot_center_pay_comm,  lot_center_rtv, lot_center_rtv_comm
       )
   with base as
    (select org_code,
            flow_type,
            sum(amount) as amount,
            sum(be_account_balance) as be_account_balance,
            sum(af_account_balance) as af_account_balance
       from his_agency_fund
       join inf_agencys
      using (agency_code)
      where calc_date = to_char(p_curr_date - 1, 'yyyy-mm-dd')
      group by org_code, flow_type),
   center_pay as
    (select f_get_flow_pay_org(pay_flow) org_code, 24 flow_type, sum(pay_amount) amount
       from flow_pay
      where pay_time >= trunc(p_curr_date) - 1
        and pay_time < trunc(p_curr_date)
        and is_center_paid = 1
      group by f_get_flow_pay_org(pay_flow)),
   center_pay_comm as
    (select org_code, flow_type, sum(change_amount) amount
       from flow_org
      where trade_time >= trunc(p_curr_date) - 1
        and trade_time < trunc(p_curr_date)
        and flow_type in (23,35,36,37,38)
      group by org_code, flow_type),
   agency_balance as
    (select * from (select org_code, be_account_balance, af_account_balance
       from base
      where flow_type = 0)
      unpivot (amount for flow_type in (be_account_balance as 88, af_account_balance as 99))),
   fund as
    (select *
       from (select org_code, flow_type, amount from base
             union all
             select org_code, flow_type, amount from center_pay_comm
             union all
             select org_code, flow_type, amount from agency_balance
             union all
             select org_code, flow_type, amount from center_pay) pivot(sum(amount) for flow_type in(1 as charge,
                                                                   2  as withdraw,
                                                                   5  as sale_comm,
                                                                   6  as pay_comm,
                                                                   7  as sale,
                                                                   8  as paid,
                                                                   11 as rtv,
                                                                   13 as rtv_comm,
                                                                   24 as center_pay,
                                                                   23 as center_pay_comm,
                                                                   45 as lot_sale,
                                                                   43 as lot_sale_comm,
                                                                   41 as lot_paid,
                                                                   44 as lot_pay_comm,
                                                                   42 as lot_rtv,
                                                                   47 as lot_rtv_comm,
                                                                   37 as lot_center_pay,
                                                                   36 as lot_center_pay_comm,
                                                                   38 as lot_center_rtv,
                                                                   35 as lot_center_rtv_comm,
                                                                   88 as be,
                                                                   99 as af))),
   pre_detail as
    (select org_code,
            nvl(be, 0) be_account_balance,
            nvl(charge, 0) charge,
            nvl(withdraw, 0) withdraw,
            nvl(sale, 0) sale,
            nvl(sale_comm, 0) sale_comm,
            nvl(paid, 0) paid,
            nvl(pay_comm, 0) pay_comm,
            nvl(rtv, 0) rtv,
            nvl(rtv_comm, 0) rtv_comm,
            nvl(center_pay, 0) center_pay,
            nvl(center_pay_comm, 0) center_pay_comm,
            nvl(lot_sale, 0) lot_sale,
            nvl(lot_sale_comm, 0) lot_sale_comm,
            nvl(lot_paid, 0) lot_paid,
            nvl(lot_pay_comm, 0) lot_pay_comm,
            nvl(lot_rtv, 0) lot_rtv,
            nvl(lot_rtv_comm, 0) lot_rtv_comm,
            nvl(lot_center_pay, 0) lot_center_pay,
            nvl(lot_center_pay_comm, 0) lot_center_pay_comm,
            nvl(lot_center_rtv, 0) lot_center_rtv,
            (case 2 when (select org_type from inf_orgs where org_code=fund.org_code) then (nvl(lot_center_rtv_comm, 0) - nvl(lot_rtv_comm, 0))  else nvl(lot_center_rtv_comm, 0) end) lot_center_rtv_comm,
            nvl(af, 0) af_account_balance
       from fund),
   will_write as
   (select org_code,
           -- 通用
           be_account_balance, af_account_balance,          charge,          withdraw,
           -- 销售金额-销售佣金-兑奖-兑奖佣金-中心兑奖-中心兑奖佣金+退货佣金-退货金额 -中心退票+中心退票佣金
           (sale - sale_comm - paid - pay_comm - center_pay - center_pay_comm + rtv_comm - rtv
            + lot_sale - lot_sale_comm - lot_paid - lot_pay_comm - lot_center_pay - lot_center_pay_comm - lot_rtv + lot_rtv_comm
            - lot_center_rtv + lot_center_rtv_comm) incoming,
           (charge - withdraw - center_pay - center_pay_comm - lot_center_pay - lot_center_pay_comm  - lot_rtv - lot_rtv_comm - lot_center_rtv - lot_center_rtv_comm) pay_up,
           -- 即开票
           sale,                sale_comm,              paid,      pay_comm,     rtv,       rtv_comm,     center_pay,     center_pay_comm,
           -- 电脑票
           lot_sale,            lot_sale_comm,          lot_paid,  lot_pay_comm, lot_rtv,   lot_rtv_comm, lot_center_pay, lot_center_pay_comm, lot_center_rtv,lot_center_rtv_comm
      from pre_detail)
   select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
          org_code,
          nvl(be_account_balance , 0),   nvl(af_account_balance , 0),   nvl(charge , 0),      nvl(withdraw , 0),          nvl(incoming , 0),    nvl(pay_up , 0),
          nvl(sale , 0),                 nvl(sale_comm , 0),            nvl(paid , 0),        nvl(pay_comm , 0),          nvl(rtv , 0),         nvl(rtv_comm , 0),      nvl(center_pay , 0),     nvl(center_pay_comm , 0),
          nvl(lot_sale , 0),             nvl(lot_sale_comm , 0),        nvl(lot_paid , 0),    nvl(lot_pay_comm , 0),      nvl(lot_rtv , 0),     nvl(lot_rtv_comm , 0),  nvl(lot_center_pay , 0), nvl(lot_center_pay_comm , 0),   nvl(lot_center_rtv , 0),   nvl(lot_center_rtv_comm , 0)
     from will_write right join inf_orgs using (org_code);

    commit;

    if p_maintance_mod = 0 then
       -- 管理员资金日结
       insert into HIS_MM_FUND (calc_date, MARKET_ADMIN, flow_type, amount, be_account_balance, af_account_balance)
         with last_day as
          (select MARKET_ADMIN, af_account_balance be_account_balance
             from his_mm_fund
            where calc_date = to_char(p_curr_date - 2, 'yyyy-mm-dd')
              and flow_type = 0),
         this_day as
          (select MARKET_ADMIN, account_balance af_account_balance
             from acc_mm_account
            where acc_type = 1),
         mm_balance as
          (select MARKET_ADMIN, be_account_balance, 0 as af_account_balance
             from last_day
           union all
           select MARKET_ADMIN, 0 as be_account_balance, af_account_balance
             from this_day),
         mb as
          (select MARKET_ADMIN,
                  sum(be_account_balance) be_account_balance,
                  sum(af_account_balance) af_account_balance
             from mm_balance
            group by MARKET_ADMIN),
         now_fund as
          (select MARKET_ADMIN, flow_type, sum(change_amount) as amount
             from flow_market_manager
            where trade_time >= trunc(p_curr_date - 1)
              and trade_time < trunc(p_curr_date)
            group by MARKET_ADMIN, flow_type)
         select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
                MARKET_ADMIN,
                flow_type,
                amount,
                0 be_account_balance,
                0 af_account_balance
           from now_fund
         union all
         select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
                MARKET_ADMIN,
                0,
                0,
                be_account_balance,
                af_account_balance
           from mb;

      commit;
   end if;

   -- 管理员库存日结
   insert into HIS_MM_INVENTORY (CALC_DATE, MARKET_ADMIN, PLAN_CODE, OPEN_INV, CLOSE_INV, GOT_TICKETS, SALED_TICKETS, CANCELED_TICKETS, RETURN_TICKETS, BROKEN_TICKETS)
      with
      -- 期初
      open_inv as
       (select WAREHOUSE MARKET_ADMIN, PLAN_CODE, sum(TICKETS) open_INV
          from HIS_LOTTERY_INVENTORY
         where CALC_DATE = to_char(trunc(p_curr_date) - 2, 'yyyy-mm-dd')
           and status = 21
         group by WAREHOUSE, PLAN_CODE),
      -- 期末
      close_inv as
       (select WAREHOUSE MARKET_ADMIN, PLAN_CODE, sum(TICKETS) CLOSE_INV
          from HIS_LOTTERY_INVENTORY
         where CALC_DATE = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
           and status = 21
         group by WAREHOUSE, PLAN_CODE),
      -- 收货
      got as
       (select apply_admin, plan_code, sum(detail.tickets) TICKETS
          from SALE_DELIVERY_ORDER mm
          join wh_goods_issue_detail detail
            on (mm.do_no = detail.ref_no)
         where status = 4
           and OUT_DATE >= trunc(p_curr_date - 1)
           and OUT_DATE < trunc(p_curr_date)
         group by apply_admin, plan_code),
      -- 销售
      saled as
       (select AR_ADMIN, plan_code, sum(detail.TICKETS) TICKETS
          from SALE_AGENCY_RECEIPT mm
          join wh_goods_receipt_detail detail
            on (mm.AR_NO = detail.ref_no)
         where AR_DATE >= trunc(p_curr_date - 1)
           and AR_DATE < trunc(p_curr_date)
         group by AR_ADMIN, plan_code),
      -- 退货
      canceled as
       (select AI_MM_ADMIN, plan_code, sum(detail.TICKETS) TICKETS
          from SALE_AGENCY_RETURN mm
          join wh_goods_issue_detail detail
            on (mm.AI_NO = detail.ref_no)
         where Ai_DATE >= trunc(p_curr_date - 1)
           and Ai_DATE < trunc(p_curr_date)
         group by AI_MM_ADMIN, plan_code),
      -- 还货
      returned as
       (select MARKET_MANAGER_ADMIN, plan_code, sum(detail.TICKETS) TICKETS
          from SALE_RETURN_RECODER mm
          join wh_goods_receipt_detail detail
            on (mm.RETURN_NO = detail.ref_no)
         where status = 6
           and RECEIVE_DATE >= trunc(p_curr_date - 1)
           and RECEIVE_DATE < trunc(p_curr_date)
         group by MARKET_MANAGER_ADMIN, plan_code),
      -- 损毁
      broken_detail as
       (select BROKEN_NO,
               plan_code,
               PACKAGES * (select TICKETS_EVERY_PACK
                             from GAME_BATCH_IMPORT_DETAIL
                            where plan_code = tt.plan_code
                              and batch_no = tt.batch_no) tickets
          from WH_BROKEN_RECODER_DETAIL tt),
      broken as
       (select APPLY_ADMIN, plan_code, sum(TICKETS) TICKETS
          from WH_BROKEN_RECODER
          join broken_detail
         using (BROKEN_NO)
         where APPLY_DATE >= trunc(p_curr_date - 1)
           and APPLY_DATE < trunc(p_curr_date)
         group by APPLY_ADMIN, plan_code),
      total_detail as
       (select apply_admin MARKET_ADMIN,
               plan_code,
               0           as open_inv,
               0           as CLOSE_INV,
               TICKETS     GOT_TICKETS,
               0           as SALED_TICKETS,
               0           as canceled_tickets,
               0           as RETURN_TICKETS,
               0           as BROKEN_TICKETS
          from got
        union all
        select AR_ADMIN  MARKET_ADMIN,
               plan_code,
               0         as open_inv,
               0         as CLOSE_INV,
               0         as GOT_TICKETS,
               TICKETS   as SALED_TICKETS,
               0         as canceled_tickets,
               0         as RETURN_TICKETS,
               0         as BROKEN_TICKETS
          from saled
        union all
        select AI_MM_ADMIN MARKET_ADMIN,
               plan_code,
               0           as open_inv,
               0           as CLOSE_INV,
               0           as GOT_TICKETS,
               0           as SALED_TICKETS,
               tickets     as canceled_tickets,
               0           as RETURN_TICKETS,
               0           as BROKEN_TICKETS
          from canceled
        union all
        select MARKET_MANAGER_ADMIN MARKET_ADMIN,
               plan_code,
               0                    as open_inv,
               0                    as CLOSE_INV,
               0                    as GOT_TICKETS,
               0                    as SALED_TICKETS,
               0                    as canceled_tickets,
               TICKETS              as RETURN_TICKETS,
               0                    as BROKEN_TICKETS
          from returned
        union all
        select APPLY_ADMIN MARKET_ADMIN,
               plan_code,
               0           as open_inv,
               0           as CLOSE_INV,
               0           as GOT_TICKETS,
               0           as SALED_TICKETS,
               0           as canceled_tickets,
               0           as RETURN_TICKETS,
               TICKETS     as BROKEN_TICKETS
          from broken
        union all
        select to_number(MARKET_ADMIN) MARKET_ADMIN,
               PLAN_CODE,
               open_inv,
               0 as CLOSE_INV,
               0 as GOT_TICKETS,
               0 as SALED_TICKETS,
               0 as canceled_tickets,
               0 as RETURN_TICKETS,
               0 as BROKEN_TICKETS
          from open_inv
        union all
        select to_number(MARKET_ADMIN) MARKET_ADMIN,
               PLAN_CODE,
               0 as open_inv,
               CLOSE_INV,
               0 as GOT_TICKETS,
               0 as SALED_TICKETS,
               0 as canceled_tickets,
               0 as RETURN_TICKETS,
               0 as BROKEN_TICKETS
          from close_inv),
      total_sum as
       (select to_char(p_curr_date - 1, 'yyyy-mm-dd'),
               MARKET_ADMIN,
               PLAN_CODE,
               sum(open_inv) as open_inv,
               sum(CLOSE_INV) as CLOSE_INV,
               sum(GOT_TICKETS) GOT_TICKETS,
               sum(SALED_TICKETS) as SALED_TICKETS,
               sum(canceled_tickets) as canceled_tickets,
               sum(RETURN_TICKETS) as RETURN_TICKETS,
               sum(BROKEN_TICKETS) as BROKEN_TICKETS
          from total_detail
         group by MARKET_ADMIN, PLAN_CODE)
      -- 限制人员为市场管理员
      select * from total_sum where exists(select 1 from INF_MARKET_ADMIN where MARKET_ADMIN = total_sum.MARKET_ADMIN);

   commit;

   -- 3.17.1.4  部门应缴款报表（Institution Payable Report）
   insert into his_org_fund
     (calc_date, org_code, charge, withdraw, center_paid, center_paid_comm, pay_up)
   with base as
    (select org_code, FLOW_TYPE, sum(AMOUNT) as amount
       from his_agency_fund
       join inf_agencys
      using (agency_code)
      where CALC_DATE = to_char(p_curr_date - 1, 'yyyy-mm-dd')
        and FLOW_TYPE in (1, 2)
        and org_code in (select org_code from inf_orgs where ORG_TYPE = 1)
      group by org_code, FLOW_TYPE),
   center_pay as
    (select org_code, sum(change_amount) amount
       from flow_org
      where TRADE_TIME >= trunc(p_curr_date) - 1
        and TRADE_TIME < trunc(p_curr_date)
        and FLOW_TYPE = eflow_type.org_center_pay
      group by org_code),
   center_pay_comm as
    (select org_code, sum(change_amount) amount
       from flow_org
      where TRADE_TIME >= trunc(p_curr_date) - 1
        and TRADE_TIME < trunc(p_curr_date)
        and FLOW_TYPE = eflow_type.org_center_pay_comm
      group by org_code),
   fund as
    (select *
       from (select org_code, FLOW_TYPE, AMOUNT from base
             union all
             select org_code, 8 FLOW_TYPE, AMOUNT from center_pay
             union all
             select org_code, 21 FLOW_TYPE, AMOUNT from center_pay_comm
            ) pivot(sum(amount) for FLOW_TYPE in(1 as charge, 2 as withdraw, 8 as paid, 21 as paid_comm)))
   select to_char(p_curr_date - 1, 'yyyy-mm-dd') CALC_DATE,
          org_code,nvl(charge, 0) charge,
          nvl(withdraw, 0) withdraw,
          nvl(paid, 0) CENTER_PAID,
          nvl(paid_comm, 0) center_paid_comm,
          (nvl(charge, 0) - nvl(withdraw, 0) - nvl(paid, 0) + nvl(paid_comm, 0)) pay_up
     from inf_orgs left join fund using (org_code);

   commit;

   -- 部门库存日结
   insert into HIS_ORG_INV_REPORT (calc_date, org_code, oper_type, plan_code, amount, tickets)
   with base as (
      -- 调拨出库、站点退货
      select SEND_ORG org_code,wgid.ISSUE_TYPE do_type ,plan_code,sum(amount) amount, sum(tickets) tickets
        from WH_GOODS_ISSUE_DETAIL wgid
        join WH_GOODS_ISSUE wgi
       using (SGI_NO)
       where ISSUE_END_TIME >= trunc(p_curr_date) - 1
         and ISSUE_END_TIME < trunc(p_curr_date)
         and wgid.ISSUE_TYPE in (1,4)
         group by SEND_ORG,wgid.ISSUE_TYPE,plan_code
      union all
      -- 调拨入库，取计划入库数量（需要先找到调拨单，然后找到调拨单对应的出库单，获取实际出库明细）
      select wri.RECEIVE_ORG org_code, 12 do_type,plan_code,sum(wgid.amount) amount, sum(wgid.tickets) tickets
        from WH_GOODS_ISSUE_DETAIL wgid
        join SALE_TRANSFER_BILL stb
          on (wgid.REF_NO = stb.STB_NO)
        join WH_GOODS_receipt wri
          on (wri.REF_NO = stb.STB_NO)
       where receipt_END_TIME >= trunc(p_curr_date) - 1
         and receipt_END_TIME < trunc(p_curr_date)
         and (wri.receipt_TYPE = 2 or (wri.receipt_TYPE = 1 and wri.RECEIVE_ORG = '00'))
         group by wri.RECEIVE_ORG,wri.receipt_TYPE + 10,plan_code
      union all
      -- 站点入库销售
      select RECEIVE_ORG org_code,wgid.receipt_TYPE + 10 do_type,plan_code,sum(amount) amount, sum(tickets) tickets
        from WH_GOODS_receipt_DETAIL wgid
        join WH_GOODS_receipt wgi
       using (SGR_NO)
       where receipt_END_TIME >= trunc(p_curr_date) - 1
         and receipt_END_TIME < trunc(p_curr_date)
         and wgid.receipt_TYPE = 4
         group by RECEIVE_ORG,wgid.receipt_TYPE + 10,plan_code
      union all
      -- 损毁
      select f_get_admin_org(APPLY_ADMIN) org_code, 20 do_type,PLAN_CODE,
             sum(amount) amount, sum(WH_BROKEN_RECODER_DETAIL.packages) * 100
        from WH_BROKEN_RECODER join WH_BROKEN_RECODER_DETAIL using(BROKEN_NO)
       where APPLY_DATE >= trunc(p_curr_date) - 1
         and APPLY_DATE < trunc(p_curr_date)
       group by f_get_admin_org(APPLY_ADMIN),PLAN_CODE
      union all
      -- 期初库存
      select substr(WAREHOUSE,1,2) org_code,88 do_type,PLAN_CODE,sum(AMOUNT) AMOUNT,sum(TICKETS) TICKETS
        from HIS_LOTTERY_INVENTORY
       where calc_date = to_char(trunc(p_curr_date) - 2, 'yyyy-mm-dd')
         and STATUS = 11
       group by substr(WAREHOUSE,1,2),PLAN_CODE
      union all
      -- 期末库存
      select substr(WAREHOUSE,1,2) org_code,99 do_type,PLAN_CODE,sum(AMOUNT) AMOUNT,sum(TICKETS) TICKETS
        from HIS_LOTTERY_INVENTORY
       where calc_date = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
         and STATUS = 11
       group by substr(WAREHOUSE,1,2),PLAN_CODE
      union all
      select f_get_admin_org(market_admin) org, 66 do_type, PLAN_CODE,
             sum(OPEN_INV) * (select TICKET_AMOUNT from game_plans where plan_code = tt.plan_code),
             sum(OPEN_INV)
        from his_mm_inventory tt
       where calc_date = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
       group by f_get_admin_org(market_admin),plan_code
       union all
       select f_get_admin_org(market_admin) org, 77 do_type, PLAN_CODE,
              sum(CLOSE_INV) * (select TICKET_AMOUNT from game_plans where plan_code = tt.plan_code),
              sum(CLOSE_INV)
        from his_mm_inventory tt
       where calc_date = to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd')
       group by f_get_admin_org(market_admin),plan_code
      )
   select to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd'), org_code, do_type, PLAN_CODE,amount, tickets
     from base;

   commit;

   if p_maintance_mod = 0 then
      -- 代理商资金报表（Agent Fund Report）
      insert into his_agent_fund_report (calc_date, org_code, flow_type, amount)
      with
         agent_org as (
            select org_code from inf_orgs where org_type = 2),
         base as (
            select org_code, flow_type, sum(change_amount) amount
              from flow_org
             where trade_time >= trunc(p_curr_date) - 1
               and trade_time < trunc(p_curr_date)
               and org_code in (select org_code from agent_org)
             group by org_code, flow_type),
         last_day as (
            select org_code, 88 as flow_type, amount
              from his_agent_fund_report
             where org_code in (select org_code from agent_org)
               and flow_type = 99
               and calc_date = to_char(trunc(p_curr_date) - 2, 'yyyy-mm-dd')),
         today as (
            select org_code, 99 as flow_type, account_balance amount
              from acc_org_account
             where org_code in (select org_code from agent_org)),
         plus_result as (
            select org_code, flow_type, amount from base
            union all
            select org_code, flow_type, amount from last_day
            union all
            select org_code, flow_type, amount from today)
      select to_char(trunc(p_curr_date) - 1, 'yyyy-mm-dd'), org_code, flow_type, amount
        from plus_result;

      commit;
   end if;

  -- 销售、退票和兑奖统计
  insert into his_sale_pay_cancel
    (sale_date, sale_month, area_code, org_code, plan_code, sale_amount, sale_comm, cancel_amount, cancel_comm, pay_amount, pay_comm, incoming)
  -- 即开票
  with sale as
   (select to_char(sale_time, 'yyyy-mm-dd') sale_day,
           to_char(sale_time, 'yyyy-mm') sale_month,
           area_code,
           org_code,
           f_get_old_plan_name(plan_code, batch_no) plan_code,
           sum(sale_amount) sale_amount,
           sum(comm_amount) as sale_comm
      from flow_sale
     where sale_time >= trunc(p_curr_date) - 1
       and sale_time <  trunc(p_curr_date)
     group by area_code,
              org_code,
              f_get_old_plan_name(plan_code, batch_no),
              to_char(sale_time, 'yyyy-mm-dd'),
              to_char(sale_time, 'yyyy-mm')),
  cancel as
   (select to_char(cancel_time, 'yyyy-mm-dd') sale_day,
           to_char(cancel_time, 'yyyy-mm') sale_month,
           area_code,
           org_code,
           f_get_old_plan_name(plan_code, batch_no) plan_code,
           sum(sale_amount) cancel_amount,
           sum(comm_amount) as cancel_comm
      from flow_cancel
     where cancel_time >= trunc(p_curr_date) - 1
       and cancel_time <  trunc(p_curr_date)
     group by area_code,
              org_code,
              f_get_old_plan_name(plan_code, batch_no),
              to_char(cancel_time, 'yyyy-mm-dd'),
              to_char(cancel_time, 'yyyy-mm')),
  pay_detail as
   (select to_char(pay_time, 'yyyy-mm-dd') sale_day,
           to_char(pay_time, 'yyyy-mm') sale_month,
           area_code,
           f_get_flow_pay_org(pay_flow) org_code,
           f_get_old_plan_name(plan_code, batch_no) plan_code,
           pay_amount,
           nvl(comm_amount, 0) comm_amount
      from flow_pay
     where pay_time >= trunc(p_curr_date) - 1
       and pay_time <  trunc(p_curr_date) ),
  pay as
   (select sale_day,
           sale_month,
           area_code,
           org_code,
           plan_code,
           sum(pay_amount) pay_amount,
           sum(comm_amount) as pay_comm
      from pay_detail
     group by sale_day, sale_month, area_code, org_code, plan_code),
  pre_detail as (
     select sale_day, sale_month, area_code, org_code, plan_code, sale_amount, sale_comm, 0 as cancel_amount, 0 as cancel_comm, 0 as pay_amount, 0 as pay_comm from sale
      union all
     select sale_day, sale_month, area_code, org_code, plan_code, 0 as sale_amount, 0 as sale_comm, cancel_amount, cancel_comm, 0 as pay_amount, 0 as pay_comm from cancel
      union all
     select sale_day, sale_month, area_code, org_code, plan_code, 0 as sale_amount, 0 as sale_comm, 0 as cancel_amount, 0 as cancel_comm, pay_amount, pay_comm from pay
  ),
  -- 电脑票
  lot_sale as
   (select to_char(SALETIME, 'yyyy-mm-dd') sale_day,
           to_char(SALETIME, 'yyyy-mm') sale_month,
           area_code,
           org_code,
           f_get_game_name(game_code) plan_code,
           sum(TICKET_AMOUNT) lot_sale_amount,
           sum(COMMISSIONAMOUNT) as lot_sale_comm
      from his_sellticket join inf_agencys
        on his_sellticket.agency_code=inf_agencys.agency_code
        and SALETIME >= trunc(p_curr_date) - 1
        and SALETIME <  trunc(p_curr_date)
        group by area_code,
              org_code,
              f_get_game_name(game_code),
              to_char(SALETIME, 'yyyy-mm-dd'),
              to_char(SALETIME, 'yyyy-mm')),
  lot_cancel as
   (select to_char(CANCELTIME, 'yyyy-mm-dd') sale_day,
           to_char(CANCELTIME, 'yyyy-mm') sale_month,
       f_get_agency_area(his_cancelticket.applyflow_sell) area_code,
           org_code,
           f_get_game_name(game_code) plan_code,
           sum(TICKET_AMOUNT) lot_cancel_amount,
           sum(COMMISSIONAMOUNT) as lot_cancel_comm
      from his_cancelticket join his_sellticket
        on his_cancelticket.applyflow_sell=his_sellticket.applyflow_sell
        and  CANCELTIME >= trunc(p_curr_date) - 1
        and CANCELTIME <  trunc(p_curr_date)
        group by f_get_agency_area(his_cancelticket.applyflow_sell),
              org_code,
              f_get_game_name(game_code),
              to_char(CANCELTIME, 'yyyy-mm-dd'),
              to_char(CANCELTIME, 'yyyy-mm')),
  lot_pay as
   (select to_char(PAYTIME, 'yyyy-mm-dd') sale_day,
           to_char(PAYTIME, 'yyyy-mm') sale_month,
           f_get_agency_area(applyflow_sell) area_code,
           org_code,
           f_get_game_name(game_code) plan_code,
           sum(winningamount) lot_pay_amount,
           sum(commissionamount) lot_pay_comm
      from his_payticket
     where PAYTIME >= trunc(p_curr_date) - 1
       and PAYTIME <  trunc(p_curr_date)
     group by to_char(PAYTIME, 'yyyy-mm-dd'),
              to_char(PAYTIME, 'yyyy-mm'),
              f_get_agency_area(applyflow_sell),
              org_code,
              f_get_game_name(game_code)),
  lot_pre_detail as (
     select sale_day, sale_month, area_code, org_code, plan_code, lot_sale_amount, lot_sale_comm, 0 as lot_cancel_amount, 0 as lot_cancel_comm, 0 as lot_pay_amount, 0 as lot_pay_comm from lot_sale
      union all
     select sale_day, sale_month, area_code, org_code, plan_code, 0 as lot_sale_amount, 0 as lot_sale_comm, lot_cancel_amount, lot_cancel_comm, 0 as lot_pay_amount, 0 as lot_pay_comm from lot_cancel
      union all
     select sale_day, sale_month, area_code, org_code, plan_code, 0 as lot_sale_amount, 0 as lot_sale_comm, 0 as lot_cancel_amount, 0 as lot_cancel_comm, lot_pay_amount, lot_pay_comm from lot_pay
  )
  --计开票
  select sale_day, sale_month, nvl(area_code, 'NONE') area_code, org_code, plan_code,
         nvl(sum(sale_amount), 0) sale_amount,
         nvl(sum(sale_comm), 0) sale_comm,
         nvl(sum(cancel_amount), 0) cancel_amount,
         nvl(sum(cancel_comm), 0) cancel_comm,
         nvl(sum(pay_amount), 0) pay_amount,
         nvl(sum(pay_comm), 0) pay_comm,
         (nvl(sum(sale_amount), 0) - nvl(sum(sale_comm), 0) - nvl(sum(pay_amount), 0) - nvl(sum(pay_comm), 0) - nvl(sum(cancel_amount), 0) + nvl(sum(cancel_comm), 0)) incoming
    from pre_detail
   group by sale_day, sale_month, area_code, org_code, plan_code
  union all
  --电脑票
  select sale_day, sale_month, nvl(area_code, 'NONE') area_code, org_code, to_char(plan_code),
         nvl(sum(lot_sale_amount), 0) sale_amount,
         nvl(sum(lot_sale_comm), 0) sale_comm,
         nvl(sum(lot_cancel_amount), 0) cancel_amount,
         nvl(sum(lot_cancel_comm), 0) cancel_comm,
         nvl(sum(lot_pay_amount), 0) pay_amount,
         nvl(sum(lot_pay_comm), 0) pay_comm,
         (nvl(sum(lot_sale_amount), 0) - nvl(sum(lot_sale_comm), 0) - nvl(sum(lot_pay_amount), 0) - nvl(sum(lot_pay_comm), 0) - nvl(sum(lot_cancel_amount), 0) + nvl(sum(lot_cancel_comm), 0)) incoming
    from lot_pre_detail
   group by sale_day, sale_month, area_code, org_code, plan_code;

  commit;

  insert into his_pay_level
    (sale_date, sale_month, org_code, plan_code, level_1, level_2, level_3, level_4, level_5, level_6, level_7, level_8, level_other, total)
  with
  pay_detail as
     (select to_char(pay_time, 'yyyy-mm-dd') sale_day,
             to_char(pay_time, 'yyyy-mm') sale_month,
             f_get_old_plan_name(plan_code,batch_no) plan_code,
             (case when reward_no = 1 then pay_amount else 0 end) level_1,
             (case when reward_no = 2 then pay_amount else 0 end) level_2,
             (case when reward_no = 3 then pay_amount else 0 end) level_3,
             (case when reward_no = 4 then pay_amount else 0 end) level_4,
             (case when reward_no = 5 then pay_amount else 0 end) level_5,
             (case when reward_no = 6 then pay_amount else 0 end) level_6,
             (case when reward_no = 7 then pay_amount else 0 end) level_7,
             (case when reward_no = 8 then pay_amount else 0 end) level_8,
             (case when reward_no in (9,10,11,12,13) then pay_amount else 0 end) level_other,
             pay_amount,
             f_get_flow_pay_org(pay_flow) org_code
        from flow_pay
     where pay_time >= trunc(p_curr_date) - 1
       and pay_time <  trunc(p_curr_date))
  select sale_day,
         sale_month,
         org_code,
         plan_code,
         sum(level_1) as level_1,
         sum(level_2) as level_2,
         sum(level_3) as level_3,
         sum(level_4) as level_4,
         sum(level_5) as level_5,
         sum(level_6) as level_6,
         sum(level_7) as level_7,
         sum(level_8) as level_8,
         sum(level_other) as level_other,
         sum(pay_amount) as total
    from pay_detail
   group by sale_day,
            sale_month,
            org_code,
            plan_code;
  commit;

end;
/

create or replace procedure p_set_tds_issue_draw_notice
/*****************************************************************/
   ----------- 生成 TDS json开奖公告 ---------------
   ----- created by chen zhen @ 2016-04-18
/*****************************************************************/

(
   p_game_code    in number, --游戏编码
   p_issue_number in number, --期次编码

   c_errorcode out number,   --业务错误编码
   c_errormesg out string    --错误信息描述
) is

   all_json_obj json;
   second_json  json;
   draw_json    json;
   draw_json_list json_list;

   v_rank1_json json_list;
   v_rank2_json json_list;
   v_rank3_json json_list;
   v_rank4_json json_list;
   v_rank5_json json_list;
   v_rank_json  json_list;

   -- 临时的json和json list变量
   tempobj json;
   tempobj_list json_list;

   v_draw_code            varchar2(200);
   v_winning_amount       number(28);
   v_sale_amount          number(28);
   v_issue_number         iss_game_issue.issue_number%type;

   -- 最近100期的开奖号码
   type draw_record is record(issue_number number(28), final_draw_number varchar2(200));
   type draw_collect is table of draw_record;
   v_array_draw_code draw_collect;

   v_loop_i number(2);

   -- 开奖结果，每个小球对应的数字
   draw_number number(3);

   -- 临时clob对象，用于入库
   temp_clob clob;

begin
  -- 初始化变量
  c_errorcode := 0;
  all_json_obj := json();
  second_json := json();
  v_array_draw_code := draw_collect();
  draw_json := json();
  draw_json_list := json_list();

  -- 临时的json和json list变量
  tempobj := json();
  tempobj_list := json_list();

  v_rank1_json := json_list();
  v_rank2_json := json_list();
  v_rank3_json := json_list();
  v_rank4_json := json_list();
  v_rank5_json := json_list();
  v_rank_json := json_list();

  -- TDS动画，只做了11选5的，其他的没有做
  if p_game_code <> 12 then
    return;
  end if;

  -- 11选5，所有要先开五个坑
  for v_loop_i in 1 .. 11 loop
     v_rank1_json.append(0);
     v_rank2_json.append(0);
     v_rank3_json.append(0);
     v_rank4_json.append(0);
     v_rank5_json.append(0);
     v_rank_json.append(0);
  end loop;

  all_json_obj.put('cmd', 8193);
  all_json_obj.put('game', p_game_code);
  all_json_obj.put('issue', p_issue_number);

  -- 开奖号码
  begin
     select issue_number,final_draw_number, issue_sale_amount, winning_amount
       into v_issue_number, v_draw_code, v_sale_amount, v_winning_amount
       from iss_game_issue
      where game_code=p_game_code
        and issue_number=p_issue_number;
  exception
     when no_data_found then
     c_errorcode := 1;
     c_errormesg := error_msg.err_p_set_json_issue_draw_n_1;               -- 游戏期次不存在，或者未开奖
     return;
  end;

  if v_winning_amount is null then
     c_errorcode := 10;
     c_errormesg := error_msg.err_p_set_json_issue_draw_n_1;               -- 游戏期次不存在，或者未开奖
     return;
  end if;

  all_json_obj.put('draw_code', v_draw_code);
  all_json_obj.put('draw_time', dbtool.t2s(sysdate + 5 / 24 / 60 / 50));    -- 无理由，当前时间加5秒

  -- 销售和中奖金额
  second_json.put('sale_amount', v_sale_amount);
  second_json.put('win_amount', v_winning_amount);


  -- 奖级奖金表
  for tab in (select prize_level, prize_name, prize_count*single_bet_reward amount, prize_count from iss_prize where game_code=p_game_code and issue_number=v_issue_number order by prize_level) loop
     tempobj := json();
     tempobj.put('name', tab.prize_name);
     tempobj.put('amount', tab.amount);
     tempobj.put('bets', tab.prize_count);
     tempobj_list.append(tempobj.to_json_value);
  end loop;

  second_json.put('prize_level',tempobj_list.to_json_value);
  all_json_obj.put('win_info', second_json.to_json_value);

  -- 中大奖的销售站
  -- modify by ChenZhen @2016-06-17 修改SQL。倒排单票中奖金额
  tempobj_list := json_list();
  for tab in (
              with sa as
               (select agency_code, address from inf_agencys),
              single_ticket_reward as (
                select applyflow_sell, sale_agency, sum(winningamount) amount
                  from his_win_ticket_detail hwt
                 where game_code = p_game_code
                   and issue_number= v_issue_number
                 group by applyflow_sell, sale_agency
         order by amount desc),
              top_10_win as
               (select sale_agency agency_code, amount from single_ticket_reward where rownum <= 10)
              select agency_code, amount, address
                from top_10_win
                join sa
               using(agency_code) order by amount desc
             ) loop
     tempobj := json();
     tempobj.put('agency_code', tab.agency_code);
     tempobj.put('win_amount', tab.amount);
     tempobj.put('agency_adderss',tab.address);
     tempobj_list.append(tempobj.to_json_value);
  end loop;
  all_json_obj.put('big_win', tempobj_list.to_json_value);



  -- 先获取最近100期的开奖号码
  with tab as (
     select issue_number, final_draw_number
       from iss_game_issue
      where game_code=p_game_code
        and final_draw_number is not null
        -- 如果期次编号为0，就把最近的开奖号码发回去
        and issue_number <= v_issue_number
      order by issue_number desc)
  select issue_number, final_draw_number bulk collect into v_array_draw_code
    from tab
   where rownum <= 100;
  dbms_output.put_line(v_array_draw_code.count);

  -- 最近20期分析
  second_json := json();
  for v_loop_i in 1 .. 40 loop
     exit when v_loop_i > v_array_draw_code.count;
     draw_json.put('issue', v_array_draw_code(v_loop_i).issue_number);
     draw_json.put('drawcode', v_array_draw_code(v_loop_i).final_draw_number);
     draw_json_list.append(draw_json.to_json_value);

     -- 每个坑都走一遍
     v_draw_code := replace(v_array_draw_code(v_loop_i).final_draw_number, '+', ',');
     for tab in (select rownum,column_value from table(dbtool.strsplit(v_draw_code))) loop
        draw_number := tab.column_value;
        case tab.rownum
           when 1 then v_rank1_json.replace(draw_number, v_rank1_json.get(draw_number).get_number + 1);
           when 2 then v_rank2_json.replace(draw_number, v_rank2_json.get(draw_number).get_number + 1);
           when 3 then v_rank3_json.replace(draw_number, v_rank3_json.get(draw_number).get_number + 1);
           when 4 then v_rank4_json.replace(draw_number, v_rank4_json.get(draw_number).get_number + 1);
           when 5 then v_rank5_json.replace(draw_number, v_rank5_json.get(draw_number).get_number + 1);
        end case;
        v_rank_json.replace(draw_number, v_rank_json.get(draw_number).get_number + 1);
     end loop;

     exit when v_array_draw_code.count = v_loop_i;
  end loop;
  second_json.put('draw_code', draw_json_list.to_json_value);
  second_json.put('rank_1st', v_rank1_json.to_json_value);
  second_json.put('rank_2st', v_rank2_json.to_json_value);
  second_json.put('rank_3st', v_rank3_json.to_json_value);
  second_json.put('rank_4st', v_rank4_json.to_json_value);
  second_json.put('rank_5st', v_rank5_json.to_json_value);
  second_json.put('rank_total', v_rank_json.to_json_value);

  all_json_obj.put('last_issue_40', second_json.to_json_value);

  -- 冷热号分析（20、50、100期）
  v_rank_json := json_list();
  for v_loop_i in 1 .. 11 loop
     v_rank_json.append(0);
  end loop;
  for v_loop_i in 1 .. 20 loop
     -- 每个坑都走一遍
     exit when v_loop_i > v_array_draw_code.count;
     v_draw_code := replace(v_array_draw_code(v_loop_i).final_draw_number, '+', ',');
     for tab in (select rownum,column_value from table(dbtool.strsplit(v_draw_code))) loop
        draw_number := tab.column_value;
        v_rank_json.replace(draw_number, v_rank_json.get(draw_number).get_number + 1);
     end loop;

     exit when v_array_draw_code.count = v_loop_i;
  end loop;
  all_json_obj.put('hot_cool_20', v_rank_json.to_json_value);

  v_rank_json := json_list();
  for v_loop_i in 1 .. 11 loop
     v_rank_json.append(0);
  end loop;
  for v_loop_i in 1 .. 50 loop
     -- 每个坑都走一遍
     exit when v_loop_i > v_array_draw_code.count;
     v_draw_code := replace(v_array_draw_code(v_loop_i).final_draw_number, '+', ',');
     for tab in (select rownum,column_value from table(dbtool.strsplit(v_draw_code))) loop
        draw_number := tab.column_value;
        v_rank_json.replace(draw_number, v_rank_json.get(draw_number).get_number + 1);
     end loop;

     exit when v_array_draw_code.count = v_loop_i;
  end loop;
  all_json_obj.put('hot_cool_50', v_rank_json.to_json_value);

  v_rank_json := json_list();
  for v_loop_i in 1 .. 11 loop
     v_rank_json.append(0);
  end loop;
  for v_loop_i in 1 .. 100 loop
     -- 每个坑都走一遍
     exit when v_loop_i > v_array_draw_code.count;
     v_draw_code := replace(v_array_draw_code(v_loop_i).final_draw_number, '+', ',');
     for tab in (select rownum,column_value from table(dbtool.strsplit(v_draw_code))) loop
        draw_number := tab.column_value;
        v_rank_json.replace(draw_number, v_rank_json.get(draw_number).get_number + 1);
     end loop;

     exit when v_array_draw_code.count = v_loop_i;
  end loop;
  all_json_obj.put('hot_cool_100', v_rank_json.to_json_value);

  if f_get_sys_param('1105') = '0' then
    all_json_obj.put('roll_text_1', nvl(f_get_sys_param('1101'), '') || '　');
    all_json_obj.put('roll_text_2', nvl(f_get_sys_param('1102'), '') || '　');
    all_json_obj.put('roll_text_3', nvl(f_get_sys_param('1103'), '') || '　');

  else
    -- 7天内中大奖的销售站
    all_json_obj.put('roll_text_1', '');
    all_json_obj.put('roll_text_2', '');
    all_json_obj.put('roll_text_3', '');

    -- modify by kwx @2016-07-05 7天内中大奖前三名大奖信息
    for tab in (with
                sa as (
                  select agency_code, address from inf_agencys),
                single_ticket_reward as (
                  select applyflow_sell, sale_agency, issue_number, sum(winningamount) amount
                    from his_win_ticket_detail hwt
                   where game_code = 12
                     and winnning_time >= trunc(sysdate) - 6
                   group by applyflow_sell, sale_agency, issue_number
                   order by amount desc),
                top_10_win as
                 (select sale_agency agency_code, amount,issue_number from single_ticket_reward where rownum <= 3)
                select rownum, agency_code, amount, address, issue_number
                  from top_10_win
                  join sa
                 using(agency_code) order by amount desc
               ) loop
      all_json_obj.put('roll_text_' || to_char(tab.rownum), to_char(tab.agency_code) || ' ' || to_char(tab.address) || '. ' || to_char(tab.issue_number) || '( ' || to_char(tab.amount) || ' រៀល )');
    end loop;
  end if;

  all_json_obj.put('errorCode', 5000);

  temp_clob := empty_clob();
  dbms_lob.createtemporary(temp_clob, true);
  all_json_obj.to_clob(temp_clob);
  update iss_game_issue_xml set json_winning_brodcast = temp_clob where game_code = p_game_code and issue_number = p_issue_number;
  dbms_lob.freetemporary(temp_clob);

  commit;

exception
  when others then
    rollback;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

end;
/

create or replace procedure p_mm_inv_check
/****************************************************************/
   ------------------- 市场管理员库存盘点 -------------------
   ---- add by 陈震: 2015-12-08
   ----   输入一个彩票数组，确定出市场管理员的库存情况（以本为单位），返回两个数组。
   ----   1、显示彩票不在这个管理员手中的；
   ----   2、应该在管理员库存，但是未扫描的彩票

   ---- modify by 陈震: 2016-10-13
   ----   修改盘点 结果为是否一致。1=一致，0=不一致

   /*************************************************************/
(
 --------------输入----------------
  p_oper                               in number,                             -- 市场管理员
  p_array_lotterys                     in type_mm_check_lottery_list,         -- 输入的彩票对象

  ---------出口参数---------
  c_array_lotterys                     out type_mm_check_lottery_list,        -- 输出的彩票对象
  c_inv_tickets                        out number,                            -- 管理员库存彩票数量
  c_check_tickets                      out number,                            -- 本次盘点中，属于管理员的彩票数量
  c_diff_tickets                       out number,                            -- 未盘点的管理员彩票数量
  c_scan_tickets                       out number,                            -- 本次扫描数量
  c_errorcode                          out number,                            -- 错误编码
  c_errormesg                          out string                             -- 错误原因

 ) is

   v_tmp_lotterys                      type_mm_check_lottery_list;            -- 库存彩票对象
   v_out_lotterys                      type_mm_check_lottery_list;            -- 临时彩票对象
   v_s1_lotterys                       type_mm_check_lottery_list;            -- 临时彩票对象
   v_s2_lotterys                       type_mm_check_lottery_list;            -- 临时彩票对象

   v_cp_no                             char(10);

begin

  /*-----------    初始化数据    -----------------*/
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  c_inv_tickets := 0;
  c_check_tickets := 0;
  c_diff_tickets := 0;

  /*----------- 数据校验   -----------------*/
  -- 校验入口参数是否正确，对应的数据记录是否存在
  if not f_check_admin(p_oper) then
    c_errorcode := 1;
    c_errormesg := dbtool.format_line(p_oper) || error_msg.err_common_100; -- 无此人
    return;
  end if;

  /*----------- 业务逻辑   -----------------*/
  /********************************************************************************************************************************************************************/
  -- 获取管理员所有彩票对象（本）
  select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, (ticket_no_end - ticket_no_start + 1), 0)
    bulk collect into v_tmp_lotterys
    from wh_ticket_package
   where status = 21
     and current_warehouse = p_oper;

  -- 生成管理员库存数量
  select sum(tickets)
    into c_inv_tickets
    from table(v_tmp_lotterys);
  c_inv_tickets := nvl(c_inv_tickets, 0);

  -- 生成本次扫描数量
  c_scan_tickets := p_array_lotterys.count;

  /********************************************************************************************************************************************************************/
  -- 看看输入的彩票中，有多少本是在库存管理员手中的.统计交集的票数量，为盘点数量
  select sum(src.tickets)
    into c_check_tickets
    from table(p_array_lotterys) dest
    join table(v_tmp_lotterys) src
   using (plan_code, batch_no, package_no);
  c_check_tickets := nvl(c_check_tickets, 0);

  -- 本次盘点后，管理员有多少票没有被盘点
  c_diff_tickets := nvl(c_inv_tickets,0) - nvl(c_check_tickets, 0);

  /********************************************************************************************************************************************************************/
  -- 获取未扫描的票
  select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, 0, 2)
   bulk collect into v_s2_lotterys
   from (
       select plan_code, batch_no, package_no from table(v_tmp_lotterys)
       minus
       select plan_code, batch_no, package_no from table(p_array_lotterys));

  -- 显示不在管理员手中的票
  select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, 0, 1)
   bulk collect into v_s1_lotterys
   from (
       select plan_code, batch_no, package_no from table(p_array_lotterys)
       minus
       select plan_code, batch_no, package_no from table(v_tmp_lotterys));

  -- 合并结果
  select type_mm_check_lottery_info(plan_code, batch_no, 3, 0, 0, package_no, tickets, status)
   bulk collect into v_out_lotterys
   from (
       select plan_code, batch_no, package_no, tickets, status from table(v_s1_lotterys)
       union all
       select plan_code, batch_no, package_no, tickets, status from table(v_s2_lotterys));

  c_array_lotterys := v_out_lotterys;

  -- 插入数据库
  v_cp_no := f_get_wh_check_point_seq;

  insert into wh_mm_check
    (cp_no,              manager_id,           result,
     inv_tickets,        check_tickets,        diff_tickets,
     scan_tickets,       cp_date)
  values
    (v_cp_no,            p_oper,               (case when c_diff_tickets = 0 then 1 else 0 end ),
     c_inv_tickets,      c_check_tickets,      c_diff_tickets,
     c_scan_tickets,     sysdate);

  if c_array_lotterys.count > 0 then
    forall i in 1 .. c_array_lotterys.count
      insert into wh_mm_check_detail
        (cp_detail_no,                      cp_no,                        manager_id,
         plan_code,                         batch_no,                     valid_number,
         trunk_no,                          box_no,                       package_no,
         tickets,                           status)
      values
        (f_get_wh_check_point_seq,          v_cp_no,                      p_oper,
         c_array_lotterys(i).plan_code,     c_array_lotterys(i).batch_no, c_array_lotterys(i).valid_number,
         c_array_lotterys(i).trunk_no,      c_array_lotterys(i).box_no,   c_array_lotterys(i).package_no,
         c_array_lotterys(i).tickets,       c_array_lotterys(i).status);

  end if;

  commit;

exception
  when others then
    c_errorcode := 100;
    c_errormesg := error_msg.err_common_1 || sqlerrm;
    rollback;
end;
/
