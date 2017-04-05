#include "global.h"
#include "gl_inf.h"
#include "gl_koc11x5_db.h"
#include "gl_koc11x5_betcount.h"


int gl_koc11x5_betlineBetcount(
        const BETLINE *betline)
{
    int ret = 0;
    log_notice("enter gl_betLineBetCount");
    uint8 subtype = betline->subtype;
    uint8 bettype = betline->bettype;

    SUBTYPE_PARAM* subparam = gl_koc11x5_getSubtypeParam(subtype);


    GL_BETPART* bpA = GL_BETPART_A(betline);
    ret = gl_koc11x5_betpartBetcount(bettype, bpA, subparam);

    log_notice("gl_betLineBetCount ret[%d]",ret);

    return ret;
}

int gl_koc11x5_betpartBetcount(
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
		case BETTYPE_DT:
		{
			ret = gl_koc11x5_DTPartBetcount(bp, subparam);
			break;
		}
        case BETTYPE_YXFS:
		{
			ret = gl_koc11x5_YXFSPartBetcount(bp, subparam);
			break;
		}
        case BETTYPE_FS:
        {
        	ret = gl_koc11x5_FSPartBetcount(bp, subparam);
        	break;
        }

	}

    return ret;
}


int gl_koc11x5_DTPartBetcount(
	const GL_BETPART *bp,
	const SUBTYPE_PARAM *subparam)
{
	ts_notused(subparam);
	int ret = 0;
	int dCnt = 0;
	int tCnt = 0;

	int subn = gl_koc11x5_subNum(subparam->subtypeCode);

	switch (bp->mode)
	{
	default:
		log_warn("gl_koc11x5_DTPartBetcount mode[%d] not support!",bp->mode);
		ret = -1;
		break;
	case MODE_FD:
		dCnt = bitCount(bp->bitmap, 0, 2);
		tCnt = bitCount(bp->bitmap, 2, 2);
		ret = mathc(tCnt, subn - dCnt);

		log_debug("gl_koc11x5_DTPartBetcount dCnt[%d] tCnt[%d] ret[%d]", dCnt, tCnt, ret);
		break;

	}

	return ret;
}


int gl_koc11x5_YXFSPartBetcount(
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


int gl_koc11x5_FSPartBetcount(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam)
{

	int expr = gl_koc11x5_subNum(subparam->subtypeCode);
    if(expr < 0)
	{
    	return -1;
	}

	int ret = 0;
	int bitcnt = 0;


    switch (bp->mode)
    {
        default:
        	log_warn("gl_koc11x5_FSPartBetcount mode[%d] not support!",bp->mode);
        	ret = -1;
            break;
        case MODE_JC:

            bitcnt = bitCount(bp->bitmap, 0, bp->size);
            ret = mathc(bitcnt, expr);
        	break;
    }

    return ret;
}

