#ifndef TFE_INF_H_INCLUDED
#define TFE_INF_H_INCLUDED


#define TFE_TASK_CNT  (16)
#define TFE_FILE_SIZE (512*1024*1024) //MAX is 2*1024*1024*1024

#define TFE_TIMEOUT      1
#define TFE_CRC_FAILED   2


#define TFE_HEADER_LENGTH   9

typedef enum _TFE_TASKID {
    TFE_TASK_ADDER = 0,
    TFE_TASK_FLUSH = 1,

    TFE_TASK_REPLY,
    TFE_TASK_SCAN,
    TFE_TASK_UPDATE,
    TFE_TASK_UPDATE_DB,
    TFE_TASK_UPDATE_DB2,
    //TFE_TASK_REMOTE_SYNC,
}TFE_TASKID;



int tfe_create();
int tfe_destroy();

void *tfe_create_file(void *arg);

int tfe_init();
void tfe_set_offset(int task_id, uint64 offset);
uint64 tfe_get_offset(int task_id, uint32 *fileIdx=NULL, uint32 *offset=NULL);
uint64 tfe_get_pre_offset(int task_id, uint32 *fileIdx=NULL, uint32 *offset=NULL);
uint64 tfe_get_count(int task_id);
void tfe_reinit_adder_count();
time_type tfe_get_last_checkpoint_time();
uint64 tfe_get_checkpoint_seq();

void tfe_dump_offset();//dump task offset



int tfe_find(unsigned char* buf, int buflen, uint64 offset);

int tfe_check_point_init();
int tfe_do_check_point(uint64 seq);


int tfe_t_init(int taskid, int target, const char* followers, int using_advanced_read);
int tfe_t_write(const unsigned char* buf, int buflen);
int tfe_t_flush();
int tfe_t_read(unsigned char* buf, int buflen, int msec);
int tfe_t_commit();
int tfe_t_rollback();

uint64 tfe_t_file_offset(uint32 *fileIdx=NULL, uint32 *offset=NULL);
uint64 tfe_t_pre_file_offset(uint32 *fileIdx=NULL, uint32 *offset=NULL);


int tfe_t_keep_footmark(const char* name, int id);
int tfe_t_restore_footmark(const char* name, int id);


#endif  // TFE_INF_H_INCLUDED

