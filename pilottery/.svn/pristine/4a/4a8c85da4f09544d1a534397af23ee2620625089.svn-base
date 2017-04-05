#include "global.h"


#define SERVER_IP ("192.168.20.234")
#define SERVER_PORT 20000

int *p_int_array = NULL;

char ip[16];
int port;
int connect_num;
int cycle_num;

int exitt = false;


void mysleep(int usec)
{
    struct timeval t_timeval;
    t_timeval.tv_sec = 0;
    t_timeval.tv_usec = usec;
    select(0, NULL, NULL, NULL, &t_timeval);
}


void *test_thread(void *arg)
{
    int thread_idx = *(int *)arg;

    int sockfd;
    if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) == -1)
    {
        fprintf(stderr, "socket error!\n");
        fflush(stdout);
        return NULL;
    }

    struct sockaddr_in serv_addr;
    memset(&serv_addr,0,sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(port);
    serv_addr.sin_addr.s_addr = inet_addr(ip);

    if (connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(struct sockaddr)) == -1)
    {
        fprintf(stderr, "connect error!\n");
        fflush(stdout);
        return NULL;
    }

    int ret = 0;
    char buf[1024];
    int buf_offset = 0;
    //int len = 64;
    int cnt = 0;
    while (1)
    {
        buf_offset = 0;

        if ((cycle_num > 0) && (cnt>=cycle_num))
            break;

        memset(buf, 0, 1024);
        GLTP_MSG_N_ECHO_REQ *echo_req = (GLTP_MSG_N_ECHO_REQ *)buf;
        echo_req->header.type = GLTP_MSG_TYPE_NCP;
        echo_req->header.func = GLTP_N_ECHO_REQ;
        echo_req->header.when = time(NULL);
        sprintf(echo_req->echo_str, "abcdefghijklmnopqrstuvwxyz1234567890");
        echo_req->echo_len = strlen(echo_req->echo_str);
        echo_req->header.length = sizeof(GLTP_MSG_N_ECHO_REQ) + strlen(echo_req->echo_str) + 2;

        printf("Tx  -> length[%d] type[%d] func[%d]\n%s\n", echo_req->header.length, echo_req->header.type, echo_req->header.func, echo_req->echo_str);

        ret = send(sockfd, buf, echo_req->header.length,0);
        if (ret <=0)
        {
            fprintf(stderr, "send fail!\n");
            fflush(stdout);
            //return 0;
        }

        while (1)
        {
            ret = recv(sockfd, buf+buf_offset, 1024-buf_offset, 0);
            if (ret < 0)
            {
                if (errno == EINTR)
                {
                    continue;
                }
                else if (EAGAIN == errno || EWOULDBLOCK == errno)
                {
                    break;
                }
                else
                {
                    fprintf(stderr, "read error! %s\n", strerror(errno));
                    fflush(stdout);
                    return 0;
                }
            }
            else if (0 == ret)
            {
                fprintf(stderr, "the peer has performed an orderly shutdown. Reason [%s].", strerror(errno));
                fflush(stdout);
                return 0;
            }
            else
            {
                buf_offset += ret;

                if (buf_offset == *(unsigned short *)buf)
                    break;
            }
        }
        GLTP_MSG_N_ECHO_RSP *echo_rsp = (GLTP_MSG_N_ECHO_RSP *)buf;
        if ( buf_offset != echo_rsp->header.length)
        {
            fprintf(stderr, "length error. rx length[%d]!\n", buf_offset);
            fflush(stdout);
            return 0;
        }
        buf[echo_rsp->header.length-2] = '\0';

        printf("Rx  -> length[%d] type[%d] func[%d]\n%s\n", echo_rsp->header.length, echo_rsp->header.type, echo_rsp->header.func, echo_rsp->echo_str);

        cnt++;
        *(p_int_array + thread_idx) = *(p_int_array + thread_idx) + 1;
    }

    close(sockfd);
    return NULL;
}

// ./ncpc_test 127.0.0.1 20000 2 100
int main(int argc, char *argv[])
{
    ts_notused(argc);

    sprintf(ip, "%s", "127.0.0.1");
    port = 20000;
    connect_num = 10;
    cycle_num = 1;

    strcpy(ip, argv[1]);
    port = atoi(argv[2]);
    connect_num = atoi(argv[3]);
    cycle_num = atoi(argv[4]);

    p_int_array = (int *)malloc(sizeof(int)*connect_num);
    int ret = 0;
    int i=0;
    pthread_t th;
    for (i=0; i<connect_num; i++)
    {
        int *k = (int *)malloc(sizeof(int));
        *k = i;
        ret = pthread_create(&th, NULL, test_thread, k);
        if(ret!=0)
        {
            fprintf(stderr, "create failure. [%d]\n", i);
            fflush(stdout);
            return -1;
        }
    }

    float speed;
    time_t start = time(NULL);
    while (!exitt)
    {
        sleep(1);

        int64 sum = 0;
        for (i=0; i<connect_num; i++)
        {
            sum += *(p_int_array + i);
        }

        time_t end = time(NULL);
        if (end == start)
            speed = 0.0;
        else
            speed = sum / (end - start);
        printf("thread_count[%d] count[%lld] speed: %.2f /sec\n", connect_num, sum, speed);
        fflush(stdout);

        if (sum == cycle_num*connect_num)
            break;
    }

    return 0;
}

