#ifndef INM_MESSAGE_H_INCLUDED
#define INM_MESSAGE_H_INCLUDED


//------------------------------------------------------------------------------
// INM 消息编码
//------------------------------------------------------------------------------
typedef enum _INM_MSG_TYPE {
    INM_TYPE_NULL                           = 0,

    // ncp ---------------------------------------------------------------------
    INM_TYPE_N_HB                           = 1,
    INM_TYPE_N_ECHO                         = 2,

    // terminal ----------------------------------------------------------------
    INM_TYPE_T_ECHO                         = 3,
    INM_TYPE_T_AUTH                         = 4,     //Terminal认证消息
    INM_TYPE_T_VERSION_INQUIRY              = 5,     //版本验证消息
    INM_TYPE_T_SELL_TICKET                  = 6,     //(TF) Terminal彩票销售
    INM_TYPE_T_PAY_TICKET                   = 7,     //(TF) Terminal彩票兑奖
    INM_TYPE_T_CANCEL_TICKET                = 8,     //(TF) Terminal彩票取消

    INM_TYPE_T_SIGNIN                       = 9,     //(TF) Terminal销售员登录消息
    INM_TYPE_T_SIGNOUT                      = 10,    //(TF) Terminal销售员签退消息
    INM_TYPE_T_CHANGE_PWD                   = 11,    //(TF) Terminal销售员修改密码

    INM_TYPE_T_AGENCY_BALANCE               = 12,    //查询销售站余额

    INM_TYPE_T_INQUIRY_TICKET_DETAIL        = 13,    //查询彩票明细
    INM_TYPE_T_GAME_INFO                    = 14,    //请求游戏信息

    INM_TYPE_T_GAME_DRAW_ANNOUNCE           = 15,    //请求游戏开奖公告

    INM_TYPE_T_OPEN_GAME_UNS                = 16,    //游戏期次开启
    INM_TYPE_T_CLOSE_SECONDS_UNS            = 17,    //游戏期次即将关闭
    INM_TYPE_T_CLOSE_GAME_UNS               = 18,    //游戏期次关闭
    INM_TYPE_T_DRAW_ANNOUNCE_UNS            = 19,    //游戏期次开奖公告

    INM_TYPE_T_RESET_UNS                    = 20,    //签退终端机(销售员)
    INM_TYPE_T_MESSAGE_UNS                  = 21,    //终端机通知消息

    // AccessProcider (AP) -----------------------------------------------------

    INM_TYPE_AP_INQUIRY_TICKET              = 22,    //AP查询彩票出票状态
    INM_TYPE_AP_INQUIRY_ISSUE               = 25,    //AP查询游戏当前期
    INM_TYPE_AP_ISSUE_STATE                 = 26,    //AP查询游戏所有预售期

    INM_TYPE_AP_ECHO                        = 30,

    // zot ---------------------------------------------------------------------
    //tfe
    INM_TYPE_TFE_CHECK_POINT                = 31,    //(TF) CheckPoint记录

    //system
    INM_TYPE_SYS_SWITCH_SESSION             = 32,    //(TF) 日结的切换记录

    //system
    INM_TYPE_SYS_BUSINESS_STATE             = 33,    //(TF) 系统运行状态切换至BUSINESS的记录

    //rng status change message
    INM_TYPE_RNG_STATUS                     = 35,    //(TF) RNG状态改变消息

    //game issue state
    INM_TYPE_ISSUE_STATE_PRESALE            = 36,    //(TF) Issue标记游戏期次可预售
    INM_TYPE_ISSUE_STATE_OPEN               = 37,    //(TF) Issue标记游戏当前期次
    INM_TYPE_ISSUE_STATE_CLOSING            = 38,    //(TF) Issue期即将关闭
    INM_TYPE_ISSUE_STATE_CLOSED             = 39,    //(TF) Issue游戏期关闭   标记游戏开始销售为停止
    INM_TYPE_ISSUE_STATE_SEALED             = 40,    //(TF) Issue数据封存完毕
    INM_TYPE_ISSUE_STATE_DRAWNUM_INPUTED    = 41,    //(TF) Issue开奖号码已录入
    INM_TYPE_ISSUE_STATE_MATCHED            = 42,    //(TF) Issue销售已经匹配
    INM_TYPE_ISSUE_STATE_FUND_INPUTED       = 43,    //(TF) Issue高等奖金总额、奖金池总额、调节基金总额、发行基金总额   已录入
    INM_TYPE_ISSUE_STATE_LOCAL_CALCED       = 44,    //(TF) Issue本地算奖完成
    INM_TYPE_ISSUE_STATE_PRIZE_ADJUSTED     = 45,    //(TF) Issue奖级调整完毕
    INM_TYPE_ISSUE_STATE_PRIZE_CONFIRMED    = 46,    //(TF) Issue开奖确认
    INM_TYPE_ISSUE_STATE_DB_IMPORTED        = 47,    //(TF) Issue中奖数据已录入数据库
    INM_TYPE_ISSUE_STATE_ISSUE_END          = 48,    //(TF) Issue期结全部完成

    INM_TYPE_ISSUE_SALE_FILE_MD5SUM         = 49,    // 分发稽核数据摘要
    INM_TYPE_ISSUE_DRAW_REDO                = 50,    //(TF) Issue重做期结流程  (重新开奖)
    INM_TYPE_ISSUE_SECOND_DRAW              = 51,    //(TF) 期次重新开奖(二次开奖)


    // OMS ---------------------------------------------------------------------
    INM_TYPE_O_HB                           = 52,
    INM_TYPE_O_ECHO                         = 53,
    INM_TYPE_O_COMMON                       = 54,    //OMS INM消息,只含有头部信息

    INM_TYPE_O_INQUIRY_SYSTEM               = 55,    //(查询系统运行状态)

    INM_TYPE_O_GL_POLICY_PARAM              = 56,    //(TF) OMS修改游戏政策参数
    INM_TYPE_O_GL_RULE_PARAM                = 57,    //(TF) OMS修改游戏普通规则参数
    INM_TYPE_O_GL_CTRL_PARAM                = 58,    //(TF) OMS修改游戏控制参数
    INM_TYPE_O_GL_RISK_CTRL_PARAM           = 59,    //(TF) OMS修改游戏风险控制参数
    INM_TYPE_O_GL_SALE_CTRL                 = 60,    //(TF) OMS游戏销售控制
    INM_TYPE_O_GL_PAY_CTRL                  = 61,    //(TF) OMS游戏兑奖控制
    INM_TYPE_O_GL_CANCEL_CTRL               = 62,    //(TF) OMS游戏退票控制
    INM_TYPE_O_GL_AUTO_DRAW                 = 63,    //(TF) OMS游戏自动开奖控制
    INM_TYPE_O_GL_SERVICE_TIME              = 64,    //(TF) OMS游戏服务时段设置
    INM_TYPE_O_GL_WARN_THRESHOLD            = 65,    //(TF) OMS游戏告警阈值设置

    INM_TYPE_O_GL_ISSUE_ADD_NFY             = 66,    //(TF) OMS增加期次通知
    INM_TYPE_O_GL_ISSUE_DEL                 = 67,    //(TF) OMS删除期次

    INM_TYPE_O_PAY_TICKET                   = 68,    //OMS彩票兑奖
    INM_TYPE_O_CANCEL_TICKET                = 69,    //OMS彩票取消
    INM_TYPE_O_INQUIRY_TICKET               = 70,    //OMS彩票查询

    INM_TYPE_T_MESSAGE_ERR                  = 100,   //终端机错误消息
    INM_TYPE_T_GAME_ISSUE                   = 110,   //请求游戏当前期次信息

    //retry message
    INM_TYPE_T_RETRY                        = 111,   //内部retry消息记录

    INM_TYPE_T_INQUIRY_WIN                  = 112,   //查询中奖彩票明细

    //fbs message for terminal
    INM_TYPE_FBS_MATCH_INFO                 = 150,   //查询比赛信息
    INM_TYPE_FBS_SELL_TICKET                = 151,   //售票
    INM_TYPE_FBS_PAY_TICKET                 = 152,   //兑奖
    INM_TYPE_FBS_CANCEL_TICKET              = 153,   //退票
    INM_TYPE_FBS_INQUIRY_TICKET             = 154,   //查询彩票明细
    INM_TYPE_FBS_INQUIRY_WIN_TICKET         = 155,   //查询中奖彩票明细

    //fbs message for OMS
    INM_TYPE_O_FBS_PAY_TICKET               = 161,   //OMS彩票兑奖
    INM_TYPE_O_FBS_CANCEL_TICKET            = 162,   //OMS彩票取消
    INM_TYPE_O_FBS_INQUIRY_TICKET           = 163,   //OMS彩票查询

    INM_TYPE_O_FBS_ADD_MATCH_NTY            = 164,   //新增比赛通知消息
    INM_TYPE_O_FBS_DEL_MATCH                = 165,   //删除比赛
    INM_TYPE_O_FBS_MATCH_STATUS_CTRL        = 166,   //启用/停用比赛

    INM_TYPE_O_FBS_MATCH_OPEN               = 167,   //比赛可以销售
    INM_TYPE_O_FBS_MATCH_CLOSE              = 168,   //比赛截止销售
    INM_TYPE_O_FBS_DRAW_INPUT_RESULT        = 169,   //录入比赛结果
    INM_TYPE_O_FBS_DRAW_CONFIRM             = 170,   //比赛开奖结果确认并完成
    INM_TYPE_O_FBS_MATCH_TIME               = 171,   //修改比赛关闭时间

    INM_TYPE_COMMOM_ERR                     = 172,   //通用错误类型

    INM_TYPE_AP_AUTODRAW                    = 173,   //AP自动兑奖
    INM_TYPE_AP_AUTODRAW_OVER               = 174,   //AP自动兑奖完成
    INM_TYPE_AP_SELL_TICKET                 = 175,   //AP售票

}INM_MSG_TYPE;


//指定按1字节对齐
#pragma pack (1)



//内部消息头
typedef struct _INM_MSG_HEADER {
    uint16  length;             //消息长度
    uint32  version;            //tfe记录版本号
    uint8   type;               //消息类型 (INM_MSG_TYPE)
    uint32  when;               //时间戳(秒数)
    uint16  status;             //业务处理结果，消息返回值(错误编码 OMS_RESULT_TYPE)

    uint32  socket_idx;         //NCPC_DATABASE中ncpArray的下标

    uint8   gltp_type;          //消息类型(内部产生的消息不使用此字段,默认填 0)
    uint16  gltp_func;          //消息编码(内部产生的消息不使用此字段,默认填 0)
    uint8   gltp_from;          //消息来源  TICKET_FROM_TYPE (内部产生的消息不使用此字段,默认填 0)

    uint32  tfe_file_idx;       //需要进行TF持久化的记录使用此字段(由TF模块填写)
    uint32  tfe_offset;         //需要进行TF持久化的记录使用此字段(由TF模块填写)
    uint32  tfe_when;           //需要进行TF持久化的记录使用此字段(由TF模块填写)

    char data[];
}INM_MSG_HEADER;

#define INM_MSG_HEADER_LEN sizeof(INM_MSG_HEADER)



//取消指定对齐，恢复缺省对齐
#pragma pack ()



#include "inm_message_ncp.h"
#include "inm_message_oms.h"
#include "inm_message_terminal.h"
#include "inm_message_zot.h"
#include "inm_message_ap.h"


static inline void DUMP_INMMSG(char *inm_buf)
{
    static char dump_type_buf[64];
    static char dump_buf[1024];

    //不需要内容的消息首字节填零使之不打印
    dump_buf[0] = '\0';
    INM_MSG_HEADER *header = (INM_MSG_HEADER *)inm_buf;
    switch (header->type)
    {
        // ncp -----------------------------------------------------------------
        case INM_TYPE_N_HB:
            return;
            //sprintf(dump_type_buf, "%s", "INM_TYPE_N_HB");
            //break;
        case INM_TYPE_N_ECHO:
            sprintf(dump_type_buf, "%s", "INM_TYPE_N_ECHO");
            break;
        // terminal ------------------------------------------------------------
        case INM_TYPE_T_ECHO:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_ECHO");
            break;
        case INM_TYPE_T_AUTH:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_AUTH");
            break;
        case INM_TYPE_T_VERSION_INQUIRY:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_VERSION_INQUIRY");
            break;
        case INM_TYPE_T_SELL_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_SELL_TICKET");
            break;
        case INM_TYPE_T_PAY_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_PAY_TICKET");
            break;
        case INM_TYPE_T_CANCEL_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_CANCEL_TICKET");
            break;
        case INM_TYPE_T_SIGNIN:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_SIGNIN");
            break;
        case INM_TYPE_T_SIGNOUT:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_SIGNOUT");
            break;
        case INM_TYPE_T_CHANGE_PWD:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_CHANGE_PWD");
            break;
        case INM_TYPE_T_AGENCY_BALANCE:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_AGENCY_BALANCE");
            break;
        case INM_TYPE_T_INQUIRY_TICKET_DETAIL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_INQUIRY_TICKET_DETAIL");
            break;
        case INM_TYPE_T_GAME_INFO:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_GAME_INFO");
            break;
        case INM_TYPE_T_GAME_DRAW_ANNOUNCE:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_GAME_DRAW_ANNOUNCE"); //查询开奖公告
            break;
        case INM_TYPE_T_GAME_ISSUE:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_GAME_ISSUE");
            break;

        case INM_TYPE_T_OPEN_GAME_UNS:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_OPEN_GAME_UNS");
            break;
        case INM_TYPE_T_CLOSE_SECONDS_UNS:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_CLOSE_SECONDS_UNS");
            break;
        case INM_TYPE_T_CLOSE_GAME_UNS:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_CLOSE_GAME_UNS");
            break;
        case INM_TYPE_T_DRAW_ANNOUNCE_UNS:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_DRAW_ANNOUNCE_UNS"); //开奖公告广播
            break;

        case INM_TYPE_T_RESET_UNS:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_RESET_UNS");
            break;
        case INM_TYPE_T_MESSAGE_UNS:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_MESSAGE_UNS");
            break;
        case INM_TYPE_T_MESSAGE_ERR:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_MESSAGE_ERR");
            break;
        case INM_TYPE_T_INQUIRY_WIN:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_INQUIRY_WIN");
            break;
        //retry message
        case INM_TYPE_T_RETRY:
            sprintf(dump_type_buf, "%s", "INM_TYPE_T_RETRY");
            break;
        // AccessProcider (AP) -------------------------------------------------
        case INM_TYPE_AP_ECHO:
            sprintf(dump_type_buf, "%s", "INM_TYPE_AP_ECHO");
            break;
        case INM_TYPE_AP_INQUIRY_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_AP_INQUIRY_TICKET");
            break;
        case INM_TYPE_AP_INQUIRY_ISSUE:
            sprintf(dump_type_buf, "%s", "INM_TYPE_AP_INQUIRY_ISSUE");
            break;
        case INM_TYPE_AP_ISSUE_STATE:
            sprintf(dump_type_buf, "%s", "INM_TYPE_AP_ISSUE_STATE");
            break;

        // FBS  -------------------------------------------------
        case INM_TYPE_FBS_MATCH_INFO:
            sprintf(dump_type_buf, "%s", "INM_TYPE_FBS_MATCH_INFO");
            break;
        case INM_TYPE_FBS_SELL_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_FBS_SELL_TICKET");
            break;
        case INM_TYPE_FBS_PAY_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_FBS_PAY_TICKET");
            break;
        case INM_TYPE_FBS_CANCEL_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_FBS_CANCEL_TICKET");
            break;

        case INM_TYPE_O_FBS_PAY_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_FBS_PAY_TICKET");
            break;
        case INM_TYPE_O_FBS_CANCEL_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_FBS_CANCEL_TICKET");
            break;
        case INM_TYPE_O_FBS_INQUIRY_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_FBS_INQUIRY_TICKET");
            break;

        case INM_TYPE_O_FBS_ADD_MATCH_NTY:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_FBS_ADD_MATCH_NTY");
            break;
        case INM_TYPE_O_FBS_DEL_MATCH:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_FBS_DEL_MATCH");
            break;
        case INM_TYPE_O_FBS_MATCH_STATUS_CTRL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_FBS_MATCH_STATUS_CTRL");
            break;
        case INM_TYPE_O_FBS_MATCH_OPEN:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_FBS_MATCH_OPEN");
            break;
        case INM_TYPE_O_FBS_MATCH_CLOSE:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_FBS_MATCH_CLOSE");
            break;
        case INM_TYPE_O_FBS_DRAW_INPUT_RESULT:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_FBS_DRAW_INPUT_RESULT");
            break;
        case INM_TYPE_O_FBS_DRAW_CONFIRM:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_FBS_DRAW_CONFIRM");
            break;

        // zot -----------------------------------------------------------------
        //tfe
        case INM_TYPE_TFE_CHECK_POINT:
            sprintf(dump_type_buf, "%s", "INM_TYPE_TFE_CHECK_POINT");
            break;
        //system business state
        case INM_TYPE_SYS_BUSINESS_STATE:
            sprintf(dump_type_buf, "%s", "INM_TYPE_SYS_BUSINESS_STATE");
            break;
        //system
        case INM_TYPE_SYS_SWITCH_SESSION:
            sprintf(dump_type_buf, "%s", "INM_TYPE_SYS_SWITCH_SESSION");
            break;
        //rng 状态改变消息
        case INM_TYPE_RNG_STATUS:
            sprintf(dump_type_buf, "%s", "INM_TYPE_RNG_STATUS");
            break;

        //game issue state
        case INM_TYPE_ISSUE_STATE_PRESALE:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_PRESALE");
            INM_MSG_ISSUE_PRESALE *pInm = (INM_MSG_ISSUE_PRESALE *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_STATE_OPEN:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_OPEN");
            INM_MSG_ISSUE_OPEN *pInm = (INM_MSG_ISSUE_OPEN *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        /*
        case INM_TYPE_ISSUE_STATE_CLOSING:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_CLOSING");
            INM_MSG_ISSUE_CLOSING *pInm = (INM_MSG_ISSUE_CLOSING *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        */
        case INM_TYPE_ISSUE_STATE_CLOSED:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_CLOSED");
            INM_MSG_ISSUE_CLOSE *pInm = (INM_MSG_ISSUE_CLOSE *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_STATE_SEALED:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_SEALED");
            INM_MSG_ISSUE_STATE *pInm = (INM_MSG_ISSUE_STATE *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_STATE_DRAWNUM_INPUTED:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_DRAWNUM_INPUTED");
            INM_MSG_ISSUE_DRAWNUM_INPUTE *pInm = (INM_MSG_ISSUE_DRAWNUM_INPUTE *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_STATE_MATCHED:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_MATCHED");
            INM_MSG_ISSUE_STATE *pInm = (INM_MSG_ISSUE_STATE *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_STATE_FUND_INPUTED:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_FUND_INPUTED");
            INM_MSG_ISSUE_FUND_INPUTE *pInm = (INM_MSG_ISSUE_FUND_INPUTE *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_STATE_LOCAL_CALCED:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_LOCAL_CALCED");
            INM_MSG_ISSUE_WLEVEL *pInm = (INM_MSG_ISSUE_WLEVEL *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_STATE_PRIZE_ADJUSTED:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_PRIZE_ADJUSTED");
            INM_MSG_ISSUE_WLEVEL *pInm = (INM_MSG_ISSUE_WLEVEL *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_STATE_PRIZE_CONFIRMED:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_PRIZE_CONFIRMED");
            INM_MSG_ISSUE_STATE *pInm = (INM_MSG_ISSUE_STATE *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_STATE_DB_IMPORTED:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_DB_IMPORTED");
            INM_MSG_ISSUE_STATE *pInm = (INM_MSG_ISSUE_STATE *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_STATE_ISSUE_END:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_STATE_ISSUE_END");
            INM_MSG_ISSUE_STATE *pInm = (INM_MSG_ISSUE_STATE *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_SALE_FILE_MD5SUM:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_SALE_FILE_MD5SUM");
            INM_MSG_ISSUE_SALE_FILE_MD5SUM *pInm = (INM_MSG_ISSUE_SALE_FILE_MD5SUM *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_DRAW_REDO:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_DRAW_REDO");
            INM_MSG_ISSUE_DRAW_REDO *pInm = (INM_MSG_ISSUE_DRAW_REDO *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }
        case INM_TYPE_ISSUE_SECOND_DRAW:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_ISSUE_SECOND_DRAW");
            INM_MSG_ISSUE_SECOND_DRAW *pInm = (INM_MSG_ISSUE_SECOND_DRAW *)inm_buf;
            sprintf(dump_buf, "game[%d] issueNumber[%lld]", pInm->gameCode, pInm->issueNumber);
            break;
        }


        // OMS -----------------------------------------------------------------
        case INM_TYPE_O_HB:
            return;
            //sprintf(dump_type_buf, "%s", "INM_TYPE_O_HB");
            //break;
        case INM_TYPE_O_ECHO:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_ECHO");
            break;
        case INM_TYPE_O_COMMON:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_COMMON");
            break;

        case INM_TYPE_O_GL_POLICY_PARAM:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_POLICY_PARAM");
            break;
        case INM_TYPE_O_GL_RULE_PARAM:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_RULE_PARAM");
            break;
        case INM_TYPE_O_GL_CTRL_PARAM:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_CTRL_PARAM");
            break;
        case INM_TYPE_O_GL_RISK_CTRL_PARAM:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_RISK_CTRL_PARAM");
            break;
        case INM_TYPE_O_GL_SALE_CTRL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_SALE_CTRL");
            break;
        case INM_TYPE_O_GL_PAY_CTRL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_PAY_CTRL");
            break;
        case INM_TYPE_O_GL_CANCEL_CTRL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_CANCEL_CTRL");
            break;
        case INM_TYPE_O_GL_AUTO_DRAW:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_AUTO_DRAW");
            break;
        case INM_TYPE_O_GL_SERVICE_TIME:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_SERVICE_TIME");
            break;
        case INM_TYPE_O_GL_WARN_THRESHOLD:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_WARN_THRESHOLD");
            break;

        case INM_TYPE_O_GL_ISSUE_ADD_NFY:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_ISSUE_ADD_NFY");
            break;
        case INM_TYPE_O_GL_ISSUE_DEL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_GL_ISSUE_DEL");
            break;

        case INM_TYPE_O_PAY_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_PAY_TICKET");
            break;
        case INM_TYPE_O_CANCEL_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_CANCEL_TICKET");
            break;
        case INM_TYPE_O_INQUIRY_TICKET:
        {
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_INQUIRY_TICKET");
            INM_MSG_O_INQUIRY_TICKET *pInm = (INM_MSG_O_INQUIRY_TICKET *)inm_buf;
            sprintf(dump_buf, "status [%hu] tsn [%s]", pInm->header.inm_header.status, pInm->rspfn_ticket);
            break;
        }

        /*
        case INM_TYPE_O_TMS_AREA_ADD:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AREA_ADD");
            break;
        case INM_TYPE_O_TMS_AREA_MDY:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AREA_MDY");
            break;
        case INM_TYPE_O_TMS_AREA_DELETE:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AREA_DELETE");
            break;
        case INM_TYPE_O_TMS_AREA_AGENCY_GAMECTRL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AREA_AGENCY_GAMECTRL");
            break;
        case INM_TYPE_O_TMS_AREA_RESET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AREA_RESET");
            break;
        case INM_TYPE_O_TMS_AREA_GAME:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AREA_GAME");
            break;
        case INM_TYPE_O_TMS_AREA_MESSAGE:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AREA_MESSAGE");
            break;

        case INM_TYPE_O_TMS_AGENCY_ADD:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AGENCY_ADD");
            break;
        case INM_TYPE_O_TMS_AGENCY_MDY:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AGENCY_MDY");
            break;
        case INM_TYPE_O_TMS_AGENCY_STATUS_CTRL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AGENCY_STATUS_CTRL");
            break;
        case INM_TYPE_O_TMS_AGENCY_MARGINALCREDIT:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AGENCY_MARGINALCREDIT");
            break;
        case INM_TYPE_O_TMS_AGENCY_CLR:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AGENCY_CLR");
            break;

        case INM_TYPE_O_TMS_TERM_ADD:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_TERM_ADD");
            break;
        case INM_TYPE_O_TMS_TERM_MDY:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_TERM_MDY");
            break;
        case INM_TYPE_O_TMS_TERM_STATUS_CTRL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_TERM_STATUS_CTRL");
            break;

        case INM_TYPE_O_TMS_TELLER_ADD:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_TELLER_ADD");
            break;
        case INM_TYPE_O_TMS_TELLER_MDY:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_TELLER_MDY");
            break;
        case INM_TYPE_O_TMS_TELLER_STATUS_CTRL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_TELLER_STATUS_CTRL");
            break;
        case INM_TYPE_O_TMS_TELLER_RESET_PWD:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_TELLER_RESET_PWD");
            break;

        case INM_TYPE_O_TMS_AGNECY_DEPOSITAMOUNT:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_AGNECY_DEPOSITAMOUNT");
            break;

        case INM_TYPE_O_TMS_VERSION_ADD:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_VERSION_ADD");
            break;
        case INM_TYPE_O_TMS_VERSION_MDY:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_VERSION_MDY");
            break;
        case INM_TYPE_O_TMS_VERSION_STATUS_CTRL:
            sprintf(dump_type_buf, "%s", "INM_TYPE_O_TMS_VERSION_STATUS_CTRL");
            break;
			
		*/

        //FBS
        case INM_TYPE_FBS_INQUIRY_WIN_TICKET:
            sprintf(dump_type_buf, "%s", "INM_TYPE_FBS_INQUIRY_WIN_TICKET");
            break;


        default:
            sprintf(dump_type_buf, "%s", "Unknown_INM_TYPE");
            break;
    }
    static char when[64];
    fmt_time_t(header->tfe_when, DATETIME_FORMAT_EX_EN, when);
    log_debug("Inm Message -> %s <%d> File[%d] Offset[%d] When[%s] [%s]",
        dump_type_buf, header->type, header->tfe_file_idx, header->tfe_offset, when, dump_buf);
}



#endif //INM_MESSAGE_H_INCLUDED


