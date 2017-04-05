#include <unistd.h>
#include <time.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <pthread.h>
#include <errno.h>
#include <signal.h>
#include <poll.h>

#include "3des.h"
#include "crc16.h"
#include "protocol.h"

#define HB_INTERVAL 5


static RNG_STATUS g_status = RNG_UNCONNECTED;
bool sendHB = false;


void alarm_handler(int sig)
{
    (void)sig;
    sendHB = true;
    signal(SIGALRM, alarm_handler);
}

char *get_time_format(char *time_string)
{
    struct timeval tv;
    struct tm ptm;

    gettimeofday(&tv, NULL); 
    localtime_r(&tv.tv_sec, &ptm);
    sprintf(time_string, "%02d:%02d:%02d.%06ld", 
            ptm.tm_hour, ptm.tm_min, ptm.tm_sec, (long)(tv.tv_usec));

    return time_string;
}

#define log(fmt, ...) \
    do { \
            char buf[96]; \
            fprintf(stderr, "[DBG][%s][%s:%d]->"fmt"\n", get_time_format(buf), \
                    __FUNCTION__, __LINE__, ##__VA_ARGS__); \
    } while (0)

int recv_msg(int fd, void *buf)
{
    ssize_t nr;
    unsigned char *p = (unsigned char *)buf;
    size_t msg_size;

    nr = recv(fd, p, 2, 0);
    if (nr < 0) {
        log("get msg size failure [%s]", strerror(errno));
        return -1;
    } else if (nr == 0) {
        log("get msg size failure. peer orderly shutdown");
        return -1;
    } else if (nr != 2) {
        log("get msg size failure. recv bytes != 2");
        return -1;
    }

    msg_size = *(unsigned short *)p;
    msg_size -= 2;
    p += 2;

    while (msg_size > 0) {
        nr = recv(fd, p, msg_size, 0);
        if (nr < 0) {
            if (errno == EINTR) continue;
            else {
                log("recv failed [%s]", strerror(errno));
                return -1;
            }
        } else if (nr == 0) {
            log("recv failed. peer orderly shutdown");
            return -1;
        } else {
            p += nr;
            msg_size -= nr;
        }
    }

    return 0;
}

int recv_msg_timed(int fd, void *buf, struct timeval *tv)
{
    int ret;
    struct pollfd fds;

    if (!tv) return recv_msg(fd, buf);

REDO_RECV:

    fds.fd = fd;
    fds.events = POLLIN;
    ret = poll(&fds, 1, tv->tv_sec*1000 + (tv->tv_usec/1000));
    if (ret < 0) {
        if (errno == EINTR) goto REDO_RECV;
        log("poll error [%s]", strerror(errno));
        return -1;
    } else if (ret == 0) {
        //log("poll timeout");
        return 1;
    } else {
        return recv_msg(fd, buf);
    }
}

int send_msg(int fd, void *buf)
{
    ssize_t ns;
    unsigned char *p = (unsigned char *)buf;
    size_t left = *(unsigned short *)buf;

    while (left > 0) {
        ns = send(fd, p, left, 0);
        if (ns < 0) {
            if (errno == EINTR) continue;
            else {
                log("send failed [%s]", strerror(errno));
                return -1;
            }
        } else {
            p += ns;
            left -= ns;
        }
    }

    return 0;
}

int main() {
    int sock, ret;
    struct sockaddr_in addr;

    g_status = RNG_UNCONNECTED;

    log("rng status == UNCONNECTED");

    signal(SIGALRM, alarm_handler);
    signal(SIGPIPE, SIG_IGN);

    unsigned char buf1[1024];
    unsigned char buf2[1024];
    struct timeval tv = {0, 500*1000};
    while (true) {
        switch (g_status) {
        case RNG_UNCONNECTED:
        {
            if ((sock = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
                log("socket() failed [%s]", strerror(errno));
                return -1;
            }

            int yes = 1;
            setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes));

            memset(&addr, 0, sizeof(addr));
            addr.sin_family = AF_INET;
            addr.sin_port = htons(1573);
            if (inet_aton("192.168.26.173", &addr.sin_addr) == 0) {
                log("invalid address");
                return -1;
            }

            while (connect(sock, (const struct sockaddr *)&addr, sizeof(addr)) 
                   < 0) {
                log("connect() failed [%s]", strerror(errno));
                sleep(3);
            }
            g_status = RNG_CONNECTED;
            break;
        }
        case RNG_CONNECTED:
        {
            memset(buf1, 0, sizeof(buf1));
            RNG_MSG_AUTH_REQ *g = (RNG_MSG_AUTH_REQ *)buf1;
            g->header.len = sizeof(RNG_MSG_AUTH_REQ);
            g->header.type = RNG_MSG_TYPE_AUTH_REQ;
            g->header.deviceID = 0;
            g->header.param = 0;
            g->mac[0] = 0x00;
            g->mac[1] = 0x50;
            g->mac[2] = 0x56;
            g->mac[3] = 0xbc;
            g->mac[4] = 0xbd;
            g->mac[5] = 0x91;
            g->crc = 32765;
            ret = send_msg(sock, buf1);
            if (ret < 0) {
                log("send_msg() failed. close socket.");
                close(sock);
                g_status = RNG_UNCONNECTED;
                break;
            }
            log("authentication request is sent");
            memset(buf2, 0, sizeof(buf2));
            ret = recv_msg(sock, buf2);
            if (ret < 0) {
                log("recv_msg() failed. close socket.");
                close(sock);
                g_status = RNG_UNCONNECTED;
                break;
            } else {
                RNG_MSG_AUTH_RSP *h = (RNG_MSG_AUTH_RSP *)buf2;
                if (h->retcode != RNG_SUCCESS) {
                    log("auth rsp retcode unsuccess. close socket.");
                    close(sock);
                    g_status = RNG_UNCONNECTED;
                }
                g_status = RNG_AUTHENTICATED;
                log("RNG STATUS == AUTHENTICATED");
                alarm(HB_INTERVAL);
            }
            break;
        }
        case RNG_AUTHENTICATED:
        {
            if (sendHB) {
                sendHB = false;
                memset(buf1, 0, sizeof(buf1));
                RNG_MSG_HB *g = (RNG_MSG_HB *)buf1;
                g->header.len = sizeof(RNG_MSG_HB);
                g->header.type = RNG_MSG_TYPE_HB;
                g->header.deviceID = 0;
                g->header.param = 0;
                g->crc = 12345;
                log("sending HB");
                ret = send_msg(sock, buf1);
                if (ret < 0) {
                    log("send_msg() failed. close socket.");
                    close(sock);
                    g_status = RNG_UNCONNECTED;
                }
            }
            memset(buf2, 0, sizeof(buf2));
            ret = recv_msg_timed(sock, buf2, &tv);
            if (ret < 0) {
                log("recv timed failed. close socket.");
                close(sock);
                g_status = RNG_UNCONNECTED;
            } else if (ret == 0) {
                uint8 type = *(uint8 *)&buf2[2];
                if (type == RNG_MSG_TYPE_DRAW_REQ) {
                    memset(buf1, 0, sizeof(buf1));
                    RNG_MSG_DRAW_RSP *h = (RNG_MSG_DRAW_RSP *)buf1;
                    h->header.len = sizeof(RNG_MSG_DRAW_RSP);
                    h->header.type = RNG_MSG_TYPE_DRAW_RSP;
                    h->header.deviceID = 0;
                    h->header.param = 0;
                    h->gameCode = 5;
                    h->issueNumber = 20140001;
                    h->retcode = RNG_SUCCESS;
                    h->resultLen = 5;
                    h->result[0] = 1;
                    h->result[1] = 2;
                    h->result[2] = 3;
                    h->result[3] = 4;
                    h->result[4] = 5;
                    uint16 *crc = (uint16 *)&(h->result[5]);
                    *crc = 32265;
                    log("sending draw number response");
                    ret = send_msg(sock, buf1);
                    if (ret < 0) {
                        log("send_msg() failed. close socket.");
                        close(sock);
                        g_status = RNG_UNCONNECTED;
                    }
                } else if (type == RNG_MSG_TYPE_HB) {
                    log("heartbeat received");
                    alarm(HB_INTERVAL);
                } else {
                    log("unknown type [%hhx]", type);
                }
            } else {
                // time out
            }

            break;
        }
        default:
            break;
        }
    }

    return 0;
}



































