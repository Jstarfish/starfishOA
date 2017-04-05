#ifndef GLTP_MESSAGE_TERMINAL_H_INCLUDED
#define GLTP_MESSAGE_TERMINAL_H_INCLUDED


//------------------------------------------------------------------------------
//终端机消息编码
//------------------------------------------------------------------------------
typedef enum _GLTP_MSG_TERMINAL_TYPE {
    //心跳
    GLTP_T_HB                       = 0,

    //ECHO
    GLTP_T_ECHO_REQ                 = 1,
    GLTP_T_ECHO_RSP                 = 2,

    //网络延时计量
    GLTP_T_NETWORK_DELAY_REQ        = 3,
    GLTP_T_NETWORK_DELAY_RSP        = 4,

    //认证
    GLTP_T_AUTH_REQ                 = 3001,
    GLTP_T_AUTH_RSP                 = 3002,

    //游戏信息请求
    GLTP_T_GAME_INFO_REQ            = 3003,
    GLTP_T_GAME_INFO_RSP            = 3004,

    //彩票销售
    GLTP_T_SELL_TICKET_REQ          = 3005,
    GLTP_T_SELL_TICKET_RSP          = 3006,

    //彩票查询
    GLTP_T_INQUIRY_TICKET_REQ       = 3007,
    GLTP_T_INQUIRY_TICKET_RSP       = 3008,

    //彩票兑奖
    GLTP_T_PAY_TICKET_REQ           = 3009,
    GLTP_T_PAY_TICKET_RSP           = 3010,

    //彩票取消
    GLTP_T_CANCEL_TICKET_REQ        = 3011,
    GLTP_T_CANCEL_TICKET_RSP        = 3012,

    //销售员登录
    GLTP_T_SIGNIN_REQ               = 3013,
    GLTP_T_SIGNIN_RSP               = 3014,

    //销售员签退
    GLTP_T_SIGNOUT_REQ              = 3015,
    GLTP_T_SIGNOUT_RSP              = 3016,

    //销售员修改密码
    GLTP_T_CHANGE_PWD_REQ           = 3017,
    GLTP_T_CHANGE_PWD_RSP           = 3018,

    //销售站余额查询
    GLTP_T_AGENCY_BALANCE_REQ       = 3019,
    GLTP_T_AGENCY_BALANCE_RSP       = 3020,

    //游戏当前期次信息查询
    GLTP_T_GAME_ISSUE_REQ           = 3023,
    GLTP_T_GAME_ISSUE_RSP           = 3024,

    //彩票中奖查询
    GLTP_T_INQUIRY_WIN_REQ          = 3025,
    GLTP_T_INQUIRY_WIN_RSP          = 3026,


    // FBS   比赛信息查询
    GLTP_FBS_INQUIRY_MATCH_REQ      = 3061,
    GLTP_FBS_INQUIRY_MATCH_RSP      = 3062,

}GLTP_MSG_TERMINAL_TYPE;


//------------------------------------------------------------------------------
//终端机广播消息码
//------------------------------------------------------------------------------
typedef enum _GLTP_MSG_TERMINAL_UNS_TYPE
{
    //打开游戏
    GLTP_T_UNS_OPEN_GAME            = 4001,

    //游戏关闭倒计时
    GLTP_T_UNS_CLOSE_SECONDS        = 4002,

    //关闭游戏
    GLTP_T_UNS_CLOSE_GAME           = 4003,

    //游戏开奖公告
    GLTP_T_UNS_DRAW_ANNOUNCE        = 4004,

    //终端机重置
    GLTP_T_UNS_RESET                = 4005,

    //通知消息
    GLTP_T_UNS_MESSAGE              = 4006,

}GLTP_MSG_TERMINAL_UNS_TYPE;



//指定按1字节对齐
#pragma pack (1)


typedef struct _GLTP_MSG_T_HEADER
{
    //GLTP_MSG_HEADER
    uint16  length;        //消息长度
    uint8   type;          //消息类型
    uint16  func;          //消息编码
    uint32  when;          //时间戳(秒数)

    uint64  token;
    uint32  identify;      //for ncp socket identify
    uint32  msn;           //传输序列号
    uint16  param;         //参数: 培训票(1)

    uint16  status;        //消息处理状态

    char data[];
}GLTP_MSG_T_HEADER;
#define GLTP_MSG_T_HEADER_LEN sizeof(GLTP_MSG_T_HEADER)


//------------------------------------------------------------------------------
//终端心跳请求/响应消息(0) <GLTP_T_HB>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_HB
{
    GLTP_MSG_T_HEADER  header;
    uint16  crc;
}GLTP_MSG_T_HB;


//------------------------------------------------------------------------------
//业务处理失败的通用响应消息
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_ERR_RSP
{
    GLTP_MSG_T_HEADER header;
    uint32  timeStamp;
    uint16  crc;
}GLTP_MSG_T_ERR_RSP;


//------------------------------------------------------------------------------
//ECHO请求/响应消息(1/2) <GLTP_T_ECHO_REQ/GLTP_T_ECHO_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_ECHO_REQ
{
    GLTP_MSG_T_HEADER header;
    uint32  echo_len;
    char    echo_str[];  //不可超过128字节
    //uint16  crc;
}GLTP_MSG_T_ECHO_REQ;

typedef struct _GLTP_MSG_T_ECHO_RSP
{
    GLTP_MSG_T_HEADER header;
    uint32  timeStamp;

    uint32  echo_len;
    char    echo_str[]; //reply -> Welcome, I'm TaiShan System. <echo_str>
    //uint16  crc;
}GLTP_MSG_T_ECHO_RSP;


//------------------------------------------------------------------------------
//网络延时计量请求/响应消息(3/4) <GLTP_T_NETWORK_DELAY_REQ/GLTP_T_NETWORK_DELAY_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_NETWORK_DELAY_REQ
{
    GLTP_MSG_T_HEADER header;
    uint32  delayMilliSeconds;  //终端收到上一个网络计时消息的延迟毫秒数(终端连接后第一个网络计时消息此字段填0)
    uint16  crc;
}GLTP_MSG_T_NETWORK_DELAY_REQ;

typedef struct _GLTP_MSG_T_NETWORK_DELAY_RSP
{
    GLTP_MSG_T_HEADER header;
    uint16  crc;
}GLTP_MSG_T_NETWORK_DELAY_RSP;


//------------------------------------------------------------------------------
//终端认证请求/响应消息(3001/3002) <GLTP_T_AUTH_REQ/GLTP_T_AUTH_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_AUTH_REQ
{
    GLTP_MSG_T_HEADER  header;
    uint8   mac[6];
    char    version[16]; //终端当前软件版本
    uint16  crc;
}GLTP_MSG_T_AUTH_REQ;

typedef struct _GLTP_MSG_T_AUTH_RSP
{
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    uint64  terminalCode; //终端编码
    uint64  agencyCode;   //站点编码
    uint16  areaCode;     //区域编码
    uint16  crc;
}GLTP_MSG_T_AUTH_RSP;


//------------------------------------------------------------------------------
//游戏信息请求/响应消息(3003/3004) <GLTP_T_GAME_INFO_REQ/GLTP_T_GAME_INFO_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_GAME_INFO_REQ
{
    GLTP_MSG_T_HEADER  header;

    uint16  crc;
}GLTP_MSG_T_GAME_INFO_REQ;

typedef struct _GAME_INFO
{
    uint8   gameCode;               //游戏编码
    char    singleAmount[256];      //单注投注金额字符串
    money_t maxAmountPerTicket;     //单票最大金额
    uint16  maxBetTimes;            //每投注行最大投注倍数
    uint8   maxIssueCount;          //单票可连续购买期数
    uint64  currentIssueNumber;     //当前期号
    uint32  currentIssueCloseTime;  //当前期关闭时间
}GAME_INFO;

typedef struct _GLTP_MSG_T_GAME_INFO_RSP
{
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    char    contactAddress[AGENCY_ADDRESS_LENGTH];     //站点联系地址
    char    contactPhone[24];                          //站点联系电话
    char    ticketSlogan[TICKET_SLOGAN_LENGTH];        //彩票票面宣传语

    uint8   gameCount;                                 //游戏个数
    GAME_INFO gameArray[];
    //uint16  crc;
}GLTP_MSG_T_GAME_INFO_RSP;


//------------------------------------------------------------------------------
//游戏当前期次信息请求/响应消息(3023/3024) <GLTP_T_GAME_ISSUE_REQ/GLTP_T_GAME_ISSUE_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_GAME_ISSUE_REQ
{
    GLTP_MSG_T_HEADER  header;

    uint8   gameCode;
    uint16  crc;
}GLTP_MSG_T_GAME_ISSUE_REQ;

typedef struct _GLTP_MSG_T_GAME_ISSUE_RSP
{
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    uint8   gameCode;          //游戏编码
    uint64  issueNumber;       //当前期号
    uint32  issueStartTime;    //期开始时间
    uint32  issueLength;       //期长
    uint32  countDownSeconds;  //期关闭倒计时秒数
    uint16  crc;
}GLTP_MSG_T_GAME_ISSUE_RSP;


//------------------------------------------------------------------------------
//彩票销售请求/响应消息(3005/3006) <GLTP_T_SELL_TICKET_REQ/GLTP_T_SELL_TICKET_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_SELL_TICKET_REQ
{
    GLTP_MSG_T_HEADER  header;

    char    loyaltyNum[LOYALTY_CARD_LENGTH];  //会员卡号

    uint16  betStringLen;                     //投注字符串长度
    char    betString[];                      //投注字符串

    //uint16  crc;
}GLTP_MSG_T_SELL_TICKET_REQ;

typedef struct _GLTP_MSG_T_SELL_TICKET_RSP
{
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    char    rspfn_ticket[TSN_LENGTH];   //售票响应交易流水号

    money_t availableCredit;            //可销售余额(包括信用额度和临时信用额度)

    uint8   gameCode;
    uint64  currentIssueNumber;         //交易当前的期号
    uint64  flowNumber;                 //终端交易业务序号
    uint32  transTimeStamp;             //交易时间
    money_t transAmount;                //交易金额
    uint32  drawTimeStamp;              //开奖时间
    uint16  crc;
}GLTP_MSG_T_SELL_TICKET_RSP;


//------------------------------------------------------------------------------
//彩票查询请求/响应消息(3007/3008) <GLTP_T_INQUIRY_TICKET_REQ/GLTP_T_INQUIRY_TICKET_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_INQUIRY_TICKET_REQ {
    GLTP_MSG_T_HEADER  header;

    char    rspfn_ticket[TSN_LENGTH];
    uint16  crc;
}GLTP_MSG_T_INQUIRY_TICKET_REQ;

typedef struct _GLTP_MSG_T_INQUIRY_TICKET_RSP {
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    char    rspfn_ticket[TSN_LENGTH];   //票号

    uint8   gameCode;                   //游戏编码

    uint16  betStringLen;               //投注字符串长度
    char    betString[];                //投注字符串
    //uint16  crc;
}GLTP_MSG_T_INQUIRY_TICKET_RSP;


//------------------------------------------------------------------------------
//彩票兑奖请求/响应消息(3009/3010) <GLTP_T_PAY_TICKET_REQ/GLTP_T_PAY_TICKET_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_PAY_TICKET_REQ {
    GLTP_MSG_T_HEADER  header;

    char    rspfn_ticket[TSN_LENGTH];               //交易流水号

    char    loyaltyNum[LOYALTY_CARD_LENGTH];        //会员卡号
    char    identityNumber[IDENTITY_CARD_LENGTH];   //身份证号码
    uint16  crc;
}GLTP_MSG_T_PAY_TICKET_REQ;

typedef struct _GLTP_MSG_T_PAY_TICKET_RSP {
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    char    rspfn_ticket_pay[TSN_LENGTH]; //兑奖响应交易流水号
    char    rspfn_ticket[TSN_LENGTH];     //票号

    money_t availableCredit;              //可销售余额(包括信用额度和临时信用额度)

    uint8   gameCode;
    uint64  flowNumber;                   //终端交易业务序号
    money_t winningAmountWithTax;         //中奖金额(税前)
    money_t taxAmount;                    //税金
    money_t winningAmount;                //中奖金额税后
    uint32  transTimeStamp;               //交易时间

    uint16  crc;
}GLTP_MSG_T_PAY_TICKET_RSP;


//------------------------------------------------------------------------------
//彩票取消请求/响应消息(3011/3012) <GLTP_T_CANCEL_TICKET_REQ/GLTP_T_CANCEL_TICKET_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_CANCEL_TICKET_REQ {
    GLTP_MSG_T_HEADER  header;

    char    rspfn_ticket[TSN_LENGTH];         //交易流水号

    char    loyaltyNum[LOYALTY_CARD_LENGTH];  //会员卡号
    uint16  crc;
}GLTP_MSG_T_CANCEL_TICKET_REQ;

typedef struct _GLTP_MSG_T_CANCEL_TICKET_RSP {
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    char    rspfn_ticket_cancel[TSN_LENGTH]; //退票响应交易流水号
    char    rspfn_ticket[TSN_LENGTH];        //票号

    money_t availableCredit;                 //可销售余额(包括信用额度和临时信用额度)

    uint8   gameCode;
    uint64  flowNumber;                      //终端交易业务序号
    uint32  transTimeStamp;                  //交易时间
    money_t cancelAmount;                    //取消金额
    uint16  crc;
}GLTP_MSG_T_CANCEL_TICKET_RSP;


//------------------------------------------------------------------------------
//销售员登录请求/响应消息(3013/3014) <GLTP_T_SIGNIN_REQ/GLTP_T_SIGNIN_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_SIGNIN_REQ
{
    GLTP_MSG_T_HEADER  header;

    uint32  tellerCode;               //销售员编码
    char    password[PWD_MD5_LENGTH]; //销售员密码
    uint16  crc;
}GLTP_MSG_T_SIGNIN_REQ;

typedef struct _GLTP_MSG_T_SIGNIN_RSP
{
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    uint32  tellerCode;             //销售员编码
    uint8   tellerType;             //销售员类型
    money_t availableCredit;        //可销售余额(包括信用额度和临时信用额度)
    uint8   forceModifyPwd;         //强制修改密码标记
    uint64  flowNumber;             //终端交易业务序号
    uint32  exchangeRate;           //汇率(瑞尔对美元)
    uint16  crc;
}GLTP_MSG_T_SIGNIN_RSP;


//------------------------------------------------------------------------------
//销售员签退请求/响应消息(3015/3016) <GLTP_T_SIGNOUT_REQ/GLTP_T_SIGNOUT_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_SIGNOUT_REQ
{
    GLTP_MSG_T_HEADER  header;

    uint32  tellerCode;             //销售员编码
    uint8   type;                   //签退类型 正常0 或 强制1
    uint16  crc;
}GLTP_MSG_T_SIGNOUT_REQ;

typedef struct _GLTP_MSG_T_SIGNOUT_RSP
{
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    uint16  crc;
}GLTP_MSG_T_SIGNOUT_RSP;


//------------------------------------------------------------------------------
//销售员修改密码请求/响应消息(3017/3018) <GLTP_T_CHANGE_PWD_REQ/GLTP_T_CHANGE_PWD_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_CHANGE_PWD_REQ {
    GLTP_MSG_T_HEADER  header;

    uint32  tellerCode;                  //销售员编码
    char    oldPassword[PWD_MD5_LENGTH]; //销售员原密码
    char    newPassword[PWD_MD5_LENGTH]; //销售员新密码
    uint16  crc;
}GLTP_MSG_T_CHANGE_PWD_REQ;

typedef struct _GLTP_MSG_T_CHANGE_PWD_RSP {
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    uint16  crc;
}GLTP_MSG_T_CHANGE_PWD_RSP;


//------------------------------------------------------------------------------
//销售站余额查询请求/响应消息(3019/3020) <GLTP_T_AGENCY_BALANCE_REQ/GLTP_T_AGENCY_BALANCE_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_AGENCY_BALANCE_REQ {
    GLTP_MSG_T_HEADER  header;

    uint16  crc;
}GLTP_MSG_T_AGENCY_BALANCE_REQ;

typedef struct _GLTP_MSG_T_AGENCY_BALANCE_RSP {
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    uint64  agencyCode;             //销售站编码

    money_t availableCredit;        //可销售余额(账户余额 + 信用额度)
    money_t accountBalance;         //账户余额
    money_t marginalCreditLimit;    //信用额度
    uint16  crc;
}GLTP_MSG_T_AGENCY_BALANCE_RSP;


//------------------------------------------------------------------------------
//彩票中奖查询请求/响应消息(3025/3026) <GLTP_T_INQUIRY_WIN_REQ/GLTP_T_INQUIRY_WIN_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_INQUIRY_WIN_REQ {
    GLTP_MSG_T_HEADER  header;

    char    rspfn_ticket[TSN_LENGTH];
    uint16  crc;
}GLTP_MSG_T_INQUIRY_WIN_REQ;

typedef struct _GLTP_MSG_T_INQUIRY_WIN_RSP {
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    char    rspfn_ticket[TSN_LENGTH];

    uint8   gameCode;                       //游戏编码

    uint8   isBigPrize;                     //是否是大奖

    uint64  amountBeforeTax;                //中奖金额(税前)
    uint64  taxAmount;                      //税金
    uint64  amountAfterTax;                 //中奖金额(税后)

    uint8   isPayed;                        //是否已兑奖:未兑奖(0) 已兑奖(1)
    uint16  crc;
}GLTP_MSG_T_INQUIRY_WIN_RSP;




//------------------------------------------------------------------------------
// FBS 比赛场次信息查询请求/响应消息(3061/3062) <GLTP_FBS_INQUIRY_MATCH_REQ/GLTP_FBS_INQUIRY_MATCH_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_FBS_MATCH_INFO_REQ
{
    GLTP_MSG_T_HEADER  header;

    uint8 gameCode;
    uint16  crc;
}GLTP_MSG_T_FBS_MATCH_INFO_REQ;

typedef struct _FBS_MATCH_INFO
{
    uint32 match_code; //match code  全局唯一 150930999
    uint32 seq; //match sequence number in one issue  在一期里面唯一
    //uint8  status; // enabled or disabled
    uint8  subtype_status[FBS_SUBTYPE_NUM]; //针对这场比赛是否启用这个玩法 value 0,1
    uint32 competition;
    uint32 round; //联赛第几轮
    uint16    home_code;
    //char   home_term[256]; //主队名称
    uint16    away_code;
    //char   away_term[256]; //客队名称
    uint32 date; //比赛日期 20130312
    //char   venue[256]; //match address 比赛地点
    uint32 match_time; //match start time 比赛时间
    //time_t result_time; //get result time 得到比赛结果时间
    //time_t draw_time; //draw complete time 比赛开奖完成时间

    uint32 sale_time; //begin sale time 开始销售时间
    uint32 close_time; //stop sale time 截止销售时间

    uint32 state; //比赛状态  (MATCH_STATE)

    //mathc home team handicap result sets
    int32  home_handicap; //胜平负 (主队让球数) 正数为主队让球数 负数为客队让球数
    int32  home_handicap_point5; //胜负 (主队让球数 0.5 1.5 2.5 -0.5 -1.5 -2.5) 正数为主队让球数 负数为客队让球数   (这个数 除以 10 才是实际值)
}FBS_MATCH_INFO;


typedef struct _GLTP_MSG_T_FBS_MATCH_INFO_RSP
{
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    uint8 gameCode;
    uint16   matchCount;              //场次个数
    FBS_MATCH_INFO fbsMatch[];//FBS_MAX_TICKET_MATCH
    //uint16  crc;
}GLTP_MSG_T_FBS_MATCH_INFO_RSP;




//------------------------------------------------------------------------------
// 以下为终端广播消息
//------------------------------------------------------------------------------

//游戏开启(4001) <GLTP_T_UNS_OPEN_GAME>
typedef struct _GLTP_MSG_T_OPEN_GAME_UNS {
    GLTP_MSG_T_HEADER  header;

    uint8   gameCode;               //游戏编码
    uint64  issueNumber;            //期号
    uint32  issueTimeStamp;         //期次开启时间
    uint32  issueTimeSpan;          //期长(秒数)
    uint32  countDownSeconds;       //期关闭倒计时秒数
    uint16  crc;
}GLTP_MSG_T_OPEN_GAME_UNS;


//游戏即将关闭(4002) <GLTP_T_UNS_CLOSE_SECONDS>
/*
typedef struct _GLTP_MSG_T_CLOSE_SECONDS_UNS {
    GLTP_MSG_T_HEADER  header;

    uint8   gameCode;               //游戏编码
    uint64  issueNumber;            //期号
    uint32  issueTimeStamp;         //期次即将关闭时间
    uint32  closeCountDownSecond;   //秒数
    uint16  crc;
}GLTP_MSG_T_CLOSE_SECONDS_UNS;
*/

//游戏关闭(4003) <GLTP_T_UNS_CLOSE_GAME>
typedef struct _GLTP_MSG_T_CLOSE_GAME_UNS {
    GLTP_MSG_T_HEADER  header;

    uint8   gameCode;               //游戏编码
    uint64  issueNumber;            //期号
    uint32  issueTimeStamp;         //期次关闭时间
    uint16  crc;
}GLTP_MSG_T_CLOSE_GAME_UNS;


//游戏开奖公告结果(4004) <GLTP_T_UNS_DRAW_ANNOUNCE>
typedef struct _GLTP_MSG_T_DRAW_ANNOUNCE_UNS {
    GLTP_MSG_T_HEADER  header;

    uint8   gameCode;               //游戏编码
    uint64  issueNumber;            //期号
    uint32  issueTimeStamp;         //期次开奖公告时间
    uint16  drawCodeLen;            //开奖号码字符串长度
    uint16  drawAnnounceLen;        //开奖公告字符串长度
    char    drawCode[];             //游戏号码开奖结果
    //char    drawAnnounce[];       //游戏开奖公告结果
    //uint16  crc;
}GLTP_MSG_T_DRAW_ANNOUNCE_UNS;


//终端机重置(4005) <GLTP_T_UNS_RESET>
typedef struct _GLTP_MSG_T_RESET_UNS {
    GLTP_MSG_T_HEADER  header;

    uint8  ctrlLevel;           // 0:全国 1:省 2:市 3:销售站 4:终端机
    uint64 ctrlCode;            // 若ctrlLevel为1，则为两位数省代码
                                // 若ctrlLevel为2，则为四位数省市代码
                                // 若ctrlLevel为3，则为十位数省市销售站代码
                                // 若ctrlLevel为0或4(即广播和单播)，则此值无意义
    uint16  crc;
}GLTP_MSG_T_RESET_UNS;

//终端机通知消息(4006) <GLTP_T_UNS_MESSAGE>
typedef struct _GLTP_MSG_T_MESSAGE_UNS {
    GLTP_MSG_T_HEADER  header;

    uint8  ctrlLevel;           // 0:全国 1:省 2:市 3:销售站 4:终端机
    uint64 ctrlCode;            // 若ctrlLevel为1，则为两位数省代码
                                // 若ctrlLevel为2，则为四位数省市代码
                                // 若ctrlLevel为3，则为十位数省市销售站代码
                                // 若ctrlLevel为0或4(即广播和单播)，则此值无意义
    uint32 createTime;
    uint32 sendTime;
    uint8  who;                 //设备目标(0:终端机 1:TDS)
    uint8  flag;                // 1: 显示十秒  0：一直显示
    uint16 length;
    char   message[];
    //uint16  crc;
}GLTP_MSG_T_MESSAGE_UNS;



//取消指定对齐，恢复缺省对齐
#pragma pack ()



#endif //GLTP_MESSAGE_TERMINAL_H_INCLUDED


