create or replace procedure p_om_tds_issue_draw_notice
/*****************************************************************/
   ----------- 生成json TDS开奖公告 ---------------
   ----- created by chen zhen @ 2016-04-18
/*****************************************************************/

(
   p_game_code    in number,    --游戏编码
   p_issue_number in number,    --期次编码

   c_json         out clob,     --返回值
   c_errorcode    out number,   --业务错误编码
   c_errormesg    out string    --错误信息描述
) is

   tempclob clob;
   tempobj json;
   tempobj_list json_list;

   v_issue_number        iss_game_issue.issue_number%type;
   v_draw_code           iss_game_issue.final_draw_number%type;
   v_sale_amount		 iss_game_issue.issue_sale_amount%type;
   v_winning_amount		 iss_game_issue.winning_amount%type;

begin
  -- 初始化变量
  c_errorcode := 0;

  -- 临时的json和json list变量
  tempobj := json();
  tempobj_list := json_list();

  if p_issue_number = 0 then
     -- 开奖号码
    begin
       select issue_number,final_draw_number, issue_sale_amount, winning_amount
         into v_issue_number, v_draw_code, v_sale_amount, v_winning_amount
         from iss_game_issue
        where issue_number in  (select max(issue_number) from iss_game_issue where game_code = p_game_code and issue_status >= egame_issue_status.issuedatastoragecompleted)
          and game_code = p_game_code;
    exception
       when no_data_found then
       c_errorcode := 11;
       c_errormesg := error_msg.err_p_set_json_issue_draw_n_1;               -- 游戏期次不存在，或者未开奖
       return;
    end;
  else
    v_issue_number := p_issue_number;
  end if;

  begin
    select json_winning_brodcast
      into tempclob
      from iss_game_issue_xml
     where game_code = p_game_code
       and issue_number = v_issue_number;
  exception
     when no_data_found then
     c_errorcode := 12;
     c_errormesg := error_msg.err_p_set_json_issue_draw_n_1;               -- 游戏期次不存在，或者未开奖
     return;
  end;

  if tempclob is null then
     c_errorcode := 13;
     c_errormesg := error_msg.err_p_set_json_issue_draw_n_1;               -- 游戏期次不存在，或者未开奖
     return;
  end if;

  c_json := tempclob;

exception
  when others then
      dbtool.set_dberror(errcode => c_errorcode, errmesg => c_errormesg);

end;