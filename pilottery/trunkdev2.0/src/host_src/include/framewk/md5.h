#ifndef MCL_MD5_H
#define MCL_MD5_H
#include <stdio.h>

typedef unsigned char *POINTER;
typedef unsigned short int UINT2;
typedef unsigned int UINT4;

typedef struct {
  UINT4 state[4];        /* state (ABCD) */
  UINT4 count[2];        /* number of bits, modulo 2^64 (lsb first) */
  unsigned char buffer[64];    /* input buffer */
} MD5_CTX;

void MD5Init (MD5_CTX *);

void MD5Update (MD5_CTX *, unsigned char *, unsigned int);

void MD5Final (unsigned char [16], MD5_CTX *);


/** md5 for string
 *  parameters:
 *           string: the string to md5
 *           digest: store the md5 digest
 *  return: 0 for success, != 0 fail
*/
int MD5String(char *string, unsigned char digest[16]);

/** md5 for buffer
 *  parameters:
 *           buffer: the buffer to md5
 *           len: the buffer length
 *           digest: store the md5 digest
 *  return: 0 for success, != 0 fail
*/
int MD5Buffer(char *buffer, unsigned int len, unsigned char digest[16]);

/** md5 for file
 *  parameters:
 *           filename: the filename whose content to md5
 *           digest: store the md5 digest
 *  return: 0 for success, != 0 fail
*/
int md5_file(const char *file, char *md5);
//对指定文件计算MD5值,并返回md5值
int md5_file_calc(const char *file, char *md5);
//读取指定文件的MD5文件的内容
int get_md5_file(const char *file, char *md5);
//对指定文件计算MD5值, 并与此文件的MD5文件的值进行比较
int md5_file_verify(const char *file);


//hmac 算法
void hmac_md5 (const unsigned char *password,  size_t pass_len,
               const unsigned char *challenge, size_t chal_len,
               unsigned char *response,  size_t resp_len);



#endif

