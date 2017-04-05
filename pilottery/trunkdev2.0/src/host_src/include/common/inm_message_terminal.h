#ifndef INM_MESSAGE_TERMINAL_H_INCLUDED
#define INM_MESSAGE_TERMINAL_H_INCLUDED



//指定按1字节对齐
#pragma pack (1)


typedef struct _INM_MSG_T_HEADER {
    INM_MSG_HEADER   inm_header;

    uint32  cid;            //终端index
    uint64  token;

    uint32  areaCode;       //所属区域编码
    uint64  agencyCode;     //销售站唯一编码
    uint64  terminalCode;   //终端机唯一编码
    uint32  tellerCode;     //Teller唯一编码

    uint32  ncpIdentify;    //for ncp socket identify

    uint32  msn;            //传输序列号
    uint16  reqParam;       //参数  / 复用 ap param

    char    data[];
}INM_MSG_T_HEADER;
#define INM_MSG_T_HEADER_LEN sizeof(INM_MSG_T_HEADER)



// Terminal ----------------------------------------------------------------------------------

//RETRY消息处理
typedef struct _INM_MSG_T_RETRY
{
    INM_MSG_T_HEADER header;
    uint32                  gltp_msg_len;
    char                    gltp_msg[];
}INM_MSG_T_RETRY;

//echo message
typedef struct _INM_MSG_T_ECHO
{
    INM_MSG_T_HEADER header;
    uint32                  echo_len;
    char                    echo_str[];
}INM_MSG_T_ECHO;

//终端认证----------------------------------------------------------------
typedef struct _INM_MSG_T_AUTH
{
    INM_MSG_T_HEADER  header;
    uint8   mac[6];
    char    version[16]; //终端当前软件版本
}INM_MSG_T_AUTH;

//销售员登录------------------------------------------------
typedef struct _INM_MSG_T_SIGNIN
{
    INM_MSG_T_HEADER header;

    char                    password[PWD_MD5_LENGTH+1];
    uint8                   tellerType;             //Teller类型
    money_t                 availableCredit;        //账户余额
    uint8					forceModifyPwd;		    //强制修改密码标记
    uint64                  nextFlowNumber;         //下一笔交易流水号
    uint32                  loginTime;
}INM_MSG_T_SIGNIN;


//销售员签退-------------------------------------------------
typedef struct _INM_MSG_T_SIGNOUT
{
    INM_MSG_T_HEADER header;

    uint32                  logoutTime;

}INM_MSG_T_SIGNOUT;


//销售员修改密码------------------------------------------------
typedef struct _INM_MSG_T_CHANGE_PWD
{
    INM_MSG_T_HEADER header;

    char                    newPassword[PWD_MD5_LENGTH+1];
    char                    oldPassword[PWD_MD5_LENGTH+1];
    uint32                  changeTime;
}INM_MSG_T_CHANGE_PWD;


//彩票查询请求
typedef struct _INM_MSG_T_INQUIRY_TICKET
{
    INM_MSG_T_HEADER header;

    char                    reqfn_ticket[TSN_LENGTH]; //售票请求的TSN
    char                    rspfn_ticket[TSN_LENGTH]; //售票响应的TSN
    uint64                  unique_tsn;

    uint8                   gameCode;               //游戏编码
    uint64                  saleStartIssue;         //销售期号
    uint64                  saleLastIssue;          //销售最后一期期号

    uint16                  betStringLen;           //投注字符串长度
    char                    betString[];            //投注字符串
}INM_MSG_T_INQUIRY_TICKET;


//彩票中奖查询请求
typedef struct _INM_MSG_T_INQUIRY_WIN
{
    INM_MSG_T_HEADER header;

    char                    rspfn_ticket[TSN_LENGTH]; //售票响应的TSN
    uint64                  unique_tsn;

    uint8                   gameCode;               //游戏编码
    uint64                  saleStartIssue;         //销售期号
    uint64                  saleLastIssue;          //销售最后一期期号

    uint8                   isBigPrize;             //是否是大奖

    uint64                  amountBeforeTax;        //中奖金额(税前)
    uint64                  taxAmount;              //税金
    uint64                  amountAfterTax;         //中奖金额(税后)

    uint8                   isPayed;                //是否已兑奖:未兑奖(0) 已兑奖(1)

    uint8                   matchCount;                  //FBS
    uint32                  matchCode[FBS_MAX_TICKET_MATCH];    //FBS
}INM_MSG_T_INQUIRY_WIN;


//游戏信息请求------------------------------------------------
typedef struct _INM_MSG_T_GAME_INFO
{
    INM_MSG_T_HEADER header;

    char    contactAddress[AGENCY_ADDRESS_LENGTH+1];//站点联系地址
    char    contactPhone[LOYALTY_CARD_LENGTH+1];    //站点联系电话
    char    ticketSlogan[TICKET_SLOGAN_LENGTH+1];   //彩票票面宣传语

    uint8                   gameCount;              //游戏个数
    GAME_INFO               gameArray[];
}INM_MSG_T_GAME_INFO;


//销售彩票
typedef struct _INM_MSG_T_SELL_TICKET
{
    INM_MSG_T_HEADER        header;

    char                    reqfn_ticket[TSN_LENGTH];    //用于售票的唯一请求交易流水号
    char                    rspfn_ticket[TSN_LENGTH];    //用于售票的唯一响应交易流水号
    uint64                  unique_tsn;

    uint64                  issueNumber; //销售时的期号

    money_t                 commissionAmount; //售票佣金返还金额
    char                    loyaltyNum[LOYALTY_CARD_LENGTH+1]; //会员卡号

    money_t                 availableCredit;        //账户余额

    uint32                  drawTimeStamp;          //最后一期开奖时间

    uint64                  flowNumber; //终端业务流水序号

    TICKET                  ticket; //变长字段
}INM_MSG_T_SELL_TICKET;


//兑奖
typedef struct _INM_MSG_T_PAY_TICKET
{
    INM_MSG_T_HEADER        header;

    char                    reqfn_ticket_pay[TSN_LENGTH];    //兑奖交易请求流水号
    char                    rspfn_ticket_pay[TSN_LENGTH];    //兑奖交易响应流水号
    uint64                  unique_tsn_pay;

    char                    reqfn_ticket[TSN_LENGTH];        //彩票交易请求流水号
    char                    rspfn_ticket[TSN_LENGTH];        //彩票交易响应流水号
    uint64                  unique_tsn;

    uint64                  issueNumber_pay;                 //兑奖发生时的游戏期号

    uint8                   gameCode;               //游戏编码
    uint64                  saleStartIssue;         //销售起始期号
    uint32                  saleStartIssueSerial;   //销售起始期序号
    uint8                   issueCount;             //连续购买期数
    uint64                  saleLastIssue;          //销售的最后一期期号
    uint32                  saleLastIssueSerial;    //销售的最后一期序号
    money_t                 ticketAmount;           //票面金额

    uint8                   isTrain;                //是否培训模式: 否(0)/是(1)

    uint8                   isBigWinning;           //是否是大奖
    money_t                 winningAmountWithTax;   //中奖金额(税前)
    money_t                 taxAmount;              //税金
    money_t                 winningAmount;          //中奖金额税后

    money_t                 commissionAmount;       //兑奖佣金返还金额

    uint32                  winningCount;           //中奖总注数
    money_t                 hd_winning;             //高等奖中奖金额
    uint32                  hd_count;               //高等奖中奖注数
    money_t                 ld_winning;             //低等奖中奖金额
    uint32                  ld_count;               //低等奖中奖注数

    uint8                   claimingScope;          //游戏兑奖范围, enum AREA_LEVEL

    uint64                  flowNumber;             //终端业务流水序号
    uint64                  saleAgencyCode;

    char                    loyaltyNum[LOYALTY_CARD_LENGTH+1];       //会员卡号
    uint8                   identityType;                          //证件类型
    char                    identityNumber[IDENTITY_CARD_LENGTH+1];  //证件号码
    char                    name[ENTRY_NAME_LEN+1];                  //姓名

    money_t                 availableCredit;        //账户余额
}INM_MSG_T_PAY_TICKET;


//退票
typedef struct _INM_MSG_T_CANCEL_TICKET
{
    INM_MSG_T_HEADER        header;

    char                    reqfn_ticket_cancel[TSN_LENGTH]; //退票交易请求流水号
    char                    rspfn_ticket_cancel[TSN_LENGTH]; //退票交易响应流水号
    uint64                  unique_tsn_cancel;

    char                    reqfn_ticket[TSN_LENGTH];        //彩票交易请求流水号
    char                    rspfn_ticket[TSN_LENGTH];        //彩票交易响应流水号
    uint64                  unique_tsn;

    money_t                 commissionAmount;       //售票佣金返还金额

    uint64                  flowNumber;             //终端业务流水序号

    money_t                 availableCredit;        //账户余额(退票后的可销售余额)

    uint64                  saleAgencyCode;

    char                    loyaltyNum[LOYALTY_CARD_LENGTH+1];    //会员卡号

    TICKET                  ticket; //变长字段
}INM_MSG_T_CANCEL_TICKET;


//销售站账户余额查询响应消息---GLTP_T_AGENCY_BALANCE_RSP------------
typedef struct _INM_MSG_T_AGENCY_BALANCE {
    INM_MSG_T_HEADER  header;
    
	uint64  agencyCode;             //销售站编码

    money_t accountBalance;        //账户余额
    money_t marginalCreditLimit;   //信用额度
}INM_MSG_T_AGENCY_BALANCE;



// ------------------------------------------------------------------
// for 代理商
// ------------------------------------------------------------------

//期次查询消息 - INM_TYPE_T_INQUIRY_ISSUE
typedef struct _INM_MSG_T_INQUIRY_ISSUE
{
    INM_MSG_T_HEADER header;

    /*
    char                    reqfn_ticket[TSN_LENGTH];    //用于售票的唯一请求交易流水号
    char                    rspfn_ticket[TSN_LENGTH];    //用于售票的唯一响应交易流水号

    uint64                  issueNumber; //销售时的期号

    money_t                 availableCredit; //可销售余额 (不含本票产生的代销费金额)

    int16                   saleCommissionRate;     //售票佣金返还比例
    money_t                 commissionAmount;       //售票佣金返还金额

    uint32                  drawTimeStamp;          //最后一期开奖时间

    TICKET                  ticket; //变长字段
    */
}INM_MSG_T_INQUIRY_ISSUE;


//期次状态查询消息 - INM_TYPE_T_ISSUE_STATE
typedef struct _INM_MSG_T_ISSUE_STATE
{
    INM_MSG_T_HEADER header;

    /*
    char                    reqfn_ticket[TSN_LENGTH];    //用于售票的唯一请求交易流水号
    char                    rspfn_ticket[TSN_LENGTH];    //用于售票的唯一响应交易流水号

    uint64                  issueNumber; //销售时的期号

    money_t                 availableCredit; //可销售余额 (不含本票产生的代销费金额)

    int16                   saleCommissionRate;     //售票佣金返还比例
    money_t                 commissionAmount;       //售票佣金返还金额

    uint32                  drawTimeStamp;          //最后一期开奖时间

    TICKET                  ticket; //变长字段
    */
}INM_MSG_T_ISSUE_STATE;





// ------------------------------------------------------------------
// for FBS Sport
// ------------------------------------------------------------------

//期次场次信息查询请求 （返回比赛列表）------------------------------------------------
typedef struct _INM_MSG_FBS_MATCH_INFO
{
    INM_MSG_T_HEADER header;

    uint8   gameCode;
    uint16   matchCount;              //场次个数
    FBS_MATCH_INFO fbsMatch[];//FBS_MAX_TICKET_MATCH
}INM_MSG_FBS_MATCH_INFO;


//FBS销售彩票
typedef struct _INM_MSG_FBS_SELL_TICKET
{
    INM_MSG_T_HEADER        header;

    char                    reqfn_ticket[TSN_LENGTH];    //用于售票的唯一请求交易流水号
    char                    rspfn_ticket[TSN_LENGTH];    //用于售票的唯一响应交易流水号
    uint64                  unique_tsn;

    uint32                  issueNumber; //可销售期的最小期号  (注意 不是  场次所属期号)

    char                    loyaltyNum[LOYALTY_CARD_LENGTH+1]; //会员卡号

    money_t                 availableCredit;        //账户余额

    uint32                  drawTimeStamp;          //最后一期开奖时间

    uint64                  flowNumber; //终端业务流水序号

    uint16                  betStringLen; //包含最后的一个'\0'
    char                    betString[];//投注字符串
    //FBS_TICKET            ticket; //变长字段
}INM_MSG_FBS_SELL_TICKET;


//兑奖
typedef struct _INM_MSG_FBS_PAY_TICKET
{
    INM_MSG_T_HEADER        header;

    char                    reqfn_ticket_pay[TSN_LENGTH];    //兑奖交易请求流水号
    char                    rspfn_ticket_pay[TSN_LENGTH];    //兑奖交易响应流水号
    uint64                  unique_tsn_pay;

    char                    reqfn_ticket[TSN_LENGTH];        //彩票交易请求流水号
    char                    rspfn_ticket[TSN_LENGTH];        //彩票交易响应流水号
    uint64                  unique_tsn;

    uint64                  issueNumber_pay;        //兑奖发生时的游戏期号

    uint8                   gameCode;               //游戏编码
    uint32                  issueNumber;            //销售期号
    money_t                 ticketAmount;           //票面金额

    uint8                   isTrain;                //是否培训模式: 否(0)/是(1)

    uint8                   isBigWinning;           //是否是大奖
    money_t                 winningAmountWithTax;   //中奖金额(税前)
    money_t                 taxAmount;              //税金
    money_t                 winningAmount;          //中奖金额税后

    uint32                  winningCount;           //中奖总注数
    money_t                 hd_winning;             //高等奖中奖金额
    uint32                  hd_count;               //高等奖中奖注数
    money_t                 ld_winning;             //低等奖中奖金额
    uint32                  ld_count;               //低等奖中奖注数

    uint64                  flowNumber;             //终端业务流水序号
    uint64                  saleAgencyCode;

    char                    loyaltyNum[LOYALTY_CARD_LENGTH];       //会员卡号
    uint8                   identityType;                          //证件类型
    char                    identityNumber[IDENTITY_CARD_LENGTH];  //证件号码
    char                    name[ENTRY_NAME_LEN];                  //姓名

    money_t                 availableCredit;        //账户余额
    uint8                   matchCount;
    uint32                  matchCode[FBS_MAX_TICKET_MATCH];

}INM_MSG_FBS_PAY_TICKET;


//退票
typedef struct _INM_MSG_FBS_CANCEL_TICKET
{
    INM_MSG_T_HEADER        header;

    char                    reqfn_ticket_cancel[TSN_LENGTH]; //退票交易请求流水号
    char                    rspfn_ticket_cancel[TSN_LENGTH]; //退票交易响应流水号
    uint64                  unique_tsn_cancel;

    char                    reqfn_ticket[TSN_LENGTH];        //彩票交易请求流水号
    char                    rspfn_ticket[TSN_LENGTH];        //彩票交易响应流水号
    uint64                  unique_tsn;

    uint64                  flowNumber;             //终端业务流水序号

    money_t                 availableCredit;        //账户余额(退票后的可销售余额)

    uint64                  saleAgencyCode;

    char                    loyaltyNum[LOYALTY_CARD_LENGTH];    //会员卡号

    uint8                   matchCount;
    uint32                  matchCode[FBS_MAX_TICKET_MATCH];

    FBS_TICKET              ticket; //变长字段
}INM_MSG_FBS_CANCEL_TICKET;












//------------------------------------------------------------------------------------------------
// Terminal UNS Message
//------------------------------------------------------------------------------------------------

//游戏开启
typedef struct _INM_MSG_T_OPEN_GAME_UNS {
    INM_MSG_T_HEADER  header;

    uint8   gameCode;               //游戏编码
    uint64  issueNumber;            //期号
    uint32  issueTimeStamp;         //期次开启时间
    uint32  issueTimeSpan;          //期长（秒数）
    uint32  countDownSeconds;       //期关闭倒计时秒数
}INM_MSG_T_OPEN_GAME_UNS;


//游戏即将关闭
typedef struct _INM_MSG_T_CLOSE_SECONDS_UNS {
    INM_MSG_T_HEADER  header;

    uint8   gameCode;               //游戏编码
    uint64  issueNumber;            //期号
    uint32  issueTimeStamp;         //期次即将关闭时间
    uint32  closeCountDownSecond;   //秒数
}INM_MSG_T_CLOSE_SECONDS_UNS;


//游戏关闭
typedef struct _INM_MSG_T_CLOSE_GAME_UNS {
    INM_MSG_T_HEADER  header;

    uint8   gameCode;               //游戏编码
    uint64  issueNumber;            //期号
    uint32  issueTimeStamp;         //期次关闭时间
}INM_MSG_T_CLOSE_GAME_UNS;


//游戏开奖公告
typedef struct _INM_MSG_T_DRAW_ANNOUNCE_UNS {
    INM_MSG_T_HEADER  header;

    uint8   gameCode;                           //游戏编码
    uint64  issueNumber;                        //期号
    uint32  issueTimeStamp;                     //期次开奖公告时间
    uint16  drawCodeLen;                        //开奖号码字符串长度
    char    drawCode[MAX_GAME_RESULTS_STR_LEN]; //游戏开奖号码
    uint16  drawAnnounceLen;                    //开奖公告字符串长度
    char    drawAnnounce[];                     //游戏开奖公告结果
}INM_MSG_T_DRAW_ANNOUNCE_UNS;



//取消指定对齐，恢复缺省对齐
#pragma pack ()


#endif //INM_MESSAGE_TERMINAL_H_INCLUDED

