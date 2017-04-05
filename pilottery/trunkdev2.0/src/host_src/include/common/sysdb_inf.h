#ifndef SYSDB_INF_H_INCLUDED
#define SYSDB_INF_H_INCLUDED


//------------------------------------------------------------------------------
// 系统文件存储路径的统一定义
//------------------------------------------------------------------------------
#define TAISHAN_HOST_PATH         "/ts_host"

#define IPC_FILE_PATH             TAISHAN_HOST_PATH "/ipcs"
#define CONFIG_FILE_PATH          TAISHAN_HOST_PATH "/conf"
#define LOG_ROOT_DIR              TAISHAN_HOST_PATH "/logs"
#define DATA_ROOT_DIR             TAISHAN_HOST_PATH "/data"
#define TASK_ROOT_DIR             TAISHAN_HOST_PATH "/task"

//------------------------------------------------------------------------------
// 定义系统V进程间通讯接口的键所需要的路径与文件名
//------------------------------------------------------------------------------
#define IPC_SHMPATH               IPC_FILE_PATH "/shm.key"  //共享内存
#define IPC_SEMPATH               IPC_FILE_PATH "/sem.key"  //信号量
#define IPC_MSGPATH               IPC_FILE_PATH "/msg.key"  //消息队列

//------------------------------------------------------------------------------
// 定义配置文件的路径
//------------------------------------------------------------------------------
//配置文件路径 sysdb.xml
#define SYSDB_CONFIG_FILE         CONFIG_FILE_PATH "/sysdb.xml"
//配置文件路径 bqueues.xml
#define BQUEUES_CONFIG_FILE       CONFIG_FILE_PATH "/bqueues.xml"
//配置文件路径 ncpc.xml
#define NCPC_CONFIG_FILE          CONFIG_FILE_PATH "/ncpc.xml"

//---------------------------------------------------------------------------------------

//得到 /ts_host/data/tfe_data/ 目录
#define TFE_DATA_SUBDIR            DATA_ROOT_DIR "/tfe_data"

//得到 /ts_host/data/tidx_data/ 目录
#define TIDX_DATA_SUBDIR           DATA_ROOT_DIR "/tidx_data"

//得到 /ts_host/data/game_data/ 目录
#define GAME_DATA_SUBDIR           DATA_ROOT_DIR "/game_data"

//得到 /ts_host/data/upload_data/ 目录
#define UPLOAD_DATA_SUBDIR         DATA_ROOT_DIR "/upload_data"

//得到 /ts_host/data/pub_data/ 目录
#define PUB_DATA_SUBDIR            DATA_ROOT_DIR "/pub_data"

//得到 /ts_host/data/snapshot_data/ 目录
#define SNAPSHOT_DATA_SUBDIR       DATA_ROOT_DIR "/snapshot_data"

//期次管理的memory 数据文件路径
#define TS_MEM_GAME_DB             "/dev/shm/ts_game"

//代理商售票memory leveldb数据文件路径
#define TS_MEM_KVDB_DB             "/dev/shm/ts_kvdb"


//---------------------------------------------------------------------------------------
//      /ts_host/data/ 下的 session 目录的相关 路径函数 接口
//---------------------------------------------------------------------------------------
/*

/ts_host/data/

/ts_host/data/tfe_data/
/ts_host/data/tfe_data/datazoo_N.tf   ( tfe 交易日志文件, N从1开始，不断加1)

/ts_host/data/tidx_data/
/ts_host/data/tidx_data/20150910.idx  ( 票索引数据目录，按天命名文件，一天一个文件)

/ts_host/data/game_data/
/ts_host/data/game_data/game_N/
/ts_host/data/game_data/game_N/draw/
/ts_host/data/game_data/game_N/issue_YYY_draw_announce.xml   (期开奖过程中产生的开奖公告文件)
/ts_host/data/game_data/game_N/issue_YYY_agency_stat.txt     (销售站的中奖统计文件)
/ts_host/data/game_data/game_N/issue_YYY.db  ( 某一期的 票文件 db file. sqlite db file)


/ts_host/data/upload_data/  (系统用于上传中心的游戏数据目录)
/ts_host/data/upload_data/issue_GG_YYY.upld (上报中心的销售文件)( 某一期的 售票文件 福彩中心规定的格式 )
/ts_host/data/upload_data/issue_GG_YYY.upld.md5  ( 某一期的 售票文件 的 MD5校验文件 )


/ts_host/data/pub_data/   (系统生成的接入商的期次中奖文件的数据目录)
/ts_host/data/pub_data/NNNN_issue_GG_YYY.pub (中奖的数据文件)
/ts_host/data/pub_data/NNNN_issue_GG_YYY.pub.md5  (中奖的数据文件 的 MD5校验文件 )


/ts_host/data/snapshot_data/     (系统快照数据目录，用于故障恢复)
/ts_host/data/snapshot_data/last_snapshot    (文本文件，保存最后一次快照的目录名称)
/ts_host/data/snapshot_data/YYYYMMDD.HHMMSS/     (例如: 20130717.175534)
/ts_host/data/snapshot_data/YYYYMMDD.HHMMSS/game.snapshot
/ts_host/data/snapshot_data/YYYYMMDD.HHMMSS/issue_riskctrl_GG_YYY.snapshot     (GG为2位游戏编码，YYY为完整的游戏期号)
/ts_host/data/snapshot_data/YYYYMMDD.HHMMSS/tf.snapshot
*/

//----------- Session -----------------------------------------

// 得到指定的session文件路径
//-->  /ts_host/data/tf_data/session
int32 ts_get_session_filepath(char *path, int len);
bool ts_write_sessionDate_file(char* filepath,char *buf);

//----------- TF -----------------------------------------

// 得到指定的tf文件路径
//-->  /ts_host/data/tf_data/datazoo_N.tf
int32 ts_get_tf_filepath(uint32 tf_idx, char *path, int len);

//----------- Ticket Index -------------------------------

// 得到票索引文件的文件路径
//-->  /ts_host/data/tidx_data/
int32 ts_get_ticket_idx_filepath(uint32 date, char *path, int len);

//----------- Game ---------------------------------------

//得到游戏数据根目录
//-->  /ts_host/data/game_data
int32 ts_get_game_root_dir(char *path, int len);

//得到指定的游戏数据目录
//-->  /ts_host/data/game_data/game_N/
int32 ts_get_game_dir(char *game_abbr, char *path, int len);

//得到指定的游戏开奖数据目录
//-->  /ts_host/data/game_data/game_N/draw/
int32 ts_get_game_draw_dir(char *game_abbr, char *path, int len);

//得到指定的游戏期次管理数据文件
//-->  /dev/shm/ts_game/game_N.db
int32 ts_get_mem_game_filepath(char *game_abbr, char *path, int len);

//代理商售票memory leveldb数据文件路径
//-->  /dev/shm/ts_kvdb
int32 ts_get_kvdb_filepath(char *path, int len);

//得到指定游戏 某一期的 AP中奖文件路径
//-->  /ts_host/data/win_data/ap_paid_game_12_161226017_K11X5.dat
int32 ts_get_game_issue_ap_pay_filepath(char *game_abbr, uint8 gameCode, uint64 issue_num, char *path, int len);

//得到指定游戏 某一期的 票数据 db文件路径
//-->  /ts_host/data/game_data/game_N/issue_YYY.db
int32 ts_get_game_issue_ticket_filepath(char *game_abbr, uint64 issue_num, char *path, int len);

//得到指定游戏 某一期的 中奖票数据 db文件路径
//-->  /ts_host/data/game_data/game_N/issue_win_YYY.db
int32 ts_get_game_issue_ticket_win_filepath(char *game_abbr, uint64 issue_num, uint8 draw_times, char *path, int len);
//得到指定游戏 某一期的 开奖过程数据 db文件路径
//-->  /ts_host/data/game_data/game_N/draw/draw_issue_YYY.db
int32 ts_get_game_issue_draw_filepath(char *game_abbr, uint64 issue_num, uint8 draw_times, char *path, int len);
//得到指定游戏 某一期的 中奖数据文本文件路径
//-->  /ts_host/data/win_data/game_N/win_ticket_issue_20140627003.dat
int32 ts_get_game_issue_win_data_filepath(char *game_abbr, uint64 issue_num, uint8 draw_times, char *path, int len);

//得到指定游戏 某一期的 开奖公告xml文件的路径
//-->  /ts_host/data/game_data/game_N/draw_announce_issue_YYY.xml
int32 ts_get_game_issue_draw_announce_filepath(char *game_abbr, uint64 issue_num, uint8 draw_times, char *path, int len);


//----------- FBS Game ---------------------------------------

//得到指定 FBS游戏 某一期的 票数据 db文件路径
//-->  /ts_host/data/game_data/game_N/issue_YYY.db
int32 ts_get_fbs_issue_ticket_filepath(char *game_abbr, uint32 issue_num, char *path, int len);
//得到指定 FBS游戏 某一期的 中奖票数据 db文件路径
//-->  /ts_host/data/game_data/game_N/issue_win_YYY.db
int32 ts_get_fbs_issue_ticket_win_filepath(char *game_abbr, uint32 issue_num, char *path, int len);
//得到指定 FBS游戏 的 彩票拆单开奖数据 db文件路径
//-->  /ts_host/data/game_data/game_N/fbs_order.db
int32 ts_get_fbs_ticket_order_filepath(char *game_abbr, char *path, int len);
//得到指定 FBS游戏 的 彩票拆单开奖数据 meta文件路径
//-->  /ts_host/data/game_data/game_N/fbs_order.meta
int32 ts_get_fbs_ticket_meta_filepath(char *game_abbr, char *path, int len);
//得到指定 FBS游戏 的 开奖过程中发生的标记文件路径 tag文件路径
//-->  /ts_host/data/game_data/game_N/fbs_order.tag
int32 ts_get_fbs_draw_tag_filepath(char *game_abbr, char *path, int len);
//得到指定 FBS游戏 的 历史开奖过程数据 文件保存目录
//-->  /ts_host/data/game_data/game_N/draw
int32 ts_get_fbs_draw_dirpath(char *game_abbr, char *path, int len);
//得到指定游戏 某一比赛场次的 中奖数据文本文件路径
//-->  /ts_host/data/win_data/game_N/win_ticket_match_xxx.dat
int32 ts_get_fbs_game_match_win_data_filepath(char *game_abbr, uint32 match_code, uint8 draw_times, char *path, int len);


//----------- backup -------------------------------------
//得到指定游戏 某一期的 AP兑奖完成文件路径
//-->  /ts_host/data/win_data/ap_paid_game_12_161226017_K11X5.dat
int32 ts_get_game_issue_ap_paidover_filepath(char *game_abbr, uint8 gameCode, uint64 issue_num, char *path, int len);

//得到指定游戏 某一期的 封存数据的备份文件路径
//-->  /ts_host/data/seal_data/game_N_issue_20140627003_seal.dat
int32 ts_get_game_issue_seal_data_filepath(char *game_abbr, uint64 issue_num, char *path, int len);


//----------- Upload -------------------------------------

//得到指定游戏的某一期的上传数据文件名
//-->  /ts_host/data/upload_data/issue_GG_YYY.upld
int32 ts_get_upload_game_issue_filepath(uint8 game_code, uint64 issue_num, char *path, int len);


//----------- Pub -------------------------------------

//得到指定接入商的指定游戏的某一期的中奖数据文件名
//-->  /ts_host/data/pub_data/NNNN_issue_GG_YYY.pub
int32 ts_get_pub_game_issue_filepath(uint32 ap_code, uint8 game_code, uint64 issue_num, uint8 draw_times, char *path, int len);



//----------- Snapshot -----------------------------------
//得到系统快照数据目录
//-->  /ts_host/data/snapshot_data/
int32 ts_get_snapshot_dir(char *path, int len);

//得到系统最后一次快照的目录名
//-->  /ts_host/data/snapshot_data/YYYYMMDD.HHMMSS/
int32 ts_get_snapshot_last_dir(char *path, int len);

//得到最后一次快照目录下的(游戏)快照数据文件名
//-->  /ts_host/data/snapshot_data/YYYYMMDD.HHMMSS/game.snapshot
int32 ts_get_snapshot_game_filepath(char *path, int len);

//得到最后一次快照目录下指定游戏指定期的(风险控制)快照数据文件名
//-->  /ts_host/data/snapshot_data/YYYYMMDD.HHMMSS/issue_riskctrl_GG_YYY.snapshot
int32 ts_get_snapshot_issue_riskctrl_filepath(uint8 game_code, uint64 issue_num, char *path, int len);

//得到最后一次快照目录下的(TF)快照数据文件名
//-->  /ts_host/data/snapshot_data/YYYYMMDD.HHMMSS/tf.snapshot
int32 ts_get_snapshot_tf_filepath(char *path, int len);



//---------------------------------------------------------------------------------------
//系统游戏支持

typedef struct _GAME_SUPPORT
{
    uint8 used;
    uint8 gameCode;     //游戏编码
    GAME_TYPE gameType; // 游戏类型  enum GAME_TYPE
    char gameAbbr[15];   //游戏字符缩写
    DRAW_TYPE drawType; //开奖模式 enum DRAW_TYPE
} GAME_SUPPORT;

//判定当前是否支持此游戏
bool game_support(uint8 game_code);
//获取某个游戏的字母缩写
void get_game_abbr(uint8 game_code, char *abbr);
uint8 get_game_code(char *abbr);

GAME_SUPPORT *get_game_support(uint8 game_code);



//---------------------------------------------------------------------------------------




#pragma pack (1)

//定义系统最大的任务数
#define SYS_MAX_TASK_COUNT 128

typedef enum _STATUS_OUTPUT
{
    STATUS_OK       = 0,
    STATUS_FAILED   = 1,
    STATUS_WARNING  = 2,
}STATUS_OUTPUT;

//系统状态
typedef enum _SYS_STATUS
{
    SYS_STATUS_EMPTY       = 0,
    SYS_STATUS_START       = 1,
    SYS_STATUS_DATA_SYNC   = 2,
    SYS_STATUS_DATA_LOAD   = 4,
    SYS_STATUS_DATA_RESUME = 5,
    SYS_STATUS_BUSINESS    = 6,
    SYS_STATUS_END,
}SYS_STATUS;

//系统任务编号
typedef enum _SYS_TASK
{
    SYS_TASK_EMPTY              = -1,
    SYS_TASK_TSTOP              = 0,

    //SYS_TASK_BQUEUESD           = 1,

    SYS_TASK_NCPC_TASK          = 2,
    SYS_TASK_NCPC_AUTOPAY       = 3,
    SYS_TASK_GL_DRIVER          = 4,
    SYS_TASK_RNG_SERVER         = 5,
    SYS_TASK_GL_FBS_DRIVER      = 6,
    SYS_TASK_GL_DRAW            = 7,

    SYS_TASK_TFE_ADDER          = SYS_TASK_GL_DRAW + MAX_GAME_NUMBER,
    SYS_TASK_TFE_FLUSH,
    SYS_TASK_TFE_REPLY,
    SYS_TASK_TFE_UPDATER,

    SYS_TASK_TFE_SCAN,

    SYS_TASK_TFE_UPDATER_DB,

    SYS_TASK_END                = 100,
}SYS_TASK;

//系统任务状态
typedef enum _SYS_TASK_STATUS
{
    SYS_TASK_STATUS_EMPTY = 0,
    SYS_TASK_STATUS_START = 1,
    SYS_TASK_STATUS_RUN   = 2,
    SYS_TASK_STATUS_EXIT  = 3,      //正常退出
    SYS_TASK_STATUS_CRASH = 4,      //异常退出
}SYS_TASK_STATUS;


//数据区的结构
typedef struct _SYS_TASK_RECORD
{
     bool             used;
     char             taskPath[64];    // 任务路径
     char             taskName[64];    // 任务名称
     SYS_TASK_STATUS  taskStatus;      // 任务状态
     uint8            restartTask;     // 重新启动此任务(此标志为1时，如果此任务没有运行，tstop将启动此任务)
     time_type        taskStartTime;   // 任务启动时间
     time_type        taskEndTime;     // 任务退出时间
     int32            taskRestartNum;  // 任务启动次数
     int32            taskProcId;      // 任务ID
     bool             process_exited;  // 任务退出标志，由SIGCHILD信号处理函数设置
     char             param[64];       // 任务启动参数选项
}SYS_TASK_RECORD;

//连接OMS notify通道配置及状态
typedef struct _SYS_OMS_MONITOR
{
    char                oms_monitor_ip[16];         //om监控服务器ip <notify>
    uint32              oms_monitor_port;           //om监控服务器port <notify>
}SYS_OMS_MONITOR;

//连接数据库配置及状态
typedef struct _SYS_DB_CONFIG
{
    char                url[128];                   //数据库连接字符串
    char                username[64];               //数据库连接用户名
    char                password[64];               //数据库连接密码

    time_type           last_except_time;           //最后一次异常发生的时间
    char                except_code[64];            //返回的错误编号
    char                except_info[512];           //返回的错误信息
}SYS_DB_CONFIG;


typedef struct _SYS_DATABASE
{
    uint32              version;                    //系统版本
    uint8               log_level;                  //运行log级别
    uint32              machineCode;                //机器节点号
    time_type           sysStartTime;               //系统启动时间
    time_type           sysRunningTime;             //系统启动完成时间
    SYS_STATUS          sysStatus;                  //系统状态
    uint8               safeClose;                  //安全关闭标志

    uint32              sessionDate;                //系统当前会话日期(年月日20160119)
    uint32              switch_session_time;        //系统会话切换时间 0300 临晨3点
    uint8               send_switch_session_flag;   //是否已发送switch session消息

    uint32              token_expired;              //token expired time

    uint32              ncp_port;                   //NCP监听端口
    uint32              ncp_http_port;              //NCP HTTP 监听端口

    uint32              rng_port;                   //RNG监听端口

    SYS_OMS_MONITOR     oms_monitor;                //oms监控通道

    SYS_DB_CONFIG       db_oms;                     //om数据库配置及状态
    SYS_DB_CONFIG       db_mis;                     //mis数据库配置及状态

    SYS_TASK_RECORD     taskArray[SYS_MAX_TASK_COUNT]; //任务记录

    uint32              riel_to_usd;                //瑞尔对美金的汇率
}SYS_DATABASE;

typedef SYS_DATABASE* SYS_DATABASE_PTR;

#pragma pack ()



bool sysdb_create();
bool sysdb_destroy();
bool sysdb_init();
bool sysdb_close();
bool sysdb_clear();

SYS_DATABASE_PTR sysdb_getDatabasePtr();

uint32 sysdb_version();

uint8 sysdb_log_level();
uint8 sysdb_set_log_level(uint8 log_level);

bool sysdb_load_config();

//得到系统的当前状态
SYS_STATUS sysdb_getSysStatus();
int32 sysdb_setSysStatus(SYS_STATUS status);

//得到系统安全关闭标记
void sysdb_setSafeClose(uint8 flag);
uint8 sysdb_getSafeClose();

int sysdb_verifySessionDate();
void sysdb_setSendSwitchSessionFlag(uint8 flag);
void sysdb_setSessionDate(uint32 date);
uint32 sysdb_getSessionDate();
uint32 sysdb_getSwitchSessionTime();

uint32 sysdb_getTokenExpired();

void sysdb_setTaskStatus(SYS_TASK task, SYS_TASK_STATUS status);

SYS_TASK_RECORD *sysdb_getTask(SYS_TASK task);
SYS_TASK_RECORD *sysdb_getTaskArray();

// 得到TFPath数据  flag 1: start  2: running
int32 sysdb_setStartTime(int flag, time_type t);

int32 sysdb_getTaskIndexByPid(int32 taskpid);

uint32 sysdb_getMachineCode();

uint32 sysdb_getNcpPort();
uint32 sysdb_getNcpHttpPort();


uint32 sysdb_getRngPort();

SYS_OMS_MONITOR *sysdb_getOmsMonitorCfg();

SYS_DB_CONFIG *sysdb_getOmsDBCfg();
SYS_DB_CONFIG *sysdb_getMisDBCfg();

//checkpoint 数据保存及恢复
int32 sysdb_chkp_save(char *chkp_path);
int32 sysdb_chkp_restore(char *chkp_path);

//------------------------------------------------------------------------------


//通过游戏编码得到 gl_draw 的任务索引
SYS_TASK sysdb_get_gl_draw_task_index(uint8 game_code);


//通过 gl_draw 的任务索引 得到 游戏编码
uint8 sysdb_get_gl_draw_game_code(SYS_TASK taskIdx);



//------------------------------------------------------------------------------
enum TS_KEY_TYPE
{
    DATABASE_CONNECTION_KEY = 1,
	SALE_TICKET_KEY,
	WIN_TICKET_KEY,
	SALE_DATA_SEAL_KEY,
	AGENCY_AMOUNT_KEY,
};
//根据类型得到一个key和版本号
int32 sysdb_getKey(int32 type, unsigned char *key, uint16 *key_version);
//根据版本号和类型得到一个key，用于检验
int32 sysdb_findKey(int32 type, uint16 key_version, unsigned char *key);





//------------------------------------------------------------------------------
// Notify消息接口
//------------------------------------------------------------------------------
//发送Notify消息
bool sys_notify(const uint16 func, const uint8 level, char* ntf_buf, const uint16 ntf_buf_len);
//收消息队列中的消息(阻塞收)
int32 sys_r_message(char *message, uint32 len);




#if 0
//caoxf__

extern const int xmlprCnt;
extern const int xmlplCnt;
extern char xmlPrize[][100];
extern char xmlPool[][100];

int verifyXml(char *xmlFileName);
int loadTSXml(
        XMLElement *elem,
        char *node,
        int type,
        char (*arrIn)[100],
        int length,
        char (*arrOut)[50][128]);
#endif


#endif

