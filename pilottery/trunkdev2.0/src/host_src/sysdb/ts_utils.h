#ifndef TS_UTILS_H_INCLUDED
#define TS_UTILS_H_INCLUDED



//---------------------------utility interface-------------------------

void clear_screen(void);
void clear_to_eol(void);
void move_cursor(int row, int col);
void print_status(const char *msg, int status);
void show_waiting_info(const char *msg, int times);

#define MOVE_TO_COL        "\033[60G"        // move to column 60
#define SETCOLOR_SUCCESS   "\033[1;32m"      // change color to bright (1) green (32)
#define SETCOLOR_FAILURE   "\033[1;31m"      // change color to bright (1) red (31)
#define SETCOLOR_WARNING   "\033[1;33m"      // change color to bright (1) yellor (33)
#define SETCOLOR_NORMAL    "\033[0;39m"      // reset all attr (0), change color to default (39)
#define LIGHT_GREEN        "\033[1;32m"
#define COLOR_CYAN         "\033[0;36m"      // reset all attr (0), change color to cyan (36)

#define MOVE_TO_PREV_LINE  "\033[1A"         // cursor up by 1 row



bool ts_initLog();
bool ts_closeLog();

//-------------------------------------------------------------------


int32 sys_startTask(SYS_TASK taskIdx);
int32 sys_startTaskEx(SYS_TASK taskIdx);

bool sys_check_process_alive(int pid);

int32 sys_stopTask(SYS_TASK taskIdx);
int32 sys_stopTaskEx(SYS_TASK taskIdx);
int32 sys_wait_task_stop(SYS_TASK taskIdx);

int32 sys_check_task();

bool sys_testOmsDB(char * username,char * passwd,char * servicename);


//------------------------------------------------------------------

bool sys_init();

bool sys_close();

bool sys_start_framework();

bool sys_game_init();

bool sys_start_tfe_first();

//等待数据库和TF同步完成
bool sys_wait_tfe_datbase_sync();

//数据加载线程
void *sys_load_data_thread(void *arg);

bool sys_recover_snapshot_data();

bool sys_start_data_resume_task();

bool sys_check_data_resume();

bool sys_start_operation_task();

void sys_stop_task_1();
bool sys_wait_close_sync();
void sys_stop_task_2();
void sys_stop_task_3();


//send system stste to BUSINESS
bool sys_send_business_state();


//Notify 发送线程
void *sys_send_notify_thread(void *arg);

#endif //TS_UTILS_H_INCLUDED

