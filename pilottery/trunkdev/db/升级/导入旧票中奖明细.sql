create table exp_J0002_15903 (tmp_col VARCHAR2(4000))
ORGANIZATION EXTERNAL
  (TYPE ORACLE_LOADER
   DEFAULT DIRECTORY impdir
   ACCESS PARAMETERS
      (RECORDS DELIMITED BY NEWLINE
       LOAD WHEN (tmp_col != BLANKS)
       fields (
          tmp_col CHAR(4000)
       )
      )
   LOCATION ('J0002_15903_1_0_1_1.dat')
  );

insert into game_batch_reward_detail select 'IMP-X0000001','J0002','15903',tmp_col,0 from exp_J0002_15903;
commit;
drop table exp_J0002_15903;


create table exp_J0003_15904 (tmp_col VARCHAR2(4000))
ORGANIZATION EXTERNAL
  (TYPE ORACLE_LOADER
   DEFAULT DIRECTORY impdir
   ACCESS PARAMETERS
      (RECORDS DELIMITED BY NEWLINE
       LOAD WHEN (tmp_col != BLANKS)
       fields (
          tmp_col CHAR(4000)
       )
      )
   LOCATION ('J0003_15904_1_0_1_1.dat')
  );

insert into game_batch_reward_detail select 'IMP-X0000002','J0003','15904',tmp_col,0 from exp_J0003_15904;
commit;
drop table exp_J0003_15904;

create table exp_J0006_15909 (tmp_col VARCHAR2(4000))
ORGANIZATION EXTERNAL
  (TYPE ORACLE_LOADER
   DEFAULT DIRECTORY impdir
   ACCESS PARAMETERS
      (RECORDS DELIMITED BY NEWLINE
       LOAD WHEN (tmp_col != BLANKS)
       fields (
          tmp_col CHAR(4000)
       )
      )
   LOCATION ('J0006_15909_1_0_1_1.dat')
  );

insert into game_batch_reward_detail select 'IMP-X0000002','J0006','15909',tmp_col,0 from exp_J0006_15909;
commit;
drop table exp_J0006_15909;

create table exp_J2015_00001 (tmp_col VARCHAR2(4000))
ORGANIZATION EXTERNAL
  (TYPE ORACLE_LOADER
   DEFAULT DIRECTORY impdir
   ACCESS PARAMETERS
      (RECORDS DELIMITED BY NEWLINE
       LOAD WHEN (tmp_col != BLANKS)
       fields (
          tmp_col CHAR(4000)
       )
      )
   LOCATION ('J2015_00001_1_0_1_1.dat')
  );

insert into game_batch_reward_detail select 'IMP-X0000002','J2015','00001',tmp_col,0 from exp_J2015_00001;
commit;
drop table exp_J2015_00001;

create table exp_J2015_00002 (tmp_col VARCHAR2(4000))
ORGANIZATION EXTERNAL
  (TYPE ORACLE_LOADER
   DEFAULT DIRECTORY impdir
   ACCESS PARAMETERS
      (RECORDS DELIMITED BY NEWLINE
       LOAD WHEN (tmp_col != BLANKS)
       fields (
          tmp_col CHAR(4000)
       )
      )
   LOCATION ('J2015_00002_1_0_1_1.dat')
  );

insert into game_batch_reward_detail select 'IMP-X0000002','J2015','00002',tmp_col,0 from exp_J2015_00002;
commit;
drop table exp_J2015_00002;

create table exp_J2014_00001 (tmp_col VARCHAR2(4000))
ORGANIZATION EXTERNAL
  (TYPE ORACLE_LOADER
   DEFAULT DIRECTORY impdir
   ACCESS PARAMETERS
      (RECORDS DELIMITED BY NEWLINE
       LOAD WHEN (tmp_col != BLANKS)
       fields (
          tmp_col CHAR(4000)
       )
      )
   LOCATION ('J2014_00001.dat')
  );

insert into game_batch_reward_detail select 'IMP-X0000002','J2014','00001',tmp_col,0 from exp_J2014_00001;
commit;
drop table exp_J2014_00001;









--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create table exp_aixin (tmp_col VARCHAR2(4000))
ORGANIZATION EXTERNAL
  (TYPE ORACLE_LOADER
   DEFAULT DIRECTORY impdir
   ACCESS PARAMETERS
      (RECORDS DELIMITED BY NEWLINE
       LOAD WHEN (tmp_col != BLANKS)
       fields (
          tmp_col CHAR(4000)
       )
      )
   LOCATION ('Aixin_Used.dat')
  );

select * from exp_aixin where tmp_col not in (select safe_code from game_batch_reward_detail where plan_code='J2014' and batch_no='00001')
select tmp_col,count(*) from exp_aixin group by tmp_col having count(*) > 1;
select count(*) from exp_aixin where tmp_col in (select safe_code from game_batch_reward_detail where plan_code='J2014' and batch_no='00001')

update /*+ parallel */ game_batch_reward_detail tab
   set is_paid = 1
 where plan_code='J2014' and batch_no='00001'
   and exists(select 1 from exp_aixin where tab.safe_code = tmp_col);

drop table exp_aixin;

create table exp_dgl (tmp_col VARCHAR2(4000))
ORGANIZATION EXTERNAL
  (TYPE ORACLE_LOADER
   DEFAULT DIRECTORY impdir
   ACCESS PARAMETERS
      (RECORDS DELIMITED BY NEWLINE
       LOAD WHEN (tmp_col != BLANKS)
       fields (
          tmp_col CHAR(4000)
       )
      )
   LOCATION ('DGL_Used.dat')
  );

select * from exp_dgl where tmp_col not in (select substr(safe_code,1,18) from game_batch_reward_detail where plan_code='J0005')

select count(*) from exp_dgl where tmp_col in (select substr(safe_code,1,18) from game_batch_reward_detail where plan_code='J0005')

update /*+ parallel */ game_batch_reward_detail tab
   set is_paid = 1
 where plan_code='J0005'
   and exists(select 1 from exp_dgl where substr(tab.safe_code, 1, 18) = tmp_col);

drop table exp_dgl;


create table exp_gx (tmp_col VARCHAR2(4000))
ORGANIZATION EXTERNAL
  (TYPE ORACLE_LOADER
   DEFAULT DIRECTORY impdir
   ACCESS PARAMETERS
      (RECORDS DELIMITED BY NEWLINE
       LOAD WHEN (tmp_col != BLANKS)
       fields (
          tmp_col CHAR(4000)
       )
      )
   LOCATION ('Gongxi_Used.dat')
  );

select * from exp_gx where tmp_col not in (select substr(safe_code,1,18) from game_batch_reward_detail where plan_code='J0004')

select count(*) from exp_gx where tmp_col in (select substr(safe_code,1,18) from game_batch_reward_detail where plan_code='J0004')

update /*+ parallel */ game_batch_reward_detail tab
   set is_paid = 1
 where plan_code='J0004'
   and exists(select 1 from exp_gx where substr(tab.safe_code, 1, 18) = tmp_col);

drop table exp_gx;

create table exp_iphone (tmp_col VARCHAR2(4000))
ORGANIZATION EXTERNAL
  (TYPE ORACLE_LOADER
   DEFAULT DIRECTORY impdir
   ACCESS PARAMETERS
      (RECORDS DELIMITED BY NEWLINE
       LOAD WHEN (tmp_col != BLANKS)
       fields (
          tmp_col CHAR(4000)
       )
      )
   LOCATION ('XB_Used.dat')
  );

select * from exp_iphone where tmp_col not in (select substr(safe_code,1,18) from game_batch_reward_detail where plan_code = 'J0002' or (plan_code = 'J2015' and batch_no = '00001'));

select count(*) from exp_iphone where tmp_col in (select substr(safe_code,1,18) from game_batch_reward_detail where plan_code = 'J0002' or (plan_code = 'J2015' and batch_no = '00001'));

update /*+ parallel */ game_batch_reward_detail tab
   set is_paid = 1
 where (plan_code = 'J2015' and batch_no = '00001')
   and exists(select 1 from exp_iphone where substr(tab.safe_code, 1, 18) = tmp_col);

update /*+ parallel */ game_batch_reward_detail tab
   set is_paid = 1
 where plan_code = 'J0002'
   and exists(select 1 from exp_iphone where substr(tab.safe_code, 1, 18) = tmp_col);

drop table exp_iphone;


create table exp_ball (tmp_col VARCHAR2(4000))
ORGANIZATION EXTERNAL
  (TYPE ORACLE_LOADER
   DEFAULT DIRECTORY impdir
   ACCESS PARAMETERS
      (RECORDS DELIMITED BY NEWLINE
       LOAD WHEN (tmp_col != BLANKS)
       fields (
          tmp_col CHAR(4000)
       )
      )
   LOCATION ('ball_Used.dat')
  );

select * from exp_ball where tmp_col not in (select substr(safe_code,1,18) from game_batch_reward_detail where plan_code = 'J0003' or (plan_code = 'J2015' and batch_no = '00002'));

select count(*) from exp_ball where tmp_col in (select substr(safe_code,1,18) from game_batch_reward_detail where plan_code = 'J0003' or (plan_code = 'J2015' and batch_no = '00002'));

update /*+ parallel */ game_batch_reward_detail tab
   set is_paid = 1
 where plan_code = 'J0003'
   and exists(select 1 from exp_ball where substr(tab.safe_code, 1, 18) = tmp_col);

update /*+ parallel */ game_batch_reward_detail tab
   set is_paid = 1
 where (plan_code = 'J2015' and batch_no = '00002')
   and exists(select 1 from exp_ball where substr(tab.safe_code, 1, 18) = tmp_col);




select tmp_col,count(*) from exp_aixin group by tmp_col having count(*) > 1;
select tmp_col,count(*) from exp_dgl group by tmp_col having count(*) > 1;
select tmp_col,count(*) from exp_gx group by tmp_col having count(*) > 1;
select tmp_col,count(*) from exp_iphone group by tmp_col having count(*) > 1;
select tmp_col,count(*) from exp_ball group by tmp_col having count(*) > 1;
