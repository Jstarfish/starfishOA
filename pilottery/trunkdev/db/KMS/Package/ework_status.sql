CREATE OR REPLACE PACKAGE ework_status IS
   /****** ���������±�                                                 ******/
   /****** ���ⵥ��wh_goods_issue��   ״̬��1-δ��ɣ�2-����ɣ�	status  ******/
   /****** ��Ʒ��⣨item_receipt��   ״̬��1-δ��ɣ�2-����ɣ�	status  ******/
   /****** ��ⵥ��WH_GOODS_RECEIPT(STATUS)                               ******/
   /****** ״̬��1-δ��ɣ�2-����ɣ� ******/
   working                /* 1-δ��� */                  CONSTANT NUMBER := 1;
   done                   /* 2-����� */                  CONSTANT NUMBER := 2;
END;
/
