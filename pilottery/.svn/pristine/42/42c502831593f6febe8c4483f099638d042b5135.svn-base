#include "gl_ssc_verify.h"

#include "gl_ssc_betcount.h"


/*=========================================================================================================
 * 全局常量及值宏定义，并对其进行简要说明
 * Global Constant & Macro Definitions and Brief Description
 =========================================================================================================*/
static const int MAX_BUFSIZE = 2048;

int gl_ssc_ticketVerify(const TICKET *ticket)
{
    uint8 errnum = 0;
    uint16 totalBets = 0;

	log_debug("gameCode[%d] ticketAmount[%lld] issueNumber[%lld] issueCount[%d] betLineCount[%d].",\
			ticket->gameCode, ticket->amount, ticket->issue, ticket->issueCount, ticket->betlineCount);

//    if( 0 != gl_ssc_subtypeVerify(ticket, &errnum, &totalBets) ) {
//        //pTf->status = errnum;
//        return -1;
//    }
//   // pTf->totalBets = totalBets;

    int32 betCnt = 0;
    uint16 totalBetCount = 0;
    money_t calcMoney = 0;
    BETLINE *line = (BETLINE*)GL_BETLINE(ticket);

    for (int idx = 0; idx < ticket->betlineCount; idx++) {
        SUBTYPE_PARAM* subparam = gl_ssc_getSubtypeParam(line->subtype);
        if(subparam == NULL) {
            log_debug("saleProcessing gl_ssc_getSubtypeParam gameCode[%d] subType[%d] is NULL", ticket->gameCode, line->subtype);
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

		if(0 != gl_ssc_betlineVerify(line)) {
			log_debug("saleProcessing gl_ssc_betlineVerify  ");
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
        log_debug("saleProcessing calcMoney[%lld] tmoney[%lld] betcnt", calcMoney , ticket->amount);
        errnum = SYS_RESULT_SELL_TICKET_AMOUNT_ERR;
        return errnum;
    }
    totalBets = totalBetCount;

    return SYS_RESULT_SUCCESS;
}

int gl_ssc_betlineVerify(
        const BETLINE *betline)
{
    int ret = 0;
    uint8 subtype = betline->subtype;
    SUBTYPE_PARAM* subparam = gl_ssc_getSubtypeParam(subtype);

	GL_BETPART* bpA = GL_BETPART_A(betline);

	uint8 btA = GL_BETTYPE_A(betline);
	ret = gl_ssc_betpartVerify(btA, bpA, subparam);

	return ret;
}

int gl_ssc_betpartVerify(
	    uint8 bettype,
	    const GL_BETPART* bp,
	    const SUBTYPE_PARAM* subparam)
{
    int ret = 0;

	switch (bettype)
    {
    	default:
        {
            log_warn("gl_betPartVerify  bettype not support!!!");
            ret = -1;
            break;
        }
        case BETTYPE_DS:
        {
            ret = gl_ssc_DSPartVerify(bp, subparam);
            break;
        }
        case BETTYPE_FS:
        {
            ret = gl_ssc_FSPartVerify(bp, subparam);
            break;
        }
        case BETTYPE_YXFS:
		{
			ret = gl_ssc_YXFSPartVerify(bp, subparam);
			break;
		}
        case BETTYPE_HZ:
		{
			ret = gl_ssc_HZPartVerify(bp, subparam);
			break;
		}
        case BETTYPE_BD:
		{
			ret = gl_ssc_BDPartVerify(bp, subparam);
			break;
		}
        case BETTYPE_BC:
		{
			ret = gl_ssc_BCPartVerify(bp, subparam);
			break;
		}
    }

    return ret;
}

int gl_ssc_DSPartVerify(
		const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam)
{
	int ret = 0;
    int minnum = 0, maxnum = 0, bitcnt = 0;
    int rangeMin = 0, rangeMax = 0, rangeCnt = 0;
    int num = 0;

    rangeMin = 0;
    rangeMax = 9;
    switch(subparam->subtypeCode)
    {
    case SUBTYPE_1ZX:
    	rangeCnt = 1;
    	break;
    case SUBTYPE_2ZX:
    case SUBTYPE_2FX:
    case SUBTYPE_2ZUX:
    case SUBTYPE_3Z3:
    	rangeCnt = 2;
        break;
    case SUBTYPE_3ZX:
    case SUBTYPE_3FX:
    case SUBTYPE_3ZUX:
    case SUBTYPE_3Z6:
    	rangeCnt = 3;
        break;
    case SUBTYPE_5ZX:
    case SUBTYPE_5FX:
    case SUBTYPE_5TX:
    	rangeCnt = 5;
        break;
    case SUBTYPE_DXDS:
    	rangeCnt = 2;
        rangeMax = 3;
        break;
    default:
    	return -1;
    }

    switch (bp->mode)
    {
        default:
        	log_warn("gl_DSPartVerify mode not support!!!");
        	ret = -1;
            break;
        case MODE_JC:
            //范围
            maxnum = bitHL2num(bp->bitmap, 0, bp->size, 1, 0);
            if ((maxnum > rangeMax) || (maxnum < rangeMin)) {
                log_warn("gl_DSPartVerify JC range fail!!!maxnum[%d]",
                            maxnum);
                ret = -1;
                break;
            }
            minnum = bitHL2num(bp->bitmap, 0, bp->size, 0, 0);
            if ((minnum > rangeMax) || (minnum < rangeMin)) {
                log_warn("gl_DSPartVerify JC rangeL fail!!!minnum[%d]",
                            minnum);
                ret = -1;
                break;
            }
            //数量
            bitcnt = bitCount(bp->bitmap, 0, bp->size);
            if (bitcnt != rangeCnt) {
                log_warn("gl_DSPartVerify JC quantity fail!!! \
                		bitcnt[%d],rangeCnt[%d]",
                            bitcnt, rangeCnt);
                ret = -1;
                break;
            }
            log_debug("gl_DSPartVerify JC OK");
            break;

        case MODE_FD:
            for (int idx = 0; idx < bp->size / 2; idx++)
            {
                //校验范围
                maxnum = bitHL2num((uint8*) bp->bitmap, idx * 2, 2, 1, 0);
                if (-1 == maxnum) {
					//continue;
				}
                if ((maxnum > rangeMax) || (maxnum < rangeMin)) {
                    log_warn("gl_DSPartVerify FD range fail!!!maxnum[%d]",
                    		maxnum);
                    ret = -1;
                    break;
                }
                minnum = bitHL2num((uint8*) bp->bitmap, idx * 2, 2, 0, 0);
                if ((minnum > rangeMax) || (minnum < rangeMin)) {
                    log_warn("gl_DSPartVerify FD rangeL fail!!!minnum[%d]",
                    		minnum);
                    ret = -1;
                    break;
                }
                //校验数量
                num = bitCount((uint8*) bp->bitmap, idx * 2, 2);
                if (1 == num) {
                    bitcnt++;
                } else if (0 == num) {
                	;
                }else {
                    log_warn("gl_DSPartVerify FD quantity fail!!!num[%d]",
                    		num);
                    ret = -1;
                    break;
                }
            }
            if (0 != ret) {
            	break;
            }
            if (bitcnt != rangeCnt) {
                log_warn("gl_DSPartVerify FD bitcnt[%d] != rangeCnt fail[%d]!!!",
                		bitcnt, rangeCnt);
                ret = -1;
                break;
            }
    }

    return ret;
}

int gl_ssc_FSPartVerify(
		const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam)
{
	int ret = 0;
    int minnum = 0, maxnum = 0, bitcnt = 0;
    int rangeMin = 0, rangeMax = 0, rangeCnt = 0;

    rangeMin = 0;
    rangeMax = 9;
    switch(subparam->subtypeCode)
    {
    case SUBTYPE_1ZX:
    	rangeCnt = 1;
    	break;
    case SUBTYPE_2ZX:
    case SUBTYPE_2FX:
    case SUBTYPE_2ZUX:
    	rangeCnt = 2;
        break;
    case SUBTYPE_3Z3:
    	rangeCnt = 2;
        break;
    case SUBTYPE_3ZX:
    case SUBTYPE_3ZUX:
    case SUBTYPE_3Z6:
    	rangeCnt = 3;
        break;
    default:
    	return -1;
    }

    switch (bp->mode)
    {
        default:
        	log_warn("gl_FSPartVerify mode not support!!!");
        	ret = -1;
            break;
        case MODE_JC:
            //范围
            maxnum = bitHL2num(bp->bitmap, 0, bp->size, 1, 0);
            if ((maxnum > rangeMax) || (maxnum < rangeMin)) {
                log_warn("gl_FSPartVerify JC range fail!!!maxnum[%d]",
                            maxnum);
                ret = -1;
                break;
            }
            minnum = bitHL2num(bp->bitmap, 0, bp->size, 0 ,0);
            if ((minnum > rangeMax) || (minnum < rangeMin)) {
                log_warn("gl_FSPartVerify JC rangeL fail!!!minnum[%d]",
                            minnum);
                ret = -1;
                break;
            }
            //数量
            bitcnt = bitCount(bp->bitmap, 0, bp->size);
            if (bitcnt < rangeCnt) {
                log_warn("gl_FSPartVerify JC quantity fail!!!  \
                		bitcnt[%d],rangeCnt[%d]",
                            bitcnt, rangeCnt);
                ret = -1;
                break;
            }
            log_debug("gl_FSPartVerify JC ok");
            break;
    }

    return ret;

}

int gl_ssc_YXFSPartVerify(
		const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam)
{
	int ret = 0;
    int minnum = 0, maxnum = 0, bitcnt = 0;
    int rangeMin = 0, rangeMax = 0, rangeCnt = 0;
    int num = 0;

    rangeMin = 0;
    rangeMax = 9;
    switch(subparam->subtypeCode)
    {
    case SUBTYPE_1ZX:
    	rangeCnt = 1;
    	break;
    case SUBTYPE_2ZX:
    case SUBTYPE_2FX:
    case SUBTYPE_2ZUX:
    	rangeCnt = 2;
        break;
    case SUBTYPE_3ZX:
    case SUBTYPE_3FX:
    case SUBTYPE_3ZUX:
    case SUBTYPE_3Z6:
    	rangeCnt = 3;
        break;
    case SUBTYPE_5ZX:
    case SUBTYPE_5FX:
    case SUBTYPE_5TX:
    	rangeCnt = 5;
        break;
    case SUBTYPE_DXDS:
    	rangeCnt = 2;
    	rangeMax = 3;
        break;
    default:
    	return -1;
    }

    switch (bp->mode)
    {
        default:
        	log_warn("gl_YXFSPartVerify mode not support!!!");
        	ret = -1;
            break;

        case MODE_FD:
            for (int idx = 0; idx < bp->size / 2; idx++) {
                //校验范围
                maxnum = bitHL2num((uint8*) bp->bitmap, idx * 2, 2, 1, 0);
                if (-1 == maxnum) {
					//continue;
				}
                if ((maxnum > rangeMax) || (maxnum < rangeMin)) {
                    log_warn("gl_YXFSPartVerify FD range fail!!!maxnum[%d]",
                    		maxnum);
                    ret = -1;
                    break;
                }
                minnum = bitHL2num((uint8*) bp->bitmap, idx * 2, 2, 0, 0);
                if ((minnum > rangeMax) || (minnum < rangeMin)) {
                    log_warn("gl_YXFSPartVerify FD rangeL fail!!!minnum[%d]",
                    		minnum);
                    ret = -1;
                    break;
                }
                //校验数量
                num = bitCount((uint8*) bp->bitmap, idx * 2, 2);
                bitcnt += num;
            }
            if (0 != ret) {
				break;
			}
            if (bitcnt < rangeCnt) {
                log_warn("gl_YXFSPartVerify FD bitcnt[%d] != rangeCnt fail[%d]!!!",
                		bitcnt, rangeCnt);
                ret = -1;
                break;
            }
    }

    return ret;
}

int gl_ssc_HZPartVerify(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam)
{
	int ret = 0;
	int rangeMin = 0, rangeMax = 27;
    switch(subparam->subtypeCode)
    {
    case SUBTYPE_2ZX:
    case SUBTYPE_2ZUX:
    	rangeMax = 18;
        break;
    case SUBTYPE_3ZX:
    case SUBTYPE_3ZUX:
    	rangeMax = 27;
        break;
    default:
    	return -1;
    }

	if ((bp->bitmap[0] > rangeMax) || (bp->bitmap[0] < rangeMin)) {
		ret = -1;
		log_debug("gl_HZPartVerify  fail!!! map[0]=[%d]",
				bp->bitmap[0]);
	}

	return ret;
}

int gl_ssc_BDPartVerify(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam)
{
	subparam = subparam;
	int ret = 0;
	int minnum = 0, maxnum = 0, num = 0;
	int bitcnt = 0;
    int rangeMin = 0;
    int rangeMax = 9;
    int rangeCnt = 3;

    switch (bp->mode)
    {
        default:
        	log_warn("gl_BDPartVerify mode not support!!!");
        	ret = -1;
            break;
        case MODE_FD:
            for (int idx = 0; idx < bp->size / 2; idx++) {
                //校验范围
                maxnum = bitHL2num((uint8*) bp->bitmap, idx * 2, 2, 1, 0);
                if ((maxnum > rangeMax) || (maxnum < rangeMin)) {
                    log_warn("gl_BDPartVerify FD range fail!!!maxnum[%d]",
                    		maxnum);
                    ret = -1;
                    break;
                }
                minnum = bitHL2num((uint8*) bp->bitmap, idx * 2, 2, 0, 0);
                if ((minnum > rangeMax) || (minnum < rangeMin)) {
                    log_warn("gl_BDPartVerify FD rangeL fail!!!minnum[%d]",
                    		minnum);
                    ret = -1;
                    break;
                }
                //校验数量
                num = bitCount((uint8*) bp->bitmap, idx * 2, 2);
                if (num > 1) {
                	ret = -1;
                	break;
                }
                bitcnt += num;
            }
            if (0 != ret) {
				break;
			}
            if (bitcnt >= rangeCnt) {
                log_warn("gl_BDPartVerify FD bitcnt[%d] != rangeCnt fail[%d]!!!",
                		bitcnt, rangeCnt);
                ret = -1;
                break;
            }
    }

    return ret;
}

int gl_ssc_BCPartVerify(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam)
{
	ts_notused(subparam);
	int ret = 0;
    int minnum = 0, maxnum = 0, bitcnt = 0;
    int rangeMin = 0, rangeMax = 0, rangeCnt = 0;

    rangeMin = 0;
    rangeMax = 9;
   	rangeCnt = 3;

    switch (bp->mode)
    {
        default:
        	log_warn("gl_BCPartVerify mode not support!!!");
        	ret = -1;
            break;
        case MODE_JC:
            //范围
            maxnum = bitHL2num(bp->bitmap, 0, bp->size, 1, 0);
            if ((maxnum > rangeMax) || (maxnum < rangeMin)) {
                log_warn("gl_BCPartVerify JC range fail!!!maxnum[%d]",
                            maxnum);
                ret = -1;
                break;
            }
            minnum = bitHL2num(bp->bitmap, 0, bp->size, 0 ,0);
            if ((minnum > rangeMax) || (minnum < rangeMin)) {
                log_warn("gl_BCPartVerify JC rangeL fail!!!minnum[%d]",
                            minnum);
                ret = -1;
                break;
            }
            //数量
            bitcnt = bitCount(bp->bitmap, 0, bp->size);
            if (bitcnt < rangeCnt) {
                log_warn("gl_BCPartVerify JC quantity fail!!!  \
                		bitcnt[%d],rangeCnt[%d]",
                            bitcnt, rangeCnt);
                ret = -1;
                break;
            }
            log_debug("gl_BCPartVerify JC ok");
            break;
    }

    return ret;
}



