#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <errno.h>
#include <string.h>
#include <stdarg.h>
#include <time.h>
#include <stdio.h>

#include "shm_mod.h"
#include "log.h"

static int   nGlobalMem = 0;          // descriptor of the shm
static char *pGlobalMem = NULL;       // pointer to the shm
static int   nGlobalLen = 0;          // length of the shm

static RNG_SHM_PTR shm_ptr = NULL;

// helper function to get formatted time in c string
char *get_date_time_format(time_t t, char *f)
{
    struct tm mytm;
    localtime_r(&t, &mytm);
    strftime(f, 32, "%Y-%m-%d %H:%M:%S", &mytm);
    return f;
}

// create shared memory
int shm_create(void)
{
    int ret;
    key_t keyid;

    nGlobalLen = sizeof(RNG_SHM_INFO);

    // create keyid
    keyid = ftok(RNG_SHM_PATH, RNG_SHM_KEY);
    if (keyid == -1) {
        log("ftok() [%s]", strerror(errno));
        return -1;
    }

    // delete the shared memory in the last session if exists
    nGlobalMem = shmget(keyid, 0, 0);
    if (nGlobalMem >= 0) {
        log("shared memory already exists. delete first.");
        ret = shmctl(nGlobalMem, IPC_RMID, NULL);
        if (ret == -1) {
            log("shmclt(IPC_RMID) [%s]", strerror(errno));
            return -1;
        }
        log("previous shared memory deleted.");
    }
    else if (errno != ENOENT) { // error, but not caused by non-existence of shm
        log("shmget() [%s]", strerror(errno));
        return -1;
    }
    else {
        log("shmget() no previous shm session exists");
    }

    // create shared memory
    nGlobalMem = shmget(keyid, nGlobalLen, IPC_CREAT|IPC_EXCL|0644);
    if (nGlobalMem == -1) {
        log("shmget() [%s]", strerror(errno));
        return -1;
    }

    // attach shared memory
    pGlobalMem = (char *)shmat(nGlobalMem, 0, 0);
    if (pGlobalMem == (char *)-1) {
        log("shmat() [%s]", strerror(errno));
        return -1;
    }

    // initialize shared memory
    memset(pGlobalMem, 0, nGlobalLen);

    // detach the shared memory
    ret = shmdt(pGlobalMem);
    if (ret == -1) {
        log("shmdt() [%s]", strerror(errno));
        return -1;
    }

    log("shm_create() success! shm_key[%#x] shm_id[%d]", keyid, nGlobalMem);
    return 0;
}

// delete shared memory
int shm_destroy(void)
{
    int ret;
    key_t keyid;

    // create keyid
    keyid = ftok(RNG_SHM_PATH, RNG_SHM_KEY);
    if (keyid == -1) {
        log("ftok() [%s]", strerror(errno));
        return -1;
    }

    // get the descriptor of the shared memory
    nGlobalMem = shmget(keyid, 0, 0);
    if (nGlobalMem == -1) {
        log("shmget() [%s]", strerror(errno));
        return -1;
    }

    // delete the shared memory
    ret = shmctl(nGlobalMem, IPC_RMID, NULL);
    if (ret == -1) {
        log("shmclt(IPC_RMID) [%s]", strerror(errno));
        return -1;
    }

    log("shm_destroy() success!");
    return 0;
}

// attach shared memory
int shm_init(void)
{
    key_t keyid;

    // create keyid
    keyid = ftok(RNG_SHM_PATH, RNG_SHM_KEY);
    if (keyid == -1) {
        log("ftok() [%s]", strerror(errno));
        return -1;
    }

    // get the descriptor of the shared memory
    nGlobalMem = shmget(keyid, 0, 0);
    if (nGlobalMem == -1) {
        log("shmget() [%s]", strerror(errno));
        return -1;
    }

    // attach the shared memory
    pGlobalMem = (char *)shmat(nGlobalMem, 0, 0);
    if (pGlobalMem == (char *)-1) {
        log("shmat() [%s]", strerror(errno));
        return -1;
    }

    // make the global info pointer point to the shared memory
    shm_ptr = (RNG_SHM_PTR)pGlobalMem;

    return 0;
}

// close shared memory
int shm_close(void)
{
    int ret;

    if (pGlobalMem == NULL) {
        log("pGlobalMem is NULL");
        return -1;
    }

    // detach shared memory
    ret = shmdt(pGlobalMem);
    if (ret == -1) {
        log("shmdt() [%s]", strerror(errno));
        return -1;
    }

    nGlobalMem = 0;
    pGlobalMem = NULL;
    nGlobalLen = 0;
    shm_ptr = NULL;

    return 0;
}

// get the pointer of shared memory
RNG_SHM_PTR get_shm_ptr(void)
{
    return shm_ptr;
}

int shm_runlog_info(const char *str, ...)
{
    time_t now = time(NULL);
    struct tm nowtm;
    localtime_r(&now, &nowtm);

    va_list ap;

    // it's subtle to tune the indices...
    memset(shm_ptr->run_info_array[shm_ptr->run_idx], 0, LOG_LENGTH);
    strftime(shm_ptr->run_info_array[shm_ptr->run_idx], 9, "%H:%M:%S", &nowtm);
    shm_ptr->run_info_array[shm_ptr->run_idx][8] = ' ';
    shm_ptr->run_info_array[shm_ptr->run_idx][9] = ' ';

    va_start(ap, str);
    vsnprintf(&(shm_ptr->run_info_array[shm_ptr->run_idx][10]), LOG_LENGTH-12, str, ap);
    va_end(ap);

    //log("%s", shm_ptr->run_info_array[shm_ptr->run_idx]);

    if (shm_ptr->run_idx == LOG_NUMBER-1) {
        shm_ptr->run_idx = 0;
    }
    else {
        shm_ptr->run_idx++;
    }

    return 0;
}

int shm_business_info(const char *str, ...)
{
    time_t now = time(NULL);
    struct tm nowtm;
    localtime_r(&now, &nowtm);

    va_list ap;

    // it's subtle to tune the indices...
    memset(shm_ptr->business_info_array[shm_ptr->business_idx], 0, LOG_LENGTH);
    strftime(shm_ptr->business_info_array[shm_ptr->business_idx], 9, "%H:%M:%S", &nowtm);
    shm_ptr->business_info_array[shm_ptr->business_idx][8] = ' ';
    shm_ptr->business_info_array[shm_ptr->business_idx][9] = ' ';

    va_start(ap, str);
    vsnprintf(&(shm_ptr->business_info_array[shm_ptr->business_idx][10]), LOG_LENGTH-12, str, ap);
    va_end(ap);

    //log("%s", shm_ptr->business_info_array[shm_ptr->business_idx]);

    if (shm_ptr->business_idx == LOG_NUMBER-1) {
        shm_ptr->business_idx = 0;
    }
    else {
        shm_ptr->business_idx++;
    }

    return 0;
}






