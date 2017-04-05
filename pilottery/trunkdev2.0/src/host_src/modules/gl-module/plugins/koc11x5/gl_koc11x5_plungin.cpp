#include "global.h"
#include "gl_inf.h"

#include "gl_koc11x5_db.h"
#include "gl_koc11x5_rk.h"
#include "gl_koc11x5_match.h"
#include "gl_koc11x5_verify.h"
#include "gl_koc11x5_prize_calc.h"



extern "C" bool plugin_init(GAME_PLUGIN_INTERFACE *plugin_i)
{
    if (NULL == plugin_i) {
        return false;
    }

    plugin_i->mem_creat = gl_koc11x5_mem_creat;
    plugin_i->mem_destroy = gl_koc11x5_mem_destroy;
    plugin_i->mem_attach = gl_koc11x5_mem_attach;
    plugin_i->mem_detach = gl_koc11x5_mem_detach;
    plugin_i->get_mem_db = gl_koc11x5_get_mem_db;
	
	plugin_i->load_memdata = gl_koc11x5_load_memdata;

    plugin_i->get_issueTable = gl_koc11x5_getIssueTable;
    plugin_i->get_subtypeTable = gl_koc11x5_getSubtypeTable;
    plugin_i->get_divisionTable = gl_koc11x5_getDivisionTable;
    plugin_i->get_prizeTable = gl_koc11x5_getPrizeTable;

    plugin_i->get_poolParam = gl_koc11x5_getPoolParam;
    plugin_i->get_rkTable = gl_koc11x5_getRkTable;

    plugin_i->get_singleAmount = gl_koc11x5_getSingleAmount;

    plugin_i->get_currIssue = gl_koc11x5_get_currIssue;
    plugin_i->get_issueInfo = gl_koc11x5_get_issueInfo;
    plugin_i->get_issueInfo2 = gl_koc11x5_get_issueInfo2;
    plugin_i->get_issueCurrMaxSeq = gl_koc11x5_get_issueMaxSeq;

    plugin_i->sale_ticket_verify = gl_koc11x5_ticketVerify;
    plugin_i->create_drawNum = gl_koc11x5_createDrawnum;
    plugin_i->match_ticket = gl_koc11x5_ticketMatch;
    plugin_i->calc_prize = gl_koc11x5_calc_prize;

    plugin_i->format_ticket = gl_koc11x5_format_ticket;

    plugin_i->sale_rk_verify = gl_koc11x5_sale_rk_verify;
    plugin_i->sale_rk_commit = gl_koc11x5_sale_rk_commit;
    plugin_i->cancel_rk_rollback = gl_koc11x5_cancel_rk_rollback;
    plugin_i->cancel_rk_commit = gl_koc11x5_cancel_rk_commit;
    plugin_i->rk_reinitData = gl_koc11x5_rk_reinitData;


    plugin_i->get_rkReportData = gl_koc11x5_rk_getReportData;

    plugin_i->get_issueMaxCount = get_koc11x5_issueMaxCount;
    plugin_i->get_issueCount = get_koc11x5_issueCount;
    plugin_i->load_newIssueData = gl_koc11x5_load_newIssueData;
    plugin_i->load_oldIssueData = gl_koc11x5_load_oldIssueData;
    plugin_i->del_issue = gl_koc11x5_del_issue;
    plugin_i->clear_oneIssueData = gl_koc11x5_clear_oneIssueData;

    plugin_i->chkp_saveData = gl_koc11x5_chkp_saveData;
    plugin_i->chkp_restoreData = gl_koc11x5_chkp_restoreData;

    plugin_i->load_prizeParam = gl_koc11x5_loadPrizeTable;
    plugin_i->load_issue_RKdata = load_koc11x5_issue_rkdata;

    plugin_i->resolve_winConfigString = gl_koc11x5_resolve_winStr;
    plugin_i->get_winConfigString = gl_koc11x5_get_winStr;

    plugin_i->get_prizeTableStart = gl_koc11x5_getPrizeTableBegin;

    plugin_i->get_issueInfoByIndex = gl_koc11x5_get_issueInfoByIndex;
    plugin_i->get_rkIssueDataTable = gl_koc11x5_get_rkIssueDataTable;

    plugin_i->gen_fun = NULL;

    return true;
}







