#ifndef GL_SSC_BETCOUNT_H__
#define GL_SSC_BETCOUNT_H__




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

int gl_ssc_betlineBetcount(
        const BETLINE *betline);

int gl_ssc_betpartBetcount(
	    uint8 bettype,
	    const GL_BETPART* bp,
	    const SUBTYPE_PARAM* subparam);

int gl_ssc_DSPartBetcount(
		const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam);

int gl_ssc_FSPartBetcount(
		const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam);

int gl_ssc_YXFSPartBetcount(
		const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam);

int gl_ssc_HZPartBetcount(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam);

int gl_ssc_BDPartBetcount(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam);

int gl_ssc_BCPartBetcount(
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


#endif /* GL_SSC_BETCOUNT_H__ */
