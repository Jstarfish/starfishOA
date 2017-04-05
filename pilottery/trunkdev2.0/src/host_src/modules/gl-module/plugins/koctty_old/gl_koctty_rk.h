#ifndef GL_KOCTTY_RK_H_INCLUDED
#define GL_KOCTTY_RK_H_INCLUDED



/*=========================================================================================================
 * ȫ�ֳ�����ֵ�궨�壬��������м�Ҫ˵��
 * Global Constant & Macro Definitions and Brief Description
 =========================================================================================================*/
#define MAX_WINLEVEL 3
#define MAX_BET_TYPE 6
#define RISKNUMBER_STR_LENGTH 200
#define RISKNUMBER_ONE_SUBTYPE 1

#define MAX_FUN_KEY 14

#define KOCTTY_SUBTYPE_COUNT 7

/*=========================================================================================================
 * ���Ͷ���(struct��enum)��,�������Ҫ���ݽṹ��Ҫ��ϸ˵��
 * Type Declarations(struct,enum etc.) and Brief Description
 * If it's Significant,Detailed Description Should Be Present
 * ʹ�����ͻع鱾�س�������(const)�ȣ��������Ҫ���ݽṹ��Ҫ��ϸ˵��
 * Recuve Declare Vars ,If important,Detailed Description is Required.
 =========================================================================================================*/


//���տ��Ʋ���
typedef struct _KOCTTY_RISKCTRL_PARAM
{
    money_t maxPay;      //����⸶
    money_t riskValue;   //��ط�ֵ
	money_t unitBetWin;  //��ͨ����ע�н�����
	money_t specBetWin;  //�����н�����ע�н�����
}KOCTTY_RISKCTRL_PARAM;


// KOCTTY���տ�����Ӫ������
typedef struct _KOCTTY_BETCOUNT
{
    uint32 betCount;
    uint32 betCountCommit;

}KOCTTY_BETCOUNT;


typedef struct _KOCTTY_BET_DATA
{
	KOCTTY_BETCOUNT          koctty2star[100];
	KOCTTY_BETCOUNT          koctty3star[1000];
	KOCTTY_BETCOUNT          koctty4star[10000];

}KOCTTY_BET_DATA;


typedef struct _GAME_RISK_KOCTTY_ISSUE_DATA
{
	uint16                     returnRate;                                //������
	KOCTTY_RISKCTRL_PARAM      riskCtrl[KOCTTY_SUBTYPE_COUNT];
	money_t                    saleMoney[KOCTTY_SUBTYPE_COUNT];           // tmp for tf_adder verify
	money_t                    saleMoneyCommit[KOCTTY_SUBTYPE_COUNT];     //commit for tf_reply and tf_updater_db

	money_t                    currMaxWin[KOCTTY_SUBTYPE_COUNT];          //for report
	money_t                    currPay[KOCTTY_SUBTYPE_COUNT];             //for report ---

	KOCTTY_BET_DATA            betData;
}GAME_RISK_KOCTTY_ISSUE_DATA;


typedef GAME_RISK_KOCTTY_ISSUE_DATA* GAME_KOCTTYRISK_PTR;


typedef struct _GL_KOCTTY_RK_CHKP_DATA
{
	uint32 issueSeq;

    uint32 twoStarbetCountCommit[100];

    uint32 threeStarbetCountCommit[1000];

    uint32 fourStarbetCountCommit[10000];

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

#endif





