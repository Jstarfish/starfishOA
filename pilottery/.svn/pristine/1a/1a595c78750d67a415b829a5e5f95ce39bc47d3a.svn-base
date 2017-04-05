#include "gl_ssc_match.h"

/*=========================================================================================================
 * 全局常量及值宏定义，并对其进行简要说明
 * Global Constant & Macro Definitions and Brief Description
 =========================================================================================================*/
static GL_SSC_DRAWNUM ssc_drawnum;

int gl_ssc_drawnumDXDY(
	uint8 gw,
	uint8 sw,
	uint8 out[])
{
	if (gw > 4) {
		out[0] = (out[0] | (0x01 << 0));
	} else {
		out[0] = (out[0] | (0x01 << 1));
	}
	if (0 != gw % 2) {
		out[0] = (out[0] | (0x01 << 2));
	} else {
		out[0] = (out[0] | (0x01 << 3));
	}

	if (sw > 4) {
		out[2] = (out[2] | (0x01 << 0));
	} else {
		out[2] = (out[2] | (0x01 << 1));
	}
	if (0 != sw % 2) {
		out[2] = (out[2] | (0x01 << 2));
	} else {
		out[2] = (out[2] | (0x01 << 3));
	}

	return 0;
}

int gl_ssc_drawnumZUX(
		const uint8 in[],
		uint8 count,
		uint8 out[][3])
{
	if (2 == count) {
		out[0][0] = in[0];
		out[0][1] = in[1];
		out[1][0] = in[1];
		out[1][1] = in[0];
	} else if (6 == count) {
		out[0][0] = in[0];
		out[0][1] = in[1];
		out[0][2] = in[2];

		out[1][0] = in[0];
		out[1][1] = in[2];
		out[1][2] = in[1];

		out[2][0] = in[1];
		out[2][1] = in[0];
		out[2][2] = in[2];

		out[3][0] = in[1];
		out[3][1] = in[2];
		out[3][2] = in[0];

		out[4][0] = in[2];
		out[4][1] = in[0];
		out[4][2] = in[1];

		out[5][0] = in[2];
		out[5][1] = in[1];
		out[5][2] = in[0];
	}

	return 0;
}

int gl_ssc_createDrawnum(
		const uint8 xcode[],
		uint8 len)//xcode长度
{
    log_debug("gl_createDrawnum xcode [%d]:[%d]:[%d]:[%d]:[%d]",
    		xcode[0], xcode[1], xcode[2], xcode[3], xcode[4]);

    memset(&ssc_drawnum, 0, sizeof(ssc_drawnum));

	if (len != 5){
		log_error("ssc_drawnum len error, len[%d]", len);
		return -1;
	}

	uint8 xcode_2[2] = {0};
	uint8 xcode_3[3] = {0};
	xcode_2[0] = xcode[3];
	xcode_2[1] = xcode[4];
	xcode_3[0] = xcode[2];
	xcode_3[1] = xcode[3];
	xcode_3[2] = xcode[4];

	ssc_drawnum.hz2 = xcode_2[0] + xcode_2[1];
	ssc_drawnum.hz3 = xcode_3[0] + xcode_3[1] + xcode_3[2];
	ssc_drawnum.distribute2 = drawnumDistribute(xcode_2, 2);
	ssc_drawnum.distribute3 = drawnumDistribute(xcode_3, 3);
	gl_ssc_drawnumDXDY(xcode_2[1], xcode_2[0], ssc_drawnum.dxds);

    num2bit(xcode_2, 2, ssc_drawnum.pmap2, 0, 0);
    num2bit(xcode_3, 3, ssc_drawnum.pmap3, 0, 0);

    if (21000000 == ssc_drawnum.distribute3)
    {
    	uint8 t[2] = {0};
    	if (xcode_3[0] == xcode_3[1])
    	{
    		t[0] = xcode_3[0];
    		t[1] = xcode_3[2];
    	} else if (xcode_3[0] == xcode_3[2])
    	{
    		t[0] = xcode_3[0];
    		t[1] = xcode_3[1];
    	} else
    	{
    		t[0] = xcode_3[1];
    		t[1] = xcode_3[0];
    	}
    	for (int i = 0; i < 2; i++)
    	{
			num2bit(&t[i], 1, ssc_drawnum.smapZ3, i * 2, 0);
		}
    }

    uint8 tmp[6][3] = {{0}};
    gl_ssc_drawnumZUX(xcode_2, 2, tmp);
    for (int i = 0; i < 2; i++) {
    	for (int j = 0; j < 2; j++) {
    		num2bit(&tmp[i][j], 1, ssc_drawnum.smap2[i], j * 2, 0);
    	}
    }

    memset(tmp, 0, sizeof(tmp));
    gl_ssc_drawnumZUX(xcode_3, 6, tmp);
    for (int i = 0; i < 6; i++) {
    	for (int j = 0; j < 3; j++) {
    		num2bit(&tmp[i][j], 1, ssc_drawnum.smap3[i], j * 2, 0);
    	}
    }

    for (int i = 0; i < 5; i++) {
    	num2bit(&xcode[i], 1, ssc_drawnum.smap, i * 2, 0);
    }

    return 0;
}

int gl_ssc_ticketMatch(
		const TICKET *ticket,
		const char *subtype,
		const char *division,
		uint32 matchRet[])
{
	ts_notused(subtype);
    memset(matchRet, 0, sizeof(uint32) * MAX_PRIZE_COUNT);
    BETLINE *betline = NULL;
    log_debug("gl_ticketMatch gameCode[%d],issueCnt[%d],betlineCnt[%d],tmoney[%lld]",
    		ticket->gameCode, ticket->issueCount, ticket->betlineCount, ticket->amount);
    log_debug("betString:%s", ticket->betString);

    for (int idx = 0; idx < ticket->betlineCount; idx++) {
        if (0==idx) {
            betline = (BETLINE*)GL_BETLINE(ticket);
        } else {
            betline = (BETLINE*)GL_BETLINE_NEXT(betline);
        }

        gl_ssc_betlineMatch(betline, (DIVISION_PARAM*)division, matchRet);
    }

    for (uint16 jdx = 0; jdx < MAX_PRIZE_COUNT; jdx++) {
        if (matchRet[jdx]>0) {
            return 1;
        }
    }

    return 0;
}

int gl_ssc_betlineMatch(
		const BETLINE *betline,
		DIVISION_PARAM *division,
		uint32 matchRet[])
{
    int ret = 0;
    log_notice( "enter gl_ssc_betlineMatch");
    char mutex[255] = {0};
    for(uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++) {
    	DIVISION_PARAM *divParam = division + jdx;

    	if ( (divParam == NULL) || (!divParam->used) ) {
            continue;
        }
        if (betline->subtype != divParam->subtypeCode) {
            continue;
        }
        if  (0 != divParam->A_distribute) {
        	if ( (divParam->A_baseEnd - divParam->A_baseBegin == 1) &&
        		 (ssc_drawnum.distribute2 != divParam->A_distribute) ){
        		continue;
        	}
        	if ( (divParam->A_baseEnd - divParam->A_baseBegin == 2) &&
				 (ssc_drawnum.distribute3 != divParam->A_distribute) ){
				continue;
			}
        }

        if (0 != divParam->mutex) {
        	if (0 != mutex[divParam->mutex]) {
        		continue;
        	}
        }

        ret = gl_ssc_betpartMatch(betline, divParam);
		matchRet[divParam->prizeCode] += ret * betline->betTimes;

		if ((0 != ret) && (0 != divParam->mutex))
		{
			mutex[divParam->mutex] = 1;
		}

        log_debug("gl_betlineMatch divCode[%d],prizeRet[%d]:[%d]",
        		   jdx, divParam->prizeCode, matchRet[divParam->prizeCode]);
    }

    return 0;
}

int gl_ssc_betpartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam)
{
	log_debug( "enter gl_betPartMatch");
	    switch (betline->bettype)
	    {
	    	default:
	    		break;
	        case BETTYPE_DS:
	        {
	            return gl_ssc_DSPartMatch(betline, divparam);
	            break;
	        }
	        case BETTYPE_FS:
	        {
	        	return gl_ssc_FSPartMatch(betline, divparam);
	            break;
	        }
	        case BETTYPE_YXFS:
	        {
	        	return gl_ssc_YXFSPartMatch(betline, divparam);
	            break;
	        }
	        case BETTYPE_HZ:
			{
				return gl_ssc_HZPartMatch(betline, divparam);
				break;
			}
	        case BETTYPE_BD:
			{
				return gl_ssc_BDPartMatch(betline, divparam);
				break;
			}
	        case BETTYPE_BC:
			{
				return gl_ssc_BCPartMatch(betline, divparam);
				break;
			}
	    }

	    return 0;
}

int gl_ssc_DSPartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam)
{
	log_debug("enter gl_DSPartMatch");

	int ret = 0;
	uint8 andRet[10] = {0};
	GL_BETPART* bp = GL_BETPART_A(betline);

	if (divparam->subtypeCode == SUBTYPE_3Z3) {
		ret = 0;
		for (int idx = 0; idx < 2; idx++) {
			memset(andRet, 0, sizeof(andRet));
			bitAnd(ssc_drawnum.smapZ3, idx * 2, bp->bitmap, idx * 2, 2, andRet);

			if (1 != bitCount(andRet, 0, 2)) {
				return 0;
			};

			ret++;
		}
		if (2 == ret) {
			return 1;
		}

	} else if (divparam->subtypeCode == SUBTYPE_DXDS)
    {
		for (int idx = divparam->A_baseBegin - 1; idx < divparam->A_baseEnd; idx++) {
			memset(andRet, 0, sizeof(andRet));
			bitAnd(bp->bitmap, idx * 2, ssc_drawnum.dxds, idx * 2, 2, andRet);
			if (1 != bitCount(andRet, 0, 2)) {
				log_debug("gl_DSPartMatch N");
				return 0;
			};
		}
		return 1;
    } else if (bp->mode == MODE_JC) {
		return gl_ssc_FSPartMatch(betline, divparam);
	} else {
		return gl_ssc_YXFSPartMatch(betline, divparam);
	}

	return 0;
}

int gl_ssc_FSPartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam)
{
    log_debug("enter gl_FSPartMatch");

	uint8 andRet[10] = {0};
	GL_BETPART* bp = GL_BETPART_A(betline);

    if(MODE_JC != bp->mode) {
    	return 0;
    }

    if (divparam->subtypeCode == SUBTYPE_2ZUX) {
    	memset(andRet, 0, sizeof(andRet));
		bitAnd(ssc_drawnum.pmap2, 0, bp->bitmap, 0, bp->size, andRet);
		int cnt = bitCount(andRet, 0, bp->size);
		if (cnt == 2) {
			return 1;
		}
    } else if (divparam->subtypeCode == SUBTYPE_3Z3) {
        memset(andRet, 0, sizeof(andRet));
        bitAnd(ssc_drawnum.pmap3, 0, bp->bitmap, 0, bp->size, andRet);
        int cnt = bitCount(andRet, 0, bp->size);
		if (cnt == 2) {
			return 1;
		}
	} else if (divparam->subtypeCode == SUBTYPE_3Z6){
		memset(andRet, 0, sizeof(andRet));
		bitAnd(ssc_drawnum.pmap3, 0, bp->bitmap, 0, bp->size, andRet);
		int cnt = bitCount(andRet, 0, bp->size);
		if (cnt == 3) {
			return 1;
		}
	}else if (divparam->subtypeCode == SUBTYPE_1ZX){
		memset(andRet, 0, sizeof(andRet));
		bitAnd(ssc_drawnum.smap, 4 * bp->size, bp->bitmap, 0, bp->size, andRet);
		int cnt = bitCount(andRet, 0, bp->size);
		if (cnt == 1) {
			return 1;
		}
	}

    return 0;
}

int gl_ssc_YXFSPartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam)
{
	   log_debug("enter gl_YXFSPartMatch");

		uint8 andRet[10] = {0};
		GL_BETPART* bp = GL_BETPART_A(betline);

	    if(MODE_FD != bp->mode) {
	    	return 0;
	    }

	    if (divparam->subtypeCode == SUBTYPE_2ZUX)
	    {
			int flag = 0;
		    int ret = 0;
	    	for (int k = 0; k < 2; k++) {
				flag = 0;
				for (int idx = 0; idx < bp->size / 2; idx++) {
					memset(andRet, 0, sizeof(andRet));
					bitAnd(bp->bitmap, idx * 2, ssc_drawnum.smap2[k], idx * 2, 2, andRet);

					if (1 != bitCount(andRet, 0, bp->size)) {
						flag = -1;
						break;
					}
				}
				//组选OK
				if (0 == flag)
				{
					ret++;
				}
			}

	    	return ret;//多个
	    } else
	    {
	        int jdx = divparam->A_baseBegin - 1;
	        if ( (divparam->subtypeCode == SUBTYPE_2ZX)
	          || (divparam->subtypeCode == SUBTYPE_2FX) ) {
	            jdx -= 3;
	        }
	        if ( (divparam->subtypeCode == SUBTYPE_3ZX)
              || (divparam->subtypeCode == SUBTYPE_3FX) ) {
                jdx -= 2;
            }
			for (int idx = divparam->A_baseBegin - 1; idx < divparam->A_baseEnd; idx++) {
				if (0 == bitCount(bp->bitmap, jdx * 2, 2)) {
					return 0;
				}
				memset(andRet, 0, sizeof(andRet));
				bitAnd(bp->bitmap, jdx * 2, ssc_drawnum.smap, idx * 2, 2, andRet);
				jdx++;
				if (1 != bitCount(andRet, 0, bp->size)) {
					log_debug("gl_YXFSPartMatch N");
					return 0;
				};
			}
	    }

		log_debug("gl_YXFSPartMatch Y");

	    return 1;
}

int gl_ssc_HZPartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam)
{
    log_debug("enter gl_HZPartMatch");

    GL_BETPART* bp = GL_BETPART_A(betline);

    switch(divparam->subtypeCode)
    {
    case SUBTYPE_2ZX:
    case SUBTYPE_2ZUX:
    	if (ssc_drawnum.hz2 == bp->bitmap[0])
    	{
    		return 1;
    	}
    	break;
    case SUBTYPE_3ZX:
    case SUBTYPE_3ZUX:
    	if (ssc_drawnum.hz3 == bp->bitmap[0])
    	{
    		return 1;
    	}
    	break;
    }

	return 0;
}

int gl_ssc_BDPartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam)
{
	ts_notused(divparam);
	log_debug("enter gl_BDPartMatch");

	uint8 andRet[10] = {0};
	GL_BETPART* bp = GL_BETPART_A(betline);

    if(MODE_FD != bp->mode) {
    	return 0;
    }

    int flag = 0;

	//组选3
	if (divparam->subtypeCode == SUBTYPE_3ZUX)
	{
		for (int k = 0; k < 6; k++) {
			flag = 0;
			for (int idx = 0; idx < bp->size / 2; idx++) {
				//判断空位（由于有任选的情况）
				if (0 == bitCount(bp->bitmap, idx * 2, 2)) {
					//continue;
				}
				memset(andRet, 0, sizeof(andRet));
				bitAnd(bp->bitmap, idx * 2, ssc_drawnum.smap3[k], idx * 2, 2, andRet);

				if (1 != bitCount(andRet, 0, bp->size)) {
					flag = -1;
					break;
				}
			}
			//组选OK
			if (0 == flag)
			{
				return 1;
			}
		}
	} else if (divparam->subtypeCode == SUBTYPE_2ZUX)
	{
		memset(andRet, 0, sizeof(andRet));
		bitAnd(ssc_drawnum.pmap2, 0, bp->bitmap, 0, bp->size, andRet);
		int cnt = bitCount(andRet, 0, bp->size);
		if (cnt == 1) {
			return 1;
		}
	}

	return 0;
}

int gl_ssc_BCPartMatch(
		const BETLINE *betline,
		const DIVISION_PARAM *divparam)
{
	ts_notused(divparam);
	log_debug("enter gl_BCPartMatch");

	uint8 andRet[10] = {0};
	GL_BETPART* bp = GL_BETPART_A(betline);

    if(MODE_JC != bp->mode) {
    	return 0;
    }

	memset(andRet, 0, sizeof(andRet));
	bitAnd(ssc_drawnum.pmap3, 0, bp->bitmap, 0, bp->size, andRet);
	int cnt = bitCount(andRet, 0, bp->size);
	if (cnt == 3) {
		return 1;
	} else {
		return 0;
	}
}

