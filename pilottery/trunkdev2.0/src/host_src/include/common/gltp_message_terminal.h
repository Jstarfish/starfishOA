#ifndef GLTP_MESSAGE_TERMINAL_H_INCLUDED
#define GLTP_MESSAGE_TERMINAL_H_INCLUDED


//------------------------------------------------------------------------------
//�ն˻���Ϣ����
//------------------------------------------------------------------------------
typedef enum _GLTP_MSG_TERMINAL_TYPE {
    //����
    GLTP_T_HB                       = 0,

    //ECHO
    GLTP_T_ECHO_REQ                 = 1,
    GLTP_T_ECHO_RSP                 = 2,

    //������ʱ����
    GLTP_T_NETWORK_DELAY_REQ        = 3,
    GLTP_T_NETWORK_DELAY_RSP        = 4,

    //��֤
    GLTP_T_AUTH_REQ                 = 3001,
    GLTP_T_AUTH_RSP                 = 3002,

    //��Ϸ��Ϣ����
    GLTP_T_GAME_INFO_REQ            = 3003,
    GLTP_T_GAME_INFO_RSP            = 3004,

    //��Ʊ����
    GLTP_T_SELL_TICKET_REQ          = 3005,
    GLTP_T_SELL_TICKET_RSP          = 3006,

    //��Ʊ��ѯ
    GLTP_T_INQUIRY_TICKET_REQ       = 3007,
    GLTP_T_INQUIRY_TICKET_RSP       = 3008,

    //��Ʊ�ҽ�
    GLTP_T_PAY_TICKET_REQ           = 3009,
    GLTP_T_PAY_TICKET_RSP           = 3010,

    //��Ʊȡ��
    GLTP_T_CANCEL_TICKET_REQ        = 3011,
    GLTP_T_CANCEL_TICKET_RSP        = 3012,

    //����Ա��¼
    GLTP_T_SIGNIN_REQ               = 3013,
    GLTP_T_SIGNIN_RSP               = 3014,

    //����Աǩ��
    GLTP_T_SIGNOUT_REQ              = 3015,
    GLTP_T_SIGNOUT_RSP              = 3016,

    //����Ա�޸�����
    GLTP_T_CHANGE_PWD_REQ           = 3017,
    GLTP_T_CHANGE_PWD_RSP           = 3018,

    //����վ����ѯ
    GLTP_T_AGENCY_BALANCE_REQ       = 3019,
    GLTP_T_AGENCY_BALANCE_RSP       = 3020,

    //��Ϸ��ǰ�ڴ���Ϣ��ѯ
    GLTP_T_GAME_ISSUE_REQ           = 3023,
    GLTP_T_GAME_ISSUE_RSP           = 3024,

    //��Ʊ�н���ѯ
    GLTP_T_INQUIRY_WIN_REQ          = 3025,
    GLTP_T_INQUIRY_WIN_RSP          = 3026,


    // FBS   ������Ϣ��ѯ
    GLTP_FBS_INQUIRY_MATCH_REQ      = 3061,
    GLTP_FBS_INQUIRY_MATCH_RSP      = 3062,

}GLTP_MSG_TERMINAL_TYPE;


//------------------------------------------------------------------------------
//�ն˻��㲥��Ϣ��
//------------------------------------------------------------------------------
typedef enum _GLTP_MSG_TERMINAL_UNS_TYPE
{
    //����Ϸ
    GLTP_T_UNS_OPEN_GAME            = 4001,

    //��Ϸ�رյ���ʱ
    GLTP_T_UNS_CLOSE_SECONDS        = 4002,

    //�ر���Ϸ
    GLTP_T_UNS_CLOSE_GAME           = 4003,

    //��Ϸ��������
    GLTP_T_UNS_DRAW_ANNOUNCE        = 4004,

    //�ն˻�����
    GLTP_T_UNS_RESET                = 4005,

    //֪ͨ��Ϣ
    GLTP_T_UNS_MESSAGE              = 4006,

}GLTP_MSG_TERMINAL_UNS_TYPE;



//ָ����1�ֽڶ���
#pragma pack (1)


typedef struct _GLTP_MSG_T_HEADER
{
    //GLTP_MSG_HEADER
    uint16  length;        //��Ϣ����
    uint8   type;          //��Ϣ����
    uint16  func;          //��Ϣ����
    uint32  when;          //ʱ���(����)

    uint64  token;
    uint32  identify;      //for ncp socket identify
    uint32  msn;           //�������к�
    uint16  param;         //����: ��ѵƱ(1)

    uint16  status;        //��Ϣ����״̬

    char data[];
}GLTP_MSG_T_HEADER;
#define GLTP_MSG_T_HEADER_LEN sizeof(GLTP_MSG_T_HEADER)


//------------------------------------------------------------------------------
//�ն���������/��Ӧ��Ϣ(0) <GLTP_T_HB>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_HB
{
    GLTP_MSG_T_HEADER  header;
    uint16  crc;
}GLTP_MSG_T_HB;


//------------------------------------------------------------------------------
//ҵ����ʧ�ܵ�ͨ����Ӧ��Ϣ
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_ERR_RSP
{
    GLTP_MSG_T_HEADER header;
    uint32  timeStamp;
    uint16  crc;
}GLTP_MSG_T_ERR_RSP;


//------------------------------------------------------------------------------
//ECHO����/��Ӧ��Ϣ(1/2) <GLTP_T_ECHO_REQ/GLTP_T_ECHO_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_ECHO_REQ
{
    GLTP_MSG_T_HEADER header;
    uint32  echo_len;
    char    echo_str[];  //���ɳ���128�ֽ�
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
//������ʱ��������/��Ӧ��Ϣ(3/4) <GLTP_T_NETWORK_DELAY_REQ/GLTP_T_NETWORK_DELAY_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_NETWORK_DELAY_REQ
{
    GLTP_MSG_T_HEADER header;
    uint32  delayMilliSeconds;  //�ն��յ���һ�������ʱ��Ϣ���ӳٺ�����(�ն����Ӻ��һ�������ʱ��Ϣ���ֶ���0)
    uint16  crc;
}GLTP_MSG_T_NETWORK_DELAY_REQ;

typedef struct _GLTP_MSG_T_NETWORK_DELAY_RSP
{
    GLTP_MSG_T_HEADER header;
    uint16  crc;
}GLTP_MSG_T_NETWORK_DELAY_RSP;


//------------------------------------------------------------------------------
//�ն���֤����/��Ӧ��Ϣ(3001/3002) <GLTP_T_AUTH_REQ/GLTP_T_AUTH_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_AUTH_REQ
{
    GLTP_MSG_T_HEADER  header;
    uint8   mac[6];
    char    version[16]; //�ն˵�ǰ�����汾
    uint16  crc;
}GLTP_MSG_T_AUTH_REQ;

typedef struct _GLTP_MSG_T_AUTH_RSP
{
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    uint64  terminalCode; //�ն˱���
    uint64  agencyCode;   //վ�����
    uint16  areaCode;     //�������
    uint16  crc;
}GLTP_MSG_T_AUTH_RSP;


//------------------------------------------------------------------------------
//��Ϸ��Ϣ����/��Ӧ��Ϣ(3003/3004) <GLTP_T_GAME_INFO_REQ/GLTP_T_GAME_INFO_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_GAME_INFO_REQ
{
    GLTP_MSG_T_HEADER  header;

    uint16  crc;
}GLTP_MSG_T_GAME_INFO_REQ;

typedef struct _GAME_INFO
{
    uint8   gameCode;               //��Ϸ����
    char    singleAmount[256];      //��עͶע����ַ���
    money_t maxAmountPerTicket;     //��Ʊ�����
    uint16  maxBetTimes;            //ÿͶע�����Ͷע����
    uint8   maxIssueCount;          //��Ʊ��������������
    uint64  currentIssueNumber;     //��ǰ�ں�
    uint32  currentIssueCloseTime;  //��ǰ�ڹر�ʱ��
}GAME_INFO;

typedef struct _GLTP_MSG_T_GAME_INFO_RSP
{
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    char    contactAddress[AGENCY_ADDRESS_LENGTH];     //վ����ϵ��ַ
    char    contactPhone[24];                          //վ����ϵ�绰
    char    ticketSlogan[TICKET_SLOGAN_LENGTH];        //��ƱƱ��������

    uint8   gameCount;                                 //��Ϸ����
    GAME_INFO gameArray[];
    //uint16  crc;
}GLTP_MSG_T_GAME_INFO_RSP;


//------------------------------------------------------------------------------
//��Ϸ��ǰ�ڴ���Ϣ����/��Ӧ��Ϣ(3023/3024) <GLTP_T_GAME_ISSUE_REQ/GLTP_T_GAME_ISSUE_RSP>
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

    uint8   gameCode;          //��Ϸ����
    uint64  issueNumber;       //��ǰ�ں�
    uint32  issueStartTime;    //�ڿ�ʼʱ��
    uint32  issueLength;       //�ڳ�
    uint32  countDownSeconds;  //�ڹرյ���ʱ����
    uint16  crc;
}GLTP_MSG_T_GAME_ISSUE_RSP;


//------------------------------------------------------------------------------
//��Ʊ��������/��Ӧ��Ϣ(3005/3006) <GLTP_T_SELL_TICKET_REQ/GLTP_T_SELL_TICKET_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_SELL_TICKET_REQ
{
    GLTP_MSG_T_HEADER  header;

    char    loyaltyNum[LOYALTY_CARD_LENGTH];  //��Ա����

    uint16  betStringLen;                     //Ͷע�ַ�������
    char    betString[];                      //Ͷע�ַ���

    //uint16  crc;
}GLTP_MSG_T_SELL_TICKET_REQ;

typedef struct _GLTP_MSG_T_SELL_TICKET_RSP
{
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    char    rspfn_ticket[TSN_LENGTH];   //��Ʊ��Ӧ������ˮ��

    money_t availableCredit;            //���������(�������ö�Ⱥ���ʱ���ö��)

    uint8   gameCode;
    uint64  currentIssueNumber;         //���׵�ǰ���ں�
    uint64  flowNumber;                 //�ն˽���ҵ�����
    uint32  transTimeStamp;             //����ʱ��
    money_t transAmount;                //���׽��
    uint32  drawTimeStamp;              //����ʱ��
    uint16  crc;
}GLTP_MSG_T_SELL_TICKET_RSP;


//------------------------------------------------------------------------------
//��Ʊ��ѯ����/��Ӧ��Ϣ(3007/3008) <GLTP_T_INQUIRY_TICKET_REQ/GLTP_T_INQUIRY_TICKET_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_INQUIRY_TICKET_REQ {
    GLTP_MSG_T_HEADER  header;

    char    rspfn_ticket[TSN_LENGTH];
    uint16  crc;
}GLTP_MSG_T_INQUIRY_TICKET_REQ;

typedef struct _GLTP_MSG_T_INQUIRY_TICKET_RSP {
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    char    rspfn_ticket[TSN_LENGTH];   //Ʊ��

    uint8   gameCode;                   //��Ϸ����

    uint16  betStringLen;               //Ͷע�ַ�������
    char    betString[];                //Ͷע�ַ���
    //uint16  crc;
}GLTP_MSG_T_INQUIRY_TICKET_RSP;


//------------------------------------------------------------------------------
//��Ʊ�ҽ�����/��Ӧ��Ϣ(3009/3010) <GLTP_T_PAY_TICKET_REQ/GLTP_T_PAY_TICKET_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_PAY_TICKET_REQ {
    GLTP_MSG_T_HEADER  header;

    char    rspfn_ticket[TSN_LENGTH];               //������ˮ��

    char    loyaltyNum[LOYALTY_CARD_LENGTH];        //��Ա����
    char    identityNumber[IDENTITY_CARD_LENGTH];   //����֤����
    uint16  crc;
}GLTP_MSG_T_PAY_TICKET_REQ;

typedef struct _GLTP_MSG_T_PAY_TICKET_RSP {
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    char    rspfn_ticket_pay[TSN_LENGTH]; //�ҽ���Ӧ������ˮ��
    char    rspfn_ticket[TSN_LENGTH];     //Ʊ��

    money_t availableCredit;              //���������(�������ö�Ⱥ���ʱ���ö��)

    uint8   gameCode;
    uint64  flowNumber;                   //�ն˽���ҵ�����
    money_t winningAmountWithTax;         //�н����(˰ǰ)
    money_t taxAmount;                    //˰��
    money_t winningAmount;                //�н����˰��
    uint32  transTimeStamp;               //����ʱ��

    uint16  crc;
}GLTP_MSG_T_PAY_TICKET_RSP;


//------------------------------------------------------------------------------
//��Ʊȡ������/��Ӧ��Ϣ(3011/3012) <GLTP_T_CANCEL_TICKET_REQ/GLTP_T_CANCEL_TICKET_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_CANCEL_TICKET_REQ {
    GLTP_MSG_T_HEADER  header;

    char    rspfn_ticket[TSN_LENGTH];         //������ˮ��

    char    loyaltyNum[LOYALTY_CARD_LENGTH];  //��Ա����
    uint16  crc;
}GLTP_MSG_T_CANCEL_TICKET_REQ;

typedef struct _GLTP_MSG_T_CANCEL_TICKET_RSP {
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    char    rspfn_ticket_cancel[TSN_LENGTH]; //��Ʊ��Ӧ������ˮ��
    char    rspfn_ticket[TSN_LENGTH];        //Ʊ��

    money_t availableCredit;                 //���������(�������ö�Ⱥ���ʱ���ö��)

    uint8   gameCode;
    uint64  flowNumber;                      //�ն˽���ҵ�����
    uint32  transTimeStamp;                  //����ʱ��
    money_t cancelAmount;                    //ȡ�����
    uint16  crc;
}GLTP_MSG_T_CANCEL_TICKET_RSP;


//------------------------------------------------------------------------------
//����Ա��¼����/��Ӧ��Ϣ(3013/3014) <GLTP_T_SIGNIN_REQ/GLTP_T_SIGNIN_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_SIGNIN_REQ
{
    GLTP_MSG_T_HEADER  header;

    uint32  tellerCode;               //����Ա����
    char    password[PWD_MD5_LENGTH]; //����Ա����
    uint16  crc;
}GLTP_MSG_T_SIGNIN_REQ;

typedef struct _GLTP_MSG_T_SIGNIN_RSP
{
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    uint32  tellerCode;             //����Ա����
    uint8   tellerType;             //����Ա����
    money_t availableCredit;        //���������(�������ö�Ⱥ���ʱ���ö��)
    uint8   forceModifyPwd;         //ǿ���޸�������
    uint64  flowNumber;             //�ն˽���ҵ�����
    uint32  exchangeRate;           //����(�������Ԫ)
    uint16  crc;
}GLTP_MSG_T_SIGNIN_RSP;


//------------------------------------------------------------------------------
//����Աǩ������/��Ӧ��Ϣ(3015/3016) <GLTP_T_SIGNOUT_REQ/GLTP_T_SIGNOUT_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_SIGNOUT_REQ
{
    GLTP_MSG_T_HEADER  header;

    uint32  tellerCode;             //����Ա����
    uint8   type;                   //ǩ������ ����0 �� ǿ��1
    uint16  crc;
}GLTP_MSG_T_SIGNOUT_REQ;

typedef struct _GLTP_MSG_T_SIGNOUT_RSP
{
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    uint16  crc;
}GLTP_MSG_T_SIGNOUT_RSP;


//------------------------------------------------------------------------------
//����Ա�޸���������/��Ӧ��Ϣ(3017/3018) <GLTP_T_CHANGE_PWD_REQ/GLTP_T_CHANGE_PWD_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_CHANGE_PWD_REQ {
    GLTP_MSG_T_HEADER  header;

    uint32  tellerCode;                  //����Ա����
    char    oldPassword[PWD_MD5_LENGTH]; //����Աԭ����
    char    newPassword[PWD_MD5_LENGTH]; //����Ա������
    uint16  crc;
}GLTP_MSG_T_CHANGE_PWD_REQ;

typedef struct _GLTP_MSG_T_CHANGE_PWD_RSP {
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    uint16  crc;
}GLTP_MSG_T_CHANGE_PWD_RSP;


//------------------------------------------------------------------------------
//����վ����ѯ����/��Ӧ��Ϣ(3019/3020) <GLTP_T_AGENCY_BALANCE_REQ/GLTP_T_AGENCY_BALANCE_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_AGENCY_BALANCE_REQ {
    GLTP_MSG_T_HEADER  header;

    uint16  crc;
}GLTP_MSG_T_AGENCY_BALANCE_REQ;

typedef struct _GLTP_MSG_T_AGENCY_BALANCE_RSP {
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    uint64  agencyCode;             //����վ����

    money_t availableCredit;        //���������(�˻���� + ���ö��)
    money_t accountBalance;         //�˻����
    money_t marginalCreditLimit;    //���ö��
    uint16  crc;
}GLTP_MSG_T_AGENCY_BALANCE_RSP;


//------------------------------------------------------------------------------
//��Ʊ�н���ѯ����/��Ӧ��Ϣ(3025/3026) <GLTP_T_INQUIRY_WIN_REQ/GLTP_T_INQUIRY_WIN_RSP>
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

    uint8   gameCode;                       //��Ϸ����

    uint8   isBigPrize;                     //�Ƿ��Ǵ�

    uint64  amountBeforeTax;                //�н����(˰ǰ)
    uint64  taxAmount;                      //˰��
    uint64  amountAfterTax;                 //�н����(˰��)

    uint8   isPayed;                        //�Ƿ��Ѷҽ�:δ�ҽ�(0) �Ѷҽ�(1)
    uint16  crc;
}GLTP_MSG_T_INQUIRY_WIN_RSP;




//------------------------------------------------------------------------------
// FBS ����������Ϣ��ѯ����/��Ӧ��Ϣ(3061/3062) <GLTP_FBS_INQUIRY_MATCH_REQ/GLTP_FBS_INQUIRY_MATCH_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_T_FBS_MATCH_INFO_REQ
{
    GLTP_MSG_T_HEADER  header;

    uint8 gameCode;
    uint16  crc;
}GLTP_MSG_T_FBS_MATCH_INFO_REQ;

typedef struct _FBS_MATCH_INFO
{
    uint32 match_code; //match code  ȫ��Ψһ 150930999
    uint32 seq; //match sequence number in one issue  ��һ������Ψһ
    //uint8  status; // enabled or disabled
    uint8  subtype_status[FBS_SUBTYPE_NUM]; //����ⳡ�����Ƿ���������淨 value 0,1
    uint32 competition;
    uint32 round; //�����ڼ���
    uint16    home_code;
    //char   home_term[256]; //��������
    uint16    away_code;
    //char   away_term[256]; //�Ͷ�����
    uint32 date; //�������� 20130312
    //char   venue[256]; //match address �����ص�
    uint32 match_time; //match start time ����ʱ��
    //time_t result_time; //get result time �õ��������ʱ��
    //time_t draw_time; //draw complete time �����������ʱ��

    uint32 sale_time; //begin sale time ��ʼ����ʱ��
    uint32 close_time; //stop sale time ��ֹ����ʱ��

    uint32 state; //����״̬  (MATCH_STATE)

    //mathc home team handicap result sets
    int32  home_handicap; //ʤƽ�� (����������) ����Ϊ���������� ����Ϊ�Ͷ�������
    int32  home_handicap_point5; //ʤ�� (���������� 0.5 1.5 2.5 -0.5 -1.5 -2.5) ����Ϊ���������� ����Ϊ�Ͷ�������   (����� ���� 10 ����ʵ��ֵ)
}FBS_MATCH_INFO;


typedef struct _GLTP_MSG_T_FBS_MATCH_INFO_RSP
{
    GLTP_MSG_T_HEADER  header;
    uint32  timeStamp;

    uint8 gameCode;
    uint16   matchCount;              //���θ���
    FBS_MATCH_INFO fbsMatch[];//FBS_MAX_TICKET_MATCH
    //uint16  crc;
}GLTP_MSG_T_FBS_MATCH_INFO_RSP;




//------------------------------------------------------------------------------
// ����Ϊ�ն˹㲥��Ϣ
//------------------------------------------------------------------------------

//��Ϸ����(4001) <GLTP_T_UNS_OPEN_GAME>
typedef struct _GLTP_MSG_T_OPEN_GAME_UNS {
    GLTP_MSG_T_HEADER  header;

    uint8   gameCode;               //��Ϸ����
    uint64  issueNumber;            //�ں�
    uint32  issueTimeStamp;         //�ڴο���ʱ��
    uint32  issueTimeSpan;          //�ڳ�(����)
    uint32  countDownSeconds;       //�ڹرյ���ʱ����
    uint16  crc;
}GLTP_MSG_T_OPEN_GAME_UNS;


//��Ϸ�����ر�(4002) <GLTP_T_UNS_CLOSE_SECONDS>
/*
typedef struct _GLTP_MSG_T_CLOSE_SECONDS_UNS {
    GLTP_MSG_T_HEADER  header;

    uint8   gameCode;               //��Ϸ����
    uint64  issueNumber;            //�ں�
    uint32  issueTimeStamp;         //�ڴμ����ر�ʱ��
    uint32  closeCountDownSecond;   //����
    uint16  crc;
}GLTP_MSG_T_CLOSE_SECONDS_UNS;
*/

//��Ϸ�ر�(4003) <GLTP_T_UNS_CLOSE_GAME>
typedef struct _GLTP_MSG_T_CLOSE_GAME_UNS {
    GLTP_MSG_T_HEADER  header;

    uint8   gameCode;               //��Ϸ����
    uint64  issueNumber;            //�ں�
    uint32  issueTimeStamp;         //�ڴιر�ʱ��
    uint16  crc;
}GLTP_MSG_T_CLOSE_GAME_UNS;


//��Ϸ����������(4004) <GLTP_T_UNS_DRAW_ANNOUNCE>
typedef struct _GLTP_MSG_T_DRAW_ANNOUNCE_UNS {
    GLTP_MSG_T_HEADER  header;

    uint8   gameCode;               //��Ϸ����
    uint64  issueNumber;            //�ں�
    uint32  issueTimeStamp;         //�ڴο�������ʱ��
    uint16  drawCodeLen;            //���������ַ�������
    uint16  drawAnnounceLen;        //���������ַ�������
    char    drawCode[];             //��Ϸ���뿪�����
    //char    drawAnnounce[];       //��Ϸ����������
    //uint16  crc;
}GLTP_MSG_T_DRAW_ANNOUNCE_UNS;


//�ն˻�����(4005) <GLTP_T_UNS_RESET>
typedef struct _GLTP_MSG_T_RESET_UNS {
    GLTP_MSG_T_HEADER  header;

    uint8  ctrlLevel;           // 0:ȫ�� 1:ʡ 2:�� 3:����վ 4:�ն˻�
    uint64 ctrlCode;            // ��ctrlLevelΪ1����Ϊ��λ��ʡ����
                                // ��ctrlLevelΪ2����Ϊ��λ��ʡ�д���
                                // ��ctrlLevelΪ3����Ϊʮλ��ʡ������վ����
                                // ��ctrlLevelΪ0��4(���㲥�͵���)�����ֵ������
    uint16  crc;
}GLTP_MSG_T_RESET_UNS;

//�ն˻�֪ͨ��Ϣ(4006) <GLTP_T_UNS_MESSAGE>
typedef struct _GLTP_MSG_T_MESSAGE_UNS {
    GLTP_MSG_T_HEADER  header;

    uint8  ctrlLevel;           // 0:ȫ�� 1:ʡ 2:�� 3:����վ 4:�ն˻�
    uint64 ctrlCode;            // ��ctrlLevelΪ1����Ϊ��λ��ʡ����
                                // ��ctrlLevelΪ2����Ϊ��λ��ʡ�д���
                                // ��ctrlLevelΪ3����Ϊʮλ��ʡ������վ����
                                // ��ctrlLevelΪ0��4(���㲥�͵���)�����ֵ������
    uint32 createTime;
    uint32 sendTime;
    uint8  who;                 //�豸Ŀ��(0:�ն˻� 1:TDS)
    uint8  flag;                // 1: ��ʾʮ��  0��һֱ��ʾ
    uint16 length;
    char   message[];
    //uint16  crc;
}GLTP_MSG_T_MESSAGE_UNS;



//ȡ��ָ�����룬�ָ�ȱʡ����
#pragma pack ()



#endif //GLTP_MESSAGE_TERMINAL_H_INCLUDED

