#include "global.h"
#include "sysdb_inf.h"
#include "ncpc_inf.h"
#include "tms_inf.h"
#include "gl_inf.h"
#include "tfe_inf.h"


extern "C" int ts4py_init()
{
    if (!sysdb_init()) {
        printf("ts4py_init() -> sysdb_init error.");
        return -1;
    }
    if (!gl_init()) {
        printf("ts4py_init() -> gl_init error.");
        return -1;
    }
    if (!tms_mgr()->TMSInit()) {
        printf("ts4py_init() -> tms_mgr() init error.");
        return -1;
    }
    return 0;
}

extern "C" int ts4py_close()
{
    tms_mgr()->TMSClose();
    gl_close();
    sysdb_close();
    return 0;
}

extern "C" int ts4py_get_gamelist(char *str)
{
    char tmp[64];
    str[0] = 0;
    int idx = 0;
    for (idx=0;idx<MAX_GAME_NUMBER;idx++) {
        GAME_SUPPORT *g = get_game_support(idx);
        if (g->used) {
            sprintf(tmp,"%u:%s ", g->gameCode, g->gameAbbr);
            strcat(str, tmp);
        }
    }
    return 0;
}

extern "C" int ts4py_get_date_and_digit_tsn(char *tsn, char *date, char *unique_tsn)
{
    char t[32] = {0}; uint32 d=0; uint64 u=0;
    sprintf(t,"%s",tsn);
    u = extract_tsn(t, &d);
    if (u==0) {
        printf("ts4py_get_date_and_digit_tsn() -> extract_tsn error. [%s]", t);
        return -1;
    }
    sprintf(date,"%u",d); sprintf(unique_tsn,"%llu",u);
    return 0;
}

//draw procedure
extern "C" int ts4py_issueBlob2str(D_FIELD_BLOB_KEY type, const char *str_s, int len_s, char *str_d, int len_d)
{
    ts_notused(len_s);
    ts_notused(len_d);
    char str[1024*2] = {0};
    memset(str_d,0,len_d);
    switch (type)
    {
        default:
            return -1;
        case D_TICKETS_STAT_BLOB_KEY:
        {
            TICKET_STAT *p = (TICKET_STAT*)str_s;
            sprintf(str_d, "%u;%u;%lld;%u;%u;%lld",
                p->s_ticketCnt, p->s_betCnt, p->s_amount, p->c_ticketCnt, p->c_betCnt, p->c_amount);
            break;
        }
        case D_WLEVEL_STAT_BLOB_KEY:
        {
            VALUE_TRIPLE *p = (VALUE_TRIPLE*)str_s;
            for (int i = 0; i < MAX_PRIZE_COUNT; i++)
            {
                if (p->value == 0) {
                    p++;
                    continue;
                }
                sprintf(str, "%s/%u;%u", str, p->code, p->value);
                p++;
            }
            if (strlen(str)==0)
                sprintf(str_d, "0;0");
            else
                sprintf(str_d, "%s", &str[1]);
            break;
        }

        case D_WPRIZE_LEVEL_BLOB_KEY:
        {
            PRIZE_LEVEL *p = (PRIZE_LEVEL*)str_s;
            for (int i = 0; i < MAX_PRIZE_COUNT; i++)
            {
                if (p->count == 0) {
                    p++;
                    continue;
                }
                sprintf(str, "%s/%d;%d;%u;%lld", str, p->prize_code, p->hflag, p->count, p->money_amount);
                p++;
            }
            if (strlen(str)==0)
                sprintf(str_d, "0;0;0;0");
            else
                sprintf(str_d, "%s", &str[1]);
            break;
        }

        case D_WPRIZE_LEVEL_CONFIRM_BLOB_KEY:
        {
            PRIZE_LEVEL *p = (PRIZE_LEVEL*)str_s;
            for (int i = 0; i < MAX_PRIZE_COUNT; i++)
            {
                if (p->count == 0) {
                    p++;
                    continue;
                }
                sprintf(str, "%s/%d;%d;%u;%lld", str, p->prize_code, p->hflag, p->count, p->money_amount);
                p++;
            }
            if (strlen(str)==0)
                sprintf(str_d, "0;0;0;0");
            else
                sprintf(str_d, "%s", &str[1]);
            break;
        }
        case D_WFUND_INFO_BLOB_KEY:
        {
            GL_PRIZE_CALC *p = (GL_PRIZE_CALC*)str_s;
            sprintf(str_d, "%lld;%s;%lld;%lld;%lld;%d;%lld;%s;%lld;%lld;%d",
                p->saleAmount, p->pool.poolName, p->pool.poolAmount, p->adjustAmount, p->publishAmount, p->returnRate,
                p->prizeAmount, p->poolUsed.poolName, p->poolUsed.poolAmount, p->highPrize2Adjust, p->moneyEnough);
            break;
        }
        case D_WFUND_INFO_CONFIRM_BLOB_KEY:
        {
            GL_PRIZE_CALC *p = (GL_PRIZE_CALC*)str_s;
            sprintf(str_d, "%lld;%s;%lld;%lld;%lld;%d;%lld;%s;%lld;%lld;%d",
                p->saleAmount, p->pool.poolName, p->pool.poolAmount, p->adjustAmount, p->publishAmount, p->returnRate,
                p->prizeAmount, p->poolUsed.poolName, p->poolUsed.poolAmount, p->highPrize2Adjust, p->moneyEnough);
            break;
        }
    }
    return 0;
}
