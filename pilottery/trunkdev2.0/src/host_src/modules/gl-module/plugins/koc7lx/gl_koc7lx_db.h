#ifndef GL_KOC7LX_DB_H_
#define GL_KOC7LX_DB_H_

#include "gl_plugins_inf.h"

//Ͷע��ʽ
typedef enum _SUBTYPE
{
    SUBTYPE_ZX     = 1, //ֱѡ
    //SUBTYPE_ZXHALF = 2, //ֱѡ����֮һ
} SUBTYPE;

//���� ���ܴ�0����
typedef enum _PRIZE
{
    PRIZE_1  = 1,  //һ�Ƚ�
    PRIZE_2  = 2,  //���Ƚ�
    PRIZE_3  = 3,  //���Ƚ�
    PRIZE_4  = 4,  //�ĵȽ�
    PRIZE_5  = 5,  //��Ƚ�
    PRIZE_6  = 6,  //���Ƚ�
    PRIZE_7  = 7,  //�ߵȽ�
    PRIZE_1H = 8,  //һ�Ƚ�(����֮һ)
//    PRIZE_2H = 9,  //���Ƚ�(����֮һ)
//    PRIZE_3H = 10, //���Ƚ�(����֮һ)
//    PRIZE_4H = 11, //�ĵȽ�(����֮һ)
//    PRIZE_5H = 12, //��Ƚ�(����֮һ)
//    PRIZE_6H = 13, //���Ƚ�(����֮һ)
//    PRIZE_7H = 14, //�ߵȽ�(����֮һ)
} PRIZE;

#pragma pack(1)

//������Ͷע����bitmap��ʽ
typedef struct _GL_KOC7LX_DRAWNUM
{
    uint8 drawA[5];      //���������bitmap(�������ر���룬�ܹ�6��bit)
    uint8 specialNumber; //�ر������ֵ
} GL_KOC7LX_DRAWNUM;

//����ʵ��ѡ��������
typedef struct _GL_KOC7LX_SELECTNUM
{
    uint8 ACnt;
    uint8 ATCnt;
} GL_KOC7LX_SELECTNUM;

//����ƥ��ʱ���еĺ������
typedef struct _GL_KOC7LX_MATCHNUM
{
    uint8 ACnt;            //A��ƥ��������(�������ر����)
    uint8 ATCnt;           //A����ƥ��������(�������ر����)
    uint8 specialMatched;  //�ر����ƥ��(0δƥ��1ƥ��)
    uint8 specialTMatched; //�ر����������ƥ��(0δƥ��1ƥ��)
} GL_KOC7LX_MATCHNUM;

//�淨�������
typedef struct _SUBTYPE_PARAM
{
    bool   used; //�Ƿ�ʹ��
    uint8  subtypeCode; //��Ϸ�淨���
    char   subtypeAbbr[10]; //��Ϸ�淨��ʶ
    char   subtypeName[ENTRY_NAME_LEN]; //��Ϸ�淨����
    uint32 bettype; //֧�ֵ�Ͷע��ʽ,��λ��ʾ,��Ͷע��ʽ���±��Ӧ
    uint8  status; //1 ENABLED / 2 DISABLED  ���������ۿ���
    uint8  A_selectBegin; //���뼯��(A��)   ��ʼ����
    uint8  A_selectEnd; //���뼯��(A��)   ��������
    uint8  A_selectCount; //ѡ�Ÿ���(A��)
    uint8  A_selectMaxCount; //��ʽ���ѡ�Ÿ���(A��)
    uint16 singleAmount; //�淨�µĵ�ע���(���)
} SUBTYPE_PARAM;

//ƥ��������
typedef struct _DIVISION_PARAM
{
    bool  used; //�Ƿ�ʹ��
    uint8 divisionCode;
    char  divisionName[ENTRY_NAME_LEN];
    uint8 prizeCode;  //���ȱ�� enum PRIZE
    uint8 subtypeCode; //�淨���
    uint8 A_matchCount; //ƥ�Ը���(A��)
    uint8 specialNumberMatch; //�ر����ƥ��ֵ(0δƥ��1ƥ��)
} DIVISION_PARAM;

//�㽱���ò���
typedef struct _KOC7LX_CALC_PRIZE_PARAM
{
    money_t  firstPrizeLowerBetLimit;
    money_t  firstPrizeUpperBetLimit;
    money_t  minAmount;
}KOC7LX_CALC_PRIZE_PARAM;

#pragma pack()


bool gl_koc7lx_mem_creat(int issue_count);
bool gl_koc7lx_mem_destroy(void);
bool gl_koc7lx_mem_attach(void);
bool gl_koc7lx_mem_detach(void);

void *gl_koc7lx_get_mem_db(void);

PRIZE_PARAM *gl_koc7lx_getPrizeTableBegin(void);
bool gl_koc7lx_load_memdata(void);

ISSUE_INFO *gl_koc7lx_getIssueTable(void);
void *gl_koc7lx_getSubtypeTable(int *len);
SUBTYPE_PARAM *gl_koc7lx_getSubtypeParam(uint8 subtypeCode);
void *gl_koc7lx_getDivisionTable(int *len,uint64 issueNumber);
PRIZE_PARAM *gl_koc7lx_getPrizeTable(uint64 issueNum);

POOL_PARAM *gl_koc7lx_getPoolParam(void);

int gl_koc7lx_getSingleAmount(char *buffer, size_t len);

ISSUE_INFO *gl_koc7lx_get_currIssue(void);
ISSUE_INFO *gl_koc7lx_get_issueInfo(uint64 issueNum);
ISSUE_INFO *gl_koc7lx_get_issueInfo2(uint32 issueSerial);
uint32 gl_koc7lx_get_issueMaxSeq(void);

int gl_koc7lx_format_ticket(char *buf, uint32 length, int mode, BETLINE *betline);

int get_koc7lx_issueMaxCount(void);
int get_koc7lx_issueCount(void);
int gl_koc7lx_load_newIssueData(void *issueBuffer, int32 issueCount);
int gl_koc7lx_load_oldIssueData(void *issueBuffer, int32 issueCount);
bool gl_koc7lx_del_issue(uint64 issueNum);
bool gl_koc7lx_clear_oneIssueData(uint64 issueNum);

bool gl_koc7lx_chkp_saveData(const char *filePath);
bool gl_koc7lx_chkp_restoreData(const char *filePath);

bool gl_koc7lx_loadPrizeTable(uint64 issue, PRIZE_PARAM_ISSUE *prize);

int gl_koc7lx_resolve_winStr(uint64 issue, void *buf);
char *gl_koc7lx_get_winStr(uint64 issue);

#endif /* GL_KOC7LX_DB_H_ */


