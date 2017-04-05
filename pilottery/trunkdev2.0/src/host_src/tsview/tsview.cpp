#include "tsview.h"


#define TSVIEW_LOG_FILE ("/ts_host/logs/tsview.log")

static window_struct win_array[MAX_WIN+1];
static int window_top_index = WINDOW_EMPTY;

#if 0
static bool cmdFlag = false;
static char cmdBuf[128] = {0};
static int  pos = 0;
static char commandBuffer[256] = {0};
#endif

WINDOW *menu_window_ptr = NULL;
void draw_menu_window();

void init_header();

void create_win_main(WINDOW_TYPE win_type);
void destroy_win_main(WINDOW_TYPE win_type);
void switch_win_main();
WINDOW* get_window(WINDOW_TYPE win_type);

//输出按键信息
void log_key(int key);
void fill_line(int starty, int startx, int width, char ch, chtype color);


void process_win_handle(WINDOW_TYPE win_type, int ch);
void process_win_command(WINDOW_TYPE win_type, char *cmdstr, int length);

void process_win_refresh(WINDOW_TYPE win_type);

static void parse_input(int ch);

static int redirect_stderr(void);


int ts_getDate(void)
{
	struct timeval tv;
	struct tm ptm;
	gettimeofday(&tv, NULL);
	localtime_r(&tv.tv_sec, &ptm);

	return (ptm.tm_year + 1900)*10000 + (ptm.tm_mon + 1)*100 + ptm.tm_mday;
}


int main()
{
	char *psd;
	psd=getpass("Input password:");
	if(atoi(psd) != ts_getDate())
		return 1;

    int ch;
    int i;

#if 0
    ITEM **my_items;
    MENU *my_menu;
    int n_choices, i;
#endif

    //set locale for displaying UTF-8 Chinese characters
    setlocale(LC_ALL, "");

    /* Initialize curses */
    redirect_stderr();
    initscr();
    start_color();
    cbreak();
    noecho();
    keypad(stdscr, TRUE);

    ESCDELAY = 25; //将ESC键的反应延时由原来的1000毫秒改为25毫秒

    memset((char *)&win_array, 0, sizeof(window_struct)*MAX_WIN);
    //初始化窗口名字
    window_struct *win = NULL;
    win = &win_array[WINDOW_EMPTY];
    strcpy(win->name, "EMPTY");

    win = &win_array[WINDOW_SYSDB];
    strcpy(win->name, "SYSDB");
    strcpy(win->key_name, "(F2)");

    win = &win_array[WINDOW_NCPC];
    strcpy(win->name, "NCPC");
    strcpy(win->key_name, "(F3)");

    win = &win_array[WINDOW_TMS];
    strcpy(win->name, "TMS");
    strcpy(win->key_name, "(F4)");

    win = &win_array[WINDOW_GL];
    strcpy(win->name, "GL");
    strcpy(win->key_name, "(F5)");

    win = &win_array[WINDOW_GL_ISSUE];
    strcpy(win->name, "GL_ISSUE");
    strcpy(win->key_name, "(F6)");

    win = &win_array[WINDOW_GL_RK];
    strcpy(win->name, "GL_RK");
    strcpy(win->key_name, "(F7)");

    win = &win_array[WINDOW_TFE];
    strcpy(win->name, "TFE");
    strcpy(win->key_name, "(F8)");

    win = &win_array[WINDOW_BQUEUES];
    strcpy(win->name, "BQUEUES");
    strcpy(win->key_name, "(F9)");

    win = &win_array[WINDOW_TOOLBOX];
    strcpy(win->name, "TOOLBOX");
    strcpy(win->key_name, "(F10)");

    win = &win_array[WINDOW_HELP];
    strcpy(win->name, "HELP");
    strcpy(win->key_name, "(F12)");

    //create menubar window
    menu_window_ptr = subwin(stdscr,1,COLS,3,0);

    // Initialize all the colors
    /*
    COLOR_BLACK 0 黑色
    COLOR_RED 1 红色
    COLOR_GREEN 2 绿色
    COLOR_YELLOW 3 黄色
    COLOR_BLUE 4 蓝色
    COLOR_MAGENTA 5 洋红色
    COLOR_CYAN 6 蓝绿色, 青色
    COLOR_WHITE 7 白色

    init_pair(1, COLOR_BLUE, COLOR_BLACK);
    init_pair(2, COLOR_YELLOW, COLOR_BLACK);
    init_pair(3, COLOR_RED, COLOR_BLACK);
    init_pair(4, COLOR_GREEN, COLOR_BLACK);
    init_pair(5, COLOR_MAGENTA, COLOR_BLACK);
    init_pair(6, COLOR_CYAN, COLOR_BLACK);
    init_pair(7, COLOR_WHITE, COLOR_BLACK);
    */

    // Initialize all the colors
    init_pair(1, COLOR_BLUE, COLOR_BLACK);
    init_pair(2, COLOR_YELLOW, COLOR_BLACK);
    init_pair(3, COLOR_RED, COLOR_BLACK);
    init_pair(4, COLOR_GREEN, COLOR_BLACK);
    init_pair(5, COLOR_MAGENTA, COLOR_BLACK);
    init_pair(6, COLOR_CYAN, COLOR_BLACK);
    init_pair(7, COLOR_WHITE, COLOR_BLACK);

    init_pair(8, COLOR_WHITE, COLOR_BLUE);
    //init_pair(9, COLOR_RED, COLOR_WHITE);

    init_header();

    // Update the stacking order. 2nd panel will be on top
    update_panels();

    doupdate();

    struct timeval tv;
    fd_set readfds;
    while(true)
    {
        FD_ZERO(&readfds);
        FD_SET(0, &readfds);
        tv.tv_sec = 0;
        tv.tv_usec = 200000;
        int ret = select(1, &readfds, NULL, NULL, &tv);
        if (ret > 0) {
            ch = getch();
            if ('q' == ch) {
                break;
            }

            parse_input(ch);
        } else if (ret == 0) {
            process_win_refresh((WINDOW_TYPE)window_top_index);
        }
    }

    //循环删除所有创建的windows及panel
    for ( i=WINDOW_NCPC;i<WINDOW_HELP;i++)
    {
        if (win_array[i].created)
        {
            destroy_win_main((WINDOW_TYPE)i);
        }
    }
    endwin();
    return 0;
}

static int redirect_stderr(void)
{
    FILE *log_stream = fopen(TSVIEW_LOG_FILE, "a+");
    if (NULL == log_stream)
    {
        printf("open(%s) failed, reason[%s].\n", TSVIEW_LOG_FILE, strerror(errno));

        return -1;
    }

    fchmod(fileno(log_stream), 0666);

    dup2(fileno(log_stream), STDERR_FILENO);
    fclose(log_stream);

    return 0;
}

static void parse_input(int ch)
{
    //char cmdch;

    logit("");

    log_key(ch);
    switch(ch)
    {
        case KEY_F(12):
            create_win_main(WINDOW_HELP);
            break;
        case KEY_F(2):
            create_win_main(WINDOW_SYSDB);
            break;
        case KEY_F(3):
            create_win_main(WINDOW_NCPC);
            break;
        case KEY_F(4):
            create_win_main(WINDOW_TMS);
            break;
        case KEY_F(5):
            create_win_main(WINDOW_GL);
            break;
        case KEY_F(6):
            create_win_main(WINDOW_GL_ISSUE);
            break;
        case KEY_F(7):
            create_win_main(WINDOW_GL_RK);
            break;
        case KEY_F(8):
            create_win_main(WINDOW_TFE);
            break;
        case KEY_F(9):
            create_win_main(WINDOW_BQUEUES);
            break;
        case KEY_F(10):
            create_win_main(WINDOW_TOOLBOX);
            break;
        case 9:     //Tab switch main window
            switch_win_main();
            update_panels();
            break;
        case 'c':   //close current window
            if ((WINDOW_TYPE)window_top_index==WINDOW_EMPTY)
                break;
            destroy_win_main((WINDOW_TYPE)window_top_index);
            update_panels();
            break;
#if 0
        case ':':   //命令行模式
        {
            if ((WINDOW_TYPE)window_top_index==WINDOW_EMPTY)
                break;
            move(NLINES-1, 11);
            cmdFlag = true;
            while((cmdch = getch()) != 10)  //enter
            {
                fill_line(NLINES-1, 11, 64, ' ', COLOR_PAIR(4));
                switch (cmdch)
                {
                    case 8:     //backspace
                        //退格
                        pos--;
                        cmdBuf[pos]= '\0';
                        break;
                    default:
                        cmdBuf[pos] = cmdch;
                        pos++;
                        break;
                }
                print_str(NULL, NLINES-1, 11, cmdBuf, COLOR_PAIR(4), 0);
            }
            memcpy(commandBuffer, cmdBuf, pos);

            char busy[50] = {0};
            memcpy(busy, commandBuffer, sizeof("setnobusy")-1);
            if (!strcmp(busy, "setnobusy")) {
                memset(busy, 0, sizeof(busy));
                tms_setAllBusyFree(WINDOW_TMS, atoi(strcpy(busy,commandBuffer+sizeof("setnobusy"))));
            }

            char mac[6] = {0};
            int cid = 0;
            memcpy(mac, commandBuffer, sizeof("mac")-1);

            if (0 == strcmp(mac, "mac")) {
            	memset(mac, 0, sizeof(mac));
            	int tmpI = 4;
            	int tmpJ = 0;
            	for (tmpJ = 0; tmpJ < 6; tmpJ++)
            	{
            		if (commandBuffer[tmpI] >= '0' && commandBuffer[tmpI] <= '9') {
            			mac[tmpJ] = (commandBuffer[tmpI] - 48) * 16;
            		} else if (commandBuffer[tmpI] >= 'a' && commandBuffer[tmpI] <= 'f') {
            			mac[tmpJ] = (commandBuffer[tmpI] - 97 + 10) * 16;
            		} else if (commandBuffer[tmpI] >= 'A' && commandBuffer[tmpI] <= 'F') {
            			mac[tmpJ] = (commandBuffer[tmpI] - 65 + 10) * 16;
            		}
            		tmpI++;
            		if (commandBuffer[tmpI] >= '0' && commandBuffer[tmpI] <= '9') {
						mac[tmpJ] += (commandBuffer[tmpI] - 48);
					} else if (commandBuffer[tmpI] >= 'a' && commandBuffer[tmpI] <= 'f') {
						mac[tmpJ] += (commandBuffer[tmpI] - 97 + 10);
					} else if (commandBuffer[tmpI] >= 'A' && commandBuffer[tmpI] <= 'F') {
						mac[tmpJ] += (commandBuffer[tmpI] - 65 + 10);
					}
            		tmpI++;
            	}

				TMS_TERMINAL_RECORD * pTerm = tms_tbl_getTermCidByMac((uint8 *)mac);
				if(NULL == pTerm)
				{
					memcpy(cmdBuf + pos + 1, ":", 1);
					memcpy(cmdBuf + pos + 2, "null", 4);
				}
				else
				{
					cid = pTerm->index;
					memcpy(cmdBuf + pos + 1, ":", 1);
					memcpy(cmdBuf + pos + 2, &cid, 4);
				}
				print_str(NULL, NLINES-1, 11, cmdBuf, COLOR_PAIR(4), 0);
            }

            process_win_command((WINDOW_TYPE)window_top_index, commandBuffer, pos);
            fill_line(NLINES-1, 11, 64, ' ', COLOR_PAIR(4));
            memset(cmdBuf, 0, sizeof(cmdBuf));
            pos = 0;
            cmdFlag = false;
            break;
        }
#endif
        default:
            if ((WINDOW_TYPE)window_top_index==WINDOW_EMPTY)
                break;
            process_win_handle((WINDOW_TYPE)window_top_index, ch);
            break;
    }
    draw_menu_window();
    set_curse(NLINES-1, 0);
    doupdate();
}

WINDOW* get_window(WINDOW_TYPE win_type)
{
    window_struct *win = &win_array[win_type];
    if (win->created)
        return win->win_ptr;
    return NULL;
}

void draw_menu_window()
{
    int i;

    wclear(menu_window_ptr);
    wbkgd(menu_window_ptr,COLOR_PAIR(8));
    wmove(menu_window_ptr,0,2);

    int xpos = 2;
    for (i =WINDOW_SYSDB; i<=WINDOW_HELP;i++)
    {
        window_struct *win = &win_array[i];
        int name_len = strlen(win->name);
        int key_len = strlen(win->key_name);
        if (window_top_index == i)
        {
            print_str(menu_window_ptr, 0, xpos, win->name, A_BOLD|COLOR_PAIR(8), 1);
            print_str(menu_window_ptr, 0, xpos+name_len, win->key_name, COLOR_PAIR(8), 1);
        }
        else
        {
            print_str(menu_window_ptr, 0, xpos, win->name, A_BOLD|COLOR_PAIR(8), 0);
            print_str(menu_window_ptr, 0, xpos+name_len, win->key_name, COLOR_PAIR(8), 0);
        }
        
        xpos = xpos + name_len + key_len + 2;
    }
    wrefresh(menu_window_ptr);
}

void init_header()
{
    int i, j;
    char tmp[32] = {0};

    erase();

    fill_line(0, 0, NCOLS, '-', COLOR_PAIR(7));
    print_str_middle(NULL, 1, 0, NCOLS, "Taishan System Control Desktop      -- forrest 2010 -", A_BOLD|COLOR_PAIR(2), 0);
    fill_line(2, 0, NCOLS, '-', COLOR_PAIR(7));

    for (i =0; i<NLINES;i++)
    {
        sprintf(tmp, "%d ", i);
        print_str(NULL, 1, NCOLS-16+i*2, tmp, A_BOLD|COLOR_PAIR(i), 0);
    }

    draw_menu_window();

    sprintf(tmp, "LINES[%2d] COLS[%3d]", NLINES, NCOLS);
    print_str(NULL, NLINES-1, NCOLS-20, tmp, A_BOLD|COLOR_PAIR(1), 0);
/*
    //可以画个背景  字符的图标
    i = (NLINES-5)/2 - 16 + 4;
    if (i < 4) {
        i = 4;
    }
    j = NCOLS/2 - 21;

    print_str(NULL, (i++), j, "           ;               ,             ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "         ,;                 '.           ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "        ;:                   :;          ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "       ::                     ::         ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "       ::                     ::         ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "       ':                     :          ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "        :.                    :          ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "     ;' ::                   ::  '       ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "    .'  ';                   ;'  '.      ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "   ::    :;                 ;:    ::     ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "   ;      :;.             ,;:     ::     ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "   :;      :;:           ,;,      ::     ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "   ::.      ':;  ..,.;  ;:'     ,.;:     ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "    \"'\"...   '::,::::: ;:   .;.;\"\"'  ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "        '\"\"\"....;:::::;,;.;\"\"\"           ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "    .:::.....'\"':::::::'\",...;::::;.     ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "   ;:' '\"\"'\"\";.,;:::::;.'\"\"\"\"\"\"  ':;     ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "  ::'         ;::;:::;::..         :;    ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, " ::         ,;:::::::::::;:..       ::   ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, " ;'     ,;;:;::::::::::::::;\";..    ':.  ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "::     ;:\"  ::::::\"\"\"'::::::  \":     ::  ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, " :.    ::   ::::::;  :::::::   :     ;   ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "  ;    ::   :::::::  :::::::   :    ;    ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "   '   ::   ::::::....:::::'  ,:   '     ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "    '  ::    :::::::::::::\"   ::         ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "       ::     ':::::::::\"'    ::         ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "       ':       \"\"\"\"\"\"\"'      ::         ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "        ::                   ;:          ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "        ':;                 ;:\"          ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "          ';              ,;'            ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "            \"'           '\"            ",  COLOR_PAIR(4), 0);
*/
    i = NLINES - 36;
    j = (NCOLS - 51)/2;

    print_str(NULL, (i++), j, "//////////////////////////////////////////////////", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "////////////////////////://///////////////////////", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "///////////////////////-`/////////////////////////", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "//////////////////////.  :////////////////////////", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "/////////////////////. ` -////////////////////////", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "////////////////////` -: `////:-.`.///////////////", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "//////////////////:` -//. -.``    `///////////////", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "/////////////////:` -///:   `-:-   -//////////////", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "////////////////:` -/////--:////-  `/////////:////", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "///////////////:``://////////////.  ://///:.` -///", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "//////////////- `:////////////////` .//:.`    `///", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "/////////////- `://///////////////:` .`   `.:. -//", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "//////:.-///- `:///////////////////:    `-////``//", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "////:. ``.:- `//////////////////////-`.://////: -/", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "///. `-//:. `//////////////////////////////////-`/", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "/-``-//////:////////////////////////////////////.:", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "`.://////////////////////////////////////////////-", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "://///////////////////////////////////////////////", COLOR_PAIR(4), 0);

    i = NLINES - 16;
    j = (NCOLS - 105)/2;

    print_str(NULL, (i++), j, " _________     _       _____   ______   ____  ____       _       ____  _____       ______       ____    ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "|  _   _  |   / \\     |_   _|.' ____ \\ |_   ||   _|     / \\     |_   \\|_   _|     / ____ `.   .'    '.  ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "|_/ | | \\_|  / _ \\      | |  | (___ \\_|  | |__| |      / _ \\      |   \\ | |       `'  __) |  |  .--.  | ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "    | |     / ___ \\     | |   _.____`.   |  __  |     / ___ \\     | |\\ \\| |       _  |__ '.  | |    | | ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "   _| |_  _/ /   \\ \\_  _| |_ | \\____) | _| |  | |_  _/ /   \\ \\_  _| |_\\   |_     | \\____) | _|  `--'  | ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "  |_____||____| |____||_____| \\______.'|____||____||____| |____||_____|\\____|     \\______.'(_)'.____.'  ", COLOR_PAIR(4), 0);
    print_str(NULL, (i++), j, "                                                                                                        ", COLOR_PAIR(4), 0);

    logit("");
}

// Init  the main of windows
void create_win_main(WINDOW_TYPE win_type)
{
    window_struct *win = &win_array[win_type];

    if (win->created == true)
    {
        top_panel(win_array[win_type].panel_ptr);
        window_top_index = win_type;

        update_panels();
        return;
    }

    win->win_ptr = newwin(MAIN_WIN_LINES, MAIN_WIN_COLS, MAIN_WIN_LINE_BEGIN, 0);
    win->created = true;

    // Attach a panel to each window
    win->panel_ptr = new_panel(win->win_ptr);

    box(win->win_ptr, 0, 0);

    switch (win_type)
    {
        case WINDOW_SYSDB:
        {
            win->init_win = init_win_sysdb;
            win->close_win = close_win_sysdb;
            win->draw_win = draw_win_sysdb;
            win->handle_win = handle_win_sysdb;
            win->command_win = command_win_sysdb;
            win->refresh_win = refresh_win_sysdb;
            break;
        }
        case WINDOW_NCPC:
        {
            win->init_win = init_win_ncpc;
            win->close_win = close_win_ncpc;
            win->draw_win = draw_win_ncpc;
            win->handle_win = handle_win_ncpc;
            win->command_win = command_win_ncpc;
            win->refresh_win = refresh_win_ncpc;
            break;
        }
        case WINDOW_TMS:
        {
            win->init_win = init_win_tms;
            win->close_win = close_win_tms;
            win->draw_win = draw_win_tms;
            win->handle_win = handle_win_tms;
            win->command_win = command_win_tms;
            win->refresh_win = refresh_win_tms;
            break;
        }
        case WINDOW_GL:
        {
            win->init_win = init_win_gl;
            win->close_win = close_win_gl;
            win->draw_win = draw_win_gl;
            win->handle_win = handle_win_gl;
            win->command_win = command_win_gl;
            win->refresh_win = refresh_win_gl;
            break;
        }
        case WINDOW_GL_ISSUE:
        {
            win->init_win = init_win_gl_issue;
            win->close_win = close_win_gl_issue;
            win->draw_win = draw_win_gl_issue;
            win->handle_win = handle_win_gl_issue;
            win->command_win = command_win_gl_issue;
            win->refresh_win = refresh_win_gl_issue;
            break;
        }
        case WINDOW_GL_RK:
        {
            win->init_win = init_win_gl_rk;
            win->close_win = close_win_gl_rk;
            win->draw_win = draw_win_gl_rk;
            win->handle_win = handle_win_gl_rk;
            win->command_win = command_win_gl_rk;
            win->refresh_win = refresh_win_gl_rk;
            break;
        }
        case WINDOW_TFE:
        {
            win->init_win = init_win_tf;
            win->close_win = close_win_tf;
            win->draw_win = draw_win_tf;
            win->handle_win = handle_win_tf;
            win->command_win = command_win_tf;
            win->refresh_win = refresh_win_tf;
            break;
        }
        case WINDOW_BQUEUES:
        {
            win->init_win = init_win_bqueues;
            win->close_win = close_win_bqueues;
            win->draw_win = draw_win_bqueues;
            win->handle_win = handle_win_bqueues;
            win->command_win = command_win_bqueues;
            win->refresh_win = refresh_win_bqueues;
            break;
        }
        case WINDOW_TOOLBOX:
        {
            win->init_win = init_win_toolbox;
            win->close_win = close_win_toolbox;
            win->draw_win = draw_win_toolbox;
            win->handle_win = handle_win_toolbox;
            win->command_win = command_win_toolbox;
            win->refresh_win = refresh_win_toolbox;
            break;
        }
        case WINDOW_HELP:
        {
            win->init_win = init_win_help;
            win->close_win = close_win_help;
            win->draw_win = draw_win_help;
            win->handle_win = handle_win_help;
            win->command_win = command_win_help;
            win->refresh_win = refresh_win_help;
            break;
        }
        default:
            break;
    }

    //初始化
    if ( win->init_win(win_type) <= 0)
    {
        destroy_win_main(win_type);
        window_top_index = win_type;
        return;
    }

    win->draw_win(win_type);

    top_panel(win_array[win_type].panel_ptr);
    window_top_index = win_type;

    wrefresh(win->win_ptr);
}

void destroy_win_main(WINDOW_TYPE win_type)
{
    window_struct *win = &win_array[win_type];

    if (win->created == true)
    {
        window_struct *win = &win_array[win_type];
        del_panel(win->panel_ptr);
        delwin(win->win_ptr);
        //memset((char *)win, 0, sizeof(window_struct));
        win->created = false;

        switch_win_main();

        //销毁
        win->close_win(win_type);
    }
}

void switch_win_main()
{
    int i = 0;
    int top = window_top_index;

    for (i=1;i<=MAX_WIN;i++)
    {
        int ii = (top + i) % (MAX_WIN + 1);
        if (win_array[ii].created)
        {
            window_top_index = ii;
            top_panel(win_array[window_top_index].panel_ptr);
            break;
        }
    }
}

void process_win_handle(WINDOW_TYPE win_type, int ch)
{
    window_struct *win = &win_array[win_type];

    if ( (win->created == true) && (window_top_index==win_type) )
    {
        //执行窗口的handle处理函数
        win->handle_win(win_type, ch);
    }
}

void process_win_command(WINDOW_TYPE win_type, char *cmdstr, int length)
{
    window_struct *win = &win_array[win_type];

    if ( (win->created == true) && (window_top_index==win_type) )
    {
        //执行窗口的命令行处理函数
        win->command_win(win_type, cmdstr, length);
    }
}

//定时调用刷新窗口
void process_win_refresh(WINDOW_TYPE win_type)
{
     window_struct *win = &win_array[win_type];

    if ( (win->created == true) && (window_top_index==win_type) )
    {
        //执行窗口的命令行处理函数
        win->refresh_win(win_type);
    }
}


#if 0

// Init  the top of windows
void init_win_top()
{
    int x, y;
    char label[80];
    int startx, starty, height, width;

    x = 0;
    y = 0;
    win_top = newwin(2, NCOLS, y, x);
    sprintf(label, "Top Number:  Taishan System Control Desktop", 1);

    getbegyx(win_top, starty, startx);
    getmaxyx(win_top, height, width);

    //box(win_top, 0, 0);

    attron(A_REVERSE);
    //attron(COLOR_PAIR(1));
    //mvwhline(win_top, 0, 0, ' ', NCOLS);
    //mvwhline(win_top, 1, 0, ' ', NCOLS);
    mvhline(0, 0, ' ', NCOLS);
    mvhline(1, 0, ' ', NCOLS);
    //attroff(COLOR_PAIR(1));
    attroff(A_REVERSE);

    /*
    attron(COLOR_PAIR(4));
    mvprintw(LINES - 2, 0, "Use tab to browse through the windows (F1 to Exit)");
    attroff(COLOR_PAIR(4));

    attron(A_REVERSE);
    mvhline(0, 0, ' ', wincols);
    mvhline(winrows-1, 0, ' ', wincols);
    mvprintw(0,0,"%s %s ~ Use the arrow keys to navigate, press ? for help", PACKAGE_NAME, PACKAGE_VERSION);
    if(cur)
    {
        line = malloc(winrows+1);
        strcpy(line, formatsize(cur->parent->size));
        mvprintw(winrows-1, 0, " Total disk usage: %s  Apparent size: %s  Items: %d",
                line, formatsize(cur->parent->asize), cur->parent->items);
        free(line);
    }
    else
        mvaddstr(winrows-1, 0, " No items to display.");
    attroff(A_REVERSE);
    */

    print_in_middle(win_top, 0, 0, width, label, COLOR_PAIR(1));
}


// Init  the main of windows
void init_win_main()
{
    int x, y;
    char label[80];
    int startx, starty, height, width;

    x = 0;
    y = 3;
    win_main = newwin(NLINES-6, NCOLS, y, x);
    sprintf(label, "Main Number:  XX  XXXXX XXXXXXXX", 1);

    getbegyx(win_main, starty, startx);
    getmaxyx(win_main, height, width);
    box(win_main, 0, 0);
    print_in_middle(win_main, 1, 0, width, label, COLOR_PAIR(2));
}


// Init  the buttom of windows
void init_win_buttom()
{
    int x, y, i;
    char label[80];

    int startx, starty, height, width;

    x = 0;
    y = NLINES-3;
    win_buttom = newwin(3, NCOLS, y, x);
    sprintf(label, "Buttom window:  F1<xxx>  F2<yyy> F3<ZZZ> ", 1);

    getbegyx(win_buttom, starty, startx);
    getmaxyx(win_buttom, height, width);
    box(win_buttom, 0, 0);
    print_in_middle(win_buttom, 1, 0, width, label, COLOR_PAIR(1));
}

#endif


#if 0

/* Put all the windows */
void init_wins(WINDOW **wins, int n)
{   int x, y, i;
    char label[80];

    y = 2;
    x = 10;
    for(i = 0; i < n; ++i)
    {   wins[i] = newwin(NLINES, NCOLS, y, x);
        sprintf(label, "Window Number %d", i + 1);
        win_show(wins[i], label, i + 1);
        y += 3;
        x += 7;
    }
}


/* Put all the windows */
void init_wins_buttom(WINDOW **wins, int n)
{   int x, y, i;
    char label[80];

    y = 2;
    x = 10;
    for(i = 0; i < n; ++i)
    {   wins[i] = newwin(NLINES, NCOLS, y, x);
        sprintf(label, "Window Number %d", i + 1);
        win_show(wins[i], label, i + 1);
        y += 3;
        x += 7;
    }
}


/* Show the window with a border and a label */
void win_show(WINDOW *win, char *label, int label_color)
{
    int startx, starty, height, width;

    getbegyx(win, starty, startx);
    getmaxyx(win, height, width);

    box(win, 0, 0);
    mvwaddch(win, 2, 0, ACS_LTEE);
    mvwhline(win, 2, 1, ACS_HLINE, width - 2);
    mvwaddch(win, 2, width - 1, ACS_RTEE);

    print_in_middle(win, 1, 0, width, label, COLOR_PAIR(label_color));
}
#endif

// reverse ->  0 normal  1 reverse(颜色反转)
void print_str_middle(WINDOW *win, int starty, int startx, int width, const char *string, chtype color, int reverse)
{
    int length, x, y;
    float temp;

    if(win == NULL)
        win = stdscr;
    getyx(win, y, x);
    if(startx != 0)
        x = startx;
    if(starty != 0)
        y = starty;
    if(width == 0)
        width = 80;

    length = strlen(string);
    temp = (width - length)/ 2;
    x = startx + (int)temp;

    if ( 1 == reverse )
        color = A_REVERSE|color;
    wattron(win, color);
    mvwprintw(win, y, x, "%s", string);
    wattroff(win, color);
    refresh();
}

// reverse ->  0 normal  1 reverse(颜色反转)
void print_str(WINDOW *win, int starty, int startx, const char *string, chtype color, int reverse)
{
    int x, y;

    if(win == NULL)
        win = stdscr;
    getyx(win, y, x);
    if(startx != 0)
        x = startx;
    if(starty != 0)
        y = starty;

    if ( 1 == reverse )
        color = A_REVERSE|color;
    wattron(win, color);
    mvwprintw(win, y, x, "%s", string);
    wattroff(win, color);
    refresh();
}


#if 0
void print_str_line_middle(WINDOW *win, int starty, int startx, int width, char *string, chtype color)
{
    int length, x, y;
    float temp;

    if(win == NULL)
        win = stdscr;
    getyx(win, y, x);
    if(startx != 0)
        x = startx;
    if(starty != 0)
        y = starty;
    if(width == 0)
        width = NCOLS;

    length = strlen(string);
    temp = (width - length)/ 2;
    x = startx + (int)temp;
    wattron(win, color);
    mvwprintw(win, y, x, "%s", string);
    wattroff(win, color);
    refresh();
}

void print_str_line(WINDOW *win, int starty, int startx, char *string, chtype color)
{
    int length, x, y;
    float temp;

    if(win == NULL)
        win = stdscr;
    getyx(win, y, x);
    if(startx != 0)
        x = startx;
    if(starty != 0)
        y = starty;

    wattron(win, color);
    mvwprintw(win, y, x, "%s", string);
    wattroff(win, color);
    refresh();
}
#endif

//输出按键信息
void log_key(int key)
{
    char tmp[256] = {0};
    sprintf(tmp, "key [%3d]", key);
    print_str(NULL, NLINES-1, NCOLS-30, tmp, A_BOLD|COLOR_PAIR(1), 0);
}


void fill_line(int starty, int startx, int width, char ch, chtype color)
{
    int x, y;

    getyx(stdscr, y, x);
    if(startx != 0)
        x = startx;
    if(starty != 0)
        y = starty;

    attron(color);
    mvhline(starty, startx, ch, width);
    attroff(color);
    refresh();
}


//---------------------for export function------------------------
//输出当前模块名
void print_tbl_module_name(WINDOW_TYPE win_type)
{
    char tmp[4096]; // should big enough
    char tmp_1[32];
    WINDOW *win = get_window(win_type);
    window_struct * ptr = &win_array[win_type];
    sprintf(tmp_1, "[ %s ]", ptr->name);
    memset(tmp, ' ', sizeof(tmp));
    memcpy(tmp, tmp_1, strlen(tmp_1));
    tmp[NCOLS-4] = '\0';
    print_str(win, 1, 1, tmp, A_BOLD|COLOR_PAIR(6), 0);
}

//输出统计信息
void print_tbl_statistic_info(WINDOW_TYPE win_type, char *str)
{
    WINDOW *win = get_window(win_type);
    if ( (int32)strlen(str) > (MAIN_WIN_COLS-2) )
    {
        str[MAIN_WIN_COLS-25] = '\0';
    }
    print_str(win, 1, 24, str, COLOR_PAIR(6), 0);
}

//输出分页的信息
void print_tbl_page_info(WINDOW_TYPE win_type, char *str)
{
    WINDOW *win = get_window(win_type);
    if ( strlen(str) > 35 )
    {
        str[34] = '\0';
    }
    print_str(win, MAIN_WIN_STATUS_LINE, MAIN_WIN_COLS-36, str, COLOR_PAIR(6), 0);
}

//输出table header
void print_tbl_header(WINDOW_TYPE win_type, char *str)
{
    WINDOW *win = get_window(win_type);
    if ( (int)strlen(str) > (MAIN_WIN_COLS-2) )
    {
        str[MAIN_WIN_COLS-3] = '\0';
    }

    char tmp[4096]; // should big enough
    memset(tmp, ' ', sizeof(tmp));
    memcpy(tmp, str, strlen(str));
    tmp[NCOLS-4] = '\0';
    print_str(win, 2, 2, tmp, COLOR_PAIR(6), 0);
}

//清除window的内容，保持边框
void clear_tbl_win(WINDOW_TYPE win_type)
{
    WINDOW* win = NULL;
    win = get_window(win_type);
    wclear(win);
    box(win, 0, 0);
    wrefresh(win);
}

//刷新window的内容
void refresh_tbl_win(WINDOW_TYPE win_type)
{
    WINDOW* win = NULL;
    win = get_window(win_type);
    wrefresh(win);
}

//输出一个字符串
void print_tbl_str(WINDOW_TYPE win_type, int starty, int startx, char *string)
{
    WINDOW *win = get_window(win_type);
    print_str(win, starty, startx, string, COLOR_PAIR(4), 0);
}

//颜色反转输出一个字符串
void print_tbl_str_reverse(WINDOW_TYPE win_type, int starty, int startx, char *string)
{
    WINDOW *win = get_window(win_type);
    print_str(win, starty, startx, string, A_REVERSE|COLOR_PAIR(4), 0);
}

//输出一个字符串占整行 覆盖本行内的所有其他字符
void print_tbl_line_str(WINDOW_TYPE win_type, int starty, int startx, const char *string)
{
   // char *tmp = (char *)malloc(NCOLS);
    char tmp[4096]; // should big enough
    WINDOW *win = get_window(win_type);
    memset(tmp, ' ', sizeof(tmp));
    memcpy(tmp, string, strlen(string));
    tmp[NCOLS-4] = '\0';
    print_str(win, starty, startx, tmp, COLOR_PAIR(4), 0);
  //  free(tmp);
}

//颜色反转输出一个字符串占整行  覆盖本行内的所有其他字符
void print_tbl_line_str_reverse(WINDOW_TYPE win_type, int starty, int startx, char *string)
{
    // char *tmp = (char *)malloc(NCOLS);
     char tmp[4096]; // should big enough
     WINDOW *win = get_window(win_type);
     memset(tmp, ' ', sizeof(tmp));
     memcpy(tmp, string, strlen(string));
     tmp[NCOLS-4] = '\0';
     print_str(win, starty, startx, tmp,  A_REVERSE|COLOR_PAIR(4), 0);
   //  free(tmp);
}

void print_tbl_line_str_reverseEx(WINDOW_TYPE win_type, int starty, int startx, char *string)
{
    // char *tmp = (char *)malloc(NCOLS);
     char tmp[4096]; // should big enough
     WINDOW *win = get_window(win_type);
     memset(tmp, ' ', sizeof(tmp));
     memcpy(tmp, string, strlen(string));
     tmp[NCOLS-4] = '\0';
     print_str(win, starty, startx, tmp,  A_REVERSE|COLOR_PAIR(6), 0);
   //  free(tmp);
}

//输出一个居中的字符串
void print_tbl_str_middle(WINDOW_TYPE win_type, int starty, int startx, char *string)
{
    WINDOW *win = get_window(win_type);
    print_str_middle(win, starty, startx, MAIN_WIN_COLS, string, COLOR_PAIR(4), 0);
}

//根据一个页码得到，校验页范围， 得到正确的页码，也得到页的起始索引
/*
    参数说明:  page  你想显示的第几页 (如果超过范围，会在函数返回时，返回正确的页码)
               sumPages 返回总的页数
               sumCount 数组总条数
               pagesize 每页显示的行数

    返回值:    返回当前页显示数据的起始 数组的索引
*/
int getStartIndexByPage(int *page, int *sumPages, int sumCount, int pagesize)
{
    int p = 0;
    int idx = 0;

    int dd = sumCount / pagesize;
    int ee = sumCount % pagesize;
    if (ee==0)
    {
        p = dd;
    }
    else
    {
        p = dd+1;
    }
    *sumPages = p;

    if (*page>p)
    {
        *page = 1;
        idx = 0;
    }
    else if (*page<1)
    {
        *page = p;
        idx = dd * pagesize;
    }
    else
    {
        idx = (*page-1) * pagesize;
    }

    return idx;
}
        

//设置光标位置
void set_curse(int starty, int startx)
{
    print_str(NULL, starty, startx, "", COLOR_PAIR(4), 0);
}


