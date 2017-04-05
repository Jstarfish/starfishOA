#include "global.h"
#include "gl_inf.h"

#include "gl_koctty_db.h"
#include "gl_koctty_verify.h"
#include "gl_koctty_betcount.h"
#include "gl_koctty_rk.h"



#define GL_KOCTTY_SHM_KEY      (GL_SHM_KEY + GAME_KOCTTY)

#define SHARE_MEM_REDUN  32


static int32 ncGlobalMem = 0;
static int32 ncGlobalLen = 0;

const int MAX_BUFSIZE = 2048;

static GL_PLUGIN_INFO koctty_plugin_info;

static void * koctty_plugin_info_ptr = NULL;


extern GAME_RISK_KOCTTY_ISSUE_DATA *rk_koctty_issueData;
extern KOCTTY_BETBC_TABLE *rk_koctty_bcTable;
extern ISSUE_INFO *koctty_issue_info;
extern int totalIssueCount;

/// share interface

bool gl_koctty_mem_creat(int issue_count)
{

	int32 ret = -1;
    IPCKEY keyid;

    ncGlobalLen = sizeof(int) +
            sizeof(SUBTYPE_PARAM) * MAX_SUBTYPE_COUNT +
            sizeof(DIVISION_PARAM) * issue_count * MAX_DIVISION_COUNT +
            sizeof(ISSUE_INFO) * issue_count +
            sizeof(PRIZE_PARAM) * issue_count * MAX_PRIZE_COUNT +
            sizeof(POOL_PARAM) +
            sizeof(GAME_RISK_KOCTTY_ISSUE_DATA) * issue_count +
            sizeof(KOCTTY_BETBC_TABLE) +
            SHARE_MEM_REDUN;

    //创建keyid
    keyid = ipcs_shmkey(GL_KOCTTY_SHM_KEY);

    //创建共享内存
    ncGlobalMem = sysv_get_shm(keyid, ncGlobalLen, IPC_CREAT | IPC_EXCL | 0644);
    if (-1 == ncGlobalMem)
    {
        log_error("gl_create::create globalSection(gl) failure");
        return false;
    }

    //内存映射
    koctty_plugin_info_ptr = (signed char *) sysv_attach_shm(ncGlobalMem, 0, 0);
    if ((void*) -1 == koctty_plugin_info_ptr)
    {
        log_error("gl_create::attach globalSection(gl) failure.");
        return false;
    }

    //初始化共享内存
    memset(koctty_plugin_info_ptr, 0, ncGlobalLen);
    *((int *) koctty_plugin_info_ptr) = issue_count;
    //

    //断开与共享内存的映射
    ret = sysv_detach_shm(koctty_plugin_info_ptr);
    if (ret < 0)
    {
        log_error("gl_create:deattach globalSection(gl) failure.");
        return false;
    }

    log_info("gl_koctty_mem_creat success! shm_key[%#x] shm_id[%d] size[%d] issueCount[%d]", keyid, ncGlobalMem, ncGlobalLen, issue_count);
    return true;
}

//删除共享内存
bool gl_koctty_mem_destroy()
{
    int32 ret = -1;

    //如果创建共享内存和删除共享内存在不同的任务中，需要下面这段程序
    IPCKEY keyid;

    keyid = ipcs_shmkey(GL_KOCTTY_SHM_KEY);

    ncGlobalMem = sysv_get_shm(keyid, 0, 0);
    //ncGlobalMem = sysv_get_shm(keyid, ncGlobalLen, IPC_CREAT|0644);
    if (-1 == ncGlobalMem)
    {
        log_error("gl_destroy::open globalSection(gl) failure.");
        return false;
    }

    //删除共享内存
    ret = sysv_ctl_shm(ncGlobalMem, IPC_RMID, NULL);
    if (ret < 0)
    {
        log_error("gl_destroy:delete globalSection(gl) failure.");
        return false;
    }

    log_info("gl_koctty_mem_destroy success!");
    return true;
}

//映射共享内存区
bool gl_koctty_mem_attach()
{
    IPCKEY keyid;

    keyid = ipcs_shmkey(GL_KOCTTY_SHM_KEY);

    ncGlobalMem = sysv_get_shm(keyid, 0, 0);
    //ncGlobalMem = sysv_get_shm(keyid, ncGlobalLen, IPC_CREAT|0644);
    if (-1 == ncGlobalMem)
    {
        log_error("gl_init::open globalSection(gl) failure.");
        return false;
    }

    koctty_plugin_info_ptr =  sysv_attach_shm(ncGlobalMem, 0, 0);
    if ((signed char *) -1 == koctty_plugin_info_ptr)
    {
        log_error("gl_init::attach globalSection(gl) failure.");
        return false;
    }

    //初始化数据库结构指针
    koctty_plugin_info.issueCount = *(int *)koctty_plugin_info_ptr;

    koctty_plugin_info.subtype_info = (char *)koctty_plugin_info_ptr + sizeof(int);

    koctty_plugin_info.division_info = (char *)koctty_plugin_info.subtype_info + sizeof(SUBTYPE_PARAM) * MAX_SUBTYPE_COUNT;

    koctty_plugin_info.issue_info = (char *)koctty_plugin_info.division_info + sizeof(DIVISION_PARAM) * MAX_DIVISION_COUNT * koctty_plugin_info.issueCount;

    koctty_plugin_info.prize_info = (char *)koctty_plugin_info.issue_info + sizeof(ISSUE_INFO) * koctty_plugin_info.issueCount;

    koctty_plugin_info.pool_info = (char *)koctty_plugin_info.prize_info + sizeof(PRIZE_PARAM) * MAX_PRIZE_COUNT * koctty_plugin_info.issueCount;

    koctty_plugin_info.rk_info = (char *)koctty_plugin_info.pool_info + sizeof(POOL_PARAM);


    //////////////// rk globa /////////////////////////
	rk_koctty_issueData = (GAME_RISK_KOCTTY_ISSUE_DATA *)(koctty_plugin_info.rk_info);

	rk_koctty_bcTable = (KOCTTY_BETBC_TABLE *)((char *)koctty_plugin_info.rk_info + sizeof(GAME_RISK_KOCTTY_ISSUE_DATA) * koctty_plugin_info.issueCount);

	koctty_issue_info = (ISSUE_INFO *)(koctty_plugin_info.issue_info);

	totalIssueCount = koctty_plugin_info.issueCount;

	rk_initVerifyFun();

    return true;
}

//关闭共享内存区的映射
bool gl_koctty_mem_detach()
{
    int32 ret = -1;

    if (NULL == koctty_plugin_info_ptr)
    {
        log_error("gl_close::globalSection(gl) pointer is NULL;");
        return false;
    }

    //断开与共享内存的映射
    ret = sysv_detach_shm(koctty_plugin_info_ptr);
    if (ret < 0)
    {
        log_error("gl_close:deattach globalSection(gl) failure.");
        return false;
    }

    ncGlobalMem = 0;
    koctty_plugin_info_ptr = NULL;
    return true;
}


/*    next  no can see out of .so    */
void *gl_koctty_get_mem_db(void)
{
    return koctty_plugin_info_ptr;
}



void * gl_koctty_getSubtypeTable(int *len)
{
	if (len != NULL)
        *len = sizeof(SUBTYPE_PARAM) * MAX_SUBTYPE_COUNT;
    return koctty_plugin_info.subtype_info;
}

SUBTYPE_PARAM * gl_koctty_getSubtypeParam( uint8 subtypeCode)
{
	SUBTYPE_PARAM * subTable = (SUBTYPE_PARAM *) gl_koctty_getSubtypeTable(NULL);
	for(int i = 0; i < MAX_SUBTYPE_COUNT; i++)
	{
		if((subTable[i].used) && (subTable[i].subtypeCode ==  subtypeCode))
			return &subTable[i];
	}

    return NULL;
}

void * gl_koctty_getDivisionTable(int *len,uint64 issueNum)
{
	if (len != NULL)
        *len = sizeof(DIVISION_PARAM) * MAX_SUBTYPE_COUNT;

	DIVISION_PARAM *divisionParam =(DIVISION_PARAM *)(koctty_plugin_info.division_info);

	KOCTTY_CALC_PRIZE_PARAM calcParam;
	calcParam.specWinFlag = 0;

	ISSUE_INFO *allIssueInfo = gl_koctty_getIssueTable();

	int idx = 0;

	if(issueNum > 0)
	{
		for(idx = 0; idx < totalIssueCount ; idx++)
		{
			if(allIssueInfo[idx].used)
			{
				if(allIssueInfo[idx].issueNumber == issueNum)
				{
					gl_koctty_resolve_winStr(issueNum,(void *)&calcParam);
					break;
				}
			}
		}

		divisionParam =(DIVISION_PARAM *)((char *)koctty_plugin_info.division_info + sizeof(DIVISION_PARAM) * MAX_DIVISION_COUNT * idx);

		for(int i = 0; i < MAX_DIVISION_COUNT; i++)
		{
			if(divisionParam[i].used)
				divisionParam[i].specWinFlag = calcParam.specWinFlag;
		}
	}

    return (void *)divisionParam;
}

DIVISION_PARAM * gl_koctty_getDivisionParam( uint8 divisionCode)
{
	DIVISION_PARAM * divisionTable = (DIVISION_PARAM *)gl_koctty_getDivisionTable(NULL,0);
	for(int i = 0; i < MAX_DIVISION_COUNT; i++)
	{
		if((divisionTable[i].used) && (divisionTable[i].divisionCode == divisionCode))
				return &divisionTable[i];
	}

	return NULL;
}

PRIZE_PARAM * gl_koctty_getPrizeTable(uint64 issueNum)
{
	if(issueNum == 0)
	    return  (PRIZE_PARAM *)((char *)koctty_plugin_info.prize_info);

	int idx = 0;
	int ret = 0;
	ISSUE_INFO * issueTable = gl_koctty_getIssueTable();
	for(; idx < totalIssueCount; idx++ )
	{
		if((issueTable[idx].used) && (issueTable[idx].issueNumber == issueNum))
		{
			ret++;
			break;
		}
	}
	if(ret == 0)
		return NULL;
	return  (PRIZE_PARAM *)((char *)koctty_plugin_info.prize_info + sizeof(PRIZE_PARAM) * idx * MAX_PRIZE_COUNT);
}


POOL_PARAM *gl_koctty_getPoolParam(void)
{
	return (POOL_PARAM*) koctty_plugin_info.pool_info;
}

void *gl_koctty_getRkTable(void)
{
	return koctty_plugin_info.rk_info;
}

int gl_koctty_getSingleAmount(char *buffer, size_t len)
{
	char tmp[256] = {0};

	for (uint8 subtype = SUBTYPE_QH2; subtype <= SUBTYPE_H3; subtype++)
	{
	    SUBTYPE_PARAM *subParam = gl_koctty_getSubtypeParam(subtype);
	    sprintf(tmp, "%s%s=%d", tmp, subtypeAbbr[GAME_KOCTTY][subtype], subParam->singleAmount);

	    if (subtype != SUBTYPE_H3)
	    {
	        strcat(tmp, ",");
	    }
	}

	if (strlen(tmp) + 1 > len)
	{
	    log_error("gl_koctty_getSingleAmount() len not enough.");
        return -1;
	}
	memcpy(buffer, tmp, strlen(tmp)+1);

	return 0;
}

ISSUE_INFO *gl_koctty_getIssueTable(void)
{
	return (ISSUE_INFO*) koctty_plugin_info.issue_info;
}

int get_koctty_issueMaxCount(void)
{
    return totalIssueCount;
}

int get_koctty_issueCount(void)
{
	int ret = 0;
	ISSUE_INFO *issueTable = gl_koctty_getIssueTable();
	for(int i = 0; i < totalIssueCount; i++)
	{
		if((issueTable[i].used) && (issueTable[i].curState < ISSUE_STATE_ISSUE_END))
			ret++;
	}
    return ret;
}



PRIZE_PARAM * gl_koctty_getPrizeTableBegin(void)
{
	return  (PRIZE_PARAM *) koctty_plugin_info.prize_info;
}

bool gl_koctty_load_memdata(void)
{
	//SUBTYPE
	SUBTYPE_PARAM *subParam = (SUBTYPE_PARAM*)gl_koctty_getSubtypeTable(NULL);

	SUBTYPE_PARAM subtype_param[MAX_SUBTYPE_COUNT] = {
		{false,0,            "",     "",         0,          0, 0, 0, 0},
		{true, SUBTYPE_QH2,  "QH2",  "前后二",    4294967295, 1, 0, 9, 1000},
		{true, SUBTYPE_QH3,  "QH3",  "前后三",    4294967295, 1, 0, 9, 1000},
		{true, SUBTYPE_4ZX,  "4ZX",  "四星直选",  4294967295, 1, 0, 9, 1000},
		{true, SUBTYPE_Q2,  "Q2",  "前二",    4294967295, 1, 0, 9, 1000},
		{true, SUBTYPE_H2,  "H2",  "后二",    4294967295, 1, 0, 9, 1000},
		{true, SUBTYPE_Q3,  "Q3",  "前三",    4294967295, 1, 0, 9, 1000},
		{true, SUBTYPE_H3,  "H3",  "后三",    4294967295, 1, 0, 9, 1000}

	};
	memcpy( subParam, subtype_param, sizeof(subtype_param) );

    //DIVISION

    //注意修改时与gl_koctty_get_specPrize保持同步
	DIVISION_PARAM div_param[MAX_DIVISION_COUNT] = {

		{true, 1,  "前后二",     PRIZE_QH2,     SUBTYPE_QH2,   false,    2,     0},
		{true, 2,  "前后三",     PRIZE_QH3,     SUBTYPE_QH3,   false,    3,     0},
		{true, 3,  "四星直选",   PRIZE_4ZX,     SUBTYPE_4ZX,   false,    4,     0},

		{true, 4,  "前后二特别奖",     PRIZE_SPEQH2,     SUBTYPE_QH2,   true,    2,    0},
		{true, 5,  "前后三特别奖",     PRIZE_SPEQH3,     SUBTYPE_QH3,   true,    3,    0},
		{true, 6,  "四星直选特别奖",   PRIZE_SPE4ZX,     SUBTYPE_4ZX,   true,    4,    0},

		{true, 7,  "前三",     PRIZE_Q3,     SUBTYPE_Q3,   false,    3,     0},
		{true, 8,  "后三",     PRIZE_H3,     SUBTYPE_H3,   false,    3,     0},
		{true, 9,  "前二",     PRIZE_Q2,     SUBTYPE_Q2,   false,    2,     0},
		{true, 10,  "后二",     PRIZE_H2,     SUBTYPE_H2,   false,    2,     0},
		{true, 11,  "前三特别奖",     PRIZE_SPEQ3,     SUBTYPE_Q3,   true,    3,     0},
		{true, 12,  "后三特别奖",     PRIZE_SPEH3,     SUBTYPE_H3,   true,    3,     0},
		{true, 13,  "前二特别奖",     PRIZE_SPEQ2,     SUBTYPE_Q2,   true,    2,     0},
		{true, 14,  "后二特别奖",     PRIZE_SPEH2,     SUBTYPE_H2,   true,    2,     0},

	};

	DIVISION_PARAM *divParam = (DIVISION_PARAM*)gl_koctty_getDivisionTable(NULL,0);
	memcpy( divParam, div_param, sizeof(div_param) );
	for(int i = 0; i < totalIssueCount * MAX_DIVISION_COUNT; i = i + MAX_DIVISION_COUNT)
	{
	    memcpy( &divParam[i], div_param, sizeof(div_param) );
	}

    //PRIZE
	PRIZE_PARAM prize_param[MAX_PRIZE_COUNT] = {
		{false, 0,            " ",              false, ASSIGN_UNUSED, {0}},
		{true, PRIZE_4ZX,     "四星直选",       true,  ASSIGN_FIXED, {7200000}},
		{true, PRIZE_QH3,     "前后三",         false, ASSIGN_FIXED, {360000}},
		{true, PRIZE_QH2,     "前后二",         false, ASSIGN_FIXED, {36000}},
		{true, PRIZE_SPE4ZX,  "四星直选特别奖",  true,  ASSIGN_FIXED, {10000000}},
		{true, PRIZE_SPEQH3,  "前后三特别奖",    false, ASSIGN_FIXED, {500000}},
		{true, PRIZE_SPEQH2,  "前后二特别奖",    false, ASSIGN_FIXED, {50000}},
		{true, PRIZE_Q3,      "前三",           false, ASSIGN_FIXED, {720000}},
		{true, PRIZE_H3,      "后三",           false, ASSIGN_FIXED, {720000}},
		{true, PRIZE_Q2,      "前二",           false, ASSIGN_FIXED, {72000}},
		{true, PRIZE_H2,      "后二",           false, ASSIGN_FIXED, {72000}},
		{true, PRIZE_SPEQ3,   "前三特别奖",     false, ASSIGN_FIXED, {1000000}},
		{true, PRIZE_SPEH3,   "后三特别奖",     false, ASSIGN_FIXED, {1000000}},
		{true, PRIZE_SPEQ2,   "前二特别奖",     false, ASSIGN_FIXED, {100000}},
		{true, PRIZE_SPEH2,   "后二特别奖",     false, ASSIGN_FIXED, {100000}},

	};

	PRIZE_PARAM *prizeTable = gl_koctty_getPrizeTableBegin();
	for(int i = 0; i < totalIssueCount * MAX_PRIZE_COUNT; i = i + MAX_PRIZE_COUNT)
	{
	    memcpy( &prizeTable[i], prize_param, sizeof(prize_param) );
	}

	//POOL
	POOL_PARAM *poolParam = gl_koctty_getPoolParam();

	POOL_PARAM pool_param = {"奖池", 0};
	memcpy( poolParam, &pool_param, sizeof(pool_param) );

    //GAME_RK
    if (!gl_tty_rk_init())
    {
        log_error("gl_tty_rk_init() failure.");
        return false;
    }


	log_info("KOCTTY load memory Finish!");
	return true;
}

int gl_koctty_load_newIssueData(void *issueBuffer, int32 issueCount)
{
	ISSUE_CFG_DATA *issueBuf = (ISSUE_CFG_DATA *)issueBuffer;

	ISSUE_INFO *issueInfo = gl_koctty_getIssueTable();

	if(issueInfo == NULL)
	{
		log_error("gl_koctty_load_newIssueData: gl_koctty_getIssueTable is NULL!");
		return 0;
	}

    int i,j;

	for(j = 0; j < issueCount; j++)
	{
		for(i = 0; i < totalIssueCount ; i++)
		{
		    if(!issueInfo[i].used)
		    {
		        issueInfo[i].gameCode = issueBuf[j].gameCode;
		        issueInfo[i].issueNumber = issueBuf[j].issueNumber;
		        issueInfo[i].serialNumber = issueBuf[j].serialNumber;
		        issueInfo[i].curState = issueBuf[j].curState;
		        issueInfo[i].localState = issueBuf[j].localState;
		        issueInfo[i].startTime = issueBuf[j].startTime;
		        issueInfo[i].closeTime = issueBuf[j].closeTime;
		        issueInfo[i].drawTime = issueBuf[j].drawTime;
		        issueInfo[i].payEndDay = issueBuf[j].payEndDay;

		        memcpy(issueInfo[i].winConfigStr,issueBuf[j].winConfigStr,strlen(issueBuf[j].winConfigStr));
		        issueInfo[i].used = true;
		        break;
		    }
		}
        if(totalIssueCount == i)
        {
        	log_info("gl_kockeno_load_newIssueData: no issue is unused");
        	break;
        }
	}

	return j;
}

int gl_koctty_load_oldIssueData(void *issueBuffer, int32 issueCount)
{
	ISSUE_INFO *issueBuf = (ISSUE_INFO *)issueBuffer;

	ISSUE_INFO *issueInfo = gl_koctty_getIssueTable();

	if(issueInfo == NULL)
	{
		log_error("gl_koctty_load_oldIssueData: gl_koctty_getIssueTable is NULL!");
		return 0;
	}

    int i,j;

	for(j = 0; j < issueCount; j++)
	{
		for(i = 0; i < totalIssueCount ; i++)
		{
		    if(!issueInfo[i].used)
		    {
                memcpy((void *)&issueInfo[i],(void *)&issueBuf[j],sizeof(ISSUE_INFO));
		        issueInfo[i].used = true;
		        break;
		    }
		}
        if(totalIssueCount == i)
        {
        	log_info("gl_kockeno_load_newIssueData: no issue is unused");
        	break;
        }
	}

	return j;
}


ISSUE_INFO* gl_koctty_get_currIssue(void)
{
	ISSUE_INFO *allIssueInfo = gl_koctty_getIssueTable();

	time_type currentTime = get_now();

	for(int i = 0; i < totalIssueCount ; i++)
	{
		if(allIssueInfo[i].used)
		{
            if ((currentTime < allIssueInfo[i].closeTime)
		    		&& ( (allIssueInfo[i].curState == ISSUE_STATE_OPENED) || ( allIssueInfo[i].curState == ISSUE_STATE_CLOSING  && allIssueInfo[i].localState != ISSUE_STATE_CLOSED )))
			    return &(allIssueInfo[i]);
		}
	}

	return NULL;
}

ISSUE_INFO* gl_koctty_get_issueInfo(uint64 issueNum)
{
	ISSUE_INFO *allIssueInfo = gl_koctty_getIssueTable();

	if(issueNum > 0)
	{
		for(int i = 0; i < totalIssueCount ; i++)
		{
			if(allIssueInfo[i].used)
			{
				if(allIssueInfo[i].issueNumber == issueNum)
					return &(allIssueInfo[i]);
			}
		}
	}

	return NULL;
}

ISSUE_INFO* gl_koctty_get_issueInfo2(uint32 issueSerial)
{
	ISSUE_INFO *allIssueInfo = gl_koctty_getIssueTable();

	if(issueSerial > 0)
	{
		for(int i = 0; i < totalIssueCount ; i++)
		{
			if(allIssueInfo[i].used)
			{
				if(allIssueInfo[i].serialNumber == issueSerial)
					return &(allIssueInfo[i]);
			}
		}
	}

	return NULL;
}

ISSUE_INFO* gl_koctty_get_issueInfoByIndex(int idx)
{
	ISSUE_INFO *allIssueInfo = gl_koctty_getIssueTable();

    if(idx < totalIssueCount)
    	return &(allIssueInfo[idx]);
    else
	    return NULL;
}

uint32 gl_koctty_get_issueMaxSeq(void)
{
	uint32 seq = 0;
	ISSUE_INFO *allIssueInfo = gl_koctty_getIssueTable();

	for(int i = 0; i < totalIssueCount ; i++)
	{
		if(allIssueInfo[i].used)
		{
			if(allIssueInfo[i].serialNumber > seq)
				seq = allIssueInfo[i].serialNumber;
		}
	}

	return seq;
}

bool gl_koctty_del_issue(uint64 issueNum)
{
	ISSUE_INFO* issueInfo = gl_koctty_get_issueInfo(issueNum);
	if(issueInfo == NULL)
	{
		log_info("gl_koctty_del_issue: issueNum[%lld] not find",issueNum);
		return true;
	}

	if(issueInfo->localState > ISSUE_STATE_RANGED)
		return false;
	else
	{
		issueInfo->used = false;

		ISSUE_INFO *allIssueInfo = gl_koctty_getIssueTable();

		for(int i = 0; i < totalIssueCount ; i++)
		{
			if(allIssueInfo[i].used)
			{
				if(allIssueInfo[i].serialNumber > issueInfo->serialNumber)
					allIssueInfo[i].used = false;
			}
		}
	}

	return true;
}

bool gl_koctty_clear_oneIssueData(uint64 issueNum)
{
	ISSUE_INFO *allIssueInfo = gl_koctty_getIssueTable();

	for(int i = 0; i < totalIssueCount ; i++)
	{
		if(allIssueInfo[i].used)
		{
			if(allIssueInfo[i].issueNumber == issueNum)
			{
				allIssueInfo[i].used = false;
				bzero((void *)&(allIssueInfo[i]),sizeof(ISSUE_INFO));
				return true;
			}
		}
	}
	return false;
}

bool gl_koctty_chkp_saveData(const char *filePath)
{
    GL_ISSUE_CHKP_DATA data;
    memset(&data, 0, sizeof(GL_ISSUE_CHKP_DATA));
    ISSUE_INFO *issue_chkp = NULL;
    ISSUE_INFO *issueInfo = gl_koctty_getIssueTable();

    for(int i = 0; i < koctty_plugin_info.issueCount; i++)
    {
        if(!issueInfo[i].used)
            continue;

        issue_chkp = &data.issueData[i];
        issue_chkp->used = true;
        issue_chkp->gameCode = issueInfo[i].gameCode;
        issue_chkp->issueNumber = issueInfo[i].issueNumber;
        issue_chkp->serialNumber = issueInfo[i].serialNumber;

        issue_chkp->stat.issueSaleAmount = issueInfo[i].stat.issueSaleAmount;
        issue_chkp->stat.issueSaleCount = issueInfo[i].stat.issueSaleCount;
        issue_chkp->stat.issueSaleBetCount = issueInfo[i].stat.issueSaleBetCount;
        issue_chkp->stat.issueCancelAmount = issueInfo[i].stat.issueCancelAmount;
        issue_chkp->stat.issueCancelCount = issueInfo[i].stat.issueCancelCount;
        issue_chkp->stat.issueCancelBetCount = issueInfo[i].stat.issueCancelBetCount;
        issue_chkp->stat.issueRefuseAmount = issueInfo[i].stat.issueRefuseAmount;
        issue_chkp->stat.issueRefuseCount = issueInfo[i].stat.issueRefuseCount;

    }

    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName, "%s/koctty_issue.snapshot", filePath);
    if((fp = open(fileName,O_CREAT|O_WRONLY,S_IRUSR )) < 0 )
    {
    	log_error("open %s error!",fileName);
    	return -1;
    }
    ssize_t ret = write(fp, (const void *)&data, sizeof(GL_ISSUE_CHKP_DATA));
    if(ret < 0)
    {
    	log_error("write %s error errno[%d]",fileName, errno);
        return -1;
    }
    close(fp);

    return gl_koctty_rk_saveData(filePath);

}

bool gl_koctty_chkp_restoreData(const char *filePath)
{
    GL_ISSUE_CHKP_DATA data;

    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName, "%s/koctty_issue.snapshot", filePath);
    if((fp = open(fileName,O_RDONLY )) < 0 )
    {
    	log_error("open %s error!", fileName);
    	return -1;
    }
    ssize_t ret = read(fp, (void *)&data, sizeof(GL_ISSUE_CHKP_DATA));
    if(ret < 0)
    {
    	log_error("read %s error errno[%d]",fileName,errno);
        return -1;
    }
    close(fp);

    ISSUE_INFO *issue_chkp = NULL;

    ISSUE_INFO *issueInfo = NULL;

    for(int i = 0; i < koctty_plugin_info.issueCount; i++)
    {
        issue_chkp = &data.issueData[i];
        if(!issue_chkp->used)
            continue;

        issueInfo = gl_koctty_get_issueInfo2(issue_chkp->serialNumber);
        if (NULL == issueInfo)
        {
            log_warn("tms chkp_restore() gl_koctty_get_issueInfo2[%d]", issue_chkp->serialNumber);
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
    if(isGameBeRiskControl(GAME_KOCTTY))
        return gl_koctty_rk_restoreData(filePath);
    return true;
}



bool gl_koctty_loadPrizeTable(uint64 issue,PRIZE_PARAM_ISSUE *prize)
{
	PRIZE_PARAM *prizeMem = gl_koctty_getPrizeTable(issue);
	if(prizeMem == NULL)
	{
    	log_error("gl_koctty_getPrizeTable issue[%lld] no find",issue);
        return false;
	}
	for(int i=0; i < MAX_PRIZE_COUNT; i++)
	{
		if(prizeMem[i].used)
		{
			for(int j=0; j < MAX_PRIZE_COUNT; j++)
			    if(prizeMem[i].prizeCode == prize[j].prizeCode)
			    {
				    prizeMem[i].fixedPrizeAmount = prize[j].prizeAmount;
			    }
		}
	}
	return true;
}

void *gl_koctty_get_rkIssueDataTable(void)
{
	return (void *)rk_koctty_issueData;
}

//通用函数处理特殊情况
int gl_koctty_get_specPrize(char *in, char *out)
{
    DIVISION_PARAM *div = (DIVISION_PARAM*)in;
    if (div == NULL)
    {
        //*out = -1;
        return -1;
    }
    div = div + 3;
    out[0] = div->specWinFlag == 1 ? '1' : '0';

    return 0;
}


int gl_koctty_gen_fun(int type, char *in, char *out)
{
    int ret = 0;
    switch(type)
    {
        default:
            ret = 0;
            break;
        case TTY_SPECPRIZE:
            ret = gl_koctty_get_specPrize(in, out);
            break;
    }
    return ret;
}

// buf: 投注行号码区(不包含括号)
// length: buf的长度
// mode: bitmap的模式
// betline: 结果存入betline
void gl_koctty_format_ticket(char* buf, uint32 length, int mode, BETLINE* betline)
{
	ts_notused(length);
    GL_BETPART *bp = (GL_BETPART*)betline->bitmap;

	BETPART_STR bpStr;
	memset(&bpStr, 0, sizeof(bpStr));
	if (mode == MODE_YS)
	{
	    splitBetpart(buf, &bpStr, 1);
	}
	else
	{
	    splitBetpart(buf, &bpStr);
	}

    int base = 0;
    int sizeA = 0;

	if (mode == MODE_JC) {
		sizeA = 2;

		bp->mode = mode;
		bp->size = sizeA;
		num2bit((uint8*)bpStr.bpAE[0], bpStr.bpAECnt[0], bp->bitmap, 0, base);
	} else if (mode == MODE_JS) {
		sizeA = 1;

		bp->mode = mode;
		bp->size = sizeA;
		bp->bitmap[0] = bpStr.bpAE[0][0];
	} else if (mode == MODE_FD) {
		sizeA = bpStr.bpALLCnt * 2;
		for (int k = 0; k < bpStr.bpALLCnt; k++) {
			num2bit((uint8*)(bpStr.bpAE + k), bpStr.bpAECnt[k], bp->bitmap, k * 2, base);
		}
		bp->mode = mode;
		bp->size = sizeA;
	} else if (mode == MODE_YS) {
        sizeA = 4 * 2;

        bp->mode = mode;
        bp->size = sizeA;

        memcpy(bp->bitmap, bpStr.bpAE[0], sizeA / 2);
        memcpy(&bp->bitmap[sizeA / 2], bpStr.bpAE[1], sizeA / 2);
	}
	betline->bitmapLen = 2 + sizeA;
	betline->betCount = gl_koctty_betlineBetcount(betline);

	SUBTYPE_PARAM* subtype = gl_koctty_getSubtypeParam(betline->subtype);
	if (subtype != NULL)
	{
		betline->singleAmount = subtype->singleAmount;
	} else
	{
		log_error("gl_koctty_getSubtypeParam is NULL!!!");
	}
}


int gl_koctty_resolve_winStr(uint64 issue,void *buf)
{
	KOCTTY_CALC_PRIZE_PARAM *calcParam = (KOCTTY_CALC_PRIZE_PARAM *)buf;
	ISSUE_INFO *issueInfo = gl_koctty_get_issueInfo(issue);
	if(issueInfo != NULL)
	{
	    int flag = 0;
	    const char *format="TBZJ:%d";
	    sscanf(issueInfo->winConfigStr,format,&flag);
	    calcParam->specWinFlag = flag;
	}
	return sizeof(KOCTTY_CALC_PRIZE_PARAM);
}


char *gl_koctty_get_winStr(uint64 issue)
{
	ISSUE_INFO *issueInfo = gl_koctty_get_issueInfo(issue);
	if(issueInfo != NULL)
	{
		return issueInfo->winConfigStr;
	}
	return NULL;
}









