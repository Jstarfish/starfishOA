#include "global.h"
#include "gl_inf.h"

#include "gfp_mod.h"
#include "gidb_mod.h"
#include "gidb_fbs_mod.h"
#include "otl_inf.h"


#define FBS_VFYC_LEN   16

#pragma pack(1)

typedef struct _FBS_TICKET_VFYC
{
    uint16  length;
    char    rspfn_ticket[TSN_LENGTH];
    uint8   isCancel;
    FBS_TICKET ticket;
} FBS_TICKET_VFYC;

typedef struct _FBS_WIN_TICKET_VFYC
{
    uint16  length;
    char    rspfn_ticket[TSN_LENGTH];
    uint8   gameCode;
    uint64  issueNumber;
    money_t ticketAmount;
    uint8   isTrain;

    uint8   isBigWinning;
    money_t winningAmountWithTax;
    money_t winningAmount;
    money_t taxAmount;
    int32   winningCount;

    uint8   paid_status;
} FBS_WIN_TICKET_VFYC;

#pragma pack()

enum FBS_VFYC_TYPE
{
    SALE_TICKET_VFYC_FBS = 1,
    WIN_TICKET_VFYC_FBS,
    PAY_TICKET_VFYC_FBS,
    CANCEL_TICKET_VFYC_FBS
};

#define KEY_MASK 0xABCD
#define KEY_VERSION_LEN 2

int calculate_vfyc_fbs(int32 type, unsigned char *key, uint32 key_len, void *data, unsigned char *vfyc, uint32 *vfyc_len)
{
    static char buffer[1024*4];
    memset(buffer, 0 ,sizeof(buffer));
    switch(type)
    {
        case SALE_TICKET_VFYC_FBS:
        {
        	GIDB_FBS_ST_REC *sale_ptr = (GIDB_FBS_ST_REC *)data;
        	FBS_TICKET_VFYC *sale_vfyc_ptr = (FBS_TICKET_VFYC *)buffer;
            sale_vfyc_ptr->length = sizeof(FBS_TICKET_VFYC) + sale_ptr->ticket.length - sizeof(sale_ptr->ticket);
            strncpy(sale_vfyc_ptr->rspfn_ticket, sale_ptr->rspfn_ticket, TSN_LENGTH);
            sale_vfyc_ptr->isCancel = sale_ptr->isCancel;
            memcpy(&sale_vfyc_ptr->ticket, &sale_ptr->ticket, sale_ptr->ticket.length);
            hmac_md5(key, key_len, (const unsigned char *)buffer, sale_vfyc_ptr->length, vfyc, FBS_VFYC_LEN);
            *vfyc_len = FBS_VFYC_LEN;

            /*
            log_debug("SALE_TICKET_VFYC_FBS --- %s --->", sale_vfyc_ptr->rspfn_ticket);
            gidb_dumpHexBuffer((char*)sale_vfyc_ptr, sizeof(SALE_CANCEL_TICKET_VFYC)+ sale_ptr->ticket.betStringLen + sale_ptr->ticket.betlineLen);
            log_debug("Vfyc [%d] --->", *vfyc_len);
            gidb_dumpHexBuffer((char*)vfyc, *vfyc_len);
            log_debug("Vfyc key[%d] --->", key_len);
            gidb_dumpHexBuffer((char*)key, key_len);
            */
            break;
        }
        case WIN_TICKET_VFYC_FBS:
        {
        	GIDB_FBS_WT_REC *win_ptr = (GIDB_FBS_WT_REC *)data;
        	FBS_WIN_TICKET_VFYC *win_vfyc_ptr = (FBS_WIN_TICKET_VFYC *)buffer;
            win_vfyc_ptr->length = sizeof(FBS_WIN_TICKET_VFYC);
            strncpy(win_vfyc_ptr->rspfn_ticket, win_ptr->rspfn_ticket, TSN_LENGTH);
            win_vfyc_ptr->gameCode = win_ptr->game_code;
            win_vfyc_ptr->issueNumber = win_ptr->issue_number;
            win_vfyc_ptr->ticketAmount = win_ptr->total_amount;
            win_vfyc_ptr->isTrain = win_ptr->is_train;
            win_vfyc_ptr->isBigWinning = win_ptr->isBigWinning;
            win_vfyc_ptr->winningAmountWithTax = win_ptr->winningAmountWithTax;
            win_vfyc_ptr->winningAmount = win_ptr->winningAmount;
            win_vfyc_ptr->taxAmount = win_ptr->taxAmount;
            win_vfyc_ptr->winningCount = win_ptr->winningCount;
            win_vfyc_ptr->paid_status = win_ptr->paid_status;
            hmac_md5(key, key_len, (const unsigned char *)buffer, win_vfyc_ptr->length, vfyc, FBS_VFYC_LEN);
            *vfyc_len = FBS_VFYC_LEN;

            /*
            log_debug("WIN_TICKET_VFYC_T --- %s --->", win_vfyc_ptr->rspfn_ticket);
            gidb_dumpHexBuffer((char*)win_vfyc_ptr, sizeof(WIN_PAY_TICKET_VFYC));
            log_debug("Vfyc [%d] --->", *vfyc_len);
            gidb_dumpHexBuffer((char*)vfyc, *vfyc_len);
            log_debug("Vfyc key[%d] --->", key_len);
            gidb_dumpHexBuffer((char*)key, key_len);
            */
            break;
        }
        case PAY_TICKET_VFYC_FBS:
        {
        	GIDB_FBS_PT_STRUCT *pay_ptr = (GIDB_FBS_PT_STRUCT *)data;
        	FBS_WIN_TICKET_VFYC *win_vfyc_ptr = (FBS_WIN_TICKET_VFYC *)buffer;
            win_vfyc_ptr->length = sizeof(FBS_WIN_TICKET_VFYC);
            strncpy(win_vfyc_ptr->rspfn_ticket, pay_ptr->rspfn_ticket, TSN_LENGTH);
            win_vfyc_ptr->gameCode = pay_ptr->gameCode;
            win_vfyc_ptr->issueNumber = pay_ptr->issueNumber;
            win_vfyc_ptr->isTrain = pay_ptr->isTrain;
            win_vfyc_ptr->ticketAmount = pay_ptr->ticketAmount;
            win_vfyc_ptr->isBigWinning = pay_ptr->isBigWinning;
            win_vfyc_ptr->winningAmountWithTax = pay_ptr->winningAmountWithTax;
            win_vfyc_ptr->winningAmount = pay_ptr->winningAmount;
            win_vfyc_ptr->taxAmount = pay_ptr->taxAmount;
            win_vfyc_ptr->winningCount = pay_ptr->winningCount;
            win_vfyc_ptr->paid_status = pay_ptr->paid_status;
            hmac_md5(key, key_len, (const unsigned char *)buffer, win_vfyc_ptr->length, vfyc, FBS_VFYC_LEN);
            *vfyc_len = FBS_VFYC_LEN;

            /*
            log_debug("PAY_TICKET_VFYC_T --- %s --->", win_vfyc_ptr->rspfn_ticket);
            gidb_dumpHexBuffer((char*)win_vfyc_ptr, sizeof(WIN_PAY_TICKET_VFYC));
            log_debug("Vfyc [%d] --->", *vfyc_len);
            gidb_dumpHexBuffer((char*)vfyc, *vfyc_len);
            log_debug("Vfyc key[%d] --->", key_len);
            gidb_dumpHexBuffer((char*)key, key_len);
            */
            break;
        }
        case CANCEL_TICKET_VFYC_FBS:
        {
        	GIDB_FBS_CT_STRUCT *cancel_ptr = (GIDB_FBS_CT_STRUCT *)data;
        	FBS_TICKET_VFYC *sale_vfyc_ptr = (FBS_TICKET_VFYC *)buffer;
            sale_vfyc_ptr->length = sizeof(FBS_TICKET_VFYC) + cancel_ptr->ticket.length + sizeof(cancel_ptr->ticket);
            strncpy(sale_vfyc_ptr->rspfn_ticket, cancel_ptr->rspfn_ticket, TSN_LENGTH);
            sale_vfyc_ptr->isCancel = true;
            memcpy((char*)&sale_vfyc_ptr->ticket, (char*)&cancel_ptr->ticket, cancel_ptr->ticket.length);
            hmac_md5(key, key_len, (const unsigned char *)buffer, sale_vfyc_ptr->length, vfyc, FBS_VFYC_LEN);
            *vfyc_len = FBS_VFYC_LEN;

            /*
            log_debug("CANCEL_TICKET_VFYC_T --- %s --->", sale_vfyc_ptr->rspfn_ticket);
            gidb_dumpHexBuffer((char*)sale_vfyc_ptr, sizeof(SALE_CANCEL_TICKET_VFYC) + sale_vfyc_ptr->ticket.betStringLen + sale_vfyc_ptr->ticket.betlineLen);
            log_debug("Vfyc [%d] --->", *vfyc_len);
            gidb_dumpHexBuffer((char*)vfyc, *vfyc_len);
            log_debug("Vfyc key[%d] --->", key_len);
            gidb_dumpHexBuffer((char*)key, key_len);
            */
            break;
        }
    }
    return 0;
}

int ts_calc_vfyc_fbs(int32 type, void *data, unsigned char *vfyc, uint32 *vfyc_len)
{
    int key_type = 0;
    if ((SALE_TICKET_VFYC_FBS == type) || (CANCEL_TICKET_VFYC_FBS == type))
        key_type = SALE_TICKET_KEY;
    else if((WIN_TICKET_VFYC_FBS == type) || (PAY_TICKET_VFYC_FBS == type))
        key_type = WIN_TICKET_KEY;
    else
    {
        log_error("ts_calc_vfyc_fbs(%d) type error.", type);
        return -1;
    }

    static unsigned char key[64];
    uint16 key_version = 0;
    int key_len = sysdb_getKey(key_type, key, &key_version);
    if (key_len <= 0)
    {
        log_error("sysdb_getKey(%d) error.", key_type);
        return -1;
    }
    key_version = KEY_MASK ^ key_version;

    uint32 vfyc_len_l = 0;
    //log_info("ts_calc_vfyc_fbs  ---- WRITE --------------------->");
    calculate_vfyc_fbs(type, key, key_len, data, vfyc, &vfyc_len_l);
    //log_info("ts_calc_vfyc_fbs ------> version[%d]", key_version);

    memcpy(vfyc+vfyc_len_l, (char*)&key_version, KEY_VERSION_LEN);
    *vfyc_len = vfyc_len_l + KEY_VERSION_LEN;
    return 0;
}

int ts_check_vfyc_fbs(int32 type, void *data, unsigned char *vfyc, uint32 vfyc_len)
{
    int key_type = 0;
    if ((SALE_TICKET_VFYC_FBS == type) || (CANCEL_TICKET_VFYC_FBS == type))
        key_type = SALE_TICKET_KEY;
    else if((WIN_TICKET_VFYC_FBS== type) || (PAY_TICKET_VFYC_FBS == type))
        key_type = WIN_TICKET_KEY;
    else
    {
        log_error("ts_check_vfyc_fbs(%d) type error.", type);
        return -1;
    }

    //�õ�vfyc�汾��
    unsigned char *ptr = vfyc + FBS_VFYC_LEN;
    uint16 key_version = KEY_MASK ^ *(uint16 *)ptr;

    //���ݰ汾�ź����͵õ�һ��key�����ڼ���
    static unsigned char key[64];
    int key_len = sysdb_findKey(key_type, key_version, key);
    if (key_len <= 0)
    {
        log_error("sysdb_findKey(%d) error.", key_type);
        return -1;
    }

    static unsigned char vfyc_l[64];
    memset(vfyc_l, 0, sizeof(vfyc_l));
    uint32 vfyc_len_l = 0;
    //log_info("ts_check_vfyc_fbs  ---- READ --------------------->");
    //log_info("vfyc_len -> %d",  vfyc_len);
    //gidb_dumpHexBuffer((char*)vfyc, vfyc_len);
    calculate_vfyc_fbs(type, key, key_len, data, vfyc_l, &vfyc_len_l);
    //log_info("ts_check_vfyc_fbs  ---- READ ------> version[%d]", key_version);
    if (((vfyc_len-KEY_VERSION_LEN) != vfyc_len_l) || (memcmp(vfyc, vfyc_l, vfyc_len_l) != 0))
    {
        log_error("ts_check_vfyc_fbs() failure. type[%d]vfyc_len[%d]vfyc_len_l[%d]",
                  type, vfyc_len, vfyc_len_l);

        return -1;
    }
    return 0;
}


//=============================================================================










//=============================================================================

#if R("---GIDB_FBS_INTERFACE---")

//---------------------------------------------------------
// gidb fbs operator interface
//---------------------------------------------------------

//------------------- gidb fbs handle interface --------------------------------------------


//�����ڱ� 
int32 gidb_fbs_im_create_table(sqlite3 *db)
{
    //��ʼ���µ�����
    if ( db_begin_transaction(db) < 0 )
    {
        log_error("db_begin_transaction error.");
        return -1;
    }

    const char *sql_str = "CREATE TABLE issue_table( \
        game_code             INTEGER NOT NULL, \
        issue_number          INT64   NOT NULL PRIMARY KEY, \
        publish_time          INT64   NOT NULL, \
        g_adjustment_fundRate INTEGER NOT NULL, \
        g_return_rate         INTEGER NOT NULL, \
        g_pay_end_day         INTEGER NOT NULL )";

    if (0 != db_create_table(db, sql_str))
    {
        log_error("gidb fbs create issue table() failure!");
        return -1;
    }

    //match_code ��Χ  151012000 - 151012999 (���ڲ�ѯָ���ڴεı���)
    const char *sql_str_1 = "CREATE TABLE match_table( \
	    issue_number          INTEGER NOT NULL, \
        match_code            INT64   NOT NULL PRIMARY KEY, \
        seq                   INTEGER NOT NULL, \
        home_code             INTEGER NOT NULL, \
        away_code             INTEGER NOT NULL, \
        draw_time             INT64   NOT NULL, \
        state                 INTEGER NOT NULL )";
    if (0 != db_create_table(db, sql_str_1))
    {
        log_error("gidb fbs create match table() failure!");
        return -1;
    }

    //�����ύ
    if ( db_end_transaction(db) < 0 )
    {
        log_error("db_end_transaction error.");
        return -1;
    }

    log_debug("gidb_fbs_im_create_table() -> success.");
    return 0;
}

int32 gidb_fbs_im_init_data(GIDB_FBS_IM_HANDLE *self)
{
    ts_notused(self);
    //
    return 0;
}

int32 gidb_fbs_im_insert_issue(GIDB_FBS_IM_HANDLE *self, GIDB_FBS_ISSUE_INFO *p_issue_info)
{
    //REPLACE INTO
    const char *sql_str = "REPLACE INTO issue_table ( \
        game_code, \
    	issue_number, \
    	publish_time, \
        g_adjustment_fundRate, \
        g_return_rate, \
        g_pay_end_day ) VALUES ( \
        %u,%u,%u,%u,%u,  %u)";

    int32 rc;
    char *zErrMsg = 0;

    if (NULL == p_issue_info)
    {
        log_error("input p_issue_info is NULL.");
        return -1;
    }
    static char sql[4096] = {0};
    sprintf( sql, sql_str,
        self->game_code,
        p_issue_info->issueNumber,
        p_issue_info->publishTime,
        p_issue_info->adjustmentFundRate,
        p_issue_info->returnRate,
        p_issue_info->payEndDay );

    rc = sqlite3_exec(self->db, sql, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("gidb_fbs_im_insert_issue() -> SQL error: %s", zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }

    log_notice("gidb_fbs_im_insert_issue(%u, %u) -> success.", self->game_code, p_issue_info->issueNumber);
    return 0;
}

//ret=2��δ�ҵ����ڴ�
int32 gidb_fbs_im_get_issue(GIDB_FBS_IM_HANDLE *self, uint32 issue_number, GIDB_FBS_ISSUE_INFO *p_issue_info)
{
    const char *sql_str = "SELECT issue_number, \
    		game_code, \
            publish_time, \
    		g_adjustment_fundRate, \
    		g_return_rate, \
    		g_pay_end_day \
        FROM issue_table WHERE issue_number=%u";

    int32 rc;
    if (NULL == p_issue_info)
    {
        log_error("input issue_info is NULL.");
        return -1;
    }
    char sql[4096] = {0};
    sprintf(sql, sql_str, issue_number);

    sqlite3_stmt* pStmt = NULL;
    rc = sqlite3_prepare_v2(self->db, sql, strlen(sql), &pStmt, NULL);
    if ( rc != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() error. [%d]", rc);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    rc = sqlite3_step(pStmt);
    if (rc == SQLITE_DONE)
    {
        log_info("gidb_fbs_im_get_issue() return empty.[%u]", issue_number);
        if (pStmt)
            sqlite3_finalize(pStmt);

        //�����ݿ���в�ѯ��Ȼ����뱾���ڴα�
        DB_ISSUE_POLICY policy;
        memset((void *)&policy, 0, sizeof(DB_ISSUE_POLICY));
        if (!otl_getFbsIssuePolicy(self->game_code, issue_number, &policy))
        {
            log_error("otl_getFbsIssuePolicy error game[%d] issue[%d]", self->game_code, issue_number);
            return -1;
        }

        if (!policy.isValid) {
            log_info("issue not found,issue[%d]", issue_number);
            return 2;//���ݿ���û�ҵ����ڴ�
        }

        memset(p_issue_info, 0, sizeof(GIDB_FBS_ISSUE_INFO));
        p_issue_info->gameCode = self->game_code;
        p_issue_info->issueNumber = issue_number;
        p_issue_info->publishTime = policy.publishTime;
        p_issue_info->adjustmentFundRate = policy.adjustmentFundRate;
        p_issue_info->returnRate = policy.returnRate;
        p_issue_info->payEndDay = policy.payEndDay;

		if (gidb_fbs_im_insert_issue(self, p_issue_info) != 0)
		{
			log_error("gidb_fbs_im_insert_issue() error. game[%d] issue_number[%u]", self->game_code, issue_number);
			return -1;
		}


        return 0;
    }
    else if (rc != SQLITE_ROW)
    {
        log_error("sqlite3_step() failure!");
        sqlite3_finalize(pStmt);
        return -1;
    }
    p_issue_info->gameCode           = sqlite3_column_int(pStmt, 0);
    p_issue_info->issueNumber        = sqlite3_column_int(pStmt, 1);
    p_issue_info->publishTime        = sqlite3_column_int(pStmt, 2);
    p_issue_info->adjustmentFundRate = sqlite3_column_int(pStmt, 3);
    p_issue_info->returnRate         = sqlite3_column_int(pStmt, 4);
    p_issue_info->payEndDay          = sqlite3_column_int(pStmt, 5);

    sqlite3_finalize(pStmt);

    log_notice("gidb_fbs_im_get_issue(%u, %u) -> success.", self->game_code, issue_number);
    return 0;
}
//ɾ��ָ���ڴμ��ڴ���������г���
int32 gidb_fbs_im_del_issue(GIDB_FBS_IM_HANDLE *self, uint32 issue_number)
{
#if 0 //��������ڴ�sqlite���ڴκͱ������ݣ�Ŀǰ��ʹ��
    const char *sql_str   = "DELETE FROM issue_table WHERE issue_number = %u";
	const char *sql_str_1 = "DELETE FROM match_table WHERE issue_number = %u";
    int32 rc;
    char *zErrMsg = 0;

    static char sql[4096] = {0};
    sprintf( sql, sql_str, issue_number );

    rc = sqlite3_exec(self->db, sql, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("gidb_fbs_im_del_issue() issue -> SQL error: %s", zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }

    sprintf( sql, sql_str_1, issue_number );

    rc = sqlite3_exec(self->db, sql, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("gidb_fbs_im_del_issue() match-> SQL error: %s", zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }
#endif
    log_notice("gidb_fbs_im_del_issue(%u, %u) -> success.", self->game_code, issue_number);
    return 0;
}

int32 gidb_fbs_im_insert_matches(GIDB_FBS_IM_HANDLE *self, GIDB_FBS_MATCH_INFO *p_matches, int match_count)
{
    //REPLACE INTO
    const char *sql = "REPLACE INTO match_table ( \
            issue_number, \
            match_code, \
            seq, \
            home_code, \
            away_code, \
            draw_time, \
            state ) VALUES ( \
    		?,?,?,?,?, ?,? )";

    int32 rc;

    if (NULL == p_matches)
    {
        log_error("input p_matches is NULL.");
        return -1;
    }

    sqlite3_stmt* pStmt = NULL;
    rc = sqlite3_prepare_v2(self->db, sql, strlen(sql), &pStmt, NULL);
    if ( rc != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() error. [%d]", rc);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    GIDB_FBS_MATCH_INFO *pMatch = p_matches;

    //ѭ������
    for (int i = 0; i < match_count; i++) {
    	bind_fbs_match(pMatch, pStmt);

        rc = sqlite3_step(pStmt);
        if ( rc != SQLITE_DONE) {
            log_error("sqlite3_step() error.");
            sqlite3_finalize(pStmt);
            return -1;
        }

        log_debug("gidb_fbs_im_insert_match(matchCode[%u], state[%d]) -> success.", pMatch->match_code, pMatch->state);
        pMatch++;
    }

    sqlite3_finalize(pStmt);

    log_debug("gidb_fbs_im_insert_match(%u, %u) -> success.", self->game_code, match_count);
    return 0;
}

//ɾ��ָ���ı���
int32 gidb_fbs_im_del_match(GIDB_FBS_IM_HANDLE *self, uint32 match_code)
{
#if 0
	const char *sql_str = "DELETE FROM match_table WHERE match_code = %u";
    int32 rc;
    char *zErrMsg = 0;

    static char sql[4096] = {0};
    sprintf( sql, sql_str, match_code );

    rc = sqlite3_exec(self->db, sql, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("gidb_fbs_im_del_match() -> SQL error: %s", zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }
#endif
    log_notice("gidb_fbs_im_del_match(%u, %u) -> success.", self->game_code, match_code);
    return 0;
}

//����ָ���ڴεı���������
int32 gidb_fbs_im_get_matches(GIDB_FBS_IM_HANDLE *self, uint32 issue_number, GIDB_FBS_MATCH_INFO *p_matches)
{
#if 0
    const char *sql_str = "SELECT \
            issue_number, \
            match_code, \
            seq, \
            competition, \
            competition_abbr, \
            round, \
            home_code, \
            home_term, \
            away_code, \
            away_term, \
            date, \
            venue, \
            match_time, \
            result_time, \
            draw_time, \
            sale_time, \
            close_time, \
            state, \
            home_handicap, \
            home_handicap_point5, \
            fht_win_result, \
            fht_home_goals, \
            fht_away_goals, \
            fht_total_goals, \
            sht_win_result, \
            sht_home_goals, \
            sht_away_goals, \
            sht_total_goals, \
            ft_win_result, \
            ft_home_goals, \
            ft_away_goals, \
            ft_total_goals, \
            first_goal, \
            fbs_odds, \
            fbs_result FROM match_table \
    		WHERE issue_number = %u ";

    int32 rc;
    GIDB_FBS_MATCH_INFO *pMatch = p_matches;

    char sql[4096] = {0};
    sprintf(sql, sql_str, issue_number);

    sqlite3_stmt* pStmt = NULL;
    rc = sqlite3_prepare_v2(self->db, sql, strlen(sql), &pStmt, NULL);
    if ( rc != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() error. [%d]", rc);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    int noRec = 1;
    while(1) {
    	rc = sqlite3_step(pStmt);
    	if ( (rc == SQLITE_DONE) and (0 == noRec) )
		{
    		return 0;
		}
    	else if ( (rc == SQLITE_DONE) and (1 == noRec) )
		{
			noRec = 0;
			log_info("gidb_fbs_im_get_matches() return empty.");
			if (pStmt)
				sqlite3_finalize(pStmt);

			//�����ݿ���в�ѯ��Ȼ����뱾�ر�����
			memset(pMatch, 0, sizeof(GIDB_FBS_MATCH_INFO));
			/*
			if (!otl_get_issue_info(self->game_code, issue_number, issue_info))
			{
				log_error("gidb_fbs_im_get_matches() error. game[%d] issue_number[%llu]", self->game_code, issue_number);
				return -1;
			}*/
			//if(ISSUE_STATE_ISSUE_END == issue_info->status)

			if (gidb_fbs_im_insert_matches(self, pMatch, 1) != 0)
			{
				log_error("gidb_fbs_im_insert_matches() error. game[%d] match_code[%u]", self->game_code, pMatch->match_code);
				return -1;
			}

			pMatch++;
			continue;
		}
		else if (rc != SQLITE_ROW)
		{
			log_error("sqlite3_step() failure!");
			sqlite3_finalize(pStmt);
			return -1;
		}

		get_fbs_match_rec_from_stmt(pMatch, pStmt);
		pMatch++;
    }


    sqlite3_finalize(pStmt);
#endif
    log_notice("gidb_fbs_im_get_matches(%u, %u) -> success.", self->game_code, issue_number);
    return 0;
}

//����ָ���ı�����Ϣ
int32 gidb_fbs_im_get_match(GIDB_FBS_IM_HANDLE *self, uint32 match_code, GIDB_FBS_MATCH_INFO *p_match_info)
{
    const char *sql_str = "SELECT \
            issue_number, \
            match_code, \
            seq, \
            home_code, \
            away_code, \
            draw_time, \
            state \
            FROM match_table \
    		WHERE match_code=%u ";

    int32 rc;

    char sql[4096] = {0};
    sprintf(sql, sql_str, match_code);

    sqlite3_stmt* pStmt = NULL;
    rc = sqlite3_prepare_v2(self->db, sql, strlen(sql), &pStmt, NULL);
    if ( rc != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() error. [%d]", rc);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    rc = sqlite3_step(pStmt);
    if (rc == SQLITE_DONE)
    {
        log_info("gidb_fbs_im_get_match() return empty.");
        if (pStmt)
            sqlite3_finalize(pStmt);

        //�����ݿ���в�ѯ��Ȼ����뱾�ر�����
        memset(p_match_info, 0, sizeof(GIDB_FBS_MATCH_INFO));
        DB_FBS_MATCH arrMatch[FBS_MAX_ISSUE_MATCH] = {0};
        GIDB_FBS_MATCH_INFO arrMatchGidb[FBS_MAX_ISSUE_MATCH] = {0};
        int matchCnt = 0;

        //����match_code,������match_code����issue�µ�����match��Ϣ�͸���
        if (!otl_get_allMatchesByOneMatch(self->game_code, match_code, arrMatch, &matchCnt))
        {
            log_error("otl_get_allMatchesByOneMatch() error. game[%d] match[%u]", self->game_code, match_code);
            return -1;
        }
        //k-debug:
        log_debug("matchCnt[%d]", matchCnt);

        int flagLoad = 1;//�ж�ȫ�������Ƿ����
        for (int idx = 0; idx < matchCnt; idx++)
        {
            if (match_code == arrMatch[idx].match_code) {
                p_match_info->issue_number = arrMatch[idx].issue_number;
                p_match_info->match_code = arrMatch[idx].match_code;
                p_match_info->seq = arrMatch[idx].seq;
                p_match_info->home_code = arrMatch[idx].home_code;
                p_match_info->away_code = arrMatch[idx].away_code;
                p_match_info->state = arrMatch[idx].match_status;
                p_match_info->draw_time = arrMatch[idx].reward_time;
            }
            if (arrMatch[idx].match_status != M_STATE_CONFIRM) {
                flagLoad = 0;
            }
            arrMatchGidb[idx].issue_number = arrMatch[idx].issue_number;
            arrMatchGidb[idx].match_code = arrMatch[idx].match_code;
            arrMatchGidb[idx].seq = arrMatch[idx].seq;
            arrMatchGidb[idx].home_code = arrMatch[idx].home_code;
            arrMatchGidb[idx].away_code = arrMatch[idx].away_code;
            arrMatchGidb[idx].state = arrMatch[idx].match_status;
            arrMatchGidb[idx].draw_time = arrMatch[idx].reward_time;
        }

        if (flagLoad) {
            if (gidb_fbs_im_insert_matches(self, arrMatchGidb, matchCnt) != 0)
            {
                log_error("gidb_fbs_im_insert_matches() error. game[%d] match_code[%u]", self->game_code, p_match_info->match_code);
                return -1;
            }
        }

        return 0;
    }
    else if (rc != SQLITE_ROW)
    {
        log_error("sqlite3_step() failure!");
        sqlite3_finalize(pStmt);
        return -1;
    }
    get_fbs_match_rec_from_stmt(p_match_info, pStmt);

    sqlite3_finalize(pStmt);

    log_notice("gidb_fbs_im_get_match(%u, %u) -> success.", self->game_code, match_code);
    return 0;
}

GIDB_FBS_IM_HANDLE *fbs_im_handle = NULL;
GIDB_FBS_IM_HANDLE * gidb_fbs_im_init(uint8 game_code)
{
    int32 ret = 0;
    char game_abbr[16];
    get_game_abbr(game_code, game_abbr);
    char db_path[256];
    ts_get_mem_game_filepath(game_abbr, db_path, 256);

    //open sqlite db connect
    sqlite3 * db = db_connect(db_path);
    if (db == NULL) {
        log_error("db_connect(%s) error.", db_path);
        return NULL;
    }
    //�жϱ��Ƿ��Ѵ���
    ret = db_check_table_exist(db, "issue_table");
    if (ret < 0) {
        log_error("db_check_table_exist(%s) found error.", db_path);
        return NULL;
    } else if (1 == ret) {
        //�������ڣ�������
        if (gidb_fbs_im_create_table(db) < 0) {
            log_error("gidb_i_create_table(%s) error.", db_path);
            return NULL;
        }
    }

    GIDB_FBS_IM_HANDLE * ptr = NULL;
    ptr = (GIDB_FBS_IM_HANDLE *)malloc(sizeof(GIDB_FBS_IM_HANDLE));
    memset(ptr, 0, sizeof(GIDB_FBS_IM_HANDLE));
    new(ptr)_GIDB_FBS_IM_HANDLE();

    ptr->game_code = game_code;
    ptr->db = db;
    //��ʼ������ָ��
    ptr->gidb_fbs_im_init_data = gidb_fbs_im_init_data;
    ptr->gidb_fbs_im_insert_issue = gidb_fbs_im_insert_issue;
    ptr->gidb_fbs_im_get_issue = gidb_fbs_im_get_issue;
    ptr->gidb_fbs_im_del_issue = gidb_fbs_im_del_issue;
    ptr->gidb_fbs_im_insert_matches = gidb_fbs_im_insert_matches;
    ptr->gidb_fbs_im_del_match = gidb_fbs_im_del_match;
    ptr->gidb_fbs_im_get_matches = gidb_fbs_im_get_matches;
    ptr->gidb_fbs_im_get_match = gidb_fbs_im_get_match;

    log_debug("gidb_fbs_im_init(%u) -> success.", game_code);
    return ptr;
}

// interface
GIDB_FBS_IM_HANDLE * gidb_fbs_im_get_handle(uint8 game_code)
{
    if (NULL != fbs_im_handle)
    {
        return fbs_im_handle;
    }

    fbs_im_handle = gidb_fbs_im_init(game_code);
    if (NULL == fbs_im_handle)
    {
        log_error("gidb_fbs_im_init(%d) failure!", game_code);
        return NULL;
    }
    return fbs_im_handle;
}

//�ر�ָ����handle
int32 gidb_fbs_im_close_handle(GIDB_FBS_IM_HANDLE *handle)
{
    db_close(handle->db);
    free((char *)handle);
    log_debug("gidb_fbs_im_close_handle() success!");
    return 0;
}

uint32 gidb_im_last_clean_time = 0;
//�رճ�ʱ��δʹ�õ�handle
int gidb_fbs_im_clean_handle()
{
    uint32 time_n = get_now();
    if ((time_n-gidb_im_last_clean_time) <= ISSUE_HANDLE_TIMEOUT)
        return 0;

    gidb_fbs_im_close_handle(fbs_im_handle);

    gidb_im_last_clean_time = time_n;

    return 0;
}
//�ر����д򿪵�handle
int gidb_fbs_im_close_all_handle()
{
    gidb_fbs_im_close_handle(fbs_im_handle);
    return 0;
}


#endif


#if R("---GIDB FBS TICKET INTERFACE---")

//������Ʊ�� 
int32 gidb_fbs_st_create_table(sqlite3 *db, uint8 game_code, uint64 issue_number)
{
    //��ʼ���µ�����
    if ( db_begin_transaction(db) < 0 )
    {
        log_error("db_begin_transaction error.");
        return -1;
    }

    const char *sql_cfg_str = "CREATE TABLE sale_config_table( \
        game_code          INTEGER NOT NULL, \
        issue_number       INT64   NOT NULL PRIMARY KEY, \
        GAME_PARAM_KEY     BLOB, \
        SUBTYPE_PARAM_KEY  BLOB, \
        POOL_PARAM_KEY     BLOB )";
    if (0 != db_create_table(db, sql_cfg_str))
    {
        log_error("gidb create sale_config_table failure!");
        return -1;
    }

    int32 rc;
    char *zErrMsg = 0;
    const char *sql_config_str = "INSERT INTO sale_config_table ( \
        game_code, issue_number ) VALUES ( %d, %llu )";
    static char sql[1024] = {0};
    sprintf( sql, sql_config_str, game_code, issue_number);
    rc = sqlite3_exec(db, sql, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("sqlite3_exec() -> SQL error: %s", zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }
    log_info("gidb create sale_config_table -> success.");

    const char *sql_str = "CREATE TABLE sale_ticket_table ( \
        from_sale                   INTEGER     NOT NULL, \
        unique_tsn                  INT64       NOT NULL PRIMARY KEY, \
        reqfn_ticket                VARCHAR(24) NOT NULL, \
        rspfn_ticket                VARCHAR(24) NOT NULL, \
        time_stamp                  INT64       NOT NULL, \
        area_code                   INTEGER     DEFAULT (0), \
        area_type                   INTEGER     DEFAULT (0), \
        agency_code                 INT64       DEFAULT (0), \
        terminal_code               INT64       DEFAULT (0), \
        teller_code                 INTEGER     DEFAULT (0), \
        claiming_scope              INTEGER     NOT NULL, \
        is_train                    INTEGER     NOT NULL, \
        game_code                   INTEGER     NOT NULL, \
        issue_number                INTEGER     NOT NULL, \
        sub_type                    INTEGER     NOT NULL, \
        bet_type                    INTEGER     NOT NULL, \
        total_amount                INT64       NOT NULL, \
        commission_amount           INT64       NOT NULL, \
        total_bets                  INTEGER     NOT NULL, \
        bet_times                   INTEGER     NOT NULL, \
        match_count                 INTEGER     NOT NULL, \
        order_count                 INTEGER     NOT NULL, \
        bet_string                  TEXT        NOT NULL, \
        ticket                      BLOB        NOT NULL, \
        is_cancel                   INTEGER     NOT NULL, \
        from_cancel                 INTEGER     DEFAULT (0), \
        reqfn_ticket_cancel         VARCHAR(24), \
        rspfn_ticket_cancel         VARCHAR(24), \
        time_stamp_cancel           INT64       DEFAULT (0), \
        agency_code_cancel          INT64       DEFAULT (0), \
        terminal_code_cancel        INT64       DEFAULT (0), \
        teller_code_cancel          INTEGER     DEFAULT (0), \
        vfyc                        BLOB        NOT NULL )";
    if (0 != db_create_table(db, sql_str))
    {
        log_error("gidb fbs create sale ticket table() failure! sql->%s", sql_str);
        return -1;
    }

    //�����ύ
    if ( db_end_transaction(db) < 0 )
    {
        log_error("db_end_transaction error.");
        return -1;
    }

    log_info("gidb fbs create sale ticket table() -> success.");
    return 0;
}

static const char *FBS_ST_FIELD_BLOB_NAME[] =  {
    "NONE",
    "GAME_PARAM_KEY",
    "SUBTYPE_PARAM_KEY",
    "POOL_PARAM_KEY"
};

//�����ڱ��������ֶ�����
int gidb_fbs_st_set_field_blob(GIDB_FBS_ST_HANDLE *self, FBS_ST_FIELD_BLOB_KEY field_type, char *data, int32 len)
{
    int32 rc;
    const char *sql_field_data = "UPDATE sale_config_table SET %s=? WHERE game_code=%d AND issue_number=%llu";

    char sql[4096] = {0};
    sprintf(sql, sql_field_data, FBS_ST_FIELD_BLOB_NAME[field_type], self->game_code, self->issue_number);

    //��ʼ���µ�����
    if (db_begin_transaction(self->db) < 0) {
        log_error("db_begin_transaction(%d, %llu) error.", self->game_code, self->issue_number);
        return -1;
    }

    sqlite3_stmt* pStmt = NULL;
    rc = sqlite3_prepare_v2(self->db, sql, strlen(sql), &pStmt, NULL);
    if ( rc != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() error. [%d]", rc);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    if ( sqlite3_bind_blob(pStmt, 1, data, len, SQLITE_STATIC) != SQLITE_OK)
    {
        log_error("sqlite3_bind_blob() error.");
        sqlite3_finalize(pStmt);
        return -1;
    }

    rc = sqlite3_step(pStmt);
    if ( rc != SQLITE_DONE)
    {
        log_error("sqlite3_step() error.");
        sqlite3_finalize(pStmt);
        return -1;
    }

    sqlite3_finalize(pStmt);

    //�����ύ
    if (db_end_transaction(self->db) < 0) {
        log_error("db_end_transaction(%d, %llu) error.", self->game_code, self->issue_number);
        return -1;
    }

    log_notice("gidb_fbs_st_set_field_blob(%d, %u, fieldType[%d]) -> success.",
    		self->game_code, self->issue_number, field_type);
    return 0;
}
//�����ڱ��������ֶ��ֶ�����
//����ֵ: С��0=����  0=�ɹ����ؽ��  1=û���ҵ���ѯ�ļ�¼  2=��ѯ���ֶ�Ϊ��
int gidb_fbs_st_get_field_blob(GIDB_FBS_ST_HANDLE *self, FBS_ST_FIELD_BLOB_KEY field_type, char *data, int32 *len)
{
    int32 rc;
    const char *sql_field_data = "SELECT %s FROM sale_config_table WHERE game_code=%d AND issue_number=%llu";

    char * data_ptr = NULL;
    uint32 data_len = 0;

    char sql[4096] = {0};
    sprintf(sql, sql_field_data, FBS_ST_FIELD_BLOB_NAME[field_type], self->game_code, self->issue_number);
    //k-debug:FBS
    log_info("sql:%s", sql);

    sqlite3_stmt* pStmt = NULL;
    rc = sqlite3_prepare_v2(self->db, sql, strlen(sql), &pStmt, NULL);
    if ( rc != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() error. [%d]", rc);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    rc = sqlite3_step(pStmt);
    if (rc == SQLITE_DONE)
    {
        log_info("gidb_fbs_st_get_field_blob() return empty.");
        sqlite3_finalize(pStmt);
        return 1;
    }
    else if (rc != SQLITE_ROW)
    {
        log_error("sqlite3_step() failure!");
        sqlite3_finalize(pStmt);
        return -1;
    }

    data_ptr = (char *)sqlite3_column_blob(pStmt, 0);
    if (data_ptr != NULL)
    {
        data_len = sqlite3_column_bytes(pStmt, 0);
        memcpy(data, data_ptr, data_len);
        *len = data_len;
    }
    else
    {
        *len = 0;
        log_info("gidb_fbs_st_get_field_blob() return empty. field data is NULL.");
        sqlite3_finalize(pStmt);
        return 2;
    }

    sqlite3_finalize(pStmt);

    log_notice("gidb_fbs_st_get_field_blob(%d, %u, fieldType[%d]) -> success.",
    		self->game_code, self->issue_number, field_type);
    return 0;
}


//��������Ʊ (�ڲ�֧�ֶ���Ʊ�Ĳ���) (����ʽ���룬������ɺ���Ҫ����ͬ���ӿڣ����ܸ��µ����ݿ�) 
int32 gidb_fbs_st_insert_ticket(GIDB_FBS_ST_HANDLE *self, GIDB_FBS_ST_REC *pSTicket)
{
    uint32 len = offsetof(GIDB_FBS_ST_REC, ticket) + pSTicket->ticket.length;

    GIDB_FBS_ST_REC *ptr = NULL;
    ptr = (GIDB_FBS_ST_REC *)malloc(len);
    if (NULL == ptr)
    {
        log_error("malloc return failure!");
        return -1;
    }
    memcpy((char *)ptr, (char *)pSTicket, len);

    self->saleTicketList.push_back(ptr);
    self->commit_flag = true;

    log_notice("gidb_fbs_st_insert_ticket push_back rspfn_ticket[%s] game[%d] issue[%u]",
    		pSTicket->rspfn_ticket, pSTicket->ticket.game_code, pSTicket->issue_number);
    return 0;
}
//���²�ƱΪ����Ʊ(����ʽ���룬������ɺ���Ҫ����ͬ���ӿڣ����ܸ��µ����ݿ�)
int32 gidb_fbs_st_update_cancel(GIDB_FBS_ST_HANDLE *self, GIDB_FBS_CT_STRUCT *pCTicket)
{
	uint32 len = offsetof(GIDB_FBS_CT_STRUCT, ticket) + pCTicket->ticket.length;

	GIDB_FBS_CT_STRUCT *ptr = NULL;
    ptr = (GIDB_FBS_CT_STRUCT *)malloc(len);
    if (NULL == ptr)
    {
        log_error("malloc return failure!");
        return -1;
    }
    memcpy((char *)ptr, (char *)pCTicket, len);

    self->cancelTicketList.push_back(ptr);
    self->commit_flag = true;

    log_notice("gidb_fbs_ct_insert_ticket push_back rspfn_ticket[%s] game[%d] issue[%u]",
    		pCTicket->rspfn_ticket, pCTicket->ticket.game_code, pCTicket->ticket.issue_number);

    return 0;
}
//�����ڵ�LIST�ڴ��е�(��Ʊ����Ʊ�ļ�¼)����д�����ݿ��ļ�
int32 gidb_fbs_st_sync_sc_ticket(GIDB_FBS_ST_HANDLE *self)
{
    int32 rc = 0;

    if (self->commit_flag == false)
    {
        return 0;
    }

    const char *sql_insert_sale_ticket = "INSERT INTO sale_ticket_table ( \
		from_sale, \
		unique_tsn, \
		reqfn_ticket, \
		rspfn_ticket, \
		time_stamp, \
		area_code, \
		area_type, \
		agency_code, \
		terminal_code, \
		teller_code, \
		claiming_scope, \
		is_train, \
		game_code, \
		issue_number, \
		sub_type, \
		bet_type, \
		total_amount, \
		commission_amount, \
		total_bets, \
		bet_times, \
		match_count, \
		order_count, \
		bet_string, \
		ticket, \
		is_cancel, \
        vfyc ) VALUES ( \
        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)";

    const char *sql_update_cancel_ticket = "UPDATE sale_ticket_table SET \
        is_cancel=?, from_cancel=?, reqfn_ticket_cancel=?, rspfn_ticket_cancel=?, time_stamp_cancel=?, \
        agency_code_cancel=?, terminal_code_cancel=?, teller_code_cancel=?, vfyc=? \
        WHERE unique_tsn=?";

    //��ʼ���µ�����
    if ( db_begin_transaction(self->db) < 0 )
    {
        log_error("db_begin_transaction(%d, %u) error.", self->game_code, self->issue_number);
        return -1;
    }

    //������Ʊҵ��Ĳ������
    sqlite3_stmt* pStmt = NULL;
    if (sqlite3_prepare_v2(self->db, sql_insert_sale_ticket, strlen(sql_insert_sale_ticket), &pStmt, NULL) != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() insert sale ticket error.");
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    static unsigned char vfyc[64];
    uint32 vfyc_len = 0;
    GIDB_FBS_ST_REC* ptr_sale = NULL;
    while (!self->saleTicketList.empty())
    {
        ptr_sale = self->saleTicketList.front();
        memset(vfyc, 0, sizeof(vfyc));

        if (ts_calc_vfyc_fbs(SALE_TICKET_VFYC_FBS, ptr_sale, vfyc, &vfyc_len) != 0)
        {
            log_error("ts_calc_vfyc_fbs() failure.");
            return -1;
        }
        bind_fbs_st_ticket(ptr_sale, pStmt, vfyc, vfyc_len);

        rc = sqlite3_step(pStmt);
        if ( rc != SQLITE_DONE)
        {
            log_error("sqlite3_step() insert sale ticket error. ret[%d], tsn[%s]", rc, ptr_sale->rspfn_ticket);
            if (pStmt)
                sqlite3_finalize(pStmt);
            return -1;
        }
        sqlite3_reset(pStmt);

        free((char *)ptr_sale);
        self->saleTicketList.pop_front();
    }
    sqlite3_finalize(pStmt);

    //������Ʊҵ��ĸ���
    if (sqlite3_prepare_v2(self->db, sql_update_cancel_ticket, strlen(sql_update_cancel_ticket), &pStmt, NULL) != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() update cancel error.");
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    GIDB_FBS_CT_STRUCT* ptr_cancel = NULL;
    while (!self->cancelTicketList.empty())
    {
        ptr_cancel = self->cancelTicketList.front();

        if (ts_calc_vfyc_fbs(CANCEL_TICKET_VFYC_FBS, ptr_cancel, vfyc, &vfyc_len) != 0)
        {
            log_error("ts_calc_vfyc_fbs() failure.");
            return -1;
        }
        bind_fbs_update_cancel_ticket(ptr_cancel, pStmt, vfyc, vfyc_len);

        rc = sqlite3_step(pStmt);
        if ( rc != SQLITE_DONE)
        {
            log_error("sqlite3_step() update cancel ticket error. ret[%d]", rc);
            if (pStmt)
                sqlite3_finalize(pStmt);
            return -1;
        }
        sqlite3_reset(pStmt);

        free((char *)ptr_cancel);
        self->cancelTicketList.pop_front();
    }
    sqlite3_finalize(pStmt);

    //�����ύ
    if ( db_end_transaction(self->db) < 0 )
    {
        log_error("db_end_transaction(%d, %u) error.", self->game_code, self->issue_number);
        return -1;
    }

    self->commit_flag = false;
    self->last_time = get_now();
    return 0;
}

//get ticket by rspfn_ticket
int32 gidb_fbs_st_get_ticket(GIDB_FBS_ST_HANDLE *self, uint64 unique_tsn, GIDB_FBS_ST_REC *pSTicket)
{
    int32 rc;

    const char *sql_str = "SELECT * FROM sale_ticket_table WHERE unique_tsn=?";
    sqlite3_stmt* pStmt = NULL;

    rc = sqlite3_prepare_v2(self->db, sql_str, strlen(sql_str), &pStmt, NULL);
    if ( rc != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() error. [%d]", rc);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    sqlite3_bind_int64(  pStmt, 1,   unique_tsn);

    rc = sqlite3_step(pStmt);
    if (rc == SQLITE_DONE)
    {
        log_info("gidb_fbs_st_get_ticket() return empty.");
        sqlite3_finalize(pStmt);
        return 1;
    }
    else if (rc != SQLITE_ROW)
    {
        log_error("sqlite3_step() failure! ret[%d]", rc);
        sqlite3_finalize(pStmt);
        return -1;
    }

    //��ȡ����
    if ( get_fbs_st_rec_from_stmt(pSTicket, pStmt) < 0 )
    {
        log_error("get_fbs_st_rec_from_stmt() failure!");
        sqlite3_finalize(pStmt);
        return -1;
    }

    sqlite3_finalize(pStmt);
    return 0;
}

static FBS_ST_MAP  fbs_st_map;
GIDB_FBS_ST_HANDLE *map_fbs_st_get(uint8 game_code, uint32 issue_number)
{
    uint64 key = (((uint64)game_code)<<56) + issue_number;
    if (1 == fbs_st_map.count(key))
    {
        return fbs_st_map[key];
    }
    return NULL;
}

int32 map_fbs_st_set(uint8 game_code, uint32 issue_number, GIDB_FBS_ST_HANDLE *handle)
{
    if (NULL == handle)
    {
        return -1;
    }
    uint64 key = (((uint64)game_code)<<56) + issue_number;
    fbs_st_map[key] = handle;
    return 0;
}

GIDB_FBS_ST_HANDLE * gidb_fbs_st_init(uint8 game_code, uint32 issue_number)
{
    int32 ret = 0;

    char game_abbr[16];
    get_game_abbr(game_code, game_abbr);
    char db_path[256];
    ts_get_fbs_issue_ticket_filepath(game_abbr, issue_number, db_path, 256);

    //open sqlite db connect
    sqlite3 * db = db_connect(db_path);
    if ( db == NULL )
    {
        log_error("db_connect(%s) error.", db_path);
        return NULL;
    }

    //�жϱ��Ƿ��Ѵ���
    ret = db_check_table_exist(db, "sale_ticket_table");
    if ( ret < 0)
    {
        log_error("db_check_table_exist(%s) found error.", db_path);
        return NULL;
    }
    else if ( 1 == ret )
    {
        //�������ڣ�������
        if ( gidb_fbs_st_create_table(db, game_code, issue_number) < 0 )
        {
            log_error("gidb_fbs_st_create_table(%s) error.", db_path);
            return NULL;
        }
    }

    //����map
    GIDB_FBS_ST_HANDLE * ptr = NULL;
    ptr = (GIDB_FBS_ST_HANDLE *)malloc(sizeof(GIDB_FBS_ST_HANDLE));
    memset(ptr, 0, sizeof(GIDB_FBS_ST_HANDLE));
    new(ptr)_GIDB_FBS_ST_HANDLE();

    ptr->game_code = game_code;
    ptr->issue_number = issue_number;
    ptr->last_time = get_now();
    ptr->db = db;

    //��ʼ������ָ��
    ptr->gidb_fbs_st_set_field_blob = gidb_fbs_st_set_field_blob;
    ptr->gidb_fbs_st_get_field_blob = gidb_fbs_st_get_field_blob;

    ptr->gidb_fbs_st_insert_ticket = gidb_fbs_st_insert_ticket;
    ptr->gidb_fbs_st_update_cancel = gidb_fbs_st_update_cancel;
    ptr->gidb_fbs_st_sync_sc_ticket = gidb_fbs_st_sync_sc_ticket;
    ptr->gidb_fbs_st_get_ticket = gidb_fbs_st_get_ticket;

    map_fbs_st_set(game_code, issue_number, ptr);

    log_notice("gidb_fbs_st_init(%u, %u) -> success.", game_code, issue_number);
    return ptr;
}

GIDB_FBS_ST_HANDLE* gidb_fbs_st_get_handle(uint8 game_code, uint32 issue_number)
{
    //k-debug:FBS
	log_info("issue:FBS %d", issue_number);
	GIDB_FBS_ST_HANDLE *ptr = map_fbs_st_get(game_code, issue_number);
    if (NULL != ptr)
    {
    	//k-debug:FBS
    	log_info("issue:FBS2 %d, %d, %u", ptr->issue_number, ptr->game_code, ptr->last_time);
        ptr->last_time = get_now();
        return ptr;
    }
    //k-debug:FBS
    log_info("issue:FBS1 %d", issue_number);

    ptr = gidb_fbs_st_init(game_code, issue_number);
    if (NULL == ptr)
    {
        log_error("gidb_fbs_st_get_handle(%u, %u) failure!", game_code, issue_number);
        return NULL;
    }
    //k-debug:FBS
    log_info("issue:FBS3 %d", ptr->issue_number);

    //k-debug:FBS
//    //���濪���������
//    int ret = gidb_fbs_save_game_param(game_code, issue_number);
//    if (ret == -1)
//    {
//    	return NULL;
//    }

    return ptr;
}

//�ر�ָ����handle
int32 gidb_fbs_st_close_handle(GIDB_FBS_ST_HANDLE *handle)
{
	uint64 key = (((uint64)handle->game_code)<<56) + handle->issue_number;
	FBS_ST_MAP::iterator iter = fbs_st_map.find(key);
	fbs_st_map.erase(iter);

    db_close(handle->db);
    free((char *)handle);
    log_notice("gidb_fbs_st_close_handle() success!");
    return 0;
}

uint32 gidb_fbs_st_last_clean_time = 0;

//�رճ�ʱ��δʹ�õ�handle
int gidb_fbs_st_clean_handle()
{
	uint32 time_n = get_now();
	if ((time_n-gidb_fbs_st_last_clean_time) <= ISSUE_HANDLE_TIMEOUT)
		return 0;

	GIDB_FBS_ST_HANDLE* handle;
	FBS_ST_MAP::iterator iter;
	//��ȫ�ı���ɾ������������Ԫ��
	for(iter = fbs_st_map.begin(); iter!=fbs_st_map.end();)
	{
		handle = iter->second;
		if ( (time_n-handle->last_time) > ISSUE_HANDLE_TIMEOUT )
		{
			db_close(handle->db);
			free((void *)handle);

			fbs_st_map.erase(iter++);
		}
		else
		{
			++iter;
		}
	}
	gidb_fbs_st_last_clean_time = time_n;

	log_notice("gidb_fbs_st_clean_handle() success!");
	return 0;
}
//�ر����д򿪵�handle
int gidb_fbs_st_close_all_handle()
{
	FBS_ST_MAP::iterator it;
	GIDB_FBS_ST_HANDLE* pi = NULL;
    for(it=fbs_st_map.begin(); it!=fbs_st_map.end();)
    {
        pi = it->second;
        db_close(pi->db);
        free((char *)pi);

        fbs_st_map.erase(it++);
    }
    log_notice("gidb_fbs_st_close_all_handle() success!");
    return 0;
}

#endif


#if R("---GIDB FBS WIN TICKET INTERFACE---")

//������Ʊ�� 
int32 gidb_fbs_wt_create_table(sqlite3 *db)
{
    //��ʼ���µ�����
    if (db_begin_transaction(db) < 0) {
        log_error("db_begin_transaction error.");
        return -1;
    }
/*
//    //���ڵ�����Ϸ���ڷ�������ȡ�����¼������ڷ�������Ͷע���
//    const char *sql_return_str = "CREATE TABLE return_ticket_table ( \
//        from_sale                   INTEGER     NOT NULL, \
//        unique_tsn                  INT64       NOT NULL PRIMARY KEY, \
//        reqfn_ticket                VARCHAR(24) NOT NULL, \
//        rspfn_ticket                VARCHAR(24) NOT NULL, \
//        time_stamp                  INT64       NOT NULL, \
//        area_code                   INTEGER     DEFAULT (0), \
//        area_type                   INTEGER     DEFAULT (0), \
//        agency_code                 INT64       DEFAULT (0), \
//        terminal_code               INT64       DEFAULT (0), \
//        teller_code                 INTEGER     DEFAULT (0), \
//        claiming_scope              INTEGER     NOT NULL, \
//        is_train                    INTEGER     NOT NULL, \
//        game_code                   INTEGER     NOT NULL, \
//        issue_number                INTEGER     NOT NULL, \
//        sub_type                    INTEGER     NOT NULL, \
//        bet_type                    INTEGER     NOT NULL, \
//        total_amount                INT64       NOT NULL, \
//        total_bets                  INTEGER     NOT NULL, \
//        bet_times                   INTEGER     NOT NULL, \
//        match_count                 INTEGER     NOT NULL, \
//        order_count                 INTEGER     NOT NULL, \
//        bet_string                  TEXT        NOT NULL, \
//        win_match_code              INTEGER     NOT NULL, \
//        pay_status                  INTEGER     NOT NULL, \
//        from_pay                    INTEGER     DEFAULT (0), \
//        reqfn_ticket_pay            VARCHAR(24), \
//        rspfn_ticket_pay            VARCHAR(24), \
//        time_stamp_pay              INT64       DEFAULT (0), \
//        agency_code_pay             INT64       DEFAULT (0), \
//        terminal_code_pay           INT64       DEFAULT (0), \
//        teller_code_pay             INTEGER     DEFAULT (0) )";
//    if (0 != db_create_table(db, sql_return_str))
//    {
//        log_error("gidb fbs create single match return ticket table() failure! sql->%s", sql_return_str);
//        return -1;
//    }
//    log_info("gidb fbs create single match return ticket table() -> success.");*/

    const char *sql_str = "CREATE TABLE win_ticket_table ( \
        from_sale                   INTEGER     NOT NULL, \
        unique_tsn                  INT64       NOT NULL PRIMARY KEY, \
        reqfn_ticket                VARCHAR(24) NOT NULL, \
        rspfn_ticket                VARCHAR(24) NOT NULL, \
        time_stamp                  INT64       NOT NULL, \
        area_code                   INTEGER     DEFAULT (0), \
        area_type                   INTEGER     DEFAULT (0), \
        agency_code                 INT64       DEFAULT (0), \
        terminal_code               INT64       DEFAULT (0), \
        teller_code                 INTEGER     DEFAULT (0), \
        claiming_scope              INTEGER     NOT NULL, \
        is_train                    INTEGER     NOT NULL, \
        game_code                   INTEGER     NOT NULL, \
        issue_number                INTEGER     NOT NULL, \
        sub_type                    INTEGER     NOT NULL, \
        bet_type                    INTEGER     NOT NULL, \
        ticket_amount                INT64       NOT NULL, \
        total_bets                  INTEGER     NOT NULL, \
        bet_times                   INTEGER     NOT NULL, \
        match_count                 INTEGER     NOT NULL, \
        order_count                 INTEGER     NOT NULL, \
        bet_string                  TEXT        NOT NULL, \
        win_match_code              INTEGER     NOT NULL, \
        is_big_winning              INTEGER     NOT NULL, \
        winning_amount_tax          INT64       NOT NULL, \
        winning_amount              INT64       NOT NULL, \
        tax_amount                  INT64       NOT NULL, \
        winning_count               INTEGER     NOT NULL, \
        paid_status                 INTEGER     NOT NULL, \
        from_pay                    INTEGER     DEFAULT (0), \
        reqfn_ticket_pay            VARCHAR(24), \
        rspfn_ticket_pay            VARCHAR(24), \
        time_stamp_pay              INT64       DEFAULT (0), \
        agency_code_pay             INT64       DEFAULT (0), \
        terminal_code_pay           INT64       DEFAULT (0), \
        teller_code_pay             INTEGER     DEFAULT (0), \
        username_pay                VARCHAR(64) DEFAULT (''), \
        identity_type_pay           INTEGER     DEFAULT (0), \
        identity_number_pay         VARCHAR(64) DEFAULT (''), \
        vfyc                        BLOB        NOT NULL )";
    if (0 != db_create_table(db, sql_str))
    {
        log_error("gidb fbs create winner ticket table() failure! sql->%s", sql_str);
        return -1;
    }
    log_info("gidb fbs create winner ticket table() -> success.");

    const char *sql_order_str = "CREATE TABLE win_order_table ( \
        unique_tsn                  INT64       NOT NULL, \
        ord_no                      INTEGER     DEFAULT (0), \
        winning_amount_tax          INT64       NOT NULL, \
        winning_amount              INT64       NOT NULL, \
        tax_amount                  INT64       NOT NULL, \
        winning_count               INTEGER     NOT NULL, \
        game_code                   INTEGER     NOT NULL, \
        sub_type                    INTEGER     NOT NULL, \
        bet_type                    INTEGER     NOT NULL, \
        bet_amount                  INT64       NOT NULL, \
        bet_count                   INTEGER     NOT NULL, \
        win_match_code              INTEGER     NOT NULL, \
        match_count                 INTEGER     NOT NULL, \
        bet_match                   BLOB        NOT NULL, \
        state                       INTEGER     NOT NULL )";
    const char *sql_order_str_1 = "CREATE INDEX unique_tsn_idx ON win_order_table(unique_tsn)";
    if (0 != db_create_table(db, sql_order_str))
    {
        log_error("gidb fbs create winner order table() failure! sql->%s", sql_order_str);
        return -1;
    }
    if (0 != db_create_table_index(db, sql_order_str_1))
    {
        log_error("gidb fbs create winner order table index failure!");
        return -1;
    }
    log_info("gidb fbs create winner order table() -> success.");

    //�����ύ
    if ( db_end_transaction(db) < 0 )
    {
        log_error("db_end_transaction error.");
        return -1;
    }

    log_info("gidb fbs create winner table() -> success.");
    return 0;
}

//���н�Ʊ�Ľ�������ڴ�����
int32 gidb_fbs_wt_insert_ticket(GIDB_FBS_WT_HANDLE *self, GIDB_FBS_WT_REC *pWTicket)
{
    uint32 len = sizeof(GIDB_FBS_WT_REC);

    GIDB_FBS_WT_REC *ptr = NULL;
    ptr = (GIDB_FBS_WT_REC *)malloc(len);
    if (NULL == ptr)
    {
        log_error("malloc return failure!");
        return -1;
    }
    memcpy((char *)ptr, (char *)pWTicket, len);

    self->winTicketList.push_back(ptr);
    self->commit_flag_win = true;
    return 0;
}
//���н��Ĳ𵥵Ľ�������ڴ�����
int32 gidb_fbs_wt_insert_order(GIDB_FBS_WT_HANDLE *self, GIDB_FBS_WO_REC *pWOrder)
{
    uint32 len = sizeof(GIDB_FBS_WO_REC);

    GIDB_FBS_WO_REC *ptr = NULL;
    ptr = (GIDB_FBS_WO_REC *)malloc(len);
    if (NULL == ptr)
    {
        log_error("malloc return failure!");
        return -1;
    }
    memcpy((char *)ptr, (char *)pWOrder, len);

    self->winOrderList.push_back(ptr);
    self->commit_flag_order = true;
    //k-debug:test
    log_debug("commit order flag true");
    return 0;
}
////������Ͷע��������ȡ����Ʊ�����ڴ�����
//int32 gidb_fbs_wt_insert_return(GIDB_FBS_WT_HANDLE *self, GIDB_FBS_WT_REC *pSRTicket)
//{
//    uint32 len = sizeof(GIDB_FBS_WT_REC);
//
//    GIDB_FBS_WT_REC *ptr = NULL;
//    ptr = (GIDB_FBS_WT_REC *)malloc(len);
//    if (NULL == ptr)
//    {
//        log_error("malloc return failure!");
//        return -1;
//    }
//    memcpy((char *)ptr, (char *)pSRTicket, len);
//
//    self->singleReturnTicketList.push_back(ptr);
//    self->commit_flag_single_return = true;
//    return 0;
//}


int32 gidb_fbs_wt_sync_ticket_win(GIDB_FBS_WT_HANDLE *self)
{
    int32 rc = 0;

    if (self->commit_flag_win == false)
    {
        return 0;
    }

    const char *sql = "INSERT INTO win_ticket_table ( \
        from_sale, \
    	unique_tsn, \
        reqfn_ticket, \
        rspfn_ticket, \
        time_stamp, \
        area_code, \
        area_type, \
        agency_code, \
        terminal_code, \
        teller_code, \
        claiming_scope, \
    	is_train, \
        game_code, \
        issue_number, \
        sub_type, \
        bet_type, \
        ticket_amount, \
        total_bets, \
        bet_times, \
        match_count, \
        order_count, \
        bet_string, \
        win_match_code, \
        is_big_winning, \
        winning_amount_tax, \
        winning_amount, \
        tax_amount, \
        winning_count, \
        paid_status, \
        vfyc ) VALUES ( \
        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)";

    //�����н���ʱƱҵ��Ĳ������(Ϊ ����Ʊ ����)
    sqlite3_stmt* pStmt = NULL;
    if (sqlite3_prepare_v2(self->db, sql, strlen(sql), &pStmt, NULL) != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() insert win ticket error.");
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    static unsigned char vfyc[64];
    uint32 vfyc_len = 0;
    GIDB_FBS_WT_REC* ptr_win = NULL;
    while (!self->winTicketList.empty())
    {
        ptr_win = self->winTicketList.front();

        if (ts_calc_vfyc_fbs(WIN_TICKET_VFYC_FBS, ptr_win , vfyc, &vfyc_len) != 0)
        {
            log_error("ts_calc_vfyc_fbs() failure.");
            return -1;
        }
        bind_fbs_win_ticket(ptr_win, pStmt, vfyc, vfyc_len);

        rc = sqlite3_step(pStmt);
        if ( rc != SQLITE_DONE)
        {
            log_error("sqlite3_step() insert win ticket error. ret[%d]", rc);
            if (pStmt)
                sqlite3_finalize(pStmt);
            return -1;
        }
        sqlite3_reset(pStmt);

        free((char *)ptr_win);
        self->winTicketList.pop_front();
    }
    sqlite3_finalize(pStmt);
    return 0;
}

int32 gidb_fbs_wt_sync_ticket_order(GIDB_FBS_WT_HANDLE *self)
{
    int32 rc = 0;

    if (self->commit_flag_order == false)
    {
        return 0;
    }

    const char *sql = "INSERT INTO win_order_table ( \
    	unique_tsn, \
        ord_no, \
        winning_amount_tax, \
        winning_amount, \
        tax_amount, \
        winning_count, \
        game_code, \
        sub_type, \
        bet_type, \
        bet_amount, \
        bet_count, \
        win_match_code, \
        match_count, \
        bet_match, \
        state ) VALUES ( \
        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)";

    //�����н���ʱƱҵ��Ĳ������(Ϊ ����Ʊ ����)
    sqlite3_stmt* pStmt = NULL;
    if (sqlite3_prepare_v2(self->db, sql, strlen(sql), &pStmt, NULL) != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() insert win order table error.");
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    GIDB_FBS_WO_REC* ptr_win = NULL;
    while (!self->winOrderList.empty())
    {
        ptr_win = self->winOrderList.front();

        bind_fbs_win_order(ptr_win, pStmt);

        rc = sqlite3_step(pStmt);
        if ( rc != SQLITE_DONE)
        {
            log_error("sqlite3_step() insert win order ticket error. ret[%d]", rc);
            if (pStmt)
                sqlite3_finalize(pStmt);
            return -1;
        }
        sqlite3_reset(pStmt);

        free((char *)ptr_win);
        self->winOrderList.pop_front();
    }
    sqlite3_finalize(pStmt);
    return 0;
}

/*
//int32 gidb_fbs_wt_sync_ticket_return(GIDB_FBS_WT_HANDLE *self)
//{
//    int32 rc = 0;
//
//    if (self->commit_flag_single_return == false)
//    {
//        return 0;
//    }
//
//    const char *sql = "INSERT INTO return_ticket_table ( \
//        from_sale, \
//    	unique_tsn, \
//        reqfn_ticket, \
//        rspfn_ticket, \
//        time_stamp, \
//        area_code, \
//        area_type, \
//        agency_code, \
//        terminal_code, \
//        teller_code, \
//        claiming_scope, \
//    	is_train, \
//        game_code, \
//        issue_number, \
//        sub_type, \
//        bet_type, \
//        total_amount, \
//        total_bets, \
//        bet_times, \
//        match_count, \
//        order_count, \
//        bet_string, \
//        win_match_code, \
//        pay_status) VALUES ( \
//        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,? )";
//
//    sqlite3_stmt* pStmt = NULL;
//    if (sqlite3_prepare_v2(self->db, sql, strlen(sql), &pStmt, NULL) != SQLITE_OK)
//    {
//        log_error("sqlite3_prepare_v2() insert return ticket error.");
//        if (pStmt)
//            sqlite3_finalize(pStmt);
//        return -1;
//    }
//
//    GIDB_FBS_WT_REC* ptr_win = NULL;
//    while (!self->singleReturnTicketList.empty())
//    {
//        ptr_win = self->singleReturnTicketList.front();
//
//        bind_fbs_return_ticket(ptr_win, pStmt);
//
//        rc = sqlite3_step(pStmt);
//        if ( rc != SQLITE_DONE)
//        {
//            log_error("sqlite3_step() insert return ticket error. ret[%d]", rc);
//            if (pStmt)
//                sqlite3_finalize(pStmt);
//            return -1;
//        }
//        sqlite3_reset(pStmt);
//
//        free((char *)ptr_win);
//        self->singleReturnTicketList.pop_front();
//    }
//    sqlite3_finalize(pStmt);
//    return 0;
//}*/

//��LIST�ڴ��е��н�Ʊд�����ݿ��ļ�
int32 gidb_fbs_wt_sync_ticket(GIDB_FBS_WT_HANDLE *self)
{
    int ret = 0;

    if ( (self->commit_flag_win == false)
      && (self->commit_flag_order == false) )
      //&& (self->commit_flag_single_return == false) )
    {
        return 0;
    }

    //��ʼ���µ�����
    if ( db_begin_transaction(self->db) < 0 )
    {
        log_error("db_begin_transaction(%d, %u) error.", self->game_code, self->issue_number);
        return -1;
    }

    ret = gidb_fbs_wt_sync_ticket_win(self);
    if (ret < 0) {
    	return -1;
    }

    ret = gidb_fbs_wt_sync_ticket_order(self);
	if (ret < 0) {
		return -1;
	}

//	ret = gidb_fbs_wt_sync_ticket_return(self);
//	if (ret < 0) {
//		return -1;
//	}


    //�����ύ
    if ( db_end_transaction(self->db) < 0 )
    {
        log_error("db_end_transaction(%d, %u) error.", self->game_code, self->issue_number);
        return -1;
    }

    self->commit_flag_win = false;
    self->commit_flag_order = false;
    //self->commit_flag_single_return = false;
    self->last_time = get_now();

    return 0;
}

//���ָ�����ο������н�Ʊ����
int32 gidb_fbs_wt_clean(GIDB_FBS_WT_HANDLE *self, uint32 match_code)
{
    // ͨ�� match_code ȥƥ�� 2���н������ win_match_code �ֶΣ��������ĳһ�����ε������н�����
    const char *sql_str   = "DELETE FROM win_ticket_table WHERE win_match_code = %u";
    const char *sql_str_1 = "DELETE FROM win_order_table WHERE win_match_code = %u";
    int32 rc;
    char *zErrMsg = 0;

    static char sql[4096] = {0};
    sprintf( sql, sql_str, match_code );

    rc = sqlite3_exec(self->db, sql, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("gidb_fbs_wt_clean() win ticket -> SQL error: %s", zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }

    memset(sql, 0, sizeof(sql));
    sprintf( sql, sql_str_1, match_code );

    rc = sqlite3_exec(self->db, sql, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("gidb_fbs_wt_clean() win order -> SQL error: %s", zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }
    log_notice("gidb_fbs_wt_clean(%u, %u) -> success.", self->game_code, match_code);

    return 0;
}

//�����н�Ʊ
int32 gidb_fbs_wt_update_pay(GIDB_FBS_WT_HANDLE *self, GIDB_FBS_PT_STRUCT *pPTicket)
{
	uint32 len = sizeof(GIDB_FBS_PT_STRUCT);

	GIDB_FBS_PT_STRUCT *ptr = NULL;
    ptr = (GIDB_FBS_PT_STRUCT *)malloc(len);
    if (NULL == ptr)
    {
        log_error("malloc return failure!");
        return -1;
    }
    memcpy((char *)ptr, (char *)pPTicket, len);

    self->payTicketList.push_back(ptr);
    self->commit_flag_pay = true;

    log_notice("gidb_fbs_pt_insert_ticket push_back rspfn_ticket[%s] game[%d] issue[%llu]",
    		pPTicket->rspfn_ticket, pPTicket->gameCode, pPTicket->issueNumber);

    return 0;
}

//�����ڵ�LIST�ڴ��е�(�ҽ��ļ�¼)����д�����ݿ��ļ�
int32 gidb_fbs_wt_sync_pay_ticket(GIDB_FBS_WT_HANDLE *self)
{
    int32 rc = 0;

    if (self->commit_flag_pay == false)
    {
        return 0;
    }

    const char *sql = "UPDATE win_ticket_table SET \
        paid_status=?, from_pay=?, reqfn_ticket_pay=?, rspfn_ticket_pay=?, time_stamp_pay=?, \
        agency_code_pay=?, terminal_code_pay=?, teller_code_pay=?, username_pay=?, \
    	identity_type_pay=?, identity_number_pay=?, vfyc=? \
        WHERE unique_tsn=?";

    //�����н���ʱƱҵ��Ĳ������(Ϊ ����Ʊ ����)
    sqlite3_stmt* pStmt = NULL;
    if (sqlite3_prepare_v2(self->db, sql, strlen(sql), &pStmt, NULL) != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() update pay ticket error.");
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    static unsigned char vfyc[64];
    uint32 vfyc_len = 0;
    GIDB_FBS_PT_STRUCT* ptr_win = NULL;
    while (!self->payTicketList.empty())
    {
        ptr_win = self->payTicketList.front();

        if (ts_calc_vfyc_fbs(WIN_TICKET_VFYC_FBS, ptr_win , vfyc, &vfyc_len) != 0)
        {
            log_error("ts_calc_vfyc_fbs() failure.");
            return -1;
        }
        bind_fbs_update_pay_ticket(ptr_win, pStmt, vfyc, vfyc_len);

        rc = sqlite3_step(pStmt);
        if ( rc != SQLITE_DONE)
        {
            log_error("sqlite3_step() update pay ticket error. ret[%d]", rc);
            if (pStmt)
                sqlite3_finalize(pStmt);
            return -1;
        }
        sqlite3_reset(pStmt);

        free((char *)ptr_win);
        self->payTicketList.pop_front();
    }
    sqlite3_finalize(pStmt);

    self->commit_flag_pay = false;
    self->last_time = get_now();
	return 0;
}

//get win ticket by rspfn_ticket
int32 gidb_fbs_wt_get_ticket(GIDB_FBS_WT_HANDLE *self, uint64 unique_tsn, GIDB_FBS_WT_REC *pWTicket)
{
    int32 rc;

    const char *sql_str = "SELECT * FROM win_ticket_table WHERE unique_tsn=?";
    sqlite3_stmt* pStmt = NULL;

    rc = sqlite3_prepare_v2(self->db, sql_str, strlen(sql_str), &pStmt, NULL);
    if ( rc != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() error. [%d]", rc);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    sqlite3_bind_int64(  pStmt, 1,   unique_tsn);

    rc = sqlite3_step(pStmt);
    if (rc == SQLITE_DONE)
    {
        log_info("gidb_fbs_wt_get_ticket() return empty.");
        sqlite3_finalize(pStmt);
        return 1;
    }
    else if (rc != SQLITE_ROW)
    {
        log_error("sqlite3_step() failure! ret[%d]", rc);
        sqlite3_finalize(pStmt);
        return -1;
    }

    //��ȡ����
    if ( get_fbs_wt_rec_from_stmt(pWTicket, pStmt) < 0 )
    {
        log_error("get_fbs_wt_rec_from_stmt() failure!");
        sqlite3_finalize(pStmt);
        return -1;
    }

    sqlite3_finalize(pStmt);
    return 0;
}

//��������ֵ ���� ��ѯ���˶��ٸ�Order
int32 gidb_fbs_wt_get_ticket_sum(GIDB_FBS_WT_HANDLE *self,
                                 uint64 unique_tsn,
                                 int64 *winning_amount_tax,
                                 int64 *winning_amount,
                                 int64 *tax_amount,
                                 int32 *winning_count)
{
    int32 rc;
    int cnt = 0;

    const char *sql_str = "SELECT * FROM win_order_table WHERE unique_tsn=?";
    sqlite3_stmt* pStmt = NULL;

    rc = sqlite3_prepare_v2(self->db, sql_str, strlen(sql_str), &pStmt, NULL);
    if ( rc != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() error. [%d]", rc);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    sqlite3_bind_int64(  pStmt, 1,   unique_tsn);

    rc = sqlite3_step(pStmt);
    if (rc == SQLITE_DONE)
	{
		log_info("gidb_fbs_wt_get_ticket_sum() return empty.");
		sqlite3_finalize(pStmt);
		return 0;
	} else if (rc != SQLITE_ROW) {
		log_error("sqlite3_step() failure! ret[%d]", rc);
		sqlite3_finalize(pStmt);
		return -1;
	}
    char buffer[4096];
    GIDB_FBS_WO_REC* pWOrder = (GIDB_FBS_WO_REC*)buffer;
    while(rc == SQLITE_ROW) {
		//��ȡ����
		if ( get_fbs_wo_rec_from_stmt(pWOrder, pStmt) < 0 )
		{
			log_error("get_fbs_wo_rec_from_stmt() failure!");
			sqlite3_finalize(pStmt);
			return -1;
		}
        *winning_amount_tax += pWOrder->winningAmountWithTax;
        *winning_amount += pWOrder->winningAmount;
        *tax_amount += pWOrder->taxAmount;
        *winning_count += pWOrder->winningCount;
		cnt++;
		rc = sqlite3_step(pStmt);
    }

    sqlite3_finalize(pStmt);
    return cnt;
}


static FBS_WT_MAP  fbs_wt_map;
GIDB_FBS_WT_HANDLE *map_fbs_wt_get(uint8 game_code, uint32 issue_number)
{
    uint64 key = (((uint64)game_code)<<56) + issue_number;
    if (1 == fbs_wt_map.count(key))
    {
        return fbs_wt_map[key];
    }
    return NULL;
}

int32 map_fbs_wt_set(uint8 game_code, uint32 issue_number, GIDB_FBS_WT_HANDLE *handle)
{
    if (NULL == handle)
    {
        return -1;
    }
    uint64 key = (((uint64)game_code)<<56) + issue_number;
    fbs_wt_map[key] = handle;
    return 0;
}

GIDB_FBS_WT_HANDLE* gidb_fbs_wt_init(uint8 game_code, uint32 issue_number)
{
    int32 ret = 0;

    char game_abbr[16];
    get_game_abbr(game_code, game_abbr);
    char db_path[256];
    ts_get_fbs_issue_ticket_win_filepath(game_abbr, issue_number, db_path, 256);

    //open sqlite db connect
    sqlite3 * db = db_connect(db_path);
    if ( db == NULL )
    {
        log_error("db_connect(%s) error.", db_path);
        return NULL;
    }

    //�жϱ��Ƿ��Ѵ���
    ret = db_check_table_exist(db, "win_ticket_table");
    if ( ret < 0)
    {
        log_error("db_check_table_exist(%s) found error.", db_path);
        return NULL;
    }
    else if ( 1 == ret )
    {
        //�������ڣ�������
        if ( gidb_fbs_wt_create_table(db) < 0 )
        {
            log_error("gidb_fbs_wt_create_table(%s) error.", db_path);
            return NULL;
        }
    }

    //����map
    GIDB_FBS_WT_HANDLE * ptr = NULL;
    ptr = (GIDB_FBS_WT_HANDLE *)malloc(sizeof(GIDB_FBS_WT_HANDLE));
    memset(ptr, 0, sizeof(GIDB_FBS_WT_HANDLE));
    new(ptr)_GIDB_FBS_WT_HANDLE();

    ptr->game_code = game_code;
    ptr->issue_number = issue_number;
    ptr->last_time = get_now();
    ptr->db = db;

    //��ʼ������ָ��
    ptr->gidb_fbs_wt_insert_ticket = gidb_fbs_wt_insert_ticket;
    ptr->gidb_fbs_wt_insert_order = gidb_fbs_wt_insert_order;
    //ptr->gidb_fbs_wt_insert_return = gidb_fbs_wt_insert_return;
    ptr->gidb_fbs_wt_sync_ticket = gidb_fbs_wt_sync_ticket;
    ptr->gidb_fbs_wt_clean = gidb_fbs_wt_clean;
    ptr->gidb_fbs_wt_update_pay = gidb_fbs_wt_update_pay;
    ptr->gidb_fbs_wt_sync_pay_ticket = gidb_fbs_wt_sync_pay_ticket;
    ptr->gidb_fbs_wt_get_ticket = gidb_fbs_wt_get_ticket;
    ptr->gidb_fbs_wt_get_ticket_sum = gidb_fbs_wt_get_ticket_sum;

    map_fbs_wt_set(game_code, issue_number, ptr);

    log_debug("gidb_fbs_wt_init(%u, %u) -> success.", game_code, issue_number);
    return ptr;
}

// interface
GIDB_FBS_WT_HANDLE * gidb_fbs_wt_get_handle(uint8 game_code, uint32 issue_number)
{
    GIDB_FBS_WT_HANDLE *ptr = map_fbs_wt_get(game_code, issue_number);
    if (NULL != ptr)
    {
        ptr->last_time = get_now();
        return ptr;
    }

    ptr = gidb_fbs_wt_init(game_code, issue_number);
    if (NULL == ptr)
    {
        log_error("gidb_fbs_wt_get_handle(%u, %u) failure!", game_code, issue_number);
        return NULL;
    }
    return ptr;
}

//�ر�ָ����handle
int32 gidb_fbs_wt_close_handle(GIDB_FBS_WT_HANDLE *handle)
{
	uint64 key = (((uint64)handle->game_code)<<56) + handle->issue_number;
	FBS_WT_MAP::iterator iter = fbs_wt_map.find(key);
	fbs_wt_map.erase(iter);

    db_close(handle->db);
    free((char *)handle);
    log_debug("gidb_fbs_wt_close_handle() success!");
    return 0;
}

uint32 gidb_fbs_wt_last_clean_time = 0;
//�رճ�ʱ��δʹ�õ�handle
int gidb_fbs_wt_clean_handle()
{
	uint32 time_n = get_now();
	if ((time_n-gidb_fbs_wt_last_clean_time) <= ISSUE_HANDLE_TIMEOUT)
		return 0;

	GIDB_FBS_WT_HANDLE* handle;
	FBS_WT_MAP::iterator iter;
	//��ȫ�ı���ɾ������������Ԫ��
	for(iter = fbs_wt_map.begin(); iter!=fbs_wt_map.end();)
	{
		handle = iter->second;
		if ( (time_n-handle->last_time) > ISSUE_HANDLE_TIMEOUT )
		{
			db_close(handle->db);
			free((void *)handle);

			fbs_wt_map.erase(iter++);
		}
		else
		{
			++iter;
		}
	}
	gidb_fbs_wt_last_clean_time = time_n;

	log_notice("gidb_fbs_wt_clean_handle() success!");
    return 0;
}
//�ر����д򿪵�handle
int gidb_fbs_wt_close_all_handle()
{
	FBS_WT_MAP::iterator it;
	GIDB_FBS_WT_HANDLE* pi = NULL;
    for(it=fbs_wt_map.begin(); it!=fbs_wt_map.end();)
    {
        pi = it->second;
        db_close(pi->db);
        free((char *)pi);

        fbs_wt_map.erase(it++);
    }

    log_debug("gidb_fbs_wt_close_all_handle() success!");
    return 0;
}


#endif



//ͬ��FBS��Ϸ�������ݵ����ݿ��ļ�(���ۡ��ҽ�����Ʊ)
//tfe_update����ʹ��
int32 gidb_fbs_sync_spc_ticket()
{
    //ͬ������Ʊ����Ʊ
    GIDB_FBS_ST_HANDLE* t_handle;
    FBS_ST_MAP::iterator t_iter;
    for(t_iter = fbs_st_map.begin(); t_iter!=fbs_st_map.end();)
    {
        t_handle = t_iter->second;
        if ( t_handle->gidb_fbs_st_sync_sc_ticket(t_handle) < 0)
        {
            log_error("gidb_fbs_st_sync_sc_ticket(%d, %u) error!", t_handle->game_code, t_handle->issue_number);
            return -1;
        }
        ++t_iter;
    }

    gidb_fbs_st_clean_handle();

    //ͬ���ҽ�Ʊ
    GIDB_FBS_WT_HANDLE* w_handle;
    FBS_WT_MAP::iterator w_iter;
    for(w_iter = fbs_wt_map.begin(); w_iter!=fbs_wt_map.end();)
    {
        w_handle = w_iter->second;
        if ( w_handle->gidb_fbs_wt_sync_ticket(w_handle) < 0)
        {
            log_error("gidb_fbs_wt_sync_ticket(%d, %u) error!", w_handle->game_code, w_handle->issue_number);
            return -1;
        }
        if ( w_handle->gidb_fbs_wt_sync_pay_ticket(w_handle) < 0)
		{
			log_error("gidb_fbs_wt_sync_pay_ticket(%d, %u) error!", w_handle->game_code, w_handle->issue_number);
			return -1;
		}
        ++w_iter;
    }

    gidb_fbs_wt_clean_handle();

    return 0;
}

//FBS����������ͬ�� win order ��  win ticket
int32 gidb_fbs_wt_sync_draw_ticket()
{
    GIDB_FBS_WT_HANDLE* w_handle;
    FBS_WT_MAP::iterator w_iter;
    for(w_iter = fbs_wt_map.begin(); w_iter!=fbs_wt_map.end();)
    {
        w_handle = w_iter->second;
        if ( w_handle->gidb_fbs_wt_sync_ticket(w_handle) < 0)
        {
            log_error("gidb_fbs_wt_sync_ticket(%d, %u) error!", w_handle->game_code, w_handle->issue_number);
            return -1;
        }

        ++w_iter;
    }

    gidb_fbs_wt_clean_handle();

    return 0;
}




#if R("---GIDB fbs draw log operation function---")

uint32 sLogMsgid = 0;

//����������־��
int32 gidb_fbs_dl_create_table(sqlite3 *db)
{
    //��ʼ���µ�����
    if ( db_begin_transaction(db) < 0 )
    {
        log_error("db_begin_transaction error.");
        return -1;
    }

    //draw_log_table ��¼����������Ҫ�Ľ������ݣ���gl_draw_fbs����ɨ��ʹ�ã�gl_draw_fbs�����ɹ��󣬽���confirm����
    //msgid���������ֶΣ���ΪΨһ��ǣ�ʹ��msgid����confirm����
    const char *sql_dl_str = "CREATE TABLE draw_log_table ( \
        msgid        INTEGER PRIMARY KEY AUTOINCREMENT, \
        game_code    INTEGER NOT NULL, \
        issue_number INT64   NOT NULL, \
        match_code   INT64   NOT NULL, \
        update_time  INT64   NOT NULL, \
        msg_type     INTEGER, \
        DRAW_MSG_KEY BLOB, \
        confirm      INTEGER DEFAULT (0), \
        confirm_time INT64 )";
    if (0 != db_create_table(db, sql_dl_str))
    {
        log_error("gidb FBS create draw_log_table failure!");
        return -1;
    }

    //�����ύ
    if ( db_end_transaction(db) < 0 )
    {
        log_error("db_end_transaction error.");
        return -1;
    }

    log_info("gidb FBS create draw_log_table -> success.");
    return 0;
}

//д��һ������������־
int32 gidb_fbs_dl_append(GIDB_FBS_DL_HANDLE *self, uint32 issue_number, uint32 match_code, int32 msg_type, char *msg, int32 msg_len)
{
    int32 rc;
    const char *sql_drawcode = "INSERT INTO draw_log_table ( \
        msgid, game_code, issue_number, match_code, update_time, msg_type, DRAW_MSG_KEY ) VALUES (null,%d,%u,%u,%ld,%d,?)";

    char sql[4096] = {0};
    sprintf(sql, sql_drawcode, self->game_code, issue_number, match_code, time(NULL), msg_type);

    sqlite3_stmt* pStmt = NULL;
    rc = sqlite3_prepare_v2(self->db, sql, strlen(sql), &pStmt, NULL);
    if (rc != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() error. [%d]", rc);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    if (sqlite3_bind_blob(pStmt, 1, msg, msg_len, SQLITE_STATIC) != SQLITE_OK)
    {
        log_error("sqlite3_bind_blob() error.");
        sqlite3_finalize(pStmt);
        return -1;
    }

    rc = sqlite3_step(pStmt);
    if (rc != SQLITE_DONE)
    {
        log_error("sqlite3_step() error.");
        sqlite3_finalize(pStmt);
        return -1;
    }

    sqlite3_finalize(pStmt);

    log_notice("gidb_fbs_dl_append(%d, %u, %u, msg_type[%d]) -> success.",
    		self->game_code, issue_number, match_code, msg_type);
    return 0;
}

//��ȡ��һ���ô�������־
int32 gidb_fbs_dl_get_last(GIDB_FBS_DL_HANDLE *self, uint32 *msgid, uint8 *msg_type, char *msg, uint32 *msg_len)
{
    int32 rc;
    const char *sql_drawcode = "SELECT msgid, msg_type, DRAW_MSG_KEY FROM draw_log_table WHERE game_code=%d AND msgid>%u AND confirm=0 ORDER BY msgid LIMIT 0,1";

    char * data_ptr = NULL;
    uint32 data_len = 0;

    char sql[4096] = {0};
    sprintf(sql, sql_drawcode, self->game_code, sLogMsgid);

    sqlite3_stmt* pStmt = NULL;
    rc = sqlite3_prepare_v2(self->db, sql, strlen(sql), &pStmt, NULL);
    if ( rc != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() error. [%d]", rc);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    rc = sqlite3_step(pStmt);
    if (rc == SQLITE_DONE)
    {
        //log_info("gidb_fbs_drawlog_get_last_dl() return empty.");
        sqlite3_finalize(pStmt);
        return 1;
    }
    else if (rc != SQLITE_ROW)
    {
        log_error("sqlite3_step() failure!");
        sqlite3_finalize(pStmt);
        return -1;
    }

    *msgid = sqlite3_column_int(pStmt, 0);
    *msg_type = sqlite3_column_int(pStmt, 1);
    data_ptr = (char *)sqlite3_column_blob(pStmt, 2);
    if (data_ptr != NULL)
    {
        data_len = sqlite3_column_bytes(pStmt, 2);
        memcpy(msg, data_ptr, data_len);
        *msg_len = data_len;
    }
    else
    {
        log_error("gidb_fbs_dl_get_last(%u) msg is null!", *msgid);
        sqlite3_finalize(pStmt);
        return -1;
    }

    sqlite3_finalize(pStmt);

    //k-debug:FBS
    if (self->game_code == GAME_FBS) {
		INM_MSG_O_FBS_DRAW_INPUT_RESULT *p = (INM_MSG_O_FBS_DRAW_INPUT_RESULT*)msg;
		log_info("len:%d, type:%d,gamecode:%d,match:%d,draw:%d,len:%d",
				data_len,
				p->header.inm_header.type,
				p->gameCode,
				p->matchCode,
				p->matchResult[0],
				p->header.inm_header.length);
    }

    log_notice("gidb_fbs_dl_get_last(%d, msgid[%u] msg_type[%d]) -> success.",
        self->game_code, *msgid, *msg_type);
    return 0;
}

//ȷ��һ����־�����ɹ�
int32 gidb_fbs_dl_confirm(GIDB_FBS_DL_HANDLE *self, uint32 msgid, uint32 flag)
{
	int32 rc;
    char *zErrMsg = 0;

    char sql[4096] = {0};
    if (flag==1)
    	sprintf(sql, "UPDATE draw_log_table SET confirm=1, confirm_time=%u WHERE msgid=%u", get_now(), msgid);
    else
    	sprintf(sql, "UPDATE draw_log_table SET confirm=2, confirm_time=%u WHERE msgid=%u", get_now(), msgid);
    
    rc = sqlite3_exec(self->db, sql, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("sqlite3_exec() -> SQL error: %s", zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }

    sLogMsgid = msgid;

    log_debug("gidb_fbs_dl_confirm(%d) msgid[%u] -> success.", self->game_code, msgid);
    return 0;
}

//ȡһ����¼
int32 gidb_fbs_dl_get_rec(GIDB_FBS_DL_HANDLE *self, uint32 issue_number, uint32 match_code, int32 msg_type)
{
    const char *sql_str = "SELECT count(*) FROM draw_log_table WHERE issue_number=%u AND match_code=%u AND msg_type=%d";

    int32 rc;
    char sql[4096] = {0};
    sprintf(sql, sql_str, issue_number, match_code, msg_type);

    sqlite3_stmt* pStmt = NULL;
    rc = sqlite3_prepare_v2(self->db, sql, strlen(sql), &pStmt, NULL);
    if (rc != SQLITE_OK) {
        log_error("gidb_fbs_dl_get_rec() sqlite3_prepare_v2() error. rc[%d](issue[%u] match[%u], msg_type[%d])",
            rc, issue_number, match_code, msg_type);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }
    rc = sqlite3_step(pStmt);
    if (rc == SQLITE_DONE) {
        log_info("gidb_fbs_dl_get_rec() return empty.(issue[%u] match[%u], msg_type[%d])",
            issue_number, match_code, msg_type);
        sqlite3_finalize(pStmt);
        return 1;
    } else if (rc == SQLITE_ROW) {
        int cnt = sqlite3_column_int(pStmt, 0);
        sqlite3_finalize(pStmt);
        if (cnt > 0) {
        	log_debug("gidb_fbs_dl_get_rec() cnt[%d](issue[%u] match[%u], msg_type[%d])",
                cnt, issue_number, match_code, msg_type);
        	return 1;
        }
        return 0;
    }
    log_error("gidb_fbs_dl_get_rec() sqlite3_step() failure!(rc(%d) issue[%u] match[%u], msg_type[%d])",
        rc, issue_number, match_code, msg_type);
    sqlite3_finalize(pStmt);
    return -1;
}

GIDB_FBS_DL_HANDLE *fbs_dl_handle = NULL;

GIDB_FBS_DL_HANDLE * gidb_fbs_dl_game_init(uint8 game_code)
{
    int32 ret = 0;

    char game_abbr[16];
    get_game_abbr(game_code, game_abbr);
    char db_path[256];
    ts_get_game_dir(game_abbr, db_path, 256);
    sprintf(db_path, "%s/drawlog_%s", db_path, game_abbr);

    //open sqlite db connect
    sqlite3 * db = db_connect(db_path);
    if (db == NULL) {
        log_error("db_connect(%s) error.", db_path);
        return NULL;
    }
    //�жϱ��Ƿ��Ѵ���
    ret = db_check_table_exist(db, "draw_log_table");
    if (ret < 0) {
        log_error("db_check_table_exist(%s) found error.", db_path);
        return NULL;
    } else if (1 == ret) {
        //�������ڣ�������
        if (gidb_fbs_dl_create_table(db) < 0) {
            log_error("gidb_fbs_dl_create_table(%s) error.", db_path);
            return NULL;
        }
    }

    GIDB_FBS_DL_HANDLE * ptr = NULL;
    ptr = (GIDB_FBS_DL_HANDLE *)malloc(sizeof(GIDB_FBS_DL_HANDLE));
    memset(ptr, 0, sizeof(GIDB_FBS_DL_HANDLE));
    new(ptr)_GIDB_FBS_DL_HANDLE();

    ptr->game_code = game_code;
    ptr->db = db;
    //��ʼ������ָ��
    ptr->gidb_fbs_dl_append = gidb_fbs_dl_append;
    ptr->gidb_fbs_dl_get_last = gidb_fbs_dl_get_last;
    ptr->gidb_fbs_dl_confirm = gidb_fbs_dl_confirm;
    ptr->gidb_fbs_dl_get_rec = gidb_fbs_dl_get_rec;

    fbs_dl_handle = ptr;
    log_debug("gidb_fbs_dl_game_init(%d) -> success.", game_code);
    return ptr;
}

// interface
GIDB_FBS_DL_HANDLE * gidb_fbs_dl_get_handle(uint8 game_code)
{
    if (NULL != fbs_dl_handle) {
        return fbs_dl_handle;
    }

    fbs_dl_handle = gidb_fbs_dl_game_init(game_code);
    if (NULL == fbs_dl_handle) {
        log_error("gidb_fbs_dl_game_init(%d) failure!", game_code);
        return NULL;
    }
    return fbs_dl_handle;
}

int32 gidb_fbs_dl_close_handle(GIDB_FBS_DL_HANDLE *handle)
{
    db_close(handle->db);
    free((char *)handle);
    log_debug("gidb_fbs_dl_close_handle() success!");
    return 0;
}

//�ر����д򿪵�handle
int gidb_fbs_dl_close_all_handle()
{
    gidb_fbs_dl_close_handle(fbs_dl_handle);

    return 0;
}

#endif







#if 0
//bind  GIDB_FBS_MATCH_INFO to sqlite3_stmt  for insert
int32 bind_fbs_match(GIDB_FBS_MATCH_INFO *pMatchRec, sqlite3_stmt* pStmt)
{
    sqlite3_bind_int(   pStmt, 1,   pMatchRec->issue_number);
    sqlite3_bind_int(   pStmt, 2,   pMatchRec->match_code);
    sqlite3_bind_int(   pStmt, 3,   pMatchRec->seq);
    sqlite3_bind_int(   pStmt, 4,   pMatchRec->competition);
    sqlite3_bind_text(  pStmt, 5 ,  pMatchRec->competition_abbr, sizeof(pMatchRec->competition_abbr), SQLITE_TRANSIENT);
    sqlite3_bind_int(   pStmt, 6,   pMatchRec->round);

    sqlite3_bind_int(   pStmt, 7,   pMatchRec->home_code);
    sqlite3_bind_text(  pStmt, 8,   pMatchRec->home_term, sizeof(pMatchRec->home_term), SQLITE_TRANSIENT);
    sqlite3_bind_int(   pStmt, 9,   pMatchRec->away_code);
    sqlite3_bind_text(  pStmt, 10,  pMatchRec->away_term, sizeof(pMatchRec->away_term), SQLITE_TRANSIENT);
    sqlite3_bind_int(   pStmt, 11,  pMatchRec->date);
    sqlite3_bind_text(  pStmt, 12,  pMatchRec->venue, sizeof(pMatchRec->venue), SQLITE_TRANSIENT);
    sqlite3_bind_int64( pStmt, 13,  pMatchRec->match_time);

    sqlite3_bind_int64( pStmt, 14,  pMatchRec->result_time);
    sqlite3_bind_int64( pStmt, 15,  pMatchRec->draw_time);
    sqlite3_bind_int64( pStmt, 16,  pMatchRec->sale_time);
    sqlite3_bind_int64( pStmt, 17,  pMatchRec->close_time);
    sqlite3_bind_int(   pStmt, 18,  pMatchRec->state);

    sqlite3_bind_int(   pStmt, 19,  pMatchRec->home_handicap);
    sqlite3_bind_int(   pStmt, 20,  pMatchRec->home_handicap_point5);
    sqlite3_bind_int(   pStmt, 21,  pMatchRec->fht_win_result);
    sqlite3_bind_int(   pStmt, 22,  pMatchRec->fht_home_goals);
    sqlite3_bind_int(   pStmt, 23,  pMatchRec->fht_away_goals);

    sqlite3_bind_int(   pStmt, 24,  pMatchRec->fht_total_goals);
    sqlite3_bind_int(   pStmt, 25,  pMatchRec->sht_win_result);
    sqlite3_bind_int(   pStmt, 26,  pMatchRec->sht_home_goals);
    sqlite3_bind_int(   pStmt, 27,  pMatchRec->sht_away_goals);
    sqlite3_bind_int(   pStmt, 28,  pMatchRec->sht_total_goals);

    sqlite3_bind_int(   pStmt, 29,  pMatchRec->ft_win_result);
    sqlite3_bind_int(   pStmt, 30,  pMatchRec->ft_home_goals);
    sqlite3_bind_int(   pStmt, 31,  pMatchRec->ft_away_goals);
    sqlite3_bind_int(   pStmt, 32,  pMatchRec->ft_total_goals);
    sqlite3_bind_int(   pStmt, 33,  pMatchRec->first_goal);

    sqlite3_bind_blob(  pStmt, 34,  (char *)pMatchRec->odds_array, sizeof(pMatchRec->odds_array), SQLITE_TRANSIENT);
    sqlite3_bind_blob(  pStmt, 35,  (char *)pMatchRec->fbs_result, sizeof(pMatchRec->fbs_result), SQLITE_TRANSIENT);

    return 0;
}
#endif

//bind  GIDB_FBS_MATCH_INFO to sqlite3_stmt  for insert
int32 bind_fbs_match(GIDB_FBS_MATCH_INFO *pMatchRec, sqlite3_stmt* pStmt)
{
    sqlite3_bind_int(   pStmt, 1,   pMatchRec->issue_number);
    sqlite3_bind_int(   pStmt, 2,   pMatchRec->match_code);
    sqlite3_bind_int(   pStmt, 3,   pMatchRec->seq);

    sqlite3_bind_int(   pStmt, 4,   pMatchRec->home_code);
    sqlite3_bind_int(   pStmt, 5,   pMatchRec->away_code);
    sqlite3_bind_int64( pStmt, 6,   pMatchRec->draw_time);
    sqlite3_bind_int(   pStmt, 7,   pMatchRec->state);
    return 0;
}


//bind  GIDB_FBS_ST_REC to sqlite3_stmt  for insert
int32 bind_fbs_st_ticket(GIDB_FBS_ST_REC *pSTicket, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len)
{
    sqlite3_bind_int(   pStmt, 1,   pSTicket->from_sale);
    sqlite3_bind_int64( pStmt, 2,   pSTicket->unique_tsn);
    sqlite3_bind_text(  pStmt, 3,   pSTicket->reqfn_ticket, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_text(  pStmt, 4,   pSTicket->rspfn_ticket, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_int64( pStmt, 5,   pSTicket->time_stamp);

    sqlite3_bind_int(   pStmt, 6,   pSTicket->area_code);
    sqlite3_bind_int(   pStmt, 7,   pSTicket->area_type);
    sqlite3_bind_int64( pStmt, 8,   pSTicket->agency_code);
    sqlite3_bind_int64( pStmt, 9,   pSTicket->terminal_code);
    sqlite3_bind_int(   pStmt, 10,   pSTicket->teller_code);

    sqlite3_bind_int(   pStmt, 11,  pSTicket->claiming_scope);
    sqlite3_bind_int(   pStmt, 12,  pSTicket->is_train);
    sqlite3_bind_int(   pStmt, 13,  pSTicket->game_code);
    sqlite3_bind_int(   pStmt, 14,  pSTicket->issue_number);
    sqlite3_bind_int(   pStmt, 15,  pSTicket->sub_type);

    sqlite3_bind_int(   pStmt, 16,  pSTicket->bet_type);
    sqlite3_bind_int64( pStmt, 17,  pSTicket->total_amount);
    sqlite3_bind_int64( pStmt, 18,  pSTicket->commissionAmount);
    sqlite3_bind_int(   pStmt, 19,  pSTicket->total_bets);
    sqlite3_bind_int(   pStmt, 20,  pSTicket->bet_times);

    sqlite3_bind_int(   pStmt, 21,  pSTicket->match_count);
    sqlite3_bind_int(   pStmt, 22,  pSTicket->order_count);
    sqlite3_bind_text(  pStmt, 23,  pSTicket->bet_string, pSTicket->bet_string_len, SQLITE_TRANSIENT);
    sqlite3_bind_blob(  pStmt, 24,  (char *)&pSTicket->ticket, pSTicket->ticket.length, SQLITE_TRANSIENT);
    sqlite3_bind_int(   pStmt, 25,  pSTicket->isCancel);

    sqlite3_bind_blob(  pStmt, 26,  vfyc, vfyc_len, SQLITE_TRANSIENT);

    return 0;
}

//bind  GIDB_FBS_PT_STRUCT to sqlite3_stmt  for update pay ticket
int32 bind_fbs_update_pay_ticket(GIDB_FBS_PT_STRUCT *pPTicket, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len)
{
	sqlite3_bind_int(   pStmt, 1,   pPTicket->paid_status);
	sqlite3_bind_int(   pStmt, 2,   pPTicket->from_pay);
    sqlite3_bind_text(  pStmt, 3,   pPTicket->reqfn_ticket_pay, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_text(  pStmt, 4,   pPTicket->rspfn_ticket_pay, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_int64( pStmt, 5,   pPTicket->timeStamp_pay);

    sqlite3_bind_int64( pStmt, 6,   pPTicket->agencyCode_pay);
    sqlite3_bind_int64( pStmt, 7,   pPTicket->terminalCode_pay);
    sqlite3_bind_int(   pStmt, 8,   pPTicket->tellerCode_pay);
    sqlite3_bind_text(  pStmt, 9,   pPTicket->userName_pay, ENTRY_NAME_LEN, SQLITE_TRANSIENT);
    sqlite3_bind_int(   pStmt, 10,  pPTicket->identityType_pay);

    sqlite3_bind_text(  pStmt, 11,  pPTicket->identityNumber_pay, IDENTITY_CARD_LENGTH, SQLITE_TRANSIENT);
    sqlite3_bind_blob(  pStmt, 12,  vfyc, vfyc_len, SQLITE_TRANSIENT);
	sqlite3_bind_int64( pStmt, 13,  pPTicket->unique_tsn);

    return 0;
}

//bind  GIDB_FBS_CT_STRUCT to sqlite3_stmt  for update cancel ticket
int32 bind_fbs_update_cancel_ticket(GIDB_FBS_CT_STRUCT *pCTicket, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len)
{
    sqlite3_bind_int(   pStmt, 1,   1);
    sqlite3_bind_int(   pStmt, 2,   pCTicket->from_cancel);
    sqlite3_bind_text(  pStmt, 3,   pCTicket->reqfn_ticket_cancel, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_text(  pStmt, 4,   pCTicket->rspfn_ticket_cancel, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_int64( pStmt, 5,   pCTicket->timeStamp_cancel);

    sqlite3_bind_int64( pStmt, 6,   pCTicket->agencyCode_cancel);
    sqlite3_bind_int64( pStmt, 7,   pCTicket->terminalCode_cancel);
    sqlite3_bind_int(   pStmt, 8,   pCTicket->tellerCode_cancel);

    sqlite3_bind_blob(  pStmt, 9,  vfyc, vfyc_len, SQLITE_TRANSIENT);
    sqlite3_bind_int64( pStmt, 10,  pCTicket->unique_tsn);
    return 0;       
}

//bind  GIDB_FBS_WT_REC to sqlite3_stmt  for insert
int32 bind_fbs_win_ticket(GIDB_FBS_WT_REC *pWTicket, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len)
{
	sqlite3_bind_int(   pStmt, 1,   pWTicket->from_sale);
	sqlite3_bind_int64( pStmt, 2,   pWTicket->unique_tsn);
    sqlite3_bind_text(  pStmt, 3,   pWTicket->reqfn_ticket, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_text(  pStmt, 4,   pWTicket->rspfn_ticket, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_int64( pStmt, 5,   pWTicket->time_stamp);


    sqlite3_bind_int(   pStmt, 6,   pWTicket->area_code);
    sqlite3_bind_int(   pStmt, 7,   pWTicket->area_type);
    sqlite3_bind_int64( pStmt, 8,   pWTicket->agency_code);
    sqlite3_bind_int64( pStmt, 9,   pWTicket->terminal_code);
    sqlite3_bind_int(   pStmt, 10,  pWTicket->teller_code);

    sqlite3_bind_int(   pStmt, 11,  pWTicket->claiming_scope);
    sqlite3_bind_int(   pStmt, 12,  pWTicket->is_train);
    sqlite3_bind_int(   pStmt, 13,  pWTicket->game_code);
    sqlite3_bind_int(   pStmt, 14,  pWTicket->issue_number);
    sqlite3_bind_int(   pStmt, 15,  pWTicket->sub_type);

    sqlite3_bind_int(   pStmt, 16,  pWTicket->bet_type);
    sqlite3_bind_int64( pStmt, 17,  pWTicket->total_amount);
    sqlite3_bind_int(   pStmt, 18,  pWTicket->total_bets);
    sqlite3_bind_int(   pStmt, 19,  pWTicket->bet_times);
    sqlite3_bind_int(   pStmt, 20,  pWTicket->match_count);

    sqlite3_bind_int(   pStmt, 21,  pWTicket->order_count);
    sqlite3_bind_text(  pStmt, 22,  pWTicket->bet_string, pWTicket->bet_string_len, SQLITE_TRANSIENT);
    sqlite3_bind_int(   pStmt, 23,  pWTicket->win_match_code);
    sqlite3_bind_int(   pStmt, 24,  pWTicket->isBigWinning);
    sqlite3_bind_int64( pStmt, 25,  pWTicket->winningAmountWithTax);
    sqlite3_bind_int64( pStmt, 26,  pWTicket->winningAmount);
    sqlite3_bind_int64( pStmt, 27,  pWTicket->taxAmount);
    sqlite3_bind_int(   pStmt, 28,  pWTicket->winningCount);
    sqlite3_bind_int(   pStmt, 29,  pWTicket->paid_status);
    sqlite3_bind_blob(  pStmt, 30,  vfyc, vfyc_len, SQLITE_TRANSIENT);
    return 0;
}

//bind  GIDB_FBS_WO_REC to sqlite3_stmt  for insert
int32 bind_fbs_win_order(GIDB_FBS_WO_REC *pWOrder, sqlite3_stmt* pStmt)
{
	sqlite3_bind_int64( pStmt, 1,   pWOrder->unique_tsn);
	sqlite3_bind_int(   pStmt, 2,   pWOrder->ord_no);
	sqlite3_bind_int64( pStmt, 3,   pWOrder->winningAmountWithTax);
	sqlite3_bind_int64( pStmt, 4,   pWOrder->winningAmount);
	sqlite3_bind_int64( pStmt, 5,   pWOrder->taxAmount);
	sqlite3_bind_int(   pStmt, 6,   pWOrder->winningCount);
	sqlite3_bind_int(   pStmt, 7,   pWOrder->game_code);
    sqlite3_bind_int(   pStmt, 8,   pWOrder->sub_type);
    sqlite3_bind_int(   pStmt, 9,   pWOrder->bet_type);
    sqlite3_bind_int64( pStmt, 10,   pWOrder->bet_amount);
    sqlite3_bind_int(   pStmt, 11,   pWOrder->bet_count);
    sqlite3_bind_int(   pStmt, 12,  pWOrder->win_match_code);
    sqlite3_bind_int(   pStmt, 13,  pWOrder->match_count);
    sqlite3_bind_blob(  pStmt, 14,  pWOrder->match_array, pWOrder->match_count*sizeof(FBS_BETM), SQLITE_TRANSIENT);
    sqlite3_bind_int(   pStmt, 15,  pWOrder->state);

    return 0;
}

////bind  GIDB_FBS_WT_REC to sqlite3_stmt  for insert
//int32 bind_fbs_return_ticket(GIDB_FBS_WT_REC *pWTicket, sqlite3_stmt* pStmt)
//{
//	sqlite3_bind_int(   pStmt, 1,   pWTicket->from_sale);
//	sqlite3_bind_int64( pStmt, 2,   pWTicket->unique_tsn);
//    sqlite3_bind_text(  pStmt, 3,   pWTicket->reqfn_ticket, (TSN_LENGTH-1), SQLITE_TRANSIENT);
//    sqlite3_bind_text(  pStmt, 4,   pWTicket->rspfn_ticket, (TSN_LENGTH-1), SQLITE_TRANSIENT);
//    sqlite3_bind_int64( pStmt, 5,   pWTicket->time_stamp);
//
//
//    sqlite3_bind_int(   pStmt, 6,   pWTicket->area_code);
//    sqlite3_bind_int(   pStmt, 7,   pWTicket->area_type);
//    sqlite3_bind_int64( pStmt, 8,   pWTicket->agency_code);
//    sqlite3_bind_int64( pStmt, 9,   pWTicket->terminal_code);
//    sqlite3_bind_int(   pStmt, 10,  pWTicket->teller_code);
//
//    sqlite3_bind_int(   pStmt, 11,  pWTicket->claiming_scope);
//    sqlite3_bind_int(   pStmt, 12,  pWTicket->is_train);
//    sqlite3_bind_int(   pStmt, 13,  pWTicket->game_code);
//    sqlite3_bind_int(   pStmt, 14,  pWTicket->issue_number);
//    sqlite3_bind_int(   pStmt, 15,  pWTicket->sub_type);
//
//    sqlite3_bind_int(   pStmt, 16,  pWTicket->bet_type);
//    sqlite3_bind_int64( pStmt, 17,  pWTicket->total_amount);
//    sqlite3_bind_int(   pStmt, 18,  pWTicket->total_bets);
//    sqlite3_bind_int(   pStmt, 19,  pWTicket->bet_times);
//    sqlite3_bind_int(   pStmt, 20,  pWTicket->match_count);
//
//    sqlite3_bind_int(   pStmt, 21,  pWTicket->order_count);
//    sqlite3_bind_text(  pStmt, 22,  pWTicket->bet_string, pWTicket->bet_string_len, SQLITE_TRANSIENT);
//    sqlite3_bind_int(   pStmt, 23,  pWTicket->win_match_code);
//    sqlite3_bind_int(   pStmt, 24,  pWTicket->paid_status);
//	return 0;
//}

#if 0
//�Ӷ�����һ���������μ�¼������ GIDB_FBS_MATCH_INFO ��Ϣ
int32 get_fbs_match_rec_from_stmt(GIDB_FBS_MATCH_INFO *pMatchRec, sqlite3_stmt *pStmt)
{
    char * ptr = NULL;

    pMatchRec->match_code = sqlite3_column_int64(pStmt, 0);
    pMatchRec->seq = sqlite3_column_int(pStmt, 1);
    pMatchRec->competition = sqlite3_column_int(pStmt, 2);
    ptr = (char *)sqlite3_column_text(pStmt, 3);
    strcpy(pMatchRec->competition_abbr, ptr);
    pMatchRec->round = sqlite3_column_int(pStmt, 4);
    pMatchRec->home_code = sqlite3_column_int(pStmt, 5);
    ptr = (char *)sqlite3_column_text(pStmt, 6);
	strcpy(pMatchRec->home_term, ptr);

	pMatchRec->away_code = sqlite3_column_int(pStmt, 7);
	ptr = (char *)sqlite3_column_text(pStmt, 8);
	strcpy(pMatchRec->away_term, ptr);
	pMatchRec->date = sqlite3_column_int(pStmt, 9);
	ptr = (char *)sqlite3_column_text(pStmt, 10);
	strcpy(pMatchRec->venue, ptr);
	pMatchRec->match_time = sqlite3_column_int64(pStmt, 11);
	pMatchRec->result_time = sqlite3_column_int64(pStmt, 12);

	pMatchRec->draw_time = sqlite3_column_int64(pStmt, 13);
	pMatchRec->sale_time = sqlite3_column_int64(pStmt, 14);
	pMatchRec->close_time = sqlite3_column_int64(pStmt, 15);
	pMatchRec->state = sqlite3_column_int(pStmt, 16);
	pMatchRec->home_handicap = sqlite3_column_int(pStmt, 17);

	pMatchRec->home_handicap_point5 = sqlite3_column_int(pStmt, 18);
	pMatchRec->fht_win_result = sqlite3_column_int(pStmt, 19);
	pMatchRec->fht_home_goals = sqlite3_column_int(pStmt, 20);
	pMatchRec->fht_away_goals = sqlite3_column_int(pStmt, 21);
	pMatchRec->fht_total_goals = sqlite3_column_int(pStmt, 22);

	pMatchRec->sht_win_result = sqlite3_column_int(pStmt, 23);
	pMatchRec->sht_home_goals = sqlite3_column_int(pStmt, 24);
	pMatchRec->sht_away_goals = sqlite3_column_int(pStmt, 25);
	pMatchRec->sht_total_goals = sqlite3_column_int(pStmt, 26);
	pMatchRec->ft_win_result = sqlite3_column_int(pStmt, 27);

	pMatchRec->ft_home_goals = sqlite3_column_int(pStmt, 28);
	pMatchRec->ft_away_goals = sqlite3_column_int(pStmt, 29);
	pMatchRec->ft_total_goals = sqlite3_column_int(pStmt, 30);
	pMatchRec->first_goal = sqlite3_column_int(pStmt, 31);
    ptr = (char *)sqlite3_column_blob(pStmt, 32);
    memcpy((char *)&pMatchRec->odds_array, ptr, sizeof(M_ODDS)*FBS_SUBTYPE_NUM);

    ptr = (char *)sqlite3_column_blob(pStmt, 33);
    memcpy((char *)&pMatchRec->fbs_result, ptr, sizeof(uint8)*FBS_SUBTYPE_NUM);

	return 0;
}
#endif

//�Ӷ�����һ���������μ�¼������ GIDB_FBS_MATCH_INFO ��Ϣ
int32 get_fbs_match_rec_from_stmt(GIDB_FBS_MATCH_INFO *pMatchRec, sqlite3_stmt *pStmt)
{
    char * ptr = NULL;

    pMatchRec->issue_number = sqlite3_column_int64(pStmt, 0);
    pMatchRec->match_code = sqlite3_column_int64(pStmt, 1);
    pMatchRec->seq = sqlite3_column_int(pStmt, 2);
    pMatchRec->home_code = sqlite3_column_int(pStmt, 3);
    pMatchRec->away_code = sqlite3_column_int(pStmt, 4);
    pMatchRec->draw_time = sqlite3_column_int64(pStmt, 5);
    pMatchRec->state = sqlite3_column_int(pStmt, 6);

    return 0;
}


//�Ӷ�����һ��sale ticket����¼������ GIDB_FBS_ST_REC ��Ϣ
int32 get_fbs_st_rec_from_stmt(GIDB_FBS_ST_REC *pSTicket, sqlite3_stmt* pStmt)
{
    char *ptr = NULL;

    pSTicket->from_sale = sqlite3_column_int(pStmt, 0);

    pSTicket->unique_tsn = sqlite3_column_int64(pStmt, 1);
    ptr = (char *)sqlite3_column_text(pStmt, 2);
    strcpy(pSTicket->reqfn_ticket, ptr);
    ptr = (char *)sqlite3_column_text(pStmt, 3);
    strcpy(pSTicket->rspfn_ticket, ptr);
    pSTicket->time_stamp = sqlite3_column_int64(pStmt, 4);

    pSTicket->area_code = sqlite3_column_int(pStmt, 5);
    pSTicket->area_type = sqlite3_column_int(pStmt, 6);
    pSTicket->agency_code = sqlite3_column_int64(pStmt, 7);
    pSTicket->terminal_code = sqlite3_column_int64(pStmt, 8);
    pSTicket->teller_code = sqlite3_column_int(pStmt, 9);

    pSTicket->claiming_scope = sqlite3_column_int(pStmt, 10);
    pSTicket->is_train = sqlite3_column_int(pStmt, 11);
    pSTicket->game_code = sqlite3_column_int(pStmt, 12);
    pSTicket->issue_number = sqlite3_column_int64(pStmt, 13);
    pSTicket->sub_type = sqlite3_column_int64(pStmt, 14);

    pSTicket->bet_type = sqlite3_column_int64(pStmt, 15);
    pSTicket->total_amount = sqlite3_column_int64(pStmt, 16);
    pSTicket->commissionAmount = sqlite3_column_int64(pStmt, 17);
    pSTicket->total_bets = sqlite3_column_int(pStmt, 18);
    pSTicket->bet_times = sqlite3_column_int(pStmt, 19);

    pSTicket->match_count = sqlite3_column_int(pStmt, 20);
    pSTicket->order_count = sqlite3_column_int(pStmt, 21);
    ptr = (char *)sqlite3_column_text(pStmt, 22);
    pSTicket->bet_string_len = sqlite3_column_bytes(pStmt, 22);
    strncpy(pSTicket->bet_string, ptr, pSTicket->bet_string_len);
    ptr = (char *)sqlite3_column_blob(pStmt, 23);
    pSTicket->ticket.length = sqlite3_column_bytes(pStmt, 23);
    memcpy((char *)&pSTicket->ticket, ptr, pSTicket->ticket.length);

    pSTicket->isCancel = sqlite3_column_int(pStmt, 24);
    if(pSTicket->isCancel)
    {
        pSTicket->from_cancel = sqlite3_column_int(pStmt, 25);
        ptr = (char *)sqlite3_column_text(pStmt, 26);
        strcpy(pSTicket->reqfn_ticket_cancel, ptr);
        ptr = (char *)sqlite3_column_text(pStmt, 27);
        strcpy(pSTicket->rspfn_ticket_cancel, ptr);
        pSTicket->timeStamp_cancel = sqlite3_column_int64(pStmt, 28);
        pSTicket->agencyCode_cancel = sqlite3_column_int64(pStmt, 29);
        pSTicket->terminalCode_cancel = sqlite3_column_int64(pStmt, 30);
        pSTicket->tellerCode_cancel = sqlite3_column_int(pStmt, 31);
    }
    unsigned char *vfyc = (unsigned char *)sqlite3_column_blob(pStmt, 32);
    uint32 vfyc_len = sqlite3_column_bytes(pStmt, 32);

    if (ts_check_vfyc_fbs(SALE_TICKET_VFYC_FBS, pSTicket, vfyc, vfyc_len) != 0)
    {
        log_error("ts_check_vfyc_fbs(SALE_TICKET_VFYC_FBS) failure. rspfn_ticket->%s", pSTicket->rspfn_ticket);
        return -1;
    }
    return 0;
}

//�Ӷ�����һ��win ticket����¼������ GIDB_FBS_WT_REC ��Ϣ
int32 get_fbs_wt_rec_from_stmt(GIDB_FBS_WT_REC *pWTicket, sqlite3_stmt* pStmt)
{
    char *ptr = NULL;

    pWTicket->from_sale = sqlite3_column_int(pStmt, 0);
    pWTicket->unique_tsn = sqlite3_column_int64(pStmt, 1);
    ptr = (char *)sqlite3_column_text(pStmt, 2);
    strcpy(pWTicket->reqfn_ticket, ptr);
    ptr = (char *)sqlite3_column_text(pStmt, 3);
    strcpy(pWTicket->rspfn_ticket, ptr);
    pWTicket->time_stamp = sqlite3_column_int64(pStmt, 4);

    pWTicket->area_code = sqlite3_column_int(pStmt, 5);
    pWTicket->area_type = sqlite3_column_int(pStmt, 6);
    pWTicket->agency_code = sqlite3_column_int64(pStmt, 7);
    pWTicket->terminal_code = sqlite3_column_int64(pStmt, 8);
    pWTicket->teller_code = sqlite3_column_int(pStmt, 9);

    pWTicket->claiming_scope = sqlite3_column_int(pStmt, 10);
    pWTicket->is_train = sqlite3_column_int(pStmt, 11);
    pWTicket->game_code = sqlite3_column_int(pStmt, 12);
    pWTicket->issue_number = sqlite3_column_int64(pStmt, 13);
    pWTicket->sub_type = sqlite3_column_int64(pStmt, 14);

    pWTicket->bet_type = sqlite3_column_int64(pStmt, 15);
    pWTicket->total_amount = sqlite3_column_int64(pStmt, 16);
    pWTicket->total_bets = sqlite3_column_int(pStmt, 17);
    pWTicket->bet_times = sqlite3_column_int(pStmt, 18);
    pWTicket->match_count = sqlite3_column_int(pStmt, 19);

    pWTicket->order_count = sqlite3_column_int(pStmt, 20);
    ptr = (char *)sqlite3_column_text(pStmt, 21);
    pWTicket->bet_string_len = sqlite3_column_bytes(pStmt, 21);
    strncpy(pWTicket->bet_string, ptr, pWTicket->bet_string_len);
    pWTicket->win_match_code = sqlite3_column_int(pStmt, 22);
    pWTicket->isBigWinning = sqlite3_column_int(pStmt, 23);
    pWTicket->winningAmountWithTax = sqlite3_column_int64(pStmt, 24);

    pWTicket->winningAmount = sqlite3_column_int64(pStmt, 25);
    pWTicket->taxAmount = sqlite3_column_int64(pStmt, 26);
    pWTicket->winningCount = sqlite3_column_int(pStmt, 27);
    pWTicket->paid_status = sqlite3_column_int(pStmt, 28);

    if(pWTicket->paid_status == PRIZE_PAYMENT_PAID) {
        pWTicket->from_pay = sqlite3_column_int(pStmt, 29);
        ptr = (char *)sqlite3_column_text(pStmt, 30);
        strcpy(pWTicket->reqfn_ticket_pay, ptr);
        ptr = (char *)sqlite3_column_text(pStmt, 31);
        strcpy(pWTicket->rspfn_ticket_pay, ptr);

        pWTicket->timeStamp_pay = sqlite3_column_int64(pStmt, 32);
        pWTicket->agencyCode_pay = sqlite3_column_int64(pStmt, 33);
        pWTicket->terminalCode_pay = sqlite3_column_int64(pStmt, 34);
        pWTicket->tellerCode_pay = sqlite3_column_int(pStmt, 35);

        ptr = (char *)sqlite3_column_text(pStmt, 36);
        strcpy(pWTicket->userName_pay, ptr);

        pWTicket->identityType_pay = sqlite3_column_int(pStmt, 37);

        ptr = (char *)sqlite3_column_text(pStmt, 38);
        strcpy(pWTicket->identityNumber_pay, ptr);
    }

    unsigned char *vfyc = (unsigned char *)sqlite3_column_blob(pStmt, 39);
    uint32 vfyc_len = sqlite3_column_bytes(pStmt, 39);

    if (ts_check_vfyc_fbs(WIN_TICKET_VFYC_FBS, pWTicket, vfyc, vfyc_len) != 0)
    {
        log_error("ts_check_vfyc_fbs(SALE_TICKET_VFYC_FBS) failure. rspfn_ticket->%s", pWTicket->rspfn_ticket);
        return -1;
    }
    return 0;
}

//�Ӷ�����һ��win order����¼������ GIDB_FBS_WO_REC ��Ϣ
int32 get_fbs_wo_rec_from_stmt(GIDB_FBS_WO_REC *pWOrder, sqlite3_stmt* pStmt)
{
    pWOrder->unique_tsn = sqlite3_column_int64(pStmt, 0);
    pWOrder->ord_no = sqlite3_column_int(pStmt, 1);
    pWOrder->winningAmountWithTax = sqlite3_column_int64(pStmt, 2);
    pWOrder->winningAmount = sqlite3_column_int64(pStmt, 3);
    pWOrder->taxAmount = sqlite3_column_int64(pStmt, 4);
    pWOrder->winningCount = sqlite3_column_int(pStmt, 5);
    pWOrder->game_code = sqlite3_column_int(pStmt, 6);
    pWOrder->sub_type = sqlite3_column_int64(pStmt, 7);
    pWOrder->bet_type = sqlite3_column_int64(pStmt, 8);
    pWOrder->bet_amount = sqlite3_column_int64(pStmt, 9);
    pWOrder->bet_count = sqlite3_column_int(pStmt, 10);
    pWOrder->win_match_code = sqlite3_column_int(pStmt, 11);
    pWOrder->match_count = sqlite3_column_int(pStmt, 12);
    unsigned char *arr = (unsigned char *)sqlite3_column_blob(pStmt, 13);
    uint32 len = sqlite3_column_bytes(pStmt, 14);
    memcpy(pWOrder->match_array, arr, len);
    pWOrder->state = sqlite3_column_int(pStmt, 14);

    return 0;
}

int fbs_sale_ticket_2_win_ticket_rec(GIDB_FBS_ST_REC *pSTicket, GIDB_FBS_WT_REC *pWTicket)
{
	pWTicket->unique_tsn = pSTicket->unique_tsn;
	memcpy(pWTicket->reqfn_ticket, pSTicket->reqfn_ticket, TSN_LENGTH);
	memcpy(pWTicket->rspfn_ticket, pSTicket->rspfn_ticket, TSN_LENGTH);
	pWTicket->time_stamp = pSTicket->time_stamp;
	pWTicket->from_sale = pSTicket->from_sale;

	pWTicket->area_code = pSTicket->area_code;
	pWTicket->area_type = pSTicket->area_type;
	pWTicket->agency_code = pSTicket->agency_code;
	pWTicket->terminal_code = pSTicket->terminal_code;
	pWTicket->teller_code = pSTicket->teller_code;

	pWTicket->claiming_scope = pSTicket->claiming_scope;
	pWTicket->is_train = pSTicket->is_train;
	pWTicket->game_code = pSTicket->game_code;
	pWTicket->issue_number = pSTicket->issue_number;
	pWTicket->sub_type = pSTicket->sub_type;

	pWTicket->bet_type = pSTicket->bet_type;
	pWTicket->total_amount = pSTicket->total_amount;
	pWTicket->total_bets = pSTicket->total_bets;
	pWTicket->bet_times = pSTicket->bet_times;
	pWTicket->match_count = pSTicket->match_count;

	pWTicket->order_count = pSTicket->order_count;

	pWTicket->paid_status = PRIZE_PAYMENT_PENDING;

	pWTicket->bet_string_len = pSTicket->bet_string_len;
	memcpy(pWTicket->bet_string, pSTicket->bet_string, pSTicket->bet_string_len);

	return 0;
}

int fbs_order_rec_2_wo_rec(FBS_ORDER_REC *pOrder, GIDB_FBS_WO_REC *pWOrder, FBS_GT_GAME_PARAM *game)
{
	pWOrder->unique_tsn = pOrder->unique_tsn;
	pWOrder->ord_no = pOrder->ord_no;
	pWOrder->winningAmountWithTax = pOrder->passed_amount;
	pWOrder->winningCount = pOrder->win_bet_count;
	pWOrder->game_code = pOrder->game_code;
	pWOrder->sub_type = pOrder->sub_type;
	pWOrder->bet_type = pOrder->bet_type;
	pWOrder->bet_amount = pOrder->bet_amount;
	pWOrder->bet_count = pOrder->bet_count;
	pWOrder->win_match_code = pOrder->win_match_code;
	pWOrder->match_count = pOrder->match_count;
    pWOrder->state = pOrder->state;
	memcpy(pWOrder->match_array, pOrder->match_array, sizeof(FBS_BETM) * pOrder->match_count);

	//order ��˰
    if (pOrder->state != ORD_STATE_RETURN) {
        if (pWOrder->winningAmountWithTax >= game->taxStartAmount) {
            pWOrder->taxAmount = (pWOrder->winningAmountWithTax - game->taxStartAmount) * game->taxRate / 1000;
            pWOrder->winningAmount = pWOrder->winningAmountWithTax - pWOrder->taxAmount;
        } else {
            pWOrder->taxAmount = 0;
            pWOrder->winningAmount = pWOrder->winningAmountWithTax;
        }
    } else {
        pWOrder->taxAmount = 0;
        pWOrder->winningAmount = pWOrder->winningAmountWithTax;
    }

	return 0;
}


int32 fbs_sell_inm_rec_2_db_tidx_rec(INM_MSG_FBS_SELL_TICKET *pInmMsg, GIDB_TICKET_IDX_REC *pTIdxRec)
{
    FBS_TICKET *fbs_ticket = (FBS_TICKET *)(pInmMsg->betString+pInmMsg->betStringLen);
    FBS_BETM *bm = (FBS_BETM*)fbs_ticket->data;
    uint32 arrTmp[256] = {0};
    pTIdxRec->unique_tsn = pInmMsg->unique_tsn;
    strcpy(pTIdxRec->reqfn_ticket, pInmMsg->reqfn_ticket);
    strcpy(pTIdxRec->rspfn_ticket, pInmMsg->rspfn_ticket);
    pTIdxRec->gameCode = fbs_ticket->game_code;
    pTIdxRec->issueNumber = fbs_ticket->issue_number;
    pTIdxRec->drawIssueNumber = fbs_ticket->issue_number;
    pTIdxRec->from_sale = pInmMsg->header.inm_header.gltp_from;
    for (int i = 0; i < fbs_ticket->match_count; i++) {
    	arrTmp[i] = bm->match_code;
    	bm++;
    }

    pTIdxRec->extend_len = fbs_ticket->match_count * sizeof(uint32) + 1;
    pTIdxRec->extend[0] = fbs_ticket->match_count;
    memcpy(pTIdxRec->extend + 1, (char*)arrTmp, pTIdxRec->extend_len - 1);

    return 0;
}

int32 fbs_sell_inm_rec_2_db_ticket_rec(INM_MSG_FBS_SELL_TICKET *pInmMsg, GIDB_FBS_ST_REC *pSTicket)
{
	pSTicket->unique_tsn = pInmMsg->unique_tsn;
	strcpy(pSTicket->reqfn_ticket, pInmMsg->reqfn_ticket);
    strcpy(pSTicket->rspfn_ticket, pInmMsg->rspfn_ticket);
    pSTicket->time_stamp = pInmMsg->header.inm_header.tfe_when;
    pSTicket->from_sale = pInmMsg->header.inm_header.gltp_from;

    pSTicket->area_code = pInmMsg->header.areaCode;
    pSTicket->area_type = 0; //pInmMsg->header.areaType;  //__DEF_PIL
    pSTicket->agency_code = pInmMsg->header.agencyCode;
    pSTicket->terminal_code = pInmMsg->header.terminalCode;
    pSTicket->teller_code = pInmMsg->header.tellerCode;

    pSTicket->claiming_scope = 0; //pInmMsg->claimingScope; //__DEF_PIL
    FBS_TICKET *tkt = (FBS_TICKET*)(pInmMsg->betString + pInmMsg->betStringLen);
    pSTicket->is_train = tkt->is_train;
    pSTicket->game_code = tkt->game_code;
    pSTicket->issue_number = pInmMsg->issueNumber;
    pSTicket->sub_type = tkt->sub_type;

    pSTicket->bet_type = tkt->bet_type;
    pSTicket->total_amount = tkt->bet_amount;
    pSTicket->commissionAmount = 0; //pInmMsg->commissionAmount; //__DEF_PIL
    pSTicket->total_bets = tkt->bet_count;
    pSTicket->bet_times = tkt->bet_times;

    pSTicket->match_count = tkt->match_count;
    pSTicket->order_count = tkt->order_count;
    pSTicket->bet_string_len = pInmMsg->betStringLen;
    strncpy(pSTicket->bet_string, pInmMsg->betString, pInmMsg->betStringLen);
    pSTicket->isCancel = 0;

    //Ʊ��Ϣ
    memcpy((char *)&pSTicket->ticket, (char *)tkt, tkt->length);
    return 0;
}

int32 fbs_pay_inm_rec_2_db_ticket_rec(INM_MSG_FBS_PAY_TICKET *pInmMsg, GIDB_FBS_PT_STRUCT *pPTicket)
{
    strcpy(pPTicket->reqfn_ticket_pay, pInmMsg->reqfn_ticket_pay);
    strcpy(pPTicket->rspfn_ticket_pay, pInmMsg->rspfn_ticket_pay);

    strcpy(pPTicket->rspfn_ticket, pInmMsg->rspfn_ticket);
    pPTicket->unique_tsn = pInmMsg->unique_tsn;

    pPTicket->timeStamp_pay = pInmMsg->header.inm_header.tfe_when;

    pPTicket->from_pay = pInmMsg->header.inm_header.gltp_from;

    pPTicket->agencyCode_pay = pInmMsg->header.agencyCode;
    pPTicket->terminalCode_pay = pInmMsg->header.terminalCode;
    pPTicket->tellerCode_pay = pInmMsg->header.tellerCode;
    pPTicket->issueNumber_pay = pInmMsg->issueNumber_pay;

    //�Ҵ�ʹ�õ���Ϣ�ֶ�
    memcpy(pPTicket->userName_pay, pInmMsg->name, ENTRY_NAME_LEN);
    pPTicket->identityType_pay = pInmMsg->identityType;
    memcpy(pPTicket->identityNumber_pay, pInmMsg->identityNumber, IDENTITY_CARD_LENGTH);

    pPTicket->isTrain = pInmMsg->isTrain;

    pPTicket->gameCode = pInmMsg->gameCode;
    pPTicket->issueNumber = pInmMsg->issueNumber;
    pPTicket->ticketAmount = pInmMsg->ticketAmount;
    pPTicket->isBigWinning = pInmMsg->isBigWinning;
    pPTicket->winningAmountWithTax = pInmMsg->winningAmountWithTax;
    pPTicket->winningAmount = pInmMsg->winningAmount;
    pPTicket->taxAmount = pInmMsg->taxAmount;
    pPTicket->winningCount = pInmMsg->winningCount;
    pPTicket->paid_status = PRIZE_PAYMENT_PAID;
    return 0;
}

int32 fbs_cancel_inm_rec_2_db_ticket_rec(INM_MSG_FBS_CANCEL_TICKET *pInmMsg, GIDB_FBS_CT_STRUCT *pCTicket)
{
    strcpy(pCTicket->reqfn_ticket_cancel, pInmMsg->reqfn_ticket_cancel);
    strcpy(pCTicket->rspfn_ticket_cancel, pInmMsg->rspfn_ticket_cancel);

    strcpy(pCTicket->rspfn_ticket, pInmMsg->rspfn_ticket);
    pCTicket->unique_tsn = pInmMsg->unique_tsn;

    pCTicket->timeStamp_cancel = pInmMsg->header.inm_header.tfe_when;

    pCTicket->from_cancel = pInmMsg->header.inm_header.gltp_from;

    pCTicket->agencyCode_cancel = pInmMsg->header.agencyCode;
    pCTicket->terminalCode_cancel = pInmMsg->header.terminalCode;
    pCTicket->tellerCode_cancel = pInmMsg->header.tellerCode;
    FBS_TICKET *tkt = &pInmMsg->ticket;
    pCTicket->isTrain = tkt->is_train;
    pCTicket->cancelAmount = tkt->bet_amount;
    pCTicket->betCount = tkt->bet_count;
    memcpy((char*)&pCTicket->ticket, (char*)tkt, tkt->length);
    return 0;
}

int32 O_fbs_pay_inm_rec_2_db_ticket_rec(INM_MSG_O_FBS_PAY_TICKET *pInmMsg, GIDB_FBS_PT_STRUCT *pPTicket)
{
    strcpy(pPTicket->reqfn_ticket_pay, pInmMsg->reqfn_ticket_pay);
    strcpy(pPTicket->rspfn_ticket_pay, pInmMsg->rspfn_ticket_pay);

    strcpy(pPTicket->rspfn_ticket, pInmMsg->rspfn_ticket);
    pPTicket->unique_tsn = pInmMsg->unique_tsn;

    pPTicket->timeStamp_pay = pInmMsg->header.inm_header.tfe_when;

    pPTicket->from_pay = TICKET_FROM_OMS;

    pPTicket->agencyCode_pay = pInmMsg->areaCode_pay;
    pPTicket->terminalCode_pay = 0;
    pPTicket->tellerCode_pay = 0;
    pPTicket->issueNumber_pay = pInmMsg->issueNumber_pay;

    //�Ҵ�ʹ�õ���Ϣ�ֶ�
    memcpy(pPTicket->userName_pay, pInmMsg->name, ENTRY_NAME_LEN);
    pPTicket->identityType_pay = pInmMsg->identityType;
    memcpy(pPTicket->identityNumber_pay, pInmMsg->identityNumber, IDENTITY_CARD_LENGTH);

    pPTicket->isTrain = pInmMsg->isTrain;

    pPTicket->gameCode = pInmMsg->gameCode;
    pPTicket->issueNumber = pInmMsg->issueNumber;
    pPTicket->ticketAmount = pInmMsg->ticketAmount;
    pPTicket->isBigWinning = pInmMsg->isBigWinning;
    pPTicket->winningAmountWithTax = pInmMsg->winningAmountWithTax;
    pPTicket->winningAmount = pInmMsg->winningAmount;
    pPTicket->taxAmount = pInmMsg->taxAmount;
    pPTicket->winningCount = pInmMsg->winningCount;
    pPTicket->paid_status = PRIZE_PAYMENT_PAID;
    return 0;
}

int32 O_fbs_cancel_inm_rec_2_db_ticket_rec(INM_MSG_O_FBS_CANCEL_TICKET *pInmMsg, GIDB_FBS_CT_STRUCT *pCTicket)
{
    strcpy(pCTicket->reqfn_ticket_cancel, pInmMsg->reqfn_ticket_cancel);
    strcpy(pCTicket->rspfn_ticket_cancel, pInmMsg->rspfn_ticket_cancel);

    strcpy(pCTicket->rspfn_ticket, pInmMsg->rspfn_ticket);
    pCTicket->unique_tsn = pInmMsg->unique_tsn;

    pCTicket->timeStamp_cancel = pInmMsg->header.inm_header.tfe_when;

    pCTicket->from_cancel = TICKET_FROM_OMS;

    pCTicket->agencyCode_cancel = pInmMsg->areaCode_cancel;
    pCTicket->terminalCode_cancel = 0;
    pCTicket->tellerCode_cancel = 0;

    pCTicket->isTrain = pInmMsg->ticket.is_train;
    pCTicket->cancelAmount = pInmMsg->ticket.bet_amount;
    pCTicket->betCount = pInmMsg->ticket.bet_count;
    memcpy((char*)&pCTicket->ticket, (char*)&pInmMsg->ticket, pInmMsg->ticket.length);
    return 0;
}

int32 AP_fbs_pay_inm_rec_2_db_ticket_rec(INM_MSG_AP_PAY_TICKET *pInmMsg, GIDB_FBS_PT_STRUCT *pPTicket)
{
    strcpy(pPTicket->reqfn_ticket_pay, pInmMsg->reqfn_ticket_pay);
    strcpy(pPTicket->rspfn_ticket_pay, pInmMsg->rspfn_ticket_pay);

    strcpy(pPTicket->rspfn_ticket, pInmMsg->rspfn_ticket_sell);
    pPTicket->unique_tsn = pInmMsg->unique_tsn;

    pPTicket->timeStamp_pay = pInmMsg->header.inm_header.tfe_when;

    pPTicket->from_pay = TICKET_FROM_AP;

    pPTicket->agencyCode_pay = pInmMsg->agency_code;
    pPTicket->terminalCode_pay = 0;
    pPTicket->tellerCode_pay = 0;
    pPTicket->issueNumber_pay = 0;

    //�Ҵ�ʹ�õ���Ϣ�ֶ�


    pPTicket->isTrain = 0;

    pPTicket->gameCode = pInmMsg->game_code;
    pPTicket->issueNumber = pInmMsg->issue;
    pPTicket->ticketAmount = pInmMsg->ticketAmount;
    pPTicket->isBigWinning = 0;
    pPTicket->winningAmountWithTax = pInmMsg->winningAmountWithTax;
    pPTicket->winningAmount = pInmMsg->winningAmount;
    pPTicket->taxAmount = pInmMsg->taxAmount;
    pPTicket->winningCount = pInmMsg->winningCount;
    pPTicket->paid_status = PRIZE_PAYMENT_PAID;
    return 0;
}




//��������ļ���������
//����Ϊ2��uint32 ��ֵ (uint32 match_code �� uint32 state)  ��һ��Ϊ ���ڽ��п����ı�������  �ڶ���Ϊ �������е���һ��( 1: ��¼�뿪�����룬�����㽱  2: �㽱��ɣ��ȴ�ȷ��)
//int flag   0: ������ļ��Ƿ����  1: ��������ļ�  2: ��ȡ����ļ�  3: ɾ������ļ�
uint64 fbs_draw_tag(char *filepath, uint32 match_code, uint32 state, int flag)
{
    char buf[8] = {0};
    FILE *fp_mark = NULL;
    if (flag == 0) {
        if(access(filepath,0) == 0)
            //file exist
            return 1;
        else
            //file not exist
            return 0;
    }
    else if (flag == 1) {
        fp_mark = fopen(filepath, "wb");
        if (fp_mark == NULL) {
            log_error("fopen error. %s", filepath);
            return -1;
        }
        *(uint32*)buf = match_code;
        *(uint32*)(buf+4) = state;
        if (1 != fwrite(buf,8,1,fp_mark)) {
            log_error("fwrite error. %s", filepath);
            return -1;
        }
        fclose(fp_mark);
        return 0;
    }
    else if (flag == 2) {
        //��ȡ�ļ�����
        fp_mark = fopen(filepath, "rb");
        if (fp_mark == NULL) {
            log_error("fopen error. %s", filepath);
            return -1;
        }
        if (1 != fread(buf,8,1,fp_mark)) {
            log_error("fread error. %s", filepath);
            return -1;
        }
        fclose(fp_mark);
        return *(uint64*)buf;
    }
    else if (flag == 3) {
        if(access(filepath,0) == 0) {
            //file exist
            if (remove(filepath) != 0) {
                perrork("remove(%s) file failed. Reason:%s.", filepath, strerror(errno));
                return -1;
            }
        }
        return 0;
    } else {
        log_error("Input flag[ %u ] error.", flag);
        return -1;
    }
    return 0;
}

//meta �ļ������ӿ�
int fbs_read_draw_meta_file(char *filepath, META_ST *meta_ptr)
{
    memset((char*)meta_ptr, 0, sizeof(META_ST));
    //�ж��ļ��Ƿ����
    if(access(filepath,0) == 0) {
        //file exist

        //У��meta�ļ�
        if (0 > md5_file_verify(filepath)) {
            log_error("md5_file_verify() error. %s", filepath);
            return -1;
        }
        
        //��ȡ�ļ�����
        FILE *fp_meta = fopen(filepath, "rb");
        if (fp_meta == NULL) {
            log_error("fopen error. %s", filepath);
            return -1;
        }
        if (1 != fread(meta_ptr, sizeof(META_ST), 1, fp_meta)) {
            log_error("fread error. %s", filepath);
            return -1;
        }
        fclose(fp_meta);
    }else {
        //meta�ļ������ڣ��ٶ����ǵ�һ�α�������
        meta_ptr->last_file_offset = 0;
        meta_ptr->last_issue_number = 0;
        meta_ptr->last_unique_tsn = 0;
        meta_ptr->last_draw_sequence = 0;
        meta_ptr->last_match_code = 0;
        meta_ptr->last_draw_time = 0;

        //1:   .meta
        FILE *fp_meta = fopen(filepath, "wb");
        if (fp_meta == NULL) {
            log_error("fopen error. %s", filepath);
            return -1;
        }
        if (1 != fwrite(meta_ptr,sizeof(META_ST),1,fp_meta)) {
            log_error("fwrite error. %s", filepath);
            fclose(fp_meta);
            return -1;
        }
        fclose(fp_meta);

        //2:   .meta.md5
        //����MD5У����
        if (0 > md5_file(filepath, NULL)) {
            log_error("md5_file() error. %s", filepath);
            return -1;
        }

        //3:   .meta.bak
        //4:   .meta.bak.md5
        char filepath_bak[256] = {0};
        sprintf(filepath_bak, "%s.bak", filepath);

        int ret = copy_file_md5(filepath, filepath_bak);
        if (ret < 0) {
            log_error("copy_file_md5( %s, %s ) error.", filepath, filepath_bak);
            return -1;
        }
    }
    return 0;
}
int fbs_write_draw_meta_file(char *filepath, META_ST *meta_ptr)
{
    FILE *fp_meta = fopen(filepath, "wb");
    if (fp_meta == NULL) {
        log_error("fopen error. %s", filepath);
        return -1;
    }
    if (1 != fwrite(meta_ptr,sizeof(META_ST),1,fp_meta)){
        log_error("fwrite error. %s", filepath);
        return -1;
    }
    fclose(fp_meta);
    //����MD5У����
    if (0 > md5_file(filepath, NULL)) {
        log_error("md5_file() error. %s", filepath);
        return -1;
    }
    return 0;
}

int fbs_verify_draw_order_file(char *filepath)
{
    //�ж��ļ��Ƿ����
    if(access(filepath,0) == 0) {
        //order �ļ�����
        //У���ļ�
        if (0 > md5_file_verify(filepath)) {
            log_error("md5_file_verify() error. %s", filepath);
            return -1;
        }
    } else {
        //1:   .order
        //order �ļ�������
        FILE *fp_ord = fopen(filepath, "wb");
        if (fp_ord == NULL) {
            log_error("fopen error. %s", filepath);
            return -1;
        }
        fclose(fp_ord);
        //2:   .order.md5
        //����MD5У����
        if (0 > md5_file(filepath, NULL)) {
            log_error("md5_file() error. %s", filepath);
            return -1;
        }

        //3:   .order.bak
        //4:   .order.bak.md5
        char filepath_bak[256] = {0};
        sprintf(filepath_bak, "%s.bak", filepath);

        int ret = copy_file_md5(filepath, filepath_bak);
        if (ret < 0) {
            log_error("copy_file_md5( %s, %s ) error.", filepath, filepath_bak);
            return -1;
        }
    }
    return 0;
}

int gidb_fbs_save_game_param(uint8 game_code, uint32 issue_number)
{
	int ret = 0;
    //�����ڴο�������Ҫ������
	GIDB_FBS_ST_HANDLE *t_handle = gidb_fbs_st_get_handle(game_code, issue_number);
    if (t_handle == NULL)
    {
        log_error("gidb_fbs_st_get_handle(%d, %u) failure", game_code, issue_number);
        return -1;
    }

    //�Ȳ�ѯ
    FBS_GT_GAME_PARAM gameParam;
    int gpLen = 0;
    memset(&gameParam, 0, sizeof(FBS_GT_GAME_PARAM));

    ret = t_handle->gidb_fbs_st_get_field_blob(t_handle, FBS_ST_GAME_PARAMBLOB_KEY, (char*)&gameParam, &gpLen);
    if ( (ret < 0) || (ret == 1) ) {
        log_error("gidb_fbs_st_get_field_blob(%d, %u, FBS_ST_GAME_PARAMBLOB_KEY) failure.ret[%d]", game_code, issue_number, ret);
        return -1;
    }

    //���ڱ����������
    if (ret == 0) {
        return 0;
    }

    if (ret != 2) {
        log_error("gidb_fbs_st_get_field_blob(%d, %u, FBS_ST_GAME_PARAMBLOB_KEY) != 2.ret[%d]", game_code, issue_number, ret);
        return -1;
    }

    //��Ϸ����
    memset(&gameParam, 0, sizeof(FBS_GT_GAME_PARAM));
    GAME_DATA *game_ptr = gl_getGameData(game_code);
    gameParam.gameCode = game_ptr->gameEntry.gameCode;
    gameParam.gameType = game_ptr->gameEntry.gameType;
    memcpy(gameParam.gameAbbr, game_ptr->gameEntry.gameAbbr, 15);
    memcpy(gameParam.gameName, game_ptr->gameEntry.gameName, MAX_GAME_NAME_LENGTH);
    memcpy(gameParam.organizationName, game_ptr->gameEntry.organizationName, MAX_ORGANIZATION_NAME_LENGTH);
    gameParam.publicFundRate = game_ptr->policyParam.publicFundRate;
    gameParam.adjustmentFundRate = game_ptr->policyParam.adjustmentFundRate;
    gameParam.returnRate = game_ptr->policyParam.returnRate;
    gameParam.taxStartAmount = game_ptr->policyParam.taxStartAmount;
    gameParam.taxRate = game_ptr->policyParam.taxRate;
    gameParam.payEndDay = game_ptr->policyParam.payEndDay;
    gameParam.drawType = game_ptr->transctrlParam.drawType;
    gameParam.bigPrize = game_ptr->transctrlParam.bigPrize;
    ret = t_handle->gidb_fbs_st_set_field_blob(t_handle, FBS_ST_GAME_PARAMBLOB_KEY, (char*)&gameParam, sizeof(FBS_GT_GAME_PARAM));
    if (ret != 0)
    {
        log_error("gidb_fbs_st_set_field_blob(%d, %u, FBS_ST_GAME_PARAMBLOB_KEY) failure.", game_code, issue_number);
        return -1;
    }
    //�淨����
//    int32 len = 0;
//    char *subtype_param = (char *)(game_handle[game_code].get_subtypeTable(&len));
//    if (subtype_param == NULL)
//    {
//        log_error("get_subtypeTable(%d, %u) failure.", game_code, issue_number);
//        return -1;
//    }
//    ret = t_handle->gidb_fbs_st_set_field_blob(t_handle, FBS_ST_SUBTYPE_PARAMBLOB_KEY, subtype_param, len);
//    if (ret != 0)
//    {
//        log_error("gidb_fbs_st_set_field_blob(%d, %u, FBS_ST_SUBTYPE_PARAMBLOB_KEY) failure.", game_code, issue_number);
//        return -1;
//    }

//    //��������
//    char tmp[100] = {0};
//    POOL_PARAM *pool_param = (POOL_PARAM*)tmp;
//    pool_param->poolAmount = 11;
//    pool_param->poolName[0] = 'a';
//
//    /*POOL_PARAM *pool_param = game_plugins_handle[game_code].get_poolParam();
//    if (pool_param == NULL)
//    {
//        log_error("get_poolParam(%d, %u) failure.", game_code, issue_number);
//        return -1;
//    }*/
//    ret = t_handle->gidb_fbs_st_set_field_blob(t_handle, FBS_ST_POOL_PARAMBLOB_KEY, (char*)pool_param, sizeof(POOL_PARAM));
//    if (ret != 0)
//    {
//        log_error("gidb_fbs_st_set_field_blob(%d, %u, FBS_ST_POOL_PARAMBLOB_KEY) failure.", game_code, issue_number);
//        return -1;
//    }

    log_debug("gidb_fbs_st_set_field_blob(%d, %u, FBS_ST_GAME_PARAMBLOB_KEY) success.", game_code, issue_number);

    return 0;
}


int32 gidb_fbs_generate_match_win_file(uint8 game_code, uint32 issue_number, uint32 match_code, uint8 draw_times, char *file)
{
    int32 rc = 0;
    int ret = 0;

    struct {
        char    reqfn_ticket[24+1];
        int64   agency_code;
        char    prizeCode;
        int32   prizeCnt;
        money_t winningAmountWithTax;
        money_t winningAmount;
        money_t taxAmount;
    } tmp_win_file;
    PRIZE_DETAIL prz_detail[MAX_PRIZE_COUNT];

    GIDB_FBS_WT_HANDLE *w_handle = gidb_fbs_wt_get_handle(game_code, issue_number);
    if ( NULL == w_handle ) {
        log_error("gidb_fbs_wt_get_handle(game_code[%u] issue_num[%llu] failed.",
                  game_code, issue_number);
        return -1;
    }

    //ɾ��ԭ�е����н��ļ���MD5�ļ�
    char cmd_str[64] = {0};
    sprintf(cmd_str, "rm -rf %s", file);
    system(cmd_str);

    memset(cmd_str, 0, sizeof(cmd_str));
    sprintf(cmd_str, "rm -rf %s.md5", file);
    system(cmd_str);

    //open
    FILE *fd = fopen(file, "a+");
    if (fd == NULL)
    {
        log_error("open error:%s", file);
        return -1;
    }

    char sql[1024] = {0};
    sprintf(sql, "SELECT \
        reqfn_ticket,  \
        agency_code,  \
        winning_count,  \
        sub_type,  \
        winning_amount_tax,  \
        winning_amount,  \
        tax_amount  \
        FROM win_ticket_table \
        WHERE \
        game_code=%d AND win_match_code=%u AND is_train=0",
        game_code, match_code);

    time_t start = get_now();

    sqlite3_stmt *pStmt = NULL;
    rc = sqlite3_prepare_v2(w_handle->db, sql, strlen(sql), &pStmt, NULL);
    if ( rc != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() error. [%d]", rc);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    while(true)
    {
        rc = sqlite3_step(pStmt);
        if (rc == SQLITE_ROW)
        {
            memset(&tmp_win_file, 0, sizeof(tmp_win_file));
            memset(&prz_detail, 0, sizeof(prz_detail));
            char *reqfn = (char*)sqlite3_column_text(pStmt, 0);
            if (reqfn != NULL)
            {
                strcpy(tmp_win_file.reqfn_ticket, reqfn);
            }

            tmp_win_file.agency_code = sqlite3_column_int64(pStmt, 1);
            tmp_win_file.prizeCode = sqlite3_column_int(pStmt, 2);
            tmp_win_file.prizeCnt = sqlite3_column_int(pStmt, 3);
            tmp_win_file.winningAmountWithTax = sqlite3_column_int64(pStmt, 4);
            tmp_win_file.winningAmount = sqlite3_column_int64(pStmt, 5);
            tmp_win_file.taxAmount = sqlite3_column_int64(pStmt, 6);

            char buf[512] = {0};
            sprintf(buf, "%s%10lld%3d%16d%16lld%16lld%16lld\n",
                    tmp_win_file.reqfn_ticket,
                    tmp_win_file.agency_code,
                    tmp_win_file.prizeCode,
                    tmp_win_file.prizeCnt,
                    tmp_win_file.winningAmountWithTax,
                    tmp_win_file.winningAmount,
                    tmp_win_file.taxAmount);

            //�� *fd �в���д������
            if(EOF == fputs(buf, fd))
            {
                log_error("fputs == eof, game[%d] issue[%lld]", game_code, issue_number);
                fclose(fd);
                return -1;
            }



        }
        else if (rc == SQLITE_DONE)
        {
            break;
        }
        else
        {
            //found error
            log_error("sqlite3_step error. (%d, %llu). rc[%d]", game_code, issue_number, rc);
            if (pStmt)
                sqlite3_finalize(pStmt);
            return -1;
        }
    }

    sqlite3_finalize(pStmt);
    fclose(fd);
    time_t end = get_now();

    //����MD5�ļ�
    ret = md5_file(file, NULL);
    if (0 != ret)
    {
        log_error("gidb_fbs_generate_issue_win_file fail. md5 error");
        return -1;
    }

    log_info("gidb_fbs_generate_issue_win_file() success. time start[%ld] end[%ld] sub[%ld]",
             start, end, end - start);

    return 0;
}



