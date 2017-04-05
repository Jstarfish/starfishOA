#include "global.h"
#include "ncpc_inf.h"
#include "tms_inf.h"
#include "ncpc_http_parse.h"
#include "ncpc_http_kvdb.h"
#include "ncpc_net.h"
#include "ncpc_message.h"


int http_callback_body(http_parser* parser, const char *at, size_t length)
{
    //for http post method
    ncpc_client *c = (ncpc_client *)parser->data;
    c->http_message = (char *)realloc(c->http_message, length+1);
    strncpy(c->http_message, at, length);
    c->http_message_len = length;
    c->http_message[c->http_message_len] = 0;
    //log_debug("http message ->%s",c->http_message);
    return 0;
}
int http_callback_url(http_parser* parser, const char *at, size_t length)
{
    ncpc_client *c = (ncpc_client *)parser->data;
    struct http_parser_url u;
    if(0 == http_parser_parse_url(at, length, 0, &u)) {
        if(u.field_set & (1 << UF_PATH)) {
            c->http_url = (char*)realloc(c->http_url, u.field_data[UF_PATH].len+1);  
            strncpy(c->http_url, at+u.field_data[UF_PATH].off, u.field_data[UF_PATH].len);  
            c->http_url[u.field_data[UF_PATH].len] = 0;
            //log_debug("c->http_url   %s", c->http_url);
        }
        if(u.field_set & (1 << UF_HOST)) {
            c->http_host = (char *)realloc(c->http_host, u.field_data[UF_HOST].len+1);
            strncpy(c->http_host, at+u.field_data[UF_HOST].off, u.field_data[UF_HOST].len);  
            c->http_host[u.field_data[UF_HOST].len] = 0;
            //log_debug("c->http_host   %s", c->http_host);
        }
    }
    return 0;
}
int http_callback_message_complete(http_parser* parser)
{
    ncpc_client *c = (ncpc_client *)parser->data;
    if (parser->method==HTTP_GET) c->http_method = 0;
    else c->http_method = 1;
    c->http_complete = 1;
    return 0;
}

ncpc_client::ncpc_client(NCPC_SERVER *_ns, int _identify, int _flag)
{
    ns = _ns; identify = _identify; flag = _flag;
    connected = 0; cfd = 0; r_buf_offset = 0; last_update = 0;
    if (flag == FLAG_HTTP) {
        //http parse setting
        parser.data = this; http_parser_init(&parser, HTTP_REQUEST);
        parser_settings.on_message_complete = http_callback_message_complete;
        parser_settings.on_url = http_callback_url;
        parser_settings.on_body = http_callback_body;
        http_url = NULL; http_host = NULL; http_message = NULL; http_message_len = 0; http_complete = 0;
    }
}
ncpc_client::~ncpc_client()
{
    if (flag == FLAG_HTTP) {
        if (http_url) free(http_url);
        if (http_host) free(http_host);
        if (http_message) free(http_message);
    }
}
int ncpc_client::connect(int _cfd, char* _ip, int _port)
{
    cfd = _cfd; strcpy(ip, _ip); port = _port;
    last_update = time(0); connected = 1; r_buf_offset = 0;
    if (flag == FLAG_HTTP) {
        http_parser_init(&parser, HTTP_REQUEST);
        http_url = NULL; http_host = NULL; http_message = NULL; http_message_len = 0; http_complete = 0;
        log_notice("accept new http connection [%s : %d]", ip, port);
    } else {
        log_debug("accept new connection [%s : %d]", ip, port);
    }
    return 0;
}
int ncpc_client::pre_disconnect()
{
    connected = 2;
    return 0;
}
int ncpc_client::disconnect()
{
    if (flag == FLAG_HTTP)
        log_notice("close one http connection [%s : %d]",ip,port);
    else
        log_debug("close one tcp connection [%s : %d]",ip,port);
    close(cfd); cfd = 0; ip[0] = 0; r_buf_offset = 0; connected = 0;
    if (flag == FLAG_TCP)
        ncpc_setConnectStatus(identify, false);
    return 0;
}
int ncpc_client::read_message()
{
    int ret = 0;
    while (MAX_BUFFER-r_buf_offset > 0) {
        ret = recv(cfd, r_buf+r_buf_offset, MAX_BUFFER-r_buf_offset, 0);
        if (ret < 0) {
            if (errno == EINTR) {
                continue;
            } else if (EAGAIN == errno || EWOULDBLOCK == errno) {
                break;
            } else {
                // shutdown terminal
                log_notice("recv() failed. Reason [%s].", strerror(errno));
                disconnect();
                return -1;
            }
        } else if (0 == ret) {
            log_notice("the peer has performed an orderly shutdown. Reason [%s].", strerror(errno));
            disconnect();
            return -1;
        } else {
            r_buf_offset += ret;
        }
    }
    last_update = time(0);
    int start = 0; int left = r_buf_offset; char *buffer = r_buf;
    while (true) {
        if ((unsigned int)left < sizeof(unsigned short)) {
            if (0 != start && 0 != left) {
                memmove(buffer, buffer + start, left);
            }
            r_buf_offset = left;
            return 0;
        }
        int msg_size = *((unsigned short *)(buffer + start));
        if (msg_size > left) {
            if (0 != start && 0 != left) {
                memmove(buffer, buffer + start, left);
            }
            r_buf_offset = left;
            return 0;
        }

        ncpc_dump_package(buffer+start, ip, port, 0);

        //send messsage to worker queue ------------------
        char *gmsg = (char*)malloc(msg_size);
        memcpy(gmsg, buffer+start, msg_size);
        mque_item *item = (mque_item*)malloc(sizeof(mque_item));
        item->ptr = gmsg; item->param1 = identify; item->param2 = FLAG_TCP;
        ns->wque->enqueue(ns->wque, item);
        //------------------------------------------------

        start += msg_size;
        left -= msg_size;
    }
    return 0;
}
void ncpc_client::send_message(char *s_buf, int s_buf_len)
{
    int nwritten = 0;
    while (nwritten < s_buf_len) {
        int r = send(cfd, s_buf+nwritten, s_buf_len-nwritten, 0);
        if ( r < 0 && ( errno == EINTR || errno == EAGAIN ) ) { usleep(1*1000); continue; }
        if ( r < 0 ) { log_notice("send error"); pre_disconnect(); return; }
        if ( r == 0 ) break;
        nwritten += r;
    }

    ncpc_dump_package(s_buf, ip, port, 1);
    return;
}

int ncpc_client::read_http_message()
{
    int len = recv(cfd, r_buf+r_buf_offset, MAX_BUFFER-r_buf_offset,0);
    if (len < 0) {
        log_notice("recv error.");
        disconnect(); return 0;
    } else if (len == 0) {
        log_notice("the peer has performed an orderly shutdown. Reason [%s].", strerror(errno));
        disconnect(); return 0;
    }
    //logit(TT, "Rx data  [%s : %d] %s", ip, port, r_buf+r_buf_len);

    //http parse
    int parsed = http_parser_execute(&parser, &parser_settings, r_buf+r_buf_offset, len);
    if (parsed != len) {
        log_warn("http parse error. parsed[%d] len[%d] c->r_buf_len[%d] buf[%s]", parsed, len, r_buf_offset, r_buf);
        disconnect();
        return 0;
    }
    r_buf_offset += len;
    //printf("--- %u - %s\n", HTTP_PARSER_ERRNO(&parser), http_errno_name(HTTP_PARSER_ERRNO(&parser)));
    //printf("--- %u - %s\n", HTTP_PARSER_ERRNO(&parser), http_errno_description(HTTP_PARSER_ERRNO(&parser)));

    if (strcasecmp(http_url, "/do")!=0) {
        log_warn("404 not found.");
        disconnect();
        return 0;
    }
    last_update = time(0);

    if (http_complete == 1) {
        r_buf[r_buf_offset] = 0;

        ncpc_dump_http_package(http_message, ip, port, 0);

        //send json messsage to worker queue ------------------
        char *jmsg = http_message; http_message = NULL; http_message_len = 0;
        mque_item *item = (mque_item*)malloc(sizeof(mque_item));
        item->ptr = jmsg; item->param1 = identify; item->param2 = FLAG_HTTP;
        ns->wque->enqueue(ns->wque, item);
        //-----------------------------------------------------
        return 0;
    }
    return 0;
}
void ncpc_client::send_http_message(char *s_buf, int s_buf_len)
{
    const char *http_response = "HTTP/1.1 200 OK\r\nServer: taishan lottery system\r\nContent-Type: text/html;charset=utf-8\r\nContent-Length: %d\r\n\r\n%s";
    char buf[MAX_BUFFER]; int len;
    len = sprintf(buf, http_response, s_buf_len, s_buf);
    int nwritten = 0;
    while (nwritten < len) {
        int r = send(cfd, buf+nwritten, len-nwritten, 0);
        if ( r < 0 && ( errno == EINTR || errno == EAGAIN ) ) { usleep(1*1000); continue; }
        if ( r < 0 ) { log_notice("send error"); pre_disconnect(); return; }
        if ( r == 0 ) break;
        nwritten += r;
    }

    ncpc_dump_http_package(s_buf, ip, port, 1);
    return;
}

int NCPC_SERVER::init()
{
    m_exit = 0;
    for(int i=0;i<MAX_CLIENT;i++)
        m_clients[i] = new ncpc_client(this, i, FLAG_TCP);
    for(int i=0;i<MAX_HTTP_CLIENT;i++)
        m_http_clients[i] = new ncpc_client(this, i, FLAG_HTTP);
    wque = mque_create();

    m_listen_port = sysdb_getNcpPort();
    m_http_listen_port = sysdb_getNcpHttpPort();

    //init bqnet fid
    fid_ncpc_send = getFidByName("ncpsend_queue");
    fid_ncpc_http_send = getFidByName("ncpsend_http_queue");
    fid_tfe_adder = getFidByName("tfe_adder");
    fid_gl_driver = getFidByName("gl_driver");
    fid_gl_fbs_driver = getFidByName("gl_fbs_driver");

    //init kvdb
    char db_path[256];
    ts_get_kvdb_filepath(db_path, 256);
    kvdb = new KVDB(db_path);
    return 0;
}

ncpc_client* NCPC_SERVER::get_connection(int idx)
{
    if (idx < 0 || idx >= MAX_CLIENT)
        return NULL;
    ncpc_client *c = m_clients[idx];
    if (c->connected == 1)
        return c;
    return NULL;
}
ncpc_client* NCPC_SERVER::get_http_connection(int idx)
{
    if (idx < 0 || idx >= MAX_HTTP_CLIENT)
        return NULL;
    ncpc_client *c = m_http_clients[idx];
    if (c->connected == 1)
        return c;
    return NULL;
}

int NCPC_SERVER::init_socket(int flag)
{
    int sfd, port;
    if (flag == 0) port = m_listen_port;
    else port = m_http_listen_port;
        
    sfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sfd < 0) {
        log_error("socket() failed. Reason [%s].", strerror(errno));
        return -1;
    }
    int optint = 1;
    setsockopt(sfd, SOL_SOCKET, SO_REUSEADDR, (char *)&optint, sizeof(optint));
    optint = fcntl(sfd, F_GETFL); optint |= O_NONBLOCK; fcntl(sfd, F_SETFL, optint);

    struct sockaddr_in server_addr;
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    server_addr.sin_port = htons(port);
    if (bind(sfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        log_error("bind( port [%d] ) failed. Reason [%s].", port, strerror(errno));
        return -1;
	}
    if (listen(sfd, 511) == -1) {
        log_error("listen() failed. Reason [%s].", strerror(errno));
        return -1;
    }
    if (flag == 0)
        log_info("ncpc net listen_port:[%d] ",port);
    else
        log_info("ncpc http net listen_port:[%d] ",port);
    return sfd;
}

void NCPC_SERVER::process_send_message(char *inm_buf)
{
    int ret = 0;
    INM_MSG_HEADER *inm_header = (INM_MSG_HEADER *)inm_buf;

    DUMP_INMMSG(inm_buf);

    if (inm_header->gltp_type == GLTP_MSG_TYPE_TERMINAL_UNS) {
        ret = ncpc_process_Send_terminal_uns_message(this, inm_buf);
        if (ret < 0) {
            log_warn("ncpc_process_Send_terminal_uns_message() process failed.");
        }
        return;
    }

    ncpc_client *c = get_connection(inm_header->socket_idx);
    if (c == NULL) {
        log_debug("process_send_message() unavailable connection idx[%d].", inm_header->socket_idx);
        return;
    }
    if (inm_header->gltp_type == GLTP_MSG_TYPE_NCP) {
        ret = ncpc_process_Send_ncp_message(this, c, inm_buf);
        if (ret < 0) {
            log_warn("ncpc_process_Send_ncp_message() process failed.");
        }
    } else if (inm_header->gltp_type == GLTP_MSG_TYPE_TERMINAL) {
        ret = ncpc_process_Send_terminal_message(this, c, inm_buf);
        if (ret < 0) {
            log_warn("ncpc_process_Send_terminal_message() process failed.");
        }
    } else {
        log_error("process_send_message() failed. unknown inm message gltp type[%d], inm type [%d]", 
                  inm_header->gltp_type, inm_header->type);
        return;
    }
    ncpc_updSendPkgNumber(c->identify);
    return;
}

int NCPC_SERVER::tx_start()
{
    char inm_buf[INM_MSG_BUFFER_LENGTH];
    int32 len = 0;
    FID fid = getFidByName("ncpsend_queue");
    if (fid < 0) {
        log_error("getFidByName( ncpsend_queue ) failure.");
        return -1;
    }
    if (!bq_register(fid, "ncpsend_queue", getpid())) {
        log_error("bq_register( ncpsend_queue ) return failure.");
        return -1;
    }
    while (!m_exit) {
        len = bq_recv(fid, inm_buf, sizeof(inm_buf), 500);
        if( len < 0 ) {
            log_error("ncpc server tx_start(), bq_recv return error.");
            break;
        } else if (len == 0) {
            continue; //timeout
        }
        process_send_message(inm_buf);
    }
    log_notice("ncpc send thread exit.");
    return 0;
}



int NCPC_SERVER::rx_start()
{
    m_sfd = init_socket(FLAG_TCP);
    if (m_sfd < 0) {
        log_error("init_socket( tcp ) failed.");
        return -1;
    }

    int client_socket;
    socklen_t client_addr_length;
    struct sockaddr_in client_addr;
    ncpc_client* c = NULL; int maxfd = 0; int i = 0;
    fd_set rset;
    struct timeval tv;
    while (!m_exit) {
        FD_ZERO(&rset); FD_SET(m_sfd, &rset); maxfd = m_sfd;
        for(i=0;i<MAX_CLIENT;i++) {
            c = m_clients[i];
            if (c->connected == 0) continue;
            if (c->connected == 2) { c->disconnect(); continue; }
            FD_SET(c->cfd, &rset);
            if (c->cfd > maxfd) maxfd = c->cfd;
        }
        tv.tv_sec = 1; tv.tv_usec = 0;
        int nready = select(maxfd + 1, &rset, NULL, NULL, &tv);
        if (nready == 0) { continue; }
        else if(nready < 0) { log_error("select error. Reason [%s]", strerror(errno)); return -1; }

        if (FD_ISSET(m_sfd, &rset)) {
            client_addr_length = sizeof(client_addr);
            client_socket = accept(m_sfd, (struct sockaddr *)&client_addr, &client_addr_length);
            if (client_socket < 0) { log_error("accept error. Reason [%s]", strerror(errno)); continue; }
            //verify ncp ip address
            char client_ip[16]; strcpy(client_ip,inet_ntoa(client_addr.sin_addr));
            int32 ncp_idx = ncpc_verifyTcpNcp(int_ipaddr(client_ip));
            if (ncp_idx < 0) {
                log_info("verify ip [%s] failure.  *** NCP CONNECT FAILURE ***", client_ip);
                close(client_socket); continue;
            }
            c = m_clients[ncp_idx];
            if (c->connected == 1) {
                c->disconnect(); //close old connection
            }
            //set nonblock
            int flags; flags = fcntl(client_socket, F_GETFL); flags |= O_NONBLOCK; fcntl(client_socket, F_SETFL, flags);
            c->connect(client_socket, client_ip, client_addr.sin_port);
            ncpc_setConnectStatus(ncp_idx, true);
        } else {
            time_t t = time(0);
            for(i=0;i<MAX_CLIENT;i++) {
                c = m_clients[i];
                if (c->connected == 0)
                    continue;
                if (FD_ISSET(c->cfd, &rset)) {
                    c->read_message();
                } else {
                    if (t-c->last_update > 10) {
                        log_warn("NCP heartbeat timeout. ip [%s]", c->ip);
                        c->disconnect();
                    }
                }
            }
        }
    }
    close(m_sfd);
    return 0;
}

void NCPC_SERVER::process_send_http_message(char *inm_buf)
{
    INM_MSG_HEADER *inm_header = (INM_MSG_HEADER *)inm_buf;

    ncpc_client *c = get_http_connection(inm_header->socket_idx);
    if (c == NULL) {
        log_debug("process_send_http_message() unavailable connection idx[%d].", inm_header->socket_idx);
        return;
    }
    ncpc_http_process_Send_message(this, c, inm_buf);
    return;
}

int NCPC_SERVER::tx_http_start()
{
    char inm_buf[INM_MSG_BUFFER_LENGTH];
    int32 len = 0;
    FID fid = getFidByName("ncpsend_http_queue");
    if (fid < 0) {
        log_error("getFidByName( ncpsend_http_queue ) failure.");
        return -1;
    }
    if (!bq_register(fid, "ncpsend_http_queue", getpid())) {
        log_error("bq_register( ncpsend_http_queue ) return failure.");
        return -1;
    }
    while (!m_exit) {
        len = bq_recv(fid, inm_buf, sizeof(inm_buf), 500);
        if(len < 0) {
            log_error("ncpc server tx_http_start(), bq_recv return error.");
            break;
        } else if (len == 0) {
            continue; //timeout
        }
        process_send_http_message(inm_buf);
    }
    log_info("ncpc http send thread exit.");
    return 0;
}



int NCPC_SERVER::rx_http_start()
{
    m_http_sfd = init_socket(FLAG_HTTP);
    if (m_http_sfd < 0) {
        log_error("init_socket( http ) failed.");
        return -1;
    }

    int client_socket;
    socklen_t client_addr_length;
    struct sockaddr_in client_addr;
    ncpc_client* c = NULL; int maxfd = 0; int i = 0;
    fd_set rset;
    struct timeval tv;
    while (!m_exit) {
        FD_ZERO(&rset); FD_SET(m_http_sfd, &rset); maxfd = m_http_sfd;
        for(i=0;i<MAX_HTTP_CLIENT;i++) {
            c = m_http_clients[i];
            if (c->connected == 0) continue;
            if (c->connected == 2) { c->disconnect(); continue; }
            FD_SET(c->cfd, &rset);
            if (c->cfd > maxfd) maxfd = c->cfd;
        }
        tv.tv_sec = 1; tv.tv_usec = 0;
        int nready = select(maxfd + 1, &rset, NULL, NULL, &tv);
        if (nready == 0) {
            continue;
        } else if(nready < 0) {
            log_error("select error. Reason [%s]", strerror(errno)); return -1;
        }
        if (FD_ISSET(m_http_sfd, &rset)) {
            client_addr_length = sizeof(client_addr);
            client_socket = accept(m_http_sfd, (struct sockaddr *)&client_addr, &client_addr_length);
            if (client_socket < 0) { log_error("accept error. Reason [%s]", strerror(errno)); continue; }
            //verify ncp ip address
            char client_ip[16]; strcpy(client_ip,inet_ntoa(client_addr.sin_addr));
            int32 ncp_idx = ncpc_verifyHttpNcp(int_ipaddr(client_ip));
            if (ncp_idx < 0) {
                log_info("verify ip [%s] failure.  *** HTTP NCP CONNECT FAILURE ***", client_ip);
                close(client_socket); continue;
            }
            c = NULL;
            for(i=0;i<MAX_HTTP_CLIENT;i++) {
                if (m_http_clients[i]->connected == 0) {
                    c = m_http_clients[i]; break;
                }
            }
            if (c == NULL) {
                log_error("too many connections"); close(client_socket); continue;
            }
            int flags; flags = fcntl(client_socket, F_GETFL); flags |= O_NONBLOCK; fcntl(client_socket, F_SETFL, flags);
            c->connect(client_socket, client_ip, client_addr.sin_port);
        } else {
            time_t t = time(0);
            for(i=0;i<MAX_HTTP_CLIENT;i++) {
                c = m_http_clients[i];
                if (c->connected == 0)
                    continue;
                if (FD_ISSET(c->cfd, &rset)) {
                    c->read_http_message();
                } else {
                    if (t-c->last_update > 8)
                        c->disconnect();
                }
            }
        }
    }
    close(m_http_sfd);
    return 0;
}

int NCPC_SERVER::timer_task()
{
    uint32 session_date = 0;
    while (!m_exit) {
        usleep(500*1000);

        //如果发生日期切换，清理kvdb中的历史数据
        if (session_date == 0)
            session_date = sysdb_getSessionDate();
        if (session_date != sysdb_getSessionDate()) {
            //delete old ap transaction flow
            //清理一周前的数据 (约束: ap售票流水号的前六位格式为：160830)
            int del_date = ts_offset_date(session_date, -7)%1000000;
            char key_str[32]; sprintf(key_str,"%06d~",del_date);
            kvdb->del_before(key_str);
            log_info("clear kvdb data. key_string: %s, switch session: %u  ->  %u", key_str, session_date, sysdb_getSessionDate());

            session_date = sysdb_getSessionDate();
        }
    }
    return 0;
}

int NCPC_SERVER::send_uns_message(char *s_buf, int s_buf_len)
{
    ncpc_client *c = NULL;
    for (int i=0;i<MAX_NCP_NUMBER;i++) {
        c = m_clients[i];
        if (c->connected == 1) {
            c->send_message(s_buf, s_buf_len);
            ncpc_updSendPkgNumber(c->identify);
        }
    }
    return 0;
}


int NCPC_SERVER::send_msg_to_bq(int bq_idx, char *buffer, int32 len)
{
    FID fid = 0;
    switch (bq_idx) {
        case q_ncpc_send:  fid = fid_ncpc_send; break;
        case q_ncpc_http_send:  fid = fid_ncpc_http_send; break;
        case q_gl_driver:  fid = fid_gl_driver; break;
        case q_tfe_adder:  fid = fid_tfe_adder; break;
        case q_fbs_driver: fid = fid_gl_fbs_driver; break;
        default:
            log_error("send_msg_to_bq() bq_idx error[%d]", bq_idx);
            return -1;
    }
    if (0 >= bq_send(fid, buffer, len)) {
        log_warn("send_msg_to_bq()::bq_send return error. fid:%i", fid);
        return -1;
    }
    return 0;
}

int NCPC_SERVER::process_recv_message(int sock_idx, char *gltp_buf)
{
    int ret  = 0;
    GLTP_MSG_HEADER *gltp_header = (GLTP_MSG_HEADER *)gltp_buf;
    char inm_buf[INM_MSG_BUFFER_LENGTH] = {0};
    INM_MSG_HEADER *inm_header = (INM_MSG_HEADER *)inm_buf;
    inm_header->socket_idx = sock_idx;

    ncpc_updRecvPkgNumber(sock_idx);
    if (gltp_header->type == GLTP_MSG_TYPE_NCP) {
        ret = ncpc_process_Recv_ncp_message(this, gltp_buf, inm_buf);
        if (ret < 0) {
            log_warn("ncpc_process_Recv_ncp_message() process failed.");
        }
    } else if (gltp_header->type == GLTP_MSG_TYPE_TERMINAL) {
        ret = ncpc_process_Recv_terminal_message(this, gltp_buf, inm_buf);
        if (ret < 0) {
            log_warn("ncpc_process_Recv_terminal_message() process failed.");
        }
    } else {
        log_warn("process_recv_message() failed. unknown gltp message type[%d]", gltp_header->type);
        ncpc_updAbnormalPkgNumber(sock_idx);
        return -1;
    }
    return 0;
}

int NCPC_SERVER::process_recv_http_message(int sock_idx, char *json_buf)
{
    return ncpc_http_process_Recv_message(this, sock_idx, json_buf);
}

int NCPC_SERVER::worker_start()
{
    mque_item* item = NULL;
    while (!m_exit) {
        item = wque->dequeue(wque, 100);
        if (item == NULL) { continue; }

        if (item->param2 == FLAG_TCP) {
            //binary buffer (gltp message)
            int ret = process_recv_message(item->param1, (char*)item->ptr);
            if (0 != ret) {
                log_warn("process_recv_message() failed.");
            }
            free(item->ptr);
        } else {
            //json string
            int ret = process_recv_http_message(item->param1, (char*)item->ptr);
            if (0 != ret) {
                log_warn("process_recv_message() failed.");
            }
        }
        free(item);
    }
    return 0;
}

void *ncpc_tx_thread(void *arg)
{
    log_info("ncpc_tx_thread start");
    NCPC_SERVER* ns = (NCPC_SERVER*)arg;

    ns->tx_start();
    
    log_info("ncpc_tx_thread exit");
    return 0;
}
void *ncpc_rx_thread(void *arg)
{
    log_info("ncpc_rx_thread start");
    NCPC_SERVER* ns = (NCPC_SERVER*)arg;

    ns->rx_start();

    log_info("ncpc_rx_thread exit");
    return 0;
}
void *ncpc_tx_http_thread(void *arg)
{
    log_info("ncpc_tx_http_thread start");
    NCPC_SERVER* ns = (NCPC_SERVER*)arg;

    ns->tx_http_start();
    
    log_info("ncpc_tx_http_thread exit");
    return 0;
}
void *ncpc_rx_http_thread(void *arg)
{
    log_info("ncpc_rx_http_thread start");
    NCPC_SERVER* ns = (NCPC_SERVER*)arg;

    ns->rx_http_start();

    log_info("ncpc_rx_http_thread exit");
    return 0;
}

void *ncpc_worker_thread(void *arg)
{
    log_info("ncpc_worker_thread start");
    NCPC_SERVER* ns = (NCPC_SERVER*)arg;

    ns->worker_start();

    log_info("ncpc_worker_thread exit");
    return 0;
}



void ncpc_service_start(NCPC_SERVER *ns)
{
    int ret = ns->init();
    if (ret < 0) {
        return;
    }

    pthread_t th;
    pthread_create(&th, NULL, ncpc_tx_thread, ns);
    pthread_create(&th, NULL, ncpc_rx_thread, ns);
    pthread_create(&th, NULL, ncpc_tx_http_thread, ns);
    pthread_create(&th, NULL, ncpc_rx_http_thread, ns);
    for (int i=0;i<NCPC_WORKER_COUNT;i++) {
        pthread_create(&th, NULL, ncpc_worker_thread, ns);
    }

    //timer loop
    ns->timer_task();
}



