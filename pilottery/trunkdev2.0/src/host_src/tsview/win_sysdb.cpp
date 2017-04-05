#include "tsview.h"
#include "sysdb_inf.h"

bool sysdb_init_flag = false;

bool sysdb_error_flag = false;

#define sysdb_win_top_line       4
#define sysdb_win_buttom_line    (MAIN_WIN_STATUS_LINE-2)

#define sysdb_win_lins  (sysdb_win_buttom_line-sysdb_win_top_line+1)


SYS_DATABASE * sysdb_database_ptr = NULL;

typedef enum _SYSDB_DISPALY_TYPE
{
    SYSDB_DISPLAY_EMPTY = 0,
    SYSDB_DISPLAY_LIST,
    SYSDB_DISPLAY_INFO_LIST,
    SYSDB_DISPLAY_CONFIG_DATA_LIST,
    SYSDB_DISPLAY_TASK_LIST
}SYSDB_DISPALY_TYPE;


//在可移动的行上 或 单独的页面上  定义用户的自定义数据
typedef struct _list_sysdb_info
{
    SYSDB_DISPALY_TYPE enter_type;
    int enter_index;                //定义回车键的将显示的数组索引
}list_sysdb_info;


//SYSDB_DISPLAY_LIST     list 页面的数据
typedef struct _display_list_sysdb_data
{
    unsigned int current_display_page;      //当前需要显示那一页
    unsigned int page_start_index;          //当前页显示的ncp索引的起始
    int currentSel;            //当前选择的行号
    int lineNum;               //当前页显示的总行数
    //
    list_sysdb_info data[MAIN_WIN_MAX_LINE];     //行索引数据  每页显示行数应该不会超过40
}display_list_sysdb_data;


//SYSDB_DISPLAY_TASK_LIST 页面的数据
typedef struct _display_task_list_sysdb_data
{
    int currentSel;            //当前选择的行号
    int lineNum;

    list_sysdb_info data[MAIN_WIN_MAX_LINE];
}display_task_list_sysdb_data;


//当前的显示模式
static SYSDB_DISPALY_TYPE sysdb_display_type = SYSDB_DISPLAY_EMPTY;
static SYSDB_DISPALY_TYPE sysdb_display_type_keep = SYSDB_DISPLAY_EMPTY;


//定义页面显示的变量数据
static display_list_sysdb_data      sysdb_list_data;
static display_task_list_sysdb_data sysdb_task_list_data;

int draw_sysdb_list( WINDOW_TYPE win_type);
int draw_sysdb_info_list( WINDOW_TYPE win_type);
int draw_sysdb_config_list( WINDOW_TYPE win_type);
int draw_sysdb_task_list( WINDOW_TYPE win_type);


int sysdb_handle_key_left( WINDOW_TYPE win_type);

int sysdb_handle_key_right( WINDOW_TYPE win_type);

int sysdb_handle_key_up( WINDOW_TYPE win_type);

int sysdb_handle_key_down( WINDOW_TYPE win_type);

int sysdb_handle_key_enter( WINDOW_TYPE win_type);

int sysdb_handle_key_escape( WINDOW_TYPE win_type);

int sysdb_handle_key_h(WINDOW_TYPE win_type);

int init_win_sysdb(WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    if (sysdb_init_flag)
        return 0;

    if (!sysdb_init())
    {
        sysdb_error_flag = true;
        logit("ERROR:  sysdb_init failure!");
        return false;
    }
    sysdb_database_ptr = sysdb_getDatabasePtr();
    memset(&sysdb_list_data, 0, sizeof(display_list_sysdb_data));
    sysdb_list_data.current_display_page = 1;
    sysdb_list_data.page_start_index = 0;
    memset(&sysdb_task_list_data, 0, sizeof(display_task_list_sysdb_data));

    sysdb_display_type = SYSDB_DISPLAY_LIST;
    sysdb_init_flag = true;
    return true;
}

int close_win_sysdb( WINDOW_TYPE win_type )
{
    ts_notused(win_type);

    if (sysdb_error_flag)
        return false;

    sysdb_init_flag = false;
    //sysdb_close();
    return true;
}

int draw_win_sysdb( WINDOW_TYPE win_type )
{
    if (sysdb_display_type != sysdb_display_type_keep)
    {
        //清除windows内容
        clear_tbl_win(win_type);

        //输出当前模块名
        print_tbl_module_name(win_type);

        sysdb_display_type_keep = sysdb_display_type;
    }
    
    if (sysdb_error_flag)
        return false;

    switch (sysdb_display_type)
    {
        case SYSDB_DISPLAY_LIST:
        {
            draw_sysdb_list(win_type);
            break;
        }
        case SYSDB_DISPLAY_INFO_LIST:
        {
            draw_sysdb_info_list(win_type);
            break;
        }
        case SYSDB_DISPLAY_CONFIG_DATA_LIST:
        {
            draw_sysdb_config_list(win_type);
            break;
        }
        case SYSDB_DISPLAY_TASK_LIST:
        {
            draw_sysdb_task_list(win_type);
            break;
        }
        default:
        {
            log_error("sysdb display type error!!");
            break;
        }
    }

    refresh_tbl_win(win_type);
    return 0;

}
int draw_sysdb_list( WINDOW_TYPE win_type)
{
    char tmp[1024] = {0};

    //输出统计信息
    sprintf(tmp, "           ");
    print_tbl_statistic_info(win_type, tmp);

    //输出table的标题
    sprintf(tmp, "%-10s","menu list");
    print_tbl_header(win_type, tmp);

    //输出table 的明细
    sysdb_list_data.lineNum = 0;       
    
    sprintf(tmp,"%-10s" ,  "System data");
    if (sysdb_list_data.currentSel==sysdb_list_data.lineNum)
    {
        sysdb_list_data.data[sysdb_list_data.currentSel].enter_type = SYSDB_DISPLAY_INFO_LIST;
        sysdb_list_data.data[sysdb_list_data.currentSel].enter_index = 0;
        print_tbl_line_str_reverse(win_type, sysdb_list_data.lineNum+sysdb_win_top_line, 2, tmp);
    }
    else
    {
        print_tbl_line_str(win_type, sysdb_list_data.lineNum+sysdb_win_top_line, 2, tmp);
    }
    sysdb_list_data.lineNum++;
   

    sprintf(tmp,"%-10s", "Config data");
    if (sysdb_list_data.currentSel==sysdb_list_data.lineNum)
    {
        sysdb_list_data.data[sysdb_list_data.currentSel].enter_type = SYSDB_DISPLAY_CONFIG_DATA_LIST;
        sysdb_list_data.data[sysdb_list_data.currentSel].enter_index = 0;
        print_tbl_line_str_reverse(win_type, sysdb_list_data.lineNum+sysdb_win_top_line, 2, tmp);
    }
    else
    {
        print_tbl_line_str(win_type, sysdb_list_data.lineNum+sysdb_win_top_line, 2, tmp);
    }
    sysdb_list_data.lineNum++;


    sprintf(tmp,"%-10s", "Task list ->");
    if (sysdb_list_data.currentSel==sysdb_list_data.lineNum)
    {
        sysdb_list_data.data[sysdb_list_data.currentSel].enter_type = SYSDB_DISPLAY_TASK_LIST;
        sysdb_list_data.data[sysdb_list_data.currentSel].enter_index = 0;
        print_tbl_line_str_reverse(win_type, sysdb_list_data.lineNum+sysdb_win_top_line, 2, tmp);
    }
    else
    {
        print_tbl_line_str(win_type, sysdb_list_data.lineNum+sysdb_win_top_line, 2, tmp);
    }
    sysdb_list_data.lineNum++;

    //输出分页的信息
    sprintf(tmp, "- pages[%d] curpage[%d] -", 1, 1 );
    print_tbl_page_info(win_type, tmp);
    
    
    return 0;
}


const char *get_SystemStatus(SYS_STATUS status)
{
    switch(status)
    {
        case SYS_STATUS_EMPTY:
        {
            return "SYS_STATUS_EMPTY";
        }
        case SYS_STATUS_DATA_SYNC:
        {
            return "SYS_STATUS_DATA_SYNC";
        }
        case SYS_STATUS_DATA_LOAD:
        {
            return "SYS_STATUS_DATA_LOAD";
        }
        case SYS_STATUS_DATA_RESUME:
        {
            return "SYS_STATUS_DATA_RESUME";
        }
        case SYS_STATUS_BUSINESS:
        {
            return "SYS_STATUS_BUSINESS";
        }
        case SYS_STATUS_END:
        {
            return "SYS_STATUS_END";
        }
        default:
        {
            return "*-UNKNOW_STATUS-*";;
        }
    }
}


int draw_sysdb_info_list( WINDOW_TYPE win_type)
{
    char tmp[1024] = {0};
    
    //输出统计信息
    sprintf(tmp, "              ");
    print_tbl_statistic_info(win_type, tmp);
    int line  = 3;

    char buf_time[64] = {0};

    sprintf(tmp,"System Version = [%u]", sysdb_database_ptr->version);
    print_tbl_str(win_type, line, 2, tmp);
    line++;

    sprintf(tmp,"Log Level = [%u]", sysdb_database_ptr->log_level);
    print_tbl_str(win_type, line, 2, tmp);
    line++;

    sprintf(tmp,"Machine Code = [%u]", sysdb_database_ptr->machineCode);
    print_tbl_str(win_type, line, 2, tmp);
    line++;

    fmt_time_t(sysdb_database_ptr->sysStartTime, DATETIME_FORMAT_EN, buf_time);
    sprintf(tmp,"System Start Time = [%s]", buf_time);
    print_tbl_str(win_type, line, 2, tmp);
    line++;

    fmt_time_t(sysdb_database_ptr->sysRunningTime, DATETIME_FORMAT_EN, buf_time);
    sprintf(tmp,"System Running Time = [%s]", buf_time);
    print_tbl_str(win_type, line, 2, tmp);
    line++;

    sprintf(tmp,"System Status = [%s]", get_SystemStatus(sysdb_database_ptr->sysStatus));
    print_tbl_str(win_type, line, 2, tmp);
    line++;

    sprintf(tmp,"Safe close flag = [%u]", sysdb_database_ptr->safeClose);
    print_tbl_str(win_type, line, 2, tmp);
    line++;

    sprintf(tmp,"Current Session = [%u]", sysdb_database_ptr->sessionDate);
    print_tbl_str(win_type, line, 2, tmp);
    line++;

    sprintf(tmp,"Switch Session Time = [%02d:%02d]", (sysdb_database_ptr->switch_session_time/100), (sysdb_database_ptr->switch_session_time%100));
    print_tbl_str(win_type, line, 2, tmp);
    line++;

    sprintf(tmp,"Switch Session Send Flag = [%s]", (sysdb_database_ptr->send_switch_session_flag)?"true":"false");
    print_tbl_str(win_type, line, 2, tmp);
    line++;

    return 0;
}


int draw_sysdb_config_list( WINDOW_TYPE win_type)
{
    char tmp[1024] = {0};
    int line_num = 3;
    
    //输出统计信息
    sprintf(tmp, "              ");
    print_tbl_statistic_info(win_type, tmp);

	sprintf(tmp,"MachineCode = [%d]  " ,  sysdb_database_ptr->machineCode);
    print_tbl_str(win_type, line_num, 2, tmp);
    line_num += 2;

	sprintf(tmp,"Version = [%d]  " ,  sysdb_database_ptr->version);
    print_tbl_str(win_type, line_num, 2, tmp);
    line_num += 2;

	sprintf(tmp,"Token TimeOut = [%d]  " ,  sysdb_database_ptr->token_expired);
    print_tbl_str(win_type, line_num, 2, tmp);
    line_num += 2;

    sprintf(tmp,"NCP Server Port = [%d]  " ,  sysdb_database_ptr->ncp_port);
    print_tbl_str(win_type, line_num, 2, tmp);
    line_num += 2;
    sprintf(tmp,"NCP HTTP Server Port = [%d]  " ,  sysdb_database_ptr->ncp_http_port);
    print_tbl_str(win_type, line_num, 2, tmp);
    line_num += 2;

	sprintf(tmp,"Rng Server Port = [%d]  " ,  sysdb_database_ptr->rng_port);
    print_tbl_str(win_type, line_num, 2, tmp);
    line_num += 2;

	sprintf(tmp,"OMS Monitor --- >\n");
	print_tbl_str(win_type, line_num, 2, tmp);
    line_num++;
	sprintf(tmp,"IP = [%s]  Port = [%d]", sysdb_database_ptr->oms_monitor.oms_monitor_ip, sysdb_database_ptr->oms_monitor.oms_monitor_port);
    print_tbl_str(win_type, line_num, 2, tmp);
    line_num += 2;
/*
    char buf_time_1[64] = {0};
	char buf_time_2[64] = {0};
	sprintf(tmp,"OMS Database --- >\n");
	print_tbl_str(win_type, line_num, 2, tmp);
    line_num++;
	sprintf(tmp,"URL = [%s]  Username = [%s]  Password = [%s]",
        sysdb_database_ptr->db_oms.url, sysdb_database_ptr->db_oms.username, sysdb_database_ptr->db_oms.password);
    print_tbl_str(win_type, line_num, 2, tmp);
    line_num++;
	fmt_time_t(sysdb_database_ptr->db_oms.last_except_time, DATETIME_FORMAT_EN, buf_time_1);
	sprintf(tmp,"LastErrorTime = [%s]  ErrorCode = [%s] Error Information = [%s]",
        buf_time_1, sysdb_database_ptr->db_oms.except_code, sysdb_database_ptr->db_oms.except_info);
    print_tbl_str(win_type, line_num, 2, tmp);
    line_num += 2;

	sprintf(tmp,"MIS Database --- >\n");
	print_tbl_str(win_type, line_num, 2, tmp);
    line_num++;
	sprintf(tmp,"URL = [%s]  Username = [%s]  Password = [%s]",
        sysdb_database_ptr->db_mis.url, sysdb_database_ptr->db_mis.username, sysdb_database_ptr->db_mis.password);
    print_tbl_str(win_type, line_num, 2, tmp);
    line_num++;
	fmt_time_t(sysdb_database_ptr->db_mis.last_except_time, DATETIME_FORMAT_EN, buf_time_1);
	sprintf(tmp,"LastErrorTime = [%s]  ErrorCode = [%s] Error Information = [%s]",
        buf_time_1, sysdb_database_ptr->db_mis.except_code, sysdb_database_ptr->db_mis.except_info);
    print_tbl_str(win_type, line_num, 2, tmp);
    line_num += 2;
*/
    sprintf(tmp, "Currency Exchange Rates --- >\n");
    print_tbl_str(win_type, line_num, 2, tmp);
    line_num++;
    sprintf(tmp, "riel to usd = [%u]", sysdb_database_ptr->riel_to_usd);
    print_tbl_str(win_type, line_num, 2, tmp);
    line_num++;

    return 0;
}


int draw_sysdb_task_list( WINDOW_TYPE win_type)
{
    char tmp[1024] = {0};
    char tmp1[80] = {0};
    int i;

    //输出统计信息
    sprintf(tmp, "            ");
    print_tbl_statistic_info(win_type, tmp);

    sysdb_task_list_data.lineNum = 0;

    //输出table的标题
    sprintf(tmp, "%-10s    %-20s      %-10s    %-23s    %s", "id", "name", "pid", "status", "startTime");
    print_tbl_header(win_type, tmp);

    SYS_TASK_RECORD * pTaskRecord = NULL;
    
    for ( i = (SYS_TASK_EMPTY+1) ; i < SYS_TASK_END ; i++ )
    {
        pTaskRecord = (SYS_TASK_RECORD *)&sysdb_database_ptr->taskArray[i];
        if (!pTaskRecord->used)
            continue;

        switch(pTaskRecord->taskStatus)
        {
            case SYS_TASK_STATUS_EMPTY:
            {
                 sprintf(tmp1 , "TASK_STATUS_EMPTY");
                 break;   
            }
            case SYS_TASK_STATUS_START :
            {
                 sprintf(tmp1 , "TASK_STATUS_START");
                 break;   
            }
            case SYS_TASK_STATUS_RUN:
            {
                 sprintf(tmp1 , "TASK_STATUS_RUN");
                 break;   
            }
            case SYS_TASK_STATUS_EXIT:
            {
                 sprintf(tmp1 , "SYS_TASK_STATUS_EXIT");
                 break;   
            }
            case SYS_TASK_STATUS_CRASH:
            {
                 sprintf(tmp1 , "TASK_STATUS_CRASH");
                 break;   
            }
        }

        char buf_time[64] = {0};
        if (pTaskRecord->taskStartTime != 0)
            fmt_time_t(pTaskRecord->taskStartTime, DATETIME_FORMAT_EN, buf_time);

    	sprintf(tmp, "%-10d    %-20s      %-10d    %-23s    %s",
                i,
                pTaskRecord->taskName,
                pTaskRecord->taskProcId,
                tmp1,
                buf_time);

        if (sysdb_task_list_data.currentSel==sysdb_task_list_data.lineNum)
        {
            sysdb_task_list_data.data[sysdb_task_list_data.currentSel].enter_index = i;
            print_tbl_line_str_reverse(win_type, sysdb_task_list_data.lineNum+sysdb_win_top_line, 2, tmp);
        }
        else
        {
            print_tbl_line_str(win_type, sysdb_task_list_data.lineNum+sysdb_win_top_line, 2, tmp);
        }
        sysdb_task_list_data.lineNum++;
    }

    return 0;
}

int sysdb_handle_key_left( WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    return 0;
}

int sysdb_handle_key_right( WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    return 0;
}
int sysdb_handle_key_down( WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    switch (sysdb_display_type)
    {
        case SYSDB_DISPLAY_LIST:
        {
            sysdb_list_data.currentSel++;
            if (sysdb_list_data.currentSel>=sysdb_list_data.lineNum)
                sysdb_list_data.currentSel = 0;
            break;
        }
        case SYSDB_DISPLAY_TASK_LIST:
        {
            sysdb_task_list_data.currentSel++;
            if (sysdb_task_list_data.currentSel>=sysdb_task_list_data.lineNum)
                sysdb_task_list_data.currentSel = 0;
            break;
        }
        case SYSDB_DISPLAY_INFO_LIST:
        case SYSDB_DISPLAY_CONFIG_DATA_LIST:
        {
            break;
        }
        default:
        {
            break;
        }
    }
    return 0;
}
int sysdb_handle_key_up( WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    switch (sysdb_display_type)
    {
        case SYSDB_DISPLAY_LIST:
        {
            sysdb_list_data.currentSel--;
            if (sysdb_list_data.currentSel<0)
                sysdb_list_data.currentSel = sysdb_list_data.lineNum-1;
            break;
        }
        case SYSDB_DISPLAY_TASK_LIST:
        {
            sysdb_task_list_data.currentSel--;
            if (sysdb_task_list_data.currentSel<0)
                sysdb_task_list_data.currentSel = sysdb_task_list_data.lineNum-1;
            break;
        }
        case SYSDB_DISPLAY_INFO_LIST:
        case SYSDB_DISPLAY_CONFIG_DATA_LIST:
        {
            break;
        }
        default:
        {
            break;
        }
    }
    return 0;
}

int sysdb_handle_key_enter( WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    switch (sysdb_display_type)
    {
        case SYSDB_DISPLAY_LIST:
        {
            sysdb_display_type = sysdb_list_data.data[sysdb_list_data.currentSel].enter_type;
            break;
        }
        case SYSDB_DISPLAY_TASK_LIST:
        {
            //任务编号
            int task_idx = sysdb_task_list_data.data[sysdb_task_list_data.currentSel].enter_index;
            SYS_TASK_RECORD * pTaskRecord = (SYS_TASK_RECORD *)&sysdb_database_ptr->taskArray[task_idx];
            if ((pTaskRecord->taskStatus == SYS_TASK_STATUS_CRASH) || (pTaskRecord->taskStatus == SYS_TASK_STATUS_EXIT))
            {
                char tmp[128] = {0};
                sprintf(tmp, "Task Name[%s] start.", pTaskRecord->taskName);

                //查询任务状态，显示对话框
                dialog_struct dlg;
                memset((char *)&dlg, 0, sizeof(dialog_struct));

                dlg.used = true;
                strcpy(dlg.title, "Task Control");

                dlg.inputFieldArray[0].used = true;
                strcpy(dlg.inputFieldArray[0].field_name, tmp);
                dlg.inputFieldArray[0].width = 1;
                dlg.inputFieldArray[0].cols = strlen(dlg.inputFieldArray[0].field_name) + 20;
                dlg.inputFieldArray[0].flag = 0;

                dialog_draw(&dlg);
                if (dlg.confirm == 0)
                {
                    //cancel dialog
                    break;
                }

                pTaskRecord->restartTask = 1;
                pTaskRecord->taskStartTime = 0;

                //判断任务当前运行状态
                logit("TASK IDX [%d] [%s]  %d", task_idx, pTaskRecord->taskName, SYSDB_DISPLAY_TASK_LIST);
            }
            break;
        }
        case SYSDB_DISPLAY_INFO_LIST:
        case SYSDB_DISPLAY_CONFIG_DATA_LIST:
        {
            break;
        }
        default:
        {
            break;
        }
    }
    return 0;
}
int sysdb_handle_key_escape( WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    switch (sysdb_display_type)
    {
        case SYSDB_DISPLAY_LIST:
        {
            break;
        }
        case SYSDB_DISPLAY_INFO_LIST:
        case SYSDB_DISPLAY_TASK_LIST:
        case SYSDB_DISPLAY_CONFIG_DATA_LIST:
        {
            sysdb_display_type = SYSDB_DISPLAY_LIST;
            break;
        }
        default:
        {
            break;
        }
    }
    return 0;
}

int sysdb_handle_key_h(WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    return 0;
}



int handle_win_sysdb( WINDOW_TYPE win_type, int ch )
{
    if (sysdb_error_flag)
        return false;

    switch(ch)
    {
        case KEY_UP:
            sysdb_handle_key_up(win_type);
            break;
        case KEY_DOWN:
            sysdb_handle_key_down(win_type);
            break;
        case KEY_LEFT:
            sysdb_handle_key_left(win_type);
            break;
        case KEY_RIGHT:
            sysdb_handle_key_right(win_type);
            break;
        case 10:     //enter
            sysdb_handle_key_enter(win_type);
            break;
        case 27:    //escapt
        case 96:    //`
            sysdb_handle_key_escape(win_type);
            break;
        case 'h':
            sysdb_handle_key_h(win_type);
            break;
        default:
            break;
    }
    draw_win_sysdb(win_type);
    return true;
}

int command_win_sysdb( WINDOW_TYPE win_type, char *cmdstr, int length )
{
    ts_notused(win_type);
    ts_notused(cmdstr);
    ts_notused(length);

    if (sysdb_error_flag)
        return false;

    return true;
}

int refresh_win_sysdb( WINDOW_TYPE win_type)
{
    if (sysdb_error_flag)
        return false;

    draw_win_sysdb( win_type );
    return true;
}

