#include "global.h"
#include "tms_inf.h"
#include "gl_inf.h"
#include "tfe_inf.h"
#include "otl_inf.h"

#define MY_TASK_NAME "tfe_updater_db\0"

static volatile int exit_signal_fired = 0;
static volatile int timer_fired = 0;
static int issueEndFlag;
static int record_cnt;
static int switchSession;
static DB_STAT *db_stat;
static timer_t  tfeUpdateDBTimer;

FID ncpc_fid;

static int tfe_updater_db_dispatcher(char *inm_buf)
{
    INM_MSG_HEADER *pInm = (INM_MSG_HEADER *)inm_buf;
    switch (pInm->type)
    {
        case INM_TYPE_T_SELL_TICKET:
        {
            INM_MSG_T_SELL_TICKET *pInmSellTicket = (INM_MSG_T_SELL_TICKET *)pInm;
            if ( (pInmSellTicket->ticket.isTrain) ||
                (pInmSellTicket->header.inm_header.status != SYS_RESULT_SUCCESS) )
                break;

            record_cnt++;

            db_stat->db_tsn[db_stat->tsnCnt].used = true;
            memcpy(db_stat->db_tsn[db_stat->tsnCnt].reqfn_ticket, pInmSellTicket->reqfn_ticket, TSN_LENGTH);
            memcpy(db_stat->db_tsn[db_stat->tsnCnt].tsn, pInmSellTicket->rspfn_ticket, TSN_LENGTH);
            db_stat->tsnCnt++;

            //更新票号到oracle数据库
            //
            break;
        }

        case INM_TYPE_FBS_SELL_TICKET:
        {
            INM_MSG_FBS_SELL_TICKET *pInmSellTicket = (INM_MSG_FBS_SELL_TICKET *)pInm;
            FBS_TICKET *fbs_ticket = (FBS_TICKET*)(pInmSellTicket->betString+pInmSellTicket->betStringLen);
            if ( (fbs_ticket->is_train) ||
                (pInmSellTicket->header.inm_header.status != SYS_RESULT_SUCCESS) )
                break;

            record_cnt++;

            db_stat->db_tsn[db_stat->tsnCnt].used = true;
            memcpy(db_stat->db_tsn[db_stat->tsnCnt].reqfn_ticket, pInmSellTicket->reqfn_ticket, TSN_LENGTH);
            memcpy(db_stat->db_tsn[db_stat->tsnCnt].tsn, pInmSellTicket->rspfn_ticket, TSN_LENGTH);
            db_stat->tsnCnt++;

            //更新票号到oracle数据库
            //
            break;
        }

        case INM_TYPE_T_CANCEL_TICKET:
        {
            INM_MSG_T_CANCEL_TICKET *pInmCancelTicket = (INM_MSG_T_CANCEL_TICKET *)pInm;
            if ( (pInmCancelTicket->ticket.isTrain) ||
                (pInmCancelTicket->header.inm_header.status != SYS_RESULT_SUCCESS) )
                break;

            record_cnt++;
            break;
        }
        case INM_TYPE_T_PAY_TICKET:
        {
            INM_MSG_T_PAY_TICKET *pInmPayTicket = (INM_MSG_T_PAY_TICKET *)pInm;
            if ( (pInmPayTicket->isTrain) ||
                (pInmPayTicket->header.inm_header.status != SYS_RESULT_SUCCESS) )
                break;

            record_cnt++;
            break;
        }
        case INM_TYPE_RNG_STATUS:
        {
            INM_MSG_RNG_STATUS *pInmRngStatus = (INM_MSG_RNG_STATUS *)pInm;
            if (pInmRngStatus->header.status != SYS_RESULT_SUCCESS)
                break;

            record_cnt++;
            db_stat->rngCnt++;
            db_stat->db_rng[pInmRngStatus->rngId].used = true;
            db_stat->db_rng[pInmRngStatus->rngId].rngId = pInmRngStatus->rngId;
            db_stat->db_rng[pInmRngStatus->rngId].workStatus = pInmRngStatus->workStatus;
            break;
        }

        case INM_TYPE_SYS_SWITCH_SESSION:
        {
            switchSession = 1;
            timer_fired = 1;
            break;
        }

		case INM_TYPE_ISSUE_STATE_ISSUE_END:
		{
			issueEndFlag = 1;
			timer_fired = 1;
			break;
		}

        case INM_TYPE_TFE_CHECK_POINT:
        {
            if (SYS_STATUS_END==sysdb_getSysStatus() && pInm->status==0xFFFF)
            {
                //safe close checkpoint
                timer_fired = 1;
                exit_signal_fired = 1;
            }
            break;
        }

        default:
            return 1;
    }
    return 0;
}

static void signal_handler(int signo)
{
    ts_notused(signo);
    exit_signal_fired = 1;
    return;
}

static void signal_alarm(int signo)
{
    ts_notused(signo);
    timer_fired = 1;
    return;
}

static int init_signal(void)
{
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

    alarm(TIMER_INTERVAL);
    */
    return 0;
}

int main(int argc, char **argv)
{
    ts_notused(argc);
    ts_notused(argv);

    int ret = 0;

    logger_init(MY_TASK_NAME);
    log_info("%s start\n", MY_TASK_NAME);

    init_signal();

    tfeUpdateDBTimer = ts_timer_init(signal_alarm);
    if(tfeUpdateDBTimer < 0)
    {
    	log_error("ts_timer_init < 0! \n");
    	return -1;
    }

    ts_timer_set( tfeUpdateDBTimer, TIMER_INTERVAL,0);

    if (!sysdb_init()) {
        log_error("sysdb_init error.");
        return  -1;
    }
    //connect oracle database
    SYS_DB_CONFIG *sysDBconfig = sysdb_getOmsDBCfg();
    char dbConnStr[64] = {0};
    sprintf(dbConnStr,"%s/%s@%s",sysDBconfig->username,sysDBconfig->password,sysDBconfig->url);
    if (!otl_connectDB(sysDBconfig->username, sysDBconfig->password, sysDBconfig->url,1)) {
        log_error("otl_connectDB() failed.");
        return  -1;
    }

    if (!tms_mgr()->TMSInit()) {
        log_error("tms_mgr()->TMSInit() error.");
        sysdb_close();
        return -1;
    }

    if (!gl_init()) {
        log_error("gl_init() error.");
        sysdb_close();
        return -1;
    }

    ret = tfe_init();
    if (0 != ret)
    {
        log_error("tfe_init(%s) failed, ret[%d].", MY_TASK_NAME, ret);
        return -1;
    }

    void *tmp_stat = malloc(sizeof(DB_STAT));
    if (tmp_stat == NULL)
    {
        log_error("malloc DB_STAT failed.(%s)", MY_TASK_NAME);
        return -1;
    }

    db_stat = (DB_STAT *)tmp_stat;

    static char footmark_name[128];
    sprintf(footmark_name, "%s/%s.ft", TFE_DATA_SUBDIR, MY_TASK_NAME);

    ret = tfe_t_restore_footmark(footmark_name, TFE_TASK_UPDATE_DB);
    if (0 != ret)
    {
        log_error("tfe_t_restore_footmark( %s ) failed.", footmark_name);
        return -1;
    }

    ret = tfe_t_init(TFE_TASK_UPDATE_DB, TFE_TASK_UPDATE, "", true);
    if (0 != ret)
    {
        sysdb_close();
        gl_close();
        log_error("tfe_t_init(%s) failed, ret[%d].", MY_TASK_NAME, ret);
        return -1;
    }
    if (!bq_init())
    {
        sysdb_close();
        log_error("%s bq_init error.",MY_TASK_NAME);
        return -1;
    }

    ncpc_fid = getFidByName("ncpsend_queue");


    uint64 t_offset = tfe_get_offset(TFE_TASK_UPDATE_DB);
    uint64 t_pre_offset  = tfe_get_pre_offset(TFE_TASK_UPDATE_DB);
    log_debug("------ %s prepare running.  [ %lld  %lld ] ---------",
                MY_TASK_NAME, t_offset, t_pre_offset);

    sysdb_setTaskStatus(SYS_TASK_TFE_UPDATER_DB, SYS_TASK_STATUS_RUN );

    log_info("%s init success\n", MY_TASK_NAME);

    int total_rec_cnt = 0;
    static char inm_buf[INM_MSG_BUFFER_LENGTH];
    char *inmPtr = NULL;
    while (0 == exit_signal_fired)
    {
        ret = tfe_t_read((unsigned char *)inm_buf, INM_MSG_BUFFER_LENGTH, 200);
        if ((ret != 0) && (ret != TFE_TIMEOUT))
        {
            log_error("tfe_t_read() failed. ret[%d].", ret);
            break; //usleep(1000);
        }

        inmPtr = inm_buf+TFE_HEADER_LENGTH;
        if (ret == 0)
        {
            total_rec_cnt++;

            int ret_0 = tfe_updater_db_dispatcher(inmPtr);
            if (0 > ret_0)
            {
                DUMP_INMMSG(inmPtr);
                log_error("tfe_updater_db_dispatcher() failed");
                break;
            }
        }

        if ( (ret == TFE_TIMEOUT) || (record_cnt > 4999) || (total_rec_cnt > 20000) || (timer_fired==1) )
        {
            if (record_cnt > 0) {

                bool bRet = otl_data_commit_omDB(db_stat);
                if (!bRet) {
                    log_error("otl_data_commit_omDB() failed.");
                    return -1;
                }

                tfe_t_commit();
                tfe_t_keep_footmark(footmark_name, TFE_TASK_UPDATE_DB);
                record_cnt = 0;
				total_rec_cnt = 0;
                memset(tmp_stat, 0, sizeof(DB_STAT));
            }
			if (1 == issueEndFlag) 
			{
				tfe_t_commit();
				tfe_t_keep_footmark(footmark_name, TFE_TASK_UPDATE_DB);
				issueEndFlag = 0;
				total_rec_cnt = 0;
			}
            if (1 == switchSession)
            {
                //call oracle sp 标记日结
                INM_MSG_SYS_SWITCH_SESSION *pInmSwitchSession = (INM_MSG_SYS_SWITCH_SESSION *)inmPtr;
                if (!otl_switch_session_oms(pInmSwitchSession->curSession))
                {
                    log_error("otl_switch_session_oms return failure. date[ %d ]", pInmSwitchSession->curSession);
                    break;
                }
                tfe_t_commit();
                tfe_t_keep_footmark(footmark_name, TFE_TASK_UPDATE_DB);
                switchSession = 0;
				total_rec_cnt = 0;
            }

            if (total_rec_cnt > 0)
            {
            	if (( total_rec_cnt > 20000 ) || (timer_fired==1) )
            	{
                    tfe_t_commit();
                    tfe_t_keep_footmark(footmark_name, TFE_TASK_UPDATE_DB);
                    total_rec_cnt = 0;
            	}
            }

        }

        if (timer_fired == 1)
        {
            timer_fired = 0;
            ts_timer_set( tfeUpdateDBTimer, TIMER_INTERVAL,0);
        }
    }

    sysdb_setTaskStatus(SYS_TASK_TFE_UPDATER_DB, SYS_TASK_STATUS_EXIT);

    tms_mgr()->TMSClose();

    gl_close();

    bq_close();

    otl_disConnectDB();

    sysdb_close();

    log_info("%s exit\n", MY_TASK_NAME);

    return 0;
}

