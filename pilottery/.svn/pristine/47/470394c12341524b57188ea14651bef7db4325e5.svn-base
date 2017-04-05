#include "global.h"
#include "gl_inf.h"
#include "tfe_inf.h"
#include "otl_inf.h"

#define MY_TASK_NAME "tfe_updater\0"

timer_t  tfeUpdateTimer;

static volatile int exit_signal_fired = 0;

static volatile int timer_fired = 0;
static int record_cnt = 0;
static int force_deal_flag = 0;

const int TFE_UPDATE_WORKER_COUNT = 2;
static int fbs_matchClose;
static int fbs_record_cnt = 0;

const char *ap_payover_sql = "SELECT reqfn_ticket,agency_code,winning_amount_tax, paid_status, reqfn_ticket_pay \
        FROM win_ticket_table WHERE is_train=0 AND from_sale=2 ";


//期次 期号 和 期次序号的对应关系，提高多期次循环处理的速度--------------
typedef map<uint64, uint64> UPDATE_ISSUE_MAP;
static UPDATE_ISSUE_MAP  update_issue_map;
uint64 map_get(uint8 game_code, uint32 issue_serial)
{
    uint64 key = (((uint64)game_code) << 56) + issue_serial;
    if (1 == update_issue_map.count(key))
    {
        return update_issue_map[key];
    }
    return 0;
}
int32 map_set(uint8 game_code, uint32 issue_serial, uint64 issue_number)
{
    uint64 key = (((uint64)game_code) << 56) + issue_serial;
    update_issue_map[key] = issue_number;
    return 0;
}
void map_del(uint8 game_code, uint32 issue_serial)
{
    uint64 key = (((uint64)game_code) << 56) + issue_serial;
    UPDATE_ISSUE_MAP::iterator iter;
    iter = update_issue_map.find(key);
    if (iter == update_issue_map.end())
        return;
    update_issue_map.erase(iter);
}
uint64 get_issue_number(uint8 game_code, uint32 issue_serial)
{
    uint64 issue_number = map_get(game_code, issue_serial);
    if (0 != issue_number)
    {
        return issue_number;
    }

    GIDB_ISSUE_HANDLE *i_handle = gidb_i_get_handle(game_code);
    if (i_handle == NULL)
    {
        log_error("gidb_i_get_handle(%d) failure", game_code);
        return -1;
    }
    GIDB_ISSUE_INFO issue_info;
    memset(&issue_info, 0, sizeof(GIDB_ISSUE_INFO));
    int ret = i_handle->gidb_i_get_info2(i_handle, issue_serial, &issue_info);
    if (ret != 0)
    {
        log_error("gidb_i_get_info2(%d %d) failure", game_code, issue_serial);
        return -1;
    }
    map_set(game_code, issue_serial, issue_info.issueNumber);
    return issue_info.issueNumber;
}

static int uproc_T_sell_ticket(INM_MSG_HEADER *pInm)
{
    int ret = 0;
    static char ticketBuf[INM_MSG_BUFFER_LENGTH];
    memset(ticketBuf, 0, INM_MSG_BUFFER_LENGTH);
    INM_MSG_T_SELL_TICKET *pInmSellTicket = (INM_MSG_T_SELL_TICKET *)pInm;

    if (SYS_RESULT_SUCCESS != pInmSellTicket->header.inm_header.status)
    {
        log_debug("uproc_T_sell_ticket(). sell ticket status[%d]", pInmSellTicket->header.inm_header.status);
        return 0;
    }

    uint8 game_code = pInmSellTicket->ticket.gameCode;
    uint64 issue_number = pInmSellTicket->ticket.issue;
    uint32 issue_serial = pInmSellTicket->ticket.issueSeq;
    GIDB_T_TICKET_HANDLE * t_handle = NULL;
    t_handle = gidb_t_get_handle(game_code, issue_number);
    if (t_handle == NULL)
    {
        log_error("gidb_t_get_handle(gameCode[%d], issue_number[%lld]) return null.", game_code, issue_number);
        return -1;
    }

    GIDB_SALE_TICKET_REC *pTicketSell = (GIDB_SALE_TICKET_REC *)ticketBuf;
    if (SYS_STATUS_DATA_SYNC == sysdb_getSysStatus())
    {
        ret = t_handle->gidb_t_get_ticket(t_handle, pInmSellTicket->unique_tsn, pTicketSell);
        if (ret == 0)
        {
            //找到了,此票已插入
            return 0;
        }
        else if (ret < 0)
        {
            log_error("gidb_t_get_ticket error. (gameCode[%d], issue_number[%lld] unique_tsn[%llu]) ",
                game_code, issue_number, pInmSellTicket->unique_tsn);
            return -1;
        }
    }
    //没有找到
    memset(ticketBuf, 0, sizeof(ticketBuf));
    T_sell_inm_rec_2_db_ticket_rec(pInmSellTicket, pTicketSell);

    ret = t_handle->gidb_t_insert_ticket(t_handle, pTicketSell);
    if (ret != 0)
    {
        log_error("gidb_t_insert_ticket rspfn_ticket[%s] false.", pTicketSell->rspfn_ticket);
        return -1;
    }

    //将此票循环加入预售的其他期次
    if (pTicketSell->ticket.issueCount > 1)
    {
        GIDB_T_TICKET_HANDLE * t_handle_pre = NULL;
        for (int i = 1; i < pTicketSell->ticket.issueCount; i++)
        {
            issue_number = get_issue_number(game_code, (issue_serial + i));
            if (issue_number == 0)
            {
                log_error("get_issue_number(%d, %d) error.", game_code, (issue_serial + i));
                return -1;
            }

            t_handle_pre = gidb_t_get_handle(game_code, issue_number);
            if (NULL == t_handle_pre)
            {
                log_error("gidb_t_get_handle(%d, %lld) error.", game_code, issue_number);
                return -1;
            }

            ret = t_handle_pre->gidb_t_insert_ticket(t_handle_pre, pTicketSell);
            if (ret != 0)
            {
                log_error("gidb_t_insert_ticket rspfn_ticket[%s] false. A", pTicketSell->rspfn_ticket);
                return -1;
            }
        }
    }

    //save index data
    GIDB_TICKET_IDX_HANDLE * tidx_handle = NULL;
    uint32 date = c_date(pInmSellTicket->unique_tsn / D15);
    tidx_handle = gidb_tidx_get_handle(date);
    if (tidx_handle == NULL)
    {
        log_error("gidb_tidx_get_handle( %u ) return null.", date);
        return -1;
    }
    GIDB_TICKET_IDX_REC *pTIdxRec = (GIDB_TICKET_IDX_REC *)ticketBuf;
    memset(ticketBuf, 0, sizeof(GIDB_TICKET_IDX_REC));
    T_sell_inm_rec_2_db_tidx_rec(pInmSellTicket, pTIdxRec);

    ret = tidx_handle->gidb_tidx_insert_ticket(tidx_handle, pTIdxRec);
    if (ret != 0)
    {
        log_error("gidb_tidx_insert_ticket error. (unique_tsn[%llu]) ", pTIdxRec->unique_tsn);
        return -1;
    }
    return 0;
}

static int uproc_T_pay_ticket(INM_MSG_HEADER *pInm)
{
    int ret = 0;
    static char ticketBuf[INM_MSG_BUFFER_LENGTH];
    INM_MSG_T_PAY_TICKET *pInmPayTicket = (INM_MSG_T_PAY_TICKET *)pInm;

    if (SYS_RESULT_SUCCESS != pInmPayTicket->header.inm_header.status)
    {
        log_error("uproc_T_pay_ticket(). *** bad message ***");
        return 0;
    }

    GIDB_W_TICKET_HANDLE * w_handle = gidb_w_get_handle(pInmPayTicket->gameCode, pInmPayTicket->saleLastIssue, GAME_DRAW_ONE);
    if (w_handle == NULL)
    {
        log_error("gidb_w_get_handle(gameCode[%u], issueNumber[%lld]) return null.", pInmPayTicket->gameCode, pInmPayTicket->saleLastIssue);
        return -1;
    }

    GIDB_PAY_TICKET_STRUCT *pTicketPay = (GIDB_PAY_TICKET_STRUCT *)ticketBuf;
    memset(ticketBuf, 0, sizeof(ticketBuf));
    T_pay_inm_rec_2_db_ticket_rec(pInmPayTicket, pTicketPay);

    ret = w_handle->gidb_w_update_pay(w_handle, pTicketPay);
    if (0 != ret)
    {
        log_error("gidb_w_update_pay rspfn_ticket[%s] false.", pTicketPay->rspfn_ticket);
        return -1;
    }
    return 0;
}

static int uproc_T_cancel_ticket(INM_MSG_HEADER *pInm)
{
    int ret = 0;
    INM_MSG_T_CANCEL_TICKET *pInmCancelTicket = (INM_MSG_T_CANCEL_TICKET *)pInm;

    if (SYS_RESULT_SUCCESS != pInmCancelTicket->header.inm_header.status)
    {
        log_error("uproc_T_cancel_ticket(). *** bad message ***");
        return 0;
    }

    uint8 game_code = pInmCancelTicket->ticket.gameCode;
    uint64 issue_number = pInmCancelTicket->ticket.issue;
    uint32 issue_serial = pInmCancelTicket->ticket.issueSeq;
    GIDB_T_TICKET_HANDLE * t_handle = NULL;
    t_handle = gidb_t_get_handle(game_code, issue_number);
    if (t_handle == NULL)
    {
        log_error("gidb_t_get_handle(gameCode[%d], issue_number[%lld]) return null.", game_code, issue_number);
        return -1;
    }

    static char ticketBuf[INM_MSG_BUFFER_LENGTH];
    memset(ticketBuf, 0, INM_MSG_BUFFER_LENGTH);
    GIDB_CANCEL_TICKET_STRUCT *pTicketCancel = (GIDB_CANCEL_TICKET_STRUCT *)ticketBuf;
    T_cancel_inm_rec_2_db_ticket_rec(pInmCancelTicket, pTicketCancel);

    ret = t_handle->gidb_t_update_cancel(t_handle, pTicketCancel);
    if (0 != ret)
    {
        log_error("gidb_t_update_cancel rspfn_ticket[%s] false.", pTicketCancel->rspfn_ticket);
        return -1;
    }

    //将此票循环在预售的其他期次中退票
    if (pInmCancelTicket->ticket.issueCount > 1)
    {
        GIDB_T_TICKET_HANDLE * t_handle_pre = NULL;
        for (int i = 1; i < pInmCancelTicket->ticket.issueCount; i++)
        {
            issue_number = get_issue_number(game_code, (issue_serial + i));
            if (issue_number == 0)
            {
                log_error("get_issue_number(%d, %d) error.", game_code, (issue_serial + i));
                return -1;
            }

            t_handle_pre = gidb_t_get_handle(game_code, issue_number);
            if (NULL == t_handle_pre)
            {
                log_error("gidb_t_get_handle(%d, %lld) error.", game_code, issue_number);
                return -1;
            }

            ret = t_handle_pre->gidb_t_update_cancel(t_handle_pre, pTicketCancel);
            if (ret != 0)
            {
                log_error("gidb_t_update_cancel rspfn_ticket[%s] false. A", pTicketCancel->rspfn_ticket);
                return -1;
            }
        }

    }
    return 0;
}


static int uproc_FBS_sell_ticket(INM_MSG_HEADER *pInm)
{
    int ret = 0;
    INM_MSG_FBS_SELL_TICKET *pFbsInmSellTicket = (INM_MSG_FBS_SELL_TICKET *)pInm;
    FBS_TICKET *fbs_ticket = (FBS_TICKET *)(pFbsInmSellTicket->betString + pFbsInmSellTicket->betStringLen);

    if (SYS_RESULT_SUCCESS != pFbsInmSellTicket->header.inm_header.status)
    {
        log_debug("uproc_FBS_sell_ticket(). sell ticket status[%d]", pFbsInmSellTicket->header.inm_header.status);
        return 0;
    }

    //k-debug:FBS
    log_info("issue:%d", fbs_ticket->issue_number);

    uint8 game_code = fbs_ticket->game_code;
    uint32 issue_number = fbs_ticket->issue_number;
    GIDB_FBS_ST_HANDLE * fbs_st_handle = NULL;
    fbs_st_handle = gidb_fbs_st_get_handle(game_code, issue_number);
    if (fbs_st_handle == NULL) {
        log_error("gidb_fbs_st_get_handle(gameCode[%d], issue_number[%d]) return null.", game_code, issue_number);
        return -1;
    }

    static char ticketBuf[INM_MSG_BUFFER_LENGTH];
    memset(ticketBuf, 0, sizeof(ticketBuf));
    GIDB_FBS_ST_REC *pSTicket = (GIDB_FBS_ST_REC *)ticketBuf;
    if (SYS_STATUS_DATA_SYNC == sysdb_getSysStatus()) {
        ret = fbs_st_handle->gidb_fbs_st_get_ticket(fbs_st_handle, pFbsInmSellTicket->unique_tsn, pSTicket);
        if (ret == 0) {
            //找到了,此票已插入
            return 0;
        }
        else if (ret < 0) {
            log_error("gidb_fbs_st_get_ticket error. (gameCode[%d], issue_number[%d] unique_tsn[%llu]) ",
                game_code, issue_number, pFbsInmSellTicket->unique_tsn);
            return -1;
        }
    }
    //没有找到
    memset(ticketBuf, 0, sizeof(ticketBuf));
    fbs_sell_inm_rec_2_db_ticket_rec(pFbsInmSellTicket, pSTicket);

    ret = fbs_st_handle->gidb_fbs_st_insert_ticket(fbs_st_handle, pSTicket);
    if (ret != 0) {
        log_error("gidb_fbs_st_insert_ticket rspfn_ticket[%s] false.", pSTicket->rspfn_ticket);
        return -1;
    }

    //save index data
    GIDB_TICKET_IDX_HANDLE * tidx_handle = NULL;
    uint32 date = c_date(pFbsInmSellTicket->unique_tsn / D15);
    tidx_handle = gidb_tidx_get_handle(date);
    if (tidx_handle == NULL) {
        log_error("gidb_tidx_get_handle( %u ) return null.", date);
        return -1;
    }
    GIDB_TICKET_IDX_REC *pTIdxRec = (GIDB_TICKET_IDX_REC *)ticketBuf;
    memset(ticketBuf, 0, sizeof(GIDB_TICKET_IDX_REC));
    fbs_sell_inm_rec_2_db_tidx_rec(pFbsInmSellTicket, pTIdxRec);
    ret = tidx_handle->gidb_tidx_insert_ticket(tidx_handle, pTIdxRec);
    if (ret != 0)
    {
        log_error("gidb_tidx_insert_ticket error. (unique_tsn[%llu]) ", pTIdxRec->unique_tsn);
        return -1;
    }
    return 0;
}
static int uproc_FBS_pay_ticket(INM_MSG_HEADER *pInm)
{
    int ret = 0;
    INM_MSG_FBS_PAY_TICKET *pFbsInmPayTicket = (INM_MSG_FBS_PAY_TICKET *)pInm;

    if (SYS_RESULT_SUCCESS != pFbsInmPayTicket->header.inm_header.status) {
        log_error("uproc_FBS_pay_ticket(). *** bad message ***");
        return 0;
    }

    GIDB_FBS_WT_HANDLE * fbs_wt_handle = NULL;
    fbs_wt_handle = gidb_fbs_wt_get_handle(pFbsInmPayTicket->gameCode, (uint32)pFbsInmPayTicket->issueNumber);
    if (fbs_wt_handle == NULL) {
        log_error("gidb_fbs_wt_get_handle(gameCode[%d], issue_number[%d]) return null.", pFbsInmPayTicket->gameCode, (uint32)pFbsInmPayTicket->issueNumber);
        return -1;
    }

    static char ticketBuf[INM_MSG_BUFFER_LENGTH];
    memset(ticketBuf, 0, sizeof(ticketBuf));
    GIDB_FBS_PT_STRUCT *pPTicket = (GIDB_FBS_PT_STRUCT *)ticketBuf;
    fbs_pay_inm_rec_2_db_ticket_rec(pFbsInmPayTicket, pPTicket);

    ret = fbs_wt_handle->gidb_fbs_wt_update_pay(fbs_wt_handle, pPTicket);
    if (0 != ret) {
        log_error("gidb_fbs_wt_update_pay rspfn_ticket[%s] false.", pPTicket->rspfn_ticket);
        return -1;
    }
    return 0;
}
static int uproc_FBS_cancel_ticket(INM_MSG_HEADER *pInm)
{
    int ret = 0;
    INM_MSG_FBS_CANCEL_TICKET *pFbsInmCancelTicket = (INM_MSG_FBS_CANCEL_TICKET *)pInm;
    FBS_TICKET *fbs_ticket = &pFbsInmCancelTicket->ticket;

    if (SYS_RESULT_SUCCESS != pFbsInmCancelTicket->header.inm_header.status) {
        log_error("uproc_FBS_cancel_ticket(). *** bad message ***");
        return 0;
    }

    uint8 game_code = fbs_ticket->game_code;
    uint32 issue_number = fbs_ticket->issue_number;
    GIDB_FBS_ST_HANDLE * fbs_st_handle = NULL;
    fbs_st_handle = gidb_fbs_st_get_handle(game_code, issue_number);
    if (fbs_st_handle == NULL) {
        log_error("gidb_fbs_st_get_handle(gameCode[%d], issue_number[%d]) return null.", game_code, issue_number);
        return -1;
    }

    static char ticketBuf[INM_MSG_BUFFER_LENGTH];
    memset(ticketBuf, 0, INM_MSG_BUFFER_LENGTH);
    GIDB_FBS_CT_STRUCT *pCTicket = (GIDB_FBS_CT_STRUCT *)ticketBuf;
    fbs_cancel_inm_rec_2_db_ticket_rec(pFbsInmCancelTicket, pCTicket);

    ret = fbs_st_handle->gidb_fbs_st_update_cancel(fbs_st_handle, pCTicket);
    if (0 != ret) {
        log_error("gidb_fbs_st_update_cancel rspfn_ticket[%s] false.", pCTicket->rspfn_ticket);
        return -1;
    }
    return 0;
}


static int uproc_OMS_pay_ticket(INM_MSG_HEADER *pInm)
{
    int ret = 0;
    static char ticketBuf[INM_MSG_BUFFER_LENGTH];
    INM_MSG_O_PAY_TICKET *pInmPayTicket = (INM_MSG_O_PAY_TICKET *)pInm;

    if (SYS_RESULT_SUCCESS != pInmPayTicket->header.inm_header.status)
    {
        log_error("uproc_OMS_pay_ticket(). *** bad message ***");
        return 0;
    }

    GIDB_W_TICKET_HANDLE * w_handle = gidb_w_get_handle(pInmPayTicket->gameCode, pInmPayTicket->saleLastIssue, GAME_DRAW_ONE);
    if (w_handle == NULL)
    {
        log_error("gidb_w_get_handle(gameCode[%u], issueNumber[%lld]) return null.", pInmPayTicket->gameCode, pInmPayTicket->saleLastIssue);
        return -1;
    }

    GIDB_PAY_TICKET_STRUCT *pTicketPay = (GIDB_PAY_TICKET_STRUCT *)ticketBuf;
    memset(ticketBuf, 0, sizeof(ticketBuf));
    O_pay_inm_rec_2_db_ticket_rec(pInmPayTicket, pTicketPay);

    ret = w_handle->gidb_w_update_pay(w_handle, pTicketPay);
    if (0 != ret)
    {
        log_error("gidb_w_update_pay rspfn_ticket[%s] false.", pTicketPay->rspfn_ticket);
        return -1;
    }
    return 0;
}

static int uproc_OMS_fbs_pay_ticket(INM_MSG_HEADER *pInm)
{
    int ret = 0;
    INM_MSG_O_FBS_PAY_TICKET *pFbsInmPayTicket = (INM_MSG_O_FBS_PAY_TICKET *)pInm;

    if (SYS_RESULT_SUCCESS != pFbsInmPayTicket->header.inm_header.status) {
        log_error("uproc_OMS_fbs_pay_ticket(). *** bad message ***");
        return 0;
    }

    GIDB_FBS_WT_HANDLE * fbs_wt_handle = NULL;
    fbs_wt_handle = gidb_fbs_wt_get_handle(pFbsInmPayTicket->gameCode, (uint32)pFbsInmPayTicket->issueNumber);
    if (fbs_wt_handle == NULL) {
        log_error("gidb_fbs_wt_get_handle(gameCode[%d], issue_number[%d]) return null.",
            pFbsInmPayTicket->gameCode, (uint32)pFbsInmPayTicket->issueNumber);
        return -1;
    }

    static char ticketBuf[INM_MSG_BUFFER_LENGTH];
    memset(ticketBuf, 0, sizeof(ticketBuf));
    GIDB_FBS_PT_STRUCT *pPTicket = (GIDB_FBS_PT_STRUCT *)ticketBuf;
    O_fbs_pay_inm_rec_2_db_ticket_rec(pFbsInmPayTicket, pPTicket);

    ret = fbs_wt_handle->gidb_fbs_wt_update_pay(fbs_wt_handle, pPTicket);
    if (0 != ret) {
        log_error("gidb_fbs_wt_update_pay rspfn_ticket[%s] false.", pPTicket->rspfn_ticket);
        return -1;
    }
    return 0;
}

static int uproc_OMS_cancel_ticket(INM_MSG_HEADER *pInm)
{
    int ret = 0;
    INM_MSG_O_CANCEL_TICKET *pInmCancelTicket = (INM_MSG_O_CANCEL_TICKET *)pInm;

    if (SYS_RESULT_SUCCESS != pInmCancelTicket->header.inm_header.status)
    {
        log_error("uproc_OMS_cancel_ticket(). *** bad message ***");
        return 0;
    }

    uint8 game_code = pInmCancelTicket->ticket.gameCode;
    uint64 issue_number = pInmCancelTicket->ticket.issue;
    uint32 issue_serial = pInmCancelTicket->ticket.issueSeq;
    GIDB_T_TICKET_HANDLE * t_handle = NULL;
    t_handle = gidb_t_get_handle(game_code, issue_number);
    if (t_handle == NULL)
    {
        log_error("gidb_t_get_handle(gameCode[%d], issue_number[%lld]) return null.", game_code, issue_number);
        return -1;
    }

    static char ticketBuf[INM_MSG_BUFFER_LENGTH];
    memset(ticketBuf, 0, INM_MSG_BUFFER_LENGTH);
    GIDB_CANCEL_TICKET_STRUCT *pTicketCancel = (GIDB_CANCEL_TICKET_STRUCT *)ticketBuf;
    O_cancel_inm_rec_2_db_ticket_rec(pInmCancelTicket, pTicketCancel);

    ret = t_handle->gidb_t_update_cancel(t_handle, pTicketCancel);
    if (0 != ret)
    {
        log_error("gidb_t_update_cancel rspfn_ticket[%s] false.", pTicketCancel->rspfn_ticket);
        return -1;
    }

    //将此票循环在预售的其他期次中退票
    if (pInmCancelTicket->ticket.issueCount > 1)
    {
        GIDB_T_TICKET_HANDLE * t_handle_pre = NULL;
        for (int i = 1; i < pInmCancelTicket->ticket.issueCount; i++)
        {
            issue_number = get_issue_number(game_code, (issue_serial + i));
            if (issue_number == 0)
            {
                log_error("get_issue_number(%d, %d) error.", game_code, (issue_serial + i));
                return -1;
            }

            t_handle_pre = gidb_t_get_handle(game_code, issue_number);
            if (NULL == t_handle_pre)
            {
                log_error("gidb_t_get_handle(%d, %lld) error.", game_code, issue_number);
                return -1;
            }

            ret = t_handle_pre->gidb_t_update_cancel(t_handle_pre, pTicketCancel);
            if (ret != 0)
            {
                log_error("gidb_t_update_cancel rspfn_ticket[%s] false. A", pTicketCancel->rspfn_ticket);
                return -1;
            }
        }

    }
    return 0;
}

static int uproc_OMS_fbs_cancel_ticket(INM_MSG_HEADER *pInm)
{
    int ret = 0;
    INM_MSG_O_FBS_CANCEL_TICKET *pFbsInmCancelTicket = (INM_MSG_O_FBS_CANCEL_TICKET *)pInm;
    FBS_TICKET *fbs_ticket = &pFbsInmCancelTicket->ticket;

    if (SYS_RESULT_SUCCESS != pFbsInmCancelTicket->header.inm_header.status) {
        log_error("uproc_OMS_FBS_cancel_ticket(). *** bad message ***");
        return 0;
    }

    uint8 game_code = fbs_ticket->game_code;
    uint32 issue_number = fbs_ticket->issue_number;
    GIDB_FBS_ST_HANDLE * fbs_st_handle = NULL;
    fbs_st_handle = gidb_fbs_st_get_handle(game_code, issue_number);
    if (fbs_st_handle == NULL) {
        log_error("gidb_fbs_st_get_handle(gameCode[%d], issue_number[%d]) return null.", game_code, issue_number);
        return -1;
    }

    static char ticketBuf[INM_MSG_BUFFER_LENGTH];
    memset(ticketBuf, 0, INM_MSG_BUFFER_LENGTH);
    GIDB_FBS_CT_STRUCT *pCTicket = (GIDB_FBS_CT_STRUCT *)ticketBuf;
    O_fbs_cancel_inm_rec_2_db_ticket_rec(pFbsInmCancelTicket, pCTicket);

    ret = fbs_st_handle->gidb_fbs_st_update_cancel(fbs_st_handle, pCTicket);
    if (0 != ret) {
        log_error("gidb_fbs_st_update_cancel rspfn_ticket[%s] false.", pCTicket->rspfn_ticket);
        return -1;
    }
    return 0;
}


int32 process_issue_closed(INM_MSG_HEADER *inm_buf)
{
    int ret = 0;

    INM_MSG_ISSUE_CLOSE *state_rec_ptr = (INM_MSG_ISSUE_CLOSE *)inm_buf;
    uint8 game_code = state_rec_ptr->gameCode;
    uint64 issue_number = state_rec_ptr->issueNumber;
    int32 issue_status = ISSUE_STATE_SEALED;


    //-------------------------------------------------------------
    //下面进行期次的封存
    //-------------------------------------------------------------


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

    /*//对销售数据文件进行MD5签名
    char game_abbr[16] = {0};
    get_game_abbr(game_code, game_abbr);
    char db_path[256] = {0};
    ts_get_game_issue_ticket_filepath(game_abbr, issue_number, db_path, 256);
    ret = md5_file(db_path, NULL);
    if (ret < 0)
    {
        log_error("md5_file(game_code[%d] issue_num[%lld]) failed.", game_code, issue_number);
        return -1;
    }

    //对销售数据文件进行备份
    char seal_path[256] = {0};
    ts_get_game_issue_seal_data_filepath(game_abbr, issue_number, seal_path, 256);
    char cmd_str[256] = {0};
    sprintf(cmd_str, "cp %s %s", db_path, seal_path);
    system(cmd_str);

    ret = md5_file(seal_path, NULL);
    if (ret < 0)
    {
        log_error("md5_file(game_code[%d] issue_num[%lld]) failed.", game_code, issue_number);
        return -1;
    }*/


    //更新数据库期次状态
    time_t t = time(NULL);
    if (!otl_set_issue_status(game_code, issue_number, issue_status, t))
    {
        log_error("otl_set_issue_status(game_code[%u] issue_number[%llu] issue_status[%s] ) failed.",
            game_code, issue_number, ISSUE_STATE_STR(issue_status));
        return -1;
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
    send_issue_status_notify(game_code, issue_number, issue_status);


    //向开奖日志表写入一条记录，通知gl_draw任务，此期次可以进行开奖
    ret = send_issue_status_message(game_code, issue_number, INM_TYPE_ISSUE_STATE_SEALED, GAME_DRAW_ONE);
    if (ret < 0)
    {
        log_error("Send issue seal state faulire. game[%d] issue[%lld]. **** NEED Manual send issue_seal_state ***",
            game_code, issue_number);
        return -1;
    }

    log_info("Exit Issue Process [%d - %lld  %s]--->", game_code, issue_number, ISSUE_STATE_STR(issue_status));
    return 0;
}

int32 process_fbs_match_close(INM_MSG_HEADER *inm_buf)
{
    int ret = 0;

    INM_MSG_O_FBS_MATCH_STATE* rec = (INM_MSG_O_FBS_MATCH_STATE *)inm_buf;
    uint8 game_code = rec->gameCode;
    uint8 issue_number = rec->issueNumber;
    uint8 match_code = rec->matchCode;



    //更新本地内存CACHE中的期次状态
    GIDB_FBS_IM_HANDLE *fbs_im_handle = gidb_fbs_im_get_handle(game_code);
    if (fbs_im_handle == NULL)
    {
        log_error("gidb_fbs_im_get_handle fail,game[%d]", game_code);
        return -1;
    }
    /*
    ret = fbs_im_handle->gidb_i_set_status(fbs_im_handle, issue_number, issue_status, t);
    if (ret != 0)
    {
        log_error("gidb_i_set_status(%d, %lld, %s) error", game_code, issue_number, dump_game_status(issue_status));
        return -1;
    }
    */








    //    //更新数据库比赛状态
    //    if ( !otl_fbs_set_match_state(game_code, match_code, M_STATE_CLOSE) ) {
    //        log_error("otl_fbs_set_match_state(match_code[%u]  M_STATE_CLOSE) failed.", match_code);
    //        return -1;
    //    }

        //更新内存的比赛状态
        //match state = M_STATE_RESULT
        //
        //
        //
        //
        //
        //

    log_info("FBS match close. match[ %u ]", rec->matchCode);
    return 0;
}

static int uproc_AP_pay_ticket(INM_MSG_HEADER *pInm)
{
    int ret = 0;
    static char ticketBuf[INM_MSG_BUFFER_LENGTH];
    INM_MSG_AP_PAY_TICKET *pInmPayTicket = (INM_MSG_AP_PAY_TICKET *)pInm;

    if (SYS_RESULT_SUCCESS != pInmPayTicket->header.inm_header.status)
    {
        log_error("uproc_AP_pay_ticket(). *** bad message ***");
        return 0;
    }

    if ((pInmPayTicket->game_code == GAME_FBS) || (pInmPayTicket->game_code == GAME_FODD))
    {
        GIDB_FBS_WT_HANDLE * w_handle = gidb_fbs_wt_get_handle(pInmPayTicket->game_code, pInmPayTicket->issue);
        if (w_handle == NULL)
        {
            log_error("gidb_w_get_handle(gameCode[%u], issueNumber[%lld]) return null.", pInmPayTicket->game_code, pInmPayTicket->issue);
            return -1;
        }

        GIDB_FBS_PT_STRUCT *pTicketPay = (GIDB_FBS_PT_STRUCT *)ticketBuf;
        memset(ticketBuf, 0, sizeof(ticketBuf));
        AP_fbs_pay_inm_rec_2_db_ticket_rec(pInmPayTicket, pTicketPay);

        ret = w_handle->gidb_fbs_wt_update_pay(w_handle, pTicketPay);
        if (0 != ret)
        {
            log_error("gidb_fbs_wt_update_pay rspfn_ticket[%s] false.", pTicketPay->rspfn_ticket);
            return -1;
        }
    }
    else
    {
        GIDB_W_TICKET_HANDLE * w_handle = gidb_w_get_handle(pInmPayTicket->game_code, pInmPayTicket->issue, GAME_DRAW_ONE);
        if (w_handle == NULL)
        {
            log_error("gidb_w_get_handle(gameCode[%u], issueNumber[%lld]) return null.", pInmPayTicket->game_code, pInmPayTicket->issue);
            return -1;
        }

        GIDB_PAY_TICKET_STRUCT *pTicketPay = (GIDB_PAY_TICKET_STRUCT *)ticketBuf;
        memset(ticketBuf, 0, sizeof(ticketBuf));
        AP_pay_inm_rec_2_db_ticket_rec(pInmPayTicket, pTicketPay);

        ret = w_handle->gidb_w_update_pay(w_handle, pTicketPay);
        if (0 != ret)
        {
            log_error("gidb_w_update_pay rspfn_ticket[%s] false.", pTicketPay->rspfn_ticket);
            return -1;
        }
    }
    return 0;
}


static int uproc_AP_pay_ticket_over(INM_MSG_HEADER *pInm)
{
    int rc;

    sqlite3_stmt *pStmt = NULL;

    INM_MSG_AP_PAY_OVER *pInmOver = (INM_MSG_AP_PAY_OVER *)pInm;

    if (SYS_RESULT_SUCCESS != pInmOver->header.inm_header.status)
    {
        log_error("uproc_AP_pay_ticket_over(). *** bad message ***");
        return 0;
    }

    char game_abbr[16] = { 0 };
    get_game_abbr(pInmOver->game_code, game_abbr);
    char ap_pay_over_file[256] = { 0 };

    ts_get_game_issue_ap_pay_filepath(game_abbr, pInmOver->game_code, pInmOver->issue, ap_pay_over_file, 256);
    FILE* filePtr = fopen(ap_pay_over_file, "w");
    if (filePtr == NULL)
    {
        log_error("fdopen %s error!", ap_pay_over_file);
        return -1;
    }

    if ((pInmOver->game_code == GAME_FBS) || (pInmOver->game_code == GAME_FODD))
    {
        GIDB_FBS_WT_HANDLE * w_handle = gidb_fbs_wt_get_handle(pInmOver->game_code, pInmOver->issue);
        if (w_handle == NULL)
        {
            log_error("gidb_w_get_handle(gameCode[%u], issueNumber[%lld]) return null.", pInmOver->game_code, pInmOver->issue);
            fclose(filePtr);
            return -1;
        }

        rc = sqlite3_prepare_v2(w_handle->db, ap_payover_sql, strlen(ap_payover_sql), &pStmt, NULL);
        if (rc != SQLITE_OK)
        {
            log_error("sqlite3_prepare_v2() error. [%d]", rc);
            if (pStmt)
                sqlite3_finalize(pStmt);
            fclose(filePtr);
            return -1;
        }
    }
    else
    {
        GIDB_W_TICKET_HANDLE * w_handle = gidb_w_get_handle(pInmOver->game_code, pInmOver->issue, GAME_DRAW_ONE);
        if (w_handle == NULL)
        {
            log_error("gidb_w_get_handle(gameCode[%u], issueNumber[%lld]) return null.", pInmOver->game_code, pInmOver->issue);
            fclose(filePtr);
            return -1;
        }

        rc = sqlite3_prepare_v2(w_handle->db, ap_payover_sql, strlen(ap_payover_sql), &pStmt, NULL);
        if (rc != SQLITE_OK)
        {
            log_error("sqlite3_prepare_v2() error. [%d]", rc);
            if (pStmt)
                sqlite3_finalize(pStmt);
            fclose(filePtr);
            return -1;
        }
    }

    uint64 agencyCode;
    char   ticket_sell_tsn[TSN_LENGTH];
    char   ticket_pay_tsn[TSN_LENGTH];
    money_t win_amount_tax;
    uint8 paid_status;
    while (true)
    {
        rc = sqlite3_step(pStmt);
        if (rc == SQLITE_ROW)
        {
            memset(ticket_sell_tsn, 0, TSN_LENGTH);

            char *rspfn = (char*)sqlite3_column_text(pStmt, 0);
            if (rspfn != NULL)
            {
                strcpy(ticket_sell_tsn, rspfn);
            }
            agencyCode = sqlite3_column_int64(pStmt, 1);
            win_amount_tax = sqlite3_column_int64(pStmt, 2);
            paid_status = sqlite3_column_int(pStmt, 3);

            memset(ticket_pay_tsn, 0, TSN_LENGTH);

            char *paytsn = (char*)sqlite3_column_text(pStmt, 4);
            if (paytsn != NULL)
            {
                strcpy(ticket_pay_tsn, paytsn);
            }

            int is_pay = (paid_status > 1) ? 1 : 0;

            fprintf(filePtr, "%llu %s %s %lld %d\n", agencyCode, ticket_sell_tsn, ticket_pay_tsn, win_amount_tax, is_pay);
        }
        else if (rc == SQLITE_DONE)
        {
            break;
        }
        else
        {
            //found error
            log_error("sqlite3_step error. (%d, %llu). rc[%d]", pInmOver->game_code, pInmOver->issue, rc);
            if (pStmt)
                sqlite3_finalize(pStmt);
            fclose(filePtr);
            return -1;
        }
    }

    sqlite3_finalize(pStmt);
    fclose(filePtr);
    log_info("create ap win and pay file: %s", ap_pay_over_file);

    char ap_pay_over_flag_file[256] = { 0 };
    ts_get_game_issue_ap_paidover_filepath(game_abbr, pInmOver->game_code, pInmOver->issue, ap_pay_over_flag_file, 256);
    FILE* fileap = fopen(ap_pay_over_flag_file, "w");
    if (fileap == NULL)
    {
        log_error("fdopen %s error!", ap_pay_over_flag_file);
        return false;
    }
    fclose(fileap);
    log_info("create ap pay over file: %s", ap_pay_over_flag_file);

    return 0;
}


static int tfe_updater_dispatcher(char *inm_buf)
{
    INM_MSG_HEADER *pInm = (INM_MSG_HEADER *)inm_buf;
    switch (pInm->type)
    {
    case INM_TYPE_ISSUE_STATE_PRESALE:
    {
        INM_MSG_ISSUE_PRESALE *ptr = (INM_MSG_ISSUE_PRESALE *)inm_buf;
        map_set(ptr->gameCode, ptr->serialNumber, ptr->issueNumber);
        break;
    }
    case INM_TYPE_ISSUE_STATE_CLOSED:
    {
        force_deal_flag = 1;
        record_cnt++;
        break;
    }
    // FBS
    case INM_TYPE_O_FBS_MATCH_CLOSE:
    {
        //比赛销售截止
        force_deal_flag = 1;
        record_cnt++;
        break;
    }

    case INM_TYPE_TFE_CHECK_POINT:
    {
        if ((SYS_STATUS_END == sysdb_getSysStatus()) && (pInm->status == 0xFFFF))
        {
            //safe close checkpoint
            timer_fired = 1;
            exit_signal_fired = 1;
        }
        break;
    }

    case INM_TYPE_T_SELL_TICKET:
        record_cnt++;
        return uproc_T_sell_ticket(pInm);
    case INM_TYPE_T_PAY_TICKET:
        record_cnt++;
        return uproc_T_pay_ticket(pInm);
    case INM_TYPE_T_CANCEL_TICKET:
        record_cnt++;
        return uproc_T_cancel_ticket(pInm);

    case INM_TYPE_FBS_SELL_TICKET:
        fbs_record_cnt++;
        return uproc_FBS_sell_ticket(pInm);
    case INM_TYPE_FBS_PAY_TICKET:
        fbs_record_cnt++;
        return uproc_FBS_pay_ticket(pInm);
    case INM_TYPE_FBS_CANCEL_TICKET:
        fbs_record_cnt++;
        return uproc_FBS_cancel_ticket(pInm);

    case INM_TYPE_O_PAY_TICKET:
        record_cnt++;
        return uproc_OMS_pay_ticket(pInm);
    case INM_TYPE_O_CANCEL_TICKET:
        record_cnt++;
        return uproc_OMS_cancel_ticket(pInm);
    case INM_TYPE_O_FBS_PAY_TICKET:
        record_cnt++;
        return uproc_OMS_fbs_pay_ticket(pInm);
    case INM_TYPE_O_FBS_CANCEL_TICKET:
        record_cnt++;
        return uproc_OMS_fbs_cancel_ticket(pInm);

    case INM_TYPE_AP_AUTODRAW:
        record_cnt++;
        return uproc_AP_pay_ticket(pInm);

    case INM_TYPE_AP_AUTODRAW_OVER:
        force_deal_flag = 1;
        record_cnt++;
        break;

    default:
        return 1;
    }
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

int main(int argc, char **argv)
{
    ts_notused(argc);
    ts_notused(argv);

    int ret = 0;

    logger_init(MY_TASK_NAME);
    log_info("%s start\n", MY_TASK_NAME);

    init_signal();

    tfeUpdateTimer = ts_timer_init(signal_alarm);
    if (tfeUpdateTimer < 0)
    {
        log_error("ts_timer_init < 0! \n");
        return -1;
    }

    ts_timer_set(tfeUpdateTimer, TIMER_INTERVAL, 0);

    if (!sysdb_init()) {
        log_error("sysdb_init error.");
        return  -1;
    }

    SYS_DB_CONFIG *sysDBconfig = sysdb_getOmsDBCfg();
    if (!otl_connectDB(sysDBconfig->username, sysDBconfig->password, sysDBconfig->url, TFE_UPDATE_WORKER_COUNT))
    {
        sysdb_close();
        log_error("otl_connectDB failed.");
        return -1;
    }

    if (!gl_init()) {
        log_error("gl_init() error.");
        sysdb_close();
        return -1;

    }

    ret = tfe_init();
    if (0 != ret)
    {
        log_error("tfe_init(%s) failed, ret[%d].", MY_TASK_NAME, ret);
        return -1;
    }

    static char footmark_name[128];
    sprintf(footmark_name, "%s/%s.ft", TFE_DATA_SUBDIR, MY_TASK_NAME);

    ret = tfe_t_restore_footmark(footmark_name, TFE_TASK_UPDATE);
    if (0 != ret)
    {
        log_error("tfe_t_restore_footmark( %s ) failed.", footmark_name);
        return -1;
    }

    char follow_str[128];
    sprintf(follow_str, "%d", TFE_TASK_UPDATE_DB);
    ret = tfe_t_init(TFE_TASK_UPDATE, TFE_TASK_SCAN, follow_str, true);
    if (0 != ret)
    {
        sysdb_close();
        gl_close();
        log_error("tfe_t_init(%s) failed, ret[%d].", MY_TASK_NAME, ret);
        return -1;
    }

    uint64 t_offset = tfe_get_offset(TFE_TASK_UPDATE);
    uint64 t_pre_offset = tfe_get_pre_offset(TFE_TASK_UPDATE);
    log_debug("------ %s prepare running.  [ %lld  %lld ] ---------",
        MY_TASK_NAME, t_offset, t_pre_offset);

    sysdb_setTaskStatus(SYS_TASK_TFE_UPDATER, SYS_TASK_STATUS_RUN);
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

            int ret_0 = tfe_updater_dispatcher(inm_buf + TFE_HEADER_LENGTH);
            if (ret_0 < 0)
            {
                DUMP_INMMSG(inm_buf + TFE_HEADER_LENGTH);
                log_error("tfe_updater_dispatcher() failed");
                break;
            }
        }

        if ((ret == TFE_TIMEOUT) || (record_cnt >= 5000) || (fbs_record_cnt >= 5000) || (total_rec_cnt > 20000) || (timer_fired == 1) || (force_deal_flag == 1))
        {
            if (record_cnt > 0 || fbs_record_cnt > 0)
            {
                int result = gidb_sync_all_spc_ticket();
                if (0 != result)
                {
                    log_error("gidb_sync_all_ticket() failed.");
                    break;
                }
                result = gidb_fbs_sync_spc_ticket();
                if (0 != result)
                {
                    log_error("gidb_fbs_sync_spc_ticket() failed.");
                    break;
                }
                result = gidb_sync_tidx_ticket();
                if (0 != result)
                {
                    log_error("gidb_sync_tidx_ticket() failed.");
                    break;
                }

                tfe_t_commit();
                tfe_t_keep_footmark(footmark_name, TFE_TASK_UPDATE);

                record_cnt = 0;
                total_rec_cnt = 0;
            }
            if (force_deal_flag == 1)
            {
                INM_MSG_HEADER *pInm = (INM_MSG_HEADER *)(inm_buf + TFE_HEADER_LENGTH);
                switch (pInm->type)
                {
                case INM_TYPE_ISSUE_STATE_CLOSED:
                {
                    INM_MSG_ISSUE_CLOSE *ptr = (INM_MSG_ISSUE_CLOSE *)pInm;
                    map_del(ptr->gameCode, ptr->serialNumber);

                    int ret = process_issue_closed((INM_MSG_HEADER *)pInm);
                    if (ret < 0)
                    {
                        log_error("process_issue_closed() failure");
                        return -1;
                    }
                    tfe_t_commit();
                    tfe_t_keep_footmark(footmark_name, TFE_TASK_UPDATE);
                    record_cnt = 0;
                    total_rec_cnt = 0;
                    break;
                }
                case INM_TYPE_O_FBS_MATCH_CLOSE:
                {
                    ret = process_fbs_match_close((INM_MSG_HEADER *)pInm);
                    if (ret < 0)
                    {
                        log_error("process_fbs_match_close() failure");
                        return -1;
                    }
                    tfe_t_commit();
                    tfe_t_keep_footmark(footmark_name, TFE_TASK_UPDATE);
                    fbs_matchClose = 0;
                    fbs_record_cnt = 0;
                    total_rec_cnt = 0;
                    break;
                }
                case INM_TYPE_AP_AUTODRAW_OVER:
                {
                    int ret = uproc_AP_pay_ticket_over((INM_MSG_HEADER *)pInm);
                    if (ret < 0)
                    {
                        log_error("uproc_AP_pay_ticket_over() failure");
                        return -1;
                    }
                    tfe_t_commit();
                    tfe_t_keep_footmark(footmark_name, TFE_TASK_UPDATE);
                    record_cnt = 0;
                    total_rec_cnt = 0;
                    break;
                }
                }
                force_deal_flag = 0;
            }
            if (total_rec_cnt > 0)
            {
                tfe_t_commit();
                if ((total_rec_cnt > 20000) || (timer_fired == 1))
                {
                    tfe_t_keep_footmark(footmark_name, TFE_TASK_UPDATE);
                    total_rec_cnt = 0;
                }
            }
        }

        if (timer_fired == 1)
        {
            timer_fired = 0;
            ts_timer_set(tfeUpdateTimer, TIMER_INTERVAL, 0);
        }

    }

    sysdb_setTaskStatus(SYS_TASK_TFE_UPDATER, SYS_TASK_STATUS_EXIT);

    gidb_tidx_close_handle();
    gidb_i_close_handle();
    gidb_t_close_handle();
    gidb_w_close_handle();

    gidb_fbs_im_close_all_handle();
    gidb_fbs_st_close_all_handle();
    gidb_fbs_wt_close_all_handle();


    gl_close();

    otl_disConnectDB();

    sysdb_close();

    log_info("%s exit\n", MY_TASK_NAME);

    return 0;
}



