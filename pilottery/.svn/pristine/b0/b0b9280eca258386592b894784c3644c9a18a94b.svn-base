#ifndef INM_MESSAGE_OMS_H_INCLUDED
#define INM_MESSAGE_OMS_H_INCLUDED



//指定按1字节对齐
#pragma pack (1)



typedef struct _INM_MSG_O_HEADER
{
    INM_MSG_HEADER   inm_header;

    uint64 token;
    uint32 sequence;//通信序列号

    char    data[];
}INM_MSG_O_HEADER;
#define INM_MSG_O_HEADER_LEN sizeof(INM_MSG_O_HEADER)


//------------------------------------------------------------------------------
// system 系统类
//------------------------------------------------------------------------------

//心跳 <INM_TYPE_O_HB>
typedef struct _INM_MSG_O_HB
{
    INM_MSG_O_HEADER header;
}INM_MSG_O_HB;

//ECHO <INM_TYPE_O_ECHO>
typedef struct _INM_MSG_O_ECHO {
    INM_MSG_O_HEADER  header;
    uint32            echo_len;
    char              echo_str[];
}INM_MSG_O_ECHO;

//查询主机运行状态 <INM_TYPE_O_INQUIRY_SYSTEM>
typedef struct _INM_MSG_O_INQUIRY_SYSTEM
{
    INM_MSG_O_HEADER  header;
    uint8             run_status;           //主机运行的状态
}INM_MSG_O_INQUIRY_SYSTEM;



//-------------------------------------------------------------
// GL 游戏类
//-------------------------------------------------------------



//----------------------------------------------------------
// issue 期次类
//----------------------------------------------------------

//OMS新增期次通知消息 <INM_TYPE_O_GL_ISSUE_ADD_NFY>
typedef struct _INM_MSG_O_GL_ISSUE_ADD_NFY {
    INM_MSG_O_HEADER  header;
    uint8             gameCode;
}INM_MSG_O_GL_ISSUE_ADD_NFY;

//游戏撤销期次 <INM_TYPE_O_GL_ISSUE_DEL>
typedef struct _INM_MSG_O_GL_ISSUE_DEL {
    INM_MSG_O_HEADER  header;
    uint8             gameCode;
    uint64            issueNumber;          //期号(撤销从这起开始的之后所有期次，包含此期次)
}INM_MSG_O_GL_ISSUE_DEL;


//-----------------------------------------------------------
// ticket 彩票类
//-----------------------------------------------------------

//彩票查询 <INM_TYPE_O_INQUIRY_TICKET>
//查票时，显示的中奖信息
typedef struct _GL_WIN_PRIZE_INFO
{
    uint8   prizeCode;                      //奖级编号
    char    prizeName[ENTRY_NAME_LEN];
    uint32  betCount;                       //中奖注数
    uint64  prizeAmount;                    //奖级金额
}GL_WIN_PRIZE_INFO;

typedef struct _INM_MSG_O_INQUIRY_TICKET
{
    INM_MSG_O_HEADER  header;

    char    rspfn_ticket[TSN_LENGTH];
    uint64  unique_tsn;

    //返回数据
    uint8   gameCode;
    char    gameName[MAX_GAME_NAME_LENGTH];

    uint8   from_sale;                      //票来源

    uint32  startIssueSerial;               //序号
    uint64  startIssueNumber;               //期号
    uint32  lastIssueSerial;                //序号
    uint64  lastIssueNumber;
    uint32  issueCount;

    money_t ticketAmount;

    uint8   isTrain;                        //是否培训模式: 否(0)/是(1)
    uint8   isCancel;                       //是否已退票  1=已退票
    uint8   isWin;                          //是否中奖 0=未开奖完成(包括多期票的所有期次), 1=未中奖, 2=中奖(所有期次开奖完成)
    uint8   isBigPrize;                     //是否是大奖

    money_t amountBeforeTax;                //中奖金额(税前)
    money_t taxAmount;                      //税金
    money_t amountAfterTax;                 //中奖金额税后

    uint64  sale_termCode;                  //销售此票的终端编码
    uint32  sale_tellerCode;                //销售此票的销售员编码
    uint32  sale_time;                      //销售时间

    uint8   isPayed;                        //是否已兑奖 0=未兑奖, 1=已兑奖
    uint64  pay_termCode;                   //兑奖此票的终端编码
    uint32  pay_tellerCode;                 //兑奖此票的销售员编码
    uint32  pay_time;                       //兑奖时间

    uint64  cancel_termCode;                //退票此票的终端编码
    uint32  cancel_tellerCode;              //退票此票的销售员编码
    uint32  cancel_time;                    //退票时间

    char    customName[ENTRY_NAME_LEN];     //兑奖用户姓名
    uint8   cardType;                       //证件类型
    char    cardCode[IDENTITY_CARD_LENGTH]; //证件号码

    uint16  betStringLen;                   //投注字符串长度
    char    betString[MAX_BET_STRING_LENGTH]; //投注字符串

    uint8   prizeCount;                     //中奖的奖级集合
    GL_WIN_PRIZE_INFO winprizes[];    
}INM_MSG_O_INQUIRY_TICKET;

//彩票兑奖 <INM_TYPE_O_PAY_TICKET>
typedef struct _INM_MSG_O_PAY_TICKET
{
    INM_MSG_O_HEADER  header;

    uint8    flag;  // 0: long tsn    1: short digit tsn

    char     reqfn_ticket_pay[TSN_LENGTH];  //兑奖交易请求流水号
    char     rspfn_ticket_pay[TSN_LENGTH];  //兑奖交易响应流水号
    uint64   unique_tsn_pay;

    char     rspfn_ticket[TSN_LENGTH];      //彩票交易流水号
    uint64   unique_tsn;
    char     reqfn_ticket[TSN_LENGTH];      //销售请求流水号

    uint64   issueNumber_pay;               //兑奖发生时的游戏期号

    uint8    gameCode;                      //游戏编码
    uint64   saleStartIssue;                //销售起始期号
    uint32   saleStartIssueSerial;          //销售起始期序号
    uint64   saleLastIssue;
    uint8    issueCount;                    //连续购买期数

    uint32   saleTime;                      //彩票销售时间

    money_t  ticketAmount;

    uint8    isTrain;                       //是否培训模式: 否(0)/是(1)

    uint8    isBigWinning;                  //是否是大奖
    money_t  winningAmountWithTax;          //中奖金额(税前)
    money_t  taxAmount;                     //税金
    money_t  winningAmount;                 //中奖金额税后

    int16    payCommissionRate;             //兑奖佣金返还比例
    money_t  commissionAmount;              //兑奖佣金返还金额

    uint16   totalBets;                     //总注数
    uint32   winningCount;                  //中奖总注数
    money_t  hd_winning;                    //高等奖兑奖金额
    uint32   hd_count;                      //高等奖兑奖注数
    money_t  ld_winning;                    //低等奖兑奖金额
    uint32   ld_count;                      //低等奖兑奖注数

    char     loyaltyNum[LOYALTY_CARD_LENGTH];       //会员卡号
    uint8    identityType;                          //证件类型
    char     identityNumber[IDENTITY_CARD_LENGTH];  //证件号码
    char     name[LOYALTY_CARD_LENGTH];             //姓名

    uint32   areaCode_pay;                  //中心兑奖区域编码
    money_t  availableCredit;               //账户余额

    //票信息
    uint64   saleAgencyCode;                        //售票站点编码
    uint16   betStringLen;                          //投注字符串长度
    char     betString[MAX_BET_STRING_LENGTH];      //投注字符串

    uint8         prizeCount;             //中奖奖等数目
    PRIZE_DETAIL  prizeDetail[];          //中奖明细
}INM_MSG_O_PAY_TICKET;


//退票 <INM_TYPE_O_CANCEL_TICKET>
typedef struct _INM_MSG_O_CANCEL_TICKET
{
    INM_MSG_O_HEADER  header;

    uint8    flag;  // 0: long tsn    1: short digit tsn

    char     reqfn_ticket_cancel[TSN_LENGTH];    //退票交易请求流水号
    char     rspfn_ticket_cancel[TSN_LENGTH];    //退票交易响应流水号
    uint64   unique_tsn_cancel;

    char     rspfn_ticket[TSN_LENGTH];           //彩票交易流水号
    uint64   unique_tsn;
    char     reqfn_ticket[TSN_LENGTH];           //销售请求流水号

    uint8    gameCode;                           //游戏编码
    uint64   saleStartIssue;                     //购买的起始期号    
    uint32   saleStartIssueSerial;               //购买的起始期次序号
    uint8    issueCount;                         //连续购买期数

    uint32   saleTime;                           //彩票销售时间

    uint8    isTrain;                            //是否培训模式: 否(0)/是(1)

    money_t  cancelAmount;                       //票面取消金额
    uint32   betCount;                           //票面投注数

    money_t  commissionAmount;                   //售票佣金返还金额

    uint32   areaCode_cancel;                    //中心退票区域编码
    money_t  availableCredit;                    //账户余额
    uint64   saleAgencyCode;                     //售票站点编码
    money_t  saleAgencyAvailableCredit;          //退票后，售票销售站的账户余额

    char     loyaltyNum[LOYALTY_CARD_LENGTH];    //会员卡号

    TICKET   ticket; //变长字段
}INM_MSG_O_CANCEL_TICKET;



//------------------------------------------------------------------------------
// FBS
//------------------------------------------------------------------------------

//查票时，显示的中奖拆单信息
typedef struct _GL_FBS_WIN_ORDER_INFO
{
    uint16    ord_no;                          //拆单编号
    money_t   winningAmountWithTax;            //中奖金额
    int32     winningCount;                    //中奖注数
    uint32    win_match_code;                  //在哪一场比赛的开奖过程中中奖
}GL_FBS_WIN_ORDER_INFO;

//彩票查询 <INM_TYPE_O_FBS_INQUIRY_TICKET>
typedef struct _INM_MSG_O_FBS_INQUIRY_TICKET
{
    INM_MSG_O_HEADER  header;

    char    rspfn_ticket[TSN_LENGTH];
    uint64  unique_tsn;

    uint8   from_sale;                      //票来源

    uint32  saleTime;                       //彩票销售时间
    uint8   gameCode;
    char    gameName[MAX_GAME_NAME_LENGTH];
    uint32  issue_number;                   //销售期号
    uint8   sub_type;                       //玩法
    uint8   bet_type;                       //过关方式(投注方式)
    money_t ticketAmount;                   //售票金额
    uint32  totalBets;                      //总注数
    uint16  matchCount;                     //选择的场次总数

    uint8   isTrain;                        //是否培训模式: 否(0)/是(1)
    uint8   isCancel;                       //是否已退票  1=已退票
    uint8   isWin;                          //是否中奖 0=未开奖完成(包括多期票的所有期次), 1=未中奖, 2=中奖(所有期次开奖完成)
    uint8   isBigPrize;                     //是否是大奖

    money_t amountBeforeTax;                //中奖金额(税前)
    money_t taxAmount;                      //税金
    money_t amountAfterTax;                 //中奖金额税后

    uint64  sale_termCode;                  //销售此票的终端编码
    uint32  sale_tellerCode;                //销售此票的销售员编码
    uint32  sale_time;                      //销售时间

    uint8   isPayed;                        //是否已兑奖 0=未兑奖, 1=已兑奖
    uint64  pay_termCode;                   //兑奖此票的终端编码
    uint32  pay_tellerCode;                 //兑奖此票的销售员编码
    uint32  pay_time;                       //兑奖时间

    uint64  cancel_termCode;                //退票此票的终端编码
    uint32  cancel_tellerCode;              //退票此票的销售员编码
    uint32  cancel_time;                    //退票时间

    char    customName[ENTRY_NAME_LEN];     //兑奖用户姓名
    uint8   cardType;                       //证件类型
    char    cardCode[IDENTITY_CARD_LENGTH]; //证件号码

    uint16  betStringLen;                   //投注字符串长度
    char    betString[MAX_BET_STRING_LENGTH]; //投注字符串

    uint32  matchCode[FBS_MAX_TICKET_MATCH];
}INM_MSG_O_FBS_INQUIRY_TICKET;

//彩票兑奖 <INM_TYPE_O_FBS_PAY_TICKET>
typedef struct _INM_MSG_O_FBS_PAY_TICKET
{
    INM_MSG_O_HEADER  header;

    char     reqfn_ticket_pay[TSN_LENGTH];  //兑奖交易请求流水号
    char     rspfn_ticket_pay[TSN_LENGTH];  //兑奖交易响应流水号
    uint64   unique_tsn_pay;

    char     rspfn_ticket[TSN_LENGTH];      //彩票交易流水号
    uint64   unique_tsn;
    char     reqfn_ticket[TSN_LENGTH];      //销售请求流水号

    uint32   issueNumber_pay;               //兑奖发生时的游戏期号

    uint8    from_sale;                     //票来源

    uint32   saleTime;                      //彩票销售时间
    uint8    gameCode;
    uint32   issueNumber;                   //销售期号
    uint8    subType;                       //玩法
    uint8    betType;                       //过关方式(投注方式)
    money_t  ticketAmount;                  //售票金额
    uint16   matchCount;                    //选择的场次总数

    uint8    isTrain;                       //是否培训模式: 否(0)/是(1)

    uint8    isBigWinning;                  //是否是大奖
    money_t  winningAmountWithTax;          //中奖金额(税前)
    money_t  taxAmount;                     //税金
    money_t  winningAmount;                 //中奖金额税后

    int16    payCommissionRate;             //兑奖佣金返还比例
    money_t  commissionAmount;              //兑奖佣金返还金额

    uint16   totalBets;                     //总注数
    uint32   winningCount;                  //中奖总注数

    uint8    claimingScope;                 //游戏兑奖范围, enum AREA_LEVEL

    char     loyaltyNum[LOYALTY_CARD_LENGTH];       //会员卡号
    uint8    identityType;                          //证件类型
    char     identityNumber[IDENTITY_CARD_LENGTH];  //证件号码
    char     name[LOYALTY_CARD_LENGTH];             //姓名

    uint32   agencyIdx;
    uint32   areaCode_pay;                  //中心兑奖区域编码
    money_t  availableCredit;               //账户余额

    //票信息
    uint64   saleAgencyCode;                        //售票站点编码
    uint16   betStringLen;                          //投注字符串长度
    char     betString[MAX_BET_STRING_LENGTH];      //投注字符串

    uint32  matchCode[FBS_MAX_TICKET_MATCH];

    uint16   orderCount;                     //拆单的数量
    GL_FBS_WIN_ORDER_INFO orderArray[];
}INM_MSG_O_FBS_PAY_TICKET;


//退票 <INM_TYPE_O_FBS_CANCEL_TICKET>
typedef struct _INM_MSG_O_FBS_CANCEL_TICKET
{
    INM_MSG_O_HEADER  header;

    char     reqfn_ticket_cancel[TSN_LENGTH];    //兑奖交易请求流水号
    char     rspfn_ticket_cancel[TSN_LENGTH];    //兑奖交易响应流水号
    uint64   unique_tsn_cancel;

    char     rspfn_ticket[TSN_LENGTH];           //彩票交易流水号
    uint64   unique_tsn;
    char     reqfn_ticket[TSN_LENGTH];           //销售请求流水号

    uint8    gameCode;                           //游戏编码
    uint32   issueNumber;                        //销售期号

    uint64   cancelAgencyCode;                   //退票请求站点编码
    uint32   saleTime;                           //彩票销售时间

    uint8    isTrain;                            //是否培训模式: 否(0)/是(1)

    money_t  cancelAmount;                       //票面取消金额
    uint32   betCount;                           //票面投注数

    int16    saleCommissionRate;                 //售票佣金返还比例
    money_t  commissionAmount;                   //售票佣金返还金额

    uint8    claimingScope;                      //游戏兑奖范围, enum AREA_LEVEL

    uint32   agencyIdx;
    uint32   areaCode_cancel;                    //中心退票区域编码
    money_t  availableCredit;                    //账户余额
    int32    saleAgencyIdx;                      //售票站点编码
    uint64   saleAgencyCode;                     //售票站点编码
    money_t  saleAgencyAvailableCredit;          //退票后，售票销售站的账户余额

    char     loyaltyNum[LOYALTY_CARD_LENGTH];    //会员卡号

    uint8    matchCount;
    uint32   matchCode[FBS_MAX_TICKET_MATCH];

    FBS_TICKET   ticket; //变长字段
}INM_MSG_O_FBS_CANCEL_TICKET;



//OMS新增比赛通知消息 <INM_TYPE_O_FBS_ADD_MATCH_NTY>
typedef struct _INM_MSG_O_FBS_ADD_MATCH_NFY {
    INM_MSG_O_HEADER  header;
    uint8             gameCode;
}INM_MSG_O_FBS_ADD_MATCH_NFY;

//游戏撤销期次 <INM_TYPE_O_FBS_DEL_MATCH>
typedef struct _INM_MSG_O_FBS_DEL_MATCH {
    INM_MSG_O_HEADER  header;
    uint8             gameCode;
    uint32            issueNumber;  //期号(日期 151025)
    uint32            matchCode; //删除此场比赛后的所有比赛 (比较比赛编码的大小)
}INM_MSG_O_FBS_DEL_MATCH;

//启用/停用比赛 <INM_TYPE_O_FBS_MATCH_STATUS_CTRL>
typedef struct _INM_MSG_O_FBS_MATCH_STATUS_CTRL {
    INM_MSG_O_HEADER  header;
    uint8             gameCode;
    uint32            issueNumber;  //期号(日期 151025)
    uint32            matchCode;
    uint8             status;
}INM_MSG_O_FBS_MATCH_STATUS_CTRL;

//修改比赛关闭时间 <INM_TYPE_O_FBS_MATCH_TIME>
typedef struct _INM_MSG_O_FBS_MATCH_TIME {
    INM_MSG_O_HEADER  header;
    uint8             gameCode;
    uint32            issueNumber;  //期号(日期 151025)
    uint32            matchCode;
    uint32            time;
}INM_MSG_O_FBS_MATCH_TIME;


//更新比赛的状态 <INM_TYPE_O_FBS_MATCH_OPEN>  <INM_TYPE_O_FBS_MATCH_CLOSE>
typedef struct _INM_MSG_O_FBS_MATCH_STATE {
    INM_MSG_O_HEADER  header;
    uint8             gameCode;
    uint32            issueNumber;  //期号(日期 151025)
    uint32            matchCode;
    uint8             state; //enum MATCH_STATE
}INM_MSG_O_FBS_MATCH_STATE;


//录入场次开奖结果 <INM_TYPE_O_FBS_DRAW_INPUT_RESULT>
typedef struct _INM_MSG_O_FBS_DRAW_INPUT_RESULT
{
    INM_MSG_O_HEADER header;

    uint8            gameCode;
    uint32           issueNumber;
    uint32           matchCode;
    uint8            drawResults[FBS_SUBTYPE_NUM]; //分玩法的开奖结果枚举值
    uint8            matchResult[8]; //比赛结果,数据格式定义参见  GLTP_MSG_O_FBS_DRAW_INPUT_RESULT_REQ的结构定义
                                     // matchResult[0]  ->  fht_win_result (上半场比赛结果  M_WIN_HOME->1, M_WIN_DRAW->2, M_WIN_AWAY->3)
                                     // matchResult[1]  ->  fht_home_goals (上半场主队进球数)
                                     // matchResult[2]  ->  fht_away_goals (上半场客队进球数)
                                     // matchResult[3]  ->  sht_win_result (下半场比赛结果  M_WIN_HOME->1, M_WIN_DRAW->2, M_WIN_AWAY->3)
                                     // matchResult[4]  ->  sht_home_goals (下半场主队进球数)
                                     // matchResult[5]  ->  sht_away_goals (下半场客队进球数)
                                     // matchResult[6]  ->  ft_win_result  (全场比赛结果    M_WIN_HOME->1, M_WIN_DRAW->2, M_WIN_AWAY->3)
                                     // matchResult[7]  ->  first_goal     (那个队伍先进球  M_TERM_HOME->1  or  M_TERM_AWAY->2)
}INM_MSG_O_FBS_DRAW_INPUT_RESULT;

//场次开奖结果确认 <INM_TYPE_O_FBS_DRAW_CONFIRM>
typedef struct _INM_MSG_O_FBS_DRAW_CONFIRM
{
    INM_MSG_O_HEADER header;

    uint8            gameCode;
    uint32           issueNumber;
    uint32           matchCode;
}INM_MSG_O_FBS_DRAW_CONFIRM;




//取消指定对齐，恢复缺省对齐
#pragma pack ()



#endif //INM_MESSAGE_OMS_H_INCLUDED



