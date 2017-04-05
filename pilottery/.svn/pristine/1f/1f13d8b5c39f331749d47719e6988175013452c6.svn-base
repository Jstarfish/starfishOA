#include "global.h"
#include "tfe_inf.h"
#include "gl_inf.h"
#include "tms_inf.h"

#include "tfe_reply_function.h"


extern GAME_PLUGIN_INTERFACE *game_plugins_handle;
extern FID ncpc_fid;


//do checkpoint
static int32 tfe_reply_checkpoint(uint64 checkpoint_seq)
{
    int ret = 0;

    log_debug("tfe_reply_checkpoint ----------> begin");

    ret = tfe_do_check_point(checkpoint_seq);
    if (ret < 0) {
        log_error("tfe_do_check_point failure. ");
        return -1;
    }

    static char snapshot_path[128];
    sprintf(snapshot_path, "%s/%lld", SNAPSHOT_DATA_SUBDIR, checkpoint_seq);
    //创建snapshot目录
    ret = mkdirs(snapshot_path);
    if (ret != 0) {
        log_error("DO CHECKPOINT -> mkdir snapshot dir failure. [ %s ]", snapshot_path);
        return -1;
    }
    //保存sysdb
    if (sysdb_chkp_save(snapshot_path) < 0) {
        log_error("sysdb_chkp_save() failed. [%s]", snapshot_path);
        return -1;
    }
    //保存gl
    if (gl_chkp_save(snapshot_path) < 0) {
        log_error("gl_chkp_save() failed. [%s]", snapshot_path);
        return -1;
    }
    //游戏插件数据保存，包括:期次数据统计、期次风险控制等
    uint8 game_code = 0;
    for (game_code=0; game_code<MAX_GAME_NUMBER; game_code++) {
        GAME_DATA* game_data = gl_getGameData(game_code);
        if (game_data->used == false)
            continue;
        ret = game_plugins_handle[game_code].chkp_saveData(snapshot_path);
        if (ret != true) {
            log_error("game plugin chkp_saveData failure. game[ %d ] [%s]", game_code, snapshot_path);
            return -1;
        }
    }
    log_debug("tfe_reply_checkpoint ----------< end");
    log_debug("DO CHECKPOINT -> success. sequence[%lld]", checkpoint_seq);
    return 0;
}

//售票更新 游戏统计 和 期次统计信息  (参数为: 票的金额 和 票的注数)
int update_issue_stat_by_sale(uint8 game_code, uint32 issue_serial, uint32 issue_count, money_t ticket_amount, uint32 bet_count)
{
    GAME_DAY_STAT *game_stat = gl_getGameDayStat(game_code);
    game_stat->saleAmount += ticket_amount;
    game_stat->saleCount++;

    ISSUE_INFO *issue_ptr = NULL;
    for (uint32 i = 0; i < issue_count; i++)
    {
        issue_ptr = game_plugins_handle[game_code].get_issueInfo2(issue_serial+i);
        if (NULL==issue_ptr)
        {
            log_error("game plugin get_issueInfo2(game_code[%u], issue_serial[%u]) return NULL.", game_code, (issue_serial+i));
            return -1;
        }
        issue_ptr->stat.issueSaleAmount += ticket_amount/issue_count;
        issue_ptr->stat.issueSaleCount++;
        issue_ptr->stat.issueSaleBetCount += bet_count/issue_count;
    }
    return 0;
}
//兑奖更新 游戏统计 信息  (参数为: 票的金额 和 票的注数)
int update_issue_stat_by_pay(uint8 game_code, money_t ticket_amount)
{
    GAME_DAY_STAT *game_stat = gl_getGameDayStat(game_code);
    game_stat->payAmount += ticket_amount;
    game_stat->payCount++;
    return 0;
}

//退票更新 游戏统计 和 期次统计 信息  (参数为: 票的金额 和 票的注数)
int update_issue_stat_by_cancel(uint8 game_code, uint32 issue_serial, uint32 issue_count, money_t ticket_amount, uint32 bet_count)
{
    GAME_DAY_STAT *game_stat = gl_getGameDayStat(game_code);
    game_stat->cancelAmount += ticket_amount;
    game_stat->cancelCount++;

    ISSUE_INFO *issue_ptr = NULL;
    for (uint32 i = 0; i < issue_count; i++)
    {
        issue_ptr = game_plugins_handle[game_code].get_issueInfo2(issue_serial+i);
        if (NULL==issue_ptr)
        {
            log_error("game plugin get_issueInfo2(game_code[%u], issue_serial[%u]) return NULL.", game_code, (issue_serial+i));
            return -1;
        }
        issue_ptr->stat.issueCancelAmount += ticket_amount/issue_count;
        issue_ptr->stat.issueCancelCount++;
        issue_ptr->stat.issueCancelBetCount += bet_count/issue_count;
    }
    return 0;
}




//----------------------------------------------------------------------------
//
//  dispatch message
//
//----------------------------------------------------------------------------

//测试消息，进行计数
static uint32 N_echo_count = 0;
int rproc_N_echo(char *inm_buf)
{
    ts_notused(inm_buf);

    N_echo_count++;
    if (N_echo_count >= 1)
        log_debug("tfe reply ncp echo_count[ %d ]", N_echo_count);
    return EXIT_NCPC;
}

int rproc_TFE_checkpoint(char *inm_buf)
{
    int ret = 0;
    INM_MSG_HEADER *pInm = (INM_MSG_HEADER *)inm_buf;
    if (SYS_STATUS_BUSINESS != sysdb_getSysStatus())
    {
        if (SYS_STATUS_END==sysdb_getSysStatus() && pInm->status==0xFFFF)
            ret = 0;
        else
            return EXIT_ONLY;
    }

    uint64 checkpoint_seq = pInm->tfe_file_idx*TFE_FILE_SIZE + pInm->tfe_offset;

    ret = tfe_reply_checkpoint(checkpoint_seq);
    if (ret < 0)
    {
        log_error("tfe_reply_checkpoint failure.");
        return EXIT_ERR;
    }

    if (SYS_STATUS_END==sysdb_getSysStatus() && pInm->status==0xFFFF)
    {
        //safe close checkpoint
        return EXIT_SAFE_CLOSE;
    }
    return EXIT_ONLY;
}

int rproc_SYS_business_state(char *inm_buf)
{
    ts_notused(inm_buf);

    //int ret = 0;
    //INM_MSG_HEADER *pInm = (INM_MSG_HEADER *)inm_buf;

    //对风险控制的恢复数据重新初始化
    uint8 game_code = 0;
    for (game_code=0; game_code<MAX_GAME_NUMBER; game_code++)
    {
        GAME_DATA* game_data = gl_getGameData(game_code);
        if (game_data->used == false)
            continue;
        if (game_data->transctrlParam.riskCtrl==false)
            continue;

        game_plugins_handle[game_code].rk_reinitData();
    }

    //更新系统状态至BUSINESS
    sysdb_setSysStatus(SYS_STATUS_BUSINESS);

    log_info("System state is BUSINESS STATE.");
    return EXIT_ONLY;
}

int rproc_SYS_switch_session(char *inm_buf)
{
    int ret = 0;
    INM_MSG_SYS_SWITCH_SESSION *pInm = (INM_MSG_SYS_SWITCH_SESSION *)inm_buf;

    //更新终端机序号
    tms_mgr()->resetSequence();

    //清理游戏日销量
    gl_cleanGameDayStatistics();

    //更新内存会话
    sysdb_setSessionDate(pInm->newSession);

    char sessionFile[256] = {0};
    ts_get_session_filepath(sessionFile, 256);

    char datebuf[16] = {0};
    sprintf(datebuf,"%d",pInm->newSession);
    if(!ts_write_sessionDate_file(sessionFile,datebuf))
    {
        log_error("ts_write_sessionDate_file error! sessionFile[%s] datebuf[%s]",sessionFile,datebuf);
        return EXIT_ERR;
    }

    sysdb_setSendSwitchSessionFlag(0);

    if (SYS_STATUS_BUSINESS==sysdb_getSysStatus())
    {
        //do checkpoint
        uint64 checkpoint_seq = pInm->header.tfe_file_idx*TFE_FILE_SIZE + pInm->header.tfe_offset;
        ret = tfe_reply_checkpoint(checkpoint_seq);
        if (ret < 0)
        {
            log_error("tfe_reply_checkpoint failure.");
            return EXIT_ERR;
        }
    }

    log_info("SWITCH SESSION.  NewSession [%d].  OldSession [%d] tfe_offset[%d - %d]", pInm->newSession, pInm->curSession,pInm->header.tfe_file_idx,pInm->header.tfe_offset);

    return EXIT_ONLY;
}


//测试消息，进行计数
static uint32 T_echo_count = 0;
int rproc_T_echo(char *inm_buf)
{
    ts_notused(inm_buf);

    T_echo_count++;
    if (T_echo_count >= 1)
        log_debug("tfe reply terminal echo_count[ %d ]", T_echo_count);
    return EXIT_NCPC;
}

int rproc_T_sell_ticket(char *inm_buf)
{
    INM_MSG_T_SELL_TICKET *pInm = (INM_MSG_T_SELL_TICKET *)inm_buf;
    if ((pInm->header.inm_header.status!=SYS_RESULT_SUCCESS) || (pInm->ticket.isTrain))
        return EXIT_NCPC;

    //更新风控数据
    if ((isGameBeRiskControl(pInm->ticket.gameCode)) && (NULL!=game_plugins_handle[pInm->ticket.gameCode].sale_rk_commit)) {
        game_plugins_handle[pInm->ticket.gameCode].sale_rk_commit(&pInm->ticket);
    }
    //更新游戏和期次销售统计数据
    update_issue_stat_by_sale(pInm->ticket.gameCode, pInm->ticket.issueSeq, pInm->ticket.issueCount, pInm->ticket.amount, pInm->ticket.betCount);
    return EXIT_NCPC;
}

int rproc_T_pay_ticket(char *inm_buf)
{
    INM_MSG_T_PAY_TICKET *pInm = (INM_MSG_T_PAY_TICKET *)inm_buf;
    if ((pInm->header.inm_header.status!=SYS_RESULT_SUCCESS)|| (pInm->isTrain))
        return EXIT_NCPC;

    //更新游戏兑奖统计数据
    update_issue_stat_by_pay(pInm->gameCode, pInm->winningAmountWithTax);
    return EXIT_NCPC;
}

int rproc_T_cancel_ticket(char *inm_buf)
{
    INM_MSG_T_CANCEL_TICKET *pInm = (INM_MSG_T_CANCEL_TICKET *)inm_buf;
    if ((pInm->header.inm_header.status!=SYS_RESULT_SUCCESS)|| (pInm->ticket.isTrain))
        return EXIT_NCPC;

    //更新风控数据
    if ((isGameBeRiskControl(pInm->ticket.gameCode)) && (NULL!=game_plugins_handle[pInm->ticket.gameCode].cancel_rk_commit)) {
        game_plugins_handle[pInm->ticket.gameCode].cancel_rk_commit(&pInm->ticket);
    }
    //更新游戏和期次退票统计数据
    update_issue_stat_by_cancel(pInm->ticket.gameCode, pInm->ticket.issueSeq,
        pInm->ticket.issueCount, pInm->ticket.amount, pInm->ticket.betCount);
    return EXIT_NCPC;
}

int rproc_O_pay_ticket(char *inm_buf)
{
    INM_MSG_O_PAY_TICKET *pInm = (INM_MSG_O_PAY_TICKET *)inm_buf;
    if ((pInm->header.inm_header.status!=SYS_RESULT_SUCCESS)|| (pInm->isTrain))
        return EXIT_NCPC;

    //更新游戏和期次兑奖统计数据
    update_issue_stat_by_pay(pInm->gameCode, pInm->winningAmountWithTax);

    return EXIT_NCPC;
}

int rproc_O_cancel_ticket(char *inm_buf)
{
    INM_MSG_O_CANCEL_TICKET *pInm = (INM_MSG_O_CANCEL_TICKET *)inm_buf;
    if ((pInm->header.inm_header.status!=SYS_RESULT_SUCCESS)|| (pInm->ticket.isTrain))
        return EXIT_NCPC;

    //更新风控数据
    if ((isGameBeRiskControl(pInm->ticket.gameCode)) && (NULL!=game_plugins_handle[pInm->ticket.gameCode].cancel_rk_commit)) {
        game_plugins_handle[pInm->ticket.gameCode].cancel_rk_commit(&pInm->ticket);
    }
    //更新游戏和期次退票统计数据
    update_issue_stat_by_cancel(pInm->ticket.gameCode, pInm->ticket.issueSeq,
        pInm->ticket.issueCount, pInm->ticket.amount, pInm->ticket.betCount);

    return EXIT_NCPC;
}


// FBS process -----------------------------------------------------------------------------------

//售票更新 游戏统计 和 期次统计信息  (参数为: 票的金额 和 票的注数)
int update_fbs_stat_by_sale(uint8 game_code, money_t ticket_amount)
{
    GAME_DAY_STAT *game_stat = gl_getGameDayStat(game_code);
    game_stat->saleAmount += ticket_amount;
    game_stat->saleCount++;

    return 0;
}

//售票更新 游戏统计 和 期次统计信息  (参数为: 票的金额 和 票的注数)
int update_fbs_stat_by_pay(uint8 game_code, money_t ticket_amount)
{
    GAME_DAY_STAT *game_stat = gl_getGameDayStat(game_code);
    game_stat->payAmount += ticket_amount;
    game_stat->payCount++;

    return 0;
}

//售票更新 游戏统计 和 期次统计信息  (参数为: 票的金额 和 票的注数)
int update_fbs_stat_by_cancel(uint8 game_code, money_t ticket_amount)
{
    GAME_DAY_STAT *game_stat = gl_getGameDayStat(game_code);
    game_stat->cancelAmount += ticket_amount;
    game_stat->cancelCount++;

    return 0;
}


int rproc_FBS_sell_ticket(char *inm_buf)
{
    INM_MSG_FBS_SELL_TICKET *pFbsInm = (INM_MSG_FBS_SELL_TICKET *)inm_buf;
    FBS_TICKET *fbs_ticket = (FBS_TICKET *)(pFbsInm->betString+pFbsInm->betStringLen);
    if ((pFbsInm->header.inm_header.status!=SYS_RESULT_SUCCESS) || (fbs_ticket->is_train))
        return EXIT_NCPC;

    int ret = game_plugins_handle[fbs_ticket->game_code].fbs_split_order(fbs_ticket);
	if (ret == -1) {
		return EXIT_NCPC;
	}

	//reply计算实时参考SP值
    ret = game_plugins_handle[fbs_ticket->game_code].fbs_calc_rt_odds(fbs_ticket);
	if (ret == -1) {
		return EXIT_NCPC;
	}

    //更新风控数据
    if ( (isGameBeRiskControl(fbs_ticket->game_code)) &&
        (NULL!=game_plugins_handle[fbs_ticket->game_code].fbs_sale_rk_commit) )
    {
        game_plugins_handle[fbs_ticket->game_code].fbs_sale_rk_commit(fbs_ticket);
    }

    //更新游戏销售统计数据
    update_fbs_stat_by_sale(fbs_ticket->game_code, fbs_ticket->bet_amount);

    return EXIT_NCPC;
}

int rproc_FBS_pay_ticket(char *inm_buf)
{
    INM_MSG_FBS_PAY_TICKET *pFbsInm = (INM_MSG_FBS_PAY_TICKET *)inm_buf;
    if ((pFbsInm->header.inm_header.status!=SYS_RESULT_SUCCESS)|| (pFbsInm->isTrain))
        return EXIT_NCPC;

    //更新游戏兑奖统计数据
    update_fbs_stat_by_pay(pFbsInm->gameCode, pFbsInm->winningAmountWithTax);

    return EXIT_NCPC;
}

int rproc_FBS_cancel_ticket(char *inm_buf)
{
    INM_MSG_FBS_CANCEL_TICKET *pFbsInm = (INM_MSG_FBS_CANCEL_TICKET *)inm_buf;
    FBS_TICKET *fbs_ticket = &pFbsInm->ticket;
    if ((pFbsInm->header.inm_header.status!=SYS_RESULT_SUCCESS)|| (fbs_ticket->is_train))
        return EXIT_NCPC;

    //更新风控数据
    if ( (isGameBeRiskControl(fbs_ticket->game_code)) &&
        (NULL!=game_plugins_handle[fbs_ticket->game_code].fbs_cancel_rk_commit) )
    {
        game_plugins_handle[fbs_ticket->game_code].fbs_cancel_rk_commit(fbs_ticket);
    }

    //更新游戏和期次退票统计数据
    update_fbs_stat_by_cancel(fbs_ticket->game_code, fbs_ticket->bet_amount);

    return EXIT_NCPC;
}

int rproc_O_fbs_pay_ticket(char *inm_buf)
{
    INM_MSG_O_FBS_PAY_TICKET *pInm = (INM_MSG_O_FBS_PAY_TICKET *)inm_buf;
    if ((pInm->header.inm_header.status!=SYS_RESULT_SUCCESS)|| (pInm->isTrain))
        return EXIT_NCPC;

    //更新游戏和期次兑奖统计数据
    update_fbs_stat_by_pay(pInm->gameCode, pInm->winningAmountWithTax);

    return EXIT_NCPC;
}

int rproc_O_fbs_cancel_ticket(char *inm_buf)
{
    INM_MSG_O_FBS_CANCEL_TICKET *pInm = (INM_MSG_O_FBS_CANCEL_TICKET *)inm_buf;
    FBS_TICKET *fbs_ticket = &pInm->ticket;
    if ((pInm->header.inm_header.status!=SYS_RESULT_SUCCESS)|| (pInm->isTrain))
        return EXIT_NCPC;

    //更新风控数据
    if ( (isGameBeRiskControl(fbs_ticket->game_code)) &&
        (NULL!=game_plugins_handle[fbs_ticket->game_code].fbs_cancel_rk_commit) )
    {
        game_plugins_handle[fbs_ticket->game_code].fbs_cancel_rk_commit(fbs_ticket);
    }

    //更新游戏和期次退票统计数据
    update_fbs_stat_by_cancel(fbs_ticket->game_code, pInm->cancelAmount);

    return EXIT_NCPC;
}
