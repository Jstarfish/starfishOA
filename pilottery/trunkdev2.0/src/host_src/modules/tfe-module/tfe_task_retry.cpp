#include "global.h"
#include "tfe_inf.h"


#define MY_TASK_NAME "tfe_retry\0"

static volatile int exit_signal_fired = 0;

static FID tfe_retry_fid;
static FID ncpc_send_fid;


static void signal_handler(int sig)
{
    ts_notused(sig);
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
    return 0;
}

int main(int argc, char *argv[])
{
    ts_notused(argc);
    ts_notused(argv);

    int ret = 0;
    int pid = -1;

    logger_init(MY_TASK_NAME);

    ret = init_signal();
    if (0 != ret)
    {
        log_error("init_signal() failed.");
        return -1;
    }

    pid = getpid();

    log_info("%s start\n", MY_TASK_NAME);

    if (!sysdb_init())
    {
        log_error("sysdb_init() failed.");
        return -1;
    }

    if (!bq_init())
    {
        sysdb_close();
		log_error("bq_init() failed.");
        return -1;
    }

    ncpc_send_fid = getFidByName("ncpsend_queue");
	tfe_retry_fid = getFidByName(MY_TASK_NAME);
    if (!bq_register(tfe_retry_fid, MY_TASK_NAME, pid))
    {
        sysdb_close();
		bq_close();
		log_error("bq_register() failed.");
        return -1;
    }

    sysdb_setTaskStatus(SYS_TASK_TFE_RETRY, SYS_TASK_STATUS_RUN);

    log_info("%s init success\n", MY_TASK_NAME);

    static char inm_buf[INM_MSG_BUFFER_LENGTH] = {0};
    static char inm_buf_t[INM_MSG_BUFFER_LENGTH] = {0};
    while (0 == exit_signal_fired)
    {
        int len = bq_recv(tfe_retry_fid, inm_buf, INM_MSG_BUFFER_LENGTH, 500);
        if (len < 0)
        {
            log_error("bq_recv() len < 0.");
            break;
        }
        else if (len == 0)
        {
            //receive timeout
            continue;
        }

        INM_MSG_HEADER *inm_header = (INM_MSG_HEADER *)inm_buf;
        if (inm_header->type != INM_TYPE_SYS_RETRY)
        {
            log_warn("Who send?. type[%d]", inm_header->type);
            continue;
        }

        INM_MSG_SYS_RETRY *retry_msg = (INM_MSG_SYS_RETRY *)inm_buf;
        uint64 offset = retry_msg->tfe_file_idx*TFE_FILE_SIZE + retry_msg->tfe_file_offset;
		ret = tfe_find((unsigned char *)inm_buf_t, INM_MSG_BUFFER_LENGTH, offset);
		if (ret!=0)
        {
		    log_error("tfe_find() error. return[ %d ]  tfe offset[ %lld ]", ret, offset);
            continue;
		}
        INM_MSG_HEADER *inm_header_t = (INM_MSG_HEADER *)(inm_buf_t+TFE_HEADER_LENGTH);
        inm_header_t->socket_idx = inm_header->socket_idx;

        len = bq_send(ncpc_send_fid, inm_buf_t+TFE_HEADER_LENGTH, *(uint16 *)(inm_buf_t+TFE_HEADER_LENGTH));
	    if (len <= 0)
	    {
	        log_error("send data to bqueues failure!");
	    }
    }

    sysdb_setTaskStatus(SYS_TASK_TFE_RETRY, SYS_TASK_STATUS_EXIT);

    bq_unregister(tfe_retry_fid);

    bq_close();

    sysdb_close();

    log_info("%s exit\n", MY_TASK_NAME);
    return 0;
}


