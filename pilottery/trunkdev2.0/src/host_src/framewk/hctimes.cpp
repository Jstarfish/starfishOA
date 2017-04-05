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

/*==============================================================================
 * 包含本地文件
 * Include Files
 =============================================================================*/

#include "global.h"

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

enum TIME_ZONE TIME_ZONE_MODE=TZONE_EN;

const char DATE_FORMAT_EN[32] = "%s-%s-%s";
const char DATE_FORMAT_CN[32] = "%s年%s月%s日";

const char TIME_FORMAT_EN[32] = "%s:%s:%s";
const char TIME_FORMAT_CN[32] = "%s时%s分%s秒";

const char TIME_FORMAT_EX_EN[32] = "%s:%s:%s.%3d";
const char TIME_FORMAT_EX_CN[32] = "%s时%s分%s秒%3d毫秒";

const char DATETIME_FORMAT_EN[32] = "%s-%s-%s %s:%s:%s";
const char DATETIME_FORMAT_CN[32] = "%s年%s月%s日%s时%s分%s秒";

const char DATETIME_FORMAT_NAME[32] = "%s-%s-%s_%s:%s:%s";

const char DATETIME_FORMAT_EX_EN[32] = "%s-%s-%s %s:%s:%s.%3d";
const char DATETIME_FORMAT_EX_CN[32] = "%s年%s月%s日%s时%s分%s秒%3d毫秒";
/*==============================================================================
 * 本地类型定义(struct、enum)等,如果是重要数据结构，要详细说明
 * Type Declarations(struct,enum etc.) and Brief Description
 * If it's Significant,Detailed Description Should Be Present
 =============================================================================*/

struct TZONE_FORMAT_STRUCT
{
    const char* date_f;
    const char* time_f;
    const char* timeex_f;
    const char* datetime_f;
    const char* datetimeex_f;
};

TZONE_FORMAT_STRUCT TZONE_FORMAT_ARR[2] =
    {
        { DATE_FORMAT_EN, TIME_FORMAT_EN, TIME_FORMAT_EX_EN, DATETIME_FORMAT_EN,
            DATETIME_FORMAT_EX_EN },
        { DATE_FORMAT_CN, TIME_FORMAT_CN, TIME_FORMAT_EX_CN, DATETIME_FORMAT_CN,
            DATETIME_FORMAT_EX_CN }
    };


/*==============================================================================
 * 本地值/函数宏定义，并对其进行简要说明
 * Local Variable and Macro Definitions and Brief Description
 =============================================================================*/


long get_when()
{
    struct timeval curtime;
    gettimeofday(&curtime, null);
    return curtime.tv_sec;
}

long get_whenMillisecond()
{
    struct timeval curtime;
    gettimeofday(&curtime, null);
    return ((curtime.tv_sec*1000) + (curtime.tv_usec/1000));
}

void get_when_ex(TIME_TYPE* time)
{
    if (time != null)
    {
        gettimeofday(time, null);
    }
}

char* cur_date(char* buffer)
{
    return get_date(TZONE_FORMAT_ARR[TIME_ZONE_MODE].date_f, buffer);
}

char* cur_time(char* buffer)
{
    return get_time(TZONE_FORMAT_ARR[TIME_ZONE_MODE].time_f, buffer);
}

char* cur_time_ex(char* buffer)
{
    return get_time_ex(TZONE_FORMAT_ARR[TIME_ZONE_MODE].timeex_f, buffer);
}

char* cur_date_time(char* buffer)
{
    return get_date_time(TZONE_FORMAT_ARR[TIME_ZONE_MODE].datetime_f, buffer);
}

char* cur_date_time_ex(char* buffer)
{
    return get_date_time_ex(TZONE_FORMAT_ARR[TIME_ZONE_MODE].datetimeex_f,
            buffer);
}

char* get_date(const char* format, char* buffer)
{
    char ybuf[4 + 1];
    char mbuf[2 + 1];
    char dbuf[2 + 1];
    time_t curtime;
    struct tm * tm_ptr;
    time(&curtime);
    tm_ptr = localtime(&curtime);

    sprintf(ybuf, "%d", tm_ptr->tm_year + 1900);

    if (tm_ptr->tm_mon + 1 >= 10)
    {
        sprintf(mbuf, "%d", tm_ptr->tm_mon + 1);
    }
    else
    {
        sprintf(mbuf, "0%d", tm_ptr->tm_mon + 1);
    }

    if (tm_ptr->tm_mday >= 10)
    {
        sprintf(dbuf, "%d", tm_ptr->tm_mday);
    }
    else
    {
        sprintf(dbuf, "0%d", tm_ptr->tm_mday);
    }

    sprintf(buffer, format, ybuf, mbuf, dbuf);

    return buffer;
}

char* get_time(const char* format, char* buffer)
{
    char hbuf[2 + 1];
    char ibuf[2 + 1];
    char sbuf[2 + 1];
    time_t curtime;
    struct tm * tm_ptr;
    time(&curtime);
    tm_ptr = localtime(&curtime);

    if (tm_ptr->tm_hour >= 10)
    {
        sprintf(hbuf, "%d", tm_ptr->tm_hour);
    }
    else
    {
        sprintf(hbuf, "0%d", tm_ptr->tm_hour);
    }

    if (tm_ptr->tm_min >= 10)
    {
        sprintf(ibuf, "%d", tm_ptr->tm_min);
    }
    else
    {
        sprintf(ibuf, "0%d", tm_ptr->tm_min);
    }

    if (tm_ptr->tm_sec >= 10)
    {
        sprintf(sbuf, "%d", tm_ptr->tm_sec);
    }
    else
    {
        sprintf(sbuf, "0%d", tm_ptr->tm_sec);
    }

    sprintf(buffer, format, hbuf, ibuf, sbuf);

    return buffer;
}

char* get_time_ex(const char* format, char* buffer)
{
    char hbuf[2 + 1];
    char ibuf[2 + 1];
    char sbuf[2 + 1];
    struct tm * tm_ptr;
    struct timeval curtime;
    gettimeofday(&curtime, null);
    tm_ptr = localtime(&curtime.tv_sec);

    if (tm_ptr->tm_hour >= 10)
    {
        sprintf(hbuf, "%d", tm_ptr->tm_hour);
    }
    else
    {
        sprintf(hbuf, "0%d", tm_ptr->tm_hour);
    }

    if (tm_ptr->tm_min >= 10)
    {
        sprintf(ibuf, "%d", tm_ptr->tm_min);
    }
    else
    {
        sprintf(ibuf, "0%d", tm_ptr->tm_min);
    }

    if (tm_ptr->tm_sec >= 10)
    {
        sprintf(sbuf, "%d", tm_ptr->tm_sec);
    }
    else
    {
        sprintf(sbuf, "0%d", tm_ptr->tm_sec);
    }

    sprintf(buffer, format, hbuf, ibuf, sbuf, curtime.tv_usec / 1000);

    return buffer;
}

char* get_date_time(const char* format, char* buffer)
{
    char ybuf[4 + 1];
    char mbuf[2 + 1];
    char dbuf[2 + 1];
    char hbuf[2 + 1];
    char ibuf[2 + 1];
    char sbuf[2 + 1];
    time_t curtime;
    struct tm * tm_ptr;
    time(&curtime);
    tm_ptr = localtime(&curtime);

    sprintf(ybuf, "%d", tm_ptr->tm_year + 1900);

    if (tm_ptr->tm_mon + 1 >= 10)
    {
        sprintf(mbuf, "%d", tm_ptr->tm_mon + 1);
    }
    else
    {
        sprintf(mbuf, "0%d", tm_ptr->tm_mon + 1);
    }

    if (tm_ptr->tm_mday >= 10)
    {
        sprintf(dbuf, "%d", tm_ptr->tm_mday);
    }
    else
    {
        sprintf(dbuf, "0%d", tm_ptr->tm_mday);
    }

    if (tm_ptr->tm_hour >= 10)
    {
        sprintf(hbuf, "%d", tm_ptr->tm_hour);
    }
    else
    {
        sprintf(hbuf, "0%d", tm_ptr->tm_hour);
    }

    if (tm_ptr->tm_min >= 10)
    {
        sprintf(ibuf, "%d", tm_ptr->tm_min);
    }
    else
    {
        sprintf(ibuf, "0%d", tm_ptr->tm_min);
    }

    if (tm_ptr->tm_sec >= 10)
    {
        sprintf(sbuf, "%d", tm_ptr->tm_sec);
    }
    else
    {
        sprintf(sbuf, "0%d", tm_ptr->tm_sec);
    }

    sprintf(buffer, format, ybuf, mbuf, dbuf, hbuf, ibuf, sbuf);

    return buffer;
}

char* get_date_time_ex(const char* format, char* buffer)
{
    char ybuf[4 + 1];
    char mbuf[2 + 1];
    char dbuf[2 + 1];
    char hbuf[2 + 1];
    char ibuf[2 + 1];
    char sbuf[2 + 1];
    struct tm * tm_ptr;
    struct timeval curtime;
    gettimeofday(&curtime, null);
    tm_ptr = localtime(&curtime.tv_sec);

    sprintf(ybuf, "%d", tm_ptr->tm_year + 1900);

    if (tm_ptr->tm_mon + 1 >= 10)
    {
        sprintf(mbuf, "%d", tm_ptr->tm_mon + 1);
    }
    else
    {
        sprintf(mbuf, "0%d", tm_ptr->tm_mon + 1);
    }

    if (tm_ptr->tm_mday >= 10)
    {
        sprintf(dbuf, "%d", tm_ptr->tm_mday);
    }
    else
    {
        sprintf(dbuf, "0%d", tm_ptr->tm_mday);
    }

    if (tm_ptr->tm_hour >= 10)
    {
        sprintf(hbuf, "%d", tm_ptr->tm_hour);
    }
    else
    {
        sprintf(hbuf, "0%d", tm_ptr->tm_hour);
    }

    if (tm_ptr->tm_min >= 10)
    {
        sprintf(ibuf, "%d", tm_ptr->tm_min);
    }
    else
    {
        sprintf(ibuf, "0%d", tm_ptr->tm_min);
    }

    if (tm_ptr->tm_sec >= 10)
    {
        sprintf(sbuf, "%d", tm_ptr->tm_sec);
    }
    else
    {
        sprintf(sbuf, "0%d", tm_ptr->tm_sec);
    }

    sprintf(buffer, format, ybuf, mbuf, dbuf, hbuf, ibuf, sbuf, curtime.tv_usec
            / 1000);

    return buffer;
}

char* fmt_date(const TIME_TYPE* _time_, const char* format, char* buffer)
{
    if (_time_ == null)
    {
        return null;
    }
    else
    {
        char ybuf[4 + 1];
        char mbuf[2 + 1];
        char dbuf[2 + 1];
        struct tm * tm_ptr;

        tm_ptr = localtime(&_time_->tv_sec);

        sprintf(ybuf, "%d", tm_ptr->tm_year + 1900);

        if (tm_ptr->tm_mon + 1 >= 10)
        {
            sprintf(mbuf, "%d", tm_ptr->tm_mon + 1);
        }
        else
        {
            sprintf(mbuf, "0%d", tm_ptr->tm_mon + 1);
        }

        if (tm_ptr->tm_mday >= 10)
        {
            sprintf(dbuf, "%d", tm_ptr->tm_mday);
        }
        else
        {
            sprintf(dbuf, "0%d", tm_ptr->tm_mday);
        }

        sprintf(buffer, format, ybuf, mbuf, dbuf);

        return buffer;
    }
}

char* fmt_time(const TIME_TYPE* _time_, const char* format, char* buffer)
{
    if (_time_ == null)
    {
        return null;
    }
    else
    {
        char hbuf[2 + 1];
        char ibuf[2 + 1];
        char sbuf[2 + 1];
        struct tm * tm_ptr;

        tm_ptr = localtime(&_time_->tv_sec);

        if (tm_ptr->tm_hour >= 10)
        {
            sprintf(hbuf, "%d", tm_ptr->tm_hour);
        }
        else
        {
            sprintf(hbuf, "0%d", tm_ptr->tm_hour);
        }

        if (tm_ptr->tm_min >= 10)
        {
            sprintf(ibuf, "%d", tm_ptr->tm_min);
        }
        else
        {
            sprintf(ibuf, "0%d", tm_ptr->tm_min);
        }

        if (tm_ptr->tm_sec >= 10)
        {
            sprintf(sbuf, "%d", tm_ptr->tm_sec);
        }
        else
        {
            sprintf(sbuf, "0%d", tm_ptr->tm_sec);
        }

        sprintf(buffer, format, hbuf, ibuf, sbuf);

        return buffer;
    }
}

char* fmt_time_ex(const TIME_TYPE* _time_, const char* format, char* buffer)
{
    if (_time_ == null)
    {
        return null;
    }
    else
    {
        char hbuf[2 + 1];
        char ibuf[2 + 1];
        char sbuf[2 + 1];
        struct tm * tm_ptr;

        tm_ptr = localtime(&_time_->tv_sec);

        if (tm_ptr->tm_hour >= 10)
        {
            sprintf(hbuf, "%d", tm_ptr->tm_hour);
        }
        else
        {
            sprintf(hbuf, "0%d", tm_ptr->tm_hour);
        }

        if (tm_ptr->tm_min >= 10)
        {
            sprintf(ibuf, "%d", tm_ptr->tm_min);
        }
        else
        {
            sprintf(ibuf, "0%d", tm_ptr->tm_min);
        }

        if (tm_ptr->tm_sec >= 10)
        {
            sprintf(sbuf, "%d", tm_ptr->tm_sec);
        }
        else
        {
            sprintf(sbuf, "0%d", tm_ptr->tm_sec);
        }

        sprintf(buffer, format, hbuf, ibuf, sbuf, _time_->tv_usec / 1000);

        return buffer;
    }
}

char* fmt_date_time(const TIME_TYPE* _time_, const char* format, char* buffer)
{
    if (_time_ == null)
    {
        return null;
    }
    else
    {
        char ybuf[4 + 1];
        char mbuf[2 + 1];
        char dbuf[2 + 1];
        char hbuf[2 + 1];
        char ibuf[2 + 1];
        char sbuf[2 + 1];
        struct tm * tm_ptr;

        tm_ptr = localtime(&_time_->tv_sec);

        sprintf(ybuf, "%d", tm_ptr->tm_year + 1900);

        if (tm_ptr->tm_mon + 1 >= 10)
        {
            sprintf(mbuf, "%d", tm_ptr->tm_mon + 1);
        }
        else
        {
            sprintf(mbuf, "0%d", tm_ptr->tm_mon + 1);
        }

        if (tm_ptr->tm_mday >= 10)
        {
            sprintf(dbuf, "%d", tm_ptr->tm_mday);
        }
        else
        {
            sprintf(dbuf, "0%d", tm_ptr->tm_mday);
        }

        if (tm_ptr->tm_hour >= 10)
        {
            sprintf(hbuf, "%d", tm_ptr->tm_hour);
        }
        else
        {
            sprintf(hbuf, "0%d", tm_ptr->tm_hour);
        }

        if (tm_ptr->tm_min >= 10)
        {
            sprintf(ibuf, "%d", tm_ptr->tm_min);
        }
        else
        {
            sprintf(ibuf, "0%d", tm_ptr->tm_min);
        }

        if (tm_ptr->tm_sec >= 10)
        {
            sprintf(sbuf, "%d", tm_ptr->tm_sec);
        }
        else
        {
            sprintf(sbuf, "0%d", tm_ptr->tm_sec);
        }

        sprintf(buffer, format, ybuf, mbuf, dbuf, hbuf, ibuf, sbuf);

        return buffer;
    }
}

char* fmt_date_time_ex(const TIME_TYPE* _time_, const char* format, char* buffer)
{
    if (_time_ == null)
    {
        return null;
    }
    else
    {
        char ybuf[4 + 1];
        char mbuf[2 + 1];
        char dbuf[2 + 1];
        char hbuf[2 + 1];
        char ibuf[2 + 1];
        char sbuf[2 + 1];
        struct tm * tm_ptr;

        tm_ptr = localtime(&_time_->tv_sec);

        sprintf(ybuf, "%d", tm_ptr->tm_year + 1900);

        if (tm_ptr->tm_mon + 1 >= 10)
        {
            sprintf(mbuf, "%d", tm_ptr->tm_mon + 1);
        }
        else
        {
            sprintf(mbuf, "0%d", tm_ptr->tm_mon + 1);
        }

        if (tm_ptr->tm_mday >= 10)
        {
            sprintf(dbuf, "%d", tm_ptr->tm_mday);
        }
        else
        {
            sprintf(dbuf, "0%d", tm_ptr->tm_mday);
        }

        if (tm_ptr->tm_hour >= 10)
        {
            sprintf(hbuf, "%d", tm_ptr->tm_hour);
        }
        else
        {
            sprintf(hbuf, "0%d", tm_ptr->tm_hour);
        }

        if (tm_ptr->tm_min >= 10)
        {
            sprintf(ibuf, "%d", tm_ptr->tm_min);
        }
        else
        {
            sprintf(ibuf, "0%d", tm_ptr->tm_min);
        }

        if (tm_ptr->tm_sec >= 10)
        {
            sprintf(sbuf, "%d", tm_ptr->tm_sec);
        }
        else
        {
            sprintf(sbuf, "0%d", tm_ptr->tm_sec);
        }

        sprintf(buffer, format, ybuf, mbuf, dbuf, hbuf, ibuf, sbuf,
                _time_->tv_usec / 1000);

        return buffer;
    }
}

time_type get_now( )
{
    time_t t1;
    time(&t1);
    return t1;
}

void print_time( )
{
    char dt_now[32];
    static int s_cnt = 0;
    get_date_time_ex(DATETIME_FORMAT_EX_EN,dt_now);
    printf("%d:\t%s\n",s_cnt++, dt_now);
}

char* fmt_time_t(const time_t _time_, const char* format, char* buffer)
{
    if (_time_ == 0)
    {
        buffer[0] = '\0';
        return buffer;
    }

    char ybuf[4 + 1];
    char mbuf[2 + 1];
    char dbuf[2 + 1];
    char hbuf[2 + 1];
    char ibuf[2 + 1];
    char sbuf[2 + 1];
    struct tm * tm_ptr;

    tm_ptr = localtime(&_time_);

    sprintf(ybuf, "%d", tm_ptr->tm_year + 1900);

    if (tm_ptr->tm_mon + 1 >= 10)
    {
        sprintf(mbuf, "%d", tm_ptr->tm_mon + 1);
    }
    else
    {
        sprintf(mbuf, "0%d", tm_ptr->tm_mon + 1);
    }

    if (tm_ptr->tm_mday >= 10)
    {
        sprintf(dbuf, "%d", tm_ptr->tm_mday);
    }
    else
    {
        sprintf(dbuf, "0%d", tm_ptr->tm_mday);
    }

    if (tm_ptr->tm_hour >= 10)
    {
        sprintf(hbuf, "%d", tm_ptr->tm_hour);
    }
    else
    {
        sprintf(hbuf, "0%d", tm_ptr->tm_hour);
    }

    if (tm_ptr->tm_min >= 10)
    {
        sprintf(ibuf, "%d", tm_ptr->tm_min);
    }
    else
    {
        sprintf(ibuf, "0%d", tm_ptr->tm_min);
    }

    if (tm_ptr->tm_sec >= 10)
    {
        sprintf(sbuf, "%d", tm_ptr->tm_sec);
    }
    else
    {
        sprintf(sbuf, "0%d", tm_ptr->tm_sec);
    }

    sprintf(buffer, format, ybuf, mbuf, dbuf, hbuf, ibuf, sbuf);

    return buffer;
}

//得到当前日期的前一天  ( day 格式 20110308 )
uint32 get_previous_day(uint32 date)
{
    int year,month,day,leap;
    year = date / 10000;
    month = date % 10000 / 100;
    day = date % 1000000 % 100;
	if(month==3)
	{
	    if(year%400==0)
		    leap=1;
	    else if(year%100==0)
		    leap=0;
		else if(year%4==0)
		    leap=1;
		else
		    leap=0;
		if(leap==1)
		{
		    if(day==1)
			{
			    day=29;
				month=2;
			}
			else
			    day = day-1;
		}
		if(leap==0)
		{
		    if(day==1)
			{
			    day=28;
				month=2;
		    }
			else
			    day = day-1;
		}
	}
	else if(month==1)
	{
	    if(day==1)
		{
		    day=31;
			month=12;
			year=year-1;
		}
		else
		    day = day-1;
	}
	else if(month==4||month==6||month==9||month==11)
	{
	    if(day==1)
		{
		    day=31;
			month = month-1;
	    }
		else
		    day = day-1;
	}
	else
	{
	    if(day==1)
		{
		    day=30;
			month = month-1;
		}
		else
		    day = day-1;
	}
	return (year*10000 + month*100 + day);
}



/////////////////// timer with SIGUSR1 //////////////////
timer_t ts_timer_init(void (*timer_handle)(int nouse))
{
    struct sigevent evp;
    timer_t timer;
    int ret;
    memset (&evp, 0, sizeof (evp));
    evp.sigev_value.sival_ptr = &timer;
    evp.sigev_notify = SIGEV_SIGNAL;
    evp.sigev_signo = SIGUSR1;

    signal(SIGUSR1, timer_handle);

    ret = timer_create(CLOCK_REALTIME, &evp, &timer);
    if( ret != 0 )
    {
        return (timer_t)-1;
    }
    return timer;
}


int ts_timer_set( timer_t  timer, int timeout,int isNsec)
{
    struct itimerspec ts;

    if(1 == isNsec)
   	{
        ts.it_interval.tv_sec = 0;
        ts.it_interval.tv_nsec = timeout;
        ts.it_value.tv_sec = 0;
        ts.it_value.tv_nsec = timeout;
   	}
    else
    {
        ts.it_interval.tv_sec = timeout;
        ts.it_interval.tv_nsec = 0;
        ts.it_value.tv_sec = timeout;
        ts.it_value.tv_nsec = 0;
    }

    return timer_settime(timer, 0, &ts, NULL);
}


void ts_timer_del(timer_t  timer)
{
    timer_delete (timer);
}


void ts_sleep(int timeout,int isSec)
{
    struct timeval t_timeval;
    if(1 == isSec)
    {
        t_timeval.tv_sec = timeout;
        t_timeval.tv_usec = 0;
    }
    else
    {
        t_timeval.tv_sec = 0;
        t_timeval.tv_usec = timeout;
    }
    select(0, NULL, NULL, NULL, &t_timeval);
}

//date参数格式: 20160131，返回格式一样
//offset参数: 大于0，未来天；小于0；之前的天
int ts_offset_date(int date, int offset)
{
    int y = date / 10000;
    int m = (date - y * 10000) / 100;
    int d = date % 100;

    struct tm t;
    t.tm_sec  = 0;
    t.tm_min  = 0;
    t.tm_hour = 0;
    t.tm_mday = d + offset;
    t.tm_mon  = m - 1;
    t.tm_year = y - 1900;
    //t.tm_wday ignored, see mktime(3)
    //t.tm_yday ignored, see mktime(3)
    t.tm_isdst = 0;
    mktime(&t);
    return (t.tm_year + 1900) * 10000 + (t.tm_mon + 1) * 100 + t.tm_mday;
}

