#ifndef GL_KOCK3_RK_H_INCLUDED
#define GL_KOCK3_RK_H_INCLUDED



/*=========================================================================================================
 * 全局常量及值宏定义，并对其进行简要说明
 * Global Constant & Macro Definitions and Brief Description
 =========================================================================================================*/


#define RISKNUMBER_STR_LENGTH 200

#define KOCK3_SUBTYPE_COUNT 8



/*=========================================================================================================
 * 类型定义(struct、enum)等,如果是重要数据结构，要详细说明
 * Type Declarations(struct,enum etc.) and Brief Description
 * If it's Significant,Detailed Description Should Be Present
 * 使用类型回归本地常量定义(const)等，如果是重要数据结构，要详细说明
 * Recuve Declare Vars ,If important,Detailed Description is Required.
 =========================================================================================================*/

typedef struct _KOCK3_HZ_EACHBETS
{
    uint16 zx_num;

    bool sub3t;
    bool sub3q;
    bool sub3ds;
    bool sub2ta;
    uint8 sub2ta_index;

    bool sub2ts;
    uint8 sub2ts_index;

    uint8 sub2ds;
    uint16 sub2ds_index[6];  // get each 2ds number from one '3nums' of sum

}KOCK3_HZ_EACHBETS;

typedef struct _KOCK3_ZX_HZ
{
    uint8 numCount;
    KOCK3_HZ_EACHBETS eachBet[6];

}KOCK3_ZX_HZ;



typedef struct _KOCK3_3T_EACHBETS
{
	uint16 zx_num;
	uint8 subhz;
	uint8 sub2t;

}KOCK3_3T_EACHBETS;

typedef struct _KOCK3_3T
{
	KOCK3_3T_EACHBETS eachBet[6];
}KOCK3_3T;


typedef struct _KOCK3_3Q_EACHBETS
{
	uint16 zx_num;
	uint8 subhz;
	uint8 sub2ds_index[3];

}KOCK3_3Q_EACHBETS;

typedef struct _KOCK3_3QA
{
	KOCK3_3Q_EACHBETS eachBet[4];

}KOCK3_3QA;


typedef struct _KOCK3_3DS
{
	uint16 zx_num;
	uint8 subhz;
	bool sub3qa;
	uint8 sub2ds_index[3];

}KOCK3_3DS;

typedef struct _KOCK3_2T_EACHBETS
{
	uint16 zx_num;          // 3ta 3ts 2ts
	uint8 subhz;
	uint16 sub3t;
	uint16 sub2ds;

}KOCK3_2T_EACHBETS;

typedef struct _KOCK3_2TA
{
	KOCK3_2T_EACHBETS eachBet[6];

}KOCK3_2TA;


typedef struct _KOCK3_2TS
{
	uint8 subhz;              // sum number
	uint8 sub2t;
	uint8 sub2ds;

}KOCK3_2TS;

typedef struct _KOCK3_2DS_EACHBETS
{
	uint16 zx_num;          // 3ta 3ts 2ts
	uint8 subhz;
	bool sub3qa;
	uint16 sub2t;

}KOCK3_2DS_EACHBETS;

typedef struct _KOCK3_2DS
{
	KOCK3_2DS_EACHBETS eachBet[6];
}KOCK3_2DS;

typedef struct _GAME_KOCK3_RK_INDEX
{
	KOCK3_ZX_HZ                index_zx_hz[19];                           // idx = sum
	KOCK3_3T                   index_3t;
	KOCK3_3QA                  index_3qa;
	KOCK3_3DS                  index_3ds[6][6][6];                        // idx = [a-1][b-1][c-1]
	KOCK3_2TA                  index_2ta[6];                              // idx = (aa % 10 - 1)
	KOCK3_2TS                  index_2ts[6][6];                           // idx = [aab / 100 - 1] [aab % 10 - 1]
	KOCK3_2DS                  index_2ds[6][6];                           // idx = [a-1] [b-1]
}GAME_KOCK3_RK_INDEX;


typedef struct _KOCK3_BETS_COUNTS
{
	uint32    betCount;
	uint32    betCountCommit;
}KOCK3_BETS_COUNTS;



typedef struct _GAME_RISK_KOCK3_ISSUE_DATA
{
    money_t                    maxPay;                                   //最大赔付
    money_t                    riskValue;                                //风控阀值
	uint16                     returnRate;                               //返奖率

	money_t                    sub_zxhz_unitWin[16];                     // ZX HZ win: idx = abs(21 - 2 * sum)
	money_t                    sub_unitWin[9];                           // idx = subtype code ,except ZX

	KOCK3_BETS_COUNTS          bets_zx_hz[19];                           // idx = sum
	KOCK3_BETS_COUNTS          bets_3ta;
	KOCK3_BETS_COUNTS          bets_3ts[6];                              // idx = (aaa % 10 - 1)
	KOCK3_BETS_COUNTS          bets_3qa;
	KOCK3_BETS_COUNTS          bets_3ds[6][6][6];                        // idx = [a-1][b-1][c-1]
	KOCK3_BETS_COUNTS          bets_2ta[6];                              // idx = (aa % 10 - 1)
	KOCK3_BETS_COUNTS          bets_2ts[6][6];                           // idx = [aab / 100 - 1] [aab % 10 - 1]
	KOCK3_BETS_COUNTS          bets_2ds[6][6];                           // idx = [a-1] [b-1]

	money_t                    saleMoney;                                // for tf_adder verify
	money_t                    saleMoneyCommit;                          // for tf_reply and tf_updater_db

	money_t                    currMaxWin;                               // for report
	money_t                    currPay;                                  // for report ---

	uint32                     issueSeq;

}GAME_RISK_KOCK3_ISSUE_DATA;



typedef struct _GL_KOCK3_RK_CHKP_ISSUE_DATA
{
	GAME_RISK_KOCK3_ISSUE_DATA rkData[MAX_ISSUE_NUMBER];
}GL_KOCK3_RK_CHKP_ISSUE_DATA;


#pragma pack()


bool gl_kock3_rk_mem_get_meta( int *length);
bool gl_kock3_rk_mem_save( void *buf, int *length);
bool gl_kock3_rk_mem_recovery( void *buf, int length);

bool gl_kock3_sale_rk_verify(TICKET* pTicket);
void gl_kock3_sale_rk_commit(TICKET* pTicket);

void gl_kock3_cancel_rk_rollback(TICKET* pTicket);
void gl_kock3_cancel_rk_commit(TICKET* pTicket);

bool gl_kock3_rk_saveData(const char *filePath);
bool gl_kock3_rk_restoreData(const char *filePath);
void gl_kock3_rk_reinitData(void);

bool gl_kock3_load_memdata(void);

bool isSubTypeBeRiskControl(uint8 gameidx,uint8 subidx);

bool load_kock3_all_issue(char *rk_param);


void rk_clear_issue_betsData(int issue);

bool load_kock3_issue_rkdata(uint32 startIssueNumber,int issue_count, char *rk_param);

bool gl_kock3_rk_getReportData(uint32 issueSeq,void *currMaxPay);

bool gl_kock3_rk_init(void);

#endif





