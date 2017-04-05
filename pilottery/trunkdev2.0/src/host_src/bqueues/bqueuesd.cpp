#include "global.h"
#include "bq_inf.h"
#include "bqueuesd.h"
#include "bqueuesnet.h"


#define MY_TASK_NAME "bqueuesd\0"

//Bqueuesd�˳���־
bool bExit = false;

//����Ϣ���н��տ�����Ϣ��buffer����
#define CTRL_BUF_SIZE   512
int8 s_chCtrlBuf[CTRL_BUF_SIZE]={0};
FID fidCtrl = 0;

timer_t  bqTimer;

//�����˳������ź�
void signal_term(int32 signal)
{
    if(signal == SIGTERM)
    {
        printf("signal_term active_000.\n");

        bExit = true;
    }
}

//����������ʱ���ź�
void signal_heartbeat(int32 signal)
{
    ts_notused(signal);

    bq_net_verify_heartbeat();
    //alarm(BQ_HB_INTERVAL_SECONDS);

    ts_timer_set( bqTimer, BQ_HB_INTERVAL_SECONDS,0);
}

int32 main(int32 argc, char *argv[])
{
    //mian����BQUEUES�Ŀ�������Ϣ����������

    argc = argc;
    **argv = **argv;//avoid warning;

    int32 ret = 0;
    BQ_HEADER header;
    BQ_NET_ROUTE_TABLE *pNetRouteTable = null;
    BQ_NET_ROUTE_ENTRY *pNetRouteEntry = null;
 
    logger_init(MY_TASK_NAME);
    
    //��������˳��ź�
    signal(SIGTERM, signal_term);

    //����PIPE�ź� ����socket�쳣
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

    //BQUEUES����ͨ�ų�ʼ��
    if ( !bq_net_init() )
    {
        log_error("bq_net_init return error!");
        return -1;
    }

    //�õ������fid
    fidCtrl = getFidByName(BQ_CTRL_PROC);
    if (fidCtrl<0)
    {
        log_error("getFidByName return error!");
        return -1;
    }

    //ע���BQueues��������
    if ( !bq_register( fidCtrl, BQ_CTRL_PROC, getpid() ) )
    {
        log_error("bq_register return error! BQ_CTRL_PROC.");
        return -1;
    }

    //ע��һ��������ʱ���Ķ�ʱ��
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

    //����BQUEUES�Ŀ�����Ϣ��������
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
                //��������
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

    //��ע��
    if ( !bq_unregister( fidCtrl) )
    {
        log_error("bq_unregister return error!");
        return -1;
    }

    //�ر������̣߳��ȴ������߳��˳�
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

ʹ��BQueues������˵��

�Ե�ǰTMS��ĳ������Ϊ��,���������BQueues��ע�ᣬȻ�������Ϣ����Ȼ���͵�GL

main()
{
    //�������ڵ�MID
    FID self_fid;

    //�����ǿ�ѡ����Ϣ����Ŀ���MID�б�

    //�����ǿ�ѡ��ĳ��MID������FID
    FID gl_1_fid;
    FID gl_2_fid;
    FID gl_3_fid;

    //����һ
    bq_init();

    //����� ���������MID
    self_mid = getMID_TMS;
    �ж�self_mid>=0
    setCurrentMID(self_mid);
    self_fid = getFidByName("��������ע����")
    �ж�self_fid>=0
    setCurrentFID(self_fid);

    //������ �õ�Ŀ���MID �� FID
    gl_mid = getMID_GL;
    �ж�gl_mid>=0

    gl_1_fid = getFidByName("Ŀ������ע����")
    �ж�gl_1_fid>=0

    gl_2_fid = getFidByName("Ŀ������ע����")
    �ж�gl_2_fid>=0

    gl_3_fid = getFidByName("Ŀ������ע����")
    �ж�gl_3_fid>=0


    //������
    bool bq_register(self_fid, "��������ע����", getpid())


    //������  ѭ��������Ϣ��ǿ�ҽ���ʹ�� ba_recvA()���������������ʹ��bq_recv����
    while()
    {
        int len = bq_recvA()
        if (len==0)
        {
            ;
            //�����˳�
            break;
        }
        if (len<0)
        {
            ;
            //�������ݴ���
            break;
        }

        //������յ�ҵ������
        ...
        //�������ݵ�Ŀ��FID      ǿ�ҽ���ʹ�� ba_recvA()���������������ʹ��bq_recv����
        bq_sendA(gl_1_fid, ...) ��
        bq_sendA(gl_2_fid, ...) ��
        bq_sendA(gl_3_fid, ...)
    }


    //������
    bool bq_unregister(self_fid)


    //������
    
}

*/
