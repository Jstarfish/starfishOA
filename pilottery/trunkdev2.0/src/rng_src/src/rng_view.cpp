#include <math.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/select.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <time.h>
#include <signal.h>

#include <ncurses.h>

#include <iostream>
using namespace std;

#include "protocol.h"
#include "rng_view.h"
#include "shm_mod.h"
#include "log.h"

// pointer to the shared memory
static RNG_SHM_PTR pShm = NULL;
// managing four regions of the rng monitor screen
static window_struct win_array[WINDOW_MAX];
static bool resize_now = false;

void resize_handler(int sig)
{
    (void)sig;
    resize_now = true;
}

int create_window_struct(WINDOW_TYPE win_type)
{
    if (win_type < 0 && win_type > WINDOW_MAX) {
        log("unknown window type %d", win_type);
        return -1;
    }

    window_struct *win = &win_array[win_type];

    switch (win_type) {
    case WINDOW_TITLE:
        win->width = COLS;
        win->height = 3;
        win->x = 0;
        win->y = 0;
        win->paint = paint_title;
        win->win_ptr = newwin(win->height, win->width, win->y, win->x);
        break;
    case WINDOW_INFO:
        win->width = COLS;
        win->height = 10;
        win->x = 0;
        win->y = 3;
        win->paint = paint_info;
        win->win_ptr = newwin(win->height, win->width, win->y, win->x);
        break;
    case WINDOW_BUSINESS:
        win->width = COLS/2;
        win->height = LINES-10-3-1;
        win->x = 0;
        win->y = 13;
        win->paint = paint_business;
        win->win_ptr = newwin(win->height, win->width, win->y, win->x);
        break;
    case WINDOW_RUNLOG:
        win->width = COLS/2;
        win->height = LINES-10-3-1;
        win->x = COLS/2;
        win->y = 13;
        win->paint = paint_runlog;
        win->win_ptr = newwin(win->height, win->width, win->y, win->x);
        break;
    default:
        log("unknown window type exists %d", win_type);
        return -1;
    }

    return 0;
}

int paint_title(window_struct *win)
{
    // top line
    wattron(win->win_ptr, COLOR_PAIR(7));
    mvwhline(win->win_ptr, win->y, win->x, '-', win->width);
    wattroff(win->win_ptr, COLOR_PAIR(7));

    // title with time
    char title[120] = {0};
    char now[32] = {0};
    struct timeval tv;
    gettimeofday(&tv, NULL);
    get_date_time_format(tv.tv_sec, now);
    sprintf(title, 
            "Taishan System --- RNG Device Monitor --- Forrest Cao 2014 (%s.%06ld)",
            now, tv.tv_usec);
    int startx = (win->width - strlen(title))/2;
    wattron(win->win_ptr, COLOR_PAIR(2)|A_BOLD);
    mvwprintw(win->win_ptr, win->y+1, startx, title);
    wattroff(win->win_ptr, COLOR_PAIR(2)|A_BOLD);

    // pallete 0 1 2 3 4 5 6 7 8
    for (int i = 0; i <= 8; i++) {
        wattron(win->win_ptr, COLOR_PAIR(i)|A_BOLD);
        mvwprintw(win->win_ptr, win->y+1, win->width-18+2*i, "%d", i);
        wattroff(win->win_ptr, COLOR_PAIR(i)|A_BOLD);
    }

    // bottom line
    wattron(win->win_ptr, COLOR_PAIR(7));
    mvwhline(win->win_ptr, win->y+2, win->x, '-', win->width);
    wattroff(win->win_ptr, COLOR_PAIR(7));

    wnoutrefresh(win->win_ptr);
    return 0;
}

static void draw_window_header(window_struct *win, const char *string)
{
    char tmp[1024] = "    "; // four spaces before heading content
    strcat(tmp, string);
    for (int i = strlen(tmp); i < (win->width-2); i++) {
        strcat(tmp, " ");
    }
    wattron(win->win_ptr, COLOR_PAIR(8)|A_BOLD);
    mvwprintw(win->win_ptr, 1, 1, tmp);
    wattroff(win->win_ptr, COLOR_PAIR(8)|A_BOLD);

    // a dash line below the heading
    wattron(win->win_ptr, COLOR_PAIR(7)|A_BOLD);
    mvwhline(win->win_ptr, 2, 1, '-', win->width-2);
    wattroff(win->win_ptr, COLOR_PAIR(7)|A_BOLD);
}

int paint_info(window_struct *win)
{
    // heading
    draw_window_header(win, "Configuration Information");

    wattron(win->win_ptr, COLOR_PAIR(4));

    // local ip
    mvwprintw(win->win_ptr, 3, 1, "%-15s-> %s", "Local IP Addr", pShm->local_ip);
    // local mac
    mvwprintw(win->win_ptr, 4, 1, "%-15s-> %02x:%02x:%02x:%02x:%02x:%02x", 
              "Local MAC", pShm->local_mac[0], pShm->local_mac[1], 
              pShm->local_mac[2], pShm->local_mac[3], pShm->local_mac[4], 
              pShm->local_mac[5]);
    // remote ip
    mvwprintw(win->win_ptr, 5, 1, "%-15s-> %s", "Remote IP Addr", pShm->server_ip);
    // remote port
    mvwprintw(win->win_ptr, 6, 1, "%-15s-> %d", "Remote Port", pShm->port);
    // device id
    mvwprintw(win->win_ptr, 7, 1, "%-15s-> %d", "Device ID", pShm->device_id);
    // debug info
    wmove(win->win_ptr, 8, 1);
    wclrtoeol(win->win_ptr);
    mvwprintw(win->win_ptr, 8, 1, "%-15s-> %s", "Debug Info", pShm->debug_info);

    // start time
    mvwprintw(win->win_ptr, 3, 40, "%-20s-> %s", "RNG Start Time", pShm->start_time);
    // last connect time
    mvwprintw(win->win_ptr, 4, 40, "%-20s-> %s", "Last Conn Time", pShm->last_connect_time);
    // last disconnect time
    mvwprintw(win->win_ptr, 5, 40, "%-20s-> %s", "Last Disconn Time", pShm->last_disconnect_time);
    // connect interval
    mvwprintw(win->win_ptr, 6, 40, "%-20s-> %d", "Connect Interval(s)", pShm->connect_interval);
    // device type
    mvwprintw(win->win_ptr, 7, 40, "%-20s-> %s", "Device Type", pShm->device_type);

    // last hb sent
    wmove(win->win_ptr, 3, 85);
    wclrtoeol(win->win_ptr);
    mvwprintw(win->win_ptr, 3, 85, "%-13s-> %ld", "Last HB Sent", pShm->last_hb_sent);
    // last hb recv
    wmove(win->win_ptr, 4, 85);
    wclrtoeol(win->win_ptr);
    mvwprintw(win->win_ptr, 4, 85, "%-13s-> %ld", "Last HB Recv", pShm->last_hb_recv);
    // heartbeat interval
    mvwprintw(win->win_ptr, 5, 85, "%-13s-> %d", "HB Interval(s)", pShm->heartbeat_interval);
    // heartbeat timeout
    mvwprintw(win->win_ptr, 6, 85, "%-13s-> %d", "HB Timeout(s)", pShm->heartbeat_timeout);

    wattroff(win->win_ptr, COLOR_PAIR(4));

    // work status
    switch (pShm->work_status) {
    case RNG_UNCONNECTED:
        wattron(win->win_ptr, COLOR_PAIR(3)|A_BOLD|A_REVERSE);
        mvwprintw(win->win_ptr, 3, win->width-24, "                    ");
        mvwprintw(win->win_ptr, 4, win->width-24, "                    ");
        mvwprintw(win->win_ptr, 5, win->width-24, "    UNCONNECTED     ");
        mvwprintw(win->win_ptr, 6, win->width-24, "                    ");
        mvwprintw(win->win_ptr, 7, win->width-24, "                    ");
        wattroff(win->win_ptr, COLOR_PAIR(3)|A_BOLD|A_REVERSE);
        break;
    case RNG_CONNECTED:
        wattron(win->win_ptr, COLOR_PAIR(2)|A_BOLD|A_REVERSE);
        mvwprintw(win->win_ptr, 3, win->width-24, "                    ");
        mvwprintw(win->win_ptr, 4, win->width-24, "                    ");
        mvwprintw(win->win_ptr, 5, win->width-24, "     CONNECTED      ");
        mvwprintw(win->win_ptr, 6, win->width-24, "                    ");
        mvwprintw(win->win_ptr, 7, win->width-24, "                    ");
        wattroff(win->win_ptr, COLOR_PAIR(2)|A_BOLD|A_REVERSE);
        break;
    case RNG_AUTHENTICATED:
        wattron(win->win_ptr, COLOR_PAIR(4)|A_BOLD|A_REVERSE);
        mvwprintw(win->win_ptr, 3, win->width-24, "                    ");
        mvwprintw(win->win_ptr, 4, win->width-24, "                    ");
        mvwprintw(win->win_ptr, 5, win->width-24, "   AUTHENTICATED    ");
        mvwprintw(win->win_ptr, 6, win->width-24, "                    ");
        mvwprintw(win->win_ptr, 7, win->width-24, "                    ");
        wattroff(win->win_ptr, COLOR_PAIR(4)|A_BOLD|A_REVERSE);
        break;
    }

    // border, put here so it will not be cleared by call to 'wclrtoeol'
    box(win->win_ptr, 0, 0);

    wnoutrefresh(win->win_ptr);
    return 0;
}

int paint_business(window_struct *win)
{
    box(win->win_ptr, 0, 0);
    draw_window_header(win, "Business Output Window");

    wattron(win->win_ptr, COLOR_PAIR(4));

    char line[1024];
    int log_index;
    for (int i = 0; i < win->height-4; i++) {

        log_index = pShm->business_idx-1-i; // idx point to next of last elem
        while (log_index < 0) log_index += LOG_NUMBER;
        log_index %= LOG_NUMBER;
    
        memset(line, 0, sizeof(line));
        snprintf(line, win->width-3, "%02d> %s", log_index, 
                 pShm->business_info_array[log_index]);
        mvwhline(win->win_ptr, win->height-2-i, 1, ' ', win->width-2);
        mvwprintw(win->win_ptr, win->height-2-i, 1, line);
    }

    wattroff(win->win_ptr, COLOR_PAIR(4));

    wnoutrefresh(win->win_ptr);
    return 0;
}

int paint_runlog(window_struct *win)
{
    box(win->win_ptr, 0, 0);
    draw_window_header(win, "Run Log Output Window");

    wattron(win->win_ptr, COLOR_PAIR(4));

    char line[1024] = {0};
    int log_index;
    for (int i = 0; i < win->height-4; i++) {

        log_index = pShm->run_idx-1-i; // idx point to next of last elem
        while (log_index < 0) log_index += LOG_NUMBER;
        log_index %= LOG_NUMBER;
    
        memset(line, 0, sizeof(line));
        snprintf(line, win->width-3, "%02d> %s", log_index, 
                 pShm->run_info_array[log_index]);
        mvwhline(win->win_ptr, win->height-2-i, 1, ' ', win->width-2);
        mvwprintw(win->win_ptr, win->height-2-i, 1, line);
    }

    wattroff(win->win_ptr, COLOR_PAIR(4));

    wnoutrefresh(win->win_ptr);
    return 0;
}

int close_window_struct(WINDOW_TYPE win_type)
{
    delwin(win_array[win_type].win_ptr);
    return 0;
}


int main(void)
{
    int ret, ch;
    struct timeval tv;
    fd_set readfds;

    signal(SIGPIPE, SIG_IGN);
    signal(SIGWINCH, resize_handler);

    ret = shm_init();
    if (ret < 0) {
        log("shm_init() failed");
        return -1;
    }

    pShm = get_shm_ptr();

    initscr();
    start_color();
    cbreak();
    noecho();
    keypad(stdscr, true);

    init_pair(1, COLOR_BLUE, COLOR_BLACK);
    init_pair(2, COLOR_YELLOW, COLOR_BLACK);
    init_pair(3, COLOR_RED, COLOR_BLACK);
    init_pair(4, COLOR_GREEN, COLOR_BLACK);
    init_pair(5, COLOR_MAGENTA, COLOR_BLACK);
    init_pair(6, COLOR_CYAN, COLOR_BLACK);
    init_pair(7, COLOR_WHITE, COLOR_BLACK);
    init_pair(8, COLOR_WHITE, COLOR_BLUE);

    //init_pair(9, COLOR_RED, COLOR_WHITE);
    //init_pair(10, COLOR_YELLOW, COLOR_BLACK);
    //init_pair(11, COLOR_GREEN, COLOR_WHITE);

    create_window_struct(WINDOW_TITLE);
    create_window_struct(WINDOW_INFO);
    create_window_struct(WINDOW_BUSINESS);
    create_window_struct(WINDOW_RUNLOG);

    do {
        FD_ZERO(&readfds);
        FD_SET(STDIN_FILENO, &readfds);
        tv.tv_sec = 0;
        tv.tv_usec = 50*1000;
        ret = select(STDIN_FILENO+1, &readfds, NULL, NULL, &tv);
        if (ret < 0) {
            if (errno == EINTR) {
                usleep(1000);
                continue;
            }
            else {
                log("select() failed [%s]", strerror(errno));
                return -1;
            }
        }
        else if (ret > 0) {
            ch = getch();
        }
    
        win_array[WINDOW_TITLE].paint(&win_array[WINDOW_TITLE]);
        win_array[WINDOW_INFO].paint(&win_array[WINDOW_INFO]);
        win_array[WINDOW_BUSINESS].paint(&win_array[WINDOW_BUSINESS]);
        win_array[WINDOW_RUNLOG].paint(&win_array[WINDOW_RUNLOG]);
    
        // help at the bottom of screen
        attron(COLOR_PAIR(4)|A_BOLD);
        mvprintw(LINES-1, 0, "\"Press 'q' or 'Q' to Exit\"");
        attroff(COLOR_PAIR(4)|A_BOLD);
        wnoutrefresh(stdscr);
        doupdate();

        // handle screen resize
        if (resize_now) {
            close_window_struct(WINDOW_TITLE);
            close_window_struct(WINDOW_INFO);
            close_window_struct(WINDOW_BUSINESS);
            close_window_struct(WINDOW_RUNLOG);
            endwin();
            refresh();
            clear();
            create_window_struct(WINDOW_TITLE);
            create_window_struct(WINDOW_INFO);
            create_window_struct(WINDOW_BUSINESS);
            create_window_struct(WINDOW_RUNLOG);
            resize_now = false;
        }
    } while (ch != 'q' && ch != 'Q');

    close_window_struct(WINDOW_TITLE);
    close_window_struct(WINDOW_INFO);
    close_window_struct(WINDOW_BUSINESS);
    close_window_struct(WINDOW_RUNLOG);

    endwin();
    return 0;
}
