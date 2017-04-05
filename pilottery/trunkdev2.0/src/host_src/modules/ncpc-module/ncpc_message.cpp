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
        //先打开新文件，打开成功后再关闭旧文件，
        //这样可以避免在磁盘写满打开新文件失败时出现调用两次fclose导致崩溃的情况发生。
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
        //先打开新文件，打开成功后再关闭旧文件，
        //这样可以避免在磁盘写满打开新文件失败时出现调用两次fclose导致崩溃的情况发生。
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

//根据终端编码和flownumber生成流水号 flag 1: sale  flag 2: pay  flag 3: cancel
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
    //心跳
    {GLTP_MSG_TYPE_NCP, GLTP_N_HB, R_NCP_hb_process, q_ncpc_send, S_NCP_hb_process},
    //echo消息
    {GLTP_MSG_TYPE_NCP, GLTP_N_ECHO_REQ, R_NCP_echo_process, q_tfe_adder, S_NCP_echo_process},
    //终端连接/断开报告
    {GLTP_MSG_TYPE_NCP, GLTP_N_TERMINAL_CONN, R_NCP_termconn_process, 0, NULL}, //rpt
    //终端网络延迟时间
    {GLTP_MSG_TYPE_NCP, GLTP_N_TERM_NETWORK_DELAY, R_NCP_network_delay_process, 0, NULL}, //rpt
    //游戏期信息
    {GLTP_MSG_TYPE_NCP, GLTP_N_GAME_ISSUE_REQ, R_NCP_gameissue_process, q_ncpc_send, S_NCP_gameissue_process}, //rpt

    //------------------------------------------------------------------------------------------------
    // terminal process cell
    //------------------------------------------------------------------------------------------------
    //echo消息
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_ECHO_REQ, R_TERM_echo_process, q_tfe_adder, S_TERM_echo_process},
    //销售员登入
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_SIGNIN_REQ, R_TERM_signin_process, q_ncpc_send, S_TERM_signin_process},
    //销售员签退
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_SIGNOUT_REQ, R_TERM_signout_process, q_ncpc_send, S_TERM_signout_process},
    //销售员修改密码
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_CHANGE_PWD_REQ, R_TERM_changepwd_process, q_ncpc_send, S_TERM_changepwd_process},
    //销售站余额查询
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_AGENCY_BALANCE_REQ, R_TERM_agencybalance_process, q_ncpc_send, S_TERM_agencybalance_process},
    //游戏信息
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_GAME_INFO_REQ, R_TERM_gameinfo_process, q_ncpc_send, S_TERM_gameinfo_process},
    //彩票销售
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_SELL_TICKET_REQ, R_TERM_sellticket_process, q_tfe_adder, S_TERM_sellticket_process},
    //彩票查询
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_INQUIRY_TICKET_REQ, R_TERM_inquiryticket_process, q_ncpc_send, S_TERM_inquiryticket_process},
    //彩票兑奖
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_PAY_TICKET_REQ, R_TERM_payticket_process, q_tfe_adder, S_TERM_payticket_process},
    //彩票取消
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_CANCEL_TICKET_REQ, R_TERM_cancelticket_process, q_tfe_adder, S_TERM_cancelticket_process},
    //彩票中奖查询
    {GLTP_MSG_TYPE_TERMINAL, GLTP_T_INQUIRY_WIN_REQ, R_TERM_inquiryWin_process, q_ncpc_send, S_TERM_inquiryWin_process},
    // FBS  比赛信息查询
    {GLTP_MSG_TYPE_TERMINAL, GLTP_FBS_INQUIRY_MATCH_REQ, R_TERM_fbs_inquiryMatch_process, q_ncpc_send, S_TERM_fbs_inquiryMatch_process},


    //------------------------------------------------------------------------------------------------
    // terminal uns process cell
    //------------------------------------------------------------------------------------------------
    //游戏开始
    {GLTP_MSG_TYPE_TERMINAL_UNS, GLTP_T_UNS_OPEN_GAME, NULL, 0, S_TERM_UNS_gameopen_process},
    //游戏结束倒计时
    //{GLTP_MSG_TYPE_TERMINAL_UNS, GLTP_T_UNS_CLOSE_SECONDS, NULL, 0, S_TERM_UNS_gameclosing_process},
    //游戏结束
    {GLTP_MSG_TYPE_TERMINAL_UNS, GLTP_T_UNS_CLOSE_GAME, NULL, 0, S_TERM_UNS_gameclose_process},
    //游戏开奖公告
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
    //echo消息
    {GLTP_O_ECHO_REQ, R_OMS_echo_process, q_ncpc_http_send, S_OMS_echo_process},
    //主机运行状态
    {GLTP_O_INQUIRY_SYSTEM_REQ, R_OMS_inquiry_system_process, q_ncpc_http_send, S_OMS_inquiry_system_process},
    //游戏政策参数
    {GLTP_O_GL_POLICY_PARAM_REQ, R_OMS_gl_policy_param_process, q_ncpc_http_send, S_OMS_gl_policy_param_process},
    //游戏普通规则参数
    {GLTP_O_GL_RULE_PARAM_REQ, R_OMS_gl_rule_param_process, q_ncpc_http_send, S_OMS_gl_rule_param_process},
    //游戏控制参数
    {GLTP_O_GL_CTRL_PARAM_REQ, R_OMS_gl_ctrl_param_process, q_ncpc_http_send, S_OMS_gl_ctrl_param_process},
    //游戏风险控制参数
    {GLTP_O_GL_RISK_CTRL_PARAM_REQ, R_OMS_gl_riskctrl_param_process, q_ncpc_http_send, S_OMS_gl_riskctrl_param_process},
    //游戏销售控制
    {GLTP_O_GL_SALE_CTRL_REQ, R_OMS_gl_sale_ctrl_process, q_ncpc_http_send, S_OMS_gl_sale_ctrl_process},
    //游戏兑奖控制
    {GLTP_O_GL_PAY_CTRL_REQ, R_OMS_gl_pay_ctrl_process, q_ncpc_http_send, S_OMS_gl_pay_ctrl_process},
    //游戏退票控制
    {GLTP_O_GL_CANCEL_CTRL_REQ, R_OMS_gl_cancel_ctrl_process, q_ncpc_http_send, S_OMS_gl_cancel_ctrl_process},
    //游戏自动开奖控制
    {GLTP_O_GL_AUTO_DRAW_REQ, R_OMS_gl_autodraw_process, q_ncpc_http_send, S_OMS_gl_autodraw_process},
    //游戏服务时段设置
    {GLTP_O_GL_SERVICE_TIME_REQ, R_OMS_gl_servicetime_process, q_ncpc_http_send, S_OMS_gl_servicetime_process},
    //游戏告警阈值设置
    {GLTP_O_GL_WARN_THRESHOLD_REQ, R_OMS_gl_warn_threshold_process, q_ncpc_http_send, S_OMS_gl_warn_threshold_process},

    //撤销期次
    {GLTP_O_GL_ISSUE_DELETE_REQ, R_OMS_gl_issue_delete_process, q_gl_driver, S_OMS_gl_issue_delete_process},
    //期次开奖（二次开奖-备用）
    {GLTP_O_GL_ISSUE_SECOND_DRAW_REQ, R_OMS_gl_issue_second_draw_process, q_ncpc_http_send, S_OMS_gl_issue_second_draw_process},
    //期结 –> 开奖号码录入
    {GLTP_O_GL_ISSUE_INPUT_DRAW_RESULT_REQ, R_OMS_gl_issue_input_drawresult_process, q_ncpc_http_send, S_OMS_gl_issue_input_drawresult_process},
    //期结 -> 游戏奖池参数 (目前未实现)
    //期结 –> 奖级奖金录入
    {GLTP_O_GL_ISSUE_INPUT_PRIZE_REQ, R_OMS_gl_issue_prize_process, q_ncpc_http_send, S_OMS_gl_issue_prize_process},
    //期结 –> 分发稽核数据摘要
    {GLTP_O_GL_ISSUE_FILE_MD5SUM_REQ, R_OMS_gl_issue_md5sum_process, q_ncpc_http_send, S_OMS_gl_issue_md5sum_process},
    //期结 –> 开奖确认
    {GLTP_O_GL_ISSUE_DRAW_CONFIRM_REQ, R_OMS_gl_issue_draw_confirm_process, q_ncpc_http_send, S_OMS_gl_issue_draw_confirm_process},
    //期结 –> 重新开奖
    {GLTP_O_GL_ISSUE_REDO_DRAW_REQ, R_OMS_gl_issue_redo_draw_process, q_ncpc_http_send, S_OMS_gl_issue_redo_draw_process},
    //新增期次通知消息
    {GLTP_O_GL_ISSUE_ADD_NFY_REQ, R_OMS_gl_issue_add_nfy_process, q_gl_driver, S_OMS_gl_issue_add_nfy_process},

    //彩票查询
    {GLTP_O_TICKET_INQUIRY_REQ, R_OMS_ticket_inquiry_process, q_ncpc_http_send, S_OMS_ticket_inquiry_process},
    //彩票兑奖
    {GLTP_O_TICKET_PAY_REQ, R_OMS_ticket_pay_process, q_tfe_adder, S_OMS_ticket_pay_process},
    //彩票退票
    {GLTP_O_TICKET_CANCEL_REQ, R_OMS_ticket_cancel_process, q_tfe_adder, S_OMS_ticket_cancel_process},
	
	// FBS
//    //彩票查询
//    {GLTP_O_FBS_TICKET_INQUIRY_REQ, R_OMS_fbs_ticket_inquiry_process, q_ncpc_http_send, S_OMS_fbs_ticket_inquiry_process},
//    //彩票兑奖
//    {GLTP_O_FBS_TICKET_PAY_REQ, R_OMS_fbs_ticket_pay_process, q_tfe_adder, S_OMS_fbs_ticket_pay_process},
//    //彩票退票
//    {GLTP_O_FBS_TICKET_CANCEL_REQ, R_OMS_fbs_ticket_cancel_process, q_tfe_adder, S_OMS_fbs_ticket_cancel_process},
    // FBS 新增比赛通知消息
    {GLTP_O_FBS_ADD_MATCH_NFY_REQ, R_OMS_fbs_add_match_nfy_process, q_fbs_driver, S_OMS_fbs_add_match_nfy_process},
    // FBS 删除比赛
    //{GLTP_O_FBS_DELETE_MATCH_REQ, R_OMS_fbs_del_match_process, q_fbs_driver, S_OMS_fbs_del_match_process},
    // FBS 启用/停用比赛
    {GLTP_O_FBS_MATCH_STATUS_CTRL_REQ, R_OMS_fbs_match_state_ctrl_process, q_fbs_driver, S_OMS_fbs_match_state_ctrl_process},
    // FBS 比赛开奖 –> 录入开奖号码
    {GLTP_O_FBS_DRAW_INPUT_RESULT_REQ, R_OMS_fbs_draw_input_result_process, q_ncpc_http_send, S_OMS_fbs_draw_input_result_process},
    // FBS 比赛开奖 –> 开奖结果确认
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
    inm_msg->ticket.isTrain = json_param->valueint; //标记是否为一张培训票
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
    int type = INM_TYPE_T_INQUIRY_TICKET_DETAIL;//FBS的复用普通查询类型

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
    int type = INM_TYPE_T_SELL_TICKET;//FBS的复用普通售票类型
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
    cJSON_AddNumberToObject(ticket, "issue_count", tkt->match_count); //期数：FBS时为match  Count
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
    tkt->is_train = json_param->valueint; //标记是否为一张培训票
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
    int type = INM_TYPE_T_PAY_TICKET;//FBS的复用兑奖售票类型

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
    int type = INM_TYPE_T_CANCEL_TICKET;//FBS的复用普通退票类型

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
    int type = INM_TYPE_O_PAY_TICKET;//FBS的复用OMS兑奖类型

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
    int type = INM_TYPE_O_CANCEL_TICKET;//FBS的复用OMS退票类型

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



认证：
    in: mac,version
    out: term_code, agency_code, org_code
    根据MAC地址判断终端存在，且状态可用，判断所属的销售站和部门存在且可用，否则返回 SYS_RESULT_T_AUTHENTICATE_ERR = 4, //认证失败
    判断终端机的运行版本可用，否则返回SYS_RESULT_VERSION_NOT_AVAILABLE_ERR = 39,  //软件版本不可用

登录：
    in:  term_code, agency_code, teller_code, passwrod
    out: teller_type,flownum,account_balance,marginal_credit
    判断Teller存在，状态可用，密码正确；否则返回 SYS_RESULT_T_NAMEPWD_ERR = 5, //用户名或密码错误
    判断登录的终端机存在且可用，判断所属的销售站和部门存在且可用，否则返回：SYS_RESULT_T_TELLER_DISABLE_ERR = 8, //销售员不可用
    判断Teller所属站点 和 终端所属站点 是否匹配，否则返回SYS_RESULT_T_TELLER_UNAUTHEN_ERR = 12, //Teller所属站点和终端所属站点不匹配
    判断teller是否已登录其他终端机，否则返回SYS_RESULT_T_TELLER_SIGNED_IN_ERR = 67, //此销售员已登录其他终端机
    判断此终端机上是否有其他teller登录，，否则返回SYS_RESULT_T_TERM_SIGNED_IN_ERR = 10, //此终端机上已有销售员登录
    更新teller的登录状态，登陆的终端机，登陆时间
签退：
    in:  term_code, agency_code, teller_code
    out: 
    判断Teller存在，更新teller的登录状态，登陆的终端机，登陆时间
    签退操作确定成功

通用校验：
    终端机、销售员、站点及所属部门，存在且可用，如果有错，返回 SYS_RESULT_T_TOKEN_EXPIRED_ERR = 68,//token失效，需要重新认证
    判断teller已登录，否则返回 SYS_RESULT_T_TELLER_SIGNOUT_ERR = 9, //销售员未登录

游戏信息请求：
    in:  term_code, agency_code, teller_code
    out: contact_address, contact_phone, ticket_slogan
    通用校验
    返回可用的游戏列表

账户余额查询：
    in:  term_code, agency_code, teller_code
    out: account_balance, marginal_credit
    通用校验
    返回账户余额和信用额度

彩票查询请求：
    in:  term_code, agency_code, teller_code
    out: 
    通用校验

修改密码：
    in:  term_code, agency_code, teller_code, old_password, new_password
    out: 
    通用校验
    判断旧密码正确，新密码符合要求，SYS_RESULT_T_NAMEPWD_ERR = 5, //用户名或密码错误

销售：
    in:  term_code, agency_code, teller_code, ...
    out: is_train(0/1)

    售票 请求参数 -----------------------------------------------------------
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
            'bet_methold':(ptf->ticket.flag),  //这里有枚举转换
            'bet_line':(ptf->ticket.betlineCount),
            'det_detail': [
                {
                    'applyflow_sell':'(ptf->reqfn_ticket)',
                    'line_no':(i),
                    'bet_type':(line->bettype),
                    'subtype':(line->subtype),
                    'oper_type':(line->flag),
                    'section':'(单行选号字符串)',
                    'bet_times':(line->betTimes), //单行倍数
                    'bet_count':(line->betCount), //单行注数
                    'bet_amount':(line->singleAmount * line->betCount * line->betTimes) //单行金额
                },
                {
                    同上
                },
                ...
            ]
        },
        'flownum':87989,
        'loyalty_code':'(ptf->loyaltyNum)',
    }
    售票 响应参数
    {
        'type':1,
        'rc':0,
        'applyflow_sell':'(ptf->reqfn_ticket)'
        'agency_code':(ptf->header.agencyCode),
        'is_train':0
        'account_balance':1536637,
        'marginal_credit':1536637
    }

    通用校验
    判断站点 和 部门 的游戏销售授权可用，否则返回SYS_RESULT_SELL_DISABLE_ERR; //游戏不可销售（含区域、站点游戏可销售校验）
    校验teller是培训员，如果是则此张彩票是培训票，培训票不记录销售记录
    校验余额，否则返回SYS_RESULT_SELL_LACK_AMOUNT_ERR; //账户金额不足告警
    SP返回‘培训模式’的标记

兑奖：
    in:  term_code, agency_code, teller_code, is_train(0/1), ...
    out: 

    兑奖 请求参数----------------------------------------------------------------
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
    兑奖 响应参数
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
    通用校验
    判断站点 和 部门 的游戏兑奖授权可用，否则返回SYS_RESULT_PAY_DISABLE_ERR;  //游戏不可兑奖（含区域、站点游戏可兑奖校验）
    兑奖范围判定，SYS_RESULT_CLAIMING_SCOPE_ERR = 19, //不符合兑奖范围
    培训票只可以由培训员兑奖，普通teller不能兑奖培训票，否则返回 SYS_RESULT_T_TELLER_UNAUTHEN_ERR; //销售员授权错误(保护) 
    正常票不能由培训员兑奖，否则返回 SYS_RESULT_T_TELLER_UNAUTHEN_ERR; //销售员授权错误(保护) 

退票：
    in:  term_code, agency_code, teller_code, is_train(0/1), ...
    out: 

    退票 请求参数------------------------------------------------------------------
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
    退票 响应参数
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
    通用校验
    判断站点 和 部门 的游戏退票授权可用，否则返回SYS_RESULT_CANCEL_DISABLE_ERR; //游戏不可退票（含区域、站点游戏可退票校验）
    培训票只可以由培训员退票，普通teller不能退培训票，否则返回 SYS_RESULT_T_TELLER_UNAUTHEN_ERR; //销售员授权错误(保护) 
    正常票不能由培训员退票，否则返回 SYS_RESULT_T_TELLER_UNAUTHEN_ERR; //销售员授权错误(保护)


培训模式判定：
    teller是培训员，则是培训模式，（建议删除终端机上的培训模式字段，仅由销售员的类型判定是否为培训模式）


兑奖范围判断：
    以兑奖站点配置的兑奖范围为准，再获取售票站点的编号，然后进行判断
    兑奖范围的配置值（同站点兑奖、同部门兑奖、全公司兑奖）



agency的站点告警 （累计销售张树、金额等字段取消）
针对兑奖和退票主机不在进行重复兑奖和退票的校验，由数据库根据唯一性保证


中心退票 请求参数-------------------------------------------------------------
{
    'type':4,
    'applyflow_cancel':'(ptf->reqfn_ticket_cancel)',
    'org_code':(ptf->header.areaCode),
    'ticket': {
        'applyflow_sell':'(ptf->reqfn_ticket)'
    }
}
中心退票 响应参数
{
    'type':4,
    'rc':0,
}


中心兑奖 请求参数------------------------------------------------------------
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
中心兑奖 响应参数
{
    'type':5,
    'rc':0,
}



#endif

