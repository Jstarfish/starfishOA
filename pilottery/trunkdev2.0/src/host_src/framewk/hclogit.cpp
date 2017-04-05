/*==============================================================================
 * 包含本地文件
 * Include Files
 =============================================================================*/
#include "global.h"

static int log_pid_g;

static uint32 current_day_g = 0;

static char log_filename_g[64] = {0};


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
    snprintf(full_path, sizeof(full_path), "%s/%s/%s.log", LOG_ROOT_DIR, time_buf, log_filename_g);

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

char *get_time_format(char *time_string)
{
    struct timeval tv; 
    struct tm ptm;
 
    gettimeofday(&tv, NULL); 
    localtime_r(&tv.tv_sec, &ptm);
    sprintf(time_string, "%04d-%02d-%02d %02d:%02d:%02d.%06ld", ptm.tm_year + 1900, ptm.tm_mon + 1, ptm.tm_mday, ptm.tm_hour, ptm.tm_min, ptm.tm_sec, (long)(tv.tv_usec));

    //处理log换日
    uint32 curdate = (ptm.tm_year + 1900)*10000 + (ptm.tm_mon + 1)*100 + ptm.tm_mday;
    if (current_day_g != curdate)
    {
        if ( open_log_filestream() != 0)
        {
            fprintf(stderr, "open_log_filestream failed.");
        }
    }
    return time_string;
}

int logger_init(const char *file_name)
{
    strcpy(log_filename_g, file_name);

    log_pid_g = getpid();

    int ret = open_log_filestream();
    if (0 != ret)
    {
        fprintf(stderr, "open_log_filestream() failed.");
        return -1;
    }
    return 0;
}

int get_pid()
{
    return log_pid_g;
}


