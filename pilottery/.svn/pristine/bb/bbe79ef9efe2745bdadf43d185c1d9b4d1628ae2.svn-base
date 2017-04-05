#include "gl_koc11x5_match.h"

/*=========================================================================================================
 * 全局常量及值宏定义，并对其进行简要说明
 * Global Constant & Macro Definitions and Brief Description
 =========================================================================================================*/
static GL_KOC11X5_DRAWNUM koc11x5_drawnum;



int gl_koc11x5_createDrawnum(
        const uint8 xcode[],
        uint8 len)//xcode长度
{
    log_debug("gl_createDrawnum xcode [%d]:[%d]:[%d]:[%d]:[%d]",
            xcode[0], xcode[1], xcode[2], xcode[3], xcode[4]);

    memset(&koc11x5_drawnum, 0, sizeof(koc11x5_drawnum));

    if (len != 5){
        log_error("koc11x5_drawnum len error, len[%d]", len);
        return -1;
    }

    uint8 cinNum[5] = {xcode[0],xcode[1],xcode[2],xcode[3],xcode[4] };
    num2bit( cinNum,5,(uint8 *)&(koc11x5_drawnum.allbitmap),0,1);

    for (int i = 0; i < 4; i++) {

		num2bit(&xcode[i], 1, (uint8 *)&(koc11x5_drawnum.zx5_bitmap[i * 2]), 0, 1);
		koc11x5_drawnum.win_uint[i] = xcode[i];
    }

    return 0;
}


int gl_koc11x5_Match_RX(
	const BETLINE *betline,
	DIVISION_PARAM *division,
	uint32 matchRet[])
{
	int ret = 0;
	int cnt = 0;
    int ant = 0;
	uint8 andRet[10] = { 0 };

	uint8 dcount = 0;
    uint8 tcount = 0;
	uint8 dmatch = 0;
	uint8 tmatch = 0;

    int subn = gl_koc11x5_subNum(betline->subtype);

	GL_BETPART* bp = GL_BETPART_A(betline);

	for (uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++) {
		DIVISION_PARAM *divParam = division + jdx;

		if (divParam == NULL)
		{
			continue;
		}
		if ((!divParam->used) || (divParam->subtypeCode != betline->subtype))
		{
			continue;
		}

		if (BETTYPE_DT == betline->bettype)
		{
			dcount = bitCount(bp->bitmap, 0, 2);
			memset(andRet, 0, sizeof(andRet));
			bitAnd((uint8 *)&(koc11x5_drawnum.allbitmap), 0, bp->bitmap, 0, 2, andRet);
			dmatch = bitCount(andRet, 0, 2);

            tcount = bitCount(bp->bitmap, 2, 2);
			memset(andRet, 0, sizeof(andRet));
			bitAnd((uint8 *)&(koc11x5_drawnum.allbitmap), 0, bp->bitmap, 2, 2, andRet);
			tmatch = bitCount(andRet, 0, 2);

            if (subn <= 5)
            {
                if (dcount != dmatch) continue;
                if ((dmatch + tmatch) >= divParam->matchCount)
                {
                    matchRet[divParam->prizeCode] += betline->betTimes * mathc(tmatch, divParam->matchCount - dmatch);
                    ret++;
                }
            }
            else
            {
                if ( (dmatch + tmatch == 5) && (5 - dmatch <= subn - dcount))
                {
                    matchRet[divParam->prizeCode] += betline->betTimes * mathc(tcount - tmatch, subn - dcount - tmatch);
                    ret++;
                }
            }

		}
		else 
		{
            ant = bitCount(bp->bitmap, 0, bp->size);
			memset(andRet, 0, sizeof(andRet));
			bitAnd((uint8 *)&(koc11x5_drawnum.allbitmap), 0, bp->bitmap, 0, bp->size, andRet);
			cnt = bitCount(andRet, 0, bp->size);
			if (cnt >= divParam->matchCount)
			{
                if (subn <= 5)
                {
                    matchRet[divParam->prizeCode] += betline->betTimes * mathc(cnt, divParam->matchCount);
                }
                else
                {
                    matchRet[divParam->prizeCode] += betline->betTimes * mathc(ant - cnt, subn - cnt);
                }
                ret++;
			}
		}

	}

	return ret;
}


int gl_koc11x5_Match_ZU(
	const BETLINE *betline,
	DIVISION_PARAM *division,
	uint32 matchRet[])
{
	int ret = 0;
	int cnt = 0;
	uint8 andRet[10] = { 0 };

	uint8 tmp[3] = { 0 };
	uint16 winbitmap = 0;

	uint8 dcount = 0;
	uint8 dmatch = 0;
	uint8 tmatch = 0;

	GL_BETPART* bp = GL_BETPART_A(betline);

	for (uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++) {
		DIVISION_PARAM *divParam = division + jdx;

		if (divParam == NULL)
		{
			continue;
		}
		if ((!divParam->used) || (divParam->subtypeCode != betline->subtype))
		{
			continue;
		}

		for (int i = 0; i < divParam->matchCount; i++)
		{
			tmp[i] = koc11x5_drawnum.win_uint[i];
		}
		num2bit(tmp, divParam->matchCount, (uint8 *)&winbitmap, 0, 1);

		if (BETTYPE_DT == betline->bettype)
		{
			dcount = bitCount(bp->bitmap, 0, 2);
			memset(andRet, 0, sizeof(andRet));
			bitAnd((uint8 *)&winbitmap, 0, bp->bitmap, 0, 2, andRet);
			dmatch = bitCount(andRet, 0, 2);
			if (dcount != dmatch)
				continue;

			memset(andRet, 0, sizeof(andRet));
			bitAnd((uint8 *)&winbitmap, 0, bp->bitmap, 2, 2, andRet);
			tmatch = bitCount(andRet, 0, 2);

			if ((dmatch + tmatch) >= divParam->matchCount)
			{
				matchRet[divParam->prizeCode] += betline->betTimes * mathc(tmatch, divParam->matchCount - dmatch);
				ret++;
			}
		}
		else
		{
			memset(andRet, 0, sizeof(andRet));
			bitAnd((uint8 *)&winbitmap, 0, bp->bitmap, 0, bp->size, andRet);
			cnt = bitCount(andRet, 0, bp->size);
			if (cnt >= divParam->matchCount)
			{
				matchRet[divParam->prizeCode] += betline->betTimes * mathc(cnt, divParam->matchCount);
				ret++;
			}
		}

	}

	return ret;
}


int gl_koc11x5_Match_ZX(
	const BETLINE *betline,
	DIVISION_PARAM *division,
	uint32 matchRet[])
{
	int ret = 0;
	int cnt = 0;
	uint8 andRet[10] = { 0 };

	GL_BETPART* bp = GL_BETPART_A(betline);

	for (uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++)
	{
		DIVISION_PARAM *divParam = division + jdx;

		if (divParam == NULL)
		{
			continue;
		}
		if ((!divParam->used) || (divParam->subtypeCode != betline->subtype))
		{
			continue;
		}

		for (int idx = 0; idx < divParam->matchCount; idx++)
		{
			memset(andRet, 0, sizeof(andRet));
			bitAnd(bp->bitmap, idx * 2, koc11x5_drawnum.zx5_bitmap, idx * 2, 2, andRet);
			cnt += bitCount(andRet, 0, bp->size);
		}
		if (cnt == divParam->matchCount)
		{
			matchRet[divParam->prizeCode] += betline->betTimes;
			ret++;
		}

	}

	return ret;
}


int gl_koc11x5_ticketMatch(
        const TICKET *ticket,
        const char *subtype,
        const char *division,
        uint32 matchRet[])
{
    ts_notused(subtype);
    memset(matchRet, 0, sizeof(uint32) * MAX_PRIZE_COUNT);
    BETLINE *betline = NULL;

    for (int idx = 0; idx < ticket->betlineCount; idx++)
    {
        if (0 == idx) {
            betline = (BETLINE*)GL_BETLINE(ticket);
        } else {
            betline = (BETLINE*)GL_BETLINE_NEXT(betline);
        }

        switch(betline->subtype)
        {
        case SUBTYPE_RX2:
		case SUBTYPE_RX3:
		case SUBTYPE_RX4:
		case SUBTYPE_RX5:
		case SUBTYPE_RX6:
		case SUBTYPE_RX7:
		case SUBTYPE_RX8:
			gl_koc11x5_Match_RX(betline, (DIVISION_PARAM*)division, matchRet);
			break;
        case SUBTYPE_Q1:
		case SUBTYPE_Q2ZU:
		case SUBTYPE_Q3ZU:
        	gl_koc11x5_Match_ZU(betline, (DIVISION_PARAM*)division, matchRet);
        	break;
		case SUBTYPE_Q2ZX:
		case SUBTYPE_Q3ZX:
        	gl_koc11x5_Match_ZX(betline, (DIVISION_PARAM*)division, matchRet);
        	break;

        }
    }

    for (uint16 jdx = 0; jdx < MAX_PRIZE_COUNT; jdx++) {
        if (matchRet[jdx]>0) {
			log_debug("gl_koc11x5_ticketMatch bet[%s],price[%d] wincount[%d]", ticket->betString, jdx, matchRet[jdx]);
            return 1;
        }
    }

    return 0;
}


