#ifndef GL_PLUGIN_INF_H_INCLUDED
#define GL_PLUGIN_INF_H_INCLUDED


// ----------------------------------------------------------------------------------------
//
// ��Ϸ����������ݽṹ����
//
// ----------------------------------------------------------------------------------------

typedef enum _PLUGIN_FUN_TYPE
{
    //TTY
    TTY_SPECPRIZE = 1, //��ȡTTY���⽱��������־

    //7LX

} PLUGIN_FUN_TYPE;

//Ͷע��ʽ���ұ�
const char bettypeAbbr[MAX_BETTYPE_COUNT][10] = {"", "DS", "FS", "DT", "BD", "HZ", "BC", "BH", "YXFS", "FW"};
//��Ϸ�淨���ұ�
const char subtypeAbbr[MAX_GAME_NUMBER][MAX_SUBTYPE_COUNT][10] = {
        //0
        {{0}},

        //SSQ(1)
        {"", "ZX"},
    
        //3D(2)
        {"", "ZX", "ZUX", "Z3", "Z6"},

        //KENO(3)
        {{0}},

        //7LC(4)
        {"", "ZX"},

        //SSC(5)
        {"", "1ZX", "2ZX", "2FX", "2ZUX", "3ZX", "3FX", "3ZUX", "3Z3", "3Z6", "5ZX", "5FX", "5TX", "DXDS"},

        //KOCTTY(6)
        {"", "QH2", "QH3", "4ZX","Q2","H2","Q3","H3"},

        //KOC7LX(7)
        {"", "ZX", "ZXHALF"},

        //KOCKENO(8)
        {"", "X1", "X2", "X3", "X4", "X5", "X6", "X7", "X8", "X9", "X10", "DX", "DS"},

        //KOCK2(9)
        {"", "JC", "4T"},

        //KOCC30S6(10)
        {"", "ZX"},

        //KOCK3(11)
        {"", "ZX", "3TA", "3TS", "3QA", "3DS", "2TA", "2TS", "2DS"},

        //KOC11X5(12)
        {"", "RX2", "RX3", "RX4", "RX5", "RX6", "RX7", "RX8", "Q1", "Q2ZU", "Q3ZU", "Q2ZX", "Q3ZX" },

        //(13)
        {"", "DG", "WH"},

        //FBS(14)
        {"", "WIN","HCP","TOT","SCR","HFT","OUOD"},
};


//���տ���ģʽ
typedef enum _RISK_MODE
{
    RISK_MODE_NOUSED  = 1,
    RISK_MODE_MAXPAY  = 2,
    RISK_MODE_MAXBET  = 3,
    RISK_MODE_COMBINE = 4,
} RISK_MODE;


//���ȷ������
typedef enum _ASSIGN_TYPE
{
    ASSIGN_UNUSED = 0,
    ASSIGN_SHARED = 1,  //��������
    ASSIGN_FIXED  = 2,  //�̶�����
}ASSIGN_TYPE;


//�������
typedef enum _POOL_TYPE
{
     //FIX_POOL = 0,                 //�̶�����
     SUB_POOL   = 1,             //�淨����
     GAME_POOL  = 2,             //��Ϸ����
     NOUSE_POOL = 3,
}POOL_TYPE;


enum
{
    WINNER_LOCAL_FILE = 1,
    WINNER_CONFIRM_FILE
};


#pragma pack(1)

typedef struct _ISSUE_INFO_STAT
{
    money_t issueSaleAmount;                        //�ڴ����۽�����δ���ڣ�
    uint32  issueSaleCount;                         //�ڴ���ƱƱ��������δ���ڣ�
    uint32  issueSaleBetCount;                      //�ڴ���Ʊע��������δ���ڣ�

    money_t issueCancelAmount;                      //�ڴ���Ʊ������δ���ڣ�
    uint32  issueCancelCount;                       //�ڴ���ƱƱ��������δ���ڣ�
    uint32  issueCancelBetCount;                    //�ڴ���Ʊע��������δ���ڣ�

    money_t issueRefuseAmount;                      //�ڴη��տ�����ɵľܾ����۽��
    uint32  issueRefuseCount;                       //�ڴη��տ�����ɵľܾ����۴���

    //--------------------------------------------------------------------------------------------------
    //�����������ֶ�����Ҳ�����Բ���Ҫ�����ڽ��ʱ�̣�����Ľ��ؽ��Ӧ�ô����ݿ��л�ȡ
    //money_t firstPoolAvailableCredit;               //�ڳ���һ�����ʽ����
    //money_t secondPoolAvailableCredit;              //�ڳ��ڶ������ʽ����
    //--------------------------------------------------------------------------------------------------

} ISSUE_INFO_STAT;

typedef struct _ISSUE_INFO
{
    bool      used;
    uint8     gameCode;                             // ��Ϸ����
    uint64    issueNumber;                          // �ں�
    uint32    serialNumber;                         // �ڴ����
    uint8     curState;
    uint8     localState;
    time_type startTime;
    time_type closeTime;
    time_type drawTime;
    uint32    payEndDay;                            // �ҽ���ֹ����
    bool      willSaleFlagGl;                       // ��Ϸ�ڴο�Ԥ���ѷ��ͱ�־ GL�����޸�

    char      drawCodeStr[MAX_GAME_RESULTS_STR_LEN];// ��������
    char      winConfigStr[MAX_GAME_RESULTS_STR_LEN]; //�㽱���ò����ַ���

    ISSUE_INFO_STAT stat;
} ISSUE_INFO;


typedef struct _GL_ISSUE_CHKP_DATA
{
    ISSUE_INFO issueData[MAX_ISSUE_NUMBER];
}GL_ISSUE_CHKP_DATA;

//��Ϸ����ӿڵĽṹ�嶨�� ---------------------------------------------------------


//�����������
typedef struct _PRIZE_PARAM
{
    bool used; //�Ƿ�ʹ��
    uint8 prizeCode;  // �������
    char prizeName[ENTRY_NAME_LEN];
    bool hflag;//�ߵȽ����
    ASSIGN_TYPE assignType; //�������
    union
    {
        money_t sharedPrizeAmount;  //��������
        money_t fixedPrizeAmount;   //�̶�����
    };
} PRIZE_PARAM;

//��Ϸ���ز���
typedef struct _POOL_PARAM
{
    char poolName[ENTRY_NAME_LEN];
    money_t poolAmount; //���ؿ��ý��
} POOL_PARAM;


// {{ plugin interface define begin
// {{�������ģ�����Ͷ���

typedef struct _GL_PRIZE_CALC
{
    // �������
    money_t saleAmount; // �����ܶ�
    POOL_AMOUNT pool; // ����
    money_t adjustAmount; // ���ڻ����ܶ�
    money_t publishAmount; // ���л����ܶ�
    uint16  returnRate; //������

    // ���������� ʵ��ʹ�õĽ��
    money_t prizeAmount; // �����ܺͣ������ߵȽ����̶���
    POOL_AMOUNT poolUsed; // ������Ҫ���뽱�صĽ��(�������۶�*���۷�����-�����ɽ��ܶ�)
    money_t highPrize2Adjust; // �ߵȽ���ת����ڻ����Ǯ, �ߵȽ���Ĩ��ֵת����ڻ���
    int32 moneyEnough;      // ���ڽ����Ƿ���
}GL_PRIZE_CALC;

// ��������
// ��������͸�������ԣ�prizeWinnerSupplementNum first100PrizeBase prizeSupplement first100PrizeSupplement
// ������Ϸ����Щ�ֶ���Ϊ0
typedef struct _GL_PRIZE_INFO
{
    // �������
    uint32 prizeBaseCount; // ����Ͷע�н���
    uint32 prizeAddCount; // ׷��Ͷע�н���, ��������͸��������

    // ��������
    money_t prizeBaseAmount; // ����Ͷע������Ŀ

    money_t prizeAddAmount; // ׷��Ͷע������Ŀ, ��������͸��������
    money_t first100PrizeBase; // ǰһ����Ͷע����������Ŀ, ��������͸��������
    money_t first100PrizeAdd; // ǰһ����׷��Ͷע������Ŀ, ��������͸��������

    // �淨����
    uint32 subtypeCode;
} GL_PRIZE_INFO;

// }}�������ģ�����Ͷ���


typedef struct _PRIZE_PARAM_ISSUE
{
    uint8 prizeCode;  // �������
    money_t prizeAmount;   //����
} PRIZE_PARAM_ISSUE;

typedef struct _GL_PLUGIN_INFO
{
    int  issueCount;     //��������ʱ ������ڿռ�������mem_create�и�ֵ
    void *subtype_info;  //�淨���������
    void *division_info; //ƥ����������

    // ���в����ڴ��С���������
    void *issue_info;   //����Ϣ
    void *prize_info;   //����
    void *pool_info;    //����
    void *rk_info;      //���
}GL_PLUGIN_INFO;
typedef GL_PLUGIN_INFO* GL_PLUGIN_INFO_PTR;


//��Ϸ����Ľӿ� -------------------------------------------------------------------------------
typedef struct _BETPART_STR
{
    char bpALL[7][100]; //Ͷע���봮��ð�ŷָ����
    int bpALLCnt;       //ð�ŷָ����ֵĸ���
    
    char bpADT[2][100]; //bpALL[0]��С�ںŷָ����
    int bpADTCnt;       //С�ںŷָ����ֵĸ���(1�޵���2�е���)
    
    char bpAE[7][100];  //bpAE[0]��ŵ�����(bpADT[0])�ļӺŲ��
                        //bpAE[i](i����)���bpALL[i](i����)�ļӺŲ��
    int bpAECnt[7];
    
    char bpAT[100];     //������(bpADT[1]����)�ļӺŷָ����
    int bpATCnt;
} BETPART_STR;


//������Ϸ����д���õ���Ϸ���룬��Ϸ�����÷���0��ʧ�ܷ���-1
int gl_formatGame(const char *betStr);

//��Ͷע�ַ���תΪTICKET�ṹ�壬����TICKET�ṹ�峤��
int gl_formatTicket(const char *betStr, char *ticket_buf, int buf_len);
int gl_fbs_formatTicket(const char *betStr, char *ticket_buf, int buf_len);
void gl_dumpFbsTicket(FBS_TICKET *ticket);
void gl_dumpTicket(TICKET *ticket);
int splitBetpart(const char buf[], BETPART_STR *bpStr, int flag = 0);


//��������ģ�壬�����㽱�ӿں���
typedef struct _GT_PRIZE_PARAM
{
    PRIZE_PARAM  prize_param[MAX_PRIZE_COUNT];
    char         calc_struct[100];             //������������ַ���
}GT_PRIZE_PARAM;






// ----------------------------------------------------------------------------------------
//
// FBS ��Ϸ����������ݽṹ����
//
// ----------------------------------------------------------------------------------------






// ----------------------------------------------------------------------------------------
//
// ��Ϸ����ӿڶ���
//
// ----------------------------------------------------------------------------------------

typedef struct _GAME_PLUGIN_INTERFACE
{
    uint8 gameCode;

    bool (*mem_creat)(int issue_count);    //��Ϸ�淨��ƥ�䣬��صȲ��������ڴ洴��
    bool (*mem_destroy)(void);
    bool (*mem_attach)(void);
    bool (*mem_detach)(void);
    void *(*get_mem_db)(void); // For tsview

    bool (*load_memdata)(void); //�ڴ����ݳ�ʼ��

    ISSUE_INFO* (*get_issueTable)(void);
    void* (*get_subtypeTable)(int *len);
    void* (*get_divisionTable)(int *len, uint64 issueNum);
    PRIZE_PARAM* (*get_prizeTable)(uint64 issueNum); //��ȡ���������б�
    POOL_PARAM* (*get_poolParam)(void); //��ȡ���ز����б�
    void* (*get_rkTable)(void);

    int (*get_singleAmount)(char *buffer, size_t len);

    ISSUE_INFO* (*get_currIssue)();//��ȡ��ǰ��,���û�з���NULL
    ISSUE_INFO* (*get_issueInfo)(uint64 issueNum);
    ISSUE_INFO* (*get_issueInfo2)(uint32 issueSerial);
    uint32 (*get_issueCurrMaxSeq)(void);

    int (*sale_ticket_verify)(const TICKET* pTicket);
    int (*create_drawNum)(const uint8 xcodes[], uint8 len);//���ɿ��������Ӧ��bitmap
    int (*match_ticket)(const TICKET *ticket, const char *subtype, const char *division, uint32 matchRet[MAX_PRIZE_COUNT]);//ƥ��
    int (*calc_prize)(uint64 issue_number, GL_PRIZE_CALC *przCalc, GT_PRIZE_PARAM *prizeTemplate, GL_PRIZE_INFO prizeInfo[MAX_PRIZE_COUNT]);//�㽱

    // buf: Ͷע�к�����(����������)
    // length: buf�ĳ���
    // mode: bitmap��ģʽ
    // betline: �������betline
    int (*format_ticket)(char* buf, uint32 length, int mode, BETLINE* betline);

    bool (*sale_rk_verify)(TICKET* pTicket);
    void (*sale_rk_commit)(TICKET* pTicket);
    void (*cancel_rk_rollback)(TICKET* pTicket);
    void (*cancel_rk_commit)(TICKET* pTicket);
    void (*rk_reinitData)(void);

    //currMaxPay ���TTY����һ���ṹ��,����3���淨�� money_t ����ֵ; ���KENO,K2 ��Ϸ,��� &money_t �ȿ�
    bool (*get_rkReportData)(uint32 issueSeq,void *currMaxPay);

    int (*get_issueMaxCount)();
    int (*get_issueCount)();
    int (*load_newIssueData)(void *issueBuf, int32 issueCount); // ISSUE_CFG_DATA * list --> issueBuf
    int (*load_oldIssueData)(void *issueBuf, int32 issueCount); //ISSUE_INFO * list --> issueBuf ,stat data in issueBuf
    bool (*del_issue)(uint64 issueNum);
    bool (*clear_oneIssueData)(uint64 issueNum);

    bool (*chkp_saveData)(const char *filePath); //�������checkpoint, �����ڴ�ͳ�����ݡ��ڴη��տ�������
    bool (*chkp_restoreData)(const char *filePath);

    bool (*load_prizeParam)(uint64 issue,PRIZE_PARAM_ISSUE *prize); // load prize param of issue,prize[MAX_PRIZE_COUNT]
    bool (*load_issue_RKdata)(uint32 startIssueSeq,int issue_count, char *rk_param);

    int (*resolve_winConfigString)(uint64 issue, void *buf); //����ĳ�ڵ��㽱���ò����ַ������������buf

    // for tsview
    PRIZE_PARAM* (*get_prizeTableStart)(void);
    ISSUE_INFO* (*get_issueInfoByIndex)(int idx);
    void* (*get_rkIssueDataTable)(void);
    char* (*get_winConfigString)(uint64 issue); //��ȡĳ�ڵ��㽱���ò����ַ���
    // an opaque 'handle' for the loaded dynamic library
    void *fun_handle;

    //ͨ�õĺ���������һЩ���⹦��(��get TTY���⽱���������)
    int (*gen_fun)(int type, char *in, char *out);


    // FBS ʹ�õĽӿڶ��� ----------------------------------------
    int (*fbs_update_configuration)(char *config_string);
    //
    FBS_SUBTYPE_PARAM* (*fbs_get_subtypeParam)(uint32 subtype);
    const char*(*fbs_get_result_string)(uint8 subtype, uint8 result_enum);
    //
    int (*fbs_load_issue)(int n, DB_FBS_ISSUE *issue_list);
    FBS_ISSUE* (*fbs_get_issue)(uint32 issue_number);
    int (*fbs_del_issue)(uint32 issue_number);
    FBS_MATCH* (*fbs_get_match)(uint32 issue_number, uint32 match_code);
    int (*fbs_del_match)(uint32 match_code);
    int (*fbs_calc_rt_odds)(FBS_TICKET *ticket);
    int (*fbs_update_match_result)(uint32 issue_number, uint32 match_code, SUB_RESULT s_results[], uint8 match_result[]);

    int (*fbs_load_match)(int n, uint32 issue_number, DB_FBS_MATCH *match_list);
    int (*fbs_load_newMatch)(void);
    //�ⲿ�ж��Ƿ�Ϊ���Ƿ����
    FBS_ISSUE* (*fbs_get_issueTable)(void);
    //
    int (*fbs_format_ticket)(const char* buf, FBS_TICKET *ticket);
    int (*fbs_split_order)(FBS_TICKET *ticket);
    //
    int (*fbs_ticket_verify)(const FBS_TICKET* ticket, uint32 *outDate);//�������һ�������Ĺر�����(����������)

    //������淨������������������ϴ�DB��OMS���ʹ��
    int (*fbs_sale_calc)(uint32 issue_number, uint32 match_code, char *outBuf);

    //
    int (*fbs_sale_rk_verify)(FBS_TICKET* ticket);
    int (*fbs_sale_rk_commit)(FBS_TICKET* ticket);
    int (*fbs_cancel_rk_rollback)(FBS_TICKET* ticket);
    int (*fbs_cancel_rk_commit)(FBS_TICKET* ticket);
    //
    bool (*fbs_chkp_saveData)(const char *filePath);
    bool (*fbs_chkp_restoreData)(const char *filePath);

}GAME_PLUGIN_INTERFACE;

typedef bool (*PLUGIN_INIT_FUN)(GAME_PLUGIN_INTERFACE *plugin_i);




//���������ڴ�
int gl_game_plugins_create();
//���ٹ����ڴ�
int gl_game_plugins_destroy();

//ʹ��ĳ����Ϸ�����ʼ�������ҹ����ڴ�
int gl_game_plugins_init_game(uint8 gameCode, GAME_PLUGIN_INTERFACE *out);

//ʹ����Ϸ�����ʼ��
int gl_game_plugins_init();
//ʹ����Ϸ�����ɹر�
int gl_game_plugins_close();

GAME_PLUGIN_INTERFACE *gl_plugins_handle();


//ʹ����Ϸ�����ʼ��(��attach�����ڴ�)
GAME_PLUGIN_INTERFACE *gl_plugins_handle_s(uint8 game_code);





//��Ϸ����ڲ����ýṹ���� ------------------------------------------------------------------------

#define GL_BETLINE(ticket) ((void*) ((char*)ticket + sizeof(TICKET) + ticket->betStringLen))
#define GL_BETLINE_NEXT(betline) ((void*) ((char*)betline + sizeof(BETLINE) + betline->bitmapLen))
#define GL_BETPART_A(betline) ((GL_BETPART*)(betline->bitmap))
#define GL_BETPART_B(betline) ((GL_BETPART*)(betline->bitmap + ((GL_BETPART*)betline->bitmap)->size + 2))
#define GL_BETTYPE_A(betline) (betline->bettype & 0x0f)
#define GL_BETTYPE_B(betline) ((betline->bettype & 0xf0) >> 4)

typedef struct _GL_BETPART
{
    uint8 mode;         //bitmapģʽenum MODE
    uint8 size;         //bitmapʹ�õĳ���
    uint8 bitmap[64];   //��Ų�������bitmap
} GL_BETPART;





/*==============================================================================
 * �������壬����������ĳ�������˵��
 * Constant / Define Declarations
 =============================================================================*/

const uint8 MAX_C = 21;
const uint8 MAX_P = 11;
// �������
const uint32 CacheC[][MAX_C] =
{
{ 0 },
{ 1, 1 },
{ 1, 2, 1 },
{ 1, 3, 3, 1 },
{ 1, 4, 6, 4, 1 },
{ 1, 5, 10, 10, 5, 1 },
{ 1, 6, 15, 20, 15, 6, 1 },
{ 1, 7, 21, 35, 35, 21, 7, 1 },
{ 1, 8, 28, 56, 70, 56, 28, 8, 1 },
{ 1, 9, 36, 84, 126, 126, 84, 36, 9, 1 },
{ 1, 10, 45, 120, 210, 252, 210, 120, 45, 10, 1 },
{ 1, 11, 55, 165, 330, 462, 462, 330, 165, 55, 11, 1 },
{ 1, 12, 66, 220, 495, 792, 924, 792, 495, 220, 66, 12, 1 },
{ 1, 13, 78, 286, 715, 1287, 1716, 1716, 1287, 715, 286, 78, 13, 1 },
{ 1, 14, 91, 364, 1001, 2002, 3003, 3432, 3003, 2002, 1001, 364, 91, 14, 1 },
{ 1, 15, 105, 455, 1365, 3003, 5005, 6435, 6435, 5005, 3003, 1365, 455, 105, 15, 1 },
{ 1, 16, 120, 560, 1820, 4368, 8008, 11440, 12870, 11440, 8008, 4368, 1820, 560, 120, 16, 1 },
{ 1, 17, 136, 680, 2380, 6188, 12376, 19448, 24310, 24310, 19448, 12376, 6188, 2380, 680, 136, 17, 1 },
{ 1, 18, 153, 816, 3060, 8568, 18564, 31824, 43758, 48620, 43758, 31824, 18564, 8568, 3060, 816, 153, 18, 1 },
{ 1, 19, 171, 969, 3876, 11628, 27132, 50388, 75582, 92378, 92378, 75582, 50388, 27132, 11628, 3876, 969, 171, 19, 1 },
{
        1,
        20,
        190,
        1140,
        4845,
        15504,
        38760,
        77520,
        125970,
        167960,
        184756,
        167960,
        125970,
        77520,
        38760,
        15504,
        4845,
        1140,
        190,
        20,
        1 } };

// ��������
const uint32 CacheP[][MAX_P] =
{
{ 0 },
{ 0, 1 },
{ 0, 2, 2 },
{ 0, 3, 6, 6 },
{ 0, 4, 12, 24, 24 },
{ 0, 5, 20, 60, 120, 120 },
{ 0, 6, 30, 120, 360, 720, 720 },
{ 0, 7, 42, 210, 840, 2520, 5040, 5040 },
{ 0, 8, 56, 336, 1680, 6720, 20160, 40320, 40320 },
{ 0, 9, 72, 504, 3024, 15120, 60480, 181440, 362880, 362880 },
{ 0, 10, 90, 720, 5040, 30240, 151200, 604800, 1814400, 3628800, 3628800 } };





#pragma pack()

int num2bit(
        const uint8 num[],
        uint8 len,
        uint8 bit[],
        uint8 bitOff,
        uint8 base);

int bit2num(
        const uint8 bit[],
        uint8 len,
        uint8 num[],
        uint8 base);

int bitCount(
        const uint8* arr,
        uint8 off,
        uint8 len);

int bitAnd(
        const uint8* arr1,
        uint8 arr1Off,
        const uint8* arr2,
        uint8 arr2Off,
        uint8 len,
        uint8* ret);

int bitHL2num(
        const uint8 *arr,
        uint8 off,
        uint8 len,
        int flagHL,//0:���λ 1�����λ
        int base);//ssq:1  3D:0....

uint32 drawnumDistribute(
        const uint8 xcode[],
        uint8 len);

uint32 mathpow(
        int base,
        int expr);

uint32 mathc(
        int8 base,
        int8 expr);

uint32 mathp(
        int8 base,
        int8 expr);

int bettype2num(
        uint8 bettype,
        uint8 num[]);

int num2bettype(
        const uint8 num[],
        uint8 *bettype);

int gl_verifyLineParam(
        uint8 gameidx,
        uint16 times);

int gl_bettypeVerify(
        uint32 bettype,
        const BETLINE *betline);

uint8 bitToUint8(
        const uint8* bitArr,
        uint8 * const numArr,
        const uint8 bitSize,
        const uint8 bitBase);

uint16 gl_sortArray(const uint8 array[],int count);

void permutation(uint8 arr[], int begin, int end, uint8 post[][5], int *idx);

int combintion(int n, int k, uint8 post[][4]);


//dump issue state ------------------------------
const char *ISSUE_STATE_STR(uint32 type);
const char *ISSUE_STATE_STR_S(uint32 type);
const char *ISSUE_STATE_STR_S_FBS(uint32 type);

//dump fbs match state ------------------------------
const char *MATCH_STATE_STR(uint32 type);


#endif //GL_PLUGIN_INF_H_INCLUDED
