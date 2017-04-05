CREATE OR REPLACE PACKAGE eplan_flow IS
   /****** 方案应对的处理流程（1-a计划，2-b计划）	plan_flow ******/
   plan_a          /* 1-a计划 */                  CONSTANT NUMBER := 1;
   plan_b          /* 2-b计划 */                  CONSTANT NUMBER := 2;
END;
/
