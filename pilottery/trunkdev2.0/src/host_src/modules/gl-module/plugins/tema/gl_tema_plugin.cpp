/*
 * gl_tema_plugin.cpp
 *
 *  Created on: 2011-6-30
 *      Author: Administrator
 */

#include "global.h"
#include "gl_inf.h"

#include "gl_tema_db.h"
#include "gl_tema_rk.h"
#include "gl_tema_verify.h"
#include "gl_tema_match.h"
#include "gl_tema_prize_calc.h"


extern "C" bool plugin_init(GAME_PLUGIN_INTERFACE *plugin_i)
{
    if (NULL == plugin_i) {
        return false;
    }

    plugin_i->mem_creat = gl_tema_mem_creat;
    plugin_i->mem_destroy = gl_tema_mem_destroy;
    plugin_i->mem_attach = gl_tema_mem_attach;
    plugin_i->mem_detach = gl_tema_mem_detach;
    plugin_i->get_mem_db = gl_tema_get_mem_db;

	plugin_i->load_memdata = gl_tema_load_memdata;

    plugin_i->get_issueTable = gl_tema_getIssueTable;
    plugin_i->get_subtypeTable = gl_tema_getSubtypeTable;
    plugin_i->get_divisionTable = gl_tema_getDivisionTable;
    plugin_i->get_prizeTable = gl_tema_getPrizeTable;

    plugin_i->get_poolParam = gl_tema_getPoolParam;
    plugin_i->get_rkTable = gl_tema_getRkTable;

    plugin_i->get_singleAmount = gl_tema_getSingleAmount;

    plugin_i->get_currIssue = gl_tema_get_currIssue;
    plugin_i->get_issueInfo = gl_tema_get_issueInfo;
    plugin_i->get_issueInfo2 = gl_tema_get_issueInfo2;
    plugin_i->get_issueCurrMaxSeq = gl_tema_get_issueMaxSeq;

    plugin_i->sale_ticket_verify = gl_tema_ticketVerify;
    plugin_i->create_drawNum = gl_tema_createDrawnum;
    plugin_i->match_ticket = gl_tema_ticketMatch;
    plugin_i->calc_prize = gl_tema_calc_prize;

    plugin_i->format_ticket = gl_tema_format_ticket;

    plugin_i->sale_rk_verify = gl_tema_sale_rk_verify;
    plugin_i->sale_rk_commit = gl_tema_sale_rk_commit;
    plugin_i->cancel_rk_rollback = gl_tema_cancel_rk_rollback;
    plugin_i->cancel_rk_commit = gl_tema_cancel_rk_commit;
    plugin_i->rk_reinitData = gl_tema_rk_reinitData;

    plugin_i->get_rkReportData = gl_tema_rk_getReportData;

    plugin_i->get_issueMaxCount = get_tema_issueMaxCount;
    plugin_i->get_issueCount = get_tema_issueCount;
    plugin_i->load_newIssueData = gl_tema_load_newIssueData;
    plugin_i->load_oldIssueData = gl_tema_load_oldIssueData;
    plugin_i->del_issue = gl_tema_del_issue;
    plugin_i->clear_oneIssueData = gl_tema_clear_oneIssueData;

    plugin_i->chkp_saveData = gl_tema_chkp_saveData;
    plugin_i->chkp_restoreData = gl_tema_chkp_restoreData;

    plugin_i->load_prizeParam = gl_tema_loadPrizeTable;
    plugin_i->load_issue_RKdata = load_tema_issue_rkdata;

    plugin_i->resolve_winConfigString = NULL;
    plugin_i->get_winConfigString = NULL;

    plugin_i->get_prizeTableStart = gl_tema_getPrizeTableBegin;

    plugin_i->get_issueInfoByIndex = gl_tema_get_issueInfoByIndex;
    plugin_i->get_rkIssueDataTable = gl_tema_get_rkIssueDataTable;

    plugin_i->gen_fun = NULL;

    return true;
}

