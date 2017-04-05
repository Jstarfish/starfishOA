#include "global.h"
#include "tmsmod.h"


TMS_DATABASE_PTR tms_database_ptr = NULL;

static TMS m_tms;

TMS *tms_mgr()
{
    return &m_tms;
}

bool TMS::TMSCreate()
{
    //创建keyid
    IPCKEY key = ipcs_shmkey(TMS_SHM_KEY);
    //创建共享内存
    m_shm_id = sysv_get_shm(key, sizeof(TMS_DATABASE), IPC_CREAT|IPC_EXCL|0644);
    if(m_shm_id < 0)
    {
        log_fatal("tms_create::open globalSection failure.");
        return false;
    }
    //attach share memory
    m_shm_ptr = sysv_attach_shm(m_shm_id, 0, 0);
    if(NULL == m_shm_ptr )
    {
        log_fatal("tms_create::attach tms database failed!");
        return false;
    }
    tms_database_ptr = (TMS_DATABASE_PTR)m_shm_ptr;
    //init share memory data
    initTMSData();
    //detach share memory
    if(sysv_detach_shm(m_shm_ptr) < 0)
    {
        log_fatal("tms_create::detach tms database failed!");
        return false;
    }

    log_info("tms create success! shm_key[%#x] shm_id[%d] size[%lu]", key, m_shm_id, sizeof(TMS_DATABASE));
    return true;
}

bool TMS::TMSDestroy()
{
    if (sysv_ctl_shm(m_shm_id, IPC_RMID, NULL) < 0)
    {
        log_error("tms_destroy:delete globalSection failure.");
        return false;
    }
    return true;
}

bool TMS::TMSInit()
{
    //创建keyid
    IPCKEY  tmskey = ipcs_shmkey(TMS_SHM_KEY);
    //创建共享内存
    m_shm_id = sysv_get_shm(tmskey, 0, 0);
    if(m_shm_id < 0)
    {
        log_fatal("tms_init::open globalSection failure.");
        return false;
    }
    //attach share memory
    m_shm_ptr = sysv_attach_shm(m_shm_id, 0, 0);
    if(NULL == m_shm_ptr)
    {
        log_fatal("tms_init::attach tms database failed!");
        return false;
    }
    tms_database_ptr = (TMS_DATABASE_PTR)m_shm_ptr;
    return true;
}

bool TMS::TMSClose()
{
    if(sysv_detach_shm(m_shm_ptr) < 0)
    {
        log_fatal("tms_close::detach tms database failed!");
        return false;
    }
    return true;
}

//初始化tms的内存数据
void TMS::initTMSData()
{
    memset(tms_database_ptr, 0, sizeof(TMS_DATABASE));

    //初始化共享内存
    TMS_TERMINAL_RECORD *pTerm = NULL;
    for(int i = 0; i < MAX_TERMINAL_NUMBER; i++)
    {
        pTerm = &tms_database_ptr->arrayTerm[i];
        pTerm->used = false;
        pTerm->index = i;
    }
    tms_database_ptr->termCount = 0;
    resetSequence();
    return;
}


//通过索引值获得终端机
TMS_TERMINAL_RECORD *TMS::getTermByIndex(int32 index)
{
    if (index >= MAX_TERMINAL_NUMBER || index < 0) {
        log_error("index [%d] exceeds limit [%d]", index, MAX_TERMINAL_NUMBER);
        return NULL;
    }
    TMS_TERMINAL_RECORD *pTerm = &tms_database_ptr->arrayTerm[index];
    if (!pTerm->used) {
        return NULL;
    }
    return pTerm;
}
uint64 TMS::generate_token(int32 index)
{
    struct timeval now;
    gettimeofday(&now, NULL);
    uint64 token = (uint16)index | ((uint64)(now.tv_sec*2+now.tv_usec*index)<<16);
    return token;
}
TMS_TERMINAL_RECORD *TMS::verify_token(uint64 token)
{
    uint32 term_index = token & 0x000000000000FFFF;
    TMS_TERMINAL_RECORD *pTerm = &tms_database_ptr->arrayTerm[term_index];
    if (pTerm->used && (pTerm->token == token) && ((time(0)-pTerm->token_last_update) < sysdb_getTokenExpired())) {
        return pTerm;
    }
    log_debug("token[%llu] pTerm->token[%llu] update[%u]", token, pTerm->token, pTerm->token_last_update);
    return NULL;
}
//获得共享内存中在用终端机的数量
uint32 TMS::getTermCount()
{
    return tms_database_ptr->termCount;
}
//终端机认证成功(认证成功后添加)
TMS_TERMINAL_RECORD* TMS::authTerm(uint64 termCode, uint64 agencyCode, uint32 areaCode, uint8 *mac, int32 ncpIdx)
{
    TMS_TERMINAL_RECORD *pTerm = NULL;
    int index;
    for (index = 0; index < MAX_TERMINAL_NUMBER; index++) {
        pTerm = &tms_database_ptr->arrayTerm[index];
        if ((pTerm->used == false) ||
            ((pTerm->used == true) && (pTerm->termCode == termCode)) ||
            ((pTerm->used == true) && ((time(0)-pTerm->token_last_update) > sysdb_getTokenExpired())))
        {
            pTerm = &tms_database_ptr->arrayTerm[index];
            pTerm->token = generate_token(index);
            pTerm->token_last_update = get_now();
            pTerm->termCode = termCode;
            pTerm->agencyCode = agencyCode;
            pTerm->areaCode = areaCode;
            memcpy(pTerm->szMac,mac,6);
            pTerm->workStatus = TELLER_WORK_SIGNOUT;
            pTerm->tellerCode = 0;

            pTerm->ncpIdx = ncpIdx;
            pTerm->lastCommTime = 0;
            
            pTerm->timeStamp = 0;
            pTerm->delayMilliSeconds = 0;
            pTerm->beginOnline = 0;
            pTerm->spTimeStamp = 0;

            pTerm->isBusy = false;
            pTerm->used = true;

            tms_database_ptr->termCount++;
            return pTerm;
        }
    }
    //没有空闲的终端
    return NULL;
}
void TMS::clearTerm(int32 index)
{
    TMS_TERMINAL_RECORD *pTerm = getTermByIndex(index);
    if (pTerm == NULL) {
        return;
    }
    pTerm->token = 0;
    pTerm->token_last_update = 0;
    pTerm->termCode = 0;
    pTerm->agencyCode = 0;
    pTerm->areaCode = 0;
    memset(pTerm->szMac,0,6);
    pTerm->workStatus = TELLER_WORK_SIGNOUT;
    pTerm->tellerCode = 0;
    pTerm->flowNumber = 0;

    pTerm->ncpIdx = -1;
    pTerm->isBusy = false;
    pTerm->msn = 0;
    pTerm->lastCommTime = 0;
    pTerm->used = false;
    tms_database_ptr->termCount--;
    return;
}

//1. 向单个终端发送重置终端消息
//2. 将终端的msn置为0
//3. 将终端的busy状态置为false
//4. 若终端的workStatus为TELLER_WORK_SIGNIN，则将其改为TELLER_WORK_SIGNOUT，并将当前签入的销售员的
//   workStatus也改为TELLER_WORK_SIGNOUT
void TMS::resetTerm(int32 index)
{
    TMS_TERMINAL_RECORD *pTerm = getTermByIndex(index);
    if (pTerm == NULL) {
        return;
    }
    //reset terminal
    log_info("resetTerm(%llu): terminal is reset", pTerm->termCode);

    clearTerm(index);
    return;
}
//登录成功后更新内存
int32 TMS::signinTerm(int32 index, uint32 tellerCode, uint64 flow)
{
    TMS_TERMINAL_RECORD *pTerm = getTermByIndex(index);
    if (pTerm == NULL) {
        return -1;
    }
    pTerm->workStatus = TELLER_WORK_SIGNIN;
    pTerm->tellerCode = tellerCode;
    pTerm->flowNumber = flow;
    return 0;
}
//签退后更新内存
int32 TMS::signoutTerm(int32 index)
{
    TMS_TERMINAL_RECORD *pTerm = getTermByIndex(index);
    if (pTerm == NULL) {
        return -1;
    }
    pTerm->workStatus = TELLER_WORK_SIGNOUT;
    pTerm->tellerCode = 0;
    return 0;
}
uint64 TMS::getSequence()
{
    return tms_database_ptr->sequence++;
}
void TMS::resetSequence()
{
    tms_database_ptr->sequence = time(0)%(3600*24);
}

void TMS::setAllTermNoBusy()
{
    for (int index = 0; index < MAX_TERMINAL_NUMBER; index++) {
        tms_database_ptr->arrayTerm[index].isBusy = false;
    }
}



int32 notify_agency_sale_bigAmount(uint64 agency_code, uint8 game_code, uint64 issue_number, money_t sale_amount, money_t available_amount)
{
    GLTP_MSG_NTF_GL_SALE_MONEY_WARN notify;
    notify.agencyCode = agency_code;
    notify.gameCode = game_code;
    notify.issueNumber = issue_number;
    notify.salesAmount = sale_amount;
    notify.availableCredit = available_amount;
    //发送Notify消息
    sys_notify(GLTP_NTF_GL_SALE_MONEY_WARN, _WARN,
        (char*)&notify, sizeof(GLTP_MSG_NTF_GL_SALE_MONEY_WARN));
    return 0;
}

int32 notify_agency_pay_bigAmount(uint64 agency_code, uint8 game_code, uint64 issue_number, money_t pay_amount, money_t available_amount)
{
    GLTP_MSG_NTF_GL_PAY_MONEY_WARN notify;
    notify.agencyCode = agency_code;
    notify.gameCode = game_code;
    notify.issueNumber = issue_number;
    notify.payAmount = pay_amount;
    notify.availableCredit = available_amount;
    //发送Notify消息
    sys_notify(GLTP_NTF_GL_PAY_MONEY_WARN, _WARN,
        (char*)&notify, sizeof(GLTP_MSG_NTF_GL_PAY_MONEY_WARN));
    return 0;
}

int32 notify_agency_cancel_bigAmount(uint64 agency_code, uint8 game_code, uint64 issue_number, money_t cancel_amount, money_t available_amount)
{
    GLTP_MSG_NTF_GL_CANCEL_MONEY_WARN notify;
    notify.agencyCode = agency_code;
    notify.gameCode = game_code;
    notify.issueNumber = issue_number;
    notify.cancelAmount = cancel_amount;
    notify.availableCredit = available_amount;
    //发送Notify消息
    sys_notify(GLTP_NTF_GL_CANCEL_MONEY_WARN, _WARN,
        (char*)&notify, sizeof(GLTP_MSG_NTF_GL_CANCEL_MONEY_WARN));
    return 0;
}


