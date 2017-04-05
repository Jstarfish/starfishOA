#ifndef HCNETIO_H_INCLUDED
#define HCNETIO_H_INCLUDED



/*==============================================================================
 * 全局常量及值宏定义，并对其进行简要说明
 * Global Constant & Macro Definitions and Brief Description
 =============================================================================*/

#define NUL_SOCKET (-1)

#define SOCKET_CHANNAL_RECV 0
#define SOCKET_CHANNAL_SEND 1
#define SOCKET_CHANNAL_BOTH 2

/*==============================================================================
 * 类型定义(struct、enum)等,如果是重要数据结构，要详细说明
 * Type Declarations(struct,enum etc.) and Brief Description
 * If it's Significant,Detailed Description Should Be Present
 =============================================================================*/
typedef int32 SOCKET;

typedef struct sockaddr_in NETADDR;

typedef enum
{
    SOCKET_TCP,
    SOCKET_UDP
} SOCKET_MODE;

typedef enum
{
    SOCKET_STATE_EMPTY = 0,
    SOCKET_STATE_READY,
    //server
    SOCKET_STATE_BIND,
    SOCKET_STATE_LISTEN,
    SOCKET_STATE_ACCEPT,
    //client
    SOCKET_STATE_CONNECT,
    //
    SOCKET_STATE_WORKING,
    SOCKET_STATE_PAUSE,
    SOCKET_STATE_FAULT
} SOCKET_STATE;

struct socket_config
{
    bool nio_mode;
    bool keep_live;
    int16 sbuf_size;
    int16 rbuf_size;
    int32 send_time;
    int32 recv_time;
};

#define BACKLOG 1024

struct socket_keyset
{

};

/*==============================================================================
 * 函数性宏定义，并对其进行简要说明
 * Functional Macro Definitions and Brief Description
 =============================================================================*/

/*==============================================================================
 * 外部函数定义，并对其进行简要说明
 * Functions Definitions and Brief Description
 =============================================================================*/

SOCKET open_socket(
        SOCKET_MODE _kind_);

bool close_socket(
        const SOCKET _sock_);

void make_addr(
        NETADDR* _addr_,
        const char* _host_,
        const uint16 _port_);

bool bind_socket(
        const SOCKET _sock_,
        const char* _intf_,
        const uint16 port);

bool getopt_socket(
        const SOCKET _sock_,
        struct socket_config* _conf_);

bool config_socket(
        const SOCKET _sock_,
        struct socket_config* _conf_);

bool listen_socket(
        const SOCKET _sock_);

bool select_socket();

SOCKET accept_socket(
        const SOCKET _sock_,
        const NETADDR* _addr_);

bool connect_socket(
        const SOCKET _sock_,
        const char* _host_,
        const uint16 _port_);

int32 tcp_send(
        const SOCKET _sock_,
        const void* _data_,
        const int32 _size_);

int32 tcp_recv(
        const SOCKET _sock_,
        void* const _data_,
        const int32 _size_);

bool tcp_recv_fully(
        const SOCKET _sock_,
        void* const _data_,
        const int32 _size_);

int32 udp_send(
        const SOCKET _sock_,
        const NETADDR* _addr_,
        const void* _data_,
        const int32 _size_);

int32 udp_recv(
        const SOCKET _sock_,
        void* const _data_,
        const int32 _size_);

uint32 int_ipaddr(
        const char *_host_);

void str_ipaddr(
        char *const _host_,
        const int32 _addr_);

void str_macaddr(
        char *const _macs,
        const char* _host_);
/*==============================================================================
 * 内联函数定义，并对其进行简要说明
 * Static Inline Functions Definitions and Brief Description
 =============================================================================*/


#endif // HCNETIO_H_INCLUDED
