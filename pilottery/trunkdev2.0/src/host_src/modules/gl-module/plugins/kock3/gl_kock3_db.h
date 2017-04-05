#ifndef GL_KOCK3_DB_H__
#define GL_KOCK3_DB_H__




/*=========================================================================================================
 * �����Ժ궨�壬��������м�Ҫ˵��
 * Functional Macro Definitions and Brief Description
 =========================================================================================================*/
#include "gl_plugins_inf.h"

typedef struct _TABLE_KOCK3
{
    uint8  hz2zx[19];
    uint8  hz3zx[28];
    uint8  hzz3[28];
    uint8  hzz6[28];

} TABLE_KOCK3;

#pragma pack(1)

typedef enum _SUBTYPE
{
    SUBTYPE_ZX = 1,
    SUBTYPE_3TA = 2,
    SUBTYPE_3TS = 3,
    SUBTYPE_3QA = 4,
    SUBTYPE_3DS = 5,
    SUBTYPE_2TA = 6,
    SUBTYPE_2TS = 7,
    SUBTYPE_2DS = 8
}SUBTYPE;

//���ܴ�0����
typedef enum _PRIZE
{
    PRIZE_3TS = 1,          //��ͬ�ŵ�ѡ ����: 240

    PRIZE_ZX_HZ_3_18 = 2,   //ֱѡ��ֵ 3 �� 18 ����: 240

    PRIZE_2TS = 3,          //��ͬ�ŵ�ѡ ����: 80

    PRIZE_ZX_HZ_4_17 = 4,   //ֱѡ��ֵ 4 �� 17 ����: 80

    PRIZE_3TA = 5,          //��ͬ��ͨѡ ����: 40

    PRIZE_ZX_HZ_5_16 = 6,   //ֱѡ��ֵ 5 �� 16 ����: 40

    PRIZE_3DS = 7,          //����ͬ��ѡ ����: 40

    PRIZE_ZX_HZ_6_15 = 8,   //ֱѡ��ֵ 6 �� 15 ����: 25

    PRIZE_ZX_HZ_7_14 = 9,   //ֱѡ��ֵ 7 �� 14 ����: 16

    PRIZE_2TA = 10,         //��ͬ�Ÿ�ѡ ����: 15

    PRIZE_ZX_HZ_8_13 = 11,  //ֱѡ��ֵ 8 �� 13 ����: 12

    PRIZE_3QA = 12,         //������ͨѡ ����: 10

    PRIZE_ZX_HZ_9_12 = 13,  //ֱѡ��ֵ 9 �� 12 ����: 10

    PRIZE_ZX_HZ_10_11 = 14, //ֱѡ��ֵ 10 �� 11 ����: 9

    PRIZE_2DS = 15,         //����ͬ��ѡ ����: 8

}PRIZE;

typedef struct _GL_KOCK3_DRAWNUM
{
    uint8  zx4_map[4*2];
	uint16 winNum;
	uint8  hz;
	bool threeSame;
	bool threeDiff;
	bool threeOrder;
	bool twoDiff;

	bool twoSame;
	uint8 twoSameNum;

	uint8 twoDiffCount;
	uint8 twoDiffArray[3];

} GL_KOCK3_DRAWNUM;

//�淨�������
typedef struct _SUBTYPE_PARAM
{
    bool used; //�Ƿ�ʹ��
    uint8 subtypeCode;
    char subtypeAbbr[10]; //��Ϸ�淨��ʶ
    char subtypeName[ENTRY_NAME_LEN];
    uint32 bettype; //֧�ֵ�Ͷע��ʽ,��λ��ʾ,��Ͷע��ʽ���±��Ӧ
    uint8 status; //1 ENABLED / 2 DISABLED  ���������ۿ���
    uint8 A_selectBegin; //���뼯��(A��)   ��ʼ����
    uint8 A_selectEnd; //���뼯��(A��)   ��������
    uint16 singleAmount;//�淨�µĵ�ע���(��)
} SUBTYPE_PARAM;

//ƥ��������
typedef struct _DIVISION_PARAM
{
    bool used; //�Ƿ�ʹ��
    uint8  divisionCode;
    char divisionName[ENTRY_NAME_LEN];
    uint8  prizeCode;  //�������
    uint8  subtypeCode; //�淨���
    uint8  distribute; //����ֲ�
    uint8  absDiff;    //abs(21-2x),x-->hz

} DIVISION_PARAM;


//�㽱���ò���
typedef struct _KOCK3_CALC_PRIZE_PARAM
{
    uint8  specWinFlag;
}KOCK3_CALC_PRIZE_PARAM;

typedef struct _KOCK3_DATABASE
{
    ISSUE_INFO issueTable[1234];//��ʱ����ʹ�� caoxf__
    uint8 subtypeCnt;//�淨����
    uint8 divisionCnt;//ƥ�����
    uint8 prizeCnt;//��������
    SUBTYPE_PARAM subtypeTable[MAX_SUBTYPE_COUNT]; //�淨���������
    DIVISION_PARAM divisionTable[MAX_DIVISION_COUNT]; //ƥ����������
    PRIZE_PARAM prizeTable[MAX_PRIZE_COUNT]; //����������
    POOL_PARAM poolParam; //��Ϸ���ز�����
}KOCK3_DATABASE;

typedef KOCK3_DATABASE* KOCK3_DATABASE_PTR;

#pragma pack()

extern TABLE_KOCK3 table_kock3;

bool gl_kock3_mem_creat(int issue_count);
bool gl_kock3_mem_destroy(void);
bool gl_kock3_mem_attach(void);
bool gl_kock3_mem_detach(void);

void *gl_kock3_get_mem_db(void);
KOCK3_DATABASE_PTR gl_kock3_getDatabasePtr(void);

void *gl_kock3_getSubtypeTable(int *len);
SUBTYPE_PARAM *gl_kock3_getSubtypeParam(uint8 subtypeCode);
void *gl_kock3_getDivisionTable(int *len,uint64 issueNumber);
DIVISION_PARAM *gl_kock3_getDivisionParam(uint8 divisionCode);
PRIZE_PARAM * gl_kock3_getPrizeTable(uint64 issue);

POOL_PARAM *gl_kock3_getPoolParam(void);
void *gl_kock3_getRkTable(void);

int gl_kock3_getSingleAmount(char *buffer, size_t len);
ISSUE_INFO *gl_kock3_getIssueTable(void);
int get_kock3_issueMaxCount(void);
int get_kock3_issueCount(void);

bool gl_kock3_load_memdata(void);

int gl_kock3_load_newIssueData(void *issueBuf, int32 issueCount);
int gl_kock3_load_oldIssueData(void *issueBuf, int32 issueCount);

ISSUE_INFO* gl_kock3_get_currIssue(void);
ISSUE_INFO* gl_kock3_get_issueInfo(uint64 issueNum);
ISSUE_INFO* gl_kock3_get_issueInfo2(uint32 issueSerial);
bool gl_kock3_del_issue(uint64 issueNum);
bool gl_kock3_clear_oneIssueData(uint64 issueNum);
//int gl_kock3_inquiry_subtypeInfo(GAME_METHOD_INFO *methodInfo);

uint32 gl_kock3_get_issueMaxSeq(void);

//ccheckpoint ���ݱ��� �� ���ݻָ�
bool gl_kock3_chkp_saveData(const char *filePath);
bool gl_kock3_chkp_restoreData(const char *filePath);

bool gl_kock3_loadPrizeTable(uint64 issue,PRIZE_PARAM_ISSUE *prize);
PRIZE_PARAM *gl_kock3_getPrizeTableBegin(void);

ISSUE_INFO* gl_kock3_get_issueInfoByIndex(int idx);
void *gl_kock3_get_rkIssueDataTable(void);

int gl_kock3_format_ticket(char* buf, uint32 length, int mode, BETLINE* betline);


char *gl_kock3_get_winStr(uint64 issue);

int gl_kock3_gen_fun(int type, char *in, char *out);

#endif




