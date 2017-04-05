#include "tsview.h"


int test_handle_key_up( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
/*
    if (ncpc_error_flag)
        return false;

    switch (ncpc_display_type)
    {
        case NCPC_DISPLAY_LIST:
        {
            ncp_list_data.currentSel--;
            if (ncp_list_data.currentSel<0)
                ncp_list_data.currentSel = ncp_list_data.lineNum-1;
            break;
        }
        case NCPC_DISPLAY_DETAIL:
        {
            break;
        }
        default:
        {
            break;
        }
    }
*/
    return true;
}



int init_win_help(WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return true;
}

int close_win_help(WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return true;
}

int draw_win_help(WINDOW_TYPE win_type)
{
    int line = 3;
    char tmp[80] = {0};

    //Çå³ýwindowsÄÚÈÝ
    clear_tbl_win(win_type);

    sprintf(tmp, "About Taishan System Control Desktop  -- forrest 2010.5 -- ");
    print_tbl_str_middle(win_type, line, 0, tmp);

    line += 2;
    sprintf(tmp, "    Tab  -  switch window between all windows.             ");
    print_tbl_str_middle(win_type, line, 0, tmp);

    line += 2;
    sprintf(tmp, "    c  -  close current window.                            ");
    print_tbl_str_middle(win_type, line, 0, tmp);

    line += 2;
    sprintf(tmp, "    q  -  exit program.                                    ");
    print_tbl_str_middle(win_type, line, 0, tmp);

    line += 2;
    sprintf(tmp, "help waiting ...                                           ");
    print_tbl_str_middle(win_type, line, 0, tmp);

    return true;
}

int handle_win_help(WINDOW_TYPE win_type, int ch)
{
    switch(ch)
    {
        case KEY_UP:
            test_handle_key_up(win_type);
            break;
        default:
            break;
    }
    return true;
}

int command_win_help( WINDOW_TYPE win_type, char *cmdstr, int length )
{
    ts_notused(win_type);
    ts_notused(cmdstr);
    ts_notused(length);
    return true;
}

int refresh_win_help( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return true;
}


