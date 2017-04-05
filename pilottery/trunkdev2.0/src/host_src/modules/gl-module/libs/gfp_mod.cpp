/***************************************************************************************
 *  文件名字：gl_game_flow_process.cpp
 *  描述：
 *
 *  作者：
 *  日期：         2010 03月04号   09:24:17
 *  CopyRight：
 *  Changes:
 ***************************************************************************************/
// system include

// local include
#include "global.h"
#include "gl_inf.h"

#include "otl_inf.h"
#include "sim_rng.h"



static ANNOUNCE_DATA *a_data = NULL;


//------内部接口-----------------------------

int send_issue_error_notify(uint8 game_code, uint64 issue_num, uint8 issue_status)
{
	GLTP_MSG_NTF_GL_ISSUE_FLOW_ERR notify;
	memset ((void*)&notify , 0 , sizeof(GLTP_MSG_NTF_GL_ISSUE_FLOW_ERR));

	notify.gameCode = game_code;
	notify.issueNumber = issue_num;
	notify.issueStatus = issue_status;
	notify.error = 1;

	sys_notify(GLTP_NTF_GL_ISSUE_FLOW_ERR, _ERROR, (char*)&notify, sizeof(notify));
	return 0;
}
//开奖过程中出现问题，将更新数据库的相关字段，记录错误原因编码和原因描述
//发送notify消息，报告期次开奖的问题
int set_issue_process_error(DB_ERROR *error_buf)
{
    log_error("Issue(game_code[%u], issue_num[%llu], ISSUE_STATE[%u], tiems[%d]) process found error.",
    		error_buf->game_code, error_buf->issue_num, error_buf->issue_status, error_buf->draw_times);

	//更新数据库游戏期次的错误信息
	if (error_buf->draw_times == GAME_DRAW_ONE)
    {
        if ( !otl_set_issue_process_error(error_buf->game_code, error_buf->issue_num) )
        {
            log_error("otl_set_issue_process_error(game_code[%u], issue_num[%llu], ISSUE_STATE[%u]) failed.",
            		error_buf->game_code, error_buf->issue_num, error_buf->issue_status);
        }
    }

    //发送开奖过程错误的 NOTIFY 消息
    send_issue_error_notify(error_buf->game_code, error_buf->issue_num, error_buf->issue_status);
    return 0;
}

//发送期次状态改变的notify消息
int send_issue_status_notify(uint8 game_code, uint64 issue_num, uint8 issue_status)
{
    GLTP_MSG_NTF_GL_ISSUE_STATUS notify;

    notify.gameCode = game_code;
    notify.issueNumber = issue_num;
    notify.nowStatus = issue_status;
    notify.nowtime = get_now();
    sys_notify(GLTP_NTF_GL_ISSUE_STATUS, _INFO, (char *)&notify, sizeof(GLTP_MSG_NTF_GL_ISSUE_STATUS));
    return 0;
}

//发送期次状态改变的INM消息
int send_issue_status_message(uint8 game_code, uint64 issue_number, INM_MSG_TYPE msg_type, uint8 draw_times)
{
    INM_MSG_ISSUE_STATE state_msg;
    memset(&state_msg, 0, sizeof(INM_MSG_ISSUE_STATE));
    state_msg.gameCode = game_code;
    state_msg.issueNumber = issue_number;
    state_msg.drawTimes = draw_times;
    state_msg.header.type = msg_type;
    state_msg.header.status = SYS_RESULT_SUCCESS;
    state_msg.header.length = sizeof(INM_MSG_ISSUE_STATE);

    GIDB_DRAWLOG_HANDLE *drawlog_handle = gidb_drawlog_get_handle(game_code);
    if (drawlog_handle == NULL)
    {
        log_error("gidb_drawlog_get_handle(%d) error", game_code);
        return -1;
    }

    int ret = drawlog_handle->gidb_drawlog_append_dl(drawlog_handle, issue_number, msg_type, (char *)&state_msg, sizeof(INM_MSG_ISSUE_STATE));
    if (ret < 0)
    {
        log_error("gidb_drawlog_append_dl(%d) type[%d] error", game_code, msg_type);
        return -1;
    }
    return 0;
}

int send_issue_status_message2(uint8 game_code, uint64 issue_number, INM_MSG_TYPE msg_type, char *msg, int32 msglen)
{
    GIDB_DRAWLOG_HANDLE *drawlog_handle = gidb_drawlog_get_handle(game_code);
    if (drawlog_handle == NULL)
    {
        log_error("gidb_drawlog_get_handle(%d) error", game_code);
        return -1;
    }

    int ret = drawlog_handle->gidb_drawlog_append_dl(drawlog_handle, issue_number, msg_type, msg, msglen);
    if (ret < 0)
    {
        log_error("gidb_drawlog_append_dl(%d) type[%d] error", game_code, msg_type);
        return -1;
    }
    return 0;
}


//判断在开奖表记录表中的某游戏某期的某次开奖状态是否已经在待检查状态issue_status之后，
//如果在的话，表明这一期的开奖状态已经被处理过
int issue_recover_check(GAME_FLOW_PROCESSOR *gfp, uint64 issue_number, uint8 draw_times, uint8 issue_status)
{
	//
	//return 0;

    uint8 game_code = gfp->game_code;
    GIDB_DRAW_HANDLE *d_handle = gidb_d_get_handle(game_code, issue_number, draw_times);
    if (d_handle == NULL)
    {
        log_error("gidb_d_get_handle(%d, %llu, %d) error", game_code, issue_number, draw_times);
        return -1;
    }

    //从开奖过程表中得到当前开奖的状态
    static char buffer[4*1024];
    GIDB_D_DATA *gd_data = (GIDB_D_DATA *)buffer;
    memset(gd_data, 0, sizeof(GIDB_D_DATA));
    int ret = d_handle->gidb_d_get_status(d_handle, gd_data);
    if (ret < 0)
    {
        log_error("gidb_d_get_status(%d, %llu, %d) failure", game_code, issue_number, draw_times);
        return -1;
    }
    if (gd_data->status >= issue_status)
    {
        //此记录已经处理过
        return 1;
    }
    if ( (issue_status - gd_data->status != 1) and (issue_status != ISSUE_STATE_SEALED) )
    {
    	log_error("issue_recover_check(%d, %llu, %d, %d) failure", game_code, issue_number, issue_status, gd_data->status);
    	return 1;
    }
    else if (issue_status == ISSUE_STATE_SEALED)
    {
    	if (issue_status - gd_data->status != ISSUE_STATE_SEALED)//第一次进入时 gd_data->status为0
    	{
    		log_error("issue_recover_check(%d, %llu, %d, %d) failure", game_code, issue_number, issue_status, gd_data->status);
    		return 1;
    	}
    }
    return 0;
}

int issue_update_status(GAME_FLOW_PROCESSOR *gfp, uint64 issue_number, int32 issue_status, uint8 draw_times)
{
    int ret = 0;
    uint8 game_code = gfp->game_code;

    //更新数据库
    time_t t = time(NULL);
    if (draw_times == GAME_DRAW_ONE)
    {
        if (!otl_set_issue_status(game_code, issue_number, issue_status, t))
        {
            log_error("otl_set_issue_status(game_code[%u] issue_number[%llu] issue_status[%d] ) failed.", game_code, issue_number, issue_status);
            return -1;
        }
    }

    GIDB_DRAW_HANDLE *d_handle = gidb_d_get_handle(game_code, issue_number, draw_times);
    if (d_handle == NULL)
    {
        log_error("gidb_d_get_handle(%d, %llu, %d) error", game_code, issue_number, draw_times);
        return -1;
    }
    //更新开奖过程中的状态
    static char buffer[4*1024];
    GIDB_D_DATA *gd_data = (GIDB_D_DATA *)buffer;
    memset(gd_data, 0, sizeof(GIDB_D_DATA));
    gd_data->status = issue_status;
    ret = d_handle->gidb_d_set_status(d_handle, gd_data);
    if (ret != 0)
    {
        log_error("gidb_d_set_status(game[%d] issue[%llu] status[%d]) error.", game_code, issue_number, issue_status);
        return -1;
    }

    //send notify
	if (draw_times == GAME_DRAW_ONE)
    {
        if (sysdb_getSysStatus() == SYS_STATUS_BUSINESS)
        {
            send_issue_status_notify( game_code, issue_number, issue_status);
        }
    }

#if 0
    GIDB_ISSUE_HANDLE *i_handle = gidb_i_get_handle(game_code);
    if (i_handle == NULL)
    {
        log_error("gidb_i_get_handle(%d) error", game_code);
        return -1;
    }
    //更新本地期次状态
    ret = i_handle->gidb_i_set_status(i_handle, issue_number, issue_status, t);
    if (ret != 0)
    {
        log_error("gidb_i_set_status(%d, %lld, %d) error", game_code, issue_number, issue_status);
        return -1;
    }

    if (draw_times == GAME_DRAW_ONE)
    {
        if (sysdb_getSysStatus() == SYS_STATUS_BUSINESS)
        {
            //更新内存期次信息
            if (issue_status > ISSUE_STATE_CLOSED)
            {
                ISSUE_INFO *is_info = gfp->plugin_handle->get_issueInfo(issue_number);
                if ( NULL == is_info )
                {
                    log_error("get_issueInfo(game_code[%u] issue_num[%llu]) return NULL.", game_code, issue_number);
                    return -1;
                }
                is_info->curState = issue_status;
            }
        }

        //notify
        send_issue_status_notify( game_code, issue_number, issue_status);
    }
#endif
    return 0;
}

//得到期次的游戏规则数据(开奖方式)
int32 get_game_issue_draw_type(uint8 game_code, uint64 issue_number)
{
    GIDB_T_TICKET_HANDLE *t_handle = gidb_t_get_handle(game_code, issue_number);
    if (t_handle == NULL)
    {
        log_error("gidb_t_get_handle() failure! game[%d] issue_number[%llu]", game_code, issue_number);
        return -1;
    }
    //得到期次封存的游戏规则数据
    static char game_buf[4*1024];
    int32 game_buf_len = 0;
    int ret = t_handle->gidb_t_get_field_blob(t_handle, T_GAME_PARAMBLOB_KEY, game_buf, &game_buf_len);
    if (ret != 0)
    {
        log_error("gidb_t_get_field_blob(%d, %llu, T_GAME_PARAMBLOB_KEY) failure!", game_code, issue_number);
        return -1;
    }
    GT_GAME_PARAM *game_param = (GT_GAME_PARAM *)game_buf;
    return game_param->drawType;
}

//期次封存
int32 gfp_issue_sealed_process(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf)
{
    int ret = 0;
    INM_MSG_ISSUE_STATE *inm_state_ptr = (INM_MSG_ISSUE_STATE *)inm_buf;
    uint8 game_code = self->game_code;
    uint64 issue_number = inm_state_ptr->issueNumber;
    uint8 draw_times = inm_state_ptr->drawTimes;
    int32 issue_status = ISSUE_STATE_SEALED;

    //判断此期次的第一次开奖是否已完成，第一次开奖未完成，不可进行多次开奖
    if (draw_times > GAME_DRAW_ONE)
    {
        GIDB_DRAW_HANDLE *d_handle_draw_one = gidb_d_get_handle(game_code, issue_number, GAME_DRAW_ONE);
        if (d_handle_draw_one == NULL)
        {
            log_error("gidb_d_get_handle(%d, %llu, GAME_DRAW_ONE) error", game_code, issue_number);
            return -1;
        }
        //从开奖过程表中得到当前开奖的状态
        static char buffer[4*1024];
        GIDB_D_DATA *gd_data = (GIDB_D_DATA *)buffer;
        memset(gd_data, 0, sizeof(GIDB_D_DATA));
        int ret = d_handle_draw_one->gidb_d_get_status(d_handle_draw_one, gd_data);
        if (ret < 0)
        {
            log_error("gidb_d_get_status(%d, %llu, %d) error", game_code, issue_number, GAME_DRAW_ONE);
            return -1;
        }
        if ( gd_data->status != ISSUE_STATE_ISSUE_END )
        {
            //第一次开奖未完成
            log_warn("Game[%d] Issue_number[%llu] isn't finish GAME_DRAW_ONE", game_code, issue_number);
            return -1;
        }
    }

    char buf_time[64] = {0};
    fmt_time_t(time(NULL), DATETIME_FORMAT_EN, buf_time);
    log_info("Enter Issue Process [%d - %llu  %s]---> %s", game_code, issue_number, ISSUE_STATE_STR(issue_status), buf_time);

    ret = issue_recover_check(self, issue_number, draw_times, issue_status);
    if (ret == 1)
    {
        //此业务已经处理过
        return 1;
    }

    //得到本期次的游戏规则数据(开奖方式)
    int32 draw_type = get_game_issue_draw_type(game_code, issue_number);
    if (draw_type < 0)
    {
        log_error("get_game_issue_draw_type(%d, %llu) failure!", game_code, issue_number);
        return -1;
    }

    if (draw_times == GAME_DRAW_ONE) //第一次开奖
    {
    	//对销售数据文件进行MD5签名
        char game_abbr[16] = {0};
        get_game_abbr(game_code, game_abbr);
        char db_path[256] = {0};
        ts_get_game_issue_ticket_filepath(game_abbr, issue_number, db_path, 256);
        ret = md5_file(db_path, NULL);
        if (ret < 0)
        {
            log_error("md5_file(game_code[%d] issue_num[%llu]) failed.", game_code, issue_number);
    		return -1;
        }

    	//生成本地封存数据文件并计算MD5
        if (draw_type != INSTANT_GAME)
        {
            TICKET_STAT ticket_stat;
            memset(&ticket_stat, 0, sizeof(TICKET_STAT));
            ret = gidb_seal_file(game_code, issue_number, &ticket_stat);
            if (0 != ret)
            {
                log_error("gidb_seal_file(game_code[%u] issue_num[%llu]) failed.", (uint32)game_code, issue_number);
                return -1;
            }

            log_info("gidb_seal_file OK ---> game_code[%d] issue_number[%llu].", game_code, issue_number);


            //(封存时)更新数据库的本期销售票数、销售注数、销售金额
            if (false == otl_set_issue_ticket_stat(game_code, issue_number, &ticket_stat))
            {
                log_error("otl_set_issue_ticket_stat(game_code[%d], issue_num[%llu]) failed.", game_code, issue_number);
                return -1;
            }
        }
    }

    //更新开奖过程的期次状态 (******** 注意: 期次封存的状态，由TFE_UPDATER完成对数据库和内存cache的修改 *******)
    GIDB_DRAW_HANDLE *d_handle = gidb_d_get_handle(game_code, issue_number, draw_times);
    if (d_handle == NULL)
    {
        log_error("gidb_d_get_handle(%d, %llu, %d) error", game_code, issue_number, draw_times);
        return -1;
    }

    //更新开奖过程中的状态
    static char buffer[4*1024];
    GIDB_D_DATA *gd_data = (GIDB_D_DATA *)buffer;
    memset(gd_data, 0, sizeof(GIDB_D_DATA));
    gd_data->status = issue_status;
    ret = d_handle->gidb_d_set_status(d_handle, gd_data);
    if (ret != 0)
    {
        log_error("gidb_d_set_status(game[%d] issue[%llu] status[%d]) error.", game_code, issue_number, issue_status);
        return -1;
    }

    //向开奖日志表写入一条记录，通知RNG Server请求开奖号码
    if (draw_type == INSTANT_GAME)
    {
        GIDB_DRAWLOG_HANDLE *drawlog_handle = gidb_drawlog_get_handle(game_code);
        if (drawlog_handle == NULL)
        {
            log_error("gidb_drawlog_get_handle(%d) error", game_code);
            return -1;
        }
        ret = drawlog_handle->gidb_drawlog_append_dc(drawlog_handle, issue_number);
        if (ret < 0)
        {
            log_error("gidb_drawlog_append_dc(%d, %llu) error", game_code, issue_number);
            return -1;
        }

        //for test draw
        if (false) //k-debug:仅供测试时使用(/tmp/drawCode_%gameCode.txt)
        {
			INM_MSG_ISSUE_DRAWNUM_INPUTE draw_rec;
			memset(&draw_rec, 0, sizeof(INM_MSG_ISSUE_DRAWNUM_INPUTE));
			draw_rec.drawTimes = inm_state_ptr->drawTimes;
			ret = generate_drawNumber(game_code, issue_number, &draw_rec);
			if (ret < 0)
			{
				log_error("generate_drawNumber error!!gamecode[%d],issue[%llu]", game_code, issue_number);
				return -1;
			}

			ret = drawlog_handle->gidb_drawlog_append_dl(drawlog_handle,
														 issue_number,
														 draw_rec.header.type,
														 (char*)&draw_rec,
														 draw_rec.header.length);
			if (ret < 0)
			{
				log_error("gidb_drawlog_append_dl(%d, %llu) error", game_code, issue_number);
				return -1;
			}
        }
    }

    log_info("Exit Issue Process [%d - %llu  %s]--->", game_code, issue_number, ISSUE_STATE_STR(issue_status));
    return 0;
}

//期结:开奖号码录入
int32 gfp_issue_drawnum_inputed_process(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf)
{
    int step = 0;
    int ret = 0;

    INM_MSG_ISSUE_DRAWNUM_INPUTE *inm_state_ptr = (INM_MSG_ISSUE_DRAWNUM_INPUTE *)inm_buf;
    uint8 game_code = self->game_code;
    uint64 issue_number = inm_state_ptr->issueNumber;
    uint8 draw_times = inm_state_ptr->drawTimes;
    int32 issue_status = ISSUE_STATE_DRAWNUM_INPUTED;

    char buf_time[64] = {0};
    fmt_time_t(time(NULL), DATETIME_FORMAT_EN, buf_time);
    log_info("Enter Issue Process [%d - %llu  %s]---> %s", game_code, issue_number, ISSUE_STATE_STR(issue_status), buf_time);

    ret = issue_recover_check(self, issue_number, draw_times, issue_status);
    if (ret == 1)
    {
        //此业务已经处理过
        return 1;
    }

    //----------------------------------------------------------------
    //for test draw
    //time_type t = get_now();
    //if (t < 1420041600 + 60 * 60 * 24 * 10) //2015-1-1 + N
    if (false)//已废弃，使用(gfp_issue_sealed_process里的for test draw)
    {
        //得到本期次的游戏规则数据(开奖方式)
        int32 draw_type = get_game_issue_draw_type(game_code, issue_number);
        if (draw_type < 0)
        {
            log_error("get_game_issue_draw_type(%d, %llu) failure!", game_code, issue_number);
            return -1;
        }

    	if (draw_type == INSTANT_GAME)
		{
			INM_MSG_ISSUE_DRAWNUM_INPUTE draw_rec;
			memset(&draw_rec, 0, sizeof(INM_MSG_ISSUE_DRAWNUM_INPUTE));
			ret = generate_drawNumber(game_code, issue_number, &draw_rec);
			if (ret < 0)
			{
				log_error("generate_drawNumber error!!gamecode[%d],issue[%llu]", game_code, issue_number);
				return -1;
			}
			memcpy(inm_state_ptr->drawCodes, draw_rec.drawCodes, (64+128));
		}
    }

    //----------------------------------------------------------------

    //获得GIDB_DRAW_HANDLE
    static char buffer[4*1024];
    GIDB_DRAW_HANDLE *d_handle = gidb_d_get_handle(game_code, issue_number, draw_times);
    if (d_handle == NULL)
    {
        log_error("gidb_d_get_handle(%d, %llu, %d) error", game_code, issue_number, draw_times);
        return -1;
    }
    //清理以前的匹配记录
    d_handle->gidb_d_clean_match_table(d_handle);

    //保存开奖号码字符串
    GIDB_D_DATA *gd_data = (GIDB_D_DATA *)buffer;
    memset(gd_data, 0, sizeof(GIDB_D_DATA));
    gd_data->field_type = DRAW_CODE_TEXT_KEY;
    gd_data->data_len = strlen(inm_state_ptr->drawCodesStr);
    strncpy(gd_data->data, inm_state_ptr->drawCodesStr, gd_data->data_len);
    ret = d_handle->gidb_d_set_field_text(d_handle, gd_data);
    if (ret != 0)
    {
        log_error("gidb_d_set_field_text(%d, %llu, field_type[DRAW_CODE_TEXT_KEY]) error", game_code, issue_number);
        return -1;
    }

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    //生成开奖号码的bitmap，便于匹配
    ret = self->plugin_handle->create_drawNum(inm_state_ptr->drawCodes, inm_state_ptr->count);
    if (ret != 0)
    {
        log_error("create_drawNum(game_code[%d] issue_num[%llu]) failed.", game_code, issue_number);
		return -1;
    }

    //票匹配
    ISSUE_REAL_STAT issue_stat;
    memset(&issue_stat, 0, sizeof(ISSUE_REAL_STAT));
    ret = gidb_match_ticket_callback(game_code, issue_number, draw_times,
                                     self->plugin_handle->match_ticket, &issue_stat);
    if ( 0 > ret )
    {
        log_error("gidb_match_ticket_callback(game_code[%d] issue_num[%llu]) failed.", game_code, issue_number);
        return -1;
    }

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    //将本期各个奖等的中奖统计信息写入本地数据库，同时输出算奖结果日志
    VALUE_TRIPLE prize_level_stat_triple[MAX_PRIZE_COUNT];
    memset(prize_level_stat_triple, 0, sizeof(VALUE_TRIPLE)*MAX_PRIZE_COUNT);
    int i, cnt = 0;
    log_notice("Game prize stat table ---> game_code[%d] issue_number[%llu]", game_code, issue_number);

    GIDB_T_TICKET_HANDLE *t_handle = gidb_t_get_handle(game_code, issue_number);
    if (t_handle == NULL)
    {
        log_error("gidb_t_get_handle(%d, %llu) failure", game_code, issue_number);
        return -1;
    }

    GT_PRIZE_PARAM gtPrizeParam;
    memset(&gtPrizeParam, 0, sizeof(gtPrizeParam));
    int32 prizeLen = 0;

	ret = t_handle->gidb_t_get_field_blob(t_handle, T_PRIZE_PARAMBLOB_KEY, (char*)&gtPrizeParam, &prizeLen);
	if (ret != 0)
	{
		log_error("gidb_t_get_field_blob(%d, %llu, T_PRIZE_PARAMBLOB_KEY) failure.", game_code, issue_number);
		return -1;
	}

    for (i = 0; i < MAX_PRIZE_COUNT; ++i)
    {
        PRIZE_PARAM *pp = &(gtPrizeParam.prize_param[i]);
        if (!pp->used)
        {
            if (issue_stat.prize_stat[i] == 0)
            {
                continue;
            }
            else
            {
                log_error("prize_stat[prize_code %d] == %u, but cannot find prize_param(game_code[%u], prize_code[%d])",
                        i, issue_stat.prize_stat[i], (uint32)game_code, i);
                return -1;
            }
        }
        if (0 == issue_stat.prize_stat[i]) {
            continue;
        }
        prize_level_stat_triple[cnt].code = i;
        prize_level_stat_triple[cnt].value = issue_stat.prize_stat[i];
        cnt++;
        log_info("prize_code=%d, prize_count=%u", i, issue_stat.prize_stat[i]);
    }
    memset(gd_data, 0, sizeof(GIDB_D_DATA));
    gd_data->field_type = D_WLEVEL_STAT_BLOB_KEY;
    gd_data->data_len = sizeof(VALUE_TRIPLE) * MAX_PRIZE_COUNT;
    memcpy(gd_data->data, (char *)prize_level_stat_triple, gd_data->data_len);
    ret = d_handle->gidb_d_set_field_blob(d_handle, gd_data);
    if (ret != 0)
    {
        log_error("gidb_d_set_field_text(%d, %llu, field_type[D_WLEVEL_STAT_BLOB_KEY]) error", game_code, issue_number);
        return -1;
    }

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    //将从匹配过程中记录的 票的数量 和 票的销售额 更新到 本地期次实际票统计数据
    TICKET_STAT ticket_stat;
    memset(&ticket_stat, 0, sizeof(TICKET_STAT));
    ticket_stat.s_ticketCnt = issue_stat.sale_tickets_count;
    ticket_stat.s_betCnt = issue_stat.sale_bet_count;
    ticket_stat.s_amount = issue_stat.sale_money_amount;
    ticket_stat.c_ticketCnt = issue_stat.cancel_tickets_count;
    ticket_stat.c_betCnt = issue_stat.cancel_bet_count;
    ticket_stat.c_amount = issue_stat.cancel_money_amount;
    memset(gd_data, 0, sizeof(GIDB_D_DATA));
    gd_data->field_type = D_TICKETS_STAT_BLOB_KEY;
    gd_data->data_len = sizeof(TICKET_STAT);
    memcpy(gd_data->data, (char *)&ticket_stat, gd_data->data_len);
    ret = d_handle->gidb_d_set_field_blob(d_handle, gd_data);
    if (ret != 0)
    {
        log_error("gidb_d_set_field_text(%d, %llu, field_type[D_TICKETS_STAT_BLOB_KEY]) error", game_code, issue_number);
        return -1;
    }

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    //更新数据库的本期销售票数、销售注数、销售金额、退票数量、退票注数、退票金额
    if (draw_times == GAME_DRAW_ONE)
    {
        if (false == otl_set_issue_ticket_stat(game_code, issue_number, &ticket_stat))
        {
            log_error("otl_set_issue_ticket_stat(game_code[%d], issue_num[%llu]) failed.", game_code, issue_number);
            return -1;
        }
    }

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%lld].", step++, game_code, issue_number);

    //将按高等奖统计各个奖等下的销售站统计信息保存到临时文件，用于生成winner.local文件时使用
    ret = save_high_prize_info_tmp(game_code, issue_number, draw_times, issue_stat.a_high_prize);
    if ( 0 > ret )
    {
        log_error("save_high_prize_info_tmp(game_code[%d], issue_number[%llu]) failed.", game_code, issue_number);
        return -1;
    }

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    //更新期次状态
    ret = issue_update_status(self, issue_number, issue_status, draw_times);
    if (ret != 0)
    {
        log_error("update_issue_status(game[%d] issue[%llu] status[%d]) error.", game_code, issue_number, issue_status);
        return -1;
    }

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);


    //向开奖日志表中发送 其状态变更为 ISSUE_STATE_MATCHED 的消息
    ret = send_issue_status_message(game_code, issue_number, INM_TYPE_ISSUE_STATE_MATCHED, draw_times);
    if (ret < 0)
    {
        log_error("send_issue_status_message(game_code[%d], issue_number[%llu], INM_TYPE_ISSUE_STATE_MATCHED) failure.", game_code, issue_number);
        return -1;
    }

    log_info("Exit Issue Process [%d - %llu  %s]--->", game_code, issue_number, ISSUE_STATE_STR(issue_status));
    return 0;
}

int32 gfp_issue_matched_process(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf, POOL_AMOUNT *pool)
{
	int ret = 0;

    INM_MSG_ISSUE_STATE *inm_state_ptr = (INM_MSG_ISSUE_STATE *)inm_buf;
    uint8 game_code = self->game_code;
    uint64 issue_number = inm_state_ptr->issueNumber;
    uint8 draw_times = inm_state_ptr->drawTimes;
    int32 issue_status = ISSUE_STATE_MATCHED;

    char buf_time[64] = {0};
    fmt_time_t(time(NULL), DATETIME_FORMAT_EN, buf_time);
    log_info("Enter Issue Process [%d - %llu  %s]---> %s", game_code, issue_number, ISSUE_STATE_STR(issue_status), buf_time);

    ret = issue_recover_check(self, issue_number, draw_times, issue_status);
    if (ret == 1)
    {
        //此业务已经处理过
        return 1;
    }

    POOL_AMOUNT *pool_amount = NULL; //奖池数据

    //得到本期次的游戏规则数据(开奖方式)
    int32 draw_type = get_game_issue_draw_type(game_code, issue_number);
    if (draw_type < 0)
    {
        log_error("get_game_issue_draw_type(%d, %llu) failure!", game_code, issue_number);
        return -1;
    }

    POOL_AMOUNT pool_tmp;
    if (draw_type != MANUAL_EXTERNAL) //外部奖池(ssq,7lc等)不取奖池，不更新奖池
    {
        if (draw_times == GAME_DRAW_ONE)
        {
            //从数据库获取奖池信息
            memset(&pool_tmp, 0, sizeof(POOL_AMOUNT));
            if ( !otl_get_issue_pool(game_code, &pool_tmp))
            {
                log_error("otl_get_issue_pool(game_code[%d] issue_number[%llu] ISSUE_STATE_MATCHED) failed.", game_code, issue_number);
			    return -1;
            }
            pool_amount = &pool_tmp;
        }
        else
        {
            pool_amount = pool;
        }
    }

    //更新期次状态
    ret = issue_update_status(self, issue_number, issue_status, draw_times);
    if (ret != 0)
    {
        log_error("update_issue_status(game[%d] issue[%llu] status[%d]) error.", game_code, issue_number, issue_status);
        return -1;
    }

    //向开奖日志表中发送 其状态变更为 ISSUE_STATE_FUND_INPUTED 的消息
    INM_MSG_ISSUE_FUND_INPUTE state_msg;
    memset(&state_msg, 0, sizeof(INM_MSG_ISSUE_FUND_INPUTE));
    state_msg.gameCode = game_code;
    state_msg.issueNumber = issue_number;
    state_msg.drawTimes = draw_times;
    state_msg.header.type = INM_TYPE_ISSUE_STATE_FUND_INPUTED;
    if (pool_amount != NULL)
    {
    	memcpy(&state_msg.pool, pool_amount, sizeof(POOL_AMOUNT));
    }
    state_msg.adjustMoneyAmount = 0;
    state_msg.publishMoneyAmount = 0;
    state_msg.header.length = sizeof(INM_MSG_ISSUE_FUND_INPUTE);
    ret = send_issue_status_message2(game_code, issue_number, INM_TYPE_ISSUE_STATE_FUND_INPUTED, (char *)&state_msg, sizeof(INM_MSG_ISSUE_FUND_INPUTE));
    if (ret < 0)
    {
        log_error("send_issue_status_message2(game_code[%d], issue_number[%lld], INM_MSG_ISSUE_FUND_INPUTE) failure.", game_code, issue_number);
        return -1;
    }

    log_info("Exit Issue Process [%d - %llu  %s]--->", game_code, issue_number, ISSUE_STATE_STR(issue_status));
    return 0;
}

int32 gfp_issue_fund_inputed_process(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf)
{
    int step = 0;
    int ret = 0;

    INM_MSG_ISSUE_FUND_INPUTE *inm_state_ptr = (INM_MSG_ISSUE_FUND_INPUTE *)inm_buf;
    uint8 game_code = self->game_code;
    uint64 issue_number = inm_state_ptr->issueNumber;
    uint8 draw_times = inm_state_ptr->drawTimes;
    int32 issue_status = ISSUE_STATE_FUND_INPUTED;

    char buf_time[64] = {0};
    fmt_time_t(time(NULL), DATETIME_FORMAT_EN, buf_time);
    log_info("Enter Issue Process [%d - %llu  %s]---> %s", game_code, issue_number, ISSUE_STATE_STR(issue_status), buf_time);

    ret = issue_recover_check(self, issue_number, draw_times, issue_status);
    if (ret == 1)
    {
        //此业务已经处理过
        return 1;
    }

    static char buffer[4*1024];

    GIDB_DRAW_HANDLE *d_handle = gidb_d_get_handle(game_code, issue_number, draw_times);
    if (d_handle == NULL)
    {
        log_error("gidb_d_get_handle(%d, %llu, %d) error", game_code, issue_number, draw_times);
        return -1;
    }
    //取得奖级中奖统计信息
    VALUE_TRIPLE prize_level_stat_triple[MAX_PRIZE_COUNT];
    memset((char *)prize_level_stat_triple, 0, sizeof(prize_level_stat_triple));

    GIDB_D_DATA *gd_data = (GIDB_D_DATA *)buffer;
    memset(gd_data, 0, sizeof(GIDB_D_DATA));
    gd_data->field_type = D_WLEVEL_STAT_BLOB_KEY;
    ret = d_handle->gidb_d_get_field_blob(d_handle, gd_data);
    if (ret != 0)
    {
        log_error("gidb_d_get_field_blob(%d, %lld, field_type[D_WLEVEL_STAT_BLOB_KEY]) error", game_code, issue_number);
        return -1;
    }
    memcpy((char *)prize_level_stat_triple, gd_data->data, gd_data->data_len);
    int32 cnt = gd_data->data_len / sizeof(VALUE_TRIPLE);

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    GL_PRIZE_INFO prizeInfo[MAX_PRIZE_COUNT];
    memset(prizeInfo, 0, sizeof(prizeInfo));
    for (int i = 0; i < cnt; i++)
    {
        prizeInfo[prize_level_stat_triple[i].code].prizeBaseCount = prize_level_stat_triple[i].value;
        if (prize_level_stat_triple[i].code > 0)
        {
			log_info("debug: i=%d, prize_code=%d, count=%d",
					i, prize_level_stat_triple[i].code, prize_level_stat_triple[i].value);
        }
    }

    //取得游戏期的实际票统计数据
    TICKET_STAT ts;
    gd_data = (GIDB_D_DATA *)buffer;
    memset(gd_data, 0, sizeof(GIDB_D_DATA));
    gd_data->field_type = D_TICKETS_STAT_BLOB_KEY;
    ret = d_handle->gidb_d_get_field_blob(d_handle, gd_data);
    if (ret != 0)
    {
        log_error("gidb_d_get_field_blob(%d, %llu, field_type[D_TICKETS_STAT_BLOB_KEY]) error", game_code, issue_number);
        return -1;
    }
    memcpy(&ts, gd_data->data, gd_data->data_len);

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    GIDB_T_TICKET_HANDLE *t_handle = gidb_t_get_handle(game_code, issue_number);
    if (t_handle == NULL)
    {
        log_error("gidb_t_get_handle() failure! game[%d] issue_number[%llu]", game_code, issue_number);
        return -1;
    }
    //获取期次封存的奖级表
    static char prize_buf[4*1024];
    memset(prize_buf, 0, 4*1024);
    int32 prize_buf_len = 0;
    ret = t_handle->gidb_t_get_field_blob(t_handle, T_PRIZE_PARAMBLOB_KEY, prize_buf, &prize_buf_len);
    if (ret != 0)
    {
        log_error("gidb_t_get_field_blob(%d, %llu, T_PRIZE_PARAMBLOB_KEY) failure!", game_code, issue_number);
        return -1;
    }
    //得到期次封存的游戏规则数据
    static char game_buf[4*1024];
    int32 game_buf_len = 0;
    ret = t_handle->gidb_t_get_field_blob(t_handle, T_GAME_PARAMBLOB_KEY, game_buf, &game_buf_len);
    if (ret != 0)
    {
        log_error("gidb_t_get_field_blob(%d, %llu, T_GAME_PARAMBLOB_KEY) failure!", game_code, issue_number);
        return -1;
    }
    GT_GAME_PARAM *game_param = (GT_GAME_PARAM *)game_buf;

    //调用游戏插件进行算奖
    GL_PRIZE_CALC przCalc;
    memset(&przCalc, 0, sizeof(przCalc));
    przCalc.saleAmount = ts.s_amount;
    memcpy(&przCalc.pool, &inm_state_ptr->pool, sizeof(POOL_AMOUNT));
    przCalc.adjustAmount = 0;
    przCalc.publishAmount = 0;
    przCalc.returnRate = game_param->returnRate;
	przCalc.moneyEnough = 1;
    log_info("totalSellMoneyAmount[%lld] poolAmount[%lld]", przCalc.saleAmount, przCalc.pool.poolAmount);

    ret = self->plugin_handle->calc_prize(issue_number, &przCalc, (GT_PRIZE_PARAM *)prize_buf, prizeInfo);
    if (ret != 0)
    {
        log_error("calc_prize(game_code[%d] issue_num[%llu]) failed.", game_code, issue_number);
        return -1;
    }
    //如果奖池不足，输出警告信息
    if (przCalc.moneyEnough == 0)
    {
        log_warn("game pool is not enough( game_code[%d] issue_num[%llu] ISSUE_STATE_FUND_INPUTED ) warn.",
        		game_code, issue_number);
    }
    log_info("totalPrizeAmount[%lld] toPool[%lld] rounding[%lld]",
    		przCalc.prizeAmount, przCalc.poolUsed.poolAmount, przCalc.highPrize2Adjust);


    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);


    //输出算奖结果 各个奖等的中奖注数和金额
    PRIZE_LEVEL prize_level_array[MAX_PRIZE_COUNT];
    memset(prize_level_array, 0, sizeof(PRIZE_LEVEL));
    log_debug("prize level  table --->  game_code[%d] issue_num[%llu]", game_code, issue_number);
    int total_prize_level = 0;
    PRIZE_PARAM *prize_ptr = ((GT_PRIZE_PARAM *)prize_buf)->prize_param;
    for (int i = 0; i < MAX_PRIZE_COUNT; i++)
    {
        PRIZE_PARAM *pp = &prize_ptr[i];
        if (pp->used == false)
        {
            continue;
        }
        prize_level_array[total_prize_level].prize_code = pp->prizeCode;
        prize_level_array[total_prize_level].hflag = pp->hflag;
        prize_level_array[total_prize_level].count = prizeInfo[pp->prizeCode].prizeBaseCount;
        prize_level_array[total_prize_level].money_amount = prizeInfo[pp->prizeCode].prizeBaseAmount;

        if (prize_level_array[total_prize_level].count > 0)
        {
        	log_info("prize_code=%u, count=%d, money_t=%lld",
                prize_level_array[total_prize_level].prize_code,
                prize_level_array[total_prize_level].count,
                prize_level_array[total_prize_level].money_amount);
        }
        total_prize_level++;
    }


    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);


    //保存奖级的奖金数据
    gd_data = (GIDB_D_DATA *)buffer;
    memset(gd_data, 0, sizeof(GIDB_D_DATA));
    gd_data->field_type = D_WPRIZE_LEVEL_BLOB_KEY;
    gd_data->data_len = total_prize_level * sizeof(PRIZE_LEVEL);
    memcpy(gd_data->data, (char *)prize_level_array, gd_data->data_len);
    ret = d_handle->gidb_d_set_field_blob(d_handle, gd_data);
    if (ret != 0)
    {
        log_error("gidb_d_set_field_text(%d, %llu, field_type[D_WPRIZE_LEVEL_BLOB_KEY]) error", game_code, issue_number);
        return -1;
    }


    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);


    //保存奖池的相关数据
    gd_data = (GIDB_D_DATA *)buffer;
    memset(gd_data, 0, sizeof(GIDB_D_DATA));
    gd_data->field_type = D_WFUND_INFO_BLOB_KEY;
    gd_data->data_len = sizeof(GL_PRIZE_CALC);
    memcpy(gd_data->data, (char *)&przCalc, gd_data->data_len);
    ret = d_handle->gidb_d_set_field_blob(d_handle, gd_data);
    if (ret != 0)
    {
        log_error("gidb_d_set_field_text(%d, %llu, field_type[D_WFUND_INFO_BLOB_KEY]) error", game_code, issue_number);
        return -1;
    }


    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);


    //更新期次状态
    ret = issue_update_status(self, issue_number, issue_status, draw_times);
    if (ret != 0)
    {
        log_error("update_issue_status(game[%d] issue[%llu] status[%d]) error.", game_code, issue_number, issue_status);
        return -1;
    }

    //得到本期次的游戏规则数据(开奖方式)
    int32 draw_type = get_game_issue_draw_type(game_code, issue_number);
    if (draw_type < 0)
    {
        log_error("get_game_issue_draw_type(%d, %llu) failure!", game_code, issue_number);
        return -1;
    }

    //向开奖日志表中发送 其状态变更为 ISSUE_STATE_LOCAL_CALCED 的消息
    memset(buffer, 0, 4*1024);
    INM_MSG_ISSUE_WLEVEL *state_ptr = (INM_MSG_ISSUE_WLEVEL *)buffer;
    state_ptr->gameCode = game_code;
    state_ptr->issueNumber = issue_number;
    state_ptr->drawTimes = draw_times;
    state_ptr->header.type = INM_TYPE_ISSUE_STATE_LOCAL_CALCED;
    state_ptr->count = total_prize_level;
    memcpy(state_ptr->prize_list, prize_level_array, sizeof(PRIZE_LEVEL) * total_prize_level);
    if (draw_type != MANUAL_EXTERNAL)
    {
        state_ptr->poolAmount = przCalc.poolUsed.poolAmount + przCalc.pool.poolAmount;
    }
    state_ptr->header.length = sizeof(INM_MSG_ISSUE_WLEVEL) + sizeof(PRIZE_LEVEL) * total_prize_level;
    ret = send_issue_status_message2(game_code, issue_number, INM_TYPE_ISSUE_STATE_LOCAL_CALCED, (char *)state_ptr, state_ptr->header.length);
    if (ret < 0)
    {
        log_error("send_issue_status_message2(game_code[%d], issue_number[%llu], INM_TYPE_ISSUE_STATE_LOCAL_CALCED) failure.", game_code, issue_number);
        return -1;
    }

    log_info("Exit Issue Process [%d - %llu  %s]--->", game_code, issue_number, ISSUE_STATE_STR(issue_status));
    return 0;
}

int32 gfp_issue_local_calced_process(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf)
{
    int step = 0;
    int ret = 0;

    INM_MSG_ISSUE_WLEVEL *inm_state_ptr = (INM_MSG_ISSUE_WLEVEL *)inm_buf;
    uint8 game_code = self->game_code;
    uint64 issue_number = inm_state_ptr->issueNumber;
    uint8 draw_times = inm_state_ptr->drawTimes;
    int32 issue_status = ISSUE_STATE_LOCAL_CALCED;

    char buf_time[64] = {0};
    fmt_time_t(time(NULL), DATETIME_FORMAT_EN, buf_time);
    log_info("Enter Issue Process [%d - %llu  %s]---> %s", game_code, issue_number, ISSUE_STATE_STR(issue_status), buf_time);

    ret = issue_recover_check(self, issue_number, draw_times, issue_status);
    if (ret == 1)
    {
        //此业务已经处理过
        return 1;
    }

    //生成winner.local文件所需的数据
    if(a_data == NULL)
    {
    	a_data =(ANNOUNCE_DATA *) malloc(sizeof(ANNOUNCE_DATA));
    	if (a_data == NULL)
    	{
    	    log_error("generate_issue_winner_data malloc return NULL.");
            return -1;
    	}
    }
    memset((char *)a_data, 0, sizeof(ANNOUNCE_DATA));
    a_data->game_code = game_code;
    a_data->issue_number = issue_number;
	ret = generate_issue_winner_data(game_code, issue_number, draw_times, WINNER_LOCAL_FILE, a_data);
    if (ret != 0)
	{
		log_error("generate_issue_winner_data(game_code[%d], issue_num[%llu], WINNER_LOCAL_FILE) failed.", game_code, issue_number);
		return -1;
	}

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

	//生成winner.local的xml文件
	ret = create_winner_file( game_code, issue_number, draw_times, WINNER_LOCAL_FILE, a_data);
	if (ret != 0)
	{
		log_error("create_winner_file(game_code[%d], issue_num[%llu, WINNER_LOCAL_FILE) failed.", game_code, issue_number);
		return -1;
	}


    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    //将winner.local文件放入本地期次存储
    ret = save_winner_file_for_gidb(game_code, issue_number, draw_times, WINNER_LOCAL_FILE);
    if (0 > ret)
    {
        log_error("save_winner_file_for_gidb(game_code[%d], issue_num[%llu WINNER_LOCAL_TEXT_KEY) failed.", game_code, issue_number);
        return -1;
    }

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    //将winner.local文件保存到OMS的数据库
    if (draw_times == GAME_DRAW_ONE)
    {
        char winFilePath[256] = {0};
        get_game_issue_winner_filepath(winFilePath, game_code, issue_number, draw_times, WINNER_LOCAL_FILE);
        if ( !otl_set_issue_calc_results(game_code, issue_number, WINNER_LOCAL_FILE, winFilePath) )
    	{
    		log_error("otl_set_issue_calc_results(game_code[%d] issue_num[%llu]) failed.", game_code, issue_number);
    		return -1;
    	}
    }

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    //更新期次状态
    ret = issue_update_status(self, issue_number, issue_status, draw_times);
    if (ret != 0)
    {
        log_error("update_issue_status(game[%d] issue[%llu] status[%d]) error.", game_code, issue_number, issue_status);
        return -1;
    }

    //得到本期次的游戏规则数据(开奖方式)
    int32 draw_type = get_game_issue_draw_type(game_code, issue_number);
    if (draw_type < 0)
    {
        log_error("get_game_issue_draw_type(%d, %llu) failure!", game_code, issue_number);
        return -1;
    }
    if (draw_type == INSTANT_GAME)
	{
    	static char buffer[4*1024];
        memset(buffer, 0, 4*1024);
        INM_MSG_ISSUE_WLEVEL *state_ptr = (INM_MSG_ISSUE_WLEVEL *)buffer;
        memcpy(state_ptr, inm_state_ptr, inm_state_ptr->header.length);
        state_ptr->header.type = INM_TYPE_ISSUE_STATE_PRIZE_ADJUSTED;
        ret = send_issue_status_message2(game_code, issue_number, INM_TYPE_ISSUE_STATE_PRIZE_ADJUSTED, (char *)state_ptr, state_ptr->header.length);
        if (ret < 0)
        {
            log_error("send_issue_status_message2(game_code[%d], issue_number[%llu], INM_TYPE_ISSUE_STATE_PRIZE_ADJUSTED) failure.", game_code, issue_number);
            return -1;
        }
    }

    log_info("Exit Issue Process [%d - %llu  %s]--->", game_code, issue_number, ISSUE_STATE_STR(issue_status));
    return 0;
}

int32 gfp_issue_prize_adjusted_process(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf)
{
    int step = 0;
    int ret = 0;

    INM_MSG_ISSUE_WLEVEL *inm_state_ptr = (INM_MSG_ISSUE_WLEVEL *)inm_buf;
    uint8 game_code = self->game_code;
    uint64 issue_number = inm_state_ptr->issueNumber;
    uint8 draw_times = inm_state_ptr->drawTimes;
    int32 issue_status = ISSUE_STATE_PRIZE_ADJUSTED;

    char buf_time[64] = {0};
    fmt_time_t(time(NULL), DATETIME_FORMAT_EN, buf_time);
    log_info("Enter Issue Process [%d - %llu  %s]---> %s", game_code, issue_number, ISSUE_STATE_STR(issue_status), buf_time);

    ret = issue_recover_check(self, issue_number, draw_times, issue_status);
    if (ret == 1)
    {
        //此业务已经处理过
        return 1;
    }

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    static char buffer[4*1024];
    GIDB_D_DATA *gd_data = NULL;

    GIDB_DRAW_HANDLE *d_handle = gidb_d_get_handle(game_code, issue_number, draw_times);
    if (d_handle == NULL)
    {
        log_error("gidb_d_get_handle(%d, %llu, %d) error", game_code, issue_number, draw_times);
        return -1;
    }

    //得到本期次的游戏规则数据(开奖方式)
    int32 draw_type = get_game_issue_draw_type(game_code, issue_number);
    if (draw_type < 0)
    {
        log_error("get_game_issue_draw_type(%d, %llu) failure!", game_code, issue_number);
        return -1;
    }

    money_t adjustMoney = 0;//奖级奖金调整后，存储奖池调整数据
    if (draw_type != INSTANT_GAME)
    {
        //从期次的奖级统计数据中，取得数量统计，
        //只有单注的中奖金额使用OMS录入的，防止出错
        //使用确认调整后的奖级奖金，得到新的奖级奖金数据

        //得到游戏奖级奖金表
        PRIZE_LEVEL prize_level_array[MAX_PRIZE_COUNT];
        memset( (char *)&prize_level_array, 0, sizeof(PRIZE_LEVEL)*MAX_PRIZE_COUNT );
        gd_data = (GIDB_D_DATA *)buffer;
        memset(gd_data, 0, sizeof(GIDB_D_DATA));
        gd_data->field_type = D_WPRIZE_LEVEL_BLOB_KEY;
        ret = d_handle->gidb_d_get_field_blob(d_handle, gd_data);
        if (ret != 0)
        {
            log_error("gidb_d_get_field_blob(%d, %llu, field_type[D_WPRIZE_LEVEL_BLOB_KEY]) error", game_code, issue_number);
            return -1;
        }
        memcpy((char*)prize_level_array, gd_data->data, gd_data->data_len);

        uint32 cnt = gd_data->data_len / sizeof(PRIZE_LEVEL);

        uint32 i = 0;
        uint32 j = 0;
        for (i = 0; i < inm_state_ptr->count; i++)
        {
        	for (j = 0; j < cnt; j++)
            {
                if (inm_state_ptr->prize_list[i].prize_code == prize_level_array[j].prize_code)
                {
                	inm_state_ptr->prize_list[i].count = prize_level_array[j].count;
                    inm_state_ptr->prize_list[i].hflag = prize_level_array[j].hflag;
                    inm_state_ptr->prize_list[i].prize_code = prize_level_array[j].prize_code;

                    adjustMoney += prize_level_array[j].count * (prize_level_array[j].money_amount
                    		- inm_state_ptr->prize_list[i].money_amount);
                    break;
                }
            }
        	if (inm_state_ptr->prize_list[i].count > 0)
        	{
				log_info("prize_code=%d, count=%d, prize_list.money_amount=%lld",
						inm_state_ptr->prize_list[i].prize_code,
						inm_state_ptr->prize_list[i].count,
						inm_state_ptr->prize_list[i].money_amount);
        	}
        }

        log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu]. merge_wprize_table success", step++, game_code, issue_number);
    }

    
    log_info("debug:game_code=%u, issue=%llu, count=%d, prize_code=%d",
    		game_code, issue_number, inm_state_ptr->count, inm_state_ptr->prize_list[0].prize_code);

    //保存确认调整后的奖级奖金数据
    gd_data = (GIDB_D_DATA *)buffer;
    memset(gd_data, 0, sizeof(GIDB_D_DATA));
    gd_data->field_type = D_WPRIZE_LEVEL_CONFIRM_BLOB_KEY;
    gd_data->data_len = inm_state_ptr->count * sizeof(PRIZE_LEVEL);
    memcpy(gd_data->data, (char *)inm_state_ptr->prize_list, gd_data->data_len);
    ret = d_handle->gidb_d_set_field_blob(d_handle, gd_data);
    if (ret != 0)
    {
        log_error("gidb_d_set_field_text(%d, %llu, field_type[D_WPRIZE_LEVEL_CONFIRM_BLOB_KEY]) error", game_code, issue_number);
        return -1;
    }

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    //计算各个奖等总的中奖金额
    money_t total_prize_amount = 0;
    for (uint32 i=0; i<inm_state_ptr->count; ++i)
    {
        total_prize_amount += inm_state_ptr->prize_list[i].count * inm_state_ptr->prize_list[i].money_amount;
    }

    //更新期次资金统计数据 的 奖金总和

    //获取奖池的相关数据
    GL_PRIZE_CALC przCalc;
    memset((char *)&przCalc, 0, sizeof(GL_PRIZE_CALC));
    gd_data = (GIDB_D_DATA *)buffer;
    memset(gd_data, 0, sizeof(GIDB_D_DATA));
    gd_data->field_type = D_WFUND_INFO_BLOB_KEY;
    ret = d_handle->gidb_d_get_field_blob(d_handle, gd_data);
    if (ret != 0)
    {
        log_error("gidb_d_get_field_blob(%d, %llu, field_type[D_WFUND_INFO_BLOB_KEY]) error", game_code, issue_number);
        return -1;
    }
    memcpy(&przCalc, gd_data->data, gd_data->data_len);
    przCalc.prizeAmount = total_prize_amount;
    if (adjustMoney != 0)
    {
    	przCalc.poolUsed.poolAmount += adjustMoney;
    	przCalc.poolUsed.poolAmount += przCalc.highPrize2Adjust;
    	przCalc.highPrize2Adjust = 0;
    	if (przCalc.poolUsed.poolAmount < przCalc.pool.poolAmount)
    	{
    		przCalc.moneyEnough = 0;
    	}

    }

    //保存确认后奖池的相关数据
    gd_data = (GIDB_D_DATA *)buffer;
    memset(gd_data, 0, sizeof(GIDB_D_DATA));
    gd_data->field_type = D_WFUND_INFO_CONFIRM_BLOB_KEY;
    gd_data->data_len = sizeof(GL_PRIZE_CALC);
    memcpy(gd_data->data, (char *)&przCalc, gd_data->data_len);
    ret = d_handle->gidb_d_set_field_blob(d_handle, gd_data);
    if (ret != 0)
    {
        log_error("gidb_d_set_field_text(%d, %llu, field_type[D_WFUND_INFO_CONFIRM_BLOB_KEY]) error", game_code, issue_number);
        return -1;
    }

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    //生成winner.confirm文件所需的数据
    if(a_data == NULL)
    {
    	a_data =(ANNOUNCE_DATA *) malloc(sizeof(ANNOUNCE_DATA));
    	if (a_data == NULL)
    	{
    	    log_error("generate_issue_winner_data malloc return NULL.");
            return -1;
    	}
    }
    memset((char *)a_data, 0, sizeof(ANNOUNCE_DATA));
    a_data->game_code = game_code;
    a_data->issue_number = issue_number;
	ret = generate_issue_winner_data(game_code, issue_number, draw_times, WINNER_CONFIRM_FILE, a_data);
    if (ret != 0)
	{
		log_error("generate_issue_winner_data(game_code[%d], issue_num[%llu], WINNER_CONFIRM_FILE) failed.", game_code, issue_number);
		return -1;
	}

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    //生成winner.confirm的xml文件
	ret = create_winner_file( game_code, issue_number, draw_times, WINNER_CONFIRM_FILE, a_data);
	if (ret != 0)
	{
		log_error("create_winner_file(game_code[%d], issue_num[%llu], WINNER_CONFIRM_FILE) failed.", game_code, issue_number);
		return -1;
	}


    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    //将winner.confirm文件放入本地期次存储
    ret = save_winner_file_for_gidb(game_code, issue_number, draw_times, WINNER_CONFIRM_FILE);
    if (0 > ret)
    {
        log_error("save_winner_file_for_gidb(game_code[%d] issue_num[%llu] WINNER_CONFIRM_FILE) failed.", game_code, issue_number);
        return -1;
    }

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    //将winner.confirm文件保存到OMS的数据库
    if (draw_times == GAME_DRAW_ONE)
    {
        char winFilePath[256] = {0};
        get_game_issue_winner_filepath(winFilePath, game_code, issue_number, draw_times, WINNER_CONFIRM_FILE);
        if ( !otl_set_issue_calc_results(game_code, issue_number, WINNER_CONFIRM_FILE, winFilePath) )
    	{
    		log_error("otl_set_issue_calc_results(game_code[%d] issue_num[%llu]) failed.", game_code, issue_number);
    		return -1;
    	}
    }

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    //更新期次状态
    ret = issue_update_status(self, issue_number, issue_status, draw_times);
    if (ret != 0)
    {
        log_error("update_issue_status(game[%d] issue[%llu] status[%d]) error.", game_code, issue_number, issue_status);
        return -1;
    }

    if (draw_type == INSTANT_GAME)
    {
        //向开奖日志表中发送 其状态变更为 INM_TYPE_ISSUE_STATE_PRIZE_CONFIRMED 的消息
        ret = send_issue_status_message(game_code, issue_number, INM_TYPE_ISSUE_STATE_PRIZE_CONFIRMED, draw_times);
        if (ret < 0)
        {
            log_error("send_issue_status_message(game_code[%d], issue_number[%llu], INM_TYPE_ISSUE_STATE_PRIZE_CONFIRMED) failure.", game_code, issue_number);
            return -1;
        }
    }

	log_info("Exit Issue Process [%d - %lld  %s]--->", game_code, issue_number, ISSUE_STATE_STR(issue_status));
    return 0;
}

int32 gfp_issue_prize_confirmed_process(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf)
{
    int step = 0;
    int ret = 0;

    INM_MSG_ISSUE_STATE *inm_state_ptr = (INM_MSG_ISSUE_STATE *)inm_buf;
    uint8 game_code = self->game_code;
    uint64 issue_number = inm_state_ptr->issueNumber;
    uint8 draw_times = inm_state_ptr->drawTimes;
    int32 issue_status = ISSUE_STATE_PRIZE_CONFIRMED;

    char buf_time[64] = {0};
    fmt_time_t(time(NULL), DATETIME_FORMAT_EN, buf_time);
    log_info("Enter Issue Process [%d - %lld  %s]---> %s", game_code, issue_number, ISSUE_STATE_STR(issue_status), buf_time);

    ret = issue_recover_check(self, issue_number, draw_times, issue_status);
    if (ret == 1)
    {
        //此业务已经处理过
        return 1;
    }

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    static char buffer[4*1024];
    GIDB_D_DATA *gd_data = NULL;

    GIDB_DRAW_HANDLE *d_handle = gidb_d_get_handle(game_code, issue_number, draw_times);
    if (d_handle == NULL)
    {
        log_error("gidb_d_get_handle(%d, %llu, %d) error", game_code, issue_number, draw_times);
        return -1;
    }

    //取得确认后的奖级奖金数据
    PRIZE_LEVEL prize_level_array[MAX_PRIZE_COUNT];
    memset( (char *)&prize_level_array, 0, sizeof(PRIZE_LEVEL)*MAX_PRIZE_COUNT );
    gd_data = (GIDB_D_DATA *)buffer;
    memset(gd_data, 0, sizeof(GIDB_D_DATA));
    gd_data->field_type = D_WPRIZE_LEVEL_CONFIRM_BLOB_KEY;
    ret = d_handle->gidb_d_get_field_blob(d_handle, gd_data);
    if (ret != 0)
    {
        log_error("gidb_d_get_field_blob(%d, %llu, field_type[D_WPRIZE_LEVEL_CONFIRM_BLOB_KEY]) error", game_code, issue_number);
        return -1;
    }
    memcpy((char*)prize_level_array, gd_data->data, gd_data->data_len);

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    //进行中奖票的奖金计算，生成中奖纪录

	//中奖票的统计 winning_stat
	//0:中奖票数量1:大奖票数2:大奖总金额3:小奖票数4:小奖总金额5:中奖总注数6:中奖总金额
	WIN_TICKET_STAT winTktStat;
	memset(&winTktStat, 0, sizeof(winTktStat));
	for (int i = 0; i < MAX_PRIZE_COUNT; i++)
	{
		winTktStat.winBet += prize_level_array[i].count;
	}

    ret = gidb_win_ticket_callback(game_code, issue_number, draw_times, prize_level_array, &winTktStat);
    if ( 0 > ret )
    {
        log_error("gidb_win_ticket_callback(%d, %llu, %d) failed.", game_code, issue_number, draw_times);
        return -1;
    }
    winTktStat.winAmount = winTktStat.bigPrizeAmount + winTktStat.smallPrizeAmount;

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    if (draw_times == GAME_DRAW_ONE)
    {
        //获取确认后的奖池的相关数据
        GL_PRIZE_CALC przCalc;
        memset((char *)&przCalc, 0, sizeof(GL_PRIZE_CALC));
        gd_data = (GIDB_D_DATA *)buffer;
        memset(gd_data, 0, sizeof(GIDB_D_DATA));
        gd_data->field_type = D_WFUND_INFO_CONFIRM_BLOB_KEY;
        ret = d_handle->gidb_d_get_field_blob(d_handle, gd_data);
        if (ret != 0)
        {
            log_error("gidb_d_get_field_blob(%d, %lld, field_type[D_WFUND_INFO_CONFIRM_BLOB_KEY]) error", game_code, issue_number);
            return -1;
        }
        memcpy(&przCalc, gd_data->data, gd_data->data_len);

        log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

        //得到本期次的游戏规则数据(开奖方式)
        int32 draw_type = get_game_issue_draw_type(game_code, issue_number);
        if (draw_type < 0)
        {
            log_error("get_game_issue_draw_type(%d, %llu) failure!", game_code, issue_number);
            return -1;
        }

        log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

        //保存确认后的奖池数据到数据库中
        if (draw_type != MANUAL_EXTERNAL)
        {
    		if ( !otl_set_issue_pool(game_code, issue_number, &przCalc))
    		{
    			log_error("otl_set_issue_pool() failed. gameCode[%d] issue[%llu]", game_code, issue_number);
    			return -1;
    		}
    		log_info("otl_set_issue_pool.gcode[%d] issue[%llu] poolXXX[%lld]",
    				game_code, issue_number, przCalc.poolUsed.poolAmount);
        }

        log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

        //OM要求直接大小奖使用数据库中的高等奖小奖字段
        if ( !otl_set_issue_winning_stat(game_code, issue_number, &winTktStat))
    	{
    		log_error("otl_set_issue_winning_stat() failed. gameCode[%d] issue[%llu]", game_code, issue_number);
    		return -1;
    	}
    }

	log_info("gfp [ %d ]---> game_code[%u] issue_num[%llu].", step++, game_code, issue_number);

    //AP中奖数据上传
    ret = gidb_generate_ap_win_file(game_code, issue_number, draw_times);
    if (0 != ret)
    {
        log_error("gidb_generate_ap_win_file(game_code[%u] issue_num[%llu]) failed.", (uint32)game_code, issue_number);
		return -1;
    }

    //更新期次状态
    ret = issue_update_status(self, issue_number, issue_status, draw_times);
    if (ret != 0)
    {
        log_error("update_issue_status(game[%d] issue[%llu] status[%d]) error.", game_code, issue_number, issue_status);
        return -1;
    }

    //向开奖日志表中发送 其状态变更为 INM_TYPE_ISSUE_STATE_DB_IMPORTED 的消息
    ret = send_issue_status_message(game_code, issue_number, INM_TYPE_ISSUE_STATE_DB_IMPORTED, draw_times);
    if (ret < 0)
    {
        log_error("send_issue_status_message(game_code[%d], issue_number[%llu], INM_TYPE_ISSUE_STATE_DB_IMPORTED) failure.", game_code, issue_number);
        return -1;
    }

	log_info("Exit Issue Process [%d - %llu  %s]--->", game_code, issue_number, ISSUE_STATE_STR(issue_status));
    return 0;
}

int32 gfp_issue_db_imported_process(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf)
{
    int step = 0;
    int ret = 0;

    INM_MSG_ISSUE_STATE *inm_state_ptr = (INM_MSG_ISSUE_STATE *)inm_buf;
    uint8 game_code = self->game_code;
    uint64 issue_number = inm_state_ptr->issueNumber;
    uint8 draw_times = inm_state_ptr->drawTimes;
    int32 issue_status = ISSUE_STATE_DB_IMPORTED;

    char buf_time[64] = {0};
    fmt_time_t(time(NULL), DATETIME_FORMAT_EN, buf_time);
    log_info("Enter Issue Process [%d - %llu  %s]---> %s", game_code, issue_number, ISSUE_STATE_STR(issue_status), buf_time);

    ret = issue_recover_check(self, issue_number, draw_times, issue_status);
    if (ret == 1)
    {
        //此业务已经处理过
        return 1;
    }

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    if (draw_times == GAME_DRAW_ONE)
    {
        char winFile[200] = { 0 };
        char game_abbr[16] = { 0 };
        get_game_abbr(game_code, game_abbr);
        ts_get_game_issue_win_data_filepath(game_abbr, issue_number, inm_state_ptr->drawTimes, winFile, sizeof(winFile));

        // 调用生成 开奖公告 数据库sp, 生成开奖公告
        if ( !otl_set_drawNotice_xml(game_code, issue_number))
        {
            log_error("otl_set_drawNotice_xml() failed, game_code[%d], issue[%llu]", game_code, issue_number);
            return -1;
        }

        //调用中奖文件通知的sp
        if (!otl_send_issue_winfile(game_code, issue_number, winFile))
        {
            log_error("otl_send_issue_winfile() failed, game_code[%d], issue[%lld], file[%s]",
                game_code, issue_number, winFile);
            return -1;
        }

        // 调用生成 TDS 开奖公告 
        if (!otl_set_drawNotice_tds(game_code, issue_number))
        {
            log_error("otl_set_drawNotice_tds() failed, game_code[%d], issue[%llu]", game_code, issue_number);
            return -1;
        }

        //get 开奖公告文件
        char drawAnnouncFile[256] = {0};
        ts_get_game_issue_draw_announce_filepath(game_abbr, issue_number, draw_times, drawAnnouncFile, 256);
        if ( !otl_get_drawNotice_xml(game_code, issue_number, drawAnnouncFile))
        {
            log_error("otl_get_drawNotice_xml() failed, game_code[%d], issue[%llu], file[%s]",
                game_code, issue_number, drawAnnouncFile);
            return -1;
        }

        //保存开奖公告到本地开奖数据表
        ret = save_drawannounce_file_for_gidb(game_code, issue_number, draw_times, drawAnnouncFile);
    	if (0 != ret) {
    		log_error("save_drawannounce_file_for_gidb() failed, game_code[%d], issue[%llu], file[%s]",
                game_code, issue_number, drawAnnouncFile);
    		return -1;
    	}
    }
    else
    {
        //本地生成开奖公告
        char drawAnnouncFile[256] = {0};
        char game_abbr[16];
        get_game_abbr(game_code, game_abbr);
        ts_get_game_issue_draw_announce_filepath(game_abbr, issue_number, draw_times, drawAnnouncFile, 256);

        //等待以后实现，本地生成开奖公告
        ;
        ;
        ;

        
    }

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    //更新期次状态
    ret = issue_update_status(self, issue_number, issue_status, draw_times);
    if (ret != 0)
    {
        log_error("update_issue_status(game[%d] issue[%llu] status[%d]) error.", game_code, issue_number, issue_status);
        return -1;
    }

    //向开奖日志表中发送 其状态变更为 INM_TYPE_ISSUE_STATE_ISSUE_END 的消息
    ret = send_issue_status_message(game_code, issue_number, INM_TYPE_ISSUE_STATE_ISSUE_END, draw_times);
    if (ret < 0)
    {
        log_error("send_issue_status_message(game_code[%d], issue_number[%llu], INM_TYPE_ISSUE_STATE_ISSUE_END) failure.", game_code, issue_number);
        return -1;
    }

	log_info("Exit Issue Process [%d - %llu  %s]--->", game_code, issue_number, ISSUE_STATE_STR(issue_status));
    return 0;
}

int32 gfp_issue_end_process(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf)
{
    int step = 0;
    int ret = 0;

    INM_MSG_ISSUE_STATE *inm_state_ptr = (INM_MSG_ISSUE_STATE *)inm_buf;
    uint8 game_code = self->game_code;
    uint64 issue_number = inm_state_ptr->issueNumber;
    uint8 draw_times = inm_state_ptr->drawTimes;
    int32 issue_status = ISSUE_STATE_ISSUE_END;

    char buf_time[64] = {0};
    fmt_time_t(time(NULL), DATETIME_FORMAT_EN, buf_time);
    log_info("Enter Issue Process [%d - %llu  %s]---> %s", game_code, issue_number, ISSUE_STATE_STR(issue_status), buf_time);

    ret = issue_recover_check(self, issue_number, draw_times, issue_status);
    if (ret == 1)
    {
        //此业务已经处理过
        return 1;
    }

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);

    //更新期次状态
    ret = issue_update_status(self, issue_number, issue_status, draw_times);
    if (ret != 0)
    {
        log_error("update_issue_status(game[%d] issue[%llu] status[%d]) error.", game_code, issue_number, issue_status);
        return -1;
    }

    //insert 自动兑奖 记录
    GIDB_DRIVERLOG_HANDLE *driverlog_handle = gidb_driverlog_get_handle();
    if (driverlog_handle == NULL)
    {
        log_error("gidb_driverlog_get_handle(%d) error");
        return -1;
    }

    char msg[1024] = {0};
    int msglen = sprintf(msg, "1:%lu", issue_number);
    ret = driverlog_handle->gidb_driverlog_append_dl(driverlog_handle, game_code, issue_number, 0, INM_TYPE_AP_AUTODRAW, msg, msglen);
    if (ret < 0)
    {
        log_error("gidb_driverlog_get_handle(%d) type[%d] error", game_code, INM_TYPE_AP_AUTODRAW);
        return -1;
    }


    //向NCPC发送一条期结的消息，用于广播开奖公告
    if (draw_times == GAME_DRAW_ONE)
    {
        if ( SYS_STATUS_BUSINESS == sysdb_getSysStatus() )
    	{
    	    static char draw_buffer[16*1024];
            memset(draw_buffer, 0, 16*1024);
            INM_MSG_T_DRAW_ANNOUNCE_UNS *pInm_msg = (INM_MSG_T_DRAW_ANNOUNCE_UNS *)draw_buffer;
            pInm_msg->header.inm_header.type = INM_TYPE_T_DRAW_ANNOUNCE_UNS;
            pInm_msg->header.inm_header.gltp_type = GLTP_MSG_TYPE_TERMINAL_UNS;
            pInm_msg->header.inm_header.gltp_func = GLTP_T_UNS_DRAW_ANNOUNCE;
            pInm_msg->header.inm_header.status = SYS_RESULT_SUCCESS;
            pInm_msg->header.inm_header.when = get_now();
            pInm_msg->gameCode = game_code;
            pInm_msg->issueNumber = issue_number;
            pInm_msg->issueTimeStamp = time(NULL);

            static char buffer[8*1024];
            GIDB_DRAW_HANDLE *d_handle = gidb_d_get_handle(game_code, issue_number, draw_times);
            if (d_handle == NULL)
            {
                log_error("gidb_d_get_handle(%d, %llu, %d) error", game_code, issue_number, draw_times);
                return -1;
            }
            //获取开奖号码字符串
            GIDB_D_DATA *gd_data = (GIDB_D_DATA *)buffer;
            memset(gd_data, 0, sizeof(GIDB_D_DATA));
            gd_data->field_type = DRAW_CODE_TEXT_KEY;
            ret = d_handle->gidb_d_get_field_text(d_handle, gd_data);
            if (ret != 0)
            {
                log_error("gidb_d_get_field_text(%d, %llu, field_type[DRAW_CODE_TEXT_KEY]) error", game_code, issue_number);
                return -1;
            }
            pInm_msg->drawCodeLen = gd_data->data_len;
            strncpy(pInm_msg->drawCode, gd_data->data, gd_data->data_len);
            //获取开奖公告
            memset(gd_data, 0, sizeof(GIDB_D_DATA));
            gd_data->field_type = DRAW_ANNOUNCE_TEXT_KEY;
            ret = d_handle->gidb_d_get_field_text(d_handle, gd_data);
            if (ret != 0)
            {
                log_error("gidb_d_get_field_text(%d, %llu, field_type[DRAW_ANNOUNCE_TEXT_KEY]) error", game_code, issue_number);
                return -1;
            }
            pInm_msg->drawAnnounceLen = gd_data->data_len;
            strncpy(pInm_msg->drawAnnounce, gd_data->data, gd_data->data_len);

            pInm_msg->header.inm_header.length = sizeof(INM_MSG_T_DRAW_ANNOUNCE_UNS) + pInm_msg->drawAnnounceLen;

            FID ncpc_fid = getFidByName("ncpsend_queue");
            ret = bq_send(ncpc_fid, draw_buffer, pInm_msg->header.inm_header.length);
            if (ret <= 0)
            {
                log_error("gl_draw send draw announce failure. game[%d] issue_number[%llu]", game_code, issue_number);
                return -1;
            }
    	}
    }

    log_info("Exit Issue Process [%d - %llu  %s]--->", game_code, issue_number, ISSUE_STATE_STR(issue_status));
    return 0;
}


//放弃本次开奖流程，对本期次重新开奖
int32 gfp_do_issue_draw_redo_process(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf)
{
    int step = 0;
    int ret = 0;

    INM_MSG_ISSUE_STATE *inm_state_ptr = (INM_MSG_ISSUE_STATE *)inm_buf;
    uint8 game_code = self->game_code;
    uint64 issue_number = inm_state_ptr->issueNumber;
    uint8 draw_times = inm_state_ptr->drawTimes;

    char buf_time[64] = {0};
    fmt_time_t(time(NULL), DATETIME_FORMAT_EN, buf_time);
    log_info("Enter Issue Process [ISSUE_REDO_DRAW  %d - %llu]---> %s", game_code, issue_number, buf_time);

    GIDB_DRAW_HANDLE *d_handle = gidb_d_get_handle(game_code, issue_number, draw_times);
    if (d_handle == NULL)
    {
        log_error("gidb_d_get_handle(%d, %llu, %d) error", game_code, issue_number, draw_times);
        return -1;
    }

    //从开奖过程表中得到当前开奖的状态
    static char buffer[4*1024];
    GIDB_D_DATA *gd_data = (GIDB_D_DATA *)buffer;
    memset(gd_data, 0, sizeof(GIDB_D_DATA));
    ret = d_handle->gidb_d_get_status(d_handle, gd_data);
    if (ret != 0)
    {
        log_error("");
        return -1;
    }
    if (gd_data->status >= ISSUE_STATE_PRIZE_CONFIRMED)
    {
        log_info("Exit Issue Process [ISSUE_REDO_DRAW.  Not allow REDO ]---> game_code[%d] issue_number[%lld]", game_code, issue_number);
        return 0;
    }

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);


    //用于重新开奖时，清理开奖过程数据和票匹配数据
    d_handle->gidb_d_cleanup(d_handle);

    //删除期结过程的相关文件

    //删除winner.local.xml
    char winLocalFile[256] = {0};
    get_game_issue_winner_filepath(winLocalFile, game_code, issue_number, draw_times, WINNER_LOCAL_FILE);
    ret = rmdirs(winLocalFile);
    if (0 != ret)
    {
    	log_error("rmdirs fail. filename:%s", winLocalFile);
    }

    //删除winner.local.xml.tmp
    char winLocalTmpFile[256] = {0};
    get_game_issue_winner_filepath(winLocalTmpFile, game_code, issue_number, draw_times, WINNER_LOCAL_FILE);
    strcat(winLocalTmpFile, ".tmp");
    ret = rmdirs(winLocalTmpFile);
    if (0 != ret)
    {
    	log_error("rmdirs fail. filename:%s", winLocalTmpFile);
    }

    //删除winner.confirm.xml文件
    char winConfirmFile[256] = {0};
    get_game_issue_winner_filepath(winConfirmFile, game_code, issue_number, draw_times, WINNER_CONFIRM_FILE);
    ret = rmdirs(winConfirmFile);
    if (0 != ret)
    {
    	log_error("rmdirs fail. filename:%s", winConfirmFile);
    }

    //删除issue_YYY_draw_announce.xml
    char drawAnnounceFile[256] = {0};
    char game_abbr[16];
    get_game_abbr(game_code, game_abbr);
    ts_get_game_issue_draw_announce_filepath(game_abbr, issue_number, draw_times, drawAnnounceFile, 256);
    ret = rmdirs(drawAnnounceFile);
    if (0 != ret)
    {
    	log_error("rmdirs fail. filename:%s", drawAnnounceFile);
    }

    //删除期中奖文件
    char issueWinFile[256] = {0};
    ts_get_game_issue_win_data_filepath(game_abbr, issue_number, draw_times, issueWinFile, 256);
    ret = rmdirs(issueWinFile);
    if (0 != ret)
    {
    	log_error("rmdirs fail. filename:%s", issueWinFile);
    }

    log_info("gfp [ %d ]---> game_code[%d] issue_number[%llu].", step++, game_code, issue_number);


    //更新数据库状态
    time_t t = time(NULL);
    if (draw_times == GAME_DRAW_ONE)
    {
        if (!otl_set_issue_status(game_code, issue_number, ISSUE_STATE_SEALED, t))
        {
            log_error("otl_set_issue_status(game_code[%u] issue_number[%llu] issue_status[%d] ) failed.",
                game_code, issue_number, ISSUE_STATE_SEALED);
            return -1;
        }

#if 0
        GIDB_ISSUE_HANDLE *i_handle = gidb_i_get_handle(game_code);
        if (i_handle == NULL)
        {
            log_error("gidb_i_get_handle(%d) error", game_code);
            return -1;
        }
        //更新内存期次状态
        ret = i_handle->gidb_i_set_status(i_handle, issue_number, ISSUE_STATE_SEALED, t);
        if (ret != 0)
        {
            log_error("gidb_i_set_status(%d, %lld, %d) error", game_code, issue_number, ISSUE_STATE_SEALED);
            return -1;
        }

        //更新内存期次状态
        if (sysdb_getSysStatus() == SYS_STATUS_BUSINESS)
        {
            ISSUE_INFO *is_info = self->plugin_handle->get_issueInfo(issue_number);
            if ( NULL == is_info )
            {
                log_error("get_issueInfo(game_code[%u] issue_num[%llu]) return NULL.", game_code, issue_number);
                return -1;
            }
            is_info->curState = ISSUE_STATE_SEALED;
        }
#endif
    }

    log_info("Exit Issue Process [ISSUE_REDO_DRAW %d - %llu]--->", game_code, issue_number);
    return 0;
}

int32 gfp_do_verify_issue_salefile_md5sum(GAME_FLOW_PROCESSOR *self, INM_MSG_HEADER *inm_buf)
{
    int ret = 0;

    INM_MSG_ISSUE_SALE_FILE_MD5SUM *inm_state_ptr = (INM_MSG_ISSUE_SALE_FILE_MD5SUM *)inm_buf;
    uint8 game_code = self->game_code;
    uint64 issue_number = inm_state_ptr->issueNumber;
    uint8 draw_times = inm_state_ptr->drawTimes;

    char buf_time[64] = {0};
    fmt_time_t(time(NULL), DATETIME_FORMAT_EN, buf_time);
    log_info("Enter Issue Process [ISSUE_VERIFY_SALE_TICKET_MD5  %d - %llu]---> %s", game_code, issue_number, buf_time);

    GIDB_DRAW_HANDLE *d_handle = gidb_d_get_handle(game_code, issue_number, draw_times);
    if (d_handle == NULL)
    {
        log_error("gidb_d_get_handle(%d, %llu, %d) error", game_code, issue_number, draw_times);
        return -1;
    }

    //从开奖过程表中得到当前开奖的状态
    static char buffer[4*1024];
    GIDB_D_DATA *gd_data = (GIDB_D_DATA *)buffer;
    memset(gd_data, 0, sizeof(GIDB_D_DATA));
    ret = d_handle->gidb_d_get_status(d_handle, gd_data);
    if (ret != 0)
    {
        log_error("");
        return -1;
    }
    if (gd_data->status < ISSUE_STATE_SEALED)
    {
        log_info("Exit Issue Process [ISSUE_VERIFY_SALE_TICKET_MD5.  Issue not sealed ]---> game_code[%d] issue_number[%llu]", game_code, issue_number);
        return -1;
    }

    //得到游戏开奖类型
    int32 draw_type = get_game_issue_draw_type(game_code, issue_number);
    if (draw_type < 0)
    {
        log_error("get_game_issue_draw_type(%d, %llu) failure!", game_code, issue_number);
        return -1;
    }

    //手工开奖游戏进行md5的数据校验
    if (draw_type != INSTANT_GAME)
    {
        char filepath[256] = {0};
        char game_abbr[16];
        get_game_abbr(game_code, game_abbr);
        ts_get_game_issue_ticket_filepath(game_abbr, issue_number, filepath, 256);

        char md5_str[64];
        ret = get_md5_file(filepath, md5_str);
        if (ret < 0)
        {
            log_error("get_md5_file(%s) failure!", filepath);
            return -1;
        }

        /*
        if ( 0 != memcmp(md5_str, inm_state_ptr->md5sum, 32))
        {
            log_error("md5 check file(%s) failure!", filepath);
            return -1;
        }
        */
    }

    log_info("Exit Issue Process [ISSUE_VERIFY_SALE_TICKET_MD5 %d - %llu]--->", game_code, issue_number);
    return 0;
}


//静态分配的GAME_FLOW_PROCESSOR数组
static GAME_FLOW_PROCESSOR gfp_handle[MAX_GAME_NUMBER];

//初始化游戏编码为game_code的GAME_FLOW_PROCESSOR结构体
int32 gfp_init(uint8 game_code)
{
    GAME_FLOW_PROCESSOR *handle = &gfp_handle[game_code];
    memset((char *)handle, 0, sizeof(GAME_FLOW_PROCESSOR));

    //获得没有attach共享内存的gl_plugin_handle
    handle->game_code = game_code;
    handle->plugin_handle = gl_plugins_handle_s(game_code);
    if (handle->plugin_handle == NULL)
    {
        log_error("gl_plugins_handle_s(%d) failed.", game_code);
        return -1;
    }

    //挂载期结相关的业务的函数指针
    handle->issue_sealed = gfp_issue_sealed_process;
    handle->issue_drawnum_inputed = gfp_issue_drawnum_inputed_process;
    handle->issue_matched = gfp_issue_matched_process;
    handle->issue_fund_inputed = gfp_issue_fund_inputed_process;
    handle->issue_local_calced = gfp_issue_local_calced_process;
    handle->issue_prize_adjusted = gfp_issue_prize_adjusted_process;
    handle->issue_prize_confirmed = gfp_issue_prize_confirmed_process;
    handle->issue_db_imported = gfp_issue_db_imported_process;
    handle->issue_end = gfp_issue_end_process;

    handle->do_issue_draw_redo = gfp_do_issue_draw_redo_process;
    handle->do_verify_salefile_md5sum = gfp_do_verify_issue_salefile_md5sum;

    handle->init = true;

    return 0;
}

GAME_FLOW_PROCESSOR *gfp_get_handle(uint8 game_code)
{
    GAME_FLOW_PROCESSOR *handle = &gfp_handle[game_code];
    if (handle->init == 0)
    {
        if (gfp_init(game_code) < 0)
        {
            log_error("gfp_init( game[%d]) failed.", game_code);
            return NULL;
        }
    }
    return handle;
}

int32 gfp_close_handle(uint8 game_code)
{
    GAME_FLOW_PROCESSOR *handle = &gfp_handle[game_code];
    handle->init = false;
    return 0;
}





//============以下函数(5个)winner local/confirm xml======begin===============
int get_game_issue_winner_filepath(char *filepath, uint8 game_code, uint64 issue_number, uint8 draw_times, uint8 flag)
{
    char game_abbr[16];
    get_game_abbr(game_code, game_abbr);
    ts_get_game_draw_dir(game_abbr, filepath, 256);
    if ( WINNER_LOCAL_FILE == flag )
        if (draw_times == GAME_DRAW_ONE)
            sprintf(filepath, "%s/issue_%llu_winner_local.xml", filepath, issue_number);
        else
            sprintf(filepath, "%s/issue_%llu_winner_local___%d.xml", filepath, issue_number, draw_times);
    else
        if (draw_times == GAME_DRAW_ONE)
            sprintf(filepath, "%s/issue_%llu_winner_confirm.xml", filepath, issue_number);
        else
            sprintf(filepath, "%s/issue_%llu_winner_confirm___%d.xml", filepath, issue_number, draw_times);
    return 0;
}

//save匹配时的高等奖统计信息(销售站)
int32 save_high_prize_info_tmp(uint8 game_code, uint64 issue_number, uint8 draw_times, ANNOUNCE_HIGH_PRIZE *aHighPrize)
{
    char winLocalFile_tmp[256];
    get_game_issue_winner_filepath(winLocalFile_tmp, game_code, issue_number, draw_times, WINNER_LOCAL_FILE);
    strcat(winLocalFile_tmp, ".tmp");

    //将高等奖信息写入临时文件
	char str[200] = {0};
    FILE *fp = fopen(winLocalFile_tmp, "wb");
    if (fp == NULL)
    {
    	log_info("debug:%s",winLocalFile_tmp);
    	return -1;
    }
    for (int i = 0; i < MAX_PRIZE_COUNT; i++)
    {
    	//0: break
    	if (0 == aHighPrize[i].prize_level)
    	{
    		continue;
    	}

    	//gamecode, issuenum, prize_level, agency_count
    	memset(str, 0, sizeof(str));
    	sprintf(str, "%u,%llu,%d,%u\n",
    			game_code,
    			issue_number,
    			aHighPrize[i].prize_level,
    			aHighPrize[i].agency_count);
		if(EOF == fputs(str, fp))
		{
			fclose(fp);
			log_error("fputs:%s",str);
			return -1;
		}

    	for(uint32 j = 0; j < aHighPrize[i].agency_count; j++)
    	{
    		//0: break
    		if (0 == aHighPrize[i].agency[j].agency_code)
    		{
    			break;
    		}
    		//agencycode, agencyid, winnercount
    		memset(str, 0, sizeof(str));
			sprintf(str, "%llu,%u\n",
					aHighPrize[i].agency[j].agency_code,
					aHighPrize[i].agency[j].winner_count);
			if(EOF == fputs(str, fp))
			{
				fclose(fp);
				log_error("fputs:%s",str);
				return -1;
			}
    	}
    }
    fclose(fp);
    return 0;
}


//get匹配时的高等奖统计信息(销售站)
int32 get_high_prize_info_tmp(uint8 game_code, uint64 issue_number, uint8 draw_times, ANNOUNCE_HIGH_PRIZE *aHighPrize)
{
    char winLocalFile_tmp[256];
    get_game_issue_winner_filepath(winLocalFile_tmp, game_code, issue_number, draw_times, WINNER_LOCAL_FILE);
    strcat(winLocalFile_tmp, ".tmp");

    //从临时文件中读取高等奖信息
	char str[200] = {0};//存储文件读取结果
	uint64 str2[200] = {0};//存储str分解后结果
    FILE *fp = fopen(winLocalFile_tmp, "rb");
    if (fp == NULL)
    {
    	log_info("debug:%s",winLocalFile_tmp);
    	return -1;
    }

    int przIdx = 0;
    while (NULL != fgets(str, sizeof(str), fp) )//get: gamecode, issuenum, prize_level, agency_count
    {
        uint32 i = 0;
        uint32 j = 0;
        memset(str2, 0, sizeof(str2));

    	//split str to str2
    	char *p = NULL;
    	char *last = NULL;
    	p = strtok_r(str, ",", &last);
        for(i = 0; ; i++)
        {
        	if (p == NULL)
        	{
        		break;
        	}

        	str2[i] = atoll(p);
        	p = strtok_r(NULL, ",", &last);
        }

        aHighPrize[przIdx].prize_level  = str2[2];
        aHighPrize[przIdx].agency_count = str2[3];

        for (j = 0; j < aHighPrize[przIdx].agency_count; j++)
        {
        	memset(str2, 0, sizeof(str2));
        	if ( NULL == fgets(str, sizeof(str), fp) )//get: agencycode, agencyid, winnercount
        	{
        		log_error("fgets: not enough. j[%d]", j);
        		fclose(fp);
        		return -1;
        	}

        	//split str to str2
        	p = strtok_r(str, ",", &last);
			for(i = 0; ; i++)
			{
				if (p == NULL)
				{
					break;
				}

				str2[i] = atoll(p);
				p = strtok_r(NULL, ",", &last);
			}

			aHighPrize[przIdx].agency[j].agency_code  = str2[0];
			aHighPrize[przIdx].agency[j].winner_count = str2[1];
        }

    	memset(str, 0, sizeof(str));
    	przIdx++;
    }
    fclose(fp);
    return 0;
}

//flag  WINNER_LOCAL_FILE = local   WINNER_CONFIRM_FILE = confirm
int32 generate_issue_winner_data(uint8 game_code, uint64 issue_number, uint8 draw_times, uint8 flag, ANNOUNCE_DATA* pData)
{
    int32 ret = 0;

    GIDB_DRAW_HANDLE *d_handle = gidb_d_get_handle(game_code, issue_number, draw_times);
    if (d_handle == NULL)
    {
        log_error("gidb_d_get_handle(%d, %llu, %d) error", game_code, issue_number, draw_times);
        return -1;
    }

    char buffer[4*1024];

    //取得开奖号码
    GIDB_D_DATA *gd_data = (GIDB_D_DATA *)buffer;
    memset(gd_data, 0, sizeof(buffer));
    gd_data->field_type = DRAW_CODE_TEXT_KEY;
    ret = d_handle->gidb_d_get_field_text(d_handle, gd_data);
    if (ret != 0)
    {
        log_error("gidb_d_get_field_text(%d, %llu, field_type[DRAW_CODE_TEXT_KEY]) error", game_code, issue_number);
        return -1;
    }
    strncpy(pData->drawCodesStr, gd_data->data, gd_data->data_len);

    //取得期次销售额
    TICKET_STAT ts;
    gd_data = (GIDB_D_DATA *)buffer;
    memset(gd_data, 0, sizeof(buffer));
    gd_data->field_type = D_TICKETS_STAT_BLOB_KEY;
    ret = d_handle->gidb_d_get_field_blob(d_handle, gd_data);
    if (ret != 0)
    {
        log_error("gidb_d_get_field_blob(%d, %llu, field_type[D_TICKETS_STAT_BLOB_KEY]) error", game_code, issue_number);
        return -1;
    }
    memcpy(&ts, gd_data->data, gd_data->data_len);
    pData->sale_total_amount = ts.s_amount;

    // 取得剩余奖池金额
    GL_PRIZE_CALC przCalc;
    memset((char *)&przCalc, 0, sizeof(GL_PRIZE_CALC));
    gd_data = (GIDB_D_DATA *)buffer;
    memset(gd_data, 0, sizeof(GIDB_D_DATA));
    gd_data->field_type = D_WFUND_INFO_BLOB_KEY;
    if ( WINNER_CONFIRM_FILE == flag )
    {
    	gd_data->field_type = D_WFUND_INFO_CONFIRM_BLOB_KEY;
    }
    ret = d_handle->gidb_d_get_field_blob(d_handle, gd_data);
    if (ret != 0)
    {
        log_error("gidb_d_get_field_blob(%d, %llu, field_type[D_WFUND_INFO_BLOB_KEY]) error", game_code, issue_number);
        return -1;
    }
    memcpy(&przCalc, gd_data->data, gd_data->data_len);
    pData->pool_left_amount = przCalc.poolUsed.poolAmount + przCalc.pool.poolAmount;
    pData->pool_amount = przCalc.pool.poolAmount;

    //得到游戏奖级奖金表
    int32 field = D_WPRIZE_LEVEL_BLOB_KEY;
    if ( WINNER_CONFIRM_FILE == flag )
    {
        field = D_WPRIZE_LEVEL_CONFIRM_BLOB_KEY;
    }
    PRIZE_LEVEL prize_level_array[MAX_PRIZE_COUNT];
    memset( (char *)&prize_level_array, 0, sizeof(PRIZE_LEVEL)*MAX_PRIZE_COUNT );
    gd_data = (GIDB_D_DATA *)buffer;
    memset(gd_data, 0, sizeof(GIDB_D_DATA));
    gd_data->field_type = field;
    ret = d_handle->gidb_d_get_field_blob(d_handle, gd_data);
    if (ret != 0)
    {
        if (field == D_WPRIZE_LEVEL_BLOB_KEY)
        {
        	log_error("gidb_d_get_field_blob(%d, %lld, field_type[D_WPRIZE_LEVEL_BLOB_KEY]) error", game_code, issue_number);
        }
		else if (field == D_WPRIZE_LEVEL_CONFIRM_BLOB_KEY)
        {
        	log_error("gidb_d_get_field_blob(%d, %lld, field_type[D_WPRIZE_LEVEL_CONFIRM_BLOB_KEY]) error", game_code, issue_number);
        }
        return -1;
    }
    memcpy((char*)prize_level_array, gd_data->data, gd_data->data_len);


    GIDB_T_TICKET_HANDLE *t_handle = gidb_t_get_handle(game_code, issue_number);
    if (t_handle == NULL)
    {
        log_error("gidb_t_get_handle() failure! game[%d] issue_number[%llu]", game_code, issue_number);
        return -1;
    }
    //取得期次封存的奖级表
    char prize_buf[4*1024];
    memset(prize_buf, 0, 4*1024);
    int32 prize_buf_len = 0;
    ret = t_handle->gidb_t_get_field_blob(t_handle, T_PRIZE_PARAMBLOB_KEY, prize_buf, &prize_buf_len);
    if (ret != 0)
    {
        log_error("gidb_t_get_field_blob(%d, %llu, T_PRIZE_PARAMBLOB_KEY) failure!", game_code, issue_number);
        return -1;
    }
    //得到期次封存的游戏规则数据
    static char game_buf[4*1024];
    int32 game_buf_len = 0;
    ret = t_handle->gidb_t_get_field_blob(t_handle, T_GAME_PARAMBLOB_KEY, game_buf, &game_buf_len);
    if (ret != 0)
    {
        log_error("gidb_t_get_field_blob(%d, %llu, T_GAME_PARAMBLOB_KEY) failure!", game_code, issue_number);
        return -1;
    }
    GT_GAME_PARAM *game_param = (GT_GAME_PARAM *)game_buf;


    money_t tax_amount = 0;
	money_t aftertax_amount = 0;
    int i = 0;
    int j = 0;
    PRIZE_PARAM *prize_ptr = ((GT_PRIZE_PARAM *)prize_buf)->prize_param;
    for (j = 0; j < MAX_PRIZE_COUNT; j++)
    {
        tax_amount = 0;
        aftertax_amount = 0;

    	//get prize name
        PRIZE_PARAM *prize_param = &prize_ptr[prize_level_array[j].prize_code];
        if (prize_param->used)
        {
			if (prize_level_array[j].money_amount >= game_param->taxStartAmount)
			{
				tax_amount = prize_level_array[j].money_amount * game_param->taxRate/1000;
			}

			aftertax_amount = prize_level_array[j].money_amount - tax_amount;

			pData->prize_count++;
			pData->prizeArray[i].prize_level = prize_level_array[j].prize_code;
			pData->prizeArray[i].is_high_prize = (uint8)prize_param->hflag;
			pData->prizeArray[i].prize_num = prize_level_array[j].count;
			pData->prizeArray[i].prize_amount = prize_level_array[j].money_amount;
			pData->prizeArray[i].prize_after_tax_amount = aftertax_amount;
			pData->prizeArray[i].prize_tax_amount = tax_amount;
			pData->prize_total_amount += prize_level_array[j].money_amount * prize_level_array[j].count;
			i++;
		}
    }

    //得到游戏期次高等奖信息(从之前保存的期次临时文件中读取)
    //ANNOUNCE_HIGH_PRIZE a_high_prize[MAX_PRIZE_COUNT];
    //pData->a_high_prize
    //用此函数保存的 save_high_prize_info()
    ret = get_high_prize_info_tmp(game_code, issue_number, draw_times, pData->a_high_prize);
    if (ret != 0)
    {
        log_error("get_high_prize_info_tmp() failed.gamecode[%u],issue[%llu]", game_code, issue_number);
        return -1;
    }
    return 0;
}

//根据 ANNOUNCE_DATA 数据，生成XML文件 < winner_local   or   winner_confirm >
int32 create_winner_file(uint8 game_code, uint64 issue_number, uint8 draw_times, uint8 flag, ANNOUNCE_DATA* pData)
{
    char winFilePath[256];
    get_game_issue_winner_filepath(winFilePath, game_code, issue_number, draw_times, flag);

    int ret = rmdirs(winFilePath);
    if (0 != ret) {
    	log_error("rmdirs fail. filename:%s", winFilePath);
    	return -1;
    }

    //从 ANNOUNCE_DATA 中获取数据，创建winner文件
	XML *xmlFile = new XML(winFilePath);
	XMLElement *elRoot      = NULL;
	XMLElement *elRootLeaf  = NULL;

	//prize
	XMLElement *elPrizes    = NULL;
	XMLElement *elPrize     = NULL;
	XMLElement *elPrizeLeaf = NULL;

	//high prize
	XMLElement *elHPrizes    = NULL;
	XMLElement *elHPrize 	 = NULL;
	XMLElement *elHPrizeLeaf = NULL;
	XMLElement *elHLocations = NULL;
	XMLElement *elHLocation  = NULL;
	XMLElement *elHLLeaf 	 = NULL;

#define contLen  99
	char xmlContent[contLen + 1] = {0};

	ANNOUNCE_XML_EL xmlEl;
	memset(&xmlEl, 0, sizeof(xmlEl));

	xmlEl.game_draw          = new XMLElement(0, "game_draw");
	xmlEl.game_code 		 = new XMLElement(0, "game_code");
	xmlEl.issue_number 		 = new XMLElement(0, "issue_number");
	xmlEl.draw_result 		 = new XMLElement(0, "draw_result");
	xmlEl.sale_total_amount  = new XMLElement(0, "sale_total_amount");
	xmlEl.prize_total_amount = new XMLElement(0, "prize_total_amount");
	xmlEl.pool_amount   	 = new XMLElement(0, "pool_amount");
	xmlEl.pool_left_amount   = new XMLElement(0, "pool_left_amount");
	xmlEl.prizes 			 = new XMLElement(0, "prizes");
	for (int i = 0; i < pData->prize_count; i++)
	{
		xmlEl.prize[i]                   = new XMLElement(0, "prize");
	    xmlEl.prize_level[i] 			 = new XMLElement(0, "prize_level");
	    xmlEl.is_high_prize[i] 		 	 = new XMLElement(0, "is_high_prize");
	    xmlEl.prize_num[i] 				 = new XMLElement(0, "prize_num");
	    xmlEl.prize_amount[i] 			 = new XMLElement(0, "prize_amount");
	    xmlEl.prize_after_tax_amount[i]  = new XMLElement(0, "prize_after_tax_amount");
	    xmlEl.prize_tax_amount[i] 		 = new XMLElement(0, "prize_tax_amount");
	}


	uint32 highPrizeCnt = 0;
	for (int i = 0; i < pData->prize_count; i++)
	{
		if (pData->a_high_prize[i].prize_level == 0)
		{
			break;
		}
		highPrizeCnt++;
	}

	xmlEl.high_prizes_2 			 = new XMLElement(0, "high_prizes");
	for (uint32 i = 0; i < highPrizeCnt; i++)
	{
		xmlEl.high_prize_2[i]   		 = new XMLElement(0, "high_prize");
		xmlEl.prize_level_2[i]   		 = new XMLElement(0, "prize_level");
		xmlEl.locations_2[i]   		 	 = new XMLElement(0, "locations");
		for (uint32 j = 0; j < pData->a_high_prize[i].agency_count; j++)
		{
			xmlEl.location_2[i][j]   		 = new XMLElement(0, "location");
			xmlEl.agency_code_2[i][j]   	 = new XMLElement(0, "agency_code");
			xmlEl.count_2[i][j]   		     = new XMLElement(0, "count");
		}
	}


	xmlFile->SetRootElement(xmlEl.game_draw);
	elRoot = xmlFile->GetRootElement();

	elRootLeaf = elRoot->AddElement(xmlEl.game_code);
	memset(xmlContent, 0, sizeof(xmlContent));
	snprintf(xmlContent, contLen, "%u", pData->game_code);
	elRootLeaf->AddContent(xmlContent, 0);

	elRootLeaf = elRoot->AddElement(xmlEl.issue_number);
	memset(xmlContent, 0, sizeof(xmlContent));
	snprintf(xmlContent, contLen, "%llu", pData->issue_number);
	elRootLeaf->AddContent(xmlContent, 0);

	elRootLeaf = elRoot->AddElement(xmlEl.draw_result);
	elRootLeaf->AddContent(pData->drawCodesStr, 0);

	elRootLeaf = elRoot->AddElement(xmlEl.sale_total_amount);
	memset(xmlContent, 0, sizeof(xmlContent));
	snprintf(xmlContent, contLen, "%lld", pData->sale_total_amount);
	elRootLeaf->AddContent(xmlContent, 0);

	elRootLeaf = elRoot->AddElement(xmlEl.prize_total_amount);
	memset(xmlContent, 0, sizeof(xmlContent));
	snprintf(xmlContent, contLen, "%lld", pData->prize_total_amount);
	elRootLeaf->AddContent(xmlContent, 0);

	elRootLeaf = elRoot->AddElement(xmlEl.pool_amount);
	memset(xmlContent, 0, sizeof(xmlContent));
	snprintf(xmlContent, contLen, "%lld", pData->pool_amount);
	elRootLeaf->AddContent(xmlContent, 0);

	elRootLeaf = elRoot->AddElement(xmlEl.pool_left_amount);
	memset(xmlContent, 0, sizeof(xmlContent));
	snprintf(xmlContent, contLen, "%lld", pData->pool_left_amount);
	elRootLeaf->AddContent(xmlContent, 0);

	elPrizes = elRoot->AddElement(xmlEl.prizes);
	for (int i = 0; i < pData->prize_count; i++)
	{
		elPrize = elPrizes->AddElement(xmlEl.prize[i]);

		elPrizeLeaf = elPrize->AddElement(xmlEl.prize_level[i]);
		memset(xmlContent, 0, sizeof(xmlContent));
		snprintf(xmlContent, contLen, "%d", pData->prizeArray[i].prize_level);
		elPrizeLeaf->AddContent(xmlContent, 0);

		elPrizeLeaf = elPrize->AddElement(xmlEl.is_high_prize[i]);
		memset(xmlContent, 0, sizeof(xmlContent));
		snprintf(xmlContent, contLen, "%d", pData->prizeArray[i].is_high_prize);
		elPrizeLeaf->AddContent(xmlContent, 0);

		elPrizeLeaf = elPrize->AddElement(xmlEl.prize_num[i]);
		memset(xmlContent, 0, sizeof(xmlContent));
		snprintf(xmlContent, contLen, "%u", pData->prizeArray[i].prize_num);
		elPrizeLeaf->AddContent(xmlContent, 0);

		elPrizeLeaf = elPrize->AddElement(xmlEl.prize_amount[i]);
		memset(xmlContent, 0, sizeof(xmlContent));
		snprintf(xmlContent, contLen, "%lld", pData->prizeArray[i].prize_amount);
		elPrizeLeaf->AddContent(xmlContent, 0);

		elPrizeLeaf = elPrize->AddElement(xmlEl.prize_after_tax_amount[i]);
		memset(xmlContent, 0, sizeof(xmlContent));
		snprintf(xmlContent, contLen, "%lld", pData->prizeArray[i].prize_after_tax_amount);
		elPrizeLeaf->AddContent(xmlContent, 0);

		elPrizeLeaf = elPrize->AddElement(xmlEl.prize_tax_amount[i]);
		memset(xmlContent, 0, sizeof(xmlContent));
		snprintf(xmlContent, contLen, "%lld", pData->prizeArray[i].prize_tax_amount);
		elPrizeLeaf->AddContent(xmlContent, 0);
	}

	//high prizeS
	elHPrizes = elRoot->AddElement(xmlEl.high_prizes_2);

	for (uint32 i = 0; i < highPrizeCnt; i++)
	{
		int m = 0;
		elHPrize = elHPrizes->AddElement(xmlEl.high_prize_2[i]);

		elHPrizeLeaf = elHPrize->AddElement(xmlEl.prize_level_2[i]);
		memset(xmlContent, 0, sizeof(xmlContent));
		snprintf(xmlContent, contLen, "%d", pData->a_high_prize[i].prize_level);
		elHPrizeLeaf->AddContent(xmlContent, 0);

		elHLocations = elHPrize->AddElement(xmlEl.locations_2[i]);

		for (int j = 0; j < MAX_AGENCY_NUMBER; j++)
		{
			if (pData->a_high_prize[i].agency[j].agency_code == 0)
			{
				break;
			}
			elHLocation = elHLocations->AddElement(xmlEl.location_2[i][m]);

			elHLLeaf = elHLocation->AddElement(xmlEl.agency_code_2[i][m]);
			memset(xmlContent, 0, sizeof(xmlContent));
			snprintf(xmlContent, contLen, "%llu", pData->a_high_prize[i].agency[j].agency_code);
			elHLLeaf->AddContent(xmlContent, 0);

			elHLLeaf = elHLocation->AddElement(xmlEl.count_2[i][m]);
			memset(xmlContent, 0, sizeof(xmlContent));
			snprintf(xmlContent, contLen, "%u", pData->a_high_prize[i].agency[j].winner_count);
			elHLLeaf->AddContent(xmlContent, 0);

			m++;
		}
	}

	xmlFile->Save(winFilePath);
	delete xmlFile;

    return 0;
}


//将 winner 文件的内容字符串写入期次表
int32 save_winner_file_for_gidb(uint8 game_code, uint64 issue_number, uint8 draw_times, uint8 flag)
{
    int32 ret = 0;
    char buf_xml_str[1*1024*1024] = {0};

    int32 field = DRAW_WINNER_LOCAL_TEXT_KEY;
    if ( WINNER_CONFIRM_FILE == flag )
    {
        field = DRAW_WINNER_CONFIRM_TEXT_KEY;
    }

    char winFilePath[256];
    get_game_issue_winner_filepath(winFilePath, game_code, issue_number, draw_times, flag);

    //将文件内容全部读到 buf_xml_str 中
    FILE *fp = fopen(winFilePath, "rb");
    if (fp == NULL)
    {
    	log_info("debug:%s",winFilePath);
    	return -1;
    }
    fread(buf_xml_str, sizeof(buf_xml_str), 1, fp);
    fclose(fp);

    //将 buf_xml_str 写入期次开奖表
    GIDB_DRAW_HANDLE *d_handle = gidb_d_get_handle(game_code, issue_number, draw_times);
    if (d_handle == NULL)
    {
        log_error("gidb_d_get_handle(%d, %llu, %d) error", game_code, issue_number, draw_times);
        return -1;
    }
    //保存开奖号码字符串
    char buffer[1*1024*1024];
    GIDB_D_DATA *gd_data = (GIDB_D_DATA *)buffer;
    memset(gd_data, 0, sizeof(GIDB_D_DATA));
    gd_data->field_type = field;
    gd_data->data_len = strlen(buf_xml_str);
    strncpy(gd_data->data, buf_xml_str, gd_data->data_len);
    ret = d_handle->gidb_d_set_field_text(d_handle, gd_data);
    if (ret != 0)
    {
        log_error("gidb_d_set_field_text(%d, %llu, field_type[%d) error", game_code, issue_number, field);
        return -1;
    }
    return 0;
}
//============winner local/confirm xml======end===============


//开奖公告保存到开奖过程数据表
int32 save_drawannounce_file_for_gidb(uint8 game_code, uint64 issue_number, uint8 draw_times, char *file)
{
    int32 ret = 0;
    char buf_xml_str[64*1024] = {0};

    //将文件内容全部读到 buf_xml_str 中
    FILE *fp = fopen(file, "rb");
    if (fp == NULL)
    {
    	log_info("debug:%s",file);
    	return -1;
    }

    fread(buf_xml_str, sizeof(buf_xml_str), 1, fp);
    fclose(fp);

    GIDB_DRAW_HANDLE *d_handle = gidb_d_get_handle(game_code, issue_number, draw_times);
    if (d_handle == NULL)
    {
        log_error("gidb_d_get_handle(%d, %llu, %d) error", game_code, issue_number, draw_times);
        return -1;
    }
    //将 开奖公告 写入期次开奖表
    char buffer[64*1024];
    GIDB_D_DATA *gd_data = (GIDB_D_DATA *)buffer;
    memset(gd_data, 0, sizeof(GIDB_D_DATA));
    gd_data->field_type = DRAW_ANNOUNCE_TEXT_KEY;
    gd_data->data_len = strlen(buf_xml_str);
    strncpy(gd_data->data, buf_xml_str, gd_data->data_len);
    ret = d_handle->gidb_d_set_field_text(d_handle, gd_data);
    if (ret != 0)
    {
        log_error("gidb_d_set_field_text(%d, %llu, field_type[DRAW_ANNOUNCE_TEXT_KEY]) error", game_code, issue_number);
        return -1;
    }

#if 0
    if (draw_times == GAME_DRAW_ONE)
    {
        if (sysdb_getSysStatus() == SYS_STATUS_BUSINESS)
        {
            GIDB_ISSUE_HANDLE *i_handle = gidb_i_get_handle(game_code);
            if (i_handle == NULL)
            {
                log_error("gidb_i_get_handle(%d) error", game_code);
                return -1;
            }
            //更新期次管理表的开奖公告
            ret = i_handle->gidb_i_set_field_text(i_handle, issue_number, I_DRAW_ANNOUNCE_TEXT_KEY, buf_xml_str);
            if (ret != 0)
            {
                log_error("gidb_i_set_field_text(%d, %lld, %d) error", game_code, issue_number, I_DRAW_ANNOUNCE_TEXT_KEY);
                return -1;
            }
        }
    }
#endif
    return 0;
}

/*
 * win表与tmp_win表:
 * 一张多期票，如果有中奖，则先将中奖票插入开奖期的win表，然后将此票到多期的最后一期的tmp_win表
 * 每期开奖confirm后,先向win表插入数据，若不是最后一期，则再向tmp_win表插入数据，再merge，每期执行merge。
 * */











//-------------------------------------------------------------------------
//销售站期次中奖统计信息
//-------------------------------------------------------------------------

#if 0
static WINNER_DATABASE *winner_db_ptr = NULL;

char *create_winner_memory(void)
{
	winner_db_ptr = (WINNER_DATABASE*) malloc(sizeof(WINNER_DATABASE));
	if (NULL == winner_db_ptr)
	{
	    return NULL;
	}
	memset(winner_db_ptr, 0, sizeof(WINNER_DATABASE));
	return (char *)winner_db_ptr;
}

void destroy_winner_memory(char *ptr)
{
	if (NULL != ptr)
	{
		free(ptr);
	}
	return;
}

WINNER_DATABASE* getWinnerPtr(void)
{
	return winner_db_ptr;
}


int32 set_winner_db(GIDB_WIN_TICKET_REC *winning_ticket, uint64 issue_number, PRIZE_PARAM *prize_ptr)
{
	WINNER_DATABASE *winner_db = getWinnerPtr();

	uint32 i = 0;
	uint32 k = 0;
	uint32 m = 0;
	if ( (winning_ticket->agencyCode == 0) &&
		 (winning_ticket->apCode != 0) ) {
		//ap 循环
		for (i = 0; i < winner_db->apCount; i++)
		{
			//ap一致
			if (winner_db->ap[i].apCode == winning_ticket->apCode)
			{
				winner_db->ap[i].drawTicketCnt++;
				for (k = 0; k < winning_ticket->prizeCount; k++)
				{
					uint32 apPrizeCnt = winner_db->ap[i].prizeCount;
					for (m = 0; m < apPrizeCnt; m++)
					{
						if (winner_db->ap[i].prize[m].prizeCode == winning_ticket->prizeDetail[k].prizeCode)
						{
							break;
						}
					}
					if (m == apPrizeCnt)
					{
						winner_db->ap[i].prizeCount++;

						PRIZE_PARAM *prize_param = &prize_ptr[winning_ticket->prizeDetail[k].prizeCode];
						if (prize_param->used) {
							winner_db->ap[i].prize[m].hflag = (prize_param->hflag == true) ? 1 : 0;
						}
						winner_db->ap[i].prize[m].prizeCode = winning_ticket->prizeDetail[k].prizeCode;
						winner_db->ap[i].prize[m].count += winning_ticket->prizeDetail[k].count;
						winner_db->ap[i].prize[m].amountSingle = winning_ticket->prizeDetail[k].amountSingle;
						memcpy(winner_db->ap[i].prize[m].name, winning_ticket->prizeDetail[k].name, sizeof(winning_ticket->prizeDetail[k].name));
					} else {
						winner_db->ap[i].prize[m].count += winning_ticket->prizeDetail[k].count;
					}

					log_info("debug:i=%u,k=%u,Count=%u,count=%u,money=%lld,code=%u,issue=%lld",
										i,k,winner_db->ap[i].prizeCount,winner_db->ap[i].prize[m].count,
										winner_db->ap[i].prize[m].amountSingle,
										winner_db->ap[i].prize[m].prizeCode,winner_db->ap[i].issueNum);
				}

				break;
			}//end if
		}//end for

		//ap不同
		if (i == winner_db->apCount)
		{
			winner_db->apCount++;
			winner_db->ap[i].apCode = winning_ticket->apCode;
			winner_db->ap[i].game_code = winning_ticket->gameCode;
			winner_db->ap[i].issueNum = issue_number;

			winner_db->ap[i].drawTicketCnt++;

			winner_db->ap[i].prizeCount = winning_ticket->prizeCount;
			for (k = 0; k < winning_ticket->prizeCount; k++)
			{
				PRIZE_PARAM *prize_param = &prize_ptr[winning_ticket->prizeDetail[k].prizeCode];
				if (prize_param->used) {
					winner_db->ap[i].prize[k].hflag = (prize_param->hflag == true) ? 1 : 0;
				}
				winner_db->ap[i].prize[k].prizeCode = winning_ticket->prizeDetail[k].prizeCode;
				winner_db->ap[i].prize[k].count = winning_ticket->prizeDetail[k].count;
				winner_db->ap[i].prize[k].amountSingle = winning_ticket->prizeDetail[k].amountSingle;
				memcpy(winner_db->ap[i].prize[k].name, winning_ticket->prizeDetail[k].name, sizeof(winning_ticket->prizeDetail[k].name));
				log_info("debug:i=%u,k=%u,Count=%u,count=%u,money=%lld,code=%u,issue=%lld",
						i,k,winner_db->ap[i].prizeCount,winner_db->ap[i].prize[k].count,
						winner_db->ap[i].prize[k].amountSingle,
						winner_db->ap[i].prize[k].prizeCode, winner_db->ap[i].issueNum);
			}
		}

		return 0;
	}


	//agency 循环
	for (i = 0; i < winner_db->agencyCount; i++)
	{
		//agency一致
		if (winner_db->agency[i].agencyCode == winning_ticket->agencyCode)
		{
			//winner_db->agency[i].prizeCount = winning_ticket->prizeCount;
			winner_db->agency[i].drawTicketCnt++;
			for (k = 0; k < winning_ticket->prizeCount; k++)
			{
				uint32 agencyPrizeCnt = winner_db->agency[i].prizeCount;
				for (m = 0; m < agencyPrizeCnt; m++)
				{
					if (winner_db->agency[i].prize[m].prizeCode == winning_ticket->prizeDetail[k].prizeCode)
					{
						break;
					}
				}
				if (m == agencyPrizeCnt)
				{
					winner_db->agency[i].prizeCount++;

					PRIZE_PARAM *prize_param = &prize_ptr[winning_ticket->prizeDetail[k].prizeCode];
					if (prize_param->used) {
						winner_db->agency[i].prize[m].hflag = (prize_param->hflag == true) ? 1 : 0;
					}
					winner_db->agency[i].prize[m].prizeCode = winning_ticket->prizeDetail[k].prizeCode;
					winner_db->agency[i].prize[m].count += winning_ticket->prizeDetail[k].count;
					winner_db->agency[i].prize[m].amountSingle = winning_ticket->prizeDetail[k].amountSingle;
					memcpy(winner_db->agency[i].prize[m].name, winning_ticket->prizeDetail[k].name, sizeof(winning_ticket->prizeDetail[k].name));
				} else {
					winner_db->agency[i].prize[m].count += winning_ticket->prizeDetail[k].count;
				}

				log_info("debug:i=%u,k=%u,Count=%u,count=%u,money=%lld,code=%u,issue=%lld",
									i,k,winner_db->agency[i].prizeCount,winner_db->agency[i].prize[m].count,
									winner_db->agency[i].prize[m].amountSingle,
									winner_db->agency[i].prize[m].prizeCode,winner_db->agency[i].issueNum);
			}

			break;
		}//end if
	}//end for

	//agency不同
	if (i == winner_db->agencyCount)
	{
		winner_db->agencyCount++;
		winner_db->agency[i].agencyCode = winning_ticket->agencyCode;
		winner_db->agency[i].game_code = winning_ticket->gameCode;
		winner_db->agency[i].issueNum = issue_number;

		winner_db->agency[i].drawTicketCnt++;

		winner_db->agency[i].prizeCount = winning_ticket->prizeCount;
		for (k = 0; k < winning_ticket->prizeCount; k++)
		{
			PRIZE_PARAM *prize_param = &prize_ptr[winning_ticket->prizeDetail[k].prizeCode];
			if (prize_param->used) {
				winner_db->agency[i].prize[k].hflag = (prize_param->hflag == true) ? 1 : 0;
			}
			winner_db->agency[i].prize[k].prizeCode = winning_ticket->prizeDetail[k].prizeCode;
			winner_db->agency[i].prize[k].count = winning_ticket->prizeDetail[k].count;
			winner_db->agency[i].prize[k].amountSingle = winning_ticket->prizeDetail[k].amountSingle;
			memcpy(winner_db->agency[i].prize[k].name, winning_ticket->prizeDetail[k].name, sizeof(winning_ticket->prizeDetail[k].name));
			log_info("debug:i=%u,k=%u,Count=%u,count=%u,money=%lld,code=%u,issue=%lld",
					i,k,winner_db->agency[i].prizeCount,winner_db->agency[i].prize[k].count,
					winner_db->agency[i].prize[k].amountSingle,
					winner_db->agency[i].prize[k].prizeCode, winner_db->agency[i].issueNum);
		}
	}

	return 0;
}


int32 save_winner_file(uint8 draw_times, char *agencyFile, char apFile[MAX_AP_NUMBER][256])
{
	WINNER_DATABASE *winner_db = getWinnerPtr();
	char str[200] = {0};

	FILE *fp = fopen(agencyFile, "wb");
    if (fp == NULL)
    {
    	log_info("debug:%s",agencyFile);
    	return -1;
    }

    uint32 i = 0;
    uint32 j = 0;
    for (i = 0; i < winner_db->agencyCount; i++)
    {
    	for(j = 0; j < winner_db->agency[i].prizeCount; j++)
    	{
    		memset(str, 0, sizeof(str));
			sprintf(str, "%llu %u %lld %u",
					winner_db->agency[i].agencyCode,
					winner_db->agency[i].game_code,
					winner_db->agency[i].issueNum,
					winner_db->agency[i].drawTicketCnt);

    		sprintf(str, "%s %u %s %u %u %lld",
    				str,
    				winner_db->agency[i].prize[j].prizeCode,
    				winner_db->agency[i].prize[j].name,
    				winner_db->agency[i].prize[j].hflag,
    				winner_db->agency[i].prize[j].count,
    				winner_db->agency[i].prize[j].amountSingle);

			sprintf(str, "%s\n", str);
			if(EOF == fputs(str, fp))
			{
				fclose(fp);
				log_error("fputs:%s",str);
				return -1;
			}
			log_info("debug:i=%u,j=%u,code=%u,count=%u,money=%lld",
					i,j,winner_db->agency[i].prize[j].prizeCode,winner_db->agency[i].prize[j].count,
					winner_db->agency[i].prize[j].amountSingle);
    	}
    }
    fclose(fp);

    //ap
	memset(str, 0, sizeof(str));

    for (i = 0; i < winner_db->apCount; i++)
    {
    	ts_get_pub_game_issue_filepath(winner_db->ap[i].apCode,
    								   winner_db->ap[i].game_code,
    								   winner_db->ap[i].issueNum,
    								   draw_times,
    								   apFile[i],
    								   256);
        fp = fopen(apFile[i], "wb");
        if (fp == NULL) {
        	log_info("debug:%s,i[%d]",apFile[i], i);
        	return -1;
        }

    	for(j = 0; j < winner_db->ap[i].prizeCount; j++) {
    		memset(str, 0, sizeof(str));
			sprintf(str, "%u %u %lld %u",
					winner_db->ap[i].apCode,
					winner_db->ap[i].game_code,
					winner_db->ap[i].issueNum,
					winner_db->ap[i].drawTicketCnt);

    		sprintf(str, "%s %u %s %u %u %lld",
    				str,
    				winner_db->ap[i].prize[j].prizeCode,
    				winner_db->ap[i].prize[j].name,
    				winner_db->ap[i].prize[j].hflag,
    				winner_db->ap[i].prize[j].count,
    				winner_db->ap[i].prize[j].amountSingle);

			sprintf(str, "%s\n", str);
			if(EOF == fputs(str, fp))
			{
				fclose(fp);
				log_error("fputs:%s",str);
				return -1;
			}
			log_info("debug:i=%u,j=%u,code=%u,count=%u,money=%lld",
					i,j,winner_db->ap[i].prize[j].prizeCode,winner_db->ap[i].prize[j].count,
					winner_db->ap[i].prize[j].amountSingle);
    	}

    	fclose(fp);
    }

    return 0;
}

#endif
