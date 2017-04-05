#include "global.h"
#include "gl_inf.h"

#include "gl_ssc_db.h"
#include "gl_ssc_rk.h"
#include "gl_ssc_match.h"
#include "gl_ssc_verify.h"
#include "gl_ssc_prize_calc.h"



extern "C" bool plugin_init(GAME_PLUGIN_INTERFACE *plugin_i)
{
    if (NULL == plugin_i) {
        return false;
    }

    plugin_i->mem_creat = gl_ssc_mem_creat;
    plugin_i->mem_destroy = gl_ssc_mem_destroy;
    plugin_i->mem_attach = gl_ssc_mem_attach;
    plugin_i->mem_detach = gl_ssc_mem_detach;
    plugin_i->get_mem_db = gl_ssc_get_mem_db;
	
	plugin_i->load_memdata = gl_ssc_load_memdata;

    plugin_i->get_issueTable = gl_ssc_getIssueTable;
    plugin_i->get_subtypeTable = gl_ssc_getSubtypeTable;
    plugin_i->get_divisionTable = gl_ssc_getDivisionTable;
    plugin_i->get_prizeTable = gl_ssc_getPrizeTable;

    plugin_i->get_poolParam = gl_ssc_getPoolParam;
    plugin_i->get_rkTable = gl_ssc_getRkTable;

    plugin_i->get_singleAmount = gl_ssc_getSingleAmount;

    plugin_i->get_currIssue = gl_ssc_get_currIssue;
    plugin_i->get_issueInfo = gl_ssc_get_issueInfo;
    plugin_i->get_issueInfo2 = gl_ssc_get_issueInfo2;
    plugin_i->get_issueCurrMaxSeq = gl_ssc_get_issueMaxSeq;

    plugin_i->sale_ticket_verify = gl_ssc_ticketVerify;
    plugin_i->create_drawNum = gl_ssc_createDrawnum;
    plugin_i->match_ticket = gl_ssc_ticketMatch;
    plugin_i->calc_prize = gl_ssc_calc_prize;

    plugin_i->format_ticket = gl_ssc_format_ticket;

    plugin_i->sale_rk_verify = gl_ssc_sale_rk_verify;
    plugin_i->sale_rk_commit = gl_ssc_sale_rk_commit;
    plugin_i->cancel_rk_rollback = gl_ssc_cancel_rk_rollback;
    plugin_i->cancel_rk_commit = gl_ssc_cancel_rk_commit;
    plugin_i->rk_reinitData = gl_ssc_rk_reinitData;

    plugin_i->get_rkReportData = gl_ssc_rk_getReportData;

    plugin_i->get_issueMaxCount = get_ssc_issueMaxCount;
    plugin_i->get_issueCount = get_ssc_issueCount;
    plugin_i->load_newIssueData = gl_ssc_load_newIssueData;
    plugin_i->load_oldIssueData = gl_ssc_load_oldIssueData;
    plugin_i->del_issue = gl_ssc_del_issue;
    plugin_i->clear_oneIssueData = gl_ssc_clear_oneIssueData;

    plugin_i->chkp_saveData = gl_ssc_chkp_saveData;
    plugin_i->chkp_restoreData = gl_ssc_chkp_restoreData;

    plugin_i->load_prizeParam = gl_ssc_loadPrizeTable;
    plugin_i->load_issue_RKdata = load_ssc_issue_rkdata;

    plugin_i->get_prizeTableStart = gl_ssc_getPrizeTableBegin;

    plugin_i->get_issueInfoByIndex = gl_ssc_get_issueInfoByIndex;
    plugin_i->get_rkIssueDataTable = gl_ssc_get_rkIssueDataTable;
    return true;
}







