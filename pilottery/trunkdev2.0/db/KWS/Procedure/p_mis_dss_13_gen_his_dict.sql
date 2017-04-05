CREATE OR REPLACE PROCEDURE p_mis_dss_13_gen_his_dict(p_settle_id IN NUMBER) IS
  v_count NUMBER(10);
BEGIN
  -- 保存日结时候的销售站历史
  SELECT COUNT(*)
    INTO v_count
    FROM his_saler_agency
   WHERE settle_id = p_settle_id;
  IF v_count = 0 THEN
    insert into his_saler_agency
      (settle_id,
       agency_code,
       agency_name,
       storetype_id,
       status,
       agency_type,
       bank_id,
       bank_account,
       telephone,
       contact_person,
       address,
       agency_add_time,
       quit_time,
       org_code,
       area_code,
       market_manager_id)
      SELECT p_settle_id,
             agency_code,
             agency_name,
             storetype_id,
             status,
             agency_type,
             bank_id,
             bank_account,
             telephone,
             contact_person,
             address,
             agency_add_time,
             quit_time,
             org_code,
             area_code,
             market_manager_id
        FROM inf_agencys;
    COMMIT;
  END IF;

END;
