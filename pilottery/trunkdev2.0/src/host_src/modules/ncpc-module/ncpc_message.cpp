#include "global.h"
#include "gl_inf.h"
#include "otl_inf.h"
#include "ncpc_inf.h"
#include "ncpc_http_parse.h"
#include "ncpc_http_kvdb.h"
#include "ncpc_net.h"
#include "ncpc_message.h"
#include "ncpcmod.h"
#include "tms_inf.h"


//--------Net Package Log----------------------------------------------------------

#define NCPC_NET_LOG_FILE "ncpc_net"
#define NCPC_NET_HTTP_LOG_FILE "ncpc_net_http"

static uint32 ncpc_current_day_g = 0;
static uint32 ncpc_http_current_day_g = 0;

static int ncpc_log_init = 0;
FILE *ncpc_net_fd;
char ncpc_net_filename[PATH_MAX];

static int ncpc_log_http_init = 0;
FILE *ncpc_net_http_fd;
char ncpc_net_http_filename[PATH_MAX];

#define LINENUM 16
static pthread_mutex_t log_mutex = PTHREAD_MUTEX_INITIALIZER;
static pthread_mutex_t log_http_mutex = PTHREAD_MUTEX_INITIALIZER;




int ncpc_initLog(struct tm *ptm)
{
    uint32 day = 0;
    pthread_mutex_lock(&log_mutex);
    day = (ptm->tm_year + 1900)*10000 + (ptm->tm_mon + 1)*100 + ptm->tm_mday;

    if (ncpc_log_init == 0) {
        //init
        char dt_now[64] = {0};
        strftime(dt_now, sizeof(dt_now), "%Y-%m-%d", (const struct tm *)ptm);
        sprintf(ncpc_net_filename, "%s/%s/%s.%s", LOG_ROOT_DIR, dt_now, NCPC_NET_LOG_FILE, "log");

        char file_path_tmp[PATH_MAX];
        strcpy(file_path_tmp, ncpc_net_filename);
        char *path_dir = dirname(file_path_tmp);
        if (0 != mkdirs(path_dir)) {
            perrork("mkdirs(%s) failed.\n", path_dir);
            goto log_error;
        }
        ncpc_net_fd = fopen(ncpc_net_filename, "a+");
        if (ncpc_net_fd == NULL) {
            perrork("[a] fopen file %s failure!", ncpc_net_filename);
            goto log_error;
        }
        ncpc_log_init = 1;
        ncpc_current_day_g = day;
    }
    //switch day
    if (day != ncpc_current_day_g) {
        //�ȴ����ļ����򿪳ɹ����ٹرվ��ļ���
        //�������Ա����ڴ���д�������ļ�ʧ��ʱ���ֵ�������fclose���±��������������
        char dt_now[64] = {0};
        strftime(dt_now, sizeof(dt_now), "%Y-%m-%d", (const struct tm *)ptm);
        sprintf(ncpc_net_filename, "%s/%s/%s.%s", LOG_ROOT_DIR, dt_now, NCPC_NET_LOG_FILE, "log");

        char file_path_tmp[PATH_MAX];
        strcpy(file_path_tmp, ncpc_net_filename);
        char *path_dir = dirname(file_path_tmp);
        if (0 != mkdirs(path_dir)) {
            perrork("mkdirs(%s) failed.\n", path_dir);
            goto log_error;
        }
        FILE *tmp_ncpc_net_fd = fopen(ncpc_net_filename, "a+");
        if (tmp_ncpc_net_fd == NULL) {
            perrork("[a] fopen file %s failure!", ncpc_net_filename);
            goto log_error;
        }
        fclose(ncpc_net_fd);
        ncpc_net_fd = tmp_ncpc_net_fd;
        ncpc_current_day_g = day;
    }
    pthread_mutex_unlock(&log_mutex);
    return 0;
log_error:
    pthread_mutex_unlock(&log_mutex);
    return -1;
}

int ncpc_http_initLog(struct tm *ptm)
{
    uint32 day = 0;
    pthread_mutex_lock(&log_http_mutex);
    day = (ptm->tm_year + 1900)*10000 + (ptm->tm_mon + 1)*100 + ptm->tm_mday;

    if (ncpc_log_http_init == 0) {
        //init
        char dt_now[64] = {0};
        strftime(dt_now, sizeof(dt_now), "%Y-%m-%d", (const struct tm *)ptm);
        sprintf(ncpc_net_http_filename, "%s/%s/%s.%s", LOG_ROOT_DIR, dt_now, NCPC_NET_HTTP_LOG_FILE, "log");

        char file_path_tmp[PATH_MAX];
        strcpy(file_path_tmp, ncpc_net_http_filename);
        char *path_dir = dirname(file_path_tmp);
        if (0 != mkdirs(path_dir)) {
            perrork("mkdirs(%s) failed.\n", path_dir);
            goto log_error;
        }
        ncpc_net_http_fd = fopen(ncpc_net_http_filename, "a+");
        if (ncpc_net_http_fd == NULL) {
            perrork("[a] fopen file %s failure!", ncpc_net_http_filename);
            goto log_error;
        }
        ncpc_log_http_init = 1;
        ncpc_http_current_day_g = day;
    }
    //switch day
    if (day != ncpc_http_current_day_g) {
        //�ȴ����ļ����򿪳ɹ����ٹرվ��ļ���
        //�������Ա����ڴ���д�������ļ�ʧ��ʱ���ֵ�������fclose���±��������������
        char dt_now[64] = {0};
        strftime(dt_now, sizeof(dt_now), "%Y-%m-%d", (const struct tm *)ptm);
        sprintf(ncpc_net_http_filename, "%s/%s/%s.%s", LOG_ROOT_DIR, dt_now, NCPC_NET_HTTP_LOG_FILE, "log");

        char file_path_tmp[PATH_MAX];
        strcpy(file_path_tmp, ncpc_net_http_filename);
        char *path_dir = dirname(file_path_tmp);
        if (0 != mkdirs(path_dir)) {
            perrork("mkdirs(%s) failed.\n", path_dir);
            goto log_error;
        }
        FILE *tmp_ncpc_net_http_fd = fopen(ncpc_net_http_filename, "a+");
        if (tmp_ncpc_net_http_fd == NULL) {
            perrork("[a] fopen file %s failure!", ncpc_net_http_filename);
            goto log_error;
        }
        fclose(ncpc_net_http_fd);
        ncpc_net_http_fd = tmp_ncpc_net_http_fd;
        ncpc_http_current_day_g = day;
    }
    pthread_mutex_unlock(&log_http_mutex);
    return 0;
log_error:
    pthread_mutex_unlock(&log_http_mutex);
    return -1;
}

void dump_hex_buffer(FILE *log_fd, char *buffer, int32 length, char *out_buffer)
{
    int offset = 0;
    for (int i = 0; i < length; i++) {
        sprintf(out_buffer+offset, "%02x ", (unsigned char)buffer[i]);
        offset += 3;
        if ((i+1) % LINENUM == 0) {
            if (i != (length-1)) {
                sprintf(out_buffer+offset, "\n"); offset += 1;
            }
        }
    }
    fprintf(log_fd, "%s\n\n", out_buffer);
    return;
}

//parameter: rx_tx  0: rx , 1: tx
void ncpc_dump_package(char *buf, char *ip, int port, int rxtx)
{
    GLTP_MSG_HEADER *header = (GLTP_MSG_HEADER *)buf;
    if (header->type == GLTP_MSG_TYPE_NCP) {
        if ((header->func==GLTP_N_HB) || (header->func==GLTP_N_TERM_NETWORK_DELAY) || (header->func==GLTP_N_TERMINAL_CONN))
            return;
    } else { //GLTP_MSG_TYPE_TERMINAL
        if ((header->func==GLTP_T_HB) || (header->func==GLTP_T_NETWORK_DELAY_REQ) || (header->func==GLTP_T_NETWORK_DELAY_RSP))
            return;
    }

    char dt_now[64] = {0}; struct timeval tv; struct tm ptm;
    gettimeofday(&tv, NULL); localtime_r(&tv.tv_sec, &ptm);
    sprintf(dt_now, "%d-%02d-%02d %02d:%02d:%02d.%3ld",
            (ptm.tm_year+1900), (ptm.tm_mon+1), ptm.tm_mday, ptm.tm_hour, ptm.tm_min, ptm.tm_sec, tv.tv_usec/1000);

    ncpc_initLog(&ptm);

    pthread_mutex_lock(&log_mutex);
    if (header->type == GLTP_MSG_TYPE_NCP) {
        fprintf(ncpc_net_fd, "NCP %s    <%s> [%s:%d] ------------>\nlen[%d] type[%d] func[%d]\n",
                (rxtx==0)?"Rx":"Tx", dt_now, ip, port, header->length, header->type, header->func);
    } else { //GLTP_MSG_TYPE_TERMINAL
        GLTP_MSG_T_HEADER *term_header = (GLTP_MSG_T_HEADER *)buf;
        if (rxtx==0)
            fprintf(ncpc_net_fd,
                    "TERM Rx    <%s> [%s:%d] ------------> CID[ %d ] TOKEN[ %llu ]\nlen[%d] type[%d] func[%d] msn[%d]\n",
                    dt_now, ip, port, (int32)(term_header->token&0x000000000000FFFF), term_header->token,
                    term_header->length, term_header->type, term_header->func, term_header->msn);
        else
            fprintf(ncpc_net_fd,
                    "TERM Tx    <%s> [%s:%d] ------------> CID[ %d ] TOKEN[ %llu ]\nlen[%d] type[%d] func[%d] msn[%d] status[%d]\n",
                    dt_now, ip, port, (int32)(term_header->token&0x000000000000FFFF), term_header->token,
                    term_header->length, term_header->type, term_header->func, term_header->msn, term_header->status);
    }
    static char msgbuf[1024*32];
    dump_hex_buffer(ncpc_net_fd, buf, header->length, msgbuf);
    pthread_mutex_unlock(&log_mutex);
    fflush(ncpc_net_fd);
    return;
}

void ncpc_dump_http_package(char *buf, char *ip, int port, int rxtx)
{
    //ignore
    char *p = strstr(buf, "\"func\":55007");
    if (p != NULL) {
        return;
    }
    p = strstr(buf, "\"func\":55009");
    if (p != NULL) {
        return;
    }

    char dt_now[64] = {0}; struct timeval tv; struct tm ptm;
    gettimeofday(&tv, NULL); localtime_r(&tv.tv_sec, &ptm);
    sprintf(dt_now, "%d-%02d-%02d %02d:%02d:%02d.%3ld",
            (ptm.tm_year+1900), (ptm.tm_mon+1), ptm.tm_mday, ptm.tm_hour, ptm.tm_min, ptm.tm_sec, tv.tv_usec/1000);

    ncpc_http_initLog(&ptm);

    pthread_mutex_lock(&log_http_mutex);
    fprintf(ncpc_net_http_fd, "%s  <%s> [%s:%d] ------------>\n%s\n",
            (rxtx==0)?"Rx":"Tx",dt_now, ip, port, buf);
    pthread_mutex_unlock(&log_http_mutex);
    fflush(ncpc_net_http_fd);
    return;
}


//--------generate_reqfn process----------------------------------------------------------

//�����ն˱����flownumber������ˮ�� flag 1: sale  flag 2: pay  flag 3: cancel
void generate_reqfn(uint8 flag, uint64 term_code, uint64 sequence, char *reqfn)
{
    ts_notused(flag);
    uint32 date = sysdb_getSessionDate();
    sprintf(reqfn, "%06u%010llu%08llu", date%1000000, term_code, sequence);
}




//--------message process----------------------------------------------------------

static NCPC_MSG_DISPATCH_CELL ncpc_msg_dispatch_cells[] =
{
    //------------------------------------------------------------------------------------------------
    // ncp process cell
    //------------------------------------------------------------------------------------------------
    //����
    {GLTP_MSG_TYPE_NCP, GLTP_N_HB, R_NCP_hb_process, q_ncpc_send, S_NCP_hb_process},
    //echo��Ϣ
    {GLTP_MSG_TYPE_NCP, GLTP_N_ECHO_REQ, R_NCP_echo_process, q_tfe_adder, S_NCP_echo_process},
    //�ն�����/�Ͽ�����
    {GLTP_MSG_TYPE_NCP, GLTP_N_TERMINAL_CONN, R_NCP_termconn_process, 0, NULL}, //rpt
    //�ն������ӳ�ʱ��
    {GLTP_MSG_TYPE_NCP, GLTP_N_TERM_NETWORK_DELAY, R_NCP_network_delay_process, 0, NULL}, //rpt
    //��Ϸ����Ϣ
    {GLTP_MSG_TYPE_NCP, GLTP_N_GAME_ISSUE_REQ, R_NCP_gameissue_process, q_ncpc_send, S_NCP_gameissue_process}, //rpt

    //------------------------------------------------------------------------------------------------
    // terminal process cell
    //------------------------------------------------------------------------------------------------
    //echo��Ϣ
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_ECHO_REQ, R_TERM_echo_process, q_tfe_adder, S_TERM_echo_process},
    //����Ա����
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_SIGNIN_REQ, R_TERM_signin_process, q_ncpc_send, S_TERM_signin_process},
    //����Աǩ��
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_SIGNOUT_REQ, R_TERM_signout_process, q_ncpc_send, S_TERM_signout_process},
    //����Ա�޸�����
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_CHANGE_PWD_REQ, R_TERM_changepwd_process, q_ncpc_send, S_TERM_changepwd_process},
    //����վ����ѯ
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_AGENCY_BALANCE_REQ, R_TERM_agencybalance_process, q_ncpc_send, S_TERM_agencybalance_process},
    //��Ϸ��Ϣ
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_GAME_INFO_REQ, R_TERM_gameinfo_process, q_ncpc_send, S_TERM_gameinfo_process},
    //��Ʊ����
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_SELL_TICKET_REQ, R_TERM_sellticket_process, q_tfe_adder, S_TERM_sellticket_process},
    //��Ʊ��ѯ
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_INQUIRY_TICKET_REQ, R_TERM_inquiryticket_process, q_ncpc_send, S_TERM_inquiryticket_process},
    //��Ʊ�ҽ�
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_PAY_TICKET_REQ, R_TERM_payticket_process, q_tfe_adder, S_TERM_payticket_process},
    //��Ʊȡ��
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_CANCEL_TICKET_REQ, R_TERM_cancelticket_process, q_tfe_adder, S_TERM_cancelticket_process},
    //��Ʊ�н���ѯ
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_INQUIRY_WIN_REQ, R_TERM_inquiryWin_process, q_ncpc_send, S_TERM_inquiryWin_process},
    // FBS  ������Ϣ��ѯ
    {GLTP_MSG_TYPE_TERMINAL, GLTP_FBS_INQUIRY_MATCH_REQ, R_TERM_fbs_inquiryMatch_process, q_ncpc_send, S_TERM_fbs_inquiryMatch_process},


    //------------------------------------------------------------------------------------------------
    // terminal uns process cell
    //------------------------------------------------------------------------------------------------
    //��Ϸ��ʼ
    {GLTP_MSG_TYPE_TERMINAL_UNS, GLTP_T_UNS_OPEN_GAME, NULL, 0, S_TERM_UNS_gameopen_process},
    //��Ϸ��������ʱ
    //{GLTP_MSG_TYPE_TERMINAL_UNS, GLTP_T_UNS_CLOSE_SECONDS, NULL, 0, S_TERM_UNS_gameclosing_process},
    //��Ϸ����
    {GLTP_MSG_TYPE_TERMINAL_UNS, GLTP_T_UNS_CLOSE_GAME, NULL, 0, S_TERM_UNS_gameclose_process},
    //��Ϸ��������
    {GLTP_MSG_TYPE_TERMINAL_UNS, GLTP_T_UNS_DRAW_ANNOUNCE, NULL, 0, S_TERM_UNS_drawannounce_process},

};

NCPC_MSG_DISPATCH_CELL *ncpc_get_dispatch(uint8 type, uint16 func)
{
    uint32 i = 0;
    NCPC_MSG_DISPATCH_CELL *cell = NULL;

    for (i = 0; i < sizeof(ncpc_msg_dispatch_cells)/sizeof(NCPC_MSG_DISPATCH_CELL); i++) {
        cell = &ncpc_msg_dispatch_cells[i];
        if ((cell->type == type) && (cell->func == func))
            return cell;
    }
    return NULL;
}




static NCPC_HTTP_MSG_DISPATCH_CELL ncpc_http_msg_dispatch_cells[] =
{
    //------------------------------------------------------------------------------------------------
    // ncpc ap http message  process cell
    //------------------------------------------------------------------------------------------------
    {GLTP_AP_ECHO,           R_AP_echo_process,          q_ncpc_http_send, S_AP_echo_process},
    {GLTP_AP_SELL_TICKET,    R_AP_sellTicket_process,    q_tfe_adder,      S_AP_sellTicket_process},
    {GLTP_AP_INQUIRY_TICKET, R_AP_inquiryTicket_process, q_ncpc_http_send, S_AP_inquiryTicket_process},
    {GLTP_AP_INQUIRY_ISSUE, R_AP_inquiry_curr_issue_process, q_ncpc_http_send, S_AP_inquiry_curr_issue_process },
    {GLTP_AP_ISSUE_STATE, R_AP_inquiry_preSale_issue_process, q_ncpc_http_send, S_AP_inquiry_preSale_issue_process },


    //FBS
    {GLTP_AP_FBS_SELL_TICKET,R_AP_fbs_sellTicket_process,q_tfe_adder,      S_AP_fbs_sellTicket_process},




    //------------------------------------------------------------------------------------------------
    // oms process cell
    //------------------------------------------------------------------------------------------------
    //echo��Ϣ
    {GLTP_O_ECHO_REQ, R_OMS_echo_process, q_ncpc_http_send, S_OMS_echo_process},
    //��������״̬
    {GLTP_O_INQUIRY_SYSTEM_REQ, R_OMS_inquiry_system_process, q_ncpc_http_send, S_OMS_inquiry_system_process},
    //��Ϸ���߲���
    {GLTP_O_GL_POLICY_PARAM_REQ, R_OMS_gl_policy_param_process, q_ncpc_http_send, S_OMS_gl_policy_param_process},
    //��Ϸ��ͨ�������
    {GLTP_O_GL_RULE_PARAM_REQ, R_OMS_gl_rule_param_process, q_ncpc_http_send, S_OMS_gl_rule_param_process},
    //��Ϸ���Ʋ���
    {GLTP_O_GL_CTRL_PARAM_REQ, R_OMS_gl_ctrl_param_process, q_ncpc_http_send, S_OMS_gl_ctrl_param_process},
    //��Ϸ���տ��Ʋ���
    {GLTP_O_GL_RISK_CTRL_PARAM_REQ, R_OMS_gl_riskctrl_param_process, q_ncpc_http_send, S_OMS_gl_riskctrl_param_process},
    //��Ϸ���ۿ���
    {GLTP_O_GL_SALE_CTRL_REQ, R_OMS_gl_sale_ctrl_process, q_ncpc_http_send, S_OMS_gl_sale_ctrl_process},
    //��Ϸ�ҽ�����
    {GLTP_O_GL_PAY_CTRL_REQ, R_OMS_gl_pay_ctrl_process, q_ncpc_http_send, S_OMS_gl_pay_ctrl_process},
    //��Ϸ��Ʊ����
    {GLTP_O_GL_CANCEL_CTRL_REQ, R_OMS_gl_cancel_ctrl_process, q_ncpc_http_send, S_OMS_gl_cancel_ctrl_process},
    //��Ϸ�Զ���������
    {GLTP_O_GL_AUTO_DRAW_REQ, R_OMS_gl_autodraw_process, q_ncpc_http_send, S_OMS_gl_autodraw_process},
    //��Ϸ����ʱ������
    {GLTP_O_GL_SERVICE_TIME_REQ, R_OMS_gl_servicetime_process, q_ncpc_http_send, S_OMS_gl_servicetime_process},
    //��Ϸ�澯��ֵ����
    {GLTP_O_GL_WARN_THRESHOLD_REQ, R_OMS_gl_warn_threshold_process, q_ncpc_http_send, S_OMS_gl_warn_threshold_process},

    //�����ڴ�
    {GLTP_O_GL_ISSUE_DELETE_REQ, R_OMS_gl_issue_delete_process, q_gl_driver, S_OMS_gl_issue_delete_process},
    //�ڴο��������ο���-���ã�
    {GLTP_O_GL_ISSUE_SECOND_DRAW_REQ, R_OMS_gl_issue_second_draw_process, q_ncpc_http_send, S_OMS_gl_issue_second_draw_process},
    //�ڽ� �C> ��������¼��
    {GLTP_O_GL_ISSUE_INPUT_DRAW_RESULT_REQ, R_OMS_gl_issue_input_drawresult_process, q_ncpc_http_send, S_OMS_gl_issue_input_drawresult_process},
    //�ڽ� -> ��Ϸ���ز��� (Ŀǰδʵ��)
    //�ڽ� �C> ��������¼��
    {GLTP_O_GL_ISSUE_INPUT_PRIZE_REQ, R_OMS_gl_issue_prize_process, q_ncpc_http_send, S_OMS_gl_issue_prize_process},
    //�ڽ� �C> �ַ���������ժҪ
    {GLTP_O_GL_ISSUE_FILE_MD5SUM_REQ, R_OMS_gl_issue_md5sum_process, q_ncpc_http_send, S_OMS_gl_issue_md5sum_process},
    //�ڽ� �C> ����ȷ��
    {GLTP_O_GL_ISSUE_DRAW_CONFIRM_REQ, R_OMS_gl_issue_draw_confirm_process, q_ncpc_http_send, S_OMS_gl_issue_draw_confirm_process},
    //�ڽ� �C> ���¿���
    {GLTP_O_GL_ISSUE_REDO_DRAW_REQ, R_OMS_gl_issue_redo_draw_process, q_ncpc_http_send, S_OMS_gl_issue_redo_draw_process},
    //�����ڴ�֪ͨ��Ϣ
    {GLTP_O_GL_ISSUE_ADD_NFY_REQ, R_OMS_gl_issue_add_nfy_process, q_gl_driver, S_OMS_gl_issue_add_nfy_process},

    //��Ʊ��ѯ
    {GLTP_O_TICKET_INQUIRY_REQ, R_OMS_ticket_inquiry_process, q_ncpc_http_send, S_OMS_ticket_inquiry_process},
    //��Ʊ�ҽ�
    {GLTP_O_TICKET_PAY_REQ, R_OMS_ticket_pay_process, q_tfe_adder, S_OMS_ticket_pay_process},
    //��Ʊ��Ʊ
    {GLTP_O_TICKET_CANCEL_REQ, R_OMS_ticket_cancel_process, q_tfe_adder, S_OMS_ticket_cancel_process},
	
	// FBS
//    //��Ʊ��ѯ
//    {GLTP_O_FBS_TICKET_INQUIRY_REQ, R_OMS_fbs_ticket_inquiry_process, q_ncpc_http_send, S_OMS_fbs_ticket_inquiry_process},
//    //��Ʊ�ҽ�
//    {GLTP_O_FBS_TICKET_PAY_REQ, R_OMS_fbs_ticket_pay_process, q_tfe_adder, S_OMS_fbs_ticket_pay_process},
//    //��Ʊ��Ʊ
//    {GLTP_O_FBS_TICKET_CANCEL_REQ, R_OMS_fbs_ticket_cancel_process, q_tfe_adder, S_OMS_fbs_ticket_cancel_process},
    // FBS ��������֪ͨ��Ϣ
    {GLTP_O_FBS_ADD_MATCH_NFY_REQ, R_OMS_fbs_add_match_nfy_process, q_fbs_driver, S_OMS_fbs_add_match_nfy_process},
    // FBS ɾ������
    //{GLTP_O_FBS_DELETE_MATCH_REQ, R_OMS_fbs_del_match_process, q_fbs_driver, S_OMS_fbs_del_match_process},
    // FBS ����/ͣ�ñ���
    {GLTP_O_FBS_MATCH_STATUS_CTRL_REQ, R_OMS_fbs_match_state_ctrl_process, q_fbs_driver, S_OMS_fbs_match_state_ctrl_process},
    // FBS �������� �C> ¼�뿪������
    {GLTP_O_FBS_DRAW_INPUT_RESULT_REQ, R_OMS_fbs_draw_input_result_process, q_ncpc_http_send, S_OMS_fbs_draw_input_result_process},
    // FBS �������� �C> �������ȷ��
    {GLTP_O_FBS_DRAW_CONFIRM_REQ, R_OMS_fbs_draw_confirm_process, q_ncpc_http_send, S_OMS_fbs_confirm_process},
};

NCPC_HTTP_MSG_DISPATCH_CELL *ncpc_http_get_dispatch(uint32 func)
{
    uint32 i = 0;
    NCPC_HTTP_MSG_DISPATCH_CELL *cell = NULL;

    for (i = 0; i < sizeof(ncpc_http_msg_dispatch_cells)/sizeof(NCPC_HTTP_MSG_DISPATCH_CELL); i++) {
        cell = &ncpc_http_msg_dispatch_cells[i];
        if (cell->func == func)
            return cell;
    }
    return NULL;
}



// oracle db sp call interface -------------------------------------------------------

//auth
int otldb_spcall_auth(char *inm_buf)
{
    int rc = 0;
    INM_MSG_T_AUTH *inm_msg = (INM_MSG_T_AUTH *)inm_buf;
    int type = inm_msg->header.inm_header.type;

    cJSON *json_req = cJSON_CreateObject();
    cJSON_AddNumberToObject(json_req, "type", type);
    char mac_str[20];
    sprintf(mac_str, "%02X:%02X:%02X:%02X:%02X:%02X",
        inm_msg->mac[0],inm_msg->mac[1],inm_msg->mac[2],inm_msg->mac[3],inm_msg->mac[4],inm_msg->mac[5]);
    cJSON_AddStringToObject(json_req, "mac", mac_str);
    cJSON_AddStringToObject(json_req, "version", inm_msg->version);
    char *req_buf = cJSON_PrintUnformatted(json_req);

    char resp_buf[INM_MSG_BUFFER_LENGTH] = {0};
    rc = otl_json_sp_pil(type, req_buf, resp_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("otldb_spcall_auth() return %d", rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_resp = cJSON_Parse(resp_buf);
    cJSON *json_rc = cJSON_GetObjectItem(json_resp, "rc");
    rc = json_rc->valueint;
    if (rc != SYS_RESULT_SUCCESS)
    {
        log_debug("auth rc:%d",rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_param = cJSON_GetObjectItem(json_resp, "term_code");
    inm_msg->header.terminalCode = atol(json_param->valuestring);
    json_param = cJSON_GetObjectItem(json_resp, "agency_code");
    inm_msg->header.agencyCode = atol(json_param->valuestring);
    json_param = cJSON_GetObjectItem(json_resp, "org_code");
    inm_msg->header.areaCode = atoi(json_param->valuestring);
    log_debug("term_code:%d agency_code:%d org_code:%d ",
        inm_msg->header.terminalCode, inm_msg->header.agencyCode, inm_msg->header.areaCode);
    free(req_buf); cJSON_Delete(json_req);
    return rc;
}

//signin
int otldb_spcall_signin(char *inm_buf)
{
    int rc = 0;
    INM_MSG_T_SIGNIN *inm_msg = (INM_MSG_T_SIGNIN *)inm_buf;
    int type = inm_msg->header.inm_header.type;

    char sbuf[64];
    cJSON *json_req = cJSON_CreateObject();
    cJSON_AddNumberToObject(json_req, "type", type);
    sprintf(sbuf, "%010llu", inm_msg->header.terminalCode);
    cJSON_AddStringToObject(json_req, "term_code", sbuf);
    sprintf(sbuf, "%08llu", inm_msg->header.agencyCode);
    cJSON_AddStringToObject(json_req, "agency_code", sbuf);

    cJSON_AddNumberToObject(json_req, "teller_code", inm_msg->header.tellerCode);
    cJSON_AddStringToObject(json_req, "password", inm_msg->password);
    char *req_buf = cJSON_PrintUnformatted(json_req);

    char resp_buf[INM_MSG_BUFFER_LENGTH] = {0};
    rc = otl_json_sp_pil(type, req_buf, resp_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("otldb_spcall_signin() return %d", rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_resp = cJSON_Parse(resp_buf);
    cJSON *json_rc = cJSON_GetObjectItem(json_resp, "rc");
    rc = json_rc->valueint;
    if (rc != SYS_RESULT_SUCCESS)
    {
        log_debug("auth rc:%d", rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_param = cJSON_GetObjectItem(json_resp, "teller_type");
    inm_msg->tellerType = json_param->valueint;
    json_param = cJSON_GetObjectItem(json_resp, "flownum");
    inm_msg->nextFlowNumber = json_param->valuedouble;
    json_param = cJSON_GetObjectItem(json_resp, "account_balance");
    inm_msg->availableCredit = json_param->valuedouble;
    json_param = cJSON_GetObjectItem(json_resp, "marginal_credit");
    inm_msg->availableCredit += json_param->valuedouble;

    log_debug("flownum:%d account_balance:%d marginal_credit:%d ",
        inm_msg->nextFlowNumber, inm_msg->availableCredit, inm_msg->availableCredit);
    free(req_buf); cJSON_Delete(json_req);
    return rc;
}

//signout
int otldb_spcall_signout(char *inm_buf)
{
    int rc = 0;
    INM_MSG_T_SIGNOUT *inm_msg = (INM_MSG_T_SIGNOUT *)inm_buf;
    int type = inm_msg->header.inm_header.type;

    char sbuf[64];
    cJSON *json_req = cJSON_CreateObject();
    cJSON_AddNumberToObject(json_req, "type", type);
    sprintf(sbuf, "%010llu", inm_msg->header.terminalCode);
    cJSON_AddStringToObject(json_req, "term_code", sbuf);
    cJSON_AddNumberToObject(json_req, "teller_code", inm_msg->header.agencyCode);

    char *req_buf = cJSON_PrintUnformatted(json_req);

    char resp_buf[INM_MSG_BUFFER_LENGTH] = {0};
    rc = otl_json_sp_pil(type, req_buf, resp_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("otldb_spcall_signout() return %d", rc);
    }
    cJSON *json_resp = cJSON_Parse(resp_buf);
    cJSON *json_rc = cJSON_GetObjectItem(json_resp, "rc");
    rc = json_rc->valueint;
    if (rc != SYS_RESULT_SUCCESS)
    {
        log_debug("inquiry balance rc:%d", rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    free(req_buf); cJSON_Delete(json_req);
    return rc;
}

//inquiry change password
int otldb_spcall_change_password(char *inm_buf)
{
    int rc = 0;
    INM_MSG_T_CHANGE_PWD *inm_msg = (INM_MSG_T_CHANGE_PWD *)inm_buf;
    int type = inm_msg->header.inm_header.type;

    char sbuf[64];
    cJSON *json_req = cJSON_CreateObject();
    cJSON_AddNumberToObject(json_req, "type", type);
    sprintf(sbuf, "%010llu", inm_msg->header.terminalCode);
    cJSON_AddStringToObject(json_req, "term_code", sbuf);
    sprintf(sbuf, "%08llu", inm_msg->header.agencyCode);
    cJSON_AddStringToObject(json_req, "agency_code", sbuf);

    cJSON_AddNumberToObject(json_req, "teller_code", inm_msg->header.tellerCode);
    cJSON_AddStringToObject(json_req, "old_password", inm_msg->oldPassword);
    cJSON_AddStringToObject(json_req, "new_password", inm_msg->newPassword);
    char *req_buf = cJSON_PrintUnformatted(json_req);

    char resp_buf[INM_MSG_BUFFER_LENGTH] = {0};
    rc = otl_json_sp_pil(type, req_buf, resp_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("otldb_spcall_change_password() return %d", rc);
    }
    cJSON *json_resp = cJSON_Parse(resp_buf);
    cJSON *json_rc = cJSON_GetObjectItem(json_resp, "rc");
    rc = json_rc->valueint;
    if (rc != SYS_RESULT_SUCCESS)
    {
        log_debug("inquiry balance rc:%d", rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    free(req_buf); cJSON_Delete(json_req);
    return rc;
}

//inquiry game info
int otldb_spcall_game_info(char *inm_buf)
{
    int rc = 0;
    INM_MSG_T_GAME_INFO *inm_msg = (INM_MSG_T_GAME_INFO *)inm_buf;
    int type = inm_msg->header.inm_header.type;

    char sbuf[64];
    cJSON *json_req = cJSON_CreateObject();
    cJSON_AddNumberToObject(json_req, "type", type);
    sprintf(sbuf, "%010llu", inm_msg->header.terminalCode);
    cJSON_AddStringToObject(json_req, "term_code", sbuf);
    sprintf(sbuf, "%08llu", inm_msg->header.agencyCode);
    cJSON_AddStringToObject(json_req, "agency_code", sbuf);
    cJSON_AddNumberToObject(json_req, "teller_code", inm_msg->header.tellerCode);
    char *req_buf = cJSON_PrintUnformatted(json_req);

    char resp_buf[INM_MSG_BUFFER_LENGTH] = {0};
    rc = otl_json_sp_pil(type, req_buf, resp_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("otldb_spcall_game_info() return %d", rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_resp = cJSON_Parse(resp_buf);
    cJSON *json_rc = cJSON_GetObjectItem(json_resp, "rc");
    rc = json_rc->valueint;
    if (rc != SYS_RESULT_SUCCESS)
    {
        log_debug("game info rc:%d", rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }

    cJSON *json_param = cJSON_GetObjectItem(json_resp, "contact_address");
    strncpy(inm_msg->contactAddress,json_param->valuestring,AGENCY_ADDRESS_LENGTH);
    inm_msg->contactAddress[AGENCY_ADDRESS_LENGTH] = 0;
    json_param = cJSON_GetObjectItem(json_resp, "contact_phone");
    strncpy(inm_msg->contactPhone,json_param->valuestring,LOYALTY_CARD_LENGTH);
    inm_msg->contactPhone[LOYALTY_CARD_LENGTH] = 0;
    json_param = cJSON_GetObjectItem(json_resp, "ticket_slogan");
    strncpy(inm_msg->ticketSlogan,json_param->valuestring,TICKET_SLOGAN_LENGTH);
    inm_msg->ticketSlogan[TICKET_SLOGAN_LENGTH] = 0;

    free(req_buf); cJSON_Delete(json_req);
    return rc;
}

//inquiry agency account balance
int otldb_spcall_agency_balance(char *inm_buf)
{
    int rc = 0;
    INM_MSG_T_AGENCY_BALANCE *inm_msg = (INM_MSG_T_AGENCY_BALANCE *)inm_buf;
    int type = inm_msg->header.inm_header.type;

    char sbuf[64];
    cJSON *json_req = cJSON_CreateObject();
    cJSON_AddNumberToObject(json_req, "type", type);
    sprintf(sbuf, "%010llu", inm_msg->header.terminalCode);
    cJSON_AddStringToObject(json_req, "term_code", sbuf);
    sprintf(sbuf, "%08llu", inm_msg->header.agencyCode);
    cJSON_AddStringToObject(json_req, "agency_code", sbuf);
    cJSON_AddNumberToObject(json_req, "teller_code", inm_msg->header.tellerCode);
    char *req_buf = cJSON_PrintUnformatted(json_req);

    char resp_buf[INM_MSG_BUFFER_LENGTH] = {0};
    rc = otl_json_sp_pil(type, req_buf, resp_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("otldb_spcall_change_password() return %d", rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_resp = cJSON_Parse(resp_buf);
    cJSON *json_rc = cJSON_GetObjectItem(json_resp, "rc");
    rc = json_rc->valueint;
    if (rc != SYS_RESULT_SUCCESS)
    {
        log_debug("inquiry balance rc:%d", rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_param = cJSON_GetObjectItem(json_resp, "account_balance");
    inm_msg->accountBalance = json_param->valuedouble;
    json_param = cJSON_GetObjectItem(json_resp, "marginal_credit");
    inm_msg->marginalCreditLimit = json_param->valuedouble;

    free(req_buf); cJSON_Delete(json_req);
    return rc;
}

//inquiry inquiry ticket (inquiry win ticket)
int otldb_spcall_inquiry_ticket(char *inm_buf)
{
    int rc = 0;
    INM_MSG_T_INQUIRY_TICKET *inm_msg = (INM_MSG_T_INQUIRY_TICKET *)inm_buf;
    int type = inm_msg->header.inm_header.type;

    char sbuf[64];
    cJSON *json_req = cJSON_CreateObject();
    cJSON_AddNumberToObject(json_req, "type", type);
    sprintf(sbuf, "%010llu", inm_msg->header.terminalCode);
    cJSON_AddStringToObject(json_req, "term_code", sbuf);
    sprintf(sbuf, "%08llu", inm_msg->header.agencyCode);
    cJSON_AddStringToObject(json_req, "agency_code", sbuf);
    cJSON_AddNumberToObject(json_req, "teller_code", inm_msg->header.tellerCode);
    char *req_buf = cJSON_PrintUnformatted(json_req);

    char resp_buf[INM_MSG_BUFFER_LENGTH] = {0};
    rc = otl_json_sp_pil(type, req_buf, resp_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("otldb_spcall_inquiry_ticket() return %d", rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_resp = cJSON_Parse(resp_buf);
    cJSON *json_rc = cJSON_GetObjectItem(json_resp, "rc");
    rc = json_rc->valueint;
    if (rc != SYS_RESULT_SUCCESS)
    {
        log_debug("inquiry balance rc:%d", rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    free(req_buf); cJSON_Delete(json_req);
    return rc;
}

//sale ticket
void getBetOneLineStringByNum(char *betString, int idx, char *buf)
{
    int count = 0; char *ptr = NULL; int j = 0;
    char *pComma = strstr(betString, "(");
    while (pComma != NULL) {
        count++;
        if (count == idx) { ptr = pComma + 1; break; }
        pComma = strstr(pComma + 1, "(");
    }
    if (ptr != NULL) {
        while (*ptr != ')') { buf[j] = *ptr; ptr++; j++; }
    }
    return;
}

int otldb_spcall_sale(char *inm_buf)
{
    int rc = 0;
    INM_MSG_T_SELL_TICKET *inm_msg = (INM_MSG_T_SELL_TICKET *)inm_buf;
    int type = inm_msg->header.inm_header.type;

    char sbuf[64];
    cJSON *json_req = cJSON_CreateObject();
    cJSON_AddNumberToObject(json_req, "type", 1);

    if (inm_msg->header.inm_header.gltp_from == TICKET_FROM_AP)
    {
        type = INM_TYPE_AP_SELL_TICKET;
        sprintf(sbuf, "%010llu", 0);
        cJSON_AddStringToObject(json_req, "term_code", sbuf);
        cJSON_AddNumberToObject(json_req, "teller_code", 0);
    }
    else
    {
        sprintf(sbuf, "%010llu", inm_msg->header.terminalCode);
        cJSON_AddStringToObject(json_req, "term_code", sbuf);
        cJSON_AddNumberToObject(json_req, "teller_code", inm_msg->header.tellerCode);
    }

    sprintf(sbuf, "%08llu", inm_msg->header.agencyCode);
    cJSON_AddStringToObject(json_req, "agency_code", sbuf);

    cJSON_AddStringToObject(json_req, "applyflow_sell", inm_msg->reqfn_ticket);
    cJSON_AddStringToObject(json_req, "loyalty_code", "0");
    //cJSON_AddStringToObject(json_req, "loyalty_code", inm_msg->loyaltyNum);
    cJSON *ticket = cJSON_CreateObject();
    cJSON_AddNumberToObject(ticket, "game_code", inm_msg->ticket.gameCode);
    cJSON_AddNumberToObject(ticket, "issue_number", inm_msg->ticket.issue);
    cJSON_AddNumberToObject(ticket, "start_issue", inm_msg->ticket.issue);
    cJSON_AddNumberToObject(ticket, "end_issue", inm_msg->ticket.lastIssue);
    cJSON_AddNumberToObject(ticket, "issue_count", inm_msg->ticket.issueCount);
    cJSON_AddNumberToObject(ticket, "ticket_amount", inm_msg->ticket.amount);
    cJSON_AddNumberToObject(ticket, "ticket_bet_count", inm_msg->ticket.betCount);
    cJSON_AddNumberToObject(ticket, "bet_methold", inm_msg->ticket.flag);
    cJSON_AddNumberToObject(ticket, "bet_line", inm_msg->ticket.betlineCount);
    cJSON *bet_lineArray = cJSON_CreateArray();
    cJSON* item = NULL;
    TICKET  *tmpTicket = &(inm_msg->ticket);
    BETLINE *line = (BETLINE*)GL_BETLINE(tmpTicket);
    char tmpLine[128] = {0};
    for (int i = 0;i < inm_msg->ticket.betlineCount;i++) {
        item = cJSON_CreateObject();
        cJSON_AddStringToObject(item, "applyflow_sell", inm_msg->reqfn_ticket);
        cJSON_AddNumberToObject(item, "line_no", i);
        cJSON_AddNumberToObject(item, "bet_type", line->bettype);
        cJSON_AddNumberToObject(item, "subtype", line->subtype);
        cJSON_AddNumberToObject(item, "oper_type", line->flag);
        bzero(tmpLine, sizeof(tmpLine));
        getBetOneLineStringByNum(inm_msg->ticket.betString, i + 1, tmpLine);
        cJSON_AddStringToObject(item, "section", tmpLine);
        cJSON_AddNumberToObject(item, "bet_times", line->betTimes);
        cJSON_AddNumberToObject(item, "bet_count", line->betCount);
        cJSON_AddNumberToObject(item, "bet_amount", line->singleAmount * line->betCount * line->betTimes);
        cJSON_AddItemToArray(bet_lineArray, item);
        line = (BETLINE*)GL_BETLINE_NEXT(line);
    }
    cJSON_AddItemToObject(ticket, "bet_detail", bet_lineArray);
    cJSON_AddItemToObject(json_req, "ticket", ticket);
    char *req_buf = cJSON_PrintUnformatted(json_req);

    char resp_buf[INM_MSG_BUFFER_LENGTH] = {0};
    rc = otl_json_sp_pil(type, req_buf, resp_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("otldb_spcall_sale(%s) return %d", inm_msg->reqfn_ticket, rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_resp = cJSON_Parse(resp_buf);
    cJSON *json_rc = cJSON_GetObjectItem(json_resp, "rc");
    rc = json_rc->valueint;
    if (rc != SYS_RESULT_SUCCESS)
    {
        log_debug("sell rc:%d", rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_param = cJSON_GetObjectItem(json_resp, "is_train");
    inm_msg->ticket.isTrain = json_param->valueint; //����Ƿ�Ϊһ����ѵƱ
    json_param = cJSON_GetObjectItem(json_resp, "flownum");
    inm_msg->flowNumber = json_param->valuedouble;
    json_param = cJSON_GetObjectItem(json_resp, "account_balance");
    inm_msg->availableCredit = json_param->valuedouble;
    json_param = cJSON_GetObjectItem(json_resp, "marginal_credit");
    inm_msg->availableCredit += json_param->valuedouble;
    json_param = cJSON_GetObjectItem(json_resp, "commission_amount");
    inm_msg->commissionAmount += json_param->valuedouble;

    free(req_buf); cJSON_Delete(json_req);
    return rc;
}

//pay ticket
int otldb_spcall_pay(char *inm_buf)
{
    int rc = 0;
    INM_MSG_T_PAY_TICKET *inm_msg = (INM_MSG_T_PAY_TICKET *)inm_buf;
    int type = inm_msg->header.inm_header.type;

    char sbuf[64];
    cJSON *json_req = cJSON_CreateObject();
    cJSON_AddNumberToObject(json_req, "type", 3);
    sprintf(sbuf, "%010llu", inm_msg->header.terminalCode);
    cJSON_AddStringToObject(json_req, "term_code", sbuf);
    sprintf(sbuf, "%08llu", inm_msg->header.agencyCode);
    cJSON_AddStringToObject(json_req, "agency_code", sbuf);

    cJSON_AddNumberToObject(json_req, "teller_code", inm_msg->header.tellerCode);

    cJSON_AddStringToObject(json_req, "applyflow_pay", inm_msg->reqfn_ticket_pay);
    cJSON_AddNumberToObject(json_req, "is_train", inm_msg->isTrain);
    sprintf(sbuf, "%08llu", inm_msg->saleAgencyCode);
    cJSON_AddStringToObject(json_req, "sale_agency", sbuf);
    cJSON_AddStringToObject(json_req, "loyalty_code", "0");
    //cJSON_AddStringToObject(json_req, "loyalty_code", inm_msg->loyaltyNum);
    cJSON *ticket = cJSON_CreateObject();
    cJSON_AddStringToObject(ticket, "applyflow_sell", inm_msg->reqfn_ticket);
    cJSON_AddNumberToObject(ticket, "game_code", inm_msg->gameCode);
    cJSON_AddNumberToObject(ticket, "issue_number", inm_msg->issueNumber_pay);
    cJSON_AddNumberToObject(ticket, "winningamounttax", inm_msg->winningAmountWithTax);
    cJSON_AddNumberToObject(ticket, "winningamount", inm_msg->winningAmount);
    cJSON_AddNumberToObject(ticket, "taxamount", inm_msg->taxAmount);
    cJSON_AddNumberToObject(ticket, "winningcount", inm_msg->winningCount);
    cJSON_AddNumberToObject(ticket, "hd_winning", inm_msg->hd_winning);
    cJSON_AddNumberToObject(ticket, "hd_count", inm_msg->hd_count);
    cJSON_AddNumberToObject(ticket, "ld_winning", inm_msg->ld_winning);
    cJSON_AddNumberToObject(ticket, "ld_count", inm_msg->ld_count);
    cJSON_AddNumberToObject(ticket, "is_big_prize", inm_msg->isBigWinning);
    cJSON_AddItemToObject(json_req, "ticket", ticket);
    char *req_buf = cJSON_PrintUnformatted(json_req);

    char resp_buf[INM_MSG_BUFFER_LENGTH] = {0};
    rc = otl_json_sp_pil(type, req_buf, resp_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("otldb_spcall_pay(%s , %s) return %d", inm_msg->reqfn_ticket_pay, inm_msg->rspfn_ticket, rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_resp = cJSON_Parse(resp_buf);
    cJSON *json_rc = cJSON_GetObjectItem(json_resp, "rc");
    rc = json_rc->valueint;
    if (rc != SYS_RESULT_SUCCESS)
    {
        log_debug("term pay rc:%d", rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_param = cJSON_GetObjectItem(json_resp, "flownum");
    inm_msg->flowNumber = json_param->valuedouble;
    json_param = cJSON_GetObjectItem(json_resp, "account_balance");
    inm_msg->availableCredit = json_param->valuedouble;
    json_param = cJSON_GetObjectItem(json_resp, "marginal_credit");
    inm_msg->availableCredit += json_param->valuedouble;

    free(req_buf); cJSON_Delete(json_req);
    return rc;
}

//cancel ticket
int otldb_spcall_cancel(char *inm_buf)
{
    int rc = 0;
    INM_MSG_T_CANCEL_TICKET *inm_msg = (INM_MSG_T_CANCEL_TICKET *)inm_buf;
    int type = inm_msg->header.inm_header.type;

    char sbuf[64];
    cJSON *json_req = cJSON_CreateObject();
    cJSON_AddNumberToObject(json_req, "type", 2);
    sprintf(sbuf, "%010llu", inm_msg->header.terminalCode);
    cJSON_AddStringToObject(json_req, "term_code", sbuf);
    sprintf(sbuf, "%08llu", inm_msg->header.agencyCode);
    cJSON_AddStringToObject(json_req, "agency_code", sbuf);

    cJSON_AddNumberToObject(json_req, "teller_code", inm_msg->header.tellerCode);

    cJSON_AddStringToObject(json_req, "applyflow_cancel", inm_msg->reqfn_ticket_cancel);
    cJSON_AddNumberToObject(json_req, "is_train", inm_msg->ticket.isTrain);
    sprintf(sbuf, "%08llu", inm_msg->saleAgencyCode);
    cJSON_AddStringToObject(json_req, "sale_agency", sbuf);
    cJSON_AddStringToObject(json_req, "loyalty_code", "0");
    //cJSON_AddStringToObject(json_req, "loyalty_code", inm_msg->loyaltyNum);
    cJSON *ticket = cJSON_CreateObject();
    cJSON_AddStringToObject(ticket, "applyflow_sell", inm_msg->reqfn_ticket);
    cJSON_AddItemToObject(json_req, "ticket", ticket);
    char *req_buf = cJSON_PrintUnformatted(json_req);

    char resp_buf[INM_MSG_BUFFER_LENGTH] = {0};
    rc = otl_json_sp_pil(type, req_buf, resp_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("otldb_spcall_cancel(%s , %s) return %d", inm_msg->reqfn_ticket_cancel, inm_msg->rspfn_ticket, rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_resp = cJSON_Parse(resp_buf);
    cJSON *json_rc = cJSON_GetObjectItem(json_resp, "rc");
    rc = json_rc->valueint;
    if (rc != SYS_RESULT_SUCCESS)
    {
        log_debug("term cancel rc:%d", rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_param = cJSON_GetObjectItem(json_resp, "flownum");
    inm_msg->flowNumber = json_param->valuedouble;
    json_param = cJSON_GetObjectItem(json_resp, "account_balance");
    inm_msg->availableCredit = json_param->valuedouble;
    json_param = cJSON_GetObjectItem(json_resp, "marginal_credit");
    inm_msg->availableCredit += json_param->valuedouble;

    free(req_buf); cJSON_Delete(json_req);
    return rc;
}

//inquiry fbs ticket (inquiry fbs win ticket)
int otldb_spcall_fbs_inquiry_ticket(char *inm_buf)
{
    int rc = 0;
    INM_MSG_T_INQUIRY_TICKET *inm_msg = (INM_MSG_T_INQUIRY_TICKET *)inm_buf;
    //int type = inm_msg->header.inm_header.type;
    int type = INM_TYPE_T_INQUIRY_TICKET_DETAIL;//FBS�ĸ�����ͨ��ѯ����

    char sbuf[64];
    cJSON *json_req = cJSON_CreateObject();
    cJSON_AddNumberToObject(json_req, "type", type);
    sprintf(sbuf, "%010llu", inm_msg->header.terminalCode);
    cJSON_AddStringToObject(json_req, "term_code", sbuf);
    sprintf(sbuf, "%08llu", inm_msg->header.agencyCode);
    cJSON_AddStringToObject(json_req, "agency_code", sbuf);
    cJSON_AddNumberToObject(json_req, "teller_code", inm_msg->header.tellerCode);
    char *req_buf = cJSON_PrintUnformatted(json_req);

    char resp_buf[INM_MSG_BUFFER_LENGTH] = {0};
    rc = otl_json_sp_pil(type, req_buf, resp_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("otldb_spcall_fbs_inquiry_ticket() return %d", rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_resp = cJSON_Parse(resp_buf);
    cJSON *json_rc = cJSON_GetObjectItem(json_resp, "rc");
    rc = json_rc->valueint;
    if (rc != SYS_RESULT_SUCCESS)
    {
        log_debug("inquiry balance rc:%d", rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    free(req_buf); cJSON_Delete(json_req);
    return rc;
}

//sale fbs ticket
int otldb_spcall_fbs_sale(char *inm_buf)
{
    int rc = 0;
    INM_MSG_FBS_SELL_TICKET *inm_msg = (INM_MSG_FBS_SELL_TICKET *)inm_buf;
    //int type = inm_msg->header.inm_header.type;
    int type = INM_TYPE_T_SELL_TICKET;//FBS�ĸ�����ͨ��Ʊ����
    FBS_TICKET *tkt = (FBS_TICKET*)(inm_msg->betString + inm_msg->betStringLen);

    char sbuf[64];
    cJSON *json_req = cJSON_CreateObject();

    if (inm_msg->header.inm_header.gltp_from == TICKET_FROM_AP)
    {
        cJSON_AddNumberToObject(json_req, "type", 6);
    }
    else
    {
        cJSON_AddNumberToObject(json_req, "type", 1);
        sprintf(sbuf, "%010llu", inm_msg->header.terminalCode);
        cJSON_AddStringToObject(json_req, "term_code", sbuf);
        cJSON_AddNumberToObject(json_req, "teller_code", inm_msg->header.tellerCode);
    }

    sprintf(sbuf, "%08llu", inm_msg->header.agencyCode);
    cJSON_AddStringToObject(json_req, "agency_code", sbuf);

    cJSON_AddStringToObject(json_req, "applyflow_sell", inm_msg->reqfn_ticket);
    cJSON_AddStringToObject(json_req, "loyalty_code", "0");
    //cJSON_AddStringToObject(json_req, "loyalty_code", inm_msg->loyaltyNum);
    cJSON *ticket = cJSON_CreateObject();
    cJSON_AddNumberToObject(ticket, "game_code", tkt->game_code);
    cJSON_AddNumberToObject(ticket, "issue_number", tkt->issue_number);
    cJSON_AddNumberToObject(ticket, "start_issue", tkt->issue_number);
    cJSON_AddNumberToObject(ticket, "end_issue", tkt->issue_number);
    cJSON_AddNumberToObject(ticket, "issue_count", tkt->match_count); //������FBSʱΪmatch  Count
    cJSON_AddNumberToObject(ticket, "ticket_amount", tkt->bet_amount);
    cJSON_AddNumberToObject(ticket, "ticket_bet_count", tkt->bet_count);
    cJSON_AddNumberToObject(ticket, "bet_methold", tkt->flag);
    cJSON_AddNumberToObject(ticket, "bet_line", 1);
    cJSON *bet_lineArray = cJSON_CreateArray();
    cJSON* item = NULL;
    item = cJSON_CreateObject();
    cJSON_AddStringToObject(item, "applyflow_sell", inm_msg->reqfn_ticket);
    cJSON_AddNumberToObject(item, "line_no", 0);
    cJSON_AddNumberToObject(item, "bet_type", tkt->bet_type);
    cJSON_AddNumberToObject(item, "subtype", tkt->sub_type);
    cJSON_AddNumberToObject(item, "oper_type", 0);  //line->flag
    //bzero(tmpLine, sizeof(tmpLine));
    //getBetOneLineStringByNum(inm_msg->ticket.betString, i + 1, tmpLine);
    cJSON_AddStringToObject(item, "section", inm_msg->betString);
    cJSON_AddNumberToObject(item, "bet_times", tkt->bet_times);
    cJSON_AddNumberToObject(item, "bet_count", tkt->bet_count);
    cJSON_AddNumberToObject(item, "bet_amount", tkt->bet_amount);
    cJSON_AddItemToArray(bet_lineArray, item);


    cJSON_AddItemToObject(ticket, "bet_detail", bet_lineArray);
    cJSON_AddItemToObject(json_req, "ticket", ticket);
    char *req_buf = cJSON_PrintUnformatted(json_req);

    char resp_buf[INM_MSG_BUFFER_LENGTH] = {0};
    rc = otl_json_sp_pil(type, req_buf, resp_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("otldb_spcall_fbs_sale(%s) return %d", inm_msg->reqfn_ticket, rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_resp = cJSON_Parse(resp_buf);
    cJSON *json_rc = cJSON_GetObjectItem(json_resp, "rc");
    rc = json_rc->valueint;
    if (rc != SYS_RESULT_SUCCESS)
    {
        log_debug("sell rc:%d", rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_param = cJSON_GetObjectItem(json_resp, "is_train");
    tkt->is_train = json_param->valueint; //����Ƿ�Ϊһ����ѵƱ
    json_param = cJSON_GetObjectItem(json_resp, "flownum");
    inm_msg->flowNumber = json_param->valuedouble;
    json_param = cJSON_GetObjectItem(json_resp, "account_balance");
    inm_msg->availableCredit = json_param->valuedouble;
    json_param = cJSON_GetObjectItem(json_resp, "marginal_credit");
    inm_msg->availableCredit += json_param->valuedouble;
    //json_param = cJSON_GetObjectItem(json_resp, "commission_amount");
    //inm_msg->commissionAmount += json_param->valuedouble;

    free(req_buf); cJSON_Delete(json_req);
    return rc;
}

//pay fbs ticket
int otldb_spcall_fbs_pay(char *inm_buf)
{
    int rc = 0;
    INM_MSG_FBS_PAY_TICKET *inm_msg = (INM_MSG_FBS_PAY_TICKET *)inm_buf;
    //int type = inm_msg->header.inm_header.type;
    int type = INM_TYPE_T_PAY_TICKET;//FBS�ĸ��öҽ���Ʊ����

    char sbuf[64];
    cJSON *json_req = cJSON_CreateObject();
    cJSON_AddNumberToObject(json_req, "type", 3);
    sprintf(sbuf, "%010llu", inm_msg->header.terminalCode);
    cJSON_AddStringToObject(json_req, "term_code", sbuf);
    sprintf(sbuf, "%08llu", inm_msg->header.agencyCode);
    cJSON_AddStringToObject(json_req, "agency_code", sbuf);

    cJSON_AddNumberToObject(json_req, "teller_code", inm_msg->header.tellerCode);

    cJSON_AddStringToObject(json_req, "applyflow_pay", inm_msg->reqfn_ticket_pay);
    cJSON_AddNumberToObject(json_req, "is_train", inm_msg->isTrain);
    sprintf(sbuf, "%08llu", inm_msg->saleAgencyCode);
    cJSON_AddStringToObject(json_req, "sale_agency", sbuf);
    cJSON_AddStringToObject(json_req, "loyalty_code", "0");
    //cJSON_AddStringToObject(json_req, "loyalty_code", inm_msg->loyaltyNum);
    cJSON *ticket = cJSON_CreateObject();
    cJSON_AddStringToObject(ticket, "applyflow_sell", inm_msg->reqfn_ticket);
    cJSON_AddNumberToObject(ticket, "game_code", inm_msg->gameCode);
    cJSON_AddNumberToObject(ticket, "issue_number", inm_msg->issueNumber_pay);
    cJSON_AddNumberToObject(ticket, "winningamounttax", inm_msg->winningAmountWithTax);
    cJSON_AddNumberToObject(ticket, "winningamount", inm_msg->winningAmount);
    cJSON_AddNumberToObject(ticket, "taxamount", inm_msg->taxAmount);
    cJSON_AddNumberToObject(ticket, "winningcount", inm_msg->winningCount);
    cJSON_AddNumberToObject(ticket, "hd_winning", inm_msg->hd_winning);
    cJSON_AddNumberToObject(ticket, "hd_count", inm_msg->hd_count);
    cJSON_AddNumberToObject(ticket, "ld_winning", inm_msg->ld_winning);
    cJSON_AddNumberToObject(ticket, "ld_count", inm_msg->ld_count);
    cJSON_AddNumberToObject(ticket, "is_big_prize", inm_msg->isBigWinning);
    cJSON_AddItemToObject(json_req, "ticket", ticket);
    char *req_buf = cJSON_PrintUnformatted(json_req);

    char resp_buf[INM_MSG_BUFFER_LENGTH] = {0};
    rc = otl_json_sp_pil(type, req_buf, resp_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("otldb_spcall_fbs_pay(%s , %s) return %d", inm_msg->reqfn_ticket_pay, inm_msg->rspfn_ticket, rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_resp = cJSON_Parse(resp_buf);
    cJSON *json_rc = cJSON_GetObjectItem(json_resp, "rc");
    rc = json_rc->valueint;
    if (rc != SYS_RESULT_SUCCESS)
    {
        log_debug("term pay rc:%d", rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_param = cJSON_GetObjectItem(json_resp, "flownum");
    inm_msg->flowNumber = json_param->valuedouble;
    json_param = cJSON_GetObjectItem(json_resp, "account_balance");
    inm_msg->availableCredit = json_param->valuedouble;
    json_param = cJSON_GetObjectItem(json_resp, "marginal_credit");
    inm_msg->availableCredit += json_param->valuedouble;

    free(req_buf); cJSON_Delete(json_req);
    return rc;



}

//cancel fbs ticket
int otldb_spcall_fbs_cancel(char *inm_buf)
{
    int rc = 0;
    INM_MSG_FBS_CANCEL_TICKET *inm_msg = (INM_MSG_FBS_CANCEL_TICKET *)inm_buf;
    //int type = inm_msg->header.inm_header.type;
    int type = INM_TYPE_T_CANCEL_TICKET;//FBS�ĸ�����ͨ��Ʊ����

    char sbuf[64];
    cJSON *json_req = cJSON_CreateObject();
    cJSON_AddNumberToObject(json_req, "type", 2);
    sprintf(sbuf, "%010llu", inm_msg->header.terminalCode);
    cJSON_AddStringToObject(json_req, "term_code", sbuf);
    sprintf(sbuf, "%08llu", inm_msg->header.agencyCode);
    cJSON_AddStringToObject(json_req, "agency_code", sbuf);

    cJSON_AddNumberToObject(json_req, "teller_code", inm_msg->header.tellerCode);

    cJSON_AddStringToObject(json_req, "applyflow_cancel", inm_msg->reqfn_ticket_cancel);
    cJSON_AddNumberToObject(json_req, "is_train", inm_msg->ticket.is_train);
    sprintf(sbuf, "%08llu", inm_msg->saleAgencyCode);
    cJSON_AddStringToObject(json_req, "sale_agency", sbuf);
    cJSON_AddStringToObject(json_req, "loyalty_code", "0");
    //cJSON_AddStringToObject(json_req, "loyalty_code", inm_msg->loyaltyNum);
    cJSON *ticket = cJSON_CreateObject();
    cJSON_AddStringToObject(ticket, "applyflow_sell", inm_msg->reqfn_ticket);
    cJSON_AddItemToObject(json_req, "ticket", ticket);
    char *req_buf = cJSON_PrintUnformatted(json_req);

    char resp_buf[INM_MSG_BUFFER_LENGTH] = {0};
    rc = otl_json_sp_pil(type, req_buf, resp_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("otldb_spcall_fbs_cancel(%s , %s) return %d", inm_msg->reqfn_ticket_cancel, inm_msg->rspfn_ticket, rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_resp = cJSON_Parse(resp_buf);
    cJSON *json_rc = cJSON_GetObjectItem(json_resp, "rc");
    rc = json_rc->valueint;
    if (rc != SYS_RESULT_SUCCESS)
    {
        log_debug("term cancel rc:%d", rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_param = cJSON_GetObjectItem(json_resp, "flownum");
    inm_msg->flowNumber = json_param->valuedouble;
    json_param = cJSON_GetObjectItem(json_resp, "account_balance");
    inm_msg->availableCredit = json_param->valuedouble;
    json_param = cJSON_GetObjectItem(json_resp, "marginal_credit");
    inm_msg->availableCredit += json_param->valuedouble;

    free(req_buf); cJSON_Delete(json_req);
    return rc;
}


//oms pay ticket
int otldb_spcall_oms_pay(char *inm_buf)
{
    int rc = 0;
    INM_MSG_O_PAY_TICKET *inm_msg = (INM_MSG_O_PAY_TICKET *)inm_buf;
    int type = inm_msg->header.inm_header.type;

    char sbuf[64];
    cJSON *json_req = cJSON_CreateObject();
    cJSON_AddNumberToObject(json_req, "type", 5);
    sprintf(sbuf, "%02u", inm_msg->areaCode_pay);
    cJSON_AddStringToObject(json_req, "org_code", sbuf);

    cJSON_AddStringToObject(json_req, "applyflow_pay", inm_msg->reqfn_ticket_pay);
    cJSON_AddNumberToObject(json_req, "is_train", 0);
    sprintf(sbuf, "%08llu", inm_msg->saleAgencyCode);
    cJSON_AddStringToObject(json_req, "sale_agency", sbuf);
    cJSON_AddStringToObject(json_req, "loyalty_code", "0");
    cJSON *ticket = cJSON_CreateObject();
    cJSON_AddStringToObject(ticket, "applyflow_sell", inm_msg->reqfn_ticket);
    cJSON_AddNumberToObject(ticket, "game_code", inm_msg->gameCode);
    cJSON_AddNumberToObject(ticket, "issue_number", inm_msg->issueNumber_pay);
    cJSON_AddNumberToObject(ticket, "winningamounttax", inm_msg->winningAmountWithTax);
    cJSON_AddNumberToObject(ticket, "winningamount", inm_msg->winningAmount);
    cJSON_AddNumberToObject(ticket, "taxamount", inm_msg->taxAmount);
    cJSON_AddNumberToObject(ticket, "winningcount", inm_msg->winningCount);
    cJSON_AddNumberToObject(ticket, "hd_winning", inm_msg->hd_winning);
    cJSON_AddNumberToObject(ticket, "hd_count", inm_msg->hd_count);
    cJSON_AddNumberToObject(ticket, "ld_winning", inm_msg->ld_winning);
    cJSON_AddNumberToObject(ticket, "ld_count", inm_msg->ld_count);
    cJSON_AddNumberToObject(ticket, "is_big_prize", inm_msg->isBigWinning);
    cJSON_AddItemToObject(json_req, "ticket", ticket);
    char *req_buf = cJSON_PrintUnformatted(json_req);

    char resp_buf[INM_MSG_BUFFER_LENGTH] = {0};
    rc = otl_json_sp_pil(type, req_buf, resp_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("otldb_spcall_oms_pay(%s , %s) return %d", inm_msg->reqfn_ticket_pay, inm_msg->rspfn_ticket, rc);

        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_resp = cJSON_Parse(resp_buf);
    cJSON *json_rc = cJSON_GetObjectItem(json_resp, "rc");
    rc = json_rc->valueint;
    if (rc != SYS_RESULT_SUCCESS)
    {
        log_debug("inquiry balance rc:%d", rc);
    }
    free(req_buf); cJSON_Delete(json_req);
    return rc;
}

//central pay fbs ticket
int otldb_spcall_oms_fbs_pay(char *inm_buf)
{
    int rc = 0;
    INM_MSG_O_FBS_PAY_TICKET *inm_msg = (INM_MSG_O_FBS_PAY_TICKET *)inm_buf;
    //int type = inm_msg->header.inm_header.type;
    int type = INM_TYPE_O_PAY_TICKET;//FBS�ĸ���OMS�ҽ�����

    char sbuf[64];
    cJSON *json_req = cJSON_CreateObject();
    cJSON_AddNumberToObject(json_req, "type", 5);
    sprintf(sbuf, "%02u", inm_msg->areaCode_pay);
    cJSON_AddStringToObject(json_req, "org_code", sbuf);

    cJSON_AddStringToObject(json_req, "applyflow_pay", inm_msg->reqfn_ticket_pay);
    cJSON_AddNumberToObject(json_req, "is_train", 0);
    sprintf(sbuf, "%08llu", inm_msg->saleAgencyCode);
    cJSON_AddStringToObject(json_req, "sale_agency", sbuf);
    cJSON_AddStringToObject(json_req, "loyalty_code", "0");
    cJSON *ticket = cJSON_CreateObject();
    cJSON_AddStringToObject(ticket, "applyflow_sell", inm_msg->reqfn_ticket);
    cJSON_AddNumberToObject(ticket, "game_code", inm_msg->gameCode);
    cJSON_AddNumberToObject(ticket, "issue_number", inm_msg->issueNumber_pay);
    cJSON_AddNumberToObject(ticket, "winningamounttax", inm_msg->winningAmountWithTax);
    cJSON_AddNumberToObject(ticket, "winningamount", inm_msg->winningAmount);
    cJSON_AddNumberToObject(ticket, "taxamount", inm_msg->taxAmount);
    cJSON_AddNumberToObject(ticket, "winningcount", inm_msg->winningCount);
    cJSON_AddNumberToObject(ticket, "hd_winning", 0);
    cJSON_AddNumberToObject(ticket, "hd_count", 0);
    cJSON_AddNumberToObject(ticket, "ld_winning", 0);
    cJSON_AddNumberToObject(ticket, "ld_count", 0);
    cJSON_AddNumberToObject(ticket, "is_big_prize", inm_msg->isBigWinning);
    cJSON_AddItemToObject(json_req, "ticket", ticket);
    char *req_buf = cJSON_PrintUnformatted(json_req);

    char resp_buf[INM_MSG_BUFFER_LENGTH] = {0};
    rc = otl_json_sp_pil(type, req_buf, resp_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("otldb_spcall_oms_fbs_pay(%s , %s) return %d", inm_msg->reqfn_ticket_pay, inm_msg->rspfn_ticket, rc);

        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_resp = cJSON_Parse(resp_buf);
    cJSON *json_rc = cJSON_GetObjectItem(json_resp, "rc");
    rc = json_rc->valueint;
    if (rc != SYS_RESULT_SUCCESS)
    {
        log_debug("inquiry balance rc:%d", rc);
    }
    free(req_buf); cJSON_Delete(json_req);
    return rc;
}

//oms cancel ticket
int otldb_spcall_oms_cancel(char *inm_buf)
{
    int rc = 0;
    INM_MSG_O_CANCEL_TICKET *inm_msg = (INM_MSG_O_CANCEL_TICKET *)inm_buf;
    int type = inm_msg->header.inm_header.type;

    char sbuf[64];
    cJSON *json_req = cJSON_CreateObject();
    cJSON_AddNumberToObject(json_req, "type", 4);
    sprintf(sbuf, "%02u", inm_msg->areaCode_cancel);
    cJSON_AddStringToObject(json_req, "org_code", sbuf);

    cJSON_AddNumberToObject(json_req, "is_train", 0);
    sprintf(sbuf, "%08llu", inm_msg->saleAgencyCode);
    cJSON_AddStringToObject(json_req, "sale_agency", sbuf);
    cJSON_AddStringToObject(json_req, "loyalty_code", "0");
    cJSON_AddStringToObject(json_req, "applyflow_cancel", inm_msg->reqfn_ticket_cancel);
    cJSON *ticket = cJSON_CreateObject();
    cJSON_AddStringToObject(ticket, "applyflow_sell", inm_msg->reqfn_ticket);
    cJSON_AddItemToObject(json_req, "ticket", ticket);
    char *req_buf = cJSON_PrintUnformatted(json_req);

    char resp_buf[INM_MSG_BUFFER_LENGTH] = {0};
    rc = otl_json_sp_pil(type, req_buf, resp_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("otldb_spcall_oms_cancel(%s , %s) return %d", inm_msg->reqfn_ticket_cancel, inm_msg->rspfn_ticket, rc);

        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_resp = cJSON_Parse(resp_buf);
    cJSON *json_rc = cJSON_GetObjectItem(json_resp, "rc");
    rc = json_rc->valueint;
    if (rc != SYS_RESULT_SUCCESS)
    {
        log_debug("inquiry balance rc:%d", rc);
    }
    free(req_buf); cJSON_Delete(json_req);
    return rc;
}

//central cancel fbs ticket
int otldb_spcall_oms_fbs_cancel(char *inm_buf)
{
    int rc = 0;
    INM_MSG_O_FBS_CANCEL_TICKET *inm_msg = (INM_MSG_O_FBS_CANCEL_TICKET *)inm_buf;
    int type = INM_TYPE_O_CANCEL_TICKET;//FBS�ĸ���OMS��Ʊ����

    char sbuf[64];
    cJSON *json_req = cJSON_CreateObject();
    cJSON_AddNumberToObject(json_req, "type", 4);
    sprintf(sbuf, "%02u", inm_msg->areaCode_cancel);
    cJSON_AddStringToObject(json_req, "org_code", sbuf);

    cJSON_AddNumberToObject(json_req, "is_train", 0);
    sprintf(sbuf, "%08llu", inm_msg->saleAgencyCode);
    cJSON_AddStringToObject(json_req, "sale_agency", sbuf);
    cJSON_AddStringToObject(json_req, "loyalty_code", "0");
    cJSON_AddStringToObject(json_req, "applyflow_cancel", inm_msg->reqfn_ticket_cancel);
    cJSON *ticket = cJSON_CreateObject();
    cJSON_AddStringToObject(ticket, "applyflow_sell", inm_msg->reqfn_ticket);
    cJSON_AddItemToObject(json_req, "ticket", ticket);
    char *req_buf = cJSON_PrintUnformatted(json_req);

    char resp_buf[INM_MSG_BUFFER_LENGTH] = {0};
    rc = otl_json_sp_pil(type, req_buf, resp_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("otldb_spcall_oms_fbs_cancel(%s , %s) return %d", inm_msg->reqfn_ticket_cancel, inm_msg->rspfn_ticket, rc);

        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_resp = cJSON_Parse(resp_buf);
    cJSON *json_rc = cJSON_GetObjectItem(json_resp, "rc");
    rc = json_rc->valueint;
    if (rc != SYS_RESULT_SUCCESS)
    {
        log_debug("inquiry balance rc:%d", rc);
    }
    free(req_buf); cJSON_Delete(json_req);
    return rc;
}


//term online
int otldb_spcall_term_online(char *inm_buf)
{
    int rc = 0;
    TMS_TERMINAL_RECORD *pTerm = (TMS_TERMINAL_RECORD *)inm_buf;
    int type = GLTP_N_TERM_NETWORK_DELAY;

    char sbuf[64];
    cJSON *json_req = cJSON_CreateObject();
    cJSON_AddNumberToObject(json_req, "type", type);
    sprintf(sbuf, "%010llu", pTerm->termCode);
    cJSON_AddStringToObject(json_req, "term_code", sbuf);
    cJSON_AddNumberToObject(json_req, "begin_time", pTerm->beginOnline);
    cJSON_AddNumberToObject(json_req, "online_seconds", (get_now() - pTerm->beginOnline));
    char *req_buf = cJSON_PrintUnformatted(json_req);

    char resp_buf[INM_MSG_BUFFER_LENGTH] = { 0 };
    rc = otl_json_sp_pil(INM_TYPE_N_HB, req_buf, resp_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("otldb_spcall_signin() return %d", rc);
        free(req_buf); cJSON_Delete(json_req);
        return rc;
    }
    cJSON *json_resp = cJSON_Parse(resp_buf);
    cJSON *json_rc = cJSON_GetObjectItem(json_resp, "rc");
    rc = json_rc->valueint;

    log_debug("otldb_spcall_term_online rc:[%d] ", rc);
    free(req_buf); cJSON_Delete(json_req);
    return rc;
}

#if 0



��֤��
    in: mac,version
    out: term_code, agency_code, org_code
    ����MAC��ַ�ж��ն˴��ڣ���״̬���ã��ж�����������վ�Ͳ��Ŵ����ҿ��ã����򷵻� SYS_RESULT_T_AUTHENTICATE_ERR = 4, //��֤ʧ��
    �ж��ն˻������а汾���ã����򷵻�SYS_RESULT_VERSION_NOT_AVAILABLE_ERR = 39,  //�����汾������

��¼��
    in:  term_code, agency_code, teller_code, passwrod
    out: teller_type,flownum,account_balance,marginal_credit
    �ж�Teller���ڣ�״̬���ã�������ȷ�����򷵻� SYS_RESULT_T_NAMEPWD_ERR = 5, //�û������������
    �жϵ�¼���ն˻������ҿ��ã��ж�����������վ�Ͳ��Ŵ����ҿ��ã����򷵻أ�SYS_RESULT_T_TELLER_DISABLE_ERR = 8, //����Ա������
    �ж�Teller����վ�� �� �ն�����վ�� �Ƿ�ƥ�䣬���򷵻�SYS_RESULT_T_TELLER_UNAUTHEN_ERR = 12, //Teller����վ����ն�����վ�㲻ƥ��
    �ж�teller�Ƿ��ѵ�¼�����ն˻������򷵻�SYS_RESULT_T_TELLER_SIGNED_IN_ERR = 67, //������Ա�ѵ�¼�����ն˻�
    �жϴ��ն˻����Ƿ�������teller��¼�������򷵻�SYS_RESULT_T_TERM_SIGNED_IN_ERR = 10, //���ն˻�����������Ա��¼
    ����teller�ĵ�¼״̬����½���ն˻�����½ʱ��
ǩ�ˣ�
    in:  term_code, agency_code, teller_code
    out: 
    �ж�Teller���ڣ�����teller�ĵ�¼״̬����½���ն˻�����½ʱ��
    ǩ�˲���ȷ���ɹ�

ͨ��У�飺
    �ն˻�������Ա��վ�㼰�������ţ������ҿ��ã�����д������� SYS_RESULT_T_TOKEN_EXPIRED_ERR = 68,//tokenʧЧ����Ҫ������֤
    �ж�teller�ѵ�¼�����򷵻� SYS_RESULT_T_TELLER_SIGNOUT_ERR = 9, //����Աδ��¼

��Ϸ��Ϣ����
    in:  term_code, agency_code, teller_code
    out: contact_address, contact_phone, ticket_slogan
    ͨ��У��
    ���ؿ��õ���Ϸ�б�

�˻�����ѯ��
    in:  term_code, agency_code, teller_code
    out: account_balance, marginal_credit
    ͨ��У��
    �����˻��������ö��

��Ʊ��ѯ����
    in:  term_code, agency_code, teller_code
    out: 
    ͨ��У��

�޸����룺
    in:  term_code, agency_code, teller_code, old_password, new_password
    out: 
    ͨ��У��
    �жϾ�������ȷ�����������Ҫ��SYS_RESULT_T_NAMEPWD_ERR = 5, //�û������������

���ۣ�
    in:  term_code, agency_code, teller_code, ...
    out: is_train(0/1)

    ��Ʊ ������� -----------------------------------------------------------
    {
        'type':1,
        'applyflow_sell':'(ptf->reqfn_ticket)'
        'terminal_code':(ptf->header.terminalCode),
        'teller_code':(ptf->header.tellerCode),
        'agency_code':(ptf->header.agencyCode),
        'ticket': {
            'game_code':(ptf->ticket.gameCode),
            'issue_number':(ptf->ticket.issue),
            'start_issue':(ptf->ticket.issue),
            'end_issue':(ptf->ticket.lastIssue),
            'issue_count':(ptf->ticket.issueCount),
            'ticket_amount':(ptf->ticket.amount),
            'ticket_bet_count':(ptf->ticket.betCount),
            'bet_methold':(ptf->ticket.flag),  //������ö��ת��
            'bet_line':(ptf->ticket.betlineCount),
            'det_detail': [
                {
                    'applyflow_sell':'(ptf->reqfn_ticket)',
                    'line_no':(i),
                    'bet_type':(line->bettype),
                    'subtype':(line->subtype),
                    'oper_type':(line->flag),
                    'section':'(����ѡ���ַ���)',
                    'bet_times':(line->betTimes), //���б���
                    'bet_count':(line->betCount), //����ע��
                    'bet_amount':(line->singleAmount * line->betCount * line->betTimes) //���н��
                },
                {
                    ͬ��
                },
                ...
            ]
        },
        'flownum':87989,
        'loyalty_code':'(ptf->loyaltyNum)',
    }
    ��Ʊ ��Ӧ����
    {
        'type':1,
        'rc':0,
        'applyflow_sell':'(ptf->reqfn_ticket)'
        'agency_code':(ptf->header.agencyCode),
        'is_train':0
        'account_balance':1536637,
        'marginal_credit':1536637
    }

    ͨ��У��
    �ж�վ�� �� ���� ����Ϸ������Ȩ���ã����򷵻�SYS_RESULT_SELL_DISABLE_ERR; //��Ϸ�������ۣ�������վ����Ϸ������У�飩
    У��teller����ѵԱ�����������Ų�Ʊ����ѵƱ����ѵƱ����¼���ۼ�¼
    У�������򷵻�SYS_RESULT_SELL_LACK_AMOUNT_ERR; //�˻�����澯
    SP���ء���ѵģʽ���ı��

�ҽ���
    in:  term_code, agency_code, teller_code, is_train(0/1), ...
    out: 

    �ҽ� �������----------------------------------------------------------------
    {
        'type':3,
        'applyflow_pay':'(ptf->reqfn_ticket_pay)',
        'terminal_code':(ptf->header.terminalCode),
        'teller_code':(ptf->header.tellerCode),
        'agency_code':(ptf->header.agencyCode),
        'ticket': {
            'applyflow_sell':'(ptf->reqfn_ticket)',
            'game_code':(ptf->gameCode),
            'issue_number':(ptf->issueNumber_pay),
            'winningamounttax':(ptf->winningAmountWithTax),
            'winningamount':(ptf->winningAmount),
            'taxamount':(ptf->taxAmount),
            'winningcount':(ptf->winningCount),
            'hd_winning':(ptf->hd_winning),
            'hd_count':(ptf->hd_count),
            'ld_winning':(ptf->ld_winning),
            'ld_count':(ptf->ld_count),
            'is_big_prize':(ptf->isBigWinning)
        }
        'is_train':0,
        'loyalty_code':'(ptf->loyaltyNum)',
    }
    �ҽ� ��Ӧ����
    {
        'type':3,
        'rc':0,
        'applyflow_pay':'(ptf->reqfn_ticket_pay)',
        'agency_code':(ptf->header.agencyCode),
        'ticket': {
            'applyflow_sell':'(ptf->reqfn_ticket)'
        }
        'flownum':87989,
        'account_balance':1536637,
        'marginal_credit':1536637
    }
    ͨ��У��
    �ж�վ�� �� ���� ����Ϸ�ҽ���Ȩ���ã����򷵻�SYS_RESULT_PAY_DISABLE_ERR;  //��Ϸ���ɶҽ���������վ����Ϸ�ɶҽ�У�飩
    �ҽ���Χ�ж���SYS_RESULT_CLAIMING_SCOPE_ERR = 19, //�����϶ҽ���Χ
    ��ѵƱֻ��������ѵԱ�ҽ�����ͨteller���ܶҽ���ѵƱ�����򷵻� SYS_RESULT_T_TELLER_UNAUTHEN_ERR; //����Ա��Ȩ����(����) 
    ����Ʊ��������ѵԱ�ҽ������򷵻� SYS_RESULT_T_TELLER_UNAUTHEN_ERR; //����Ա��Ȩ����(����) 

��Ʊ��
    in:  term_code, agency_code, teller_code, is_train(0/1), ...
    out: 

    ��Ʊ �������------------------------------------------------------------------
    {
        'type':2,
        'applyflow_cancel':'(ptf->reqfn_ticket_cancel)',
        'terminal_code':(ptf->header.terminalCode),
        'teller_code':(ptf->header.tellerCode),
        'agency_code':(ptf->header.agencyCode),
        'ticket': {
            'applyflow_sell':'(ptf->reqfn_ticket)'
        }
        'is_train':0
        'loyalty_code':'(ptf->loyaltyNum)',
    }
    ��Ʊ ��Ӧ����
    {
        'type':2,
        'rc':0,
        'applyflow_cancel':'(ptf->reqfn_ticket_cancel)',
        'agency_code':(ptf->header.agencyCode),
        'ticket': {
            'applyflow_sell':'(ptf->reqfn_ticket)'
        }
        'flownum':87989,
        'account_balance':1536637,
        'marginal_credit':1536637
    }
    ͨ��У��
    �ж�վ�� �� ���� ����Ϸ��Ʊ��Ȩ���ã����򷵻�SYS_RESULT_CANCEL_DISABLE_ERR; //��Ϸ������Ʊ��������վ����Ϸ����ƱУ�飩
    ��ѵƱֻ��������ѵԱ��Ʊ����ͨteller��������ѵƱ�����򷵻� SYS_RESULT_T_TELLER_UNAUTHEN_ERR; //����Ա��Ȩ����(����) 
    ����Ʊ��������ѵԱ��Ʊ�����򷵻� SYS_RESULT_T_TELLER_UNAUTHEN_ERR; //����Ա��Ȩ����(����)


��ѵģʽ�ж���
    teller����ѵԱ��������ѵģʽ��������ɾ���ն˻��ϵ���ѵģʽ�ֶΣ���������Ա�������ж��Ƿ�Ϊ��ѵģʽ��


�ҽ���Χ�жϣ�
    �Զҽ�վ�����õĶҽ���ΧΪ׼���ٻ�ȡ��Ʊվ��ı�ţ�Ȼ������ж�
    �ҽ���Χ������ֵ��ͬվ��ҽ���ͬ���Ŷҽ���ȫ��˾�ҽ���



agency��վ��澯 ���ۼ����������������ֶ�ȡ����
��Զҽ�����Ʊ�������ڽ����ظ��ҽ�����Ʊ��У�飬�����ݿ����Ψһ�Ա�֤


������Ʊ �������-------------------------------------------------------------
{
    'type':4,
    'applyflow_cancel':'(ptf->reqfn_ticket_cancel)',
    'org_code':(ptf->header.areaCode),
    'ticket': {
        'applyflow_sell':'(ptf->reqfn_ticket)'
    }
}
������Ʊ ��Ӧ����
{
    'type':4,
    'rc':0,
}


���Ķҽ� �������------------------------------------------------------------
{
    'type':5,
    'applyflow_pay':'(ptf->reqfn_ticket_pay)',
    'org_code':(ptf->header.areaCode),
    'ticket': {
        'applyflow_sell':'(ptf->reqfn_ticket)',
        'game_code':(ptf->gameCode),
        'issue_number':(ptf->issueNumber_pay),
        'winningamounttax':(ptf->winningAmountWithTax),
        'winningamount':(ptf->winningAmount),
        'taxamount':(ptf->taxAmount),
        'winningcount':(ptf->winningCount),
        'hd_winning':(ptf->hd_winning),
        'hd_count':(ptf->hd_count),
        'ld_winning':(ptf->ld_winning),
        'ld_count':(ptf->ld_count),
        'is_big_prize':(ptf->isBigWinning)
    }
}
���Ķҽ� ��Ӧ����
{
    'type':5,
    'rc':0,
}



#endif
