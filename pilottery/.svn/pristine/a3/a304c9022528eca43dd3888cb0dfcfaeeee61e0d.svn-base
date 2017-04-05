#ifndef _SHM_MOD_H_
#define _SHM_MOD_H_

#define RNG_SHM_PATH         "/ts_rng/ipcs/shm.key"
#define RNG_SHM_KEY          15
#define MAX_GAME_NUMBER      8
#define GAME_NAME_LENGTH     50
#define LOG_NUMBER           100
#define LOG_LENGTH           150  //actual screen log it will be truncated to the size of the window

#pragma pack(1)

typedef struct _RNG_SHM_INFO {
    char  server_ip[16];
    int   port;
    int   device_id;
    char  device_type[30];
    int   connect_interval;
    int   heartbeat_interval;
    int   heartbeat_timeout;

    int   work_status; // initialize to RNG_UNCONNECTED

    char  local_ip[16];
    unsigned char  local_mac[6];
    char  start_time[32];
    char  last_connect_time[32];
    char  last_disconnect_time[32];

    long  last_hb_sent;
    long  last_hb_recv;

    char  debug_info[256]; // format '(gamecode,queue_size,sample_1_size,sample_2_size...)(..)..'

    int   business_idx; // initialize to 0
    char  business_info_array[LOG_NUMBER][LOG_LENGTH];

    int   run_idx; // initialize to 0
    char  run_info_array[LOG_NUMBER][LOG_LENGTH];
} RNG_SHM_INFO;

typedef RNG_SHM_INFO *RNG_SHM_PTR;

#pragma pack()

// helper function to get formatted time in c string, used by rngview and client
char *get_date_time_format(time_t t, char *f);

// create shared memory
int shm_create(void);

// delete shared memory
int shm_destroy(void);

// attach shared memory
int shm_init(void);

// close shared memory
int shm_close(void);

// get the pointer of shared memory
RNG_SHM_PTR get_shm_ptr(void);

typedef enum _INFO_TYPE {
    BUSINESS = 0,
    RUN      = 1,
} INFO_TYPE;

// push log info into the specified message array in the shared memory
int shm_runlog_info(const char *str, ...);
int shm_business_info(const char *str, ...);

#endif // _SHM_MOD_H_









































