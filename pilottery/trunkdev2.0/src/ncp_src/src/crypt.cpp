#include <stdio.h>
#include <string.h>
#include <iostream>     
#include <algorithm>    
#include <vector>       
#include "crypt.h"

typedef char int8;
typedef unsigned char uint8;
typedef short int16;
typedef unsigned short uint16;
typedef int int32;
typedef unsigned int uint32;
typedef long long int64;
typedef unsigned long long uint64;

//-------------------------------------------------------------------------------------------------------------------

// crc16 look-up table
unsigned short crc16[] = {
    0x0000, 0xcc01, 0xd801, 0x1400, 0xf001,
    0x3c00, 0x2800, 0xe401, 0xa001, 0x6c00, 0x7800, 0xb401, 0x5000, 0x9c01,
    0x8801, 0x4400, 0xcc01, 0x0000, 0x1400, 0xd801, 0x3c00, 0xf001, 0xe401,
    0x2800, 0x6c00, 0xa001, 0xb401, 0x7800, 0x9c01, 0x5000, 0x4400, 0x8801,
    0xd801, 0x1400, 0x0000, 0xcc01, 0x2800, 0xe401, 0xf001, 0x3c00, 0x7800,
    0xb401, 0xa001, 0x6c00, 0x8801, 0x4400, 0x5000, 0x9c01, 0x1400, 0xd801,
    0xcc01, 0x0000, 0xe401, 0x2800, 0x3c00, 0xf001, 0xb401, 0x7800, 0x6c00,
    0xa001, 0x4400, 0x8801, 0x9c01, 0x5000, 0xf001, 0x3c00, 0x2800, 0xe401,
    0x0000, 0xcc01, 0xd801, 0x1400, 0x5000, 0x9c01, 0x8801, 0x4400, 0xa001,
    0x6c00, 0x7800, 0xb401, 0x3c00, 0xf001, 0xe401, 0x2800, 0xcc01, 0x0000,
    0x1400, 0xd801, 0x9c01, 0x5000, 0x4400, 0x8801, 0x6c00, 0xa001, 0xb401,
    0x7800, 0x2800, 0xe401, 0xf001, 0x3c00, 0xd801, 0x1400, 0x0000, 0xcc01,
    0x8801, 0x4400, 0x5000, 0x9c01, 0x7800, 0xb401, 0xa001, 0x6c00, 0xe401,
    0x2800, 0x3c00, 0xf001, 0x1400, 0xd801, 0xcc01, 0x0000, 0x4400, 0x8801,
    0x9c01, 0x5000, 0xb401, 0x7800, 0x6c00, 0xa001, 0xa001, 0x6c00, 0x7800,
    0xb401, 0x5000, 0x9c01, 0x8801, 0x4400, 0x0000, 0xcc01, 0xd801, 0x1400,
    0xf001, 0x3c00, 0x2800, 0xe401, 0x6c00, 0xa001, 0xb401, 0x7800, 0x9c01,
    0x5000, 0x4400, 0x8801, 0xcc01, 0x0000, 0x1400, 0xd801, 0x3c00, 0xf001,
    0xe401, 0x2800, 0x7800, 0xb401, 0xa001, 0x6c00, 0x8801, 0x4400, 0x5000,
    0x9c01, 0xd801, 0x1400, 0x0000, 0xcc01, 0x2800, 0xe401, 0xf001, 0x3c00,
    0xb401, 0x7800, 0x6c00, 0xa001, 0x4400, 0x8801, 0x9c01, 0x5000, 0x1400,
    0xd801, 0xcc01, 0x0000, 0xe401, 0x2800, 0x3c00, 0xf001, 0x5000, 0x9c01,
    0x8801, 0x4400, 0xa001, 0x6c00, 0x7800, 0xb401, 0xf001, 0x3c00, 0x2800,
    0xe401, 0x0000, 0xcc01, 0xd801, 0x1400, 0x9c01, 0x5000, 0x4400, 0x8801,
    0x6c00, 0xa001, 0xb401, 0x7800, 0x3c00, 0xf001, 0xe401, 0x2800, 0xcc01,
    0x0000, 0x1400, 0xd801, 0x8801, 0x4400, 0x5000, 0x9c01, 0x7800, 0xb401,
    0xa001, 0x6c00, 0x2800, 0xe401, 0xf001, 0x3c00, 0xd801, 0x1400, 0x0000,
    0xcc01, 0x4400, 0x8801, 0x9c01, 0x5000, 0xb401, 0x7800, 0x6c00, 0xa001,
    0xe401, 0x2800, 0x3c00, 0xf001, 0x1400, 0xd801, 0xcc01, 0x0000 };

// actual computation of crc value
void crc_calculate(unsigned short* crc, unsigned char* buffer, int length)
{
    unsigned short index = 0;
    unsigned short crcIndex = 0;
    unsigned short tableEntry = 0;

    for (index = 0x0; index < length; index++) {
        tableEntry = crc16[(crcIndex & 0xF) | ((buffer[index] & 0xF) << 0x4)];
        crcIndex   = crcIndex >> 0x4 ^ tableEntry;
        tableEntry = crc16[(crcIndex & 0xF) | (buffer[index] & 0xF0)];
        crcIndex   = crcIndex >> 0x4 ^ tableEntry;
    }
    *crc = crcIndex;
}

// return the calculated crc value of 'buf'
unsigned short calc_crc(void * buf, int len)
{
    unsigned short crc = 0;
    crc_calculate(&crc, (unsigned char *) buf, len);
    return crc;
}

//-------------------------------------------------------------------------------------------------------------------

long long DELTA = 2654435769L; //0x9e3779b9
#define MIN_LENGTH 32

void switch_endian_ll(long long & n){
  char* p = (char*)&n;
  std::swap(p[0], p[7]);
  std::swap(p[1], p[6]);
  std::swap(p[2], p[5]);
  std::swap(p[3], p[4]);
}

void XXTEAEncrypt( long long * data, int datalen,  long long * key) {
  int n = datalen;
  long long  z = data[datalen - 1], y = data[0], sum = 0;
  int p, q, e;
  q = 6 + 52 / n;
  while (q-- > 0) {
    sum += DELTA;
    e = (sum >> 2) & 3;
    for (p = 0; p < n - 1; p++) {
      y = data[p + 1];
      z = (data[p] += ((z >> 5) ^ (y << 2)) + (((y >> 3) ^ (z << 4)) ^ (sum ^ y)) + (key[(p & 3) ^ e] ^ z));
    }
    y = data[0];
    z = (data[n - 1] += ((z >> 5) ^ (y << 2)) + (((y >> 3) ^ (z << 4)) ^ (sum ^ y)) + (key[(p & 3) ^ e] ^ z));
  }
  for(int i=0; i<n; ++i)
    switch_endian_ll(data[i]);
}

void XXTEADecrypt(long long* data, int datalen, long long* key) {
  int n = datalen;
  for(int i=0; i<n; ++i)
    switch_endian_ll(data[i]);
  long long z = data[datalen - 1], y = data[0], sum = 0;
  int p, q, e;
  q = 6 + 52 / n;
  sum = q * DELTA;
  while (sum != 0) {
    e = (sum >> 2) & 3;
    for (p = n - 1; p > 0; p--) {
      z = data[(p - 1)];
      y = (data[p] -= ((z >> 5) ^ (y << 2)) + (((y >> 3) ^ (z << 4)) ^ (sum ^ y)) + (key[((p & 3) ^ e)] ^ z));
    }
    z = data[n - 1];
    y = (data[0] -= ((z >> 5) ^ (y << 2)) + (((y >> 3) ^ (z << 4)) ^ (sum ^ y)) + (key[((p & 3) ^ e)] ^ z));
    sum -= DELTA;
  }
}

int align(int len, int step) {
  return (len % step) ? (step*(len/step+1)) : len;
}

struct auto_free
{
  auto_free(char* p) : _p(p) {}
  ~auto_free(){ free(_p); }
  char* _p;
};

char teakey[MIN_LENGTH];
void init_tea_key(){
  static bool called = false;
  if(!called) {
    memset(teakey, 0, sizeof(teakey));
    char const * key = "^~*&udy3892(*)*GF^T^*(OU89y{}+_@";
    strncpy(teakey, key, sizeof(teakey));
    called = true;
  }
}

#define should_use_align ((long)(long*)1 != 1)

int Encrypt(char* data, int datalen, char key[MIN_LENGTH]) 
{
  if(datalen < MIN_LENGTH) return -1;
  if(datalen % 8) return -2;
  //if((int)data % 8) return -3;
  XXTEAEncrypt((long long*)(data), datalen/sizeof(long long), (long long*)key);
  return datalen;
}

int Decrypt(char* data, int datalen, char key[MIN_LENGTH])
{
  if(datalen < MIN_LENGTH) return -1;
  if(datalen % 8) return -2;
  //if((int)data % 8) return -3;
  XXTEADecrypt((long long*)data, datalen/sizeof(long long), (long long*)key);
  return datalen;
}

void add_crc(char * src, int len)
{
  unsigned short crc = calc_crc(src, len-2);
  memcpy(src+len-2, &crc, sizeof(crc));
}

bool check_crc(char * src, int len) 
{
  unsigned short crc1, crc2;
  crc1 = calc_crc(src, len-2);
  memcpy(&crc2, src+len-2, sizeof(crc2));
  return crc1 == crc2;
}

int encrypt_ts(char *src, int srcsize, char *dest, int destsize )
{
  init_tea_key();
  int ret;
  size_t srclen = *(unsigned short*)(src);
  if(srclen > (unsigned int)srcsize || srclen < 5) return -21;
  add_crc(src, srclen);
  int len = align(srclen, 8);
  if(destsize < (2 + len)) return -22;
  
  char * p1 = dest + 2;
  
  if(should_use_align) p1 = dest;
  
  memcpy(p1, src, srclen);
  memset(p1 + srclen, 0, len - srclen);
  
  if((ret =  Encrypt(p1, len, teakey)) < 0) return ret;
  
  if(p1 == dest) memmove(dest + 2, dest, len);
  
  *(unsigned short*)dest = 2 + len;

  return 2 + len;
}

int decrypt_ts(char *src, int srcsize, char *dest, int destsize)
{
  init_tea_key();
  int ret;
  size_t srclen = *(unsigned short*)(src);
  if(srclen > (unsigned int)srcsize || srclen < 5) return -21;
  int len = srclen -2;
  if(destsize < len) return -22;

  memcpy(dest, src+2, len);

  if((ret =  Decrypt(dest, len, teakey)) < 0) return ret;
  
  size_t contentlen = *(unsigned short*)dest;
  if(contentlen > (unsigned int)len) return -23;
  if(!check_crc(dest, contentlen)) return -24;

  return contentlen;
}

