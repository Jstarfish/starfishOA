-- sys 用户登录
create user rouser identified by power;
grant connect to rouser;
grant CREATE SYNONYM to rouser;

create user kro identified by oracle;
grant connect to kro;
grant CREATE SYNONYM to kro;

-- KWS 用户登录
begin
   -- 表
   for tab in (select table_name from user_tables) loop
      execute immediate 'grant select on KWS.' || tab.table_name || ' to rouser';
   end loop;

   -- 视图
   for tab in (select view_name from user_views) loop
      execute immediate 'grant select on KWS.' || tab.view_name || ' to rouser';
   end loop;
end;
/

-- rouser用户登录
begin
   -- 表
   for tab in (select owner,table_name from dba_tables where owner = 'KWS') loop
      execute immediate 'create or replace synonym ' || tab.table_name || ' for ' || tab.owner || '.' || tab.table_name;
   end loop;

   -- 视图
   for tab in (select owner, view_name as table_name from dba_views where owner = 'KWS') loop
      execute immediate  'create or replace synonym ' || tab.table_name || ' for ' || tab.owner || '.' || tab.table_name;
   end loop;
end;
/
