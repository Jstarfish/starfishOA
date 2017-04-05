#include "tsview.h"
#include "tms_inf.h"

bool tms_init_flag = false;

bool tms_error_flag = false;
TMS_DATABASE_PTR tms_database_ptr = NULL;

typedef enum _TMS_DISPLAY_TYPE
{
    TMS_DISPLAY_EMPTY = 0,
    TMS_DISPLAY_FIRST_PAGE,
    TMS_DISPLAY_TERMINAL_LIST,

}TMS_DISPLAY_TYPE;


//在可移动的行上 或 单独的页面上  定义用户的自定义数据
typedef struct _list_tms_info
{
    TMS_DISPLAY_TYPE enter_type;
    int enter_index;                //定义回车键的将显示的数组索引
}list_tms_info;


//TMS_DISPLAY_FIRST_PAGE    first page 页面的数据
typedef struct _display_first_page_data
{
    int currentSel;            //当前选择的行号
    int lineNum;               //当前页显示的总行数
    //
    list_tms_info data[MAIN_WIN_MAX_LINE];     //行索引数据  每页显示行数应该不会超过40
}display_first_page_data;

//TMS_DISPLAY_AREA_LIST    area list 页面的数据
typedef struct _display_area_list_data
{
    unsigned int current_display_page; //当前需要显示那一页
    unsigned int page_start_index; //当前页显示的teller索引的起始
    int currentSel;            //当前选择的行号
    int lineNum;               //当前页显示的总行数
    //
    list_tms_info data[MAIN_WIN_MAX_LINE];     //行索引数据  每页显示行数应该不会超过40
}display_area_list_data;

//TMS_DISPLAY_AGENCY_LIST    agency list 页面的数据
typedef struct _display_agency_list_data
{
    unsigned int current_display_page;      //当前需要显示那一页
    unsigned int page_start_index;          //当前页显示的agency索引的起始
    int currentSel;            //当前选择的行号
    int lineNum;               //当前页显示的总行数
    //
    list_tms_info data[MAIN_WIN_MAX_LINE];     //行索引数据  每页显示行数应该不会超过40
}display_agency_list_data;

//TMS_DISPLAY_TERMINAL_LIST    terminal list 页面的数据
typedef struct _display_terminal_list_data
{
    unsigned int current_display_page;      //当前需要显示那一页
    unsigned int page_start_index;          //当前页显示的terminal索引的起始
    int currentSel;            //当前选择的行号
    int lineNum;               //当前页显示的总行数
    //
    list_tms_info data[MAIN_WIN_MAX_LINE];     //行索引数据  每页显示行数应该不会超过40
}display_terminal_list_data;

//TMS_DISPLAY_TELLER_LIST    teller list 页面的数据
typedef struct _display_teller_list_data
{
    unsigned int current_display_page;      //当前需要显示那一页
    unsigned int page_start_index;          //当前页显示的teller索引的起始
    int currentSel;            //当前选择的行号
    int lineNum;               //当前页显示的总行数
    //
    list_tms_info data[MAIN_WIN_MAX_LINE];     //行索引数据  每页显示行数应该不会超过40
}display_teller_list_data;

//TMS_DISPLAY_SOFT_LIST    soft list 页面的数据
typedef struct _display_soft_list_data
{
    unsigned int current_display_page;      //当前需要显示那一页
    unsigned int page_start_index;     //当前页显示的teller索引的起始
    int currentSel;            //当前选择的行号
    int lineNum;               //当前页显示的总行数
    //
    list_tms_info data[MAIN_WIN_MAX_LINE];     //行索引数据  每页显示行数应该不会超过40
}display_soft_list_data;

//TMS_DISPLAY_AREA_DETAIL  area detail 页面的数据
typedef struct _display_detail_area_data
{
    //如果需要分页显示detail信息
    int area_index;         //tms表数组索引
    //
    list_tms_info data;     //行索引数据
}display_detail_area_data;

//TMS_DISPLAY_AGENCY_DETAIL  agency detail 页面的数据
typedef struct _display_detail_agency_data
{
    //如果需要分页显示detail信息
    int agency_index;         //tms表数组索引
    //
    list_tms_info data;     //行索引数据
}display_detail_agency_data;


//TMS_DISPLAY_TERMINAL_DETAIL  terminal detail 页面的数据
typedef struct _display_detail_terminal_data
{
    //如果需要分页显示detail信息
    int terminal_index;         //tms表数组索引
    //
    list_tms_info data;     //行索引数据
}display_detail_terminal_data;

//TMS_DISPLAY_TELLER_DETAIL  teller detail 页面的数据
typedef struct _display_detail_teller_data
{
    //如果需要分页显示detail信息
    int teller_index;         //tms表数组索引
    //
    list_tms_info data;     //行索引数据
}display_detail_teller_data;

#define tms_win_top_line       3
#define tms_win_buttom_line    (MAIN_WIN_STATUS_LINE-2)

#define tms_win_lins  (tms_win_buttom_line-tms_win_top_line+1)


//当前的显示模式
static TMS_DISPLAY_TYPE tms_display_type = TMS_DISPLAY_EMPTY;
static TMS_DISPLAY_TYPE tms_display_type_keep = TMS_DISPLAY_EMPTY;


//定义页面显示的变量数据
static display_terminal_list_data terminal_list_data;
static display_detail_terminal_data terminal_detail_data;


//函数接口------------------------------------------------------------------
int draw_first_page( WINDOW_TYPE win_type);

int draw_terminal_list( WINDOW_TYPE win_type );


int tms_handle_key_left( WINDOW_TYPE win_type);

int tms_handle_key_right( WINDOW_TYPE win_type);

int tms_handle_key_up( WINDOW_TYPE win_type);

int tms_handle_key_down( WINDOW_TYPE win_type);

int tms_handle_key_enter( WINDOW_TYPE win_type);

int tms_handle_key_escape( WINDOW_TYPE win_type);


int tms_handle_key_h(WINDOW_TYPE win_type);

int int2hex(int num);


int init_win_tms(WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    if (tms_init_flag)
        return 0;

    //映射TMS共享内存区
    if (!tms_mgr()->TMSInit())
    {
        logit("ERROR:  tms_init failure!");
        tms_error_flag = true;
        return false;
    }
    tms_database_ptr = tms_mgr()->getDatabasePtr();

    memset(&terminal_list_data, 0, sizeof(display_terminal_list_data));
    memset(&terminal_detail_data, 0, sizeof(display_detail_terminal_data));

    terminal_list_data.current_display_page = 1;
    terminal_list_data.page_start_index = 0;

    tms_display_type = TMS_DISPLAY_FIRST_PAGE;
    tms_init_flag = true;
    return true;
}

int close_win_tms( WINDOW_TYPE win_type )
{
    ts_notused(win_type);
    if (tms_error_flag)
        return false;

    tms_init_flag = false;
    //tms_mgr()->TMSClose();
    return true;
}

int draw_win_tms( WINDOW_TYPE win_type )
{
    if (tms_display_type != tms_display_type_keep)
    {
        //清除windows内容
        clear_tbl_win(win_type);

        //输出当前模块名
        print_tbl_module_name(win_type);

        tms_display_type_keep = tms_display_type;
    }

    if (tms_error_flag)
        return false;

    switch (tms_display_type)
    {
        case TMS_DISPLAY_FIRST_PAGE:
        {
            draw_first_page(win_type);
            break;
        }
        case TMS_DISPLAY_TERMINAL_LIST:
        {
            draw_terminal_list(win_type);
            break;
        }

        default:
        {
            logit("tms display type error!!");
            break;
        }
    }
    refresh_tbl_win(win_type);

    return true;
}

int handle_win_tms( WINDOW_TYPE win_type, int ch )
{
    if (tms_error_flag)
        return false;

    switch(ch)
    {
        case KEY_UP:
            tms_handle_key_up(win_type);
            break;
        case KEY_DOWN:
            tms_handle_key_down(win_type);
            break;
        case KEY_LEFT:
            tms_handle_key_left(win_type);
            break;
        case KEY_RIGHT:
            tms_handle_key_right(win_type);
            break;
        case 10:     //enter
            tms_handle_key_enter(win_type);
            break;
        case 27:    //escapt
        case 96:    //`
            tms_handle_key_escape(win_type);
            break;
        case 'h':
            tms_handle_key_h(win_type);
            break;
        default:
            break;
    }
    draw_win_tms(win_type);

    return true;
}

int command_win_tms( WINDOW_TYPE win_type, char *cmdstr, int length )
{
    ts_notused(win_type);
    ts_notused(cmdstr);
    ts_notused(length);
    if (tms_error_flag)
        return false;

    return true;
}

int refresh_win_tms( WINDOW_TYPE win_type)
{
    if (tms_error_flag)
        return false;

    draw_win_tms(win_type);
    return true;
}

//-------自定义函数-----------------------------------------------------------

int tms_handle_key_left( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    switch (tms_display_type)
    {
        case TMS_DISPLAY_FIRST_PAGE:
        {
            //向前翻页
            terminal_list_data.current_display_page--;
            break;
        }
        case TMS_DISPLAY_TERMINAL_LIST:
        {
            if (terminal_detail_data.terminal_index>0)
            {
                terminal_detail_data.terminal_index = terminal_detail_data.terminal_index - 1;
            }
            break;
        }
        default:
        {
            break;
        }
    }
    return true;
}

int tms_handle_key_right( WINDOW_TYPE win_type)
{
#if 1 //__DEF_PIL

    ts_notused(win_type);
    switch (tms_display_type)
    {
        case TMS_DISPLAY_FIRST_PAGE:
        {
            //向后翻页
            terminal_list_data.current_display_page++;
            break;
        }
        case TMS_DISPLAY_TERMINAL_LIST:
        {
            if ( terminal_detail_data.terminal_index < (MAX_TERMINAL_NUMBER-1) )
                terminal_detail_data.terminal_index = terminal_detail_data.terminal_index + 1;
            break;
        }
        default:
        {
            break;
        }
    }
#endif
    return true;
}

int tms_handle_key_up( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    switch (tms_display_type)
    {
        case TMS_DISPLAY_FIRST_PAGE:
        {
            terminal_list_data.currentSel--;
            if (terminal_list_data.currentSel<0)
                terminal_list_data.currentSel = terminal_list_data.lineNum-1;
            break;
        }

        default:
        {
            break;
        }
    }
    return true;
}

int tms_handle_key_down( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    switch (tms_display_type)
    {
        case TMS_DISPLAY_FIRST_PAGE:
        {
            terminal_list_data.currentSel++;
            if (terminal_list_data.currentSel>=terminal_list_data.lineNum)
                terminal_list_data.currentSel = 0;
            break;
        }
        default:
        {
            break;
        }
    }
    return true;
}

int tms_handle_key_enter( WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    switch (tms_display_type)
    {
        case TMS_DISPLAY_FIRST_PAGE:
        {
            if (terminal_list_data.data[terminal_list_data.currentSel].enter_type!=TMS_DISPLAY_EMPTY)
            {
                tms_display_type = terminal_list_data.data[terminal_list_data.currentSel].enter_type;
                terminal_detail_data.terminal_index = terminal_list_data.data[terminal_list_data.currentSel].enter_index;
            }
            break;
        }

        default:
        {
            break;
        }
    }
    return true;
}

int tms_handle_key_escape( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    switch (tms_display_type)
    {
        case TMS_DISPLAY_FIRST_PAGE:
        {
            break;
        }
        case TMS_DISPLAY_TERMINAL_LIST:
        {
            tms_display_type = TMS_DISPLAY_FIRST_PAGE;
            break;
        }

        default:
        {
            break;
        }
    }
    return true;
}

int tms_handle_key_h(WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    //输出本窗口的帮助信息，再按一次'h'消失
    return true;
}


int draw_first_page( WINDOW_TYPE win_type)
{
#if 1 //__DEF_PIL
    TMS_TERMINAL_RECORD *ptr = NULL;
    char tmp[256] = {0};
    int i;
    int opage, page, sumpages, start_idx;
    int connectCount = 0;
    int loginCount = 0;

    //输出table的标题
    sprintf(tmp, "      Used   termCode     agencyCode   areaCode   ncpIdx    work       IsBusy MSN  FlowNumber Mac");
    print_tbl_header(win_type, tmp);

    opage = terminal_list_data.current_display_page;
    page = terminal_list_data.current_display_page;
    start_idx = getStartIndexByPage(&page, &sumpages, tms_database_ptr->termCount, tms_win_lins);
    terminal_list_data.current_display_page = page;
    terminal_list_data.page_start_index = start_idx;
    if (opage!=page)
        terminal_list_data.currentSel = 0;

    //输出table 的明细
    terminal_list_data.lineNum = 0;
    for (i=terminal_list_data.page_start_index;i<MAX_TERMINAL_NUMBER;i++)
    {
        ptr = &tms_database_ptr->arrayTerm[i];

        if (ptr->used && (ptr->workStatus==TELLER_WORK_SIGNIN))
        {
            loginCount++;
        }

        if (terminal_list_data.lineNum >= tms_win_lins)
        {
            continue;
        }
        else
        {
            memset(tmp, 0, 256);
            if (!ptr->used)
            {
                tmp[0] = '-';
                goto end_draw;
            }
                //continue;

            char workStatustmp[40];
            memset(workStatustmp, 0, sizeof(workStatustmp));

            switch(ptr->workStatus)
            {
                default:
                    strcpy(workStatustmp, "Unknown");
                    break;
                case TELLER_WORK_SIGNIN:
                    strcpy(workStatustmp, "SignIn");
                    break;
                case TELLER_WORK_SIGNOUT:
                    strcpy(workStatustmp, "SignOut");
                    break;
            }

            sprintf(tmp, "%-5d %-4c %-12.12lld   %-12.10lld %-12.10d %-6d %-10s  %-6c %-4d %-10lld %02x-%02x-%02x-%02x-%02x-%02x",
                    ptr->index,
                    ptr->used?'Y':'N',
                    ptr->termCode,
                    ptr->agencyCode,
                    ptr->areaCode,
                    ptr->ncpIdx,
                    workStatustmp,
                    ptr->isBusy?'Y':'N',
                    ptr->msn,
                    ptr->flowNumber,
                    ptr->szMac[0],
                    ptr->szMac[1],
                    ptr->szMac[2],
                    ptr->szMac[3],
                    ptr->szMac[4],
                    ptr->szMac[5]);

  end_draw: if (terminal_list_data.currentSel==terminal_list_data.lineNum)
            {
                terminal_list_data.data[terminal_list_data.currentSel].enter_type = TMS_DISPLAY_TERMINAL_LIST;
                print_tbl_line_str_reverse(win_type, terminal_list_data.lineNum+tms_win_top_line, 2, tmp);
            }
            else
            {
                print_tbl_line_str(win_type, terminal_list_data.lineNum+tms_win_top_line, 2, tmp);
            }
            terminal_list_data.lineNum++;
        }
    }

    //输出统计信息
    sprintf(tmp, "terminalCount[ %d ]  loginCount[ %d ]",
        tms_database_ptr->termCount, loginCount);
    print_tbl_statistic_info(win_type, tmp);

    //输出分页的信息
    sprintf(tmp, "- pages[%d] curpage[%d] -", sumpages, page );
    print_tbl_page_info(win_type, tmp);
#endif

    return true;
}



int draw_terminal_list( WINDOW_TYPE win_type )
{
#if 1 //__DEF_PIL

    char tmp[256] = {0};
    int count = 0;
    TMS_TERMINAL_RECORD *ptr =NULL;

    //输出table的标题
    sprintf(tmp, "Terminal Detail Information");
    print_tbl_header(win_type, tmp);

    //access ncp_index
    ptr = &tms_database_ptr->arrayTerm[terminal_list_data.page_start_index + terminal_list_data.currentSel];

    memset(tmp, 0, 256);

    sprintf(tmp, "No.[%d]               used[%c]   index[%d]",
        terminal_list_data.page_start_index + terminal_list_data.currentSel,
        ptr->used?'Y':'N', ptr->index);
    print_tbl_line_str(win_type, count+tms_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "termCode[%lld]       agencyCode[%lld]    areaCode[%d]",
        ptr->termCode, ptr->agencyCode, ptr->areaCode);
    print_tbl_line_str(win_type, count+tms_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "Mac[ %02x-%02x-%02x-%02x-%02x-%02x ]",
        ptr->szMac[0], ptr->szMac[1], ptr->szMac[2],
        ptr->szMac[3], ptr->szMac[4], ptr->szMac[5]);
    print_tbl_line_str(win_type, count+tms_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "ncpIdx[%d]     workStatus[%s]",
        ptr->ncpIdx,
        (ptr->workStatus==TELLER_WORK_SIGNIN)?"SignIn":((ptr->workStatus==TELLER_WORK_SIGNOUT)?"SignOut":"Unknown")
    );
    print_tbl_line_str(win_type, count+tms_win_top_line, 2, tmp);
    count++;

    char buf_time[64] = {0};
    fmt_time_t(ptr->token_last_update, DATETIME_FORMAT_EN, buf_time);
	sprintf(tmp, "Token[ %llu ]  Token Expired[ %s ]", ptr->token, buf_time);
    print_tbl_line_str(win_type, count+tms_win_top_line, 2, tmp);
    count++;

    memset(buf_time, 0, sizeof(buf_time));
    fmt_time_t(ptr->lastCommTime, DATETIME_FORMAT_EN, buf_time);
    sprintf(tmp, "lastCommTime [ %s ]", buf_time);
    print_tbl_line_str(win_type, count+tms_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "last message crc[ %d ]", ptr->last_crc);
    print_tbl_line_str(win_type, count+tms_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "retryCount[%d]      nMSN[%d]    flowNumber[%lld]",
        ptr->retryCount, ptr->msn, ptr->flowNumber);
    print_tbl_line_str(win_type, count+tms_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "tellerCode[%d]",
        ptr->tellerCode);
    print_tbl_line_str(win_type, count+tms_win_top_line, 2, tmp);
    count++;

    refresh_tbl_win(win_type);
#endif
    return true;
}



int tms_setAllBusyFree(WINDOW_TYPE win_type, int cid)
{
    ts_notused(win_type);
    int32 termIdx= MASK_CID(cid);
    TMS_TERMINAL_RECORD *ptr = tms_mgr()->getTermByIndex(termIdx);
    if (ptr != NULL) {
        ptr->isBusy = 0;
    }
    return true;
}

//主机专用，确保：转换后的16进制仅含数字，不含字母
int int2hex(int num)
{
	int i = num;
	int j = 0;
	int n = 0;
	char s[17]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
	char k[30] = {0};
	char arr[30] = {0};
	while(i != 0)
	{
		j = i % 16;
		k[n] = s[j];
		i /= 16;
		n++;
	}
	i = 0;
	for (int idx = n - 1; idx >= 0; idx--, i++)
	{
		arr[i] = k[idx];
	}

	return atol(arr);
}

