#include "gl_koctty_verify.h"

#include "gl_koctty_betcount.h"


/*=========================================================================================================
 * 全局常量及值宏定义，并对其进行简要说明
 * Global Constant & Macro Definitions and Brief Description
 =========================================================================================================*/
static const int MAX_BUFSIZE = 2048;

int gl_koctty_ticketVerify(const TICKET *ticket)
{
    uint8 errnum = 0;
    uint16 totalBets = 0;

    log_debug("gameCode[%d] ticketAmount[%lld] issueNumber[%lld] issueCount[%d] betLineCount[%d].",\
            ticket->gameCode, ticket->amount, ticket->issue, ticket->issueCount, ticket->betlineCount);

//    if( 0 != gl_koctty_subtypeVerify(ticket, &errnum, &totalBets) ) {
//        //pTf->status = errnum;
//        return -1;
//    }
//   // pTf->totalBets = totalBets;

    //uint32 betCnt = 0;
    uint16 totalBetCount = 0;
    money_t calcMoney = 0;
    BETLINE *line = (BETLINE*)GL_BETLINE(ticket);

    for (int idx = 0; idx < ticket->betlineCount; idx++) {
        SUBTYPE_PARAM* subparam = gl_koctty_getSubtypeParam(line->subtype);
        if(subparam == NULL) {
        	log_warn("saleProcessing gl_koctty_getSubtypeParam gameCode[%d] subType[%d] is NULL", ticket->gameCode, line->subtype);
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

        if(0 != gl_koctty_betlineVerify(line)) {
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

int gl_koctty_betlineVerify(
        const BETLINE *betline)
{
    int ret = 0;
    uint8 subtype = betline->subtype;
    SUBTYPE_PARAM* subparam = gl_koctty_getSubtypeParam(subtype);

    GL_BETPART* bpA = GL_BETPART_A(betline);

    uint8 btA = GL_BETTYPE_A(betline);
    ret = gl_koctty_betpartVerify(btA, bpA, subparam);

    return ret;
}

int gl_koctty_betpartVerify(
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
            ret = gl_koctty_DSPartVerify(bp, subparam);
            break;
        }
        case BETTYPE_YXFS:
        {
            ret = gl_koctty_YXFSPartVerify(bp, subparam);
            break;
        }
        case BETTYPE_FW:
        {
            ret = gl_koctty_FWPartVerify(bp, subparam);
            break;
        }

    }

    return ret;
}

int gl_koctty_DSPartVerify(
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

    case SUBTYPE_QH2:
        rangeCnt = 2;
        break;
    case SUBTYPE_QH3:
        rangeCnt = 3;
        break;
    case SUBTYPE_4ZX:
        rangeCnt = 4;
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



int gl_koctty_YXFSPartVerify(
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

    case SUBTYPE_QH2:
        rangeCnt = 2;
        break;
    case SUBTYPE_QH3:
        rangeCnt = 3;
        break;
    case SUBTYPE_4ZX:
        rangeCnt = 4;
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

int gl_koctty_FWPartVerify(
        const GL_BETPART* bp,
        const SUBTYPE_PARAM *subparam)
{
    int ret = 0;
    int numOne = 0, numTwo = 0;
    int rangeMax = 0;

    switch(subparam->subtypeCode)
    {
        case SUBTYPE_QH2:
            rangeMax = 99;
            break;
        case SUBTYPE_QH3:
            rangeMax = 999;
            break;
        case SUBTYPE_4ZX:
            rangeMax = 9999;
            break;

        default:
            return -1;
    }

    switch (bp->mode)
    {
        default:
            log_warn("gl_FWPartVerify mode not support!!!");
            ret = -1;
            break;

        case MODE_YS:
            char str[5] = {0};
            memcpy(str, bp->bitmap, bp->size/2);
            numOne = atoi(str);
            memcpy(str, bp->bitmap+bp->size/2, bp->size/2);
            numTwo = atoi(str);

            if ( (numOne > numTwo) || (numOne > rangeMax) || (numTwo > rangeMax) || (numOne < 0) || (numTwo < 0) ) {
                log_warn("gl_FWPartVerify numOne[%d], numTwo fail[%d]!!!",
                        numOne, numTwo);
                ret = -1;
                break;
            }
    }

    return ret;
}


