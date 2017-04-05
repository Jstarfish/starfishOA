#include "tsview.h"
#include "ncpc_inf.h"

bool ncpc_init_flag = false;

bool ncpc_error_flag = false;
NCPC_DATABASE_PTR ncpc_database_ptr = NULL;

typedef enum _NCPC_DISPALY_TYPE
{
    NCPC_DISPLAY_EMPTY = 0,
    NCPC_DISPLAY_LIST,
    NCPC_DISPLAY_DETAIL
}NCPC_DISPALY_TYPE;


//�ڿ��ƶ������� �� ������ҳ����  �����û����Զ�������
typedef struct _list_ncp_info
{
    NCPC_DISPALY_TYPE enter_type;
    int enter_index;                //����س����Ľ���ʾ����������
}list_ncp_info;


//NCPC_DISPLAY_LIST    ncpc list ҳ�������
typedef struct _display_list_ncp_data
{
    unsigned int current_display_page;      //��ǰ��Ҫ��ʾ��һҳ
    unsigned int page_start_index;          //��ǰҳ��ʾ��ncp��������ʼ
    int currentSel;            //��ǰѡ����к�
    int lineNum;               //��ǰҳ��ʾ��������
    //
    list_ncp_info data[MAIN_WIN_MAX_LINE];     //����������  ÿҳ��ʾ����Ӧ�ò��ᳬ��40
}display_list_ncp_data;


//NCPC_DISPLAY_DETAIL  ncpc detail ҳ�������
typedef struct _display_detail_ncp_data
{
    int ncp_index;         //ncpc����������

    list_ncp_info data;     //����������
}display_detail_ncp_data;

#define ncpc_win_top_line       4
#define ncpc_win_buttom_line    (MAIN_WIN_STATUS_LINE-2)

#define ncpc_win_lins  (ncpc_win_buttom_line-ncpc_win_top_line+1)


//��ǰ����ʾģʽ
static NCPC_DISPALY_TYPE ncpc_display_type = NCPC_DISPLAY_EMPTY;
static NCPC_DISPALY_TYPE ncpc_display_type_keep = NCPC_DISPLAY_EMPTY;


//����ҳ����ʾ�ı�������
static display_list_ncp_data ncp_list_data;
static display_detail_ncp_data ncp_detail_data;


//�����ӿ�------------------------------------------------------------------
int draw_ncpc_list( WINDOW_TYPE win_type);

int draw_ncpc_detail( WINDOW_TYPE win_type );

int ncpc_handle_key_left( WINDOW_TYPE win_type);

int ncpc_handle_key_right( WINDOW_TYPE win_type);

int ncpc_handle_key_up( WINDOW_TYPE win_type);

int ncpc_handle_key_down( WINDOW_TYPE win_type);

int ncpc_handle_key_enter( WINDOW_TYPE win_type);

int ncpc_handle_key_escape( WINDOW_TYPE win_type);

int ncpc_handle_key_h(WINDOW_TYPE win_type);


//--------------------------------------------------------------------------

int init_win_ncpc(WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    if (ncpc_init_flag)
        return 0;

    //ӳ��NCPC�����ڴ���
    if (!ncpc_init())
    {
        logit("ERROR:  ncpc_init failure!");
        ncpc_error_flag = true;
        return false;
    }
    ncpc_database_ptr = ncpc_getDatabasePtr();

    memset(&ncp_list_data, 0, sizeof(display_list_ncp_data));
    memset(&ncp_detail_data, 0, sizeof(display_detail_ncp_data));

    ncp_list_data.current_display_page = 1;
    ncp_list_data.page_start_index = 0;

    ncp_detail_data.ncp_index = 0;

    ncpc_display_type = NCPC_DISPLAY_LIST;
    ncpc_init_flag = true;
    return true;
}

int close_win_ncpc( WINDOW_TYPE win_type )
{
    ts_notused(win_type);

    if (ncpc_error_flag)
        return false;

    ncpc_init_flag = false;
    //ncpc_close();
    return true;
}

int draw_win_ncpc( WINDOW_TYPE win_type )
{
    if (ncpc_display_type != ncpc_display_type_keep)
    {
        //���windows����
        clear_tbl_win(win_type);

        //�����ǰģ����
        print_tbl_module_name(win_type);

        ncpc_display_type_keep = ncpc_display_type;
    }
    
    if (ncpc_error_flag)
        return false;

    switch (ncpc_display_type)
    {
        case NCPC_DISPLAY_LIST:
        {
            draw_ncpc_list(win_type);
            break;
        }
        case NCPC_DISPLAY_DETAIL:
        {
            draw_ncpc_detail(win_type);
            break;
        }
        default:
        {
            logit("ncpc display type error!!");
            break;
        }
    }

    refresh_tbl_win(win_type);
    return true;
}

int handle_win_ncpc( WINDOW_TYPE win_type, int ch )
{
    if (ncpc_error_flag)
        return false;

    switch(ch)
    {
        case KEY_UP:
            ncpc_handle_key_up(win_type);
            break;
        case KEY_DOWN:
            ncpc_handle_key_down(win_type);
            break;
        case KEY_LEFT:
            ncpc_handle_key_left(win_type);
            break;
        case KEY_RIGHT:
            ncpc_handle_key_right(win_type);
            break;
        case 10:     //enter
            ncpc_handle_key_enter(win_type);
            break;
        case 27:    //escapt
        case 96:    //`
            ncpc_handle_key_escape(win_type);
            break;
        case 'h':
            ncpc_handle_key_h(win_type);
            break;
        default:
            break;
    }
    draw_win_ncpc(win_type);
    return true;
}

int command_win_ncpc( WINDOW_TYPE win_type, char *cmdstr, int length )
{
    ts_notused(win_type);
    ts_notused(cmdstr);
    ts_notused(length);

    if (ncpc_error_flag)
        return false;

    return true;
}

int refresh_win_ncpc( WINDOW_TYPE win_type)
{
    if (ncpc_error_flag)
        return false;

    draw_win_ncpc(win_type);
    return true;
}


//-------�Զ��庯��-----------------------------------------------------------------

int ncpc_handle_key_left( WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    switch (ncpc_display_type)
    {
        case NCPC_DISPLAY_LIST:
        {
            //��ǰ��ҳ
            ncp_list_data.current_display_page--;
            break;
        }
        case NCPC_DISPLAY_DETAIL:
        {
            if (ncp_detail_data.ncp_index>0)
            {
                ncp_detail_data.ncp_index = ncp_detail_data.ncp_index - 1;
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

int ncpc_handle_key_right( WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    switch (ncpc_display_type)
    {
        case NCPC_DISPLAY_LIST:
        {
            //���ҳ
            ncp_list_data.current_display_page++;
            break;
        }
        case NCPC_DISPLAY_DETAIL:
        {
            if ( ncp_detail_data.ncp_index < (MAX_NCP_NUMBER-1) )
                ncp_detail_data.ncp_index = ncp_detail_data.ncp_index + 1;
            break;
        }
        default:
        {
            break;
        }
    }
    return true;
}

int ncpc_handle_key_up( WINDOW_TYPE win_type)
{
    ts_notused(win_type);

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
    return true;
}

int ncpc_handle_key_down( WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    switch (ncpc_display_type)
    {
        case NCPC_DISPLAY_LIST:
        {
            ncp_list_data.currentSel++;
            if (ncp_list_data.currentSel>=ncp_list_data.lineNum)
                ncp_list_data.currentSel = 0;
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
    return true;
}

int ncpc_handle_key_enter( WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    switch (ncpc_display_type)
    {
        case NCPC_DISPLAY_LIST:
        {
            ncpc_display_type = ncp_list_data.data[ncp_list_data.currentSel].enter_type;
            ncp_detail_data.ncp_index = ncp_list_data.data[ncp_list_data.currentSel].enter_index;
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
    return true;
}

int ncpc_handle_key_escape( WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    switch (ncpc_display_type)
    {
        case NCPC_DISPLAY_LIST:
        {
            break;
        }
        case NCPC_DISPLAY_DETAIL:
        {
            ncpc_display_type = NCPC_DISPLAY_LIST;
            break;
        }
        default:
        {
            break;
        }
    }
    return true;
}

int ncpc_handle_key_h(WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    return true;
}


//����listҳ��
int draw_ncpc_list( WINDOW_TYPE win_type)
{
    NCP_RECORD *ptr = NULL;
    char tmp[256] = {0};
    int i;
    int count_sum = 0;
    int count_conn = 0;
    int opage, page, sumpages, start_idx;

    //���table�ı���
    sprintf(tmp, "    Used ncpCode  type  IpAddr          conn  connectNum sendPkgNum recvPkgNum abnormalPkgNum");
    print_tbl_header(win_type, tmp);

    opage = ncp_list_data.current_display_page;
    page = ncp_list_data.current_display_page;
    start_idx = getStartIndexByPage(&page, &sumpages, MAX_NCP_NUMBER, ncpc_win_lins);
    ncp_list_data.current_display_page = page;
    ncp_list_data.page_start_index = start_idx;
    if (opage!=page)
        ncp_list_data.currentSel = 0;

    //���table ����ϸ
    ncp_list_data.lineNum = 0;
    for (i=ncp_list_data.page_start_index;i<MAX_NCP_NUMBER;i++)
    {
        ptr = &ncpc_database_ptr->ncpArray[i];
        if (ptr->used)
        {
            count_sum++;
            if (ptr->connect)
                count_conn++;
        }

        if (ncp_list_data.lineNum >= ncpc_win_lins)
        {
            continue;
        }
        else
        {
            memset(tmp, 0, 256);

            sprintf(tmp, "%-3d %-4c %-8d %s  %-15s %-4c  %-10u %-10lld %-10lld %lld",
                    i,
                    ptr->used?'Y':'N',
                    ptr->ncpCode,
                    ptr->type?"HTTP":"TCP ",
                    ptr->ipAddr,
                    ptr->connect?'Y':'N',
                    ptr->connectNum,
                    ptr->sendPkgNum,
                    ptr->recvPkgNum,
                    ptr->abnormalPkgNum);

            if (ncp_list_data.currentSel==ncp_list_data.lineNum)
            {
                ncp_list_data.data[ncp_list_data.currentSel].enter_type = NCPC_DISPLAY_DETAIL;
                ncp_list_data.data[ncp_list_data.currentSel].enter_index = i;
                print_tbl_line_str_reverse(win_type, ncp_list_data.lineNum+ncpc_win_top_line, 2, tmp);
            }
            else
            {
                print_tbl_line_str(win_type, ncp_list_data.lineNum+ncpc_win_top_line, 2, tmp);
            }
            ncp_list_data.lineNum++;
        }
    }

    //���ͳ����Ϣ
    sprintf(tmp, "max_ncp[ %d ] UsedCount[ %d ] connect[ %d ]", MAX_NCP_NUMBER, count_sum, count_conn);
    print_tbl_statistic_info(win_type, tmp);

    //�����ҳ����Ϣ
    sprintf(tmp, "- pages[%d] curpage[%d] -", sumpages, page );
    print_tbl_page_info(win_type, tmp);

    return true;
}


int draw_ncpc_detail( WINDOW_TYPE win_type )
{
    char tmp[256] = {0};
    int count = 0;
    NCP_RECORD *ptr =NULL;
    
    //���table�ı���
    sprintf(tmp, "Ncp Detail Information");
    print_tbl_header(win_type, tmp);

    //access ncp_index
    ptr = &ncpc_database_ptr->ncpArray[ncp_detail_data.ncp_index];
    
    memset(tmp, 0, 256);

    sprintf(tmp, "index [ %d ]", ncp_detail_data.ncp_index);
    print_tbl_line_str(win_type, count+ncpc_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "used [ %c ]", ptr->used?'Y':'N');
    print_tbl_line_str(win_type, count+ncpc_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "ncpCode [ %d ]", ptr->ncpCode);
    print_tbl_line_str(win_type, count+ncpc_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "type [ %d ]", ptr->type);
    print_tbl_line_str(win_type, count+ncpc_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "IpAddr [ %s ]", ptr->ipAddr);
    print_tbl_line_str(win_type, count+ncpc_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "connect [ %c ]", ptr->connect?'Y':'N');
    print_tbl_line_str(win_type, count+ncpc_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "sendPkgNum [ %lld ]", ptr->sendPkgNum);
    print_tbl_line_str(win_type, count+ncpc_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "recvPkgNum [ %lld ]", ptr->recvPkgNum);
    print_tbl_line_str(win_type, count+ncpc_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "abnormalPkgNum [ %lld ]", ptr->abnormalPkgNum);
    print_tbl_line_str(win_type, count+ncpc_win_top_line, 2, tmp);

    refresh_tbl_win(win_type);

    return true;
}

