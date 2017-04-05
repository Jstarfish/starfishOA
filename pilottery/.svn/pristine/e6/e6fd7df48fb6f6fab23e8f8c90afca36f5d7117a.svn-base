#include "gl_kock3_verify.h"



/*=========================================================================================================
 * 全局常量及值宏定义，并对其进行简要说明
 * Global Constant & Macro Definitions and Brief Description
 =========================================================================================================*/
static const int MAX_BUFSIZE = 2048;

int gl_kock3_bettypeVerify(uint8 subtype, uint8 bettype)
{
	if((subtype == SUBTYPE_ZX) && (bettype == BETTYPE_HZ))
		return 0;
	if(bettype == BETTYPE_DS)
		return 0;
    return -1;
}

int gl_kock3_ticketVerify(const TICKET *ticket)
{
    uint8 errnum = 0;
    uint16 totalBets = 0;

    log_debug("gameCode[%d] ticketAmount[%lld] issueNumber[%lld] issueCount[%d] betLineCount[%d].",\
            ticket->gameCode, ticket->amount, ticket->issue, ticket->issueCount, ticket->betlineCount);

//    if( 0 != gl_kock3_subtypeVerify(ticket, &errnum, &totalBets) ) {
//        //pTf->status = errnum;
//        return -1;
//    }
//   // pTf->totalBets = totalBets;

    //uint32 betCnt = 0;
    uint16 totalBetCount = 0;
    money_t calcMoney = 0;
    BETLINE *line = (BETLINE*)GL_BETLINE(ticket);

    for (int idx = 0; idx < ticket->betlineCount; idx++) {
        SUBTYPE_PARAM* subparam = gl_kock3_getSubtypeParam(line->subtype);
        if(subparam == NULL) {
        	log_warn("saleProcessing gl_kock3_getSubtypeParam gameCode[%d] subType[%d] is NULL", ticket->gameCode, line->subtype);
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

        if ( 0 != gl_kock3_bettypeVerify(line->subtype, line->bettype) ) {
        	log_warn("saleProcessing gameCode[%d] subtype[%d] bettype[%d] ", ticket->gameCode, line->subtype, line->bettype);
            errnum = SYS_RESULT_GAME_SUBTYPE_ERR;
            return errnum;
        }

        if ( 0 != gl_verifyLineParam(ticket->gameCode, line->betTimes) ) {
        	log_warn("saleProcessing multiply[%d] ",line->betTimes);
            errnum = SYS_RESULT_SELL_BETTIMES_ERR;
            return errnum;
        }

        if(0 != gl_kock3_betlineVerify(line)) {
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

int gl_kock3_betlineVerify(
        const BETLINE *betline)
{
    int ret = 0;
    uint8 subtype = betline->subtype;
    SUBTYPE_PARAM* subparam = gl_kock3_getSubtypeParam(subtype);

    GL_BETPART* bpA = GL_BETPART_A(betline);

    uint8 btA = GL_BETTYPE_A(betline);
    ret = gl_kock3_betpartVerify(btA, bpA, subparam);

    return ret;
}

int gl_kock3_betpartVerify(
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
            ret = gl_kock3_DSPartVerify(bp, subparam);
            break;
        }
        case BETTYPE_HZ:
        {
            ret = gl_kock3_HZPartVerify(bp, subparam);
            break;
        }

    }

    return ret;
}

bool isThreeSameNum(int num)
{
	return ((num == 111) || (num == 222) || (num == 333) || (num == 444) || (num == 555) || (num == 666));
}

bool isThreeDiffNum(int num)
{
	if((num < 100) || (num > 666) )
		return false;

	uint8 a = num / 100;
	uint8 b = (num - a * 100) / 10;
	uint8 c = num % 10;
	return ((a != b) && (b != c) && (a != c));
}

bool isTwoSameNum(int num)
{
	return ( (num == 11) || (num == 22) || (num == 33)|| (num == 44)|| (num == 55)|| (num == 66));
}

bool isTwoSameSingleNum(int num)
{
	if ((num < 112) || (num > 665) )
		return false;

	uint8 a = num / 100;
	uint8 b = (num - a * 100) / 10;
	uint8 c = num % 10;
	if (((a != b) && (b != c) && (a != c)) || ((a == b) && (b == c) && (a == c)))
		return false;
	return true;
}

bool isTwoDiffNum(int num)
{
	if ((num < 12) || (num > 65) )
		return false;

	uint8 a = num / 10;
	uint8 b = num % 10;

	return (a != b);
}

int gl_kock3_DSPartVerify(
        const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam)
{
    int ret = 0;
    int minnum = 0, maxnum = 0, bitcnt = 0;
    int rangeMin = 0, rangeMax = 0, rangeCnt = 0;
    int num = 0;

    rangeMin = 0;
    rangeMax = 9;
    int betN = 0;
    switch(subparam->subtypeCode)
    {

    case SUBTYPE_3TA:
    case SUBTYPE_3QA:
    	break;
    case SUBTYPE_3TS:
    	betN = atoi((char *)(bp->bitmap));
    	ret = isThreeSameNum(betN) ? 0:1;
        break;
    case SUBTYPE_3DS:
    	betN = atoi((char *)(bp->bitmap));
    	ret = isThreeDiffNum(betN) ? 0:1;
        break;

    case SUBTYPE_2TA:
    	ret = isTwoSameNum(bp->bitmap[0]) ? 0:1;
        break;

    case SUBTYPE_2TS:
    	betN = atoi((char *)(bp->bitmap));
    	ret = isTwoSameSingleNum(betN) ? 0:1;
        break;

    case SUBTYPE_2DS:
    	ret = isTwoDiffNum(bp->bitmap[0]) ? 0:1;
        break;

    default:
        return -1;
    }


    return ret;
}



int gl_kock3_HZPartVerify(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam)
{
	ts_notused(subparam);
	int ret = 0;
	int rangeMin = 3, rangeMax = 18;

	if ((bp->bitmap[0] > rangeMax) || (bp->bitmap[0] < rangeMin)) {
		ret = -1;
		log_debug("gl_kock3_HZPartVerify  fail!!! map[0]=[%d]",	bp->bitmap[0]);
	}

	return ret;
}

