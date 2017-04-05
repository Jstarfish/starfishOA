CREATE OR REPLACE PACKAGE edraw_state IS
  /****** 期次开奖状态（0=不能开奖状态；1=开奖准备状态；2=数据整理状态；3=备份状态；4=备份完成；5=第一次输入完成；6=第二次输入完成；7=开奖号码审批通过；8=开奖号码审批失败；9=开奖号码已发送；10=派奖检索完成；11=派奖输入已发送；12=中奖统计完成；13=数据稽核已发送 ；14=数据稽核完成；15=期结确认已发送；16=开奖完成） ******/
  
  edraw_unvalid             /* 不能开奖状态                       */  CONSTANT NUMBER := 0;        
  edraw_ready               /* 开奖准备状态                       */  CONSTANT NUMBER := 1;        
  edraw_data_collected      /* 数据整理状态                       */  CONSTANT NUMBER := 2;        
  edraw_backup              /* 备份状态                           */  CONSTANT NUMBER := 3;        
  edraw_backuped            /* 备份完成        第一次输入结果     */  CONSTANT NUMBER := 4;        
  edraw_first_inputted      /* 第一次输入完成                     */  CONSTANT NUMBER := 5;        
  edraw_second_inputted     /* 第二次输入完成                     */  CONSTANT NUMBER := 6;        
  edraw_draw_number_pass    /* 开奖号码审批通过                   */  CONSTANT NUMBER := 7;        
  edraw_draw_number_reject  /* 开奖号码审批失败                   */  CONSTANT NUMBER := 8;        
  edraw_draw_number_sent    /* 开奖号码已发送                     */  CONSTANT NUMBER := 9;        
  edraw_prize_collected     /* 派奖检索完成                       */  CONSTANT NUMBER := 10;       
  edraw_prize_input_sent    /* 派奖输入已发送                     */  CONSTANT NUMBER := 11;       
  edraw_prize_stated        /* 中奖统计完成                       */  CONSTANT NUMBER := 12;       
  edraw_data_check_sent     /* 数据稽核已发送                     */  CONSTANT NUMBER := 13;       
  edraw_data_checked        /* 数据稽核完成                       */  CONSTANT NUMBER := 14;       
  edraw_confirm_sent        /* 期结确认已发送                     */  CONSTANT NUMBER := 15;       
  edraw_draw_finish         /* 开奖完成                           */  CONSTANT NUMBER := 16;       

END;
/
