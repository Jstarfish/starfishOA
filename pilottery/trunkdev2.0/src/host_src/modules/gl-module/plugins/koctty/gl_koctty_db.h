#ifndef GL_KOCTTY_DB_H__
#define GL_KOCTTY_DB_H__




/*=========================================================================================================
 * 函数性宏定义，并对其进行简要说明
 * Functional Macro Definitions and Brief Description
 =========================================================================================================*/
#include "gl_plugins_inf.h"

typedef struct _TABLE_KOCTTY
{
    uint8  hz2zx[19];
    uint8  hz3zx[28];
    uint8  hzz3[28];
    uint8  hzz6[28];

} TABLE_KOCTTY;

#pragma pack(1)

typedef enum _SUBTYPE
{
    SUBTYPE_QH2 = 1,
    SUBTYPE_QH3 = 2,
    SUBTYPE_4ZX = 3,

    SUBTYPE_Q2 = 4,
    SUBTYPE_H2 = 5,
    SUBTYPE_Q3 = 6,
    SUBTYPE_H3 = 7
}SUBTYPE;

//不能从0计数
typedef enum _PRIZE
{
    PRIZE_4ZX = 1,  //四星直选
    PRIZE_QH3 = 2,  //前后三
    PRIZE_QH2 = 3,  //前后二

    PRIZE_SPE4ZX = 4,  //四星直选特别奖
    PRIZE_SPEQH3 = 5,  //前后三特别奖
    PRIZE_SPEQH2 = 6,  //前后二特别奖

    PRIZE_Q3 = 7,     // 前三
    PRIZE_H3 = 8,     // 后三
    PRIZE_Q2 = 9,     // 前二
    PRIZE_H2 = 10,    // 后二
    PRIZE_SPEQ3 = 11,  // 前三特别奖
    PRIZE_SPEH3 = 12,  // 后三特别奖
    PRIZE_SPEQ2 = 13,  // 前二特别奖
    PRIZE_SPEH2 = 14   // 后二特别奖

}PRIZE;

typedef struct _GL_KOCTTY_DRAWNUM
{
    bool distribute_4d;
    bool distribute_q3;
    bool distribute_h3;
    bool distribute_q2;
    bool distribute_h2;
    uint8  zx4_map[4*2];
	uint16 winNum;

	uint16 zx4Compact;
	uint16 q3Compact;
	uint16 h3Compact;
	uint16 q2Compact;
	uint16 h2Compact;
	
	uint16 zx4sort;
	uint16 q3sort;
	uint16 h3sort;
	uint16 q2sort;
	uint16 h2sort;

} GL_KOCTTY_DRAWNUM;

//玩法规则参数
typedef struct _SUBTYPE_PARAM
{
    bool used; //是否被使用
    uint8 subtypeCode;
    char subtypeAbbr[10]; //游戏玩法标识
    char subtypeName[ENTRY_NAME_LEN];
    uint32 bettype; //支持的投注方式,按位显示,与投注方式表下标对应
    uint8 status; //1 ENABLED / 2 DISABLED  仅用于销售控制
    uint8 A_selectBegin; //号码集合(A区)   起始号码
    uint8 A_selectEnd; //号码集合(A区)   结束号码
    uint16 singleAmount;//玩法下的单注金额(分)
} SUBTYPE_PARAM;

//匹配规则参数
typedef struct _DIVISION_PARAM
{
    bool used; //是否被使用
    uint8  divisionCode;
    char divisionName[ENTRY_NAME_LEN];
    uint8  prizeCode;  //奖级编号
    uint8  subtypeCode; //玩法编号
    bool  distribute; //号码分布
    uint8  matchCount; //匹配个数
    uint8  specWinFlag;  //启用特殊中将规则标志

} DIVISION_PARAM;


//算奖配置参数
typedef struct _KOCTTY_CALC_PRIZE_PARAM
{
    uint8  specWinFlag;
}KOCTTY_CALC_PRIZE_PARAM;

typedef struct _KOCTTY_DATABASE
{
    ISSUE_INFO issueTable[1234];//暂时编译使用 caoxf__
    uint8 subtypeCnt;//玩法个数
    uint8 divisionCnt;//匹配个数
    uint8 prizeCnt;//奖级个数
    SUBTYPE_PARAM subtypeTable[MAX_SUBTYPE_COUNT]; //玩法规则参数表
    DIVISION_PARAM divisionTable[MAX_DIVISION_COUNT]; //匹配规则参数表
    PRIZE_PARAM prizeTable[MAX_PRIZE_COUNT]; //奖级参数表
    POOL_PARAM poolParam; //游戏奖池参数表
}KOCTTY_DATABASE;

typedef KOCTTY_DATABASE* KOCTTY_DATABASE_PTR;

#pragma pack()

extern TABLE_KOCTTY table_koctty;

bool gl_koctty_mem_creat(int issue_count);
bool gl_koctty_mem_destroy(void);
bool gl_koctty_mem_attach(void);
bool gl_koctty_mem_detach(void);

void *gl_koctty_get_mem_db(void);
KOCTTY_DATABASE_PTR gl_koctty_getDatabasePtr(void);

void *gl_koctty_getSubtypeTable(int *len);
SUBTYPE_PARAM *gl_koctty_getSubtypeParam(uint8 subtypeCode);
void *gl_koctty_getDivisionTable(int *len,uint64 issueNumber);
DIVISION_PARAM *gl_koctty_getDivisionParam(uint8 divisionCode);
PRIZE_PARAM * gl_koctty_getPrizeTable(uint64 issue);

POOL_PARAM *gl_koctty_getPoolParam(void);
void *gl_koctty_getRkTable(void);

int gl_koctty_getSingleAmount(char *buffer, size_t len);
ISSUE_INFO *gl_koctty_getIssueTable(void);
int get_koctty_issueMaxCount(void);
int get_koctty_issueCount(void);

bool gl_koctty_load_memdata(void);

int gl_koctty_load_newIssueData(void *issueBuf, int32 issueCount);
int gl_koctty_load_oldIssueData(void *issueBuf, int32 issueCount);

ISSUE_INFO* gl_koctty_get_currIssue(void);
ISSUE_INFO* gl_koctty_get_issueInfo(uint64 issueNum);
ISSUE_INFO* gl_koctty_get_issueInfo2(uint32 issueSerial);
bool gl_koctty_del_issue(uint64 issueNum);
bool gl_koctty_clear_oneIssueData(uint64 issueNum);
//int gl_koctty_inquiry_subtypeInfo(GAME_METHOD_INFO *methodInfo);

uint32 gl_koctty_get_issueMaxSeq(void);

//ccheckpoint 数据保存 和 数据恢复
bool gl_koctty_chkp_saveData(const char *filePath);
bool gl_koctty_chkp_restoreData(const char *filePath);

bool gl_koctty_loadPrizeTable(uint64 issue,PRIZE_PARAM_ISSUE *prize);
PRIZE_PARAM *gl_koctty_getPrizeTableBegin(void);

ISSUE_INFO* gl_koctty_get_issueInfoByIndex(int idx);
void *gl_koctty_get_rkIssueDataTable(void);

int gl_koctty_format_ticket(char* buf, uint32 length, int mode, BETLINE* betline);

int gl_koctty_resolve_winStr(uint64 issue,void *buf);
char *gl_koctty_get_winStr(uint64 issue);

int gl_koctty_gen_fun(int type, char *in, char *out);

int  gl_tty_getDsPosition(int n, int k, uint8 position[][4]);
void gl_tty_getDsNum(uint8 bitmap[], uint8 outnum[], uint8 position[], int count);
int gl_tty_getRepeat(uint16 num, int count);
#endif





