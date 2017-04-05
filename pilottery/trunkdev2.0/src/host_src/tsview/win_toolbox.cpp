#include "tsview.h"
#include "tfe_inf.h"
#include "gl_inf.h"
#include "tms_inf.h"

//#include"gfp_mod.h"
//#include"gidb_mod.h"



//用户取消
#define ERR_USER_CANCEL  0

//参数输入错误
#define ERR_INPUT_PARAMETER  1
//没有找到
#define ERR_NOT_FIND  2
//处理失败
#define ERR_PROCESS_FAILURE 3

//当返回 ERR_PROCESS_FAILURE 时，存放错误字符串
char error_info[1024] = {0};


const char *saleFromStr[4] = {"","TERM","WPS","GUI"};



bool toolbox_error_flag = false;

#define toolbox_win_top_line       4
#define toolbox_win_buttom_line    (MAIN_WIN_STATUS_LINE-2)

#define toolbox_win_lins  (toolbox_win_buttom_line-toolbox_win_top_line+1)

//用于保存输入的条件数据
dialog_struct input_data;

typedef enum _TOOLBOX_DISPALY_TYPE
{
    TOOLBOX_DISPLAY_EMPTY = 0,
    TOOLBOX_DISPLAY_LIST,

    TOOLBOX_DISPLAY_SET_LOG_LEVEL,
    TOOLBOX_DISPLAY_TERMINAL_NO_BUSY,

    //del
    TOOLBOX_DISPLAY_AGENCY_INFO,
    TOOLBOX_DISPLAY_TERMINAL_INFO,

    TOOLBOX_DISPLAY_TELL_INFO,

    TOOLBOX_DISPLAY_SALE_TICKET_INFO,
    TOOLBOX_DISPLAY_WIN_TICKET_INFO,



}TOOLBOX_DISPALY_TYPE;


//在可移动的行上 或 单独的页面上  定义用户的自定义数据
typedef struct _list_toolbox_info
{
    TOOLBOX_DISPALY_TYPE enter_type;
    int enter_index;                //定义回车键的将显示的数组索引
    TOOLBOX_DISPALY_TYPE escapt_type;
}list_toolbox_info;

//TOOLBOX_DISPLAY_LIST     list 页面的数据
typedef struct _display_list_toolbox_data
{
    unsigned int current_display_page;      //当前需要显示那一页
    unsigned int page_start_index;          //当前页显示的ncp索引的起始
    int currentSel;            //当前选择的行号
    int lineNum;               //当前页显示的总行数
    //
    list_toolbox_info data[MAIN_WIN_MAX_LINE];     //行索引数据  每页显示行数应该不会超过40
}display_list_toolbox_data;

//定义页面显示的变量数据
static display_list_toolbox_data      toolbox_list_data;

//当前的显示模式
static TOOLBOX_DISPALY_TYPE toolbox_display_type = TOOLBOX_DISPLAY_EMPTY;
static TOOLBOX_DISPALY_TYPE toolbox_display_type_keep = TOOLBOX_DISPLAY_EMPTY;

SYS_DATABASE_PTR sys_database_ptr = NULL;

int draw_toolbox_list( WINDOW_TYPE win_type);
int pop_dialog(TOOLBOX_DISPALY_TYPE display_type);

bool toolbox_shm_init();
bool toolbox_shm_close();

int draw_log_level( WINDOW_TYPE win_type);
int draw_terminal_no_busy( WINDOW_TYPE win_type);

int draw_agency_info( WINDOW_TYPE win_type);
int draw_terminal_info( WINDOW_TYPE win_type);
int draw_tell_info( WINDOW_TYPE win_type);
int draw_sale_ticket( WINDOW_TYPE win_type);
int draw_win_ticket( WINDOW_TYPE win_type);







int init_win_toolbox(WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    toolbox_display_type = TOOLBOX_DISPLAY_LIST;

    if (toolbox_shm_init())
    {
    	sys_database_ptr = sysdb_getDatabasePtr();
    }

    memset((char *)&input_data, 0, sizeof(dialog_struct));

    return true;
}

int close_win_toolbox( WINDOW_TYPE win_type )
{
    ts_notused(win_type);
    if (toolbox_error_flag)
        return false;

    return true;
}

int draw_win_toolbox( WINDOW_TYPE win_type )
{
    //if (toolbox_display_type != toolbox_display_type_keep)
    {
        //清除windows内容
        clear_tbl_win(win_type);

        //输出当前模块名
        print_tbl_module_name(win_type);

        toolbox_display_type_keep = toolbox_display_type;
    }
    
    if (toolbox_error_flag)
        return false;

    switch (toolbox_display_type)
    {
		default:
		{
			log_error("toolbox display type error!!");
			break;
		}
		case TOOLBOX_DISPLAY_LIST:
		{
			draw_toolbox_list(win_type);
			break;
		}
		case TOOLBOX_DISPLAY_SET_LOG_LEVEL:
		{
			draw_log_level(win_type);
			break;
		}
		case TOOLBOX_DISPLAY_TERMINAL_NO_BUSY:
		{
			draw_terminal_no_busy(win_type);
			break;
		}

		//del
        case TOOLBOX_DISPLAY_AGENCY_INFO:
        {
            draw_agency_info(win_type);
            break;
        }
        case TOOLBOX_DISPLAY_TERMINAL_INFO:
        {
            draw_terminal_info(win_type);
            break;
        }

        case TOOLBOX_DISPLAY_TELL_INFO:
        {
            draw_tell_info(win_type);
            break;
        }
        case TOOLBOX_DISPLAY_SALE_TICKET_INFO:
        {
            draw_sale_ticket(win_type);
            break;
        }
        case TOOLBOX_DISPLAY_WIN_TICKET_INFO:
        {
            draw_win_ticket(win_type);
            break;
        }
    }

    refresh_tbl_win(win_type);
    return 0;
}

int toolbox_handle_key_left( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return 0;
}

int toolbox_handle_key_right( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return 0;
}
int toolbox_handle_key_down( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    switch (toolbox_display_type)
    {
        case TOOLBOX_DISPLAY_LIST:
        {
            toolbox_list_data.currentSel++;
            if (toolbox_list_data.currentSel>=toolbox_list_data.lineNum)
                toolbox_list_data.currentSel = 0;
            break;
        }
        default:
        {
            break;
        }
    }
    return 0;
}
int toolbox_handle_key_up( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    switch (toolbox_display_type)
    {
        case TOOLBOX_DISPLAY_LIST:
        {
            toolbox_list_data.currentSel--;
            if (toolbox_list_data.currentSel<0)
                toolbox_list_data.currentSel = toolbox_list_data.lineNum-1;
            break;
        }
        default:
        {
            break;
        }
    }
    return 0;
}
int toolbox_handle_key_enter( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    switch (toolbox_display_type)
    {
        case TOOLBOX_DISPLAY_LIST:
        {
            int ret = pop_dialog(toolbox_list_data.data[toolbox_list_data.currentSel].enter_type);
            if (ret == 0)
            {
                toolbox_display_type = toolbox_list_data.data[toolbox_list_data.currentSel].enter_type;

                //set log level
                if (toolbox_display_type == TOOLBOX_DISPLAY_SET_LOG_LEVEL)
                {
                	int level = atoi(input_data.inputFieldArray[0].field_value);
                    if ( (level < LOG_NOTICE) || (level > LOG_FATAL) )
                    {
                    	level = sys_database_ptr->log_level;
                    }

                    log_info("tsview set log level.[%d]-->[%d]", sys_database_ptr->log_level, level);

                	sys_database_ptr->log_level = level;
                	toolbox_display_type = TOOLBOX_DISPLAY_LIST;
                }
                else if (toolbox_display_type == TOOLBOX_DISPLAY_TERMINAL_NO_BUSY)
                {
                	uint64 termCode = atol(input_data.inputFieldArray[0].field_value);
#if 0 //__DEF_PIL
                	TMS_TERMINAL_RECORD *term = tms_mgr()->getTermByCode(termCode);
                	if (term != NULL)
                	{
                		term->isBusy = false;
                	}
#endif
                	toolbox_display_type = TOOLBOX_DISPLAY_LIST;
                }
            }
            break;
        }
        case TOOLBOX_DISPLAY_SET_LOG_LEVEL:
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
int toolbox_handle_key_escape( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    switch (toolbox_display_type)
    {
        case TOOLBOX_DISPLAY_LIST:
        {
            break;
        }
        default:
        {
            toolbox_display_type = TOOLBOX_DISPLAY_LIST;
            //toolbox_display_type = toolbox_detail_data.data.escapt_type;
            break;
        }
    }
    return 0;
}

int toolbox_handle_key_h(WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return 0;
}



int handle_win_toolbox( WINDOW_TYPE win_type, int ch )
{
    if (toolbox_error_flag)
        return false;

    switch(ch)
    {
        case KEY_UP:
            toolbox_handle_key_up(win_type);
            break;
        case KEY_DOWN:
            toolbox_handle_key_down(win_type);
            break;
        case KEY_LEFT:
            toolbox_handle_key_left(win_type);
            break;
        case KEY_RIGHT:
            toolbox_handle_key_right(win_type);
            break;
        case 10:     //enter
            toolbox_handle_key_enter(win_type);
            break;
        case 27:    //escapt
        case 96:    //`
            toolbox_handle_key_escape(win_type);
            break;
        case 'h':
            toolbox_handle_key_h(win_type);
            break;
        default:
            break;
    }
    draw_win_toolbox(win_type);
    return true;
}

int command_win_toolbox( WINDOW_TYPE win_type, char *cmdstr, int length )
{
    ts_notused(win_type);
    ts_notused(cmdstr);
    ts_notused(length);
    if (toolbox_error_flag)
        return false;
    return true;
}

int refresh_win_toolbox( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    if (toolbox_error_flag)
        return false;
    return true;
}


int pop_dialog(TOOLBOX_DISPALY_TYPE display_type)
{
    memset((char *)&input_data, 0, sizeof(dialog_struct));

    dialog_struct dlg;
    memset((char *)&dlg, 0, sizeof(dialog_struct));

    switch (display_type)
    {
		default:
		{
			logit("pop_dialog display type error!!");
			return 1;
		}
		case TOOLBOX_DISPLAY_SET_LOG_LEVEL:
		{
			dlg.used = true;
			strcpy(dlg.title, "set log level");

			dlg.inputFieldArray[0].used = true;
			strcpy(dlg.inputFieldArray[0].field_name, "1:LOG_NOTICE 2:LOG_DEBUG 3:LOG_INFO 4:LOG_WARN 5:LOG_ERROR 6:LOG_FATAL");
			dlg.inputFieldArray[0].width = 2;
			dlg.inputFieldArray[0].cols = strlen(dlg.inputFieldArray[0].field_name) + 4;
			dlg.inputFieldArray[0].flag = 0;

			dlg.inputFieldArray[1].used = true;
			sprintf(dlg.inputFieldArray[1].field_name, "log level: %d [***Warning*** LOG_NOTICE will cause large files!!!]",
			        sys_database_ptr->log_level);

			break;
		}
        case TOOLBOX_DISPLAY_TERMINAL_NO_BUSY:
        {
            dlg.used = true;
            strcpy(dlg.title, "Set Terminal No Busy");

            dlg.inputFieldArray[0].used = true;
            strcpy(dlg.inputFieldArray[0].field_name, "term code:");
            dlg.inputFieldArray[0].width = 30;
            dlg.inputFieldArray[0].cols = strlen(dlg.inputFieldArray[0].field_name) + 4;
            dlg.inputFieldArray[0].flag = 0;

            break;
        }

        //del
    	case TOOLBOX_DISPLAY_AGENCY_INFO:
        {
            dlg.used = false;
            strcpy(dlg.title, "Search Agency");
            break;
        }
        case TOOLBOX_DISPLAY_TERMINAL_INFO:
        {
            dlg.used = false;
            strcpy(dlg.title, "Search Terminal");
            break;
        }

        case TOOLBOX_DISPLAY_TELL_INFO:
        {
            dlg.used = false;
            strcpy(dlg.title, "Search Teller");
            break;
        }
        case TOOLBOX_DISPLAY_SALE_TICKET_INFO:
        {
            dlg.used = true;
            strcpy(dlg.title, "Search Sale Ticket");

            dlg.inputFieldArray[0].used = true;
            strcpy(dlg.inputFieldArray[0].field_name, "option:  1: TSN  2: FlowNumber");
            dlg.inputFieldArray[0].width = 2;
            dlg.inputFieldArray[0].cols = strlen(dlg.inputFieldArray[0].field_name) + 4;
            dlg.inputFieldArray[0].flag = 0;

            dlg.inputFieldArray[1].used = true;
            strcpy(dlg.inputFieldArray[1].field_name, "input :");
            dlg.inputFieldArray[1].width = 32;
            dlg.inputFieldArray[1].cols = strlen(dlg.inputFieldArray[1].field_name) + 4;
            dlg.inputFieldArray[1].flag = 1;
            break;
        }
        case TOOLBOX_DISPLAY_WIN_TICKET_INFO:
        {
            dlg.used = true;
            strcpy(dlg.title, "Search Win Ticket");

            dlg.inputFieldArray[0].used = true;
            strcpy(dlg.inputFieldArray[0].field_name, "option:  1: TSN  2: FlowNumber");
            dlg.inputFieldArray[0].width = 2;
            dlg.inputFieldArray[0].cols = strlen(dlg.inputFieldArray[0].field_name) + 4;
            dlg.inputFieldArray[0].flag = 0;

            dlg.inputFieldArray[1].used = true;
            strcpy(dlg.inputFieldArray[1].field_name, "input :");
            dlg.inputFieldArray[1].width = 32;
            dlg.inputFieldArray[1].cols = strlen(dlg.inputFieldArray[1].field_name) + 4;
            dlg.inputFieldArray[1].flag = 1;
            break;
        }
    }

    if (dlg.used)
    {
        dialog_draw(&dlg);
        if (dlg.confirm == 0)
        {
            //cancel dialog
            return 1;
        }
        memcpy((char *)&input_data, (char *)&dlg, sizeof(dialog_struct));
    }
    else
    {
        //not init
        return 1;
    }
    return 0;
}

int draw_toolbox_list( WINDOW_TYPE win_type)
{
    char tmp[1024] = {0};

    //输出统计信息
    sprintf(tmp, "           ");
    print_tbl_statistic_info(win_type, tmp);

    //输出table的标题
    sprintf(tmp, "%-10s","menu list");
    print_tbl_header(win_type, tmp);

    //输出table 的明细
    toolbox_list_data.lineNum = 0;       
    
    //GET/SET LOG LEVEL
    sprintf(tmp,"%-3d %s" , toolbox_list_data.lineNum, "display/set log level");
    if (toolbox_list_data.currentSel==toolbox_list_data.lineNum)
    {
        toolbox_list_data.data[toolbox_list_data.currentSel].escapt_type= TOOLBOX_DISPLAY_EMPTY;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_type = TOOLBOX_DISPLAY_SET_LOG_LEVEL;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_index = 0;
        print_tbl_line_str_reverse(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    else
    {
        print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    toolbox_list_data.lineNum++;

    //根据 完整的终端编码, 设置终端机 no busy
    sprintf(tmp,"%-3d %s" , toolbox_list_data.lineNum, "set terminal no busy");
    if (toolbox_list_data.currentSel==toolbox_list_data.lineNum)
    {
        toolbox_list_data.data[toolbox_list_data.currentSel].escapt_type= TOOLBOX_DISPLAY_EMPTY;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_type = TOOLBOX_DISPLAY_TERMINAL_NO_BUSY;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_index = 0;
        print_tbl_line_str_reverse(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    else
    {
        print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    toolbox_list_data.lineNum++;

    //显示 pop_dialog解析后的结果，只显示，不可选择、不可操作
    char strRet[256] = {0};
    char strName[128] = {0};
    char strValue[256] = {0};
    int strValue1 = {0};
    memcpy(strName, input_data.inputFieldArray[0].field_name, 127);
    memcpy(strValue, input_data.inputFieldArray[0].field_value, 255);
    strValue1 = atoi(input_data.inputFieldArray[0].field_value);

    sprintf(tmp," ");
    print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);

    if (strcmp(strName, "1:LOG_NOTICE 2:LOG_DEBUG 3:LOG_INFO 4:LOG_WARN 5:LOG_ERROR 6:LOG_FATAL") == 0)
    {
        sprintf(tmp, "~~~~Exec Result: log level");
        sprintf(strRet,"    input[%d] real[%d]" , strValue1, sys_database_ptr->log_level);
    }
    else
    {
        sprintf(tmp, "~~~~Exec Result:  None");
    }
    print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line+1, 2, tmp);
    print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line+2, 2, strRet);


#if 0
    //根据 完整的销售站编码 或者 销售站的编号ID 查找销售站
    sprintf(tmp,"%-3d %s" , toolbox_list_data.lineNum, "search agency");
    if (toolbox_list_data.currentSel==toolbox_list_data.lineNum)
    {
        toolbox_list_data.data[toolbox_list_data.currentSel].escapt_type= TOOLBOX_DISPLAY_EMPTY;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_type = TOOLBOX_DISPLAY_AGENCY_INFO;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_index = 0;
        print_tbl_line_str_reverse(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    else
    {
        print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    toolbox_list_data.lineNum++;

    //根据 cid 或者 MAC地址 或者 完整的终端编码 或者 终端的编号ID, 查找终端机
    sprintf(tmp,"%-3d %s" , toolbox_list_data.lineNum, "search terminal");
    if (toolbox_list_data.currentSel==toolbox_list_data.lineNum)
    {
        toolbox_list_data.data[toolbox_list_data.currentSel].escapt_type= TOOLBOX_DISPLAY_EMPTY;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_type = TOOLBOX_DISPLAY_TERMINAL_INFO;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_index = 0;
        print_tbl_line_str_reverse(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    else
    {
        print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    toolbox_list_data.lineNum++;


    //根据 编码, 查找Teller
    sprintf(tmp,"%-3d %s" , toolbox_list_data.lineNum, "search teller");
    if (toolbox_list_data.currentSel==toolbox_list_data.lineNum)
    {
        toolbox_list_data.data[toolbox_list_data.currentSel].escapt_type= TOOLBOX_DISPLAY_EMPTY;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_type = TOOLBOX_DISPLAY_TELL_INFO;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_index = 0;
        print_tbl_line_str_reverse(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    else
    {
        print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    toolbox_list_data.lineNum++;

    //根据TSN或者FlowNumber查找销售票
    sprintf(tmp,"%-3d %s" , toolbox_list_data.lineNum, "find sale ticket by TSN or FLOWNUMBER");
    if (toolbox_list_data.currentSel==toolbox_list_data.lineNum)
    {
        toolbox_list_data.data[toolbox_list_data.currentSel].escapt_type= TOOLBOX_DISPLAY_EMPTY;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_type = TOOLBOX_DISPLAY_SALE_TICKET_INFO;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_index = 0;
        print_tbl_line_str_reverse(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    else
    {
        print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    toolbox_list_data.lineNum++;

    //根据TSN或者FlowNumber查找中奖票
    sprintf(tmp,"%-3d %s" , toolbox_list_data.lineNum, "find win ticket by TSN or FLOWNUMBER");
    if (toolbox_list_data.currentSel==toolbox_list_data.lineNum)
    {
        toolbox_list_data.data[toolbox_list_data.currentSel].escapt_type= TOOLBOX_DISPLAY_EMPTY;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_type = TOOLBOX_DISPLAY_WIN_TICKET_INFO;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_index = 0;
        print_tbl_line_str_reverse(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    else
    {
        print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    toolbox_list_data.lineNum++;
#endif


    return 0;
}

int draw_agency_info( WINDOW_TYPE win_type)
{
    char tmp[1024] = {0};

    //输出table的标题
    sprintf(tmp, "%s","Agency Information");
    print_tbl_header(win_type, tmp);

    //输出table 的明细
    toolbox_list_data.lineNum = 0;

    print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, "waitting ... ...");

#if 0
    //根据 完整的销售站编码 或者 销售站的编号ID 查找销售站
    sprintf(tmp,"%-3d %s" , toolbox_list_data.lineNum, "search agency");
    if (toolbox_list_data.currentSel==toolbox_list_data.lineNum)
    {
        toolbox_list_data.data[toolbox_list_data.currentSel].escapt_type= TOOLBOX_DISPLAY_EMPTY;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_type = TOOLBOX_DISPLAY_AGENCY_INFO;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_index = 0;
        print_tbl_line_str_reverse(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    else
    {
        print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    toolbox_list_data.lineNum++;

    //根据 cid 或者 MAC地址 或者 完整的终端编码 或者 终端的编号ID, 查找终端机
    sprintf(tmp,"%-3d %s" , toolbox_list_data.lineNum, "search terminal");
    if (toolbox_list_data.currentSel==toolbox_list_data.lineNum)
    {
        toolbox_list_data.data[toolbox_list_data.currentSel].escapt_type= TOOLBOX_DISPLAY_EMPTY;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_type = TOOLBOX_DISPLAY_TERMINAL_INFO;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_index = 0;
        print_tbl_line_str_reverse(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    else
    {
        print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    toolbox_list_data.lineNum++;

    //根据 完整的终端编码, 设置终端机 no busy
    sprintf(tmp,"%-3d %s" , toolbox_list_data.lineNum, "set terminal no busy");
    if (toolbox_list_data.currentSel==toolbox_list_data.lineNum)
    {
        toolbox_list_data.data[toolbox_list_data.currentSel].escapt_type= TOOLBOX_DISPLAY_EMPTY;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_type = TOOLBOX_DISPLAY_TERMINAL_INFO;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_index = 0;
        print_tbl_line_str_reverse(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    else
    {
        print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    toolbox_list_data.lineNum++;

    //根据TSN或者FlowNumber查找销售票
    sprintf(tmp,"%-3d %s" , toolbox_list_data.lineNum, "find sale ticket by TSN or FLOWNUMBER");
    if (toolbox_list_data.currentSel==toolbox_list_data.lineNum)
    {
        toolbox_list_data.data[toolbox_list_data.currentSel].escapt_type= TOOLBOX_DISPLAY_EMPTY;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_type = TOOLBOX_DISPLAY_SALE_TICKET_INFO;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_index = 0;
        print_tbl_line_str_reverse(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    else
    {
        print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    toolbox_list_data.lineNum++;

    //根据TSN或者FlowNumber查找中奖票
    sprintf(tmp,"%-3d %s" , toolbox_list_data.lineNum, "find win ticket by TSN or FLOWNUMBER");
    if (toolbox_list_data.currentSel==toolbox_list_data.lineNum)
    {
        toolbox_list_data.data[toolbox_list_data.currentSel].escapt_type= TOOLBOX_DISPLAY_EMPTY;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_type = TOOLBOX_DISPLAY_WIN_TICKET_INFO;
        toolbox_list_data.data[toolbox_list_data.currentSel].enter_index = 0;
        print_tbl_line_str_reverse(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    else
    {
        print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, tmp);
    }
    toolbox_list_data.lineNum++;
#endif
    return 0;
}


int draw_terminal_info( WINDOW_TYPE win_type)
{
    char tmp[1024] = {0};

    //输出table的标题
    sprintf(tmp, "%s","Terminal Information");
    print_tbl_header(win_type, tmp);

    //输出table 的明细
    toolbox_list_data.lineNum = 0;

    print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, "waitting ... ...");

    return 0;
}


int draw_terminal_no_busy( WINDOW_TYPE win_type)
{
    char tmp[1024] = {0};

    //输出table的标题
    sprintf(tmp, "%s","Terminal Information");
    print_tbl_header(win_type, tmp);

    //输出table 的明细
    toolbox_list_data.lineNum = 0;

    print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, "waitting ... ...");

    return 0;
}


int draw_tell_info( WINDOW_TYPE win_type)
{
    char tmp[1024] = {0};

    //输出table的标题
    sprintf(tmp, "%s","Terminal Information");
    print_tbl_header(win_type, tmp);

    //输出table 的明细
    toolbox_list_data.lineNum = 0;

    print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, "waitting ... ...");

    return 0;
}



void betLinePick(char * src,char * buff,int line)
{
	char tmpbuf[100] = {0};
    char command[512] = {0};
    sprintf(command,"echo \"%s\" | awk -F'/' '{print $%d}'",src,line);
    FILE   *stream = popen( command, "r" );
    if(stream)
    {
    	fgets( tmpbuf, 100, stream);
    	snprintf(buff,strlen(tmpbuf),"%s",tmpbuf);
        pclose( stream );
    }

}

int draw_sale_ticket( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
#if 0
    char tmp[1024] = {0};
    int i;
    int ret = 0;
    char buffer[100*1024] = {0};
    GIDB_SALE_TICKET_REC *pTicketSale = NULL;
    memset(buffer, 0, 100*1024);
    pTicketSale = (GIDB_SALE_TICKET_REC *)buffer;

    //输出table的标题
    sprintf(tmp, "%s","Sale ticket Information");
    print_tbl_header(win_type, tmp);

    //输出table 的明细
    toolbox_list_data.lineNum = 0;

    bool direct_access = false;

    //初始化共享内存
    if ( !toolbox_shm_init())
    {
        direct_access = false;       
    }
    else
    {
        direct_access = true;
    }

    //------------>
    { // add this '{'  just for no compile error "error: jump to label"

    int len = 0;
    int opt = atoi(input_data.inputFieldArray[0].field_value);

    if (( opt < 1 ) || (opt > 2))
    {
        sprintf(error_info, "Input parameter error. opt[%d]",opt);
        goto FIND_ERROR;
    }

    char tsnStr[TSN_LENGTH + 1] = {0};
    uint8 *pTsn;
    char tsn_str[32] = {0};

    uint8 game_code = 0;
    uint32 issue_serial_number = 0;
    uint32 issue_number = 0;
    uint32 session_no = 0;

    char flowNumStr[REQFLOW_LENGTH + 1] = {0};

    if ( opt == 2 ) //flowNum
    {
        len = strlen(input_data.inputFieldArray[1].field_value);
        if ( len != REQFLOW_LENGTH)
        {
            sprintf(error_info, "Input parameter error. flownumber strlen[%d]",len);
            goto FIND_ERROR;
        }

        //开始处理

        memcpy(flowNumStr, input_data.inputFieldArray[1].field_value, len);
        tf_extract_flownum((uint8 *)flowNumStr, &game_code, &issue_number);


        //查票
        if (direct_access)
        {
            //通过GIDB查票
            GIDB_TICKET_HANDLE * pHandle = gidb_get_ticket_handle(game_code, issue_number);
            if (NULL == pHandle)
            {
                sprintf(error_info, "gidb_get_ticket_handle() failure. game_code[%d] issue_number[%d]", game_code, issue_number);
                goto FIND_ERROR;
            }
            ret = pHandle->gidb_get_sell_ticket2(pHandle,flowNumStr, pTicketSale);
            if ( 0 > ret )
            {
                sprintf(error_info, "gidb_get_win_ticket2() failure. game_code[%d] issue_number[%d] flowNumStr[%s]",
                        game_code, issue_number, flowNumStr);
                goto FIND_ERROR;
            }
            else if (ret == 1)
            {
                sprintf(error_info, "Not Find. game_code[%d] issue_number[%d] flowNumStr[%s]",
                        game_code, issue_number, flowNumStr);
                goto FIND_ERROR;
            }

        }
        else
        {
            //直接打开数据文件查找
            char db_path[256] = {0};
            ts_get_game_issue_ticket_filepath(game_code, issue_number, db_path, 256);
            if( (access( db_path, 0 )) == -1 )
            {
                sprintf(error_info, "db_path[%s] issue_number[%Ld] no exit", db_path,issue_number);
                goto FIND_ERROR;
            }
            sqlite3 * db = db_connect(db_path);
            if ( db == NULL )
            {
                sprintf(error_info, "db_connect() failure. db_path[%s]", db_path);
                goto FIND_ERROR;
            }

            char *sql_str = "SELECT * FROM sale_ticket_table WHERE flow_number=?";
            sqlite3_stmt* pStmt = NULL;

            ret = sqlite3_prepare_v2(db, sql_str, strlen(sql_str), &pStmt, NULL);
            if ( ret != SQLITE_OK)
            {
            	if (pStmt)
                    sqlite3_finalize(pStmt);
                sprintf(error_info, "sqlite3_prepare_v2() failure. sql_str[%s]", sql_str);
                goto FIND_ERROR;
            }
            sqlite3_bind_text(  pStmt, 1,   flowNumStr, REQFLOW_LENGTH, SQLITE_TRANSIENT);
        	ret = sqlite3_step(pStmt);
            if (ret == SQLITE_DONE)
            {
                sqlite3_finalize(pStmt);
                sprintf(error_info, "Not find ticket(). game_code[%d] issue_number[%d] flowNumStr[%s]",
                        game_code, issue_number, flowNumStr);
                goto FIND_ERROR;
            }
            else if (ret != SQLITE_ROW)
            {
            	sqlite3_finalize(pStmt);
                sprintf(error_info, "sqlite3_step() failure! game_code[%d] issue_number[%d] flowNumStr[%s]",
                        game_code, issue_number, flowNumStr);
                goto FIND_ERROR;
            }

            //读取数据
            if ( get_sale_ticket_rec_from_stmt(pTicketSale, pStmt) < 0 )
            {
                sqlite3_finalize(pStmt);
                sprintf(error_info, "get_sale_ticket_rec_from_stmt() failure! game_code[%d] issue_number[%d] flowNumStr[%s]",
                        game_code, issue_number, flowNumStr);
                goto FIND_ERROR;
            }
            sqlite3_finalize(pStmt);
            db_close(db);
        }
    }
    else //tsn
    {
        len = strlen(input_data.inputFieldArray[1].field_value);
        if ( len != TSN_LENGTH*2)
        {
            sprintf(error_info, "Input parameter error.");
            goto FIND_ERROR;
        }

        //开始处理

        uint8 buf[128] = {0};

        len = hex_decode_binary(input_data.inputFieldArray[1].field_value, TSN_LENGTH*2, buf);
        memcpy(tsnStr, buf, len);

        pTsn = (uint8 *)tsnStr;

        //check TSN
        if ( !tf_checktsn(pTsn) )
        {
            sprintf(error_info, "check tsn failure. tsn->%s", pTsn);
            goto FIND_ERROR;
        }

        //得到游戏号和期次序号

        tf_extract_triple(pTsn, &game_code, &issue_serial_number, &session_no);
        GIDB_ISSUE_HANDLE *issueHandle = gidb_get_issue_handle(game_code);
       	if ( NULL == issueHandle )
        {
       		sprintf(error_info,"gidb_get_issue_handle() failure!");
       		goto FIND_ERROR;
        }
       	GIDB_ISSUE_INFO is_info;
       	memset((char *)&is_info, 0, sizeof(GIDB_ISSUE_INFO));
       	ret = issueHandle->gidb_get_issue_info2(issueHandle, game_code, issue_serial_number, &is_info);
       	if ( ret != 0 )
        {
       		sprintf(error_info,"gidb_get_issue_info2() failure!");
       		goto FIND_ERROR;
        }
       	issue_number = is_info.issueNumber;

        
        //转换TSN to TSN_STRING
        char tsn_str[32] = {0};
        binary_encode_hex(pTsn, TSN_LENGTH, tsn_str);

        //查票
        if (direct_access)
        {
            //通过GIDB查票
            GIDB_TICKET_HANDLE * pHandle = gidb_get_ticket_handle2(game_code, issue_serial_number);
            if (NULL == pHandle)
            {
                sprintf(error_info, "gidb_get_ticket_handle2() failure. game_code[%d] issue_serial_number[%d]", game_code, issue_serial_number);
                goto FIND_ERROR;
            }
            ret = pHandle->gidb_get_sell_ticket(pHandle,pTsn, pTicketSale);
            if ( 0 > ret )
            {
                sprintf(error_info, "gidb_get_win_ticket() failure. game_code[%d] issue_serial_number[%d] tsn[%s]",
                        game_code, issue_serial_number, tsn_str);
                goto FIND_ERROR;
            }
            else if (ret == 1)
            {
                sprintf(error_info, "Not Find. game_code[%d] issue_serial_number[%d] tsn[%s]",
                        game_code, issue_serial_number, tsn_str);
                goto FIND_ERROR;
            }

        }
        else
        {
            //直接打开数据文件查找
            char db_path[256] = {0};
            ts_get_game_issue_ticket_filepath(game_code, issue_number, db_path, 256);
            if( (access( db_path, 0 )) == -1 )
            {
                sprintf(error_info, "db_path[%s] issue_number[%Ld] no exit", db_path,issue_number);
                goto FIND_ERROR;
            }
            sqlite3 * db = db_connect(db_path);
            if ( db == NULL )
            {
                sprintf(error_info, "db_connect() failure. db_path[%s]", db_path);
                goto FIND_ERROR;
            }

            char *sql_str = "SELECT * FROM sale_ticket_table WHERE tsn=?";
            sqlite3_stmt* pStmt = NULL;

            ret = sqlite3_prepare_v2(db, sql_str, strlen(sql_str), &pStmt, NULL);
            if ( ret != SQLITE_OK)
            {
            	if (pStmt)
                    sqlite3_finalize(pStmt);
                sprintf(error_info, "sqlite3_prepare_v2() failure. sql_str[%s]", sql_str);
                goto FIND_ERROR;
            }
            sqlite3_bind_text(  pStmt, 1,   tsn_str, TSN_LENGTH*2, SQLITE_TRANSIENT);
        	ret = sqlite3_step(pStmt);
            if (ret == SQLITE_DONE)
            {
                sqlite3_finalize(pStmt);
                sprintf(error_info, "Not find ticket(). game_code[%d] issue_serial_number[%d] tsn[%s]",
                        game_code, issue_serial_number, tsn_str);
                goto FIND_ERROR;
            }
            else if (ret != SQLITE_ROW)
            {
            	sqlite3_finalize(pStmt);
                sprintf(error_info, "sqlite3_step() failure! game_code[%d] issue_serial_number[%d] tsn[%s]",
                        game_code, issue_serial_number, tsn_str);
                goto FIND_ERROR;
            }

            //读取数据
            if ( get_sale_ticket_rec_from_stmt(pTicketSale, pStmt) < 0 )
            {
                sqlite3_finalize(pStmt);
                sprintf(error_info, "get_sale_ticket_rec_from_stmt() failure! game_code[%d] issue_serial_number[%d] tsn[%s]",
                        game_code, issue_serial_number, tsn_str);
                goto FIND_ERROR;
            }
            sqlite3_finalize(pStmt);
            db_close(db);         
        }
    }

		//显示 GIDB_SALE_TICKET_REC *pTicketSale 到屏幕
		//

		int line = toolbox_list_data.lineNum+toolbox_win_top_line;

		char pBuf[2048] = {0};
		sprintf(pBuf,"session No [%d]",tf_extract_session(pTicketSale->tsn));
		print_tbl_line_str(win_type, line, 2, pBuf);


		bzero(pBuf,2048); line++;
	    char buf_tsn[TSN_LENGTH * 2 + 2];
	    binary_encode_hex(pTicketSale->tsn, TSN_LENGTH, buf_tsn);
		sprintf(pBuf,"tsn [%s]",buf_tsn);
		print_tbl_line_str(win_type, line, 2, pBuf);
/*
		bzero(pBuf,2048); line++;
		char extCode_buf[EXT_CODE_LENGTH + 1] = {0};
		snprintf(extCode_buf,EXT_CODE_LENGTH,"%s",pTicketSale->extCode);
		sprintf(pBuf,"extCode [%s]",extCode_buf);
		print_tbl_line_str(win_type, line, 2, pBuf);
*/
		bzero(pBuf,2048);line++;
		char flow_buf[REQFLOW_LENGTH + 1] = {0};
		snprintf(flow_buf,REQFLOW_LENGTH,"%s",pTicketSale->flowNumber);
		sprintf(pBuf,"flowNumber [%s]",flow_buf);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"timeStamp [%Ld]",pTicketSale->timeStamp);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"Sale From [%s]",saleFromStr[pTicketSale->from_sale]);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"provinceCode[%d] agencyCode[%d] tellerId[%d]",\
				pTicketSale->provinceCode,pTicketSale->agencyCode,pTicketSale->tellerId);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"terminalCode[%d] termFlowNumber[%Ld]",pTicketSale->terminalCode,pTicketSale->termFlowNumber);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"gameId[%d] gameCode[%d]",pTicketSale->gameId,pTicketSale->gameCode);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"saleStartIssue [%ld]",pTicketSale->saleStartIssue);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"saleStartIssueSerial [%ld]",pTicketSale->saleStartIssueSerial);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"saleEndIssue [%ld]",pTicketSale->saleEndIssue);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"totalBets [%d]",pTicketSale->totalBets);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"ticketAmount [%ld]",pTicketSale->ticketAmount);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"commissionAmount [%ld]",pTicketSale->commissionAmount);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"claimingScope [%d]",pTicketSale->claimingScope);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"drawTimeStamp [%ld]",pTicketSale->drawTimeStamp);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"isTrain [%d]",pTicketSale->isTrain);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"isCancel [%d]",pTicketSale->isCancel);
		print_tbl_line_str(win_type, line, 2, pBuf);

		if(pTicketSale->isCancel > 0)
		{
			bzero(pBuf,2048);line++;
			char buf_tsn_cancel[TSN_LENGTH * 2 + 2];
			binary_encode_hex(pTicketSale->tsn_cancel, TSN_LENGTH, buf_tsn_cancel);
			sprintf(pBuf,"tsn_cancel [%s]",buf_tsn_cancel);
			print_tbl_line_str(win_type, line, 2, pBuf);
/*
			bzero(pBuf,2048);line++;
			sprintf(pBuf,"extCode_cancel [%s]",pTicketSale->extCode_cancel);
			print_tbl_line_str(win_type, line, 2, pBuf);
*/
			bzero(pBuf,2048);line++;
			char flow_buf_cancel[REQFLOW_LENGTH + 1] = {0};
			snprintf(flow_buf_cancel,REQFLOW_LENGTH,"%s",pTicketSale->flow_number_cancel);
			sprintf(pBuf,"flow_number_cancel [%s]",flow_buf_cancel);
			print_tbl_line_str(win_type, line, 2, pBuf);

			bzero(pBuf,2048);line++;
			sprintf(pBuf,"timeStamp_cancel [%ld]",pTicketSale->timeStamp_cancel);
			print_tbl_line_str(win_type, line, 2, pBuf);

			bzero(pBuf,2048);line++;
			sprintf(pBuf,"from_cancel [%d]",pTicketSale->from_cancel);
			print_tbl_line_str(win_type, line, 2, pBuf);

			bzero(pBuf,2048);line++;
			sprintf(pBuf,"agencyId_cancel [%ld]",pTicketSale->agencyId_cancel);
			print_tbl_line_str(win_type, line, 2, pBuf);

			bzero(pBuf,2048);line++;
			sprintf(pBuf,"terminalId_cancel [%ld]",pTicketSale->terminalId_cancel);
			print_tbl_line_str(win_type, line, 2, pBuf);

			bzero(pBuf,2048);line++;
			sprintf(pBuf,"tellerId_cancel [%ld]",pTicketSale->tellerId_cancel);
			print_tbl_line_str(win_type, line, 2, pBuf);

			bzero(pBuf,2048);line++;
			sprintf(pBuf,"termFlowNumber_cancel [%ld]",pTicketSale->termFlowNumber_cancel);
			print_tbl_line_str(win_type, line, 2, pBuf);
		}

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"betLines [%d]",pTicketSale->betLines);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"betslip_length [%ld]",pTicketSale->betslip_length);
		print_tbl_line_str(win_type, line, 2, pBuf);


		char lineStr[100];
        char headStr[32];
		for(i = 1; i <= pTicketSale->betLines; i++)
		{
			bzero(headStr,32);
			sprintf(headStr,"betline[%02d] betString",i);

			bzero(lineStr,100);
			betLinePick(pTicketSale->bet_string,lineStr,i);

			bzero(pBuf,2048);line++;
			snprintf(pBuf,strlen(headStr)+strlen(lineStr)+3,"%s[%s]",headStr,lineStr);

			print_tbl_line_str(win_type, line, 2, pBuf);
		}
		return 0;
    }

FIND_ERROR:
    
    print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, error_info);
    print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line+1, 2, "press \"Escape\" to return");
#endif
    return 0;
}

int draw_win_ticket( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
#if 0
    char tmp[1024] = {0};
    int i;
    int ret = 0;
    char buffer[100*1024] = {0};
    GIDB_WIN_TICKET_REC *pTicketWin = NULL;
    memset(buffer, 0, 100*1024);
    pTicketWin = (GIDB_WIN_TICKET_REC *)buffer;

    //输出table的标题
    sprintf(tmp, "%s","Win ticket Information");
    print_tbl_header(win_type, tmp);

    //输出table 的明细
    toolbox_list_data.lineNum = 0;

    bool direct_access = false;

    //初始化共享内存
    if ( !toolbox_shm_init())
    {
        direct_access = false;
    }
    else
    {
        direct_access = true;
    }

    //------------>

    { // add this '{'  just for no compile error "error: jump to label"

    int len = 0;
    int opt = atoi(input_data.inputFieldArray[0].field_value);

    if (( opt < 1 ) || (opt > 2))
    {
        sprintf(error_info, "Input parameter error.opt[%d]",opt);
        goto FIND_ERROR;
    }

    char tsnStr[TSN_LENGTH + 1] = {0};
    uint8 *pTsn;
    char tsn_str[32] = {0};
    //得到游戏号和期次序号
    uint8 game_code = 0;
    uint32 issue_serial_number = 0;
    uint32 issue_number = 0;

    char flowNumStr[REQFLOW_LENGTH + 1] = {0};

    if ( opt == 2 ) //flowNum
    {
        len = strlen(input_data.inputFieldArray[1].field_value);
        if ( len != REQFLOW_LENGTH)
        {
            sprintf(error_info, "Input parameter error. flownumber strlen[%d]",len);
            goto FIND_ERROR;
        }

        //开始处理

        memcpy(flowNumStr, input_data.inputFieldArray[1].field_value, len);
        tf_extract_flownum((uint8 *)flowNumStr, &game_code, &issue_number);


        //查票
        if (!direct_access)
        {
            //通过GIDB查票
            GIDB_TICKET_HANDLE * pHandle = gidb_get_ticket_handle(game_code, issue_number);
            if (NULL == pHandle)
            {
                sprintf(error_info, "gidb_get_ticket_handle() failure. game_code[%d] issue_number[%Ld]", game_code, issue_number);
                goto FIND_ERROR;
            }
            ret = pHandle->gidb_get_win_ticket2( pHandle, flowNumStr, pTicketWin);
            if ( 0 > ret )
            {
                sprintf(error_info, "gidb_get_win_ticket2() failure. game_code[%d] issue_number[%Ld] flowNumStr[%s]",
                        game_code, issue_number, flowNumStr);
                goto FIND_ERROR;
            }
            else if (ret == 1)
            {
                sprintf(error_info, "Not Find. game_code[%d] issue_number[%Ld] flowNumStr[%s]",
                        game_code, issue_number, flowNumStr);
                goto FIND_ERROR;
            }

        }
        else
        {
            //直接打开数据文件查找
            char db_path[256] = {0};
            ts_get_game_issue_ticket_filepath(game_code, issue_number, db_path, 256);
            if( (access( db_path, 0 )) == -1 )
            {
                sprintf(error_info, "db_path[%s] no exit", db_path);
                goto FIND_ERROR;
            }
            sqlite3 * db = db_connect(db_path);
            if ( db == NULL )
            {
                sprintf(error_info, "db_connect() failure. db_path[%s]", db_path);
                goto FIND_ERROR;
            }

            char *sql_str = "SELECT * FROM win_ticket_table WHERE flow_number=?";
            sqlite3_stmt* pStmt = NULL;

            ret = sqlite3_prepare_v2(db, sql_str, strlen(sql_str), &pStmt, NULL);
            if ( ret != SQLITE_OK)
            {
            	if (pStmt)
                    sqlite3_finalize(pStmt);
                sprintf(error_info, "sqlite3_prepare_v2() failure. sql_str[%s]", sql_str);
                goto FIND_ERROR;
            }
            sqlite3_bind_text(  pStmt, 1,   flowNumStr, REQFLOW_LENGTH, SQLITE_TRANSIENT);
        	ret = sqlite3_step(pStmt);
            if (ret == SQLITE_DONE)
            {
                sqlite3_finalize(pStmt);
                sprintf(error_info, "Not find ticket(). game_code[%d] issue_number[%Ld] flowNumStr[%s]",
                        game_code, issue_number, flowNumStr);
                goto FIND_ERROR;
            }
            else if (ret != SQLITE_ROW)
            {
            	sqlite3_finalize(pStmt);
                sprintf(error_info, "sqlite3_step() failure! game_code[%d] issue_number[%Ld] flowNumStr[%s]",
                        game_code, issue_number, flowNumStr);
                goto FIND_ERROR;
            }

            //读取数据
            if ( get_winner_ticket_rec_from_stmt(pTicketWin, pStmt) < 0 )
            {
                sqlite3_finalize(pStmt);
                sprintf(error_info, "get_winner_ticket_rec_from_stmt() failure! game_code[%d] issue_number[%Ld] flowNumStr[%s]",
                        game_code, issue_number, flowNumStr);
                goto FIND_ERROR;
            }
            sqlite3_finalize(pStmt);
            db_close(db);
        }
    }
    else //tsn
    {
        len = strlen(input_data.inputFieldArray[1].field_value);
        if ( len != TSN_LENGTH*2)
        {
            sprintf(error_info, "Input parameter error.");
            goto FIND_ERROR;
        }

        //开始处理

        uint8 buf[128] = {0};

        len = hex_decode_binary(input_data.inputFieldArray[1].field_value, TSN_LENGTH*2, buf);
        memcpy(tsnStr, buf, len);

        pTsn = (uint8 *)tsnStr;

        //check TSN
        if ( !tf_checktsn(pTsn) )
        {
            sprintf(error_info, "check tsn failure. tsn->%s", pTsn);
            goto FIND_ERROR;
        }

        tf_extract_triple(pTsn, &game_code, &issue_serial_number, NULL);
        GIDB_ISSUE_HANDLE *issueHandle = gidb_get_issue_handle(game_code);
       	if ( NULL == issueHandle )
        {
       		sprintf(error_info,"gidb_get_issue_handle() failure!");
       		goto FIND_ERROR;
        }
       	GIDB_ISSUE_INFO is_info;
       	memset((char *)&is_info, 0, sizeof(GIDB_ISSUE_INFO));
       	ret = issueHandle->gidb_get_issue_info2(issueHandle, game_code, issue_serial_number, &is_info);
       	if ( ret != 0 )
        {
       		sprintf(error_info,"gidb_get_issue_info2() failure!");
       		goto FIND_ERROR;
        }
       	issue_number = is_info.issueNumber;


        //转换TSN to TSN_STRING

        binary_encode_hex(pTsn, TSN_LENGTH, tsn_str);

        //查票
        if (!direct_access)
        {
            //通过GIDB查票
            GIDB_TICKET_HANDLE * pHandle = gidb_get_ticket_handle2(game_code, issue_serial_number);
            if (NULL == pHandle)
            {
                sprintf(error_info, "gidb_get_ticket_handle2() failure. game_code[%d] issue_serial_number[%d]", game_code, issue_serial_number);
                goto FIND_ERROR;
            }
            ret = pHandle->gidb_get_win_ticket( pHandle, pTsn, pTicketWin);
            if ( 0 > ret )
            {
                sprintf(error_info, "gidb_get_win_ticket() failure. game_code[%d] issue_serial_number[%d] tsn[%s]",
                        game_code, issue_serial_number, tsn_str);
                goto FIND_ERROR;
            }
            else if (ret == 1)
            {
                sprintf(error_info, "Not Find. game_code[%d] issue_serial_number[%d] tsn[%s]",
                        game_code, issue_serial_number, tsn_str);
                goto FIND_ERROR;
            }

        }
        else
        {
            //直接打开数据文件查找
            char db_path[256] = {0};
            ts_get_game_issue_ticket_filepath(game_code, issue_number, db_path, 256);
            if( (access( db_path, 0 )) == -1 )
            {
                sprintf(error_info, "db_path[%s] no exit", db_path);
                goto FIND_ERROR;
            }
            sqlite3 * db = db_connect(db_path);
            if ( db == NULL )
            {
                sprintf(error_info, "db_connect() failure. db_path[%s]", db_path);
                goto FIND_ERROR;
            }

            char *sql_str = "SELECT * FROM win_ticket_table WHERE tsn=?";
            sqlite3_stmt* pStmt = NULL;

            ret = sqlite3_prepare_v2(db, sql_str, strlen(sql_str), &pStmt, NULL);
            if ( ret != SQLITE_OK)
            {
            	if (pStmt)
                    sqlite3_finalize(pStmt);
                sprintf(error_info, "sqlite3_prepare_v2() failure. sql_str[%s]", sql_str);
                goto FIND_ERROR;
            }
            sqlite3_bind_text(  pStmt, 1,   tsn_str, TSN_LENGTH*2, SQLITE_TRANSIENT);
        	ret = sqlite3_step(pStmt);
            if (ret == SQLITE_DONE)
            {
                sqlite3_finalize(pStmt);
                sprintf(error_info, "Not find ticket(). game_code[%d] issue_serial_number[%d] tsn[%s]",
                        game_code, issue_serial_number, tsn_str);
                goto FIND_ERROR;
            }
            else if (ret != SQLITE_ROW)
            {
            	sqlite3_finalize(pStmt);
                sprintf(error_info, "sqlite3_step() failure! game_code[%d] issue_serial_number[%d] tsn[%s]",
                        game_code, issue_serial_number, tsn_str);
                goto FIND_ERROR;
            }

            //读取数据
            if ( get_winner_ticket_rec_from_stmt(pTicketWin, pStmt) < 0 )
            {
                sqlite3_finalize(pStmt);
                sprintf(error_info, "get_winner_ticket_rec_from_stmt() failure! game_code[%d] issue_serial_number[%d] tsn[%s]",
                        game_code, issue_serial_number, tsn_str);
                goto FIND_ERROR;
            }
            sqlite3_finalize(pStmt);
            db_close(db);
        }
    }


		//显示 GIDB_SALE_TICKET_REC *pTicketWin 到屏幕
		//

		int line = toolbox_list_data.lineNum+toolbox_win_top_line;

		char pBuf[2048] = {0};
		sprintf(pBuf,"session No [%d]",tf_extract_session(pTicketWin->tsn));
		print_tbl_line_str(win_type, line, 2, pBuf);


		bzero(pBuf,2048); line++;
	    char buf_tsn[TSN_LENGTH * 2 + 2];
	    binary_encode_hex(pTicketWin->tsn, TSN_LENGTH, buf_tsn);
		sprintf(pBuf,"tsn [%s]",buf_tsn);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048); line++;
		char extCode_buf[EXT_CODE_LENGTH + 1] = {0};
		snprintf(extCode_buf,EXT_CODE_LENGTH,"%s",pTicketWin->extCode);
		sprintf(pBuf,"extCode [%s]",extCode_buf);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		char flow_buf[REQFLOW_LENGTH + 1] = {0};
		snprintf(flow_buf,REQFLOW_LENGTH,"%s",pTicketWin->flowNumber);
		sprintf(pBuf,"flowNumber [%s]",flow_buf);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"timeStamp [%Ld]",pTicketWin->timeStamp);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"Sale From [%s]",saleFromStr[pTicketWin->from_sale]);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"provinceCode[%d] agencyCode[%d] tellerId[%d]",\
				pTicketWin->provinceCode,pTicketWin->agencyCode,pTicketWin->tellerId);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"terminalCode[%d] termFlowNumber[%Ld]",pTicketWin->terminalCode,pTicketWin->termFlowNumber_pay);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"gameId[%d] gameCode[%d]",pTicketWin->gameId,pTicketWin->gameCode);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"issueNumber [%ld]",pTicketWin->issueNumber);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"issueCount [%d]",pTicketWin->issueCount);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"saleStartIssue [%ld]",pTicketWin->saleStartIssue);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"saleStartIssueSerial [%ld]",pTicketWin->saleStartIssueSerial);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"saleEndIssue [%ld]",pTicketWin->saleEndIssue);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"totalBets [%ld]",pTicketWin->totalBets);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"ticketAmount [%ld]",pTicketWin->ticketAmount);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"claimingScope [%d]",pTicketWin->claimingScope);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"isTrain [%d]",pTicketWin->isTrain);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"isBigWinning [%d]",pTicketWin->isBigWinning);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"betLines [%d]",pTicketWin->betLines);
		print_tbl_line_str(win_type, line, 2, pBuf);

		char lineStr[100];
        char headStr[32];
		for(i = 1; i <= pTicketWin->betLines; i++)
		{
			bzero(headStr,32);
			sprintf(headStr,"betline[%02d] betString",i);

			bzero(lineStr,100);
			betLinePick(pTicketWin->bet_string,lineStr,i);

			bzero(pBuf,2048);line++;
			snprintf(pBuf,strlen(headStr)+strlen(lineStr)+3,"%s[%s]",headStr,lineStr);

			print_tbl_line_str(win_type, line, 2, pBuf);
		}

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"winningAmountWithTax [%ld]",pTicketWin->winningAmountWithTax);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"winningAmount [%ld]",pTicketWin->winningAmount);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"taxAmount [%ld]",pTicketWin->taxAmount);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"winningCount [%ld]",pTicketWin->winningCount);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"hd_winning [%ld]",pTicketWin->hd_winning);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"hd_count [%ld]",pTicketWin->hd_count);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"ld_winning [%ld]",pTicketWin->ld_winning);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"ld_count [%ld]",pTicketWin->ld_count);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"userName_pay [%s]",pTicketWin->userName_pay);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"identityType_pay [%d]",pTicketWin->identityType_pay);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"identityNumber_pay [%s]",pTicketWin->identityNumber_pay);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"paid_status [%d]",pTicketWin->paid_status);
		print_tbl_line_str(win_type, line, 2, pBuf);

		if(pTicketWin->paid_status)
		{
			bzero(pBuf,2048);line++;
			char buf_tsn_pay[TSN_LENGTH * 2 + 2] = {0};
			binary_encode_hex(pTicketWin->tsn_pay, TSN_LENGTH, buf_tsn_pay);
			sprintf(pBuf,"tsn_pay [%s]",buf_tsn_pay);
			print_tbl_line_str(win_type, line, 2, pBuf);
/*
			bzero(pBuf,2048);line++;
			sprintf(pBuf,"extCode_pay [%s]",pTicketWin->extCode_pay);
			print_tbl_line_str(win_type, line, 2, pBuf);
*/
			bzero(pBuf,2048);line++;
			char flow_buf_pay[REQFLOW_LENGTH + 1] = {0};
			snprintf(flow_buf_pay,REQFLOW_LENGTH,"%s",pTicketWin->flow_number_pay);
			sprintf(pBuf,"flow_number_pay [%s]",flow_buf_pay);
			print_tbl_line_str(win_type, line, 2, pBuf);

			bzero(pBuf,2048);line++;
			sprintf(pBuf,"timeStamp_pay [%ld]",pTicketWin->timeStamp_pay);
			print_tbl_line_str(win_type, line, 2, pBuf);

			bzero(pBuf,2048);line++;
			sprintf(pBuf,"from_pay [%s]",saleFromStr[pTicketWin->from_pay]);
			print_tbl_line_str(win_type, line, 2, pBuf);

			bzero(pBuf,2048);line++;
			sprintf(pBuf,"agencyId_pay [%ld] terminalId_pay [%ld] tellerId_pay [%ld] termFlowNumber_pay [%ld]",\
					pTicketWin->agencyId_pay,pTicketWin->terminalId_pay,pTicketWin->tellerId_pay,pTicketWin->termFlowNumber_pay);
			print_tbl_line_str(win_type, line, 2, pBuf);

		}


		bzero(pBuf,2048);line++;
		sprintf(pBuf,"prizeCount [%d]",pTicketWin->prizeCount);
		print_tbl_line_str(win_type, line, 2, pBuf);

		bzero(pBuf,2048);line++;
		sprintf(pBuf,"prizeDetail_length [%ld]",pTicketWin->prizeDetail_length);
		print_tbl_line_str(win_type, line, 2, pBuf);

        for(i=0; i < pTicketWin->prizeCount; i++)
        {
			bzero(pBuf,2048);line++;
			sprintf(pBuf,"Prize Name [%s]",pTicketWin->prizeDetail[i].name);
			print_tbl_line_str(win_type, line, 2, pBuf);

			bzero(pBuf,2048);line++;
			sprintf(pBuf,"prizeCode [%d]  count[%ld]",pTicketWin->prizeDetail[i].prizeCode,pTicketWin->prizeDetail[i].count);
			print_tbl_line_str(win_type, line, 2, pBuf);

			bzero(pBuf,2048);line++;
			sprintf(pBuf,"amountSingle [%ld] amountBeforeTax [%ld] amountTax [%ld] amountAfterTax [%ld]",\
					pTicketWin->prizeDetail[i].amountSingle,pTicketWin->prizeDetail[i].amountBeforeTax,\
					pTicketWin->prizeDetail[i].amountTax,pTicketWin->prizeDetail[i].amountAfterTax);
			print_tbl_line_str(win_type, line, 2, pBuf);

        }


		return 0;
    }


FIND_ERROR:
    
    if (ret == ERR_INPUT_PARAMETER)
        print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, "Parameter input error!");
    else if (ret == ERR_NOT_FIND)
        print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, "Not Find!");
    else
    {
        print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line, 2, error_info);
    }
    print_tbl_line_str(win_type, toolbox_list_data.lineNum+toolbox_win_top_line+1, 2, "press \"Escape\" to return");
#endif
    return 0;
}

int draw_log_level( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return 0;
}


bool toolbox_shm_init()
{
    if (!sysdb_init())
    {
    	log_info("sysdb_init false");
        return false;
    }
    if (!tms_mgr()->TMSInit())
    {
    	log_info("tms_mgr init false");
        return false;
    }
    if (!gl_init())
    {
    	log_info("gl_init false");
        return false;
    }
    if (tfe_init() != 0)
    {
    	log_info("tfe_init false");
        return false;
    }
    /*
    if (!gidb_shm_init())
    {
    	log_info("sysdb_init false");
        return false;
    }
    */

    return true;
}

bool toolbox_shm_close()
{
	//gidb_close_all_db();
    //gidb_shm_close();
    gl_close();
    tms_mgr()->TMSClose();
    sysdb_close();

    return true;
}



