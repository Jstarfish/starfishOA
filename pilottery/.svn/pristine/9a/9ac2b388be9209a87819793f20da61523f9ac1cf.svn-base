#ifndef HCIPC_H_INCLUDED
#define HCIPC_H_INCLUDED


/*==============================================================================
 * 全局常量及值宏定义，并对其进行简要说明
 * Global Constant & Macro Definitions and Brief Description
 =============================================================================*/
#define  IPC_FAILURE (-1) 

/*==============================================================================
 * 类型定义(struct、enum)等,如果是重要数据结构，要详细说明
 * Type Declarations(struct,enum etc.) and Brief Description
 * If it's Significant,Detailed Description Should Be Present
 =============================================================================*/
typedef key_t IPCKEY;
typedef int32 SEM_ID;
typedef int32 MSG_ID;
typedef int32 SHM_ID;

struct msgipc_buffer
{
    long msgtype;
    char msgtext[8192];   //最大的notify和report长度
}__attribute__ ((packed));

/*==============================================================================
 * 函数定义，并对其进行简要说明
 * Funcs Definitions and Brief Description
 =============================================================================*/

IPCKEY sysv_create_key(
        const char* _fname_,
        const int _subid_);

SHM_ID sysv_get_shm(
        IPCKEY _keyid_,
        size_t _size_,
        int32 _shmflg_);

int32 sysv_ctl_shm(
        SHM_ID _shmid_,
        int32 _cmd_,
        struct shmid_ds *_buf_);

void* sysv_attach_shm(
        SHM_ID _shmid_,
        const void *_shmaddr_,
        int32 _shmflg_);

int32 sysv_detach_shm(
        const void *_shmaddr_);
/*==============================================================================
 * 创建信号量集，并将其初始化为1。
 * 如果信号量集已经存在，其包含的信号量都将初始化为1
 =============================================================================*/
SEM_ID sysv_sem_create(
        IPCKEY _keyid_,
        int8 _size_);

/*==============================================================================
 * 创建信号量集，并将其初始化为指定值value。
 * 如果信号量集已经存在，其包含的信号量都将初始化为value
 =============================================================================*/
SEM_ID sysv_sem_createAndSet(
        IPCKEY _keyid_,
        int8 _size_,
        int8 _value_);

/*==============================================================================
 * 如果信号量集不经存在，创建信号量集，其包含的信号量的初始值为0
 * 如果信号量集已经存在，其包含的信号量都不改变
 =============sysv_sem_get=====================================================*/
SEM_ID sysv_sem_get(
        IPCKEY _keyid_,
        int8 _size_);


void sysv_sem_remove(
        SEM_ID _semid_);

bool sysv_sem_setval(
        SEM_ID _semid_,
        int32 _which_,
        int32 _value_);
int sys_sem_getval(SEM_ID _semid_, int32 _which_);
bool SEM_P(
        SEM_ID _semid_,
        int32 _which_);

bool SEM_P_TIMED(
        SEM_ID _semid_,
        int32 _which_,
        struct timespec *timeout);

int32 SEM_P_NOWAIT(
        SEM_ID _semid_,
        int32 _which_);

int32 SEM_V_NOWAIT(
        SEM_ID _semid_,
        int32 _which_);        

bool SEM_PS(
        SEM_ID _semid_,
        int32 _which_,
        int32 _count_);

bool SEM_V(
        SEM_ID _semid_,
        int32 _which_);

bool SEM_V_TIMED(
        SEM_ID _semid_,
        int32 _which_,
        struct timespec *timeout);

bool SEM_VS(
        int32 _semid_,
        int32 _which_,
        int32 _count_);

MSG_ID sysv_msg_create(
        IPCKEY _keyid_);

void sysv_msg_remove(
        MSG_ID _msgid_);

bool MSG_S(
        MSG_ID _msgid_,
        long _type_,
        void* _data_,
        int32 _off_,
        int32 _size_);

int32 MSG_R(
        MSG_ID _msgid_,
        long _type_,
        void* _data_,
        int32 _off_,
        int32 _size_);

bool MSG_S_BLOCK(
        MSG_ID _msgid_,
        long _type_,
        void* _data_,
        int32 _off_,
        int32 _size_);

int32 MSG_R_BLOCK(
        MSG_ID _msgid_,
        long _type_,
        void* _data_,
        int32 _off_,
        int32 _size_);


IPCKEY ipcs_shmkey(
        const int _keyid_);

IPCKEY ipcs_semkey(
        const int _keyid_);

IPCKEY ipcs_msgkey(
        const int _keyid_);



/*==============================================================================
 * 内联函数定义，并对其进行简要说明
 * Static Inline Functions Definitions and Brief Description
 =============================================================================*/

static __inline__ SHM_ID ipcs_newshm(
        const int _keyid_,
        const uint32 _size_,
        const int32 _shmflg_)
{
    IPCKEY ipckey = ipcs_shmkey(_keyid_);

    if (ipckey == IPC_FAILURE)
    {
        return IPC_FAILURE;
    }
    else
    {
        return sysv_get_shm(ipckey, _size_, _shmflg_);
    }
}

static __inline__ SEM_ID ipcs_newsem(
        const int _keyid_,
        const int _size_)
{
    IPCKEY ipckey = ipcs_semkey(_keyid_);

    if (ipckey == IPC_FAILURE)
    {
        return IPC_FAILURE;
    }
    else
    {
        return sysv_sem_create(ipckey, _size_);
    }
}

static __inline__ void ipcs_delsem(
        const SEM_ID semid)
{
    sysv_sem_remove(semid);
}

static __inline__ MSG_ID ipcs_newmsg(
        const int _keyid_)
{
    IPCKEY ipckey = ipcs_msgkey(_keyid_);

    if (ipckey == IPC_FAILURE)
    {
        return IPC_FAILURE;
    }
    else
    {
        return sysv_msg_create(ipckey);
    }
}

static __inline__ void ipcs_delmsg(
        const MSG_ID msgid)
{
    sysv_msg_remove(msgid);
}

#endif // HCIPC_H_INCLUDED
