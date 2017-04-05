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
	
	koctty_drawnum.zx4sort =  gl_sortArray(xcode,4);
    koctty_drawnum.q3sort = gl_sortArray(xcode,3);
    koctty_drawnum.q2sort = gl_sortArray(xcode,2);

    const uint8 h3Num[3] = {xcode[1],xcode[2],xcode[3]};
    koctty_drawnum.h3sort = gl_sortArray(h3Num,3);

    const uint8 h2Num[2] = {xcode[2],xcode[3]};
    koctty_drawnum.h2sort = gl_sortArray(h2Num,2);

    uint8 cinNum[4] = {xcode[0],xcode[1],xcode[2],xcode[3]};
    num2bit( cinNum,4,(uint8 *)&(koctty_drawnum.zx4Compact),0,0);
    num2bit( cinNum,3,(uint8 *)&(koctty_drawnum.q3Compact),0,0);
    num2bit( cinNum,2,(uint8 *)&(koctty_drawnum.q2Compact),0,0);

    uint8 hinNum[3] = {xcode[1],xcode[2],xcode[3]};
    num2bit( hinNum,3,(uint8 *)&(koctty_drawnum.h3Compact),0,0);

    uint8 tinNum[2] = {xcode[2],xcode[3]};
    num2bit( tinNum,2,(uint8 *)&(koctty_drawnum.h2Compact),0,0);

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
    int cnt = 0;
    uint8 andRet[10] = {0};
    GL_BETPART* bp = GL_BETPART_A(betline);

    uint8 bettype = GL_BETTYPE_A(betline);

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

        if(BETTYPE_BC == bettype)
        {
            if(MODE_JC != bp->mode) {
            	log_warn("bp->mode[%d] not support when bettype is BC!",bp->mode);
            	continue;
            }

        	cnt = bitCount((uint8 *)&(koctty_drawnum.q2Compact), 0, 2);
        	if (cnt == 2)
        	{
        	    memset(andRet, 0, sizeof(andRet));
        	    bitAnd((uint8 *)&(koctty_drawnum.q2Compact), 0, bp->bitmap, 0, bp->size, andRet);
        	    cnt = bitCount(andRet, 0, bp->size);
        	    if (cnt == 2)
        	    {
        		    prizeCode = PRIZE_QH2;
        		    matchRet[prizeCode] += betline->betTimes;
        		    ret++;
        	    }
            }

        	cnt = bitCount((uint8 *)&(koctty_drawnum.h2Compact), 0, 2);
        	if (cnt == 2)
        	{
        	    memset(andRet, 0, sizeof(andRet));
        	    bitAnd((uint8 *)&(koctty_drawnum.h2Compact), 0, bp->bitmap, 0, bp->size, andRet);
        	    cnt = bitCount(andRet, 0, bp->size);
        	    if (cnt == 2)
        	    {
        		    prizeCode = PRIZE_QH2;
        		    matchRet[prizeCode] += betline->betTimes;
        		    ret++;
        	    }
        	}

        }
		else if(BETTYPE_BD == bettype)
        {
            if(MODE_FD != bp->mode) {
            	log_warn("bp->mode[%d] not support when bettype is BD!",bp->mode);
            	continue;
            }

            uint8 betnum[2] = {0};
            uint16 qh2sort = 0;

			uint8 position[35][4];
			memset((void *)position, 0, sizeof(position));

			int pcnt = gl_tty_getDsPosition(bp->size / 2, 2, position);
			for (int idx = 0; idx < pcnt; idx++)
			{
				gl_tty_getDsNum(bp->bitmap, betnum, position[idx], 2);
				qh2sort = (betnum[0] < betnum[1]) ? betnum[0] * 10 + betnum[1] : betnum[1] * 10 + betnum[0];
				int rep = gl_tty_getRepeat(qh2sort, 2);
				if (qh2sort == koctty_drawnum.q2sort)
				{
					if (koctty_drawnum.distribute_q2)
					{
						if (divParam->specWinFlag == 1)
							prizeCode = PRIZE_SPEQH2;
						else
							prizeCode = PRIZE_QH2;
						matchRet[prizeCode] += betline->betTimes * rep;
					}
					else
					{
						prizeCode = PRIZE_QH2;
						matchRet[prizeCode] += betline->betTimes * rep;
					}
					ret++;
				}

				if (qh2sort == koctty_drawnum.h2sort)
				{
					if (koctty_drawnum.distribute_h2)
					{
						if (divParam->specWinFlag == 1)
							prizeCode = PRIZE_SPEQH2;
						else
							prizeCode = PRIZE_QH2;
						matchRet[prizeCode] += betline->betTimes * rep;
					}
					else
					{
						prizeCode = PRIZE_QH2;
						matchRet[prizeCode] += betline->betTimes * rep;
					}
					ret++;
				}
			}

        }
        else if(BETTYPE_FW == bettype)
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
    int cnt = 0;
    uint8 andRet[10] = {0};
    GL_BETPART* bp = GL_BETPART_A(betline);
    uint8 bettype = GL_BETTYPE_A(betline);

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
        if(BETTYPE_BC == bettype)
        {
            if(MODE_JC != bp->mode) {
            	log_warn("bp->mode[%d] not support when bettype is BC!",bp->mode);
            	continue;
            }

            cnt = bitCount((uint8 *)&(koctty_drawnum.q3Compact), 0, 2);
            if(cnt == 3)
            {
        	    memset(andRet, 0, sizeof(andRet));
        	    bitAnd((uint8 *)&(koctty_drawnum.q3Compact), 0, bp->bitmap, 0, bp->size, andRet);
        	    cnt = bitCount(andRet, 0, bp->size);
        	    if (cnt == 3)
        	    {
        		    prizeCode = PRIZE_QH3;
        		    matchRet[prizeCode] += betline->betTimes;
        		    ret++;
        	    }
            }

            cnt = bitCount((uint8 *)&(koctty_drawnum.h3Compact), 0, 2);
            if(cnt == 3)
            {
        	    memset(andRet, 0, sizeof(andRet));
        	    bitAnd((uint8 *)&(koctty_drawnum.h3Compact), 0, bp->bitmap, 0, bp->size, andRet);
        	    cnt = bitCount(andRet, 0, bp->size);
        	    if (cnt == 3)
        	    {
        		    prizeCode = PRIZE_QH3;
        		    matchRet[prizeCode] += betline->betTimes;
        		    ret++;
        	    }
            }

        }
        else if(BETTYPE_BD == bettype)
        {
            if(MODE_FD != bp->mode) {
            	log_warn("bp->mode[%d] not support when bettype is BD!",bp->mode);
            	continue;
            }

            uint8 betnum[3] = {0};
            uint16 qh3sort = 0;

			uint8 position[35][4];
			memset((void *)position, 0, sizeof(position));

			int pcnt = gl_tty_getDsPosition(bp->size / 2, 3, position);
			for (int idx = 0; idx < pcnt; idx++)
			{
				gl_tty_getDsNum(bp->bitmap, betnum, position[idx], 3);
				qh3sort = gl_sortArray(betnum, 3);
				int rep = gl_tty_getRepeat(qh3sort, 3);
				if (qh3sort == koctty_drawnum.q3sort)
				{
					if (koctty_drawnum.distribute_q3)
					{
						if (divParam->specWinFlag == 1)
							prizeCode = PRIZE_SPEQH3;
						else
							prizeCode = PRIZE_QH3;
						matchRet[prizeCode] += betline->betTimes * rep;
					}
					else
					{
						prizeCode = PRIZE_QH3;
						matchRet[prizeCode] += betline->betTimes * rep;
					}
					ret++;
				}

				if (qh3sort == koctty_drawnum.h3sort)
				{
					if (koctty_drawnum.distribute_h3)
					{
						if (divParam->specWinFlag == 1)
							prizeCode = PRIZE_SPEQH3;
						else
							prizeCode = PRIZE_QH3;
						matchRet[prizeCode] += betline->betTimes * rep;
					}
					else
					{
						prizeCode = PRIZE_QH3;
						matchRet[prizeCode] += betline->betTimes * rep;
					}
					ret++;
				}
			}

        }
        else if(BETTYPE_FW == bettype)
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
    int cnt = 0;
    uint8 andRet[10] = {0};
    GL_BETPART* bp = GL_BETPART_A(betline);
    uint8 bettype = GL_BETTYPE_A(betline);

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

        if(BETTYPE_BC == bettype)
        {
            if(MODE_JC != bp->mode) {
            	log_warn("bp->mode[%d] not support when bettype is BC!",bp->mode);
            	continue;
            }

        	cnt = bitCount((uint8 *)&(koctty_drawnum.zx4Compact), 0, 2);
        	if (cnt != 4)
        	{
        		continue;
        	}

        	memset(andRet, 0, sizeof(andRet));
        	bitAnd((uint8 *)&(koctty_drawnum.zx4Compact), 0, bp->bitmap, 0, bp->size, andRet);
        	cnt = bitCount(andRet, 0, bp->size);
        	if (cnt == 4)
        	{
        		prizeCode = PRIZE_4ZX;
        		matchRet[prizeCode] += betline->betTimes;
        		ret++;
        	}

        }
		else if(BETTYPE_BD == bettype)
        {
            if(MODE_FD != bp->mode) {
            	log_warn("bp->mode[%d] not support when bettype is BD!",bp->mode);
            	continue;
            }

			uint16 z4sort = 0;
            uint8 betnum[4] = {0};
			uint8 position[35][4];
			memset((void *)position, 0, sizeof(position));

			int pcnt = gl_tty_getDsPosition(bp->size / 2, 4, position);
			for (int idx = 0; idx < pcnt; idx++)
			{
				gl_tty_getDsNum(bp->bitmap, betnum, position[idx], 4);
				z4sort = gl_sortArray(betnum, 4);

				if (z4sort == koctty_drawnum.zx4sort)
				{
					int rep = gl_tty_getRepeat(z4sort, 4);
					if (koctty_drawnum.distribute_4d)
					{
						if (divParam->specWinFlag == 1)
							prizeCode = PRIZE_SPE4ZX;
						else
							prizeCode = PRIZE_4ZX;
						matchRet[prizeCode] += betline->betTimes * rep;
					}
					else
					{
						prizeCode = PRIZE_4ZX;
						matchRet[prizeCode] += betline->betTimes * rep;
					}
					ret++;
				}
			}

        }
        else if(BETTYPE_FW == bettype)
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



int gl_koctty_Match_Q2(
        const BETLINE *betline,
        DIVISION_PARAM *division,
        uint32 matchRet[])
{
    int ret = 0;
    int prizeCode = 0;
    int cnt = 0;
    uint8 andRet[10] = {0};
    GL_BETPART* bp = GL_BETPART_A(betline);
    uint8 bettype = GL_BETTYPE_A(betline);

    for(uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++) {
        DIVISION_PARAM *divParam = division + jdx;

        if (divParam == NULL)
        {
            continue;
        }

        if( (!divParam->used) || (divParam->subtypeCode != SUBTYPE_Q2 ) )
        {
            continue;
        }

        if(BETTYPE_BC == bettype)
        {
            if(MODE_JC != bp->mode) {
            	log_warn("bp->mode[%d] not support when bettype is BC!",bp->mode);
            	continue;
            }

        	cnt = bitCount((uint8 *)&(koctty_drawnum.q2Compact), 0, 2);
        	if (cnt != 2)
        	{
        		continue;
        	}

        	memset(andRet, 0, sizeof(andRet));
        	bitAnd((uint8 *)&(koctty_drawnum.q2Compact), 0, bp->bitmap, 0, bp->size, andRet);
        	cnt = bitCount(andRet, 0, bp->size);
        	if (cnt == 2)
        	{
        		prizeCode = PRIZE_Q2;
        		matchRet[prizeCode] += betline->betTimes;
        		ret++;
        	}

        }
        else if(BETTYPE_BD == bettype)
        {
            if(MODE_FD != bp->mode) {
            	log_warn("bp->mode[%d] not support when bettype is BD!",bp->mode);
            	continue;
            }

            uint8 betnum[2] = {0};
            uint16 q2sort = 0;

			uint8 position[35][4];
			memset((void *)position, 0, sizeof(position));

			int pcnt = gl_tty_getDsPosition(bp->size / 2, 2, position);
			for (int idx = 0; idx < pcnt; idx++)
			{
				gl_tty_getDsNum(bp->bitmap, betnum, position[idx], 2);
				q2sort = (betnum[0] < betnum[1]) ? betnum[0] * 10 + betnum[1] : betnum[1] * 10 + betnum[0];
				if (q2sort == koctty_drawnum.q2sort)
				{
					int rep = gl_tty_getRepeat(q2sort, 2);
					if (koctty_drawnum.distribute_q2)
					{
						if (divParam->specWinFlag == 1)
							prizeCode = PRIZE_SPEQ2;
						else
							prizeCode = PRIZE_Q2;
						matchRet[prizeCode] += betline->betTimes * rep;
					}
					else
					{
						prizeCode = PRIZE_Q2;
						matchRet[prizeCode] += betline->betTimes * rep;
					}
					ret++;
				}
			}

        }
        else if(BETTYPE_FW == bettype)
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
                          prizeCode = PRIZE_SPEQ2;
                      else
                          prizeCode = PRIZE_Q2;
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
                        prizeCode = PRIZE_SPEQ2;
                    else
                        prizeCode = PRIZE_Q2;
                }
                matchRet[prizeCode] += betline->betTimes;
                ret++;
            }

        }
        if(ret > 0)
        {
            log_debug("gl_koctty_Match_Q2 divCode[%d],prizeRet[%d]:[%d]",
                                   jdx, divParam->prizeCode, ret);
            break;
        }
    }

    return ret;
}



int gl_koctty_Match_H2(
        const BETLINE *betline,
        DIVISION_PARAM *division,
        uint32 matchRet[])
{
    int ret = 0;
    int prizeCode = 0;
    int cnt = 0;
    uint8 andRet[10] = {0};
    GL_BETPART* bp = GL_BETPART_A(betline);
    uint8 bettype = GL_BETTYPE_A(betline);

    for(uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++) {
        DIVISION_PARAM *divParam = division + jdx;

        if (divParam == NULL)
        {
            continue;
        }

        if( (!divParam->used) || (divParam->subtypeCode != SUBTYPE_H2 ) )
        {
            continue;
        }

        if(BETTYPE_BC == bettype)
        {
            if(MODE_JC != bp->mode) {
            	log_warn("bp->mode[%d] not support when bettype is BC!",bp->mode);
            	continue;
            }

        	cnt = bitCount((uint8 *)&(koctty_drawnum.h2Compact), 0, 2);
        	if (cnt != 2)
        	{
        		continue;
        	}

        	memset(andRet, 0, sizeof(andRet));
        	bitAnd((uint8 *)&(koctty_drawnum.h2Compact), 0, bp->bitmap, 0, bp->size, andRet);
        	cnt = bitCount(andRet, 0, bp->size);
        	if (cnt == 2)
        	{
        		prizeCode = PRIZE_H2;
        		matchRet[prizeCode] += betline->betTimes;
        		ret++;
        	}

        }
        else if(BETTYPE_BD == bettype)
        {
            if(MODE_FD != bp->mode) {
            	log_warn("bp->mode[%d] not support when bettype is BD!",bp->mode);
            	continue;
            }

            uint8 betnum[2] = {0};
            uint16 h2sort = 0;
			uint8 position[35][4];
			memset((void *)position, 0, sizeof(position));

			int pcnt = gl_tty_getDsPosition(bp->size / 2, 2, position);
			for (int idx = 0; idx < pcnt; idx++)
			{
				gl_tty_getDsNum(bp->bitmap, betnum, position[idx], 2);
				h2sort = (betnum[0] < betnum[1]) ? betnum[0] * 10 + betnum[1] : betnum[1] * 10 + betnum[0];
				if (h2sort == koctty_drawnum.h2sort)
				{
					int rep = gl_tty_getRepeat(h2sort, 2);
					if (koctty_drawnum.distribute_h2)
					{
						if (divParam->specWinFlag == 1)
							prizeCode = PRIZE_SPEH2;
						else
							prizeCode = PRIZE_H2;
						matchRet[prizeCode] += betline->betTimes * rep;
					}
					else
					{
						prizeCode = PRIZE_H2;
						matchRet[prizeCode] += betline->betTimes * rep;
					}
					ret++;
				}
			}
        }
        else if(BETTYPE_FW == bettype)
        {
            uint8 ns[8] = {0};
            uint8 ne[8] = {0};
            memcpy((void *)ns,(void *)(bp->bitmap),bp->size/2);
            memcpy((void *)ne,(void *)(bp->bitmap + bp->size/2),bp->size/2);

            uint16 fws = atoi((char *)ns);
            uint16 fwe = atoi((char *)ne);

            if (((koctty_drawnum.winNum % 100) >= fws) && ((koctty_drawnum.winNum % 100) <= fwe))
            {
                 prizeCode = divParam->prizeCode;
                 if(koctty_drawnum.distribute_h2)
                 {
                      if(divParam->specWinFlag == 1)
                          prizeCode = PRIZE_SPEH2;
                      else
                          prizeCode = PRIZE_H2;
                  }
                  matchRet[prizeCode] += betline->betTimes;
                  ret++;
            }
        }
        else
        {

            memset(andRet,0,sizeof(andRet));

            bitAnd(koctty_drawnum.zx4_map, 4, bp->bitmap, 0, 4, andRet);
            if(bitCount(andRet, 0, bp->size) == 2)
            {
                prizeCode = divParam->prizeCode;
                if(koctty_drawnum.distribute_h2)
                {
                    if(divParam->specWinFlag == 1)
                        prizeCode = PRIZE_SPEH2;
                    else
                        prizeCode = PRIZE_H2;
                }
                matchRet[prizeCode] += betline->betTimes;
                ret++;
            }
        }
        if(ret > 0)
        {
            log_debug("gl_koctty_Match_H2 divCode[%d],prizeRet[%d]:[%d]",
                                   jdx, divParam->prizeCode, ret);
            break;
        }
    }

    return ret;
}




int gl_koctty_Match_Q3(
        const BETLINE *betline,
        DIVISION_PARAM *division,
        uint32 matchRet[])
{
    int ret = 0;
    int prizeCode = 0;
    int cnt = 0;
    uint8 andRet[10] = {0};
    GL_BETPART* bp = GL_BETPART_A(betline);
    uint8 bettype = GL_BETTYPE_A(betline);

    for(uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++) {
        DIVISION_PARAM *divParam = division + jdx;

        if (divParam == NULL)
        {
            continue;
        }

        if( (!divParam->used) || (divParam->subtypeCode != SUBTYPE_Q3 ) )
        {
            continue;
        }

        if(BETTYPE_BC == bettype)
        {
            if(MODE_JC != bp->mode) {
            	log_warn("bp->mode[%d] not support when bettype is BC!",bp->mode);
            	continue;
            }

        	cnt = bitCount((uint8 *)&(koctty_drawnum.q3Compact), 0, 2);
        	if (cnt != 3)
        	{
        		continue;
        	}

        	memset(andRet, 0, sizeof(andRet));
        	bitAnd((uint8 *)&(koctty_drawnum.q3Compact), 0, bp->bitmap, 0, bp->size, andRet);
        	cnt = bitCount(andRet, 0, bp->size);
        	if (cnt == 3)
        	{
        		prizeCode = PRIZE_Q3;
        		matchRet[prizeCode] += betline->betTimes;
        		ret++;
        	}

        }
		else if(BETTYPE_BD == bettype)
        {
            if(MODE_FD != bp->mode) {
            	log_warn("bp->mode[%d] not support when bettype is BD!",bp->mode);
            	continue;
            }

            uint8 betnum[3] = {0};
            uint16 q3sort = 0;

			uint8 position[35][4];
			memset((void *)position, 0, sizeof(position));

			int pcnt = gl_tty_getDsPosition(bp->size / 2, 3, position);
			for (int idx = 0; idx < pcnt; idx++)
			{
				gl_tty_getDsNum(bp->bitmap, betnum, position[idx], 3);
				q3sort = gl_sortArray(betnum, 3);
				if (q3sort == koctty_drawnum.q3sort)
				{
					int rep = gl_tty_getRepeat(q3sort, 3);
					if (koctty_drawnum.distribute_q3)
					{
						if (divParam->specWinFlag == 1)
							prizeCode = PRIZE_SPEQ3;
						else
							prizeCode = PRIZE_Q3;
						matchRet[prizeCode] += betline->betTimes * rep;
					}
					else
					{
						prizeCode = PRIZE_Q3;
						matchRet[prizeCode] += betline->betTimes * rep;
					}
					ret++;
				}
			}

        }
        else if(BETTYPE_FW == bettype)
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
                          prizeCode = PRIZE_SPEQ3;
                      else
                          prizeCode = PRIZE_Q3;
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
                        prizeCode = PRIZE_SPEQ3;
                    else
                        prizeCode = PRIZE_Q3;
                }
                matchRet[prizeCode] += betline->betTimes;
                ret++;
            }

        }
        if(ret > 0)
        {
            log_debug("gl_koctty_Match_Q3 divCode[%d],prizeRet[%d]:[%d]",
                                   jdx, divParam->prizeCode, ret);
            break;
        }
    }

    return ret;
}



int gl_koctty_Match_H3(
        const BETLINE *betline,
        DIVISION_PARAM *division,
        uint32 matchRet[])
{
    int ret = 0;
    int prizeCode = 0;
    int cnt = 0;
    uint8 andRet[10] = {0};
    GL_BETPART* bp = GL_BETPART_A(betline);
    uint8 bettype = GL_BETTYPE_A(betline);

    for(uint16 jdx = 0; jdx < MAX_DIVISION_COUNT; jdx++) {
        DIVISION_PARAM *divParam = division + jdx;

        if (divParam == NULL)
        {
            continue;
        }

        if( (!divParam->used) || (divParam->subtypeCode != SUBTYPE_H3 ) )
        {
            continue;
        }

        if(BETTYPE_BC == bettype)
        {
            if(MODE_JC != bp->mode) {
            	log_warn("bp->mode[%d] not support when bettype is BC!",bp->mode);
            	continue;
            }

        	cnt = bitCount((uint8 *)&(koctty_drawnum.h3Compact), 0, 2);
        	if (cnt != 3)
        	{
        		continue;
        	}

        	memset(andRet, 0, sizeof(andRet));
        	bitAnd((uint8 *)&(koctty_drawnum.h3Compact), 0, bp->bitmap, 0, bp->size, andRet);
        	cnt = bitCount(andRet, 0, bp->size);
        	if (cnt == 3)
        	{
        		prizeCode = PRIZE_H3;
        		matchRet[prizeCode] += betline->betTimes;
        		ret++;
        	}

        }
		else if(BETTYPE_BD == bettype)
        {
            if(MODE_FD != bp->mode) {
            	log_warn("bp->mode[%d] not support when bettype is BD!",bp->mode);
            	continue;
            }

            uint8 betnum[3] = {0};
            uint16 h3sort = 0;

			uint8 position[35][4];
			memset((void *)position, 0, sizeof(position));

			int pcnt = gl_tty_getDsPosition(bp->size / 2, 3, position);
			for (int idx = 0; idx < pcnt; idx++)
			{
				gl_tty_getDsNum(bp->bitmap, betnum, position[idx], 3);
				h3sort = gl_sortArray(betnum, 3);
				if (h3sort == koctty_drawnum.h3sort)
				{
					int rep = gl_tty_getRepeat(h3sort, 3);
					if (koctty_drawnum.distribute_h3)
					{
						if (divParam->specWinFlag == 1)
							prizeCode = PRIZE_SPEH3;
						else
							prizeCode = PRIZE_H3;
						matchRet[prizeCode] += betline->betTimes * rep;
					}
					else
					{
						prizeCode = PRIZE_H3;
						matchRet[prizeCode] += betline->betTimes * rep;
					}
					ret++;
				}
			}

        }
        else if(BETTYPE_FW == bettype)
        {
            uint8 ns[8] = {0};
            uint8 ne[8] = {0};
            memcpy((void *)ns,(void *)(bp->bitmap),bp->size/2);
            memcpy((void *)ne,(void *)(bp->bitmap + bp->size/2),bp->size/2);

            uint16 fws = atoi((char *)ns);
            uint16 fwe = atoi((char *)ne);

            if (((koctty_drawnum.winNum % 1000) >= fws) && ((koctty_drawnum.winNum % 1000) <= fwe))
            {
                 prizeCode = divParam->prizeCode;
                 if(koctty_drawnum.distribute_h3)
                 {
                      if(divParam->specWinFlag == 1)
                          prizeCode = PRIZE_SPEH3;
                      else
                          prizeCode = PRIZE_H3;
                  }
                  matchRet[prizeCode] += betline->betTimes;
                  ret++;
            }
        }
        else
        {
            memset(andRet,0,sizeof(andRet));

            bitAnd(koctty_drawnum.zx4_map, 2, bp->bitmap, 0, 6, andRet);
            if(bitCount(andRet, 0, bp->size) == 3)
            {
                prizeCode = divParam->prizeCode;
                if(koctty_drawnum.distribute_h3)
                {
                    if(divParam->specWinFlag == 1)
                        prizeCode = PRIZE_SPEH3;
                    else
                        prizeCode = PRIZE_H3;
                }
                matchRet[prizeCode] += betline->betTimes;
                ret++;
            }
        }
        if(ret > 0)
        {
            log_debug("gl_koctty_Match_H3 divCode[%d],prizeRet[%d]:[%d]",
                                   jdx, divParam->prizeCode, ret);
            break;
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
        case SUBTYPE_Q2:
        	gl_koctty_Match_Q2(betline, (DIVISION_PARAM*)division, matchRet);
        	break;
        case SUBTYPE_H2:
        	gl_koctty_Match_H2(betline, (DIVISION_PARAM*)division, matchRet);
        	break;
        case SUBTYPE_Q3:
        	gl_koctty_Match_Q3(betline, (DIVISION_PARAM*)division, matchRet);
        	break;
        case SUBTYPE_H3:
        	gl_koctty_Match_H3(betline, (DIVISION_PARAM*)division, matchRet);
        	break;
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


