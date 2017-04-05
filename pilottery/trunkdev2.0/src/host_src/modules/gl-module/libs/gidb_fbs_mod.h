#ifndef GAME_ISSUE_FBS_H_INCLUDED
#define GAME_ISSUE_FBS_H_INCLUDED

//内部函数--------------------------------------------------------------------------------



// sqlite 数据访问的结构体

//------------------------------
// issue & match manage Interface
//------------------------------

typedef struct _GIDB_FBS_ISSUE_INFO
{
    uint8 gameCode;                                 //游戏编码
    uint32 issueNumber; //期次编号
    uint32 publishTime; //期次发布时间
    uint16 adjustmentFundRate; //调节金比例
    uint16 returnRate; //理论返奖率
    uint16 payEndDay; //兑奖期(天)
} GIDB_FBS_ISSUE_INFO;

struct _GIDB_FBS_IM_HANDLE;
typedef struct _GIDB_FBS_IM_HANDLE GIDB_FBS_IM_HANDLE;
struct _GIDB_FBS_IM_HANDLE {
    uint8 game_code;
    sqlite3 *db;

    int32 (*gidb_fbs_im_init_data)(GIDB_FBS_IM_HANDLE *self);
    int32 (*gidb_fbs_im_insert_issue)(GIDB_FBS_IM_HANDLE *self, GIDB_FBS_ISSUE_INFO *p_issue_info);
    int32 (*gidb_fbs_im_get_issue)(GIDB_FBS_IM_HANDLE *self, uint32 issue_number, GIDB_FBS_ISSUE_INFO *p_issue_info);
    int32 (*gidb_fbs_im_del_issue)(GIDB_FBS_IM_HANDLE *self, uint32 issue_number); //删除指定期次及期次下面的所有场次
    int32 (*gidb_fbs_im_insert_matches)(GIDB_FBS_IM_HANDLE *self, GIDB_FBS_MATCH_INFO *p_matches, int match_count);
    int32 (*gidb_fbs_im_del_match)(GIDB_FBS_IM_HANDLE *self, uint32 match_code); //删除指定的比赛

    int32 (*gidb_fbs_im_get_matches)(GIDB_FBS_IM_HANDLE *self, uint32 issue_number, GIDB_FBS_MATCH_INFO *p_matches); //返回指定期次的比赛的总数
    int32 (*gidb_fbs_im_get_match)(GIDB_FBS_IM_HANDLE *self, uint32 match_code, GIDB_FBS_MATCH_INFO *p_match_info); //返回指定的比赛信息
};
//获取期次访问的操作接口
GIDB_FBS_IM_HANDLE * gidb_fbs_im_get_handle(uint8 game_code);

//关闭指定的handle
int32 gidb_fbs_im_close_handle(GIDB_FBS_IM_HANDLE *handle);
//关闭长时间未使用的handle
int gidb_fbs_im_clean_handle();
//关闭所有打开的handle
int gidb_fbs_im_close_all_handle();



//------------------------------
// 兑奖 和 退票 接口使用的结构
//------------------------------

//更新兑奖信息使用的结构体
typedef struct _GIDB_FBS_PT_STRUCT {
    char    reqfn_ticket_pay[TSN_LENGTH];    //兑奖交易流水号(请求)
    char    rspfn_ticket_pay[TSN_LENGTH];    //兑奖交易流水号(响应)

    char    rspfn_ticket[TSN_LENGTH];        //售票交易流水号(响应)
    uint64  unique_tsn;                      //唯一序号

    uint32  timeStamp_pay;                   //时间戳 -- 兑奖

    uint8   from_pay;                        //票来源 -- 兑奖

    uint64  agencyCode_pay;                  //销售站唯一编号 -- 兑奖
    uint64  terminalCode_pay;                //终端唯一编号 -- 兑奖
    uint32  tellerCode_pay;                  //销售员唯一编号 -- 兑奖
    uint64  issueNumber_pay;                 //兑奖发生时的期号 -- 兑奖

    //兑大奖使用的信息字段
    char    userName_pay[ENTRY_NAME_LEN];               //用户名称 -- 兑奖
    int     identityType_pay;                           //证件类型 -- 兑奖
    char    identityNumber_pay[IDENTITY_CARD_LENGTH];   //证件号码 -- 兑奖

    uint8   isTrain;                         //是否培训模式: 否(0)/是(1)

    uint8   gameCode;                        //游戏编码
    uint64  issueNumber;                     //销售期号
    money_t ticketAmount;                    //票面金额
    uint8   isBigWinning;                    //是否是大奖  0=不是  1=是
    money_t winningAmountWithTax;            //奖金金额(含税)
    money_t winningAmount;                   //奖金金额(不含税)
    money_t taxAmount;                       //奖金税金
    int32   winningCount;                    //总的中奖注数

    uint8   paid_status;                     //兑奖状态  enum PRIZE_PAYMENT_STATUS
} GIDB_FBS_PT_STRUCT;


//更新退票信息使用的结构体
typedef struct _GIDB_FBS_CT_STRUCT {
    char    reqfn_ticket_cancel[TSN_LENGTH]; //退票交易流水号(请求)
    char    rspfn_ticket_cancel[TSN_LENGTH]; //退票交易流水号(响应)

    char    rspfn_ticket[TSN_LENGTH];        //售票交易流水号(响应)
    uint64  unique_tsn;                      //唯一序号

    uint32  timeStamp_cancel;                //时间戳 -- 退票

    uint8   from_cancel;                     //票来源 -- 退票

    uint64  agencyCode_cancel;               //销售站编码 -- 退票
    uint64  terminalCode_cancel;             //终端编码 -- 退票
    uint32  tellerCode_cancel;               //Teller编码 -- 退票

    uint8   isTrain;                         //是否培训模式: 否(0)/是(1)
    money_t cancelAmount;                    //退票金额
    uint32  betCount;                        //总注数

    //票信息
    FBS_TICKET ticket;                       //票信息
} GIDB_FBS_CT_STRUCT;


//------------------------------
// sale ticket Interface
//------------------------------
typedef struct _GIDB_FBS_ST_REC {
    uint64    unique_tsn;                      //唯一序号
    char      reqfn_ticket[TSN_LENGTH];        //售票交易流水号(请求)
    char      rspfn_ticket[TSN_LENGTH];        //售票交易流水号(响应)
    time_type time_stamp;                      //时间戳

    uint8     from_sale;                       //票来源

    uint32    area_code;                       //所属区域编码
    uint8     area_type;                       //所属区域类型
    uint64    agency_code;                     //销售站编码
    uint64    terminal_code;                   //终端编码
    uint32    teller_code;                     //Teller编码

    uint8     claiming_scope;                  //游戏兑奖范围, enum AREA_LEVEL

    uint8     is_train;                        //是否培训模式: 否(0)/是(1)

    uint8     game_code;                       //游戏编码
    uint32    issue_number;                    //销售期号
    uint8     sub_type;                        //玩法
    uint8     bet_type;                        //过关方式(投注方式)
    money_t   total_amount;                    //投注总金额  已包含倍投
    money_t   commissionAmount;                //售票佣金返还金额
    uint32    total_bets;                      //投注总注数  已包含倍投
    uint16    bet_times;                       //投注倍数

    uint16    match_count;                     //选择的场次总数
    uint16    order_count;                     //拆分的订单总数
    uint16    bet_string_len;                  //包含最后的一个'\0'
    char      bet_string[MAX_BET_STRING_LENGTH];//投注字符串

    uint8     isCancel;                        //是否已退票
    //记录一些退票的销售站信息及游戏信息
    uint8     from_cancel;                     //票来源 -- 退票
    char      reqfn_ticket_cancel[TSN_LENGTH]; //退票交易流水号(请求)
    char      rspfn_ticket_cancel[TSN_LENGTH]; //退票交易流水号(响应)
    time_type timeStamp_cancel;                //时间戳 -- 退票
    uint64    agencyCode_cancel;               //销售站编码 -- 退票
    uint64    terminalCode_cancel;             //终端编码 -- 退票
    uint32    tellerCode_cancel;               //Teller编码 -- 退票

    FBS_TICKET ticket;                          //票信息
}GIDB_FBS_ST_REC;

typedef struct _FBS_GT_GAME_PARAM
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
}FBS_GT_GAME_PARAM;

//二进制数据字段key
typedef enum _FBS_ST_FIELD_BLOB_KEY
{
    FBS_ST_GAME_PARAMBLOB_KEY = 1,
    FBS_ST_SUBTYPE_PARAMBLOB_KEY,
    FBS_ST_POOL_PARAMBLOB_KEY,
}FBS_ST_FIELD_BLOB_KEY;

typedef list<GIDB_FBS_ST_REC *> FBS_ST_LIST;
typedef list<GIDB_FBS_CT_STRUCT *> FBS_CT_LIST;

struct _GIDB_FBS_ST_HANDLE;
typedef struct _GIDB_FBS_ST_HANDLE GIDB_FBS_ST_HANDLE;
struct _GIDB_FBS_ST_HANDLE {
    _GIDB_FBS_ST_HANDLE(){}
    uint8  game_code;
    uint32 issue_number;
    uint32 last_time; //最后一次访问时间
    sqlite3 *db;

    bool commit_flag;
    FBS_ST_LIST saleTicketList;
    FBS_CT_LIST cancelTicketList;

    int32 (*gidb_fbs_st_set_field_blob)(GIDB_FBS_ST_HANDLE *self, FBS_ST_FIELD_BLOB_KEY field_type, char *data, int32 len);
    int32 (*gidb_fbs_st_get_field_blob)(GIDB_FBS_ST_HANDLE *self, FBS_ST_FIELD_BLOB_KEY field_type, char *data, int32 *len);

    //插入销售票 (内部支持多期票的插入) (批量式插入，插入完成后需要调用同步接口，才能更新到数据库) 
    int32 (*gidb_fbs_st_insert_ticket)(GIDB_FBS_ST_HANDLE *self, GIDB_FBS_ST_REC *pSTicket);
    //更新彩票为已退票(批量式插入，插入完成后需要调用同步接口，才能更新到数据库)
    int32 (*gidb_fbs_st_update_cancel)(GIDB_FBS_ST_HANDLE *self, GIDB_FBS_CT_STRUCT *pCTicket);
    //将本期的LIST内存中的(售票、退票的记录)数据写入数据库文件
    int32 (*gidb_fbs_st_sync_sc_ticket)(GIDB_FBS_ST_HANDLE *self);
    //get ticket by rspfn_ticket
    int32 (*gidb_fbs_st_get_ticket)(GIDB_FBS_ST_HANDLE *self, uint64 unique_tsn, GIDB_FBS_ST_REC *pSTicket);
};
typedef map<uint64, GIDB_FBS_ST_HANDLE*> FBS_ST_MAP;

//获取期次访问的操作接口
GIDB_FBS_ST_HANDLE* gidb_fbs_st_get_handle(uint8 game_code, uint32 issue_number);
//关闭指定的handle
int32 gidb_fbs_st_close_handle(GIDB_FBS_ST_HANDLE *handle);
//关闭长时间未使用的handle
int gidb_fbs_st_clean_handle();
//关闭所有打开的handle
int gidb_fbs_st_close_all_handle();




//------------------------------
// win ticket Interface
//------------------------------

typedef struct _GIDB_FBS_WT_REC {
    uint64    unique_tsn;                      //唯一序号
    char      reqfn_ticket[TSN_LENGTH];        //售票交易流水号(请求)
    char      rspfn_ticket[TSN_LENGTH];        //售票交易流水号(响应)
    time_type time_stamp;                      //时间戳

    uint8     from_sale;                       //票来源

    uint32    area_code;                       //所属区域编码
    uint8     area_type;                       //所属区域类型
    uint64    agency_code;                     //销售站编码
    uint64    terminal_code;                   //终端编码
    uint32    teller_code;                     //Teller编码

    uint8     claiming_scope;                  //游戏兑奖范围, enum AREA_LEVEL
    uint8     is_train;                        //是否培训模式: 否(0)/是(1)

    uint8     game_code;                       //游戏编码
    uint32    issue_number;                    //销售期号
    uint8     sub_type;                        //玩法
    uint8     bet_type;                        //过关方式(投注方式)
    money_t   total_amount;                    //投注总金额
    uint32    total_bets;                      //投注总注数
    uint16    bet_times;                       //投注倍数

    uint16    match_count;                     //选择的场次总数
    uint16    order_count;                     //拆分的订单总数

    //投注行信息
    uint32    bet_string_len;
    char      bet_string[MAX_BET_STRING_LENGTH]; //投注号码字符串

    uint32    win_match_code;                  //在哪一场比赛的开奖过程中中奖

    //下面是中奖的信息
    uint8     isBigWinning;                    //是否是大奖  0=不是  1=是
    money_t   winningAmountWithTax;            //奖金金额(含税)
    money_t   winningAmount;                   //奖金金额(不含税)
    money_t   taxAmount;                       //奖金税金
    int32     winningCount;                    //总的中奖注数

    //兑奖状态
    uint8     paid_status;                     //兑奖状态  enum PRIZE_PAYMENT_STATUS

    //记录一些兑奖的销售站信息及游戏信息
    uint8     from_pay;                        //票来源 -- 兑奖
    char      reqfn_ticket_pay[TSN_LENGTH];    //兑奖交易流水号(请求)
    char      rspfn_ticket_pay[TSN_LENGTH];    //兑奖交易流水号(响应)
    time_type timeStamp_pay;                   //时间戳 -- 兑奖
    
    uint64    agencyCode_pay;                  //销售站唯一编号 -- 兑奖
    uint64    terminalCode_pay;                //终端唯一编号 -- 兑奖
    uint32    tellerCode_pay;                  //销售员唯一编号 -- 兑奖

    //兑大奖使用的信息字段
    char      userName_pay[ENTRY_NAME_LEN];    //用户姓名
    int       identityType_pay;                //证件类型
    char      identityNumber_pay[IDENTITY_CARD_LENGTH]; //证件号码
}GIDB_FBS_WT_REC;

typedef struct _GIDB_FBS_WO_REC {
    uint64    unique_tsn;
    uint16    ord_no;                          //拆单编号

    money_t   winningAmountWithTax;            //中奖金额
    money_t   winningAmount;                   //中奖金额(不含税)
    money_t   taxAmount;                       //税金
    int32     winningCount;                    //中奖注数

    uint8     game_code;                       //游戏
    uint8     sub_type;                        //玩法
    uint8     bet_type;                        //过关方式(投注方式)
    money_t   bet_amount;                      //拆单投注金额
    uint32    bet_count;                       //拆单投注注数

    uint32    win_match_code;                  //在哪一场比赛的开奖过程中中奖

    uint8     state;                           //状态 ( 0 投注  1 已过关  2 过关失败  3 全部过关  4 单关投注，比赛取消做退票处理)

    uint8     match_count;
    FBS_BETM  match_array[];                   //比赛的投注信息
}GIDB_FBS_WO_REC;

typedef list<GIDB_FBS_PT_STRUCT *> FBS_PT_LIST;
typedef list<GIDB_FBS_WT_REC *> FBS_WT_LIST;
typedef list<GIDB_FBS_WO_REC *> FBS_WO_LIST;
typedef list<GIDB_FBS_WT_REC *> FBS_SRT_LIST; //针对单关投注，发生比赛取消的情况

struct _GIDB_FBS_WT_HANDLE;
typedef struct _GIDB_FBS_WT_HANDLE GIDB_FBS_WT_HANDLE;
struct _GIDB_FBS_WT_HANDLE {
    _GIDB_FBS_WT_HANDLE(){}
    uint8  game_code;
    uint32 issue_number;
    uint8  draw_times;
    uint32 last_time; //最后一次访问时间
    sqlite3 *db;

    //tf_update使用，用于批量更新入库
    bool commit_flag_pay;
    FBS_PT_LIST payTicketList;

    bool commit_flag_win;
    FBS_WT_LIST winTicketList;

    bool commit_flag_order;
    FBS_WO_LIST winOrderList;

    //bool commit_flag_single_return;
    //FBS_SRT_LIST singleReturnTicketList;

    //更新彩票为已兑奖(批量式插入，插入完成后需要调用同步接口，才能更新到数据库)
    int32 (*gidb_fbs_wt_update_pay)(GIDB_FBS_WT_HANDLE *self, GIDB_FBS_PT_STRUCT *pPTicket);
    //将本期的LIST内存中的(兑奖的记录)数据写入数据库文件
    int32 (*gidb_fbs_wt_sync_pay_ticket)(GIDB_FBS_WT_HANDLE *self);

    //将中奖票的结果放入内存链表
    int32 (*gidb_fbs_wt_insert_ticket)(GIDB_FBS_WT_HANDLE *self, GIDB_FBS_WT_REC *pWTicket);
    int32 (*gidb_fbs_wt_insert_order)(GIDB_FBS_WT_HANDLE *self, GIDB_FBS_WO_REC *pWOrder);
    //int32 (*gidb_fbs_wt_insert_return)(GIDB_FBS_WT_HANDLE *self, GIDB_FBS_WT_REC *pSRTicket);
    //将LIST内存中的中奖票写入数据库文件
    int32 (*gidb_fbs_wt_sync_ticket)(GIDB_FBS_WT_HANDLE *self);
    //清除指定场次开奖的中奖票数据
    int32 (*gidb_fbs_wt_clean)(GIDB_FBS_WT_HANDLE *self, uint32 match_code);

    //get win ticket by rspfn_ticket
    int32 (*gidb_fbs_wt_get_ticket)(GIDB_FBS_WT_HANDLE *self, uint64 unique_tsn, GIDB_FBS_WT_REC *pWTicket);
    int32 (*gidb_fbs_wt_get_ticket_sum)(GIDB_FBS_WT_HANDLE *self,
            uint64 unique_tsn,
            int64 *winning_amount_tax,
            int64 *winning_amount,
            int64 *tax_amount,
            int32 *winning_count);
};
typedef map<uint64, GIDB_FBS_WT_HANDLE*> FBS_WT_MAP;

//通过期次序号得到期次handle
GIDB_FBS_WT_HANDLE * gidb_fbs_wt_get_handle(uint8 game_code, uint32 issue_number);

//关闭指定的handle
int32 gidb_fbs_wt_close_handle(GIDB_FBS_WT_HANDLE *handle);
//关闭长时间未使用的handle
int gidb_fbs_wt_clean_handle();
//关闭所有打开的handle
int gidb_fbs_wt_close_all_handle();

//FBS开奖过程中同步 win order 和  win ticket
int32 gidb_fbs_wt_sync_draw_ticket();


//同步FBS游戏的期数据到数据库文件(销售、兑奖、退票)
int32 gidb_fbs_sync_spc_ticket();


// draw  log  define -------------------------------------------------------

//------------------------------
// issue & match draw log Interface
//------------------------------
struct _GIDB_FBS_DL_HANDLE;
typedef struct _GIDB_FBS_DL_HANDLE GIDB_FBS_DL_HANDLE;
struct _GIDB_FBS_DL_HANDLE {
    uint8 game_code;
    sqlite3 *db;

    int32 (*gidb_fbs_dl_append)(GIDB_FBS_DL_HANDLE *self, uint32 issue_number, uint32 match_code, int32 msg_type, char *msg, int32 msg_len);
    int32 (*gidb_fbs_dl_get_last)(GIDB_FBS_DL_HANDLE *self, uint32 *msgid, uint8 *msg_type, char *msg, uint32 *msg_len);
    int32 (*gidb_fbs_dl_confirm)(GIDB_FBS_DL_HANDLE *self, uint32 msgid, uint32 flag);
    int32 (*gidb_fbs_dl_get_rec)(GIDB_FBS_DL_HANDLE *self, uint32 issue_number, uint32 match_code, int32 msg_type);
};

//获取期次访问的操作接口
GIDB_FBS_DL_HANDLE * gidb_fbs_dl_get_handle(uint8 game_code);

//关闭指定的handle
int32 gidb_fbs_dl_close_handle(GIDB_FBS_DL_HANDLE *handle);

//关闭所有打开的handle
int gidb_fbs_dl_close_all_handle();

// draw meta data file structure define -------------------------------------------------------

//meta文件的内容结构
typedef struct _META_ST {
    uint64  last_file_offset; //上次处理完成的文件偏移
    uint32  last_draw_sequence; //最近一次开奖的顺号
    uint32  last_issue_number; //最近一次处理的期号(用于拆单)
    uint64  last_unique_tsn; //最近一次处理的销售票表的 最后一条unique_tsn

    // 以下字段保存最后一场比赛的开奖信息
    uint32  last_match_code; //最近一场开奖比赛的编号
    uint32  last_draw_time; //最近一次开奖完成的时间
    SUB_RESULT s_results[FBS_SUBTYPE_NUM]; //开奖场次的赛果信息
    uint8      match_result[8]; //比赛结果,数据格式定义参见  GLTP_MSG_O_FBS_DRAW_INPUT_RESULT_REQ的结构定义
} META_ST;

// 开奖使用的拆单二进制文件记录
enum {
    //拆单状态枚举值
    ORD_STATE_BET = 0,
    ORD_STATE_PASSED,
    ORD_STATE_NO_WIN,
    ORD_STATE_WIN,
    ORD_STATE_RETURN, //针对单关投注，发生比赛取消的情况
};
typedef struct _FBS_ORDER_REC {
    uint16    length;

    uint64    unique_tsn;
    uint16    ord_no;                          //拆单编号

    uint8     state;                           //状态 ( 0 投注  1 已过关  2 过关失败  3 全部过关  4 单关投注，比赛取消做退票处理)
    uint8     passed_match;                    //已过关比赛数目
    money_t   passed_amount;                   //过关后的金额，也是进入下一关的投注金额 ( 初始值为 初始投注金额 )
    uint32    win_bet_count;                   //中奖注数 (含倍投)
    uint32    win_match_code;                  //在哪一场比赛的开奖过程中中奖

    uint8     game_code;                       //游戏
    uint32    issue_number;                    //销售期号
    uint8     sub_type;                        //玩法
    uint8     bet_type;                        //过关方式(投注方式)
    money_t   bet_amount;                      //拆单投注金额
    uint32    bet_count;                       //拆单投注注数
    uint16    bet_times;                       //投注倍数

    uint8     match_count;
    FBS_BETM  match_array[];                   //比赛的投注信息
}FBS_ORDER_REC;




//开奖标记文件处理接口
//内容为2个uint32 的值 (uint32 match_code 和 uint32 state)
//第一个为 正在进行开奖的比赛编码  第二个为 开奖进行到哪一步( 1: 已录入开奖号码，正在算奖  2: 算奖完成，等待确认)
//int flag   0: 检查标记文件是否存在  1: 建立标记文件  2: 读取标记文件  3: 删除标记文件
uint64 fbs_draw_tag(char *filepath, uint32 match_code, uint32 state, int flag);

//meta 文件处理接口
int fbs_read_draw_meta_file(char *filepath, META_ST *meta_ptr);
int fbs_write_draw_meta_file(char *filepath, META_ST *meta_ptr);
int fbs_verify_draw_order_file(char *filepath);





//bind  GIDB_FBS_MATCH_INFO to sqlite3_stmt  for insert
int32 bind_fbs_match(GIDB_FBS_MATCH_INFO *pMatchRec, sqlite3_stmt* pStmt);

//bind  GIDB_FBS_ST_REC to sqlite3_stmt  for insert
int32 bind_fbs_st_ticket(GIDB_FBS_ST_REC *pSTicket, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len);
//bind  GIDB_FBS_PT_STRUCT to sqlite3_stmt  for update pay ticket
int32 bind_fbs_update_pay_ticket(GIDB_FBS_PT_STRUCT *pPTicket, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len);
//bind  GIDB_FBS_CT_STRUCT to sqlite3_stmt  for update cancel ticket
int32 bind_fbs_update_cancel_ticket(GIDB_FBS_CT_STRUCT *pCTicket, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len);
//bind  GIDB_FBS_WT_REC to sqlite3_stmt  for insert
int32 bind_fbs_return_ticket(GIDB_FBS_WT_REC *pWTicket, sqlite3_stmt* pStmt);
//bind  GIDB_FBS_WT_REC to sqlite3_stmt  for insert
int32 bind_fbs_win_ticket(GIDB_FBS_WT_REC *pWTicket, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len);
//bind  GIDB_FBS_WO_REC to sqlite3_stmt  for insert
int32 bind_fbs_win_order(GIDB_FBS_WO_REC *pWOrder, sqlite3_stmt* pStmt);

//从读到的一条比赛场次记录，构造 GIDB_FBS_MATCH_INFO 信息
int32 get_fbs_match_rec_from_stmt(GIDB_FBS_MATCH_INFO *pMatchRec, sqlite3_stmt* pStmt);

//从读到的一条sale ticket表记录，构造 GIDB_FBS_ST_REC 信息
int32 get_fbs_st_rec_from_stmt(GIDB_FBS_ST_REC *pSTicket, sqlite3_stmt* pStmt);
//从读到的一条win ticket表记录，构造 GIDB_FBS_WT_REC 信息
int32 get_fbs_wt_rec_from_stmt(GIDB_FBS_WT_REC *pWTicket, sqlite3_stmt* pStmt);
//从读到的一条win order表记录，构造 GIDB_FBS_WO_REC 信息
int32 get_fbs_wo_rec_from_stmt(GIDB_FBS_WO_REC *pWOrder, sqlite3_stmt* pStmt);

int32 fbs_sale_ticket_2_win_ticket_rec(GIDB_FBS_ST_REC *pSTicket, GIDB_FBS_WT_REC *pWTicket);
int32 fbs_order_rec_2_wo_rec(FBS_ORDER_REC *pOrder, GIDB_FBS_WO_REC *pWOrder, FBS_GT_GAME_PARAM *game);

int32 fbs_sell_inm_rec_2_db_tidx_rec(INM_MSG_FBS_SELL_TICKET *pInmMsg, GIDB_TICKET_IDX_REC *pTIdxRec);
int32 fbs_sell_inm_rec_2_db_ticket_rec(INM_MSG_FBS_SELL_TICKET *pInmMsg, GIDB_FBS_ST_REC *pSTicket);
int32 fbs_pay_inm_rec_2_db_ticket_rec(INM_MSG_FBS_PAY_TICKET *pInmMsg, GIDB_FBS_PT_STRUCT *pPTicket);
int32 fbs_cancel_inm_rec_2_db_ticket_rec(INM_MSG_FBS_CANCEL_TICKET *pInmMsg, GIDB_FBS_CT_STRUCT *pCTicket);

int32 O_fbs_pay_inm_rec_2_db_ticket_rec(INM_MSG_O_FBS_PAY_TICKET *pInmMsg, GIDB_FBS_PT_STRUCT *pPTicket);
int32 O_fbs_cancel_inm_rec_2_db_ticket_rec(INM_MSG_O_FBS_CANCEL_TICKET *pInmMsg, GIDB_FBS_CT_STRUCT *pCTicket);
    
int32 AP_fbs_pay_inm_rec_2_db_ticket_rec(INM_MSG_AP_PAY_TICKET *pInmMsg, GIDB_FBS_PT_STRUCT *pPTicket);
int gidb_fbs_save_game_param(uint8 game_code, uint32 issue_number);

//生成中奖明细文件
int32 gidb_fbs_generate_match_win_file(uint8 game_code, uint32 issue_number, uint32 match_code, uint8 draw_times, char *file);


#endif //GAME_ISSUE_FBS_H_INCLUDED

