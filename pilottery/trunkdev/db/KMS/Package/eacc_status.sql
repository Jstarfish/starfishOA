CREATE OR REPLACE PACKAGE eacc_status IS
   /****** �˻�״̬��1-���ã�2-ͣ�ã�3-�쳣�� ******/
   available                /* 1-���� */                  CONSTANT NUMBER := 1;
   stoped                   /* 2-ͣ�� */                  CONSTANT NUMBER := 2;
   abnormal                 /* 3-�쳣 */                  CONSTANT NUMBER := 3;
END;
/
