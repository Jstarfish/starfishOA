CREATE OR REPLACE PACKAGE eagency_type IS
   /****** 销售站类型(1=传统销售站/2=后缴款销售站/3=无纸化/4=中心销售站) ******/
   traditionalagency        /* 1=传统销售站*/           CONSTANT NUMBER := 1;
   accreditedagency         /* 2=后缴款销售站 */        CONSTANT NUMBER := 2;
   paperless                /* 3=无纸化*/               CONSTANT NUMBER := 3;
   center_agency            /* 4=中心销售站*/           CONSTANT NUMBER := 4;
END;
/
