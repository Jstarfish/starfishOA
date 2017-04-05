#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <errno.h>
#include <netinet/in.h>
#include <strings.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <stdint.h>
#include <string.h>
#include <signal.h>
#include <fcntl.h>
#include <time.h>

#include "ev.h"

//c++ stl
#include <map>
#include <list>
using namespace std;
using namespace __gnu_cxx;

typedef int8_t    int8;
typedef uint8_t   uint8;
typedef int16_t   int16;
typedef uint16_t  uint16;
typedef int32_t   int32;
typedef uint32_t  uint32;
typedef int64_t   int64;
typedef uint64_t  uint64;
typedef int64_t   money_t;
#include "../src/gltp_message.h"


#define CONNECTED 1
#define DISCONNECTED 0

#define PORT 20000
#define BUFFER_SIZE (1024*8)

#define log_level 0
//log level
#define II  0
#define WW  1
#define EE  2
#define logit(flag, fmt, varlist...) \
    do { \
        char ff[4]; \
        if (flag==II) sprintf(ff,"II"); else if (flag==WW) sprintf(ff,"WW"); else if (flag==EE) sprintf(ff,"EE"); else sprintf(ff,"**"); \
        if (flag<log_level) break; \
        char time_string[96]; \
        struct timeval tv; \
        struct tm ptm; \
        gettimeofday(&tv, NULL); \
        localtime_r(&tv.tv_sec, &ptm); \
        sprintf(time_string, "%04d-%02d-%02d %02d:%02d:%02d.%06ld", ptm.tm_year + 1900, ptm.tm_mon + 1, ptm.tm_mday, ptm.tm_hour, ptm.tm_min, ptm.tm_sec, (long)(tv.tv_usec)); \
        fprintf(stderr, "[%s][ %s ][%d][%s@%s:%d]-> "fmt"\n", time_string, ff, getpid(), __FUNCTION__, __FILE__, __LINE__, ##varlist); \
        fflush(stderr); \
    } while (0)



typedef struct _connection
{
    int cfd;
    char ip[16];
    int port;
    char r_buf[BUFFER_SIZE];
    int r_size;
    int r_offset;
    time_t last_update;

    ev_io *watcher;
    struct ev_loop* loop;
} connection;

map<int, connection*> conn_map;
connection* get_connection(int socket)
{
    if (1 == conn_map.count(socket))
        return conn_map[socket];
    return NULL;
}
void set_connection(int socket, connection *c)
{
    conn_map[socket] = c;
}

void del_connection(int socket)
{
    map<int, connection*>::iterator iter;
    iter = conn_map.find(socket);
    if (iter != conn_map.end())
        conn_map.erase(iter);
}

int proc_ncp_hb_msg(char *in_buf, char *out_buf)
{
    GLTP_MSG_N_HB *hb = (GLTP_MSG_N_HB *)in_buf;
    GLTP_MSG_N_HB *hbrsp = (GLTP_MSG_N_HB *)out_buf;
    hbrsp->header.length = sizeof(GLTP_MSG_N_HB);
    hbrsp->header.type = GLTP_MSG_TYPE_NCP;
    hbrsp->header.func = GLTP_N_HB;
    hbrsp->header.when = time(NULL);
    logit(II, "HB message. (%u)", hb->header.when);
    return 0;
}

int proc_ncp_echo_msg(char *in_buf, char *out_buf)
{
    GLTP_MSG_N_ECHO_REQ *req = (GLTP_MSG_N_ECHO_REQ *)in_buf;
    GLTP_MSG_N_ECHO_RSP *rsp = (GLTP_MSG_N_ECHO_RSP *)out_buf;
    rsp->header.length = sizeof(GLTP_MSG_N_ECHO_RSP) + 2;
    rsp->header.type = GLTP_MSG_TYPE_NCP;
    rsp->header.func = GLTP_N_ECHO_RSP;

    char tmp_string[200] = {0};
    int len = (req->echo_len>=200)?199:req->echo_len;
    memcpy(tmp_string, req->echo_str, len); tmp_string[len] = 0;
    rsp->echo_len = sprintf(rsp->echo_str, "Welcome, I'm TaiShan System. ---> %s <---", tmp_string);

    logit(II, "ECHO (1): NCP msg (%s)", tmp_string);
    return 0;
}

int proc_ncp_term_conn_report(char *in_buf)
{
    GLTP_MSG_N_TERMINAL_CONN *report = (GLTP_MSG_N_TERMINAL_CONN *)in_buf;
    if (report->conn == CONNECTED)
        logit(II, "CONN REPORT (1001): token (%lu) connected at (%u)", report->token, report->timestamp);
    if (report->conn == DISCONNECTED)
        logit(II, "CONN REPORT (1001): token (%lu) disconnected at (%u)", report->token, report->timestamp);
    return 0;
}

int proc_ncp_term_network_delay(char *in_buf)
{
    GLTP_MSG_N_TERM_NETWORK_DELAY *delay = (GLTP_MSG_N_TERM_NETWORK_DELAY *)in_buf;
    logit(II, "NET DELAY (1002): token (%lu) timestamp (%u) delay (%u)",
             delay->token, delay->timestamp, delay->delayMilliSeconds);
    return 0;
}

int proc_ncp_msg(char *in_buf, char *out_buf)
{
    GLTP_MSG_N_HEADER *ncp = (GLTP_MSG_N_HEADER *)in_buf;
    switch (ncp->func)
    {
        case GLTP_N_HB:
            if (0 > proc_ncp_hb_msg(in_buf, out_buf)) {
                logit(EE, "proc_ncp_hb_msg() failed");
                return -1;
            }
            break;
        case GLTP_N_ECHO_REQ:
            if (0 > proc_ncp_echo_msg(in_buf, out_buf)) {
                logit(EE, "proc_ncp_echo_msg() failed");
                return -1;
            }
            break;
        case GLTP_N_TERMINAL_CONN:
            if (0 > proc_ncp_term_conn_report(in_buf)) {
                logit(EE, "proc_ncp_term_conn_report() failed");
                return -1;
            }
            break;
        case GLTP_N_TERM_NETWORK_DELAY:
            if (0 > proc_ncp_term_network_delay(in_buf)) {
                logit(EE, "proc_ncp_term_network_delay() failed");
                return -1;
            }
            break;
        default:
        {
            logit(EE, "unknown ncp message func [%hu]", ncp->func);
            return -1;
        }
    }
    return 0;
}


static int token = 101010;
static uint64_t global_terminal_code = 110100000101;
static int base_tsn = 1;

int proc_term_echo(char *in_buf, char *out_buf)
{
    GLTP_MSG_T_ECHO_REQ *req = (GLTP_MSG_T_ECHO_REQ *)in_buf;
    GLTP_MSG_T_ECHO_RSP *rsp = (GLTP_MSG_T_ECHO_RSP *)out_buf;    
    rsp->header.type = GLTP_MSG_TYPE_TERMINAL;
    rsp->header.func = GLTP_T_ECHO_RSP;
    rsp->header.when = time(NULL);
    rsp->header.token = req->header.token;
    rsp->header.identify = req->header.identify;
    rsp->header.msn = 0;
    rsp->header.param = 0;
    rsp->header.status = 0;

    char tmp_string[200] = {0};
    int len = (req->echo_len>=200)?199:req->echo_len;
    memcpy(tmp_string, req->echo_str, len); tmp_string[len] = 0;
    rsp->echo_len = sprintf(rsp->echo_str, "Welcome, I'm TaiShan System. ---> %s <---", tmp_string);
    rsp->header.length = sizeof(GLTP_MSG_T_ECHO_RSP) + rsp->echo_len + 2;

    logit(II, "ECHO (1): token (%lu) msg (%s)", req->header.token, req->echo_str);
    return 0;
}

int proc_term_auth(char *in_buf, char *out_buf)
{
    GLTP_MSG_T_AUTH_REQ *req = (GLTP_MSG_T_AUTH_REQ *)in_buf;
    GLTP_MSG_T_AUTH_RSP *rsp = (GLTP_MSG_T_AUTH_RSP *)out_buf;
    rsp->header.length = sizeof(GLTP_MSG_T_AUTH_RSP);
    rsp->header.type = GLTP_MSG_TYPE_TERMINAL;
    rsp->header.func = GLTP_T_AUTH_RSP;
    rsp->header.when = time(NULL);
    rsp->header.token = token++;
    rsp->header.identify = req->header.identify;
    rsp->header.msn = 0;
    rsp->header.param = 0;
    rsp->header.status = 0;
    rsp->timeStamp = time(NULL);
    rsp->terminalCode = global_terminal_code; global_terminal_code += 100;
    rsp->agencyCode = rsp->terminalCode/100;
    rsp->areaCode = 1;
    //rsp->crc is set by ncp

    logit(II, "AUTH (3001): mac (%02x:%02x:%02x:%02x:%02x:%02x) token (%lu) terminalCode (%ld) assigned",
             req->mac[0], req->mac[1], req->mac[2], req->mac[3], req->mac[4], req->mac[5],
             rsp->header.token, rsp->terminalCode);
    return 0;
}

int proc_term_game_info(char *in_buf, char *out_buf)
{
    GLTP_MSG_T_GAME_INFO_REQ *req = (GLTP_MSG_T_GAME_INFO_REQ *)in_buf;
    GLTP_MSG_T_GAME_INFO_RSP *rsp = (GLTP_MSG_T_GAME_INFO_RSP *)out_buf;
    rsp->header.length = sizeof(GLTP_MSG_T_GAME_INFO_RSP) + sizeof(GAME_INFO) + 2;
    rsp->header.type = GLTP_MSG_TYPE_TERMINAL;
    rsp->header.func = GLTP_T_GAME_INFO_RSP;
    rsp->header.when = time(NULL);
    rsp->header.token = req->header.token;
    rsp->header.identify = req->header.identify;
    rsp->header.msn = req->header.msn;
    rsp->header.param = 0;
    rsp->header.status = 0;
    rsp->timeStamp = time(NULL);
    strcpy(rsp->contactAddress, "a dummy address");
    strcpy(rsp->contactPhone, "62601980");
    strcpy(rsp->ticketSlogan, "this is a test");

    rsp->gameCount = 1;
    rsp->gameArray[0].gameCode = 7;
    strcpy(rsp->gameArray[0].singleAmount, "ZX=2000,ZXHALF=1000");
    rsp->gameArray[0].maxAmountPerTicket = 10000000;
    rsp->gameArray[0].maxBetTimes = 1000;
    rsp->gameArray[0].maxIssueCount = 12;
    rsp->gameArray[0].currentIssueNumber = 2014001;
    rsp->gameArray[0].currentIssueCloseTime = time(NULL) + 604800;
    //rsp->crc is set by ncp

    logit(II, "GAME INFO (3003): token (%lu)", rsp->header.token);
    return 0;
}

int proc_term_sell_ticket(char *in_buf, char *out_buf)
{
    GLTP_MSG_T_SELL_TICKET_REQ *req = (GLTP_MSG_T_SELL_TICKET_REQ *)in_buf;
    GLTP_MSG_T_SELL_TICKET_RSP *rsp = (GLTP_MSG_T_SELL_TICKET_RSP *)out_buf;
    rsp->header.length = sizeof(GLTP_MSG_T_SELL_TICKET_RSP);
    rsp->header.type = GLTP_MSG_TYPE_TERMINAL;
    rsp->header.func = GLTP_T_SELL_TICKET_RSP;
    rsp->header.when = time(NULL);
    rsp->header.token = req->header.token;
    rsp->header.identify = req->header.identify;
    rsp->header.msn = req->header.msn;
    rsp->header.param = 0;
    rsp->header.status = 0;
    rsp->timeStamp = time(NULL);

    char ticket_buf[30] = {0};
    snprintf(ticket_buf, TSN_LENGTH, "0123456789abcdef%08d", base_tsn++);
    ticket_buf[24] = '\0';
    strncpy(rsp->rspfn_ticket, ticket_buf, TSN_LENGTH);

    rsp->availableCredit = 99999999;
    rsp->gameCode = 1;
    rsp->currentIssueNumber = 0;
    rsp->flowNumber = random() % 131072;
    rsp->transTimeStamp = time(NULL);
    rsp->transAmount = 10000;
    rsp->drawTimeStamp = time(NULL) + 604800 * 7;
    //rsp->crc is set by ncp
    
    char betString[512] = {0};
    memcpy(betString, req->betString, req->betStringLen);

    logit(II, "SELL (3005): token (%lu), msn (%u), tsn (%s) flow (%ld) (%s)",
            rsp->header.token, rsp->header.msn,
            rsp->rspfn_ticket, rsp->flowNumber, betString);
    return 0;
}

int proc_term_inquiry_ticket(char *in_buf, char *out_buf)
{
    GLTP_MSG_T_INQUIRY_TICKET_REQ *req = (GLTP_MSG_T_INQUIRY_TICKET_REQ *)in_buf;
    GLTP_MSG_T_INQUIRY_TICKET_RSP *rsp = (GLTP_MSG_T_INQUIRY_TICKET_RSP *)out_buf;
    rsp->betStringLen = strlen("null");
    rsp->header.length = sizeof(GLTP_MSG_T_INQUIRY_TICKET_RSP) + rsp->betStringLen + 2;
    rsp->header.type = GLTP_MSG_TYPE_TERMINAL;
    rsp->header.func = GLTP_T_INQUIRY_TICKET_RSP;
    rsp->header.when = time(NULL);
    rsp->header.token = req->header.token;
    rsp->header.identify = req->header.identify;
    rsp->header.msn = req->header.msn;
    rsp->header.param = 0;
    rsp->header.status = 0;
    rsp->timeStamp = time(NULL);

    strcpy(rsp->rspfn_ticket, req->rspfn_ticket);
    strcpy(rsp->betString, "null");
    //rsp->crc is set by ncp

    logit(II, "INQUIRY (3007): token (%lu) msn (%u) status (%hu) tsn (%s)",
             rsp->header.token, rsp->header.msn, rsp->header.status, rsp->rspfn_ticket);
    return 0;
}

int proc_term_pay_ticket(char *in_buf, char *out_buf)
{
    GLTP_MSG_T_PAY_TICKET_REQ *req = (GLTP_MSG_T_PAY_TICKET_REQ *)in_buf;
    GLTP_MSG_T_PAY_TICKET_RSP *rsp = (GLTP_MSG_T_PAY_TICKET_RSP *)out_buf;
    //rsp->betStringLen = strlen("null");
    //rsp->header.length = sizeof(GLTP_MSG_T_PAY_TICKET_RSP) + rsp->betStringLen + 2;
    rsp->header.length = sizeof(GLTP_MSG_T_PAY_TICKET_RSP);
    rsp->header.type = GLTP_MSG_TYPE_TERMINAL;
    rsp->header.func = GLTP_T_PAY_TICKET_RSP;
    rsp->header.when = time(NULL);
    rsp->header.token = req->header.token;
    rsp->header.identify = req->header.identify;
    rsp->header.msn = req->header.msn;
    rsp->header.param = 0;
    rsp->header.status = 0;
    rsp->timeStamp = time(NULL);

    strcpy(rsp->rspfn_ticket_pay, req->rspfn_ticket);
    rsp->availableCredit = 99999999;
    rsp->gameCode = 1;
    rsp->flowNumber = random() % 131072;
    rsp->winningAmountWithTax = 1010000;
    rsp->taxAmount = 10000;
    rsp->winningAmount = 1000000;
    rsp->transTimeStamp = time(NULL);
    //strcpy(rsp->betString, "null");
    //rsp->crc is set by ncp

    logit(II, "PAY (3009): token (%lu), msn (%u), tsn (%s) flow (%ld)",
        rsp->header.token, rsp->header.msn, rsp->rspfn_ticket_pay, rsp->flowNumber);
    return 0;
}

int proc_term_cancel_ticket(char *in_buf, char *out_buf)
{
    GLTP_MSG_T_CANCEL_TICKET_REQ *req = (GLTP_MSG_T_CANCEL_TICKET_REQ *)in_buf;
    GLTP_MSG_T_CANCEL_TICKET_RSP *rsp = (GLTP_MSG_T_CANCEL_TICKET_RSP *)out_buf;
    rsp->header.length = sizeof(GLTP_MSG_T_CANCEL_TICKET_RSP);
    rsp->header.type = GLTP_MSG_TYPE_TERMINAL;
    rsp->header.func = GLTP_T_CANCEL_TICKET_RSP;
    rsp->header.when = time(NULL);
    rsp->header.token = req->header.token;
    rsp->header.identify = req->header.identify;
    rsp->header.msn = req->header.msn;
    rsp->header.param = 0;
    rsp->header.status = 0;
    rsp->timeStamp = time(NULL);

    strcpy(rsp->rspfn_ticket_cancel, req->rspfn_ticket);
    rsp->availableCredit = 99999999;
    rsp->gameCode = 1;
    rsp->flowNumber = random() % 131072;
    rsp->transTimeStamp = time(NULL);
    rsp->cancelAmount = 10000;
    //rsp->crc is set by ncp

    logit(II, "CANCEL (3011): token (%lu), msn (%u), tsn (%s) flow (%ld)",
        rsp->header.token, rsp->header.msn, rsp->rspfn_ticket_cancel, rsp->flowNumber);
    return 0;
}

int proc_term_signin(char *in_buf, char *out_buf)
{
    GLTP_MSG_T_SIGNIN_REQ *req = (GLTP_MSG_T_SIGNIN_REQ *)in_buf;
    GLTP_MSG_T_SIGNIN_RSP *rsp = (GLTP_MSG_T_SIGNIN_RSP *)out_buf;
    rsp->header.length = sizeof(GLTP_MSG_T_SIGNIN_RSP);
    rsp->header.type = GLTP_MSG_TYPE_TERMINAL;
    rsp->header.func = GLTP_T_SIGNIN_RSP;
    rsp->header.when = time(NULL);
    rsp->header.token = req->header.token;
    rsp->header.identify = req->header.identify;
    rsp->header.msn = req->header.msn;
    rsp->header.param = 0;
    rsp->header.status = 0;
    rsp->timeStamp = time(NULL);
    rsp->tellerCode = req->tellerCode;
    rsp->tellerType = 1;
    rsp->availableCredit = 1000000;
    rsp->forceModifyPwd = 0;
    //rsp->crc is set by ncp

    logit(II, "SIGNIN (3013): token (%lu) teller (%u) passwd (%s)",
             rsp->header.token, req->tellerCode, req->password);
    return 0;
}

int proc_term_signout(char *in_buf, char *out_buf)
{
    GLTP_MSG_T_SIGNOUT_REQ *req = (GLTP_MSG_T_SIGNOUT_REQ *)in_buf;
    GLTP_MSG_T_SIGNOUT_RSP *rsp = (GLTP_MSG_T_SIGNOUT_RSP *)out_buf;
    rsp->header.length = sizeof(GLTP_MSG_T_SIGNOUT_RSP);
    rsp->header.type = GLTP_MSG_TYPE_TERMINAL;
    rsp->header.func = GLTP_T_SIGNOUT_RSP;
    rsp->header.when = time(NULL);
    rsp->header.token = req->header.token;
    rsp->header.identify = req->header.identify;
    rsp->header.msn = req->header.msn;
    rsp->header.param = 0;
    rsp->header.status = 0;
    rsp->timeStamp = time(NULL);
    //rsp->crc is set by ncp

    logit(II, "SIGNOUT (3015): token (%lu), teller (%u)", rsp->header.token, 
             req->tellerCode);
    return 0;
}

int proc_term_change_pwd(char *in_buf, char *out_buf)
{
    GLTP_MSG_T_CHANGE_PWD_REQ *req = (GLTP_MSG_T_CHANGE_PWD_REQ *)in_buf;
    GLTP_MSG_T_CHANGE_PWD_RSP *rsp = (GLTP_MSG_T_CHANGE_PWD_RSP *)out_buf;

    rsp->header.length = sizeof(GLTP_MSG_T_CHANGE_PWD_RSP);
    rsp->header.type = GLTP_MSG_TYPE_TERMINAL;
    rsp->header.func = GLTP_T_CHANGE_PWD_RSP;
    rsp->header.when = time(NULL);
    rsp->header.token = req->header.token;
    rsp->header.identify = req->header.identify;
    rsp->header.msn = req->header.msn;
    rsp->header.param = 0;
    rsp->header.status = 0;
    rsp->timeStamp = time(NULL);
    //rsp->crc is set by ncp

    logit(II, "CHPWD (3017): token (%lu)", rsp->header.token);
    return 0;
}

int proc_term_agency_balance(char *in_buf, char *out_buf)
{
    GLTP_MSG_T_AGENCY_BALANCE_REQ *req = (GLTP_MSG_T_AGENCY_BALANCE_REQ *)in_buf;
    GLTP_MSG_T_AGENCY_BALANCE_RSP *rsp = (GLTP_MSG_T_AGENCY_BALANCE_RSP *)out_buf;
    rsp->header.length = sizeof(GLTP_MSG_T_AGENCY_BALANCE_RSP);
    rsp->header.type = GLTP_MSG_TYPE_TERMINAL;
    rsp->header.func = GLTP_T_AGENCY_BALANCE_RSP;
    rsp->header.when = time(NULL);
    rsp->header.token = req->header.token;
    rsp->header.identify = req->header.identify;
    rsp->header.msn = req->header.msn;
    rsp->header.param = 0;
    rsp->header.status = 0;
    rsp->timeStamp = time(NULL);
    //rsp->crc is set by ncp

    rsp->agencyCode = 110100000101;
    rsp->availableCredit = 99999999;
    rsp->accountBalance = 8888888;
    rsp->marginalCreditLimit = 1000000;

    logit(II, "REPORT (3019): token (%lu)", rsp->header.token);
    return 0;
}

int proc_term_msg(char *in_buf, char *out_buf)
{
    GLTP_MSG_T_HEADER *term = (GLTP_MSG_T_HEADER *)in_buf;

    switch (term->func)
    {
        case GLTP_T_ECHO_REQ:
            if (0 > proc_term_echo(in_buf, out_buf)) {
                logit(EE, "proc_term_echo() failed");
                return -1;
            }
            break;
        case GLTP_T_AUTH_REQ:
            if (0 > proc_term_auth(in_buf, out_buf)) {
                logit(EE, "proc_term_auth() failed");
                return -1;
            }
            break;
        case GLTP_T_GAME_INFO_REQ:
            if (0 > proc_term_game_info(in_buf, out_buf)) {
                logit(EE, "proc_term_game_info() failed");
                return -1;
            }
            break;
        case GLTP_T_SELL_TICKET_REQ:
            if (0 > proc_term_sell_ticket(in_buf, out_buf)) {
                logit(EE, "proc_term_sell_ticket() failed");
                return -1;
            }
            break;
        case GLTP_T_INQUIRY_TICKET_REQ:
            if (0 > proc_term_inquiry_ticket(in_buf, out_buf)) {
                logit(EE, "proc_term_inquiry_ticket() failed");
                return -1;
            }
            break;
        case GLTP_T_PAY_TICKET_REQ:
            if (0 > proc_term_pay_ticket(in_buf, out_buf)) {
                logit(EE, "proc_term_pay_ticket() failed");
                return -1;
            }
            break;
        case GLTP_T_CANCEL_TICKET_REQ:
            if (0 > proc_term_cancel_ticket(in_buf, out_buf)) {
                logit(EE, "proc_term_cancel_ticket() failed");
                return -1;
            }
            break;
        case GLTP_T_SIGNIN_REQ:
            if (0 > proc_term_signin(in_buf, out_buf)) {
                logit(EE, "proc_term_signin() failed");
                return -1;
            }
            break;
        case GLTP_T_SIGNOUT_REQ:
            if (0 > proc_term_signout(in_buf, out_buf)) {
                logit(EE, "proc_term_signout() failed");
                return -1;
            }
            break;
        case GLTP_T_CHANGE_PWD_REQ:
            if (0 > proc_term_change_pwd(in_buf, out_buf)) {
                logit(EE, "proc_term_change_pwd() failed");
                return -1;
            }
            break;
        case GLTP_T_AGENCY_BALANCE_REQ:
            if (0 > proc_term_agency_balance(in_buf, out_buf)) {
                logit(EE, "proc_term_agency_balance() failed");
                return -1;
            }
            break;
        default:
        {
            logit(WW, "unknown terminal message func [%hu]", term->func);
            return -1;
        }
    }
    return 0;
}

static int process_message(connection *c, char *in_buf)
{
    c->last_update = time(NULL);

    static char out_buf[BUFFER_SIZE];
    memset(out_buf, 0, BUFFER_SIZE);

    GLTP_MSG_HEADER *gltp = (GLTP_MSG_HEADER *)in_buf;
    switch (gltp->type)
    {
        case GLTP_MSG_TYPE_NCP: {
            if (0 > proc_ncp_msg(in_buf, out_buf)) {
                logit(EE, "proc_ncp_msg() failed");
                return -1;
            }
            break;
        }
        case GLTP_MSG_TYPE_TERMINAL: {
            if (0 > proc_term_msg(in_buf, out_buf)) {
                logit(EE, "proc_term_msg() failed");
                return -1;
            }
            break;
        }
        default: {
            logit(EE, "unknown gltp type [%hhu]", gltp->type);
            return -1;
        }
    }

    //send data to net
    int out_buf_len = *(unsigned short *)out_buf;
    int nwritten = 0;
    while (nwritten < out_buf_len) {
        int r;
        r = write(c->cfd, out_buf+nwritten, out_buf_len-nwritten);
        if (r < 0 && ( errno == EINTR || errno == EAGAIN)) {
            usleep( 100*1000 );
            continue;
        }
        if (r < 0) {
            logit(EE, "write error!");
            return -1;
        }
        if ( r == 0 )
            break;
        nwritten += r;
    }
    return 0;
}

void close_connection(connection * c)
{
    logit(II, "Close one connection.  ip[%s] port[%d]",c->ip, c->port);
    close(c->cfd);
    ev_io_stop(c->loop, c->watcher);
    del_connection(c->cfd);
    free(c->watcher);
    free(c);
}

void read_cb(struct ev_loop *loop, struct ev_io *watcher, int revents)
{
    ((void)loop);
    if(EV_ERROR & revents) {
        logit(EE, "error event in read_cb");
        return;
    }

    connection *c = (connection *)watcher->data;
    int ret = 0;
    while (c->r_size-c->r_offset > 0) {
        ret = recv(c->cfd, c->r_buf+c->r_offset, sizeof(c->r_buf)-c->r_offset, 0);
        if (ret < 0) {
            if (errno == EINTR) continue;
            else if (EAGAIN==errno || EWOULDBLOCK==errno) {
                break;
            }
            else {
                // shutdown terminal
                logit(WW, "recv() failed. Reason [%s].", strerror(errno));
                close_connection(c);
                return;
            }
        }
        else if (0 == ret) {
            logit(WW, "the peer has performed an orderly shutdown. Reason [%s].", strerror(errno));
            close_connection(c);
            return;
        }
        else {
            c->r_offset += ret;
        }
    }
    int start = 0;
    int left = c->r_offset;
    char *buffer = c->r_buf;
    while (true) {
        if ((unsigned int)left < sizeof(unsigned short)) {
            if ( 0 != start && 0 != left) {
                memmove(buffer, buffer + start, left);
            }
            c->r_offset = left;
            return;
        }
        int msg_size = *((unsigned short *)(buffer + start));
        if (msg_size > left) {
            if (0 != start && 0 != left) {
                memmove(buffer, buffer + start, left);
            }
            c->r_offset = left;
            return;
        }

        if (0 > process_message(c, buffer+start)) {
            logit(WW, "process_message() failed.");
            close_connection(c);
            return;
        }
        start += msg_size;
        left -= msg_size;
    }
    return;
}

static void timer_cb (EV_P_ ev_timer *w, int revents)
{
    ((void)w);((void)revents);
    connection *c = NULL;

    uint32 time_n = time(NULL);
    //便利关闭超时的连接
    map<int, connection*>::iterator iter;
    for(iter=conn_map.begin(); iter!=conn_map.end();)
    {
        c = iter->second;
        if (time_n-c->last_update > 60)
        {
            close(c->cfd);
            ev_io_stop(loop, c->watcher);
            conn_map.erase(iter++);
            free(c->watcher);
            free(c);
        }
        else
        {
            ++iter;
        }
    }
}

void accept_cb(struct ev_loop *loop, struct ev_io *watcher, int revents) {
    if(EV_ERROR & revents) {
        logit(EE, "error event in accept_cb");
        return;
    }
    struct sockaddr_in client_addr;
    socklen_t client_len = sizeof(client_addr);
    int cfd = accept(watcher->fd, (struct sockaddr *)&client_addr, &client_len);
    if (cfd < 0) {
        logit(EE, "accept error\n");
        return;
    }
    fcntl(cfd, F_SETFL, fcntl(cfd, F_GETFD, 0)|O_NONBLOCK);

    connection *c = (connection*)malloc(sizeof(connection));
    memset(c, 0, sizeof(connection));
    sprintf(c->ip, "%s", (char*)inet_ntoa(client_addr.sin_addr));
    c->port = client_addr.sin_port;
    c->cfd = cfd;
    c->r_size = BUFFER_SIZE;
    c->r_offset = 0;
    c->last_update = time(NULL);
    c->watcher = (struct ev_io*)malloc(sizeof(struct ev_io));
    c->watcher->data = c;
    c->loop = loop;
    set_connection(c->cfd, c);
    logit(II, "Accept one connection.  ip[%s] port[%d] fd[%d].", c->ip, c->port, c->cfd);
    
    ev_io_init(c->watcher, read_cb, c->cfd, EV_READ);
    ev_io_start(loop, c->watcher);
}

/*
static bool set_daemonize(void)
{
    fflush(NULL);
    switch (fork()) {
        case -1:
            return false;
        case 0:
            break;
        default:
            _exit(0);
    }
    if (setsid() == -1) {
        return false;
    }
    switch (fork()) {
        case -1:
            return false;
        case 0:
            break;
        default:
            _exit(0);
    }
    umask(0);

    close(0);
    close(1);
    close(2);
    int fd = open("/dev/null", O_RDWR, 0);
    if (fd != -1) {
        dup2(fd, 0);
        dup2(fd, 1);
        dup2(fd, 2);
        if (fd > 2) {
            close(fd);
        }
    }
    return true;
}
*/

int main() 
{
    //set_daemonize();

    struct ev_loop *loop = ev_default_loop(0);
    int sfd;
    struct sockaddr_in addr;
    struct ev_io socket_watcher;
    struct ev_timer timer_watcher;

    if( (sfd = socket(PF_INET, SOCK_STREAM, 0)) < 0 ) {
        logit(EE, "socket error. errno:%d", errno);
        return -1;
    }
    
    //set reuse address
    int so_reuseaddr=1;
    setsockopt(sfd,SOL_SOCKET,SO_REUSEADDR,&so_reuseaddr,sizeof(so_reuseaddr));
    //set nonblocking
    fcntl(sfd, F_SETFL, fcntl(sfd, F_GETFD, 0)|O_NONBLOCK);

    bzero(&addr, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(PORT);
    addr.sin_addr.s_addr = INADDR_ANY;
    if (bind(sfd, (struct sockaddr*) &addr, sizeof(addr)) != 0) {
        logit(EE, "bind error.errno:%d",errno);
        return -1;
    }
    if (listen(sfd, 2) < 0) {
        logit(EE, "listen error");
        return -1;
    }
    
    //设置cb函数，字段等
    ev_io_init(&socket_watcher, accept_cb, sfd, EV_READ);
    ev_io_start(loop, &socket_watcher);

    ev_timer_init(&timer_watcher, timer_cb, 0., 5.);
    ev_timer_start(loop, &timer_watcher);
    
    while (1) {
        ev_loop(loop, 0);
    }
    return 0;
}


