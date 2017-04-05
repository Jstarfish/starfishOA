#include "global.h"
#include "gl_inf.h"
#include "otl_inf.h"


timer_t  glIssueTimer;

#define MY_TASK_NAME "gl_driver\0"

static volatile int exit_signal_fired = 0;
static volatile int timer_fired = 0;

#define PROTECT_TIMER_INTERVAL 60
#define CLEAR_WAIT_TIME 10


GAME_PLUGIN_INTERFACE *game_plugins_handle = NULL;

typedef struct _GAME_THREAD {
    uint8 gameCode;
    pthread_t   threadId;
    MQUE *q;
    GAME_PLUGIN_INTERFACE *game_handle;
    int32 issueUsedCount;
    int32 issueMemMaxCount;//此游戏期次内存空间
    char *issueBuf;//从数据库加载期次使用的buffer
} GAME_THREAD;
GAME_THREAD game_list[MAX_GAME_NUMBER];

static FID gl_driver_fid, tfe_adder_fid, ncpc_send;



//下面的代码，暂时没有使用，先注释掉
#if 0
//static bool SendIssueSaleFlag[MAX_GAME_NUMBER][MAX_GAME_ISSUE_COUNT];
char* get_date_byTimestamp(time_t *curtime, const char* format, char* buffer)
{
    char ybuf[4 + 1];
    char mbuf[2 + 1];
    char dbuf[2 + 1];

    struct tm * tm_ptr;

    tm_ptr = localtime(curtime);

    sprintf(ybuf, "%d", tm_ptr->tm_year + 1900);

    if (tm_ptr->tm_mon + 1 >= 10)
    {
        sprintf(mbuf, "%d", tm_ptr->tm_mon + 1);
    }
    else
    {
        sprintf(mbuf, "0%d", tm_ptr->tm_mon + 1);
    }

    if (tm_ptr->tm_mday >= 10)
    {
        sprintf(dbuf, "%d", tm_ptr->tm_mday);
    }
    else
    {
        sprintf(dbuf, "0%d", tm_ptr->tm_mday);
    }

    sprintf(buffer, format, ybuf, mbuf, dbuf);

    return buffer;
}

time_t gl_getEndOfTodayTime(void)
{
    time_t time_tmp = time(NULL);
    struct tm *tm_p = localtime(&time_tmp);
    tm_p->tm_sec = 0;
    tm_p->tm_min = 0;
    tm_p->tm_hour = 0;
    time_t time_start_day = mktime(tm_p);
    time_t start_of_next_day = time_start_day + 24 * 3600;

    return start_of_next_day;
}

bool gl_checkGameInTransTime(uint8 gameCode)
{
    TRANSCTRL_PARAM *transctrlParam = gl_getTransctrlParam(gameCode);
    time_type now = get_now();
    if (((now >= transctrlParam->ap_service_time_1_b) && (now <= transctrlParam->ap_service_time_1_e)) ||
        ((now >= transctrlParam->ap_service_time_2_b) && (now <= transctrlParam->ap_service_time_2_e)))
        return true;
    return false;
}

bool gl_checkDrawTime(ISSUE_INFO *issue)
{
    char dt_now[64] = { 0 };
    get_date("%s%s%s", dt_now);

    long long today = atol(dt_now);

    char drawStr[64] = { 0 };
    get_date_byTimestamp((time_t *)&(issue->drawTime), "%s%s%s", drawStr);

    long long drawTime = atol(drawStr);

    if (today >= drawTime)
        return true;

    return false;
}
#endif


void gl_sendIssueOpen(uint8 gameCode, uint64 issueNumber, uint32 issueSerial, uint32 issueLength, uint32 startTime)
{
    INM_MSG_ISSUE_OPEN inm_msg;

    inm_msg.gameCode = gameCode;
    inm_msg.issueNumber = issueNumber;
    inm_msg.serialNumber = issueSerial;
    inm_msg.startTime = startTime;
    inm_msg.issueTimeSpan = issueLength;
    inm_msg.header.length = sizeof(inm_msg);
    inm_msg.header.type = INM_TYPE_ISSUE_STATE_OPEN;
    inm_msg.header.when = time(NULL);

    bq_send(tfe_adder_fid, (char *)&inm_msg, inm_msg.header.length);
    log_info("gl_sendIssueOpen gameCode[%d] issueNum[%lld] Open to TFE.", gameCode, issueNumber);
}

/*
void gl_sendIssueWillClose(uint8 gameCode, uint64 issueNumber, uint32 issueSerial, uint32 seconds, uint32 closeTime)
{
    INM_MSG_ISSUE_CLOSING inm_msg;

    inm_msg.gameCode = gameCode;
    inm_msg.issueNumber = issueNumber;
    inm_msg.serialNumber = issueSerial;
    inm_msg.closingTime = closeTime;
    inm_msg.seconds = seconds;
    inm_msg.header.length = sizeof(inm_msg);
    inm_msg.header.type = INM_TYPE_ISSUE_STATE_CLOSING;
    inm_msg.header.when = time(NULL);

    bq_send(tfe_adder_fid, (char *)&inm_msg, inm_msg.header.length);
    log_info("gl_sendIssueWillClose gameCode[%d] issueNum[%lld] seconds[%d] to TFE.",
        gameCode, issueNumber, seconds);
}
*/

void gl_sendIssueClosed(uint8 gameCode, uint64 issueNumber, uint32 issueSerial, uint32 closeTime, money_t rkAmount, uint32 rkCount)
{
    INM_MSG_ISSUE_CLOSE inm_msg;

    inm_msg.gameCode = gameCode;
    inm_msg.issueNumber = issueNumber;
    inm_msg.serialNumber = issueSerial;
    inm_msg.closeTime = closeTime;
    inm_msg.header.length = sizeof(inm_msg);
    inm_msg.header.type = INM_TYPE_ISSUE_STATE_CLOSED;
    inm_msg.header.when = time(NULL);

    inm_msg.refuseAmount = rkAmount;
    inm_msg.refuseCount = rkCount;

    bq_send(tfe_adder_fid, (char *)&inm_msg, inm_msg.header.length);
    log_info("gl_sendIssueClosed gameCode[%d] issueNum[%lld] to TFE.", gameCode, issueNumber);
}

typedef struct _CANSALE_ISSURE
{
    uint8     gameCode;
    uint64    issueNumber;
    uint32    serialNumber;
    time_type startTime;
    time_type closeTime;
    time_type awardTime;
    uint32    payEndDay;
} CANSALE_ISSURE;

void gl_sendIssueCanSale(CANSALE_ISSURE *issue)
{
    INM_MSG_ISSUE_PRESALE inm_msg;
    inm_msg.gameCode = issue->gameCode;
    inm_msg.issueNumber = issue->issueNumber;
    inm_msg.serialNumber = issue->serialNumber;
    inm_msg.startTime = issue->startTime;
    inm_msg.closeTime = issue->closeTime;
    inm_msg.awardTime = issue->awardTime;
    inm_msg.payEndDay = issue->payEndDay;
    inm_msg.header.length = sizeof(inm_msg);
    inm_msg.header.type = INM_TYPE_ISSUE_STATE_PRESALE;
    inm_msg.header.when = time(NULL);

    bq_send(tfe_adder_fid, (char *)&inm_msg, inm_msg.header.length);
    log_info("gl_sendIssueCanSale gameCode[%d] issueNum[%lld] to TF.", issue->gameCode, issue->issueNumber);

}


// otl 删除此期后的所有期次
bool del_issue_DB(int gameCode, uint64 issueNumber)
{
    return otl_delIssue(gameCode, issueNumber);
}

//从数据库加载制定数量的期次
int get_newIssueFromDB(GAME_THREAD *gt, int issueMemCount)
{
    bzero(gt->issueBuf, sizeof(ISSUE_CFG_DATA) * issueMemCount);

    int idx = 0;
    uint32 maxIssueSeq = gt->game_handle->get_issueCurrMaxSeq();
    ISSUE_NEWCFG_LIST issue_list;
    int ret = otl_getGameNewIssueList(gt->gameCode, &issue_list, issueMemCount, maxIssueSeq);
    if (ret > 0)
    {
        ISSUE_NEWCFG_LIST::iterator issueListIterator;
        for (issueListIterator = issue_list.begin(); issueListIterator != issue_list.end(); issueListIterator++)
        {
            ISSUE_CFG_DATA *tmpIssue = *issueListIterator;
            memcpy(gt->issueBuf + sizeof(ISSUE_CFG_DATA) * idx, (char *)tmpIssue, sizeof(ISSUE_CFG_DATA));
            idx++;
        }

        ISSUE_NEWCFG_LIST::iterator iterbegin = issue_list.begin();
        ISSUE_NEWCFG_LIST::iterator iterend = issue_list.end();
        ISSUE_CFG_DATA* pIssue = NULL;
        while (iterbegin != iterend)
        {
            pIssue = (*iterbegin);
            free(pIssue);
            pIssue = NULL;
            iterbegin = issue_list.erase(iterbegin);
            iterbegin++;
        }

        return ret;
    }

    return 0;
}



// send OMS response message
void send_OMS_response(INM_MSG_O_HEADER *pInm)
{
    int ret = bq_send(ncpc_send, (char*)pInm, pInm->inm_header.length);
    if (ret <= 0)
    {
        //BQueues出错
        log_warn("sendDataToBQ()::bq_send return error. fid:%i", ncpc_send);
    }
}

int proc_issue_add_nfy(GAME_THREAD *gt, INM_MSG_O_GL_ISSUE_ADD_NFY *pInm)
{
    TRANSCTRL_PARAM * transParam = gl_getTransctrlParam(gt->gameCode);
    int factload = 0;
    int freeIssueCount = gt->issueMemMaxCount - gt->issueUsedCount;
    if (freeIssueCount > 0)
    {
        int issueCount = get_newIssueFromDB(gt, freeIssueCount);
        if (issueCount > 0)
        {
            factload = gt->game_handle->load_newIssueData((void *)gt->issueBuf, issueCount);

            for (int i = 0; i < factload; i++)
            {
                uint64 issue = ((ISSUE_CFG_DATA *)(gt->issueBuf + i * sizeof(ISSUE_CFG_DATA)))->issueNumber;
                PRIZE_PARAM_ISSUE prize[MAX_PRIZE_COUNT];
                memset((void *)prize, 0, sizeof(prize));
                if (otl_getIssuePrizeInfo(gt->gameCode, issue, prize) < 0)
                {
                    log_error("otl_getIssuePrizeInfo( gameCode[%d] issue[%lld]) failure.", gt->gameCode, issue);
                    return -1;
                }
                if (!gt->game_handle->load_prizeParam(issue, prize))
                {
                    log_error("load_prizeParam( gameCode[%d] issue[%lld]) failure.", gt->gameCode, issue);
                    return -1;
                }
                log_info("load_prizeParam( gameCode[%d] issue [%lld]) ok.", gt->gameCode, issue);
                /*
                                char rkBuf[512] = {0};
                                if(!otl_getIssueRKInfo(gt->gameCode, issue,rkBuf))
                                {
                                    log_error("otl_getIssueRKInfo( gameCode[%d] issue[%lld]) failure.", gt->gameCode,issue);
                                    return false;
                                }
                */

                if (transParam->riskCtrl)
                {
                    uint32 issueSeq = ((ISSUE_CFG_DATA *)(gt->issueBuf + i * sizeof(ISSUE_CFG_DATA)))->serialNumber;
                    gt->game_handle->load_issue_RKdata(issueSeq, 1, transParam->riskCtrlParam);
                }
            }

            gt->issueUsedCount += factload;
        }
    }
    log_info("thread[%lu] process add issue success. game[%d] issueCount[%d]", gt->threadId, pInm->gameCode, factload);

    if (pInm->header.inm_header.when != 0xABCD) //内部的保护消息，不向OMS响应
    {
        pInm->header.inm_header.status = SYS_RESULT_SUCCESS;
        send_OMS_response((INM_MSG_O_HEADER *)pInm);
    }
    return factload;
}

int proc_issue_del(GAME_THREAD *gt, INM_MSG_O_GL_ISSUE_DEL *pInm)
{
    if (gt->game_handle->del_issue(pInm->issueNumber))
    {
        if (false == del_issue_DB(pInm->gameCode, pInm->issueNumber))
            pInm->header.inm_header.status = SYS_RESULT_FAILURE;
    }
    log_info("thread[%lu] process delete issue success. game[%d] issue[%lld] and later issue", gt->threadId, pInm->gameCode, pInm->issueNumber);

    send_OMS_response((INM_MSG_O_HEADER *)pInm);
    return 0;
}


void check_sendPreSaleIssue(GAME_THREAD *gt, uint32 seq, time_type currTime)
{
    TRANSCTRL_PARAM *transctrlParam = gl_getTransctrlParam(gt->gameCode);

    for (int j = 0; j < transctrlParam->maxIssueCount; j++)
    {
        ISSUE_INFO * willSaleIssue = gt->game_handle->get_issueInfo2(seq + j);
        if (willSaleIssue != NULL)
        {
            if (willSaleIssue->curState < ISSUE_STATE_PRESALE)
            {
                if (!willSaleIssue->willSaleFlagGl)
                {
                    CANSALE_ISSURE canSaleissue;
                    canSaleissue.gameCode = gt->gameCode;
                    canSaleissue.issueNumber = willSaleIssue->issueNumber;
                    canSaleissue.serialNumber = willSaleIssue->serialNumber;
                    canSaleissue.startTime = willSaleIssue->startTime;
                    canSaleissue.closeTime = willSaleIssue->closeTime;
                    canSaleissue.awardTime = willSaleIssue->drawTime;
                    canSaleissue.payEndDay = willSaleIssue->payEndDay;
                    gl_sendIssueCanSale(&canSaleissue);
                    willSaleIssue->localState = ISSUE_STATE_PRESALE;
                    willSaleIssue->willSaleFlagGl = true;
                    log_info("gl_sendIssueStatus game[%d] issueNum[%lld] can sale", gt->gameCode, canSaleissue.issueNumber);
                }
            }
        }
    }
}

int proc_issue_cycle(GAME_THREAD *gt, bool *checkPreSale)
{
    TRANSCTRL_PARAM *transctrlParam = gl_getTransctrlParam(gt->gameCode);

    gt->issueUsedCount = 0;

    ISSUE_INFO *all_issue = gt->game_handle->get_issueTable();
    for (int i = 0; i < gt->issueMemMaxCount; i++)
    {
        ISSUE_INFO * issue_info = &all_issue[i];
        if (issue_info->used)
        {
            time_type currentTime = get_now();
            gt->issueUsedCount++;
            if ((issue_info->curState == ISSUE_STATE_OPENED) && (*checkPreSale))
            {
                check_sendPreSaleIssue(gt, issue_info->serialNumber, currentTime);
                *checkPreSale = false;
            }

            //send_willSaleIssue
            if ((currentTime >= issue_info->startTime) &&
                (issue_info->curState == ISSUE_STATE_RANGED) &&
                (issue_info->localState != ISSUE_STATE_PRESALE))
            {
                check_sendPreSaleIssue(gt, issue_info->serialNumber, currentTime);
            }

            if ((currentTime >= issue_info->startTime) &&
                (issue_info->curState == ISSUE_STATE_PRESALE) &&
                (issue_info->localState != ISSUE_STATE_OPENED) && (NULL == gt->game_handle->get_issueInfo2(issue_info->serialNumber - 1)))
            {
                //send_open
                issue_info->localState = ISSUE_STATE_OPENED;
                gl_sendIssueOpen(gt->gameCode, issue_info->issueNumber, issue_info->serialNumber, issue_info->closeTime - issue_info->startTime, issue_info->startTime);
                log_info("gl_sendIssueOpen game[%d] issueNum[%lld] ISSUE_STATE_OPENED startTime[%d]", gt->gameCode, issue_info->issueNumber, issue_info->startTime);
            }

            //send_closing
            /*
            if ( ((currentTime + (int32)transctrlParam->countDownTimes) >= issue_info->closeTime) &&
                (issue_info->curState == ISSUE_STATE_OPENED) &&
                (issue_info->localState != ISSUE_STATE_CLOSING))
            {
                issue_info->localState = ISSUE_STATE_CLOSING;
                int downTimeCount = issue_info->closeTime - currentTime;
                if(downTimeCount < 0)
                    downTimeCount = 0;
                gl_sendIssueWillClose(gt->gameCode, issue_info->issueNumber, issue_info->serialNumber, downTimeCount,issue_info->closeTime);
                log_info("gl_sendIssueWillClose game[%d] issueNum[%lld] seconds[%d]",
                    gt->gameCode, issue_info->issueNumber, transctrlParam->countDownTimes);
            }
            */

            //send_closed
            if ((currentTime >= issue_info->closeTime) &&
                (issue_info->curState == ISSUE_STATE_OPENED) &&
                (issue_info->localState != ISSUE_STATE_CLOSED))
            {
                issue_info->localState = ISSUE_STATE_CLOSED;
                gl_sendIssueClosed(gt->gameCode, issue_info->issueNumber, issue_info->serialNumber, issue_info->closeTime, issue_info->stat.issueRefuseAmount, issue_info->stat.issueRefuseCount);
                log_info("gl_sendIssueStatus game[%d] issueNum[%lld] refuseMoney[%lld] refuseCount[%d] ISSUE_STATE_CLOSED", gt->gameCode, issue_info->issueNumber, issue_info->stat.issueRefuseAmount, issue_info->stat.issueRefuseCount);
                check_sendPreSaleIssue(gt, issue_info->serialNumber + 1, currentTime);
            }

            if (issue_info->curState >= ISSUE_STATE_CLOSED)
            {
                if (currentTime - issue_info->closeTime > CLEAR_WAIT_TIME)
                {
                    //删除已期结的期次
                    log_debug("game[%d] issue[%lld] clean from plugin mem.", gt->gameCode, issue_info->issueNumber);
                    gt->game_handle->clear_oneIssueData(issue_info->issueNumber);
                    issue_info->used = false;
                    gt->issueUsedCount--;

                    //加载一个新期次
                    int issueCount = get_newIssueFromDB(gt, 1);
                    if (issueCount > 0)
                    {
                        int ret = gt->game_handle->load_newIssueData((void *)gt->issueBuf, issueCount);

                        for (int i = 0; i < ret; i++)
                        {
                            uint64 issue = ((ISSUE_CFG_DATA *)(gt->issueBuf + i * sizeof(ISSUE_CFG_DATA)))->issueNumber;
                            PRIZE_PARAM_ISSUE prize[MAX_PRIZE_COUNT];
                            memset((void *)prize, 0, sizeof(prize));
                            if (otl_getIssuePrizeInfo(gt->gameCode, issue, prize) < 0)
                            {
                                log_error("otl_getIssuePrizeInfo( gameCode[%d] issue[%lld]) failure.", gt->gameCode, issue);
                                return false;
                            }
                            if (!gt->game_handle->load_prizeParam(issue, prize))
                            {
                                log_error("load_prizeParam( gameCode[%d] issue[%lld]) failure.", gt->gameCode, issue);
                                return false;
                            }
                            log_info("load_prizeParam( gameCode[%d] issue [%lld]) ok.", gt->gameCode, issue);

                            if (transctrlParam->riskCtrl)
                            {
                                uint32 issueSeq = ((ISSUE_CFG_DATA *)(gt->issueBuf + i * sizeof(ISSUE_CFG_DATA)))->serialNumber;
                                gt->game_handle->load_issue_RKdata(issueSeq, 1, transctrlParam->riskCtrlParam);
                            }
                        }
                        gt->issueUsedCount += ret;
                        if (ret > 0)
                            *checkPreSale = true;
                    }
                }
            }
        }
    }
    return 0;
}

//分游戏驱动的线程
void *gl_driver_thread(void *arg)
{
    GAME_THREAD *gt = (GAME_THREAD *)arg;

    bool checkPreSale = false;

    while (0 == exit_signal_fired)
    {
        if (SYS_STATUS_BUSINESS != sysdb_getSysStatus())
        {
            ts_sleep(1000, 0);
            continue;
        }
        mque_item *msg = gt->q->dequeue(gt->q, 100);
        if (NULL != msg)
        {
            INM_MSG_HEADER *pInm = (INM_MSG_HEADER *)msg->ptr;
            if (INM_TYPE_O_GL_ISSUE_ADD_NFY == pInm->type)
            {
                //process add issue notify
                if (proc_issue_add_nfy(gt, (INM_MSG_O_GL_ISSUE_ADD_NFY *)pInm) > 0)
                    checkPreSale = true;
            }
            else if (INM_TYPE_O_GL_ISSUE_DEL == pInm->type)
            {
                //process delete issue
                proc_issue_del(gt, (INM_MSG_O_GL_ISSUE_DEL *)pInm);
            }

            free(msg->ptr);
            free(msg);
            continue;
        }

        //timeout
        proc_issue_cycle(gt, &checkPreSale);
    }
    log_info("gl_issue thread exit. game[%d]", gt->gameCode);
    return 0;
}

static void signal_alarm(int signo)
{
    ts_notused(signo);
    timer_fired = 1;
    return;
}

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

    /*
    sas.sa_handler = signal_alarm;
    if (sigaction(SIGALRM, &sas, NULL) == -1) {
        log_error("sigaction() failed. Reason: %s", strerror(errno));
        return -1;
    }
    */
    return 0;
}

int main(int argc, char *argv[])
{
    ts_notused(argc);
    ts_notused(argv);

    int ret = 0;

    logger_init(MY_TASK_NAME);

    ret = init_signal();
    if (0 != ret)
    {
        log_error("init_signal() failed.");
        return -1;
    }

    log_info("%s start\n", MY_TASK_NAME);

    if (!sysdb_init())
    {
        log_error("%s sysdb_init error.", MY_TASK_NAME);
        return -1;
    }

    if (!bq_init())
    {
        sysdb_close();
        log_error("%s bq_init error.", MY_TASK_NAME);
        return -1;
    }

    if (!gl_init())
    {
        sysdb_close();
        bq_close();
        log_error("%s gl_init() error.", MY_TASK_NAME);
        return -1;
    }

    SYS_DB_CONFIG *sysDBconfig = sysdb_getOmsDBCfg();
    char dbConnStr[64] = { 0 };

    sprintf(dbConnStr, "%s/%s@%s", sysDBconfig->username, sysDBconfig->password, sysDBconfig->url);


    uint8 gameUsed = 0;
    uint8 dbGameCode[MAX_GAME_NUMBER] = { 0 };
    for (uint8 game_code = 0; game_code < MAX_GAME_NUMBER; game_code++)
    {
        GAME_DATA* game_data = gl_getGameData(game_code);
        if ((game_data->used) && (game_data->gameEntry.gameType < GAME_TYPE_FINAL_ODDS))
        {
            dbGameCode[gameUsed] = game_code;
            gameUsed++;
        }
    }


    if (!otl_connectDB(sysDBconfig->username, sysDBconfig->password, sysDBconfig->url, gameUsed))
    {
        sysdb_close();
        bq_close();
        gl_close();
        log_error("otl_connectDB() failed.");
        return -1;
    }

    if (gl_game_plugins_init() != 0)
    {
        otl_disConnectDB();
        sysdb_close();
        bq_close();
        gl_close();
        log_error("gl_game_plugins_init() failed.");
        return -1;
    }
    game_plugins_handle = gl_plugins_handle();

    gl_driver_fid = getFidByName(MY_TASK_NAME);
    tfe_adder_fid = getFidByName("tfe_adder");
    ncpc_send = getFidByName("ncpsend_http_queue");
    if (!bq_register(gl_driver_fid, MY_TASK_NAME, getpid()))
    {
        log_error("gl_issue bq_register() error.");
        return -1;
    }

    uint8 gameCode;
    GAME_DATA *game_data = NULL;
    GAME_THREAD *gt = NULL;
    for (gameCode = 0; gameCode < MAX_GAME_NUMBER; gameCode++)
    {
        game_data = gl_getGameData(gameCode);
        if (game_data->used == false) {
            continue;
        }

        if (game_data->gameEntry.gameType >= GAME_TYPE_FINAL_ODDS)
        {
            continue;
        }

        gt = &game_list[gameCode];
        gt->gameCode = gameCode;
        gt->game_handle = &game_plugins_handle[gameCode];
        gt->issueUsedCount = 0;
        gt->issueMemMaxCount = gt->game_handle->get_issueMaxCount();
        int len = sizeof(ISSUE_CFG_DATA) * gt->issueMemMaxCount;
        gt->issueBuf = (char *)malloc(len);
        if (gt->issueBuf == NULL)
        {
            gl_game_plugins_close();
            gl_close();
            sysdb_close();
            bq_close();
            log_error("malloc() issue buffer failed. length[%d]", len);
            return -1;
        }
        gt->q = mque_create();
        if (NULL == gt->q)
        {
            gl_game_plugins_close();
            gl_close();
            sysdb_close();
            bq_close();
            log_error("queue_issue_create() failed.");
            return -1;
        }

        //创建线程
        ret = pthread_create(&gt->threadId, NULL, gl_driver_thread, (void *)gt);
        if (ret != 0)
        {
            log_error("Start gl_driver_thread failure.");
            return -1;
        }
    }

    sysdb_setTaskStatus(SYS_TASK_GL_DRIVER, SYS_TASK_STATUS_RUN);

    log_info("%s init success\n", MY_TASK_NAME);

    //启动期次驱动保护定时器
    //alarm(PROTECT_TIMER_INTERVAL);

    glIssueTimer = ts_timer_init(signal_alarm);
    if (glIssueTimer < 0)
    {
        log_error("ts_timer_init < 0! \n");
        return -1;
    }

    ts_timer_set(glIssueTimer, PROTECT_TIMER_INTERVAL, 0);

    static char inm_buf[INM_MSG_BUFFER_LENGTH];
    while (0 == exit_signal_fired)
    {
        ret = bq_recv(gl_driver_fid, inm_buf, sizeof(inm_buf), 500);
        if (ret < 0)
        {
            //BQueues出错退出
            log_error("bq_recvA return error. ret[%d]", ret);
            break;
        }
        else if (ret == 0)
        {
            //timeout
            //设置一个保护，用于内存中没用期次，增加期次的通知消息没有收到的情况
            if (timer_fired == 1)
            {
                for (int g = 0; g < MAX_GAME_NUMBER; g++)
                {
                    game_data = gl_getGameData(g);
                    if (game_data->used == 0) {
                        continue;
                    }
                    if (game_data->gameEntry.gameType >= GAME_TYPE_FINAL_ODDS)
                    {
                        continue;
                    }

                    INM_MSG_O_GL_ISSUE_ADD_NFY *i_nfy = (INM_MSG_O_GL_ISSUE_ADD_NFY *)malloc(sizeof(INM_MSG_O_GL_ISSUE_ADD_NFY));
                    if (i_nfy == NULL)
                    {
                        log_error("malloc() issue buffer error. internal length[%ld]", sizeof(INM_MSG_O_GL_ISSUE_ADD_NFY));
                        break;
                    }
                    i_nfy->header.inm_header.type = INM_TYPE_O_GL_ISSUE_ADD_NFY;
                    i_nfy->header.inm_header.when = 0xABCD;
                    i_nfy->header.inm_header.status = 0;
                    i_nfy->gameCode = g;
                    i_nfy->header.inm_header.length = sizeof(INM_MSG_O_GL_ISSUE_ADD_NFY);

                    mque_item *msg = (mque_item *)malloc(sizeof(mque_item));
                    if (msg == NULL)
                    {
                        log_error("malloc() ISSUE_MSG buffer error. internal. length[%ld]", sizeof(mque_item));
                        break;
                    }
                    msg->ptr = i_nfy;

                    gt = &game_list[g];
                    gt->q->enqueue(gt->q, msg);
                }
                timer_fired = 0;
                //alarm(PROTECT_TIMER_INTERVAL);
                ts_timer_set(glIssueTimer, PROTECT_TIMER_INTERVAL, 0);
            }
            continue;
        }
        else
        {
            INM_MSG_HEADER * pInm = (INM_MSG_HEADER *)inm_buf;
            if (INM_TYPE_O_GL_ISSUE_ADD_NFY == pInm->type)
            {
                INM_MSG_O_GL_ISSUE_ADD_NFY *addMsg = (INM_MSG_O_GL_ISSUE_ADD_NFY *)pInm;
                gt = &game_list[addMsg->gameCode];
            }
            else if (INM_TYPE_O_GL_ISSUE_DEL == pInm->type)
            {
                INM_MSG_O_GL_ISSUE_DEL *delMsg = (INM_MSG_O_GL_ISSUE_DEL *)pInm;
                gt = &game_list[delMsg->gameCode];
            }
            else
            {
                //其他消息不处理，应该也没有其他消息
                log_warn("Who send message? type[%d]", pInm->type);
                continue;
            }

            char *issue_buf = (char *)malloc(pInm->length);
            if (issue_buf == NULL)
            {
                log_error("malloc() issue buffer error. length[%d]", pInm->length);
                break;
            }
            memcpy(issue_buf, inm_buf, pInm->length);

            mque_item *msg = (mque_item *)malloc(sizeof(mque_item));
            if (msg == NULL)
            {
                log_error("malloc() ISSUE_MSG buffer error. length[%ld]", sizeof(mque_item));
                break;
            }
            msg->ptr = issue_buf;

            gt->q->enqueue(gt->q, msg);
        }
    }

    sysdb_setTaskStatus(SYS_TASK_GL_DRIVER, SYS_TASK_STATUS_EXIT);

    //可以在这里等待线程退出，但阻塞的线程，怎么处理?
    //
    //




    gl_game_plugins_close();
    game_plugins_handle = NULL;

    sysdb_close();

    gl_close();

    bq_close();

    otl_disConnectDB();

    log_info("%s exit\n", MY_TASK_NAME);

    return 0;
}




