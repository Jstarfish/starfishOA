#ifndef BQUEUES_H_INCLUDED
#define BQUEUES_H_INCLUDED


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



//共享内存信息分布  按顺序连续存放 --------------------------------
/*
--- sizeof( BQ_NET_ROUTE_TABLE  ) -------  NET 路由表
--- sizeof( BQ_FID_ROUTE_TABLE  ) -------  模块路由表
--- sizeof( BQ_TASK_QUEUE_ARRAY ) -------  任务注册表
--- sizeof( BQ_FREE_QUEUE_ARRAY ) -------  free queue 管理数组
--- sizeof( BQ_NODE_DATA ) * BQ_TYPE[0].count ---  某一类型的数据块索引数据节点链表
--- sizeof( BQ_NODE_DATA ) * BQ_TYPE[1].count ---
--- sizeof( BQ_NODE_DATA ) * BQ_TYPE[2].count ---
--- sizeof( BQ_NODE_DATA ) * BQ_TYPE[3].count ---
......
--- BQ_TYPE[0].size * BQ_TYPE[0].count ---  真正的数据存放内存区
--- BQ_TYPE[1].size * BQ_TYPE[1].count ---
--- BQ_TYPE[2].size * BQ_TYPE[2].count ---
--- BQ_TYPE[3].size * BQ_TYPE[3].count ---
......
*/
enum GLOBAL_SHARE_MEMORY_OFFSET
{
    OFFSET_NET_ROUTE_TABLE   =  0,
    OFFSET_TASK_QUEUE_ARRAY  =  OFFSET_NET_ROUTE_TABLE + sizeof(BQ_NET_ROUTE_TABLE),
    OFFSET_FREE_QUEUE_ARRAY  =  OFFSET_TASK_QUEUE_ARRAY + sizeof(BQ_TASK_QUEUE_ARRAY),
    OFFSET_NODE_DATA_AREA    =  OFFSET_FREE_QUEUE_ARRAY + sizeof(BQ_FREE_QUEUE_ARRAY)
};


bool bq_load_conf();

void bq_netConnect(uint8 netindex, TIME_TYPE conntime);
void bq_netDisConnect(uint8 netindex, TIME_TYPE disconntime, BQ_DISCONN_REASON reason);

BQ_TASK_QUEUE *getTaskEntry(FID fid);

BQ_NET_ROUTE_ENTRY *getTaskNetRouteEntry(FID fid);



bool bq_sendWriteHexLog(FID hfid, FID sfid,char *str , int32 lenth);
bool bq_recvWriteHexLog( FID hfid,char *str , int32 lenth);


#if R("---BQUEUES notify interface---")

//BQueues链路状态变更
bool bq_notify_net_change(char *src_ip, char *des_ip, bool conn);

//Buffer不足报警事件
bool bq_notify_buffer_warning(uint8 type, uint32 count);

#endif


#endif  //BQUEUES_H_INCLUDED


