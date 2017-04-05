#ifndef INM_MESSAGE_NCP_H_INCLUDED
#define INM_MESSAGE_NCP_H_INCLUDED


//指定按1字节对齐
#pragma pack (1)


typedef struct _INM_MSG_N_HEADER {
    INM_MSG_HEADER   inm_header;

    //uint32  tid;
    //uint32  terminal_code;
    //uint32  agency_code;
    //********************************8

    char    data[];
}INM_MSG_N_HEADER;
#define INM_MSG_N_HEADER_LEN sizeof(INM_MSG_N_HEADER)



// NCP ----------------------------------------------------------------------------------

//Heartbeat Message
//只有 INM_MSG_N_HEADER，没有数据区

//echo message
typedef struct _INM_MSG_N_ECHO {
    INM_MSG_N_HEADER header;
    uint32  echo_len;
    char    echo_str[];
}INM_MSG_N_ECHO;


//游戏当前期次信息应答------------------------------------------------
typedef struct _INM_MSG_N_GAME_ISSUE
{
	INM_MSG_N_HEADER header;

    uint8   gameCount;
    HOST_GAME_ISSUE issue[];
}INM_MSG_N_GAME_ISSUE;



//取消指定对齐，恢复缺省对齐
#pragma pack ()



#endif //INM_MESSAGE_NCP_H_INCLUDED

