#ifndef REPLY_FUNC_H_INCLUDED
#define REPLY_FUNC_H_INCLUDED

//TFE_REPLY_FUNCTION中的rproc函数的返回值
#define EXIT_ERR  -1  //处理发生错误
#define EXIT_NCPC  0  //处理返回并将INM消息发回给NCPC
#define EXIT_ONLY  1  //处理返回
#define EXIT_SAFE_CLOSE 2 //系统安全关闭，reply安全退出

typedef struct _MSG_DISPATCH_CELL
{
    uint8 inm_type;
    int (*msg_process_fun)(char *inm_buf);
}MSG_DISPATCH_CELL;


//售票更新期次统计信息  (参数为: 票的金额 和 票的注数)
int update_issue_stat_by_sale(uint8 game_code, uint32 issue_serial, uint32 issue_count, money_t ticket_amount, uint32 bet_count);
//兑奖更新 游戏统计 信息  (参数为: 票的金额 和 票的注数)
int update_issue_stat_by_pay(uint8 game_code, money_t ticket_amount);
//退票更新 游戏统计 和 期次统计 信息  (参数为: 票的金额 和 票的注数)
int update_issue_stat_by_cancel(uint8 game_code, uint32 issue_serial, uint32 issue_count, money_t ticket_amount, uint32 bet_count);


int rproc_N_echo(char *inm_buf);

int rproc_TFE_checkpoint(char *inm_buf);

int rproc_SYS_business_state(char *inm_buf);
int rproc_SYS_switch_session(char *inm_buf);

int rproc_T_echo(char *inm_buf);
int rproc_T_sell_ticket(char *inm_buf);
int rproc_T_pay_ticket(char *inm_buf);
int rproc_T_cancel_ticket(char *inm_buf);

int rproc_GL_issue_presale(char *inm_buf);
int rproc_GL_issue_open(char *inm_buf);
int rproc_GL_issue_closing(char *inm_buf);
int rproc_GL_issue_closed(char *inm_buf);

int rproc_O_pay_ticket(char *inm_buf);
int rproc_O_cancel_ticket(char *inm_buf);

int rproc_O_fbs_pay_ticket(char *inm_buf);
int rproc_O_fbs_cancel_ticket(char *inm_buf);


int rproc_FBS_sell_ticket(char *inm_buf);
int rproc_FBS_pay_ticket(char *inm_buf);
int rproc_FBS_cancel_ticket(char *inm_buf);


#endif //REPLY_FUNC_H_INCLUDED

