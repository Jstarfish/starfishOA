#ifndef GL_SSC_MATCH_H__
#define GL_SSC_MATCH_H__


#include "global.h"
#include "gl_inf.h"
#include "gl_ssc_db.h"



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
int gl_ssc_drawnumDXDY(
	uint8 gw,
	uint8 sw,
	uint8 out[]);

int gl_ssc_drawnumZUX(
		const uint8 in[],
		uint8 count,
		uint8 out[][3]);

int gl_ssc_createDrawnum(
		const uint8 xcode[],
		uint8 len);//xcode����

int gl_ssc_ticketMatch(
		const TICKET *ticket,
		const char *subtype,
		const char *division,
		uint32 matchRet[]);

int gl_ssc_betlineMatch(
		const BETLINE *betline,
		DIVISION_PARAM *division,
		uint32 matchRet[]);

int gl_ssc_betpartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam);

int gl_ssc_DSPartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam);

int gl_ssc_FSPartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam);

int gl_ssc_YXFSPartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam);

int gl_ssc_HZPartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam);

int gl_ssc_BDPartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam);

int gl_ssc_BCPartMatch(
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


#endif /* GL_SSC_MATCH_H__ */

