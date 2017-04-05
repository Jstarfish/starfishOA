#ifndef OTL_INF_H_INCLUDED
#define OTL_INF_H_INCLUDED


typedef enum
{
    FLUSH_SALE = 1 ,
    FLUSH_SALE_IF,
    FLUSH_SALE_DETAIL,
    FLUSH_SALE_DETAIL_IF,
    FLUSH_PAY,
    FLUSH_PAY_IF,
    FLUSH_CANCEL,
    FLUSH_CANCEL_IF,
    FLUSH_WIN,
    FLUSH_WIN_DETAIL,
    FLUSH_SALE_3D
}SQL_FLUSH_TYPE;

typedef struct _DB_RNG {
	bool   used;
	uint32 rngId;
    uint8  workStatus; //0=未连接  1=已连接 2=正常工作
}DB_RNG;

typedef struct _DB_TSN {
    bool   used;
    char   reqfn_ticket[TSN_LENGTH];
    uint8  tsn[TSN_LENGTH]; //0=未连接  1=已连接 2=正常工作
}DB_TSN;

typedef struct _DB_STAT {
	DB_RNG    db_rng[MAX_RNG_NUMBER];
    DB_TSN    db_tsn[5000];
	int rngCnt;
    int tsnCnt;
} DB_STAT;

typedef struct _DB_ISSUE_POLICY {
    bool isValid;
    int publishTime;
    int adjustmentFundRate;
    int returnRate;
    int payEndDay;
}DB_ISSUE_POLICY;


#define PERFECT_SQL_BATCH       (2618)

// use for Oms DataBase -------------------------------------------------------------------------
bool otl_connectDB(char * username,char * passwd,char * servicename,int min);
void otl_disConnectDB(void);

bool otl_cleanOmsCommLog(); //系统启动时，清除OMS通信日志标记


//日结调用接口
bool otl_switch_session_oms(uint32 date);

//data load -----------------------------------------------------------------------------------
int otl_getGameList(GAME_LIST *game_list);

int otl_getRngList(RNG_LIST *rng_list);

int otl_getGameNewIssueList(uint8 game_code, ISSUE_NEWCFG_LIST *issue_list, int issueCount,uint32 seq); //gl_driver调用，线程安全版
int otl_getGameOldIssueList(uint8 game_code, ISSUE_OLDCFG_LIST *issue_list, int issueCount);

bool otl_delIssue(int gameCode, uint64 issueNumber); //gl_driver调用，线程安全版

int otl_getIssuePrizeInfo(uint8 gameCode,uint64 issue,PRIZE_PARAM_ISSUE prize[]);  //调用着提供prize空间，返回值为奖级个数,小于0为错

bool otl_getIssueRKInfo(uint8 game_code,uint64 issue,char *buf);


//terminal --------------------------------------------------------------------------------------
bool otl_insert_T_sellTickets(char *buf, int count);
bool otl_insert_T_sellTickets_if(char *buf, int count);
bool otl_insert_T_cancelTicket(char *buf, int count);
bool otl_insert_T_cancelTicket_if(char *buf, int count);
bool otl_insert_T_payTicket(char *buf, int count);
bool otl_insert_T_payTicket_if(char *buf, int count);

bool otl_setRngStatus(DB_RNG data[], int count);

bool otl_data_commit_omDB(DB_STAT *data);


//OMS --------------------------------------------------------------------------------------------

bool otl_insert_OMS_cancelTicket(char *buf, int count);
bool otl_insert_OMS_cancelTicket_if(char *buf, int count);
bool otl_insert_OMS_payTicket(char *buf, int count);
bool otl_insert_OMS_payTicket_if(char *buf, int count);

// game issue -----------------------------------------------------------------------------------
bool  otl_set_issueMatchStr(uint8 game_code, uint64 issue_num, char *matchStr);
bool otl_set_issue_status(uint8 game_code, uint64 issue_num, int32 issue_status,int32 real_time);
//bool otl_set_issue_real_time(uint8 game_code, uint64 issue_num, int32 real_time, int issue_status);
bool otl_set_issue_process_error(uint8 game_code, uint64 issue_num);
bool otl_set_issue_ticket_stat(uint8 game_code, uint64 issue_num, TICKET_STAT *ts);
bool otl_get_issue_pool(uint8 game_code, POOL_AMOUNT *pool);
bool otl_set_issue_pool(uint8 game_code, uint64 issue_num, GL_PRIZE_CALC *przCalc);
bool otl_set_issue_calc_results(uint8 game_code, uint64 issue_num, int flag,char *filename);
bool otl_set_issue_winning_stat(uint8 game_code, uint64 issue_num, WIN_TICKET_STAT *t);

bool otl_send_issue_winfile(uint8 game_code, uint64 issue_number,char * winFile);

bool otl_set_drawNotice_xml(uint8 game_code,uint64 issueNum);
bool otl_get_drawNotice_xml(uint8 gameCode,uint64 issueNumber, char *filepath);

bool otl_get_issue_info(uint8 game_code, uint64 issue_num, GIDB_ISSUE_INFO *issue_info);
bool otl_get_issue_info2(uint8 game_code, uint32 issue_serial, GIDB_ISSUE_INFO *issue_info);

bool otl_set_issue_rk_stat(uint8 game_code, uint64 issue_num, money_t ticketAmount,uint32 ticketCount);

bool otl_insertNotifyEvent(const char *host_ip,int type,uint8 level,char * msg,uint32 time);

bool otl_set_drawNotice_tds(uint8 game_code, uint64 issue_num);


/************************* pil **************************************************************/

bool otl_set_issue_status(uint8 game_code, uint64 issue_num, int32 issue_status, int32 real_time);
int otl_json_sp_pil(int type,char * req, char *rsp);

bool otl_ap_pay_over(int game_code, uint64 issue_num);

/************************* fbs ***************************************************************/
//bool otl_fbs_getCompetition(int *count, DB_FBS_COMPETITION *comp);
//bool otl_fbs_getTeam(int *count, DB_FBS_TEAM *team);

bool otl_fbs_getIssueWhenStart(uint8 gameCode,int *count, DB_FBS_ISSUE *issue);

int otl_fbs_getOneNewIssue(uint8 gameCode,uint32 maxissue, DB_FBS_ISSUE *buf);
bool otl_fbs_getMatchByIssue(uint8 gameCode,uint32 issuenum, int *count, DB_FBS_MATCH *buf);
bool otl_fbs_getAllMatchsByIssue(uint8 gameCode, uint32 issuenum, int *count, DB_FBS_MATCH *fbsm);
bool otl_get_allMatchesByOneMatch(uint8 gameCode, uint32 match_code, DB_FBS_MATCH *arrMatch, int *count);
bool otl_fbs_getMatchOdds(uint8 gameCode,uint32 matchCode, int *count, DB_FBS_ODDS *buf);

bool otl_fbs_update_match_result(uint8 gameCode,uint32 issue, uint32 match, char * result);

bool otl_getFbsIssuePolicy(uint8 gameCode, uint32 issue, DB_ISSUE_POLICY *pol);

// FBS ---------------------
//更新比赛开奖过程的错误
bool otl_fbs_set_match_process_error(uint8 game_code, uint32 issue_num, uint32 match_code);
//更新比赛的状态
bool otl_fbs_set_match_state(uint8 gameCode, uint32 match_code, uint8 state);
//更新比赛的算奖结果
bool otl_fbs_set_match_draw_result(uint8 gameCode, uint32 match_code, SUB_RESULT s_results[]);
//获取指定比赛的信息
bool otl_fbs_get_match_info(uint8 game_code, uint32 match_code, GIDB_FBS_MATCH_INFO *match_info);

#endif	//OTL_INF_H_INCLUDED

