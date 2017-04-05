CREATE OR REPLACE PROCEDURE p_om_issue_delete
/****************************************************************/
  ------------------- 适用于删除期次 -------------------
  ----add by dzg 2014-07-10 删除期次及其相关数据。
  ----删除当前期次之后所有期次及其相关内容
  ----如果当前期次已经发布，则撤销
  ----modify by dzg 2014-07-14 增加期次删除时，删除开奖公告内容
  ----modify by dzg 2014.10.20 修改支持本地化
  /*************************************************************/
(
 --------------输入----------------
 p_game_code     IN NUMBER, --游戏编号
 p_issue_numuber IN NUMBER, --期次号
 ---------出口参数---------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 ) IS

   -- 同步数据
   v_param     VARCHAR2(200);
   v_ip        VARCHAR2(200);
   v_user      VARCHAR2(200);
   v_pass      VARCHAR2(200);
   v_url       VARCHAR2(200);

   v_c_errorcode NUMBER(10);
   v_c_errormesg VARCHAR2(1000);

   v_mysql_issue_list   type_game_issue_list_mon;
   v_mysql_issue_date   type_game_issue_info_mon;
   v_count              number(10);

BEGIN

   /*-----------    初始化数据    -----------------*/
   dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);
   v_mysql_issue_list := type_game_issue_list_mon();

   /*-----------    删除期次     -----------------*/

   -- 删除前，先保存需要删除的数据，准备同步用
   v_count := 0;
   for tab_del_issue in (select game_code, issue_number from iss_game_issue WHERE iss_game_issue.game_code = p_game_code AND iss_game_issue.issue_number >= p_issue_numuber) loop
      v_mysql_issue_date := new type_game_issue_info_mon(
                                                         tab_del_issue.game_code,             --游戏编号
                                                         tab_del_issue.issue_number,          --期次号
                                                         0,                       --期次状态
                                                         0,                       --风控状态
                                                         null,                    --实际期次开始时间
                                                         null,                    --实际期次关闭时间
                                                         null,                    --实际期次开奖时间
                                                         null,                    --实际期次结束时间
                                                         0,                       --期初奖池
                                                         null,                    --第一次开奖用户
                                                         null,                    --第二次开奖用户
                                                         0);                      --期末奖池
      v_mysql_issue_list.extend;
      v_count := v_count + 1;
      v_mysql_issue_list(v_count) := v_mysql_issue_date;
   end loop;

   /*-----删除期表内容-----*/
   DELETE FROM iss_game_issue
   WHERE iss_game_issue.game_code = p_game_code
     AND iss_game_issue.issue_number >= p_issue_numuber;

   /*-----删除参数表数据-----*/

   DELETE FROM iss_current_param
   WHERE iss_current_param.game_code = p_game_code
     AND iss_current_param.issue_number >= p_issue_numuber;

   /*-----删除期次奖级-----*/

   DELETE FROM iss_game_prize_rule
   WHERE iss_game_prize_rule.game_code = p_game_code
     AND iss_game_prize_rule.issue_number >= p_issue_numuber;

   /*-----删除期次开奖公告-----*/
   DELETE FROM iss_game_issue_xml
    WHERE iss_game_issue_xml.game_code = p_game_code
      AND iss_game_issue_xml.issue_number >= p_issue_numuber;

   COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    --c_errormesg := '数据库异常' || SQLERRM;
    c_errormesg := error_msg.MSG0004 || SQLERRM;

END;
