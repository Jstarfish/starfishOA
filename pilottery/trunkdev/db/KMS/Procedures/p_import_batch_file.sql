CREATE OR REPLACE PROCEDURE p_import_batch_file
/****************************************************************/
   ------------------- 适用于导入批次数据文件 -------------------
   ---- 导入批次数据文件
   ---- add by 陈震: 2015/9/9
   ---- 业务流程：页面中保存数据以后，调用此存储过程，用来导入数据文件
   ----           1、查找  批次信息导入（GAME_BATCH_IMPORT）表，获取文件名
   ----           2、建立扩展表，包装信息、奖符信息、中奖明细信息，
   /*************************************************************/
(
 --------------输入----------------
 p_plan_code in char, -- 方案代码
 p_batch_no  in char, -- 生产批次
 p_oper      IN number, --

 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因

 ) AUTHID CURRENT_USER IS

   v_count number(5);

   v_file_name_package VARCHAR2(500); -- 包装信息文件名
   v_file_name_map     VARCHAR2(500); -- 奖符信息文件名
   v_file_name_reward  VARCHAR2(500); -- 中奖明细信息文件名
   v_import_no         VARCHAR2(12); -- 数据导入编号

   v_table_name varchar2(100); -- 导数据的临时表
   v_sql        varchar2(10000); -- 动态SQL语句

   v_file_plan  varchar2(100); -- 第1行方案代码
   v_file_batch varchar2(100); -- 第5行生产批次

   v_bind_1  varchar2(100); -- 第1行方案代码
   v_bind_2  varchar2(100); -- 第2行彩票分类
   v_bind_3  varchar2(100); -- 第3行彩票名称
   v_bind_4  varchar2(100); -- 第4行单票金额
   v_bind_5  varchar2(100); -- 第5行生产批次
   v_bind_6  varchar2(100); -- 第6行每组箱数
   v_bind_7  varchar2(100); -- 第7行每箱本数
   v_bind_8  varchar2(100); -- 第8行每本张数
   v_bind_9  varchar2(100); -- 第9行奖组张数（万张）
   v_bind_10 varchar2(100); -- 第10行首分组号
   v_bind_11 varchar2(100); -- 第11行生产厂家
   v_bind_12 varchar2(100); -- 第12行单箱重量
   v_bind_13 varchar2(100); -- 第13行总票数
   v_bind_14 varchar2(100); -- 第14行首箱编号（例如“00001”）
   v_bind_15 varchar2(100); -- 第15行每箱盒数

   v_plan_publish          number(1);                                      -- 印制厂商编号

   v_tab_reward            game_batch_import_reward%rowtype;
   v_first_line            boolean;

BEGIN

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

   /*----------- 数据校验   -----------------*/
   -- 校验入口参数是否正确，对应的数据记录是否存在
   select count(*)
     into v_count
     from dual
    where exists (select 1
             from GAME_BATCH_IMPORT
            where PLAN_CODE = p_plan_code
              and BATCH_NO = p_batch_no);
   IF v_count = 1 THEN
      c_errorcode := 1;
      c_errormesg := error_msg.ERR_P_IMPORT_BATCH_FILE_1; -- 批次数据信息已经存在
      RETURN;
   END IF;

   /**********************************************************/
   /******************* 插入导入信息表 *************************/
   v_file_name_package := 'PACKAGE-' || p_plan_code || '_' || p_batch_no || '.imp';
   v_file_name_map     := 'MAP-' || p_plan_code || '_' || p_batch_no || '.imp';
   v_file_name_reward  := 'REWARD-' || p_plan_code || '_' || p_batch_no || '.imp';

   insert into game_batch_import
      (import_no,
       plan_code,
       batch_no,
       package_file,
       reward_map_file,
       reward_detail_file,
       start_date,
       end_date,
       import_admin)
   values
      (f_get_batch_import_seq,
       p_plan_code,
       p_batch_no,
       v_file_name_package,
       v_file_name_map,
       v_file_name_reward,
       sysdate,
       null,
       p_oper)
   returning import_no into v_import_no;

   /**********************************************************/
   /******************* 导入包装信息 *************************/
   -- 删除原有数据
   -- delete from GAME_BATCH_IMPORT_DETAIL where PLAN_CODE = p_plan_code and BATCH_NO = p_batch_no;

   -- 建立外部表，使用统一的表名 ext_kws_import。导入之前，确定是否存在这张表，存在就删除。
   v_table_name := 'ext_kws_import';
   SELECT COUNT(*)
     INTO v_count
     FROM user_tables
    WHERE table_name = upper(v_table_name);
   IF v_count = 1 THEN
      v_sql := 'drop table ' || v_table_name;
      EXECUTE IMMEDIATE v_sql;
   END IF;

   -- 拼接导入SQL，并开始导入数据
   v_sql := 'create table ' || v_table_name || ' (tmp_col VARCHAR2(100)) ';
   v_sql := v_sql || 'ORGANIZATION EXTERNAL';
   v_sql := v_sql || '  (TYPE ORACLE_LOADER ';
   v_sql := v_sql || '   DEFAULT DIRECTORY impdir';
   v_sql := v_sql || '   ACCESS PARAMETERS ';
   v_sql := v_sql || '      (RECORDS DELIMITED BY NEWLINE';
   v_sql := v_sql || '       LOAD WHEN (tmp_col != BLANKS))';
   v_sql := v_sql || '   LOCATION (''' || v_file_name_package || ''')';
   v_sql := v_sql || '  )';
   EXECUTE IMMEDIATE v_sql;

   -- 先获取包装文件中的所含数据内容
   -- 以下内容，摘自 “SVN\doc\11Reference\现场包装编码规则\说明文件.docx”
   v_sql := 'select * from (select rownum cnt, tmp_col from ext_kws_import) pivot(max(tmp_col) for cnt in(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15))';
   EXECUTE IMMEDIATE v_sql
      into v_bind_1, v_bind_2, v_bind_3, v_bind_4, v_bind_5, v_bind_6, v_bind_7, v_bind_8, v_bind_9, v_bind_10, v_bind_11, v_bind_12, v_bind_13, v_bind_14, v_bind_15;

   -- 判断文件中的数据，与待导入的数据是否一致
   if (v_file_plan <> p_plan_code) or (v_file_batch <> p_batch_no) then
      rollback;
      c_errorcode := 2;
      c_errormesg := error_msg.ERR_P_IMPORT_BATCH_FILE_2; -- 文件中的方案与批次信息同导入记录中内容不符
      RETURN;
   end if;

   -- 插入数据
   insert into GAME_BATCH_IMPORT_DETAIL
      (IMPORT_NO,
       PLAN_CODE,
       BATCH_NO,
       LOTTERY_TYPE,
       LOTTERY_NAME,
       BOXES_EVERY_TRUNK,
       TRUNKS_EVERY_GROUP,
       PACKS_EVERY_TRUNK,
       TICKETS_EVERY_PACK,
       TICKETS_EVERY_GROUP,
       FIRST_REWARD_GROUP_NO,
       TICKETS_EVERY_BATCH,
       FIRST_TRUNK_BATCH,
       STATUS)
   values
      (v_import_no,
       p_plan_code,
       p_batch_no,
       v_bind_2,
       v_bind_3,
       to_number(replace(v_bind_15,chr(13),'')),
       to_number(replace(v_bind_6,chr(13),'')),
       to_number(replace(v_bind_7,chr(13),'')),
       to_number(replace(v_bind_8,chr(13),'')),
       to_number(replace(v_bind_9,chr(13),'')) * 10000,
       to_number(replace(v_bind_10,chr(13),'')),
       to_number(replace(v_bind_13,chr(13),'')),
       to_number(replace(v_bind_14,chr(13),'')),
       ebatch_item_status.working);

   -- 删除临时表
   v_sql := 'drop table ' || v_table_name;
   EXECUTE IMMEDIATE v_sql;

   /**********************************************************/
   /******************* 导入奖符信息 *************************/
   -- 删除原有数据
   delete from GAME_BATCH_IMPORT_REWARD where PLAN_CODE = p_plan_code and BATCH_NO = p_batch_no;

   -- 拼接导入SQL，并开始导入数据
   v_sql := 'create table ' || v_table_name ||
            ' (REWARD_NO VARCHAR2(10),FAST_IDENTITY_CODE VARCHAR2(20),SINGLE_REWARD_AMOUNT VARCHAR2(10),COUNTS VARCHAR2(10)) ';
   v_sql := v_sql || 'ORGANIZATION EXTERNAL';
   v_sql := v_sql || '  (TYPE ORACLE_LOADER ';
   v_sql := v_sql || '   DEFAULT DIRECTORY impdir';
   v_sql := v_sql || '   ACCESS PARAMETERS ';
   v_sql := v_sql ||
            '      (RECORDS DELIMITED BY NEWLINE  LOAD WHEN (FAST_IDENTITY_CODE != BLANKS) fields terminated by 0X''09'' missing field values are null )';
   v_sql := v_sql || '   LOCATION (''' || v_file_name_map || ''')';
   v_sql := v_sql || '  )';
   EXECUTE IMMEDIATE v_sql;

   v_sql := 'truncate table tmp_batch_reward';
   EXECUTE IMMEDIATE v_sql;
   v_sql := 'insert into tmp_batch_reward select to_number(replace(REWARD_NO,chr(13),'''')),trim(FAST_IDENTITY_CODE),to_number(replace(SINGLE_REWARD_AMOUNT,chr(13),'''')),to_number(replace(COUNTS,chr(13),'''')) from ' || v_table_name;
   EXECUTE IMMEDIATE v_sql;

   -- 循环外部表，生成数据
   v_first_line := true;
   v_tab_reward.IMPORT_NO := v_import_no;
   v_tab_reward.PLAN_CODE := p_plan_code;
   v_tab_reward.BATCH_NO := p_batch_no;

   for loop_tab in (select * from tmp_batch_reward) loop
      if loop_tab.REWARD_NO is not null then
         if not v_first_line then
            -- 插入上次获取的数据
            insert into GAME_BATCH_IMPORT_REWARD values v_tab_reward;
         end if;

         -- 确保导入的数据，都是瑞尔
         if loop_tab.SINGLE_REWARD_AMOUNT < 1000 then
            rollback;
            delete GAME_BATCH_IMPORT_DETAIL where plan_code = p_plan_code and batch_no=p_batch_no;
            delete GAME_BATCH_IMPORT_REWARD where PLAN_CODE = p_plan_code and BATCH_NO = p_batch_no;
            delete game_batch_import where plan_code = p_plan_code and batch_no=p_batch_no;
            commit;
            raise_application_error(-20001, 'User define error: SINGLE_REWARD_AMOUNT must great 1000');
            return;
         end if;

         v_tab_reward.REWARD_NO := loop_tab.REWARD_NO;
         v_tab_reward.SINGLE_REWARD_AMOUNT := loop_tab.SINGLE_REWARD_AMOUNT;
         v_tab_reward.COUNTS := loop_tab.COUNTS;
         v_tab_reward.FAST_IDENTITY_CODE := loop_tab.FAST_IDENTITY_CODE;
      else
         v_tab_reward.FAST_IDENTITY_CODE := v_tab_reward.FAST_IDENTITY_CODE || ',' || loop_tab.FAST_IDENTITY_CODE;
      end if;

      v_first_line := false;
   end loop;
   -- 处理最后一行数据
   insert into GAME_BATCH_IMPORT_REWARD values v_tab_reward;

   -- 删除临时表
   v_sql := 'drop table ext_kws_import';
   EXECUTE IMMEDIATE v_sql;

   /**********************************************************/
   /******************* 导入奖级信息 *************************/
   -- 删除原有数据
   delete from GAME_BATCH_REWARD_DETAIL where PLAN_CODE = p_plan_code and BATCH_NO = p_batch_no;

   -- 拼接导入SQL，并开始导入数据
   v_sql := 'create table ' || v_table_name || ' (tmp_col VARCHAR2(4000)) ';
   v_sql := v_sql || 'ORGANIZATION EXTERNAL';
   v_sql := v_sql || '  (TYPE ORACLE_LOADER ';
   v_sql := v_sql || '   DEFAULT DIRECTORY impdir';
   v_sql := v_sql || '   ACCESS PARAMETERS ';
   v_sql := v_sql || '      (RECORDS DELIMITED BY NEWLINE' ;
   v_sql := v_sql || '       LOAD WHEN (tmp_col != BLANKS) ';
   v_sql := v_sql || '       fields (';
   v_sql := v_sql || '          tmp_col CHAR(4000) ';
   v_sql := v_sql || '       )';
   v_sql := v_sql || '      )';
   v_sql := v_sql || '   LOCATION (''' || v_file_name_reward || ''')';
   v_sql := v_sql || '  )';
   EXECUTE IMMEDIATE v_sql;

   -- 插入数据
   v_sql := 'insert into GAME_BATCH_REWARD_DETAIL (IMPORT_NO, PLAN_CODE, BATCH_NO, SAFE_CODE) ';
   v_sql := v_sql || 'select ''' || v_import_no || ''',';
   v_sql := v_sql || '       ''' || p_plan_code || ''',';
   v_sql := v_sql || '       ''' || p_batch_no || ''',';
   v_sql := v_sql || '       tmp_col from ext_kws_import';
   EXECUTE IMMEDIATE v_sql;

   -- 设置结束时间字段
   update GAME_BATCH_IMPORT
      set END_DATE = sysdate
    where IMPORT_NO = v_import_no;

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      delete GAME_BATCH_IMPORT_DETAIL where plan_code = p_plan_code and batch_no=p_batch_no;
      delete GAME_BATCH_IMPORT_REWARD where PLAN_CODE = p_plan_code and BATCH_NO = p_batch_no;
      delete GAME_BATCH_REWARD_DETAIL where PLAN_CODE = p_plan_code and BATCH_NO = p_batch_no;
      delete game_batch_import where plan_code = p_plan_code and batch_no=p_batch_no;
      commit;
      c_errorcode := 1;
      c_errormesg := error_msg.ERR_COMMON_1 || SQLERRM;

END;
