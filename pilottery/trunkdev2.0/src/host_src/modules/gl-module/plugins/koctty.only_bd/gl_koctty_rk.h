#ifndef GL_KOCTTY_RK_H_INCLUDED
#define GL_KOCTTY_RK_H_INCLUDED



/*=========================================================================================================
 * 全局常量及值宏定义，并对其进行简要说明
 * Global Constant & Macro Definitions and Brief Description
 =========================================================================================================*/

#define RISKNUMBER_STR_LENGTH 200

#define MAX_FUN_KEY 14

#define KOCTTY_SUBTYPE_COUNT 8

#define KOCTTY_BC_2D_MAX 100
#define KOCTTY_BC_3D_MAX 1000
#define KOCTTY_BC_4D_MAX 10000

#define KOCTTY_BC_COUNT_MAX 24

/*=========================================================================================================
 * 类型定义(struct、enum)等,如果是重要数据结构，要详细说明
 * Type Declarations(struct,enum etc.) and Brief Description
 * If it's Significant,Detailed Description Should Be Present
 * 使用类型回归本地常量定义(const)等，如果是重要数据结构，要详细说明
 * Recuve Declare Vars ,If important,Detailed Description is Required.
 =========================================================================================================*/


//风险控制参数
typedef struct _KOCTTY_RISKCTRL_PARAM
{
    money_t maxPay;      //最大赔付
    money_t riskValue;   //风控阀值
	money_t unitBetWin;  //普通规则单注中奖奖金
	money_t specBetWin;  //特殊中奖规则单注中奖奖金
}KOCTTY_RISKCTRL_PARAM;


// KOCTTY风险控制运营参数表
typedef struct _KOCTTY_BETCOUNT
{
    uint32 betCount;
    uint32 betCountCommit;

}KOCTTY_BETCOUNT;


typedef struct _KOCTTY_BET_DATA
{
	KOCTTY_BETCOUNT          kqh2[100];
	KOCTTY_BETCOUNT          kqh3[1000];
	KOCTTY_BETCOUNT          k4[10000];

	KOCTTY_BETCOUNT          q2[100];
	KOCTTY_BETCOUNT          h2[100];
	KOCTTY_BETCOUNT          q3[1000];
	KOCTTY_BETCOUNT          h3[1000];

}KOCTTY_BET_DATA;


typedef struct _GAME_RISK_KOCTTY_ISSUE_DATA
{
	uint16                     returnRate;                                //返奖率
	KOCTTY_RISKCTRL_PARAM      riskCtrl[KOCTTY_SUBTYPE_COUNT];
	money_t                    saleMoney[KOCTTY_SUBTYPE_COUNT];           // tmp for tf_adder verify
	money_t                    saleMoneyCommit[KOCTTY_SUBTYPE_COUNT];     //commit for tf_reply and tf_updater_db

	money_t                    currMaxWin[KOCTTY_SUBTYPE_COUNT];          //for report
	money_t                    currPay[KOCTTY_SUBTYPE_COUNT];             //for report ---

	KOCTTY_BET_DATA            betData;
}GAME_RISK_KOCTTY_ISSUE_DATA;

typedef struct _KOCTTY_BETBC_INDEX
{
	uint16 numCount;
    uint16 numArray[KOCTTY_BC_COUNT_MAX];

}KOCTTY_BETBC_INDEX;

typedef struct _KOCTTY_BETBC_TABLE
{
	KOCTTY_BETBC_INDEX twoStarBC[KOCTTY_BC_2D_MAX];
	KOCTTY_BETBC_INDEX threeStarBC[KOCTTY_BC_3D_MAX];
	KOCTTY_BETBC_INDEX fourStarBC[KOCTTY_BC_4D_MAX];

}KOCTTY_BETBC_TABLE;



typedef struct _GL_KOCTTY_RK_CHKP_DATA
{
	uint32 issueSeq;

    uint32 twoStarbetCountCommit[100];

    uint32 threeStarbetCountCommit[1000];

    uint32 fourStarbetCountCommit[10000];

    uint32 firstTwoBetCountCommit[100];
    uint32 lastTwoBetCountCommit[100];
    uint32 firstThreeBetCountCommit[1000];
    uint32 lastThreeBetCountCommit[1000];

    money_t  saleMoneyCommit[KOCTTY_SUBTYPE_COUNT];


}GL_KOCTTY_RK_CHKP_DATA;

typedef struct _GL_KOCTTY_RK_CHKP_ISSUE_DATA
{
	GL_KOCTTY_RK_CHKP_DATA rkData[MAX_ISSUE_NUMBER];
}GL_KOCTTY_RK_CHKP_ISSUE_DATA;


#pragma pack()


bool gl_koctty_rk_mem_get_meta( int *length);
bool gl_koctty_rk_mem_save( void *buf, int *length);
bool gl_koctty_rk_mem_recovery( void *buf, int length);

bool gl_koctty_sale_rk_verify(TICKET* pTicket);
void gl_koctty_sale_rk_commit(TICKET* pTicket);

void gl_koctty_cancel_rk_rollback(TICKET* pTicket);
void gl_koctty_cancel_rk_commit(TICKET* pTicket);

bool gl_koctty_rk_saveData(const char *filePath);
bool gl_koctty_rk_restoreData(const char *filePath);
void gl_koctty_rk_reinitData(void);

bool gl_koctty_load_memdata(void);

bool isSubTypeBeRiskControl(uint8 gameidx,uint8 subidx);

bool load_koctty_all_issue(char *rk_param);


void rk_clear_issue_betsData(int issue);

bool load_koctty_issue_rkdata(uint32 startIssueNumber,int issue_count, char *rk_param);

void rk_initVerifyFun(void);

bool gl_koctty_rk_getReportData(uint32 issueSeq,void *currMaxPay);

bool gl_tty_rk_init(void);

#endif





