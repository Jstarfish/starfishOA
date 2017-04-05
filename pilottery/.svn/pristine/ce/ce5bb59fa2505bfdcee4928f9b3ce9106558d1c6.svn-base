#include "gl_koctty_match.h"

/*=========================================================================================================
 * 全局常量及值宏定义，并对其进行简要说明
 * Global Constant & Macro Definitions and Brief Description
 =========================================================================================================*/
static GL_KOCTTY_DRAWNUM koctty_drawnum;

void ttyDrawnumDistribute( const uint8 xcode[])
{
    koctty_drawnum.winNum = xcode[0] * 1000 + xcode[1] * 100 + xcode[2] * 10 + xcode[3];
    if((xcode[0] == xcode[1]) && (xcode[1] == xcode[2]) && (xcode[2] == xcode[3]))
    {
        koctty_drawnum.distribute_4d = true;
        koctty_drawnum.distribute_q3 = true;
        koctty_drawnum.distribute_h3 = true;
        koctty_drawnum.distribute_q2 = true;
        koctty_drawnum.distribute_h2 = true;
        return;
    }
    if((xcode[0] == xcode[1]) && (xcode[1] == xcode[2]) )
    {
        koctty_drawnum.distribute_4d = false;
        koctty_drawnum.distribute_q3 = true;
        koctty_drawnum.distribute_h3 = false;
        koctty_drawnum.distribute_q2 = true;
        koctty_drawnum.distribute_h2 = false;
        return;
    }
    if( (xcode[1] == xcode[2]) && (xcode[2] == xcode[3]) )
    {
        koctty_drawnum.distribute_4d = false;
        koctty_drawnum.distribute_q3 = false;
        koctty_drawnum.distribute_h3 = true;
        koctty_drawnum.distribute_q2 = false;
        koctty_drawnum.distribute_h2 = true;
        return;
    }
    if( xcode[0] == xcode[1] )
    {
        koctty_drawnum.distribute_4d = false;
        koctty_drawnum.distribute_q3 = false;
        koctty_drawnum.distribute_h3 = false;
        koctty_drawnum.distribute_q2 = true;
        koctty_drawnum.distribute_h2 = (xcode[2] == xcode[3]);
        return;
    }
    if( xcode[2] == xcode[3] )
    {
        koctty_drawnum.distribute_4d = false;
        koctty_drawnum.distribute_q3 = false;
        koctty_drawnum.distribute_h3 = false;
        koctty_drawnum.distribute_q2 = (xcode[0] == xcode[1]);
        koctty_drawnum.distribute_h2 = true;
        return;
    }
}


int gl_koctty_createDrawnum(
        const uint8 xcode[],
        uint8 len)//xcode长度
{
    log_debug("gl_createDrawnum xcode [%d]:[%d]:[%d]:[%d]",
            xcode[0], xcode[1], xcode[2], xcode[3]);

    memset(&koctty_drawnum, 0, sizeof(koctty_drawnum));

    if (len != 4){
        log_error("koctty_drawnum len error, len[%d]", len);
        return -1;
    }

    ttyDrawnumDistribute(xcode);

    for (int i = 0; i < 4; i++) {
        num2bit(&xcode[i], 1, koctty_drawnum.zx4_map, i * 2, 0);
    }

    return 0;
}



int gl_koctty_Match_QH2(
        const BETLINE *betline,
        DIVISION_PARAM *division,
        uint32 matchRet[])
{
    int ret = 0;
    int prizeCode = 0;
    uint8 andRet[10] = {0};
    GL_BETPART* bp = GL_BETPART_A(betline);

    for(uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++) {
        DIVISION_PARAM *divParam = division + jdx;

        if (divParam == NULL)
        {
            continue;
        }

        if( (!divParam->used) || (divParam->subtypeCode != SUBTYPE_QH2 ) )
        {
            continue;
        }

        if(BETTYPE_FW == GL_BETTYPE_A(betline))
        {
            uint8 ns[8] = {0};
            uint8 ne[8] = {0};
            memcpy((void *)ns,(void *)(bp->bitmap),bp->size/2);
            memcpy((void *)ne,(void *)(bp->bitmap + bp->size/2),bp->size/2);
            
            uint16 fws = atoi((char *)ns);
            uint16 fwe = atoi((char *)ne);
            
            if(((koctty_drawnum.winNum / 100) >= fws) && ((koctty_drawnum.winNum / 100) <= fwe))
            {
                 prizeCode = divParam->prizeCode;
                 if(koctty_drawnum.distribute_q2)
                 {
                      if(divParam->specWinFlag == 1)
                          prizeCode = PRIZE_SPEQH2;
                      else
                          prizeCode = PRIZE_QH2;
                  }
                  matchRet[prizeCode] += betline->betTimes;
                  ret++;
            }
            if (((koctty_drawnum.winNum % 100) >= fws) && ((koctty_drawnum.winNum % 100) <= fwe))
            {
                 prizeCode = divParam->prizeCode;
                 if(koctty_drawnum.distribute_h2)
                 {
                      if(divParam->specWinFlag == 1)
                          prizeCode = PRIZE_SPEQH2;
                      else
                          prizeCode = PRIZE_QH2;
                  }
                  matchRet[prizeCode] += betline->betTimes;
                  ret++;
            }
        }
        else
        {
            memset(andRet,0,sizeof(andRet));
            bitAnd(koctty_drawnum.zx4_map, 0, bp->bitmap, 0, 4, andRet);
            if(bitCount(andRet, 0, bp->size) == 2)
            {
                prizeCode = divParam->prizeCode;
                if(koctty_drawnum.distribute_q2)
                {
                    if(divParam->specWinFlag == 1)
                        prizeCode = PRIZE_SPEQH2;
                    else
                        prizeCode = PRIZE_QH2;
                }
                matchRet[prizeCode] += betline->betTimes;
                ret++;
            }

            memset(andRet,0,sizeof(andRet));

            bitAnd(koctty_drawnum.zx4_map, 4, bp->bitmap, 0, 4, andRet);
            if(bitCount(andRet, 0, bp->size) == 2)
            {
                prizeCode = divParam->prizeCode;
                if(koctty_drawnum.distribute_h2)
                {
                    if(divParam->specWinFlag == 1)
                        prizeCode = PRIZE_SPEQH2;
                    else
                        prizeCode = PRIZE_QH2;
                }
                matchRet[prizeCode] += betline->betTimes;
                ret++;
            }
        }
        if(ret > 0)
        {
            log_debug("gl_koctty_Match_QH2 divCode[%d],prizeRet[%d]:[%d]",
                                   jdx, divParam->prizeCode, ret);
            break;
        }
    }

    return ret;
}




int gl_koctty_Match_QH3(
        const BETLINE *betline,
        DIVISION_PARAM *division,
        uint32 matchRet[])
{
    int ret = 0;
    int prizeCode = 0;
    uint8 andRet[10] = {0};
    GL_BETPART* bp = GL_BETPART_A(betline);

    for(uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++) {
        DIVISION_PARAM *divParam = division + jdx;

        if (divParam == NULL)
        {
            continue;
        }

        if( (!divParam->used) || (divParam->subtypeCode != SUBTYPE_QH3 ) )
        {
            continue;
        }
        
        if(BETTYPE_FW == GL_BETTYPE_A(betline))
        {
            uint8 ns[8] = {0};
            uint8 ne[8] = {0};
            memcpy((void *)ns,(void *)(bp->bitmap),bp->size/2);
            memcpy((void *)ne,(void *)(bp->bitmap + bp->size/2),bp->size/2);
            
            uint16 fws = atoi((char *)ns);
            uint16 fwe = atoi((char *)ne);
            
            if(((koctty_drawnum.winNum / 10) >= fws) && ((koctty_drawnum.winNum / 10) <= fwe))
            {
                 prizeCode = divParam->prizeCode;
                 if(koctty_drawnum.distribute_q3)
                 {
                      if(divParam->specWinFlag == 1)
                          prizeCode = PRIZE_SPEQH3;
                      else
                          prizeCode = PRIZE_QH3;
                  }
                  matchRet[prizeCode] += betline->betTimes;
                  ret++;
            }
            if (((koctty_drawnum.winNum % 1000) >= fws) && ((koctty_drawnum.winNum % 1000) <= fwe))
            {
                 prizeCode = divParam->prizeCode;
                 if(koctty_drawnum.distribute_h3)
                 {
                      if(divParam->specWinFlag == 1)
                          prizeCode = PRIZE_SPEQH3;
                      else
                          prizeCode = PRIZE_QH3;
                  }
                  matchRet[prizeCode] += betline->betTimes;
                  ret++;
            }
        }
        else
        {

            memset(andRet,0,sizeof(andRet));

            bitAnd(koctty_drawnum.zx4_map, 0, bp->bitmap, 0, 6, andRet);
            if(bitCount(andRet, 0, bp->size) == 3)
            {
                prizeCode = divParam->prizeCode;
                if(koctty_drawnum.distribute_q3)
                {
                    if(divParam->specWinFlag == 1)
                        prizeCode = PRIZE_SPEQH3;
                    else
                        prizeCode = PRIZE_QH3;
                }
                matchRet[prizeCode] += betline->betTimes;
                ret++;
            }

            memset(andRet,0,sizeof(andRet));

            bitAnd(koctty_drawnum.zx4_map, 2, bp->bitmap, 0, 6, andRet);
            if(bitCount(andRet, 0, bp->size) == 3)
            {
                prizeCode = divParam->prizeCode;
                if(koctty_drawnum.distribute_h3)
                {
                    if(divParam->specWinFlag == 1)
                        prizeCode = PRIZE_SPEQH3;
                    else
                        prizeCode = PRIZE_QH3;
                }
                matchRet[prizeCode] += betline->betTimes;
                ret++;
            }
        }
        if(ret > 0)
        {
            log_debug("gl_koctty_Match_QH3 divCode[%d],prizeRet[%d]:[%d]",
                                   jdx, divParam->prizeCode, ret);
            break;
        }
    }

    return ret;
}



int gl_koctty_Match_4ZX(
        const BETLINE *betline,
        DIVISION_PARAM *division,
        uint32 matchRet[])
{
    int ret = 0;
    int prizeCode = 0;
    uint8 andRet[10] = {0};
    GL_BETPART* bp = GL_BETPART_A(betline);

    for(uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++) {
        DIVISION_PARAM *divParam = division + jdx;

        if (divParam == NULL)
        {
            continue;
        }
        if( (!divParam->used) || (divParam->subtypeCode != SUBTYPE_4ZX ) )
        {
            continue;
        }

        if ( koctty_drawnum.distribute_4d != divParam->distribute )
        {
            continue;
        }
        if(BETTYPE_FW == GL_BETTYPE_A(betline))
        {
            uint8 ns[8] = {0};
            uint8 ne[8] = {0};
            memcpy((void *)ns,(void *)(bp->bitmap),bp->size/2);
            memcpy((void *)ne,(void *)(bp->bitmap + bp->size/2),bp->size/2);
            
            uint16 fws = atoi((char *)ns);
            uint16 fwe = atoi((char *)ne);
            
            if(((koctty_drawnum.winNum ) >= fws) && ((koctty_drawnum.winNum ) <= fwe))
            {
                 prizeCode = divParam->prizeCode;
                 if(koctty_drawnum.distribute_4d)
                 {
                      if(divParam->specWinFlag == 1)
                          prizeCode = PRIZE_SPE4ZX;
                      else
                          prizeCode = PRIZE_4ZX;
                  }
                  matchRet[prizeCode] += betline->betTimes;
                  ret++;
            }
        }
        else
        {
            memset(andRet,0,sizeof(andRet));

            bitAnd(koctty_drawnum.zx4_map, 0, bp->bitmap, 0, 8, andRet);

            if(bitCount(andRet, 0, bp->size) == 4)
                ret = 1;
            if(ret > 0)
            {
                prizeCode = divParam->prizeCode;
                if(koctty_drawnum.distribute_4d)
                {
                    if(divParam->specWinFlag == 1)
                        prizeCode = PRIZE_SPE4ZX;
                    else
                        prizeCode = PRIZE_4ZX;
                }
                matchRet[prizeCode] += ret * betline->betTimes;
                //log_debug("gl_koctty_Match_4ZX divCode[%d],prizeRet[%d]:[%d]", jdx, prizeCode, ret);
                break;
            }
        }
    }

    return ret;
}

int gl_koctty_ticketMatch(
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
        case SUBTYPE_QH2:
            gl_koctty_Match_QH2(betline, (DIVISION_PARAM*)division, matchRet);
            break;
        case SUBTYPE_QH3:
            gl_koctty_Match_QH3(betline, (DIVISION_PARAM*)division, matchRet);
            break;
        case SUBTYPE_4ZX:
            gl_koctty_Match_4ZX(betline, (DIVISION_PARAM*)division, matchRet);
        }
    }

    for (uint16 jdx = 0; jdx < MAX_PRIZE_COUNT; jdx++) {
        if (matchRet[jdx]>0) {
            return 1;
        }
    }

    return 0;
}


