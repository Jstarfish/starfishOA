CREATE OR REPLACE FUNCTION f_get_game_current_issue(p_game_code number)
   RETURN number IS
   v_issue_current number(12);
   v_cnt           number(2);
BEGIN
   begin
      SELECT issue_number
        INTO v_issue_current
        FROM iss_game_issue
       WHERE game_code = p_game_code
         AND real_start_time IS NOT NULL
         AND real_close_time IS NULL;
   exception
      when no_data_found then
         -- 无当前期时，找到最后结束的期次，获取issue_seq号码
         select max(issue_seq)
           into v_issue_current
           from iss_game_issue
          WHERE game_code = p_game_code
            AND real_close_time IS NOT NULL;

         select count(*)
           into v_cnt
           from iss_game_issue
          where game_code = p_game_code
            and issue_seq = v_issue_current + 1;
         if v_cnt <> 0 then
            select issue_number
              into v_issue_current
              from iss_game_issue
             where game_code = p_game_code
               and issue_seq = v_issue_current + 1;
         else
            v_issue_current := 0 - (v_issue_current + 1);
         end if;
   end;

   return v_issue_current;
END;
