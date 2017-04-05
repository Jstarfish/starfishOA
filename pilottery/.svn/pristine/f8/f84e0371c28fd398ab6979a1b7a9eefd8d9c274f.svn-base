#include "global.h"
#include "gl_inf.h"

#include "protocol.h"
#include "3des.h"


#define MY_TASK_NAME "gl_rngserver\0"


static volatile int exit_signal_fired = 0;


#define MAX_MSG_SIZE             1024   // 消息最大长度
#define RECV_BUF_SIZE            16384  // 消息接收缓冲区长度
#define HEARTBEAT_TIME_INTERVAL  5      // 心跳间隔时间
#define HEARTBEAT_TIME_CLOSE     20     // 心跳丢失时间
#define DRAW_REQ_TIMEOUT         1      // 发送开奖请求，等待响应的超时时间


//RNG连接结构
typedef struct _RNG_CONN
{
    uint32     index;
    uint8      gameCode;                //游戏编码
    RNG_PARAM *rng_param;               //共享内存中的rng记录指针
    int        c_fd;                    //rng client socket
    char       ip[16];
    int        port;
    time_t     last_interaction;
    char       r_buf[RECV_BUF_SIZE];    //消息接收缓冲区
    int        r_offset;                //缓冲区偏移量
} RNG_CONN;

//游戏--期次数据状态码
typedef enum _DRAW_MSG_STATUS
{
    DRAW_MSG_DEFAULT        = 0,
    DRAW_MSG_WAIT_REQUEST   = 1,        //有期次需要请求开奖号码，等待发送
    DRAW_MSG_WAIT_RESPONSE  = 2,        //已为此期发送开奖请求，等待响应
} DRAW_REQ_STATUS;

//记录游戏--期次数据结构
typedef struct _RNG_GI_DATA
{
    uint8            game_code;         //游戏编码
    DRAW_REQ_STATUS  status;            //DRAW_REQ_STATUS
    uint64           issue_number;      //期号
    uint32           dc_msgid;          //请求开奖日志表中的消息编号
    RNG_CONN        *rng_ptr;           //请求的RNG
    time_t           req_time;          //发送开奖请求的时间
    pthread_mutex_t  mutex;
} RNG_GI_DATA;

//RNG Server数据结构
typedef struct _RNG_SERVER
{
    RNG_CONN     rng_conn[MAX_RNG_NUMBER];
    RNG_GI_DATA  gi_data[MAX_GAME_NUMBER];
    int          s_fd;                  // server listening socket
    pthread_t    issueScanThread;
}RNG_SERVER;


int conn_send_data(RNG_SERVER *rs, RNG_CONN *c, char *send_msg);
int conn_close(RNG_CONN *c);

//-------------------------------------------------------------------------------------------------

//随机选取一个可用的RNG发送开奖请求(cur_rng==NULL) 或者 找到一个除cur_rng之外的可用的RNG
RNG_CONN *get_other_rng(RNG_SERVER *rs, RNG_CONN *cur_rng)
{
    RNG_CONN *rng = NULL;

    int i;                           //counting index
    int j = rand() % MAX_RNG_NUMBER; //random offset
    int k;                           //actual index

    for (i = 0; i < MAX_RNG_NUMBER; i++)
    {
        k = (i + j) % MAX_RNG_NUMBER;
        rng = &(rs->rng_conn[k]);
        if (rng->rng_param->workStatus == RNG_AUTHENTICATED &&
            (cur_rng == NULL || rng->index != cur_rng->index))
        {
            return rng;
        }
    }
    return NULL;
}

//发送开奖请求
RNG_CONN *send_draw_request(RNG_SERVER *rs, RNG_CONN *cur_rng, uint8 game_code, uint64 issue_number)
{
    RNG_CONN *rng = get_other_rng(rs, cur_rng);
    if (rng == NULL)
    {
        log_warn("cannot find available rng");
        return NULL;
    }

    RNG_MSG_DRAW_REQ req;
    memset(&req, 0, sizeof(RNG_MSG_DRAW_REQ));
    req.header.len = sizeof(RNG_MSG_DRAW_REQ);
    req.header.type = RNG_MSG_TYPE_DRAW_REQ;
    req.header.deviceID = rng->rng_param->rngId;
    req.header.time = (uint32)time(NULL);
    req.header.param = 0;
    req.gameCode = game_code;
    req.issueNumber = issue_number;
    if (0 > conn_send_data(rs, rng, (char *)&req))
    {
        conn_close(rng);
        log_error("send_draw_request()  conn_send_data error. rng[ %s ]", rng->ip);
        return NULL;
    }
    log_debug("send_draw_request success. rng[%s] game[%d] issue_number[%lld]",
        rng->ip, game_code, issue_number);
    return rng;
}

// 期次开奖扫描线程
void *issue_draw_scan_thread(void *arg)
{
    RNG_SERVER *rs = (RNG_SERVER *)arg;

    GAME_DATA *game_data = NULL;
    GIDB_DRAWLOG_HANDLE *dl_handle = NULL;
    RNG_GI_DATA *gi_ptr = NULL;
    RNG_CONN *c = NULL;
    uint32 msgid = 0;
    uint64 issue_number = 0;
    int ret;

    log_info("issue_draw_scan_thread starts......");

    while (!exit_signal_fired)
    {
        //循环所有游戏
        for (int g = 0; g < MAX_GAME_NUMBER; g++)
        {
            //获得游戏记录
            game_data = gl_getGameData(g);
            if ( (game_data->used == false)
                  || (game_data->transctrlParam.drawType != INSTANT_GAME)
                  || (game_data->transctrlParam.autoDraw != 1)
                  || (game_data->gameEntry.gameType == GAME_TYPE_FINAL_ODDS) //进一步防止基础数据设置错误，导致drawlog表创建错误
                  || (game_data->gameEntry.gameType == GAME_TYPE_FIXED_ODDS)
            		)
                continue;

            gi_ptr = &rs->gi_data[g];
            pthread_mutex_lock(&gi_ptr->mutex);
            if (gi_ptr->status == DRAW_MSG_WAIT_REQUEST)
            {
                //内存中有已读取还没有发送的开奖请求
                c = send_draw_request(rs, NULL, gi_ptr->game_code, gi_ptr->issue_number);
                if (c == NULL)
                {
                    pthread_mutex_unlock(&gi_ptr->mutex);
                    log_warn("send_draw_request failure.");
                    continue;
                }
                gi_ptr->status = DRAW_MSG_WAIT_RESPONSE;
                gi_ptr->rng_ptr = c;
                gi_ptr->req_time = time(NULL);
                pthread_mutex_unlock(&gi_ptr->mutex);
                continue;
            }
            else if (gi_ptr->status == DRAW_MSG_WAIT_RESPONSE)
            {
                //内存中有已发送的开奖请求(还未收到响应)
                time_t now_t = time(NULL);

                //如果未超时，则跳过
                if ((now_t-gi_ptr->req_time) < DRAW_REQ_TIMEOUT)
                {
                    pthread_mutex_unlock(&gi_ptr->mutex);
                    continue;
                }

                conn_close(gi_ptr->rng_ptr);

                log_debug("no draw response in 1 sec for game [%d] on conn index [%d] of rngId [%d]",
                          g, gi_ptr->rng_ptr->index, gi_ptr->rng_ptr->rng_param->rngId);

                //如果已超时，则更换一个RNG重新发送开奖号码请求消息
                c = send_draw_request(rs, gi_ptr->rng_ptr, gi_ptr->game_code, gi_ptr->issue_number);
                if (c == NULL)
                {
                    gi_ptr->status = DRAW_MSG_WAIT_REQUEST;
                    gi_ptr->rng_ptr = NULL;
                    pthread_mutex_unlock(&gi_ptr->mutex);
                    log_warn("send_draw_request failure.");
                    continue;
                }
                gi_ptr->status = DRAW_MSG_WAIT_RESPONSE;
                gi_ptr->rng_ptr = c;
                gi_ptr->req_time = time(NULL);
                pthread_mutex_unlock(&gi_ptr->mutex);
                continue;
            }
            //当GI结构的状态为DRAW_MSG_DEFAULT时，离开锁区进入下面的代码
            pthread_mutex_unlock(&gi_ptr->mutex);

            dl_handle = gidb_drawlog_get_handle(g);
            if (dl_handle == NULL)
            {
                log_error("gidb_drawlog_get_handle() failed. game[%d]", g);
                break;
            }
            ret = dl_handle->gidb_drawlog_get_last_dc(dl_handle, &msgid, &issue_number);
            if (ret == 1)
            {
                //log_debug("drawlog database has no unconfirmed record in dc table game [%d]", g);
                continue; //dl表中如无未confirm的记录,则处理下一个游戏,这里要用continue
            }
            else if (ret < 0)
            {
                log_error("gidb_drawlog_get_last_dc() failed");
                break;
            }

            pthread_mutex_lock(&gi_ptr->mutex);
            gi_ptr->issue_number = issue_number;
            gi_ptr->dc_msgid = msgid;
            c = send_draw_request(rs, NULL, gi_ptr->game_code, gi_ptr->issue_number);
            if (c == NULL)
            {
                gi_ptr->status = DRAW_MSG_WAIT_REQUEST;
                gi_ptr->rng_ptr = NULL;
                pthread_mutex_unlock(&gi_ptr->mutex);
                log_warn("send_draw_request failure.");
                continue;
            }
            gi_ptr->status = DRAW_MSG_WAIT_RESPONSE;
            gi_ptr->rng_ptr = c;
            gi_ptr->req_time = time(NULL);
            pthread_mutex_unlock(&gi_ptr->mutex);

            log_info("Process DRAW REQUEST Message success. rng[ %s ]", c->ip);
        }
        ts_sleep(500*1000,0);
    }

    log_info("issue_draw_scan_thread exits......");

    return (void*)arg;
}

//-----------------------------------------------------------------------------------

int R_proc_auth_request_message(RNG_SERVER *rs, RNG_CONN *c, RNG_MESSAGE_HEADER *header)
{
    RNG_MSG_AUTH_REQ *msg = (RNG_MSG_AUTH_REQ *)header;
    ts_notused(msg);

    /* 在RNG连接时，已经过IP地址认证，这里的认证主要是证书的认证，目前保留，不再使用MAC地址认证
    ;
    */

    //设置rng workStatus
    gl_setRngWorkStatus(c->rng_param->rngId, RNG_AUTHENTICATED);
    //assert(c->rng_param->workStatus == RNG_AUTHENTICATED);
    log_info("RNG idx[%d] ip[%s] RNG_AUTHENTICATED real work status [%d]", c->index, c->ip,
             c->rng_param->workStatus);

    //response message
    RNG_MSG_AUTH_RSP msg_resp;
    memset(&msg_resp, 0, sizeof(RNG_MSG_AUTH_RSP));
    msg_resp.header.len = sizeof(RNG_MSG_AUTH_RSP);
    msg_resp.header.type = RNG_MSG_TYPE_AUTH_RSP;
    msg_resp.header.deviceID = c->rng_param->rngId;
    msg_resp.header.time = (uint32)time(NULL);
    msg_resp.header.param = 0;
    msg_resp.retcode = RNG_SUCCESS;
    if (0 > conn_send_data(rs, c, (char *)&msg_resp))
    {
        log_error("conn_send_data error. rng[ %s ]", c->ip);
        return -1;
    }

    log_info("Process AUTH Message success. rng[ %s ]", c->ip);
    return 0;
}

int R_proc_hb_message(RNG_SERVER *rs, RNG_CONN *c, RNG_MESSAGE_HEADER *header)
{
    ts_notused(header);

    //response message
    RNG_MSG_HB msg_resp;
    memset(&msg_resp, 0, sizeof(RNG_MSG_HB));
    msg_resp.header.len = sizeof(RNG_MSG_HB);
    msg_resp.header.type = RNG_MSG_TYPE_HB;
    msg_resp.header.deviceID = c->rng_param->rngId;
    msg_resp.header.time = (uint32)time(NULL);
    msg_resp.header.param = 0;
    if ( 0 > conn_send_data(rs, c, (char *)&msg_resp))
    {
        log_error("conn_send_data error. rng[ %s ]", c->ip);
        return -1;
    }

    //log_info("Process HB Message success. rng[ %s ]", c->ip);
    return 0;
}

char *drawCode_to_string(char *buffer, const unsigned char *drawCode, int length,
                         const char *delimiter)
{
    int i = 0;
    int str_len = 0;
    buffer[0] = '\0';
    for (i = 0; i<length-1; i++) {
        // make sure the printBuf is big enough
        str_len += sprintf(buffer+str_len, "%d%s", (unsigned int)drawCode[i], delimiter);
    }
    if (0!=length) {
        str_len += sprintf(buffer+str_len, "%d", (unsigned int)drawCode[i]);
    }

    return buffer;
}

int R_proc_draw_response_message(RNG_SERVER *rs, RNG_CONN *c, RNG_MESSAGE_HEADER *header)
{
    RNG_MSG_DRAW_RSP *msg = (RNG_MSG_DRAW_RSP *)header;

    RNG_GI_DATA *gi_ptr = &rs->gi_data[msg->gameCode];
    pthread_mutex_lock(&gi_ptr->mutex);
    if ((gi_ptr->issue_number == msg->issueNumber) &&
        (msg->retcode == RNG_SUCCESS) &&
        (gi_ptr->status == DRAW_MSG_WAIT_RESPONSE) &&
        (gi_ptr->rng_ptr == c))
    {
        //此响应消息为有效的响应消息
        INM_MSG_ISSUE_DRAWNUM_INPUTE draw_msg;
        memset(&draw_msg, 0, sizeof(INM_MSG_ISSUE_DRAWNUM_INPUTE));
        draw_msg.header.length = sizeof(INM_MSG_ISSUE_DRAWNUM_INPUTE);
        draw_msg.header.type = INM_TYPE_ISSUE_STATE_DRAWNUM_INPUTED;
        draw_msg.header.when = (uint32)time(NULL);
        draw_msg.header.status = SYS_RESULT_SUCCESS;
        draw_msg.gameCode = msg->gameCode;
        draw_msg.issueNumber = msg->issueNumber;
        draw_msg.drawTimes = GAME_DRAW_ONE;
        draw_msg.count = msg->resultLen;
        memcpy(draw_msg.drawCodes, msg->result, msg->resultLen);
        drawCode_to_string(draw_msg.drawCodesStr, draw_msg.drawCodes, draw_msg.count, ",");
        draw_msg.timeStamp = (uint32)time(NULL);

        GIDB_DRAWLOG_HANDLE *dl_handle = gidb_drawlog_get_handle(msg->gameCode);
        if (dl_handle == NULL)
        {
            pthread_mutex_unlock(&gi_ptr->mutex);
            log_error("gidb_drawlog_get_handle() failed. game[%d]", msg->gameCode);
            return -1;
        }
        int ret = dl_handle->gidb_drawlog_append_dl(dl_handle, msg->issueNumber, INM_TYPE_ISSUE_STATE_DRAWNUM_INPUTED,
            (char *)&draw_msg, draw_msg.header.length);
        if (ret < 0)
        {
            pthread_mutex_unlock(&gi_ptr->mutex);
            log_error("gidb_drawlog_append_dl() failed. game[%d] issue_number[%lld]", msg->gameCode, msg->issueNumber);
            return -1;
        }
        ret = dl_handle->gidb_drawlog_confirm_dc(dl_handle, gi_ptr->dc_msgid);
        if (ret < 0)
        {
            pthread_mutex_unlock(&gi_ptr->mutex);
            log_error("gidb_drawlog_confirm_dc() failed. game[%d] issue_number[%lld] msgid[%d]", msg->gameCode, msg->issueNumber, gi_ptr->dc_msgid);
            return -1;
        }
        gi_ptr->status = DRAW_MSG_DEFAULT;
        gi_ptr->issue_number = 0;
        gi_ptr->dc_msgid = 0;
        gi_ptr->rng_ptr = 0;
        gi_ptr->req_time = 0;
    }
    else
    {
        pthread_mutex_unlock(&gi_ptr->mutex);
        log_error("incorrect draw rsp retcode [%hhu]", msg->retcode);
        return -1;
    }
    pthread_mutex_unlock(&gi_ptr->mutex);

    log_info("Process DRAW RESPONSE Message success. rng[ %s ]", c->ip);
    return 0;
}

int process_recv_message(RNG_SERVER *rs, RNG_CONN *c, char *msg_buf)
{
    int ret = 0;
    // decrypt message
    char buf[MAX_MSG_SIZE];
    memset(buf, 0, sizeof(buf));
    if (dec_3des(msg_buf, buf) < 0)
    {
        log_error("dec_3des failure. ip->%s : %d ", c->ip, c->port);
        return -1;
    }

    RNG_MESSAGE_HEADER *header = (RNG_MESSAGE_HEADER *)buf;
    // check crc
    uint16 crcmsg = *(uint16 *)(buf+header->len-2);
    uint16 crccal = calc_crc(buf, header->len-2);
    if (crcmsg != crccal)
    {
        log_error("CRC calc error. received crc %hu calced crc %hu. ip[%s : %d] DeviceId[%d]",
                  crcmsg, crccal, c->ip, c->port, header->deviceID);
        return -1;
    }

    if (header->deviceID != c->rng_param->rngId)
    {
        log_error("Device ID error: shared memory [%u] message [%hhu]", c->rng_param->rngId,
                  header->deviceID);
        return -1;
    }

    if (c->rng_param->status != ENABLED)
    {
        log_error("RNG is disabled: deviceID [%hhu] status [%hhu]", header->deviceID,
                  c->rng_param->status);
        return -1;
    }

    if (header->type == RNG_MSG_TYPE_AUTH_REQ)
    {
        ret = R_proc_auth_request_message(rs, c, header);
    }
    else if (header->type == RNG_MSG_TYPE_HB)
    {
        ret = R_proc_hb_message(rs, c, header);
    }
    else if (header->type == RNG_MSG_TYPE_DRAW_RSP)
    {
        ret = R_proc_draw_response_message(rs, c, header);
    }
    else
    {
        log_error("Message Type error. ip[%s : %d] MsgType[%d]", c->ip, c->port, header->type);
        return -1;
    }

    if (ret < 0)
        return -1;

    c->last_interaction = time(NULL);
    return 0;
}

int conn_recv_data(RNG_SERVER *rs, RNG_CONN *c)
{
    int ret = 0;

    while (sizeof(c->r_buf)-c->r_offset > 0) {
        ret = recv(c->c_fd, c->r_buf+c->r_offset, sizeof(c->r_buf)-c->r_offset, 0);
        if (ret < 0) {
            if (errno == EINTR) {
                continue;
            } else if (EAGAIN == errno || EWOULDBLOCK == errno) {
                break;
            } else {
                // shutdown terminal
                log_notice("recv() failed. Reason [%s].", strerror(errno));
                return -1;
            }
        } else if (0 == ret) {
            log_notice("the peer has performed an orderly shutdown. Reason [%s].", strerror(errno));
            return -1;
        } else {
            c->r_offset += ret;
        }
    }

    int start = 0;
    int left = c->r_offset;
    char *buffer = c->r_buf;
    while (true) {
        if ((unsigned int)left < sizeof(unsigned short)) {
            if ( 0 != start && 0 != left) {
                memmove(buffer, buffer + start, left);
            }
            c->r_offset = left;
            return 0;
        }

        int msg_size = *((unsigned short *)(buffer + start));
        if (msg_size > left) {
            if (0 != start && 0 != left) {
                memmove(buffer, buffer + start, left);
            }
            c->r_offset = left;
            return 0;
        }

        int ret = process_recv_message(rs, c, buffer + start);
        if (0 != ret) {
            log_warn("process_recv_message() failed.");
            return -1;
        }

        start += msg_size;
        left -= msg_size;
    }
    return 0;
}

int conn_send_data(RNG_SERVER *rs, RNG_CONN *c, char *send_msg)
{
    ts_notused(rs);

    //添加CRC
    int msg_len = *(unsigned short *)send_msg;
    unsigned short *crc_ptr = (unsigned short *)(send_msg + msg_len - 2);
    *crc_ptr = calc_crc(send_msg, msg_len-2);

    //3DES加密
    char buf[MAX_MSG_SIZE] = {0};
    if (enc_3des(send_msg, buf) < 0)
    {
        log_error("enc_3des failure. ip->%s:%d ", c->ip, c->port);
        return -1;
    }

    ssize_t ns;
    unsigned char *p = (unsigned char *)buf;
    size_t left = *(unsigned short *)buf;

    //发送消息
    while (left > 0)
    {
        ns = send(c->c_fd, p, left, 0);
        if (ns < 0)
        {
            if (errno == EINTR)
                continue;
            else
            {
                log_error("send failed [%s] ip[%s]", strerror(errno), c->ip);
                return -1;
            }
        }
        else
        {
            p += ns;
            left -= ns;
        }
    }
    return 0;
}

int conn_close(RNG_CONN *c)
{
    gl_setRngWorkStatus(c->rng_param->rngId, RNG_UNCONNECTED);
    //assert(c->rng_param->workStatus == RNG_UNCONNECTED);

    log_info("conn_close: RNG idx[%d] ip[%s] mac[%02hhx:%02hhx:%02hhx:%02hhx:%02hhx:%02hhx] workStatus[%d]",
             c->index, c->rng_param->rngIp,
             c->rng_param->rngMac[0], c->rng_param->rngMac[1], c->rng_param->rngMac[2],
             c->rng_param->rngMac[3], c->rng_param->rngMac[4], c->rng_param->rngMac[5],
             c->rng_param->workStatus);

    close(c->c_fd);
    c->r_offset = 0;
    return 0;
}

int rs_init(RNG_SERVER *rs)
{
    uint32 idx = 0;
    RNG_PARAM *rng_param = NULL;
    for (idx = 0; idx < MAX_RNG_NUMBER; idx++)
    {
        rng_param = gl_getRngData() + idx;

        rng_param->workStatus = RNG_UNCONNECTED;

        rs->rng_conn[idx].index = idx;
        rs->rng_conn[idx].gameCode = rng_param->gameCode;
        rs->rng_conn[idx].rng_param = rng_param;
        rs->rng_conn[idx].c_fd = -1;
        memcpy(rs->rng_conn[idx].ip, rng_param->rngIp, sizeof(rng_param->rngIp));
        rs->rng_conn[idx].port = 0;
        rs->rng_conn[idx].last_interaction = (time_t)0;
        memset(rs->rng_conn[idx].r_buf, 0, sizeof(rs->rng_conn[idx].r_buf));
        rs->rng_conn[idx].r_offset = 0;

        log_debug("[%d] rng_param used[%d] gameCode[%d] rngid[%d] ip[%s] name[%s] workStatus[%d]",
                  idx, rng_param->used, rng_param->gameCode, rng_param->rngId, rng_param->rngIp,
                  rng_param->rngName, rng_param->workStatus);
    }

    RNG_GI_DATA *gi_data_ptr = NULL;
    for (int g = 0; g < MAX_GAME_NUMBER; g++) {
        gi_data_ptr = &rs->gi_data[g];
        gi_data_ptr->game_code = g;
        gi_data_ptr->status = DRAW_MSG_DEFAULT;
        gi_data_ptr->issue_number = 0;
        gi_data_ptr->dc_msgid = 0;
        gi_data_ptr->rng_ptr = NULL;
        gi_data_ptr->req_time = 0;
        if (pthread_mutex_init(&gi_data_ptr->mutex, NULL)) {
            log_error("pthread_mutex_init failure");
            return -1;
        }
    }
    return 0;
}


// 创建监听socket
int rs_socket_init(RNG_SERVER *rs)
{
    log_info("socket_init");

    rs->s_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (rs->s_fd == -1)
    {
        log_error("socket");
        return -1;
    }

    int on = 1;
    if (setsockopt(rs->s_fd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(int)) == -1)
    {
        log_error("setsockopt");
        return -1;
    }

    struct sockaddr_in local_addr;
    memset(&local_addr, 0, sizeof(local_addr));
    int port = sysdb_getRngPort();
    local_addr.sin_family = AF_INET;
    local_addr.sin_addr.s_addr = INADDR_ANY;
    local_addr.sin_port = htons(port);
    if (bind(rs->s_fd, (const struct sockaddr *)(&local_addr), sizeof(local_addr)) == -1)
    {
        log_error("bind");
        return -1;
    }

    if (listen(rs->s_fd, SOMAXCONN) == -1)
    {
        log_error("listen");
        return -1;
    }

    log_info("socket listen port: %d", port);
    return 0;
}

//socket 事件循环
int rs_socket_loop(RNG_SERVER *rs)
{
    int client_sock_fd;
    fd_set local_read_fd_set;

    struct timeval time_out;

    struct sockaddr_in sa;
    socklen_t salen = sizeof(sa);
    while (!exit_signal_fired)
    {
        FD_ZERO(&local_read_fd_set); // clear the fd set
        FD_SET(rs->s_fd, &local_read_fd_set); // add the listening socket to the fd set

        int max_fd = rs->s_fd;

        // for each used RNG in shared memory that is not unconnected, add its socket to the fd set
        RNG_CONN *rng = NULL;
        for (int i = 0; i < MAX_RNG_NUMBER; i++)
        {
            rng = &(rs->rng_conn[i]);
            if (rng->rng_param->used && rng->rng_param->workStatus != RNG_UNCONNECTED)
            {
                FD_SET(rng->c_fd, &local_read_fd_set);
            }
            if (rng->c_fd > max_fd)
                max_fd = rng->c_fd;
        }
        max_fd += 1;

        // select
        time_out.tv_sec = 1;
        time_out.tv_usec = 0;
        int fd_num = select(max_fd, &local_read_fd_set, NULL, NULL, &time_out);
        if (fd_num < 0)
        {
            if (errno == EINTR)
            {
                continue;
            }
            else
            {
                perror("select() error");
                return -1;
            }
        }
        else if (fd_num == 0)
        {
            continue;
        }

        // the listening socket is selected
        if (FD_ISSET(rs->s_fd, &local_read_fd_set))
        {
            client_sock_fd = accept(rs->s_fd, (struct sockaddr*)&sa, &salen);
            if (client_sock_fd == -1)
            {
                if (errno == EINTR)
                {
                    continue;
                }
                else
                {
                    perror("accept error.");
                    return -1;
                }
            }

            //校验IP地址
            int find = 0;
            char c_ip[32] = {0};
            strcpy(c_ip, inet_ntoa(sa.sin_addr));

            log_debug("c_ip [%s]", c_ip);

            // checking the accepting socket's ip address is from one of the available RNG in
            // shared memory
            for (int rng_idx = 0; rng_idx < MAX_RNG_NUMBER; rng_idx++)
            {
                rng = &(rs->rng_conn[rng_idx]);

                if (rng->rng_param->used &&
                    rng->rng_param->status == ENABLED &&
                    0 == strcmp(rng->rng_param->rngIp, c_ip))
                {
                    //校验成功
                    log_debug("coming device is found in RNG shared memory index[%d]", rng_idx);
                    find = 1;
                    break;
                }
            }
            if (0 == find) // the coming socket's ip does not exist in shared memory
            {
                close(client_sock_fd);
                log_debug("Has abnormal rng connect. ip[ %s ]", c_ip);
            }
            else
            {
                //set non blocking
                //has to set nonblock due to the receive function
                int opts;

                opts = fcntl(client_sock_fd, F_GETFL);
                if (opts < 0)
                {
                    log_error("fcntl(client_sock_fd,GETFL) failed. Reason [%s].", strerror(errno));
                    return -1;
                }

                opts = opts | O_NONBLOCK;
                if (fcntl(client_sock_fd, F_SETFL, opts) < 0)
                {
                    log_error("fcntl(sock,SETFL,opts), failed. Reason [%s].", strerror(errno));
                    return -1;
                }

                //set tcp no delay
                int on = 1;
                if (setsockopt(client_sock_fd, IPPROTO_TCP, TCP_NODELAY, &on, sizeof(on)) == -1)
                {
                    perror("setsockopt TCP_NODELAY error");
                    return -1;
                }

                // rng now points to the corresponding rng device info
                rng->c_fd = client_sock_fd;
                rng->port = ntohs(sa.sin_port);
                rng->last_interaction = time(NULL);
                rng->r_offset = 0;

                log_info("RNG idx[%d] ip[%s] current work status [%d]",
                         rng->index, rng->ip, rng->rng_param->workStatus);

                gl_setRngWorkStatus(rng->rng_param->rngId, RNG_CONNECTED);
                //assert(rng->rng_param->workStatus == RNG_CONNECTED);
                log_info("RNG idx[%d] ip[%s] RNG_CONNECTED real work status [%d]",
                         rng->index, rng->ip, rng->rng_param->workStatus);

                log_info("Accept rng connect->[%d][%s:%d] game[%d] fd[%d]",
                         rng->index, c_ip, rng->port, rng->gameCode, rng->c_fd);
            }
        }

        // scan all rng
        time_t now_t = time(NULL);
        for (int i = 0; i < MAX_RNG_NUMBER; i++)
        {
            rng = &(rs->rng_conn[i]);
            // the current rng is in at a valid status
            if (rng->rng_param->used && rng->rng_param->workStatus != RNG_UNCONNECTED)
            {
                if (FD_ISSET(rng->c_fd, &local_read_fd_set))
                {
                    //recv message
                    if (0 > conn_recv_data(rs, rng) )
                    {
                        //close socket
                        conn_close(rng);
                    }
                }

                if ((now_t - rng->last_interaction) > HEARTBEAT_TIME_CLOSE)
                {
                    //close socket
                    log_debug("rng socket timeout, close socket. %s", rng->ip);
                    conn_close(rng);
                    continue;
                }
            }
        }
    }
    close(rs->s_fd);
    return 0;
}

static void signal_handler(int signo)
{
    ts_notused(signo);
    exit_signal_fired = 1;
    return;
}

static int init_signal(void)
{
    struct sigaction sas;
    memset(&sas, 0, sizeof(sas));
    sas.sa_handler = signal_handler;
    sigemptyset(&sas.sa_mask);
    sas.sa_flags |= SA_INTERRUPT;

    if (sigaction(SIGINT, &sas, NULL) == -1)
    {
        log_error("sigaction(SIGINT) failed. Reason: %s", strerror(errno));
        return -1;
    }

    if (sigaction(SIGTERM, &sas, NULL) == -1)
    {
        log_error("sigaction(SIGTERM) failed. Reason: %s", strerror(errno));
        return -1;
    }

    signal(SIGPIPE, SIG_IGN);

    return 0;
}

int main(int argc, char *argv[])
{
    ts_notused(argc);
    ts_notused(argv);
    srand(time(NULL));

    int ret = 0;

    logger_init(MY_TASK_NAME);

    ret = init_signal();
    if (0 != ret)
    {
        log_error("init_signal() failed.");
        return -1;
    }

    log_info("%s start", MY_TASK_NAME);

    if (!sysdb_init())
    {
        log_error("%s sysdb_init error.", MY_TASK_NAME);
        return -1;
    }

    if (!bq_init())
    {
        log_error("%s bq_init error.", MY_TASK_NAME);
        sysdb_close();
        return -1;
    }

    if (!gl_init())
    {
        sysdb_close();
        bq_close();
        log_error("%s gl_init() error.", MY_TASK_NAME);
        return -1;
    }

    // init socket server
    RNG_SERVER rng_server;
    ret = rs_init(&rng_server);
    if (0 > ret)
    {
        log_error("rs_init() failed.");
        return -1;
    }

    ret = rs_socket_init(&rng_server);
    if (0 > ret)
    {
        log_error("rs_socket_init() failed.");
        return -1;
    }

    //create issue scan thread
    ret = pthread_create(&rng_server.issueScanThread, NULL, issue_draw_scan_thread, &rng_server);
    if (0 != ret)
    {
        log_error("pthread_create( issueScanThread ) failed. Reason [%s].", strerror(ret));
        return -1;
    }

    sysdb_setTaskStatus(SYS_TASK_RNG_SERVER, SYS_TASK_STATUS_RUN);

    log_info("%s init success", MY_TASK_NAME);

    while (0 == exit_signal_fired)
    {
        ret = rs_socket_loop(&rng_server);
        if (0 > ret)
        {
            log_error("rs_socket_loop() failed.");
            break;
        }
    }

    sysdb_setTaskStatus(SYS_TASK_RNG_SERVER, SYS_TASK_STATUS_EXIT);

    gl_close();
    bq_close();
    sysdb_close();

    log_info("%s exit\n", MY_TASK_NAME);
    return 0;
}

