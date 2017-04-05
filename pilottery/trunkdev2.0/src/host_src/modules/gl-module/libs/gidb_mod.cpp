#include "global.h"
#include "gl_inf.h"

#include"gfp_mod.h"
#include"gidb_mod.h"
#include"otl_inf.h"


void gidb_dumpHexBuffer(char *str, int32 str_length)
{
    int linenum = 1600;
    char msgbuf[4096] = {0};

    int len = 1;  //��ǰҪ��ӡ�ĳ���
    int offset = 0;
    while (true)
    {
        if (len > str_length)
        {
            log_info("%s", msgbuf);
            break;
        }
        if (!(len%linenum))
        {
            log_info("%s", msgbuf);
            memset(msgbuf, 0, sizeof(msgbuf));
            offset = 0;
        }
        sprintf(msgbuf+offset, "%02x ", (uint8)*(str+len-1));

        offset += 3;
        len++;
    }
    //printf("\n");
    return;
}


//=============================================================================

#define GIDB_VFYC_LEN   16

#pragma pack(1)

typedef struct _SALE_CANCEL_TICKET_VFYC
{
    uint16  length;
    char    rspfn_ticket[TSN_LENGTH];
    uint8   isCancel;
    TICKET  ticket;
} SALE_CANCEL_TICKET_VFYC;

typedef struct _WIN_PAY_TICKET_VFYC
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
} WIN_PAY_TICKET_VFYC;


#pragma pack()

enum GIDB_VFYC_TYPE
{
    SALE_TICKET_VFYC_T = 1,
    WIN_TICKET_VFYC_T,
    TMP_WIN_TICKET_VFYC_T,
    PAY_TICKET_VFYC_T,
    CANCEL_TICKET_VFYC_T
};

#define KEY_MASK 0xABCD
#define KEY_VERSION_LEN 2

int calculate_vfyc(int32 type, unsigned char *key, uint32 key_len, void *data, unsigned char *vfyc, uint32 *vfyc_len)
{
    static char buffer[1024*4];
    memset(buffer, 0 ,sizeof(buffer));
    switch(type)
    {
        case SALE_TICKET_VFYC_T:
        {
            GIDB_SALE_TICKET_REC *sale_ptr = (GIDB_SALE_TICKET_REC *)data;
            SALE_CANCEL_TICKET_VFYC *sale_vfyc_ptr = (SALE_CANCEL_TICKET_VFYC *)buffer;
            sale_vfyc_ptr->length = sizeof(SALE_CANCEL_TICKET_VFYC) + sale_ptr->ticket.betStringLen + sale_ptr->ticket.betlineLen;
            strncpy(sale_vfyc_ptr->rspfn_ticket, sale_ptr->rspfn_ticket, TSN_LENGTH);
            sale_vfyc_ptr->isCancel = sale_ptr->isCancel;
            memcpy(&sale_vfyc_ptr->ticket, &sale_ptr->ticket, sale_ptr->ticket.length);
            hmac_md5(key, key_len, (const unsigned char *)buffer, sale_vfyc_ptr->length, vfyc, GIDB_VFYC_LEN);
            *vfyc_len = GIDB_VFYC_LEN;

            /*
            log_debug("SALE_TICKET_VFYC_T --- %s --->", sale_vfyc_ptr->rspfn_ticket);
            gidb_dumpHexBuffer((char*)sale_vfyc_ptr, sizeof(SALE_CANCEL_TICKET_VFYC)+ sale_ptr->ticket.betStringLen + sale_ptr->ticket.betlineLen);
            log_debug("Vfyc [%d] --->", *vfyc_len);
            gidb_dumpHexBuffer((char*)vfyc, *vfyc_len);
            log_debug("Vfyc key[%d] --->", key_len);
            gidb_dumpHexBuffer((char*)key, key_len);
            */
            break;
        }
        case WIN_TICKET_VFYC_T:
        {
            GIDB_WIN_TICKET_REC *win_ptr = (GIDB_WIN_TICKET_REC *)data;
            WIN_PAY_TICKET_VFYC *win_vfyc_ptr = (WIN_PAY_TICKET_VFYC *)buffer;
            win_vfyc_ptr->length = sizeof(WIN_PAY_TICKET_VFYC);
            strncpy(win_vfyc_ptr->rspfn_ticket, win_ptr->rspfn_ticket, TSN_LENGTH);
            win_vfyc_ptr->gameCode = win_ptr->gameCode;
            win_vfyc_ptr->issueNumber = win_ptr->issueNumber;
            win_vfyc_ptr->ticketAmount = win_ptr->ticketAmount;
            win_vfyc_ptr->isTrain = win_ptr->isTrain;
            win_vfyc_ptr->isBigWinning = win_ptr->isBigWinning;
            win_vfyc_ptr->winningAmountWithTax = win_ptr->winningAmountWithTax;
            win_vfyc_ptr->winningAmount = win_ptr->winningAmount;
            win_vfyc_ptr->taxAmount = win_ptr->taxAmount;
            win_vfyc_ptr->winningCount = win_ptr->winningCount;
            win_vfyc_ptr->paid_status = win_ptr->paid_status;
            hmac_md5(key, key_len, (const unsigned char *)buffer, win_vfyc_ptr->length, vfyc, GIDB_VFYC_LEN);
            *vfyc_len = GIDB_VFYC_LEN;

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
        case TMP_WIN_TICKET_VFYC_T:
        {
            GIDB_TMP_WIN_TICKET_REC *tmp_win_ptr = (GIDB_TMP_WIN_TICKET_REC *)data;
            WIN_PAY_TICKET_VFYC *win_vfyc_ptr = (WIN_PAY_TICKET_VFYC *)buffer;
            win_vfyc_ptr->length = sizeof(WIN_PAY_TICKET_VFYC);
            strncpy(win_vfyc_ptr->rspfn_ticket, tmp_win_ptr->rspfn_ticket, TSN_LENGTH);
            win_vfyc_ptr->gameCode = tmp_win_ptr->gameCode;
            win_vfyc_ptr->issueNumber = tmp_win_ptr->issueNumber;
            win_vfyc_ptr->ticketAmount = tmp_win_ptr->ticketAmount;
            win_vfyc_ptr->isTrain = tmp_win_ptr->isTrain;
            win_vfyc_ptr->isBigWinning = tmp_win_ptr->isBigWinning;
            win_vfyc_ptr->winningAmountWithTax = tmp_win_ptr->winningAmountWithTax;
            win_vfyc_ptr->winningAmount = tmp_win_ptr->winningAmount;
            win_vfyc_ptr->taxAmount = tmp_win_ptr->taxAmount;
            win_vfyc_ptr->winningCount = tmp_win_ptr->winningCount;
            win_vfyc_ptr->paid_status = 0;
            hmac_md5(key, key_len, (const unsigned char *)buffer, win_vfyc_ptr->length, vfyc, GIDB_VFYC_LEN);
            *vfyc_len = GIDB_VFYC_LEN;

            /*
            log_debug("TMP_WIN_TICKET_VFYC_T --- %s --->", win_vfyc_ptr->rspfn_ticket);
            gidb_dumpHexBuffer((char*)win_vfyc_ptr, sizeof(WIN_PAY_TICKET_VFYC));
            log_debug("Vfyc [%d] --->", *vfyc_len);
            gidb_dumpHexBuffer((char*)vfyc, *vfyc_len);
            log_debug("Vfyc key[%d] --->", key_len);
            gidb_dumpHexBuffer((char*)key, key_len);
            */
            break;
        }
        case PAY_TICKET_VFYC_T:
        {
            GIDB_PAY_TICKET_STRUCT *pay_ptr = (GIDB_PAY_TICKET_STRUCT *)data;
            WIN_PAY_TICKET_VFYC *win_vfyc_ptr = (WIN_PAY_TICKET_VFYC *)buffer;
            win_vfyc_ptr->length = sizeof(WIN_PAY_TICKET_VFYC);
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
            hmac_md5(key, key_len, (const unsigned char *)buffer, win_vfyc_ptr->length, vfyc, GIDB_VFYC_LEN);
            *vfyc_len = GIDB_VFYC_LEN;

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
        case CANCEL_TICKET_VFYC_T:
        {
            GIDB_CANCEL_TICKET_STRUCT *cancel_ptr = (GIDB_CANCEL_TICKET_STRUCT *)data;
            SALE_CANCEL_TICKET_VFYC *sale_vfyc_ptr = (SALE_CANCEL_TICKET_VFYC *)buffer;
            sale_vfyc_ptr->length = sizeof(SALE_CANCEL_TICKET_VFYC) + cancel_ptr->ticket.betStringLen + cancel_ptr->ticket.betlineLen;
            strncpy(sale_vfyc_ptr->rspfn_ticket, cancel_ptr->rspfn_ticket, TSN_LENGTH);
            sale_vfyc_ptr->isCancel = true;
            memcpy((char*)&sale_vfyc_ptr->ticket, (char*)&cancel_ptr->ticket, cancel_ptr->ticket.length);
            hmac_md5(key, key_len, (const unsigned char *)buffer, sale_vfyc_ptr->length, vfyc, GIDB_VFYC_LEN);
            *vfyc_len = GIDB_VFYC_LEN;

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

int ts_calc_vfyc(int32 type, void *data, unsigned char *vfyc, uint32 *vfyc_len)
{
    int key_type = 0;
    if ((SALE_TICKET_VFYC_T == type) || (CANCEL_TICKET_VFYC_T == type))
        key_type = SALE_TICKET_KEY;
    else if((WIN_TICKET_VFYC_T == type) || (TMP_WIN_TICKET_VFYC_T == type)|| (PAY_TICKET_VFYC_T == type))
        key_type = WIN_TICKET_KEY;
    else
    {
        log_error("ts_calc_vfyc(%d) type error.", type);
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
    //log_info("ts_calc_vfyc  ---- WRITE --------------------->");
    calculate_vfyc(type, key, key_len, data, vfyc, &vfyc_len_l);
    //log_info("ts_calc_vfyc ------> version[%d]", key_version);

    memcpy(vfyc+vfyc_len_l, (char*)&key_version, KEY_VERSION_LEN);
    *vfyc_len = vfyc_len_l + KEY_VERSION_LEN;
    return 0;
}

int ts_check_vfyc(int32 type, void *data, unsigned char *vfyc, uint32 vfyc_len)
{
    int key_type = 0;
    if ((SALE_TICKET_VFYC_T == type) || (CANCEL_TICKET_VFYC_T == type))
        key_type = SALE_TICKET_KEY;
    else if((WIN_TICKET_VFYC_T == type) || (TMP_WIN_TICKET_VFYC_T == type)|| (PAY_TICKET_VFYC_T == type))
        key_type = WIN_TICKET_KEY;
    else
    {
        log_error("ts_check_vfyc(%d) type error.", type);
        return -1;
    }

    //�õ�vfyc�汾��
    unsigned char *ptr = vfyc + GIDB_VFYC_LEN;
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
    //log_info("ts_check_vfyc  ---- READ --------------------->");
    //log_info("vfyc_len -> %d",  vfyc_len);
    //gidb_dumpHexBuffer((char*)vfyc, vfyc_len);
    calculate_vfyc(type, key, key_len, data, vfyc_l, &vfyc_len_l);
    //log_info("ts_check_vfyc  ---- READ ------> version[%d]", key_version);
    if (((vfyc_len-KEY_VERSION_LEN) != vfyc_len_l) || (memcmp(vfyc, vfyc_l, vfyc_len_l) != 0))
    {
        log_error("ts_check_vfyc() failure. type[%d]vfyc_len[%d]vfyc_len_l[%d]",
                  type, vfyc_len, vfyc_len_l);

        return -1;
    }
    return 0;
}


//=============================================================================


//����
int32 db_create_table(sqlite3 *db, const char *sql)
{
    int rc;
    char *zErrMsg = 0;
    rc = sqlite3_exec(db, sql, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("db_create_table error: %s",zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }
    return 0;
}

//��������
int32 db_create_table_index(sqlite3 *db, const char *sql)
{
    int rc;
    char *zErrMsg = 0;
    rc = sqlite3_exec(db, sql, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("db_create_table_index error: %s",zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }
    return 0;
}



//�ж�ָ�������ݱ��Ƿ����  1=not exist  0=exist -1=error
int32 db_check_table_exist(sqlite3 *db, const char *table_name)
{
    const char *sql_str = "SELECT COUNT(*) as CNT FROM sqlite_master where type='table' and name='%s'";

    int32 rc;
    int cnt = 0;

    char sql[4096] = {0};
    sprintf(sql, sql_str, table_name);

    sqlite3_stmt* pStmt = NULL;
    rc = sqlite3_prepare_v2(db, sql, strlen(sql), &pStmt, NULL);
    if ( rc != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() error. [%d]", rc);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    rc = sqlite3_step(pStmt);
    if (rc == SQLITE_ROW)
    {
        cnt = sqlite3_column_int(pStmt, 0);
        if ( cnt > 0)
        {
            //����
            sqlite3_finalize(pStmt);
            //log_info("db_check_table_exist(%s) return. table is exist.", table_name);
            return 0;
        }
        else
        {
            //������
            sqlite3_finalize(pStmt);
            log_info("db_check_table_exist(%s) return. table is not exist.", table_name);
            return 1;
        }
    }
    else
    {
        sqlite3_finalize(pStmt);
        log_error("sqlite3_step() failure!");
        return -1;
    }
}

//��ʼ����
int db_begin_transaction(sqlite3 *db)
{
    int rc = 0;
    char *zErrMsg = 0;
    rc = sqlite3_exec(db, "BEGIN TRANSACTION;", NULL, NULL, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("BEGIN TRANSACTION error: %s",zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }
    return 0;
}

//�ύ����
int db_end_transaction(sqlite3 *db)
{
    int rc = 0;
    char *zErrMsg = 0;
    rc = sqlite3_exec(db, "COMMIT TRANSACTION;", NULL, NULL, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("COMMIT TRANSACTION error: %s",zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }
    return 0;
}

static int sqliteBusyCallback (
    void *ptr,               // Database connection
    int count                // Number of times table has been busy
)
{
    ts_notused(ptr);
    ts_notused(count);
    ts_sleep(50 * 1000,0);
    //sqlite3OsSleep(db->pVfs, 1000);//1ms
    log_notice("found busy. sleep 50ms. retry.");
    return 1;
}

//����sqlite���ݿ� 
sqlite3 * db_connect(const char *db_file)
{
    sqlite3 *db;
    int rc;
    rc = sqlite3_open(db_file, &db);
    if(rc != SQLITE_OK)
    {
        log_error("Can't open database: %s",sqlite3_errmsg(db));
        return NULL;
    }
    sqlite3_busy_handler(db, sqliteBusyCallback, (void*)db);
    return db;
}

//�ر�sqlite���ݿ� 
int32 db_close(sqlite3 *db)
{
    sqlite3_close(db);
    return 0;
}






//=============================================================================

#if R("---GIDB_GAME_ISSUE_INTERFACE---")

//---------------------------------------------------------
// game issue operator interface
//---------------------------------------------------------

//------------------- game issue handle interface --------------------------------------------


//�����ڱ� 
int32 gidb_i_create_table(sqlite3 *db)
{
    //��ʼ���µ�����
    if ( db_begin_transaction(db) < 0 )
    {
        log_error("db_begin_transaction error.");
        return -1;
    }

    const char *sql_str = "CREATE TABLE issue_table( \
        game_code           INTEGER NOT NULL, \
        issue_number        INT64   NOT NULL PRIMARY KEY, \
        issue_serial        INTEGER NOT NULL UNIQUE, \
        estimate_start_time INT64   NOT NULL, \
        estimate_close_time INT64   NOT NULL, \
        estimate_draw_time  INT64   NOT NULL, \
        real_start_time     INT64   DEFAULT (0), \
        real_close_time     INT64   DEFAULT (0), \
        real_draw_time      INT64   DEFAULT (0), \
        real_pay_time       INT64   DEFAULT (0), \
        pay_end_day_date    INT64   NOT NULL, \
        status              INTEGER NOT NULL, \
        DRAW_CODE_KEY       TEXT    DEFAULT '', \
        DRAW_ANNOUNCE_KEY   TEXT    DEFAULT '')";

    const char *sql_str_1 = "CREATE UNIQUE INDEX issue_seq ON issue_table(issue_serial)";

    if (0 != db_create_table(db, sql_str))
    {
        log_error("gidb_i_create_table() failure!");
        return -1;
    }
    if (0 != db_create_table_index(db, sql_str_1))
    {
        log_error("gidb_i_create_table() failure!");
        return -1;
    }

    //�����ύ
    if ( db_end_transaction(db) < 0 )
    {
        log_error("db_end_transaction error.");
        return -1;
    }

    log_debug("gidb_i_create_table() -> success.");
    return 0;
}

int32 gidb_i_init_data(GIDB_ISSUE_HANDLE *self)
{
    ts_notused(self);
    //��ʼ��ʱ�����ڴ�otl���ݿ����һЩ�ڴ�
    //
    //
    //
    return 0;
}

//����һ�� 
int32 gidb_i_insert(GIDB_ISSUE_HANDLE *self, GIDB_ISSUE_INFO *p_issue_info)
{
    //REPLACE INTO
    const char *sql_str = "REPLACE INTO issue_table ( \
        game_code, \
        issue_number, \
        issue_serial, \
        estimate_start_time, \
        estimate_close_time, \
        estimate_draw_time, \
        real_start_time, \
        real_close_time, \
        real_draw_time, \
        real_pay_time, \
        pay_end_day_date, \
        status, \
        DRAW_CODE_KEY) VALUES ( \
        %d, %llu, %u, %u, %u, %u, %u, %u, %u, %u, %u, %d, \'%s\')";

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
        p_issue_info->serialNumber,
        p_issue_info->estimate_start_time,
        p_issue_info->estimate_close_time,
        p_issue_info->estimate_draw_time,
        p_issue_info->real_start_time,
        p_issue_info->real_close_time,
        p_issue_info->real_draw_time,
        p_issue_info->real_pay_time,
        p_issue_info->payEndDay,
        p_issue_info->status,
        p_issue_info->draw_code_str);

    rc = sqlite3_exec(self->db, sql, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("gidb_i_insert() -> SQL error: %s",zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }

    log_notice("gidb_i_insert(%d, %lld) -> success.", self->game_code, p_issue_info->issueNumber);
    return 0;
}

//�ڴε����� for redraw���¿���
int32 gidb_i_cleanup(GIDB_ISSUE_HANDLE *self, uint64 issue_number)
{
    const char *sql_str = "UPDATE issue_table SET status=%d, \
        real_draw_time=null, real_pay_time=null, \
        DRAW_CODE_KEY=null, \
        DRAW_ANNOUNCE_KEY=null \
        WHERE game_code=%d AND issue_number=%llu";

    int32 rc;
    char *zErrMsg = 0;

    char sql[4096] = {0};
    sprintf(sql, sql_str, ISSUE_STATE_SEALED, self->game_code, issue_number);
    
    rc = sqlite3_exec(self->db, sql, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("gidb_i_cleanup() -> SQL error: %s",zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }

    log_notice("gidb_i_cleanup(%d, %lld) -> success.", self->game_code, issue_number);
    return 0;
}

//��ȡ�ڴ���Ϣ  (by �ں�)
int32 gidb_i_get_info(GIDB_ISSUE_HANDLE *self, uint64 issue_number, GIDB_ISSUE_INFO *issue_info)
{
    const char *sql_str = "SELECT game_code, \
        issue_number, issue_serial, \
        estimate_start_time, estimate_close_time, estimate_draw_time, \
        real_start_time, real_close_time, real_draw_time, real_pay_time, \
        pay_end_day_date, \
        status, \
        DRAW_CODE_KEY \
        FROM issue_table WHERE issue_number=%llu";

    int32 rc;

    if (NULL == issue_info)
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
        log_info("gidb_i_get_info() return empty.");
        if (pStmt)
            sqlite3_finalize(pStmt);

        //�����ݿ���в�ѯ��Ȼ����뱾���ڴα�
        memset(issue_info, 0, sizeof(GIDB_ISSUE_INFO));
        if (!otl_get_issue_info(self->game_code, issue_number, issue_info))
        {
            log_error("otl_get_issue_info() error. game[%d] issue_number[%llu]", self->game_code, issue_number);
            return -1;
        }
        if(ISSUE_STATE_ISSUE_END == issue_info->status)
        {
            if (gidb_i_insert(self, issue_info) != 0)
            {
                log_error("gidb_i_insert() error. game[%d] issue_number[%llu]", self->game_code, issue_number);
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

    issue_info->gameCode = sqlite3_column_int(pStmt, 0);
    issue_info->issueNumber = sqlite3_column_int64(pStmt, 1);
    issue_info->serialNumber = sqlite3_column_int(pStmt, 2);

    issue_info->estimate_start_time = sqlite3_column_int64(pStmt, 3);
    issue_info->estimate_close_time = sqlite3_column_int64(pStmt, 4);
    issue_info->estimate_draw_time = sqlite3_column_int64(pStmt, 5);
    issue_info->real_start_time = sqlite3_column_int64(pStmt, 6);
    issue_info->real_close_time = sqlite3_column_int64(pStmt, 7);
    issue_info->real_draw_time = sqlite3_column_int64(pStmt, 8);
    issue_info->real_pay_time = sqlite3_column_int64(pStmt, 9);
    
    issue_info->payEndDay = sqlite3_column_int64(pStmt, 10);
    issue_info->status = sqlite3_column_int(pStmt, 11);
    char *t_ch = (char *)sqlite3_column_text(pStmt, 12);
    if (t_ch != NULL)
    {
        strcpy(issue_info->draw_code_str, t_ch);
    }
    else
    {
        issue_info->draw_code_str[0] = '\0';
    }

    if (issue_info->status != ISSUE_STATE_ISSUE_END)
    {
        //�����ݿ����¼���һ��
        //
        ;
    }

    sqlite3_finalize(pStmt);

    log_notice("gidb_i_get_info(%d, %llu) -> success.", self->game_code, issue_number);
    return 0;
}

//��ȡ�ڴ���Ϣ (by �ڴ����)
int32 gidb_i_get_info2(GIDB_ISSUE_HANDLE *self, uint32 issue_serial, GIDB_ISSUE_INFO *issue_info)
{
    const char *sql_str = "SELECT game_code, \
        issue_number, issue_serial, \
        estimate_start_time, estimate_close_time, estimate_draw_time, \
        real_start_time, real_close_time, real_draw_time, real_pay_time, \
        pay_end_day_date, \
        status, \
        DRAW_CODE_KEY \
        FROM issue_table WHERE issue_serial=%u";

    int32 rc;

    if (NULL == issue_info)
    {
        log_error("input issue_info is NULL.");
        return -1;
    }

    char sql[4096] = {0};
    sprintf(sql, sql_str, issue_serial);

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
        log_info("gidb_i_get_info2() return empty.");
        if (pStmt)
            sqlite3_finalize(pStmt);

        //�����ݿ���в�ѯ��Ȼ����뱾���ڴα�
        memset(issue_info, 0, sizeof(GIDB_ISSUE_INFO));
        if (!otl_get_issue_info2(self->game_code, issue_serial, issue_info))
        {
            log_error("otl_get_issue_info2() error. game[%d] issue_serial[%u]", self->game_code, issue_serial);
            return -1;
        }
        if(ISSUE_STATE_PRESALE <= issue_info->status)
        {
            if (gidb_i_insert(self, issue_info) != 0)
            {
                log_error("gidb_i_insert() error. game[%d] issue_serial[%u]", self->game_code, issue_serial);
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

    issue_info->gameCode = sqlite3_column_int(pStmt, 0);
    issue_info->issueNumber = sqlite3_column_int64(pStmt, 1);
    issue_info->serialNumber = sqlite3_column_int(pStmt, 2);

    issue_info->estimate_start_time = sqlite3_column_int64(pStmt, 3);
    issue_info->estimate_close_time = sqlite3_column_int64(pStmt, 4);
    issue_info->estimate_draw_time = sqlite3_column_int64(pStmt, 5);
    issue_info->real_start_time = sqlite3_column_int64(pStmt, 6);
    issue_info->real_close_time = sqlite3_column_int64(pStmt, 7);
    issue_info->real_draw_time = sqlite3_column_int64(pStmt, 8);
    issue_info->real_pay_time = sqlite3_column_int64(pStmt, 9);
    
    issue_info->payEndDay = sqlite3_column_int64(pStmt, 10);
    issue_info->status = sqlite3_column_int(pStmt, 11);
    char *t_ch = (char *)sqlite3_column_text(pStmt, 12);
    if (t_ch != NULL)
    {
        strcpy(issue_info->draw_code_str, t_ch);
    }
    else
    {
        issue_info->draw_code_str[0] = '\0';
    }

    sqlite3_finalize(pStmt);

    log_notice("gidb_i_get_info2(%d, %u) -> success.", self->game_code, issue_serial);
    return 0;
}

//������״̬
int32 gidb_i_set_status(GIDB_ISSUE_HANDLE *self, uint64 issue_number, uint8 issue_status, uint32 real_time)
{
    const char *sql_str = "UPDATE issue_table SET status=%d WHERE issue_number=%llu";
    const char *sql_str_1 = "UPDATE issue_table SET status=%d, %s=%ld WHERE issue_number=%llu";

    int32 rc;
    char *zErrMsg = 0;

    char sql[4096] = {0};
    char fiels_str[64] = {0};
    if (ISSUE_STATE_OPENED == issue_status)
    {
        strcpy(fiels_str, "real_start_time");
    }
    else if (ISSUE_STATE_CLOSED == issue_status)
    {
        strcpy(fiels_str, "real_close_time");
    }
    else if (ISSUE_STATE_DRAWNUM_INPUTED == issue_status)
    {
        strcpy(fiels_str, "real_draw_time");
    }
    else if (ISSUE_STATE_ISSUE_END == issue_status)
    {
        strcpy(fiels_str, "real_pay_time");
    }

    if (strlen(fiels_str) == 0)
        sprintf(sql, sql_str, issue_status, issue_number);
    else
        sprintf(sql, sql_str_1, issue_status, fiels_str, real_time, issue_number);
    
    rc = sqlite3_exec(self->db, sql, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("gidb_i_set_status(%d) -> SQL error: %s", issue_status, zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }

    log_debug("gidb_i_set_status(%d, %lld, status[%d]) -> success.", self->game_code, issue_number, issue_status);
    return 0;
}
int32 gidb_i_get_status(GIDB_ISSUE_HANDLE *self, uint64 issue_number, uint8 *issue_status)
{
    const char *sql_str = "SELECT status FROM issue_table WHERE issue_number=%llu";

    int32 rc;

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
        log_info("gidb_i_get_status() return empty.");
        sqlite3_finalize(pStmt);
        return 1;
    }
    else if (rc != SQLITE_ROW)
    {
        log_error("sqlite3_step() failure!");
        sqlite3_finalize(pStmt);
        return -1;
    }

    *issue_status = sqlite3_column_int(pStmt, 0);
    
    sqlite3_finalize(pStmt);

    log_notice("gidb_i_get_status(%d, %llu, status[%d]) -> success.", self->game_code, issue_number, *issue_status);
    return 0;
}

static const char *I_FIELD_TEXT_NAME[] =  {
    "NONE",
    "DRAW_CODE_KEY",
    "DRAW_ANNOUNCE_KEY"
};

//�����ڱ��ַ����ֶ�����
int32 gidb_i_set_field_text(GIDB_ISSUE_HANDLE *self, uint64 issue_number, ISSUE_FIELD_TEXT_KEY field_type, char *str)
{
    int32 rc;
    const char *sql_field_data = "UPDATE issue_table SET %s=? WHERE issue_number=%llu";

    char sql[4096] = {0};
    sprintf(sql, sql_field_data, I_FIELD_TEXT_NAME[field_type], issue_number);

    sqlite3_stmt* pStmt = NULL;
    rc = sqlite3_prepare_v2(self->db, sql, strlen(sql), &pStmt, NULL);
    if ( rc != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() error. [%d]", rc);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    if ( sqlite3_bind_text(pStmt, 1, str, strlen(str), SQLITE_STATIC) != SQLITE_OK)
    {
        log_error("sqlite3_bind_text() error.");
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

    log_debug("gidb_i_set_field_text(%d, %llu, fieldType[%d]) -> success.", self->game_code, issue_number, field_type);
    return 0;
}

//�����ڱ��ַ����ֶ�����
//����ֵ: С��0=����  0=�ɹ����ؽ��  1=û���ҵ���ѯ�ļ�¼  2=��ѯ���ֶ�Ϊ��
int32 gidb_i_get_field_text(GIDB_ISSUE_HANDLE *self, uint64 issue_number, ISSUE_FIELD_TEXT_KEY field_type, char *str)
{
    int32 rc;
    const char *sql_field_data = "SELECT %s FROM issue_table WHERE issue_number=%llu";

    char * data_ptr = NULL;

    char sql[4096] = {0};
    sprintf(sql, sql_field_data, I_FIELD_TEXT_NAME[field_type], issue_number);

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
        log_info("gidb_i_get_field_text() return empty.");
        sqlite3_finalize(pStmt);
        return 1;
    }
    else if (rc != SQLITE_ROW)
    {
        log_error("sqlite3_step() failure!");
        sqlite3_finalize(pStmt);
        return -1;
    }

    data_ptr = (char *)sqlite3_column_text(pStmt, 0);
    if (data_ptr != NULL)
    {
        strcpy(str, data_ptr);
    }
    else
    {
        str[0] = '\0';
        log_info("gidb_i_get_field_text() return empty. field data is NULL.");
        sqlite3_finalize(pStmt);
        return 2;
    }

    sqlite3_finalize(pStmt);

    log_notice("gidb_i_get_field_text(%d, %llu, fieldType[%d]) -> success.", self->game_code, issue_number, field_type);
    return 0;
}




//-----------------------------------------------------------------------------------------------------

//��Ϸmap
static GAME_ISSUE_MAP  game_issue_map;

GIDB_ISSUE_HANDLE *map_i_get(uint8 game_code)
{
    if (1 == game_issue_map.count(game_code))
    {
        return game_issue_map[game_code];
    }
    return NULL;
}

int32 map_i_set(uint8 game_code, GIDB_ISSUE_HANDLE *ptr)
{
    if (NULL == ptr)
    {
        return -1;
    }
    game_issue_map[game_code] = ptr;
    return 0;
}


GIDB_ISSUE_HANDLE * gidb_i_game_init(uint8 game_code)
{
    int32 ret = 0;

    char game_abbr[16];
    get_game_abbr(game_code, game_abbr);
    char db_path[256];
    ts_get_mem_game_filepath(game_abbr, db_path, 256);

    //open sqlite db connect
    sqlite3 * db = db_connect(db_path);
    if (  db == NULL )
    {
        log_error("db_connect(%s) error.", db_path);
        return NULL;
    }

    //�жϱ��Ƿ��Ѵ���
    ret = db_check_table_exist(db, "issue_table");
    if ( ret < 0)
    {
        log_error("db_check_table_exist(%s) found error.", db_path);
        return NULL;
    }
    else if ( 1 == ret )
    {
        //�������ڣ�������
        if ( gidb_i_create_table(db) < 0 )
        {
            log_error("gidb_i_create_table(%s) error.", db_path);
            return NULL;
        }
    }

    //����map
    GIDB_ISSUE_HANDLE * ptr = NULL;
    ptr = (GIDB_ISSUE_HANDLE *)malloc(sizeof(GIDB_ISSUE_HANDLE));
    memset(ptr, 0, sizeof(GIDB_ISSUE_HANDLE));

    ptr->game_code = game_code;
    ptr->db = db;

    //��ʼ������ָ��
    ptr->gidb_i_init_data = gidb_i_init_data;
    ptr->gidb_i_insert = gidb_i_insert;
    ptr->gidb_i_cleanup = gidb_i_cleanup;

    ptr->gidb_i_get_info = gidb_i_get_info;
    ptr->gidb_i_get_info2 = gidb_i_get_info2;

    ptr->gidb_i_set_status = gidb_i_set_status;
    ptr->gidb_i_get_status = gidb_i_get_status;

    ptr->gidb_i_set_field_text = gidb_i_set_field_text;
    ptr->gidb_i_get_field_text = gidb_i_get_field_text;

    map_i_set(game_code, ptr);

    log_debug("gidb_i_game_init(%d) -> success.", game_code);
    return ptr;
}

// interface
GIDB_ISSUE_HANDLE * gidb_i_get_handle(uint8 game_code)
{
    GIDB_ISSUE_HANDLE *ptr = map_i_get(game_code);
    if (NULL != ptr)
    {
        return ptr;
    }

    ptr = gidb_i_game_init(game_code);
    if (NULL == ptr)
    {
        log_error("gidb_i_get_handle(%d) failure!", game_code);
        return NULL;
    }
    return ptr;
}

int32 gidb_i_close_handle()
{
    GAME_ISSUE_MAP::iterator it;
    GIDB_ISSUE_HANDLE* pi = NULL;
    for(it=game_issue_map.begin(); it!=game_issue_map.end();)
    {
        pi = it->second;
        db_close(pi->db);
        free((char *)pi);

        game_issue_map.erase(it++);
    }

    log_debug("gidb_i_close_handle() success!");
    return 0;
}

#endif



//=============================================================================

#if R("---GIDB_GAME_DRAW_INTERFACE---")

//�����ڴο�����
int32 gidb_d_create_table_match(sqlite3 *db)
{
    const char *sql_match_str = "CREATE TABLE match_ticket_table ( \
        unique_tsn                  INT64       NOT NULL PRIMARY KEY, \
        reqfn_ticket                VARCHAR(24) NOT NULL, \
        rspfn_ticket                VARCHAR(24) NOT NULL, \
        time_stamp                  INT64       NOT NULL, \
        from_sale                   INTEGER     NOT NULL, \
        area_code                   INTEGER     DEFAULT (0), \
        area_type                   INTEGER     DEFAULT (0), \
        agency_code                 INT64       DEFAULT (0), \
        terminal_code               INT64       DEFAULT (0), \
        teller_code                 INTEGER     DEFAULT (0), \
        ap_code                     INTEGER     DEFAULT (0), \
        game_code                   INTEGER     NOT NULL, \
        issue_number                INT64       NOT NULL, \
        issue_count                 INTEGER     NOT NULL, \
        sale_start_issue            INT64       NOT NULL, \
        sale_start_issue_serial     INTEGER     NOT NULL, \
        sale_end_issue              INTEGER     NOT NULL, \
        total_bets                  INTEGER     NOT NULL, \
        ticket_amount               INT64       NOT NULL, \
        claiming_scope              INTEGER     NOT NULL, \
        is_train                    INTEGER     NOT NULL, \
        bet_string                  TEXT        NOT NULL, \
        match_result                BLOB        NOT NULL )";
    if (0 != db_create_table(db, sql_match_str))
    {
        log_error("gidb create match_ticket_table failure!");
        return -1;
    }
    return 0;
}

int32 gidb_d_create_table(sqlite3 *db, uint8 game_code, uint64 issue_number)
{
    //��ʼ���µ�����
    if ( db_begin_transaction(db) < 0 )
    {
        log_error("db_begin_transaction error.");
        return -1;
    }

    const char *sql_str = "CREATE TABLE draw_table( \
        game_code                INTEGER  NOT NULL, \
        issue_number             INT64    NOT NULL PRIMARY KEY, \
        status                   INTEGER  NOT NULL, \
        last_update              INT64    DEFAULT (0), \
        DRAW_CODE_KEY            TEXT, \
        TICKETS_STAT_KEY         BLOB, \
        WINNER_LOCAL_KEY         TEXT, \
        WINNER_CONFIRM_KEY       TEXT, \
        WLEVEL_STAT_KEY          BLOB, \
        WPRIZE_TABLE_KEY         BLOB, \
        WPRIZE_TABLE_CONFIRM_KEY BLOB, \
        WFUND_INFO_KEY           BLOB, \
        WFUND_INFO_CONFIRM_KEY   BLOB, \
        DRAW_ANNOUNCE_KEY        TEXT )";
    if (0 != db_create_table(db, sql_str))
    {
        log_error("gidb create draw_table failure!");
        return -1;
    }
    int32 rc;
    char *zErrMsg = 0;
    const char *sql_draw_str = "INSERT INTO draw_table ( \
        game_code, issue_number, status) VALUES (%d, %llu, %d)";
    static char sql[1024] = {0};
    sprintf( sql, sql_draw_str, game_code, issue_number, 0);
    rc = sqlite3_exec(db, sql, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("sqlite3_exec() -> SQL error: %s",zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }
    log_info("gidb create draw_table -> success.");

    rc = gidb_d_create_table_match(db);
    if (rc < 0)
    {
        log_error("gidb_d_create_table_match() failure!");
        return -1;
    }

    //�����ύ
    if ( db_end_transaction(db) < 0 )
    {
        log_error("db_end_transaction error.");
        return -1;
    }

    log_info("gidb_d_create_table(gidb create match_ticket_table) -> success.");

    return 0;
}

//����Ʊƥ��֮ǰ��������ǰ��ƥ���¼
int32 gidb_d_clean_match_table(GIDB_DRAW_HANDLE *self)
{
    int32 rc;
    char *zErrMsg = 0;

    //ɾ��ƥ���¼��
    const char *sql_clean_str = "DROP TABLE match_ticket_table";
    rc = sqlite3_exec(self->db, sql_clean_str, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("gidb_delete_issue() -> SQL error: %s",zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }
    //���´���ƥ���
    rc = gidb_d_create_table_match(self->db);
    if (rc < 0)
    {
        log_error("gidb_d_create_table_match() failure!");
        return -1;
    }

    log_notice("gidb_d_clean_match_table(%d, %llu) -> success.", self->game_code, self->issue_number);
    return 0;
}

//�������¿���ʱ�����������������ݺ�Ʊƥ������
int32 gidb_d_cleanup(GIDB_DRAW_HANDLE *self)
{
    const char *sql_str = "UPDATE draw_table SET status=%d, last_update=%u, \
        DRAW_CODE_KEY=null, \
        TICKETS_STAT_KEY=null, \
        WINNER_LOCAL_KEY=null, \
        WINNER_CONFIRM_KEY=null, \
        WLEVEL_STAT_KEY=null, \
        WPRIZE_TABLE_KEY=null, \
        WPRIZE_TABLE_CONFIRM_KEY=null, \
        WFUND_INFO_KEY=null, \
        WFUND_INFO_CONFIRM_KEY=null, \
        DRAW_ANNOUNCE_KEY=null \
        WHERE game_code=%d AND issue_number=%llu";

    int32 rc;
    char *zErrMsg = 0;

    char sql[4096] = {0};
    sprintf(sql, sql_str, ISSUE_STATE_SEALED, get_now(), self->game_code, self->issue_number);
    
    rc = sqlite3_exec(self->db, sql, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("gidb_d_cleanup() -> SQL error: %s",zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }

    //���ƥ���¼��������
    rc = gidb_d_clean_match_table(self);
    if (rc < 0)
    {
        log_error("gidb_d_clean_match_table() failure!");
        return -1;
    }

    log_notice("gidb_d_cleanup(%d, %llu) -> success.", self->game_code, self->issue_number);
    return 0;
}

//����GIDB_DRAW_HANDLE�е���Ϸ������ںţ�����draw_table����status��last_update�е�ֵ
//Ҫ���µ�status������GIDB_D_DATA��status�ֶ���
int32 gidb_d_set_status(GIDB_DRAW_HANDLE *self, GIDB_D_DATA *gd_data)
{
    const char *sql_str = "UPDATE draw_table SET status=%d, last_update=%u WHERE game_code=%d AND issue_number=%llu";

    int32 rc;
    char *zErrMsg = 0;

    char sql[4096] = {0};
    sprintf(sql, sql_str, gd_data->status, get_now(), self->game_code, self->issue_number);

    rc = sqlite3_exec(self->db, sql, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("gidb_d_set_status(%d) -> SQL error: %s", gd_data->status, zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }

    log_debug("gidb_d_set_status(%d, %lld, status[%d]) -> success.", self->game_code, self->issue_number, gd_data->status);
    return 0;
}

//����GIDB_DRAW_HANDLE�е���Ϸ������ںţ�����draw_table����status��last_update�е�ֵ
//����õ���״̬���������ʱ�䱣����GIDB_D_DATA��status��update_time�ֶ���
int32 gidb_d_get_status(GIDB_DRAW_HANDLE *self, GIDB_D_DATA *gd_data)
{
    const char *sql_str = "SELECT status, last_update FROM draw_table WHERE game_code=%d AND issue_number=%llu";

    char sql[4096] = {0};
    sprintf(sql, sql_str, self->game_code, self->issue_number);

    int32 rc;
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
        log_info("gidb_d_get_status() return empty.");
        sqlite3_finalize(pStmt);
        return 1;
    }
    else if (rc != SQLITE_ROW)
    {
        log_error("sqlite3_step() failure!");
        sqlite3_finalize(pStmt);
        return -1;
    }

    gd_data->status = sqlite3_column_int(pStmt, 0);
    gd_data->update_time = sqlite3_column_int64(pStmt, 1);

    sqlite3_finalize(pStmt);

    log_notice("gidb_d_get_status(%d, %llu, status[%d]) -> success.", self->game_code, self->issue_number, gd_data->status);
    return 0;
}

static const char *D_FIELD_TEXT_NAME[] =  {
    "NONE",
    "DRAW_CODE_KEY",
    "WINNER_LOCAL_KEY",
    "WINNER_CONFIRM_KEY",
    "DRAW_ANNOUNCE_KEY"
};

//�����ڱ��ַ����ֶ�����
int32 gidb_d_set_field_text(GIDB_DRAW_HANDLE *self, GIDB_D_DATA *gd_data)
{
    const char *sql_field_data = "UPDATE draw_table SET %s=?, last_update=%u WHERE game_code=%d AND issue_number=%llu";

    char sql[4096] = {0};
    sprintf(sql, sql_field_data, D_FIELD_TEXT_NAME[gd_data->field_type], get_now(), self->game_code, self->issue_number);

    int32 rc;
    sqlite3_stmt* pStmt = NULL;
    rc = sqlite3_prepare_v2(self->db, sql, strlen(sql), &pStmt, NULL);
    if ( rc != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() error. [%d]", rc);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    if ( sqlite3_bind_text(pStmt, 1, gd_data->data, gd_data->data_len, SQLITE_STATIC) != SQLITE_OK)
    {
        log_error("sqlite3_bind_text() error.");
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

    log_debug("gidb_d_set_field_text(%d, %llu, fieldType[%d]) -> success.", self->game_code, self->issue_number, gd_data->field_type);
    return 0;
}
//�����ڱ��ַ����ֶ�����
//����ֵ: С��0=����  0=�ɹ����ؽ��  1=û���ҵ���ѯ�ļ�¼  2=��ѯ���ֶ�Ϊ��
int32 gidb_d_get_field_text(GIDB_DRAW_HANDLE *self, GIDB_D_DATA *gd_data)
{
    int32 rc;
    const char *sql_field_data = "SELECT status, last_update, %s FROM draw_table WHERE game_code=%d AND issue_number=%llu";

    char * data_ptr = NULL;

    char sql[4096] = {0};
    sprintf(sql, sql_field_data, D_FIELD_TEXT_NAME[gd_data->field_type], self->game_code, self->issue_number);

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
        log_info("gidb_get_field_data() return empty.");
        sqlite3_finalize(pStmt);
        return 1;
    }
    else if (rc != SQLITE_ROW)
    {
        log_error("sqlite3_step() failure!");
        sqlite3_finalize(pStmt);
        return -1;
    }

    gd_data->status = sqlite3_column_int(pStmt, 0);
    gd_data->update_time = sqlite3_column_int(pStmt, 1);
    data_ptr = (char *)sqlite3_column_text(pStmt, 2);
    if (data_ptr != NULL)
    {
        strcpy(gd_data->data, data_ptr);
        gd_data->data_len = strlen(gd_data->data);
    }
    else
    {
        gd_data->data_len = 0;
        log_info("gidb_d_get_field_text() return empty. field data is NULL.");
        sqlite3_finalize(pStmt);
        return 2;
    }

    sqlite3_finalize(pStmt);

    log_notice("gidb_d_get_field_text(%d, %llu, fieldType[%d]) -> success.", self->game_code, self->issue_number, gd_data->field_type);
    return 0;
}


static const char *D_FIELD_BLOB_NAME[] =  {
    "NONE",
    "TICKETS_STAT_KEY",
    "WLEVEL_STAT_KEY",
    "WPRIZE_TABLE_KEY",
    "WPRIZE_TABLE_CONFIRM_KEY",
    "WFUND_INFO_KEY",
    "WFUND_INFO_CONFIRM_KEY",
};

//�����ڱ��������ֶ�����
int gidb_d_set_field_blob(GIDB_DRAW_HANDLE *self, GIDB_D_DATA *gd_data)
{
    const char *sql_field_data = "UPDATE draw_table SET %s=?, last_update=%u WHERE game_code=%d AND issue_number=%llu";

    char sql[4096] = {0};
    sprintf(sql, sql_field_data, D_FIELD_BLOB_NAME[gd_data->field_type], get_now(), self->game_code, self->issue_number);
    
    int32 rc;
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

    if ( sqlite3_bind_blob(pStmt, 1, gd_data->data, gd_data->data_len, SQLITE_STATIC) != SQLITE_OK)
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

    log_debug("gidb_d_set_field_blob(%d, %llu, fieldType[%d]) -> success.", self->game_code, self->issue_number, gd_data->field_type);
    return 0;
}
//�����ڱ��������ֶ��ֶ�����
//����ֵ: С��0=����  0=�ɹ����ؽ��  1=û���ҵ���ѯ�ļ�¼  2=��ѯ���ֶ�Ϊ��
int gidb_d_get_field_blob(GIDB_DRAW_HANDLE *self, GIDB_D_DATA *gd_data)
{
    int32 rc;
    const char *sql_field_data = "SELECT status, last_update, %s FROM draw_table WHERE game_code=%d AND issue_number=%llu";

    char * data_ptr = NULL;
    uint32 data_len = 0;

    char sql[4096] = {0};
    sprintf(sql, sql_field_data, D_FIELD_BLOB_NAME[gd_data->field_type], self->game_code, self->issue_number);

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
        log_info("gidb_d_get_field_blob() return empty.");
        sqlite3_finalize(pStmt);
        return 1;
    }
    else if (rc != SQLITE_ROW)
    {
        log_error("sqlite3_step() failure!");
        sqlite3_finalize(pStmt);
        return -1;
    }

    gd_data->status = sqlite3_column_int(pStmt, 0);
    gd_data->update_time = sqlite3_column_int(pStmt, 1);
    data_ptr = (char *)sqlite3_column_blob(pStmt, 2);
    if (data_ptr != NULL)
    {
        data_len = sqlite3_column_bytes(pStmt, 2);
        memcpy(gd_data->data, data_ptr, data_len);
        gd_data->data_len = data_len;
    }
    else
    {
        gd_data->data_len = 0;
        log_info("gidb_d_get_field_blob() return empty. field data is NULL.");
        sqlite3_finalize(pStmt);
        return 2;
    }

    sqlite3_finalize(pStmt);

    log_notice("gidb_d_get_field_blob(%d, %llu, fieldType[%d]) -> success.", self->game_code, self->issue_number, gd_data->field_type);
    return 0;
}

int32 gidb_d_insert_ticket(GIDB_DRAW_HANDLE *self, GIDB_MATCH_TICKET_REC *pTicketMatch)
{
    uint32 len = sizeof(GIDB_MATCH_TICKET_REC) + pTicketMatch->betStringLen;

    GIDB_MATCH_TICKET_REC *ptr = NULL;
    ptr = (GIDB_MATCH_TICKET_REC *)malloc(len);
    if (NULL == ptr)
    {
        log_error("malloc return failure!");
        return -1;
    }
    memcpy((char *)ptr, (char *)pTicketMatch, len);

    self->matchTicketList.push_back(ptr);
    self->commit_flag_match = true;

    return 0;
}

//�����ڵ�LIST�ڴ��е�ƥ���¼��������д�����ݿ��ļ�
int32 gidb_d_sync_ticket(GIDB_DRAW_HANDLE *self)
{
    int32 rc = 0;

    if (self->commit_flag_match == false)
    {
        return 0;
    }

    const char *sql_insert_match_ticket = "INSERT INTO match_ticket_table ( \
        unique_tsn, \
        reqfn_ticket, \
        rspfn_ticket, \
        time_stamp, \
        from_sale, \
        area_code, \
        area_type, \
        agency_code, \
        terminal_code, \
        teller_code, \
        ap_code, \
        game_code, \
        issue_number, \
        issue_count, \
        sale_start_issue, \
        sale_start_issue_serial, \
        sale_end_issue, \
        total_bets, \
        ticket_amount, \
        claiming_scope, \
        is_train, \
        bet_string, \
        match_result ) VALUES ( \
        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)";

    //��ʼ���µ�����
    if ( db_begin_transaction(self->db) < 0 )
    {
        log_error("db_begin_transaction(%d, %llu) error.", self->game_code, self->issue_number);
        return -1;
    }

    //����ƥ��Ʊҵ��Ĳ������
    sqlite3_stmt* pStmt = NULL;
    if (sqlite3_prepare_v2(self->db, sql_insert_match_ticket, strlen(sql_insert_match_ticket), &pStmt, NULL) != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() insert match ticket error.");
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    GIDB_MATCH_TICKET_REC* ptr_match = NULL;
    while (!self->matchTicketList.empty())
    {
        ptr_match = self->matchTicketList.front();

        bind_match_ticket(ptr_match, pStmt);

        rc = sqlite3_step(pStmt);
        if ( rc != SQLITE_DONE)
        {
            log_error("sqlite3_step() insert match ticket error. ret[%d]", rc);
            if (pStmt)
                sqlite3_finalize(pStmt);
            return -1;
        }
        sqlite3_reset(pStmt);

        free((char *)ptr_match);
        self->matchTicketList.pop_front();
    }
    sqlite3_finalize(pStmt);

    //�����ύ
    if ( db_end_transaction(self->db) < 0 )
    {
        log_error("db_end_transaction(%d, %llu) error.", self->game_code, self->issue_number);
        return -1;
    }

    self->commit_flag_match = false;

    return 0;
}

//keyֵǰ��λΪgame_code���ڴΰ�λΪdraw_times��ʡ�µ�48λΪ�ڴκ�
static DRAW_ISSUE_MAP  draw_issue_map;

GIDB_DRAW_HANDLE *map_d_get(uint8 game_code, uint64 issue_number, uint8 draw_times)
{
    //ͨ��game_code��issue_number��draw_times�ϳ�key
    uint64 key = (((uint64)game_code)<<56) + (((uint64)draw_times)<<48) + issue_number;
    if (1 == draw_issue_map.count(key))
    {
        return draw_issue_map[key];
    }
    return NULL;
}

int32 map_d_set(uint8 game_code, uint64 issue_number, uint8 draw_times, GIDB_DRAW_HANDLE *ptr)
{
    if (NULL == ptr)
    {
        return -1;
    }
    //ͨ��game_code��issue_number��draw_times�ϳ�key
    uint64 key = (((uint64)game_code)<<56) + (((uint64)draw_times)<<48) + issue_number;
    draw_issue_map[key] = ptr;
    return 0;
}

//��ʼ��һ��GIDB_DRAW_HANDLE���������ַ����map��
GIDB_DRAW_HANDLE * gidb_d_issue_init(uint8 game_code, uint64 issue_number, uint8 draw_times)
{
    int32 ret = 0;

    char game_abbr[16];
    get_game_abbr(game_code, game_abbr);
    char db_path[256];
    ts_get_game_issue_draw_filepath(game_abbr, issue_number, draw_times, db_path, 256);

    //����sqlite���ݿ� 
    sqlite3 * db = db_connect(db_path);
    if (db == NULL)
    {
        log_error("db_connect(%s) error.", db_path);
        return NULL;
    }

    //�жϱ��Ƿ��Ѵ���
    ret = db_check_table_exist(db, "draw_table");
    if (ret < 0)
    {
        log_error("db_check_table_exist(%s) found error.", db_path);
        return NULL;
    }
    else if (1 == ret)
    {
        //�������ڣ�������
        if (gidb_d_create_table(db, game_code, issue_number) < 0)
        {
            log_error("gidb_d_create_table(%s) error.", db_path);
            return NULL;
        }
    }

    //����map
    GIDB_DRAW_HANDLE * ptr = NULL;
    ptr = (GIDB_DRAW_HANDLE *)malloc(sizeof(GIDB_DRAW_HANDLE));
    memset(ptr, 0, sizeof(GIDB_DRAW_HANDLE));
    new(ptr)_GIDB_DRAW_HANDLE();

    ptr->game_code = game_code;
    ptr->issue_number = issue_number;
    ptr->draw_times = draw_times;
    ptr->last_time = get_now();
    ptr->db = db;

    //��ʼ������ָ��
    ptr->gidb_d_cleanup = gidb_d_cleanup;
    ptr->gidb_d_clean_match_table = gidb_d_clean_match_table;
    ptr->gidb_d_set_status = gidb_d_set_status;
    ptr->gidb_d_get_status = gidb_d_get_status;

    ptr->gidb_d_set_field_text = gidb_d_set_field_text;
    ptr->gidb_d_get_field_text = gidb_d_get_field_text;

    ptr->gidb_d_set_field_blob = gidb_d_set_field_blob;
    ptr->gidb_d_get_field_blob = gidb_d_get_field_blob;

    ptr->gidb_d_insert_ticket = gidb_d_insert_ticket;
    ptr->gidb_d_sync_ticket = gidb_d_sync_ticket;

    map_d_set(game_code, issue_number, draw_times, ptr);

    log_debug("gidb_d_issue_init(%d, %llu, %d) -> success.", game_code, issue_number, draw_times);
    return ptr;
}

//ͨ��game_code��issue_number��draw_times���һ��GIDB_DRAW_HANDLEָ��
//������GIDB_DRAW_HANDLEָ�벻�������ʼ��һ��������map�У�����ָ�뷵��
GIDB_DRAW_HANDLE * gidb_d_get_handle(uint8 game_code, uint64 issue_number, uint8 draw_times)
{
    GIDB_DRAW_HANDLE *ptr = map_d_get(game_code, issue_number, draw_times);
    if (NULL != ptr)
    {
        ptr->last_time = get_now();
        return ptr;
    }

    ptr = gidb_d_issue_init(game_code, issue_number, draw_times);
    if (NULL == ptr)
    {
        log_error("gidb_d_issue_init(%d) failure!", game_code);
        return NULL;
    }
    return ptr;
}

uint32 gidb_d_last_clean_time = 0;
//������ʱ�䲻ʹ�õ�handle
int gidb_d_clean_handle_timeout()
{
    uint32 time_n = get_now();
    if ((time_n-gidb_d_last_clean_time) <= ISSUE_HANDLE_TIMEOUT)
        return 0;

    DRAW_ISSUE_MAP::iterator iter;
    GIDB_DRAW_HANDLE* handle;
    //��ȫ�ı���ɾ������������Ԫ��
    for(iter = draw_issue_map.begin(); iter!=draw_issue_map.end();)
    {
        handle = iter->second;
        if ( (time_n-handle->last_time) > ISSUE_HANDLE_TIMEOUT )
        {
            db_close(handle->db);
            free((void *)handle);

            draw_issue_map.erase(iter++);
        }
        else
        {
            ++iter;
        }
    }
    gidb_d_last_clean_time = time_n;

    log_notice("gidb_d_clean_handle_timeout() success!");
    return 0;
}

int32 gidb_d_close_handle()
{
    DRAW_ISSUE_MAP::iterator iter;
    GIDB_DRAW_HANDLE* handle = NULL;
    for(iter=draw_issue_map.begin(); iter!=draw_issue_map.end();)
    {
        handle = iter->second;
        db_close(handle->db);
        free((char *)handle);

        draw_issue_map.erase(iter++);
    }

    log_debug("gidb_d_close_handle() success!");
    return 0;
}


#endif


#if R("---GIDB TICKET INDEX INTERFACE---")

//ticket idx tick

//����Ʊ������ 
int32 gidb_tidx_create_table(sqlite3 *db)
{
    //��ʼ���µ�����
    if ( db_begin_transaction(db) < 0 )
    {
        log_error("db_begin_transaction error.");
        return -1;
    }

    const char *sql_str = "CREATE TABLE ticket_idx_table( \
        unique_tsn                  INT64       NOT NULL PRIMARY KEY, \
        reqfn_ticket                VARCHAR(24) NOT NULL, \
        rspfn_ticket                VARCHAR(24) NOT NULL, \
        game_code                   INTEGER     NOT NULL, \
        issue_number                INT64       NOT NULL, \
        draw_issue_number           INT64       NOT NULL, \
        from_sale                   INTEGER     NOT NULL, \
    	extend                      BLOB )"; //��չ�ֶ�(FBS:match_count,match_code,match_code...)

    const char *sql_str_1 = "CREATE UNIQUE INDEX issue_seq ON ticket_idx_table(reqfn_ticket)";

    if (0 != db_create_table(db, sql_str))
    {
        log_error("gidb create ticket_idx_table failure!");
        return -1;
    }
    if (0 != db_create_table_index(db, sql_str_1))
    {
        log_error("gidb create ticket_idx_table index failure!");
        return -1;
    }

    //�����ύ
    if ( db_end_transaction(db) < 0 )
    {
        log_error("db_end_transaction error.");
        return -1;
    }

    log_info("gidb create ticket index table() -> success.");
    return 0;
}

int32 gidb_tidx_insert_ticket(GIDB_TICKET_IDX_HANDLE *self, GIDB_TICKET_IDX_REC *pTIdxRec)
{
    uint32 len = sizeof(GIDB_TICKET_IDX_REC) + pTIdxRec->extend_len;

    GIDB_TICKET_IDX_REC *ptr = NULL;
    ptr = (GIDB_TICKET_IDX_REC *)malloc(len);
    if (NULL == ptr)
    {
        log_error("malloc return failure!");
        return -1;
    }
    memcpy((char *)ptr, (char *)pTIdxRec, len);

    self->ticketIdxList.push_back(ptr);
    self->commit_flag = true;

    log_notice("gidb_tidx_insert_ticket push_back unique_tsn[%llu] game[%d] issue[%llu]",
            pTIdxRec->unique_tsn, pTIdxRec->gameCode, pTIdxRec->issueNumber);
    return 0;
}

int32 gidb_tidx_sync(GIDB_TICKET_IDX_HANDLE *self)
{
    int32 rc = 0;

    if (self->commit_flag == false)
    {
        return 0;
    }

    const char *sql_insert_ticket_idx = "REPLACE INTO ticket_idx_table ( \
        unique_tsn, reqfn_ticket, rspfn_ticket, game_code, issue_number, draw_issue_number, from_sale, extend) VALUES ( ?,?,?,?,?,?,?,? )";

    //��ʼ���µ�����
    if ( db_begin_transaction(self->db) < 0 )
    {
        log_error("db_begin_transaction(%u) error.", self->date);
        return -1;
    }

    //����Ʊ�������ݵĲ���
    sqlite3_stmt* pStmt = NULL;
    if (sqlite3_prepare_v2(self->db, sql_insert_ticket_idx, strlen(sql_insert_ticket_idx), &pStmt, NULL) != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() insert ticket index error.");
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    GIDB_TICKET_IDX_REC* ptr_ticketIdx = NULL;
    TICKET_IDX_LIST::iterator iter_tidx;
    for (iter_tidx=self->ticketIdxList.begin(); iter_tidx!=self->ticketIdxList.end(); ++iter_tidx)
    {
        ptr_ticketIdx = *iter_tidx;

        bind_ticket_idx(ptr_ticketIdx, pStmt);

        rc = sqlite3_step(pStmt);
        if ( rc != SQLITE_DONE)
        {
            log_error("sqlite3_step() insert ticket index error. ret[%d]", rc);
            if (pStmt)
                sqlite3_finalize(pStmt);
            return -1;
        }
        sqlite3_reset(pStmt);
    }
    sqlite3_finalize(pStmt);

    while (!self->ticketIdxList.empty())
    {
        ptr_ticketIdx = self->ticketIdxList.front();
        free((char *)ptr_ticketIdx);
        self->ticketIdxList.pop_front();
    }

    //�����ύ
    if ( db_end_transaction(self->db) < 0 )
    {
        log_error("db_end_transaction(%u) error.", self->date);
        return -1;
    }

    self->commit_flag = false;
    self->last_time = get_now();
    return 0;
}
//get ticket by unique_tsn
int32 gidb_tidx_get(GIDB_TICKET_IDX_HANDLE *self, uint64 unique_tsn, GIDB_TICKET_IDX_REC *pTIdxRec)
{
    int32 rc;

    const char *sql_str = "SELECT * FROM ticket_idx_table WHERE unique_tsn=?";
    sqlite3_stmt* pStmt = NULL;

    rc = sqlite3_prepare_v2(self->db, sql_str, strlen(sql_str), &pStmt, NULL);
    if ( rc != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() error. [%d]", rc);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    sqlite3_bind_int64(pStmt, 1, unique_tsn);

    rc = sqlite3_step(pStmt);
    if (rc == SQLITE_DONE)
    {
        log_info("gidb_tidx_get() return empty.");
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
    get_ticket_idx_rec_from_stmt(pTIdxRec, pStmt);

    sqlite3_finalize(pStmt);
    return 0;
}
//get ticket by reqfn_ticket
int32 gidb_tidx_get2(GIDB_TICKET_IDX_HANDLE *self, char *reqfn_ticket, GIDB_TICKET_IDX_REC *pTIdxRec)
{
    int32 rc;

    const char *sql_str = "SELECT * FROM ticket_idx_table WHERE reqfn_ticket=?";
    sqlite3_stmt* pStmt = NULL;

    rc = sqlite3_prepare_v2(self->db, sql_str, strlen(sql_str), &pStmt, NULL);
    if ( rc != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() error. [%d]", rc);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    sqlite3_bind_text(pStmt, 1, reqfn_ticket, strlen(reqfn_ticket), SQLITE_TRANSIENT);

    rc = sqlite3_step(pStmt);
    if (rc == SQLITE_DONE)
    {
        log_info("gidb_tidx_get2() return empty.");
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
    get_ticket_idx_rec_from_stmt(pTIdxRec, pStmt);

    sqlite3_finalize(pStmt);
    return 0;
}

static pthread_mutex_t tidx_mutex = PTHREAD_MUTEX_INITIALIZER;
static TICKET_IDX_MAP  ticket_idx_map;
GIDB_TICKET_IDX_HANDLE *map_tidx_get(uint32 date)
{
    if (1 == ticket_idx_map.count(date))
    {
        return ticket_idx_map[date];
    }
    return NULL;
}

int32 map_tidx_set(uint32 date, GIDB_TICKET_IDX_HANDLE *ptr)
{
    if (NULL == ptr)
    {
        return -1;
    }
    ticket_idx_map[date] = ptr;
    return 0;
}

GIDB_TICKET_IDX_HANDLE * gidb_tidx_init(uint32 date)
{
    int32 ret = 0;

    char db_path[256];
    ts_get_ticket_idx_filepath(date, db_path, 256);

    //open sqlite db connect
    sqlite3 * db = db_connect(db_path);
    if ( db == NULL )
    {
        log_error("db_connect(%s) error.", db_path);
        return NULL;
    }

    //�жϱ��Ƿ��Ѵ���
    ret = db_check_table_exist(db, "ticket_idx_table");
    if ( ret < 0)
    {
        log_error("db_check_table_exist(%s) found error.", db_path);
        return NULL;
    }
    else if ( 1 == ret )
    {
        //�������ڣ�������
        if ( gidb_tidx_create_table(db) < 0 )
        {
            log_error("gidb_tidx_create_table(%s) error.", db_path);
            return NULL;
        }
    }

    //����map
    GIDB_TICKET_IDX_HANDLE * ptr = NULL;
    ptr = (GIDB_TICKET_IDX_HANDLE *)malloc(sizeof(GIDB_TICKET_IDX_HANDLE));
    memset(ptr, 0, sizeof(GIDB_TICKET_IDX_HANDLE));
    new(ptr)_GIDB_TICKET_IDX_HANDLE();

    ptr->date = date;
    ptr->last_time = get_now();
    ptr->db = db;

    //��ʼ������ָ��
    ptr->gidb_tidx_insert_ticket = gidb_tidx_insert_ticket;
    ptr->gidb_tidx_sync = gidb_tidx_sync;
    ptr->gidb_tidx_get = gidb_tidx_get;
    ptr->gidb_tidx_get2 = gidb_tidx_get2;

    pthread_mutex_lock(&tidx_mutex);
    map_tidx_set(date, ptr);
    pthread_mutex_unlock(&tidx_mutex);

    log_debug("gidb_tidx_init(%u) -> success.", date);
    return ptr;
}

// interface
GIDB_TICKET_IDX_HANDLE * gidb_tidx_get_handle(uint32 date)
{
    pthread_mutex_lock(&tidx_mutex);
    GIDB_TICKET_IDX_HANDLE *ptr = map_tidx_get(date);
    if (NULL != ptr)
    {
        ptr->last_time = get_now();
        pthread_mutex_unlock(&tidx_mutex);
        return ptr;
    }
    pthread_mutex_unlock(&tidx_mutex);
    ptr = gidb_tidx_init(date);
    if (NULL == ptr)
    {
        log_error("gidb_tidx_init(%u) failure!", date);
        return NULL;
    }
    return ptr;
}

uint32 gidb_tidx_last_clean_time = 0;
//������ʱ�䲻ʹ�õ�handle
int gidb_tidx_clean_handle_timeout()
{
    uint32 time_n = get_now();
    if ((time_n-gidb_tidx_last_clean_time) <= ISSUE_HANDLE_TIMEOUT)
        return 0;

    GIDB_TICKET_IDX_HANDLE* handle;
    TICKET_IDX_MAP::iterator iter;
    //��ȫ�ı���ɾ������������Ԫ��
    pthread_mutex_lock(&tidx_mutex);
    for(iter = ticket_idx_map.begin(); iter!=ticket_idx_map.end();)
    {
        handle = iter->second;
        if ( (time_n-handle->last_time) > ISSUE_HANDLE_TIMEOUT ) {
            db_close(handle->db);
            free((void *)handle);

            ticket_idx_map.erase(iter++);
        } else {
            ++iter;
        }
    }
    pthread_mutex_unlock(&tidx_mutex);
    gidb_tidx_last_clean_time = time_n;

    log_notice("gidb_tidx_clean_handle_timeout() success!");
    return 0;
}

int32 gidb_tidx_close_handle()
{
    TICKET_IDX_MAP::iterator it;
    GIDB_TICKET_IDX_HANDLE* pi = NULL;
    pthread_mutex_lock(&tidx_mutex);
    for(it=ticket_idx_map.begin(); it!=ticket_idx_map.end();)
    {
        pi = it->second;
        db_close(pi->db);
        free((char *)pi);

        ticket_idx_map.erase(it++);
    }
    pthread_mutex_unlock(&tidx_mutex);

    log_debug("gidb_tidx_close_handle() success!");
    return 0;
}

int32 get_ticket_idx(uint32 date, uint64 unique_tsn, GIDB_TICKET_IDX_REC *pTIdxRec)
{
    int ret = 0;
    //�������ļ��в�ѯƱ��Ϣ
    GIDB_TICKET_IDX_HANDLE * tidx_handle = NULL;
    tidx_handle = gidb_tidx_get_handle(date);
    if(tidx_handle == NULL)
    {
        log_error("gidb_tidx_get_handle( %u ) return null.", date);
        return -1;
    }
    ret = tidx_handle->gidb_tidx_get(tidx_handle, unique_tsn, pTIdxRec);
    if (ret < 0)
    {
        log_error("gidb_tidx_get( %llu ) failure.", unique_tsn);
        return -1;
    }
    else if (ret == 1)
    {
        log_error("gidb_tidx_get( %llu ) not found.", unique_tsn);
        return 1;
    }
    gidb_tidx_clean_handle_timeout();
    return 0;
}

int32 get_ticket_idx2(uint32 date, char *reqfn_ticket, GIDB_TICKET_IDX_REC *pTIdxRec)
{
    int ret = 0;
    //�������ļ��в�ѯƱ��Ϣ
    GIDB_TICKET_IDX_HANDLE * tidx_handle = NULL;
    tidx_handle = gidb_tidx_get_handle(date);
    if(tidx_handle == NULL)
    {
        log_error("gidb_tidx_get_handle( %u ) return null.", date);
        return -1;
    }
    ret = tidx_handle->gidb_tidx_get2(tidx_handle, reqfn_ticket, pTIdxRec);
    if (ret < 0)
    {
        log_error("gidb_tidx_get2( %s ) failure.", reqfn_ticket);
        return -1;
    }
    else if (ret == 1)
    {
        log_error("gidb_tidx_get2( %s ) not found.", reqfn_ticket);
        return 1;
    }
    gidb_tidx_clean_handle_timeout();
    return 0;
}


#endif


#if R("---GIDB SALE TICKET INTERFACE---")

//sale tick

//��������Ʊ�ڱ� 
int32 gidb_t_create_table(sqlite3 *db, uint8 game_code, uint64 issue_number)
{
    //��ʼ���µ�����
    if ( db_begin_transaction(db) < 0 )
    {
        log_error("db_begin_transaction error.");
        return -1;
    }

    const char *sql_str = "CREATE TABLE sale_config_table( \
        game_code          INTEGER NOT NULL, \
        issue_number       INT64   NOT NULL PRIMARY KEY, \
        GAME_PARAM_KEY     BLOB, \
        SUBTYPE_PARAM_KEY  BLOB, \
        DIVISION_PARAM_KEY BLOB, \
        PRIZE_PARAM_KEY    BLOB, \
        POOL_PARAM_KEY     BLOB )";
    if (0 != db_create_table(db, sql_str))
    {
        log_error("gidb create draw_table failure!");
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

    const char *sql_sale_str = "CREATE TABLE sale_ticket_table ( \
        from_sale                   INTEGER     NOT NULL, \
        unique_tsn                  INT64       NOT NULL PRIMARY KEY, \
        reqfn_ticket                VARCHAR(24) NOT NULL, \
        rspfn_ticket                VARCHAR(24) NOT NULL, \
        time_stamp                  INT64       NOT NULL, \
        game_code                   INTEGER     NOT NULL, \
        issue_number                INT64       NOT NULL, \
        issue_count                 INTEGER     NOT NULL, \
        sale_start_issue            INT64       NOT NULL, \
        sale_start_issue_serial     INTEGER     NOT NULL, \
        sale_end_issue              INT64       NOT NULL, \
        total_bets                  INTEGER     NOT NULL, \
        ticket_amount               INT64       NOT NULL, \
        commission_amount           INT64       NOT NULL, \
        claiming_scope              INTEGER     NOT NULL, \
        draw_time_stamp             INT64       NOT NULL, \
        is_train                    INTEGER     NOT NULL, \
        betline_count               INTEGER     NOT NULL, \
        bet_string                  TEXT        NOT NULL, \
        ticket                      BLOB        NOT NULL, \
        area_code                   INTEGER     DEFAULT (0), \
        area_type                   INTEGER     DEFAULT (0), \
        agency_code                 INT64       DEFAULT (0), \
        terminal_code               INT64       DEFAULT (0), \
        teller_code                 INTEGER     DEFAULT (0), \
        ap_code                     INTEGER     DEFAULT (0), \
        is_cancel                   INTEGER     NOT NULL, \
        from_cancel                 INTEGER     DEFAULT (0), \
        reqfn_ticket_cancel         VARCHAR(24), \
        rspfn_ticket_cancel         VARCHAR(24), \
        time_stamp_cancel           INT64       DEFAULT (0), \
        agency_code_cancel          INT64       DEFAULT (0), \
        terminal_code_cancel        INT64       DEFAULT (0), \
        teller_code_cancel          INTEGER     DEFAULT (0), \
        ap_code_cancel              INTEGER     DEFAULT (0), \
        vfyc                        BLOB        NOT NULL )";

    if (0 != db_create_table(db, sql_sale_str))
    {
        log_error("gidb create sale ticket table() failure! sql->%s", sql_sale_str);
        return -1;
    }

    //�����ύ
    if ( db_end_transaction(db) < 0 )
    {
        log_error("db_end_transaction error.");
        return -1;
    }

    log_info("gidb create sale ticket table() -> success.");
    return 0;
}

static const char *T_FIELD_BLOB_NAME[] =  {
    "NONE",
    "GAME_PARAM_KEY",
    "SUBTYPE_PARAM_KEY",
    "DIVISION_PARAM_KEY",
    "PRIZE_PARAM_KEY",
    "POOL_PARAM_KEY"
};

//�����ڱ��������ֶ�����
int gidb_t_set_field_blob(GIDB_T_TICKET_HANDLE *self, T_FIELD_BLOB_KEY field_type, char *data, int32 len)
{
    int32 rc;
    const char *sql_field_data = "UPDATE sale_config_table SET %s=? WHERE game_code=%d AND issue_number=%llu";

    char sql[4096] = {0};
    sprintf(sql, sql_field_data, T_FIELD_BLOB_NAME[field_type], self->game_code, self->issue_number);
    
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

    log_notice("gidb_t_set_field_blob(%d, %llu, fieldType[%d]) -> success.", self->game_code, self->issue_number, field_type);
    return 0;
}
//�����ڱ��������ֶ��ֶ�����
//����ֵ: С��0=����  0=�ɹ����ؽ��  1=û���ҵ���ѯ�ļ�¼  2=��ѯ���ֶ�Ϊ��
int gidb_t_get_field_blob(GIDB_T_TICKET_HANDLE *self, T_FIELD_BLOB_KEY field_type, char *data, int32 *len)
{
    int32 rc;
    const char *sql_field_data = "SELECT %s FROM sale_config_table WHERE game_code=%d AND issue_number=%llu";

    char * data_ptr = NULL;
    uint32 data_len = 0;

    char sql[4096] = {0};
    sprintf(sql, sql_field_data, T_FIELD_BLOB_NAME[field_type], self->game_code, self->issue_number);

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
        log_info("gidb_t_get_field_blob() return empty.");
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
        log_info("gidb_t_get_field_blob() return empty. field data is NULL.");
        sqlite3_finalize(pStmt);
        return 2;
    }

    sqlite3_finalize(pStmt);

    log_notice("gidb_t_get_field_blob(%d, %llu, fieldType[%d]) -> success.", self->game_code, self->issue_number, field_type);
    return 0;
}


int32 gidb_t_insert_ticket(GIDB_T_TICKET_HANDLE *self, GIDB_SALE_TICKET_REC *pTicketSell)
{
    uint32 len = offsetof(GIDB_SALE_TICKET_REC, ticket) + pTicketSell->ticket.length;

    GIDB_SALE_TICKET_REC *ptr = NULL;
    ptr = (GIDB_SALE_TICKET_REC *)malloc(len);
    if (NULL == ptr)
    {
        log_error("malloc return failure!");
        return -1;
    }
    memcpy((char *)ptr, (char *)pTicketSell, len);

    self->saleTicketList.push_back(ptr);
    self->commit_flag = true;

    log_notice("gidb_t_insert_ticket push_back rspfn_ticket[%s] game[%d] issue[%llu]",
            pTicketSell->rspfn_ticket, pTicketSell->ticket.gameCode, pTicketSell->issueNumber);
    return 0;
}

int32 gidb_t_update_cancel(GIDB_T_TICKET_HANDLE *self, GIDB_CANCEL_TICKET_STRUCT *pCancelInfo)
{
    uint32 len = sizeof(GIDB_CANCEL_TICKET_STRUCT) + pCancelInfo->ticket.betStringLen + pCancelInfo->ticket.betlineLen;
    GIDB_CANCEL_TICKET_STRUCT *ptr = NULL;
    ptr = (GIDB_CANCEL_TICKET_STRUCT *)malloc(len);
    if (NULL == ptr)
    {
        log_error("malloc return failure!");
        return -1;
    }
    memcpy((char *)ptr, (char *)pCancelInfo, len);

    self->cancelTicketList.push_back(ptr);
    self->commit_flag = true;

    //log_debug("gidb_t_update_cancel push_back rspfn_ticket[%s]", pCancelInfo->rspfn_ticket);
    return 0;
}

int32 gidb_t_sync_sc_ticket(GIDB_T_TICKET_HANDLE *self) //st ->  sale & cancel
{
    int32 rc = 0;

    if (self->commit_flag == false)
    {
        return 0;
    }

    const char *sql_insert_sale_ticket = "INSERT INTO sale_ticket_table ( \
        from_sale,  \
        unique_tsn, \
        reqfn_ticket, \
        rspfn_ticket, \
        time_stamp,  \
        game_code, \
        issue_number, \
        issue_count, \
        sale_start_issue, \
        sale_start_issue_serial, \
        sale_end_issue, \
        total_bets, \
        ticket_amount, \
        commission_amount, \
        claiming_scope, \
        draw_time_stamp, \
        is_train, \
        betline_count, \
        bet_string, \
        ticket, \
        area_code, \
        area_type, \
        agency_code, \
        terminal_code, \
        teller_code, \
        ap_code, \
        is_cancel, \
        vfyc ) VALUES ( \
        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)";

    const char *sql_update_cancel_ticket = "UPDATE sale_ticket_table SET \
        is_cancel=?, from_cancel=?, reqfn_ticket_cancel=?, rspfn_ticket_cancel=?, time_stamp_cancel=?, \
        agency_code_cancel=?, terminal_code_cancel=?, teller_code_cancel=?, ap_code_cancel=?, vfyc=? \
        WHERE unique_tsn=?";

    //��ʼ���µ�����
    if ( db_begin_transaction(self->db) < 0 )
    {
        log_error("db_begin_transaction(%d, %llu) error.", self->game_code, self->issue_number);
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
    GIDB_SALE_TICKET_REC* ptr_sale = NULL;
    while (!self->saleTicketList.empty())
    {
        ptr_sale = self->saleTicketList.front();
        memset(vfyc, 0, sizeof(vfyc));

        if (ts_calc_vfyc(SALE_TICKET_VFYC_T, ptr_sale, vfyc, &vfyc_len) != 0)
        {
            log_error("ts_calc_vfyc() failure.");
            return -1;
        }
        bind_sale_ticket(ptr_sale, pStmt, vfyc, vfyc_len);

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

    GIDB_CANCEL_TICKET_STRUCT* ptr_cancel = NULL;
    while (!self->cancelTicketList.empty())
    {
        ptr_cancel = self->cancelTicketList.front();

        if (ts_calc_vfyc(CANCEL_TICKET_VFYC_T, ptr_cancel, vfyc, &vfyc_len) != 0)
        {
            log_error("ts_calc_vfyc() failure.");
            return -1;
        }
        bind_update_cancel_ticket(ptr_cancel, pStmt, vfyc, vfyc_len);

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
        log_error("db_end_transaction(%d, %llu) error.", self->game_code, self->issue_number);
        return -1;
    }

    self->commit_flag = false;
    self->last_time = get_now();
    return 0;
}

int32 gidb_t_get_ticket(GIDB_T_TICKET_HANDLE *self, uint64 unique_tsn, GIDB_SALE_TICKET_REC *pTicketSell)
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
        log_info("gidb_t_get_ticket() return empty.");
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
    if ( get_sale_ticket_rec_from_stmt(pTicketSell, pStmt) < 0 )
    {
        log_error("get_sale_ticket_rec_from_stmt() failure!");
        sqlite3_finalize(pStmt);
        return -1;
    }

    sqlite3_finalize(pStmt);
    return 0;
}

static pthread_mutex_t t_mutex = PTHREAD_MUTEX_INITIALIZER;
static T_TICKET_MAP  t_ticket_map;
GIDB_T_TICKET_HANDLE *map_t_get(uint8 game_code, uint64 issue_number)
{
    uint64 key = (((uint64)game_code)<<56) + issue_number;
    if (1 == t_ticket_map.count(key))
    {
        return t_ticket_map[key];
    }
    return NULL;
}

int32 map_t_set(uint8 game_code, uint64 issue_number, GIDB_T_TICKET_HANDLE *ptr)
{
    if (NULL == ptr)
    {
        return -1;
    }
    uint64 key = (((uint64)game_code)<<56) + issue_number;
    t_ticket_map[key] = ptr;
    return 0;
}

GIDB_T_TICKET_HANDLE * gidb_t_ticket_init(uint8 game_code, uint64 issue_number)
{
    int32 ret = 0;

    char game_abbr[16];
    get_game_abbr(game_code, game_abbr);
    char db_path[256];
    ts_get_game_issue_ticket_filepath(game_abbr, issue_number, db_path, 256);

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
        if ( gidb_t_create_table(db, game_code, issue_number) < 0 )
        {
            log_error("gidb_t_create_table(%s) error.", db_path);
            return NULL;
        }
    }

    //����map
    GIDB_T_TICKET_HANDLE * ptr = NULL;
    ptr = (GIDB_T_TICKET_HANDLE *)malloc(sizeof(GIDB_T_TICKET_HANDLE));
    memset(ptr, 0, sizeof(GIDB_T_TICKET_HANDLE));
    new(ptr)_GIDB_T_TICKET_HANDLE();

    ptr->game_code = game_code;
    ptr->issue_number = issue_number;
    ptr->last_time = get_now();
    ptr->db = db;

    //��ʼ������ָ��
    ptr->gidb_t_set_field_blob = gidb_t_set_field_blob;
    ptr->gidb_t_get_field_blob = gidb_t_get_field_blob;

    ptr->gidb_t_insert_ticket = gidb_t_insert_ticket;
    ptr->gidb_t_update_cancel = gidb_t_update_cancel;
    ptr->gidb_t_sync_sc_ticket = gidb_t_sync_sc_ticket;
    ptr->gidb_t_get_ticket = gidb_t_get_ticket;
    pthread_mutex_lock(&t_mutex);
    map_t_set(game_code, issue_number, ptr);
    pthread_mutex_unlock(&t_mutex);
    log_debug("gidb_t_ticket_init(%d, %llu) -> success.", game_code, issue_number);
    return ptr;
}

// interface
GIDB_T_TICKET_HANDLE * gidb_t_get_handle(uint8 game_code, uint64 issue_number)
{
    pthread_mutex_lock(&t_mutex);
    GIDB_T_TICKET_HANDLE *ptr = map_t_get(game_code, issue_number);
    if (NULL != ptr)
    {
        ptr->last_time = get_now();
        pthread_mutex_unlock(&t_mutex);
        return ptr;
    }
    pthread_mutex_unlock(&t_mutex);
    ptr = gidb_t_ticket_init(game_code, issue_number);
    if (NULL == ptr)
    {
        log_error("gidb_t_ticket_init(%d) failure!", game_code);
        return NULL;
    }
    return ptr;
}

uint32 gidb_t_last_clean_time = 0;
//������ʱ�䲻ʹ�õ�handle
int gidb_t_clean_handle_timeout()
{
    uint32 time_n = get_now();
    if ((time_n-gidb_t_last_clean_time) <= ISSUE_HANDLE_TIMEOUT)
        return 0;

    GIDB_T_TICKET_HANDLE* handle;
    T_TICKET_MAP::iterator iter;
    //��ȫ�ı���ɾ������������Ԫ��
    pthread_mutex_lock(&t_mutex);
    for(iter = t_ticket_map.begin(); iter!=t_ticket_map.end();)
    {
        handle = iter->second;
        if ( (time_n-handle->last_time) > ISSUE_HANDLE_TIMEOUT )
        {
            db_close(handle->db);
            free((void *)handle);

            t_ticket_map.erase(iter++);
        }
        else
        {
            ++iter;
        }
    }
    pthread_mutex_unlock(&t_mutex);
    gidb_t_last_clean_time = time_n;
    log_notice("gidb_t_clean_handle_timeout() success!");
    return 0;
}

int32 gidb_t_close_handle()
{
    T_TICKET_MAP::iterator it;
    GIDB_T_TICKET_HANDLE* pi = NULL;
    pthread_mutex_lock(&t_mutex);
    for(it=t_ticket_map.begin(); it!=t_ticket_map.end();)
    {
        pi = it->second;
        db_close(pi->db);
        free((char *)pi);

        t_ticket_map.erase(it++);
    }
    pthread_mutex_unlock(&t_mutex);
    log_debug("gidb_t_close_handle() success!");
    return 0;
}


#endif

//====================================================================================================


#if R("---GIDB WIN TICKET INTERFACE---")


//�����н�Ʊ�����ļ� 
int32 gidb_w_create_table(sqlite3 *db)
{
    //��ʼ���µ�����
    if ( db_begin_transaction(db) < 0 )
    {
        log_error("db_begin_transaction error.");
        return -1;
    }

    const char *sql_winner_str = "CREATE TABLE win_ticket_table ( \
        unique_tsn                  INT64       NOT NULL PRIMARY KEY, \
        reqfn_ticket                VARCHAR(24) NOT NULL, \
        rspfn_ticket                VARCHAR(24) NOT NULL, \
        time_stamp                  INT64       NOT NULL, \
        from_sale                   INTEGER     NOT NULL, \
        area_code                   INTEGER     DEFAULT (0), \
        area_type                   INTEGER     DEFAULT (0), \
        agency_code                 INT64       DEFAULT (0), \
        terminal_code               INT64       DEFAULT (0), \
        teller_code                 INTEGER     DEFAULT (0), \
        ap_code                     INTEGER     DEFAULT (0), \
        game_code                   INTEGER     NOT NULL, \
        issue_number                INT64       NOT NULL, \
        issue_count                 INTEGER     NOT NULL, \
        sale_start_issue            INT64       NOT NULL, \
        sale_start_issue_serial     INTEGER     NOT NULL, \
        sale_end_issue              INTEGER     NOT NULL, \
        total_bets                  INTEGER     NOT NULL, \
        ticket_amount               INT64       NOT NULL, \
        claiming_scope              INTEGER     NOT NULL, \
        is_train                    INTEGER     NOT NULL, \
        bet_string                  TEXT        NOT NULL, \
        is_big_winning              INTEGER     NOT NULL, \
        winning_amount_tax          INT64       NOT NULL, \
        winning_amount              INT64       NOT NULL, \
        tax_amount                  INT64       NOT NULL, \
        winning_count               INTEGER     NOT NULL, \
        hd_winning                  INT64       NOT NULL, \
        hd_count                    INTEGER     NOT NULL, \
        ld_winning                  INT64       NOT NULL, \
        ld_count                    INTEGER     NOT NULL, \
        paid_status                 INTEGER     NOT NULL, \
        from_pay                    INTEGER     DEFAULT (0), \
        reqfn_ticket_pay            VARCHAR(24), \
        rspfn_ticket_pay            VARCHAR(24), \
        time_stamp_pay              INT64       DEFAULT (0), \
        agency_code_pay             INT64       DEFAULT (0), \
        terminal_code_pay           INT64       DEFAULT (0), \
        teller_code_pay             INTEGER     DEFAULT (0), \
        ap_code_pay                 INTEGER     DEFAULT (0), \
        username_pay                VARCHAR(64) DEFAULT (''), \
        identity_type_pay           INTEGER     DEFAULT (0), \
        identity_number_pay         VARCHAR(64) DEFAULT (''), \
        prize_count                 INTEGER     NOT NULL, \
        prize_detail                BLOB        NOT NULL, \
        vfyc                        BLOB        NOT NULL )";
    if (0 != db_create_table(db, sql_winner_str))
    {
        log_error("gidb create winner ticket table() failure! sql->%s", sql_winner_str);
        return -1;
    }
    log_info("gidb create winner ticket table() -> success.");


    const char *sql_tmp_winner_str = "CREATE TABLE tmp_win_ticket_table ( \
        unique_tsn                  INT64       NOT NULL, \
        reqfn_ticket                VARCHAR(24) NOT NULL, \
        rspfn_ticket                VARCHAR(24) NOT NULL, \
        time_stamp                  INT64       NOT NULL, \
        from_sale                   INTEGER     NOT NULL, \
        area_code                   INTEGER     DEFAULT (0), \
        area_type                   INTEGER     DEFAULT (0), \
        agency_code                 INT64       DEFAULT (0), \
        terminal_code               INT64       DEFAULT (0), \
        teller_code                 INTEGER     DEFAULT (0), \
        ap_code                     INTEGER     DEFAULT (0), \
        game_code                   INTEGER     NOT NULL, \
        issue_number                INT64       NOT NULL, \
        issue_count                 INTEGER     NOT NULL, \
        sale_start_issue            INT64       NOT NULL, \
        sale_start_issue_serial     INTEGER     NOT NULL, \
        sale_end_issue              INTEGER     NOT NULL, \
        total_bets                  INTEGER     NOT NULL, \
        ticket_amount               INT64       NOT NULL, \
        claiming_scope              INTEGER     NOT NULL, \
        is_train                    INTEGER     NOT NULL, \
        bet_string                  TEXT        NOT NULL, \
        is_big_winning              INTEGER     NOT NULL, \
        winning_amount_tax          INT64       NOT NULL, \
        winning_amount              INT64       NOT NULL, \
        tax_amount                  INT64       NOT NULL, \
        winning_count               INTEGER     NOT NULL, \
        hd_winning                  INT64       NOT NULL, \
        hd_count                    INTEGER     NOT NULL, \
        ld_winning                  INT64       NOT NULL, \
        ld_count                    INTEGER     NOT NULL, \
        prize_count                 INTEGER     NOT NULL, \
        prize_detail                BLOB        NOT NULL, \
        win_issue_number            INT64       NOT NULL, \
        vfyc                        BLOB        NOT NULL )";
    if (0 != db_create_table(db, sql_tmp_winner_str))
    {
        log_error("gidb create tmp winner ticket table() failure! sql->%s", sql_tmp_winner_str);
        return -1;
    }

    //�����ύ
    if ( db_end_transaction(db) < 0 )
    {
        log_error("db_end_transaction error.");
        return -1;
    }

    log_info("gidb create tmp winner ticket table() -> success.");
    return 0;
}

//���²�ƱΪ�Ѷҽ�
int32 gidb_w_update_pay(GIDB_W_TICKET_HANDLE *self, GIDB_PAY_TICKET_STRUCT *pPayInfo)
{
    uint32 len = sizeof(GIDB_PAY_TICKET_STRUCT);
    GIDB_PAY_TICKET_STRUCT *ptr = NULL;
    ptr = (GIDB_PAY_TICKET_STRUCT *)malloc(len);
    if (NULL == ptr)
    {
        log_error("malloc return failure!");
        return -1;
    }
    memcpy((char *)ptr, (char *)pPayInfo, len);

    self->payTicketList.push_back(ptr);
    self->commit_flag = true;

    log_notice("gidb_w_update_pay push_back rspfn_ticket[%s]", pPayInfo->rspfn_ticket);
    return 0;
}

//ͬ�����ڵ� �ҽ��������� ������
int32 gidb_w_sync_pay_ticket(GIDB_W_TICKET_HANDLE *self)
{
    int32 rc = 0;

    if (self->commit_flag == false)
    {
        return 0;
    }

    const char *sql_update_pay_ticket = "UPDATE win_ticket_table SET \
        paid_status=?, from_pay=?, reqfn_ticket_pay=?, rspfn_ticket_pay=?, time_stamp_pay=?, \
        agency_code_pay=?, terminal_code_pay=?, teller_code_pay=?, ap_code_pay=?, \
        username_pay=?, identity_type_pay=?, identity_number_pay=?, vfyc=? \
        WHERE unique_tsn=?";

    //��ʼ���µ�����
    if ( db_begin_transaction(self->db) < 0 )
    {
        log_error("db_begin_transaction(%d, %llu) error.", self->game_code, self->issue_number);
        return -1;
    }

    //�����ҽ�ҵ��ĸ���
    sqlite3_stmt* pStmt = NULL;
    if (sqlite3_prepare_v2(self->db, sql_update_pay_ticket, strlen(sql_update_pay_ticket), &pStmt, NULL) != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() update pay error.");
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    static unsigned char vfyc[64];
    uint32 vfyc_len = 0;
    GIDB_PAY_TICKET_STRUCT* ptr_pay = NULL;
    while (!self->payTicketList.empty())
    {
        ptr_pay = self->payTicketList.front();

        if (ts_calc_vfyc(PAY_TICKET_VFYC_T, ptr_pay , vfyc, &vfyc_len) != 0)
        {
            log_error("ts_calc_vfyc() failure.");
            return -1;
        }
        bind_update_pay_ticket(ptr_pay, pStmt, vfyc, vfyc_len);

        //logout
        log_info("gidb_sync_ticket pay bind rspfn_ticket[%s]",ptr_pay->rspfn_ticket);

        rc = sqlite3_step(pStmt);
        if ( rc != SQLITE_DONE)
        {
            log_error("sqlite3_step() update pay ticket error. ret[%d]", rc);
            if (pStmt)
                sqlite3_finalize(pStmt);
            return -1;
        }
        sqlite3_reset(pStmt);

        //caoxf__ �˴���������ʱ����������ͳ���ڴ������ڼ�Ķҽ�ͳ�ƽ��
        //ͳ���ڴζҽ���
        //ptr_pay->issueNumber_pay
        //�ȴ��ļ���ȡ���ڴεĶҽ����
        //�ۼƴ˴ζҽ��Ľ��
        //д�ۼƶҽ����ļ�

        free((char *)ptr_pay);
        self->payTicketList.pop_front();
    }
    sqlite3_finalize(pStmt);

    //�����ύ
    if ( db_end_transaction(self->db) < 0 )
    {
        log_error("db_end_transaction(%d, %llu) error.", self->game_code, self->issue_number);
        return -1;
    }

    self->commit_flag = false;
    self->last_time = get_now();
    return 0;
}

int32 gidb_w_insert_ticket(GIDB_W_TICKET_HANDLE *self, GIDB_WIN_TICKET_REC *pTicketWin)
{
    uint32 len = sizeof(GIDB_WIN_TICKET_REC) + pTicketWin->prizeDetail_length;

    GIDB_WIN_TICKET_REC *ptr = NULL;
    ptr = (GIDB_WIN_TICKET_REC *)malloc(len);
    if (NULL == ptr)
    {
        log_error("malloc return failure!");
        return -1;
    }
    memcpy((char *)ptr, (char *)pTicketWin, len);

    self->winTicketList.push_back(ptr);
    self->commit_flag_win = true;

    return 0;
}

int32 gidb_w_sync_ticket(GIDB_W_TICKET_HANDLE *self)
{
    int32 rc = 0;

    if (self->commit_flag_win == false)
    {
        return 0;
    }

    const char *sql_insert_win_ticket = "INSERT INTO win_ticket_table ( \
        unique_tsn, \
        reqfn_ticket, \
        rspfn_ticket, \
        time_stamp, \
        from_sale, \
        area_code, \
        area_type, \
        agency_code, \
        terminal_code, \
        teller_code, \
        ap_code, \
        game_code, \
        issue_number, \
        issue_count, \
        sale_start_issue, \
        sale_start_issue_serial, \
        sale_end_issue, \
        total_bets, \
        ticket_amount, \
        claiming_scope, \
        is_train, \
        bet_string, \
        is_big_winning, \
        winning_amount_tax, \
        winning_amount, \
        tax_amount, \
        winning_count, \
        hd_winning, \
        hd_count, \
        ld_winning, \
        ld_count, \
        paid_status, \
        prize_count, \
        prize_detail, \
        vfyc ) VALUES ( \
        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)";

    //��ʼ���µ�����
    if ( db_begin_transaction(self->db) < 0 )
    {
        log_error("db_begin_transaction(%d, %llu) error.", self->game_code, self->issue_number);
        return -1;
    }

    //�����н���ʱƱҵ��Ĳ������(Ϊ ����Ʊ ����)
    sqlite3_stmt* pStmt = NULL;
    if (sqlite3_prepare_v2(self->db, sql_insert_win_ticket, strlen(sql_insert_win_ticket), &pStmt, NULL) != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() insert win ticket error.");
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    static unsigned char vfyc[64];
    uint32 vfyc_len = 0;
    GIDB_WIN_TICKET_REC* ptr_win = NULL;
    while (!self->winTicketList.empty())
    {
        ptr_win = self->winTicketList.front();

        if (ts_calc_vfyc(WIN_TICKET_VFYC_T, ptr_win , vfyc, &vfyc_len) != 0)
        {
            log_error("ts_calc_vfyc() failure.");
            return -1;
        }
        bind_winner_ticket(ptr_win, pStmt, vfyc, vfyc_len);

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

    //�����ύ
    if ( db_end_transaction(self->db) < 0 )
    {
        log_error("db_end_transaction(%d, %llu) error.", self->game_code, self->issue_number);
        return -1;
    }

    self->commit_flag_win = false;
    return 0;
}

//������ڵ��н�Ʊ�����һ�ڵ���ʱ�н�Ʊ���ݱ���(����ʽ���룬������ɺ���Ҫ����ͬ���ӿڣ����ܸ��µ����ݿ�)
int32 gidb_w_insert_tmp_ticket(GIDB_W_TICKET_HANDLE *self, GIDB_TMP_WIN_TICKET_REC *pTicketTmpWin)
{
    uint32 len = sizeof(GIDB_TMP_WIN_TICKET_REC) + pTicketTmpWin->prizeDetail_length;

    GIDB_TMP_WIN_TICKET_REC *ptr = NULL;
    ptr = (GIDB_TMP_WIN_TICKET_REC *)malloc(len);
    if (NULL == ptr)
    {
        log_error("malloc return failure!");
        return -1;
    }
    memcpy((char *)ptr, (char *)pTicketTmpWin, len);

    self->tmpWinTicketList.push_back(ptr);
    self->commit_flag_tmp_win = true;

    return 0;
}

//���ָ�������ڴ��ڱ�����ʱ���еĲд�����
int32 gidb_w_clean_tmp_ticket(GIDB_W_TICKET_HANDLE *self, uint64 draw_issue_number)
{
	if (self->tmp_win_draw_issue != draw_issue_number) {
		//delete win_draw_issue == draw_issue_number  records
	    int32 rc = 0;
	    char sql_del_tmp_win_ticket[256] = {0};
	    const char *str = "DELETE FROM tmp_win_ticket_table \
	        WHERE win_issue_number = %llu";
	    sprintf(sql_del_tmp_win_ticket, str, draw_issue_number);

	    //�����н���ʱƱҵ��Ĳ������(Ϊ ����Ʊ ����)
	    sqlite3_stmt* pStmt = NULL;
	    if (sqlite3_prepare_v2(self->db, sql_del_tmp_win_ticket, strlen(sql_del_tmp_win_ticket), &pStmt, NULL) != SQLITE_OK)
	    {
	        log_error("sqlite3_prepare_v2() del tmp win ticket error.");
	        if (pStmt)
	            sqlite3_finalize(pStmt);
	        return -1;
	    }
	    rc = sqlite3_step(pStmt);
		if (rc != SQLITE_DONE)
		{
			log_error("sqlite3_step() del tmp win ticket error. ret[%d]", rc);
			if (pStmt)
				sqlite3_finalize(pStmt);
			return -1;
		}

	    sqlite3_finalize(pStmt);
		self->tmp_win_draw_issue = draw_issue_number;
	}

	return 0;
}

//�����ڵ���ʱ�н���¼��������д�����ݿ��ļ�
int32 gidb_w_sync_tmp_ticket(GIDB_W_TICKET_HANDLE *self)
{
    int32 rc = 0;

    if (self->commit_flag_tmp_win == false)
    {
        return 0;
    }

    const char *sql_insert_tmp_win_ticket = "INSERT INTO tmp_win_ticket_table ( \
        unique_tsn, \
        reqfn_ticket, \
        rspfn_ticket, \
        time_stamp, \
        from_sale, \
        area_code, \
        area_type, \
        agency_code, \
        terminal_code, \
        teller_code, \
        ap_code, \
        game_code, \
        issue_number, \
        issue_count, \
        sale_start_issue, \
        sale_start_issue_serial, \
        sale_end_issue, \
        total_bets, \
        ticket_amount, \
        claiming_scope, \
        is_train, \
        bet_string, \
        is_big_winning, \
        winning_amount_tax, \
        winning_amount, \
        tax_amount, \
        winning_count, \
        hd_winning, \
        hd_count, \
        ld_winning, \
        ld_count, \
        prize_count, \
        prize_detail, \
        win_issue_number, \
        vfyc ) VALUES ( \
        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)";

    //��ʼ���µ�����
    if ( db_begin_transaction(self->db) < 0 )
    {
        log_error("db_begin_transaction(%d, %llu) error.", self->game_code, self->issue_number);
        return -1;
    }

    //�����н���ʱƱҵ��Ĳ������(Ϊ ����Ʊ ����)
    sqlite3_stmt* pStmt = NULL;
    if (sqlite3_prepare_v2(self->db, sql_insert_tmp_win_ticket, strlen(sql_insert_tmp_win_ticket), &pStmt, NULL) != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() insert tmp win ticket error.");
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    static unsigned char vfyc[64];
    uint32 vfyc_len = 0;
    GIDB_TMP_WIN_TICKET_REC* ptr_tmp_win = NULL;
    while (!self->tmpWinTicketList.empty())
    {
        ptr_tmp_win = self->tmpWinTicketList.front();

        if (ts_calc_vfyc(TMP_WIN_TICKET_VFYC_T, ptr_tmp_win , vfyc, &vfyc_len) != 0)
        {
            log_error("ts_calc_vfyc() failure.");
            return -1;
        }
        bind_tmp_winner_ticket(ptr_tmp_win, pStmt, vfyc, vfyc_len);

        rc = sqlite3_step(pStmt);
        if (rc != SQLITE_DONE)
        {
            log_error("sqlite3_step() insert tmp win ticket error. ret[%d]", rc);
            if (pStmt)
                sqlite3_finalize(pStmt);
            return -1;
        }
        sqlite3_reset(pStmt);

        free((char *)ptr_tmp_win);
        self->tmpWinTicketList.pop_front();
    }
    sqlite3_finalize(pStmt);

    //�����ύ
    if ( db_end_transaction(self->db) < 0 )
    {
        log_error("db_end_transaction(%d, %llu) error.", self->game_code, self->issue_number);
        return -1;
    }

    self->commit_flag_tmp_win = false;

    return 0;
}

//merge tmp_win_table �� win_ticket_table
int32 gidb_w_merge_tmp_ticket(GIDB_W_TICKET_HANDLE *self, money_t big_prize)
{
    int32 rc = 0;

    //��ҳ��ȡ���н�����Ʊ����
    WIN_TICKET_MAP map_win;

    //��ʱ��ŵ���Ҫ�����н����Ķ���Ʊ
    WIN_TICKET_LIST list_insert;

    //��ʱ��ŵ���Ҫ�����н����Ķ���Ʊ
    WIN_TICKET_LIST list_update;

    //�ȷ�ҳ��ȡtmp_win_ticket_table���� һ�����������ݵ��ڴ�������Ȼ���������д���
    //���²�ѯ��Ʊ���е�δ��Ʊ��¼
    char buf_tmp_win[1024 * 100] = {0};
    GIDB_TMP_WIN_TICKET_REC *pRec_tmp_win = (GIDB_TMP_WIN_TICKET_REC *)buf_tmp_win;

    char buf_win[1024 * 100] = {0};
    GIDB_WIN_TICKET_REC *pRec_win = (GIDB_WIN_TICKET_REC *)buf_win;

    uint32 offset = 0;
    while (true)
    {
        const char *sql_str = "SELECT * FROM tmp_win_ticket_table LIMIT 1000 OFFSET ?";
        sqlite3_stmt* pStmt = NULL;
        if (sqlite3_prepare_v2(self->db, sql_str, strlen(sql_str), &pStmt, NULL) != SQLITE_OK)
        {
            log_error("sqlite3_prepare_v2() error.");
            if (pStmt)
                sqlite3_finalize(pStmt);
            return -1;
        }

        sqlite3_bind_int(  pStmt, 1,   offset);

        //ѭ����ȡ�н���ʱƱ����
        int32 cnt = 0;
        while (true)
        {
            rc = sqlite3_step(pStmt);
            if (rc == SQLITE_ROW)
            {
                memset(buf_tmp_win, 0, (1024 * 100));

                if ( get_tmp_winner_ticket_rec_from_stmt(pRec_tmp_win, pStmt) < 0 )
                {
                    log_error("get_tmp_winner_ticket_rec_from_stmt(%d, %llu) error.", self->game_code, self->issue_number);
                    if (pStmt)
                        sqlite3_finalize(pStmt);
                    return -1;
                }

                GIDB_WIN_TICKET_REC *ptr = NULL;
                string rspfn_ticket_d = (const char *)pRec_tmp_win->rspfn_ticket;
                if (0 == map_win.count(rspfn_ticket_d))
                {
                    //malloc GIDB_WIN_TICKET_REC ��¼
                    int32 len = sizeof(GIDB_WIN_TICKET_REC) + sizeof(PRIZE_DETAIL)*MAX_PRIZE_COUNT;
                    ptr = (GIDB_WIN_TICKET_REC *)malloc(len);
                    if (NULL == ptr)
                    {
                        log_error("malloc return failure!");
                        if (pStmt)
                            sqlite3_finalize(pStmt);
                        return -1;
                    }
                    //ת�� GIDB_TMP_WIN_TICKET_REC ---->  GIDB_WIN_TICKET_REC
                    tmp_win_ticket_2_win_ticket_rec(pRec_tmp_win, ptr);

                    map_win[rspfn_ticket_d] = ptr;
                }
                else
                {
                    //֮ǰ������ͬһ�Ų�Ʊ�������ڵ��н���¼����������ۼ�
                    ptr = map_win[rspfn_ticket_d];

                    ptr->winningAmountWithTax += pRec_tmp_win->winningAmountWithTax;
                    ptr->winningAmount += pRec_tmp_win->winningAmount;
                    ptr->taxAmount += pRec_tmp_win->taxAmount;
                    ptr->winningCount += pRec_tmp_win->winningCount;
                    ptr->hd_winning += pRec_tmp_win->hd_winning;
                    ptr->hd_count += pRec_tmp_win->hd_count;
                    ptr->ld_winning += pRec_tmp_win->ld_winning;
                    ptr->ld_count += pRec_tmp_win->ld_count;

                    if (ptr->hd_winning + ptr->ld_winning >= big_prize)
                    {
                        ptr->isBigWinning = 1;
                    }
                    else
                    {
                        ptr->isBigWinning = 0;
                    }

                    int flag = 1;
                    int cnt_0 = ptr->prizeCount;
                    int prizeCnt = cnt_0;
                    for (int j = 0; j < pRec_tmp_win->prizeCount; j++)
                    {
                        flag = 1;
                        for (int i = 0; i < cnt_0; i++)
                        {
                            if ((ptr->prizeDetail[i].prizeCode == pRec_tmp_win->prizeDetail[j].prizeCode)
                                    && (ptr->prizeDetail[i].amountSingle == pRec_tmp_win->prizeDetail[j].amountSingle))
                            {
                                ptr->prizeDetail[i].count += pRec_tmp_win->prizeDetail[j].count;
                                ptr->prizeDetail[i].amountTax += pRec_tmp_win->prizeDetail[j].amountTax;
                                ptr->prizeDetail[i].amountBeforeTax += pRec_tmp_win->prizeDetail[j].amountBeforeTax;
                                ptr->prizeDetail[i].amountAfterTax += pRec_tmp_win->prizeDetail[j].amountAfterTax;
                                flag = 0;
                                break;
                            }
                        }
                        if (1 == flag)
                        {
                            ptr->prizeDetail[prizeCnt].count = pRec_tmp_win->prizeDetail[j].count;
                            ptr->prizeDetail[prizeCnt].amountTax = pRec_tmp_win->prizeDetail[j].amountTax;
                            ptr->prizeDetail[prizeCnt].amountBeforeTax = pRec_tmp_win->prizeDetail[j].amountBeforeTax;
                            ptr->prizeDetail[prizeCnt].amountAfterTax = pRec_tmp_win->prizeDetail[j].amountAfterTax;
                            ptr->prizeDetail[prizeCnt].amountSingle = pRec_tmp_win->prizeDetail[j].amountSingle;
                            ptr->prizeCount++;
                            prizeCnt++;
                        }
                    }
                    ptr->prizeDetail_length = sizeof(PRIZE_DETAIL) *  ptr->prizeCount;
                    
                }
                cnt++;
            }
            else if (rc == SQLITE_DONE)
            {
                //success break
                break;
            }
            else
            {
                //found error
                log_error("sqlite3_step error. (%d, %llu). ret[%d]", self->game_code, self->issue_number, rc);
                if (pStmt)
                    sqlite3_finalize(pStmt);
                return -1;
            }
        }
        sqlite3_finalize(pStmt);

        //�ж��Ƿ�����˳�ѭ��
        if ( 0 == cnt )
        {
            //����tmp_win_ticket_table���е����ݴ������
            break;
        }

        //��ʼ���������Ѷ�����tmp win ticket
        GIDB_WIN_TICKET_REC* ptr_win = NULL;
        WIN_TICKET_MAP::iterator iter;
        for(iter=map_win.begin();iter!=map_win.end();)
        {
            ptr_win = iter->second;

            memset(buf_win, 0, (1024 * 100));
            rc = self->gidb_w_get_ticket(self, ptr_win->unique_tsn, pRec_win);
            if ( rc < 0 )
            {
                log_error("gidb_w_get_ticket() error.");
                return -1;
            }
            else if ( 1 == rc )
            {
                //û���ҵ�
                list_insert.push_back(ptr_win);
            }
            else
            {
                //�ҵ��ˣ�����н����ۼ�����
                ptr_win->winningAmountWithTax += pRec_win->winningAmountWithTax;
                ptr_win->winningAmount += pRec_win->winningAmount;
                ptr_win->taxAmount += pRec_win->taxAmount;
                ptr_win->winningCount += pRec_win->winningCount;
                ptr_win->hd_winning += pRec_win->hd_winning;
                ptr_win->hd_count += pRec_win->hd_count;
                ptr_win->ld_winning += pRec_win->ld_winning;
                ptr_win->ld_count += pRec_win->ld_count;

                if (ptr_win->hd_winning + ptr_win->ld_winning >= big_prize)
                {
                    ptr_win->isBigWinning = 1;
                }
                else
                {
                    ptr_win->isBigWinning = 0;
                }

                int flag = 1;
                int cnt_0 = ptr_win->prizeCount;
                int prizeCnt = cnt_0;
                for (int j = 0; j < pRec_win->prizeCount; j++)
                {
                    flag = 1;
                    for (int i = 0; i < cnt_0; i++)
                    {
                        if ((ptr_win->prizeDetail[i].prizeCode == pRec_win->prizeDetail[j].prizeCode)
                                && (ptr_win->prizeDetail[i].amountSingle == pRec_win->prizeDetail[j].amountSingle))
                        {
                            ptr_win->prizeDetail[i].count += pRec_win->prizeDetail[j].count;
                            ptr_win->prizeDetail[i].amountTax += pRec_win->prizeDetail[j].amountTax;
                            ptr_win->prizeDetail[i].amountBeforeTax += pRec_win->prizeDetail[j].amountBeforeTax;
                            ptr_win->prizeDetail[i].amountAfterTax += pRec_win->prizeDetail[j].amountAfterTax;
                            flag = 0;
                            break;
                        }
                    }
                    if (1 == flag)
                    {
                        ptr_win->prizeDetail[prizeCnt].count = pRec_win->prizeDetail[j].count;
                        ptr_win->prizeDetail[prizeCnt].amountTax = pRec_win->prizeDetail[j].amountTax;
                        ptr_win->prizeDetail[prizeCnt].amountBeforeTax = pRec_win->prizeDetail[j].amountBeforeTax;
                        ptr_win->prizeDetail[prizeCnt].amountAfterTax = pRec_win->prizeDetail[j].amountAfterTax;
                        ptr_win->prizeDetail[prizeCnt].amountSingle = pRec_win->prizeDetail[j].amountSingle;
                        ptr_win->prizeCount++;
                        prizeCnt++;
                    }
                }
                ptr_win->prizeDetail_length = sizeof(PRIZE_DETAIL) *  ptr_win->prizeCount;

                list_update.push_back(ptr_win);
            }
            //��map��ɾ��
            map_win.erase(iter++);
        }

        //���������н�Ʊ(����Ʊ����ǰ�ڴ�û���н�����ǰ�ڴ����н�)
        const char *sql_insert_win_ticket = "INSERT INTO win_ticket_table ( \
            unique_tsn, \
            reqfn_ticket, \
            rspfn_ticket, \
            time_stamp, \
            from_sale, \
            area_code, \
            area_type, \
            agency_code, \
            terminal_code, \
            teller_code, \
            ap_code, \
            game_code, \
            issue_number, \
            issue_count, \
            sale_start_issue, \
            sale_start_issue_serial, \
            sale_end_issue, \
            total_bets, \
            ticket_amount, \
            claiming_scope, \
            is_train, \
            bet_string, \
            is_big_winning, \
            winning_amount_tax, \
            winning_amount, \
            tax_amount, \
            winning_count, \
            hd_winning, \
            hd_count, \
            ld_winning, \
            ld_count, \
            paid_status, \
            prize_count, \
            prize_detail, \
            vfyc ) VALUES ( \
            ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)";

        //��ʼ���µ�����
        if ( db_begin_transaction(self->db) < 0 )
        {
            log_error("db_begin_transaction(%d, %llu) error.", self->game_code, self->issue_number);
            return -1;
        }

        sqlite3_stmt* pStmt_insert = NULL;
        if (sqlite3_prepare_v2(self->db, sql_insert_win_ticket, strlen(sql_insert_win_ticket), &pStmt_insert, NULL) != SQLITE_OK)
        {
            log_error("sqlite3_prepare_v2() insert win ticket error.");
            if (pStmt_insert)
                sqlite3_finalize(pStmt_insert);
            return -1;
        }

        static unsigned char vfyc[64];
        uint32 vfyc_len = 0;
        GIDB_WIN_TICKET_REC* ptr_win_0 = NULL;
        while (!list_insert.empty())
        {
            ptr_win_0 = list_insert.front();
            ptr_win_0->paid_status = PRIZE_PAYMENT_PENDING;

            if (ts_calc_vfyc(WIN_TICKET_VFYC_T, ptr_win_0 , vfyc, &vfyc_len) != 0)
            {
                log_error("ts_calc_vfyc() failure.");
                return -1;
            }
            bind_winner_ticket(ptr_win_0, pStmt_insert, vfyc, vfyc_len);

            rc = sqlite3_step(pStmt_insert);
            if ( rc != SQLITE_DONE)
            {
                log_error("sqlite3_step() insert win ticket error. ret[%d]", rc);
                if (pStmt_insert)
                    sqlite3_finalize(pStmt_insert);
                return -1;
            }
            sqlite3_reset(pStmt_insert);

            free((char *)ptr_win_0);
            list_insert.pop_front();
        }
        sqlite3_finalize(pStmt_insert);

        //�����ύ
        if ( db_end_transaction(self->db) < 0 )
        {
            log_error("db_end_transaction(%d, %lld) error.", self->game_code, self->issue_number);
            return -1;
        }

        //���������н�Ʊ(����Ʊ����ǰ�ڴ��н�����ǰ�ڴ�Ҳ���н�)
        const char *sql_update_pay_ticket = "UPDATE win_ticket_table SET \
            is_big_winning=?, winning_amount_tax=?, winning_amount=?, tax_amount=?, \
            winning_count=?, hd_winning=?, hd_count=?, ld_winning=?, ld_count=?, \
            prize_count=?, prize_detail=?, vfyc=? WHERE unique_tsn=?";

        //��ʼ���µ�����
        if ( db_begin_transaction(self->db) < 0 )
        {
            log_error("db_begin_transaction(%d, %llu) error.", self->game_code, self->issue_number);
            return -1;
        }

        sqlite3_stmt* pStmt_update = NULL;
        if (sqlite3_prepare_v2(self->db, sql_update_pay_ticket, strlen(sql_update_pay_ticket), &pStmt_update, NULL) != SQLITE_OK)
        {
            log_error("sqlite3_prepare_v2() insert win ticket error.");
            if (pStmt_update)
                sqlite3_finalize(pStmt_update);
            return -1;
        }

        GIDB_WIN_TICKET_REC* ptr_win_1 = NULL;
        while (!list_update.empty())
        {
            ptr_win_1 = list_update.front();

            ptr_win_1->paid_status = PRIZE_PAYMENT_PENDING;

            if (ts_calc_vfyc(WIN_TICKET_VFYC_T, ptr_win_1 , vfyc, &vfyc_len) != 0)
            {
                log_error("ts_calc_vfyc() failure.");
                return -1;
            }

            sqlite3_bind_int(   pStmt_update, 1,   ptr_win_1->isBigWinning);
            sqlite3_bind_int64( pStmt_update, 2,   ptr_win_1->winningAmountWithTax);
            sqlite3_bind_int64( pStmt_update, 3,   ptr_win_1->winningAmount);
            sqlite3_bind_int64( pStmt_update, 4,   ptr_win_1->taxAmount);
            sqlite3_bind_int(   pStmt_update, 5,   ptr_win_1->winningCount);
            sqlite3_bind_int64( pStmt_update, 6,   ptr_win_1->hd_winning);
            sqlite3_bind_int(   pStmt_update, 7,   ptr_win_1->hd_count);
            sqlite3_bind_int64( pStmt_update, 8,   ptr_win_1->ld_winning);
            sqlite3_bind_int(   pStmt_update, 9,   ptr_win_1->ld_count);
            sqlite3_bind_int(   pStmt_update, 10,  ptr_win_1->prizeCount);
            sqlite3_bind_blob(  pStmt_update, 11,  (char *)ptr_win_1->prizeDetail, ptr_win_1->prizeDetail_length, SQLITE_TRANSIENT);
            sqlite3_bind_blob(  pStmt_update, 12,  vfyc, vfyc_len, SQLITE_TRANSIENT);
            sqlite3_bind_int64(  pStmt_update, 13,  ptr_win_1->unique_tsn);

            rc = sqlite3_step(pStmt_update);
            if ( rc != SQLITE_DONE)
            {
                log_error("sqlite3_step() update win ticket error. ret[%d]", rc);
                if (pStmt_update)
                    sqlite3_finalize(pStmt_update);
                return -1;
            }
            sqlite3_reset(pStmt_update);

            free((char *)ptr_win_1);
            list_update.pop_front();
        }
        sqlite3_finalize(pStmt_update);

        //�����ύ
        if ( db_end_transaction(self->db) < 0 )
        {
            log_error("db_end_transaction(%d, %llu) error.", self->game_code, self->issue_number);
            return -1;
        }

        //��ҳ��������
        offset += 1000;
    }
    return 0;
}


//get win ticket by rspfn_ticket   ( return  0=����  1=û���ҵ�  С��0=����)
int32 gidb_w_get_ticket(GIDB_W_TICKET_HANDLE *self, uint64 unique_tsn, GIDB_WIN_TICKET_REC *pTicketWin)
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

    sqlite3_bind_int64(  pStmt, 1, unique_tsn);

    rc = sqlite3_step(pStmt);
    if (rc == SQLITE_DONE)
    {
        log_info("gidb_w_get_ticket() return empty.");
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
    if ( get_winner_ticket_rec_from_stmt(pTicketWin, pStmt) < 0 )
    {
        log_error("get_winner_ticket_rec_from_stmt() failure!");
        sqlite3_finalize(pStmt);
        return -1;
    }

    sqlite3_finalize(pStmt);
    return 0;
}


static pthread_mutex_t w_mutex = PTHREAD_MUTEX_INITIALIZER;
//�ڴ����������MAP
static W_TICKET_MAP w_ticket_map;
//ͨ���ڴ���ŵõ�
GIDB_W_TICKET_HANDLE * map_w_get(uint8 game_code, uint64 issue_number, uint8 draw_times)
{
    uint64 key = (((uint64)game_code)<<56) + (((uint64)draw_times)<<48) + (uint64)issue_number;
    if (1 == w_ticket_map.count(key))
    {
        return w_ticket_map[key];
    }
    return NULL;
}
int32 map_w_set(uint8 game_code, uint64 issue_number, uint8 draw_times, GIDB_W_TICKET_HANDLE *ptr)
{
    if (NULL == ptr)
    {
        return -1;
    }
    uint64 key = (((uint64)game_code)<<56) + (((uint64)draw_times)<<48) + (uint64)issue_number;
    w_ticket_map[key] = ptr;
    return 0;
}



//��ʼ������MAP������
GIDB_W_TICKET_HANDLE * gidb_w_ticket_init(uint8 game_code, uint64 issue_number, uint8 draw_times)
{
    int32 ret = 0;

    char game_abbr[16];
    get_game_abbr(game_code, game_abbr);
    char db_path[256];
    ts_get_game_issue_ticket_win_filepath(game_abbr, issue_number, draw_times, db_path, 256);

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
        if ( gidb_w_create_table(db) < 0 )
        {
            log_error("gidb_w_create_table(%s) error.", db_path);
            return NULL;
        }
    }

    //����map
    GIDB_W_TICKET_HANDLE * ptr = NULL;
    ptr = (GIDB_W_TICKET_HANDLE *)malloc(sizeof(GIDB_W_TICKET_HANDLE));
    memset(ptr, 0, sizeof(GIDB_W_TICKET_HANDLE));
    new(ptr)_GIDB_W_TICKET_HANDLE();

    ptr->game_code = game_code;
    ptr->issue_number = issue_number;
    ptr->draw_times = draw_times;
    ptr->last_time = get_now();
    ptr->tmp_win_draw_issue = 0;
    ptr->db = db;

    //��ʼ������ָ��
    ptr->gidb_w_update_pay = gidb_w_update_pay;
    ptr->gidb_w_sync_pay_ticket = gidb_w_sync_pay_ticket;
    ptr->gidb_w_insert_ticket = gidb_w_insert_ticket;
    ptr->gidb_w_sync_ticket = gidb_w_sync_ticket;
    ptr->gidb_w_insert_tmp_ticket = gidb_w_insert_tmp_ticket;
    ptr->gidb_w_sync_tmp_ticket = gidb_w_sync_tmp_ticket;
    ptr->gidb_w_get_ticket = gidb_w_get_ticket;
    ptr->gidb_w_merge_tmp_ticket = gidb_w_merge_tmp_ticket;
    ptr->gidb_w_clean_tmp_ticket = gidb_w_clean_tmp_ticket;
    pthread_mutex_lock(&w_mutex);
    map_w_set(game_code, issue_number, draw_times, ptr);
    pthread_mutex_unlock(&w_mutex);
    log_info("gidb_w_ticket_init(%d, %llu) -> success.", game_code, issue_number);
    return ptr;
}


//ͨ���ڴ���ŵõ��ڴ�handle
GIDB_W_TICKET_HANDLE * gidb_w_get_handle(uint8 game_code, uint64 issue_number, uint8 draw_times)
{
    //�鿴MAP���Ƿ����
    pthread_mutex_lock(&w_mutex);
    GIDB_W_TICKET_HANDLE *ptr = map_w_get(game_code, issue_number, draw_times);
    if (NULL != ptr)
    {
        ptr->last_time = get_now();
        pthread_mutex_unlock(&w_mutex);
        return ptr;
    }
    pthread_mutex_unlock(&w_mutex);
    ptr = gidb_w_ticket_init(game_code, issue_number, draw_times);
    if (NULL == ptr)
    {
        log_error("gidb_w_ticket_init(%d, %llu, %d) failure!", game_code, issue_number, draw_times);
        return NULL;
    }
    return ptr;
}

uint32 gidb_w_last_clean_time = 0;
//������ʱ�䲻ʹ�õ�handle
int gidb_w_clean_handle_timeout()
{
    uint32 time_n = get_now();
    if ((time_n-gidb_w_last_clean_time) <= ISSUE_HANDLE_TIMEOUT)
        return 0;

    GIDB_W_TICKET_HANDLE* handle;
    W_TICKET_MAP::iterator iter;
    //��ȫ�ı���ɾ������������Ԫ��
    pthread_mutex_lock(&w_mutex);
    for(iter = w_ticket_map.begin(); iter!=w_ticket_map.end();)
    {
        handle = iter->second;
        if ( (time_n-handle->last_time) > ISSUE_HANDLE_TIMEOUT )
        {
            db_close(handle->db);
            free((void *)handle);

            w_ticket_map.erase(iter++);
        }
        else
        {
            ++iter;
        }
    }
    pthread_mutex_unlock(&w_mutex);
    gidb_w_last_clean_time = time_n;
    return 0;
}

//�����г����˳��󣬹ر����д򿪵�db�ļ�
int32 gidb_w_close_handle()
{
    W_TICKET_MAP::iterator tt;
    GIDB_W_TICKET_HANDLE* pt = NULL;
    pthread_mutex_lock(&w_mutex);
    for(tt=w_ticket_map.begin(); tt!=w_ticket_map.end();)
    {
        pt = tt->second;
        db_close(pt->db);
        free((char *)pt);

        w_ticket_map.erase(tt++);
    }
    pthread_mutex_unlock(&w_mutex);
    log_info("gidb_w_close_handle() success!");
    return 0;
}

int32 gidb_delete_win_ticket_db(uint8 game_code, uint64 issue_number, uint8 draw_times)
{
    //�õ��������������ļ�·��
    char game_abbr[16];
    get_game_abbr(game_code, game_abbr);
    char win_ticket_db_path[256];
    ts_get_game_issue_ticket_win_filepath(game_abbr, issue_number, draw_times, win_ticket_db_path, 256);

    //ɾ��ԭ�е��н������ļ�
    char cmd_str[64] = {0};
    sprintf(cmd_str, "rm -rf %s", win_ticket_db_path);
    system(cmd_str);
    return 0;
}

#endif


#if R("---GIDB SQLITE operation function---")

//bind  GIDB_TICKET_IDX_REC to sqlite3_stmt  for insert
int32 bind_ticket_idx(GIDB_TICKET_IDX_REC *pTIdxRec, sqlite3_stmt* pStmt)
{
    sqlite3_bind_int64( pStmt, 1,   pTIdxRec->unique_tsn);
    sqlite3_bind_text(  pStmt, 2,   pTIdxRec->reqfn_ticket, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_text(  pStmt, 3,   pTIdxRec->rspfn_ticket, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_int(   pStmt, 4,   pTIdxRec->gameCode);
    sqlite3_bind_int64( pStmt, 5,   pTIdxRec->issueNumber);
    sqlite3_bind_int64( pStmt, 6,   pTIdxRec->drawIssueNumber);
    sqlite3_bind_int(   pStmt, 7,   pTIdxRec->from_sale);
    sqlite3_bind_blob(  pStmt, 8,   pTIdxRec->extend, pTIdxRec->extend_len, SQLITE_TRANSIENT);
    return 0;    
}

//bind  GIDB_SALE_TICKET_REC to sqlite3_stmt  for insert
int32 bind_sale_ticket(GIDB_SALE_TICKET_REC *pSaleRec, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len)
{
    sqlite3_bind_int(   pStmt, 1,   pSaleRec->from_sale);
    sqlite3_bind_int64( pStmt, 2,   pSaleRec->unique_tsn);
    sqlite3_bind_text(  pStmt, 3,   pSaleRec->reqfn_ticket, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_text(  pStmt, 4,   pSaleRec->rspfn_ticket, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_int64( pStmt, 5,   pSaleRec->timeStamp);

    sqlite3_bind_int(   pStmt, 6,   pSaleRec->ticket.gameCode);
    sqlite3_bind_int64( pStmt, 7,   pSaleRec->issueNumber);
    sqlite3_bind_int(   pStmt, 8,   pSaleRec->ticket.issueCount);
    sqlite3_bind_int64( pStmt, 9,   pSaleRec->ticket.issue);
    sqlite3_bind_int(   pStmt, 10,   pSaleRec->ticket.issueSeq);
    sqlite3_bind_int64( pStmt, 11,  pSaleRec->ticket.lastIssue);
    sqlite3_bind_int(   pStmt, 12,  pSaleRec->ticket.betCount);
    sqlite3_bind_int64( pStmt, 13,  pSaleRec->ticket.amount);
    sqlite3_bind_int64( pStmt, 14,  pSaleRec->commissionAmount);
    sqlite3_bind_int(   pStmt, 15,  pSaleRec->claimingScope);
    sqlite3_bind_int64( pStmt, 16,  pSaleRec->drawTimeStamp);
    sqlite3_bind_int(   pStmt, 17,  pSaleRec->isTrain);
    sqlite3_bind_int(   pStmt, 18,  pSaleRec->ticket.betlineCount);
    sqlite3_bind_text(  pStmt, 19,  pSaleRec->ticket.betString, pSaleRec->ticket.betStringLen, SQLITE_TRANSIENT);
    sqlite3_bind_blob(  pStmt, 20,  (char *)&pSaleRec->ticket, pSaleRec->ticket.length, SQLITE_TRANSIENT);

    sqlite3_bind_int(   pStmt, 21,  pSaleRec->areaCode);
    sqlite3_bind_int(   pStmt, 22,  pSaleRec->areaType);
    sqlite3_bind_int64( pStmt, 23,  pSaleRec->agencyCode);
    sqlite3_bind_int64( pStmt, 24,  pSaleRec->terminalCode);
    sqlite3_bind_int(   pStmt, 25,  pSaleRec->tellerCode);
    sqlite3_bind_int(   pStmt, 26,  pSaleRec->apCode);
    sqlite3_bind_int(   pStmt, 27,  pSaleRec->isCancel);
    sqlite3_bind_blob(  pStmt, 28,  vfyc, vfyc_len, SQLITE_TRANSIENT);

    return 0;    
}

//bind  GIDB_PAY_TICKET_STRUCT to sqlite3_stmt  for update pay table
int32 bind_update_pay_ticket(GIDB_PAY_TICKET_STRUCT *pPayRec, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len)
{
    sqlite3_bind_int(   pStmt, 1,   PRIZE_PAYMENT_PAID);
    sqlite3_bind_int(   pStmt, 2,   pPayRec->from_pay);
    sqlite3_bind_text(  pStmt, 3,   pPayRec->reqfn_ticket_pay, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_text(  pStmt, 4,   pPayRec->rspfn_ticket_pay, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_int64( pStmt, 5,   pPayRec->timeStamp_pay);

    sqlite3_bind_int64( pStmt, 6,   pPayRec->agencyCode_pay);
    sqlite3_bind_int64( pStmt, 7,   pPayRec->terminalCode_pay);
    sqlite3_bind_int(   pStmt, 8,   pPayRec->tellerCode_pay);
    sqlite3_bind_int(   pStmt, 9,  pPayRec->apCode_pay);

    sqlite3_bind_text(  pStmt, 10,  pPayRec->userName_pay, ENTRY_NAME_LEN, SQLITE_TRANSIENT);
    sqlite3_bind_int(   pStmt, 11,  pPayRec->identityType_pay);
    sqlite3_bind_text(  pStmt, 12,  pPayRec->identityNumber_pay, IDENTITY_CARD_LENGTH, SQLITE_TRANSIENT);

    sqlite3_bind_blob(  pStmt, 13,  vfyc, vfyc_len, SQLITE_TRANSIENT);
    sqlite3_bind_int64( pStmt, 14,  pPayRec->unique_tsn);
    return 0;
}


//bind  GIDB_CANCEL_TICKET_STRUCT to sqlite3_stmt  for update pay table
int32 bind_update_cancel_ticket(GIDB_CANCEL_TICKET_STRUCT *pCancelRec, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len)
{
    sqlite3_bind_int(   pStmt, 1,   1);
    sqlite3_bind_int(   pStmt, 2,   pCancelRec->from_cancel);
    sqlite3_bind_text(  pStmt, 3,   pCancelRec->reqfn_ticket_cancel, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_text(  pStmt, 4,   pCancelRec->rspfn_ticket_cancel, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_int64( pStmt, 5,   pCancelRec->timeStamp_cancel);

    sqlite3_bind_int64( pStmt, 6,   pCancelRec->agencyCode_cancel);
    sqlite3_bind_int64( pStmt, 7,   pCancelRec->terminalCode_cancel);
    sqlite3_bind_int(   pStmt, 8,   pCancelRec->tellerCode_cancel);
    sqlite3_bind_int(   pStmt, 9,   pCancelRec->apCode_cancel);

    sqlite3_bind_blob(  pStmt, 10,  vfyc, vfyc_len, SQLITE_TRANSIENT);
    sqlite3_bind_int64( pStmt, 11,  pCancelRec->unique_tsn);
    return 0;       
}


//bind  GIDB_WIN_TICKET_REC to sqlite3_stmt  for insert
int32 bind_winner_ticket(GIDB_WIN_TICKET_REC *pWinRec, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len)
{
    sqlite3_bind_int64( pStmt, 1,   pWinRec->unique_tsn);
    sqlite3_bind_text(  pStmt, 2,   pWinRec->reqfn_ticket, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_text(  pStmt, 3,   pWinRec->rspfn_ticket, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_int64( pStmt, 4,   pWinRec->timeStamp);
    sqlite3_bind_int(   pStmt, 5,   pWinRec->from_sale);

    sqlite3_bind_int(   pStmt, 6,   pWinRec->areaCode);
    sqlite3_bind_int(   pStmt, 7,   pWinRec->areaType);
    sqlite3_bind_int64( pStmt, 8,   pWinRec->agencyCode);
    sqlite3_bind_int64( pStmt, 9,   pWinRec->terminalCode);
    sqlite3_bind_int(   pStmt, 10,  pWinRec->tellerCode);
    sqlite3_bind_int(   pStmt, 11,  pWinRec->apCode);

    sqlite3_bind_int(   pStmt, 12,  pWinRec->gameCode);
    sqlite3_bind_int64( pStmt, 13,  pWinRec->issueNumber);
    sqlite3_bind_int(   pStmt, 14,  pWinRec->issueCount);
    sqlite3_bind_int64( pStmt, 15,  pWinRec->saleStartIssue);
    sqlite3_bind_int(   pStmt, 16,  pWinRec->saleStartIssueSerial);
    sqlite3_bind_int64( pStmt, 17,  pWinRec->saleEndIssue);
    sqlite3_bind_int(   pStmt, 18,  pWinRec->totalBets);
    sqlite3_bind_int64( pStmt, 19,  pWinRec->ticketAmount);
    sqlite3_bind_int(   pStmt, 20,  pWinRec->claimingScope);
    sqlite3_bind_int(   pStmt, 21,  pWinRec->isTrain);
    sqlite3_bind_text(  pStmt, 22,  pWinRec->bet_string, pWinRec->bet_string_len, SQLITE_TRANSIENT);

    sqlite3_bind_int(   pStmt, 23,  pWinRec->isBigWinning);
    sqlite3_bind_int64( pStmt, 24,  pWinRec->winningAmountWithTax);
    sqlite3_bind_int64( pStmt, 25,  pWinRec->winningAmount);
    sqlite3_bind_int64( pStmt, 26,  pWinRec->taxAmount);
    sqlite3_bind_int(   pStmt, 27,  pWinRec->winningCount);
    sqlite3_bind_int64( pStmt, 28,  pWinRec->hd_winning);
    sqlite3_bind_int(   pStmt, 29,  pWinRec->hd_count);
    sqlite3_bind_int64( pStmt, 30,  pWinRec->ld_winning);
    sqlite3_bind_int(   pStmt, 31,  pWinRec->ld_count);

    sqlite3_bind_int(   pStmt, 32,  pWinRec->paid_status);

    sqlite3_bind_int(   pStmt, 33,  pWinRec->prizeCount);
    sqlite3_bind_blob(  pStmt, 34,  (char *)pWinRec->prizeDetail, pWinRec->prizeDetail_length, SQLITE_TRANSIENT);
    sqlite3_bind_blob(  pStmt, 35,  vfyc, vfyc_len, SQLITE_TRANSIENT);
    return 0;
}

//bind  GIDB_TMP_WIN_TICKET_REC to sqlite3_stmt  for insert
int32 bind_tmp_winner_ticket(GIDB_TMP_WIN_TICKET_REC *pTmpWinRec, sqlite3_stmt* pStmt, unsigned char *vfyc, uint32 vfyc_len)
{
    sqlite3_bind_int64( pStmt, 1,   pTmpWinRec->unique_tsn);
    sqlite3_bind_text(  pStmt, 2,   pTmpWinRec->reqfn_ticket, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_text(  pStmt, 3,   pTmpWinRec->rspfn_ticket, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_int64( pStmt, 4,   pTmpWinRec->timeStamp);
    sqlite3_bind_int(   pStmt, 5,   pTmpWinRec->from_sale);

    sqlite3_bind_int(   pStmt, 6,   pTmpWinRec->areaCode);
    sqlite3_bind_int(   pStmt, 7,   pTmpWinRec->areaType);
    sqlite3_bind_int64( pStmt, 8,   pTmpWinRec->agencyCode);
    sqlite3_bind_int64( pStmt, 9,   pTmpWinRec->terminalCode);
    sqlite3_bind_int(   pStmt, 10,  pTmpWinRec->tellerCode);
    sqlite3_bind_int(   pStmt, 11,  pTmpWinRec->apCode);

    sqlite3_bind_int(   pStmt, 12,  pTmpWinRec->gameCode);
    sqlite3_bind_int64( pStmt, 13,  pTmpWinRec->issueNumber);
    sqlite3_bind_int(   pStmt, 14,  pTmpWinRec->issueCount);
    sqlite3_bind_int64( pStmt, 15,  pTmpWinRec->saleStartIssue);
    sqlite3_bind_int(   pStmt, 16,  pTmpWinRec->saleStartIssueSerial);
    sqlite3_bind_int64( pStmt, 17,  pTmpWinRec->saleEndIssue);
    sqlite3_bind_int(   pStmt, 18,  pTmpWinRec->totalBets);
    sqlite3_bind_int64( pStmt, 19,  pTmpWinRec->ticketAmount);
    sqlite3_bind_int(   pStmt, 20,  pTmpWinRec->claimingScope);
    sqlite3_bind_int(   pStmt, 21,  pTmpWinRec->isTrain);
    sqlite3_bind_text(  pStmt, 22,  pTmpWinRec->bet_string, pTmpWinRec->bet_string_len, SQLITE_TRANSIENT);

    sqlite3_bind_int(   pStmt, 23,  pTmpWinRec->isBigWinning);
    sqlite3_bind_int64( pStmt, 24,  pTmpWinRec->winningAmountWithTax);
    sqlite3_bind_int64( pStmt, 25,  pTmpWinRec->winningAmount);
    sqlite3_bind_int64( pStmt, 26,  pTmpWinRec->taxAmount);
    sqlite3_bind_int(   pStmt, 27,  pTmpWinRec->winningCount);
    sqlite3_bind_int64( pStmt, 28,  pTmpWinRec->hd_winning);
    sqlite3_bind_int(   pStmt, 29,  pTmpWinRec->hd_count);
    sqlite3_bind_int64( pStmt, 30,  pTmpWinRec->ld_winning);
    sqlite3_bind_int(   pStmt, 31,  pTmpWinRec->ld_count);

    sqlite3_bind_int(   pStmt, 32,  pTmpWinRec->prizeCount);
    sqlite3_bind_blob(  pStmt, 33,  (char *)pTmpWinRec->prizeDetail, pTmpWinRec->prizeDetail_length, SQLITE_TRANSIENT);

    sqlite3_bind_int(   pStmt, 34,  pTmpWinRec->win_issue_number);
    sqlite3_bind_blob(  pStmt, 35,  vfyc, vfyc_len, SQLITE_TRANSIENT);
    return 0;
}

//bind  GIDB_MATCH_TICKET_REC to sqlite3_stmt  for insert
int32 bind_match_ticket(GIDB_MATCH_TICKET_REC *pMatchRec, sqlite3_stmt* pStmt)
{
    sqlite3_bind_int64( pStmt, 1,   pMatchRec->unique_tsn);
    sqlite3_bind_text(  pStmt, 2,   pMatchRec->reqfn_ticket, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_text(  pStmt, 3,   pMatchRec->rspfn_ticket, (TSN_LENGTH-1), SQLITE_TRANSIENT);
    sqlite3_bind_int64( pStmt, 4,   pMatchRec->timeStamp);
    sqlite3_bind_int(   pStmt, 5,   pMatchRec->from_sale);

    sqlite3_bind_int(   pStmt, 6,   pMatchRec->areaCode);
    sqlite3_bind_int(   pStmt, 7,   pMatchRec->areaType);
    sqlite3_bind_int64( pStmt, 8,   pMatchRec->agencyCode);
    sqlite3_bind_int64( pStmt, 9,   pMatchRec->terminalCode);
    sqlite3_bind_int(   pStmt, 10,  pMatchRec->tellerCode);
    sqlite3_bind_int(   pStmt, 11,  pMatchRec->apCode);

    sqlite3_bind_int(   pStmt, 12,  pMatchRec->gameCode);
    sqlite3_bind_int64( pStmt, 13,  pMatchRec->issueNumber);
    sqlite3_bind_int(   pStmt, 14,  pMatchRec->issueCount);
    sqlite3_bind_int64( pStmt, 15,  pMatchRec->saleStartIssue);
    sqlite3_bind_int(   pStmt, 16,  pMatchRec->saleStartIssueSerial);
    sqlite3_bind_int64( pStmt, 17,  pMatchRec->saleEndIssue);
    sqlite3_bind_int(   pStmt, 18,  pMatchRec->totalBets);
    sqlite3_bind_int64( pStmt, 19,  pMatchRec->ticketAmount);
    sqlite3_bind_int(   pStmt, 20,  pMatchRec->claimingScope);
    sqlite3_bind_int(   pStmt, 21,  pMatchRec->isTrain);
    sqlite3_bind_text(  pStmt, 22,  pMatchRec->betString, pMatchRec->betStringLen, SQLITE_TRANSIENT);
    sqlite3_bind_blob(  pStmt, 23,  (char *)pMatchRec->match_result, sizeof(VALUE_TRIPLE)*MAX_PRIZE_COUNT, SQLITE_TRANSIENT);
    return 0;    
}




//�Ӷ�����һ��Ʊ������¼������ GIDB_TICKET_IDX_REC ��Ϣ
int32 get_ticket_idx_rec_from_stmt(GIDB_TICKET_IDX_REC *pTIdxRec, sqlite3_stmt* pStmt)
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
    pTIdxRec->extend_len = sqlite3_column_bytes(pStmt, 7);
    ptr = (char *)sqlite3_column_blob(pStmt, 7);
    memcpy(pTIdxRec->extend, ptr, pTIdxRec->extend_len);

    return 0;
}


//�Ӷ�����һ����Ʊ����¼������ GIDB_SALE_TICKET_REC ��Ϣ
int32 get_sale_ticket_rec_from_stmt(GIDB_SALE_TICKET_REC *pRec, sqlite3_stmt* pStmt)
{
    char * ptr = NULL;
    
    pRec->from_sale = sqlite3_column_int(pStmt, 0);

    pRec->unique_tsn = sqlite3_column_int64(pStmt, 1);
    ptr = (char *)sqlite3_column_text(pStmt, 2);
    strcpy(pRec->reqfn_ticket, ptr);
    ptr = (char *)sqlite3_column_text(pStmt, 3);
    strcpy(pRec->rspfn_ticket, ptr);
    pRec->timeStamp = sqlite3_column_int64(pStmt, 4);

    pRec->ticket.gameCode = sqlite3_column_int(pStmt, 5);
    pRec->issueNumber = sqlite3_column_int64(pStmt, 6);
    pRec->ticket.issueCount = sqlite3_column_int(pStmt, 7);
    pRec->ticket.issue = sqlite3_column_int64(pStmt, 8);
    pRec->ticket.issueSeq = sqlite3_column_int(pStmt, 9);
    pRec->ticket.lastIssue = sqlite3_column_int64(pStmt, 10);
    pRec->ticket.betCount = sqlite3_column_int(pStmt, 11);
    pRec->ticket.amount = sqlite3_column_int64(pStmt, 12);
    pRec->commissionAmount = sqlite3_column_int64(pStmt, 13);
    pRec->claimingScope = sqlite3_column_int(pStmt, 14);
    pRec->drawTimeStamp = sqlite3_column_int64(pStmt, 15);
    pRec->ticket.isTrain = sqlite3_column_int(pStmt, 16);
    pRec->isTrain = pRec->ticket.isTrain;
    pRec->ticket.flag = 0;
    pRec->ticket.betlineCount = sqlite3_column_int(pStmt, 17);

    ptr = (char *)sqlite3_column_text(pStmt, 18);
    pRec->ticket.betStringLen = sqlite3_column_bytes(pStmt, 18);
    strncpy(pRec->ticket.betString, ptr, pRec->ticket.betStringLen);

    ptr = (char *)sqlite3_column_blob(pStmt, 19);
    pRec->ticket.length = sqlite3_column_bytes(pStmt, 19);
    memcpy((char *)&pRec->ticket, ptr, pRec->ticket.length);

    pRec->areaCode = sqlite3_column_int(pStmt, 20);
    pRec->areaType = sqlite3_column_int(pStmt, 21);
    pRec->agencyCode = sqlite3_column_int64(pStmt, 22);
    pRec->terminalCode = sqlite3_column_int64(pStmt, 23);
    pRec->tellerCode = sqlite3_column_int(pStmt, 24);
    pRec->apCode = sqlite3_column_int(pStmt, 25);

    pRec->isCancel = sqlite3_column_int(pStmt, 26);
    if(pRec->isCancel)
    {
        pRec->from_cancel = sqlite3_column_int(pStmt, 27);
        ptr = (char *)sqlite3_column_text(pStmt, 28);
        strcpy(pRec->reqfn_ticket_cancel, ptr);
        ptr = (char *)sqlite3_column_text(pStmt, 29);
        strcpy(pRec->rspfn_ticket_cancel, ptr);
        pRec->timeStamp_cancel = sqlite3_column_int64(pStmt, 30);
        pRec->agencyCode_cancel = sqlite3_column_int64(pStmt, 31);
        pRec->terminalCode_cancel = sqlite3_column_int64(pStmt, 32);
        pRec->tellerCode_cancel = sqlite3_column_int(pStmt, 33);
        pRec->apCode_cancel = sqlite3_column_int(pStmt, 34);
    }
    unsigned char *vfyc = (unsigned char *)sqlite3_column_blob(pStmt, 35);
    uint32 vfyc_len = sqlite3_column_bytes(pStmt, 35);

    if (ts_check_vfyc(SALE_TICKET_VFYC_T, pRec, vfyc, vfyc_len) != 0)
    {
        log_error("ts_check_vfyc(SALE_TICKET_VFYC_T) failure. rspfn_ticket->%s", pRec->rspfn_ticket);
        return -1;
    }
    return 0;
}

//�Ӷ�����һ���н�����¼������ GIDB_WIN_TICKET_REC ��Ϣ
int32 get_winner_ticket_rec_from_stmt(GIDB_WIN_TICKET_REC *pRec, sqlite3_stmt* pStmt)
{
    char * ptr = NULL;

    //��һ������,ע��˴��Ǵ�0��ʼ��
    pRec->unique_tsn = sqlite3_column_int64(pStmt, 0);
    ptr = (char *)sqlite3_column_text(pStmt, 1);
    strcpy(pRec->reqfn_ticket, ptr);
    ptr = (char *)sqlite3_column_text(pStmt, 2);
    strcpy(pRec->rspfn_ticket, ptr);
    pRec->timeStamp = sqlite3_column_int64(pStmt, 3);
    pRec->from_sale = sqlite3_column_int(pStmt, 4);
    pRec->areaCode = sqlite3_column_int(pStmt, 5);
    pRec->areaType = sqlite3_column_int(pStmt, 6);
    pRec->agencyCode = sqlite3_column_int64(pStmt, 7);
    pRec->terminalCode = sqlite3_column_int64(pStmt, 8);
    pRec->tellerCode = sqlite3_column_int(pStmt, 9);
    pRec->apCode = sqlite3_column_int(pStmt, 10);

    pRec->gameCode = sqlite3_column_int(pStmt, 11);
    pRec->issueNumber = sqlite3_column_int64(pStmt, 12);
    pRec->issueCount = sqlite3_column_int(pStmt, 13);
    pRec->saleStartIssue = sqlite3_column_int64(pStmt, 14);
    pRec->saleStartIssueSerial = sqlite3_column_int(pStmt, 15);
    pRec->saleEndIssue = sqlite3_column_int64(pStmt, 16);
    pRec->totalBets = sqlite3_column_int(pStmt, 17);
    pRec->ticketAmount = sqlite3_column_int64(pStmt, 18);
    pRec->claimingScope = sqlite3_column_int(pStmt, 19);
    pRec->isTrain = sqlite3_column_int(pStmt, 20);
    ptr = (char *)sqlite3_column_text(pStmt, 21);
    pRec->bet_string_len = sqlite3_column_bytes(pStmt, 21);
    strncpy(pRec->bet_string, ptr, pRec->bet_string_len);

    pRec->isBigWinning = sqlite3_column_int(pStmt, 22);
    pRec->winningAmountWithTax = sqlite3_column_int64(pStmt, 23);
    pRec->winningAmount = sqlite3_column_int64(pStmt, 24);
    pRec->taxAmount = sqlite3_column_int64(pStmt, 25);
    pRec->winningCount = sqlite3_column_int(pStmt, 26);
    pRec->hd_winning = sqlite3_column_int64(pStmt, 27);
    pRec->hd_count = sqlite3_column_int(pStmt, 28);
    pRec->ld_winning = sqlite3_column_int64(pStmt, 29);
    pRec->ld_count = sqlite3_column_int(pStmt, 30);

    pRec->paid_status = sqlite3_column_int(pStmt, 31);
    if(pRec->paid_status == PRIZE_PAYMENT_PAID)
    {
        pRec->from_pay = sqlite3_column_int(pStmt, 32);
        ptr = (char *)sqlite3_column_text(pStmt, 33);
        strcpy(pRec->reqfn_ticket_pay, ptr);
        ptr = (char *)sqlite3_column_text(pStmt, 34);
        strcpy(pRec->rspfn_ticket_pay, ptr);
        pRec->timeStamp_pay = sqlite3_column_int64(pStmt, 35);

        pRec->agencyCode_pay = sqlite3_column_int64(pStmt, 36);
        pRec->terminalCode_pay = sqlite3_column_int64(pStmt, 37);
        pRec->tellerCode_pay = sqlite3_column_int(pStmt, 38);
        pRec->apCode_pay = sqlite3_column_int(pStmt, 39);
        ptr = (char *)sqlite3_column_text(pStmt, 40);
        if(ptr[0])
        {
            memcpy(pRec->userName_pay, ptr, ENTRY_NAME_LEN);
        }
        pRec->identityType_pay = sqlite3_column_int(pStmt, 41);
        ptr = (char *)sqlite3_column_text(pStmt, 42);
        if(ptr[0])
        {
            memcpy(pRec->identityNumber_pay, ptr, IDENTITY_CARD_LENGTH);
        }
    }

    pRec->prizeCount = sqlite3_column_int(pStmt, 43);
    ptr = (char *)sqlite3_column_blob(pStmt, 44);
    pRec->prizeDetail_length = sqlite3_column_bytes(pStmt, 44);
    memcpy((char *)pRec->prizeDetail, ptr, pRec->prizeDetail_length);

    unsigned char *vfyc = (unsigned char *)sqlite3_column_blob(pStmt, 45);
    uint32 vfyc_len = sqlite3_column_bytes(pStmt, 45);

    if (ts_check_vfyc(WIN_TICKET_VFYC_T, pRec, vfyc, vfyc_len) != 0)
    {
        log_error("ts_check_vfyc(WIN_TICKET_VFYC_T) failure. rspfn_ticket->%s", pRec->rspfn_ticket);
        return -1;
    }
    return 0;
}

//�Ӷ�����һ�������н�������¼������ GIDB_TMP_WIN_TICKET_REC ��Ϣ
int32 get_tmp_winner_ticket_rec_from_stmt(GIDB_TMP_WIN_TICKET_REC *pRec, sqlite3_stmt* pStmt)
{
    char * ptr = NULL;

    pRec->unique_tsn = sqlite3_column_int64(pStmt, 0);
    ptr = (char *)sqlite3_column_text(pStmt, 1);
    strcpy(pRec->reqfn_ticket, ptr);
    ptr = (char *)sqlite3_column_text(pStmt, 2);
    strcpy(pRec->rspfn_ticket, ptr);

    pRec->timeStamp = sqlite3_column_int64(pStmt, 3);

    pRec->from_sale = sqlite3_column_int(pStmt, 4);
    pRec->areaCode = sqlite3_column_int(pStmt, 5);
    pRec->areaType = sqlite3_column_int(pStmt, 6);
    pRec->agencyCode = sqlite3_column_int64(pStmt, 7);
    pRec->terminalCode = sqlite3_column_int64(pStmt, 8);
    pRec->tellerCode = sqlite3_column_int(pStmt, 9);
    pRec->apCode = sqlite3_column_int(pStmt, 10);

    pRec->gameCode = sqlite3_column_int(pStmt, 11);
    pRec->issueNumber = sqlite3_column_int64(pStmt, 12);
    pRec->issueCount = sqlite3_column_int(pStmt, 13);
    pRec->saleStartIssue = sqlite3_column_int64(pStmt, 14);
    pRec->saleStartIssueSerial = sqlite3_column_int(pStmt, 15);
    pRec->saleEndIssue = sqlite3_column_int64(pStmt, 16);
    pRec->totalBets = sqlite3_column_int(pStmt, 17);
    pRec->ticketAmount = sqlite3_column_int64(pStmt, 18);
    pRec->claimingScope = sqlite3_column_int(pStmt, 19);
    pRec->isTrain = sqlite3_column_int(pStmt, 20);

    ptr = (char *)sqlite3_column_text(pStmt, 21);
    pRec->bet_string_len = sqlite3_column_bytes(pStmt, 21);
    strncpy(pRec->bet_string, ptr, pRec->bet_string_len);

    pRec->isBigWinning = sqlite3_column_int(pStmt, 22);
    pRec->winningAmountWithTax = sqlite3_column_int64(pStmt, 23);
    pRec->winningAmount = sqlite3_column_int64(pStmt, 24);
    pRec->taxAmount = sqlite3_column_int64(pStmt, 25);
    pRec->winningCount = sqlite3_column_int(pStmt, 26);
    pRec->hd_winning = sqlite3_column_int64(pStmt, 27);
    pRec->hd_count = sqlite3_column_int(pStmt, 28);
    pRec->ld_winning = sqlite3_column_int64(pStmt, 29);
    pRec->ld_count = sqlite3_column_int(pStmt, 30);

    pRec->prizeCount = sqlite3_column_int(pStmt, 31);
    ptr = (char *)sqlite3_column_blob(pStmt, 32);
    pRec->prizeDetail_length = sqlite3_column_bytes(pStmt, 32);
    memcpy((char *)pRec->prizeDetail, ptr, pRec->prizeDetail_length);

    pRec->win_issue_number = sqlite3_column_int(pStmt, 33);

    unsigned char *vfyc = (unsigned char *)sqlite3_column_blob(pStmt, 34);
    uint32 vfyc_len = sqlite3_column_bytes(pStmt, 34);

    if (ts_check_vfyc(TMP_WIN_TICKET_VFYC_T, pRec, vfyc, vfyc_len) != 0)
    {
        log_error("ts_check_vfyc(TMP_WIN_TICKET_VFYC_T) failure. rspfn_ticket->%s", pRec->rspfn_ticket);
        return -1;
    }
    return 0;
}

//�Ӷ�����һ��ƥ��������¼������ GIDB_MATCH_TICKET_REC ��Ϣ
int32 get_match_ticket_rec_from_stmt(GIDB_MATCH_TICKET_REC *pRec, sqlite3_stmt* pStmt)
{
    char * ptr = NULL;
    int32 len = 0;

    pRec->unique_tsn = sqlite3_column_int64(pStmt, 0);
    ptr = (char *)sqlite3_column_text(pStmt, 1);
    strcpy(pRec->reqfn_ticket, ptr);
    ptr = (char *)sqlite3_column_text(pStmt, 2);
    strcpy(pRec->rspfn_ticket, ptr);
    pRec->timeStamp = sqlite3_column_int64(pStmt, 3);
    pRec->from_sale = sqlite3_column_int(pStmt, 4);
    pRec->areaCode = sqlite3_column_int(pStmt, 5);
    pRec->areaType = sqlite3_column_int(pStmt, 6);
    pRec->agencyCode = sqlite3_column_int64(pStmt, 7);
    pRec->terminalCode = sqlite3_column_int64(pStmt, 8);
    pRec->tellerCode = sqlite3_column_int(pStmt, 9);
    pRec->apCode = sqlite3_column_int(pStmt, 10);

    pRec->gameCode = sqlite3_column_int(pStmt, 11);
    pRec->issueNumber = sqlite3_column_int64(pStmt, 12);
    pRec->issueCount = sqlite3_column_int(pStmt, 13);
    pRec->saleStartIssue = sqlite3_column_int64(pStmt, 14);
    pRec->saleStartIssueSerial = sqlite3_column_int(pStmt, 15);
    pRec->saleEndIssue = sqlite3_column_int64(pStmt, 16);
    pRec->totalBets = sqlite3_column_int(pStmt, 17);
    pRec->ticketAmount = sqlite3_column_int64(pStmt, 18);
    pRec->claimingScope = sqlite3_column_int(pStmt, 19);
    pRec->isTrain = sqlite3_column_int(pStmt, 20);

    ptr = (char *)sqlite3_column_text(pStmt, 21);
    pRec->betStringLen = sqlite3_column_bytes(pStmt, 21);
    strncpy(pRec->betString, ptr, pRec->betStringLen);

    ptr = (char *)sqlite3_column_blob(pStmt, 22);
    len = sqlite3_column_bytes(pStmt, 22);
    memcpy((char *)pRec->match_result, ptr, len);
    return 0;
}

//ת�� GIDB_SALE_TICKET_REC ---->  GIDB_MATCH_TICKET_REC
int32 sale_ticket_2_match_ticket_rec(GIDB_SALE_TICKET_REC *pSaleRec, GIDB_MATCH_TICKET_REC * pMatchRec)
{
    memset((char *)pMatchRec, 0, sizeof(GIDB_MATCH_TICKET_REC));

    pMatchRec->unique_tsn = pSaleRec->unique_tsn;
    strcpy(pMatchRec->reqfn_ticket, pSaleRec->reqfn_ticket);
    strcpy(pMatchRec->rspfn_ticket, pSaleRec->rspfn_ticket);
    pMatchRec->timeStamp = pSaleRec->timeStamp;
    pMatchRec->from_sale = pSaleRec->from_sale;

    pMatchRec->areaCode = pSaleRec->areaCode;
    pMatchRec->areaType = pSaleRec->areaType;
    pMatchRec->agencyCode = pSaleRec->agencyCode;
    pMatchRec->terminalCode = pSaleRec->terminalCode;
    pMatchRec->tellerCode = pSaleRec->tellerCode;
    pMatchRec->apCode = pSaleRec->apCode;

    pMatchRec->gameCode = pSaleRec->ticket.gameCode;
    pMatchRec->issueNumber = pSaleRec->issueNumber;
    pMatchRec->issueCount = pSaleRec->ticket.issueCount;
    pMatchRec->saleStartIssue = pSaleRec->ticket.issue;
    pMatchRec->saleStartIssueSerial = pSaleRec->ticket.issueSeq;
    pMatchRec->saleEndIssue = pSaleRec->ticket.lastIssue;
    pMatchRec->totalBets = pSaleRec->ticket.betCount;
    pMatchRec->ticketAmount = pSaleRec->ticket.amount;
    pMatchRec->claimingScope = pSaleRec->claimingScope;
    pMatchRec->isTrain = pSaleRec->isTrain;

    memset((char *)pMatchRec->match_result, 0, sizeof(VALUE_TRIPLE)*MAX_PRIZE_COUNT );

    pMatchRec->betStringLen = pSaleRec->ticket.betStringLen;
    strcpy(pMatchRec->betString, pSaleRec->ticket.betString);
    return 0;
}


//ת�� GIDB_MATCH_TICKET_REC ---->  GIDB_WIN_TICKET_REC
int32 match_ticket_2_win_ticket_rec(GIDB_MATCH_TICKET_REC *pMatchRec, GIDB_WIN_TICKET_REC *pWinRec)
{
    memset((char *)pWinRec, 0, sizeof(GIDB_WIN_TICKET_REC));

    pWinRec->unique_tsn = pMatchRec->unique_tsn;
    strcpy(pWinRec->reqfn_ticket, pMatchRec->reqfn_ticket);
    strcpy(pWinRec->rspfn_ticket, pMatchRec->rspfn_ticket);
    pWinRec->timeStamp = pMatchRec->timeStamp;
    pWinRec->from_sale = pMatchRec->from_sale;           

    pWinRec->areaCode = pMatchRec->areaCode;        
    pWinRec->areaType = pMatchRec->areaType;            
    pWinRec->agencyCode = pMatchRec->agencyCode;          
    pWinRec->terminalCode = pMatchRec->terminalCode;        
    pWinRec->tellerCode = pMatchRec->tellerCode;          
    pWinRec->apCode = pMatchRec->apCode;              

    pWinRec->gameCode = pMatchRec->gameCode;            
    pWinRec->issueNumber = pMatchRec->issueNumber;         
    pWinRec->issueCount = pMatchRec->issueCount;          
    pWinRec->saleStartIssue = pMatchRec->saleStartIssue;      
    pWinRec->saleStartIssueSerial = pMatchRec->saleStartIssueSerial;
    pWinRec->saleEndIssue = pMatchRec->saleEndIssue;        
    pWinRec->totalBets = pMatchRec->totalBets;           
    pWinRec->ticketAmount = pMatchRec->ticketAmount;        
    pWinRec->claimingScope = pMatchRec->claimingScope;       
    pWinRec->isTrain = pMatchRec->isTrain;

    pWinRec->bet_string_len = pMatchRec->betStringLen;
    strcpy(pWinRec->bet_string, pMatchRec->betString);

    pWinRec->isBigWinning = 0;
    return 0;
}


//ת�� GIDB_WIN_TICKET_REC ---->  GIDB_TMP_WIN_TICKET_REC
int32 win_ticket_2_tmp_win_ticket_rec(GIDB_WIN_TICKET_REC *pWinRec, GIDB_TMP_WIN_TICKET_REC *pTmpWinRec)
{
    memset((char *)pTmpWinRec, 0, sizeof(GIDB_TMP_WIN_TICKET_REC));

    pTmpWinRec->unique_tsn = pWinRec->unique_tsn;
    strcpy(pTmpWinRec->reqfn_ticket, pWinRec->reqfn_ticket);
    strcpy(pTmpWinRec->rspfn_ticket, pWinRec->rspfn_ticket);
    pTmpWinRec->timeStamp = pWinRec->timeStamp;
    pTmpWinRec->from_sale = pWinRec->from_sale;

    pTmpWinRec->areaCode = pWinRec->areaCode; 
    pTmpWinRec->areaType = pWinRec->areaType;     
    pTmpWinRec->agencyCode = pWinRec->agencyCode;   
    pTmpWinRec->terminalCode = pWinRec->terminalCode; 
    pTmpWinRec->tellerCode = pWinRec->tellerCode;   
    pTmpWinRec->apCode = pWinRec->apCode;       

    pTmpWinRec->gameCode = pWinRec->gameCode;            
    pTmpWinRec->issueNumber = pWinRec->issueNumber;         
    pTmpWinRec->issueCount = pWinRec->issueCount;          
    pTmpWinRec->saleStartIssue = pWinRec->saleStartIssue;      
    pTmpWinRec->saleStartIssueSerial = pWinRec->saleStartIssueSerial;
    pTmpWinRec->saleEndIssue = pWinRec->saleEndIssue;        
    pTmpWinRec->totalBets = pWinRec->totalBets;           
    pTmpWinRec->ticketAmount = pWinRec->ticketAmount;        
    pTmpWinRec->claimingScope = pWinRec->claimingScope;       
    pTmpWinRec->isTrain = pWinRec->isTrain;             
    pTmpWinRec->bet_string_len = pWinRec->bet_string_len;
    strcpy(pTmpWinRec->bet_string, pWinRec->bet_string);

    pTmpWinRec->isBigWinning = pWinRec->isBigWinning;
    pTmpWinRec->winningAmountWithTax = pWinRec->winningAmountWithTax;
    pTmpWinRec->winningAmount = pWinRec->winningAmount;
    pTmpWinRec->taxAmount = pWinRec->taxAmount;
    pTmpWinRec->winningCount = pWinRec->winningCount;
    pTmpWinRec->hd_winning = pWinRec->hd_winning;
    pTmpWinRec->hd_count = pWinRec->hd_count;
    pTmpWinRec->ld_winning = pWinRec->ld_winning;
    pTmpWinRec->ld_count = pWinRec->ld_count;

    pTmpWinRec->prizeCount = pWinRec->prizeCount;
    pTmpWinRec->prizeDetail_length = pWinRec->prizeDetail_length;
    memcpy((char *)pTmpWinRec->prizeDetail, (char *)pWinRec->prizeDetail, pWinRec->prizeDetail_length);
    return 0;
}


//ת�� GIDB_TMP_WIN_TICKET_REC ---->  GIDB_WIN_TICKET_REC
int32 tmp_win_ticket_2_win_ticket_rec(GIDB_TMP_WIN_TICKET_REC *pTmpWinRec, GIDB_WIN_TICKET_REC *pWinRec)
{
    memset((char *)pWinRec, 0, sizeof(GIDB_WIN_TICKET_REC));

    pWinRec->unique_tsn = pTmpWinRec->unique_tsn;
    strcpy(pWinRec->reqfn_ticket, pTmpWinRec->reqfn_ticket);
    strcpy(pWinRec->rspfn_ticket, pTmpWinRec->rspfn_ticket);
    pWinRec->timeStamp = pTmpWinRec->timeStamp;
    pWinRec->from_sale = pTmpWinRec->from_sale;

    pWinRec->areaCode = pTmpWinRec->areaCode;
    pWinRec->areaType = pTmpWinRec->areaType;
    pWinRec->agencyCode = pTmpWinRec->agencyCode;   
    pWinRec->terminalCode = pTmpWinRec->terminalCode; 
    pWinRec->tellerCode = pTmpWinRec->tellerCode;   
    pWinRec->apCode = pTmpWinRec->apCode;       

    pWinRec->gameCode = pTmpWinRec->gameCode;            
    pWinRec->issueNumber = pTmpWinRec->issueNumber;         
    pWinRec->issueCount = pTmpWinRec->issueCount;          
    pWinRec->saleStartIssue = pTmpWinRec->saleStartIssue;      
    pWinRec->saleStartIssueSerial = pTmpWinRec->saleStartIssueSerial;
    pWinRec->saleEndIssue = pTmpWinRec->saleEndIssue;        
    pWinRec->totalBets = pTmpWinRec->totalBets;           
    pWinRec->ticketAmount = pTmpWinRec->ticketAmount;        
    pWinRec->claimingScope = pTmpWinRec->claimingScope;       
    pWinRec->isTrain = pTmpWinRec->isTrain;             
    pWinRec->bet_string_len = pTmpWinRec->bet_string_len;
    strcpy(pWinRec->bet_string, pTmpWinRec->bet_string);

    pWinRec->isBigWinning = pTmpWinRec->isBigWinning;
    pWinRec->winningAmountWithTax = pTmpWinRec->winningAmountWithTax;
    pWinRec->winningAmount = pTmpWinRec->winningAmount;
    pWinRec->taxAmount = pTmpWinRec->taxAmount;
    pWinRec->winningCount = pTmpWinRec->winningCount;
    pWinRec->hd_winning = pTmpWinRec->hd_winning;
    pWinRec->hd_count = pTmpWinRec->hd_count;
    pWinRec->ld_winning = pTmpWinRec->ld_winning;
    pWinRec->ld_count = pTmpWinRec->ld_count;

    //pWinRec->paid_status = 

    pWinRec->prizeCount = pTmpWinRec->prizeCount;
    pWinRec->prizeDetail_length = pTmpWinRec->prizeDetail_length;
    memcpy((char *)pWinRec->prizeDetail, (char *)pTmpWinRec->prizeDetail, pTmpWinRec->prizeDetail_length);
    return 0;
}



int32 T_sell_inm_rec_2_db_tidx_rec(INM_MSG_T_SELL_TICKET *pInmMsg, GIDB_TICKET_IDX_REC *pTIdxRec)
{
    pTIdxRec->unique_tsn = pInmMsg->unique_tsn;
    strcpy(pTIdxRec->reqfn_ticket, pInmMsg->reqfn_ticket);
    strcpy(pTIdxRec->rspfn_ticket, pInmMsg->rspfn_ticket);
    pTIdxRec->gameCode = pInmMsg->ticket.gameCode;
    pTIdxRec->issueNumber = pInmMsg->ticket.issue;
    pTIdxRec->drawIssueNumber = pInmMsg->ticket.lastIssue;
    pTIdxRec->from_sale = pInmMsg->header.inm_header.gltp_from;
    pTIdxRec->extend_len = 0;
    pTIdxRec->extend[0] = '\0';
    return 0;
}

int32 T_sell_inm_rec_2_db_ticket_rec(INM_MSG_T_SELL_TICKET *pInmMsg, GIDB_SALE_TICKET_REC *pTicket)
{
    strcpy(pTicket->reqfn_ticket, pInmMsg->reqfn_ticket);
    strcpy(pTicket->rspfn_ticket, pInmMsg->rspfn_ticket);
    pTicket->unique_tsn = pInmMsg->unique_tsn;
    pTicket->timeStamp = pInmMsg->header.inm_header.tfe_when;
    pTicket->from_sale = pInmMsg->header.inm_header.gltp_from;

    pTicket->issueNumber = pInmMsg->issueNumber;
    pTicket->commissionAmount = pInmMsg->commissionAmount;
    pTicket->claimingScope = 0; //pInmMsg->claimingScope; //__DEF_PIL
    pTicket->drawTimeStamp = pInmMsg->drawTimeStamp;

    pTicket->areaCode = pInmMsg->header.areaCode;
    pTicket->areaType = 0; //pInmMsg->header.areaType; //__DEF_PIL
    pTicket->agencyCode = pInmMsg->header.agencyCode;
    pTicket->terminalCode = pInmMsg->header.terminalCode;
    pTicket->tellerCode = pInmMsg->header.tellerCode;
    pTicket->apCode = 0;

    pTicket->isTrain = pInmMsg->ticket.isTrain;

    pTicket->isCancel = 0;

    //Ʊ��Ϣ
    memcpy((char *)&pTicket->ticket, (char *)&pInmMsg->ticket, pInmMsg->ticket.length);
    return 0;
}

int32 T_pay_inm_rec_2_db_ticket_rec(INM_MSG_T_PAY_TICKET *pInmMsg, GIDB_PAY_TICKET_STRUCT *pTicket)
{
    strcpy(pTicket->reqfn_ticket_pay, pInmMsg->reqfn_ticket_pay);
    strcpy(pTicket->rspfn_ticket_pay, pInmMsg->rspfn_ticket_pay);

    strcpy(pTicket->rspfn_ticket, pInmMsg->rspfn_ticket);
    pTicket->unique_tsn = pInmMsg->unique_tsn;

    pTicket->timeStamp_pay = pInmMsg->header.inm_header.tfe_when;

    pTicket->from_pay = pInmMsg->header.inm_header.gltp_from;
    
    pTicket->agencyCode_pay = pInmMsg->header.agencyCode;
    pTicket->terminalCode_pay = pInmMsg->header.terminalCode;
    pTicket->tellerCode_pay = pInmMsg->header.tellerCode;
    pTicket->apCode_pay= 0;
    pTicket->issueNumber_pay = pInmMsg->issueNumber_pay;

    //�Ҵ�ʹ�õ���Ϣ�ֶ�
    memcpy(pTicket->userName_pay, pInmMsg->name, ENTRY_NAME_LEN);
    pTicket->identityType_pay = pInmMsg->identityType;
    memcpy(pTicket->identityNumber_pay, pInmMsg->identityNumber, IDENTITY_CARD_LENGTH);

    pTicket->isTrain = pInmMsg->isTrain;

    pTicket->gameCode = pInmMsg->gameCode;
    pTicket->issueNumber = pInmMsg->saleStartIssue;
    pTicket->ticketAmount = pInmMsg->ticketAmount;
    pTicket->isBigWinning = pInmMsg->isBigWinning;
    pTicket->winningAmountWithTax = pInmMsg->winningAmountWithTax;
    pTicket->winningAmount = pInmMsg->winningAmount;
    pTicket->taxAmount = pInmMsg->taxAmount;
    pTicket->winningCount = pInmMsg->winningCount;
    pTicket->paid_status = PRIZE_PAYMENT_PAID;
    return 0;
}

int32 T_cancel_inm_rec_2_db_ticket_rec(INM_MSG_T_CANCEL_TICKET *pInmMsg, GIDB_CANCEL_TICKET_STRUCT *pTicket)
{
    strcpy(pTicket->reqfn_ticket_cancel, pInmMsg->reqfn_ticket_cancel);
    strcpy(pTicket->rspfn_ticket_cancel, pInmMsg->rspfn_ticket_cancel);

    strcpy(pTicket->rspfn_ticket, pInmMsg->rspfn_ticket);
    pTicket->unique_tsn = pInmMsg->unique_tsn;

    pTicket->timeStamp_cancel = pInmMsg->header.inm_header.tfe_when;

    pTicket->from_cancel = pInmMsg->header.inm_header.gltp_from;

    pTicket->agencyCode_cancel = pInmMsg->header.agencyCode;
    pTicket->terminalCode_cancel = pInmMsg->header.terminalCode;
    pTicket->tellerCode_cancel = pInmMsg->header.tellerCode;
    pTicket->apCode_cancel = 0;
    pTicket->isTrain = pInmMsg->ticket.isTrain;
    pTicket->cancelAmount = pInmMsg->ticket.amount;
    pTicket->betCount = pInmMsg->ticket.betCount;
    memcpy((char*)&pTicket->ticket, (char*)&pInmMsg->ticket, pInmMsg->ticket.length);
    return 0;
}

int32 O_pay_inm_rec_2_db_ticket_rec(INM_MSG_O_PAY_TICKET *pInmMsg, GIDB_PAY_TICKET_STRUCT *pTicket)
{
    strcpy(pTicket->reqfn_ticket_pay, pInmMsg->reqfn_ticket_pay);
    strcpy(pTicket->rspfn_ticket_pay, pInmMsg->rspfn_ticket_pay);

    strcpy(pTicket->rspfn_ticket, pInmMsg->rspfn_ticket);
    pTicket->unique_tsn = pInmMsg->unique_tsn;

    pTicket->timeStamp_pay = pInmMsg->header.inm_header.tfe_when;

    pTicket->from_pay = TICKET_FROM_OMS;

    pTicket->agencyCode_pay = pInmMsg->areaCode_pay;
    pTicket->terminalCode_pay = 0;
    pTicket->tellerCode_pay = 0;
    pTicket->apCode_pay= 0;
    pTicket->issueNumber_pay = pInmMsg->issueNumber_pay;

    //�Ҵ�ʹ�õ���Ϣ�ֶ�
    memcpy(pTicket->userName_pay, pInmMsg->name, ENTRY_NAME_LEN);
    pTicket->identityType_pay = pInmMsg->identityType;
    memcpy(pTicket->identityNumber_pay, pInmMsg->identityNumber, IDENTITY_CARD_LENGTH);

    pTicket->isTrain = pInmMsg->isTrain;

    pTicket->gameCode = pInmMsg->gameCode;
    pTicket->issueNumber = pInmMsg->saleStartIssue;
    pTicket->ticketAmount = pInmMsg->ticketAmount;
    pTicket->isBigWinning = pInmMsg->isBigWinning;
    pTicket->winningAmountWithTax = pInmMsg->winningAmountWithTax;
    pTicket->winningAmount = pInmMsg->winningAmount;
    pTicket->taxAmount = pInmMsg->taxAmount;
    pTicket->winningCount = pInmMsg->winningCount;
    pTicket->paid_status = PRIZE_PAYMENT_PAID;
    return 0;
}

int32 O_cancel_inm_rec_2_db_ticket_rec(INM_MSG_O_CANCEL_TICKET *pInmMsg, GIDB_CANCEL_TICKET_STRUCT *pTicket)
{
    strcpy(pTicket->reqfn_ticket_cancel, pInmMsg->reqfn_ticket_cancel);
    strcpy(pTicket->rspfn_ticket_cancel, pInmMsg->rspfn_ticket_cancel);

    strcpy(pTicket->rspfn_ticket, pInmMsg->rspfn_ticket);
    pTicket->unique_tsn = pInmMsg->unique_tsn;

    pTicket->timeStamp_cancel = pInmMsg->header.inm_header.tfe_when;

    pTicket->from_cancel = TICKET_FROM_OMS;

    pTicket->agencyCode_cancel = pInmMsg->areaCode_cancel;
    pTicket->terminalCode_cancel = 0;
    pTicket->tellerCode_cancel = 0;
    pTicket->apCode_cancel = 0;

    pTicket->isTrain = pInmMsg->ticket.isTrain;
    pTicket->cancelAmount = pInmMsg->ticket.amount;
    pTicket->betCount = pInmMsg->ticket.betCount;
    memcpy((char*)&pTicket->ticket, (char*)&pInmMsg->ticket, pInmMsg->ticket.length);
    return 0;
}

int32 AP_pay_inm_rec_2_db_ticket_rec(INM_MSG_AP_PAY_TICKET *pInmMsg, GIDB_PAY_TICKET_STRUCT *pTicket)
{
    strcpy(pTicket->reqfn_ticket_pay, pInmMsg->reqfn_ticket_pay);
    strcpy(pTicket->rspfn_ticket_pay, pInmMsg->rspfn_ticket_pay);

    strcpy(pTicket->rspfn_ticket, pInmMsg->rspfn_ticket_sell);
    pTicket->unique_tsn = pInmMsg->unique_tsn;

    pTicket->timeStamp_pay = pInmMsg->header.inm_header.tfe_when;

    pTicket->from_pay = TICKET_FROM_AP;

    pTicket->agencyCode_pay = pInmMsg->area_code;
    pTicket->terminalCode_pay = 0;
    pTicket->tellerCode_pay = 0;
    pTicket->apCode_pay = 0;
    pTicket->issueNumber_pay = 0;

    //�Ҵ�ʹ�õ���Ϣ�ֶ�


    pTicket->isTrain = 0;

    pTicket->gameCode = pInmMsg->game_code;
    pTicket->issueNumber = pInmMsg->issue;
    pTicket->ticketAmount = pInmMsg->ticketAmount;
    pTicket->isBigWinning = 0;
    pTicket->winningAmountWithTax = pInmMsg->winningAmountWithTax;
    pTicket->winningAmount = pInmMsg->winningAmount;
    pTicket->taxAmount = pInmMsg->taxAmount;
    pTicket->winningCount = pInmMsg->winningCount;
    pTicket->paid_status = PRIZE_PAYMENT_PAID;
    return 0;
}

#endif


//tfe_update����ʹ�ã� ͬ��������Ϸ�������ݵ����ݿ��ļ� spc -> sale & pay & cancel
int32 gidb_sync_all_spc_ticket()
{
    //ͬ������Ʊ����Ʊ
    GIDB_T_TICKET_HANDLE* t_handle;
    T_TICKET_MAP::iterator t_iter;
    for(t_iter = t_ticket_map.begin(); t_iter!=t_ticket_map.end();)
    {
        t_handle = t_iter->second;
        if ( t_handle->gidb_t_sync_sc_ticket(t_handle) < 0)
        {
            log_error("gidb_t_sync_sc_ticket(%d, %llu) error!", t_handle->game_code, t_handle->issue_number);
            return -1;
        }
        ++t_iter;
    }
    gidb_t_clean_handle_timeout();

    //ͬ���ҽ�Ʊ
    GIDB_W_TICKET_HANDLE* w_handle;
    W_TICKET_MAP::iterator w_iter;
    for(w_iter = w_ticket_map.begin(); w_iter!=w_ticket_map.end();)
    {
        w_handle = w_iter->second;
        if ( w_handle->gidb_w_sync_pay_ticket(w_handle) < 0)
        {
            log_error("gidb_w_sync_pay_ticket(%d, %llu) error!", w_handle->game_code, w_handle->issue_number);
            return -1;
        }
        ++w_iter;
    }
    gidb_w_clean_handle_timeout();
    return 0;
}

//tfe_update����ʹ�ã� ͬ��Ʊ�������� 
int32 gidb_sync_tidx_ticket()
{
    GIDB_TICKET_IDX_HANDLE* tidx_handle;
    TICKET_IDX_MAP::iterator tidx_iter;
    for(tidx_iter = ticket_idx_map.begin(); tidx_iter!=ticket_idx_map.end();)
    {
        tidx_handle = tidx_iter->second;
        if ( tidx_handle->gidb_tidx_sync(tidx_handle) < 0)
        {
            log_error("gidb_sync_tidx_ticket(%u) error!", tidx_handle->date);
            return -1;
        }
        ++tidx_iter;
    }
    gidb_tidx_clean_handle_timeout();

    return 0;
}

//ͬ��ָ����Ϸ������tmp win ticket �� ��ʱ�н��ļ���( Ϊ ����Ʊ���� )
//uint64 issue_number ��ǰ�Ŀ����ڵ��ں�
int32 gidb_sync_all_tmp_win_ticket(uint8 game_code, uint64 issue_number)
{
    GIDB_W_TICKET_HANDLE* w_handle;
    W_TICKET_MAP::iterator w_iter;
    for(w_iter=w_ticket_map.begin(); w_iter!=w_ticket_map.end(); ++w_iter)
    {
        w_handle = w_iter->second;
        if ( w_handle->game_code == game_code )
        {
            if ( w_handle->gidb_w_clean_tmp_ticket(w_handle, issue_number) < 0)
            {
                log_error("gidb_w_clean_tmp_ticket(%d, %llu, %llu) error!",
				    w_handle->game_code, w_handle->issue_number, issue_number);
                return -1;
        	}
            if ( w_handle->gidb_w_sync_tmp_ticket(w_handle) < 0)
            {
                log_error("gidb_w_sync_tmp_ticket(%d, %llu) error!", w_handle->game_code, w_handle->issue_number);
                return -1;
            }
        }
    }
    return 0;
}

//��������Ʊƥ��
int32 gidb_match_ticket_callback(uint8 game_code, uint64 issue_number, uint8 draw_times,
                                 match_ticket_callback match_func,
                                 ISSUE_REAL_STAT *pIssue_real_stat)
{
    int32 rc;
    int ret = 0;

    //�õ���Ʊ���ݵ�Handle
    GIDB_T_TICKET_HANDLE *t_handle = gidb_t_get_handle(game_code, issue_number);
    if (t_handle == NULL)
    {
        log_error("gidb_t_get_handle() failure! game[%d] issue_number[%llu]", game_code, issue_number);
        return -1;
    }

    //�õ�������Handle
    GIDB_DRAW_HANDLE *d_handle =  gidb_d_get_handle(game_code, issue_number, draw_times);
    if (d_handle == NULL)
    {
        log_error("gidb_d_get_handle() failure! game[%d] issue_number[%llu]", game_code, issue_number);
        return -1;
    }

    //�õ����ڴε��淨����
    static char subtype_buf[8*1024];
    int32 subtype_buf_len = 0;
    ret = t_handle->gidb_t_get_field_blob(t_handle, T_SUBTYPE_PARAMBLOB_KEY, subtype_buf, &subtype_buf_len);
    if (ret != 0)
    {
        log_error("gidb_t_get_field_blob(%d, %lld, T_SUBTYPE_PARAMBLOB_KEY) failure!", game_code, issue_number);
        return -1;
    }

    //�õ����ڴε��н���������
    static char division_buf[8*1024];
    int32 division_buf_len = 0;
    ret = t_handle->gidb_t_get_field_blob(t_handle, T_DIVISION_PARAMBLOB_KEY, division_buf, &division_buf_len);
    if (ret != 0)
    {
        log_error("gidb_t_get_field_blob(%d, %lld, T_DIVISION_PARAMBLOB_KEY) failure!", game_code, issue_number);
        return -1;
    }
    //�õ����ڴε��н���������
    static char prize_buf[8*1024];
    int32 prize_buf_len = 0;
    ret = t_handle->gidb_t_get_field_blob(t_handle, T_PRIZE_PARAMBLOB_KEY, prize_buf, &prize_buf_len);
    if (ret != 0)
    {
        log_error("gidb_t_get_field_blob(%d, %lld, T_PRIZE_PARAMBLOB_KEY) failure!", game_code, issue_number);
        return -1;
    }


    //ƥ����ȼ�¼,��ȡ��Ʊ��¼����
    char matchProgress[200] = {0};
    int64 saleCnt = 0;
    int64 matchCnt = 0;
    const char *sql_str = "SELECT count(*) FROM sale_ticket_table";
    sqlite3_stmt* pStmt = NULL;
    if (sqlite3_prepare_v2(t_handle->db, sql_str, strlen(sql_str), &pStmt, NULL) != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() error.");
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }
    rc = sqlite3_step(pStmt);
    if ( rc == SQLITE_ROW )
    {
        saleCnt = sqlite3_column_int64(pStmt, 0);
    }
    else if( rc == SQLITE_DONE)
    {
        //�ɹ��������
    }
    else
    {
        log_error("sqlite3_step error. game[%d] issue[%llu]. ret[%d]", game_code, issue_number, rc);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }
    sqlite3_finalize(pStmt);
	pStmt = NULL;


    //ƥ���¼����д�������
    int32 commit_cnt = 0;

    //���²�ѯ��Ʊ���е���Ʊ��¼
    static char buf_sale[1024 * 16] = {0};
    GIDB_SALE_TICKET_REC *pRec_sale = (GIDB_SALE_TICKET_REC *)buf_sale;

    static char buf_match[1024 * 16] = {0};
    GIDB_MATCH_TICKET_REC *pRec_match = (GIDB_MATCH_TICKET_REC *)buf_match;

    time_type start = get_now();

    sql_str = "SELECT * FROM sale_ticket_table";
    if (sqlite3_prepare_v2(t_handle->db, sql_str, strlen(sql_str), &pStmt, NULL) != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() error.");
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    time_type t1 = get_now();
    time_type t2 = t1;
    //ѭ����ȡ����Ʊ����
    while ( true )
    {
        rc = sqlite3_step(pStmt);
        if ( rc == SQLITE_ROW )
        {
            ++matchCnt;
            t2 = get_now();
            //ÿ5�룬��¼һ��ƥ�����
            if (t2 - t1 > 5)
            {
                t1 = t2;
                sprintf(matchProgress, "%lld/%lld", saleCnt, matchCnt);
                otl_set_issueMatchStr(game_code, issue_number, matchProgress);
                log_info("match progress. game[%d] issue[%lld] sale_ticket_count[%lld] match_count[%lld]",
                        game_code, issue_number, saleCnt, matchCnt);
            }

            memset(buf_sale, 0, (1024 * 16));
            memset(buf_match, 0, (1024 * 16));

            //�Ӷ�������Ʊ��¼���� GIDB_SALE_TICKET_REC �ṹ
            if ( get_sale_ticket_rec_from_stmt(pRec_sale, pStmt) < 0 )
            {
                log_error("get_sale_ticket_rec_from_stmt() failure!");
                if (pStmt)
                    sqlite3_finalize(pStmt);
                return -1;
            }

            //ͳ��ʵ����Ʊ��Ϣ(������ѵƱ)
            if (pRec_sale->isCancel == 1)
            {
                if (pRec_sale->isTrain == 0)
                {
                    pIssue_real_stat->cancel_tickets_count++;
                    pIssue_real_stat->cancel_bet_count += pRec_sale->ticket.betCount/ pRec_sale->ticket.issueCount;
                    pIssue_real_stat->cancel_money_amount += pRec_sale->ticket.amount / pRec_sale->ticket.issueCount;
                }
                continue;
            }

            //ͳ��ʵ��������Ϣ(������ѵƱ)
            if (pRec_sale->isTrain == 0)
            {
                pIssue_real_stat->sale_tickets_count++;
                pIssue_real_stat->sale_bet_count += pRec_sale->ticket.betCount/ pRec_sale->ticket.issueCount;
                pIssue_real_stat->sale_money_amount += pRec_sale->ticket.amount / pRec_sale->ticket.issueCount;
            }

            //��ʼƥ��
            uint32 results[MAX_PRIZE_COUNT];
            memset(results, 0, sizeof(results));

            ret = match_func(&pRec_sale->ticket, subtype_buf, division_buf, results);
            if (0 == ret)
            {
                //û���н���ȡ��һ��
                continue;
            }


            //�н���  --------------------------------------------------------------->

            //conver pRec_sale  ->  pRec_match struct
            sale_ticket_2_match_ticket_rec(pRec_sale, pRec_match);

            //����ѵƱ���ۼӱ��ڸ������н�����
            if (pRec_match->isTrain == 0)
            {
                int32 i;
                for (i = 0; i < MAX_PRIZE_COUNT; i++)
                {
                    pIssue_real_stat->prize_stat[i] += results[i];
                }
            }

            int cnt = 0;
            PRIZE_PARAM *param_ptr = ((GT_PRIZE_PARAM *)prize_buf)->prize_param;
            for (int i = 0; i < MAX_PRIZE_COUNT; ++i)
            {
                PRIZE_PARAM *pp = &param_ptr[i];
                if (!pp->used)
                    continue;
                if (0 == results[i])
                    continue;

                pRec_match->match_result[cnt].code = i;
                pRec_match->match_result[cnt].value = results[i];
                cnt++;



                //ANNOUNCE XML ---------------------------------
                if (pp->hflag)
                {
                    ANNOUNCE_HIGH_PRIZE *ptr = &pIssue_real_stat->a_high_prize[i];
                    ptr->prize_level = pp->prizeCode;
                    int agencyCnt = ptr->agency_count;
                    for (int iAgency = 0; iAgency < agencyCnt + 1; iAgency++)
                    {
                        if (ptr->agency[iAgency].agency_code == pRec_match->agencyCode) {
                            ptr->agency[iAgency].winner_count += results[i];
                            break;
                        } else if (ptr->agency[iAgency].agency_code == 0) {
                            ptr->agency[iAgency].agency_code = pRec_match->agencyCode;
                            ptr->agency[iAgency].winner_count = results[i];
                            ptr->agency_count++;
                            break;
                        }
                    }
                }
            }

            //��ƥ�������ݼ�¼����д�����ݿ�
            if ( d_handle->gidb_d_insert_ticket(d_handle, pRec_match) < 0 )
            {
                log_error("gidb_d_insert_ticket(%d, %llu) error.", game_code, issue_number);
                if (pStmt)
                    sqlite3_finalize(pStmt);
                return -1;
            }
            commit_cnt++;

            //ÿ10000���ύһ��ƥ����н�Ʊ
            if ( commit_cnt >= 10000 )
            {
                if ( d_handle->gidb_d_sync_ticket(d_handle) < 0 )
                {
                    if (pStmt)
                        sqlite3_finalize(pStmt);
                    return -1;
                }
                commit_cnt = 0;
            }
        }
        else if( rc == SQLITE_DONE)
        {
            //�ɹ��������
            break;
        }
        else
        {
            log_error("sqlite3_step error. game[%d] issue[%llu]. ret[%d]", game_code, issue_number, rc);
            if (pStmt)
                sqlite3_finalize(pStmt);
            return -1;
        }
    } //end while

    //�ύδ�ύ������
    if (commit_cnt > 0)
    {
        if ( d_handle->gidb_d_sync_ticket(d_handle) < 0 )
        {
            if (pStmt)
                sqlite3_finalize(pStmt);
            return -1;
        }
    }
    sqlite3_finalize(pStmt);

    sprintf(matchProgress, "%lld/%lld", saleCnt, saleCnt);
    otl_set_issueMatchStr(game_code, issue_number, matchProgress);
	log_info("match progress.  game[%d] issue[%lld] sale_ticket_count[%lld] match_count[%lld]",
            game_code, issue_number, saleCnt, matchCnt);

    time_type end = get_now();


    //���ƥ����ͳ����Ϣ
    char buf_time_start[64] = {0};
    fmt_time_t(start, DATETIME_FORMAT_EN, buf_time_start);
    char buf_time_end[64] = {0};
    fmt_time_t(end, DATETIME_FORMAT_EN, buf_time_end);

    log_info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    log_info("MATCH RESULT:  Game[%d] Issue[%llu] costTime[%d sec]", t_handle->game_code, t_handle->issue_number, (int32)(end - start));
    log_info("    startTime[ %s ]    endTime[ %s]", buf_time_start, buf_time_end);
    log_info("    Real sale ticket count [%d]", pIssue_real_stat->sale_tickets_count);
    log_info("    Real sale ticket amount [%lld]", pIssue_real_stat->sale_money_amount);
    log_info("    ------- prize level statistics -------");
    for (int32 i = 0; i < MAX_PRIZE_COUNT; i++)
    {
        if (pIssue_real_stat->prize_stat[i] > 0)
            log_info("      Level [%d]   Winner Count [%d]", i, pIssue_real_stat->prize_stat[i]);
    }
    //Ҳ�ɿ�������д󽱵�����վͳ��
    //------------>>>>>
    log_info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

    return 0;
}


//��ƥ���ļ������н�Ʊ��¼��
int32 gidb_win_ticket_callback(   uint8 game_code, uint64 issue_number, uint8 draw_times,
                                  PRIZE_LEVEL prize_level_array[MAX_PRIZE_COUNT],
                                  WIN_TICKET_STAT *winTktStat)
{
    int ret = 0;
    int32 rc;

    //�õ���Ʊ���ݵ�Handle
    GIDB_T_TICKET_HANDLE *t_handle = gidb_t_get_handle(game_code, issue_number);
    if (t_handle == NULL)
    {
        log_error("gidb_t_get_handle() failure! game[%d] issue_number[%llu]", game_code, issue_number);
        return -1;
    }
    //�õ����ڴε���Ϸ��������
    static char game_buf[4*1024];
    int32 game_buf_len = 0;
    ret = t_handle->gidb_t_get_field_blob(t_handle, T_GAME_PARAMBLOB_KEY, game_buf, &game_buf_len);
    if (ret != 0)
    {
        log_error("gidb_t_get_field_blob(%d, %llu, T_GAME_PARAMBLOB_KEY) failure!", game_code, issue_number);
        return -1;
    }
    GT_GAME_PARAM *game_param = (GT_GAME_PARAM *)game_buf;
    //�õ����ڴε��н���������
    static char prize_buf[8*1024];
    int32 prize_buf_len = 0;
    ret = t_handle->gidb_t_get_field_blob(t_handle, T_PRIZE_PARAMBLOB_KEY, prize_buf, &prize_buf_len);
    if (ret != 0)
    {
        log_error("gidb_t_get_field_blob(%d, %llu, T_PRIZE_PARAMBLOB_KEY) failure!", game_code, issue_number);
        return -1;
    }

    //�õ�������Handle
    GIDB_DRAW_HANDLE *d_handle =  gidb_d_get_handle(game_code, issue_number, draw_times);
    if (d_handle == NULL)
    {
        log_error("gidb_d_get_handle() failure! game[%d] issue_number[%llu]", game_code, issue_number);
        return -1;
    }

    //�õ��н���Handle
    GIDB_W_TICKET_HANDLE *w_handle =  gidb_w_get_handle(game_code, issue_number, draw_times);
    if (w_handle == NULL)
    {
        log_error("gidb_w_get_handle() failure! game[%d] issue_number[%llu]", game_code, issue_number);
        return -1;
    }


    //�� PRIZE_LEVEL �ṹ���� תΪ PRIZE_TABLE �ṹ���飬���ڼ��㽱��
    PRIZE_TABLE prize_table[MAX_PRIZE_COUNT];
    memset( (char *)prize_table, 0, sizeof(PRIZE_TABLE)*MAX_PRIZE_COUNT );
    for (int i = 0; i < MAX_PRIZE_COUNT; i++)
    {
        int prize_code = prize_level_array[i].prize_code;
        prize_table[prize_code].hflag = prize_level_array[i].hflag;
        prize_table[prize_code].money_amount = prize_level_array[i].money_amount;
        if (prize_level_array[i].money_amount >= game_param->taxStartAmount)
        {
            prize_table[prize_code].tax = prize_level_array[i].money_amount * game_param->taxRate/1000;
        }
    }

    //clean win_ticket_table data
    const char *sql_del_str = "DELETE FROM win_ticket_table";
    char *zErrMsg = 0;
    rc = sqlite3_exec(w_handle->db, sql_del_str, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("gidb delete win_ticket_table -> SQL error: %s",zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }


    //�н���¼����д�������
    int32 commit_cnt = 0;


    //���±�����ѯƥ���ļ�
    time_type start = get_now();

    char buf_match[1024 * 16] = {0};
    GIDB_MATCH_TICKET_REC *pRec_match = (GIDB_MATCH_TICKET_REC *)buf_match;

    char buf_win[1024 * 16] = {0};
    GIDB_WIN_TICKET_REC *pRec_win = (GIDB_WIN_TICKET_REC *)buf_win;

    char buf_tmp_win[1024 * 16] = {0};
    GIDB_TMP_WIN_TICKET_REC *pRec_tmp_win = (GIDB_TMP_WIN_TICKET_REC *)buf_tmp_win;
    int32 commit_cnt_tmp_win = 0;

    const char *sql_str = "SELECT * FROM match_ticket_table";
    sqlite3_stmt* pStmt = NULL;
    if (sqlite3_prepare_v2(d_handle->db, sql_str, strlen(sql_str), &pStmt, NULL) != SQLITE_OK)
    {
        log_error("sqlite3_prepare_v2() error.");
        if (pStmt)
            sqlite3_finalize(pStmt);
        return false;
    }


    //ѭ����ȡƥ��Ʊ����
    while ( true )
    {
        rc = sqlite3_step(pStmt);
        if ( rc == SQLITE_ROW )
        {
            memset(buf_match, 0, (1024 * 16));
            memset(buf_win, 0, (1024 * 16));

            if (pRec_win->isTrain == 0)
            {
                winTktStat->winCnt++;
            }

            //�Ӷ�����ƥ���¼���� GIDB_MATCH_TICKET_REC �ṹ
            get_match_ticket_rec_from_stmt(pRec_match, pStmt);

            //conver pRec_match  ->  pRec_win struct
            match_ticket_2_win_ticket_rec(pRec_match, pRec_win);

            pRec_win->winningAmountWithTax = 0;
            pRec_win->winningAmount = 0;
            pRec_win->taxAmount = 0;
            pRec_win->winningCount = 0;
            pRec_win->hd_winning = 0;
            pRec_win->hd_count = 0;
            pRec_win->ld_winning = 0;
            pRec_win->ld_count = 0;
            if (issue_number == pRec_win->saleEndIssue)
                pRec_win->paid_status = PRIZE_PAYMENT_PENDING;
            else
                pRec_win->paid_status = PRIZE_PAYMENT_NONE;

            int j = 0;
            PRIZE_PARAM *param_ptr = ((GT_PRIZE_PARAM *)prize_buf)->prize_param;
            for (int i = 0; i < MAX_PRIZE_COUNT; i++)
            {
                int prize_code = pRec_match->match_result[i].code;
                if (0 == pRec_match->match_result[i].value)
                {
                    break;
                }

                if (prize_table[prize_code].hflag)
                {
                    pRec_win->hd_count += pRec_match->match_result[i].value;
                    pRec_win->hd_winning += prize_table[prize_code].money_amount * pRec_match->match_result[i].value;
                }
                else
                {
                    pRec_win->ld_count += pRec_match->match_result[i].value;
                    pRec_win->ld_winning += prize_table[prize_code].money_amount * pRec_match->match_result[i].value;
                }

                pRec_win->prizeCount++;
                PRIZE_PARAM *pp = &param_ptr[prize_code];
                memcpy(pRec_win->prizeDetail[j].name, pp->prizeName, sizeof(pp->prizeName));
                pRec_win->prizeDetail[j].prizeCode = prize_code;
                pRec_win->prizeDetail[j].count = pRec_match->match_result[i].value;
                pRec_win->prizeDetail[j].amountSingle = prize_table[prize_code].money_amount;
                pRec_win->prizeDetail[j].amountTax = prize_table[prize_code].tax;
                pRec_win->prizeDetail[j].amountBeforeTax = prize_table[prize_code].money_amount * pRec_match->match_result[i].value;
                pRec_win->prizeDetail[j].amountAfterTax = (prize_table[prize_code].money_amount - prize_table[prize_code].tax) * pRec_match->match_result[i].value;
                j++;

                pRec_win->winningCount = pRec_win->hd_count + pRec_win->ld_count;
                pRec_win->taxAmount += prize_table[prize_code].tax * pRec_match->match_result[i].value;
                pRec_win->winningAmountWithTax += prize_table[prize_code].money_amount * pRec_match->match_result[i].value;
                pRec_win->winningAmount += (prize_table[prize_code].money_amount - prize_table[prize_code].tax) * pRec_match->match_result[i].value;
            }

            if (pRec_win->isTrain == 0)
            {
                if (pRec_win->hd_winning + pRec_win->ld_winning >= game_param->bigPrize) {
                    pRec_win->isBigWinning = 1;
                    winTktStat->bigPrizeCnt++;
                    winTktStat->bigPrizeAmount += pRec_win->hd_winning + pRec_win->ld_winning;
                } else {
                    winTktStat->smallPrizeCnt++;
                    winTktStat->smallPrizeAmount += pRec_win->hd_winning + pRec_win->ld_winning;
                    pRec_win->isBigWinning = 0;
                }
            }

            pRec_win->prizeDetail_length = sizeof(PRIZE_DETAIL) *  pRec_win->prizeCount;

            //���н�������ݼ�¼����д�����ݿ�
            if ( w_handle->gidb_w_insert_ticket(w_handle, pRec_win) < 0 )
            {
                log_error("gidb_w_insert_ticket(%d-%llu) file error.", game_code, issue_number);
                if (pStmt)
                    sqlite3_finalize(pStmt);
                return -1;
            }
            commit_cnt++;

            //ÿ10000���ύһ��ƥ����н�Ʊ
            if ( commit_cnt >= 10000 )
            {
                if ( w_handle->gidb_w_sync_ticket(w_handle) < 0 )
                {
                    log_error("gidb_w_sync_ticket(%d-%llu) file error.", game_code, issue_number);
                    if (pStmt)
                        sqlite3_finalize(pStmt);
                    return -1;
                }
                commit_cnt = 0;
            }

            if (issue_number != pRec_win->saleEndIssue)
            {
                //����Ʊ, ��ǰ�������һ��, ���н�����д�뵽��Ӧ��tmp_win_ticket��
                //�õ�����Ʊ���һ�ڵ��ںţ�Ȼ��ͨ���ںŵõ�handle��
                //�ٽ��н���Ϣд�� tmp_w_handle
                GIDB_W_TICKET_HANDLE * tmp_w_handle = gidb_w_get_handle(game_code, pRec_win->saleEndIssue, draw_times);
                if (NULL == tmp_w_handle)
                {
                    log_error("gidb_w_get_handle(%d, %llu, %d) tmp win db error.", game_code, pRec_win->saleEndIssue, draw_times);
                    if (pStmt)
                        sqlite3_finalize(pStmt);
                    return -1;
                }

                memset(buf_tmp_win, 0, (1024 * 16));
                win_ticket_2_tmp_win_ticket_rec(pRec_win, pRec_tmp_win);
                pRec_tmp_win->win_issue_number = issue_number;

                if ( tmp_w_handle->gidb_w_insert_tmp_ticket(tmp_w_handle, pRec_tmp_win) < 0 )
                {
                    log_error("gidb_w_insert_tmp_ticket(%d, %llu, %d) current_issue(%d, %llu) tmp win db error.",
                            game_code, pRec_win->saleEndIssue, draw_times, game_code, issue_number);
                    if (pStmt)
                        sqlite3_finalize(pStmt);
                    return -1;
                }
                commit_cnt_tmp_win++;

                if (commit_cnt_tmp_win >= 2000)
                {
                    if ( gidb_sync_all_tmp_win_ticket(game_code, issue_number) < 0 )
                    {
                        log_error("gidb_sync_all_tmp_win_ticket(%d) current_issue(%d, %llu) tmp win db error.",
                            game_code, game_code, issue_number);
                        if (pStmt)
                            sqlite3_finalize(pStmt);
                        return -1;
                    }
                    commit_cnt_tmp_win = 0;
                }
            }
        }
        else if ( rc == SQLITE_DONE)
        {
            //�ɹ��������
            break;
        }
        else
        {
            //error
            log_error("sqlite3_step error. ret[%d]", rc);
            if (pStmt)
                sqlite3_finalize(pStmt);
            return -1;
        }
    }  //end while

    //�ύδ�ύ���н�����
    if (commit_cnt > 0)
    {
        if ( w_handle->gidb_w_sync_ticket(w_handle) < 0 )
        {
            log_error("gidb_w_sync_ticket(%d, %llu) file error.", game_code, issue_number);
            if (pStmt)
                sqlite3_finalize(pStmt);
            return -1;
        }
    }

    //�ύδ�ύ���н���ʱƱ(Ϊ ����Ʊ ����)
    if ( commit_cnt_tmp_win > 0 )
    {
        if ( gidb_sync_all_tmp_win_ticket(game_code, issue_number) < 0 )
        {
            log_error("gidb_sync_all_tmp_win_ticket(%d) current_issue(%d, %llu) tmp win db error.",
                game_code, game_code, issue_number);
            if (pStmt)
                sqlite3_finalize(pStmt);
            return -1;
        }
    }
    sqlite3_finalize(pStmt);

    //�õ����� �н��ļ����ļ�·��
    char winFile[256] = {0};
	char game_abbr[16] = {0};
	get_game_abbr(game_code, game_abbr);
	ts_get_game_issue_win_data_filepath(game_abbr, issue_number, draw_times, winFile, 256);

    //>1�ο���ע�⴦��
    ret = gidb_generate_issue_win_file(game_code, issue_number, draw_times, winFile);
    if (ret != 0)
    {
    	log_error("gidb_generate_agency_win_file() error. game[%d] issue[%llu],draw_times[%d]",
    			game_code, issue_number, draw_times);
    	return -1;
    }

    //���棬��Ҫ����(���������һ�ڵ��н�Ʊ)����Ʊ
    //merge tmp_win_table �� win_ticket_table
    if (w_handle->gidb_w_merge_tmp_ticket(w_handle, game_param->bigPrize) < 0 )
    {
        log_error("gidb_w_merge_tmp_ticket(%d, %llu) error.", game_code, issue_number);
        return -1;
    }

    time_type end = get_now();

    //����㽱���ͳ����Ϣ
    char buf_time_start[64] = {0};
    fmt_time_t(start, DATETIME_FORMAT_EN, buf_time_start);
    char buf_time_end[64] = {0};
    fmt_time_t(end, DATETIME_FORMAT_EN, buf_time_end);

    log_info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    log_info("WIN RESULT:  Game[%d] Issue[%llu] costTime[%d sec]", game_code, issue_number, (int32)(end - start));
    log_info("    startTime[ %s ]    endTime[ %s]", buf_time_start, buf_time_end);
    //Ҳ�ɿ����������Ľ�������Ϣ������վ���ͳ����Ϣ
    //------------>>>>>
    log_info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

    return 0;

}





//====================================================================================================
typedef struct _TMP_SQLITE_EXEC {
    FILE    *fd;
    bool    used;
    money_t s_amount_r;//s_amount * (1 - ������ - ���ڻ������) ��������
    money_t s_amount_all;//�������۶�(������Ʊ��������Ʊ)

    uint32  s_ticketCnt;
    uint32  s_betCnt;
    money_t s_amount;//�������۶�(������Ʊ����������Ʊ��δ����)

    uint32  c_ticketCnt;
    uint32  c_betCnt;
    money_t c_amount;
} TMP_SQLITE_EXEC;

#define AREACNT  100
typedef struct _TMP_SEAL_STATE_XML {
    XMLElement *seal;
    XMLElement *state;
    XMLElement *game;
    XMLElement *issue;
    XMLElement *area_all;

    XMLElement *area[AREACNT];
    XMLElement *code[AREACNT];
    XMLElement *s_amount_r[AREACNT]; //s_amount * (1 - ������ - ���ڻ������)��������
    XMLElement *s_amount_all[AREACNT];//�������۶�(������Ʊ��������Ʊ)
    XMLElement *s_amount[AREACNT];//�������۶�(������Ʊ����������Ʊ��δ����)
    XMLElement *s_ticket_cnt[AREACNT];
    XMLElement *s_bet_cnt[AREACNT];
    XMLElement *c_amount[AREACNT];
    XMLElement *c_ticket_cnt[AREACNT];
    XMLElement *c_bet_cnt[AREACNT];
} TMP_SEAL_STATE_XML;

//���ʱ����ǰ����ͳ������, XML
int gidb_seal_state_file(uint8 game_code, uint64 issue_number, char *path, TMP_SQLITE_EXEC *data)
{
    int ret = rmdirs(path);
    if (0 != ret) {
        log_error("rmdirs fail. filename:%s", path);
        return -1;
    }

    //�� TMP_SQLITE_EXEC �л�ȡ���ݣ�����seal_state�ļ�
    XML *xmlFile = new XML(path);

    XMLElement *elRoot       = NULL;
    XMLElement *elState      = NULL;
    XMLElement *elStateLeaf  = NULL;

    //area
    XMLElement *elAreaAll    = NULL;
    XMLElement *elArea       = NULL;
    XMLElement *elAreaLeaf   = NULL;

#define contLen  99
    char xmlContent[contLen + 1] = {0};

    TMP_SEAL_STATE_XML xmlEl;
    memset(&xmlEl, 0, sizeof(xmlEl));

    xmlEl.seal               = new XMLElement(0, "seal");
    xmlEl.state              = new XMLElement(0, "state");
    xmlEl.game               = new XMLElement(0, "game");
    xmlEl.issue              = new XMLElement(0, "issue");
    xmlEl.area_all           = new XMLElement(0, "area_all");

    int usedCnt = 0;
    TMP_SQLITE_EXEC *pData = data;
    pData->used = true;
    for (int i = 0; i < AREACNT; i++)
    {
        if ( !(pData+i)->used )
        {
            continue;
        }
        xmlEl.area[usedCnt]                    = new XMLElement(0, "area");
        xmlEl.code[usedCnt]                    = new XMLElement(0, "code");
        xmlEl.s_amount_r[usedCnt]              = new XMLElement(0, "s_amount_r");
        xmlEl.s_amount_all[usedCnt]            = new XMLElement(0, "s_amount_all");
        xmlEl.s_amount[usedCnt]                = new XMLElement(0, "s_amount");
        xmlEl.s_ticket_cnt[usedCnt]            = new XMLElement(0, "s_ticket_cnt");
        xmlEl.s_bet_cnt[usedCnt]               = new XMLElement(0, "s_bet_cnt");
        xmlEl.c_amount[usedCnt]                = new XMLElement(0, "c_amount");
        xmlEl.c_ticket_cnt[usedCnt]            = new XMLElement(0, "c_ticket_cnt");
        xmlEl.c_bet_cnt[usedCnt]               = new XMLElement(0, "c_bet_cnt");

        usedCnt++;
    }

    xmlFile->SetRootElement(xmlEl.seal);
    elRoot = xmlFile->GetRootElement();

    elState = elRoot->AddElement(xmlEl.state);

    elStateLeaf = elState->AddElement(xmlEl.game);
    memset(xmlContent, 0, sizeof(xmlContent));
    snprintf(xmlContent, contLen, "%d", game_code);
    elStateLeaf->AddContent(xmlContent, 0);

    elStateLeaf = elState->AddElement(xmlEl.issue);
    memset(xmlContent, 0, sizeof(xmlContent));
    snprintf(xmlContent, contLen, "%llu", issue_number);
    elStateLeaf->AddContent(xmlContent, 0);

    elStateLeaf = elState->AddElement(xmlEl.s_amount_r[0]);
    memset(xmlContent, 0, sizeof(xmlContent));
    snprintf(xmlContent, contLen, "%lld", pData->s_amount_r);
    elStateLeaf->AddContent(xmlContent, 0);

    elStateLeaf = elState->AddElement(xmlEl.s_amount_all[0]);
    memset(xmlContent, 0, sizeof(xmlContent));
    snprintf(xmlContent, contLen, "%lld", pData->s_amount_all);
    elStateLeaf->AddContent(xmlContent, 0);

    elStateLeaf = elState->AddElement(xmlEl.s_amount[0]);
    memset(xmlContent, 0, sizeof(xmlContent));
    snprintf(xmlContent, contLen, "%lld", pData->s_amount);
    elStateLeaf->AddContent(xmlContent, 0);

    elStateLeaf = elState->AddElement(xmlEl.s_ticket_cnt[0]);
    memset(xmlContent, 0, sizeof(xmlContent));
    snprintf(xmlContent, contLen, "%d", pData->s_ticketCnt);
    elStateLeaf->AddContent(xmlContent, 0);

    elStateLeaf = elState->AddElement(xmlEl.s_bet_cnt[0]);
    memset(xmlContent, 0, sizeof(xmlContent));
    snprintf(xmlContent, contLen, "%d", pData->s_betCnt);
    elStateLeaf->AddContent(xmlContent, 0);

    elStateLeaf = elState->AddElement(xmlEl.c_amount[0]);
    memset(xmlContent, 0, sizeof(xmlContent));
    snprintf(xmlContent, contLen, "%lld", pData->c_amount);
    elStateLeaf->AddContent(xmlContent, 0);

    elStateLeaf = elState->AddElement(xmlEl.c_ticket_cnt[0]);
    memset(xmlContent, 0, sizeof(xmlContent));
    snprintf(xmlContent, contLen, "%d", pData->c_ticketCnt);
    elStateLeaf->AddContent(xmlContent, 0);

    elStateLeaf = elState->AddElement(xmlEl.c_bet_cnt[0]);
    memset(xmlContent, 0, sizeof(xmlContent));
    snprintf(xmlContent, contLen, "%d", pData->c_betCnt);
    elStateLeaf->AddContent(xmlContent, 0);

    elAreaAll = elRoot->AddElement(xmlEl.area_all);
    usedCnt = 1;
    for (int i = 1; i < AREACNT; i++)//����00
    {
        pData = data + i;
        if ( !pData->used )
        {
            continue;
        }
        elArea = elAreaAll->AddElement(xmlEl.area[usedCnt]);

        elAreaLeaf = elArea->AddElement(xmlEl.code[usedCnt]);
        memset(xmlContent, 0, sizeof(xmlContent));
        snprintf(xmlContent, contLen, "%d", i);
        elAreaLeaf->AddContent(xmlContent, 0);

        elAreaLeaf = elArea->AddElement(xmlEl.s_amount_r[usedCnt]);
        memset(xmlContent, 0, sizeof(xmlContent));
        snprintf(xmlContent, contLen, "%lld", pData->s_amount_r);
        elAreaLeaf->AddContent(xmlContent, 0);

        elAreaLeaf = elArea->AddElement(xmlEl.s_amount_all[usedCnt]);
        memset(xmlContent, 0, sizeof(xmlContent));
        snprintf(xmlContent, contLen, "%lld", pData->s_amount_all);
        elAreaLeaf->AddContent(xmlContent, 0);

        elAreaLeaf = elArea->AddElement(xmlEl.s_amount[usedCnt]);
        memset(xmlContent, 0, sizeof(xmlContent));
        snprintf(xmlContent, contLen, "%lld", pData->s_amount);
        elAreaLeaf->AddContent(xmlContent, 0);

        elAreaLeaf = elArea->AddElement(xmlEl.s_ticket_cnt[usedCnt]);
        memset(xmlContent, 0, sizeof(xmlContent));
        snprintf(xmlContent, contLen, "%d", pData->s_ticketCnt);
        elAreaLeaf->AddContent(xmlContent, 0);

        elAreaLeaf = elArea->AddElement(xmlEl.s_bet_cnt[usedCnt]);
        memset(xmlContent, 0, sizeof(xmlContent));
        snprintf(xmlContent, contLen, "%d", pData->s_betCnt);
        elAreaLeaf->AddContent(xmlContent, 0);

        elAreaLeaf = elArea->AddElement(xmlEl.c_amount[usedCnt]);
        memset(xmlContent, 0, sizeof(xmlContent));
        snprintf(xmlContent, contLen, "%lld", pData->c_amount);
        elAreaLeaf->AddContent(xmlContent, 0);

        elAreaLeaf = elArea->AddElement(xmlEl.c_ticket_cnt[usedCnt]);
        memset(xmlContent, 0, sizeof(xmlContent));
        snprintf(xmlContent, contLen, "%d", pData->c_ticketCnt);
        elAreaLeaf->AddContent(xmlContent, 0);

        elAreaLeaf = elArea->AddElement(xmlEl.c_bet_cnt[usedCnt]);
        memset(xmlContent, 0, sizeof(xmlContent));
        snprintf(xmlContent, contLen, "%d", pData->c_betCnt);
        elAreaLeaf->AddContent(xmlContent, 0);

        usedCnt++;
    }

    xmlFile->Save(path);
    delete xmlFile;

    return 0;
}


//���ڽ��ʱ�򣬵��ô˺��������������ϴ����ļ�
static int select_seal_callback(void *data, int col_count, char **col_values, char **col_Name)
{
//0    unique_tsn,
//1    total_bets,
//2    ticket_amount,
//3    bet_string,
//4    is_cancel,
//5    issue_count,
//6    agency_code,
//7    area_code,
//8    area_type

    ts_notused(col_count);
    ts_notused(col_Name);

    // ÿ����¼�ص�һ�θú������ж������ͻص����ٴ�
    //ȡ��ѯ���ص�ÿ�е�ֵ����0��ʼ  col_values[i]

    //�õ��ļ����
    TMP_SQLITE_EXEC *tmpExec = (TMP_SQLITE_EXEC *)data;
    TMP_SQLITE_EXEC *tmpExecProvince = NULL;
    int issueCnt = atoi(col_values[5]);
    int area = atoi(col_values[7]);
    if ( (area > 10000) || (area < 0) )
    {
        log_error("select_seal_callback error area[%d]", area);
        return -1;
    }

    tmpExecProvince = tmpExec + area;
    tmpExecProvince->used = true;
    tmpExec->used = true;

    if (atoi(col_values[4]) == 0)
    {
        tmpExec->s_ticketCnt++;
        tmpExec->s_betCnt += atoi(col_values[1]) / issueCnt;
        tmpExec->s_amount += atol(col_values[2]) / issueCnt;
        tmpExec->s_amount_all += atol(col_values[2]);
        //province
        tmpExecProvince->s_ticketCnt++;
        tmpExecProvince->s_betCnt += atoi(col_values[1]) / issueCnt;
        tmpExecProvince->s_amount += atol(col_values[2]) / issueCnt;
        tmpExecProvince->s_amount_all += atol(col_values[2]);
    }
    else
    {
        tmpExec->c_ticketCnt++;
        tmpExec->c_betCnt += atoi(col_values[1]);
        tmpExec->c_amount += atol(col_values[2]);
        //province
        tmpExecProvince->c_ticketCnt++;
        tmpExecProvince->c_betCnt += atoi(col_values[1]);
        tmpExecProvince->c_amount += atol(col_values[2]);

        return 0;
    }

    //��ʽ��Ϊ�ո�ָ���ַ���
    static char buf[4096] = {0};
    sprintf(buf, "%010d, %016lld, %s\n",
            tmpExec->s_ticketCnt, atoll(col_values[0]), col_values[3]);

    //�� *fd �в���д������
    if(EOF == fputs(buf, tmpExec->fd))
    {
        log_error("fputs error  eof");
        return -1;
    }

    return 0;
}

//�������������ϴ��ļ�
int32 gidb_seal_file(uint8 game_code, uint64 issue_number, TICKET_STAT *ticket_stat)
{
    int32 rc = 0;
    int ret = 0;
    char *zErrMsg = 0;

    GIDB_T_TICKET_HANDLE *t_handle = gidb_t_get_handle(game_code, issue_number);
    if (NULL == t_handle)
    {
        log_error("gidb_t_get_handle(game_code[%u] issue_num[%llu]) failed.", game_code, issue_number);
        return -1;
    }

    char ttySpecPrize[10] = {0};
    if (game_code == GAME_KOCTTY)
    {
        //�õ����ڴε��н���������
        char division_buf[8*1024] = {0};
        int32 division_buf_len = 0;
        ret = t_handle->gidb_t_get_field_blob(t_handle, T_DIVISION_PARAMBLOB_KEY, division_buf, &division_buf_len);
        if (ret != 0)
        {
            log_error("gidb_t_get_field_blob(%d, %llu, T_DIVISION_PARAMBLOB_KEY) failure!", game_code, issue_number);
            return -1;
        }

        //��ȡTTY�ر𿪽���־�Ƿ���
        static GAME_PLUGIN_INTERFACE gamePlugin;
        GAME_PLUGIN_INTERFACE *game_plugins_handle = &gamePlugin;
        if (gl_game_plugins_init_game(game_code, &gamePlugin)!=0)
        {
            //log_error("gl_game_plugins_init() failed.");//gl_game_plugins_init_game���Ѵ�log
            return -1;
        }

        ret = game_plugins_handle->gen_fun(TTY_SPECPRIZE, division_buf, ttySpecPrize);
        if (ret != 0)
        {
            log_error("getTTYspecPrize(%d, %lld) failure.", game_code, issue_number);
            return -1;
        }
    }

    char seal_path[256] = {0};
    char game_abbr[16] = {0};
    get_game_abbr(game_code, game_abbr);
    ts_get_game_issue_seal_data_filepath(game_abbr, issue_number, seal_path, 256);

    //ɾ�����еĸ��ڴε�seal,seal.md5�ļ�
    char cmd_str[256] = {0};
    sprintf(cmd_str, "rm -rf %s", seal_path);
    system(cmd_str);

    memset(cmd_str, 0, sizeof(cmd_str));
    sprintf(cmd_str, "rm -rf %s.md5", seal_path);
    system(cmd_str);

    TMP_SQLITE_EXEC tmpExecProvince[100];//ʡ����λ����
    memset(tmpExecProvince, 0, sizeof(tmpExecProvince));
    TMP_SQLITE_EXEC *tmpExec = tmpExecProvince;

    //��������seal�ļ�
    tmpExec->fd = fopen(seal_path, "w");
    if (tmpExec->fd == NULL)
    {
        log_error("fopen error:%s", seal_path);
        return -1;
    }

    char buf_title[1048] = {0};

    sprintf(buf_title, "# Game[%s] Issue[%lld] Amount[                ] Count[            ] BetCount[            ]       \n",
            game_abbr, issue_number);
    if (game_code == GAME_KOCTTY)
    {
        sprintf(buf_title, "%s# specPrize[%s]\n",
                buf_title, ttySpecPrize);
    }
    if(EOF == fputs(buf_title, tmpExec->fd))
    {
        fclose(tmpExec->fd);
        log_error("fputs error:%s", buf_title);
        return -1;
    }

    sprintf(buf_title, "# line , unique_tsn , bet_string\n");
    if(EOF == fputs(buf_title, tmpExec->fd))
    {
        fclose(tmpExec->fd);
        log_error("fputs error:%s", buf_title);
        return -1;
    }

    //ִ�� select ��ѯ��䣬ͨ���ص��������� seal�ļ�
    char buf_sql[1024] = {0};
    sprintf(buf_sql, "SELECT \
        unique_tsn, \
        total_bets, \
        ticket_amount, \
        bet_string, \
        is_cancel, \
        issue_count, \
        agency_code, \
        area_code, \
        area_type \
        FROM sale_ticket_table \
        WHERE \
        game_code=%d AND sale_start_issue=%lld AND is_train=0",
        game_code, issue_number);

    time_t start = get_now();
    rc = sqlite3_exec(t_handle->db, buf_sql, select_seal_callback, (void *)tmpExec, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("sqlite3_exec() failure. game[%d]issue[%lld]error->%s",
                game_code, issue_number, zErrMsg);
        sqlite3_free(zErrMsg);
        fclose(tmpExec->fd);
        return -1;
    }

    if ( 0 == fseek(tmpExec->fd, 0, SEEK_SET) )
    {
        sprintf(buf_title, "# Game[%s] Issue[%lld] Amount[%16lld] Count[%12d] BetCount[%12d]",
                game_abbr, issue_number, tmpExec->s_amount, tmpExec->s_ticketCnt, tmpExec->s_betCnt);
        if(EOF == fputs(buf_title, tmpExec->fd))
        {
            fclose(tmpExec->fd);
            log_error("fputs error:game[%d]issue[%lld]buftitle[%s]", game_code, issue_number, buf_title);
            return -1;
        }
    }

    time_t end = get_now();

    //�ر��ļ�
    fclose(tmpExec->fd);

    //����MD5�ļ�
    ret = md5_file(seal_path, NULL);
    if (0 != ret)
    {
        log_error("gidb_seal_file md5 error, game[%d]issue[%lld]sum_count[%d]",
                game_code, issue_number, tmpExec->s_ticketCnt);
        return -1;
    }

    ticket_stat->s_amount = tmpExec->s_amount;
    ticket_stat->s_ticketCnt = tmpExec->s_ticketCnt;
    ticket_stat->s_betCnt = tmpExec->s_betCnt;
    ticket_stat->c_amount = tmpExec->c_amount;
    ticket_stat->c_ticketCnt = tmpExec->c_ticketCnt;
    ticket_stat->c_betCnt = tmpExec->c_betCnt;

    //�õ����ڴε���Ϸ��������
    static char game_buf[4*1024];
    int32 game_buf_len = 0;
    ret = t_handle->gidb_t_get_field_blob(t_handle, T_GAME_PARAMBLOB_KEY, game_buf, &game_buf_len);
    if (ret != 0)
    {
        log_error("gidb_t_get_field_blob(%d, %lld, T_GAME_PARAMBLOB_KEY) failure!", game_code, issue_number);
        return -1;
    }

    GT_GAME_PARAM *game_param = (GT_GAME_PARAM *)game_buf;
    for (int i = 0; i < AREACNT; i++)
    {
        if (!tmpExec[i].used)
            continue;
        tmpExec[i].s_amount_r = tmpExec[i].s_amount * (1000 - game_param->returnRate - game_param->adjustmentFundRate) / 1000;
    }

    log_info("gidb_seal_file() success. game[%d]issue[%llu]sum_count[%d] time start[%ld] end[%ld] sub[%ld]",
                game_code, issue_number, tmpExec->s_ticketCnt, start, end, end - start);

    //���ɷ��ͳ������XML��OM��ӡ
    char seal_state[256] = {0};
    sprintf(seal_state, "%s.xml", seal_path);
    gidb_seal_state_file(game_code, issue_number, seal_state, tmpExec);

    log_info("gidb_seal_state_file() success. game[%d]issue[%llu]",
            game_code, issue_number);
    return 0;
}


//���ڽ��ʱ�򣬵��ô˺�����������ֽ�����н��ļ�
static int select_ap_win_callback(void * data, int col_count, char ** col_values, char ** col_Name)
{
    ts_notused(col_count);
    ts_notused(col_Name);

    // ÿ����¼�ص�һ�θú������ж������ͻص����ٴ�
    //ȡ��ѯ���ص�ÿ�е�ֵ����0��ʼ  col_values[i]

    TMP_SQLITE_EXEC *tmpExec = (TMP_SQLITE_EXEC *)data;
    tmpExec->s_ticketCnt++;
    tmpExec->s_amount += atoll(col_values[5]);

    //�õ��ļ����
    //��ʽ��Ϊ�ո�ָ���ַ���
    char buf[512] = {0};
    sprintf(buf, "%d %s %s %s %s %s %s %s\n", tmpExec->s_ticketCnt, col_values[0], col_values[1], col_values[2], col_values[3], col_values[4], col_values[5], col_values[6]);

    //�� *fd �в���д������
    if(EOF == fputs(buf, tmpExec->fd))
    {
        log_error("fputs error  eof");
        fclose(tmpExec->fd);
        return -1;
    }
    return 0;
}
int32 gidb_generate_ap_win_file(uint8 game_code, uint64 issue_number, uint8 draw_times)
{
    int32 rc = 0;
    int ret = 0;
    char *zErrMsg = 0;

    GIDB_W_TICKET_HANDLE *w_handle = gidb_w_get_handle(game_code, issue_number, draw_times);
    if ( NULL == w_handle ) {
        log_error("gidb_w_get_handle(game_code[%u] issue_num[%llu] draw_times[%d]) failed.", game_code, issue_number, draw_times);
        return -1;
    }

    //�õ�ap �н��ļ����ļ�·��
    char ap_win_file_path[256] = {0};
    ts_get_pub_game_issue_filepath(0, game_code, issue_number, draw_times, ap_win_file_path, 256);

    //ɾ��ԭ�е����н��ļ���MD5�ļ�
    char cmd_str[64] = {0};
    sprintf(cmd_str, "rm -rf %s", ap_win_file_path);
    system(cmd_str);

    memset(cmd_str, 0, sizeof(cmd_str));
    sprintf(cmd_str, "rm -rf %s.md5", ap_win_file_path);
    system(cmd_str);

    TMP_SQLITE_EXEC tmpExec;
    memset(&tmpExec, 0, sizeof(tmpExec));
    tmpExec.s_ticketCnt = 0; tmpExec.s_amount = 0;
    
    //open upload�ļ�
    tmpExec.fd = fopen(ap_win_file_path, "a+");
    if (tmpExec.fd == NULL)
    {
        log_error("open error:%s", ap_win_file_path);
        return -1;
    }

    //from_sale
    //ִ�� select ��ѯ��䣬ͨ���ص��������� upload sale �ļ�
    char buf_sql[1024] = {0};
    sprintf(buf_sql, "SELECT \
        agency_code,  \
        reqfn_ticket, \
        rspfn_ticket, \
        unique_tsn, \
        time_stamp,  \
        winning_amount,  \
        is_big_winning  \
        FROM win_ticket_table \
        WHERE \
        game_code=%d AND sale_start_issue=%llu AND is_train=0 AND from_sale=%d",
        game_code, issue_number, TICKET_FROM_AP);

    time_t start = get_now();

    rc = sqlite3_exec(w_handle->db, buf_sql, select_ap_win_callback, (void *)&tmpExec, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("sqlite3_exec() failure. error->%s",zErrMsg);
        sqlite3_free(zErrMsg);
        fclose(tmpExec.fd);
        return -1;
    }
    time_t end = get_now();

    char buf[512] = {0};
    sprintf(buf, "--- Total Tickets: %u    Total Amount: %lld ---\n", tmpExec.s_ticketCnt, tmpExec.s_amount);
    if(EOF == fputs(buf, tmpExec.fd))
    {
        log_error("fputs error  eof");
        sqlite3_free(zErrMsg);
        fclose(tmpExec.fd);
        return -1;
    }

    //�ر��ļ�
    fclose(tmpExec.fd);

    //����MD5�ļ�
    ret = md5_file(ap_win_file_path, NULL);
    if (0 != ret)
    {
        log_error("gidb_generate_ap_win_file fail. md5 error,sum_count[%d]",
                  tmpExec.s_ticketCnt);
        return -1;
    }

    log_info("gidb_generate_ap_win_file() success. sum_count[%d] time start[%ld] end[%ld] sub[%ld]",
             tmpExec.s_ticketCnt, start, end, end - start);

    return 0;
}

int32 gidb_generate_issue_win_file(uint8 game_code, uint64 issue_number, uint8 draw_times, char *file)
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

    GIDB_W_TICKET_HANDLE *w_handle = gidb_w_get_handle(game_code, issue_number, draw_times);
    if ( NULL == w_handle ) {
        log_error("gidb_w_get_handle(game_code[%u] issue_num[%llu] draw_times[%d]) failed.",
                  game_code, issue_number, draw_times);
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
        prize_count,  \
        prize_detail  \
        FROM win_ticket_table \
        WHERE \
        game_code=%d AND is_train=0",
        game_code);

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
            int przCnt = sqlite3_column_int(pStmt, 2);


            char *prz = (char*)sqlite3_column_blob(pStmt, 3);
            if (prz != NULL)
            {
                int data_len = sqlite3_column_bytes(pStmt, 3);
                memcpy(&prz_detail, prz, data_len);


                for (int i = 0; i < przCnt; i++)
                {
                    tmp_win_file.prizeCode = prz_detail[i].prizeCode;
                    tmp_win_file.prizeCnt  = prz_detail[i].count;
                    tmp_win_file.winningAmountWithTax = prz_detail[i].amountBeforeTax;
                    tmp_win_file.winningAmount = prz_detail[i].amountAfterTax;
                    tmp_win_file.taxAmount = prz_detail[i].amountTax;

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
        log_error("gidb_generate_issue_win_file fail. md5 error");
        return -1;
    }

    log_info("gidb_generate_issue_win_file() success. time start[%ld] end[%ld] sub[%ld]",
             start, end, end - start);

    return 0;
}



#if R("---GIDB draw log operation function---")


//����������־��
int32 gidb_drawlog_create_table(sqlite3 *db)
{
    //��ʼ���µ�����
    if ( db_begin_transaction(db) < 0 )
    {
        log_error("db_begin_transaction error.");
        return -1;
    }

    //draw_code_table ��¼����Ҫ���󿪽�������ڴΣ���rng_serverɨ��ʹ��
    //�����󵽿������벢д��draw_log_table�󣬽���confirm����
    //msgid���������ֶΣ���ΪΨһ��ǣ�ʹ��msgid����confirm����
    const char *sql_dc_str = "CREATE TABLE draw_code_table( \
        msgid        INTEGER PRIMARY KEY AUTOINCREMENT, \
        game_code    INTEGER NOT NULL, \
        issue_number INT64   NOT NULL, \
        update_time  INT64   NOT NULL, \
        confirm      INTEGER DEFAULT (0), \
        confirm_time INT64 )";
    if (0 != db_create_table(db, sql_dc_str))
    {
        log_error("gidb create draw_code_table failure!");
        return -1;
    }
    log_info("gidb create draw_code_table -> success.");

    //draw_log_table ��¼����������Ҫ�Ľ������ݣ���gl_draw����ɨ��ʹ�ã�gl_draw�����ɹ��󣬽���confirm����
    //msgid���������ֶΣ���ΪΨһ��ǣ�ʹ��msgid����confirm����
    const char *sql_dl_str = "CREATE TABLE draw_log_table ( \
        msgid        INTEGER PRIMARY KEY AUTOINCREMENT, \
        game_code    INTEGER NOT NULL, \
        issue_number INT64   NOT NULL, \
        update_time  INT64   NOT NULL, \
        msg_type     INTEGER, \
        DRAW_MSG_KEY BLOB, \
        confirm      INTEGER DEFAULT (0), \
        confirm_time INT64 )";
    if (0 != db_create_table(db, sql_dl_str))
    {
        log_error("gidb create draw_log_table failure!");
        return -1;
    }

    //�����ύ
    if ( db_end_transaction(db) < 0 )
    {
        log_error("db_end_transaction error.");
        return -1;
    }

    log_info("gidb create draw_log_table -> success.");
    return 0;
}

//д��һ�����󿪽�������־
int32 gidb_drawlog_append_dc(GIDB_DRAWLOG_HANDLE *self, uint64 issue_number)
{
    const char *sql_drawcode = "INSERT INTO draw_code_table ( \
        msgid, game_code, issue_number, update_time) VALUES (null,%d,%llu,%ld)";

    char sql[4096] = {0};
    sprintf(sql, sql_drawcode, self->game_code, issue_number, time(NULL));
    
    int32 rc;
    char *zErrMsg = 0;
    rc = sqlite3_exec(self->db, sql, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("sqlite3_exec() -> SQL error: %s", zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }

    log_debug("gidb_drawlog_append_dc(%d, %llu) -> success.", self->game_code, issue_number);
    return 0;
}

//��ȡ��һ���ô�������־
int32 gidb_drawlog_get_last_dc(GIDB_DRAWLOG_HANDLE *self, uint32 *msgid, uint64 *issue_number)
{
    int32 rc;
    const char *sql_drawcode = "SELECT msgid, issue_number FROM draw_code_table WHERE game_code=%d AND confirm=0 ORDER BY msgid LIMIT 0,1";

    char sql[4096] = {0};
    sprintf(sql, sql_drawcode, self->game_code);

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
        //log_info("gidb_drawlog_get_last_dc() return empty.");
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
    *issue_number = sqlite3_column_int(pStmt, 1);

    sqlite3_finalize(pStmt);

    log_debug("gidb_drawlog_get_last_dc(%d, %llu) msgid[%u]) -> success.", self->game_code, *issue_number, *msgid);
    return 0;
}

//ȷ��һ����־�����ɹ�
int32 gidb_drawlog_confirm_dc(GIDB_DRAWLOG_HANDLE *self, uint32 msgid)
{
    const char *sql_str = "UPDATE draw_code_table SET confirm=1, confirm_time=%ld WHERE msgid=%u";

    int32 rc;
    char *zErrMsg = 0;

    char sql[4096] = {0};
    sprintf(sql, sql_str, time(NULL), msgid);

    rc = sqlite3_exec(self->db, sql, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK)
    {
        log_error("sqlite3_exec() -> SQL error: %s", zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }

    log_debug("gidb_drawlog_confirm_dc(%d) msgid[%u] -> success.", self->game_code, msgid);
    return 0;
}


//д��һ������������־
int32 gidb_drawlog_append_dl(GIDB_DRAWLOG_HANDLE *self, uint64 issue_number, int32 msg_type, char *msg, int32 msg_len)
{
    int32 rc;
    const char *sql_drawcode = "INSERT INTO draw_log_table ( \
        msgid, game_code, issue_number, update_time, msg_type, DRAW_MSG_KEY ) VALUES (null,%d,%lld,%ld,%d,?)";

    char sql[4096] = {0};
    sprintf(sql, sql_drawcode, self->game_code, issue_number, time(NULL), msg_type);

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

    log_debug("gidb_drawlog_append_dl(%d, %llu, msg_type[%d]) -> success.", self->game_code, issue_number, msg_type);
    return 0;
}

//��ȡ��һ���ô�������־
int32 gidb_drawlog_get_last_dl(GIDB_DRAWLOG_HANDLE *self, uint32 *msgid, uint8 *msg_type, char *msg, uint32 *msg_len)
{
    int32 rc;
    const char *sql_drawcode = "SELECT msgid, msg_type, DRAW_MSG_KEY FROM draw_log_table WHERE game_code=%d AND confirm=0 ORDER BY msgid LIMIT 0,1";

    char * data_ptr = NULL;
    uint32 data_len = 0;

    char sql[4096] = {0};
    sprintf(sql, sql_drawcode, self->game_code);

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
        //log_info("gidb_drawlog_get_last_dl() return empty.");
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
        log_error("gidb_drawlog_get_last_dl(%u) msg is null!", *msgid);
        sqlite3_finalize(pStmt);
        return -1;
    }

    sqlite3_finalize(pStmt);

    log_debug("gidb_drawlog_get_last_dl(%d, msgid[%u] msg_type[%d]) -> success.", self->game_code, *msgid, *msg_type);
    return 0;
}

//ȷ��һ����־�����ɹ�
int32 gidb_drawlog_confirm_dl(GIDB_DRAWLOG_HANDLE *self, uint32 msgid, uint32 flag)
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

    log_debug("gidb_drawlog_confirm_dl(%d) msgid[%u] -> success.", self->game_code, msgid);
    return 0;
}

//ȡһ����¼
int32 gidb_drawlog_get_rec(GIDB_DRAWLOG_HANDLE *self, uint64 issue_number, int32 msg_type)
{
    const char *sql_str = "SELECT count(*) from draw_log_table WHERE issue_number=%llu and msg_type=%d";

    int32 rc;
    char sql[4096] = {0};
    sprintf(sql, sql_str, issue_number, msg_type);

    sqlite3_stmt* pStmt = NULL;
    rc = sqlite3_prepare_v2(self->db, sql, strlen(sql), &pStmt, NULL);
    if (rc != SQLITE_OK)
    {
        log_error("gidb_drawlog_get_rec sqlite3_prepare_v2() error. rc[%d](issue[%llu], msg_type[%d])", rc, issue_number, msg_type);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    rc = sqlite3_step(pStmt);
    if (rc == SQLITE_DONE)
    {
        log_info("gidb_drawlog_get_rec return empty.(issue[%llu], msg_type[%d])",  issue_number, msg_type);
        sqlite3_finalize(pStmt);
        return 1;
    }
    else if (rc == SQLITE_ROW)
    {
        int cnt = sqlite3_column_int(pStmt, 0);

        sqlite3_finalize(pStmt);

        if (cnt > 0)
        {
        	log_debug("gidb_drawlog_get_rec cnt[%d](issue[%llu], msg_type[%d])", cnt, issue_number, msg_type);
        	return 1;
        }

        return 0;
    }

    log_error("gidb_drawlog_get_rec sqlite3_step() failure!(rc(%d)issue[%llu], msg_type[%d])", rc, issue_number, msg_type);
    sqlite3_finalize(pStmt);
    return -1;
}


//��Ϸmap
static GAME_DRAWLOG_MAP  game_drawlog_map;

GIDB_DRAWLOG_HANDLE *map_drawlog_get(uint8 game_code)
{
    if (1 == game_drawlog_map.count(game_code))
    {
        return game_drawlog_map[game_code];
    }
    return NULL;
}

int32 map_drawlog_set(uint8 game_code, GIDB_DRAWLOG_HANDLE *ptr)
{
    if (NULL == ptr)
    {
        return -1;
    }
    game_drawlog_map[game_code] = ptr;
    return 0;
}


GIDB_DRAWLOG_HANDLE * gidb_drawlog_game_init(uint8 game_code)
{
    int32 ret = 0;

    char game_abbr[16];
    get_game_abbr(game_code, game_abbr);
    char db_path[256];
    ts_get_game_dir(game_abbr, db_path, 256);
    sprintf(db_path, "%s/drawlog_%s", db_path, game_abbr);

    //open sqlite db connect
    sqlite3 * db = db_connect(db_path);
    if (  db == NULL )
    {
        log_error("db_connect(%s) error.", db_path);
        return NULL;
    }

    //�жϱ��Ƿ��Ѵ���
    ret = db_check_table_exist(db, "draw_log_table");
    if ( ret < 0)
    {
        log_error("db_check_table_exist(%s) found error.", db_path);
        return NULL;
    }
    else if ( 1 == ret )
    {
        //�������ڣ�������
        if ( gidb_drawlog_create_table(db) < 0 )
        {
            log_error("gidb_drawlog_create_table(%s) error.", db_path);
            return NULL;
        }
    }

    //����map
    GIDB_DRAWLOG_HANDLE * ptr = NULL;
    ptr = (GIDB_DRAWLOG_HANDLE *)malloc(sizeof(GIDB_DRAWLOG_HANDLE));
    memset(ptr, 0, sizeof(GIDB_DRAWLOG_HANDLE));

    ptr->game_code = game_code;
    ptr->db = db;

    //��ʼ������ָ��
    ptr->gidb_drawlog_append_dc = gidb_drawlog_append_dc;
    ptr->gidb_drawlog_get_last_dc = gidb_drawlog_get_last_dc;
    ptr->gidb_drawlog_confirm_dc = gidb_drawlog_confirm_dc;

    ptr->gidb_drawlog_append_dl = gidb_drawlog_append_dl;
    ptr->gidb_drawlog_get_last_dl = gidb_drawlog_get_last_dl;
    ptr->gidb_drawlog_confirm_dl = gidb_drawlog_confirm_dl;
    ptr->gidb_drawlog_get_rec = gidb_drawlog_get_rec;

    map_drawlog_set(game_code, ptr);

    log_debug("gidb_drawlog_game_init(%d) -> success.", game_code);
    return ptr;
}

// interface
GIDB_DRAWLOG_HANDLE * gidb_drawlog_get_handle(uint8 game_code)
{
    GIDB_DRAWLOG_HANDLE *ptr = map_drawlog_get(game_code);
    if (NULL != ptr)
    {
        return ptr;
    }

    ptr = gidb_drawlog_game_init(game_code);
    if (NULL == ptr)
    {
        log_error("gidb_drawlog_get_handle(%d) failure!", game_code);
        return NULL;
    }
    return ptr;
}

int32 gidb_drawlog_close_handle()
{
    GAME_DRAWLOG_MAP::iterator it;
    GIDB_DRAWLOG_HANDLE* pi = NULL;
    for(it=game_drawlog_map.begin(); it!=game_drawlog_map.end();)
    {
        pi = it->second;
        db_close(pi->db);
        free((char *)pi);

        game_drawlog_map.erase(it++);
    }

    log_debug("gidb_drawlog_close_handle() success!");
    return 0;
}

#endif





#if R("---GIDB driver log operation function---")

//------------------------------
// ҵ������ log Interface
//------------------------------

static GIDB_DRIVERLOG_HANDLE  *driverlog_handle = NULL;

//����������־��
int32 gidb_driverlog_create_table(sqlite3 *db)
{
    //��ʼ���µ�����
    if ( db_begin_transaction(db) < 0 ) {
        log_error("db_begin_transaction error.");
        return -1;
    }

    //driver_log_table ��������һЩ�������Ŀǰ��������ap���ڴο�����ɣ����߱����������ʱ���Զ��ҽ�
    //msgid���������ֶΣ���ΪΨһ��ǣ�ʹ��msgid����confirm����
    const char *sql_dl_str = "CREATE TABLE driver_log_table ( \
        msgid        INTEGER PRIMARY KEY AUTOINCREMENT, \
        game_code    INTEGER NOT NULL, \
        issue_number INT64   NOT NULL, \
        match_code   INT64   NOT NULL, \
        update_time  INT64   NOT NULL, \
        msg_type     INTEGER, \
        data_string  TEXT, \
        confirm      INTEGER DEFAULT (0), \
        confirm_time INT64 )";
    if (0 != db_create_table(db, sql_dl_str)) {
        log_error("gidb create driver_log_table failure!");
        return -1;
    }
    log_info("gidb create driver_log_table -> success.");

    //�����ύ
    if ( db_end_transaction(db) < 0 ) {
        log_error("db_end_transaction error.");
        return -1;
    }

    log_info("gidb create driver_log_table -> success.");
    return 0;
}

//д��һ������������־
int32 gidb_driverlog_append_dl(GIDB_DRIVERLOG_HANDLE *self, uint32 game, uint64 issue, uint64 match, int32 msg_type, char *msg, int32 msg_len)
{
    int32 rc;
    const char *sql_drawcode = "INSERT INTO driver_log_table ( \
        msgid, game_code, issue_number, match_code, update_time, msg_type, data_string ) VALUES (null,%u,%ld,%ld,%ld,%d,?)";

    char sql[4096] = {0};
    sprintf(sql, sql_drawcode, game, issue, match, time(NULL), msg_type);

    sqlite3_stmt* pStmt = NULL;
    rc = sqlite3_prepare_v2(self->db, sql, strlen(sql), &pStmt, NULL);
    if (rc != SQLITE_OK) {
        log_error("sqlite3_prepare_v2() error. [%d]", rc);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }
    if (sqlite3_bind_text(pStmt, 1, msg, msg_len, SQLITE_TRANSIENT) != SQLITE_OK) {
        log_error("sqlite3_bind_blob() error.");
        sqlite3_finalize(pStmt);
        return -1;
    }

    rc = sqlite3_step(pStmt);
    if (rc != SQLITE_DONE) {
        log_error("sqlite3_step() error.");
        sqlite3_finalize(pStmt);
        return -1;
    }

    sqlite3_finalize(pStmt);

    log_debug("gidb_driverlog_append_dl(%u, %llu, %llu, data_string[%s]) -> success.", game, issue, match, msg);
    return 0;
}

//��ȡ��һ���ô�������־
int32 gidb_driverlog_get_last_dl(GIDB_DRIVERLOG_HANDLE *self, uint32 type, uint32 *msgid, uint8 *msg_type, uint8 *gameCode, char *msg, uint32 *msg_len)
{
    int32 rc;
    char * data_ptr = NULL;
    char sql[4096] = {0};

    if (type == 0)
        sprintf(sql, "SELECT game_code,msgid, msg_type, data_string FROM driver_log_table WHERE confirm=0 ORDER BY msgid LIMIT 0,1");
    else
        sprintf(sql, "SELECT game_code,msgid, msg_type, data_string FROM driver_log_table WHERE msg_type=%u AND confirm=0 ORDER BY msgid LIMIT 0,1", type);

    sqlite3_stmt* pStmt = NULL;
    rc = sqlite3_prepare_v2(self->db, sql, strlen(sql), &pStmt, NULL);
    if ( rc != SQLITE_OK) {
        log_error("sqlite3_prepare_v2() error. [%d]", rc);
        if (pStmt)
            sqlite3_finalize(pStmt);
        return -1;
    }

    rc = sqlite3_step(pStmt);
    if (rc == SQLITE_DONE) {
        //log_info("gidb_drawlog_get_last_dl() return empty.");
        sqlite3_finalize(pStmt);
        return 1;
    } else if (rc != SQLITE_ROW) {
        log_error("sqlite3_step() failure!");
        sqlite3_finalize(pStmt);
        return -1;
    }
    *gameCode = sqlite3_column_int(pStmt, 0);
    *msgid = sqlite3_column_int(pStmt, 1);
    *msg_type = sqlite3_column_int(pStmt, 2);
    data_ptr = (char *)sqlite3_column_text(pStmt, 3);
    *msg_len = 0;
    if (data_ptr != NULL) {
        strcpy(msg, data_ptr); *msg_len = strlen(msg);
    }

    sqlite3_finalize(pStmt);

    log_debug("gidb_driverlog_get_last_dl(msgid[%u] msg_type[%d]) -> success.", *msgid, *msg_type);
    return 0;
}

//ȷ��һ����־�����ɹ�
int32 gidb_driverlog_confirm_dl(GIDB_DRIVERLOG_HANDLE *self, uint32 msgid, uint32 flag)
{
	int32 rc;
    char *zErrMsg = 0;

    char sql[4096] = {0};
    if (flag==1)
    	sprintf(sql, "UPDATE driver_log_table SET confirm=1, confirm_time=%u WHERE msgid=%u", get_now(), msgid);
    else
    	sprintf(sql, "UPDATE driver_log_table SET confirm=2, confirm_time=%u WHERE msgid=%u", get_now(), msgid);
    
    rc = sqlite3_exec(self->db, sql, 0, 0, &zErrMsg);
    if(rc != SQLITE_OK) {
        log_error("sqlite3_exec() -> SQL error: %s", zErrMsg);
        sqlite3_free(zErrMsg);
        return -1;
    }

    log_debug("gidb_driverlog_confirm_dl() msgid[%u] -> success.", msgid);
    return 0;
}

GIDB_DRIVERLOG_HANDLE * gidb_driverlog_init()
{
    int32 ret = 0;

    char db_path[256];
    ts_get_game_root_dir(db_path, 256);
    sprintf(db_path, "%s/driver_log", db_path);

    //open sqlite db connect
    sqlite3 * db = db_connect(db_path);
    if (  db == NULL ) {
        log_error("db_connect(%s) error.", db_path);
        return NULL;
    }
    //�жϱ��Ƿ��Ѵ���
    ret = db_check_table_exist(db, "driver_log_table");
    if ( ret < 0) {
        log_error("db_check_table_exist(%s) found error.", db_path);
        return NULL;
    } else if ( 1 == ret ) {
        //�������ڣ�������
        if ( gidb_driverlog_create_table(db) < 0 ) {
            log_error("gidb_driverlog_create_table(%s) error.", db_path);
            return NULL;
        }
    }

    GIDB_DRIVERLOG_HANDLE * ptr = NULL;
    ptr = (GIDB_DRIVERLOG_HANDLE *)malloc(sizeof(GIDB_DRIVERLOG_HANDLE));
    memset(ptr, 0, sizeof(GIDB_DRIVERLOG_HANDLE));
    ptr->db = db;

    //��ʼ������ָ��
    ptr->gidb_driverlog_append_dl = gidb_driverlog_append_dl;
    ptr->gidb_driverlog_get_last_dl = gidb_driverlog_get_last_dl;
    ptr->gidb_driverlog_confirm_dl = gidb_driverlog_confirm_dl;

    log_debug("gidb_driverlog_init() -> success.");
    return ptr;
}

// interface
GIDB_DRIVERLOG_HANDLE * gidb_driverlog_get_handle()
{
    if (NULL != driverlog_handle) {
        return driverlog_handle;
    }

    GIDB_DRIVERLOG_HANDLE *ptr = gidb_driverlog_init();
    if (NULL == ptr) {
        log_error("gidb_driverlog_get_handle() failure!");
        return NULL;
    }
    driverlog_handle = ptr;
    return driverlog_handle;
}

int32 gidb_driverlog_close_handle()
{
    if (NULL != driverlog_handle) {
        db_close(driverlog_handle->db);
        free((char *)driverlog_handle);
        driverlog_handle = NULL;
    }
    log_debug("gidb_driverlog_close_handle() success!");
    return 0;
}

#endif


