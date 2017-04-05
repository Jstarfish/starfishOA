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

   v_desc varchar2(1000);
   v_rec_date date;

BEGIN
   -- 初始化数据
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   if p_game_code <> egame.fbs then
     -- 检查 iss_prize 表是否有数据（足彩游戏不检查）
     select count(*)
       into v_cnt
       from dual
      where exists(select 1 from iss_prize where game_code=p_game_code and issue_number=p_issue_number);

     if v_cnt = 0 then
        c_errorcode := 1;
        c_errormesg := 'iss_prize is no data. game_code ['||p_game_code||'] issue_number ['||p_issue_number||']';
        return;
     end if;
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
   v_sql := v_sql || '      (RECORDS DELIMITED BY NEWLINE logfile bkdir:''import_win_data_' || p_game_code || '_' || p_issue_number || '.log''';
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

   -- FBS 单独获取开奖时间
   if p_game_code <> egame.fbs then
     -- 获得插入所需要的必备数据（开奖时间）
     SELECT real_reward_time
       INTO v_reward_time
       FROM iss_game_issue
      WHERE game_code = p_game_code
        AND issue_number = p_issue_number;
   else
     select REWARD_TIME
       INTO v_reward_time
       from FBS_MATCH
      where game_code = p_game_code
        AND MATCH_CODE = p_issue_number;
   end if;
   
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
   
   -- FBS 游戏，区别对待，处理高低将等
   if p_game_code <> egame.fbs then
     v_sql := v_sql || '             (SELECT is_hd_prize';
     v_sql := v_sql || '                FROM iss_prize';
     v_sql := v_sql || '               WHERE game_code = ' || p_game_code;
     v_sql := v_sql || '                 AND issue_number = ' || p_issue_number;
     v_sql := v_sql || '                 and prize_level = df.prize_level),';
   else
     -- FBS游戏，所有奖等都是低等奖
     v_sql := v_sql || '             0,';
   end if;
   
   v_sql := v_sql || '             winningamounttax,';
   v_sql := v_sql || '             winningamount,';
   v_sql := v_sql || '             taxamount, f_get_his_win_seq';
   v_sql := v_sql || '        FROM ' || v_table_name || ' df; commit; end;';
   EXECUTE IMMEDIATE v_sql;

   -- 删除外部表
   v_sql := 'drop table ' || v_table_name;
   EXECUTE IMMEDIATE v_sql;

   -- FBS 游戏，不执行统计
   if p_game_code <> egame.fbs then
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
   end if;
   
EXCEPTION
   WHEN OTHERS THEN
      rollback;
      c_errorcode := 1;
      c_errormesg := 'Import winning data is failed. GAME_CODE ['||p_game_code||'] ISSUE_NUMBER ['||p_issue_number||'] Errmsg : ' || sqlerrm;
      return;
END;
