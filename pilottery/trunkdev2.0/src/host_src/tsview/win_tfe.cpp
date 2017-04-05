#include "tsview.h"
#include "gl_inf.h"
#include "tfe_inf.h"

bool tfe_init_flag = false;

int init_flag = 0;


int init_win_tf(WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    if (tfe_init_flag)
        return 0;

    if (!gl_init()) {
        logit("gl_init failed.");
        return false;
    }

    if (tfe_init()!=0) {
        logit("tfe_init failed.");
        return false;
    }
    tfe_init_flag = true;
    return true;
}

int close_win_tf( WINDOW_TYPE win_type )
{
    ts_notused(win_type);

    tfe_init_flag = false;
    return true;
}

static int display_task_list(WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    int top_line = 4;

    char tmp[1024] = {0};

    //输出table的标题
    sprintf(tmp, "%-8s %-16s   %-8s %-11s   %-12s %-15s   %-12s",
            "INDEX", "NAME", "FILE_IDX", "FILE_OFFSET", "FILE_PRE_IDX", "FILE_PRE_OFFSET", "RECORD_COUNT");
    print_tbl_header(win_type, tmp);

    uint32 fileIdx = 0;
    uint32 offset = 0;
    uint32 fileIdx_pre = 0;
    uint32 offset_pre = 0;
    tfe_get_offset(TFE_TASK_ADDER, &fileIdx, &offset);
    tfe_get_pre_offset(TFE_TASK_ADDER, &fileIdx_pre, &offset_pre);
    snprintf(tmp, sizeof(tmp), "%-8d %-16s   %-8d %-11d                                  %-12lld",
        TFE_TASK_ADDER, "tfe_adder", fileIdx, offset, tfe_get_count(TFE_TASK_ADDER));
    print_tbl_line_str(win_type, top_line, 2, tmp);
    top_line += 1;

    tfe_get_offset(TFE_TASK_FLUSH, &fileIdx, &offset);
    snprintf(tmp, sizeof(tmp), "%-8d %-16s   %-8d %-11d", TFE_TASK_FLUSH, "tfe_flush", fileIdx, offset);
    print_tbl_line_str(win_type, top_line, 2, tmp);
    top_line += 2;

    tfe_get_offset(TFE_TASK_REPLY, &fileIdx, &offset);
    tfe_get_pre_offset(TFE_TASK_REPLY, &fileIdx_pre, &offset_pre);
    snprintf(tmp, sizeof(tmp), "%-8d %-16s   %-8d %-11d   %-12d %-15d   %-12lld",
        TFE_TASK_REPLY, "tfe_reply", fileIdx, offset, fileIdx_pre, offset_pre, tfe_get_count(TFE_TASK_REPLY));
    print_tbl_line_str(win_type, top_line, 2, tmp);
    top_line += 1;

    tfe_get_offset(TFE_TASK_SCAN, &fileIdx, &offset);
    tfe_get_pre_offset(TFE_TASK_SCAN, &fileIdx_pre, &offset_pre);
    snprintf(tmp, sizeof(tmp), "%-8d %-16s   %-8d %-11d   %-12d %-15d   %-12lld",
        TFE_TASK_SCAN, "tfe_scan", fileIdx, offset, fileIdx_pre, offset_pre, tfe_get_count(TFE_TASK_SCAN));
    print_tbl_line_str(win_type, top_line, 2, tmp);
    top_line += 1;

    tfe_get_offset(TFE_TASK_UPDATE, &fileIdx, &offset);
    tfe_get_pre_offset(TFE_TASK_UPDATE, &fileIdx_pre, &offset_pre);
    snprintf(tmp, sizeof(tmp), "%-8d %-16s   %-8d %-11d   %-12d %-15d   %-12lld",
        TFE_TASK_UPDATE, "tfe_update", fileIdx, offset, fileIdx_pre, offset_pre, tfe_get_count(TFE_TASK_UPDATE));
    print_tbl_line_str(win_type, top_line, 2, tmp);
    top_line += 1;

    tfe_get_offset(TFE_TASK_UPDATE_DB, &fileIdx, &offset);
    tfe_get_pre_offset(TFE_TASK_UPDATE_DB, &fileIdx_pre, &offset_pre);
    snprintf(tmp, sizeof(tmp), "%-8d %-16s   %-8d %-11d   %-12d %-15d   %-12lld",
        TFE_TASK_UPDATE_DB, "tfe_update_db", fileIdx, offset, fileIdx_pre, offset_pre, tfe_get_count(TFE_TASK_UPDATE_DB));
    print_tbl_line_str(win_type, top_line, 2, tmp);
    top_line += 1;

	/*
    tfe_get_offset(TFE_TASK_UPDATE_DB2, &fileIdx, &offset);
    tfe_get_pre_offset(TFE_TASK_UPDATE_DB2, &fileIdx_pre, &offset_pre);
    snprintf(tmp, sizeof(tmp), "%-8d %-16s   %-8d %-11d   %-12d %-15d   %-12lld",
        TFE_TASK_UPDATE_DB2, "tfe_update_db2", fileIdx, offset, fileIdx_pre, offset_pre, tfe_get_count(TFE_TASK_UPDATE_DB2));
    print_tbl_line_str(win_type, top_line, 2, tmp);
    top_line += 1;
	*/

    /*
    tfe_get_offset(TFE_TASK_REMOTE_SYNC, &fileIdx, &offset);
    tfe_get_pre_offset(TFE_TASK_REMOTE_SYNC, &fileIdx_pre, &offset_pre);
    snprintf(tmp, sizeof(tmp), "%-8d %-16s   %-8d %-11d   %-12d %-15d   %-12lld",
        TFE_TASK_REMOTE_SYNC, "tfe_remote_sync", fileIdx, offset, fileIdx_pre, offset_pre, tfe_get_count(TFE_TASK_REMOTE_SYNC));
    print_tbl_line_str(win_type, top_line, 2, tmp);
    top_line += 1;
    */

    top_line += 2;
    char buf_time[64] = {0};
    fmt_time_t(tfe_get_last_checkpoint_time(), DATETIME_FORMAT_EN, buf_time);
    snprintf(tmp, sizeof(tmp), "Last Checkpoint Time[ %s ] Identify[ %lld ]", buf_time, tfe_get_checkpoint_seq());
    print_tbl_line_str(win_type, top_line, 2, tmp);

    return true;
}

int draw_win_tf(WINDOW_TYPE win_type)
{
    if (init_flag == 0)
    {
        //清除windows内容
        clear_tbl_win(win_type);

        //输出当前模块名
        print_tbl_module_name(win_type);

        init_flag = 1;
    }


    display_task_list(win_type);

    refresh_tbl_win(win_type);
    return true;
}

static bool tf_db_handle_key_up(WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return true;
}

static bool tf_db_handle_key_down(WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return true;
}

static bool tf_db_handle_key_left(WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return true;
}

static bool tf_db_handle_key_right(WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return true;

}

static bool tf_db_handle_key_enter(WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return true;
}

static bool tf_db_handle_key_escape(WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    return true;
}

int handle_win_tf( WINDOW_TYPE win_type, int ch )
{
    switch(ch)
    {
        case KEY_UP:
            tf_db_handle_key_up(win_type);
            break;
        case KEY_DOWN:
            tf_db_handle_key_down(win_type);
            break;
        case KEY_LEFT:
            tf_db_handle_key_left(win_type);
            break;
        case KEY_RIGHT:
            tf_db_handle_key_right(win_type);
            break;
        case 10:     //enter
            tf_db_handle_key_enter(win_type);
            break;
        case 27:    //escapt
        case 96:    //`
            tf_db_handle_key_escape(win_type);
            break;
        default:
            break;
    }
    draw_win_tf(win_type);
    return true;
}

int command_win_tf( WINDOW_TYPE win_type, char *cmdstr, int length )
{
    ts_notused(win_type);
    ts_notused(cmdstr);
    ts_notused(length);
    return true;
}

int refresh_win_tf( WINDOW_TYPE win_type)
{
    draw_win_tf(win_type);
    return true;
}

