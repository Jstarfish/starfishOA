#include "global.h"
#include "gl_inf.h"

#include "gl_fbs_db.h"


extern "C" bool plugin_init(GAME_PLUGIN_INTERFACE *plugin_i)
{
    if (NULL == plugin_i) {
        return false;
    }

    plugin_i->mem_creat = gl_fbs_mem_creat;
    plugin_i->mem_destroy = gl_fbs_mem_destroy;
    plugin_i->mem_attach = gl_fbs_mem_attach;
    plugin_i->mem_detach = gl_fbs_mem_detach;
    plugin_i->get_mem_db = gl_fbs_get_mem_db;
	plugin_i->load_memdata = gl_fbs_load_memdata;


	plugin_i->get_singleAmount = gl_fbs_getSingleAmount;

    plugin_i->fbs_update_configuration = gl_fbs_update_configuration;
    plugin_i->fbs_get_subtypeParam = gl_fbs_get_subtypeParam;
    plugin_i->fbs_get_result_string = FbsResultString;

    plugin_i->fbs_load_issue = gl_fbs_load_issue;
    plugin_i->fbs_get_issue = gl_fbs_get_issue;
	plugin_i->fbs_del_issue = gl_fbs_del_issue;
	plugin_i->fbs_get_match = gl_fbs_get_match;
	plugin_i->fbs_del_match = gl_fbs_del_match;
	plugin_i->fbs_calc_rt_odds = gl_fbs_calc_rt_odds;
    plugin_i->fbs_update_match_result = gl_fbs_update_match_result;

    //
    plugin_i->fbs_load_match = gl_fbs_load_match;
	//plugin_i->fbs_load_newMatch = gl_fbs_load_newMatch;
	plugin_i->fbs_get_issueTable = gl_fbs_get_issueTable;
	plugin_i->get_issueMaxCount = get_fbs_issueMaxCount;

    plugin_i->get_issueCurrMaxSeq = gl_fbs_get_issueMaxSeq;

    //
	plugin_i->fbs_format_ticket = gl_fbs_format_ticket;
	plugin_i->fbs_split_order = gl_fbs_split_order;
    //
    plugin_i->fbs_ticket_verify = gl_fbs_ticket_verify;
    //
    plugin_i->fbs_sale_rk_verify = gl_fbs_sale_rk_verify;
    plugin_i->fbs_sale_rk_commit = gl_fbs_sale_rk_commit;
    plugin_i->fbs_cancel_rk_rollback = gl_fbs_cancel_rk_rollback;
    plugin_i->fbs_cancel_rk_commit = gl_fbs_cancel_rk_commit;
    //
	plugin_i->chkp_saveData = gl_fbs_chkp_saveData;
	plugin_i->chkp_restoreData = gl_fbs_chkp_restoreData;

	//
	plugin_i->get_poolParam = gl_fbs_getPoolParam;
    plugin_i->get_subtypeTable = gl_fbs_getSubtypeTable;


    //
    plugin_i->get_currIssue = gl_fbs_get_currIssue;


    //计算各玩法各赛果的销售情况，上传DB，OMS监控使用
    plugin_i->fbs_sale_calc = gl_fbs_sale_calc;

    return true;
}







