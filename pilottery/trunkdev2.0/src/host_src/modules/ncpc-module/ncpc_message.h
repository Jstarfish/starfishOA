#ifndef NCPC_MESSAGE_H_INCLUDED
#define NCPC_MESSAGE_H_INCLUDED


//--------Net Package Log----------------------------------------------------------

void ncpc_dump_package(char *buf, char *ip, int port, int rxtx);
void ncpc_dump_http_package(char *buf, char *ip, int port, int rxtx);



//--------message process----------------------------------------------------------

// which_queue
//enum {
//    q_ncpc_send = 1,
//    q_ncpc_http_send,
//    q_gl_driver,
//    q_tfe_adder,
//    q_fbs_driver,
//};

// which_queue
enum {
    q_ncpc_send = 1,
    q_ncpc_http_send,
    q_gl_sale,
    q_gl_pay,
    q_gl_cancel,
    q_gl_driver,
    q_tfe_adder,
    q_fbs_driver,
};


// ncpc common function -------------------------------
//根据终端编码和flownumber生成流水号 flag 1: sale  flag 2: pay  flag 3: cancel
void generate_reqfn(uint8 flag, uint64 term_code, uint64 sequence, char *reqfn);







typedef struct _NCPC_MSG_DISPATCH_CELL
{
    uint8  type;
    uint16 func;

    //recv message process
    int (*R_process)(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
    //send to which queue
    uint8 which_queue;
    //send message process
    int (*S_process)(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
}NCPC_MSG_DISPATCH_CELL;
NCPC_MSG_DISPATCH_CELL* ncpc_get_dispatch(uint8 type, uint16 func);


int ncpc_process_Recv_ncp_message(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int ncpc_process_Send_ncp_message(NCPC_SERVER *ns, ncpc_client *c, char *inm_buf);

int ncpc_process_Recv_terminal_message(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int ncpc_process_Send_terminal_message(NCPC_SERVER *ns, ncpc_client *c, char *inm_buf);
int ncpc_process_Send_terminal_uns_message(NCPC_SERVER *ns, char *inm_buf);


//----------------------------------------------------------------------------------------------------
//
// ncp message process
//
//----------------------------------------------------------------------------------------------------
//心跳
int R_NCP_hb_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_NCP_hb_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
//echo message
int R_NCP_echo_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_NCP_echo_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//终端连接\断开报告
int R_NCP_termconn_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
//终端网络延时报告
int R_NCP_network_delay_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);

//游戏期次信息查询
int R_NCP_gameissue_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_NCP_gameissue_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);


//---------------------------------------------------------------------------------------------------------
//
// terminal message process
//
//--------------------------------------------------------------------------------------------------------
//echo
int R_TERM_echo_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_echo_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//auth
int R_TERM_auth_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_auth_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//销售员登陆
int R_TERM_signin_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_signin_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//销售员签退
int R_TERM_signout_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_signout_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//销售员密码修改
int R_TERM_changepwd_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_changepwd_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//销售站余额查询
int R_TERM_agencybalance_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_agencybalance_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//游戏信息请求
int R_TERM_gameinfo_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_gameinfo_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//彩票销售
int R_TERM_sellticket_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_sellticket_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//彩票查询
int R_TERM_inquiryticket_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_inquiryticket_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//彩票兑奖
int R_TERM_payticket_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_payticket_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//彩票取消
int R_TERM_cancelticket_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_cancelticket_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//彩票中奖查询
int R_TERM_inquiryWin_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_inquiryWin_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);

// FBS  比赛信息查询
int R_TERM_fbs_inquiryMatch_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_fbs_inquiryMatch_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);

//--------------------------------------------------------------------------------------------------
//
// terminal uns message process
//
//--------------------------------------------------------------------------------------------------
int S_TERM_UNS_gameopen_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
int S_TERM_UNS_gameclose_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
int S_TERM_UNS_drawannounce_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
















typedef struct _NCPC_HTTP_MSG_DISPATCH_CELL
{
    uint16 func;
    int (*R_process)(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
    uint8 which_queue; //send to which queue
    int (*S_process)(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
}NCPC_HTTP_MSG_DISPATCH_CELL;
NCPC_HTTP_MSG_DISPATCH_CELL* ncpc_http_get_dispatch(uint32 func);

int ncpc_http_process_Recv_message(NCPC_SERVER *ns, int sock_idx, char *json_buf);
int ncpc_http_process_Send_message(NCPC_SERVER *ns, ncpc_client *c, char *inm_buf);

//---------------------------------------------------------------------------------------------------------
//
// oms http json message process
//
//--------------------------------------------------------------------------------------------------------
int R_OMS_echo_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_echo_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);

//主机运行状态
int R_OMS_inquiry_system_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_inquiry_system_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);

//  game -------------------------------------------
//游戏政策参数
int R_OMS_gl_policy_param_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_policy_param_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//游戏普通规则参数
int R_OMS_gl_rule_param_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_rule_param_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//游戏控制参数
int R_OMS_gl_ctrl_param_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_ctrl_param_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//游戏风险控制参数
int R_OMS_gl_riskctrl_param_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_riskctrl_param_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//游戏销售控制
int R_OMS_gl_sale_ctrl_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_sale_ctrl_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//游戏兑奖控制
int R_OMS_gl_pay_ctrl_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_pay_ctrl_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//游戏退票控制
int R_OMS_gl_cancel_ctrl_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_cancel_ctrl_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//游戏自动开奖控制
int R_OMS_gl_autodraw_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_autodraw_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//游戏服务时段设置
int R_OMS_gl_servicetime_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_servicetime_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//游戏告警阈值设置
int R_OMS_gl_warn_threshold_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_warn_threshold_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);

// isssue ------------------------------------------------------
//新增期次通知
int R_OMS_gl_issue_add_nfy_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_issue_add_nfy_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//撤销期次
int R_OMS_gl_issue_delete_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_issue_delete_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//期次开奖（二次开奖-备用）(在首次开奖成功完成后才能发起)
int R_OMS_gl_issue_second_draw_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_issue_second_draw_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//期结 –> 开奖号码录入
int R_OMS_gl_issue_input_drawresult_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_issue_input_drawresult_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//期结 –> 奖级奖金录入
int R_OMS_gl_issue_prize_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_issue_prize_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//期结 –> 分发稽核数据摘要
int R_OMS_gl_issue_md5sum_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_issue_md5sum_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//期结 –> 开奖确认
int R_OMS_gl_issue_draw_confirm_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_issue_draw_confirm_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//期结 –> 重新开奖
int R_OMS_gl_issue_redo_draw_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_issue_redo_draw_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);


// ticket ------------------------------------------------------
//彩票查询
int R_OMS_ticket_inquiry_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_ticket_inquiry_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//彩票兑奖
int R_OMS_ticket_pay_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_ticket_pay_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//彩票退票
int R_OMS_ticket_cancel_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_ticket_cancel_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);

// FBS --------------------------------------------------------

// FBS 新增比赛通知消息
int R_OMS_fbs_add_match_nfy_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_fbs_add_match_nfy_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
// FBS 删除比赛
int R_OMS_fbs_del_match_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_fbs_del_match_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
// FBS 启用/停用比赛
int R_OMS_fbs_match_state_ctrl_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_fbs_match_state_ctrl_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
// FBS 修改比赛关闭时间
int R_OMS_fbs_match_time_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_fbs_match_time_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
// FBS 比赛开奖 –> 录入开奖号码
int R_OMS_fbs_draw_input_result_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_fbs_draw_input_result_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
// FBS 比赛开奖 –> 开奖结果确认
int R_OMS_fbs_draw_confirm_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_fbs_confirm_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);



//---------------------------------------------------------------------------------------------------------
//
// AccessProvide http json message process
//
//--------------------------------------------------------------------------------------------------------

////AccessProvide业务消息
//typedef enum _GLTP_MESSAGE_AP_FUNC {
//    //echo
//    GLTP_AP_ECHO               = 50001,
//    //彩票销售
//    GLTP_AP_SELL_TICKET        = 55001,
//    //彩票查询
//    GLTP_AP_INQUIRY_TICKET     = 55003,
//    //彩票兑奖
//    GLTP_AP_PAY_TICKET         = 55005,
//    //游戏期次列表查询
//    GLTP_AP_INQUIRY_ISSUE      = 55007,
//    //游戏期次状态查询
//    GLTP_AP_ISSUE_STATE        = 55009,
//}GLTP_MESSAGE_AP_FUNC;

//AccessProvide业务消息
typedef enum _GLTP_MESSAGE_AP_FUNC {
    //echo
    GLTP_AP_ECHO               = 50001,
    //彩票销售
    GLTP_AP_SELL_TICKET        = 55001,
    //彩票查询
    GLTP_AP_INQUIRY_TICKET     = 55003,
    //游戏当前期次查询
    GLTP_AP_INQUIRY_ISSUE      = 55007,
    //游戏预售期次查询
    GLTP_AP_ISSUE_STATE        = 55009,

    //FBS 彩票销售
    GLTP_AP_FBS_SELL_TICKET    = 55011,
    //FBS 比赛查询
    GLTP_AP_INQUIRY_MATCH      = 55015,

}GLTP_MESSAGE_AP_FUNC;


// echo message
int R_AP_echo_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_AP_echo_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
// sell ticket
int R_AP_sellTicket_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_AP_sellTicket_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
// inquiry ticket
int R_AP_inquiryTicket_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_AP_inquiryTicket_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);

// inquiry curr issue
int R_AP_inquiry_curr_issue_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_AP_inquiry_curr_issue_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);

// inquiry pre sale issue
int R_AP_inquiry_preSale_issue_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_AP_inquiry_preSale_issue_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);

// fbs  sell ticket
int R_AP_fbs_sellTicket_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_AP_fbs_sellTicket_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);





#define ts_notused_args \
            ts_notused(ns); \
            ts_notused(gltp_buf); \
            ts_notused(inm_buf);





// oracle db sp call interface -------------------------------------------------------

// term online
int otldb_spcall_term_online(char *inm_buf);

//auth
int otldb_spcall_auth(char *inm_buf);
//signin
int otldb_spcall_signin(char *inm_buf);
//signout
int otldb_spcall_signout(char *inm_buf);
//inquiry change password
int otldb_spcall_change_password(char *inm_buf);
//inquiry game info
int otldb_spcall_game_info(char *inm_buf);
//inquiry agency account balance
int otldb_spcall_agency_balance(char *inm_buf);
//inquiry inquiry ticket (inquiry win ticket)
int otldb_spcall_inquiry_ticket(char *inm_buf);
//sale ticket
int otldb_spcall_sale(char *inm_buf);
//pay ticket
int otldb_spcall_pay(char *inm_buf);
//cancel ticket
int otldb_spcall_cancel(char *inm_buf);


//inquiry fbs ticket (inquiry fbs win ticket)
int otldb_spcall_fbs_inquiry_ticket(char *inm_buf);
//sale fbs ticket
int otldb_spcall_fbs_sale(char *inm_buf);
//pay fbs ticket
int otldb_spcall_fbs_pay(char *inm_buf);
//cancel fbs ticket
int otldb_spcall_fbs_cancel(char *inm_buf);



//central inquiry ticket
int otldb_spcall_oms_inquiry_ticket(char *inm_buf);
//central pay ticket
int otldb_spcall_oms_pay(char *inm_buf);
//central cancel ticket
int otldb_spcall_oms_cancel(char *inm_buf);


//central inquiry fbs ticket
int otldb_spcall_oms_fbs_inquiry_ticket(char *inm_buf);
//central pay fbs ticket
int otldb_spcall_oms_fbs_pay(char *inm_buf);
//central cancel fbs ticket
int otldb_spcall_oms_fbs_cancel(char *inm_buf);

#endif //NCPC_MESSAGE_H_INCLUDED

