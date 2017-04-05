#ifndef TYPE_DEFINE_H_INCLUDED
#define TYPE_DEFINE_H_INCLUDED

//------------------------------------------------------------------------------
// ALL
//------------------------------------------------------------------------------

//��Ӧecodeö�ٶ���
typedef enum _ECODE
{
    SUCCESS = 0,              //�ɹ�
    FAILURE = 1,              //ʧ��
}ECODE;

//״̬����
typedef enum _STATUS_TYPE
{
    STATUS_EMPTY = 0,
    ENABLED      = 1,         //����
    DISABLED     = 2,         //������
    DELETED      = 3,         //��ɾ��
}STATUS_TYPE;

//ҵ������(������ˮ������)
typedef enum _BUSINESS_TYPE
{
    BUS_SALE   = 0,
    BUS_PAY    = 1,
    BUS_CANCEL = 2,
}BUSINESS_TYPE;

//Ʊ��Դ
typedef enum  _TICKET_FROM_TYPE {
    TICKET_FROM_EMPTY = 0,
    TICKET_FROM_TERM  = 1,    //�����ն�
    TICKET_FROM_AP    = 2,    //���Խ�����
    TICKET_FROM_OMS   = 3,    //����OMS
} TICKET_FROM_TYPE;

//RNGʹ��״̬
typedef enum _RNG_STATUS_USED
{
    RNG_STATUS_ON  = 1,
    RNG_STATUS_OFF = 2,
}RNG_STATUS_USED;



//------------------------------------------------------------------------------
// GL
//------------------------------------------------------------------------------

//��Ϸ��ʶ
typedef enum _GAME {
    G_NONE         = 0,
    GAME_SSQ       = 1,    //˫ɫ��
    GAME_3D        = 2,    //3D
    GAME_KENO      = 3,    //��ŵ
    GAME_7LC       = 4,    //���ֲ�
    GAME_SSC       = 5,    //ʱʱ��

    //����կ��Ŀ
    GAME_KOCTTY    = 6,   //����կ����Ӯ
    GAME_KOC7LX    = 7,   //����կ������
    GAME_KOCKENO   = 8,   //����կ��ŵ
    GAME_KOCK2     = 9,   //����կ��2
    GAME_KOCC30S6  = 10,  //����կ30ѡ6
    GAME_KOCK3     = 11,  //��3
	GAME_KOC11X5   = 12,  //11ѡ5
    GAME_TEMA      = 13,  //����
    //����
    GAME_FBS       = 14,  //���
    GAME_FODD      = 15,  //�̶�����
}GAME;

//��Ϸ����
typedef enum  _GAME_TYPE {
    GT_NONE           = 0,
    GAME_TYPE_KENO    = 1,     // �쿪
    GAME_TYPE_LOTTO   = 2,     // ��͸
    GAME_TYPE_DIGIT   = 3,     // ����
    GAME_TYPE_FINAL_ODDS = 4,  // ������������Ϸ
	GAME_TYPE_FIXED_ODDS = 5,  // �̶���������Ϸ
}GAME_TYPE;

//��Ϸ����ҡ��ģʽ
typedef enum _DRAW_TYPE
{
    DT_NONE          = 0,
    INSTANT_GAME     = 1,      // ���ӿ������쿪��
    MANUAL_INTERNAL  = 2,      // �ֹ��ɽ����ڲ�����
    MANUAL_EXTERNAL  = 3,      // �ֹ��ɽ����ⲿ����
}DRAW_TYPE;

//�ڴ�״̬
typedef enum _ISSUE_STATUS
{
    ISSUE_STATE_RANGED          = 0,  //�ڴ�Ԥ�ţ����ɱ����ۣ����Ա�ɾ��
    ISSUE_STATE_PRESALE         = 1,  //�ڴ�Ԥ�ۣ������ڶ���Ʊ�б����� 
    ISSUE_STATE_OPENED          = 2,  //�ڴο�ʼ
    ISSUE_STATE_CLOSING         = 3,  //�ڴμ�������
    ISSUE_STATE_CLOSED          = 4,  //�ڴν���
    ISSUE_STATE_SEALED          = 5,  //�ڴη�棬�ڽ����̿�ʼ
    ISSUE_STATE_DRAWNUM_INPUTED = 6,  //�ڽ�:��������¼��
    ISSUE_STATE_MATCHED         = 7,  //�ڽ�:����Ʊ��ƥ��������
    ISSUE_STATE_FUND_INPUTED    = 8,  //�ڽ�:���ز���¼��
    ISSUE_STATE_LOCAL_CALCED    = 9,  //�ڽ�:�����㽱���
    ISSUE_STATE_PRIZE_ADJUSTED  = 10, //�ڽ�:�����������
    ISSUE_STATE_PRIZE_CONFIRMED = 11, //�ڽ�:����ȷ��
    ISSUE_STATE_DB_IMPORTED     = 12, //�ڽ�:�н��������
    ISSUE_STATE_ISSUE_END       = 13, //�ڽ�:�ڽ����
}ISSUE_STATUS;



//------------------------------------------------------------------------------
// TMS
//------------------------------------------------------------------------------

//��Χ����
typedef enum _AREA_LEVEL
{
    COUNTRY_LEVEL  = 0,                //ȫ��
    PROVINCE_LEVEL = 1,                //ʡ
    AGENCY_LEVEL   = 3,                //����վ
}AREA_LEVEL;

//����վ����
typedef enum _AGENCY_TYPE
{
    AGENCY_EMPTY       = 0,
    AGENCY_TERMINAL    = 1,            //��ͳ�ն�(Ԥ����)
    AGENCY_ACCREDIT    = 2,            //�����ն�(�󸶷�)
    AGENCY_CHANNEL     = 3,            //������
}AGENCY_TYPE;

//����Ա����
typedef enum _TELLER_TYPE
{
    EMPTY_TELLER      = 0,
    COMMON_TELLER     = 1,             //��ͨ����Ա
    AGENCY_MANAGER    = 2,             //����վ����
    //BIGWINNER_TELLER  = 3,            //���ҽ��˻�
    TRAINER_TELLER    = 3,             //��ѵԱ
}TELLER_TYPE;

//�ն�����״̬
typedef enum _TERM_CONNECTION_STATUS
{
    TERM_DISCONNECT = 0,
    TERM_CONNECT    = 1,
}TERM_CONNECTION_STATUS;

//����Ա����״̬
typedef enum _TELLER_WORK_STATUS
{
    TELLER_WORK_EMPTY    = 0,
    TELLER_WORK_SIGNIN   = 1,          //ǩ��
    TELLER_WORK_SIGNOUT  = 2,          //ǩ��
    //TELLER_WORK_CLEANOUT,              //���
}TELLER_WORK_STATUS;

//���ö������
typedef enum _CREDIT_LIMIT_TYPE
{
    MARGINAL      = 1,                 //���ö��
    TEMP_MARGINAL = 2,                 //��ʱ���ö��
    BOTH_MARGINAL = 3,                 //���ö�� �� ��ʱ���ö��
}CREDIT_LIMIT_TYPE;



//------------------------------------------------------------------------------
// BUSINESS DEFINITION
//------------------------------------------------------------------------------

#pragma pack (1)



//Ͷע�ַ�������
//SSQ | 21030814007 | 8 | 24000 | FLAG | ZX-DS-(1+2+3+4+5+6:7)-1-0 / ZX-DS-(1+2+3+4+5+6:7)-1-0 / ZX-DS-(1+2+3+4+5+6:7)-1-0
//��Ϸ | �ں� | ������������ | Ʊ��� | Ʊ��չ��� | Ͷע����Ϣ...


//Ͷע�нṹ����
typedef struct _BETLINE
{
    uint8   subtype;       //�淨
    uint8   bettype;       //Ͷע��ʽ
    uint16  betTimes;      //����
    uint16  flag;          //Ͷע����չ����
    money_t singleAmount;  //��ע���(��)

    int32   betCount;      //Ͷע��ע��

    uint8   bitmapLen;     //bitmap����
    char    bitmap[];
}BETLINE;

//Ʊ�ṹ����
typedef struct _TICKET
{
    uint16  length;          //�ṹ���ȣ������������ֽ�
    uint8   gameCode;
    uint64  issue;           //�ں� (��Ʊ�����������0�����GLģ����´��ֶ�Ϊ��ǰ�ں�)
    uint32  issueSeq;        //�ڴ����
    uint8   issueCount;      //��������
    uint64  lastIssue;       //��������һ���ں�
    int32   betCount;        //��ע��
    money_t amount;          //�ܽ��
    uint16  flag;            //Ʊ��չ����

    uint8   isTrain;         //�Ƿ���ѵģʽ: ��(0)/��(1)

    uint8   betlineCount;    //Ͷע����

    uint16  betStringLen;    //Ͷע�ַ�������

    uint16  betlineLen;      //����Ͷע���ܳ���
    char    betString[];     //Ͷע�ַ���

    //BETLINE betlines[]; //Ͷע����Ϣ
}TICKET;

typedef struct _TICKET_STAT
{
    bool    used;
    uint64  issueNum;

    uint32  s_ticketCnt;
    uint32  s_betCnt;
    money_t s_amount;

    uint32  c_ticketCnt;
    uint32  c_betCnt;
    money_t c_amount;
} TICKET_STAT;

typedef struct _PRIZE_DETAIL
{
    char    name[ENTRY_NAME_LEN]; //��������
    uint8   prizeCode;            //���ȱ���(��Ϸ���PRIZEö��)
    uint32  count;                //�н�ע��
    money_t amountSingle;         //��ע���
    money_t amountBeforeTax;      //��ע���x�н�ע��
    money_t amountTax;            //��ע˰��
    money_t amountAfterTax;       //(��ע���-˰��)x�н�ע��
} PRIZE_DETAIL;

//�н�Ʊ��ͳ��
typedef struct _WIN_TICKET_STAT
{
	int64   winCnt;           //�н�Ʊ����
	int64   bigPrizeCnt;      //��Ʊ��
	money_t bigPrizeAmount;   //���ܽ��
	int64   smallPrizeCnt;    //С��Ʊ��
	money_t smallPrizeAmount; //С���ܽ��
	int64   winBet;           //�н���ע��
	money_t winAmount;        //�н��ܽ��
}WIN_TICKET_STAT;






// -- FBS TICKET -------------------------------------------------

typedef struct _FBS_BETM {
    uint32 match_code;
    uint8  result_count; //Ͷע�Ľ����Ŀ
    uint8  results[32];  //Ͷע������ö��ֵ
}FBS_BETM;

typedef struct _FBS_ORDER {
    uint16  length;
    uint16  ord_no; //�𵥱��
    uint8   bet_type; //���ط�ʽ(Ͷע��ʽ)
    money_t bet_amount; //�Ѱ�����Ͷ
    uint32  bet_count; //�Ѱ�����Ͷ
    uint8   match_count; //Ͷע�ı���������
    uint8   result_count; //Ͷע����������
    uint32  match_code_set[]; //����𵥵ı�������
}FBS_ORDER;

typedef struct _FBS_TICKET {
    uint16  length; //�ṹ���ȣ������������ֽ�
    uint8   game_code; //��Ϸ
    uint8   sub_type; //�淨
    uint32  issue_number; //�������ڵ���С�ں�(ע�� ����  ���������ں�)
    uint8   bet_type; //���ط�ʽ(Ͷע��ʽ)
    money_t bet_amount; //Ͷע�ܽ��  �Ѱ�����Ͷ
    uint32  bet_count; //Ͷע��ע��  �Ѱ�����Ͷ
    uint16  bet_times; //Ͷע����
    uint16  flag; //��չ����
    uint8   is_train; //�Ƿ���ѵģʽ: ��(0)/��(1)
    //
    uint16  match_count; //ѡ��ĳ�������
    uint16  order_count; //��ֵĶ�������
    char    data[];
    //FBS_BETM match_array[]; //������Ͷע��Ϣ
    //FBS_ORDER ord_array[];
}FBS_TICKET;



#pragma pack ()



#endif //TYPE_DEFINE_H_INCLUDED



