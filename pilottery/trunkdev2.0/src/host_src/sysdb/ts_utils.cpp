#include "global.h"
#include "gl_inf.h"
#include "tfe_inf.h"
#include "ncpc_inf.h"
#include "tms_inf.h"
#include "otl_inf.h"

#include "ts_utils.h"

extern bool exit_flag_g;


//----------------------------------------------------------

void clear_screen(void)
{
    printf("\033[2J");
    return;
}

void clear_to_eol(void)
{
    printf("\033[K");
    return;
}

void move_cursor(int row, int col)
{
    printf("\033[%d;%dH",row, col);
    return;
}


void print_status(const char *msg, int status)
{
    clear_to_eol();

    char buff[2048] = {0};
    int str_len = 0;

    str_len += snprintf(buff + str_len, sizeof(buff) - str_len, "%s", msg);

    if (STATUS_OK == status)
    {
        str_len += snprintf(buff + str_len, sizeof(buff) - str_len, MOVE_TO_COL "[" SETCOLOR_SUCCESS "OK" SETCOLOR_NORMAL "]\n");
    }
    else if (STATUS_FAILED == status)
    {
        str_len += snprintf(buff + str_len, sizeof(buff) - str_len, MOVE_TO_COL "[" SETCOLOR_FAILURE "FAILED" SETCOLOR_NORMAL "]\n");
    }
    else if (STATUS_WARNING == status)
    {
        str_len += snprintf(buff + str_len, sizeof(buff) - str_len, MOVE_TO_COL "[" SETCOLOR_WARNING "WARNING" SETCOLOR_NORMAL "]\n");
    }

    printf("%s", buff);
    return;
}

void show_waiting_info(const char *msg, int times)
{
    clear_to_eol();
    printf("-->"LIGHT_GREEN"Tips: "SETCOLOR_NORMAL"%s", msg);

    for (int i = 0; i < times; i++)
    {
        printf(".");
    }

    printf("\n" MOVE_TO_PREV_LINE);
    return;
}

//------------------------------------------------------


static FILE* sysdb_filefd = NULL;

bool ts_initLog()
{
    char fdname[PATH_MAX];

    sprintf(fdname, "%s/%s.%s", LOG_ROOT_DIR, "tstop", "log");

    char file_path_tmp[PATH_MAX];
    strcpy(file_path_tmp, fdname);
    char *path_dir = dirname(file_path_tmp);

    int ret = mkdirs(path_dir);
    if (ret != 0) {
        fprintf(stderr, "mkdirs(%s) failed.\n", path_dir);

        return false;
    }

    if ((sysdb_filefd = fopen(fdname, "a+"))==NULL) {
        perrork("[a] fopen file %s failure!",fdname);

        return false;
    }

    ret = dup2(fileno(sysdb_filefd), STDERR_FILENO);
    if (-1 == ret) {
        perrork("dup2() failed. Reason [%s].", strerror(errno));
        ts_closeLog();

        return false;
    }

    return true;
}

bool ts_closeLog()
{
    if (NULL != sysdb_filefd) {
        fclose(sysdb_filefd);
        sysdb_filefd = NULL;
    }

    return true;
}







int32 sys_startTask(SYS_TASK taskIdx)
{
    SYS_TASK_RECORD *pTaskRecord = sysdb_getTask(taskIdx);
    if( NULL == pTaskRecord)
    {
        log_error("task index maybe error. taskIdx[%d].", taskIdx);
        return -1;
    }

    char task_path[PATH_MAX];
    snprintf(task_path, sizeof(task_path), "%s%s", pTaskRecord->taskPath, pTaskRecord->taskName);
    if (access(task_path, F_OK) != 0)
    {
        log_error("access([%s], F_OK) failed. Reason [%s].", task_path, strerror(errno));
        return -1;
    }

    switch (fork())
    {
        case -1:
        {
            // fork failed.
            log_error("fork failed. Reason [%s].", strerror(errno));
            return -1;
        }
        case 0:
        {
            // child process
            if (strlen(pTaskRecord->param) == 0)
            {
                execl(task_path, task_path, (char *)0);
            }
            else
            {
                execl(task_path, task_path, pTaskRecord->param, (char *)0);
            }
            log_error("execl([%s]) failed. Reason [%s].", task_path, strerror(errno));
            exit(0);
            return -1;
        }
        default:
            return 0;
    }
    return 0;
}

int32 sys_startTaskEx(SYS_TASK taskIdx)
{
    char msg[128];
    char wait_msg[128];

    SYS_TASK_RECORD *pTaskRecord = sysdb_getTask(taskIdx);
    if( NULL == pTaskRecord)
    {
        log_error("task index maybe error. taskIdx[%d].", taskIdx);
        return -1;
    }

    sprintf(msg, "%s start:", pTaskRecord->taskName);
    sprintf(wait_msg, "waiting for %s start", pTaskRecord->taskName);

    if (sys_startTask(taskIdx)!=0)
    {
        print_status(msg, STATUS_FAILED);
        return -1;
    }

    int times = 0;
    log_info("wait task taskrecord->name[%s].", pTaskRecord->taskName);
    while (1)
    {
        ts_sleep(200*1000,0);
        if ( pTaskRecord->taskStatus == SYS_TASK_STATUS_RUN )
        {
            break;
        }
        show_waiting_info(wait_msg, times);
        if (times++>7)
        {
            times = 0;
        }
    }
    clear_to_eol();
    print_status(msg, STATUS_OK);
    return 0;
}

bool sys_check_process_alive(int pid)
{
    char path[PATH_MAX];

    sprintf(path, "/proc/%d/status", pid);
    if (0 != access(path, F_OK))
    {
        return false;
    }
    else
    {
        // maybe a zombie
        return true;
    }
    return false;
}

int32 sys_stopTask(SYS_TASK taskIdx)
{
    SYS_TASK_RECORD *pTaskRecord = sysdb_getTask(taskIdx);
    if( NULL == pTaskRecord)
    {
        log_error("task index maybe error. taskIdx[%d].", taskIdx);
        return -1;
    }

    if (!sys_check_process_alive(pTaskRecord->taskProcId))
    {
        log_notice("kill task: [%s] maybe exited.", pTaskRecord->taskName);
        return 0;
    }

    log_notice("Begin kill [%s], pid [%d].", pTaskRecord->taskName, pTaskRecord->taskProcId);

    int ret = kill(pTaskRecord->taskProcId, SIGTERM);
    if (0 != ret)
    {
        log_error("kill [%s] failed. Reason [%s].", pTaskRecord->taskName, strerror(errno));
        return -1;
    }
    return 0;
}

int32 sys_stopTaskEx(SYS_TASK taskIdx)
{
    SYS_TASK_RECORD *pTaskRecord = sysdb_getTask(taskIdx);
    if( NULL == pTaskRecord)
    {
        log_error("task index maybe error. taskIdx[%d].", taskIdx);
        return -1;
    }

    int ret = sys_stopTask(taskIdx);
    if (ret != 0)
    {
        log_error("sys_stopTask failure. task[%s].", pTaskRecord->taskName);
        return -1;
    }

    while (1)
    {
        if ( SYS_TASK_STATUS_EXIT == pTaskRecord->taskStatus )
        {
            log_info("stop task[ %s ] ok.", pTaskRecord->taskName);
            break;
        }
        ts_sleep(100 * 1000,0);
        sys_stopTask(taskIdx);
    }
    return 0;
}

int32 sys_wait_task_stop(SYS_TASK taskIdx)
{
    SYS_TASK_RECORD *pTaskRecord = sysdb_getTask(taskIdx);
    if( NULL == pTaskRecord)
    {
        log_error("task index maybe error. taskIdx[%d].", taskIdx);
        return -1;
    }

    while (1)
    {
        if ( SYS_TASK_STATUS_EXIT == pTaskRecord->taskStatus )
        {
            log_info("stop task[ %s ] ok.", pTaskRecord->taskName);
            break;
        }
        ts_sleep(100 * 1000,0);
    }
    return 0;
}

void sys_send_task_notify(SYS_TASK_RECORD *task)
{
    GLTP_MSG_NTF_SYS_TASK_FAULT notify;
    memset(notify.taskName,0,sizeof(notify.taskName));
    strcpy(notify.taskName, task->taskName);
    sys_notify(GLTP_NTF_SYS_TASK_FAULT, _FATAL, (char *)&notify, sizeof(notify));
}


int32 sys_check_task()
{
    if (SYS_STATUS_BUSINESS != sysdb_getSysStatus())
    {
        return 0;
    }

    for (int32 i=0; i<SYS_MAX_TASK_COUNT; i++)
    {
        SYS_TASK_RECORD *pTaskRecord = sysdb_getTask((SYS_TASK)i);
        if( NULL == pTaskRecord)
        {
            continue;
        }

        if ( pTaskRecord->process_exited )
        {
            //任务异常退出
            sys_send_task_notify(pTaskRecord);
            pTaskRecord->process_exited = false;
        }

        if (sys_check_process_alive(pTaskRecord->taskProcId))
        {
            //log_info("%s(pid[%d]) is still alive.", pTaskRecord->taskName, pTaskRecord->taskProcId);
            continue;
        }

        //if ( pTaskRecord->restartTask && (pTaskRecord->taskStatus==SYS_TASK_STATUS_CRASH) )
        if ( pTaskRecord->restartTask )
        {
            //自动加载
            if (sys_startTask((SYS_TASK)i)!=-1)
            {
                log_info("try to restart %s.", pTaskRecord->taskName);
                int retry_time = 0;
                while ( !exit_flag_g && (retry_time++ < 5) )
                {
                    if (SYS_TASK_STATUS_RUN == pTaskRecord->taskStatus)
                    {
                        log_info("%s start ok.", pTaskRecord->taskName);
                        break;
                    }

                    ts_sleep(1,1);
                    log_info("wait %s to start...", pTaskRecord->taskName);
                }
            }
            pTaskRecord->restartTask = 0;
        }
        /*
        else if ( !pTaskRecord->taskStartMode && (pTaskRecord->taskStatus==SYS_TASK_STATUS_RESTART))
        {
            if (sys_check_process_alive(pTaskRecord->taskProcId))
            {
                log_info("%s(pid[%d]) is still alive.", pTaskRecord->taskName, pTaskRecord->taskProcId);

                continue;
            }

            // 手动运行
            if (sys_startTask((SYS_TASK)i)!=-1)
            {
                log_info("try to restart %s.", pTaskRecord->taskName);
                int retry_time = 0;
                while (!exit_flag_g&&retry_time++<5)
                {
                    if ( SYS_TASK_STATUS_RUN == pTaskRecord->taskStatus )
                    {
                        log_info("%s start ok.", pTaskRecord->taskName);
                        break;
                    }

                    sleep(1);
                    log_info("wait %s to start...", pTaskRecord->taskName);
                }
            }
        }
        */
    }
    return 0;
}

bool sys_testOmsDB(char * username,char * passwd,char * servicename)
{
    return otl_connectDB(username,passwd,servicename,1) ;
}

bool sys_init()
{
    if (!bqueue_create())
    {
        log_error("bqueue_create() return failed.");
        return false;
    }
    print_status("Init bqueues module", STATUS_OK);

    if (!ncpc_create())
    {
        log_error("ncpc_create() failed.");
        return false;
    }
    print_status("Init ncpc module", STATUS_OK);

    if (tfe_create()!=0)
    {
        log_error("tfe_create() failed.");
        return false;
    }
    print_status("Init tfe module", STATUS_OK);

    //caoxf__
    /*
    if (!tsc_create())
    {
        log_error("tsc_create() failed.");
        return false;
    }
    print_status("Init tscache module", STATUS_OK);
    */

    if (!gl_create())
    {
        log_error("gl_create() failed." );
        return false;
    }
    print_status("Init gl module", STATUS_OK);

    if (!tms_mgr()->TMSCreate())
    {
        log_error("tms_mgr()->TMSCreate() failed.");
        return false;
    }
    print_status("Init tms module", STATUS_OK);


    //--------------------------------------------
    if(!bq_init())
    {
        log_error("bq_init() false!.");
        return false;
    }

    if(!ncpc_init())
    {
        log_error("ncpc_init() false!.");
        return false;
    }

    if(!gl_init())
    {
        log_error("gl_init() false!.");
        return false;
    }

    if(tfe_init()!=0)
    {
        log_error("tfe_init() false!.");
        return false;
    }
    log_debug("------- After TFE Create -------");
    tfe_dump_offset();

    if(!tms_mgr()->TMSInit())
    {
        log_error("tms_mgr()->TMSInit() false!.");
        return false;
    }

    return true;
}

bool sys_close()
{
    //应该先close共享内存，然后再destroy
    tms_mgr()->TMSClose();

    if (!tms_mgr()->TMSDestroy())
    {
        log_error("tms destroy() failed.");
    }

    if (!ncpc_destroy())
    {
        log_error("ncpc_destroy() failed.");
    }

    //销毁全部游戏插件
    GAME_PLUGIN_INTERFACE *game_plugins_handle = gl_plugins_handle();
    GAME_DATA *game_data = NULL;
    uint8 gameidx;
    for (gameidx = 0; gameidx < MAX_GAME_NUMBER; gameidx++)
    {
        game_data = gl_getGameData(gameidx);
        if (game_data->used == false)
        {
            continue;
        }

        //销毁游戏插件
        //game_data->gameEntry.gameCode
        bool ret = game_plugins_handle[gameidx].mem_destroy();
        log_info("game_plugin_destroy( %s ) [%s].", game_data->gameEntry.gameAbbr,ret?"success":"failed");
    }

    gl_game_plugins_close();
    game_plugins_handle = NULL;

    if (!gl_destroy())
    {
        log_error("gl_destroy() failed.");
    }

    if (!tfe_destroy())
    {
        log_error("tfe_destroy() failed.");
    }

    if (!bqueue_destroy())
    {
        log_error("bqueue_destroy() failed.");
    }

    //caoxf__
    /*
    if (!tsc_destroy())
    {
        log_error("tsc_destroy() failed.");
    }
    */

    return true;
}

bool sys_start_framework()
{
    /*
    sysdb_setTaskStatus(SYS_TASK_BQUEUESD, SYS_TASK_STATUS_START);
    if (sys_startTaskEx(SYS_TASK_BQUEUESD)!=0)
    {
        log_error("bqueuesd start [FAILURE].");
        return false;
    }
    log_info("bqueuesd start [OK].");
    */
    sysdb_setTaskStatus(SYS_TASK_NCPC_TASK, SYS_TASK_STATUS_START);
    if (sys_startTaskEx(SYS_TASK_NCPC_TASK)!=0)
    {
        return false;
    }
    log_info("ncpc_task start [OK].");

    sysdb_setTaskStatus(SYS_TASK_NCPC_AUTOPAY, SYS_TASK_STATUS_START);
    if (sys_startTaskEx(SYS_TASK_NCPC_AUTOPAY) != 0)
    {
        return false;
    }
    log_info("ncpc_ap_pay start [OK].");

    return true;
}


bool sys_game_init()
{
    int ret = 0;

    //从database获取游戏列表
    GAME_LIST game_list;
    if (otl_getGameList(&game_list) < 0)
    {
        log_error("otl_getGameList() failed.");
        print_status("Init game table", STATUS_FAILED);
        return false;
    }

    GAME_DATA *game_cfg_data = NULL;
    GAME_DATA *game_data = NULL;
    while (!game_list.empty())
    {
        game_cfg_data = game_list.front();

        if (!game_support(game_cfg_data->gameEntry.gameCode))
        {
            log_error("Game[%d] isn't support.", game_cfg_data->gameEntry.gameCode);
            print_status("Init game table", STATUS_FAILED);
            return false;
        }

        //init game parameter
        game_data = gl_getGameData(game_cfg_data->gameEntry.gameCode);
        strcpy(game_data->gameEntry.gameName, game_cfg_data->gameEntry.gameName);
        strcpy(game_data->gameEntry.organizationName, game_cfg_data->gameEntry.organizationName);
        memcpy(&game_data->policyParam, &game_cfg_data->policyParam, sizeof(POLICY_PARAM));
        DRAW_TYPE dt = game_cfg_data->transctrlParam.drawType;
        memcpy(&game_data->transctrlParam, &game_cfg_data->transctrlParam, sizeof(TRANSCTRL_PARAM));
        game_data->transctrlParam.drawType = dt;

        game_data->used = true;

        free(game_cfg_data);
        game_list.pop_front();
    }

    //加载RNG数据
    RNG_LIST rng_list;
    if (otl_getRngList(&rng_list) < 0)
    {
        log_error("otl_getRngList() failed.");
        print_status("Init rng table", STATUS_FAILED);
        return false;
    }
    RNG_PARAM *rng_cfg_param = NULL;

    uint32 rng_idx = 0;
    while (!rng_list.empty())
    {
        rng_cfg_param = rng_list.front();

        ret = gl_setGameParamRng(rng_cfg_param);
        if (ret < 0)
        {
            log_error("gl_setGameParamRng() failed.");
            print_status("Init rng table", STATUS_FAILED);
            return false;
        }

        if (rng_idx >= MAX_RNG_NUMBER)
            break;

        rng_idx++;


        free(rng_cfg_param);
        rng_list.pop_front();
    }

    //创建游戏插件使用的共享内存
    ret = gl_game_plugins_create();
    if(ret < 0)
    {
        log_error("gl_game_plugins_create() failed.");
        print_status("Init game table", STATUS_FAILED);
        return false;
    }

    return true;
}

uint64 reply_offset = 0; //------------------------------------------(临时方案)
bool sys_start_tfe_first()
{
    log_debug("After sys_start_tfe_first()");
    tfe_dump_offset();

    //更新reply的偏移和flush一样 ------------------------------------------(临时方案)
    reply_offset = tfe_get_offset(TFE_TASK_REPLY);
    tfe_set_offset(TFE_TASK_REPLY, tfe_get_offset(TFE_TASK_FLUSH));

    sysdb_setTaskStatus(SYS_TASK_TFE_FLUSH, SYS_TASK_STATUS_START);
    if (sys_startTaskEx(SYS_TASK_TFE_FLUSH)!=0)
    {
        return false;
    }
    log_info("tfe_flush start [OK].");

    sysdb_setTaskStatus(SYS_TASK_TFE_SCAN, SYS_TASK_STATUS_START);
    if (sys_startTaskEx(SYS_TASK_TFE_SCAN)!=0)
    {
        log_error("tfe_scan start [FAILURE].");
        return false;
    }
    log_info("tfe_scan start [OK].");

    sysdb_setTaskStatus(SYS_TASK_TFE_UPDATER, SYS_TASK_STATUS_START);
    if (sys_startTaskEx(SYS_TASK_TFE_UPDATER)!=0)
    {
        log_error("tfe_updater start [FAILURE].");
        return false;
    }
    log_info("tfe_updater start [OK].");

    sysdb_setTaskStatus(SYS_TASK_TFE_UPDATER_DB, SYS_TASK_STATUS_START);
    if (sys_startTaskEx(SYS_TASK_TFE_UPDATER_DB)!=0)
    {
        log_error("tfe_updater_db start [FAILURE].");
        return false;
    }
    log_info("tfe_updater_db start [OK].");

	/*
    sysdb_setTaskStatus(SYS_TASK_TFE_UPDATER_DB2, SYS_TASK_STATUS_START);
    if (sys_startTaskEx(SYS_TASK_TFE_UPDATER_DB2)!=0)
    {
        log_error("tfe_updater_db2 start [FAILURE].");
        return false;
    }
    log_info("tfe_updater_db2 start [OK].");
	*/
    /*
    sysdb_setTaskStatus(SYS_TASK_TFE_REMOTE_SYNC, SYS_TASK_STATUS_START);
    if (sys_startTaskEx(SYS_TASK_TFE_REMOTE_SYNC)!=0)
    {
        log_error("tfe_remote_sync start [FAILURE].");
        return false;
    }
    log_info("tfe_remote_sync start [OK].");
    */
    return true;
}

//等待数据库和TF同步完成
bool sys_wait_tfe_datbase_sync()
{
    uint64 t_offset_flush = tfe_get_offset(TFE_TASK_FLUSH);

    uint64 t_offset = tfe_get_offset(TFE_TASK_UPDATE);
    if (t_offset_flush != t_offset)
    {
        printf("\r------ FLUSH[ %lld ] UPDATE    [ %lld ] ---------", t_offset_flush, t_offset);
        return false;
    }
    printf("\r------ FLUSH[ %lld ] UPDATE    [ %lld ] ---------\n", t_offset_flush, t_offset);

    t_offset = tfe_get_offset(TFE_TASK_SCAN);
    if (t_offset_flush != t_offset)
    {
        printf("\r------ FLUSH[ %lld ] SCAN      [ %lld ] ---------", t_offset_flush, t_offset);
        return false;
    }
    printf("\r------ FLUSH[ %lld ] SCAN      [ %lld ] ---------\n", t_offset_flush, t_offset);

    t_offset = tfe_get_offset(TFE_TASK_UPDATE_DB);
    if (t_offset_flush != t_offset)
    {
        printf("\r------ FLUSH[ %lld ] UPDATE_DB [ %lld ] ---------", t_offset_flush, t_offset);
        return false;
    }
    printf("\r------ FLUSH[ %lld ] UPDATE_DB [ %lld ] ---------\n", t_offset_flush, t_offset);

    //t_offset = tfe_get_offset(TFE_TASK_UPDATE_DB2);
    //printf("------ FLUSH[ %lld ] UPDATE_DB2[ %lld ] ---------\n", t_offset_flush, t_offset);
    //if (t_offset_flush != t_offset)
    //{
        //return false;
        //printf("------ SKIP UPDATE_DB2 CHECK ---------\n");
    //}

    //还原reply的偏移 ------------------------------------------(临时方案)
    tfe_set_offset(TFE_TASK_REPLY, reply_offset);

    return true;
}


bool sys_load_game_issue_data()
{
    GAME_PLUGIN_INTERFACE *game_plugins_handle = gl_plugins_handle();
    int ret = 0;

    log_debug("sys_load_game_issue_data ---------> begin");

    uint8 gameidx;
    GAME_DATA *game_data = NULL;
    for (gameidx = 0; gameidx < MAX_GAME_NUMBER; gameidx++)
    {
        game_data = gl_getGameData(gameidx);
        if (game_data->used == false) {
            continue;
        }
        if (GAME_FBS==game_data->gameEntry.gameCode || GAME_FODD==game_data->gameEntry.gameCode) {
            continue;
        }

        TRANSCTRL_PARAM * transParam = gl_getTransctrlParam(game_data->gameEntry.gameCode);
        ISSUE_OLDCFG_LIST issue_list;
        ret = otl_getGameOldIssueList(game_data->gameEntry.gameCode, &issue_list,transParam->maxIssueCount * 2);
        if (ret < 0)
        {
            log_error("otl_getGameIssueList( gameCode[%d] ) failure.", game_data->gameEntry.gameCode);
            return false;
        }

        void *issue_cfg_data = NULL;
        while (!issue_list.empty())
        {
            issue_cfg_data = (void *)issue_list.front();

            //更新到共享内存
            int row = game_plugins_handle[game_data->gameEntry.gameCode].load_oldIssueData(issue_cfg_data,1);
            log_info("load_issueData( gameCode[%d] ) issue row[%d].", game_data->gameEntry.gameCode,row);

            uint64 issue = ((ISSUE_INFO *)issue_cfg_data)->issueNumber;
            PRIZE_PARAM_ISSUE prize[MAX_PRIZE_COUNT];
            memset((void *)prize , 0, sizeof(prize));
            if(otl_getIssuePrizeInfo(game_data->gameEntry.gameCode, issue,prize) < 0)
            {
                log_error("otl_getIssuePrizeInfo( gameCode[%d] issue[%lld]) failure.", game_data->gameEntry.gameCode,issue);
                return false;
            }
            if( !game_plugins_handle[game_data->gameEntry.gameCode].load_prizeParam(issue,prize))
            {
                log_error("load_prizeParam( gameCode[%d] issue[%lld]) failure.", game_data->gameEntry.gameCode,issue);
                return false;
            }
            log_info("load_prizeParam( gameCode[%d] issue [%lld]) ok.", game_data->gameEntry.gameCode,issue);

            /*
            char rkBuf[512] = {0};
            if(!otl_getIssueRKInfo(game_data->gameEntry.gameCode, issue,rkBuf))
            {
                log_error("otl_getIssueRKInfo( gameCode[%d] issue[%lld]) failure.", game_data->gameEntry.gameCode,issue);
                return false;
            }
            */

            if(transParam->riskCtrl)
            {
                uint32 issueSeq = ((ISSUE_INFO *)issue_cfg_data)->serialNumber;
                game_plugins_handle[game_data->gameEntry.gameCode].load_issue_RKdata(issueSeq,1,transParam->riskCtrlParam);
                log_info("load_issue_RKdata game[%d] rkParam[%s] over",game_data->gameEntry.gameCode,transParam->riskCtrlParam);
            }

            free((char *)issue_cfg_data);
            issue_list.pop_front();
        }
    }

    log_debug("sys_load_game_issue_data ---------< end");
    return true;
}


bool sys_load_game_fbs_data()
{
    GAME_PLUGIN_INTERFACE *game_plugins_handle = gl_plugins_handle();
    int ret = 0;

    log_debug("sys_load_game_fbs_data ---------> begin");

    uint8 gameidx;
    GAME_DATA *game_data_fbs = gl_getGameData(GAME_FBS);
    if (game_data_fbs->used == true) {
        //加载有未开奖的比赛及期次
        int count = 0;
        DB_FBS_ISSUE issueLst[FBS_MAX_ISSUE_NUM];
        memset((void *)issueLst, 0, sizeof(DB_FBS_ISSUE) * FBS_MAX_ISSUE_NUM);
        if (otl_fbs_getIssueWhenStart(GAME_FBS, &count, issueLst))
        {
            for (int i = 0; i < count; i++)
            {
                int matchCount = 0;
                DB_FBS_MATCH matchLst[FBS_MAX_ISSUE_MATCH];
                memset((void *)matchLst, 0, sizeof(DB_FBS_MATCH) * FBS_MAX_ISSUE_MATCH);
                if (otl_fbs_getMatchByIssue(GAME_FBS, issueLst[i].issue_number, &matchCount, matchLst))
                {
                    game_plugins_handle[GAME_FBS].fbs_load_issue(1, &issueLst[i]);
                    game_plugins_handle[GAME_FBS].fbs_load_match(matchCount, issueLst[i].issue_number, matchLst);
                }
                else
                {
                    log_error("otl_fbs_getMatchByIssue error! issue_number[%d]", count);
                    return false;
                }
            }
        }
        else
        {
            log_error("otl_fbs_getIssueWhenStart error! count[%d]", count);
            return false;
        }
        ;
        ;
        ;
    }

    GAME_DATA *game_data_fodd = gl_getGameData(GAME_FODD);
    if (game_data_fodd->used == true) {
        //加载有未开奖的比赛及期次
        ;
        ;
        ;
    }

    log_debug("sys_load_game_fbs_data ---------< end");
    return true;
}

void *sys_load_data_thread(void *arg)
{
    int *step = (int *)arg;

    if (sys_load_game_issue_data() == false)
    {
        log_error("load_game_issue_data() [FAILURE].");
        exit(-1);
    }
    if (sys_load_game_fbs_data() == false)
    {
        log_error("load_game_fbs_data() [FAILURE].");
        exit(-1);
    }
    *step = 1;
    return 0;
}

bool sys_recover_snapshot_data()
{
    //从tfe得到checkpoint的标记编号
    uint64 checkpoint_seq = tfe_get_checkpoint_seq();
    if (0 == checkpoint_seq)
        return true;

    char snapshot_path[128];
    sprintf(snapshot_path, "%s/%llu", SNAPSHOT_DATA_SUBDIR, checkpoint_seq);

    log_debug("recover snapshot data  < %llu > ------> begin", checkpoint_seq);

    //恢复sysdb
    if (sysdb_chkp_restore(snapshot_path) < 0)
    {
        log_error("sysdb_chkp_restore() failed.");
        return false;
    }
    //恢复game
    if (gl_chkp_restore(snapshot_path) < 0)
    {
        log_error("gl_chkp_restore() failed.");
        return false;
    }

    //游戏插件数据恢复，包括:期次数据统计、期次风险控制等
    GAME_PLUGIN_INTERFACE *game_plugins_handle = gl_plugins_handle();
    GAME_DATA *game_data = NULL;
    uint8 gameidx;
    for (gameidx = 0; gameidx < MAX_GAME_NUMBER; gameidx++)
    {
        game_data = gl_getGameData(gameidx);
        if (game_data->used == false)
            continue;

        if (false == game_plugins_handle[gameidx].chkp_restoreData(snapshot_path))
        {
            log_error("game plugins chkp_restoreData failure. game[%d].", gameidx);
            return false;
        }
    }

    log_debug("recover snapshot data  < %llu > ------< end", checkpoint_seq);

    return true;
}

bool sys_start_data_resume_task()
{
    //启动tfe_reply任务进行数据恢复
    //tfe_reply任务在启动恢复阶段只处理对期次风险控制有影响的tf记录
    sysdb_setTaskStatus(SYS_TASK_TFE_REPLY, SYS_TASK_STATUS_START);
    if (sys_startTaskEx(SYS_TASK_TFE_REPLY)!=0)
    {
        log_error("Start tfe_reply task failure.\n");
        return false;
    }
    log_info("tfe_reply start [OK].");
    return true;
}

bool sys_check_data_resume()
{
    //等待reply任务到达文件尾，共享内存恢复完成
    uint64 t_offset_flush = tfe_get_offset(TFE_TASK_FLUSH);

    uint64 t_offset = tfe_get_offset(TFE_TASK_REPLY);
    if (t_offset_flush != t_offset)
    {
        return false;
    }
    //更新adder的count数目准确
    tfe_reinit_adder_count();
    return true;
}


bool sys_start_operation_task()
{
    //TF task
    sysdb_setTaskStatus(SYS_TASK_TFE_ADDER, SYS_TASK_STATUS_START);
    if (sys_startTaskEx(SYS_TASK_TFE_ADDER)!=0)
    {
        return false;
    }
    log_info("tf_adder start [OK].");

    //启动gl相关task
    sysdb_setTaskStatus(SYS_TASK_GL_DRIVER, SYS_TASK_STATUS_START);
    if (sys_startTaskEx(SYS_TASK_GL_DRIVER)!=0)
    {
        return false;
    }
    log_info("gl_driver start [OK].");

    //gl_fbs_driver
    if (game_support(GAME_FBS) || game_support(GAME_FODD))
    {
        sysdb_setTaskStatus(SYS_TASK_GL_FBS_DRIVER, SYS_TASK_STATUS_START);
        if (sys_startTaskEx(SYS_TASK_GL_FBS_DRIVER) != 0)
        {
            return false;
        }
        log_info("gl_fbs_driver start [OK].");
    }

    sysdb_setTaskStatus(SYS_TASK_RNG_SERVER, SYS_TASK_STATUS_START);
    if (sys_startTaskEx(SYS_TASK_RNG_SERVER)!=0)
    {
        return false;
    }
    log_info("rng_server start [OK].");

    //循环游戏列表，启动各个游戏的gl_draw任务
    int32 idx = SYS_TASK_EMPTY;
    for (idx=SYS_TASK_GL_DRAW; idx<SYS_TASK_TFE_ADDER; idx++)
    {
        SYS_TASK_RECORD *pTask = sysdb_getTask((SYS_TASK)idx);
        if( NULL == pTask)
            continue;
        sysdb_setTaskStatus((SYS_TASK)idx, SYS_TASK_STATUS_START);
        if (sys_startTaskEx((SYS_TASK)idx)!=0)
        {
            return false;
        }
        log_info("%s start [OK].", pTask->taskName);
    }
    return true;
}


void sys_stop_task_1()
{
    sys_stopTaskEx(SYS_TASK_NCPC_AUTOPAY);
    sys_stopTaskEx(SYS_TASK_NCPC_TASK);
    sys_stopTaskEx(SYS_TASK_GL_DRIVER);
    sys_stopTaskEx(SYS_TASK_GL_FBS_DRIVER);
}


//检查所有的TFE相关任务均达到TF尾部
bool sys_wait_close_sync()
{
    uint64 t_offset_adder = tfe_get_offset(TFE_TASK_ADDER);
    uint64 t_offset_flush = tfe_get_offset(TFE_TASK_FLUSH);
    if (t_offset_adder != t_offset_flush)
    {
        return false;
    }

    uint64 t_offset = tfe_get_offset(TFE_TASK_REPLY);
    if (t_offset_flush != t_offset)
    {
        return false;
    }

    t_offset = tfe_get_offset(TFE_TASK_SCAN);
    if (t_offset_flush != t_offset)
    {
        return false;
    }

    t_offset = tfe_get_offset(TFE_TASK_UPDATE);
    if (t_offset_flush != t_offset)
    {
        return false;
    }

    t_offset = tfe_get_offset(TFE_TASK_UPDATE_DB);
    if (t_offset_flush != t_offset)
    {
        return false;
    }

	/*
    t_offset = tfe_get_offset(TFE_TASK_UPDATE_DB2);
    if (t_offset_flush != t_offset)
    {
        return false;
    }
	*/

    /*
    t_offset = tfe_get_offset(TFE_TASK_REMOTE_SYNC);
    if (t_offset_flush != t_offset)
    {
        return false;
    }
    */

    //等待gl_draw 完成开奖相关的处理
    //
    //
    //
    
    return true;
}


void sys_stop_task_2()
{
    sys_stopTaskEx(SYS_TASK_RNG_SERVER);
    sys_wait_task_stop(SYS_TASK_TFE_ADDER);

    int32 idx = SYS_TASK_EMPTY;
    for (idx=SYS_TASK_GL_DRAW; idx<SYS_TASK_TFE_ADDER; idx++)
    {
        sys_wait_task_stop((SYS_TASK)idx);
    }
}

void sys_stop_task_3()
{
    sys_wait_task_stop(SYS_TASK_TFE_REPLY);
    sys_wait_task_stop(SYS_TASK_TFE_SCAN);
    sys_wait_task_stop(SYS_TASK_TFE_UPDATER);
    sys_wait_task_stop(SYS_TASK_TFE_UPDATER_DB);

    sys_stopTaskEx(SYS_TASK_TFE_FLUSH);
    sys_wait_task_stop(SYS_TASK_TFE_FLUSH);
}


//send system stste to BUSINESS
bool sys_send_business_state()
{
    int ret = 0;

    FID fid_tfe_adder = getFidByName("tfe_adder");
    INM_MSG_HEADER inm_msg;
    memset((char *)&inm_msg, 0, sizeof(INM_MSG_HEADER));
    inm_msg.length = sizeof(INM_MSG_HEADER);
    inm_msg.type = INM_TYPE_SYS_BUSINESS_STATE;
    inm_msg.when = get_now();
    inm_msg.status = SYS_RESULT_SUCCESS;
    ret = bq_send(fid_tfe_adder, (char*)&inm_msg, inm_msg.length);
    if( ret<=0 )
    {
        //BQueues出错
        log_warn("sys_send_business_state()::bq_send business state return error. fid:%i", fid_tfe_adder);
        return false;
    }
    return true;
}


// Notify process ---------------------------------------------------

int sys_format_notify(GLTP_MSG_NTF_HEADER *ntf_header, int& event_type, char *str_buf)
{
    char *ntf_body = ntf_header->data;
    switch(ntf_header->func) {
        case GLTP_NTF_SYS_TASK_FAULT: //7011 系统任务异常
        {
            event_type = 1;
            GLTP_MSG_NTF_SYS_TASK_FAULT* nfy = (GLTP_MSG_NTF_SYS_TASK_FAULT*)ntf_body;
            sprintf(str_buf, "task status warning.[%s]",nfy->taskName);
            break;
        }
        case GLTP_NTF_DB_EXCEPTION: //7012 数据库连接失败
        {
            event_type = 1;
            GLTP_MSG_NTF_DB_EXCEPTION* nfy = (GLTP_MSG_NTF_DB_EXCEPTION*)ntf_body;
            sprintf(str_buf, "database connection error.[%s]",(nfy->db_type==1)?"OMS":"MIS");
            break;
        }
        case GLTP_NTF_DB_DEAL_FALSE: //7013 数据库业务执行失败
        {
            event_type = 1;
            GLTP_MSG_NTF_DB_DEALFALSE* nfy = (GLTP_MSG_NTF_DB_DEALFALSE*)ntf_body;
            sprintf(str_buf, "database operation failure.[%s]",nfy->dealFalse);
            break;
        }
        case GLTP_NTF_BQ_BUFFER_NOTENOUGH: //7021 BQueues Buffer不足报警事件
        {
            event_type = 1;
            GLTP_MSG_NTF_BQ_BUFFER_NOTENOUGH* nfy = (GLTP_MSG_NTF_BQ_BUFFER_NOTENOUGH*)ntf_body;
            sprintf(str_buf, "bqueues insufficient buffer. bufferType[%u] remainBuffNum[%u]",nfy->bufferType,nfy->remainBuffNum);
            break;
        }
        case GLTP_NTF_BQ_LINK_STATUS: //7022 BQueues链路状态变更
        {
            event_type = 1;
            GLTP_MSG_NTF_BQ_LINK_STATUS* nfy = (GLTP_MSG_NTF_BQ_LINK_STATUS*)ntf_body;
            sprintf(str_buf, "bqueues connection status modified.[%s, %s] %s", nfy->AModIP,nfy->BModIP, (nfy->linkState==1)?"Disconnect":"Connect");
            break;
        }
        case GLTP_NTF_NCP_STATUS: //7041 NCP可用状态改变事件
        {
            event_type = 1;
            GLTP_MSG_NTF_NCP_STATUS* nfy = (GLTP_MSG_NTF_NCP_STATUS*)ntf_body;
            sprintf(str_buf, "NCP status modified.[%s %s]",nfy->ipaddr,(nfy->status==1)?"Enable":((nfy->status==2)?"Disable":((nfy->status==3)?"Delete":"Unknow")));
            break;
        }
        case GLTP_NTF_NCP_LINK_STATUS: //7042 NCP链路状态改变事件
        {
            event_type = 1;
            GLTP_MSG_NTF_NCP_LINK* nfy = (GLTP_MSG_NTF_NCP_LINK*)ntf_body;
            sprintf(str_buf, "NCP connection status modified.[%s %s]",nfy->ipaddr,(nfy->connect==0)?"Disconnect":"Connect");
            break;
        }

        case GLTP_NTF_GL_SALE_MONEY_WARN: //7101 单票大额销售告警
        {
            event_type = 2;
            GLTP_MSG_NTF_GL_SALE_MONEY_WARN* nfy = (GLTP_MSG_NTF_GL_SALE_MONEY_WARN*)ntf_body;
            sprintf(str_buf, "single-ticket large-amount sale warning. agency[%llu] amount[%lld]",nfy->agencyCode,nfy->salesAmount);
            break;
        }
        case GLTP_NTF_GL_PAY_MONEY_WARN: //7102 单票大额兑奖告警
        {
            event_type = 2;
            GLTP_MSG_NTF_GL_PAY_MONEY_WARN* nfy = (GLTP_MSG_NTF_GL_PAY_MONEY_WARN*)ntf_body;
            sprintf(str_buf, "single-ticket large-amount payout warning. agency[%llu] amount[%lld]",nfy->agencyCode,nfy->payAmount);
            break;
        }
        case GLTP_NTF_GL_CANCEL_MONEY_WARN: //7103 单票大额取消告警
        {
            event_type = 2;
            GLTP_MSG_NTF_GL_CANCEL_MONEY_WARN* nfy = (GLTP_MSG_NTF_GL_CANCEL_MONEY_WARN*)ntf_body;
            sprintf(str_buf, "single-ticket large-amount refund warning. agency[%llu] amount[%lld]",nfy->agencyCode,nfy->cancelAmount);
            break;
        }
        case GLTP_NTF_GL_CONTROL_GAME: //7104 游戏状态变化(是否可销售、是否可兑奖、是否可退票)
        {
            event_type = 2;
            GLTP_MSG_NTF_GL_CONTROL_GAME* nfy = (GLTP_MSG_NTF_GL_CONTROL_GAME*)ntf_body;
            sprintf(str_buf, "game status modified. game[%u] %s[%s]",
                nfy->gameCode, (nfy->flag==1)?"Sale":((nfy->flag==2)?"Payout":((nfy->flag==3)?"Refund":"Unknow")), (nfy->status==1)?"True":"False");
            break;
        }
        case GLTP_NTF_GL_ISSUE_STATUS: //7105 期次状态变化
        {
            event_type = 2;
            GLTP_MSG_NTF_GL_ISSUE_STATUS* nfy = (GLTP_MSG_NTF_GL_ISSUE_STATUS*)ntf_body;
            sprintf(str_buf, "issue status modified. game[%u] issue[%u] status[%s]", nfy->gameCode, nfy->issueNumber, ISSUE_STATE_STR_S(nfy->nowStatus));
            break;
        }
        case GLTP_NTF_GL_ISSUE_FLOW_ERR: //7107 期结过程出现错误
        {
            event_type = 2;
            GLTP_MSG_NTF_GL_ISSUE_FLOW_ERR* nfy = (GLTP_MSG_NTF_GL_ISSUE_FLOW_ERR*)ntf_body;
            sprintf(str_buf, "error occurred in end-of-issue processing. game[%u] issue[%u] status[%s] error[%u]",
                nfy->gameCode, nfy->issueNumber, ISSUE_STATE_STR_S(nfy->issueStatus), nfy->error);
            break;
        }
        case GLTP_NTF_GL_ISSUE_AUTO_DRAW: //7108 游戏期次自动开奖状态变化(自动开奖游戏，自动开奖标记改变)
        {
            event_type = 2;
            GLTP_MSG_NTF_GL_ISSUE_AUTO_DRAW* nfy = (GLTP_MSG_NTF_GL_ISSUE_AUTO_DRAW*)ntf_body;
            sprintf(str_buf, "auto-draw status modified. game[%u] state[%s]",nfy->gameCode,(nfy->status==1)?"True":"False");
            break;
        }
        case GLTP_NTF_GL_RISK_CTRL: //7109 风险控制警告
        {
            event_type = 2;
            GLTP_MSG_NTF_GL_RISK_CTRL* nfy = (GLTP_MSG_NTF_GL_RISK_CTRL*)ntf_body;
            sprintf(str_buf, "risk control warning. game[%u] issue[%u] subType[%u]",nfy->gameCode, nfy->issueNumber, nfy->subType);
            break;
        }

        case GLTP_NTF_GL_RNG_STATUS: //7111 RNG可用状态变化
        {
            event_type = 3;
            GLTP_MSG_NTF_GL_RNG_STATUS* nfy = (GLTP_MSG_NTF_GL_RNG_STATUS*)ntf_body;
            sprintf(str_buf, "RNG enabled status modified. [%s %s]",nfy->ipaddr,(nfy->status==1)?"Enable":((nfy->status==2)?"Disable":((nfy->status==3)?"Delete":"Unknow")));
            break;
        }
        case GLTP_NTF_GL_RNG_WORK_STATUS: //7112 RNG链路状态变化
        {
            event_type = 3;
            GLTP_MSG_NTF_GL_RNG_WORK_STATUS* nfy = (GLTP_MSG_NTF_GL_RNG_WORK_STATUS*)ntf_body;
            sprintf(str_buf, "RNG work status modified. [%s %s]",
                nfy->ipaddr,(nfy->workStatus==1)?"CONNECT":((nfy->workStatus==2)?"INITIALIZING":((nfy->workStatus==3)?"WORKING":"DISCONNECT")));
            break;
        }
        case GLTP_NTF_GL_POLICY_PARAM: //7113 修改游戏政策参数
        {
            event_type = 3;
            GLTP_MSG_NTF_GL_POLICY_PARAM* nfy = (GLTP_MSG_NTF_GL_POLICY_PARAM*)ntf_body;
            sprintf(str_buf, "modify game policy parameters. game[%u]",nfy->gameCode);
            break;
        }
        case GLTP_NTF_GL_RULE_PARAM: //7114 修改游戏普通规则参数
        {
            event_type = 3;
            GLTP_MSG_NTF_GL_RULE_PARAM* nfy = (GLTP_MSG_NTF_GL_RULE_PARAM*)ntf_body;
            sprintf(str_buf, "modify game rule parameters. game[%u]",nfy->gameCode);
            break;
        }
        case GLTP_NTF_GL_CTRL_PARAM: //7115 修改游戏控制参数
        {
            event_type = 3;
            GLTP_MSG_NTF_GL_CTRL_PARAM* nfy = (GLTP_MSG_NTF_GL_CTRL_PARAM*)ntf_body;
            sprintf(str_buf, "modify game control parameters. game[%u]",nfy->gameCode);
            break;
        }
        case GLTP_NTF_GL_RISK_CTRL_PARAM: //7117 修改游戏风险控制参数
        {
            event_type = 3;
            GLTP_MSG_NTF_GL_RISK_CTRL_PARAM* nfy = (GLTP_MSG_NTF_GL_RISK_CTRL_PARAM*)ntf_body;
            sprintf(str_buf, "modify game risk control parameters. game[%u]",nfy->gameCode);
            break;
        }
        case GLTP_NTF_TMS_TERM_MSN_ERR: //7219 终端机MSN错误
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_TERM_MSN_ERR* nfy = (GLTP_MSG_NTF_TMS_TERM_MSN_ERR*)ntf_header;
            sprintf(str_buf, "terminal MSN error. terminal[%llu] recvMsn[%u] msn[%u]", nfy->termCode, nfy->recvMsn, nfy->msn);
            break;
        }
        case GLTP_NTF_TMS_TERM_BUSY_ERR: //7220 终端机BUSY错误
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_TERM_BUSY_ERR* nfy = (GLTP_MSG_NTF_TMS_TERM_BUSY_ERR*)ntf_header;
            sprintf(str_buf, "terminal busy error. terminal[%llu]", nfy->termCode);
            break;
        }

        case GLTP_NTF_GL_FBS_DRAW_ERR: //7150 比赛开奖错误
        {
            event_type = 2;
            GLTP_MSG_NTF_GL_FBS_DRAW_ERR* nfy = (GLTP_MSG_NTF_GL_FBS_DRAW_ERR*)ntf_header;
            sprintf(str_buf, "Fbs match draw error[%u]. issue[%lu] match[%llu] state[%u]", nfy->error, nfy->issueNumber, nfy->matchCode, MATCH_STATE_STR(nfy->matchStatus));
            break;
        }
        case GLTP_NTF_GL_FBS_DRAW_CONFIRM: //7151 比赛开奖完成
        {
            event_type = 2;
            GLTP_MSG_NTF_GL_FBS_DRAW_CONFIRM* nfy = (GLTP_MSG_NTF_GL_FBS_DRAW_CONFIRM*)ntf_header;
            sprintf(str_buf, "Fbs match draw finish. issue[%lu] match[%llu]", nfy->issueNumber, nfy->matchCode);
            break;
        }

#if 0 //__DEF_PIL

        case GLTP_NTF_TMS_AREA_ADD: //7201 增加区域
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_AREA_ADD* nfy = (GLTP_MSG_NTF_TMS_AREA_ADD*)ntf_header;
            sprintf(str_buf, "add region. area[%u %s]",nfy->areaCode,nfy->areaName);
            break;
        }
        case GLTP_NTF_TMS_AREA_MODIFY: //7202 修改区域
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_AREA_MODIFY* nfy = (GLTP_MSG_NTF_TMS_AREA_MODIFY*)ntf_header;
            sprintf(str_buf, "region information modified. area[%u %s]",nfy->areaCode,nfy->areaName);
            break;
        }
        case GLTP_NTF_TMS_AREA_STATUS: //7203 区域可用状态变更
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_AREA_STATUS* nfy = (GLTP_MSG_NTF_TMS_AREA_STATUS*)ntf_header;
            sprintf(str_buf, "region status modified. area[%u] status[%s]",nfy->areaCode,(nfy->status==1)?"Enable":((nfy->status==2)?"Disable":((nfy->status==3)?"Delete":"Unknow")));
            break;
        }
        case GLTP_NTF_TMS_AREA_CTRL_GAME: //7204 区域授权游戏参数变更
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_AREA_CTRL_GAME* nfy = (GLTP_MSG_NTF_TMS_AREA_CTRL_GAME*)ntf_header;
            sprintf(str_buf, "game authorization in region. ctrlCode[%llu] gameCount[%u]",nfy->ctrlCode,nfy->gameCount);
            break;
        }
        case GLTP_NTF_TMS_AREA_CTRL_AGENCY_GAME: //7205 区域销售站授权游戏参数变更
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_AREA_CTRL_AGENCY_GAME* nfy = (GLTP_MSG_NTF_TMS_AREA_CTRL_AGENCY_GAME*)ntf_header;
            sprintf(str_buf, "game authorization in agency. ctrlCode[%llu] gameCount[%u]",nfy->ctrlCode,nfy->gameCount);
            break;

        }
        case GLTP_NTF_TMS_AGENCY_ADD: //7206 增加销售站
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_AGENCY_ADD* nfy = (GLTP_MSG_NTF_TMS_AGENCY_ADD*)ntf_header;
            sprintf(str_buf, "add agency. agency[%llu %s] type[%u] availableCredit[%lld]",nfy->agencyCode,nfy->agencyName,nfy->agencyType,nfy->availableCredit);
            break;
        }
        case GLTP_NTF_TMS_AGENCY_MODIFY: //7207 修改销售站
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_AGENCY_MODIFY* nfy = (GLTP_MSG_NTF_TMS_AGENCY_MODIFY*)ntf_header;
            sprintf(str_buf, "agency information modified. agency[%llu %s] type[%u]",nfy->agencyCode,nfy->agencyName,nfy->agencyType);
            break;
        }
        case GLTP_NTF_TMS_AGENCY_STATUS: //7208 销售站可用状态
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_AGENCY_STATUS* nfy = (GLTP_MSG_NTF_TMS_AGENCY_STATUS*)ntf_header;
            sprintf(str_buf, "agency enable status modified. agency[%llu %s]",nfy->agencyCode,(nfy->status==1)?"Enable":((nfy->status==2)?"Disable":((nfy->status==3)?"Delete":"Unknow")));
            break;
        }
        case GLTP_NTF_TMS_AGENCY_DEPOSIT: //7210 销售站缴款
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_AGENCY_DEPOSIT* nfy = (GLTP_MSG_NTF_TMS_AGENCY_DEPOSIT*)ntf_header;
            sprintf(str_buf, "agency deposit. agency[%llu] depositAmount[%lld] availableCredit[%lld]",nfy->agencyCode,nfy->depositAmount,nfy->availableCredit);
            break;
        }
        case GLTP_NTF_TMS_AGENCY_CREDIT_LIMIT: //7211 销售站信用额度变更
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_AGENCY_CREDIT_LIMIT* nfy = (GLTP_MSG_NTF_TMS_AGENCY_CREDIT_LIMIT*)ntf_header;
            sprintf(str_buf, "modify agency credit limit. agency[%llu] availableCredit[%lld] marginalCreditLimit[%lld] tempMarginalCreditLimit[%lld]",
                nfy->agencyCode,nfy->availableCredit,nfy->marginalCreditLimit,nfy->tempMarginalCreditLimit);
            break;
        }
        case GLTP_NTF_TMS_AGENCY_PAY_TICKET_WARN: //7212 销售站每日兑奖数量(或者金额)超过阈值告警
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_AGENCY_PAY_TICKET_WARN* nfy = (GLTP_MSG_NTF_TMS_AGENCY_PAY_TICKET_WARN*)ntf_header;
            sprintf(str_buf, "agency payout amount exceeding daily limit. agency[%llu] totalPayCount[%u] totalPayAmount[%lld]",nfy->agencyCode,nfy->totalPayCount,nfy->totalPayAmount);
            break;
        }
        case GLTP_NTF_TMS_AGENCY_CANCEL_TICKET_WARN: //7213 销售站每日退票数量(或者金额)超过阈值告警
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_AGENCY_CANCEL_TICKET_WARN* nfy = (GLTP_MSG_NTF_TMS_AGENCY_CANCEL_TICKET_WARN*)ntf_header;
            sprintf(str_buf, "agency refund amount exceeding daily limit. agency[%llu] totalCancelCount[%u] totalCancelAmount[%lld]",nfy->agencyCode,nfy->totalCancelCount,nfy->totalCancelAmount);
            break;

        }
        case GLTP_NTF_TMS_TERM_ADD: //7214 增加终端机
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_TERM_ADD* nfy = (GLTP_MSG_NTF_TMS_TERM_ADD*)ntf_header;
            sprintf(str_buf, "add terminal. terminal[%llu] status[%u] machineType[%u] train[%u]",nfy->termCode,nfy->status,nfy->machineType,nfy->isTrain);
            break;
        }
        case GLTP_NTF_TMS_TERM_MODIFY: //7215 修改终端机
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_TERM_MODIFY* nfy = (GLTP_MSG_NTF_TMS_TERM_MODIFY*)ntf_header;
            sprintf(str_buf, "terminal information modified. terminal[%llu] status[%u] machineType[%u] train[%u]",nfy->termCode,nfy->status,nfy->machineType,nfy->isTrain);
            break;
        }
        case GLTP_NTF_TMS_TERM_STATUS: //7216 终端机可用状态
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_TERM_STATUS* nfy = (GLTP_MSG_NTF_TMS_TERM_STATUS*)ntf_header;
            sprintf(str_buf, "terminal status modified. terminal[%llu] status[%s]",nfy->termCode,(nfy->status==1)?"Enable":((nfy->status==2)?"Disable":((nfy->status==3)?"Delete":"Unknow")));
            break;
        }
        case GLTP_NTF_TMS_TELLER_ADD: //7221 增加销售员事件
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_TELLER_ADD* nfy = (GLTP_MSG_NTF_TMS_TELLER_ADD*)ntf_header;
            sprintf(str_buf, "add teller. teller[%u] tellerType[%u] status[%u]",nfy->tellerCode,nfy->tellerType,nfy->status);
            break;
        }
        case GLTP_NTF_TMS_TELLER_MODIFY: //7222 修改销售员事件
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_TELLER_MODIFY* nfy = (GLTP_MSG_NTF_TMS_TELLER_MODIFY*)ntf_header;
            sprintf(str_buf, "teller information modified. teller[%u] tellerType[%u] status[%u]",nfy->tellerCode,nfy->tellerType,nfy->status);
            break;
        }
        case GLTP_NTF_TMS_TELLER_STATUS: //7223 销售员可用状态事件
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_TELLER_STATUS* nfy = (GLTP_MSG_NTF_TMS_TELLER_STATUS*)ntf_header;
            sprintf(str_buf, "teller enable status modified. teller[%u] status[%s]",nfy->tellerCode,(nfy->status==1)?"Enable":((nfy->status==2)?"Disable":((nfy->status==3)?"Delete":"Unknow")));
            break;

        }
        case GLTP_NTF_TMS_VERSION_ADD: //7224 增加版本信息事件
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_VERSION_ADD* nfy = (GLTP_MSG_NTF_TMS_VERSION_ADD*)ntf_header;
            sprintf(str_buf, "add terminal version. versionNo[%s] machineType[%u]",nfy->versionNo,nfy->machineType);
            break;
        }
        case GLTP_NTF_TMS_VERSION_MODIFY: //7225 修改版本信息事件
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_VERSION_MODIFY* nfy = (GLTP_MSG_NTF_TMS_VERSION_MODIFY*)ntf_header;
            sprintf(str_buf, "version information modified. versionNo[%s] machineType[%u]",nfy->versionNo,nfy->machineType);
            break;
        }
        case GLTP_NTF_TMS_VERSION_STATUS: //7226 版本可用状态事件
        {
            event_type = 4;
            GLTP_MSG_NTF_TMS_VERSION_STATUS* nfy = (GLTP_MSG_NTF_TMS_VERSION_STATUS*)ntf_header;
            sprintf(str_buf, "version status modified. versionNo[%s] status[%s]",nfy->versionNo,(nfy->status==1)?"Enable":((nfy->status==2)?"Disable":((nfy->status==3)?"Delete":"Unknow")));
            break;
        }
#endif

        default:
        {
            event_type = 1;
            sprintf(str_buf, "unknow notify func[%u]",ntf_header->func);
            log_error("unknow notify func[%u]",ntf_header->func);
            break;
        }
    }
    return 0;
}

void *sys_send_notify_thread(void *arg)
{
    ts_notused(arg);

    int32 len = 0;
    SOCKET clientSocket = 0;

    SYS_OMS_MONITOR *pOMCfg = sysdb_getOmsMonitorCfg();
    NETADDR addr;
    make_addr( &addr,pOMCfg->oms_monitor_ip,pOMCfg->oms_monitor_port);

#if 0 //for test
    SYS_OMS_MONITOR OMCfgTest1 = {"192.168.20.121", 12990};
    SYS_OMS_MONITOR *pOMCfgTest1 = &OMCfgTest1;
    NETADDR addrTest1;
    make_addr( &addrTest1,pOMCfgTest1->oms_monitor_ip,pOMCfgTest1->oms_monitor_port);

    SYS_OMS_MONITOR OMCfgTest2 = {"192.168.20.138", 12990};
    SYS_OMS_MONITOR *pOMCfgTest2 = &OMCfgTest2;
    NETADDR addrTest2;
    make_addr( &addrTest2,pOMCfgTest2->oms_monitor_ip,pOMCfgTest2->oms_monitor_port);
#endif

    if( (clientSocket = open_socket(SOCKET_UDP)) == false )
    {
        log_error("open socket error!\n");
        return 0;
    }

	const char *host_ip = "HOST";
    static char sbuf[8192];
    static char str_buf[16384];
    while (1)
    {
        //接收来自于IPC Queue的 Notify 消息
        len = sys_r_message(sbuf, 8192);
        if ( len <= 0 ) {
             log_error("receive message from IPC MessageQueue Failure.");
             return 0;
        }

        GLTP_MSG_NTF_HEADER *ntf_header = (GLTP_MSG_NTF_HEADER *)sbuf;
        int event_type = 0; str_buf[0] = 0;
        sys_format_notify(ntf_header, event_type, str_buf);
        log_info("Notify message -> func[%u] level[%u] %s", ntf_header->func,ntf_header->level,str_buf);

		if (!otl_insertNotifyEvent(host_ip, event_type, ntf_header->level, str_buf, ntf_header->when))
		{
			log_error("otl_insertNotifyEvent event_type[%d] str[%s]", event_type, str_buf);
		}
    }
    return 0;
}


