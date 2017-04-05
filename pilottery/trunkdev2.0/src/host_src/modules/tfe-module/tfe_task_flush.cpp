#include "global.h"
#include "tfe_inf.h"

#define MY_TASK_NAME "tfe_flush\0"
#define CHECKPOINT_TIMER  (TIMER_INTERVAL*60*12)

static volatile int exit_signal_fired = 0;

timer_t  tfeFlushTimer;

FID fid_tfe_adder = 0;
static int alarm_timer = 1;
static int first_flag = 0;
static int send_safe_close = 0;

time_t checkpoint_lasttime = 0;
int send_check_point_message()
{
    int ret  = 0;
    int do_checkpoint = 0;

    if ( SYS_STATUS_BUSINESS == sysdb_getSysStatus())
    {
        time_t now = get_now();
        if((first_flag==0) || ((now-checkpoint_lasttime)>CHECKPOINT_TIMER))
        {
    	    first_flag = 1;
            checkpoint_lasttime = now;
            do_checkpoint = 1;
        }
        if (do_checkpoint == 0)
            return 0;

        //send checkpoint inm message
        INM_MSG_HEADER inm_msg;
        memset((char *)&inm_msg, 0, sizeof(INM_MSG_HEADER));
        inm_msg.length = sizeof(INM_MSG_HEADER);
        inm_msg.type = INM_TYPE_TFE_CHECK_POINT;
        inm_msg.when = get_now();
        inm_msg.status = SYS_RESULT_SUCCESS;
        ret = bq_send(fid_tfe_adder, (char*)&inm_msg, inm_msg.length);
        if( ret<=0 )
        {
            //BQueues出错
            log_warn("sendDataToBQ()::bq_send checkpoint messge return error. fid:%i", fid_tfe_adder);
        }
        checkpoint_lasttime = get_now();
        log_debug("Send checkpoint inm message");
    }
    if ((SYS_STATUS_END==sysdb_getSysStatus()) && (sysdb_getSafeClose()==1))
    {
        if (send_safe_close == 1)
            return 0;
        send_safe_close = 1; //send only one times

        //send safe close checkpoint
        INM_MSG_HEADER inm_msg;
        memset((char *)&inm_msg, 0, sizeof(INM_MSG_HEADER));
        inm_msg.length = sizeof(INM_MSG_HEADER);
        inm_msg.type = INM_TYPE_TFE_CHECK_POINT;
        inm_msg.when = get_now();
        inm_msg.status = 0xFFFF;
        ret = bq_send(fid_tfe_adder, (char*)&inm_msg, inm_msg.length);
        if( ret<=0 )
        {
            //BQueues出错
            log_warn("sendDataToBQ()::bq_send safe close checkpoint messge return error. fid:%i", fid_tfe_adder);
        }
        log_debug("Send safe close checkpoint inm message");
    }
    return 0;
}

static void signal_alarm(int signo)
{
    ts_notused(signo);

    send_check_point_message();

    //alarm(alarm_timer);
    ts_timer_set( tfeFlushTimer, alarm_timer,0);
    return;
}

static void signal_handler(int signo)
{
    ts_notused(signo);
    sysdb_setTaskStatus(SYS_TASK_TFE_FLUSH, SYS_TASK_STATUS_EXIT);
    bq_close();
    sysdb_close();
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
    if (sigaction(SIGINT, &sas, NULL) == -1)
    {
        log_error("sigaction() failed. Reason: %s", strerror(errno));
        return -1;
    }

    if (sigaction(SIGTERM, &sas, NULL) == -1)
    {
        log_error("sigaction() failed. Reason: %s", strerror(errno));
        return -1;
    }

    /*
    sas.sa_handler = signal_alarm;
    if (sigaction(SIGALRM, &sas, NULL) == -1) {
        log_error("sigaction() failed. Reason: %s", strerror(errno));
        return -1;
    }

    alarm(alarm_timer);
    */
    return 0;
}

int32 main(int argc, char **argv)
{
    ts_notused(argc);
    ts_notused(argv);

    int32 ret;

    logger_init(MY_TASK_NAME);

    ret = init_signal();
    if (0 != ret)
    {
        log_error("init_signal() failed.");
        return -1;
    }
    tfeFlushTimer = ts_timer_init(signal_alarm);
    if(tfeFlushTimer < 0)
    {
    	log_error("ts_timer_init < 0! \n");
    	return -1;
    }

    ts_timer_set( tfeFlushTimer, alarm_timer,0);

    log_info("%s start", MY_TASK_NAME);

    if (!sysdb_init())
    {
        log_error("sysdb_init failed");
        return -1;
    }

    if (!bq_init())
    {
        sysdb_close();
		log_error("bq_init() failed.");
        return -1;
    }



    //启动文件创建的线程
    pthread_t pth_t;
    ret = pthread_create(&pth_t, NULL, tfe_create_file, NULL);
    if (0 != ret)
    {
        log_error("pthread_create( tfe_create_file ) failed. Reason [%s].", strerror(errno));
        return -1;
    }

    char follow_str[128];
    sprintf(follow_str, "%d", TFE_TASK_REPLY);
	ret = tfe_t_init(TFE_TASK_FLUSH, TFE_TASK_ADDER, follow_str, false);
    if (0!=ret)
    {
        log_error("tfe_t_init failed.");
        return -1;
    }

    uint64 t_offset = tfe_get_offset(TFE_TASK_FLUSH);
    log_debug("------ FLUSH[ %lld ]---------", t_offset);

    fid_tfe_adder = getFidByName("tfe_adder");

    sysdb_setTaskStatus(SYS_TASK_TFE_FLUSH, SYS_TASK_STATUS_RUN);
    log_info("%s init success\n", MY_TASK_NAME);

    while (0 == exit_signal_fired)
    {
        ret = tfe_t_flush();
        if (0!=ret)
        {
            log_error("tfe_t_flush failed.");
            return -1;
        }
        ts_sleep(50*1000,0);
    }

    log_info("%s exit\n", MY_TASK_NAME);
    return 0;
}


