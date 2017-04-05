#ifndef NCP_UTILITY_H
#define NCP_UTILITY_H

time_t get_now();
void set_non_block(int fd);
char *get_time_format(char *time_string);

// log
#define perrork(format,args...) \
            fprintf(stderr, format, ##args);\
            fprintf(stderr, "[errinfo:%d]: %s\n",errno,strerror(errno));


//log level
#define DD  0
#define II  1
#define WW  2
#define EE  3
#define PP  99
#define logit(flag, fmt, varlist...) \
    do { \
        char ff[4]; \
        if (flag==DD) sprintf(ff,"DD"); \
        else if (flag==II) sprintf(ff,"II"); \
        else if (flag==WW) sprintf(ff,"WW"); \
        else if (flag==EE) sprintf(ff,"EE"); \
        else if (flag==PP) sprintf(ff,"PP"); \
        else sprintf(ff,"**"); \
        if (flag>=log_level()) { \
            char time_string[96]; \
            if (flag==WW || flag==EE) \
                fprintf(stderr, "[%s][ %s ] [%s@%s:%d]-> "fmt"\n", log_time_format(time_string), ff, __FUNCTION__, __FILE__, __LINE__, ##varlist); \
            else if (flag==PP) \
                fprintf(stderr, "[%s] "fmt"\n", log_time_format(time_string), ##varlist); \
            else \
                fprintf(stderr, "[%s][ %s ] -> "fmt"\n", log_time_format(time_string), ff, ##varlist); \
            fflush(stderr); \
        } \
    } while (0)

#define LINENUM 16
#define logit_hex(buffer, length, fmt, varlist...) \
    do { \
        char log_buffer[1024*4]; char time_string[96]; \
        int offset = sprintf(log_buffer, "[%s] "fmt"\n", log_time_format(time_string), ##varlist); \
        for (int i=0;i<length;i++) { \
            sprintf(log_buffer+offset, "%02x ", (unsigned char)buffer[i]); offset += 3; \
            if (i>=1020) { break; } \
            if ((i+1) % LINENUM == 0) { if (i != (length-1)) { sprintf(log_buffer+offset, "\n"); offset += 1; } } \
        } \
        if (length>1020) fprintf(stderr, "%s...\n\n", log_buffer); \
        else fprintf(stderr, "%s\n\n", log_buffer); \
        fflush(stderr); \
    } while (0)            


char *log_time_format(char *time_string);

int logger_init(const char *file_name, int log_level);
int log_level();

#endif  //NCP_UTILITY_H

