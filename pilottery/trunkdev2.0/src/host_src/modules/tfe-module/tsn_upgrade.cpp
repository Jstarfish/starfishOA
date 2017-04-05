/*
 * 2015-10-13 Kevin
 * unique tsn upgrade
 * �漰�����ݣ�
 * data/game_data,win_data,tidx_data
 * */
#include "global.h"
#include "gl_inf.h"
#include "tfe_inf.h"
#include "otl_inf.h"
#include "gfp_mod.h"
#include "gidb_mod.h"

#define MY_TASK_NAME "tsnUpgrade\0"

//unique_tsn���� ��¼
typedef struct _TSN_TICKET_REC {
    uint64     unique_tsn;                      //Ψһ���
    char       reqfn_ticket[TSN_LENGTH];        //��Ʊ������ˮ��(����)(**��Ҫȷ���ն˻���ˮ�ŵ����ɹ���  ��  ��������ˮ�ŵ����ɹ��� **)
    char       rspfn_ticket[TSN_LENGTH];        //��Ʊ������ˮ��(��Ӧ)(**ȷ���ն˻���Ӧ��ˮ�ŵ����ɹ���(��TSN)  ��  ��������ˮ�ŵ����ɹ��� **)
    uint8      gameCode;                        //��Ϸ����
    uint64     issueNumber;                     //�����ں�
    uint64     drawIssueNumber;                 //�н��ں�
    uint8      from_sale;
    uint64     old_unique_tsn;
    uint32     dt;                              //����(20151015)
} TSN_TICKET_REC;

static sqlite3 *dbTsn = NULL;

//����tsn_upgrade�м��
static int tsn_create_table(void);
static int bind_tsn_rec(TSN_TICKET_REC *pTsnRec, sqlite3_stmt *pStmt);
//�Ӷ�����һ��Ʊ������¼������ TSN_TICKET_REC ��Ϣ
static int get_tsn_rec_from_stmt(TSN_TICKET_REC *pTsnRec, sqlite3_stmt* pStmt);
//�Ӷ�����һ��Ʊ������¼������ GIDB_TICKET_IDX_REC ��Ϣ
static int get_tidx_rec_from_stmt(GIDB_TICKET_IDX_REC *pTIdxRec, sqlite3_stmt* pStmt);
static int tsn_insert_tsn_table(uint8 game_code, uint64 issue_number);
static int tsn_update_tsn_table(uint8 game_code, uint64 issue_number);
static int tsn_insert_tidx_table(uint8 game_code, uint64 issue_number);
static int tsn_update_win_table(uint8 game_code, uint64 issue_number);
static int tsn_update_sale_table(uint8 game_code, uint64 issue_number);


int main(int argc, char **argv)
{
	ts_notused(argc);
	ts_notused(argv);

	printf("Input 'Y'(Confirm Execute): ");
	char c = 0;
	scanf("%c", &c);
	if(c != 'Y') {
		return 1;
	}

    logger_init(MY_TASK_NAME);
	log_info("%s start execute, Please wait...", MY_TASK_NAME);

	int ret = 0;

	//create table tsn_upgrade
	ret = tsn_create_table();
	if (0 != ret) {
		return -1;
	}

	//get config
    char strCfg[6][20];
    memset(strCfg, 0, sizeof(strCfg));
    FILE *fp = fopen("/tmp/tsn_cfg.txt", "rb");
    if (NULL == fp)
    {
    	log_info("Open (tsn_cfg.txt) failed!");
    	return -1;
    }
    for (int i = 0; i < 6; i++) {
    	fgets(strCfg[i], sizeof(strCfg[i]), fp);
    }
    fclose(fp);

	int j = 0;
	for (int iGame = 0; iGame < 2; iGame++) {
		uint8 game_code = atoi(strCfg[j++]);
		uint64 issue_begin = atol(strCfg[j++]);
		uint64 issue_end = atol(strCfg[j++]);

		if (0 == game_code) {
		    break;
		}

		//�����N����Ϸ�����ڴ�����
		for (uint64 issue_number = issue_begin; issue_number < issue_end + 1; issue_number++) {
			log_info("=====Game[%d] Issue[%lld] step[0]",
					game_code, issue_number);
			//***insert table  tsn_upgrade***
			ret = tsn_insert_tsn_table(game_code, issue_number);
			log_info("Game[%d] Issue[%lld] ret[%d] step[1]",
					game_code, issue_number, ret);
			if (0 != ret) {
				return ret;
			}
			//***update table  tsn_upgrade***
			ret = tsn_update_tsn_table(game_code, issue_number);
			log_info("Game[%d] Issue[%lld] ret[%d] step[2]",
					game_code, issue_number, ret);
			if (0 != ret) {
				return ret;
			}

			//***insert table  tidx***
			ret = tsn_insert_tidx_table(game_code, issue_number);
			log_info("Game[%d] Issue[%lld] ret[%d] step[3]",
					game_code, issue_number, ret);
			if (0 != ret) {
				return ret;
			}

			//***update table  win***
			ret = tsn_update_win_table(game_code, issue_number);
			log_info("Game[%d] Issue[%lld] ret[%d] step[4]",
					game_code, issue_number, ret);
			if (0 != ret) {
				return ret;
			}

			//***update table  sale***
			ret = tsn_update_sale_table(game_code, issue_number);
			log_info("Game[%d] Issue[%lld] ret[%d] step[5]",
					game_code, issue_number, ret);
			if (0 != ret) {
				return ret;
			}
		}//end for(issue_number)
	}//end for(iGame)

	sqlite3_close(dbTsn);

    //gidb_t_clean_handle_timeout();
    //gidb_w_clean_handle_timeout();

    gidb_t_close_handle();
    gidb_w_close_handle();

	log_info("Finish");
	return 0;
}



//*****************************
static int tsn_create_table(void)
{
    int32 ret = 0;
    char db_path[256] = {DATA_ROOT_DIR "/tsn_upgrade.db"};

    //open sqlite db connect
    dbTsn = db_connect(db_path);
    if ( dbTsn == NULL ) {
        log_error("db_connect(%s) error.", db_path);
        return -1;
    }

    //�жϱ��Ƿ��Ѵ���
    ret = db_check_table_exist(dbTsn, "tsn_upgrade_table");
    if ( ret < 0) {
        log_error("db_check_table_exist(%s) found error.", db_path);
        return -1;
    } else if ( 1 == ret ) {
        //�����ڣ�������
        const char *sql_str = "CREATE TABLE tsn_upgrade_table ( \
        	unique_tsn                  INT64       NOT NULL UNIQUE, \
			reqfn_ticket                VARCHAR(24) NOT NULL, \
			rspfn_ticket                VARCHAR(24) NOT NULL, \
			game_code                   INTEGER     NOT NULL, \
			issue_number                INT64       NOT NULL, \
			sale_end_issue              INTEGER     NOT NULL, \
			from_sale                   INTEGER     NOT NULL, \
			old_unique_tsn              INT64       NOT NULL PRIMARY KEY, \
            dt                          INTEGER     NOT NULL, \
        	is_win                      INTEGER     DEFAULT (0) )";  //δ�н�(0) �н�(1)

        if (0 != db_create_table(dbTsn, sql_str)) {
            log_error("gidb create (tsn_upgrade_table) failure! sql->%s", sql_str);
            return -1;
        }
    } else if ( 0 == ret ) {
    	log_info("table (tsn_upgrade_table) exist");
    	//return -1;
    }

    log_info("gidb create (tsn_upgrade_table) success.");
    return 0;
}


static int bind_tsn_rec(TSN_TICKET_REC *pTsnRec, sqlite3_stmt *pStmt)
{
    sqlite3_bind_int64( pStmt, 1,   pTsnRec->unique_tsn);
    sqlite3_bind_text(  pStmt, 2,   pTsnRec->reqfn_ticket, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_text(  pStmt, 3,   pTsnRec->rspfn_ticket, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_int(   pStmt, 4,   pTsnRec->gameCode);
    sqlite3_bind_int64( pStmt, 5,   pTsnRec->issueNumber);

    sqlite3_bind_int64( pStmt, 6,   pTsnRec->drawIssueNumber);
    sqlite3_bind_int(   pStmt, 7,   pTsnRec->from_sale);
    sqlite3_bind_int64( pStmt, 8,   pTsnRec->old_unique_tsn);
    sqlite3_bind_int(   pStmt, 9,   pTsnRec->dt);

	return 0;
}


static int get_tsn_rec_from_stmt(TSN_TICKET_REC *pTsnRec, sqlite3_stmt *pStmt)
{
    char * ptr = NULL;
    char dtStr[20] = {0};
    pTsnRec->old_unique_tsn = sqlite3_column_int64(pStmt, 0);
    ptr = (char *)sqlite3_column_text(pStmt, 1);
    strcpy(pTsnRec->reqfn_ticket, ptr);
    ptr = (char *)sqlite3_column_text(pStmt, 2);
    strcpy(pTsnRec->rspfn_ticket, ptr);
    pTsnRec->gameCode = sqlite3_column_int(pStmt, 3);
    pTsnRec->issueNumber = sqlite3_column_int64(pStmt, 4);
    pTsnRec->drawIssueNumber = sqlite3_column_int64(pStmt, 5);
    pTsnRec->from_sale = sqlite3_column_int(pStmt, 6);

    int64 date = sqlite3_column_int64(pStmt, 7);
    fmt_date((TIME_TYPE*)&date, "%s%s%s", dtStr);
    pTsnRec->dt = atoi(dtStr);

    return 0;
}

//�Ӷ�����һ��Ʊ������¼������ GIDB_TICKET_IDX_REC ��Ϣ
static int get_tidx_rec_from_stmt(GIDB_TICKET_IDX_REC *pTIdxRec, sqlite3_stmt* pStmt)
{
    char * ptr = NULL;

    pTIdxRec->unique_tsn = sqlite3_column_int64(pStmt, 0);
    ptr = (char *)sqlite3_column_text(pStmt, 1);
    strcpy(pTIdxRec->reqfn_ticket, ptr);
    ptr = (char *)sqlite3_column_text(pStmt, 2);
    strcpy(pTIdxRec->rspfn_ticket, ptr);
    pTIdxRec->gameCode = sqlite3_column_int(pStmt, 3);
    pTIdxRec->issueNumber = sqlite3_column_int64(pStmt, 4);
    pTIdxRec->drawIssueNumber = sqlite3_column_int64(pStmt, 5);
    pTIdxRec->from_sale = sqlite3_column_int(pStmt, 6);
    pTIdxRec->extend_len = 0;
    pTIdxRec->extend[0] = '\0';

    return 0;
}


static int tsn_insert_tsn_table(uint8 game_code, uint64 issue_number)
{
	GIDB_T_TICKET_HANDLE *t_handle = gidb_t_get_handle(game_code, issue_number);
	if(t_handle == NULL)
	{
		log_error("gidb_t_get_handle(gameCode:%d, issue_number:%lld return null.",
				game_code, issue_number);
		return -1;
	}

	//��ѯĳ��Ϸĳ���µ�sale_ticket_table��
	//ȫ����¼������cancel, train
	const char *sql_sale_str = "SELECT \
			unique_tsn, \
			reqfn_ticket, \
			rspfn_ticket, \
			game_code, \
			issue_number, \
			sale_end_issue, \
			from_sale, \
			time_stamp \
			FROM sale_ticket_table";
	sqlite3_stmt *pStmt = NULL;
	if (sqlite3_prepare_v2(t_handle->db, sql_sale_str, strlen(sql_sale_str), &pStmt, NULL) != SQLITE_OK) {
		log_error("sqlite3_prepare_v2() error.");
		if (pStmt) {
			sqlite3_finalize(pStmt);
		}
		return -1;
	}
	//����tsn_upgrade_table��
	const char *sql_tsn_str = "INSERT INTO tsn_upgrade_table (\
			unique_tsn, \
			reqfn_ticket, \
			rspfn_ticket, \
			game_code, \
			issue_number, \
			sale_end_issue, \
			from_sale, \
			old_unique_tsn, \
			dt ) VALUES ( \
			?,?,?,?,?, ?,?,?,?)";
	sqlite3_stmt *pStmtTsn = NULL;
	if (sqlite3_prepare_v2(dbTsn, sql_tsn_str, strlen(sql_tsn_str), &pStmtTsn, NULL) != SQLITE_OK) {
		log_error("sqlite3_prepare_v2() error.");
		if (pStmtTsn) {
			sqlite3_finalize(pStmtTsn);
		}
		return -1;
	}

	char buf_sale[1024 * 16] = {0};
	char dtStr[20] = {0};
	TSN_TICKET_REC *pTsnRec = (TSN_TICKET_REC *)buf_sale;

	int fTran = 1;
	int64 idx = 0;
	//������¼����
	for (int64 iRec = 0; ; iRec++) {
		if (fTran == 1) {
			db_begin_transaction(dbTsn);
			fTran = 0;
		}
		int rc = sqlite3_step(pStmt);
		if ( rc == SQLITE_ROW ) {
			memset(buf_sale, 0, sizeof(buf_sale));
			memset(dtStr, 0, sizeof(dtStr));
			idx++;

			//Warning: ����ʵ��������sql˳����뱣��һ��
			get_tsn_rec_from_stmt(pTsnRec, pStmt);

			//convert unique_tsn
			if (0 != pTsnRec->unique_tsn / D15) { //15λ
				//new unique_tsn
				continue;
			}

			uint16 fileIdx = pTsnRec->old_unique_tsn / D10;
			uint32 fileOffset = pTsnRec->old_unique_tsn % D10;
			pTsnRec->unique_tsn = generate_digit_tsn(pTsnRec->dt, fileIdx, fileOffset);

			//insert TSN_TICKET_REC��¼
			bind_tsn_rec(pTsnRec, pStmtTsn);
			rc = sqlite3_step(pStmtTsn);
			if ( rc != SQLITE_DONE) {
				log_error("sqlite3_step() insert(tsn_upgrade_table) error. ret[%d]", rc);
				if (pStmtTsn) {
					sqlite3_finalize(pStmtTsn);
				}
				return -1;
			}

			sqlite3_reset(pStmtTsn);
		} else if( rc == SQLITE_DONE) {
			//�ɹ��������
			break;
		} else {
			log_error("sqlite3_step error. game[%d] issue[%lld]. ret[%d]",
					game_code, issue_number, rc);
			if (pStmt) {
				sqlite3_finalize(pStmt);
			}
			return -1;
		}
		if (idx > 5000) {
			db_end_transaction(dbTsn);
			fTran = 1;
			idx = 0;
		}

	}//end for(iRec)

	if (fTran == 0) {
		db_end_transaction(dbTsn);
	}

	sqlite3_finalize(pStmt);
	sqlite3_finalize(pStmtTsn);

	return 0;
}


static int tsn_update_tsn_table(uint8 game_code, uint64 issue_number)
{
    //�õ��н���Handle
	int draw_times = 1;
    GIDB_W_TICKET_HANDLE *w_handle =  gidb_w_get_handle(game_code, issue_number, draw_times);
    if (w_handle == NULL) {
        log_error("gidb_w_get_handle() failure! game[%d] issue_number[%llu]", game_code, issue_number);
        return -1;
    }

	//��ѯĳ��Ϸĳ���µ�win_ticket_table��
	//ȫ����¼������cancel, train
	const char *sql_win_str = "SELECT unique_tsn FROM win_ticket_table";
	sqlite3_stmt *pStmt = NULL;
	if (sqlite3_prepare_v2(w_handle->db, sql_win_str, strlen(sql_win_str), &pStmt, NULL) != SQLITE_OK) {
		log_error("sqlite3_prepare_v2() error.");
		if (pStmt) {
			sqlite3_finalize(pStmt);
		}
		return -1;
	}

	//����tsn_upgrade_table��
	char sql_tsn_str[256] = "UPDATE tsn_upgrade_table SET \
			is_win = 1 \
			WHERE old_unique_tsn = ?";

	sqlite3_stmt *pStmtTsn = NULL;
	if (sqlite3_prepare_v2(dbTsn, sql_tsn_str, strlen(sql_tsn_str), &pStmtTsn, NULL) != SQLITE_OK) {
		log_error("sqlite3_prepare_v2() error.");
		if (pStmtTsn) {
			sqlite3_finalize(pStmtTsn);
		}
		return -1;
	}

	int64 uniqueTsn = 0;
    int fTran = 1;
    int64 idx = 0;

	//������¼����
	for (int64 iRec = 0; ; iRec++) {
		if (fTran == 1) {
			db_begin_transaction(dbTsn);
			fTran = 0;
		}
		int rc = sqlite3_step(pStmt);
		if ( rc == SQLITE_ROW ) {
			uniqueTsn = sqlite3_column_int64(pStmt, 0);
			idx++;

			//update TSN_TICKET_REC��¼
			sqlite3_bind_int64( pStmtTsn, 1, uniqueTsn);
			rc = sqlite3_step(pStmtTsn);
			if ( rc != SQLITE_DONE) {
				log_error("sqlite3_step() insert(tsn_upgrade_table) error. ret[%d]", rc);
				if (pStmtTsn) {
					sqlite3_finalize(pStmtTsn);
				}
				return -1;
			}

			sqlite3_reset(pStmtTsn);
		} else if( rc == SQLITE_DONE) {
			//�ɹ��������
			break;
		} else {
			log_error("sqlite3_step error. game[%d] issue[%lld]. ret[%d]",
					game_code, issue_number, rc);
			if (pStmt) {
				sqlite3_finalize(pStmt);
			}
			return -1;
		}
		if (idx > 5000) {
			db_end_transaction(dbTsn);
			fTran = 1;
			idx = 0;
		}

	}//end for(iRec)

	if (fTran == 0) {
		db_end_transaction(dbTsn);
	}

	sqlite3_finalize(pStmt);
	sqlite3_finalize(pStmtTsn);

	return 0;
}


static int tsn_insert_tidx_table(uint8 game_code, uint64 issue_number)
{
	int ret = 0;
	GIDB_T_TICKET_HANDLE *t_handle = gidb_t_get_handle(game_code, issue_number);
	if(t_handle == NULL)
	{
		log_error("gidb_t_get_handle(gameCode:%d, issue_number:%lld return null.",
				game_code, issue_number);
		return -1;
	}

	//��ѯĳ��Ϸĳ���µ�sale_ticket_table��
	//ȫ����¼������cancel, train
	const char sql_str[256] = "SELECT \
			unique_tsn, \
			reqfn_ticket, \
			rspfn_ticket, \
			game_code, \
			issue_number, \
			sale_end_issue, \
			from_sale, \
			time_stamp \
			FROM sale_ticket_table";
	sqlite3_stmt *pStmt = NULL;
	if (sqlite3_prepare_v2(t_handle->db, sql_str, strlen(sql_str), &pStmt, NULL) != SQLITE_OK) {
		log_error("sqlite3_prepare_v2() error.");
		if (pStmt) {
			sqlite3_finalize(pStmt);
		}
		return -1;
	}

	static char buf_sale[1024 * 16] = {0};
	static char dtStr[20] = {0};
	GIDB_TICKET_IDX_REC *pTIdxRec = (GIDB_TICKET_IDX_REC *)buf_sale;

	int iSync = 0;
	for (int64 iRec = 0; ; iRec++) {
		int rc = sqlite3_step(pStmt);
		if ( rc == SQLITE_ROW ) {
			memset(buf_sale, 0, sizeof(buf_sale));
			memset(dtStr, 0, sizeof(dtStr));

			//warning:����ʵ��������sql˳����뱣��һ��
			get_tidx_rec_from_stmt(pTIdxRec, pStmt);

			//convert unique_tsn
			if (0 != pTIdxRec->unique_tsn / D15) { //15λ
				//new unique_tsn
				continue;
			}

			iSync++;

			uint16 fileIdx = pTIdxRec->unique_tsn / D10;
			uint32 fileOffset = pTIdxRec->unique_tsn % D10;
			int64 dt = sqlite3_column_int64(pStmt, 7);
			fmt_date((TIME_TYPE*)&dt, "%s%s%s", dtStr);
			pTIdxRec->unique_tsn = generate_digit_tsn(atoi(dtStr), fileIdx, fileOffset);

			//insert GIDB_TICKET_IDX_REC��¼
			GIDB_TICKET_IDX_HANDLE * tidx_handle = NULL;
			uint32 date = atoi(dtStr);
			tidx_handle = gidb_tidx_get_handle(date);
			if(tidx_handle == NULL)
			{
				log_error("gidb_tidx_get_handle( %u ) return null.", date);
				return -1;
			}

			ret = tidx_handle->gidb_tidx_insert_ticket(tidx_handle, pTIdxRec);
			if (ret != 0)
			{
				log_error("gidb_tidx_insert_ticket error. (unique_tsn[%llu]) ", pTIdxRec->unique_tsn);
				return -1;
			}
		} else if( rc == SQLITE_DONE) {
			//�ɹ��������
			break;
		} else {
			log_error("sqlite3_step error. game[%d] issue[%lld]. ret[%d]",
					game_code, issue_number, rc);
			if (pStmt) {
				sqlite3_finalize(pStmt);
			}
			return -1;
		}

		//sync
		if (iSync > 5000) {
			iSync = 0;

			ret = gidb_sync_tidx_ticket();
			if (0 != ret) {
				log_error("gidb_sync_tidx_ticket() failed.");
				return -1;
			}
		}

	}//end for(iRec)

	sqlite3_finalize(pStmt);

	//sync
	ret = gidb_sync_tidx_ticket();
	if (0 != ret) {
		log_error("gidb_sync_tidx_ticket() failed.");
		return -1;
	}

	return 0;
}


static int tsn_update_win_table(uint8 game_code, uint64 issue_number)
{
	char sql_tsn_str[256] = {0};
	char sql_win_str[256] = {0};
	char str[256] = "SELECT \
			unique_tsn, \
			old_unique_tsn \
			FROM tsn_upgrade_table \
			WHERE game_code = %d and issue_number = %llu and is_win = 1";
    sprintf(sql_tsn_str, str, game_code, issue_number);

	sqlite3_stmt *pStmt = NULL;
	if (sqlite3_prepare_v2(dbTsn, sql_tsn_str, strlen(sql_tsn_str), &pStmt, NULL) != SQLITE_OK) {
		log_error("sqlite3_prepare_v2() error.");
		if (pStmt) {
			sqlite3_finalize(pStmt);
		}
		return -1;
	}

    //�õ��н���Handle
	int draw_times = 1;
    GIDB_W_TICKET_HANDLE *w_handle =  gidb_w_get_handle(game_code, issue_number, draw_times);
    if (w_handle == NULL) {
        log_error("gidb_w_get_handle() failure! game[%d] issue_number[%llu]", game_code, issue_number);
        return -1;
    }

	char buf[1024 * 16] = {0};
	TSN_TICKET_REC *pTsnRec = (TSN_TICKET_REC *)buf;
	int fTran = 1;
	int64 idx = 0;

	//������¼����
	for (int64 iRec = 0; ; iRec++) {
		if (fTran == 1) {
			db_begin_transaction(w_handle->db);
			fTran = 0;
		}
		int rc = sqlite3_step(pStmt);
		if ( rc == SQLITE_ROW ) {
			memset(buf, 0, sizeof(buf));
			idx++;

			pTsnRec->unique_tsn = sqlite3_column_int64(pStmt, 0);
			pTsnRec->old_unique_tsn = sqlite3_column_int64(pStmt, 1);

			//����win_ticket_table��
			char str[256] = "UPDATE win_ticket_table SET \
					unique_tsn = %llu \
					WHERE unique_tsn = %llu";
			sprintf(sql_win_str, str, pTsnRec->unique_tsn, pTsnRec->old_unique_tsn);
		    char *zErrMsg = 0;
		    rc = sqlite3_exec(w_handle->db, sql_win_str, 0, 0, &zErrMsg);
		    if(rc != SQLITE_OK) {
		        log_error("gidb update win_ticket_table -> SQL error: %s", zErrMsg);
		        sqlite3_free(zErrMsg);
		        return -1;
		    }
		} else if( rc == SQLITE_DONE) {
			//�ɹ��������
			break;
		} else {
			log_error("sqlite3_step error. game[%d] issue[%lld]. ret[%d]",
					game_code, issue_number, rc);
			if (pStmt) {
				sqlite3_finalize(pStmt);
			}
			return -1;
		}

		if (idx > 5000) {
			db_end_transaction(w_handle->db);
			fTran = 1;
			idx = 0;
		}
	}//end for(iRec)
	if (fTran == 0) {
		db_end_transaction(w_handle->db);
	}

	sqlite3_finalize(pStmt);

	return 0;
}


static int tsn_update_sale_table(uint8 game_code, uint64 issue_number)
{
	char sql_tsn_str[256] = {0};
	char sql_sale_str[256] = {0};
	char str[256] = "SELECT \
			unique_tsn, \
			old_unique_tsn \
			FROM tsn_upgrade_table \
			WHERE game_code = %d and issue_number = %llu";
    sprintf(sql_tsn_str, str, game_code, issue_number);

	sqlite3_stmt *pStmt = NULL;
	if (sqlite3_prepare_v2(dbTsn, sql_tsn_str, strlen(sql_tsn_str), &pStmt, NULL) != SQLITE_OK) {
		log_error("sqlite3_prepare_v2() error.");
		if (pStmt) {
			sqlite3_finalize(pStmt);
		}
		return -1;
	}

    //�õ�sale��Handle
	GIDB_T_TICKET_HANDLE *t_handle = gidb_t_get_handle(game_code, issue_number);
	if(t_handle == NULL) {
		log_error("gidb_t_get_handle(gameCode:%d, issue_number:%lld return null.",
				game_code, issue_number);
		return -1;
	}

	char buf[1024 * 16] = {0};
	TSN_TICKET_REC *pTsnRec = (TSN_TICKET_REC *)buf;
	int fTran = 1;
	int64 idx = 0;

	//������¼����
	for (int64 iRec = 0; ; iRec++) {
		if (fTran == 1) {
			db_begin_transaction(t_handle->db);
			fTran = 0;
		}
		int rc = sqlite3_step(pStmt);
		if ( rc == SQLITE_ROW ) {
			memset(buf, 0, sizeof(buf));
            idx++;

			pTsnRec->unique_tsn = sqlite3_column_int64(pStmt, 0);
			pTsnRec->old_unique_tsn = sqlite3_column_int64(pStmt, 1);

			//����sale_ticket_table��
			char str[256] = "UPDATE sale_ticket_table SET \
					unique_tsn = %llu \
					WHERE unique_tsn = %llu";
			sprintf(sql_sale_str, str, pTsnRec->unique_tsn, pTsnRec->old_unique_tsn);
		    char *zErrMsg = 0;
		    rc = sqlite3_exec(t_handle->db, sql_sale_str, 0, 0, &zErrMsg);
		    if(rc != SQLITE_OK) {
		        log_error("gidb update win_ticket_table -> SQL error: %s", zErrMsg);
		        sqlite3_free(zErrMsg);
		        return -1;
		    }
		} else if( rc == SQLITE_DONE) {
			//�ɹ��������
			break;
		} else {
			log_error("sqlite3_step error. game[%d] issue[%lld]. ret[%d]",
					game_code, issue_number, rc);
			if (pStmt) {
				sqlite3_finalize(pStmt);
			}
			return -1;
		}
		if (idx > 5000) {
			db_end_transaction(t_handle->db);
			fTran = 1;
			idx = 0;
		}
	}//end for(iRec)
	if (fTran == 0) {
		db_end_transaction(t_handle->db);
	}

	sqlite3_finalize(pStmt);

	return 0;
}






