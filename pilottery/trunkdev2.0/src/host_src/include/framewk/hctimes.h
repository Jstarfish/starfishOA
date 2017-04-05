#ifndef HCTIMES_H_INCLUDED
#define HCTIMES_H_INCLUDED


/*==============================================================================
 ģ������



 ģ�鹦��:



 ģ������:



 �༰����:



 �޸ļ�¼��
 +++ �޸�����                             ��ǰ�汾                                 �޸���Ա                                �޸�����
 ++| ----------      ------------      ------------     -------------
 ++| 2009.09.25                        Tommy, Forrest

 ==============================================================================*/

/*==============================================================================
 * ȫ�ֳ�����ֵ�궨�壬��������м�Ҫ˵��
 * Global Constant & Macro Definitions and Brief Description
 =============================================================================*/

extern const char DATE_FORMAT_EN[32];

extern const char DATE_FORMAT_CN[32];

extern const char TIME_FORMAT_EN[32];

extern const char TIME_FORMAT_CN[32];

extern const char TIME_FORMAT_EX_EN[32];

extern const char TIME_FORMAT_EX_CN[32];

extern const char DATETIME_FORMAT_EN[32];

extern const char DATETIME_FORMAT_NAME[32];

extern const char DATETIME_FORMAT_CN[32];

extern const char DATETIME_FORMAT_EX_EN[32];

extern const char DATETIME_FORMAT_EX_CN[32];

/*==============================================================================
 * ���Ͷ���(struct��enum)��,�������Ҫ���ݽṹ��Ҫ��ϸ˵��
 * Type Declarations(struct,enum etc.) and Brief Description
 * If it's Significant,Detailed Description Should Be Present
 =============================================================================*/

typedef struct timeval TIME_TYPE;

enum TIME_ZONE
{
    TZONE_EN = 0,
    TZONE_CN = 1
};

extern enum TIME_ZONE TIME_ZONE_MODE;

/*==============================================================================
 * �����Ժ궨�壬��������м�Ҫ˵��
 * Functional Macro Definitions and Brief Description
 =============================================================================*/

/*==============================================================================
 * �ⲿ�������壬��������м�Ҫ˵��
 * Functions Definitions and Brief Description
 =============================================================================*/

long get_when();

long get_whenMillisecond();

void get_when_ex(
        TIME_TYPE* time);

char* cur_date(
        char* buffer);

char* cur_time(
        char* buffer);

char* cur_time_ex(
        char* buffer);

char* cur_date_time(
        char* buffer);

char* cur_date_time_ex(
        char* buffer);

char* get_date(
        const char* format,
        char* buffer);

char* get_time(
        const char* format,
        char* buffer);

char* get_time_ex(
        const char* format,
        char* buffer);

char* get_date_time(
        const char* format,
        char* buffer);

char* get_date_time_ex(
        const char* format,
        char* buffer);

char* fmt_date(
        const TIME_TYPE* _time_,
        const char* format,
        char* buffer);

char* fmt_time(
        const TIME_TYPE* _time_,
        const char* format,
        char* buffer);

char* fmt_time_ex(
        const TIME_TYPE* _time_,
        const char* format,
        char* buffer);

char* fmt_date_time(
        const TIME_TYPE* _time_,
        const char* format,
        char* buffer);

char* fmt_date_time_ex(
        const TIME_TYPE* _time_,
        const char* format,
        char* buffer);

time_type get_now( );


//����debugʱ�ã���ӡ����ǰ���뼶ʱ��2010-04-13 11:26:18.857
void print_time( );


char* fmt_time_t(const time_t _time_, const char* format, char* buffer);

// timer with SIGUSR1
timer_t ts_timer_init(void (*timer_handle)(int nouse));

int ts_timer_set( timer_t  timer, int timeout,int isNsec);

void ts_timer_del(timer_t  timer);

void ts_sleep(int timeout,int isSec);

//date������ʽ: 20160131�����ظ�ʽһ��
//offset����: ����0��δ���죻С��0��֮ǰ����
int ts_offset_date(int date, int offset);


/*==============================================================================
 * �����������壬��������м�Ҫ˵��
 * Static Inline Functions Definitions and Brief Description
 =============================================================================*/


#endif // HCTIMES_H_INCLUDED
