CREATE OR REPLACE PACKAGE eaccount_type IS
   /****** ���������±�(�˻����ͣ�1-������2-վ�㣩	account_type)  ******/
   /******    2.1.9.1 ����վ�����������ĳ�ֵ��fund_charge_center��   ******/
   /******    2.1.9.2 ����վ���������ֽ��ֵ��FUND_CHARGE_CASH��     ******/
   /******    2.1.9.3 ����վ�����������֣�FUND_WITHDRAW��            ******/
   /******    2.1.9.4 ����վ�����������ˣ�FUND_TUNING��              ******/

   org                      /* 1-���� */                  CONSTANT NUMBER := 1;
   agency                   /* 2-վ�� */                  CONSTANT NUMBER := 2;
END;
/
