#ifndef GL_INF_H_INCLUDED
#define GL_INF_H_INCLUDED


//-----------------------------------------------------------------------------------------
//
//   GL database
//
//-----------------------------------------------------------------------------------------

//��Ϸ��Ϣ
typedef struct _GAME_PARAM
{
    uint8 gameCode;     //��Ϸ����
    GAME_TYPE gameType; // ��Ϸ����
    char gameAbbr[15];   //��Ϸ�ַ���д
    char gameName[MAX_GAME_NAME_LENGTH]; //��Ϸ����
    char organizationName[MAX_ORGANIZATION_NAME_LENGTH]; //���е�λ����
} GAME_PARAM;

//���߲���
typedef struct _POLICY_PARAM
{
    uint16 publicFundRate;      //��������
    uint16 adjustmentFundRate;  //���ڽ����
    uint16 returnRate;          //���۷�����
    money_t taxStartAmount;     //��˰������(��λ:��)
    uint16 taxRate;             //��˰ǧ�ֱ�
    uint16 payEndDay;           //�ҽ���(��)
} POLICY_PARAM;

//���׿��Ʋ���
typedef struct _TRANSCTRL_PARAM
{
    DRAW_TYPE drawType; //�ڴο���ģʽ

    bool    saleFlag; //�Ƿ������
    bool    cancelFlag; //�Ƿ����Ʊ
    bool    payFlag; //�Ƿ�ɶҽ�

    bool    riskCtrl; //�Ƿ����÷��տ���
    char    riskCtrlParam[512]; //��Ϸ���տ��Ʋ���(�ַ���)

    // common control parameter ---------------------------------------------------
    uint8   autoDraw; //�Ƿ��Զ�����  enable:1   disable:2
    uint32  cancelTime; //������Ʊʱ��   ��λ: ��
    uint32  countDownTimes; //���ۼ����ر�����ʱ��

    uint16  maxTimesPerBetLine; //���������
    uint8   maxBetLinePerTicket; //��Ʊ�������  //���FBS��Ϸ���˲�������һ��Ʊ����ѡ��ı�����������
    uint16  maxIssueCount; //��������ڴ�
    money_t maxAmountPerTicket; //��Ʊ����1-50��

    money_t gamePayLimited; //��Ϸ�ҽ������޶��λ�֣��� ϵͳ������ֵ�����еĶҽ���Ϊ���ܴ˲������ƣ�
    money_t bigPrize; //�ж��Ƿ��Ǵ� ��С�ڳ����޶(ȷ���Ƿ��Ǵ�)(��Ʊ)


    money_t saleLimit; //��Ʊ���۽��澯��ֵ
    money_t payLimit; //��Ʊ�ҽ����澯��ֵ
    money_t cancelLimit; //��Ʊ��Ʊ���澯��ֵ


    //��Ϸÿ�շ���ʱ���һ
    uint32  service_time_1_b;
    uint32  service_time_1_e;
    //��Ϸÿ�շ���ʱ��ζ�
    uint32  service_time_2_b;
    uint32  service_time_2_e;

    //������(ʡ��)�޶�  ------------------------------------------------------
    money_t branchCenterPayLimited;    //������(ʡ��)�ҽ��޶�
    money_t branchCenterCancelLimited; //������(ʡ��)��Ʊ�޶�
    //terminal control parameter  ------------------------------------------------
    money_t commonTellerPayLimited;    //��ͨ��������Ա�ҽ��޶�趨��ͨ����Ա�Ŀɶҽ����ޣ���ͨ����Ա�ҽ�ʱ����֤���޶
    money_t commonTellerCancelLimited; //��ͨ��������Ա��Ʊ�޶�趨��ͨ����Ա�Ŀ���Ʊ���ޣ���ͨ����Ա��Ʊʱ����֤���޶
} TRANSCTRL_PARAM;

//��Ϸ���׵���ͳ������
typedef struct _GAME_DAY_STAT
{
    uint32  saleCount; //����Ʊ��
    money_t saleAmount; //���۽��
    uint32  payCount; //�ҽ�Ʊ��
    money_t payAmount; //�ҽ����
    uint32  cancelCount; //����Ʊ��
    money_t cancelAmount; //�������
} GAME_DAY_STAT;

//��Ϸ�����
typedef struct _GAME_DATA
{
    bool used; //�Ƿ�ʹ��
    GAME_PARAM gameEntry; //��Ʊ��Ϸ��
    POLICY_PARAM policyParam; //���߲���
    TRANSCTRL_PARAM transctrlParam; //���ۿ��Ʋ���

    GAME_DAY_STAT gameDayStat;//������Ϸͳ������
} GAME_DATA;

//RNG�����ڴ����
typedef struct _RNG_PARAM
{
    bool    used;
    uint32  rngId;
    char    rngName[ENTRY_NAME_LEN];
    uint8   status;     // RNG����״̬ enum STATUS_TYPE (Ŀǰ��ԶΪENABLED)
    uint8   workStatus; // RNG����״̬ enum RNG_STATUS
    uint8   rngMac[6];  // ��ǰrng client��mac��ַ
    char    rngIp[16];  // ��ǰrng client��ip��ַ
    uint8   gameCode;   // ��RNG����֧�ֵ���Ϸ(0����֧��������Ϸ)
} RNG_PARAM;

//-----------------------------------------------------------------------------------------

#define SALE_BUCKET_NUM       (32767) //0x7FFF
#define SALE_BUCKET_SIZE      (16)
#define SALE_OVERFLOW_SIZE    (4096*16)

#define PAY_BUCKET_NUM        (32767) //0x7FFF
#define PAY_BUCKET_SIZE       (16)
#define PAY_OVERFLOW_SIZE     (4096*16)

#define CANCEL_BUCKET_NUM     (8191) //0x1FFF
#define CANCEL_BUCKET_SIZE    (16)
#define CANCEL_OVERFLOW_SIZE  (256*16)

/*
#define ISSUE_BUCKET_NUM     (131071) //0x0001FFFF
#define ISSUE_BUCKET_SIZE    (16)
#define ISSUE_OVERFLOW_SIZE  (4096*16)
*/

// �ҽ�/��Ʊ Ʊ���ڴ�����
typedef struct _SHM_TSN_STRUCT {
    uint8  used;
    char   tsn[TSN_LENGTH];
} SHM_TSN_STRUCT;


//�ڴ�GL���ݿ� ----------------------------------------------------------------------------
typedef struct _GL_DATABASE
{
    GAME_DATA gameTable[MAX_GAME_NUMBER]; //��Ϸ���ݱ�
    RNG_PARAM rngTable[MAX_RNG_NUMBER]; //RNG����

    //��ֽ������������ˮ��ʹ�õ�Request Number cache�ڴ�
    SHM_TSN_STRUCT sale_buckets[SALE_BUCKET_NUM][SALE_BUCKET_SIZE];
    SHM_TSN_STRUCT sale_overflow[SALE_OVERFLOW_SIZE];
    pthread_mutex_t sale_lock;

    //�ҽ�ʹ�õ�TSN cache�ڴ�
    SHM_TSN_STRUCT pay_buckets[PAY_BUCKET_NUM][PAY_BUCKET_SIZE];
    SHM_TSN_STRUCT pay_overflow[PAY_OVERFLOW_SIZE];
    pthread_mutex_t pay_lock;

    //��Ʊʹ�õ�TSN cache�ڴ�
    SHM_TSN_STRUCT cancel_buckets[CANCEL_BUCKET_NUM][CANCEL_BUCKET_SIZE];
    SHM_TSN_STRUCT cancel_overflow[CANCEL_OVERFLOW_SIZE];
    pthread_mutex_t cancel_lock;

} GL_DATABASE;

typedef GL_DATABASE* GL_DATABASE_PTR;




//----------------------------------------------------------------------------------------
//
//    GL database ��� INTERFACE
//
//----------------------------------------------------------------------------------------


//���������ڴ�
bool gl_create();

//ɾ�������ڴ�
bool gl_destroy();

//ӳ�乲���ڴ���
bool gl_init();

//�رչ����ڴ�����ӳ��
bool gl_close();

GL_DATABASE_PTR gl_getDataBasePtr(void);



//��Ϸ�Ƿ����
bool isGameBeUsed(uint8 gameCode);

//��ȡָ��gameCode����Ϸ����
GAME_DATA* gl_getGameData(uint8 gameCode);

//��ȡָ��gameCode����Ϸ��������
GAME_PARAM* gl_getGameParam(uint8 gameCode);

//��ȡָ��gameCode�����߲���
POLICY_PARAM* gl_getPolicyParam(uint8 gameCode);

//��ȡָ��gameCode�Ľ��׿��Ʋ���
TRANSCTRL_PARAM * gl_getTransctrlParam(uint8 gameCode);

//��ȡRNG����
RNG_PARAM* gl_getRngData();



//��֤��ǰʱ���Ƿ�����Ϸ�ķ���ʱ�η�Χ��
bool gl_verifyServiceTime(uint8 gameCode);

//��ȡָ��gameCode����Ϸ����ͳ������
GAME_DAY_STAT * gl_getGameDayStat(uint8 gameCode);

//�ս�ʱ�����Ϸ����ͳ������
void gl_cleanGameDayStatistics();


//�Ƿ����÷��տ���
bool isGameBeRiskControl(uint8 gameCode);


//������Ϸ���ۡ��ҽ���ȡ��   flag (1:sale 2:pay 3:cancel)  status(0: false 1:true)
int gl_setGameCtrl(uint8 gameCode, uint8 flag, uint8 status);

//������Ϸ������Ʊʱ��
int gl_setCancelTime(uint8 gameCode,uint32 cancelTime);

//������Ϸ�Զ��������(��Ե��ӿ�����Ϸ��Ч)
int gl_setAutoDrawStatus(uint8 gameCode, uint8 status);

//�����Ϸ����RNG
int gl_setGameParamRng(RNG_PARAM *rngParam);

//����RNG����״̬
int gl_setRngWorkStatus(uint32 rngId, int workStatus);


//checkpoint ���ݱ��漰�ָ�
int32 gl_chkp_save(char *chkp_path);
int32 gl_chkp_restore(char *chkp_path);





//----------------------------------------------------------------------------------------
//
//    GL COMMON STRUCTURE DEFINE
//
//----------------------------------------------------------------------------------------
#include "gl_type_def.h"



//----------------------------------------------------------------------------------------
//
//    GIDB FBS INTERFACE
//
//----------------------------------------------------------------------------------------
#include "gl_fbs_inf.h"



//----------------------------------------------------------------------------------------
//
//    Game Plugins INTERFACE
//
//----------------------------------------------------------------------------------------
#include "gl_plugins_inf.h"



//----------------------------------------------------------------------------------------
//
//    GIDB INTERFACE
//
//----------------------------------------------------------------------------------------
#include "gidb_mod.h"



//-------------------------------------------------------------------------------------------------------
//
//    DRAW GFP INTERFACE
//
//-------------------------------------------------------------------------------------------------------
#include "gfp_mod.h"



//----------------------------------------------------------------------------------------
//
//    FBS GIDB INTERFACE
//
//----------------------------------------------------------------------------------------
#include "gidb_fbs_mod.h"




//----------------------------------------------------------------------------------------
//
//    TSN ��� INTERFACE
//
//----------------------------------------------------------------------------------------

//offset_days -> (�뿪ʼ���1��1�յ�����)  return ������( 20150921 )
int c_date(int offset_days);
//date -> 20150921 , return 1234 (�뿪ʼ���1��1�յ�����)
int c_days(int date);

//���� DIGIT TSN (�ڲ�ʹ�õ�����TSN)
uint64 generate_digit_tsn(uint32 date, uint16 fileIdx, uint32 fileOffset);
//���� DIGIT TSN (�ڲ�ʹ�õ�����TSN)
int extract_digit_tsn(uint64 unique_tsn, uint32 *date, uint16 *fileIdx, uint32 *fileOffset);
//ʹ�� �ڲ���digit_tsn ���������ⲿ�� �ַ���Ʊ��
int generate_tsn(uint64 unique_tsn, char *tsn_str);
//ʹ�� �ⲿ�� �ַ���Ʊ�� ���� �ڲ���digit_tsn
uint64 extract_tsn(char *tsn_str, uint32 *date);


#define SUPPORT_OLD_TSN
#ifdef SUPPORT_OLD_TSN
uint64 extract_old_tsn(char *tsn_str, uint32 *date);
#endif








//-------------------------------------------------------------------------------------------------------
//
//spccial  interface
//
//-------------------------------------------------------------------------------------------------------


typedef list<GAME_DATA *> GAME_LIST;
typedef struct _ISSUE_CFG_DATA
{
    uint8 gameCode;                                 // ��Ϸ����
    uint64 issueNumber;
    uint32 serialNumber;                            // �ڴ����, ��Ч��Χ[0-1048575] uint16+uint8 = 20bit
    uint8 curState;
    uint8 localState;
    time_type startTime;
    time_type closeTime;
    time_type drawTime;
    uint64 payEndDay;                               // �ҽ���ֹ����
    char  winConfigStr[MAX_GAME_RESULTS_STR_LEN];  //�㽱���ò����ַ���
} ISSUE_CFG_DATA;
typedef list<ISSUE_CFG_DATA *> ISSUE_NEWCFG_LIST;
typedef list<ISSUE_INFO *> ISSUE_OLDCFG_LIST;

typedef list<RNG_PARAM *> RNG_LIST;


typedef struct _AREA_GAME_INFO
{
    uint8   gameCode;
    uint8   status;

    int16   CommissionRate; // ������/Ӷ�� ����

    uint8   sellStatus;
    uint8   payStatus;
    uint8   cancelStatus;
}AREA_GAME_INFO;

typedef struct _TMS_AREA_CFG_DATA
{
    uint8   areaType; // 1: province
    uint32  areaCode;
    uint8   status;

    char    areaName[64];

    uint32  parentCode; //���������ݱ���

    uint8   gameCount;
    AREA_GAME_INFO gameArray[MAX_GAME_NUMBER];
} TMS_AREA_CFG_DATA;
typedef list<TMS_AREA_CFG_DATA *> TMS_AREA_CFG_LIST;


typedef struct _AGENCY_GAME_INFO
{
    uint8   gameCode;               //��Ϸ����
    uint8   status;                 //��Ϸ����״̬   enum STATUS_TYPE

    int16   saleCommissionRate;     //����վ���۴����ѱ���
    int16   payCommissionRate;      //����վ�ҽ������ѱ���

    uint8   claimingScope;          //�ҽ���Χ, enum AREA_LEVEL
    uint8   sellStatus;             //�Ƿ������
    uint8   payStatus;              //�Ƿ�ɶҽ�
    uint8   cancelStatus;           //�Ƿ��ȡ��
}AGENCY_GAME_INFO;

typedef struct _TMS_AGENCY_CFG_DATA
{
    uint64  agencyCode;
    uint8   status;

    uint32  areaCode;
    uint16  areaType;

    uint8   agencyType;

    time_type business_begin_time;
    time_type business_end_time;

    money_t availableCredit;                  //�˻����

    money_t marginalCreditLimit;
    money_t tempMarginalCreditLimit;

    char   agencyName[ENTRY_NAME_LEN];                          //����վ����
    char   contactAddress[AGENCY_ADDRESS_LENGTH];               //��ϵ�˵�ַ
    char   contactPhone[20];                                    //��ϵ�˵绰

    uint8   gameCount;
    AGENCY_GAME_INFO gameArray[MAX_GAME_NUMBER];
} TMS_AGENCY_CFG_DATA;
typedef list<TMS_AGENCY_CFG_DATA *> TMS_AGENCY_CFG_LIST;


typedef struct _TMS_TERMINAL_CFG_DATA
{
    uint64 termCode;
    uint8  status;

    uint8  szTermMac[6];
    char   unique_code[32];
    uint8  isTrain;
    uint16 machineModel;

    uint64 agencyCode;

    uint64 flowNumber;
} TMS_TERMINAL_CFG_DATA;
typedef list<TMS_TERMINAL_CFG_DATA *> TMS_TERMINAL_CFG_LIST;


typedef struct _TMS_TELLER_CFG_DATA
{
    uint32 tellerCode;
    uint8  status;

    uint64 agencyCode;

    uint8  tellerType;
    uint32 password;
} TMS_TELLER_CFG_DATA;
typedef list<TMS_TELLER_CFG_DATA *> TMS_TELLER_CFG_LIST;

typedef struct _TMS_VERSION_CFG_DATA
{
    uint8  machineType;             //���û���
    char   szVersionNo[16];         //�汾���ַ���
    uint8  status;                  //�Ƿ����
} TMS_VERSION_CFG_DATA;
typedef list<TMS_VERSION_CFG_DATA *> TMS_VERSION_CFG_LIST;


//-------------------------------------------------------------------------------------------------------
//
// gl  tool
//
//-------------------------------------------------------------------------------------------------------

//ȥ���ַ���ͷβ���Ŀո��ַ�
char *strtrim(char *string);

void ts_regex_init(void);
void ts_regex_release(void);
bool ts_regex_ticket_match(const char *str);
bool ts_regex_bettype_match(uint8 bet, const char *str);


#endif


