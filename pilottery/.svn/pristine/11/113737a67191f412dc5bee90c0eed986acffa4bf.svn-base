#include "global.h"
#include "gl_inf.h"

#include "gl_kock3_db.h"
#include "gl_kock3_rk.h"
#include "gl_kock3_match.h"
#include "gl_kock3_verify.h"
#include "gl_kock3_prize_calc.h"



extern "C" bool plugin_init(GAME_PLUGIN_INTERFACE *plugin_i)
{
    if (NULL == plugin_i) {
        return false;
    }

    plugin_i->mem_creat = gl_kock3_mem_creat;
    plugin_i->mem_destroy = gl_kock3_mem_destroy;
    plugin_i->mem_attach = gl_kock3_mem_attach;
    plugin_i->mem_detach = gl_kock3_mem_detach;
    plugin_i->get_mem_db = gl_kock3_get_mem_db;
	
	plugin_i->load_memdata = gl_kock3_load_memdata;

    plugin_i->get_issueTable = gl_kock3_getIssueTable;
    plugin_i->get_subtypeTable = gl_kock3_getSubtypeTable;
    plugin_i->get_divisionTable = gl_kock3_getDivisionTable;
    plugin_i->get_prizeTable = gl_kock3_getPrizeTable;

    plugin_i->get_poolParam = gl_kock3_getPoolParam;
    plugin_i->get_rkTable = gl_kock3_getRkTable;

    plugin_i->get_singleAmount = gl_kock3_getSingleAmount;

    plugin_i->get_currIssue = gl_kock3_get_currIssue;
    plugin_i->get_issueInfo = gl_kock3_get_issueInfo;
    plugin_i->get_issueInfo2 = gl_kock3_get_issueInfo2;
    plugin_i->get_issueCurrMaxSeq = gl_kock3_get_issueMaxSeq;

    plugin_i->sale_ticket_verify = gl_kock3_ticketVerify;
    plugin_i->create_drawNum = gl_kock3_createDrawnum;
    plugin_i->match_ticket = gl_kock3_ticketMatch;
    plugin_i->calc_prize = gl_kock3_calc_prize;

    plugin_i->format_ticket = gl_kock3_format_ticket;

    plugin_i->sale_rk_verify = gl_kock3_sale_rk_verify;
    plugin_i->sale_rk_commit = gl_kock3_sale_rk_commit;
    plugin_i->cancel_rk_rollback = gl_kock3_cancel_rk_rollback;
    plugin_i->cancel_rk_commit = gl_kock3_cancel_rk_commit;
    plugin_i->rk_reinitData = gl_kock3_rk_reinitData;


    plugin_i->get_rkReportData = gl_kock3_rk_getReportData;

    plugin_i->get_issueMaxCount = get_kock3_issueMaxCount;
    plugin_i->get_issueCount = get_kock3_issueCount;
    plugin_i->load_newIssueData = gl_kock3_load_newIssueData;
    plugin_i->load_oldIssueData = gl_kock3_load_oldIssueData;
    plugin_i->del_issue = gl_kock3_del_issue;
    plugin_i->clear_oneIssueData = gl_kock3_clear_oneIssueData;

    plugin_i->chkp_saveData = gl_kock3_chkp_saveData;
    plugin_i->chkp_restoreData = gl_kock3_chkp_restoreData;

    plugin_i->load_prizeParam = gl_kock3_loadPrizeTable;
    plugin_i->load_issue_RKdata = load_kock3_issue_rkdata;

    plugin_i->resolve_winConfigString = NULL;
    plugin_i->get_winConfigString = NULL;

    plugin_i->get_prizeTableStart = gl_kock3_getPrizeTableBegin;

    plugin_i->get_issueInfoByIndex = gl_kock3_get_issueInfoByIndex;
    plugin_i->get_rkIssueDataTable = gl_kock3_get_rkIssueDataTable;

    plugin_i->gen_fun = NULL;

    return true;
}







