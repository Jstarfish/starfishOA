#include "global.h"
#include "sysdb_inf.h"

#include "ts_utils.h"
#include "gl_inf.h"
#include "otl_inf.h"


bool exit_flag_g = false;

static int32 cycle_interval = 500 * 1000;

static int times = 0;
static const int times_point = 7;

static int run_flag = 0;
static int check_session_flag = 0;

static void reap_child(void)
{
    int status;
    pid_t pid;
    int32 process_index = 0;

    for (;;)
    {
        pid = waitpid(-1, &status, WNOHANG);
        if (pid==0)
        {
            return;
        }

        if (pid==-1)
        {
            if (errno==EINTR)
            {
                continue;
            }
            if (errno==ECHILD)
            {
                log_warn("no more child to wait..., TaiShan system can exit now!");
                sysdb_setSysStatus(SYS_STATUS_END);
                return;
            }
            log_warn("waitpid() failed! errno[%d], strerror[%s]", errno, strerror(errno));
            return;
        }

        process_index = sysdb_getTaskIndexByPid(pid);
        if (process_index==-1)
        {
            log_warn("unknown child pid[%d]", pid);
            return;
        }

        SYS_TASK_RECORD *taskrecord = sysdb_getTask((SYS_TASK)process_index);
        if (WIFEXITED(status))
        {
            log_warn("pid [%d] [%s] exited, status=%d", pid, taskrecord->taskName, WEXITSTATUS(status));

            taskrecord->taskStatus = SYS_TASK_STATUS_EXIT;
            taskrecord->taskProcId = -1;
            taskrecord->process_exited = true;
        }
        else if (WIFSIGNALED(status))
        {
            log_warn("pid [%d] [%s] killed by signal %d", pid, taskrecord->taskName, WTERMSIG(status));

            taskrecord->taskStatus = SYS_TASK_STATUS_CRASH;
            taskrecord->taskProcId = -1;
            taskrecord->process_exited = true;
            taskrecord->taskStartTime = 0;
            taskrecord->taskEndTime = 0;
        }
        else if (WIFSTOPPED(status))
        {
            log_warn("pid [%d] [%s] stopped by signal %d", pid, taskrecord->taskName, WSTOPSIG(status));
        }
        else if (WIFCONTINUED(status))
        {
            log_notice("pid [%d] [%s] continued", pid, taskrecord->taskName);
        }
    }

    return;
}

typedef void Sigfunc(int);

static Sigfunc *signal_init(int signo, Sigfunc *func, int flags)
{
    struct sigaction act, oact;

    act.sa_handler = func;
    sigemptyset(&act.sa_mask);

    act.sa_flags = 0;
    if (signo == SIGALRM)
    {
#ifdef SA_INTERRUPT
        act.sa_flags |= SA_INTERRUPT;
#endif
    }
    else
    {
#ifdef SA_RESTART
        act.sa_flags |= SA_RESTART;
#endif
    }

    act.sa_flags |= flags;
    if (sigaction(signo, &act, &oact) < 0)
    {
        return SIG_ERR;
    }

    return oact.sa_handler;
}

static void handler_signal(int signo)
{
    switch (signo)
    {
        case SIGCHLD:
            reap_child();
            break;

        default:
            break;
    }

    return;
}

static bool daemonize(void)
{
    fflush(stdout);
    fflush(stderr);

    switch (fork())
    {
        case -1:
            return false;
        case 0:
            break;
        default:
            _exit(0);
    }

    if (setsid() == -1)
    {
        return false;
    }

    switch (fork())
    {
        case -1:
            return false;
        case 0:
            break;
        default:
            _exit(0);
    }

    umask(0);

    close(0);
    //    close(1);
    //    close(2);
    int fd = open("/dev/null", O_RDWR, 0);
    if (fd != -1)
    {
        dup2(fd, 0);
        //       dup2(fd, 1);
        //       dup2(fd, 2);
        if (fd > 2)
        {
            close(fd);
        }
    }

    return true;
}


static bool sys_state_machine()
{
    switch (sysdb_getSysStatus())
    {
        case SYS_STATUS_START:
        {
            sysdb_setStartTime(1, get_now());

            //系统初始化
            if (sys_init() == false)
            {
                log_error("ts_init() failed.");
                return false;
            }
            print_status("System init", STATUS_OK);

            //启动Notify 发送线程
            pthread_t pth;
            if ( pthread_create(&pth, NULL, sys_send_notify_thread, NULL) )
            {
                log_error("Start send_notify_thread failure.\n");
                return false;
            }
            print_status("Start send notify task", STATUS_OK);

            if (sys_game_init() == false)
            {
                log_error("ts_game_init() failed.\n");
                return false;
            }
            print_status("Game data init", STATUS_OK);

            //启动框架层任务
            if (sys_start_framework() == false)
            {
                log_error("start_framework() failed.\n");
                return false;
            }
            print_status("Start framework", STATUS_OK);

            sysdb_setSysStatus(SYS_STATUS_DATA_SYNC);
            break;
        }

        case SYS_STATUS_DATA_SYNC:
        {
            //启动TF的数据库相关任务
            if (sys_start_tfe_first() == false)
            {
                log_error("start_tf_first() failed.");
                return false;
            }
            print_status("Start tfe task for data sync", STATUS_OK);

            //等待TF的相关数据库任务完成TF与数据库的同步
            times = 0;
            while (true)
            {
                if (sys_wait_tfe_datbase_sync() == true)
                    break;

                ts_sleep(cycle_interval,0);
            }
            print_status("Tfe and Database sync", STATUS_OK);

            sysdb_setSysStatus(SYS_STATUS_DATA_LOAD);
            break;
        }

        case SYS_STATUS_DATA_LOAD:
        {
            int load_data_step = 0;

            //启动load data 线程
            pthread_t pth;
            if (pthread_create(&pth, NULL, sys_load_data_thread, &load_data_step)) {
                log_error("Start sys_load_data_thread failure.\n");
                return false;
            }
            //Game Issue Data
            times = 0;
            while (load_data_step == 0) {
                show_waiting_info("Loading game issue data", times++);
                if (times > times_point) {
                    times = 0;
                }
                ts_sleep(cycle_interval,0);
            }
            print_status("Load game issue data", STATUS_OK);

            sysdb_setSysStatus(SYS_STATUS_DATA_RESUME);
            break;
        }

        case SYS_STATUS_DATA_RESUME:
        {
            //从snapshot恢复数据
            if (sys_recover_snapshot_data() == false)
            {
                log_error("recover_snapshot_data() failed.\n");
                return false;
            }

            //启动数据恢复任务
            if (sys_start_data_resume_task() == false)
            {
                log_error("start_data_resume_task() failed.\n");
                return false;
            }

            //等待数据恢复完成
            while (sys_check_data_resume() == false)
            {
                show_waiting_info("waiting for data resume", times);
                if (times++>7)
                {
                    times = 0;
                }
                ts_sleep(cycle_interval,0);
            }
            print_status("Data resume", STATUS_OK);

            //设置系统会话检查标记
            check_session_flag = 1;

            //启动业务处理任务
            if (sys_start_operation_task() == false)
            {
                log_error("start operation task failed.");
                print_status("start operation task", STATUS_FAILED);
                return false;
            }
            print_status("start operation task", STATUS_OK);

            //send business TFE record
            if (sys_send_business_state() == false)
            {
                log_error("sys_send_business_state failed.");
                print_status("send system state to BUSINESS", STATUS_FAILED);
                return false;
            }
            while( SYS_STATUS_BUSINESS != sysdb_getSysStatus() )
            {
                ts_sleep(cycle_interval,0);
            }            
            break;
        }

        case SYS_STATUS_BUSINESS:
        {
            if (run_flag == 0)
            {   
                sysdb_setStartTime(2, get_now());

                print_status("TaiShan system start success.", STATUS_OK);
                print_status("GOOD WORK ... ...", STATUS_OK);

                run_flag = 1;
            }
            break;
        }

        case SYS_STATUS_END:
        {
            //安全关闭系统，用于系统升级及维护
            print_status("TaiShan System begin closing", STATUS_OK);

            //关闭任务(1)
            sys_stop_task_1();

            //等待所有任务到达TF尾部( 与 FLUSH 任务指针相同)
            while(sys_wait_close_sync() == false)
            {
            	show_waiting_info("waiting for task sync finish", times);
                if (times++>7)
                {
                    times = 0;
                }
                ts_sleep(1,1);
            }

            sysdb_setSafeClose(1);

            //tfe_flush任务将写入一条特殊的系统关闭的checkpoint记录，
            //tfe的相关任务在读到这条记录时，会安全退出

            //关闭任务(2) waiting adder exit
            sys_stop_task_2();

            //等待所有任务到达TF尾部( 与 FLUSH 任务指针相同)
            while(sys_wait_close_sync() == false)
            {
            	show_waiting_info("waiting for task sync finish", times);
                if (times++>7)
                {
                    times = 0;
                }
                ts_sleep(1,1);
            }

            //关闭任务(3)
            sys_stop_task_3();

            //系统资源销毁
            sys_close();

            print_status("TaiShan System closed", STATUS_OK);
            exit_flag_g = true;
            return true;
        }
        default:
        {
            log_error("****** ERROR TS State[%d] **********", sysdb_getSysStatus());
            break;
        }
    }
    return true;
}


int32 main(int argc, char *argv[])
{
    if (argc != 2 )
    {
        fprintf(stderr, "Input parameter error.\n");
        return 1;
    }

    if (( 0 != strcmp(argv[1], "start")) && ( 0 != strcmp(argv[1], "stop")))
    {
        fprintf(stderr, "Input parameter error.\n");
        return 1;
    }

    if (0 == strcmp(argv[1], "stop"))
    {
        //stop system ----------------------------------------------
        if (!sysdb_init())
        {
            fprintf(stderr, "system isn't start.\n");
            return 1;
        }
        sysdb_setSysStatus(SYS_STATUS_END);
        sysdb_close();
        printf("system is going to stop. please wait a moment.\n");
        return 1;
    }

    //start system ----------------------------------------------
    if (!daemonize())
    {
        fprintf(stderr, "daemonize tstop failed.");
        return 1;
    }

    system("clear");

    //启动时间
    char timestr[32]={0};
    struct timeval tv; 
    struct tm ptm;
    gettimeofday(&tv, NULL); 
    localtime_r(&tv.tv_sec, &ptm);
    sprintf(timestr, "%04d-%02d-%02d %02d:%02d:%02d", ptm.tm_year + 1900, ptm.tm_mon + 1, ptm.tm_mday, ptm.tm_hour, ptm.tm_min, ptm.tm_sec);
    printf("\n [ "COLOR_CYAN"%s"SETCOLOR_NORMAL" ]  --- Welcome to "LIGHT_GREEN"TaiShan System"SETCOLOR_NORMAL" ---\n\n", timestr);

    printf("TAISHAN_HOST_PATH                 [ %s ]\n", TAISHAN_HOST_PATH);
    printf("CONFIG_FILE_PATH                  [ %s ]\n", CONFIG_FILE_PATH);
    printf("LOG_ROOT_DIR                      [ %s ]\n", LOG_ROOT_DIR);
    printf("IPC_SEMPATH                       [ %s ]\n", IPC_SEMPATH);
    printf("IPC_SHMPATH                       [ %s ]\n", IPC_SHMPATH);
    printf("IPC_MSGPATH                       [ %s ]\n", IPC_MSGPATH);
    printf("DATA_ROOT_DIR                     [ %s ]\n", DATA_ROOT_DIR);
    printf("TASK_ROOT_DIR                     [ %s ]\n", TASK_ROOT_DIR);
    printf("\n");
    printf("TFE_DATA_SUBDIR                   [ %s ]\n", TFE_DATA_SUBDIR);
    printf("GAME_DATA_SUBDIR                  [ %s ]\n", GAME_DATA_SUBDIR);
    printf("UPLOAD_DATA_SUBDIR                [ %s ]\n", UPLOAD_DATA_SUBDIR);
    printf("PUB_DATA_SUBDIR                   [ %s ]\n", PUB_DATA_SUBDIR);
    printf("SNAPSHOT_DATA_SUBDIR              [ %s ]\n\n", SNAPSHOT_DATA_SUBDIR);

    signal_init(SIGCHLD, &handler_signal, SA_NODEFER);

    if (!ts_initLog())
    {
        log_error("ts_initLog() failed.");
        return 1;
    }

    log_info("TaiShan System Start --------------------------------------------------------------.");
    print_status("TaiShan System prepare start", STATUS_OK);

    if (!sysdb_create())
    {
        log_error("sysdb_create() failed.");
        return 1;
    }
    print_status("create sysdb share memory", STATUS_OK);

    if (!sysdb_init())
    {
        log_error("sysdb_init() failed.");
        return 1;
    }

    if (!sysdb_load_config())
    {
        log_error("sysdb_load_conf() failed.");
        return 1;
    }
    print_status("sysdb load configuration", STATUS_OK);

    sysdb_setTaskStatus(SYS_TASK_TSTOP, SYS_TASK_STATUS_RUN);

    SYS_DB_CONFIG *sysDBconfig = sysdb_getOmsDBCfg();
    char dbConnStr[128] = {0};
    sprintf(dbConnStr, "%s/%s@%s", sysDBconfig->username, sysDBconfig->password, sysDBconfig->url);

    times = 3;
    while (!exit_flag_g)
    {
        show_waiting_info("waiting for establishing connect to Database ", times++);
        //测试数据库
        if (sys_testOmsDB(sysDBconfig->username, sysDBconfig->password, sysDBconfig->url) == false)
        {
            if (times > times_point)
            {
                times = 0;
            }
            ts_sleep(1,1);
            continue;
        }
        //清除OMS通信日志标记
        if (otl_cleanOmsCommLog() == false)
        {
            log_error("otl_cleanOmsCommLog() failed.");
            print_status("otl_cleanOmsCommLog() found error. exit", STATUS_FAILED);
            return 1;
        }
        break;
    }
    clear_to_eol();
    print_status("Test Database Connect", STATUS_OK);

    sysdb_setSysStatus(SYS_STATUS_START);
    while (!exit_flag_g)
    {
        //检查会话switch
        if (1 == check_session_flag)
        {
            if(sysdb_verifySessionDate() < 0)
            {
            	log_error("sysdb_verifySessionDate error!. TaiShan System exit!");
            	break;
            }
        }

        if (sys_state_machine() == false)
        {
            log_error("System start / stop failure.");
            print_status("TaiShan System running found error. exit", STATUS_FAILED);

            //sysdb_setSysStatus(SYS_STATUS_END);
            break;
        }

        if (SYS_STATUS_BUSINESS == sysdb_getSysStatus())
        {
            sys_check_task();
        }

        fflush(stdout);
        fflush(stderr);
        ts_sleep(cycle_interval,0);
    }

    sysdb_setTaskStatus(SYS_TASK_TSTOP, SYS_TASK_STATUS_EXIT);

    sysdb_close();

    sysdb_destroy();

    log_info("TaiShan System exit.");





    // 在删除footmark文件后，让 刘孟飞 看看tfe_t_restore_footmark函数，好像文件打开了2遍
    //未完成工作，刘孟飞处理切换tfe文件
    //处理不存在footmark文件的情况
    //修改启动脚本  start |  stop ( CONFIRM  or  CONFIRM FORCE )
    //
    //还有什么没有想到?


    printf("\n\n----------------------------------------------------------------\n");
    printf("\n------------------ ATTENTION  (important) ----------------------\n\n");
    printf("If you want to upgrade the system ...\n");
    printf("and if you have modified the INM message structure. You must\n");
    printf("  I   ->   SAFELY CLOSE THE SYSTEM first;\n");
    printf("  II  ->   Switch the TF file using the following steps:\n");
    printf("        1. Delete the TFE checkpoint file. [ /ts_host/data/tfe_data/tfe.checkpoint ].\n");
    printf("        2. Delete the footmark file with TFE tasks. [ /ts_host/data/tfe_data/*taskname*.ft ].\n");
    printf("        3. Touch a new file, with name [ /ts_host/data/tfe_data/tfe.checkpoint.update ].\n");
    printf("        4. Modify the file [ /ts_host/data/tfe_data/tfe.checkpoint.update ], and write ' NEW TF FILE INDEX NUMBER ' into it.\n");
    printf("  III ->   Do system upgrade;\n");
    printf("  IV  ->   Start the newer-versioned system.\n");
    printf("  Finally ->   You must delete the file [ /ts_host/data/tfe_data/tfe.checkpoint.update ] after the system have started successfully.\n");
    printf("\n----------------------------------------------------------------\n");
    printf("\n----------------------------------------------------------------\n");





    fflush(stdout);
    fflush(stderr);

    ts_closeLog();

    return 0;
}


