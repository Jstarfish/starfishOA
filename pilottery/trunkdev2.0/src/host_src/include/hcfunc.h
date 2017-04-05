#ifndef HCFUNC_H_
#define HCFUNC_H_


/*=========================================================================================================
 * 函数性宏定义，并对其进行简要说明
 * Functional Macro Definitions and Brief Description
 =========================================================================================================*/

/**
 * 定义代码区域的含义，便于代码浏览
 */
#define R(...) 1


#define ISSYS32 (sizeof(long)==4)
#define ISSYS64 (sizeof(long)==8)

/**
 * 获取field在结构体(type)中的字节数
 */
#define FLD_SIZ(type,field) \
        sizeof(((type *) 0)->field)

/**
 * 获取field在结构体(type)中的偏移量
 */
#define FLD_POS(type,field) \
        ((ulong)&(((type *)0)->field))

/**
 * 解析错误原因
 */
#define ERRINFO strerror(errno)

/**
 * 获取最小值
 */
#define MIN_V(va,vb) (((va)>(vb))?(vb):(va))

/**
 * 获取最大值
 */
#define MAX_V(va,vb) (((va)>(vb))?(va):(vb))

/**
 * 返回一个比{val}小的最接近的{base}的倍数
 */
#define FLOOR(val,base) (((val)/(base))*(base))

/**
 * 返回一个比{val}大的最接近的{base}的倍数
 */
#define ROUND(val,base) ((((val)+(base-1))/(base))*(base))

/**
 * 返回数组元素的个数
 */
#define ARR_SIZE(arr) ( sizeof((arr))/sizeof((arr[0])))

/**
 * 导出变长常数列表
 */
#define NEWVARLIST(vname,vfrom) \
    va_list vname;\
    va_start(vname,vfrom);

#define GETNEXTVAR(vtype,vname,vlist) \
    vtype vname=va_arg(vlist,vtype)

/**
 * 导出变长常数列表
 */
#define STRVARLIST(BUF,VARS,FROM,SFMT) \
       va_list(VARS);\
       va_start(VARS,FROM);\
       vsprintf(BUF,SFMT,VARS);\
       va_end(VARS);

/**
 * 打印核心错误输出
 */
#define perrork(format,args...) \
            fprintf(stderr, format, ##args);\
            fprintf(stderr, "[errinfo:%d]: %s\n",errno,ERRINFO);

/**
 * 打印核心错误输出
 */
#define errdump(haserr,format,params...) \
            fprintf(stderr, format, ##params);\
            if((haserr)){\
              fprintf(stderr, "[errinfo:%d]: %s\n",errno,ERRINFO);\
            }

/**
 * 打印输出行
 */
#define println(format,args...) \
            printf(format,##args);printf("\n");

static __inline__ char* memwint08(
        char** dataptr,
        const void* datasrc)
{
    int datalen = sizeof(uint8);
    memcpy(*dataptr, datasrc, datalen);
    return (*dataptr = (*dataptr) + datalen);
}

static __inline__ char* memwint16(
        char** dataptr,
        const void* datasrc)
{
    int datalen = sizeof(uint16);
    memcpy(*dataptr, datasrc, datalen);
    return (*dataptr = (*dataptr) + datalen);
}

static __inline__ char* memwint32(
        char** dataptr,
        const void* datasrc)
{
    int datalen = sizeof(uint32);
    memcpy(*dataptr, datasrc, datalen);
    return (*dataptr = (*dataptr) + datalen);
}

static __inline__ char* memwint64(
        char** dataptr,
        const void* datasrc)
{
    int datalen = sizeof(uint64);
    memcpy(*dataptr, datasrc, datalen);
    return (*dataptr = (*dataptr) + datalen);
}

static __inline__ char* memwvint08(
        char** dataptr,
        const int8 datasrc)
{
    int8 dataval = datasrc;
    int datalen = sizeof(uint8);
    memcpy(*dataptr, &dataval, datalen);
    return (*dataptr = (*dataptr) + datalen);
}

static __inline__ char* memwvint16(
        char** dataptr,
        const uint16 datasrc)
{
    int16 dataval = datasrc;
    int datalen = sizeof(uint16);
    memcpy(*dataptr, &dataval, datalen);
    return (*dataptr = (*dataptr) + datalen);
}

static __inline__ char* memwvint32(
        char** dataptr,
        const int32 datasrc)
{
    int32 dataval = datasrc;
    int datalen = sizeof(uint32);
    memcpy(*dataptr, &dataval, datalen);
    return (*dataptr = (*dataptr) + datalen);
}

static __inline__ char* memwvint64(
        char** dataptr,
        const int64 datasrc)
{
    int64 dataval = datasrc;
    int datalen = sizeof(uint64);
    memcpy(*dataptr, &dataval, datalen);
    return (*dataptr = (*dataptr) + datalen);
}

static __inline__ char* memwstring(
        char** dataptr,
        const char* datasrc)
{
    int datalen = strlen(datasrc);
    memcpy(*dataptr, datasrc, datalen);
    return (*dataptr = (*dataptr) + datalen + 1);
}

static __inline__ char* memwarray(
        char** dataptr,
        const void* datasrc,
        const int datalen)
{
    memcpy(*dataptr, datasrc, datalen);
    return (*dataptr = (*dataptr) + datalen);
}

static __inline__ int8 memrint8(
        char** dataptr)
{
    static int width = sizeof(int8);
    *dataptr = (*dataptr) + width;
    return ((int8*) (*dataptr - width))[0];
}

static __inline__ int16 memrint16(
        char** dataptr)
{
    static int width = sizeof(int16);
    *dataptr = (*dataptr) + width;
    return ((int16*) (*dataptr - width))[0];
}

static __inline__ int32 memrint32(
        char** dataptr)
{
    static int width = sizeof(int32);
    *dataptr = (*dataptr) + width;
    return ((int32*) (*dataptr - width))[0];
}

static __inline__ long memrlong(
        char** dataptr)
{
    static int width = sizeof(long);
    *dataptr = (*dataptr) + width;
    return ((long*) (*dataptr - width))[0];
}


#endif /* HCFUNC_H_ */

