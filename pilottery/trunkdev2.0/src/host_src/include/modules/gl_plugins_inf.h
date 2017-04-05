#ifndef GL_PLUGIN_INF_H_INCLUDED
#define GL_PLUGIN_INF_H_INCLUDED


// ----------------------------------------------------------------------------------------
//
// 游戏插件内容数据结构定义
//
// ----------------------------------------------------------------------------------------

typedef enum _PLUGIN_FUN_TYPE
{
    //TTY
    TTY_SPECPRIZE = 1, //获取TTY特殊奖级开启标志

    //7LX

} PLUGIN_FUN_TYPE;

//投注方式查找表
const char bettypeAbbr[MAX_BETTYPE_COUNT][10] = {"", "DS", "FS", "DT", "BD", "HZ", "BC", "BH", "YXFS", "FW"};
//游戏玩法查找表
const char subtypeAbbr[MAX_GAME_NUMBER][MAX_SUBTYPE_COUNT][10] = {
        //0
        {{0}},

        //SSQ(1)
        {"", "ZX"},
    
        //3D(2)
        {"", "ZX", "ZUX", "Z3", "Z6"},

        //KENO(3)
        {{0}},

        //7LC(4)
        {"", "ZX"},

        //SSC(5)
        {"", "1ZX", "2ZX", "2FX", "2ZUX", "3ZX", "3FX", "3ZUX", "3Z3", "3Z6", "5ZX", "5FX", "5TX", "DXDS"},

        //KOCTTY(6)
        {"", "QH2", "QH3", "4ZX","Q2","H2","Q3","H3"},

        //KOC7LX(7)
        {"", "ZX", "ZXHALF"},

        //KOCKENO(8)
        {"", "X1", "X2", "X3", "X4", "X5", "X6", "X7", "X8", "X9", "X10", "DX", "DS"},

        //KOCK2(9)
        {"", "JC", "4T"},

        //KOCC30S6(10)
        {"", "ZX"},

        //KOCK3(11)
        {"", "ZX", "3TA", "3TS", "3QA", "3DS", "2TA", "2TS", "2DS"},

        //KOC11X5(12)
        {"", "RX2", "RX3", "RX4", "RX5", "RX6", "RX7", "RX8", "Q1", "Q2ZU", "Q3ZU", "Q2ZX", "Q3ZX" },

        //(13)
        {"", "DG", "WH"},

        //FBS(14)
        {"", "WIN","HCP","TOT","SCR","HFT","OUOD"},
};


//风险控制模式
typedef enum _RISK_MODE
{
    RISK_MODE_NOUSED  = 1,
    RISK_MODE_MAXPAY  = 2,
    RISK_MODE_MAXBET  = 3,
    RISK_MODE_COMBINE = 4,
} RISK_MODE;


//奖等分配规则
typedef enum _ASSIGN_TYPE
{
    ASSIGN_UNUSED = 0,
    ASSIGN_SHARED = 1,  //浮动奖金
    ASSIGN_FIXED  = 2,  //固定奖金
}ASSIGN_TYPE;


//奖池类别
typedef enum _POOL_TYPE
{
     //FIX_POOL = 0,                 //固定奖池
     SUB_POOL   = 1,             //玩法奖池
     GAME_POOL  = 2,             //游戏奖池
     NOUSE_POOL = 3,
}POOL_TYPE;


enum
{
    WINNER_LOCAL_FILE = 1,
    WINNER_CONFIRM_FILE
};


#pragma pack(1)

typedef struct _ISSUE_INFO_STAT
{
    money_t issueSaleAmount;                        //期次销售金额（不含未来期）
    uint32  issueSaleCount;                         //期次售票票数（不含未来期）
    uint32  issueSaleBetCount;                      //期次售票注数（不含未来期）

    money_t issueCancelAmount;                      //期次退票金额（不含未来期）
    uint32  issueCancelCount;                       //期次退票票数（不含未来期）
    uint32  issueCancelBetCount;                    //期次退票注数（不含未来期）

    money_t issueRefuseAmount;                      //期次风险控制造成的拒绝销售金额
    uint32  issueRefuseCount;                       //期次风险控制造成的拒绝销售次数

    //--------------------------------------------------------------------------------------------------
    //下面这两个字段这里也许可以不需要，在期结的时刻，起初的奖池金额应该从数据库中获取
    //money_t firstPoolAvailableCredit;               //期初第一奖池资金余额
    //money_t secondPoolAvailableCredit;              //期初第二奖池资金余额
    //--------------------------------------------------------------------------------------------------

} ISSUE_INFO_STAT;

typedef struct _ISSUE_INFO
{
    bool      used;
    uint8     gameCode;                             // 游戏编码
    uint64    issueNumber;                          // 期号
    uint32    serialNumber;                         // 期次序号
    uint8     curState;
    uint8     localState;
    time_type startTime;
    time_type closeTime;
    time_type drawTime;
    uint32    payEndDay;                            // 兑奖截止日期
    bool      willSaleFlagGl;                       // 游戏期次可预售已发送标志 GL本地修改

    char      drawCodeStr[MAX_GAME_RESULTS_STR_LEN];// 开奖号码
    char      winConfigStr[MAX_GAME_RESULTS_STR_LEN]; //算奖配置参数字符串

    ISSUE_INFO_STAT stat;
} ISSUE_INFO;


typedef struct _GL_ISSUE_CHKP_DATA
{
    ISSUE_INFO issueData[MAX_ISSUE_NUMBER];
}GL_ISSUE_CHKP_DATA;

//游戏插件接口的结构体定义 ---------------------------------------------------------


//奖级规则参数
typedef struct _PRIZE_PARAM
{
    bool used; //是否被使用
    uint8 prizeCode;  // 奖级编号
    char prizeName[ENTRY_NAME_LEN];
    bool hflag;//高等奖标记
    ASSIGN_TYPE assignType; //分配规则
    union
    {
        money_t sharedPrizeAmount;  //浮动奖金
        money_t fixedPrizeAmount;   //固定奖金
    };
} PRIZE_PARAM;

//游戏奖池参数
typedef struct _POOL_PARAM
{
    char poolName[ENTRY_NAME_LEN];
    money_t poolAmount; //奖池可用金额
} POOL_PARAM;


// {{ plugin interface define begin
// {{奖金计算模块类型定义

typedef struct _GL_PRIZE_CALC
{
    // 传入参数
    money_t saleAmount; // 销售总额
    POOL_AMOUNT pool; // 奖池
    money_t adjustAmount; // 调节基金总额
    money_t publishAmount; // 发行基金总额
    uint16  returnRate; //返奖率

    // 传出参数： 实际使用的金额
    money_t prizeAmount; // 奖金总和，包括高等奖，固定奖
    POOL_AMOUNT poolUsed; // 本期需要划入奖池的金额(本期销售额*理论返奖率-本期派奖总额)
    money_t highPrize2Adjust; // 高等奖金转入调节基金的钱, 高等奖的抹零值转入调节基金
    int32 moneyEnough;      // 当期奖金是否不足
}GL_PRIZE_CALC;

// 奖级属性
// 超级大乐透独有属性：prizeWinnerSupplementNum first100PrizeBase prizeSupplement first100PrizeSupplement
// 其他游戏将这些字段填为0
typedef struct _GL_PRIZE_INFO
{
    // 传入参数
    uint32 prizeBaseCount; // 基本投注中奖数
    uint32 prizeAddCount; // 追加投注中奖数, 超级大乐透独有属性

    // 传出参数
    money_t prizeBaseAmount; // 基本投注奖金数目

    money_t prizeAddAmount; // 追加投注奖金数目, 超级大乐透独有属性
    money_t first100PrizeBase; // 前一百名投注基本奖金数目, 超级大乐透独有属性
    money_t first100PrizeAdd; // 前一百名追加投注奖金数目, 超级大乐透独有属性

    // 玩法编码
    uint32 subtypeCode;
} GL_PRIZE_INFO;

// }}奖金计算模块类型定义


typedef struct _PRIZE_PARAM_ISSUE
{
    uint8 prizeCode;  // 奖级编号
    money_t prizeAmount;   //奖金
} PRIZE_PARAM_ISSUE;

typedef struct _GL_PLUGIN_INFO
{
    int  issueCount;     //主机启动时 申请的期空间数，在mem_create中赋值
    void *subtype_info;  //玩法规则参数表
    void *division_info; //匹配规则参数表

    // 下列参数内存大小与期数相关
    void *issue_info;   //期信息
    void *prize_info;   //奖级
    void *pool_info;    //奖池
    void *rk_info;      //风控
}GL_PLUGIN_INFO;
typedef GL_PLUGIN_INFO* GL_PLUGIN_INFO_PTR;


//游戏插件的接口 -------------------------------------------------------------------------------
typedef struct _BETPART_STR
{
    char bpALL[7][100]; //投注号码串的冒号分隔拆分
    int bpALLCnt;       //冒号分隔部分的个数
    
    char bpADT[2][100]; //bpALL[0]的小于号分隔拆分
    int bpADTCnt;       //小于号分隔部分的个数(1无胆拖2有胆拖)
    
    char bpAE[7][100];  //bpAE[0]存放胆码区(bpADT[0])的加号拆分
                        //bpAE[i](i非零)存放bpALL[i](i非零)的加号拆分
    int bpAECnt[7];
    
    char bpAT[100];     //拖码区(bpADT[1]如有)的加号分隔拆分
    int bpATCnt;
} BETPART_STR;


//根据游戏名缩写，得到游戏编码，游戏不可用返回0，失败返回-1
int gl_formatGame(const char *betStr);

//将投注字符串转为TICKET结构体，返回TICKET结构体长度
int gl_formatTicket(const char *betStr, char *ticket_buf, int buf_len);
int gl_fbs_formatTicket(const char *betStr, char *ticket_buf, int buf_len);
void gl_dumpFbsTicket(FBS_TICKET *ticket);
void gl_dumpTicket(TICKET *ticket);
int splitBetpart(const char buf[], BETPART_STR *bpStr, int flag = 0);


//奖级参数模板，传入算奖接口函数
typedef struct _GT_PRIZE_PARAM
{
    PRIZE_PARAM  prize_param[MAX_PRIZE_COUNT];
    char         calc_struct[100];             //奖金计算特殊字符串
}GT_PRIZE_PARAM;






// ----------------------------------------------------------------------------------------
//
// FBS 游戏插件内容数据结构定义
//
// ----------------------------------------------------------------------------------------






// ----------------------------------------------------------------------------------------
//
// 游戏插件接口定义
//
// ----------------------------------------------------------------------------------------

typedef struct _GAME_PLUGIN_INTERFACE
{
    uint8 gameCode;

    bool (*mem_creat)(int issue_count);    //游戏玩法，匹配，风控等参数共享内存创建
    bool (*mem_destroy)(void);
    bool (*mem_attach)(void);
    bool (*mem_detach)(void);
    void *(*get_mem_db)(void); // For tsview

    bool (*load_memdata)(void); //内存数据初始化

    ISSUE_INFO* (*get_issueTable)(void);
    void* (*get_subtypeTable)(int *len);
    void* (*get_divisionTable)(int *len, uint64 issueNum);
    PRIZE_PARAM* (*get_prizeTable)(uint64 issueNum); //获取奖级参数列表
    POOL_PARAM* (*get_poolParam)(void); //获取奖池参数列表
    void* (*get_rkTable)(void);

    int (*get_singleAmount)(char *buffer, size_t len);

    ISSUE_INFO* (*get_currIssue)();//获取当前期,如果没有返回NULL
    ISSUE_INFO* (*get_issueInfo)(uint64 issueNum);
    ISSUE_INFO* (*get_issueInfo2)(uint32 issueSerial);
    uint32 (*get_issueCurrMaxSeq)(void);

    int (*sale_ticket_verify)(const TICKET* pTicket);
    int (*create_drawNum)(const uint8 xcodes[], uint8 len);//生成开奖号码对应的bitmap
    int (*match_ticket)(const TICKET *ticket, const char *subtype, const char *division, uint32 matchRet[MAX_PRIZE_COUNT]);//匹配
    int (*calc_prize)(uint64 issue_number, GL_PRIZE_CALC *przCalc, GT_PRIZE_PARAM *prizeTemplate, GL_PRIZE_INFO prizeInfo[MAX_PRIZE_COUNT]);//算奖

    // buf: 投注行号码区(不包含括号)
    // length: buf的长度
    // mode: bitmap的模式
    // betline: 结果存入betline
    int (*format_ticket)(char* buf, uint32 length, int mode, BETLINE* betline);

    bool (*sale_rk_verify)(TICKET* pTicket);
    void (*sale_rk_commit)(TICKET* pTicket);
    void (*cancel_rk_rollback)(TICKET* pTicket);
    void (*cancel_rk_commit)(TICKET* pTicket);
    void (*rk_reinitData)(void);

    //currMaxPay 针对TTY，是一个结构体,包含3个玩法的 money_t 类型值; 针对KENO,K2 游戏,存放 &money_t 既可
    bool (*get_rkReportData)(uint32 issueSeq,void *currMaxPay);

    int (*get_issueMaxCount)();
    int (*get_issueCount)();
    int (*load_newIssueData)(void *issueBuf, int32 issueCount); // ISSUE_CFG_DATA * list --> issueBuf
    int (*load_oldIssueData)(void *issueBuf, int32 issueCount); //ISSUE_INFO * list --> issueBuf ,stat data in issueBuf
    bool (*del_issue)(uint64 issueNum);
    bool (*clear_oneIssueData)(uint64 issueNum);

    bool (*chkp_saveData)(const char *filePath); //插件数据checkpoint, 包括期次统计数据、期次风险控制数据
    bool (*chkp_restoreData)(const char *filePath);

    bool (*load_prizeParam)(uint64 issue,PRIZE_PARAM_ISSUE *prize); // load prize param of issue,prize[MAX_PRIZE_COUNT]
    bool (*load_issue_RKdata)(uint32 startIssueSeq,int issue_count, char *rk_param);

    int (*resolve_winConfigString)(uint64 issue, void *buf); //解析某期的算奖配置参数字符串，结果存入buf

    // for tsview
    PRIZE_PARAM* (*get_prizeTableStart)(void);
    ISSUE_INFO* (*get_issueInfoByIndex)(int idx);
    void* (*get_rkIssueDataTable)(void);
    char* (*get_winConfigString)(uint64 issue); //获取某期的算奖配置参数字符串
    // an opaque 'handle' for the loaded dynamic library
    void *fun_handle;

    //通用的函数，处理一些特殊功能(如get TTY特殊奖级开启与否)
    int (*gen_fun)(int type, char *in, char *out);


    // FBS 使用的接口定义 ----------------------------------------
    int (*fbs_update_configuration)(char *config_string);
    //
    FBS_SUBTYPE_PARAM* (*fbs_get_subtypeParam)(uint32 subtype);
    const char*(*fbs_get_result_string)(uint8 subtype, uint8 result_enum);
    //
    int (*fbs_load_issue)(int n, DB_FBS_ISSUE *issue_list);
    FBS_ISSUE* (*fbs_get_issue)(uint32 issue_number);
    int (*fbs_del_issue)(uint32 issue_number);
    FBS_MATCH* (*fbs_get_match)(uint32 issue_number, uint32 match_code);
    int (*fbs_del_match)(uint32 match_code);
    int (*fbs_calc_rt_odds)(FBS_TICKET *ticket);
    int (*fbs_update_match_result)(uint32 issue_number, uint32 match_code, SUB_RESULT s_results[], uint8 match_result[]);

    int (*fbs_load_match)(int n, uint32 issue_number, DB_FBS_MATCH *match_list);
    int (*fbs_load_newMatch)(void);
    //外部判断是否为空是否可用
    FBS_ISSUE* (*fbs_get_issueTable)(void);
    //
    int (*fbs_format_ticket)(const char* buf, FBS_TICKET *ticket);
    int (*fbs_split_order)(FBS_TICKET *ticket);
    //
    int (*fbs_ticket_verify)(const FBS_TICKET* ticket, uint32 *outDate);//返回最后一场比赛的关闭日期(即开奖日期)

    //计算各玩法各赛果的销售情况，上传DB，OMS监控使用
    int (*fbs_sale_calc)(uint32 issue_number, uint32 match_code, char *outBuf);

    //
    int (*fbs_sale_rk_verify)(FBS_TICKET* ticket);
    int (*fbs_sale_rk_commit)(FBS_TICKET* ticket);
    int (*fbs_cancel_rk_rollback)(FBS_TICKET* ticket);
    int (*fbs_cancel_rk_commit)(FBS_TICKET* ticket);
    //
    bool (*fbs_chkp_saveData)(const char *filePath);
    bool (*fbs_chkp_restoreData)(const char *filePath);

}GAME_PLUGIN_INTERFACE;

typedef bool (*PLUGIN_INIT_FUN)(GAME_PLUGIN_INTERFACE *plugin_i);




//创建共享内存
int gl_game_plugins_create();
//销毁共享内存
int gl_game_plugins_destroy();

//使用某个游戏插件初始化，不挂共享内存
int gl_game_plugins_init_game(uint8 gameCode, GAME_PLUGIN_INTERFACE *out);

//使用游戏插件初始化
int gl_game_plugins_init();
//使用游戏插件完成关闭
int gl_game_plugins_close();

GAME_PLUGIN_INTERFACE *gl_plugins_handle();


//使用游戏插件初始化(不attach共享内存)
GAME_PLUGIN_INTERFACE *gl_plugins_handle_s(uint8 game_code);





//游戏插件内部共用结构定义 ------------------------------------------------------------------------

#define GL_BETLINE(ticket) ((void*) ((char*)ticket + sizeof(TICKET) + ticket->betStringLen))
#define GL_BETLINE_NEXT(betline) ((void*) ((char*)betline + sizeof(BETLINE) + betline->bitmapLen))
#define GL_BETPART_A(betline) ((GL_BETPART*)(betline->bitmap))
#define GL_BETPART_B(betline) ((GL_BETPART*)(betline->bitmap + ((GL_BETPART*)betline->bitmap)->size + 2))
#define GL_BETTYPE_A(betline) (betline->bettype & 0x0f)
#define GL_BETTYPE_B(betline) ((betline->bettype & 0xf0) >> 4)

typedef struct _GL_BETPART
{
    uint8 mode;         //bitmap模式enum MODE
    uint8 size;         //bitmap使用的长度
    uint8 bitmap[64];   //存放不定长的bitmap
} GL_BETPART;





/*==============================================================================
 * 常量定义，并对所定义的常量进行说明
 * Constant / Define Declarations
 =============================================================================*/

const uint8 MAX_C = 21;
const uint8 MAX_P = 11;
// 缓存组合
const uint32 CacheC[][MAX_C] =
{
{ 0 },
{ 1, 1 },
{ 1, 2, 1 },
{ 1, 3, 3, 1 },
{ 1, 4, 6, 4, 1 },
{ 1, 5, 10, 10, 5, 1 },
{ 1, 6, 15, 20, 15, 6, 1 },
{ 1, 7, 21, 35, 35, 21, 7, 1 },
{ 1, 8, 28, 56, 70, 56, 28, 8, 1 },
{ 1, 9, 36, 84, 126, 126, 84, 36, 9, 1 },
{ 1, 10, 45, 120, 210, 252, 210, 120, 45, 10, 1 },
{ 1, 11, 55, 165, 330, 462, 462, 330, 165, 55, 11, 1 },
{ 1, 12, 66, 220, 495, 792, 924, 792, 495, 220, 66, 12, 1 },
{ 1, 13, 78, 286, 715, 1287, 1716, 1716, 1287, 715, 286, 78, 13, 1 },
{ 1, 14, 91, 364, 1001, 2002, 3003, 3432, 3003, 2002, 1001, 364, 91, 14, 1 },
{ 1, 15, 105, 455, 1365, 3003, 5005, 6435, 6435, 5005, 3003, 1365, 455, 105, 15, 1 },
{ 1, 16, 120, 560, 1820, 4368, 8008, 11440, 12870, 11440, 8008, 4368, 1820, 560, 120, 16, 1 },
{ 1, 17, 136, 680, 2380, 6188, 12376, 19448, 24310, 24310, 19448, 12376, 6188, 2380, 680, 136, 17, 1 },
{ 1, 18, 153, 816, 3060, 8568, 18564, 31824, 43758, 48620, 43758, 31824, 18564, 8568, 3060, 816, 153, 18, 1 },
{ 1, 19, 171, 969, 3876, 11628, 27132, 50388, 75582, 92378, 92378, 75582, 50388, 27132, 11628, 3876, 969, 171, 19, 1 },
{
        1,
        20,
        190,
        1140,
        4845,
        15504,
        38760,
        77520,
        125970,
        167960,
        184756,
        167960,
        125970,
        77520,
        38760,
        15504,
        4845,
        1140,
        190,
        20,
        1 } };

// 缓存排列
const uint32 CacheP[][MAX_P] =
{
{ 0 },
{ 0, 1 },
{ 0, 2, 2 },
{ 0, 3, 6, 6 },
{ 0, 4, 12, 24, 24 },
{ 0, 5, 20, 60, 120, 120 },
{ 0, 6, 30, 120, 360, 720, 720 },
{ 0, 7, 42, 210, 840, 2520, 5040, 5040 },
{ 0, 8, 56, 336, 1680, 6720, 20160, 40320, 40320 },
{ 0, 9, 72, 504, 3024, 15120, 60480, 181440, 362880, 362880 },
{ 0, 10, 90, 720, 5040, 30240, 151200, 604800, 1814400, 3628800, 3628800 } };





#pragma pack()

int num2bit(
        const uint8 num[],
        uint8 len,
        uint8 bit[],
        uint8 bitOff,
        uint8 base);

int bit2num(
        const uint8 bit[],
        uint8 len,
        uint8 num[],
        uint8 base);

int bitCount(
        const uint8* arr,
        uint8 off,
        uint8 len);

int bitAnd(
        const uint8* arr1,
        uint8 arr1Off,
        const uint8* arr2,
        uint8 arr2Off,
        uint8 len,
        uint8* ret);

int bitHL2num(
        const uint8 *arr,
        uint8 off,
        uint8 len,
        int flagHL,//0:最低位 1：最高位
        int base);//ssq:1  3D:0....

uint32 drawnumDistribute(
        const uint8 xcode[],
        uint8 len);

uint32 mathpow(
        int base,
        int expr);

uint32 mathc(
        int8 base,
        int8 expr);

uint32 mathp(
        int8 base,
        int8 expr);

int bettype2num(
        uint8 bettype,
        uint8 num[]);

int num2bettype(
        const uint8 num[],
        uint8 *bettype);

int gl_verifyLineParam(
        uint8 gameidx,
        uint16 times);

int gl_bettypeVerify(
        uint32 bettype,
        const BETLINE *betline);

uint8 bitToUint8(
        const uint8* bitArr,
        uint8 * const numArr,
        const uint8 bitSize,
        const uint8 bitBase);

uint16 gl_sortArray(const uint8 array[],int count);

void permutation(uint8 arr[], int begin, int end, uint8 post[][5], int *idx);

int combintion(int n, int k, uint8 post[][4]);


//dump issue state ------------------------------
const char *ISSUE_STATE_STR(uint32 type);
const char *ISSUE_STATE_STR_S(uint32 type);
const char *ISSUE_STATE_STR_S_FBS(uint32 type);

//dump fbs match state ------------------------------
const char *MATCH_STATE_STR(uint32 type);


#endif //GL_PLUGIN_INF_H_INCLUDED

