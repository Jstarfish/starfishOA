CREATE OR REPLACE PACKAGE ecp_status IS
   /****** ���������±�                                 ******/
   /******    2.1.5.12 �̵㵥��wh_check_point��           ******/
   /******        �̵�״̬��1-�̵��У�2-�̵������	status ******/

   working                /* 1-�̵���   */                  CONSTANT NUMBER := 1;
   done                   /* 2-�̵���� */                  CONSTANT NUMBER := 2;
END;
/
