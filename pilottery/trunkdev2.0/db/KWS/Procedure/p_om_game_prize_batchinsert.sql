CREATE OR REPLACE PROCEDURE p_om_game_prize_batchinsert
/***************************************************************
  ------------------- 游戏奖级批量处理  -------------------
  ---------add by dzg  2014-8-4 批量更新奖级 
  ---------modify by dzg 2014.10.20 修改支持本地化
  ************************************************************/
(
 
 --------------输入----------------
 
 p_game_prize_list IN type_game_prize_list, --游戏奖级信息
 
 --------------出口参数----------------
 c_errorcode OUT NUMBER, --错误编码
 c_errormesg OUT STRING --错误原因
 
 ) IS

  v_his_code                   NUMBER := 0; --历史编号，从0开始
  v_cur_prize_info    type_game_prize_info; --当前奖级信息

BEGIN
  /*-----------    初始化数据    -----------*/

  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  /*-----------  输入数据校验    ----------*/
  IF p_game_prize_list.count < 0 THEN
    c_errorcode := 1;
    --c_errormesg := '输入授权游戏不能为空';
    c_errormesg := error_msg.MSG0005;
    RETURN;
  END IF;

  v_cur_prize_info := p_game_prize_list(1);
  SELECT nvl(MAX(his_prize_code), 0)+1
    INTO v_his_code
    FROM gp_prize_rule
   WHERE gp_prize_rule.game_code = v_cur_prize_info.GAMECODE;

  /*-----------选择游戏循环插入----------*/

  FOR i IN 1 .. p_game_prize_list.count LOOP
  
    v_cur_prize_info := p_game_prize_list(i);
  
    ---插入所有奖级
    INSERT INTO gp_prize_rule
      (his_prize_code,
       his_modify_date,
       game_code,
       prule_level,
       prule_name,
       prule_desc,
       level_prize)
    VALUES
      (v_his_code,
       SYSDATE,
       v_cur_prize_info.GAMECODE,
       v_cur_prize_info.RULELEVEL,
       v_cur_prize_info.RULENAME,
       v_cur_prize_info.RULEDESC,
       v_cur_prize_info.RULEAMOUNT);  
  
  END LOOP;

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    c_errorcode := 1;
    --c_errormesg := '数据库异常' || SQLERRM;
    c_errormesg := error_msg.MSG0004 || SQLERRM;
  
END;
/
