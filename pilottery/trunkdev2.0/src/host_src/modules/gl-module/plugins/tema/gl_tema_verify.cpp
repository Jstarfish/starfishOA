/*
 * gl_tema_verify.cpp
 *
 *  Created on: 2011-6-30
 *      Author: Administrator
 */

#include "global.h"
#include "gl_inf.h"
#include "gl_plugins_inf.h"


#include "gl_tema_db.h"
#include "gl_tema_verify.h"


int gl_tema_ticketVerify(const TICKET* ticket)
{
    uint8 errnum = 0;
    uint16 totalBets = 0;

	log_debug("gameCode[%d] ticketAmount[%lld] issueNumber[%lld] issueCount[%d] betLineCount[%d].",\
			ticket->gameCode, ticket->amount, ticket->issue, ticket->issueCount, ticket->betlineCount);

		int32 betCnt = 0;
    uint16 totalBetCount = 0;
    money_t calcMoney = 0;
    BETLINE *line = (BETLINE*)GL_BETLINE(ticket);

    for (int idx = 0; idx < ticket->betlineCount; idx++) {
        SUBTYPE_PARAM* subparam = gl_tema_getSubtypeParam(line->subtype);
        if(subparam == NULL) {
            log_debug("saleProcessing gl_tema_getSubtypeParam gameCode[%d] subType[%d] is NULL", ticket->gameCode, line->subtype);
            errnum = SYS_RESULT_GAME_SUBTYPE_ERR;
            return errnum;
        }

        if ( 0 != gl_bettypeVerify(subparam->bettype, line) ) {
            log_debug("saleProcessing gameCode[%d] subtype[%d] bettype[%d] ", ticket->gameCode, line->subtype, line->bettype);
            errnum = SYS_RESULT_GAME_SUBTYPE_ERR;
            return errnum;
        }

		if ( 0 != gl_verifyLineParam(ticket->gameCode, line->betTimes) ) {
			log_debug("saleProcessing multiply[%d] ",line->betTimes);
			errnum = SYS_RESULT_SELL_BETTIMES_ERR;
			return errnum;
		}

		if(0 != gl_tema_betlineVerify(line)) {
			log_debug("saleProcessing gl_tema_betlineVerify fail ");
			errnum = SYS_RESULT_SELL_DATA_ERR;
			return errnum;
		}

		betCnt = line->betCount;
        if(betCnt < 0) {
            log_debug("saleProcessing betCnt[%d] < 0 ", betCnt);
            errnum = SYS_RESULT_SELL_BETLINE_ERR;
            return errnum;
        }

		totalBetCount += betCnt * line->betTimes;
		calcMoney += line->betTimes * betCnt * subparam->singleAmount;
		log_debug("saleProcessing betTimes[%d] betCnt[%d] singleAmount[%d]",
					line->betTimes, betCnt, subparam->singleAmount);
		log_debug("saleProcessing calcMoney[%lld] ",calcMoney);

        line = (BETLINE*)GL_BETLINE_NEXT(line);
    }

    calcMoney  =  calcMoney * ticket->issueCount;
    log_debug("saleProcessing calcMoney[%lld] issueCount[%d] ", calcMoney, ticket->issueCount);
    if((calcMoney != ticket->amount) || (calcMoney <= 0)) {
        log_debug("saleProcessing calcMoney[%lld] tmoney[%lld] betcnt",calcMoney , ticket->amount);
        errnum = SYS_RESULT_SELL_TICKET_AMOUNT_ERR;
        return errnum;
    }
    totalBets = totalBetCount;

    return SYS_RESULT_SUCCESS;
}



int gl_tema_betlineVerify(const BETLINE* betline)
{
	int ret = 0;
    uint8 subtype = betline->subtype;

    SUBTYPE_PARAM* subparam = gl_tema_getSubtypeParam(subtype);

	GL_BETPART* bpA = GL_BETPART_A(betline);

	uint8 btA = GL_BETTYPE_A(betline);
	ret = gl_tema_betpartVerify(btA, 0, bpA, subparam);
	if (ret != 0) {
		return -1;
	}

	return ret;
}

int gl_tema_betpartVerify(
				  uint8 bettype,
				  uint8 flagAB, //0：A区  1：B区
				  const GL_BETPART* bp,
				  const SUBTYPE_PARAM* subparam)
{
    switch(bettype)
    {
        default:
		{
			log_debug("gl_tema_betpartVerify default bettype[%d] part[%c].", bettype, (0==flagAB)?'a':'b');
			return -1;
		}
        case BETTYPE_DS:
		{
			return gl_tema_DSPartVerify(flagAB, bp, subparam);
		}
        case BETTYPE_FS:
		{
			return gl_tema_FSPartVerify(flagAB, bp, subparam);
		}
    }
}

int gl_tema_DSPartVerify(
		uint8 flagAB,
   		const GL_BETPART* bp,
		const SUBTYPE_PARAM* subparam)
{
    uint16 rangeMin = 0, rangeMax = 0, rangeCnt = 0;
    int ret = 0;

    if(0 == flagAB) {
        rangeMin = subparam->A_selectBegin;
        rangeMax = subparam->A_selectEnd;
        rangeCnt = 1;
    }

    switch(bp->mode)
    {
        case MODE_JC: //紧凑模式
		{
			uint8 num[128] = { 0};

			uint8 numCnt = bit2num(bp->bitmap, bp->size, num, 1);

			if(numCnt != rangeCnt) {
				//LOG
				log_debug("gl_tema_DSPartVerify numCnt[%d] rangeCnt[%d].", numCnt, rangeCnt);
				return -1;
			} else {
				ret = (num[0] >= rangeMin) && (num[numCnt - 1] <= rangeMax);
				if (0 == ret) {
					log_debug("gl_tema_DSPartVerify rangeData %d, %d",
							num[0], num[numCnt - 1]);
					return -1;
				}
				return 0;
			}
		}
        default:
		{
			log_debug("gl_tema_DSPartVerify default. mode[%d] size[%d]", bp->mode,bp->size);
			return -1;
		}
    }
}

int gl_tema_FSPartVerify(
		uint8 flagAB,
        const GL_BETPART* bp,
        const SUBTYPE_PARAM* subparam)
{
    uint16 rangeMin = 0, rangeMax = 0;
    uint16 rangeCnt = 0, maxCnt = 0;
    int ret = 0;

    if(0 == flagAB) {
        rangeMin = subparam->A_selectBegin;
        rangeMax = subparam->A_selectEnd;
        rangeCnt = 1;
        maxCnt = subparam->A_selectMaxCount;
    }

    switch(bp->mode)
    {
        case MODE_JC: //紧凑模式
            {
                uint8 num[128] = { 0};

                int numCnt = bit2num(bp->bitmap, bp->size, num, 1);

                log_debug("gl_tema_FSPartVerify rangeData %d, %d", num[0], num[numCnt - 1]);

                if((numCnt < rangeCnt + 1) || (numCnt > maxCnt)) {
                    //LOG
                    return -1;
                } else {
                    ret = (num[0] >= rangeMin) && (num[numCnt - 1] <= rangeMax);
                    return (0 == ret) ? -1 : 0;
                }

            }
        default:
            {
            	log_debug("gl_tema_FSPartVerify default. mode[%d] size[%d]", bp->mode, bp->size);
                return -1;
            }
    }
}



////数量计算
int gl_tema_betlineCount(
			   const BETLINE* betline)
{
	GL_BETPART* bpA = GL_BETPART_A(betline);

	uint8 btA = GL_BETTYPE_A(betline);

	int32 betCnt = gl_tema_betpartCount(btA, 0, bpA, NULL);

	return betCnt;
}

int gl_tema_betpartCount(
			  uint8 bettype,
			  uint8 flagAB,
			  const GL_BETPART* bp,
			  const SUBTYPE_PARAM* subparam)
{
    switch(bettype)
    {
        default:
            {
            	log_debug("gl_tema_betpartCount default.");
                return -1;
            }
        case BETTYPE_DS:
        	return 1;
        case BETTYPE_FS:
            {
                return gl_tema_FSbetCount(flagAB, bp, subparam);
            }
    }
}

int gl_tema_FSbetCount(
			 uint8 flagAB,
			 const GL_BETPART* bp,
			 const SUBTYPE_PARAM* subparam)
{
	ts_notused(subparam);
	ts_notused(flagAB);
    switch(bp->mode)
    {
        case MODE_JC: //紧凑模式
            {
                uint8 bitCnt = bitCount(bp->bitmap, 0, bp->size);

                return bitCnt;
            }
        default:
            {
            	log_debug("gl_tema_FSbetCount default.");
                return -1;
            }
    }
}




