CREATE OR REPLACE PACKAGE eapply_status IS
   /****** �����¼״̬��1=���ύ��2=�ѳ�����3=����ˡ�4=�Ѿܾ���6-�����֡�7=�ɿ�ɹ��� ******/
   /****** �����ڱ� ����վ���������ֽ��ֵ��fund_charge_cash�� �� ����վ�����������֣�fund_withdraw�� ******/
   applyed                  /* 1=���ύ */                  CONSTANT NUMBER := 1;
   canceled                 /* 2=�ѳ��� */                  CONSTANT NUMBER := 2;
   audited                  /* 3=����� */                  CONSTANT NUMBER := 3;
   resused                  /* 4=�Ѿܾ� */                  CONSTANT NUMBER := 4;
   withdraw                 /* 6-������ */                  CONSTANT NUMBER := 6;
   charged                  /* 7=�ɿ�ɹ� */                CONSTANT NUMBER := 7;
END;
/
