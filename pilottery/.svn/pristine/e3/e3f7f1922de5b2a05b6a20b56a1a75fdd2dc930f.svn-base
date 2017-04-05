#ifndef GAME_ISSUE_H_INCLUDED
#define GAME_ISSUE_H_INCLUDED


#define GIDB_MAX_GAME_NUMBER MAX_GAME_NUMBER
#define GIDB_MAX_ISSUE_NUMBER 100000



//第几次开奖
typedef enum _DRAW_TIMES {
    GAME_DRAW_ONE    = 1,
    GAME_DRAW_TWO    = 2,
    GAME_DRAW_THREE  = 3,
} DRAW_TIMES;


#pragma pack(1)

//----------------------------
//数据表记录访问结构
//----------------------------

//票索引记录
typedef struct _GIDB_TICKET_IDX_REC {
    uint64     unique_tsn;                      //唯一序号
    char       reqfn_ticket[TSN_LENGTH];        //售票交易流水号(请求)(**需要确认终端机流水号的生成规则  和  接入商流水号的生成规则 **)
    char       rspfn_ticket[TSN_LENGTH];        //售票交易流水号(响应)(**确认终端机响应流水号的生成规则(含TSN)  和  接入商流水号的生成规则 **)
    uint8      gameCode;                        //游戏编码
    uint64     issueNumber;                     //销售期号
    uint64     drawIssueNumber;                 //中奖期号
    uint8      from_sale;
    uint16     extend_len;
    char       extend[];
} GIDB_TICKET_IDX_REC;

//销售票记录
typedef struct _GIDB_SALE_TICKET_REC {
    char       reqfn_ticket[TSN_LENGTH];        //售票交易流水号(请求)(**需要确认终端机流水号的生成规则  和  接入商流水号的生成规则 **)
    char       rspfn_ticket[TSN_LENGTH];        //售票交易流水号(响应)(**确认终端机响应流水号的生成规则(含TSN)  和  接入商流水号的生成规则 **)
    uint64     unique_tsn;                      //唯一序号

    time_type  timeStamp;                       //时间戳

    uint8      from_sale;                       //票来源

    uint64     issueNumber;                     //销售期号(购买时的当前期号)

    money_t    commissionAmount;                //售票佣金返还金额
    uint8      claimingScope;                   //游戏兑奖范围, enum AREA_LEVEL
    time_type  drawTimeStamp;                   //最后一期开奖时间

    uint32     areaCode;                        //所属区域编码
    uint8      areaType;                        //所属区域类型
    uint64     agencyCode;                      //销售站编码
    uint64     terminalCode;                    //终端编码
    uint32     tellerCode;                      //Teller编码

    uint32     apCode;                          //接入商编码

    uint8      isTrain;                         //是否培训模式: 否(0)/是(1)

    uint8      isCancel;                        //是否已退票
    //记录一些退票的销售站信息及游戏信息
    uint8      from_cancel;                     //票来源 -- 退票
    char       reqfn_ticket_cancel[TSN_LENGTH]; //退票交易流水号(请求)
    char       rspfn_ticket_cancel[TSN_LENGTH]; //退票交易流水号(响应)
    time_type  timeStamp_cancel;                //时间戳 -- 退票
    uint64     agencyCode_cancel;               //销售站编码 -- 退票
    uint64     terminalCode_cancel;             //终端编码 -- 退票
    uint32     tellerCode_cancel;               //Teller编码 -- 退票
    uint32     apCode_cancel;                   //接入商编码 -- 退票

    //票信息
    TICKET     ticket;
} GIDB_SALE_TICKET_REC;


//中奖匹配文件的存储结构体
typedef struct _GIDB_MATCH_TICKET_REC
{
    uint64    unique_tsn;                      //唯一序号
    char      reqfn_ticket[TSN_LENGTH];        //售票交易流水号(请求)
    char      rspfn_ticket[TSN_LENGTH];        //售票交易流水号(响应)
    time_type timeStamp;                        //时间戳

    uint8    from_sale;                         //票来源

    uint32  areaCode;                           //所属区域编码
    uint8   areaType;                           //所属区域类型
    uint64  agencyCode;                         //销售站编码
    uint64  terminalCode;                       //终端编码
    uint32  tellerCode;                         //Teller编码

    uint32  apCode;                             //接入商编码

    uint8   gameCode;                           //游戏编码
    uint64  issueNumber;                        //销售期号
    uint8   issueCount;                         //连续购买期数
    uint64  saleStartIssue;                     //购买的起始期号
    uint32  saleStartIssueSerial;               //购买的起始期序号
    uint64  saleEndIssue;                       //购买的最后期号
    uint16  totalBets;                          //总注数
    money_t ticketAmount;                       //票面销售金额

    uint8   claimingScope;                      //游戏兑奖范围, enum AREA_LEVEL

    uint8   isTrain;                            //是否培训模式: 否(0)/是(1)

    //中奖信息
    VALUE_TRIPLE match_result[MAX_PRIZE_COUNT];

    //投注行信息
    uint16  betStringLen; //投注字符串长度
    char    betString[]; //投注字符串
} GIDB_MATCH_TICKET_REC;


typedef enum _PRIZE_PAYMENT_STATUS
{
    PRIZE_PAYMENT_PENDING = 1,     // 可兑奖，但还未兑奖
    PRIZE_PAYMENT_PAID,            // 已兑奖完毕
    PRIZE_PAYMENT_NONE = 100,      // 不可兑奖, 连续多期票
} PRIZE_PAYMENT_STATUS;

//中奖票记录
typedef struct _GIDB_WIN_TICKET_REC
{
    //下面是原始的售票信息
    uint64    unique_tsn;                      //唯一序号
    char      reqfn_ticket[TSN_LENGTH];        //售票交易流水号(请求)
    char      rspfn_ticket[TSN_LENGTH];        //售票交易流水号(响应)
    time_type timeStamp;                        //时间戳

    uint8    from_sale;                         //票来源

    uint32  areaCode;                           //所属区域编码
    uint8   areaType;                           //所属区域类型
    uint64  agencyCode;                         //销售站编码
    uint64  terminalCode;                       //终端编码
    uint32  tellerCode;                         //Teller编码

    uint32  apCode;                             //接入商编码

    uint8   gameCode;                           //游戏编码
    uint64  issueNumber;                        //销售期号
    uint8   issueCount;                         //连续购买期数
    uint64  saleStartIssue;                     //购买的起始期号
    uint32  saleStartIssueSerial;               //购买的起始期序号
    uint64  saleEndIssue;                       //购买的最后期号
    uint16  totalBets;                          //总注数
    money_t ticketAmount;                       //票面销售金额

    uint8   claimingScope;                      //游戏兑奖范围, enum AREA_LEVEL

    uint8   isTrain;                            //是否培训模式: 否(0)/是(1)

    //投注行信息
    uint32  bet_string_len;
    char    bet_string[MAX_BET_STRING_LENGTH];  //投注号码字符串

    //下面是中奖的信息
    uint8   isBigWinning;                       //是否是大奖  0=不是  1=是
    money_t winningAmountWithTax;               //奖金金额(含税)
    money_t winningAmount;                      //奖金金额(不含税)
    money_t taxAmount;                          //奖金税金
    int32   winningCount;                       //总的中奖注数
    money_t hd_winning;                         //高等奖中奖金额
    int32   hd_count;                           //高等奖中奖注数
    money_t ld_winning;                         //低等奖中奖金额
    int32   ld_count;                           //低等奖中奖注数

    //兑奖状态
    uint8   paid_status;                        //兑奖状态  enum PRIZE_PAYMENT_STATUS

    //记录一些兑奖的销售站信息及游戏信息
    uint8    from_pay;                          //票来源 -- 兑奖
    char       reqfn_ticket_pay[TSN_LENGTH];    //兑奖交易流水号(请求)
    char       rspfn_ticket_pay[TSN_LENGTH];    //兑奖交易流水号(响应)
    time_type timeStamp_pay;                    //时间戳 -- 兑奖
    
    uint64  agencyCode_pay;                     //销售站唯一编号 -- 兑奖
    uint64  terminalCode_pay;                   //终端唯一编号 -- 兑奖
    uint32  tellerCode_pay;                     //销售员唯一编号 -- 兑奖
    uint32  apCode_pay;                         //接入商编码 -- 兑奖

    //兑大奖使用的信息字段
    char    userName_pay[ENTRY_NAME_LEN];       //用户姓名
    int     identityType_pay;                   //证件类型
    char    identityNumber_pay[IDENTITY_CARD_LENGTH]; //证件号码

    //下面是中奖的明细
    uint8   prizeCount;                         //中的奖等的数量
    uint32  prizeDetail_length;                 //下面的变长数据的长度
    PRIZE_DETAIL prizeDetail[];                 //奖等明细
} GIDB_WIN_TICKET_REC;



//多期票使用的 临时中奖票记录
typedef struct _GIDB_TMP_WIN_TICKET_REC
{
    //下面是原始的售票信息
    uint64     unique_tsn;                      //唯一序号
    char       reqfn_ticket[TSN_LENGTH];        //售票交易流水号(请求)
    char       rspfn_ticket[TSN_LENGTH];        //售票交易流水号(响应)
    time_type timeStamp;                        //时间戳

    uint8    from_sale;                         //票来源

    uint32  areaCode;                           //所属区域编码
    uint8   areaType;                           //所属区域类型
    uint64  agencyCode;                         //销售站编码
    uint64  terminalCode;                       //终端编码
    uint32  tellerCode;                         //Teller编码

    uint32  apCode;                             //接入商编码

    uint8   gameCode;                           //游戏编码
    uint64  issueNumber;                        //销售期号
    uint8   issueCount;                         //连续购买期数
    uint64  saleStartIssue;                     //购买的起始期号
    uint32  saleStartIssueSerial;               //购买的起始期序号
    uint64  saleEndIssue;                       //购买的最后期号
    uint16  totalBets;                          //总注数
    money_t ticketAmount;                       //票面销售金额

    uint8   claimingScope;                      //游戏兑奖范围, enum AREA_LEVEL

    uint8   isTrain;                            //是否培训模式: 否(0)/是(1)

    //投注行信息
    uint32  bet_string_len;
    char    bet_string[MAX_BET_STRING_LENGTH];  //投注号码字符串

    //下面是中奖的信息
    uint8   isBigWinning;                       //是否是大奖  0=不是  1=是
    uint32  win_issue_number;                   //中奖期号
    money_t winningAmountWithTax;               //奖金金额(含税)
    money_t winningAmount;                      //奖金金额(不含税)
    money_t taxAmount;                          //奖金税金
    int32   winningCount;                       //总的中奖注数
    money_t hd_winning;                         //高等奖中奖金额
    int32   hd_count;                           //高等奖中奖注数
    money_t ld_winning;                         //低等奖中奖金额
    int32   ld_count;                           //低等奖中奖注数

    //下面是中奖的明细
    uint8   prizeCount;                         //中的奖等的数量
    uint32  prizeDetail_length;                 //下面的变长数据的长度
    PRIZE_DETAIL prizeDetail[];                 //奖等明细
} GIDB_TMP_WIN_TICKET_REC;




//------------------------------------------------------------------------------------------
// 兑奖 和 退票 接口使用的结构


//更新兑奖信息使用的结构体
typedef struct _GIDB_PAY_TICKET_STRUCT {
    char    reqfn_ticket_pay[TSN_LENGTH];     //兑奖交易流水号(请求)
    char    rspfn_ticket_pay[TSN_LENGTH];     //兑奖交易流水号(响应)

    char    rspfn_ticket[TSN_LENGTH];         //售票交易流水号(响应)
    uint64  unique_tsn;                       //唯一序号

    uint32  timeStamp_pay;                              //时间戳 -- 兑奖

    uint8   from_pay;                                   //票来源 -- 兑奖
    
    uint64  agencyCode_pay;                     //销售站唯一编号 -- 兑奖
    uint64  terminalCode_pay;                   //终端唯一编号 -- 兑奖
    uint32  tellerCode_pay;                     //销售员唯一编号 -- 兑奖
    uint32  apCode_pay;                         //接入商编码 -- 兑奖
    uint64  issueNumber_pay;                    //兑奖发生时的期号 -- 兑奖

    //兑大奖使用的信息字段
    char    userName_pay[ENTRY_NAME_LEN];               //用户名称 -- 兑奖
    int     identityType_pay;                           //证件类型 -- 兑奖
    char    identityNumber_pay[IDENTITY_CARD_LENGTH];   //证件号码 -- 兑奖

    uint8   isTrain;                                    //是否培训模式: 否(0)/是(1)

    uint8   gameCode;                       //游戏编码
    uint64  issueNumber;                    //销售期号
    money_t ticketAmount;                   //票面金额
    uint8   isBigWinning;                   //是否是大奖  0=不是  1=是
    money_t winningAmountWithTax;           //奖金金额(含税)
    money_t winningAmount;                  //奖金金额(不含税)
    money_t taxAmount;                      //奖金税金
    int32   winningCount;                   //总的中奖注数

    uint8   paid_status;                    //兑奖状态  enum PRIZE_PAYMENT_STATUS
} GIDB_PAY_TICKET_STRUCT;



//更新退票信息使用的结构体
typedef struct _GIDB_CANCEL_TICKET_STRUCT {
    char    reqfn_ticket_cancel[TSN_LENGTH];//退票交易流水号(请求)
    char    rspfn_ticket_cancel[TSN_LENGTH];//退票交易流水号(响应)

    char    rspfn_ticket[TSN_LENGTH];       //售票交易流水号(响应)
    uint64  unique_tsn;                     //唯一序号

    uint32  timeStamp_cancel;               //时间戳 -- 退票
    uint8   from_cancel;                    //票来源 -- 退票

    uint64  agencyCode_cancel;              //销售站编码 -- 退票
    uint64  terminalCode_cancel;            //终端编码 -- 退票
    uint32  tellerCode_cancel;              //Teller编码 -- 退票
    uint32  apCode_cancel;                  //接入商编码 -- 退票

    uint8   isTrain;                        //是否培训模式: 否(0)/是(1)
    money_t cancelAmount;                   //退票金额
    uint32  betCount;                       //总注数

    //票信息
    TICKET  ticket;
} GIDB_CANCEL_TICKET_STRUCT;

#pragma pack()

typedef list<GIDB_TICKET_IDX_REC *> TICKET_IDX_LIST;
typedef list<GIDB_SALE_TICKET_REC *> SALE_TICKET_LIST;
typedef list<GIDB_PAY_TICKET_STRUCT *> PAY_TICKET_LIST;
typedef list<GIDB_CANCEL_TICKET_STRUCT *> CANCEL_TICKET_LIST;
typedef list<GIDB_MATCH_TICKET_REC *> MATCH_TICKET_LIST;
typedef map<string, GIDB_WIN_TICKET_REC *> WIN_TICKET_MAP;
typedef list<GIDB_WIN_TICKET_REC *> WIN_TICKET_LIST;
typedef list<GIDB_TMP_WIN_TICKET_REC *> TMP_WIN_TICKET_LIST;


//------------------------------
// issue manage Interface
//------------------------------

//字符串数据字段key 
typedef enum _ISSUE_FIELD_TEXT_KEY
{
    I_DRAW_CODE_TEXT_KEY = 1,                         //开奖号码字符串 
    I_DRAW_ANNOUNCE_TEXT_KEY                          //drawAnnounce（开奖公告） 
}ISSUE_FIELD_TEXT_KEY;

typedef struct _GIDB_ISSUE_INFO
{
    uint8 gameCode;                                 //游戏编码
    uint64 issueNumber;
    uint32 serialNumber;                            //期次序号
    uint8 status;

    time_type estimate_start_time;
    time_type estimate_close_time;
    time_type estimate_draw_time;
    time_type real_start_time;
    time_type real_close_time;
    time_type real_draw_time;
    time_type real_pay_time; 
    
    uint32 payEndDay;                               //兑奖截止日期(年月日)
    char draw_code_str[MAX_GAME_RESULTS_STR_LEN];   //开奖号码字符串
} GIDB_ISSUE_INFO;

struct _GIDB_ISSUE_HANDLE;
typedef struct _GIDB_ISSUE_HANDLE GIDB_ISSUE_HANDLE;
struct _GIDB_ISSUE_HANDLE {
    uint8 game_code;
    sqlite3 *db;

    int32 (*gidb_i_init_data)(GIDB_ISSUE_HANDLE *self);
    int32 (*gidb_i_insert)(GIDB_ISSUE_HANDLE *self, GIDB_ISSUE_INFO *p_issue_info);
    int32 (*gidb_i_cleanup)(GIDB_ISSUE_HANDLE *self, uint64 issue_num);

    int32 (*gidb_i_get_info)(GIDB_ISSUE_HANDLE *self, uint64 issue_num, GIDB_ISSUE_INFO *p_issue_info);
    int32 (*gidb_i_get_info2)(GIDB_ISSUE_HANDLE *self, uint32 issue_serial, GIDB_ISSUE_INFO *p_issue_info);

    int32 (*gidb_i_set_status)(GIDB_ISSUE_HANDLE *self, uint64 issue_num, uint8 issue_status, uint32 real_time);
    int32 (*gidb_i_get_status)(GIDB_ISSUE_HANDLE *self, uint64 issue_num, uint8 *issue_status);

    int32 (*gidb_i_set_field_text)(GIDB_ISSUE_HANDLE *self, uint64 issue_num, ISSUE_FIELD_TEXT_KEY field_type, char *str);
    int32 (*gidb_i_get_field_text)(GIDB_ISSUE_HANDLE *self, uint64 issue_num, ISSUE_FIELD_TEXT_KEY field_type, char *str);
};
typedef map<uint32, GIDB_ISSUE_HANDLE*> GAME_ISSUE_MAP;

//获取期次访问的操作接口
GIDB_ISSUE_HANDLE * gidb_i_get_handle(uint8 game_code);

//任务退出时调用此接口关闭db文件
int32 gidb_i_close_handle();



//------------------------------
// issue draw Interface
//------------------------------

//和draw_table交互用的模板，用于将数据放入表中或从表中拿出数据
typedef struct _GIDB_D_DATA
{
    uint8  status;
    time_type update_time;

    uint32 field_type;
    uint32 data_len;
    char   data[];
}GIDB_D_DATA;

//字符串数据字段key 
typedef enum _D_FIELD_TEXT_KEY
{
    DRAW_CODE_TEXT_KEY = 1,                         //开奖号码字符串
    DRAW_WINNER_LOCAL_TEXT_KEY = 2,                 //winner.local(本地算奖结果)
    DRAW_WINNER_CONFIRM_TEXT_KEY = 3,               //winner.confirm（确认后的算奖结果）
    DRAW_ANNOUNCE_TEXT_KEY = 4,
}D_FIELD_TEXT_KEY;

//二进制数据字段key
typedef enum _D_FIELD_BLOB_KEY
{
    D_TICKETS_STAT_BLOB_KEY = 1,                 //本期票统计信息
    D_WLEVEL_STAT_BLOB_KEY = 2,                  //期次各奖等中奖统计
    D_WPRIZE_LEVEL_BLOB_KEY = 3,                 //期次奖级奖金统计信息
    D_WPRIZE_LEVEL_CONFIRM_BLOB_KEY = 4,         //期次奖级奖金统计信息 （确认后）
    D_WFUND_INFO_BLOB_KEY = 5,                   //期次奖池数据
    D_WFUND_INFO_CONFIRM_BLOB_KEY = 6,           //确认后的奖池数据
}D_FIELD_BLOB_KEY;

struct _GIDB_DRAW_HANDLE;
typedef struct _GIDB_DRAW_HANDLE GIDB_DRAW_HANDLE;
struct _GIDB_DRAW_HANDLE {
    _GIDB_DRAW_HANDLE(){}
    uint8  game_code;
    uint64 issue_number;
    uint8 draw_times;
    uint32 last_time; //最后一次访问时间
    sqlite3 *db;

    bool commit_flag_match;
    MATCH_TICKET_LIST matchTicketList;

    int32 (*gidb_d_cleanup)(GIDB_DRAW_HANDLE *self);
    int32 (*gidb_d_clean_match_table)(GIDB_DRAW_HANDLE *self);

    int32 (*gidb_d_set_status)(GIDB_DRAW_HANDLE *self, GIDB_D_DATA *gd_data);
    int32 (*gidb_d_get_status)(GIDB_DRAW_HANDLE *self, GIDB_D_DATA *gd_data);

    int32 (*gidb_d_set_field_text)(GIDB_DRAW_HANDLE *self, GIDB_D_DATA *gd_data);
    int32 (*gidb_d_get_field_text)(GIDB_DRAW_HANDLE *self, GIDB_D_DATA *gd_data);

    int32 (*gidb_d_set_field_blob)(GIDB_DRAW_HANDLE *self, GIDB_D_DATA *gd_data);
    int32 (*gidb_d_get_field_blob)(GIDB_DRAW_HANDLE *self, GIDB_D_DATA *gd_data);

    //将匹配票的结果放入内存链表
    int32 (*gidb_d_insert_ticket)(GIDB_DRAW_HANDLE *self, GIDB_MATCH_TICKET_REC *pTicketMatch);
    //将LIST内存中的匹配纪录写入数据库文件
    int32 (*gidb_d_sync_ticket)(GIDB_DRAW_HANDLE *self);
};
typedef map<uint64, GIDB_DRAW_HANDLE*> DRAW_ISSUE_MAP;

//获取期次访问的操作接口
GIDB_DRAW_HANDLE * gidb_d_get_handle(uint8 game_code, uint64 issue_number, uint8 draw_times);

//任务退出时调用此接口关闭db文件
int gidb_d_clean_handle_timeout();
int32 gidb_d_close_handle();



//------------------------------
// ticket index Interface
//------------------------------

struct _GIDB_TICKET_IDX_HANDLE;
typedef struct _GIDB_TICKET_IDX_HANDLE GIDB_TICKET_IDX_HANDLE;
struct _GIDB_TICKET_IDX_HANDLE {
    _GIDB_TICKET_IDX_HANDLE(){}
    uint32 date; //20150910
    uint32 last_time; //最后一次访问时间
    sqlite3 *db;

    bool commit_flag;
    TICKET_IDX_LIST ticketIdxList;

    //插入销售票索引 (批量式插入，插入完成后需要调用同步接口，才能更新到数据库) 
    int32 (*gidb_tidx_insert_ticket)(GIDB_TICKET_IDX_HANDLE *self, GIDB_TICKET_IDX_REC *pTIdxRec);
    //将本期的LIST内存中的(售票、退票的记录)数据写入数据库文件
    int32 (*gidb_tidx_sync)(GIDB_TICKET_IDX_HANDLE *self);
     //get ticket by unique_tsn
    int32 (*gidb_tidx_get)(GIDB_TICKET_IDX_HANDLE *self, uint64 unique_tsn, GIDB_TICKET_IDX_REC *pTIdxRec);
      //get ticket by reqfn_ticket
    int32 (*gidb_tidx_get2)(GIDB_TICKET_IDX_HANDLE *self, char *reqfn_ticket, GIDB_TICKET_IDX_REC *pTIdxRec);
};
typedef map<uint64, GIDB_TICKET_IDX_HANDLE*> TICKET_IDX_MAP;

//获取期次访问的操作接口
GIDB_TICKET_IDX_HANDLE * gidb_tidx_get_handle(uint32 date);

//任务退出时调用此接口关闭db文件
int gidb_tidx_clean_handle_timeout();
int32 gidb_tidx_close_handle();

int32 get_ticket_idx(uint32 date, uint64 unique_tsn, GIDB_TICKET_IDX_REC *pTIdxRec);
int32 get_ticket_idx2(uint32 date, char *reqfn_ticket, GIDB_TICKET_IDX_REC *pTIdxRec);

//------------------------------
// issue sale ticket Interface
//------------------------------

typedef struct _GT_GAME_PARAM
{
    uint8 gameCode; //游戏编码
    GAME_TYPE gameType; // 游戏类型
    char gameAbbr[15]; //游戏字符缩写
    char gameName[MAX_GAME_NAME_LENGTH]; //游戏名称
    char organizationName[MAX_ORGANIZATION_NAME_LENGTH]; //发行单位名称

    uint16 publicFundRate; //公益金比例
    uint16 adjustmentFundRate; //调节金比例
    uint16 returnRate; //理论返奖率
    money_t taxStartAmount; //缴税起征额(单位:瑞尔)
    uint16 taxRate; //缴税千分比
    uint16 payEndDay; //兑奖期(天)

    DRAW_TYPE drawType; //期次开奖模式

    money_t bigPrize; //判定是否是大额奖 （小于超大额奖限额）(确定是否是大额奖)(单票)
}GT_GAME_PARAM;

//二进制数据字段key
typedef enum _T_FIELD_BLOB_KEY
{
    T_GAME_PARAMBLOB_KEY = 1,
    T_SUBTYPE_PARAMBLOB_KEY,
    T_DIVISION_PARAMBLOB_KEY,
    T_PRIZE_PARAMBLOB_KEY,
    T_POOL_PARAMBLOB_KEY,
}T_FIELD_BLOB_KEY;

struct _GIDB_T_TICKET_HANDLE;
typedef struct _GIDB_T_TICKET_HANDLE GIDB_T_TICKET_HANDLE;
struct _GIDB_T_TICKET_HANDLE {
    _GIDB_T_TICKET_HANDLE(){}
    uint8  game_code;
    uint64 issue_number;
    uint32 last_time; //最后一次访问时间
    sqlite3 *db;

    bool commit_flag;
    SALE_TICKET_LIST saleTicketList;
    CANCEL_TICKET_LIST cancelTicketList;

    int32 (*gidb_t_set_field_blob)(GIDB_T_TICKET_HANDLE *self, T_FIELD_BLOB_KEY field_type, char *data, int32 len);
    int32 (*gidb_t_get_field_blob)(GIDB_T_TICKET_HANDLE *self, T_FIELD_BLOB_KEY field_type, char *data, int32 *len);

    //插入销售票 (内部支持多期票的插入) (批量式插入，插入完成后需要调用同步接口，才能更新到数据库) 
    int32 (*gidb_t_insert_ticket)(GIDB_T_TICKET_HANDLE *self, GIDB_SALE_TICKET_REC *pTicketSell);
    //更新彩票为已退票(批量式插入，插入完成后需要调用同步接口，才能更新到数据库)
    int32 (*gidb_t_update_cancel)(GIDB_T_TICKET_HANDLE *self, GIDB_CANCEL_TICKET_STRUCT *pCancelInfo);
    //将本期的LIST内存中的(售票、退票的记录)数据写入数据库文件
    int32 (*gidb_t_sync_sc_ticket)(GIDB_T_TICKET_HANDLE *self);
    //get ticket by rspfn_ticket
    int32 (*gidb_t_get_ticket)(GIDB_T_TICKET_HANDLE *self, uint64 unique_tsn, GIDB_SALE_TICKET_REC *pTicketSell);
};
typedef map<uint64, GIDB_T_TICKET_HANDLE*> T_TICKET_MAP;

//获取期次访问的操作接口
GIDB_T_TICKET_HANDLE * gidb_t_get_handle(uint8 game_code, uint64 issue_number);

//任务退出时调用此接口关闭db文件
int gidb_t_clean_handle_timeout();
int32 gidb_t_close_handle();


//------------------------------
// issue win ticket Interface
//------------------------------

struct _GIDB_W_TICKET_HANDLE;
typedef struct _GIDB_W_TICKET_HANDLE GIDB_W_TICKET_HANDLE;
struct _GIDB_W_TICKET_HANDLE {
    _GIDB_W_TICKET_HANDLE(){}
    uint8 game_code;
    uint64 issue_number;
    uint8 draw_times;
    uint32 last_time; //最后一次访问时间
    uint64 tmp_win_draw_issue; //最近一次开奖的期号，用于清除临时表中，此开奖期插入的在本期可兑奖的多期中奖票
    sqlite3 *db;

    //tf_update使用，用于批量更新入库
    bool commit_flag;
    PAY_TICKET_LIST payTicketList;

    bool commit_flag_win;
    WIN_TICKET_LIST winTicketList;

    bool commit_flag_tmp_win;
    TMP_WIN_TICKET_LIST tmpWinTicketList;

    //更新彩票为已兑奖(批量式插入，插入完成后需要调用同步接口，才能更新到数据库)
    int32 (*gidb_w_update_pay)(GIDB_W_TICKET_HANDLE *self, GIDB_PAY_TICKET_STRUCT *pPayInfo);
    //将本期的LIST内存中的(兑奖的记录)数据写入数据库文件
    int32 (*gidb_w_sync_pay_ticket)(GIDB_W_TICKET_HANDLE *self);

    //将中奖票的结果放入内存链表
    int32 (*gidb_w_insert_ticket)(GIDB_W_TICKET_HANDLE *self, GIDB_WIN_TICKET_REC *pTicketWin);
    //将LIST内存中的中奖票写入数据库文件
    int32 (*gidb_w_sync_ticket)(GIDB_W_TICKET_HANDLE *self);

    //插入多期的中奖票到最后一期的临时中奖票数据表中(批量式插入，插入完成后需要调用同步接口，才能更新到数据库)
    int32 (*gidb_w_insert_tmp_ticket)(GIDB_W_TICKET_HANDLE *self, GIDB_TMP_WIN_TICKET_REC *pTicketTmpWin);
    //将本期的临时中奖纪录数据批量写入数据库文件
    int32 (*gidb_w_sync_tmp_ticket)(GIDB_W_TICKET_HANDLE *self);
    //merge tmp_win_table 到 wim_ticket_table
    int32 (*gidb_w_merge_tmp_ticket)(GIDB_W_TICKET_HANDLE *self, money_t big_prize);
    //开奖期出问题时清理临时中奖表
    int32 (*gidb_w_clean_tmp_ticket)(GIDB_W_TICKET_HANDLE *self, uint64 draw_issue_number);

    //get win ticket by rspfn_ticket
    int32 (*gidb_w_get_ticket)(GIDB_W_TICKET_HANDLE *self, uint64 unique_tsn, GIDB_WIN_TICKET_REC *pTicketWin);
};
typedef map<uint64, GIDB_W_TICKET_HANDLE*> W_TICKET_MAP;

//通过期次序号得到期次handle
GIDB_W_TICKET_HANDLE * gidb_w_get_handle(uint8 game_code, uint64 issue_number, uint8 draw_times);

//清理长时间不使用的handle
int gidb_w_clean_handle_timeout();

//在所有程序退出后，关闭所有打开的db文件, 每个使用GIDB模块的任务，在退出时调用
int gidb_w_close_handle();

//map中期次文件handle清理时间
#define ISSUE_HANDLE_TIMEOUT 60

//同步所有游戏的期数据到数据库文件(销售、兑奖、退票)
int32 gidb_sync_all_spc_ticket();

//同步彩票索引数据
int32 gidb_sync_tidx_ticket();




//------------------------------------------------------------------------------------

int32 T_sell_inm_rec_2_db_tidx_rec(INM_MSG_T_SELL_TICKET *pInmMsg, GIDB_TICKET_IDX_REC *pTIdxRec);
int32 T_sell_inm_rec_2_db_ticket_rec(INM_MSG_T_SELL_TICKET *pInmMsg, GIDB_SALE_TICKET_REC *pTicket);
int32 T_pay_inm_rec_2_db_ticket_rec(INM_MSG_T_PAY_TICKET *pInmMsg, GIDB_PAY_TICKET_STRUCT *pTicket);
int32 T_cancel_inm_rec_2_db_ticket_rec(INM_MSG_T_CANCEL_TICKET *pInmMsg, GIDB_CANCEL_TICKET_STRUCT *pTicket);

int32 O_pay_inm_rec_2_db_ticket_rec(INM_MSG_O_PAY_TICKET *pInmMsg, GIDB_PAY_TICKET_STRUCT *pTicket);
int32 O_cancel_inm_rec_2_db_ticket_rec(INM_MSG_O_CANCEL_TICKET *pInmMsg, GIDB_CANCEL_TICKET_STRUCT *pTicket);

int32 AP_pay_inm_rec_2_db_ticket_rec(INM_MSG_AP_PAY_TICKET *pInmMsg, GIDB_PAY_TICKET_STRUCT *pTicket);

//------------------------------
// issue draw log Interface
//------------------------------


struct _GIDB_DRAWLOG_HANDLE;
typedef struct _GIDB_DRAWLOG_HANDLE GIDB_DRAWLOG_HANDLE;
struct _GIDB_DRAWLOG_HANDLE {
    uint8 game_code;
    sqlite3 *db;

    int32 (*gidb_drawlog_append_dc)(GIDB_DRAWLOG_HANDLE *self, uint64 issue_number);
    int32 (*gidb_drawlog_get_last_dc)(GIDB_DRAWLOG_HANDLE *self, uint32 *msgid, uint64 *issue_number);
    int32 (*gidb_drawlog_confirm_dc)(GIDB_DRAWLOG_HANDLE *self, uint32 msgid);

    int32 (*gidb_drawlog_append_dl)(GIDB_DRAWLOG_HANDLE *self, uint64 issue_number, int32 msg_type, char *msg, int32 msg_len);
    int32 (*gidb_drawlog_get_last_dl)(GIDB_DRAWLOG_HANDLE *self, uint32 *msgid, uint8 *msg_type, char *msg, uint32 *msg_len);
    int32 (*gidb_drawlog_confirm_dl)(GIDB_DRAWLOG_HANDLE *self, uint32 msgid, uint32 flag);

    int32 (*gidb_drawlog_get_rec)(GIDB_DRAWLOG_HANDLE *self, uint64 issue_number, int32 msg_type);
};
typedef map<uint32, GIDB_DRAWLOG_HANDLE*> GAME_DRAWLOG_MAP;

//获取期次访问的操作接口
GIDB_DRAWLOG_HANDLE * gidb_drawlog_get_handle(uint8 game_code);

//任务退出时调用此接口关闭db文件
int32 gidb_drawlog_close_handle();




//内部函数--------------------------------------------------------------------------------


//内部计算奖金使用
typedef struct _PRIZE_TABLE
{
    int32      hflag;         //是否高等奖
    money_t    money_amount;  //单注金额
    money_t    tax;
} PRIZE_TABLE;


//建表
int32 db_create_table(sqlite3 *db, const char *sql);

//建立索引
int32 db_create_table_index(sqlite3 *db, const char *sql);

//判断指定的数据表是否存在  1=not exist  0=exist -1=error
int32 db_check_table_exist(sqlite3 *db, const char *table_name);

//开始事务
int db_begin_transaction(sqlite3 *db);

//提交事务
int db_end_transaction(sqlite3 *db);

//连接sqlite数据库 
sqlite3 * db_connect(const char *db_file);

//关闭sqlite数据库 
int32 db_close(sqlite3 *db);


//从读到的一条票索引记录，构造 GIDB_TICKET_IDX_REC 信息
int32 get_ticket_idx_rec_from_stmt(GIDB_TICKET_IDX_REC *pRec, sqlite3_stmt* pStmt);
//从读到的一条match表记录，构造 GIDB_SALE_TICKET_REC 信息
int32 get_sale_ticket_rec_from_stmt(GIDB_SALE_TICKET_REC *pRec, sqlite3_stmt* pStmt);
//从读到的一条match表记录，构造 GIDB_WIN_TICKET_REC 信息
int32 get_winner_ticket_rec_from_stmt(GIDB_WIN_TICKET_REC *pRec, sqlite3_stmt* pStmt);
//从读到的一条match表记录，构造 GIDB_TMP_WIN_TICKET_REC 信息
int32 get_tmp_winner_ticket_rec_from_stmt(GIDB_TMP_WIN_TICKET_REC *pRec, sqlite3_stmt* pStmt);
//从读到的一条match表记录，构造 GIDB_MATCH_TICKET_REC 信息
int32 get_match_ticket_rec_from_stmt(GIDB_MATCH_TICKET_REC *pRec, sqlite3_stmt* pStmt);


//bind  GIDB_TICKET_IDX_REC to sqlite3_stmt  for insert
int32 bind_ticket_idx(GIDB_TICKET_IDX_REC *pTidxRec, sqlite3_stmt* pStmt);
//bind  GIDB_SALE_TICKET_REC to sqlite3_stmt  for insert
int32 bind_sale_ticket(GIDB_SALE_TICKET_REC *pSaleRec, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len);
//bind  GIDB_WIN_TICKET_REC to sqlite3_stmt  for insert
int32 bind_winner_ticket(GIDB_WIN_TICKET_REC *pWinRec, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len);
//bind  GIDB_TMP_WIN_TICKET_REC to sqlite3_stmt  for insert
int32 bind_tmp_winner_ticket(GIDB_TMP_WIN_TICKET_REC *pTmpWinRec, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len);
//bind  GIDB_MATCH_TICKET_REC to sqlite3_stmt  for insert
int32 bind_match_ticket(GIDB_MATCH_TICKET_REC *pMatchRec, sqlite3_stmt* pStmt);

//bind  GIDB_PAY_TICKET_STRUCT to sqlite3_stmt  for update pay table
int32 bind_update_pay_ticket(GIDB_PAY_TICKET_STRUCT *pPayRec, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len);
//bind  GIDB_CANCEL_TICKET_STRUCT to sqlite3_stmt  for update pay table
int32 bind_update_cancel_ticket(GIDB_CANCEL_TICKET_STRUCT *pCancelRec, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len);





//转换 GIDB_SALE_TICKET_REC ---->  GIDB_MATCH_TICKET_REC
int32 sale_ticket_2_match_ticket_rec(GIDB_SALE_TICKET_REC *pSaleRec, GIDB_MATCH_TICKET_REC * pMatchRec);

//转换 GIDB_MATCH_TICKET_REC ---->  GIDB_WIN_TICKET_REC
int32 match_ticket_2_win_ticket_rec(GIDB_MATCH_TICKET_REC *pMatchRec, GIDB_WIN_TICKET_REC *pWinRec);

//转换 GIDB_WIN_TICKET_REC ---->  GIDB_TMP_WIN_TICKET_REC
int32 win_ticket_2_tmp_win_ticket_rec(GIDB_WIN_TICKET_REC *pWinRec, GIDB_TMP_WIN_TICKET_REC *pTmpWinRec);

//转换 GIDB_TMP_WIN_TICKET_REC ---->  GIDB_WIN_TICKET_REC
int32 tmp_win_ticket_2_win_ticket_rec(GIDB_TMP_WIN_TICKET_REC *pTmpWinRec, GIDB_WIN_TICKET_REC *pWinRec);






//--------------------------------------------------------------
//  xxx
//--------------------------------------------------------------

//匹配函数指针
typedef int (*match_ticket_callback)(const TICKET *ticket, const char *subtype, const char *division, uint32 matchRet[MAX_PRIZE_COUNT]);


//从售票记录生成匹配记录文件
int32 gidb_match_ticket_callback(uint8 game_code,
                                 uint64 issue_number,
                                 uint8 draw_times,
                                 match_ticket_callback match_func,
                                 ISSUE_REAL_STAT *pIssue_real_stat);

//从匹配文件生成中奖表
int32 gidb_win_ticket_callback(uint8 game_code,
                               uint64 issue_number,
                               uint8 draw_times,
                               PRIZE_LEVEL prize_level_array[MAX_PRIZE_COUNT],
                               WIN_TICKET_STAT *winTktStat);


//生成向中心上传的销售文件
int32 gidb_seal_file(uint8 game_code, uint64 issue_number, TICKET_STAT *ticket_stat);

//生成无纸化销售的中奖文件
int32 gidb_generate_ap_win_file(uint8 game_code, uint64 issue_number, uint8 draw_times);

//生成中奖明细文件
int32 gidb_generate_issue_win_file(uint8 game_code, uint64 issue_number, uint8 draw_times, char *file);






//------------------------------
// 业务驱动 log Interface
//------------------------------

struct _GIDB_DRIVERLOG_HANDLE;
typedef struct _GIDB_DRIVERLOG_HANDLE GIDB_DRIVERLOG_HANDLE;
struct _GIDB_DRIVERLOG_HANDLE {
    sqlite3 *db;

    int32 (*gidb_driverlog_append_dl)(GIDB_DRIVERLOG_HANDLE *self, uint32 game, uint64 issue, uint64 match, int32 msg_type, char *msg, int32 msg_len);
    int32 (*gidb_driverlog_get_last_dl)(GIDB_DRIVERLOG_HANDLE *self, uint32 type, uint32 *msgid, uint8 *msg_type,uint8 *gameCode, char *msg, uint32 *msg_len);
    int32 (*gidb_driverlog_confirm_dl)(GIDB_DRIVERLOG_HANDLE *self, uint32 msgid, uint32 flag);
};
//获取访问的操作接口
GIDB_DRIVERLOG_HANDLE * gidb_driverlog_get_handle();
//任务退出时调用此接口关闭db文件
int32 gidb_driverlog_close_handle();


#endif //GAME_ISSUE_H_INCLUDED

