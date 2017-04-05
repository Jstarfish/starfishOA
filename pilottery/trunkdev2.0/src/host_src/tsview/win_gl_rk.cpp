#include "tsview.h"
#include "gl_inf.h"



bool gl_rk_init_flag = false;

#define rk_win_top_line       4
#define gl_rk_win_buttom_line    (MAIN_WIN_STATUS_LINE-2)

#define rk_win_lins  (gl_rk_win_buttom_line-rk_win_top_line+1)



int init_win_gl_rk(WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return true;
}

int close_win_gl_rk( WINDOW_TYPE win_type )
{
    ts_notused(win_type);
    return true;
}




void rk_firstpage(WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return;
}


int draw_win_gl_rk( WINDOW_TYPE win_type )
{
    ts_notused(win_type);
    return true;
}

//-------自定义函数-----------------------------------------------------------

int gl_rk_handle_key_left( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return true;
}

int gl_rk_handle_key_right( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return true;
}


int gl_rk_handle_key_up( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return true;
}

int gl_rk_handle_key_down( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return true;
}

int gl_rk_handle_key_enter( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return true;
}

int gl_rk_handle_key_escape( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return true;
}

int gl_rk_handle_key_i(WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return true;
}

int gl_rk_handle_key_h(WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    //输出本窗口的帮助信息，再按一次'h'消失
    return true;
}

int handle_win_gl_rk( WINDOW_TYPE win_type, int ch )
{
    ts_notused(win_type);
    ts_notused(ch);
    return true;
}

int command_win_gl_rk( WINDOW_TYPE win_type, char *cmdstr, int length)
{
    ts_notused(win_type);
    ts_notused(cmdstr);
    ts_notused(length);    
    return true;
}

int refresh_win_gl_rk( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return true;
}


