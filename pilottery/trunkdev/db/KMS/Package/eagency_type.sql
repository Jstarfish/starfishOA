CREATE OR REPLACE PACKAGE eagency_type IS
   /****** ����վ����(1=��ͳ����վ/2=��ɿ�����վ/3=��ֽ��/4=��������վ) ******/
   traditionalagency        /* 1=��ͳ����վ*/           CONSTANT NUMBER := 1;
   accreditedagency         /* 2=��ɿ�����վ */        CONSTANT NUMBER := 2;
   paperless                /* 3=��ֽ��*/               CONSTANT NUMBER := 3;
   center_agency            /* 4=��������վ*/           CONSTANT NUMBER := 4;
END;
/
