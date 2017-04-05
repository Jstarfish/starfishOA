#include "global.h"
#include "ncpc_inf.h"
#include "tms_inf.h"
#include "gl_inf.h"
#include "ncpc_http_parse.h"
#include "ncpc_http_kvdb.h"
#include "ncpc_net.h"
#include "ncpc_message.h"

#define CLOSE_ALL_HANDLE_TIME (60*15)
static time_t last_update = 0;

extern GAME_PLUGIN_INTERFACE *game_plugins_handle;
static pthread_mutex_t term_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t risk_mutex[MAX_GAME_NUMBER] = { PTHREAD_MUTEX_INITIALIZER  };





//--------------------------------------------------------------------------------------------------
//
// TERM  fun
//
//--------------------------------------------------------------------------------------------------
int term_sellticket(char *gltp_buf, char *inm_buf, TMS_TERMINAL_RECORD* pTerm);
int term_fbs_sellticket(char *gltp_buf, char *inm_buf, TMS_TERMINAL_RECORD* pTerm);

int term_inquiryticket(char *gltp_buf, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec);
int term_fbs_inquiryticket(char *gltp_buf, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec);

int term_inquiryWin(char *gltp_buf, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec);
int term_fbs_inquiryWin(char *gltp_buf, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec);

int term_payticket(char *gltp_buf, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec, TMS_TERMINAL_RECORD* pTerm);
int term_fbs_payticket(char *gltp_buf, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec, TMS_TERMINAL_RECORD* pTerm);

int term_cancelticket(char *gltp_buf, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec, TMS_TERMINAL_RECORD* pTerm);
int term_fbs_cancelticket(char *gltp_buf, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec, TMS_TERMINAL_RECORD* pTerm);







static int terminal_msn(TMS_TERMINAL_RECORD *pTerm, uint16 func, uint32 msn, uint16 crc)
{
    if (GLTP_T_SIGNIN_REQ==func) {
        if (msn != 1) {
            //��¼��Ϣ��MSN�������1
            return -1;
        }
        pTerm->msn = 1;
        *(uint16*)pTerm->last_response = 0;
        pTerm->last_crc = 0;
        return 0;
    }
    if (pTerm->msn == msn) {
        *(uint16*)pTerm->last_response = 0;
        pTerm->last_crc = 0;
        return 0;
    }
    if ((pTerm->msn-1) == msn) {
        //check cretry
        if( (GLTP_T_SELL_TICKET_REQ == func) ||
            (GLTP_T_PAY_TICKET_REQ == func) ||
            (GLTP_T_CANCEL_TICKET_REQ == func) )
        {
            pTerm->retryCount++;
            GLTP_MSG_T_HEADER *g_retry_header = (GLTP_MSG_T_HEADER *)pTerm->last_response;
           // if ((func!=(g_retry_header->func-1)) || (g_retry_header->length == 0) || (crc!=pTerm->last_crc)) {
            if ((func != (g_retry_header->func - 1)) || (g_retry_header->length == 0) ) {
                //retry failure
                *(uint16*)pTerm->last_response = 0;
                pTerm->last_crc = 0;
                log_warn("retry message failed. cid[%d] header->func[%d] retry->func[%d] length[%u] crc[%u] termcrc[%u]",
                        pTerm->index, func, g_retry_header->func-1, g_retry_header->length, crc, pTerm->last_crc);
                return -1;
            }
            //��Ӧretry����
            return 1;
        }
        //������Ϣ���������Ĵ���
        *(uint16*)pTerm->last_response = 0;
        pTerm->last_crc = 0;
        return 2;
    }
    //����������е��ˣ�˵��msn�д���
    log_error("msn error: pTerm:[%d] g_header[%d]", pTerm->msn, msn);
    return -1;
}

void send_inm_auth_message(NCPC_SERVER *ns, INM_MSG_T_AUTH *inm_auth_msg, uint16 status)
{
    inm_auth_msg->header.inm_header.type = INM_TYPE_T_AUTH;
    inm_auth_msg->header.inm_header.status = status;
    inm_auth_msg->header.msn = 0;
    inm_auth_msg->header.reqParam = 0;
    inm_auth_msg->header.inm_header.length = sizeof(INM_MSG_T_AUTH);
    ns->send_msg_to_bq(q_ncpc_send, (char *)inm_auth_msg, inm_auth_msg->header.inm_header.length);
    return;
}

void keep_last_response(GLTP_MSG_T_HEADER *g_header, uint32 cid)
{
    uint32 max_len = 256;
    if ((GLTP_T_SELL_TICKET_RSP == g_header->func) ||
        (GLTP_T_PAY_TICKET_RSP == g_header->func) ||
        (GLTP_T_CANCEL_TICKET_RSP == g_header->func))
    {
        TMS_TERMINAL_RECORD *pTerm = tms_mgr()->getTermByIndex(cid);
        if (NULL == pTerm)
        {
            log_error("keep_last_response() failure. term is NULL. idx[%d]", cid);
            return;
        }
        if ((sizeof(GLTP_MSG_T_SELL_TICKET_RSP) > max_len) ||
            (sizeof(GLTP_MSG_T_PAY_TICKET_RSP) > max_len) ||
            (sizeof(GLTP_MSG_T_CANCEL_TICKET_RSP) > max_len))
        {
            pTerm->last_crc = 0;
            *(uint16*)pTerm->last_response = 0;
            log_warn("keep_last_response() failure. message too long. > 256. idx[%d]", cid);
            return;
        }
        memcpy(pTerm->last_response, (char*)g_header, g_header->length);
    }
    return;
}

int ncpc_process_Recv_terminal_message(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf)
{
    int ret = 0;
    GLTP_MSG_T_HEADER *g_header = (GLTP_MSG_T_HEADER *)gltp_buf;
    INM_MSG_T_HEADER *inm_header = (INM_MSG_T_HEADER *)inm_buf;

    if (g_header->length < (GLTP_MSG_T_HEADER_LEN + CRC_SIZE))
        return -1;

    int32 term_cid = 0;
    uint8 type = g_header->type;
    uint16 func = g_header->func;
    time_type when = get_now();
    uint64 token = g_header->token;
    inm_header->inm_header.when = when;
    inm_header->inm_header.status = SYS_RESULT_SUCCESS;
    inm_header->inm_header.gltp_type = type;
    inm_header->inm_header.gltp_func = func;
    inm_header->inm_header.gltp_from = TICKET_FROM_TERM;
    inm_header->ncpIdentify = g_header->identify;

    if (GLTP_T_AUTH_REQ == func) {
        //��֤����
        R_TERM_auth_process(ns, gltp_buf, inm_buf);
        return 0;
    }

    //check token available
    TMS_TERMINAL_RECORD *pTerm = tms_mgr()->verify_token(token);
    if (pTerm == NULL) {
        log_debug("token invalid. token[%llu]", token);

        //send token expired
        inm_header->inm_header.type = INM_TYPE_T_MESSAGE_ERR;
        inm_header->inm_header.status = SYS_RESULT_T_TOKEN_EXPIRED_ERR;
        inm_header->cid = 0;
        inm_header->token = token;
        inm_header->msn = g_header->msn;
        inm_header->reqParam = g_header->param;
        inm_header->inm_header.length = INM_MSG_T_HEADER_LEN;
        ns->send_msg_to_bq(q_ncpc_send, inm_buf, inm_header->inm_header.length);
        return 0;
    }
    term_cid = pTerm->index;

    //check busy -------------------------
    pthread_mutex_lock(&term_mutex);
    if (pTerm->isBusy) {
        pthread_mutex_unlock(&term_mutex);
        //����notify��Ϣ:�ն˻�BUSY����
        GLTP_MSG_NTF_TMS_TERM_BUSY_ERR notify;
        notify.termCode = pTerm->termCode;
        memcpy(notify.szTermMac, pTerm->szMac, 6);
        sys_notify(GLTP_NTF_TMS_TERM_BUSY_ERR, _ERROR, (char *)&notify, sizeof(notify));

        log_warn("cid[%d] busy", term_cid);
        return 0;
    }
    pTerm->isBusy = true; //����busy���
    pthread_mutex_unlock(&term_mutex);

    //check msn ---------------------------
    if ((GLTP_T_ECHO_REQ != func) &&
        (GLTP_T_SIGNOUT_REQ != func))
    {
        uint16 crc = *(uint16*)((char*)g_header + g_header->length - 2);
        ret = terminal_msn(pTerm, func, g_header->msn, crc);
        if (ret < 0) {
            //msn error
            inm_header->inm_header.type = INM_TYPE_T_MESSAGE_ERR;
            inm_header->inm_header.status = SYS_RESULT_T_MSN_ERR;
            inm_header->cid = pTerm->index;
            inm_header->token = token;
            inm_header->msn = g_header->msn;
            inm_header->reqParam = g_header->param;
            inm_header->inm_header.length = INM_MSG_T_HEADER_LEN;
            ns->send_msg_to_bq(q_ncpc_send, inm_buf, inm_header->inm_header.length);

            tms_mgr()->resetTerm(pTerm->index);

            //����notify��Ϣ:�ն˻�msn����
            log_debug("NOTIFY sent: GLTP_MSG_NTF_TMS_TERM_MSN_ERR");
            GLTP_MSG_NTF_TMS_TERM_MSN_ERR notify;
            notify.termCode = pTerm->termCode;
            memcpy(notify.szTermMac, pTerm->szMac, 6);
            notify.recvMsn = g_header->msn;
            notify.msn = pTerm->msn;
            sys_notify(GLTP_NTF_TMS_TERM_MSN_ERR, _WARN, (char *)&notify, sizeof(notify));
            return 0;
        }
        else if (ret == 1) {
            //����retry����
            INM_MSG_T_RETRY *retry_msg = (INM_MSG_T_RETRY *)inm_buf;
            retry_msg->header.inm_header.type = INM_TYPE_T_RETRY;
            retry_msg->header.inm_header.status = SYS_RESULT_SUCCESS;
            retry_msg->header.token = token;
            retry_msg->header.cid = pTerm->index;
            retry_msg->gltp_msg_len = *(uint16*)pTerm->last_response;
            memcpy(retry_msg->gltp_msg, pTerm->last_response, retry_msg->gltp_msg_len);
            retry_msg->header.inm_header.length = sizeof(INM_MSG_T_RETRY) + retry_msg->gltp_msg_len;
            ns->send_msg_to_bq(q_ncpc_send, inm_buf, retry_msg->header.inm_header.length);

            pTerm->token_last_update = when;
            return 0;
        }
        else if (ret == 0) {
            pTerm->msn += 1;
        }
    }
    //update token keepalive time
    pTerm->token_last_update = when;

    inm_header->cid = term_cid;
    inm_header->token = g_header->token;
    inm_header->msn = g_header->msn;
    inm_header->reqParam = g_header->param;
    inm_header->areaCode = pTerm->areaCode;
    inm_header->agencyCode = pTerm->agencyCode;
    inm_header->terminalCode = pTerm->termCode;
    inm_header->tellerCode = pTerm->tellerCode;

    NCPC_MSG_DISPATCH_CELL *msg_cell = ncpc_get_dispatch(type, func);
    if (msg_cell == NULL) {
        log_error("ncpc_get_dispatch() failed. unknow message type[%d] func[%d]", g_header->type, g_header->func);
        return -1;
    }

    int msg_len = msg_cell->R_process(ns, gltp_buf, inm_buf);
    if (msg_len <= 0) {
        log_warn("R_process() failed. type[%d] func[%d]", type, func);
        return -1;
    }
    inm_header->inm_header.length = msg_len;

    log_debug("R_process result -> status[%d] cid[%d]", inm_header->inm_header.status, inm_header->cid);

    //����ʧ��ֱ�ӷ���
    if (inm_header->inm_header.status != SYS_RESULT_SUCCESS) {
        ns->send_msg_to_bq(q_ncpc_send, inm_buf, inm_header->inm_header.length);
        return 0;
    }

    ns->send_msg_to_bq(msg_cell->which_queue, inm_buf, inm_header->inm_header.length);

    time_t nowt = time(NULL);
    if ((nowt - last_update) > CLOSE_ALL_HANDLE_TIME)
    {
        gidb_t_clean_handle_timeout();
        gidb_w_clean_handle_timeout();

        gidb_fbs_st_clean_handle();
        gidb_fbs_wt_clean_handle();
        last_update = nowt;
    }
    return 0;
}

int ncpc_process_Send_terminal_message(NCPC_SERVER *ns, ncpc_client *c, char *inm_buf)
{
    INM_MSG_T_HEADER *inm_header = (INM_MSG_T_HEADER *)inm_buf;
    char gltp_buf[MAX_BUFFER] = {0};
    GLTP_MSG_T_HEADER *g_header = (GLTP_MSG_T_HEADER *)gltp_buf;

    g_header->type = inm_header->inm_header.gltp_type;
    g_header->func = inm_header->inm_header.gltp_func + 1;
    g_header->when = get_now();
    g_header->msn = inm_header->msn;
    g_header->token = inm_header->token;
    g_header->identify = inm_header->ncpIdentify;
    g_header->param = inm_header->reqParam;
    g_header->status = inm_header->inm_header.status;

    if (SYS_RESULT_T_TOKEN_EXPIRED_ERR == inm_header->inm_header.status) {
        //����ͨ�õĴ�����Ϣ
        GLTP_MSG_T_ERR_RSP* g_err_msg = (GLTP_MSG_T_ERR_RSP*)g_header;
        g_err_msg->timeStamp = inm_header->inm_header.when;
        g_err_msg->crc = 0;
        g_err_msg->header.length = sizeof(GLTP_MSG_T_ERR_RSP);
        //send to net
        c->send_message(gltp_buf, g_header->length);
        return 0;
    }

    TMS_TERMINAL_RECORD *pTerm = tms_mgr()->getTermByIndex(inm_header->cid);
    if (NULL == pTerm) {
        log_error("term is NULL. idx[%d]", inm_header->cid);
        return -1;
    }

    if (GLTP_T_AUTH_RSP == g_header->func) {
        S_TERM_auth_process(ns, inm_buf, gltp_buf);
        c->send_message(gltp_buf, g_header->length);
        return 0;
    }

    //retry��Ϣ��ֱ�ӷ���
    if (inm_header->inm_header.type == INM_TYPE_T_RETRY) {
        pthread_mutex_lock(&term_mutex);
        pTerm->isBusy = false; //����busy���
        pthread_mutex_unlock(&term_mutex);

        INM_MSG_T_RETRY *inm_retry_msg = (INM_MSG_T_RETRY *)inm_header;
        memcpy(gltp_buf, inm_retry_msg->gltp_msg, inm_retry_msg->gltp_msg_len);
        g_header->when = get_now();
        g_header->identify = inm_retry_msg->header.ncpIdentify;

        //send to net
        c->send_message(gltp_buf, g_header->length);
        return 0;
    }

    //������
    if (SYS_RESULT_SUCCESS != inm_header->inm_header.status) {
        //����ͨ�õĴ�����Ϣ
        pthread_mutex_lock(&term_mutex);
        pTerm->isBusy = false; //����busy���
        pthread_mutex_unlock(&term_mutex);

        GLTP_MSG_T_ERR_RSP* g_err_msg = (GLTP_MSG_T_ERR_RSP*)g_header;
        g_err_msg->timeStamp = inm_header->inm_header.when;
        g_err_msg->crc = 0;
        g_err_msg->header.length = sizeof(GLTP_MSG_T_ERR_RSP);

        //�����ط���Ϣ
        keep_last_response(g_header, pTerm->index);

        //send to net
        c->send_message(gltp_buf, g_header->length);
        return 0;
    }

    NCPC_MSG_DISPATCH_CELL *msg_cell = ncpc_get_dispatch(inm_header->inm_header.gltp_type, inm_header->inm_header.gltp_func);
    if (msg_cell == NULL) {
        log_error("ncpc_get_dispatch() failed. unknow message type[%d] func[%d]",
            inm_header->inm_header.gltp_type, inm_header->inm_header.gltp_func);
        return -1;
    }

    int msg_len = msg_cell->S_process(ns, inm_buf, gltp_buf);
    if (msg_len <= 0) {
        log_warn("S_process() failed. type[%d] func[%d]",
            inm_header->inm_header.gltp_type, inm_header->inm_header.gltp_func);
        return -1;
    }
    g_header->length = msg_len;

    pthread_mutex_lock(&term_mutex);
    pTerm->isBusy = false; //����busy���
    pthread_mutex_unlock(&term_mutex);

    //�����ط���Ϣ
    keep_last_response(g_header, pTerm->index);

    //send to net
    c->send_message(gltp_buf, g_header->length);
    return 0;
}

int ncpc_process_Send_terminal_uns_message(NCPC_SERVER *ns, char *inm_buf)
{
    INM_MSG_T_HEADER *inm_header = (INM_MSG_T_HEADER *)inm_buf;
    char gltp_buf[MAX_BUFFER] = {0};
    GLTP_MSG_T_HEADER *g_header = (GLTP_MSG_T_HEADER *)gltp_buf;

    g_header->type = inm_header->inm_header.gltp_type;
    g_header->func = inm_header->inm_header.gltp_func;
    g_header->when = get_now();
    g_header->msn = inm_header->msn;
    g_header->token = 0;
    g_header->identify = 0;
    g_header->param = inm_header->reqParam;
    g_header->status = 0;

    NCPC_MSG_DISPATCH_CELL *msg_cell = ncpc_get_dispatch(inm_header->inm_header.gltp_type, inm_header->inm_header.gltp_func);
    if (msg_cell == NULL) {
        log_error("ncpc_get_dispatch() failed. unknow message type[%d] func[%d]",
            inm_header->inm_header.gltp_type, inm_header->inm_header.gltp_func);
        return -1;
    }

    int msg_len = msg_cell->S_process(ns, inm_buf, gltp_buf);
    if (msg_len <= 0) {
        log_warn("S_process() failed. type[%d] func[%d]",
            inm_header->inm_header.gltp_type, inm_header->inm_header.gltp_func);
        return -1;
    }
    g_header->length = msg_len;

    //send to net
    ns->send_uns_message(gltp_buf, g_header->length);
    return 0;
}


//auth
int R_TERM_auth_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf)
{
    GLTP_MSG_T_AUTH_REQ *gltp_auth_msg = (GLTP_MSG_T_AUTH_REQ *)gltp_buf;
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER *)inm_buf;
    INM_MSG_T_AUTH *inm_auth_msg = (INM_MSG_T_AUTH *)inm_buf;
    msg_header->inm_header.type = INM_TYPE_T_AUTH;
    msg_header->cid = 0;
    msg_header->token = 0;
    msg_header->terminalCode = 0;
    msg_header->agencyCode = 0;
    msg_header->areaCode = 0;
    memcpy(inm_auth_msg->mac,(char*)gltp_auth_msg->mac,6);
	memcpy(inm_auth_msg->version, gltp_auth_msg->version, sizeof(inm_auth_msg->version));

    int rc = otldb_spcall_auth(inm_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_warn("Terminal auth failure. MAC[%02X:%02X:%02X:%02X:%02X:%02X] does not exist",
                     gltp_auth_msg->mac[0], gltp_auth_msg->mac[1], gltp_auth_msg->mac[2],
                     gltp_auth_msg->mac[3], gltp_auth_msg->mac[4], gltp_auth_msg->mac[5]);
        send_inm_auth_message(ns, inm_auth_msg, rc);
        return 0;
    }
    // auth success
    pthread_mutex_lock(&term_mutex);
    TMS_TERMINAL_RECORD* pTerm = tms_mgr()->authTerm(msg_header->terminalCode,msg_header->agencyCode,msg_header->areaCode,gltp_auth_msg->mac,msg_header->inm_header.socket_idx);
    pthread_mutex_unlock(&term_mutex);
    if (pTerm == NULL) {
        log_warn("full terminal space.");
        send_inm_auth_message(ns, inm_auth_msg, SYS_RESULT_T_AUTHENTICATE_ERR);
        return 0;
    }
    msg_header->cid = pTerm->index;
    msg_header->token = pTerm->token;
    send_inm_auth_message(ns, inm_auth_msg, SYS_RESULT_SUCCESS);
    return 0;
}

int S_TERM_auth_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf)
{
    ts_notused_args;
    INM_MSG_T_AUTH *inm_msg = (INM_MSG_T_AUTH *)inm_buf;
    GLTP_MSG_T_AUTH_RSP *g_msg = (GLTP_MSG_T_AUTH_RSP *)gltp_buf;

    TMS_TERMINAL_RECORD *pTerm = tms_mgr()->getTermByIndex(inm_msg->header.cid);
    if (NULL == pTerm) {
        log_error("term is NULL. idx[%d]", inm_msg->header.cid);
        return -1;
    }
    pthread_mutex_lock(&term_mutex);
    pTerm->isBusy = false; //����busy���
    pthread_mutex_unlock(&term_mutex);
    g_msg->timeStamp = get_now();
    g_msg->terminalCode = inm_msg->header.terminalCode;
    g_msg->agencyCode = inm_msg->header.agencyCode;
    g_msg->areaCode = inm_msg->header.areaCode;
    g_msg->header.length = sizeof(GLTP_MSG_T_AUTH_RSP);
    return 0;
}

//echo
int R_TERM_echo_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf)
{
    ts_notused_args;
    GLTP_MSG_T_ECHO_REQ *g_msg = (GLTP_MSG_T_ECHO_REQ *)gltp_buf;
    INM_MSG_T_ECHO *inm_msg = (INM_MSG_T_ECHO *)inm_buf;
    int32 cid = inm_msg->header.cid;

    inm_msg->header.inm_header.type = INM_TYPE_T_ECHO;

    int len = sizeof(INM_MSG_T_ECHO);

    TMS_TERMINAL_RECORD* pTerm = tms_mgr()->getTermByIndex(cid);
    if (NULL == pTerm) {
        log_error("term is NULL. idx[%d]", cid);
        inm_msg->header.inm_header.status = SYS_RESULT_T_TOKEN_EXPIRED_ERR;
        return len;
    }

    const char echo_str[] = "Welcome, I'm TaiShan System. ";
    inm_msg->echo_len = sprintf(inm_msg->echo_str, "%s <%s>", echo_str, g_msg->echo_str) + 1;
    return (sizeof(INM_MSG_T_ECHO) + inm_msg->echo_len);
}

int S_TERM_echo_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf)
{
    ts_notused_args;

    INM_MSG_T_ECHO *inm_msg = (INM_MSG_T_ECHO *)inm_buf;
    GLTP_MSG_T_ECHO_RSP *g_msg = (GLTP_MSG_T_ECHO_RSP *)gltp_buf;
    g_msg->timeStamp = inm_msg->header.inm_header.when;

    g_msg->echo_len = inm_msg->echo_len;
    memcpy(g_msg->echo_str, inm_msg->echo_str, g_msg->echo_len);
    return ( sizeof(GLTP_MSG_T_ECHO_RSP) + g_msg->echo_len + CRC_SIZE);
}


int R_TERM_signin_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf)
{
    ts_notused_args;
    GLTP_MSG_T_SIGNIN_REQ *g_msg = (GLTP_MSG_T_SIGNIN_REQ *)gltp_buf;
    INM_MSG_T_SIGNIN *inm_msg = (INM_MSG_T_SIGNIN *)inm_buf;
    int32 cid = inm_msg->header.cid;

    inm_msg->header.inm_header.type = INM_TYPE_T_SIGNIN;

    int len = sizeof(INM_MSG_T_SIGNIN);

    TMS_TERMINAL_RECORD* pTerm = tms_mgr()->getTermByIndex(cid);
    if (NULL == pTerm) {
        log_error("term is NULL. idx[%d]", cid);
        inm_msg->header.inm_header.status = SYS_RESULT_T_TOKEN_EXPIRED_ERR;
        return len;
    }
    inm_msg->header.tellerCode = g_msg->tellerCode;
    strncpy(inm_msg->password, g_msg->password, PWD_MD5_LENGTH); inm_msg->password[PWD_MD5_LENGTH] = 0;

    int rc = otldb_spcall_signin(inm_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("Teller[%u] signin failure.",g_msg->tellerCode);
        inm_msg->header.inm_header.status = rc;
        return len;
    }
    inm_msg->loginTime = get_now();

    //���������MD5���㣬���������111111����Ҫ��ǿ���޸�����
    char init_pwd[33];  //-******************************* ����111111��MD5���룬����init_pwd
    //DEFAULT_TELLER_PASSWORD
    //
    //
    //
    //
    //
    if (strcmp(init_pwd,inm_msg->password) == 0)
        inm_msg->forceModifyPwd = 1;

    tms_mgr()->signinTerm(cid,g_msg->tellerCode, inm_msg->nextFlowNumber);
    return len;
}

int S_TERM_signin_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf)
{
    ts_notused_args;
    GLTP_MSG_T_SIGNIN_RSP *g_msg = (GLTP_MSG_T_SIGNIN_RSP *)gltp_buf;
    INM_MSG_T_SIGNIN *inm_msg = (INM_MSG_T_SIGNIN *)inm_buf;
    g_msg->timeStamp = inm_msg->header.inm_header.when;
    g_msg->tellerCode = inm_msg->header.tellerCode;
    g_msg->tellerType = inm_msg->tellerType;
    g_msg->availableCredit = inm_msg->availableCredit;
    g_msg->forceModifyPwd = inm_msg->forceModifyPwd;
    g_msg->flowNumber = inm_msg->nextFlowNumber;
    g_msg->exchangeRate = sysdb_getDatabasePtr()->riel_to_usd;
    return sizeof(GLTP_MSG_T_SIGNIN_RSP);
}

int R_TERM_signout_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf)
{
    ts_notused_args;
    //GLTP_MSG_T_SIGNOUT_REQ *g_msg = (GLTP_MSG_T_SIGNOUT_REQ *)gltp_buf;
    INM_MSG_T_SIGNOUT *inm_msg = (INM_MSG_T_SIGNOUT *)inm_buf;
    int32 cid = inm_msg->header.cid;

    inm_msg->header.inm_header.type = INM_TYPE_T_SIGNOUT;

    int len = sizeof(INM_MSG_T_SIGNOUT);

    TMS_TERMINAL_RECORD* pTerm = tms_mgr()->getTermByIndex(cid);
    if (NULL == pTerm) {
        log_error("term is NULL. idx[%d]", cid);
        inm_msg->header.inm_header.status = SYS_RESULT_T_TOKEN_EXPIRED_ERR;
        return len;
    }

    int rc = otldb_spcall_signout(inm_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("Teller[%u] signout failure.",inm_msg->header.tellerCode);
        inm_msg->header.inm_header.status = rc;
        return len;
    }
    inm_msg->logoutTime = get_now();

    tms_mgr()->signoutTerm(cid);
    return sizeof(INM_MSG_T_SIGNOUT);
}

int S_TERM_signout_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf)
{
    ts_notused_args;
    GLTP_MSG_T_SIGNOUT_RSP *g_msg = (GLTP_MSG_T_SIGNOUT_RSP *)gltp_buf;
    INM_MSG_T_SIGNOUT *inm_msg = (INM_MSG_T_SIGNOUT *)inm_buf;
    g_msg->timeStamp = inm_msg->header.inm_header.when;

    return sizeof(GLTP_MSG_T_SIGNOUT_RSP);
}

int R_TERM_changepwd_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf)
{
    ts_notused_args;
    GLTP_MSG_T_CHANGE_PWD_REQ *g_msg = (GLTP_MSG_T_CHANGE_PWD_REQ *)gltp_buf;
    INM_MSG_T_CHANGE_PWD *inm_msg = (INM_MSG_T_CHANGE_PWD *)inm_buf;
    int32 cid = inm_msg->header.cid;

    inm_msg->header.inm_header.type = INM_TYPE_T_CHANGE_PWD;

    int len = sizeof(INM_MSG_T_CHANGE_PWD);

    TMS_TERMINAL_RECORD* pTerm = tms_mgr()->getTermByIndex(cid);
    if (NULL == pTerm) {
        log_error("term is NULL. idx[%d]", cid);
        inm_msg->header.inm_header.status = SYS_RESULT_T_TOKEN_EXPIRED_ERR;
        return len;
    }
    inm_msg->header.tellerCode = g_msg->tellerCode;
    strncpy(inm_msg->oldPassword, g_msg->oldPassword, PWD_MD5_LENGTH); inm_msg->oldPassword[PWD_MD5_LENGTH] = 0;
    strncpy(inm_msg->newPassword, g_msg->newPassword, PWD_MD5_LENGTH); inm_msg->newPassword[PWD_MD5_LENGTH] = 0;

    int rc = otldb_spcall_change_password(inm_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("Teller[%u] change password failure.",g_msg->tellerCode);
        inm_msg->header.inm_header.status = rc;
        return len;
    }
    inm_msg->changeTime = get_now();
    return sizeof(INM_MSG_T_CHANGE_PWD);
}

int S_TERM_changepwd_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf)
{
    ts_notused_args;
    GLTP_MSG_T_CHANGE_PWD_RSP *g_msg = (GLTP_MSG_T_CHANGE_PWD_RSP *)gltp_buf;
    INM_MSG_T_CHANGE_PWD *inm_msg = (INM_MSG_T_CHANGE_PWD *)inm_buf;
    g_msg->timeStamp = inm_msg->header.inm_header.when;

    return sizeof(GLTP_MSG_T_CHANGE_PWD_RSP);
}

int R_TERM_agencybalance_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf)
{
    ts_notused_args;
    //GLTP_MSG_T_AGENCY_BALANCE_REQ *g_msg = (GLTP_MSG_T_AGENCY_BALANCE_REQ *)gltp_buf;
    INM_MSG_T_AGENCY_BALANCE *inm_msg = (INM_MSG_T_AGENCY_BALANCE *)inm_buf;
    int32 cid = inm_msg->header.cid;

    inm_msg->header.inm_header.type = INM_TYPE_T_AGENCY_BALANCE;

    int len = sizeof(INM_MSG_T_AGENCY_BALANCE);

    TMS_TERMINAL_RECORD* pTerm = tms_mgr()->getTermByIndex(cid);
    if (NULL == pTerm) {
        log_error("term is NULL. idx[%d]", cid);
        inm_msg->header.inm_header.status = SYS_RESULT_T_TOKEN_EXPIRED_ERR;
        return len;
    }
    inm_msg->agencyCode = pTerm->agencyCode;

    int rc = otldb_spcall_agency_balance(inm_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("inquiry agency[%llu] balance failure.",inm_msg->header.agencyCode);
        inm_msg->header.inm_header.status = rc;
        return len;
    }
    return sizeof(INM_MSG_T_AGENCY_BALANCE);
}

int S_TERM_agencybalance_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf)
{
    ts_notused_args;
    GLTP_MSG_T_AGENCY_BALANCE_RSP *g_msg = (GLTP_MSG_T_AGENCY_BALANCE_RSP *)gltp_buf;
    INM_MSG_T_AGENCY_BALANCE *inm_msg = (INM_MSG_T_AGENCY_BALANCE *)inm_buf;
    g_msg->timeStamp = inm_msg->header.inm_header.when;

    g_msg->agencyCode = inm_msg->agencyCode;
    g_msg->availableCredit = inm_msg->accountBalance + inm_msg->marginalCreditLimit;
    g_msg->accountBalance = inm_msg->accountBalance;
    g_msg->marginalCreditLimit = inm_msg->marginalCreditLimit;
    return sizeof(GLTP_MSG_T_AGENCY_BALANCE_RSP);
}

int R_TERM_gameinfo_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf)
{
    ts_notused_args;
    //GLTP_MSG_T_GAME_INFO_REQ *g_msg = (GLTP_MSG_T_GAME_INFO_REQ *)gltp_buf;
    INM_MSG_T_GAME_INFO *inm_msg = (INM_MSG_T_GAME_INFO *)inm_buf;
    int32 cid = inm_msg->header.cid;

    inm_msg->header.inm_header.type = INM_TYPE_T_GAME_INFO;

    int len = sizeof(INM_MSG_T_GAME_INFO);

    TMS_TERMINAL_RECORD* pTerm = tms_mgr()->getTermByIndex(cid);
    if (NULL == pTerm) {
        log_error("term is NULL. idx[%d]", cid);
        inm_msg->header.inm_header.status = SYS_RESULT_T_TOKEN_EXPIRED_ERR;
        return len;
    }

    int rc = otldb_spcall_game_info(inm_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("inquiry game information failure.");
        inm_msg->header.inm_header.status = rc;
        return len;
    }

    int game_count = 0;
    GAME_INFO *game_info = NULL;
    for (int game_code=1; game_code<MAX_GAME_NUMBER; game_code++) {
        GAME_DATA *gd = gl_getGameData(game_code);
        if (!gd->used) continue;
        game_info = &inm_msg->gameArray[game_count];
        game_info->gameCode = game_code;
        TRANSCTRL_PARAM *trans_param = gl_getTransctrlParam(game_code);
        game_plugins_handle[game_info->gameCode].get_singleAmount(game_info->singleAmount, sizeof(game_info->singleAmount));
        game_info->maxAmountPerTicket = trans_param->maxAmountPerTicket;
        game_info->maxBetTimes = trans_param->maxTimesPerBetLine;
        game_info->maxIssueCount = trans_param->maxIssueCount;

        ISSUE_INFO *issue_ptr = game_plugins_handle[game_info->gameCode].get_currIssue();
        if (NULL == issue_ptr) {
            game_info->currentIssueNumber = 0;
            game_info->currentIssueCloseTime = 0;
        } else {
            game_info->currentIssueNumber = issue_ptr->issueNumber;
            game_info->currentIssueCloseTime = issue_ptr->closeTime;
        }
        game_count++;
    }
    inm_msg->gameCount = game_count;
    return sizeof(INM_MSG_T_GAME_INFO) + inm_msg->gameCount * sizeof(GAME_INFO);
}

int S_TERM_gameinfo_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf)
{
    ts_notused_args;
    GLTP_MSG_T_GAME_INFO_RSP *g_msg = (GLTP_MSG_T_GAME_INFO_RSP *)gltp_buf;
    INM_MSG_T_GAME_INFO *inm_msg = (INM_MSG_T_GAME_INFO *)inm_buf;
    g_msg->timeStamp = inm_msg->header.inm_header.when;

    strncpy(g_msg->contactAddress, inm_msg->contactAddress, sizeof(g_msg->contactAddress));
    strncpy(g_msg->contactPhone, inm_msg->contactPhone, sizeof(g_msg->contactPhone));
    strncpy(g_msg->ticketSlogan, inm_msg->ticketSlogan, sizeof(g_msg->ticketSlogan));

    g_msg->gameCount = inm_msg->gameCount;
    int b_len = sizeof(GAME_INFO) * g_msg->gameCount;
    memcpy((char *)g_msg->gameArray, (char *)inm_msg->gameArray, b_len);
    return (sizeof(GLTP_MSG_T_GAME_INFO_RSP) + b_len + CRC_SIZE);
}


uint32 sale_verifyIssue(uint8 gameCode, uint64 issue, uint8 count, ISSUE_INFO* curr_issue_info)
{
    uint64 startIssueNumber = 0;
    uint64 currIssueNumber = curr_issue_info->issueNumber;

    TRANSCTRL_PARAM *transctrlParam = gl_getTransctrlParam(gameCode);
    if (count > transctrlParam->maxIssueCount) {
        log_debug("Issue count[%d] error. game[%d].", count, gameCode);
        return SYS_RESULT_SELL_ISSUECOUNT_ERR;
    }
    ISSUE_INFO *start_issue_info = NULL;
    if(issue == 0) {
        startIssueNumber = currIssueNumber;
        start_issue_info = curr_issue_info;
    } else if (issue != currIssueNumber) {
        start_issue_info = game_plugins_handle[gameCode].get_issueInfo(issue);
        if (start_issue_info == NULL) {
            log_debug("get_issueInfo[%lld] error.", issue);
            return SYS_RESULT_SELL_NOISSUE_ERR;
        }
        startIssueNumber = issue;
    } else {
        startIssueNumber = issue;
        start_issue_info = curr_issue_info;
    }
    for (int i = 1; i<count; i++) {
        ISSUE_INFO *yIssue = game_plugins_handle[gameCode].get_issueInfo2(start_issue_info->serialNumber+i);
        if ((yIssue==NULL) || (yIssue->curState!=ISSUE_STATE_PRESALE)) {
            log_debug("Issue serialNumber [%d] not ready for sell.", (start_issue_info->serialNumber+i));
            return SYS_RESULT_SELL_ISSUECOUNT_ERR;
        }
    }
    if ( (start_issue_info->used)) {
        if (((start_issue_info->curState==ISSUE_STATE_OPENED) || (start_issue_info->curState==ISSUE_STATE_CLOSING) )
            && (start_issue_info->localState!=ISSUE_STATE_CLOSED))
        {
            return SYS_RESULT_SUCCESS;
        }
        if ( (start_issue_info->curState==ISSUE_STATE_PRESALE)
            && (startIssueNumber>=currIssueNumber)
            && ( (startIssueNumber+count)<=(currIssueNumber+transctrlParam->maxIssueCount) ) )
        {
            return SYS_RESULT_SUCCESS;
        }
    }
    return SYS_RESULT_SELL_ISSUECOUNT_ERR;
}
int term_sellticket(char *gltp_buf, char *inm_buf, TMS_TERMINAL_RECORD* pTerm)
{
    int ret  = 0;
    GLTP_MSG_T_SELL_TICKET_REQ *g_msg = (GLTP_MSG_T_SELL_TICKET_REQ *)gltp_buf;
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER *)inm_buf;
    INM_MSG_T_SELL_TICKET *inm_msg = (INM_MSG_T_SELL_TICKET *)inm_buf;
    int32 cid = msg_header->cid;

    msg_header->inm_header.type = INM_TYPE_T_SELL_TICKET;

    int len = offsetof(INM_MSG_T_SELL_TICKET, ticket);

    inm_msg->ticket.betStringLen = g_msg->betStringLen + 1;//�����Լ���һ��'\0'
    strncpy(inm_msg->ticket.betString, g_msg->betString, g_msg->betStringLen);
    ret = gl_formatTicket(inm_msg->ticket.betString, (char *)&inm_msg->ticket, INM_MSG_BUFFER_LENGTH-1024);
    if (ret < 0) {
        msg_header->inm_header.status = SYS_RESULT_SELL_DATA_ERR; //Ͷע�ַ�����ʽ����
        log_error("gl_formatTicket error");
        return len;
    }
    strncpy(inm_msg->loyaltyNum, g_msg->loyaltyNum, LOYALTY_CARD_LENGTH);
    inm_msg->loyaltyNum[LOYALTY_CARD_LENGTH] = 0;

    //DUMP Ticket
    gl_dumpTicket(&inm_msg->ticket);

    uint8 game_code = inm_msg->ticket.gameCode;
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
    ret = sale_verifyIssue(game_code, inm_msg->ticket.issue, inm_msg->ticket.issueCount, curr_issue_info);
    if ( ret != SYS_RESULT_SUCCESS ) {
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
    if (inm_msg->ticket.issue==0)
        saleStartIssue = curr_issue_info->issueNumber;
    ISSUE_INFO * start_issue_info = game_plugins_handle[game_code].get_issueInfo(saleStartIssue);
    ISSUE_INFO * end_issue_info = game_plugins_handle[game_code].get_issueInfo2(start_issue_info->serialNumber+inm_msg->ticket.issueCount-1);
    if (end_issue_info == NULL) {
        log_debug("game plugin get_issueInfo2(game_code[%u], issue_serial[%u]) return NULL.",
                  game_code, start_issue_info->serialNumber+inm_msg->ticket.issueCount-1);
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    inm_msg->issueNumber = curr_issue_info->issueNumber;           //ϵͳ������Ʊʱ�ĵ�ǰ�ں�
    inm_msg->ticket.issue = start_issue_info->issueNumber;         //����Ʊʵ����ʵ����ĵ�һ�ڵ��ں�
    inm_msg->ticket.issueSeq = start_issue_info->serialNumber;     //����Ʊʵ����ʵ����ĵ�һ�ڵ��ڴ����
    inm_msg->ticket.lastIssue = end_issue_info->issueNumber;       //����Ʊʵ����ʵ��������һ�ڵ��ں�
    inm_msg->drawTimeStamp = end_issue_info->drawTime;             //���һ�ڵĿ���ʱ��

    //��Ϸ���տ��Ƽ��
    if ((isGameBeRiskControl(game_code)) && (NULL!=game_plugins_handle[game_code].sale_rk_verify)) {
        pthread_mutex_lock(&risk_mutex[game_code]);
        ret = game_plugins_handle[game_code].sale_rk_verify(&inm_msg->ticket);
        if (false == ret) {
            msg_header->inm_header.status = SYS_RESULT_RISK_CTRL_ERR;
            pthread_mutex_unlock(&risk_mutex[game_code]);
            return len;
        }
        pthread_mutex_unlock(&risk_mutex[game_code]);
    }

    generate_reqfn(1, pTerm->termCode, tms_mgr()->getSequence(), inm_msg->reqfn_ticket); //����������ˮ��

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

    if (inm_msg->ticket.isTrain == 1)
    {
        msg_header->reqParam = 0x8000; //��ѵƱ���
        if ((isGameBeRiskControl(game_code)) && (NULL != game_plugins_handle[game_code].cancel_rk_rollback)) {
            pthread_mutex_lock(&risk_mutex[game_code]);
            game_plugins_handle[game_code].cancel_rk_rollback(&inm_msg->ticket);
            pthread_mutex_unlock(&risk_mutex[game_code]);
        }
    }

    len = offsetof(INM_MSG_T_SELL_TICKET, ticket) + inm_msg->ticket.length;

    pTerm->flowNumber = inm_msg->flowNumber;
    pTerm->last_crc = *(uint16 *)&gltp_buf[g_msg->header.length-2]; //�������һ�ν��׵�crc

    //���۴��澯
    if ((transctrlParam->saleLimit!=0) && (inm_msg->ticket.amount >= transctrlParam->saleLimit)) {
        notify_agency_sale_bigAmount(inm_msg->header.agencyCode, game_code,
        		inm_msg->ticket.issue, inm_msg->ticket.amount, inm_msg->availableCredit);
    }
    return len;
}
int term_fbs_sellticket(char *gltp_buf, char *inm_buf, TMS_TERMINAL_RECORD* pTerm)
{
    int ret  = 0;
    GLTP_MSG_T_SELL_TICKET_REQ *g_msg = (GLTP_MSG_T_SELL_TICKET_REQ *)gltp_buf;
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER *)inm_buf;
    INM_MSG_FBS_SELL_TICKET *inm_msg = (INM_MSG_FBS_SELL_TICKET *)inm_buf;
    int32 cid = msg_header->cid;

    msg_header->inm_header.type = INM_TYPE_FBS_SELL_TICKET;

    int len = sizeof(INM_MSG_FBS_SELL_TICKET);
    //k-debug
    log_debug("fbs sell gltp. termLen[%d]strlen[%d][%s]",
            g_msg->betStringLen, strlen(g_msg->betString), g_msg->betString);

    //***ע��betStringLen����ֵ��ʹ��fbs_ticket
    inm_msg->betStringLen = g_msg->betStringLen + 1;//�����Լ���һ��'\0'
    FBS_TICKET *fbs_ticket = (FBS_TICKET*)(inm_msg->betString+inm_msg->betStringLen);
    strncpy(inm_msg->betString, g_msg->betString, g_msg->betStringLen);
    ret = gl_fbs_formatTicket(inm_msg->betString, (char *)fbs_ticket, INM_MSG_BUFFER_LENGTH-1024);
    if (ret < 0) {
        msg_header->inm_header.status = SYS_RESULT_SELL_DATA_ERR; //Ͷע�ַ�����ʽ����
        log_error("gl_fbs_formatTicket error");
        return len;
    }
    strncpy(inm_msg->loyaltyNum, g_msg->loyaltyNum, LOYALTY_CARD_LENGTH);
    inm_msg->loyaltyNum[LOYALTY_CARD_LENGTH] = 0;

    //DUMP Ticket
    gl_dumpFbsTicket(fbs_ticket);

    uint8 game_code = fbs_ticket->game_code;
    //�����Ϸ����
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
    if (fbs_ticket->bet_amount > transctrlParam->maxAmountPerTicket) {
        log_debug("Fbs saleProcessing tmoney[%lld]", fbs_ticket->bet_amount);
        return SYS_RESULT_SELL_TICKET_AMOUNT_ERR;
    }
    //���Ͷע����
    if ((fbs_ticket->match_count > transctrlParam->maxBetLinePerTicket) || (fbs_ticket->match_count < 1)) {
        log_info("saleProcessing gl_verifyBetCountParam gameCode[%d] matchCount[%d] error", game_code, fbs_ticket->match_count);
        msg_header->inm_header.status = SYS_RESULT_SELL_BETLINE_ERR;
        return len;
    }

    //������Ϸ�������Ʊ��֤,������֤
    uint32 drawTime = 0;
    ret = game_plugins_handle[game_code].fbs_ticket_verify(fbs_ticket, &drawTime);
    if ( ret != 0 )
    {
        log_debug("sale_fbs_ticket_verify failure. ticket->%s", inm_msg->betString);
        msg_header->inm_header.status = ret;
        return len;
    }
    inm_msg->issueNumber = fbs_ticket->issue_number;
    inm_msg->drawTimeStamp = drawTime;  //����ʱ��


    generate_reqfn(1, pTerm->termCode, tms_mgr()->getSequence(), inm_msg->reqfn_ticket); //����������ˮ��

    int rc = otldb_spcall_fbs_sale(inm_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("sell fbs ticket failure.");
        inm_msg->header.inm_header.status = rc;
        return len;
    }

    if (fbs_ticket->is_train == 1)
        msg_header->reqParam = 0x8000; //��ѵƱ���

    pTerm->flowNumber = inm_msg->flowNumber;
    pTerm->last_crc = *(uint16 *)&gltp_buf[g_msg->header.length-2]; //�������һ�ν��׵�crc

    //���۴��澯
    if ((transctrlParam->saleLimit!=0) && (fbs_ticket->bet_amount >= transctrlParam->saleLimit)) {
        notify_agency_sale_bigAmount(inm_msg->header.agencyCode, game_code,
        		fbs_ticket->issue_number, fbs_ticket->bet_amount, inm_msg->availableCredit);
    }

    len = sizeof(INM_MSG_FBS_SELL_TICKET) + inm_msg->betStringLen + fbs_ticket->length;

    log_debug("k-debug:ncpc len0[%d],len[%d],amount[%llu],str[%s]",
            len, fbs_ticket->length, fbs_ticket->bet_amount, inm_msg->betString);
    return len;
}

int R_TERM_sellticket_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf)
{
    ts_notused_args;
    int ret = 0;
    GLTP_MSG_T_SELL_TICKET_REQ *g_msg = (GLTP_MSG_T_SELL_TICKET_REQ *)gltp_buf;
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER *)inm_buf;
    int32 cid = msg_header->cid;

    msg_header->inm_header.type = INM_TYPE_COMMOM_ERR;
    int len = sizeof(INM_MSG_T_HEADER);

    TMS_TERMINAL_RECORD* pTerm = tms_mgr()->getTermByIndex(cid);
    if (NULL == pTerm) {
        log_error("term is NULL. idx[%d]", cid);
        msg_header->inm_header.status = SYS_RESULT_T_TOKEN_EXPIRED_ERR;
        return len;
    }

	if (g_msg->betStringLen >= 2048) {
	    msg_header->inm_header.status = SYS_RESULT_SELL_DATA_ERR; //Ͷע�ַ�����ʽ����
        log_error("g_msg->betStringLen[%d]", g_msg->betStringLen);
        return len;
	}
    int game_code = gl_formatGame(g_msg->betString);
    if (-1 == game_code) {
        msg_header->inm_header.status = SYS_RESULT_SELL_DATA_ERR; //Ͷע�ַ�����ʽ����
        log_error("g_msg->betStringLen[%d]", g_msg->betStringLen);
        return len;
    } else if (0 == game_code) {
        msg_header->inm_header.status = SYS_RESULT_GAME_DISABLE_ERR;//��Ϸ������
        log_debug("SYS_RESULT_GAME_DISABLE_ERR: saleProcessing gameCode[%d] can't used.", game_code);
        return len;
    }

    if ((game_code!=GAME_FBS) && (game_code!=GAME_FODD)) {
        //��ͨ��Ϸ
        return term_sellticket(gltp_buf, inm_buf, pTerm);
    }
    // FBS ��Ϸ
    return term_fbs_sellticket(gltp_buf, inm_buf, pTerm);
}

int S_TERM_sellticket_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf)
{
    ts_notused_args;
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER *)inm_buf;
    GLTP_MSG_T_SELL_TICKET_RSP *g_msg = (GLTP_MSG_T_SELL_TICKET_RSP *)gltp_buf;
    g_msg->timeStamp = msg_header->inm_header.when;
    g_msg->transTimeStamp = msg_header->inm_header.when;


    if (msg_header->inm_header.type == INM_TYPE_T_SELL_TICKET) {
        INM_MSG_T_SELL_TICKET *inm_msg = (INM_MSG_T_SELL_TICKET *)inm_buf;
        memcpy(g_msg->rspfn_ticket, inm_msg->rspfn_ticket, TSN_LENGTH);
        g_msg->availableCredit = inm_msg->availableCredit;
        g_msg->gameCode = inm_msg->ticket.gameCode;
        g_msg->currentIssueNumber = inm_msg->issueNumber;
        g_msg->flowNumber = inm_msg->flowNumber;
        g_msg->transAmount = inm_msg->ticket.amount;
        g_msg->drawTimeStamp = inm_msg->drawTimeStamp;
    } else if (msg_header->inm_header.type == INM_TYPE_FBS_SELL_TICKET) {
        INM_MSG_FBS_SELL_TICKET *inm_msg = (INM_MSG_FBS_SELL_TICKET *)inm_buf;
        FBS_TICKET *fbs_ticket = (FBS_TICKET*)(inm_msg->betString+inm_msg->betStringLen);

        memcpy(g_msg->rspfn_ticket, inm_msg->rspfn_ticket, TSN_LENGTH);
        g_msg->availableCredit = inm_msg->availableCredit;
        g_msg->gameCode = fbs_ticket->game_code;
        g_msg->currentIssueNumber = inm_msg->issueNumber;
        g_msg->flowNumber = inm_msg->flowNumber;
        g_msg->transAmount = fbs_ticket->bet_amount;
        g_msg->drawTimeStamp = inm_msg->drawTimeStamp;
    }

    return sizeof(GLTP_MSG_T_SELL_TICKET_RSP);
}


int term_inquiryticket(char *gltp_buf, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec)
{
    GLTP_MSG_T_INQUIRY_TICKET_REQ *g_msg = (GLTP_MSG_T_INQUIRY_TICKET_REQ *)gltp_buf;
    INM_MSG_T_INQUIRY_TICKET *inm_msg = (INM_MSG_T_INQUIRY_TICKET *)inm_buf;
    int32 cid = inm_msg->header.cid;

    inm_msg->header.inm_header.type = INM_TYPE_T_INQUIRY_TICKET_DETAIL;

    int len = sizeof(INM_MSG_T_INQUIRY_TICKET);

    inm_msg->betStringLen = 0; //�������������жϴ�INM��Ϣ�Ƿ�Я��ԭʼͶע��Ϣ

    int rc = otldb_spcall_inquiry_ticket(inm_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("db verify Inquiry ticket failure. agencyCode[%llu]",inm_msg->header.agencyCode);
        inm_msg->header.inm_header.status = rc;
        return len;
    }

    inm_msg->unique_tsn = tidx_rec->unique_tsn;
    memcpy(inm_msg->rspfn_ticket, g_msg->rspfn_ticket, TSN_LENGTH);
    inm_msg->gameCode = tidx_rec->gameCode;
    inm_msg->saleStartIssue = tidx_rec->issueNumber;
    inm_msg->saleLastIssue = tidx_rec->drawIssueNumber;

    uint8 game_code = inm_msg->gameCode;
    //�����Ϸ����
    if (!isGameBeUsed(game_code)) {
        log_debug("SYS_RESULT_GAME_DISABLE_ERR: gameCode[%d] can't used.", game_code);
        inm_msg->header.inm_header.status = SYS_RESULT_GAME_DISABLE_ERR;
        return len;
    }
    //����Ƿ��ڷ���ʱ�εķ�Χ��
    if (false == gl_verifyServiceTime(game_code)) {
        log_debug("SYS_RESULT_GAME_SERVICETIME_OUT_ERR: game[%d] time out of service time.", game_code);
        inm_msg->header.inm_header.status = SYS_RESULT_GAME_SERVICETIME_OUT_ERR; //��ǰ�����ڲ�Ʊ����ʱ��
        return len;
    }
    //�õ��ڴ���Ϣ
    GIDB_ISSUE_HANDLE * i_handle = gidb_i_get_handle(game_code);
    if (i_handle == NULL) {
        log_error("SYS_RESULT_FAILURE: gidb_i_get_handle return NULL  gameCode[%d].", game_code);
        inm_msg->header.inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    static GIDB_ISSUE_INFO issue_info;
    int ret = i_handle->gidb_i_get_info(i_handle, inm_msg->saleStartIssue, &issue_info);
    if (ret != 0) {
        log_error("SYS_RESULT_FAILURE: gidb_i_get_info2 found error. tsn[ %s ]", inm_msg->rspfn_ticket);
        inm_msg->header.inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    //��ѯ����Ʊ
    GIDB_T_TICKET_HANDLE * t_handle = gidb_t_get_handle(game_code, inm_msg->saleStartIssue);
    if(t_handle == NULL) {
        log_error("SYS_RESULT_FAILURE: gidb_t_get_handle return NULL  gameCode[%d] issueNumber[%lld].",
            game_code, inm_msg->saleStartIssue);
        inm_msg->header.inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    char sale_ticket_buf[INM_MSG_BUFFER_LENGTH] = {0};
    GIDB_SALE_TICKET_REC *pSaleTicket = (GIDB_SALE_TICKET_REC *)sale_ticket_buf;
    ret = t_handle->gidb_t_get_ticket(t_handle, inm_msg->unique_tsn, pSaleTicket);
    if (ret < 0) {
        log_error("SYS_RESULT_FAILURE: gidb_t_get_ticket found error. rspfn_ticket[ %s ] unique_tsn[ %llu ]", inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        inm_msg->header.inm_header.status = SYS_RESULT_FAILURE;
        return len;
    } else if (ret == 1) {
        log_debug("SYS_RESULT_PAY_NOT_FOUND_ERR: gidb_t_get_ticket return NULL. rspfn_ticket[ %s ] unique_tsn[ %llu ]", inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        inm_msg->header.inm_header.status = SYS_RESULT_TICKET_NOT_FOUND_ERR; //û���ҵ����Ų�Ʊ
        return len;
    }

    inm_msg->betStringLen = pSaleTicket->ticket.betStringLen;
    strncpy(inm_msg->betString, pSaleTicket->ticket.betString, inm_msg->betStringLen);
    return (sizeof(INM_MSG_T_INQUIRY_TICKET) + inm_msg->betStringLen);
}
int term_fbs_inquiryticket(char *gltp_buf, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec)
{
    GLTP_MSG_T_INQUIRY_TICKET_REQ *g_msg = (GLTP_MSG_T_INQUIRY_TICKET_REQ *)gltp_buf;
    INM_MSG_T_INQUIRY_TICKET *inm_msg = (INM_MSG_T_INQUIRY_TICKET *)inm_buf;
    int32 cid = inm_msg->header.cid;

    inm_msg->header.inm_header.type = INM_TYPE_FBS_INQUIRY_TICKET;

    int len = sizeof(INM_MSG_T_INQUIRY_TICKET);

    inm_msg->betStringLen = 0; //�������������жϴ�INM��Ϣ�Ƿ�Я��ԭʼͶע��Ϣ

    int rc = otldb_spcall_fbs_inquiry_ticket(inm_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("db verify Inquiry fbs ticket failure. agencyCode[%llu]",inm_msg->header.agencyCode);
        inm_msg->header.inm_header.status = rc;
        return len;
    }

    inm_msg->unique_tsn = tidx_rec->unique_tsn;
    memcpy(inm_msg->rspfn_ticket, g_msg->rspfn_ticket, TSN_LENGTH);
    inm_msg->gameCode = tidx_rec->gameCode;
    inm_msg->saleStartIssue = tidx_rec->issueNumber;
    inm_msg->saleLastIssue = tidx_rec->drawIssueNumber;

    uint8 game_code = inm_msg->gameCode;
    //�����Ϸ����
    if (!isGameBeUsed(game_code)) {
        log_debug("SYS_RESULT_GAME_DISABLE_ERR: gameCode[%d] can't used.", game_code);
        inm_msg->header.inm_header.status = SYS_RESULT_GAME_DISABLE_ERR;
        return len;
    }
    //����Ƿ��ڷ���ʱ�εķ�Χ��
    if (false == gl_verifyServiceTime(game_code)) {
        log_debug("SYS_RESULT_GAME_SERVICETIME_OUT_ERR: game[%d] time out of service time.", game_code);
        inm_msg->header.inm_header.status = SYS_RESULT_GAME_SERVICETIME_OUT_ERR; //��ǰ�����ڲ�Ʊ����ʱ��
        return len;
    }
    //��ѯ����Ʊ
    GIDB_FBS_ST_HANDLE *t_handle = gidb_fbs_st_get_handle(game_code, inm_msg->saleStartIssue);
    if(t_handle == NULL) {
        log_error("SYS_RESULT_FAILURE: gidb_fbs_st_get_handle return NULL  gameCode[%d] issueNumber[%lld].",
            game_code, inm_msg->saleStartIssue);
        inm_msg->header.inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    char sale_ticket_buf[INM_MSG_BUFFER_LENGTH] = {0};
    memset(sale_ticket_buf, 0, sizeof(INM_MSG_BUFFER_LENGTH));
    GIDB_FBS_ST_REC *pSaleTicket = (GIDB_FBS_ST_REC *)sale_ticket_buf;
    int ret = t_handle->gidb_fbs_st_get_ticket(t_handle, inm_msg->unique_tsn, pSaleTicket);
    if (ret < 0) {
        log_error("SYS_RESULT_FAILURE: gidb_fbs_st_get_ticket found error. rspfn_ticket[ %s ] unique_tsn[ %llu ]",
                inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        inm_msg->header.inm_header.status = SYS_RESULT_FAILURE;
        return len;
    } else if (ret == 1) {
        log_debug("SYS_RESULT_PAY_NOT_FOUND_ERR: gidb_fbs_st_get_ticket return NULL. rspfn_ticket[ %s ] unique_tsn[ %llu ]",
                inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        inm_msg->header.inm_header.status = SYS_RESULT_TICKET_NOT_FOUND_ERR; //û���ҵ����Ų�Ʊ
        return len;
    }
    inm_msg->betStringLen = pSaleTicket->bet_string_len;
    strncpy(inm_msg->betString, pSaleTicket->bet_string, inm_msg->betStringLen);
    return (sizeof(INM_MSG_T_INQUIRY_TICKET) + inm_msg->betStringLen);
}

int R_TERM_inquiryticket_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf)
{
    ts_notused_args;
    GLTP_MSG_T_INQUIRY_TICKET_REQ *g_msg = (GLTP_MSG_T_INQUIRY_TICKET_REQ *)gltp_buf;
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER *)inm_buf;
    int32 cid = msg_header->cid;
    
    msg_header->inm_header.type = INM_TYPE_COMMOM_ERR;
    int len = sizeof(INM_MSG_T_HEADER);

    TMS_TERMINAL_RECORD* pTerm = tms_mgr()->getTermByIndex(cid);
    if (NULL == pTerm) {
        log_error("term is NULL. idx[%d]", cid);
        msg_header->inm_header.status = SYS_RESULT_T_TOKEN_EXPIRED_ERR;
        return len;
    }

    //parse rspfn (tsn)
    uint32 date = 0;
    uint64 unique_tsn = extract_tsn(g_msg->rspfn_ticket, &date);
    if (unique_tsn==0) {
        log_error("extract_tsn failed. [ %s ]", g_msg->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_TSN_ERR; //TSN����
        return len;
    }
    //�������ļ��в�ѯƱ��Ϣ
    char tidx_buf[512] = {0};
    GIDB_TICKET_IDX_REC *tidx_rec = (GIDB_TICKET_IDX_REC*)tidx_buf;
    int ret = get_ticket_idx(date, unique_tsn, tidx_rec);
    if (ret < 0) {
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    } else if (ret == 1) {
        msg_header->inm_header.status = SYS_RESULT_TICKET_NOT_FOUND_ERR;
        return len;
    }
    //��֤У����
    if (0 != memcmp(g_msg->rspfn_ticket, tidx_rec->rspfn_ticket, TSN_LENGTH-1)) {
        log_error("tsn verify fail!!!, [ %s  ---  %s ]", g_msg->rspfn_ticket, tidx_rec->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_TSN_ERR; //TSN����
        return len;
    }

    if ((tidx_rec->gameCode!=GAME_FBS) && (tidx_rec->gameCode!=GAME_FODD)) {
        //��ͨ��Ϸ
        return term_inquiryticket(gltp_buf, inm_buf, tidx_rec);
    }
    // FBS ��Ϸ
    return term_fbs_inquiryticket(gltp_buf, inm_buf, tidx_rec);
}

int S_TERM_inquiryticket_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf)
{
    ts_notused_args;
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER *)inm_buf;
    GLTP_MSG_T_INQUIRY_TICKET_RSP *g_msg = (GLTP_MSG_T_INQUIRY_TICKET_RSP *)gltp_buf;
    g_msg->timeStamp = msg_header->inm_header.when;

    INM_MSG_T_INQUIRY_TICKET *inm_msg = (INM_MSG_T_INQUIRY_TICKET *)inm_buf;
    memcpy(g_msg->rspfn_ticket, inm_msg->rspfn_ticket, TSN_LENGTH);
    g_msg->gameCode = inm_msg->gameCode;
    g_msg->betStringLen = inm_msg->betStringLen;
    memcpy(g_msg->betString, inm_msg->betString,g_msg->betStringLen);

    return sizeof(GLTP_MSG_T_INQUIRY_TICKET_RSP) + g_msg->betStringLen + CRC_SIZE;
}



int term_inquiryWin(char *gltp_buf, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec)
{
    GLTP_MSG_T_INQUIRY_WIN_REQ *g_msg = (GLTP_MSG_T_INQUIRY_WIN_REQ *)gltp_buf;
    INM_MSG_T_INQUIRY_WIN *inm_msg = (INM_MSG_T_INQUIRY_WIN *)inm_buf;
    int32 cid = inm_msg->header.cid;

    inm_msg->header.inm_header.type = INM_TYPE_T_INQUIRY_WIN;

    int len = sizeof(INM_MSG_T_INQUIRY_WIN);

   int rc = otldb_spcall_inquiry_ticket(inm_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("db verify Inquiry win ticket failure. agencyCode[%llu]",inm_msg->header.agencyCode);
        inm_msg->header.inm_header.status = rc;
        return len;
    }

    inm_msg->unique_tsn = tidx_rec->unique_tsn;
    memcpy(inm_msg->rspfn_ticket, g_msg->rspfn_ticket, TSN_LENGTH);
    inm_msg->gameCode = tidx_rec->gameCode;
    inm_msg->saleStartIssue = tidx_rec->issueNumber;
    inm_msg->saleLastIssue = tidx_rec->drawIssueNumber;

    uint8 game_code = inm_msg->gameCode;
    //�����Ϸ����
    if (!isGameBeUsed(game_code)) {
        log_debug("process_T_inquiry_win gameCode[%d] can't used.", game_code);
        inm_msg->header.inm_header.status = SYS_RESULT_GAME_DISABLE_ERR;
        return len;
    }

    GIDB_T_TICKET_HANDLE * t_handle = gidb_t_get_handle(game_code, inm_msg->saleStartIssue);
    if (t_handle == NULL) {
        log_warn("SYS_RESULT_FAILURE: gidb_t_get_handle return NULL. gameCode[%d] issueNumber[%lld].",
            game_code, inm_msg->saleStartIssue);
        inm_msg->header.inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }

    char sale_ticket_buf[INM_MSG_BUFFER_LENGTH] = { 0 };
    memset(sale_ticket_buf, 0, INM_MSG_BUFFER_LENGTH);
    GIDB_SALE_TICKET_REC *pSaleTicket = (GIDB_SALE_TICKET_REC *)sale_ticket_buf;
    int ret = t_handle->gidb_t_get_ticket(t_handle, inm_msg->unique_tsn, pSaleTicket);
    if (ret < 0) {
        log_debug("SYS_RESULT_FAILURE: gidb_get_sell_ticket found error. rspfn_ticket[ %s ] unique_tsn[ %llu ]", inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        inm_msg->header.inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    else if (ret == 1) {
        log_debug("SYS_RESULT_PAY_NOT_FOUND_ERR: gidb_get_sell_ticket return NULL. tsn[ %s ]", inm_msg->rspfn_ticket);
        inm_msg->header.inm_header.status = SYS_RESULT_TICKET_NOT_FOUND_ERR; //û���ҵ����Ų�Ʊ
        return len;
    }

    if (pSaleTicket->isCancel)
    {
        log_debug("TSN[ %s ] has cancel.", inm_msg->rspfn_ticket);
        inm_msg->header.inm_header.status = SYS_RESULT_CANCEL_AGAIN_ERR; //����Ʊ
        return len;
    }
    //check ���һ�ڵ��ڴ�״̬
    GIDB_ISSUE_HANDLE * i_handle = gidb_i_get_handle(game_code);
    if(i_handle == NULL) {
        log_warn("gidb_i_get_handle return NULL  gameCode[%d].", game_code);
        inm_msg->header.inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    GIDB_ISSUE_INFO last_issue_info;
    ret = i_handle->gidb_i_get_info(i_handle, inm_msg->saleLastIssue, &last_issue_info);
    if (ret != 0) {
        log_error("SYS_RESULT_FAILURE: gidb_i_get_info found error. tsn[ %s ]", inm_msg->rspfn_ticket);
        inm_msg->header.inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    if (ISSUE_STATE_ISSUE_END != last_issue_info.status) {
        if (last_issue_info.status < ISSUE_STATE_CLOSED) {
            log_debug("issue[%lld] state[%d] < ISSUE_STATE_CLOSED. tsn[%s]",
                last_issue_info.issueNumber, last_issue_info.status, inm_msg->rspfn_ticket);
            inm_msg->header.inm_header.status = SYS_RESULT_PAY_NOT_DRAW_ERR; //�ڻ�û�п���
            return len;
        } else {
            log_debug("issue[%lld] state[%d] >= ISSUE_STATE_CLOSED. tsn[%s]",
                last_issue_info.issueNumber, last_issue_info.status, inm_msg->rspfn_ticket);
            inm_msg->header.inm_header.status = SYS_RESULT_PAY_WAIT_DRAW_ERR; //�ڴεȴ��������
            return len;
        }
    }
    //��ѯ�˲�Ʊ�Ƿ��н�
    GIDB_W_TICKET_HANDLE * w_handle = gidb_w_get_handle(game_code, inm_msg->saleLastIssue, GAME_DRAW_ONE);
    if(w_handle == NULL) {
        log_error("gidb_w_get_handle return NULL  gameCode[%d] issueNumber[%lld].", game_code, inm_msg->saleLastIssue);
        inm_msg->header.inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    char win_ticket_buf[INM_MSG_BUFFER_LENGTH] = {0};
    GIDB_WIN_TICKET_REC *pWinTicket = (GIDB_WIN_TICKET_REC *)win_ticket_buf;
    ret = w_handle->gidb_w_get_ticket(w_handle, inm_msg->unique_tsn, pWinTicket);
    if (ret < 0) {
        log_error("gidb_w_get_ticket found error. rspfn_ticket[ %s ] unique_tsn[ %llu ]", inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        inm_msg->header.inm_header.status = SYS_RESULT_FAILURE;
        return len;
    } else if (ret == 1) {
        inm_msg->header.inm_header.status = SYS_RESULT_PAY_NOT_WIN_ERR;
        return len;
    }
    // �н�
    inm_msg->isBigPrize = pWinTicket->isBigWinning;
    inm_msg->isPayed = 0;
    if (pWinTicket->paid_status == PRIZE_PAYMENT_PAID) {
        inm_msg->isPayed = 1;
    }
    inm_msg->amountBeforeTax = pWinTicket->winningAmountWithTax;
    inm_msg->taxAmount = pWinTicket->taxAmount;
    inm_msg->amountAfterTax = pWinTicket->winningAmount;
    return len;
}

int term_fbs_inquiryWin(char *gltp_buf, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec)
{
    GLTP_MSG_T_INQUIRY_WIN_REQ *g_msg = (GLTP_MSG_T_INQUIRY_WIN_REQ *)gltp_buf;
    INM_MSG_T_INQUIRY_WIN *inm_msg = (INM_MSG_T_INQUIRY_WIN *)inm_buf;
    int32 cid = inm_msg->header.cid;

    inm_msg->header.inm_header.type = INM_TYPE_FBS_INQUIRY_WIN_TICKET;

    int len = sizeof(INM_MSG_T_INQUIRY_WIN);

    int rc = otldb_spcall_fbs_inquiry_ticket(inm_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("db verify Inquiry win ticket failure. agencyCode[%llu]",inm_msg->header.agencyCode);
        inm_msg->header.inm_header.status = rc;
        return len;
    }

    inm_msg->unique_tsn = tidx_rec->unique_tsn;
    memcpy(inm_msg->rspfn_ticket, g_msg->rspfn_ticket, TSN_LENGTH);
    inm_msg->gameCode = tidx_rec->gameCode;
    inm_msg->saleStartIssue = tidx_rec->issueNumber;
    inm_msg->saleLastIssue = tidx_rec->drawIssueNumber;

    inm_msg->matchCount = tidx_rec->extend[0];
    memcpy((char*)inm_msg->matchCode, (char*)&tidx_rec->extend[1], tidx_rec->extend_len - 1);


    uint8 game_code = inm_msg->gameCode;
    //�����Ϸ����
    if (!isGameBeUsed(game_code)) {
        log_debug("process_T_inquiry_win gameCode[%d] can't used.", game_code);
        inm_msg->header.inm_header.status = SYS_RESULT_GAME_DISABLE_ERR;
        return len;
    }
    //����Ƿ��ڷ���ʱ�εķ�Χ��
    if (false == gl_verifyServiceTime(game_code)) {
        log_debug("SYS_RESULT_GAME_SERVICETIME_OUT_ERR: game[%d] time out of service time.", game_code);
        inm_msg->header.inm_header.status = SYS_RESULT_GAME_SERVICETIME_OUT_ERR; //��ǰ�����ڲ�Ʊ����ʱ��
        return len;
    }

    //check �����ڴ��Ƿ񶼿��꽱,���һ��������
    GIDB_FBS_IM_HANDLE *im_handle = gidb_fbs_im_get_handle(game_code);
    GIDB_FBS_MATCH_INFO match_info = {0};
    int flagEnd = 1;
    uint32 drawTime = 0;
    time_t drawTimeTmp = 0;
    char strDrawTime[20] = {0};

    for (int i = 0; i < inm_msg->matchCount; i++)
    {
        int ret = im_handle->gidb_fbs_im_get_match(im_handle, inm_msg->matchCode[i], &match_info);
        if (ret < 0) {
            log_error("gidb_fbs_im_get_match fail.match[%u]", inm_msg->matchCode[i]);
            inm_msg->header.inm_header.status = SYS_RESULT_FAILURE;
            return len;
        }

        if (match_info.state != M_STATE_CONFIRM)  {
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
        log_debug("match[%u] tsn[%s]",inm_msg->matchCode[0], inm_msg->rspfn_ticket);
        if (inm_msg->matchCount == 1) {
            inm_msg->header.inm_header.status = SYS_RESULT_PAY_NOT_DRAW_ERR;
            return len;
        } else {
            inm_msg->header.inm_header.status = SYS_RESULT_FBS_PAY_MULTI_MATCH_ERR;//�ೡ������û�п��꽱
            return len;
        }
    }

    //��ѯ�˲�Ʊ�Ƿ��н�
    GIDB_FBS_WT_HANDLE * w_handle = gidb_fbs_wt_get_handle(game_code, inm_msg->saleLastIssue);
    if(w_handle == NULL) {
        log_error("gidb_fbs_wt_get_handle return NULL  gameCode[%d] issueNumber[%lld].", game_code, inm_msg->saleLastIssue);
        inm_msg->header.inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    char win_ticket_buf[INM_MSG_BUFFER_LENGTH] = {0};
    memset(win_ticket_buf, 0, INM_MSG_BUFFER_LENGTH);
    GIDB_FBS_WT_REC *pWinTicket = (GIDB_FBS_WT_REC *)win_ticket_buf;
    int ret = w_handle->gidb_fbs_wt_get_ticket(w_handle, inm_msg->unique_tsn, pWinTicket);
    if (ret < 0) {
        log_error("gidb_fbs_wt_get_ticket found error. rspfn_ticket[ %s ] unique_tsn[ %llu ]",
                inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        inm_msg->header.inm_header.status = SYS_RESULT_FAILURE;
        return len;
    } else if (ret == 1) {
        inm_msg->header.inm_header.status = SYS_RESULT_PAY_NOT_WIN_ERR;
        return len;
    }
    // �н�
    inm_msg->isBigPrize = pWinTicket->isBigWinning;
    inm_msg->isPayed = 0;
    if (pWinTicket->paid_status == PRIZE_PAYMENT_PAID)
        inm_msg->isPayed = 1;
    inm_msg->amountBeforeTax = pWinTicket->winningAmountWithTax;
    inm_msg->taxAmount = pWinTicket->taxAmount;
    inm_msg->amountAfterTax = pWinTicket->winningAmount;
    return len;
}

int R_TERM_inquiryWin_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf)
{
    ts_notused_args;
    GLTP_MSG_T_INQUIRY_WIN_REQ *g_msg = (GLTP_MSG_T_INQUIRY_WIN_REQ *)gltp_buf;
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER *)inm_buf;
    int32 cid = msg_header->cid;

    msg_header->inm_header.type = INM_TYPE_COMMOM_ERR;
    
    int len = sizeof(INM_MSG_T_HEADER);

    TMS_TERMINAL_RECORD* pTerm = tms_mgr()->getTermByIndex(cid);
    if (NULL == pTerm) {
        log_error("term is NULL. idx[%d]", cid);
        msg_header->inm_header.status = SYS_RESULT_T_TOKEN_EXPIRED_ERR;
        return len;
    }

    //parse rspfn (tsn)
    uint32 date = 0;
    uint64 unique_tsn = extract_tsn(g_msg->rspfn_ticket, &date);
    if (unique_tsn==0) {
        log_error("extract_tsn failed. [ %s ]", g_msg->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_TSN_ERR; //TSN����
        return len;
    }
    //�������ļ��в�ѯƱ��Ϣ
    char tidx_buf[512] = {0};
    GIDB_TICKET_IDX_REC *tidx_rec = (GIDB_TICKET_IDX_REC*)tidx_buf;
    int ret = get_ticket_idx(date, unique_tsn, tidx_rec);
    if (ret < 0) {
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    } else if (ret == 1) {
        msg_header->inm_header.status = SYS_RESULT_TICKET_NOT_FOUND_ERR;
        return len;
    }
    //��֤У����
    if (0 != memcmp(g_msg->rspfn_ticket, tidx_rec->rspfn_ticket, TSN_LENGTH-1)) {
        log_error("tsn verify fail!!!, [ %s  ---  %s ]", g_msg->rspfn_ticket, tidx_rec->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_TSN_ERR; //TSN����
        return len;
    }

    if ((tidx_rec->gameCode!=GAME_FBS) && (tidx_rec->gameCode!=GAME_FODD)) {
        //��ͨ��Ϸ
        return term_inquiryWin(gltp_buf, inm_buf, tidx_rec);
    }
    // FBS ��Ϸ
    return term_fbs_inquiryWin(gltp_buf, inm_buf, tidx_rec);
}

int S_TERM_inquiryWin_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf)
{
    ts_notused_args;

    GLTP_MSG_T_INQUIRY_WIN_RSP *g_msg = (GLTP_MSG_T_INQUIRY_WIN_RSP *)gltp_buf;
    INM_MSG_T_INQUIRY_WIN *inm_msg = (INM_MSG_T_INQUIRY_WIN *)inm_buf;
    g_msg->timeStamp = inm_msg->header.inm_header.when;

    memcpy(g_msg->rspfn_ticket, inm_msg->rspfn_ticket, TSN_LENGTH);
    g_msg->gameCode = inm_msg->gameCode;
    g_msg->isBigPrize = inm_msg->isBigPrize;
    g_msg->amountBeforeTax = inm_msg->amountBeforeTax;
    g_msg->amountAfterTax = inm_msg->amountAfterTax;
    g_msg->taxAmount = inm_msg->taxAmount;
    g_msg->isPayed = inm_msg->isPayed;

    return sizeof(GLTP_MSG_T_INQUIRY_WIN_RSP);
}



int term_payticket(char *gltp_buf, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec, TMS_TERMINAL_RECORD* pTerm)
{
    GLTP_MSG_T_PAY_TICKET_REQ *g_msg = (GLTP_MSG_T_PAY_TICKET_REQ *)gltp_buf;
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER *)inm_buf;
    INM_MSG_T_PAY_TICKET *inm_msg = (INM_MSG_T_PAY_TICKET *)inm_buf;
    int32 cid = inm_msg->header.cid;

    msg_header->inm_header.type = INM_TYPE_T_PAY_TICKET;

    int len = sizeof(INM_MSG_T_PAY_TICKET);

    inm_msg->unique_tsn = tidx_rec->unique_tsn;
    memcpy(inm_msg->rspfn_ticket, g_msg->rspfn_ticket, TSN_LENGTH);
    inm_msg->gameCode = tidx_rec->gameCode;
    inm_msg->saleStartIssue = tidx_rec->issueNumber;
    inm_msg->saleLastIssue = tidx_rec->drawIssueNumber;
    strncpy(inm_msg->loyaltyNum, g_msg->loyaltyNum, LOYALTY_CARD_LENGTH);
    inm_msg->loyaltyNum[LOYALTY_CARD_LENGTH] = 0;
    inm_msg->identityType = 0;
    strncpy(inm_msg->identityNumber, g_msg->identityNumber, IDENTITY_CARD_LENGTH);
    inm_msg->identityNumber[IDENTITY_CARD_LENGTH] = 0;
    inm_msg->name[0] = 0;

    uint8 game_code = inm_msg->gameCode;
    //�����Ϸ����
    if (!isGameBeUsed(game_code)) {
        log_debug("SYS_RESULT_GAME_DISABLE_ERR: gameCode[%d] can't used.", game_code);
        msg_header->inm_header.status = SYS_RESULT_GAME_DISABLE_ERR;
        return len;
    }
    //�����Ϸ�ɶҽ�
    TRANSCTRL_PARAM *transctrlParam = gl_getTransctrlParam(game_code);
    if (!transctrlParam->payFlag) {
        log_debug("SYS_RESULT_PAY_DISABLE_ERR: game[%d] payFlag not be used.", game_code);
        msg_header->inm_header.status = SYS_RESULT_PAY_DISABLE_ERR; //����Ϸ���ɶҽ�
        return len;
    }
    //����Ƿ��ڷ���ʱ�εķ�Χ��
    if (false == gl_verifyServiceTime(game_code))
    {
        log_debug("SYS_RESULT_GAME_SERVICETIME_OUT_ERR: game[%d] time out of service time.", game_code);
        msg_header->inm_header.status = SYS_RESULT_GAME_SERVICETIME_OUT_ERR; //��ǰ�����ڲ�Ʊ����ʱ��
        return len;
    }

    GIDB_T_TICKET_HANDLE * t_handle = gidb_t_get_handle(game_code, inm_msg->saleStartIssue);
    if (t_handle == NULL) {
        log_warn("SYS_RESULT_FAILURE: gidb_t_get_handle return NULL. gameCode[%d] issueNumber[%lld].",
            game_code, inm_msg->saleStartIssue);
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }

    char sale_ticket_buf[INM_MSG_BUFFER_LENGTH] = { 0 };
    memset(sale_ticket_buf, 0, INM_MSG_BUFFER_LENGTH);
    GIDB_SALE_TICKET_REC *pSaleTicket = (GIDB_SALE_TICKET_REC *)sale_ticket_buf;
    int ret = t_handle->gidb_t_get_ticket(t_handle, inm_msg->unique_tsn, pSaleTicket);
    if (ret < 0) {
        log_debug("SYS_RESULT_FAILURE: gidb_get_sell_ticket found error. rspfn_ticket[ %s ] unique_tsn[ %llu ]",
                inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    else if (ret == 1) {
        log_debug("SYS_RESULT_PAY_NOT_FOUND_ERR: gidb_get_sell_ticket return NULL. tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_TICKET_NOT_FOUND_ERR; //û���ҵ����Ų�Ʊ
        return len;
    }

    if (pSaleTicket->isCancel)
    {
        log_debug("TSN[ %s ] has cancel.", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_CANCEL_AGAIN_ERR; //����Ʊ
        return len;
    }

    //check ���һ�ڵ��ڴ�״̬
    GIDB_ISSUE_HANDLE * i_handle = gidb_i_get_handle(game_code);
    if(i_handle == NULL) {
        log_error("SYS_RESULT_FAILURE: gidb_i_get_handle return NULL  gameCode[%d].", game_code);
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    GIDB_ISSUE_INFO last_issue_info;
    ret = i_handle->gidb_i_get_info(i_handle, inm_msg->saleLastIssue, &last_issue_info);
    if (ret != 0) {
        log_error("SYS_RESULT_FAILURE: gidb_i_get_info found error. tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    if (ISSUE_STATE_ISSUE_END != last_issue_info.status) {
        if (last_issue_info.status < ISSUE_STATE_CLOSED) {
            log_debug("issue[%lld] state[%d] < ISSUE_STATE_CLOSED. tsn[%s]",
                last_issue_info.issueNumber, last_issue_info.status, inm_msg->rspfn_ticket);
            msg_header->inm_header.status = SYS_RESULT_PAY_NOT_DRAW_ERR; //�ڻ�û�п���
            return len;
        } else {
            log_debug("issue[%lld] state[%d] >= ISSUE_STATE_CLOSED. tsn[%s]",
                last_issue_info.issueNumber, last_issue_info.status, inm_msg->rspfn_ticket);
            msg_header->inm_header.status = SYS_RESULT_PAY_WAIT_DRAW_ERR; //�ڴεȴ��������
            return len;
        }
    }
    //���ҽ���
    if (sysdb_getSessionDate() > last_issue_info.payEndDay) {
        log_debug("issue[%lld] state[%d] > payEndDay. tsn[%s]",
            last_issue_info.issueNumber, last_issue_info.status, inm_msg->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_PAY_DAYEND_ERR;
        return len;
    }
    //����ڴ����
    ISSUE_INFO* curr_issue_info = game_plugins_handle[game_code].get_currIssue(); //����Ϸ�����ȡ��Ϸ��ǰ�ڴ�
    if (curr_issue_info == NULL) {
        log_info("Get current issue failure. game[%d].", game_code);
        msg_header->inm_header.status = SYS_RESULT_SELL_NOISSUE_ERR;
        return len;
    }
    inm_msg->issueNumber_pay = curr_issue_info->issueNumber;

    //��ѯ�˲�Ʊ�Ƿ��н�
    GIDB_W_TICKET_HANDLE * w_handle = gidb_w_get_handle(game_code, inm_msg->saleLastIssue, GAME_DRAW_ONE);
    if(w_handle == NULL) {
        log_error("SYS_RESULT_FAILURE: gidb_w_get_handle return NULL  gameCode[%d] issueNumber[%lld].", game_code, inm_msg->saleLastIssue);
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    char win_ticket_buf[INM_MSG_BUFFER_LENGTH] = {0};
    GIDB_WIN_TICKET_REC *pWinTicket = (GIDB_WIN_TICKET_REC *)win_ticket_buf;
    ret = w_handle->gidb_w_get_ticket(w_handle, inm_msg->unique_tsn, pWinTicket);
    if (ret < 0) {
        log_error("SYS_RESULT_FAILURE: gidb_w_get_ticket found error. rspfn_ticket[ %s ] unique_tsn[ %llu ]",
            inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    } else if (ret == 1) {
        log_debug("SYS_RESULT_PAY_NOT_FOUND_ERR: gidb_w_get_ticket return NULL. rspfn_ticket[ %s ] unique_tsn[ %llu ]",
            inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        msg_header->inm_header.status = SYS_RESULT_PAY_NOT_WIN_ERR; //��Ʊδ�н�
        return len;
    }
    //����Ƿ�����ѵƱ (��ѵƱ�ҽ�ֻ�����ݿ����ͨ�ü���)
    inm_msg->isTrain = pWinTicket->isTrain;
    if (1 == inm_msg->isTrain)
        inm_msg->header.reqParam = 0x8000;
    // �н�
    if (pWinTicket->paid_status == PRIZE_PAYMENT_NONE) {
        log_debug("SYS_RESULT_PAY_MULTI_ISSUE_ERR: gl_pay multi issue ticket. tsn[ %s ]", inm_msg->rspfn_ticket);
        //����Ʊδ���   *************��̫�����ߵ����ǰ���Ѿ�У��������ڴ����ڽ�*********
        msg_header->inm_header.status = SYS_RESULT_PAY_MULTI_ISSUE_ERR;
        return len;
    } else if (pWinTicket->paid_status == PRIZE_PAYMENT_PAID) {
        log_debug("SYS_RESULT_PAY_PAID_ERR: gl_pay again. tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_PAY_PAID_ERR; //�Ѷҽ�
        return len;
    }
    //�ж���Ϸ�ҽ������޶�
    if (pWinTicket->winningAmountWithTax >= transctrlParam->gamePayLimited) {
        log_debug("SYS_RESULT_PAY_GAMELIMIT_ERR: gamePayLimited no pass. tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_PAY_GAMELIMIT_ERR; //������Ϸ�ҽ��������
        return len;
    }
    //�ж�����Ա�ҽ��������
    /*
    if ( (pWinTicket->winningAmountWithTax > transctrlParam->commonTellerPayLimited) && (0 == inm_msg->isTrain) ) {
        log_debug("SYS_RESULT_TELLER_PAY_LIMIT_ERR: tsn[ %s ] win_amount[ %lld ]",
                inm_msg->rspfn_ticket, pWinTicket->winningAmountWithTax);
        msg_header->inm_header.status = SYS_RESULT_TELLER_PAY_LIMIT_ERR; //����Աû�д�Ʊ�Ķҽ�Ȩ��
        return len;
    }
    */
    strcpy(inm_msg->reqfn_ticket, pWinTicket->reqfn_ticket);
    inm_msg->issueCount = pWinTicket->issueCount;
    inm_msg->saleStartIssueSerial = pWinTicket->saleStartIssueSerial;
    inm_msg->saleLastIssueSerial = pWinTicket->saleStartIssueSerial + pWinTicket->issueCount - 1;
    inm_msg->ticketAmount = pWinTicket->ticketAmount;

    inm_msg->isBigWinning = pWinTicket->isBigWinning;
    inm_msg->winningAmountWithTax = pWinTicket->winningAmountWithTax;
    inm_msg->taxAmount = pWinTicket->taxAmount;
    inm_msg->winningAmount = pWinTicket->winningAmount;
    inm_msg->winningCount = pWinTicket->winningCount;
    inm_msg->hd_winning = pWinTicket->hd_winning;
    inm_msg->hd_count = pWinTicket->hd_count;
    inm_msg->ld_winning = pWinTicket->ld_winning;
    inm_msg->ld_count = pWinTicket->ld_count;
    inm_msg->saleAgencyCode = pWinTicket->agencyCode;

    generate_reqfn(2, pTerm->termCode, tms_mgr()->getSequence(), inm_msg->reqfn_ticket_pay); //����������ˮ��

    int rc = otldb_spcall_pay(inm_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("pay ticket failure.");
        inm_msg->header.inm_header.status = rc;
        return len;
    }

    pTerm->flowNumber = inm_msg->flowNumber;
    pTerm->last_crc = *(uint16 *)&gltp_buf[g_msg->header.length-2]; //�������һ�ν��׵�crc

    //���ҽ��澯
    if ((transctrlParam->payLimit!=0) && (inm_msg->winningAmountWithTax >= transctrlParam->payLimit)) {
        notify_agency_pay_bigAmount(inm_msg->header.agencyCode, game_code,
                inm_msg->issueNumber_pay, inm_msg->winningAmountWithTax, inm_msg->availableCredit);
    }
    return len;
}

int term_fbs_payticket(char *gltp_buf, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec, TMS_TERMINAL_RECORD* pTerm)
{
    GLTP_MSG_T_PAY_TICKET_REQ *g_msg = (GLTP_MSG_T_PAY_TICKET_REQ *)gltp_buf;
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER *)inm_buf;
    INM_MSG_FBS_PAY_TICKET *inm_msg = (INM_MSG_FBS_PAY_TICKET *)inm_buf;
    int32 cid = inm_msg->header.cid;

    msg_header->inm_header.type = INM_TYPE_FBS_PAY_TICKET;

    int len = sizeof(INM_MSG_FBS_PAY_TICKET);

    inm_msg->unique_tsn = tidx_rec->unique_tsn;
    memcpy(inm_msg->rspfn_ticket, g_msg->rspfn_ticket, TSN_LENGTH);
    inm_msg->gameCode = tidx_rec->gameCode;
    inm_msg->issueNumber = tidx_rec->issueNumber;
    strncpy(inm_msg->loyaltyNum, g_msg->loyaltyNum, LOYALTY_CARD_LENGTH);
    inm_msg->loyaltyNum[LOYALTY_CARD_LENGTH] = 0;
    inm_msg->identityType = 0;
    strncpy(inm_msg->identityNumber, g_msg->identityNumber, IDENTITY_CARD_LENGTH);
    inm_msg->identityNumber[IDENTITY_CARD_LENGTH] = 0;
    inm_msg->name[0] = 0;
    inm_msg->matchCount = tidx_rec->extend[0];
    memcpy((char*)inm_msg->matchCode, (char*)&tidx_rec->extend[1], tidx_rec->extend_len - 1);

    uint8 game_code = inm_msg->gameCode;
    //�����Ϸ����
    if (!isGameBeUsed(game_code)) {
        log_debug("SYS_RESULT_GAME_DISABLE_ERR: gameCode[%d] can't used.", game_code);
        msg_header->inm_header.status = SYS_RESULT_GAME_DISABLE_ERR;
        return len;
    }
    //�����Ϸ�ɶҽ�
    TRANSCTRL_PARAM *transctrlParam = gl_getTransctrlParam(game_code);
    if (!transctrlParam->payFlag) {
        log_debug("SYS_RESULT_PAY_DISABLE_ERR: game[%d] payFlag not be used.", game_code);
        msg_header->inm_header.status = SYS_RESULT_PAY_DISABLE_ERR; //����Ϸ���ɶҽ�
        return len;
    }
    //����Ƿ��ڷ���ʱ�εķ�Χ��
    if (false == gl_verifyServiceTime(game_code))
    {
        log_debug("SYS_RESULT_GAME_SERVICETIME_OUT_ERR: game[%d] time out of service time.", game_code);
        msg_header->inm_header.status = SYS_RESULT_GAME_SERVICETIME_OUT_ERR; //��ǰ�����ڲ�Ʊ����ʱ��
        return len;
    }

    //check �����ڴ��Ƿ񶼿��꽱,���һ��������
    GIDB_FBS_IM_HANDLE *im_handle = gidb_fbs_im_get_handle(game_code);
    GIDB_FBS_MATCH_INFO match_info = {0};
    int flagEnd = 1;
    uint32 drawTime = 0;
    time_t drawTimeTmp = 0;
    char strDrawTime[20] = {0};

    //k-debug
    log_debug("inm_msg->matchCount [%d]", inm_msg->matchCount);

    for (int i = 0; i < inm_msg->matchCount; i++)
    {
        memset(&match_info, 0, sizeof(GIDB_FBS_MATCH_INFO));
        int ret = im_handle->gidb_fbs_im_get_match(im_handle, inm_msg->matchCode[i], &match_info);

        //k-debug
        log_debug("inm_msg->matchCode [%u],state[%d],ret[%d]", inm_msg->matchCode[i], match_info.state, ret);

        if (ret < 0) {
            log_error("gidb_fbs_im_get_match fail.match[%u]", inm_msg->matchCode[i]);
            msg_header->inm_header.status = SYS_RESULT_FAILURE;
            return len;
        }

        if (match_info.state != M_STATE_CONFIRM)  {
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
        log_debug("issue[%lld] tsn[%s]",inm_msg->issueNumber, inm_msg->rspfn_ticket);
        if (inm_msg->matchCount == 1) {
            msg_header->inm_header.status = SYS_RESULT_PAY_WAIT_DRAW_ERR;
            return len;
        } else {
            msg_header->inm_header.status = SYS_RESULT_FBS_PAY_MULTI_MATCH_ERR;
            return len;
        }
    }

    //��ѯ�˲�Ʊ�Ƿ��н�
    GIDB_FBS_WT_HANDLE *w_handle = gidb_fbs_wt_get_handle(game_code, inm_msg->issueNumber);
    if(w_handle == NULL) {
        log_error("SYS_RESULT_FAILURE: gidb_fbs_wt_get_handle return NULL  gameCode[%d] issueNumber[%u].",
            game_code, inm_msg->issueNumber);
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    static char win_ticket_buf[INM_MSG_BUFFER_LENGTH] = {0};
    GIDB_FBS_WT_REC *pWinTicket = (GIDB_FBS_WT_REC *)win_ticket_buf;
    int ret = w_handle->gidb_fbs_wt_get_ticket(w_handle, inm_msg->unique_tsn, pWinTicket);
    if (ret < 0) {
        log_error("SYS_RESULT_FAILURE: gidb_fbs_wt_get_ticket found error. rspfn_ticket[ %s ] unique_tsn[ %llu ]",
                inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    } else if (ret == 1) {
        log_debug("SYS_RESULT_PAY_NOT_FOUND_ERR: gidb_w_get_ticket return NULL. rspfn_ticket[ %s ] unique_tsn[ %llu ]",
                inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        msg_header->inm_header.status = SYS_RESULT_PAY_NOT_WIN_ERR; //��Ʊδ�н�
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
        log_error("gidb_fbs_st_get_field_blob(%d, %u, FBS_ST_GAME_PARAMBLOB_KEY) failure.",game_code, inm_msg->issueNumber);
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }

    uint32 payEndDay = 0;
    //payEndDay ADD days
    int d = c_days(drawTime);
    d += game_param.payEndDay;
    payEndDay = c_date(d);
    if (sysdb_getSessionDate() > payEndDay) {
        log_debug("expired, issue[%u] payEndDay[%u]. tsn[%s]", inm_msg->issueNumber, payEndDay, inm_msg->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_PAY_DAYEND_ERR;
        return len;
    }
    //����Ƿ�����ѵƱ
    if(inm_msg->header.inm_header.gltp_from == TICKET_FROM_TERM) {
        inm_msg->isTrain = pWinTicket->is_train;
        if (1 == inm_msg->isTrain)
            inm_msg->header.reqParam = 0x8000;
    }
    // �н�
    if (pWinTicket->paid_status == PRIZE_PAYMENT_NONE) {
        log_debug("SYS_RESULT_PAY_MULTI_ISSUE_ERR: gl_pay multi issue ticket. tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_PAY_MULTI_ISSUE_ERR; //����Ʊδ���   *************��̫�����ߵ����ǰ���Ѿ�У��������ڴ����ڽ�*********
        return len;
    } else if (pWinTicket->paid_status == PRIZE_PAYMENT_PAID) {
        log_debug("SYS_RESULT_PAY_PAID_ERR: gl_pay again. tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_PAY_PAID_ERR; //�Ѷҽ�
        return len;
    }
    //�ж���Ϸ�ҽ������޶�
    if (pWinTicket->winningAmountWithTax >= transctrlParam->gamePayLimited) {
        log_debug("SYS_RESULT_PAY_GAMELIMIT_ERR: gamePayLimited no pass. tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_PAY_GAMELIMIT_ERR; //������Ϸ�ҽ��������
        return len;
    }
    //�ж�����Ա�ҽ��������
    /*
    if(pInmMsg->header.inm_header.gltp_from == TICKET_FROM_TERM)
    {
        if ( (pWinTicket->winningAmountWithTax > transctrlParam->commonTellerPayLimited) &&
            (0 == pInmMsg->isTrain) )
        {
            log_debug("SYS_RESULT_TELLER_PAY_LIMIT_ERR: tsn[ %s ] win_amount[ %lld ]",
                pInmMsg->rspfn_ticket, pWinTicket->winningAmountWithTax);
            return SYS_RESULT_TELLER_PAY_LIMIT_ERR; //����Աû�д�Ʊ�Ķҽ�Ȩ��
        }
    }
    */

    strcpy(inm_msg->reqfn_ticket, pWinTicket->reqfn_ticket);
    strcpy(inm_msg->rspfn_ticket, pWinTicket->rspfn_ticket);
    inm_msg->ticketAmount = pWinTicket->total_amount;
    inm_msg->isBigWinning = pWinTicket->isBigWinning;
    inm_msg->winningAmountWithTax = pWinTicket->winningAmountWithTax;
    inm_msg->taxAmount = pWinTicket->taxAmount;
    inm_msg->winningAmount = pWinTicket->winningAmount;
    inm_msg->winningCount = pWinTicket->winningCount;
    inm_msg->issueNumber_pay = sysdb_getSessionDate();
    inm_msg->saleAgencyCode = pWinTicket->agency_code;

    generate_reqfn(2, pTerm->termCode, tms_mgr()->getSequence(), inm_msg->reqfn_ticket_pay); //����������ˮ��

    int rc = otldb_spcall_fbs_pay(inm_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("pay fbs ticket failure.");
        inm_msg->header.inm_header.status = rc;
        return len;
    }

    pTerm->flowNumber = inm_msg->flowNumber;
    pTerm->last_crc = *(uint16 *)&gltp_buf[g_msg->header.length-2]; //�������һ�ν��׵�crc

    //���ҽ��澯
    if ((transctrlParam->payLimit!=0) && (inm_msg->winningAmountWithTax >= transctrlParam->payLimit)) {
        notify_agency_pay_bigAmount(inm_msg->header.agencyCode, game_code,
                inm_msg->issueNumber_pay, inm_msg->winningAmountWithTax, inm_msg->availableCredit);
    }
    return len;
}

int R_TERM_payticket_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf)
{
    ts_notused_args;
    GLTP_MSG_T_PAY_TICKET_REQ *g_msg = (GLTP_MSG_T_PAY_TICKET_REQ *)gltp_buf;
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER *)inm_buf;
    INM_MSG_T_PAY_TICKET *inm_msg = (INM_MSG_T_PAY_TICKET *)inm_buf;
    int32 cid = inm_msg->header.cid;

    msg_header->inm_header.type = INM_TYPE_COMMOM_ERR;

    int len = sizeof(INM_MSG_T_HEADER);

    TMS_TERMINAL_RECORD* pTerm = tms_mgr()->getTermByIndex(cid);
    if (NULL == pTerm) {
        log_error("term is NULL. idx[%d]", cid);
        msg_header->inm_header.status = SYS_RESULT_T_TOKEN_EXPIRED_ERR;
        return len;
    }

    //parse rspfn (tsn)
    uint32 date = 0;
    uint64 unique_tsn = extract_tsn(g_msg->rspfn_ticket, &date);
    if (unique_tsn==0) {
        log_error("extract_tsn failed. [ %s ]", g_msg->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_TSN_ERR; //TSN����
        return len;
    }
    //�������ļ��в�ѯƱ��Ϣ
    char tidx_buf[512] = {0};
    GIDB_TICKET_IDX_REC *tidx_rec = (GIDB_TICKET_IDX_REC*)tidx_buf;
    int ret = get_ticket_idx(date, unique_tsn, tidx_rec);
    if (ret < 0) {
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
		return len;
    } else if (ret == 1) {
        msg_header->inm_header.status = SYS_RESULT_TICKET_NOT_FOUND_ERR;
        return len;
    }

    //��֤У����
    if (0 != memcmp(g_msg->rspfn_ticket, tidx_rec->rspfn_ticket, TSN_LENGTH-1)) {
        log_error("tsn verify fail!!!, [ %s  ---  %s ]", g_msg->rspfn_ticket, tidx_rec->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_TSN_ERR; //TSN����
        return len;
    }

    if ((tidx_rec->gameCode!=GAME_FBS) && (tidx_rec->gameCode!=GAME_FODD)) {
        //��ͨ��Ϸ
        return term_payticket(gltp_buf, inm_buf, tidx_rec, pTerm);
    }
    // FBS ��Ϸ
    return term_fbs_payticket(gltp_buf, inm_buf, tidx_rec, pTerm);
}

int S_TERM_payticket_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf)
{
    ts_notused_args;
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER *)inm_buf;
    GLTP_MSG_T_PAY_TICKET_RSP *g_msg = (GLTP_MSG_T_PAY_TICKET_RSP *)gltp_buf;
    g_msg->timeStamp = msg_header->inm_header.when;
    g_msg->transTimeStamp = msg_header->inm_header.when;


    if (msg_header->inm_header.type == INM_TYPE_T_PAY_TICKET) {
        INM_MSG_T_PAY_TICKET *inm_msg = (INM_MSG_T_PAY_TICKET *)inm_buf;
        memcpy(g_msg->rspfn_ticket_pay, inm_msg->rspfn_ticket_pay, TSN_LENGTH);
        memcpy(g_msg->rspfn_ticket, inm_msg->rspfn_ticket, TSN_LENGTH);
        g_msg->availableCredit = inm_msg->availableCredit;
        g_msg->gameCode = inm_msg->gameCode;
        g_msg->flowNumber = inm_msg->flowNumber;
        g_msg->winningAmountWithTax = inm_msg->winningAmountWithTax;
        g_msg->taxAmount = inm_msg->taxAmount;
        g_msg->winningAmount = inm_msg->winningAmount;
    } else if (msg_header->inm_header.type == INM_TYPE_FBS_PAY_TICKET) {
        INM_MSG_FBS_PAY_TICKET *inm_msg = (INM_MSG_FBS_PAY_TICKET *)inm_buf;
        memcpy(g_msg->rspfn_ticket_pay, inm_msg->rspfn_ticket_pay, TSN_LENGTH);
        memcpy(g_msg->rspfn_ticket, inm_msg->rspfn_ticket, TSN_LENGTH);
        g_msg->availableCredit = inm_msg->availableCredit;
        g_msg->gameCode = inm_msg->gameCode;
        g_msg->flowNumber = inm_msg->flowNumber;
        g_msg->winningAmountWithTax = inm_msg->winningAmountWithTax;
        g_msg->taxAmount = inm_msg->taxAmount;
        g_msg->winningAmount = inm_msg->winningAmount;

        //k-debug
        log_debug("tsn[%s][%s]", inm_msg->rspfn_ticket, inm_msg->rspfn_ticket_pay);
    }

    return sizeof(GLTP_MSG_T_PAY_TICKET_RSP);
}


int term_cancelticket(char *gltp_buf, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec, TMS_TERMINAL_RECORD* pTerm)
{
    GLTP_MSG_T_CANCEL_TICKET_REQ *g_msg = (GLTP_MSG_T_CANCEL_TICKET_REQ *)gltp_buf;
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER *)inm_buf;
    INM_MSG_T_CANCEL_TICKET *inm_msg = (INM_MSG_T_CANCEL_TICKET *)inm_buf;
    int32 cid = msg_header->cid;

    msg_header->inm_header.type = INM_TYPE_T_CANCEL_TICKET;

    int len = sizeof(INM_MSG_T_CANCEL_TICKET);

    inm_msg->unique_tsn = tidx_rec->unique_tsn;
    memcpy(inm_msg->rspfn_ticket, g_msg->rspfn_ticket, TSN_LENGTH);
    inm_msg->ticket.gameCode = tidx_rec->gameCode;
    inm_msg->ticket.issue = tidx_rec->issueNumber;
    memcpy(inm_msg->loyaltyNum, g_msg->loyaltyNum, LOYALTY_CARD_LENGTH);
    inm_msg->loyaltyNum[LOYALTY_CARD_LENGTH] = 0;

    uint8 game_code = tidx_rec->gameCode;
    //�����Ϸ����
    if (!isGameBeUsed(game_code)) {
        log_debug("SYS_RESULT_GAME_DISABLE_ERR: gameCode[%d] can't used.", game_code);
        msg_header->inm_header.status = SYS_RESULT_GAME_DISABLE_ERR;
        return len;
    }
    TRANSCTRL_PARAM *transctrlParam = gl_getTransctrlParam(game_code);
    if (!transctrlParam->cancelFlag) {
        log_debug("SYS_RESULT_PAY_DISABLE_ERR: game[%d] cancelFlag not be used.", game_code);
        msg_header->inm_header.status = SYS_RESULT_CANCEL_DISABLE_ERR; //����Ϸ������Ʊ
        return len;
    }
    //����Ƿ��ڷ���ʱ�εķ�Χ��
    if (false == gl_verifyServiceTime(game_code)) {
        log_debug("SYS_RESULT_GAME_SERVICETIME_OUT_ERR: game[%d] time out of service time.", game_code);
        msg_header->inm_header.status = SYS_RESULT_GAME_SERVICETIME_OUT_ERR; //��ǰ�����ڲ�Ʊ����ʱ��
        return len;
    }
    //�ԱȲ�Ʊ��ǰ�ڴκ������ڴ�
    ISSUE_INFO* issue_info = game_plugins_handle[game_code].get_currIssue(); //����Ϸ�����ȡ��Ϸ��ǰ�ڴ�
    if (issue_info == NULL) {
        log_info("Get current issue failure. tsn[%s] game[%d] issueSeq[%d]", inm_msg->rspfn_ticket, game_code, inm_msg->ticket.issueSeq);
        msg_header->inm_header.status = SYS_RESULT_CANCEL_NOT_ACCEPT_ERR; //û�е�ǰ�ڣ���������Ʊ
        return len;
    }
    if (inm_msg->ticket.issue != issue_info->issueNumber) {
        log_info("Current issue doesn't equal ticket sale issue. tsn[%s] game[%d] issueNumber[%lld]",
            inm_msg->rspfn_ticket, game_code, issue_info->issueNumber);
        msg_header->inm_header.status = SYS_RESULT_CANCEL_NOT_ACCEPT_ERR; //��ǰ�ڲ��������ڣ���������Ʊ
        return len;
    }
    if (issue_info->curState > ISSUE_STATE_CLOSING) {
        log_info("SYS_RESULT_CANCEL_NOT_ACCEPT_ERR: current issue has already closed. tsn[%s] game[%d] issueNumber[%lld]",
            inm_msg->rspfn_ticket, game_code, issue_info->issueNumber);
        msg_header->inm_header.status = SYS_RESULT_CANCEL_NOT_ACCEPT_ERR; //��ǰ�ڴ��ѹر�
        return len;
    }
    inm_msg->ticket.issueSeq = issue_info->serialNumber;
    //��ѯ����Ʊ
    GIDB_T_TICKET_HANDLE * t_handle = gidb_t_get_handle(game_code, inm_msg->ticket.issue);
    if(t_handle == NULL) {
        log_warn("SYS_RESULT_FAILURE: gidb_t_get_handle return NULL. gameCode[%d] issueNumber[%lld].",
            game_code, inm_msg->ticket.issue);
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    char sale_ticket_buf[INM_MSG_BUFFER_LENGTH] = {0};
    memset(sale_ticket_buf, 0, INM_MSG_BUFFER_LENGTH);
    GIDB_SALE_TICKET_REC *pSaleTicket = (GIDB_SALE_TICKET_REC *)sale_ticket_buf;
    int ret = t_handle->gidb_t_get_ticket(t_handle, inm_msg->unique_tsn, pSaleTicket);
    if (ret < 0) {
        log_debug("SYS_RESULT_FAILURE: gidb_get_sell_ticket found error. rspfn_ticket[ %s ] unique_tsn[ %llu ]",
                inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    } else if (ret == 1) {
        log_debug("SYS_RESULT_PAY_NOT_FOUND_ERR: gidb_get_sell_ticket return NULL. tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_TICKET_NOT_FOUND_ERR; //û���ҵ����Ų�Ʊ
        return len;
    }
    strcpy(inm_msg->reqfn_ticket, pSaleTicket->reqfn_ticket);
    //����Ƿ�����ѵƱ
    if (1 == inm_msg->ticket.isTrain)
        inm_msg->header.reqParam = 0x8000;
    if (pSaleTicket->issueNumber != issue_info->issueNumber) {
        log_info("Current issue doesn't equal ticket sale issue. tsn[%s] game[%d] issueNumber[%lld]",
            inm_msg->rspfn_ticket, game_code, issue_info->issueNumber);
        msg_header->inm_header.status = SYS_RESULT_CANCEL_NOT_ACCEPT_ERR; //��ǰ�ڲ��������ڣ���������Ʊ
        return len;
    }
    //�ж��Ƿ�����Ʊ
    if (pSaleTicket->isCancel) {
        log_debug("TSN[ %s ] has cancel.", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_CANCEL_AGAIN_ERR; //����Ʊ
        return len;
    }
    //�ж�����Ա��Ʊ�������
    /*
    if ((inm_msg->ticket.amount > transctrlParam->commonTellerCancelLimited) && (0 == inm_msg->ticket.isTrain)) {
        log_debug("SYS_RESULT_CANCEL_MONEYLIMIT_ERR: tsn[ %s ] cancel_amount[ %lld ]",
            inm_msg->rspfn_ticket, inm_msg->ticket.amount);
        msg_header->inm_header.status = SYS_RESULT_CANCEL_MONEYLIMIT_ERR; //������ͨ����Ա��Ʊ�޶�
        return len;
    }
    */
    //�ж��Ƿ��ǳ�����Ʊʱ��
    time_type currentTime = get_now();
    time_type saleTime = pSaleTicket->timeStamp;
    if (saleTime + transctrlParam->cancelTime < currentTime) {
        log_info("SYS_RESULT_CANCEL_TIME_END_ERR: gl_cancel max cancel Time! tsn[%s] saleTime[%d] currentTime[%d]",
            inm_msg->rspfn_ticket, (int32)saleTime, (int32)currentTime);
        msg_header->inm_header.status = SYS_RESULT_CANCEL_TIME_END_ERR;
        return len;
    }
    //�ж�agency��Ʊ��Χ
    inm_msg->saleAgencyCode = pSaleTicket->agencyCode;
    if (inm_msg->saleAgencyCode != inm_msg->header.agencyCode) {
        log_info("SYS_RESULT_T_CANCEL_AGENCY_ERR: gl_cancel agencyCode not match!");
        msg_header->inm_header.status = SYS_RESULT_T_CANCEL_AGENCY_ERR; //��ǰҪ����Ʊ������վ����Ʊ������վһ��
        return len;
    }

    generate_reqfn(3, pTerm->termCode, tms_mgr()->getSequence(), inm_msg->reqfn_ticket_cancel); //����������ˮ��

    int rc = otldb_spcall_cancel(inm_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("cancel ticket failure.");
        inm_msg->header.inm_header.status = rc;
        return len;
    }
    memcpy((char *)&inm_msg->ticket, (char *)&pSaleTicket->ticket, pSaleTicket->ticket.length);

    //���·��տ���
    if ((isGameBeRiskControl(game_code)) && (NULL!=game_plugins_handle[game_code].cancel_rk_rollback)) {
        pthread_mutex_lock(&risk_mutex[game_code]);
        game_plugins_handle[game_code].cancel_rk_rollback(&inm_msg->ticket);
        pthread_mutex_unlock(&risk_mutex[game_code]);
    }

    pTerm->flowNumber = inm_msg->flowNumber;
    pTerm->last_crc = *(uint16 *)&gltp_buf[g_msg->header.length-2]; //�������һ�ν��׵�crc

    //��Ʊ���澯
    if ((transctrlParam->cancelLimit != 0) && (pSaleTicket->ticket.amount >= transctrlParam->cancelLimit)) {
        notify_agency_cancel_bigAmount(inm_msg->header.agencyCode, game_code,
                tidx_rec->issueNumber, pSaleTicket->ticket.amount, inm_msg->availableCredit);
    }
    return  (offsetof(INM_MSG_T_CANCEL_TICKET, ticket) + inm_msg->ticket.length);
}

int term_fbs_cancelticket(char *gltp_buf, char *inm_buf, GIDB_TICKET_IDX_REC *tidx_rec, TMS_TERMINAL_RECORD* pTerm)
{
    GLTP_MSG_T_CANCEL_TICKET_REQ *g_msg = (GLTP_MSG_T_CANCEL_TICKET_REQ *)gltp_buf;
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER *)inm_buf;
    INM_MSG_FBS_CANCEL_TICKET *inm_msg = (INM_MSG_FBS_CANCEL_TICKET *)inm_buf;
    FBS_TICKET *fbs_ticket = &inm_msg->ticket;
    int32 cid = msg_header->cid;

    msg_header->inm_header.type = INM_TYPE_FBS_CANCEL_TICKET;

    int len = sizeof(INM_MSG_FBS_CANCEL_TICKET);

    inm_msg->unique_tsn = tidx_rec->unique_tsn;
    memcpy(inm_msg->rspfn_ticket, g_msg->rspfn_ticket, TSN_LENGTH);
    inm_msg->ticket.game_code = tidx_rec->gameCode;
    inm_msg->ticket.issue_number = tidx_rec->issueNumber;
    memcpy(inm_msg->loyaltyNum, g_msg->loyaltyNum, LOYALTY_CARD_LENGTH);
    inm_msg->loyaltyNum[LOYALTY_CARD_LENGTH] = 0;
    inm_msg->matchCount = tidx_rec->extend[0];
    memcpy((char*)inm_msg->matchCode, (char*)&tidx_rec->extend[1], tidx_rec->extend_len - 1);


    uint8 game_code = tidx_rec->gameCode;
    //�����Ϸ����
    if (!isGameBeUsed(game_code)) {
        log_debug("SYS_RESULT_GAME_DISABLE_ERR: gameCode[%d] can't used.", game_code);
        msg_header->inm_header.status = SYS_RESULT_GAME_DISABLE_ERR;
        return len;
    }
    TRANSCTRL_PARAM *transctrlParam = gl_getTransctrlParam(game_code);
    if (!transctrlParam->cancelFlag) {
        log_debug("SYS_RESULT_PAY_DISABLE_ERR: game[%d] cancelFlag not be used.", game_code);
        msg_header->inm_header.status = SYS_RESULT_CANCEL_DISABLE_ERR; //����Ϸ������Ʊ
        return len;
    }
    //����Ƿ��ڷ���ʱ�εķ�Χ��
    if (false == gl_verifyServiceTime(game_code)) {
        log_debug("SYS_RESULT_GAME_SERVICETIME_OUT_ERR: game[%d] time out of service time.", game_code);
        msg_header->inm_header.status = SYS_RESULT_GAME_SERVICETIME_OUT_ERR; //��ǰ�����ڲ�Ʊ����ʱ��
        return len;
    }
    //��鳡��
    uint32 *matchCode = inm_msg->matchCode;
    for (int i = 0; i < inm_msg->matchCount; i++) {
        FBS_MATCH *match = game_plugins_handle[game_code].fbs_get_match(inm_msg->ticket.issue_number, *matchCode);
        if (match == NULL) {
            log_error("check match is NULL, match_code[%d]", *matchCode);
            msg_header->inm_header.status = SYS_RESULT_FAILURE;
            return len;
        } else if (match->state != M_STATE_OPEN) {
            msg_header->inm_header.status = SYS_RESULT_CANCEL_NOT_ACCEPT_ERR; //�������йر�
            return len;
        }
        matchCode++;
    }
    //��ѯ����Ʊ
    GIDB_FBS_ST_HANDLE *t_handle = gidb_fbs_st_get_handle(game_code, inm_msg->ticket.issue_number);
    if(t_handle == NULL) {
        log_warn("SYS_RESULT_FAILURE: gidb_fbs_st_get_handle return NULL. gameCode[%d] issueNumber[%u].",
            game_code, inm_msg->ticket.issue_number);
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    }
    char sale_ticket_buf[INM_MSG_BUFFER_LENGTH];
    memset(sale_ticket_buf, 0, INM_MSG_BUFFER_LENGTH);
    GIDB_FBS_ST_REC *pSaleTicket = (GIDB_FBS_ST_REC *)sale_ticket_buf;
    int ret = t_handle->gidb_fbs_st_get_ticket(t_handle, inm_msg->unique_tsn, pSaleTicket);
    if (ret < 0) {
        log_debug("SYS_RESULT_FAILURE: gidb_fbs_st_get_ticket found error. rspfn_ticket[ %s ] unique_tsn[ %llu ]",
                inm_msg->rspfn_ticket, inm_msg->unique_tsn);
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
        return len;
    } else if (ret == 1) {
        log_debug("SYS_RESULT_PAY_NOT_FOUND_ERR: gidb_fbs_st_get_ticket return NULL. tsn[ %s ]", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_TICKET_NOT_FOUND_ERR; //û���ҵ����Ų�Ʊ
        return len;
    }
    strcpy(inm_msg->reqfn_ticket, pSaleTicket->reqfn_ticket);
    strcpy(inm_msg->rspfn_ticket, pSaleTicket->rspfn_ticket);
    memcpy((char *)&inm_msg->ticket, (char *)&pSaleTicket->ticket, pSaleTicket->ticket.length);
    //����Ƿ�����ѵƱ
    if (1 == inm_msg->ticket.is_train)
        inm_msg->header.reqParam = 0x8000;
    //�ж��Ƿ�����Ʊ
    if (pSaleTicket->isCancel) {
        log_debug("TSN[ %s ] has cancel.", inm_msg->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_CANCEL_AGAIN_ERR; //����Ʊ
        return len;
    }
    //�ж�����Ա��Ʊ�������
    /*
    if ( (inm_msg->ticket.bet_amount > transctrlParam->commonTellerCancelLimited) &&
        (0 == inm_msg->ticket.is_train) )
    {
        log_debug("SYS_RESULT_CANCEL_MONEYLIMIT_ERR: tsn[ %s ] cancel_amount[ %lld ]",
            inm_msg->rspfn_ticket, inm_msg->ticket.bet_amount);
        msg_header->inm_header.status = SYS_RESULT_CANCEL_MONEYLIMIT_ERR; //������ͨ����Ա��Ʊ�޶�
        return len;
    }
    */
    //�ж��Ƿ��ǳ�����Ʊʱ��
    time_type currentTime = get_now();
    time_type saleTime = pSaleTicket->time_stamp;
    if (saleTime + transctrlParam->cancelTime < currentTime) {
        log_info("SYS_RESULT_CANCEL_TIME_END_ERR: gl_cancel max cancel Time! tsn[%s] saleTime[%d] currentTime[%d]",
            inm_msg->rspfn_ticket, (int32)saleTime, (int32)currentTime);
        msg_header->inm_header.status = SYS_RESULT_CANCEL_TIME_END_ERR;
        return len;
    }
    //�ж�agency��Ʊ��Χ
    inm_msg->saleAgencyCode = pSaleTicket->agency_code;
    if (inm_msg->saleAgencyCode != inm_msg->header.agencyCode) {
        log_info("SYS_RESULT_T_CANCEL_AGENCY_ERR: gl_cancel agencyCode not match!");
        msg_header->inm_header.status = SYS_RESULT_T_CANCEL_AGENCY_ERR; //��ǰҪ����Ʊ������վ����Ʊ������վһ��
        return len;
    }

    generate_reqfn(3, pTerm->termCode, tms_mgr()->getSequence(), inm_msg->reqfn_ticket_cancel); //����������ˮ��

    int rc = otldb_spcall_fbs_cancel(inm_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("cancel fbs ticket failure.");
        inm_msg->header.inm_header.status = rc;
        return len;
    }
    memcpy((char *)&inm_msg->ticket, (char *)&pSaleTicket->ticket, pSaleTicket->ticket.length);

    pTerm->flowNumber = inm_msg->flowNumber;
    pTerm->last_crc = *(uint16 *)&gltp_buf[g_msg->header.length-2]; //�������һ�ν��׵�crc

    //��Ʊ���澯
    if ((transctrlParam->cancelLimit != 0) && (pSaleTicket->ticket.bet_amount >= transctrlParam->cancelLimit)) {
        notify_agency_cancel_bigAmount(inm_msg->header.agencyCode, game_code,
                tidx_rec->issueNumber, pSaleTicket->ticket.bet_amount, inm_msg->availableCredit);
    }
    return  (offsetof(INM_MSG_FBS_CANCEL_TICKET, ticket) + inm_msg->ticket.length);
}

int R_TERM_cancelticket_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf)
{
    ts_notused_args;
    GLTP_MSG_T_CANCEL_TICKET_REQ *g_msg = (GLTP_MSG_T_CANCEL_TICKET_REQ *)gltp_buf;
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER *)inm_buf;
    int32 cid = msg_header->cid;

    msg_header->inm_header.type = INM_TYPE_COMMOM_ERR;

    int len = sizeof(INM_MSG_T_HEADER);

    TMS_TERMINAL_RECORD* pTerm = tms_mgr()->getTermByIndex(cid);
    if (NULL == pTerm) {
        log_error("term is NULL. idx[%d]", cid);
        msg_header->inm_header.status = SYS_RESULT_T_TOKEN_EXPIRED_ERR;
        return len;
    }

    //parse rspfn (tsn)
    uint32 date = 0;
    uint64 unique_tsn = extract_tsn(g_msg->rspfn_ticket, &date);
    if (unique_tsn==0) {
        log_error("extract_tsn failed. [ %s ]", g_msg->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_TSN_ERR; //TSN����
        return len;
    }
    //�������ļ��в�ѯƱ��Ϣ
    char tidx_buf[512] = {0};
    GIDB_TICKET_IDX_REC *tidx_rec = (GIDB_TICKET_IDX_REC*)tidx_buf;
    int ret = get_ticket_idx(date, unique_tsn, tidx_rec);
    if (ret < 0) {
        msg_header->inm_header.status = SYS_RESULT_FAILURE;
		return len;
    } else if (ret == 1) {
        msg_header->inm_header.status = SYS_RESULT_TICKET_NOT_FOUND_ERR;
        return len;
    }
    //��֤У����
    if (0 != memcmp(g_msg->rspfn_ticket, tidx_rec->rspfn_ticket, TSN_LENGTH-1)) {
        log_error("tsn verify fail!!!, [ %s  ---  %s ]", g_msg->rspfn_ticket, tidx_rec->rspfn_ticket);
        msg_header->inm_header.status = SYS_RESULT_TSN_ERR; //TSN����
        return len;
    }

    if ((tidx_rec->gameCode!=GAME_FBS) && (tidx_rec->gameCode!=GAME_FODD)) {
        //��ͨ��Ϸ
        return term_cancelticket(gltp_buf, inm_buf, tidx_rec, pTerm);
    }

    //k-debug:test
    log_info("term_fbs_cancelticket date[%u]game[%d]issue[%u]tsn[%s]",
            date, tidx_rec->gameCode, tidx_rec->issueNumber, g_msg->rspfn_ticket);
    // FBS ��Ϸ
    return term_fbs_cancelticket(gltp_buf, inm_buf, tidx_rec, pTerm);

}

int S_TERM_cancelticket_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf)
{
    ts_notused_args;
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER *)inm_buf;
    GLTP_MSG_T_CANCEL_TICKET_RSP *g_msg = (GLTP_MSG_T_CANCEL_TICKET_RSP *)gltp_buf;
    g_msg->timeStamp = msg_header->inm_header.when;
    g_msg->transTimeStamp = msg_header->inm_header.when;


    if (msg_header->inm_header.type == INM_TYPE_T_CANCEL_TICKET) {
        INM_MSG_T_CANCEL_TICKET *inm_msg = (INM_MSG_T_CANCEL_TICKET *)inm_buf;
        memcpy(g_msg->rspfn_ticket_cancel, inm_msg->rspfn_ticket_cancel, TSN_LENGTH);
        memcpy(g_msg->rspfn_ticket, inm_msg->rspfn_ticket, TSN_LENGTH);
        g_msg->availableCredit = inm_msg->availableCredit;
        g_msg->gameCode = inm_msg->ticket.gameCode;
        g_msg->flowNumber = inm_msg->flowNumber;
        g_msg->cancelAmount = inm_msg->ticket.amount;
        g_msg->crc = 0;
    } else if (msg_header->inm_header.type == INM_TYPE_FBS_CANCEL_TICKET) {
        INM_MSG_FBS_CANCEL_TICKET *inm_msg = (INM_MSG_FBS_CANCEL_TICKET *)inm_buf;
        memcpy(g_msg->rspfn_ticket_cancel, inm_msg->rspfn_ticket_cancel, TSN_LENGTH);
        memcpy(g_msg->rspfn_ticket, inm_msg->rspfn_ticket, TSN_LENGTH);
        g_msg->availableCredit = inm_msg->availableCredit;
        g_msg->gameCode = inm_msg->ticket.game_code;
        g_msg->flowNumber = inm_msg->flowNumber;
        g_msg->cancelAmount = inm_msg->ticket.bet_amount;
        g_msg->crc = 0;
    }

    return sizeof(GLTP_MSG_T_CANCEL_TICKET_RSP);
}


int R_TERM_fbs_inquiryMatch_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf)
{
    ts_notused_args;
    GLTP_MSG_T_FBS_MATCH_INFO_REQ *g_msg = (GLTP_MSG_T_FBS_MATCH_INFO_REQ *)gltp_buf;
    INM_MSG_T_HEADER *msg_header = (INM_MSG_T_HEADER *)inm_buf;
    INM_MSG_FBS_MATCH_INFO *inm_msg = (INM_MSG_FBS_MATCH_INFO *)inm_buf;
    int32 cid = msg_header->cid;

    msg_header->inm_header.type = INM_TYPE_FBS_MATCH_INFO;

    int len = sizeof(INM_MSG_FBS_MATCH_INFO);

    TMS_TERMINAL_RECORD* pTerm = tms_mgr()->getTermByIndex(cid);
    if (NULL == pTerm) {
        log_error("term is NULL. idx[%d]", cid);
        inm_msg->header.inm_header.status = SYS_RESULT_T_TOKEN_EXPIRED_ERR;
        return len;
    }

    FBS_ISSUE *issue_ptr = game_plugins_handle[GAME_FBS].fbs_get_issueTable();

    int matchCnt = 0;
    for (int i = 0; i < FBS_MAX_ISSUE_NUM; i++)
    {
        if (!issue_ptr->used) {
            issue_ptr++;
            continue;
        }

        for (int j = 0; j < FBS_MAX_ISSUE_MATCH; j++)
        {
            FBS_MATCH *match = issue_ptr->match_array + j;
            FBS_MATCH_INFO *fbsMatch = inm_msg->fbsMatch + matchCnt;

            if ( (!match->used) || (match->status != ENABLED) || (match->state != M_STATE_OPEN) ) {
                continue;
            }

            fbsMatch->match_code = match->match_code;
            fbsMatch->seq = match->seq;
            strcpy((char*)fbsMatch->subtype_status, (char*)match->subtype_status);
            fbsMatch->competition = match->competition;
            fbsMatch->round = match->round;
            fbsMatch->home_code = match->home_code;
            fbsMatch->away_code = match->away_code;
            fbsMatch->date = match->date;
            //strcpy(fbsMatch->venue, match->venue);
            fbsMatch->match_time = match->match_time;
            fbsMatch->sale_time = match->sale_time;
            fbsMatch->close_time = match->close_time;
            fbsMatch->state = match->state;
            fbsMatch->home_handicap = match->home_handicap;
            fbsMatch->home_handicap_point5 = match->home_handicap_point5;

            matchCnt++;
        }

        issue_ptr++;
    }

    inm_msg->matchCount = matchCnt;
    inm_msg->gameCode = GAME_FBS;

    return len + inm_msg->matchCount * sizeof(FBS_MATCH_INFO);
}

int S_TERM_fbs_inquiryMatch_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf)
{
    ts_notused_args;
    INM_MSG_FBS_MATCH_INFO *inm_msg = (INM_MSG_FBS_MATCH_INFO *)inm_buf;
    GLTP_MSG_T_FBS_MATCH_INFO_RSP *g_msg = (GLTP_MSG_T_FBS_MATCH_INFO_RSP *)gltp_buf;
    g_msg->timeStamp = get_now();

    g_msg->gameCode = inm_msg->gameCode;
    g_msg->matchCount = inm_msg->matchCount;
    memcpy(g_msg->fbsMatch, inm_msg->fbsMatch, sizeof(FBS_MATCH_INFO)*inm_msg->matchCount);

    return (sizeof(GLTP_MSG_T_FBS_MATCH_INFO_RSP) + sizeof(FBS_MATCH_INFO) * g_msg->matchCount + CRC_SIZE);
}


//----------------------------------------------------------------------------------------------------------
//
// UNS Message
//
//----------------------------------------------------------------------------------------------------------

int S_TERM_UNS_gameopen_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf)
{
    ts_notused_args;
    GLTP_MSG_T_OPEN_GAME_UNS *g_msg = (GLTP_MSG_T_OPEN_GAME_UNS *)gltp_buf;
    INM_MSG_T_OPEN_GAME_UNS *inm_msg = (INM_MSG_T_OPEN_GAME_UNS *)inm_buf;

    g_msg->gameCode = inm_msg->gameCode;
    g_msg->issueNumber = inm_msg->issueNumber;
    g_msg->issueTimeStamp = inm_msg->issueTimeStamp;
    g_msg->issueTimeSpan = inm_msg->issueTimeSpan;
    g_msg->countDownSeconds = inm_msg->countDownSeconds;

    inm_msg->header.reqParam = 1; //broadcast

    return sizeof(GLTP_MSG_T_OPEN_GAME_UNS);
}

/*
int S_TERM_UNS_gameclosing_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf)
{
    ts_notused_args;
    GLTP_MSG_T_CLOSE_SECONDS_UNS *g_msg = (GLTP_MSG_T_CLOSE_SECONDS_UNS *)gltp_buf;
    INM_MSG_T_CLOSE_SECONDS_UNS *inm_msg = (INM_MSG_T_CLOSE_SECONDS_UNS *)inm_buf;

    g_msg->gameCode = inm_msg->gameCode;
    g_msg->issueNumber = inm_msg->issueNumber;
    g_msg->issueTimeStamp = inm_msg->issueTimeStamp;
    g_msg->closeCountDownSecond = inm_msg->closeCountDownSecond;

    inm_msg->header.reqParam = 1; //broadcast

    return sizeof(GLTP_MSG_T_CLOSE_SECONDS_UNS);
}
*/

int S_TERM_UNS_gameclose_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf)
{
    ts_notused_args;
    GLTP_MSG_T_CLOSE_GAME_UNS *g_msg = (GLTP_MSG_T_CLOSE_GAME_UNS *)gltp_buf;
    INM_MSG_T_CLOSE_GAME_UNS *inm_msg = (INM_MSG_T_CLOSE_GAME_UNS *)inm_buf;

    g_msg->gameCode = inm_msg->gameCode;
    g_msg->issueNumber = inm_msg->issueNumber;
    g_msg->issueTimeStamp = inm_msg->issueTimeStamp;

    inm_msg->header.reqParam = 1; //broadcast

    return sizeof(GLTP_MSG_T_CLOSE_GAME_UNS);
}

int S_TERM_UNS_drawannounce_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf)
{
    ts_notused_args;
    GLTP_MSG_T_DRAW_ANNOUNCE_UNS *g_msg = (GLTP_MSG_T_DRAW_ANNOUNCE_UNS *)gltp_buf;
    INM_MSG_T_DRAW_ANNOUNCE_UNS*inm_msg = (INM_MSG_T_DRAW_ANNOUNCE_UNS *)inm_buf;

    g_msg->gameCode = inm_msg->gameCode;
    g_msg->issueNumber = inm_msg->issueNumber;
    g_msg->issueTimeStamp = inm_msg->issueTimeStamp;

    g_msg->drawCodeLen = inm_msg->drawCodeLen;
    g_msg->drawAnnounceLen = inm_msg->drawAnnounceLen;
    strncpy(g_msg->drawCode, inm_msg->drawCode, g_msg->drawCodeLen);
    strncpy((g_msg->drawCode + g_msg->drawCodeLen), inm_msg->drawAnnounce, g_msg->drawAnnounceLen);

    inm_msg->header.reqParam = 1; //broadcast

    return (sizeof(GLTP_MSG_T_DRAW_ANNOUNCE_UNS) + g_msg->drawCodeLen + g_msg->drawAnnounceLen + CRC_SIZE);
}

