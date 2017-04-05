#include "tsview.h"
#include "gl_inf.h"

bool gl_init_flag = false;

#define gl_win_top_line       4
#define gl_win_buttom_line    (MAIN_WIN_STATUS_LINE-2)

#define gl_win_lins  (gl_win_buttom_line-gl_win_top_line+1)



bool gl_error_flag = false;


typedef enum _GL_DISPALY_TYPE
{
    GL_DISPLAY_EMPTY = 0,
    GL_DISPLAY_GAME_LIST,
    GL_DISPLAY_GAME_PARAM
}GL_DISPALY_TYPE;

static GL_DISPALY_TYPE gl_display_type = GL_DISPLAY_EMPTY;
static GL_DISPALY_TYPE gl_display_type_keep = GL_DISPLAY_EMPTY;



//在可移动的行上 或 单独的页面上  定义用户的自定义数据
typedef struct _list_gl_info
{
    GL_DISPALY_TYPE enter_type;
    int enter_index;                //定义回车键的将显示的数组索引
}list_gl_info;


//GL_DISPLAY_FIRST_LIST    first page 页面的数据
typedef struct _display_game_list_data
{
    int currentSel;            //当前选择的行号
    int lineNum;               //当前页显示的总行数
    //
    list_gl_info data[MAIN_WIN_MAX_LINE];     //行索引数据  每页显示行数应该不会超过40
}display_game_list_data;


typedef struct _display_game_param_data
{
    int game_code;         //ncpc表数组索引

    list_gl_info data[MAIN_WIN_MAX_LINE];     //行索引数据  每页显示行数应该不会超过40
}display_game_param_data;


//定义页面显示的变量数据
static display_game_list_data game_list_data;
static display_game_param_data game_param_data;


int init_win_gl(WINDOW_TYPE win_type)
{
    ts_notused(win_type);

    if (gl_init_flag)
        return 0;

    if(!gl_init())
    {
        logit("gl shm attach failed.");

        return false;
    }

    memset(&game_list_data, 0, sizeof(display_game_list_data));
    memset(&game_param_data, 0, sizeof(display_game_param_data));

    game_list_data.currentSel = 0;

    gl_display_type = GL_DISPLAY_GAME_LIST;
    gl_init_flag = true;
    return true;
}

int close_win_gl( WINDOW_TYPE win_type )
{
    ts_notused(win_type);

    gl_init_flag = false;
    //gl_close();
    return true;
}

int draw_game_list( WINDOW_TYPE win_type)
{
    //输出列表
    game_list_data.lineNum = 0;

    GAME_DATA *ptr = NULL;
    char tmp[512] = {0};
    int i;

    if (gl_error_flag)
        return true;

    //输出列表
    int ln = 1;

    sprintf(tmp, "     gameCode      SaleFlag  CancelFlag  PayFlag  RiskCtrl    GameName");
    print_tbl_header(win_type, tmp);

    for(i=0;i<MAX_GAME_NUMBER;i++)
    {
        ptr = gl_getGameData(i);
        if(ptr->used)
        {
            memset(tmp,0,sizeof(tmp));
            sprintf(tmp, "%-3d [ %2d %4s ]    [ %d ]     [ %d ]       [ %d ]    [ %d ]    %s",
                ln, ptr->gameEntry.gameCode,ptr->gameEntry.gameAbbr,
                ptr->transctrlParam.saleFlag,
                ptr->transctrlParam.cancelFlag,
                ptr->transctrlParam.payFlag,
                ptr->transctrlParam.riskCtrl,
                ptr->gameEntry.gameName);
            ln++;

            if (game_list_data.currentSel==game_list_data.lineNum)
            {
                game_list_data.data[game_list_data.currentSel].enter_type = GL_DISPLAY_GAME_PARAM;
                game_list_data.data[game_list_data.currentSel].enter_index = (int)ptr->gameEntry.gameCode;
                print_tbl_line_str_reverse(win_type, game_list_data.lineNum+gl_win_top_line, 2, tmp);
            }
            else
            {
                print_tbl_line_str(win_type, game_list_data.lineNum+gl_win_top_line, 2, tmp);
            }
            game_list_data.lineNum++;
        }
    }
    return true;
}

int draw_game_param( WINDOW_TYPE win_type)
{
    char tmp[256] = {0};
    int count = 0;
    GAME_DATA *ptr = gl_getGameData(game_param_data.game_code);
    if ((ptr==NULL) || !ptr->used)
    {
        sprintf(tmp, "Game[ %d ] is not exist.", game_param_data.game_code);
        print_tbl_header(win_type, tmp);
        return 0;
    }

    //输出table的标题
    sprintf(tmp, "Game[ %d  %s] parameter", ptr->gameEntry.gameCode, ptr->gameEntry.gameAbbr);
    print_tbl_header(win_type, tmp);

    sprintf(tmp, "gameName[ %s ]", ptr->gameEntry.gameName);
    print_tbl_line_str(win_type, count+gl_win_top_line, 2, tmp);
    count++;
    sprintf(tmp, "organizationName[ %s ]", ptr->gameEntry.organizationName);
    print_tbl_line_str(win_type, count+gl_win_top_line, 2, tmp);
    count++;
    count++;

    sprintf(tmp, "publicFundRate[ %d ]   adjustmentFundRate[ %d ]   returnRate[ %d ]",
        ptr->policyParam.publicFundRate, ptr->policyParam.adjustmentFundRate, ptr->policyParam.returnRate);
    print_tbl_line_str(win_type, count+gl_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "taxStartAmount[ %lld ]   taxRate[ %d ]   payEndDay[ %d ]",
        ptr->policyParam.taxStartAmount, ptr->policyParam.taxRate, ptr->policyParam.payEndDay);
    print_tbl_line_str(win_type, count+gl_win_top_line, 2, tmp);
    count++;
    count++;

    sprintf(tmp, "drawType[ %d ]", ptr->transctrlParam.drawType);
    print_tbl_line_str(win_type, count+gl_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "riskCtrl[ %d ]   Param[ %s ]", ptr->transctrlParam.riskCtrl, ptr->transctrlParam.riskCtrlParam);
    print_tbl_line_str(win_type, count+gl_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "autoDraw[ %d ]   cancelTime[ %d ]   countDownTimes[ %d ]",
        ptr->transctrlParam.autoDraw, ptr->transctrlParam.cancelTime, ptr->transctrlParam.countDownTimes);
    print_tbl_line_str(win_type, count+gl_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "maxTimesPerBetLine[ %d ]   maxBetLinePerTicket[ %d ]   maxIssueCount[ %d ]   maxAmountPerTicket[ %lld ]",
        ptr->transctrlParam.maxTimesPerBetLine, ptr->transctrlParam.maxBetLinePerTicket,
        ptr->transctrlParam.maxIssueCount, ptr->transctrlParam.maxAmountPerTicket);
    print_tbl_line_str(win_type, count+gl_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "gamePayLimited[ %lld ]   bigPrizeLimited[ %lld ]",
        ptr->transctrlParam.gamePayLimited, ptr->transctrlParam.bigPrize);
    print_tbl_line_str(win_type, count+gl_win_top_line, 2, tmp);
    count++;

    /*
    sprintf(tmp, "branchCenterPayLimited[ %lld ]   branchCenterCancelLimited[ %lld ]",
        ptr->transctrlParam.branchCenterPayLimited, ptr->transctrlParam.branchCenterCancelLimited);
    print_tbl_line_str(win_type, count+gl_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "commonTellerPayLimited[ %lld ]   commonTellerCancelLimited[ %lld ]",
        ptr->transctrlParam.commonTellerPayLimited, ptr->transctrlParam.commonTellerCancelLimited);
    print_tbl_line_str(win_type, count+gl_win_top_line, 2, tmp);
    count++;
    */

    sprintf(tmp, "saleLimit[ %lld ]   payLimit[ %lld ]   cancelLimit[ %lld ]",
        ptr->transctrlParam.saleLimit, ptr->transctrlParam.payLimit, ptr->transctrlParam.cancelLimit);
    print_tbl_line_str(win_type, count+gl_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "service time[ %04d - %04d ]  [ %04d - %04d ]",
        ptr->transctrlParam.service_time_1_b, ptr->transctrlParam.service_time_1_e,
        ptr->transctrlParam.service_time_2_b, ptr->transctrlParam.service_time_2_e);
    print_tbl_line_str(win_type, count+gl_win_top_line, 2, tmp);
    count++;

    sprintf(tmp, "Statistics  sale[ %lld - %d ]   pay[ %lld - %d ]   cancel[ %lld - %d ]",
        ptr->gameDayStat.saleAmount, ptr->gameDayStat.saleCount,
        ptr->gameDayStat.payAmount, ptr->gameDayStat.payCount,
        ptr->gameDayStat.cancelAmount, ptr->gameDayStat.cancelCount);
    print_tbl_line_str(win_type, count+gl_win_top_line, 2, tmp);
    count++;


    RNG_PARAM *rng = NULL;
    for(int i=0;i<MAX_RNG_NUMBER;i++)
    {
        rng = gl_getRngData() + i;
        if (!rng->used)
            continue;

        sprintf(tmp, "RNG - %d   Ip[ %16s ] Mac[ %02X:%02X:%02X:%02X:%02X:%02X ] Status[ %s ] Work[ %s ] Name[ %s ] Game[ %d ]",
            rng->rngId,
            rng->rngIp,
            rng->rngMac[0],rng->rngMac[1],rng->rngMac[2],rng->rngMac[3],rng->rngMac[4],rng->rngMac[5],
            (rng->status==ENABLED)?"ENABLED":((rng->status==DISABLED)?"DISABLED":((rng->status==DELETED)?"DELETED":"UNKNOW")),
            (rng->workStatus==1)?"CONNECT":((rng->workStatus==2)?"INITIALIZING":((rng->workStatus==3)?"WORKING":"DISCONNECT")),
            rng->rngName, rng->gameCode);
        print_tbl_line_str(win_type, count+gl_win_top_line, 2, tmp);
        count++;
    }
    return true;
}

int draw_win_gl( WINDOW_TYPE win_type )
{
    if (gl_display_type != gl_display_type_keep)
    {
        //清除windows内容
        clear_tbl_win(win_type);

        //输出当前模块名
        print_tbl_module_name(win_type);

        gl_display_type_keep = gl_display_type;
    }

    if (gl_error_flag)
        return false;

    switch (gl_display_type)
    {
        case GL_DISPLAY_GAME_LIST:
        {
            draw_game_list(win_type);
            break;
        }
        case GL_DISPLAY_GAME_PARAM:
        {
            draw_game_param(win_type);
            break;
        }
        default:
        {
            //log_error("gl display type error!!");
            break;
        }
    }
    refresh_tbl_win(win_type);

    return true;
}

//-------自定义函数-----------------------------------------------------------

int gl_handle_key_left( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    if (gl_error_flag)
        return false;

    switch (gl_display_type)
    {
        case GL_DISPLAY_GAME_LIST:
        {
            break;
        }
        case GL_DISPLAY_GAME_PARAM:
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

int gl_handle_key_right( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    if (gl_error_flag)
        return false;

    switch (gl_display_type)
    {
        case GL_DISPLAY_GAME_LIST:
        {
            break;
        }
        case GL_DISPLAY_GAME_PARAM:
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


int gl_handle_key_up( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    if (gl_error_flag)
        return false;

    switch (gl_display_type)
    {
        case GL_DISPLAY_GAME_LIST:
        {
            game_list_data.currentSel--;
            if (game_list_data.currentSel<0)
                game_list_data.currentSel = game_list_data.lineNum-1;
            break;
        }
        case GL_DISPLAY_GAME_PARAM:
        {
            /*
            game_param_data.currentSel--;
            if (game_param_data.currentSel<0)
                game_param_data.currentSel = game_param_data.lineNum-1;
            */
            break;
        }
        default:
        {
            break;
        }
    }
    return true;
}

int gl_handle_key_down( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    if (gl_error_flag)
        return false;

    switch (gl_display_type)
    {
        case GL_DISPLAY_GAME_LIST:
        {
            game_list_data.currentSel++;
            if (game_list_data.currentSel>=game_list_data.lineNum)
                game_list_data.currentSel = 0;
            break;
        }
        case GL_DISPLAY_GAME_PARAM:
        {
            /*
            game_param_data.currentSel++;
            if (game_param_data.currentSel>=game_param_data.lineNum)
                game_param_data.currentSel = 0;
            */
            break;
        }
        default:
        {
            break;
        }
    }
    return true;
}

int gl_handle_key_enter( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    if (gl_error_flag)
        return false;

    switch (gl_display_type)
    {
        case GL_DISPLAY_GAME_LIST:
        {
            if (game_list_data.data[game_list_data.currentSel].enter_type!=GL_DISPLAY_EMPTY)
            {
                gl_display_type = game_list_data.data[game_list_data.currentSel].enter_type;
                game_param_data.game_code = game_list_data.data[game_list_data.currentSel].enter_index;
            }
            break;
        }
        case GL_DISPLAY_GAME_PARAM:
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

int gl_handle_key_escape( WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    if (gl_error_flag)
        return false;

    switch (gl_display_type)
    {
        case GL_DISPLAY_GAME_LIST:
        {
            break;
        }
        case GL_DISPLAY_GAME_PARAM:
        {
            gl_display_type = GL_DISPLAY_GAME_LIST;
            break;
        }
        default:
        {
            break;
        }
    }
    return true;
}

int gl_handle_key_h(WINDOW_TYPE win_type)
{
    ts_notused(win_type);
    //输出本窗口的帮助信息，再按一次'h'消失
    return true;
}

int handle_win_gl( WINDOW_TYPE win_type, int ch )
{
    if (gl_error_flag)
        return false;

    switch(ch)
    {
        case KEY_UP:
            gl_handle_key_up(win_type);
            break;
        case KEY_DOWN:
            gl_handle_key_down(win_type);
            break;
        case KEY_LEFT:
            gl_handle_key_left(win_type);
            break;
        case KEY_RIGHT:
            gl_handle_key_right(win_type);
            break;
        case 10:     //enter
            gl_handle_key_enter(win_type);
            break;
        case 27:    //escapt
        case 96:    //`
            gl_handle_key_escape(win_type);
            break;
        case 'h':
            gl_handle_key_h(win_type);
            break;
        default:
            break;
    }
    draw_win_gl(win_type);

    return true;
}

int command_win_gl( WINDOW_TYPE win_type, char *cmdstr, int length )
{
    ts_notused(win_type);
    ts_notused(cmdstr);
    ts_notused(length);
    if (gl_error_flag)
        return false;

    return true;
}

int refresh_win_gl( WINDOW_TYPE win_type)
{
    if (gl_error_flag)
        return false;

    draw_win_gl(win_type);
    return true;
}


