CREATE OR REPLACE PACKAGE ewarehouse_status IS
   /****** ״̬��1-���ã�2-ͣ�ã�3-�̵��У� ******/
   working                 /* 1-���� */                  CONSTANT NUMBER := 1;
   stoped                  /* 2-ͣ�� */                  CONSTANT NUMBER := 2;
   checking                /* 3-�̵��� */                CONSTANT NUMBER := 3;
END;
/
