#ifndef GL_KOC11X5_RK_H_INCLUDED
#define GL_KOC11X5_RK_H_INCLUDED



/*=========================================================================================================
 * 全局常量及值宏定义，并对其进行简要说明
 * Global Constant & Macro Definitions and Brief Description
 =========================================================================================================*/


#define RISKNUMBER_STR_LENGTH 200

#define KOC11X5_SUBTYPE_COUNT 12

/*=========================================================================================================
 * 类型定义(struct、enum)等,如果是重要数据结构，要详细说明
 * Type Declarations(struct,enum etc.) and Brief Description
 * If it's Significant,Detailed Description Should Be Present
 * 使用类型回归本地常量定义(const)等，如果是重要数据结构，要详细说明
 * Recuve Declare Vars ,If important,Detailed Description is Required.
 =========================================================================================================*/



typedef struct _GAME_KOC11X5_RK_INDEX
{
    uint16 bn2idx[12][12][12][12][12];
    uint16 betmap[KOC11X5_SUBTYPE_COUNT + 1][990];          // each DS bet of subtype
    uint16 w2bidx[55440][KOC11X5_SUBTYPE_COUNT + 1][20];    // one five win num -> each bet index of subtype
    uint16 b2windex[KOC11X5_SUBTYPE_COUNT + 1][990][10080]; // any betmap -> 0 ~ 55439 of w2bidx
}GAME_KOC11X5_RK_INDEX;


typedef struct _KOC11X5_BETS_COUNTS
{
	uint32    betCount;
	uint32    betCountCommit;
}KOC11X5_BETS_COUNTS;


typedef struct _GAME_RISK_KOC11X5_ISSUE_DATA
{
    money_t                    maxPay;                                   //最大赔付
    money_t                    riskValue;                                //风控阀值
	uint16                     returnRate;                               //返奖率

	money_t                    sub_unitWin[KOC11X5_SUBTYPE_COUNT + 1];   // idx = subtype code 

	KOC11X5_BETS_COUNTS        bets[KOC11X5_SUBTYPE_COUNT + 1][990];

	money_t                    saleMoney;                                // for tf_adder verify
	money_t                    saleMoneyCommit;                          // for tf_reply and tf_updater_db

	money_t                    currMaxWin;                               // for report
	money_t                    currPay;                                  // for report ---

	uint32                     issueSeq;

}GAME_RISK_KOC11X5_ISSUE_DATA;



typedef struct _GL_KOC11X5_RK_CHKP_ISSUE_DATA
{
	GAME_RISK_KOC11X5_ISSUE_DATA rkData[MAX_ISSUE_NUMBER];
}GL_KOC11X5_RK_CHKP_ISSUE_DATA;


#pragma pack()


bool gl_koc11x5_rk_mem_get_meta( int *length);
bool gl_koc11x5_rk_mem_save( void *buf, int *length);
bool gl_koc11x5_rk_mem_recovery( void *buf, int length);

bool gl_koc11x5_sale_rk_verify(TICKET* pTicket);
void gl_koc11x5_sale_rk_commit(TICKET* pTicket);

void gl_koc11x5_cancel_rk_rollback(TICKET* pTicket);
void gl_koc11x5_cancel_rk_commit(TICKET* pTicket);

bool gl_koc11x5_rk_saveData(const char *filePath);
bool gl_koc11x5_rk_restoreData(const char *filePath);
void gl_koc11x5_rk_reinitData(void);

bool gl_koc11x5_load_memdata(void);

bool isSubTypeBeRiskControl(uint8 gameidx,uint8 subidx);

bool load_koc11x5_all_issue(char *rk_param);


void rk_clear_issue_betsData(int issue);

bool load_koc11x5_issue_rkdata(uint32 startIssueNumber,int issue_count, char *rk_param);

bool gl_koc11x5_rk_getReportData(uint32 issueSeq,void *currMaxPay);

bool gl_koc11x5_rk_init(void);

#endif





