#include "global.h"
#include "gl_inf.h"

#include "gl_kock3_db.h"
#include "gl_kock3_verify.h"
#include "gl_kock3_rk.h"



#define GL_KOCK3_SHM_KEY      (GL_SHM_KEY + GAME_KOCK3)

#define SHARE_MEM_REDUN  32


static int32 ncGlobalMem = 0;
static int32 ncGlobalLen = 0;

const int MAX_BUFSIZE = 2048;

static GL_PLUGIN_INFO kock3_plugin_info;

static void * kock3_plugin_info_ptr = NULL;


extern GAME_RISK_KOCK3_ISSUE_DATA *rk_kock3_issueData;
extern GAME_KOCK3_RK_INDEX *rk_kock3_bcTable;
extern ISSUE_INFO *kock3_issue_info;
extern int totalIssueCount;

/// share interface

bool gl_kock3_mem_creat(int issue_count)
{

	int32 ret = -1;
    IPCKEY keyid;

    ncGlobalLen = sizeof(int) +
            sizeof(SUBTYPE_PARAM) * MAX_SUBTYPE_COUNT +
            sizeof(DIVISION_PARAM) * issue_count * MAX_DIVISION_COUNT +
            sizeof(ISSUE_INFO) * issue_count +
            sizeof(PRIZE_PARAM) * issue_count * MAX_PRIZE_COUNT +
            sizeof(POOL_PARAM) +
            sizeof(GAME_RISK_KOCK3_ISSUE_DATA) * issue_count +
            sizeof(GAME_KOCK3_RK_INDEX) +
            SHARE_MEM_REDUN;

    //创建keyid
    keyid = ipcs_shmkey(GL_KOCK3_SHM_KEY);

    //创建共享内存
    ncGlobalMem = sysv_get_shm(keyid, ncGlobalLen, IPC_CREAT | IPC_EXCL | 0644);
    if (-1 == ncGlobalMem)
    {
        log_error("gl_create::create globalSection(gl) failure");
        return false;
    }

    //内存映射
    kock3_plugin_info_ptr = (signed char *) sysv_attach_shm(ncGlobalMem, 0, 0);
    if ((void*) -1 == kock3_plugin_info_ptr)
    {
        log_error("gl_create::attach globalSection(gl) failure.");
        return false;
    }

    //初始化共享内存
    memset(kock3_plugin_info_ptr, 0, ncGlobalLen);
    *((int *) kock3_plugin_info_ptr) = issue_count;
    //

    //断开与共享内存的映射
    ret = sysv_detach_shm(kock3_plugin_info_ptr);
    if (ret < 0)
    {
        log_error("gl_create:deattach globalSection(gl) failure.");
        return false;
    }

    log_info("gl_kock3_mem_creat success! shm_key[%#x] shm_id[%d] size[%d] issueCount[%d]", keyid, ncGlobalMem, ncGlobalLen, issue_count);
    return true;
}

//删除共享内存
bool gl_kock3_mem_destroy()
{
    int32 ret = -1;

    //如果创建共享内存和删除共享内存在不同的任务中，需要下面这段程序
    IPCKEY keyid;

    keyid = ipcs_shmkey(GL_KOCK3_SHM_KEY);

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

    log_info("gl_kock3_mem_destroy success!");
    return true;
}

//映射共享内存区
bool gl_kock3_mem_attach()
{
    IPCKEY keyid;

    keyid = ipcs_shmkey(GL_KOCK3_SHM_KEY);

    ncGlobalMem = sysv_get_shm(keyid, 0, 0);
    //ncGlobalMem = sysv_get_shm(keyid, ncGlobalLen, IPC_CREAT|0644);
    if (-1 == ncGlobalMem)
    {
        log_error("gl_init::open globalSection(gl) failure.");
        return false;
    }

    kock3_plugin_info_ptr =  sysv_attach_shm(ncGlobalMem, 0, 0);
    if ((signed char *) -1 == kock3_plugin_info_ptr)
    {
        log_error("gl_init::attach globalSection(gl) failure.");
        return false;
    }

    //初始化数据库结构指针
    kock3_plugin_info.issueCount = *(int *)kock3_plugin_info_ptr;

    kock3_plugin_info.subtype_info = (char *)kock3_plugin_info_ptr + sizeof(int);

    kock3_plugin_info.division_info = (char *)kock3_plugin_info.subtype_info + sizeof(SUBTYPE_PARAM) * MAX_SUBTYPE_COUNT;

    kock3_plugin_info.issue_info = (char *)kock3_plugin_info.division_info + sizeof(DIVISION_PARAM) * MAX_DIVISION_COUNT * kock3_plugin_info.issueCount;

    kock3_plugin_info.prize_info = (char *)kock3_plugin_info.issue_info + sizeof(ISSUE_INFO) * kock3_plugin_info.issueCount;

    kock3_plugin_info.pool_info = (char *)kock3_plugin_info.prize_info + sizeof(PRIZE_PARAM) * MAX_PRIZE_COUNT * kock3_plugin_info.issueCount;

    kock3_plugin_info.rk_info = (char *)kock3_plugin_info.pool_info + sizeof(POOL_PARAM);


    //////////////// rk globa /////////////////////////
	rk_kock3_issueData = (GAME_RISK_KOCK3_ISSUE_DATA *)(kock3_plugin_info.rk_info);

	rk_kock3_bcTable = (GAME_KOCK3_RK_INDEX *)((char *)kock3_plugin_info.rk_info + sizeof(GAME_RISK_KOCK3_ISSUE_DATA) * kock3_plugin_info.issueCount);

	kock3_issue_info = (ISSUE_INFO *)(kock3_plugin_info.issue_info);

	totalIssueCount = kock3_plugin_info.issueCount;

    return true;
}

//关闭共享内存区的映射
bool gl_kock3_mem_detach()
{
    int32 ret = -1;

    if (NULL == kock3_plugin_info_ptr)
    {
        log_error("gl_close::globalSection(gl) pointer is NULL;");
        return false;
    }

    //断开与共享内存的映射
    ret = sysv_detach_shm(kock3_plugin_info_ptr);
    if (ret < 0)
    {
        log_error("gl_close:deattach globalSection(gl) failure.");
        return false;
    }

    ncGlobalMem = 0;
    kock3_plugin_info_ptr = NULL;
    return true;
}


/*    next  no can see out of .so    */
void *gl_kock3_get_mem_db(void)
{
    return kock3_plugin_info_ptr;
}



void * gl_kock3_getSubtypeTable(int *len)
{
	if (len != NULL)
        *len = sizeof(SUBTYPE_PARAM) * MAX_SUBTYPE_COUNT;
    return kock3_plugin_info.subtype_info;
}

SUBTYPE_PARAM * gl_kock3_getSubtypeParam( uint8 subtypeCode)
{
	SUBTYPE_PARAM * subTable = (SUBTYPE_PARAM *) gl_kock3_getSubtypeTable(NULL);
	for(int i = 0; i < MAX_SUBTYPE_COUNT; i++)
	{
		if((subTable[i].used) && (subTable[i].subtypeCode ==  subtypeCode))
			return &subTable[i];
	}

    return NULL;
}

void * gl_kock3_getDivisionTable(int *len,uint64 issueNum)
{
	if (len != NULL)
        *len = sizeof(DIVISION_PARAM) * MAX_DIVISION_COUNT;

	DIVISION_PARAM *divisionParam =(DIVISION_PARAM *)(kock3_plugin_info.division_info);

	ISSUE_INFO *allIssueInfo = gl_kock3_getIssueTable();

	int idx = 0;

	if(issueNum > 0)
	{
		for(idx = 0; idx < totalIssueCount ; idx++)
		{
			if(allIssueInfo[idx].used)
			{
				if(allIssueInfo[idx].issueNumber == issueNum)
				{
					break;
				}
			}
		}

		divisionParam =(DIVISION_PARAM *)((char *)kock3_plugin_info.division_info + sizeof(DIVISION_PARAM) * MAX_DIVISION_COUNT * idx);

	}

    return (void *)divisionParam;
}

DIVISION_PARAM * gl_kock3_getDivisionParam( uint8 divisionCode)
{
	DIVISION_PARAM * divisionTable = (DIVISION_PARAM *)gl_kock3_getDivisionTable(NULL,0);
	for(int i = 0; i < MAX_DIVISION_COUNT; i++)
	{
		if((divisionTable[i].used) && (divisionTable[i].divisionCode == divisionCode))
				return &divisionTable[i];
	}

	return NULL;
}

PRIZE_PARAM * gl_kock3_getPrizeTable(uint64 issueNum)
{
	if(issueNum == 0)
	    return  (PRIZE_PARAM *)((char *)kock3_plugin_info.prize_info);

	int idx = 0;
	int ret = 0;
	ISSUE_INFO * issueTable = gl_kock3_getIssueTable();
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
	return  (PRIZE_PARAM *)((char *)kock3_plugin_info.prize_info + sizeof(PRIZE_PARAM) * idx * MAX_PRIZE_COUNT);
}


POOL_PARAM *gl_kock3_getPoolParam(void)
{
	return (POOL_PARAM*) kock3_plugin_info.pool_info;
}

void *gl_kock3_getRkTable(void)
{
	return kock3_plugin_info.rk_info;
}

int gl_kock3_getSingleAmount(char *buffer, size_t len)
{
	char tmp[256] = {0};

	for (uint8 subtype = SUBTYPE_ZX; subtype <= SUBTYPE_2DS; subtype++)
	{
	    SUBTYPE_PARAM *subParam = gl_kock3_getSubtypeParam(subtype);
	    sprintf(tmp, "%s%s=%d", tmp, subtypeAbbr[GAME_KOCK3][subtype], subParam->singleAmount);

	    if (subtype != SUBTYPE_2DS)
	    {
	        strcat(tmp, ",");
	    }
	}

	if (strlen(tmp) + 1 > len)
	{
	    log_error("gl_kock3_getSingleAmount() len not enough.");
        return -1;
	}
	memcpy(buffer, tmp, strlen(tmp)+1);

	return 0;
}

ISSUE_INFO *gl_kock3_getIssueTable(void)
{
	return (ISSUE_INFO*) kock3_plugin_info.issue_info;
}

int get_kock3_issueMaxCount(void)
{
    return totalIssueCount;
}

int get_kock3_issueCount(void)
{
	int ret = 0;
	ISSUE_INFO *issueTable = gl_kock3_getIssueTable();
	for(int i = 0; i < totalIssueCount; i++)
	{
		if((issueTable[i].used) && (issueTable[i].curState < ISSUE_STATE_ISSUE_END))
			ret++;
	}
    return ret;
}



PRIZE_PARAM * gl_kock3_getPrizeTableBegin(void)
{
	return  (PRIZE_PARAM *) kock3_plugin_info.prize_info;
}

bool gl_kock3_load_memdata(void)
{
	//SUBTYPE
	SUBTYPE_PARAM *subParam = (SUBTYPE_PARAM*)gl_kock3_getSubtypeTable(NULL);

	SUBTYPE_PARAM subtype_param[MAX_SUBTYPE_COUNT] = {
		{false,0,            "",     "",         0,          0, 0, 0, 0},
		{true, SUBTYPE_ZX,  "ZX",  "直选",    0, 1, 0, 9, 1000},
		{true, SUBTYPE_3TA,  "3TA",  "三同号通选",    0, 1, 0, 9, 1000},
		{true, SUBTYPE_3TS,  "3TS",  "三同号单选",  0, 1, 0, 9, 1000},
		{true, SUBTYPE_3QA,  "3QA",  "三连号通选",    0, 1, 0, 9, 1000},
		{true, SUBTYPE_3DS,  "3DS",  "三不同单选",    0, 1, 0, 9, 1000},
		{true, SUBTYPE_2TA,  "2TA",  "二同号复选",    0, 1, 0, 9, 1000},
		{true, SUBTYPE_2TS,  "2TS",  "二同号单选",    0, 1, 0, 9, 1000},
		{true, SUBTYPE_2DS,  "2DS",  "二不同单选",    0, 1, 0, 9, 1000},

	};
	memcpy( subParam, subtype_param, sizeof(subtype_param) );

    //DIVISION

	DIVISION_PARAM div_param[MAX_DIVISION_COUNT] = {

		{true, 1,  "三同号单选",     PRIZE_3TS,     SUBTYPE_3TS,   1,    3},

		{true, 2,  "直选和值3和18",     PRIZE_ZX_HZ_3_18,     SUBTYPE_ZX,   1,    15},

		{true, 3,  "二同号单选",   PRIZE_2TS,     SUBTYPE_2TS,   2,    3},

		{true, 4,  "直选和值4和17",     PRIZE_ZX_HZ_4_17,     SUBTYPE_ZX,   1,    13},

		{true, 5,  "三同号通选",     PRIZE_3TA,     SUBTYPE_3TA,   1,    3},

		{true, 6,  "直选和值5和16",   PRIZE_ZX_HZ_5_16,     SUBTYPE_ZX,   1,    11},

		{true, 7,  "三不同单选",     PRIZE_3DS,     SUBTYPE_3DS,   3,    3},

		{true, 8,  "直选和值6和15",     PRIZE_ZX_HZ_6_15,     SUBTYPE_ZX,   1,    9},

		{true, 9,  "直选和值7和14",     PRIZE_ZX_HZ_7_14,     SUBTYPE_ZX,   1,    7},

		{true, 10,  "二同号复选",     PRIZE_2TA,     SUBTYPE_2TA,   2,    2},

		{true, 11,  "直选和值8和13",     PRIZE_ZX_HZ_8_13,     SUBTYPE_ZX,   1,    5},

		{true, 12,  "三连号通选",     PRIZE_3QA,     SUBTYPE_3QA,   3,    3},

		{true, 13,  "直选和值9和12",     PRIZE_ZX_HZ_9_12,     SUBTYPE_ZX,   1,    3},

		{true, 14,  "直选和值10和11",     PRIZE_ZX_HZ_10_11,     SUBTYPE_ZX,   1,    1},

		{true, 15,  "二不同单选",     PRIZE_2DS,     SUBTYPE_2DS,   2,    2},
	};

	DIVISION_PARAM *divParam = (DIVISION_PARAM*)gl_kock3_getDivisionTable(NULL,0);
	memcpy( divParam, div_param, sizeof(div_param) );
	for(int i = 0; i < totalIssueCount * MAX_DIVISION_COUNT; i = i + MAX_DIVISION_COUNT)
	{
	    memcpy( &divParam[i], div_param, sizeof(div_param) );
	}

    //PRIZE
	PRIZE_PARAM prize_param[MAX_PRIZE_COUNT] = {
		{false, 0,            " ",              false, ASSIGN_UNUSED, {0}},
		{true, PRIZE_3TS,     "三同号单选",       true,  ASSIGN_FIXED, {240}},
		{true, PRIZE_ZX_HZ_3_18,     "直选和值3和18",         false, ASSIGN_FIXED, {240}},
		{true, PRIZE_2TS,     "二同号单选",         false, ASSIGN_FIXED, {80}},
		{true, PRIZE_ZX_HZ_4_17,  "直选和值4和17",  true,  ASSIGN_FIXED, {80}},
		{true, PRIZE_3TA,  "三同号通选",    false, ASSIGN_FIXED, {40}},
		{true, PRIZE_ZX_HZ_5_16,  "直选和值5和16",    false, ASSIGN_FIXED, {40}},
		{true, PRIZE_3DS,      "三不同单选",           false, ASSIGN_FIXED, {40}},
		{true, PRIZE_ZX_HZ_6_15,      "直选和值6和15",           false, ASSIGN_FIXED, {25}},
		{true, PRIZE_ZX_HZ_7_14,      "直选和值7和14",           false, ASSIGN_FIXED, {16}},
		{true, PRIZE_2TA,      "二同号复选",           false, ASSIGN_FIXED, {15}},
		{true, PRIZE_ZX_HZ_8_13,   "直选和值8和13",     false, ASSIGN_FIXED, {12}},
		{true, PRIZE_3QA,   "三连号通选",     false, ASSIGN_FIXED, {10}},
		{true, PRIZE_ZX_HZ_9_12,   "直选和值9和12",     false, ASSIGN_FIXED, {10}},
		{true, PRIZE_ZX_HZ_10_11,   "直选和值10和11",     false, ASSIGN_FIXED, {9}},
		{true, PRIZE_2DS,   "二不同单选",     false, ASSIGN_FIXED, {8}},

	};

	PRIZE_PARAM *prizeTable = gl_kock3_getPrizeTableBegin();
	for(int i = 0; i < totalIssueCount * MAX_PRIZE_COUNT; i = i + MAX_PRIZE_COUNT)
	{
	    memcpy( &prizeTable[i], prize_param, sizeof(prize_param) );
	}

	//POOL
	POOL_PARAM *poolParam = gl_kock3_getPoolParam();

	POOL_PARAM pool_param = {"奖池", 0};
	memcpy( poolParam, &pool_param, sizeof(pool_param) );

    //GAME_RK
    if (!gl_kock3_rk_init())
    {
        log_error("gl_kock3_rk_init() failure.");
        return false;
    }


	log_info("KOCK3 load memory Finish!");
	return true;
}

int gl_kock3_load_newIssueData(void *issueBuffer, int32 issueCount)
{
	ISSUE_CFG_DATA *issueBuf = (ISSUE_CFG_DATA *)issueBuffer;

	ISSUE_INFO *issueInfo = gl_kock3_getIssueTable();

	if(issueInfo == NULL)
	{
		log_error("gl_kock3_load_newIssueData: gl_kock3_getIssueTable is NULL!");
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

int gl_kock3_load_oldIssueData(void *issueBuffer, int32 issueCount)
{
	ISSUE_INFO *issueBuf = (ISSUE_INFO *)issueBuffer;

	ISSUE_INFO *issueInfo = gl_kock3_getIssueTable();

	if(issueInfo == NULL)
	{
		log_error("gl_kock3_load_oldIssueData: gl_kock3_getIssueTable is NULL!");
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


ISSUE_INFO* gl_kock3_get_currIssue(void)
{
	ISSUE_INFO *allIssueInfo = gl_kock3_getIssueTable();

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

ISSUE_INFO* gl_kock3_get_issueInfo(uint64 issueNum)
{
	ISSUE_INFO *allIssueInfo = gl_kock3_getIssueTable();

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

ISSUE_INFO* gl_kock3_get_issueInfo2(uint32 issueSerial)
{
	ISSUE_INFO *allIssueInfo = gl_kock3_getIssueTable();

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

ISSUE_INFO* gl_kock3_get_issueInfoByIndex(int idx)
{
	ISSUE_INFO *allIssueInfo = gl_kock3_getIssueTable();

    if(idx < totalIssueCount)
    	return &(allIssueInfo[idx]);
    else
	    return NULL;
}

uint32 gl_kock3_get_issueMaxSeq(void)
{
	uint32 seq = 0;
	ISSUE_INFO *allIssueInfo = gl_kock3_getIssueTable();

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

bool gl_kock3_del_issue(uint64 issueNum)
{
	ISSUE_INFO* issueInfo = gl_kock3_get_issueInfo(issueNum);
	if(issueInfo == NULL)
	{
		log_info("gl_kock3_del_issue: issueNum[%lld] not find",issueNum);
		return true;
	}

	if(issueInfo->localState > ISSUE_STATE_RANGED)
		return false;
	else
	{
		issueInfo->used = false;

		ISSUE_INFO *allIssueInfo = gl_kock3_getIssueTable();

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

bool gl_kock3_clear_oneIssueData(uint64 issueNum)
{
	ISSUE_INFO *allIssueInfo = gl_kock3_getIssueTable();

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

bool gl_kock3_chkp_saveData(const char *filePath)
{
    GL_ISSUE_CHKP_DATA data;
    memset(&data, 0, sizeof(GL_ISSUE_CHKP_DATA));
    ISSUE_INFO *issue_chkp = NULL;
    ISSUE_INFO *issueInfo = gl_kock3_getIssueTable();

    for(int i = 0; i < kock3_plugin_info.issueCount; i++)
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
    sprintf(fileName, "%s/kock3_issue.snapshot", filePath);
    if((fp = open(fileName,O_CREAT|O_WRONLY,S_IRUSR )) < 0 )
    {
    	log_error("open %s error!",fileName);
    	return false;
    }
    ssize_t ret = write(fp, (const void *)&data, sizeof(GL_ISSUE_CHKP_DATA));
    if(ret < 0)
    {
    	log_error("write %s error errno[%d]",fileName, errno);
        return false;
    }
    close(fp);

    return gl_kock3_rk_saveData(filePath);

}

bool gl_kock3_chkp_restoreData(const char *filePath)
{
    GL_ISSUE_CHKP_DATA data;

    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName, "%s/kock3_issue.snapshot", filePath);
    if (access(fileName, 0) != 0)
    {
        log_warn("%s doesn't exist.", fileName);
        return true;
    }
    if((fp = open(fileName,O_RDONLY )) < 0 )
    {
    	log_error("open %s error!", fileName);
    	return false;
    }
    ssize_t ret = read(fp, (void *)&data, sizeof(GL_ISSUE_CHKP_DATA));
    if(ret < 0)
    {
    	log_error("read %s error errno[%d]",fileName,errno);
        return false;
    }
    close(fp);

    ISSUE_INFO *issue_chkp = NULL;

    ISSUE_INFO *issueInfo = NULL;

    for(int i = 0; i < kock3_plugin_info.issueCount; i++)
    {
        issue_chkp = &data.issueData[i];
        if(!issue_chkp->used)
            continue;

        issueInfo = gl_kock3_get_issueInfo2(issue_chkp->serialNumber);
        if (NULL == issueInfo)
        {
            log_warn("tms chkp_restore() gl_kock3_get_issueInfo2[%d]", issue_chkp->serialNumber);
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
    if(isGameBeRiskControl(GAME_KOCK3))
        return gl_kock3_rk_restoreData(filePath);
    return true;
}



bool gl_kock3_loadPrizeTable(uint64 issue,PRIZE_PARAM_ISSUE *prize)
{
	PRIZE_PARAM *prizeMem = gl_kock3_getPrizeTable(issue);
	if(prizeMem == NULL)
	{
    	log_error("gl_kock3_getPrizeTable issue[%lld] no find",issue);
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

void *gl_kock3_get_rkIssueDataTable(void)
{
	return (void *)rk_kock3_issueData;
}


// buf: 投注行号码区(不包含括号)
// length: buf的长度
// mode: bitmap的模式
// betline: 结果存入betline
int gl_kock3_format_ticket(char* buf, uint32 length, int mode, BETLINE* betline)
{
	ts_notused(length);
    GL_BETPART *bp = (GL_BETPART*)betline->bitmap;

    int ret = 0;

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
		ret = num2bit((uint8*)bpStr.bpAE[0], bpStr.bpAECnt[0], bp->bitmap, 0, base);
        if (ret != 0) {
            return -1;
        }
	} else if (mode == MODE_JS) {
		sizeA = 1;

		bp->mode = mode;
		bp->size = sizeA;
		bp->bitmap[0] = bpStr.bpAE[0][0];
	} else if (mode == MODE_FD) {
		sizeA = bpStr.bpALLCnt * 2;
		for (int k = 0; k < bpStr.bpALLCnt; k++) {
			ret = num2bit((uint8*)(bpStr.bpAE + k), bpStr.bpAECnt[k], bp->bitmap, k * 2, base);
	        if (ret != 0) {
	            return -1;
	        }
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
	betline->betCount = 1;

	SUBTYPE_PARAM* subtype = gl_kock3_getSubtypeParam(betline->subtype);
	if (subtype != NULL)
	{
		betline->singleAmount = subtype->singleAmount;
	} else
	{
		log_error("gl_kock3_getSubtypeParam is NULL!!!");
		return -1;
	}

	return 0;
}











