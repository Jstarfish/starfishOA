#include "global.h"
#include "ncpc_inf.h"
#include "tms_inf.h"
#include "gl_inf.h"
#include "otl_inf.h"
#include "ncpc_http_parse.h"
#include "ncpc_http_kvdb.h"
#include "ncpc_net.h"
#include "ncpc_message.h"


#define MY_TASK_NAME "ncpc_task\0"

NCPC_SERVER *ns = NULL;
GAME_PLUGIN_INTERFACE *game_plugins_handle = NULL;


static void signal_handler(int signo)
{
    ts_notused(signo);
    ns->m_exit = true;
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
    signal(SIGPIPE, SIG_IGN);
    return 0;
}

int32 main(int argc, char *argv[])
{
    ts_notused(argc); ts_notused(argv);

    logger_init(MY_TASK_NAME);

    log_info("%s start\n", MY_TASK_NAME);

    if (0 != init_signal()) { log_error("init_signal() failed."); return -1; }
    if (!sysdb_init()) { log_error("sysdb_init return error!"); return -1; }
	SYS_DB_CONFIG *sysDBconfig = sysdb_getOmsDBCfg();
    if (!otl_connectDB(sysDBconfig->username, sysDBconfig->password, sysDBconfig->url, NCPC_WORKER_COUNT)) {
        log_error("otl_connectDB failed."); return -1;
    }
    if (!bq_init()) { log_error("bq_init return error!"); return -1; }
    if (!ncpc_init()) { log_error("ncpc_init return error!\n"); return -1; }
    ncp_connect_set_false();
    if (!tms_mgr()->TMSInit()) { log_error("tms init() return error!"); return -1; }
    tms_mgr()->setAllTermNoBusy();
    if (!gl_init()) { log_error("gl_init return error!"); return -1; }
    if (gl_game_plugins_init()!=0) { log_error("gl_game_plugins_init() failed."); return -1; }
    game_plugins_handle = gl_plugins_handle();
    ts_regex_init();
    sysdb_setTaskStatus(SYS_TASK_NCPC_TASK, SYS_TASK_STATUS_RUN);
    log_info("%s init success\n", MY_TASK_NAME);

    ns = new NCPC_SERVER();
    ncpc_service_start(ns);

    sysdb_setTaskStatus(SYS_TASK_NCPC_TASK, SYS_TASK_STATUS_EXIT);
    ts_regex_release();
    gidb_tidx_close_handle();
    gl_close();
    tms_mgr()->TMSClose();
    ncpc_close();
    bq_close();
    sysdb_close();
	otl_disConnectDB();

    log_info("%s exit\n", MY_TASK_NAME);
    return 0;
}



