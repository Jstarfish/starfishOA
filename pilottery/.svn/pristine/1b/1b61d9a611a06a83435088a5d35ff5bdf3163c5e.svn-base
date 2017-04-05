#ifndef NCPC_INF_H_INCLUDED
#define NCPC_INF_H_INCLUDED



//内存NCP记录类型
typedef struct _NCP_RECORD
{
    bool    used;
    int32   index;
    uint32  ncpCode;
    char    name[64];
    uint8   type;       //0: terminal ncp  1:ap ncp  2:oms
    char    ipAddr[16];
    bool    connect;
    uint32  connectNum; //terminal connect number, AP connect number
    uint64  sendPkgNum;
    uint64  recvPkgNum;
    uint64  abnormalPkgNum;
}NCP_RECORD;

//内存NCPC数据库
typedef struct _NCPC_DATABASE
{
    NCP_RECORD  ncpArray[MAX_NCP_NUMBER];
}NCPC_DATABASE;

typedef NCPC_DATABASE *NCPC_DATABASE_PTR;


//创建共享内存
bool ncpc_create();

//删除共享内存
bool ncpc_destroy();

//映射共享内存区
bool ncpc_init();

//关闭共享内存区的映射
bool ncpc_close();


//for view
NCPC_DATABASE_PTR ncpc_getDatabasePtr();


//-------------------------------------------------------
// NCPC 接口

NCP_RECORD *ncpc_getNcpRecord(int32 idx);

//增加ncp
//成功 返回编号 失败 返回-1(或者错误标号)
int32 ncpc_addNcpRecord(NCP_RECORD *pNcpRec);

//根据TCP连接的NCP的IP地址校验身份
//返回 -1 校验失败 否则返回 数组编号
int32 ncpc_verifyTcpNcp(uint32 ipaddr);
//根据HTTP连接的NCP的IP地址校验身份
//返回 -1 校验失败 否则返回 数组编号
int32 ncpc_verifyHttpNcp(uint32 ipaddr);

//ncp的连接状态
void ncpc_setConnectStatus(int32 idx, bool connect);
bool ncpc_getConnectionStatus(int32 idx);

//得到ncp类型
uint8 ncpc_getType(int32 idx);

//更新ncp连接的(终端/AP)数目
void ncpc_updConnectedNumber(int32 idx, uint32 termcnt);

//更新ncp发送的报文数目
void ncpc_updSendPkgNumber(int32 idx);

//更新ncp接收的报文数目
void ncpc_updRecvPkgNumber(int32 idx);

//更新ncp处理的异常报文数目
void ncpc_updAbnormalPkgNumber(int32 idx);

void ncp_connect_set_false();

#endif

