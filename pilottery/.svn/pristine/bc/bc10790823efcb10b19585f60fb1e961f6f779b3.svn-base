#include "global.h"
#include "ncpcmod.h"

//NCPC共享内存的文件描述符
static int32 nGlobalMem = 0;
//指向NCPC数据的指针
static int8 *pGlobalMem = NULL;
//NCPC database占用字节大小
static int32 nGlobalLen = 0;

static NCPC_DATABASE_PTR ncpc_database_ptr = NULL;

//创建共享内存
bool ncpc_create()
{
    int32 ret = -1;
    IPCKEY keyid;

    nGlobalLen = sizeof(NCPC_DATABASE);

    //创建keyid
    keyid = ipcs_shmkey(NCPC_SHM_KEY);

    //创建共享内存
    nGlobalMem = sysv_get_shm(keyid, nGlobalLen, IPC_CREAT|IPC_EXCL|0644);
    if (-1 == nGlobalMem)
    {
        ncpc_destroy();
        nGlobalMem = sysv_get_shm(keyid, nGlobalLen, IPC_CREAT|IPC_EXCL|0644);
        if (-1 == nGlobalMem)
        {
            log_fatal("ncpc_create::create globalSection failure key[%d].\n" , NCPC_SHM_KEY);
            return false;
        }
    }

    //内存映射
    pGlobalMem = (int8 *)sysv_attach_shm(nGlobalMem, 0, 0);
    if ((int8 *)-1 == pGlobalMem)
    {
        log_fatal("ncpc_create::attach globalSection failure.\n");
        return false;
    }

    //初始化共享内存
    memset(pGlobalMem, 0, nGlobalLen);

    ncpc_database_ptr = (NCPC_DATABASE *)pGlobalMem;

    //加载ncp列表
    ret = ncpc_loadConf(NCPC_CONFIG_FILE);
    if (ret < 0)
    {
        log_fatal("ncpc_loadConf failure.\n");
        return false;
    }


    //断开与共享内存的映射
    ret = sysv_detach_shm(pGlobalMem);
    if (ret < 0)
    {
        log_fatal("ncpc_create:deattach globalSection failure.\n");
        return false;
    }

    log_info("ncpc_create success! shm_key[%#x] shm_id[%d] size[%d]", keyid, nGlobalMem, nGlobalLen);
    return true;
}

//删除共享内存
bool ncpc_destroy()
{
    int32 ret = -1;

    //如果创建共享内存和删除共享内存在不同的任务中，需要下面这段程序
    IPCKEY keyid;

    keyid = ipcs_shmkey(NCPC_SHM_KEY);

    nGlobalMem = sysv_get_shm(keyid, 0, 0);
    //nGlobalMem = sysv_get_shm(keyid, nGlobalLen, IPC_CREAT|0644);
    if (-1 == nGlobalMem)
    {
        log_error("ncpc_destroy::open globalSection failure.\n");
        return false;
    }

    //删除共享内存
    ret = sysv_ctl_shm(nGlobalMem, IPC_RMID, NULL);
    if (ret < 0)
    {
        log_error("ncpc_destroy:delete globalSection failure.\n");
        return false;
    }

    log_info("ncpc_destroy::success ");
    return true;
}

//映射共享内存区
bool ncpc_init()
{
    IPCKEY keyid;

    keyid = ipcs_shmkey(NCPC_SHM_KEY);

    nGlobalMem = sysv_get_shm(keyid, 0, 0);
    //nGlobalMem = sysv_get_shm(keyid, nGlobalLen, IPC_CREAT|0644);
    if (-1 == nGlobalMem)
    {
        log_error("ncpc_init::open globalSection(ncpc) failure.\n");
        return false;
    }

    pGlobalMem = (int8 *)sysv_attach_shm(nGlobalMem,0,0);
    if ((int8 *)-1 == pGlobalMem)
    {
        log_error("ncpc_init::attach globalSection(ncpc) failure.\n");
        return false;
    }

    //初始化数据库结构指针
    ncpc_database_ptr = (NCPC_DATABASE *)pGlobalMem;

    return true;
}

//关闭共享内存区的映射
bool ncpc_close()
{
    int32 ret = -1;

    if (NULL == pGlobalMem)
    {
        log_error("ncpc_close::globalSection(ncpc) pointer is NULL;\n");
        return false;
    }

    //断开与共享内存的映射
    ret = sysv_detach_shm(pGlobalMem);
    if (ret < 0)
    {
        log_error("ncpc_close:deattach globalSection(ncpc) failure.\n");
        return false;
    }

    nGlobalMem = 0;
    pGlobalMem = NULL;
    ncpc_database_ptr = NULL;
    return true;
}

//for tsview
NCPC_DATABASE_PTR ncpc_getDatabasePtr()
{
    return ncpc_database_ptr;
}


int ncpc_loadConf(const char *xmlFileName)
{
    NCP_RECORD ncp_rec;

    //加载配置文件
    log_debug("Begin load [%s]", xmlFileName);

    XML xmlFile(xmlFileName);
    XMLElement *elemRoot = xmlFile.GetRootElement();
    if (NULL == elemRoot) {
        log_error("ncpc_loadConf : GetRootElement failure");
        return -1;
    }

    for (uint32 i = 0; i < elemRoot->GetChildrenNum(); i++) {
        XMLElement *elem = elemRoot->GetChildren()[i];
        memset(&ncp_rec, 0, sizeof(NCP_RECORD));
        ncp_rec.ncpCode = i + 1;
        XMLElement *elemLeaf = elem->FindElementZ("ipaddr");
        if (NULL == elemLeaf) {
            log_error("ncpc_loadConf : FindElementZ[%s] is null!", "ipaddr");
            return -1;
        }
        XMLContent *ct = elemLeaf->GetContents()[0];
        if (NULL == ct) {
            log_error("ncpc_loadConf : GetContents[%s] failure!", "ipaddr");
            return -1;
        }
        ct->GetValue(ncp_rec.ipAddr);

        elemLeaf = elem->FindElementZ("name");
        if (NULL == elemLeaf) {
            log_error("ncpc_loadConf : FindElementZ[%s] is null!", "name");
            return -1;
        }
        ct = elemLeaf->GetContents()[0];
        if (NULL == ct) {
            log_error("ncpc_loadConf : GetContents[%s] failure!", "name");
            return -1;
        }
        ct->GetValue(ncp_rec.name);
        char str[128];
        elemLeaf = elem->FindElementZ("type");
        if (NULL == elemLeaf) {
            log_error("ncpc_loadConf : FindElementZ[%s] is null!", "type");
            return -1;
        }
        ct = elemLeaf->GetContents()[0];
        if (NULL == ct) {
            log_error("ncpc_loadConf : GetContents[%s] failure!", "type");
            return -1;
        }
        ct->GetValue(str);
        ncp_rec.type = atoi(str);

        ncpc_addNcpRecord(&ncp_rec);
    }
    return 0;
}

void ncp_connect_set_false()
{
	for (int i = 0; i < MAX_NCP_NUMBER; i++) {
		ncpc_database_ptr->ncpArray[i].connect = false;
		ncpc_database_ptr->ncpArray[i].connectNum = 0;
	}
}

NCP_RECORD *ncpc_getNcpRecord(int32 idx)
{
    NCP_RECORD *pNcpRec = NULL;
    if (idx < 0)
        return NULL;
    pNcpRec = &ncpc_database_ptr->ncpArray[idx];
    if (pNcpRec->used) {
        return pNcpRec;
    }
    return NULL;
}

//增加ncp
//成功 返回编号 失败 返回-1(或者错误标号)
int32 ncpc_addNcpRecord(NCP_RECORD *pNcpRec)
{
    NCP_RECORD *pNR = NULL;
    int32 i = 0;
    for (i = 0; i < MAX_NCP_NUMBER; i++) {
        pNR = &ncpc_database_ptr->ncpArray[i];
        if (!pNR->used) {
            pNR->used = true;
            pNR->ncpCode = pNcpRec->ncpCode;
            strcpy(pNR->name, pNcpRec->name);
            pNR->type = pNcpRec->type;
            strcpy(pNR->ipAddr, pNcpRec->ipAddr);
            pNR->connect = false;
            pNR->connectNum = 0;
            pNR->sendPkgNum = 0;
            pNR->recvPkgNum = 0;
            pNR->abnormalPkgNum = 0;

            log_info("Add ncp code[%u] name[%s] type[%hhu] ip[%s]",
                     pNR->ncpCode, pNR->name, pNR->type, pNR->ipAddr);
            return 0;
        }
    }
    log_error("ncpc_addNcpRecord false. ncpCode[%d]", pNcpRec->ncpCode);
    return -1;
}

//根据TCP连接的NCP的IP地址校验身份
//返回 -1 校验失败 否则返回 数组编号
int32 ncpc_verifyTcpNcp(uint32 ipaddr)
{
    NCP_RECORD *pNcpRec = NULL;
    for (int i = 0; i < MAX_NCP_NUMBER; i++) {
        pNcpRec = &ncpc_database_ptr->ncpArray[i];
        if (pNcpRec->used && int_ipaddr(pNcpRec->ipAddr)==ipaddr && pNcpRec->type==0) {
            //success
            return i;
        }
    }
    //校验失败
    return -1;
}

//根据HTTP连接的NCP的IP地址校验身份
//返回 -1 校验失败 否则返回 数组编号
int32 ncpc_verifyHttpNcp(uint32 ipaddr)
{
    NCP_RECORD *pNcpRec = NULL;
    for (int i = 0; i < MAX_NCP_NUMBER; i++) {
        pNcpRec = &ncpc_database_ptr->ncpArray[i];
        if (pNcpRec->used && int_ipaddr(pNcpRec->ipAddr)==ipaddr && pNcpRec->type==1) {
            //success
            return i;
        }
    }
    //校验失败
    return -1;
}

//更新ncp的连接状态
void ncpc_setConnectStatus(int32 idx, bool connect)
{
    NCP_RECORD *pNcpRec = NULL;
    pNcpRec = &ncpc_database_ptr->ncpArray[idx];
    pNcpRec->connect = connect;

    ncpc_notify_link(pNcpRec);
    return;
}

bool ncpc_getConnectionStatus(int32 idx)
{
    return ncpc_database_ptr->ncpArray[idx].connect;
}

uint8 ncpc_getType(int32 idx)
{
    return ncpc_database_ptr->ncpArray[idx].type;
}


//更新ncp连接的终端数目
void ncpc_updConnectedNumber(int32 idx, uint32 termcnt)
{
    ncpc_database_ptr->ncpArray[idx].connectNum = termcnt;
}

//更新ncp发送的报文数目
void ncpc_updSendPkgNumber(int32 idx)
{
    ncpc_database_ptr->ncpArray[idx].sendPkgNum++;
}

//更新ncp接收的报文数目
void ncpc_updRecvPkgNumber(int32 idx)
{
    ncpc_database_ptr->ncpArray[idx].recvPkgNum++;
}

//更新ncp处理的异常报文数目
void ncpc_updAbnormalPkgNumber(int32 idx)
{
    NCP_RECORD *pNcpRec = NULL;
    pNcpRec = &ncpc_database_ptr->ncpArray[idx];

    pNcpRec->abnormalPkgNum++;
    return;
}


//-------------NOTIFY INTERFACE--------------------

int32 ncpc_notify_link(NCP_RECORD *pNcpRec)
{
    GLTP_MSG_NTF_NCP_LINK notify;
    memset(&notify , 0, sizeof(GLTP_MSG_NTF_NCP_LINK));

    notify.ncpCode = pNcpRec->ncpCode;
    notify.type = pNcpRec->type;
    strcpy(notify.ipaddr, pNcpRec->ipAddr);
    notify.connect = pNcpRec->connect;

    sys_notify(GLTP_NTF_NCP_LINK_STATUS, _WARN, (char*)&notify, sizeof(GLTP_MSG_NTF_NCP_LINK));
    return 0;
}

cJSON *cJSON_Get(cJSON *object, const char *string, int dt)
{
	cJSON *item = cJSON_GetObjectItem(object, string);
	if (item == NULL || item->type != dt) {
		log_error("Json Message field [ %s ] parse error.", string);
		return NULL;
	}
	return item;
}

