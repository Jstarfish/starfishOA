#include "global.h"
#include "tfe_inf.h"
#include "gl_inf.h"
#include "tms_inf.h"

#define MY_TASK_NAME "tfe_adder\0"

static volatile int exit_signal_fired = 0;
GAME_PLUGIN_INTERFACE *game_plugins_handle = NULL;

static int process_saleTicket(char * buf)
{
	INM_MSG_T_SELL_TICKET* inm_msg = (INM_MSG_T_SELL_TICKET*)buf;
    if ((SYS_RESULT_SUCCESS!=inm_msg->header.inm_header.status) || (inm_msg->ticket.isTrain))
        return 0;

    //在这里保护验证一下，售票的期次是否已关闭
	time_type currentTime = get_now();
    uint8 game_code = inm_msg->ticket.gameCode;
    ISSUE_INFO* issue_ptr = game_plugins_handle[game_code].get_issueInfo(inm_msg->ticket.issue);
    if ((NULL==issue_ptr) || (issue_ptr->localState>=ISSUE_STATE_CLOSED) || (currentTime > issue_ptr->closeTime)) {
        inm_msg->header.inm_header.status = SYS_RESULT_SELL_NOISSUE_ERR;
        return 0;
    }

    //uint8 gameCode = inm_msg->ticket.gameCode;
    return 0;
}

static int process_fbs_saleTicket(char * buf)
{
    INM_MSG_FBS_SELL_TICKET* inm_msg = (INM_MSG_FBS_SELL_TICKET*)buf;
    FBS_TICKET *fbs_ticket = (FBS_TICKET*)(inm_msg->betString+inm_msg->betStringLen);
    if ((SYS_RESULT_SUCCESS!=inm_msg->header.inm_header.status) || (fbs_ticket->is_train))
        return 0;

    time_type currentTime = get_now();
    uint8 game_code = fbs_ticket->game_code;

#if 0
	//k-debug:FBS
	log_info("adder begin");
	int ret = 0;
    INM_MSG_FBS_SELL_TICKET* pFbsInm = (INM_MSG_FBS_SELL_TICKET*)buf;
    FBS_TICKET *fbs_ticket = (FBS_TICKET *)(pFbsInm->betString+pFbsInm->betStringLen);
    if ((SYS_RESULT_SUCCESS!=pFbsInm->header.inm_header.status) || (fbs_ticket->is_train))
        return 0;

    //校验销售站余额
    ret = tms_mgr()->salesTicketCheckForAdder(pFbsInm->header.agencyIndex, fbs_ticket->bet_amount);
    if (ret != SYS_RESULT_SUCCESS)
    {
        pFbsInm->header.inm_header.status = ret;
        return 0;
    }

    //游戏风险控制
    if ( (isGameBeRiskControl(fbs_ticket->game_code)) &&
        (NULL!=game_plugins_handle[fbs_ticket->game_code].fbs_sale_rk_verify) )
	{
	    ret = game_plugins_handle[fbs_ticket->game_code].fbs_sale_rk_verify(fbs_ticket);
        if (false == ret)
        {
            pFbsInm->header.inm_header.status = SYS_RESULT_RISK_CTRL_ERR;
            return 0;
        }
    }

    //更新销售站可销售金额
    SALES_TICKET_FOR_ADDER saleTicket;
    saleTicket.agencyIndex = pFbsInm->header.agencyIndex;
    saleTicket.agencyCode = pFbsInm->header.agencyCode;
    saleTicket.gameCode = fbs_ticket->game_code;
    saleTicket.salesAmount = fbs_ticket->bet_amount;

    ret = tms_mgr()->salesTicketForAdder(&saleTicket);
    if (ret != SYS_RESULT_SUCCESS)
    {
        pFbsInm->header.inm_header.status = ret;
        return 0;
    }

    pFbsInm->saleCommissionRate = saleTicket.saleCommissionRate;
    pFbsInm->commissionAmount = saleTicket.saleCommission;
    pFbsInm->availableCredit = saleTicket.availableCredit;
    log_info("adder end");
#endif
    return 0;
}

static int process_payTicket(char * buf)
{
    INM_MSG_T_PAY_TICKET* inm_msg = (INM_MSG_T_PAY_TICKET*)buf;
    if ((SYS_RESULT_SUCCESS!=inm_msg->header.inm_header.status) || (inm_msg->isTrain))
        return 0;
    //
	return 0;
}

static int process_fbs_payTicket(char * buf)
{
    INM_MSG_FBS_PAY_TICKET* inm_msg = (INM_MSG_FBS_PAY_TICKET*)buf;
    if ((SYS_RESULT_SUCCESS!=inm_msg->header.inm_header.status) || (inm_msg->isTrain))
        return 0;
    //
    return 0;}

static int process_oms_payTicket(char * buf)
{
    INM_MSG_O_PAY_TICKET* inm_msg = (INM_MSG_O_PAY_TICKET*)buf;
    if ((SYS_RESULT_SUCCESS!=inm_msg->header.inm_header.status) || (inm_msg->isTrain))
        return 0;
    //
	return 0;
}

static int process_oms_fbs_payTicket(char * buf)
{
    INM_MSG_O_FBS_PAY_TICKET* inm_msg = (INM_MSG_O_FBS_PAY_TICKET*)buf;
    if ((SYS_RESULT_SUCCESS!=inm_msg->header.inm_header.status) || (inm_msg->isTrain))
        return 0;
    //
    return 0;
}


static int process_cancelTicket(char * buf)
{
    INM_MSG_T_CANCEL_TICKET* inm_msg = (INM_MSG_T_CANCEL_TICKET*)buf;
    if ((SYS_RESULT_SUCCESS!=inm_msg->header.inm_header.status) || (inm_msg->ticket.isTrain))
        return 0;

    //uint8 gameCode = inm_msg->ticket.gameCode;
	return 0;
}

static int process_fbs_cancelTicket(char * buf)
{
    INM_MSG_FBS_CANCEL_TICKET* inm_msg = (INM_MSG_FBS_CANCEL_TICKET*)buf;
    if ((SYS_RESULT_SUCCESS!=inm_msg->header.inm_header.status) || (inm_msg->ticket.is_train))
        return 0;

    //uint8 gameCode = inm_msg->ticket.gameCode;
	return 0;
}

static int process_oms_cancelTicket(char * buf)
{
    INM_MSG_O_CANCEL_TICKET* inm_msg = (INM_MSG_O_CANCEL_TICKET*)buf;
    if ((SYS_RESULT_SUCCESS!=inm_msg->header.inm_header.status) || (inm_msg->isTrain))
        return 0;

    //uint8 gameCode = inm_msg->ticket.gameCode;
    return 0;
}

static int process_oms_fbs_cancelTicket(char * buf)
{
    INM_MSG_O_FBS_CANCEL_TICKET* inm_msg = (INM_MSG_O_FBS_CANCEL_TICKET*)buf;
    if ((SYS_RESULT_SUCCESS!=inm_msg->header.inm_header.status) || (inm_msg->isTrain))
        return 0;

    //uint8 gameCode = inm_msg->ticket.gameCode;
    return 0;
}

static void tfe_adder_dispatcher(char *inm_buf)
{
    INM_MSG_HEADER *inm_msg = (INM_MSG_HEADER *)inm_buf;
    inm_msg->version = sysdb_version();
    switch (inm_msg->type) {
        case INM_TYPE_T_SELL_TICKET:
            process_saleTicket(inm_buf);
            break;
        case INM_TYPE_T_PAY_TICKET:
            process_payTicket(inm_buf);
            break;
        case INM_TYPE_O_PAY_TICKET:
            process_oms_payTicket(inm_buf);
            break;
        case INM_TYPE_T_CANCEL_TICKET:
            process_cancelTicket(inm_buf);
            break;
        case INM_TYPE_O_CANCEL_TICKET:
            process_oms_cancelTicket(inm_buf);
            break;

        case INM_TYPE_FBS_SELL_TICKET:
            process_fbs_saleTicket(inm_buf);
            break;
        case INM_TYPE_FBS_PAY_TICKET:
            process_fbs_payTicket(inm_buf);
            break;
        case INM_TYPE_FBS_CANCEL_TICKET:
            process_fbs_cancelTicket(inm_buf);
            break;
        case INM_TYPE_O_FBS_PAY_TICKET:
            process_oms_fbs_payTicket(inm_buf);
            break;
        case INM_TYPE_O_FBS_CANCEL_TICKET:
            process_oms_fbs_cancelTicket(inm_buf);
            break;

        case INM_TYPE_TFE_CHECK_POINT:
            if (inm_msg->status == 0xFFFF) {
                //safe close checkpoint
                exit_signal_fired = 1;
            }
            break;
        default:
            break;
    }
    return;
}

static void tfe_adder_generate_tsn(char *inm_buf)
{
    INM_MSG_HEADER *pInmHeader = (INM_MSG_HEADER *)inm_buf;
    tfe_t_file_offset(&pInmHeader->tfe_file_idx, &pInmHeader->tfe_offset);
    time_t curtime = 0;
    time(&curtime);
    pInmHeader->tfe_when = (uint32)curtime;
    struct tm lt;
    localtime_r(&curtime, &lt);
    uint32 date = (lt.tm_year+1900)*10000 + (lt.tm_mon+1)*100 + lt.tm_mday;

    switch (pInmHeader->type)
    {
        case INM_TYPE_T_SELL_TICKET: {
            INM_MSG_T_SELL_TICKET* pInmSell = (INM_MSG_T_SELL_TICKET*)pInmHeader;
            pInmSell->unique_tsn = generate_digit_tsn(date, pInmSell->header.inm_header.tfe_file_idx, pInmSell->header.inm_header.tfe_offset);
        	generate_tsn(pInmSell->unique_tsn, pInmSell->rspfn_ticket);
            break;
        }
        case INM_TYPE_FBS_SELL_TICKET: {
            INM_MSG_FBS_SELL_TICKET* pInmFbsSell = (INM_MSG_FBS_SELL_TICKET*)pInmHeader;
            pInmFbsSell->unique_tsn = generate_digit_tsn(date, pInmFbsSell->header.inm_header.tfe_file_idx, pInmFbsSell->header.inm_header.tfe_offset);
        	generate_tsn(pInmFbsSell->unique_tsn, pInmFbsSell->rspfn_ticket);
            break;
        }
        case INM_TYPE_T_PAY_TICKET: {
            INM_MSG_T_PAY_TICKET* pInmPay = (INM_MSG_T_PAY_TICKET*)pInmHeader;
            pInmPay->unique_tsn_pay = generate_digit_tsn(date, pInmPay->header.inm_header.tfe_file_idx, pInmPay->header.inm_header.tfe_offset);
        	generate_tsn(pInmPay->unique_tsn_pay, pInmPay->rspfn_ticket_pay);
            break;
        }
        case INM_TYPE_FBS_PAY_TICKET: {
            INM_MSG_FBS_PAY_TICKET* pInmFbsPay = (INM_MSG_FBS_PAY_TICKET*)pInmHeader;
            pInmFbsPay->unique_tsn_pay = generate_digit_tsn(date, pInmFbsPay->header.inm_header.tfe_file_idx, pInmFbsPay->header.inm_header.tfe_offset);
        	generate_tsn(pInmFbsPay->unique_tsn_pay, pInmFbsPay->rspfn_ticket_pay);
            break;
        }
        case INM_TYPE_O_PAY_TICKET: {
            INM_MSG_O_PAY_TICKET* pInmOmsPay = (INM_MSG_O_PAY_TICKET*)pInmHeader;
            pInmOmsPay->unique_tsn_pay = generate_digit_tsn(date, pInmOmsPay->header.inm_header.tfe_file_idx, pInmOmsPay->header.inm_header.tfe_offset);
        	generate_tsn(pInmOmsPay->unique_tsn_pay, pInmOmsPay->rspfn_ticket_pay);
        	break;
        }
        case INM_TYPE_O_FBS_PAY_TICKET: {
            INM_MSG_O_FBS_PAY_TICKET* pInmOmsPay = (INM_MSG_O_FBS_PAY_TICKET*)pInmHeader;
            pInmOmsPay->unique_tsn_pay = generate_digit_tsn(date, pInmOmsPay->header.inm_header.tfe_file_idx, pInmOmsPay->header.inm_header.tfe_offset);
            generate_tsn(pInmOmsPay->unique_tsn_pay, pInmOmsPay->rspfn_ticket_pay);
            break;
        }
        case INM_TYPE_T_CANCEL_TICKET: {
            INM_MSG_T_CANCEL_TICKET* pInmCancel = (INM_MSG_T_CANCEL_TICKET*)pInmHeader;
            pInmCancel->unique_tsn_cancel = generate_digit_tsn(date, pInmCancel->header.inm_header.tfe_file_idx, pInmCancel->header.inm_header.tfe_offset);
        	generate_tsn(pInmCancel->unique_tsn_cancel, pInmCancel->rspfn_ticket_cancel);
            break;
        }
        case INM_TYPE_FBS_CANCEL_TICKET: {
            INM_MSG_FBS_CANCEL_TICKET* pInmCancel = (INM_MSG_FBS_CANCEL_TICKET*)pInmHeader;
            pInmCancel->unique_tsn_cancel = generate_digit_tsn(date, pInmCancel->header.inm_header.tfe_file_idx, pInmCancel->header.inm_header.tfe_offset);
        	generate_tsn(pInmCancel->unique_tsn_cancel, pInmCancel->rspfn_ticket_cancel);
            break;
        }
        case INM_TYPE_O_CANCEL_TICKET: {
            INM_MSG_O_CANCEL_TICKET* pInmOmsCancel = (INM_MSG_O_CANCEL_TICKET*)pInmHeader;
            pInmOmsCancel->unique_tsn_cancel = generate_digit_tsn(date, pInmOmsCancel->header.inm_header.tfe_file_idx, pInmOmsCancel->header.inm_header.tfe_offset);
        	generate_tsn(pInmOmsCancel->unique_tsn_cancel, pInmOmsCancel->rspfn_ticket_cancel);
            break;
        }
        case INM_TYPE_O_FBS_CANCEL_TICKET: {
            INM_MSG_O_FBS_CANCEL_TICKET* pInmOmsCancel = (INM_MSG_O_FBS_CANCEL_TICKET*)pInmHeader;
            pInmOmsCancel->unique_tsn_cancel = generate_digit_tsn(date, pInmOmsCancel->header.inm_header.tfe_file_idx, pInmOmsCancel->header.inm_header.tfe_offset);
            generate_tsn(pInmOmsCancel->unique_tsn_cancel, pInmOmsCancel->rspfn_ticket_cancel);
            break;
        }
        case INM_TYPE_AP_AUTODRAW: {
            INM_MSG_AP_PAY_TICKET* pInmOmsPay = (INM_MSG_AP_PAY_TICKET*)pInmHeader;
            pInmOmsPay->unique_tsn_pay = generate_digit_tsn(date, pInmOmsPay->header.inm_header.tfe_file_idx, pInmOmsPay->header.inm_header.tfe_offset);
            generate_tsn(pInmOmsPay->unique_tsn_pay, pInmOmsPay->rspfn_ticket_pay);
            break;
        }
        default: {
            break;
        }
    }
    return;
}

static void signal_handler(int sig)
{
    ts_notused(sig);
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
    ts_notused(argc); ts_notused(argv);

    logger_init(MY_TASK_NAME);
    log_info("%s start\n", MY_TASK_NAME);

    if (init_signal() != 0) { log_error("init_signal() failed."); return -1; }
    int pid = getpid();
    if (!sysdb_init()) { log_error("sysdb_init() failed."); return -1; }
    if (!bq_init()) { log_error("bq_init() failed."); return -1; }
    if (!tms_mgr()->TMSInit()) { log_error("tms_mgr()->TMSInit() failed."); return -1; }
    if (!gl_init()) { log_error("gl_init() failed."); return -1; }
    if (gl_game_plugins_init()!=0) { log_error("gl_game_plugins_init() failed."); return -1; }
    game_plugins_handle = gl_plugins_handle();

    char follow_str[128]; sprintf(follow_str, "%d", TFE_TASK_FLUSH);
	int ret = tfe_t_init(TFE_TASK_ADDER, 0, follow_str, false);
    if (0!=ret) { log_error("tfe_t_init() failed."); return -1; }
    FID fid = getFidByName(MY_TASK_NAME);
    if (!bq_register(fid, MY_TASK_NAME, pid)) { log_error("bq_register() failed."); return -1; }

    sysdb_setTaskStatus(SYS_TASK_TFE_ADDER, SYS_TASK_STATUS_RUN);
    log_info("%s init success\n", MY_TASK_NAME);

    static char inm_buf[INM_MSG_BUFFER_LENGTH+TFE_HEADER_LENGTH] = {0};
    while (0 == exit_signal_fired) {
        int len = bq_recv(fid, (inm_buf+TFE_HEADER_LENGTH), (INM_MSG_BUFFER_LENGTH-TFE_HEADER_LENGTH), 500);
        if (len < 0) {
            log_error("bq_recv() len < 0."); break;
        } else if (len == 0) {
            continue; //receive timeout
        }
        char *pInmBuf = inm_buf + TFE_HEADER_LENGTH;
        tfe_adder_dispatcher(pInmBuf);

        tfe_adder_generate_tsn(pInmBuf);
        while(1) {
            ret = tfe_t_write((const unsigned char *)inm_buf, (TFE_HEADER_LENGTH + *(uint16 *)pInmBuf));
            if (ret == TFE_TIMEOUT) {
                tfe_adder_generate_tsn(pInmBuf);
                log_debug("tfe_adder append TFE_TIMEOUT. ret [%d]", ret);
                continue;
            } else if (ret < 0) {
                log_warn("tfe_adder append record failed. ret [%d]", ret);
                ts_sleep(10*1000,0);
                continue;
            }
            break;
        }
    }
    sysdb_setTaskStatus(SYS_TASK_TFE_ADDER, SYS_TASK_STATUS_EXIT);

    bq_unregister(fid);
    gl_game_plugins_close(); game_plugins_handle = NULL;
	gl_close();	
	tms_mgr()->TMSClose();
    bq_close();
    sysdb_close();
    log_info("%s exit\n", MY_TASK_NAME);
    return 0;
}



