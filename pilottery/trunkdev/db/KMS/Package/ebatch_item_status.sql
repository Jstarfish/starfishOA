CREATE OR REPLACE PACKAGE ebatch_item_status IS
   /****** ���������±�                                                                              ******/
   /******    2.1.4.5 ������Ϣ����֮��װ��GAME_BATCH_IMPORT_DETAIL��   ״̬��1-���ã�2-��ͣ��3-���У�	status   ******/
   /******    2.1.10.1 ��Ʒ��item_items��                              ״̬��1-���ã�2-��ͣ��3-���У�	status   ******/

   /****** ״̬��1-���ã�2-ͣ�ã� ******/
   working                   /* 1-���� */                  CONSTANT NUMBER := 1;
   pause                     /* 2-��ͣ */                  CONSTANT NUMBER := 2;
   quited                    /* 3-���� */                  CONSTANT NUMBER := 3;
END;
/
