/*==============================================================================
 模块名：


 修改记录：
 +++ 修改日期                             当前版本                                 修改人员                                修改描述
 ++| ----------      ------------      ------------     -------------
 ++| 2009.09.25                        Tommy, Forrest

 ==============================================================================*/

/*==============================================================================
 * 包含系统文件
 * Includes System Files
 =============================================================================*/

#include "global.h"

/*==============================================================================
 * 包含本地文件
 * Include Files
 =============================================================================*/

/*==============================================================================
 * 常量定义，并对所定义的常量进行说明
 * Constant / Define Declarations
 =============================================================================*/

/*==============================================================================
 * 类型定义(struct、enum)等,如果是重要数据结构，要详细说明
 * Type Declarations(struct,enum etc.) and Brief Description
 * If it's Significant,Detailed Description Should Be Present
 =============================================================================*/

/*==============================================================================
 * 全局常量定义，并对其进行简要说明
 * Global Constant Declarations and Brief Description
 =============================================================================*/

/*==============================================================================
 * 本地值/函数宏定义，并对其进行简要说明
 * Local Variable and Macro Definitions and Brief Description
 =============================================================================*/
bool env_read(
        const char* env_key,
        char * const env_val)
{
    char* value=getenv(env_key);
    if(value==null)
    {
        return false;
    }
    else
    {
        strcpy(env_val,value);
        return true;
    }
}

/*****************************************************************************************
 * 函数名称：
 * 参数：
 * 返回值：
 * 功能描述：
 ******************************************************************************************/
int rmdirs(const char *name)
{
    int ret = 0;
    DIR *dir;
    struct dirent *read_dir;
    struct stat st;
    char buf[PATH_MAX];

    if (lstat(name, &st) < 0) {
         if (errno == ENOENT) {
             return ret;
         }
         perrork("lstat(%s) failed. Reason:%s.", name, strerror(errno));
         return -1;
    }

    if (S_ISDIR(st.st_mode)) {
        if ((dir = opendir(name)) == NULL) {
            perrork("opendir(%s) failed. Reason:%s.", name, strerror(errno));
            return -1;
        }

        while ((read_dir = readdir(dir)) != NULL) {
            if (strcmp(read_dir->d_name, ".") == 0 || strcmp(read_dir->d_name, "..") == 0) {
                continue;
            }
            sprintf(buf, "%s/%s", name, read_dir->d_name);
            ret = rmdirs(buf);
            if (0 != ret) {
                return -1;
            }
        }
        closedir(dir);
    }

    if (remove(name) != 0) {
        perrork("opendir(%s) failed. Reason:%s.", name, strerror(errno));
        return -1;
    }

    return ret;
}


/*****************************************************************************************
 * 函数名称：
 * 参数：
 * 返回值：
 * 功能描述：
 ******************************************************************************************/
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


/*****************************************************************************************
 * 函数名称：
 * 参数：
 * 返回值：
 * 功能描述：
 ******************************************************************************************/
ssize_t safe_read(int fd, void *buf, size_t count)
{
    ssize_t n;

    do {
        n = read(fd, buf, count);
    } while (n < 0 && errno == EINTR);

    return n;
}

/*****************************************************************************************
 * 函数名称：
 * 参数：
 * 返回值：
 * 功能描述：
 ******************************************************************************************/
ssize_t safe_write(int fd, const void *buf, size_t count)
{
    ssize_t n;

    do {
        n = write(fd, buf, count);
    } while (n < 0 && errno == EINTR);

    return n;
}

/*****************************************************************************************
 * 函数名称：
 * 参数：
 * 返回值：
 * 功能描述：
 ******************************************************************************************/
ssize_t full_write(int fd, const void *buf, size_t len)
{
    ssize_t cc;
    ssize_t total;

    total = 0;

    while (len) {
        cc = safe_write(fd, buf, len);

        if (cc < 0) {
            if (total) {
                return total;
            }
            return cc;
        }

        total += cc;
        buf = ((const char *)buf) + cc;
        len -= cc;
    }

    return total;
}

/*****************************************************************************************
 * 函数名称：
 * 参数：
 * 返回值：
 * 功能描述：
 ******************************************************************************************/
int file_copy(const char *in_file, const char *out_file)
{
    int ret = 0;

    char out_file_tmp[PATH_MAX];
    strcpy(out_file_tmp, out_file);
    char *out_dir = dirname(out_file_tmp);

    ret = mkdirs(out_dir);
    if (0 != ret) {
        perrork("mkdirs(%s) failed.", out_dir);

        return -1;
    }

    int in_fd;
    int out_fd;
    struct stat stat_t;

    ret = stat(in_file, &stat_t);
    if (ret != 0) {
        if (errno == ENOENT) {
            // do not exist
            perrork("open(%s) failed. Reason:%s.", in_file, strerror(errno));

            return 0;
        }

        perrork("open(%s) failed. Reason:%s.", in_file, strerror(errno));

        return -1;
    }
    if((in_fd = open(in_file, O_RDONLY)) == -1) {
        perrork("open(%s) failed. Reason:%s.", in_file, strerror(errno));


        return -1;
    }
    if ((out_fd = open(out_file, O_WRONLY|O_CREAT|O_TRUNC, S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH)) == -1) {
         perrork("open(%s) failed. Reason:%s.", out_file, strerror(errno));
         close(in_fd);

         return -1;
    }

    int count = 0;
    char buf[1024*32];
    while ((count = safe_read(in_fd, buf, sizeof(buf))) > 0) {
        if (full_write(out_fd, buf, count) != count) {
            perrork("full_write(%s) failed. Reason:%s.", out_file, strerror(errno));
            close(in_fd);
            close(out_fd);

            return -1;
        }
    }

    if (count < 0) {
        perrork("safe_read(%s) failed. Reason:%s.", in_file, strerror(errno));
        close(in_fd);
        close(out_fd);

        return -1;
    }

    close(in_fd);
    close(out_fd);

    return 0;
}

/*****************************************************************************************
 * 函数名称：
 * 参数：
 * 返回值：
 * 功能描述：
 ******************************************************************************************/
int file_copy_md5sum(const char *in_file, const char *out_file)
{
    int ret = 0;

    char out_file_tmp[PATH_MAX];
    strcpy(out_file_tmp, out_file);
    char *out_dir = dirname(out_file_tmp);

    ret = mkdirs(out_dir);
    if (0 != ret) {
        perrork("mkdirs(%s) failed.", out_dir);

        return -1;
    }

    char md5sum_file[PATH_MAX];
    strcpy(md5sum_file, out_file);
    strcat(md5sum_file, ".md5");

    int in_fd;
    int out_fd;
    int md5sum_fd;
    struct stat stat_t;

    ret = stat(in_file, &stat_t);
    if (ret != 0) {
        if (errno == ENOENT) {
            // do not exist
            perrork("open(%s) failed. Reason:%s.", in_file, strerror(errno));
            return 0;
        }
        perrork("open(%s) failed. Reason:%s.", in_file, strerror(errno));

        return -1;
    }

    if((in_fd = open(in_file, O_RDONLY)) == -1) {
        perrork("open(%s) failed. Reason:%s.", in_file, strerror(errno));

        return -1;
    }

    if ((out_fd = open(out_file, O_WRONLY|O_CREAT|O_TRUNC, S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH)) == -1) {
         perrork("open(%s) failed. Reason:%s.", out_file, strerror(errno));
         close(in_fd);

         return -1;
    }

    MD5_CTX context;
    MD5Init(&context);

    int count = 0;
    char buf[1024*32];
    while ((count = safe_read(in_fd, buf, sizeof(buf))) > 0) {
        MD5Update(&context, (unsigned char *)buf, count);
        if (full_write(out_fd, buf, count) != count) {
            perrork("full_write(%s) failed. Reason:%s.", out_file, strerror(errno));
            close(in_fd);
            close(out_fd);

            return -1;
        }
    }

    close(in_fd);
    close(out_fd);

    if (count < 0) {
        perrork("safe_read(%s) failed. Reason:%s.", in_file, strerror(errno));

        return -1;
    }

    if ((md5sum_fd = open(md5sum_file, O_WRONLY|O_CREAT|O_TRUNC, S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH)) == -1) {
         perrork("open(%s) failed. Reason:%s.", md5sum_file, strerror(errno));

         return -1;
    }

    unsigned char digest[16];
    char digest_str[32+1];

    MD5Final(digest, &context);
    for (int i = 0; i < 16; i++) {
        sprintf(digest_str + 2*i, "%.02x", digest[i]);
    }

    if (full_write(md5sum_fd, digest_str, sizeof(digest_str) - 1) != sizeof(digest_str) - 1) {
        perrork("full_write(%s) failed. Reason:%s.", md5sum_file, strerror(errno));
        close(md5sum_fd);

        return -1;
    }

    close(md5sum_fd);

    return ret;
}


/*****************************************************************************************
 * 函数名称：
 * 参数：
 * 返回值：
 * 功能描述：拷贝文件 并 生成md5文件，并与原文件的md5进行比较
 ******************************************************************************************/
int copy_file_md5(char *filepath, char *file_new)
{
    char md5_a[32];
    char md5_b[32];
    int ret = file_copy_md5sum(filepath, file_new);
    if (ret < 0) {
        log_error("file_copy_md5sum() return error. [%s]", filepath);
        return -1;
    }

    if (0 > get_md5_file(filepath, md5_a)) {
        log_error("get_md5_file() error. %s", filepath);
        return -1;
    }
    if (0 > get_md5_file(file_new, md5_b)) {
        log_error("get_md5_file() error. %s", file_new);
        return -1;
    }
    if (0 != strncmp(md5_a,md5_b,32)) {
        log_error("md5 check failure. %s", filepath);
        return -1;
    }
    return 0;
}


/*****************************************************************************************
 * 函数名称：
 * 参数：
 * 返回值：
 * 功能描述：
 ******************************************************************************************/
int get_file_size(const char *file_path, uint64 *f_size)
{
    struct stat f_stat;

    memset(&f_stat, 0, sizeof(f_stat));
    *f_size = 0;
    int ret = stat(file_path, &f_stat);
    if (0 == ret) {
        *f_size = f_stat.st_size;

        return 0;
    }

    return -1;
}


/*****************************************************************************************
 * 函数名称：buffer 转 16进制 字符串
 * 参数：
 * 返回值：
 * 功能描述：
 ******************************************************************************************/
char *binary_encode_hex(uint8 *buf, int length, char *outputStr)
{
   int i;
   int str_len = 0;
   outputStr[0] = '\0';
   for (i = 0; i < length; i++) {
       // make sure the outputStr is big enough
       str_len += sprintf(outputStr + str_len, "%02X", buf[i]);
   }

   return outputStr;
}


/*****************************************************************************************
 * 函数名称：从 16进制 字符串 转 buffer
 * 参数： 字符串指针，字符串长度， 输出的buf
 * 返回值：返回buf的长度
 * 功能描述： 内部使用，代码中没有做非法字符的保护
 ******************************************************************************************/
int32 hex_decode_binary(char *str, int length, uint8 *outputBuf)
{
    int i = 0;
    char hex_char_str[3] = {0};
    unsigned char *ptr = (unsigned char *)outputBuf;
    int cnt = 0;
    for (i=0; i<length; i+=2)
    {
        str[i] = toupper(str[i]);
        str[i+1] = toupper(str[i+1]);
        hex_char_str[0] = str[i];
        hex_char_str[1] = str[i+1];
        hex_char_str[2] = '\0';
        *(ptr + cnt) = (unsigned char)strtol(hex_char_str, NULL, 16);
        cnt++;
    }
    return cnt;
}


