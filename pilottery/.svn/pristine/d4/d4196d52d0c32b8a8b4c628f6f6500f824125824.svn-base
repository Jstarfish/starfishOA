#ifndef TYPE_DEFINE_H_INCLUDED
#define TYPE_DEFINE_H_INCLUDED

//------------------------------------------------------------------------------
// ALL
//------------------------------------------------------------------------------

//响应ecode枚举定义
typedef enum _ECODE
{
    SUCCESS = 0,              //成功
    FAILURE = 1,              //失败
}ECODE;

//状态类型
typedef enum _STATUS_TYPE
{
    STATUS_EMPTY = 0,
    ENABLED      = 1,         //可用
    DISABLED     = 2,         //不可用
    DELETED      = 3,         //已删除
}STATUS_TYPE;

//业务类型(用于流水号生成)
typedef enum _BUSINESS_TYPE
{
    BUS_SALE   = 0,
    BUS_PAY    = 1,
    BUS_CANCEL = 2,
}BUSINESS_TYPE;

//票来源
typedef enum  _TICKET_FROM_TYPE {
    TICKET_FROM_EMPTY = 0,
    TICKET_FROM_TERM  = 1,    //来自终端
    TICKET_FROM_AP    = 2,    //来自接入商
    TICKET_FROM_OMS   = 3,    //来自OMS
} TICKET_FROM_TYPE;

//RNG使用状态
typedef enum _RNG_STATUS_USED
{
    RNG_STATUS_ON  = 1,
    RNG_STATUS_OFF = 2,
}RNG_STATUS_USED;



//------------------------------------------------------------------------------
// GL
//------------------------------------------------------------------------------

//游戏标识
typedef enum _GAME {
    G_NONE         = 0,
    GAME_SSQ       = 1,    //双色球
    GAME_3D        = 2,    //3D
    GAME_KENO      = 3,    //基诺
    GAME_7LC       = 4,    //七乐彩
    GAME_SSC       = 5,    //时时彩

    //柬埔寨项目
    GAME_KOCTTY    = 6,   //柬埔寨天天赢
    GAME_KOC7LX    = 7,   //柬埔寨七龙星
    GAME_KOCKENO   = 8,   //柬埔寨基诺
    GAME_KOCK2     = 9,   //柬埔寨快2
    GAME_KOCC30S6  = 10,  //柬埔寨30选6
    GAME_KOCK3     = 11,  //快3
	GAME_KOC11X5   = 12,  //11选5
    GAME_TEMA      = 13,  //特码
    //足球
    GAME_FBS       = 14,  //足彩
    GAME_FODD      = 15,  //固定赔率
}GAME;

//游戏类型
typedef enum  _GAME_TYPE {
    GT_NONE           = 0,
    GAME_TYPE_KENO    = 1,     // 快开
    GAME_TYPE_LOTTO   = 2,     // 乐透
    GAME_TYPE_DIGIT   = 3,     // 数字
    GAME_TYPE_FINAL_ODDS = 4,  // 最终赔率型游戏
	GAME_TYPE_FIXED_ODDS = 5,  // 固定赔率型游戏
}GAME_TYPE;

//游戏开奖摇号模式
typedef enum _DRAW_TYPE
{
    DT_NONE          = 0,
    INSTANT_GAME     = 1,      // 电子开奖，快开型
    MANUAL_INTERNAL  = 2,      // 手工派奖，内部奖池
    MANUAL_EXTERNAL  = 3,      // 手工派奖，外部奖池
}DRAW_TYPE;

//期次状态
typedef enum _ISSUE_STATUS
{
    ISSUE_STATE_RANGED          = 0,  //期次预排，不可被销售，可以被删除
    ISSUE_STATE_PRESALE         = 1,  //期次预售，可以在多期票中被销售 
    ISSUE_STATE_OPENED          = 2,  //期次开始
    ISSUE_STATE_CLOSING         = 3,  //期次即将结束
    ISSUE_STATE_CLOSED          = 4,  //期次结束
    ISSUE_STATE_SEALED          = 5,  //期次封存，期结流程开始
    ISSUE_STATE_DRAWNUM_INPUTED = 6,  //期结:开奖号码录入
    ISSUE_STATE_MATCHED         = 7,  //期结:销售票的匹配计算完成
    ISSUE_STATE_FUND_INPUTED    = 8,  //期结:奖池参数录入
    ISSUE_STATE_LOCAL_CALCED    = 9,  //期结:本地算奖完成
    ISSUE_STATE_PRIZE_ADJUSTED  = 10, //期结:奖级调整完毕
    ISSUE_STATE_PRIZE_CONFIRMED = 11, //期结:开奖确认
    ISSUE_STATE_DB_IMPORTED     = 12, //期结:中奖数据入库
    ISSUE_STATE_ISSUE_END       = 13, //期结:期结完成
}ISSUE_STATUS;



//------------------------------------------------------------------------------
// TMS
//------------------------------------------------------------------------------

//范围级别
typedef enum _AREA_LEVEL
{
    COUNTRY_LEVEL  = 0,                //全国
    PROVINCE_LEVEL = 1,                //省
    AGENCY_LEVEL   = 3,                //销售站
}AREA_LEVEL;

//销售站类型
typedef enum _AGENCY_TYPE
{
    AGENCY_EMPTY       = 0,
    AGENCY_TERMINAL    = 1,            //传统终端(预付费)
    AGENCY_ACCREDIT    = 2,            //受信终端(后付费)
    AGENCY_CHANNEL     = 3,            //代销商
}AGENCY_TYPE;

//销售员类型
typedef enum _TELLER_TYPE
{
    EMPTY_TELLER      = 0,
    COMMON_TELLER     = 1,             //普通销售员
    AGENCY_MANAGER    = 2,             //销售站经理
    //BIGWINNER_TELLER  = 3,            //大额兑奖账户
    TRAINER_TELLER    = 3,             //培训员
}TELLER_TYPE;

//终端连接状态
typedef enum _TERM_CONNECTION_STATUS
{
    TERM_DISCONNECT = 0,
    TERM_CONNECT    = 1,
}TERM_CONNECTION_STATUS;

//销售员工作状态
typedef enum _TELLER_WORK_STATUS
{
    TELLER_WORK_EMPTY    = 0,
    TELLER_WORK_SIGNIN   = 1,          //签入
    TELLER_WORK_SIGNOUT  = 2,          //签出
    //TELLER_WORK_CLEANOUT,              //班结
}TELLER_WORK_STATUS;

//信用额度类型
typedef enum _CREDIT_LIMIT_TYPE
{
    MARGINAL      = 1,                 //信用额度
    TEMP_MARGINAL = 2,                 //临时信用额度
    BOTH_MARGINAL = 3,                 //信用额度 和 临时信用额度
}CREDIT_LIMIT_TYPE;



//------------------------------------------------------------------------------
// BUSINESS DEFINITION
//------------------------------------------------------------------------------

#pragma pack (1)



//投注字符串定义
//SSQ | 21030814007 | 8 | 24000 | FLAG | ZX-DS-(1+2+3+4+5+6:7)-1-0 / ZX-DS-(1+2+3+4+5+6:7)-1-0 / ZX-DS-(1+2+3+4+5+6:7)-1-0
//游戏 | 期号 | 连续购买期数 | 票金额 | 票扩展标记 | 投注行信息...


//投注行结构定义
typedef struct _BETLINE
{
    uint8   subtype;       //玩法
    uint8   bettype;       //投注方式
    uint16  betTimes;      //倍数
    uint16  flag;          //投注行扩展参数
    money_t singleAmount;  //单注金额(分)

    int32   betCount;      //投注行注数

    uint8   bitmapLen;     //bitmap长度
    char    bitmap[];
}BETLINE;

//票结构定义
typedef struct _TICKET
{
    uint16  length;          //结构长度，含自身两个字节
    uint8   gameCode;
    uint64  issue;           //期号 (售票如果当期期填0，则此GL模块更新此字段为当前期号)
    uint32  issueSeq;        //期次序号
    uint8   issueCount;      //购买期数
    uint64  lastIssue;       //购买的最后一期期号
    int32   betCount;        //总注数
    money_t amount;          //总金额
    uint16  flag;            //票扩展参数

    uint8   isTrain;         //是否培训模式: 否(0)/是(1)

    uint8   betlineCount;    //投注行数

    uint16  betStringLen;    //投注字符串长度

    uint16  betlineLen;      //后面投注行总长度
    char    betString[];     //投注字符串

    //BETLINE betlines[]; //投注行信息
}TICKET;

typedef struct _TICKET_STAT
{
    bool    used;
    uint64  issueNum;

    uint32  s_ticketCnt;
    uint32  s_betCnt;
    money_t s_amount;

    uint32  c_ticketCnt;
    uint32  c_betCnt;
    money_t c_amount;
} TICKET_STAT;

typedef struct _PRIZE_DETAIL
{
    char    name[ENTRY_NAME_LEN]; //奖等名称
    uint8   prizeCode;            //奖等编码(游戏插件PRIZE枚举)
    uint32  count;                //中奖注数
    money_t amountSingle;         //单注金额
    money_t amountBeforeTax;      //单注金额x中奖注数
    money_t amountTax;            //单注税金
    money_t amountAfterTax;       //(单注金额-税金)x中奖注数
} PRIZE_DETAIL;

//中奖票的统计
typedef struct _WIN_TICKET_STAT
{
	int64   winCnt;           //中奖票数量
	int64   bigPrizeCnt;      //大奖票数
	money_t bigPrizeAmount;   //大奖总金额
	int64   smallPrizeCnt;    //小奖票数
	money_t smallPrizeAmount; //小奖总金额
	int64   winBet;           //中奖总注数
	money_t winAmount;        //中奖总金额
}WIN_TICKET_STAT;






// -- FBS TICKET -------------------------------------------------

typedef struct _FBS_BETM {
    uint32 match_code;
    uint8  result_count; //投注的结果数目
    uint8  results[32];  //投注的赛果枚举值
}FBS_BETM;

typedef struct _FBS_ORDER {
    uint16  length;
    uint16  ord_no; //拆单编号
    uint8   bet_type; //过关方式(投注方式)
    money_t bet_amount; //已包含倍投
    uint32  bet_count; //已包含倍投
    uint8   match_count; //投注的比赛场次数
    uint8   result_count; //投注的赛果总数
    uint32  match_code_set[]; //这个拆单的比赛集合
}FBS_ORDER;

typedef struct _FBS_TICKET {
    uint16  length; //结构长度，含自身两个字节
    uint8   game_code; //游戏
    uint8   sub_type; //玩法
    uint32  issue_number; //可销售期的最小期号(注意 不是  场次所属期号)
    uint8   bet_type; //过关方式(投注方式)
    money_t bet_amount; //投注总金额  已包含倍投
    uint32  bet_count; //投注总注数  已包含倍投
    uint16  bet_times; //投注倍数
    uint16  flag; //扩展参数
    uint8   is_train; //是否培训模式: 否(0)/是(1)
    //
    uint16  match_count; //选择的场次总数
    uint16  order_count; //拆分的订单总数
    char    data[];
    //FBS_BETM match_array[]; //比赛的投注信息
    //FBS_ORDER ord_array[];
}FBS_TICKET;



#pragma pack ()



#endif //TYPE_DEFINE_H_INCLUDED



