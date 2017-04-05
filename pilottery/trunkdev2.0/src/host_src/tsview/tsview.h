#ifndef _TAISHAN_H__
#define _TAISHAN_H__

#include <locale.h>
#include <stdio.h>
#include <malloc.h>
#include <string.h>
#include <ncurses.h>
#include <panel.h>
#include <menu.h>
#include <form.h>

#include "global.h"

#define NLINES LINES
#define NCOLS COLS

//针对整个屏幕
#define MAIN_WIN_LINE_BEGIN 4
#define MAIN_WIN_LINES NLINES-5
#define MAIN_WIN_COLS NCOLS

//在main窗口内部
#define MAIN_WIN_TOP_LINE 0
#define MAIN_WIN_BUTTOM_LINE MAIN_WIN_LINES-3
#define MAIN_WIN_STATUS_LINE MAIN_WIN_LINES-2

#define MAIN_WIN_MAX_LINE   40

typedef enum _WINDOW_TYPE
{
    WINDOW_EMPTY = 0,
    WINDOW_SYSDB,
    WINDOW_NCPC,
    WINDOW_TMS,
    WINDOW_GL,
    WINDOW_GL_ISSUE,
    WINDOW_GL_RK,
    WINDOW_TFE,
    WINDOW_BQUEUES,
    WINDOW_TOOLBOX,
    WINDOW_HELP
}WINDOW_TYPE;

#define MAX_WIN WINDOW_HELP


//对外函数指针接口
typedef int (*init_win_func)( WINDOW_TYPE win_type );
typedef int (*close_win_func)( WINDOW_TYPE win_type );
typedef int (*draw_win_func)( WINDOW_TYPE win_type );
typedef int (*handle_win_func)( WINDOW_TYPE win_type, int ch );
typedef int (*command_win_func)( WINDOW_TYPE win_type, char *cmdstr, int length );
typedef int (*refresh_win_func)( WINDOW_TYPE win_type );


typedef struct _window_struct
{
    bool    created;
    char    name[32];
    char    key_name[32];
    WINDOW *win_ptr;
    PANEL  *panel_ptr;

    init_win_func    init_win;
    close_win_func   close_win;
    draw_win_func    draw_win;
    handle_win_func  handle_win;
    command_win_func command_win;
    refresh_win_func refresh_win;
}window_struct;


//for export interface-------------------------------------------------------------

//输出当前模块名
void print_tbl_module_name(WINDOW_TYPE win_type);

//输出统计信息
void print_tbl_statistic_info(WINDOW_TYPE win_type, char *str);

//输出分页的信息
void print_tbl_page_info(WINDOW_TYPE win_type, char *str);

//输出table header
void print_tbl_header(WINDOW_TYPE win_type, char *str);

//清除窗口的内容，保持边框
void clear_tbl_win(WINDOW_TYPE win_type);

//刷新window的内容
void refresh_tbl_win(WINDOW_TYPE win_type);

//输出一个字符串
void print_tbl_str(WINDOW_TYPE win_type, int starty, int startx, char *string);

//颜色反转输出一个字符串
void print_tbl_str_reverse(WINDOW_TYPE win_type, int starty, int startx, char *string);

//输出一个字符串占整行 覆盖本行内的所有其他字符
void print_tbl_line_str(WINDOW_TYPE win_type, int starty, int startx, const char *string);

//颜色反转输出一个字符串占整行  覆盖本行内的所有其他字符
void print_tbl_line_str_reverse(WINDOW_TYPE win_type, int starty, int startx, char *string);
void print_tbl_line_str_reverseEx(WINDOW_TYPE win_type, int starty, int startx, char *string);
//输出一个居中的字符串
void print_tbl_str_middle(WINDOW_TYPE win_type, int starty, int startx, char *string);

//根据一个页码得到，校验页范围， 得到正确的页码，也得到页的起始索引
/*
    参数说明:  page  你想显示的第几页 (如果超过范围，会在函数返回时，返回正确的页码)
               sumPages 返回总的页数
               sumCount 数组总条数
               pagesize 每页显示的行数

    返回值:    返回当前页显示数据的起始 数组的索引
*/
int getStartIndexByPage(int *page, int *sumPages, int sumCount, int pagesize);

// reverse ->  0 normal  1 reverse(颜色反转)
void print_str(WINDOW *win, int starty, int startx, const char *string, chtype color, int reverse);

void print_str_middle(WINDOW *win, int starty, int startx, int width, const char *string, chtype color, int reverse);


//输出错误信息
//void logit(char *logdata);
//void logit(fmt, varlist...);
#define logit(fmt, varlist...) \
	do { \
        char log_buf[4096] = {0}; \
        sprintf(log_buf, ""#fmt"", ##varlist); \
        print_str(NULL, NLINES-1, 1, "                                                                             ", COLOR_PAIR(3), 0); \
        print_str(NULL, NLINES-1, 1, "-> ", COLOR_PAIR(3), 0); \
        print_str(NULL, NLINES-1, 4, log_buf, A_BOLD|COLOR_PAIR(3), 0); \
        set_curse(NLINES-1, 0); \
    } while (0)

//设置光标位置
void set_curse(int starty, int startx);


//写文件log
#define gkview_log(fmt, varlist...) \
    do { \
        char dt_now[64] = {0}; \
        get_date_time_ex(DATETIME_FORMAT_EX_EN, dt_now); \
        FILE* fd = fopen("./aaa.log", "a+"); \
        fprintf(fd, "[%s]-> "#fmt"\n", dt_now, ##varlist); \
        fflush(fd); \
        fclose(fd); \
    } while (0)


//需要实现的接口---------------------------------------------------------------------

int init_win_ncpc( WINDOW_TYPE win_type );
int close_win_ncpc( WINDOW_TYPE win_type );
int draw_win_ncpc( WINDOW_TYPE win_type );
int handle_win_ncpc( WINDOW_TYPE win_type, int ch );
int command_win_ncpc( WINDOW_TYPE win_type, char *cmdstr, int length );
int refresh_win_ncpc( WINDOW_TYPE win_type );

int init_win_tms( WINDOW_TYPE win_type );
int close_win_tms( WINDOW_TYPE win_type );
int draw_win_tms( WINDOW_TYPE win_type );
int handle_win_tms( WINDOW_TYPE win_type, int ch );
int command_win_tms( WINDOW_TYPE win_type, char *cmdstr, int length );
int refresh_win_tms( WINDOW_TYPE win_type );

int init_win_gl( WINDOW_TYPE win_type );
int close_win_gl( WINDOW_TYPE win_type );
int draw_win_gl( WINDOW_TYPE win_type );
int handle_win_gl( WINDOW_TYPE win_type, int ch );
int command_win_gl( WINDOW_TYPE win_type, char *cmdstr, int length );
int refresh_win_gl( WINDOW_TYPE win_type );

int init_win_gl_issue( WINDOW_TYPE win_type );
int close_win_gl_issue( WINDOW_TYPE win_type );
int draw_win_gl_issue( WINDOW_TYPE win_type );
int handle_win_gl_issue( WINDOW_TYPE win_type, int ch );
int command_win_gl_issue( WINDOW_TYPE win_type, char *cmdstr, int length );
int refresh_win_gl_issue( WINDOW_TYPE win_type );

int init_win_gl_rk( WINDOW_TYPE win_type );
int close_win_gl_rk( WINDOW_TYPE win_type );
int draw_win_gl_rk( WINDOW_TYPE win_type );
int handle_win_gl_rk( WINDOW_TYPE win_type, int ch );
int command_win_gl_rk( WINDOW_TYPE win_type, char *cmdstr, int length );
int refresh_win_gl_rk( WINDOW_TYPE win_type );

int init_win_tf( WINDOW_TYPE win_type );
int close_win_tf( WINDOW_TYPE win_type );
int draw_win_tf( WINDOW_TYPE win_type );
int handle_win_tf( WINDOW_TYPE win_type, int ch );
int command_win_tf( WINDOW_TYPE win_type, char *cmdstr, int length );
int refresh_win_tf( WINDOW_TYPE win_type );

int init_win_sysdb( WINDOW_TYPE win_type );
int close_win_sysdb( WINDOW_TYPE win_type );
int draw_win_sysdb( WINDOW_TYPE win_type );
int handle_win_sysdb( WINDOW_TYPE win_type, int ch );
int command_win_sysdb( WINDOW_TYPE win_type, char *cmdstr, int length );
int refresh_win_sysdb( WINDOW_TYPE win_type );

int init_win_bqueues( WINDOW_TYPE win_type );
int close_win_bqueues( WINDOW_TYPE win_type );
int draw_win_bqueues( WINDOW_TYPE win_type );
int handle_win_bqueues( WINDOW_TYPE win_type, int ch );
int command_win_bqueues( WINDOW_TYPE win_type, char *cmdstr, int length );
int refresh_win_bqueues( WINDOW_TYPE win_type );

int init_win_toolbox( WINDOW_TYPE win_type );
int close_win_toolbox( WINDOW_TYPE win_type );
int draw_win_toolbox( WINDOW_TYPE win_type );
int handle_win_toolbox( WINDOW_TYPE win_type, int ch );
int command_win_toolbox( WINDOW_TYPE win_type, char *cmdstr, int length );
int refresh_win_toolbox( WINDOW_TYPE win_type );

int init_win_help( WINDOW_TYPE win_type );
int close_win_help( WINDOW_TYPE win_type );
int draw_win_help( WINDOW_TYPE win_type );
int handle_win_help( WINDOW_TYPE win_type, int ch );
int command_win_help( WINDOW_TYPE win_type, char *cmdstr, int length );
int refresh_win_help( WINDOW_TYPE win_type );



//--------------------------------------------------------------------
char *ts_getDateFormat(time_t tt,char *now);







//输入框
typedef struct _input_field
{
    bool used;

    char field_name[128];

    //输入框的宽度
    int width;
    //输入框的起始列
    int cols;

    //0 只容许输入数字   1 容许 数字 和 字母
    int flag;

    char field_value[256];
}input_field;

//对话框结构(当前只支持一个选择条件)
typedef struct _dialog_struct
{
    bool used;

    char title[64];

    //输入框
    FIELD *field[8];
    input_field inputFieldArray[8];

    //是否确认 1 confirm  0 cancel
    int confirm;
}dialog_struct;


void dialog_draw(dialog_struct * ptr);

#endif  //_TAISHAN_H__

