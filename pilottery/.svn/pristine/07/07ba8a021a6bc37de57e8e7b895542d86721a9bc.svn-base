#include "global.h"
#include "bq_inf.h"
#include "bqueuesd.h"
#include "bqueuesnet.h"


#define MY_TASK_NAME "bqueuesd\0"

//Bqueuesd退出标志
bool bExit = false;

//从消息队列接收控制消息的buffer缓冲
#define CTRL_BUF_SIZE   512
int8 s_chCtrlBuf[CTRL_BUF_SIZE]={0};
FID fidCtrl = 0;

timer_t  bqTimer;

//处理退出任务信号
void signal_term(int32 signal)
{
    if(signal == SIGTERM)
    {
        printf("signal_term active_000.\n");

        bExit = true;
    }
}

//处理心跳定时器信号
void signal_heartbeat(int32 signal)
{
    ts_notused(signal);

    bq_net_verify_heartbeat();
    //alarm(BQ_HB_INTERVAL_SECONDS);

    ts_timer_set( bqTimer, BQ_HB_INTERVAL_SECONDS,0);
}

int32 main(int32 argc, char *argv[])
{
    //mian处理BQUEUES的控制类消息，包括心跳

    argc = argc;
    **argv = **argv;//avoid warning;

    int32 ret = 0;
    BQ_HEADER header;
    BQ_NET_ROUTE_TABLE *pNetRouteTable = null;
    BQ_NET_ROUTE_ENTRY *pNetRouteEntry = null;
 
    logger_init(MY_TASK_NAME);
    
    //处理程序退出信号
    signal(SIGTERM, signal_term);

    //忽略PIPE信号 处理socket异常
    signal(SIGPIPE, SIG_IGN);

	log_info("%s start\n", MY_TASK_NAME);

	if (!sysdb_init())
    {
        log_error("sysdb_init() failed.");
        return 1;
    }

	if ( !bq_init() )
    {
        log_error("bq_init return error!");
        return -1;
    }

    //BQUEUES网络通信初始化
    if ( !bq_net_init() )
    {
        log_error("bq_net_init return error!");
        return -1;
    }

    //得到任务的fid
    fidCtrl = getFidByName(BQ_CTRL_PROC);
    if (fidCtrl<0)
    {
        log_error("getFidByName return error!");
        return -1;
    }

    //注册从BQueues接收数据
    if ( !bq_register( fidCtrl, BQ_CTRL_PROC, getpid() ) )
    {
        log_error("bq_register return error! BQ_CTRL_PROC.");
        return -1;
    }

    //注册一个心跳超时检测的定时器
    //signal(SIGALRM, signal_heartbeat);
    //alarm(BQ_HB_INTERVAL_SECONDS);
    bqTimer = ts_timer_init(signal_heartbeat);
    if(bqTimer < 0)
    {
    	log_error("ts_timer_init < 0! \n");
    	return -1;
    }

    ts_timer_set( bqTimer, BQ_HB_INTERVAL_SECONDS,0);

    if ( !sysdb_init() )
    {
        log_error("sysdb_init return error!.");
        return -1;
    }

	sysdb_setTaskStatus(SYS_TASK_BQUEUESD, SYS_TASK_STATUS_RUN );

    log_info("%s init success\n", MY_TASK_NAME);

    //进入BQUEUES的控制消息处理流程
    while(!bExit)
    {
        memset(s_chCtrlBuf, 0, CTRL_BUF_SIZE);
        ret = bq_recvA(fidCtrl, &header, (char*)s_chCtrlBuf, CTRL_BUF_SIZE, 500);
        if ( ret < 0 )
        {
            log_error("bq_recvA return error!\n");
            break;
        }
        else if (ret==0)
        {
            //receive timeout
            continue;
        }

        switch(header.code)
        {
            case BQ_CTRL_CODE_HB:
            {
                //处理心跳
                BQ_MSG_HB *bq_msg_hb = (BQ_MSG_HB *)s_chCtrlBuf ;

                if (bq_msg_hb->code==BQ_CTRL_CODE_HB)
                {
                    pNetRouteTable = getNetRouteTable();
                    pNetRouteEntry = &pNetRouteTable->netRouteTable[bq_msg_hb->netId];
                    pNetRouteEntry->failureHB = 0;

                }
                break;
            }
            default:
            {
                break;
            }
        }
    }

	sysdb_setTaskStatus(SYS_TASK_BQUEUESD, SYS_TASK_STATUS_EXIT);

    //反注册
    if ( !bq_unregister( fidCtrl) )
    {
        log_error("bq_unregister return error!");
        return -1;
    }

    //关闭网络线程，等待网络线程退出
    if ( !bq_net_close() )
    {
        log_error("bq_net_close return error!");
        return -1;
    }

    if ( !bq_close() )
    {
        log_error("bq_close return error!");
        return -1;
    }

    log_info("%s exit\n", MY_TASK_NAME);

    return 0;
}





/*

使用BQueues的任务说明

以当前TMS的某个任务为例,这个任务在BQueues中注册，然后接收消息处理，然后发送到GL

main()
{
    //自身所在的MID
    FID self_fid;

    //下面是可选的消息发送目标的MID列表

    //下面是可选的某个MID的任务FID
    FID gl_1_fid;
    FID gl_2_fid;
    FID gl_3_fid;

    //步骤一
    bq_init();

    //步骤二 设置自身的MID
    self_mid = getMID_TMS;
    判断self_mid>=0
    setCurrentMID(self_mid);
    self_fid = getFidByName("自身任务注册名")
    判断self_fid>=0
    setCurrentFID(self_fid);

    //步骤三 得到目标的MID 和 FID
    gl_mid = getMID_GL;
    判断gl_mid>=0

    gl_1_fid = getFidByName("目标任务注册名")
    判断gl_1_fid>=0

    gl_2_fid = getFidByName("目标任务注册名")
    判断gl_2_fid>=0

    gl_3_fid = getFidByName("目标任务注册名")
    判断gl_3_fid>=0


    //步骤四
    bool bq_register(self_fid, "自身任务注册名", getpid())


    //步骤五  循环接收消息，强烈建议使用 ba_recvA()这个函数，而不是使用bq_recv函数
    while()
    {
        int len = bq_recvA()
        if (len==0)
        {
            ;
            //正常退出
            break;
        }
        if (len<0)
        {
            ;
            //接收数据错误
            break;
        }

        //处理接收的业务数据
        ...
        //发送数据到目标FID      强烈建议使用 ba_recvA()这个函数，而不是使用bq_recv函数
        bq_sendA(gl_1_fid, ...) 或
        bq_sendA(gl_2_fid, ...) 或
        bq_sendA(gl_3_fid, ...)
    }


    //步骤六
    bool bq_unregister(self_fid)


    //步骤七
    
}

*/
