#include "global.h"
#include "gl_inf.h"
#include "gl_ssc_db.h"
#include "gl_ssc_betcount.h"


int gl_ssc_betlineBetcount(
        const BETLINE *betline)
{
    int ret = 0;
    log_debug("enter gl_betLineBetCount");
    uint8 subtype = betline->subtype;
    uint8 bettype = betline->bettype;

    SUBTYPE_PARAM* subparam = gl_ssc_getSubtypeParam(subtype);
    switch(subparam->subtypeCode)
    {
    case SUBTYPE_2FX:
    	return 2;
    case SUBTYPE_3FX:
    	return 3;
    case SUBTYPE_5FX:
    	return 4;
    default:
    	break;
    }

    GL_BETPART* bpA = GL_BETPART_A(betline);
    ret = gl_ssc_betpartBetcount(bettype, bpA, subparam);

    log_debug("gl_betLineBetCount ret[%d]",
    		ret);

    return ret;
}

int gl_ssc_betpartBetcount(
	    uint8 bettype,
	    const GL_BETPART* bp,
	    const SUBTYPE_PARAM* subparam)
{
    log_debug("enter gl_betpartBetcount");

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
            ret = gl_ssc_DSPartBetcount(bp, subparam);
            break;
        }
        case BETTYPE_FS:
        {
            ret = gl_ssc_FSPartBetcount(bp, subparam);
            break;
        }
        case BETTYPE_YXFS:
		{
			ret = gl_ssc_YXFSPartBetcount(bp, subparam);
			break;
		}
        case BETTYPE_HZ:
		{
			ret = gl_ssc_HZPartBetcount(bp, subparam);
			break;
		}
        case BETTYPE_BD:
		{
			ret = gl_ssc_BDPartBetcount(bp, subparam);
			break;
		}
        case BETTYPE_BC:
		{
			ret = gl_ssc_BCPartBetcount(bp, subparam);
			break;
		}
	}

    return ret;
}

int gl_ssc_DSPartBetcount(
		const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam)
{
	ts_notused(bp);
	ts_notused(subparam);
	return 1;
}

int gl_ssc_FSPartBetcount(
		const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam)
{
	int ret = 0;
	int bitcnt = 0;

    switch (bp->mode)
    {
        default:
        	log_warn("gl_FSPartBetcount mode not support!!!");
        	ret = -1;
            break;
        case MODE_JC:
        	bitcnt = bitCount(bp->bitmap, 0, bp->size);
        	if (SUBTYPE_3Z3 == subparam->subtypeCode) {
        		ret = mathp(bitcnt, 2);
        	} else if (SUBTYPE_2ZUX == subparam->subtypeCode) {
        		ret = mathc(bitcnt, 2);
        	} else {
        		ret = mathc(bitcnt, 3);
        	}
            break;

    }

    return ret;
}

int gl_ssc_YXFSPartBetcount(
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

int gl_ssc_HZPartBetcount(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam)
{
	int ret = 0;
	switch(subparam->subtypeCode)
	{
	case SUBTYPE_2ZX:
		ret = table_ssc.zxhz2[bp->bitmap[0]];
		break;
	case SUBTYPE_2ZUX:
		ret = table_ssc.zuxhz2[bp->bitmap[0]];
		break;
	case SUBTYPE_3ZX:
		ret = table_ssc.zxhz3[bp->bitmap[0]];
		break;
	case SUBTYPE_3ZUX:
		ret = table_ssc.zuxhz3[bp->bitmap[0]];
		break;
	default:
		ret = -1;
		break;
	}

	return ret;
}

int gl_ssc_BDPartBetcount(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam)
{
	ts_notused(subparam);
	int ret = 0;
    int bitcnt = bitCount(bp->bitmap, 0, bp->size);

	switch(subparam->subtypeCode)
	{
	case SUBTYPE_2ZUX:
		if (1 == bitcnt) {
			ret = table_ssc.zuxbd2[1];
		}

		break;
	case SUBTYPE_3ZUX:
		if (1 == bitcnt) {
			ret = table_ssc.zuxbd3[1];
		} else if (2 == bitcnt) {
			ret = table_ssc.zuxbd3[2];
		}
		break;
	default:
		ret = -1;
		break;
	}


	return ret;
}

int gl_ssc_BCPartBetcount(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam)
{
	ts_notused(subparam);
	int ret = 0;
    int bitcnt = bitCount(bp->bitmap, 0, bp->size);
    if (bitcnt < 3 || bitcnt > 9) {
    	return -1;
    }
    ret = table_ssc.zxbc[bitcnt];

    return ret;
}





