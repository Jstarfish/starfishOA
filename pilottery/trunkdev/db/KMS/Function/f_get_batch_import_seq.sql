/********************************************************************************/
  ------------------- ������������Ϣ�������-----------------------------
  ----��Ա�GAME_BATCH_IMPORT��AME_BATCH_IMPORT_DETAIL��GAME_BATCH_IMPORT_REWARD
  ----��GAME_BATCH_REWARD_DETAIL��IMPORT_NO�ֶδ���ͬһ���к���
  ----add by dzg: 2015-9-11
/********************************************************************************/
CREATE OR REPLACE FUNCTION F_GET_BATCH_IMPORT_SEQ
   RETURN VARCHAR2 IS
BEGIN
   return 'IMP-'||lpad(seq_batch_imp.nextval,8,'0');
END;
