#include "ncp.h"
#include "ncp_util.h"

time_t get_now()
{
    time_t t1;
    time(&t1);
    return t1;
}

void set_non_block(int fd)
{
    int flags;
    flags = fcntl(fd, F_GETFL);
    flags |= O_NONBLOCK;
    fcntl(fd, F_SETFL, flags);
}

char *get_time_format(char *time_string)
{
    struct timeval tv; 
    struct tm ptm;
 
    gettimeofday(&tv, NULL); 
    localtime_r(&tv.tv_sec, &ptm);
    sprintf(time_string, "%04d-%02d-%02d %02d:%02d:%02d.%06ld", ptm.tm_year + 1900, ptm.tm_mon + 1, ptm.tm_mday, ptm.tm_hour, ptm.tm_min, ptm.tm_sec, (long)(tv.tv_usec));
    return time_string;
}




// log ---------------------------------------

static int log_level_g = 0;
static uint32 current_day_g = 0;
static char log_filename_g[64] = {0};

int mkdirs(const char *path)
{
    char pathname[PATH_MAX];
    strcpy(pathname, path);
    int i;
    int len = strlen(pathname);
    if (pathname[len -1] != '/') {
        strcat(pathname, "/");
    }
    len = strlen(pathname);

    for (i=1; i<len; i++) {
        if (pathname[i] == '/') {
            pathname[i] = 0;
            if (access(pathname, F_OK) != 0) {
                if (mkdir(pathname, 0755) == -1) {
                     perrork("mkdir(%s) failed. Reason:%s.", pathname, strerror(errno));
                     return -1;
                }
            }
            pathname[i]='/';
        }
    }

    return 0;
}

static int open_log_filestream()
{
    if (strlen(log_filename_g) == 0)
        return 0;

    struct timeval tv;
    struct tm ptm;
    gettimeofday(&tv, NULL);
    localtime_r(&tv.tv_sec, &ptm);

    current_day_g = (ptm.tm_year + 1900)*10000 + (ptm.tm_mon + 1)*100 + ptm.tm_mday;

    char time_buf[96];
    strftime(time_buf, sizeof(time_buf), "%Y-%m-%d", (const struct tm *)&ptm);

    char full_path[256] = {0};
    snprintf(full_path, sizeof(full_path), "/ts_ncp/logs/%s/%s.log", time_buf, log_filename_g);

    char file_path_tmp[256];
    strcpy(file_path_tmp, full_path);
    char *path_dir = dirname(file_path_tmp);
    int ret = mkdirs(path_dir);
    if (ret != 0)
    {
        fprintf(stderr, "mkdirs(%s) failed.\n", path_dir);
        return -1;
    }

    FILE *log_stream = fopen(full_path, "a+");
    if (NULL == log_stream)
    {
        fprintf(stderr, "unable to open %s, reason[%s].\n", full_path, strerror(errno));
        return -1;
    }
    ret = fchmod(fileno(log_stream), 0644);
    if (ret != 0)
    {
        fprintf(stderr, "fchmod(%s) failed. Reason: [%s]\n", full_path, strerror(errno));
        fclose(log_stream);
        return -1;
    }
    setlinebuf(log_stream);
    ret = dup2(fileno(log_stream), STDOUT_FILENO);
    if (-1 == ret)
    {
        perrork("dup2() failed. Reason [%s].", strerror(errno));
        fclose(log_stream);
        return -1;
    }
    ret = dup2(fileno(log_stream), STDERR_FILENO);
    if (-1 == ret)
    {
        perrork("dup2() failed. Reason [%s].", strerror(errno));
        fclose(log_stream);
        return -1;
    }
    fclose(log_stream);
    return 0;
}

char *log_time_format(char *time_string)
{
    struct timeval tv; 
    struct tm ptm; 
    gettimeofday(&tv, NULL); 
    localtime_r(&tv.tv_sec, &ptm);
    sprintf(time_string, "%04d-%02d-%02d %02d:%02d:%02d.%03d", ptm.tm_year + 1900, ptm.tm_mon + 1, ptm.tm_mday, ptm.tm_hour, ptm.tm_min, ptm.tm_sec, (int)(tv.tv_usec/1000));
    //´¦Àílog»»ÈÕ
    uint32 curdate = (ptm.tm_year + 1900)*10000 + (ptm.tm_mon + 1)*100 + ptm.tm_mday;
    if (current_day_g != curdate)
    {
        if (open_log_filestream() != 0)
        {
            fprintf(stderr, "open_log_filestream failed.");
        }
    }
    return time_string;
}

int logger_init(const char *file_name, int log_level)
{
    strcpy(log_filename_g, file_name);

    int ret = open_log_filestream();
    if (0 != ret)
    {
        fprintf(stderr, "open_log_filestream() failed.");
        return -1;
    }
    log_level_g = log_level;
    return 0;
}

int log_level()
{
    return log_level_g;
}

