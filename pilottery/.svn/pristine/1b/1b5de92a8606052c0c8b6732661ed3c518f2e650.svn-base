#ifndef NCP_SERVER_H
#define NCP_SERVER_H


typedef struct _ncp_server
{
    int log_level;

    int port;

    //工作线程数量
    int worker_thread_count;
    work_thread *worker_threads;

    //--- tcp ---
    int listenfd;
    //事件watcher
    struct ev_io watcher;

    //loop
    struct ev_loop* loop;

    ts_queue *msg_queue;

    char host_ip[32];
    int host_port;
    int host_connected;

    int heartbeat_interval;
    int keepalive_time;

    cache_mgr *ccmgr; //cache mgr
} ncp_server;
work_thread *get_worker(ncp_server* ns, uint32 identify);

#endif //NCP_SERVER_H

