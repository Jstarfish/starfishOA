#include "global.h"
#include "gl_inf.h"
#include "otl_inf.h"
#include "gl_fbs_inf.h"


timer_t  glIssueTimer;

#define MY_TASK_NAME "gl_fbs_driver\0"

static volatile int exit_signal_fired = 0;
static volatile int timer_fired = 0;

#define PROTECT_TIMER_INTERVAL 60
#define CLEAR_WAIT_TIME 10
#define FBS_MEM_LENGTH (1024*88) // -> sizeof(DB_FBS_MATCH) * 256


GAME_PLUGIN_INTERFACE *game_plugins_handle = NULL;

typedef struct _GAME_THREAD {
    uint8 gameCode;
    pthread_t   threadId;
    MQUE *q;
    GAME_PLUGIN_INTERFACE *game_handle;
    uint16 issueUsedCount;
    uint16 issueMemMaxCount;//����Ϸ�ڴ��ڴ�ռ�
    char *issueBuf;//�����ݿ�����ڴ�ʹ�õ�buffer
} GAME_THREAD;
GAME_THREAD game_list[MAX_GAME_NUMBER];

static FID gl_driver_fid, tfe_adder_fid, ncpc_send;


void gl_sendMatchOpen(uint8 gameCode, uint32 issue_number, uint32 matchCode)
{
    INM_MSG_O_FBS_MATCH_STATE inm_msg;

    inm_msg.gameCode = gameCode;
    inm_msg.issueNumber = issue_number;
    inm_msg.matchCode = matchCode;
    inm_msg.state = M_STATE_OPEN;

    inm_msg.header.inm_header.length = sizeof(inm_msg);
    inm_msg.header.inm_header.type = INM_TYPE_O_FBS_MATCH_OPEN;
    inm_msg.header.inm_header.when = time(NULL);

    bq_send(tfe_adder_fid, (char *)&inm_msg, inm_msg.header.inm_header.length);
    log_info("gl_sendMatchOpen gameCode[%d] issueNum[%d] Open to TFE.", gameCode, issue_number);
}


void gl_sendMatchClosed(uint8 gameCode, uint32 issue_number, uint32 matchCode)
{
    INM_MSG_O_FBS_MATCH_STATE inm_msg;

    inm_msg.gameCode = gameCode;
    inm_msg.issueNumber = issue_number;
    inm_msg.matchCode = matchCode;
    inm_msg.state = M_STATE_CLOSE;

    inm_msg.header.inm_header.length = sizeof(inm_msg);
    inm_msg.header.inm_header.type = INM_TYPE_O_FBS_MATCH_CLOSE;
    inm_msg.header.inm_header.when = time(NULL);

    bq_send(tfe_adder_fid, (char *)&inm_msg, inm_msg.header.inm_header.length);
    log_info("gl_sendMatchClosed gameCode[%d] issueNum[%d] to TFE.", gameCode, issue_number);
}

uint32 check_allMatch_end(GAME_THREAD *gt, uint32 issue_number)
{
    int idx = 0;
    uint32 closeTime = 0;
    FBS_ISSUE *issue_info = gt->game_handle->fbs_get_issue(issue_number);
    if (issue_info != NULL)
    {
        if (issue_info->used)
        {
            int m;
            for (m = 0; m < FBS_MAX_ISSUE_MATCH; m++)
            {
                if (issue_info->match_array[m].used)
                {
                    if (closeTime < issue_info->match_array[m].close_time) {
                        closeTime = issue_info->match_array[m].close_time;
                    }
                    idx++;
                    if (issue_info->match_array[m].state < M_STATE_CLOSE)
                        return 0;
                }
            }
            log_debug("check_allMatch_end issue[%d] m[%d] idx[%d]", issue_number,m,idx);
        }
    }
    else
    {
        log_warn("fbs_get_issue [%d] return NULL", issue_number);
    }

    if (idx > 0)
    {
        log_debug("check_allMatch_end issue[%d] close[%d] ", issue_number, closeTime);
        return closeTime;
    }
    else
        return 0;
}



//�����ݿ�����ƶ��������ڴ�
bool get_newIssueFromDB(GAME_THREAD *gt, uint32 maxissue)
{
    log_debug("get_newIssueFromDB load maxissue[%d] enter", maxissue);
    bzero(gt->issueBuf, sizeof(FBS_MEM_LENGTH));
    int count = 0;
    DB_FBS_ISSUE issue_list;
    memset((void *)&issue_list, 0, sizeof(DB_FBS_ISSUE));
    if (otl_fbs_getOneNewIssue(gt->gameCode, maxissue, &issue_list) > 0)
    {
        if (otl_fbs_getMatchByIssue(gt->gameCode, issue_list.issue_number, &count, (DB_FBS_MATCH *)(gt->issueBuf)))
        {
            gt->game_handle->fbs_load_issue(1, &issue_list);
            gt->game_handle->fbs_load_match(count, issue_list.issue_number, (DB_FBS_MATCH *)(gt->issueBuf));
        }
        else
        {
            log_error("get_newIssueFromDB get match of issue[%d] error!", issue_list.issue_number);
            return false;
        }
        log_debug("get_newIssueFromDB load get issue[%d] match count[%d]", issue_list.issue_number, count);
        return true;
    }
    return false;
}



// send OMS response message
void send_OMS_response(INM_MSG_O_HEADER *pInm)
{
    int ret = bq_send(ncpc_send, (char*)pInm, pInm->inm_header.length);
    if (ret <= 0)
    {
        //BQueues����
        log_warn("sendDataToBQ()::bq_send return error. fid:%i", ncpc_send);
    }
}

void proc_issue_add_nfy(GAME_THREAD *gt, INM_MSG_O_FBS_ADD_MATCH_NFY *pInm)
{
    log_info("proc_issue_add_nfy  add issue process... game[%d] ", pInm->gameCode);
    if (gt->issueMemMaxCount - gt->issueUsedCount > 0)
    {
        uint32 maxIssue = gt->game_handle->get_issueCurrMaxSeq();
        if (get_newIssueFromDB(gt, maxIssue))
            gt->issueUsedCount++;
    }

    if (pInm->header.inm_header.when != 0xABCD) //�ڲ��ı�����Ϣ������OMS��Ӧ
    {
        pInm->header.inm_header.status = SYS_RESULT_SUCCESS;
        send_OMS_response((INM_MSG_O_HEADER *)pInm);
    }
    return;
}

int proc_issue_cycle(GAME_THREAD *gt)
{
    uint16 ct = 0;
    FBS_ISSUE *all_issue = gt->game_handle->fbs_get_issueTable();
    for (int i = 0; i < gt->issueMemMaxCount; i++)
    {
        if (all_issue[i].used)
        {
            ct++;
        }
    }
    gt->issueUsedCount = ct;

    for (int i = 0; i < gt->issueMemMaxCount; i++)
    {
        if (all_issue[i].used)
        {
            FBS_MATCH *matchArray = all_issue[i].match_array;

            for (int m = 0; m < FBS_MAX_ISSUE_MATCH; m++)
            {
                if (matchArray[m].used)
                {
                    time_type currentTime = get_now();

                    if ((currentTime >= matchArray[m].sale_time) &&
                        (matchArray[m].state == M_STATE_ARRANGE) &&
                        (matchArray[m].localState != M_STATE_OPEN))
                    {
                        //send_open
                        matchArray[m].localState = M_STATE_OPEN;
                        gl_sendMatchOpen(gt->gameCode, all_issue[i].issue_number, matchArray[m].match_code);
                        log_info("gl_sendMatchOpen game[%d] issueNum[%d] match[%d] M_STATE_OPEN startTime[%d]", gt->gameCode, all_issue[i].issue_number, matchArray[m].match_code);
                    }

                    //send_closed
                    if ((currentTime >= matchArray[m].close_time) &&
                        (matchArray[m].state == M_STATE_OPEN) &&
                        (matchArray[m].localState != M_STATE_CLOSE))
                    {
                        matchArray[m].localState = M_STATE_CLOSE;
                        gl_sendMatchClosed(gt->gameCode, all_issue[i].issue_number, matchArray[m].match_code);
                        log_info("gl_sendIssueStatus game[%d] issueNum[%d] match[%d] M_STATE_CLOSE", gt->gameCode, all_issue[i].issue_number, matchArray[m].match_code);
                    }

                    if (matchArray[m].state >= M_STATE_CLOSE)
                    {
                        uint32 ret = check_allMatch_end(gt, all_issue[i].issue_number);
                        if (ret > 0)
                        {
                            //��״̬�ر�
                            all_issue[i].state = ISSUE_STATE_CLOSED;

                            if ((currentTime - ret) > CLEAR_WAIT_TIME)
                            {
                                uint32 maxIssue = gt->game_handle->get_issueCurrMaxSeq();
                                log_debug("game[%d] issue[%d] clean from plugin mem.", gt->gameCode, all_issue[i].issue_number);
                                gt->game_handle->fbs_del_issue(all_issue[i].issue_number);
                                gt->issueUsedCount--;
                                if (get_newIssueFromDB(gt, maxIssue))
                                    gt->issueUsedCount++;
                            }
                        }
                    }
                }
            }
        }
    }
    return 0;
}

//����Ϸ�������߳�
void *gl_driver_thread(void *arg)
{
    GAME_THREAD *gt = (GAME_THREAD *)arg;
    log_debug("start gl_driver_thread game[%d]",gt->gameCode);

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
            if (INM_TYPE_O_FBS_ADD_MATCH_NTY == pInm->type)
            {
                //process add issue notify
                log_debug("gl_driver_thread fbs add match message.");
                proc_issue_add_nfy(gt, (INM_MSG_O_FBS_ADD_MATCH_NFY *)pInm);
            }
            free(msg->ptr);
            free(msg);
            continue;
        }

        //timeout
        proc_issue_cycle(gt);
    }
    log_info("gl_issue thread exit. game[%d]", gt->gameCode);
    return 0;
}

void *gl_matchResult_update(void *arg)
{
    GAME_THREAD *gt = (GAME_THREAD *)arg;
    log_debug("start gl_matchResult_update game[%d]", gt->gameCode);

    char jsonBuf[4096] = { 0 };
    int ret;

    while (0 == exit_signal_fired)
    {
        sleep(PROTECT_TIMER_INTERVAL + 30);
        FBS_ISSUE *all_issue = gt->game_handle->fbs_get_issueTable();
        for (int i = 0; i < gt->issueMemMaxCount; i++)
        {
            if (all_issue[i].used)
            {
                FBS_MATCH *matchArray = all_issue[i].match_array;

                for (int m = 0; m < FBS_MAX_ISSUE_MATCH; m++)
                {
                    if (matchArray[m].used)
                    {
                        if ((matchArray[m].state == M_STATE_OPEN) && (matchArray[m].localState == M_STATE_OPEN))
                        {
                            memset(jsonBuf, 0, sizeof(jsonBuf));
                            ret = gt->game_handle->fbs_sale_calc(all_issue[i].issue_number, matchArray[m].match_code, jsonBuf);
                            if (ret == 0)
                            {
                                log_debug("fbs_sale_calc issue[%d] match[%d] json[%s]", all_issue[i].issue_number, matchArray[m].match_code, jsonBuf);
                                if (!otl_fbs_update_match_result(GAME_FBS, all_issue[i].issue_number, matchArray[m].match_code, jsonBuf))
                                {
                                    log_error("otl_fbs_update_match_result error!");
                                }
                            }
                            else
                            {
                                log_error("fbs_sale_calc match code[%d] error!", matchArray[m].match_code);
                            }
                        }
                    }
                }
            }
        }
    }
    log_info("gl_issue gl_matchResult_update exit. game[%d]", gt->gameCode);
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

    for (uint8 game_code = 0; game_code < MAX_GAME_NUMBER; game_code++)
    {
        GAME_DATA* game_data = gl_getGameData(game_code);
        if ((game_data->used) && (game_data->gameEntry.gameType >= GAME_TYPE_FINAL_ODDS))
        {
            gameUsed++;
        }
    }


    if (!otl_connectDB(sysDBconfig->username, sysDBconfig->password, sysDBconfig->url, gameUsed * 2))
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

        if (game_data->gameEntry.gameType < GAME_TYPE_FINAL_ODDS)
        {
            continue;
        }

        gt = &game_list[gameCode];
        gt->gameCode = gameCode;
        gt->game_handle = &game_plugins_handle[gameCode];
        gt->issueUsedCount = 0;
        gt->issueMemMaxCount = FBS_MAX_ISSUE_NUM;
        int len = sizeof(FBS_MEM_LENGTH);
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

        //�����߳�
        ret = pthread_create(&gt->threadId, NULL, gl_driver_thread, (void *)gt);
        if (ret != 0)
        {
            log_error("Start gl_driver_thread failure.");
            return -1;
        }

        ret = pthread_create(&gt->threadId, NULL, gl_matchResult_update, (void *)gt);
        if (ret != 0)
        {
            log_error("Start gl_matchResult_update failure.");
            return -1;
        }
    }

    sysdb_setTaskStatus(SYS_TASK_GL_FBS_DRIVER, SYS_TASK_STATUS_RUN);

    log_info("%s init success\n", MY_TASK_NAME);

    //�����ڴ�����������ʱ��
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
            //BQueues�����˳�
            log_error("bq_recvA return error. ret[%d]", ret);
            break;
        }
        else if (ret == 0)
        {
            //timeout
            //����һ�������������ڴ���û���ڴΣ������ڴε�֪ͨ��Ϣû���յ������
            if (timer_fired == 1)
            {
                for (int g = 0; g < MAX_GAME_NUMBER; g++)
                {
                    game_data = gl_getGameData(g);
                    if (game_data->used == 0) {
                        continue;
                    }
                    if (game_data->gameEntry.gameType < GAME_TYPE_FINAL_ODDS)
                    {
                        continue;
                    }

                    INM_MSG_O_FBS_ADD_MATCH_NFY *i_nfy = (INM_MSG_O_FBS_ADD_MATCH_NFY *)malloc(sizeof(INM_MSG_O_FBS_ADD_MATCH_NFY));
                    if (i_nfy == NULL)
                    {
                        log_error("malloc() issue buffer error. internal length[%ld]", sizeof(INM_MSG_O_FBS_ADD_MATCH_NFY));
                        break;
                    }
                    i_nfy->header.inm_header.type = INM_TYPE_O_FBS_ADD_MATCH_NTY;
                    i_nfy->header.inm_header.when = 0xABCD;
                    i_nfy->header.inm_header.status = 0;
                    i_nfy->gameCode = g;
                    i_nfy->header.inm_header.length = sizeof(INM_MSG_O_FBS_ADD_MATCH_NFY);

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
            if (INM_TYPE_O_FBS_ADD_MATCH_NTY == pInm->type)
            {
                INM_MSG_O_FBS_ADD_MATCH_NFY *addMsg = (INM_MSG_O_FBS_ADD_MATCH_NFY *)pInm;
                gt = &game_list[addMsg->gameCode];
            }
            else
            {
                //������Ϣ��������Ӧ��Ҳû��������Ϣ
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

    sysdb_setTaskStatus(SYS_TASK_GL_FBS_DRIVER, SYS_TASK_STATUS_EXIT);

    gl_game_plugins_close();
    game_plugins_handle = NULL;

    sysdb_close();

    gl_close();

    bq_close();

    otl_disConnectDB();

    log_info("%s exit\n", MY_TASK_NAME);

    return 0;
}



