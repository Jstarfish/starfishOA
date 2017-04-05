/*==============================================================================
 * 包含系统文件
 * Includes System Files
 =============================================================================*/

#include "global.h"

/*==============================================================================
 * 包含本地文件
 * Include Files
 =============================================================================*/

/*==============================================================================
 * 常量定义，并对所定义的常量进行说明
 * Constant / Define Declarations
 =============================================================================*/

//static const int MSG_WAITALL=0x100;

/*==============================================================================
 * 类型定义(struct、enum)等,如果是重要数据结构，要详细说明
 * Type Declarations(struct,enum etc.) and Brief Description
 * If it's Significant,Detailed Description Should Be Present
 =============================================================================*/

/*==============================================================================
 * 全局常量定义，并对其进行简要说明
 * Global Constant Declarations and Brief Description
 =============================================================================*/

/*==============================================================================
 * 本地值/函数宏定义，并对其进行简要说明
 * Local Variable and Macro Definitions and Brief Description
 =============================================================================*/

#define convertsocketstd(stdaddr,inaddr) \
    struct sockaddr* stdaddr =(struct sockaddr*)&inaddr

#define convertsocketin(inaddr,stdaddr) \
    struct sockaddr_in* inaddr =(struct sockaddr_in*)&stdaddr

SOCKET open_socket(
        SOCKET_MODE _kind_)
{
    SOCKET sockid = NUL_SOCKET;

    if (_kind_ == SOCKET_TCP)
    {
        sockid = socket(AF_INET, SOCK_STREAM, 0);
    }
    else if (_kind_ == SOCKET_UDP)
    {
        sockid = socket(AF_INET, SOCK_DGRAM, 0);
    }

    if (-1 == sockid) {
        perrork("socket() failed. Reason [%s].", strerror(errno));
    }

    return sockid;
}

bool close_socket(
        const SOCKET _sock_)
{
    bool err = false;

    int ret = shutdown(_sock_, SHUT_RDWR);
    if (0 != ret) {
        perrork("shutdown() failed. Reason [%s].", strerror(errno));

        if (errno != ENOTCONN && errno != ECONNRESET) {
            err = true;
        }
    }

    if (0 != close(_sock_)) {
        perrork("close(fd[%d]) failed. Reason [%s].", _sock_, strerror(errno));

        if (errno != ENOTCONN && errno != ECONNRESET) {
            err = true;
        }
    }

    return !err;
}

void make_addr(
        NETADDR* _addr_,
        const char* _host_,
        const uint16 _port_)
{
    if (_addr_ != null)
    {
        memset(_addr_, 0, sizeof(NETADDR));
        _addr_->sin_family = AF_INET;
        _addr_->sin_port = htons(_port_);
        if (_host_ == null)
        {
            _addr_->sin_addr.s_addr = htonl(INADDR_ANY);
        }
        else
        {
            _addr_->sin_addr.s_addr = inet_addr(_host_);
        }
    }
}

bool bind_socket(
        const SOCKET _sock_,
        const char* _host_,
        const uint16 _port_)
{
    struct sockaddr_in addr;
    convertsocketstd(_addr,addr);
    make_addr(&addr, _host_, _port_);

    int sizeaddr = sizeof(struct sockaddr);

    return bind(_sock_, _addr, sizeaddr) == 0;
}

bool getopt_socket(
        const SOCKET _sock_,
        struct socket_config* _conf_)
{
    int32 option_size = 0;
    if (_conf_ != null)
    {
        option_size = sizeof(_conf_->sbuf_size);
        if (getsockopt(_sock_, SOL_SOCKET, SO_SNDBUF, &(_conf_->sbuf_size),
                (socklen_t*) &option_size) != 0)
        {
            return false;
        }
        option_size = sizeof(_conf_->rbuf_size);
        if (getsockopt(_sock_, SOL_SOCKET, SO_RCVBUF, &(_conf_->rbuf_size),
                (socklen_t*) &option_size) != 0)
        {
            return false;
        }
        option_size = sizeof(_conf_->keep_live);
        if (getsockopt(_sock_, SOL_SOCKET, SO_KEEPALIVE, &(_conf_->keep_live),
                (socklen_t*) &option_size) != 0)
        {
            return false;
        }
    }

    return false;
}

bool config_socket(
        SOCKET _sock_,
        struct socket_config* _conf_)
{
    fcntl(_sock_, F_SETOWN, getpid());
    if (_conf_ != null)
    {
        if (setsockopt(_sock_, SOL_SOCKET, SO_SNDBUF, &(_conf_->sbuf_size),
                sizeof(_conf_->sbuf_size)) != 0)
        {
            return false;
        }
        if (setsockopt(_sock_, SOL_SOCKET, SO_RCVBUF, &(_conf_->rbuf_size),
                sizeof(_conf_->rbuf_size)) != 0)
        {
            return false;
        }
        if (setsockopt(_sock_, SOL_SOCKET, SO_KEEPALIVE, &(_conf_->keep_live),
                sizeof(_conf_->keep_live)) != 0)
        {
            return false;
        }
        if (setsockopt(_sock_, SOL_SOCKET, SO_SNDTIMEO, &(_conf_->send_time),
                sizeof(_conf_->send_time)) != 0)
        {
            return false;
        }

        if (setsockopt(_sock_, SOL_SOCKET, SO_RCVTIMEO, &(_conf_->recv_time),
                sizeof(_conf_->recv_time)) != 0)
        {
            return false;
        }
        if (_conf_->nio_mode)//nio_mode = 1 则设置为阻塞模式
        {
            if (fcntl(_sock_, F_SETFL, O_NONBLOCK) != 0)
            {
                return false;
            }
        }

        return true;
    }
    else
    {
        return false;
    }
}

bool listen_socket(
        const SOCKET _sock_)
{
    return listen(_sock_, 1) == 0;
}

SOCKET accept_socket(
        const SOCKET _sock_,
        const NETADDR* _addr_)
{
    static socklen_t sizeaddr = sizeof(struct sockaddr_in);
    return accept(_sock_, (struct sockaddr*) _addr_, &sizeaddr);
}

bool connect_socket(
        const SOCKET _sock_,
        const char* _host_,
        const uint16 _port_)
{
    struct sockaddr_in addr;
    convertsocketstd(_addr,addr);

    make_addr(&addr, _host_, _port_);

    int sizeaddr = sizeof(struct sockaddr);

    int ret = connect(_sock_, _addr, sizeaddr);
    if (0 != ret) {
        perrork("connect to host [%s], port [%d] failed. Reason [%s]", _host_, (int32)_port_, strerror(errno));

        return false;
    }

    return true;
}

int32 tcp_send(
        const SOCKET _sock_,
        const void* _data_,
        const int32 _size_)
{
    return send(_sock_, _data_, _size_, 0);
}

int32 tcp_recv(
        const SOCKET _sock_,
        void* const _data_,
        const int32 _size_)
{
    return recv(_sock_, _data_, _size_, 0);
}

bool tcp_recv_fully(
        const SOCKET _sock_,
        void* const _data_,
        const int32 _size_)
{

    int _recv_ = 0, _ctrl_;

    char* buff =(char*)_data_;

    while (_recv_ < _size_)
    {
        _ctrl_ = recv(_sock_, buff+_recv_, _size_-_recv_, 0);

        if(_ctrl_ <= 0)
        {
            return false;
        }
        else
        {
            _recv_ += _ctrl_;
        }
    }

    return _recv_ == _size_ ;
}

int32 udp_send(
        const SOCKET _sock_,
        const NETADDR* _addr_,
        const void* _data_,
        const int32 _size_)
{
    int sizeaddr = sizeof(struct sockaddr_in);
    return sendto(_sock_, _data_, _size_, 0, (struct sockaddr*) _addr_,
            sizeaddr);
}

int32 udp_recv(
        const SOCKET _sock_,
        void* const _data_,
        const int32 _size_)
{
    return recvfrom(_sock_, _data_, _size_, 0, null, null);
}

uint32 int_ipaddr(
        const char *_host_)
{
    return inet_addr(_host_);
}

void str_ipaddr(
        char * const _host_,
        const int32 _addr_)
{
    struct in_addr temp;
    temp.s_addr = _addr_;
    char* addr = inet_ntoa(temp);
    strncpy(_host_, addr, strlen(addr));
}

void str_macaddr(
        char * const _host_,
        const char* _macs_)
{
    sprintf(_host_, "%02X:%02X:%02X:%02X:%02X:%02X",
            _macs_[0], _macs_[1], _macs_[2],
            _macs_[3], _macs_[4], _macs_[5]);
}

