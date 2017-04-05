#include "global.h"
#include "glmod.h"


static int32 nGlobalMem = 0;
static int8 *pGlobalMem = NULL;
static int32 nGlobalLen = 0;

static GL_DATABASE_PTR gl_database_ptr = NULL;



//创建共享内存
bool gl_create()
{
    int32 ret = -1;
    IPCKEY keyid;

    nGlobalLen = sizeof(GL_DATABASE);

    //创建keyid
    keyid = ipcs_shmkey(GL_SHM_KEY);

    //创建共享内存
    nGlobalMem = sysv_get_shm(keyid, nGlobalLen, IPC_CREAT | IPC_EXCL | 0644);
    if (-1 == nGlobalMem)
    {
        log_error("gl_create::create globalSection(gl) failure");
        return false;
    }

    //内存映射
    pGlobalMem = (signed char *) sysv_attach_shm(nGlobalMem, 0, 0);
    if ((signed char *) -1 == pGlobalMem)
    {
        log_error("gl_create::attach globalSection(gl) failure.");
        return false;
    }

    //初始化共享内存
    memset(pGlobalMem, 0, nGlobalLen);

    gl_database_ptr = (GL_DATABASE *) pGlobalMem;




    //初始化系统支持的游戏列表 ------------------------------------------
    uint8 gameCode = 0;
    GAME_SUPPORT *game_support = NULL;
    for (gameCode=0; gameCode<MAX_GAME_NUMBER; gameCode++)
    {
        game_support = get_game_support(gameCode);
        GAME_DATA* gameData = gl_getGameData(gameCode);
        //gameData->used = game_support->used;
        gameData->gameEntry.gameCode = game_support->gameCode;
        gameData->gameEntry.gameType = game_support->gameType;
        strcpy(gameData->gameEntry.gameAbbr, game_support->gameAbbr);
        gameData->transctrlParam.drawType = game_support->drawType;
    }

    //初始化 hash cache互斥量 ----------------------------------------------------
    pthread_mutexattr_t mattr_sale;
    ret = pthread_mutexattr_init(&mattr_sale);
    if (0 != ret)
    {
        log_error("pthread_mutexattr_init failed. sale hash mutex. reason:[%s]", strerror(errno));
        return false;
    }
    ret = pthread_mutexattr_setpshared(&mattr_sale, PTHREAD_PROCESS_SHARED);
    if (0 != ret)
    {
        log_error("pthread_mutexattr_setpshared failed. sale hash mutex. reason:[%s]", strerror(errno));
        return false;
    }
    ret = pthread_mutex_init(&gl_database_ptr->sale_lock, &mattr_sale);
    if (0 != ret)
    {
        log_error("pthread_mutex_init failed. sale hash mutex. reason:[%s]", strerror(errno));
        return false;
    }

    pthread_mutexattr_t mattr_pay;
    ret = pthread_mutexattr_init(&mattr_pay);
    if (0 != ret)
    {
        log_error("pthread_mutexattr_init failed. pay hash mutex. reason:[%s]", strerror(errno));
        return false;
    }
    ret = pthread_mutexattr_setpshared(&mattr_pay, PTHREAD_PROCESS_SHARED);
    if (0 != ret)
    {
        log_error("pthread_mutexattr_setpshared failed. pay hash mutex. reason:[%s]", strerror(errno));
        return false;
    }
    ret = pthread_mutex_init(&gl_database_ptr->pay_lock, &mattr_pay);
    if (0 != ret)
    {
        log_error("pthread_mutex_init failed. pay hash mutex. reason:[%s]", strerror(errno));
        return false;
    }

    pthread_mutexattr_t mattr_cancel;
    ret = pthread_mutexattr_init(&mattr_cancel);
    if (0 != ret)
    {
        log_error("pthread_mutexattr_init failed. cancel hash mutex. reason:[%s]", strerror(errno));
        return false;
    }
    ret = pthread_mutexattr_setpshared(&mattr_cancel, PTHREAD_PROCESS_SHARED);
    if (0 != ret)
    {
        log_error("pthread_mutexattr_setpshared failed. cancel hash mutex. reason:[%s]", strerror(errno));
        return false;
    }
    ret = pthread_mutex_init(&gl_database_ptr->cancel_lock, &mattr_cancel);
    if (0 != ret)
    {
        log_error("pthread_mutex_init failed. cancel hash mutex. reason:[%s]", strerror(errno));
        return false;
    }

    //断开与共享内存的映射
    ret = sysv_detach_shm(pGlobalMem);
    if (ret < 0)
    {
        log_error("gl_create:deattach globalSection(gl) failure.");
        return false;
    }

    log_info("gl_create success! shm_key[%#x] shm_id[%d] size[%d]", keyid, nGlobalMem, nGlobalLen);
    return true;
}

//删除共享内存
bool gl_destroy()
{
    int32 ret = -1;

    //如果创建共享内存和删除共享内存在不同的任务中，需要下面这段程序
    IPCKEY keyid;

    keyid = ipcs_shmkey(GL_SHM_KEY);

    nGlobalMem = sysv_get_shm(keyid, 0, 0);
    //nGlobalMem = sysv_get_shm(keyid, nGlobalLen, IPC_CREAT|0644);
    if (-1 == nGlobalMem)
    {
        log_error("gl_destroy::open globalSection(gl) failure.");
        return false;
    }

    //删除共享内存
    ret = sysv_ctl_shm(nGlobalMem, IPC_RMID, NULL);
    if (ret < 0)
    {
        log_error("gl_destroy:delete globalSection(gl) failure.");
        return false;
    }

    log_info("gl_destroy success!");
    return true;
}

//映射共享内存区
bool gl_init()
{
    IPCKEY keyid;

    keyid = ipcs_shmkey(GL_SHM_KEY);

    nGlobalMem = sysv_get_shm(keyid, 0, 0);
    //nGlobalMem = sysv_get_shm(keyid, nGlobalLen, IPC_CREAT|0644);
    if (-1 == nGlobalMem)
    {
        log_error("gl_init::open globalSection(gl) failure.");
        return false;
    }

    pGlobalMem = (signed char *) sysv_attach_shm(nGlobalMem, 0, 0);
    if ((signed char *) -1 == pGlobalMem)
    {
        log_error("gl_init::attach globalSection(gl) failure.");
        return false;
    }

    //初始化数据库结构指针
    gl_database_ptr = (GL_DATABASE *) pGlobalMem;
    return true;
}

//关闭共享内存区的映射
bool gl_close()
{
    int32 ret = -1;

    if (NULL == pGlobalMem)
    {
        log_error("gl_close::globalSection(gl) pointer is NULL;");
        return false;
    }

    //断开与共享内存的映射
    ret = sysv_detach_shm(pGlobalMem);
    if (ret < 0)
    {
        log_error("gl_close:deattach globalSection(gl) failure.");
        return false;
    }

    nGlobalMem = 0;
    pGlobalMem = NULL;
    gl_database_ptr = NULL;
    return true;
}

GL_DATABASE_PTR gl_getDataBasePtr(void)
{
    return gl_database_ptr;
}

//游戏是否可用
bool isGameBeUsed(uint8 gameCode)
{
    if ( gameCode<MAX_GAME_NUMBER )
        return gl_database_ptr->gameTable[gameCode].used;
    return false;
}

//获取指定gameCode的游戏数据
GAME_DATA *gl_getGameData(uint8 gameCode)
{
    return &(gl_database_ptr->gameTable[gameCode]);
}

//获取指定gameCode的游戏基本参数
GAME_PARAM *gl_getGameParam(uint8 gameCode)
{
    return &(gl_database_ptr->gameTable[gameCode].gameEntry);
}

//获取指定gameCode的政策参数
POLICY_PARAM* gl_getPolicyParam(uint8 gameCode)
{
    return &(gl_database_ptr->gameTable[gameCode].policyParam);
}

//获取指定gameCode的交易控制参数
TRANSCTRL_PARAM *gl_getTransctrlParam(uint8 gameCode)
{
    return &(gl_database_ptr->gameTable[gameCode].transctrlParam);
}

//获取RNG数据
RNG_PARAM *gl_getRngData()
{
    return gl_database_ptr->rngTable;
}


//验证当前时间是否在游戏的服务时段范围内
bool gl_verifyServiceTime(uint8 gameCode)
{
    time_t curtime;
    struct tm * tm_ptr;
    time(&curtime);
    tm_ptr = localtime(&curtime);
    uint32 ct = tm_ptr->tm_hour*100 + tm_ptr->tm_min;

    TRANSCTRL_PARAM *transctrlParam = gl_getTransctrlParam(gameCode);

    //检验是否配置服务时段限制
    if ( (transctrlParam->service_time_1_b == 0)
        && (transctrlParam->service_time_1_e == 0)
        && (transctrlParam->service_time_2_b == 0)
        && (transctrlParam->service_time_2_e == 0) )
    {
        return true;
    }

    //检验服务时段范围
    if ( (transctrlParam->service_time_1_b != 0)
        || (transctrlParam->service_time_1_e != 0)
        || (transctrlParam->service_time_2_b != 0)
        || (transctrlParam->service_time_2_e != 0) )
    {
        if ( (ct >= transctrlParam->service_time_1_b) && (ct < transctrlParam->service_time_1_e) )
        {
            return true;
        }
        else if ( (ct >= transctrlParam->service_time_2_b) && (ct < transctrlParam->service_time_2_e) )
        {
            return true;
        }
    }
    return false;
}

//获取指定gameCode的游戏当日统计数据
GAME_DAY_STAT *gl_getGameDayStat(uint8 gameCode)
{
    return &(gl_database_ptr->gameTable[gameCode].gameDayStat);
}

//日结时清除游戏当日统计数据
void gl_cleanGameDayStatistics()
{
    GAME_DATA* gameData = NULL;
    for (int gameCode=0; gameCode<MAX_GAME_NUMBER; gameCode++)
    {
        gameData = gl_getGameData(gameCode);
        if (!gameData->used)
            continue;
        gameData->gameDayStat.saleCount = 0;
        gameData->gameDayStat.saleAmount = 0;
        gameData->gameDayStat.payCount = 0;
        gameData->gameDayStat.payAmount = 0;
        gameData->gameDayStat.cancelCount = 0;
        gameData->gameDayStat.cancelAmount = 0;
    }
}


//是否启用风险控制
bool isGameBeRiskControl(uint8 gameCode)
{
    return gl_database_ptr->gameTable[gameCode].transctrlParam.riskCtrl;
}


//设置游戏销售、兑奖、取消   flag (1:sale 2:pay 3:cancel)  status(0: false 1:true)
int gl_setGameCtrl(uint8 gameCode, uint8 flag, uint8 status)
{
    TRANSCTRL_PARAM * transParam = gl_getTransctrlParam(gameCode);
    if (transParam == NULL)
    {
        log_error("Game code[%d] error.", gameCode);
        return -1;
    }
    switch(flag)
    {
        case 1:
        {
            transParam->saleFlag = (0 == status) ? false : true;
            break;
        }
        case 2:
        {
            transParam->payFlag = (0 == status) ? false : true;
            break;
        }
        case 3:
        {
            transParam->cancelFlag = (0 == status) ? false : true;
            break;
        }
        default:
        {
            log_error("gl_setGameCtrl( gameCode[%d] )  flag[%d] error.", gameCode, flag);
            return -1;
        }
    }

    GLTP_MSG_NTF_GL_CONTROL_GAME notify;
    notify.gameCode = gameCode;
    notify.flag = flag;
    notify.status = status;
    sys_notify(GLTP_NTF_GL_CONTROL_GAME, _WARN, (char *)&notify, sizeof(GLTP_MSG_NTF_GL_CONTROL_GAME));
    return 0;
}

//设置游戏允许退票时间
int gl_setCancelTime(uint8 gameCode,uint32 cancelTime)
{
    TRANSCTRL_PARAM * transParam = gl_getTransctrlParam(gameCode);
    if (transParam == NULL)
    {
        log_error("Game code[%d] error.", gameCode);
        return -1;
    }
    transParam->cancelTime = cancelTime;
    return 0;
}

//设置游戏自动开奖标记(针对电子开奖游戏有效)
int gl_setAutoDrawStatus(uint8 gameCode, uint8 status)
{
    TRANSCTRL_PARAM * transParam = gl_getTransctrlParam(gameCode);
    if (transParam == NULL)
    {
        log_error("Game code[%d] error.", gameCode);
        return -1;
    }
    transParam->autoDraw = status;

    GLTP_MSG_NTF_GL_ISSUE_AUTO_DRAW notify;
    notify.gameCode = gameCode;
    notify.status = status;
    sys_notify(GLTP_NTF_GL_ISSUE_AUTO_DRAW, _WARN, (char *)&notify, sizeof(GLTP_MSG_NTF_GL_ISSUE_AUTO_DRAW));
    return 0;
}

//添加游戏开奖RNG
int gl_setGameParamRng(RNG_PARAM *rngParam)
{
    RNG_PARAM *hostRngParam = gl_getRngData();
    for (int i = 0; i < MAX_RNG_NUMBER; i++)
    {
        if (hostRngParam[i].used == false)
        {
            memcpy(&hostRngParam[i], rngParam, sizeof(RNG_PARAM));
            hostRngParam[i].status = ENABLED; //RNG一直处于ENABLED状态
            hostRngParam[i].workStatus = 0;   //RNG初始处于未连接状态
            hostRngParam[i].used = true;
            return 0;
        }
    }
    return -1;
}

//设置RNG工作状态
int gl_setRngWorkStatus(uint32 rngId, int workStatus)
{
    RNG_PARAM *hostRngParam = gl_getRngData();
    for (int i = 0; i < MAX_RNG_NUMBER; i++)
    {
        if (hostRngParam[i].used && hostRngParam[i].rngId == rngId)
        {
            hostRngParam[i].workStatus = workStatus;

            //向TFE发送RNG工作状态改变消息用于入Oracle数据库
            INM_MSG_RNG_STATUS inm_msg;
            inm_msg.header.length = sizeof(INM_MSG_RNG_STATUS);
            inm_msg.header.type = INM_TYPE_RNG_STATUS;
            inm_msg.header.status = SYS_RESULT_SUCCESS;
            inm_msg.rngId = rngId;
            inm_msg.workStatus = workStatus;
            FID fid_tfe_adder = getFidByName("tfe_adder");
            bq_send(fid_tfe_adder, (char*)&inm_msg, *(uint16*)&inm_msg);

            //向监控发送RNG工作状态改变的Notify消息
            GLTP_MSG_NTF_GL_RNG_WORK_STATUS notify;
            notify.rngId = rngId;
            notify.workStatus = workStatus;
            memcpy(notify.mac, hostRngParam[i].rngMac, 6);
            memcpy(notify.ipaddr, hostRngParam[i].rngIp, 16);
            sys_notify(GLTP_NTF_GL_RNG_WORK_STATUS, _WARN, (char*)&notify, sizeof(notify));
            return 0;
        }
    }
    return -1;
}


//checkpoint 数据保存及恢复
int32 gl_chkp_save(char *chkp_path)
{
    GL_CHKP_DATA data;
    memset(&data, 0, sizeof(GL_CHKP_DATA));
    uint8 gameCode = 0;
    for (gameCode=0; gameCode<MAX_GAME_NUMBER; gameCode++)
    {
        GAME_DATA* gameData = &(gl_database_ptr->gameTable[gameCode]);
        if (gameData->used)
            memcpy(&(data.gameStat[gameCode]), &(gameData->gameDayStat), sizeof(GAME_DAY_STAT));
    }

    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName, "%s/gl.snapshot", chkp_path);
    if((fp = open(fileName,O_CREAT|O_WRONLY,S_IRUSR )) < 0 )
    {
        log_error("open %s error!",fileName);
        return -1;
    }
    ssize_t ret = write(fp, (const void *)&data, sizeof(GL_CHKP_DATA));
    if(ret < 0)
    {
        log_error("write %s error errno[%d]",fileName, errno);
        return -1;
    }
    close(fp);
    return 0;
}
int32 gl_chkp_restore(char *chkp_path)
{
    GL_CHKP_DATA data;

    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName, "%s/gl.snapshot", chkp_path);
    if((fp = open(fileName,O_RDONLY )) < 0 )
    {
        log_error("open %s error!", fileName);
        return -1;
    }
    ssize_t ret = read(fp, (void *)&data, sizeof(GL_CHKP_DATA));
    if(ret < 0)
    {
        log_error("read %s error errno[%d]",fileName,errno);
        return -1;
    }
    close(fp);

    uint8 gameCode = 0;
    for (gameCode=0; gameCode<MAX_GAME_NUMBER; gameCode++)
    {
        GAME_DATA* gameData = &(gl_database_ptr->gameTable[gameCode]);
        if (gameData->used)
            memcpy(&(gameData->gameDayStat), &(data.gameStat[gameCode]), sizeof(GAME_DAY_STAT));
    }
    return 0;
}


//--------------------------------------------------------------------------------

#define TSN_BYTE_LENGTH    12

#define TS_START_YEAR   20150101
#define TS_END_YEAR     20420501
#define TS_MAX_DAYS     9863
#define TS_OFFSET_YEAR  2015
#define TS_HEAD_YEAR    2015
#define TS_TAIL_YEAR    2042
static int yeartab[28][5]= {
    //{ 年, 年偏移, 闰年, 本年多少天, 本年1月1日距离TS_START_YEAR多少天}
    {2015,  0,  365,  1        },
    {2016,  1,  366,  366      },
    {2017,  0,  365,  732      },
    {2018,  0,  365,  1097     },
    {2019,  0,  365,  1462     },
    {2020,  1,  366,  1827     },
    {2021,  0,  365,  2193     },
    {2022,  0,  365,  2558     },
    {2023,  0,  365,  2923     },
    {2024,  1,  366,  3288     },
    {2025,  0,  365,  3654     },
    {2026,  0,  365,  4019     },
    {2027,  0,  365,  4384     },
    {2028,  1,  366,  4749     },
    {2029,  0,  365,  5115     },
    {2030,  0,  365,  5480     },
    {2031,  0,  365,  5845     },
    {2032,  1,  366,  6210     },
    {2033,  0,  365,  6576     },
    {2034,  0,  365,  6941     },
    {2035,  0,  365,  7306     },
    {2036,  1,  366,  7671     },
    {2037,  0,  365,  8037     },
    {2038,  0,  365,  8402     },
    {2039,  0,  365,  8767     },
    {2040,  1,  366,  9132     },
    {2041,  0,  365,  9498     },
    {2042,  0,  365,  9863     }
};
static char daytab[2][13]= {
    {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31},
    {0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
};
//offset_days -> (离开始年的1月1日的天数)  return 年月日( 20150921 )
int c_date(int offset_days) {
    if (offset_days<1 || offset_days>TS_MAX_DAYS) return -1;
    int idx = offset_days/365;
    while(1) {
        if (yeartab[idx][3] > offset_days) { idx--; continue; }
        break;
    }
    int day_in_year = offset_days - yeartab[idx][3];
    int month = 1;
    for (month = 1; day_in_year>=daytab[yeartab[idx][1]][month]; month++) {
        day_in_year -= daytab[yeartab[idx][1]][month];
    }
    return (yeartab[idx][0]*10000 + month*100 + day_in_year+1);
}
//date -> 20150921 , return 1234 (离开始年的1月1日的天数)
int c_days(int date) {
    if (date<TS_START_YEAR || date>TS_END_YEAR) return -1;
    int days,year,month,day, i;
    int idx = (date/10000 - TS_OFFSET_YEAR);
    days = yeartab[idx][3];
    year = yeartab[idx][0];
    month = date%10000/100;
    day = date%100;
    for (i = 1; i < month ; i++) {
        day += daytab[yeartab[idx][1]][i];
    }
    return (days + day-1);
}

uint64 encry_digit_tsn(uint64 number)
{
	int n[18];
	int i = 0;
	uint64 encry_number = number;
    //提取每位数字
    int k = 1;
	for (i=0;i<18;i++)
    {
    	n[i] = encry_number % 10;
    	encry_number /= 10;
    	//每位数字+7再对10取模
    	n[i] = ( n[i] + k ) % 10;
    	k++; if (k>9) k=1;
	}
	//交换原始数字
	encry_number = n[15]; n[15] = n[1]; n[1] = encry_number; // 1 <---> 15
	encry_number = n[10]; n[10] = n[2]; n[2] = encry_number; // 2 <---> 10
	encry_number = n[5]; n[5] = n[3]; n[3] = encry_number; // 3 <---> 5
	encry_number = n[8]; n[8] = n[4]; n[4] = encry_number; // 4 <---> 8
	encry_number = n[12]; n[12] = n[6]; n[6] = encry_number; // 6 <---> 12
	encry_number = n[9]; n[9] = n[7]; n[7] = encry_number; // 7 <---> 9
	encry_number = n[16]; n[16] = n[17]; n[17] = encry_number; // 16 <---> 17
	//计算出加密18位数字
	encry_number = 0;
	for (i=17;i>=0;i--)
    {
    	if (i==0)
    	    encry_number += n[i];
    	else
    	    encry_number += n[i] * (uint64)pow(10,i);
	}
    return encry_number;
}
uint64 decry_digit_tsn(uint64 encry_number)
{
	int n[18];
	int i = 0;
	uint64 number = encry_number;
    //提取每位数字
    int k = 1;
	for (i=0;i<18;i++)
    {
    	n[i] = number % 10;
    	number /= 10;
	}
	//交换原始数字
	number = n[15]; n[15] = n[1]; n[1] = number; // 1 <---> 15
	number = n[10]; n[10] = n[2]; n[2] = number; // 2 <---> 10
	number = n[5]; n[5] = n[3]; n[3] = number; // 3 <---> 5
	number = n[8]; n[8] = n[4]; n[4] = number; // 4 <---> 8
	number = n[12]; n[12] = n[6]; n[6] = number; // 6 <---> 12
	number = n[9]; n[9] = n[7]; n[7] = number; // 7 <---> 9
	number = n[16]; n[16] = n[17]; n[17] = number; // 16 <---> 17
	k = 1;
	for (i=0;i<18;i++)
    {
    	//每位数字+3再对10取模
    	n[i] = (n[i]+(10-k)) % 10;
    	k++; if (k>9) k=1;
	}
	//计算出原始18位数字
	number = 0;
	for (i=17;i>=0;i--)
    {
    	if (i==0)
    	    number += n[i];
    	else
    	    number += n[i] * (uint64)pow(10,i);
	}
	return number;
}


//生成 DIGIT TSN (内部使用的明文TSN)
uint64 generate_digit_tsn(uint32 date, uint16 fileIdx, uint32 fileOffset)
{
    uint64 days = c_days(date);
    return (days*D15 + fileIdx*D10 + fileOffset);
}
#define TS_MAX_FILEOFFSET 512*1024*1024
//解析 DIGIT TSN (内部使用的明文TSN)
int extract_digit_tsn(uint64 unique_tsn, uint32 *date, uint16 *fileIdx, uint32 *fileOffset)
{
    if (date != NULL) {
        uint32 days = unique_tsn / D15;
        if ( (days<1) ||(days>TS_MAX_DAYS) ) {
            log_error("extract_digit_tsn() failed. days out of range. [%u]", days);
            return -1;
        }
        *date = c_date(days);
    }
    if (fileIdx != NULL) {
        *fileIdx = (unique_tsn / D10) % 100000;
    }
    if (fileOffset != NULL) {
        *fileOffset = unique_tsn % D10;
        if (*fileOffset>TS_MAX_FILEOFFSET) {
            log_error("extract_digit_tsn() failed. file_offset out of range. [%u]", *fileOffset);
            return -1;
        }
    }
    return 0;
}

//使用 内部的digit_tsn 生成用于外部的 字符串票号
int generate_tsn(uint64 unique_tsn, char *tsn_str)
{
    //正向 从unique_tsn生成tsn字符串
    struct timeval tv;
    gettimeofday(&tv, NULL);
    uint32 vfyc = tv.tv_usec;
    sprintf(tsn_str, "%18llu%06u", encry_digit_tsn(unique_tsn), vfyc);
    tsn_str[TSN_LENGTH-1] = '\0';
    return 0;
}
//使用 外部的 字符串票号 生成 内部的digit_tsn
uint64 extract_tsn(char *tsn_str, uint32 *date)
{
	char tmp_tsn[19] = {0};
	memcpy(tmp_tsn, tsn_str, 18);
	uint64 t = atoll(tmp_tsn);
	if (t/D15 == 0) return 0;
    uint64 unique_tsn = decry_digit_tsn(t);
    if (date != NULL) {
        uint32 days = unique_tsn / D15;
        int d = c_date(days);
        if (-1 == d) {
        	log_info("MAYBE This is OLD TSN. tsn_str[ %s ]  unique_tsn[ %llu ]", tsn_str, unique_tsn);
        	return 0;
        } else {
        	*date = d;
        }
    }
    return unique_tsn;
}



#ifdef SUPPORT_OLD_TSN
//sqlite函数
#include "gfp_mod.h"
#include "gidb_mod.h"
#endif

#ifdef SUPPORT_OLD_TSN

//  OLD TSN 相关 --------------------------------------------------------------------




//系统响应流水定义(共12个字节)
/*
typedef struct _TSN_STRUC
{
    //BIT
    site:4; (0 - 3)
    game:8; (4 - 11)
    issue:32; (12 - 43)
    tfe_file:16; (44 - 59)
    tfe_offset:32;(60 - 91)
    crc:4;(92 - 95)
}TSN_STRUC;
*/

// site
#define TSN_SITE_BIT_OFFSET         0
#define TSN_SITE_BIT_LENGTH         4
//game
#define TSN_GAME_BIT_OFFSET         4
#define TSN_GAME_BIT_LENGTH         8
//issue
#define TSN_ISSUE_BIT_OFFSET        12
#define TSN_ISSUE_BIT_LENGTH        32
//tfe_file_idx
#define TSN_FILEIDX_BIT_OFFSET      44
#define TSN_FILEIDX_BIT_LENGTH      16
//tfe_file_offset
#define TSN_OFFSET_BIT_OFFSET       60
#define TSN_OFFSET_BIT_LENGTH       32
//crc
#define TSN_CRC_BIT_OFFSET          92
#define TSN_CRC_BIT_LENGTH          4



//组装交易响应流水号 12个字节
int32 fillin_bits(uint8 * buffer, uint32 offset, uint32 length, uint32 num)
{
    uint32 st, ln, lt, rt, cnt, tl, tr;
    uint8 c, c1, c2;
    int32 i;

    st = offset>>3;
    lt = offset&0x07;
    rt = 7-((offset+length-1)&0x07);
    cnt = ((offset+length-1)>>3)-(offset>>3)+1;

    for (i = cnt-1; i>=0; i--) {
        tl = tr = 0;
        c = *(buffer+st+i);
        if (0==i) {
            tl = lt;
        }
        if (cnt-1==(uint32)i) {
            tr = rt;
        }

        ln = 8-tl-tr;
        c1 = num&0x00ff;
        c1 <<= tr;
        c1 <<= tl;
        c1 >>= tl;
        c2 = 0xff;
        c2 <<= tl;
        c2 >>= tl;
        c2 >>= tr;
        c2 <<= tr;
        c &= ~c2;
        c |= c1;
        *(buffer+st+i) = c;
        num >>= ln;
    }

    return 0;
}

uint32 extract_bits(char * buffer, uint32 offset, uint32 length)
{
    uint32 ret = 0;
    uint32 st, ln, lt, rt, i, cnt, tl, tr;
    uint8 c;

    st = offset>>3;
    lt = offset&0x07;
    rt = 7-((offset+length-1)&0x07);
    cnt = ((offset+length-1)>>3)-(offset>>3)+1;

    for (i = 0; i<cnt; i++) {
        tl = tr = 0;
        c = *(buffer+st+i);

        if (0==i) {
            tl = lt;
        }
        if (cnt-1==i) {
            tr = rt;
        }

        ln = 8-tl-tr;
        c <<= tl;
        c >>= tl;
        c >>= tr;
        ret <<= ln;
        ret |= c;
    }
    return ret;
}

uint8 generate_crc(uint8 *tsn, int32 length)
{
    uint8 crc = 0;
    for (int32 i = 0; i<length; i++) {
        crc += *(tsn+i);
    }
    return (crc & 0x0F);
}

//----------------辅助函数，将tsn搅混-------------------------//

//将tsn[index1]&mask和tsn[index2]&mask交换
#define bitswap(tsn, index1, index2, mask) \
    do { \
        tsn[index1] ^= tsn[index2] & mask; \
        tsn[index2] ^= tsn[index1] & mask; \
        tsn[index1] ^= tsn[index2] & mask; \
    } while (0)

//将tsn[index]中的bit反转
#define reversebyte(tsn, index) \
    do { \
        uint8 swap = 0; \
        int i; \
        for (i = 0; i < 8; i++) { \
            swap |= (((tsn[index]>>i)&1) << (7-i)); \
        } \
        tsn[index] = swap; \
    } while (0)

//将tsn中每个字节的前4个bit与后4个bit交换
#define rotate4(tsn) \
    do { \
        int i; \
        for (i = 0; i < 12; i++) { \
            tsn[i] = (tsn[i]>>4)|(tsn[i]<<4); \
        } \
    } while (0)

//将整个tsn的bit反转
#define reverse(tsn) \
    do { \
        bitswap(tsn, 0, 11, 0xFF); reversebyte(tsn, 0); reversebyte(tsn, 11); \
        bitswap(tsn, 1, 10, 0xFF); reversebyte(tsn, 1); reversebyte(tsn, 10); \
        bitswap(tsn, 2, 9, 0xFF);  reversebyte(tsn, 2); reversebyte(tsn, 9); \
        bitswap(tsn, 3, 8, 0xFF);  reversebyte(tsn, 3); reversebyte(tsn, 8); \
        bitswap(tsn, 4, 7, 0xFF);  reversebyte(tsn, 4); reversebyte(tsn, 7); \
        bitswap(tsn, 5, 6, 0xFF);  reversebyte(tsn, 5); reversebyte(tsn, 6); \
    } while (0)

//异或操作用key
static uint8 keys[12] = {
        0x4f, 0x65, 0xa2, 0x37, 0xd8, 0xc0,
        0x41, 0x32, 0x6b, 0xfe, 0xbb, 0x52,
};
//异或操作
#define tsnxor(tsn) \
    do { \
        int i; \
        for (i = 0; i < 12; i++) { \
            tsn[i] ^= keys[i]; \
        } \
    } while (0)

//从倒数第二个字节开始往前，用后面的字节与当前字节异或，到第一个字节为止
//(因为后面的字节变化较频繁，用此方法可以扩散误差)
#define spread_err(tsn) \
    do { \
        int i; \
        for (i = 11; i > 0; i--) { \
            tsn[i-1] ^= tsn[i]; \
        } \
    } while (0)

//spread_err的逆操作
#define reduce_err(tsn) \
    do { \
        int i; \
        for (i = 0; i < 11; i++) { \
            tsn[i] ^= tsn[i+1]; \
        } \
    } while (0)


void encry_tsn(uint8 * tsn)
{
    spread_err(tsn);
    int i;
    for (i = 0; i < 3; i++) {
        bitswap(tsn, 0, 6, 0x1F);
        bitswap(tsn, 1, 7, 0x1F);
        bitswap(tsn, 2, 8, 0x1F);
        bitswap(tsn, 3, 9, 0x1F);
        bitswap(tsn, 4, 10, 0x1F);
        bitswap(tsn, 5, 11, 0x1F);
        reverse(tsn);
        bitswap(tsn, 0, 10, 0x3C);
        bitswap(tsn, 1, 5, 0x3C);
        bitswap(tsn, 2, 7, 0x3C);
        bitswap(tsn, 3, 11, 0x3C);
        bitswap(tsn, 4, 8, 0x3C);
        rotate4(tsn);
    }
    tsnxor(tsn);
}
void decry_tsn(uint8 * tsn)
{
    int i;
    tsnxor(tsn);
    for (i = 0; i < 3; i++) {
        rotate4(tsn);
        bitswap(tsn, 4, 8, 0x3C);
        bitswap(tsn, 3, 11, 0x3C);
        bitswap(tsn, 2, 7, 0x3C);
        bitswap(tsn, 1, 5, 0x3C);
        bitswap(tsn, 0, 10, 0x3C);
        reverse(tsn);
        bitswap(tsn, 0, 6, 0x1F);
        bitswap(tsn, 1, 7, 0x1F);
        bitswap(tsn, 2, 8, 0x1F);
        bitswap(tsn, 3, 9, 0x1F);
        bitswap(tsn, 4, 10, 0x1F);
        bitswap(tsn, 5, 11, 0x1F);
    }
    reduce_err(tsn);
}

//将TSN转大写
int upper_tsn(char *tsn_str)
{
    for (int i = 0; i < TSN_LENGTH; i++)
    {
        tsn_str[i] = toupper(tsn_str[i]);
    }
    return 0;
}

//生成 明文UNIQUE TSN
uint64 generate_old_unique_tsn(uint16 fileIdx, uint32 fileOffset)
{
    uint64 max_fileIdx = 9999999;
    uint64 max_fileOffset = 1; max_fileOffset = max_fileOffset * 512*1024*1024;
    assert(fileIdx<=max_fileIdx);
    assert(fileOffset<max_fileOffset);
    uint64 tsn = fileIdx;
    tsn = tsn * D10 + fileOffset;
    return tsn;
}

//解析 TSN
uint64 extract_old_tsn(char *tsn_str, uint32 *date)//注意返回值-1, uint64类型
{
	//uint8 gameCode = 0;
	//uint32 issueSeq = 0;
	uint16 fileIdx = 0;
	uint32 fileOffset = 0;
	uint64 unique_tsn = 0;

	upper_tsn(tsn_str);

	uint8 tmptsn[TSN_BYTE_LENGTH];
    hex_decode_binary(tsn_str, (TSN_LENGTH-1), tmptsn);


    decry_tsn(tmptsn);
    uint8 crc_0 = tmptsn[TSN_BYTE_LENGTH-1] & 0x0F;
    tmptsn[TSN_BYTE_LENGTH-1] = tmptsn[TSN_BYTE_LENGTH-1] & 0xF0;
    uint8 crc_1 = generate_crc(tmptsn, TSN_BYTE_LENGTH);
    if (crc_0 != crc_1)
    {
        log_error("extract_tsn() failed. crc error.[%s]", tsn_str);
        return 0;
    }
	//gameCode = extract_bits((char*)tmptsn, TSN_GAME_BIT_OFFSET, TSN_GAME_BIT_LENGTH);
	//issueSeq = extract_bits((char*)tmptsn, TSN_ISSUE_BIT_OFFSET, TSN_ISSUE_BIT_LENGTH);
	fileIdx = extract_bits((char *)tmptsn, TSN_FILEIDX_BIT_OFFSET, TSN_FILEIDX_BIT_LENGTH);
	fileOffset = extract_bits((char *)tmptsn, TSN_OFFSET_BIT_OFFSET, TSN_OFFSET_BIT_LENGTH);

    uint64 max_fileIdx = 9999999;
    uint64 max_fileOffset = 1; max_fileOffset = max_fileOffset * 512*1024*1024;
    if(fileIdx > max_fileIdx)
    	return 0;

    if(fileOffset >= max_fileOffset)
    	return 0;

    uint64 old_unique_tsn = generate_old_unique_tsn(fileIdx, fileOffset);

    //查询unique_tsn对应表
    char db_path[256] = {DATA_ROOT_DIR "/tsn_upgrade.db"};

    //open sqlite db connect
    sqlite3 *db = db_connect(db_path);
    if ( db == NULL ) {
        log_error("db_connect(%s) error.", db_path);
        return 0;
    }
    char sql_tsn_str[256] = {0};
	char str[256] = "SELECT unique_tsn, dt FROM tsn_upgrade_table WHERE old_unique_tsn = %llu";
	sprintf(sql_tsn_str, str, old_unique_tsn);
	sqlite3_stmt *pStmt = NULL;
	if (sqlite3_prepare_v2(db, sql_tsn_str, strlen(sql_tsn_str), &pStmt, NULL) != SQLITE_OK) {
		log_error("sqlite3_prepare_v2() error.");
		if (pStmt) {
			sqlite3_finalize(pStmt);
		}
		return 0;
	}
	int rc = sqlite3_step(pStmt);
	if ( rc == SQLITE_ROW ) {
		unique_tsn = sqlite3_column_int64(pStmt, 0);
		*date = sqlite3_column_int(pStmt, 1);
	} else if( rc == SQLITE_DONE) {
		//成功处理完毕
		log_info("no record.  old_unique_tsn[%llu]. rc[%d]",
						old_unique_tsn, rc);
		unique_tsn = 0;
	} else {
		log_error("sqlite3_step error. old_unique_tsn[%llu]. rc[%d]",
				old_unique_tsn, rc);
		if (pStmt) {
			sqlite3_finalize(pStmt);
		}
		return 0;
	}
	sqlite3_finalize(pStmt);
	db_close(db);

    return unique_tsn;
}

#endif


regex_t  re_ticket;
regex_t  re_bettype[MAX_BETTYPE_COUNT];

bool ts_regex_ticket_match(const char *str)
{
    int status = regexec(&re_ticket, str, (size_t)0, NULL, 0);
    return (status == 0);
}

bool ts_regex_bettype_match(uint8 bet, const char *str)
{
    int status = regexec(&re_bettype[bet], str, (size_t)0, NULL, 0);
    return (status == 0);
}

const char bettypePattern[MAX_BETTYPE_COUNT][10] =
{ "",
"[^0-9+:*]", //DS
"[^0-9+]",   //FS
"[^0-9<+]",  //DT
"[^0-9:]",   //BD
"[^0-9]",    //HZ
"[^0-9+:]",  //BC
"",          //BH
"[^0-9+:]",  //YXFS
"[^0-9:]" }; //FW

void ts_regex_init(void)
{
    const char *pattern_ticket = "[^\]\[0-9A-Z(<)+:*\|/-]";
    regcomp(&re_ticket, pattern_ticket, REG_EXTENDED | REG_NOSUB);

    for (int i = 0; i < MAX_BETTYPE_COUNT; i++)
    {
        if (bettypePattern[i] != NULL)
        {
            regcomp(&re_bettype[i], bettypePattern[i], REG_EXTENDED | REG_NOSUB);
        }
    }
}

void ts_regex_release(void)
{
    regfree(&re_ticket);
    for (int i = 0; i < MAX_BETTYPE_COUNT; i++)
    {
        if (bettypePattern[i] != NULL)
        {
            regfree(&re_bettype[i]);
        }
    }
}
