/*==============================================================================
模块名：BQueues


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009.09.25                        Forrest

==============================================================================*/

/*==============================================================================
 * 包含系统文件
 * Includes System Files
 =============================================================================*/


/*==============================================================================
 * 包含本地文件
 * Include Files
 =============================================================================*/
#include "global.h"
#include "bq_inf.h"

#include "bqueues.h"
              


/*==============================================================================
 * 常量定义，并对所定义的常量进行说明
 * Constant / Define Declarations
 =============================================================================*/


/*==============================================================================
 * 类型定义(struct、enum)等,如果是重要数据结构，要详细说明
 * Type Declarations(struct,enum etc.) and Brief Description
 * If it's Significant,Detailed Description Should Be Present
 =============================================================================*/


/*==============================================================================
 * 全局常量定义，并对其进行简要说明
 * Global Constant Declarations and Brief Description
 =============================================================================*/

#define BQ_TASK_QUEUE_PROTECT  (50000)
 
//bqueues内存块类型定义

const static BQ_TYPE_DATA bq_type_define[BQ_TYPE_NUM] =
{
    { BQ_SMALL_TYPE,  "bq_small\0",  64,   5000, 100 },
    { BQ_MEDIUM_TYPE, "bq_medium\0", 128,  5000, 100 },
    { BQ_LARGE_TYPE,  "bq_large\0",  512,  5000, 100 },
    { BQ_HUGE_TYPE_0, "bq_huge_0\0", 4096, 50000, 100 },
    { BQ_HUGE_TYPE,   "bq_huge\0",   (1024*16-256), 10000, 20  }
};

/*
const static BQ_TYPE_DATA bq_type_define[BQ_TYPE_NUM] =
{
    { BQ_SMALL_TYPE,  "bq_small\0",  64,   500, 100 },
    { BQ_MEDIUM_TYPE, "bq_medium\0", 128,  500, 100 },
    { BQ_LARGE_TYPE,  "bq_large\0",  512,  500, 100 },
    { BQ_HUGE_TYPE_0, "bq_huge_0\0", 1488, 50, 10 },
    { BQ_HUGE_TYPE,   "bq_huge\0",   4096, 20, 5  }
};
*/

#define BQ_TASKQUEUE_WARN_NUM  10000

//共享内存变量
static int32    nGlobalMem = 0;
static char *   pGlobalMem = null;
static int32    nGlobalLen = 0;

/*==============================================================================
 * 宏定义，并对其进行简要说明
 * Macro Definitions and Brief Description
 =============================================================================*/

bool bq_init_pthread_mutex(pthread_mutex_t *mutex)
{
    int ret = 0;
    pthread_mutexattr_t mattr;

    ret = pthread_mutexattr_init(&mattr);
    if (0 != ret)
    {
        log_fatal("bq_init_pthread_lock::pthread_mutexattr_init failed. reason:[%s]", strerror(errno));
        return false;
    }
    ret = pthread_mutexattr_setpshared(&mattr, PTHREAD_PROCESS_SHARED);
    if (0 != ret)
    {
        log_fatal("bq_init_pthread_lock::pthread_mutexattr_setpshared failed. reason:[%s]", strerror(errno));
        return false;
    }
    ret = pthread_mutex_init(mutex, &mattr);
    if (0 != ret)
    {
        log_fatal("bq_init_pthread_lock::pthread_mutex_init failed. reason:[%s]", strerror(errno));
        return false;
    }
    return true;
}

bool bq_init_pthread_cond(pthread_cond_t *cond)
{
    int ret = 0;
    pthread_condattr_t cattr;

    ret = pthread_condattr_init(&cattr);
    if (0 != ret)
    {
        log_fatal("bq_init_pthread_cond::pthread_condattr_init failed. reason:[%s]", strerror(errno));
        return false;
    }
    ret = pthread_condattr_setpshared(&cattr, PTHREAD_PROCESS_SHARED);
    if (0 != ret)
    {
        log_fatal("bq_init_pthread_cond::pthread_condattr_setpshared failed. reason:[%s]", strerror(errno));
        return false;
    }
    ret = pthread_cond_init(cond, &cattr);
    if (0 != ret)
    {
        log_fatal("bq_init_pthread_cond::pthread_cond_init failed. reason:[%s]", strerror(errno));
        return false;
    }
    return true;
}

int8 getTaskNameByFid( FID fid, char* name)
{
    int32 i = 0;
    BQ_TASK_QUEUE *pTaskQueue = null;
    BQ_TASK_QUEUE_ARRAY *pTaskQueueArray = null;

    if ( pGlobalMem==null )
    {
        return -1;
    }
    pTaskQueueArray = (BQ_TASK_QUEUE_ARRAY *)(pGlobalMem + OFFSET_TASK_QUEUE_ARRAY);
    for (i=0;i<BQ_MAX_TASK_NUM;i++)
    {
        pTaskQueue  = &pTaskQueueArray->taskQueueArray[i];
        if ( !pTaskQueue->used )
            continue;
        if ((pTaskQueue->fid == fid) )
        {
            strcpy( name , pTaskQueue->name);
            return i;
        }
    }
    log_error("getTaskNameByFid::Don't find any FID match with fid[%d] ", fid);
    return -1;
}

bool bq_sendWriteHexLog(FID hfid, FID sfid,char *str , int32 lenth)
{
    return true;
    char buff[1024*32]= {0};
    uint32 buff_len = 0;
    char *ptr = str;
    int strlength = lenth ;
    int len = 1;  //当前要打印的长度

    char hTaskName[128]= {0};
    char sTaskName[128]= {0};
    getTaskNameByFid( hfid , hTaskName );
    getTaskNameByFid( sfid , sTaskName );

    buff_len += snprintf(buff + buff_len, sizeof(buff) - buff_len,
            "\nbq_send hfid[%d],sfid[%d] len[%d]->>\n", hfid, sfid, lenth);

    buff_len += snprintf(buff + buff_len, sizeof(buff) - buff_len,
            "bq_send hTaskName[%s],sTaskName[%s] ->>", hTaskName, sTaskName);

    while(true)
    {
        if(len>strlength)
        {
            break;
        }
        if( !( (len-1)%16) )
        {
            buff_len += snprintf(buff + buff_len, sizeof(buff) - buff_len, "\n");

        }
        buff_len += snprintf(buff + buff_len, sizeof(buff) - buff_len,  "%02x ", (uint8)*(ptr+len-1));
        len++;
    }
    log_info("%s", buff);
    return true;
}

bool bq_recvWriteHexLog( FID hfid, char *str , int32 lenth)
{
    return true;
    char buff[1024*32]= {0};
    uint32 buff_len = 0;
    char *ptr = str;
    int strlength = lenth ; 
    int len = 1;  //当前要打印的长度

    char hTaskName[128]= {0};

    getTaskNameByFid( hfid , hTaskName );
    buff_len += snprintf(buff + buff_len, sizeof(buff) - buff_len, "\nbq_recv hfid[%d] name[%s]->>" ,hfid ,hTaskName);
   
    while(true)
    {
        if(len>strlength)
        {
            break;
        }
        if( !( (len-1)%16) )
        {
            buff_len += snprintf(buff + buff_len, sizeof(buff) - buff_len, "\n");

        }
        buff_len += snprintf(buff + buff_len, sizeof(buff) - buff_len,  "%02x ", (uint8)*(ptr+len-1));
        len++;
    }
    log_info("%s", buff);
    return true;
}


/*==============================================================================
函数功能：根据free queue类型，从free的头部取出一个node


参数列表：
    BQ_FREE_QUEUE *pFreeQueue   free链表指针
    
函数返回：成功返回 数据节点BQ_NODE_DATA 指针 否则返回null


函数说明：


调用范围：内部程序调用



修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
static BQ_NODE_DATA* getFreeNode(BQ_FREE_QUEUE *pFreeQueue)
{
    BQ_NODE_DATA    *pNode = null;
    bool            warnningFlag = false;

    if ( pFreeQueue->queueCount > 0 )
    {
        pNode = (BQ_NODE_DATA *)(pGlobalMem+pFreeQueue->offsetHead);
        if (pFreeQueue->offsetHead == pFreeQueue->offsetTail)
        {
            pFreeQueue->offsetHead = 0;
            pFreeQueue->offsetTail = 0;
        }
        else
        {
            pFreeQueue->offsetHead = pNode->offsetNext;
        }
        pFreeQueue->queueCount--;
        pNode->offsetNext = 0;
        pNode->status = BQ_IN_ALLOCATE;

        if (pFreeQueue->queueCount < pFreeQueue->warnLevel)
        {
            warnningFlag = true;
        }
    }
    else
    {
        pFreeQueue->getFailedCount++;
    }

    /*
    if (warnningFlag)
    {
        //发送一条告警信息
        //bq_notify_buf_less(pFreeQueue->type, pFreeQueue->queueCount);
        // log_warn("getFreeNode::buffer does not enough pFreeQueue->queueCount[%d]." , pFreeQueue->queueCount);
    }
    */
    return pNode;
}

/*==============================================================================
函数功能：追加到一个node到free链表尾部


参数列表：
    参数：
    BQ_FREE_QUEUE *pFreeQueue   free链表指针
    BQ_NODE_DATA *pNode    数据节点

函数返回：


函数说明：


调用范围：内部程序调用


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
static void putFreeNode(BQ_FREE_QUEUE *pFreeQueue, BQ_NODE_DATA *pNode)
{
    BQ_NODE_DATA *pNode_t = null;
    if ( pFreeQueue->queueCount != 0 )
    {
        pNode_t = (BQ_NODE_DATA *)(pGlobalMem+pFreeQueue->offsetTail);
        pNode_t->offsetNext = (char *)pNode - pGlobalMem;
        pFreeQueue->offsetTail = (char *)pNode - pGlobalMem;
    }
    else
    {
        pFreeQueue->offsetHead = (char *)pNode - pGlobalMem;
        pFreeQueue->offsetTail = (char *)pNode - pGlobalMem;
    }
    pFreeQueue->queueCount++;
    pNode->offsetNext = 0;
    pNode->status = BQ_IN_FREE;
    pNode->pid = 0;
    pNode->len = 0;
    return;
}

/*==============================================================================
函数功能：从任务链表头上摘掉一个node


参数列表：
    参数：
    BQ_TASK_QUEUE *pTaskQueue   任务任务链表指针

函数返回：


函数说明：


调用范围：内部程序调用


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
static BQ_NODE_DATA* getTaskNode(BQ_TASK_QUEUE *pTaskQueue)
{
    BQ_NODE_DATA *pNode = null;

    if ( pTaskQueue->queueCount > 0 )
    {
        pNode = (BQ_NODE_DATA *)(pGlobalMem+pTaskQueue->offsetHead);
        if (pTaskQueue->offsetHead == pTaskQueue->offsetTail)
        {
            pTaskQueue->offsetHead = 0;
            pTaskQueue->offsetTail = 0;
        }
        else
        {
            pTaskQueue->offsetHead = pNode->offsetNext;
        }
        pTaskQueue->queueCount--;
        pTaskQueue->processed++;
        get_when_ex(&pTaskQueue->lastProcessTime);
        pNode->offsetNext = 0;
        pNode->status = BQ_IN_PROCESS;
    }
    return pNode;
}

/*==============================================================================
函数功能：追加一个node到任务链表尾部


参数列表：
    参数：
    BQ_TASK_QUEUE *pTaskQueue   任务任务链表指针
    BQ_NODE_DATA *pNode 数据节点

函数返回：


函数说明：


调用范围：内部程序调用


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
static void putTaskNode(BQ_TASK_QUEUE *pTaskQueue, BQ_NODE_DATA *pNode)
{
    BQ_NODE_DATA *pNode_t = null;
    if ( pTaskQueue->queueCount != 0 )
    {
        pNode_t = (BQ_NODE_DATA *)(pGlobalMem+pTaskQueue->offsetTail);
        pNode_t->offsetNext = (char *)pNode - pGlobalMem;
        pTaskQueue->offsetTail = (char *)pNode - pGlobalMem;
    }
    else
    {
        pTaskQueue->offsetHead = (char *)pNode - pGlobalMem;
        pTaskQueue->offsetTail = (char *)pNode - pGlobalMem;
    }
    pTaskQueue->queueCount++;
    pTaskQueue->received++;
    get_when_ex(&pTaskQueue->lastRecvTime);
    pNode->offsetNext = 0;
    pNode->status = BQ_IN_TASK;
    pNode->pid = pTaskQueue->pid;
    return;
}

/*==============================================================================
函数功能：创建共享内存，并组织链表


参数列表：
    参数：

函数返回：成功返回true 失败 false


函数说明：


调用范围：外部程序用于创建共享内存调用


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
bool bqueue_create()
{
    int32 nLength = 0;
    uint32 i, j;
    int32 buflen = 0;
    IPCKEY keyid;

    BQ_TYPE_DATA            *pTypeData = null;
    BQ_NET_ROUTE_ENTRY      *pNetRouteEntry = null;
    BQ_NET_ROUTE_TABLE      *pNetRouteTable = null;
    BQ_TASK_QUEUE           *pTaskQueue = null;
    BQ_TASK_QUEUE_ARRAY     *pTaskQueueArray = null;
    BQ_FREE_QUEUE           *pFreeQueue = null;
    BQ_FREE_QUEUE_ARRAY     *pFreeQueueArray = null;
    BQ_NODE_DATA            *pNode = null;   //某个索引节点的指针
    char                    *pBlock = null;          //某块内存的指针
    char                    *pOffsetNodeArea = null;    //内存块链表基地址
    char                    *pOffsetblockArea = null;   //内存块基地址
    char                    *pOffsetNodeArea_type = null;   //某种类型链表的基地址
    char                    *pOffsetblockArea_type = null;  //某种类型内存区的基地址

    //计算所需的共享内存尺寸
    nLength += sizeof(BQ_NET_ROUTE_TABLE);
    nLength += sizeof(BQ_TASK_QUEUE_ARRAY);
    nLength += sizeof(BQ_FREE_QUEUE_ARRAY);
    for (i=0;i<BQ_TYPE_NUM;i++)
    {
        pTypeData = (BQ_TYPE_DATA *)&bq_type_define[i];
        nLength += pTypeData->count * sizeof(BQ_NODE_DATA);
        buflen += pTypeData->count * pTypeData->size;
    }
    nLength += buflen;
    nGlobalLen = nLength;

    //创建共享内存
    keyid = ipcs_shmkey(BQ_SHM_KEY);
    if((nGlobalMem = sysv_get_shm(keyid, nGlobalLen, IPC_CREAT | 0644)) == -1)
    {
        log_fatal("bqueue_create::create global section failure!");
        return false;
    }

    //内存映射、初始化内存
    if((pGlobalMem = (char *)sysv_attach_shm(nGlobalMem,0,0)) == (char *) -1)
    {
        log_fatal("bqueue_create::create global section failure!");
        return false;
    }

    //初始化共享内存信息
    memset(pGlobalMem, 0, nGlobalLen);

    //初始化NET ROUTE TABLE
    pNetRouteTable = (BQ_NET_ROUTE_TABLE *)(pGlobalMem + OFFSET_NET_ROUTE_TABLE);
   
    for (i=0;i<BQ_MAX_NET_NUM;i++)
    {
        pNetRouteEntry = &pNetRouteTable->netRouteTable[i];
        pNetRouteEntry->used = false;
    }
    
    //初始化任务注册数组
    pTaskQueueArray = (BQ_TASK_QUEUE_ARRAY *)(pGlobalMem + OFFSET_TASK_QUEUE_ARRAY);
    for (i=0;i<BQ_MAX_TASK_NUM;i++)
    {
        pTaskQueue = &pTaskQueueArray->taskQueueArray[i];
        pTaskQueue->used = false;
    }

    //建立内存块索引链表
    pFreeQueueArray = (BQ_FREE_QUEUE_ARRAY *)(pGlobalMem + OFFSET_FREE_QUEUE_ARRAY);

    pOffsetNodeArea = pGlobalMem + OFFSET_NODE_DATA_AREA;
    pOffsetblockArea = pGlobalMem + nLength - buflen;
    pOffsetNodeArea_type = pOffsetNodeArea;
    pOffsetblockArea_type = pOffsetblockArea;
    for (i=0;i<BQ_TYPE_NUM;i++)
    {
        pFreeQueue = &pFreeQueueArray->freeQueueArray[i];
        pTypeData = (BQ_TYPE_DATA *)&bq_type_define[i];
        pFreeQueue->used = true;
        pFreeQueue->type = pTypeData->type;
        pFreeQueue->count = pTypeData->count;
        if ( !bq_init_pthread_mutex(&(pFreeQueue->mutex)) )
        {
            log_fatal("bqueue_create::bq_init_pthread_mutex failed.");
            return false;
        }
        pFreeQueue->queueCount = 0;
        pFreeQueue->warnLevel = pTypeData->warnning;
        pFreeQueue->getFailedCount = 0;
        //sysv_sem_setval(pFreeQueue->semCurCount, 0, 0);

        for (j=0;j<pTypeData->count;j++)
        {
            pNode = (BQ_NODE_DATA *)(pOffsetNodeArea_type + j * sizeof(BQ_NODE_DATA));
            pBlock = pOffsetblockArea_type + (j * pTypeData->size);

            pNode->type = pTypeData->type;
            pNode->status = BQ_IN_FREE;
            pNode->pid = 0;
            pNode->offsetBuf = pBlock - pGlobalMem;

            pNode->len = 0;
            pNode->offsetNext = (char *)pNode + sizeof(BQ_NODE_DATA) - pGlobalMem;

            pthread_mutex_lock(&pFreeQueue->mutex);
            putFreeNode(pFreeQueue, pNode);
            pthread_mutex_unlock(&pFreeQueue->mutex);
        }

        pOffsetNodeArea_type += pTypeData->count * sizeof(BQ_NODE_DATA);
        pOffsetblockArea_type += pTypeData->count * pTypeData->size;
    }

    //载入BQueues配置数据
    if (!bq_load_conf())
    {
        log_fatal("bqueue_create::load_bqueues_conf return error!");
        return false;
    }

    log_info("bqueue_create success! shm_key[%#x] shm_id[%d] size[%d]", keyid, nGlobalMem, nGlobalLen);
    return true;
}

/*==============================================================================
函数功能：删除共享内存


参数列表：
    参数：

函数返回：成功返回true 失败 false


函数说明：


调用范围：外部程序用于删除共享内存调用


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
bool bqueue_destroy()
{
    if ( pGlobalMem==null )
        return false;

    /* caoxf__
    log_info("bqueue_destroy::clear sem." );

    
    BQ_TASK_QUEUE *pTaskQueue = null;
    BQ_TASK_QUEUE_ARRAY *pTaskQueueArray = null;
    BQ_FREE_QUEUE *pFreeQueue = null;
    BQ_FREE_QUEUE_ARRAY *pFreeQueueArray = null;

    
    pTaskQueueArray = (BQ_TASK_QUEUE_ARRAY *)(pGlobalMem + OFFSET_TASK_QUEUE_ARRAY);
    for (i=0; i<BQ_MAX_TASK_NUM; i++)
    {
        pTaskQueue = &pTaskQueueArray->taskQueueArray[i];
        if ( pTaskQueue->used )
        {
            log_info("bqueue_destroy::remove semaphore. TaskQueue[%d] mid[%d] fid[%d] name[%s]",
                    i, pTaskQueue->mid, pTaskQueue->fid, pTaskQueue->name);
            //sysv_sem_remove (pTaskQueue->semMutex);
            //sysv_sem_remove (pTaskQueue->semCurCount);
            
        }
    }
    

    pFreeQueueArray = (BQ_FREE_QUEUE_ARRAY *)(pGlobalMem + OFFSET_FREE_QUEUE_ARRAY);
    for (i=0; i<BQ_TYPE_NUM; i++)
    {
        pFreeQueue = &pFreeQueueArray->freeQueueArray[i];
        log_info("bqueue_destroy::remove semaphore. pFreeQueue[%d] ", i );
        //sysv_sem_remove (pFreeQueue->semMutex);
        //sysv_sem_remove (pFreeQueue->semCurCount);
       
    }
    */

    if ( sysv_detach_shm(pGlobalMem)<0 )
    {
        log_fatal("bqueue_destroy::close global section failure.");
        return false;
    }
    //删除共享内存及其数据结构
    if ( sysv_ctl_shm( nGlobalMem, IPC_RMID, null) < 0 )
    {
        log_fatal("bqueue_destroy::delete global section failure.");
        return false;
    }

    log_info("bqueue_destroy::success " );
    return true;
}


/*==============================================================================
函数功能：从buff 配置 的异机通讯模块间路由表


参数列表：
    参数：
    const char * buff   需要解析的buff 
    BQ_NET_ROUTE_ENTRY *NetRouteEntry  解析后得到数据的指针

函数返回：成功返回true 失败 false


函数说明：


调用范围：内部程序用于buff 解析的异机通讯模块配置调用

修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-11-18                           Martin

=============================================================================*/
bool parse_net_route_entry(const char * buff , BQ_NET_ROUTE_ENTRY *NetRouteEntry)
{
    char* idxp = (char *)buff;
    char *p = idxp;
    int nCount = 0 ;
    char patt [128]= {0};
    while (idxp)
    {
        idxp = index(p, ',');
        if (idxp != null )
        {
            memset(patt, 0, sizeof(patt));
            memcpy(patt, p, idxp-p);
            switch(nCount )
            {
                case 0:
                    NetRouteEntry->protocol = (BQ_PROTOCOL_TYPE)atoi(patt);
                    break;
                case 1:
                    memcpy(NetRouteEntry->ipAddr_str , patt , strlen(patt));
                    NetRouteEntry->ipAddr = int_ipaddr((char *)NetRouteEntry->ipAddr_str);
                    break ;
                case 2:
                    memcpy(NetRouteEntry->ipAddrSec_str, patt, strlen(patt));
                    NetRouteEntry->ipAddrSec = int_ipaddr((char *)NetRouteEntry->ipAddrSec_str);
                    break ;
                case 3:
                    NetRouteEntry->port = atoi(patt);
                    break ;
                default:
                    break;
            }
            p = idxp + 1;
            nCount++;
        }
        if (idxp == null && p !=null)
        {
            memset(patt, 0, sizeof(patt));
            memcpy(patt, p, strlen(buff)-(p-buff));
            NetRouteEntry->netfid = atoi(patt);
        }
    }
    return true;
}

/*==============================================================================
函数功能：从bqueue的配置文件导入 模块间路由配置表


参数列表：
    参数：

函数返回：成功返回true 失败 false


函数说明：


调用范围：内部程序用于读取conf 文件调用


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
bool bq_load_conf()
{
    int32 i = 0 ;
    BQ_NET_ROUTE_TABLE      *pNetRouteTable =null;
    BQ_NET_ROUTE_ENTRY      *pNetRouteEntry =null;
    BQ_TASK_QUEUE_ARRAY     *pTaskQueueArray = null;
    BQ_TASK_QUEUE           *pTaskQueue = null;
    BQ_NET_ROUTE_ENTRY      netentry;
    char    str[128]={0};
    char    str_temp0[64]={0};
    int32   nCount = 0;
    int32   taskIndexId = 0;

    if ( pGlobalMem==null )
    {
        return false;
    }
    log_info("bq_load_conf start.");

    XML xmlFile(BQUEUES_CONFIG_FILE);

    pNetRouteTable =  (BQ_NET_ROUTE_TABLE *)(pGlobalMem + OFFSET_NET_ROUTE_TABLE);
    pTaskQueueArray = (BQ_TASK_QUEUE_ARRAY *)(pGlobalMem + OFFSET_TASK_QUEUE_ARRAY);

    taskIndexId = 0;

    // 1 --- 加载NET ROUTE TABLE-----------------------------------------
    memset (str, 0, 128);
     
    XMLElement* subtypes = xmlFile.GetRootElement()->FindElementZ("netroutetable", false); 
    
    XMLElement* temp =  subtypes->FindElementZ("count" , false);

    temp->GetContents()[0]->GetValue(str);
    nCount = atoi(str);


    //init NET ROUTE TABLE
    for (i=0; i<nCount; i++)
    {
        memset (str, 0, 128);
        sprintf(str_temp0, "net_%d", i);

        memset((char*)&netentry, 0, sizeof(BQ_NET_ROUTE_ENTRY));
        
        temp =  subtypes->FindElementZ(str_temp0 , false);

        XMLElement* nettemp =  temp->FindElementZ("protocol" , false);
        nettemp->GetContents()[0]->GetValue(str);
        netentry.protocol =(BQ_PROTOCOL_TYPE) atoi(str);
       
        nettemp =  temp->FindElementZ("localIP" , false);
        nettemp->GetContents()[0]->GetValue(str);
        sprintf(netentry.ipAddr_str ,  "%s" , str );
        netentry.ipAddr = int_ipaddr((char *)netentry.ipAddr_str);
        
        nettemp =  temp->FindElementZ("remoteIP" , false);
        nettemp->GetContents()[0]->GetValue(str);
        sprintf(netentry.ipAddrSec_str ,  "%s" , str );
        netentry.ipAddrSec = int_ipaddr((char *)netentry.ipAddrSec_str);

   
        nettemp =  temp->FindElementZ("port" , false);
        nettemp->GetContents()[0]->GetValue(str);
        netentry.port= atoi(str);

        nettemp =  temp->FindElementZ("netfid" , false);
        nettemp->GetContents()[0]->GetValue(str);
        netentry.netfid = atoi(str);

   
        pNetRouteEntry = &pNetRouteTable->netRouteTable[i];
        pNetRouteEntry->protocol = netentry.protocol;
        pNetRouteEntry->ipAddr = netentry.ipAddr;
        strcpy(pNetRouteEntry->ipAddr_str, netentry.ipAddr_str);
        pNetRouteEntry->ipAddrSec = netentry.ipAddrSec;
        strcpy(pNetRouteEntry->ipAddrSec_str, netentry.ipAddrSec_str);
        pNetRouteEntry->port = netentry.port;
        pNetRouteEntry->netfid = netentry.netfid;
        pNetRouteEntry->used = true;
        log_info("bq_load_conf::net_%d ip[%s] ipsec[%s] port[%d] netfid[%d] protocol[%d]",
                i, pNetRouteEntry->ipAddr_str, pNetRouteEntry->ipAddrSec_str,
                pNetRouteEntry->port, pNetRouteEntry->netfid, pNetRouteEntry->protocol);

        // 2 --- 配置bq_net_proc任务-----------------------------------------
        pTaskQueue = &pTaskQueueArray->taskQueueArray[taskIndexId];
        pTaskQueue->fid = taskIndexId;
        sprintf(pTaskQueue->name, "%s%d", BQ_NET_PROC, i);
        if ( !bq_init_pthread_mutex(&(pTaskQueue->mutex)) )
        {
            log_fatal("bq_load_conf::bq_init_pthread_mutex failed.");
            return false;
        }
        if ( !bq_init_pthread_cond(&(pTaskQueue->cond_v)) )
        {
            log_fatal("bq_load_conf::bq_init_pthread_cond failed.");
            return false;
        }
        pTaskQueue->queueCount = 0;
        pTaskQueue->used = true;
        log_info("bq_load_conf::config net task. fid[%d] name[%s] taskIndexId[%d ]",
                pTaskQueue->fid, pTaskQueue->name, taskIndexId );
        taskIndexId++;
        
    }

    // 3 --- 加载TASK TABLE-----------------------------------------
    memset (str, 0, 128);

    subtypes = xmlFile.GetRootElement()->FindElementZ("tasktable", false); 
    temp =  subtypes->FindElementZ("count" , false);
    temp->GetContents()[0]->GetValue(str);
    nCount = atoi(str);

    //init TASK TABLE
    for (i=0;i<nCount;i++)
    {
        memset (str, 0, 128);
        sprintf(str_temp0, "app_%d", i);

        pTaskQueue = &pTaskQueueArray->taskQueueArray[taskIndexId];

        temp =  subtypes->FindElementZ(str_temp0 , false);

        XMLElement* eletemp =  temp->FindElementZ("name" , false);
        eletemp->GetContents()[0]->GetValue(str);
        strcpy(pTaskQueue->name, str);

        eletemp = temp->FindElementZ("local" , false);
        eletemp->GetContents()[0]->GetValue(str);
        if (atoi(str) == 1)
            pTaskQueue->local = true;
        else
            pTaskQueue->local = false;

        eletemp =  temp->FindElementZ("netindex" , false);
        eletemp->GetContents()[0]->GetValue(str);
        pTaskQueue->netIndex = atoi( str );

        if ( !bq_init_pthread_mutex(&(pTaskQueue->mutex)) )
        {
            log_fatal("bq_load_conf::bq_init_pthread_mutex failed.");
            return false;
        }
        if ( !bq_init_pthread_cond(&(pTaskQueue->cond_v)) )
        {
            log_fatal("bq_load_conf::bq_init_pthread_cond failed.");
            return false;
        }
        pTaskQueue->fid = taskIndexId;
        pTaskQueue->queueCount = 0;
        pTaskQueue->used = true;
        log_info("bq_load_conf::config task. fid[%d] name[%s] local[%d] netIndex[%d]" ,
                pTaskQueue->fid, pTaskQueue->name, pTaskQueue->local, pTaskQueue->netIndex);
        taskIndexId++;
    }

    log_info("bq_load_conf success.");
    return true;
}


/*==============================================================================
函数功能：当bqueues的不同模块间网络连接成功时，更新 net 路由表，并通知监控模块


参数列表：
    参数：
    BQ_NET_ROUTE_ENTRY *pNetRouteEntry  net路由表指针
    SOCKET socket socket套接字
    TIME_TYPE conntime   断开时间
    
函数返回：


函数说明：


调用范围：供内部程序调用

修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
void bq_netConnect(uint8 netindex, TIME_TYPE conntime)
{
    BQ_NET_ROUTE_TABLE *pNetRouteTable = null;
    BQ_NET_ROUTE_ENTRY *pNetRouteEntry = null;

    pNetRouteTable = getNetRouteTable();
    pNetRouteEntry = &pNetRouteTable->netRouteTable[netindex];

    pNetRouteEntry->netStatus = BQ_NET_STATUS_CONNECTED;
    pNetRouteEntry->connectTime = conntime;
    pNetRouteEntry->failureHB = 0;
    pNetRouteEntry->retryConnect = 0;

    //通知Monitor agent
    bq_notify_net_change(pNetRouteEntry->ipAddr_str, pNetRouteEntry->ipAddrSec_str, 1);
}

/*==============================================================================
函数功能：当bqueues的不同模块间网络连接断开时，更新net 路由表，并通知监控模块


参数列表：
    参数：
    BQ_NET_ROUTE_ENTRY *pNetRouteEntry  net路由表指针
    TIME_TYPE disconntime   断开时间
    BQ_DISCONN_REASON reason    断开原因

函数返回：


函数说明：


调用范围：供内部程序调用


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
void bq_netDisConnect(uint8 netindex, TIME_TYPE disconntime, BQ_DISCONN_REASON reason)
{
    BQ_NET_ROUTE_TABLE *pNetRouteTable = null;
    BQ_NET_ROUTE_ENTRY *pNetRouteEntry = null;

    pNetRouteTable = getNetRouteTable();
    pNetRouteEntry = &pNetRouteTable->netRouteTable[netindex];

    pNetRouteEntry->netStatus = BQ_NET_STATUS_DISCONNECTED;
    pNetRouteEntry->disconnTime = disconntime;
    pNetRouteEntry->disconnCount++;
    pNetRouteEntry->disconnReason = reason;

    //通知Monitor agent
    bq_notify_net_change(pNetRouteEntry->ipAddr_str, pNetRouteEntry->ipAddrSec_str, 0 );
}

/*==============================================================================
函数功能：得到net 路由表的头指针


参数列表：
    参数：

函数返回：返回头指针


函数说明：


调用范围：供内部程序调用


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
BQ_NET_ROUTE_TABLE *getNetRouteTable()
{
    BQ_NET_ROUTE_TABLE *pNetRouteTable = null;
    pNetRouteTable = (BQ_NET_ROUTE_TABLE *)(pGlobalMem + OFFSET_NET_ROUTE_TABLE);
    return pNetRouteTable;
}


/*==============================================================================
函数功能：得到对应此 fid 的task记录指针


参数列表：
    参数：
     FID mid     任务所属模块ID
函数返回：成功返回指针，失败返回null


函数说明：


调用范围：供内部程序用于获取此 fid 对应 的task记录指针调用


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
BQ_TASK_QUEUE *getTaskEntry(FID fid)
{
    BQ_TASK_QUEUE_ARRAY *pTaskTable = null;
    BQ_TASK_QUEUE *pTaskEntry = null;

    if ( fid >= BQ_MAX_TASK_NUM )
        return null;

    pTaskTable = (BQ_TASK_QUEUE_ARRAY *)(pGlobalMem + OFFSET_TASK_QUEUE_ARRAY);
    pTaskEntry = &pTaskTable->taskQueueArray[fid];
    if ( !pTaskEntry->used )
        return null;

    return pTaskEntry;
}

/*==============================================================================
函数功能：得到对应此 net 路由表的记录指针


参数列表：
    参数：
    FID netfid

函数返回：成功返回指针，失败返回null


函数说明：


调用范围：供内部程序用于获取此 netfid  对应 的net 路由表记录指针调用

修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
BQ_NET_ROUTE_ENTRY *getTaskNetRouteEntry(FID fid)
{
    BQ_TASK_QUEUE *pTaskEntry = getTaskEntry(fid);
    if(pTaskEntry==null)
        return null;

    if ( pTaskEntry->netIndex > BQ_MAX_NET_TASK_NUM )
        return null;

    BQ_NET_ROUTE_TABLE *pNetRouteTable = null;
    BQ_NET_ROUTE_ENTRY *pNetRouteEntry = null;
    pNetRouteTable = (BQ_NET_ROUTE_TABLE *)(pGlobalMem + OFFSET_NET_ROUTE_TABLE);
    pNetRouteEntry = &pNetRouteTable->netRouteTable[pTaskEntry->netIndex];
    if ( !pNetRouteEntry->used )
        return null;

    return pNetRouteEntry;
}


/*==============================================================================
函数功能：om_notify 链路状态改变


参数列表：
    参数：

函数返回：成功返回true 失败 false


函数说明：


调用范围：


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
bool bq_notify_net_change(char *src_mid_ip, char *des_mid_ip, bool conn)
{
    GLTP_MSG_NTF_BQ_LINK_STATUS notify;
    memset ((void*)&notify , 0 , sizeof(GLTP_MSG_NTF_BQ_LINK_STATUS));

    memcpy(notify.AModIP, src_mid_ip, sizeof(notify.AModIP));
    memcpy(notify.BModIP, des_mid_ip, sizeof(notify.BModIP));
    notify.linkState = conn;

    sys_notify(GLTP_NTF_BQ_LINK_STATUS, _WARN, (char *)&notify, sizeof(GLTP_MSG_NTF_BQ_LINK_STATUS));
    return true;
}

/*==============================================================================
函数功能：om_notify buffer不足事件告警


参数列表：
    参数：

函数返回：成功返回true 失败 false


函数说明：


调用范围：


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
bool bq_notify_buffer_warning(uint8 type, uint32 count)
{
    GLTP_MSG_NTF_BQ_BUFFER_NOTENOUGH notify;

    memset ((void*)&notify , 0 , sizeof(GLTP_MSG_NTF_BQ_BUFFER_NOTENOUGH));

    notify.bufferType = type;
    notify.remainBuffNum = count;

    sys_notify(GLTP_NTF_BQ_BUFFER_NOTENOUGH, _WARN, (char *)&notify, sizeof(GLTP_MSG_NTF_BQ_BUFFER_NOTENOUGH));
    return true;
}


/*==============================================================================
函数功能：任务使用bqueues的初始化函数，对共享内存进行映射


参数列表：
    参数：

函数返回：成功返回true 失败 false


函数说明：


调用范围：供外部程序用于 任务使用bqueues的初始化时调用


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
bool bq_init()
{
    if( (nGlobalMem = sysv_get_shm(ipcs_shmkey(BQ_SHM_KEY),nGlobalLen,0) ) == -1 )
    {
        log_fatal("bq_init::open global section failure shm_key[%d]." , BQ_SHM_KEY );
        return false;
    }
    
    if( (pGlobalMem = (char *)sysv_attach_shm(nGlobalMem,0,0)) == (char *)-1 )
    {
        log_fatal("bq_init::map global section failure.");
        return false;
    }

    return true;
}

/*==============================================================================
函数功能：关闭共享内存区的映射


参数列表：
    参数：

函数返回：成功返回true 失败 false


函数说明：


调用范围：供外部程序用于 关闭共享内存区的映射时调用


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
bool bq_close()
{
    //断开与共享内存的连接
    if ( sysv_detach_shm((void const*)pGlobalMem)<0 )
    {
        log_fatal("bq_close::close global section failure.");
        return false;
    }
    nGlobalMem = 0;
    pGlobalMem = null;
    return true;
}


/*==============================================================================
函数功能：根据任务名称匹配得到对应的FID，即在任务注册表中配置的位置索引


参数列表：
    参数：
    char* name  任务名称

函数返回：失败返回-1 ，成功返回FID >=0


函数说明：


调用范围：供外部程序用于根据任务名称匹配得到对应的FID时调用


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
int8 getFidByName(const char *name)
{
    int32 i = 0;
    BQ_TASK_QUEUE *pTaskQueue = null;
    BQ_TASK_QUEUE_ARRAY *pTaskQueueArray = null;

    if (pGlobalMem == null)
    {
        log_error("getFidByName(%s) returns null", name);
        return -1;
    }

    pTaskQueueArray = (BQ_TASK_QUEUE_ARRAY *)(pGlobalMem + OFFSET_TASK_QUEUE_ARRAY);
    for (i = 0; i < BQ_MAX_TASK_NUM; i++)
    {
        pTaskQueue = &pTaskQueueArray->taskQueueArray[i];
        if (!pTaskQueue->used)
            continue;
        if (0 == strcmp(name, pTaskQueue->name))
        {
            log_info("getFidByName::ok. task(name[%s] fid[%d]) input(name[%s]).", pTaskQueue->name, i, name);
            return i;
        }
    }
    log_error("getFidByName::Can't find any FID match with name[%s].", name);
    return -1;
}

/*==============================================================================
函数功能：注册任务到bqueues

参数列表：
    参数：
    FID fid     需要注册的任务号ID
    char* name  需要注册的任务名称
    PID pid 需要注册的进程号
    
函数返回： 注册成功返回true 失败 false
                   

函数说明：


调用范围：供外部程序用于任务在bqueues中的注册的调用

修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
bool bq_register(FID fid, const char* name, PID pid)
{
    BQ_TASK_QUEUE *pTaskQueue = null;
    BQ_TASK_QUEUE_ARRAY *pTaskQueueArray = null;

    if ( pGlobalMem==null )
    {
        return false;
    }

    if ( (fid<0) || (fid>=BQ_MAX_TASK_NUM) || (null==name) || (pid<=0) )
    {
        log_fatal("bq_register::input parameter is error.");
        return false;
    }
    
    pTaskQueueArray = (BQ_TASK_QUEUE_ARRAY *)(pGlobalMem + OFFSET_TASK_QUEUE_ARRAY);
    pTaskQueue = &pTaskQueueArray->taskQueueArray[fid];
    if ( memcmp(name, pTaskQueue->name, strlen(pTaskQueue->name)))
    {
        log_info("bq_register::register failure task( name[%s]) input( fid[%d] name[%s]).",
                pTaskQueue->name, fid ,name);
        return false;
    }

    if ( pTaskQueue->used )
    {
        if ( !pTaskQueue->registed )
        {
            pTaskQueue->fid = fid;
            pTaskQueue->pid = pid;
            pTaskQueue->offsetHead = 0;
            pTaskQueue->offsetTail = 0;
            pTaskQueue->queueCount = 0;
            pTaskQueue->received = 0;
            pTaskQueue->processed = 0;
            pTaskQueue->registed = true;
        }
    }
    else
    {
        log_fatal("bq_register::Task fid didn't cinfig. fid[%d] name[%s]", fid, name);
        return false;
    }

    log_info("bq_register::ok. fid[%d] name[%s].", fid, name);

    return true;
}

/*==============================================================================
函数功能：取消任务在bqueues中的注册，并清空任务队列


参数列表：
    参数：
    FID fid     需要注册的功能号ID

函数返回：反注册成功返回true 失败 false


函数说明：


调用范围：供外部程序用于取消任务在bqueues中的注册的调用


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
bool bq_unregister(FID fid)
{
    BQ_TASK_QUEUE *pTaskQueue = null;
    BQ_TASK_QUEUE_ARRAY *pTaskQueueArray = null;
    BQ_FREE_QUEUE *pFreeQueue = null;
    BQ_FREE_QUEUE_ARRAY *pFreeQueueArray = null;
    BQ_NODE_DATA *pNode = null;

    if ( pGlobalMem==null )
    {
        log_fatal("bq_unregister::Bqueues global section didn't initialization.");
        return false;
    }

    if ( (fid<0) || (fid>=BQ_MAX_TASK_NUM) )
    {
        log_fatal("bq_unregister::fid is error. fid[%d]", fid);
        return false;
    }

    pTaskQueueArray = (BQ_TASK_QUEUE_ARRAY *)(pGlobalMem + OFFSET_TASK_QUEUE_ARRAY);
    pTaskQueue = &pTaskQueueArray->taskQueueArray[fid];

    if ( pTaskQueue->used )
    {
        pTaskQueue->registed = false;
    }

    //清空任务消息队列
    while ( pTaskQueue->queueCount > 0 )
    {
        pthread_mutex_lock(&pTaskQueue->mutex);
        pNode  = getTaskNode(pTaskQueue);
        pthread_mutex_unlock(&pTaskQueue->mutex);

        pFreeQueueArray = (BQ_FREE_QUEUE_ARRAY *)(pGlobalMem + OFFSET_FREE_QUEUE_ARRAY);
        pFreeQueue = &pFreeQueueArray->freeQueueArray[(int32)pNode->type];

        pthread_mutex_lock(&pFreeQueue->mutex);
        putFreeNode(pFreeQueue, pNode);
        pthread_mutex_unlock(&pFreeQueue->mutex);
    }

    log_info("bq_unregister::ok. fid[%d] name[%s].", fid, pTaskQueue->name);

    return true;
}

/*==============================================================================
函数功能：发送消息

参数列表：
    参数：
    const BQ_HEADER *header BQ消息头结构
    char *buf   BQ 消息
    int32 len   BQ 消息长度

函数返回：如果send 出错 返回 0  成功返回长度


函数说明：


调用范围：提供外部程序用于BQ发送调用

修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
int32 bq_sendA(const BQ_HEADER *header, const char *buf, uint32 len)
{
    int32 i =0;
    bool flag = false;


    BQ_NET_ROUTE_ENTRY  *pNetRouteEntry = null;
    BQ_TYPE_DATA        *pTypeData = null;
    BQ_TASK_QUEUE       *pTaskQueue = null;
    BQ_TASK_QUEUE_ARRAY *pTaskQueueArray = null;
    BQ_FREE_QUEUE       *pFreeQueue = null;
    BQ_FREE_QUEUE_ARRAY *pFreeQueueArray = null;
    BQ_NODE_DATA*        pNode = null;

    if ( (header==null) || (buf==null) || (len<=0) )
    {
        log_error("bq_sendA::parameter is error.");
        return 0;
    }

    if ( (header->host<0) || (header->host>=BQ_MAX_TASK_NUM) )
    {
        log_error("bq_sendA::BQ_HEADER.host.Task id [%d] is out of range.", header->host);
        return 0;
    }

    pTaskQueueArray = (BQ_TASK_QUEUE_ARRAY *)(pGlobalMem + OFFSET_TASK_QUEUE_ARRAY);
    pTaskQueue = &pTaskQueueArray->taskQueueArray[header->host];

    if ( !pTaskQueue->used || !pTaskQueue->registed )
    {
        log_error("bq_sendA:: task isn't used OR isn't register. host-FID[%d] send-FID[%d].",
            header->host, header->sender);
        return 0;
    }

    if ( len > bq_type_define[BQ_TYPE_NUM-1].size )
    {
        //消息太长
        log_error("bq_sendA::message is too long. len[%u]", len);
        return 0;
    }

GET_FREE_NODE:

    //根据 Message 的长度来申请Block
    for (i=0;i<BQ_TYPE_NUM;i++)
    {
        pTypeData = (BQ_TYPE_DATA *)&bq_type_define[i];
        if ( len <= pTypeData->size )
        {
            pFreeQueueArray = (BQ_FREE_QUEUE_ARRAY *)(pGlobalMem + OFFSET_FREE_QUEUE_ARRAY);
            pFreeQueue = &pFreeQueueArray->freeQueueArray[i];

            pthread_mutex_lock(&pFreeQueue->mutex);
            if(pFreeQueue->queueCount <= 0)
            {
                pthread_mutex_unlock(&pFreeQueue->mutex);
                continue;
            }
            else
            {
                pNode = getFreeNode(pFreeQueue);
                pthread_mutex_unlock(&pFreeQueue->mutex);
                flag = true;
                break;
            }
        }
    }

    if (!flag)
    {
        ts_sleep(1000,0);
        log_warn("bq_sendA::get free node failure. retry");
        goto GET_FREE_NODE;
    }

    pNode->header.host = header->host;
    pNode->header.sender = header->sender;
    pNode->header.code = header->code;
    pNode->len = len;
    memcpy( (pGlobalMem+pNode->offsetBuf), buf, len);
    pTaskQueueArray = (BQ_TASK_QUEUE_ARRAY *)(pGlobalMem + OFFSET_TASK_QUEUE_ARRAY);

    if (pTaskQueue->local)
    {
        //本地，直接发送
        pthread_mutex_lock(&pTaskQueue->mutex);
        putTaskNode(pTaskQueue, pNode);
        pthread_mutex_unlock(&pTaskQueue->mutex);

        //唤醒接受任务
        pthread_cond_signal(&pTaskQueue->cond_v);
        
        while (pTaskQueue->queueCount > BQ_TASK_QUEUE_PROTECT)
        {
            ts_sleep(1000,0);
        }

        //任务队列未处理消息过多告警
        if (pTaskQueue->queueCount > BQ_TASKQUEUE_WARN_NUM)
        {
            bq_notify_buffer_warning(pNode->type , (pTypeData->count-pTaskQueue->queueCount));
        }
    }
    else
    {
        //网络 发送到MID对应的异机通信模块
        pNetRouteEntry = getTaskNetRouteEntry(pTaskQueue->netIndex);
        if(pNetRouteEntry==null)
        {
            //得到网络net记录失败
            log_error("bq_sendA::getTaskNetRouteEntry(fid=%d) return failure.", pTaskQueue->fid);
            return 0;
        }

        pTaskQueue = &pTaskQueueArray->taskQueueArray[pNetRouteEntry->netfid];

        pthread_mutex_lock(&pTaskQueue->mutex);
        putTaskNode(pTaskQueue, pNode);
        pthread_mutex_unlock(&pTaskQueue->mutex);

        //唤醒接受任务
        pthread_cond_signal(&pTaskQueue->cond_v);
        
        while (pTaskQueue->queueCount > BQ_TASK_QUEUE_PROTECT)
        {
            ts_sleep(1000,0);
        }

        //任务队列未处理消息过多告警
        if (pTaskQueue->queueCount > BQ_TASKQUEUE_WARN_NUM)
        {
            bq_notify_buffer_warning(pNode->type , (pTypeData->count-pTaskQueue->queueCount));
        }
    }

    return len;
}

/*==============================================================================
函数功能：发送BQ 消息


参数列表：
    参数：
    FID hfid     BQ接收方的功能号
    char *buf   BQ 消息
    int32 len   BQ 消息长度

函数返回：如果send 出错 返回 0  成功返回长度


函数说明：


调用范围：提供外部程序用于BQ发送调用


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
int32 bq_send(FID hfid, const char *buf, int32 length)
{
    int32 ret = 0;
    BQ_HEADER header;

    header.host = hfid;
    header.sender = 0;
    header.code = 0;
    bq_sendWriteHexLog(hfid, 0, (char *)buf ,length );
    ret = bq_sendA(&header, buf, length);
    if ( ret <= 0 )
    {
        log_error("bq_sendA::bq_send return error!");
    }
    return ret;
}

/*==============================================================================
函数功能：接收消息


参数列表：
    参数：
    FID fid     BQ接收的功能号
    BQ_HEADER *header   BQ头结构体
    char *buf   BQ 消息
    int32 len   BQ 消息长度

函数返回：如果recv出错 返回 -1 如果是遇到退出码则返回0


函数说明：


调用范围：提供外部程序用于BQ接收调用


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
int32 bq_recvA(FID fid, BQ_HEADER *header, char *buf, uint32 len, int32 timeout_msec)
{
    //------------------------------
    // 队列中有数据,关键问题，这个任务队列只能单个任务收
    //------------------------------

    int32 nlength = 0;

    BQ_TASK_QUEUE *pTaskQueue = null;
    BQ_TASK_QUEUE_ARRAY *pTaskQueueArray = null;
    BQ_FREE_QUEUE *pFreeQueue = null;
    BQ_FREE_QUEUE_ARRAY *pFreeQueueArray = null;
    BQ_NODE_DATA* pNode = null;
    BQ_NODE_DATA* pNode_t = null;

    if ( (buf==null) || (len<=0) )
    {
        log_error("bq_recvA::msgptr is NULL or len is error.");
        return -1;
    }
    if ( (fid<0) || (fid>=BQ_MAX_TASK_NUM) )
    {
        log_error("bq_recvA::FID is error. fid[%d].", fid);
        return -1;
    }
   
    pTaskQueueArray = (BQ_TASK_QUEUE_ARRAY *)(pGlobalMem + OFFSET_TASK_QUEUE_ARRAY);
    pTaskQueue = &pTaskQueueArray->taskQueueArray[fid];

    if ( !pTaskQueue->used || !pTaskQueue->registed )
    {
        log_error("bq_recvA::Task didn't registed or didn't config.");
        return -1;
    }

    //锁定task queue count
    pthread_mutex_lock(&pTaskQueue->mutex);
    if (pTaskQueue->queueCount<=0)
    {
        if (timeout_msec == 0)
        {
            while (pTaskQueue->queueCount<=0)
            {
                //阻塞接收  函数进入时先unlock,出来时再lock
                pthread_cond_wait(&pTaskQueue->cond_v, &pTaskQueue->mutex);
            }
        }
        else
        {
            struct timespec timeout;
            int t_s = timeout_msec / 1000;
            int t_m = timeout_msec % 1000;
            struct timeval now;
            gettimeofday(&now, NULL);
            timeout.tv_sec = now.tv_sec + t_s;
            timeout.tv_nsec = (now.tv_usec*1000) + (t_m*1000*1000);
            if (timeout.tv_nsec >= 1000000000)
            {
                timeout.tv_nsec -= 1000000000;
                timeout.tv_sec++;
            }
            //带超时的阻塞
            if (ETIMEDOUT == pthread_cond_timedwait(&pTaskQueue->cond_v, &pTaskQueue->mutex, &timeout))
            {
                pthread_mutex_unlock(&pTaskQueue->mutex);
                return 0;
            }
            if (pTaskQueue->queueCount<=0)
            {   
                pthread_mutex_unlock(&pTaskQueue->mutex);
                return 0;
            }
        }
    }

    //得到第一个消息的长度，判断buffer长度是否正确
    pNode_t = (BQ_NODE_DATA *)(pGlobalMem+pTaskQueue->offsetHead);
    if ( pNode_t->len > len )
    {
        pthread_mutex_unlock(&pTaskQueue->mutex);
        log_error("bq_recvA::Receive buffer isn't enough.");
        return -1;
    }
    //从task queue摘下节点
    pNode = getTaskNode(pTaskQueue);
    pthread_mutex_unlock(&pTaskQueue->mutex);

    header->host = pNode->header.host;
    header->sender = pNode->header.sender;
    header->code = pNode->header.code;
    nlength = pNode->len;
    memcpy((char *)buf, (char *)(pGlobalMem+pNode->offsetBuf), nlength);

    pFreeQueueArray = (BQ_FREE_QUEUE_ARRAY *)(pGlobalMem + OFFSET_FREE_QUEUE_ARRAY);
    pFreeQueue = &pFreeQueueArray->freeQueueArray[(int32)pNode->type];

    //还回free链表
    pthread_mutex_lock(&pFreeQueue->mutex);
    putFreeNode(pFreeQueue, pNode);
    pthread_mutex_unlock(&pFreeQueue->mutex);

    return nlength;
}

/*==============================================================================
函数功能：接收消息


参数列表：
    参数：
    FID fid     BQ接收的功能号
    char *buf   BQ 消息
    int32 len   BQ 消息长度

函数返回：如果recv出错 返回 -1 如果是遇到退出码则返回BQ_CMD_CODE_EXIT =9999
函数说明：
调用范围：提供外部程序用于BQ接收调用
修改记录：
修改日期        CR No             修改人          描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
int32 bq_recv(FID fid, char *buf, int32 len, int32 timeout_msec)
{
    int32 ret = 0;
    BQ_HEADER header;
    ret = bq_recvA(fid, &header, buf, len, timeout_msec);
    if ( ret < 0 )
    {
        log_error("bq_recv::bq_recvA return error!");
        return ret;
    }
    else if ( ret == 0 )
    {
        //receive timeout
        return ret;
    }

    bq_recvWriteHexLog( fid , buf , ret);
    return ret;
}

/*--------------------------查看BQueues状态接口-----------------------------------------*/

/*==============================================================================
函数功能：查看网络链路的状况


参数列表
    参数：

函数返回：


函数说明：


调用范围：


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
void bq_print_netRouteTable()
{
    int32 i =0;
    BQ_NET_ROUTE_TABLE *pNetRouteTable = null;
    BQ_NET_ROUTE_ENTRY *pNetRouteEntry = null;

    if ( pGlobalMem==null )
    {
        printf("Couldn't find global section.\n");
        return;
    }

    printf( "BQ--- Output NET Route Table Information ------------ begin\n\n");
    pNetRouteTable = (BQ_NET_ROUTE_TABLE *)(pGlobalMem + OFFSET_NET_ROUTE_TABLE);
    for (i=0;i<BQ_MAX_NET_TASK_NUM;i++)
    {
        pNetRouteEntry = &pNetRouteTable->netRouteTable[i];
        if ( !pNetRouteEntry->used )
            continue;
        printf( "BQ NET[%d] -> ip[%s] ipsec[%s] port[%d] protocol[%d] netfid[%d]\n",
                i,
                pNetRouteEntry->ipAddr_str,
                pNetRouteEntry->ipAddrSec_str,
                pNetRouteEntry->port,
                pNetRouteEntry->protocol,
                pNetRouteEntry->netfid );
        printf( "       netStatus[%d] connectTime[%d:%d] disconnTime[%d:%d] disconnCount[%d] disconnReason[%d]\n",
                pNetRouteEntry->netStatus,
                (int32)pNetRouteEntry->connectTime.tv_sec,
                (int32)pNetRouteEntry->connectTime.tv_usec,
                (int32)pNetRouteEntry->disconnTime.tv_sec,
                (int32)pNetRouteEntry->disconnTime.tv_usec,
                pNetRouteEntry->disconnCount,
                pNetRouteEntry->disconnReason );
        printf( "       failureHB[%d] retryConnect[%d] sendPkgNum[%d] recvPkgNum[%d]\n",
                pNetRouteEntry->failureHB,
                pNetRouteEntry->retryConnect,
                pNetRouteEntry->sndPkgNum,
                pNetRouteEntry->rcvPkgNum );
        printf( "\n");
    }
    printf( "BQ--- Output Net Route Table Information ------------ end\n");
}


/*==============================================================================
函数功能：查看free队列使用情况


参数列表：
    参数：

函数返回：


函数说明：


调用范围：


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
void bq_print_freeQueue()
{
    int32 i =0;
    BQ_TYPE_DATA *pTypeData = null;
    BQ_FREE_QUEUE *pFreeQueue = null;
    BQ_FREE_QUEUE_ARRAY *pFreeQueueArray = null;

    if ( pGlobalMem==null )
    {
        printf("Couldn't find global section.\n");
        return;
    }

    printf( "BQ--- Output FreeQueues Information ------------ begin\n\n");
    pFreeQueueArray = (BQ_FREE_QUEUE_ARRAY *)(pGlobalMem + OFFSET_FREE_QUEUE_ARRAY);
    for (i=0;i<BQ_TYPE_NUM;i++)
    {
        pTypeData = (BQ_TYPE_DATA *)&bq_type_define[i];
        pFreeQueue = &pFreeQueueArray->freeQueueArray[i];
        printf( "BQ Free -> %s\n",pTypeData->name );
        printf( "       type[%d]  block_count[%d]  block_size[%d]\n", pTypeData->type, pTypeData->count, pTypeData->size );
        printf( "       block_used[%d]  block_free[%d]\n", (pFreeQueue->count-pFreeQueue->queueCount), pFreeQueue->queueCount );
        printf( "       FreeNode_Head(offset)[0X%0x]  FreeNode_Tail[0X%0x] \n", pFreeQueue->offsetHead, pFreeQueue->offsetTail );
        printf( "       nWarnLevel[%d]  nGetFailedCount[%d]\n", pFreeQueue->warnLevel, pFreeQueue->getFailedCount );
        printf( "\n");
    }
    printf( "BQ--- Output FreeQueues Information ------------ end\n");
}

int32  bq_check_freeQueue()
{
    int32 i =0;
    BQ_TYPE_DATA *pTypeData = null;
    BQ_FREE_QUEUE *pFreeQueue = null;
    BQ_FREE_QUEUE_ARRAY *pFreeQueueArray = null;

    int64   block_free_count = 0;
    int64   block_sum_count = 0;

    if ( pGlobalMem==null )
    {
        printf("Couldn't find global section.\n");
        return -1 ;
    }

    printf( "BQ--- Output FreeQueues Information ------------ begin\n\n");
    pFreeQueueArray = (BQ_FREE_QUEUE_ARRAY *)(pGlobalMem + OFFSET_FREE_QUEUE_ARRAY);
    for (i=0;i<BQ_TYPE_NUM;i++)
    {
        pTypeData = (BQ_TYPE_DATA *)&bq_type_define[i];
        pFreeQueue = &pFreeQueueArray->freeQueueArray[i];

        block_sum_count += pFreeQueue->count;
        block_free_count += pFreeQueue->queueCount;
        
    }
    
    return block_free_count*100/block_sum_count;
    
}

/*==============================================================================
函数功能：查看task队列使用情况


参数列表：
    参数：bool used  是否显示没使用的记录，used==false，则全都显示

函数返回：


函数说明：


调用范围：


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
void bq_print_taskQueue()
{
    int32 i =0;
    BQ_TASK_QUEUE *pTaskQueue = null;
    BQ_TASK_QUEUE_ARRAY *pTaskQueueArray = null;

    if ( pGlobalMem==null )
    {
        printf("Couldn't find global section.\n");
        return;
    }

    printf( "BQ--- Output TaskQueues Information ------------ begin\n\n");
    pTaskQueueArray = (BQ_TASK_QUEUE_ARRAY *)(pGlobalMem + OFFSET_TASK_QUEUE_ARRAY);
    for (i=0;i<BQ_MAX_TASK_NUM;i++)
    {
        pTaskQueue = &pTaskQueueArray->taskQueueArray[i];
        if ( !pTaskQueue->used )
            continue;
        printf( "BQ Task -> %s  TID[%d] PID[%d]\n",pTaskQueue->name, pTaskQueue->fid, pTaskQueue->pid);
        printf( "       Current_Count[%d] Receive_count[%d] Processed_count[%d]\n",pTaskQueue->queueCount, pTaskQueue->received, pTaskQueue->processed);
        printf( "\n");
    }
    printf( "BQ--- Output TaskQueues Information ------------ end\n");
}


/*==============================================================================
函数功能：当任务可以直接从队列中申请内存使用时，可能申请的内存丢失，
          这个函数用来整理回收丢失的内存
          现在的机制，暂时不用实现


参数列表：
    参数：

函数返回：


函数说明：


调用范围：


修改记录：

 修改日期              CR No        修改人         描述
----------      ------------      --------        -------------
2009-09-18                        Forrest

=============================================================================*/
void bq_refresh()
{

}

BQ_TASK_QUEUE_ARRAY *getTaskQueueArray()
{
    BQ_TASK_QUEUE_ARRAY *pTaskQueueArray = null;

    if ( pGlobalMem==null )
    {
        printf("Couldn't find global section.\n");
        return pTaskQueueArray;
    }

    pTaskQueueArray = (BQ_TASK_QUEUE_ARRAY *)(pGlobalMem + OFFSET_TASK_QUEUE_ARRAY);

    return pTaskQueueArray;
}

BQ_FREE_QUEUE_ARRAY *getFreeQueueArray()
{
    BQ_FREE_QUEUE_ARRAY *pFreeQueueArray = null;
  
    if ( pGlobalMem==null )
    {
     
        return pFreeQueueArray ;
    }
  
    pFreeQueueArray = (BQ_FREE_QUEUE_ARRAY *)(pGlobalMem + OFFSET_FREE_QUEUE_ARRAY);

     return pFreeQueueArray ;
}




//--- message queue 内部使用的队列 -------------------------------------

static void mque_enqueue(MQUE *q, mque_item *ism)
{
    pthread_mutex_lock(&(q->mutex));
    if (q->size == 0) {
        q->head = q->tail = ism; ism->next = NULL;
    } else {
        ism->next = NULL; q->tail->next = ism; q->tail = ism;
    }
    q->size++;
    pthread_mutex_unlock(&(q->mutex));
    pthread_cond_signal(&(q->cond));
    return;
}
static mque_item *mque_dequeue(MQUE *q, int timeout_msec)
{
    pthread_mutex_lock(&(q->mutex));
    if (q->size <= 0) {
        if (timeout_msec == 0) {
            while (q->size == 0) { pthread_cond_wait(&(q->cond), &(q->mutex)); }
        } else {
            struct timespec timeout; int t_s = timeout_msec / 1000; int t_m = timeout_msec % 1000;
            struct timeval now; gettimeofday(&now, NULL);
            timeout.tv_sec = now.tv_sec + t_s; timeout.tv_nsec = (now.tv_usec*1000) + (t_m*1000*1000);
            if (timeout.tv_nsec >= 1000000000) { timeout.tv_nsec -= 1000000000; timeout.tv_sec++; }
            pthread_cond_timedwait(&(q->cond), &(q->mutex), &timeout);
            if (q->size == 0) { pthread_mutex_unlock(&(q->mutex)); return NULL; }
        }
    }
    mque_item *ism = q->head; q->head = ism->next;
    if (NULL == q->head) q->tail = NULL;
    q->size--;
    pthread_mutex_unlock(&(q->mutex));
    return ism;
}
static int mque_size(MQUE *q)
{
    pthread_mutex_lock(&(q->mutex));
    int size = q->size;
    pthread_mutex_unlock(&(q->mutex));
    return size;
}
MQUE *mque_create()
{
    MQUE *q = (MQUE *)malloc(sizeof(MQUE));
    if (NULL == q) { log_error("malloc() return NULL."); return NULL; }
    memset(q, 0, sizeof(MQUE));
    q->enqueue = mque_enqueue;
    q->dequeue = mque_dequeue;
    q->get_size = mque_size;
    q->head = NULL; q->tail = NULL; q->size = 0;
    int ret = pthread_mutex_init(&(q->mutex), NULL);
    if (0 != ret) { log_error("pthread_mutex_init() failed. Reason:[%s].", strerror(errno)); return NULL; }
    ret = pthread_cond_init(&(q->cond), NULL);
    if (0 != ret) { log_error("pthread_cond_init() failed. Reason:[%s].", strerror(errno)); return NULL; }
    return q;
}



