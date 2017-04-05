create or replace procedure p_set_issue_status
/**************************************************************/
  ------------------适用于:主机更新期次状态 -------------------
  -- modify by Chen Zhen @ 2016-09-20
  -- 增加向CNCP发送消息的部分。消息通过job实现，不影响主要流程。
  /*************************************************************/
(
 --------------输入----------------
 p_game_code    in number, --游戏编码
 p_issue_number in number, --期次编码
 p_status       in number, --期次状态
 p_hosttime     in date, --主机时间
 ---------出口参数---------
 c_errorcode out number, --业务错误编码
 c_errormesg out string --错误信息描述
 ) is

  v_temp_count     number := 0; --临时数据用于验证初始化
  v_draw_limit_day number(10); --兑奖期限（设置值）

  v_pool_amount_before number(18); --奖池调整前的金额
  v_pool_amount_after  number(18); --奖池调整后的金额
  v_adj_amount_before  number(18); --调节基金调整前的金额
  v_adj_amount_after   number(18); --调节基金调整后的金额

  v_now_date date;
  v_rest_day number(10);

begin
  --初始化数据
  dbtool.set_success(errcode => c_errorcode, errmesg => c_errormesg);

  ------------校验有效性
  -----状态有效性校验
  if p_status < 0 or p_status > egame_issue_status.issuecompleted then
    c_errorcode := 1;
    c_errormesg := '输入的期次状态无效！';
    return;
  end if;

  -----期次数据有效性校验
  select count(iss_game_issue.issue_number)
    into v_temp_count
    from iss_game_issue
   where iss_game_issue.game_code = p_game_code
     and iss_game_issue.issue_number = p_issue_number
     and iss_game_issue.issue_status < egame_issue_status.issuecompleted;

  if v_temp_count <= 0 then
    c_errorcode := 1;
    c_errormesg := '期次不存在或期次已完结！';
    return;
  end if;

  if v_temp_count > 1 then
    c_errorcode := 1;
    c_errormesg := '系统中存在重复的期次！';
    return;
  end if;

  --------------- 更新开奖状态
  case p_status
  --期次开始，更新实际开始时间
    when egame_issue_status.issueopen then
      update iss_game_issue g
         set g.real_start_time = p_hosttime, g.issue_status = p_status
       where g.game_code = p_game_code
         and g.issue_number = p_issue_number;
    
    
  --更新期次实际结束时间
    when egame_issue_status.issueclosed then
      update iss_game_issue g
         set g.real_close_time = p_hosttime, g.issue_status = p_status
       where g.game_code = p_game_code
         and g.issue_number = p_issue_number;
    
      
  --更新期次实际开奖时间,输入开奖号码时间
  -- 2014.7.7 陈震 增加计算弃奖时间
    when egame_issue_status.enteringdrawcodes then
      -- 根据期次，获取政策参数中的“兑奖期”
      begin
        select draw_limit_day
          into v_draw_limit_day
          from gp_policy
         where his_policy_code =
               (select distinct his_policy_code
                  from iss_current_param
                 where game_code = p_game_code
                   and issue_number = p_issue_number)
           and game_code = p_game_code;
      exception
        when no_data_found then
          c_errorcode := 1;
          c_errormesg := '无法获取“政策参数”中的“兑奖期”！';
          rollback;
          return;
      end;
      if v_draw_limit_day is null then
        c_errorcode := 1;
        c_errormesg := '无法获取“政策参数”中的“兑奖期”！';
        rollback;
        return;
      end if;
    
      -- 根据当前日期，检查是否有节假日顺延设置
      -- 1、确定当前日期是否在节假日设置中；
      -- 2、循环数日期，确定一个计数器。遇到节假日时，跳过不累计，直到累计数达到兑奖期的数字
      select trunc(sysdate, 'dd') into v_now_date from dual;
      v_rest_day := v_draw_limit_day;
      for tab_delay in (select h_day_start, h_day_end
                          from sys_calendar
                         where h_day_code >=
                               (select min(h_day_code)
                                  from sys_calendar
                                 where h_day_start > v_now_date)) loop
        v_rest_day := v_rest_day - (tab_delay.h_day_start - 1 - v_now_date);
        if v_rest_day = 0 then
          v_now_date := tab_delay.h_day_start - 1;
          exit;
        end if;
      
        if v_rest_day < 0 then
          v_now_date := tab_delay.h_day_start - 1 + v_rest_day;
          exit;
        end if;
      
        v_now_date := tab_delay.h_day_end;
      end loop;
      if v_rest_day > 0 then
        v_now_date := v_now_date + v_rest_day;
      end if;
    
      -- 计算弃奖日期，写入 "兑奖截止日期（天） pay_end_day"
      update iss_game_issue g
         set g.real_reward_time = p_hosttime,
             g.issue_status     = p_status,
             g.pay_end_day      = to_number(to_char(v_now_date, 'yyyymmdd'))
       where g.game_code = p_game_code
         and g.issue_number = p_issue_number;
    
    
  --期次封存，初始化数据
    when egame_issue_status.issuesealed then
      update iss_game_issue g
         set g.draw_state           = edraw_state.edraw_ready,
             g.issue_status         = p_status,
             g.first_draw_number    = null,
             g.first_draw_user_id   = null,
             g.code_input_methold   = null,
             g.second_draw_number   = null,
             g.second_draw_user_id  = null,
             g.final_draw_number    = null,
             g.final_draw_user_id   = null,
             g.rewarding_error_code = null,
             g.rewarding_error_mesg = null,
             g.pool_start_amount    = null
       where g.game_code = p_game_code
         and g.issue_number = p_issue_number;
    
  --期次状态:本地算奖完成; 开奖状态:派奖检索完成
    when egame_issue_status.localprizecalculationdone then
      update iss_game_issue g
         set g.draw_state   = edraw_state.edraw_prize_collected,
             g.issue_status = p_status
       where g.game_code = p_game_code
         and g.issue_number = p_issue_number;
    
  --期次状态:奖级调整完毕; 开奖状态:中奖统计完成
    when egame_issue_status.prizeleveladjustmentdone then
      update iss_game_issue g
         set g.draw_state   = edraw_state.edraw_prize_stated,
             g.issue_status = p_status
       where g.game_code = p_game_code
         and g.issue_number = p_issue_number;
    
  --期次状态:期结完成; 开奖状态:开奖完成
  --modify by dzg 2014-6-19 修订增加更新期结时间
  --modify by 陈震 2014-07-08 手工修改奖池生效
    when egame_issue_status.issuecompleted then
      update iss_game_issue g
         set g.draw_state     = edraw_state.edraw_draw_finish,
             g.issue_end_time = p_hosttime,
             g.issue_status   = p_status
       where g.game_code = p_game_code
         and g.issue_number = p_issue_number;
    
      -- 针对未生效的奖池调整
      for tab_pool_adj in (select pool_flow,
                                  pool_adj_type,
                                  adj_amount,
                                  adj_desc
                             from iss_game_pool_adj
                            where game_code = p_game_code
                              and pool_code = 0
                              and is_adj = eboolean.noordisabled) loop
        -- 更新奖池余额
        -- 更新奖池余额，同时获得调整之前和之后的奖池余额
        update iss_game_pool
           set pool_amount_before = pool_amount_after,
               pool_amount_after  = pool_amount_after +
                                    tab_pool_adj.adj_amount,
               adj_time           = sysdate
         where game_code = p_game_code
           and pool_code = 0
        returning pool_amount_before, pool_amount_after into v_pool_amount_before, v_pool_amount_after;
      
        -- 加奖池流水
        insert into iss_game_pool_his
          (his_code,
           game_code,
           issue_number,
           pool_code,
           change_amount,
           pool_amount_before,
           pool_amount_after,
           adj_time,
           pool_adj_type,
           adj_reason,
           pool_flow)
        values
          (f_get_game_his_code_seq,
           p_game_code,
           p_issue_number,
           0,
           tab_pool_adj.adj_amount,
           v_pool_amount_before,
           v_pool_amount_after,
           sysdate,
           tab_pool_adj.pool_adj_type,
           tab_pool_adj.adj_desc,
           tab_pool_adj.pool_flow);
      
        /*----------- 针对变更类型做后续的事情 -----------------*/
        case tab_pool_adj.pool_adj_type
          when epool_change_type.in_issue_pool_manual then
            -- 类型为 4、调节基金手动拨入
            -- 修改余额，同时获得调整之前余额和调整之后余额
            update adj_game_current
               set pool_amount_before = pool_amount_after,
                   pool_amount_after  = pool_amount_after +
                                        tab_pool_adj.adj_amount
             where game_code = p_game_code
            returning pool_amount_before, pool_amount_after into v_adj_amount_before, v_adj_amount_after;
          
            -- 插入调整历史
            insert into adj_game_his
              (his_code,
               game_code,
               issue_number,
               adj_change_type,
               adj_amount,
               adj_amount_before,
               adj_amount_after,
               adj_time)
            values
              (f_get_game_his_code_seq,
               p_game_code,
               p_issue_number,
               eadj_change_type.out_issue_pool_manual,
               tab_pool_adj.adj_amount,
               v_adj_amount_before,
               v_adj_amount_after,
               sysdate)
            returning adj_amount_after into v_adj_amount_after;
          
          when epool_change_type.in_commission then
            -- 类型为 5、发行费手动拨入
            insert into gov_commision
              (his_code,
               game_code,
               issue_number,
               comm_change_type,
               adj_amount,
               adj_amount_before,
               adj_amount_after,
               adj_time,
               adj_reason)
            values
              (f_get_game_his_code_seq,
               p_game_code,
               p_issue_number,
               ecomm_change_type.out_to_pool,
               tab_pool_adj.adj_amount,
               nvl((select adj_amount_after
                     from gov_commision
                    where game_code = p_game_code
                      and his_code =
                          (select max(his_code)
                             from gov_commision
                            where game_code = p_game_code)),
                   0),
               nvl((select adj_amount_after
                     from gov_commision
                    where game_code = p_game_code
                      and his_code =
                          (select max(his_code)
                             from gov_commision
                            where game_code = p_game_code)),
                   0) - tab_pool_adj.adj_amount,
               sysdate,
               tab_pool_adj.adj_desc);
        end case;
      end loop;
    
  --默认状态
    else
      update iss_game_issue g
         set g.issue_status = p_status
       where g.game_code = p_game_code
         and g.issue_number = p_issue_number;
  end case;

  commit;

exception
  when others then
    rollback;
    dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);
end;
