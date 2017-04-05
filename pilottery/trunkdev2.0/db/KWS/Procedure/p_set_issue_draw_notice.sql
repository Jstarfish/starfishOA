CREATE OR REPLACE PROCEDURE p_set_issue_draw_notice
/*****************************************************************/
  ----------- 生成开奖公告 ---------------
  ---- migrate by Chen Zhen @ 2016-04-18
/*****************************************************************/

(p_game_code    IN NUMBER, --游戏编码
 p_issue_number IN NUMBER, --期次编码
 --p_draw_nocite  OUT CLOB, --开奖公告字符串
 c_errorcode OUT NUMBER, --业务错误编码
 c_errormesg OUT STRING --错误信息描述
 ) IS

  -- 高等奖中奖销售站统计
  v_clob                CLOB; -- confirm XML
  v_draw_info           xmltype;
  v_prize_info          xmltype; --
  v_single_prize        xmltype;
  v_single_prize_agency xmltype;

  v_draw_result        VARCHAR2(100); -- 开奖号码
  v_prize_total_amount VARCHAR2(100); -- 中奖总额

  v_count INTEGER;

  -- 外层循环用
  doc      dbms_xmldom.domdocument;
  buf      VARCHAR2(4000);
  docelem  dbms_xmldom.domelement;
  nodelist dbms_xmldom.domnodelist;
  node     dbms_xmldom.domnode;
  v_size   NUMBER;

  -- 内层循环用
  doc_agency      dbms_xmldom.domdocument;
  buf_agency      VARCHAR2(4000);
  docelem_agency  dbms_xmldom.domelement;
  nodelist_agency dbms_xmldom.domnodelist;
  node_agency     dbms_xmldom.domnode;
  v_size_agency   NUMBER;

  v_prize_level           NUMBER(3); -- 奖级
  v_prize_name            VARCHAR2(100); -- 奖级名称
  v_is_hd_prize           NUMBER(1); -- 是否高等奖
  v_prize_count           NUMBER(16); -- 中奖注数
  v_single_bet_reward     NUMBER(28); -- 单注金额
  v_single_bet_reward_tax NUMBER(28); -- 单注税后中奖金额
  v_tax                   NUMBER(28); -- 单注税金
  v_agency_code           NUMBER(16); -- 销售站编号
  v_win_count             NUMBER(28); -- 注数
  v_sale_amount           NUMBER(28); -- 销售总额

  v_rtv      xmltype;
  v_area     xmltype;
  v_loop_xml xmltype;
  v_agency   xmltype;

  -- 调用获取系统参数存储过程用
  v_param_code    NUMBER(10);
  v_c_param_value VARCHAR2(100);
  v_c_errorcode   NUMBER(10);
  v_c_errormesg   VARCHAR2(1000);

  -- 发SMS
  v_max_single_reward NUMBER(28); -- 单注最高奖金

BEGIN
  -- 初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
  --v_area := xmltype('');

  -- 从gameissues中获取XML文件内容
  SELECT winner_confirm_info
    INTO v_clob
    FROM iss_game_issue_xml
   WHERE game_code = p_game_code
     AND issue_number = p_issue_number;
  v_draw_info := xmltype(v_clob);

  /*----------------- 解析XML中的开奖信息，先处理非奖等部分 -----------------*/
  -- 开奖号码
  SELECT xmlcast(xmlquery('/game_draw/draw_result/text()' passing
                          v_draw_info RETURNING content) AS VARCHAR2(100))
    INTO v_draw_result
    FROM dual;

  -- 中奖总额
  SELECT xmlcast(xmlquery('/game_draw/prize_total_amount/text()' passing
                          v_draw_info RETURNING content) AS VARCHAR2(100))
    INTO v_prize_total_amount
    FROM dual;

  -- 先更新gameissue表（开奖号码、销售总额、中奖总额）
  UPDATE iss_game_issue
     SET final_draw_number = v_draw_result
   WHERE game_code = p_game_code
     AND issue_number = p_issue_number;

  /*----------------- 解析XML中的开奖信息，奖级部分先入库 -----------------*/
  -- 获得奖级部分XML文件，
  SELECT xmlquery('/game_draw/prizes' passing v_draw_info RETURNING content)
    INTO v_prize_info
    FROM dual;
  doc := dbms_xmldom.newdomdocument(v_prize_info);

  docelem  := dbms_xmldom.getdocumentelement(doc);
  nodelist := dbms_xmldom.getelementsbytagname(docelem, 'prize');

  v_size := dbms_xmldom.getlength(nodelist);

  -- 获得confirm中的中奖统计信息，入库
  v_max_single_reward := 0;
  FOR v IN 1 .. v_size LOOP
    node := dbms_xmldom.getfirstchild(dbms_xmldom.item(nodelist, v - 1));
    dbms_xmldom.writetobuffer(dbms_xmldom.item(nodelist, v - 1), buf);
    v_single_prize := xmltype(buf);
    SELECT xmlcast(xmlquery('/prize/prize_level/text()' passing
                            v_single_prize RETURNING content) AS NUMBER(3))
      INTO v_prize_level
      FROM dual;
    SELECT xmlcast(xmlquery('/prize/is_high_prize/text()' passing
                            v_single_prize RETURNING content) AS NUMBER(1))
      INTO v_is_hd_prize
      FROM dual;
    SELECT xmlcast(xmlquery('/prize/prize_num/text()' passing
                            v_single_prize RETURNING content) AS NUMBER(16))
      INTO v_prize_count
      FROM dual;
    SELECT xmlcast(xmlquery('/prize/prize_amount/text()' passing
                            v_single_prize RETURNING content) AS NUMBER(28))
      INTO v_single_bet_reward
      FROM dual;
    SELECT xmlcast(xmlquery('/prize/prize_after_tax_amount/text()' passing
                            v_single_prize RETURNING content) AS NUMBER(28))
      INTO v_single_bet_reward_tax
      FROM dual;
    SELECT xmlcast(xmlquery('/prize/prize_tax_amount/text()' passing
                            v_single_prize RETURNING content) AS NUMBER(28))
      INTO v_tax
      FROM dual;

    BEGIN
      SELECT prize_name
        INTO v_prize_name
        FROM iss_game_prize_rule
       WHERE game_code = p_game_code
         AND issue_number = p_issue_number
         AND prize_level = v_prize_level;
    EXCEPTION
      WHEN no_data_found THEN
        v_prize_name := '[UNKNOWN Prize Level] GameCode:' || p_game_code ||
                        ' IssueNumber:' || p_issue_number ||
                        ' Prize Level:' || v_prize_level;
    END;

    -- 考虑重新开奖，做之前，看看数据库里面有没有奖级
    SELECT COUNT(*)
      INTO v_count
      FROM dual
     WHERE EXISTS (SELECT 1
              FROM iss_prize
             WHERE game_code = p_game_code
               AND issue_number = p_issue_number
               AND prize_level = v_prize_level);
    IF v_count = 0 THEN
      INSERT INTO iss_prize
        (game_code,
         issue_number,
         prize_level,
         prize_name,
         is_hd_prize,
         prize_count,
         single_bet_reward,
         single_bet_reward_tax,
         tax)
      VALUES
        (p_game_code,
         p_issue_number,
         v_prize_level,
         v_prize_name,
         v_is_hd_prize,
         v_prize_count,
         v_single_bet_reward,
         v_single_bet_reward_tax,
         v_tax);
    ELSE
      UPDATE iss_prize
         SET prize_name            = v_prize_name,
             is_hd_prize           = v_is_hd_prize,
             prize_count           = v_prize_count,
             single_bet_reward     = v_single_bet_reward,
             single_bet_reward_tax = v_single_bet_reward_tax,
             tax                   = v_tax
       WHERE game_code = p_game_code
         AND issue_number = p_issue_number
         AND prize_level = v_prize_level;
    END IF;

    -- 获取最高单注奖金
    if v_max_single_reward < v_single_bet_reward then
      v_max_single_reward := v_single_bet_reward;
    end if;
  END LOOP;

  /*----------------- 解析XML中的开奖信息，处理高等奖销售站中奖注数 -----------------*/
  SELECT xmlquery('/game_draw/high_prizes' passing v_draw_info RETURNING
                  content)
    INTO v_prize_info
    FROM dual;
  doc := dbms_xmldom.newdomdocument(v_prize_info);

  docelem  := dbms_xmldom.getdocumentelement(doc);
  nodelist := dbms_xmldom.getelementsbytagname(docelem, 'high_prize');
  v_size   := dbms_xmldom.getlength(nodelist);

  FOR v IN 1 .. v_size LOOP
    node := dbms_xmldom.getfirstchild(dbms_xmldom.item(nodelist, v - 1));
    dbms_xmldom.writetobuffer(dbms_xmldom.item(nodelist, v - 1), buf);
    v_single_prize := xmltype(buf);

    -- 获取奖级
    SELECT xmlcast(xmlquery('/high_prize/prize_level/text()' passing
                            v_single_prize RETURNING content) AS NUMBER(3))
      INTO v_prize_level
      FROM dual;

    -- 再对奖级下面的信息进行解析
    SELECT xmlquery('/high_prize/locations' passing v_single_prize
                    RETURNING content)
      INTO v_agency
      FROM dual;

    doc_agency      := dbms_xmldom.newdomdocument(v_agency);
    docelem_agency  := dbms_xmldom.getdocumentelement(doc_agency);
    nodelist_agency := dbms_xmldom.getelementsbytagname(docelem_agency,
                                                        'location');
    v_size_agency   := dbms_xmldom.getlength(nodelist_agency);
    FOR vv IN 1 .. v_size_agency LOOP
      node_agency := dbms_xmldom.getfirstchild(dbms_xmldom.item(nodelist_agency,
                                                                vv - 1));
      dbms_xmldom.writetobuffer(dbms_xmldom.item(nodelist_agency, vv - 1),
                                buf_agency);
      v_single_prize_agency := xmltype(buf_agency);

      -- 销售站
      SELECT xmlcast(xmlquery('/location/agency_code/text()' passing
                              v_single_prize_agency RETURNING content) AS
                     NUMBER(16))
        INTO v_agency_code
        FROM dual;

      -- 中奖注数
      SELECT xmlcast(xmlquery('/location/count/text()' passing
                              v_single_prize_agency RETURNING content) AS
                     NUMBER(28))
        INTO v_win_count
        FROM dual;

      -- 插入临时表，用于后续统计
      INSERT INTO tmp_calc_issue_broadcast
        (agency_code, prize_level, winning_count)
      VALUES
        (v_agency_code, v_prize_level, v_win_count);
    END LOOP;
  END LOOP;

  /*----------------- 按照销售站统计区域中奖信息，生成高等奖中奖分布的XML -----------------*/
  -- 生成 高等奖统计信息
  FOR parea IN (SELECT DISTINCT org_code
                  FROM inf_agencys
                 WHERE agency_code IN
                       (SELECT agency_code FROM tmp_calc_issue_broadcast)) LOOP

    -- 先生成统计此区域下各个奖等的统计值
    SELECT xmlagg(xmlelement("areaLotteryDetail",
                             xmlconcat(xmlelement("prizeLevel", prize_name),
                                       xmlelement("betCount",
                                                  SUM(winning_count)))))
      INTO v_loop_xml
      FROM (SELECT (SELECT prize_name
                      FROM iss_game_prize_rule
                     WHERE game_code = p_game_code
                       AND issue_number = p_issue_number
                       AND prize_level = calc.prize_level) prize_name,
                   winning_count
              FROM tmp_calc_issue_broadcast calc
             WHERE agency_code IN
                   (SELECT agency_code
                      FROM inf_agencys
                     WHERE area_code = parea.org_code))
     GROUP BY prize_name;

    -- 合并上区域的信息
    SELECT xmlelement("Area",
                      xmlconcat(xmlelement("areaCode", org_code),
                                xmlelement("areaName", org_name),
                                v_loop_xml))
      INTO v_loop_xml
      FROM inf_orgs
     WHERE org_code = parea.org_code;

    -- 累加
    SELECT xmlconcat(v_area, v_loop_xml) INTO v_area FROM dual;
  END LOOP;

  -- 套上一个套套，生成“高等奖统计信息”
  SELECT xmlelement("highPrizeAreas", v_area) INTO v_area FROM dual;

  /*----------------- 生成最终的开奖公告XML -----------------*/
  -- 获取各个游戏的开奖公告时间描述
  CASE p_game_code
    WHEN egame.koc6hc THEN
      -- 七龙星
      v_param_code := 1009;
    WHEN egame.kocssc THEN
      -- 天天赢
      v_param_code := 1010;
    WHEN egame.ssc THEN
      -- 时时彩
      v_param_code := 1011;
    WHEN egame.kk3 THEN
      -- 快三
      v_param_code := 1012;
    WHEN egame.s11q5 THEN
      -- 11选5
      v_param_code := 1013;
    WHEN egame.tema THEN
      -- 40选1-特码游戏
      v_param_code := 1020;

    ELSE
      v_param_code := 9999;

  END CASE;

  p_sys_get_parameter(p_param_code  => v_param_code,
                      c_param_value => v_c_param_value,
                      c_errorcode   => v_c_errorcode,
                      c_errormesg   => v_c_errormesg);
  IF v_c_errorcode <> 0 THEN
    c_errorcode := 1;
    c_errormesg := '获取系统参数错误，参数序号【' || v_param_code || '】。错误名称：' ||
                   v_c_errormesg;
    ROLLBACK;
    RETURN;
  END IF;

  -- 生成最终的XML
  SELECT xmlelement("announcement",
         /* 开奖公告综述部分 */ xmlattributes(p_game_code AS "gameCode", (SELECT full_name
                                                              FROM inf_games
                                                             WHERE game_code =
                                                                   p_game_code) AS "gameName", p_issue_number AS "periodIssue", nvl(to_char(real_reward_time, 'yyyy-mm-dd'), ' ') AS "dperdLevel", nvl(pay_end_day, 0) AS "overDual", nvl(final_draw_number, ' ') AS "codeResult", nvl(issue_sale_amount, 0) AS "saleAmount",(CASE
           WHEN EXISTS
            (SELECT 1
                   FROM iss_game_pool
                  WHERE game_code =
                        p_game_code) THEN
            1
           ELSE
            0
         END) AS "hasPool", nvl(pool_close_amount, 0) AS "poolScroll", v_c_param_value AS "drawCycle"),
         /* 奖级奖金部分 */(with orderd_level as (select game_code,
                                             issue_number,
                                             prize_level,
                                             disp_order
                                        from iss_game_prize_rule
                                       where game_code = p_game_code
                                         and issue_number =
                                             p_issue_number), now_prize as (select game_code,
                                                                             issue_number,
                                                                             prize_level,
                                                                             prize_name,
                                                                             is_hd_prize,
                                                                             prize_count,
                                                                             single_bet_reward,
                                                                             single_bet_reward_tax,
                                                                             tax
                                                                        from iss_prize
                                                                       where game_code =
                                                                             p_game_code
                                                                         and issue_number =
                                                                             p_issue_number), orderd_prize as (select game_code,
                                                                                                                issue_number,
                                                                                                                prize_level,
                                                                                                                prize_name,
                                                                                                                is_hd_prize,
                                                                                                                prize_count,
                                                                                                                single_bet_reward,
                                                                                                                single_bet_reward_tax,
                                                                                                                tax,
                                                                                                                disp_order
                                                                                                           from orderd_level
                                                                                                           join now_prize
                                                                                                          using (game_code, issue_number, prize_level)
                                                                                                          order by disp_order)
           select xmlagg(xmlelement("lotteryDetail",
                                    xmlconcat(xmlelement("prizeLevel",
                                                         prize_name),
                                              xmlelement("betCount",
                                                         prize_count),
                                              xmlelement("awardAmount",
                                                         single_bet_reward),
                                              xmlelement("amountAftertax",
                                                         single_bet_reward_tax),
                                              xmlelement("amountTotal",
                                                         prize_count *
                                                         single_bet_reward))))
             from orderd_prize),
           /* 高等奖区域分布部分 */
           v_area), issue_sale_amount
             INTO v_rtv, v_sale_amount
             FROM iss_game_issue tab
            WHERE game_code = p_game_code
              AND issue_number = p_issue_number;


  -- 更新数据库
  UPDATE iss_game_issue_xml
     SET winning_brodcast = v_rtv.getclobval()
   WHERE game_code = p_game_code
     AND issue_number = p_issue_number;

  -- 更新 ISS_GAME_POLICY_FUND
  SELECT COUNT(*)
    INTO v_count
    FROM dual
   WHERE EXISTS (SELECT 1
            FROM iss_game_policy_fund
           WHERE game_code = p_game_code
             AND issue_number = p_issue_number);
  IF v_count = 1 THEN
    DELETE FROM iss_game_policy_fund
     WHERE game_code = p_game_code
       AND issue_number = p_issue_number;
  END IF;
  INSERT INTO iss_game_policy_fund
    (game_code,
     issue_number,
     sale_amount,
     theory_win_amount,
     fund_amount,
     comm_amount,
     adj_fund)
    SELECT p_game_code,
           p_issue_number,
           v_sale_amount,
           v_sale_amount / 1000 * theory_rate,
           v_sale_amount / 1000 * fund_rate,
           v_sale_amount / 1000 *
           (1000 - fund_rate - adj_rate - theory_rate),
           v_sale_amount / 1000 * adj_rate
      FROM gp_policy
     WHERE (game_code, his_policy_code) =
           (SELECT game_code, his_policy_code
              FROM iss_current_param
             WHERE game_code = p_game_code
               AND issue_number = p_issue_number);

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

END;
