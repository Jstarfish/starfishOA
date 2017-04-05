#ifndef GL_SSC_DB_H__
#define GL_SSC_DB_H__




/*=========================================================================================================
 * 函数性宏定义，并对其进行简要说明
 * Functional Macro Definitions and Brief Description
 =========================================================================================================*/
#include "gl_plugins_inf.h"

typedef struct _TABLE_SSC
{
    uint8  zxhz2[19];
    uint8  zuxhz2[19];
    uint8  zxhz3[28];
    uint8  zuxhz3[28];
    uint16 zxbc[11];
    uint8  z3fs[11];
    uint8  z6fs[11];
    uint8  zuxbd2[2];
    uint8  zuxbd3[3];
} TABLE_SSC;

#pragma pack(1)

typedef enum _SUBTYPE
{
    SUBTYPE_1ZX   = 1,
    SUBTYPE_2ZX   = 2,
    SUBTYPE_2FX   = 3,
    SUBTYPE_2ZUX  = 4,
    SUBTYPE_3ZX   = 5,
    SUBTYPE_3FX   = 6,
    SUBTYPE_3ZUX  = 7,
    SUBTYPE_3Z3   = 8,
    SUBTYPE_3Z6   = 9,
    SUBTYPE_5ZX   = 10,
    SUBTYPE_5FX   = 11,
    SUBTYPE_5TX   = 12,
    SUBTYPE_DXDS  = 13,
}SUBTYPE;

//不能从0计数
typedef enum _PRIZE
{
    PRIZE_1ZX      = 1,  //一星直选 10
    PRIZE_2ZX      = 2,  //二星直选 100
    PRIZE_3ZX      = 3,  //三星直选 1000
    PRIZE_5ZX      = 4,  //五星直选 100,000
    PRIZE_DXDS     = 5,  //大小单双 4
    PRIZE_2ZUX20   = 6,  //二星组选-20 100
    PRIZE_2ZUX11   = 7,  //二星组选-11 50
    PRIZE_3ZUX300  = 8,  //三星组选-300 1000
    PRIZE_3ZUX210  = 9,  //三星组选-210 320
    PRIZE_3ZUX111  = 10, //三星组选-111 160
    PRIZE_3Z3      = 11, //三星组三 320
    PRIZE_3Z6      = 12, //三星组六 160
    PRIZE_5TX1     = 13, //五星通选-一等奖 20,000
    PRIZE_5TX2     = 14, //五星通选-二等奖 200
    PRIZE_5TX3     = 15, //五星通选-三等奖 20
}PRIZE;

typedef struct _GL_SSC_DRAWNUM
{
    uint32 distribute2;
    uint32 distribute3;
    uint8  hz2;
    uint8  hz3;
    uint8  pmap2[2];
    uint8  pmap3[2];
    uint8  smap[5*2];
    uint8  smapZ3[2*2];//3Z3DS
    uint8  smap2[2][2*2];//2ZUXYXFS
    uint8  smap3[6][3*2];//3ZUXBD
    uint8  dxds[4];//0~3
} GL_SSC_DRAWNUM;

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
    uint32 A_distribute; //号码分布(A区)
    uint8 A_baseBegin; //基本起始(A区) 开奖号
    uint8 A_baseEnd; //基本结束(A区)
    //bool A_hasOrder; //有序匹对(A区)
    uint8 mutex;      //匹配规则之间互斥  0:不启用  1~255
} DIVISION_PARAM;

typedef struct _SSC_DATABASE
{
    ISSUE_INFO issueTable[1234];//暂时编译使用 caoxf__
    uint8 subtypeCnt;//玩法个数
    uint8 divisionCnt;//匹配个数
    uint8 prizeCnt;//奖级个数
    SUBTYPE_PARAM subtypeTable[MAX_SUBTYPE_COUNT]; //玩法规则参数表
    DIVISION_PARAM divisionTable[MAX_DIVISION_COUNT]; //匹配规则参数表
    PRIZE_PARAM prizeTable[MAX_PRIZE_COUNT]; //奖级参数表
    POOL_PARAM poolParam; //游戏奖池参数表
}SSC_DATABASE;

typedef SSC_DATABASE* SSC_DATABASE_PTR;

#pragma pack()

extern TABLE_SSC table_ssc;

bool gl_ssc_mem_creat(int issue_count);
bool gl_ssc_mem_destroy(void);
bool gl_ssc_mem_attach(void);
bool gl_ssc_mem_detach(void);

void *gl_ssc_get_mem_db(void);
SSC_DATABASE_PTR gl_ssc_getDatabasePtr(void);

void *gl_ssc_getSubtypeTable(int *len);
SUBTYPE_PARAM *gl_ssc_getSubtypeParam(uint8 subtypeCode);
void *gl_ssc_getDivisionTable(int *len,uint64 issueNum);
DIVISION_PARAM *gl_ssc_getDivisionParam(uint8 divisionCode);
PRIZE_PARAM * gl_ssc_getPrizeTable(uint64 issue);

POOL_PARAM *gl_ssc_getPoolParam(void);
void *gl_ssc_getRkTable(void);
int gl_ssc_getSingleAmount(char *buffer, size_t len);
ISSUE_INFO *gl_ssc_getIssueTable(void);
int get_ssc_issueMaxCount(void);
int get_ssc_issueCount(void);

bool gl_ssc_load_memdata(void);

int gl_ssc_load_newIssueData(void *issueBuf, int32 issueCount);
int gl_ssc_load_oldIssueData(void *issueBuf, int32 issueCount);

ISSUE_INFO* gl_ssc_get_currIssue(void);
ISSUE_INFO* gl_ssc_get_issueInfo(uint64 issueNum);
ISSUE_INFO* gl_ssc_get_issueInfo2(uint32 issueSerial);
bool gl_ssc_del_issue(uint64 issueNum);
bool gl_ssc_clear_oneIssueData(uint64 issueNum);
//int gl_ssc_inquiry_subtypeInfo(GAME_METHOD_INFO *methodInfo);

uint32 gl_ssc_get_issueMaxSeq(void);

//ccheckpoint 数据保存 和 数据恢复
bool gl_ssc_chkp_saveData(const char *filePath);
bool gl_ssc_chkp_restoreData(const char *filePath);

bool gl_ssc_loadPrizeTable(uint64 issue,PRIZE_PARAM_ISSUE *prize);
PRIZE_PARAM *gl_ssc_getPrizeTableBegin(void);

ISSUE_INFO* gl_ssc_get_issueInfoByIndex(int idx);
void *gl_ssc_get_rkIssueDataTable(void);

int gl_ssc_format_ticket(char* buf, uint32 length, int mode, BETLINE* betline);

#endif





