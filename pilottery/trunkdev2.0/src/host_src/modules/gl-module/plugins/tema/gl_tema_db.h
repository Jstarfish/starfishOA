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

//不能从0计数
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

//玩法规则参数
typedef struct _SUBTYPE_PARAM
{
    bool used; //是否被使用
    uint8 subtypeCode;
    char subtypeAbbr[10]; //游戏玩法标识
    char subtypeName[ENTRY_NAME_LEN];
    uint32 bettype; //支持的投注方式,按位显示,与投注方式表下标对应
    uint8 A_selectBegin; //号码集合(A区)   起始号码
    uint8 A_selectEnd; //号码集合(A区)   结束号码
    uint8 A_selectCount; //选号个数(A区)
    uint8 A_selectMaxCount; //复式最大选号个数(A区)
    uint16 singleAmount;//玩法下的单注金额(分)
} SUBTYPE_PARAM;

//匹配规则参数
typedef struct _DIVISION_PARAM
{
    bool used; //是否被使用
    uint8 divisionCode;
    char divisionName[ENTRY_NAME_LEN];
    uint8 prizeCode;  //奖级编号
    uint8 subtypeCode; //玩法编号
    uint8 A_baseBegin; //基本起始(A区)
    uint8 A_baseEnd; //基本结束(A区)
    uint8 A_matchCount; //匹对个数(A区)
} DIVISION_PARAM;


#define TEMA_MAX_ISSUE_COUNT  32

typedef struct _TEMA_DATABASE
{
	ISSUE_INFO issueTable[TEMA_MAX_ISSUE_COUNT];
	uint8 subtypeCnt;//玩法个数
	uint8 divisionCnt;//匹配个数
	uint8 prizeCnt;//奖级个数
	SUBTYPE_PARAM subtypeTable[MAX_SUBTYPE_COUNT]; //玩法规则参数表
    DIVISION_PARAM divisionTable[MAX_DIVISION_COUNT]; //匹配规则参数表
    PRIZE_PARAM prizeTable[MAX_PRIZE_COUNT]; //奖级参数表
    POOL_PARAM poolParam; //游戏奖池参数表
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

//ccheckpoint 数据保存 和 数据恢复
bool gl_tema_chkp_saveData(const char *filePath);
bool gl_tema_chkp_restoreData(const char *filePath);

int gl_tema_format_ticket(char* buf, uint32 length, int mode, BETLINE* betline);

PRIZE_PARAM * gl_tema_getPrizeTableBegin(void);
ISSUE_INFO* gl_tema_get_issueInfoByIndex(int idx);
void *gl_tema_get_rkIssueDataTable(void);


#endif /* GL_TEMA_DB_H_ */
