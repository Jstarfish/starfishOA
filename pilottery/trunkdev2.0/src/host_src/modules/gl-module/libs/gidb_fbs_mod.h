#ifndef GAME_ISSUE_FBS_H_INCLUDED
#define GAME_ISSUE_FBS_H_INCLUDED

//�ڲ�����--------------------------------------------------------------------------------



// sqlite ���ݷ��ʵĽṹ��

//------------------------------
// issue & match manage Interface
//------------------------------

typedef struct _GIDB_FBS_ISSUE_INFO
{
    uint8 gameCode;                                 //��Ϸ����
    uint32 issueNumber; //�ڴα��
    uint32 publishTime; //�ڴη���ʱ��
    uint16 adjustmentFundRate; //���ڽ����
    uint16 returnRate; //���۷�����
    uint16 payEndDay; //�ҽ���(��)
} GIDB_FBS_ISSUE_INFO;

struct _GIDB_FBS_IM_HANDLE;
typedef struct _GIDB_FBS_IM_HANDLE GIDB_FBS_IM_HANDLE;
struct _GIDB_FBS_IM_HANDLE {
    uint8 game_code;
    sqlite3 *db;

    int32 (*gidb_fbs_im_init_data)(GIDB_FBS_IM_HANDLE *self);
    int32 (*gidb_fbs_im_insert_issue)(GIDB_FBS_IM_HANDLE *self, GIDB_FBS_ISSUE_INFO *p_issue_info);
    int32 (*gidb_fbs_im_get_issue)(GIDB_FBS_IM_HANDLE *self, uint32 issue_number, GIDB_FBS_ISSUE_INFO *p_issue_info);
    int32 (*gidb_fbs_im_del_issue)(GIDB_FBS_IM_HANDLE *self, uint32 issue_number); //ɾ��ָ���ڴμ��ڴ���������г���
    int32 (*gidb_fbs_im_insert_matches)(GIDB_FBS_IM_HANDLE *self, GIDB_FBS_MATCH_INFO *p_matches, int match_count);
    int32 (*gidb_fbs_im_del_match)(GIDB_FBS_IM_HANDLE *self, uint32 match_code); //ɾ��ָ���ı���

    int32 (*gidb_fbs_im_get_matches)(GIDB_FBS_IM_HANDLE *self, uint32 issue_number, GIDB_FBS_MATCH_INFO *p_matches); //����ָ���ڴεı���������
    int32 (*gidb_fbs_im_get_match)(GIDB_FBS_IM_HANDLE *self, uint32 match_code, GIDB_FBS_MATCH_INFO *p_match_info); //����ָ���ı�����Ϣ
};
//��ȡ�ڴη��ʵĲ����ӿ�
GIDB_FBS_IM_HANDLE * gidb_fbs_im_get_handle(uint8 game_code);

//�ر�ָ����handle
int32 gidb_fbs_im_close_handle(GIDB_FBS_IM_HANDLE *handle);
//�رճ�ʱ��δʹ�õ�handle
int gidb_fbs_im_clean_handle();
//�ر����д򿪵�handle
int gidb_fbs_im_close_all_handle();



//------------------------------
// �ҽ� �� ��Ʊ �ӿ�ʹ�õĽṹ
//------------------------------

//���¶ҽ���Ϣʹ�õĽṹ��
typedef struct _GIDB_FBS_PT_STRUCT {
    char    reqfn_ticket_pay[TSN_LENGTH];    //�ҽ�������ˮ��(����)
    char    rspfn_ticket_pay[TSN_LENGTH];    //�ҽ�������ˮ��(��Ӧ)

    char    rspfn_ticket[TSN_LENGTH];        //��Ʊ������ˮ��(��Ӧ)
    uint64  unique_tsn;                      //Ψһ���

    uint32  timeStamp_pay;                   //ʱ��� -- �ҽ�

    uint8   from_pay;                        //Ʊ��Դ -- �ҽ�

    uint64  agencyCode_pay;                  //����վΨһ��� -- �ҽ�
    uint64  terminalCode_pay;                //�ն�Ψһ��� -- �ҽ�
    uint32  tellerCode_pay;                  //����ԱΨһ��� -- �ҽ�
    uint64  issueNumber_pay;                 //�ҽ�����ʱ���ں� -- �ҽ�

    //�Ҵ�ʹ�õ���Ϣ�ֶ�
    char    userName_pay[ENTRY_NAME_LEN];               //�û����� -- �ҽ�
    int     identityType_pay;                           //֤������ -- �ҽ�
    char    identityNumber_pay[IDENTITY_CARD_LENGTH];   //֤������ -- �ҽ�

    uint8   isTrain;                         //�Ƿ���ѵģʽ: ��(0)/��(1)

    uint8   gameCode;                        //��Ϸ����
    uint64  issueNumber;                     //�����ں�
    money_t ticketAmount;                    //Ʊ����
    uint8   isBigWinning;                    //�Ƿ��Ǵ�  0=����  1=��
    money_t winningAmountWithTax;            //������(��˰)
    money_t winningAmount;                   //������(����˰)
    money_t taxAmount;                       //����˰��
    int32   winningCount;                    //�ܵ��н�ע��

    uint8   paid_status;                     //�ҽ�״̬  enum PRIZE_PAYMENT_STATUS
} GIDB_FBS_PT_STRUCT;


//������Ʊ��Ϣʹ�õĽṹ��
typedef struct _GIDB_FBS_CT_STRUCT {
    char    reqfn_ticket_cancel[TSN_LENGTH]; //��Ʊ������ˮ��(����)
    char    rspfn_ticket_cancel[TSN_LENGTH]; //��Ʊ������ˮ��(��Ӧ)

    char    rspfn_ticket[TSN_LENGTH];        //��Ʊ������ˮ��(��Ӧ)
    uint64  unique_tsn;                      //Ψһ���

    uint32  timeStamp_cancel;                //ʱ��� -- ��Ʊ

    uint8   from_cancel;                     //Ʊ��Դ -- ��Ʊ

    uint64  agencyCode_cancel;               //����վ���� -- ��Ʊ
    uint64  terminalCode_cancel;             //�ն˱��� -- ��Ʊ
    uint32  tellerCode_cancel;               //Teller���� -- ��Ʊ

    uint8   isTrain;                         //�Ƿ���ѵģʽ: ��(0)/��(1)
    money_t cancelAmount;                    //��Ʊ���
    uint32  betCount;                        //��ע��

    //Ʊ��Ϣ
    FBS_TICKET ticket;                       //Ʊ��Ϣ
} GIDB_FBS_CT_STRUCT;


//------------------------------
// sale ticket Interface
//------------------------------
typedef struct _GIDB_FBS_ST_REC {
    uint64    unique_tsn;                      //Ψһ���
    char      reqfn_ticket[TSN_LENGTH];        //��Ʊ������ˮ��(����)
    char      rspfn_ticket[TSN_LENGTH];        //��Ʊ������ˮ��(��Ӧ)
    time_type time_stamp;                      //ʱ���

    uint8     from_sale;                       //Ʊ��Դ

    uint32    area_code;                       //�����������
    uint8     area_type;                       //������������
    uint64    agency_code;                     //����վ����
    uint64    terminal_code;                   //�ն˱���
    uint32    teller_code;                     //Teller����

    uint8     claiming_scope;                  //��Ϸ�ҽ���Χ, enum AREA_LEVEL

    uint8     is_train;                        //�Ƿ���ѵģʽ: ��(0)/��(1)

    uint8     game_code;                       //��Ϸ����
    uint32    issue_number;                    //�����ں�
    uint8     sub_type;                        //�淨
    uint8     bet_type;                        //���ط�ʽ(Ͷע��ʽ)
    money_t   total_amount;                    //Ͷע�ܽ��  �Ѱ�����Ͷ
    money_t   commissionAmount;                //��ƱӶ�𷵻����
    uint32    total_bets;                      //Ͷע��ע��  �Ѱ�����Ͷ
    uint16    bet_times;                       //Ͷע����

    uint16    match_count;                     //ѡ��ĳ�������
    uint16    order_count;                     //��ֵĶ�������
    uint16    bet_string_len;                  //��������һ��'\0'
    char      bet_string[MAX_BET_STRING_LENGTH];//Ͷע�ַ���

    uint8     isCancel;                        //�Ƿ�����Ʊ
    //��¼һЩ��Ʊ������վ��Ϣ����Ϸ��Ϣ
    uint8     from_cancel;                     //Ʊ��Դ -- ��Ʊ
    char      reqfn_ticket_cancel[TSN_LENGTH]; //��Ʊ������ˮ��(����)
    char      rspfn_ticket_cancel[TSN_LENGTH]; //��Ʊ������ˮ��(��Ӧ)
    time_type timeStamp_cancel;                //ʱ��� -- ��Ʊ
    uint64    agencyCode_cancel;               //����վ���� -- ��Ʊ
    uint64    terminalCode_cancel;             //�ն˱��� -- ��Ʊ
    uint32    tellerCode_cancel;               //Teller���� -- ��Ʊ

    FBS_TICKET ticket;                          //Ʊ��Ϣ
}GIDB_FBS_ST_REC;

typedef struct _FBS_GT_GAME_PARAM
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
}FBS_GT_GAME_PARAM;

//�����������ֶ�key
typedef enum _FBS_ST_FIELD_BLOB_KEY
{
    FBS_ST_GAME_PARAMBLOB_KEY = 1,
    FBS_ST_SUBTYPE_PARAMBLOB_KEY,
    FBS_ST_POOL_PARAMBLOB_KEY,
}FBS_ST_FIELD_BLOB_KEY;

typedef list<GIDB_FBS_ST_REC *> FBS_ST_LIST;
typedef list<GIDB_FBS_CT_STRUCT *> FBS_CT_LIST;

struct _GIDB_FBS_ST_HANDLE;
typedef struct _GIDB_FBS_ST_HANDLE GIDB_FBS_ST_HANDLE;
struct _GIDB_FBS_ST_HANDLE {
    _GIDB_FBS_ST_HANDLE(){}
    uint8  game_code;
    uint32 issue_number;
    uint32 last_time; //���һ�η���ʱ��
    sqlite3 *db;

    bool commit_flag;
    FBS_ST_LIST saleTicketList;
    FBS_CT_LIST cancelTicketList;

    int32 (*gidb_fbs_st_set_field_blob)(GIDB_FBS_ST_HANDLE *self, FBS_ST_FIELD_BLOB_KEY field_type, char *data, int32 len);
    int32 (*gidb_fbs_st_get_field_blob)(GIDB_FBS_ST_HANDLE *self, FBS_ST_FIELD_BLOB_KEY field_type, char *data, int32 *len);

    //��������Ʊ (�ڲ�֧�ֶ���Ʊ�Ĳ���) (����ʽ���룬������ɺ���Ҫ����ͬ���ӿڣ����ܸ��µ����ݿ�) 
    int32 (*gidb_fbs_st_insert_ticket)(GIDB_FBS_ST_HANDLE *self, GIDB_FBS_ST_REC *pSTicket);
    //���²�ƱΪ����Ʊ(����ʽ���룬������ɺ���Ҫ����ͬ���ӿڣ����ܸ��µ����ݿ�)
    int32 (*gidb_fbs_st_update_cancel)(GIDB_FBS_ST_HANDLE *self, GIDB_FBS_CT_STRUCT *pCTicket);
    //�����ڵ�LIST�ڴ��е�(��Ʊ����Ʊ�ļ�¼)����д�����ݿ��ļ�
    int32 (*gidb_fbs_st_sync_sc_ticket)(GIDB_FBS_ST_HANDLE *self);
    //get ticket by rspfn_ticket
    int32 (*gidb_fbs_st_get_ticket)(GIDB_FBS_ST_HANDLE *self, uint64 unique_tsn, GIDB_FBS_ST_REC *pSTicket);
};
typedef map<uint64, GIDB_FBS_ST_HANDLE*> FBS_ST_MAP;

//��ȡ�ڴη��ʵĲ����ӿ�
GIDB_FBS_ST_HANDLE* gidb_fbs_st_get_handle(uint8 game_code, uint32 issue_number);
//�ر�ָ����handle
int32 gidb_fbs_st_close_handle(GIDB_FBS_ST_HANDLE *handle);
//�رճ�ʱ��δʹ�õ�handle
int gidb_fbs_st_clean_handle();
//�ر����д򿪵�handle
int gidb_fbs_st_close_all_handle();




//------------------------------
// win ticket Interface
//------------------------------

typedef struct _GIDB_FBS_WT_REC {
    uint64    unique_tsn;                      //Ψһ���
    char      reqfn_ticket[TSN_LENGTH];        //��Ʊ������ˮ��(����)
    char      rspfn_ticket[TSN_LENGTH];        //��Ʊ������ˮ��(��Ӧ)
    time_type time_stamp;                      //ʱ���

    uint8     from_sale;                       //Ʊ��Դ

    uint32    area_code;                       //�����������
    uint8     area_type;                       //������������
    uint64    agency_code;                     //����վ����
    uint64    terminal_code;                   //�ն˱���
    uint32    teller_code;                     //Teller����

    uint8     claiming_scope;                  //��Ϸ�ҽ���Χ, enum AREA_LEVEL
    uint8     is_train;                        //�Ƿ���ѵģʽ: ��(0)/��(1)

    uint8     game_code;                       //��Ϸ����
    uint32    issue_number;                    //�����ں�
    uint8     sub_type;                        //�淨
    uint8     bet_type;                        //���ط�ʽ(Ͷע��ʽ)
    money_t   total_amount;                    //Ͷע�ܽ��
    uint32    total_bets;                      //Ͷע��ע��
    uint16    bet_times;                       //Ͷע����

    uint16    match_count;                     //ѡ��ĳ�������
    uint16    order_count;                     //��ֵĶ�������

    //Ͷע����Ϣ
    uint32    bet_string_len;
    char      bet_string[MAX_BET_STRING_LENGTH]; //Ͷע�����ַ���

    uint32    win_match_code;                  //����һ�������Ŀ����������н�

    //�������н�����Ϣ
    uint8     isBigWinning;                    //�Ƿ��Ǵ�  0=����  1=��
    money_t   winningAmountWithTax;            //������(��˰)
    money_t   winningAmount;                   //������(����˰)
    money_t   taxAmount;                       //����˰��
    int32     winningCount;                    //�ܵ��н�ע��

    //�ҽ�״̬
    uint8     paid_status;                     //�ҽ�״̬  enum PRIZE_PAYMENT_STATUS

    //��¼һЩ�ҽ�������վ��Ϣ����Ϸ��Ϣ
    uint8     from_pay;                        //Ʊ��Դ -- �ҽ�
    char      reqfn_ticket_pay[TSN_LENGTH];    //�ҽ�������ˮ��(����)
    char      rspfn_ticket_pay[TSN_LENGTH];    //�ҽ�������ˮ��(��Ӧ)
    time_type timeStamp_pay;                   //ʱ��� -- �ҽ�
    
    uint64    agencyCode_pay;                  //����վΨһ��� -- �ҽ�
    uint64    terminalCode_pay;                //�ն�Ψһ��� -- �ҽ�
    uint32    tellerCode_pay;                  //����ԱΨһ��� -- �ҽ�

    //�Ҵ�ʹ�õ���Ϣ�ֶ�
    char      userName_pay[ENTRY_NAME_LEN];    //�û�����
    int       identityType_pay;                //֤������
    char      identityNumber_pay[IDENTITY_CARD_LENGTH]; //֤������
}GIDB_FBS_WT_REC;

typedef struct _GIDB_FBS_WO_REC {
    uint64    unique_tsn;
    uint16    ord_no;                          //�𵥱��

    money_t   winningAmountWithTax;            //�н����
    money_t   winningAmount;                   //�н����(����˰)
    money_t   taxAmount;                       //˰��
    int32     winningCount;                    //�н�ע��

    uint8     game_code;                       //��Ϸ
    uint8     sub_type;                        //�淨
    uint8     bet_type;                        //���ط�ʽ(Ͷע��ʽ)
    money_t   bet_amount;                      //��Ͷע���
    uint32    bet_count;                       //��Ͷעע��

    uint32    win_match_code;                  //����һ�������Ŀ����������н�

    uint8     state;                           //״̬ ( 0 Ͷע  1 �ѹ���  2 ����ʧ��  3 ȫ������  4 ����Ͷע������ȡ������Ʊ����)

    uint8     match_count;
    FBS_BETM  match_array[];                   //������Ͷע��Ϣ
}GIDB_FBS_WO_REC;

typedef list<GIDB_FBS_PT_STRUCT *> FBS_PT_LIST;
typedef list<GIDB_FBS_WT_REC *> FBS_WT_LIST;
typedef list<GIDB_FBS_WO_REC *> FBS_WO_LIST;
typedef list<GIDB_FBS_WT_REC *> FBS_SRT_LIST; //��Ե���Ͷע����������ȡ�������

struct _GIDB_FBS_WT_HANDLE;
typedef struct _GIDB_FBS_WT_HANDLE GIDB_FBS_WT_HANDLE;
struct _GIDB_FBS_WT_HANDLE {
    _GIDB_FBS_WT_HANDLE(){}
    uint8  game_code;
    uint32 issue_number;
    uint8  draw_times;
    uint32 last_time; //���һ�η���ʱ��
    sqlite3 *db;

    //tf_updateʹ�ã����������������
    bool commit_flag_pay;
    FBS_PT_LIST payTicketList;

    bool commit_flag_win;
    FBS_WT_LIST winTicketList;

    bool commit_flag_order;
    FBS_WO_LIST winOrderList;

    //bool commit_flag_single_return;
    //FBS_SRT_LIST singleReturnTicketList;

    //���²�ƱΪ�Ѷҽ�(����ʽ���룬������ɺ���Ҫ����ͬ���ӿڣ����ܸ��µ����ݿ�)
    int32 (*gidb_fbs_wt_update_pay)(GIDB_FBS_WT_HANDLE *self, GIDB_FBS_PT_STRUCT *pPTicket);
    //�����ڵ�LIST�ڴ��е�(�ҽ��ļ�¼)����д�����ݿ��ļ�
    int32 (*gidb_fbs_wt_sync_pay_ticket)(GIDB_FBS_WT_HANDLE *self);

    //���н�Ʊ�Ľ�������ڴ�����
    int32 (*gidb_fbs_wt_insert_ticket)(GIDB_FBS_WT_HANDLE *self, GIDB_FBS_WT_REC *pWTicket);
    int32 (*gidb_fbs_wt_insert_order)(GIDB_FBS_WT_HANDLE *self, GIDB_FBS_WO_REC *pWOrder);
    //int32 (*gidb_fbs_wt_insert_return)(GIDB_FBS_WT_HANDLE *self, GIDB_FBS_WT_REC *pSRTicket);
    //��LIST�ڴ��е��н�Ʊд�����ݿ��ļ�
    int32 (*gidb_fbs_wt_sync_ticket)(GIDB_FBS_WT_HANDLE *self);
    //���ָ�����ο������н�Ʊ����
    int32 (*gidb_fbs_wt_clean)(GIDB_FBS_WT_HANDLE *self, uint32 match_code);

    //get win ticket by rspfn_ticket
    int32 (*gidb_fbs_wt_get_ticket)(GIDB_FBS_WT_HANDLE *self, uint64 unique_tsn, GIDB_FBS_WT_REC *pWTicket);
    int32 (*gidb_fbs_wt_get_ticket_sum)(GIDB_FBS_WT_HANDLE *self,
            uint64 unique_tsn,
            int64 *winning_amount_tax,
            int64 *winning_amount,
            int64 *tax_amount,
            int32 *winning_count);
};
typedef map<uint64, GIDB_FBS_WT_HANDLE*> FBS_WT_MAP;

//ͨ���ڴ���ŵõ��ڴ�handle
GIDB_FBS_WT_HANDLE * gidb_fbs_wt_get_handle(uint8 game_code, uint32 issue_number);

//�ر�ָ����handle
int32 gidb_fbs_wt_close_handle(GIDB_FBS_WT_HANDLE *handle);
//�رճ�ʱ��δʹ�õ�handle
int gidb_fbs_wt_clean_handle();
//�ر����д򿪵�handle
int gidb_fbs_wt_close_all_handle();

//FBS����������ͬ�� win order ��  win ticket
int32 gidb_fbs_wt_sync_draw_ticket();


//ͬ��FBS��Ϸ�������ݵ����ݿ��ļ�(���ۡ��ҽ�����Ʊ)
int32 gidb_fbs_sync_spc_ticket();


// draw  log  define -------------------------------------------------------

//------------------------------
// issue & match draw log Interface
//------------------------------
struct _GIDB_FBS_DL_HANDLE;
typedef struct _GIDB_FBS_DL_HANDLE GIDB_FBS_DL_HANDLE;
struct _GIDB_FBS_DL_HANDLE {
    uint8 game_code;
    sqlite3 *db;

    int32 (*gidb_fbs_dl_append)(GIDB_FBS_DL_HANDLE *self, uint32 issue_number, uint32 match_code, int32 msg_type, char *msg, int32 msg_len);
    int32 (*gidb_fbs_dl_get_last)(GIDB_FBS_DL_HANDLE *self, uint32 *msgid, uint8 *msg_type, char *msg, uint32 *msg_len);
    int32 (*gidb_fbs_dl_confirm)(GIDB_FBS_DL_HANDLE *self, uint32 msgid, uint32 flag);
    int32 (*gidb_fbs_dl_get_rec)(GIDB_FBS_DL_HANDLE *self, uint32 issue_number, uint32 match_code, int32 msg_type);
};

//��ȡ�ڴη��ʵĲ����ӿ�
GIDB_FBS_DL_HANDLE * gidb_fbs_dl_get_handle(uint8 game_code);

//�ر�ָ����handle
int32 gidb_fbs_dl_close_handle(GIDB_FBS_DL_HANDLE *handle);

//�ر����д򿪵�handle
int gidb_fbs_dl_close_all_handle();

// draw meta data file structure define -------------------------------------------------------

//meta�ļ������ݽṹ
typedef struct _META_ST {
    uint64  last_file_offset; //�ϴδ�����ɵ��ļ�ƫ��
    uint32  last_draw_sequence; //���һ�ο�����˳��
    uint32  last_issue_number; //���һ�δ������ں�(���ڲ�)
    uint64  last_unique_tsn; //���һ�δ���������Ʊ���� ���һ��unique_tsn

    // �����ֶα������һ�������Ŀ�����Ϣ
    uint32  last_match_code; //���һ�����������ı��
    uint32  last_draw_time; //���һ�ο�����ɵ�ʱ��
    SUB_RESULT s_results[FBS_SUBTYPE_NUM]; //�������ε�������Ϣ
    uint8      match_result[8]; //�������,���ݸ�ʽ����μ�  GLTP_MSG_O_FBS_DRAW_INPUT_RESULT_REQ�Ľṹ����
} META_ST;

// ����ʹ�õĲ𵥶������ļ���¼
enum {
    //��״̬ö��ֵ
    ORD_STATE_BET = 0,
    ORD_STATE_PASSED,
    ORD_STATE_NO_WIN,
    ORD_STATE_WIN,
    ORD_STATE_RETURN, //��Ե���Ͷע����������ȡ�������
};
typedef struct _FBS_ORDER_REC {
    uint16    length;

    uint64    unique_tsn;
    uint16    ord_no;                          //�𵥱��

    uint8     state;                           //״̬ ( 0 Ͷע  1 �ѹ���  2 ����ʧ��  3 ȫ������  4 ����Ͷע������ȡ������Ʊ����)
    uint8     passed_match;                    //�ѹ��ر�����Ŀ
    money_t   passed_amount;                   //���غ�Ľ�Ҳ�ǽ�����һ�ص�Ͷע��� ( ��ʼֵΪ ��ʼͶע��� )
    uint32    win_bet_count;                   //�н�ע�� (����Ͷ)
    uint32    win_match_code;                  //����һ�������Ŀ����������н�

    uint8     game_code;                       //��Ϸ
    uint32    issue_number;                    //�����ں�
    uint8     sub_type;                        //�淨
    uint8     bet_type;                        //���ط�ʽ(Ͷע��ʽ)
    money_t   bet_amount;                      //��Ͷע���
    uint32    bet_count;                       //��Ͷעע��
    uint16    bet_times;                       //Ͷע����

    uint8     match_count;
    FBS_BETM  match_array[];                   //������Ͷע��Ϣ
}FBS_ORDER_REC;




//��������ļ������ӿ�
//����Ϊ2��uint32 ��ֵ (uint32 match_code �� uint32 state)
//��һ��Ϊ ���ڽ��п����ı�������  �ڶ���Ϊ �������е���һ��( 1: ��¼�뿪�����룬�����㽱  2: �㽱��ɣ��ȴ�ȷ��)
//int flag   0: ������ļ��Ƿ����  1: ��������ļ�  2: ��ȡ����ļ�  3: ɾ������ļ�
uint64 fbs_draw_tag(char *filepath, uint32 match_code, uint32 state, int flag);

//meta �ļ������ӿ�
int fbs_read_draw_meta_file(char *filepath, META_ST *meta_ptr);
int fbs_write_draw_meta_file(char *filepath, META_ST *meta_ptr);
int fbs_verify_draw_order_file(char *filepath);





//bind  GIDB_FBS_MATCH_INFO to sqlite3_stmt  for insert
int32 bind_fbs_match(GIDB_FBS_MATCH_INFO *pMatchRec, sqlite3_stmt* pStmt);

//bind  GIDB_FBS_ST_REC to sqlite3_stmt  for insert
int32 bind_fbs_st_ticket(GIDB_FBS_ST_REC *pSTicket, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len);
//bind  GIDB_FBS_PT_STRUCT to sqlite3_stmt  for update pay ticket
int32 bind_fbs_update_pay_ticket(GIDB_FBS_PT_STRUCT *pPTicket, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len);
//bind  GIDB_FBS_CT_STRUCT to sqlite3_stmt  for update cancel ticket
int32 bind_fbs_update_cancel_ticket(GIDB_FBS_CT_STRUCT *pCTicket, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len);
//bind  GIDB_FBS_WT_REC to sqlite3_stmt  for insert
int32 bind_fbs_return_ticket(GIDB_FBS_WT_REC *pWTicket, sqlite3_stmt* pStmt);
//bind  GIDB_FBS_WT_REC to sqlite3_stmt  for insert
int32 bind_fbs_win_ticket(GIDB_FBS_WT_REC *pWTicket, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len);
//bind  GIDB_FBS_WO_REC to sqlite3_stmt  for insert
int32 bind_fbs_win_order(GIDB_FBS_WO_REC *pWOrder, sqlite3_stmt* pStmt);

//�Ӷ�����һ���������μ�¼������ GIDB_FBS_MATCH_INFO ��Ϣ
int32 get_fbs_match_rec_from_stmt(GIDB_FBS_MATCH_INFO *pMatchRec, sqlite3_stmt* pStmt);

//�Ӷ�����һ��sale ticket����¼������ GIDB_FBS_ST_REC ��Ϣ
int32 get_fbs_st_rec_from_stmt(GIDB_FBS_ST_REC *pSTicket, sqlite3_stmt* pStmt);
//�Ӷ�����һ��win ticket����¼������ GIDB_FBS_WT_REC ��Ϣ
int32 get_fbs_wt_rec_from_stmt(GIDB_FBS_WT_REC *pWTicket, sqlite3_stmt* pStmt);
//�Ӷ�����һ��win order����¼������ GIDB_FBS_WO_REC ��Ϣ
int32 get_fbs_wo_rec_from_stmt(GIDB_FBS_WO_REC *pWOrder, sqlite3_stmt* pStmt);

int32 fbs_sale_ticket_2_win_ticket_rec(GIDB_FBS_ST_REC *pSTicket, GIDB_FBS_WT_REC *pWTicket);
int32 fbs_order_rec_2_wo_rec(FBS_ORDER_REC *pOrder, GIDB_FBS_WO_REC *pWOrder, FBS_GT_GAME_PARAM *game);

int32 fbs_sell_inm_rec_2_db_tidx_rec(INM_MSG_FBS_SELL_TICKET *pInmMsg, GIDB_TICKET_IDX_REC *pTIdxRec);
int32 fbs_sell_inm_rec_2_db_ticket_rec(INM_MSG_FBS_SELL_TICKET *pInmMsg, GIDB_FBS_ST_REC *pSTicket);
int32 fbs_pay_inm_rec_2_db_ticket_rec(INM_MSG_FBS_PAY_TICKET *pInmMsg, GIDB_FBS_PT_STRUCT *pPTicket);
int32 fbs_cancel_inm_rec_2_db_ticket_rec(INM_MSG_FBS_CANCEL_TICKET *pInmMsg, GIDB_FBS_CT_STRUCT *pCTicket);

int32 O_fbs_pay_inm_rec_2_db_ticket_rec(INM_MSG_O_FBS_PAY_TICKET *pInmMsg, GIDB_FBS_PT_STRUCT *pPTicket);
int32 O_fbs_cancel_inm_rec_2_db_ticket_rec(INM_MSG_O_FBS_CANCEL_TICKET *pInmMsg, GIDB_FBS_CT_STRUCT *pCTicket);
    
int32 AP_fbs_pay_inm_rec_2_db_ticket_rec(INM_MSG_AP_PAY_TICKET *pInmMsg, GIDB_FBS_PT_STRUCT *pPTicket);
int gidb_fbs_save_game_param(uint8 game_code, uint32 issue_number);

//�����н���ϸ�ļ�
int32 gidb_fbs_generate_match_win_file(uint8 game_code, uint32 issue_number, uint32 match_code, uint8 draw_times, char *file);


#endif //GAME_ISSUE_FBS_H_INCLUDED
