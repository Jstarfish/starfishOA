#ifndef GL_KOC11X5_DB_H__
#define GL_KOC11X5_DB_H__




/*=========================================================================================================
 * 函数性宏定义，并对其进行简要说明
 * Functional Macro Definitions and Brief Description
 =========================================================================================================*/
#include "gl_plugins_inf.h"

typedef struct _TABLE_KOC11X5
{
    uint8  hz2zx[19];
    uint8  hz3zx[28];
    uint8  hzz3[28];
    uint8  hzz6[28];

} TABLE_KOC11X5;

#pragma pack(1)

typedef enum _SUBTYPE
{
    SUBTYPE_RX2 = 1,
    SUBTYPE_RX3 = 2,
    SUBTYPE_RX4 = 3,
    SUBTYPE_RX5 = 4,
    SUBTYPE_RX6 = 5,
    SUBTYPE_RX7 = 6,
    SUBTYPE_RX8 = 7,

	SUBTYPE_Q1 = 8,
	SUBTYPE_Q2ZU = 9,
	SUBTYPE_Q3ZU = 10,
	SUBTYPE_Q2ZX = 11,
	SUBTYPE_Q3ZX = 12

}SUBTYPE;

//不能从0计数
typedef enum _PRIZE
{
    PRIZE_RX2 = 1,  //任选二
    PRIZE_RX3 = 2,  //任选三
    PRIZE_RX4 = 3,  //任选四
    PRIZE_RX5 = 4,  //任选五
    PRIZE_RX6 = 5,  //任选六
    PRIZE_RX7 = 6,  //任选七
    PRIZE_RX8 = 7,  //任选八

    PRIZE_Q1 = 8,   //前一
    PRIZE_Q2ZU = 9, //前二组选
    PRIZE_Q3ZU = 10,//前三组选
    PRIZE_Q2ZX = 11,//前二直选
    PRIZE_Q3ZX = 12 //前三直选
}PRIZE;

typedef struct _GL_KOC11X5_DRAWNUM
{
	uint8  win_uint[5];
    uint8  zx5_bitmap[5*2];
	uint16 allbitmap;

} GL_KOC11X5_DRAWNUM;

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

} DIVISION_PARAM;


//算奖配置参数
typedef struct _KOC11X5_CALC_PRIZE_PARAM
{
    uint8  specWinFlag;
}KOC11X5_CALC_PRIZE_PARAM;

typedef struct _KOC11X5_DATABASE
{
    ISSUE_INFO issueTable[1234];//暂时编译使用 caoxf__
    uint8 subtypeCnt;//玩法个数
    uint8 divisionCnt;//匹配个数
    uint8 prizeCnt;//奖级个数
    SUBTYPE_PARAM subtypeTable[MAX_SUBTYPE_COUNT]; //玩法规则参数表
    DIVISION_PARAM divisionTable[MAX_DIVISION_COUNT]; //匹配规则参数表
    PRIZE_PARAM prizeTable[MAX_PRIZE_COUNT]; //奖级参数表
    POOL_PARAM poolParam; //游戏奖池参数表
}KOC11X5_DATABASE;

typedef KOC11X5_DATABASE* KOC11X5_DATABASE_PTR;

#pragma pack()

extern TABLE_KOC11X5 table_koc11x5;

bool gl_koc11x5_mem_creat(int issue_count);
bool gl_koc11x5_mem_destroy(void);
bool gl_koc11x5_mem_attach(void);
bool gl_koc11x5_mem_detach(void);

void *gl_koc11x5_get_mem_db(void);
KOC11X5_DATABASE_PTR gl_koc11x5_getDatabasePtr(void);

void *gl_koc11x5_getSubtypeTable(int *len);
SUBTYPE_PARAM *gl_koc11x5_getSubtypeParam(uint8 subtypeCode);
void *gl_koc11x5_getDivisionTable(int *len,uint64 issueNumber);
DIVISION_PARAM *gl_koc11x5_getDivisionParam(uint8 divisionCode);
PRIZE_PARAM * gl_koc11x5_getPrizeTable(uint64 issue);

POOL_PARAM *gl_koc11x5_getPoolParam(void);
void *gl_koc11x5_getRkTable(void);

int gl_koc11x5_getSingleAmount(char *buffer, size_t len);
ISSUE_INFO *gl_koc11x5_getIssueTable(void);
int get_koc11x5_issueMaxCount(void);
int get_koc11x5_issueCount(void);

bool gl_koc11x5_load_memdata(void);

int gl_koc11x5_load_newIssueData(void *issueBuf, int32 issueCount);
int gl_koc11x5_load_oldIssueData(void *issueBuf, int32 issueCount);

ISSUE_INFO* gl_koc11x5_get_currIssue(void);
ISSUE_INFO* gl_koc11x5_get_issueInfo(uint64 issueNum);
ISSUE_INFO* gl_koc11x5_get_issueInfo2(uint32 issueSerial);
bool gl_koc11x5_del_issue(uint64 issueNum);
bool gl_koc11x5_clear_oneIssueData(uint64 issueNum);
//int gl_koc11x5_inquiry_subtypeInfo(GAME_METHOD_INFO *methodInfo);

uint32 gl_koc11x5_get_issueMaxSeq(void);

//ccheckpoint 数据保存 和 数据恢复
bool gl_koc11x5_chkp_saveData(const char *filePath);
bool gl_koc11x5_chkp_restoreData(const char *filePath);

bool gl_koc11x5_loadPrizeTable(uint64 issue,PRIZE_PARAM_ISSUE *prize);
PRIZE_PARAM *gl_koc11x5_getPrizeTableBegin(void);

ISSUE_INFO* gl_koc11x5_get_issueInfoByIndex(int idx);
void *gl_koc11x5_get_rkIssueDataTable(void);

int gl_koc11x5_format_ticket(char* buf, uint32 length, int mode, BETLINE* betline);

int gl_koc11x5_resolve_winStr(uint64 issue,void *buf);
char *gl_koc11x5_get_winStr(uint64 issue);


int gl_koc11x5_subNum(uint8 subtype);

int  gl_11x5_getDsPosition(int n, int k, uint8 position[][4]);
void gl_11x5_getDsNum(uint8 bitmap[], uint8 outnum[], uint8 position[], int count);
int gl_11x5_getRepeat(uint16 num, int count);
#endif





