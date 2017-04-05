#ifndef HCLOGIT_H_INCLUDED
#define HCLOGIT_H_INCLUDED

#include <stdio.h>


typedef enum _LOG_LEVEL {
    LOG_NOTICE = 1,
    LOG_DEBUG,
    LOG_INFO,
    LOG_WARN,
    LOG_ERROR,
    LOG_FATAL,
    LOG_NONE
} LOG_LEVEL;

char *get_time_format(char *time_string);
int get_pid();

int logger_init(const char *file_name);


#define log_notice(fmt, varlist...) \
    do { \
        if (sysdb_log_level() <= LOG_NOTICE) { \
           char time_buff[96]; \
           fprintf(stderr, "[%s][ NOTICE ][%d][%s@%s:%d]-> "fmt"\n", get_time_format(time_buff), get_pid(), __FUNCTION__, __FILE__, __LINE__, ##varlist); \
           fflush(stderr); \
        } \
    } while (0)

#define log_debug(fmt, varlist...) \
    do { \
        if (sysdb_log_level() <= LOG_DEBUG) { \
           char time_buff[96]; \
           fprintf(stderr, "[%s][ DEBUG ][%d][%s@%s:%d]-> "fmt"\n", get_time_format(time_buff), get_pid(), __FUNCTION__, __FILE__, __LINE__, ##varlist); \
           fflush(stderr); \
        } \
    } while (0)

#define log_info(fmt, varlist...) \
    do { \
        if (sysdb_log_level() <= LOG_INFO) { \
           char time_buff[96]; \
           fprintf(stderr, "[%s][ INFO  ][%d][%s@%s:%d]-> "fmt"\n", get_time_format(time_buff), get_pid(), __FUNCTION__, __FILE__, __LINE__, ##varlist); \
           fflush(stderr); \
        } \
    } while (0)

#define log_warn(fmt, varlist...) \
    do { \
        if (sysdb_log_level() <= LOG_WARN) { \
           char time_buff[96]; \
           fprintf(stderr, "[%s][ WARN  ][%d][%s@%s:%d]-> "fmt"\n", get_time_format(time_buff), get_pid(), __FUNCTION__, __FILE__, __LINE__, ##varlist); \
           fflush(stderr); \
       } \
    } while (0)

#define log_error(fmt, varlist...) \
	do { \
        if (sysdb_log_level() <= LOG_ERROR) { \
           char time_buff[96]; \
           fprintf(stderr, "[%s][ ERROR ][%d][%s@%s:%d]-> "fmt"\n", get_time_format(time_buff), get_pid(), __FUNCTION__, __FILE__, __LINE__, ##varlist); \
           fflush(stderr); \
       } \
    } while (0)

#define log_fatal( fmt, varlist...) \
    do { \
        if (sysdb_log_level() <= LOG_FATAL) { \
           char time_buff[96]; \
           fprintf(stderr, "[%s][ FATAL ][%d][%s@%s:%d]-> "fmt"\n", get_time_format(time_buff), get_pid(), __FUNCTION__, __FILE__, __LINE__, ##varlist); \
           fflush(stderr); \
        } \
    } while (0)


#endif // HCLOGIT_H_INCLUDED

