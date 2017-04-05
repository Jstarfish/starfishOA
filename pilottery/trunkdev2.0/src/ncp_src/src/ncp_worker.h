#ifndef WORK_THREAD_H
#define WORK_THREAD_H

struct _conn_item;
struct _work_thread;
struct _ncp_server;

typedef struct _tq_item {
    struct _tq_item *next; // for queue

    int type; // 1: new connection  2: data  3: close socket  4: close all socket
    uint32 identify;
    struct _conn_item *c;
    char *data;
}tq_item;

typedef struct _ts_queue ts_queue;
struct _ts_queue {
    int (*init)(ts_queue *q);
    void (*enqueue)(ts_queue *q, tq_item *item);
    tq_item *(*dequeue)(ts_queue *q);
    tq_item *(*dequeue_timeout)(ts_queue *q, int timeout_msec);
    int (*get_size)(ts_queue *q);
    tq_item *head;
    tq_item *tail;
    int size;
    pthread_mutex_t mutex;
    pthread_cond_t cond;
};
ts_queue *ts_queue_create();


// Describe every connection
typedef struct _conn_item
{
    int cfd;     // the socket fd of the connection
    unsigned int identify;
    char m_ip[16];
    int m_port;

    uint64 terminalCode; //终端机编码
    uint64 agencyCode;   //站点编码
    uint16 areaCode; //省编码

    char *rbuf;
    int rsize;   //recv buffer size
    int rbytes;  //current receive data length

    ev_io *watcher;
    struct _work_thread *thread;

    int close_socket;

    time_t last_update;

    struct _conn_item *next;
} conn_item;

conn_item *conn_new(int cfd, char *ip, int port);
void conn_close(conn_item *c);


typedef struct _work_thread
{
    int idx;

    struct _ncp_server *ns;

    ts_queue *que;

    map<uint32, conn_item*> socket_map;

    //线程id
    pthread_t          th_id;
    //事件循环
    struct ev_loop*    loop;
    //异步事件watcher
    struct ev_async    async_watcher;
    //timer
    struct ev_timer    timer_watcher;
} work_thread;

int worker_init(struct _ncp_server *ns);
void worker_notify(work_thread *worker, int type, uint32 identify, conn_item* c, char *data);

#define MSG_HLEN (4)

#endif

