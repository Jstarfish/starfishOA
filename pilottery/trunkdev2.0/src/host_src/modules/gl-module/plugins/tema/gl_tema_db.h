/*
 * gl_tema_db.h
 *
 *  Created on: 2011-6-30
 *      Author: Administrator
 */

#ifndef GL_TEMA_DB_H_
#define GL_TEMA_DB_H_

#include "gl_plugins_inf.h"

enum _SUBTYPE
{
	SUBTYPE_DG = 1,
	SUBTYPE_WH
};

//���ܴ�0����
enum _PRIZE
{
	PRIZE_1 = 1,
	PRIZE_2
};

#pragma pack(1)

typedef struct _GL_TEMA_DRAWNUM
{
	uint8  dgmap[8];
	uint8  whmap;
} GL_TEMA_DRAWNUM;

typedef struct _GL_TEMA_MATCHNUM
{
    uint8 ACnt;
} GL_TEMA_MATCHNUM;

//�淨�������
typedef struct _SUBTYPE_PARAM
{
    bool used; //�Ƿ�ʹ��
    uint8 subtypeCode;
    char subtypeAbbr[10]; //��Ϸ�淨��ʶ
    char subtypeName[ENTRY_NAME_LEN];
    uint32 bettype; //֧�ֵ�Ͷע��ʽ,��λ��ʾ,��Ͷע��ʽ���±��Ӧ
    uint8 A_selectBegin; //���뼯��(A��)   ��ʼ����
    uint8 A_selectEnd; //���뼯��(A��)   ��������
    uint8 A_selectCount; //ѡ�Ÿ���(A��)
    uint8 A_selectMaxCount; //��ʽ���ѡ�Ÿ���(A��)
    uint16 singleAmount;//�淨�µĵ�ע���(��)
} SUBTYPE_PARAM;

//ƥ��������
typedef struct _DIVISION_PARAM
{
    bool used; //�Ƿ�ʹ��
    uint8 divisionCode;
    char divisionName[ENTRY_NAME_LEN];
    uint8 prizeCode;  //�������
    uint8 subtypeCode; //�淨���
    uint8 A_baseBegin; //������ʼ(A��)
    uint8 A_baseEnd; //��������(A��)
    uint8 A_matchCount; //ƥ�Ը���(A��)
} DIVISION_PARAM;


#define TEMA_MAX_ISSUE_COUNT  32

typedef struct _TEMA_DATABASE
{
	ISSUE_INFO issueTable[TEMA_MAX_ISSUE_COUNT];
	uint8 subtypeCnt;//�淨����
	uint8 divisionCnt;//ƥ�����
	uint8 prizeCnt;//��������
	SUBTYPE_PARAM subtypeTable[MAX_SUBTYPE_COUNT]; //�淨���������
    DIVISION_PARAM divisionTable[MAX_DIVISION_COUNT]; //ƥ����������
    PRIZE_PARAM prizeTable[MAX_PRIZE_COUNT]; //����������
    POOL_PARAM poolParam; //��Ϸ���ز�����
}TEMA_DATABASE;

#pragma pack(0)

typedef TEMA_DATABASE* TEMA_DATABASE_PTR;


bool gl_tema_mem_creat(int issue_count);
bool gl_tema_mem_destroy(void);
bool gl_tema_mem_attach(void);
bool gl_tema_mem_detach(void);

void *gl_tema_get_mem_db(void);

bool gl_tema_load_memdata(void);

void * gl_tema_getSubtypeTable(int *len);
SUBTYPE_PARAM * gl_tema_getSubtypeParam(uint8 subtypeCode);
void *gl_tema_getDivisionTable(int *len,uint64 issueNumber);
DIVISION_PARAM *gl_tema_getDivisionParam(uint8 divCode);
PRIZE_PARAM *gl_tema_getPrizeTable(uint64 issue);

POOL_PARAM* gl_tema_getPoolParam(void);

void *gl_tema_getRkTable(void);

int gl_tema_getSingleAmount(char *buffer, size_t len);

ISSUE_INFO *gl_tema_getIssueTable(void);
int get_tema_issueMaxCount(void);
int get_tema_issueCount(void);

int gl_tema_load_newIssueData(void *issueBuf, int32 issueCount);
int gl_tema_load_oldIssueData(void *issueBuf, int32 issueCount);

bool gl_tema_loadPrizeTable(uint64 issue,PRIZE_PARAM_ISSUE *prize);

ISSUE_INFO* gl_tema_get_currIssue(void);
ISSUE_INFO* gl_tema_get_issueInfo(uint64 issueNum);
ISSUE_INFO* gl_tema_get_issueInfo2(uint32 issueSerial);
bool gl_tema_del_issue(uint64 issueNum);
bool gl_tema_clear_oneIssueData(uint64 issueNum);
//int gl_tema_inquiry_subtypeInfo(GAME_METHOD_INFO *buf);

uint32 gl_tema_get_issueMaxSeq(void);

//ccheckpoint ���ݱ��� �� ���ݻָ�
bool gl_tema_chkp_saveData(const char *filePath);
bool gl_tema_chkp_restoreData(const char *filePath);

int gl_tema_format_ticket(char* buf, uint32 length, int mode, BETLINE* betline);

PRIZE_PARAM * gl_tema_getPrizeTableBegin(void);
ISSUE_INFO* gl_tema_get_issueInfoByIndex(int idx);
void *gl_tema_get_rkIssueDataTable(void);


#endif /* GL_TEMA_DB_H_ */