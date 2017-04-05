#ifndef GL_KOCK3_VERIFY_H__
#define GL_KOCK3_VERIFY_H__


#include "global.h"
#include "gl_inf.h"
#include "gl_kock3_db.h"



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
int gl_kock3_ticketVerify(
		const TICKET *ticket);

int gl_kock3_betlineVerify(
        const BETLINE *betline);

int gl_kock3_betpartVerify(
	    uint8 bettype,
	    const GL_BETPART* bp,
	    const SUBTYPE_PARAM* subparam);

int gl_kock3_DSPartVerify(
		const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam);

int gl_kock3_FSPartVerify(
		const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam);

int gl_kock3_YXFSPartVerify(
		const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam);

int gl_kock3_FWPartVerify(
        const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam);

int gl_kock3_HZPartVerify(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam);

int gl_kock3_BDPartVerify(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam);

int gl_kock3_BCPartVerify(
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


#endif /* GL_KOCK3_VERIFY_H__ */

