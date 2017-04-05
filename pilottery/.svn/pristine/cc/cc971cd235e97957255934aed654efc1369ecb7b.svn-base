#include "global.h"
#include "gl_inf.h"

#include "gl_koc7lx_db.h"
#include "gl_koc7lx_verify.h"
#include "gl_koc7lx_match.h"
#include "gl_koc7lx_prize_calc.h"


extern "C" bool plugin_init(GAME_PLUGIN_INTERFACE *plugin_i)
{
    if (NULL == plugin_i)
    {
        return false;
    }

    plugin_i->mem_creat = gl_koc7lx_mem_creat;
    plugin_i->mem_destroy = gl_koc7lx_mem_destroy;
    plugin_i->mem_attach = gl_koc7lx_mem_attach;
    plugin_i->mem_detach = gl_koc7lx_mem_detach;
    plugin_i->get_mem_db = gl_koc7lx_get_mem_db;

    plugin_i->load_memdata = gl_koc7lx_load_memdata;

    plugin_i->get_issueTable = gl_koc7lx_getIssueTable;
    plugin_i->get_subtypeTable = gl_koc7lx_getSubtypeTable;
    plugin_i->get_divisionTable = gl_koc7lx_getDivisionTable;
    plugin_i->get_prizeTable = gl_koc7lx_getPrizeTable;

    plugin_i->get_poolParam = gl_koc7lx_getPoolParam;
    plugin_i->get_rkTable = NULL;

    plugin_i->get_singleAmount = gl_koc7lx_getSingleAmount;

    plugin_i->get_currIssue = gl_koc7lx_get_currIssue;
    plugin_i->get_issueInfo = gl_koc7lx_get_issueInfo;
    plugin_i->get_issueInfo2 = gl_koc7lx_get_issueInfo2;
    plugin_i->get_issueCurrMaxSeq = gl_koc7lx_get_issueMaxSeq;

    plugin_i->sale_ticket_verify = gl_koc7lx_ticketVerify;
    plugin_i->create_drawNum = gl_koc7lx_createDrawnum;
    plugin_i->match_ticket = gl_koc7lx_ticketMatch;
    plugin_i->calc_prize = gl_koc7lx_calc_prize;

    plugin_i->format_ticket = gl_koc7lx_format_ticket;

    plugin_i->sale_rk_verify = NULL;
    plugin_i->sale_rk_commit = NULL;
    plugin_i->cancel_rk_rollback = NULL;
    plugin_i->cancel_rk_commit = NULL;
    plugin_i->rk_reinitData = NULL;
    plugin_i->get_rkReportData = NULL;

    plugin_i->get_issueMaxCount = get_koc7lx_issueMaxCount;
    plugin_i->get_issueCount = get_koc7lx_issueCount;
    plugin_i->load_newIssueData = gl_koc7lx_load_newIssueData;
    plugin_i->load_oldIssueData = gl_koc7lx_load_oldIssueData;
    plugin_i->del_issue = gl_koc7lx_del_issue;
    plugin_i->clear_oneIssueData = gl_koc7lx_clear_oneIssueData;

    plugin_i->chkp_saveData = gl_koc7lx_chkp_saveData;
    plugin_i->chkp_restoreData = gl_koc7lx_chkp_restoreData;

    plugin_i->load_prizeParam = gl_koc7lx_loadPrizeTable;

    plugin_i->resolve_winConfigString = gl_koc7lx_resolve_winStr;
    plugin_i->get_winConfigString = gl_koc7lx_get_winStr;

    plugin_i->gen_fun = NULL;

    return true;
}





