#ifndef GLTP_MESSAGE_NOTIFY_H_INCLUDED
#define GLTP_MESSAGE_NOTIFY_H_INCLUDED

// NOTIFY的等级
#define   _INFO   ((uint8)1)
#define   _WARN   ((uint8)2)
#define   _ERROR  ((uint8)3)
#define   _FATAL  ((uint8)4)


//------------------------------------------------------------------------------
// NOTIFY消息编码(填入GLTP消息头中的func字段)
//------------------------------------------------------------------------------
typedef enum _GLTP_MESSAGE_NOTIFY_TYPE
{
    // SYS NOTIFY ---------------------------------
    GLTP_NTF_SYS_TASK_FAULT                 = 7011,       //系统任务异常
    GLTP_NTF_DB_EXCEPTION                   = 7012,       //数据库连接失败
    GLTP_NTF_DB_DEAL_FALSE                  = 7013,       //数据库业务执行失败

    // BQNET NOTIFY -------------------------------
    GLTP_NTF_BQ_BUFFER_NOTENOUGH            = 7021,       //BQueues Buffer不足报警事件
    GLTP_NTF_BQ_LINK_STATUS                 = 7022,       //BQueues链路状态变更

    // TFE NOTIFY ---------------------------------
    //703*

    // NCP NOTIFY  --------------------------------
    GLTP_NTF_NCP_STATUS                     = 7041,       //NCP可用状态改变事件
    GLTP_NTF_NCP_LINK_STATUS                = 7042,       //NCP链路状态改变事件

    // GL NOTIFY ----------------------------------
    GLTP_NTF_GL_SALE_MONEY_WARN             = 7101,       //单票大额销售告警
    GLTP_NTF_GL_PAY_MONEY_WARN              = 7102,       //单票大额兑奖告警
    GLTP_NTF_GL_CANCEL_MONEY_WARN           = 7103,       //单票大额取消告警

    GLTP_NTF_GL_CONTROL_GAME                = 7104,       //游戏状态变化(是否可销售、是否可兑奖、是否可退票)
    GLTP_NTF_GL_ISSUE_STATUS                = 7105,       //期次状态变化
    GLTP_NTF_GL_ISSUE_FLOW_ERR              = 7107,       //期结过程出现错误
    GLTP_NTF_GL_ISSUE_AUTO_DRAW             = 7108,       //游戏期次自动开奖状态变化(自动开奖游戏，自动开奖标记改变)

    GLTP_NTF_GL_RISK_CTRL                   = 7109,       //风险控制警告
    GLTP_NTF_GL_ADJUST_RISK                 = 7110,       //风险控制树调整

    GLTP_NTF_GL_RNG_STATUS                  = 7111,       //RNG可用状态变化
    GLTP_NTF_GL_RNG_WORK_STATUS             = 7112,       //RNG链路状态变化

    GLTP_NTF_GL_POLICY_PARAM                = 7113,       //修改游戏政策参数
    GLTP_NTF_GL_RULE_PARAM                  = 7114,       //修改游戏普通规则参数
    GLTP_NTF_GL_CTRL_PARAM                  = 7115,       //修改游戏控制参数
    //GLTP_NTF_GL_PRIZE_POOL                = 7116,       //修改游戏奖池金额
    GLTP_NTF_GL_RISK_CTRL_PARAM             = 7117,       //修改游戏风险控制参数

    // FBS
    GLTP_NTF_GL_FBS_DRAW_ERR                = 7150,       //FBS比赛开奖过程出现错误
    GLTP_NTF_GL_FBS_DRAW_CONFIRM            = 7151,       //FBS比赛开奖确认完成

    // TMS NOTIFY  --------------------------------
    GLTP_NTF_TMS_AREA_ADD                   = 7201,       //增加区域
    GLTP_NTF_TMS_AREA_MODIFY                = 7202,       //修改区域
    GLTP_NTF_TMS_AREA_STATUS                = 7203,       //区域可用状态变更
    GLTP_NTF_TMS_AREA_CTRL_GAME             = 7204,       //区域授权游戏参数变更
    GLTP_NTF_TMS_AREA_CTRL_AGENCY_GAME      = 7205,       //区域销售站授权游戏参数变更

    GLTP_NTF_TMS_AGENCY_ADD                 = 7206,       //增加销售站
    GLTP_NTF_TMS_AGENCY_MODIFY              = 7207,       //修改销售站
    GLTP_NTF_TMS_AGENCY_STATUS              = 7208,       //销售站可用状态
    GLTP_NTF_TMS_AGENCY_DEPOSIT             = 7210,       //销售站缴款
    GLTP_NTF_TMS_AGENCY_CREDIT_LIMIT        = 7211,       //销售站信用额度变更
    GLTP_NTF_TMS_AGENCY_PAY_TICKET_WARN     = 7212,       //销售站每日兑奖数量(或者金额)超过阈值告警
    GLTP_NTF_TMS_AGENCY_CANCEL_TICKET_WARN  = 7213,       //销售站每日退票数量(或者金额)超过阈值告警

    GLTP_NTF_TMS_TERM_ADD                   = 7214,       //增加终端机
    GLTP_NTF_TMS_TERM_MODIFY                = 7215,       //修改终端机
    GLTP_NTF_TMS_TERM_STATUS                = 7216,       //终端机可用状态
    //GLTP_NTF_TMS_TERM_LINK_STATUS           = 7217,       //终端机链路状态
    //GLTP_NTF_TMS_TERM_SIGN_STATUS           = 7218,       //终端机登录/签退事件
    GLTP_NTF_TMS_TERM_MSN_ERR               = 7219,       //终端机MSN错误
    GLTP_NTF_TMS_TERM_BUSY_ERR              = 7220,       //终端机BUSY错误

    GLTP_NTF_TMS_TELLER_ADD                 = 7221,       //增加销售员事件
    GLTP_NTF_TMS_TELLER_MODIFY              = 7222,       //修改销售员事件
    GLTP_NTF_TMS_TELLER_STATUS              = 7223,       //销售员可用状态事件

    GLTP_NTF_TMS_VERSION_ADD                = 7224,       //增加版本信息事件
    GLTP_NTF_TMS_VERSION_MODIFY             = 7225,       //修改版本信息事件
    GLTP_NTF_TMS_VERSION_STATUS             = 7226,       //版本可用状态事件

}GLTP_MESSAGE_NOTIFY_TYPE;



//指定按1字节对齐
#pragma pack (1)



//------------------------------------------------------------------------------
// GLTP-NOTIFY消息头(覆盖GLTP消息头字段)
// 填充消息时, type字段填GLTP_MSG_TYPE_NOTIFY(7), func字段填NOTIFY消息编码.
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_NTF_HEADER
{
    //GLTP_MSG_HEADER
    uint16  length;        //消息长度
    uint8   type;          //消息类型  OMS(0),销售站-终端(1),接入商(2)
    uint16  func;          //消息编码
    uint32  when;          //时间戳(秒数)

    uint8   level;         //NOTIFY的等级

    char data[];
}GLTP_MSG_NTF_HEADER;
#define GLTP_MSG_NTF_HEADER_LEN sizeof(GLTP_MSG_NTF_HEADER)



//------------------------------------------------------------------------------
// SYS NOTIFY
//------------------------------------------------------------------------------

//任务状态监控<异常结束> GLTP_NTF_SYS_TASK_FAULT(7011)
typedef struct _GLTP_MSG_NTF_SYS_TASK_FAULT
{
    char  taskName[64];                     //任务名称
}GLTP_MSG_NTF_SYS_TASK_FAULT;

//数据库连接失败 GLTP_NTF_DB_EXCEPTION(7012)
typedef struct _GLTP_MSG_NTF_DB_EXCEPTION
{
    uint8 db_type;                          //OMS(1),MIS(2)
}GLTP_MSG_NTF_DB_EXCEPTION;

//数据库业务执行失败 GLTP_NTF_DB_DEAL_FALSE(7013)
typedef struct _GLTP_MSG_NTF_DB_DEALFALSE
{
    char dealFalse[256];                  //主机oracle调用失败的接口名称
}GLTP_MSG_NTF_DB_DEALFALSE;

//------------------------------------------------------------------------------
// BQ NOTIFY
//------------------------------------------------------------------------------

//BQ Buffer不足报警事件 GLTP_NTF_BQ_BUFFER_NOTENOUGH(7021)
typedef struct _GLTP_MSG_NTF_BQ_BUFFER_NOTENOUGH
{
    uint8    bufferType;                    //Buffer类型
    uint32   remainBuffNum;                 //当前剩余Buffer数目
}GLTP_MSG_NTF_BQ_BUFFER_NOTENOUGH;

//BQueues链路状态变更 GLTP_NTF_BQ_LINK_STATUS(7022)
typedef struct _GLTP_MSG_NTF_BQ_LINK_STATUS
{
    char   AModIP[16];                       //A模块IP
    char   BModIP[16];                       //B模块IP
    uint8  linkState;                        //链路状态  断开(0),连接(1)
}GLTP_MSG_NTF_BQ_LINK_STATUS;



//------------------------------------------------------------------------------
// TFE NOTIFY
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
// NCP NOTIFY
//------------------------------------------------------------------------------

//NCP可用状态改变事件 GLTP_NTF_NCP_STATUS(7041)
typedef struct _GLTP_MSG_NTF_NCP_STATUS
{
    uint32  ncpCode;                        //NCP编码
    uint8   type;                           //NCP类型
    char    ipaddr[16];                     //IP地址
    uint8   status;                         //NCP可用状态 enum STATUS_TYPE
}GLTP_MSG_NTF_NCP_STATUS;

//NCP链路状态改变事件 GLTP_NTF_NCP_LINK_STATUS(7042)
typedef struct _GLTP_MSG_NTF_NCP_LINK
{
    uint32  ncpCode;                        //NCP编码
    uint8   type;                           //NCP类型
    char    ipaddr[16];                     //IP地址
    uint8   connect;                        //链路状态 连接(0),断开(1)
}GLTP_MSG_NTF_NCP_LINK;



//------------------------------------------------------------------------------
// GL NOTIFY
//------------------------------------------------------------------------------

//单票大额扣销售告警 GLTP_NTF_GL_SALE_MONEY_WARN(7101)
typedef struct _GLTP_MSG_NTF_GL_SALE_MONEY_WARN
{
    uint8   gameCode;                       //游戏编码
    uint64  issueNumber;                    //彩票期号
    uint64  agencyCode;                     //销售站编码
    money_t salesAmount;                    //票销售金额
    money_t availableCredit;                //账户余额
}GLTP_MSG_NTF_GL_SALE_MONEY_WARN;

//单票大额兑奖告警 GLTP_NTF_GL_PAY_MONEY_WARN(7102)
typedef struct _GLTP_MSG_NTF_GL_PAY_MONEY_WARN
{
    uint8   gameCode;                       //游戏编码
    uint64  issueNumber;                    //彩票售票时的期号
    uint64  agencyCode;                     //销售站编码
    money_t payAmount;                      //票兑奖金额
    money_t availableCredit;                //账户余额
}GLTP_MSG_NTF_GL_PAY_MONEY_WARN;

//单票大额取消告警 GLTP_NTF_GL_CANCEL_MONEY_WARN(7103)
typedef struct _GLTP_MSG_NTF_GL_CANCEL_MONEY_WARN
{
    uint8   gameCode;                       //游戏编码
    uint64  issueNumber;                    //彩票售票时的期号
    uint64  agencyCode;                     //销售站编码
    money_t cancelAmount;                   //票取消金额
    money_t availableCredit;                //账户余额
}GLTP_MSG_NTF_GL_CANCEL_MONEY_WARN;

//游戏状态变化(是否可销售、是否可兑奖、是否可退票) GLTP_NTF_GL_CONTROL_GAME(7104)
typedef struct _GLTP_MSG_NTF_GL_CONTROL_GAME
{
    uint8   gameCode;                       //游戏编码
    uint8   flag;                           //控制类型 销售(1),兑奖(2),取消(3)
    uint8   status;                         //修改后的状态 不允许(0),允许(1)
}GLTP_MSG_NTF_GL_CONTROL_GAME;

//期次状态变化 GLTP_NTF_GL_ISSUE_STATUS(7105)
typedef struct _GLTP_MSG_NTF_GL_ISSUE_STATUS
{
    uint8   gameCode;                       //游戏编码
    uint32  issueNumber;                    //期次编号
    uint8   nowStatus;                      //期次当前状态
    uint32  nowtime;                        //当前时间
}GLTP_MSG_NTF_GL_ISSUE_STATUS;

//期结过程出现错误 GLTP_NTF_GL_ISSUE_FLOW_ERR(7107)
typedef struct _GLTP_MSG_NTF_GL_ISSUE_FLOW_ERR
{
    uint8   gameCode;                       //游戏编码
    uint32  issueNumber;                    //期次编号
    uint8   issueStatus;                    //期次状态
    uint8   error;                          //期次错误码
}GLTP_MSG_NTF_GL_ISSUE_FLOW_ERR;

//游戏期次自动开奖状态变化(自动开奖游戏，自动开奖标记改变) GLTP_NTF_GL_ISSUE_AUTO_DRAW(7108)
typedef struct _GLTP_MSG_NTF_GL_ISSUE_AUTO_DRAW
{
    uint8   gameCode;                       //游戏编码

    uint8   status;                         //修改后的状态 不允许(0),允许(1)
}GLTP_MSG_NTF_GL_ISSUE_AUTO_DRAW;

//风险控制警告 GLTP_NTF_GL_RISK_CTRL(7109)
typedef struct _GLTP_MSG_NTF_GL_RISK_CTRL
{
    uint8   gameCode;                       //游戏编码

    uint32  issueNumber;                    //期次编号
    uint8   subType;                        //游戏玩法
    char    betNumber[32];                  //投注号码字符串
}GLTP_MSG_NTF_GL_RISK_CTRL;

//风险控制树调整 GLTP_NTF_GL_ADJUST_RISK(7110)
typedef struct _GLTP_MSG_NTF_GL_ADJUST_RISK
{
    uint8   gameCode;                       //游戏编码

    uint8   subType;                        //游戏玩法
    uint32  adjustStep;                     //调整步长
}GLTP_MSG_NTF_GL_ADJUST_RISK;

//RNG可用状态改变事件 GLTP_NTF_GL_RNG_STATUS(7111)
typedef struct _GLTP_MSG_NTF_GL_RNG_STATUS
{
    uint32  rngId;                          //RNG共享内存索引值

    uint8   status;                         //RNG可用状态 enum STATUS_TYPE
    uint8   mac[6];                         //RNG MAC地址
    char    ipaddr[16];                     //RNG IP地址
}GLTP_MSG_NTF_GL_RNG_STATUS;

//RNG链路状态改变事件 GLTP_NTF_GL_RNG_WORK_STATUS(7112)
typedef struct _GLTP_MSG_NTF_GL_RNG_WORK_STATUS
{
    uint32  rngId;                          //RNG共享内存索引值

    uint8   workStatus;                     //RNG 工作状态 0=未连接  1=已连接 2=正常工作
    uint8   mac[6];                         //RNG MAC地址
    char    ipaddr[16];                     //RNG IP地址
}GLTP_MSG_NTF_GL_RNG_WORK_STATUS;

//修改游戏政策参数 GLTP_NTF_GL_POLICY_PARAM(7113)
typedef struct _GLTP_MSG_NTF_GL_POLICY_PARAM
{
    uint8   gameCode;                       //游戏编码

    uint16  publicFundRate;                 //公益金比例
    uint16  adjustmentFundRate;             //调节基金比例
    uint16  returnRate;                     //理论返奖率
    uint64  taxStartAmount;                 //缴税起征额(单位:分)
    uint16  taxRate;                        //缴税千分比
    uint16  payEndDay;                      //兑奖期
}GLTP_MSG_NTF_GL_POLICY_PARAM;

//修改游戏普通规则参数 GLTP_NTF_GL_RULE_PARAM(7114)
typedef struct _GLTP_MSG_NTF_GL_RULE_PARAM
{
    uint8   gameCode;                       //游戏编码

    uint32  maxTimesPerBetLine;             //单行最大倍数<=99
    uint32  maxBetLinePerTicket;            //单票最大投注行数<=10
    uint32  maxAmountPerTicket;             //单票最大销售限额(分)<=2000000
}GLTP_MSG_NTF_GL_RULE_PARAM;

//修改游戏控制参数 GLTP_NTF_GL_CTRL_PARAM(7115)
typedef struct _GLTP_MSG_NTF_GL_CTRL_PARAM
{
    uint8   gameCode;                       //游戏编码

    uint32  cancelTime;                     //允许退票时间
    uint32  countDownTimes;                 //游戏期关闭提醒时间(秒)

}GLTP_MSG_NTF_GL_CTRL_PARAM;

//修改游戏风险控制参数 GLTP_NTF_GL_RISK_CTRL_PARAM(7117)
typedef struct _GLTP_MSG_NTF_GL_RISK_CTRL_PARAM
{
    uint8   gameCode;                       //游戏编码
    uint8   riskCtrl;
    uint32  strLength;                      //风险控制字符串长度
    char    riskCtrlStr[512];               //风险控制字符串
}GLTP_MSG_NTF_GL_RISK_CTRL_PARAM;



//------------------------------------------------------------------------------
// FBS Draw NOTIFY
//------------------------------------------------------------------------------

//FBS 比赛开奖过程出现错误 GLTP_NTF_GL_FBS_DRAW_ERR(7150)
typedef struct _GLTP_MSG_NTF_GL_FBS_DRAW_ERR
{
    uint8   gameCode;                       //游戏编码
    uint32  issueNumber;                    //期次编号
    uint32  matchCode;                      //比赛编号
    uint8   matchStatus;                    //比赛状态
    uint8   error;                          //期次错误码
}GLTP_MSG_NTF_GL_FBS_DRAW_ERR;

//FBS 比赛开奖完成 GLTP_NTF_GL_FBS_DRAW_CONFIRM(7151)
typedef struct _GLTP_MSG_NTF_GL_FBS_DRAW_CONFIRM
{
    uint8   gameCode;                       //游戏编码
    uint32  issueNumber;                    //期次编号
    uint32  matchCode;                      //比赛编号
}GLTP_MSG_NTF_GL_FBS_DRAW_CONFIRM;



//------------------------------------------------------------------------------
// TMS NOTIFY
//------------------------------------------------------------------------------

//终端机MSN错误 GLTP_NTF_TMS_TERM_MSN_ERR(7219)
typedef struct _GLTP_MSG_NTF_TMS_TERM_MSN_ERR
{
    uint64  termCode;                       //终端机编码

    uint8   szTermMac[6];                   //终端机MAC地址
    uint8   recvMsn;                        //终端机请求的MSN
    uint8   msn;                            //系统保存的终端机MSN
}GLTP_MSG_NTF_TMS_TERM_MSN_ERR;

//终端机BUSY错误 GLTP_NTF_TMS_TERM_BUSY_ERR(7220)
typedef struct _GLTP_MSG_NTF_TMS_TERM_BUSY_ERR
{
    uint64  termCode;                       //终端机编码

    uint8   szTermMac[6];                   //终端机MAC地址
}GLTP_MSG_NTF_TMS_TERM_BUSY_ERR;




//取消指定对齐，恢复缺省对齐
#pragma pack ()


#endif //GLTP_MESSAGE_NOTIFY_H_INCLUDED



