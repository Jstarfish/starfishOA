CREATE OR REPLACE PACKAGE eticket_status IS
   /****** ��ٵ�-���ԭ��41-������42-�𻵡�43-��ʧ�� ******/
   /****** ״̬��11-�ڿ⡢12-��վ�㣬20-��;��31-�����ۡ�41-������42-�𻵡�43-��ʧ�� ******/
   in_warehouse         /* 11-�ڿ� */                  CONSTANT NUMBER := 11;
   in_agency            /* 12-��վ�� */                CONSTANT NUMBER := 12;
   on_way               /* 20-��; */                  CONSTANT NUMBER := 20;
   in_mm                /* 21-����Ա���� */            CONSTANT NUMBER := 21;
   saled                /* 31-������ */                CONSTANT NUMBER := 31;
   stolen               /* 41-���� */                  CONSTANT NUMBER := 41;
   broken               /* 42-�� */                  CONSTANT NUMBER := 42;
   lost                 /* 43-��ʧ */                  CONSTANT NUMBER := 43;
END;

