/*==============================================================================
 * 包含系统文件
 * Includes System Files
 =============================================================================*/

/*==============================================================================
 * 包含本地文件
 * Include Files
 =============================================================================*/
#include "global.h"

/*==============================================================================
 * 常量定义，并对所定义的常量进行说明
 * Constant / Define Declarations
 =============================================================================*/

/*==============================================================================
 * 类型定义(struct、enum)等,如果是重要数据结构，要详细说明
 * Type Declarations(struct,enum etc.) and Brief Description
 * If it's Significant,Detailed Description Should Be Present
 =============================================================================*/

union unionsem
{
    int32 value;
    uint16 array;
    struct semid_ds * dsbuf;
};

/*==============================================================================
 * 全局常量定义，并对其进行简要说明
 * Global Constant Declarations and Brief Description
 =============================================================================*/

extern int32 errno;

/*==============================================================================
 * 本地值/函数宏定义，并对其进行简要说明
 * Local Variable and Macro Definitions and Brief Description
 =============================================================================*/

/*==============================================================================
 函数功能：


 参数列表：
 参数：

 函数返回：


 函数说明：


 调用范围：


 修改记录：

 修改日期              CR No        修改人         描述
 ----------      ------------      --------        -------------
 2009-09-18                           Tommy         RRU Version

 =============================================================================*/
IPCKEY sysv_create_key(
        const char* _fname_,
        const int _subid_)
{
    key_t newkey = ftok(_fname_, _subid_);

    if (newkey == (key_t)IPC_FAILURE)
    {
        perrork("create ipcs key from(%s,%d) failed!",_fname_,_subid_);
    }

    return newkey;
}

/*==============================================================================
 函数功能：


 参数列表：
 参数：

 函数返回：
 value   shmget()was successful. The value returned is the shared memory ID
 associated with the key parameter.
 -1      shmget() was not successful. The errno variable is set to indicate the error.

 函数说明：


 调用范围：


 修改记录：

 修改日期              CR No        修改人         描述
 ----------      ------------      --------        -------------
 2009-10-08                        Forrest

 =============================================================================*/
int32 sysv_get_shm(
        IPCKEY _keyid_,
        size_t _size_,
        int32 _shmflg_)
{
    int32 ret = shmget(_keyid_, _size_, _shmflg_);
    if (ret == IPC_FAILURE)
    {
        perrork("shmget(%d,%d,%d) return error!\n",(int32)_keyid_,(int32)_size_,_shmflg_);
    }
    return ret;
}

/*==============================================================================
 函数功能：


 参数列表：
 参数：

 函数返回：

 函数说明：


 调用范围：


 修改记录：

 修改日期              CR No        修改人         描述
 ----------      ------------      --------        -------------
 2009-10-08                        Forrest

 =============================================================================*/
int32 sysv_ctl_shm(
        int32 _shmid_,
        int32 _cmd_,
        struct shmid_ds *_buf_)
{
    int32 ret = shmctl(_shmid_, _cmd_, _buf_);
    if (ret == IPC_FAILURE)
    {
        perrork("shmctl(%d,%d) return error!\n",_shmid_,_cmd_);
    }
    return ret;
}

/*==============================================================================
 函数功能：


 参数列表：
 参数：

 函数返回：
 value   shmat() was successful. The value returned is a pointer
 to the shared memory segment associated with the specified identifier.
 NULL    shmat() was not successful. The errno variable is set to indicate the error.

 函数说明：


 调用范围：


 修改记录：

 修改日期              CR No        修改人         描述
 ----------      ------------      --------        -------------
 2009-10-08                        Forrest

 =============================================================================*/
void* sysv_attach_shm(
        int32 _shmid_,
        const void *_shmaddr_,
        int32 _shmflg_)
{
    void* retp = shmat(_shmid_, _shmaddr_, _shmflg_);
    if (retp == (void *)-1)
    {
        perrork("shmat(%d,_,%d) return error!\n",_shmid_,_shmflg_);
    }
    return retp;
}

/*==============================================================================
 函数功能：


 参数列表：
 参数：

 函数返回：
 0    shmdt() was successful.
 -1   shmdt() was not successful. The errno variable is set to indicate the error.


 函数说明：


 调用范围：


 修改记录：

 修改日期              CR No        修改人         描述
 ----------      ------------      --------        -------------
 2009-10-08                        Forrest

 =============================================================================*/
int32 sysv_detach_shm(
        const void *_shmaddr_)
{
    int32 ret = shmdt(_shmaddr_);
    if (ret == IPC_FAILURE)
    {
        perrork("shmdt() return error!\n");
    }
    return ret;
}

/*==============================================================================
 函数功能：创建信号量集，并将信号集中的各个信号量初始值设置为1


 参数列表：
 参数：

 函数返回：


 函数说明：


 调用范围：


 修改记录：

 修改日期              CR No        修改人         描述
 ----------      ------------      --------        -------------
 2009-09-18                        Tommy

 =============================================================================*/
SEM_ID sysv_sem_create(
        IPCKEY _keyid_,
        int8 _size_)
{
    int index;

    union unionsem param;

    int sysvid = semget(_keyid_, _size_, 0644 | IPC_CREAT);

    if (sysvid == IPC_FAILURE)
    {
        perrork("create semaphore(%d) failed!\n",(int32)_keyid_);

        return IPC_FAILURE;
    }
    else
    {
        param.value = 1;
        for (index = 0; index < _size_; index++)
        {
            if (semctl(sysvid, index, SETVAL, param) == IPC_FAILURE)
            {
                perrork("initial semaphore(%d,%d) failed!\n",(int32)_keyid_,index);

                return IPC_FAILURE;
            }
        }
        return sysvid;
    }
}


/*==============================================================================
 函数功能：创建信号量集，并将信号集中的各个信号量初始值设置为value
 参数列表：
 参数：
 函数返回：
 函数说明：
 调用范围：
 修改记录：
 修改日期              CR No        修改人         描述
 ----------      ------------      --------        -------------
 2009-09-18                        xiongal

 =============================================================================*/
SEM_ID sysv_sem_createAndSet(
        IPCKEY _keyid_,
        int8 _size_,
        int8 _value_)
{
    int index;

    union unionsem param;

    int sysvid = semget(_keyid_, _size_, 0644 | IPC_CREAT);

    if (sysvid == IPC_FAILURE)
    {
        perrork("create semaphore(%d) failed!\n",(int32)_keyid_);

        return IPC_FAILURE;
    }
    else
    {
        param.value = _value_;
        for (index = 0; index < _size_; index++)
        {
            if (semctl(sysvid, index, SETVAL, param) == IPC_FAILURE)
            {
                perrork("initial semaphore(%d,%d) failed!\n",(int32)_keyid_,index);

                return IPC_FAILURE;
            }
        }
        return sysvid;
    }
}


/*==============================================================================
 函数功能：获取信号量集的semid，不改变其中各个信号量的值
 参数列表：
 参数：
 函数返回：
 函数说明：
 调用范围：
 修改记录：
 修改日期              CR No        修改人         描述
 ----------      ------------      --------        -------------
 2009-09-18                        xiongal

 =============================================================================*/
SEM_ID sysv_sem_get(
        IPCKEY _keyid_,
        int8 _size_
        )
{
    int sysvid = semget(_keyid_, _size_, 0644 | IPC_CREAT);

    if (sysvid == IPC_FAILURE)
    {
        perrork("create semaphore(%d) failed!\n",(int32)_keyid_);

        return IPC_FAILURE;
    }
    return sysvid;
}


/*==============================================================================
 函数功能：


 参数列表：
 参数：

 函数返回：


 函数说明：


 调用范围：


 修改记录：

 修改日期              CR No        修改人         描述
 ----------      ------------      --------        -------------
 2009-09-18                           Tommy

 =============================================================================*/
void sysv_sem_remove(
        SEM_ID _semid_)
{
    if (semctl(_semid_, 1, IPC_RMID, null) == IPC_FAILURE)
    {
        perrork("delete semaphore(%d) failed!\n",_semid_);
    }
}

/*==============================================================================
 函数功能：


 参数列表：
 参数：

 函数返回：


 函数说明：


 调用范围：


 修改记录：

 修改日期              CR No        修改人         描述
 ----------      ------------      --------        -------------
 2009-09-18                           Tommy

 =============================================================================*/
bool sysv_sem_setval(
        SEM_ID _semid_,
        int32 _which_,
        int32 _value_)
{
    union unionsem param;
    param.value = _value_;
    if (semctl(_semid_, _which_, SETVAL, param) == IPC_FAILURE)
    {
        perrork("setval semaphore(%d) value failed!\n",_semid_);
        return false;
    }
    else
    {
        return true;
    }
}


int sys_sem_getval(SEM_ID _semid_, int32 _which_)
{
    return semctl(_semid_,_which_,GETVAL,0);
}
/*==============================================================================
 函数功能：


 参数列表：
 参数：

 函数返回：


 函数说明：


 调用范围：


 修改记录：

 修改日期              CR No        修改人         描述
 ----------      ------------      --------        -------------
 2009-09-18                           Tommy

 =============================================================================*/
bool SEM_P(
        SEM_ID _semid_,
        int32 _which_)
{
    struct sembuf sem[1];
    sem[0].sem_op = -1;
    sem[0].sem_flg = 0;
    sem[0].sem_num = _which_;
    do
    {
        if (semop(_semid_, sem, 1) == IPC_FAILURE)
        {
            if (errno == EINTR)
            {
                continue;
            }
            else
            {
                perrork("semaphore(%d) P operation failure.\n",_semid_);

                return false;
            }
        }
        else
        {
            return true;
        }
    } while (1);
}

/*==============================================================================
 函数功能：


 参数列表：
 参数：

 函数返回：


 函数说明：


 调用范围：


 修改记录：

 修改日期              CR No        修改人         描述
 ----------      ------------      --------        -------------
 2009-09-18                           Tommy

 =============================================================================*/
bool SEM_P_TIMED(
        SEM_ID _semid_,
        int32 _which_,
        struct timespec *timeout)
{
    struct sembuf sem[1];
    sem[0].sem_op = -1;
    sem[0].sem_flg = 0;
    sem[0].sem_num = _which_;
    do
    {
        if (semtimedop(_semid_, sem, 1, timeout) == IPC_FAILURE)
        {
            if (errno == EINTR)
            {
                continue;
            }
            else if (errno != EAGAIN)
            {
                perrork("semaphore(%d) P operation failure.\n",_semid_);
            }

            return false;
        }
        else
        {
            return true;
        }
    } while (1);
}

/*==============================================================================
 函数功能：


 参数列表：
 参数：

 函数返回：


 函数说明：


 调用范围：


 修改记录：

 修改日期              CR No        修改人         描述
 ----------      ------------      --------        -------------
 2009-09-18                           Tommy

 =============================================================================*/

int32 SEM_P_NOWAIT(
        SEM_ID _semid_,
        int32 _which_)
{
    struct sembuf sem[1];
    sem[0].sem_op = -1;
    sem[0].sem_flg = IPC_NOWAIT;
    sem[0].sem_num = _which_;
    do
    {
        if (semop(_semid_, sem, 1) == IPC_FAILURE)
        {
            if (errno == EAGAIN)
            {
                  return 0;
            }
            else if(errno==EINTR)
            {
                  return 0;
            }
            else
            {
                perrork("semaphore(%d) P operation failure.\n",_semid_);

                return -1;
            }
        }
        else
        {
            return 1;
        }
    } while (1);
}


int32 SEM_V_NOWAIT(
        SEM_ID _semid_,
        int32 _which_)
{
    struct sembuf sem[1];
    sem[0].sem_op = 1;
    sem[0].sem_flg = IPC_NOWAIT;
    sem[0].sem_num = _which_;
    do
    {
        if (semop(_semid_, sem, 1) == IPC_FAILURE)
        {
            if (errno == EAGAIN)
            {
                  return 0;
            }
            else if(errno==EINTR)
            {
                  return 0;
            }
            else
            {
                perrork("semaphore(%d) P operation failure.\n",_semid_);

                return -1;
            }
        }
        else
        {
            return 1;
        }
    } while (1);
}

/*==============================================================================
 函数功能：


 参数列表：
 参数：

 函数返回：


 函数说明：


 调用范围：


 修改记录：

 修改日期              CR No        修改人         描述
 ----------      ------------      --------        -------------
 2009-09-18                           Tommy

 =============================================================================*/
bool SEM_PS(
        SEM_ID _semid_,
        int32 _which_,
        int32 _count_)
{
    struct sembuf sem[1];
    sem[0].sem_flg = 0;
    sem[0].sem_num = _which_;
    sem[0].sem_op = -1 * (_count_);

    do
    {
        if (semop(_semid_, sem, 1) == IPC_FAILURE)
        {
            if (errno == EINTR)
            {
                continue;
            }
            else
            {
                perrork("semaphore(%d) PS(%d) operation failure.\n",_semid_,_count_);

                return false;
            }
        }
        else
        {
            return true;
        }
    } while (1);
}

/*==============================================================================
 函数功能：


 参数列表：
 参数：

 函数返回：


 函数说明：


 调用范围：


 修改记录：

 修改日期              CR No        修改人         描述
 ----------      ------------      --------        -------------
 2009-09-18                           Tommy

 =============================================================================*/
bool SEM_V(
        SEM_ID _semid_,
        int32 _which_)
{
    struct sembuf sem[1];
    sem[0].sem_op = +1;
    sem[0].sem_flg = 0;
    sem[0].sem_num = _which_;

    do
    {
        if (semop(_semid_, sem, 1) == IPC_FAILURE)
        {
            if (errno == EINTR)
            {
                continue;
            }
            else
            {
                perrork("semaphore(%d) V operation failure. ",_semid_);

                return false;
            }
        }
        else
        {
            return true;
        }
    } while (1);

}


/*==============================================================================
 函数功能：


 参数列表：
 参数：

 函数返回：


 函数说明：


 调用范围：


 修改记录：

 修改日期              CR No        修改人         描述
 ----------      ------------      --------        -------------
 2009-09-18                           Tommy

 =============================================================================*/
bool SEM_V_TIMED(
        SEM_ID _semid_,
        int32 _which_,
        struct timespec *timeout)
{
    struct sembuf sem[1];
    sem[0].sem_op = +1;
    sem[0].sem_flg = 0;
    sem[0].sem_num = _which_;

    do
    {
        if (semtimedop(_semid_, sem, 1, timeout) == IPC_FAILURE)
        {
            if (errno == EINTR)
            {
                continue;
            }
            else if (errno != EAGAIN)
            {
                perrork("semaphore(%d) V operation failure. ",_semid_);
            }

            return false;
        }
        else
        {
            return true;
        }
    } while (1);

}

/*==============================================================================
 函数功能：


 参数列表：
 参数：

 函数返回：


 函数说明：


 调用范围：


 修改记录：

 修改日期              CR No        修改人         描述
 ----------      ------------      --------        -------------
 2009-09-18                           Tommy         RRU Version

 =============================================================================*/
bool SEM_VS(
        SEM_ID _semid_,
        int32 _which_,
        int32 _count_)
{
    struct sembuf sem[1];
    sem[0].sem_flg = 0;
    sem[0].sem_num = _which_;
    sem[0].sem_op = +1 * (_count_);

    do
    {
        if (semop(_semid_, sem, 1) == IPC_FAILURE)
        {
            if (errno == EINTR)
            {
                continue;
            }
            else
            {
                perrork("semaphore(%d) VS(%d) operation failure. ",_semid_,_count_);

                return false;
            }
        }
        else
        {
            return true;
        }
    } while (1);
}

/*==============================================================================
 函数功能：


 参数列表：
 参数：

 函数返回：


 函数说明：


 调用范围：


 修改记录：

 修改日期              CR No        修改人         描述
 ----------      ------------      --------        -------------
 2009-09-18                           Tommy         RRU Version

 =============================================================================*/
MSG_ID sysv_msg_create(
        IPCKEY _keyid_)
{
    int sysvid = msgget(_keyid_, 0644 | IPC_CREAT);

    if (sysvid == IPC_FAILURE)
    {
        perrork("create message queue(%d) failed!",(int32)_keyid_);
    }

    return sysvid;
}

/*==============================================================================
 函数功能：


 参数列表：
 参数：

 函数返回：


 函数说明：


 调用范围：


 修改记录：

 修改日期              CR No        修改人         描述
 ----------      ------------      --------        -------------
 2009-09-18                           Tommy         RRU Version

 =============================================================================*/
void sysv_msg_remove(
        MSG_ID _msgid_)
{
    if (msgctl(_msgid_, IPC_RMID, null) == IPC_FAILURE)
    {
        perrork("delete message queue(%d) failed!",_msgid_);
    }
}

bool MSG_S(
        MSG_ID _msgid_,
        long _type_,
        void* _data_,
        int32 _off_,
        int32 _size_)
{
    char* point = (char*) _data_;
    point = point + _off_;
    msgipc_buffer message;
    message.msgtype = _type_;
    memcpy(message.msgtext, point, _size_);
    return msgsnd(_msgid_, &message, _size_, IPC_NOWAIT) == 0;
}

bool MSG_S_BLOCK(
        MSG_ID _msgid_,
        long _type_,
        void* _data_,
        int32 _off_,
        int32 _size_)
{
    char* point = (char*) _data_;
    point = point + _off_;
    msgipc_buffer message;
    message.msgtype = _type_;
    memcpy(message.msgtext, point, _size_);
    return msgsnd(_msgid_, &message, _size_, 0) == 0;
}

int32 MSG_R(
        MSG_ID _msgid_,
        long _type_,
        void* _data_,
        int32 _off_,
        int32 _size_)
{
    char* point = (char*) _data_;
    point = point + _off_;
    msgipc_buffer message;
    int size = msgrcv(_msgid_, &message, 8192, _type_, IPC_NOWAIT);
    if (size > -1)
    {
        size = MIN_V(_size_,size);
        memcpy(point, message.msgtext, size);
    }
    return size;
}

int32 MSG_R_BLOCK(
        MSG_ID _msgid_,
        long _type_,
        void* _data_,
        int32 _off_,
        int32 _size_)
{
    char* point = (char*) _data_;
    point = point + _off_;
    msgipc_buffer message;
    int size = msgrcv(_msgid_, &message, 8192, _type_, 0);
    if (size > -1)
    {
        size = MIN_V(_size_,size);
        memcpy(point, message.msgtext, size);
    }
    return size;
}

IPCKEY ipcs_shmkey(
        const int _keyid_)
{
    return sysv_create_key(IPC_SHMPATH, _keyid_);
}

IPCKEY ipcs_semkey(
        const int _keyid_)
{
    return sysv_create_key(IPC_SEMPATH, _keyid_);
}

IPCKEY ipcs_msgkey(
        const int _keyid_)
{
    return sysv_create_key(IPC_MSGPATH, _keyid_);
}

