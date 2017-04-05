#include "global.h"
#include "gl_inf.h"

#include "gl_koc7lx_db.h"
#include "gl_koc7lx_verify.h"

#define GL_KOC7LX_SHM_KEY      (GL_SHM_KEY + GAME_KOC7LX)

static GL_PLUGIN_INFO koc7lx_plugin_info = {0, NULL, NULL, NULL, NULL, NULL, NULL};
static void *koc7lx_plugin_info_ptr = NULL;


bool gl_koc7lx_mem_creat(int issue_count)
{
    int32 ret;
    IPCKEY keyid;

    int ncGlobalLen = sizeof(int) +
                      sizeof(SUBTYPE_PARAM) * MAX_SUBTYPE_COUNT +
                      sizeof(DIVISION_PARAM) * MAX_DIVISION_COUNT +
                      sizeof(ISSUE_INFO) * issue_count +
                      sizeof(PRIZE_PARAM) * issue_count * MAX_PRIZE_COUNT +
                      sizeof(POOL_PARAM);

    //获得KOC7LX共享内存键
    keyid = ipcs_shmkey(GL_KOC7LX_SHM_KEY);
    if (IPC_FAILURE == keyid)
    {
        log_error("koc7lx:creat:ipcs_shmkey failure");
        return false;
    }

    //创建KOC7LX共享内存
    int ncGlobalMem = sysv_get_shm(keyid, ncGlobalLen, IPC_CREAT|IPC_EXCL|0644);
    if (-1 == ncGlobalMem)
    {
        log_error("koc7lx:creat:sysv_get_shm failure");
        return false;
    }

    //获得KOC7LX共享内存指针
    void *pcGlobalMem = sysv_attach_shm(ncGlobalMem, 0, 0);
    if ((void *)-1 == pcGlobalMem)
    {
        log_error("koc7lx:creat:sys_attach_shm failure");
        return false;
    }

    //共享内存清零
    memset(pcGlobalMem, 0, ncGlobalLen);

    //将期次个数放入共享内存区前四个字节中
    *(int *)pcGlobalMem = issue_count;

    //共享内存创建并初始化后即可断开与其的连接
    ret = sysv_detach_shm(pcGlobalMem);
    if (0 > ret)
    {
        log_error("koc7lx:creat:sysv_detach_shm failure");
        return false;
    }

    //打印日志
    log_info("gl_koc7lx_mem_creat success! shm_key[%#x] shm_id[%d] size[%d]",
             keyid, ncGlobalMem, ncGlobalLen);
    return true;
}

bool gl_koc7lx_mem_destroy(void)
{
    int32 ret;
    IPCKEY keyid;

    //获得KOC7LX共享内存键
    keyid = ipcs_shmkey(GL_KOC7LX_SHM_KEY);
    if (IPC_FAILURE == keyid)
    {
        log_error("koc7lx:destroy:ipcs_shmkey failure");
        return false;
    }

    //获得KOC7LX共享内存描述符
    int ncGlobalMem = sysv_get_shm(keyid, 0, 0);
    if (-1 == ncGlobalMem)
    {
        log_error("koc7lx:destroy:sysv_get_shm failure");
        return false;
    }

    //删除共享内存
    ret = sysv_ctl_shm(ncGlobalMem, IPC_RMID, NULL);
    if (0 > ret)
    {
        log_error("koc7lx:destroy:sysv_ctl_shm failure");
        return false;
    }

    //打印日志
    log_info("gl_koc7lx_mem_destroy success!");
    return true;
}

bool gl_koc7lx_mem_attach(void)
{
    IPCKEY keyid;

    keyid = ipcs_shmkey(GL_KOC7LX_SHM_KEY);
    if (IPC_FAILURE == keyid)
    {
        log_error("koc7lx:attach:ipcs_shmkey failure");
        return false;
    }

    int ncGlobalMem = sysv_get_shm(keyid, 0, 0);
    if (-1 == ncGlobalMem)
    {
        log_error("koc7lx:attach:sysv_get_shm failure");
        return false;
    }

    koc7lx_plugin_info_ptr = sysv_attach_shm(ncGlobalMem, 0, 0);
    if ((void *)-1 == koc7lx_plugin_info_ptr)
    {
        log_error("koc7lx:attach:sysv_attach_shm failure");
        koc7lx_plugin_info_ptr = NULL;
        return false;
    }

    //用koc7lx_plugin_info里的各个指针指向KOC7LX共享内存中的各个区块
    koc7lx_plugin_info.issueCount = *(int *)koc7lx_plugin_info_ptr;
    
    koc7lx_plugin_info.subtype_info = (char *)koc7lx_plugin_info_ptr + sizeof(int);
    
    koc7lx_plugin_info.division_info = (char *)koc7lx_plugin_info.subtype_info +
                                    sizeof(SUBTYPE_PARAM) * MAX_SUBTYPE_COUNT;
    
    koc7lx_plugin_info.issue_info = (char *)koc7lx_plugin_info.division_info + 
                                 sizeof(DIVISION_PARAM) * MAX_DIVISION_COUNT;
    
    koc7lx_plugin_info.prize_info = (char *)koc7lx_plugin_info.issue_info + 
                                sizeof(ISSUE_INFO) * koc7lx_plugin_info.issueCount;
    
    koc7lx_plugin_info.pool_info = (char *)koc7lx_plugin_info.prize_info + 
             sizeof(PRIZE_PARAM) * koc7lx_plugin_info.issueCount * MAX_PRIZE_COUNT;
    
    koc7lx_plugin_info.rk_info = NULL;

    return true;
}

bool gl_koc7lx_mem_detach(void)
{
    int32 ret;

    if (NULL == koc7lx_plugin_info_ptr)
    {
        log_notice("koc7lx:detach pointer is NULL.");
        return true;
    }

    ret = sysv_detach_shm(koc7lx_plugin_info_ptr);
    if (0 > ret)
    {
        log_error("koc7lx:detach:sysv_detach_shm failure");
        return false;
    }

    koc7lx_plugin_info_ptr = NULL;

    return true;
}

void *gl_koc7lx_get_mem_db(void)
{
    return koc7lx_plugin_info_ptr;
}

PRIZE_PARAM *gl_koc7lx_getPrizeTableBegin(void)
{
    return (PRIZE_PARAM *) koc7lx_plugin_info.prize_info;
}

bool gl_koc7lx_load_memdata(void)
{
    //填充玩法信息，拷入共享内存
    SUBTYPE_PARAM *subParam = (SUBTYPE_PARAM *)gl_koc7lx_getSubtypeTable(NULL);

    SUBTYPE_PARAM subtype_param[MAX_SUBTYPE_COUNT] = {
        {false, 0, "", "", 0, 0, 0, 0, 0, 0, 0},
        {true, SUBTYPE_ZX, "ZX", "直选", 1<<BETTYPE_DS|1<<BETTYPE_FS|1<<BETTYPE_DT, 1, 1, 40, 6, 16, 1000},
        //{true, SUBTYPE_ZXHALF, "ZXHALF", "直选二分之一", 1<<BETTYPE_DS|1<<BETTYPE_FS|1<<BETTYPE_DT, 2, 1, 40, 6, 16, 1000},
    };
    memcpy(subParam, subtype_param, sizeof(subtype_param));

    //填充奖级信息，拷入共享内存
    DIVISION_PARAM *divParam = (DIVISION_PARAM *)gl_koc7lx_getDivisionTable(NULL,0);

    DIVISION_PARAM div_param[MAX_DIVISION_COUNT] = {
        {true, 0,  "6+0", PRIZE_1,  SUBTYPE_ZX, 6, 0},
        {true, 1,  "5+1", PRIZE_2,  SUBTYPE_ZX, 5, 1},
        {true, 2,  "5+0", PRIZE_3,  SUBTYPE_ZX, 5, 0},
        {true, 3,  "4+1", PRIZE_4,  SUBTYPE_ZX, 4, 1},
        {true, 4,  "4+0", PRIZE_5,  SUBTYPE_ZX, 4, 0},
        {true, 5,  "3+1", PRIZE_6,  SUBTYPE_ZX, 3, 1},
        {true, 6,  "3+0", PRIZE_7,  SUBTYPE_ZX, 3, 0},
        {true, 7,  "2+1", PRIZE_7,  SUBTYPE_ZX, 2, 1},
//        {true, 7,  "6+0", PRIZE_1H, SUBTYPE_ZXHALF, 6, 0},
//        {true, 8,  "5+1", PRIZE_2H, SUBTYPE_ZXHALF, 5, 1},
//        {true, 9,  "5+0", PRIZE_3H, SUBTYPE_ZXHALF, 5, 0},
//        {true, 10, "4+1", PRIZE_4H, SUBTYPE_ZXHALF, 4, 1},
//        {true, 11, "4+0", PRIZE_5H, SUBTYPE_ZXHALF, 4, 0},
//        {true, 12, "3+1", PRIZE_6H, SUBTYPE_ZXHALF, 3, 1},
//        {true, 13, "3+0", PRIZE_7H, SUBTYPE_ZXHALF, 3, 0},
    };
    memcpy(divParam, div_param, sizeof(div_param));

    //填充奖等信息，拷入共享内存
    PRIZE_PARAM prize_param[MAX_PRIZE_COUNT] = {
        {false, 0,        "",             false, ASSIGN_UNUSED, {0}},
        {true,  PRIZE_1,  "一等奖",        true,  ASSIGN_SHARED, {0}},
        {true,  PRIZE_2,  "二等奖",        true,  ASSIGN_FIXED,  {20000000}},
        {true,  PRIZE_3,  "三等奖",        false, ASSIGN_FIXED,  {2000000}},
        {true,  PRIZE_4,  "四等奖",        false, ASSIGN_FIXED,  {400000}},
        {true,  PRIZE_5,  "五等奖",        false, ASSIGN_FIXED,  {40000}},
        {true,  PRIZE_6,  "六等奖",        false, ASSIGN_FIXED,  {20000}},
        {true,  PRIZE_7,  "七等奖",        false, ASSIGN_FIXED,  {4000}},
//        {true,  PRIZE_1H, "二分之一一等奖", true,  ASSIGN_SHARED, {0}},
//        {true,  PRIZE_2H, "二分之一二等奖", true,  ASSIGN_FIXED,  {12000000}},
//        {true,  PRIZE_3H, "二分之一三等奖", false, ASSIGN_FIXED,  {1200000}},
//        {true,  PRIZE_4H, "二分之一四等奖", false, ASSIGN_FIXED,  {200000}},
//        {true,  PRIZE_5H, "二分之一五等奖", false, ASSIGN_FIXED,  {40000}},
//        {true,  PRIZE_6H, "二分之一六等奖", false, ASSIGN_FIXED,  {8000}},
//        {true,  PRIZE_7H, "二分之一七等奖", false, ASSIGN_FIXED,  {4000}},
    };

    PRIZE_PARAM *prizeTable = gl_koc7lx_getPrizeTableBegin();
    for (int i = 0; i < koc7lx_plugin_info.issueCount * MAX_PRIZE_COUNT; i += MAX_PRIZE_COUNT)
    {
        memcpy(&prizeTable[i], prize_param, sizeof(prize_param));
    }

    //填充奖池信息，拷入共享内存
    POOL_PARAM *poolParam = gl_koc7lx_getPoolParam();

    POOL_PARAM pool_param = {"奖池", 0};
    memcpy(poolParam, &pool_param, sizeof(pool_param));

    log_info("KOC7LX load memory finish!");
    return true;
}

ISSUE_INFO *gl_koc7lx_getIssueTable(void)
{
    return (ISSUE_INFO *)koc7lx_plugin_info.issue_info;
}

void *gl_koc7lx_getSubtypeTable(int *len)
{
    if (NULL != len)
    {
        *len = sizeof(SUBTYPE_PARAM) * MAX_SUBTYPE_COUNT;
    }
    return koc7lx_plugin_info.subtype_info;
}

void *gl_koc7lx_getDivisionTable(int *len, uint64 issueNumber)
{
    ts_notused(issueNumber);
    if (NULL != len)
    {
        *len = sizeof(DIVISION_PARAM) * MAX_DIVISION_COUNT;
    }
    return koc7lx_plugin_info.division_info;
}

PRIZE_PARAM *gl_koc7lx_getPrizeTable(uint64 issueNum)
{
    if (0 == issueNum)
    {
        return (PRIZE_PARAM *)koc7lx_plugin_info.prize_info;
    }

    int idx = 0;
    int ret = 0;
    ISSUE_INFO *issueTable = gl_koc7lx_getIssueTable();
    for (; idx < koc7lx_plugin_info.issueCount; idx++)
    {
        if (issueTable[idx].used && issueTable[idx].issueNumber == issueNum)
        {
            ret++;
            break;
        }
    }
    if (0 == ret)
    {
        return NULL;
    }

    return (PRIZE_PARAM *)((char *)koc7lx_plugin_info.prize_info + 
                           sizeof(PRIZE_PARAM) * idx * MAX_PRIZE_COUNT);
}

POOL_PARAM *gl_koc7lx_getPoolParam(void)
{
    return (POOL_PARAM *)koc7lx_plugin_info.pool_info;
}

int gl_koc7lx_getSingleAmount(char *buffer, size_t len)
{
    if (buffer == NULL)
    {
        log_error("buffer is NULL.");
        return -1;
    }

    char tmp[256] = {0};

    for (uint8 subtype = SUBTYPE_ZX; subtype <= SUBTYPE_ZX; subtype++)
    {
        SUBTYPE_PARAM *subParam = gl_koc7lx_getSubtypeParam(subtype);
        if (subParam != NULL)
        {
            sprintf(tmp, "%s%s=%d", tmp, subtypeAbbr[GAME_KOC7LX][subtype], subParam->singleAmount);

//            if (subtype != SUBTYPE_ZXHALF)
//            {
//                strcat(tmp, ",");
//            }
        }
    }

    if (strlen(tmp) + 1 > len)
    {
        log_error("gl_koc7lx_getSingleAmount() len not enough.");
        return -1;
    }
    memcpy(buffer, tmp, strlen(tmp)+1);

    return 0;
}

ISSUE_INFO *gl_koc7lx_get_currIssue(void)
{
    ISSUE_INFO *issueTable = gl_koc7lx_getIssueTable();

    time_type currentTime = get_now();

    for (int i = 0; i < koc7lx_plugin_info.issueCount; i++)
    {
        if (issueTable[i].used)
        {
            if ( (currentTime < issueTable[i].closeTime)
		    		&& ( (issueTable[i].curState == ISSUE_STATE_OPENED)
		    		|| ( issueTable[i].curState == ISSUE_STATE_CLOSING  && issueTable[i].localState != ISSUE_STATE_CLOSED ) )
		       )
			    return &(issueTable[i]);
        }
    }

    return NULL;
}

ISSUE_INFO *gl_koc7lx_get_issueInfo(uint64 issueNum)
{
    ISSUE_INFO *issueTable = gl_koc7lx_getIssueTable();

    if (issueNum == 0)
    {
        log_debug("issueNum is 0.");
        return NULL;
    }

    for (int i = 0; i < koc7lx_plugin_info.issueCount; i++)
    {
        if (issueTable[i].used)
        {
            if (issueTable[i].issueNumber == issueNum)
            {
                return &issueTable[i];
            }
        }
    }

    log_error("cannot get issue by issue number[%llu]", issueNum);
    return NULL;
}

ISSUE_INFO *gl_koc7lx_get_issueInfo2(uint32 issueSerial)
{
    ISSUE_INFO *issueTable = gl_koc7lx_getIssueTable();

    if (issueSerial == 0)
    {
        log_debug("issueSerial is 0.");
        return NULL;
    }

    for (int i = 0; i < koc7lx_plugin_info.issueCount; i++)
    {
        if (issueTable[i].used)
        {
            if (issueTable[i].serialNumber == issueSerial)
            {
                return &issueTable[i];
            }
        }
    }

    log_debug("cannot get issue by issue serial[%u]", issueSerial);
    return NULL;
}

uint32 gl_koc7lx_get_issueMaxSeq(void)
{
    uint32 seq = 0;
    ISSUE_INFO *issueTable = gl_koc7lx_getIssueTable();

    for (int i = 0; i < koc7lx_plugin_info.issueCount; i++)
    {
        if (issueTable[i].used)
        {
            if (issueTable[i].serialNumber > seq)
            {
                seq = issueTable[i].serialNumber;
            }
        }
    }

    return seq;
}

SUBTYPE_PARAM *gl_koc7lx_getSubtypeParam(uint8 subtypeCode)
{
    SUBTYPE_PARAM *subTable = (SUBTYPE_PARAM *) gl_koc7lx_getSubtypeTable(NULL);
    for (int i = 0; i < MAX_SUBTYPE_COUNT; i++)
    {
        if (subTable[i].used && subTable[i].subtypeCode == subtypeCode)
        {
            return &subTable[i];
        }
    }
    return NULL;
}

// buf: 投注行号码区(不包含括号)
// length: buf的长度
// mode: bitmap的模式
// betline: 结果存入betline
int gl_koc7lx_format_ticket(char *buf, uint32 length, int mode, BETLINE *betline)
{
    ts_notused(length);

    uint8 bettype = GL_BETTYPE_A(betline);
    GL_BETPART *bpA = GL_BETPART_A(betline);

    int ret = 0;

    BETPART_STR bpStr;
    memset(&bpStr, 0, sizeof(bpStr));
    splitBetpart(buf, &bpStr);

    int base = 1;
    int sizeA = 0;

    if (bettype == BETTYPE_DT)
    {
        sizeA = 5 * 2;

        bpA->mode = mode;
        bpA->size = sizeA;
        ret = num2bit((uint8*)bpStr.bpAE[0], bpStr.bpAECnt[0], bpA->bitmap, 0, base);
        if (ret != 0) {
            return -1;
        }
        ret = num2bit((uint8*)bpStr.bpAT, bpStr.bpATCnt, bpA->bitmap, 5, base);
        if (ret != 0) {
            return -1;
        }
    }
    else
    {
        sizeA = 5;

        bpA->mode = mode;
        bpA->size = sizeA;
        ret = num2bit((uint8*)bpStr.bpAE[0], bpStr.bpAECnt[0], bpA->bitmap, 0, base);
        if (ret != 0) {
            return -1;
        }
    }

    betline->bitmapLen = 2 + sizeA;
    betline->betCount = gl_koc7lx_betlineCount(betline);

    SUBTYPE_PARAM *subtype = gl_koc7lx_getSubtypeParam(betline->subtype);
    if (subtype != NULL)
    {
        betline->singleAmount = subtype->singleAmount;
    }
    else
    {
        log_error("gl_koc7lx_getSubtypeParam is NULL!!!");
        return -1;
    }
    return 0;
}

int get_koc7lx_issueMaxCount(void)
{
    return koc7lx_plugin_info.issueCount;
}

int get_koc7lx_issueCount(void)
{
    int ret = 0;

    ISSUE_INFO *issueTable = gl_koc7lx_getIssueTable();
    for (int i = 0; i < koc7lx_plugin_info.issueCount; i++)
    {
        if (issueTable[i].used && issueTable[i].curState < ISSUE_STATE_ISSUE_END)
        {
            ret++;
        }
    }

    return ret;
}

int gl_koc7lx_load_newIssueData(void *issueBuffer, int32 issueCount)
{
    ISSUE_CFG_DATA *issueBuf = (ISSUE_CFG_DATA *)issueBuffer;
    
    ISSUE_INFO *issueTable = gl_koc7lx_getIssueTable();

    if (NULL == issueTable)
    {
        log_error("gl_koc7lx_load_newIssueData: get_koc7lx_issueTable is NULL!");
        return 0;
    }

    int i,j;
    for (j = 0; j < issueCount; j++)
    {
        for (i = 0; i < koc7lx_plugin_info.issueCount; i++)
        {
            if (!issueTable[i].used)
            {
                issueTable[i].gameCode = issueBuf[j].gameCode;
                issueTable[i].issueNumber = issueBuf[j].issueNumber;
                issueTable[i].serialNumber = issueBuf[j].serialNumber;
                issueTable[i].curState = issueBuf[j].curState;
                issueTable[i].localState = issueBuf[j].localState;
                issueTable[i].startTime = issueBuf[j].startTime;
                issueTable[i].closeTime = issueBuf[j].closeTime;
                issueTable[i].drawTime = issueBuf[j].drawTime;
                issueTable[i].payEndDay = issueBuf[j].payEndDay;
                memcpy(issueTable[i].winConfigStr,issueBuf[j].winConfigStr,strlen(issueBuf[j].winConfigStr));
                issueTable[i].used = true;
                break;
            }
        }
        if(koc7lx_plugin_info.issueCount == i)
        {
        	log_info("gl_koc7lx_load_newIssueData: no issue is unused");
        	break;
        }
    }

    return j;
}

int gl_koc7lx_load_oldIssueData(void *issueBuffer, int32 issueCount)
{
    ISSUE_INFO *issueBuf = (ISSUE_INFO *)issueBuffer;

    ISSUE_INFO *issueTable = gl_koc7lx_getIssueTable();

    if (NULL == issueTable)
    {
        log_error("gl_koc7lx_load_oldIssueData: get_koc7lx_issueTable is NULL!");
        return 0;
    }

    int i,j;
    for (j = 0; j < issueCount; j++)
    {
        for ( i = 0; i < koc7lx_plugin_info.issueCount; i++)
        {
            if (!issueTable[i].used)
            {
                memcpy(&issueTable[i], &issueBuf[j], sizeof(ISSUE_INFO));
                issueTable[i].used = true;
                break;
            }
        }
        if(koc7lx_plugin_info.issueCount == i)
        {
        	log_info("gl_koc7lx_load_oldIssueData: no issue is unused");
        	break;
        }
    }

    return j;
}

bool gl_koc7lx_del_issue(uint64 issueNum)
{
    ISSUE_INFO *issueInfo = gl_koc7lx_get_issueInfo(issueNum);

    if (NULL == issueInfo)
    {
        log_info("gl_koc7lx_del_issue: issue %llu does not exist", issueNum);
        return true;
    }

    if (issueInfo->localState > ISSUE_STATE_RANGED)
    {
        log_error("gl_koc7lx_del_issue: issue %llu cannot be deleted", issueNum);
        return false;
    }
    else
    {
        issueInfo->used = false;

        ISSUE_INFO *issueTable = gl_koc7lx_getIssueTable();

        // 删除所有期次序号大于被删除期次序号的期
        for (int i = 0; i < koc7lx_plugin_info.issueCount; i++)
        {
            if (issueTable[i].used)
            {
                if (issueTable[i].serialNumber > issueInfo->serialNumber)
                {
                    issueTable[i].used = false;
                }
            }
        }
    }

    return true;
}

bool gl_koc7lx_clear_oneIssueData(uint64 issueNum)
{
    if (issueNum == 0)
    {
        log_error("issueNum is 0");
        return false;
    }

    ISSUE_INFO *issueTable = gl_koc7lx_getIssueTable();

    for (int i = 0; i < koc7lx_plugin_info.issueCount; i++)
    {
        if (issueTable[i].used && issueTable[i].issueNumber == issueNum)
        {
            memset(&issueTable[i], 0, sizeof(ISSUE_INFO));
            issueTable[i].used = false;
            return true;
        }
    }

    return false;
}

bool gl_koc7lx_chkp_saveData(const char *filePath)
{
    GL_ISSUE_CHKP_DATA data;
    memset(&data, 0, sizeof(GL_ISSUE_CHKP_DATA));
    ISSUE_INFO *issue_chkp = NULL;
    ISSUE_INFO *issueTable = gl_koc7lx_getIssueTable();

    for (int i = 0; i < koc7lx_plugin_info.issueCount; i++)
    {
        if (!issueTable[i].used) continue;

        issue_chkp = &data.issueData[i];
        issue_chkp->used = true;
        issue_chkp->gameCode = issueTable[i].gameCode;
        issue_chkp->issueNumber = issueTable[i].issueNumber;
        issue_chkp->serialNumber = issueTable[i].serialNumber;

        issue_chkp->stat.issueSaleAmount = issueTable[i].stat.issueSaleAmount;
        issue_chkp->stat.issueSaleCount = issueTable[i].stat.issueSaleCount;
        issue_chkp->stat.issueSaleBetCount = issueTable[i].stat.issueSaleBetCount;
        issue_chkp->stat.issueCancelAmount = issueTable[i].stat.issueCancelAmount;
        issue_chkp->stat.issueCancelCount = issueTable[i].stat.issueCancelCount;
        issue_chkp->stat.issueCancelBetCount = issueTable[i].stat.issueCancelBetCount;
        issue_chkp->stat.issueRefuseAmount = issueTable[i].stat.issueRefuseAmount;
        issue_chkp->stat.issueRefuseCount = issueTable[i].stat.issueRefuseCount;
    }

    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName, "%s/koc7lx_issue.snapshot", filePath);
    
    fp = open(fileName, O_CREAT|O_WRONLY, S_IRUSR);
    if (0 > fp)
    {
        log_error("open %s error", fileName);
        return false;
    }

    ssize_t ret = write(fp, (const void *)&data, sizeof(GL_ISSUE_CHKP_DATA));
    if (0 > ret)
    {
        log_error("write %s error [%s]", fileName, strerror(errno));
        return false;
    }

    close(fp);

    return true;
}

bool gl_koc7lx_chkp_restoreData(const char *filePath)
{
    GL_ISSUE_CHKP_DATA data;

    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName, "%s/koc7lx_issue.snapshot", filePath);
    if (access(fileName, 0) != 0)
    {
        log_warn("%s doesn't exist.", fileName);
        return true;
    }
    fp = open(fileName, O_RDONLY);
    if (0 > fp)
    {
        log_error("open %s error!", fileName);
        return false;
    }

    ssize_t ret = read(fp, &data, sizeof(GL_ISSUE_CHKP_DATA));
    if (0 > ret)
    {
        log_error("read %s error [%s]", fileName, strerror(errno));
        return false;
    }

    close(fp);

    ISSUE_INFO *issue_chkp;
    ISSUE_INFO *issueInfo;
    for (int i = 0; i < koc7lx_plugin_info.issueCount; i++)
    {
        issue_chkp = &data.issueData[i];
        
        if (!issue_chkp->used) continue;

        issueInfo = gl_koc7lx_get_issueInfo2(issue_chkp->serialNumber);
        if (NULL == issueInfo)
        {
            log_warn("chkp_restore:gl_koc7lx_get_issueInfo2[%d]",
                     issue_chkp->serialNumber);
            continue;
        }

        issueInfo->stat.issueSaleAmount = issue_chkp->stat.issueSaleAmount;
        issueInfo->stat.issueSaleCount = issue_chkp->stat.issueSaleCount;
        issueInfo->stat.issueSaleBetCount = issue_chkp->stat.issueSaleBetCount;
        issueInfo->stat.issueCancelAmount = issue_chkp->stat.issueCancelAmount;
        issueInfo->stat.issueCancelCount = issue_chkp->stat.issueCancelCount;
        issueInfo->stat.issueCancelBetCount = issue_chkp->stat.issueCancelBetCount;
        issueInfo->stat.issueRefuseAmount = issue_chkp->stat.issueRefuseAmount;
        issueInfo->stat.issueRefuseCount = issue_chkp->stat.issueRefuseCount;
    }

    return true;
}

bool gl_koc7lx_loadPrizeTable(uint64 issue, PRIZE_PARAM_ISSUE *prize)
{
    PRIZE_PARAM *prizeInfo = gl_koc7lx_getPrizeTable(issue);
    if (NULL == prizeInfo)
    {
        log_error("gl_koc7lx_getPrizeTable issue[%llu] unfound", issue);
        return false;
    }

    for (int i = 0; i < MAX_PRIZE_COUNT; i++)
    {
        if (prizeInfo[i].used)
        {
            for (int j = 0; j < MAX_PRIZE_COUNT; j++)
            {
                if (prizeInfo[i].prizeCode == prize[j].prizeCode)
                {
                    prizeInfo[i].fixedPrizeAmount = prize[j].prizeAmount;
                }
            }
        }
    }

    return true;
}

int gl_koc7lx_resolve_winStr(uint64 issue, void *buf)
{
    KOC7LX_CALC_PRIZE_PARAM *calcParam = (KOC7LX_CALC_PRIZE_PARAM *)buf;

    ISSUE_INFO *issueInfo = gl_koc7lx_get_issueInfo(issue);
    if (issueInfo == NULL)
    {
        return -1;
    }

    sscanf(issueInfo->winConfigStr, "FDBD:%lld#FDFD:%lld#FDMIN:%lld",
    	   &calcParam->firstPrizeLowerBetLimit,
           &calcParam->firstPrizeUpperBetLimit,
           &calcParam->minAmount);
    return sizeof(KOC7LX_CALC_PRIZE_PARAM);
}

char *gl_koc7lx_get_winStr(uint64 issue)
{
    ISSUE_INFO *issueInfo = gl_koc7lx_get_issueInfo(issue);

    if (issueInfo != NULL)
    {
        return issueInfo->winConfigStr;
    }

    return NULL;
}



