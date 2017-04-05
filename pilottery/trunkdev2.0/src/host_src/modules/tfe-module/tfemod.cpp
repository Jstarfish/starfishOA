//#define TFE_SINGLE


#ifdef TFE_SINGLE
#include <stdio.h>
#include <iostream>
#include <algorithm>
#include <vector>
#include <list>
#include <limits>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <semaphore.h>
#include <sys/time.h>
#include <assert.h>
#include <errno.h>
#include <signal.h>
#include <pthread.h>
#include <time.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/mman.h>
#include <sys/sem.h>




typedef signed char int8;
typedef signed short int16;
typedef signed int int32;

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;

/*
typedef unsigned short ushort;

typedef unsigned long ulong;
typedef unsigned long point_t;
*/
typedef long long int64;
typedef unsigned long long uint64;



#define TFE_SHM_KEY             4

#define TFE_SEM_KEY                      181      // 181 ~ 190
#define TFE_SEM_KEY2                     182


#define MAX_GAME_NUMBER                8

#define TFE_TASK_CNT  (8 + MAX_GAME_NUMBER)
#define TFE_FILE_SIZE (256*1024*1024)


#define TFE_TIMEOUT      1
#define TFE_CRC_FAILED   2


enum TFE_TASKID {
    TFE_TASK_ADDER = 0,
    TFE_TASK_FLUSH = 1,

    TFE_TASK_REPLY,
    TFE_TASK_SCAN,
    TFE_TASK_UPDATE,
    TFE_TASK_UPDATE_DB,
    //TFE_TASK_UPDATE_DB2,
    //TFE_TASK_REMOTE_SYNC,
};


#define ts_notused(V) ((void) V)


#define TFE_DATA_SUBDIR "."

int32 ts_get_tf_filepath(uint32 tf_idx, char *path, int len)
{
    return snprintf(path, len, "%s/datazoo_%d.tf", TFE_DATA_SUBDIR, tf_idx);
}


#include "md5.h"

using namespace std;

#else

#include "global.h"

#include "tfemod.h"

#endif //TFE_SINGLE




static const uint16 crc_table[256] = {
    0xf1c0,0xf248,0x553e,0xae68,0xc753,0x6269,0x9a19,0x7fed,
    0xb010,0x4d44,0x6d07,0x9ec0,0x578c,0xbb57,0x07f1,0x3d1f,
    0x6944,0x1f29,0x014d,0xce4a,0x08b5,0x6f29,0xdb33,0x0c96,
    0x1e8b,0x2045,0x90b0,0x676f,0xb3c1,0x9316,0xcc1f,0x8e54,
    0xc1ea,0x65a2,0xa28b,0xe271,0x5801,0x9c97,0x636e,0x31f1,
    0xc563,0x06cb,0x1145,0xac9b,0x38ed,0xeadc,0xbecb,0xc577,
    0xf853,0x49f0,0x25e6,0x7cbf,0x9424,0xd1b9,0xa882,0x71b2,
    0x571b,0x45f9,0x58ed,0x4545,0x33b1,0xd356,0xf677,0xd606,
    0xb103,0x10bb,0xcc60,0x53ef,0x608f,0x5bcb,0x6458,0xa920,
    0x485a,0xb492,0xd323,0x5cc6,0xf96f,0x9c72,0x5d16,0x3655,
    0xd0e1,0x89c5,0x198d,0xe965,0xb1b7,0x1c39,0x6790,0x44f9,
    0x7069,0x103f,0x4338,0xc585,0xbcce,0x8327,0x2a91,0x661d,
    0xa5b9,0xcac7,0x1218,0x6e6b,0x6996,0xe1b2,0x3bfc,0x79b6,
    0x39b6,0xd112,0x6ace,0x81cf,0x7239,0xcc8d,0x2f46,0x1518,
    0x9ebd,0x1f35,0xca3e,0x7b97,0x0428,0xb3db,0x9723,0xa54b,
    0x6253,0x0a2e,0x005e,0x6517,0xc461,0xbd05,0xee83,0xf766,
    0x9500,0x87f5,0x4451,0x261e,0x53f0,0x7980,0x9cbf,0xbad8,
    0x4c77,0x20bb,0xf5b3,0xfd02,0x18b7,0x3e5a,0x890f,0x84d0,
    0xa3fa,0xc444,0x9f36,0xe02e,0x4e70,0xc951,0xf13f,0x7bea,
    0xdefc,0x647e,0x0e6d,0xa714,0xa3f3,0xb406,0x77a2,0xb725,
    0x9207,0x034f,0x94e7,0x5abd,0xe8b4,0xe576,0x9c46,0x4e42,
    0xf5df,0xdfc3,0xc680,0xd4d5,0x8e90,0x7123,0x1569,0x5b4f,
    0xc8e8,0x0c3f,0x48f3,0x504d,0x03c8,0xda9b,0xbb2a,0xb03f,
    0x62c4,0x066e,0x88b2,0x05d5,0x294d,0x7f9e,0xfa83,0xafd5,
    0xde40,0xe0be,0x66f9,0xb991,0x693d,0x7b30,0x0376,0xa964,
    0x7d70,0x465e,0x3520,0xebda,0x31ad,0xecb4,0x2686,0xdae9,
    0xac17,0x9c32,0x9130,0x6e08,0xd7a9,0x780d,0x1568,0x1792,
    0x444d,0xdd86,0xf7b9,0x8315,0x2678,0x9ae3,0xfafa,0x392f,
    0xf95b,0x9833,0x1ee2,0x9be5,0x1f23,0x27ae,0x9e74,0x64f4,
    0x0ce9,0xc452,0x6ec1,0xa54c,0xac38,0xadbd,0x05dc,0xa5f1,
    0xb25b,0xad01,0x2aed,0xd3df,0x4dcb,0xa5a7,0x4bbf,0x05b7,
    0xc477,0xed46,0x2150,0xc427,0x01bd,0x0059,0x9c1d,0xa457
};
uint16 crc16(const unsigned char *content, int length)
{
    uint16 index = 0;
    uint16 crcIndex = 0;
    uint16 tableEntry = 0;
    for (index = 0x0; index < length; index++)
    {
        tableEntry = crc_table[(crcIndex & 0xF) | (content[index] & 0xF) << 0x4];
        crcIndex = crcIndex >> 0x4 ^ tableEntry;
        tableEntry = crc_table[(crcIndex & 0xF) | (content[index] & 0xF0)];
        crcIndex = crcIndex >> 0x4 ^ tableEntry;
    }
    return crcIndex;
}

#define SEM_TIMED_FLAG true

int gMSec = 1000;

typedef bool (*ptr_verify_tf_record)(unsigned char*);
void tfe_set_verify_tf_record_funptr(ptr_verify_tf_record ptr);

string tf_file_name(int i) {
    char name[256] = {0};
    ts_get_tf_filepath(i, name, 256);
    return string(name);
}

static char checkpoint_filename[256] = {0};
char *checkpoint_file_name() {
    sprintf(checkpoint_filename, "%s/tfe.checkpoint", TFE_DATA_SUBDIR);
    return checkpoint_filename;
}


#define PRINT_SYSTEM_ERROR(n) printf("system API %s failed, reason is: %s\n", n, strerror(errno))
#define CHECK_SYSTEM_FAILURE(n) do { if(-1 == ret) { PRINT_SYSTEM_ERROR(n); goto TFE_ERROR; } } while(0)
#define CHECK_SYSTEM_FAILURE_EXPR(n, e) do { if(e) { PRINT_SYSTEM_ERROR(n); goto TFE_ERROR; } } while(0)

#define PRINT_ERROR(n) printf("func %s failed\n", n)
#define CHECK_FAILURE(n) do { if(-1 == ret) { PRINT_ERROR(n); goto TFE_ERROR; } } while(0)
#define CHECK_FAILURE_EXPR(n, e) do { if(e) { PRINT_ERROR(n); goto TFE_ERROR; } } while(0)


void md5(unsigned char* data, int datalen, unsigned char md[16]) {
    MD5Buffer((char*)data, datalen, md);
}

bool bytes_equal(unsigned char* p1, unsigned char* p2, int cnt) {
    for(int i=0; i<cnt; ++i) { if(p1[i] != p2[i]) return false; } return true; }

struct ErrorHelper {
    void clear_error() { m_errored = false; }
	void set_error() { m_errored = true; }
	bool errored() { return m_errored; }
	bool m_errored;
};

struct File : public ErrorHelper {
    File(const string name, const string flag = "r")
	    : m_fh(NULL) {
        m_fh = fopen(name.c_str(), flag.c_str());
		CHECK_SYSTEM_FAILURE_EXPR("fopen", NULL == m_fh);
    TFE_ERROR: return;
    }
    virtual ~File() { if(opened()) fclose(m_fh); }
    static bool exist(const string name){
        FILE* fh = fopen(name.c_str(), "r");
        if(fh) { fclose(fh); return true; }
        return false;
    }
    bool opened() { return m_fh != NULL; }
    long size() {
        int ret; long len; clear_error();
        CHECK_FAILURE_EXPR("size", false == opened());
        ret = fseek(m_fh, 0, SEEK_END); CHECK_SYSTEM_FAILURE("fseek");
        len = ftell(m_fh); CHECK_SYSTEM_FAILURE_EXPR("ftell", -1 == len);
        return len;
    TFE_ERROR: set_error(); return -1;
    }
    int write(unsigned char* data, int len) {
        int left = len; int cnt; clear_error();
        CHECK_FAILURE_EXPR("write", false == opened());
        while(left > 0) {
            cnt = fwrite(data+(len-left), 1, left, m_fh);
            if(0 == cnt) { PRINT_SYSTEM_ERROR("fwrite"); break; }
            left -= cnt;
        }
        return len - left;
    TFE_ERROR: set_error(); return -1;
    }
    int read(unsigned char* data, int len) {
        int left = len; int cnt; clear_error();
        CHECK_FAILURE_EXPR("read", false == opened());
        while(left > 0) {
            cnt = fread(data+(len-left), 1, left, m_fh);
            if(0 == cnt) { PRINT_SYSTEM_ERROR("fread"); break; }
            left -= cnt;
        }
        return len - left;
    TFE_ERROR: set_error(); return -1;
    }
    int seek(long offset) {
        int ret; clear_error();
        CHECK_FAILURE_EXPR("read", false == opened());
        ret = fseek(m_fh, offset, SEEK_SET); CHECK_SYSTEM_FAILURE("fseek");
        return ret;
    TFE_ERROR: set_error(); return -1;
    }
    void flush() { if(opened()) fflush(m_fh); }
    int read_record(unsigned char* data, int len, bool allow_zero_head = true) {
        int ret1; int ret2; clear_error();
        CHECK_FAILURE_EXPR("read_record @1", false == opened());
	    ret1 = read(data, 2); CHECK_FAILURE_EXPR("read_record @2", ret1 != 2);
	    if(allow_zero_head && 0 == *(uint16*)data) return 2;
	    CHECK_FAILURE_EXPR("read_record @3", *(uint16*)data <= 2);
	    CHECK_FAILURE_EXPR("read_record @4", len < *(uint16*)data);
	    ret2 = read(data+2, *(uint16*)data - 2); CHECK_FAILURE_EXPR("read_record @3", ret2 != *(uint16*)data-2);
	    return ret1 + ret2; //004
    TFE_ERROR: set_error(); return -1;
    }
    static void truncate_by_align(const char* name, int align) {
        if(File::exist(name) == false) return;
        long n; { File file(name); n = file.size(); }
        if(n % align) { n -= n % align; truncate(name, n); }
    }
    FILE* m_fh;
};

union unionsem
{
    int value;
    uint16 array;
    struct semid_ds * dsbuf;
};

struct Semphore {
    Semphore():m_key(0), m_sem_cnt(0) {}
    Semphore(key_t key, int sem_cnt) { init(key, sem_cnt); }
    int init(key_t key, int sem_cnt) {
        m_key = key; m_sem_cnt = sem_cnt;
        int ret = m_sem_id = semget(key, sem_cnt, 0666);
        CHECK_SYSTEM_FAILURE("semget");
        return 0; TFE_ERROR: return -1;
    }
    static int create(key_t key, int sem_cnt, int value = 0) {
        int ret, sem_id; union unionsem param; param.value = value;
        ret = sem_id = semget(key, sem_cnt, 0666 | IPC_CREAT | IPC_EXCL); CHECK_SYSTEM_FAILURE("semget");
        for (int i = 0; i < sem_cnt; i++) {
            ret = semctl(sem_id, i, SETVAL, param); CHECK_SYSTEM_FAILURE("semctl");
        }
		return 0; TFE_ERROR: return -1;
    }
    static int destroy(key_t key, int sem_cnt){
        int ret, sem_id;
        ret = sem_id = semget(key, sem_cnt, 0666); CHECK_SYSTEM_FAILURE("semget");
        ret = semctl(sem_id, 0, IPC_RMID); CHECK_SYSTEM_FAILURE("semctl");
    return 0; TFE_ERROR: return -1;
    }
    int PorV(int i, int pv) {
        int ret; struct sembuf sem[1];
        sem[0].sem_op = pv; sem[0].sem_flg = 0; sem[0].sem_num = i;
        struct timespec timeout; timeout.tv_sec = gMSec/1000; timeout.tv_nsec = ((uint64)gMSec % 1000) * 1000 * 1000;
        //struct timespec timeout; timeout.tv_sec = 1; timeout.tv_nsec = 0;
        while(true) {
            if(!SEM_TIMED_FLAG)
                ret = semop(m_sem_id, sem, 1);
            else
                ret = semtimedop(m_sem_id, sem, 1, &timeout);
            if(-1 == ret && EINTR == errno) continue;
			if(-1 == ret && EAGAIN == errno) return TFE_TIMEOUT;
			if(-1 == ret && ERANGE == errno) return 0;
            break;
        }
        CHECK_SYSTEM_FAILURE("semtimedopORsemop");
        return 0; TFE_ERROR: return -1;
    }
    int value(int i) { return semctl(m_sem_id, i, GETVAL, 0); }
    int wait(int i) { return PorV(i, -1); }
    int post(int i) { return PorV(i, +1); }
    key_t m_key; int m_sem_id; int m_sem_cnt;
};

struct MemoryMap {
    static int flush(void* p, int len) {
        int ret = msync(p, len, MS_SYNC); CHECK_SYSTEM_FAILURE("msync");
        return 0; TFE_ERROR: return -1;
    }
	static void* map(int fd, int begin, int len) {
        void* ret; //int ret1;
        ret = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_SHARED, fd, begin);
        CHECK_SYSTEM_FAILURE_EXPR("mmap",  (void *)-1 == ret);
        // ret1 = madvise(ret, len, MADV_WILLNEED);
        // CHECK_SYSTEM_FAILURE_EXPR("madvise", -1 == ret1);
        return ret; TFE_ERROR: return (void *)-1;
    }
    static int unmap(void* p, int len) {
        int ret = munmap(p, len);
        CHECK_SYSTEM_FAILURE("munmap");
        return 0; TFE_ERROR: return -1;
    }
};

struct SharedMemory{
    SharedMemory(key_t key, int len)
        : m_key(key), m_len(len) {
        int ret, shmid;
        ret = shmid = shmget(key, len, 0666); CHECK_SYSTEM_FAILURE("shmget");
        m_p = (char *)shmat(shmid, 0, 0); CHECK_SYSTEM_FAILURE_EXPR("shmat", m_p == (char*)-1);
    TFE_ERROR: return;
    }
    static int create(key_t key, int len, unsigned char* shm_input) {
        int ret, shmid; char* p;
        ret = shmid = shmget(key, len, IPC_CREAT|IPC_EXCL|0666); CHECK_SYSTEM_FAILURE("shmget");
        p = (char *)shmat(shmid, 0, 0); CHECK_SYSTEM_FAILURE_EXPR("shmat", p == (char*)-1);
        memcpy(p, shm_input, len);
        shmdt(p);
        return 0; TFE_ERROR: return -1;
    }
    static int destroy(key_t key, int len) {
        int ret, shmid;
        ret = shmid = shmget(key, len, 0666); CHECK_SYSTEM_FAILURE("shmget");
        shmctl(shmid, IPC_RMID, NULL);
		return 0; TFE_ERROR: return -1;
    }
    key_t m_key; int m_len; char* m_p;
};

template<class T> struct Lock {
    Lock(T& t, int i):m_t(t),m_i(i) {
	    // int ret;
		// while( 0 != (ret = t.wait(i))) {
		//     if(TFE_TIMEOUT == ret) { printf("L-."); fflush(NULL); }
		// }
	}
	~Lock() {
	    // int ret;
		// while( 0 != (ret = m_t.post(m_i))) {
		//     if(TFE_TIMEOUT == ret) { printf("L+."); fflush(NULL); }
		// }
	}
	T& m_t; int m_i;
};


//007
#pragma pack(push)
#pragma pack(1)
struct ShmData{
  uint64 m_offsets[TFE_TASK_CNT];
  uint64 m_pre_offsets[TFE_TASK_CNT];
  uint64 m_counts[TFE_TASK_CNT];
  time_type m_last_checkpoint_time; //最后一次checkpoint时间
  uint64 m_checkpoint_seq; //最后一次checkpoint offset
};
#pragma pack(pop)

struct Manager {
    static const int task_cnt = TFE_TASK_CNT;
    static const int shm_size = sizeof(ShmData); //007
    Manager()
	    : m_shm(TFE_SHM_KEY, shm_size), m_sems(TFE_SEM_KEY, TFE_TASK_CNT), m_sems1(TFE_SEM_KEY2, TFE_TASK_CNT) {
      ShmData* data = (ShmData*)m_shm.m_p; //007
      m_offsets = data->m_offsets;
      m_pre_offsets = data->m_pre_offsets;
      m_counts = data->m_counts;
	}
    static int create(unsigned char* shm_input) {
	    int ret = SharedMemory::create(TFE_SHM_KEY, shm_size, shm_input); CHECK_FAILURE("create");
		ret = Semphore::create(TFE_SEM_KEY, TFE_TASK_CNT, 0); CHECK_FAILURE("create");
		ret = Semphore::create(TFE_SEM_KEY2, TFE_TASK_CNT, 1); CHECK_FAILURE("create");
		return 0; TFE_ERROR: return -1;
    }
    static int destroy() {
        int ret = SharedMemory::destroy(TFE_SHM_KEY, shm_size); CHECK_FAILURE("destroy");
        ret = Semphore::destroy(TFE_SEM_KEY, TFE_TASK_CNT); CHECK_FAILURE("destroy");
        ret = Semphore::destroy(TFE_SEM_KEY2, TFE_TASK_CNT); CHECK_FAILURE("destroy");
        return 0; TFE_ERROR: return -1;
    }
    uint64 get_offset(int i) {
        //Lock<Semphore> l(m_sems1, i);
        return m_offsets[i];
    }
    uint64 get_pre_offset(int i) {
	    //Lock<Semphore> l(m_sems1, i);
		return m_pre_offsets[i];
	}
    time_type get_last_checkpoint_time() {
        ShmData* data = (ShmData*)m_shm.m_p; //007
		return data->m_last_checkpoint_time;
    }
    void set_last_checkpoint_time(time_type t) {
        ShmData* data = (ShmData*)m_shm.m_p; //007
		data->m_last_checkpoint_time = t;
    }
	uint64 get_checkpoint_seq() {
        ShmData* data = (ShmData*)m_shm.m_p; //007
		return data->m_checkpoint_seq;
    }
    void set_checkpoint_seq(uint64 seq) {
        ShmData* data = (ShmData*)m_shm.m_p; //007
		data->m_checkpoint_seq = seq;
    }
    void set_offset(int i, uint64 v) {
        //Lock<Semphore> l(m_sems1, i);
        m_offsets[i] = v;
    }
    void set_pre_offset(int i, uint64 v) {
        //Lock<Semphore> l(m_sems1, i);
    	m_pre_offsets[i] = v;
    }
    void advance_offset(int i, int len) {
        //Lock<Semphore> l(m_sems1, i);
        m_offsets[i] += len;
    }
    bool offset_equal(int l, int r) {
        return get_offset(l) == get_offset(r);
	}
    uint64 get_count(int i) {
	    //Lock<Semphore> l(m_sems1, i);
		return m_counts[i];
	}
	void set_count(int i, uint64 v) {
	    //Lock<Semphore> l(m_sems1, i);
		m_counts[i] = v;
	}
	void advance_count(int i, int len) {
	    //Lock<Semphore> l(m_sems1, i);
		m_counts[i] += len;
	}
    int wait_target(int id, int target) {
	    //while(get_offset(id) == get_offset(target)) {
		/*
		while(get_offset(id) >= get_offset(target)) {
		    int ret; if((ret = m_sems.wait(id)) > 0) return ret;
		}
		*/
		if (get_offset(id) >= get_offset(target)) {
            m_sems.wait(id);
            if (get_offset(id) >= get_offset(target)) return TFE_TIMEOUT;
        }
		return 0;
	}
	int wait_target_provisional(int id, int target, uint64 offset) {
	    //while(offset == get_offset(target)) {
		/*
		while(offset >= get_offset(target)) {
		    int ret; if((ret = m_sems.wait(id)) > 0) return ret;
		}
		*/
		if (offset >= get_offset(target)) {
            m_sems.wait(id);
            if (offset >= get_offset(target)) return TFE_TIMEOUT;
        }
		return 0;
	}
	void notify_follower(uint64 ori_offset, int follower) {
        if(ori_offset == get_offset(follower) || ori_offset == get_pre_offset(follower)) { // 009
		    while(0 !=  m_sems.post(follower)) {
                //printf("n"); fflush(NULL);
            }
		}
	}
	int sem_value(int i) { return m_sems.value(i); }
	int sem1_value(int i) { return m_sems1.value(i); }
	uint64* m_offsets;
	uint64* m_pre_offsets;
	uint64* m_counts;
	SharedMemory m_shm;
	Semphore m_sems;
	Semphore m_sems1;
};

uint64 align_prev(uint64 current, int step){
    uint64 offset = current%step;
    return (0 == offset) ? current : (current - offset);
}
uint64 align_next(uint64 current, int step){
    uint64 offset = current%step;
    return (0 == offset) ? current : (current - offset + step);
}
int open_file(const char* name) {
    int ret;
	while(true) {
	    if(File::exist(name)) {
		    File file(name);
			if(file.opened() && file.size() == TFE_FILE_SIZE) break;
		}
		printf("crap! waiting for file %s creating\n", name); sleep(1);
	}
    ret = open(name, O_RDWR, S_IRWXU); CHECK_SYSTEM_FAILURE("open");
	return ret; TFE_ERROR: return -1;
}
void close_file(int fd) { close(fd); }

#pragma pack(push)
#pragma pack(1)
struct Head {
    uint16 len;
    uint16 crc;
    int timestamp;
    unsigned char invalid; //009
};
#pragma pack(pop)

struct Task{
    Task(int id, int target, vector<int> followers, bool advance_read = false)
        : m_id(id), m_target(target), m_followers(followers),
		m_provisional(advance_read), m_provisional_offset(0), m_provisional_count(0) { //006
        mgr.m_pre_offsets[id] = 0; //002
        m_fi = mgr.get_offset(id)/TFE_FILE_SIZE;
        m_fd = open_file(tf_file_name(m_fi).c_str()); if(-1 == m_fd) return;
        m_ptr = (char*)MemoryMap::map(m_fd, 0, TFE_FILE_SIZE); if((void*)-1 == m_ptr) return;
		if(0 == m_id) { m_adder_mapped_ptrs.push_back(m_ptr); m_adder_mapped_fds.push_back(m_fd); }
        m_ptr += (mgr.get_offset(id) - (uint64)m_fi * TFE_FILE_SIZE);
        if(advance_read) {
            m_provisional_offset = mgr.get_offset(id);
            mgr.m_pre_offsets[id] = m_provisional_offset; //002
		}
    }
    int write(const unsigned char* buf, int buflen) {
        //001
        Head* h = (Head*)buf; h->len = buflen;
        time_t t; time(&t); h->timestamp = (int)t; h->crc = crc16(buf+sizeof(Head), buflen-sizeof(Head));
        h->invalid = 0; //009

        int ret = 0;
        uint64 ori_offset = offset();
        int space;
        if((space = space_in_file()) < buflen) { advance(space); ret = advance_file();  if(-1 == ret) return -1; return TFE_TIMEOUT; }
        memcpy(m_ptr, buf, buflen); advance(buflen);
        notify_followers(ori_offset);
        mgr.advance_count(m_id, 1);
        return ret;
    }
    int flush() {
        while(wait_target()) {}
        uint64 ori_offset = offset();
        uint64 dst_offset = mgr.get_offset(0);
        bool cross = (ori_offset/TFE_FILE_SIZE != dst_offset/TFE_FILE_SIZE);
        if(cross) dst_offset = (uint64)m_fi*TFE_FILE_SIZE + TFE_FILE_SIZE;
        MemoryMap::flush(m_ptr - (ori_offset%4096), align_next(dst_offset, 4096) - align_prev(ori_offset, 4096));
        advance(dst_offset - ori_offset);
        notify_followers(ori_offset);
        if(cross) { int ret = advance_file(); if(-1 == ret) return -1; }
        return 0;
    }
    int read(unsigned char* buf, int buflen, int msec = 200) {
        ts_notused(buflen);
	*(int*)buf = 0;
        int ret = 0; int space;
		gMSec = msec;
        if(m_provisional) {
            ret = wait_target_provisional(); if(ret) return ret;
            if((space = space_in_file(m_provisional_offset)) <= 2 || 0 == *(uint16*)m_ptr) {
	      advance_provisional(space); ret = advance_file(); if(-1 == ret) return -1; return TFE_TIMEOUT;
            }
            memcpy(buf, m_ptr, *(uint16*)m_ptr); advance_provisional(*(uint16*)m_ptr);
        } else {
            ret = wait_target(); if(ret) return ret;
            uint64 ori_offset = offset();
            if((space = space_in_file()) <= 2 || 0 == *(uint16*)m_ptr) {
                advance(space); ret = advance_file(); if(-1 == ret) return -1; return TFE_TIMEOUT;
            }
            memcpy(buf, m_ptr, *(uint16*)m_ptr); advance(*(uint16*)m_ptr);
            notify_followers(ori_offset);
        }

        //001
        Head* h = (Head*)buf;
        if(h->crc != crc16(&buf[0]+sizeof(Head), h->len - sizeof(Head))) return TFE_CRC_FAILED;

        //mgr.advance_count(m_id, 1); //006
        if(m_provisional)
            m_provisional_count++;
        else
            mgr.advance_count(m_id, 1);

	    return ret;
    }
    int commit() {
        int ret = 0;
        uint64 ori_offset = offset();
        advance_offset_only(m_provisional_offset - ori_offset); //003
        notify_followers(ori_offset);
        mgr.advance_count(m_id, m_provisional_count); m_provisional_count = 0; //006
        return ret;
    }
    int rollback() {
        int fi = offset()/TFE_FILE_SIZE;
        if(fi == m_fi) {
            advance_provisional(offset() - m_provisional_offset);
        } else {
            MemoryMap::unmap(m_ptr - offset_in_file(m_provisional_offset), TFE_FILE_SIZE);
            close_file(m_fd);
            m_fd = open_file(tf_file_name(fi).c_str()); if(-1 == m_fd) return -1;
            m_ptr = (char*)MemoryMap::map(m_fd, 0, TFE_FILE_SIZE); if((void*)-1 == m_ptr) return -1;
            m_fi = fi;
            m_ptr += offset_in_file(offset());
            m_provisional_offset = offset();
            mgr.m_pre_offsets[m_id] = m_provisional_offset; //002
        }
        return 0;
    }
    static int find(unsigned char* buf, int buflen, int fi, int offset) {
        File file(tf_file_name(fi)); if(false == file.opened()) return -1;
        file.seek(offset); if(file.errored()) return -1;
        file.read_record(buf, buflen); if(file.errored()) return -1;

        //001
        Head* h = (Head*)buf;
        if(h->crc != crc16(&buf[0]+sizeof(Head), h->len - sizeof(Head))) return TFE_CRC_FAILED;
        return 0;
    }
  //009
    static int invalid(int fi, int offset)
    {
	    File file(tf_file_name(fi), "r+");
		if(false == file.opened()) return -1;
		file.seek(offset+offsetof(Head, invalid));
		if(file.errored()) return -1;
		unsigned char data[1] = {0x01};
		file.write(data, sizeof(data));
		if(file.errored()) return -1;
		return 0;
	}

    static uint64 find_end(uint64 start_offset, ptr_verify_tf_record ptr_fun, uint64& count) {
        int fi = start_offset / TFE_FILE_SIZE;
        uint64 curr_offset = start_offset;
        int offset_in_file = start_offset % TFE_FILE_SIZE;
        int file_space = TFE_FILE_SIZE - offset_in_file;
        bool found = false;
        while(true)
        {
            File file(tf_file_name(fi));
			if(false == file.opened())
            {
                printf("file.opened() failure. start_offset[%lld] fi[%d] curr_offset[%lld] offset_in_file[%d]. reason is: %s\n",
                    start_offset, fi, curr_offset, offset_in_file, strerror(errno));
                return -1;
            }
            file.seek(offset_in_file);
            if(file.errored())
            {
                printf("file.seek() failure. fi[%d] curr_offset[%lld] offset_in_file[%d]. reason is: %s\n",
                    fi, curr_offset, offset_in_file, strerror(errno));
                return -1;
            }
            while(file_space > 2)
            {
                unsigned char buf[64*1024]; *(uint16*)&buf[0] = 0x0000;
                file.read_record(buf, sizeof(buf));
                if(file.errored())
                {
                    printf("file.read_record() failure. fi[%d] curr_offset[%lld] offset_in_file[%d]. reason is: %s\n",
                        fi, curr_offset, offset_in_file, strerror(errno));
                    return -1;
                }
                int recordlen = *(uint16*)&buf[0];
                if(0 == recordlen && file_space == TFE_FILE_SIZE) { found = true; break; }
                if(0 == recordlen && file_space >= 64*1024) { found = true; break; }
                if(0 == recordlen) break;
                if(false == ptr_fun(buf)) { found = true; break; }
                count++;
                curr_offset += recordlen; file_space -= recordlen;
            }
            if(found) return curr_offset;
            curr_offset += file_space; fi++; offset_in_file = 0; file_space = TFE_FILE_SIZE;
        }
        return curr_offset;
    }
    void advance(int len) { mgr.advance_offset(m_id, len); m_ptr += len; }
    void advance_provisional(int len) {
        m_provisional_offset += len; m_ptr += len;
		mgr.m_pre_offsets[m_id] = m_provisional_offset; //002
    }
    void advance_offset_only(int len) { mgr.advance_offset(m_id, len); } //003
    uint64 offset() { return mgr.get_offset(m_id); }
    void offset(uint64 v) { mgr.set_offset(m_id, v); }

    uint64 count() { return mgr.get_count(m_id); } // 004
    void count(uint64 v) { mgr.set_count(m_id, v); } // 004

    int offset_in_file(uint64 offset) { return offset - (uint64)m_fi*TFE_FILE_SIZE; } //005
    int space_in_file() { return space_in_file(offset()); }
    int space_in_file(uint64 offset) { return TFE_FILE_SIZE - offset_in_file(offset); }

    int wait_target() { return mgr.wait_target(m_id, m_target); }
    int wait_target_provisional() { return mgr.wait_target_provisional(m_id, m_target, m_provisional_offset); }
    void notify_followers(uint64 ori_offset) {
        for(unsigned int i=0; i<m_followers.size(); ++i)
	        mgr.notify_follower(ori_offset, m_followers[i]);
	}
    int advance_file() {
        if(0 == m_id) {
            while(m_adder_mapped_ptrs.size() > 5) {
		        MemoryMap::unmap(m_adder_mapped_ptrs.front(), TFE_FILE_SIZE); close_file(m_adder_mapped_fds.front());
			    m_adder_mapped_ptrs.pop_front(); m_adder_mapped_fds.pop_front();
		    }
	    } else {
	        MemoryMap::unmap(m_ptr - TFE_FILE_SIZE, TFE_FILE_SIZE);
		    close_file(m_fd);
        }
		m_fd = open_file(tf_file_name(++m_fi).c_str()); if(-1 == m_fd) return -1;
		m_ptr = (char*)MemoryMap::map(m_fd, 0, TFE_FILE_SIZE); if((void *)-1 == m_ptr) return -1;
		if(0 == m_id) {
		    m_adder_mapped_ptrs.push_back(m_ptr);
			m_adder_mapped_fds.push_back(m_fd);
		}
		return 0;
    }

	int m_id; int m_target; vector<int> m_followers;
    bool m_provisional; uint64 m_provisional_offset; int m_provisional_count; //006
	int m_fd; int m_fi; char* m_ptr;
	Manager mgr;

	list<char*> m_adder_mapped_ptrs;
	list<int> m_adder_mapped_fds;
};

struct CheckPointFile : public File{
    static const int record_size = 512;
    static const int md5_size = 16;
    static const int data_offset = 2;
    CheckPointFile(const string name, const string flag = "r") : File(name, flag) {
    }
    virtual ~CheckPointFile() {}
    bool read_record(long n, unsigned char* buf) {
	    unsigned char* p = &buf[0];
		if(-1 == seek(n)) return false;
		if(record_size != read(buf, record_size)) return false;
		unsigned char* data = p + 2; int datalen = *(uint16*)p - 2 - md5_size;
        unsigned char md[md5_size];
        md5(data, datalen, md);
        return bytes_equal(md, data + datalen, md5_size) ? true : false;
    }
    bool read_last_record(unsigned char* buf, int buflen) {
        if(buflen < record_size) {
            printf("input error: @read_last_record buflen=%d\n", buflen);
            return false;
        }
        long n = size();
        n -= n % record_size;
        n -= record_size;
        while(n >= 0) {
            if(read_record(n, buf))
                return true;
            n -= record_size;
        }
        return false;
    }
    bool append_record(unsigned char* data, int datalen) {
        unsigned char buf[record_size]; memset(buf, 0, sizeof(buf));
        *(uint16*)&buf[0] = 2 + datalen + md5_size;
        memcpy(&buf[2], data, datalen);
        md5(data, datalen, &buf[2+datalen]);
        if(sizeof(buf) != write(buf, sizeof(buf))) return false;
        flush();
        return true;
    }
};

void split_string(const char* followers, char sep, vector<int>& v)
{
    if(NULL == followers || 0 == strlen(followers)) return;
    char buf[256] = {0, }; strcpy(buf, followers); int last = 0;
    for(unsigned int i=0; i<strlen(buf); ++i){
        if(buf[i] == sep) { buf[i] = 0x00; v.push_back(atoi(&(buf[last]))); last = i + 1; }
    }
    v.push_back(atoi(&(buf[last])));
}


Manager* gMgr = NULL;
int tfe_init()
{
    static Manager mgr;
    gMgr = &mgr;
    return 0;
}

void tfe_set_offset(int task_id, uint64 offset)
{
    return gMgr->set_offset(task_id, offset);
}

uint64 tfe_get_offset(int task_id, uint32 *fileIdx, uint32 *offset)
{
    if ((fileIdx==NULL) || (offset==NULL))
        return gMgr->get_offset(task_id);

    uint64 fo = gMgr->get_offset(task_id);
    if (fileIdx!=NULL)
        *fileIdx = (unsigned int)(fo / TFE_FILE_SIZE);
    if (offset!=NULL)
        *offset = (unsigned int)(fo % TFE_FILE_SIZE);
    return gMgr->get_offset(task_id);
}
uint64 tfe_get_pre_offset(int task_id, uint32 *fileIdx, uint32 *offset)
{
    if ((fileIdx==NULL) || (offset==NULL))
        return gMgr->get_pre_offset(task_id);

    uint64 fo = gMgr->get_pre_offset(task_id);
    if (fileIdx!=NULL)
        *fileIdx = (unsigned int)(fo / TFE_FILE_SIZE);
    if (offset!=NULL)
        *offset = (unsigned int)(fo % TFE_FILE_SIZE);
    return gMgr->get_pre_offset(task_id);
}

uint64 tfe_get_count(int task_id)
{
    return gMgr->get_count(task_id);
}

time_type tfe_get_last_checkpoint_time()
{
    return gMgr->get_last_checkpoint_time();
}

uint64 tfe_get_checkpoint_seq()
{
    return gMgr->get_checkpoint_seq();
}

//adder任务的记录数在重启tfe后可能不正确，此函数用reply的记录数去更新adder的记录数
void tfe_reinit_adder_count()
{
    return gMgr->set_count(TFE_TASK_ADDER, gMgr->get_count(TFE_TASK_REPLY));
}


void tfe_dump_offset()
{
    log_debug(" [ Adder ]----------------- offset[%lld] count[%lld]",
        gMgr->get_offset(TFE_TASK_ADDER), gMgr->get_count(TFE_TASK_ADDER));
    log_debug(" [ Flush ]----------------- offset[%lld] count[%lld]",
        gMgr->get_offset(TFE_TASK_FLUSH), gMgr->get_count(TFE_TASK_FLUSH));
    log_debug(" [ Reply ]----------------- offset[%lld] count[%lld]",
        gMgr->get_offset(TFE_TASK_REPLY), gMgr->get_count(TFE_TASK_REPLY));
    log_debug(" [ Update ]----------------- offset[%lld] count[%lld]",
        gMgr->get_offset(TFE_TASK_UPDATE), gMgr->get_count(TFE_TASK_UPDATE));
    log_debug(" [ Scan ]----------------- offset[%lld] count[%lld]",
        gMgr->get_offset(TFE_TASK_SCAN), gMgr->get_count(TFE_TASK_SCAN));
    log_debug(" [ Update_DB ]----------------- offset[%lld] count[%lld]",
        gMgr->get_offset(TFE_TASK_UPDATE_DB), gMgr->get_count(TFE_TASK_UPDATE_DB));
    //log_debug(" [ Update_DB2 ]----------------- offset[%lld] count[%lld]",
        //gMgr->get_offset(TFE_TASK_UPDATE_DB2), gMgr->get_count(TFE_TASK_UPDATE_DB2));
    //log_debug(" [ Remote_sync ]----------------- offset[%lld] count[%lld]",
    //    gMgr->get_offset(TFE_TASK_REMOTE_SYNC), gMgr->get_count(TFE_TASK_REMOTE_SYNC));
    return;
}


Task* gTask = NULL;
#define RECORD_CNT 2

int tfe_t_init(int taskid, int target, const char* followers, int using_advanced_read)
{
    if(gTask) return 0;
    vector<int> vfollowers; split_string(followers, ' ', vfollowers);
    static Task t(taskid, target, vfollowers, using_advanced_read); gTask = &t;

    gMgr = &(t.mgr);
    return 0;
}

int tfe_t_write(const unsigned char* buf, int buflen)
{
    return gTask->write(buf, buflen);
}

int tfe_t_flush()
{
    return gTask->flush();
}

int tfe_t_read(unsigned char* buf, int buflen, int msec)
{
    while(1)
    {
        int ret = gTask->read(buf, buflen, msec);
        Head * head = (Head *)buf;
        if (1==head->invalid)
            continue;
        return ret;
    }
}

uint64 tfe_t_file_offset(uint32 *fileIdx, uint32 *offset)
{
    if ((fileIdx==NULL) || (offset==NULL))
        return gTask->offset();

    uint64 fo = gTask->offset();
    if (fileIdx!=NULL)
        *fileIdx = (uint32)(fo / TFE_FILE_SIZE);
    if (offset!=NULL)
        *offset = (uint32)(fo % TFE_FILE_SIZE);
    return gTask->offset();
}

uint64 tfe_t_pre_file_offset(uint32 *fileIdx, uint32 *offset)
{
    if ((fileIdx==NULL) || (offset==NULL))
        return gTask->m_provisional_offset;

    uint64 fo = gTask->m_provisional_offset;
    if (fileIdx!=NULL)
        *fileIdx = (uint32)(fo / TFE_FILE_SIZE);
    if (offset!=NULL)
        *offset = (uint32)(fo % TFE_FILE_SIZE);
    return gTask->m_provisional_offset;
}

int tfe_t_commit()
{
    return gTask->commit();
}

int tfe_t_rollback()
{
    return gTask->rollback();
}

#pragma pack(push)
#pragma pack(1)
struct DataSaverHead{
    uint64 seq;
    uint64 offset;
    uint64 count; //004
    uint16 crc;
};
#pragma pack(pop)

int tfe_t_keep_footmark(const char* name, int id) //007
{
    if(false == File::exist(name)) { File file(name, "w"); }
	File::truncate_by_align(name, sizeof(DataSaverHead));

	uint64 minseq = std::numeric_limits<uint64>::max(); int minseqidx = 0;
	uint64 maxseq = -1; int maxseqidx = 0;
	int location = 0;

	File file(name, "r+"); int len = file.size();
	unsigned char buf[512];
	if((unsigned int)len > sizeof(buf)) return -1;
	DataSaverHead* head = (DataSaverHead*)buf;
	int cnt = len/sizeof(DataSaverHead);
	file.seek(0);
	if(len != file.read(buf, len)) return -1;
	int crcfailed = -1;
	for(int i=0; i<cnt; ++i) {
	    if(head[i].crc != crc16((unsigned char*)&head[i], sizeof(DataSaverHead) - 2)) {
		    printf("crc16 failed\n"); crcfailed = i; continue;
		}
		if(head[i].seq > maxseq) { maxseq = head[i].seq; maxseqidx = i; }
		if(head[i].seq < minseq) { minseq = head[i].seq; minseqidx = i; }
	}
	if(-1 != crcfailed) {
	    location = sizeof(DataSaverHead) * crcfailed;
	} else {
	    if(cnt < RECORD_CNT) location = sizeof(DataSaverHead) * cnt;
		if(cnt == RECORD_CNT) location = sizeof(DataSaverHead) * minseqidx;
	}

	DataSaverHead record;
	record.seq = ++maxseq;
	record.offset = gMgr->get_offset(id); //007
	record.count = gMgr->get_count(id);  //007
	record.crc = crc16((unsigned char*)&record, sizeof(DataSaverHead) - 2);
	file.seek(location);
	file.write((unsigned char*)&record, sizeof(record));

	//log_debug(" tfe_t_keep_footmark()  task[%d] time[%d]", id, get_now());
	return 0;
}

int tfe_t_restore_footmark(const char* name, int id)//007
{
    log_debug(" restore_footmark()  begin ---> [%d] offset[%lld] pre_offset[%lld] count[%lld]",
        get_now(), gMgr->get_offset(id), gMgr->get_pre_offset(id), gMgr->get_count(id));

    if(false == File::exist(name)) { File file(name, "w"); }
	File::truncate_by_align(name, sizeof(DataSaverHead));

	uint64 minseq = std::numeric_limits<uint64>::max(); int minseqidx = 0;
	uint64 maxseq = -1; int maxseqidx = 0;

    File file(name); int len = file.size();
	unsigned char buf[512];
	if((uint32)len > sizeof(buf)) return -1;
	DataSaverHead* head = (DataSaverHead*)buf;
	int cnt = len/sizeof(DataSaverHead);
	file.seek(0);
	if(len != file.read(buf, len)) return -1;
	bool found_valid_record = false;
	for(int i=0; i<cnt; ++i) {
	    if(head[i].crc != crc16((unsigned char*)&head[i], sizeof(DataSaverHead) - 2))
		    continue;
	    if(head[i].seq > maxseq) { maxseq = head[i].seq; maxseqidx = i; }
	    if(head[i].seq < minseq) { minseq = head[i].seq; minseqidx = i; }
	    found_valid_record = true;
	}
	if(found_valid_record) {
        gMgr->set_offset(id, head[maxseqidx].offset); //007
        gMgr->set_pre_offset(id, head[maxseqidx].offset); //008
        gMgr->set_count(id, head[maxseqidx].count); //007
	}
    log_debug(" restore_footmark()  end ---> [%d] offset[%lld] pre_offset[%lld] count[%lld]",
        get_now(), gMgr->get_offset(id), gMgr->get_pre_offset(id), gMgr->get_count(id));
    return 0;
}

int tfe_find(unsigned char* buf, int buflen, uint64 offset)
{
    return Task::find(buf, buflen, offset/TFE_FILE_SIZE, offset%TFE_FILE_SIZE);
}

bool verify_tf_record_func(unsigned char* buf)
{
    Head*h = (Head*)buf;
    return h->crc == crc16(buf+sizeof(Head), h->len - sizeof(Head));
}
ptr_verify_tf_record verify_tf_record = &verify_tf_record_func;
void tfe_set_verify_tf_record_funptr(ptr_verify_tf_record ptr)
{
    verify_tf_record = ptr;
}


int tfe_check_point_init()
{
    File::truncate_by_align(checkpoint_file_name(), CheckPointFile::record_size);
	static Manager mgr_chkp;
	gMgr = &mgr_chkp;
	return 0;
}

template<int Len>
void file_save_tail(const char* name)
{
    unsigned char buf[Len];
	{
	    File file(name); if(file.size() <= Len) return; file.seek(file.size() - Len); file.read(buf, Len);
	}
	File file(name, "w"); file.write(buf, Len);
}

int tfe_do_check_point(uint64 seq) //007
{
    gMgr->set_last_checkpoint_time(get_now());
    gMgr->set_checkpoint_seq(seq);

    unsigned char data[Manager::shm_size];
    memset(data, 0, sizeof(data)); //005
    ShmData* shm = (ShmData*)data;  //007
    shm->m_checkpoint_seq = gMgr->get_checkpoint_seq();
    shm->m_last_checkpoint_time = gMgr->get_last_checkpoint_time();
	for(int i=0; i<TFE_TASK_CNT; ++i) {
        shm->m_offsets[i] = gMgr->get_offset(i); shm->m_counts[i] = gMgr->get_count(i);  //007
    }
	{
	    CheckPointFile file(checkpoint_file_name(), "a");
		file.append_record(data, sizeof(data));
	}
	file_save_tail<CheckPointFile::record_size * 4>(checkpoint_file_name());
	return 0;
}


void *tfe_create_file(void *arg)
{
    ts_notused(arg);

    Manager mgr;
	uint64 offset = mgr.get_offset(0);
	int i = offset/TFE_FILE_SIZE; int j = i;
	while(1) {
	    if(File::exist(tf_file_name(j++))) continue; break;
	}
	j--;
	{
	    if(File::exist(tf_file_name(j))) {
		    File file(tf_file_name(j));
			if(TFE_FILE_SIZE == file.size()) j++;
		}
	}

	unsigned char zerodata[4096]; memset(zerodata, 0, sizeof(zerodata));
	while(1) {
	    if(j - i < 5) {
			File file(tf_file_name(j++), "w");
			for(unsigned int k=0; k<(TFE_FILE_SIZE/sizeof(zerodata)); ++k)
			    file.write(zerodata, sizeof(zerodata));
			continue;
		}
		ts_sleep(60,1);
		i = mgr.get_offset(0)/TFE_FILE_SIZE;
	}
    return NULL;
}

int tfe_create_first_file()
{
    if(File::exist(tf_file_name(0))) return 0;
    unsigned char zerodata[4096]; memset(zerodata, 0, sizeof(zerodata));
    File file(tf_file_name(0), "w");
    for(unsigned int k=0; k<(TFE_FILE_SIZE/sizeof(zerodata)); ++k)
        file.write(zerodata, sizeof(zerodata));
    return 0;
}

int tfe_create()
{
    unsigned char buf[CheckPointFile::record_size];
	memset(buf, 0, sizeof(buf));
	if(File::exist(checkpoint_file_name())) {
	    File::truncate_by_align(checkpoint_file_name(), CheckPointFile::record_size);
		CheckPointFile file(checkpoint_file_name());
		file.read_last_record(buf, sizeof(buf));
	}
    Manager::create(&buf[0] + CheckPointFile::data_offset);

    Manager mgr;

    //check switch tfe file
    char path[256]={0}; sprintf(path, "%s.update", checkpoint_file_name());
    FILE* fh; char buf_s[256]={0};
    if((fh=fopen(path,"r"))){
        size_t n=256; fgets(buf_s,n,fh);printf("checkpoint.upate:<%s>\n",buf_s);
        if(strlen(buf_s)>=2){
            if(buf_s[strlen(buf_s)-1]=='\r' || buf_s[strlen(buf_s)-1]=='\n') buf_s[strlen(buf_s)-1]=0x00;
            if(buf_s[strlen(buf_s)-2]=='\r' || buf_s[strlen(buf_s)-2]=='\n') buf_s[strlen(buf_s)-2]=0x00;
        }
        int fidx = atoi(buf_s);
        for(int i=0; i<TFE_TASK_CNT; ++i){
            mgr.set_offset(i, (long long)fidx * TFE_FILE_SIZE);
            mgr.set_pre_offset(i, (long long)fidx * TFE_FILE_SIZE);
        }
        fclose(fh);
        char cmd[512]={0}; sprintf(cmd, "rm -f %s.update",checkpoint_file_name());
        system(cmd);
    }

    log_debug(" checkponit begin [ Adder ]----------------- [%d] offset[%lld] count[%lld]\n",
        get_now(), mgr.get_offset(0), mgr.get_count(0));
    log_debug(" checkponit begin [ Flush ]----------------- [%d] offset[%lld] count[%lld]\n",
        get_now(), mgr.get_offset(1), mgr.get_count(1));
    log_debug(" checkponit begin [ Reply ]----------------- [%d] offset[%lld] count[%lld]\n",
        get_now(), mgr.get_offset(2), mgr.get_count(2));

	if(0 != mgr.get_offset(0) && 0 != mgr.get_offset(1))
    {
        uint64 count = mgr.get_count(0); //005
		uint64 offset = Task::find_end(mgr.get_offset(1), verify_tf_record, count);
		mgr.set_offset(0, offset); mgr.set_offset(1, offset);
		mgr.set_count(0, count); //005
	}

    log_debug(" checkponit end [ Adder ]----------------- [%d] offset[%lld] count[%lld]\n",
        get_now(), mgr.get_offset(0), mgr.get_count(0));
    log_debug(" checkponit end [ Flush ]----------------- [%d] offset[%lld] count[%lld]\n",
        get_now(), mgr.get_offset(1), mgr.get_count(1));
    log_debug(" checkponit end [ Reply ]----------------- [%d] offset[%lld] count[%lld]\n",
        get_now(), mgr.get_offset(2), mgr.get_count(2));


    //init first tfe file
    tfe_create_first_file();

#ifndef TFE_SINGLE
	log_info("tfe_create success! shm_key[%#x] shm_id[%d] size[%d]", mgr.m_shm.m_key, 0, mgr.m_shm.m_len);//caoxf__
#endif
    return 0;
}

int tfe_destroy()
{
    Manager::destroy();
    return 0;
}




#ifdef TFE_SINGLE


int main(int argc, char *argv[])
{
#ifdef SHM_CREATOR
    tfe_create();
#endif

#ifdef SHM_DESTROY
    tfe_destroy();
#endif

#ifdef TF_VIEW
    tfe_init();

    uint32 fileIdx = 0;
    uint32 offset = 0;
    uint32 fileIdx_pre = 0;
    uint32 offset_pre = 0;
    while(true) {
        system("clear");
        tfe_get_offset(TFE_TASK_ADDER, &fileIdx, &offset);
        tfe_get_pre_offset(TFE_TASK_ADDER, &fileIdx_pre, &offset_pre);
        printf("%-16s[%02d]   %-8d %-11d                                  %-12lld\n",
            "tfe_adder", TFE_TASK_ADDER, fileIdx, offset, tfe_get_count(TFE_TASK_ADDER));

        tfe_get_offset(TFE_TASK_FLUSH, &fileIdx, &offset);
        tfe_get_pre_offset(TFE_TASK_FLUSH, &fileIdx_pre, &offset_pre);
        printf("%-16s[%02d]   %-8d %-11d\n",
            "tfe_flush", TFE_TASK_FLUSH, fileIdx, offset);

        tfe_get_offset(TFE_TASK_REPLY, &fileIdx, &offset);
        tfe_get_pre_offset(TFE_TASK_REPLY, &fileIdx_pre, &offset_pre);
        printf("%-16s[%02d]   %-8d %-11d   %-12d %-15d   %-12lld\n",
            "tfe_reply", TFE_TASK_REPLY, fileIdx, offset, fileIdx_pre, offset_pre, tfe_get_count(TFE_TASK_REPLY));

        tfe_get_offset(TFE_TASK_UPDATE, &fileIdx, &offset);
        tfe_get_pre_offset(TFE_TASK_UPDATE, &fileIdx_pre, &offset_pre);
        printf("%-16s[%02d]   %-8d %-11d   %-12d %-15d   %-12lld\n",
            "tfe_update", TFE_TASK_UPDATE, fileIdx, offset, fileIdx_pre, offset_pre, tfe_get_count(TFE_TASK_UPDATE));

        tfe_get_offset(TFE_TASK_SCAN, &fileIdx, &offset);
        tfe_get_pre_offset(TFE_TASK_SCAN, &fileIdx_pre, &offset_pre);
        printf("%-16s[%02d]   %-8d %-11d   %-12d %-15d   %-12lld\n",
            "tfe_scan", TFE_TASK_SCAN, fileIdx, offset, fileIdx_pre, offset_pre, tfe_get_count(TFE_TASK_SCAN));

        tfe_get_offset(TFE_TASK_UPDATE_DB, &fileIdx, &offset);
        tfe_get_pre_offset(TFE_TASK_UPDATE_DB, &fileIdx_pre, &offset_pre);
        printf("%-16s[%02d]   %-8d %-11d   %-12d %-15d   %-12lld\n",
            "tfe_update_db", TFE_TASK_UPDATE_DB, fileIdx, offset, fileIdx_pre, offset_pre, tfe_get_count(TFE_TASK_UPDATE_DB));

        //tfe_get_offset(TFE_TASK_UPDATE_DB2, &fileIdx, &offset);
        //tfe_get_pre_offset(TFE_TASK_UPDATE_DB2, &fileIdx_pre, &offset_pre);
        //printf("%-16s[%02d]   %-8d %-11d   %-12d %-15d   %-12lld\n",
          //  "tfe_update_db2", TFE_TASK_UPDATE_DB2, fileIdx, offset, fileIdx_pre, offset_pre, tfe_get_count(TFE_TASK_UPDATE_DB2));

        sleep(1);
    }
#endif

#ifdef FILE_CREATOR
    tfe_create_file(NULL);
#endif

#ifdef ADDER
    int rec_length = 100;
    int rec_num = 1;
    rec_length = atoi(argv[1]);
    rec_num = atoi(argv[2]);

    tfe_t_init(TFE_TASK_ADDER, 0, "1", false);
    int i = 0;
    unsigned char buf[10240];
    memset(buf, 0, sizeof(buf));

    *(uint16*)buf = rec_length;
    for (i=0;i<rec_num;i++) {
        *(int*)(buf+sizeof(Head)) = i;
        tfe_t_write(buf, *(uint16*)buf);
    }
    //printf("ok finished!\n"); while(1) sleep(3);
#endif

#ifdef FLUSH
    tfe_t_init(TFE_TASK_FLUSH, TFE_TASK_ADDER, "2", false);
    while(1) { tfe_t_flush(); usleep(100*1000); }
#endif

#ifdef REPLY
    uint64 count = 0;
    tfe_t_init(TFE_TASK_REPLY, TFE_TASK_FLUSH, "3", true);
    tfe_check_point_init();
    unsigned char buf[800];
    while(1){
        int ret = tfe_t_read(buf, sizeof(buf), 1000);
        if((ret!=TFE_TIMEOUT)&&(ret!=0)) { printf("---Reply---"); fflush(NULL); break;}
        tfe_t_commit();
        count++;
        if (count >= 100) {tfe_do_check_point(count); count=0;}
    }
#endif

#ifdef UPDATE
    tfe_t_init(TFE_TASK_UPDATE, TFE_TASK_REPLY, "5 7 9 12 13", true);
    unsigned char buf[800];
    while(1){
        int ret = tfe_t_read(buf, sizeof(buf), 1000);
        if((ret!=TFE_TIMEOUT)&&(ret!=0)) { printf("---Update---"); fflush(NULL); break;}
        tfe_t_commit();
    }
#endif

#ifdef SCAN
    tfe_t_init(TFE_TASK_SCAN, TFE_TASK_UPDATE, "", true);
    unsigned char buf[800];
    while(1){
        int ret = tfe_t_read(buf, sizeof(buf), 1000);
        if((ret!=TFE_TIMEOUT)&&(ret!=0)) { printf("---Scan---"); fflush(NULL); break;}
        tfe_t_commit();
    }
#endif

#ifdef UPDATE_DB
    tfe_t_init(TFE_TASK_UPDATE_DB, TFE_TASK_UPDATE, "", true);
    unsigned char buf[800];
    while(1){
        int ret = tfe_t_read(buf, sizeof(buf), 1000);
        if((ret!=TFE_TIMEOUT)&&(ret!=0)) { printf("---Update_DB---"); fflush(NULL); break;}
        tfe_t_commit();
    }
#endif

#ifdef UPDATE_DB2
    tfe_t_init(TFE_TASK_UPDATE_DB2, TFE_TASK_UPDATE, "", true);
    unsigned char buf[800];
    while(1){
        int ret = tfe_t_read(buf, sizeof(buf), 1000);
        if((ret!=TFE_TIMEOUT)&&(ret!=0)) { printf("---Update_DB2---"); fflush(NULL); break;}
        tfe_t_commit();
    }
#endif

}


#endif

