#include "global.h"
#include "gl_inf.h"

#include "gl_koc7lx_db.h"
#include "gl_koc7lx_verify.h"

//-------VERIFY---------//
int gl_koc7lx_ticketVerify(const TICKET *ticket)
{
    log_debug("gameCode[%d] ticketAmount[%lld] issueNumber[%lld] issueCount[%d] betLineCount[%d].",
              ticket->gameCode, ticket->amount, ticket->issue, ticket->issueCount,
              ticket->betlineCount);

    int32 betCnt;
    money_t calcMoney = 0;
    BETLINE *line = (BETLINE *)GL_BETLINE(ticket);

    for (int idx = 0; idx < ticket->betlineCount; idx++)
    {
        // 通过投注行的玩法信息获得玩法参数
        SUBTYPE_PARAM *subparam = gl_koc7lx_getSubtypeParam(line->subtype);
        if (subparam == NULL)
        {
        	log_warn("saleProcessing gl_koc7lx_getSubtypeParam gameCode[%d] subType[%d] is NULL",
                      ticket->gameCode, line->subtype);
            return SYS_RESULT_GAME_SUBTYPE_ERR;
        }
        // 校验该玩法是否启用，允许售票
        if (ENABLED != subparam->status)
        {
        	log_warn("saleProcessing gameCode[%d] subtype[%d] status is not ENABLED",
        			ticket->gameCode, line->subtype);
            return SYS_RESULT_GAME_SUBTYPE_ERR;
        }

        // 校验该玩法是否支持投注行的投注方式
        if (0 != gl_bettypeVerify(subparam->bettype, line))
        {
        	log_warn("saleProcessing gameCode[%d] subtype[%d] bettype[%d] bettype unsupported",
                      ticket->gameCode, line->subtype, line->bettype);
            return SYS_RESULT_GAME_SUBTYPE_ERR;
        }

        // 检查投注行倍数是否大于交易控制参数中的倍数限制
        if (0 != gl_verifyLineParam(ticket->gameCode, line->betTimes))
        {
        	log_warn("saleProcessing multiplier[%d] exceeds limit", line->betTimes);
            return SYS_RESULT_SELL_BETTIMES_ERR;
        }

        // 校验投注行号码区是否合法
        if (0 != gl_koc7lx_betlineVerify(line))
        {
        	log_warn("saleProcessing gl_koc7lx_subtypeVerify gameCode[%d]", ticket->gameCode);
            return SYS_RESULT_SELL_DATA_ERR;
        }

        // 校验注数是否超出最大值
        betCnt = line->betCount;
        if (betCnt < 0)
        { //we store betcount with uint16
        	log_warn("saleProcessing subcnt[%d] < 0", betCnt);
            return SYS_RESULT_SELL_BETLINE_ERR;
        }

        calcMoney += line->betTimes * betCnt * subparam->singleAmount;

        log_debug("saleProcessing betTimes[%d] betCnt[%d] singleAmount[%d] calcMoney[%lld]",
                  line->betTimes, betCnt, subparam->singleAmount, calcMoney);

        line = (BETLINE*)GL_BETLINE_NEXT(line);
    }

    calcMoney = calcMoney * ticket->issueCount;
    log_debug("saleProcessing calcMoney[%lld] issueCount[%d]", calcMoney, ticket->issueCount);
    // 校验票面总金额是否等于传来消息中的总金额
    if (calcMoney != ticket->amount || calcMoney <= 0)
    {
    	log_warn("saleProcessing calcMoney[%lld] tmoney[%lld] betcnt", calcMoney, ticket->amount);
        return SYS_RESULT_SELL_TICKET_AMOUNT_ERR;
    }

    return SYS_RESULT_SUCCESS;
}

int gl_koc7lx_betlineVerify(const BETLINE *betline)
{
    uint8 subtype = betline->subtype;

    SUBTYPE_PARAM *subparam = gl_koc7lx_getSubtypeParam(subtype);
    if(subparam == NULL)
    	return -1;

    GL_BETPART *bpA = GL_BETPART_A(betline);
    uint8 btA = GL_BETTYPE_A(betline);

    return gl_koc7lx_betpartVerify(btA, bpA, subparam);
}

int gl_koc7lx_betpartVerify(
        uint8 bettype,
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam)
{
    switch (bettype)
    {
        case BETTYPE_DS:
        {
            return gl_koc7lx_DSPartVerify(bp, subparam);
        }
        case BETTYPE_FS:
        {
            return gl_koc7lx_FSPartVerify(bp, subparam);
        }
        case BETTYPE_DT:
        {
            return gl_koc7lx_DTPartVerify(bp, subparam);
        }
        default:
        {
        	log_warn("gl_koc7lx_betpartVerify default bettype[%d]", bettype);
            return -1;
        }
    }
}

int gl_koc7lx_DSPartVerify(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam)
{
    uint16 rangeMin, rangeMax, rangeCnt;

    rangeMin = subparam->A_selectBegin;
    rangeMax = subparam->A_selectEnd;
    rangeCnt = subparam->A_selectCount;

    switch (bp->mode) {
        case MODE_JC:
        {
            uint8 num[128] = {0};

            int numCnt = bit2num(bp->bitmap, bp->size, num, 1);

            if (numCnt != rangeCnt)
            {
                //投注号码的个数须与单注要求个数相同
            	log_warn("gl_koc7lx_DSPartVerify numCnt[%d] rangeCnt[%d]", numCnt, rangeCnt);
                return -1;
            }
            else if (!(num[0] >= rangeMin && num[numCnt-1] <= rangeMax))
            {
                //投注号码的取值范围应在[rangeMin, rangeMax]里
            	log_warn("gl_koc7lx_DSPartVerify rangeData %d %d", num[0], num[numCnt-1]);
                return -1;
            }
            else
            {
                //通过验证
                return 0;
            }
        }
        default:
        {
        	log_warn("gl_koc7lx_DSPartVerify default.");
            return -1;
        }
    }
}

int gl_koc7lx_FSPartVerify(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam)
{
    uint16 rangeMin, rangeMax, rangeCnt, maxCnt;

    rangeMin = subparam->A_selectBegin;
    rangeMax = subparam->A_selectEnd;
    rangeCnt = subparam->A_selectCount;
    maxCnt   = subparam->A_selectMaxCount;

    switch (bp->mode)
    {
        case MODE_JC:
        {
            uint8 num[128] = {0};

            int numCnt = bit2num(bp->bitmap, bp->size, num, 1);

            if (numCnt < rangeCnt + 1 || numCnt > maxCnt)
            {
                //投注号码个数须大于单注要求个数且不大于复式最大选号个数
            	log_warn("gl_koc7lx_FSPartVerify numCnt[%d] rangeCnt[%d] maxCnt[%d]",
                          numCnt, rangeCnt, maxCnt);
                return -1;
            }
            else if (!(num[0] >= rangeMin && num[numCnt-1] <= rangeMax))
            {
                //投注号码的取值范围应在[rangeMin, rangeMax]里
            	log_warn("gl_koc7lx_FSPartVerify rangeData %d %d", num[0], num[numCnt-1]);
                return -1;
            }
            else
            {
                //通过验证
                return 0;
            }
        }
        default:
        {
        	log_warn("gl_koc7lx_FSPartVerify default.");
            return -1;
        }
    }
}

int gl_koc7lx_DTPartVerify(
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam)
{
    uint16 rangeMin, rangeMax, rangeCnt, maxCnt;

    rangeMin = subparam->A_selectBegin;
    rangeMax = subparam->A_selectEnd;
    rangeCnt = subparam->A_selectCount;
    maxCnt   = subparam->A_selectMaxCount;

    switch (bp->mode)
    {
        case MODE_JC:
        {
            uint8 numD[128] = {0};
            uint8 numT[128] = {0};

            int dCnt = bit2num(bp->bitmap, bp->size/2, numD, 1);
            int tCnt = bit2num(bp->bitmap + bp->size/2, bp->size/2, numT, 1);

            if (dCnt >= rangeCnt || dCnt == 0 || dCnt+tCnt <= rangeCnt || dCnt+tCnt > rangeCnt-1+maxCnt)
            {
                //胆码和拖码的个数应符合胆拖投注的要求
            	log_warn("gl_koc7lx_DTPartVerify dCnt[%d] tCnt[%d] rangeCnt[%d] maxCnt[%d]",
                          dCnt, tCnt, rangeCnt, maxCnt);
                return -1;
            }
            else if (!(numD[0] >= rangeMin && numD[dCnt-1] <= rangeMax &&
                       numT[0] >= rangeMin && numT[tCnt-1] <= rangeMax))
            {
                //胆码和拖码的取值范围应在[rangeMin, rangeMax]里
            	log_warn("gl_koc7lx_DTPartVerify rangeData d[%d,%d] t[%d,%d]",
                          numD[0], numD[dCnt-1], numT[0], numT[tCnt-1]);
                return -1;
            }

            //胆码和拖码不能有相同的号码
            for (int i = 0; i < dCnt; i++)
                for (int j = 0; j < tCnt; j++)
                    if (numD[i] == numT[j])
                    {
                    	log_warn("gl_koc7lx_DTPartVerify same number in Dan %d and Tuo %d", i, j);
                        return -1;
                    }

            //通过验证
            return 0;
        }
        default:
        {
        	log_warn("gl_koc7lx_DTPartVerify default.");
            return -1;
        }
    }
}




//-------BETLINE COUNT---------//
int gl_koc7lx_betlineCount(const BETLINE *betline)
{
    uint8 subtype = betline->subtype;
    SUBTYPE_PARAM *subparam = gl_koc7lx_getSubtypeParam(subtype);
    if (NULL == subparam)
    {
    	log_warn("gl_koc7lx_betlineCount  subparam==NULL");
    	return -1;
    }

    GL_BETPART *bpA = GL_BETPART_A(betline);
    uint8 btA = GL_BETTYPE_A(betline);

    return gl_koc7lx_betpartCount(btA, bpA, subparam);
}

int gl_koc7lx_betpartCount(
        uint8 bettype,
        const GL_BETPART *bp,
        const SUBTYPE_PARAM *subparam)
{
    switch (bettype)
    {
        case BETTYPE_DS:
        case BETTYPE_FS:
        {
            return gl_koc7lx_FSbetCount(bp, subparam);
        }
        case BETTYPE_DT:
        {
            return gl_koc7lx_DTbetCount(bp, subparam);
        }
        default:
        {
        	log_warn("gl_koc7lx_betpartCount default.");
            return -1;
        }
    }
}

int gl_koc7lx_FSbetCount(
             const GL_BETPART* bp,
             const SUBTYPE_PARAM* subparam)
{
    uint16 rangeCnt = subparam->A_selectCount;

    switch (bp->mode)
    {
        case MODE_JC:
        {
            uint8 bitCnt = bitCount(bp->bitmap, 0, bp->size);
            return mathc(bitCnt, rangeCnt);
        }
        default:
        {
        	log_warn("gl_7lx_FSbetCount default.");
            return -1;
        }
    }
}

int gl_koc7lx_DTbetCount(
             const GL_BETPART* bp,
             const SUBTYPE_PARAM* subparam)
{
    uint16 rangeCnt = subparam->A_selectCount;

    switch (bp->mode)
    {
        case MODE_JC:
        {
            uint8 dCnt = bitCount(bp->bitmap, 0, bp->size / 2);
            uint8 tCnt = bitCount(bp->bitmap, bp->size / 2, bp->size / 2);

            return mathc(tCnt, rangeCnt - dCnt);
        }
        default:
        {
            log_warn("gl_koc7lx_DTBetCount default.");
            return -1;
        }
    }
}
