#ifndef GLTP_MESSAGE_H_INCLUDED
#define GLTP_MESSAGE_H_INCLUDED



//消息类型定义
typedef enum _GLTP_MSG_TYPE {
    GLTP_MSG_TYPE_NCP             = 1,   //NCP APNCP 业务消息 
    GLTP_MSG_TYPE_OMS             = 2,   //OMS业务消息
    GLTP_MSG_TYPE_TERMINAL        = 3,   //终端机业务消息
    GLTP_MSG_TYPE_TERMINAL_UNS    = 4,   //终端机业务消息广播消息
    GLTP_MSG_TYPE_AP              = 5,   //接入商业务消息

    GLTP_MSG_TYPE_NOTIFY          = 7,   //NOTIFY事件消息
    GLTP_MSG_TYPE_REPORT          = 8,   //REPORT监控消息
}GLTP_MSG_TYPE;



//指定按1字节对齐
#pragma pack (1)


//消息头部
typedef struct _GLTP_MSG_HEADER
{
    uint16  length;        //消息长度
    uint8   type;          //消息类型
    uint16  func;          //消息编码
    uint32  when;          //时间戳（秒数）

    char data[];
}GLTP_MSG_HEADER;
#define GLTP_MSG_HEADER_LEN sizeof(GLTP_MSG_HEADER)



//取消指定对齐，恢复缺省对齐
#pragma pack ()



#define TSN_LENGTH               25
#define PWD_MD5_LENGTH           32   //MD5密码长度
#define LOYALTY_CARD_LENGTH      20
#define IDENTITY_CARD_LENGTH     18
#define TICKET_SLOGAN_LENGTH     1024 //票面宣传语最大长度
#define AGENCY_ADDRESS_LENGTH    512  //销售站地址最大长度

#include "gltp_message_ncp.h"
#include "gltp_message_terminal.h"



//定义数据处理结果类型
typedef enum _SYS_RESULT_TYPE
{
    SYS_RESULT_SUCCESS = 0,                         //交易成功
    SYS_RESULT_FAILURE = 1,                         //交易失败

    //SYS_RESULT_RETRY_ERR = 2,                     //重传
    SYS_RESULT_T_AGENCY_ERR = 3,                    //销售站不存在或未启动
    SYS_RESULT_T_AUTHENTICATE_ERR = 4,              //认证失败
    SYS_RESULT_T_NAMEPWD_ERR = 5,                   //用户名或密码错误
    SYS_RESULT_T_TERM_DISABLE_ERR = 6,              //终端不可用
    SYS_RESULT_T_CANCEL_AGENCY_ERR = 7,             //退票销售站与售票销售站不匹配

    SYS_RESULT_T_TELLER_DISABLE_ERR = 8,            //销售员不可用
    SYS_RESULT_T_TELLER_SIGNOUT_ERR = 9,            //销售员未登录
    SYS_RESULT_T_TERM_SIGNED_IN_ERR = 10,           //此终端机上已有销售员登录
    SYS_RESULT_T_TELLER_CLEANOUT_ERR = 11,          //销售员已班结
    SYS_RESULT_T_TELLER_UNAUTHEN_ERR = 12,          //销售员未授此操作权限
    SYS_RESULT_T_TELLER_UNEXIST = 13,               //销售员不存在

    SYS_RESULT_GAME_DISABLE_ERR = 14,               //游戏不可用
    SYS_RESULT_SELL_DISABLE_ERR = 15,               //游戏不可销售
    SYS_RESULT_PAY_DISABLE_ERR = 16,                //游戏不可兑奖
    SYS_RESULT_CANCEL_DISABLE_ERR = 17,             //游戏不可取消
    SYS_RESULT_GAME_SUBTYPE_ERR = 18,               //游戏玩法方式不支持
    SYS_RESULT_CLAIMING_SCOPE_ERR = 19,             //不符合兑奖范围

    SYS_RESULT_SELL_DATA_ERR = 20,                  //彩票销售选号错误
    SYS_RESULT_SELL_BETLINE_ERR = 21,               //彩票销售注数错误
    SYS_RESULT_SELL_BETTIMES_ERR = 22,              //彩票销售倍数错误
    SYS_RESULT_SELL_ISSUECOUNT_ERR = 23,            //彩票销售期数错误
    SYS_RESULT_SELL_TICKET_AMOUNT_ERR = 24,         //彩票销售金额错误
    SYS_RESULT_SELL_LACK_AMOUNT_ERR = 25,           //账户余额不足

    //风险控制 计算结果
    SYS_RESULT_RISK_CTRL_ERR = 26,                  //超过风险控制

    SYS_RESULT_TSN_ERR = 27,                        //TSN错误
    SYS_RESULT_PAY_LACK_CASH_ERR = 28,              //现金金额不足 (需要放入现金)
    SYS_RESULT_PAY_BIG_WINNING_ERR = 29,            //中大奖，需要输入票面附加码(此错误码停止使用)
    SYS_RESULT_TICKET_NOT_FOUND_ERR = 30,           //没有找到此彩票
    SYS_RESULT_PAY_PAID_ERR = 31,                   //彩票已兑奖
    SYS_RESULT_CANCEL_AGAIN_ERR = 32,               //彩票已退票
    SYS_RESULT_PAY_NOT_WIN_ERR = 33,                //彩票未中奖
    SYS_RESULT_PAY_NOT_DRAW_ERR = 34,               //彩票期还没有开奖
    SYS_RESULT_PAY_WAIT_DRAW_ERR = 35,              //彩票期等待开奖
    SYS_RESULT_CANCEL_NOT_ACCEPT_ERR = 36,          //彩票退票失败
    SYS_RESULT_LACK_CASH_ERR = 37,                  //现金金额不足 (当执行取出现金操作时发生)

    SYS_RESULT_MSG_DATA_ERR = 38,                   //消息数据错误
    SYS_RESULT_VERSION_NOT_AVAILABLE_ERR = 39,      //软件版本不可用
    SYS_RESULT_GAMERESULT_DISABLE_ERR = 40,         //开奖结果不可用
    SYS_RESULT_SELL_NOISSUE_ERR = 41,               //彩票销售无当前期可用
    SYS_RESULT_SELL_DRAWTIME_ERR = 42,              //彩票销售获取开奖时间错误

    SYS_RESULT_PAY_MULTI_ISSUE_ERR = 43,            //连续多期票，最后一期未结束，不能兑奖
    SYS_RESULT_TELLER_PAY_LIMIT_ERR = 44,           //超出销售员兑奖范围
    SYS_RESULT_PAY_WAIT_AWARD_TIME_ERR = 45,        //未到兑奖开始时间
    SYS_RESULT_PAY_AWARD_TIME_END_ERR = 46,         //兑奖时间已结束
    SYS_RESULT_CANCEL_TIME_END_ERR = 47,            //已过最大撤消时间,不能退票
    SYS_RESULT_PAY_NEED_EXCODE_ERR = 48,            //兑大奖需要附加码
    SYS_RESULT_PAY_EXCODE_ERR = 49,                 //兑大奖附加码错误

    SYS_RESULT_PAY_DAYEND_ERR = 50,                 //兑奖日期已结止
    SYS_RESULT_T_CANCEL_UNTRAINER_ERR = 51,         //销售员退培训票
    SYS_RESULT_T_CANCEL_TRAINER_ERR = 52,           //培训员退正常票
    SYS_RESULT_T_PAY_UNTRAINER_ERR = 53,            //销售员兑培训票
    SYS_RESULT_T_PAY_TRAINER_ERR = 54,              //培训员兑正常票
    SYS_RESULT_INQUIRY_ISSUE_NOFOUND_ERR = 55,      //彩票期未找到

    SYS_RESULT_GAME_SERVICETIME_OUT_ERR = 56,       //当前不是彩票交易时段

    SYS_RESULT_T_TERM_TRAIN_UNREPORT_ERR = 57,      //培训机不可查销售员报表

    SYS_RESULT_PAY_PAYING_ERR = 58,                 //彩票正在兑奖中
    SYS_RESULT_CANCEL_CANCELING_ERR = 59,           //彩票退票中

    SYS_RESULT_PAY_GAMELIMIT_ERR = 60,              //游戏兑奖限额： 系统保护阈值（所有的兑奖行为都受此参数限制）
    SYS_RESULT_CANCEL_MONEYLIMIT_ERR = 61,          //退票超出限额
    SYS_RESULT_FLOW_NUMBER_ERR = 62,                //交易流水号不匹配

    SYS_RESULT_AP_TOKEN_ERR = 63,                   //ap业务token验证失败

    SYS_RESULT_TYPE_ERR = 64,                       //查询类型(type)错误

    SYS_RESULT_T_AGENCY_TIME_ERR = 65,              //超出销售站营业时间

    SYS_RESULT_T_AGENCY_TYPE_ERR = 66,              //销售站类型不支持

    SYS_RESULT_T_TELLER_SIGNED_IN_ERR = 67,         //此销售员已登录其他终端机


    SYS_RESULT_T_TOKEN_EXPIRED_ERR = 68,            //token失效，需要重新认证
    SYS_RESULT_T_MSN_ERR = 69,                      //msn错误，需要重新登录

}SYS_RESULT_TYPE;


#endif //GLTP_MESSAGE_H_INCLUDED

