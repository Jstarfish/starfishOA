#include "global.h"
#include "tms_inf.h"
#include "gl_inf.h"
#include "ncpc_http_parse.h"
#include "ncpc_http_kvdb.h"
#include "ncpc_net.h"
#include "ncpc_message.h"
#include "ncpcmod.h"
//#include "ncpc_http_message.h"

#define GLTP_HTTP_MSG_VERSION "1.0.0"

static const char *DateTime_Format_AP = "%s%s%s%s%s%s";

extern GAME_PLUGIN_INTERFACE *game_plugins_handle;
extern pthread_mutex_t risk_mutex[MAX_GAME_NUMBER];


//--------------------------------------------------------------------------------------------------
//
// OMS  fun
//
//--------------------------------------------------------------------------------------------------

int r_oms_inquiryticket(char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec);
int r_oms_fbs_inquiryticket(char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec);

int s_oms_inquiryticket(char *inm_buf, cJSON *json_result);
int s_oms_fbs_inquiryticket(char *inm_buf, cJSON *json_result);

int r_oms_payticket(cJSON *json_params, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec);
int r_oms_fbs_payticket(cJSON *json_params, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec);

int s_oms_payticket(char *inm_buf, cJSON *json_result);
int s_oms_fbs_payticket(char *inm_buf, cJSON *json_result);

int r_oms_cancelticket(cJSON *json_params, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec);
int r_oms_fbs_cancelticket(cJSON *json_params, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec);

int s_oms_cancelticket(char *inm_buf, cJSON *json_result);
int s_oms_fbs_cancelticket(char *inm_buf, cJSON *json_result);




// message process -----------------------------------------------------------------------

int ncpc_http_process_Recv_message(NCPC_SERVER *ns, int sock_idx, char *json_buf)
{
    cJSON *json_root = cJSON_Parse(json_buf);
    if (!json_root) {
        log_warn("Json parse error before: [%s]", cJSON_GetErrorPtr()); return -1;
    }
    cJSON *json_version = cJSON_Get(json_root, "version", cJSON_String);
    if (json_version == NULL)
    {
        log_warn("Message get version error.");
        cJSON_Delete(json_root);
        return -1;
    }
    //check version support
    if (0 != strcmp(json_version->valuestring, GLTP_HTTP_MSG_VERSION)) {
        log_warn("Message version error."); cJSON_Delete(json_root); return -1;
    }
    cJSON *json_type = cJSON_Get(json_root, "type", cJSON_Number);
    if (json_type == NULL)
    {
        log_warn("Message get type error.");
        cJSON_Delete(json_root);
        return -1;
    }
    cJSON *json_func = cJSON_Get(json_root, "func", cJSON_Number);
    if (json_func == NULL)
    {
        log_warn("Message get func error.");
        cJSON_Delete(json_root);
        return -1;
    }
    cJSON *json_token = cJSON_Get(json_root, "token", cJSON_Number);
    if (json_token == NULL)
    {
        log_warn("Message get token error.");
        cJSON_Delete(json_root);
        return -1;
    }
    cJSON *json_msn = cJSON_Get(json_root, "msn", cJSON_Number);
    if (json_msn == NULL)
    {
        log_warn("Message get msn error.");
        cJSON_Delete(json_root);
        return -1;
    }
    cJSON *json_when = cJSON_Get(json_root, "when", cJSON_Number);
    if (json_when == NULL)
    {
        log_warn("Message get when error.");
        cJSON_Delete(json_root);
        return -1;
    }
    cJSON *json_params = cJSON_GetObjectItem(json_root, "params");
    if (json_params == NULL || (json_params->type != cJSON_String && json_params->type != cJSON_Array && json_params->type != cJSON_Object)) {
        log_warn("Message field [ params ] parse error."); cJSON_Delete(json_root); return -1;
    }
    uint64 token = json_token->valuedouble;
    int type = json_type->valueint;
    int func = json_func->valueint;

    char inm_buf[INM_MSG_BUFFER_LENGTH];
    memset(inm_buf, 0, INM_MSG_BUFFER_LENGTH);
    INM_MSG_HEADER *inm_header = (INM_MSG_HEADER *)inm_buf;
    inm_header->when = get_now();
    inm_header->status = SYS_RESULT_SUCCESS;
    inm_header->gltp_type = type;
    inm_header->gltp_func = func;
    inm_header->socket_idx = sock_idx;

    if (type == GLTP_MSG_TYPE_AP) {
        inm_header->gltp_from = TICKET_FROM_AP;
        /*
        INM_MSG_AP_HEADER *inm_ap_header = (INM_MSG_AP_HEADER *)inm_buf;
        inm_ap_header->token = token;
        inm_ap_header->sequence = json_msn->valueint;
        cJSON *json_agency = cJSON_Get(json_params, "agencyCode", cJSON_Number); 
        if (json_agency == NULL)
        { 
            log_warn("Message get agencyCode error.");
            cJSON_Delete(json_root); 
            return -1; 
        }
        */
        INM_MSG_T_HEADER *inm_t_header = (INM_MSG_T_HEADER *)inm_buf;
        inm_t_header->token = token;
        inm_t_header->msn = json_msn->valueint;
        cJSON *json_agency = cJSON_Get(json_params, "agencyCode", cJSON_Number); if (json_agency == NULL) { cJSON_Delete(json_root); return -1; }
        inm_t_header->agencyCode = json_agency->valuedouble;
    }
    else if (type == GLTP_MSG_TYPE_OMS) {
        inm_header->gltp_from = TICKET_FROM_OMS;
        INM_MSG_O_HEADER *inm_o_header = (INM_MSG_O_HEADER *)inm_buf;
        inm_o_header->token = token;
        inm_o_header->sequence = json_msn->valueint;

        //��kvdb�в�ѯ��sequence
        //
        // __DEF_PIL   �����kvdb������Ҫ��Ϊԭ�Ӳ���
        /*
        char oms_flow[32]; sprintf(oms_flow, "oms_%u", inm_o_header->sequence);
        string value = ns->kvdb->get(oms_flow);
        if (value.empty()) {
            ns->kvdb->put(oms_flow, (char*)"");
        } else {
            log_warn("OMS_RESULT_FAILURE: oms sequence duplicate. sequence[ %u ].", inm_o_header->sequence);
            inm_o_header->inm_header.status = OMS_RESULT_FAILURE;
            inm_o_header->inm_header.length = INM_MSG_O_HEADER_LEN;
            ns->send_msg_to_bq(q_ncpc_http_send, inm_buf, INM_MSG_O_HEADER_LEN);
            cJSON_Delete(json_root);
            return 0;
        }
        */
    }
    else {
        log_warn("Message type[%u] error.", type); cJSON_Delete(json_root); return -1;
    }

    NCPC_HTTP_MSG_DISPATCH_CELL *msg_cell = ncpc_http_get_dispatch(func);
    if (msg_cell == NULL) {
        log_error("ncpc_http_get_dispatch() failed. unknow message func[%d]", func); cJSON_Delete(json_root); return -1;
    }
    int msg_len = msg_cell->R_process(ns, json_params, inm_buf);
    if (msg_len <= 0) {
        log_warn("R_process() failed. func[%d]", func); cJSON_Delete(json_root); return -1;
    }
    inm_header->length = msg_len;

    log_debug("R_process result -> token[%llu] status[%d].", token, inm_header->status);

    //����ʧ��ֱ�ӷ���
    if (inm_header->status != SYS_RESULT_SUCCESS) {
        cJSON_Delete(json_root);
        ns->send_msg_to_bq(q_ncpc_http_send, inm_buf, INM_MSG_T_HEADER_LEN);
        return 0;
    }

    ns->send_msg_to_bq(msg_cell->which_queue, inm_buf, inm_header->length);
    cJSON_Delete(json_root);
    return 0;
}

int ncpc_http_process_Send_message(NCPC_SERVER *ns, ncpc_client *c, char *inm_buf)
{
    INM_MSG_HEADER *inm_header = (INM_MSG_HEADER *)inm_buf;
    int type = inm_header->gltp_type;
    int func = inm_header->gltp_func;
    NCPC_HTTP_MSG_DISPATCH_CELL *msg_cell = ncpc_http_get_dispatch(func);
    if (msg_cell == NULL) {
        log_error("ncpc_http_get_dispatch() failed. unknow message func[%d]", func); return -1;
    }

    cJSON *json_result = cJSON_CreateObject();
    if (SYS_RESULT_SUCCESS != inm_header->status) {
        //����ͨ�õĴ�����Ϣ
        cJSON_AddStringToObject(json_result, "err", "message process failure");
    }
    else {
        int msg_len = msg_cell->S_process(ns, inm_buf, json_result);
        if (msg_len < 0) {
            log_warn("S_process() failed. func[%d]", func); cJSON_Delete(json_result); return -1;
        }
    }

    uint64 token = 0; uint32 msn = 0;
    if (type == GLTP_MSG_TYPE_AP) {
        /*
        INM_MSG_AP_HEADER *inm_ap_header = (INM_MSG_AP_HEADER *)inm_buf;
        token = inm_ap_header->token;
        msn = inm_ap_header->sequence;
        */
        INM_MSG_T_HEADER *inm_t_header = (INM_MSG_T_HEADER *)inm_buf;
        token = inm_t_header->token;
        msn = inm_t_header->msn;
    }
    else if (type == GLTP_MSG_TYPE_OMS) {
        INM_MSG_O_HEADER *inm_o_header = (INM_MSG_O_HEADER *)inm_buf;
        token = inm_o_header->token;
        msn = inm_o_header->sequence;
    }
    else {
        log_warn("S_process() failed. type[%d] error", type); cJSON_Delete(json_result); return -1;
    }

    log_debug("S_process result -> token[%llu] status[%d].", token, inm_header->status);

    cJSON *result_root = cJSON_CreateObject();
    cJSON_AddStringToObject(result_root, "version", GLTP_HTTP_MSG_VERSION);
    cJSON_AddNumberToObject(result_root, "type", type);
    cJSON_AddNumberToObject(result_root, "func", func);
    cJSON_AddNumberToObject(result_root, "token", token);
    cJSON_AddNumberToObject(result_root, "msn", msn);
    cJSON_AddNumberToObject(result_root, "when", get_now());
    cJSON_AddNumberToObject(result_root, "rc", inm_header->status);
    cJSON_AddItemToObject(result_root, "result", json_result);

    char *response_message = cJSON_PrintUnformatted(result_root);
    int response_length = strlen(response_message);

    /*
    //kvdb
    if (type == GLTP_MSG_TYPE_OMS) {
        char oms_flow[32]; char rc[8];
        INM_MSG_O_HEADER *inm_o_header = (INM_MSG_O_HEADER *)inm_buf;
        sprintf(oms_flow, "oms_%u", inm_o_header->sequence);
        sprintf(rc, "%u", inm_header->status);
        ns->kvdb->put(oms_flow, rc);
    }
    */

    //send message to net
    c->send_http_message(response_message, response_length);

    free(response_message);
    cJSON_Delete(result_root);
    return 0;
}



// echo message
int R_AP_echo_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_T_ECHO *inm_msg = (INM_MSG_T_ECHO *)inm_buf;
    inm_msg->header.inm_header.type = INM_TYPE_AP_ECHO;
    int len = sizeof(INM_MSG_T_ECHO);

    cJSON *json_echo = cJSON_Get(json_params, "echo", cJSON_String);
    if (json_echo == NULL) {
        inm_msg->header.inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    inm_msg->echo_len = sprintf(inm_msg->echo_str, "reply -> %s", json_echo->valuestring) + 1;

    log_info("R_AP_echo_process -> ap_token[%llu]", inm_msg->header.token);
    return (sizeof(INM_MSG_T_ECHO) + inm_msg->echo_len);
}
int S_AP_echo_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns);
    INM_MSG_T_ECHO *inm_msg = (INM_MSG_T_ECHO *)inm_buf;

    inm_msg->echo_str[inm_msg->echo_len] = 0;
    cJSON_AddStringToObject(json_result, "echo", inm_msg->echo_str);

    log_info("S_AP_echo_process -> ap_token[%llu]", inm_msg->header.token);
    return 0;
}

// sell ticket
extern uint32 sale_verifyIssue(uint8 gameCode, uint64 issue, uint8 count, ISSUE_INFO* curr_issue_info);
int R_AP_sellTicket_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER*)inm_buf;
    INM_MSG_T_SELL_TICKET *inm_msg = (INM_MSG_T_SELL_TICKET *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_T_SELL_TICKET;
    msg_header->areaCode = 99;
    int len = offsetof(INM_MSG_T_SELL_TICKET, ticket);

    cJSON *json_reqfn = cJSON_Get(json_params, "reqfn", cJSON_String);
    if (json_reqfn == NULL) {
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    cJSON *json_bet_string = cJSON_Get(json_params, "bet_string", cJSON_String);
    if (json_bet_string == NULL) {
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    if (strlen(json_bet_string->valuestring) >= 2048) {
        msg_header->inm_header.status = SYS_RESULT_SELL_DATA_ERR; //Ͷע�ַ�����ʽ����
        log_error("bet_string len [%d]", strlen(json_bet_string->valuestring));
        return len;
    }
    memcpy(inm_msg->reqfn_ticket, json_reqfn->valuestring, TSN_LENGTH); inm_msg->reqfn_ticket[TSN_LENGTH] = 0;
    inm_msg->ticket.betStringLen = sprintf(inm_msg->ticket.betString, "%s", json_bet_string->valuestring) + 1;
    if (0 > gl_formatTicket(json_bet_string->valuestring, (char*)&inm_msg->ticket, INM_MSG_BUFFER_LENGTH - 1024)) {
        msg_header->inm_header.status = SYS_RESULT_SELL_DATA_ERR; //Ͷע�ַ�����ʽ����
        return len;
    }
    strcpy(inm_msg->loyaltyNum, "0");

    // check reqfn_ticket
    string value = ns->kvdb->get(inm_msg->reqfn_ticket);
    if (value.empty()) {
        ns->kvdb->put(inm_msg->reqfn_ticket, (char*)"");
    }
    else {
        log_warn("SYS_RESULT_FAILURE: reqfn_ticket duplicate. reqfn_ticket[ %s ].", inm_msg->reqfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }

    //DUMP Ticket
    gl_dumpTicket(&inm_msg->ticket);

    uint8 game_code = inm_msg->ticket.gameCode;
    if (!isGameBeUsed(game_code)) {
        log_debug("SYS_RESULT_GAME_DISABLE_ERR: saleProcessing gameCode[%d] can't used.", game_code);
        msg_header->inm_header.status = SYS_RESULT_GAME_DISABLE_ERR;
        return len;
    }
    TRANSCTRL_PARAM *transctrlParam = gl_getTransctrlParam(game_code);
    if (!transctrlParam->saleFlag) {
        log_debug("SYS_RESULT_SELL_DISABLE_ERR: gl_sale SaleFlag not be used.");
        msg_header->inm_header.status = SYS_RESULT_SELL_DISABLE_ERR;
        return len;
    }
    //����Ƿ��ڷ���ʱ�εķ�Χ��
    if (false == gl_verifyServiceTime(game_code)) {
        log_debug("SYS_RESULT_GAME_SERVICETIME_OUT_ERR: gl_sale time over. game[%d]", game_code);
        msg_header->inm_header.status = SYS_RESULT_GAME_SERVICETIME_OUT_ERR;
        return len;
    }
    //���Ʊ�������
    if (inm_msg->ticket.amount > transctrlParam->maxAmountPerTicket) {
        log_debug("saleProcessing tmoney[%lld]", inm_msg->ticket.amount);
        msg_header->inm_header.status = SYS_RESULT_SELL_TICKET_AMOUNT_ERR;
        return len;
    }
    //���Ͷע����
    if ((inm_msg->ticket.betlineCount > transctrlParam->maxBetLinePerTicket) ||
        (inm_msg->ticket.betlineCount < 1)) {
        log_info("saleProcessing gl_verifyBetCountParam gameCode[%d] betlinecnt[%d] error", game_code, inm_msg->ticket.betlineCount);
        msg_header->inm_header.status = SYS_RESULT_SELL_BETLINE_ERR;
        return len;
    }
    //����ڴ����
    ISSUE_INFO* curr_issue_info = game_plugins_handle[game_code].get_currIssue(); //����Ϸ�����ȡ��Ϸ��ǰ�ڴ�
    if (curr_issue_info == NULL) {
        log_info("Get current issue failure. game[%d].", game_code);
        msg_header->inm_header.status = SYS_RESULT_SELL_NOISSUE_ERR;
        return len;
    }
    int ret = sale_verifyIssue(game_code, inm_msg->ticket.issue, inm_msg->ticket.issueCount, curr_issue_info);
    if (ret != SYS_RESULT_SUCCESS) {
        log_debug("saleProcessing issueNum[%lld] icount[%d] error", inm_msg->ticket.issue, inm_msg->ticket.issueCount);
        msg_header->inm_header.status = ret;
        return len;
    }
    //������Ϸ�������Ʊ��֤
    ret = game_plugins_handle[game_code].sale_ticket_verify(&inm_msg->ticket);
    if (ret != SYS_RESULT_SUCCESS) {
        log_debug("sale_ticket_verify failure. ticket->%s", inm_msg->ticket.betString);
        msg_header->inm_header.status = ret;
        return len;
    }
    //��ȡ������ʼ�ڴκͿ���ʱ��
    uint64 saleStartIssue = inm_msg->ticket.issue;
    if (inm_msg->ticket.issue == 0)
        saleStartIssue = curr_issue_info->issueNumber;
    ISSUE_INFO * start_issue_info = game_plugins_handle[game_code].get_issueInfo(saleStartIssue);
    ISSUE_INFO * end_issue_info = game_plugins_handle[game_code].get_issueInfo2(start_issue_info->serialNumber + inm_msg->ticket.issueCount - 1);
    if (end_issue_info == NULL) {
        log_debug("game plugin get_issueInfo2(game_code[%u], issue_serial[%u]) return NULL.",
            game_code, start_issue_info->serialNumber + inm_msg->ticket.issueCount - 1);
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    inm_msg->issueNumber = curr_issue_info->issueNumber;           //ϵͳ������Ʊʱ�ĵ�ǰ�ں�
    inm_msg->ticket.issue = start_issue_info->issueNumber;         //����Ʊʵ����ʵ����ĵ�һ�ڵ��ں�
    inm_msg->ticket.issueSeq = start_issue_info->serialNumber;     //����Ʊʵ����ʵ����ĵ�һ�ڵ��ڴ����
    inm_msg->ticket.lastIssue = end_issue_info->issueNumber;       //����Ʊʵ����ʵ��������һ�ڵ��ں�
    inm_msg->drawTimeStamp = end_issue_info->drawTime;             //���һ�ڵĿ���ʱ��

    //��Ϸ���տ��Ƽ��
    if ((isGameBeRiskControl(game_code)) && (NULL != game_plugins_handle[game_code].sale_rk_verify)) {
        pthread_mutex_lock(&risk_mutex[game_code]);
        ret = game_plugins_handle[game_code].sale_rk_verify(&inm_msg->ticket);
        if (false == ret) {
            msg_header->inm_header.status = SYS_RESULT_RISK_CTRL_ERR;
            pthread_mutex_unlock(&risk_mutex[game_code]);
            return len;
        }
        pthread_mutex_unlock(&risk_mutex[game_code]);
    }

    int rc = otldb_spcall_sale(inm_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("sell ticket failure.");
        inm_msg->header.inm_header.status = rc;
        if ((isGameBeRiskControl(game_code)) && (NULL != game_plugins_handle[game_code].cancel_rk_rollback)) {
            pthread_mutex_lock(&risk_mutex[game_code]);
            game_plugins_handle[game_code].cancel_rk_rollback(&inm_msg->ticket);
            pthread_mutex_unlock(&risk_mutex[game_code]);
        }
        return len;
    }

    if (rc != 0) {
        //��Ϸ���տ��ƻع�
        if ((isGameBeRiskControl(game_code)) && (NULL != game_plugins_handle[game_code].cancel_rk_rollback)) {
            pthread_mutex_lock(&risk_mutex[game_code]);
            game_plugins_handle[game_code].cancel_rk_rollback(&inm_msg->ticket);
            pthread_mutex_unlock(&risk_mutex[game_code]);
        }
        return len;
    }

    if (inm_msg->ticket.isTrain == 1)
    {
        if ((isGameBeRiskControl(game_code)) && (NULL != game_plugins_handle[game_code].cancel_rk_rollback)) {
            pthread_mutex_lock(&risk_mutex[game_code]);
            game_plugins_handle[game_code].cancel_rk_rollback(&inm_msg->ticket);
            pthread_mutex_unlock(&risk_mutex[game_code]);
        }
    }

    log_info("R_AP_sellTicket_process -> ap_token[%llu]", msg_header->token);
    return (offsetof(INM_MSG_T_SELL_TICKET, ticket) + inm_msg->ticket.length);
}
int S_AP_sellTicket_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns);
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER*)inm_buf;
    INM_MSG_T_SELL_TICKET *inm_msg = (INM_MSG_T_SELL_TICKET *)inm_buf;

    cJSON_AddStringToObject(json_result, "reqfn", inm_msg->reqfn_ticket);
    cJSON_AddStringToObject(json_result, "rspfn", inm_msg->rspfn_ticket);
    cJSON_AddNumberToObject(json_result, "game", inm_msg->ticket.gameCode);
    cJSON_AddNumberToObject(json_result, "issue", inm_msg->ticket.issue);
    cJSON_AddNumberToObject(json_result, "amount", inm_msg->ticket.amount);

    ns->kvdb->put(inm_msg->reqfn_ticket, inm_msg->rspfn_ticket);

    log_info("S_AP_sellTicket_process -> ap_token[%llu]", msg_header->token);
    return 0;
}


// inquiry ticket
int R_AP_inquiryTicket_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER*)inm_buf;
    INM_MSG_T_INQUIRY_TICKET *inm_msg = (INM_MSG_T_INQUIRY_TICKET *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_AP_INQUIRY_TICKET;
    int len = sizeof(INM_MSG_T_INQUIRY_TICKET);

    cJSON *json_reqfn = cJSON_Get(json_params, "reqfn", cJSON_String);
    if (json_reqfn == NULL) {
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    memcpy(inm_msg->reqfn_ticket, json_reqfn->valuestring, 18); inm_msg->reqfn_ticket[18] = 0;

    // found reqfn_ticket
    string value = ns->kvdb->get(json_reqfn->valuestring);
    if (value.empty()) {
        log_warn("ap_token[%llu] Message sale failure.  reqfn[%s].", msg_header->token, json_reqfn->valuestring);
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    memcpy(inm_msg->rspfn_ticket, value.c_str(), 18); inm_msg->rspfn_ticket[18] = 0;


    int rc = 0;
    //
    // OTL__SP
    // call db sp -----------------------------------------------
    //  in param:  agencyCode(token), json message(inm_msg->reqfn_ticket,...)
    // out param:  rc
    //
    //sp  ͨ��У��(agency,area�����ҿ���)
    //
    //rc
    //
    //
    //
    if (rc != 0) {
        msg_header->inm_header.status = rc;
        return len;
    }

    log_info("R_AP_inquiryTicket_process -> ap_token[%llu]", msg_header->token);
    return len;
}
int S_AP_inquiryTicket_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns);
    INM_MSG_T_INQUIRY_TICKET *inm_msg = (INM_MSG_T_INQUIRY_TICKET *)inm_buf;

    cJSON_AddStringToObject(json_result, "reqfn", inm_msg->reqfn_ticket);
    cJSON_AddStringToObject(json_result, "rspfn", inm_msg->rspfn_ticket);

    log_info("S_AP_inquiryTicket_process -> ap_token[%llu]", inm_msg->header.token);
    return 0;
}

bool check_ap_paid_over_file_exist(uint8 game_code, uint64 issue)
{
    char game_abbr[16] = { 0 };
    get_game_abbr(game_code, game_abbr);
    char ap_pay_over_file[256] = { 0 };
    ts_get_game_issue_ap_paidover_filepath(game_abbr, game_code, issue, ap_pay_over_file, 256);
    if ((access(ap_pay_over_file, F_OK)) != -1)
    {
        return true;
    }
    return false;
}

char *get_date_by_stamp(time_type tt, char *time_buf)
{
    fmt_time_t(tt, DateTime_Format_AP, time_buf);
    return time_buf;
}

// inquiry curr issue
int R_AP_inquiry_curr_issue_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER*)inm_buf;
    INM_MSG_AP_CURR_ISSUE *inm_msg = (INM_MSG_AP_CURR_ISSUE *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_AP_INQUIRY_ISSUE;
    int len = sizeof(INM_MSG_AP_CURR_ISSUE);

    cJSON *json_game = cJSON_Get(json_params, "gameCode", cJSON_Number);
    if (json_game == NULL) {
        log_debug("get gameCode error.");
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    inm_msg->game_code = json_game->valueint;
    if (!isGameBeUsed(inm_msg->game_code)) {
        log_debug("SYS_RESULT_GAME_DISABLE_ERR: gameCode[%d] can't used.", inm_msg->game_code);
        msg_header->inm_header.status = SYS_RESULT_GAME_DISABLE_ERR;
        return len;
    }

    cJSON *json_issue = cJSON_Get(json_params, "issueNumber", cJSON_Number);
    if (json_issue == NULL) {
        log_debug("get issueNumber error.");
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    uint64 issueStart = json_issue->valueint;

    cJSON *json_issueSeq = cJSON_Get(json_params, "issueSeq", cJSON_Number);
    if (json_issueSeq == NULL) {
        log_debug("get issueSeq error.");
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }

    uint8 status = 0;
    uint64 issueStartSeq = json_issueSeq->valueint;

    if ((issueStart == 0) || (issueStartSeq == 0))
    {
        ISSUE_INFO* curr_issue_info = game_plugins_handle[inm_msg->game_code].get_currIssue();
        if (curr_issue_info == NULL) {
            log_info("Get current issue failure. game[%d].", inm_msg->game_code);
            return len;
        }
        inm_msg->issues[0].issue = curr_issue_info->issueNumber;
        inm_msg->issues[0].issueSeq = curr_issue_info->serialNumber;
        inm_msg->issues[0].status = 1;
        inm_msg->issues[0].startTime = curr_issue_info->startTime;
        inm_msg->issues[0].endTime = curr_issue_info->closeTime;
        inm_msg->issues[0].drawTime = 0;
        strcpy(inm_msg->issues[0].drawNumber, " ");
        inm_msg->count = 1;
        return (len + sizeof(INM_MSG_AP_ONE_END_ISSUE));
    }
    else
    {
        GIDB_ISSUE_HANDLE * i_handle = gidb_i_get_handle(inm_msg->game_code);
        if (i_handle == NULL) {
            log_error("SYS_RESULT_FAILURE: gidb_i_get_handle return NULL  gameCode[%d].", inm_msg->game_code);
            msg_header->inm_header.status = SYS_RESULT_FAILURE;
            return len;
        }

        uint32 seqn = issueStartSeq;
        GIDB_ISSUE_INFO issue_info;
        while (1)
        {
            memset((void *)&issue_info,0,sizeof(GIDB_ISSUE_INFO));
            uint8 ret = i_handle->gidb_i_get_info2(i_handle, seqn, &issue_info);
            if (ret != 0) {
                log_error("SYS_RESULT_FAILURE: gidb_i_get_info found error. issue[ %lld ]", issueStart);
                msg_header->inm_header.status = SYS_RESULT_FAILURE;
                return len;
            }
            if (issue_info.status < ISSUE_STATE_OPENED)
            {
                break;
            }

            inm_msg->issues[inm_msg->count].issue = issue_info.issueNumber;
            inm_msg->issues[inm_msg->count].issueSeq = issue_info.serialNumber;
            inm_msg->issues[inm_msg->count].startTime = issue_info.real_start_time;
            inm_msg->issues[inm_msg->count].endTime = issue_info.estimate_close_time;
            inm_msg->issues[inm_msg->count].drawTime = issue_info.estimate_draw_time;
            strcpy(inm_msg->issues[inm_msg->count].drawNumber, issue_info.draw_code_str);
            if (issue_info.status < ISSUE_STATE_CLOSING)
            {
                inm_msg->issues[inm_msg->count].status = 1;
            }
            else if ((issue_info.status < ISSUE_STATE_DRAWNUM_INPUTED) && (issue_info.status >= ISSUE_STATE_CLOSED))
            {
                inm_msg->issues[inm_msg->count].status = 3;
            }
            else if ((issue_info.status < ISSUE_STATE_ISSUE_END) && (issue_info.status >= ISSUE_STATE_DRAWNUM_INPUTED))
            {
                inm_msg->issues[inm_msg->count].status = 4;
            }
            else
            {

                inm_msg->issues[inm_msg->count].drawTime = issue_info.real_draw_time;
                if (check_ap_paid_over_file_exist(inm_msg->game_code, issue_info.issueNumber))
                {
                    inm_msg->issues[inm_msg->count].status = 5;
                }
                else
                    inm_msg->issues[inm_msg->count].status = 4;
            }

            inm_msg->count++;
            if (issue_info.status < ISSUE_STATE_CLOSING)
            {
                break;
            }

            if (inm_msg->count >= (MAX_ISSUE_NUMBER / 2) )
            {
                log_warn("game[%d] issueStartSeq[%llu]  too many issues.", inm_msg->game_code, issueStartSeq);
                break;
            }
            seqn++;
        }

    }
    log_info("R_AP_inquiry_curr_issue_process -> game[%d] issuecount[%d]", inm_msg->game_code, inm_msg->count);
    return (len + sizeof(INM_MSG_AP_ONE_END_ISSUE) * inm_msg->count);
}
int S_AP_inquiry_curr_issue_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns);


    INM_MSG_AP_CURR_ISSUE *inm_msg = (INM_MSG_AP_CURR_ISSUE *)inm_buf;

    cJSON *json_winPrizeArray = cJSON_CreateArray();
    INM_MSG_AP_ONE_END_ISSUE *ptr = NULL;
    cJSON* item = NULL;
    for (int i = 0;i < inm_msg->count;i++) {
        ptr = &inm_msg->issues[i];
        item = cJSON_CreateObject();
        cJSON_AddNumberToObject(item, "issueNumber", ptr->issue);
        cJSON_AddNumberToObject(item, "issueSeq", ptr->issueSeq);
        cJSON_AddNumberToObject(item, "issueStatus", ptr->status);
        char time_start[16] = { 0 };
        cJSON_AddStringToObject(item, "startTime", get_date_by_stamp(ptr->startTime, time_start));
        char time_end[16] = { 0 };
        cJSON_AddStringToObject(item, "endTime", get_date_by_stamp(ptr->endTime, time_end));
        char time_draw[16] = { 0 };
        cJSON_AddStringToObject(item, "drawTime", get_date_by_stamp(ptr->drawTime, time_draw));
        cJSON_AddStringToObject(item, "drawNumber", ptr->drawNumber);
        cJSON_AddItemToArray(json_winPrizeArray, item);
    }
    if(inm_msg->count > 0)
        cJSON_AddItemToObject(json_result, "issueList", json_winPrizeArray);


    log_info("S_AP_inquiry_curr_issue_process -> game[%d]", inm_msg->game_code);
    return 0;
}


// inquiry all pre sale issues
int R_AP_inquiry_preSale_issue_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER*)inm_buf;
    INM_MSG_AP_ALL_PRESALE_ISSUES *inm_msg = (INM_MSG_AP_ALL_PRESALE_ISSUES *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_AP_ISSUE_STATE;
    int len = sizeof(INM_MSG_AP_CURR_ISSUE);

    cJSON *json_game = cJSON_Get(json_params, "gameCode", cJSON_Number);
    if (json_game == NULL) {
        log_debug("get gameCode error.");
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    inm_msg->game_code = json_game->valueint;
    if (!isGameBeUsed(inm_msg->game_code)) {
        log_debug("SYS_RESULT_GAME_DISABLE_ERR: gameCode[%d] can't used.", inm_msg->game_code);
        msg_header->inm_header.status = SYS_RESULT_GAME_DISABLE_ERR;
        return len;
    }

    cJSON *json_issue = cJSON_Get(json_params, "issueNumber", cJSON_Number);
    if (json_issue == NULL) {
        log_debug("get issueNumber error.");
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    uint64 startIssue = json_issue->valueint;
    uint8 issue_idx = 1;

    ISSUE_INFO* curr_issue_info = game_plugins_handle[inm_msg->game_code].get_currIssue();
    if (curr_issue_info != NULL)
    {
        ISSUE_INFO *next_issue_ptr = NULL;
        while (1)
        {
            next_issue_ptr = game_plugins_handle[inm_msg->game_code].get_issueInfo2(curr_issue_info->serialNumber + issue_idx);
            if (next_issue_ptr != NULL)
            {
                if (next_issue_ptr->curState == ISSUE_STATE_PRESALE)
                {
                    if (next_issue_ptr->issueNumber > startIssue)
                    {
                        inm_msg->issues[inm_msg->count].issue = next_issue_ptr->issueNumber;
                        inm_msg->issues[inm_msg->count].issueSeq = next_issue_ptr->serialNumber;
                        inm_msg->issues[inm_msg->count].status = 0;
                        inm_msg->issues[inm_msg->count].startTime = next_issue_ptr->startTime;
                        inm_msg->issues[inm_msg->count].endTime = next_issue_ptr->closeTime;
                        inm_msg->count++;
                    }
                }
                else
                    break;
            }
            else
                break;
            issue_idx++;
        }
    }
    else
    {
        log_debug("find game[%d] no curr issue.", inm_msg->game_code);
        return len;
    }
    log_info("R_AP_inquiry_preSale_issue_process -> game[%d]", inm_msg->game_code);
    return (len + sizeof(INM_MSG_AP_ONE_PRESALE_ISSUE) * inm_msg->count);
}
int S_AP_inquiry_preSale_issue_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns);
    INM_MSG_AP_ALL_PRESALE_ISSUES *inm_msg = (INM_MSG_AP_ALL_PRESALE_ISSUES *)inm_buf;

    cJSON *json_winPrizeArray = cJSON_CreateArray();
    INM_MSG_AP_ONE_PRESALE_ISSUE *ptr = NULL;
    cJSON* item = NULL;
    for (int i = 0;i < inm_msg->count;i++) {
        ptr = &inm_msg->issues[i];
        item = cJSON_CreateObject();
        cJSON_AddNumberToObject(item, "issueNumber", ptr->issue);
        cJSON_AddNumberToObject(item, "issueSeq", ptr->issueSeq);
        cJSON_AddNumberToObject(item, "issueStatus", ptr->status);
        char time_start[16] = { 0 };
        cJSON_AddStringToObject(item, "startTime", get_date_by_stamp(ptr->startTime, time_start));
        char time_end[16] = { 0 };
        cJSON_AddStringToObject(item, "endTime", get_date_by_stamp(ptr->endTime, time_end));

        cJSON_AddItemToArray(json_winPrizeArray, item);
    }
    if (inm_msg->count > 0)
        cJSON_AddItemToObject(json_result, "issueList", json_winPrizeArray);

    log_info("S_AP_inquiryTicket_process -> game[%d]", inm_msg->game_code);
    return 0;
}

//get sequence
int get_sequence(uint64 *sequence)
{
    char str[20] = { 0 };
    memset(str, 0, 20);
    FILE *fp = fopen("./test_seq.txt", "r+");//�ļ��������
    if (fp == NULL) {
        log_error("debug:fopen fail. [test_seq.txt]");
        return -1;
    }

    if (NULL == fgets(str, sizeof(str), fp)) {
        str[0] = '1';
    }

    *sequence = atol(str);
    fseek(fp, 0, SEEK_SET);
    memset(str, 0, sizeof(str));
    (*sequence)++;
    sprintf(str, "%lu", *sequence);
    if (EOF == fputs(str, fp)) {
        fclose(fp);
        log_error("fputs fail");
        return -1;
    }

    fclose(fp);
    return 0;
}

// fbs sell ticket
int R_AP_fbs_sellTicket_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
#if 1
    //k-debug:FBS
    log_debug("enter R_AP_fbs_sellTicket_process");
    ts_notused(ns);
    int ret = 0;
    INM_MSG_T_HEADER *header = (INM_MSG_T_HEADER*)inm_buf;
    INM_MSG_FBS_SELL_TICKET *fbs_inm_msg = (INM_MSG_FBS_SELL_TICKET *)inm_buf;
    header->inm_header.type = INM_TYPE_FBS_SELL_TICKET;
    int len = sizeof(INM_MSG_FBS_SELL_TICKET);
    //FBS_TICKET* ticket = (FBS_TICKET*)(fbs_inm_msg->betString);

    //check ap(agencyCode) enabled
//    TMS_AGENCY_RECORD *pAgency = tms_mgr()->getAgencyByIndex(header->agencyIndex);
//    if (pAgency==NULL || !pAgency->used || pAgency->status != ENABLED) {
//        log_error("sell ticket message -> ap[%llu] isn't enabled.", header->agencyCode);
//        header->inm_header.status = SYS_RESULT_T_AGENCY_ERR;//ap������
//        return len;
//    }

//    cJSON *json_reqfn = cJSON_Get(json_params, "reqfn", cJSON_String);
//    if (json_reqfn==NULL) {
//        header->inm_header.status = SYS_RESULT_FAILURE;
//        return len;
//    }


    //k-debug: test
    {
        header->inm_header.status = SYS_RESULT_FAILURE;
        log_debug("http  ap sale");

        cJSON *json_bet_string1 = cJSON_Get(json_params, "bet_string", cJSON_String);
        if (json_bet_string1 != NULL) {
            log_debug("http  ap sale[%s]", json_bet_string1->valuestring);
        }

        return len;
    }



    uint64 sequence = 0;
    ret = get_sequence(&sequence);
    if (ret != 0) {
        log_error("get_sequence fail");
        header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }

    generate_reqfn(1, 789, sequence, fbs_inm_msg->reqfn_ticket);

    cJSON *json_bet_string = cJSON_Get(json_params, "bet_string", cJSON_String);
    if (json_bet_string == NULL) {
        header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }

    if (strlen(json_bet_string->valuestring) >= 2048) {
        header->inm_header.status = SYS_RESULT_SELL_DATA_ERR; //Ͷע�ַ�����ʽ����
        log_error("bet_string len [%d]", strlen(json_bet_string->valuestring));
        return len;
    }

    //memcpy(fbs_inm_msg->reqfn_ticket,json_reqfn->valuestring,TSN_LENGTH);
    fbs_inm_msg->reqfn_ticket[TSN_LENGTH - 1] = 0;
    fbs_inm_msg->betStringLen = sprintf(fbs_inm_msg->betString, "%s", json_bet_string->valuestring) + 1;
    FBS_TICKET *fbs_ticket = (FBS_TICKET *)(fbs_inm_msg->betString + fbs_inm_msg->betStringLen);
    if (0 > gl_fbs_formatTicket(fbs_inm_msg->betString, (char*)fbs_ticket, INM_MSG_BUFFER_LENGTH - 1024 - fbs_inm_msg->betStringLen)) {
        header->inm_header.status = SYS_RESULT_SELL_DATA_ERR; //Ͷע�ַ�����ʽ����
        return len;
    }

    strcpy(fbs_inm_msg->loyaltyNum, "0");

    uint8 game_code = fbs_ticket->game_code;

    // check reqfn_ticket
    string value = ns->kvdb->get(fbs_inm_msg->reqfn_ticket);
    if (value.empty()) {
        ns->kvdb->put(fbs_inm_msg->reqfn_ticket, "");
    }
    else {
        log_warn("SYS_RESULT_FAILURE: reqfn_ticket duplicate. reqfn_ticket[ %s ].", fbs_inm_msg->reqfn_ticket);
        header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }

    gl_dumpFbsTicket(fbs_ticket);

    if (!isGameBeUsed(game_code)) {
        log_debug("SYS_RESULT_GAME_DISABLE_ERR: saleProcessing gameCode[%d] can't used.", game_code);
        header->inm_header.status = SYS_RESULT_GAME_DISABLE_ERR;
        return len;
    }
    TRANSCTRL_PARAM *transctrlParam = gl_getTransctrlParam(game_code);
    if (!transctrlParam->saleFlag) {
        log_debug("SYS_RESULT_SELL_DISABLE_ERR: gl_sale SaleFlag not be used.");
        header->inm_header.status = SYS_RESULT_SELL_DISABLE_ERR;
        return len;
    }
    //����Ƿ��ڷ���ʱ�εķ�Χ��
    if (false == gl_verifyServiceTime(game_code)) {
        log_debug("SYS_RESULT_GAME_SERVICETIME_OUT_ERR: gl_sale time over. game[%d]", game_code);
        header->inm_header.status = SYS_RESULT_GAME_SERVICETIME_OUT_ERR;
        return len;
    }

    //���Ʊ�������
    if (fbs_ticket->bet_amount > transctrlParam->maxAmountPerTicket) {
        log_debug("saleProcessing tmoney[%lld]", fbs_ticket->bet_amount);
        return SYS_RESULT_SELL_TICKET_AMOUNT_ERR;
    }
    //    //���Ͷע����
    //    if ((inm_msg->ticket.betlineCount > transctrlParam->maxBetLinePerTicket) ||
    //         (inm_msg->ticket.betlineCount < 1)) {
    //        log_info("saleProcessing gl_verifyBetCountParam gameCode[%d] betlinecnt[%d] error", game_code, inm_msg->ticket.betlineCount);
    //        msg_header->inm_header.status = SYS_RESULT_SELL_BETLINE_ERR;
    //        return len;
    //    }
    //    //����ڴ����
    //    ISSUE_INFO* curr_issue_info = game_plugins_handle[game_code].get_currIssue(); //����Ϸ�����ȡ��Ϸ��ǰ�ڴ�
    //    if (curr_issue_info == NULL) {
    //        log_info("Get current issue failure. game[%d].", game_code);
    //        msg_header->inm_header.status = SYS_RESULT_SELL_NOISSUE_ERR;
    //        return len;
    //    }
    //    int ret = sale_verifyIssue(game_code, inm_msg->ticket.issue, inm_msg->ticket.issueCount, curr_issue_info);
    //    if ( ret != SYS_RESULT_SUCCESS ) {
    //        log_debug("saleProcessing issueNum[%lld] icount[%d] error", inm_msg->ticket.issue, inm_msg->ticket.issueCount);
    //        msg_header->inm_header.status = ret;
    //        return len;
    //    }
        //������Ϸ�������Ʊ��֤
    uint32 drawTime = 0;
    ret = game_plugins_handle[game_code].fbs_ticket_verify(fbs_ticket, &drawTime);
    if (ret != SYS_RESULT_SUCCESS) {
        log_debug("sale_ticket_verify failure. ticket->%s", fbs_inm_msg->betString);
        header->inm_header.status = ret;
        return len;
    }
    //    //��ȡ������ʼ�ڴκͿ���ʱ��
    //    uint64 saleStartIssue = inm_msg->ticket.issue;
    //    if (inm_msg->ticket.issue==0)
    //        saleStartIssue = curr_issue_info->issueNumber;
    //    ISSUE_INFO * start_issue_info = game_plugins_handle[game_code].get_issueInfo(saleStartIssue);
    //    ISSUE_INFO * end_issue_info = game_plugins_handle[game_code].get_issueInfo2(start_issue_info->serialNumber+inm_msg->ticket.issueCount-1);
    //    if (end_issue_info == NULL) {
    //        log_debug("game plugin get_issueInfo2(game_code[%u], issue_serial[%u]) return NULL.",
    //                  game_code, start_issue_info->serialNumber+inm_msg->ticket.issueCount-1);
    //        msg_header->inm_header.status = SYS_RESULT_FAILURE;
    //        return len;
    //    }
        //fbs_inm_msg->issueNumber = curr_issue_info->;           //ϵͳ������Ʊʱ�ĵ�ǰ�ں�
        //fbs_inm_msg-> = start_issue_info->issueNumber;         //����Ʊʵ����ʵ����ĵ�һ�ڵ��ں�
        //fbs_inm_msg->ticket.issueSeq = start_issue_info->serialNumber;     //����Ʊʵ����ʵ����ĵ�һ�ڵ��ڴ����
        //fbs_inm_msg->ticket.lastIssue = end_issue_info->issueNumber;       //����Ʊʵ����ʵ��������һ�ڵ��ں�
        //fbs_inm_msg->drawTimeStamp = end_issue_info->drawTime;             //���һ�ڵĿ���ʱ��

    //    //��Ϸ���տ��Ƽ��
    //    if ((isGameBeRiskControl(game_code)) && (NULL!=game_plugins_handle[game_code].sale_rk_verify)) {
    //        pthread_mutex_lock(&risk_mutex[game_code]);
    //        ret = game_plugins_handle[game_code].sale_rk_verify(&inm_msg->ticket);
    //        if (false == ret) {
    //            msg_header->inm_header.status = SYS_RESULT_RISK_CTRL_ERR;
    //            pthread_mutex_unlock(&risk_mutex[game_code]);
    //            return len;
    //        }
    //        pthread_mutex_unlock(&risk_mutex[game_code]);
    //    }

    //    int rc = otldb_spcall_sale(inm_buf);
    //    if (rc != SYS_RESULT_SUCCESS) {
    //        log_debug("sell fbs ticket failure.");
    //        fbs_inm_msg->header.inm_header.status = rc;
    //        if ((isGameBeRiskControl(game_code)) && (NULL != game_plugins_handle[game_code].cancel_rk_rollback)) {
    //            pthread_mutex_lock(&risk_mutex[game_code]);
    //            game_plugins_handle[game_code].cancel_rk_rollback(&inm_msg->ticket);
    //            pthread_mutex_unlock(&risk_mutex[game_code]);
    //        }
    //        return len;
    //    }

    //    if (rc != 0) {
    //        //��Ϸ���տ��ƻع�
    //        if ((isGameBeRiskControl(game_code)) &&  (NULL!=game_plugins_handle[game_code].cancel_rk_rollback)) {
    //            pthread_mutex_lock(&risk_mutex[game_code]);
    //            game_plugins_handle[game_code].cancel_rk_rollback(&inm_msg->ticket);
    //            pthread_mutex_unlock(&risk_mutex[game_code]);
    //        }
    //        return len;
    //    }
    len = sizeof(INM_MSG_FBS_SELL_TICKET) + fbs_inm_msg->betStringLen + fbs_ticket->length;
    log_info("R_AP_fbs_sellTicket_process -> ap_token[%llu]", header->token);
    return len;
#endif

}
int S_AP_fbs_sellTicket_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
#if 1
    ts_notused(ns);
    INM_MSG_T_HEADER *header = (INM_MSG_T_HEADER*)inm_buf;
    INM_MSG_FBS_SELL_TICKET *fbs_inm_msg = (INM_MSG_FBS_SELL_TICKET *)inm_buf;
    FBS_TICKET *fbs_ticket = (FBS_TICKET *)(fbs_inm_msg->betString + fbs_inm_msg->betStringLen);

    cJSON_AddStringToObject(json_result, "reqfn", fbs_inm_msg->reqfn_ticket);
    cJSON_AddStringToObject(json_result, "rspfn", fbs_inm_msg->rspfn_ticket);
    cJSON_AddNumberToObject(json_result, "game", fbs_ticket->game_code);
    cJSON_AddNumberToObject(json_result, "issue", fbs_ticket->issue_number);
    cJSON_AddNumberToObject(json_result, "amount", fbs_ticket->bet_amount);

    ns->kvdb->put(fbs_inm_msg->reqfn_ticket, fbs_inm_msg->rspfn_ticket);

    log_info("S_AP_fbs_sellTicket_process -> ap_code[%llu]", header->agencyCode);
#endif
    return 0;
}




// ---------------------------------------------------------------------------------------------
//
//    OMS MESSAGE
//
// ---------------------------------------------------------------------------------------------

#define parse_assert_return(jo) \
    do { \
        if (jo==NULL) { msg_header->inm_header.status = OMS_RESULT_FAILURE; return len; } \
    } while (0)
#define parse_assert_return2(jo) \
    do { \
        if (jo==NULL) { msg_header->status = OMS_RESULT_FAILURE; return len; } \
    } while (0)


int R_OMS_echo_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_ECHO;
    int len = sizeof(INM_MSG_O_HEADER);

    cJSON *json_echo = cJSON_Get(json_params, "echo", cJSON_String); parse_assert_return(json_echo);

    INM_MSG_O_ECHO *inm_msg = (INM_MSG_O_ECHO *)inm_buf;
    inm_msg->echo_len = sprintf(inm_msg->echo_str, "reply -> %s", json_echo->valuestring) + 1;
    return (sizeof(INM_MSG_O_ECHO) + inm_msg->echo_len);
}
int S_OMS_echo_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns);
    INM_MSG_O_ECHO *inm_msg = (INM_MSG_O_ECHO *)inm_buf;

    inm_msg->echo_str[inm_msg->echo_len] = 0;
    cJSON_AddStringToObject(json_result, "echo", inm_msg->echo_str);
    return 0;
}


//------------------------------------------------------------------------------
// ��ѯ��������״̬
//------------------------------------------------------------------------------
int R_OMS_inquiry_system_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns); ts_notused(json_params);
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_INQUIRY_SYSTEM;

    INM_MSG_O_INQUIRY_SYSTEM *inm_msg = (INM_MSG_O_INQUIRY_SYSTEM *)inm_buf;
    inm_msg->run_status = 0;
    return sizeof(INM_MSG_O_INQUIRY_SYSTEM);
}

int S_OMS_inquiry_system_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns);
    INM_MSG_O_INQUIRY_SYSTEM *inm_msg = (INM_MSG_O_INQUIRY_SYSTEM *)inm_buf;

    cJSON_AddNumberToObject(json_result, "runStatus", inm_msg->run_status);
    return 0;
}



//--------------------------------��Ϸ��----------------------------------------


//------------------------------------------------------------------------------
// �޸���Ϸ���߲���
//------------------------------------------------------------------------------
int R_OMS_gl_policy_param_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_GL_POLICY_PARAM;
    int len = sizeof(INM_MSG_O_HEADER);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return(json_gameCode);
    cJSON *json_publicFundRate = cJSON_Get(json_params, "publicFundRate", cJSON_Number); parse_assert_return(json_publicFundRate);
    cJSON *json_adjustmentFundRate = cJSON_Get(json_params, "adjustmentFundRate", cJSON_Number); parse_assert_return(json_adjustmentFundRate);
    cJSON *json_returnRate = cJSON_Get(json_params, "returnRate", cJSON_Number); parse_assert_return(json_returnRate);
    cJSON *json_taxStartAmount = cJSON_Get(json_params, "taxStartAmount", cJSON_Number); parse_assert_return(json_taxStartAmount);
    cJSON *json_taxRate = cJSON_Get(json_params, "taxRate", cJSON_Number); parse_assert_return(json_taxRate);
    cJSON *json_payEndDay = cJSON_Get(json_params, "payEndDay", cJSON_Number); parse_assert_return(json_payEndDay);

    //��鵱ǰû���Ѽ��ص��ڴ�(OMS��֤)
    POLICY_PARAM* param = gl_getPolicyParam(json_gameCode->valueint);
    param->publicFundRate = json_publicFundRate->valueint;
    param->adjustmentFundRate = json_adjustmentFundRate->valueint;
    param->returnRate = json_returnRate->valueint;
    param->taxStartAmount = json_taxStartAmount->valuedouble;
    param->taxRate = json_taxRate->valueint;
    param->payEndDay = json_payEndDay->valueint;
    log_info("OMS modify game[%d] policy param success", (int32)json_gameCode->valueint);

    //����notify��Ϣ:�޸���Ϸ���߲���
    GLTP_MSG_NTF_GL_POLICY_PARAM notify;
    notify.gameCode = json_gameCode->valueint;
    notify.publicFundRate = param->publicFundRate;
    notify.adjustmentFundRate = param->adjustmentFundRate;
    notify.returnRate = param->returnRate;
    notify.taxStartAmount = param->taxStartAmount;
    notify.taxRate = param->taxRate;
    notify.payEndDay = param->payEndDay;
    sys_notify(GLTP_NTF_GL_POLICY_PARAM, _WARN, (char *)&notify, sizeof(GLTP_MSG_NTF_GL_POLICY_PARAM));
    return len;
}

int S_OMS_gl_policy_param_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}

//------------------------------------------------------------------------------
// �޸���Ϸ��ͨ�������
//------------------------------------------------------------------------------
int R_OMS_gl_rule_param_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_GL_RULE_PARAM;
    int len = sizeof(INM_MSG_O_HEADER);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return(json_gameCode);
    cJSON *json_maxTimesPerBetLine = cJSON_Get(json_params, "maxTimesPerBetLine", cJSON_Number); parse_assert_return(json_maxTimesPerBetLine);
    cJSON *json_maxBetLinePerTicket = cJSON_Get(json_params, "maxBetLinePerTicket", cJSON_Number); parse_assert_return(json_maxBetLinePerTicket);
    cJSON *json_maxAmountPerTicket = cJSON_Get(json_params, "maxAmountPerTicket", cJSON_Number); parse_assert_return(json_maxAmountPerTicket);

    TRANSCTRL_PARAM* param = gl_getTransctrlParam(json_gameCode->valueint);
    param->maxTimesPerBetLine = json_maxTimesPerBetLine->valueint;
    param->maxBetLinePerTicket = json_maxBetLinePerTicket->valueint;
    param->maxAmountPerTicket = json_maxAmountPerTicket->valuedouble;

    //����notify��Ϣ:�޸���Ϸ��ͨ�������
    GLTP_MSG_NTF_GL_RULE_PARAM notify;
    notify.gameCode = json_gameCode->valueint;
    notify.maxTimesPerBetLine = param->maxTimesPerBetLine;
    notify.maxBetLinePerTicket = param->maxBetLinePerTicket;
    notify.maxAmountPerTicket = param->maxAmountPerTicket;
    sys_notify(GLTP_NTF_GL_RULE_PARAM, _WARN, (char *)&notify, sizeof(GLTP_MSG_NTF_GL_RULE_PARAM));
    return len;
}

int S_OMS_gl_rule_param_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}

//------------------------------------------------------------------------------
// �޸���Ϸ���Ʋ���
//------------------------------------------------------------------------------
int R_OMS_gl_ctrl_param_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_GL_CTRL_PARAM;
    int len = sizeof(INM_MSG_O_HEADER);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return(json_gameCode);
    cJSON *json_cancelTime = cJSON_Get(json_params, "cancelTime", cJSON_Number); parse_assert_return(json_cancelTime);
    cJSON *json_countDownTimes = cJSON_Get(json_params, "countDownTimes", cJSON_Number); parse_assert_return(json_countDownTimes);
    //    cJSON *json_branchCenterPayLimited = cJSON_Get(json_params, "branchCenterPayLimited", cJSON_Number); parse_assert_return(json_branchCenterPayLimited);
    //    cJSON *json_branchCenterCancelLimited = cJSON_Get(json_params, "branchCenterCancelLimited", cJSON_Number); parse_assert_return(json_branchCenterCancelLimited);
    //    cJSON *json_commonTellerPayLimited = cJSON_Get(json_params, "commonTellerPayLimited", cJSON_Number); parse_assert_return(json_commonTellerPayLimited);
    //    cJSON *json_commonTellerCancelLimited = cJSON_Get(json_params, "commonTellerCancelLimited", cJSON_Number); parse_assert_return(json_commonTellerCancelLimited);

    TRANSCTRL_PARAM* param = gl_getTransctrlParam(json_gameCode->valueint);
    param->cancelTime = json_cancelTime->valueint;
    param->countDownTimes = json_countDownTimes->valueint;
    //    param->branchCenterPayLimited = json_branchCenterPayLimited->valuedouble;
    //    param->branchCenterCancelLimited = json_branchCenterCancelLimited->valuedouble;
    //    param->commonTellerPayLimited = json_commonTellerPayLimited->valuedouble;
    //    param->commonTellerCancelLimited = json_commonTellerCancelLimited->valuedouble;

        //����notify��Ϣ:�޸���Ϸ���Ʋ���
    GLTP_MSG_NTF_GL_CTRL_PARAM notify;
    notify.gameCode = json_gameCode->valueint;
    notify.cancelTime = param->cancelTime;
    notify.countDownTimes = param->countDownTimes;
    //    notify.branchCenterPayLimited = param->branchCenterPayLimited;
    //    notify.branchCenterCancelLimited = param->branchCenterCancelLimited;
    //    notify.commonTellerPayLimited = param->commonTellerPayLimited;
    //    notify.commonTellerCancelLimited = param->commonTellerCancelLimited;
    sys_notify(GLTP_NTF_GL_CTRL_PARAM, _WARN, (char *)&notify, sizeof(GLTP_MSG_NTF_GL_CTRL_PARAM));
    return len;
}

int S_OMS_gl_ctrl_param_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}

//------------------------------------------------------------------------------
// �޸���Ϸ���տ��Ʋ���
//------------------------------------------------------------------------------
int R_OMS_gl_riskctrl_param_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_GL_RISK_CTRL_PARAM;
    int len = sizeof(INM_MSG_O_HEADER);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return(json_gameCode);
    cJSON *json_riskCtrl = cJSON_Get(json_params, "riskCtrl", cJSON_Number); parse_assert_return(json_riskCtrl);
    cJSON *json_riskCtrlStr = cJSON_Get(json_params, "riskCtrlStr", cJSON_String); parse_assert_return(json_riskCtrlStr);

    TRANSCTRL_PARAM* param = gl_getTransctrlParam(json_gameCode->valueint);
    if (json_riskCtrl->valueint == 1)
    {
        param->riskCtrl = true;
        memset(param->riskCtrlParam, 0, sizeof(param->riskCtrlParam));
        strcpy(param->riskCtrlParam, json_riskCtrlStr->valuestring);
    }
    else {
        param->riskCtrl = false;
    }

    //����notify��Ϣ:�޸���Ϸ���տ��Ʋ���
    GLTP_MSG_NTF_GL_RISK_CTRL_PARAM notify;
    notify.gameCode = json_gameCode->valueint;
    notify.riskCtrl = param->riskCtrl;
    notify.strLength = strlen(param->riskCtrlParam);
    memset(notify.riskCtrlStr, 0, sizeof(notify.riskCtrlStr));
    strcpy(notify.riskCtrlStr, param->riskCtrlParam);
    sys_notify(GLTP_NTF_GL_RISK_CTRL_PARAM, _WARN, (char *)&notify, (sizeof(GLTP_MSG_NTF_GL_RISK_CTRL_PARAM) + notify.strLength));
    return len;
}

int S_OMS_gl_riskctrl_param_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}

//------------------------------------------------------------------------------
// ��Ϸ���ۿ���
//------------------------------------------------------------------------------
int R_OMS_gl_sale_ctrl_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_GL_SALE_CTRL;
    int len = sizeof(INM_MSG_O_HEADER);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return(json_gameCode);
    cJSON *json_canSale = cJSON_Get(json_params, "canSale", cJSON_Number); parse_assert_return(json_canSale);

    gl_setGameCtrl(json_gameCode->valueint, 1, json_canSale->valueint);
    return len;
}

int S_OMS_gl_sale_ctrl_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}

//------------------------------------------------------------------------------
// ��Ϸ�ҽ�����
//------------------------------------------------------------------------------
int R_OMS_gl_pay_ctrl_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_GL_PAY_CTRL;
    int len = sizeof(INM_MSG_O_HEADER);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return(json_gameCode);
    cJSON *json_canPay = cJSON_Get(json_params, "canPay", cJSON_Number); parse_assert_return(json_canPay);

    gl_setGameCtrl(json_gameCode->valueint, 2, json_canPay->valueint);
    return len;
}

int S_OMS_gl_pay_ctrl_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}

//------------------------------------------------------------------------------
// ��Ϸ��Ʊ����
//------------------------------------------------------------------------------
int R_OMS_gl_cancel_ctrl_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_GL_CANCEL_CTRL;
    int len = sizeof(INM_MSG_O_HEADER);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return(json_gameCode);
    cJSON *json_canCancel = cJSON_Get(json_params, "canCancel", cJSON_Number); parse_assert_return(json_canCancel);

    gl_setGameCtrl(json_gameCode->valueint, 3, json_canCancel->valueint);
    return len;
}

int S_OMS_gl_cancel_ctrl_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}

//------------------------------------------------------------------------------
// ��Ϸ�Զ���������
//------------------------------------------------------------------------------
int R_OMS_gl_autodraw_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_GL_AUTO_DRAW;
    int len = sizeof(INM_MSG_O_HEADER);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return(json_gameCode);
    cJSON *json_canAuto = cJSON_Get(json_params, "canAuto", cJSON_Number); parse_assert_return(json_canAuto);

    gl_setAutoDrawStatus(json_gameCode->valueint, json_canAuto->valueint);
    return len;
}

int S_OMS_gl_autodraw_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}

//------------------------------------------------------------------------------
// ��Ϸ����ʱ������
//------------------------------------------------------------------------------
int R_OMS_gl_servicetime_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_GL_SERVICE_TIME;
    int len = sizeof(INM_MSG_O_HEADER);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return(json_gameCode);
    cJSON *json_service_time_1_b = cJSON_Get(json_params, "service_time_1_b", cJSON_Number); parse_assert_return(json_service_time_1_b);
    cJSON *json_service_time_1_e = cJSON_Get(json_params, "service_time_1_e", cJSON_Number); parse_assert_return(json_service_time_1_e);
    cJSON *json_service_time_2_b = cJSON_Get(json_params, "service_time_2_b", cJSON_Number); parse_assert_return(json_service_time_2_b);
    cJSON *json_service_time_2_e = cJSON_Get(json_params, "service_time_2_e", cJSON_Number); parse_assert_return(json_service_time_2_e);

    TRANSCTRL_PARAM* param = gl_getTransctrlParam(json_gameCode->valueint);
    param->service_time_1_b = json_service_time_1_b->valueint;
    param->service_time_1_e = json_service_time_1_e->valueint;
    param->service_time_2_b = json_service_time_2_b->valueint;
    param->service_time_2_e = json_service_time_2_e->valueint;
    return len;
}

int S_OMS_gl_servicetime_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}

//------------------------------------------------------------------------------
// ��Ϸ�澯��ֵ����
//------------------------------------------------------------------------------
int R_OMS_gl_warn_threshold_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_GL_WARN_THRESHOLD;
    int len = sizeof(INM_MSG_O_HEADER);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return(json_gameCode);
    cJSON *json_saleLimit = cJSON_Get(json_params, "saleLimit", cJSON_Number); parse_assert_return(json_saleLimit);
    cJSON *json_payLimit = cJSON_Get(json_params, "payLimit", cJSON_Number); parse_assert_return(json_payLimit);
    cJSON *json_cancelLimit = cJSON_Get(json_params, "cancelLimit", cJSON_Number); parse_assert_return(json_cancelLimit);

    TRANSCTRL_PARAM* param = gl_getTransctrlParam(json_gameCode->valueint);
    param->saleLimit = json_saleLimit->valuedouble;
    param->payLimit = json_payLimit->valuedouble;
    param->cancelLimit = json_cancelLimit->valuedouble;
    return len;
}

int S_OMS_gl_warn_threshold_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}



//--------------------------------�ڴ���----------------------------------------


//------------------------------------------------------------------------------
// �����ڴ�
//------------------------------------------------------------------------------
int R_OMS_gl_issue_delete_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_GL_ISSUE_DEL;
    int len = sizeof(INM_MSG_O_HEADER);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return(json_gameCode);
    cJSON *json_issueNumber = cJSON_Get(json_params, "issueNumber", cJSON_Number); parse_assert_return(json_issueNumber);

    INM_MSG_O_GL_ISSUE_DEL *inm_msg = (INM_MSG_O_GL_ISSUE_DEL *)inm_buf;
    inm_msg->gameCode = json_gameCode->valueint;
    inm_msg->issueNumber = json_issueNumber->valuedouble;
    return sizeof(INM_MSG_O_GL_ISSUE_DEL);
}

int S_OMS_gl_issue_delete_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}

//------------------------------------------------------------------------------
// �ڴο��������ο���-���ã�(���״ο����ɹ���ɺ���ܷ���)
//------------------------------------------------------------------------------
int R_OMS_gl_issue_second_draw_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_HEADER *msg_header = (INM_MSG_HEADER *)inm_buf;
    msg_header->type = INM_TYPE_ISSUE_SECOND_DRAW;
    int len = sizeof(INM_MSG_HEADER);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return2(json_gameCode);
    cJSON *json_issueNumber = cJSON_Get(json_params, "issueNumber", cJSON_Number); parse_assert_return2(json_issueNumber);
    cJSON *json_drawTimes = cJSON_Get(json_params, "drawTimes", cJSON_Number); parse_assert_return2(json_drawTimes);

    INM_MSG_ISSUE_SECOND_DRAW *inm_msg = (INM_MSG_ISSUE_SECOND_DRAW *)inm_buf;
    inm_msg->gameCode = json_gameCode->valueint;
    inm_msg->issueNumber = json_issueNumber->valuedouble;
    inm_msg->drawTimes = json_drawTimes->valueint;

    inm_msg->header.length = sizeof(INM_MSG_ISSUE_SECOND_DRAW);
    //д�뿪����־��
    int ret = send_issue_status_message2(inm_msg->gameCode, inm_msg->issueNumber, INM_TYPE_ISSUE_SECOND_DRAW, inm_buf, inm_msg->header.length);
    if (ret < 0) {
        log_error("send_issue_status_message2() failure. game[%d] issue_number[%lld] INM_TYPE_ISSUE_SECOND_DRAW",
            inm_msg->gameCode, inm_msg->issueNumber);
        msg_header->status = OMS_RESULT_FAILURE;
        return len;
    }
    return sizeof(INM_MSG_ISSUE_SECOND_DRAW);
}

int S_OMS_gl_issue_second_draw_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}

//------------------------------------------------------------------------------
// �ڽ� �C> ��������¼��
//------------------------------------------------------------------------------
int R_OMS_gl_issue_input_drawresult_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_HEADER *msg_header = (INM_MSG_HEADER *)inm_buf;
    msg_header->type = INM_TYPE_ISSUE_STATE_DRAWNUM_INPUTED;
    int len = sizeof(INM_MSG_HEADER);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return2(json_gameCode);
    cJSON *json_issueNumber = cJSON_Get(json_params, "issueNumber", cJSON_Number); parse_assert_return2(json_issueNumber);
    cJSON *json_drawTimes = cJSON_Get(json_params, "drawTimes", cJSON_Number); parse_assert_return2(json_drawTimes);
    cJSON *json_numberCount = cJSON_Get(json_params, "numberCount", cJSON_Number); parse_assert_return2(json_numberCount);
    cJSON *json_drawNumber = cJSON_Get(json_params, "drawNumber", cJSON_String); parse_assert_return2(json_drawNumber);
    cJSON *json_timeStamp = cJSON_Get(json_params, "timeStamp", cJSON_Number); parse_assert_return2(json_timeStamp);
    //cJSON *json_gameDisplay = cJSON_Get(json_params, "gameDisplay", cJSON_String); parse_assert_return2(json_gameDisplay);

    INM_MSG_ISSUE_DRAWNUM_INPUTE *inm_msg = (INM_MSG_ISSUE_DRAWNUM_INPUTE *)inm_buf;
    inm_msg->gameCode = json_gameCode->valueint;
    inm_msg->issueNumber = json_issueNumber->valuedouble;
    inm_msg->drawTimes = json_drawTimes->valueint;
    inm_msg->count = json_numberCount->valueint;
    strcpy(inm_msg->drawCodesStr, json_drawNumber->valuestring);
    inm_msg->timeStamp = json_timeStamp->valueint;

    char numTmp[MAX_GAME_RESULTS_STR_LEN] = { 0 };
    strcpy(numTmp, json_drawNumber->valuestring);
    char *last = NULL;
    char *p = strtok_r(numTmp, ",", &last);
    if (p == NULL) {
        log_error("drawNumber is NULL");
        return -1;
    }
    for (int i = 0; p != NULL; i++)
    {
        inm_msg->drawCodes[i] = atoi(p);
        p = strtok_r(NULL, ",", &last);
    }


    msg_header->length = sizeof(INM_MSG_ISSUE_DRAWNUM_INPUTE);
    //д�뿪����־��
    int ret = send_issue_status_message2(inm_msg->gameCode, inm_msg->issueNumber, INM_TYPE_ISSUE_STATE_DRAWNUM_INPUTED, inm_buf, inm_msg->header.length);
    if (ret < 0) {
        log_error("send_issue_status_message2() failure. game[%d] issue_number[%lld] INM_TYPE_ISSUE_STATE_DRAWNUM_INPUTED",
            inm_msg->gameCode, inm_msg->issueNumber);
        msg_header->status = OMS_RESULT_FAILURE;
        return len;
    }
    return sizeof(INM_MSG_ISSUE_DRAWNUM_INPUTE);
}

int S_OMS_gl_issue_input_drawresult_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}



//------------------------------------------------------------------------------
// �ڽ� -> ��Ϸ���ز��� (Ŀǰδʵ��)
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
// �ڽ� �C> ��������¼��
//------------------------------------------------------------------------------
int R_OMS_gl_issue_prize_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_HEADER *msg_header = (INM_MSG_HEADER *)inm_buf;
    msg_header->type = INM_TYPE_ISSUE_STATE_PRIZE_ADJUSTED;
    int len = sizeof(INM_MSG_HEADER);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return2(json_gameCode);
    cJSON *json_issueNumber = cJSON_Get(json_params, "issueNumber", cJSON_Number); parse_assert_return2(json_issueNumber);
    cJSON *json_drawTimes = cJSON_Get(json_params, "drawTimes", cJSON_Number); parse_assert_return2(json_drawTimes);
    cJSON *json_prizeCount = cJSON_Get(json_params, "prizeCount", cJSON_Number); parse_assert_return2(json_prizeCount);
    cJSON *json_prizes = cJSON_GetObjectItem(json_params, "prizes");
    if (json_prizes == NULL || json_prizes->type != cJSON_Array) {
        log_warn("Message field [ json_prizes ] parse error.");
        msg_header->status = OMS_RESULT_FAILURE;
        return len;
    }

    INM_MSG_ISSUE_WLEVEL *inm_msg = (INM_MSG_ISSUE_WLEVEL *)inm_buf;
    inm_msg->gameCode = json_gameCode->valueint;
    inm_msg->issueNumber = json_issueNumber->valuedouble;
    inm_msg->drawTimes = json_drawTimes->valueint;
    inm_msg->poolAmount = 0;
    inm_msg->count = json_prizeCount->valueint;
    cJSON *json_prizes_item = NULL; cJSON *json_priceCode = NULL; cJSON *json_prizeAmount = NULL;
    for (uint32 i = 0; i < inm_msg->count; i++)
    {
        json_prizes_item = cJSON_GetArrayItem(json_prizes, i);
        if (json_prizes_item == NULL || json_prizes_item->type != cJSON_Object) {
            log_warn("Message field [ prizes item ] parse error.");
            msg_header->status = OMS_RESULT_FAILURE;
            return len;
        }
        json_priceCode = cJSON_Get(json_prizes_item, "prizeCode", cJSON_Number); parse_assert_return2(json_priceCode);
        json_prizeAmount = cJSON_Get(json_prizes_item, "prizeAmount", cJSON_Number); parse_assert_return2(json_prizeAmount);
        inm_msg->prize_list[i].prize_code = json_priceCode->valueint;
        inm_msg->prize_list[i].money_amount = json_prizeAmount->valuedouble;
    }

    msg_header->length = sizeof(INM_MSG_ISSUE_WLEVEL) + inm_msg->count * sizeof(PRIZE_LEVEL);
    //д�뿪����־��
    int ret = send_issue_status_message2(inm_msg->gameCode, inm_msg->issueNumber, INM_TYPE_ISSUE_STATE_PRIZE_ADJUSTED, inm_buf, inm_msg->header.length);
    if (ret < 0) {
        log_error("send_issue_status_message2() failure. game[%d] issue_number[%lld] INM_TYPE_ISSUE_STATE_PRIZE_ADJUSTED",
            inm_msg->gameCode, inm_msg->issueNumber);
        msg_header->status = OMS_RESULT_FAILURE;
        return len;
    }
    return sizeof(INM_MSG_ISSUE_WLEVEL) + inm_msg->count * sizeof(PRIZE_LEVEL);
}

int S_OMS_gl_issue_prize_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}

//------------------------------------------------------------------------------
// �ڽ� �C> �ַ���������ժҪ
//------------------------------------------------------------------------------
int R_OMS_gl_issue_md5sum_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_HEADER *msg_header = (INM_MSG_HEADER *)inm_buf;
    msg_header->type = INM_TYPE_ISSUE_SALE_FILE_MD5SUM;
    int len = sizeof(INM_MSG_HEADER);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return2(json_gameCode);
    cJSON *json_issueNumber = cJSON_Get(json_params, "issueNumber", cJSON_Number); parse_assert_return2(json_issueNumber);
    cJSON *json_drawTimes = cJSON_Get(json_params, "drawTimes", cJSON_Number); parse_assert_return2(json_drawTimes);
    cJSON *json_md5sum = cJSON_Get(json_params, "md5sum", cJSON_String); parse_assert_return2(json_md5sum);

    INM_MSG_ISSUE_SALE_FILE_MD5SUM *inm_msg = (INM_MSG_ISSUE_SALE_FILE_MD5SUM *)inm_buf;
    inm_msg->gameCode = json_gameCode->valueint;
    inm_msg->issueNumber = json_issueNumber->valuedouble;
    inm_msg->drawTimes = json_drawTimes->valueint;
    strncpy((char*)inm_msg->md5sum, json_md5sum->valuestring, 32);

    msg_header->length = sizeof(INM_MSG_ISSUE_SALE_FILE_MD5SUM);
    //д�뿪����־��
    int ret = send_issue_status_message2(inm_msg->gameCode, inm_msg->issueNumber, INM_TYPE_ISSUE_SALE_FILE_MD5SUM, inm_buf, inm_msg->header.length);
    if (ret < 0) {
        log_error("send_issue_status_message2() failure. game[%d] issue_number[%lld] INM_TYPE_ISSUE_SALE_FILE_MD5SUM",
            inm_msg->gameCode, inm_msg->issueNumber);
        msg_header->status = OMS_RESULT_FAILURE;
        return len;
    }

    return sizeof(INM_MSG_ISSUE_SALE_FILE_MD5SUM);
}

int S_OMS_gl_issue_md5sum_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}

//------------------------------------------------------------------------------
// �ڽ� �C> ����ȷ��
//------------------------------------------------------------------------------
int R_OMS_gl_issue_draw_confirm_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_HEADER *msg_header = (INM_MSG_HEADER *)inm_buf;
    msg_header->type = INM_TYPE_ISSUE_STATE_PRIZE_CONFIRMED;
    int len = sizeof(INM_MSG_HEADER);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return2(json_gameCode);
    cJSON *json_issueNumber = cJSON_Get(json_params, "issueNumber", cJSON_Number); parse_assert_return2(json_issueNumber);
    cJSON *json_drawTimes = cJSON_Get(json_params, "drawTimes", cJSON_Number); parse_assert_return2(json_drawTimes);

    INM_MSG_ISSUE_STATE *inm_msg = (INM_MSG_ISSUE_STATE *)inm_buf;
    inm_msg->gameCode = json_gameCode->valueint;
    inm_msg->issueNumber = json_issueNumber->valuedouble;
    inm_msg->drawTimes = json_drawTimes->valueint;

    msg_header->length = sizeof(INM_MSG_ISSUE_STATE);
    //д�뿪����־��
    int ret = send_issue_status_message(inm_msg->gameCode, inm_msg->issueNumber, INM_TYPE_ISSUE_STATE_PRIZE_CONFIRMED, inm_msg->drawTimes);
    if (ret < 0) {
        log_error("send_issue_status_message2() failure. game[%d] issue_number[%lld] INM_TYPE_ISSUE_STATE_PRIZE_CONFIRMED",
            inm_msg->gameCode, inm_msg->issueNumber);
        msg_header->status = OMS_RESULT_FAILURE;
        return len;
    }
    return sizeof(INM_MSG_ISSUE_STATE);
}

int S_OMS_gl_issue_draw_confirm_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}

//------------------------------------------------------------------------------
// �ڽ� �C> ���¿���(�������ڽ��еĿ��������½��п���)
//------------------------------------------------------------------------------
int R_OMS_gl_issue_redo_draw_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_HEADER *msg_header = (INM_MSG_HEADER *)inm_buf;
    msg_header->type = INM_TYPE_ISSUE_DRAW_REDO;
    int len = sizeof(INM_MSG_HEADER);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return2(json_gameCode);
    cJSON *json_issueNumber = cJSON_Get(json_params, "issueNumber", cJSON_Number); parse_assert_return2(json_issueNumber);
    cJSON *json_drawTimes = cJSON_Get(json_params, "drawTimes", cJSON_Number); parse_assert_return2(json_drawTimes);

    INM_MSG_ISSUE_DRAW_REDO *inm_msg = (INM_MSG_ISSUE_DRAW_REDO *)inm_buf;
    inm_msg->gameCode = json_gameCode->valueint;
    inm_msg->issueNumber = json_issueNumber->valuedouble;
    inm_msg->drawTimes = json_drawTimes->valueint;

    msg_header->length = sizeof(INM_MSG_ISSUE_DRAW_REDO);
    //д�뿪����־��
    int ret = send_issue_status_message2(inm_msg->gameCode, inm_msg->issueNumber, INM_TYPE_ISSUE_DRAW_REDO, inm_buf, inm_msg->header.length);
    if (ret < 0) {
        log_error("send_issue_status_message2() failure. game[%d] issue_number[%lld] INM_TYPE_ISSUE_DRAW_REDO",
            inm_msg->gameCode, inm_msg->issueNumber);
        msg_header->status = OMS_RESULT_FAILURE;
        return len;
    }
    return sizeof(INM_MSG_ISSUE_DRAW_REDO);
}

int S_OMS_gl_issue_redo_draw_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}


//------------------------------------------------------------------------------
// �����ڴ�֪ͨ
//------------------------------------------------------------------------------
int R_OMS_gl_issue_add_nfy_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_GL_ISSUE_ADD_NFY;
    int len = sizeof(INM_MSG_O_HEADER);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return(json_gameCode);

    INM_MSG_O_GL_ISSUE_ADD_NFY *inm_msg = (INM_MSG_O_GL_ISSUE_ADD_NFY *)inm_buf;
    inm_msg->gameCode = json_gameCode->valueint;
    return sizeof(INM_MSG_O_GL_ISSUE_ADD_NFY);
}

int S_OMS_gl_issue_add_nfy_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}






//--------------------------------��Ʊ����--------------------------------------


//------------------------------------------------------------------------------
// ��Ʊ��ѯ
//------------------------------------------------------------------------------
int r_oms_inquiryticket(char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec)
{
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    INM_MSG_O_INQUIRY_TICKET *inm_msg = (INM_MSG_O_INQUIRY_TICKET *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_INQUIRY_TICKET;
    int len = sizeof(INM_MSG_O_INQUIRY_TICKET);

    inm_msg->unique_tsn = tidx_rec->unique_tsn;
    strcpy(inm_msg->rspfn_ticket, tidx_rec->rspfn_ticket);
    inm_msg->gameCode = tidx_rec->gameCode;
    inm_msg->startIssueNumber = tidx_rec->issueNumber; //�����ں�
    inm_msg->lastIssueNumber = tidx_rec->drawIssueNumber;

    uint8 game_code = tidx_rec->gameCode;
    inm_msg->prizeCount = 0;
    //�����Ϸ����
    if (!isGameBeUsed(game_code)) {
        log_debug("OMS_RESULT_FAILURE: process_O_inquiry_ticket gameCode[%d] can't used.", game_code);
        msg_header->inm_header.status = OMS_RESULT_GAME_DISABLE_ERR;
        return len;
    }
    GAME_PARAM *param = gl_getGameParam(game_code);
    strncpy(inm_msg->gameName, param->gameName, MAX_GAME_NAME_LENGTH);
    //�õ������ڵ���Ϣ
    GIDB_ISSUE_HANDLE * i_handle = gidb_i_get_handle(game_code);
    if (i_handle == NULL) {
        log_warn("gidb_i_get_handle return NULL  gameCode[%d].", game_code);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    GIDB_ISSUE_INFO issue_info;
    int ret = i_handle->gidb_i_get_info(i_handle, inm_msg->startIssueNumber, &issue_info);
    if (ret != 0) {
        log_debug("gidb_i_get_info found error. issueNumber[ %lld ]", issue_info.issueNumber);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    //��ѯ����Ʊ
    GIDB_T_TICKET_HANDLE *t_handle = gidb_t_get_handle(game_code, issue_info.issueNumber);
    if (t_handle == NULL) {
        log_warn("gidb_t_get_handle return NULL  gameCode[%d] issueNumber[%lld].", game_code, inm_msg->startIssueNumber);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    char sale_ticket_buf[INM_MSG_BUFFER_LENGTH] = { 0 };
    GIDB_SALE_TICKET_REC *pSaleTicket = (GIDB_SALE_TICKET_REC *)sale_ticket_buf;
    ret = t_handle->gidb_t_get_ticket(t_handle, inm_msg->unique_tsn, pSaleTicket);
    if (ret < 0) {
        log_error("gidb_t_get_ticket found error. rspfn_ticket[ %s ] unique_tsn[ %llu ]", inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    else if (ret == 1) {
        log_debug("OMS_RESULT_TICKET_UNFOUND: gidb_get_sell_ticket return NULL. rspfn_ticket[ %s ] unique_tsn[ %llu ]",
            inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        msg_header->inm_header.status = OMS_RESULT_TICKET_NOT_FOUND_ERR; //û���ҵ����Ų�Ʊ
        return len;
    }
    inm_msg->startIssueSerial = pSaleTicket->ticket.issueSeq;
    inm_msg->lastIssueSerial = pSaleTicket->ticket.issueSeq + pSaleTicket->ticket.issueCount - 1;
    inm_msg->issueCount = pSaleTicket->ticket.issueCount;
    inm_msg->ticketAmount = pSaleTicket->ticket.amount;
    inm_msg->sale_termCode = pSaleTicket->terminalCode;
    inm_msg->sale_tellerCode = pSaleTicket->tellerCode;
    inm_msg->sale_time = pSaleTicket->timeStamp;
    inm_msg->betStringLen = pSaleTicket->ticket.betStringLen;
    strncpy(inm_msg->betString, pSaleTicket->ticket.betString, inm_msg->betStringLen);

    inm_msg->from_sale = pSaleTicket->from_sale;

    inm_msg->isTrain = pSaleTicket->isTrain;
    inm_msg->isCancel = pSaleTicket->isCancel;
    if (inm_msg->isCancel) {
        //����Ʊ
        inm_msg->cancel_termCode = pSaleTicket->terminalCode_cancel;
        inm_msg->cancel_tellerCode = pSaleTicket->tellerCode_cancel;
        inm_msg->cancel_time = pSaleTicket->timeStamp_cancel;
        msg_header->inm_header.status = OMS_RESULT_SUCCESS;
        return len;
    }
    //�ж��Ƿ����Ʊ
    GIDB_ISSUE_INFO last_issue_info;
    if (inm_msg->issueCount > 1) {
        memset(&last_issue_info, 0, sizeof(GIDB_ISSUE_INFO));
        ret = i_handle->gidb_i_get_info(i_handle, inm_msg->lastIssueNumber, &last_issue_info);
        if (ret != 0) {
            log_error("gidb_i_get_info found error. gameCode[%d]", game_code);
            msg_header->inm_header.status = OMS_RESULT_FAILURE;
            return len;
        }
        //check ���һ�ڵ��ڴ�״̬
        if (ISSUE_STATE_ISSUE_END != last_issue_info.status) {
            inm_msg->isWin = 0;
            msg_header->inm_header.status = OMS_RESULT_SUCCESS; //δ�������
            return len;
        }
    }
    if (ISSUE_STATE_ISSUE_END != issue_info.status) {
        inm_msg->isWin = 0;
        log_debug("issue[%lld] state[%d] tsn[%s]", issue_info.issueNumber, issue_info.status, inm_msg->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_SUCCESS; //�ڻ�û�п���
        return len;
    }
    //��ѯ�˲�Ʊ�Ƿ��н�
    GIDB_W_TICKET_HANDLE * w_handle = gidb_w_get_handle(game_code, inm_msg->lastIssueNumber, GAME_DRAW_ONE);
    if (w_handle == NULL) {
        log_error("gidb_w_get_handle return NULL  gameCode[%d] issueNumber[%lld].", game_code, inm_msg->lastIssueNumber);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    char win_ticket_buf[INM_MSG_BUFFER_LENGTH] = { 0 };
    GIDB_WIN_TICKET_REC *pWinTicket = (GIDB_WIN_TICKET_REC *)win_ticket_buf;
    ret = w_handle->gidb_w_get_ticket(w_handle, inm_msg->unique_tsn, pWinTicket);
    if (ret < 0) {
        log_error("gidb_w_get_ticket found error. rspfn_ticket[ %s ] unique_tsn[ %llu ]", inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    else if (ret == 1) {
        inm_msg->isWin = 1;
        msg_header->inm_header.status = OMS_RESULT_SUCCESS; //δ�н�
        return len;
    }
    // �н�
    inm_msg->isWin = 2;
    inm_msg->isBigPrize = pWinTicket->isBigWinning;
    inm_msg->isPayed = 0;
    if (pWinTicket->paid_status == PRIZE_PAYMENT_PAID) {
        inm_msg->isPayed = 1;
        inm_msg->pay_termCode = pWinTicket->terminalCode_pay;
        inm_msg->pay_tellerCode = pWinTicket->tellerCode_pay;
        inm_msg->pay_time = pWinTicket->timeStamp_pay;
        if (inm_msg->isBigPrize) {
            strncpy(inm_msg->customName, pWinTicket->userName_pay, ENTRY_NAME_LEN);
            inm_msg->cardType = pWinTicket->identityType_pay;
            strncpy(inm_msg->cardCode, pWinTicket->identityNumber_pay, IDENTITY_CARD_LENGTH);
        }
    }
    inm_msg->amountBeforeTax = pWinTicket->winningAmountWithTax;
    inm_msg->taxAmount = pWinTicket->taxAmount;
    inm_msg->amountAfterTax = pWinTicket->winningAmount;
    inm_msg->prizeCount = pWinTicket->prizeCount;
    for (int i = 0; i < inm_msg->prizeCount; i++) {
        GL_WIN_PRIZE_INFO *ptr_i = &inm_msg->winprizes[i];
        PRIZE_DETAIL *ptr_d = &pWinTicket->prizeDetail[i];

        ptr_i->prizeCode = ptr_d->prizeCode;
        strncpy(ptr_i->prizeName, ptr_d->name, ENTRY_NAME_LEN);
        ptr_i->betCount = ptr_d->count;
        ptr_i->prizeAmount = ptr_d->amountSingle;
    }

    len = sizeof(INM_MSG_O_INQUIRY_TICKET) + inm_msg->prizeCount * sizeof(GL_WIN_PRIZE_INFO);
    return len;
}

int r_oms_fbs_inquiryticket(char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec)
{
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    INM_MSG_O_FBS_INQUIRY_TICKET *inm_msg = (INM_MSG_O_FBS_INQUIRY_TICKET *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_FBS_INQUIRY_TICKET;
    int len = sizeof(INM_MSG_O_FBS_INQUIRY_TICKET);

    inm_msg->unique_tsn = tidx_rec->unique_tsn;
    strcpy(inm_msg->rspfn_ticket, tidx_rec->rspfn_ticket);
    inm_msg->gameCode = tidx_rec->gameCode;
    inm_msg->issue_number = tidx_rec->issueNumber; //�����ں�
    inm_msg->matchCount = tidx_rec->extend[0];
    memcpy((char*)inm_msg->matchCode, (char*)&tidx_rec->extend[1], tidx_rec->extend_len - 1);

    uint8 game_code = tidx_rec->gameCode;
    //inm_msg->prizeCount = 0;

    //�����Ϸ����
    if (!isGameBeUsed(game_code)) {
        log_debug("OMS_RESULT_FAILURE: process_O_fbs_inquiry_ticket gameCode[%d] can't used.", game_code);
        msg_header->inm_header.status = OMS_RESULT_GAME_DISABLE_ERR;
        return len;
    }
    GAME_PARAM *param = gl_getGameParam(game_code);
    strncpy(inm_msg->gameName, param->gameName, MAX_GAME_NAME_LENGTH);

    //��ѯ����Ʊ
    GIDB_FBS_ST_HANDLE *t_handle = gidb_fbs_st_get_handle(game_code, inm_msg->issue_number);
    if (t_handle == NULL) {
        log_warn("gidb_fbs_st_get_handle return NULL  gameCode[%d] issueNumber[%lld].", game_code, inm_msg->issue_number);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }

    char sale_ticket_buf[INM_MSG_BUFFER_LENGTH] = { 0 };
    GIDB_FBS_ST_REC *pSaleTicket = (GIDB_FBS_ST_REC *)sale_ticket_buf;
    int ret = t_handle->gidb_fbs_st_get_ticket(t_handle, inm_msg->unique_tsn, pSaleTicket);
    if (ret < 0) {
        log_error("gidb_fbs_st_get_ticket found error. rspfn_ticket[ %s ] unique_tsn[ %llu ]", inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    else if (ret == 1) {
        log_debug("OMS_RESULT_TICKET_UNFOUND: gidb_fbs_st_get_ticket return NULL. rspfn_ticket[ %s ] unique_tsn[ %llu ]",
            inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        msg_header->inm_header.status = OMS_RESULT_TICKET_NOT_FOUND_ERR; //û���ҵ����Ų�Ʊ
        return len;
    }

    inm_msg->sub_type = pSaleTicket->sub_type;
    inm_msg->bet_type = pSaleTicket->bet_type;
    inm_msg->ticketAmount = pSaleTicket->total_amount;
    inm_msg->totalBets = pSaleTicket->total_bets;
    inm_msg->sale_termCode = pSaleTicket->terminal_code;
    inm_msg->sale_tellerCode = pSaleTicket->teller_code;
    inm_msg->sale_time = pSaleTicket->time_stamp;
    inm_msg->betStringLen = pSaleTicket->bet_string_len;
    strncpy(inm_msg->betString, pSaleTicket->bet_string, inm_msg->betStringLen);

    inm_msg->from_sale = pSaleTicket->from_sale;

    inm_msg->isTrain = pSaleTicket->is_train;
    inm_msg->isCancel = pSaleTicket->isCancel;
    if (inm_msg->isCancel) {
        //����Ʊ
        inm_msg->cancel_termCode = pSaleTicket->terminalCode_cancel;
        inm_msg->cancel_tellerCode = pSaleTicket->tellerCode_cancel;
        inm_msg->cancel_time = pSaleTicket->timeStamp_cancel;
        msg_header->inm_header.status = OMS_RESULT_SUCCESS;
        return len;
    }

    //check �����ڴ��Ƿ񶼿��꽱,���һ��������
    GIDB_FBS_IM_HANDLE *im_handle = gidb_fbs_im_get_handle(game_code);
    GIDB_FBS_MATCH_INFO match_info = { 0 };
    int flagEnd = 1;
    uint32 drawTime = 0;
    time_t drawTimeTmp = 0;
    char strDrawTime[20] = { 0 };

    for (int i = 0; i < inm_msg->matchCount; i++)
    {
        int ret = im_handle->gidb_fbs_im_get_match(im_handle, inm_msg->matchCode[i], &match_info);
        if (ret < 0) {
            log_error("gidb_fbs_im_get_match fail.match[%u]", inm_msg->matchCode[i]);
            msg_header->inm_header.status = OMS_RESULT_FAILURE;
            return len;
        }

        if (match_info.state != M_STATE_CONFIRM) {
            flagEnd = 0;
            break;
        }
        if (drawTimeTmp < match_info.draw_time) {
            drawTimeTmp = match_info.draw_time;
        }
    }

    struct tm *p = gmtime(&drawTimeTmp);
    strftime(strDrawTime, 20, "%Y%m%d", p);
    drawTime = atoi(strDrawTime);

    //k-debug:test
    log_debug("draw_time:%d, %d", drawTimeTmp, drawTime);

    if (0 == flagEnd) {
        log_debug("issue[%u] tsn[%s]", inm_msg->matchCode, inm_msg->rspfn_ticket);

        inm_msg->isWin = 0;
        msg_header->inm_header.status = OMS_RESULT_SUCCESS; //δ�������
        return len;
    }

    //��ѯ�˲�Ʊ�Ƿ��н�
    GIDB_FBS_WT_HANDLE *wt_handle = gidb_fbs_wt_get_handle(game_code, inm_msg->issue_number);
    if (wt_handle == NULL) {
        log_warn("gidb_fbs_wt_get_handle return NULL  gameCode[%d] issueNumber[%lld].",
            game_code, inm_msg->issue_number);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }

    char win_ticket_buf[INM_MSG_BUFFER_LENGTH] = { 0 };
    GIDB_FBS_WT_REC *pWinTicket = (GIDB_FBS_WT_REC *)win_ticket_buf;
    ret = wt_handle->gidb_fbs_wt_get_ticket(wt_handle, inm_msg->unique_tsn, pWinTicket);
    if (ret < 0) {
        log_error("gidb_fbs_wt_get_ticket found error. rspfn_ticket[ %s ] unique_tsn[ %llu ]",
            inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    else if (ret == 1) {
        inm_msg->isWin = 1;
        msg_header->inm_header.status = OMS_RESULT_SUCCESS; //δ�н�
        return len;
    }

    // �н�
    inm_msg->isWin = 2;
    inm_msg->isBigPrize = pWinTicket->isBigWinning;
    inm_msg->isPayed = 0;
    if (pWinTicket->paid_status == PRIZE_PAYMENT_PAID) {
        inm_msg->isPayed = 1;
        inm_msg->pay_termCode = pWinTicket->terminalCode_pay;
        inm_msg->pay_tellerCode = pWinTicket->tellerCode_pay;
        inm_msg->pay_time = pWinTicket->timeStamp_pay;
        if (inm_msg->isBigPrize) {
            strncpy(inm_msg->customName, pWinTicket->userName_pay, ENTRY_NAME_LEN);
            inm_msg->cardType = pWinTicket->identityType_pay;
            strncpy(inm_msg->cardCode, pWinTicket->identityNumber_pay, IDENTITY_CARD_LENGTH);
        }
    }
    inm_msg->amountBeforeTax = pWinTicket->winningAmountWithTax;
    inm_msg->taxAmount = pWinTicket->taxAmount;
    inm_msg->amountAfterTax = pWinTicket->winningAmount;

    return sizeof(INM_MSG_O_FBS_INQUIRY_TICKET);
}

int R_OMS_ticket_inquiry_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;

    msg_header->inm_header.type = INM_TYPE_COMMOM_ERR;
    int len = sizeof(INM_MSG_O_HEADER);

    cJSON *json_rspfn_ticket = cJSON_Get(json_params, "rspfn_ticket", cJSON_String); parse_assert_return(json_rspfn_ticket);

    //parse rspfn (tsn)
    uint32 date = 0;
    uint64 unique_tsn = extract_tsn(json_rspfn_ticket->valuestring, &date);
    if (unique_tsn == 0) {
        log_error("extract_tsn failed. [ %s ]", json_rspfn_ticket->valuestring);
        msg_header->inm_header.status = OMS_RESULT_TICKET_TSN_ERR; //TSN����
        return len;
    }
    //�������ļ��в�ѯƱ��Ϣ
    char tidx_buf[512] = { 0 };
    GIDB_TICKET_IDX_REC *tidx_rec = (GIDB_TICKET_IDX_REC*)tidx_buf;
    memset(tidx_rec, 0, sizeof(tidx_buf));
    int ret = get_ticket_idx(date, unique_tsn, tidx_rec);
    if (ret < 0) {
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    else if (ret == 1) {
        msg_header->inm_header.status = OMS_RESULT_TICKET_NOT_FOUND_ERR;
        return len;
    }

    //��֤У����
    if (0 != strcmp(json_rspfn_ticket->valuestring, tidx_rec->rspfn_ticket)) {
        log_error("tsn verify fail!!!, [ %s  ---  %s ]", json_rspfn_ticket->valuestring, tidx_rec->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_TICKET_TSN_ERR; //TSN����
        return len;
    }

    if ((tidx_rec->gameCode != GAME_FBS) && (tidx_rec->gameCode != GAME_FODD)) {
        //��ͨ��Ϸ
        return r_oms_inquiryticket(inm_buf, tidx_rec);
    }
    // FBS ��Ϸ
    return r_oms_fbs_inquiryticket(inm_buf, tidx_rec);
}


int s_oms_inquiryticket(char *inm_buf, cJSON *json_result)
{
    INM_MSG_O_INQUIRY_TICKET *inm_msg = (INM_MSG_O_INQUIRY_TICKET *)inm_buf;

    cJSON_AddStringToObject(json_result, "rspfn_ticket", inm_msg->rspfn_ticket);
    cJSON_AddNumberToObject(json_result, "gameCode", inm_msg->gameCode);
    cJSON_AddStringToObject(json_result, "gameName", inm_msg->gameName);
    cJSON_AddNumberToObject(json_result, "from_sale", inm_msg->from_sale);
    cJSON_AddNumberToObject(json_result, "startIssueNumber", inm_msg->startIssueNumber);
    cJSON_AddNumberToObject(json_result, "lastIssueNumber", inm_msg->lastIssueNumber);
    cJSON_AddNumberToObject(json_result, "issueCount", inm_msg->issueCount);
    cJSON_AddNumberToObject(json_result, "ticketAmount", inm_msg->ticketAmount);
    cJSON_AddNumberToObject(json_result, "isTrain", inm_msg->isTrain);
    cJSON_AddNumberToObject(json_result, "isCancel", inm_msg->isCancel);
    cJSON_AddNumberToObject(json_result, "isWin", inm_msg->isWin);
    cJSON_AddNumberToObject(json_result, "isBigPrize", inm_msg->isBigPrize);
    cJSON_AddNumberToObject(json_result, "amountBeforeTax", inm_msg->amountBeforeTax);
    cJSON_AddNumberToObject(json_result, "taxAmount", inm_msg->taxAmount);
    cJSON_AddNumberToObject(json_result, "amountAfterTax", inm_msg->amountAfterTax);
    char tmp[20] = { 0 };
    sprintf(tmp, "%010llu", inm_msg->sale_termCode);

    cJSON_AddStringToObject(json_result, "sale_termCode", tmp);
    cJSON_AddNumberToObject(json_result, "sale_tellerCode", inm_msg->sale_tellerCode);
    cJSON_AddNumberToObject(json_result, "sale_time", inm_msg->sale_time);
    cJSON_AddNumberToObject(json_result, "isPayed", inm_msg->isPayed);

    sprintf(tmp, "%010llu", inm_msg->pay_termCode);
    cJSON_AddStringToObject(json_result, "pay_termCode", tmp);
    cJSON_AddNumberToObject(json_result, "pay_tellerCode", inm_msg->pay_tellerCode);
    cJSON_AddNumberToObject(json_result, "pay_time", inm_msg->pay_time);

    sprintf(tmp, "%010llu", inm_msg->cancel_termCode);
    cJSON_AddStringToObject(json_result, "cancel_termCode", tmp);
    cJSON_AddNumberToObject(json_result, "cancel_tellerCode", inm_msg->cancel_tellerCode);
    cJSON_AddNumberToObject(json_result, "cancel_time", inm_msg->cancel_time);
    cJSON_AddStringToObject(json_result, "customName", inm_msg->customName);
    cJSON_AddNumberToObject(json_result, "cardType", inm_msg->cardType);
    cJSON_AddStringToObject(json_result, "cardCode", inm_msg->cardCode);
    cJSON_AddStringToObject(json_result, "betString", inm_msg->betString);
    cJSON_AddNumberToObject(json_result, "prizeCount", inm_msg->prizeCount);
    cJSON *json_winPrizeArray = cJSON_CreateArray();
    GL_WIN_PRIZE_INFO *ptr = NULL;
    cJSON* item = NULL;
    for (int i = 0;i < inm_msg->prizeCount;i++) {
        ptr = &inm_msg->winprizes[i];
        item = cJSON_CreateObject();
        cJSON_AddNumberToObject(item, "prizeCode", ptr->prizeCode);
        cJSON_AddStringToObject(item, "prizeName", ptr->prizeName);
        cJSON_AddNumberToObject(item, "betCount", ptr->betCount);
        cJSON_AddNumberToObject(item, "prizeAmount", ptr->prizeAmount);
        cJSON_AddItemToArray(json_winPrizeArray, item);
    }
    cJSON_AddItemToObject(json_result, "winPrizes", json_winPrizeArray);
    return 0;
}

int s_oms_fbs_inquiryticket(char *inm_buf, cJSON *json_result)
{
    INM_MSG_O_FBS_INQUIRY_TICKET *inm_msg = (INM_MSG_O_FBS_INQUIRY_TICKET *)inm_buf;

    cJSON_AddStringToObject(json_result, "rspfn_ticket", inm_msg->rspfn_ticket);
    cJSON_AddNumberToObject(json_result, "gameCode", inm_msg->gameCode);
    cJSON_AddStringToObject(json_result, "gameName", inm_msg->gameName);
    cJSON_AddNumberToObject(json_result, "from_sale", inm_msg->from_sale);
    cJSON_AddNumberToObject(json_result, "startIssueNumber", inm_msg->issue_number);
    cJSON_AddNumberToObject(json_result, "lastIssueNumber", 0);
    cJSON_AddNumberToObject(json_result, "issueCount", 1);
    //    cJSON_AddNumberToObject(json_result, "sub_type", inm_msg->sub_type);//OMS��Ҫ,��betString����
    //    cJSON_AddNumberToObject(json_result, "bet_type", inm_msg->bet_type);
    cJSON_AddNumberToObject(json_result, "matchCount", inm_msg->matchCount);
    cJSON_AddNumberToObject(json_result, "ticketAmount", inm_msg->ticketAmount);
    cJSON_AddNumberToObject(json_result, "totalBets", inm_msg->totalBets);
    cJSON_AddNumberToObject(json_result, "isTrain", inm_msg->isTrain);
    cJSON_AddNumberToObject(json_result, "isCancel", inm_msg->isCancel);
    cJSON_AddNumberToObject(json_result, "isWin", inm_msg->isWin);
    cJSON_AddNumberToObject(json_result, "isBigPrize", inm_msg->isBigPrize);
    cJSON_AddNumberToObject(json_result, "amountBeforeTax", inm_msg->amountBeforeTax);
    cJSON_AddNumberToObject(json_result, "taxAmount", inm_msg->taxAmount);
    cJSON_AddNumberToObject(json_result, "amountAfterTax", inm_msg->amountAfterTax);
    char tmp[20] = { 0 };
    sprintf(tmp, "%010llu", inm_msg->sale_termCode);

    cJSON_AddStringToObject(json_result, "sale_termCode", tmp);
    cJSON_AddNumberToObject(json_result, "sale_tellerCode", inm_msg->sale_tellerCode);
    cJSON_AddNumberToObject(json_result, "sale_time", inm_msg->sale_time);
    cJSON_AddNumberToObject(json_result, "isPayed", inm_msg->isPayed);

    sprintf(tmp, "%010llu", inm_msg->pay_termCode);
    cJSON_AddStringToObject(json_result, "pay_termCode", tmp);
    cJSON_AddNumberToObject(json_result, "pay_tellerCode", inm_msg->pay_tellerCode);
    cJSON_AddNumberToObject(json_result, "pay_time", inm_msg->pay_time);

    sprintf(tmp, "%010llu", inm_msg->cancel_termCode);
    cJSON_AddStringToObject(json_result, "cancel_termCode", tmp);
    cJSON_AddNumberToObject(json_result, "cancel_tellerCode", inm_msg->cancel_tellerCode);
    cJSON_AddNumberToObject(json_result, "cancel_time", inm_msg->cancel_time);
    cJSON_AddStringToObject(json_result, "customName", inm_msg->customName);
    cJSON_AddNumberToObject(json_result, "cardType", inm_msg->cardType);
    cJSON_AddStringToObject(json_result, "cardCode", inm_msg->cardCode);
    cJSON_AddStringToObject(json_result, "betString", inm_msg->betString);

    return 0;
}

int S_OMS_ticket_inquiry_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns);
    int ret = 0;
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    if (msg_header->inm_header.type == INM_TYPE_O_INQUIRY_TICKET) {
        ret = s_oms_inquiryticket(inm_buf, json_result);
    }
    else if (msg_header->inm_header.type == INM_TYPE_O_FBS_INQUIRY_TICKET) {
        ret = s_oms_fbs_inquiryticket(inm_buf, json_result);
    }

    return ret;
}

//------------------------------------------------------------------------------
// ��Ʊ�ҽ�
//------------------------------------------------------------------------------
int r_oms_payticket(cJSON *json_params, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec)
{
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    INM_MSG_O_PAY_TICKET *inm_msg = (INM_MSG_O_PAY_TICKET *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_PAY_TICKET;
    int len = sizeof(INM_MSG_O_HEADER);

    //cJSON *json_rspfn_ticket = cJSON_Get(json_params, "rspfn_ticket", cJSON_String); parse_assert_return(json_rspfn_ticket);
    cJSON *json_reqfn_ticket_pay = cJSON_Get(json_params, "reqfn_ticket_pay", cJSON_String); parse_assert_return(json_reqfn_ticket_pay);
    cJSON *json_areaCode_pay = cJSON_Get(json_params, "areaCode_pay", cJSON_String); parse_assert_return(json_areaCode_pay);
    uint32 areaCode_pay = atoi(json_areaCode_pay->valuestring);

    strcpy(inm_msg->rspfn_ticket, tidx_rec->rspfn_ticket);
    strcpy(inm_msg->reqfn_ticket, tidx_rec->reqfn_ticket);
    inm_msg->unique_tsn = tidx_rec->unique_tsn;
    strcpy(inm_msg->reqfn_ticket_pay, json_reqfn_ticket_pay->valuestring);
    inm_msg->gameCode = tidx_rec->gameCode;
    inm_msg->saleStartIssue = tidx_rec->issueNumber;
    inm_msg->saleLastIssue = tidx_rec->drawIssueNumber;
    inm_msg->areaCode_pay = areaCode_pay;
    inm_msg->betStringLen = 0; //�������������жϴ�INM��Ϣ�Ƿ�Я��ԭʼͶע��Ϣ
    inm_msg->issueNumber_pay = 0; //caoxf__ ���ֶ���ʱ����

    uint8 game_code = tidx_rec->gameCode;
    //�����Ϸ����
    if (!isGameBeUsed(game_code)) {
        log_debug("OMS_RESULT_GAME_DISABLE_ERR: gameCode[%d] can't used.", game_code);
        msg_header->inm_header.status = OMS_RESULT_GAME_DISABLE_ERR;
        return len;
    }
    //�����Ϸ�Ƿ�ɶҽ�
    TRANSCTRL_PARAM *transctrlParam = gl_getTransctrlParam(game_code);
    if (!transctrlParam->payFlag) {
        log_debug("OMS_RESULT_PAY_DISABLE_ERR: game[%d] payFlag not be used.", game_code);
        msg_header->inm_header.status = OMS_RESULT_PAY_DISABLE_ERR; //����Ϸ���ɶҽ�
        return len;
    }
    //����Ƿ��ڷ���ʱ�εķ�Χ��
    if (false == gl_verifyServiceTime(game_code)) {
        log_debug("OMS_RESULT_GAME_SERVICETIME_OUT_ERR: game[%d] time out of service time.", game_code);
        msg_header->inm_header.status = OMS_RESULT_GAME_SERVICETIME_OUT_ERR; //��ǰ�����ڲ�Ʊ����ʱ��
        return len;
    }
    //check ���һ�ڵ��ڴ�״̬
    GIDB_ISSUE_HANDLE * i_handle = gidb_i_get_handle(game_code);
    if (i_handle == NULL) {
        log_error("OMS_RESULT_FAILURE: gidb_i_get_handle return NULL  gameCode[%d].", game_code);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    GIDB_ISSUE_INFO last_issue_info;
    int ret = i_handle->gidb_i_get_info(i_handle, inm_msg->saleLastIssue, &last_issue_info);
    if (ret != 0) {
        log_error("OMS_RESULT_FAILURE: gidb_i_get_info found error. tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    if (ISSUE_STATE_ISSUE_END != last_issue_info.status) {
        if (last_issue_info.status < ISSUE_STATE_CLOSED) {
            log_debug("issue[%lld] state[%d] < ISSUE_STATE_CLOSED. tsn[%s]",
                last_issue_info.issueNumber, last_issue_info.status, inm_msg->rspfn_ticket);
            msg_header->inm_header.status = OMS_RESULT_PAY_NOT_DRAW_ERR; //�ڻ�û�п���
            return len;
        }
        else {
            log_debug("issue[%lld] state[%d] >= ISSUE_STATE_CLOSED. tsn[%s]",
                last_issue_info.issueNumber, last_issue_info.status, inm_msg->rspfn_ticket);
            msg_header->inm_header.status = OMS_RESULT_PAY_WAIT_DRAW_ERR; //�ڴεȴ��������
            return len;
        }
    }
    //����ڴ����
    ISSUE_INFO* curr_issue_info = game_plugins_handle[game_code].get_currIssue(); //����Ϸ�����ȡ��Ϸ��ǰ�ڴ�
    if (curr_issue_info == NULL) {
        log_info("Get current issue failure. game[%d].", game_code);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    inm_msg->issueNumber_pay = curr_issue_info->issueNumber;
    //��ѯ�˲�Ʊ�Ƿ��н�
    GIDB_W_TICKET_HANDLE * w_handle = gidb_w_get_handle(game_code, inm_msg->saleLastIssue, GAME_DRAW_ONE);
    if (w_handle == NULL) {
        log_error("SYS_RESULT_FAILURE: gidb_w_get_handle return NULL  gameCode[%d] issueNumber[%lld].",
            game_code, inm_msg->saleLastIssue);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    char win_ticket_buf[INM_MSG_BUFFER_LENGTH] = { 0 };
    GIDB_WIN_TICKET_REC *pWinTicket = (GIDB_WIN_TICKET_REC *)win_ticket_buf;
    ret = w_handle->gidb_w_get_ticket(w_handle, inm_msg->unique_tsn, pWinTicket);
    if (ret < 0) {
        log_error("OMS_RESULT_FAILURE: gidb_w_get_ticket found error. rspfn_ticket[ %s ] unique_tsn[ %llu ]", inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    else if (ret == 1) {
        log_debug("SYS_RESULT_PAY_NOT_FOUND_ERR: gidb_w_get_ticket return NULL. rspfn_ticket[ %s ] unique_tsn[ %llu ]", inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        msg_header->inm_header.status = OMS_RESULT_PAY_NOT_WIN_ERR; //��Ʊδ�н�
        return len;
    }
    //���ҽ���
    if (sysdb_getSessionDate() > last_issue_info.payEndDay) {
        log_debug("issue[%lld] state[%d] > payEndDay. tsn[%s]",
            last_issue_info.issueNumber, last_issue_info.status, inm_msg->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_PAY_DAYEND_ERR;
        return len;
    }
    //����Ƿ�����ѵƱ
    inm_msg->isTrain = pWinTicket->isTrain;
    if (1 == inm_msg->isTrain) {
        log_debug("TSN[ %s ] is train ticket.", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_PAY_TRAINING_TICKET_ERR; //������OM����ѵƱ
        return len;
    }
    // �н�
    if (pWinTicket->paid_status == PRIZE_PAYMENT_NONE) {
        log_debug("OMS_RESULT_PAY_MULTI_ISSUE_ERR: gl_pay multi issue ticket. tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_PAY_MULTI_ISSUE_ERR; //����Ʊδ���   *************��̫�����ߵ����ǰ���Ѿ�У��������ڴ����ڽ�*********
        return len;
    }
    else if (pWinTicket->paid_status == PRIZE_PAYMENT_PAID) {
        log_debug("OMS_RESULT_PAY_PAID_ERR: gl_pay again. tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_PAY_PAID_ERR; //�Ѷҽ�
        return len;
    }
    //�ж���Ϸ�ҽ������޶�
    if (pWinTicket->winningAmountWithTax >= transctrlParam->gamePayLimited) {
        log_debug("OMS_RESULT_PAY_GAMELIMIT_ERR: gamePayLimited no pass. tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_PAY_MONEY_LIMIT_ERR; //������Ϸ�ҽ��������
        return len;
    }
    //��鲿�Ŷҽ��޶�
    /*
    if (pWinTicket->winningAmountWithTax > transctrlParam->branchCenterCancelLimited) {
        log_debug("OMS_RESULT_PAY_GAMELIMIT_ERR: branchCenterPayLimited no pass. tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_PAY_MONEY_LIMIT_ERR; //������Ϸ�ҽ��������
        return len;
    }
    */
    inm_msg->issueCount = pWinTicket->issueCount;
    inm_msg->saleStartIssueSerial = pWinTicket->saleStartIssueSerial;
    inm_msg->betStringLen = pWinTicket->bet_string_len;
    strncpy(inm_msg->betString, pWinTicket->bet_string, inm_msg->betStringLen);
    inm_msg->ticketAmount = pWinTicket->ticketAmount;
    inm_msg->saleTime = pWinTicket->timeStamp;

    inm_msg->isBigWinning = pWinTicket->isBigWinning;
    inm_msg->winningAmountWithTax = pWinTicket->winningAmountWithTax;
    inm_msg->taxAmount = pWinTicket->taxAmount;
    inm_msg->winningAmount = pWinTicket->winningAmount;
    inm_msg->winningCount = pWinTicket->winningCount;
    inm_msg->hd_winning = pWinTicket->hd_winning;
    inm_msg->hd_count = pWinTicket->hd_count;
    inm_msg->ld_winning = pWinTicket->ld_winning;
    inm_msg->ld_count = pWinTicket->ld_count;

    inm_msg->prizeCount = pWinTicket->prizeCount;
    inm_msg->saleAgencyCode = pWinTicket->agencyCode;
    memcpy(inm_msg->prizeDetail, pWinTicket->prizeDetail, pWinTicket->prizeDetail_length);

    int rc = otldb_spcall_oms_pay(inm_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("oms pay ticket failure.");
        inm_msg->header.inm_header.status = rc;
        return len;
    }

    //���ҽ��澯
    if ((transctrlParam->payLimit != 0) && (inm_msg->winningAmountWithTax >= transctrlParam->payLimit)) {
        notify_agency_pay_bigAmount(inm_msg->areaCode_pay, game_code, inm_msg->issueNumber_pay,
            inm_msg->winningAmountWithTax, inm_msg->availableCredit);
    }

    len = sizeof(INM_MSG_O_PAY_TICKET) + inm_msg->prizeCount * sizeof(PRIZE_DETAIL);
    return len;
}

int r_oms_fbs_payticket(cJSON *json_params, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec)
{
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    INM_MSG_O_FBS_PAY_TICKET *inm_msg = (INM_MSG_O_FBS_PAY_TICKET *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_FBS_PAY_TICKET;
    int len = sizeof(INM_MSG_O_HEADER);

    //cJSON *json_rspfn_ticket = cJSON_Get(json_params, "rspfn_ticket", cJSON_String); parse_assert_return(json_rspfn_ticket);
    cJSON *json_reqfn_ticket_pay = cJSON_Get(json_params, "reqfn_ticket_pay", cJSON_String); parse_assert_return(json_reqfn_ticket_pay);
    cJSON *json_areaCode_pay = cJSON_Get(json_params, "areaCode_pay", cJSON_String); parse_assert_return(json_areaCode_pay);
    uint32 areaCode_pay = atoi(json_areaCode_pay->valuestring);

    strcpy(inm_msg->rspfn_ticket, tidx_rec->rspfn_ticket);
    strcpy(inm_msg->reqfn_ticket, tidx_rec->reqfn_ticket);
    inm_msg->unique_tsn = tidx_rec->unique_tsn;
    strcpy(inm_msg->reqfn_ticket_pay, json_reqfn_ticket_pay->valuestring);
    inm_msg->gameCode = tidx_rec->gameCode;
    inm_msg->issueNumber = tidx_rec->issueNumber;
    //inm_msg->saleLastIssue =  tidx_rec->drawIssueNumber;
    inm_msg->areaCode_pay = areaCode_pay;
    inm_msg->betStringLen = 0; //�������������жϴ�INM��Ϣ�Ƿ�Я��ԭʼͶע��Ϣ
    inm_msg->issueNumber_pay = 0; //caoxf__ ���ֶ���ʱ����

    inm_msg->matchCount = tidx_rec->extend[0];
    memcpy((char*)inm_msg->matchCode, (char*)&tidx_rec->extend[1], tidx_rec->extend_len - 1);


    uint8 game_code = tidx_rec->gameCode;
    //�����Ϸ����
    if (!isGameBeUsed(game_code)) {
        log_debug("OMS_RESULT_GAME_DISABLE_ERR: gameCode[%d] can't used.", game_code);
        msg_header->inm_header.status = OMS_RESULT_GAME_DISABLE_ERR;
        return len;
    }
    //�����Ϸ�Ƿ�ɶҽ�
    TRANSCTRL_PARAM *transctrlParam = gl_getTransctrlParam(game_code);
    if (!transctrlParam->payFlag) {
        log_debug("OMS_RESULT_PAY_DISABLE_ERR: game[%d] payFlag not be used.", game_code);
        msg_header->inm_header.status = OMS_RESULT_PAY_DISABLE_ERR; //����Ϸ���ɶҽ�
        return len;
    }
    //����Ƿ��ڷ���ʱ�εķ�Χ��
    if (false == gl_verifyServiceTime(game_code)) {
        log_debug("OMS_RESULT_GAME_SERVICETIME_OUT_ERR: game[%d] time out of service time.", game_code);
        msg_header->inm_header.status = OMS_RESULT_GAME_SERVICETIME_OUT_ERR; //��ǰ�����ڲ�Ʊ����ʱ��
        return len;
    }

    //check �����ڴ��Ƿ񶼿��꽱,���һ��������
    GIDB_FBS_IM_HANDLE *im_handle = gidb_fbs_im_get_handle(game_code);
    GIDB_FBS_MATCH_INFO match_info = { 0 };
    int flagEnd = 1;
    uint32 drawTime = 0;
    time_t drawTimeTmp = 0;
    char strDrawTime[20] = { 0 };

    for (int i = 0; i < inm_msg->matchCount; i++)
    {
        int ret = im_handle->gidb_fbs_im_get_match(im_handle, inm_msg->matchCode[i], &match_info);
        if (ret < 0) {
            log_error("gidb_fbs_im_get_match fail.match[%u]", inm_msg->matchCode[i]);
            msg_header->inm_header.status = OMS_RESULT_FAILURE;
            return len;
        }

        if (match_info.state != M_STATE_CONFIRM) {
            flagEnd = 0;
            break;
        }
        if (drawTimeTmp < match_info.draw_time) {
            drawTimeTmp = match_info.draw_time;
        }
    }

    struct tm *p = gmtime(&drawTimeTmp);
    strftime(strDrawTime, 20, "%Y%m%d", p);
    drawTime = atoi(strDrawTime);

    //k-debug:test
    log_debug("draw_time:%d, %d", drawTimeTmp, drawTime);

    if (0 == flagEnd) {
        log_debug("issue[%lld] tsn[%s]", inm_msg->issueNumber, inm_msg->rspfn_ticket);
        if (inm_msg->matchCount == 1) {
            msg_header->inm_header.status = OMS_RESULT_PAY_NOT_DRAW_ERR;
            return len;
        }
        else {
            msg_header->inm_header.status = OMS_RESULT_PAY_MULTI_ISSUE_ERR;//�ೡ������û�п��꽱
            return len;
        }
    }

    inm_msg->issueNumber_pay = 0;
    //��ѯ�˲�Ʊ�Ƿ��н�
    GIDB_FBS_WT_HANDLE * w_handle = gidb_fbs_wt_get_handle(game_code, inm_msg->issueNumber);
    if (w_handle == NULL) {
        log_error("SYS_RESULT_FAILURE: gidb_fbs_wt_get_handle return NULL  gameCode[%d] issueNumber[%lld].",
            game_code, inm_msg->issueNumber);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    char win_ticket_buf[INM_MSG_BUFFER_LENGTH] = { 0 };
    GIDB_FBS_WT_REC *pWinTicket = (GIDB_FBS_WT_REC *)win_ticket_buf;
    int ret = w_handle->gidb_fbs_wt_get_ticket(w_handle, inm_msg->unique_tsn, pWinTicket);
    if (ret < 0) {
        log_error("OMS_RESULT_FAILURE: gidb_fbs_wt_get_ticket found error. rspfn_ticket[ %s ] unique_tsn[ %llu ]",
            inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    else if (ret == 1) {
        log_debug("SYS_RESULT_PAY_NOT_FOUND_ERR: gidb_fbs_wt_get_ticket return NULL. rspfn_ticket[ %s ] unique_tsn[ %llu ]",
            inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        msg_header->inm_header.status = OMS_RESULT_PAY_NOT_WIN_ERR; //��Ʊδ�н�
        return len;
    }

    //���ҽ���
    FBS_GT_GAME_PARAM game_param;
    int gpLen = 0;
    memset(&game_param, 0, sizeof(FBS_GT_GAME_PARAM));
    GIDB_FBS_ST_HANDLE *t_handle = gidb_fbs_st_get_handle(game_code, inm_msg->issueNumber);
    if (t_handle == NULL) {
        log_error("gidb_fbs_st_get_handle(%d, %u) failure", game_code, inm_msg->issueNumber);
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    ret = t_handle->gidb_fbs_st_get_field_blob(t_handle, FBS_ST_GAME_PARAMBLOB_KEY, (char*)&game_param, &gpLen);
    if (ret != 0) {
        log_error("gidb_fbs_st_get_field_blob(%d, %u, FBS_ST_GAME_PARAMBLOB_KEY) failure.", game_code, inm_msg->issueNumber);
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }

    uint32 payEndDay = 0;
    //payEndDay ADD days
    int d = c_days(drawTime);
    d += game_param.payEndDay;
    payEndDay = c_date(d);
    if (sysdb_getSessionDate() > payEndDay) {
        log_debug("expired, issue[%u] payEndDay[%u]. tsn[%s],drawTime[%u],d[%d]",
            inm_msg->issueNumber, payEndDay, inm_msg->rspfn_ticket, drawTime, d);
        msg_header->inm_header.status = OMS_RESULT_PAY_DAYEND_ERR;
        return len;
    }

    //����Ƿ�����ѵƱ
    inm_msg->isTrain = pWinTicket->is_train;
    if (1 == inm_msg->isTrain) {
        log_debug("TSN[ %s ] is train ticket.", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_PAY_TRAINING_TICKET_ERR; //������OM����ѵƱ
        return len;
    }
    // �н�
    if (pWinTicket->paid_status == PRIZE_PAYMENT_NONE) {
        log_debug("OMS_RESULT_PAY_MULTI_ISSUE_ERR: gl_pay multi issue ticket. tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_PAY_MULTI_ISSUE_ERR; //����Ʊδ���   *************��̫�����ߵ����ǰ���Ѿ�У��������ڴ����ڽ�*********
        return len;
    }
    else if (pWinTicket->paid_status == PRIZE_PAYMENT_PAID) {
        log_debug("OMS_RESULT_PAY_PAID_ERR: gl_pay again. tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_PAY_PAID_ERR; //�Ѷҽ�
        return len;
    }
    //�ж���Ϸ�ҽ������޶�
    if (pWinTicket->winningAmountWithTax >= transctrlParam->gamePayLimited) {
        log_debug("OMS_RESULT_PAY_GAMELIMIT_ERR: gamePayLimited no pass. tsn[ %s ],[%ld][%ld]",
            inm_msg->rspfn_ticket, pWinTicket->winningAmountWithTax, transctrlParam->gamePayLimited);
        msg_header->inm_header.status = OMS_RESULT_PAY_MONEY_LIMIT_ERR; //������Ϸ�ҽ��������
        return len;
    }
    //��鲿�Ŷҽ��޶�
    /*
    if (pWinTicket->winningAmountWithTax > transctrlParam->branchCenterCancelLimited) {
        log_debug("OMS_RESULT_PAY_GAMELIMIT_ERR: branchCenterPayLimited no pass. tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_PAY_MONEY_LIMIT_ERR; //������Ϸ�ҽ��������
        return len;
    }
    */
    //inm_msg-> = pWinTicket->issueCount;
    //inm_msg-> = pWinTicket->saleStartIssueSerial;
    inm_msg->betStringLen = pWinTicket->bet_string_len;
    strncpy(inm_msg->betString, pWinTicket->bet_string, inm_msg->betStringLen);
    inm_msg->ticketAmount = pWinTicket->total_amount;
    inm_msg->saleTime = pWinTicket->time_stamp;

    inm_msg->isBigWinning = pWinTicket->isBigWinning;
    inm_msg->winningAmountWithTax = pWinTicket->winningAmountWithTax;
    inm_msg->taxAmount = pWinTicket->taxAmount;
    inm_msg->winningAmount = pWinTicket->winningAmount;
    inm_msg->winningCount = pWinTicket->winningCount;
    inm_msg->saleAgencyCode = pWinTicket->agency_code;
    //    inm_msg->hd_winning = pWinTicket->hd_winning;
    //    inm_msg->hd_count = pWinTicket->hd_count;
    //    inm_msg->ld_winning = pWinTicket->ld_winning;
    //    inm_msg->ld_count = pWinTicket->ld_count;

        //inm_msg->orderCount = pWinTicket->prizeCount;
        //memcpy(inm_msg->orderArray,pWinTicket->prizeDetail,pWinTicket->prizeDetail_length);

    int rc = otldb_spcall_oms_fbs_pay(inm_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("oms pay fbs ticket failure.");
        inm_msg->header.inm_header.status = rc;
        return len;
    }

    //���ҽ��澯
//    if ((transctrlParam->payLimit!=0) && (inm_msg->winningAmountWithTax >= transctrlParam->payLimit)) {
//        notify_agency_pay_bigAmount(inm_msg->areaCode_pay, game_code, inm_msg->issueNumber_pay,
//            inm_msg->winningAmountWithTax, inm_msg->availableCredit);
//    }

    len = sizeof(INM_MSG_O_FBS_PAY_TICKET) + inm_msg->orderCount * sizeof(GL_FBS_WIN_ORDER_INFO);
    return len;
}

int R_OMS_ticket_pay_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_COMMOM_ERR;
    int len = sizeof(INM_MSG_O_HEADER);

    cJSON *json_rspfn_ticket = cJSON_Get(json_params, "rspfn_ticket", cJSON_String); parse_assert_return(json_rspfn_ticket);
    cJSON *json_reqfn_ticket_pay = cJSON_Get(json_params, "reqfn_ticket_pay", cJSON_String); parse_assert_return(json_reqfn_ticket_pay);
    cJSON *json_areaCode_pay = cJSON_Get(json_params, "areaCode_pay", cJSON_String); parse_assert_return(json_areaCode_pay);
    uint32 areaCode_pay = atoi(json_areaCode_pay->valuestring);

    //parse rspfn (tsn)
    uint32 date = 0;
    uint64 unique_tsn = extract_tsn(json_rspfn_ticket->valuestring, &date);
    if (unique_tsn == 0) {
        log_error("extract_tsn failed. [ %s ]", json_rspfn_ticket->valuestring);
        msg_header->inm_header.status = OMS_RESULT_TICKET_TSN_ERR; //TSN����
        return len;
    }
    //�������ļ��в�ѯƱ��Ϣ
    char tidx_buf[512] = { 0 };
    GIDB_TICKET_IDX_REC *tidx_rec = (GIDB_TICKET_IDX_REC*)tidx_buf;
    memset(tidx_rec, 0, sizeof(tidx_buf));
    int ret = get_ticket_idx(date, unique_tsn, tidx_rec);
    if (ret < 0) {
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    else if (ret == 1) {
        msg_header->inm_header.status = OMS_RESULT_TICKET_NOT_FOUND_ERR;
        return len;
    }
    //��֤У����
    if (0 != strcmp(json_rspfn_ticket->valuestring, tidx_rec->rspfn_ticket)) {
        log_error("tsn verify fail!!!, [ %s  ---  %s ]", json_rspfn_ticket->valuestring, tidx_rec->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_TICKET_TSN_ERR; //TSN����
        return len;
    }

    if ((tidx_rec->gameCode != GAME_FBS) && (tidx_rec->gameCode != GAME_FODD)) {
        //��ͨ��Ϸ
        return r_oms_payticket(json_params, inm_buf, tidx_rec);
    }
    // FBS ��Ϸ
    return r_oms_fbs_payticket(json_params, inm_buf, tidx_rec);
}

int s_oms_payticket(char *inm_buf, cJSON *json_result)
{
    INM_MSG_O_PAY_TICKET *inm_msg = (INM_MSG_O_PAY_TICKET *)inm_buf;

    cJSON_AddStringToObject(json_result, "rspfn_ticket", inm_msg->rspfn_ticket);
    cJSON_AddStringToObject(json_result, "reqfn_ticket", inm_msg->reqfn_ticket);
    cJSON_AddNumberToObject(json_result, "unique_tsn", inm_msg->unique_tsn);
    cJSON_AddStringToObject(json_result, "rspfn_ticket_pay", inm_msg->rspfn_ticket_pay);
    cJSON_AddStringToObject(json_result, "reqfn_ticket_pay", inm_msg->reqfn_ticket_pay);
    cJSON_AddNumberToObject(json_result, "unique_tsn_pay", inm_msg->unique_tsn_pay);
    char tmp[20] = { 0 };
    sprintf(tmp, "%02u", inm_msg->areaCode_pay);
    cJSON_AddStringToObject(json_result, "areaCode_pay", tmp);

    cJSON_AddNumberToObject(json_result, "gameCode", inm_msg->gameCode);
    cJSON_AddNumberToObject(json_result, "issueCount", inm_msg->issueCount);
    cJSON_AddNumberToObject(json_result, "startIssueNumber", inm_msg->saleStartIssue);
    cJSON_AddNumberToObject(json_result, "endIssueNumber", inm_msg->saleLastIssue);
    cJSON_AddNumberToObject(json_result, "saleTime", inm_msg->saleTime);
    cJSON_AddNumberToObject(json_result, "winningAmountWithTax", inm_msg->winningAmountWithTax);
    cJSON_AddNumberToObject(json_result, "taxAmount", inm_msg->taxAmount);
    cJSON_AddNumberToObject(json_result, "winningAmount", inm_msg->winningAmount);
    cJSON_AddNumberToObject(json_result, "transTimeStamp", inm_msg->header.inm_header.when);
    cJSON_AddStringToObject(json_result, "betString", inm_msg->betString);
    cJSON_AddNumberToObject(json_result, "prizeCount", inm_msg->prizeCount);
    cJSON *json_winPrizeArray = cJSON_CreateArray();
    PRIZE_DETAIL *ptr = NULL;
    cJSON* item = NULL;
    for (int i = 0;i < inm_msg->prizeCount;i++) {
        ptr = &inm_msg->prizeDetail[i];
        item = cJSON_CreateObject();
        cJSON_AddStringToObject(item, "name", ptr->name);
        cJSON_AddNumberToObject(item, "prizeCode", ptr->prizeCode);
        cJSON_AddNumberToObject(item, "count", ptr->count);
        cJSON_AddNumberToObject(item, "amountSingle", ptr->amountSingle);
        cJSON_AddNumberToObject(item, "amountBeforeTax", ptr->amountBeforeTax);
        cJSON_AddNumberToObject(item, "amountTax", ptr->amountTax);
        cJSON_AddNumberToObject(item, "amountAfterTax", ptr->amountAfterTax);
        cJSON_AddItemToArray(json_winPrizeArray, item);
    }
    cJSON_AddItemToObject(json_result, "prizeDetail", json_winPrizeArray);
    return 0;
}

int s_oms_fbs_payticket(char *inm_buf, cJSON *json_result)
{
    INM_MSG_O_FBS_PAY_TICKET *inm_msg = (INM_MSG_O_FBS_PAY_TICKET *)inm_buf;

    cJSON_AddStringToObject(json_result, "rspfn_ticket", inm_msg->rspfn_ticket);
    cJSON_AddStringToObject(json_result, "reqfn_ticket", inm_msg->reqfn_ticket);
    cJSON_AddNumberToObject(json_result, "unique_tsn", inm_msg->unique_tsn);
    cJSON_AddStringToObject(json_result, "rspfn_ticket_pay", inm_msg->rspfn_ticket_pay);
    cJSON_AddStringToObject(json_result, "reqfn_ticket_pay", inm_msg->reqfn_ticket_pay);
    cJSON_AddNumberToObject(json_result, "unique_tsn_pay", inm_msg->unique_tsn_pay);
    char tmp[20] = { 0 };
    sprintf(tmp, "%02u", inm_msg->areaCode_pay);
    cJSON_AddStringToObject(json_result, "areaCode_pay", tmp);

    cJSON_AddNumberToObject(json_result, "gameCode", inm_msg->gameCode);
    cJSON_AddNumberToObject(json_result, "issueCount", 1);
    cJSON_AddNumberToObject(json_result, "startIssueNumber", inm_msg->issueNumber);
    cJSON_AddNumberToObject(json_result, "endIssueNumber", inm_msg->issueNumber);
    cJSON_AddNumberToObject(json_result, "saleTime", inm_msg->saleTime);
    cJSON_AddNumberToObject(json_result, "winningAmountWithTax", inm_msg->winningAmountWithTax);
    cJSON_AddNumberToObject(json_result, "taxAmount", inm_msg->taxAmount);
    cJSON_AddNumberToObject(json_result, "winningAmount", inm_msg->winningAmount);
    cJSON_AddNumberToObject(json_result, "transTimeStamp", inm_msg->header.inm_header.when);
    cJSON_AddStringToObject(json_result, "betString", inm_msg->betString);

    //Ϊ�˸�ʽ
    cJSON_AddNumberToObject(json_result, "prizeCount", 1);
    cJSON *json_winPrizeArray = cJSON_CreateArray();
    cJSON* item = NULL;
    for (int i = 0;i < 1;i++) {

        item = cJSON_CreateObject();
        cJSON_AddStringToObject(item, "name", " ");
        cJSON_AddNumberToObject(item, "prizeCode", 0);
        cJSON_AddNumberToObject(item, "count", inm_msg->winningCount);
        cJSON_AddNumberToObject(item, "amountSingle", 0);
        cJSON_AddNumberToObject(item, "amountBeforeTax", inm_msg->winningAmountWithTax);
        cJSON_AddNumberToObject(item, "amountTax", inm_msg->taxAmount);
        cJSON_AddNumberToObject(item, "amountAfterTax", inm_msg->winningAmount);
        cJSON_AddItemToArray(json_winPrizeArray, item);
    }
    cJSON_AddItemToObject(json_result, "prizeDetail", json_winPrizeArray);

    return 0;
}

int S_OMS_ticket_pay_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns);
    int ret = 0;
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    if (msg_header->inm_header.type == INM_TYPE_O_PAY_TICKET) {
        ret = s_oms_payticket(inm_buf, json_result);
    }
    else if (msg_header->inm_header.type == INM_TYPE_O_FBS_PAY_TICKET) {
        ret = s_oms_fbs_payticket(inm_buf, json_result);
    }

    return ret;
}

//------------------------------------------------------------------------------
// ��Ʊ��Ʊ
//------------------------------------------------------------------------------
int r_oms_cancelticket(cJSON *json_params, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec)
{
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    INM_MSG_O_CANCEL_TICKET *inm_msg = (INM_MSG_O_CANCEL_TICKET *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_CANCEL_TICKET;
    int len = sizeof(INM_MSG_O_HEADER);

    cJSON *json_rspfn_ticket = cJSON_Get(json_params, "rspfn_ticket", cJSON_String); parse_assert_return(json_rspfn_ticket);
    cJSON *json_reqfn_ticket_cancel = cJSON_Get(json_params, "reqfn_ticket_cancel", cJSON_String); parse_assert_return(json_reqfn_ticket_cancel);
    cJSON *json_areaCode_cancel = cJSON_Get(json_params, "areaCode_cancel", cJSON_String); parse_assert_return(json_areaCode_cancel);
    uint32 areaCode_cancel = atoi(json_areaCode_cancel->valuestring);

    strcpy(inm_msg->rspfn_ticket, tidx_rec->rspfn_ticket);
    strcpy(inm_msg->reqfn_ticket, tidx_rec->reqfn_ticket);
    inm_msg->unique_tsn = tidx_rec->unique_tsn;
    strcpy(inm_msg->reqfn_ticket_cancel, json_reqfn_ticket_cancel->valuestring);
    inm_msg->gameCode = tidx_rec->gameCode;
    inm_msg->saleStartIssue = tidx_rec->issueNumber;
    inm_msg->areaCode_cancel = areaCode_cancel;

    log_info("process_O_cancel_ticket tsn[ %s ]", inm_msg->rspfn_ticket);

    uint8 game_code = tidx_rec->gameCode;
    //�����Ϸ����
    if (!isGameBeUsed(game_code)) {
        log_debug("OMS_RESULT_GAME_DISABLE_ERR: gameCode[%d] can't used.", game_code);
        msg_header->inm_header.status = OMS_RESULT_GAME_DISABLE_ERR;
        return len;
    }
    TRANSCTRL_PARAM *transctrlParam = gl_getTransctrlParam(game_code);
    if (!transctrlParam->cancelFlag) {
        log_debug("OMS_RESULT_CANCEL_DISABLE_ERR: game[%d] cancelFlag not be used.", game_code);
        msg_header->inm_header.status = OMS_RESULT_CANCEL_DISABLE_ERR; //����Ϸ������Ʊ
        return len;
    }
    //����Ƿ��ڷ���ʱ�εķ�Χ��
    if (false == gl_verifyServiceTime(game_code)) {
        log_debug("OMS_RESULT_GAME_SERVICETIME_OUT_ERR: game[%d] time out of service time.", game_code);
        msg_header->inm_header.status = OMS_RESULT_GAME_SERVICETIME_OUT_ERR; //��ǰ�����ڲ�Ʊ����ʱ��
        return len;
    }
    //�ԱȲ�Ʊ��ǰ�ڴκ������ڴ�
    ISSUE_INFO* issue_info = game_plugins_handle[game_code].get_currIssue(); //����Ϸ�����ȡ��Ϸ��ǰ�ڴ�
    if (issue_info == NULL) {
        log_info("Get current issue failure. tsn[%s] game[%d]", inm_msg->rspfn_ticket, game_code);
        msg_header->inm_header.status = OMS_RESULT_CANCEL_ISSUE_ERR; //û�е�ǰ�ڣ���������Ʊ
        return len;
    }
    if (inm_msg->saleStartIssue != issue_info->issueNumber) {
        log_info("Current issue doesn't equal ticket sale issue. tsn[%s] game[%d] issueNumber[%lld]",
            inm_msg->rspfn_ticket, game_code, issue_info->issueNumber);
        msg_header->inm_header.status = OMS_RESULT_CANCEL_ISSUE_ERR; //��ǰ�ڲ��������ڣ���������Ʊ
        return len;
    }
    if (issue_info->curState > ISSUE_STATE_CLOSING) {
        log_info("OMS_RESULT_CANCEL_ISSUE_ERR: current issue has already closed. tsn[%s] game[%d] issueNumber[%lld]",
            inm_msg->rspfn_ticket, game_code, issue_info->issueNumber);
        msg_header->inm_header.status = OMS_RESULT_CANCEL_ISSUE_ERR; //��ǰ�ڴ��ѹر�
        return len;
    }
    inm_msg->saleStartIssueSerial = issue_info->serialNumber;
    //��ѯ����Ʊ
    GIDB_T_TICKET_HANDLE * t_handle = gidb_t_get_handle(game_code, inm_msg->saleStartIssue);
    if (t_handle == NULL)
    {
        log_warn("OMS_RESULT_FAILURE: gidb_t_get_handle return NULL. gameCode[%d] issueNumber[%lld].",
            game_code, inm_msg->saleStartIssue);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    char sale_ticket_buf[INM_MSG_BUFFER_LENGTH] = { 0 };
    GIDB_SALE_TICKET_REC *pSaleTicket = (GIDB_SALE_TICKET_REC *)sale_ticket_buf;
    int ret = t_handle->gidb_t_get_ticket(t_handle, inm_msg->unique_tsn, pSaleTicket);
    if (ret < 0) {
        log_debug("OMS_RESULT_FAILURE: gidb_get_sell_ticket found error. rspfn_ticket[ %s ] unique_tsn[ %llu ]",
            inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    else if (ret == 1) {
        log_debug("OMS_RESULT_TICKET_NOT_FOUND_ERR: gidb_get_sell_ticket return NULL. tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_TICKET_NOT_FOUND_ERR; //û���ҵ����Ų�Ʊ
        return len;
    }
    strcpy(inm_msg->reqfn_ticket, pSaleTicket->reqfn_ticket);
    strcpy(inm_msg->rspfn_ticket, pSaleTicket->rspfn_ticket);
    memcpy((char *)&inm_msg->ticket, (char *)&pSaleTicket->ticket, pSaleTicket->ticket.length);
    inm_msg->cancelAmount = pSaleTicket->ticket.amount;
    inm_msg->saleTime = pSaleTicket->timeStamp;
    inm_msg->commissionAmount = pSaleTicket->commissionAmount;
    inm_msg->saleAgencyCode = pSaleTicket->agencyCode;
    //�ж��Ƿ�����Ʊ
    if (pSaleTicket->isCancel) {
        log_debug("TSN[ %s ] has cancel.", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_CANCEL_AGAIN_ERR; //����Ʊ
        return len;
    }
    //����Ƿ�����ѵƱ
    if (1 == pSaleTicket->isTrain) {
        log_debug("OMS_RESULT_T_CANCEL_TRAINING_TICKET_ERR: tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_CANCEL_TRAINING_TICKET_ERR; //������OM����ѵƱ
        return len;
    }
    //��鲿����Ʊ�޶�
    /*
    if (inm_msg->cancelAmount > transctrlParam->branchCenterCancelLimited) {
        log_debug("OMS_RESULT_CANCEL_MONEY_LIMIT_ERR: cancelAmount[%lld] branchCenterCancelLimited[%lld] no pass. tsn[ %s ]",
            inm_msg->cancelAmount, transctrlParam->branchCenterCancelLimited,inm_msg->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_CANCEL_MONEY_LIMIT_ERR; //������Ʊ�������
        return len;
    }
    */
    //��ƱȨ�޵��жϣ�ĿǰOMS(�������ŵ�OMS) Ĭ�Ͽ���������Ʊ
    //pSaleTicket->areaCode  <--->   inm_msg->areaCode_cancel

    int rc = otldb_spcall_oms_cancel(inm_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("oms cancel ticket failure.");
        inm_msg->header.inm_header.status = rc;
        return len;
    }

    //���·��տ���
    if ((isGameBeRiskControl(game_code)) && (NULL != game_plugins_handle[game_code].cancel_rk_rollback)) {
        pthread_mutex_lock(&risk_mutex[game_code]);
        game_plugins_handle[game_code].cancel_rk_rollback(&inm_msg->ticket);
        pthread_mutex_unlock(&risk_mutex[game_code]);
    }

    //��Ʊ���澯
    if ((transctrlParam->cancelLimit != 0) && (pSaleTicket->ticket.amount >= transctrlParam->cancelLimit)) {
        notify_agency_cancel_bigAmount(inm_msg->areaCode_cancel, game_code,
            tidx_rec->issueNumber, pSaleTicket->ticket.amount, inm_msg->availableCredit);
    }

    len = offsetof(INM_MSG_O_CANCEL_TICKET, ticket) + inm_msg->ticket.length;
    return len;
}

int r_oms_fbs_cancelticket(cJSON *json_params, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec)
{
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    INM_MSG_O_FBS_CANCEL_TICKET *inm_msg = (INM_MSG_O_FBS_CANCEL_TICKET *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_FBS_CANCEL_TICKET;
    int len = sizeof(INM_MSG_O_HEADER);

    cJSON *json_rspfn_ticket = cJSON_Get(json_params, "rspfn_ticket", cJSON_String); parse_assert_return(json_rspfn_ticket);
    cJSON *json_reqfn_ticket_cancel = cJSON_Get(json_params, "reqfn_ticket_cancel", cJSON_String); parse_assert_return(json_reqfn_ticket_cancel);
    cJSON *json_areaCode_cancel = cJSON_Get(json_params, "areaCode_cancel", cJSON_String); parse_assert_return(json_areaCode_cancel);
    uint32 areaCode_cancel = atoi(json_areaCode_cancel->valuestring);

    strcpy(inm_msg->rspfn_ticket, tidx_rec->rspfn_ticket);
    strcpy(inm_msg->reqfn_ticket, tidx_rec->reqfn_ticket);
    inm_msg->unique_tsn = tidx_rec->unique_tsn;
    strcpy(inm_msg->reqfn_ticket_cancel, json_reqfn_ticket_cancel->valuestring);
    inm_msg->gameCode = tidx_rec->gameCode;
    inm_msg->issueNumber = tidx_rec->issueNumber;
    inm_msg->ticket.issue_number = tidx_rec->issueNumber;
    inm_msg->areaCode_cancel = areaCode_cancel;

    inm_msg->matchCount = tidx_rec->extend[0];
    memcpy((char*)inm_msg->matchCode, (char*)&tidx_rec->extend[1], tidx_rec->extend_len - 1);

    log_info("process_O_fbs_cancel_ticket tsn[ %s ]", inm_msg->rspfn_ticket);

    uint8 game_code = tidx_rec->gameCode;
    //�����Ϸ����
    if (!isGameBeUsed(game_code)) {
        log_debug("OMS_RESULT_GAME_DISABLE_ERR: gameCode[%d] can't used.", game_code);
        msg_header->inm_header.status = OMS_RESULT_GAME_DISABLE_ERR;
        return len;
    }
    TRANSCTRL_PARAM *transctrlParam = gl_getTransctrlParam(game_code);
    if (!transctrlParam->cancelFlag) {
        log_debug("OMS_RESULT_CANCEL_DISABLE_ERR: game[%d] cancelFlag not be used.", game_code);
        msg_header->inm_header.status = OMS_RESULT_CANCEL_DISABLE_ERR; //����Ϸ������Ʊ
        return len;
    }
    //����Ƿ��ڷ���ʱ�εķ�Χ��
    if (false == gl_verifyServiceTime(game_code)) {
        log_debug("OMS_RESULT_GAME_SERVICETIME_OUT_ERR: game[%d] time out of service time.", game_code);
        msg_header->inm_header.status = OMS_RESULT_GAME_SERVICETIME_OUT_ERR; //��ǰ�����ڲ�Ʊ����ʱ��
        return len;
    }

    //��鳡��  �Ƿ��б����ѽ���
    uint32 *matchCode = inm_msg->matchCode;
    for (int i = 0; i < inm_msg->matchCount; i++) {
        FBS_MATCH *match = game_plugins_handle[game_code].fbs_get_match(inm_msg->ticket.issue_number, *matchCode);
        if (match == NULL) {
            log_error("check match is NULL, match_code[%d]", *matchCode);
            msg_header->inm_header.status = SYS_RESULT_FAILURE;
            return len;
        }
        else if (match->state != M_STATE_OPEN) {
            msg_header->inm_header.status = OMS_RESUTL_CANCEL_NOT_ACCEPT; //�������йر�
            return len;
        }
        matchCode++;
    }

    //��ѯ����Ʊ
    GIDB_FBS_ST_HANDLE *t_handle = gidb_fbs_st_get_handle(game_code, inm_msg->issueNumber);
    if (t_handle == NULL)
    {
        log_warn("OMS_RESULT_FAILURE: gidb_fbs_st_get_handle return NULL. gameCode[%d] issueNumber[%lld].",
            game_code, inm_msg->issueNumber);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    char sale_ticket_buf[INM_MSG_BUFFER_LENGTH] = { 0 };
    GIDB_FBS_ST_REC *pSaleTicket = (GIDB_FBS_ST_REC *)sale_ticket_buf;
    int ret = t_handle->gidb_fbs_st_get_ticket(t_handle, inm_msg->unique_tsn, pSaleTicket);
    if (ret < 0) {
        log_debug("OMS_RESULT_FAILURE: gidb_fbs_st_get_ticket found error. rspfn_ticket[ %s ] unique_tsn[ %llu ]",
            inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    else if (ret == 1) {
        log_debug("OMS_RESULT_TICKET_NOT_FOUND_ERR: gidb_fbs_st_get_ticket return NULL. tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_TICKET_NOT_FOUND_ERR; //û���ҵ����Ų�Ʊ
        return len;
    }
    strcpy(inm_msg->reqfn_ticket, pSaleTicket->reqfn_ticket);
    strcpy(inm_msg->rspfn_ticket, pSaleTicket->rspfn_ticket);
    memcpy((char *)&inm_msg->ticket, (char *)&pSaleTicket->ticket, pSaleTicket->ticket.length);
    inm_msg->cancelAmount = pSaleTicket->ticket.bet_amount;
    inm_msg->saleTime = pSaleTicket->time_stamp;
    inm_msg->commissionAmount = pSaleTicket->commissionAmount;
    inm_msg->saleAgencyCode = pSaleTicket->agency_code;
    //�ж��Ƿ�����Ʊ
    if (pSaleTicket->isCancel) {
        log_debug("TSN[ %s ] has cancel.", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_CANCEL_AGAIN_ERR; //����Ʊ
        return len;
    }
    //����Ƿ�����ѵƱ
    if (1 == pSaleTicket->is_train) {
        log_debug("OMS_RESULT_T_CANCEL_TRAINING_TICKET_ERR: tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_CANCEL_TRAINING_TICKET_ERR; //������OM����ѵƱ
        return len;
    }
    //��鲿����Ʊ�޶�
    /*
    if (inm_msg->cancelAmount > transctrlParam->branchCenterCancelLimited) {
        log_debug("OMS_RESULT_CANCEL_MONEY_LIMIT_ERR: cancelAmount[%lld] branchCenterCancelLimited[%lld] no pass. tsn[ %s ]",
            inm_msg->cancelAmount, transctrlParam->branchCenterCancelLimited,inm_msg->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_CANCEL_MONEY_LIMIT_ERR; //������Ʊ�������
        return len;
    }
    */
    //��ƱȨ�޵��жϣ�ĿǰOMS(�������ŵ�OMS) Ĭ�Ͽ���������Ʊ
    //pSaleTicket->areaCode  <--->   inm_msg->areaCode_cancel

    int rc = otldb_spcall_oms_fbs_cancel(inm_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("oms fbs cancel ticket failure.");
        inm_msg->header.inm_header.status = rc;
        return len;
    }

    //���·��տ���
//    if ((isGameBeRiskControl(game_code)) && (NULL!=game_plugins_handle[game_code].cancel_rk_rollback)) {
//        pthread_mutex_lock(&risk_mutex[game_code]);
//        game_plugins_handle[game_code].cancel_rk_rollback(&inm_msg->ticket);
//        pthread_mutex_unlock(&risk_mutex[game_code]);
//    }
//
//    //��Ʊ���澯
//    if ((transctrlParam->cancelLimit != 0) && (pSaleTicket->ticket.amount >= transctrlParam->cancelLimit)) {
//        notify_agency_cancel_bigAmount(inm_msg->areaCode_cancel, game_code,
//                tidx_rec->issueNumber, pSaleTicket->ticket.amount, inm_msg->availableCredit);
//    }

    len = offsetof(INM_MSG_O_FBS_CANCEL_TICKET, ticket) + inm_msg->ticket.length;
    return len;
}

int R_OMS_ticket_cancel_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_COMMOM_ERR;
    int len = sizeof(INM_MSG_O_HEADER);

    cJSON *json_rspfn_ticket = cJSON_Get(json_params, "rspfn_ticket", cJSON_String); parse_assert_return(json_rspfn_ticket);
    cJSON *json_reqfn_ticket_cancel = cJSON_Get(json_params, "reqfn_ticket_cancel", cJSON_String); parse_assert_return(json_reqfn_ticket_cancel);
    cJSON *json_areaCode_cancel = cJSON_Get(json_params, "areaCode_cancel", cJSON_String); parse_assert_return(json_areaCode_cancel);
    uint32 areaCode_cancel = atoi(json_areaCode_cancel->valuestring);

    //parse rspfn (tsn)
    uint32 date = 0;
    uint64 unique_tsn = extract_tsn(json_rspfn_ticket->valuestring, &date);
    if (unique_tsn == 0) {
        log_error("extract_tsn failed. [ %s ]", json_rspfn_ticket->valuestring);
        msg_header->inm_header.status = OMS_RESULT_TICKET_TSN_ERR; //TSN����
        return len;
    }
    //�������ļ��в�ѯƱ��Ϣ
    char tidx_buf[512] = { 0 };
    GIDB_TICKET_IDX_REC *tidx_rec = (GIDB_TICKET_IDX_REC*)tidx_buf;
    int ret = get_ticket_idx(date, unique_tsn, tidx_rec);
    if (ret < 0) {
        msg_header->inm_header.status = OMS_RESULT_FAILURE;
        return len;
    }
    else if (ret == 1) {
        msg_header->inm_header.status = OMS_RESULT_TICKET_NOT_FOUND_ERR;
        return len;
    }
    //��֤У����
    if (0 != strcmp(json_rspfn_ticket->valuestring, tidx_rec->rspfn_ticket)) {
        log_error("tsn verify fail!!!, [ %s  ---  %s ]", json_rspfn_ticket->valuestring, tidx_rec->rspfn_ticket);
        msg_header->inm_header.status = OMS_RESULT_TICKET_TSN_ERR; //TSN����
        return len;
    }

    if ((tidx_rec->gameCode != GAME_FBS) && (tidx_rec->gameCode != GAME_FODD)) {
        //��ͨ��Ϸ
        return r_oms_cancelticket(json_params, inm_buf, tidx_rec);
    }
    // FBS ��Ϸ
    return r_oms_fbs_cancelticket(json_params, inm_buf, tidx_rec);
}

int s_oms_cancelticket(char *inm_buf, cJSON *json_result)
{
    INM_MSG_O_CANCEL_TICKET *inm_msg = (INM_MSG_O_CANCEL_TICKET *)inm_buf;

    cJSON_AddStringToObject(json_result, "rspfn_ticket", inm_msg->rspfn_ticket);
    cJSON_AddStringToObject(json_result, "reqfn_ticket", inm_msg->reqfn_ticket);
    cJSON_AddNumberToObject(json_result, "unique_tsn", inm_msg->unique_tsn);
    cJSON_AddStringToObject(json_result, "rspfn_ticket_cancel", inm_msg->rspfn_ticket_cancel);
    cJSON_AddStringToObject(json_result, "reqfn_ticket_cancel", inm_msg->reqfn_ticket_cancel);
    cJSON_AddNumberToObject(json_result, "unique_tsn_cancel", inm_msg->unique_tsn_cancel);

    char tmp[20] = { 0 };
    sprintf(tmp, "%02u", inm_msg->areaCode_cancel);
    cJSON_AddStringToObject(json_result, "areaCode_cancel", tmp);

    cJSON_AddNumberToObject(json_result, "gameCode", inm_msg->gameCode);
    cJSON_AddNumberToObject(json_result, "startIssueNumber", inm_msg->saleStartIssue);
    cJSON_AddNumberToObject(json_result, "saleTime", inm_msg->saleTime);

    sprintf(tmp, "%08llu", inm_msg->saleAgencyCode);
    cJSON_AddStringToObject(json_result, "saleAgencyCode", tmp);
    cJSON_AddNumberToObject(json_result, "cancelAmount", inm_msg->cancelAmount);
    cJSON_AddNumberToObject(json_result, "transTimeStamp", inm_msg->header.inm_header.when);
    cJSON_AddNumberToObject(json_result, "commissionAmount", inm_msg->commissionAmount);
    return 0;
}

int s_oms_fbs_cancelticket(char *inm_buf, cJSON *json_result)
{
    INM_MSG_O_FBS_CANCEL_TICKET *inm_msg = (INM_MSG_O_FBS_CANCEL_TICKET *)inm_buf;

    cJSON_AddStringToObject(json_result, "rspfn_ticket", inm_msg->rspfn_ticket);
    cJSON_AddStringToObject(json_result, "reqfn_ticket", inm_msg->reqfn_ticket);
    cJSON_AddNumberToObject(json_result, "unique_tsn", inm_msg->unique_tsn);
    cJSON_AddStringToObject(json_result, "rspfn_ticket_cancel", inm_msg->rspfn_ticket_cancel);
    cJSON_AddStringToObject(json_result, "reqfn_ticket_cancel", inm_msg->reqfn_ticket_cancel);
    cJSON_AddNumberToObject(json_result, "unique_tsn_cancel", inm_msg->unique_tsn_cancel);

    char tmp[20] = { 0 };
    sprintf(tmp, "%02u", inm_msg->areaCode_cancel);
    cJSON_AddStringToObject(json_result, "areaCode_cancel", tmp);

    cJSON_AddNumberToObject(json_result, "gameCode", inm_msg->gameCode);
    cJSON_AddNumberToObject(json_result, "startIssueNumber", inm_msg->issueNumber);
    cJSON_AddNumberToObject(json_result, "saleTime", inm_msg->saleTime);

    sprintf(tmp, "%08llu", inm_msg->saleAgencyCode);
    cJSON_AddStringToObject(json_result, "saleAgencyCode", tmp);
    cJSON_AddNumberToObject(json_result, "cancelAmount", inm_msg->cancelAmount);
    cJSON_AddNumberToObject(json_result, "transTimeStamp", inm_msg->header.inm_header.when);
    cJSON_AddNumberToObject(json_result, "commissionAmount", inm_msg->commissionAmount);

    return 0;
}

int S_OMS_ticket_cancel_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns);
    int ret = 0;
    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    if (msg_header->inm_header.type == INM_TYPE_O_CANCEL_TICKET) {
        ret = s_oms_cancelticket(inm_buf, json_result);
    }
    else if (msg_header->inm_header.type == INM_TYPE_O_FBS_CANCEL_TICKET) {
        ret = s_oms_fbs_cancelticket(inm_buf, json_result);
    }

    return ret;
}

//------------------------------------------------------------------------------
// FBS ��������֪ͨ��Ϣ
//------------------------------------------------------------------------------
int R_OMS_fbs_add_match_nfy_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);;

    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    INM_MSG_O_FBS_ADD_MATCH_NFY *inm_msg = (INM_MSG_O_FBS_ADD_MATCH_NFY *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_FBS_ADD_MATCH_NTY;
    int len = sizeof(INM_MSG_O_FBS_ADD_MATCH_NFY);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return(json_gameCode);

    inm_msg->gameCode = json_gameCode->valueint;

    //gl_driver����otl�ӿ�

    return len;
}
int S_OMS_fbs_add_match_nfy_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}


//------------------------------------------------------------------------------
// FBS ɾ������
//------------------------------------------------------------------------------
int R_OMS_fbs_del_match_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
#if 0
    ts_notused_args;
    GLTP_MSG_O_FBS_DELETE_MATCH_REQ *g_msg = (GLTP_MSG_O_FBS_DELETE_MATCH_REQ *)gltp_buf;
    INM_MSG_O_FBS_DEL_MATCH *inm_msg = (INM_MSG_O_FBS_DEL_MATCH *)inm_buf;
    inm_msg->header.inm_header.type = INM_TYPE_O_FBS_DEL_MATCH;

    inm_msg->gameCode = g_msg->gameCode;
    inm_msg->issueNumber = g_msg->issueNumber;
    inm_msg->matchCode = g_msg->matchCode;
    return sizeof(INM_MSG_O_FBS_DEL_MATCH);
#endif
    return 0;
}
int S_OMS_fbs_del_match_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}


//------------------------------------------------------------------------------
// FBS ����/ͣ�ñ���
//------------------------------------------------------------------------------
int R_OMS_fbs_match_state_ctrl_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);;

    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    INM_MSG_O_FBS_MATCH_STATUS_CTRL *inm_msg = (INM_MSG_O_FBS_MATCH_STATUS_CTRL *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_FBS_MATCH_STATUS_CTRL;
    int len = sizeof(INM_MSG_O_FBS_MATCH_STATUS_CTRL);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return(json_gameCode);
    cJSON *json_issueNumber = cJSON_Get(json_params, "issueNumber", cJSON_Number); parse_assert_return(json_issueNumber);
    cJSON *json_matchCode = cJSON_Get(json_params, "matchCode", cJSON_Number); parse_assert_return(json_matchCode);
    cJSON *json_status = cJSON_Get(json_params, "status", cJSON_Number); parse_assert_return(json_status);

    inm_msg->gameCode = json_gameCode->valueint;
    inm_msg->issueNumber = json_issueNumber->valueint;
    inm_msg->matchCode = json_matchCode->valueint;
    inm_msg->status = json_status->valueint;

    return len;
}
int S_OMS_fbs_match_state_ctrl_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}


//------------------------------------------------------------------------------
// FBS �޸ı����ر�ʱ��
//------------------------------------------------------------------------------
int R_OMS_fbs_match_time_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);;

    INM_MSG_O_HEADER *msg_header = (INM_MSG_O_HEADER *)inm_buf;
    INM_MSG_O_FBS_MATCH_TIME *inm_msg = (INM_MSG_O_FBS_MATCH_TIME *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_O_FBS_MATCH_TIME;
    int len = sizeof(INM_MSG_O_FBS_MATCH_TIME);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return(json_gameCode);
    cJSON *json_issueNumber = cJSON_Get(json_params, "issueNumber", cJSON_Number); parse_assert_return(json_issueNumber);
    cJSON *json_matchCode = cJSON_Get(json_params, "matchCode", cJSON_Number); parse_assert_return(json_matchCode);
    cJSON *json_time = cJSON_Get(json_params, "time", cJSON_Number); parse_assert_return(json_time);

    inm_msg->gameCode = json_gameCode->valueint;
    inm_msg->issueNumber = json_issueNumber->valueint;
    inm_msg->matchCode = json_matchCode->valueint;
    inm_msg->time = json_time->valueint;

    return len;
}
int S_OMS_fbs_match_time_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}


//------------------------------------------------------------------------------
// FBS �������� �C> ¼�뿪������
//------------------------------------------------------------------------------
int R_OMS_fbs_draw_input_result_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_HEADER *msg_header = (INM_MSG_HEADER *)inm_buf;
    msg_header->type = INM_TYPE_O_FBS_DRAW_INPUT_RESULT;
    int len = sizeof(INM_MSG_HEADER);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return2(json_gameCode);
    cJSON *json_issueNumber = cJSON_Get(json_params, "issueNumber", cJSON_Number); parse_assert_return2(json_issueNumber);
    cJSON *json_matchCode = cJSON_Get(json_params, "matchCode", cJSON_Number); parse_assert_return2(json_matchCode);
    cJSON *json_drawResults = cJSON_Get(json_params, "drawResults", cJSON_String); parse_assert_return2(json_drawResults);
    cJSON *json_matchResult = cJSON_Get(json_params, "matchResult", cJSON_String); parse_assert_return2(json_matchResult);
    //cJSON *json_timeStamp = cJSON_Get(json_params, "timeStamp", cJSON_Number); parse_assert_return2(json_timeStamp);

    INM_MSG_O_FBS_DRAW_INPUT_RESULT *inm_msg = (INM_MSG_O_FBS_DRAW_INPUT_RESULT *)inm_buf;
    inm_msg->gameCode = json_gameCode->valueint;
    inm_msg->issueNumber = json_issueNumber->valueint;
    inm_msg->matchCode = json_matchCode->valueint;


    int i = 0;
    char str[500] = { 0 };
    char str1[500] = { 0 };
    strcpy(str1, json_drawResults->valuestring);
    memcpy(str, str1 + 1, strlen(str1) - 2);

    log_debug("drawResults[%s]", str);

    // ��Ͷע��������ð��','�ָ��ĸ����ֽ�����
    char *p = NULL;
    char *last = NULL;
    p = strtok_r(str, ",", &last);
    for (i = 1; ; i++) {
        if (p == NULL) {
            break;
        }

        //log_debug("drawresult[%d]:[%s]", i, strtrim(p+2));
        //strcpy((char*)(inm_msg->drawResults+i), atoi(strtrim(p+2)));//����'x:'
        inm_msg->drawResults[i] = atoi(strtrim(p + 2));//����'x:'
        p = strtok_r(NULL, ",", &last);
    }
    if (i != FBS_SUBTYPE_NUM) {
        log_error("drawResults  number error[%d]", i);
        msg_header->status = OMS_RESULT_FAILURE;
        return len;
    }

    i = 0;
    memset(str, 0, sizeof(str));
    memset(str1, 0, sizeof(str1));
    strcpy(str1, json_matchResult->valuestring);
    memcpy(str, str1 + 1, strlen(str1) - 2);

    log_debug("matchResult[%s]", str);

    p = strtok_r(str, ",", &last);
    for (i = 0; ; i++) {
        if (p == NULL) {
            break;
        }

        //log_debug("matchResult[%d]:[%s]", i, strtrim(p+2));
        //strcpy((char*)(inm_msg->matchResult+i), strtrim(p+2));//����'x:'
        inm_msg->matchResult[i] = atoi(strtrim(p + 2));//����'x:'
        p = strtok_r(NULL, ",", &last);
    }
    if (i != 8) {
        log_error("matchResult  number error[%d]", i);
        msg_header->status = OMS_RESULT_FAILURE;
        return len;
    }

    //k-debug:
    log_debug("drawResults:[%d,%d,%d,%d,%d,%d],matchResult:[%d,%d,%d,%d,%d,%d,%d,%d]",
        inm_msg->drawResults[1], inm_msg->drawResults[2], inm_msg->drawResults[3],
        inm_msg->drawResults[4], inm_msg->drawResults[5], inm_msg->drawResults[6],
        inm_msg->matchResult[0], inm_msg->matchResult[1], inm_msg->matchResult[2],
        inm_msg->matchResult[3], inm_msg->matchResult[4], inm_msg->matchResult[5],
        inm_msg->matchResult[6], inm_msg->matchResult[7]);

    msg_header->length = sizeof(INM_MSG_O_FBS_DRAW_INPUT_RESULT);
    //д�뿪����־��
    GIDB_FBS_DL_HANDLE *drawlog_handle = gidb_fbs_dl_get_handle(inm_msg->gameCode);
    if (drawlog_handle == NULL)
    {
        log_error("gidb_fbs_dl_get_handle(%d) error", inm_msg->gameCode);
        msg_header->status = OMS_RESULT_FAILURE;
        return len;
    }

    int ret = drawlog_handle->gidb_fbs_dl_append(drawlog_handle, inm_msg->issueNumber, inm_msg->matchCode, INM_TYPE_O_FBS_DRAW_INPUT_RESULT, inm_buf, msg_header->length);
    if (ret < 0)
    {
        log_error("gidb_fbs_dl_append(%d) match[%u] type[%d] error", inm_msg->gameCode, inm_msg->matchCode, INM_TYPE_O_FBS_DRAW_INPUT_RESULT);
        msg_header->status = OMS_RESULT_FAILURE;
        return len;
    }
    return sizeof(INM_MSG_O_FBS_DRAW_INPUT_RESULT);







#if 0
    ts_notused_args;
    int ret = 0;
    GLTP_MSG_O_FBS_DRAW_INPUT_RESULT_REQ *g_msg = (GLTP_MSG_O_FBS_DRAW_INPUT_RESULT_REQ *)gltp_buf;
    INM_MSG_O_FBS_DRAW_INPUT_RESULT *inm_msg = (INM_MSG_O_FBS_DRAW_INPUT_RESULT *)inm_buf;
    inm_msg->header.inm_header.type = INM_TYPE_O_FBS_DRAW_INPUT_RESULT;

    inm_msg->gameCode = g_msg->gameCode;
    inm_msg->issueNumber = g_msg->issueNumber;
    inm_msg->matchCode = g_msg->matchCode;
    memcpy(inm_msg->drawResults, g_msg->drawResults, FBS_SUBTYPE_NUM);
    memcpy(inm_msg->matchResult, g_msg->matchResult, 8);
    inm_msg->header.inm_header.length = sizeof(INM_MSG_O_FBS_DRAW_INPUT_RESULT);

    //�򿪽���־��д��һ����¼��֪ͨgl_draw_fbs���񣬴˳��ο��Խ��п���
    GIDB_FBS_DL_HANDLE *fbs_dl_handle = gidb_fbs_dl_get_handle(inm_msg->gameCode);
    if (fbs_dl_handle == NULL)
    {
        sysdb_close();
        log_error("gidb_fbs_dl_get_handle(%d) error", inm_msg->gameCode);
        return -1;
    }
    ret = fbs_dl_handle->gidb_fbs_dl_append(fbs_dl_handle, inm_msg->issueNumber, inm_msg->matchCode, INM_TYPE_O_FBS_DRAW_INPUT_RESULT, inm_buf, inm_msg->header.inm_header.length);
    if (ret < 0)
    {
        log_error("gidb_fbs_dl_append(%u) type[%d] error", inm_msg->matchCode, INM_TYPE_O_FBS_DRAW_INPUT_RESULT);
        return -1;
    }
    return sizeof(INM_MSG_O_FBS_DRAW_INPUT_RESULT);
#endif
    return 0;
}
int S_OMS_fbs_draw_input_result_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;

}


//------------------------------------------------------------------------------
// FBS �������� �C> �������ȷ��
//------------------------------------------------------------------------------
int R_OMS_fbs_draw_confirm_process(NCPC_SERVER *ns, cJSON *json_params, char *inm_buf)
{
    ts_notused(ns);
    INM_MSG_HEADER *msg_header = (INM_MSG_HEADER *)inm_buf;
    msg_header->type = INM_TYPE_O_FBS_DRAW_CONFIRM;
    int len = sizeof(INM_MSG_HEADER);

    cJSON *json_gameCode = cJSON_Get(json_params, "gameCode", cJSON_Number); parse_assert_return2(json_gameCode);
    cJSON *json_issueNumber = cJSON_Get(json_params, "issueNumber", cJSON_Number); parse_assert_return2(json_issueNumber);
    cJSON *json_matchCode = cJSON_Get(json_params, "matchCode", cJSON_Number); parse_assert_return2(json_matchCode);

    INM_MSG_O_FBS_DRAW_CONFIRM *inm_msg = (INM_MSG_O_FBS_DRAW_CONFIRM *)inm_buf;
    inm_msg->gameCode = json_gameCode->valueint;
    inm_msg->issueNumber = json_issueNumber->valueint;
    inm_msg->matchCode = json_matchCode->valueint;
    //inm_msg->timeStamp = json_timeStamp->valueint;

    msg_header->length = sizeof(INM_MSG_O_FBS_DRAW_CONFIRM);
    //д�뿪����־��
    GIDB_FBS_DL_HANDLE *drawlog_handle = gidb_fbs_dl_get_handle(inm_msg->gameCode);
    if (drawlog_handle == NULL)
    {
        log_error("gidb_fbs_dl_get_handle(%d) error", inm_msg->gameCode);
        msg_header->status = OMS_RESULT_FAILURE;
        return len;
    }

    int ret = drawlog_handle->gidb_fbs_dl_append(drawlog_handle, inm_msg->issueNumber, inm_msg->matchCode, INM_TYPE_O_FBS_DRAW_CONFIRM, inm_buf, msg_header->length);
    if (ret < 0)
    {
        log_error("gidb_fbs_dl_append(%d) match[%u] type[%d] error", inm_msg->gameCode, inm_msg->matchCode, INM_TYPE_O_FBS_DRAW_CONFIRM);
        msg_header->status = OMS_RESULT_FAILURE;
        return len;
    }

    return sizeof(INM_MSG_O_FBS_DRAW_CONFIRM);

#if 0
    ts_notused_args;
    int ret = 0;
    GLTP_MSG_O_FBS_DRAW_CONFIRM_REQ *g_msg = (GLTP_MSG_O_FBS_DRAW_CONFIRM_REQ *)gltp_buf;
    INM_MSG_O_FBS_DRAW_CONFIRM *inm_msg = (INM_MSG_O_FBS_DRAW_CONFIRM *)inm_buf;
    inm_msg->header.inm_header.type = INM_TYPE_O_FBS_DRAW_CONFIRM;

    inm_msg->gameCode = g_msg->gameCode;
    inm_msg->issueNumber = g_msg->issueNumber;
    inm_msg->matchCode = g_msg->matchCode;
    inm_msg->header.inm_header.length = sizeof(INM_MSG_O_FBS_DRAW_CONFIRM);

    //�򿪽���־��д��һ����¼��֪ͨgl_draw_fbs���񣬴˳��ο��Խ��п���
    GIDB_FBS_DL_HANDLE *fbs_dl_handle = gidb_fbs_dl_get_handle(inm_msg->gameCode);
    if (fbs_dl_handle == NULL)
    {
        sysdb_close();
        log_error("gidb_fbs_dl_get_handle(%d) error", inm_msg->gameCode);
        return -1;
    }
    ret = fbs_dl_handle->gidb_fbs_dl_append(fbs_dl_handle, inm_msg->issueNumber, inm_msg->matchCode, INM_TYPE_O_FBS_DRAW_CONFIRM, inm_buf, inm_msg->header.inm_header.length);
    if (ret < 0)
    {
        log_error("gidb_fbs_dl_append(%u) type[%d] error", inm_msg->matchCode, INM_TYPE_O_FBS_DRAW_CONFIRM);
        return -1;
    }
    return sizeof(INM_MSG_O_FBS_DRAW_CONFIRM);
#endif
    return 0;

}
int S_OMS_fbs_confirm_process(NCPC_SERVER *ns, char *inm_buf, cJSON *json_result)
{
#if 0
    ts_notused_args;
    INM_MSG_O_FBS_DRAW_CONFIRM *inm_msg = (INM_MSG_O_FBS_DRAW_CONFIRM *)inm_buf;
    GLTP_MSG_O_COMMON_RSP *g_msg = (GLTP_MSG_O_COMMON_RSP *)gltp_buf;
    g_msg->header.func = GLTP_O_FBS_DRAW_CONFIRM_RSP;

    g_msg->status = inm_msg->header.inm_header.status;
    return sizeof(GLTP_MSG_O_COMMON_RSP);
#endif

    ts_notused(ns); ts_notused(inm_buf); ts_notused(json_result);
    return 0;
}

