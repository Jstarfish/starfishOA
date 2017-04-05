#ifndef GAME_ISSUE_H_INCLUDED
#define GAME_ISSUE_H_INCLUDED


#define GIDB_MAX_GAME_NUMBER MAX_GAME_NUMBER
#define GIDB_MAX_ISSUE_NUMBER 100000



//�ڼ��ο���
typedef enum _DRAW_TIMES {
    GAME_DRAW_ONE    = 1,
    GAME_DRAW_TWO    = 2,
    GAME_DRAW_THREE  = 3,
} DRAW_TIMES;


#pragma pack(1)

//----------------------------
//���ݱ��¼���ʽṹ
//----------------------------

//Ʊ������¼
typedef struct _GIDB_TICKET_IDX_REC {
    uint64     unique_tsn;                      //Ψһ���
    char       reqfn_ticket[TSN_LENGTH];        //��Ʊ������ˮ��(����)(**��Ҫȷ���ն˻���ˮ�ŵ����ɹ���  ��  ��������ˮ�ŵ����ɹ��� **)
    char       rspfn_ticket[TSN_LENGTH];        //��Ʊ������ˮ��(��Ӧ)(**ȷ���ն˻���Ӧ��ˮ�ŵ����ɹ���(��TSN)  ��  ��������ˮ�ŵ����ɹ��� **)
    uint8      gameCode;                        //��Ϸ����
    uint64     issueNumber;                     //�����ں�
    uint64     drawIssueNumber;                 //�н��ں�
    uint8      from_sale;
    uint16     extend_len;
    char       extend[];
} GIDB_TICKET_IDX_REC;

//����Ʊ��¼
typedef struct _GIDB_SALE_TICKET_REC {
    char       reqfn_ticket[TSN_LENGTH];        //��Ʊ������ˮ��(����)(**��Ҫȷ���ն˻���ˮ�ŵ����ɹ���  ��  ��������ˮ�ŵ����ɹ��� **)
    char       rspfn_ticket[TSN_LENGTH];        //��Ʊ������ˮ��(��Ӧ)(**ȷ���ն˻���Ӧ��ˮ�ŵ����ɹ���(��TSN)  ��  ��������ˮ�ŵ����ɹ��� **)
    uint64     unique_tsn;                      //Ψһ���

    time_type  timeStamp;                       //ʱ���

    uint8      from_sale;                       //Ʊ��Դ

    uint64     issueNumber;                     //�����ں�(����ʱ�ĵ�ǰ�ں�)

    money_t    commissionAmount;                //��ƱӶ�𷵻����
    uint8      claimingScope;                   //��Ϸ�ҽ���Χ, enum AREA_LEVEL
    time_type  drawTimeStamp;                   //���һ�ڿ���ʱ��

    uint32     areaCode;                        //�����������
    uint8      areaType;                        //������������
    uint64     agencyCode;                      //����վ����
    uint64     terminalCode;                    //�ն˱���
    uint32     tellerCode;                      //Teller����

    uint32     apCode;                          //�����̱���

    uint8      isTrain;                         //�Ƿ���ѵģʽ: ��(0)/��(1)

    uint8      isCancel;                        //�Ƿ�����Ʊ
    //��¼һЩ��Ʊ������վ��Ϣ����Ϸ��Ϣ
    uint8      from_cancel;                     //Ʊ��Դ -- ��Ʊ
    char       reqfn_ticket_cancel[TSN_LENGTH]; //��Ʊ������ˮ��(����)
    char       rspfn_ticket_cancel[TSN_LENGTH]; //��Ʊ������ˮ��(��Ӧ)
    time_type  timeStamp_cancel;                //ʱ��� -- ��Ʊ
    uint64     agencyCode_cancel;               //����վ���� -- ��Ʊ
    uint64     terminalCode_cancel;             //�ն˱��� -- ��Ʊ
    uint32     tellerCode_cancel;               //Teller���� -- ��Ʊ
    uint32     apCode_cancel;                   //�����̱��� -- ��Ʊ

    //Ʊ��Ϣ
    TICKET     ticket;
} GIDB_SALE_TICKET_REC;


//�н�ƥ���ļ��Ĵ洢�ṹ��
typedef struct _GIDB_MATCH_TICKET_REC
{
    uint64    unique_tsn;                      //Ψһ���
    char      reqfn_ticket[TSN_LENGTH];        //��Ʊ������ˮ��(����)
    char      rspfn_ticket[TSN_LENGTH];        //��Ʊ������ˮ��(��Ӧ)
    time_type timeStamp;                        //ʱ���

    uint8    from_sale;                         //Ʊ��Դ

    uint32  areaCode;                           //�����������
    uint8   areaType;                           //������������
    uint64  agencyCode;                         //����վ����
    uint64  terminalCode;                       //�ն˱���
    uint32  tellerCode;                         //Teller����

    uint32  apCode;                             //�����̱���

    uint8   gameCode;                           //��Ϸ����
    uint64  issueNumber;                        //�����ں�
    uint8   issueCount;                         //������������
    uint64  saleStartIssue;                     //�������ʼ�ں�
    uint32  saleStartIssueSerial;               //�������ʼ�����
    uint64  saleEndIssue;                       //���������ں�
    uint16  totalBets;                          //��ע��
    money_t ticketAmount;                       //Ʊ�����۽��

    uint8   claimingScope;                      //��Ϸ�ҽ���Χ, enum AREA_LEVEL

    uint8   isTrain;                            //�Ƿ���ѵģʽ: ��(0)/��(1)

    //�н���Ϣ
    VALUE_TRIPLE match_result[MAX_PRIZE_COUNT];

    //Ͷע����Ϣ
    uint16  betStringLen; //Ͷע�ַ�������
    char    betString[]; //Ͷע�ַ���
} GIDB_MATCH_TICKET_REC;


typedef enum _PRIZE_PAYMENT_STATUS
{
    PRIZE_PAYMENT_PENDING = 1,     // �ɶҽ�������δ�ҽ�
    PRIZE_PAYMENT_PAID,            // �Ѷҽ����
    PRIZE_PAYMENT_NONE = 100,      // ���ɶҽ�, ��������Ʊ
} PRIZE_PAYMENT_STATUS;

//�н�Ʊ��¼
typedef struct _GIDB_WIN_TICKET_REC
{
    //������ԭʼ����Ʊ��Ϣ
    uint64    unique_tsn;                      //Ψһ���
    char      reqfn_ticket[TSN_LENGTH];        //��Ʊ������ˮ��(����)
    char      rspfn_ticket[TSN_LENGTH];        //��Ʊ������ˮ��(��Ӧ)
    time_type timeStamp;                        //ʱ���

    uint8    from_sale;                         //Ʊ��Դ

    uint32  areaCode;                           //�����������
    uint8   areaType;                           //������������
    uint64  agencyCode;                         //����վ����
    uint64  terminalCode;                       //�ն˱���
    uint32  tellerCode;                         //Teller����

    uint32  apCode;                             //�����̱���

    uint8   gameCode;                           //��Ϸ����
    uint64  issueNumber;                        //�����ں�
    uint8   issueCount;                         //������������
    uint64  saleStartIssue;                     //�������ʼ�ں�
    uint32  saleStartIssueSerial;               //�������ʼ�����
    uint64  saleEndIssue;                       //���������ں�
    uint16  totalBets;                          //��ע��
    money_t ticketAmount;                       //Ʊ�����۽��

    uint8   claimingScope;                      //��Ϸ�ҽ���Χ, enum AREA_LEVEL

    uint8   isTrain;                            //�Ƿ���ѵģʽ: ��(0)/��(1)

    //Ͷע����Ϣ
    uint32  bet_string_len;
    char    bet_string[MAX_BET_STRING_LENGTH];  //Ͷע�����ַ���

    //�������н�����Ϣ
    uint8   isBigWinning;                       //�Ƿ��Ǵ�  0=����  1=��
    money_t winningAmountWithTax;               //������(��˰)
    money_t winningAmount;                      //������(����˰)
    money_t taxAmount;                          //����˰��
    int32   winningCount;                       //�ܵ��н�ע��
    money_t hd_winning;                         //�ߵȽ��н����
    int32   hd_count;                           //�ߵȽ��н�ע��
    money_t ld_winning;                         //�͵Ƚ��н����
    int32   ld_count;                           //�͵Ƚ��н�ע��

    //�ҽ�״̬
    uint8   paid_status;                        //�ҽ�״̬  enum PRIZE_PAYMENT_STATUS

    //��¼һЩ�ҽ�������վ��Ϣ����Ϸ��Ϣ
    uint8    from_pay;                          //Ʊ��Դ -- �ҽ�
    char       reqfn_ticket_pay[TSN_LENGTH];    //�ҽ�������ˮ��(����)
    char       rspfn_ticket_pay[TSN_LENGTH];    //�ҽ�������ˮ��(��Ӧ)
    time_type timeStamp_pay;                    //ʱ��� -- �ҽ�
    
    uint64  agencyCode_pay;                     //����վΨһ��� -- �ҽ�
    uint64  terminalCode_pay;                   //�ն�Ψһ��� -- �ҽ�
    uint32  tellerCode_pay;                     //����ԱΨһ��� -- �ҽ�
    uint32  apCode_pay;                         //�����̱��� -- �ҽ�

    //�Ҵ�ʹ�õ���Ϣ�ֶ�
    char    userName_pay[ENTRY_NAME_LEN];       //�û�����
    int     identityType_pay;                   //֤������
    char    identityNumber_pay[IDENTITY_CARD_LENGTH]; //֤������

    //�������н�����ϸ
    uint8   prizeCount;                         //�еĽ��ȵ�����
    uint32  prizeDetail_length;                 //����ı䳤���ݵĳ���
    PRIZE_DETAIL prizeDetail[];                 //������ϸ
} GIDB_WIN_TICKET_REC;



//����Ʊʹ�õ� ��ʱ�н�Ʊ��¼
typedef struct _GIDB_TMP_WIN_TICKET_REC
{
    //������ԭʼ����Ʊ��Ϣ
    uint64     unique_tsn;                      //Ψһ���
    char       reqfn_ticket[TSN_LENGTH];        //��Ʊ������ˮ��(����)
    char       rspfn_ticket[TSN_LENGTH];        //��Ʊ������ˮ��(��Ӧ)
    time_type timeStamp;                        //ʱ���

    uint8    from_sale;                         //Ʊ��Դ

    uint32  areaCode;                           //�����������
    uint8   areaType;                           //������������
    uint64  agencyCode;                         //����վ����
    uint64  terminalCode;                       //�ն˱���
    uint32  tellerCode;                         //Teller����

    uint32  apCode;                             //�����̱���

    uint8   gameCode;                           //��Ϸ����
    uint64  issueNumber;                        //�����ں�
    uint8   issueCount;                         //������������
    uint64  saleStartIssue;                     //�������ʼ�ں�
    uint32  saleStartIssueSerial;               //�������ʼ�����
    uint64  saleEndIssue;                       //���������ں�
    uint16  totalBets;                          //��ע��
    money_t ticketAmount;                       //Ʊ�����۽��

    uint8   claimingScope;                      //��Ϸ�ҽ���Χ, enum AREA_LEVEL

    uint8   isTrain;                            //�Ƿ���ѵģʽ: ��(0)/��(1)

    //Ͷע����Ϣ
    uint32  bet_string_len;
    char    bet_string[MAX_BET_STRING_LENGTH];  //Ͷע�����ַ���

    //�������н�����Ϣ
    uint8   isBigWinning;                       //�Ƿ��Ǵ�  0=����  1=��
    uint32  win_issue_number;                   //�н��ں�
    money_t winningAmountWithTax;               //������(��˰)
    money_t winningAmount;                      //������(����˰)
    money_t taxAmount;                          //����˰��
    int32   winningCount;                       //�ܵ��н�ע��
    money_t hd_winning;                         //�ߵȽ��н����
    int32   hd_count;                           //�ߵȽ��н�ע��
    money_t ld_winning;                         //�͵Ƚ��н����
    int32   ld_count;                           //�͵Ƚ��н�ע��

    //�������н�����ϸ
    uint8   prizeCount;                         //�еĽ��ȵ�����
    uint32  prizeDetail_length;                 //����ı䳤���ݵĳ���
    PRIZE_DETAIL prizeDetail[];                 //������ϸ
} GIDB_TMP_WIN_TICKET_REC;




//------------------------------------------------------------------------------------------
// �ҽ� �� ��Ʊ �ӿ�ʹ�õĽṹ


//���¶ҽ���Ϣʹ�õĽṹ��
typedef struct _GIDB_PAY_TICKET_STRUCT {
    char    reqfn_ticket_pay[TSN_LENGTH];     //�ҽ�������ˮ��(����)
    char    rspfn_ticket_pay[TSN_LENGTH];     //�ҽ�������ˮ��(��Ӧ)

    char    rspfn_ticket[TSN_LENGTH];         //��Ʊ������ˮ��(��Ӧ)
    uint64  unique_tsn;                       //Ψһ���

    uint32  timeStamp_pay;                              //ʱ��� -- �ҽ�

    uint8   from_pay;                                   //Ʊ��Դ -- �ҽ�
    
    uint64  agencyCode_pay;                     //����վΨһ��� -- �ҽ�
    uint64  terminalCode_pay;                   //�ն�Ψһ��� -- �ҽ�
    uint32  tellerCode_pay;                     //����ԱΨһ��� -- �ҽ�
    uint32  apCode_pay;                         //�����̱��� -- �ҽ�
    uint64  issueNumber_pay;                    //�ҽ�����ʱ���ں� -- �ҽ�

    //�Ҵ�ʹ�õ���Ϣ�ֶ�
    char    userName_pay[ENTRY_NAME_LEN];               //�û����� -- �ҽ�
    int     identityType_pay;                           //֤������ -- �ҽ�
    char    identityNumber_pay[IDENTITY_CARD_LENGTH];   //֤������ -- �ҽ�

    uint8   isTrain;                                    //�Ƿ���ѵģʽ: ��(0)/��(1)

    uint8   gameCode;                       //��Ϸ����
    uint64  issueNumber;                    //�����ں�
    money_t ticketAmount;                   //Ʊ����
    uint8   isBigWinning;                   //�Ƿ��Ǵ�  0=����  1=��
    money_t winningAmountWithTax;           //������(��˰)
    money_t winningAmount;                  //������(����˰)
    money_t taxAmount;                      //����˰��
    int32   winningCount;                   //�ܵ��н�ע��

    uint8   paid_status;                    //�ҽ�״̬  enum PRIZE_PAYMENT_STATUS
} GIDB_PAY_TICKET_STRUCT;



//������Ʊ��Ϣʹ�õĽṹ��
typedef struct _GIDB_CANCEL_TICKET_STRUCT {
    char    reqfn_ticket_cancel[TSN_LENGTH];//��Ʊ������ˮ��(����)
    char    rspfn_ticket_cancel[TSN_LENGTH];//��Ʊ������ˮ��(��Ӧ)

    char    rspfn_ticket[TSN_LENGTH];       //��Ʊ������ˮ��(��Ӧ)
    uint64  unique_tsn;                     //Ψһ���

    uint32  timeStamp_cancel;               //ʱ��� -- ��Ʊ
    uint8   from_cancel;                    //Ʊ��Դ -- ��Ʊ

    uint64  agencyCode_cancel;              //����վ���� -- ��Ʊ
    uint64  terminalCode_cancel;            //�ն˱��� -- ��Ʊ
    uint32  tellerCode_cancel;              //Teller���� -- ��Ʊ
    uint32  apCode_cancel;                  //�����̱��� -- ��Ʊ

    uint8   isTrain;                        //�Ƿ���ѵģʽ: ��(0)/��(1)
    money_t cancelAmount;                   //��Ʊ���
    uint32  betCount;                       //��ע��

    //Ʊ��Ϣ
    TICKET  ticket;
} GIDB_CANCEL_TICKET_STRUCT;

#pragma pack()

typedef list<GIDB_TICKET_IDX_REC *> TICKET_IDX_LIST;
typedef list<GIDB_SALE_TICKET_REC *> SALE_TICKET_LIST;
typedef list<GIDB_PAY_TICKET_STRUCT *> PAY_TICKET_LIST;
typedef list<GIDB_CANCEL_TICKET_STRUCT *> CANCEL_TICKET_LIST;
typedef list<GIDB_MATCH_TICKET_REC *> MATCH_TICKET_LIST;
typedef map<string, GIDB_WIN_TICKET_REC *> WIN_TICKET_MAP;
typedef list<GIDB_WIN_TICKET_REC *> WIN_TICKET_LIST;
typedef list<GIDB_TMP_WIN_TICKET_REC *> TMP_WIN_TICKET_LIST;


//------------------------------
// issue manage Interface
//------------------------------

//�ַ��������ֶ�key 
typedef enum _ISSUE_FIELD_TEXT_KEY
{
    I_DRAW_CODE_TEXT_KEY = 1,                         //���������ַ��� 
    I_DRAW_ANNOUNCE_TEXT_KEY                          //drawAnnounce���������棩 
}ISSUE_FIELD_TEXT_KEY;

typedef struct _GIDB_ISSUE_INFO
{
    uint8 gameCode;                                 //��Ϸ����
    uint64 issueNumber;
    uint32 serialNumber;                            //�ڴ����
    uint8 status;

    time_type estimate_start_time;
    time_type estimate_close_time;
    time_type estimate_draw_time;
    time_type real_start_time;
    time_type real_close_time;
    time_type real_draw_time;
    time_type real_pay_time; 
    
    uint32 payEndDay;                               //�ҽ���ֹ����(������)
    char draw_code_str[MAX_GAME_RESULTS_STR_LEN];   //���������ַ���
} GIDB_ISSUE_INFO;

struct _GIDB_ISSUE_HANDLE;
typedef struct _GIDB_ISSUE_HANDLE GIDB_ISSUE_HANDLE;
struct _GIDB_ISSUE_HANDLE {
    uint8 game_code;
    sqlite3 *db;

    int32 (*gidb_i_init_data)(GIDB_ISSUE_HANDLE *self);
    int32 (*gidb_i_insert)(GIDB_ISSUE_HANDLE *self, GIDB_ISSUE_INFO *p_issue_info);
    int32 (*gidb_i_cleanup)(GIDB_ISSUE_HANDLE *self, uint64 issue_num);

    int32 (*gidb_i_get_info)(GIDB_ISSUE_HANDLE *self, uint64 issue_num, GIDB_ISSUE_INFO *p_issue_info);
    int32 (*gidb_i_get_info2)(GIDB_ISSUE_HANDLE *self, uint32 issue_serial, GIDB_ISSUE_INFO *p_issue_info);

    int32 (*gidb_i_set_status)(GIDB_ISSUE_HANDLE *self, uint64 issue_num, uint8 issue_status, uint32 real_time);
    int32 (*gidb_i_get_status)(GIDB_ISSUE_HANDLE *self, uint64 issue_num, uint8 *issue_status);

    int32 (*gidb_i_set_field_text)(GIDB_ISSUE_HANDLE *self, uint64 issue_num, ISSUE_FIELD_TEXT_KEY field_type, char *str);
    int32 (*gidb_i_get_field_text)(GIDB_ISSUE_HANDLE *self, uint64 issue_num, ISSUE_FIELD_TEXT_KEY field_type, char *str);
};
typedef map<uint32, GIDB_ISSUE_HANDLE*> GAME_ISSUE_MAP;

//��ȡ�ڴη��ʵĲ����ӿ�
GIDB_ISSUE_HANDLE * gidb_i_get_handle(uint8 game_code);

//�����˳�ʱ���ô˽ӿڹر�db�ļ�
int32 gidb_i_close_handle();



//------------------------------
// issue draw Interface
//------------------------------

//��draw_table�����õ�ģ�壬���ڽ����ݷ�����л�ӱ����ó�����
typedef struct _GIDB_D_DATA
{
    uint8  status;
    time_type update_time;

    uint32 field_type;
    uint32 data_len;
    char   data[];
}GIDB_D_DATA;

//�ַ��������ֶ�key 
typedef enum _D_FIELD_TEXT_KEY
{
    DRAW_CODE_TEXT_KEY = 1,                         //���������ַ���
    DRAW_WINNER_LOCAL_TEXT_KEY = 2,                 //winner.local(�����㽱���)
    DRAW_WINNER_CONFIRM_TEXT_KEY = 3,               //winner.confirm��ȷ�Ϻ���㽱�����
    DRAW_ANNOUNCE_TEXT_KEY = 4,
}D_FIELD_TEXT_KEY;

//�����������ֶ�key
typedef enum _D_FIELD_BLOB_KEY
{
    D_TICKETS_STAT_BLOB_KEY = 1,                 //����Ʊͳ����Ϣ
    D_WLEVEL_STAT_BLOB_KEY = 2,                  //�ڴθ������н�ͳ��
    D_WPRIZE_LEVEL_BLOB_KEY = 3,                 //�ڴν�������ͳ����Ϣ
    D_WPRIZE_LEVEL_CONFIRM_BLOB_KEY = 4,         //�ڴν�������ͳ����Ϣ ��ȷ�Ϻ�
    D_WFUND_INFO_BLOB_KEY = 5,                   //�ڴν�������
    D_WFUND_INFO_CONFIRM_BLOB_KEY = 6,           //ȷ�Ϻ�Ľ�������
}D_FIELD_BLOB_KEY;

struct _GIDB_DRAW_HANDLE;
typedef struct _GIDB_DRAW_HANDLE GIDB_DRAW_HANDLE;
struct _GIDB_DRAW_HANDLE {
    _GIDB_DRAW_HANDLE(){}
    uint8  game_code;
    uint64 issue_number;
    uint8 draw_times;
    uint32 last_time; //���һ�η���ʱ��
    sqlite3 *db;

    bool commit_flag_match;
    MATCH_TICKET_LIST matchTicketList;

    int32 (*gidb_d_cleanup)(GIDB_DRAW_HANDLE *self);
    int32 (*gidb_d_clean_match_table)(GIDB_DRAW_HANDLE *self);

    int32 (*gidb_d_set_status)(GIDB_DRAW_HANDLE *self, GIDB_D_DATA *gd_data);
    int32 (*gidb_d_get_status)(GIDB_DRAW_HANDLE *self, GIDB_D_DATA *gd_data);

    int32 (*gidb_d_set_field_text)(GIDB_DRAW_HANDLE *self, GIDB_D_DATA *gd_data);
    int32 (*gidb_d_get_field_text)(GIDB_DRAW_HANDLE *self, GIDB_D_DATA *gd_data);

    int32 (*gidb_d_set_field_blob)(GIDB_DRAW_HANDLE *self, GIDB_D_DATA *gd_data);
    int32 (*gidb_d_get_field_blob)(GIDB_DRAW_HANDLE *self, GIDB_D_DATA *gd_data);

    //��ƥ��Ʊ�Ľ�������ڴ�����
    int32 (*gidb_d_insert_ticket)(GIDB_DRAW_HANDLE *self, GIDB_MATCH_TICKET_REC *pTicketMatch);
    //��LIST�ڴ��е�ƥ���¼д�����ݿ��ļ�
    int32 (*gidb_d_sync_ticket)(GIDB_DRAW_HANDLE *self);
};
typedef map<uint64, GIDB_DRAW_HANDLE*> DRAW_ISSUE_MAP;

//��ȡ�ڴη��ʵĲ����ӿ�
GIDB_DRAW_HANDLE * gidb_d_get_handle(uint8 game_code, uint64 issue_number, uint8 draw_times);

//�����˳�ʱ���ô˽ӿڹر�db�ļ�
int gidb_d_clean_handle_timeout();
int32 gidb_d_close_handle();



//------------------------------
// ticket index Interface
//------------------------------

struct _GIDB_TICKET_IDX_HANDLE;
typedef struct _GIDB_TICKET_IDX_HANDLE GIDB_TICKET_IDX_HANDLE;
struct _GIDB_TICKET_IDX_HANDLE {
    _GIDB_TICKET_IDX_HANDLE(){}
    uint32 date; //20150910
    uint32 last_time; //���һ�η���ʱ��
    sqlite3 *db;

    bool commit_flag;
    TICKET_IDX_LIST ticketIdxList;

    //��������Ʊ���� (����ʽ���룬������ɺ���Ҫ����ͬ���ӿڣ����ܸ��µ����ݿ�) 
    int32 (*gidb_tidx_insert_ticket)(GIDB_TICKET_IDX_HANDLE *self, GIDB_TICKET_IDX_REC *pTIdxRec);
    //�����ڵ�LIST�ڴ��е�(��Ʊ����Ʊ�ļ�¼)����д�����ݿ��ļ�
    int32 (*gidb_tidx_sync)(GIDB_TICKET_IDX_HANDLE *self);
     //get ticket by unique_tsn
    int32 (*gidb_tidx_get)(GIDB_TICKET_IDX_HANDLE *self, uint64 unique_tsn, GIDB_TICKET_IDX_REC *pTIdxRec);
      //get ticket by reqfn_ticket
    int32 (*gidb_tidx_get2)(GIDB_TICKET_IDX_HANDLE *self, char *reqfn_ticket, GIDB_TICKET_IDX_REC *pTIdxRec);
};
typedef map<uint64, GIDB_TICKET_IDX_HANDLE*> TICKET_IDX_MAP;

//��ȡ�ڴη��ʵĲ����ӿ�
GIDB_TICKET_IDX_HANDLE * gidb_tidx_get_handle(uint32 date);

//�����˳�ʱ���ô˽ӿڹر�db�ļ�
int gidb_tidx_clean_handle_timeout();
int32 gidb_tidx_close_handle();

int32 get_ticket_idx(uint32 date, uint64 unique_tsn, GIDB_TICKET_IDX_REC *pTIdxRec);
int32 get_ticket_idx2(uint32 date, char *reqfn_ticket, GIDB_TICKET_IDX_REC *pTIdxRec);

//------------------------------
// issue sale ticket Interface
//------------------------------

typedef struct _GT_GAME_PARAM
{
    uint8 gameCode; //��Ϸ����
    GAME_TYPE gameType; // ��Ϸ����
    char gameAbbr[15]; //��Ϸ�ַ���д
    char gameName[MAX_GAME_NAME_LENGTH]; //��Ϸ����
    char organizationName[MAX_ORGANIZATION_NAME_LENGTH]; //���е�λ����

    uint16 publicFundRate; //��������
    uint16 adjustmentFundRate; //���ڽ����
    uint16 returnRate; //���۷�����
    money_t taxStartAmount; //��˰������(��λ:���)
    uint16 taxRate; //��˰ǧ�ֱ�
    uint16 payEndDay; //�ҽ���(��)

    DRAW_TYPE drawType; //�ڴο���ģʽ

    money_t bigPrize; //�ж��Ƿ��Ǵ� ��С�ڳ����޶(ȷ���Ƿ��Ǵ�)(��Ʊ)
}GT_GAME_PARAM;

//�����������ֶ�key
typedef enum _T_FIELD_BLOB_KEY
{
    T_GAME_PARAMBLOB_KEY = 1,
    T_SUBTYPE_PARAMBLOB_KEY,
    T_DIVISION_PARAMBLOB_KEY,
    T_PRIZE_PARAMBLOB_KEY,
    T_POOL_PARAMBLOB_KEY,
}T_FIELD_BLOB_KEY;

struct _GIDB_T_TICKET_HANDLE;
typedef struct _GIDB_T_TICKET_HANDLE GIDB_T_TICKET_HANDLE;
struct _GIDB_T_TICKET_HANDLE {
    _GIDB_T_TICKET_HANDLE(){}
    uint8  game_code;
    uint64 issue_number;
    uint32 last_time; //���һ�η���ʱ��
    sqlite3 *db;

    bool commit_flag;
    SALE_TICKET_LIST saleTicketList;
    CANCEL_TICKET_LIST cancelTicketList;

    int32 (*gidb_t_set_field_blob)(GIDB_T_TICKET_HANDLE *self, T_FIELD_BLOB_KEY field_type, char *data, int32 len);
    int32 (*gidb_t_get_field_blob)(GIDB_T_TICKET_HANDLE *self, T_FIELD_BLOB_KEY field_type, char *data, int32 *len);

    //��������Ʊ (�ڲ�֧�ֶ���Ʊ�Ĳ���) (����ʽ���룬������ɺ���Ҫ����ͬ���ӿڣ����ܸ��µ����ݿ�) 
    int32 (*gidb_t_insert_ticket)(GIDB_T_TICKET_HANDLE *self, GIDB_SALE_TICKET_REC *pTicketSell);
    //���²�ƱΪ����Ʊ(����ʽ���룬������ɺ���Ҫ����ͬ���ӿڣ����ܸ��µ����ݿ�)
    int32 (*gidb_t_update_cancel)(GIDB_T_TICKET_HANDLE *self, GIDB_CANCEL_TICKET_STRUCT *pCancelInfo);
    //�����ڵ�LIST�ڴ��е�(��Ʊ����Ʊ�ļ�¼)����д�����ݿ��ļ�
    int32 (*gidb_t_sync_sc_ticket)(GIDB_T_TICKET_HANDLE *self);
    //get ticket by rspfn_ticket
    int32 (*gidb_t_get_ticket)(GIDB_T_TICKET_HANDLE *self, uint64 unique_tsn, GIDB_SALE_TICKET_REC *pTicketSell);
};
typedef map<uint64, GIDB_T_TICKET_HANDLE*> T_TICKET_MAP;

//��ȡ�ڴη��ʵĲ����ӿ�
GIDB_T_TICKET_HANDLE * gidb_t_get_handle(uint8 game_code, uint64 issue_number);

//�����˳�ʱ���ô˽ӿڹر�db�ļ�
int gidb_t_clean_handle_timeout();
int32 gidb_t_close_handle();


//------------------------------
// issue win ticket Interface
//------------------------------

struct _GIDB_W_TICKET_HANDLE;
typedef struct _GIDB_W_TICKET_HANDLE GIDB_W_TICKET_HANDLE;
struct _GIDB_W_TICKET_HANDLE {
    _GIDB_W_TICKET_HANDLE(){}
    uint8 game_code;
    uint64 issue_number;
    uint8 draw_times;
    uint32 last_time; //���һ�η���ʱ��
    uint64 tmp_win_draw_issue; //���һ�ο������ںţ����������ʱ���У��˿����ڲ�����ڱ��ڿɶҽ��Ķ����н�Ʊ
    sqlite3 *db;

    //tf_updateʹ�ã����������������
    bool commit_flag;
    PAY_TICKET_LIST payTicketList;

    bool commit_flag_win;
    WIN_TICKET_LIST winTicketList;

    bool commit_flag_tmp_win;
    TMP_WIN_TICKET_LIST tmpWinTicketList;

    //���²�ƱΪ�Ѷҽ�(����ʽ���룬������ɺ���Ҫ����ͬ���ӿڣ����ܸ��µ����ݿ�)
    int32 (*gidb_w_update_pay)(GIDB_W_TICKET_HANDLE *self, GIDB_PAY_TICKET_STRUCT *pPayInfo);
    //�����ڵ�LIST�ڴ��е�(�ҽ��ļ�¼)����д�����ݿ��ļ�
    int32 (*gidb_w_sync_pay_ticket)(GIDB_W_TICKET_HANDLE *self);

    //���н�Ʊ�Ľ�������ڴ�����
    int32 (*gidb_w_insert_ticket)(GIDB_W_TICKET_HANDLE *self, GIDB_WIN_TICKET_REC *pTicketWin);
    //��LIST�ڴ��е��н�Ʊд�����ݿ��ļ�
    int32 (*gidb_w_sync_ticket)(GIDB_W_TICKET_HANDLE *self);

    //������ڵ��н�Ʊ�����һ�ڵ���ʱ�н�Ʊ���ݱ���(����ʽ���룬������ɺ���Ҫ����ͬ���ӿڣ����ܸ��µ����ݿ�)
    int32 (*gidb_w_insert_tmp_ticket)(GIDB_W_TICKET_HANDLE *self, GIDB_TMP_WIN_TICKET_REC *pTicketTmpWin);
    //�����ڵ���ʱ�н���¼��������д�����ݿ��ļ�
    int32 (*gidb_w_sync_tmp_ticket)(GIDB_W_TICKET_HANDLE *self);
    //merge tmp_win_table �� wim_ticket_table
    int32 (*gidb_w_merge_tmp_ticket)(GIDB_W_TICKET_HANDLE *self, money_t big_prize);
    //�����ڳ�����ʱ������ʱ�н���
    int32 (*gidb_w_clean_tmp_ticket)(GIDB_W_TICKET_HANDLE *self, uint64 draw_issue_number);

    //get win ticket by rspfn_ticket
    int32 (*gidb_w_get_ticket)(GIDB_W_TICKET_HANDLE *self, uint64 unique_tsn, GIDB_WIN_TICKET_REC *pTicketWin);
};
typedef map<uint64, GIDB_W_TICKET_HANDLE*> W_TICKET_MAP;

//ͨ���ڴ���ŵõ��ڴ�handle
GIDB_W_TICKET_HANDLE * gidb_w_get_handle(uint8 game_code, uint64 issue_number, uint8 draw_times);

//����ʱ�䲻ʹ�õ�handle
int gidb_w_clean_handle_timeout();

//�����г����˳��󣬹ر����д򿪵�db�ļ�, ÿ��ʹ��GIDBģ����������˳�ʱ����
int gidb_w_close_handle();

//map���ڴ��ļ�handle����ʱ��
#define ISSUE_HANDLE_TIMEOUT 60

//ͬ��������Ϸ�������ݵ����ݿ��ļ�(���ۡ��ҽ�����Ʊ)
int32 gidb_sync_all_spc_ticket();

//ͬ����Ʊ��������
int32 gidb_sync_tidx_ticket();




//------------------------------------------------------------------------------------

int32 T_sell_inm_rec_2_db_tidx_rec(INM_MSG_T_SELL_TICKET *pInmMsg, GIDB_TICKET_IDX_REC *pTIdxRec);
int32 T_sell_inm_rec_2_db_ticket_rec(INM_MSG_T_SELL_TICKET *pInmMsg, GIDB_SALE_TICKET_REC *pTicket);
int32 T_pay_inm_rec_2_db_ticket_rec(INM_MSG_T_PAY_TICKET *pInmMsg, GIDB_PAY_TICKET_STRUCT *pTicket);
int32 T_cancel_inm_rec_2_db_ticket_rec(INM_MSG_T_CANCEL_TICKET *pInmMsg, GIDB_CANCEL_TICKET_STRUCT *pTicket);

int32 O_pay_inm_rec_2_db_ticket_rec(INM_MSG_O_PAY_TICKET *pInmMsg, GIDB_PAY_TICKET_STRUCT *pTicket);
int32 O_cancel_inm_rec_2_db_ticket_rec(INM_MSG_O_CANCEL_TICKET *pInmMsg, GIDB_CANCEL_TICKET_STRUCT *pTicket);

int32 AP_pay_inm_rec_2_db_ticket_rec(INM_MSG_AP_PAY_TICKET *pInmMsg, GIDB_PAY_TICKET_STRUCT *pTicket);

//------------------------------
// issue draw log Interface
//------------------------------


struct _GIDB_DRAWLOG_HANDLE;
typedef struct _GIDB_DRAWLOG_HANDLE GIDB_DRAWLOG_HANDLE;
struct _GIDB_DRAWLOG_HANDLE {
    uint8 game_code;
    sqlite3 *db;

    int32 (*gidb_drawlog_append_dc)(GIDB_DRAWLOG_HANDLE *self, uint64 issue_number);
    int32 (*gidb_drawlog_get_last_dc)(GIDB_DRAWLOG_HANDLE *self, uint32 *msgid, uint64 *issue_number);
    int32 (*gidb_drawlog_confirm_dc)(GIDB_DRAWLOG_HANDLE *self, uint32 msgid);

    int32 (*gidb_drawlog_append_dl)(GIDB_DRAWLOG_HANDLE *self, uint64 issue_number, int32 msg_type, char *msg, int32 msg_len);
    int32 (*gidb_drawlog_get_last_dl)(GIDB_DRAWLOG_HANDLE *self, uint32 *msgid, uint8 *msg_type, char *msg, uint32 *msg_len);
    int32 (*gidb_drawlog_confirm_dl)(GIDB_DRAWLOG_HANDLE *self, uint32 msgid, uint32 flag);

    int32 (*gidb_drawlog_get_rec)(GIDB_DRAWLOG_HANDLE *self, uint64 issue_number, int32 msg_type);
};
typedef map<uint32, GIDB_DRAWLOG_HANDLE*> GAME_DRAWLOG_MAP;

//��ȡ�ڴη��ʵĲ����ӿ�
GIDB_DRAWLOG_HANDLE * gidb_drawlog_get_handle(uint8 game_code);

//�����˳�ʱ���ô˽ӿڹر�db�ļ�
int32 gidb_drawlog_close_handle();




//�ڲ�����--------------------------------------------------------------------------------


//�ڲ����㽱��ʹ��
typedef struct _PRIZE_TABLE
{
    int32      hflag;         //�Ƿ�ߵȽ�
    money_t    money_amount;  //��ע���
    money_t    tax;
} PRIZE_TABLE;


//����
int32 db_create_table(sqlite3 *db, const char *sql);

//��������
int32 db_create_table_index(sqlite3 *db, const char *sql);

//�ж�ָ�������ݱ��Ƿ����  1=not exist  0=exist -1=error
int32 db_check_table_exist(sqlite3 *db, const char *table_name);

//��ʼ����
int db_begin_transaction(sqlite3 *db);

//�ύ����
int db_end_transaction(sqlite3 *db);

//����sqlite���ݿ� 
sqlite3 * db_connect(const char *db_file);

//�ر�sqlite���ݿ� 
int32 db_close(sqlite3 *db);


//�Ӷ�����һ��Ʊ������¼������ GIDB_TICKET_IDX_REC ��Ϣ
int32 get_ticket_idx_rec_from_stmt(GIDB_TICKET_IDX_REC *pRec, sqlite3_stmt* pStmt);
//�Ӷ�����һ��match���¼������ GIDB_SALE_TICKET_REC ��Ϣ
int32 get_sale_ticket_rec_from_stmt(GIDB_SALE_TICKET_REC *pRec, sqlite3_stmt* pStmt);
//�Ӷ�����һ��match���¼������ GIDB_WIN_TICKET_REC ��Ϣ
int32 get_winner_ticket_rec_from_stmt(GIDB_WIN_TICKET_REC *pRec, sqlite3_stmt* pStmt);
//�Ӷ�����һ��match���¼������ GIDB_TMP_WIN_TICKET_REC ��Ϣ
int32 get_tmp_winner_ticket_rec_from_stmt(GIDB_TMP_WIN_TICKET_REC *pRec, sqlite3_stmt* pStmt);
//�Ӷ�����һ��match���¼������ GIDB_MATCH_TICKET_REC ��Ϣ
int32 get_match_ticket_rec_from_stmt(GIDB_MATCH_TICKET_REC *pRec, sqlite3_stmt* pStmt);


//bind  GIDB_TICKET_IDX_REC to sqlite3_stmt  for insert
int32 bind_ticket_idx(GIDB_TICKET_IDX_REC *pTidxRec, sqlite3_stmt* pStmt);
//bind  GIDB_SALE_TICKET_REC to sqlite3_stmt  for insert
int32 bind_sale_ticket(GIDB_SALE_TICKET_REC *pSaleRec, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len);
//bind  GIDB_WIN_TICKET_REC to sqlite3_stmt  for insert
int32 bind_winner_ticket(GIDB_WIN_TICKET_REC *pWinRec, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len);
//bind  GIDB_TMP_WIN_TICKET_REC to sqlite3_stmt  for insert
int32 bind_tmp_winner_ticket(GIDB_TMP_WIN_TICKET_REC *pTmpWinRec, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len);
//bind  GIDB_MATCH_TICKET_REC to sqlite3_stmt  for insert
int32 bind_match_ticket(GIDB_MATCH_TICKET_REC *pMatchRec, sqlite3_stmt* pStmt);

//bind  GIDB_PAY_TICKET_STRUCT to sqlite3_stmt  for update pay table
int32 bind_update_pay_ticket(GIDB_PAY_TICKET_STRUCT *pPayRec, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len);
//bind  GIDB_CANCEL_TICKET_STRUCT to sqlite3_stmt  for update pay table
int32 bind_update_cancel_ticket(GIDB_CANCEL_TICKET_STRUCT *pCancelRec, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len);





//ת�� GIDB_SALE_TICKET_REC ---->  GIDB_MATCH_TICKET_REC
int32 sale_ticket_2_match_ticket_rec(GIDB_SALE_TICKET_REC *pSaleRec, GIDB_MATCH_TICKET_REC * pMatchRec);

//ת�� GIDB_MATCH_TICKET_REC ---->  GIDB_WIN_TICKET_REC
int32 match_ticket_2_win_ticket_rec(GIDB_MATCH_TICKET_REC *pMatchRec, GIDB_WIN_TICKET_REC *pWinRec);

//ת�� GIDB_WIN_TICKET_REC ---->  GIDB_TMP_WIN_TICKET_REC
int32 win_ticket_2_tmp_win_ticket_rec(GIDB_WIN_TICKET_REC *pWinRec, GIDB_TMP_WIN_TICKET_REC *pTmpWinRec);

//ת�� GIDB_TMP_WIN_TICKET_REC ---->  GIDB_WIN_TICKET_REC
int32 tmp_win_ticket_2_win_ticket_rec(GIDB_TMP_WIN_TICKET_REC *pTmpWinRec, GIDB_WIN_TICKET_REC *pWinRec);






//--------------------------------------------------------------
//  xxx
//--------------------------------------------------------------

//ƥ�亯��ָ��
typedef int (*match_ticket_callback)(const TICKET *ticket, const char *subtype, const char *division, uint32 matchRet[MAX_PRIZE_COUNT]);


//����Ʊ��¼����ƥ���¼�ļ�
int32 gidb_match_ticket_callback(uint8 game_code,
                                 uint64 issue_number,
                                 uint8 draw_times,
                                 match_ticket_callback match_func,
                                 ISSUE_REAL_STAT *pIssue_real_stat);

//��ƥ���ļ������н���
int32 gidb_win_ticket_callback(uint8 game_code,
                               uint64 issue_number,
                               uint8 draw_times,
                               PRIZE_LEVEL prize_level_array[MAX_PRIZE_COUNT],
                               WIN_TICKET_STAT *winTktStat);


//�����������ϴ��������ļ�
int32 gidb_seal_file(uint8 game_code, uint64 issue_number, TICKET_STAT *ticket_stat);

//������ֽ�����۵��н��ļ�
int32 gidb_generate_ap_win_file(uint8 game_code, uint64 issue_number, uint8 draw_times);

//�����н���ϸ�ļ�
int32 gidb_generate_issue_win_file(uint8 game_code, uint64 issue_number, uint8 draw_times, char *file);






//------------------------------
// ҵ������ log Interface
//------------------------------

struct _GIDB_DRIVERLOG_HANDLE;
typedef struct _GIDB_DRIVERLOG_HANDLE GIDB_DRIVERLOG_HANDLE;
struct _GIDB_DRIVERLOG_HANDLE {
    sqlite3 *db;

    int32 (*gidb_driverlog_append_dl)(GIDB_DRIVERLOG_HANDLE *self, uint32 game, uint64 issue, uint64 match, int32 msg_type, char *msg, int32 msg_len);
    int32 (*gidb_driverlog_get_last_dl)(GIDB_DRIVERLOG_HANDLE *self, uint32 type, uint32 *msgid, uint8 *msg_type,uint8 *gameCode, char *msg, uint32 *msg_len);
    int32 (*gidb_driverlog_confirm_dl)(GIDB_DRIVERLOG_HANDLE *self, uint32 msgid, uint32 flag);
};
//��ȡ���ʵĲ����ӿ�
GIDB_DRIVERLOG_HANDLE * gidb_driverlog_get_handle();
//�����˳�ʱ���ô˽ӿڹر�db�ļ�
int32 gidb_driverlog_close_handle();


#endif //GAME_ISSUE_H_INCLUDED

