#ifndef GLTP_MESSAGE_OMS_H_INCLUDED
#define GLTP_MESSAGE_OMS_H_INCLUDED


//OMS专属响应状态码
typedef enum _OMS_RESULT_TYPE
{
    OMS_RESULT_SUCCESS                       = 0,   // 系统返回成功
    OMS_RESULT_FAILURE                       = 1,   // 系统返回失败

    OMS_RESULT_TICKET_NOT_FOUND_ERR          = 2,   // 查无此票
    OMS_RESULT_TICKET_TSN_ERR                = 3,   // TSN错误
    OMS_RESULT_BUSY_ERR                      = 4,   // 正在处理OMS消息中

    OMS_RESULT_GAME_DISABLE_ERR              = 5,   //游戏不可用
    OMS_RESULT_GAME_SERVICETIME_OUT_ERR      = 6,   //当前不是彩票交易时段

    OMS_RESULT_AGENCY_TYPE_ERR               = 7,   //销售站类型错误

    OMS_RESULT_PAY_DISABLE_ERR               = 8,   //游戏不可兑奖
    OMS_RESULT_PAY_PAYING_ERR                = 9,   //彩票正在兑奖中
    OMS_RESULT_PAY_NOT_DRAW_ERR              = 10,  //彩票期还没有开奖
    OMS_RESULT_PAY_WAIT_DRAW_ERR             = 11,  //彩票期等待开奖完成
    OMS_RESULT_PAY_DAYEND_ERR                = 12,  //兑奖日期已结止
    OMS_RESULT_PAY_TRAINING_TICKET_ERR       = 13,  //销售员兑培训票
    OMS_RESULT_PAY_NOT_WIN_ERR               = 14,  //彩票未中奖
    OMS_RESULT_PAY_MULTI_ISSUE_ERR           = 15,  //多期票未完结
    OMS_RESULT_PAY_PAID_ERR                  = 16,  //彩票已兑奖
    OMS_RESULT_PAY_MONEY_LIMIT_ERR           = 17,  //兑奖超出限额

    OMS_RESULT_CANCEL_DISABLE_ERR            = 18,  //游戏不可取消
    OMS_RESULT_CANCEL_AGAIN_ERR              = 19,  //彩票已退票
    OMS_RESULT_CANCEL_CANCELING_ERR          = 20,  //彩票退票中
    OMS_RESULT_CANCEL_ISSUE_ERR              = 21,  //退票期次类错误
    OMS_RESULT_CANCEL_TRAINING_TICKET_ERR    = 22,  //销售员退培训票
    OMS_RESULT_CANCEL_TIME_END_ERR           = 23,  //超过退票时间
    OMS_RESULT_CANCEL_MONEY_LIMIT_ERR        = 24,  //退票超出限额
    OMS_RESULT_CLAIMING_SCOPE_ERR            = 25,  //不符合兑奖范围
    OMS_RESULT_LACK_AMOUNT_ERR               = 26,  //销售站现金余额不足
    OMS_RESUTL_PAY_FORBID                    = 27,  //分中心不允许兑奖
    OMS_RESUTL_CANCEL_FORBID                 = 28,  //分中心不允许退票
    OMS_RESUTL_CANCEL_NOT_ACCEPT             = 29,  //场次已有关闭,不允许退票
}OMS_RESULT_TYPE;

//------------------------------------------------------------------------------
// OMS消息编码(填入GLTP消息头中的func字段)
//------------------------------------------------------------------------------
typedef enum _GLTP_MESSAGE_OMS_TYPE
{
    //心跳
    GLTP_O_HB                               = 0,

    //ECHO
    GLTP_O_ECHO_REQ                         = 1,
    GLTP_O_ECHO_RSP                         = 2,

    //系统类--------------------------------------------------------------------
    //查询系统运行状态
    GLTP_O_INQUIRY_SYSTEM_REQ               = 1001,
    GLTP_O_INQUIRY_SYSTEM_RSP               = 1002,

    //游戏类--------------------------------------------------------------------
    //修改游戏政策参数
    GLTP_O_GL_POLICY_PARAM_REQ              = 2001,
    GLTP_O_GL_POLICY_PARAM_RSP              = 2002,

    //修改游戏普通规则参数
    GLTP_O_GL_RULE_PARAM_REQ                = 2003,
    GLTP_O_GL_RULE_PARAM_RSP                = 2004,

    //修改游戏控制参数
    GLTP_O_GL_CTRL_PARAM_REQ                = 2005,
    GLTP_O_GL_CTRL_PARAM_RSP                = 2006,

    //修改游戏风险控制参数
    GLTP_O_GL_RISK_CTRL_PARAM_REQ           = 2009,
    GLTP_O_GL_RISK_CTRL_PARAM_RSP           = 2010,

    //游戏销售控制
    GLTP_O_GL_SALE_CTRL_REQ                 = 2011,
    GLTP_O_GL_SALE_CTRL_RSP                 = 2012,

    //游戏兑奖控制
    GLTP_O_GL_PAY_CTRL_REQ                  = 2013,
    GLTP_O_GL_PAY_CTRL_RSP                  = 2014,

    //游戏退票控制
    GLTP_O_GL_CANCEL_CTRL_REQ               = 2015,
    GLTP_O_GL_CANCEL_CTRL_RSP               = 2016,

    //游戏自动开奖控制
    GLTP_O_GL_AUTO_DRAW_REQ                 = 2017,
    GLTP_O_GL_AUTO_DRAW_RSP                 = 2018,

    //游戏服务时段设置
    GLTP_O_GL_SERVICE_TIME_REQ              = 2019,
    GLTP_O_GL_SERVICE_TIME_RSP              = 2020,

    //游戏告警阈值设置
    GLTP_O_GL_WARN_THRESHOLD_REQ            = 2021,
    GLTP_O_GL_WARN_THRESHOLD_RSP            = 2022,

    //期次类--------------------------------------------------------------------
    //撤销期次
    GLTP_O_GL_ISSUE_DELETE_REQ              = 3001,
    GLTP_O_GL_ISSUE_DELETE_RSP              = 3002,

    //期次重新开奖(二次开奖)
    GLTP_O_GL_ISSUE_SECOND_DRAW_REQ         = 3003,
    GLTP_O_GL_ISSUE_SECOND_DRAW_RSP         = 3004,

    //期结 -> 开奖号码录入
    GLTP_O_GL_ISSUE_INPUT_DRAW_RESULT_REQ   = 3005,
    GLTP_O_GL_ISSUE_INPUT_DRAW_RESULT_RSP   = 3006,

    //期结 -> 游戏奖池参数 (目前未实现)
    GLTP_O_GL_ISSUE_INPUT_POOL_REQ          = 3007,
    GLTP_O_GL_ISSUE_INPUT_POOL_RSP          = 3008,

    //期结 -> 奖级奖金录入
    GLTP_O_GL_ISSUE_INPUT_PRIZE_REQ         = 3009,
    GLTP_O_GL_ISSUE_INPUT_PRIZE_RSP         = 3010,

    //期结 -> 分发稽核数据摘要
    GLTP_O_GL_ISSUE_FILE_MD5SUM_REQ         = 3011,
    GLTP_O_GL_ISSUE_FILE_MD5SUM_RSP         = 3012,

    //期结 -> 开奖确认
    GLTP_O_GL_ISSUE_DRAW_CONFIRM_REQ        = 3013,
    GLTP_O_GL_ISSUE_DRAW_CONFIRM_RSP        = 3014,

    //期结 -> 重新开奖(放弃本次开奖流程，本期次需要重新开奖)
    GLTP_O_GL_ISSUE_REDO_DRAW_REQ           = 3015,
    GLTP_O_GL_ISSUE_REDO_DRAW_RSP           = 3016,

    //新增期次通知消息
    GLTP_O_GL_ISSUE_ADD_NFY_REQ             = 3017,
    GLTP_O_GL_ISSUE_ADD_NFY_RSP             = 3018,

    //彩票类--------------------------------------------------------------------
    //彩票查询
    GLTP_O_TICKET_INQUIRY_REQ               = 4001,
    GLTP_O_TICKET_INQUIRY_RSP               = 4002,
    //彩票兑奖
    GLTP_O_TICKET_PAY_REQ                   = 4003,
    GLTP_O_TICKET_PAY_RSP                   = 4004,
    //彩票退票
    GLTP_O_TICKET_CANCEL_REQ                = 4005,
    GLTP_O_TICKET_CANCEL_RSP                = 4006,

    //区域类--------------------------------------------------------------------
    //新增区域
    GLTP_O_AREA_ADD_REQ                     = 5001,
    GLTP_O_AREA_ADD_RSP                     = 5002,
    //修改区域
    GLTP_O_AREA_MDY_REQ                     = 5003,
    GLTP_O_AREA_MDY_RSP                     = 5004,
    //删除区域
    GLTP_O_AREA_DELETE_REQ                  = 5005,
    GLTP_O_AREA_DELETE_RSP                  = 5006,

    //区域销售站游戏授权
    GLTP_O_AREA_AGENCY_GAMECTRL_REQ         = 5007,
    GLTP_O_AREA_AGENCY_GAMECTRL_RSP         = 5008,
    //签退终端/销售员
    GLTP_O_AREA_RESET_REQ                   = 5009,
    GLTP_O_AREA_RESET_RSP                   = 5010,
    //区域游戏授权
    GLTP_O_AREA_GAME_REQ                    = 5011,
    GLTP_O_AREA_GAME_RSP                    = 5012,

    //销售站类-------------------------------------------------------------------
    //新增销售站
    GLTP_O_AGENCY_ADD_REQ                   = 6001,
    GLTP_O_AGENCY_ADD_RSP                   = 6002,
    //修改销售站
    GLTP_O_AGENCY_MDY_REQ                   = 6003,
    GLTP_O_AGENCY_MDY_RSP                   = 6004,
    //销售站状态控制
    GLTP_O_AGENCY_STATUS_CTRL_REQ           = 6005,
    GLTP_O_AGENCY_STATUS_CTRL_RSP           = 6006,
    //修改销售站信用额度
    GLTP_O_AGENCY_MARGINALCREDIT_REQ        = 6007,
    GLTP_O_AGENCY_MARGINALCREDIT_RSP        = 6008,
    //清退销售站
    GLTP_O_AGENCY_CLR_REQ                   = 6009,
    GLTP_O_AGENCY_CLR_RSP                   = 6010,

    //终端类--------------------------------------------------------------------
    //新增终端
    GLTP_O_TERM_ADD_REQ                     = 7001,
    GLTP_O_TERM_ADD_RSP                     = 7002,
    //修改终端
    GLTP_O_TERM_MDY_REQ                     = 7003,
    GLTP_O_TERM_MDY_RSP                     = 7004,
    //终端状态控制
    GLTP_O_TERM_STATUS_CTRL_REQ             = 7005,
    GLTP_O_TERM_STATUS_CTRL_RSP             = 7006,

    //销售员类-------------------------------------------------------------------
    //新增销售员
    GLTP_O_TELLER_ADD_REQ                   = 8001,
    GLTP_O_TELLER_ADD_RSP                   = 8002,
    //修改销售员
    GLTP_O_TELLER_MDY_REQ                   = 8003,
    GLTP_O_TELLER_MDY_RSP                   = 8004,
    //销售员状态控制
    GLTP_O_TELLER_STATUS_CTRL_REQ           = 8005,
    GLTP_O_TELLER_STATUS_CTRL_RSP           = 8006,
    //销售员密码重置
    GLTP_O_TELLER_RESET_PWD_REQ             = 8007,
    GLTP_O_TELLER_RESET_PWD_RSP             = 8008,

    //资金类--------------------------------------------------------------------
    //手工缴款
    //GLTP_O_AGNECY_DEPOSITAMOUNT_REQ         = 9001,
    //GLTP_O_AGNECY_DEPOSITAMOUNT_RSP         = 9002,

    //版本类--------------------------------------------------------------------
    //增加软件包
    GLTP_O_VERSION_ADD_REQ                  = 10001,
    GLTP_O_VERSION_ADD_RSP                  = 10002,
    //修改软件包
    GLTP_O_VERSION_MDY_REQ                  = 10003,
    GLTP_O_VERSION_MDY_RSP                  = 10004,
    //设置软件包状态
    GLTP_O_VERSION_STATUS_CTRL_REQ          = 10005,
    GLTP_O_VERSION_STATUS_CTRL_RSP          = 10006,

    //其他---------------------------------------------------------------------
    //区域发送通知消息
    GLTP_O_AREA_MESSAGE_REQ                 = 11001,
    GLTP_O_AREA_MESSAGE_RSP                 = 11002,
    //更新彩票票面标语
    GLTP_O_UPDATE_TICKET_SLOGAN_REQ         = 11003,
    GLTP_O_UPDATE_TICKET_SLOGAN_RSP         = 11004,
    //TMS阀值设定
    GLTP_O_UPDATE_TMS_LIMITS_REQ            = 11005,
    GLTP_O_UPDATE_TMS_LIMITS_RSP            = 11006,


    //FBS 游戏类---------------------------------------------------------------

    //新增比赛通知消息
    GLTP_O_FBS_ADD_MATCH_NFY_REQ            = 12007,
    GLTP_O_FBS_ADD_MATCH_NFY_RSP            = 12008,

//    //撤销比赛
//    GLTP_O_FBS_DELETE_MATCH_REQ             = 12009,
//    GLTP_O_FBS_DELETE_MATCH_RSP             = 12010,

    //启用/停用比赛
    GLTP_O_FBS_MATCH_STATUS_CTRL_REQ        = 12011,
    GLTP_O_FBS_MATCH_STATUS_CTRL_RSP        = 12012,

    //修改比赛关闭时间
    GLTP_O_FBS_MDY_MATCH_TIME_REQ           = 12013,
    GLTP_O_FBS_MDY_MATCH_TIME_RSP           = 12014,

    //比赛开奖 -> 比赛结果录入
    GLTP_O_FBS_DRAW_INPUT_RESULT_REQ        = 12021,
    GLTP_O_FBS_DRAW_INPUT_RESULT_RSP        = 12022,

    //比赛开奖 -> 开奖结果确认消息
    GLTP_O_FBS_DRAW_CONFIRM_REQ             = 12023,
    GLTP_O_FBS_DRAW_CONFIRM_RSP             = 12024,



}GLTP_MESSAGE_OMS_TYPE;


#if 0

//指定按1字节对齐
#pragma pack (1)



//---------------------------------------------------------------------------------------------------
// FBS 消息定义
//---------------------------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// 彩票查询(请求/响应)
// 请求消息编码 GLTP_O_FBS_TICKET_INQUIRY_REQ(12001)
// 响应消息编码 GLTP_O_FBS_TICKET_INQUIRY_RSP(12002)
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_O_FBS_INQUIRY_TICKET_REQ
{
    GLTP_MSG_O_HEADER  header;
    char   rspfn_ticket[TSN_LENGTH];
}GLTP_MSG_O_FBS_INQUIRY_TICKET_REQ;

//------------------------------------------------------------------------------
//查票中奖信息结构体
//------------------------------------------------------------------------------
//查票时，显示的中奖拆单信息
typedef struct _GL_FBS_WIN_ORDER_INFO
{
    uint16    ord_no;                          //拆单编号

    money_t   winningAmountWithTax;            //中奖金额
    int32     winningCount;                    //中奖注数

    uint32    win_match_code;                  //在哪一场比赛的开奖过程中中奖
}GL_FBS_WIN_ORDER_INFO;
typedef struct _GLTP_MSG_O_FBS_INQUIRY_TICKET_RSP
{
    GLTP_MSG_O_HEADER header;
    uint32  status;                         //成功(0)

    char    rspfn_ticket[TSN_LENGTH];
    uint8   gameCode;                       //游戏编码
    char    gameName[MAX_GAME_NAME_LENGTH]; //游戏名称

    uint8   from_sale;                      //票来源

    uint64  issueNumber;                    //销售期号

    uint64  ticketAmount;                   //票面金额

    uint8   isTrain;                        //是否培训模式: 否(0)/是(1)
    uint8   isCancel;                       //是否已退票:已退票(1)
    uint8   isWin;                          //是否中奖:未开奖(0) 未中奖(1) 中奖(2)
    uint8   isBigPrize;                     //是否是大奖

    uint64  amountBeforeTax;                //中奖金额(税前)
    uint64  taxAmount;                      //税金
    uint64  amountAfterTax;                 //中奖金额(税后)

    uint64  sale_termCode;                  //售票终端编码
    uint32  sale_tellerCode;                //售票销售员编码
    uint32  sale_time;                      //售票时间

    uint8   isPayed;                        //是否已兑奖:未兑奖(0) 已兑奖(1)
    uint64  pay_termCode;                   //兑奖终端编码
    uint32  pay_tellerCode;                 //兑奖销售员编码
    uint32  pay_time;                       //兑奖时间
    uint32  issueNumber_pay;                //兑奖发生时的游戏期号

    uint64  cancel_termCode;                //退票终端编码
    uint32  cancel_tellerCode;              //退票销售员编码
    uint32  cancel_time;                    //退票时间

    char    customName[ENTRY_NAME_LEN];     //彩民姓名
    uint8   cardType;                       //证件类型:身份证(1)护照(2)军官证(3)士兵证(4)回乡证(5)其他证件(9)
    char    cardCode[IDENTITY_CARD_LENGTH]; //证件号码

    uint16  betStringLen;                   //投注字符串长度
    char    betString[];                    //投注字符串

    //uint16  orderCount;                   //拆单的数量
    //GL_FBS_WIN_ORDER_INFO orderArray[];
}GLTP_MSG_O_FBS_INQUIRY_TICKET_RSP;


//------------------------------------------------------------------------------
// 彩票兑奖(请求/响应)
// 请求消息编码 GLTP_O_FBS_TICKET_PAY_REQ(12003)
// 响应消息编码 GLTP_O_FBS_TICKET_PAY_RSP(12004)
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_O_FBS_PAY_TICKET_REQ
{
    GLTP_MSG_O_HEADER header;

    char    rspfn_ticket[TSN_LENGTH];

    char    reqfn_ticket_pay[TSN_LENGTH]; //兑奖请求交易流水号
    uint64  payAgencyCode;                //兑奖请求销售站编码
}GLTP_MSG_O_FBS_PAY_TICKET_REQ;

typedef struct _GLTP_MSG_O_FBS_PAY_TICKET_RSP
{
    GLTP_MSG_O_HEADER header;
    uint32  status;

    char    rspfn_ticket_pay[TSN_LENGTH]; //兑奖响应交易流水号

    char    rspfn_ticket[TSN_LENGTH];
    char    reqfn_ticket[TSN_LENGTH];   //销售请求流水号

    uint64  payAgencyCode;              //兑奖请求销售站编码
    uint8   gameCode;
    uint64  issueNumber;                //起始期期号
    uint32  saleTime;                   //销售时间

    money_t winningAmountWithTax;       //中奖金额(税前)
    money_t taxAmount;                  //税金
    money_t winningAmount;              //中奖金额税后
    uint32  transTimeStamp;             //交易时间

    uint16  betStringLen;               //投注字符串长度
    char    betString[];                //投注字符串

    //uint16  orderCount;               //拆单的数量
    //GL_FBS_WIN_ORDER_INFO orderArray[];
}GLTP_MSG_O_FBS_PAY_TICKET_RSP;


//------------------------------------------------------------------------------
// 彩票退票(请求/响应)
// 请求消息编码 GLTP_O_FBS_TICKET_CANCEL_REQ(12005)
// 响应消息编码 GLTP_O_FBS_TICKET_CANCEL_RSP(12006)
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_O_FBS_CANCEL_TICKET_REQ
{
    GLTP_MSG_O_HEADER header;

    char    rspfn_ticket[TSN_LENGTH];

    char    reqfn_ticket_cancel[TSN_LENGTH]; //退票请求交易流水号
    uint64  cancelAgencyCode;                //退票请求销售站编码
}GLTP_MSG_O_FBS_CANCEL_TICKET_REQ;

typedef struct _GLTP_MSG_O_FBS_CANCEL_TICKET_RSP
{
    GLTP_MSG_O_HEADER header;
    uint32  status;

    char    rspfn_ticket_cancel[TSN_LENGTH]; //退票响应交易流水号

    char    rspfn_ticket[TSN_LENGTH];
    char    reqfn_ticket[TSN_LENGTH];   //销售请求流水号

    uint64  cancelAgencyCode;           //退票请求站点编码
    uint8   gameCode;
    uint64  issueNumber;                //销售期号
    uint32  saleTime;                   //销售时间

    uint64  saleAgencyCode;             //售票站点编码
    money_t cancelAmount;               //取消金额
    uint32  transTimeStamp;             //交易时间
    money_t commissionAmount;           //销售佣金
}GLTP_MSG_O_FBS_CANCEL_TICKET_RSP;



//------------------------------------------------------------------------------
// 新增比赛通知消息
// 请求消息编码 GLTP_O_FBS_ADD_MATCH_NFY_REQ(12007)
// 响应消息使用公共OMS返回消息, 消息编码为 GLTP_O_FBS_ADD_MATCH_NFY_RSP(12008)
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_O_FBS_ADD_MATCH_NFY_REQ
{
    GLTP_MSG_O_HEADER  header;
    uint8   gameCode;
}GLTP_MSG_O_FBS_ADD_MATCH_NFY_REQ;


//------------------------------------------------------------------------------
// 撤销比赛
// 请求消息编码 GLTP_O_FBS_DELETE_MATCH_REQ(12009)
// 响应消息使用公共OMS返回消息, 消息编码为 GLTP_O_FBS_DELETE_MATCH_RSP(12010)
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_O_FBS_DELETE_MATCH_REQ
{
    GLTP_MSG_O_HEADER  header;
    uint8   gameCode;
    uint32  issueNumber;  //期号(日期 151025)
    uint32  matchCode; //删除此场比赛后的所有比赛 (比较比赛编码的大小)
}GLTP_MSG_O_FBS_DELETE_MATCH_REQ;


//------------------------------------------------------------------------------
// 启用/停用比赛
// 请求消息编码 GLTP_O_FBS_MATCH_STATUS_CTRL_REQ(12011)
// 响应消息使用公共OMS返回消息, 消息编码为 GLTP_O_FBS_MATCH_STATUS_CTRL_RSP(12012)
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_O_FBS_MATCH_STATUS_CTRL_REQ
{
    GLTP_MSG_O_HEADER  header;
    uint8   gameCode;
    uint32  issueNumber;  //期号(日期 151025)
    uint32  matchCode; //删除此场比赛后的所有比赛 (比较比赛编码的大小)
    uint8   enable;
}GLTP_MSG_O_FBS_MATCH_STATUS_CTRL_REQ;


//------------------------------------------------------------------------------
// 比赛开奖，录入比赛结果
// 请求消息编码 GLTP_O_FBS_DRAW_INPUT_RESULT_REQ(12021)
// 响应消息使用公共OMS返回消息, 消息编码为 GLTP_O_FBS_DRAW_INPUT_RESULT_RSP(12022)
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_O_FBS_DRAW_INPUT_RESULT_REQ
{
    GLTP_MSG_O_HEADER  header;
    uint8   gameCode;
    uint32  issueNumber;  //期号(日期 151025)
    uint32  matchCode;
    uint8   drawResults[FBS_SUBTYPE_NUM]; //分玩法的开奖结果枚举值
    uint8   matchResult[8]; //比赛结果,数据格式定义如下
                            // matchResult[0]  ->  fht_win_result (上半场比赛结果  M_WIN_HOME->1, M_WIN_DRAW->2, M_WIN_AWAY->3)
                            // matchResult[1]  ->  fht_home_goals (上半场主队进球数)
                            // matchResult[2]  ->  fht_away_goals (上半场客队进球数)
                            // matchResult[3]  ->  sht_win_result (下半场比赛结果  M_WIN_HOME->1, M_WIN_DRAW->2, M_WIN_AWAY->3)
                            // matchResult[4]  ->  sht_home_goals (下半场主队进球数)
                            // matchResult[5]  ->  sht_away_goals (下半场客队进球数)
                            // matchResult[6]  ->  ft_win_result  (全场比赛结果    M_WIN_HOME->1, M_WIN_DRAW->2, M_WIN_AWAY->3)
                            // matchResult[7]  ->  first_goal     (那个队伍先进球  M_TERM_HOME->1  or  M_TERM_AWAY->2)
}GLTP_MSG_O_FBS_DRAW_INPUT_RESULT_REQ;


//------------------------------------------------------------------------------
// 比赛开奖，开奖结果确认消息
// 请求消息编码 GLTP_O_FBS_DRAW_CONFIRM_REQ(12023)
// 响应消息使用公共OMS返回消息, 消息编码为 GLTP_O_FBS_DRAW_CONFIRM_RSP(12024)
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_O_FBS_DRAW_CONFIRM_REQ
{
    GLTP_MSG_O_HEADER  header;
    uint8   gameCode;
    uint32  issueNumber;  //期号(日期 151025)
    uint32  matchCode;
}GLTP_MSG_O_FBS_DRAW_CONFIRM_REQ;



//取消指定对齐，恢复缺省对齐
#pragma pack ()

#endif

#endif //GLTP_MESSAGE_OMS_H_INCLUDED

