CREATE OR REPLACE PACKAGE ebroken_source IS
   /******* ���������±�                                                   ******/
   /*******    2.1.5.16 ��ٵ���wh_broken_recoder��                          ******/
   /*******        ������Դ��1-�˹�¼�룬2-���������ɣ�3-�̵����ɣ�	source  ******/

   manual_input                 /* 1-�˹�¼��   */                  CONSTANT NUMBER := 1;
   trans_bill                   /* 2-���������� */                  CONSTANT NUMBER := 2;
   check_point                  /* 3-�̵�����   */                  CONSTANT NUMBER := 3;
END;
/
