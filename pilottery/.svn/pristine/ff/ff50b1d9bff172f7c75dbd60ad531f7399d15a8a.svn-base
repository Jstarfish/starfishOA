#ifndef GL_SSC_RK_H_INCLUDED
#define GL_SSC_RK_H_INCLUDED



/*=========================================================================================================
 * 全局常量及值宏定义，并对其进行简要说明
 * Global Constant & Macro Definitions and Brief Description
 =========================================================================================================*/
#define MAX_WINLEVEL 3
#define MAX_BET_TYPE 6
#define RISKNUMBER_STR_LENGTH 200
#define RISKNUMBER_ONE_SUBTYPE 1

#define MAX_FUN_KEY 14

#define SSC_SUBTYPE_COUNT 14

/*=========================================================================================================
 * 类型定义(struct、enum)等,如果是重要数据结构，要详细说明
 * Type Declarations(struct,enum etc.) and Brief Description
 * If it's Significant,Detailed Description Should Be Present
 * 使用类型回归本地常量定义(const)等，如果是重要数据结构，要详细说明
 * Recuve Declare Vars ,If important,Detailed Description is Required.
 =========================================================================================================*/


//风险控制参数
typedef struct _SSC_RISKCTRL_PARAM
{
	uint8 subtype;
	uint32 initLimit;
	money_t unitBetWin;  //单注中奖最大奖金
}SSC_RISKCTRL_PARAM;

// SSC风险控制运营参数表

// 一星
typedef struct _SSC_1STAR
{
    uint16 betCompact;     //紧凑模式betmap
    uint32 betCount;
    uint32 betCountCommit;

    uint32 betCountFirst;    //五星通选对应的前一星投注数
    uint32 betCountFirstCommit;

    uint32 betCountLast;     //五星通选对应的后一星投注数
    uint32 betCountLastCommit;
}SSC_1STAR;

// 二星
typedef struct _SSC_2STAR
{
    uint16 betCompact;     //紧凑模式betmap
    uint16 betNumMap[2];   //分段模式betmap
    uint32 betCount;
    uint32 betCountCommit;

    uint32 betCountPort;      //组选
    uint32 betCountPortCommit;

    uint32 betCountFirst;    //五星通选对应的前二星投注数
    uint32 betCountFirstCommit;

    uint32 betCountLast;     //五星通选对应的后二星投注数
    uint32 betCountLastCommit;

}SSC_2STAR;

// 三星
typedef struct _SSC_3STAR
{
    uint16 betCompact;     //紧凑模式betmap
    uint16 betNumMap[3];   //直选分段模式betmap
    uint16 betNumMapAss3[2]; //组三分段模式
    uint32 betCount;
    uint32 betCountCommit;

    uint32 betCountAss3;      //组三
    uint32 betCountAss3Commit;

    uint32 betCountAss6;      //组六
    uint32 betCountAss6Commit;

    uint32 betCountFirst;    //五星通选对应的前三星投注数
    uint32 betCountFirstCommit;

    uint32 betCountLast;     //五星通选对应的后三星投注数
    uint32 betCountLastCommit;
}SSC_3STAR;

// 五星
typedef struct _SSC_5STAR
{
    uint16 betNumMap[5];   //分段模式betmap
    uint32 betCount;
    uint32 betCountCommit;

    uint32 betCountWhole;        //五星通选
    uint32 betCountWholeCommit;
}SSC_5STAR;

typedef struct _SSC_5STAR_WHOLE_INDEX
{
    uint16  indexFirst3Star[100]; //五星通选对应的前三星地址索引
    uint16  indexLast3Star[100];//五星通选对应的后三星地址索引
    uint8   indexFirst2Star[1000];//五星通选对应的前二星地址索引
    uint8   indexLast2Star[1000];//五星通选对应的后二星地址索引
}SSC_5STAR_WHOLE_INDEX;

// 大小单双
typedef struct _SSC_DXDS
{
    uint8 betRaws;     //原始模式betmap
    uint32 betCount;
    uint32 betCountCommit;
}SSC_DXDS;

//当前销售动态参数表
typedef struct _SALES_DATA
{
    //玩法销售额
    money_t saleMoneyBySubtype;

    //游戏玩法投注
    uint32 currentBetCount;

    //每玩法当前限制量
    uint32 currRestrictBetCount;

    //玩法中最大投注号码的投注数
    uint32 numberMaxBetCount;

    //第一次达到初始限制时的玩法投注数
    uint32 firstBetCount;

    //第一次达到初始限制时的标志
    bool  firstBetFlag;

    //第一次达到初始限制时的号码
    uint16 firstNumberGetLimit;

}SSC_SALES_DATA;

typedef struct _SUB_DIRECT_2STAR
{
	uint8 count;
    int index[100];
}SUB_DIRECT_2STAR;

typedef struct _SUB_PORT_2STAR
{
	uint8 count;
    int index[100];
}SUB_PORT_2STAR;

typedef struct _SUB_DIRECT_3STAR
{
	uint16 count;
    int index[1000];
}SUB_DIRECT_3STAR;

typedef struct _SUB_PORT_3STAR
{
	uint16 count;
    int index[1000];
}SUB_PORT_3STAR;


typedef struct _SUM_DIRECT_2STAR
{
	uint8 count;
    int index[100];
}SUM_DIRECT_2STAR;

typedef struct _SUM_PORT_2STAR
{
	uint8 count;
    int index[100];
}SUM_PORT_2STAR;

typedef struct _SUM_DIRECT_3STAR
{
	uint16 count;
    int index[1000];
}SUM_DIRECT_3STAR;

typedef struct _SUM_PORT_3STAR
{
	uint16 count;
    int index[1000];
    uint16 subCount[3];
}SUM_PORT_3STAR;

typedef struct _BAO1DAN__3STAR
{
	uint16 count;
    int index[1000];
}BAO1DAN_3STAR;

typedef struct _BAO2DAN__3STAR
{
	uint16 count;
    int index[1000];
}BAO2DAN_3STAR;

typedef struct _SSC_SUM_SUB
{
	SUB_DIRECT_2STAR    Sub2StarDirect[10];
	SUB_PORT_2STAR      Sub2StarPort[10];
	SUB_DIRECT_3STAR    Sub3StarDirect[10];
	SUB_PORT_3STAR      Sub3StarPort[10];
	SUM_DIRECT_2STAR    Sum2StarDirect[20];
	SUM_PORT_2STAR      Sum2StarPort[20];
	SUM_DIRECT_3STAR    Sum3StarDirect[28];
	SUM_PORT_3STAR      Sum3StarPort[28];
	BAO1DAN_3STAR       BaoOneDan3Star[10];
	BAO2DAN_3STAR       BaoTwoDan3Star[100];

}SSC_SUM_SUB;

typedef struct _SSC_BET_DATA
{
	SSC_1STAR          ssc1star[10];
	SSC_2STAR          ssc2star[100];
	SSC_3STAR          ssc3star[1000];
	SSC_5STAR          ssc5star[100000];
	SSC_DXDS           sscDxds[16];
}SSC_BET_DATA;


typedef struct _GAME_RISK_SSC_ISSUE_DATA
{
	float                  winPercent;                         //返奖率
	SSC_RISKCTRL_PARAM      riskCtrl[SSC_SUBTYPE_COUNT];
	SSC_SALES_DATA          salesData[SSC_SUBTYPE_COUNT];           // tmp for tf_adder verify
	SSC_SALES_DATA          salesDataCommit[SSC_SUBTYPE_COUNT];     //commit for tf_reply and tf_updater_db
	SSC_BET_DATA            betData;
}GAME_RISK_SSC_ISSUE_DATA;

typedef struct _GAME_RISK_SSC
{

	SSC_SUM_SUB             sumSubIndex;
	SSC_5STAR_WHOLE_INDEX   index5StarWhole[100000];
	int FiveStarNum[10][10][10][10][10];

	GAME_RISK_SSC_ISSUE_DATA *rk_ssc_data;
}GAME_RISK_SSC;

typedef GAME_RISK_SSC* GAME_SSCRISK_PTR;


typedef struct _GL_SSC_RK_CHKP_DATA
{
	uint32 issueSeq;

    uint32 oneStarbetCountCommit[10];
    uint32 oneStarbetCountFirstCommit[10];
    uint32 oneStarbetCountLastCommit[10];

    uint32 twoStarbetCountCommit[100];
    uint32 twoStarbetCountPortCommit[100];
    uint32 twoStarbetCountFirstCommit[100];
    uint32 twoStarbetCountLastCommit[100];

    uint32 threeStarbetCountCommit[1000];
    uint32 threeStarbetCountAss3Commit[1000];
    uint32 threeStarbetCountAss6Commit[1000];
    uint32 threeStarbetCountFirstCommit[1000];
    uint32 threeStarbetCountLastCommit[1000];

    uint32 fiveStarbetCountCommit[10000];
    uint32 fiveStarbetCountWholeCommit[10000];

    uint32 DXDSbetCountCommit[16];

    SSC_SALES_DATA  salesDataCommit[SSC_SUBTYPE_COUNT];


}GL_SSC_RK_CHKP_DATA;

typedef struct _GL_SSC_RK_CHKP_ISSUE_DATA
{
	GL_SSC_RK_CHKP_DATA rkData[MAX_ISSUE_NUMBER];
}GL_SSC_RK_CHKP_ISSUE_DATA;


#pragma pack()


bool gl_ssc_rk_mem_get_meta( int *length);
bool gl_ssc_rk_mem_save( void *buf, int *length);
bool gl_ssc_rk_mem_recovery( void *buf, int length);

bool gl_ssc_sale_rk_verify(TICKET* pTicket);
void gl_ssc_sale_rk_commit(TICKET* pTicket);

void gl_ssc_cancel_rk_rollback(TICKET* pTicket);
void gl_ssc_cancel_rk_commit(TICKET* pTicket);

bool gl_ssc_rk_saveData(const char *filePath);
bool gl_ssc_rk_restoreData(const char *filePath);
void gl_ssc_rk_reinitData(void);

bool gl_ssc_load_memdata(void);

bool isSubTypeBeRiskControl(uint8 gameidx,uint8 subidx);

bool load_ssc_all_issue(char *rk_param);
bool gl_ssc_rk_init();

void rk_clear_issue_betsData(int issue);

bool load_ssc_issue_rkdata(uint32 startIssueNumber,int issue_count, char *rk_param);

void rk_initVerifyFun(void);

bool gl_ssc_rk_getReportData(uint32 issueSeq,void *data);

#endif





