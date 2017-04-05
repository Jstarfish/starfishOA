#include <unistd.h>
#include <time.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <errno.h>
#include <signal.h>
#include <poll.h>

#include <iostream>
using namespace std;

#include "3des.h"
#include "crc16.h"
#include "protocol.h"

#define TIME_INTERVAL 3

typedef struct _RNG {
    RNG_STATUS status;
    bool doRequest;
} RNG;

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
            fprintf(stderr, "[%s][%s:%d]->"fmt"\n", get_time_format(buf), \
                    __FUNCTION__, __LINE__, ##__VA_ARGS__); \
    } while (0)


static RNG rng = { RNG_UNCONNECTED, false };


void alarm_handler(int sig)
{
    (void)sig;
    rng.doRequest = true;
    signal(SIGALRM, alarm_handler);
}

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


int main(void)
{
    int servsock, clisock, ret;
    struct sockaddr_in servaddr, connaddr;
    socklen_t socklen;

    srand(time(NULL));

    servsock = socket(AF_INET, SOCK_STREAM, 0);

    int yes = 1;
    setsockopt(servsock, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes));

    memset(&servaddr, 0, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(1573);
    inet_aton("192.168.26.173", &servaddr.sin_addr);

    bind(servsock, (const struct sockaddr *)&servaddr, sizeof(servaddr));

    ret = listen(servsock, SOMAXCONN);
    if (ret >= 0) {
        log("listen on 192.168.26.173:1573");
    }

    rng.status = RNG_UNCONNECTED;

    log("rng status == UNCONNECTED");

    signal(SIGALRM, alarm_handler);
    signal(SIGPIPE, SIG_IGN);

    unsigned char buf1[1024];
    unsigned char buf2[1024];
    unsigned char buf3[1024];
    unsigned char buf4[1024];
    struct timeval tv = {0, 500*1000};
    while (true) {
        switch (rng.status) {
        case RNG_UNCONNECTED:
        {
            memset(&connaddr, 0, sizeof(connaddr));
            connaddr.sin_family = AF_INET;
            socklen = sizeof(connaddr);
            log("waiting for new socket connection");
            clisock = accept(servsock, (struct sockaddr *)&connaddr, &socklen);
            if (clisock >= 0) {
                log("accept() success");
                log("peer connection from %s:%hu", inet_ntoa(connaddr.sin_addr),
                    ntohs(connaddr.sin_port));
            }
            rng.status = RNG_CONNECTED;
            log("rng status == CONNECTED");
            break;
        }
        case RNG_CONNECTED:
        {
            memset(buf3, 0, sizeof(buf3));
            ret = recv_msg(clisock, buf3);
            if (ret < 0) {
                log("recv_msg() failed. close socket.");
                close(clisock);
                rng.status = RNG_UNCONNECTED;
                break;
            }
            // decrypt message
            memset(buf1, 0, sizeof(buf1));
            dec_3des((char *)buf3, (char *)buf1);
            log("recv message decrypted");
            RNG_MESSAGE_HEADER *hdr = (RNG_MESSAGE_HEADER *)buf1;
            // check crc
            uint16 crcmsg = *(uint16 *)(buf1+hdr->len-2);
            uint16 crccal = calc_crc(hdr, hdr->len-2);
            if (crcmsg != crccal) {
                log("crc inconsistent. received crc %hu calced crc %hu", crcmsg,
                    crccal);
                exit(1);
            } else {
                log("received crc %hu calced crc %hu", crcmsg, crccal);
            }
            if (hdr->type == RNG_MSG_TYPE_AUTH_REQ) {
                memset(buf2, 0, sizeof(buf2));
                RNG_MSG_AUTH_RSP *g = 
                         (RNG_MSG_AUTH_RSP *)buf2;
                g->header.len = sizeof(RNG_MSG_AUTH_RSP);
                g->header.type = RNG_MSG_TYPE_AUTH_RSP;
                g->header.deviceID = 1;
                g->header.time = (uint32)time(NULL);
                g->header.param = 0;
                g->retcode = RNG_SUCCESS;
                g->crc = calc_crc(g, g->header.len-2);
                log("sending authentication request");
                memset(buf4, 0, sizeof(buf4));
                enc_3des((char *)buf2, (char *)buf4);
                log("sent message encrypted");
                ret = send_msg(clisock, buf4);
                if (ret < 0) {
                    log("send_msg() failed. close socket.");
                    close(clisock);
                    rng.status = RNG_UNCONNECTED;
                }
                rng.status = RNG_AUTHENTICATED;
                log("rng status == AUTHENTICATED");
                alarm(TIME_INTERVAL);
            } else {
                log("unknown type [%hhu]", hdr->type);
            }
            break;
        }
        case RNG_AUTHENTICATED:
        {
            if (rng.doRequest) {
                memset(buf1, 0, sizeof(buf1));
                RNG_MSG_DRAW_REQ *g = (RNG_MSG_DRAW_REQ *)buf1;
                g->header.len = sizeof(RNG_MSG_DRAW_REQ);
                g->header.type = RNG_MSG_TYPE_DRAW_REQ;
                g->header.deviceID = 1;
                g->header.time = (uint32)time(NULL);
                g->header.param = 0;
                int r = rand() % 5;
                if (r == 0) g->gameCode = 1;
                else if (r == 1) g->gameCode = 2;
                else if (r == 2) g->gameCode = 5;
                else if (r == 3) g->gameCode = 13;
                else if (r == 4) g->gameCode = 14;
                g->issueNumber = 20140001;
                g->crc = calc_crc(g, g->header.len-2);

                // encrypt message
                memset(buf3, 0, sizeof(buf3));
                enc_3des((char *)buf1, (char *)buf3);
                log("send message encryted");

                log("sending draw number request (%hhu)", g->gameCode);
                ret = send_msg(clisock, buf3);
                if (ret < 0) {
                    log("send_msg() failed. close socket.");
                    close(clisock);
                    rng.status = RNG_UNCONNECTED;
                }
                rng.doRequest = false;
            }
            memset(buf2, 0, sizeof(buf2));
            ret = recv_msg_timed(clisock, buf2, &tv);
            if (ret < 0) {
                log("recv timed failed. close socket.");
                close(clisock);
                rng.status = RNG_UNCONNECTED;
            } else if (ret == 0) {
                // decrypt message
                memset(buf4, 0, sizeof(buf4));
                dec_3des((char *)buf2, (char *)buf4);
                log("recv message decryted");

                RNG_MESSAGE_HEADER *hdr = (RNG_MESSAGE_HEADER *)buf4;

                uint16 crcmsg = *(uint16 *)(buf4+hdr->len-2);
                uint16 crccal = calc_crc(hdr, hdr->len-2);
                if (crcmsg != crccal) {
                    log("message length %hu", hdr->len);
                    log("crc inconsistent. received crc %hu calced crc %hu", 
                        crcmsg, crccal);
                    exit(1);
                }

                if (hdr->type == RNG_MSG_TYPE_DRAW_RSP) {
                    log("draw response received! Reset alarm.");

                    RNG_MSG_DRAW_RSP *rsp = (RNG_MSG_DRAW_RSP *)buf4;
                    if (rsp->retcode != RNG_SUCCESS) {
                        printf("request retcode not successful g (%hhu) rc (%hhu)\n", rsp->gameCode, rsp->retcode);
                    }
                    else {
                        printf("(%hhu) ", rsp->gameCode);
                        for (int i = 0; i < rsp->resultLen; i++) {
                           printf("%02hhu ", rsp->result[i]);
                        }
                        cout << endl;
                    }
                    alarm(TIME_INTERVAL);
                } else if (hdr->type == RNG_MSG_TYPE_HB) {
                    log("HB received");

                    memset(buf1, 0, sizeof(buf1));
                    RNG_MSG_HB *g = (RNG_MSG_HB *)buf1;
                    g->header.len = sizeof(RNG_MSG_HB);
                    g->header.type = RNG_MSG_TYPE_HB;
                    g->header.deviceID = 1;
                    g->header.time = (uint32)time(NULL);
                    g->header.param = 0;
                    g->crc = calc_crc(g, g->header.len-2);

                    // encrypt message
                    memset(buf3, 0, sizeof(buf3));
                    enc_3des((char *)buf1, (char *)buf3);
                    log("send message encryted");

                    log("sending HB");
                    ret = send_msg(clisock, buf3);
                    if (ret < 0) {
                        log("send_msg() failed");
                        close(clisock);
                        rng.status = RNG_UNCONNECTED;
                    }

                } else {
                    log("unknown type [%hhx]", hdr->type);
                }
            } else { // time out
                //log("timeout");
            }

            break;
        }
        default:
            log("unknown status [%d]", rng.status);
            break;
        }
    }

    return 0;
}
































