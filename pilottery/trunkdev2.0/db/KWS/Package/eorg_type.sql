CREATE OR REPLACE PACKAGE eorg_type IS
   /****** 部门类别（1-公司,2-代理） ******/
   company                  /* 1-公司 */                CONSTANT NUMBER := 1;
   agent                    /* 2-代理 */                CONSTANT NUMBER := 2;
END;
/