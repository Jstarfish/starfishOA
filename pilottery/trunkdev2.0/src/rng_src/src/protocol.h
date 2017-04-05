#ifndef _PROTOCOL_H_
#define _PROTOCOL_H_

// The following typedefs shall be commented when used in rng_server
#include <stdint.h>
typedef uint8_t  uint8;
typedef uint16_t uint16;
typedef uint32_t uint32;
typedef uint64_t uint64;

// RNG working status: used for business logic but not used in messages
typedef enum _RNG_STATUS {
    RNG_UNCONNECTED   = 0,
    RNG_CONNECTED     = 1,
    RNG_AUTHENTICATED = 2,
} RNG_STATUS;

// RNG message return code
typedef enum _RNG_RETURN_CODE {
    RNG_SUCCESS               = 0,
    RNG_FAILURE               = 1,
    RNG_GAME_NOT_SUPPORTED    = 2,
} RNG_RETURN_CODE;


// RNG message type
typedef enum _RNG_MESSAGE_TYPE {
    RNG_MSG_TYPE_HB        = 0xff,    // heartbeat message
    RNG_MSG_TYPE_AUTH_REQ  = 0x01,    // authentication request
    RNG_MSG_TYPE_AUTH_RSP  = 0x02,    // authentication response
    RNG_MSG_TYPE_DRAW_REQ  = 0x03,    // draw number request
    RNG_MSG_TYPE_DRAW_RSP  = 0X04,    // draw number response
} RNG_MESSAGE_TYPE;


// One-byte alignment starts
#pragma pack (1)


// RNG message header
typedef struct _RNG_MESSAGE_HEADER {
    uint16      len;             // message length (in total)
    uint8       type;            // message type: RNG_MESSAGE_TYPE
    uint8       deviceID;        // device identification no.
    uint32      time;            // message creation time stamp
    uint8       param;           // extension parameter
} RNG_MESSAGE_HEADER;


// RNG heartbeat message (RNG_MSG_TYPE_HB) RNG->HOST->RNG
typedef struct _RNG_MSG_HB {
    RNG_MESSAGE_HEADER header;
    uint16             crc;
} RNG_MSG_HB;


// RNG authentication request message (RNG_MSG_TYPE_AUTH_REQ) RNG->HOST
typedef struct _RNG_MSG_AUTH_REQ {
    RNG_MESSAGE_HEADER header;
    uint8              mac[6];
    uint16             crc;
} RNG_MSG_AUTH_REQ;


// RNG authentication response message (RNG_MSG_TYPE_AUTH_RSP) HOST->RNG
typedef struct _RNG_MSG_AUTH_RSP {
    RNG_MESSAGE_HEADER header;
    uint8              retcode;
    uint16             crc;
} RNG_MSG_AUTH_RSP;


// RNG draw number request message (RNG_MSG_TYPE_DRAW_REQ) HOST->RNG
typedef struct _RNG_MSG_DRAW_REQ {
    RNG_MESSAGE_HEADER header;
    uint8              gameCode;
    uint64             issueNumber;
    uint16             crc;
} RNG_MSG_DRAW_REQ;


// RNG draw number reply message (RNG_MSG_TYPE_DRAW_RSP) RNG->HOST
typedef struct _RNG_MSG_DRAW_RSP {
    RNG_MESSAGE_HEADER header;
    uint8              gameCode;
    uint64             issueNumber;
    uint8              retcode;
    uint8              resultLen;
    uint8              result[];
    //uint16           crc;
} RNG_MSG_DRAW_RSP;


// One-byte alignment ends
#pragma pack ()

#endif // _PROTOCOL_H_
