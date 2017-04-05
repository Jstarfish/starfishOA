create or replace package ehost_error is
  /****** 适用于主机调用类sp，来源于主机程序                             ******/

  host_t_agency_err              /* 销售站不存在或未启动                                       */  constant number := 3;
  host_t_authenticate_err        /* 认证失败                                                   */  constant number := 4;
  host_t_namepwd_err             /* 用户名或密码错误                                           */  constant number := 5;
  host_t_term_disable_err        /* 终端不可用                                                 */  constant number := 6;
  host_t_cancel_agency_err       /* 退票销售站与售票销售站不匹配                               */  constant number := 7;

  host_t_teller_disable_err      /* 销售员不可用                                               */  constant number := 8;
  host_t_teller_signout_err      /* 销售员未登录                                               */  constant number := 9;
  host_t_term_signed_in_err      /* 此终端机上已有销售员登录                                   */  constant number := 10;
  host_t_teller_cleanout_err     /* 销售员已班结                                               */  constant number := 11;
  host_t_teller_unauthen_err     /* 销售员未授此操作权限                                       */  constant number := 12;
  host_t_teller_unexist          /* 销售员不存在                                               */  constant number := 13;

  host_game_disable_err          /* 游戏不可用                                                 */  constant number := 14;
  host_sell_disable_err          /* 游戏不可销售                                               */  constant number := 15;
  host_pay_disable_err           /* 游戏不可兑奖                                               */  constant number := 16;
  host_cancel_disable_err        /* 游戏不可取消                                               */  constant number := 17;
  host_game_subtype_err          /* 游戏玩法方式不支持                                         */  constant number := 18;
  host_claiming_scope_err        /* 不符合兑奖范围                                             */  constant number := 19;

  host_sell_data_err             /* 彩票销售选号错误                                           */  constant number := 20;
  host_sell_betline_err          /* 彩票销售超过最大行数(场次)限制                             */  constant number := 21;
  host_sell_bettimes_err         /* 彩票销售倍数错误                                           */  constant number := 22;
  host_sell_issuecount_err       /* 彩票销售期数错误                                           */  constant number := 23;
  host_sell_ticket_amount_err    /* 彩票销售金额错误                                           */  constant number := 24;
  host_sell_lack_amount_err      /* 账户余额不足                                               */  constant number := 25;
  host_tsn_err                   /* tsn错误                                                    */  constant number := 27;
  host_pay_lack_cash_err         /* 现金金额不足 (需要放入现金)                                */  constant number := 28;
  host_pay_big_winning_err       /* 中大奖，需要输入票面附加码(此错误码停止使用)               */  constant number := 29;
  host_ticket_not_found_err      /* 没有找到此彩票                                             */  constant number := 30;
  host_pay_paid_err              /* 彩票已兑奖                                                 */  constant number := 31;
  host_cancel_again_err          /* 彩票已退票                                                 */  constant number := 32;
  host_pay_not_win_err           /* 彩票未中奖                                                 */  constant number := 33;
  host_pay_not_draw_err          /* 彩票期还没有开奖                                           */  constant number := 34;
  host_pay_wait_draw_err         /* 彩票期等待开奖                                             */  constant number := 35;
  host_cancel_not_accept_err     /* 彩票退票失败                                               */  constant number := 36;
  host_lack_cash_err             /* 现金金额不足 (当执行取出现金操作时发生)                    */  constant number := 37;

  host_msg_data_err              /* 消息数据错误                                               */  constant number := 38;
  host_version_not_available_err /* 软件版本不可用                                             */  constant number := 39;
  host_gameresult_disable_err    /* 开奖结果不可用                                             */  constant number := 40;
  host_sell_noissue_err          /* 彩票销售无当前期可用                                       */  constant number := 41;
  host_sell_drawtime_err         /* 彩票销售获取开奖时间错误                                   */  constant number := 42;

  host_pay_multi_issue_err       /* 连续多期票，最后一期未结束，不能兑奖                       */  constant number := 43;
  host_teller_pay_limit_err      /* 超出销售员兑奖范围                                         */  constant number := 44;
  host_pay_wait_award_time_err   /* 未到兑奖开始时间                                           */  constant number := 45;
  host_pay_award_time_end_err    /* 兑奖时间已结束                                             */  constant number := 46;
  host_cancel_time_end_err       /* 已过最大撤消时间,不能退票                                  */  constant number := 47;
  host_pay_need_excode_err       /* 兑大奖需要附加码                                           */  constant number := 48;
  host_pay_excode_err            /* 兑大奖附加码错误                                           */  constant number := 49;

  host_pay_dayend_err            /* 兑奖日期已结止                                             */  constant number := 50;
  host_t_cancel_untrainer_err    /* 销售员退培训票                                             */  constant number := 51;
  host_t_cancel_trainer_err      /* 培训员退正常票                                             */  constant number := 52;
  host_t_pay_untrainer_err       /* 销售员兑培训票                                             */  constant number := 53;
  host_t_pay_trainer_err         /* 培训员兑正常票                                             */  constant number := 54;
  host_inquiry_issue_nofound_err /* 彩票期未找到                                               */  constant number := 55;

  host_game_servicetime_out_err  /* 当前不是彩票交易时段                                       */  constant number := 56;

  host_t_term_train_unreport_err /* 培训机不可查销售员报表                                     */  constant number := 57;

  host_pay_paying_err            /* 彩票正在兑奖中                                             */  constant number := 58;
  host_cancel_canceling_err      /* 彩票退票中                                                 */  constant number := 59;

  host_pay_gamelimit_err         /* 游戏兑奖限额： 系统保护阈值（所有的兑奖行为都受此参数限制）*/  constant number := 60;
  host_cancel_moneylimit_err     /* 退票超出限额                                               */  constant number := 61;
  host_flow_number_err           /* 交易流水号不匹配                                           */  constant number := 62;

  host_ap_token_err              /* ap业务token验证失败                                        */  constant number := 63;

  host_type_err                  /* 查询类型(type)错误                                         */  constant number := 64;

  host_t_agency_time_err         /* 超出销售站营业时间                                         */  constant number := 65;

  host_t_agency_type_err         /* 销售站类型不支持                                           */  constant number := 66;

  host_t_teller_signed_in_err    /* 此销售员已登录其他终端机                                   */  constant number := 67;
  host_t_token_expired_err       /* token失效，需要重新认证                                    */  constant number := 68;
  host_t_msn_err                 /* msn错误，需要重新登录                                      */  constant number := 69;

  oms_ticket_not_found_err       /* 查无此票             */                                        constant number := 2;   
  oms_ticket_tsn_err             /* TSN错误              */                                        constant number := 3;   
  oms_busy_err                   /* 正在处理OMS消息中    */                                        constant number := 4;   
  oms_game_disable_err           /* 游戏不可用           */                                        constant number := 5;   
  oms_game_servicetime_out_err   /* 当前不是彩票交易时段 */                                        constant number := 6;   
  oms_agency_type_err            /* 销售站类型错误       */                                        constant number := 7;   
  oms_pay_disable_err            /* 游戏不可兑奖         */                                        constant number := 8;   
  oms_pay_paying_err             /* 彩票正在兑奖中       */                                        constant number := 9;   
  oms_pay_not_draw_err           /* 彩票期还没有开奖     */                                        constant number := 10;  
  oms_pay_wait_draw_err          /* 彩票期等待开奖完成   */                                        constant number := 11;  
  oms_pay_dayend_err             /* 兑奖日期已结止       */                                        constant number := 12;  
  oms_pay_training_ticket_err    /* 销售员兑培训票       */                                        constant number := 13;  
  oms_pay_not_win_err            /* 彩票未中奖           */                                        constant number := 14;  
  oms_pay_multi_issue_err        /* 多期票未完结         */                                        constant number := 15;  
  oms_pay_paid_err               /* 彩票已兑奖           */                                        constant number := 16;  
  oms_pay_money_limit_err        /* 兑奖超出限额         */                                        constant number := 17;  
  oms_cancel_disable_err         /* 游戏不可取消         */                                        constant number := 18;  
  oms_cancel_again_err           /* 彩票已退票           */                                        constant number := 19;  
  oms_cancel_canceling_err       /* 彩票退票中           */                                        constant number := 20;  
  oms_cancel_issue_err           /* 退票期次类错误       */                                        constant number := 21;  
  oms_cancel_training_ticket_err /* 销售员退培训票       */                                        constant number := 22;  
  oms_cancel_time_end_err        /* 超过退票时间         */                                        constant number := 23;  
  oms_cancel_money_limit_err     /* 退票超出限额         */                                        constant number := 24;  
  oms_claiming_scope_err         /* 不符合兑奖范围       */                                        constant number := 25;  
  oms_lack_amount_err            /* 销售站现金余额不足   */                                        constant number := 26;  
  oms_cancel_forbid              /* 分中心不允许退票     */                                        constant number := 27;  
  oms_pay_forbid                 /* 分中心不允许兑奖     */                                        constant number := 28;  
end;