#include "ncp.h"
#include "cache_mgr.h"
#include "ncp_worker.h"
#include "ncp_server.h"
#include "ncp_ncpc.h"


static ncp_server *ns = NULL;
static bool daemonize_g = false;
static char pidfile_g[512] = {0};


#define CONF_FILE_PATH  ("/ts_ncp/conf/ncp.conf")
static int load_conf(ncp_server *ns)
{
    FILE *fin;
    char buf[4096];
    char *ptok;
    int i, c, ret;

    ret = access(CONF_FILE_PATH, R_OK);
    if (ret != 0) {
        fprintf(stderr, "access(%s, R_OK) failed! Reason: [%s].\n", CONF_FILE_PATH, strerror(errno));
        return -1;
    }
    // load configuration file into the buffer
    // open the file
    fin = fopen(CONF_FILE_PATH, "r");
    if (fin == NULL) {
        fprintf(stderr, "fopen [%s] failed.\n", CONF_FILE_PATH);
        return -1;
    }
    // move everything into the buffer
    for (i = 0; i < 4096 && (c = fgetc(fin)) != EOF; i++)
        buf[i] = c;
    // check for overflow
    if (i == 4096) {
        fprintf(stderr, "input file too large, increase buffer size.\n");
        return -1;
    }
    // take care of null-delimiter
    if (c == EOF)
        buf[i] = '\0';

    // parse the buffer
    ptok = strtok(buf, " \t\r\n=");
    while (ptok != NULL) {
        if (strcmp(ptok, "log_level") == 0) {
            ptok = strtok(NULL, " \t\r\n=");
            ns->log_level = atoi(ptok);
        } else if (strcmp(ptok, "tcp_port") == 0) {
            ptok = strtok(NULL, " \t\r\n=");
            ns->port = atoi(ptok);
        } else if (strcmp(ptok, "ncpc_ip") == 0) {
            ptok = strtok(NULL, " \t\r\n=");
            strncpy(ns->host_ip, ptok, sizeof(ns->host_ip));
        } else if (strcmp(ptok, "ncpc_port") == 0) {
            ptok = strtok(NULL, " \t\r\n=");
            ns->host_port = atoi(ptok);
        } else if (strcmp(ptok, "worker_count") == 0) {
            ptok = strtok(NULL, " \t\r\n=");
            ns->worker_thread_count = atoi(ptok);
        } else if (strcmp(ptok, "keepalive_time") == 0) {
            ptok = strtok(NULL, " \t\r\n=");
            ns->keepalive_time = atoi(ptok);
        } else {
            fprintf(stderr, "unknow node <%s> in [%s].\n", ptok, CONF_FILE_PATH);
            return -1;
        }
        ptok = strtok(NULL, " \t\r\n="); // advance to the next token
    }

    printf("\nNCP Configure Info  ---------------------------------------\n");
    printf("log_level [%d]\n", ns->log_level);
    printf("tcp port [%d]\n", ns->port);
    printf("ncpc_ip  [%s], ncpc_port [%d]\n", ns->host_ip, ns->host_port);
    printf("worker_count [%d]\n", ns->worker_thread_count);
    printf("keepalive_time [%d]\n\n", ns->keepalive_time);
    return 0;
}

work_thread *get_worker(ncp_server* ns, uint32 identify)
{
    int index = identify % ns->worker_thread_count;
    return &ns->worker_threads[index];
}

//有请求时的回调
static void accept_callback(struct ev_loop *loop, ev_io *watcher, int revents)
{
    wh_notused(loop); wh_notused(revents);
    ncp_server *ns = (ncp_server *)watcher->data;
    struct sockaddr_in sin;
    socklen_t addrlen = sizeof(struct sockaddr);
    int accept_fd = accept(watcher->fd, (struct sockaddr *)&sin, &addrlen);
    while (accept_fd < 0) {
        if (errno == EINTR || errno == EAGAIN || errno == EWOULDBLOCK)
            continue;
        else
            logit(EE, "accept fd[%d] fail.", watcher->fd);
    }
    set_non_block(accept_fd);

    if (ns->host_connected == 0) {
        close(accept_fd);
        return;
    }

    conn_item *c = conn_new(accept_fd, (char *)inet_ntoa(sin.sin_addr), sin.sin_port);
    work_thread *worker = get_worker(ns, c->identify);
    c->thread = worker;
    logit(II, "Accept one connection.  fd[%d] ip[%s] port[%d].", c->cfd, c->m_ip, c->m_port);
    worker_notify(worker, 1, c->identify, c, NULL);
}

#if 0
//定时器
static void timer_callback(EV_P_ ev_timer *watcher, int revents)
{
    wh_notused(loop); wh_notused(revents);
    ncp_server* ns = (ncp_server*)watcher->data;
    conn_item* c = NULL;
    //process connection close
    while(1) {
        tq_item* item = ns->free_que->dequeue(ns->free_que);
        if(item == NULL)
            break;
        c = item->c;
        map<uint32, conn_item*>::iterator iter = ns->conn_map.find(c->identify);
        if(iter != ns->conn_map.end()) {
            ns->conn_map.erase(iter);
        }
        conn_close(c);
        wh_free(item);
    }
}
#endif

static int ns_init_socket(ncp_server *ns)
{
    int ret;
    //tcp server
    if ((ns->listenfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        logit(EE, "init socket fail. errno [%d]", ns->listenfd);
        return -1;
    }
    int flag = 1;
    //keepalive
    setsockopt(ns->listenfd, SOL_SOCKET, SO_KEEPALIVE, &flag, sizeof(flag));
    //reuse
    setsockopt(ns->listenfd, SOL_SOCKET, SO_REUSEADDR, &flag, sizeof(flag));
    set_non_block(ns->listenfd);

    struct sockaddr_in serveraddr;
    memset(&serveraddr, 0, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    serveraddr.sin_port = htons(ns->port);
    serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
    if ((ret = bind(ns->listenfd, (struct sockaddr*)&serveraddr, sizeof(serveraddr))) < 0) {
        logit(EE, "bind fail. errno [%d]", ret);
        return -1;
    }
    if ((ret = listen(ns->listenfd, 5)) < 0) {
        logit(EE, "listen fail. error [%d]", ret);
        return -1;
    }
    return 0;
}

static int ns_create(ncp_server *ns)
{
    //create message queue
    ns->msg_queue = ts_queue_create();
    if (ns->msg_queue == NULL) {
        logit(EE, "ts_queue_create(msg_queue) fail.");
        return -1;
    }

    //create connect host thread
    if (0 > ncpc_client_start(ns)) {
        logit(EE, "ncpc_client_start fail.");
        return -1;
    }

    //init ncp server
    if (0 > ns_init_socket(ns)) {
        logit(EE, "ns_init_socket() fail.");
        return -1;
    }

    //init worker
    if (0 > worker_init(ns)) {
        logit(EE, "worker_init() fail.");
        return -1;
    }

    ns->loop = ev_default_loop(0);
    return 0;
}


static void ns_start(ncp_server *ns)
{
    ns->watcher.data = ns;

    // monitor server-side IO read event
    ev_io_init(&ns->watcher, accept_callback, ns->listenfd, EV_READ);
    // start watcher
    ev_io_start(ns->loop, &ns->watcher);

    ev_loop(ns->loop, 0);
}


static void usage(void)
{
    fprintf(stderr, "Usage: ncp_server [--daemonize] [--pidfile filename]");
    exit(1);
    return;
}

static void parse_opts(int argc, char **argv)
{
    for (int i = 1; i < argc; i++) {
        if (0 == strcmp(argv[i], "--daemonize")) {
            daemonize_g = true;
        } else if (0 == strcmp(argv[i], "--pidfile")) {
            if (i + 1 < argc) {
                strncpy(pidfile_g, argv[i+1], sizeof(pidfile_g));
                i++;
            } else {
                usage();
            }
        } else {
            usage();
        }
    }
    return ;
}

static bool ncp_daemonize(void)
{
    fflush(NULL);
    switch (fork()) {
        case -1:
            return false;
        case 0:
            break;
        default:
            _exit(0);
    }
    if (setsid() == -1) {
        return false;
    }
    switch (fork()) {
        case -1:
            return false;
        case 0:
            break;
        default:
            _exit(0);
    }
    umask(0);
    close(0);
    close(1);
    close(2);
    int fd = open("/dev/null", O_RDWR, 0);
    if (fd != -1) {
        dup2(fd, 0);
        dup2(fd, 1);
        dup2(fd, 2);
        if (fd > 2) {
            close(fd);
        }
    }
    return true;
}

static void signal_handler(int signo)
{
    (void) signo;
    ev_break (ns->loop, EVBREAK_ALL);
    return;
}

static int init_signal(void)
{
    struct sigaction sas;
    memset(&sas, 0, sizeof(sas));
    sas.sa_handler = signal_handler;
    sigemptyset(&sas.sa_mask);
    sas.sa_flags |= SA_INTERRUPT;
    if (sigaction(SIGINT, &sas, NULL) == -1) {
        logit(EE, "sigaction(SIGINT) failed. Reason: %s", strerror(errno));
        return -1;
    }
    if (sigaction(SIGTERM, &sas, NULL) == -1) {
        logit(EE, "sigaction(SIGTERM) failed. Reason: %s", strerror(errno));
        return -1;
    }
    signal(SIGPIPE, SIG_IGN);
    return 0;
}


/*
解决服务器产生大量close_wait问题
 
要解决这个问题的可以修改系统的参数(/etc/sysctl.conf文件)，系统默认超时时间的是7200秒，也就是2小时。
默认如下：
tcp_keepalive_time = 7200 seconds (2 hours)
tcp_keepalive_probes = 9
tcp_keepalive_intvl = 75 seconds

意思是如果某个TCP连接在idle 2个小时后,内核才发起probe.如果probe 9次(每次75秒)不成功,内核才彻底放弃,认为该连接已失效

修改后

sysctl -w net.ipv4.tcp_keepalive_time=30
sysctl -w net.ipv4.tcp_keepalive_probes=2
sysctl -w net.ipv4.tcp_keepalive_intvl=2

经过这个修改后，服务器会在短时间里回收没有关闭的tcp连接


#让TIME_WAIT尽快回收，观察大概是一秒钟
echo "1" > /proc/sys/net/ipv4/tcp_tw_recycle

net.ipv4.tcp_tw_recycle = 1
*/

int main(int argc, char *argv[])
{
    parse_opts(argc, argv);

    //daemonize
    if (daemonize_g) {
        if (!ncp_daemonize()) {
            logit(EE,"ncp_daemonize() failed. Reason [%s].", strerror(errno));
            return 1;
        }
    }
    //write the process id into file '/ts_ncp/logs/ncp_server.pid'
    if ('\0' != pidfile_g[0]) {
        FILE *f = fopen(pidfile_g, "w+");
        if (NULL == f) {
            logit(EE,"fopen([%s]) failed. Reason [%s].", pidfile_g, strerror(errno));
            return 1;
        }
        fprintf(f, "%ld", (long)getpid());
        fclose(f);
    }

    cache_mgr *ccmgr = (cache_mgr*)wh_malloc(sizeof(cache_mgr));
    new(ccmgr)_cache_mgr();

    ns = (ncp_server *)wh_malloc(sizeof(ncp_server));
    memset(ns, 0, sizeof(ncp_server));
    new(ns)_ncp_server();
    ns->ccmgr = ccmgr;

    if (init_signal() != 0) {
        logit(EE,"init_signal() failed.");
        return 1;
    }

    //load config file
    if (0 > load_conf(ns)) {
        logit(EE, "load_conf() failure.");
        return -1;
    }

    if (logger_init("ncp_server", ns->log_level) != 0) {
        logit(EE,"logger_init() failed.");
        return 1;
    }

    logit(II, "ncp server start ----");

    ns_create(ns);
    ns_start(ns);
    return 0;
}


