/*
 * gl_tema_match.cpp
 *
 *  Created on: 2011-6-30
 *      Author: Administrator
 */

#include "global.h"
#include "gl_inf.h"
#include "gl_tema_db.h"
#include "gl_tema_match.h"

static GL_TEMA_DRAWNUM tema_drawnum;


int gl_tema_createDrawnum(const uint8 xcode[], uint8 len)
{
	log_debug("enter gl_tema_createDrawnum xcodeLen[%d]", len);

	if (len != 1) {
		log_error("tema_drawnum len error, len[%d]", len);
		return -1;
	}

	for (int idx = 0; idx < len; idx++)	{
		log_debug("xcode[%d]:[%d]", idx, xcode[idx]);
	}

	memset(&tema_drawnum, 0, sizeof(tema_drawnum));

	num2bit(xcode, len, (uint8*)(tema_drawnum.dgmap), 0, 1);

    uint8 wh = 0;
    if (xcode[0] <= 10) wh = 1;
    else if ((xcode[0] > 10) && (xcode[0] <= 20)) wh = 2;
    else if ((xcode[0] > 20) && (xcode[0] <= 30)) wh = 3;
    else wh = 4;
    num2bit(&wh, 1, (uint8*)&(tema_drawnum.whmap), 0, 1);

    return 0;
}


int gl_tema_ticketMatch(const TICKET *ticket, const char *subtype, const char *division, uint32 matchRet[])
{
    memset(matchRet, 0, sizeof(uint32) * MAX_PRIZE_COUNT);
    BETLINE *betline = NULL;
    //log_debug("gl_tema_ticketMatch gameCode[%d],issueCnt[%d],betlineCnt[%d],tmoney[%lld]",
    //        ticket->gameCode, ticket->issueCount, ticket->betlineCount, ticket->amount);

    for (int idx = 0; idx < ticket->betlineCount; idx++) {
        if (0==idx) {
            betline = (BETLINE*)GL_BETLINE(ticket);
        } else {
            betline = (BETLINE*)GL_BETLINE_NEXT(betline);
        }

        gl_tema_betlineMatch((SUBTYPE_PARAM*)subtype, (DIVISION_PARAM*)division, betline, matchRet);
    }

    for (uint16 jdx = 0; jdx < MAX_PRIZE_COUNT; jdx++) {
        if (matchRet[jdx]>0) {
            return 1;
        }
    }

    return 0;
}


int gl_tema_betlineMatch(SUBTYPE_PARAM* subtype, DIVISION_PARAM *division, const BETLINE *betline, uint32 matchRet[])
{
    GL_TEMA_MATCHNUM matchNum;

	GL_BETPART* bp = GL_BETPART_A(betline);

    uint8 andRet[10] = { 0 };

    //SUBTYPE_PARAM *subParam = subtype + betline->subtype;//subtypeCodeÎªÏÂ±ê

    for(uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++) {
    	DIVISION_PARAM *divParam = division + jdx;

    	if ( (divParam == NULL) || (!divParam->used) ) {
            continue;
        }
        if (betline->subtype != divParam->subtypeCode) {
            continue;
        }

        memset(&matchNum, 0, sizeof(matchNum));
        memset(andRet, 0, sizeof(andRet));
        if (betline->subtype == SUBTYPE_DG)
        {
            bitAnd((uint8*)tema_drawnum.dgmap, 0, bp->bitmap, 0, bp->size, andRet);
            matchNum.ACnt = bitCount(andRet, 0, bp->size);
        }
        else
        {
            bitAnd((uint8*)&tema_drawnum.whmap, 0, bp->bitmap, 0, bp->size, andRet);
            matchNum.ACnt = bitCount(andRet, 0, bp->size);
        }

		matchRet[divParam->prizeCode] += matchNum.ACnt * betline->betTimes;
        log_debug("gl_tema_betlineMatch divCode[%d],prizeRet[%d]:[%d]",  jdx, divParam->prizeCode, matchRet[divParam->prizeCode]);
    }

	return 0;
}














