#include "global.h"
#include "gl_inf.h"

#include "gl_koc11x5_db.h"
#include "gl_koc11x5_verify.h"
#include "gl_koc11x5_betcount.h"
#include "gl_koc11x5_rk.h"



#define GL_KOC11X5_SHM_KEY      (GL_SHM_KEY + GAME_KOC11X5)

#define SHARE_MEM_REDUN  32


static int32 ncGlobalMem = 0;
static int32 ncGlobalLen = 0;

const int MAX_BUFSIZE = 2048;

static GL_PLUGIN_INFO koc11x5_plugin_info;

static void * koc11x5_plugin_info_ptr = NULL;


extern GAME_RISK_KOC11X5_ISSUE_DATA *rk_koc11x5_issueData;
extern GAME_KOC11X5_RK_INDEX *rk_koc11x5_idxTable;
extern ISSUE_INFO *koc11x5_issue_info;
extern int totalIssueCount;

/// share interface

bool gl_koc11x5_mem_creat(int issue_count)
{

	int32 ret = -1;
    IPCKEY keyid;

    ncGlobalLen = sizeof(int) +
            sizeof(SUBTYPE_PARAM) * MAX_SUBTYPE_COUNT +
            sizeof(DIVISION_PARAM) * issue_count * MAX_DIVISION_COUNT +
            sizeof(ISSUE_INFO) * issue_count +
            sizeof(PRIZE_PARAM) * issue_count * MAX_PRIZE_COUNT +
            sizeof(POOL_PARAM) +
            sizeof(GAME_RISK_KOC11X5_ISSUE_DATA) * issue_count +
            sizeof(GAME_KOC11X5_RK_INDEX) +
            SHARE_MEM_REDUN;

    //����keyid
    keyid = ipcs_shmkey(GL_KOC11X5_SHM_KEY);

    //���������ڴ�
    ncGlobalMem = sysv_get_shm(keyid, ncGlobalLen, IPC_CREAT | IPC_EXCL | 0644);
    if (-1 == ncGlobalMem)
    {
        log_error("gl_create::create globalSection(gl) failure");
        return false;
    }

    //�ڴ�ӳ��
    koc11x5_plugin_info_ptr = (signed char *) sysv_attach_shm(ncGlobalMem, 0, 0);
    if ((void*) -1 == koc11x5_plugin_info_ptr)
    {
        log_error("gl_create::attach globalSection(gl) failure.");
        return false;
    }

    //��ʼ�������ڴ�
    memset(koc11x5_plugin_info_ptr, 0, ncGlobalLen);
    *((int *) koc11x5_plugin_info_ptr) = issue_count;
    //

    //�Ͽ��빲���ڴ��ӳ��
    ret = sysv_detach_shm(koc11x5_plugin_info_ptr);
    if (ret < 0)
    {
        log_error("gl_create:deattach globalSection(gl) failure.");
        return false;
    }

    log_info("gl_koc11x5_mem_creat success! shm_key[%#x] shm_id[%d] size[%d] issueCount[%d]", keyid, ncGlobalMem, ncGlobalLen, issue_count);
    return true;
}

//ɾ�������ڴ�
bool gl_koc11x5_mem_destroy()
{
    int32 ret = -1;

    //������������ڴ��ɾ�������ڴ��ڲ�ͬ�������У���Ҫ������γ���
    IPCKEY keyid;

    keyid = ipcs_shmkey(GL_KOC11X5_SHM_KEY);

    ncGlobalMem = sysv_get_shm(keyid, 0, 0);
    //ncGlobalMem = sysv_get_shm(keyid, ncGlobalLen, IPC_CREAT|0644);
    if (-1 == ncGlobalMem)
    {
        log_error("gl_destroy::open globalSection(gl) failure.");
        return false;
    }

    //ɾ�������ڴ�
    ret = sysv_ctl_shm(ncGlobalMem, IPC_RMID, NULL);
    if (ret < 0)
    {
        log_error("gl_destroy:delete globalSection(gl) failure.");
        return false;
    }

    log_info("gl_koc11x5_mem_destroy success!");
    return true;
}

//ӳ�乲���ڴ���
bool gl_koc11x5_mem_attach()
{
    IPCKEY keyid;

    keyid = ipcs_shmkey(GL_KOC11X5_SHM_KEY);

    ncGlobalMem = sysv_get_shm(keyid, 0, 0);
    //ncGlobalMem = sysv_get_shm(keyid, ncGlobalLen, IPC_CREAT|0644);
    if (-1 == ncGlobalMem)
    {
        log_error("gl_init::open globalSection(gl) failure.");
        return false;
    }

    koc11x5_plugin_info_ptr =  sysv_attach_shm(ncGlobalMem, 0, 0);
    if ((signed char *) -1 == koc11x5_plugin_info_ptr)
    {
        log_error("gl_init::attach globalSection(gl) failure.");
        return false;
    }

    //��ʼ�����ݿ�ṹָ��
    koc11x5_plugin_info.issueCount = *(int *)koc11x5_plugin_info_ptr;

    koc11x5_plugin_info.subtype_info = (char *)koc11x5_plugin_info_ptr + sizeof(int);

    koc11x5_plugin_info.division_info = (char *)koc11x5_plugin_info.subtype_info + sizeof(SUBTYPE_PARAM) * MAX_SUBTYPE_COUNT;

    koc11x5_plugin_info.issue_info = (char *)koc11x5_plugin_info.division_info + sizeof(DIVISION_PARAM) * MAX_DIVISION_COUNT * koc11x5_plugin_info.issueCount;

    koc11x5_plugin_info.prize_info = (char *)koc11x5_plugin_info.issue_info + sizeof(ISSUE_INFO) * koc11x5_plugin_info.issueCount;

    koc11x5_plugin_info.pool_info = (char *)koc11x5_plugin_info.prize_info + sizeof(PRIZE_PARAM) * MAX_PRIZE_COUNT * koc11x5_plugin_info.issueCount;

    koc11x5_plugin_info.rk_info = (char *)koc11x5_plugin_info.pool_info + sizeof(POOL_PARAM);


    //////////////// rk globa /////////////////////////
	rk_koc11x5_issueData = (GAME_RISK_KOC11X5_ISSUE_DATA *)(koc11x5_plugin_info.rk_info);

	rk_koc11x5_idxTable = (GAME_KOC11X5_RK_INDEX *)((char *)koc11x5_plugin_info.rk_info + sizeof(GAME_RISK_KOC11X5_ISSUE_DATA) * koc11x5_plugin_info.issueCount);

	koc11x5_issue_info = (ISSUE_INFO *)(koc11x5_plugin_info.issue_info);

	totalIssueCount = koc11x5_plugin_info.issueCount;

    return true;
}

//�رչ����ڴ�����ӳ��
bool gl_koc11x5_mem_detach()
{
    int32 ret = -1;

    if (NULL == koc11x5_plugin_info_ptr)
    {
        log_error("gl_close::globalSection(gl) pointer is NULL;");
        return false;
    }

    //�Ͽ��빲���ڴ��ӳ��
    ret = sysv_detach_shm(koc11x5_plugin_info_ptr);
    if (ret < 0)
    {
        log_error("gl_close:deattach globalSection(gl) failure.");
        return false;
    }

    ncGlobalMem = 0;
    koc11x5_plugin_info_ptr = NULL;
    return true;
}


/*    next  no can see out of .so    */
void *gl_koc11x5_get_mem_db(void)
{
    return koc11x5_plugin_info_ptr;
}



void * gl_koc11x5_getSubtypeTable(int *len)
{
	if (len != NULL)
        *len = sizeof(SUBTYPE_PARAM) * MAX_SUBTYPE_COUNT;
    return koc11x5_plugin_info.subtype_info;
}

SUBTYPE_PARAM * gl_koc11x5_getSubtypeParam( uint8 subtypeCode)
{
	SUBTYPE_PARAM * subTable = (SUBTYPE_PARAM *) gl_koc11x5_getSubtypeTable(NULL);
	for(int i = 0; i < MAX_SUBTYPE_COUNT; i++)
	{
		if((subTable[i].used) && (subTable[i].subtypeCode ==  subtypeCode))
			return &subTable[i];
	}

    return NULL;
}

void * gl_koc11x5_getDivisionTable(int *len,uint64 issueNum)
{
	if (len != NULL)
        *len = sizeof(DIVISION_PARAM) * MAX_DIVISION_COUNT;

	DIVISION_PARAM *divisionParam =(DIVISION_PARAM *)(koc11x5_plugin_info.division_info);

	KOC11X5_CALC_PRIZE_PARAM calcParam;
	calcParam.specWinFlag = 0;

	ISSUE_INFO *allIssueInfo = gl_koc11x5_getIssueTable();

	int idx = 0;

	if(issueNum > 0)
	{
		for(idx = 0; idx < totalIssueCount ; idx++)
		{
			if(allIssueInfo[idx].used)
			{
				if(allIssueInfo[idx].issueNumber == issueNum)
				{
					gl_koc11x5_resolve_winStr(issueNum,(void *)&calcParam);
					break;
				}
			}
		}

		divisionParam =(DIVISION_PARAM *)((char *)koc11x5_plugin_info.division_info + sizeof(DIVISION_PARAM) * MAX_DIVISION_COUNT * idx);

	}

    return (void *)divisionParam;
}

DIVISION_PARAM * gl_koc11x5_getDivisionParam( uint8 divisionCode)
{
	DIVISION_PARAM * divisionTable = (DIVISION_PARAM *)gl_koc11x5_getDivisionTable(NULL,0);
	for(int i = 0; i < MAX_DIVISION_COUNT; i++)
	{
		if((divisionTable[i].used) && (divisionTable[i].divisionCode == divisionCode))
				return &divisionTable[i];
	}

	return NULL;
}

PRIZE_PARAM * gl_koc11x5_getPrizeTable(uint64 issueNum)
{
	if(issueNum == 0)
	    return  (PRIZE_PARAM *)((char *)koc11x5_plugin_info.prize_info);

	int idx = 0;
	int ret = 0;
	ISSUE_INFO * issueTable = gl_koc11x5_getIssueTable();
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
	return  (PRIZE_PARAM *)((char *)koc11x5_plugin_info.prize_info + sizeof(PRIZE_PARAM) * idx * MAX_PRIZE_COUNT);
}


POOL_PARAM *gl_koc11x5_getPoolParam(void)
{
	return (POOL_PARAM*) koc11x5_plugin_info.pool_info;
}

void *gl_koc11x5_getRkTable(void)
{
	return koc11x5_plugin_info.rk_info;
}

int gl_koc11x5_getSingleAmount(char *buffer, size_t len)
{
	char tmp[256] = {0};

	for (uint8 subtype = SUBTYPE_RX2; subtype <= SUBTYPE_Q3ZX; subtype++)
	{
	    SUBTYPE_PARAM *subParam = gl_koc11x5_getSubtypeParam(subtype);
	    sprintf(tmp, "%s%s=%d", tmp, subtypeAbbr[GAME_KOC11X5][subtype], subParam->singleAmount);

	    if (subtype != SUBTYPE_Q3ZX)
	    {
	        strcat(tmp, ",");
	    }
	}

	if (strlen(tmp) + 1 > len)
	{
	    log_error("gl_koc11x5_getSingleAmount() len not enough.");
        return -1;
	}
	memcpy(buffer, tmp, strlen(tmp)+1);

	return 0;
}

ISSUE_INFO *gl_koc11x5_getIssueTable(void)
{
	return (ISSUE_INFO*) koc11x5_plugin_info.issue_info;
}

int get_koc11x5_issueMaxCount(void)
{
    return totalIssueCount;
}

int get_koc11x5_issueCount(void)
{
	int ret = 0;
	ISSUE_INFO *issueTable = gl_koc11x5_getIssueTable();
	for(int i = 0; i < totalIssueCount; i++)
	{
		if((issueTable[i].used) && (issueTable[i].curState < ISSUE_STATE_ISSUE_END))
			ret++;
	}
    return ret;
}



PRIZE_PARAM * gl_koc11x5_getPrizeTableBegin(void)
{
	return  (PRIZE_PARAM *) koc11x5_plugin_info.prize_info;
}

bool gl_koc11x5_load_memdata(void)
{
	//SUBTYPE
	SUBTYPE_PARAM *subParam = (SUBTYPE_PARAM*)gl_koc11x5_getSubtypeTable(NULL);

	SUBTYPE_PARAM subtype_param[MAX_SUBTYPE_COUNT] = {
		{false,0,            "",     "",         0,          0, 0, 0, 0},
		{true, SUBTYPE_RX2,  "RX2",  "��ѡ��",    4294967295, 1, 1, 11, 1000},
		{true, SUBTYPE_RX3,  "RX3",  "��ѡ��",    4294967295, 1, 1, 11, 1000},
		{true, SUBTYPE_RX4,  "RX4",  "��ѡ��",  4294967295, 1, 1, 11, 1000},
		{true, SUBTYPE_RX5,  "RX5",  "��ѡ��",    4294967295, 1, 1, 11, 1000},
		{true, SUBTYPE_RX6,  "RX6",  "��ѡ��",    4294967295, 1, 1, 11, 1000},
		{true, SUBTYPE_RX7,  "RX7",  "��ѡ��",    4294967295, 1, 1, 11, 1000},
		{true, SUBTYPE_RX8,  "RX8",  "��ѡ��",    4294967295, 1, 1, 11, 1000},
		{true, SUBTYPE_Q1,  "Q1",  "ǰһ",    4294967295, 1, 1, 11, 1000 },
		{true, SUBTYPE_Q2ZU, "Q2ZU",  "ǰ����ѡ",    4294967295, 1, 1, 11, 1000 },
		{true, SUBTYPE_Q3ZU, "Q3ZU",  "ǰ����ѡ",    4294967295, 1, 1, 11, 1000 },
		{true, SUBTYPE_Q2ZX, "Q2ZX",  "ǰ��ֱѡ",    4294967295, 1, 1, 11, 1000 },
		{true, SUBTYPE_Q3ZX, "Q3ZX",  "ǰ��ֱѡ",    4294967295, 1, 1, 11, 1000 }

	};
	memcpy( subParam, subtype_param, sizeof(subtype_param) );

    //DIVISION


	DIVISION_PARAM div_param[MAX_DIVISION_COUNT] = {

		{true, 1,  "��ѡ��",     PRIZE_RX2,     SUBTYPE_RX2,   false,    2},
		{true, 2,  "��ѡ��",     PRIZE_RX3,     SUBTYPE_RX3,   false,    3},
		{true, 3,  "��ѡ��",     PRIZE_RX4,     SUBTYPE_RX4,   false,    4},
		{true, 4,  "��ѡ��",     PRIZE_RX5,     SUBTYPE_RX5,   true,     5},
		{true, 5,  "��ѡ��",     PRIZE_RX6,     SUBTYPE_RX6,   true,     5},
		{true, 6,  "��ѡ��",     PRIZE_RX7,     SUBTYPE_RX7,   true,     5},
		{true, 7,  "��ѡ��",     PRIZE_RX8,     SUBTYPE_RX8,   false,    5},
		{true, 8,  "ǰһ",       PRIZE_Q1,      SUBTYPE_Q1,   false,    1},
		{true, 9,  "ǰ����ѡ",   PRIZE_Q2ZU,    SUBTYPE_Q2ZU,   false,    2},
		{true, 10,  "ǰ����ѡ",  PRIZE_Q3ZU,    SUBTYPE_Q3ZU,   false,    3},
		{true, 11,  "ǰ��ֱѡ",  PRIZE_Q2ZX,    SUBTYPE_Q2ZX,   true,     2},
		{true, 12,  "ǰ��ֱѡ",  PRIZE_Q3ZX,    SUBTYPE_Q3ZX,   true,     3}

	};

	DIVISION_PARAM *divParam = (DIVISION_PARAM*)gl_koc11x5_getDivisionTable(NULL,0);
	memcpy( divParam, div_param, sizeof(div_param) );
	for(int i = 0; i < totalIssueCount * MAX_DIVISION_COUNT; i = i + MAX_DIVISION_COUNT)
	{
	    memcpy( &divParam[i], div_param, sizeof(div_param) );
	}

    //PRIZE
	PRIZE_PARAM prize_param[MAX_PRIZE_COUNT] = {
		{false, 0,            " ",              false, ASSIGN_UNUSED, {0}},
		{true, PRIZE_RX2,     "��ѡ��",       false,  ASSIGN_FIXED, {3000}},
		{true, PRIZE_RX3,     "��ѡ��",       false, ASSIGN_FIXED, {10000}},
		{true, PRIZE_RX4,     "��ѡ��",       false, ASSIGN_FIXED, {40000}},
		{true, PRIZE_RX5,     "��ѡ��",       true,  ASSIGN_FIXED, {275000}},
		{true, PRIZE_RX6,     "��ѡ��",       false, ASSIGN_FIXED, {45000}},
		{true, PRIZE_RX7,     "��ѡ��",       false, ASSIGN_FIXED, {13000}},
		{true, PRIZE_RX8,     "��ѡ��",       false, ASSIGN_FIXED, {5000}},
		{true, PRIZE_Q1,      "ǰһ",         false, ASSIGN_FIXED, {6000}},
		{true, PRIZE_Q2ZU,    "ǰ����ѡ",     false, ASSIGN_FIXED, {32000}},
		{true, PRIZE_Q3ZU,    "ǰ����ѡ",     false, ASSIGN_FIXED, {100000}},
		{true, PRIZE_Q2ZX,    "ǰ��ֱѡ",     false, ASSIGN_FIXED, {60000}},
		{true, PRIZE_Q3ZX,    "ǰ��ֱѡ",     true,  ASSIGN_FIXED, {580000}}

	};

	PRIZE_PARAM *prizeTable = gl_koc11x5_getPrizeTableBegin();
	for(int i = 0; i < totalIssueCount * MAX_PRIZE_COUNT; i = i + MAX_PRIZE_COUNT)
	{
	    memcpy( &prizeTable[i], prize_param, sizeof(prize_param) );
	}

	//POOL
	POOL_PARAM *poolParam = gl_koc11x5_getPoolParam();

	POOL_PARAM pool_param = {"����", 0};
	memcpy( poolParam, &pool_param, sizeof(pool_param) );

    //GAME_RK
    if (!gl_koc11x5_rk_init())
    {
        log_error("gl_11x5_rk_init() failure.");
        return false;
    }


	log_info("KOC11X5 load memory Finish!");
	return true;
}

int gl_koc11x5_load_newIssueData(void *issueBuffer, int32 issueCount)
{
	ISSUE_CFG_DATA *issueBuf = (ISSUE_CFG_DATA *)issueBuffer;

	ISSUE_INFO *issueInfo = gl_koc11x5_getIssueTable();

	if(issueInfo == NULL)
	{
		log_error("gl_koc11x5_load_newIssueData: gl_koc11x5_getIssueTable is NULL!");
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

int gl_koc11x5_load_oldIssueData(void *issueBuffer, int32 issueCount)
{
	ISSUE_INFO *issueBuf = (ISSUE_INFO *)issueBuffer;

	ISSUE_INFO *issueInfo = gl_koc11x5_getIssueTable();

	if(issueInfo == NULL)
	{
		log_error("gl_koc11x5_load_oldIssueData: gl_koc11x5_getIssueTable is NULL!");
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


ISSUE_INFO* gl_koc11x5_get_currIssue(void)
{
	ISSUE_INFO *allIssueInfo = gl_koc11x5_getIssueTable();

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

ISSUE_INFO* gl_koc11x5_get_issueInfo(uint64 issueNum)
{
	ISSUE_INFO *allIssueInfo = gl_koc11x5_getIssueTable();

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

ISSUE_INFO* gl_koc11x5_get_issueInfo2(uint32 issueSerial)
{
	ISSUE_INFO *allIssueInfo = gl_koc11x5_getIssueTable();

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

ISSUE_INFO* gl_koc11x5_get_issueInfoByIndex(int idx)
{
	ISSUE_INFO *allIssueInfo = gl_koc11x5_getIssueTable();

    if(idx < totalIssueCount)
    	return &(allIssueInfo[idx]);
    else
	    return NULL;
}

uint32 gl_koc11x5_get_issueMaxSeq(void)
{
	uint32 seq = 0;
	ISSUE_INFO *allIssueInfo = gl_koc11x5_getIssueTable();

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

bool gl_koc11x5_del_issue(uint64 issueNum)
{
	ISSUE_INFO* issueInfo = gl_koc11x5_get_issueInfo(issueNum);
	if(issueInfo == NULL)
	{
		log_info("gl_koc11x5_del_issue: issueNum[%lld] not find",issueNum);
		return true;
	}

	if(issueInfo->localState > ISSUE_STATE_RANGED)
		return false;
	else
	{
		issueInfo->used = false;

		ISSUE_INFO *allIssueInfo = gl_koc11x5_getIssueTable();

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

bool gl_koc11x5_clear_oneIssueData(uint64 issueNum)
{
	ISSUE_INFO *allIssueInfo = gl_koc11x5_getIssueTable();

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

bool gl_koc11x5_chkp_saveData(const char *filePath)
{
    GL_ISSUE_CHKP_DATA data;
    memset(&data, 0, sizeof(GL_ISSUE_CHKP_DATA));
    ISSUE_INFO *issue_chkp = NULL;
    ISSUE_INFO *issueInfo = gl_koc11x5_getIssueTable();

    for(int i = 0; i < koc11x5_plugin_info.issueCount; i++)
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
    sprintf(fileName, "%s/koc11x5_issue.snapshot", filePath);
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

    return gl_koc11x5_rk_saveData(filePath);

}

bool gl_koc11x5_chkp_restoreData(const char *filePath)
{
    GL_ISSUE_CHKP_DATA data;

    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName, "%s/koc11x5_issue.snapshot", filePath);
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

    for(int i = 0; i < koc11x5_plugin_info.issueCount; i++)
    {
        issue_chkp = &data.issueData[i];
        if(!issue_chkp->used)
            continue;

        issueInfo = gl_koc11x5_get_issueInfo2(issue_chkp->serialNumber);
        if (NULL == issueInfo)
        {
            log_warn("tms chkp_restore() gl_koc11x5_get_issueInfo2[%d]", issue_chkp->serialNumber);
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
    if(isGameBeRiskControl(GAME_KOC11X5))
        return gl_koc11x5_rk_restoreData(filePath);
    return true;
}



bool gl_koc11x5_loadPrizeTable(uint64 issue,PRIZE_PARAM_ISSUE *prize)
{
	PRIZE_PARAM *prizeMem = gl_koc11x5_getPrizeTable(issue);
	if(prizeMem == NULL)
	{
    	log_error("gl_koc11x5_getPrizeTable issue[%lld] no find",issue);
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

void *gl_koc11x5_get_rkIssueDataTable(void)
{
	return (void *)rk_koc11x5_issueData;
}



// buf: Ͷע�к�����(����������)
// length: buf�ĳ���
// mode: bitmap��ģʽ
// betline: �������betline
int gl_koc11x5_format_ticket(char* buf, uint32 length, int mode, BETLINE* betline)
{
	ts_notused(length);
    GL_BETPART *bp = (GL_BETPART*)betline->bitmap;

    int ret = 0;

	BETPART_STR bpStr;
	memset(&bpStr, 0, sizeof(bpStr));

    splitBetpart(buf, &bpStr);


    int base = 1;
    int sizeA = 0;
	if (GL_BETTYPE_A(betline) == BETTYPE_DT) {
		sizeA = 2 * 2;

		bp->mode = mode;
		bp->size = sizeA;

        if (bpStr.bpALLCnt != 1) {
            log_error("BETTYPE_DT error!bpAllCnt[%d]", bpStr.bpALLCnt);
            return -1;
        }

		ret = num2bit((uint8*)(bpStr.bpAE[0]), bpStr.bpAECnt[0], bp->bitmap, 0, base);
		if (ret != 0) {
		    return -1;
		}
		ret = num2bit((uint8*)bpStr.bpAT, bpStr.bpATCnt, bp->bitmap, 2, base);
        if (ret != 0) {
            return -1;
        }
	}
	else {
		if (mode == MODE_JC) {
			sizeA = 2;

			bp->mode = mode;
			bp->size = sizeA;

			if ( (bpStr.bpALLCnt != 1) || (bpStr.bpADTCnt != 1) ) {
			    log_error("MODE_JC error!bpAllCnt[%d]bpADTCnt[%d]", bpStr.bpALLCnt, bpStr.bpADTCnt);
			    return -1;
			}
			ret = num2bit((uint8*)bpStr.bpAE[0], bpStr.bpAECnt[0], bp->bitmap, 0, base);
	        if (ret != 0) {
	            return -1;
	        }
		}
		else if (mode == MODE_FD) {
			sizeA = bpStr.bpALLCnt * 2;
			for (int k = 0; k < bpStr.bpALLCnt; k++) {
				ret = num2bit((uint8*)(bpStr.bpAE + k), bpStr.bpAECnt[k], bp->bitmap, k * 2, base);
		        if (ret != 0) {
		            return -1;
		        }
			}
			bp->mode = mode;
			bp->size = sizeA;
		}
		else {
			log_error("gl_koc11x5_getSubtypeParam mode [%d] unknow!", mode);
			return -1;
		}
	}
	betline->bitmapLen = 2 + sizeA;
	betline->betCount = gl_koc11x5_betlineBetcount(betline);

	SUBTYPE_PARAM* subtype = gl_koc11x5_getSubtypeParam(betline->subtype);
	if (subtype != NULL)
	{
		betline->singleAmount = subtype->singleAmount;
	} else
	{
		log_error("gl_koc11x5_getSubtypeParam is NULL!!!");
		return -1;
	}

	return 0;
}


int gl_koc11x5_resolve_winStr(uint64 issue,void *buf)
{
	KOC11X5_CALC_PRIZE_PARAM *calcParam = (KOC11X5_CALC_PRIZE_PARAM *)buf;
	ISSUE_INFO *issueInfo = gl_koc11x5_get_issueInfo(issue);
	if(issueInfo != NULL)
	{
	    int flag = 0;
	    const char *format="TBZJ:%d";
	    sscanf(issueInfo->winConfigStr,format,&flag);
	    calcParam->specWinFlag = flag;
	}
	return sizeof(KOC11X5_CALC_PRIZE_PARAM);
}


char *gl_koc11x5_get_winStr(uint64 issue)
{
	ISSUE_INFO *issueInfo = gl_koc11x5_get_issueInfo(issue);
	if(issueInfo != NULL)
	{
		return issueInfo->winConfigStr;
	}
	return NULL;
}


int  gl_11x5_getDsPosition(int n, int k, uint8 position[][4])
{
	return combintion(n, k, position);
}

void gl_11x5_getDsNum(uint8 bitmap[], uint8 outnum[], uint8 position[], int count)
{
	for (int i = 0; i < count; i++)
	{
		bit2num(bitmap + 2 * position[i], 2, outnum + i, 0);
	}
}

int gl_11x5_getRepeat(uint16 num, int count) // num must be sort!
{
	int ret = -1;
	uint8 a, b, c, d;
	switch (count)
	{
	case 4:
	{
		a = num / 1000;
		b = (num - a * 1000) / 100;
		c = (num - a * 1000 - b * 100) / 10;
		d = num % 10;

		if ((a < b) && (b < c) && (c < d))
			ret = 1;
		else if ((a == b) && (b == c) && (c == d))
			ret = 24;
		else if ((a == b) && (c == d))
			ret = 4;
		else
			ret = 6;
		break;
	}
	case 3:
	{
		a = num / 100;
		b = (num - a * 100) / 10;
		c = num % 10;

		if ((a < b) && (b < c) )
			ret = 1;
		else if ((a == b) && (b == c) )
			ret = 6;
		else
			ret = 2;
		break;
	}
	case 2:
	{
		a = num / 10;
		b = num % 10;
		ret = (a == b)? 2 : 1;
		break;
	}
	default:
		log_error("gl_11x5_getRepeat count[%d] unknow", count);
	}
	return ret;
}



int gl_koc11x5_subNum(uint8 subtype)
{
	int expr = 0;
	switch (subtype)
	{
	case SUBTYPE_Q1:
		expr = 1;
		break;
	case SUBTYPE_RX2:
	case SUBTYPE_Q2ZU:
		expr = 2;
		break;
	case SUBTYPE_RX3:
	case SUBTYPE_Q3ZU:
		expr = 3;
		break;
	case SUBTYPE_RX4:
		expr = 4;
		break;
	case SUBTYPE_RX5:
		expr = 5;
		break;
	case SUBTYPE_RX6:
		expr = 6;
		break;
	case SUBTYPE_RX7:
		expr = 7;
		break;
	case SUBTYPE_RX8:
		expr = 8;
		break;
	default:
		log_warn("gl_koc11x5_subNum subtype[%d] not support!", subtype);
		expr = -1;
	}

	return expr;
}