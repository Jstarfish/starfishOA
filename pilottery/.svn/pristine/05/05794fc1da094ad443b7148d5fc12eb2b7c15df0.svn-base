#include "global.h"
#include "tfe_inf.h"
#include "gl_inf.h"
#include "tms_inf.h"
#include "ncpc_inf.h"

#include "tfe_reply_function.h"


#define MY_TASK_NAME "tfe_reply\0"

static volatile int exit_signal_fired = 0;

GAME_PLUGIN_INTERFACE *game_plugins_handle = NULL;

FID ncpc_fid;
FID ncpc_http_fid;

static MSG_DISPATCH_CELL msg_dispatch_cells[256] = {
    //TFE测试消息
    { INM_TYPE_N_ECHO,                      rproc_N_echo },

    //check_point
    { INM_TYPE_TFE_CHECK_POINT,             rproc_TFE_checkpoint },

    //系统状态切换至business
    { INM_TYPE_SYS_BUSINESS_STATE,          rproc_SYS_business_state },

    //日结的切换记录
    { INM_TYPE_SYS_SWITCH_SESSION,          rproc_SYS_switch_session },

    //terminal
    { INM_TYPE_T_ECHO,                      rproc_T_echo },
    { INM_TYPE_T_SELL_TICKET,               rproc_T_sell_ticket },
    { INM_TYPE_T_PAY_TICKET,                rproc_T_pay_ticket },
    { INM_TYPE_T_CANCEL_TICKET,             rproc_T_cancel_ticket },

    { INM_TYPE_ISSUE_STATE_PRESALE,         NULL },
    { INM_TYPE_ISSUE_STATE_OPEN,            NULL },
    { INM_TYPE_ISSUE_STATE_CLOSING,         NULL },
    { INM_TYPE_ISSUE_STATE_CLOSED,          NULL },

    { INM_TYPE_O_PAY_TICKET,                rproc_O_pay_ticket },
    { INM_TYPE_O_CANCEL_TICKET,             rproc_O_cancel_ticket },

    { INM_TYPE_O_FBS_PAY_TICKET,            rproc_O_fbs_pay_ticket },
    { INM_TYPE_O_FBS_CANCEL_TICKET,         rproc_O_fbs_cancel_ticket },

    { INM_TYPE_FBS_SELL_TICKET,             rproc_FBS_sell_ticket },
    { INM_TYPE_FBS_PAY_TICKET,              rproc_FBS_pay_ticket },
    { INM_TYPE_FBS_CANCEL_TICKET,           rproc_FBS_cancel_ticket },

};
static MSG_DISPATCH_CELL *msg_dispatch_sorted_cells[256];

static void tfe_reply_dispatcher(char *inm_buf)
{
    int ret = 0;

    INM_MSG_HEADER *pInm = (INM_MSG_HEADER *)inm_buf;
    MSG_DISPATCH_CELL *cell = msg_dispatch_sorted_cells[pInm->type];
    if (NULL == cell)
    {
        log_notice("inm type [%hhu] no deal fun", pInm->type);
        return;
    }
    if (NULL != cell->msg_process_fun)
    {
        ret = cell->msg_process_fun(inm_buf);
        if (ret == EXIT_ERR)
        {
            log_error("tfe_reply process message failure! tfe_file[%d] tfe_offset[%d]", pInm->tfe_file_idx, pInm->tfe_offset);
        }
        else if (ret == EXIT_SAFE_CLOSE)
        {
            //系统安全关闭
            exit_signal_fired = 1;
        }
        else if (ret == EXIT_ONLY)
        {
            //do nothing and return
        }
        else if (ret == EXIT_NCPC && sysdb_getSysStatus() == SYS_STATUS_BUSINESS)
        {
            if ( (pInm->gltp_from == TICKET_FROM_AP) || (pInm->gltp_from == TICKET_FROM_OMS) ) {
                ret = bq_send(ncpc_http_fid, inm_buf, *(uint16*)inm_buf);;
            } else {
                ret = bq_send(ncpc_fid, inm_buf, *(uint16*)inm_buf);
            }
            if (ret <= 0) {
                log_error("tfe_reply send data to bqueues failure!");
            }
        }
        else
        {
            log_error("invalid return value [%d] at system state [%d]", ret, sysdb_getSysStatus());
        }
    }
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
        log_error("sysdb_init() failed.");
        return  -1;
    }

    if (!bq_init())
    {
        sysdb_close();
        log_error("bq_init() failed.");
        return -1;
    }

    if (!ncpc_init())
    {
        sysdb_close();
        bq_close();
        log_error("ncpc_init() failed.");
        return -1;
    }

    if (!tms_mgr()->TMSInit())
    {
        sysdb_close();
        bq_close();
        ncpc_close();
        log_error("tms_mgr()->TMSInit() failed.");
        return -1;
    }

    if (!gl_init())
    {
        sysdb_close();
        bq_close();
        ncpc_close();
        log_error("gl_init() failed.");
        return -1;
    }

    if (gl_game_plugins_init()!=0)
    {
        sysdb_close();
        bq_close();
        ncpc_close();
        log_error("gl_game_plugins_init() failed.");
        return -1;
    }
    game_plugins_handle = gl_plugins_handle();

    char follow_str[128];
    sprintf(follow_str, "%d", TFE_TASK_SCAN);
    ret = tfe_t_init(TFE_TASK_REPLY, TFE_TASK_FLUSH, follow_str, true);
    if (0 != ret)
    {
        sysdb_close();
        bq_close();
        ncpc_close();
        gl_close();
        log_error("tfe_t_init() failed.");
        return -1;
    }

    //checkpoint init
    tfe_check_point_init();

    uint64 t_offset = tfe_get_offset(TFE_TASK_REPLY);
    log_debug("------ REPLY[ %lld ]---------", t_offset);

    ncpc_fid = getFidByName("ncpsend_queue");
    ncpc_http_fid = getFidByName("ncpsend_http_queue");

    //初始化处理分发器
    memset(msg_dispatch_sorted_cells, 0, sizeof(msg_dispatch_sorted_cells));
    for (uint32 i = 0; i < sizeof(msg_dispatch_cells)/sizeof(MSG_DISPATCH_CELL); i++) {
        msg_dispatch_sorted_cells[msg_dispatch_cells[i].inm_type] = &(msg_dispatch_cells[i]);
    }

    sysdb_setTaskStatus(SYS_TASK_TFE_REPLY, SYS_TASK_STATUS_RUN );

    log_info("%s init success\n", MY_TASK_NAME);

    static char inm_buf[INM_MSG_BUFFER_LENGTH];
    while (0 == exit_signal_fired)
    {
        ret = tfe_t_read((unsigned char *)inm_buf, INM_MSG_BUFFER_LENGTH, 200);
        if ((ret != 0) && (ret!=TFE_TIMEOUT))
        {
            log_error("tfe_t_read() failed. ret[%d].", ret);
            break; //usleep(1000);
        }
        if (ret==TFE_TIMEOUT)
            continue;

        tfe_reply_dispatcher(inm_buf+TFE_HEADER_LENGTH);

        tfe_t_commit();
    }

    sysdb_setTaskStatus(SYS_TASK_TFE_REPLY, SYS_TASK_STATUS_EXIT);

    gl_game_plugins_close();
    game_plugins_handle = NULL;

    gl_close();

    tms_mgr()->TMSClose();

    ncpc_close();

    bq_close();

    sysdb_close();

    log_info("%s exit\n", MY_TASK_NAME);
    return 0;
}



