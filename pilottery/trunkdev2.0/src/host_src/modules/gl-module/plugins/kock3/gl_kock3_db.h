#ifndef GL_KOCK3_DB_H__
#define GL_KOCK3_DB_H__




/*=========================================================================================================
 * 函数性宏定义，并对其进行简要说明
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

//不能从0计数
typedef enum _PRIZE
{
    PRIZE_3TS = 1,          //三同号单选 奖金: 240

    PRIZE_ZX_HZ_3_18 = 2,   //直选和值 3 和 18 奖金: 240

    PRIZE_2TS = 3,          //二同号单选 奖金: 80

    PRIZE_ZX_HZ_4_17 = 4,   //直选和值 4 和 17 奖金: 80

    PRIZE_3TA = 5,          //三同号通选 奖金: 40

    PRIZE_ZX_HZ_5_16 = 6,   //直选和值 5 和 16 奖金: 40

    PRIZE_3DS = 7,          //三不同单选 奖金: 40

    PRIZE_ZX_HZ_6_15 = 8,   //直选和值 6 和 15 奖金: 25

    PRIZE_ZX_HZ_7_14 = 9,   //直选和值 7 和 14 奖金: 16

    PRIZE_2TA = 10,         //二同号复选 奖金: 15

    PRIZE_ZX_HZ_8_13 = 11,  //直选和值 8 和 13 奖金: 12

    PRIZE_3QA = 12,         //三连号通选 奖金: 10

    PRIZE_ZX_HZ_9_12 = 13,  //直选和值 9 和 12 奖金: 10

    PRIZE_ZX_HZ_10_11 = 14, //直选和值 10 和 11 奖金: 9

    PRIZE_2DS = 15,         //二不同单选 奖金: 8

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
    uint8  distribute; //号码分布
    uint8  absDiff;    //abs(21-2x),x-->hz

} DIVISION_PARAM;


//算奖配置参数
typedef struct _KOCK3_CALC_PRIZE_PARAM
{
    uint8  specWinFlag;
}KOCK3_CALC_PRIZE_PARAM;

typedef struct _KOCK3_DATABASE
{
    ISSUE_INFO issueTable[1234];//暂时编译使用 caoxf__
    uint8 subtypeCnt;//玩法个数
    uint8 divisionCnt;//匹配个数
    uint8 prizeCnt;//奖级个数
    SUBTYPE_PARAM subtypeTable[MAX_SUBTYPE_COUNT]; //玩法规则参数表
    DIVISION_PARAM divisionTable[MAX_DIVISION_COUNT]; //匹配规则参数表
    PRIZE_PARAM prizeTable[MAX_PRIZE_COUNT]; //奖级参数表
    POOL_PARAM poolParam; //游戏奖池参数表
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

//ccheckpoint 数据保存 和 数据恢复
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





