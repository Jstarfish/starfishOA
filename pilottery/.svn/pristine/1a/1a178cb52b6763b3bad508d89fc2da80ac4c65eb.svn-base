#ifndef INM_MESSAGE_AP_H_INCLUDED
#define INM_MESSAGE_AP_H_INCLUDED


//指定按1字节对齐
#pragma pack (1)

typedef struct _INM_MSG_AP_PAY_TICKET
{
    INM_MSG_T_HEADER  header;

    uint8    flag;  // 0: long tsn    1: short digit tsn

    char     reqfn_ticket_pay[TSN_LENGTH];   //兑奖交易请求流水号
    char     rspfn_ticket_pay[TSN_LENGTH];   //兑奖交易响应流水号
    char     reqfn_ticket_sell[TSN_LENGTH];  //彩票交易请求流水号
    char     rspfn_ticket_sell[TSN_LENGTH];  //销售交易响应流水号
    uint64   unique_tsn;
    uint64   unique_tsn_pay;

    uint8    game_code;                     //游戏编码
    uint64   issue;
    money_t  ticketAmount;
    money_t  winningAmountWithTax;          //中奖金额(税前)
    money_t  taxAmount;                     //税金
    money_t  winningAmount;                 //中奖金额税后

    uint32   winningCount;                  //中奖总注数
    money_t  hd_winning;                    //高等奖兑奖金额
    uint32   hd_count;                      //高等奖兑奖注数
    money_t  ld_winning;                    //低等奖兑奖金额
    uint32   ld_count;                      //低等奖兑奖注数
    uint8    isBigWin;

    uint32   area_code;                     //中心兑奖区域编码
    uint64   agency_code;                   //站点编码

}INM_MSG_AP_PAY_TICKET;

typedef struct _INM_MSG_AP_PAY_OVER
{
    INM_MSG_T_HEADER  header;
    uint8    game_code;
    uint64   issue;
}INM_MSG_AP_PAY_OVER;

typedef struct _INM_MSG_AP_ONE_END_ISSUE
{
    uint64   issue;
    uint32   issueSeq;
    uint8    status;
    time_type startTime;
    time_type endTime;
    char      drawNumber[MAX_GAME_RESULTS_STR_LEN];
    time_type drawTime;
}INM_MSG_AP_ONE_END_ISSUE;

typedef struct _INM_MSG_AP_CURR_ISSUE
{
    INM_MSG_T_HEADER  header;
    uint8    game_code;
    uint8    count;
    INM_MSG_AP_ONE_END_ISSUE issues[];

}INM_MSG_AP_CURR_ISSUE;


typedef struct _INM_MSG_AP_ONE_PRESALE_ISSUE
{
    uint64   issue;
    uint32   issueSeq;
    uint8    status;
    time_type startTime;
    time_type endTime;
}INM_MSG_AP_ONE_PRESALE_ISSUE;

typedef struct _INM_MSG_AP_ALL_PRESALE_ISSUES
{
    INM_MSG_T_HEADER  header;
    uint8    game_code;
    uint8    count;
    INM_MSG_AP_ONE_PRESALE_ISSUE issues[];
}INM_MSG_AP_ALL_PRESALE_ISSUES;

//取消指定对齐，恢复缺省对齐
#pragma pack ()



#endif //INM_MESSAGE_NCP_H_INCLUDED

