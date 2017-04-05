#include "global.h"
#include "gl_inf.h"
#include "gl_koctty_db.h"
#include "gl_koctty_betcount.h"


int gl_koctty_betlineBetcount(
        const BETLINE *betline)
{
    int ret = 0;
    log_notice("enter gl_betLineBetCount");
    uint8 subtype = betline->subtype;
    uint8 bettype = betline->bettype;

    SUBTYPE_PARAM* subparam = gl_koctty_getSubtypeParam(subtype);


    GL_BETPART* bpA = GL_BETPART_A(betline);
    ret = gl_koctty_betpartBetcount(bettype, bpA, subparam);

    log_notice("gl_betLineBetCount ret[%d]",ret);

    return ret;
}

int gl_koctty_betpartBetcount(
	    uint8 bettype,
	    const GL_BETPART* bp,
	    const SUBTYPE_PARAM* subparam)
{
	log_notice("enter gl_betpartBetcount");

    int ret = 0;
    switch (bettype)
	{
    	default:
        {
            log_warn("gl_betpartBetcount bettype[%d] fail!!!",
            		bettype);
            ret = -1;
            break;
        }
        case BETTYPE_DS:
        {
            ret = 1;
            break;
        }
        case BETTYPE_YXFS:
		{
			ret = gl_koctty_YXFSPartBetcount(bp, subparam);
			break;
		}
        case BETTYPE_FW:
        {
            ret = gl_koctty_FWPartBetcount(bp, subparam);
            break;
        }
        case BETTYPE_BC:
        {
        	ret = gl_koctty_BCPartBetcount(bp, subparam);
        	break;
        }


	}

    return ret;
}


int gl_koctty_YXFSPartBetcount(
		const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam)
{
	ts_notused(subparam);
	int ret = 0;
	int bitcnt = 0;
	int cnt = 1;

    switch (bp->mode)
    {
        default:
        	log_warn("gl_YXFSPartBetcount mode not support!!!");
        	ret = -1;
            break;
        case MODE_FD:
			int i = 0;
			for (; i < bp->size / 2; i++) {
				bitcnt = bitCount(bp->bitmap, i * 2, 2);
				if (bitcnt != 0) {
					cnt *= bitcnt;
				}
			}
			if (cnt > 1) {
				ret = cnt;
			}
        	break;
    }

    return ret;
}

int gl_koctty_FWPartBetcount(
        const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam)
{
    ts_notused(subparam);
    int ret = 0;
    char str[5] = {0};
    int numOne = 0;
    int numTwo = 0;



    switch (bp->mode)
    {
        default:
            log_warn("gl_FWPartBetcount mode not support!!!");
            ret = -1;
            break;
        case MODE_YS:
            memcpy(str, bp->bitmap, bp->size / 2);
            numOne = atoi(str);
            numTwo = atoi((char*)&bp->bitmap[bp->size/2]);
            ret = numTwo - numOne + 1;

            break;
    }

    return ret;
}



int gl_koctty_BCPartBetcount(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam)
{

	int expr = 0;
	switch(subparam->subtypeCode)
	{
	case SUBTYPE_QH2:
	case SUBTYPE_Q2:
	case SUBTYPE_H2:
		expr = 2;
		break;
	case SUBTYPE_QH3:
	case SUBTYPE_Q3:
	case SUBTYPE_H3:
		expr = 3;
		break;
	case SUBTYPE_4ZX:
		expr = 4;
		break;
	default:
    	log_warn("gl_koctty_BCPartBetcount subtype[%d] not support!",subparam->subtypeCode);
    	return -1;
	}


	int ret = 0;
	int bitcnt = 0;


    switch (bp->mode)
    {
        default:
        	log_warn("gl_koctty_BCPartBetcount mode[%d] not support!",bp->mode);
        	ret = -1;
            break;
        case MODE_JC:

            bitcnt = bitCount(bp->bitmap, 0, bp->size);
            ret = mathp(bitcnt, expr);
        	break;
    }

    return ret;
}

