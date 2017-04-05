CREATE OR REPLACE FUNCTION f_get_right_issue(p_game_code number, p_issue_seq number)
   RETURN number IS
   v_issue_current number(12);
   v_cnt           number(2);
BEGIN
   if p_issue_seq >= 0 then
      return p_issue_seq;
   end if;
   begin
      SELECT issue_number
        INTO v_issue_current
        FROM iss_game_issue
       WHERE game_code = p_game_code
         AND issue_seq = abs(p_issue_seq)
         and issue_status > egame_issue_status.prearrangement;
   exception
      when no_data_found then
         v_issue_current := p_issue_seq;
   end;

   return v_issue_current;
END;
