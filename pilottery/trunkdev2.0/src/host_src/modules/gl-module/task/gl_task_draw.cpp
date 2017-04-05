#include "global.h"
#include "gl_inf.h"
#include "otl_inf.h"


static char MY_TASK_NAME[32]; //gl_draw


static volatile int exit_signal_fired = 0;

static uint8 game_code = 0;
SYS_TASK task_draw_idx = SYS_TASK_EMPTY;

GAME_FLOW_PROCESSOR *gfp = NULL;


int32 gl_draw_dispatcher(char *inm_buf, DB_ERROR *out_buf)
{
    int ret = 0;

    DB_ERROR *pError = out_buf;

    INM_MSG_HEADER *pInm = (INM_MSG_HEADER *)inm_buf;
    switch (pInm->type)
    {
        case INM_TYPE_ISSUE_STATE_SEALED:
        {
            INM_MSG_ISSUE_STATE *inm_ptr = (INM_MSG_ISSUE_STATE *)inm_buf;
            pError->game_code = inm_ptr->gameCode;
            pError->issue_num = inm_ptr->issueNumber;
            pError->draw_times = inm_ptr->drawTimes;
            pError->issue_status = ISSUE_STATE_SEALED;

            gfp = gfp_get_handle(game_code);
            if (gfp == NULL)
            {
            	log_error("gfp_get_handle() return NULL, gamecode=%d", game_code);
            	return -1;
            }
            ret = gfp->issue_sealed(gfp, pInm);
            if (ret < 0)
            {
                log_error("gfp issue_sealed( %d ) failure", inm_ptr->gameCode);
                return -1;
            }
            else if (ret == 1)
            {
            	return ret;
            }

            break;
        }

        case INM_TYPE_ISSUE_STATE_DRAWNUM_INPUTED:
        {
            INM_MSG_ISSUE_DRAWNUM_INPUTE *inm_ptr = (INM_MSG_ISSUE_DRAWNUM_INPUTE *)inm_buf;
            pError->game_code = inm_ptr->gameCode;
            pError->issue_num = inm_ptr->issueNumber;
            pError->draw_times = inm_ptr->drawTimes;
            pError->issue_status = ISSUE_STATE_DRAWNUM_INPUTED;

            gfp = gfp_get_handle(game_code);
            ret = gfp->issue_drawnum_inputed(gfp, pInm);
            if (ret < 0)
            {
                log_error("gfp issue_drawnum_inputed( %d ) failure", inm_ptr->gameCode);
                return -1;
            }
            else if (ret == 1)
			{
				return ret;
			}
            break;
        }

        case INM_TYPE_ISSUE_STATE_MATCHED:
        {
            INM_MSG_ISSUE_STATE *inm_ptr = (INM_MSG_ISSUE_STATE *)inm_buf;
            pError->game_code = inm_ptr->gameCode;
            pError->issue_num = inm_ptr->issueNumber;
            pError->draw_times = inm_ptr->drawTimes;
            pError->issue_status = ISSUE_STATE_MATCHED;

            gfp = gfp_get_handle(game_code);
            ret = gfp->issue_matched(gfp, pInm, NULL);
            if (ret < 0)
            {
                log_error("gfp issue_matched( %d ) failure", inm_ptr->gameCode);
                return -1;
            }
            else if (ret == 1)
			{
				return ret;
			}
            break;
        }

        case INM_TYPE_ISSUE_STATE_FUND_INPUTED:
        {
            INM_MSG_ISSUE_FUND_INPUTE *inm_ptr = (INM_MSG_ISSUE_FUND_INPUTE *)inm_buf;
            pError->game_code = inm_ptr->gameCode;
            pError->issue_num = inm_ptr->issueNumber;
            pError->draw_times = inm_ptr->drawTimes;
            pError->issue_status = ISSUE_STATE_FUND_INPUTED;

            gfp = gfp_get_handle(game_code);
            ret = gfp->issue_fund_inputed(gfp, pInm);
            if (ret < 0)
            {
                log_error("gfp issue_fund_inputed( %d ) failure", inm_ptr->gameCode);
                return -1;
            }
            else if (ret == 1)
			{
				return ret;
			}
            break;
        }

        case INM_TYPE_ISSUE_STATE_LOCAL_CALCED:
        {
            INM_MSG_ISSUE_WLEVEL *inm_ptr = (INM_MSG_ISSUE_WLEVEL *)inm_buf;
            pError->game_code = inm_ptr->gameCode;
            pError->issue_num = inm_ptr->issueNumber;
            pError->draw_times = inm_ptr->drawTimes;
            pError->issue_status = ISSUE_STATE_LOCAL_CALCED;

            gfp = gfp_get_handle(game_code);
            ret = gfp->issue_local_calced(gfp, pInm);
            if (ret < 0)
            {
                log_error("gfp issue_local_calced( %d ) failure", inm_ptr->gameCode);
                return -1;
            }
            else if (ret == 1)
			{
				return ret;
			}
            break;
        }

        case INM_TYPE_ISSUE_STATE_PRIZE_ADJUSTED:
        {
            INM_MSG_ISSUE_WLEVEL *inm_ptr = (INM_MSG_ISSUE_WLEVEL *)inm_buf;
            pError->game_code = inm_ptr->gameCode;
            pError->issue_num = inm_ptr->issueNumber;
            pError->draw_times = inm_ptr->drawTimes;
            pError->issue_status = ISSUE_STATE_PRIZE_ADJUSTED;

            gfp = gfp_get_handle(game_code);
            ret = gfp->issue_prize_adjusted(gfp, pInm);
            if (ret < 0)
            {
                log_error("gfp issue_prize_adjusted( %d ) failure", inm_ptr->gameCode);
                return -1;
            }
            else if (ret == 1)
			{
				return ret;
			}
            break;
        }

        case INM_TYPE_ISSUE_STATE_PRIZE_CONFIRMED:
        {
            INM_MSG_ISSUE_STATE *inm_ptr = (INM_MSG_ISSUE_STATE *)inm_buf;
            pError->game_code = inm_ptr->gameCode;
            pError->issue_num = inm_ptr->issueNumber;
            pError->draw_times = inm_ptr->drawTimes;
            pError->issue_status = ISSUE_STATE_PRIZE_CONFIRMED;

            gfp = gfp_get_handle(game_code);
            ret = gfp->issue_prize_confirmed(gfp, pInm);
            if (ret < 0)
            {
                log_error("gfp issue_prize_confirmed( %d ) failure", inm_ptr->gameCode);
                return -1;
            }
            else if (ret == 1)
			{
				return ret;
			}
            break;
        }

        case INM_TYPE_ISSUE_STATE_DB_IMPORTED:
        {
            INM_MSG_ISSUE_STATE *inm_ptr = (INM_MSG_ISSUE_STATE *)inm_buf;
            pError->game_code = inm_ptr->gameCode;
            pError->issue_num = inm_ptr->issueNumber;
            pError->draw_times = inm_ptr->drawTimes;
            pError->issue_status = ISSUE_STATE_DB_IMPORTED;

            gfp = gfp_get_handle(game_code);
            ret = gfp->issue_db_imported(gfp, pInm);
            if (ret < 0)
            {
                log_error("gfp issue_db_imported( %d ) failure", inm_ptr->gameCode);
                return -1;
            }
            else if (ret == 1)
			{
				return ret;
			}
            break;
        }

        case INM_TYPE_ISSUE_STATE_ISSUE_END:
        {
            INM_MSG_ISSUE_STATE *inm_ptr = (INM_MSG_ISSUE_STATE *)inm_buf;
            pError->game_code = inm_ptr->gameCode;
            pError->issue_num = inm_ptr->issueNumber;
            pError->draw_times = inm_ptr->drawTimes;
            pError->issue_status = ISSUE_STATE_ISSUE_END;

            gfp = gfp_get_handle(game_code);
            ret = gfp->issue_end(gfp, pInm);
            if (ret < 0)
            {
                log_error("gfp issue_end( %d ) failure", inm_ptr->gameCode);
                return -1;
            }
            else if (ret == 1)
			{
				return ret;
			}

            if ((inm_ptr->drawTimes == GAME_DRAW_ONE) &&
                (SYS_STATUS_BUSINESS == sysdb_getSysStatus()))
            {
				//从数据库获取期次信息更新cache的期次信息
				GIDB_ISSUE_HANDLE *i_handle = gidb_i_get_handle(game_code);
				if (i_handle == NULL)
				{
					log_error("gidb_i_get_handle(%d) error", game_code);
					return -1;
				}
				GIDB_ISSUE_INFO issue_info;
				memset(&issue_info, 0, sizeof(GIDB_ISSUE_INFO));
				if (!otl_get_issue_info(inm_ptr->gameCode, inm_ptr->issueNumber, &issue_info))
				{
					log_error("otl_get_issue_info() error. game[%d] issue_number[%llu]", inm_ptr->gameCode, inm_ptr->issueNumber);
					return -1;
				}
				if (i_handle->gidb_i_insert(i_handle, &issue_info) != 0)
				{
					log_error("gidb_i_insert() error. game[%d] issue_number[%llu]", inm_ptr->gameCode, inm_ptr->issueNumber);
					return -1;
				}
            }

            if (inm_ptr->drawTimes == GAME_DRAW_ONE)
            {
				//写一条TF update_db2用
				FID adder_fid = getFidByName("tfe_adder");
				ret = bq_send(adder_fid, (char*)inm_ptr, *(uint16*)inm_ptr);
				if (ret <= 0)
				{
					log_error("gl_task_draw send data to adder failure! game[%d] issue[%llu]",
							pError->game_code, pError->issue_num);
				}
            }

            break;
        }

        case INM_TYPE_ISSUE_DRAW_REDO:
        {
            INM_MSG_ISSUE_STATE *inm_ptr = (INM_MSG_ISSUE_STATE *)inm_buf;
            pError->game_code = inm_ptr->gameCode;
            pError->issue_num = inm_ptr->issueNumber;
            pError->draw_times = inm_ptr->drawTimes;
            pError->issue_status = 255;

            gfp = gfp_get_handle(game_code);
            ret = gfp->do_issue_draw_redo(gfp, pInm);
            if (ret < 0)
            {
                log_error("gfp do_issue_draw_redo( %d ) failure", inm_ptr->gameCode);
                return -1;
            }
            break;
        }

		case INM_TYPE_ISSUE_SALE_FILE_MD5SUM:
		{
            INM_MSG_ISSUE_SALE_FILE_MD5SUM *inm_ptr = (INM_MSG_ISSUE_SALE_FILE_MD5SUM *)inm_buf;
            pError->game_code = inm_ptr->gameCode;
            pError->issue_num = inm_ptr->issueNumber;
            pError->draw_times = inm_ptr->drawTimes;
            pError->issue_status = 255;

            gfp = gfp_get_handle(game_code);
            ret = gfp->do_verify_salefile_md5sum(gfp, pInm);
            if (ret < 0)
            {
                log_error("gfp do_verify_salefile_md5sum( %d ) failure", inm_ptr->gameCode);
                return -1;
            }
            break;
        }

        default:
            return 1;
    }
    gidb_d_clean_handle_timeout();
    gidb_t_clean_handle_timeout();
    gidb_w_clean_handle_timeout();
    return 0;
}

static void signal_handler(int signo)
{
    ts_notused(signo);
    exit_signal_fired = 1;
    return;
}

static int init_signal(void)
{
    signal(SIGPIPE, SIG_IGN);

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
    return 0;
}

int main(int argc, char *argv[])
{
    ts_notused(argc);

    int ret = 0;

    //根据启动参数得到游戏编码
    game_code = atoi(argv[1]);
    task_draw_idx = (SYS_TASK)sysdb_get_gl_draw_task_index(game_code);
    char game_abbr[16];
    get_game_abbr(game_code, game_abbr);
    sprintf(MY_TASK_NAME, "gl_draw_%s", game_abbr);

    logger_init(MY_TASK_NAME);

    ret = init_signal();
    if (0 != ret)
    {
        log_error("init_signal() failed.");
        return -1;
    }

    if (!sysdb_init())
	{
		log_error("%s sysdb_init error.",MY_TASK_NAME);
		return -1;
	}

    if (!bq_init())
    {
        sysdb_close();
        log_error("bq_init() failed.");
        return -1;
    }

    log_info("%s start\n", MY_TASK_NAME);

	SYS_DB_CONFIG *sysDBconfig = sysdb_getOmsDBCfg();
    char dbConnStr[64] = {0};
    sprintf(dbConnStr,"%s/%s@%s",sysDBconfig->username,sysDBconfig->password,sysDBconfig->url);
    if(!otl_connectDB(sysDBconfig->username, sysDBconfig->password, sysDBconfig->url,2))
    {
    	sysdb_close();
        log_error("otl_connectDB() failed.");
        return -1;
    }

    GIDB_DRAWLOG_HANDLE *drawlog_handle = gidb_drawlog_get_handle(game_code);
    if (drawlog_handle == NULL)
    {
        sysdb_close();
        log_error("gidb_drawlog_get_handle(%d) error", game_code);
        return -1;
    }

    sysdb_setTaskStatus(task_draw_idx, SYS_TASK_STATUS_RUN );

    log_info("%s init success\n", MY_TASK_NAME);

    static char inm_buf[INM_MSG_BUFFER_LENGTH];
    uint32 msgid = 0;
    uint8 msg_type = 0;
    uint32 inm_len = 0;
    DB_ERROR error_buf = {0, 0, 0, 0};
    while (0 == exit_signal_fired)
	{
        //扫表获取下一条需要处理的日志记录，获取其DRAW_MSG_KEY表列存储的INM消息
        ret = drawlog_handle->gidb_drawlog_get_last_dl(drawlog_handle, &msgid, &msg_type, inm_buf, &inm_len);
        if (ret < 0)
        {
            log_error("gidb_drawlog_get_last_dl(%d) error", game_code);
            return -1;
        }
        else if(ret == 1)
        {
            //get nothing
            if (SYS_STATUS_END==sysdb_getSysStatus() && sysdb_getSafeClose()==1)
                exit_signal_fired = 1; //saft exit
            ts_sleep(500*1000,0);
            continue;
        }

        //dispatch message
        memset(&error_buf, 0, sizeof(error_buf));
        ret = gl_draw_dispatcher(inm_buf, &error_buf);
        if (ret < 0)
        {
            log_error("gl_draw_dispatcher() failed.");
            set_issue_process_error(&error_buf);
            return -1;
        }

        //confirm drawlog message
        if (ret == 0)
        {
        	ret = drawlog_handle->gidb_drawlog_confirm_dl(drawlog_handle, msgid, 1);
        }
        else if (ret == 1)
        {
        	ret = drawlog_handle->gidb_drawlog_confirm_dl(drawlog_handle, msgid, 2);
        }
        else // (ret < 0)
        {
            log_error("gidb_drawlog_confirm_dl(%d) error", game_code);
            set_issue_process_error(&error_buf);
            return -1;
        }
    }

    sysdb_setTaskStatus(task_draw_idx, SYS_TASK_STATUS_EXIT);

    gidb_i_close_handle();
    gidb_d_close_handle();
    gidb_t_close_handle();
    gidb_w_close_handle();
    gidb_drawlog_close_handle();

    otl_disConnectDB();

    sysdb_close();

	log_info("%s exit\n", MY_TASK_NAME);

    return 0;
}




