#ifndef GL_KOCK3_MATCH_H__
#define GL_KOCK3_MATCH_H__


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

int gl_kock3_createDrawnum(
		const uint8 xcode[],
		uint8 len);//xcode����

int gl_kock3_ticketMatch(
		const TICKET *ticket,
		const char *subtype,
		const char *division,
		uint32 matchRet[]);

int gl_kock3_betlineMatch(
		const BETLINE *betline,
		DIVISION_PARAM *division,
		uint32 matchRet[]);

int gl_kock3_betpartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam);

int gl_kock3_DSPartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam);

int gl_kock3_HZPartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam);




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


#endif /* GL_KOCK3_MATCH_H__ */

