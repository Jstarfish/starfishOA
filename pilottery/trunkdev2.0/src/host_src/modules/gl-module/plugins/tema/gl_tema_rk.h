#ifndef GL_TEMA_RK_H_INCLUDED
#define GL_TEMA_RK_H_INCLUDED



/*=========================================================================================================
 * ȫ�ֳ�����ֵ�궨�壬��������м�Ҫ˵��
 * Global Constant & Macro Definitions and Brief Description
 =========================================================================================================*/
#define MAX_WINLEVEL 3
#define MAX_BET_TYPE 6
#define RISKNUMBER_STR_LENGTH 200
#define RISKNUMBER_ONE_SUBTYPE 1

#define MAX_FUN_KEY 14

#define TEMA_SUBTYPE_COUNT 2
#define TEMA_MAX_BALLNUM 40

/*=========================================================================================================
 * ���Ͷ���(struct��enum)��,�������Ҫ���ݽṹ��Ҫ��ϸ˵��
 * Type Declarations(struct,enum etc.) and Brief Description
 * If it's Significant,Detailed Description Should Be Present
 * ʹ�����ͻع鱾�س�������(const)�ȣ��������Ҫ���ݽṹ��Ҫ��ϸ˵��
 * Recuve Declare Vars ,If important,Detailed Description is Required.
 =========================================================================================================*/


//���տ��Ʋ���

typedef struct _TEMA_RK_BETS_COUNT
{
    uint32     betCount[TEMA_MAX_BALLNUM + 1];
    uint32     betCountCommit[TEMA_MAX_BALLNUM + 1];

}TEMA_RK_BETS_COUNT;


typedef struct _GAME_RISK_TEMA_ISSUE_DATA
{
    money_t    winMoney[TEMA_SUBTYPE_COUNT];  //�淨�н�����

	uint16     returnRate;                    //������
    money_t    maxPay;                        //����⸶
    money_t    riskValue;                     //��ط�ֵ

    money_t    totalSaleMoney;
    money_t    totalSaleMoneyCommit;

	money_t    currMaxWin;          //for report
	money_t    currPay;             //for report ---

    TEMA_RK_BETS_COUNT bets[TEMA_SUBTYPE_COUNT];

}GAME_RISK_TEMA_ISSUE_DATA;


typedef GAME_RISK_TEMA_ISSUE_DATA* GAME_TEMARISK_PTR;


typedef struct _GL_TEMA_RK_CHKP_DATA
{
	uint32    issueSeq;

	uint32    betCountCommitJC[TEMA_MAX_BALLNUM];
	uint32    betCountCommit4T[TEMA_MAX_BALLNUM];
	money_t   totalSaleMoneyCommit;

}GL_TEMA_RK_CHKP_DATA;

typedef struct _GL_TEMA_RK_CHKP_ISSUE_DATA
{
	GL_TEMA_RK_CHKP_DATA rkData[MAX_ISSUE_NUMBER];
}GL_TEMA_RK_CHKP_ISSUE_DATA;


#pragma pack()


bool gl_tema_rk_mem_get_meta( int *length);
bool gl_tema_rk_mem_save( void *buf, int *length);
bool gl_tema_rk_mem_recovery( void *buf, int length);

bool gl_tema_sale_rk_verify(TICKET* pTicket);
void gl_tema_sale_rk_commit(TICKET* pTicket);

void gl_tema_cancel_rk_rollback(TICKET* pTicket);
void gl_tema_cancel_rk_commit(TICKET* pTicket);

bool gl_tema_rk_saveData(const char *filePath);
bool gl_tema_rk_restoreData(const char *filePath);
void gl_tema_rk_reinitData(void);

bool gl_tema_load_memdata(void);

bool isSubTypeBeRiskControl(uint8 gameidx,uint8 subidx);

bool load_tema_all_issue(char *rk_param);
bool gl_tema_rk_init();

void rk_clear_issue_betsData(int issue);

bool load_tema_issue_rkdata(uint32 startIssueNumber,int issue_count, char *rk_param);

void rk_initVerifyFun(void);

bool gl_tema_rk_getReportData(uint32 issueSeq,void *currMaxPay);

#endif





