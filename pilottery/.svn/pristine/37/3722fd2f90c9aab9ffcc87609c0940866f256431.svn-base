/********************************************************************************/
  ------------------- 适用于批次信息导入序号-----------------------------
  ----针对表GAME_BATCH_IMPORT、AME_BATCH_IMPORT_DETAIL、GAME_BATCH_IMPORT_REWARD
  ----和GAME_BATCH_REWARD_DETAIL的IMPORT_NO字段创建同一序列函数
  ----add by dzg: 2015-9-11
/********************************************************************************/
CREATE OR REPLACE FUNCTION F_GET_BATCH_IMPORT_SEQ
   RETURN VARCHAR2 IS
BEGIN
   return 'IMP-'||lpad(seq_batch_imp.nextval,8,'0');
END;
