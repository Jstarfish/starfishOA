#include "global.h"
#include "gl_inf.h"

#include "gl_koctty_db.h"
#include "gl_koctty_rk.h"
#include "gl_koctty_match.h"
#include "gl_koctty_verify.h"
#include "gl_koctty_prize_calc.h"



extern "C" bool plugin_init(GAME_PLUGIN_INTERFACE *plugin_i)
{
    if (NULL == plugin_i) {
        return false;
    }

    plugin_i->mem_creat = gl_koctty_mem_creat;
    plugin_i->mem_destroy = gl_koctty_mem_destroy;
    plugin_i->mem_attach = gl_koctty_mem_attach;
    plugin_i->mem_detach = gl_koctty_mem_detach;
    plugin_i->get_mem_db = gl_koctty_get_mem_db;
	
	plugin_i->load_memdata = gl_koctty_load_memdata;

    plugin_i->get_issueTable = gl_koctty_getIssueTable;
    plugin_i->get_subtypeTable = gl_koctty_getSubtypeTable;
    plugin_i->get_divisionTable = gl_koctty_getDivisionTable;
    plugin_i->get_prizeTable = gl_koctty_getPrizeTable;

    plugin_i->get_poolParam = gl_koctty_getPoolParam;
    plugin_i->get_rkTable = gl_koctty_getRkTable;

    plugin_i->get_singleAmount = gl_koctty_getSingleAmount;

    plugin_i->get_currIssue = gl_koctty_get_currIssue;
    plugin_i->get_issueInfo = gl_koctty_get_issueInfo;
    plugin_i->get_issueInfo2 = gl_koctty_get_issueInfo2;
    plugin_i->get_issueCurrMaxSeq = gl_koctty_get_issueMaxSeq;

    plugin_i->sale_ticket_verify = gl_koctty_ticketVerify;
    plugin_i->create_drawNum = gl_koctty_createDrawnum;
    plugin_i->match_ticket = gl_koctty_ticketMatch;
    plugin_i->calc_prize = gl_koctty_calc_prize;

    plugin_i->format_ticket = gl_koctty_format_ticket;

    plugin_i->sale_rk_verify = gl_koctty_sale_rk_verify;
    plugin_i->sale_rk_commit = gl_koctty_sale_rk_commit;
    plugin_i->cancel_rk_rollback = gl_koctty_cancel_rk_rollback;
    plugin_i->cancel_rk_commit = gl_koctty_cancel_rk_commit;
    plugin_i->rk_reinitData = gl_koctty_rk_reinitData;


    plugin_i->get_rkReportData = gl_koctty_rk_getReportData;

    plugin_i->get_issueMaxCount = get_koctty_issueMaxCount;
    plugin_i->get_issueCount = get_koctty_issueCount;
    plugin_i->load_newIssueData = gl_koctty_load_newIssueData;
    plugin_i->load_oldIssueData = gl_koctty_load_oldIssueData;
    plugin_i->del_issue = gl_koctty_del_issue;
    plugin_i->clear_oneIssueData = gl_koctty_clear_oneIssueData;

    plugin_i->chkp_saveData = gl_koctty_chkp_saveData;
    plugin_i->chkp_restoreData = gl_koctty_chkp_restoreData;

    plugin_i->load_prizeParam = gl_koctty_loadPrizeTable;
    plugin_i->load_issue_RKdata = load_koctty_issue_rkdata;

    plugin_i->resolve_winConfigString = gl_koctty_resolve_winStr;
    plugin_i->get_winConfigString = gl_koctty_get_winStr;

    plugin_i->get_prizeTableStart = gl_koctty_getPrizeTableBegin;

    plugin_i->get_issueInfoByIndex = gl_koctty_get_issueInfoByIndex;
    plugin_i->get_rkIssueDataTable = gl_koctty_get_rkIssueDataTable;

    plugin_i->gen_fun = gl_koctty_gen_fun;

    return true;
}







