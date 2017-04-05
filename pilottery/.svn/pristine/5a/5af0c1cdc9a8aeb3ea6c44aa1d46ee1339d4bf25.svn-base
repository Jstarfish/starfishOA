#ifndef NCP_H
#define NCP_H

#include <ctype.h>
#include <errno.h>
#include <limits.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include <arpa/inet.h>
#include <fcntl.h>
#include <libgen.h>
#include <netinet/in.h>
#include <pthread.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

#include "ev.h"

#include <map>
#include <list>
using namespace std;

typedef int8_t    int8;
typedef uint8_t   uint8;
typedef int16_t   int16;
typedef uint16_t  uint16;
typedef int32_t   int32;
typedef uint32_t  uint32;
typedef int64_t   int64;
typedef uint64_t  uint64;
typedef int64_t   money_t;

#include "gltp_message.h"
#include "ncp_util.h"
#include "crypt.h"

#define wh_notused(V)                ((void) V)
#define wh_malloc(len)               malloc(len)
#define wh_calloc(n, len)            calloc(n,len)
#define wh_realloc(mem, n_bytes)     realloc(mem, n_bytes)
#define wh_free(mem)                 free(mem)

#define BUFFER_SIZE 1024*32
#define CRC_SIZE 2

#endif //NCP_H

