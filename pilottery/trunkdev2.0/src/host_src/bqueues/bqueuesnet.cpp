#include "global.h"
#include "bq_inf.h"
#include "bqueues.h"
#include "bqueuesnet.h"


//MESSAGE在被传输到网络时，添加4个字节的 PDU界定符 和 报文长度
#define TCP_STREAM_FLAG         0xf364  /* 基于Stream传输方式PDU的界定符，在线路上为|0xf3|0x64| */

#define STREAM_RECVBUF_SIZE     0x2200  /* Size of receiving buffer for TCP channel */

#define STREAM_SENDBUF_SIZE     0x0800  /* Size of receiving buffer for TCP channel */

#define SOCKET_RETRY_TIMES      3       /* max retry times */
#define SOCKET_RETRY_INTERVAL   5     /* 5 seconds retry connect interval*/

#pragma pack (1)

typedef struct _BQ_NET_HEADER
{
    uint16      streamflag;     // Stream方式通道必须的PDU分隔符
    BQ_HEADER   streamheader;
    uint16      streamlen;
}BQ_NET_HEADER;
#define TCP_STREAM_HEAD_SIZE    sizeof(BQ_NET_HEADER)
#pragma pack ()

extern bool bExit;

int j = 0 ;
//net route table array
typedef struct _BQ_NET_SOCKET_TABLE
{
    BQ_NET_SOCKET_RECORD       bqNetSocketArray[BQ_MAX_NET_TASK_NUM];
}BQ_NET_SOCKET_TABLE;

BQ_NET_SOCKET_TABLE bqnetSocketTable;

//bq net网络收发线程初始化
bool bq_net_init()
{
    int32 i =0;
    int32 ret = 0;

    BQ_NET_ROUTE_TABLE *pNetRouteTable = null;
    BQ_NET_ROUTE_ENTRY *pNetRouteEntry = null;
    BQ_NET_SOCKET_RECORD *pNetSocketRecord = null;
    //初始化网络连接数组
    memset( (void*)&bqnetSocketTable, 0, sizeof(BQ_NET_SOCKET_TABLE) );
    
    pNetRouteTable = getNetRouteTable();
    for (i=0;i<BQ_MAX_NET_TASK_NUM;i++)
    {
        pNetRouteEntry = &pNetRouteTable->netRouteTable[i];
        pNetSocketRecord = & (bqnetSocketTable.bqNetSocketArray[i]);
       
        if ( !pNetRouteEntry->used )
            continue;
        
        pNetSocketRecord->used = true;
        pNetSocketRecord->socket = 0;
        pNetSocketRecord->netstatus = false;
        pNetSocketRecord->netId = i;
        pNetSocketRecord->netfid = pNetRouteEntry->netfid;
    }

    
    //创建Socket数据收发线程任务
    for (i=0;i<BQ_MAX_NET_TASK_NUM;i++)
    {
       
        pNetSocketRecord = & (bqnetSocketTable.bqNetSocketArray[i]);
        if ( !pNetSocketRecord->used )
            continue;
        
        //创建Socket发送线程
        ret = pthread_create(& pNetSocketRecord->sendThread, NULL , bq_net_send_thread, &pNetSocketRecord->netId);
        if(ret!=0)
        {
            log_fatal("bq_net_init::create bq_net_send_thread failure! netIndex[%d]", i);
            return false;
        }

        //创建Socket接收线程
        ret = pthread_create(&bqnetSocketTable.bqNetSocketArray[i].recvThread, NULL , bq_net_recv_thread, &pNetSocketRecord->netId);
        if(ret!=0)
        {
            log_fatal("bq_net_init::create bq_net_recv_thread failure! netIndex[%d]", i);
            return false;
        }
        
    }
    return true;
}

//bq net 关闭
bool bq_net_close()
{
    int32 i =0;
    BQ_NET_SOCKET_RECORD *pNetSocketRecord = null;
    bExit = true;

    //关闭所有Socket
    for (i=0;i<BQ_MAX_NET_TASK_NUM;i++)
    {   
        pNetSocketRecord = & (bqnetSocketTable.bqNetSocketArray[i]);
        if ( !pNetSocketRecord->used )
            continue;

        if ( pNetSocketRecord->netstatus)
        {
            close_socket(pNetSocketRecord->socket);
            bq_net_disconnect(pNetSocketRecord->netId, BQ_DISCONN_REASON_MANUAL);
        }
    }

    //唤醒接收Socket数据线程退出  发送bq_recv退出消息，使Socket发送数据线程退出
    for (i=0;i<MAX_NCP_NUMBER;i++)
    {
        if ( !bqnetSocketTable.bqNetSocketArray[i].used )
            continue;
    }

    ts_sleep(1,1);

    //等待所有的线程退出
    for (i=0;i<MAX_NCP_NUMBER;i++)
    {
        pthread_join(bqnetSocketTable.bqNetSocketArray[i].recvThread, NULL);
        pthread_join(bqnetSocketTable.bqNetSocketArray[i].sendThread, NULL);
    }

    return true;
}


void bq_net_connect(int32 netindex, SOCKET socket)
{
    TIME_TYPE time;

    bqnetSocketTable.bqNetSocketArray[netindex].socket = socket;
    bqnetSocketTable.bqNetSocketArray[netindex].netstatus = true;

    get_when_ex(&time);
    bq_netConnect( netindex, time );
}

void bq_net_disconnect(int32 netindex, BQ_DISCONN_REASON reason)
{
    TIME_TYPE time;

    bqnetSocketTable.bqNetSocketArray[netindex].socket = 0;
    bqnetSocketTable.bqNetSocketArray[netindex].netstatus = false;

    get_when_ex(&time);
    bq_netDisConnect( netindex, time, reason );
    log_error("bq_net_disconnect::socket disconnect! netIndex[%d]", netindex);
}

bool bq_net_send_heartbeat(int32 netIndex)
{
    char buff[128] = {0};
    int32 iSentLen = 0;
    BQ_NET_ROUTE_TABLE *pNetRouteTable = null;
    BQ_NET_ROUTE_ENTRY *pNetRouteEntry = null;
    BQ_NET_SOCKET_RECORD *pNetSocketRecord = null;

    pNetRouteTable = getNetRouteTable();
    pNetRouteEntry = &pNetRouteTable->netRouteTable[netIndex];
    pNetSocketRecord = &bqnetSocketTable.bqNetSocketArray[netIndex];

    BQ_NET_HEADER *pNetHeader = (BQ_NET_HEADER *)buff;
    BQ_MSG_HB *pMsgHB = (BQ_MSG_HB *)((char *)buff + sizeof(BQ_NET_HEADER));
    

    //得到任务的fid
    FID fidCtrl = 0;
    fidCtrl = getFidByName(BQ_CTRL_PROC);
    if (fidCtrl<0)
    {
        log_error("bq_net_send_heartbeat::getFidByName return error!");
        return false;
    }

    *((uint16*)buff) = htons(TCP_STREAM_FLAG);
    pNetHeader->streamheader.host = fidCtrl;
    pNetHeader->streamheader.sender = fidCtrl;
    pNetHeader->streamheader.code = BQ_CTRL_CODE_HB;
    pNetHeader->streamlen = sizeof(BQ_MSG_HB);
    pMsgHB->code = BQ_CTRL_CODE_HB;
    pMsgHB->netId = netIndex;

    if ( pNetSocketRecord->netstatus )
    {
        iSentLen = tcp_send(pNetSocketRecord->socket, buff, TCP_STREAM_HEAD_SIZE+sizeof(BQ_MSG_HB));
        if( iSentLen >0 )
        {
            pNetRouteEntry->sndPkgNum++;
           

        }
        else
        {
            //链路断开
           
            close_socket(pNetSocketRecord->socket);
            bq_net_disconnect(netIndex, BQ_DISCONN_REASON_RS);
        }
    }
    return true;
}

void bq_net_verify_heartbeat()
{
    BQ_NET_ROUTE_TABLE *pNetRouteTable = null;
    BQ_NET_ROUTE_ENTRY *pNetRouteEntry = null;
    BQ_NET_SOCKET_RECORD *pNetSocketRecord = null;
    int i =0;
    pNetRouteTable = getNetRouteTable();

    for (i=0;i<MAX_NCP_NUMBER;i++)
    {
        pNetRouteEntry = &pNetRouteTable->netRouteTable[i];
        pNetSocketRecord = &bqnetSocketTable.bqNetSocketArray[i];

        if (!pNetRouteEntry->used)
            continue;

        if( pNetSocketRecord->netstatus )
        {
            if( pNetRouteEntry->failureHB>=BQ_MAX_HB_FAILURE_COUNT )
            {
                //链路断开
                close_socket(pNetSocketRecord->socket);
                bq_net_disconnect(pNetSocketRecord->netId, BQ_DISCONN_REASON_HB);
            }
            else
            {
                //发送心跳数据
                if ( !bq_net_send_heartbeat(i) )
                {
                    log_error("bq_net_verify_heartbeat::bq_net_send_heartbeat return error! netIndex[%d]", i);
                }
                else
                {
                    pNetRouteEntry->failureHB++;
                }
            }
        }
    }
}


bool recvData(int32 netIndex, char *buf, int32 &offset)
{
    BQ_NET_ROUTE_TABLE *pNetRouteTable = null;
    BQ_NET_ROUTE_ENTRY *pNetRouteEntry = null;
    BQ_NET_SOCKET_RECORD *pNetSocketRecord = null;
    BQ_NET_HEADER *pNetHeader = null;
    
    int32 i;
    int32 s_offset = 0;
    int32 iRecvLen,iOffset, iPduLength;
    int32 ret = 0;

    pNetRouteTable = getNetRouteTable();
    pNetRouteEntry = &pNetRouteTable->netRouteTable[netIndex];
    pNetSocketRecord = &bqnetSocketTable.bqNetSocketArray[netIndex];

    s_offset = offset;

    // 如果是TCP通道，则需要用接收缓冲区来接收数据，完成消息的拼装和解析
    
    iRecvLen = tcp_recv( pNetSocketRecord->socket, buf+s_offset, STREAM_RECVBUF_SIZE-s_offset );

    if( iRecvLen >0 )
        s_offset += iRecvLen;
    else
    {
        return false;
    }
    iOffset =0;
    while(true)
    {
        // 若线路上不存在传输错误，接收缓冲区中的头2个Byte应该是界定符0xF364；
        // 如果不是的话，就需要在接收缓冲区中向后寻找界定符，只到接收到的数据的尾部
        while( *((unsigned short*)(buf+iOffset)) !=htons((TCP_STREAM_FLAG)) )
        {
             
            if( iOffset >= (s_offset-1) )
            {
                break;
            }
            iOffset++;
            
        }
        // 如果接收缓冲区中的数据量 < Stream标志头的长度，可以将剩余的数据搬移到
        // 接收缓冲区的头部，然后退出
        if( (s_offset-iOffset) <= (int32)TCP_STREAM_HEAD_SIZE )
        {
            if( iOffset>0 )
            {
                for(i=0;i<(s_offset-iOffset);i++)
                {
                    buf[i] = buf[iOffset +i];
                }
                s_offset -= iOffset;
            }
            return true;
        }
        else
        {
            pNetHeader = (BQ_NET_HEADER *)(buf+iOffset);
            iPduLength = pNetHeader->streamlen;

            // 如果接收缓冲区中的数据量 < Pdu的长度
            // 可以将剩余的数据搬移到接收缓冲区的头部，然后退出
            if( (s_offset-iOffset) < iPduLength )
            {
                if(iOffset >0)
                {
                    for(i=0;i<(s_offset-iOffset);i++)
                    {
                        buf[i] = buf[iOffset +i];
                    }
                    s_offset -= iOffset;

                    offset = s_offset;
                }
            
                return true;
            }
            else
            {
                // 如果接收缓冲区中的数据量 >= Pdu的长度
                // 就可以申请消息数据块来处理了
                pNetHeader = (BQ_NET_HEADER *)(buf+iOffset);
                ret = bq_sendA( &pNetHeader->streamheader,
                                ( buf+iOffset+TCP_STREAM_HEAD_SIZE ), pNetHeader->streamlen);
                if ( ret <= 0 )
                {
                    return false;
                }
                else
                {   
                    iOffset += sizeof(BQ_NET_HEADER)+iPduLength;
                    pNetRouteEntry->rcvPkgNum++;
                }
            }
        }
    }

}


//从Socket接收数据线程,发往BQUEUES
void *bq_net_recv_thread(void *arg)
{
    int32 netIndex = -1;
    BQ_NET_ROUTE_TABLE *pNetRouteTable = null;
    BQ_NET_ROUTE_ENTRY *pNetRouteEntry = null;

    //从socket接收数据的缓冲区
    char  s_chRecvBuf[STREAM_RECVBUF_SIZE];
    int32 s_iOffset;

    SOCKET sockId, clientSocket;
    NETADDR peerAddr;       // accept client ip address

   netIndex = *(uint8 *)arg;
    if( (netIndex<0)||(netIndex>=BQ_MAX_NET_TASK_NUM) )
    {
        log_fatal("bq_net_recv_thread::parameter Except! netIndex[%d]", netIndex);
        return false;
    }
    pNetRouteTable = getNetRouteTable();
    pNetRouteEntry = &pNetRouteTable->netRouteTable[netIndex];

    memset(s_chRecvBuf, 0, STREAM_RECVBUF_SIZE);
    s_iOffset = 0;

    switch( pNetRouteEntry->protocol )
    {
        case BQ_PROTOCOL_TCP_CLIENT :
        {
            while(true)
            {
                if( (clientSocket =open_socket(SOCKET_TCP)) == false )
                {
                    log_fatal("bq_net_recv_thread::open socket error! netIndex[%d]", netIndex);
                    break;
                }
                if( connect_socket( clientSocket, pNetRouteEntry->ipAddrSec_str, pNetRouteEntry->port) == false )
                {
                    close_socket( clientSocket );
                    bq_net_disconnect(netIndex, BQ_DISCONN_REASON_CONN);
                    pNetRouteEntry->retryConnect++;
                    ts_sleep(SOCKET_RETRY_INTERVAL,1);
                    continue;
                }
                bq_net_connect(netIndex, clientSocket);

                while(true)
                {
                    if( recvData( netIndex, s_chRecvBuf, s_iOffset ) == false )
                    {
                        memset(s_chRecvBuf , 0 , STREAM_RECVBUF_SIZE);
                        s_iOffset = 0 ;
                        close_socket( clientSocket );
                        bq_net_disconnect(netIndex, BQ_DISCONN_REASON_RS);
                        log_error("bq_net_recv_thread::recvData return error! netIndex[%d]", netIndex);
                        break;
                    }
                    
                }
               
            }
            break;
        }

        case BQ_PROTOCOL_TCP_SERVER :
        {
            if( ( sockId = open_socket(SOCKET_TCP) ) == false )
            {
                log_fatal("bq_net_recv_thread::open socket error! netIndex[%d]", netIndex);
                break;
            }
             bool  bReuseaddr=true;
             setsockopt(sockId,SOL_SOCKET ,SO_REUSEADDR,(const char*)&bReuseaddr,sizeof(int32));
        
            if( bind_socket(sockId, NULL, pNetRouteEntry->port) == false )
            {
                log_fatal("bq_net_recv_thread::bind socket error! netIndex[%d]", netIndex);
                break;
            }
            if( listen_socket(sockId) == false )
            {
                log_fatal("bq_net_recv_thread::listen socket return error! netIndex[%d]", netIndex);
                break;
            }
            while(true)
            {
                memset((char *)&peerAddr, 0, sizeof(NETADDR));
                clientSocket = accept_socket(sockId, &peerAddr);
                if( clientSocket == ERROR )
                {
                    log_fatal("bq_net_recv_thread::accept socket return error! netIndex[%d]", netIndex);
                    break;
                }

                /*
                可以在此校验IP地址的合法性，是否是配置的
                */

                bq_net_connect(netIndex, clientSocket);

                while(true)
                {
                    if( recvData( netIndex, s_chRecvBuf, s_iOffset ) == false )
                    {
                        memset(s_chRecvBuf , 0 , STREAM_RECVBUF_SIZE);
                        s_iOffset = 0 ;
                        close_socket( clientSocket );
                        bq_net_disconnect(netIndex, BQ_DISCONN_REASON_RS);
                        break;
                    }
                    
                }
            }
            close_socket( sockId );
            break;
        }
        default :
        {
            log_fatal("bq_net_recv_thread::Unknow mode error! netIndex[%d]", netIndex);
            break;
        }
    }

     return null;
}


//从BQUEUES接收数据, 向Socket发送数据线程
void *bq_net_send_thread(void *arg)
{
    int32 netIndex = -1;
    BQ_NET_ROUTE_TABLE *pNetRouteTable = null;
    BQ_NET_ROUTE_ENTRY *pNetRouteEntry = null;
    BQ_NET_SOCKET_RECORD *pNetSocketRecord = null;

    //从bqueues接收数据的缓冲区
    char s_chSendBuf[STREAM_SENDBUF_SIZE]={0};
    char fidname[BQ_TASK_NAME_LENGTH] = {0};
    BQ_HEADER header;
    int32 iSentLen = 0;
    BQ_NET_HEADER *pNetHeader = null;
    int32 len = 0;
    netIndex = *(uint8 *)arg;

    if( (netIndex<0)||(netIndex>=BQ_MAX_NET_TASK_NUM) )
    {
        log_fatal("bq_net_send_thread::parameter Except! netIndex[%d]", netIndex);
        return null;
    }
    
    pNetRouteTable = getNetRouteTable();
    pNetRouteEntry = &pNetRouteTable->netRouteTable[netIndex];
    pNetSocketRecord = &bqnetSocketTable.bqNetSocketArray[netIndex];
    sprintf(fidname, "%s%d", BQ_NET_PROC, netIndex);
     
    if ( !bq_register(pNetRouteEntry->netfid, fidname, getpid() ) )
    {
        log_fatal("bq_net_send_thread::bq_register return error! netIndex[%d]", netIndex);
        return null;
    }   

    while(!bExit)
    {   
        memset(s_chSendBuf, 0, STREAM_SENDBUF_SIZE);
        len = bq_recvA(pNetRouteEntry->netfid, &header, s_chSendBuf+TCP_STREAM_HEAD_SIZE, STREAM_SENDBUF_SIZE, 500);
        if( len < 0 )
        {
            //BQueues出错退出
            log_fatal("bq_net_send_thread::bq_recvA return error! netIndex[%d]", netIndex);
            break;
        }
        else if (len == 0)
        {
            //receive timeout
            continue;
        }

        //input net header info
        pNetHeader = (BQ_NET_HEADER *)s_chSendBuf;
        *((uint16*)s_chSendBuf) = htons(TCP_STREAM_FLAG);
        pNetHeader->streamheader = header;
        pNetHeader->streamlen = len;

        if ( pNetSocketRecord->netstatus )
        {
            iSentLen = tcp_send(pNetSocketRecord->socket, s_chSendBuf, len+TCP_STREAM_HEAD_SIZE);
            if( iSentLen >0 )
            {
                pNetRouteEntry->sndPkgNum++;
            }
            else
            {
                //链路断开 ,消息回到bq
                bq_sendA(&header , s_chSendBuf + TCP_STREAM_HEAD_SIZE , len);
                close_socket(pNetSocketRecord->socket);
                bq_net_disconnect(netIndex, BQ_DISCONN_REASON_RS);
            }
        }
        else
        {
            //网络没有连接
            bq_sendA(&header , s_chSendBuf + TCP_STREAM_HEAD_SIZE , len);
            log_error("bq_net_send_thread::network is disconnect. netIndex[%d]", netIndex);
        }
    }

    if ( !bq_unregister( pNetRouteEntry->netfid) )
    {
        log_fatal("bq_net_send_thread::bq_unregister return error! netIndex[%d]", netIndex);
        return null;
    }

     return null;
}

   
