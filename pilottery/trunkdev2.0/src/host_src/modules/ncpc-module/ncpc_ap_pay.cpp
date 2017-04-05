#include "global.h"
#include "gl_inf.h"
#include "otl_inf.h"

static const char *MY_TASK_NAME = "ncpc_ap_pay\0";
static volatile int exit_signal_fired = 0;
static FID ncpc_appay_send, tfe_adder_fid, ncpc_appay_recv;

static void signal_handler(int signo)
{
    ts_notused(signo);
    exit_signal_fired = 1;
    return;
}

static int init_signal(void)
{
    signal(SIGPIPE, SIG_IGN);

    struct sigaction sas;
    memset(&sas, 0, sizeof(sas));
    sas.sa_handler = signal_handler;
    sigemptyset(&sas.sa_mask);
    sas.sa_flags |= SA_INTERRUPT;
    if (sigaction(SIGINT, &sas, NULL) == -1) {
        log_error("sigaction() failed. Reason: %s", strerror(errno));
        return -1;
    }

    if (sigaction(SIGTERM, &sas, NULL) == -1) {
        log_error("sigaction() failed. Reason: %s", strerror(errno));
        return -1;
    }
    return 0;
}


int set_json_ap_auto_pay(char *buf)
{
    int rc = 0;
    INM_MSG_AP_PAY_TICKET *ap_pays = (INM_MSG_AP_PAY_TICKET *)buf;
    int type = INM_TYPE_AP_AUTODRAW;

    char sbuf[64] = { 0 };
    cJSON *json_req = cJSON_CreateObject();
    cJSON_AddNumberToObject(json_req, "type", 3);
    cJSON_AddStringToObject(json_req, "term_code", "0");
    cJSON_AddNumberToObject(json_req, "teller_code", 0);
    cJSON_AddStringToObject(json_req, "applyflow_pay", ap_pays->reqfn_ticket_pay);
    cJSON_AddNumberToObject(json_req, "is_train", 0);
    sprintf(sbuf, "%08llu", ap_pays->agency_code);
    cJSON_AddStringToObject(json_req, "agency_code", sbuf);
    cJSON_AddStringToObject(json_req, "sale_agency", sbuf);
    cJSON_AddStringToObject(json_req, "loyalty_code", "0");
    cJSON *ticket = cJSON_CreateObject();
    cJSON_AddStringToObject(ticket, "applyflow_sell", ap_pays->reqfn_ticket_sell);
    cJSON_AddNumberToObject(ticket, "game_code", ap_pays->game_code);
    cJSON_AddNumberToObject(ticket, "issue_number", ap_pays->issue);
    cJSON_AddNumberToObject(ticket, "winningamounttax", ap_pays->winningAmountWithTax);
    cJSON_AddNumberToObject(ticket, "winningamount", ap_pays->winningAmount);
    cJSON_AddNumberToObject(ticket, "taxamount", ap_pays->taxAmount);
    cJSON_AddNumberToObject(ticket, "winningcount", ap_pays->winningCount);
    cJSON_AddNumberToObject(ticket, "hd_winning", ap_pays->hd_winning);
    cJSON_AddNumberToObject(ticket, "hd_count", ap_pays->hd_count);
    cJSON_AddNumberToObject(ticket, "ld_winning", ap_pays->ld_winning);
    cJSON_AddNumberToObject(ticket, "ld_count", ap_pays->ld_count);
    cJSON_AddNumberToObject(ticket, "is_big_prize", ap_pays->isBigWin);
    cJSON_AddItemToObject(json_req, "ticket", ticket);
    char *req_buf = cJSON_PrintUnformatted(json_req);

    char resp_buf[INM_MSG_BUFFER_LENGTH] = { 0 };
    rc = otl_json_sp_pil(type, req_buf, resp_buf);
    if (rc != SYS_RESULT_SUCCESS) {
        log_debug("otldb_spcall_oms_pay(%s , %s) return %d", ap_pays->reqfn_ticket_pay, ap_pays->reqfn_ticket_sell, rc);

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


int getIssueNums4Str(char * issueStr, int issue[],uint32 *match,bool flag)
{
    char *p;
    int n = 0;
    char buf[1024] = { 0 };

    if (flag)
    {
        sscanf(issueStr, "%d:%d:%s", match, &n, buf);
    }
    else
    {
        sscanf(issueStr, "%d:%s", &n, buf);
    }

    if (n > 1)
    {
        sscanf(buf, "%d,", &issue[0]);
        p = strchr(issueStr, ',');
        for (int i = 0; i < (n - 1); i++)
        {
            sscanf(p, ",%d", &issue[i + 1]);
            p = strchr(p + 1, ',');
        }
    }
    else
    {
        issue[0] = atoi(buf);
    }
    return n;
}

bool autoPayAPticketFromWinTable(uint8 game_code, int issue_number,uint32 match,bool fbsFlag)
{
    int ret,rc;
    char sql[1024] = { "SELECT area_code,reqfn_ticket,agency_code,ticket_amount,winning_amount_tax, \
        winning_amount,tax_amount,winning_count,hd_winning,hd_count,ld_winning,ld_count,unique_tsn,is_big_winning,rspfn_ticket \
        FROM win_ticket_table \
        WHERE is_train=0 AND paid_status=1 AND from_sale=2" };

    INM_MSG_AP_PAY_TICKET paybuf;
    sqlite3_stmt *pStmt = NULL;

    if (fbsFlag)
    {
        char appstr[64] = { 0 };
        sprintf(appstr, " AND win_match_code=%u", match);
        strcat(sql, appstr);
        GIDB_FBS_WT_HANDLE *w_handle = gidb_fbs_wt_get_handle(game_code, issue_number);
        if (NULL == w_handle)
        {
            log_error("gidb_fbs_wt_get_handle(game_code[%u] issue_num[%llu] ) failed.", game_code, issue_number);
            return false;
        }
        rc = sqlite3_prepare_v2(w_handle->db, sql, strlen(sql), &pStmt, NULL);
        if (rc != SQLITE_OK)
        {
            log_error("sqlite3_prepare_v2() error. [%d]", rc);
            if (pStmt)
                sqlite3_finalize(pStmt);
            return false;
        }
    }
    else
    {
        GIDB_W_TICKET_HANDLE *w_handle = gidb_w_get_handle(game_code, issue_number, 1);
        if (NULL == w_handle) 
        {
            log_error("gidb_w_get_handle(game_code[%u] issue_num[%llu] ) failed.", game_code, issue_number);
            return false;
        }
        rc = sqlite3_prepare_v2(w_handle->db, sql, strlen(sql), &pStmt, NULL);
        if (rc != SQLITE_OK)
        {
            log_error("sqlite3_prepare_v2() error. [%d]", rc);
            if (pStmt)
                sqlite3_finalize(pStmt);
            return false;
        }
    }

    int idx = 0;
    while (true)
    {
        rc = sqlite3_step(pStmt);
        if (rc == SQLITE_ROW)
        {
            memset((void *)&paybuf, 0, sizeof(paybuf));
            paybuf.header.inm_header.type = INM_TYPE_AP_AUTODRAW;
            paybuf.header.inm_header.length = sizeof(INM_MSG_AP_PAY_TICKET);
            paybuf.area_code = sqlite3_column_int(pStmt, 0);

            char *reqfn = (char*)sqlite3_column_text(pStmt, 1);
            if (reqfn != NULL)
            {
                strcpy(paybuf.reqfn_ticket_sell, reqfn);
            }
            generate_tsn(get_now(), paybuf.reqfn_ticket_pay );

            paybuf.agency_code = sqlite3_column_int64(pStmt, 2);
            paybuf.ticketAmount = sqlite3_column_int64(pStmt, 3);
            paybuf.winningAmountWithTax = sqlite3_column_int64(pStmt, 4);
            paybuf.winningAmount = sqlite3_column_int64(pStmt, 5);
            paybuf.taxAmount = sqlite3_column_int64(pStmt, 6);
            paybuf.winningCount = sqlite3_column_int(pStmt, 7);
            paybuf.hd_winning = sqlite3_column_int64(pStmt, 8);
            paybuf.hd_count = sqlite3_column_int(pStmt, 9);
            paybuf.ld_winning = sqlite3_column_int64(pStmt, 10);
            paybuf.ld_count = sqlite3_column_int(pStmt, 11);
            paybuf.unique_tsn = sqlite3_column_int64(pStmt, 12);
            paybuf.isBigWin = sqlite3_column_int(pStmt, 13);

            char *rspfn = (char*)sqlite3_column_text(pStmt, 14);
            if (rspfn != NULL)
            {
                strcpy(paybuf.rspfn_ticket_sell , rspfn);
            }

            paybuf.issue = issue_number;
            paybuf.game_code = game_code;
            idx++;
            log_debug("pay[%d] uniquetsn[%lld] area[%d] reqfn_sell[%s] reqfn_pay[%s] agency_code[%d] winningAmountWithTax[%lld] wincount[%d]",
                idx, paybuf.unique_tsn, paybuf.area_code, paybuf.reqfn_ticket_sell, paybuf.reqfn_ticket_pay, paybuf.agency_code, paybuf.winningAmountWithTax, paybuf.winningCount);

            ret = set_json_ap_auto_pay((char *)&paybuf);
            if (ret != 0)
            {
                if (ret == SYS_RESULT_PAY_PAID_ERR)
                {
                    log_debug("ap pay tsn[%s] SYS_RESULT_PAY_PAID_ERR", paybuf.rspfn_ticket_sell);
                    continue;
                }
                if (ret == SYS_RESULT_TELLER_PAY_LIMIT_ERR)
                {
                    log_debug("ap pay tsn[%s] SYS_RESULT_TELLER_PAY_LIMIT_ERR", paybuf.rspfn_ticket_sell);
                    continue;
                }
                sqlite3_finalize(pStmt);
                return false;
            }

            bq_send(tfe_adder_fid, (char *)&paybuf, sizeof(INM_MSG_AP_PAY_TICKET));
        }
        else if (rc == SQLITE_DONE)
        {
            break;
        }
        else
        {
            //found error
            log_error("sqlite3_step error. (%d, %llu). rc[%d]", game_code, issue_number, rc);
            if (pStmt)
                sqlite3_finalize(pStmt);
            return false;
        }
    }
    sqlite3_finalize(pStmt);
    gidb_w_clean_handle_timeout();
    return true;
}


bool autoAP_pay(GIDB_DRIVERLOG_HANDLE *ap_pay_handle,uint32 msgid, uint8 game_code,int count, int issue_number[],uint32 match,bool flag)
{
    for (int i = 0; i < count; i++)
    {
        if (!autoPayAPticketFromWinTable(game_code, issue_number[i],match, flag))
        {
            log_error("game[%d] issue[%d]", game_code, issue_number[i]);
            return false;
        }
    }
    
    ap_pay_handle->gidb_driverlog_confirm_dl(ap_pay_handle, msgid, 1);

    INM_MSG_AP_PAY_OVER payover;
    memset((void *)&payover, 0, sizeof(INM_MSG_AP_PAY_OVER));


    payover.header.inm_header.type = INM_TYPE_AP_AUTODRAW_OVER;
    payover.header.inm_header.length = sizeof(INM_MSG_AP_PAY_OVER);
    payover.game_code = game_code;
    payover.issue = issue_number[0];
    bq_send(tfe_adder_fid, (char *)&payover, sizeof(INM_MSG_AP_PAY_OVER));

    return true;
}


int main(int argc, char *argv[])
{
    logger_init(MY_TASK_NAME);

    int ret = init_signal();
    if (0 != ret)
    {
        log_error("init_signal() failed.");
        return -1;
    }

    if (!sysdb_init())
    {
        log_error("%s sysdb_init error.", MY_TASK_NAME);
        return -1;
    }

    if (!bq_init())
    {
        sysdb_close();
        log_error("bq_init() failed.");
        return -1;
    }

    // ncpc_appay_send = getFidByName(MY_TASK_NAME);
    tfe_adder_fid = getFidByName("tfe_adder");
    // ncpc_appay_recv = getFidByName("ncpc_appay_recv");
    /*
    if (!bq_register(ncpc_appay_send, MY_TASK_NAME, getpid()))
    {
        log_error("ncpc_appay_send bq_register() error.");
        return -1;
    }
    */
    SYS_DB_CONFIG *sysDBconfig = sysdb_getOmsDBCfg();
    char dbConnStr[64] = { 0 };
    sprintf(dbConnStr, "%s/%s@%s", sysDBconfig->username, sysDBconfig->password, sysDBconfig->url);
    if (!otl_connectDB(sysDBconfig->username, sysDBconfig->password, sysDBconfig->url, 2))
    {
        sysdb_close();
        log_error("otl_connectDB() failed.");
        return -1;
    }


    GIDB_DRIVERLOG_HANDLE *ap_pay_handle = gidb_driverlog_get_handle();
    if (ap_pay_handle == NULL)
    {
        sysdb_close();
        log_error("gidb_driverlog_get_handle error");
        return -1;
    }

    log_info("gidb_driverlog_get_handle ok.");

    char msg_buf[2048] = { 0 };
    uint8 gameCode = 0;
    uint32 msgid = 0;
    uint8 msg_type = 0;
    uint32 inm_len = 0;
    bool flag;

    sysdb_setTaskStatus(SYS_TASK_NCPC_AUTOPAY, SYS_TASK_STATUS_RUN);

    while (0 == exit_signal_fired)
    {
        memset(msg_buf,0,sizeof(msg_buf));
        ret = ap_pay_handle->gidb_driverlog_get_last_dl(ap_pay_handle, INM_TYPE_AP_AUTODRAW, &msgid, &msg_type, &gameCode,msg_buf, &inm_len);
        if (ret < 0)
        {
            log_error("gidb_driverlog_get_last_dl(%d) error", gameCode);
            return -1;
        }
        else if (ret == 1)
        {
            ts_sleep(500 * 1000, 0);
            continue;
        }
        flag = ((gameCode == GAME_FBS) || (gameCode == GAME_FODD));
        int issue[128] = { 0 };
        uint32 matchCode = 0;

        ret = getIssueNums4Str(msg_buf, issue, &matchCode, flag);
        log_debug("getIssueNums4Str game[%d] ret[%d]", gameCode, ret);

        if (autoAP_pay(ap_pay_handle, msgid, gameCode,ret, issue,matchCode,flag))
        {
            log_debug("msgid[%d] game[%d] issue[%d] auto pay over",msgid, gameCode,issue[0]);
        }
        else
            exit_signal_fired = 1;

    }


    sysdb_setTaskStatus(SYS_TASK_NCPC_AUTOPAY, SYS_TASK_STATUS_EXIT);

    gidb_w_close_handle();
    gidb_driverlog_close_handle();

    otl_disConnectDB();

    sysdb_close();

    log_info("%s exit\n", MY_TASK_NAME);
    
    return 0;
}









