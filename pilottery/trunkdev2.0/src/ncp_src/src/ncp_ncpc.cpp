#include "ncp.h"
#include "cache_mgr.h"
#include "ncp_worker.h"
#include "ncp_server.h"
#include "ncp_ncpc.h"


int ncpc_fd;
struct ev_loop *loop;
ev_io ncpc_rx_watcher;
struct ev_async ncpc_async_watcher; //asynchronous event watcher
struct ev_timer ncpc_timer_watcher; //timer

char rx_buf[BUFFER_SIZE];
int rbytes = 0;
unsigned int last_heartbeat_tx = 0;
unsigned int last_heartbeat_rx = 0;

static int ncpc_conn_new(ncp_server *ns)
{
    ncpc_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (-1 == ncpc_fd) {
        logit(EE, "init ncpc socket fail. errno [%d]", ncpc_fd);
        return -1;
    }

    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(ns->host_port);
    inet_aton(ns->host_ip, &addr.sin_addr);
    if (connect(ncpc_fd, (struct sockaddr*) &addr, sizeof(addr)) == -1) {
        logit(WW, "connect[%s : %d] error. [%s]", ns->host_ip, ns->host_port, strerror(errno));
        close(ncpc_fd);
        return -1;
    }
    set_non_block(ncpc_fd);
    return 0;
}

static void ncpc_conn_close(ncp_server *ns)
{
    ns->host_connected = 0;
    close(ncpc_fd);
    ev_io_stop(EV_A_ &ncpc_rx_watcher);
    last_heartbeat_rx = 0;
    last_heartbeat_tx = 0;
    logit(WW, "close socket with host.");
}

static int ncpc_tx_process(ncp_server *ns, char *buf)
{
    wh_notused(ns);
    GLTP_MSG_T_HEADER *header = (GLTP_MSG_T_HEADER *)buf;
    //send to host
    size_t nwritten = 0;
    while (nwritten < header->length) {
        int r = write(ncpc_fd, (char*)buf+nwritten, header->length-nwritten);

        if (r < 0 && (errno == EINTR || errno == EAGAIN)) {
            usleep(10*1000);
            continue;
        }
        if (r < 0) {
            logit(WW, "write error!");
            return -1;
        }
        if (r == 0)
            break;
        nwritten += r;
    }
    if (header->type == GLTP_MSG_TYPE_TERMINAL) {
        logit_hex(buf, header->length, "Tx to Host   --->  length[%hu] type[%hhu] func[%hu] token[%lu] identify[%u]",
            header->length, header->type, header->func, header->token, header->identify);
    } else if (header->type == GLTP_MSG_TYPE_NCP) {
        logit_hex(buf, header->length, "Tx to Host   --->  length[%hu] type[%hhu] func[%hu]",
            header->length, header->type, header->func);
    } else {
        logit_hex(buf, header->length, "Tx to Host   --->  length[%hu] type[%hhu] func[%hu]",
            header->length, header->type, header->func);
    }
    return 0;
}

static int ncpc_rx_process(ncp_server *ns, char *buf)
{
    GLTP_MSG_T_HEADER *header = (GLTP_MSG_T_HEADER *)buf;
    switch (header->type) {
        case GLTP_MSG_TYPE_TERMINAL: {
            logit_hex(buf, header->length, "Rx from Host --->  length[%hu] type[%hhu] func[%hu] token[%lu] identify[%u]",
                header->length, header->type, header->func, header->token, header->identify);
            //send message to terminal
            work_thread *worker = get_worker(ns, header->identify);
            char *msg_buf = (char *)wh_malloc(header->length);
            memcpy(msg_buf, buf, header->length);
            worker_notify(worker, 2, header->identify, NULL, msg_buf);
            break;
        }
        case GLTP_MSG_TYPE_TERMINAL_UNS: {
            static HOST_GAME_ISSUE current_issue;
            if (header->func == GLTP_T_UNS_OPEN_GAME) {
                //issue open
                GLTP_MSG_T_OPEN_GAME_UNS *open_uns = (GLTP_MSG_T_OPEN_GAME_UNS*)header;
                current_issue.gameCode = open_uns->gameCode;
                current_issue.issueNumber = open_uns->issueNumber;
                current_issue.issueStartTime = open_uns->issueTimeStamp;
                current_issue.issueLength = open_uns->issueTimeSpan;
                current_issue.countDownSeconds = open_uns->countDownSeconds;
                ccmgr_issue_set(ns->ccmgr, open_uns->gameCode, &current_issue);
                logit_hex(buf, header->length, "Rx from Host --->  length[%hu] type[%hhu] func[%hu] (game:%u issue:%lu  OPEN)",
                    header->length, header->type, header->func, open_uns->gameCode, open_uns->issueNumber);
            } else if (header->func == GLTP_T_UNS_CLOSE_GAME) {
                //issue close
                GLTP_MSG_T_CLOSE_GAME_UNS *close_uns = (GLTP_MSG_T_CLOSE_GAME_UNS*)header;
                ccmgr_issue_del(ns->ccmgr, close_uns->gameCode);
                logit_hex(buf, header->length, "Rx from Host --->  length[%hu] type[%hhu] func[%hu] (game:%u issue:%lu  CLOSE)",
                    header->length, header->type, header->func, close_uns->gameCode, close_uns->issueNumber);
            } else if (header->func == GLTP_T_UNS_DRAW_ANNOUNCE) {
                //issue draw announce
                _GLTP_MSG_T_DRAW_ANNOUNCE_UNS *draw_announce_uns = (_GLTP_MSG_T_DRAW_ANNOUNCE_UNS*)header;
                logit_hex(buf, header->length, "Rx from Host --->  length[%hu] type[%hhu] func[%hu] (game:%u issue:%lu  DRAW ANNOUNCE)",
                    header->length, header->type, header->func, draw_announce_uns->gameCode, draw_announce_uns->issueNumber);
            } else {
                //other uns message
                logit_hex(buf, header->length, "Rx from Host --->  length[%hu] type[%hhu] func[%hu]",
                    header->length, header->type, header->func);
                logit(EE, "RECV *** UNKNOWN UNS MESSAGE ***   length[%hu] type[%hhu] func[%hu]", header->length, header->type, header->func);
                break;
            }
            //send uns message to all terminal
            for (int i=0;i<ns->worker_thread_count;i++) {
                work_thread *worker = &ns->worker_threads[i];
                char *msg_buf = (char *)wh_malloc(header->length);
                memcpy(msg_buf, buf, header->length);
                worker_notify(worker, 3, 0, NULL, msg_buf);
            }
            break;
        }
        case GLTP_MSG_TYPE_NCP: {
            if (header->func == GLTP_N_HB) {
                last_heartbeat_rx = time(NULL);
            } else if (header->func == GLTP_N_GAME_ISSUE_RSP) {
                GLTP_MSG_N_GAME_ISSUE_RSP *resp_msg = (GLTP_MSG_N_GAME_ISSUE_RSP*)header;
                HOST_GAME_ISSUE *issue_ptr = NULL;
                for (int i=0;i<resp_msg->gameCount;i++) {
                    issue_ptr = &resp_msg->issueInfo[i];
                    ccmgr_issue_set(ns->ccmgr, issue_ptr->gameCode, issue_ptr);
                    logit(DD, "get game current issue response. (game:%u issue:%lu)", issue_ptr->gameCode, issue_ptr->issueNumber);
                }
            } else {
                //other ncp message
                logit(EE, "RECV *** UNKNOWN NCP MESSAGE ***   length[%hu] type[%hhu] func[%hu]", header->length, header->type, header->func);
            }
            logit_hex(buf, header->length, "Rx from Host --->  length[%hu] type[%hhu] func[%hu]", header->length, header->type, header->func);
            break;
        }
        default: {
            logit(EE, "RECV *** UNKNOWN MESSAGE ***   length[%hu] type[%hhu] func[%hu]", header->length, header->type, header->func);
            break;
        }
    }
    return 0;
}

static void ncpc_recv_callback(EV_P_ ev_io *w, int revents)
{
    wh_notused(loop); wh_notused(revents);
    ncp_server *ns = (ncp_server *)w->data;
    int ret = 0;
    int rsize = BUFFER_SIZE;
    while ((rsize-rbytes) > 0) {
        ret = recv(ncpc_fd, rx_buf+rbytes, rsize-rbytes, 0);
        if (ret < 0) {
            if (errno == EINTR)
                continue;
            else if (EAGAIN == errno || EWOULDBLOCK == errno)
                break;
            else {
                logit(WW, "read error!");
                ncpc_conn_close(ns);
                return;
            }
        } else if (0 == ret) {
            logit(WW, "the peer has performed an orderly shutdown. Reason [%s].", strerror(errno));
            ncpc_conn_close(ns);
            return;
        } else
            rbytes += ret;
    }

    int start = 0;
    int left = rbytes;
    char *buffer = rx_buf;
    while (true) {
        if ((unsigned int)left < sizeof(unsigned short)) {
            if ( 0 != start && 0 != left) {
                memmove(buffer, buffer + start, left);
            }
            rbytes = left;
            return;
        }
        int msg_size = *((unsigned short *)(buffer + start));
        if (msg_size > left) {
            if (0 != start && 0 != left) {
                memmove(buffer, buffer + start, left);
            }
            rbytes = left;
            return;
        }
        char *msg_ptr = buffer + start;
        //process message
        int ret = ncpc_rx_process(ns, msg_ptr);
        if (0 != ret) {
            logit(EE, "process_recv_message() failed.");
            ncpc_conn_close(ns);
            return;
        }
        start += msg_size;
        left -= msg_size;
    }
    return;
}

//timer
static void ncpc_timer_callback(EV_P_ ev_timer *watcher, int revents)
{
    wh_notused(loop); wh_notused(revents);
    ncp_server *ns = (ncp_server *)watcher->data;

    if (ns->host_connected == 0) {
        int ret = ncpc_conn_new(ns);

        if (ret < 0) {
            logit(EE, "connection_new() failure.");
            sleep(3);
            return;
        }

        ncpc_rx_watcher.data = ns;
        ev_io_init(&ncpc_rx_watcher, ncpc_recv_callback, ncpc_fd, EV_READ);
        ev_io_start(EV_A_ &ncpc_rx_watcher);

        logit(II, "connect to host success");
        ns->host_connected = 1;

        char msg_buf[256];
        memset(msg_buf, 0, 256);
        GLTP_MSG_N_HEADER *issue_request_message = (GLTP_MSG_N_HEADER*)msg_buf;
        issue_request_message->length = sizeof(GLTP_MSG_N_HEADER) + CRC_SIZE;
        issue_request_message->type = GLTP_MSG_TYPE_NCP;
        issue_request_message->func = GLTP_N_GAME_ISSUE_REQ;
        issue_request_message->when = time(0);
        if (0 > ncpc_tx_process(ns, msg_buf)) {
            logit(EE, "send issue request message failure.");
            ncpc_conn_close(ns);
        }
        return;
    }

    //heartbeat check
    unsigned int now = time(NULL);
    if (last_heartbeat_rx != 0 && (now-last_heartbeat_rx > 15)) {
        logit(II, "heartbeat timeout");
        ncpc_conn_close(ns);
        return;
    }

    if (now-last_heartbeat_tx > 8) {
        //send heartbeat
        GLTP_MSG_N_HB *hb = (GLTP_MSG_N_HB *)wh_malloc(sizeof(GLTP_MSG_N_HB));
        hb->header.length = sizeof(GLTP_MSG_N_HB);
        hb->header.type = GLTP_MSG_TYPE_NCP;
        hb->header.func = GLTP_N_HB;
        hb->header.when = time(NULL);
        hb->termcnt = 0;
        hb->crc = 0;
        ncpc_notify(ns, 0, (char*)hb);
        last_heartbeat_tx = now;
    }
    return;
}

static void ncpc_async_callback(EV_P_ ev_async *watcher, int revents)
{
    wh_notused(loop); wh_notused(revents);
    ncp_server *ns = (ncp_server *)watcher->data;

    // obtained a message
    while (1) {
        tq_item *item = ns->msg_queue->dequeue(ns->msg_queue);
        if (NULL == item)
            break;

        if (ns->host_connected == 0) {
            wh_free(item->data);
            wh_free(item);
            continue;
        }

        if (0 > ncpc_tx_process(ns, item->data)) {
            logit(WW, "ncpc_tx_process process faliure.");
            ncpc_conn_close(ns);
        }
        wh_free(item->data);
        wh_free(item);
    }
}

static void *ncpc_client_loop(void *arg)
{
    ncp_server *ns = (ncp_server *)arg;
    loop = ev_loop_new(0);
    if (!loop) {
        logit(EE, "allocate loop fail.");
        return NULL;
    }

    //async
    ncpc_async_watcher.data = ns;
    ev_async_init(&ncpc_async_watcher, ncpc_async_callback);
    ev_async_start(EV_A_ &ncpc_async_watcher);

    //timer
    ncpc_timer_watcher.data = ns;
    ev_timer_init(&ncpc_timer_watcher, ncpc_timer_callback, 0., 1.);
    ev_timer_start(EV_A_ &ncpc_timer_watcher);

    ev_loop(loop, 0);
    return NULL;
}

void ncpc_notify(ncp_server *ns, int type, char *data)
{
    tq_item *item = (tq_item *)wh_malloc(sizeof(tq_item));
    item->type = type;
    item->data = data;
    ns->msg_queue->enqueue(ns->msg_queue, item);

    // send signal to worker thread to let it receive request
    ev_async_send(loop, &ncpc_async_watcher);
}

int ncpc_client_start(ncp_server *ns)
{
    pthread_t th;
    int ret = pthread_create(&th, NULL, ncpc_client_loop, (void *)ns);
    if (ret < 0) {
        logit(EE, "pthread create ncpc_client_loop thread fail.");
        return -1;
    }
    return 0;
}

