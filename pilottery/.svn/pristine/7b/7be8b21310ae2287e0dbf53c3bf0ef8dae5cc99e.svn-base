#ifndef GLTP_MESSAGE_NCP_H_INCLUDED
#define GLTP_MESSAGE_NCP_H_INCLUDED


//------------------------------------------------------------------------------
//NCP消息编码
//------------------------------------------------------------------------------
typedef enum _GLTP_MESSAGE_NCP_TYPE {
    //心跳 ( NCP <-> host )
    GLTP_N_HB                  = 0,

    //ECHO ( NCP <-> host ) 链路测试消息
    GLTP_N_ECHO_REQ            = 1,
    GLTP_N_ECHO_RSP            = 2,

    //终端机安全密钥获取消息 ( NCP <-> host ) (未实现)
    GLTP_N_KEY_REQ             = 3,
    GLTP_N_KEY_RSP             = 4,

    //终端机连接状态报告 ( NCP -> host )
    GLTP_N_TERMINAL_CONN       = 1001,

    //终端机网络延时报告 ( NCP -> host )
    GLTP_N_TERM_NETWORK_DELAY  = 1002,


    //游戏期次信息消息 ( NCP <-> host )
    GLTP_N_GAME_ISSUE_REQ      = 2001,
    //                 ( host -> NCP )
    GLTP_N_GAME_ISSUE_RSP      = 2002,

}GLTP_MESSAGE_NCP_TYPE;



//指定按1字节对齐
#pragma pack (1)



typedef struct _GLTP_MSG_N_HEADER
{
    //GLTP_MSG_HEADER
    uint16  length;        //消息长度
    uint8   type;          //消息类型
    uint16  func;          //消息编码
    uint32  when;          //时间戳（秒数）

    char data[];
}GLTP_MSG_N_HEADER;
#define GLTP_MSG_N_HEADER_LEN sizeof(GLTP_MSG_N_HEADER)



//------------------------------------------------------------------------------
//NCP心跳请求/响应消息(0) <GLTP_N_HB>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_N_HB
{
    GLTP_MSG_N_HEADER  header;
    uint32  termcnt;           //当前终端连接数
    uint16  crc;
}GLTP_MSG_N_HB;


//------------------------------------------------------------------------------
//ECHO请求/响应消息(1/2) <GLTP_N_KEY_REQ/GLTP_N_ECHO_RSP>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_N_ECHO_REQ
{
    GLTP_MSG_N_HEADER header;
    uint32  echo_len;
    char    echo_str[];        //不可超过128字节
    //uint16  crc;
}GLTP_MSG_N_ECHO_REQ;

typedef struct _GLTP_MSG_N_ECHO_RSP
{
    GLTP_MSG_N_HEADER header;
    uint32  echo_len;
    char    echo_str[];        //reply -> Welcome, I'm TaiShan System.
    //uint16  crc;
}GLTP_MSG_N_ECHO_RSP;


//------------------------------------------------------------------------------
//终端机连接状态报告消息 <GLTP_N_TERMINAL_CONN>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_N_TERMINAL_CONN
{
    GLTP_MSG_N_HEADER  header;
    uint64 token;
    uint32 timestamp;
    uint8  conn;               //0 断开   1 连接
    uint32 termcnt;            //当前终端连接数
    uint16 crc;
}GLTP_MSG_N_TERMINAL_CONN;


//------------------------------------------------------------------------------
//终端机网络延时报告消息 <GLTP_N_TERM_NETWORK_DELAY>
//------------------------------------------------------------------------------
typedef struct _GLTP_MSG_N_TERM_NETWORK_DEALY
{
    GLTP_MSG_N_HEADER  header;
    uint64 token;
    uint32 timestamp;
    uint32 delayMilliSeconds;  //终端收到上一个网络计时消息的延迟毫秒数(终端连接后第一个网络计时消息此字段填0)
    uint16 crc;
}GLTP_MSG_N_TERM_NETWORK_DELAY;


//------------------------------------------------------------------------------
//游戏期次信息消息 <GLTP_MSG_N_GAME_ISSUE_RSP>
//------------------------------------------------------------------------------
typedef struct _HOST_GAME_ISSUE
{
    uint8  gameCode;                             //游戏编码
    uint64  issueNumber;                         //当前期期号
    uint32  issueStartTime;                      //期开始时间
    uint32  issueLength;                         //期长
    uint32  countDownSeconds;                    //期关闭倒计时秒数
}HOST_GAME_ISSUE;

typedef struct _GLTP_MSG_N_GAME_ISSUE_RSP
{
    GLTP_MSG_N_HEADER  header;
    uint8  gameCount;              //游戏个数
    HOST_GAME_ISSUE issueInfo[];   //当前期信息结构体数组
}GLTP_MSG_N_GAME_ISSUE_RSP;

//取消指定对齐，恢复缺省对齐
#pragma pack ()



#endif //GLTP_MESSAGE_NCP_H_INCLUDED


