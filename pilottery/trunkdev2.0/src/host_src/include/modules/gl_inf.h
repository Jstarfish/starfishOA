#ifndef GL_INF_H_INCLUDED
#define GL_INF_H_INCLUDED


//-----------------------------------------------------------------------------------------
//
//   GL database
//
//-----------------------------------------------------------------------------------------

//游戏信息
typedef struct _GAME_PARAM
{
    uint8 gameCode;     //游戏编码
    GAME_TYPE gameType; // 游戏类型
    char gameAbbr[15];   //游戏字符缩写
    char gameName[MAX_GAME_NAME_LENGTH]; //游戏名称
    char organizationName[MAX_ORGANIZATION_NAME_LENGTH]; //发行单位名称
} GAME_PARAM;

//政策参数
typedef struct _POLICY_PARAM
{
    uint16 publicFundRate;      //公益金比例
    uint16 adjustmentFundRate;  //调节金比例
    uint16 returnRate;          //理论返奖率
    money_t taxStartAmount;     //缴税起征额(单位:分)
    uint16 taxRate;             //缴税千分比
    uint16 payEndDay;           //兑奖期(天)
} POLICY_PARAM;

//交易控制参数
typedef struct _TRANSCTRL_PARAM
{
    DRAW_TYPE drawType; //期次开奖模式

    bool    saleFlag; //是否可销售
    bool    cancelFlag; //是否可退票
    bool    payFlag; //是否可兑奖

    bool    riskCtrl; //是否启用风险控制
    char    riskCtrlParam[512]; //游戏风险控制参数(字符串)

    // common control parameter ---------------------------------------------------
    uint8   autoDraw; //是否自动开奖  enable:1   disable:2
    uint32  cancelTime; //允许退票时间   单位: 秒
    uint32  countDownTimes; //销售即将关闭提醒时间

    uint16  maxTimesPerBetLine; //单行最大倍数
    uint8   maxBetLinePerTicket; //单票最大行数  //针对FBS游戏，此参数代表一张票做多选择的比赛场次数量
    uint16  maxIssueCount; //最大连续期次
    money_t maxAmountPerTicket; //单票最大金额（1-50）

    money_t gamePayLimited; //游戏兑奖保护限额（单位分）： 系统保护阈值（所有的兑奖行为都受此参数限制）
    money_t bigPrize; //判定是否是大额奖 （小于超大额奖限额）(确定是否是大额奖)(单票)


    money_t saleLimit; //单票销售金额告警阈值
    money_t payLimit; //单票兑奖金额告警阈值
    money_t cancelLimit; //单票退票金额告警阈值


    //游戏每日服务时间段一
    uint32  service_time_1_b;
    uint32  service_time_1_e;
    //游戏每日服务时间段二
    uint32  service_time_2_b;
    uint32  service_time_2_e;

    //分中心(省级)限额  ------------------------------------------------------
    money_t branchCenterPayLimited;    //分中心(省级)兑奖限额
    money_t branchCenterCancelLimited; //分中心(省级)退票限额
    //terminal control parameter  ------------------------------------------------
    money_t commonTellerPayLimited;    //普通销售销售员兑奖限额：设定普通销售员的可兑奖上限（普通销售员兑奖时需验证此限额）
    money_t commonTellerCancelLimited; //普通销售销售员退票限额：设定普通销售员的可退票上限（普通销售员退票时需验证此限额）
} TRANSCTRL_PARAM;

//游戏交易当日统计数据
typedef struct _GAME_DAY_STAT
{
    uint32  saleCount; //销售票数
    money_t saleAmount; //销售金额
    uint32  payCount; //兑奖票数
    money_t payAmount; //兑奖金额
    uint32  cancelCount; //撤销票数
    money_t cancelAmount; //撤销金额
} GAME_DAY_STAT;

//游戏管理表
typedef struct _GAME_DATA
{
    bool used; //是否被使用
    GAME_PARAM gameEntry; //彩票游戏表
    POLICY_PARAM policyParam; //政策参数
    TRANSCTRL_PARAM transctrlParam; //销售控制参数

    GAME_DAY_STAT gameDayStat;//当日游戏统计数据
} GAME_DATA;

//RNG共享内存参数
typedef struct _RNG_PARAM
{
    bool    used;
    uint32  rngId;
    char    rngName[ENTRY_NAME_LEN];
    uint8   status;     // RNG可用状态 enum STATUS_TYPE (目前永远为ENABLED)
    uint8   workStatus; // RNG工作状态 enum RNG_STATUS
    uint8   rngMac[6];  // 当前rng client的mac地址
    char    rngIp[16];  // 当前rng client的ip地址
    uint8   gameCode;   // 此RNG可以支持的游戏(0代表支持所有游戏)
} RNG_PARAM;

//-----------------------------------------------------------------------------------------

#define SALE_BUCKET_NUM       (32767) //0x7FFF
#define SALE_BUCKET_SIZE      (16)
#define SALE_OVERFLOW_SIZE    (4096*16)

#define PAY_BUCKET_NUM        (32767) //0x7FFF
#define PAY_BUCKET_SIZE       (16)
#define PAY_OVERFLOW_SIZE     (4096*16)

#define CANCEL_BUCKET_NUM     (8191) //0x1FFF
#define CANCEL_BUCKET_SIZE    (16)
#define CANCEL_OVERFLOW_SIZE  (256*16)

/*
#define ISSUE_BUCKET_NUM     (131071) //0x0001FFFF
#define ISSUE_BUCKET_SIZE    (16)
#define ISSUE_OVERFLOW_SIZE  (4096*16)
*/

// 兑奖/退票 票号内存数据
typedef struct _SHM_TSN_STRUCT {
    uint8  used;
    char   tsn[TSN_LENGTH];
} SHM_TSN_STRUCT;


//内存GL数据库 ----------------------------------------------------------------------------
typedef struct _GL_DATABASE
{
    GAME_DATA gameTable[MAX_GAME_NUMBER]; //游戏数据表
    RNG_PARAM rngTable[MAX_RNG_NUMBER]; //RNG参数

    //无纸化销售请求流水号使用的Request Number cache内存
    SHM_TSN_STRUCT sale_buckets[SALE_BUCKET_NUM][SALE_BUCKET_SIZE];
    SHM_TSN_STRUCT sale_overflow[SALE_OVERFLOW_SIZE];
    pthread_mutex_t sale_lock;

    //兑奖使用的TSN cache内存
    SHM_TSN_STRUCT pay_buckets[PAY_BUCKET_NUM][PAY_BUCKET_SIZE];
    SHM_TSN_STRUCT pay_overflow[PAY_OVERFLOW_SIZE];
    pthread_mutex_t pay_lock;

    //退票使用的TSN cache内存
    SHM_TSN_STRUCT cancel_buckets[CANCEL_BUCKET_NUM][CANCEL_BUCKET_SIZE];
    SHM_TSN_STRUCT cancel_overflow[CANCEL_OVERFLOW_SIZE];
    pthread_mutex_t cancel_lock;

} GL_DATABASE;

typedef GL_DATABASE* GL_DATABASE_PTR;




//----------------------------------------------------------------------------------------
//
//    GL database 相关 INTERFACE
//
//----------------------------------------------------------------------------------------


//创建共享内存
bool gl_create();

//删除共享内存
bool gl_destroy();

//映射共享内存区
bool gl_init();

//关闭共享内存区的映射
bool gl_close();

GL_DATABASE_PTR gl_getDataBasePtr(void);



//游戏是否可用
bool isGameBeUsed(uint8 gameCode);

//获取指定gameCode的游戏数据
GAME_DATA* gl_getGameData(uint8 gameCode);

//获取指定gameCode的游戏基本参数
GAME_PARAM* gl_getGameParam(uint8 gameCode);

//获取指定gameCode的政策参数
POLICY_PARAM* gl_getPolicyParam(uint8 gameCode);

//获取指定gameCode的交易控制参数
TRANSCTRL_PARAM * gl_getTransctrlParam(uint8 gameCode);

//获取RNG数据
RNG_PARAM* gl_getRngData();



//验证当前时间是否在游戏的服务时段范围内
bool gl_verifyServiceTime(uint8 gameCode);

//获取指定gameCode的游戏当日统计数据
GAME_DAY_STAT * gl_getGameDayStat(uint8 gameCode);

//日结时清除游戏当日统计数据
void gl_cleanGameDayStatistics();


//是否启用风险控制
bool isGameBeRiskControl(uint8 gameCode);


//设置游戏销售、兑奖、取消   flag (1:sale 2:pay 3:cancel)  status(0: false 1:true)
int gl_setGameCtrl(uint8 gameCode, uint8 flag, uint8 status);

//设置游戏允许退票时间
int gl_setCancelTime(uint8 gameCode,uint32 cancelTime);

//设置游戏自动开奖标记(针对电子开奖游戏有效)
int gl_setAutoDrawStatus(uint8 gameCode, uint8 status);

//添加游戏开奖RNG
int gl_setGameParamRng(RNG_PARAM *rngParam);

//设置RNG工作状态
int gl_setRngWorkStatus(uint32 rngId, int workStatus);


//checkpoint 数据保存及恢复
int32 gl_chkp_save(char *chkp_path);
int32 gl_chkp_restore(char *chkp_path);





//----------------------------------------------------------------------------------------
//
//    GL COMMON STRUCTURE DEFINE
//
//----------------------------------------------------------------------------------------
#include "gl_type_def.h"



//----------------------------------------------------------------------------------------
//
//    GIDB FBS INTERFACE
//
//----------------------------------------------------------------------------------------
#include "gl_fbs_inf.h"



//----------------------------------------------------------------------------------------
//
//    Game Plugins INTERFACE
//
//----------------------------------------------------------------------------------------
#include "gl_plugins_inf.h"



//----------------------------------------------------------------------------------------
//
//    GIDB INTERFACE
//
//----------------------------------------------------------------------------------------
#include "gidb_mod.h"



//-------------------------------------------------------------------------------------------------------
//
//    DRAW GFP INTERFACE
//
//-------------------------------------------------------------------------------------------------------
#include "gfp_mod.h"



//----------------------------------------------------------------------------------------
//
//    FBS GIDB INTERFACE
//
//----------------------------------------------------------------------------------------
#include "gidb_fbs_mod.h"




//----------------------------------------------------------------------------------------
//
//    TSN 相关 INTERFACE
//
//----------------------------------------------------------------------------------------

//offset_days -> (离开始年的1月1日的天数)  return 年月日( 20150921 )
int c_date(int offset_days);
//date -> 20150921 , return 1234 (离开始年的1月1日的天数)
int c_days(int date);

//生成 DIGIT TSN (内部使用的明文TSN)
uint64 generate_digit_tsn(uint32 date, uint16 fileIdx, uint32 fileOffset);
//解析 DIGIT TSN (内部使用的明文TSN)
int extract_digit_tsn(uint64 unique_tsn, uint32 *date, uint16 *fileIdx, uint32 *fileOffset);
//使用 内部的digit_tsn 生成用于外部的 字符串票号
int generate_tsn(uint64 unique_tsn, char *tsn_str);
//使用 外部的 字符串票号 生成 内部的digit_tsn
uint64 extract_tsn(char *tsn_str, uint32 *date);


#define SUPPORT_OLD_TSN
#ifdef SUPPORT_OLD_TSN
uint64 extract_old_tsn(char *tsn_str, uint32 *date);
#endif








//-------------------------------------------------------------------------------------------------------
//
//spccial  interface
//
//-------------------------------------------------------------------------------------------------------


typedef list<GAME_DATA *> GAME_LIST;
typedef struct _ISSUE_CFG_DATA
{
    uint8 gameCode;                                 // 游戏编码
    uint64 issueNumber;
    uint32 serialNumber;                            // 期次序号, 有效范围[0-1048575] uint16+uint8 = 20bit
    uint8 curState;
    uint8 localState;
    time_type startTime;
    time_type closeTime;
    time_type drawTime;
    uint64 payEndDay;                               // 兑奖截止日期
    char  winConfigStr[MAX_GAME_RESULTS_STR_LEN];  //算奖配置参数字符串
} ISSUE_CFG_DATA;
typedef list<ISSUE_CFG_DATA *> ISSUE_NEWCFG_LIST;
typedef list<ISSUE_INFO *> ISSUE_OLDCFG_LIST;

typedef list<RNG_PARAM *> RNG_LIST;


typedef struct _AREA_GAME_INFO
{
    uint8   gameCode;
    uint8   status;

    int16   CommissionRate; // 代销费/佣金 比例

    uint8   sellStatus;
    uint8   payStatus;
    uint8   cancelStatus;
}AREA_GAME_INFO;

typedef struct _TMS_AREA_CFG_DATA
{
    uint8   areaType; // 1: province
    uint32  areaCode;
    uint8   status;

    char    areaName[64];

    uint32  parentCode; //父区域数据编码

    uint8   gameCount;
    AREA_GAME_INFO gameArray[MAX_GAME_NUMBER];
} TMS_AREA_CFG_DATA;
typedef list<TMS_AREA_CFG_DATA *> TMS_AREA_CFG_LIST;


typedef struct _AGENCY_GAME_INFO
{
    uint8   gameCode;               //游戏编码
    uint8   status;                 //游戏可用状态   enum STATUS_TYPE

    int16   saleCommissionRate;     //销售站销售代销费比例
    int16   payCommissionRate;      //销售站兑奖代销费比例

    uint8   claimingScope;          //兑奖范围, enum AREA_LEVEL
    uint8   sellStatus;             //是否可销售
    uint8   payStatus;              //是否可兑奖
    uint8   cancelStatus;           //是否可取消
}AGENCY_GAME_INFO;

typedef struct _TMS_AGENCY_CFG_DATA
{
    uint64  agencyCode;
    uint8   status;

    uint32  areaCode;
    uint16  areaType;

    uint8   agencyType;

    time_type business_begin_time;
    time_type business_end_time;

    money_t availableCredit;                  //账户余额

    money_t marginalCreditLimit;
    money_t tempMarginalCreditLimit;

    char   agencyName[ENTRY_NAME_LEN];                          //销售站名称
    char   contactAddress[AGENCY_ADDRESS_LENGTH];               //联系人地址
    char   contactPhone[20];                                    //联系人电话

    uint8   gameCount;
    AGENCY_GAME_INFO gameArray[MAX_GAME_NUMBER];
} TMS_AGENCY_CFG_DATA;
typedef list<TMS_AGENCY_CFG_DATA *> TMS_AGENCY_CFG_LIST;


typedef struct _TMS_TERMINAL_CFG_DATA
{
    uint64 termCode;
    uint8  status;

    uint8  szTermMac[6];
    char   unique_code[32];
    uint8  isTrain;
    uint16 machineModel;

    uint64 agencyCode;

    uint64 flowNumber;
} TMS_TERMINAL_CFG_DATA;
typedef list<TMS_TERMINAL_CFG_DATA *> TMS_TERMINAL_CFG_LIST;


typedef struct _TMS_TELLER_CFG_DATA
{
    uint32 tellerCode;
    uint8  status;

    uint64 agencyCode;

    uint8  tellerType;
    uint32 password;
} TMS_TELLER_CFG_DATA;
typedef list<TMS_TELLER_CFG_DATA *> TMS_TELLER_CFG_LIST;

typedef struct _TMS_VERSION_CFG_DATA
{
    uint8  machineType;             //适用机型
    char   szVersionNo[16];         //版本号字符串
    uint8  status;                  //是否可用
} TMS_VERSION_CFG_DATA;
typedef list<TMS_VERSION_CFG_DATA *> TMS_VERSION_CFG_LIST;


//-------------------------------------------------------------------------------------------------------
//
// gl  tool
//
//-------------------------------------------------------------------------------------------------------

//去掉字符串头尾部的空格字符
char *strtrim(char *string);

void ts_regex_init(void);
void ts_regex_release(void);
bool ts_regex_ticket_match(const char *str);
bool ts_regex_bettype_match(uint8 bet, const char *str);


#endif


