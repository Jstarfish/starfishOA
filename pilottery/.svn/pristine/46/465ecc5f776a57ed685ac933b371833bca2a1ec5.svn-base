#include "global.h"
#include "tfe_inf.h"
#include "gl_inf.h"
#include "otl_inf.h"

#define MY_TASK_NAME "tfe_scan\0"

timer_t  tfeScanTimer;

// variables define
static volatile int exit_signal_fired = 0;
static volatile int timer_fired = 0;

FID ncpc_fid;

GAME_PLUGIN_INTERFACE *game_plugins_handle = NULL;


//tfe_scan 调用
int32 process_issue_presale(INM_MSG_HEADER *inm_buf)
{
    int ret = 0;
    INM_MSG_ISSUE_PRESALE *state_rec_ptr = (INM_MSG_ISSUE_PRESALE *)inm_buf;
    uint8 game_code = state_rec_ptr->gameCode;
    uint64 issue_number = state_rec_ptr->issueNumber;
    uint8 issue_status = ISSUE_STATE_PRESALE;

    log_info("Enter Issue Process [%d - %lld  %s]---> tf_file_id[%u] tf_offset[%u]",
        game_code, issue_number, ISSUE_STATE_STR(issue_status), state_rec_ptr->header.tfe_file_idx, state_rec_ptr->header.tfe_offset);

    if (sysdb_getSysStatus() != SYS_STATUS_BUSINESS)
    {
        //故障恢复过程，需要判断此记录是否已处理过,如果处理过则直接返回
        //从数据库中查询期次状态，根据期次状态判断
        GIDB_ISSUE_INFO issue_info;
        memset(&issue_info, 0, sizeof(GIDB_ISSUE_INFO));
        if (!otl_get_issue_info(game_code, issue_number, &issue_info))
        {
            log_error("otl_get_issue_info() error. game[%d] issue_number[%lld]", game_code, issue_number);
            return -1;
        }
        if (issue_info.status >= issue_status)
        {
            log_debug("Game[%d] Issue[%lld] Status[%s] has already processed. --- SKIP ---", game_code, issue_number, ISSUE_STATE_STR(issue_status));
            return 0;
        }
    }

    //保存期次开奖所需要的数据
    GIDB_T_TICKET_HANDLE *t_handle = gidb_t_get_handle(game_code, issue_number);
    if (t_handle == NULL)
    {
        log_error("gidb_t_get_handle(%d, %lld) failure", game_code, issue_number);
        return -1;
    }
    //游戏数据
    GT_GAME_PARAM game_param;
    memset(&game_param, 0, sizeof(GT_GAME_PARAM));
    GAME_DATA *game_ptr = gl_getGameData(game_code);
    game_param.gameCode = game_ptr->gameEntry.gameCode;
    game_param.gameType = game_ptr->gameEntry.gameType;
    memcpy(game_param.gameAbbr, game_ptr->gameEntry.gameAbbr, 15);
    memcpy(game_param.gameName, game_ptr->gameEntry.gameName, MAX_GAME_NAME_LENGTH);
    memcpy(game_param.organizationName, game_ptr->gameEntry.organizationName, MAX_ORGANIZATION_NAME_LENGTH);
    game_param.publicFundRate = game_ptr->policyParam.publicFundRate;
    game_param.adjustmentFundRate = game_ptr->policyParam.adjustmentFundRate;
    game_param.returnRate = game_ptr->policyParam.returnRate;
    game_param.taxStartAmount = game_ptr->policyParam.taxStartAmount;
    game_param.taxRate = game_ptr->policyParam.taxRate;
    game_param.payEndDay = game_ptr->policyParam.payEndDay;
    game_param.drawType = game_ptr->transctrlParam.drawType;
    game_param.bigPrize = game_ptr->transctrlParam.bigPrize;
    ret = t_handle->gidb_t_set_field_blob(t_handle, T_GAME_PARAMBLOB_KEY, (char*)&game_param, sizeof(GT_GAME_PARAM));
    if (ret != 0)
    {
        log_error("gidb_t_set_field_blob(%d, %lld, T_GAME_PARAMBLOB_KEY) failure.", game_code, issue_number);
        return -1;
    }
    //玩法数据
    int32 len = 0;
    char *subtype_param = (char *)(game_plugins_handle[game_code].get_subtypeTable(&len));
    if (subtype_param == NULL)
    {
        log_error("get_subtypeTable(%d, %lld) failure.", game_code, issue_number);
        return -1;
    }
    ret = t_handle->gidb_t_set_field_blob(t_handle, T_SUBTYPE_PARAMBLOB_KEY, subtype_param, len);
    if (ret != 0)
    {
        log_error("gidb_t_set_field_blob(%d, %lld, T_SUBTYPE_PARAMBLOB_KEY) failure.", game_code, issue_number);
        return -1;
    }
    //匹配规则数据
    char *division_param = (char *)(game_plugins_handle[game_code].get_divisionTable(&len,issue_number));
    if (division_param == NULL)
    {
        log_error("get_divisionTable(%d, %lld) failure.", game_code, issue_number);
        return -1;
    }
    ret = t_handle->gidb_t_set_field_blob(t_handle, T_DIVISION_PARAMBLOB_KEY, division_param, len);
    if (ret != 0)
    {
        log_error("gidb_t_set_field_blob(%d, %lld, T_DIVISION_PARAMBLOB_KEY) failure.", game_code, issue_number);
        return -1;
    }
    //奖级表数据
    PRIZE_PARAM_ISSUE prize[MAX_PRIZE_COUNT];
    memset((void *)prize , 0, sizeof(prize));
    if(otl_getIssuePrizeInfo(game_code, issue_number, prize) < 0)
    {
        log_error("otl_getIssuePrizeInfo( gameCode[%d] issue[%lld]) failure.", game_code, issue_number);
        return false;
    }

    PRIZE_PARAM *prize_param = game_plugins_handle[game_code].get_prizeTable(0);
    if (prize_param == NULL)
    {
        log_error("get_prizeTable(%d, %lld) failure.", game_code, issue_number);
        return -1;
    }

    //更新共享内存奖等奖金
    for (int i = 0; i < MAX_PRIZE_COUNT; i++)
    {
    	for (int j = 0; j < MAX_PRIZE_COUNT; j++)
    	{
    		if (prize[j].prizeCode == prize_param[i].prizeCode)
			{
				prize_param[i].fixedPrizeAmount = prize[j].prizeAmount;
				break;
			}
    	}
    }

    //奖级奖金存入sqlite数据库
    GT_PRIZE_PARAM gt_prize_param;
    memcpy(gt_prize_param.prize_param, prize_param, sizeof(PRIZE_PARAM)*MAX_PRIZE_COUNT);
    memset(&gt_prize_param.calc_struct, 0, sizeof(gt_prize_param.calc_struct));
    //解析算奖配置参数字符串，将解析出的结构体放入calc_struct字段中
    if(game_plugins_handle[game_code].resolve_winConfigString != NULL)
    {
        game_plugins_handle[game_code].resolve_winConfigString(issue_number, &gt_prize_param.calc_struct);
    }

    ret = t_handle->gidb_t_set_field_blob(t_handle, T_PRIZE_PARAMBLOB_KEY, (char*)&gt_prize_param, sizeof(GT_PRIZE_PARAM));
    if (ret != 0)
    {
        log_error("gidb_t_set_field_blob(%d, %lld, T_PRIZE_PARAMBLOB_KEY) failure.", game_code, issue_number);
        return -1;
    }
    //奖池数据
    POOL_PARAM *pool_param = game_plugins_handle[game_code].get_poolParam();
    if (pool_param == NULL)
    {
        log_error("get_poolParam(%d, %lld) failure.", game_code, issue_number);
        return -1;
    }
    ret = t_handle->gidb_t_set_field_blob(t_handle, T_POOL_PARAMBLOB_KEY, (char*)pool_param, sizeof(POOL_PARAM));
    if (ret != 0)
    {
        log_error("gidb_t_set_field_blob(%d, %lld, T_POOL_PARAMBLOB_KEY) failure.", game_code, issue_number);
        return -1;
    }

    //更新数据库期次状态
    time_t t = time(NULL);
    if (!otl_set_issue_status(game_code, issue_number, issue_status, t))
    {
        log_error("otl_set_issue_status(game_code[%u] issue_number[%llu] issue_status[%s] ) failed.", game_code, issue_number, ISSUE_STATE_STR(issue_status));
        return -1;
    }

    if (sysdb_getSysStatus() == SYS_STATUS_BUSINESS)
    {
		ISSUE_INFO *issue_ptr = game_plugins_handle[state_rec_ptr->gameCode].get_issueInfo(state_rec_ptr->issueNumber);
		if (NULL==issue_ptr)
		{
			log_error("game plugin get_issueInfo(game_code[%u], issue_number[%lld]) return NULL.",
					state_rec_ptr->gameCode, state_rec_ptr->issueNumber);
			return -1;
		}
		issue_ptr->curState = ISSUE_STATE_PRESALE;
    }

    //本地内存CACHE插入新期
    GIDB_ISSUE_HANDLE *i_handle = gidb_i_get_handle(game_code);
    if (i_handle == NULL)
    {
        log_error("");
        return -1;
    }
    static char buffer[4*1024];
    GIDB_ISSUE_INFO *is_info = (GIDB_ISSUE_INFO *)buffer;
    memset(is_info, 0, sizeof(GIDB_ISSUE_INFO));
    is_info->gameCode = game_code;
    is_info->issueNumber = issue_number;
    is_info->serialNumber = state_rec_ptr->serialNumber;
    is_info->status = issue_status;
    is_info->estimate_start_time = state_rec_ptr->startTime;
    is_info->estimate_close_time = state_rec_ptr->closeTime;
    is_info->estimate_draw_time = state_rec_ptr->awardTime;
    is_info->payEndDay = state_rec_ptr->payEndDay;
    ret = i_handle->gidb_i_insert(i_handle, is_info);
    if (ret != 0)
    {
        log_error("gidb_i_insert(%d %lld) failure", game_code, issue_number);
        return -1;
    }

    //notify
    send_issue_status_notify( game_code, issue_number, issue_status);

    log_info("Exit Issue Process [%d - %lld  %s]--->", game_code, issue_number, ISSUE_STATE_STR(issue_status));
    return 0;
}

int32 process_issue_open(INM_MSG_HEADER *inm_buf)
{
    int ret = 0;
    INM_MSG_ISSUE_OPEN *state_rec_ptr = (INM_MSG_ISSUE_OPEN *)inm_buf;
    uint8 game_code = state_rec_ptr->gameCode;
    uint64 issue_number = state_rec_ptr->issueNumber;
    uint8 issue_status = ISSUE_STATE_OPENED;

    log_info("Enter Issue Process [%d - %lld  %s]---> tf_file_id[%u] tf_offset[%u]",
        game_code, issue_number, ISSUE_STATE_STR(issue_status), state_rec_ptr->header.tfe_file_idx, state_rec_ptr->header.tfe_offset);

    if (sysdb_getSysStatus() != SYS_STATUS_BUSINESS)
    {
        //故障恢复过程，需要判断此记录是否已处理过,如果处理过则直接返回
        //从数据库中查询期次状态，根据期次状态判断
        GIDB_ISSUE_INFO issue_info;
        memset(&issue_info, 0, sizeof(GIDB_ISSUE_INFO));
        if (!otl_get_issue_info(game_code, issue_number, &issue_info))
        {
            log_error("otl_get_issue_info() error. game[%d] issue_number[%lld]", game_code, issue_number);
            return -1;
        }
        if (issue_info.status >= issue_status)
        {
            log_debug("Game[%d] Issue[%lld] Status[%s] has already processed. --- SKIP ---", game_code, issue_number, ISSUE_STATE_STR(issue_status));
            return 0;
        }
    }

    //更新数据库期次状态
    time_t t = time(NULL);
    if (!otl_set_issue_status(game_code, issue_number, issue_status, t))
    {
        log_error("otl_set_issue_status(game_code[%u] issue_number[%llu] issue_status[%s] ) failed.", game_code, issue_number, ISSUE_STATE_STR(issue_status));
        return -1;
    }

    //更新内存期次状态，发送广播消息
    if (SYS_STATUS_BUSINESS == sysdb_getSysStatus())
    {
		ISSUE_INFO *issue_ptr = game_plugins_handle[state_rec_ptr->gameCode].get_issueInfo(state_rec_ptr->issueNumber);
		if (NULL==issue_ptr)
		{
			log_warn("game plugin get_issueInfo(game_code[%u], issue_number[%lld]) return NULL.", state_rec_ptr->gameCode, state_rec_ptr->issueNumber);
		}
		else
		{
			//update memory issue state
			issue_ptr->curState = ISSUE_STATE_OPENED;

            TRANSCTRL_PARAM * trans = gl_getTransctrlParam(state_rec_ptr->gameCode);

			//构造广播消息发送
			static INM_MSG_T_OPEN_GAME_UNS inm_msg;
			memset(&inm_msg, 0, sizeof(INM_MSG_T_OPEN_GAME_UNS));
			inm_msg.header.inm_header.type = INM_TYPE_T_OPEN_GAME_UNS;
			inm_msg.header.inm_header.gltp_type = GLTP_MSG_TYPE_TERMINAL_UNS;
			inm_msg.header.inm_header.gltp_func = GLTP_T_UNS_OPEN_GAME;
			inm_msg.header.inm_header.status = SYS_RESULT_SUCCESS;
			inm_msg.header.inm_header.when = get_now();
			inm_msg.gameCode = state_rec_ptr->gameCode;
			inm_msg.issueNumber = state_rec_ptr->issueNumber;
			inm_msg.issueTimeStamp = state_rec_ptr->startTime;
			inm_msg.issueTimeSpan = state_rec_ptr->issueTimeSpan;
			inm_msg.countDownSeconds = trans->countDownTimes;
			inm_msg.header.inm_header.length = sizeof(INM_MSG_T_OPEN_GAME_UNS);

			ret = bq_send(ncpc_fid, (char*)&inm_msg, *(uint16*)&inm_msg);
			if (ret <= 0)
			{
				log_error("tfe_scan send data to bqueues failure! ");
			}
		}
    }

    //更新本地内存CACHE中的期次状态
    GIDB_ISSUE_HANDLE *i_handle = gidb_i_get_handle(game_code);
    if (i_handle == NULL)
    {
    	log_error("gidb_i_get_handle fail,game[%d]", game_code);
        return -1;
    }
    ret = i_handle->gidb_i_set_status(i_handle, issue_number, issue_status, t);
    if (ret != 0)
    {
        log_error("gidb_i_set_status(%d, %lld, %s) error", game_code, issue_number, ISSUE_STATE_STR(issue_status));
        return -1;
    }

    //notify
    send_issue_status_notify( game_code, issue_number, issue_status);

    log_info("Exit Issue Process [%d - %lld  %s]--->", game_code, issue_number, ISSUE_STATE_STR(issue_status));
    return 0;
}

/*
int32 process_issue_closing(INM_MSG_HEADER *inm_buf)
{
    int ret = 0;

    INM_MSG_ISSUE_CLOSING *state_rec_ptr = (INM_MSG_ISSUE_CLOSING *)inm_buf;
    uint8 game_code = state_rec_ptr->gameCode;
    uint64 issue_number = state_rec_ptr->issueNumber;
    int32 issue_status = ISSUE_STATE_CLOSING;

    log_info("Enter Issue Process [%d - %lld  %s]---> tf_file_id[%u] tf_offset[%u]",
        game_code, issue_number, ISSUE_STATE_STR(issue_status), state_rec_ptr->header.tfe_file_idx, state_rec_ptr->header.tfe_offset);

    if (sysdb_getSysStatus() != SYS_STATUS_BUSINESS)
    {
        //故障恢复过程，需要判断此记录是否已处理过,如果处理过则直接返回
        //从数据库中查询期次状态，根据期次状态判断
        GIDB_ISSUE_INFO issue_info;
        memset(&issue_info, 0, sizeof(GIDB_ISSUE_INFO));
        if (!otl_get_issue_info(game_code, issue_number, &issue_info))
        {
            log_error("otl_get_issue_info() error. game[%d] issue_number[%lld]", game_code, issue_number);
            return -1;
        }
        if (issue_info.status >= issue_status)
        {
            log_debug("Game[%d] Issue[%lld] Status[%s] has already processed. --- SKIP ---", game_code, issue_number, ISSUE_STATE_STR(issue_status));
            return 0;
        }
    }

    //更新数据库期次状态
    time_t t = time(NULL);
    if (!otl_set_issue_status(game_code, issue_number, issue_status, t))
    {
        log_error("otl_set_issue_status(game_code[%u] issue_number[%llu] issue_status[%s] ) failed.", game_code, issue_number, ISSUE_STATE_STR(issue_status));
        return -1;
    }

    //更新内存期次状态，发送广播消息
	if (SYS_STATUS_BUSINESS == sysdb_getSysStatus())
    {
		ISSUE_INFO *issue_ptr = game_plugins_handle[state_rec_ptr->gameCode].get_issueInfo(state_rec_ptr->issueNumber);
		if (NULL==issue_ptr)
		{
			log_warn("game plugin get_issueInfo(game_code[%u], issue_number[%lld]) return NULL.",
					state_rec_ptr->gameCode, state_rec_ptr->issueNumber);
		}
		else
		{
			issue_ptr->curState = ISSUE_STATE_CLOSING;

			//构造广播消息发送
			static INM_MSG_T_CLOSE_SECONDS_UNS inm_msg;
			memset(&inm_msg, 0, sizeof(INM_MSG_T_CLOSE_SECONDS_UNS));
			inm_msg.header.inm_header.type = INM_TYPE_T_CLOSE_SECONDS_UNS;
			inm_msg.header.inm_header.gltp_type = GLTP_MSG_TYPE_TERMINAL_UNS;
			inm_msg.header.inm_header.gltp_func = GLTP_T_UNS_CLOSE_SECONDS;
			inm_msg.header.inm_header.status = SYS_RESULT_SUCCESS;
			inm_msg.header.inm_header.when = get_now();
			inm_msg.gameCode = state_rec_ptr->gameCode;
			inm_msg.issueNumber = state_rec_ptr->issueNumber;
			inm_msg.issueTimeStamp = state_rec_ptr->closingTime;
			inm_msg.closeCountDownSecond = state_rec_ptr->seconds;
			inm_msg.header.inm_header.length = sizeof(INM_MSG_T_CLOSE_SECONDS_UNS);

			ret = bq_send(ncpc_fid, (char*)&inm_msg, *(uint16*)&inm_msg);
			if (ret <= 0)
			{
				log_error("tfe_scan send data to bqueues failure! ");
			}
		}
    }

    //更新本地内存CACHE中的期次状态
    GIDB_ISSUE_HANDLE *i_handle = gidb_i_get_handle(game_code);
    if (i_handle == NULL)
    {
        log_error("gidb_i_get_handle fail,game[%d]", game_code);
        return -1;
    }
    ret = i_handle->gidb_i_set_status(i_handle, issue_number, issue_status, t);
    if (ret != 0)
    {
        log_error("gidb_i_set_status(%d, %lld, %s) error", game_code, issue_number, ISSUE_STATE_STR(issue_status));
        return -1;
    }

    //notify
    send_issue_status_notify( game_code, issue_number, issue_status);

    log_info("Exit Issue Process [%d - %lld  %s]--->", game_code, issue_number, ISSUE_STATE_STR(issue_status));
    return 0;
}
*/

int32 process_issue_closed(INM_MSG_HEADER *inm_buf)
{
    int ret = 0;

    INM_MSG_ISSUE_CLOSE *state_rec_ptr = (INM_MSG_ISSUE_CLOSE *)inm_buf;
    uint8 game_code = state_rec_ptr->gameCode;
    uint64 issue_number = state_rec_ptr->issueNumber;
    int32 issue_status = ISSUE_STATE_CLOSED;

    log_info("Enter Issue Process [%d - %lld  %s]---> tf_file_id[%u] tf_offset[%u]",
        game_code, issue_number, ISSUE_STATE_STR(issue_status), state_rec_ptr->header.tfe_file_idx, state_rec_ptr->header.tfe_offset);

    if (sysdb_getSysStatus() != SYS_STATUS_BUSINESS)
    {
        //故障恢复过程，需要判断此记录是否已处理过,如果处理过则直接返回
        //从数据库中查询期次状态，根据期次状态判断
        GIDB_ISSUE_INFO issue_info;
        memset(&issue_info, 0, sizeof(GIDB_ISSUE_INFO));
        if (!otl_get_issue_info(game_code, issue_number, &issue_info))
        {
            log_error("otl_get_issue_info() error. game[%d] issue_number[%lld]", game_code, issue_number);
            return -1;
        }
        if (issue_info.status >= issue_status)
        {
            log_debug("Game[%d] Issue[%lld] Status[%s] has already processed. --- SKIP ---",
            		game_code, issue_number, ISSUE_STATE_STR(issue_status));
            return 0;
        }
    }

    log_info("otl_set_issue_rk_stat(game_code[%u] issue_number[%llu] rkAmount[%lld]rkCnt[%d]issue_status[%s] ).",
    				game_code, issue_number, state_rec_ptr->refuseAmount, state_rec_ptr->refuseCount, ISSUE_STATE_STR(issue_status));

    if (!otl_set_issue_rk_stat(game_code, issue_number, state_rec_ptr->refuseAmount, state_rec_ptr->refuseCount))
	{
		log_error("otl_set_issue_rk_stat(game_code[%u] issue_number[%llu] rkAmount[%lld]rkCnt[%d]issue_status[%s] ) failed.",
				game_code, issue_number, state_rec_ptr->refuseAmount, state_rec_ptr->refuseCount, ISSUE_STATE_STR(issue_status));
		//return -1;
	}

    //更新数据库期次状态
    time_t t = time(NULL);
    if (!otl_set_issue_status(game_code, issue_number, issue_status, t))
    {
        log_error("otl_set_issue_status(game_code[%u] issue_number[%llu] issue_status[%s] ) failed.",
        		game_code, issue_number, ISSUE_STATE_STR(issue_status));
        return -1;
    }

    //更新内存期次状态，发送广播消息
	if (SYS_STATUS_BUSINESS == sysdb_getSysStatus())
    {
		ISSUE_INFO *issue_ptr = game_plugins_handle[state_rec_ptr->gameCode].get_issueInfo(state_rec_ptr->issueNumber);
		if (NULL==issue_ptr)
		{
			log_warn("game plugin get_issueInfo(game_code[%u], issue_number[%lld]) return NULL.",
					state_rec_ptr->gameCode, state_rec_ptr->issueNumber);
		}
		else
		{
			issue_ptr->curState = ISSUE_STATE_CLOSED;
			//

			//构造广播消息发送
			static INM_MSG_T_CLOSE_GAME_UNS inm_msg;
			memset(&inm_msg, 0, sizeof(INM_MSG_T_CLOSE_GAME_UNS));
			inm_msg.header.inm_header.type = INM_TYPE_T_CLOSE_GAME_UNS;
			inm_msg.header.inm_header.gltp_type = GLTP_MSG_TYPE_TERMINAL_UNS;
			inm_msg.header.inm_header.gltp_func = GLTP_T_UNS_CLOSE_GAME;
			inm_msg.header.inm_header.status = SYS_RESULT_SUCCESS;
			inm_msg.header.inm_header.when = get_now();
			inm_msg.gameCode = state_rec_ptr->gameCode;
			inm_msg.issueNumber = state_rec_ptr->issueNumber;
			inm_msg.issueTimeStamp = state_rec_ptr->closeTime;
			inm_msg.header.inm_header.length = sizeof(INM_MSG_T_CLOSE_GAME_UNS);

			ret = bq_send(ncpc_fid, (char*)&inm_msg, *(uint16*)&inm_msg);
			if (ret <= 0)
			{
				log_error("tfe_scan send data to bqueues failure! ");
			}
		}
    }

    //更新本地内存CACHE中的期次状态
    GIDB_ISSUE_HANDLE *i_handle = gidb_i_get_handle(game_code);
    if (i_handle == NULL)
    {
        log_error("gidb_i_get_handle fail,game[%d]", game_code);
        return -1;
    }
    ret = i_handle->gidb_i_set_status(i_handle, issue_number, issue_status, t);
    if (ret != 0)
    {
        log_error("gidb_i_set_status(%d, %lld, %s) error", game_code, issue_number, ISSUE_STATE_STR(issue_status));
        return -1;
    }

    //notify
    send_issue_status_notify( game_code, issue_number, issue_status);

    log_info("Exit Issue Process [%d - %lld  %s]--->", game_code, issue_number, ISSUE_STATE_STR(issue_status));

    return 0;
}


int32 process_fbs_match_open(INM_MSG_HEADER *inm_buf)
{
    int ret = 0;
    INM_MSG_O_FBS_MATCH_STATE *rec = (INM_MSG_O_FBS_MATCH_STATE *)inm_buf;

    uint8 game_code = rec->gameCode;
    uint32 match_code = rec->matchCode;
    uint8 match_state = M_STATE_OPEN;

    log_info("Enter Fbs Match Process [%lld - %s]---> tf_file_id[%u] tf_offset[%u]",
        match_code, MATCH_STATE_STR(match_state), inm_buf->tfe_file_idx, inm_buf->tfe_offset);

    if (sysdb_getSysStatus() != SYS_STATUS_BUSINESS) {
        //故障恢复过程，需要判断此记录是否已处理过,如果处理过则直接返回
        //从数据库中查询期次状态，根据期次状态判断
        GIDB_FBS_MATCH_INFO match_info;
        memset(&match_info, 0, sizeof(GIDB_FBS_MATCH_INFO));
        if (!otl_fbs_get_match_info(game_code, match_code, &match_info)) {
            log_error("otl_fbs_get_match_info() error. game[%d] match[%u]", game_code, match_code);
            return -1;
        }
        if (match_info.state >= match_state) {
            log_debug("Game[%d] Match[%u] Status[%s] has already processed. --- SKIP ---", game_code, match_code, MATCH_STATE_STR(match_state));
            return 0;
        }
    }

    //保存此期游戏配置参数
    ret = gidb_fbs_save_game_param(game_code, rec->issueNumber);
    if (ret == -1) {
        log_error("gidb_fbs_save_game_param fail.game[%d]issue[%u]match[%u]",
                game_code, rec->issueNumber, match_code);
        return -1;
    }

    //更新数据库期次状态
    if (!otl_fbs_set_match_state(game_code, match_code, match_state)) {
        log_error("otl_fbs_set_match_state(game_code[%u] match_code[%llu] match_state[%s] ) failed.", game_code, match_code, MATCH_STATE_STR(match_state));
        return -1;
    }

    //更新内存比赛状态，发送广播消息
    if (SYS_STATUS_BUSINESS == sysdb_getSysStatus()) {
    	FBS_MATCH *match_ptr = game_plugins_handle[rec->gameCode].fbs_get_match(rec->issueNumber, match_code);
		if (NULL==match_ptr) {
			log_error("game plugin fbs_get_match(game_code[%u], match_code[%u]) return NULL.",
					game_code, match_code);
            return -1;
		}
        //update memory match state
        match_ptr->state = M_STATE_OPEN;
    }

    log_info("Exit Fbs Match Process [%lld - %s]", match_code, MATCH_STATE_STR(match_state));
    return 0;
}

int32 process_fbs_match_close(INM_MSG_HEADER *inm_buf)
{
    int ret = 0;
    INM_MSG_O_FBS_MATCH_STATE *rec = (INM_MSG_O_FBS_MATCH_STATE *)inm_buf;

    uint8 game_code = rec->gameCode;
    uint64 match_code = rec->matchCode;
    uint8 match_state = M_STATE_CLOSE;

    log_info("Enter Fbs Match Process [%lld - %s]---> tf_file_id[%u] tf_offset[%u]",
        match_code, MATCH_STATE_STR(match_state), inm_buf->tfe_file_idx, inm_buf->tfe_offset);

    if (sysdb_getSysStatus() != SYS_STATUS_BUSINESS) {
        //故障恢复过程，需要判断此记录是否已处理过,如果处理过则直接返回
        //从数据库中查询期次状态，根据期次状态判断
        GIDB_FBS_MATCH_INFO match_info;
        memset(&match_info, 0, sizeof(GIDB_FBS_MATCH_INFO));
        if (!otl_fbs_get_match_info(game_code, match_code, &match_info)) {
            log_error("otl_fbs_get_match_info() error. game[%d] match[%lld]", game_code, match_code);
            return -1;
        }
        if (match_info.state >= match_state) {
            log_debug("Game[%d] Match[%lld] Status[%s] has already processed. --- SKIP ---", game_code, match_code, MATCH_STATE_STR(match_state));
            return 0;
        }
    }

    //关闭时强制更新一次销售数据
    char jsonBuf[4096] = { 0 };
    ret = game_plugins_handle[rec->gameCode].fbs_sale_calc(rec->issueNumber, rec->matchCode, jsonBuf);
    if (ret == 0)
    {
        log_debug("fbs_sale_calc issue[%d] match[%d] json[%s]", rec->issueNumber, rec->matchCode, jsonBuf);
        if (!otl_fbs_update_match_result(GAME_FBS, rec->issueNumber, rec->matchCode, jsonBuf))
        {
            log_error("otl_fbs_update_match_result error!");
        }
    }
    else
    {
        log_error("fbs_sale_calc match code[%d] error!", rec->matchCode);
    }


    //更新数据库期次状态
    if (!otl_fbs_set_match_state(game_code, match_code, match_state)) {
        log_error("otl_fbs_set_match_state(game_code[%u] match_code[%llu] match_state[%s] ) failed.", game_code, match_code, MATCH_STATE_STR(match_state));
        return -1;
    }

    //更新内存比赛状态，发送广播消息
    if (SYS_STATUS_BUSINESS == sysdb_getSysStatus()) {
    	FBS_MATCH *match_ptr = game_plugins_handle[rec->gameCode].fbs_get_match(rec->issueNumber, match_code);
		if (NULL==match_ptr) {
			log_error("game plugin fbs_get_match(game_code[%u], match_code[%lld]) return NULL.",
					game_code, match_code);
            return -1;
		}
        //update memory match state
        match_ptr->state = M_STATE_CLOSE;
    }

    log_info("Exit Fbs Match Process [%lld - %s]", match_code, MATCH_STATE_STR(match_state));
    return 0;
}


int tfe_scan_dispatcher(char *inm_buf)
{
    int ret = 0;
    INM_MSG_HEADER *pInm = (INM_MSG_HEADER *)inm_buf;
    switch (pInm->type)
    {
        case INM_TYPE_ISSUE_STATE_PRESALE:
        {
            ret = process_issue_presale(pInm);
            if (ret < 0)
            {
                log_error("process_issue_presale() failure");
                return -1;
            }
            break;
        }

        case INM_TYPE_ISSUE_STATE_OPEN:
        {
            ret = process_issue_open(pInm);
            if (ret < 0)
            {
                log_error("process_issue_open() failure");
                return -1;
            }
            break;
        }
        /*
        case INM_TYPE_ISSUE_STATE_CLOSING:
        {
            ret = process_issue_closing(pInm);
            if (ret < 0)
            {
                log_error("process_issue_closing() failure");
                return -1;
            }
            break;
        }
        */
        case INM_TYPE_ISSUE_STATE_CLOSED:
        {
            ret = process_issue_closed(pInm);
            if (ret < 0)
            {
                log_error("process_issue_closed() failure");
                return -1;
            }
            break;
        }


        //FBS
        case INM_TYPE_O_FBS_MATCH_OPEN:
        {
            ret = process_fbs_match_open(pInm);
            if (ret < 0)
            {
                log_error("process_fbs_match_open() failure");
                return -1;
            }
            break;
        }
        case INM_TYPE_O_FBS_MATCH_CLOSE:
        {
            ret = process_fbs_match_close(pInm);
            if (ret < 0)
            {
                log_error("process_fbs_match_close() failure");
                return -1;
            }
            break;
        }


        case INM_TYPE_TFE_CHECK_POINT:
        {
            if( (SYS_STATUS_END==sysdb_getSysStatus()) &&(pInm->status == 0xFFFF))
            {
                //safe close checkpoint
                exit_signal_fired = 1;
            }
            break;
        }

        default:
            return 1;
    }

    gidb_t_clean_handle_timeout();
    gidb_fbs_st_clean_handle();
    return 0;
}


static void signal_handler(int signo)
{
    ts_notused(signo);
    exit_signal_fired = 1;

    return;
}

static void signal_alarm(int signo)
{
    ts_notused(signo);
    timer_fired = 1;

    return;
}

static int init_signal(void)
{
    struct sigaction sas;
    memset(&sas, 0, sizeof(sas));
    sas.sa_handler = signal_handler;
    sigemptyset(&sas.sa_mask);
    sas.sa_flags |= SA_INTERRUPT;
    if (sigaction(SIGINT, &sas, NULL) == -1) {
        log_error("sigaction() failed. Reason: %s", strerror(errno));

        return -1;
    }

    if (sigaction(SIGTERM, &sas, NULL) == -1) {
        log_error("sigaction() failed. Reason: %s", strerror(errno));

        return -1;
    }

    /*
    sas.sa_handler = signal_alarm;
    if (sigaction(SIGALRM, &sas, NULL) == -1) {
        log_error("sigaction() failed. Reason: %s", strerror(errno));

        return -1;
    }

    alarm(TIMER_INTERVAL);
    */
    return 0;
}

int main(int argc, char *argv[])
{
    ts_notused(argc);
    ts_notused(argv);

    int ret = 0;

    logger_init(MY_TASK_NAME);

    log_info("%s start\n", MY_TASK_NAME);

    ret = init_signal();
    if (ret != 0) {
        log_error("init_signal() failed.");

        return -1;
    }

    tfeScanTimer = ts_timer_init(signal_alarm);
    if(tfeScanTimer < 0)
    {
    	log_error("ts_timer_init < 0! \n");
    	return -1;
    }

    ts_timer_set( tfeScanTimer, TIMER_INTERVAL,0);

	if (!sysdb_init()) {
        log_error("sysdb_init() failed.");
        return -1;
    }

    if (!bq_init())
    {
        sysdb_close();
        log_error("bq_init() failed.");
        return -1;
    }

    //connect oracle database
	SYS_DB_CONFIG *sysDBconfig = sysdb_getOmsDBCfg();
    char dbConnStr[64] = {0};
    sprintf(dbConnStr,"%s/%s@%s",sysDBconfig->username,sysDBconfig->password,sysDBconfig->url);
    if (!otl_connectDB(sysDBconfig->username, sysDBconfig->password, sysDBconfig->url,1)) {
        log_error("otl_connectDB() failed.");
        return  -1;
    }

    if (!gl_init()) {
        log_error("gl_init() failed.");
        return -1;
    }

    if (gl_game_plugins_init()!=0)
    {
        sysdb_close();
		gl_close();
        log_error("gl_game_plugins_init() failed.");
        return -1;
    }
    game_plugins_handle = gl_plugins_handle();

	ret = tfe_init();
	if (0 != ret)
	{
		log_error("tfe_init(%s) failed, ret[%d].", MY_TASK_NAME, ret);
		return -1;
	}
	static char footmark_name[128];
	sprintf(footmark_name, "%s/%s.ft", TFE_DATA_SUBDIR, MY_TASK_NAME);
	ret = tfe_t_restore_footmark(footmark_name, TFE_TASK_SCAN);
	if (0 != ret)
	{
		log_error("tfe_t_restore_footmark( %s ) failed.", footmark_name);
		return -1;
	}

    char follow_str[128];
    sprintf(follow_str, "%d", TFE_TASK_UPDATE);

    ret = tfe_t_init(TFE_TASK_SCAN, TFE_TASK_REPLY, follow_str, true);
    if (0 != ret)
    {
        log_error("tfe_t_init(%s) failed, ret[%d].", MY_TASK_NAME, ret);
        return -1;
    }
    uint64 t_offset = tfe_get_offset(TFE_TASK_SCAN);
    uint64 t_pre_offset = tfe_get_pre_offset(TFE_TASK_SCAN);
    log_debug("------ %s prepare running.  [ %lld  %lld ] ---------",
    		MY_TASK_NAME, t_offset, t_pre_offset);

    ncpc_fid = getFidByName("ncpsend_queue");

    sysdb_setTaskStatus(SYS_TASK_TFE_SCAN, SYS_TASK_STATUS_RUN );

	log_info("%s init success\n", MY_TASK_NAME);

    int total_rec_cnt = 0;
    static char inm_buf[INM_MSG_BUFFER_LENGTH];
    while (0 == exit_signal_fired)
	{
        ret = tfe_t_read((unsigned char *)inm_buf, INM_MSG_BUFFER_LENGTH, 200);
        if ((ret != 0) && (ret != TFE_TIMEOUT))
        {
            log_error("tfe_t_read() failed. ret[%d].", ret);
            break; //usleep(1000);
        }

        if (ret == 0)
        {
            total_rec_cnt++;
            int ret_0 = tfe_scan_dispatcher(inm_buf+TFE_HEADER_LENGTH);
            if (ret_0 < 0)
            {
                DUMP_INMMSG(inm_buf+TFE_HEADER_LENGTH);
                log_error("tfe_scan_dispatcher record process error.");
                break;
            }
            else if (0 == ret_0)
            {
                tfe_t_commit();
                tfe_t_keep_footmark(footmark_name, TFE_TASK_SCAN);
                total_rec_cnt = 0;
                continue;
            }
        }

        if (total_rec_cnt > 0)
        {
            tfe_t_commit();
            if(total_rec_cnt > 20000)
            {
                tfe_t_keep_footmark(footmark_name, TFE_TASK_SCAN);
                total_rec_cnt = 0;
            }
        }

    }

    if (1 == exit_signal_fired)
	{
        tfe_t_commit();
    }

	sysdb_setTaskStatus(SYS_TASK_TFE_SCAN, SYS_TASK_STATUS_EXIT);

    gidb_i_close_handle();
    gidb_drawlog_close_handle();

    gidb_fbs_im_close_all_handle();
    gidb_fbs_dl_close_all_handle();

    gl_close();

    otl_disConnectDB();

    sysdb_close();

    log_info("%s exit\n", MY_TASK_NAME);

    return 0;
}

