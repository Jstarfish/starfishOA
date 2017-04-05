#include "global.h"
#include "gl_inf.h"
#include "otl_inf.h"


static char MY_TASK_NAME[32]; //gl_draw_fbs


static volatile int exit_signal_fired = 0;

static uint8 game_code = GAME_FBS;
SYS_TASK task_draw_idx = SYS_TASK_EMPTY;

GAME_PLUGIN_INTERFACE *game_handle = NULL;

//得到本期次的游戏规则数据
//static char game_buf[4*1024];
static FBS_GT_GAME_PARAM game_param;

int get_game_param(uint8 game_code, uint32 issue_number, char *game_buf);



//--- FBS 中奖票入库处理 -------------------------------------
#if 0
typedef struct _FBS_WIN_MSG {
    struct _FBS_WIN_MSG *next; // for queue

    uint8  type; //0-中奖票入库开始  1-中奖票入库   2-中奖票入库结束
    uint32 issue; //期号
    uint32 match; //比赛编码
    int32 len;
    uint64 data[];
} FBS_WIN_MSG;
#endif

#if 1  //caoxf__
typedef struct _FBS_WIN_MSG {
    struct _FBS_WIN_MSG *next; // for queue

    uint8  type; //0-开始进行本场次的开奖处理 1-中奖订单入库 2-中奖票入库 3-开奖完成的结束消息
    uint32 issue; //期号
    uint32 match; //比赛编码
    char*  ptr;
} FBS_WIN_MSG;
#endif

typedef struct _QUEUE_FBS_MSG QUEUE_FBS_MSG;
struct _QUEUE_FBS_MSG {
    int (*init)(QUEUE_FBS_MSG *q);
    void (*enqueue)(QUEUE_FBS_MSG *q, FBS_WIN_MSG* msg);
    FBS_WIN_MSG *(*dequeue)(QUEUE_FBS_MSG *q, int timeout_msec);
    int (*get_size)(QUEUE_FBS_MSG *q);
    FBS_WIN_MSG *head;
    FBS_WIN_MSG *tail;
    int size;
    pthread_mutex_t mutex;
    pthread_cond_t cond;
};
QUEUE_FBS_MSG *queue_fbs_msg_create();

static void queue_fbs_msg_enqueue(QUEUE_FBS_MSG *q, FBS_WIN_MSG *msg)
{
    pthread_mutex_lock(&(q->mutex));
    if (q->size == 0) {
        q->head = q->tail = msg;
        msg->next = NULL;
    }
    else
    {
        msg->next = NULL;
        q->tail->next = msg;
        q->tail = msg;
    }
    q->size++;
    pthread_mutex_unlock(&(q->mutex));
    pthread_cond_signal(&(q->cond));
    return;
}

static FBS_WIN_MSG *queue_fbs_msg_dequeue(QUEUE_FBS_MSG *q, int timeout_msec)
{
    pthread_mutex_lock(&(q->mutex));

    if (q->size <= 0) {
        if (timeout_msec == 0) {
            while (q->size == 0) {
                //阻塞接收
                pthread_cond_wait(&(q->cond), &(q->mutex));
            }
        } else {
            //带超时的阻塞收
            struct timespec timeout;
            int t_s = timeout_msec / 1000;
            int t_m = timeout_msec % 1000;
            struct timeval now;
            gettimeofday(&now, NULL);
            timeout.tv_sec = now.tv_sec + t_s;
            timeout.tv_nsec = (now.tv_usec*1000) + (t_m*1000*1000);
            if (timeout.tv_nsec >= 1000000000) {
                timeout.tv_nsec -= 1000000000;
                timeout.tv_sec++;
            }
            pthread_cond_timedwait(&(q->cond), &(q->mutex), &timeout);
            if (q->size == 0) {
                pthread_mutex_unlock(&(q->mutex));
                return NULL;
            }
        }
    }
    FBS_WIN_MSG *msg = q->head;
    q->head = msg->next;
    if (NULL == q->head)
        q->tail = NULL;
    q->size--;

    pthread_mutex_unlock(&(q->mutex));
    return msg;
}

static int queue_fbs_msg_size(QUEUE_FBS_MSG *q)
{
    pthread_mutex_lock(&(q->mutex));
    int size = q->size;
    pthread_mutex_unlock(&(q->mutex));
    return size;
}

QUEUE_FBS_MSG *queue_fbs_msg_create()
{
    QUEUE_FBS_MSG *q = (QUEUE_FBS_MSG *)malloc(sizeof(QUEUE_FBS_MSG));
    if (NULL == q) {
        log_error("malloc() return NULL.");
        return NULL;
    }
    memset(q, 0, sizeof(QUEUE_FBS_MSG));

    q->enqueue = queue_fbs_msg_enqueue;
    q->dequeue = queue_fbs_msg_dequeue;
    q->get_size = queue_fbs_msg_size;
    q->head = NULL;
    q->tail = NULL;
    q->size = 0;

    int ret = pthread_mutex_init(&(q->mutex), NULL);
    if (0 != ret)
    {
        log_error("pthread_mutex_init() failed. Reason:[%s].", strerror(errno));
        return NULL;
    }
    ret = pthread_cond_init(&(q->cond), NULL);
    if (0 != ret)
    {
        log_error("pthread_cond_init() failed. Reason:[%s].", strerror(errno));
        return NULL;
    }
    return q;
}

QUEUE_FBS_MSG *queue = NULL;




//----------------------------------------------------------------------------------

//连同此文件的md5文件一起移动
int move_file_md5(char *filepath, char *filepath_new)
{
    if(access(filepath,0) == 0) {
        //file exist
        if (rename(filepath,filepath_new) != 0) {
            perrork("rename(%s) file failed. Reason:%s.", filepath, strerror(errno));
            return -1;
        }
        char filepath_md5[256];
        char filepath_new_md5[256];
        sprintf(filepath_md5, "%s.md5", filepath);
        sprintf(filepath_new_md5, "%s.md5", filepath_new);
        if (rename(filepath_md5,filepath_new_md5) != 0) {
            perrork("rename(%s) file failed. Reason:%s.", filepath_md5, strerror(errno));
            return -1;
        }
        return 0;
    }
    return -1;
}
//连同此文件的md5文件一起删除
int delete_file_md5(char *filepath)
{
    if(access(filepath,0) == 0) {
        //file exist
        if (remove(filepath) != 0) {
            perrork("remove(%s) file failed. Reason:%s.", filepath, strerror(errno));
            return -1;
        }
    }
    return 0;
}



////得到下一期的期号  issue_number 151025
//uint32 fbs_next_issue(uint32 issue_number)
//{
//    int m[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
//    int year = issue_number / 10000 + 2000;
//    int month = (issue_number / 100) % 100;
//    int day = issue_number % 100;
//    if (((year%4==0) && (year%100!=0)) || (year%400==0))
//        m[1]++;
//    (month == 12 && day == 31) ? year++ : year;
//    month = (month + day / m[month - 1]) % 12;
//    day = day % m[month - 1] + 1;
//    return ((year-2000)*10000 + month*100 + day);
//}

//得到下一期的期号  issue_number 2016001(2017000????)  错误时返回0
uint32 fbs_next_issue(GIDB_FBS_IM_HANDLE *self, uint32 issue_number_max, uint32 issue_number)
{
    GIDB_FBS_ISSUE_INFO p_issue_info;
    p_issue_info.issueNumber = 0;
    issue_number++;
    for (; issue_number <= issue_number_max; issue_number++)
    {
        int ret = self->gidb_fbs_im_get_issue(self, issue_number, &p_issue_info);
        if (0 == ret) {
            log_info("gidb_fbs_im_get_issue  issue[%u]", p_issue_info.issueNumber);
            return issue_number;
        } else if (-1 == ret) {
            log_error("gidb_fbs_im_get_issue issue[%u]issue_max[%u]", issue_number, issue_number_max);
            return 0;
        }
    }

    return issue_number;
}




int win_ticket_sync = 0; //用于线程同步 中奖票入sqlite库完成
//处理中奖票入库的线程
void *fbs_draw_win_ticket_process_thread(void *arg)
{
    ts_notused(arg);
    log_info("gl_draw_win_ticket_process_thread start.");

    int ret = 0;
    GIDB_FBS_ST_REC *pSTicket = NULL;
    FBS_ORDER_REC *order_rec = NULL;

    GIDB_FBS_WT_HANDLE *fbs_wt_handle = NULL;
    GIDB_FBS_WT_REC *pWTicket = NULL;
    GIDB_FBS_WO_REC *pWOrder = NULL;
    int mlen = 0;

    int count = 0;

    uint32 issue_number = 0;
    uint32 match_code = 0;

    while (0 == exit_signal_fired)
    {
        FBS_WIN_MSG *msg = queue->dequeue(queue, 100);
        if (NULL == msg)
            continue;

#if 0

    ----bak2----
#endif


#if 1

        //k-debug
        log_debug("msg->type [%d]", msg->type);

        if (msg->type == 0) {
            //开始进行本场次的开奖处理
            //开始入库 open gidb fbs win handle
            fbs_wt_handle = gidb_fbs_wt_get_handle(GAME_FBS, msg->issue);
            if(fbs_wt_handle == NULL) {
                log_error("gidb_fbs_wt_get_handle(issueNumber[%u]) return null.", msg->issue);
                exit(-1);
            }
            ret = fbs_wt_handle->gidb_fbs_wt_clean(fbs_wt_handle,msg->match);
            if(ret != 0) {
                log_error("gidb_fbs_wt_clean(issue[%u] match[%u]) error.", msg->issue,msg->match);
                exit(-1);
            }
            issue_number = msg->issue;
            match_code = msg->match;

            count = 0;
            free(msg);
            continue;
        }

        if (msg->type == 1) {
            order_rec = (FBS_ORDER_REC*)msg->ptr;

            //k-debug
            if (order_rec == NULL) {
                log_error("order_rec is NULL");
            }
            //中奖订单入库
            fbs_wt_handle = gidb_fbs_wt_get_handle(GAME_FBS, msg->issue);
            if(fbs_wt_handle == NULL) {
                log_error("gidb_fbs_wt_get_handle(issueNumber[%u]) return null.", msg->issue);
                exit(-1);
            }

            //
            //
            //针对单关投注,比赛取消,做退票处理,考虑也不插入退票表，
            //也插入中奖订单表，进行统一处理 ?????
            //
            //

            mlen = sizeof(GIDB_FBS_WO_REC) + order_rec->match_count*sizeof(FBS_BETM);
            pWOrder = (GIDB_FBS_WO_REC*)malloc(mlen);
            FBS_GT_GAME_PARAM *game = &game_param;
            //convert   order_rec --->  pWOrder
            fbs_order_rec_2_wo_rec(order_rec, pWOrder, game);
            ret = fbs_wt_handle->gidb_fbs_wt_insert_order(fbs_wt_handle, pWOrder);
            if (ret != 0) {
                log_error("gidb_fbs_wt_insert_order() failure. unique_tsn[%llu] false.", pWOrder->unique_tsn);
                exit(-1);
            }
            count++;
            if (count>=10000) {
                //sync win order
                ret = gidb_fbs_wt_sync_draw_ticket();
                if (ret < 0) {
                    log_error("gidb_fbs_wt_sync_draw_ticket fail!!");
                    exit(-1);
                }
                count = 0;
            }
            free(msg);
            continue;
        }

        if (msg->type == 2) {

            //处理最后的win order入库
            ret = gidb_fbs_wt_sync_draw_ticket();
            if (ret < 0) {
                log_error("gidb_fbs_wt_sync_draw_ticket fail!!");
                exit(-1);
            }
            count = 0;


            pSTicket = (GIDB_FBS_ST_REC*)msg->ptr;
            //中奖彩票处理及入库
            fbs_wt_handle = gidb_fbs_wt_get_handle(GAME_FBS, msg->issue);
            if(fbs_wt_handle == NULL) {
                log_error("gidb_fbs_wt_get_handle(issueNumber[%u]) return null.", msg->issue);
                exit(-1);
            }

            // 对每张彩票，在order表里进行查询，获取总的中奖金额和注数
            int64 sum_winning_amount_tax = 0;
            int64 sum_winning_amount = 0;
            int64 sum_tax_amount = 0;
            int32 sum_winning_count = 0;
            ret = fbs_wt_handle->gidb_fbs_wt_get_ticket_sum(fbs_wt_handle,pSTicket->unique_tsn,
                    &sum_winning_amount_tax, &sum_winning_amount, &sum_tax_amount, &sum_winning_count);
            if (ret < 0) {
                log_error("gidb_fbs_wt_get_ticket_sum(issue[%u] unique_tsn[%lu]) found error.", msg->issue,pSTicket->unique_tsn);
                exit(-1);
            }
            if (ret == 0) {
                //此张彩票没有发现中奖的order
                free(msg);
                continue;
            }

            mlen = sizeof(GIDB_FBS_WT_REC);
            pWTicket = (GIDB_FBS_WT_REC*)malloc(mlen);
            memset(pWTicket,0,sizeof(GIDB_FBS_WT_REC));
            //convert   pSTicket --->  pWTicket
            fbs_sale_ticket_2_win_ticket_rec(pSTicket, pWTicket);

            pWTicket->winningAmountWithTax = sum_winning_amount_tax;
            pWTicket->winningAmount = sum_winning_amount;
            pWTicket->taxAmount = sum_tax_amount;
            pWTicket->winningCount = sum_winning_count;

            //单关、过关投注
            pWTicket->win_match_code = match_code;
            pWTicket->isBigWinning = 0;
            ret = fbs_wt_handle->gidb_fbs_wt_insert_ticket(fbs_wt_handle, pWTicket);
            if (ret != 0) {
                log_error("gidb_fbs_wt_insert_ticket() failure. unique_tsn[%llu] false.", pWTicket->unique_tsn);
                exit(-1);
            }
            count++;
            if (count>=10000) {
                //sync win ticket
                ret = gidb_fbs_wt_sync_draw_ticket();
                if (ret < 0) {
                    log_error("gidb_fbs_wt_sync_draw_ticket fail!!");
                    exit(-1);
                }
                count = 0;
            }
            free(msg);
            continue;
        }

        if (msg->type == 3) {
            //本场次的彩票已全部处理完成
            ret = gidb_fbs_wt_sync_draw_ticket();
            if (ret < 0) {
                log_error("gidb_fbs_wt_sync_draw_ticket fail!!");
                exit(-1);
            }
            count = 0;
            win_ticket_sync = 1;
            
            gidb_fbs_wt_clean_handle();
            free(msg);
            continue;
        }


#endif

    }
    log_info("gl_draw_win_ticket_process_thread exit.");
    return 0;
}


typedef map<uint64, GIDB_FBS_ST_REC*> ST_MAP;
ST_MAP st_map; //全局map 缓存所有未开奖的销售票信息，目的为了加速比赛派奖过程


//拆单处理  返回拆单文件的大小
//uint32 last_issue_number  上次开奖处理的期次   uint64 last_unique_tsn 上次开奖查询的最后一张票记录
//uint32 issue_number  现在的期次号
//char *filePath_ord  拆单文件路径
//uint64 file_offset 上次拆单文件的最后偏移
//uint64 *unique_tsn 返回处理的issue_number期次的
//若改为多线程，拆单函数需修改
int64 fbs_process_order(uint8 game_code,
		              uint32 last_issue_number,
		              uint64 last_unique_tsn,
		              uint32 issue_number,
		              char *filePath_ord,
		              uint64 file_offset,
		              uint64 *unique_tsn)
{
//k-debug:FBS
	log_info("order  1");
	int32 rc, j, m, n;

    //打开拆单数据文件
    FILE *fp = fopen(filePath_ord, "ab+");
    if (fp == NULL) {
    	log_error("fopen error. %s", filePath_ord);
    	return -1;
    }
    fseek(fp, file_offset, SEEK_SET);

    //循环处理从上次开奖过后到现在的期次
    GIDB_FBS_ST_HANDLE *fbs_st_handle = NULL;
    GIDB_FBS_IM_HANDLE *fbs_im_handle = NULL;
    uint32 issue = last_issue_number;

    // 调用游戏插件(calc betCount)
    GAME_PLUGIN_INTERFACE *game_plugins_handle = gl_plugins_handle();

    fbs_im_handle = gidb_fbs_im_get_handle(game_code);


    while (issue <= issue_number) {
        //k-debug
        log_debug("fbs_process_order  issue [%u][%u]", issue, issue_number);

        //得到售票数据的Handle
        fbs_st_handle = gidb_fbs_st_get_handle(game_code, issue);
        if (fbs_st_handle == NULL) {
            log_error("gidb_fbs_st_get_handle() failure! game[%d] issue_number[%u]", game_code, issue);
            return -1;
        }
        sqlite3_stmt* pStmt = NULL;
        const char *sql_str = "SELECT * FROM sale_ticket_table";
        if (sqlite3_prepare_v2(fbs_st_handle->db, sql_str, strlen(sql_str), &pStmt, NULL) != SQLITE_OK) {
            log_error("sqlite3_prepare_v2() error.");
            if (pStmt)
                sqlite3_finalize(pStmt);
            return -1;
        }
        //循环读取销售票数据
        static char buf_ticket[1024*16] = {0};
        GIDB_FBS_ST_REC *sticket_ptr = (GIDB_FBS_ST_REC *)buf_ticket;
        static char buf_ord[128*1024] = {0}; //拆单的临时内存
        FBS_ORDER_REC *ord_rec = (FBS_ORDER_REC*)buf_ord;

        FBS_BETM *betm = NULL;
        FBS_ORDER *order = NULL;
        char *orders_head = NULL;
        int sl;
        FBS_TICKET *ticket =NULL;

        char *ptr = NULL;
        int rl = offsetof(GIDB_FBS_ST_REC,ticket);
        while (1)
        {
            rc = sqlite3_step(pStmt);
            if ( rc == SQLITE_ROW )
            {
                memset(buf_ticket, 0, (1024 * 16));
                //从读到的售票记录构造 GIDB_SALE_TICKET_REC 结构
                if (get_fbs_st_rec_from_stmt(sticket_ptr, pStmt) < 0) {
                    log_error("get_fbs_st_rec_from_stmt() failure!");
                    if (pStmt)
                        sqlite3_finalize(pStmt);
                    return -1;
                }

                //k-debug
                log_debug("fbs_process_order. tsn[%lu]last tsn[%lu]", sticket_ptr->unique_tsn, last_unique_tsn);

                if (sticket_ptr->unique_tsn <= last_unique_tsn)
                    continue;

                //拆单,填充ticket->order
                ticket = &sticket_ptr->ticket;
                int ret = game_plugins_handle[ticket->game_code].fbs_split_order(ticket);
                if (ret == -1) {
                	return -1;
                }

                if (0 == st_map.count(sticket_ptr->unique_tsn)) {
                    ptr = (char *)malloc(rl);
                    memcpy(ptr, (char*)sticket_ptr, rl);
                    st_map[sticket_ptr->unique_tsn] = (GIDB_FBS_ST_REC*)ptr;
                }

                //开始拆单
                orders_head = ticket->data + ticket->match_count*sizeof(FBS_BETM);
                order = (FBS_ORDER*)orders_head;
                sl = 0;
                for (j=0;j<ticket->order_count;j++) {
                    order = (FBS_ORDER*)(orders_head+sl);
                    ord_rec->unique_tsn = sticket_ptr->unique_tsn;
                    ord_rec->ord_no = order->ord_no;
                    ord_rec->state = ORD_STATE_BET;
                    ord_rec->passed_match = 0;
                    ord_rec->passed_amount = order->bet_amount; //过关后的金额，也是进入下一关的投注金额 ( 初始值为 初始投注金额 )
                    ord_rec->game_code = ticket->game_code;
                    ord_rec->issue_number = ticket->issue_number;
                    ord_rec->sub_type = ticket->sub_type;
                    ord_rec->bet_type = order->bet_type;
                    ord_rec->bet_amount = order->bet_amount;
                    ord_rec->bet_count = order->bet_count;
                    ord_rec->bet_times = ticket->bet_times;
                    ord_rec->match_count = order->match_count;
                    for (m=0;m<ord_rec->match_count;m++) {
                        for (n=0;n<ticket->match_count;n++) {
                            betm = (FBS_BETM*)(ticket->data + n*sizeof(FBS_BETM));
                            if (betm->match_code == order->match_code_set[m]) {
                                memcpy((char*)ord_rec->match_array+m*sizeof(FBS_BETM),betm,sizeof(FBS_BETM));
                                break;
                            }
                        }
                    }
                    ord_rec->length = sizeof(FBS_ORDER_REC) + ord_rec->match_count*sizeof(FBS_BETM);
                    sl += order->length;

                    //将 ord_rec 写入拆单文件列表
                    if (1 != fwrite(buf_ord,ord_rec->length,1,fp)){
                        log_error("fwrite error. %s", filePath_ord);
                        return -1;
                    }

                    //k-debug:test
                    log_debug("ord_rec tsn[%llu]psdamount[%ld]", ord_rec->unique_tsn, ord_rec->passed_amount);
                }
                *unique_tsn = sticket_ptr->unique_tsn;
            } else if( rc == SQLITE_DONE) {
                //成功处理完毕
                break;
            } else {
                log_error("sqlite3_step error. game[%d] issue[%u]. ret[%d]", game_code, issue, rc);
                if (pStmt)
                    sqlite3_finalize(pStmt);
                return -1;
            }
        } //end while
        sqlite3_finalize(pStmt);
        gidb_fbs_st_close_handle(fbs_st_handle);

        issue = fbs_next_issue(fbs_im_handle, issue_number, issue);
        if (0 == issue) {
            log_error("fbs_next_issue error!");
            return -1;
        }
    }
    fflush(fp);
    uint64 file_offset_new = ftell(fp); //得到文件的大小
    fclose(fp);
    return file_offset_new;
}

//拆单计算
int fbs_order_calc(uint32 match_code, FBS_ORDER_REC *ord_rec, SUB_RESULT s_results[])
{
    int i=0;
    int attention_match = 0; //此拆单是否关注这场比赛
    uint8 pass = 0; //是否投中
    money_t r_amt = 0;
    FBS_BETM *betm = NULL;
    uint8 result_count = 0;
    if (ord_rec == NULL) {
        log_debug("fbs_order_calc ord_rec is NULL");
        return 0;
    }
    //k-debug:???
//    if (ord_rec->state==ORD_STATE_NO_WIN || ord_rec->state==ORD_STATE_WIN)
//        return 0;
    for (i=0;i<ord_rec->match_count;i++) {
        betm = (FBS_BETM*)((char*)ord_rec->match_array + i*sizeof(FBS_BETM));
        if (betm->match_code == match_code) {

            result_count = betm->result_count;//取消计算中奖注数用
            attention_match = 1;
            break;
        }
    }

    //k-debug test
    log_info("attention_match: match_code[%u]tsn[%llu]no[%d]subtype[%d]state[%d]passamount[%lld]attention[%d]",
                    match_code,ord_rec->unique_tsn,ord_rec->ord_no,ord_rec->sub_type,
                    ord_rec->state,ord_rec->passed_amount, attention_match);
    if (attention_match==0) {
        //一定要修改，防止前值为ORD_STATE_PASSED，多*SP
        //或者用attention标志
        //ord_rec->state = ORD_STATE_BET;
        return 0;
    }

    //k-debug
    log_debug("returnRate [%d]", game_param.returnRate);

    //累加计算此场比赛的 玩法总投注额
    s_results[ord_rec->sub_type].amount += ord_rec->passed_amount; //此单截止目前的过关金额(已乘过已过关场次的SP),也是此场比赛的投注金额
    //k-debug test
    log_info("s_results amount:match[%u]ord_no[%d]s_amount[%lld], ord[%lld], sub_type[%d]",
            match_code, ord_rec->ord_no, s_results[ord_rec->sub_type].amount, ord_rec->passed_amount, ord_rec->sub_type);
    if (ord_rec->bet_type == BET_1C1) {
        //单关投注
        s_results[ord_rec->sub_type].single_amount += ord_rec->passed_amount;

        //比赛取消
        if (s_results[ord_rec->sub_type].result == FBS_DRAW_All) {
            //对于单关投注，发生比赛取消的情况，做退票处理，不计算销售金额
            s_results[ord_rec->sub_type].amount -= ord_rec->passed_amount; 
        }
    } else {
        //过关投注
        s_results[ord_rec->sub_type].multiple_amount += ord_rec->passed_amount;
    }

    //累加计算此场比赛的 某个玩法 的 各个赛果的总投注额
    pass = 0;
    if (s_results[ord_rec->sub_type].result == FBS_DRAW_All) {
        //比赛取消
        if (ord_rec->bet_type == BET_1C1) {
            //单关投注
            //投中赛果的金额，比赛取消算全部投中
            s_results[ord_rec->sub_type].result_amount += 0; //这里要作为退票处理
            s_results[ord_rec->sub_type].single_result_amount += ord_rec->passed_amount;
        } else {
            //过关投注
            //投中赛果的金额，比赛取消算全部投中
            s_results[ord_rec->sub_type].result_amount += ord_rec->passed_amount;
            s_results[ord_rec->sub_type].multiple_result_amount += ord_rec->passed_amount;
        }
        pass = 1;
    } else {
        r_amt = rounddown(ord_rec->passed_amount*1.0/betm->result_count); //平均每个赛果的投注金额
        for (i=0;i<betm->result_count;i++) {
            //k-debug
            log_debug("fbs_order_calc:i[%d]betmResults[%d]result[%d]subtype[%d]amt[%ld]",
                    i, betm->results[i],
                    s_results[ord_rec->sub_type].result,
                    ord_rec->sub_type,
                    r_amt);
            //判断是否有投中赛果
            if (betm->results[i] == s_results[ord_rec->sub_type].result) {
                //过关成功
                s_results[ord_rec->sub_type].result_amount += r_amt; //投中彩果的金额
                if (ord_rec->bet_type == BET_1C1) //单关投注
                    s_results[ord_rec->sub_type].single_result_amount += r_amt;
                else //过关投注
                    s_results[ord_rec->sub_type].multiple_result_amount += r_amt;
                pass = 1;
                break;
            }
        }
    }
    if (pass == 0) {
        //过关失败
        ord_rec->state = ORD_STATE_NO_WIN;
    } else {
        //过关成功
        ord_rec->passed_match++; //此单的过关数加1
        if (ord_rec->passed_match == ord_rec->match_count){
            //最后一场比赛

            //对于单关投注，发生比赛取消的情况，做退票处理，不计算销售金额
            if (ord_rec->bet_type==BET_1C1 && s_results[ord_rec->sub_type].result==FBS_DRAW_All) {
                ord_rec->state = ORD_STATE_RETURN;
                ord_rec->win_bet_count = 0;
            } else {
                ord_rec->state = ORD_STATE_WIN;
                if (0 == ord_rec->win_bet_count) {
                    ord_rec->win_bet_count = ord_rec->bet_times; //计算中奖注数
                } else {
                    ord_rec->win_bet_count *= ord_rec->bet_times; //计算中奖注数, 有取消场次
                }
            }
            ord_rec->win_match_code = match_code; //此订单在这场比赛的开奖过程中中奖
        } else if (s_results[ord_rec->sub_type].result==FBS_DRAW_All){
            //还需要继续过关
            ord_rec->state = ORD_STATE_PASSED;

            if (0 == ord_rec->win_bet_count) {
                ord_rec->win_bet_count = result_count; //计算中奖注数
            } else {
                ord_rec->win_bet_count *= result_count; //计算中奖注数, 有取消场次
            }
        } else {
            //还需要继续过关
            ord_rec->state = ORD_STATE_PASSED;
        }
    }

    //k-debug:FBS
    log_debug("SUB_RESULT:code[%d]amount[%lu]single_amount[%lu]multiple_amount[%lu]result[%d] \
            result_amount[%lu]single_result_amount[%lu]multiple_result_amount[%lu]",
            s_results[ord_rec->sub_type].code,s_results[ord_rec->sub_type].amount,s_results[ord_rec->sub_type].single_amount,
            s_results[ord_rec->sub_type].multiple_amount,s_results[ord_rec->sub_type].result,
            s_results[ord_rec->sub_type].result_amount,s_results[ord_rec->sub_type].single_result_amount,
            s_results[ord_rec->sub_type].multiple_result_amount);

    return 0;
}

/* 保留用于mmap的内存对齐
uint64 mem_align(uint64 current){
    uint64 offset = current%4096;
    return (0 == offset) ? current : (current - offset);
}
*/

/***
 *
 * 有关开奖过程中重要文件之间的关系：
 * game目录下会有.order、.meta、.order_bak、.meta_bak、.tag、.sale文件、win文件、md5文件(order、meta、bak)(order.new、meta.new文件只会在开奖过程中出现)
 * XXX场比赛开奖时，从sqlite里读销售数据，追加到order文件里，算奖时，根据.order文件生成order.new文件(order.new文件是在order里去掉了本场比赛相关的拆单)
 * 若没有进行重新开奖，则收到确认消息会，把order.bak meta.bak移动到draw文件夹下并重命名加上场次编号，把变化过的order移动到draw文件夹下面，
 * 删掉 .meta文件，把.order.new  .meta.new重命为.order .meta
 * 再对.order .meta复制成.order.bak .meta.bak
 * 若重新开奖，删掉.order .meta  .order.new .meta.new文件，从order.bak meta.bak复制一份.order .meta文件
***/



//开奖 处理 -------------------------------------------------------
//uint8 results[]  各个玩法的赛果
int fbs_draw_match(uint8 game_code, uint32 issue_number, uint32 match_code, uint8 results[], uint8 match_result[])
{
    uint32 step = 0;
    log_info("--- FBS Match Draw begin ---   issue[%u] match[%u] ---", issue_number,match_code); step++;

    int ret = 0;
    int i;

    //得到拆单文件路径
    char game_abbr[16];
    get_game_abbr(game_code, game_abbr);
    char filePath_ord[256];
    char filePath_meta[256];
    ts_get_fbs_ticket_order_filepath(game_abbr, filePath_ord, 256);
    ts_get_fbs_ticket_meta_filepath(game_abbr, filePath_meta, 256);
    char filePath_ord_bak[256];
    char filePath_meta_bak[256];
    sprintf(filePath_ord_bak, "%s.bak", filePath_ord);
    sprintf(filePath_meta_bak, "%s.bak", filePath_meta);
    char filePath_ord_new[256];
    char filePath_meta_new[256];
    sprintf(filePath_ord_new, "%s.new", filePath_ord);
    sprintf(filePath_meta_new, "%s.new", filePath_meta);
    char filePath_tag[256];
    ts_get_fbs_draw_tag_filepath(game_abbr, filePath_tag, 256);

    //get game parameter
    ret = get_game_param(game_code, issue_number, (char*)&game_param);
    if (ret != 0) {
        log_error("get_game_param(%d, %u, FBS_ST_GAME_PARAMBLOB_KEY) failure!", game_code, issue_number);
        return -1;
    }

    META_ST meta_data;
    uint32 tag_match_code = 0;
    uint32 tag_draw_state = 0;
    //check是否有未完成的开奖
    int64 mark_content = fbs_draw_tag(filePath_tag, match_code, 0, 0);
    if (mark_content < 0) {
        log_error("fbs_draw_tag( %u, checkTagFile) error", match_code);
        return -1;
    }
    if (mark_content == 1) {
        //存在标记文件,有开奖未完成
        //读取标记文件
        mark_content = fbs_draw_tag(filePath_tag, match_code, 0, 2);
        if (mark_content < 0) {
            log_error("fbs_draw_tag( %u, readTagFile) error", match_code);
            return -1;
        }
        tag_draw_state = mark_content >> 32;
        tag_match_code = mark_content & 0x00000000FFFFFFFF;
        //k-debug:test
        log_debug("mark_content[%d][%s]", mark_content, filePath_tag);
        //if (true) {
        if (tag_match_code == match_code) {
            //此场次重新开奖
            log_warn("--- Match %u  redo draw ---", match_code);

            //删除现有的拆单文件 和 meta文件
            ret = delete_file_md5(filePath_ord);
            if (ret < 0) {
                log_error("delete_file_md5( %s ) error.", filePath_ord);
                return -1;
            }
            ret = delete_file_md5(filePath_meta);
            if (ret < 0) {
                log_error("delete_file_md5( %s ) error.", filePath_meta);
                return -1;
            }
            //删除新的拆单文件 和 新的meta文件
            ret = delete_file_md5(filePath_ord_new);
            if (ret < 0) {
                log_error("delete_file_md5( %s ) error.", filePath_ord_new);
                return -1;
            }
            ret = delete_file_md5(filePath_meta_new);
            if (ret < 0) {
                log_error("delete_file_md5( %s ) error.", filePath_meta_new);
                return -1;
            }
            //copy备份的拆单文件 和 meta文件 为用于开奖的 拆单文件 和 meta 文件
            ret = copy_file_md5(filePath_ord_bak, filePath_ord);
            if (ret < 0) {
                log_error("copy_file_md5( %s, %s ) error.", filePath_ord_bak, filePath_ord);
                return -1;
            }
            ret = copy_file_md5(filePath_meta_bak, filePath_meta);
            if (ret < 0) {
                log_error("copy_file_md5( %s, %s ) error.", filePath_meta_bak, filePath_meta);
                return -1;
            }
            //删除标记文件
            mark_content = fbs_draw_tag(filePath_tag, match_code, 0, 3);
            if (mark_content < 0) {
                log_error("fbs_draw_tag( %u, deleteTagFile) error", match_code);
                return -1;
            }
        } else {
            //有别的比赛正在开奖中，此场比赛不允许开奖，忽略这条OMS开奖记录
            log_error("HAS OTHER MATCH IS DRAWING.  --- IGNORE ---  [ %u ] tag[ %u ]", match_code, tag_match_code);
            return 1;  //开奖的比赛不匹配，忽略此条记录
        }
    }

    //建立标记文件 (标识比赛开始算奖)
    mark_content = fbs_draw_tag(filePath_tag, match_code, 1, 1);
    if (mark_content < 0) {
        log_error("fbs_draw_tag( %u, state[1] newTagFile) error", match_code);
        return -1;
    }

    //校验读取meta文件
    ret = fbs_read_draw_meta_file(filePath_meta, &meta_data);
    if (ret < 0) {
        log_error("fbs_read_draw_meta_file() error. %s", filePath_meta);
    	return -1;
    }
    //校验拆单的order文件
    ret = fbs_verify_draw_order_file(filePath_ord);
    if (ret < 0) {
        log_error("fbs_verify_draw_order_file() error. %s", filePath_ord);
    	return -1;
    }

    // 开始拆单 ---------------------------------------------------------------------------------------
    log_info("--- FBS Match Draw.  issue[%u] match[%u] STEP[%u] ---", issue_number,match_code, step); step++;
    uint32 issue = issue_number;
    //k-debug: 初始化期号2016001,防止生成issue_0....过多
    if (meta_data.last_issue_number <= 2016001)
        issue = issue_number;
    else
        issue = meta_data.last_issue_number;
    uint64 last_unique_tsn = meta_data.last_unique_tsn;//防止本场比赛未拆单时，last_unique_tsn为0
    int64 file_offset = fbs_process_order(game_code,
                                          issue,
                                          meta_data.last_unique_tsn,
                                          issue_number,
                                          filePath_ord,
                                          meta_data.last_file_offset,
                                          &last_unique_tsn);
    if (file_offset < 0) {
        log_error("fbs_process_order(%u,%u,%llu,%u,%s,%llu) error.",
                game_code,issue_number,meta_data.last_unique_tsn,issue_number,filePath_ord,meta_data.last_file_offset);
    	return -1;
    }

    //k-debug:
    log_debug("offset[%ld]last[%ld]", file_offset, meta_data.last_file_offset);

    meta_data.last_file_offset = file_offset;
    meta_data.last_draw_sequence++;

    if (meta_data.last_issue_number < issue_number) {//防止先第N期再开第<N期
        meta_data.last_issue_number = issue_number;
    }
    meta_data.last_unique_tsn = last_unique_tsn;

    //扫描整个拆单文件,进行开奖SP的计算 ------------------------------------------------------------------
    log_info("--- FBS Match Draw.  issue[%u] match[%u] STEP[%u] ---", issue_number,match_code, step); step++;


    // ---------------------------------------------------
    //
    // 严重注意，这里使用的mmap没有计算当前系统的内存剩余量，默认系统内存充足，采用空间换时间的方式，提高效率
    // 如果出现内存不足，目前没有进行处理;如果采用分块mmap的方式，之后的流程还需要对文件进行全局扫描派奖，需要仔细考虑流程
    //
    // ---------------------------------------------------
    int64 warn_len = (1*1024*1024*1024);
    if (file_offset > warn_len) {
        //打一个内存使用的告警
        log_warn("---***---   mmap need memory [ %llu ] bytes   ---***---", file_offset);
    }

    //使用mmap映射内存进行处理
    int fd_ord = open(filePath_ord, O_RDWR, S_IRWXU);
    if (fd_ord<0) {
        log_error("open error. %s", filePath_ord);
    	return -1;
    }

    void* mmap_ptr = NULL;
    int flagMmap = 0;
    if (file_offset > 0) {
        flagMmap = 1;
    }
    if (flagMmap == 1) {
        mmap_ptr = mmap(NULL, file_offset, PROT_READ|PROT_WRITE, MAP_PRIVATE, fd_ord, 0);
        if ((void *)-1 == mmap_ptr) {
            log_error("mmap error. %s, errno[%d],offset[%lld],fd_ord[%d]",
                    filePath_ord, errno, file_offset, fd_ord);
            return -1;
        }
    }


    SUB_RESULT s_results[FBS_SUBTYPE_NUM];
    memset((char*)s_results,0,sizeof(SUB_RESULT)*FBS_SUBTYPE_NUM);
    for (i=FBS_SUBTYPE_WIN;i<=FBS_SUBTYPE_OUOD;i++) {
        s_results[i].code = i;
        s_results[i].result = results[i];
    }
    // 扫描整个拆单文件，计算开奖SP
    int64 pos = 0;
    FBS_ORDER_REC *ord_rec = NULL;
    while (pos < file_offset) {
        ord_rec = (FBS_ORDER_REC*)((char*)mmap_ptr+pos);
        //k-debug:
        log_debug("ord_rec before. uniquetsn[%lu]no[%d]state[%d]subtype[%d]bettype[%d]pos[%ld]offset[%ld]passamount[%ld]",
                ord_rec->unique_tsn, ord_rec->ord_no, ord_rec->state, ord_rec->sub_type, ord_rec->bet_type,
                pos, file_offset, ord_rec->passed_amount);
        //拆单处理计算
        fbs_order_calc(match_code, ord_rec, s_results);
        if (ord_rec->length == 0) {
            log_error("order length = 0");
            return -1;
        }
        pos += ord_rec->length;
    }

    //计算本场比赛各个玩法的最终赛果的SP值
    for (i=FBS_SUBTYPE_WIN;i<=FBS_SUBTYPE_OUOD;i++) {
        if (s_results[i].result == FBS_DRAW_All)
            s_results[i].final_sp = 1000;
        else {
            if (s_results[i].result_amount == 0) {
                s_results[i].final_sp = 0;
            } else {
                s_results[i].final_sp = rounddown(s_results[i].amount*1000.0/s_results[i].result_amount);
            }
        }
    }
    log_info("\n--- FBS Match Draw.  issue[%u] match[%u] STEP[%u] ---", issue_number,match_code, step); step++;

    //k-debug:FBS
    for (int i = FBS_SUBTYPE_WIN; i < FBS_SUBTYPE_NUM; i++)
    {
        log_info("\n    subtype[ %d ]   amount[ %16lld ]  result[ %u ][ %s ][ %16lld ]   final_sp[ %.3f ]",
                i,
            s_results[i].amount,
            s_results[i].result,
            game_handle[game_code].fbs_get_result_string(i,s_results[i].result),
            s_results[i].result_amount,
            s_results[i].final_sp/1000.0);
    }


    // 开始派奖，扫描整个拆单文件，更新拆单文件的 过关金额 -----------------------------------------------
    // 如果是最后一关，则将此单放入中奖文件
    // 如果不是最后一关，还要等待其他比赛开奖，则写入新的拆单文件

    //打开新的拆单数据文件，如果有旧的文件会截断为0
    FILE *fd_ord_new = fopen(filePath_ord_new, "wb");
    if (fd_ord_new == NULL) {
    	log_error("fopen error. %s", filePath_ord_new);
    	return -1;
    }

#if 0
----bak1----

#endif




#if 1  //caoxf__

    list<uint64> continue_order_list;
    list<GIDB_FBS_ST_REC*> plus_speed_list;
    FBS_WIN_MSG *item = NULL;
    int rl = offsetof(GIDB_FBS_ST_REC,ticket);
    GIDB_FBS_ST_HANDLE *fbs_st_handle = NULL;
    static char st_buffer[16*1024]; char *ptr = NULL;
    GIDB_FBS_ST_REC *pSTicket = NULL;

    //场次开奖第一条消息
    item = (FBS_WIN_MSG*)malloc(sizeof(FBS_WIN_MSG));
    item->type = 0;
    item->issue = issue_number;
    item->match = match_code;
    item->ptr = NULL;
    //send queue
    queue->enqueue(queue, item);

    pos = 0;

    while (pos < file_offset) {
        ord_rec = (FBS_ORDER_REC*)((char*)mmap_ptr+pos);

        //首先查询 st_map中是否存在此订单的ord_rec->unique_tsn,
        //如果不存在，则查询后加入
        if (0 == st_map.count(ord_rec->unique_tsn)) {
            fbs_st_handle = gidb_fbs_st_get_handle(game_code, ord_rec->issue_number);
            if (fbs_st_handle == NULL) {
                log_error("gidb_fbs_st_get_handle() failure! game[%d] issue_number[%u]", game_code, ord_rec->issue_number);
                return -1;
            }
            ret = fbs_st_handle->gidb_fbs_st_get_ticket(fbs_st_handle, ord_rec->unique_tsn, (GIDB_FBS_ST_REC*)st_buffer);
            if (ret < 0) {
                log_error("gidb_fbs_st_get_ticket() error. issue[%u] unique_tsn[%llu]", ord_rec->issue_number, ord_rec->unique_tsn);
                return -1;
            } else if (ret == 1) {
                log_error("ticket not found. issue[%u] unique_tsn[%llu]", ord_rec->issue_number, ord_rec->unique_tsn);
                return -1; //应该不会发生这个问题
            }
            //加载一张票到st_map, 判断，防止同一个TSN多个order
            //GIDB_FBS_ST_REC *tmpFBSSTRec =
            if ( st_map.find(((GIDB_FBS_ST_REC*)st_buffer)->unique_tsn) == st_map.end() ) {
                ptr = (char*)malloc(rl);
                memcpy(ptr, st_buffer, rl);
                st_map[ord_rec->unique_tsn] = (GIDB_FBS_ST_REC*)ptr;

                //k-debug:test
                pSTicket = (GIDB_FBS_ST_REC*)ptr;
                log_debug("load ticket[%ld][%d]", pSTicket->unique_tsn, pSTicket->sub_type);
            }
        }

        //k-debug:
        log_debug("ord_rec after. uniquetsn[%lu]no[%d]state[%d]subtype[%d]pos[%ld]offset[%ld]passamount[%ld]",
                ord_rec->unique_tsn, ord_rec->ord_no, ord_rec->state, ord_rec->sub_type, pos, file_offset, ord_rec->passed_amount);

        if (ord_rec->state==ORD_STATE_BET) {
            //此单等待继续开奖, 写入新的拆单文件
            if (1 != fwrite((char*)ord_rec,ord_rec->length,1,fd_ord_new)) {
                log_error("fwrite error. %s", filePath_ord_new);
                return -1;
            }
            //需要继续进行后续开奖的彩票票号
            continue_order_list.push_back(ord_rec->unique_tsn);
            pos += ord_rec->length;
            continue;
        }

        if (ord_rec->state==ORD_STATE_PASSED) {
            //此单等待继续开奖, 写入新的拆单文件
            //此单过关，更新中奖金额

            //order是否关注本场比赛
            FBS_BETM *betm = NULL;
            int attention_match = 0; //此拆单是否关注这场比赛
            for (int i=0;i<ord_rec->match_count;i++) {
                betm = (FBS_BETM*)((char*)ord_rec->match_array + i*sizeof(FBS_BETM));
                //k-debug test
                log_info("attention code i[%d]cnt[%d]code[%u]", i, ord_rec->match_count, betm->match_code);
                if (betm->match_code == match_code) {
                    attention_match = 1;
                    break;
                }
            }

            //k-debug test
            log_info("attention_match: match_code[%u]tsn[%llu]no[%d]subtype[%d]state[%d]passamount[%lld]attention[%d]",
                            match_code,ord_rec->unique_tsn,ord_rec->ord_no,ord_rec->sub_type,
                            ord_rec->state,ord_rec->passed_amount, attention_match);
            if (attention_match==1) {
                if (FBS_DRAW_All != s_results[ord_rec->sub_type].result) {
                    //计算一个赛果投注额
                    //k-debug:passed_amount 四舍五入问题(舍掉)
                    for (int z = 0; z < ord_rec->match_count; z++)
                    {
                        if (ord_rec->match_array[z].match_code == match_code) {
                            ord_rec->passed_amount = rounddown(ord_rec->passed_amount * 1.0 / ord_rec->match_array[z].result_count);
                            break;
                        }
                    }
                }
                ord_rec->passed_amount = ord_rec->passed_amount * s_results[ord_rec->sub_type].final_sp / 1000.0;
            }

            if (1 != fwrite((char*)ord_rec,ord_rec->length,1,fd_ord_new)) {
                log_error("fwrite error. %s", filePath_ord_new);
                return -1;
            }
            //需要继续进行后续开奖的彩票票号
            continue_order_list.push_back(ord_rec->unique_tsn);
            pos += ord_rec->length;

            //k-debug test
            log_info("ord_rec passed_amount: match[%u]issue[%u]ord_no[%d]passed[%lld]sub_type[%d]single_win[%lld]mul_win[%lld]",
                    ord_rec->win_match_code, ord_rec->issue_number, ord_rec->ord_no, ord_rec->passed_amount, ord_rec->sub_type,
                    s_results[ord_rec->sub_type].single_win_amount, s_results[ord_rec->sub_type].multiple_win_amount);

            continue;
        }

        if (ord_rec->state == ORD_STATE_NO_WIN) {
            //没有中奖
            pos += ord_rec->length;
            continue;
        }
        if (ord_rec->state == ORD_STATE_RETURN) {
            //单关比赛取消,做退票处理
            ord_rec->passed_amount = ord_rec->passed_amount;
        } else { //ORD_STATE_WIN
            //此单中奖，更新中奖金额

            if (FBS_DRAW_All != s_results[ord_rec->sub_type].result) {
                //计算一个赛果投注额
                for (int z = 0; z < ord_rec->match_count; z++)
                {
                    if (ord_rec->match_array[z].match_code == match_code) {
                        ord_rec->passed_amount = rounddown(ord_rec->passed_amount * 1.0 / ord_rec->match_array[z].result_count);
                        break;
                    }
                }
            }

            ord_rec->passed_amount = ord_rec->passed_amount * s_results[ord_rec->sub_type].final_sp / 1000.0;

            //涉及舍掉问题不能后面处理(X返奖率)
            ord_rec->passed_amount = ord_rec->passed_amount * game_param.returnRate / 1000.0;

            if (ord_rec->bet_type == BET_1C1) {
                s_results[ord_rec->sub_type].single_win_amount += ord_rec->passed_amount;
            } else {
                s_results[ord_rec->sub_type].multiple_win_amount += ord_rec->passed_amount;
            }
            //只能相加得来，涉及到舍去问题
            s_results[ord_rec->sub_type].win_amount = s_results[ord_rec->sub_type].single_win_amount +
                                                      s_results[ord_rec->sub_type].multiple_win_amount;

            //k-debug test
            log_info("ord_rec passed_amount win: match[%u]issue[%u]ord_no[%d]passed[%lld]sub_type[%d]single_win[%lld]mul_win[%lld]",
                    ord_rec->win_match_code, ord_rec->issue_number, ord_rec->ord_no, ord_rec->passed_amount, ord_rec->sub_type,
                    s_results[ord_rec->sub_type].single_win_amount, s_results[ord_rec->sub_type].multiple_win_amount);
        }

        //将中奖的order发送到queue进行入库
        item = (FBS_WIN_MSG*)malloc(sizeof(FBS_WIN_MSG));
        item->type = 1;
        item->issue = ord_rec->issue_number;
        item->match = match_code;
        item->ptr = (char*)ord_rec;
        //send queue
        queue->enqueue(queue, item);

        pos += ord_rec->length;

        //k-debug
        log_debug("win order [%lu][%d]", ord_rec->unique_tsn, ord_rec->ord_no);
    }

    //st_map中存放的是本次开奖涉及的全部订单
    //continue_order_list中存放的是需要继续开奖的订单
    //从st_map中先移走还需要继续开奖的票，移走的票先保存在plus_speed_list中，
    //本次开奖完成再移回st_map,用于下一场次的开奖
    uint64 u_tsn;
    while (!continue_order_list.empty()) {
        u_tsn = continue_order_list.front();
        //k-debug
        log_debug("continue_order_list [%lu]", u_tsn);

        //防止多个order同一个TSN
        if (st_map.find(u_tsn) != st_map.end()) {
            pSTicket = st_map[u_tsn]; st_map.erase(u_tsn);
            plus_speed_list.push_back(pSTicket); //将需要继续开奖的票信息保存在list中
        }
        continue_order_list.pop_front();
    }

    //此时st_map中都是有可能中奖的彩票
    ST_MAP::iterator iter;
    pSTicket = NULL;
    for(iter=st_map.begin();iter!=st_map.end();) {
        pSTicket = iter->second;
        //k-debug
        log_debug("st_map unitsn[%lu] cnt[%ld]", pSTicket->unique_tsn, st_map.size());

        item = (FBS_WIN_MSG*)malloc(sizeof(FBS_WIN_MSG));
        item->type = 2;
        item->issue = pSTicket->issue_number;
        item->match = match_code;
        item->ptr = (char*)pSTicket;
        //send queue
        queue->enqueue(queue, item);

        iter++;
    }

    //最后一条确认消息
    item = (FBS_WIN_MSG*)malloc(sizeof(FBS_WIN_MSG));
    item->type = 3;
    item->issue = 0;//unused
    item->match = match_code;
    item->ptr = NULL;
    //send queue
    queue->enqueue(queue, item);

    //等待sqlite中奖票入库完成
    while (1) {
        if (win_ticket_sync == 1)
            break;
        ts_sleep(1,1);        
    }
    win_ticket_sync = 0;

    //清除当前的st_map
    for(iter=st_map.begin();iter!=st_map.end();) {
        pSTicket = iter->second;
        //k-debug:
        log_debug("erase st map tsn[%lu]", pSTicket->unique_tsn);
        free(pSTicket);
        st_map.erase(iter++);
    }
    //将需要继续开奖的票，继续保存在st_map中，用于下一次开奖
    while (!plus_speed_list.empty()) {
        pSTicket = plus_speed_list.front();
        //k-debug:
        log_debug("plus_speed_list  tsn[%lu]", pSTicket->unique_tsn);
        st_map[pSTicket->unique_tsn] = pSTicket;
        plus_speed_list.pop_front();
    }

    log_info("--- FBS Match Draw.  issue[%u] match[%u] STEP[%u] ---", issue_number,match_code, step); step++;

#endif

    //保存拆单使用的开奖文件 (注意:这里没有保存更新原来的meta文件)-----------------
    if (flagMmap == 1) {
        ret = msync(mmap_ptr, file_offset, MS_SYNC);
        if (ret != 0) {
            log_error("msync error. %s", filePath_ord);
            return -1;
        }
        munmap(mmap_ptr, file_offset);

        //k-debug
        log_debug("munmap[%ld]", file_offset);
    }
    close(fd_ord);

    //保存新生成的拆单文件 --------------------------------------------------------
    fflush(fd_ord_new);
    file_offset = ftell(fd_ord_new); //得到文件的大小
    fclose(fd_ord_new);
    //计算新生成的拆单文件的md5,并生成MD5文件
    char md5_a[32];
    if (0 > md5_file(filePath_ord_new, md5_a)) {
        log_error("md5_file() error. %s", filePath_ord_new);
        return -1;
    }
    //保存新生成的meta文件 及 meta的md5文件 ------------------------
    meta_data.last_file_offset = file_offset;
    meta_data.last_match_code = match_code;
    meta_data.last_draw_time = get_now();
    memcpy((char*)meta_data.s_results, (char*)s_results, sizeof(SUB_RESULT)*FBS_SUBTYPE_NUM);
    memcpy((char*)meta_data.match_result, (char*)match_result, 8);
    ret = fbs_write_draw_meta_file(filePath_meta_new, &meta_data);
    if (ret < 0) {
        log_error("fbs_write_draw_meta_file() error. %s", filePath_meta_new);
    	return -1;
    }

    log_info("--- FBS Match Draw.  issue[%u] match[%u] STEP[%u] ---", issue_number,match_code, step); step++;

    //更新数据库的  算奖结果 (已X返奖率)
    if ( !otl_fbs_set_match_draw_result(game_code, match_code, s_results) ) {
        log_error("otl_fbs_set_match_draw_result(match_code[%u]  M_STATE_DRAW) failed.", match_code);
        return -1;
    }

    //更新标记文件状态 (算奖完成，等待确认)
    mark_content = fbs_draw_tag(filePath_tag, match_code, 2, 1);
    if (mark_content < 0) {
        log_error("fbs_draw_tag( %u, state[2], updateTagFile) error", match_code);
        return -1;
    }

    char winFile[200] = { 0 };
    ts_get_fbs_game_match_win_data_filepath(game_abbr, match_code, 1, winFile, sizeof(winFile));

    ret = gidb_fbs_generate_match_win_file(game_code, issue_number, match_code, 1, winFile);
    if (ret != 0) {
        log_error("gidb_fbs_generate_issue_win_file() failed, game_code[%d], issue[%lld], file[%s]",
            game_code, issue_number, winFile);
        return -1;
    }

    //更新数据库比赛状态
    if ( !otl_fbs_set_match_state(game_code, match_code, M_STATE_DRAW) ) {
        log_error("otl_fbs_set_match_state(match_code[%u]  M_STATE_CONFIRM) failed.", match_code);
        return -1;
    }

    // 输出开奖信息
    log_info("\n--- FBS Match Draw Complete. ---   issue[%u] match[%u] ---\n", issue_number,match_code); step++;
    return 0;
}

//确认开奖结果
int fbs_draw_confirm(uint8 game_code, uint32 issue_number, uint32 match_code)
{
    int ret = 0;

    //检测是否不合理消息(如重复confirm消息)
    GIDB_FBS_MATCH_INFO match_info;
    memset(&match_info, 0, sizeof(GIDB_FBS_MATCH_INFO));
    bool tmpF = otl_fbs_get_match_info(game_code, match_code, &match_info);
    if (!tmpF) {
        log_warn("otl_fbs_get_match_info fail!!!issue[%u]match_code[%u]",
                issue_number, match_code);
        return 0;
    }
    if (match_info.state == M_STATE_CONFIRM) {
        log_warn("fbs_draw_confirm warning!!!");
        return 0;
    }


    char game_abbr[16];
    get_game_abbr(game_code, game_abbr);
    char filePath_ord[256];
    char filePath_meta[256];
    ts_get_fbs_ticket_order_filepath(game_abbr, filePath_ord, 256);
    ts_get_fbs_ticket_meta_filepath(game_abbr, filePath_meta, 256);
    char filePath_ord_bak[256];
    char filePath_meta_bak[256];
    sprintf(filePath_ord_bak, "%s.bak", filePath_ord);
    sprintf(filePath_meta_bak, "%s.bak", filePath_meta);
    char filePath_ord_new[256];
    char filePath_meta_new[256];
    sprintf(filePath_ord_new, "%s.new", filePath_ord);
    sprintf(filePath_meta_new, "%s.new", filePath_meta);
    char filePath_tag[256];
    ts_get_fbs_draw_tag_filepath(game_abbr, filePath_tag, 256);
    char dirPath_draw[256];
    ts_get_fbs_draw_dirpath(game_abbr, dirPath_draw, 256);

    //检查标记文件 check是否有未完成的开奖
    int64 mark_content = fbs_draw_tag(filePath_tag, match_code, 0, 2);
    if (mark_content < 0) {
        log_error("fbs_draw_tag( %u, readTagFile) error", match_code);
        return -1;
    }
    uint32 draw_state = mark_content >> 32;
    uint32 last_match_code = mark_content & 0x00000000FFFFFFFF;
    if ((last_match_code!=match_code) || (draw_state!=2)) {
        log_error("fbs_draw_confirm(%u,%d) error. match or state NOT MATCHED.", last_match_code, draw_state);
        return 1; //开奖的比赛不匹配，忽略此条记录
    }

    //先调用 ，再清理本地数据
    char winFile[200] = { 0 };
    ts_get_fbs_game_match_win_data_filepath(game_abbr, match_code, 1, winFile, sizeof(winFile));

    //调用中奖文件通知的sp
    if (!otl_send_issue_winfile(game_code, match_code, winFile))
    {
        log_error("otl_send_issue_winfile() failed, game_code[%d], issue[%u], file[%s]",
            game_code, issue_number, winFile);
        return -1;
    }

    //重命名 并 移动 上次的备份文件 拆单文件 和 meta文件
    char pathName[256];
    sprintf(pathName, "%s/%u_draw_order.bak", dirPath_draw, match_code);
    ret = move_file_md5(filePath_ord_bak, pathName);
    if (ret < 0) {
        log_error("move_file_md5( %s, %s ) error.", filePath_ord_bak, pathName);
        return -1;
    }
    sprintf(pathName, "%s/%u_draw_meta.bak", dirPath_draw, match_code);
    ret = move_file_md5(filePath_meta_bak, pathName);
    if (ret < 0) {
        log_error("move_file_md5( %s, %s ) error.", filePath_meta_bak, pathName);
        return -1;
    }
//    //重命名 并 移动 本次开奖完成后的 原有拆单文件(已发生变更)
//    sprintf(pathName, "%s/%u_draw_order", dirPath_draw, match_code);
//    ret = move_file_md5(filePath_ord, pathName);
//    if (ret < 0) {
//        log_error("move_file_md5( %s, %s ) error.", filePath_ord, pathName);
//        return -1;
//    }


    //删除 本次开奖完成后的 order文件
    ret = delete_file_md5(filePath_ord);
    if (ret < 0) {
        log_error("delete_file_md5( %s ) error.", filePath_ord);
        return -1;
    }
    //删除 本次开奖完成后的 order.md5文件
    char filePath_order_md5[256];
    sprintf(filePath_order_md5, "%s.md5", filePath_ord);
    ret = delete_file_md5(filePath_order_md5);
    if (ret < 0) {
        log_error("delete_file_md5( %s ) error.", filePath_order_md5);
        return -1;
    }
    //删除 本次开奖完成后的 meta文件
    ret = delete_file_md5(filePath_meta);
    if (ret < 0) {
        log_error("delete_file_md5( %s ) error.", filePath_meta);
        return -1;
    }
    //删除 本次开奖完成后的 meta.md5文件
    char filePath_meta_md5[256];
    sprintf(filePath_meta_md5, "%s.md5", filePath_meta);
    ret = delete_file_md5(filePath_meta_md5);
    if (ret < 0) {
        log_error("delete_file_md5( %s ) error.", filePath_meta_md5);
        return -1;
    }

    //重命名 本次开奖完成后的 新拆单文件 和 新meta文件
    ret = move_file_md5(filePath_ord_new, filePath_ord);
    if (ret < 0) {
        log_error("move_file_md5( %s, %s ) error.", filePath_ord_new, filePath_ord);
        return -1;
    }
    ret = move_file_md5(filePath_meta_new, filePath_meta);
    if (ret < 0) {
        log_error("move_file_md5( %s, %s ) error.", filePath_meta_new, filePath_ord);
        return -1;
    }
    //备份现有的 拆单文件 和 meta文件
    ret = copy_file_md5(filePath_ord, filePath_ord_bak);
    if (ret < 0) {
        log_error("copy_file_md5( %s, %s ) error.", filePath_ord, filePath_ord_bak);
        return -1;
    }

    ret = copy_file_md5(filePath_meta, filePath_meta_bak);
    if (ret < 0) {
        log_error("copy_file_md5( %s, %s ) error.", filePath_meta, filePath_meta_bak);
        return -1;
    }

    //更新数据库比赛状态
    if ( !otl_fbs_set_match_state(game_code, match_code, M_STATE_CONFIRM) ) {
        log_error("otl_fbs_set_match_state(match_code[%u]  M_STATE_CONFIRM) failed.", match_code);
        return -1;
    }

//    //读取meta文件
//    META_ST meta_data;
//    ret = fbs_read_draw_meta_file(filePath_meta, &meta_data);
//    if (ret < 0) {
//        log_error("fbs_read_draw_meta_file() error. %s", filePath_meta);
//    	return -1;
//    }

//    //更新内存开奖结果
//    ret = game_handle[game_code].fbs_update_match_result(issue_number, match_code, meta_data.s_results, meta_data.match_result);
//    if (ret < 0) {
//        log_error("fbs_update_match_result( %u ) error.", match_code);
//    	return -1;
//    }

    //发送开奖完成的notify消息
    GLTP_MSG_NTF_GL_FBS_DRAW_CONFIRM notify;
	memset ((void*)&notify , 0 , sizeof(GLTP_MSG_NTF_GL_FBS_DRAW_CONFIRM));
	notify.gameCode = game_code;
    notify.issueNumber = issue_number;
    notify.matchCode = match_code;
    sys_notify(GLTP_NTF_GL_FBS_DRAW_CONFIRM, _INFO, (char*)&notify, sizeof(notify));

    //删除标记文件 (比赛开奖完成)
    mark_content = fbs_draw_tag(filePath_tag, match_code, 0, 3);
    if (mark_content < 0) {
        log_error("fbs_draw_tag( %u, deleteTagFile) error", match_code);
        return -1;
    }

    //insert 自动兑奖 记录
    GIDB_FBS_DL_HANDLE *driverlog_handle = gidb_fbs_dl_get_handle(game_code);
    if (driverlog_handle == NULL)
    {
        log_error("gidb_fbs_dl_get_handle(%d) error");
        return -1;
    }

    char msg[100] = {0};
    sprintf(msg, "1:%u", issue_number);
    int msglen = strlen(msg);
    ret = driverlog_handle->gidb_fbs_dl_append(driverlog_handle, issue_number, match_code, INM_TYPE_AP_AUTODRAW, msg, msglen);
    if (ret < 0)
    {
        log_error("gidb_fbs_dl_append(%d) type[%d] error", match_code, INM_TYPE_AP_AUTODRAW);
        return -1;
    }

    // 输出开奖信息
    log_info("\n--- FBS Match Draw Confirm. ---   issue[%u] match[%u] ---\n", issue_number,match_code);

    return 0;
}


typedef struct _FBS_DB_ERROR
{
    uint8  game_code;
    uint32 issue_number;
    uint32 match_code;
    uint8  match_status; // M_STATE_DRAW  || M_STATE_CONFIRM
} FBS_DB_ERROR;
//开奖过程中出现问题，将更新数据库的相关字段，记录错误原因编码和原因描述
//发送notify消息，报告期次开奖的问题
int fbs_set_draw_process_error(FBS_DB_ERROR *db_error)
{
    log_error("FBS Draw Match(issue_num[%u] match_code[%u] match_status[%u]) process found error.",
            db_error->issue_number, db_error->match_code, db_error->match_status);

	//更新数据库比赛的处理错误信息
	if ( !otl_fbs_set_match_process_error(db_error->game_code, db_error->issue_number, db_error->match_code) ) {
        log_error("otl_set_issue_process_error(issue_num[%u] match_code[%u] match_status[%u]) failed.",
            db_error->issue_number, db_error->match_code, db_error->match_status);
    }

    //发送开奖过程错误的 NOTIFY 消息
    GLTP_MSG_NTF_GL_FBS_DRAW_ERR notify;
	memset ((void*)&notify , 0 , sizeof(GLTP_MSG_NTF_GL_FBS_DRAW_ERR));
	notify.gameCode = db_error->game_code;
    notify.issueNumber = db_error->issue_number;
    notify.matchCode = db_error->match_code;
    notify.matchStatus = db_error->match_status;
    notify.error = 1;
	sys_notify(GLTP_NTF_GL_FBS_DRAW_ERR, _ERROR, (char*)&notify, sizeof(notify));
    return 0;
}



int32 gl_draw_dispatcher(char *inm_buf, FBS_DB_ERROR *db_error)
{
    int ret = 0;
    INM_MSG_HEADER *pInm = (INM_MSG_HEADER *)inm_buf;
    //k-debug:FBS
    log_info("fbs draw type:%d", pInm->type);
    switch (pInm->type)
    {
        case INM_TYPE_O_FBS_DRAW_INPUT_RESULT:
        {
            //比赛开奖
            INM_MSG_O_FBS_DRAW_INPUT_RESULT *inm_ptr = (INM_MSG_O_FBS_DRAW_INPUT_RESULT *)inm_buf;

            db_error->game_code = inm_ptr->gameCode;
            db_error->issue_number = inm_ptr->issueNumber;
            db_error->match_code = inm_ptr->matchCode;
            db_error->match_status = M_STATE_RESULT;

            //k-debug:FBS
            log_info("fbs draw begin");
            ret = fbs_draw_match(inm_ptr->gameCode, inm_ptr->issueNumber, inm_ptr->matchCode, inm_ptr->drawResults, inm_ptr->matchResult);
            if (ret < 0) {
                log_error("fbs_draw_match( %u ) failure", inm_ptr->matchCode);
                return -1;
            }
            //k-debug:FBS
            //gidb_fbs_st_close_all_handle();
            //gidb_fbs_wt_close_all_handle();
            break;
        }

        case INM_TYPE_O_FBS_DRAW_CONFIRM:
        {
            //比赛开奖结果确认
            INM_MSG_O_FBS_DRAW_CONFIRM *inm_ptr = (INM_MSG_O_FBS_DRAW_CONFIRM *)inm_buf;

            db_error->game_code = inm_ptr->gameCode;
            db_error->issue_number = inm_ptr->issueNumber;
            db_error->match_code = inm_ptr->matchCode;
            db_error->match_status = M_STATE_CONFIRM;

            ret = fbs_draw_confirm(inm_ptr->gameCode, inm_ptr->issueNumber, inm_ptr->matchCode);
            if (ret < 0) {
                log_error("fbs_draw_confirm( %u ) failure", inm_ptr->matchCode);
                return -1;
            }
            break;
        }

        default:
            return 1;
    }

    gidb_fbs_st_clean_handle();
    gidb_fbs_wt_clean_handle();

    return ret;
}

static void signal_handler(int signo)
{
    ts_notused(signo);
    exit_signal_fired = 1;
    return;
}

static int init_signal(void)
{
    signal(SIGPIPE, SIG_IGN);

    struct sigaction sas;
    memset(&sas, 0, sizeof(sas));
    sas.sa_handler = signal_handler;
    sigemptyset(&sas.sa_mask);
    sas.sa_flags |= SA_INTERRUPT;
    if (sigaction(SIGINT, &sas, NULL) == -1) {
        log_error("sigaction() failed. Reason: %s", strerror(errno));
        return -1;
    }

    if (sigaction(SIGTERM, &sas, NULL) == -1) {
        log_error("sigaction() failed. Reason: %s", strerror(errno));
        return -1;
    }
    return 0;
}

int main(int argc, char *argv[])
{
    ts_notused(argc);

    int ret = 0;

    //根据启动参数得到游戏编码
    game_code = atoi(argv[1]);
    task_draw_idx = (SYS_TASK)sysdb_get_gl_draw_task_index(game_code);
    char game_abbr[16];
    get_game_abbr(game_code, game_abbr);
    sprintf(MY_TASK_NAME, "gl_draw_%s", game_abbr);

    logger_init(MY_TASK_NAME);

    ret = init_signal();
    if (0 != ret)
    {
        log_error("init_signal() failed.");
        return -1;
    }

    if (!sysdb_init())
    {
        log_error("%s sysdb_init error.",MY_TASK_NAME);
        return -1;
    }

    if (!bq_init())
    {
        sysdb_close();
        log_error("bq_init() failed.");
        return -1;
    }

    if (!gl_init())
    {
        sysdb_close();
        bq_close();
        log_error("%s gl_init() error.",MY_TASK_NAME);
        return -1;
    }

	if (gl_game_plugins_init()!=0)
    {
        log_error("gl_game_plugins_init() failed.");
        return -1;
    }
    game_handle = gl_plugins_handle();

    log_info("%s start\n", MY_TASK_NAME);

    SYS_DB_CONFIG *sysDBconfig = sysdb_getOmsDBCfg();
    char dbConnStr[64] = {0};
    sprintf(dbConnStr,"%s/%s@%s",sysDBconfig->username,sysDBconfig->password,sysDBconfig->url);
    if(!otl_connectDB(sysDBconfig->username, sysDBconfig->password, sysDBconfig->url,2))
    {
        sysdb_close();
        log_error("otl_connectDB() failed.");
        return -1;
    }

    GIDB_FBS_DL_HANDLE *fbs_dl_handle = gidb_fbs_dl_get_handle(game_code);
    if (fbs_dl_handle == NULL)
    {
        sysdb_close();
        log_error("gidb_fbs_dl_get_handle(%d) error", game_code);
        return -1;
    }

    //创建消息队列
    queue = queue_fbs_msg_create();
    if (NULL == queue) {
        log_error("queue_fbs_msg_create() failed.");
        return -1;
    }
    //创建 处理中奖票线程
    pthread_t threadId;
    ret = pthread_create(&threadId, NULL, fbs_draw_win_ticket_process_thread, (void *)queue);
    if(ret!=0) {
        log_error("Start gl_draw_win_ticket_process_thread failure.");
        return -1;
    }

    sysdb_setTaskStatus(task_draw_idx, SYS_TASK_STATUS_RUN );

    log_info("%s init success\n", MY_TASK_NAME);


    FBS_DB_ERROR db_error;
    static char inm_buf[INM_MSG_BUFFER_LENGTH];
    uint32 msgid = 0;
    uint8 msg_type = 0;
    uint32 inm_len = 0;
    while (0 == exit_signal_fired)
    {
        //扫表获取下一条需要处理的日志记录，获取其DRAW_MSG_KEY表列存储的INM消息
        ret = fbs_dl_handle->gidb_fbs_dl_get_last(fbs_dl_handle, &msgid, &msg_type, inm_buf, &inm_len);
        if (ret < 0)
        {
            log_error("gidb_fbs_dl_get_last(%d) error", game_code);
            return -1;
        }
        else if(ret == 1)
        {
            //get nothing
            if (SYS_STATUS_END==sysdb_getSysStatus() && sysdb_getSafeClose()==1)
                exit_signal_fired = 1; //saft exit
            ts_sleep(500*1000,0);
            continue;
        }

        //dispatch message
        ret = gl_draw_dispatcher(inm_buf, &db_error);
        if (ret < 0)
        {
            log_error("gl_draw_dispatcher() failed.");
            fbs_set_draw_process_error(&db_error);
            return -1;
        }

        //confirm drawlog message
        if (ret == 0)
        {
            ret = fbs_dl_handle->gidb_fbs_dl_confirm(fbs_dl_handle, msgid, 1);
        }
        else if (ret == 1)
        {
            ret = fbs_dl_handle->gidb_fbs_dl_confirm(fbs_dl_handle, msgid, 2);
        }
        else // (ret < 0)
        {
            log_error("gidb_fbs_dl_confirm(%d) error", game_code);
            return -1;
        }
    }

    sysdb_setTaskStatus(task_draw_idx, SYS_TASK_STATUS_EXIT);

    gidb_fbs_dl_close_handle(fbs_dl_handle);
    gidb_fbs_st_close_all_handle();
    gidb_fbs_wt_close_all_handle();
    gidb_fbs_im_close_all_handle();

    otl_disConnectDB();

    sysdb_close();

    log_info("%s exit\n", MY_TASK_NAME);

    return 0;
}

int get_game_param(uint8 game_code, uint32 issue_number, char *game_buf)
{
    int ret = 0;

    //得到售票数据的Handle
    GIDB_FBS_ST_HANDLE *t_handle = gidb_fbs_st_get_handle(game_code, issue_number);
    if (t_handle == NULL)
    {
        log_error("gidb_fbs_st_get_handle() failure! game[%d] issue_number[%u]", game_code, issue_number);
        return -1;
    }

    //k-debug:FBS
    log_info("t_handle:%u", t_handle->issue_number);

    int32 game_buf_len = 0;
    ret = t_handle->gidb_fbs_st_get_field_blob(t_handle, FBS_ST_GAME_PARAMBLOB_KEY, game_buf, &game_buf_len);
    if (ret != 0)
    {
        log_error("gidb_fbs_st_get_field_blob(%d, %u, FBS_ST_GAME_PARAMBLOB_KEY) failure!", game_code, issue_number);
        return -1;
    }

    return 0;
}





#if 0

----bak1----

uint32 ord_count = 0;
static uint64 q_ptr[4096] = {0};

//发送此次更新中奖票的开始消息
FBS_WIN_MSG *item = (FBS_WIN_MSG*)malloc(sizeof(FBS_WIN_MSG));
item->type = 0;
item->issue = issue_number;
item->match = match_code;
//send queue
queue->enqueue(queue, item);
win_ticket_sync = 0;

GIDB_FBS_ST_HANDLE *fbs_st_handle = NULL;
static char st_buffer[16*1024];
GIDB_FBS_ST_REC *pSTicket = NULL;
char *ptr = NULL;
int tl = 0;
int rl = offsetof(GIDB_FBS_ST_REC,ticket);
pos = 0;
while (pos < file_offset) {
    ord_rec = (FBS_ORDER_REC*)((char*)mmap_ptr+pos);
    //k-debug:
    log_debug("ord_rec after. uniquetsn[%lu]no[%d]state[%d]subtype[%d]pos[%ld]offset[%ld]passamount[%ld]",
            ord_rec->unique_tsn, ord_rec->ord_no, ord_rec->state, ord_rec->sub_type, pos, file_offset, ord_rec->passed_amount);
    if (ord_rec->state==ORD_STATE_BET) {
        //此单等待继续开奖, 写入新的拆单文件
        if (1 != fwrite((char*)ord_rec,ord_rec->length,1,fd_ord_new)) {
            log_error("fwrite error. %s", filePath_ord_new);
            return -1;
        }
        pos += ord_rec->length;
        continue;
    }

    if (ord_rec->state==ORD_STATE_PASSED) {
        //此单等待继续开奖, 写入新的拆单文件
        //此单过关，更新中奖金额
        ord_rec->passed_amount = ord_rec->passed_amount * s_results[ord_rec->sub_type].final_sp / 1000.0;

        if (1 != fwrite((char*)ord_rec,ord_rec->length,1,fd_ord_new)) {
            log_error("fwrite error. %s", filePath_ord_new);
            return -1;
        }
        pos += ord_rec->length;
        continue;
    }

    if (ord_rec->state == ORD_STATE_NO_WIN) {
        //没有中奖
        pos += ord_rec->length;
        continue;
    }

    if (ord_rec->state == ORD_STATE_RETURN) {
        //单关比赛取消,做退票处理
        ord_rec->passed_amount = ord_rec->passed_amount;
    } else { //ORD_STATE_WIN
        //此单中奖，更新中奖金额
        ord_rec->passed_amount = ord_rec->passed_amount * s_results[ord_rec->sub_type].final_sp / 1000.0;
        if (ord_rec->bet_type == BET_1C1) {
            s_results[ord_rec->sub_type].single_win_amount += ord_rec->passed_amount;
        } else {
            s_results[ord_rec->sub_type].multiple_win_amount += ord_rec->passed_amount;
        }

        s_results[ord_rec->sub_type].win_amount = s_results[ord_rec->sub_type].single_win_amount +
                                                  s_results[ord_rec->sub_type].multiple_win_amount;

        //k-debug
        log_debug("win [%lu][%d]", ord_rec->unique_tsn, ord_rec->ord_no);
    }

    if (pSTicket == NULL) {
        //第一次进入循环
        //查询此单的 销售票信息
        if (1 == st_map.count(ord_rec->unique_tsn)) {
            pSTicket = st_map[ord_rec->unique_tsn];
            st_map.erase(ord_rec->unique_tsn);
            //k-debug:test
            log_debug("pSTicket[%ld][%d]", pSTicket->unique_tsn, pSTicket->sub_type);
        } else {
            fbs_st_handle = gidb_fbs_st_get_handle(game_code, ord_rec->issue_number);
            if (fbs_st_handle == NULL) {
                log_error("gidb_fbs_st_get_handle() failure! game[%d] issue_number[%u]", game_code, ord_rec->issue_number);
                return -1;
            }
            ret = fbs_st_handle->gidb_fbs_st_get_ticket(fbs_st_handle, ord_rec->unique_tsn, (GIDB_FBS_ST_REC*)st_buffer);
            if (ret < 0) {
                log_error("gidb_fbs_st_get_ticket() error. issue[%u] unique_tsn[%llu]", ord_rec->issue_number, ord_rec->unique_tsn);
                return -1;
            } else if (ret == 1) {
                log_error("ticket not found. issue[%u] unique_tsn[%llu]", ord_rec->issue_number, ord_rec->unique_tsn);
                return -1; //应该不会发生这个问题
            }
            //分配内存
            ptr = (char *)malloc(rl);
            memcpy(ptr, st_buffer, rl);
            pSTicket = (GIDB_FBS_ST_REC*)ptr;
            //k-debug:test
            log_debug("pSTicket[%ld][%d]", pSTicket->unique_tsn, pSTicket->sub_type);
        }
        q_ptr[0] = (uint64)pSTicket;
        ord_count = 1;
        q_ptr[1] = (uint64)ord_rec;
    } else if (pSTicket->unique_tsn == ord_rec->unique_tsn) {
        //和上一单属于同一张票
        ord_count++;
        q_ptr[ord_count] = (uint64)ord_rec;
        //k-debug:test
        log_debug("pSTicket[%ld][%d][%d]", pSTicket->unique_tsn, pSTicket->sub_type, ord_count);
    } else {
        //扫描到不同unique_tsn的彩票,将前一张彩票发送到消息队列
        tl = sizeof(FBS_WIN_MSG) + sizeof(void*)*(ord_count+1);
        item = (FBS_WIN_MSG*)malloc(tl);
        item->type = 1;
        item->issue = issue_number;
        item->match = match_code;
        item->len = ord_count;
        memcpy(item->data, (char*)q_ptr, sizeof(uint64)*(ord_count+1));
        //send queue
        queue->enqueue(queue, item);

        ord_count = 0;

        //查询新单的 销售票信息
        if (1 == st_map.count(ord_rec->unique_tsn)) {
            pSTicket = st_map[ord_rec->unique_tsn];
            st_map.erase(ord_rec->unique_tsn);
            //k-debug:test
            log_debug("pSTicket[%ld][%d]", pSTicket->unique_tsn, pSTicket->sub_type);
        } else {
            fbs_st_handle = gidb_fbs_st_get_handle(game_code, ord_rec->issue_number);
            if (fbs_st_handle == NULL) {
                log_error("gidb_fbs_st_get_handle() failure! game[%d] issue_number[%u]", game_code, ord_rec->issue_number);
                return -1;
            }
            ret = fbs_st_handle->gidb_fbs_st_get_ticket(fbs_st_handle, ord_rec->unique_tsn, (GIDB_FBS_ST_REC*)st_buffer);
            if (ret < 0) {
                log_error("gidb_fbs_st_get_ticket() error. issue[%u] unique_tsn[%llu]", ord_rec->issue_number, ord_rec->unique_tsn);
                return -1;
            } else if (ret == 1) {
                log_error("ticket not found. issue[%u] unique_tsn[%llu]", ord_rec->issue_number, ord_rec->unique_tsn);
                return -1; //应该不会发生这个问题
            }
            //分配内存
            ptr = (char *)malloc(rl);
            memcpy(ptr, st_buffer, rl);
            pSTicket = (GIDB_FBS_ST_REC*)ptr;

            //k-debug:test
            log_debug("pSTicket[%ld][%d]", pSTicket->unique_tsn, pSTicket->sub_type);
        }
        q_ptr[0] = (uint64)pSTicket;
        ord_count = 1;
        q_ptr[1] = (uint64)ord_rec;
    }
    pos += ord_rec->length;
    //k-debug:test
    log_debug("ord_rec length[%d]", ord_rec->length);
}

//将最后一张彩票发送到消息队列
if(ord_count > 0) {
    tl = sizeof(FBS_WIN_MSG) + sizeof(void*)*(ord_count+1);
    item = (FBS_WIN_MSG*)malloc(tl);
    item->type = 1;
    item->issue = issue_number;
    item->match = match_code;
    item->len = ord_count;
    memcpy(item->data, (char*)q_ptr, sizeof(uint64)*(ord_count+1));
    //send queue
    queue->enqueue(queue, item);

    ord_count = 0;
    //k-debug:test
    log_debug("send type 1");
}

//发送此次更新中奖票的结束消息
item = (FBS_WIN_MSG*)malloc(sizeof(FBS_WIN_MSG));
item->type = 2;
item->issue = issue_number;
item->match = match_code;
//send queue
queue->enqueue(queue, item);


//等待sqlite中奖票入库完成
while (1) {
    if (win_ticket_sync == 1)
        break;
    ts_sleep(1,1);
}

log_info("--- FBS Match Draw.  issue[%u] match[%u] STEP[%u] ---", issue_number,match_code, step); step++;

#endif



#if 0

----bak2----
        //处理中奖票入库begin
        if (msg->type == 0) {
            //k-debug:FBS
            log_info("msg->type == 0");
            //开始入库 open gidb fbs win handle
            fbs_wt_handle = gidb_fbs_wt_get_handle(GAME_FBS, msg->issue);
            if(fbs_wt_handle == NULL) {
                log_error("gidb_fbs_wt_get_handle(issueNumber[%u]) return null.", msg->issue);
                exit(-1);
            }
            ret = fbs_wt_handle->gidb_fbs_wt_clean(fbs_wt_handle,msg->match);
            if(ret != 0) {
                log_error("gidb_fbs_wt_clean(issue[%u] match[%u]) error.", msg->issue,msg->match);
                exit(-1);
            }
            issue_number = msg->issue;
            match_code = msg->match;

            free(msg);
            win_ticket_sync = 0;
            continue;
        }

        //处理中奖票入库end
        if (msg->type == 2) {
            //k-debug:FBS
            log_info("msg->type == 2");
            //入库结束
            fbs_wt_handle = gidb_fbs_wt_get_handle(GAME_FBS, msg->issue);
            if(fbs_wt_handle == NULL) {
                log_error("gidb_fbs_wt_get_handle(issueNumber[%u]) return null.", msg->issue);
                exit(-1);
            }
            //sync win ticket
            fbs_wt_handle->gidb_fbs_wt_sync_ticket(fbs_wt_handle);
            //close gidb fbs win handle
            gidb_fbs_wt_close_handle(fbs_wt_handle);
            free(msg);
            win_ticket_sync = 1;
            continue;
        }

        int idx = 1; //计算FBS_ORDER_REC数量
        //k-debug:test
        log_debug("enter type 1");

        //处理中奖票 msg->type == 1
        uint64* ptr = msg->data;
        pSTicket = (GIDB_FBS_ST_REC*)ptr[0];
        order_rec = (FBS_ORDER_REC*)ptr[1];

        mlen = sizeof(GIDB_FBS_WT_REC);
        pWTicket = (GIDB_FBS_WT_REC*)malloc(mlen);
        memset(pWTicket,0,sizeof(GIDB_FBS_WT_REC));
        //convert   pSTicket --->  pWTicket
        fbs_sale_ticket_2_win_ticket_rec(pSTicket, pWTicket);


        FBS_GT_GAME_PARAM *game = &game_param;
        log_info("gameParam.tax[%lld][%d][%d]", game->taxStartAmount, game->taxRate, game->returnRate);


        fbs_wt_handle = gidb_fbs_wt_get_handle(GAME_FBS, msg->issue);
        if(fbs_wt_handle == NULL) {
            log_error("gidb_fbs_wt_get_handle(issueNumber[%u]) return null.", msg->issue);
            exit(-1);
        }
        if (pSTicket->bet_type == BET_1C1 &&
            order_rec->state==ORD_STATE_RETURN ) {
            //单关投注,比赛取消,做退票处理
            ret = fbs_wt_handle->gidb_fbs_wt_insert_return(fbs_wt_handle, pWTicket);
            if (ret != 0) {
                log_error("gidb_fbs_wt_insert_return() failure. unique_tsn[%llu] false.", pWTicket->unique_tsn);
                exit(-1);
            }
            count++;
        } else {
            while (idx <= msg->len) {
                order_rec = (FBS_ORDER_REC*)ptr[idx];

                //累加
                pWTicket->winningAmountWithTax += order_rec->passed_amount;
                pWTicket->winningCount += order_rec->win_bet_count;

                mlen = sizeof(GIDB_FBS_WO_REC) + order_rec->match_count*sizeof(FBS_BETM);
                pWOrder = (GIDB_FBS_WO_REC*)malloc(mlen);
                //convert   order_rec --->  pWOrder
                fbs_order_rec_2_wo_rec(order_rec, pWOrder);

                ret = fbs_wt_handle->gidb_fbs_wt_insert_order(fbs_wt_handle, pWOrder);
                if (ret != 0) {
                    log_error("gidb_fbs_wt_insert_order() failure. unique_tsn[%llu] false.", pWOrder->unique_tsn);
                    exit(-1);
                }

                //k-debug:test
                log_debug("order unique[%ld]no[%d]psdAmount[%ld]", order_rec->unique_tsn, order_rec->ord_no, order_rec->passed_amount);
                idx++;
                count++;
            }

            if (pWTicket->winningAmountWithTax >= game->taxStartAmount) {
                pWTicket->taxAmount = (pWTicket->winningAmountWithTax - game->taxStartAmount) * game->taxRate / 1000;
                pWTicket->winningAmount = pWTicket->winningAmountWithTax - pWTicket->taxAmount;
            }

            //单关、过关投注
            pWTicket->win_match_code = match_code;
            pWTicket->isBigWinning = 0;
            ret = fbs_wt_handle->gidb_fbs_wt_insert_ticket(fbs_wt_handle, pWTicket);
            if (ret != 0) {
                log_error("gidb_fbs_wt_insert_ticket() failure. unique_tsn[%llu] false.", pWTicket->unique_tsn);
                exit(-1);
            }
        }
        free(msg);
        if (count>=10000) {
            //sync win ticket
            fbs_wt_handle->gidb_fbs_wt_sync_ticket(fbs_wt_handle);
            count = 0;
        }
#endif



