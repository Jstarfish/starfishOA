#include "global.h" 
#include "sysdb.h"


//---------------------------------------------------------------------------------------
//
//      /ts_host/data/ 下的目录及文件的相关 路径函数 接口
//
//---------------------------------------------------------------------------------------

//----------- SESSION -----------------------------------------

// 得到指定的Session文件路径
//-->  /ts_host/data/tf_data/session
int32 ts_get_session_filepath(char *path, int len)
{
    return snprintf(path, len, "%s/session", TFE_DATA_SUBDIR);
}

//----------- TF -----------------------------------------

// 得到指定的tf文件路径
//-->  /ts_host/data/tf_data/datazoo_N.tf
int32 ts_get_tf_filepath(uint32 tf_idx, char *path, int len)
{
    return snprintf(path, len, "%s/datazoo_%d.tf", TFE_DATA_SUBDIR, tf_idx);
}

//----------- Ticket Index -------------------------------

//-->  /ts_host/data/tidx_data/
int32 ts_get_ticket_idx_filepath(uint32 date, char *path, int len)
{
    return snprintf(path, len, "%s/%u.idx", TIDX_DATA_SUBDIR, date);
}


//----------- Game ---------------------------------------

//得到游戏数据根目录
//-->  /ts_host/data/game_data
int32 ts_get_game_root_dir(char *path, int len)
{
    return snprintf(path, len, "%s", GAME_DATA_SUBDIR);
}

//得到指定的游戏数据目录
//-->  /ts_host/data/game_data/game_N/
int32 ts_get_game_dir(char *game_abbr, char *path, int len)
{
    return snprintf(path, len, "%s/game_%s", GAME_DATA_SUBDIR, game_abbr);
}

//得到指定的游戏开奖数据目录
//-->  /ts_host/data/game_data/game_N/draw/
int32 ts_get_game_draw_dir(char *game_abbr, char *path, int len)
{
    return snprintf(path, len, "%s/game_%s/draw", GAME_DATA_SUBDIR, game_abbr);
}

//得到指定的游戏期次管理数据文件
//-->  /dev/shm/ts_game/game_N.db
int32 ts_get_mem_game_filepath(char *game_abbr, char *path, int len)
{
    return snprintf(path, len, "%s/game_%s.db", TS_MEM_GAME_DB, game_abbr);
}

//代理商售票memory leveldb数据文件路径
//-->  /dev/shm/ts_kvdb
int32 ts_get_kvdb_filepath(char *path, int len)
{
    return snprintf(path, len, "%s", TS_MEM_KVDB_DB);
}

//得到指定游戏 某一期的 AP中奖文件路径
//-->  /ts_host/data/win_data/ap_paid_game_12_161226017_K11X5.dat
int32 ts_get_game_issue_ap_pay_filepath(char *game_abbr,uint8 gameCode, uint64 issue_num, char *path, int len)
{
    return snprintf(path, len, "%s/ap_data/ap_paid_game_%d_%llu_%s.dat", DATA_ROOT_DIR, gameCode, issue_num, game_abbr);
}

//得到指定游戏 某一期的 票数据 db文件路径
//-->  /ts_host/data/game_data/game_N/issue_YYY.db
int32 ts_get_game_issue_ticket_filepath(char *game_abbr, uint64 issue_num, char *path, int len)
{
    return snprintf(path, len, "%s/game_%s/issue_%lld.db", GAME_DATA_SUBDIR, game_abbr, issue_num);
}

//得到指定游戏 某一期的 中奖票数据 db文件路径
//-->  /ts_host/data/game_data/game_N/issue_win_YYY.db
int32 ts_get_game_issue_ticket_win_filepath(char *game_abbr, uint64 issue_num, uint8 draw_times, char *path, int len)
{
    if (draw_times == 1)
        return snprintf(path, len, "%s/game_%s/issue_win_%lld.db", GAME_DATA_SUBDIR, game_abbr, issue_num);
    else
        return snprintf(path, len, "%s/game_%s/issue_win_%lld___%d.db", GAME_DATA_SUBDIR, game_abbr, issue_num, draw_times);
}
//得到指定游戏 某一期的 开奖过程数据 db文件路径
//-->  /ts_host/data/game_data/game_N/draw/draw_issue_YYY.db
int32 ts_get_game_issue_draw_filepath(char *game_abbr, uint64 issue_num, uint8 draw_times, char *path, int len)
{
    if (draw_times == 1)
        return snprintf(path, len, "%s/game_%s/draw/draw_issue_%lld.db", GAME_DATA_SUBDIR, game_abbr, issue_num);
    else
        return snprintf(path, len, "%s/game_%s/draw/draw_issue_%lld___%d.db", GAME_DATA_SUBDIR, game_abbr, issue_num, draw_times);
}
//得到指定游戏 某一期的 中奖数据文本文件路径
//-->  /ts_host/data/win_data/game_N/win_ticket_issue_20140627003.dat
int32 ts_get_game_issue_win_data_filepath(char *game_abbr, uint64 issue_num, uint8 draw_times, char *path, int len)
{
    if (draw_times == 1)
    	return snprintf(path, len, "%s/win_data/game_%s_issue_%lld_win_ticket.dat", DATA_ROOT_DIR, game_abbr, issue_num);
    else
    	return snprintf(path, len, "%s/win_data/game_%s_issue_%lld_win_ticket___%d.dat", DATA_ROOT_DIR, game_abbr, issue_num, draw_times);
}

//得到指定游戏 某一期的 开奖公告xml文件的路径
//-->  /ts_host/data/game_data/game_N/draw_announce_issue_YYY.xml
int32 ts_get_game_issue_draw_announce_filepath(char *game_abbr, uint64 issue_num, uint8 draw_times, char *path, int len)
{
    if (draw_times == 1)
        return snprintf(path, len, "%s/game_%s/draw_announce_issue_%lld.xml", GAME_DATA_SUBDIR, game_abbr, issue_num);
    else
        return snprintf(path, len, "%s/game_%s/draw_announce_issue_%lld___%d.xml", GAME_DATA_SUBDIR, game_abbr, issue_num, draw_times);
}


//----------- FBS Game ---------------------------------------

//得到指定 FBS游戏 某一期的 票数据 db文件路径
//-->  /ts_host/data/game_data/game_N/issue_YYY.db
int32 ts_get_fbs_issue_ticket_filepath(char *game_abbr, uint32 issue_num, char *path, int len)
{
    return snprintf(path, len, "%s/game_%s/issue_%u.db", GAME_DATA_SUBDIR, game_abbr, issue_num);
}
//得到指定 FBS游戏 某一期的 中奖票数据 db文件路径
//-->  /ts_host/data/game_data/game_N/issue_win_YYY.db
int32 ts_get_fbs_issue_ticket_win_filepath(char *game_abbr, uint32 issue_num, char *path, int len)
{
    return snprintf(path, len, "%s/game_%s/issue_win_%u.db", GAME_DATA_SUBDIR, game_abbr, issue_num);
}
//得到指定 FBS游戏 的 彩票拆单开奖数据 db文件路径
//-->  /ts_host/data/game_data/game_N/fbs_order.db
int32 ts_get_fbs_ticket_order_filepath(char *game_abbr, char *path, int len)
{
    return snprintf(path, len, "%s/game_%s/fbs_order.db", GAME_DATA_SUBDIR, game_abbr);
}
//得到指定 FBS游戏 的 彩票拆单开奖数据 meta文件路径
//-->  /ts_host/data/game_data/game_N/fbs_order.meta
int32 ts_get_fbs_ticket_meta_filepath(char *game_abbr, char *path, int len)
{
    return snprintf(path, len, "%s/game_%s/fbs_order.meta", GAME_DATA_SUBDIR, game_abbr);
}
//得到指定 FBS游戏 的 开奖过程中发生的标记文件路径 tag文件路径
//-->  /ts_host/data/game_data/game_N/fbs_order.tag
int32 ts_get_fbs_draw_tag_filepath(char *game_abbr, char *path, int len)
{
    return snprintf(path, len, "%s/game_%s/fbs_order.tag", GAME_DATA_SUBDIR, game_abbr);
}
//得到指定 FBS游戏 的 历史开奖过程数据 文件保存目录
//-->  /ts_host/data/game_data/game_N/draw
int32 ts_get_fbs_draw_dirpath(char *game_abbr, char *path, int len)
{
    return snprintf(path, len, "%s/game_%s/draw", GAME_DATA_SUBDIR, game_abbr);
}
//得到指定游戏 某一比赛场次的 中奖数据文本文件路径
//-->  /ts_host/data/win_data/game_N/win_ticket_match_xxx.dat
int32 ts_get_fbs_game_match_win_data_filepath(char *game_abbr, uint32 match_code, uint8 draw_times, char *path, int len)
{
    draw_times = 1;
    if (draw_times == 1)
        return snprintf(path, len, "%s/win_data/game_%s_match_%u_win_ticket.dat", DATA_ROOT_DIR, game_abbr, match_code);
    else
        return snprintf(path, len, "%s/win_data/game_%s_match_%u_win_ticket___%d.dat", DATA_ROOT_DIR, game_abbr, match_code, draw_times);
}



//----------- backup -------------------------------------
//得到指定游戏 某一期的 AP兑奖完成文件路径
//-->  /ts_host/data/win_data/ap_paid_game_12_161226017_K11X5.dat
int32 ts_get_game_issue_ap_paidover_filepath(char *game_abbr, uint8 gameCode, uint64 issue_num, char *path, int len)
{
    return snprintf(path, len, "%s/seal_data/ap_paid_%d_%llu_%s.over", DATA_ROOT_DIR, gameCode, issue_num, game_abbr);
}

//得到指定游戏 某一期的 封存数据的备份文件路径
//-->  /ts_host/data/seal_data/game_N_issue_20140627003_seal.dat
int32 ts_get_game_issue_seal_data_filepath(char *game_abbr, uint64 issue_num, char *path, int len)
{
    return snprintf(path, len, "%s/seal_data/game_%s_issue_%lld_seal.dat", DATA_ROOT_DIR, game_abbr, issue_num);
}


//----------- Upload -------------------------------------

//得到指定游戏的某一期的上传数据文件名
//-->  /ts_host/data/upload_data/issue_GG_YYY.upld
int32 ts_get_upload_game_issue_filepath(uint8 game_code, uint64 issue_num, char *path, int len)
{
    return snprintf(path, len, "%s/issue_%02d_%lld.upld", UPLOAD_DATA_SUBDIR, game_code, issue_num);
}


//----------- Pub -------------------------------------

//得到指定接入商的指定游戏的某一期的中奖数据文件名
//-->  /ts_host/data/pub_data/NNNN-issue_GG_YYY.pub
int32 ts_get_pub_game_issue_filepath(uint32 ap_code, uint8 game_code, uint64 issue_num, uint8 draw_times, char *path, int len)
{
    if (draw_times == 1)
        return snprintf(path, len, "%s/%010u_issue_%02d_%lld.pub", PUB_DATA_SUBDIR, ap_code, game_code, issue_num);
    else
        return snprintf(path, len, "%s/%010u_issue_%02d_%lld___%d.pub", PUB_DATA_SUBDIR, ap_code, game_code, issue_num, draw_times);
}


//----------- Snapshot -----------------------------------
//得到系统快照数据目录
//-->  /ts_host/data/snapshot_data/
int32 ts_get_snapshot_dir(char *path, int len)
{
    return snprintf(path, len, "%s/", SNAPSHOT_DATA_SUBDIR);
}

//得到系统最后一次快照的目录名
//-->  /ts_host/data/snapshot_data/YYYYMMDD.HHMMSS/
int32 ts_get_snapshot_last_dir(char *path, int len)
{
    char filename[256];
    int32 fd;
    snprintf(filename, 256, "%s/last_snapshot", SNAPSHOT_DATA_SUBDIR);

    if((fd = open(filename, O_RDONLY)) == -1)
    {
        log_error("open(%s) failed. Reason:%s.", filename, strerror(errno));
        return -1;
    }
    int count = 0;
    char buf[16];
    count = safe_read(fd, buf, sizeof(buf));
    if (count != 15)
    {
        log_error("read(%s) failed. Reason:%s.", filename, strerror(errno));
        return -1;
    }
    close(fd);
    buf[15] = '\0';

    strncpy(path, buf, len);
    return 15;
}

//得到最后一次快照目录下的(游戏)快照数据文件名
//-->  /ts_host/data/snapshot_data/YYYYMMDD.HHMMSS/game.snapshot
int32 ts_get_snapshot_game_filepath(char *path, int len)
{
    int32 ret = 0;
    char snapshot_dir[16];
    ret = ts_get_snapshot_last_dir(snapshot_dir, 16);
    if (ret <= 0)
    {
        log_error("get last snapshot dir failure.");
        return -1;
    }
    return snprintf(path, len, "%s/%s/game.snapshot", SNAPSHOT_DATA_SUBDIR, snapshot_dir);
}

//得到最后一次快照目录下指定游戏指定期的(风险控制)快照数据文件名
//-->  /ts_host/data/snapshot_data/YYYYMMDD.HHMMSS/issue_riskctrl_GG_YYY.snapshot
int32 ts_get_snapshot_issue_riskctrl_filepath(uint8 game_code, uint32 issue_num, char *path, int len)
{
    int32 ret = 0;
    char snapshot_dir[16];
    ret = ts_get_snapshot_last_dir(snapshot_dir, 16);
    if (ret <= 0)
    {
        log_error("get last snapshot dir failure.");
        return -1;
    }
    return snprintf(path, len, "%s/%s/issue_riskctrl_%02d_%d.snapshot", SNAPSHOT_DATA_SUBDIR, snapshot_dir, game_code, issue_num);
}

//得到最后一次快照目录下的(TF)快照数据文件名
//-->  /ts_host/data/snapshot_data/YYYYMMDD.HHMMSS/tf.snapshot
int32 ts_get_snapshot_tf_filepath(char *path, int len)
{
    int32 ret = 0;
    char snapshot_dir[16];
    ret = ts_get_snapshot_last_dir(snapshot_dir, 16);
    if (ret <= 0)
    {
        log_error("get last snapshot dir failure.");
        return -1;
    }
    return snprintf(path, len, "%s/%s/tf.snapshot", SNAPSHOT_DATA_SUBDIR, snapshot_dir);
}


//----------- session file -----------------------------------
bool ts_write_sessionDate_file(char* filepath,char *buf)
{
    FILE *fp = fopen(filepath, "w");
    if(fp)
	{
	  fwrite(buf, 1, strlen(buf), fp);
	  fflush(fp);
	}
    else
    	return false;
	return true;
}

bool ts_read_sessionData_file(char* filepath,char *buf)
{
    FILE *fp = fopen(filepath, "r");
    if (fp == NULL)
    {
    	return false;
    }
    fscanf(fp,"%[^\n]",buf);
    fclose(fp);

	return true;
}

uint32 ts_getNewSessionDate(uint32 oldSessionDate)
{
    return ts_offset_date(oldSessionDate, 1);
    /*
    int y = oldSessionDate / 10000;
    int m = (oldSessionDate - y * 10000) / 100;
    int d = oldSessionDate % 100;

    struct tm t;
    t.tm_sec  = 0;
    t.tm_min  = 0;
    t.tm_hour = 0;
    t.tm_mday = d + 1;
    t.tm_mon  = m - 1;
    t.tm_year = y - 1900;
    //t.tm_wday ignored, see mktime(3)
    //t.tm_yday ignored, see mktime(3)
    t.tm_isdst = 0;
    mktime(&t);
    return (t.tm_year + 1900) * 10000 + (t.tm_mon + 1) * 100 + t.tm_mday;
    */
}

//--------------------------------------------------------------------------------------------------------
//
//  系统游戏支持
//
//--------------------------------------------------------------------------------------------------------

//游戏
GAME_SUPPORT gameSupports[MAX_GAME_NUMBER] = {
    { 0,    G_NONE,        GT_NONE,               "",          DT_NONE },
    { 0,    GAME_SSQ,      GAME_TYPE_LOTTO,       "SSQ",       MANUAL_EXTERNAL }, // 1
    { 0,    GAME_3D,       GAME_TYPE_DIGIT,       "3D",        MANUAL_INTERNAL }, // 2
    { 0,    GAME_KENO,     GAME_TYPE_KENO,        "KENO",      INSTANT_GAME    }, // 3
    { 0,    GAME_7LC,      GAME_TYPE_LOTTO,       "7LC",       MANUAL_EXTERNAL }, // 4
    { 0,    GAME_SSC,      GAME_TYPE_DIGIT,       "SSC",       INSTANT_GAME    }, // 5
    { 1,    GAME_KOCTTY,   GAME_TYPE_DIGIT,       "KOCTTY",    MANUAL_INTERNAL }, // 6
    { 1,    GAME_KOC7LX,   GAME_TYPE_LOTTO,       "KOC7LX",    MANUAL_INTERNAL }, // 7
    { 0,    GAME_KOCKENO,  GAME_TYPE_KENO,        "KOCKENO",   INSTANT_GAME },    // 8
    { 0,    GAME_KOCK2,    GAME_TYPE_LOTTO,       "KOCK2",     INSTANT_GAME },    // 9
    { 0,    GAME_KOCC30S6, GAME_TYPE_LOTTO,       "KOCC30S6",  MANUAL_INTERNAL }, // 10
	{ 0,    GAME_KOCK3,    GAME_TYPE_KENO,        "KOCK3",     INSTANT_GAME },    // 11
    { 0,    GAME_KOC11X5,  GAME_TYPE_KENO,        "K11X5",     INSTANT_GAME },    // 12
    { 1,    GAME_TEMA,     GAME_TYPE_LOTTO,       "TEMA",      INSTANT_GAME },    // 13
    { 0,    GAME_FBS,      GAME_TYPE_FINAL_ODDS,  "FBS",       MANUAL_INTERNAL }, // 14
    { 0,    GAME_FODD,     GAME_TYPE_FIXED_ODDS,  "FODD",      MANUAL_INTERNAL }, // 15
};

bool game_support(uint8 game_code)
{
    if (game_code >= MAX_GAME_NUMBER)
        return false;
    if (gameSupports[game_code].used == 1)
        return true;
    return false;
}

void get_game_abbr(uint8 game_code, char *abbr)
{
    strcpy(abbr, gameSupports[game_code].gameAbbr);
}

uint8 get_game_code(char *abbr)
{
    int idx = 0;
    for (idx=0;idx<MAX_GAME_NUMBER;idx++)
    {
        GAME_SUPPORT *g = &gameSupports[idx];
        if (g->used && 0==strcmp(g->gameAbbr,abbr))
            return g->gameCode;
    }
    return 0;
}

GAME_SUPPORT *get_game_support(uint8 game_code)
{
    if (game_code >= MAX_GAME_NUMBER)
        return NULL;
    return &gameSupports[game_code];
}






//--------------------------------------------------------------------------------------------------------
//
//  Sysdb database
//
//--------------------------------------------------------------------------------------------------------


static int32 nGlobalMem = 0;
static char *pGlobalMem = NULL;

static int32 nGlobalLen = 0;

static SYS_DATABASE_PTR sysdb_database_ptr = NULL;

//NOTIFY 消息队列
static MSG_ID sysdb_NOTIFY_MQ = -1;


//创建共享内存
bool sysdb_create()
{
    IPCKEY keyid;
    nGlobalLen = sizeof( SYS_DATABASE );

    //创建keyid
    keyid = ipcs_shmkey(SYSDB_SHM_KEY);

    //创建共享内存
    nGlobalMem = sysv_get_shm(keyid, nGlobalLen, IPC_CREAT|0666);
    if( 0 > nGlobalMem )
    {
        log_fatal("sysdb_create::create global section failure!");
        return false;
    }
    //内存映射
    pGlobalMem = (char *)sysv_attach_shm(nGlobalMem,0,0);
    if( NULL==pGlobalMem )
    {
        log_fatal("sysdb_create::attach globalSection(sysdb) failure!");
        return false;
    }

    //初始化共享内存
    memset(pGlobalMem, 0, nGlobalLen);

    //初始化数据库结构指针
    sysdb_database_ptr = (SYS_DATABASE *)pGlobalMem;

    //初始化数据项
    sysdb_database_ptr->sysStartTime = 0;
    sysdb_database_ptr->sysRunningTime = 0;
    sysdb_database_ptr->sysStatus = SYS_STATUS_EMPTY;
    sysdb_database_ptr->safeClose = 0;
    sysdb_database_ptr->sessionDate = 0;
    sysdb_database_ptr->send_switch_session_flag = 0;


    log_info("sysdb_create success! shm_key[%#x] shm_id[%d] size[%d]", keyid, nGlobalMem, nGlobalLen);
    return true;
}

//删除共享内存
bool sysdb_destroy()
{
    int32 ret = -1;

    //如果创建共享内存和删除共享内存在不同的任务中，需要下面这段程序
    IPCKEY keyid;
    keyid = ipcs_shmkey(SYSDB_SHM_KEY);

    nGlobalMem = sysv_get_shm(keyid, 0, 0);
    if (-1 == nGlobalMem)
    {
        log_error("sysdb_destroy::open globalSection failure.");
        return false;
    }

    //删除共享内存
    ret = sysv_ctl_shm(nGlobalMem, IPC_RMID, NULL);
    if (ret < 0)
    {
        log_error("sysdb_destroy:delete globalSection failure.");
        return false;
    }

    //删除 NOTIFY 的 ipc 消息队列
    if (sysdb_NOTIFY_MQ >= 0 )
    {
        ipcs_delmsg(sysdb_NOTIFY_MQ);
    }

    log_info("sysdb_destroy::success " );
    return true;
}

//映射共享内存区
bool sysdb_init()
{
    IPCKEY keyid;

    keyid = ipcs_shmkey(SYSDB_SHM_KEY);

    nGlobalMem = sysv_get_shm(keyid,nGlobalLen,0);
    if( -1==nGlobalMem )
    {
        log_fatal("sysdb_init::open globalSection(sysdb) failure. keyid[%d]!", keyid);
        return false;
    }

    pGlobalMem = (char *)sysv_attach_shm(nGlobalMem,0,0);
    if( (char *)-1==pGlobalMem )
    {
        log_fatal("sysdb_init::attach globalSection(sysdb) failure!");
        return false;
    }

    //初始化数据库结构指针
    sysdb_database_ptr = (SYS_DATABASE *)pGlobalMem;

    //创建 或者 任务初始化 NOTIFY 的 ipc 消息队列
    if ((sysdb_NOTIFY_MQ = ipcs_newmsg(NOTIFY_MSG_KEY)) == IPC_FAILURE)
    {
        log_fatal("create message queue[sysdb_NOTIFY_MQ] failure.");
        return false;
    }

    return true;
}


//关闭共享内存区的映射
bool sysdb_close()
{
    int32 ret = -1;
    if( NULL==pGlobalMem )
    {
        log_fatal("sysdb_close::globalSection(sysdb) pointer is NULL!");
        return false;
    }

    //断开与共享内存的映射
    ret = sysv_detach_shm(pGlobalMem);
    if ( ret<0 )
    {
        log_fatal("sysdb_close:deattach globalSection(sysdb) failure!");
        return false;
    }

    nGlobalMem = 0;
    pGlobalMem = NULL;
    sysdb_database_ptr = NULL;
    return true;
}

//清理sysdb内存中的活动数据
bool sysdb_clear()
{
    if( NULL==pGlobalMem )
    {
        log_fatal("sysdb_clear::globalSection(sysdb) pointer is NULL!");
        return false;
    }

    //初始化共享内存
    memset(pGlobalMem, 0, nGlobalLen);

    //初始化数据项
    sysdb_database_ptr->sysStartTime = 0;
    sysdb_database_ptr->sysRunningTime = 0;
    sysdb_database_ptr->sysStatus = SYS_STATUS_EMPTY;

	return true;
}


SYS_DATABASE_PTR sysdb_getDatabasePtr()
{
    return sysdb_database_ptr;
}

bool sysdb_load_config()
{
    char    str[128]={0};
	XMLElement* subtypes = NULL;
	XMLElement* temp = NULL;
    
    XML xmlFile(SYSDB_CONFIG_FILE);
    
    if (xmlFile.IntegrityTest() != true || xmlFile.ParseStatus() == XML_PARSE_ERROR)
    {
        log_error("[%s] xml integrity check failed!", SYSDB_CONFIG_FILE);
        return false;
    }

    //log_level数据
	temp =  xmlFile.GetRootElement()->FindElementZ("version" , false);
	temp->GetContents()[0]->GetValue(str);
    sysdb_database_ptr->version = atoi(str);

    //log_level数据
	temp =  xmlFile.GetRootElement()->FindElementZ("log_level" , false);
	temp->GetContents()[0]->GetValue(str);
    sysdb_database_ptr->log_level = atoi(str);

    //machine_data数据
	temp =  xmlFile.GetRootElement()->FindElementZ("machine_code" , false);
	temp->GetContents()[0]->GetValue(str);
    sysdb_database_ptr->machineCode = atoi(str);

    //switch_day_time数据
	temp =  xmlFile.GetRootElement()->FindElementZ("switch_session_time" , false);
	temp->GetContents()[0]->GetValue(str);
    sysdb_database_ptr->switch_session_time = atoi(str);

    //token_expired数据
	temp =  xmlFile.GetRootElement()->FindElementZ("token_expired" , false);
	temp->GetContents()[0]->GetValue(str);
    sysdb_database_ptr->token_expired = atoi(str);

    //ncpc数据
    subtypes = xmlFile.GetRootElement()->FindElementZ("ncpc", false); 
    temp =  subtypes->FindElementZ("port" , false);
    temp->GetContents()[0]->GetValue(str);
    sysdb_database_ptr->ncp_port = atoi(str);
    temp =  subtypes->FindElementZ("http_port" , false);
    temp->GetContents()[0]->GetValue(str);
    sysdb_database_ptr->ncp_http_port = atoi(str);

    //rng server数据
    subtypes = xmlFile.GetRootElement()->FindElementZ("rng_server", false); 
    temp =  subtypes->FindElementZ("port" , false);
    temp->GetContents()[0]->GetValue(str);
    sysdb_database_ptr->rng_port = atoi(str);

    //oms_monitor数据
    subtypes = xmlFile.GetRootElement()->FindElementZ("oms_monitor", false);
	temp =  subtypes->FindElementZ("ip" , false);
	temp->GetContents()[0]->GetValue(str);
	sprintf(sysdb_database_ptr->oms_monitor.oms_monitor_ip ,  "%s" , str);

    temp =  subtypes->FindElementZ("port" , false);
    temp->GetContents()[0]->GetValue(str);
    sysdb_database_ptr->oms_monitor.oms_monitor_port = atoi(str);

    //载入om database 配置
	subtypes = xmlFile.GetRootElement()->FindElementZ("oms_db_config", false);
	temp =  subtypes->FindElementZ("url" , false);
	temp->GetContents()[0]->GetValue(str);
	sprintf(sysdb_database_ptr->db_oms.url,  "%s" , str);

	temp =  subtypes->FindElementZ("username" , false);
	temp->GetContents()[0]->GetValue(str);
	sprintf(sysdb_database_ptr->db_oms.username,  "%s" , str);

	temp =  subtypes->FindElementZ("password" , false);
	temp->GetContents()[0]->GetValue(str);
	sprintf(sysdb_database_ptr->db_oms.password,  "%s" , str);

    //载入mis database 配置
	subtypes = xmlFile.GetRootElement()->FindElementZ("mis_db_config", false);
	temp =  subtypes->FindElementZ("url" , false);
	temp->GetContents()[0]->GetValue(str);
	sprintf(sysdb_database_ptr->db_mis.url,  "%s" , str);

	temp =  subtypes->FindElementZ("username" , false);
	temp->GetContents()[0]->GetValue(str);
	sprintf(sysdb_database_ptr->db_mis.username,  "%s" , str);

	temp =  subtypes->FindElementZ("password" , false);
	temp->GetContents()[0]->GetValue(str);
	sprintf(sysdb_database_ptr->db_mis.password,  "%s" , str);

	//载入exchange_rate配置
	subtypes = xmlFile.GetRootElement()->FindElementZ("exchange_rate", false);
	temp = subtypes->FindElementZ("riel_to_usd", false);
	temp->GetContents()[0]->GetValue(str);
	sysdb_database_ptr->riel_to_usd = atoi(str);

    //task数据
    SYS_TASK_RECORD *pTaskEntry = NULL;

    //tstop
    pTaskEntry = &sysdb_database_ptr->taskArray[SYS_TASK_TSTOP];
    pTaskEntry->used = true;
    pTaskEntry->taskProcId = -1;
    pTaskEntry->process_exited = false;
    pTaskEntry->taskStatus = SYS_TASK_STATUS_EXIT;
    sprintf(pTaskEntry->taskName, "tstop");
    sprintf(pTaskEntry->taskPath, "%s/", TASK_ROOT_DIR);
    pTaskEntry->restartTask = 0;

    /*
    //bqueuesd
    pTaskEntry = &sysdb_database_ptr->taskArray[SYS_TASK_BQUEUESD];
    pTaskEntry->used = true;
    pTaskEntry->taskProcId = -1;
    pTaskEntry->process_exited = false;
    pTaskEntry->taskStatus = SYS_TASK_STATUS_EXIT;
    sprintf(pTaskEntry->taskName, "bqueuesd");
    sprintf(pTaskEntry->taskPath, "%s/", TASK_ROOT_DIR);
    pTaskEntry->restartTask = 0;
    */

    //ncpc_task
    pTaskEntry = &sysdb_database_ptr->taskArray[SYS_TASK_NCPC_TASK];
    pTaskEntry->used = true;
    pTaskEntry->taskProcId = -1;
    pTaskEntry->process_exited = false;
    pTaskEntry->taskStatus = SYS_TASK_STATUS_EXIT;
    sprintf(pTaskEntry->taskName, "ncpc_task");
    sprintf(pTaskEntry->taskPath, "%s/", TASK_ROOT_DIR);
    pTaskEntry->restartTask = 0;

    //ncpc_ap_pay
    pTaskEntry = &sysdb_database_ptr->taskArray[SYS_TASK_NCPC_AUTOPAY];
    pTaskEntry->used = true;
    pTaskEntry->taskProcId = -1;
    pTaskEntry->process_exited = false;
    pTaskEntry->taskStatus = SYS_TASK_STATUS_EXIT;
    sprintf(pTaskEntry->taskName, "ncpc_ap_pay");
    sprintf(pTaskEntry->taskPath, "%s/", TASK_ROOT_DIR);
    pTaskEntry->restartTask = 0;

    //gl_driver
    pTaskEntry = &sysdb_database_ptr->taskArray[SYS_TASK_GL_DRIVER];
    pTaskEntry->used = true;
    pTaskEntry->taskProcId = -1;
    pTaskEntry->process_exited = false;
    pTaskEntry->taskStatus = SYS_TASK_STATUS_EXIT;
    sprintf(pTaskEntry->taskName, "gl_driver");
    sprintf(pTaskEntry->taskPath, "%s/", TASK_ROOT_DIR);
    pTaskEntry->restartTask = 0;

    //gl_fbs_driver
    pTaskEntry = &sysdb_database_ptr->taskArray[SYS_TASK_GL_FBS_DRIVER];
    pTaskEntry->used = true;
    pTaskEntry->taskProcId = -1;
    pTaskEntry->process_exited = false;
    pTaskEntry->taskStatus = SYS_TASK_STATUS_EXIT;
    sprintf(pTaskEntry->taskName, "gl_fbs_driver");
    sprintf(pTaskEntry->taskPath, "%s/", TASK_ROOT_DIR);
    pTaskEntry->restartTask = 0;

    //rng_server
    pTaskEntry = &sysdb_database_ptr->taskArray[SYS_TASK_RNG_SERVER];
    pTaskEntry->used = true;
    pTaskEntry->taskProcId = -1;
    pTaskEntry->process_exited = false;
    pTaskEntry->taskStatus = SYS_TASK_STATUS_EXIT;
    sprintf(pTaskEntry->taskName, "rng_server");
    sprintf(pTaskEntry->taskPath, "%s/", TASK_ROOT_DIR);
    pTaskEntry->restartTask = 1;

    //gl_draw
    for (uint8 gameCode=0; gameCode<MAX_GAME_NUMBER; gameCode++)
    {
        if ( !gameSupports[gameCode].used )
            continue;

        pTaskEntry = &sysdb_database_ptr->taskArray[SYS_TASK_GL_DRAW + gameCode];
        pTaskEntry->used = true;
        pTaskEntry->taskProcId = -1;
        pTaskEntry->process_exited = false;
        pTaskEntry->taskStatus = SYS_TASK_STATUS_EXIT;
        sprintf(pTaskEntry->taskName, "gl_draw_%s", gameSupports[gameCode].gameAbbr);
        sprintf(pTaskEntry->taskPath, "%s/", TASK_ROOT_DIR);
        pTaskEntry->restartTask = 0;
        sprintf(pTaskEntry->param, "%d", gameCode);
    }

    //tfe_adder
    pTaskEntry = &sysdb_database_ptr->taskArray[SYS_TASK_TFE_ADDER];
    pTaskEntry->used = true;
    pTaskEntry->taskProcId = -1;
    pTaskEntry->process_exited = false;
    pTaskEntry->taskStatus = SYS_TASK_STATUS_EXIT;
    sprintf(pTaskEntry->taskName, "tfe_adder");
    sprintf(pTaskEntry->taskPath, "%s/", TASK_ROOT_DIR);
    pTaskEntry->restartTask = 0;

    //tfe_flush
    pTaskEntry = &sysdb_database_ptr->taskArray[SYS_TASK_TFE_FLUSH];
    pTaskEntry->used = true;
    pTaskEntry->taskProcId = -1;
    pTaskEntry->process_exited = false;
    pTaskEntry->taskStatus = SYS_TASK_STATUS_EXIT;
    sprintf(pTaskEntry->taskName, "tfe_flush");
    sprintf(pTaskEntry->taskPath, "%s/", TASK_ROOT_DIR);
    pTaskEntry->restartTask = 0;

    //tfe_reply
    pTaskEntry = &sysdb_database_ptr->taskArray[SYS_TASK_TFE_REPLY];
    pTaskEntry->used = true;
    pTaskEntry->taskProcId = -1;
    pTaskEntry->process_exited = false;
    pTaskEntry->taskStatus = SYS_TASK_STATUS_EXIT;
    sprintf(pTaskEntry->taskName, "tfe_reply");
    sprintf(pTaskEntry->taskPath, "%s/", TASK_ROOT_DIR);
    pTaskEntry->restartTask = 0;

    //tfe_updater
    pTaskEntry = &sysdb_database_ptr->taskArray[SYS_TASK_TFE_UPDATER];
    pTaskEntry->used = true;
    pTaskEntry->taskProcId = -1;
    pTaskEntry->process_exited = false;
    pTaskEntry->taskStatus = SYS_TASK_STATUS_EXIT;
    sprintf(pTaskEntry->taskName, "tfe_updater");
    sprintf(pTaskEntry->taskPath, "%s/", TASK_ROOT_DIR);
    pTaskEntry->restartTask = 0;

    //tfe_scan
    pTaskEntry = &sysdb_database_ptr->taskArray[SYS_TASK_TFE_SCAN];
    pTaskEntry->used = true;
    pTaskEntry->taskProcId = -1;
    pTaskEntry->process_exited = false;
    pTaskEntry->taskStatus = SYS_TASK_STATUS_EXIT;
    sprintf(pTaskEntry->taskName, "tfe_scan");
    sprintf(pTaskEntry->taskPath, "%s/", TASK_ROOT_DIR);
    pTaskEntry->restartTask = 0;

    //tfe_updater_db
    pTaskEntry = &sysdb_database_ptr->taskArray[SYS_TASK_TFE_UPDATER_DB];
    pTaskEntry->used = true;
    pTaskEntry->taskProcId = -1;
    pTaskEntry->process_exited = false;
    pTaskEntry->taskStatus = SYS_TASK_STATUS_EXIT;
    sprintf(pTaskEntry->taskName, "tfe_updater_db");
    sprintf(pTaskEntry->taskPath, "%s/", TASK_ROOT_DIR);
    pTaskEntry->restartTask = 0;

    return true;  
}

uint32 sysdb_version()
{
    return sysdb_database_ptr->version;
}

uint8 sysdb_log_level()
{
    if (pGlobalMem==NULL)
        return LOG_DEBUG;
    return sysdb_database_ptr->log_level;
}
uint8 sysdb_set_log_level(uint8 log_level)
{
    sysdb_database_ptr->log_level = log_level;
    return sysdb_database_ptr->log_level;
}

//得到系统的当前状态
SYS_STATUS sysdb_getSysStatus()
{
    return sysdb_database_ptr->sysStatus;
}

int32 sysdb_setSysStatus(SYS_STATUS status)
{
    if (status > SYS_STATUS_EMPTY && status <= SYS_STATUS_END)
    {
        sysdb_database_ptr->sysStatus = status;

        //可以发送notify消息
        //sys_notify_xxx();
        return 0;
    }
    return -1;
}

void sysdb_setSafeClose(uint8 flag)
{
    sysdb_database_ptr->safeClose = flag;
}

uint8 sysdb_getSafeClose()
{
    return sysdb_database_ptr->safeClose;
}

int send_switch_session_message(uint32 cur_date, uint32 new_date)
{
    FID fid_tfe_adder = getFidByName("tfe_adder");

    INM_MSG_SYS_SWITCH_SESSION inm_msg;
    memset((char *)&inm_msg, 0, sizeof(INM_MSG_SYS_SWITCH_SESSION));
    inm_msg.header.type = INM_TYPE_SYS_SWITCH_SESSION;
    inm_msg.header.when = get_now();
    inm_msg.header.status = SYS_RESULT_SUCCESS;
    inm_msg.curSession = cur_date;
    inm_msg.newSession = new_date;
    inm_msg.header.length = sizeof(INM_MSG_SYS_SWITCH_SESSION);
    int ret = bq_send(fid_tfe_adder, (char*)&inm_msg, inm_msg.header.length);
    if (ret <= 0)
    {
        //BQueues出错
        log_warn("bq_send switch session message return error. fid:%i", fid_tfe_adder);
    }
    log_debug("Send switch session inm message success");
    return 0;
}


int sysdb_verifySessionDate()
{
    time_t curtime;
    struct tm *tm_ptr;
    time(&curtime);
    tm_ptr = localtime(&curtime);

    uint32 c_t = tm_ptr->tm_hour*100 + tm_ptr->tm_min;
    uint32 c_d = (tm_ptr->tm_year + 1900)*10000 + (tm_ptr->tm_mon + 1)*100 + tm_ptr->tm_mday;

    uint32 newSession = 0;
    uint32 fileSession = 0;

    if (sysdb_database_ptr->sessionDate == 0)
    {
        //在系统恢复完成后，SessionDate为0, 判断为初次启动
        char sessionFile[256] = {0};
        ts_get_session_filepath(sessionFile, 256);

        if(access(sessionFile, F_OK) == 0 )
        {
        	char tmpDate[32] = {0};
        	if(ts_read_sessionData_file(sessionFile,tmpDate))
        	    fileSession = atol(tmpDate);
        	else
        	{
        		log_error("read session date file [%s] error",sessionFile);
        		return -1;
        	}
        }
        else
        {
    		log_error("can't find session date file [%s]",sessionFile);
    		return -1;
        }

        sysdb_database_ptr->sessionDate = fileSession;
    }
    else
    {
        if (c_d > sysdb_database_ptr->sessionDate)
        {
            if (c_t >= sysdb_database_ptr->switch_session_time &&
                false == sysdb_database_ptr->send_switch_session_flag)
            {
                //需要切换session,发送switch session消息
                sysdb_database_ptr->send_switch_session_flag = true;
                newSession = ts_getNewSessionDate(sysdb_database_ptr->sessionDate);
                send_switch_session_message(sysdb_database_ptr->sessionDate, newSession);
            }
        }
    }
    return 0;
}

void sysdb_setSendSwitchSessionFlag(uint8 flag)
{
    sysdb_database_ptr->send_switch_session_flag = flag;
}

void sysdb_setSessionDate(uint32 date)
{
    sysdb_database_ptr->sessionDate = date;
}


uint32 sysdb_getSessionDate()
{
    return sysdb_database_ptr->sessionDate;
}

uint32 sysdb_getSwitchSessionTime()
{
    return sysdb_database_ptr->switch_session_time;
}

uint32 sysdb_getTokenExpired()
{
    return sysdb_database_ptr->token_expired;
}

void sysdb_setTaskStatus(SYS_TASK task, SYS_TASK_STATUS status)
{
    if (sysdb_database_ptr->taskArray[task].used)
    {
        log_info("sysdb_setTaskStatus() name[%s],task[%d],status[%d]",sysdb_database_ptr->taskArray[task].taskName, task, status);
    	sysdb_database_ptr->taskArray[task].taskStatus = status;
        sysdb_database_ptr->taskArray[task].taskProcId = getpid();
        if(SYS_TASK_STATUS_RUN == status)
            sysdb_database_ptr->taskArray[task].taskStartTime = get_now();
        if(SYS_TASK_STATUS_EXIT== status)
            sysdb_database_ptr->taskArray[task].taskEndTime = get_now();
    }
	else
    {
    	log_error("sysdb_setTaskStatus() error! task[%d]", task);
    }
    return;
}

SYS_TASK_RECORD *sysdb_getTask(SYS_TASK task)
{
    if( (task>=0) && (task<SYS_MAX_TASK_COUNT) )
    {
        if( sysdb_database_ptr->taskArray[task].used)
        {
            return &sysdb_database_ptr->taskArray[task];
        }
    }
    return NULL;
}

SYS_TASK_RECORD *sysdb_getTaskArray()
{
	return (SYS_TASK_RECORD *)&sysdb_database_ptr->taskArray;
}

//设置时间
int32 sysdb_setStartTime(int flag, time_type t)
{
    if (flag == 1)
        sysdb_database_ptr->sysStartTime = t;
    else
        sysdb_database_ptr->sysRunningTime = t;
    return 0;
}

//得到进程任务名称by pid
int32 sysdb_getTaskIndexByPid(int32 taskpid)
{
    SYS_TASK_RECORD * pTaskRecord = NULL;
    
    for (int32 i=0 ; i<SYS_MAX_TASK_COUNT; i++)
    {
        pTaskRecord = &sysdb_database_ptr->taskArray[i];
        if( pTaskRecord->used && (pTaskRecord->taskProcId == taskpid) )
        {
           return i;
        }
    }
    return -1;
}

uint32 sysdb_getMachineCode()
{
	return sysdb_database_ptr->machineCode;
}

uint32 sysdb_getNcpPort()
{
    return sysdb_database_ptr->ncp_port;
}
uint32 sysdb_getNcpHttpPort()
{
    return sysdb_database_ptr->ncp_http_port;
}


uint32 sysdb_getRngPort()
{
    return sysdb_database_ptr->rng_port;
}

SYS_OMS_MONITOR *sysdb_getOmsMonitorCfg()
{
    return &sysdb_database_ptr->oms_monitor;
}

SYS_DB_CONFIG *sysdb_getOmsDBCfg()
{
    return &sysdb_database_ptr->db_oms;
}

SYS_DB_CONFIG *sysdb_getMisDBCfg()
{
    return &sysdb_database_ptr->db_mis;
}


//通过游戏编码得到 gl_draw 的任务索引
SYS_TASK sysdb_get_gl_draw_task_index(uint8 game_code)
{
    return (SYS_TASK)(SYS_TASK_GL_DRAW+game_code);
}

//通过 gl_draw 的任务索引 得到 游戏编码
uint8 sysdb_get_gl_draw_game_code(SYS_TASK taskIdx)
{
    return (taskIdx-SYS_TASK_GL_DRAW);
}


//checkpoint 数据保存及恢复
int32 sysdb_chkp_save(char *chkp_path)
{
    SYSDB_CHKP_DATA data;
    memset(&data, 0, sizeof(SYSDB_CHKP_DATA));
    data.sessionDate = sysdb_database_ptr->sessionDate;

    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName, "%s/sysdb.snapshot", chkp_path);
    if((fp = open(fileName,O_CREAT|O_WRONLY,S_IRUSR )) < 0 )
    {
    	log_error("open %s error!",fileName);
    	return -1;
    }
    ssize_t ret = write(fp, (const void *)&data, sizeof(SYSDB_CHKP_DATA));
    if(ret < 0)
    {
    	log_error("write %s error errno[%d]",fileName, errno);
        return -1;
    }
    close(fp);
    return 0;
}
int32 sysdb_chkp_restore(char *chkp_path)
{
    SYSDB_CHKP_DATA data;

    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName, "%s/sysdb.snapshot", chkp_path);
    if((fp = open(fileName,O_RDONLY )) < 0 )
    {
    	log_error("open %s error!", fileName);
    	return -1;
    }
    ssize_t ret = read(fp, (void *)&data, sizeof(SYSDB_CHKP_DATA));
    if(ret < 0)
    {
    	log_error("read %s error errno[%d]",fileName,errno);
        return -1;
    }
    close(fp);

    sysdb_database_ptr->sessionDate = data.sessionDate;
    return 0;
}




//-------------------------------------------------------------------------------
//根据类型得到一个key和版本号
int32 sysdb_getKey(int32 type, unsigned char *key, uint16 *key_version)
{
    int len = 0;
    switch(type)
    {
        case DATABASE_CONNECTION_KEY:
        {
            //3des
            //
            break;
        }
        case SALE_TICKET_KEY:
        {
            len = 16;
            memset(key, 0x0b, len);
            break;
        }
        case WIN_TICKET_KEY:
        {
            len = 16;
            memset(key, 0x0c, len);
            break;
        }
        case AGENCY_AMOUNT_KEY:
        {
            len = 16;
            memset(key, 0x0d, len);
            break;
        }
        default:
        {
            log_error("sysdb_getKey() unknow type[%d]", type);
            return -1;
        }
    }
    *key_version = 1234;
    return len;
}

//根据版本号和类型得到一个key，用于检验
int32 sysdb_findKey(int32 type, uint16 key_version, unsigned char *key)
{
	ts_notused(key_version);
    int len = 0;
    switch(type)
    {
        case DATABASE_CONNECTION_KEY:
        {
            //3des
            //
            break;
        }
        case SALE_TICKET_KEY:
        {
            len = 16;
            memset(key, 0x0b, len);
            break;
        }
        case WIN_TICKET_KEY:
        {
            len = 16;
            memset(key, 0x0c, len);
            break;
        }
        case AGENCY_AMOUNT_KEY:
        {
            len = 16;
            memset(key, 0x0d, len);
            break;
        }
        default:
        {
            log_error("sysdb_getKey() unknow type[%d]", type);
            return -1;
        }
    }
    return len;
}




//------------------------------------------------------------------------------
//对可能频繁发送的Notify消息进行过滤，在保护时间内多次发送的消息改为在保护时间内只发送一次

static const time_t ProtectionSeconds = 10; //过滤保护时间

static map<uint16, time_t> ProtectionMap =  //过滤保护map，记录下每个被保护的消息编码对应的上一次消息发送时间
{
        //{7011, (time_t)0},
        {7012, (time_t)0},
        {7013, (time_t)0},
        {7021, (time_t)0},
        {7022, (time_t)0},
        {7042, (time_t)0},
        {7112, (time_t)0}
};


//发送Notify消息
bool sys_notify(const uint16 func, const uint8 level, char* ntf_buf, const uint16 ntf_buf_len)
{
    //对在保护时间内多次发送的消息进行过滤
    if (ProtectionMap.find(func) != ProtectionMap.end()) //消息编码在map中
    {
        time_t now = time(NULL);
        if (now - ProtectionMap[func] > ProtectionSeconds)
        {
            ProtectionMap[func] = now;
        }
        else
        {
            return false;
        }
    }

    static char buffer[1024*8];
    GLTP_MSG_NTF_HEADER *header = (GLTP_MSG_NTF_HEADER *)buffer;

    header->type = GLTP_MSG_TYPE_NOTIFY;
    header->func = func;
    header->when = get_now();
    header->level = level;

    memcpy(header->data, ntf_buf, ntf_buf_len);
    header->length = GLTP_MSG_NTF_HEADER_LEN + ntf_buf_len;

    do
    {
        if (!MSG_S(sysdb_NOTIFY_MQ, GLTP_MSG_TYPE_NOTIFY, buffer, 0, header->length))
        {
            if (errno == EINTR)
            {
				continue;
            }

            if (errno == EAGAIN) {
                log_warn("the msg queue is full, drop the msg! Reason [%s].", strerror(errno));
                return true;
            }

            log_error("msg queue id [%d], msgsnd error! errno[%d]:%s", sysdb_NOTIFY_MQ, errno, strerror(errno));
            return false;
        }
        break;
    } while (1);

    return true;
}

//收消息队列中的消息(阻塞收)
int32 sys_r_message(char *message, uint32 len)
{
    int32 length = MSG_R_BLOCK(sysdb_NOTIFY_MQ, 0, message, 0, len);
    if (length < 0)
    {
        log_error("recv message error! errno[%d]:%s", errno, strerror(errno));
    }
    return length;
}


