set feedback off

--drop user kws cascade;
create user kws identified by oracle default tablespace ts_kws_tab temporary tablespace ts_kws_temp;
grant dba to kws;
grant create any job to kws;
grant execute any class to kws;
grant manage scheduler to kws;

exit;
