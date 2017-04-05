#ifndef INM_MESSAGE_COMMON_H_INCLUDED
#define INM_MESSAGE_COMMON_H_INCLUDED



//指定按1字节对齐
#pragma pack (1)



//日结切换的tf记录
typedef struct _INM_MSG_SYS_SWITCH_SESSION
{
    INM_MSG_HEADER          header;
    uint32                  curSession; //20131103
    uint32                  newSession; //20131104
}INM_MSG_SYS_SWITCH_SESSION;

//RNG状态改变消息 INM_TYPE_RNG_STATUS
typedef struct _INM_MSG_RNG_STATUS
{
    INM_MSG_HEADER          header;
    uint32                  rngId;
    uint8                   workStatus; //0=未连接  1=已连接 2=正常工作
}INM_MSG_RNG_STATUS;

// -------------------------------------------------------------------------------------------------



//期次预售
typedef struct _INM_MSG_ISSUE_PRESALE
{
    INM_MSG_HEADER          header;
    uint8                   gameCode;
    uint64                  issueNumber;
    uint32 					serialNumber;
    time_type               startTime;         // time when issue status is ISSUE_STATE_OPENED
    time_type               closeTime;         // time when issue status is ISSUE_STATE_CLOSED
    time_type               awardTime;         // time when issue status is ISSUE_STATE_DRAWNUM_INPUTED
    uint32					payEndDay;
}INM_MSG_ISSUE_PRESALE;


//期次开始
typedef struct _INM_MSG_ISSUE_OPEN
{
    INM_MSG_HEADER          header;
    uint8                   gameCode;
    uint64                  issueNumber;
    uint32 					serialNumber;
    time_type               startTime;
    uint32                  issueTimeSpan;          // 期长 （秒数）
}INM_MSG_ISSUE_OPEN;


//期次即将关闭
/*
typedef struct _INM_MSG_ISSUE_CLOSING
{
    INM_MSG_HEADER          header;
    uint8                   gameCode;
    uint64                  issueNumber;
    uint32 					serialNumber;
    time_type               closingTime;
    uint16                  seconds;               //倒数秒数
}INM_MSG_ISSUE_CLOSING;
*/

//期次关闭
typedef struct _INM_MSG_ISSUE_CLOSE
{
    INM_MSG_HEADER          header;
    uint8                   gameCode;
    uint64                  issueNumber;
    uint32 					serialNumber;
    time_type               closeTime;
    money_t					refuseAmount;
    uint32 					refuseCount;
}INM_MSG_ISSUE_CLOSE;


//期次状态
typedef struct _INM_MSG_ISSUE_STATE
{
    INM_MSG_HEADER          header;
    uint8                   gameCode;
    uint64                  issueNumber;
    uint8                   drawTimes; //第几次开奖
}INM_MSG_ISSUE_STATE;


//期次开奖(多次开奖) <INM_TYPE_ISSUE_SECOND_DRAW>
typedef struct _INM_MSG_ISSUE_SECOND_DRAW
{
    INM_MSG_HEADER          header;
    uint8                   gameCode;
    uint64                  issueNumber;//期号(对此期次进行再次开奖，前提为: 第一次开奖正常完成)
    uint8                   drawTimes;  //第几次开奖
}INM_MSG_ISSUE_SECOND_DRAW;



//开奖号码录入 <INM_TYPE_ISSUE_STATE_DRAWNUM_INPUTED>
typedef struct _INM_MSG_ISSUE_DRAWNUM_INPUTE
{
    INM_MSG_HEADER          header;
    uint8                   gameCode;
    uint64                  issueNumber;
    uint8                   drawTimes; //第几次开奖

    uint8                   count; //开奖结果个数
    uint8                   drawCodes[64];
    char                    drawCodesStr[MAX_GAME_RESULTS_STR_LEN];
    uint32                  timeStamp;
}INM_MSG_ISSUE_DRAWNUM_INPUTE;


//高等奖金总额、奖金池总额、调节基金总额、发行基金总额   已录入
typedef struct _POOL_AMOUNT
{
    char poolName[ENTRY_NAME_LEN];
    money_t poolAmount; //奖池可用金额
}POOL_AMOUNT;
typedef struct _INM_MSG_FUND_INPUTE
{
    INM_MSG_HEADER          header;
    uint8                   gameCode;
    uint64                  issueNumber;
    uint8                   drawTimes;              //第几次开奖

    POOL_AMOUNT             pool;                   // 奖池
    money_t                 adjustMoneyAmount;      // 调节基金总额
    money_t                 publishMoneyAmount;     // 发行基金总额
}INM_MSG_ISSUE_FUND_INPUTE;


//销售文件MD5值 <INM_TYPE_ISSUE_SALE_FILE_MD5SUM>
typedef struct _INM_MSG_ISSUE_SALE_FILE_MD5SUM
{
    INM_MSG_HEADER          header;
    uint8                   gameCode;
    uint64                  issueNumber;
    uint8                   drawTimes;   //第几次开奖
    uint8                   md5sum[32];
}INM_MSG_ISSUE_SALE_FILE_MD5SUM;


//重新开奖(放弃当前的开奖流程，本期次需要重新开奖)
typedef struct _INM_MSG_ISSUE_DRAW_REDO
{
    INM_MSG_HEADER          header;
    uint8                   gameCode;
    uint64                  issueNumber;
    uint8                   drawTimes; //第几次开奖
} INM_MSG_ISSUE_DRAW_REDO;


//本地算奖奖级结构体
typedef struct _PRIZE_LEVEL
{
    uint8      prize_code;
    int32      hflag;         //是否高等奖
    uint32     count;         //中奖注数
    money_t    money_amount;  //单注金额
}PRIZE_LEVEL;

//本地算奖 <INM_TYPE_ISSUE_STATE_PRIZE_ADJUSTED>
typedef struct _INM_MSG_ISSUE_WLEVEL
{
    INM_MSG_HEADER          header;
    uint8                   gameCode;
    uint64                  issueNumber;
    uint8                   drawTimes; //第几次开奖

    money_t                 poolAmount;
    uint32                  count;
    PRIZE_LEVEL             prize_list[];
}INM_MSG_ISSUE_WLEVEL;



//取消指定对齐，恢复缺省对齐
#pragma pack ()


#endif //INM_MESSAGE_COMMON_H_INCLUDED

