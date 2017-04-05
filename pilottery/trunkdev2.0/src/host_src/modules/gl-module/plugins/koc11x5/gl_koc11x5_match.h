#ifndef GL_KOC11X5_MATCH_H__
#define GL_KOC11X5_MATCH_H__


#include "global.h"
#include "gl_inf.h"
#include "gl_koc11x5_db.h"



/*=========================================================================================================
 * 类型定义(struct、enum)等,如果是重要数据结构，要详细说明
 * Type Declarations(struct,enum etc.) and Brief Description
 * If it's Significant,Detailed Description Should Be Present
 * 使用类型回归本地常量定义(const)等，如果是重要数据结构，要详细说明
 * Recuve Declare Vars ,If important,Detailed Description is Required.
 =========================================================================================================*/

#pragma pack (1)



#pragma pack ()


/*=========================================================================================================
 * 外部函数定义，并对其进行简要说明
 * Functions Definitions and Brief Description
 =========================================================================================================*/

int gl_koc11x5_createDrawnum(
		const uint8 xcode[],
		uint8 len);//xcode长度

int gl_koc11x5_ticketMatch(
		const TICKET *ticket,
		const char *subtype,
		const char *division,
		uint32 matchRet[]);

int gl_koc11x5_betlineMatch(
		const BETLINE *betline,
		DIVISION_PARAM *division,
		uint32 matchRet[]);

int gl_koc11x5_betpartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam);

int gl_koc11x5_DSPartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam);

int gl_koc11x5_FSPartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam);

int gl_koc11x5_YXFSPartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam);

int gl_koc11x5_HZPartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam);




/*************************************************************************************************************/

/*=========================================================================================================
 * 外部函数定义，并对其进行简要说明
 * Functions Definitions and Brief Description
 =========================================================================================================*/

/*=========================================================================================================
 * 实现在gl_digit.cpp
 * 外部函数定义，并对其进行简要说明
 * Functions Definitions and Brief Description
 =========================================================================================================*/


/*=========================================================================================================
 * 内联函数定义，并对其进行简要说明
 * Static Inline Functions Definitions and Brief Description
 =========================================================================================================*/


/***************************************************************************************************************/


#endif /* GL_KOC11X5_MATCH_H__ */

