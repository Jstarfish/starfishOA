#include "gl_kock3_match.h"

/*=========================================================================================================
 * 全局常量及值宏定义，并对其进行简要说明
 * Global Constant & Macro Definitions and Brief Description
 =========================================================================================================*/
static GL_KOCK3_DRAWNUM kock3_drawnum;

bool isThreeOrderNum(uint16 number)
{
	return( (number == 123) || (number == 234) || (number == 345) || (number == 456) );
}

uint16 gl_sortNumThree(uint16 number)
{
	uint8 array[3] = {0};
	array[0] = number / 100;
	array[1] = (number - array[0]*100) / 10;
	array[2] = number % 10;
	uint16 end = 0;
	uint16 times = 1;
	uint8 ret[10] = {0};
	for(int i = 0; i < 3; i++)
	{
		ret[array[i]]++;
	}
	for(int j = 9; j >= 0; j--)
	{
		for(int k = 0; k < ret[j]; k++)
		{
			end += j * times;
			times *= 10;
		}
	}
	return end;
}



int gl_kock3_createDrawnum(
        const uint8 xcode[],
        uint8 len)//xcode长度
{
    log_debug("gl_createDrawnum xcode [%d]:[%d]:[%d]",
            xcode[0], xcode[1], xcode[2]);

    memset(&kock3_drawnum, 0, sizeof(kock3_drawnum));

    if (len != 3){
        log_error("kock3_drawnum len error, len[%d]", len);
        return -1;
    }

    kock3_drawnum.winNum = gl_sortArray(xcode,3);
    kock3_drawnum.hz = xcode[0] + xcode[1] + xcode[2];

    if((xcode[0] == xcode[1]) && (xcode[1] == xcode[2]))
    {
        kock3_drawnum.threeSame = true;
        kock3_drawnum.threeDiff = false;
        kock3_drawnum.threeOrder = false;
        kock3_drawnum.twoDiff = false;

        kock3_drawnum.twoSame = true;
        kock3_drawnum.twoSameNum = xcode[0] * 10 + xcode[0];
    }
    else if((xcode[0] != xcode[1]) && (xcode[1] != xcode[2]) && (xcode[0] != xcode[2]) )
    {
        kock3_drawnum.threeSame = false;
        kock3_drawnum.threeDiff = true;
        kock3_drawnum.twoDiff = true;

        kock3_drawnum.twoDiffCount = 3;
        kock3_drawnum.twoDiffArray[0] = kock3_drawnum.winNum / 10;
        kock3_drawnum.twoDiffArray[1] = kock3_drawnum.winNum % 100;
        kock3_drawnum.twoDiffArray[2] = (kock3_drawnum.winNum / 100 * 10) + (kock3_drawnum.winNum % 10);

        kock3_drawnum.twoSame = false;
        if(isThreeOrderNum(kock3_drawnum.winNum))
        	kock3_drawnum.threeOrder = true;
        else
        	kock3_drawnum.threeOrder = false;
    }
    else
    {
    	kock3_drawnum.threeDiff = false;
    	kock3_drawnum.threeSame = false;
    	kock3_drawnum.threeOrder = false;
    	kock3_drawnum.twoDiff = true;

    	kock3_drawnum.twoDiffCount = 1;
    	kock3_drawnum.twoDiffArray[0] = (kock3_drawnum.winNum / 100 * 10) + (kock3_drawnum.winNum % 10);

    	kock3_drawnum.twoSame = true;
    	if((xcode[0] == xcode[1]) || (xcode[0] == xcode[2]))
    		kock3_drawnum.twoSameNum = xcode[0] * 10 + xcode[0];
    	else
    		kock3_drawnum.twoSameNum = xcode[1] * 10 + xcode[1];
    }

    return 0;
}






void gl_kock3_Match_3TA(
        const BETLINE *betline,
        DIVISION_PARAM *division,
        uint32 matchRet[])
{
    if(kock3_drawnum.threeSame)
    {
		for(uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++)
		{
			DIVISION_PARAM *divParam = division + jdx;

			if (divParam == NULL)
			{
				continue;
			}

			if( (!divParam->used) || (divParam->subtypeCode != SUBTYPE_3TA ) )
			{
				continue;
			}

            matchRet[divParam->prizeCode] += betline->betTimes;
            log_debug("gl_kock3_Match_3TA divCode[%d],prizeRet[%d]:betTimes[%d]",
                                   jdx, divParam->prizeCode, betline->betTimes);
            break;

		}
    }

    return;
}

void gl_kock3_Match_3TS(
        const BETLINE *betline,
        DIVISION_PARAM *division,
        uint32 matchRet[])
{

    GL_BETPART* bp = GL_BETPART_A(betline);

    int betN = atoi((char *)(bp->bitmap));
    if((kock3_drawnum.threeSame) && (kock3_drawnum.winNum == betN) )
    {
		for(uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++)
		{
			DIVISION_PARAM *divParam = division + jdx;

			if (divParam == NULL)
			{
				continue;
			}

			if( (!divParam->used) || (divParam->subtypeCode != SUBTYPE_3TS ) )
			{
				continue;
			}

            matchRet[divParam->prizeCode] += betline->betTimes;
            log_debug("gl_kock3_Match_3TS divCode[%d],prizeRet[%d]:betTimes[%d]",
                                   jdx, divParam->prizeCode, betline->betTimes);
            break;

		}
    }

    return;
}


void gl_kock3_Match_3QA(
        const BETLINE *betline,
        DIVISION_PARAM *division,
        uint32 matchRet[])
{
    if(kock3_drawnum.threeOrder)
    {
		for(uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++)
		{
			DIVISION_PARAM *divParam = division + jdx;

			if (divParam == NULL)
			{
				continue;
			}

			if( (!divParam->used) || (divParam->subtypeCode != SUBTYPE_3QA ) )
			{
				continue;
			}

            matchRet[divParam->prizeCode] += betline->betTimes;
            log_debug("gl_kock3_Match_3QA divCode[%d],prizeRet[%d]:betTimes[%d]",
                                   jdx, divParam->prizeCode, betline->betTimes);
            break;

		}
    }

    return;
}

void gl_kock3_Match_3DS(
        const BETLINE *betline,
        DIVISION_PARAM *division,
        uint32 matchRet[])
{
    GL_BETPART* bp = GL_BETPART_A(betline);

    uint16 betN = gl_sortNumThree( atoi((char *)(bp->bitmap)));
    if((kock3_drawnum.threeDiff) && (kock3_drawnum.winNum == betN) )
    {
		for(uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++)
		{
			DIVISION_PARAM *divParam = division + jdx;

			if (divParam == NULL)
			{
				continue;
			}

			if( (!divParam->used) || (divParam->subtypeCode != SUBTYPE_3DS ) )
			{
				continue;
			}

            matchRet[divParam->prizeCode] += betline->betTimes;
            log_debug("gl_kock3_Match_3DS divCode[%d],prizeRet[%d]:betTimes[%d]",
                                   jdx, divParam->prizeCode, betline->betTimes);
            break;

		}
    }

    return;
}


void gl_kock3_Match_2TA(
        const BETLINE *betline,
        DIVISION_PARAM *division,
        uint32 matchRet[])
{
    GL_BETPART* bp = GL_BETPART_A(betline);

    if((kock3_drawnum.twoSame) && (kock3_drawnum.twoSameNum == bp->bitmap[0]) )
    {
		for(uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++)
		{
			DIVISION_PARAM *divParam = division + jdx;

			if (divParam == NULL)
			{
				continue;
			}

			if( (!divParam->used) || (divParam->subtypeCode != SUBTYPE_2TA ) )
			{
				continue;
			}

            matchRet[divParam->prizeCode] += betline->betTimes;
            log_debug("gl_kock3_Match_2TA divCode[%d],prizeRet[%d]:betTimes[%d]",
                                   jdx, divParam->prizeCode, betline->betTimes);
            break;

		}
    }

    return;
}


void gl_kock3_Match_2TS(
        const BETLINE *betline,
        DIVISION_PARAM *division,
        uint32 matchRet[])
{
    GL_BETPART* bp = GL_BETPART_A(betline);

    uint16 betN = gl_sortNumThree( atoi((char *)(bp->bitmap)));

    if((kock3_drawnum.twoSame) && (kock3_drawnum.winNum == betN) )
    {
		for(uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++)
		{
			DIVISION_PARAM *divParam = division + jdx;

			if (divParam == NULL)
			{
				continue;
			}

			if( (!divParam->used) || (divParam->subtypeCode != SUBTYPE_2TS ) )
			{
				continue;
			}

            matchRet[divParam->prizeCode] += betline->betTimes;
            log_debug("gl_kock3_Match_2TS divCode[%d],prizeRet[%d]:betTimes[%d]",
                                   jdx, divParam->prizeCode, betline->betTimes);
            break;

		}
    }

    return;
}


void gl_kock3_Match_2DS(
        const BETLINE *betline,
        DIVISION_PARAM *division,
        uint32 matchRet[])
{
    GL_BETPART* bp = GL_BETPART_A(betline);
    int ret = 0;
    if(kock3_drawnum.twoDiff)
    {
    	for(int idx = 0; idx < kock3_drawnum.twoDiffCount; idx++)
    	{
    		if(kock3_drawnum.twoDiffArray[idx] == bp->bitmap[0])
    		{
    			ret++;
    		}
    	}
    	if(ret > 0)
    	{
			for(uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++)
			{
				DIVISION_PARAM *divParam = division + jdx;

				if (divParam == NULL)
				{
					continue;
				}

				if( (!divParam->used) || (divParam->subtypeCode != SUBTYPE_2DS ) )
				{
					continue;
				}

				matchRet[divParam->prizeCode] += betline->betTimes;
				log_debug("gl_kock3_Match_2DS divCode[%d],prizeRet[%d]:betTimes[%d]",
									   jdx, divParam->prizeCode, betline->betTimes);
				break;

			}
    	}
    }

    return;
}


void gl_kock3_Match_ZX(
		const BETLINE *betline,
		DIVISION_PARAM *division,
		uint32 matchRet[])
{

    GL_BETPART* bp = GL_BETPART_A(betline);
    if (kock3_drawnum.hz == bp->bitmap[0])
    {
        for(uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++)
        {
            DIVISION_PARAM *divParam = division + jdx;

            if (divParam == NULL)
            {
                continue;
            }

            if( (!divParam->used) || (divParam->subtypeCode != SUBTYPE_ZX ) )
            {
                continue;
            }
            uint8 ab = abs(21 - 2 * kock3_drawnum.hz);

            if (ab == divParam->absDiff)
            {
                matchRet[divParam->prizeCode] += betline->betTimes;
                log_debug("gl_kock3_Match_ZX divCode[%d],prizeRet[%d]:betTimes[%d]",
                                       jdx, divParam->prizeCode, betline->betTimes);
                break;
            }
        }
    }

	return;
}


int gl_kock3_ticketMatch(
        const TICKET *ticket,
        const char *subtype,
        const char *division,
        uint32 matchRet[])
{
    ts_notused(subtype);
    memset(matchRet, 0, sizeof(uint32) * MAX_PRIZE_COUNT);
    BETLINE *betline = NULL;
    //log_debug("gl_ticketMatch gameCode[%d],issueCnt[%d],betlineCnt[%d],tmoney[%lld]",
    //        ticket->gameCode, ticket->issueCount, ticket->betlineCount, ticket->amount);

    //uint8 andRet[10] = {0};


    for (int idx = 0; idx < ticket->betlineCount; idx++)
    {
        if (0==idx) {
            betline = (BETLINE*)GL_BETLINE(ticket);
        } else {
            betline = (BETLINE*)GL_BETLINE_NEXT(betline);
        }

        //GL_BETPART* bp = GL_BETPART_A(betline);

        switch(betline->subtype)
        {
        case SUBTYPE_ZX:
        	gl_kock3_Match_ZX(betline, (DIVISION_PARAM*)division, matchRet);
        	break;
        case SUBTYPE_3TA:
        	gl_kock3_Match_3TA(betline, (DIVISION_PARAM*)division, matchRet);
        	break;
        case SUBTYPE_3TS:
        	gl_kock3_Match_3TS(betline, (DIVISION_PARAM*)division, matchRet);
        	break;
        case SUBTYPE_3QA:
        	gl_kock3_Match_3QA(betline, (DIVISION_PARAM*)division, matchRet);
        	break;
        case SUBTYPE_3DS:
            gl_kock3_Match_3DS(betline, (DIVISION_PARAM*)division, matchRet);
            break;
        case SUBTYPE_2TA:
            gl_kock3_Match_2TA(betline, (DIVISION_PARAM*)division, matchRet);
            break;
        case SUBTYPE_2TS:
            gl_kock3_Match_2TS(betline, (DIVISION_PARAM*)division, matchRet);
            break;
        case SUBTYPE_2DS:
            gl_kock3_Match_2DS(betline, (DIVISION_PARAM*)division, matchRet);
        }
    }

    for (uint16 jdx = 0; jdx < MAX_PRIZE_COUNT; jdx++) {
        if (matchRet[jdx]>0) {
            return 1;
        }
    }

    return 0;
}


