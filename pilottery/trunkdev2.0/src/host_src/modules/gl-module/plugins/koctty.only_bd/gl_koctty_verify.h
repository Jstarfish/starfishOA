#ifndef GL_KOCTTY_VERIFY_H__
#define GL_KOCTTY_VERIFY_H__


#include "global.h"
#include "gl_inf.h"
#include "gl_koctty_db.h"



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
int gl_koctty_ticketVerify(
		const TICKET *ticket);

int gl_koctty_betlineVerify(
        const BETLINE *betline);

int gl_koctty_betpartVerify(
	    uint8 bettype,
	    const GL_BETPART* bp,
	    const SUBTYPE_PARAM* subparam);

int gl_koctty_DSPartVerify(
		const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam);

int gl_koctty_FSPartVerify(
		const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam);

int gl_koctty_YXFSPartVerify(
		const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam);

int gl_koctty_FWPartVerify(
        const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam);

int gl_koctty_HZPartVerify(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam);

int gl_koctty_BDPartVerify(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam);

int gl_koctty_BCPartVerify(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam);



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


#endif /* GL_KOCTTY_VERIFY_H__ */

