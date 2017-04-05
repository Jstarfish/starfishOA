#include "global.h"
#include "ncpc_inf.h"
#include "tms_inf.h"
#include "gl_inf.h"
#include "ncpc_http_parse.h"
#include "ncpc_http_kvdb.h"
#include "ncpc_net.h"
#include "ncpc_message.h"

extern GAME_PLUGIN_INTERFACE *game_plugins_handle;

int ncpc_process_Recv_ncp_message(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf)
{
    GLTP_MSG_N_HEADER *g_header = (GLTP_MSG_N_HEADER *)gltp_buf;
    INM_MSG_N_HEADER *inm_header = (INM_MSG_N_HEADER *)inm_buf;
    if (g_header->length < (GLTP_MSG_N_HEADER_LEN+CRC_SIZE))
        return -1;

    NCPC_MSG_DISPATCH_CELL *msg_cell = ncpc_get_dispatch(g_header->type, g_header->func);
    if (msg_cell == NULL)
    {
        log_error("ncpc_get_dispatch() failed. unknow message type[%d] func[%d]",
            g_header->type, g_header->func);
        return -1;
    }
    inm_header->inm_header.when = get_now();
    inm_header->inm_header.status = SYS_RESULT_SUCCESS;
    inm_header->inm_header.gltp_type = g_header->type;
    inm_header->inm_header.gltp_func = g_header->func;

    int msg_len = msg_cell->R_process(ns, gltp_buf, inm_buf);
    if (msg_len <= 0) {
        log_warn("R_process() failed. type[%d] func[%d]", g_header->type, g_header->func);
        return -1;
    } else if ((uint32)msg_len==0x0FFFFFFF) {
        return 0;
    }
    inm_header->inm_header.length = msg_len;

    //处理失败直接返回
    if (inm_header->inm_header.status != SYS_RESULT_SUCCESS) {
        ns->send_msg_to_bq(q_ncpc_send, inm_buf, inm_header->inm_header.length);
        return 0;
    }

    ns->send_msg_to_bq(msg_cell->which_queue, inm_buf, inm_header->inm_header.length);
    return 0;	
}

int ncpc_process_Send_ncp_message(NCPC_SERVER *ns, ncpc_client *c, char *inm_buf)
{
    INM_MSG_N_HEADER *inm_header = (INM_MSG_N_HEADER *)inm_buf;
    char gltp_buf[MAX_BUFFER] = {0};
    GLTP_MSG_N_HEADER *g_header = (GLTP_MSG_N_HEADER *)gltp_buf;

    g_header->type = inm_header->inm_header.gltp_type;
    g_header->func = inm_header->inm_header.gltp_func+1;
    g_header->when = get_now();

    NCPC_MSG_DISPATCH_CELL *msg_cell = NULL;
    //错误处理
    if( SYS_RESULT_SUCCESS != inm_header->inm_header.status) {
        //构造错误响应消息
        //ncp应该不需要错误响应消息
        //暂时不实现
        log_error("*********not exist************");
        return 0;
    } else {
        msg_cell = ncpc_get_dispatch(inm_header->inm_header.gltp_type, inm_header->inm_header.gltp_func);
        if (msg_cell == NULL) {
            log_error("ncpc_get_dispatch() failed. unknown message type[%d] func[%d]",
                inm_header->inm_header.gltp_type, inm_header->inm_header.gltp_func);
            return -1;
        }
        int msg_len = msg_cell->S_process(ns, inm_buf, gltp_buf);
        if (msg_len <= 0) {
            log_warn("S_process() failed. inm type[%d] func[%d]",
                inm_header->inm_header.gltp_type, inm_header->inm_header.gltp_func);
            return -1;
        }
        g_header->length = msg_len;
    }

    //send to net
    c->send_message(gltp_buf, g_header->length);
    return 0;
}



// -----------------------------------------------------------------------------
// heartbeat message
// -----------------------------------------------------------------------------
int R_NCP_hb_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf)
{
    ts_notused_args;
    GLTP_MSG_N_HB *g_msg = (GLTP_MSG_N_HB *)gltp_buf;
    INM_MSG_N_HEADER *inm_hb = (INM_MSG_N_HEADER *)inm_buf;
    inm_hb->inm_header.type = INM_TYPE_N_HB;

    ncpc_updConnectedNumber(inm_hb->inm_header.socket_idx, g_msg->termcnt);
    return sizeof(INM_MSG_N_HEADER);
}

int S_NCP_hb_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf)
{
    ts_notused_args;
    GLTP_MSG_N_HB *g_msg = (GLTP_MSG_N_HB *)gltp_buf;
    g_msg->header.func = GLTP_N_HB;
    return sizeof(GLTP_MSG_N_HB);
}

// -----------------------------------------------------------------------------
// echo message
// -----------------------------------------------------------------------------
int R_NCP_echo_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf)
{
    ts_notused_args;
    GLTP_MSG_N_ECHO_REQ *gltp_echo_msg = (GLTP_MSG_N_ECHO_REQ *)gltp_buf;
    INM_MSG_N_ECHO *inm_echo = (INM_MSG_N_ECHO *)inm_buf;
    inm_echo->header.inm_header.type = INM_TYPE_N_ECHO;

    const char echo_str[] = "Welcome, I'm TaiShan System. ";
    inm_echo->echo_len = sprintf(inm_echo->echo_str, "%s <%s>", echo_str, gltp_echo_msg->echo_str) + 1;
    return (sizeof(INM_MSG_N_ECHO) + inm_echo->echo_len);
}

int S_NCP_echo_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf)
{
    ts_notused_args;
    INM_MSG_N_ECHO *inm_echo = (INM_MSG_N_ECHO *)inm_buf;
    GLTP_MSG_N_ECHO_RSP *gltp_echo_msg = (GLTP_MSG_N_ECHO_RSP *)gltp_buf;

    gltp_echo_msg->echo_len = inm_echo->echo_len;
    memcpy(gltp_echo_msg->echo_str, inm_echo->echo_str, gltp_echo_msg->echo_len);
    return ( sizeof(GLTP_MSG_N_ECHO_RSP) + gltp_echo_msg->echo_len + CRC_SIZE);
}


// -----------------------------------------------------------------------------
// terminal connect / disconnect message
// -----------------------------------------------------------------------------
int R_NCP_termconn_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf)
{
    ts_notused_args;
    GLTP_MSG_N_TERMINAL_CONN *g_msg = (GLTP_MSG_N_TERMINAL_CONN *)gltp_buf;

    TMS_TERMINAL_RECORD *pTerm = tms_mgr()->verify_token(g_msg->token);
    if (pTerm == NULL) {
        log_warn("terminal connection report failure. token[%llu]", g_msg->token);
        return 0x0FFFFFFF;
    }
    ncpc_updConnectedNumber(pTerm->ncpIdx, g_msg->termcnt);

    //log_info("R_NCP_termconn_process -> cid[%d] conn[%d] timestamp[%d] ncpIdx[%d]",
    //    pTerm->index, g_msg->conn, g_msg->timestamp, pTerm->ncpIdx);

    return 0x0FFFFFFF; //此返回值，没有后续的处理
}


// -----------------------------------------------------------------------------
// terminal network delay message
// -----------------------------------------------------------------------------
int R_NCP_network_delay_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf)
{
    ts_notused_args;
    GLTP_MSG_N_TERM_NETWORK_DELAY *g_msg = (GLTP_MSG_N_TERM_NETWORK_DELAY *)gltp_buf;

    TMS_TERMINAL_RECORD *pTerm = tms_mgr()->verify_token(g_msg->token);
    if (pTerm == NULL) {
        //log_warn("R_NCP_network_delay_process: cannot get terminal token[%llu]", g_msg->token);
        return 0x0FFFFFFF;
    }
    time_type when = get_now();
    if (pTerm->timeStamp == 0)
    {
        pTerm->timeStamp = g_msg->timestamp;
        pTerm->beginOnline = when;
        pTerm->delayMilliSeconds = g_msg->delayMilliSeconds;
        pTerm->spTimeStamp = 0;
    }
    else
    {
        uint32 duration = g_msg->timestamp - pTerm->timeStamp;
        pTerm->timeStamp = g_msg->timestamp;
        pTerm->delayMilliSeconds = g_msg->delayMilliSeconds;
        if (duration > 60)
        {
            pTerm->beginOnline = when;
        }
        else
        {
            if ((when - pTerm->spTimeStamp) > (5 * 60))
            {
                pTerm->spTimeStamp = when;
                otldb_spcall_term_online((char *)pTerm);
                // otl SP
            }
        }
    }

    //log_info("R_NCP_network_delay_process: cid[%u] timestamp[%u] delay[%u]",
    //    pTerm->index, g_msg->timestamp, g_msg->delayMilliSeconds);

    return 0x0FFFFFFF; //此返回值，没有后续的处理
}


//游戏当前期次信息查询
int R_NCP_gameissue_process(NCPC_SERVER *ns, char *gltp_buf, char *inm_buf)
{
    ts_notused_args;

    INM_MSG_N_GAME_ISSUE *inm_msg = (INM_MSG_N_GAME_ISSUE *)inm_buf;

    inm_msg->header.inm_header.type = INM_TYPE_T_GAME_ISSUE;
    inm_msg->gameCount = 0;
    for (uint8 game_code = 0; game_code < MAX_GAME_NUMBER; game_code++)
    {
        GAME_DATA* game_data = gl_getGameData(game_code);
        if ( (game_data->used )
          && (game_data->gameEntry.gameType != GAME_TYPE_FINAL_ODDS)
          && (game_data->gameEntry.gameType != GAME_TYPE_FIXED_ODDS) )
        {
            inm_msg->issue[inm_msg->gameCount].gameCode = game_code;

            ISSUE_INFO *issue_ptr = game_plugins_handle[game_code].get_currIssue();
            if (NULL == issue_ptr)
            {
                inm_msg->issue[inm_msg->gameCount].issueNumber = 0;
            }
            else
            {
                inm_msg->issue[inm_msg->gameCount].issueNumber = issue_ptr->issueNumber;
                inm_msg->issue[inm_msg->gameCount].issueStartTime = issue_ptr->startTime;
                inm_msg->issue[inm_msg->gameCount].issueLength = issue_ptr->closeTime - issue_ptr->startTime;
                TRANSCTRL_PARAM * trans = gl_getTransctrlParam(game_code);
                inm_msg->issue[inm_msg->gameCount].countDownSeconds = trans->countDownTimes;
            }

            inm_msg->gameCount++;
        }
    }

    return sizeof(INM_MSG_N_GAME_ISSUE)+ inm_msg->gameCount * sizeof(HOST_GAME_ISSUE);
}

int S_NCP_gameissue_process(NCPC_SERVER *ns, char *inm_buf, char *gltp_buf)
{
    ts_notused_args;
    GLTP_MSG_N_GAME_ISSUE_RSP *g_msg = (GLTP_MSG_N_GAME_ISSUE_RSP *)gltp_buf;
    INM_MSG_N_GAME_ISSUE *inm_msg = (INM_MSG_N_GAME_ISSUE *)inm_buf;

    g_msg->gameCount = inm_msg->gameCount;

    for(uint8 idx = 0; idx < inm_msg->gameCount; idx++)
    {
    	g_msg->issueInfo[idx].gameCode = inm_msg->issue[idx].gameCode;
    	g_msg->issueInfo[idx].issueNumber = inm_msg->issue[idx].issueNumber;
    	g_msg->issueInfo[idx].issueStartTime = inm_msg->issue[idx].issueStartTime;
    	g_msg->issueInfo[idx].issueLength = inm_msg->issue[idx].issueLength;
    	g_msg->issueInfo[idx].countDownSeconds = inm_msg->issue[idx].countDownSeconds;

    }

    return sizeof(GLTP_MSG_N_GAME_ISSUE_RSP) + g_msg->gameCount * sizeof(HOST_GAME_ISSUE) + CRC_SIZE;
}


