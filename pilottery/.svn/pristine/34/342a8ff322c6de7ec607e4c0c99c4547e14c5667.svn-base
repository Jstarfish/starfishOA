/*
 * gl_tema_db.cpp
 *
 *  Created on: 2011-6-30
 *      Author: Administrator
 */

#include "global.h"
#include "gl_inf.h"

#include "gl_tema_db.h"
#include "gl_tema_verify.h"
#include "gl_tema_rk.h"

#define GL_TEMA_SHM_KEY     (GL_SHM_KEY + GAME_TEMA)

#define SHARE_MEM_REDUN  32

static GL_PLUGIN_INFO tema_plugin_info;
static void * tema_plugin_info_ptr = NULL;


extern GAME_RISK_TEMA_ISSUE_DATA *rk_tema_issueData;
extern ISSUE_INFO *tema_issue_info;
extern int totalIssueCount;


bool gl_tema_mem_creat(int issue_count)
{
    ts_notused(issue_count);
    int32 ret = -1;
    IPCKEY keyid;

    int ncGlobalLen = sizeof(int) +
            sizeof(SUBTYPE_PARAM) * MAX_SUBTYPE_COUNT +
            sizeof(DIVISION_PARAM) * MAX_DIVISION_COUNT +
            sizeof(ISSUE_INFO) * issue_count +
            sizeof(PRIZE_PARAM) * issue_count * MAX_PRIZE_COUNT +
            sizeof(POOL_PARAM) +
            sizeof(GAME_RISK_TEMA_ISSUE_DATA) * issue_count +
            SHARE_MEM_REDUN;


    keyid = ipcs_shmkey(GL_TEMA_SHM_KEY);

    int ncGlobalMem = sysv_get_shm(keyid, ncGlobalLen, IPC_CREAT | IPC_EXCL | 0644);
    if (-1 == ncGlobalMem) {
        log_error("gl_tema_mem_creat::create globalSection(gl) failure");

        return false;
    }

    void *tema_plugin_info_ptr = sysv_attach_shm(ncGlobalMem, 0, 0);
    if ((void*) -1 == tema_plugin_info_ptr) {
        log_error("gl_tema_mem_creat::attach globalSection(gl) failure.");

        return false;
    }

    memset(tema_plugin_info_ptr, 0, ncGlobalLen);

    *((int *) tema_plugin_info_ptr) = issue_count;
    ret = sysv_detach_shm(tema_plugin_info_ptr);
    if (ret < 0) {
        log_error("gl_tema_mem_creat:deattach globalSection(gl) failure.");

        return false;
    }

    log_info("gl_tema_mem_creat success! shm_key[%#x] shm_id[%d] size[%d]", keyid, ncGlobalMem, ncGlobalLen);
	return true;
}

bool gl_tema_mem_destroy(void)
{
    int32 ret = -1;

    IPCKEY keyid;

    keyid = ipcs_shmkey(GL_TEMA_SHM_KEY);

    int ncGlobalMem = sysv_get_shm(keyid, 0, 0);
    if (-1 == ncGlobalMem) {
        log_error("gl_tema_mem_destroy::open globalSection(gl) failure.");

        return false;
    }

    ret = sysv_ctl_shm(ncGlobalMem, IPC_RMID, NULL);
    if (ret < 0) {
        log_error("gl_tema_mem_destroy:delete globalSection(gl) failure.");

        return false;
    }

    log_info("gl_tema_mem_destroy success!");
	return true;
}

bool gl_tema_mem_attach(void)
{
    if (NULL != tema_plugin_info_ptr) {
        log_notice("tema share memory had attached already.");

        return true;
    }

    IPCKEY keyid;

    keyid = ipcs_shmkey(GL_TEMA_SHM_KEY);
    int ncGlobalMem = sysv_get_shm(keyid, 0, 0);
    if (-1 == ncGlobalMem) {
        log_error("gl_tema_mem_attach::open globalSection(gl) failure.");

        return false;
    }

    tema_plugin_info_ptr =  sysv_attach_shm(ncGlobalMem, 0, 0);
    if ((void *) -1 == tema_plugin_info_ptr) {
        log_error("gl_tema_mem_attach::attach globalSection(gl) failure.");
        tema_plugin_info_ptr = NULL;

        return false;
    }

    tema_plugin_info.issueCount = *(int *)tema_plugin_info_ptr;

    tema_plugin_info.subtype_info = (char *)tema_plugin_info_ptr + sizeof(int);

    tema_plugin_info.division_info = (char *)tema_plugin_info.subtype_info + sizeof(SUBTYPE_PARAM) * MAX_SUBTYPE_COUNT;

    tema_plugin_info.issue_info = (char *)tema_plugin_info.division_info + sizeof(DIVISION_PARAM) * MAX_DIVISION_COUNT;

    tema_plugin_info.prize_info = (char *)tema_plugin_info.issue_info + sizeof(ISSUE_INFO) * tema_plugin_info.issueCount;

    tema_plugin_info.pool_info = (char *)tema_plugin_info.prize_info + sizeof(PRIZE_PARAM) * MAX_PRIZE_COUNT * tema_plugin_info.issueCount;

    tema_plugin_info.rk_info = (char *)tema_plugin_info.pool_info + sizeof(POOL_PARAM);

    rk_tema_issueData = (GAME_RISK_TEMA_ISSUE_DATA *)(tema_plugin_info.rk_info);

    tema_issue_info = (ISSUE_INFO *)(tema_plugin_info.issue_info);

    totalIssueCount = tema_plugin_info.issueCount;

    return true;
}

bool gl_tema_mem_detach(void)
{
    int32 ret = -1;

    if (NULL == tema_plugin_info_ptr) {
        log_notice("gl_tema_mem_detach::globalSection(gl) pointer is NULL;");

        return true;
    }

    ret = sysv_detach_shm(tema_plugin_info_ptr);
    if (ret < 0) {
        log_error("gl_tema_mem_detach:deattach globalSection(gl) failure.");

        return false;
    }

    tema_plugin_info_ptr = NULL;

    return true;
}


void *gl_tema_get_mem_db(void)
{
    return tema_plugin_info_ptr;
}



void* gl_tema_getSubtypeTable(int *len)
{
    if (NULL != len)
        *len = sizeof(SUBTYPE_PARAM) * MAX_SUBTYPE_COUNT;
	return tema_plugin_info.subtype_info;
}

SUBTYPE_PARAM* gl_tema_getSubtypeParam(uint8 subtypeCode)
{
	SUBTYPE_PARAM * subTable = (SUBTYPE_PARAM *) gl_tema_getSubtypeTable(NULL);
	for(int i = 0; i < MAX_SUBTYPE_COUNT; i++)
	{
		if((subTable[i].used) && (subTable[i].subtypeCode ==  subtypeCode))
			return &subTable[i];
	}

    return NULL;
}

void *gl_tema_getDivisionTable(int *len, uint64 issueNumber)
{
    ts_notused(issueNumber);
	if (NULL != len)
        *len = sizeof(DIVISION_PARAM) * MAX_DIVISION_COUNT;
    return tema_plugin_info.division_info;
}

DIVISION_PARAM *gl_tema_getDivisionParam(uint8 divCode)
{
	DIVISION_PARAM * divisionTable = (DIVISION_PARAM *)gl_tema_getDivisionTable(NULL,0);
	for(int i = 0; i < MAX_DIVISION_COUNT; i++)
	{
		if((divisionTable[i].used) && (divisionTable[i].divisionCode == divCode))
				return &divisionTable[i];
	}

	return NULL;
}

PRIZE_PARAM *gl_tema_getPrizeTable(uint64 issueNum)
{
	if (issueNum == 0)
	{
	    return  (PRIZE_PARAM *)((char *)tema_plugin_info.prize_info);
	}

	int idx = 0;
	int ret = 0;
	ISSUE_INFO * issueTable = gl_tema_getIssueTable();
	for(; idx < tema_plugin_info.issueCount; idx++ )
	{
		if((issueTable[idx].used) && (issueTable[idx].issueNumber == issueNum))
		{
			ret++;
			break;
		}
	}
	if(ret == 0)
		return NULL;
	return  (PRIZE_PARAM *)((char *)tema_plugin_info.prize_info + sizeof(PRIZE_PARAM) * idx * MAX_PRIZE_COUNT);

}

void *gl_tema_getRkTable(void)
{
	return tema_plugin_info.rk_info;
}

POOL_PARAM* gl_tema_getPoolParam(void)
{
	return (POOL_PARAM*) tema_plugin_info.pool_info;
}

int gl_tema_getSingleAmount(char *buffer, size_t len)
{
    if (buffer == NULL)
    {
        log_error("buffer is NULL");
        return -1;
    }

	char tmp[256] = {0};

	for (uint8 subtype = SUBTYPE_DG; subtype <= SUBTYPE_WH; subtype++)
	{
	    SUBTYPE_PARAM *subParam = gl_tema_getSubtypeParam(subtype);
	    sprintf(tmp, "%s%s=%d", tmp, subtypeAbbr[GAME_TEMA][subtype], subParam->singleAmount);

	    if (subtype != SUBTYPE_WH)
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

PRIZE_PARAM * gl_tema_getPrizeTableBegin(void)
{
	return  (PRIZE_PARAM *) tema_plugin_info.prize_info;
}

ISSUE_INFO *gl_tema_getIssueTable(void)
{
    return (ISSUE_INFO*) tema_plugin_info.issue_info;
}

int get_tema_issueMaxCount(void)
{
    return tema_plugin_info.issueCount;
}

int get_tema_issueCount(void)
{
	int ret = 0;
	ISSUE_INFO *issueTable = gl_tema_getIssueTable();
	for(int i = 0; i < totalIssueCount; i++)
	{
		if((issueTable[i].used) && (issueTable[i].curState < ISSUE_STATE_ISSUE_END))
			ret++;
	}
    return ret;
}



bool gl_tema_load_memdata(void)
{
    //SUBTYPE
	SUBTYPE_PARAM *subParam = (SUBTYPE_PARAM*)gl_tema_getSubtypeTable(NULL);

	SUBTYPE_PARAM subtype_param[MAX_SUBTYPE_COUNT] = {
		{false,0,          "",   "",         0,          0, 0,  0, 0,  0},
		{true, SUBTYPE_DG, "DG", "数字玩法", 4294967295, 1, 40, 1, 40, 1000},
		{true, SUBTYPE_WH, "WH", "季节玩法",  4294967295, 1, 4, 1, 4, 1000}

	};
	memcpy( subParam, subtype_param, sizeof(subtype_param) );

    //DIVISION
	DIVISION_PARAM *divParam = (DIVISION_PARAM*)gl_tema_getDivisionTable(NULL,0);

	DIVISION_PARAM div_param[MAX_DIVISION_COUNT] = {
		{true, 0,  "数字玩法",      PRIZE_1,   SUBTYPE_DG,  1, 40, 1},
		{true, 1,  "季节玩法",      PRIZE_2,   SUBTYPE_WH,  1, 4, 1},
	};
	memcpy( divParam, div_param, sizeof(div_param) );

    //PRIZE
	PRIZE_PARAM prize_param[MAX_PRIZE_COUNT] = {
		{false,0,           " ",         false,  ASSIGN_UNUSED, {0}},
		{true, PRIZE_1,     "数字玩法奖级",    false,  ASSIGN_FIXED,  {1000*32}},
		{true, PRIZE_2,     "季节玩法奖级",    false,  ASSIGN_FIXED,  {1000*3}}
	};

	PRIZE_PARAM *prizeTable = gl_tema_getPrizeTableBegin();
	for(int i = 0; i < totalIssueCount * MAX_PRIZE_COUNT; i = i + MAX_PRIZE_COUNT)
	{
	    memcpy( &prizeTable[i], prize_param, sizeof(prize_param) );
	}

	//POOL
	POOL_PARAM *poolParam = gl_tema_getPoolParam();

	POOL_PARAM pool_param = {"奖池", 0};
	memcpy( poolParam, &pool_param, sizeof(pool_param) );

	log_info("tema load memory Finish!");
	return true;
}


int gl_tema_load_newIssueData(void *issueBuffer, int32 issueCount)
{
	ISSUE_CFG_DATA *issueBuf = (ISSUE_CFG_DATA *)issueBuffer;
	int maxIssueCount =  get_tema_issueMaxCount();

	ISSUE_INFO *issueInfo = gl_tema_getIssueTable();

	if(issueInfo == NULL)
	{
		log_error("gl_tema_load_newIssueData: get_tema_issueTable is NULL!");
		return 0;
	}

    int i,j;

    for(j = 0; j < issueCount; j++)
    {
	    for(i=0; i < maxIssueCount ; i++)
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
		        issueInfo[i].used = true;
		        break;
		    }
		}
        if(maxIssueCount == i)
        {
        	log_info("gl_tema_load_newIssueData: no issue is unused");
        	break;
        }
	}

	return j;
}


int gl_tema_load_oldIssueData(void *issueBuffer, int32 issueCount)
{
	ISSUE_INFO *issueBuf = (ISSUE_INFO *)issueBuffer;
	int maxIssueCount =  get_tema_issueMaxCount();

	ISSUE_INFO *issueInfo = gl_tema_getIssueTable();

	if(issueInfo == NULL)
	{
		log_error("gl_tema_load_oldIssueData: get_tema_issueTable is NULL!");
		return 0;
	}

    int i,j;

    for(j = 0; j < issueCount; j++)
    {
	    for(i = 0; i < maxIssueCount ; i++)
	    {

		    if(!issueInfo[i].used)
		    {
		    	memcpy((void *)&issueInfo[i],(void *)&issueBuf[j],sizeof(ISSUE_INFO));
		        issueInfo[i].used = true;
		        break;
		    }
		}
        if(maxIssueCount == i)
        {
        	log_info("gl_tema_load_oldIssueData: no issue is unused");
        	break;
        }
	}

	return j;
}



ISSUE_INFO* gl_tema_get_currIssue(void)
{
	ISSUE_INFO *allIssueInfo = gl_tema_getIssueTable();
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

ISSUE_INFO* gl_tema_get_issueInfo(uint64 issueNum)
{
    if (issueNum == 0)
    {
        log_error("issueNum is 0");
        return NULL;
    }

	ISSUE_INFO *allIssueInfo = gl_tema_getIssueTable();

	for(int i = 0; i < totalIssueCount ; i++)
	{
		if(allIssueInfo[i].used)
		{
			if(allIssueInfo[i].issueNumber == issueNum)
				return &(allIssueInfo[i]);
		}
	}

	return NULL;
}

ISSUE_INFO* gl_tema_get_issueInfo2(uint32 issueSerial)
{
    if (issueSerial == 0)
    {
        log_debug("issueSerial is 0");
        return NULL;
    }

	ISSUE_INFO *allIssueInfo = gl_tema_getIssueTable();

	for(int i = 0; i < totalIssueCount ; i++)
	{
		if(allIssueInfo[i].used)
		{
			if(allIssueInfo[i].serialNumber == issueSerial)
				return &(allIssueInfo[i]);
		}
	}

	return NULL;
}

uint32 gl_tema_get_issueMaxSeq(void)
{
	uint32 seq = 0;
	ISSUE_INFO *allIssueInfo = gl_tema_getIssueTable();

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

bool gl_tema_del_issue(uint64 issueNum)
{
	ISSUE_INFO* issueInfo = gl_tema_get_issueInfo(issueNum);
	if(issueInfo == NULL)
	{
		log_info("gl_tema_del_issue: issueNum[%lld] not find",issueNum);
		return true;
	}

	if(issueInfo->localState > ISSUE_STATE_RANGED)
		return false;
	else
	{
		issueInfo->used = false;

		ISSUE_INFO *allIssueInfo = gl_tema_getIssueTable();

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

bool gl_tema_clear_oneIssueData(uint64 issueNum)
{
    if (issueNum == 0)
    {
        log_error("issueNum is 0");
        return false;
    }

	ISSUE_INFO *allIssueInfo = gl_tema_getIssueTable();

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


bool gl_tema_chkp_saveData(const char *filePath)
{
    GL_ISSUE_CHKP_DATA data;
    memset(&data, 0, sizeof(GL_ISSUE_CHKP_DATA));
    ISSUE_INFO *issue_chkp = NULL;
    ISSUE_INFO *issueInfo = gl_tema_getIssueTable();

    for(int i = 0; i < totalIssueCount; i++)
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
    sprintf(fileName, "%s/tema_issue.snapshot", filePath);
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

    return gl_tema_rk_saveData(filePath);

}

bool gl_tema_chkp_restoreData(const char *filePath)
{
    GL_ISSUE_CHKP_DATA data;

    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName, "%s/tema_issue.snapshot", filePath);
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

    for(int i = 0; i < totalIssueCount; i++)
    {
        issue_chkp = &data.issueData[i];
        if(!issue_chkp->used)
            continue;

        issueInfo = gl_tema_get_issueInfo2(issue_chkp->serialNumber);
        if (NULL == issueInfo)
        {
            log_warn("tms chkp_restore() gl_tema_get_issueInfo2[%d]", issue_chkp->serialNumber);
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

    if(isGameBeRiskControl(GAME_TEMA))
        return gl_tema_rk_restoreData(filePath);
    return true;
}


bool gl_tema_loadPrizeTable(uint64 issue,PRIZE_PARAM_ISSUE *prize)
{
	PRIZE_PARAM *prizeMem = gl_tema_getPrizeTable(issue);
	if(prizeMem == NULL)
	{
    	log_error("gl_tema_loadPrizeTable issue[%lld] no find",issue);
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

// buf: 投注行号码区(不包含括号)
// length: buf的长度
// mode: bitmap的模式
// betline: 结果存入betline
int gl_tema_format_ticket(char* buf, uint32 length, int mode, BETLINE* betline)
{
	ts_notused(length);

    //uint8 bek2pe = betline->bek2pe & 0x0f;
    GL_BETPART *bp = (GL_BETPART*)betline->bitmap;

    int ret = 0;

	BETPART_STR bpStr;
	memset(&bpStr, 0, sizeof(bpStr));
	splitBetpart(buf, &bpStr);

    int base = 1;
    int sizeA = 0;

	{
		sizeA = 6;

		bp->mode = mode;
		bp->size = sizeA;
		ret = num2bit((uint8*)bpStr.bpAE[0], bpStr.bpAECnt[0], bp->bitmap, 0, base);
        if (ret != 0) {
            return -1;
        }
	}

	betline->bitmapLen = 2 + sizeA;
	betline->betCount = gl_tema_betlineCount(betline);

	SUBTYPE_PARAM* subtype = gl_tema_getSubtypeParam(betline->subtype);
	if (subtype != NULL)
	{
		betline->singleAmount = subtype->singleAmount;
	} 
    else
	{
		log_error("gl_tema_getSubtypeParam is NULL!!!");
		return -1;
	}

	return 0;
}


ISSUE_INFO* gl_tema_get_issueInfoByIndex(int idx)
{
	ISSUE_INFO *allIssueInfo = gl_tema_getIssueTable();

    if(idx < totalIssueCount)
    	return &(allIssueInfo[idx]);
    else
	    return NULL;
}


void *gl_tema_get_rkIssueDataTable(void)
{
	return (void *)rk_tema_issueData;
}


