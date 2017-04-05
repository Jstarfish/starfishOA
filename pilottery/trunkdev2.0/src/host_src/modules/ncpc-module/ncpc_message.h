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
//�����ն˱����flownumber������ˮ�� flag 1: sale  flag 2: pay  flag 3: cancel
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
//����
int R_NCP_hb_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_NCP_hb_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
//echo message
int R_NCP_echo_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_NCP_echo_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//�ն�����\�Ͽ�����
int R_NCP_termconn_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
//�ն�������ʱ����
int R_NCP_network_delay_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);

//��Ϸ�ڴ���Ϣ��ѯ
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
//����Ա��½
int R_TERM_signin_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_signin_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//����Աǩ��
int R_TERM_signout_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_signout_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//����Ա�����޸�
int R_TERM_changepwd_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_changepwd_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//����վ����ѯ
int R_TERM_agencybalance_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_agencybalance_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//��Ϸ��Ϣ����
int R_TERM_gameinfo_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_gameinfo_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//��Ʊ����
int R_TERM_sellticket_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_sellticket_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//��Ʊ��ѯ
int R_TERM_inquiryticket_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_inquiryticket_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//��Ʊ�ҽ�
int R_TERM_payticket_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_payticket_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//��Ʊȡ��
int R_TERM_cancelticket_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_cancelticket_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);
//��Ʊ�н���ѯ
int R_TERM_inquiryWin_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf);
int S_TERM_inquiryWin_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf);

// FBS  ������Ϣ��ѯ
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

//��������״̬
int R_OMS_inquiry_system_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_inquiry_system_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);

//  game -------------------------------------------
//��Ϸ���߲���
int R_OMS_gl_policy_param_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_policy_param_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//��Ϸ��ͨ�������
int R_OMS_gl_rule_param_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_rule_param_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//��Ϸ���Ʋ���
int R_OMS_gl_ctrl_param_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_ctrl_param_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//��Ϸ���տ��Ʋ���
int R_OMS_gl_riskctrl_param_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_riskctrl_param_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//��Ϸ���ۿ���
int R_OMS_gl_sale_ctrl_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_sale_ctrl_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//��Ϸ�ҽ�����
int R_OMS_gl_pay_ctrl_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_pay_ctrl_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//��Ϸ��Ʊ����
int R_OMS_gl_cancel_ctrl_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_cancel_ctrl_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//��Ϸ�Զ���������
int R_OMS_gl_autodraw_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_autodraw_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//��Ϸ����ʱ������
int R_OMS_gl_servicetime_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_servicetime_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//��Ϸ�澯��ֵ����
int R_OMS_gl_warn_threshold_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_warn_threshold_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);

// isssue ------------------------------------------------------
//�����ڴ�֪ͨ
int R_OMS_gl_issue_add_nfy_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_issue_add_nfy_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//�����ڴ�
int R_OMS_gl_issue_delete_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_issue_delete_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//�ڴο��������ο���-���ã�(���״ο����ɹ���ɺ���ܷ���)
int R_OMS_gl_issue_second_draw_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_issue_second_draw_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//�ڽ� �C> ��������¼��
int R_OMS_gl_issue_input_drawresult_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_issue_input_drawresult_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//�ڽ� �C> ��������¼��
int R_OMS_gl_issue_prize_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_issue_prize_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//�ڽ� �C> �ַ���������ժҪ
int R_OMS_gl_issue_md5sum_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_issue_md5sum_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//�ڽ� �C> ����ȷ��
int R_OMS_gl_issue_draw_confirm_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_issue_draw_confirm_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//�ڽ� �C> ���¿���
int R_OMS_gl_issue_redo_draw_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_gl_issue_redo_draw_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);


// ticket ------------------------------------------------------
//��Ʊ��ѯ
int R_OMS_ticket_inquiry_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_ticket_inquiry_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//��Ʊ�ҽ�
int R_OMS_ticket_pay_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_ticket_pay_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
//��Ʊ��Ʊ
int R_OMS_ticket_cancel_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_ticket_cancel_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);

// FBS --------------------------------------------------------

// FBS ��������֪ͨ��Ϣ
int R_OMS_fbs_add_match_nfy_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_fbs_add_match_nfy_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
// FBS ɾ������
int R_OMS_fbs_del_match_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_fbs_del_match_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
// FBS ����/ͣ�ñ���
int R_OMS_fbs_match_state_ctrl_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_fbs_match_state_ctrl_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
// FBS �޸ı����ر�ʱ��
int R_OMS_fbs_match_time_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_fbs_match_time_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
// FBS �������� �C> ¼�뿪������
int R_OMS_fbs_draw_input_result_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_fbs_draw_input_result_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);
// FBS �������� �C> �������ȷ��
int R_OMS_fbs_draw_confirm_process(NCPC_SERVER *ns, cJSON *json_msg, char *inm_buf);
int S_OMS_fbs_confirm_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result);



//---------------------------------------------------------------------------------------------------------
//
// AccessProvide http json message process
//
//--------------------------------------------------------------------------------------------------------

////AccessProvideҵ����Ϣ
//typedef enum _GLTP_MESSAGE_AP_FUNC {
//    //echo
//    GLTP_AP_ECHO               = 50001,
//    //��Ʊ����
//    GLTP_AP_SELL_TICKET        = 55001,
//    //��Ʊ��ѯ
//    GLTP_AP_INQUIRY_TICKET     = 55003,
//    //��Ʊ�ҽ�
//    GLTP_AP_PAY_TICKET         = 55005,
//    //��Ϸ�ڴ��б���ѯ
//    GLTP_AP_INQUIRY_ISSUE      = 55007,
//    //��Ϸ�ڴ�״̬��ѯ
//    GLTP_AP_ISSUE_STATE        = 55009,
//}GLTP_MESSAGE_AP_FUNC;

//AccessProvideҵ����Ϣ
typedef enum _GLTP_MESSAGE_AP_FUNC {
    //echo
    GLTP_AP_ECHO               = 50001,
    //��Ʊ����
    GLTP_AP_SELL_TICKET        = 55001,
    //��Ʊ��ѯ
    GLTP_AP_INQUIRY_TICKET     = 55003,
    //��Ϸ��ǰ�ڴβ�ѯ
    GLTP_AP_INQUIRY_ISSUE      = 55007,
    //��ϷԤ���ڴβ�ѯ
    GLTP_AP_ISSUE_STATE        = 55009,

    //FBS ��Ʊ����
    GLTP_AP_FBS_SELL_TICKET    = 55011,
    //FBS ������ѯ
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
