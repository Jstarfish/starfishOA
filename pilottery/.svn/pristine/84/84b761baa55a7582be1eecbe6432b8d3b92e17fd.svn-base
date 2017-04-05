#ifndef GL_FOOTBALL_DB_H__
#define GL_FOOTBALL_DB_H__


/*=========================================================================================================
 * 函数性宏定义，并对其进行简要说明
 * Functional Macro Definitions and Brief Description
 =========================================================================================================*/
#pragma pack(1)

typedef struct _FBS_DATABASE
{
    FBS_SUBTYPE_PARAM subtype_params[FBS_SUBTYPE_NUM];
    FBS_ISSUE issue_array[FBS_MAX_ISSUE_NUM]; //期次信息列表
}FBS_DATABASE;
typedef FBS_DATABASE* FBS_DATABASE_PTR;

#pragma pack()

//function

bool gl_fbs_mem_creat(int issue_count);
bool gl_fbs_mem_destroy();
bool gl_fbs_mem_attach();
bool gl_fbs_mem_detach();
void *gl_fbs_get_mem_db(void);

bool gl_fbs_load_memdata(void);
int gl_fbs_update_configuration(char *config_string);


int gl_fbs_getSingleAmount(char *buffer, size_t len);

FBS_SUBTYPE_PARAM* gl_fbs_get_subtypeParam(uint32 subtype);
const char *FbsResultString(uint8 subtype, uint8 result_enum);


int gl_fbs_load_issue(int n, DB_FBS_ISSUE *issue_list);
FBS_ISSUE* gl_fbs_get_issue(uint32 issue_number);
int gl_fbs_del_issue(uint32 issue_number);
FBS_MATCH* gl_fbs_get_match(uint32 issue_number, uint32 match_code);
FBS_MATCH* gl_fbs_get_match_by_match_code(uint32 match_code);

int gl_fbs_del_match(uint32 match_code);
//reply计算实时参考SP值
int gl_fbs_calc_rt_odds(FBS_TICKET *ticket);


//更新内存match 最终结果信息
// uint8 match_result[]  //比赛结果,数据格式定义参见  GLTP_MSG_O_FBS_DRAW_INPUT_RESULT_REQ的结构定义
int gl_fbs_update_match_result(uint32 issue_number, uint32 match_code, SUB_RESULT s_results[], uint8 match_result[]);

POOL_PARAM *gl_fbs_getPoolParam(void);
void *gl_fbs_getSubtypeTable(int *len);
ISSUE_INFO *gl_fbs_get_currIssue(void);
int get_fbs_issueMaxCount(void);
int get_fbs_issueMaxCount(void);
ISSUE_INFO *gl_fbs_getIssueTable(void);
FBS_ISSUE *gl_fbs_get_issueInfo(uint32 issue_number);

uint32 gl_fbs_get_issueMaxSeq(void);


int gl_fbs_load_match(int n, uint32 issue_number, DB_FBS_MATCH *match_list);
int gl_fbs_load_newMatch(void);
FBS_ISSUE* gl_fbs_get_issueTable(void);
uint32 gl_fbs_get_minIssue(void);

int gl_fbs_format_ticket(const char* buf, FBS_TICKET *ticket);
int gl_fbs_split_order(FBS_TICKET *ticket);
int gl_fbs_ticket_verify(const FBS_TICKET* ticket, uint32 *outDate);//返回最后一场比赛的关闭日期(即开奖日期)
int gl_fbs_getBetCount(uint8 betType, uint8 matchCount, unsigned char *matchBetOption);
//计算各玩法各赛果的销售情况，上传DB，OMS监控使用
int gl_fbs_sale_calc(uint32 issue_number, uint32 match_code, char *outBuf);




int gl_fbs_sale_rk_verify(FBS_TICKET* ticket);
int gl_fbs_sale_rk_commit(FBS_TICKET* ticket);
int gl_fbs_cancel_rk_rollback(FBS_TICKET* ticket);
int gl_fbs_cancel_rk_commit(FBS_TICKET* ticket);

bool gl_fbs_chkp_saveData(const char *filePath);
bool gl_fbs_chkp_restoreData(const char *filePath);





#endif

