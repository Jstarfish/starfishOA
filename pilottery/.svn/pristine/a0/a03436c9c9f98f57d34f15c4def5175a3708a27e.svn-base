#ifndef BQUEUES_INF_H_INCLUDED
#define BQUEUES_INF_H_INCLUDED


/*==============================================================================
模块名：
    


模块功能:   

   

模块描述: 

 
    
类及功能: 



修改记录：
 
 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009.09.25                          Tommy, Forrest

==============================================================================*/

//==============================================================================
// 包含本地文件
// Include Files
//==============================================================================

/*==============================================================================
 * 常量定义，并对所定义的常量进行说明
 * Constant / Define Declarations
 =============================================================================*/

/*==============================================================================
 * 类型定义(struct、enum)等,如果是重要数据结构，要详细说明
 * Type Declarations(struct,enum etc.) and Brief Description
 * If it's Significant,Detailed Description Should Be Present
 =============================================================================*/

//Function索引编号
typedef int8    FID;

//进程编号PID
typedef pid_t   PID;



//心跳
#define BQ_MAX_HB_FAILURE_COUNT     3
#define BQ_HB_INTERVAL_SECONDS      5


//定义心跳任务名 和 网络通信任务名
#define BQ_CTRL_PROC            "bq_ctrl_proc\0"
#define BQ_NET_PROC             "bq_net_proc_\0"    //bq_net_proc_NETINDEX


//定义BQueues支持的最大分布式连接数目
#define BQ_MAX_NET_NUM     (12)

//BQueues网络通信任务最大数目 (当前为最大的模块个数再减1)
#define BQ_MAX_NET_TASK_NUM     (BQ_MAX_NET_NUM)

//BQueues支持的注册接收任务的最大数目
#define BQ_MAX_APP_TASK_NUM     32

//BQueues的任务数组总数
#define BQ_MAX_TASK_NUM         (BQ_MAX_NET_TASK_NUM + BQ_MAX_APP_TASK_NUM)



//定义消息队列的类型
typedef enum _BQ_TYPE
{
    BQ_SMALL_TYPE = 0,
    BQ_MEDIUM_TYPE,
    BQ_LARGE_TYPE,
    BQ_HUGE_TYPE_0,
    BQ_HUGE_TYPE
}BQ_TYPE;

//不同尺寸的队列的数量
#define BQ_TYPE_NUM (BQ_HUGE_TYPE + 1)

//定义bqueues支持的不同尺寸内存块类型的数目
#define BQ_TYPE_MAX_NAME_LENGTH 12


typedef enum _BQ_CTRL_CODE
{
    BQ_CTRL_CODE_HB = 0xF1,         //心跳的消息命令
}BQ_CTRL_CODE;

#pragma pack (1)

//BQueues心跳消息 / 控制消息
typedef struct _BQ_MSG_HB
{
    uint8   code;   //code = BQ_CTRL_CODE_HB
    int32   netId;
}BQ_MSG_HB;

#pragma pack ()


//bqueues头
typedef struct _BQ_HEADER
{
    FID     host;           // 宿主标识
    FID     sender;         // 发送者标识
    uint8   code;           // 标识为控制类消息(非0)  业务消息填0
}BQ_HEADER;


typedef enum _BQ_PROTOCOL_TYPE
{
    BQ_PROTOCOL_EMPTY = 0,
    BQ_PROTOCOL_TCP_SERVER,
    BQ_PROTOCOL_TCP_CLIENT
    /*,
    BQ_PROTOCOL_UDP_SERVER,
    BQ_PROTOCOL_UDP_CLIENT,
    BQ_PROTOCOL_RAW
    */
}BQ_PROTOCOL_TYPE;

typedef enum _BQ_NET_STATUS
{
    BQ_NET_STATUS_EMPTY = 0,
    BQ_NET_STATUS_CONNECTED,
    BQ_NET_STATUS_DISCONNECTED
}BQ_NET_STATUS;

typedef enum _BQ_DISCONN_REASON
{
    BQ_DISCONN_REASON_EMPTY = 0,
    BQ_DISCONN_REASON_CONN,
    BQ_DISCONN_REASON_RS,
    BQ_DISCONN_REASON_HB,
    BQ_DISCONN_REASON_MANUAL,
    BQ_DISCONN_REASON_UNKNOW
}BQ_DISCONN_REASON;


//网络通信路由表
typedef struct _BQ_NET_ROUTE_ENTRY
{
    bool                used;
    uint32              ipAddr;             //本地IP
    char                ipAddr_str[16];     //本地IP字符串
    int32               ipAddrSec;          //远端IP
    char                ipAddrSec_str[16];  //远端IP字符串
    int32               port;               //服务器端口
    BQ_PROTOCOL_TYPE    protocol;           //使用的协议类型
    FID                 netfid;             //通信模块fid
    BQ_NET_STATUS       netStatus;          //连接  断开
    TIME_TYPE           connectTime;        //最后一次连接成功的时间
    TIME_TYPE           disconnTime;        //最后一次断开的时间
    int32               disconnCount;       //断开次数
    BQ_DISCONN_REASON   disconnReason;      //断开原因  1 网络收发失败  2 心跳超时  3 人工断开  4 未知
    int32               failureHB;          //失败心跳次数　HB 成功清零
    int32               retryConnect;       //重连次数  重连成功清零
    int32               sndPkgNum;          //发送包数量
    int32               rcvPkgNum;          //接收包数量   
}BQ_NET_ROUTE_ENTRY;

typedef struct _BQ_NET_ROUTE_TABLE
{
    BQ_NET_ROUTE_ENTRY       netRouteTable[BQ_MAX_NET_NUM];
}BQ_NET_ROUTE_TABLE;


/*
typedef struct _BQ_FID_ROUTE_ENTRY
{
    bool                used;
    FID                 fid;
    char                name[32];
    bool                local;                 //模块在本机 true    不在本机  false 用来判定发送到本地还是网络
    uint8               netIndex;               //使用的BQ_NET_ROUTE_TABLE的记录索引
}BQ_FID_ROUTE_ENTRY;

typedef struct _BQ_FID_ROUTE_TABLE
{
    BQ_FID_ROUTE_ENTRY       fidRouteTable[BQ_MAX_NET_NUM];
}BQ_FID_ROUTE_TABLE;
*/


// define block index node-----------------------------------

//定义内存块类型
typedef struct _BQ_TYPE_DATA
{
    BQ_TYPE type;
    char    name[BQ_TYPE_MAX_NAME_LENGTH];
    uint32   size;
    uint32   count;
    uint32   warnning;
}BQ_TYPE_DATA;


//定义内存块索引块
typedef enum _BQ_NODE_STATUS
{
    BQ_IN_FREE = 0,     //这块内存在free链表中
    BQ_IN_TASK,         //这块内存在某个任务的链表中
    BQ_IN_PROCESS,      //这块内存正在被某个任务处理
    BQ_IN_ALLOCATE      //此状态表示，这块内存被申请走了，但目前还不在链表中
}BQ_NODE_STATUS;

typedef struct _BQ_NODE_DATA
{
    BQ_TYPE             type;
    uint32              offsetBuf;          //相对偏移  内存块  ( char *)
    uint32              offsetNext;         //相对偏移  (struct _BQ_NODE_DATA *)
    BQ_NODE_STATUS      status;
    PID                 pid;                //在free链表 nPID=0， 在任务链表 nPID=任务PID， 被申请但不再链表中 nPID=申请者的PID
    BQ_HEADER           header;
    uint32              len;                //内部消息的真实长度
}BQ_NODE_DATA;

// 定义bqueues task queue array -----------------------------------

//定义一个task queue 的结构
#define BQ_TASK_NAME_LENGTH 64

typedef struct _BQ_TASK_QUEUE
{
    bool                used;
    bool                registed;
    FID                 fid;                //function index
    PID                 pid;
    char                name[BQ_TASK_NAME_LENGTH];
    uint32              offsetHead;         //相对偏移  (BQ_NODE_DATA *)
    uint32              offsetTail;         //相对偏移  (BQ_NODE_DATA *)
    pthread_cond_t      cond_v;             //用于任务阻塞的信号量
    pthread_mutex_t     mutex;               //用于互斥对task queue的操作
    uint32              queueCount;         //当前队列中的消息个数  
    uint32              received;           //收到的总消息个数
    TIME_TYPE           lastRecvTime;       //向消息队列发送最后一条信息的时间
    uint32              processed;          //处理的总消息个数
    TIME_TYPE           lastProcessTime;    //处理消息队列最后一条信息的时间

    bool                local;              //任务在本机 true，不在本机  false 用来判定发送到本地还是网络
    uint8               netIndex;           //使用的BQ_NET_ROUTE_TABLE的记录索引
}BQ_TASK_QUEUE;

typedef struct _BQ_TASK_QUEUE_ARRAY
{
    BQ_TASK_QUEUE       taskQueueArray[BQ_MAX_TASK_NUM];
}BQ_TASK_QUEUE_ARRAY;


// 定义bqueues free queue array -----------------------------------

typedef struct _BQ_FREE_QUEUE
{
    bool                used;
    BQ_TYPE             type;
    int32               count;              //总数
    int32               offsetHead;         //相对偏移  (BQ_NODE_DATA *)
    int32               offsetTail;         //相对偏移  (BQ_NODE_DATA *)
    pthread_mutex_t     mutex;               //用于互斥对free queue的操作
    int32               queueCount;
    int32               warnLevel;          //定义一个告警线，当剩余的内存块小于这个数时，每次申请会有告警提示
    int32               getFailedCount;     //这种尺寸队列申请的失败次数
}BQ_FREE_QUEUE;

typedef struct _BQ_FREE_QUEUE_ARRAY
{
    BQ_FREE_QUEUE       freeQueueArray[BQ_TYPE_NUM];
}BQ_FREE_QUEUE_ARRAY;


bool bq_init();

bool bq_close();

int8 getFidByName(const char* name);

bool bq_register(FID fid, const char* name, PID pid);

bool bq_unregister(FID fid);

//一般不使用
int32 bq_sendA(const BQ_HEADER *header, const char *buf, uint32 len);
int32 bq_recvA(FID fid, BQ_HEADER *header, char *buf, uint32 len, int32 timeout_msec);

void bq_netConnect(uint8 netindex, TIME_TYPE conntime);
void bq_netDisConnect(uint8 netindex, TIME_TYPE disconntime, BQ_DISCONN_REASON reason);


//发送消息
int32 bq_send(FID hfid, const char *buf, int32 length);

//接收消息
int32 bq_recv(FID fid, char *buf, int32 len, int32 timeout_msec);

bool bqueue_create();
bool bqueue_destroy();

//for report
int32  bq_check_freeQueue();

void bq_refresh();

BQ_NET_ROUTE_TABLE *getNetRouteTable();
BQ_TASK_QUEUE_ARRAY *getTaskQueueArray();
BQ_FREE_QUEUE_ARRAY *getFreeQueueArray();



// for look-------------------------------------------
//look bqueues state
void bq_print_netRouteTable();

void bq_print_midRouteTable();

void bq_print_freeQueue();

void bq_print_taskQueue();







//-------------------------------------------------------------------------------------------------------
//
//message queue 内部使用的队列
//
//-------------------------------------------------------------------------------------------------------
typedef struct _mque_item {
    struct _mque_item *next;
    void *ptr;
    int param1;
    int64 param2;
}mque_item;
typedef struct _MQUE MQUE;
struct _MQUE {
    int (*init)(MQUE *q);
    void (*enqueue)(MQUE *q, mque_item* ism);
    mque_item *(*dequeue)(MQUE *q, int timeout_msec);
    int (*get_size)(MQUE *q);
    mque_item *head;
    mque_item *tail;
    int size;
    pthread_mutex_t mutex;
    pthread_cond_t cond;
};
MQUE *mque_create();


#endif


