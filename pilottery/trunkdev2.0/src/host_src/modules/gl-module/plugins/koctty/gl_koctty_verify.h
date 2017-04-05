#ifndef GL_KOCTTY_VERIFY_H__
#define GL_KOCTTY_VERIFY_H__


#include "global.h"
#include "gl_inf.h"
#include "gl_koctty_db.h"



/*=========================================================================================================
 * ���Ͷ���(struct��enum)��,�������Ҫ���ݽṹ��Ҫ��ϸ˵��
 * Type Declarations(struct,enum etc.) and Brief Description
 * If it's Significant,Detailed Description Should Be Present
 * ʹ�����ͻع鱾�س�������(const)�ȣ��������Ҫ���ݽṹ��Ҫ��ϸ˵��
 * Recuve Declare Vars ,If important,Detailed Description is Required.
 =========================================================================================================*/

#pragma pack (1)



#pragma pack ()


/*=========================================================================================================
 * �ⲿ�������壬��������м�Ҫ˵��
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
 * �ⲿ�������壬��������м�Ҫ˵��
 * Functions Definitions and Brief Description
 =========================================================================================================*/

/*=========================================================================================================
 * ʵ����gl_digit.cpp
 * �ⲿ�������壬��������м�Ҫ˵��
 * Functions Definitions and Brief Description
 =========================================================================================================*/


/*=========================================================================================================
 * �����������壬��������м�Ҫ˵��
 * Static Inline Functions Definitions and Brief Description
 =========================================================================================================*/

/***************************************************************************************************************/


#endif /* GL_KOCTTY_VERIFY_H__ */

