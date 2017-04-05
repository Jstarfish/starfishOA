#include "tsview.h"

bool bq_init_flag = false;

#define PAGE_SIZE (MAIN_WIN_LINES - 5)

#define STACK_SIZE (20)

bool bq_error_flag = false;

#define current_frame (bq_context.display_stack[bq_context.stack_pointer])
#define parent_frame (bq_context.display_stack[bq_context.stack_pointer - 1])

typedef enum _BQ_DISPALY_TYPE {
    BQ_DISPLAY_EMPTY = 0,
    BQ_DISPLAY_TOP,
    BQ_DISPLAY_NET,
    BQ_DISPLAY_NET_DETAIL,
    BQ_DISPLAY_TASK,
    BQ_DISPLAY_TASK_DETAIL,
    BQ_DISPLAY_FREE_Q
} BQ_DISPALY_TYPE;

static const char *protocol_str[] = {
        "BQ_PROTOCOL_EMPTY",
        "BQ_PROTOCOL_TCP_SERVER",
        "BQ_PROTOCOL_TCP_CLIENT"
};

typedef struct _COMMON_INFO {
    BQ_DISPALY_TYPE enter_type;
} COMMON_INFO;

typedef struct _BQ_LINE {
    COMMON_INFO common_info;
    char name[64];
} BQ_LINE;

typedef union _DATA_POINTER {
    BQ_LINE *lines;
    void *pointer;
} DATA_POINTER;

typedef struct _FRAME_INFO {
    BQ_DISPALY_TYPE display_type;
    BQ_DISPALY_TYPE display_type_keep;
    int32 maxLine;
    int32 current_page;
    int32 page_size;
    int32 currentSel;
    DATA_POINTER data;
} FRAME_INFO;

typedef struct _BQ_CONTEXT {
    bool bq_error_flag;
    BQ_NET_ROUTE_TABLE *net_table;
    BQ_TASK_QUEUE_ARRAY *tasks;
    BQ_FREE_QUEUE_ARRAY *free_queue;
    FRAME_INFO display_stack[STACK_SIZE];
    int32 stack_pointer;
} BQ_CONTEXT;

static BQ_CONTEXT bq_context;

int init_win_bqueues(WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    if (bq_init_flag)
        return 0;

    bq_context.bq_error_flag = false;

    if (!bq_init()) {
        bq_context.bq_error_flag = true;
        logit("bqueues shm attach failed.");

        return false;
    }

    memset(&bq_context, 0, sizeof(bq_context));
    bq_context.net_table = getNetRouteTable();
    bq_context.tasks = getTaskQueueArray();
    bq_context.free_queue = getFreeQueueArray();
    bq_context.stack_pointer = -1;

    static BQ_LINE line_infos[3];
    line_infos[0].common_info.enter_type = BQ_DISPLAY_NET;
    snprintf(line_infos[0].name, sizeof(line_infos[1].name), "BQ_NET_ROUTE_TABLE[%d]", BQ_MAX_NET_NUM);

    line_infos[1].common_info.enter_type = BQ_DISPLAY_TASK;
    snprintf(line_infos[1].name, sizeof(line_infos[2].name), "BQ_TASK_QUEUE_ARRAY[%d]", BQ_MAX_TASK_NUM);

    line_infos[2].common_info.enter_type = BQ_DISPLAY_FREE_Q;
    snprintf(line_infos[2].name, sizeof(line_infos[3].name), "BQ_FREE_QUEUE_ARRAY[%d]", BQ_TYPE_NUM);

    // push
    bq_context.stack_pointer++;
    current_frame.current_page = 1;
    current_frame.currentSel = 0;
    current_frame.maxLine = 4;
    current_frame.page_size = PAGE_SIZE;
    current_frame.display_type = BQ_DISPLAY_TOP;
    current_frame.display_type_keep = BQ_DISPLAY_EMPTY;
    current_frame.data.lines = line_infos;

    bq_init_flag = true;
    return true;
}

int close_win_bqueues( WINDOW_TYPE win_type )
{
    ts_notused(win_type);

    if (bq_context.bq_error_flag) {
        return false;
    }

    bq_init_flag = false;
    //bq_close();
    return true;
}

static int display_empty(WINDOW_TYPE win_type)
{
    clear_tbl_win(win_type);

    return true;
}

static int display_top(WINDOW_TYPE win_type)
{
    char tmp[1024] = {0};

    if (bq_context.bq_error_flag) {
        return false;
    }

    //输出table的标题
    sprintf(tmp, "%-8s%-32s", "INDEX", "NAME");
    print_tbl_header(win_type, tmp);
    int32 sumPages = 0;

    int start_index = getStartIndexByPage(&(current_frame.current_page), &sumPages,
            current_frame.maxLine,
            current_frame.page_size);
    BQ_LINE *line_infos_t = current_frame.data.lines;
    int i;
    for (i = start_index; i < start_index + current_frame.page_size; i++) {
        if (i < current_frame.maxLine) {
            snprintf(tmp, sizeof(tmp), "%-8d%-32s", i,
                    line_infos_t[i].name);
            if (current_frame.currentSel == i) {
                print_tbl_line_str_reverse(win_type, 3 + i - start_index, 2, tmp);
            } else {
                print_tbl_line_str(win_type, 3 + i - start_index, 2, tmp);
            }
        } else {
            print_tbl_line_str(win_type, 3 + i - start_index, 2, " ");
        }
    }

    //输出分页的信息
    sprintf(tmp, "- curr_page[%d] pages[%d] -", current_frame.current_page, sumPages);
    print_tbl_page_info(win_type, tmp);

    return true;
}

/*
static int display_mid(WINDOW_TYPE win_type)
{
    char tmp[1024] = {0};

    if (bq_context.bq_error_flag) {
        return false;
    }

    //输出table的标题
    sprintf(tmp, "%-8s%-6s%-6s%-12s%-12s%-12s", "INDEX", "USED", "MID", "NAME", "IS_LOCAL", "NET_INDEX");
    print_tbl_header(win_type, tmp);
    int32 sumPages = 0;

    int start_index = getStartIndexByPage(&(current_frame.current_page), &sumPages,
            current_frame.maxLine,
            current_frame.page_size);

    int i;
    for (i = start_index; i < start_index + current_frame.page_size; i++) {
        if (i < current_frame.maxLine) {
            snprintf(tmp, sizeof(tmp), "%-8d%-6d%-6d%-12s%-12d%-12d", i,
                    (uint32)(bq_context.mid_table->midRouteTable[i].used),
                    (uint32)(bq_context.mid_table->midRouteTable[i].mid),
                    bq_context.mid_table->midRouteTable[i].name,
                    (uint32)(bq_context.mid_table->midRouteTable[i].local),
                    (uint32)(bq_context.mid_table->midRouteTable[i].netIndex));
            if (current_frame.currentSel == i) {
                print_tbl_line_str_reverse(win_type, 3 + i - start_index, 2, tmp);
            } else {
                print_tbl_line_str(win_type, 3 + i - start_index, 2, tmp);
            }
        } else {
            print_tbl_line_str(win_type, 3 + i - start_index, 2, " ");
        }
    }

    //输出分页的信息
    sprintf(tmp, "- curr_page[%d] pages[%d] -", current_frame.current_page, sumPages);
    print_tbl_page_info(win_type, tmp);

    return true;

}
*/

static int display_net(WINDOW_TYPE win_type)
{
    char tmp[1024] = {0};

     if (bq_context.bq_error_flag) {
         return false;
     }

     //输出table的标题
     sprintf(tmp, "%-8s%-6s%-18s%-18s%-8s%-12s", "INDEX", "USED", "LOCAL_IP", "REMOTE_IP", "PORT", "PROTOCOL");
     print_tbl_header(win_type, tmp);
     int32 sumPages = 0;

     int start_index = getStartIndexByPage(&(current_frame.current_page), &sumPages,
             current_frame.maxLine,
             current_frame.page_size);

     int i;
     for (i = start_index; i < start_index + current_frame.page_size; i++) {
         if (i < current_frame.maxLine) {
             snprintf(tmp, sizeof(tmp), "%-8d%-6d%-18s%-18s%-8d%-12s", i,
                     (uint32)(bq_context.net_table->netRouteTable[i].used),
                     bq_context.net_table->netRouteTable[i].ipAddr_str,
                     bq_context.net_table->netRouteTable[i].ipAddrSec_str,
                     bq_context.net_table->netRouteTable[i].port,
                     protocol_str[bq_context.net_table->netRouteTable[i].protocol]);
             if (current_frame.currentSel == i) {
                 print_tbl_line_str_reverse(win_type, 3 + i - start_index, 2, tmp);
             } else {
                 print_tbl_line_str(win_type, 3 + i - start_index, 2, tmp);
             }
         } else {
             print_tbl_line_str(win_type, 3 + i - start_index, 2, " ");
         }
     }

     //输出分页的信息
     sprintf(tmp, "- curr_page[%d] pages[%d] -", current_frame.current_page, sumPages);
     print_tbl_page_info(win_type, tmp);

     return true;
}

static int display_net_detail(WINDOW_TYPE win_type)
{
    char tmp[1024] = {0};

    if (bq_context.bq_error_flag) {
        return false;
    }

    const char *net_status[] = {
            "BQ_NET_STATUS_EMPTY",
            "BQ_NET_STATUS_CONNECTED",
            "BQ_NET_STATUS_DISCONNECTED"
    };

    const char *disconn_reason[] = {
        "BQ_DISCONN_REASON_EMPTY",
        "BQ_DISCONN_REASON_CONN",
        "BQ_DISCONN_REASON_RS",
        "BQ_DISCONN_REASON_HB",
        "BQ_DISCONN_REASON_MANUAL",
        "BQ_DISCONN_REASON_UNKNOW"
    };

    //输出table的标题
    sprintf(tmp, "%-20s", "NET_ROUTE_DETAIL");
    print_tbl_header(win_type, tmp);
    int32 sumPages = 0;

    int start_index = getStartIndexByPage(&(current_frame.current_page), &sumPages,
            current_frame.maxLine,
            current_frame.page_size);

    BQ_NET_ROUTE_ENTRY *route_entry = &(bq_context.net_table->netRouteTable[parent_frame.currentSel]);
    int i;
    for (i = start_index; i < start_index + current_frame.page_size; i++) {
        if (i < current_frame.maxLine) {
            switch (i) {
                case 0:
                    snprintf(tmp, sizeof(tmp), "used: %-20d", (uint32)(route_entry->used));
                    break;
                case 1:
                    snprintf(tmp, sizeof(tmp), "local_ip: %-20s", route_entry->ipAddr_str);
                    break;
                case 2:
                    snprintf(tmp, sizeof(tmp), "remote_ip: %-20s", route_entry->ipAddrSec_str);
                    break;
                case 3:
                    snprintf(tmp, sizeof(tmp), "port: %-20d", route_entry->port);
                    break;
                case 4:
                    snprintf(tmp, sizeof(tmp), "protocol: %-20s", protocol_str[route_entry->protocol]);
                    break;
                case 5:
                    snprintf(tmp, sizeof(tmp), "FID: %-20d", (uint32)(route_entry->netfid));
                    break;
                case 6:
                    snprintf(tmp, sizeof(tmp), "netStatus: %-20s", net_status[route_entry->netStatus]);
                    break;
                case 7:
                    {
                        char tmp_buf[64];
                        fmt_date_time((TIME_TYPE*)&(route_entry->connectTime), DATETIME_FORMAT_EN, tmp_buf);
                        snprintf(tmp, sizeof(tmp), "connectTime: %-20s", tmp_buf);
                    }
                    break;
                case 8:
                    {
                        char tmp_buf[64];
                        fmt_date_time((TIME_TYPE*)&(route_entry->disconnTime), DATETIME_FORMAT_EN, tmp_buf);
                        snprintf(tmp, sizeof(tmp), "disconnTime: %-20s", tmp_buf);
                    }
                    break;
                case 9:
                    snprintf(tmp, sizeof(tmp), "disconnCount: %-20d", route_entry->disconnCount);
                    break;
                case 10:
                    snprintf(tmp, sizeof(tmp), "disconnReason: %-20s", disconn_reason[route_entry->disconnReason]);
                    break;
                case 11:
                    snprintf(tmp, sizeof(tmp), "failureHB: %-20d", route_entry->failureHB);
                    break;
                case 12:
                    snprintf(tmp, sizeof(tmp), "retryConnect: %-20d", route_entry->retryConnect);
                    break;
                case 13:
                    snprintf(tmp, sizeof(tmp), "sndPkgNum: %-20d", route_entry->sndPkgNum);
                case 14:
                    snprintf(tmp, sizeof(tmp), "rcvPkgNum: %-20d", route_entry->rcvPkgNum);
                    break;
                default:
                    snprintf(tmp, sizeof(tmp), "%-20s", " ");
                    break;
            }

            if (current_frame.currentSel == i) {
                print_tbl_line_str_reverse(win_type, 3 + i - start_index, 2, tmp);
            } else {
                print_tbl_line_str(win_type, 3 + i - start_index, 2, tmp);
            }
        } else {
            print_tbl_line_str(win_type, 3 + i - start_index, 2, " ");
        }
    }

    //输出分页的信息
    sprintf(tmp, "- curr_page[%d] pages[%d] -", current_frame.current_page, sumPages);
    print_tbl_page_info(win_type, tmp);

    return true;
}

static int display_task(WINDOW_TYPE win_type)
{
    char tmp[1024] = {0};

    if (bq_context.bq_error_flag) {
        return false;
    }

    //输出table的标题
    sprintf(tmp, "%-8s%-6s%-10s%-6s%-8s%-8s%-18s%-6s%-6s", "INDEX", "USED", "REGISTED", "FID", "PID", "COUNT", "NAME", "LOCAL", "NETIDX");
    print_tbl_header(win_type, tmp);
    int32 sumPages = 0;

    int start_index = getStartIndexByPage(&(current_frame.current_page), &sumPages,
            current_frame.maxLine,
            current_frame.page_size);

    int i;
    for (i = start_index; i < start_index + current_frame.page_size; i++)
    {
        if (i < current_frame.maxLine)
        {
            snprintf(tmp, sizeof(tmp), "%-8d%-6d%-10d%-6d%-8d%-8d%-18s%-6d%-6d", i,
                    (uint32)(bq_context.tasks->taskQueueArray[i].used),
                    (uint32)(bq_context.tasks->taskQueueArray[i].registed),
                    (uint32)(bq_context.tasks->taskQueueArray[i].fid),
                    (uint32)(bq_context.tasks->taskQueueArray[i].pid),
                     bq_context.tasks->taskQueueArray[i].queueCount,
                     bq_context.tasks->taskQueueArray[i].name,
                     bq_context.tasks->taskQueueArray[i].local,
                     bq_context.tasks->taskQueueArray[i].netIndex);
            if (current_frame.currentSel == i)
            {
                print_tbl_line_str_reverse(win_type, 3 + i - start_index, 2, tmp);
            }
            else
            {
                print_tbl_line_str(win_type, 3 + i - start_index, 2, tmp);
            }
        }
        else
        {
            print_tbl_line_str(win_type, 3 + i - start_index, 2, " ");
        }
    }

    //输出分页的信息
    sprintf(tmp, "- curr_page[%d] pages[%d] -", current_frame.current_page, sumPages);
    print_tbl_page_info(win_type, tmp);

    return true;
}

static int display_task_detail(WINDOW_TYPE win_type)
{
    char tmp[1024] = {0};

    if (bq_context.bq_error_flag) {
        return false;
    }

    //输出table的标题
    sprintf(tmp, "%-20s", "TASK_QUEUE_DETAIL");
    print_tbl_header(win_type, tmp);
    int32 sumPages = 0;

    int start_index = getStartIndexByPage(&(current_frame.current_page), &sumPages,
            current_frame.maxLine,
            current_frame.page_size);

    BQ_TASK_QUEUE *task = &(bq_context.tasks->taskQueueArray[parent_frame.currentSel]);
    int i;
    for (i = start_index; i < start_index + current_frame.page_size; i++) {
        if (i < current_frame.maxLine) {
            switch (i) {
                case 0:
                    snprintf(tmp, sizeof(tmp), "used: %-20d", (uint32)(task->used));
                    break;
                case 1:
                    snprintf(tmp, sizeof(tmp), "registed: %-20d", (uint32)(task->registed));
                    break;
                case 2:
                    snprintf(tmp, sizeof(tmp), "fid: %-20d", (uint32)(task->fid));
                    break;
                case 3:
                    snprintf(tmp, sizeof(tmp), "pid: %-20d", (uint32)(task->pid));
                    break;
                case 4:
                    snprintf(tmp, sizeof(tmp), "name: %-20s", task->name);
                    break;
                case 5:
                    snprintf(tmp, sizeof(tmp), "offsetHead: %-20d", task->offsetHead);
                    break;
                case 6:
                    snprintf(tmp, sizeof(tmp), "offsetTail: %-20d", task->offsetTail);
                    break;
                case 7:
                    snprintf(tmp, sizeof(tmp), "queueCount: %-20d", task->queueCount);
                    break;
                case 8:
                    snprintf(tmp, sizeof(tmp), "received: %-20d", task->received);
                    break;
                case 9:
                {
                    char tmp_buf[64];
                    fmt_date_time((TIME_TYPE*)&(task->lastRecvTime), DATETIME_FORMAT_EN, tmp_buf);
                    snprintf(tmp, sizeof(tmp), "lastRecvTime: %-20s", tmp_buf);
                    break;
                }
                case 10:
                    snprintf(tmp, sizeof(tmp), "processed: %-20d", task->processed);
                    break;
                case 11:
                {
                    char tmp_buf[64];
                    fmt_date_time((TIME_TYPE*)&(task->lastProcessTime), DATETIME_FORMAT_EN, tmp_buf);
                    snprintf(tmp, sizeof(tmp), "lastProcessTime: %-20s", tmp_buf);
                    break;
                }
                case 12:
                    snprintf(tmp, sizeof(tmp), "local: %-20d", (task->local));
                    break;
                case 13:
                    snprintf(tmp, sizeof(tmp), "netIndex: %-20d", (task->netIndex));
                    break;
                default:
                    snprintf(tmp, sizeof(tmp), "%-20s", " ");
                    break;
            }

            if (current_frame.currentSel == i) {
                print_tbl_line_str_reverse(win_type, 3 + i - start_index, 2, tmp);
            } else {
                print_tbl_line_str(win_type, 3 + i - start_index, 2, tmp);
            }
        } else {
            print_tbl_line_str(win_type, 3 + i - start_index, 2, " ");
        }
    }

    //输出分页的信息
    sprintf(tmp, "- curr_page[%d] pages[%d] -", current_frame.current_page, sumPages);
    print_tbl_page_info(win_type, tmp);

    return true;
}


static int display_free_q(WINDOW_TYPE win_type)
{

    char tmp[1024] = {0};

     if (bq_context.bq_error_flag) {
         return false;
     }

     const char *bq_node_type[] = {
         "BQ_SMALL_TYPE",
         "BQ_MEDIUM_TYPE",
         "BQ_LARGE_TYPE",
         "BQ_HUGE_TYPE_0",
         "BQ_HUGE_TYPE"
     };

     //输出table的标题
     sprintf(tmp, "%-6s%-5s%-18s%-10s%-8s%-8s%-12s%-13s%-13s", "INDEX", "USED", "TYPE", "ALL_NODE", "HEAD", "TAIL",
             "FREE_NODE", "WARN_LEVEL", "FAILED_COUNT");
     print_tbl_header(win_type, tmp);
     int32 sumPages = 0;

     int start_index = getStartIndexByPage(&(current_frame.current_page), &sumPages,
             current_frame.maxLine,
             current_frame.page_size);

     int i;
     for (i = start_index; i < start_index + current_frame.page_size; i++) {
         if (i < current_frame.maxLine) {
             snprintf(tmp, sizeof(tmp), "%-6d%-5d%-18s%-10d%-8d%-8d%-12d%-13d%-13d", i,
                     (uint32)(bq_context.free_queue->freeQueueArray[i].used),
                      bq_node_type[bq_context.free_queue->freeQueueArray[i].type],
                      bq_context.free_queue->freeQueueArray[i].count,
                     bq_context.free_queue->freeQueueArray[i].offsetHead,
                     bq_context.free_queue->freeQueueArray[i].offsetTail,
                     bq_context.free_queue->freeQueueArray[i].queueCount,
                     bq_context.free_queue->freeQueueArray[i].warnLevel,
                     bq_context.free_queue->freeQueueArray[i].getFailedCount);
             if (current_frame.currentSel == i) {
                 print_tbl_line_str_reverse(win_type, 3 + i - start_index, 2, tmp);
             } else {
                 print_tbl_line_str(win_type, 3 + i - start_index, 2, tmp);
             }
         } else {
             print_tbl_line_str(win_type, 3 + i - start_index, 2, " ");
         }
     }

     //输出分页的信息
     sprintf(tmp, "- curr_page[%d] pages[%d] -", current_frame.current_page, sumPages);
     print_tbl_page_info(win_type, tmp);

     return true;

}

int draw_win_bqueues( WINDOW_TYPE win_type )
{
    if (current_frame.display_type != current_frame.display_type_keep)
    {
        //清除windows内容
        clear_tbl_win(win_type);

        //输出当前模块名
        print_tbl_module_name(win_type);

        current_frame.display_type_keep = current_frame.display_type;
    }
    
    if (bq_context.bq_error_flag) {
        return false;
    }

    //输出当前模块名
    print_tbl_module_name(win_type);

    switch (current_frame.display_type) {
        case BQ_DISPLAY_TOP:
            display_top(win_type);
            break;
        case BQ_DISPLAY_NET:
            display_net(win_type);
            break;
        case BQ_DISPLAY_NET_DETAIL:
            display_net_detail(win_type);
            break;
        case BQ_DISPLAY_TASK:
            display_task(win_type);
            break;
        case BQ_DISPLAY_TASK_DETAIL:
            display_task_detail(win_type);
            break;
        case BQ_DISPLAY_FREE_Q:
            display_free_q(win_type);
            break;
        default:
            display_empty(win_type);
            break;

    }
    refresh_tbl_win(win_type);

    return true;
}

static bool bq_handle_key_up(WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    if (bq_context.bq_error_flag) {
        return false;
    }

    current_frame.currentSel--;
    if (current_frame.currentSel < 0) {
        current_frame.currentSel = current_frame.maxLine - 1;
    }
    current_frame.current_page = (current_frame.currentSel)/(current_frame.page_size) + 1;

    return true;
}

static bool bq_handle_key_down(WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    if (bq_context.bq_error_flag) {
        return false;
    }

    current_frame.currentSel++;
    if (current_frame.currentSel >= current_frame.maxLine) {
        current_frame.currentSel = 0;
    }
    current_frame.current_page = (current_frame.currentSel)/(current_frame.page_size) + 1;

    return true;
}

static bool bq_handle_key_left(WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    if (bq_context.bq_error_flag) {
        return false;
    }

    current_frame.current_page--;
    if (current_frame.current_page < 1) {
        if ((current_frame.maxLine)%(current_frame.page_size) == 0) {
            current_frame.current_page = (current_frame.maxLine)/(current_frame.page_size);
        } else {
            current_frame.current_page = (current_frame.maxLine)/(current_frame.page_size) + 1;
        }
    }
    int32 sumPages = 0;
    current_frame.currentSel = getStartIndexByPage(&(current_frame.current_page), &sumPages,
            current_frame.maxLine,
            current_frame.page_size);

    return true;
}

static bool bq_handle_key_right(WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    if (bq_context.bq_error_flag) {
        return false;
    }

    current_frame.current_page++;
    int32 max_page = (current_frame.maxLine)/(current_frame.page_size) + 1;
    if ((current_frame.maxLine)%(current_frame.page_size) == 0) {
        max_page = (current_frame.maxLine)/(current_frame.page_size);
    }
    if (current_frame.current_page > max_page) {
        current_frame.current_page = 1;
    }
    int32 sumPages = 0;
    int32 current_sel = getStartIndexByPage(&(current_frame.current_page), &sumPages,
            current_frame.maxLine,
            current_frame.page_size);
    current_frame.currentSel = current_sel;

    return true;

}

static bool bq_handle_key_enter(WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    switch (current_frame.display_type) {
        case BQ_DISPLAY_TOP:
            if (BQ_DISPLAY_NET == current_frame.data.lines[current_frame.currentSel].common_info.enter_type) {
                bq_context.stack_pointer++;
                current_frame.current_page = 1;
                current_frame.currentSel = 0;
                current_frame.maxLine = BQ_MAX_NET_NUM;
                current_frame.page_size = PAGE_SIZE;
                current_frame.display_type = BQ_DISPLAY_NET;
            } else if (BQ_DISPLAY_TASK == current_frame.data.lines[current_frame.currentSel].common_info.enter_type) {
                bq_context.stack_pointer++;
                current_frame.current_page = 1;
                current_frame.currentSel = 0;
                current_frame.maxLine = BQ_MAX_TASK_NUM;
                current_frame.page_size = PAGE_SIZE;
                current_frame.display_type = BQ_DISPLAY_TASK;
            }  else if (BQ_DISPLAY_FREE_Q == current_frame.data.lines[current_frame.currentSel].common_info.enter_type) {
                bq_context.stack_pointer++;
                current_frame.current_page = 1;
                current_frame.currentSel = 0;
                current_frame.maxLine = BQ_TYPE_NUM;
                current_frame.page_size = PAGE_SIZE;
                current_frame.display_type = BQ_DISPLAY_FREE_Q;
            }
            break;
        case BQ_DISPLAY_NET:
            {
                bq_context.stack_pointer++;
                current_frame.current_page = 1;
                current_frame.currentSel = 0;
                current_frame.maxLine = 15;
                current_frame.page_size = PAGE_SIZE;
                current_frame.display_type = BQ_DISPLAY_NET_DETAIL;
            }
            break;
        case BQ_DISPLAY_TASK:
            {
                bq_context.stack_pointer++;
                current_frame.current_page = 1;
                current_frame.currentSel = 0;
                current_frame.maxLine = 13;
                current_frame.page_size = PAGE_SIZE;
                current_frame.display_type = BQ_DISPLAY_TASK_DETAIL;
            }
            break;
        default:
            break;
    }

    return true;
}

static bool bq_handle_key_escape(WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    if (bq_context.stack_pointer > 0) {
        bq_context.stack_pointer--;
    }

    return true;
}

int handle_win_bqueues( WINDOW_TYPE win_type, int ch )
{
    if (bq_context.bq_error_flag) {
        return false;
    }

    switch(ch)
    {
        case KEY_UP:
            bq_handle_key_up(win_type);
            break;
        case KEY_DOWN:
            bq_handle_key_down(win_type);
            break;
        case KEY_LEFT:
            bq_handle_key_left(win_type);
            break;
        case KEY_RIGHT:
            bq_handle_key_right(win_type);
            break;
        case 10:     //enter
            bq_handle_key_enter(win_type);
            break;
        case 27:    //escapt
        case 96:    //`
            bq_handle_key_escape(win_type);
            break;
        default:
            break;
    }
    draw_win_bqueues(win_type);
    return true;
}

int command_win_bqueues( WINDOW_TYPE win_type, char *cmdstr, int length )
{
    ts_notused(win_type);
    ts_notused(cmdstr);
    ts_notused(length);

    if (bq_context.bq_error_flag) {
        return false;
    }

    return true;
}

int refresh_win_bqueues( WINDOW_TYPE win_type)
{
    if (bq_context.bq_error_flag) {
        return false;
    }

    draw_win_bqueues(win_type);
    return true;
}



