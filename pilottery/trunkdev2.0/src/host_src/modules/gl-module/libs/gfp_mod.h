#ifndef __GL_GAME_FLOW_PROCESS_H_
#define __GL_GAME_FLOW_PROCESS_H_


struct _GAME_FLOW_PROCESSOR;
typedef struct _GAME_FLOW_PROCESSOR GAME_FLOW_PROCESSOR;
struct _GAME_FLOW_PROCESSOR
{
           uint8 init; // 0 not init, 1 inited
        uint8 game_code;
        GAME_PLUGIN_INTERFACE *plugin_handle;

        int32 (*issue_sealed)(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf);
        int32 (*issue_drawnum_inputed)(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf);
        int32 (*issue_matched)(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf, POOL_AMOUNT *pool);
        int32 (*issue_fund_inputed)(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf);
        int32 (*issue_local_calced)(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf);
        int32 (*issue_prize_adjusted)(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf);
        int32 (*issue_prize_confirmed)(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf);
        int32 (*issue_db_imported)(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf);
        int32 (*issue_end)(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf);

        int32 (*do_issue_draw_redo)(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf);
        int32 (*do_verify_salefile_md5sum)(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf);

        char *data;
};

GAME_FLOW_PROCESSOR *gfp_get_handle(uint8 game_code);
int32 gfp_close_handle(uint8 game_code);

//发送期次状态改变的INM消息
int send_issue_status_message(uint8 game_code, uint64 issue_number, INM_MSG_TYPE msg_type, uint8 draw_times);
int send_issue_status_message2(uint8 game_code, uint64 issue_number, INM_MSG_TYPE msg_type, char *msg, int32 msglen);


//发送期次状态改变的notify消息
int send_issue_status_notify(uint8 game_code, uint64 issue_num, uint8 issue_status);

void send_rkNotify(uint8 gameCode,uint64 issue,uint8 subtype, char *betString);


typedef struct _DB_ERROR
{
    uint8 game_code;
    uint64 issue_num;
    uint8 issue_status;
    uint8 draw_times;
} DB_ERROR;
int set_issue_process_error(DB_ERROR *error_buf);


//------内部接口-----------------------------

//--------------------------------------------------------------------------------------
//以下这部分结构体的作用，用于在match时，统计相关的期次信息 及 销售站的 高等奖中奖统计

typedef struct _ANNOUNCE_XML_EL {
	XMLElement *game_draw;
	XMLElement *game_code;
	XMLElement *issue_number;
	XMLElement *draw_result;
	XMLElement *sale_total_amount;
	XMLElement *prize_total_amount;
	XMLElement *pool_amount;
	XMLElement *pool_left_amount;

	//prizeS
	XMLElement *prizes;
	//many
	XMLElement *prize[MAX_PRIZE_COUNT];
	XMLElement *prize_level[MAX_PRIZE_COUNT];
	XMLElement *is_high_prize[MAX_PRIZE_COUNT];
	XMLElement *prize_num[MAX_PRIZE_COUNT];
	XMLElement *prize_amount[MAX_PRIZE_COUNT];
	XMLElement *prize_after_tax_amount[MAX_PRIZE_COUNT];
	XMLElement *prize_tax_amount[MAX_PRIZE_COUNT];


	//high prizeS
	XMLElement *high_prizes_2;
	//many
	XMLElement *high_prize_2[MAX_PRIZE_COUNT];
	XMLElement *prize_level_2[MAX_PRIZE_COUNT];
	XMLElement *locations_2[MAX_PRIZE_COUNT];
	XMLElement *location_2[MAX_PRIZE_COUNT][MAX_AGENCY_NUMBER];
	XMLElement *agency_code_2[MAX_PRIZE_COUNT][MAX_AGENCY_NUMBER];
	XMLElement *count_2[MAX_PRIZE_COUNT][MAX_AGENCY_NUMBER];

} ANNOUNCE_XML_EL;


//得到winner.local winner.confirm 文件路径
int get_game_issue_winner_filepath(char *filepath, uint8 game_code, uint64 issue_number, uint8 draw_times, uint8 flag);
//save匹配时的高等奖统计信息(销售站)
int32 save_high_prize_info_tmp(uint8 game_code, uint64 issue_number, uint8 draw_times, ANNOUNCE_HIGH_PRIZE *aHighPrize);
//get 匹配时的高等奖统计信息(销售站)
int32 get_high_prize_info_tmp(uint8 game_code, uint64 issue_number, uint8 draw_times, ANNOUNCE_HIGH_PRIZE *aHighPrize);
//生成 ANNOUNCE_DATA 数据         flag  WINNER_LOCAL_FILE = local   WINNER_CONFIRM_FILE = confirm
int32 generate_issue_winner_data(uint8 game_code, uint64 issue_number, uint8 draw_times, uint8 flag, ANNOUNCE_DATA* pData);
//根据 ANNOUNCE_DATA 数据，生成XML文件 < winner_local   or   winner_confirm >
int32 create_winner_file(uint8 game_code, uint64 issue_number, uint8 draw_times, uint8 flag, ANNOUNCE_DATA* pData);

//将 winner 文件的内容字符串写入期次开奖过程表
int32 save_winner_file_for_gidb(uint8 game_code, uint64 issue_number, uint8 draw_times, uint8 flag);
//开奖公告写入期次开奖过程表
int32 save_drawannounce_file_for_gidb(uint8 game_code, uint64 issue_number, uint8 draw_times, char *file);

//--------------------------------------------------------------------------------------
//以下这部分结构体的作用，用于统计销售站每期的中奖情况

typedef struct _PRIZE_INFO {
	uint8   prizeCode; //LEVEL
	char    name[ENTRY_NAME_LEN];
	uint8   hflag;
	uint32  count;
	money_t amountSingle;//单注金额
} PRIZE_INFO;


//销售站中奖情况信息
typedef struct _WINNER_INFO {
	uint64 agencyCode;
	uint32 game_code;
	uint64 issueNum;
	uint32 drawTicketCnt;
	uint8 prizeCount;
	PRIZE_INFO prize[MAX_PRIZE_COUNT];
} WINNER_INFO;

typedef struct _WINNER_DATABASE {
	uint32 agencyCount;
	WINNER_INFO agency[MAX_AGENCY_NUMBER];
} WINNER_DATABASE;

#if 0
char *create_winner_memory(void);
void destroy_winner_memory(char *ptr);

WINNER_DATABASE* getWinnerPtr(void);
//统计销售站各游戏中奖情况
int32 set_winner_db(GIDB_WIN_TICKET_REC *winning_ticket, uint64 issue_num, PRIZE_PARAM *prize_ptr);
//销售站中奖统计保存成文件
int32 save_winner_file(uint8 draw_times, char *agencyFile, char apFile[MAX_AP_NUMBER][256]);
#endif




#endif //__GL_GAME_FLOW_PROCESS_H_

