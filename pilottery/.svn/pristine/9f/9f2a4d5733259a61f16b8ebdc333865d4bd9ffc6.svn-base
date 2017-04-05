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
    -- modify by kwx @2016-07-05 7天内中大奖前三名大奖信息
    tempobj_list := json_list();
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
