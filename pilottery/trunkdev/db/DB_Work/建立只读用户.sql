-- sys �û���¼
create user rouser identified by power;
grant connect to rouser;
grant CREATE SYNONYM to rouser;


-- Taishan�û���¼
begin
   -- ��
   for tab in (select table_name from user_tables) loop
      execute immediate 'grant select on KWS.' || tab.table_name || ' to rouser';
   end loop;

   -- ��ͼ
   for tab in (select view_name from user_views) loop
      execute immediate 'grant select on KWS.' || tab.view_name || ' to rouser';
   end loop;
end;
/

-- rouser�û���¼
begin
   -- ��
   for tab in (select owner,table_name from dba_tables where owner = 'KWS') loop
      dbms_output.put_line('create or replace synonym ' || tab.table_name || ' for ' || tab.owner || '.' || tab.table_name||';');
   end loop;

   -- ��ͼ
   for tab in (select owner, view_name as table_name from dba_views where owner = 'KWS') loop
      dbms_output.put_line('create or replace synonym ' || tab.table_name || ' for ' || tab.owner || '.' || tab.table_name||';');
   end loop;
end;
