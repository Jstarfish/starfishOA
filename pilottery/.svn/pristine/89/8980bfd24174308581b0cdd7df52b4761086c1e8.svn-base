#ifndef _RNG_VIEW_H_
#define _RNG_VIEW_H_

#include <ncurses.h>

typedef enum _WINDOW_TYPE
{
    WINDOW_TITLE      = 0,
    WINDOW_INFO       = 1,
    WINDOW_BUSINESS   = 2,
    WINDOW_RUNLOG     = 3,
    WINDOW_MAX        = 4,
} WINDOW_TYPE;

typedef struct window_struct
{
    WINDOW *win_ptr;
    int     width;
    int     height;
    int     x;
    int     y;

    int (*paint)(struct window_struct *win);
} window_struct;

int create_window_struct(WINDOW_TYPE win_type);

int paint_title(window_struct *win);
int paint_info(window_struct *win);
int paint_business(window_struct *win);
int paint_runlog(window_struct *win);

int close_window_struct(WINDOW_TYPE win_type);

#endif // _RNG_VIEW_H_
