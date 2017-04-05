#include "gl_koc11x5_verify.h"

#include "gl_koc11x5_betcount.h"


/*=========================================================================================================
 * 全局常量及值宏定义，并对其进行简要说明
 * Global Constant & Macro Definitions and Brief Description
 =========================================================================================================*/
static const int MAX_BUFSIZE = 2048;

#define KOC11X5_SUBTYPE_MAX 12
const uint8 subtypeNeedMatch[KOC11X5_SUBTYPE_MAX + 1] = { 0, 2,3,4,5,6,7,8,1,2,3,2,3 };

int gl_koc11x5_ticketVerify(const TICKET *ticket)
{
    uint8 errnum = 0;
    uint16 totalBets = 0;

    log_debug("gameCode[%d] ticketAmount[%lld] issueNumber[%lld] issueCount[%d] betLineCount[%d].",\
            ticket->gameCode, ticket->amount, ticket->issue, ticket->issueCount, ticket->betlineCount);

    uint16 totalBetCount = 0;
    money_t calcMoney = 0;
    BETLINE *line = (BETLINE*)GL_BETLINE(ticket);

    for (int idx = 0; idx < ticket->betlineCount; idx++) {
        SUBTYPE_PARAM* subparam = gl_koc11x5_getSubtypeParam(line->subtype);
        if(subparam == NULL) {
        	log_warn("saleProcessing gl_koc11x5_getSubtypeParam gameCode[%d] subType[%d] is NULL", ticket->gameCode, line->subtype);
            errnum = SYS_RESULT_GAME_SUBTYPE_ERR;
            return errnum;
        }
        // 校验该玩法是否启用，允许售票
        if (ENABLED != subparam->status)
        {
        	log_warn("saleProcessing gameCode[%d] subtype[%d] status is not ENABLED", ticket->gameCode, line->subtype);
        	errnum = SYS_RESULT_GAME_SUBTYPE_ERR;
        	return errnum;
        }

        if ( 0 != gl_bettypeVerify(subparam->bettype, line) ) {
        	log_warn("saleProcessing gameCode[%d] subtype[%d] bettype[%d] ", ticket->gameCode, line->subtype, line->bettype);
            errnum = SYS_RESULT_GAME_SUBTYPE_ERR;
            return errnum;
        }

        if ( 0 != gl_verifyLineParam(ticket->gameCode, line->betTimes) ) {
        	log_warn("saleProcessing multiply[%d] ",line->betTimes);
            errnum = SYS_RESULT_SELL_BETTIMES_ERR;
            return errnum;
        }

        if(0 != gl_koc11x5_betlineVerify(line)) {
        	log_warn("saleProcessing gl_betlineVerify subtype[%d] bettype[%d] ",line->subtype, line->bettype);
            errnum = SYS_RESULT_SELL_DATA_ERR;
            return errnum;
        }

        totalBetCount += line->betCount * line->betTimes;
        calcMoney += line->betTimes * line->betCount * subparam->singleAmount;
        log_debug("saleProcessing betTimes[%d] betCnt[%d] singleAmount[%d]",
                    line->betTimes, line->betCount, subparam->singleAmount);
        log_debug("saleProcessing calcMoney[%lld] ",calcMoney);

        line = (BETLINE*)GL_BETLINE_NEXT(line);
    }

    calcMoney  =  calcMoney * ticket->issueCount;
    log_debug("saleProcessing calcMoney[%lld] issueCount[%d] ", calcMoney, ticket->issueCount);
    if((calcMoney != ticket->amount) || (calcMoney <= 0)) {
        log_warn("saleProcessing calcMoney[%lld] tmoney[%lld] betcnt", calcMoney , ticket->amount);
        errnum = SYS_RESULT_SELL_TICKET_AMOUNT_ERR;
        return errnum;
    }
    totalBets = totalBetCount;

    return SYS_RESULT_SUCCESS;
}

int gl_koc11x5_betlineVerify(
        const BETLINE *betline)
{
    int ret = 0;
    uint8 subtype = betline->subtype;
    SUBTYPE_PARAM* subparam = gl_koc11x5_getSubtypeParam(subtype);

    GL_BETPART* bpA = GL_BETPART_A(betline);

    uint8 btA = GL_BETTYPE_A(betline);
    ret = gl_koc11x5_betpartVerify(btA, bpA, subparam);

    return ret;
}

int gl_koc11x5_betpartVerify(
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
            ret = gl_koc11x5_DSPartVerify(bp, subparam);
            break;
        }
		case BETTYPE_FS:
		{
			ret = gl_koc11x5_FSPartVerify(bp, subparam);
			break;
		}
        case BETTYPE_YXFS:
        {
            ret = gl_koc11x5_YXFSPartVerify(bp, subparam);
            break;
        }
        case BETTYPE_DT:
        {
            ret = gl_koc11x5_DTPartVerify(bp, subparam);
            break;
        }
    }

    return ret;
}

int gl_koc11x5_DSPartVerify(
        const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam)
{
    int ret = 0;
    int minnum = 0, maxnum = 0, bitcnt = 0;
    int num = 0;

	int rangeMin = 1;
    int rangeMax = 11;
	int rangeCnt = subtypeNeedMatch[subparam->subtypeCode];


    switch (bp->mode)
    {
        default:
            log_warn("gl_DSPartVerify mode not support! mode[%d]", bp->mode);
            ret = -1;
            break;
        case MODE_JC:
            //范围
            maxnum = bitHL2num(bp->bitmap, 0, bp->size, 1, 1);
            if ((maxnum > rangeMax) || (maxnum < rangeMin)) {
                log_warn("gl_DSPartVerify JC range fail!!!maxnum[%d]",
                            maxnum);
                ret = -1;
                break;
            }
            minnum = bitHL2num(bp->bitmap, 0, bp->size, 0, 1);
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
                maxnum = bitHL2num((uint8*) bp->bitmap, idx * 2, 2, 1, 1);
                if (-1 == maxnum) {
                    //continue;
                }
                if ((maxnum > rangeMax) || (maxnum < rangeMin)) {
                    log_warn("gl_DSPartVerify FD range fail!!!maxnum[%d]",
                            maxnum);
                    ret = -1;
                    break;
                }
                minnum = bitHL2num((uint8*) bp->bitmap, idx * 2, 2, 0, 1);
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


int gl_koc11x5_FSPartVerify(
	const GL_BETPART* bp,
	const SUBTYPE_PARAM *subparam)
{
	int ret = 0;
	int minnum = 0, maxnum = 0, bitcnt = 0;

	int rangeMin = 1;
	int rangeMax = 11;
	int rangeCnt = subtypeNeedMatch[subparam->subtypeCode];


	switch (bp->mode)
	{
	default:
		log_warn("gl_DSPartVerify mode not support!!!");
		ret = -1;
		break;
	case MODE_JC:
		//范围
		maxnum = bitHL2num(bp->bitmap, 0, bp->size, 1, 1);
		if ((maxnum > rangeMax) || (maxnum < rangeMin)) {
			log_warn("gl_DSPartVerify JC range fail!!!maxnum[%d]",
				maxnum);
			ret = -1;
			break;
		}
		minnum = bitHL2num(bp->bitmap, 0, bp->size, 0, 1);
		if ((minnum > rangeMax) || (minnum < rangeMin)) {
			log_warn("gl_DSPartVerify JC rangeL fail!!!minnum[%d]",
				minnum);
			ret = -1;
			break;
		}
		//数量
		bitcnt = bitCount(bp->bitmap, 0, bp->size);
		if (bitcnt <= rangeCnt) {
			log_warn("gl_DSPartVerify JC quantity fail!!! \
                        bitcnt[%d],rangeCnt[%d]",
				bitcnt, rangeCnt);
			ret = -1;
			break;
		}
		log_debug("gl_DSPartVerify JC OK");
		break;

	}

	return ret;
}


int gl_koc11x5_YXFSPartVerify(
        const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam)
{
    int ret = 0;
    int minnum = 0, maxnum = 0, bitcnt = 0;
    int num = 0;

	int rangeMin = 1;
	int rangeMax = 11;
	int rangeCnt = subtypeNeedMatch[subparam->subtypeCode];

    switch (bp->mode)
    {
        default:
            log_warn("gl_YXFSPartVerify mode not support!!!");
            ret = -1;
            break;

        case MODE_FD:
            if (bp->size / 2 != rangeCnt) {
                log_warn("gl_YXFSPartVerify FD bp->size[%d] rangeCnt[%d]!",
                    bp->size, rangeCnt);
                ret = -1;
                break;
            }
            for (int idx = 0; idx < bp->size / 2; idx++) {
                //校验范围
                maxnum = bitHL2num((uint8*) bp->bitmap, idx * 2, 2, 1, 1);
                if (-1 == maxnum) {
                    //continue;
                }
                if ((maxnum > rangeMax) || (maxnum < rangeMin)) {
                    log_warn("gl_YXFSPartVerify FD range fail!!!maxnum[%d]",
                            maxnum);
                    ret = -1;
                    break;
                }
                minnum = bitHL2num((uint8*) bp->bitmap, idx * 2, 2, 0, 1);
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
                log_warn("gl_YXFSPartVerify FD bitcnt[%d] != rangeCnt fail[%d]!!!",bitcnt, rangeCnt);
                ret = -1;
                break;
            }
    }

    return ret;
}


int gl_koc11x5_DTPartVerify(
	const GL_BETPART* bp,
	const SUBTYPE_PARAM *subparam)
{
	int ret = 0;
	int minnum = 0, maxnum = 0, bitcnt = 0;

	int rangeMin = 1;
	int rangeMax = 11;
	int rangeCnt = subtypeNeedMatch[subparam->subtypeCode];

	switch (bp->mode)
	{
	default:
		log_warn("gl_koc11x5_DTPartVerify mode not support!!!");
		ret = -1;
		break;

	case MODE_FD:
		for (int idx = 0; idx < bp->size / 2; idx++) {
			//校验范围
			maxnum = bitHL2num((uint8*)bp->bitmap, idx * 2, 2, 1, 1);
			if (-1 == maxnum) {
				//continue;
			}
			if ((maxnum > rangeMax) || (maxnum < rangeMin)) {
				log_warn("gl_koc11x5_DTPartVerify FD range fail!!!maxnum[%d]",
					maxnum);
				ret = -1;
				break;
			}
			minnum = bitHL2num((uint8*)bp->bitmap, idx * 2, 2, 0, 1);
			if ((minnum > rangeMax) || (minnum < rangeMin)) {
				log_warn("gl_koc11x5_DTPartVerify FD rangeL fail!!!minnum[%d]",
					minnum);
				ret = -1;
				break;
			}
		}
		if (0 != ret) {
			break;
		}

		//校验数量
		int dan = bitCount((uint8*)bp->bitmap, 0, 2);
		int tuo = bitCount((uint8*)bp->bitmap, 2, 2);

		if ((dan >= rangeCnt) || (dan < 1))
		{
			log_warn("gl_koc11x5_DTPartVerify dan[%d]  rangeCnt fail[%d]!",dan, rangeCnt);
			ret = -1;
			break;
		}
		if (tuo <= 1)
		{
			log_warn("gl_koc11x5_DTPartVerify tuo[%d]  rangeCnt fail[%d]!", tuo, rangeCnt);
			ret = -1;
			break;
		}

		uint8 andRet[10] = { 0 };
		bitAnd(bp->bitmap, 0, bp->bitmap, 2, 2, andRet);
		uint8 cnt = bitCount(andRet, 0, 2);
		if (cnt > 0)
		{
			log_warn("gl_koc11x5_DTPartVerify there are some number in dan and tuo ");
			ret = -1;
			break;
		}

		bitcnt = dan + tuo;

		if (bitcnt < rangeCnt) {
			log_warn("gl_koc11x5_DTPartVerify FD bitcnt[%d] != rangeCnt fail[%d]!!!",
				bitcnt, rangeCnt);
			ret = -1;
			break;
		}
	}

	return ret;
}

