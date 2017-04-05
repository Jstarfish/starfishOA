#include "global.h"
#include "gl_inf.h"

#include "gl_ssc_db.h"
#include "gl_ssc_verify.h"
#include "gl_ssc_betcount.h"
#include "gl_ssc_rk.h"



#define GL_SSC_SHM_KEY      (GL_SHM_KEY + GAME_SSC)

#define SHARE_MEM_REDUN  32


static int32 ncGlobalMem = 0;
static int32 ncGlobalLen = 0;

const int MAX_BUFSIZE = 2048;

static GL_PLUGIN_INFO ssc_plugin_info;

static void * ssc_plugin_info_ptr = NULL;


extern GAME_SSCRISK_PTR rk_ssc_db_ptr;
extern GAME_RISK_SSC_ISSUE_DATA *rk_ssc_issueData;
extern ISSUE_INFO *ssc_issue_info;
extern int totalIssueCount;

TABLE_SSC table_ssc =
{
   //0, 1,  2, 3, 4,  5,  6,   7,   8,   9,   10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27

	//直选2和值
	{1, 2,  3, 4, 5,  6,  7,   8,   9,   10,  9,  8,  7,  6,  5,  4,  3,  2,  1},

	//组选2和值
	{1, 1,  2, 2, 3,  3,  4,   4,   5,   5,   5,  4,  4,  3,  3,  2,  2,  1,  1},

	//直选3和值
	{1, 3,  6, 10,15, 21, 28,  36,  45,  55,  63, 69, 73, 75, 75, 73, 69, 63, 55, 45, 36, 28, 21, 15, 10, 6,  3,  1},

	//组选3和值
	{1, 1,  2, 3, 4,  5,  7,   8,   10,  12,  13, 14, 15, 15, 15, 15, 14, 13, 12, 10, 8,  7,  5,  4,  3,  2,  1,  1},

	//直选组合复式
	{0, 0,  0, 6, 24, 60, 120, 210, 336, 504, 720},

	//组三复式
	{0, 0,  2, 6, 12, 20, 30,  42,  56,  72,  90},

	//组六复式
	{0, 0,  0, 0, 4,  10, 20,  35,  56,  84,  120},

	//组选2包胆
	{0, 10},

	//组选3包胆
	{0, 55, 10}
};

/// share interface

bool gl_ssc_mem_creat(int issue_count)
{

	int32 ret = -1;
    IPCKEY keyid;

    ncGlobalLen = sizeof(int) +
            sizeof(SUBTYPE_PARAM) * MAX_SUBTYPE_COUNT +
            sizeof(DIVISION_PARAM) * MAX_DIVISION_COUNT +
            sizeof(ISSUE_INFO) * issue_count +
            sizeof(PRIZE_PARAM) * issue_count * MAX_PRIZE_COUNT +
            sizeof(POOL_PARAM) +
            sizeof(GAME_RISK_SSC) +
            sizeof(GAME_RISK_SSC_ISSUE_DATA) * issue_count +
            SHARE_MEM_REDUN;

    //创建keyid
    keyid = ipcs_shmkey(GL_SSC_SHM_KEY);

    //创建共享内存
    ncGlobalMem = sysv_get_shm(keyid, ncGlobalLen, IPC_CREAT | IPC_EXCL | 0644);
    if (-1 == ncGlobalMem)
    {
        log_error("gl_create::create globalSection(gl) failure");
        return false;
    }

    //内存映射
    ssc_plugin_info_ptr = (signed char *) sysv_attach_shm(ncGlobalMem, 0, 0);
    if ((void*) -1 == ssc_plugin_info_ptr)
    {
        log_error("gl_create::attach globalSection(gl) failure.");
        return false;
    }

    //初始化共享内存
    memset(ssc_plugin_info_ptr, 0, ncGlobalLen);
    *((int *) ssc_plugin_info_ptr) = issue_count;
    //

    //断开与共享内存的映射
    ret = sysv_detach_shm(ssc_plugin_info_ptr);
    if (ret < 0)
    {
        log_error("gl_create:deattach globalSection(gl) failure.");
        return false;
    }

    log_info("gl_ssc_mem_creat success! shm_key[%#x] shm_id[%d] size[%d] issueCount[%d]", keyid, ncGlobalMem, ncGlobalLen, issue_count);
    return true;
}

//删除共享内存
bool gl_ssc_mem_destroy()
{
    int32 ret = -1;

    //如果创建共享内存和删除共享内存在不同的任务中，需要下面这段程序
    IPCKEY keyid;

    keyid = ipcs_shmkey(GL_SSC_SHM_KEY);

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

    log_info("gl_ssc_mem_destroy success!");
    return true;
}

//映射共享内存区
bool gl_ssc_mem_attach()
{
    IPCKEY keyid;

    keyid = ipcs_shmkey(GL_SSC_SHM_KEY);

    ncGlobalMem = sysv_get_shm(keyid, 0, 0);
    //ncGlobalMem = sysv_get_shm(keyid, ncGlobalLen, IPC_CREAT|0644);
    if (-1 == ncGlobalMem)
    {
        log_error("gl_init::open globalSection(gl) failure.");
        return false;
    }

    ssc_plugin_info_ptr =  sysv_attach_shm(ncGlobalMem, 0, 0);
    if ((signed char *) -1 == ssc_plugin_info_ptr)
    {
        log_error("gl_init::attach globalSection(gl) failure.");
        return false;
    }

    //初始化数据库结构指针
    ssc_plugin_info.issueCount = *(int *)ssc_plugin_info_ptr;

    ssc_plugin_info.subtype_info = (char *)ssc_plugin_info_ptr + sizeof(int);

    ssc_plugin_info.division_info = (char *)ssc_plugin_info.subtype_info + sizeof(SUBTYPE_PARAM) * MAX_SUBTYPE_COUNT;

    ssc_plugin_info.issue_info = (char *)ssc_plugin_info.division_info + sizeof(DIVISION_PARAM) * MAX_DIVISION_COUNT;

    ssc_plugin_info.prize_info = (char *)ssc_plugin_info.issue_info + sizeof(ISSUE_INFO) * ssc_plugin_info.issueCount;

    ssc_plugin_info.pool_info = (char *)ssc_plugin_info.prize_info + sizeof(PRIZE_PARAM) * MAX_PRIZE_COUNT * ssc_plugin_info.issueCount;

    ssc_plugin_info.rk_info = (char *)ssc_plugin_info.pool_info + sizeof(POOL_PARAM);


    //////////////// rk globa /////////////////////////
	rk_ssc_db_ptr = (GAME_SSCRISK_PTR)ssc_plugin_info.rk_info;

	rk_ssc_issueData = (GAME_RISK_SSC_ISSUE_DATA *)((char *)rk_ssc_db_ptr + sizeof(rk_ssc_db_ptr->sumSubIndex)
			                 + sizeof(rk_ssc_db_ptr->index5StarWhole) + sizeof(rk_ssc_db_ptr->FiveStarNum) );

	ssc_issue_info = (ISSUE_INFO *)ssc_plugin_info.issue_info;

	totalIssueCount = ssc_plugin_info.issueCount;

	rk_initVerifyFun();

    return true;
}

//关闭共享内存区的映射
bool gl_ssc_mem_detach()
{
    int32 ret = -1;

    if (NULL == ssc_plugin_info_ptr)
    {
        log_error("gl_close::globalSection(gl) pointer is NULL;");
        return false;
    }

    //断开与共享内存的映射
    ret = sysv_detach_shm(ssc_plugin_info_ptr);
    if (ret < 0)
    {
        log_error("gl_close:deattach globalSection(gl) failure.");
        return false;
    }

    ncGlobalMem = 0;
    ssc_plugin_info_ptr = NULL;
    return true;
}


/*    next  no can see out of .so    */
void *gl_ssc_get_mem_db(void)
{
    return ssc_plugin_info_ptr;
}



void * gl_ssc_getSubtypeTable(int *len)
{
	if (len != NULL)
        *len = sizeof(SUBTYPE_PARAM) * MAX_SUBTYPE_COUNT;
    return ssc_plugin_info.subtype_info;
}

SUBTYPE_PARAM * gl_ssc_getSubtypeParam( uint8 subtypeCode)
{
	SUBTYPE_PARAM * subTable = (SUBTYPE_PARAM *) gl_ssc_getSubtypeTable(NULL);
	for(int i = 0; i < MAX_SUBTYPE_COUNT; i++)
	{
		if((subTable[i].used) && (subTable[i].subtypeCode ==  subtypeCode))
			return &subTable[i];
	}

    return NULL;
}

void * gl_ssc_getDivisionTable(int *len,uint64 issueNum)
{
	if (len != NULL)
        *len = sizeof(DIVISION_PARAM) * MAX_DIVISION_COUNT;

	DIVISION_PARAM *divisionParam =(DIVISION_PARAM *)(ssc_plugin_info.division_info);
//    ISSUE_INFO *allIssueInfo = gl_ssc_getIssueTable();
//
//    int idx = 0;
//
//    if(issueNum > 0)
//    {
//        for(idx = 0; idx < totalIssueCount ; idx++)
//        {
//            if(allIssueInfo[idx].used)
//            {
//                if(allIssueInfo[idx].issueNumber == issueNum)
//                {
//                    break;
//                }
//            }
//        }
//
//        divisionParam =(DIVISION_PARAM *)((char *)ssc_plugin_info.division_info + sizeof(DIVISION_PARAM) * MAX_DIVISION_COUNT * idx);
//
//    }

    return (void *)divisionParam;
}

DIVISION_PARAM * gl_ssc_getDivisionParam( uint8 divisionCode)
{
	DIVISION_PARAM * divisionTable = (DIVISION_PARAM *)gl_ssc_getDivisionTable(NULL,0);
	for(int i = 0; i < MAX_DIVISION_COUNT; i++)
	{
		if((divisionTable[i].used) && (divisionTable[i].divisionCode == divisionCode))
				return &divisionTable[i];
	}

	return NULL;
}

PRIZE_PARAM * gl_ssc_getPrizeTable(uint64 issueNum)
{
	if(issueNum == 0)
	    return  (PRIZE_PARAM *)((char *)ssc_plugin_info.prize_info);

	int idx = 0;
	int ret = 0;
	ISSUE_INFO * issueTable = gl_ssc_getIssueTable();
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
	return  (PRIZE_PARAM *)((char *)ssc_plugin_info.prize_info + sizeof(PRIZE_PARAM) * idx * MAX_PRIZE_COUNT);
}


POOL_PARAM *gl_ssc_getPoolParam(void)
{
	return (POOL_PARAM*) ssc_plugin_info.pool_info;
}

void *gl_ssc_getRkTable(void)
{
	return ssc_plugin_info.rk_info;
}

int gl_ssc_getSingleAmount(char *buffer, size_t len)
{
	char tmp[256] = {0};

	for (uint8 subtype = SUBTYPE_1ZX; subtype <= SUBTYPE_DXDS; subtype++)
	{
	    SUBTYPE_PARAM *subParam = gl_ssc_getSubtypeParam(subtype);
	    sprintf(tmp, "%s%s=%d", tmp, subtypeAbbr[GAME_SSC][subtype], subParam->singleAmount);

	    if (subtype != SUBTYPE_DXDS)
	    {
	        strcat(tmp, ",");
	    }
	}

	if (strlen(tmp) + 1 > len)
	{
		log_error("gl_ssc_getSingleAmount() len not enough.");
		return -1;
	}
	memcpy(buffer, tmp, strlen(tmp) + 1);
	return 0;
}

ISSUE_INFO *gl_ssc_getIssueTable(void)
{
	return (ISSUE_INFO*) ssc_plugin_info.issue_info;
}

int get_ssc_issueMaxCount(void)
{
    return totalIssueCount;
}

int get_ssc_issueCount(void)
{
	int ret = 0;
	ISSUE_INFO *issueTable = gl_ssc_getIssueTable();
	for(int i = 0; i < totalIssueCount; i++)
	{
		if((issueTable[i].used) && (issueTable[i].curState < ISSUE_STATE_ISSUE_END))
			ret++;
	}
    return ret;
}



PRIZE_PARAM * gl_ssc_getPrizeTableBegin(void)
{
	return  (PRIZE_PARAM *) ssc_plugin_info.prize_info;
}

bool gl_ssc_load_memdata(void)
{
	//SUBTYPE
	SUBTYPE_PARAM *subParam = (SUBTYPE_PARAM*)gl_ssc_getSubtypeTable(NULL);

	SUBTYPE_PARAM subtype_param[MAX_SUBTYPE_COUNT] = {
		{false,0,            "",     "",         0,          0, 0, 0},
		{true, SUBTYPE_1ZX,  "1ZX",  "一星直选",  4294967295, 0, 9, 200},
		{true, SUBTYPE_2ZX,  "2ZX",  "二星直选",  4294967295, 0, 9, 200},
		{true, SUBTYPE_2FX,  "2FX",  "二星复选",  4294967295, 0, 9, 200},
		{true, SUBTYPE_2ZUX, "2ZUX", "二星组选",  4294967295, 0, 9, 200},
		{true, SUBTYPE_3ZX,  "3ZX",  "三星直选",  4294967295, 0, 9, 200},
		{true, SUBTYPE_3FX,  "3FX",  "三星复选",  4294967295, 0, 9, 200},
		{true, SUBTYPE_3ZUX, "3ZUX", "三星组选",  4294967295, 0, 9, 200},
		{true, SUBTYPE_3Z3,  "3Z3",  "三星组三",  4294967295, 0, 9, 200},
		{true, SUBTYPE_3Z6,  "3Z6",  "三星组六",  4294967295, 0, 9, 200},
		{true, SUBTYPE_5ZX,  "5ZX",  "五星直选",  4294967295, 0, 9, 200},
		{true, SUBTYPE_5FX,  "5FX",  "五星复选",  4294967295, 0, 9, 200},
		{true, SUBTYPE_5TX,  "5TX",  "五星通选",  4294967295, 0, 9, 200},
		{true, SUBTYPE_DXDS, "DXDS", "大小单双",  4294967295, 0, 9, 200}
	};
	memcpy( subParam, subtype_param, sizeof(subtype_param) );

    //DIVISION
	DIVISION_PARAM *divParam = (DIVISION_PARAM*)gl_ssc_getDivisionTable(NULL,0);

	DIVISION_PARAM div_param[MAX_DIVISION_COUNT] = {
		{true, 0,  "一星直选",     PRIZE_1ZX,     SUBTYPE_1ZX,   0,        5, 5, 0},
		{true, 1,  "二星直选",     PRIZE_2ZX,     SUBTYPE_2ZX,   0,        4, 5, 0},
		{true, 2,  "二星复选-2",   PRIZE_2ZX,     SUBTYPE_2FX,   0,        4, 5, 0},
		{true, 3,  "二星复选-1",   PRIZE_1ZX,     SUBTYPE_2FX,   0,        5, 5, 0},
		{true, 4,  "二星组选-20",  PRIZE_2ZUX20,  SUBTYPE_2ZUX,  20000000, 4, 5, 0},
		{true, 5,  "二星组选-11",  PRIZE_2ZUX11,  SUBTYPE_2ZUX,  11000000, 4, 5, 0},
		{true, 6,  "三星直选",     PRIZE_3ZX,     SUBTYPE_3ZX,   0,        3, 5, 0},
		{true, 7,  "三星复选-3",   PRIZE_3ZX,     SUBTYPE_3FX,   0,        3, 5, 0},
		{true, 8,  "三星复选-2",   PRIZE_2ZX,     SUBTYPE_3FX,   0,        4, 5, 0},
		{true, 9,  "三星复选-1",   PRIZE_1ZX,     SUBTYPE_3FX,   0,        5, 5, 0},
		{true, 10, "三星组选-300", PRIZE_3ZUX300, SUBTYPE_3ZUX,  30000000, 3, 5, 0},
		{true, 11, "三星组选-210", PRIZE_3ZUX210, SUBTYPE_3ZUX,  21000000, 3, 5, 0},
		{true, 12, "三星组选-111", PRIZE_3ZUX111, SUBTYPE_3ZUX,  11100000, 3, 5, 0},
		{true, 13, "三星组三",     PRIZE_3Z3,     SUBTYPE_3Z3,   21000000, 3, 5, 0},
		{true, 14, "三星组六",     PRIZE_3Z6,     SUBTYPE_3Z6,   11100000, 3, 5, 0},
		{true, 15, "五星直选",     PRIZE_5ZX,     SUBTYPE_5ZX,   0,        1, 5, 0},
		{true, 16, "五星复选-5",   PRIZE_5ZX,     SUBTYPE_5FX,   0,        1, 5, 0},
		{true, 17, "五星复选-3",   PRIZE_3ZX,     SUBTYPE_5FX,   0,        3, 5, 0},
		{true, 18, "五星复选-2",   PRIZE_2ZX,     SUBTYPE_5FX,   0,        4, 5, 0},
		{true, 19, "五星复选-1",   PRIZE_1ZX,     SUBTYPE_5FX,   0,        5, 5, 0},
		{true, 20, "五星通选-1",   PRIZE_5TX1,    SUBTYPE_5TX,   0,        1, 5, 0},
		{true, 21, "五星通选-2",   PRIZE_5TX2,    SUBTYPE_5TX,   0,        1, 3, 0},
		{true, 22, "五星通选-2",   PRIZE_5TX2,    SUBTYPE_5TX,   0,        3, 5, 0},
		{true, 23, "五星通选-3",   PRIZE_5TX3,    SUBTYPE_5TX,   0,        1, 2, 0},
		{true, 24, "五星通选-3",   PRIZE_5TX3,    SUBTYPE_5TX,   0,        4, 5, 0},
		{true, 25, "大小单双",     PRIZE_DXDS,    SUBTYPE_DXDS,  0,        4, 5, 0}
	};
	memcpy( divParam, div_param, sizeof(div_param) );

    //PRIZE
	PRIZE_PARAM prize_param[MAX_PRIZE_COUNT] = {
		{false, 0,            " ",              false, ASSIGN_UNUSED, {0}},
		{true, PRIZE_1ZX,     "一星直选",        false, ASSIGN_FIXED, {1000}},
		{true, PRIZE_2ZX,     "二星直选",        false, ASSIGN_FIXED, {10000}},
		{true, PRIZE_3ZX,     "三星直选",        false, ASSIGN_FIXED, {100000}},
		{true, PRIZE_5ZX,     "五星直选",        false, ASSIGN_FIXED, {10000000}},
		{true, PRIZE_DXDS,    "大小单双",        false, ASSIGN_FIXED, {400}},
		{true, PRIZE_2ZUX20,  "二星组选-20",     false, ASSIGN_FIXED, {10000}},
		{true, PRIZE_2ZUX11,  "二星组选-11",     false, ASSIGN_FIXED, {5000}},
		{true, PRIZE_3ZUX300, "三星组选-300",    false, ASSIGN_FIXED, {100000}},
		{true, PRIZE_3ZUX210, "三星组选-210",    false, ASSIGN_FIXED, {32000}},
		{true, PRIZE_3ZUX111, "三星组选-111",    false, ASSIGN_FIXED, {16000}},
		{true, PRIZE_3Z3,     "三星组三",        false, ASSIGN_FIXED, {32000}},
		{true, PRIZE_3Z6,     "三星组六",        false, ASSIGN_FIXED, {16000}},
		{true, PRIZE_5TX1,    "五星通选-一等奖", false, ASSIGN_FIXED, {2000000}},
		{true, PRIZE_5TX2,    "五星通选-二等奖", false, ASSIGN_FIXED, {20000}},
		{true, PRIZE_5TX3,    "五星通选-三等奖", false, ASSIGN_FIXED, {2000}}
	};

	PRIZE_PARAM *prizeTable = gl_ssc_getPrizeTableBegin();
	for(int i = 0; i < totalIssueCount * MAX_PRIZE_COUNT; i = i + MAX_PRIZE_COUNT)
	{
	    memcpy( &prizeTable[i], prize_param, sizeof(prize_param) );
	}

	//POOL
	POOL_PARAM *poolParam = gl_ssc_getPoolParam();

	POOL_PARAM pool_param = {"奖池", 0};
	memcpy( poolParam, &pool_param, sizeof(pool_param) );


    //GAME_RK
    if (!gl_ssc_rk_init())
    {
        log_error("gl_ssc_rk_init() failure.");
        return false;
    }

	log_info("SSC load memory Finish!");
	return true;
}

int gl_ssc_load_newIssueData(void *issueBuffer, int32 issueCount)
{
	ISSUE_CFG_DATA *issueBuf = (ISSUE_CFG_DATA *)issueBuffer;

	ISSUE_INFO *issueInfo = gl_ssc_getIssueTable();

	if(issueInfo == NULL)
	{
		log_error("gl_ssc_load_newIssueData: gl_ssc_getIssueTable is NULL!");
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

int gl_ssc_load_oldIssueData(void *issueBuffer, int32 issueCount)
{
	ISSUE_INFO *issueBuf = (ISSUE_INFO *)issueBuffer;

	ISSUE_INFO *issueInfo = gl_ssc_getIssueTable();

	if(issueInfo == NULL)
	{
		log_error("gl_ssc_load_oldIssueData: gl_ssc_getIssueTable is NULL!");
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


ISSUE_INFO* gl_ssc_get_currIssue(void)
{
	ISSUE_INFO *allIssueInfo = gl_ssc_getIssueTable();

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

ISSUE_INFO* gl_ssc_get_issueInfo(uint64 issueNum)
{
	ISSUE_INFO *allIssueInfo = gl_ssc_getIssueTable();

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

ISSUE_INFO* gl_ssc_get_issueInfo2(uint32 issueSerial)
{
	ISSUE_INFO *allIssueInfo = gl_ssc_getIssueTable();

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

ISSUE_INFO* gl_ssc_get_issueInfoByIndex(int idx)
{
	ISSUE_INFO *allIssueInfo = gl_ssc_getIssueTable();

    if(idx < totalIssueCount)
    	return &(allIssueInfo[idx]);
    else
	    return NULL;
}

uint32 gl_ssc_get_issueMaxSeq(void)
{
	uint32 seq = 0;
	ISSUE_INFO *allIssueInfo = gl_ssc_getIssueTable();

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

bool gl_ssc_del_issue(uint64 issueNum)
{
	ISSUE_INFO* issueInfo = gl_ssc_get_issueInfo(issueNum);
	if(issueInfo == NULL)
	{
		log_debug("gl_ssc_del_issue: gl_ssc_issueTable is NULL!");
		return true;
	}

	if(issueInfo->localState > ISSUE_STATE_RANGED)
		return false;
	else
	{
		issueInfo->used = false;

		ISSUE_INFO *allIssueInfo = gl_ssc_getIssueTable();

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

bool gl_ssc_clear_oneIssueData(uint64 issueNum)
{
	ISSUE_INFO *allIssueInfo = gl_ssc_getIssueTable();

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

bool gl_ssc_chkp_saveData(const char *filePath)
{
    GL_ISSUE_CHKP_DATA data;
    memset(&data, 0, sizeof(GL_ISSUE_CHKP_DATA));
    ISSUE_INFO *issue_chkp = NULL;
    ISSUE_INFO *issueInfo = gl_ssc_getIssueTable();

    for(int i = 0; i < ssc_plugin_info.issueCount; i++)
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
    sprintf(fileName, "%s/ssc_issue.snapshot", filePath);
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

    return gl_ssc_rk_saveData(filePath);
}

bool gl_ssc_chkp_restoreData(const char *filePath)
{
    GL_ISSUE_CHKP_DATA data;

    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName, "%s/ssc_issue.snapshot", filePath);
    if ( access(fileName, 0) != 0 )
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

    for(int i = 0; i < ssc_plugin_info.issueCount; i++)
    {
        issue_chkp = &data.issueData[i];
        if(!issue_chkp->used)
            continue;

        issueInfo = gl_ssc_get_issueInfo2(issue_chkp->serialNumber);
        if (NULL == issueInfo)
        {
            log_warn("tms chkp_restore() gl_ssc_get_issueInfo2[%d]", issue_chkp->serialNumber);
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
    if(isGameBeRiskControl(GAME_SSC))
        return gl_ssc_rk_restoreData(filePath);
    return true;
}



bool gl_ssc_loadPrizeTable(uint64 issue,PRIZE_PARAM_ISSUE *prize)
{
	PRIZE_PARAM *prizeMem = gl_ssc_getPrizeTable(issue);
	if(prizeMem == NULL)
	{
    	log_error("gl_ssc_getPrizeTable issue[%lld] no find",issue);
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

void *gl_ssc_get_rkIssueDataTable(void)
{
	return (void *)rk_ssc_issueData;
}

// buf: 投注行号码区(不包含括号)
// length: buf的长度
// mode: bitmap的模式
// betline: 结果存入betline
int gl_ssc_format_ticket(char* buf, uint32 length, int mode, BETLINE* betline)
{
	ts_notused(length);
    GL_BETPART *bp = (GL_BETPART*)betline->bitmap;

    int ret = 0;

	BETPART_STR bpStr;
	memset(&bpStr, 0, sizeof(bpStr));
	splitBetpart(buf, &bpStr);

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
	}

	betline->bitmapLen = 2 + sizeA;
	betline->betCount = gl_ssc_betlineBetcount(betline);

	SUBTYPE_PARAM* subtype = gl_ssc_getSubtypeParam(betline->subtype);
	if (subtype != NULL)
	{
		betline->singleAmount = subtype->singleAmount;
	} else
	{
		log_error("gl_ssc_getSubtypeParam is NULL!!!");
		return -1;
	}

	return 0;
}












