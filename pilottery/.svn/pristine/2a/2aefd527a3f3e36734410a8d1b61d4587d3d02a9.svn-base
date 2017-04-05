#include "ncp.h"
#include "cache_mgr.h"
#include "ncp_worker.h"
#include "ncp_server.h"
#include "ncp_ncpc.h"


// queue ---------------------------------------------
static void ts_queue_enqueue(ts_queue *q, tq_item* item)
{
    pthread_mutex_lock(&(q->mutex));
    if (q->size == 0) {
        q->head = q->tail = item;
        item->next = NULL;
    } else {
        item->next = NULL;
        q->tail->next = item;
        q->tail = item;
    }
    q->size++;
    pthread_mutex_unlock(&(q->mutex));
    pthread_cond_signal(&(q->cond));
    return;
}

static tq_item *ts_queue_dequeue(ts_queue *q)
{
    pthread_mutex_lock(&(q->mutex));
    if (q->size == 0) {
        pthread_mutex_unlock(&(q->mutex));
        return NULL;
    }
    tq_item *msg = q->head;
    q->head = msg->next;
    if (NULL == q->head)
        q->tail = NULL;
    q->size--;

    pthread_mutex_unlock(&(q->mutex));
    return msg;
}


static tq_item *ts_queue_dequeue_timeout(ts_queue *q, int timeout_msec)
{
    pthread_mutex_lock(&(q->mutex));
    if (timeout_msec == 0) {
        while (q->size == 0) {
            //blocked receive
            pthread_cond_wait(&(q->cond), &(q->mutex));
        }
    } else {
        //blocked receive with timeout
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
    tq_item *msg = q->head;
    q->head = msg->next;
    if (NULL == q->head)
        q->tail = NULL;
    q->size--;
    pthread_mutex_unlock(&(q->mutex));
    return msg;
}

static int ts_queue_size(ts_queue *q)
{
    pthread_mutex_lock(&(q->mutex));
    int size = q->size;
    pthread_mutex_unlock(&(q->mutex));
    return size;
}

ts_queue *ts_queue_create()
{
    ts_queue *q = (ts_queue *)wh_malloc(sizeof(ts_queue));
    memset(q, 0, sizeof(ts_queue));

    q->enqueue = ts_queue_enqueue;
    q->dequeue = ts_queue_dequeue;
    q->dequeue_timeout = ts_queue_dequeue_timeout;
    q->get_size = ts_queue_size;
    q->head = NULL;
    q->tail = NULL;
    q->size = 0;

    int ret = pthread_mutex_init(&(q->mutex), NULL);
    if (0 != ret) {
        logit(EE, "pthread_mutex_init() failed. Reason:[%s].", strerror(errno));
        return NULL;
    }
    ret = pthread_cond_init(&(q->cond), NULL);
    if (0 != ret) {
        logit(EE, "pthread_cond_init() failed. Reason:[%s].", strerror(errno));
        return NULL;
    }
    return q;
}


//connection
static unsigned int identify = 1;

conn_item *conn_new(int cfd, char *ip, int port)
{
    conn_item* c = (conn_item*)wh_malloc(sizeof(conn_item));
    memset(c, 0, sizeof(conn_item));
    c->cfd = cfd;
    c->identify = identify++;
    strcpy(c->m_ip, ip);
    c->m_port = port;

    c->rbuf = (char *)wh_malloc(BUFFER_SIZE+1);
    c->rsize = BUFFER_SIZE;
    c->rbytes = 0;
    c->last_update = get_now();
    c->watcher = (ev_io *)wh_malloc(sizeof(ev_io));
    c->watcher->data = c;
    c->close_socket = 0;
    return c;
}

void conn_close(conn_item *c)
{
    logit(II, "Close one connection.  fd[%d] ip[%s] port[%d].", c->cfd, c->m_ip, c->m_port);

    close(c->cfd);
    wh_free(c->watcher);
    c->rbytes = 0;
    wh_free(c->rbuf);
    wh_free(c);
}


int close_connection(conn_item *c)
{
    work_thread* wthread = c->thread;
    ev_io_stop(wthread->loop, c->watcher);
    conn_close(c);
    return 0;
}

static void send_data(conn_item* c, char *sbuf, int sbuf_len)
{
    char *enc_buffer = (char*)malloc(sbuf_len*2);
    int enc_buffer_len = encrypt_ts(sbuf, sbuf_len, enc_buffer, sbuf_len*2);

    int nwritten=0, r=0;
    while ( nwritten < sbuf_len ) {
        r = write( c->cfd, enc_buffer+nwritten, enc_buffer_len-nwritten );
        if ( r < 0 && ( errno == EINTR || errno == EAGAIN ) ) {
            usleep( 100*1000 );
            continue;
        }
        if ( r < 0 ) {
            logit(DD, "write error!");
            wh_free(enc_buffer);
            close(c->cfd); c->close_socket = 1;
            return;
        }
        if ( r == 0 )
            break;
        nwritten += r;
    }
    wh_free(enc_buffer);

    GLTP_MSG_T_HEADER *header = (GLTP_MSG_T_HEADER *)sbuf;
    //dump hex terminal message
    logit_hex(sbuf,header->length, "Tx to Terminal  [%-15s] ---> length[%hu] token[%lu] type[%hhu] func[%hu] msn[%u] identify[%u] status[%hu]",
            c->m_ip, header->length, header->token, header->type, header->func, header->msn, header->identify, header->status);
    return;
}

//send message
static int term_tx_message_process(ncp_server *ns, conn_item *c, char *sbuf)
{
    wh_notused(ns);
    GLTP_MSG_T_HEADER *header = (GLTP_MSG_T_HEADER *)sbuf;
    if (GLTP_T_AUTH_REQ == header->func) {
        GLTP_MSG_T_AUTH_RSP *rsp_msg = (GLTP_MSG_T_AUTH_RSP*)header;
        c->terminalCode = rsp_msg->terminalCode;
        c->agencyCode = rsp_msg->agencyCode;
        c->areaCode = rsp_msg->areaCode;
    }
    send_data(c, sbuf, header->length);
    return 0;
}
//send uns message
static int termuns_tx_message_process(ncp_server *ns, work_thread* wthread, char *sbuf)
{
    wh_notused(ns);
    conn_item *c = NULL;
    map<uint32, conn_item*>::iterator iter = wthread->socket_map.begin();
    for(; iter!=wthread->socket_map.end();iter++) {
        c = iter->second;
        GLTP_MSG_T_HEADER *header = (GLTP_MSG_T_HEADER *)sbuf;
        if (GLTP_T_UNS_OPEN_GAME==header->func || GLTP_T_UNS_CLOSE_GAME==header->func || GLTP_T_UNS_DRAW_ANNOUNCE==header->func) {
            send_data(c, sbuf, header->length);
        }
        /*
        else if (GLTP_T_UNS_RESET==header->func) {
            GLTP_MSG_T_RESET_UNS *pResetUns = (GLTP_MSG_T_RESET_UNS *)header;
            if ((pResetUns->ctrlLevel==0)
                || ((pResetUns->ctrlLevel==1) && (c->areaCode==pResetUns->ctrlCode))
                || ((pResetUns->ctrlLevel==2) && (c->agencyCode==pResetUns->ctrlCode)))
                send_data(c, sbuf, header->length);
        } else if (GLTP_T_UNS_MESSAGE==header->func) {
            GLTP_MSG_T_MESSAGE_UNS *pMessageUns = (GLTP_MSG_T_MESSAGE_UNS *)header;
            if ((pMessageUns->ctrlLevel==0)
                || ((pMessageUns->ctrlLevel==1) && (c->areaCode==pMessageUns->ctrlCode))
                || ((pMessageUns->ctrlLevel==2) && (c->agencyCode==pMessageUns->ctrlCode)))
                send_data(c, sbuf, header->length);
        }
        */
    }
    return 0;
}

static int rx_message_process(ncp_server *ns, conn_item *c, char *buf, int len)
{
    char *dec_buf = (char*)wh_malloc(len);
    int dec_buf_len = decrypt_ts(buf, len, dec_buf, len);
    if (dec_buf_len <= 0) {
        wh_free(dec_buf);
        logit(WW, "decrypt_ts() failure.");
        return -1;
    }
    c->last_update = time(NULL);

    GLTP_MSG_T_HEADER *header = (GLTP_MSG_T_HEADER *)dec_buf;
    header->identify = c->identify;

    //dump hex terminal message
    logit_hex(dec_buf, header->length, "Rx from Terminal[%-15s] ---> length[%hu] token[%lu] type[%hhu] func[%hu] msn[%u] identify[%u]",
            c->m_ip, header->length, header->token, header->type, header->func, header->msn, header->identify);

    if (GLTP_MSG_TYPE_TERMINAL==header->type && GLTP_T_HB==header->func) {
        //send heartbeat response direct
        header->when = get_now();
        header->status = 0;
        send_data(c, dec_buf, header->length);
        wh_free(dec_buf);
        return 0;
    }
    if (GLTP_MSG_TYPE_TERMINAL==header->type && GLTP_T_NETWORK_DELAY_REQ==header->func) {
        //send network delay response direct
        header->func = GLTP_T_NETWORK_DELAY_RSP;
        header->when = get_now();
        header->status = 0;
        header->length = sizeof(GLTP_MSG_T_NETWORK_DELAY_RSP);
        send_data(c, dec_buf, header->length);
        //send network delay message to host
        GLTP_MSG_T_NETWORK_DELAY_REQ *req_msg = (GLTP_MSG_T_NETWORK_DELAY_REQ*)header;
        GLTP_MSG_N_TERM_NETWORK_DELAY *delay_msg = (GLTP_MSG_N_TERM_NETWORK_DELAY*)malloc(sizeof(GLTP_MSG_N_TERM_NETWORK_DELAY));
        delay_msg->header.length = sizeof(GLTP_MSG_N_TERM_NETWORK_DELAY);
        delay_msg->header.type = GLTP_MSG_TYPE_NCP;
        delay_msg->header.func = GLTP_N_TERM_NETWORK_DELAY;
        delay_msg->header.when = get_now();
        delay_msg->token = req_msg->header.token;
        delay_msg->timestamp = req_msg->header.when;
        delay_msg->delayMilliSeconds = req_msg->delayMilliSeconds;
        delay_msg->crc = 0;
        ncpc_notify(ns, 0, (char*)delay_msg);
        wh_free(dec_buf);
        return 0;
    }
    if (GLTP_MSG_TYPE_TERMINAL==header->type && GLTP_T_GAME_ISSUE_REQ==header->func) {
        GLTP_MSG_T_GAME_ISSUE_REQ *req_msg = (GLTP_MSG_T_GAME_ISSUE_REQ*)header;
        char issue_buf[256] = { 0 };
        GLTP_MSG_T_GAME_ISSUE_RSP *resp_msg = (GLTP_MSG_T_GAME_ISSUE_RSP*)issue_buf;
        if (0 > ccmgr_issue_get(ns->ccmgr, req_msg->gameCode, (HOST_GAME_ISSUE*)&resp_msg->gameCode))
            resp_msg->header.status = SYS_RESULT_SELL_NOISSUE_ERR;
        else
            resp_msg->header.status = SYS_RESULT_SUCCESS;
        resp_msg->header.length = sizeof(GLTP_MSG_T_GAME_ISSUE_RSP);
        resp_msg->header.type = GLTP_MSG_TYPE_TERMINAL;
        resp_msg->header.func = GLTP_T_GAME_ISSUE_RSP;
        resp_msg->header.when = get_now();
        resp_msg->header.token = req_msg->header.token;
        resp_msg->header.identify = 0;
        resp_msg->header.msn = req_msg->header.msn;
        resp_msg->header.param = 0;
        resp_msg->timeStamp = get_now();
        //send current issue inquiry
        send_data(c, issue_buf, resp_msg->header.length);
        wh_free(dec_buf);
        return 0;
    }

    //send gltp message to ncpc message queue
    ncpc_notify(ns, 0, dec_buf);
    return 0;
}

static void recv_callback(struct ev_loop* loop, struct ev_io* watcher, int revents)
{
    wh_notused(loop); wh_notused(revents);
    
    conn_item *c = (conn_item *)watcher->data;
    work_thread* wthread = c->thread;

    c->rbytes = 0;
    for (;;) {
        if (c->rbytes >= c->rsize) {
            break;
        }
        int avail = c->rsize - c->rbytes;
        int n = read(c->cfd, c->rbuf + c->rbytes, avail);
        if (n == 0) {
            logit(DD, "the peer has performed an orderly shutdown. Reason [%s].", strerror(errno));
            wthread->socket_map.erase(c->identify);
            close_connection(c);
            return;
        } else if (n == -1) {
            if (errno == EINTR) continue;
            else if (EAGAIN==errno || EWOULDBLOCK==errno) break;
            else {
                logit(DD, "read error!"); 
                wthread->socket_map.erase(c->identify);
                close_connection(c);
                return;
            }
        } else {
            c->rbytes += n;
            if (n < avail)
                break;
        }
    }

    int start = 0;
    int left = c->rbytes;
    char *buffer = c->rbuf;
    while (true) {
        if ((unsigned int)left <= MSG_HLEN) {
            if ( 0 != start && 0 != left) {
                memmove(buffer, buffer + start, left);
            }
            c->rbytes = left;
            return;
        }
        int r_msg_size = *(unsigned short*)(buffer+start);
        if (r_msg_size > left) {
            if (0 != start && 0 != left) {
                memmove(buffer, buffer + start, left);
            }
            c->rbytes = left;
            return;
        }
        if (0 > rx_message_process(wthread->ns, c, buffer+start, r_msg_size)) {
            logit(WW, "message_process failure!");
            wthread->socket_map.erase(c->identify);
            close_connection(c);
            return;
        }
        start += r_msg_size;
        left -= r_msg_size;
    }
    return;
}

//定时器
static void timer_callback(EV_P_ ev_timer *watcher, int revents)
{
    wh_notused(loop); wh_notused(revents);

    work_thread* wthread = (work_thread*)watcher->data;
    ncp_server *ns = wthread->ns;
    conn_item *c = NULL;

    uint32 time_n = get_now();
    //关闭超时的连接
    map<uint32, conn_item*>::iterator iter = wthread->socket_map.begin();
    for(; iter!=wthread->socket_map.end();)
    {
        c = iter->second;
        if ((ns->host_connected==0) || (c->close_socket==1) || (time_n-c->last_update > ns->keepalive_time)) {
            wthread->socket_map.erase(iter++);
            close_connection(c);
        } else {
            ++iter;
        }
    }
}

static void async_callback(EV_P_ ev_async* watcher, int revents)
{
    wh_notused(loop); wh_notused(revents);

    work_thread* wthread = (work_thread*)watcher->data;
    ncp_server *ns = wthread->ns;
    conn_item *c = NULL;
    //obtain a request message
    while(1) {
        tq_item* item = wthread->que->dequeue(wthread->que);
        if(item == NULL)
            break;

        if (item->type==1) {
            //accept new connection
            c = item->c;
            wthread->socket_map[c->identify] = c;
            ev_io_init(c->watcher, recv_callback, c->cfd, EV_READ);
            ev_io_start(wthread->loop, c->watcher);
        } else if (item->type==2) {
            //send message to one terminal
            map<uint32, conn_item*>::iterator iter = wthread->socket_map.find(item->identify);
            if(iter == wthread->socket_map.end()) {
                logit(DD, "item->identify [%u] not found", item->identify);
            } else {
                term_tx_message_process(ns, iter->second, item->data);
            }
            wh_free(item->data);
        } else if (item->type==3) {
            //send message to all terminal
            termuns_tx_message_process(ns, wthread, item->data);
            wh_free(item->data);
        } else if (item->type==4) {
            //close one connection
            c = item->c;
            wthread->socket_map.erase(c->identify);
            close_connection(c);
        } else if (item->type==5) {
            //close all connection
            map<uint32, conn_item*>::iterator iter = wthread->socket_map.begin();
            for(; iter!=wthread->socket_map.end();) {
                c = iter->second;
                wthread->socket_map.erase(iter++);
                close_connection(c);
            }
        } else {
            logit(EE, "*** unknow type ***");
        }
        wh_free(item);
    }
}

static void* worker_loop(void* arg)
{
    work_thread *wthread = (work_thread *)arg;
    ev_loop(wthread->loop, 0);
    return NULL;
}

int worker_init(ncp_server *ns)
{
    //create worker thread
    int i = 0;
    ns->worker_threads = (work_thread *)wh_malloc(sizeof(work_thread)*ns->worker_thread_count);
    for(i=0; i<ns->worker_thread_count; ++i)
    {
        char *ptr = (char *)&ns->worker_threads[i];
        new(ptr)_work_thread();

        work_thread *worker = &ns->worker_threads[i];
        worker->idx = i;

        worker->ns = ns;
        worker->que = ts_queue_create();

        worker->loop = ev_loop_new(0);
        if(!worker->loop) {
            logit(EE, "ev_loop_new() fail");
            return -1;
        }

        //初始化事件监听
        worker->async_watcher.data = worker;
        ev_async_init(&worker->async_watcher, async_callback);
        ev_async_start(worker->loop, &worker->async_watcher);

        //初始化定时器事件
        worker->timer_watcher.data = worker;
        ev_timer_init(&worker->timer_watcher, timer_callback, 1., 5.);
        ev_timer_start(worker->loop, &worker->timer_watcher);

        //开启监听线程
        if(0 > pthread_create(&worker->th_id, NULL, worker_loop, (void*)worker)) {
            logit(EE, "pthread create fail. (worker_loop)");
            return -1;
        }
    }
    return 0;
}

void worker_notify(work_thread *worker, int type, uint32 identify, conn_item* c, char *data)
{
    //先将请求入队
    tq_item *item = (tq_item *)wh_malloc(sizeof(tq_item));
    item->type = type;
    item->identify = identify;
    item->c = c;
    item->data = data;
    worker->que->enqueue(worker->que, item);
    //发送信号通知工作线程接收请求
    ev_async_send(worker->loop, &worker->async_watcher);
}

