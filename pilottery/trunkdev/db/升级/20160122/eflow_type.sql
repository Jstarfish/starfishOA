CREATE OR REPLACE PACKAGE eflow_type IS
   /****** �ṩ�����±�ʹ�ã� ******/
   /******     �����ʽ���ˮ��flow_org��                  ******/
   /******     վ���ʽ���ˮ��flow_agency��               ******/
   /******     �г�����Ա�ʽ���ˮ��flow_market_manager�� ******/
   /****** �ʽ����ͣ�1-��ֵ��2-���֣�3-��Ʊ������4-����Ӷ��ר���������������5-����Ӷ��6-�ҽ�Ӷ��7-���ۣ�8-�ҽ���9-Ϊվ���ֵ��10-�ֽ��Ͻɣ�11-վ���˻���12-�����˻���13-����Ӷ��14-�г�����ԱΪվ������  ******/
   /******           21-����Ӷ��֮������ϸ��22-����Ӷ��֮�ҽ���ϸ��23-����Ӷ��֮��Ʊ��ϸ��31-�˻���Ӷ��֮�����˻��� add @2016-01-22 by chenzhen ******/

   charge                       /* 1-��ֵ       */                  CONSTANT NUMBER := 1;
   withdraw                     /* 2-����       */                  CONSTANT NUMBER := 2;
   carry                        /* 3-��Ʊ����   */                  CONSTANT NUMBER := 3;
   org_comm                     /* 4-����Ӷ��ר������������� */  CONSTANT NUMBER := 4;
   sale_comm                    /* 5-����Ӷ��   */                  CONSTANT NUMBER := 5;
   pay_comm                     /* 6-�ҽ�Ӷ��   */                  CONSTANT NUMBER := 6;
   sale                         /* 7-����       */                  CONSTANT NUMBER := 7;
   paid                         /* 8-�ҽ�       */                  CONSTANT NUMBER := 8;
   charge_for_agency            /* 9-�г�����ԱΪվ���ֵ */        CONSTANT NUMBER := 9;
   fund_return                  /* 10-�ֽ��Ͻ�  */                  CONSTANT NUMBER := 10;
   agency_return                /* 11-վ���˻�  */                  CONSTANT NUMBER := 11;
   org_return                   /* 12-�����˻�  */                  CONSTANT NUMBER := 12;
   cancel_comm                  /* 13-����Ӷ��  */                  CONSTANT NUMBER := 13;
   withdraw_for_agency          /* 14-�г�����ԱΪվ������ */       CONSTANT NUMBER := 14;

   org_comm_agency_sale         /* 21-����Ӷ��֮������ϸ    */      CONSTANT NUMBER := 21;
   org_comm_pay                 /* 22-����Ӷ��֮�ҽ���ϸ    */      CONSTANT NUMBER := 22;
   org_comm_agency_return       /* 23-����Ӷ��֮��Ʊ��ϸ    */      CONSTANT NUMBER := 23;
   org_comm_org_return          /* 31-�˻���Ӷ��֮�����˻�  */      CONSTANT NUMBER := 31;
END;
/
