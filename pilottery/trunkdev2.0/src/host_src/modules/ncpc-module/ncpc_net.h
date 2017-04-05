#ifndef NCPC_NET_H_INCLUDED
#define NCPC_NET_H_INCLUDED


#define MAX_BUFFER          (1024*16)

#define MAX_CLIENT          MAX_NCP_NUMBER
#define MAX_HTTP_CLIENT     (32)
#define NCPC_WORKER_COUNT   8

class NCPC_SERVER;

#define FLAG_TCP    0
#define FLAG_HTTP   1

class ncpc_client
{
public:
    ncpc_client(NCPC_SERVER *_ns, int _dentify, int flag);
    ~ncpc_client();

    int connect(int _cfd, char* _ip, int _port);
    int pre_disconnect();
    int disconnect();

    int read_message();
    void send_message(char *s_buf, int s_buf_len);
    int read_http_message();
    void send_http_message(char *s_buf, int s_buf_len);
public:
    NCPC_SERVER *ns;
    int identify;
    int flag;
    int cfd;
    char ip[16];
    int port;
    int connected; //0 disconnect  1 connected
    time_t last_update;
    char r_buf[MAX_BUFFER];
    int r_buf_offset;

    http_parser parser;
    http_parser_settings parser_settings;
    int  http_method;
    int  http_keepalive;
    char *http_url;
    char *http_host;
    char *http_message;
    int http_message_len;
    int http_complete; //init 0  1 complete
};


class NCPC_SERVER
{
public:
    NCPC_SERVER() {};
    ~NCPC_SERVER(){};

    int init();
    ncpc_client* get_connection(int idx);
    ncpc_client* get_http_connection(int idx);
    int init_socket(int port);
    int rx_start();
    int tx_start();
    int rx_http_start();
    int tx_http_start();
    int timer_task();

    int send_uns_message(char *s_buf, int s_buf_len);

    int send_msg_to_bq(int bq_idx, char *buffer, int32 len);
    int process_recv_message(int sock_idx, char *gltp_buf);
    void process_send_message(char *inm_buf);
    int process_recv_http_message(int sock_idx, char *json_buf);
    void process_send_http_message(char *inm_buf);
    int worker_start();
    
public:
    int m_exit;
    int m_listen_port;
    int m_sfd;
    int m_http_listen_port;
    int m_http_sfd;
    ncpc_client* m_clients[MAX_CLIENT];
    ncpc_client* m_http_clients[MAX_HTTP_CLIENT];
    MQUE *wque;
    KVDB *kvdb;

    //bqueue fid
    FID fid_ncpc_send;
    FID fid_ncpc_http_send;
    FID fid_tfe_adder;
    FID fid_gl_driver;
    FID fid_gl_fbs_driver;
};

void ncpc_service_start(NCPC_SERVER *ns);


#endif //NCPC_NET_H_INCLUDED

