#ifndef BQUEUES_NET_H_INCLUDED
#define BQUEUES_NET_H_INCLUDED

//#define BQD_LOG "#bqueuesd"
#define BQD_LOG null
//Socket��¼����
typedef struct _BQ_NET_SOCKET_RECORD
{
    bool        used;
    SOCKET      socket;
    SOCKET      socketSrv;  //server socket  �����Ϊserver����
    bool        netstatus;  //��·���ӻ�Ͽ�״̬
    uint8       netId;
    FID         netfid;
    pthread_t   sendThread;
    pthread_t   recvThread;
}BQ_NET_SOCKET_RECORD;



bool bq_net_init();

bool bq_net_close();

void bq_net_connect(int32 netindex, SOCKET socket);

void bq_net_disconnect(int32 netindex, BQ_DISCONN_REASON reason);

void bq_net_verify_heartbeat();

bool recvData(int32 netIndex, char *buf, int32 *offset);
void *bq_net_recv_thread(void *arg);

void *bq_net_send_thread(void *arg);

#endif

