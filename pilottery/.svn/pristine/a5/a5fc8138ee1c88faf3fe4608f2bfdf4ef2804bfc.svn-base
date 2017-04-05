#include "ncp.h"
#include "cache_mgr.h"


int ccmgr_init(cache_mgr *ccmgr)
{
    pthread_rwlock_init(&ccmgr->issue_rwlock, NULL);
    pthread_rwlock_init(&ccmgr->conn_rwlock, NULL);
    return 0;
}


int ccmgr_issue_get(cache_mgr *ccmgr, uint8 game_code, HOST_GAME_ISSUE* issue_ptr)
{
    uint32 key = game_code;
    HOST_GAME_ISSUE* ptr = NULL;
    pthread_rwlock_rdlock(&ccmgr->issue_rwlock);
    if (1 == ccmgr->issue_map.count(key))
    {
        ptr = ccmgr->issue_map[key];
        if (ptr->gameCode > 0) {
            memcpy((char*)issue_ptr, (char*)ptr, sizeof(HOST_GAME_ISSUE));
            pthread_rwlock_unlock(&ccmgr->issue_rwlock);
            return 0;
        }
    }
    pthread_rwlock_unlock(&ccmgr->issue_rwlock);
    return -1;
}
int ccmgr_issue_set(cache_mgr *ccmgr, uint8 game_code, HOST_GAME_ISSUE *issue_ptr)
{
    uint32 key = game_code;
    HOST_GAME_ISSUE* ptr = NULL;
    pthread_rwlock_wrlock(&ccmgr->issue_rwlock);
    if (issue_ptr->issueNumber == 0)
        issue_ptr->gameCode = 0;
    if (1 == ccmgr->issue_map.count(key))
    {
        ptr = ccmgr->issue_map[key];
        memcpy((char*)ptr, (char*)issue_ptr, sizeof(HOST_GAME_ISSUE));
        pthread_rwlock_unlock(&ccmgr->issue_rwlock);
        return 0;
    }
    ptr = (HOST_GAME_ISSUE*)malloc(sizeof(HOST_GAME_ISSUE));
    memcpy((char*)ptr, (char*)issue_ptr, sizeof(HOST_GAME_ISSUE));
    ccmgr->issue_map[key] = ptr;
    pthread_rwlock_unlock(&ccmgr->issue_rwlock);
    return 0;
}
int ccmgr_issue_del(cache_mgr *ccmgr, uint8 game_code)
{
    uint32 key = game_code;
    HOST_GAME_ISSUE* ptr = NULL;
    pthread_rwlock_wrlock(&ccmgr->issue_rwlock);
    if (1 == ccmgr->issue_map.count(key))
    {
        ptr = ccmgr->issue_map[key];
        ptr->gameCode = 0;
    }
    pthread_rwlock_unlock(&ccmgr->issue_rwlock);
    return 0;
}


void ccmgr_inc_term_conn(cache_mgr *ccmgr)
{
    pthread_rwlock_wrlock(&ccmgr->conn_rwlock);
    ccmgr->term_conn++;
    pthread_rwlock_unlock(&ccmgr->conn_rwlock);
}
void ccmgr_dec_term_conn(cache_mgr *ccmgr)
{
    pthread_rwlock_wrlock(&ccmgr->conn_rwlock);
    ccmgr->term_conn--;
    pthread_rwlock_unlock(&ccmgr->conn_rwlock);
}

int ccmgr_get_term_conn(cache_mgr *ccmgr)
{
    int conn = 0;
    pthread_rwlock_rdlock(&ccmgr->conn_rwlock);
    conn = ccmgr->term_conn;
    pthread_rwlock_unlock(&ccmgr->conn_rwlock);
    return conn;
}

