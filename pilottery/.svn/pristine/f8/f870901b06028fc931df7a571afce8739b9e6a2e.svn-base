#ifndef GL_KOC7LX_DB_H_
#define GL_KOC7LX_DB_H_

#include "gl_plugins_inf.h"

//投注方式
typedef enum _SUBTYPE
{
    SUBTYPE_ZX     = 1, //直选
    //SUBTYPE_ZXHALF = 2, //直选二分之一
} SUBTYPE;

//奖等 不能从0计数
typedef enum _PRIZE
{
    PRIZE_1  = 1,  //一等奖
    PRIZE_2  = 2,  //二等奖
    PRIZE_3  = 3,  //三等奖
    PRIZE_4  = 4,  //四等奖
    PRIZE_5  = 5,  //五等奖
    PRIZE_6  = 6,  //六等奖
    PRIZE_7  = 7,  //七等奖
    PRIZE_1H = 8,  //一等奖(二分之一)
//    PRIZE_2H = 9,  //二等奖(二分之一)
//    PRIZE_3H = 10, //三等奖(二分之一)
//    PRIZE_4H = 11, //四等奖(二分之一)
//    PRIZE_5H = 12, //五等奖(二分之一)
//    PRIZE_6H = 13, //六等奖(二分之一)
//    PRIZE_7H = 14, //七等奖(二分之一)
} PRIZE;

#pragma pack(1)

//七龙星投注号码bitmap格式
typedef struct _GL_KOC7LX_DRAWNUM
{
    uint8 drawA[5];      //开奖号码的bitmap(不包括特别号码，总共6个bit)
    uint8 specialNumber; //特别号码数值
} GL_KOC7LX_DRAWNUM;

//保存实际选择号码个数
typedef struct _GL_KOC7LX_SELECTNUM
{
    uint8 ACnt;
    uint8 ATCnt;
} GL_KOC7LX_SELECTNUM;

//保存匹配时猜中的号码个数
typedef struct _GL_KOC7LX_MATCHNUM
{
    uint8 ACnt;            //A区匹配号码个数(不包括特别号码)
    uint8 ATCnt;           //A拖区匹配号码个数(不包括特别号码)
    uint8 specialMatched;  //特别号码匹配(0未匹配1匹配)
    uint8 specialTMatched; //特别号码在拖区匹配(0未匹配1匹配)
} GL_KOC7LX_MATCHNUM;

//玩法规则参数
typedef struct _SUBTYPE_PARAM
{
    bool   used; //是否被使用
    uint8  subtypeCode; //游戏玩法编号
    char   subtypeAbbr[10]; //游戏玩法标识
    char   subtypeName[ENTRY_NAME_LEN]; //游戏玩法名称
    uint32 bettype; //支持的投注方式,按位显示,与投注方式表下标对应
    uint8  status; //1 ENABLED / 2 DISABLED  仅用于销售控制
    uint8  A_selectBegin; //号码集合(A区)   起始号码
    uint8  A_selectEnd; //号码集合(A区)   结束号码
    uint8  A_selectCount; //选号个数(A区)
    uint8  A_selectMaxCount; //复式最大选号个数(A区)
    uint16 singleAmount; //玩法下的单注金额(瑞尔)
} SUBTYPE_PARAM;

//匹配规则参数
typedef struct _DIVISION_PARAM
{
    bool  used; //是否被使用
    uint8 divisionCode;
    char  divisionName[ENTRY_NAME_LEN];
    uint8 prizeCode;  //奖等编号 enum PRIZE
    uint8 subtypeCode; //玩法编号
    uint8 A_matchCount; //匹对个数(A区)
    uint8 specialNumberMatch; //特别号码匹对值(0未匹对1匹对)
} DIVISION_PARAM;

//算奖配置参数
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


