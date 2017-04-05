#ifndef NCPC_HTTP_MESSAGE_H_INCLUDED
#define NCPC_HTTP_MESSAGE_H_INCLUDED

// http log
bool ncpc_http_initLog();
bool ncpc_http_closeLog();

void ncpc_httpd_dump_package(char *buf, char *ip, int port, int rxtx, uint64 token, int type, int func, int rc);



//AccessProvide业务消息
typedef enum _GLTP_MESSAGE_AP_FUNC {
    //echo
    GLTP_AP_ECHO               = 50001,
    //彩票销售
    GLTP_AP_SELL_TICKET        = 55001,
    //彩票查询
    GLTP_AP_INQUIRY_TICKET     = 55003,
    //彩票兑奖
    GLTP_AP_PAY_TICKET         = 55005,
    //游戏期次列表查询
    GLTP_AP_INQUIRY_ISSUE      = 55007,
    //游戏期次状态查询
    GLTP_AP_ISSUE_STATE        = 55009,

    //FBS 彩票销售
    GLTP_AP_FBS_SELL_TICKET    = 5011,
    //FBS 彩票兑奖
    GLTP_AP_FBS_PAY_TICKET     = 5013,
    //FBS 比赛查询
    GLTP_AP_INQUIRY_MATCH      = 5015,

}GLTP_MESSAGE_AP_FUNC;


#define HTTP_MSG_VERSION  ("1.0.0")

// which_queue
enum {
	q_ncpc_http_send = 1,
    q_gl_sale,
    q_gl_pay,
    q_gl_cancel,
    q_gl_driver,
    q_tfe_adder,
};

typedef struct _NCPC_MSG_DISPATCH_CELL
{
    uint16 func;
    int (*R_process)(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
    uint8 which_queue; //send to which queue
    int (*S_process)(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
}NCPC_HTTP_MSG_DISPATCH_CELL;
NCPC_HTTP_MSG_DISPATCH_CELL* ncpc_http_get_dispatch(uint32 func);

int ncpc_http_process_Recv_message(NCPC_SERVER *ns, int sock_idx, char *json_buf);
int ncpc_http_process_Send_message(NCPC_SERVER *ns, ncpc_client c, char *inm_buf);


//----------------------------------------------------------------------------------------------------
//
// ncpc http message process
//
//----------------------------------------------------------------------------------------------------
// echo message
int R_AP_echo_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_AP_echo_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
// sell ticket
int R_AP_sellTicket_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_AP_sellTicket_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
// inquiry ticket
int R_AP_inquiryTicket_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_AP_inquiryTicket_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
// pay ticket
int R_AP_payTicket_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_AP_payTicket_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
// inquire issue
int R_AP_inquiryIssue_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_AP_inquiryIssue_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
// inquire issue state
int R_AP_issueState_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_AP_issueState_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);


// fbs  sell ticket
int R_AP_fbs_sellTicket_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_AP_fbs_sellTicket_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
// fbs  pay ticket
int R_AP_fbs_payTicket_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_AP_fbs_payTicket_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
// fbs  inquire match
int R_AP_inquiryMatch_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_AP_inquiryMatch_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//-----------------------------------------------------------------------------------------------------
//
// oms message process
//
//-----------------------------------------------------------------------------------------------------

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


// FBS ticket ------------------------------------------------------
//FBS 彩票查询
int R_OMS_fbs_ticket_inquiry_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_fbs_ticket_inquiry_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//FBS 彩票兑奖
int R_OMS_fbs_ticket_pay_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_fbs_ticket_pay_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//FBS 彩票退票
int R_OMS_fbs_ticket_cancel_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_fbs_ticket_cancel_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);


#endif //NCPC_HTTP_MESSAGE_H_INCLUDED

