#ifndef INM_MESSAGE_AP_H_INCLUDED
#define INM_MESSAGE_AP_H_INCLUDED


//ָ����1�ֽڶ���
#pragma pack (1)

typedef struct _INM_MSG_AP_PAY_TICKET
{
    INM_MSG_T_HEADER  header;

    uint8    flag;  // 0: long tsn    1: short digit tsn

    char     reqfn_ticket_pay[TSN_LENGTH];   //�ҽ�����������ˮ��
    char     rspfn_ticket_pay[TSN_LENGTH];   //�ҽ�������Ӧ��ˮ��
    char     reqfn_ticket_sell[TSN_LENGTH];  //��Ʊ����������ˮ��
    char     rspfn_ticket_sell[TSN_LENGTH];  //���۽�����Ӧ��ˮ��
    uint64   unique_tsn;
    uint64   unique_tsn_pay;

    uint8    game_code;                     //��Ϸ����
    uint64   issue;
    money_t  ticketAmount;
    money_t  winningAmountWithTax;          //�н����(˰ǰ)
    money_t  taxAmount;                     //˰��
    money_t  winningAmount;                 //�н����˰��

    uint32   winningCount;                  //�н���ע��
    money_t  hd_winning;                    //�ߵȽ��ҽ����
    uint32   hd_count;                      //�ߵȽ��ҽ�ע��
    money_t  ld_winning;                    //�͵Ƚ��ҽ����
    uint32   ld_count;                      //�͵Ƚ��ҽ�ע��
    uint8    isBigWin;

    uint32   area_code;                     //���Ķҽ��������
    uint64   agency_code;                   //վ�����

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

//ȡ��ָ�����룬�ָ�ȱʡ����
#pragma pack ()



#endif //INM_MESSAGE_NCP_H_INCLUDED

