#ifndef _LOG_H_
#define _LOG_H_

#include <stdio.h>
#include <time.h>
#include <sys/time.h>

#define log(fmt, ...) \
do { \
    struct timeval tv; \
    struct tm ptm; \
    gettimeofday(&tv, NULL); \
    localtime_r(&tv.tv_sec, &ptm); \
    char time_string[96] = {0}; \
    sprintf(time_string, "%02d:%02d:%02d.%06ld", ptm.tm_hour, ptm.tm_min, \
            ptm.tm_sec, (long)(tv.tv_usec)); \
    fprintf(stderr, "[%s][%s:%d]->"fmt"\n", time_string, __FUNCTION__, \
            __LINE__, ##__VA_ARGS__); \
} while (0)

#endif // _LOG_H_
