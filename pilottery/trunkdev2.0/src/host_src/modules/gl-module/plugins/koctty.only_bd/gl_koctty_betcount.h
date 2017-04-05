#ifndef GL_KOCTTY_BETCOUNT_H__
#define GL_KOCTTY_BETCOUNT_H__




/*=========================================================================================================
 * ȫ�ֳ�����ֵ�궨�壬��������м�Ҫ˵��
 * Global Constant & Macro Definitions and Brief Description
 =========================================================================================================*/

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

int gl_koctty_betlineBetcount(
        const BETLINE *betline);

int gl_koctty_betpartBetcount(
	    uint8 bettype,
	    const GL_BETPART* bp,
	    const SUBTYPE_PARAM* subparam);

int gl_koctty_DSPartBetcount(
		const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam);

int gl_koctty_FSPartBetcount(
		const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam);

int gl_koctty_YXFSPartBetcount(
		const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam);

int gl_koctty_FWPartBetcount(
        const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam);

int gl_koctty_HZPartBetcount(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam);

int gl_koctty_BDPartBetcount(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam);

int gl_koctty_BCPartBetcount(
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


#endif /* GL_KOCTTY_BETCOUNT_H__ */

