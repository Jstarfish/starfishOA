#ifndef HCTYPE_H_INCLUDED
#define HCTYPE_H_INCLUDED



/*==============================================================================
 * 全局常量及值宏定义，并对其进行简要说明
 * Global Constant & Macro Definitions and Brief Description
 =============================================================================*/
#define true  1
#define false 0

#define SUCC  0
#define ERROR -1

#define null NULL

/*==============================================================================
 * 类型定义(struct、enum)等,如果是重要数据结构，要详细说明
 * Type Declarations(struct,enum etc.) and Brief Description
 * If it's Significant,Detailed Description Should Be Present
 =============================================================================*/

typedef signed char int8;
typedef signed short int16;
typedef signed int int32;

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;

/*
typedef unsigned short ushort;

typedef unsigned long ulong;
typedef unsigned long point_t;
*/

typedef void* voidptr;

typedef long long int64;
typedef unsigned long long uint64;

typedef int64 money_t;
//typedef unsigned long time_type;
//typedef time_t time_type;
typedef uint32 time_type;


/*
typedef struct VAR8DATAREGION{
   uint8 varsize;
   char  vardata[256];
}VAR8DATA;

typedef struct VAR16DATAREGION{
    uint16 varsize;
    char vardata[1024];
}VAR16DATA;
*/

#define ts_notused(V) ((void) V)

#endif // HCTYPE_H_INCLUDED
