#ifndef NCP_CACHE_H
#define NCP_CACHE_H

typedef map<uint32, HOST_GAME_ISSUE*> ISSUE_MAP;
typedef struct _cache_mgr
{
    ISSUE_MAP issue_map;
    pthread_rwlock_t issue_rwlock;

    int term_conn;
    pthread_rwlock_t conn_rwlock;
} cache_mgr;

int ccmgr_init(cache_mgr *ccmgr);

//当前期
int ccmgr_issue_get(cache_mgr *ccmgr, uint8 game_code, HOST_GAME_ISSUE* issue_ptr);
int ccmgr_issue_set(cache_mgr *ccmgr, uint8 game_code, HOST_GAME_ISSUE *issue_ptr);
int ccmgr_issue_del(cache_mgr *ccmgr, uint8 game_code);

//连接数
void ccmgr_inc_term_conn(cache_mgr *ccmgr);
void ccmgr_dec_term_conn(cache_mgr *ccmgr);
int ccmgr_get_term_conn(cache_mgr *ccmgr);



#endif //NCP_CACHE_H

