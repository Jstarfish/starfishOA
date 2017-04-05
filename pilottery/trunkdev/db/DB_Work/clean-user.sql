set feedback off
set serveroutput on
prompt Ëø¶¨KWSÓÃ»§
declare
   cnt         number(4);
   v_username  varchar2(100);
begin
   v_username := 'KWS';
   select count(*) into cnt from dba_users where username=v_username;
   if cnt > 0 then
      execute immediate 'alter user ' || v_username || ' account lock';
   end if;

   loop
      select count(*) into cnt from gv$session where username = v_username;
      if cnt = 0 then
         exit;
      end if;

      for ii in (select 'alter system kill session '''||sid||','||serial#||',@'||inst_id||''' immediate' as yj from gv$session where username = v_username) loop
         --dbms_output.put_line(ii.yj);
         begin
            execute immediate ii.yj;
         exception
            when others then
               dbms_output.put_line('err '||ii.yj ||' '|| sqlerrm);
         end;
      end loop;

      dbms_lock.sleep(3);
   end loop;

   select count(*) into cnt from dba_users where username=v_username;
   if cnt > 0 then
      execute immediate 'drop user ' || v_username || ' cascade';
   end if;

end;
/

exit;
