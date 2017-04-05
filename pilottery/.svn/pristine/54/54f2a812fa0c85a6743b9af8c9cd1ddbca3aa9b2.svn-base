select 'update saler_terminal set mac_address=''' where agency_code=''

set serveroutput on
declare
  v_agency inf_agencys%rowtype;

  v_old_agency inf_agencys.agency_code%type;
  v_new_agency inf_agencys.agency_code%type;

  type array_string is varray(50) of varchar2(1000);

  agency_list array_string;

  single_string varchar2(1000);

  v_count number(10);

begin
  agency_list := array_string('01069001#01060158','01069002#01060166','01079001#01070115','01079002#01070130','01079003#01070227','01019001#01010029','01019002#01010030','01019003#01010033','01019004#01010040','01029001#01020057','01059001#01050023','01139001#01130040','01119001#01110031','01119002#01110039','01119003#01110046','01119004#01110084','01119005#01110130','01119006#01110171','01119007#01110175','01119008#01110176','01039001#01030130','01089001#01080030','01089002#01080151','01089003#01080181','01129001#01120039','01069003#01060174','01069004#01060001','01119009#01110160','01119010#01110174','01119011#01110189','01049001#01040042','01119012#01110184','01109001#01100050','01139002#01130047','01119013#01110177','01069005#01060182');

  for v_loop in 1 .. agency_list.count loop
    single_string := agency_list(v_loop);

    v_count := 0;
    for tab in (select column_value,rownum from table(dbtool.strsplit(single_string,'#'))) loop
      if tab.rownum = 1 then
        v_new_agency := tab.column_value;
      end if;
      if tab.rownum = 2 then
        v_old_agency := tab.column_value;
      end if;
    end loop;

    begin
      select * into v_agency from inf_agencys where agency_code = v_old_agency;
    exception
      when no_data_found then
        dbms_output.put_line(v_old_agency || ' not FOUND');
        continue;
    end;

    dbms_output.put_line('[' || v_old_agency || '] ...... ');

    insert into inf_agencys
      (agency_code, agency_name, storetype_id, status, agency_type, bank_id, bank_account, telephone, contact_person, address, agency_add_time, quit_time, org_code, area_code, login_pass, trade_pass, market_manager_id)
    select
       v_new_agency agency_code, '[*]' || agency_name, storetype_id, status, agency_type, bank_id, bank_account, telephone, contact_person, address, agency_add_time, quit_time, org_code, area_code, login_pass, trade_pass, market_manager_id
      from inf_agencys
     where agency_code = v_old_agency;

    insert into inf_agency_ext
      (agency_code, personal_id, contract_no, glatlng_n, glatlng_e)
    select v_new_agency agency_code, personal_id, contract_no, glatlng_n, glatlng_e from inf_agency_ext where agency_code = v_old_agency;

    insert into inf_tellers
      (teller_code,
       agency_code,
       teller_name,
       teller_type,
       status,
       password)
    values
      (to_number(v_new_agency),
       v_new_agency,
       v_agency.contact_person,
       eteller_type.manager,
       eteller_status.enabled,
       '96e79218965eb72c92a549dd5a330112');

    insert into acc_agency_account
      (agency_code,
       acc_type,
       acc_name,
       acc_status,
       acc_no,
       credit_limit,
       account_balance,
       frozen_balance,
       check_code)
    values
      (v_new_agency,
       eacc_type.main_account,
       v_agency.agency_name,
       eacc_status.available,
       f_get_acc_no(v_new_agency, 'ZD'),
       0,
       0,
       0,
       '-');

    INSERT INTO saler_terminal
      (terminal_code,
       agency_code,
       unique_code,
       term_type_id,
       mac_address,
       status)
    VALUES
      (v_new_agency || '01',
       v_new_agency,
       v_new_agency || '01',
       1,
       upper('00:00:00:00:00:00'),
       1);

    --插入终端版本
    INSERT INTO upg_term_software
      (terminal_code, term_type, running_pkg_ver, downing_pkg_ver)
    VALUES
      (v_new_agency || '01', 1, '1.1.00', '-');

    dbms_output.put_line('[' || v_new_agency || ']');

  end loop;

  -- 原来属于代理商下的站点，新建电脑票之后，会隶属于分公司
  update inf_agencys
     set org_code='09'        -- 金边分一
   where agency_code in ('01069004','01069001','01069003','01069002','01069005');

  update inf_agencys
     set org_code='10'        -- 金边分三
   where agency_code in ('01119001','01119002','01119003','01119004','01119005','01119006','01119007','01119008','01119009','01119010','01119013','01119011','01119012');


/*******************************************************************************************************************************/

  -- 现金票销售站
  agency_list := array_string('01070191','01100089','01130001','01130004','01120002','01070244','01070205','01120049','01130046','01020001');
  for v_loop in 1 .. agency_list.count loop
    v_old_agency := agency_list(v_loop);

    begin
      select * into v_agency from inf_agencys where agency_code = v_old_agency;
    exception
      when no_data_found then
        dbms_output.put_line(v_old_agency || ' not FOUND');
        continue;
    end;

    /*
    insert into auth_agency
      (agency_code, game_code, pay_commission_rate, sale_commission_rate, allow_pay, allow_sale, allow_cancel, claiming_scope)
    select
      v_old_agency, game_code, 0, 70, 1, 1, 0, 0
    from inf_games;
    */
    update auth_agency set sale_commission_rate = 70, allow_pay = 1, allow_sale = 1, claiming_scope = 0 where agency_code = v_old_agency;

    INSERT INTO saler_terminal
      (terminal_code,
       agency_code,
       unique_code,
       term_type_id,
       mac_address,
       status)
    VALUES
      (v_old_agency || '01',
       v_old_agency,
       v_old_agency || '01',
       1,
       upper('00:00:00:00:00:00'),
       1);

    --插入终端版本
    INSERT INTO upg_term_software
      (terminal_code, term_type, running_pkg_ver, downing_pkg_ver)
    VALUES
      (v_old_agency || '01', 1, '1.1.00', '-');
    insert into inf_tellers
      (teller_code,
       agency_code,
       teller_name,
       teller_type,
       status,
       password)
    values
      (to_number(v_old_agency),
       v_old_agency,
       v_agency.contact_person,
       eteller_type.manager,
       eteller_status.enabled,
       '96e79218965eb72c92a549dd5a330112');

  end loop;
end;
/


update saler_terminal set mac_address=upper('00:0b:ab:6a:49:d4') where agency_code='01069004';
update saler_terminal set mac_address=upper('00:0B:AB:6C:61:A5') where agency_code='01069001';
update saler_terminal set mac_address=upper('00:0b:ab:6b:66:05') where agency_code='01069003';
update saler_terminal set mac_address=upper('00:0B:AB:67:33:74') where agency_code='01069002';
update saler_terminal set mac_address=upper('00:0B:AB:67:33:A4') where agency_code='01069005';
update saler_terminal set mac_address=upper('00:0b:ab:6a:49:40') where agency_code='01119001';
update saler_terminal set mac_address=upper('00:0b:ab:6b:65:af') where agency_code='01119002';
update saler_terminal set mac_address=upper('00:0b:ab:6b:66:07') where agency_code='01119003';
update saler_terminal set mac_address=upper('00:0B:AB:6C:61:5B') where agency_code='01119004';
update saler_terminal set mac_address=upper('00:0b:ab:6b:64:d9') where agency_code='01119005';
update saler_terminal set mac_address=upper('00:0B:AB:67:33:B8') where agency_code='01119006';
update saler_terminal set mac_address=upper('00:0b:ab:6a:48:86') where agency_code='01119007';
update saler_terminal set mac_address=upper('00:0B:AB:6A:4A:7E') where agency_code='01119008';
update saler_terminal set mac_address=upper('00:0b:ab:6a:4a:6e') where agency_code='01119009';
update saler_terminal set mac_address=upper('00:0b:ab:6b:64:21') where agency_code='01119010';
update saler_terminal set mac_address=upper('00:0B:AB:6B:66:0B') where agency_code='01119013';
update saler_terminal set mac_address=upper('00:0b:ab:6a:4a:29') where agency_code='01119011';
update saler_terminal set mac_address=upper('00:0B:AB:6A:48:14') where agency_code='01119012';
update saler_terminal set mac_address=upper('00:0B:AB:6A:4B:14') where agency_code='01079001';
update saler_terminal set mac_address=upper('00:0B:AB:6A:49:94') where agency_code='01079002';
update saler_terminal set mac_address=upper('00:0B:AB:6B:63:E3') where agency_code='01070191';
update saler_terminal set mac_address=upper('00:0B:AB:6B:66:55') where agency_code='01079003';
update saler_terminal set mac_address=upper('00:0B:AB:6A:4A:94') where agency_code='01100089';
update saler_terminal set mac_address=upper('00:0b:ab:6a:4a:78') where agency_code='01019001';
update saler_terminal set mac_address=upper('00:0B:AB:6A:4A:AE') where agency_code='01019002';
update saler_terminal set mac_address=upper('00:0B:AB:6B:9D:A1') where agency_code='01019003';
update saler_terminal set mac_address=upper('00:0B:AB:6A:48:06') where agency_code='01019004';
update saler_terminal set mac_address=upper('00:0B:AB:6B:65:F3') where agency_code='01029001';
update saler_terminal set mac_address=upper('00:0b:ab:6c:61:3d') where agency_code='01059001';
update saler_terminal set mac_address=upper('00:0B:AB:6C:60:D7') where agency_code='01130001';
update saler_terminal set mac_address=upper('00:0B:AB:6A:4A:70') where agency_code='01130004';
update saler_terminal set mac_address=upper('00:0b:ab:6b:63:eb') where agency_code='01139001';
update saler_terminal set mac_address=upper('00:0b:ab:6a:49:fa') where agency_code='01039001';
update saler_terminal set mac_address=upper('00:0b:ab:6b:64:51') where agency_code='01089001';
update saler_terminal set mac_address=upper('00:0b:ab:6c:60:fd') where agency_code='01089002';
update saler_terminal set mac_address=upper('00:0B:AB:5B:F6:E3') where agency_code='01089003';
update saler_terminal set mac_address=upper('00:0b:ab:6b:66:33') where agency_code='01120002';
update saler_terminal set mac_address=upper('00:0b:ab:6b:66:43') where agency_code='01129001';
update saler_terminal set mac_address=upper('00:0b:ab:6a:48:90') where agency_code='01120049';
update saler_terminal set mac_address=upper('00:0b:ab:6a:4a:d8') where agency_code='01070205';
update saler_terminal set mac_address=upper('00:0b:ab:6c:61:03') where agency_code='01070244';
update saler_terminal set mac_address=upper('00:0b:ab:6a:4a:b6') where agency_code='01049001';
update saler_terminal set mac_address=upper('00:0B:AB:6C:60:AB') where agency_code='01130046';
update saler_terminal set mac_address=upper('00:0B:AB:6A:4A:88') where agency_code='01109001';
update saler_terminal set mac_address=upper('00:0B:AB:67:32:EF') where agency_code='01020001';
update saler_terminal set mac_address=upper('00:0B:AB:6C:60:E7') where agency_code='01139002';


prompt Importing table inf_agency_ext...
set feedback off
set define off
insert into inf_agency_ext (AGENCY_CODE, PERSONAL_ID, CONTRACT_NO, GLATLNG_N, GLATLNG_E)
values ('01149001', '123', '111', null, null);

prompt Done.
prompt Importing table auth_agency...
set feedback off
set define off
insert into auth_agency (AGENCY_CODE, GAME_CODE, PAY_COMMISSION_RATE, SALE_COMMISSION_RATE, ALLOW_PAY, ALLOW_SALE, ALLOW_CANCEL, CLAIMING_SCOPE, AUTH_TIME)
values ('01149001', 12, 0, 0, 1, 1, 0, 0, to_date('22-06-2016 14:36:40', 'dd-mm-yyyy hh24:mi:ss'));

prompt Done.
prompt Importing table acc_agency_account...
set feedback off
set define off
insert into acc_agency_account (AGENCY_CODE, ACC_TYPE, ACC_NAME, ACC_STATUS, ACC_NO, CREDIT_LIMIT, ACCOUNT_BALANCE, FROZEN_BALANCE, CHECK_CODE)
values ('01149001', 1, '直营2店', 1, 'ZD0114001201', 0, 0, 0, '-');

prompt Done.
prompt Importing table upg_term_software...
set feedback off
set define off
insert into upg_term_software (TERMINAL_CODE, TERM_TYPE, RUNNING_PKG_VER, DOWNING_PKG_VER, LAST_UPGRADE_DATE, LAST_REPORT_DATE)
values ('0114900101', 1, '1.1.01', '-', null, to_date('28-06-2016 17:23:20', 'dd-mm-yyyy hh24:mi:ss'));

prompt Done.
prompt Importing table saler_terminal...
set feedback off
set define off
insert into saler_terminal (TERMINAL_CODE, AGENCY_CODE, UNIQUE_CODE, TERM_TYPE_ID, MAC_ADDRESS, SECURITY_ID, STATUS, TERMINAL_FOR_PAYMENT, IS_LOGGING, LATEST_LOGIN_TELLER_CODE, TRANS_SEQ)
values ('0114900101', '01149001', '0114900101', 1, '00:0B:AB:6A:48:4C', null, 1, 0, 1, 1149001, 1);

prompt Done.
prompt Importing table inf_tellers...
set feedback off
set define off
insert into inf_tellers (TELLER_CODE, AGENCY_CODE, TELLER_NAME, TELLER_TYPE, STATUS, PASSWORD, LATEST_TERMINAL_CODE, LATEST_SIGN_ON_TIME, LATEST_SIGN_OFF_TIME, IS_ONLINE)
values (1149001, '01149001', 'Buth', 2, 1, '9439aefd6282b638796f6ad26e44b159', '0114900101', to_date('28-06-2016 16:53:09', 'dd-mm-yyyy hh24:mi:ss'), to_date('28-06-2016 16:53:09', 'dd-mm-yyyy hh24:mi:ss'), 1);

prompt Done.
prompt Importing table inf_agencys...
set feedback off
set define off
insert into inf_agencys (AGENCY_CODE, AGENCY_NAME, STORETYPE_ID, STATUS, AGENCY_TYPE, BANK_ID, BANK_ACCOUNT, TELEPHONE, CONTACT_PERSON, ADDRESS, AGENCY_ADD_TIME, QUIT_TIME, ORG_CODE, AREA_CODE, LOGIN_PASS, TRADE_PASS, MARKET_MANAGER_ID)
values ('01149001', '直营2店', 61, 1, 1, null, null, '12332455', 'Buth', null, to_date('22-06-2016 13:38:53', 'dd-mm-yyyy hh24:mi:ss'), null, '08', '0114', '96e79218965eb72c92a549dd5a330112', '96e79218965eb72c92a549dd5a330112', 251);

prompt Done.
