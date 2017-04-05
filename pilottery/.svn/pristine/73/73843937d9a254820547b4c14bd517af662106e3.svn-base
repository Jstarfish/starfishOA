CREATE OR REPLACE PROCEDURE p_om_issue_create
/****************************************************************/
   ------------------- 适用于新增期次 ---------------------------
   -------modify by dzg 2014-6-21 增加期次序号控制，检查时间是否有重复--------
   -------modify by Chen Zhen 2014-7-5 根据柬埔寨表结构修改 --------
   -------modify by dzg 2014.10.20 修改支持本地化
   -------modify by dzg 2015.06.10 检测期号是否递增
   -------modify by dzg 2015.07.06 修改copy奖级和玩法的排序字段
   /*************************************************************/
(
 --------------输入----------------
 p_issue_list IN type_game_issue_list, --期次列表
 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因

 ) IS
   v_cur_game_code     NUMBER := 0; --当前游戏编号
   v_cur_issue_code    NUMBER := 0; --当前期次编号，用于2015.5.10修改验证期号递增
   v_cur_base_code     NUMBER := 0; --当前配置基础信息编号
   v_cur_plcy_code     NUMBER := 0; --当前政策参数编号
   v_cur_rule_code     NUMBER := 0; --当前玩法编号
   v_cur_win_code      NUMBER := 0; --当前中奖编号
   v_cur_prize_code    NUMBER := 0; --当前奖级编号
   v_count_temp        NUMBER := 0; --临时计数器
   v_cur_max_seq       NUMBER := 0; --当期游戏最大seq,初始值从db中获取
   v_is_time_contain   NUMBER := 0; --检测系统中是否已经包含当前期，检测时间交叉
   v_calc_winning_code VARCHAR2(100); --当前算奖规则

   v_cur_issue type_game_issue_info; --当前期

   -- 同步数据
   v_param     VARCHAR2(200);
   v_ip        VARCHAR2(200);
   v_user      VARCHAR2(200);
   v_pass      VARCHAR2(200);
   v_url       VARCHAR2(200);

   v_c_errorcode NUMBER(10);
   v_c_errormesg VARCHAR2(1000);

   v_risk_status        number(1);
   v_mysql_issue_list   type_game_issue_list_mon;
   v_mysql_issue_date   type_game_issue_info_mon;

BEGIN

   /*-----------------   初始化数据基础信息    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   v_mysql_issue_list := type_game_issue_list_mon();

   /*----------------- 输入数据校验  -----------------*/
   IF p_issue_list.count < 0 THEN
      c_errorcode := 1;
      --c_errormesg := '输入期次数据不能为空';
      c_errormesg := error_msg.MSG0027;
      RETURN;
   END IF;

   /*-------游戏有效性校验 -------*/
   v_cur_game_code := p_issue_list(1).gamecode;
   IF v_cur_game_code < 0 THEN
      c_errorcode := 1;
      --c_errormesg := '无效的游戏编码';
      c_errormesg := error_msg.MSG0028;
      RETURN;
   END IF;

   SELECT COUNT(inf_games.game_code)
     INTO v_count_temp
     FROM inf_games
    WHERE inf_games.game_code = v_cur_game_code;

   IF v_count_temp < 0 THEN
      c_errorcode := 1;
      --c_errormesg := '游戏不存在，或游戏编码异常';
      c_errormesg := error_msg.MSG0029;
      RETURN;
   END IF;
   v_count_temp := 0;

   /*-------游戏历史参数并校验 -------*/

   SELECT DISTINCT his_his_code
     INTO v_cur_base_code
     FROM v_gp_his_current
    WHERE game_code = v_cur_game_code;

   IF v_cur_base_code < 0 THEN
      c_errorcode := 1;
      --c_errormesg := '游戏' || v_cur_game_code || '基础信息配置信息为空';
      c_errormesg := error_msg.MSG0030;
      RETURN;
   END IF;

   /*-------初始化政策参数并校验 -------*/

   SELECT DISTINCT his_policy_code
     INTO v_cur_plcy_code
     FROM v_gp_policy_current
    WHERE game_code = v_cur_game_code;

   IF v_cur_plcy_code < 0 THEN
      c_errorcode := 1;
      --c_errormesg := '游戏政策参数配置信息为空';
      c_errormesg := error_msg.MSG0031;
      RETURN;
   END IF;

   /*-------初始化奖级参数并校验 -------*/
   SELECT DISTINCT his_prize_code
     INTO v_cur_prize_code
     FROM v_gp_prize_rule_current
    WHERE game_code = v_cur_game_code;

   IF v_cur_prize_code < 0 THEN
      c_errorcode := 1;
      --c_errormesg := '游戏奖级参数配置信息为空';
      c_errormesg := error_msg.MSG0032;
      RETURN;
   END IF;

   /*-------初始化玩法参数并校验 -------*/
   SELECT DISTINCT his_rule_code
     INTO v_cur_rule_code
     FROM v_gp_rule_current
    WHERE game_code = v_cur_game_code;

   IF v_cur_rule_code < 0 THEN
      c_errorcode := 1;
      --c_errormesg := '游戏玩法参数配置信息为空';
      c_errormesg := error_msg.MSG0033;
      RETURN;
   END IF;

   /*-------初始化中奖参数并校验 -------*/
   SELECT DISTINCT his_win_code
     INTO v_cur_win_code
     FROM v_gp_win_rule_current
    WHERE game_code = v_cur_game_code;

   IF v_cur_win_code < 0 THEN
      c_errorcode := 1;
      --c_errormesg := '游戏中奖参数配置信息为空';
      c_errormesg := error_msg.MSG0034;
      RETURN;
   END IF;

   /*-------获取算奖规则-------*/
   SELECT calc_winning_code
     INTO v_calc_winning_code
     FROM gp_dynamic
    WHERE game_code = v_cur_game_code;

   /*-------获取最大seq-------*/
   SELECT nvl(MAX(iss_game_issue.issue_seq), 0)
     INTO v_cur_max_seq
     FROM iss_game_issue
    WHERE iss_game_issue.game_code = v_cur_game_code;

   /*----------------- 循环插入数据  -----------------*/
   FOR i IN 1 .. p_issue_list.count LOOP

      v_cur_issue  := p_issue_list(i);
      v_count_temp := 0;

      /*-------如下检测第一次执行-------*/
      IF i = 1 THEN

         --初始化当前期次
         v_cur_issue_code := v_cur_issue.issuenumber;

         /*-----检测期次号重复 -----*/
         SELECT COUNT(iss_game_issue.issue_number)
           INTO v_count_temp
           FROM iss_game_issue
          WHERE iss_game_issue.game_code = v_cur_game_code
            AND iss_game_issue.issue_number >= v_cur_issue.issuenumber;

         IF v_count_temp > 0 THEN
            raise_application_error(-20010, error_msg.MSG0035);
         END IF;

         /*-------检测时间重复-------*/
         SELECT COUNT(iss_game_issue.issue_number)
           INTO v_is_time_contain
           FROM iss_game_issue
          WHERE iss_game_issue.game_code = v_cur_game_code
            AND iss_game_issue.plan_close_time >
                v_cur_issue.planstarttime ;

         IF v_is_time_contain > 0 THEN
            raise_application_error(-20011, error_msg.MSG0036);
            RETURN;
         END IF;
      END IF;

      /*-------如下检测期号递增-------*/
      IF i > 1 THEN
        IF v_cur_issue.issuenumber <= v_cur_issue_code THEN
           raise_application_error(-1, 'Invalid issue number:'||v_cur_issue.issuenumber);
           RETURN;
        END IF;

        IF v_cur_issue.issuenumber > v_cur_issue_code THEN
           v_cur_issue_code := v_cur_issue.issuenumber;
        END IF;
      END IF;

      /*-----插入期次 -----*/
      INSERT INTO iss_game_issue
         (game_code, issue_number, issue_seq, issue_status, is_publish, plan_start_time, plan_close_time, plan_reward_time, calc_winning_code)
      VALUES
         (v_cur_game_code,
          v_cur_issue.issuenumber,
          v_cur_max_seq + i,
          egame_issue_status.prearrangement,
          eboolean.noordisabled,
          v_cur_issue.planstarttime,
          v_cur_issue.planclosetime,
          v_cur_issue.planrewardtime,
          v_calc_winning_code);

      -- 准备同步的数据
      select is_open_risk into v_risk_status from v_gp_his_current where game_code=v_cur_game_code;
      v_mysql_issue_date := new type_game_issue_info_mon(
                                                         v_cur_game_code,                          --游戏编号
                                                         v_cur_issue.issuenumber,                  --期次号
                                                         egame_issue_status.prearrangement,        --期次状态
                                                         v_risk_status,                            --风控状态
                                                         to_char(v_cur_issue.planstarttime,  'yyyy-mm-dd hh24:mi:ss'),                                     --实际期次开始时间
                                                         to_char(v_cur_issue.planclosetime,  'yyyy-mm-dd hh24:mi:ss'),                                     --实际期次关闭时间
                                                         to_char(v_cur_issue.planrewardtime, 'yyyy-mm-dd hh24:mi:ss'),                                     --实际期次开奖时间
                                                         null,                                     --实际期次结束时间
                                                         0,                                        --期初奖池
                                                         null,                                     --第一次开奖用户
                                                         null,                                     --第二次开奖用户
                                                         0);                                       --期末奖池
      v_mysql_issue_list.extend;
      v_mysql_issue_list(i) := v_mysql_issue_date;

      /*-----插入期次游戏参数 -----*/
      INSERT INTO iss_current_param
         (game_code, issue_number, his_his_code, his_policy_code, his_rule_code, his_win_code, his_prize_code)
      VALUES
         (v_cur_game_code, v_cur_issue.issuenumber, v_cur_base_code, v_cur_plcy_code, v_cur_rule_code, v_cur_win_code, v_cur_prize_code);

      /*-----插入期次奖级-----*/
      ---modify by dzg 2015.07.06
      INSERT INTO iss_game_prize_rule
         (game_code, issue_number, prize_level, prize_name, level_prize,disp_order)
         SELECT game_code, v_cur_issue.issuenumber, prule_level, prule_name, level_prize,disp_order
           FROM v_gp_prize_rule_current
          WHERE game_code = v_cur_game_code
            AND his_prize_code = v_cur_prize_code;

      /*-----插入期次XML-----*/
      INSERT INTO iss_game_issue_xml
         (game_code, issue_number)
      VALUES
         (v_cur_game_code, v_cur_issue.issuenumber);

   END LOOP;

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      c_errorcode := 1;
      --c_errormesg := '数据库异常' || SQLERRM;
      c_errormesg := error_msg.MSG0004 || SQLERRM;

END;
