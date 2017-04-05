#include "global.h"
#include "gl_inf.h"

#include "gl_koc7lx_db.h"

//获得低等奖中奖奖金总和。在调用该函数时，固定奖等的单注中奖金额在prize_param[i].fixedPrizeAmount中，
//固定奖等的中奖注数在prizeInfoArray[i].prizeBaseCount中。
static money_t calcTotalLowPrize(
        uint64 issue_number,
        PRIZE_PARAM *prize_param,
        GL_PRIZE_INFO prizeInfoArray[MAX_PRIZE_COUNT])
{
    ts_notused(issue_number);
    money_t totalLowPrizeMoney = 0;

    for (uint8 i = 0; i < MAX_PRIZE_COUNT; i++)
    {
        if (!prize_param[i].used)
        {
            continue;
        }
        if (prize_param[i].assignType == ASSIGN_FIXED)
        {
            totalLowPrizeMoney += prizeInfoArray[i].prizeBaseCount * prize_param[i].fixedPrizeAmount;
        }
    }
    return totalLowPrizeMoney;
}

//获得全部派奖奖金总和。在调用该函数时，各奖等的单注中奖金额在prizeInfoArray[i].prizeBaseAmount中，
//各奖等的中奖注数在prizeInfoArray[i].prizeBaseCount中。
static money_t calcTotalPrize(
        uint64 issue_number,
        PRIZE_PARAM *prize_param,
        GL_PRIZE_INFO prizeInfoArray[MAX_PRIZE_COUNT])
{
    ts_notused(issue_number);
    money_t totalPrizeMoney = 0;

    for (uint8 i = 0; i < MAX_PRIZE_COUNT; i++)
    {
        if (!prize_param[i].used)
        {
            continue;
        }
        totalPrizeMoney += prizeInfoArray[i].prizeBaseAmount * prizeInfoArray[i].prizeBaseCount;
    }
    return totalPrizeMoney;
}


// 金额以瑞尔为单位进行计算
int gl_koc7lx_calc_prize(
        uint64 issue_number,
        GL_PRIZE_CALC *przCalc, 
        GT_PRIZE_PARAM *prizeTemplate,
        GL_PRIZE_INFO prizeInfo[MAX_PRIZE_COUNT])
{
    //拷贝所有的固定奖金
    for (int i = 0; i < MAX_PRIZE_COUNT; i++)
    {
        PRIZE_PARAM *prizeParam = prizeTemplate->prize_param + i;
        if (!prizeParam->used)
        {
            continue;
        }
        if (prizeParam->assignType == ASSIGN_FIXED)
        {
            prizeInfo[prizeParam->prizeCode].prizeBaseAmount = prizeParam->fixedPrizeAmount;
        }
    }

    //获得算奖配置参数字符串中的信息
    KOC7LX_CALC_PRIZE_PARAM *calc_prize_param = (KOC7LX_CALC_PRIZE_PARAM *)&(prizeTemplate->calc_struct);
    log_info("KOC7LX_CALC_PRIZE_PARAM low[%lld], up[%lld], min[%lld]",
            calc_prize_param->firstPrizeLowerBetLimit, calc_prize_param->firstPrizeUpperBetLimit, calc_prize_param->minAmount);

    if (calc_prize_param->minAmount == 0)
    {
        log_error("calc_prize_param->minAmount is 0");
        calc_prize_param->minAmount = 1;
    }

    //获得奖池资金(瑞尔)
    money_t pool_money_amount = przCalc->pool.poolAmount;

    //当期奖金充足
    przCalc->moneyEnough = 1;

    //当前转入调节基金的高等奖金为0瑞尔
    przCalc->highPrize2Adjust = 0;

    //奖池结余金额(瑞尔)
    money_t poolMoneyLeft = 0;

    //获得低等奖中奖奖金总和
    money_t totalLowPrizeMoney = calcTotalLowPrize(issue_number, prizeTemplate->prize_param, prizeInfo);

    //计算高等奖奖金
    money_t totalHighPrizeMoney = przCalc->saleAmount * przCalc->returnRate / 1000 - totalLowPrizeMoney + pool_money_amount;

    //下面定义的此变量(money_t firstPrizeRemainder)的含义 ：进调节基金的抹零值


    if (0 == prizeInfo[PRIZE_1].prizeBaseCount)//一等奖没有人中奖
    {
        prizeInfo[PRIZE_1].prizeBaseAmount = 0;
        prizeInfo[PRIZE_1H].prizeBaseAmount = 0;
        poolMoneyLeft += totalHighPrizeMoney;
    }
    else
    {
        if (totalHighPrizeMoney / prizeInfo[PRIZE_1].prizeBaseCount
                / calc_prize_param->minAmount * calc_prize_param->minAmount < calc_prize_param->firstPrizeLowerBetLimit )
        {
            przCalc->moneyEnough = 0;

            money_t bd = calc_prize_param->firstPrizeLowerBetLimit;
            prizeInfo[PRIZE_1].prizeBaseAmount = bd;

            money_t firstPrizeRemainder = 0;//calc_prize_param->firstPrizeLowerBetLimit %
                    //(prizeInfo[PRIZE_1].prizeBaseCount * 2 + prizeInfo[PRIZE_1H].prizeBaseCount);

            poolMoneyLeft =
                    totalHighPrizeMoney -
                    bd * prizeInfo[PRIZE_1].prizeBaseCount - firstPrizeRemainder;

            przCalc->highPrize2Adjust += firstPrizeRemainder;
        }
        else if (calc_prize_param->firstPrizeUpperBetLimit == 0)
        {
            money_t firstPrizePerBet = totalHighPrizeMoney  / prizeInfo[PRIZE_1].prizeBaseCount
                    / calc_prize_param->minAmount * calc_prize_param->minAmount;

            money_t firstPrizeRemainder = totalHighPrizeMoney - firstPrizePerBet *
                    prizeInfo[PRIZE_1].prizeBaseCount;

            prizeInfo[PRIZE_1].prizeBaseAmount = firstPrizePerBet;

            przCalc->highPrize2Adjust += firstPrizeRemainder;
            poolMoneyLeft = 0;
        }
        else
        {
            money_t firstPrizePerBet = totalHighPrizeMoney / prizeInfo[PRIZE_1].prizeBaseCount
                    / calc_prize_param->minAmount * calc_prize_param->minAmount;

            money_t firstPrizeRemainder = totalHighPrizeMoney % firstPrizePerBet;

            if (firstPrizePerBet > calc_prize_param->firstPrizeUpperBetLimit)
            {
                firstPrizePerBet = calc_prize_param->firstPrizeUpperBetLimit;
                firstPrizeRemainder = 0;//calc_prize_param->firstPrizeUpperBetLimit %
                         //(2 * prizeInfo[PRIZE_1].prizeBaseCount + prizeInfo[PRIZE_1H].prizeBaseCount);
            }

            prizeInfo[PRIZE_1].prizeBaseAmount = firstPrizePerBet;

            przCalc->highPrize2Adjust += firstPrizeRemainder;
            poolMoneyLeft = totalHighPrizeMoney - firstPrizeRemainder -
                    firstPrizePerBet * prizeInfo[PRIZE_1].prizeBaseCount;
        }
    }


    // 计算已用金额
    przCalc->prizeAmount = calcTotalPrize(issue_number, prizeTemplate->prize_param, prizeInfo);
    memcpy(&przCalc->poolUsed ,&przCalc->pool, sizeof(przCalc->poolUsed));

    money_t pl = poolMoneyLeft - przCalc->pool.poolAmount;

    przCalc->poolUsed.poolAmount = pl;

    return 0;
}

/*// 金额以瑞尔为单位进行计算
int gl_koc7lx_calc_prize(
        uint64 issue_number,
        GL_PRIZE_CALC *przCalc,
        GT_PRIZE_PARAM *prizeTemplate,
        GL_PRIZE_INFO prizeInfo[MAX_PRIZE_COUNT])
{
    //拷贝所有的固定奖金
    for (int i = 0; i < MAX_PRIZE_COUNT; i++)
    {
        PRIZE_PARAM *prizeParam = prizeTemplate->prize_param + i;
        if (!prizeParam->used)
        {
            continue;
        }
        if (prizeParam->assignType == ASSIGN_FIXED)
        {
            prizeInfo[prizeParam->prizeCode].prizeBaseAmount = prizeParam->fixedPrizeAmount;
        }
    }

    //获得算奖配置参数字符串中的信息
    KOC7LX_CALC_PRIZE_PARAM *calc_prize_param = (KOC7LX_CALC_PRIZE_PARAM *)&(prizeTemplate->calc_struct);
    log_info("KOC7LX_CALC_PRIZE_PARAM low[%lld], up[%lld], min[%lld]",
            calc_prize_param->firstPrizeLowerBetLimit, calc_prize_param->firstPrizeUpperBetLimit, calc_prize_param->minAmount);

    if (calc_prize_param->minAmount == 0)
    {
    	log_error("calc_prize_param->minAmount is 0");
    	calc_prize_param->minAmount = 1;
    }

    //获得奖池资金(瑞尔)
    money_t pool_money_amount = przCalc->pool.poolAmount;

    //当期奖金充足
    przCalc->moneyEnough = 1;

    //当前转入调节基金的高等奖金为0瑞尔
    przCalc->highPrize2Adjust = 0;

    //奖池结余金额(瑞尔)
    money_t poolMoneyLeft = 0;

    //获得低等奖中奖奖金总和
    money_t totalLowPrizeMoney = calcTotalLowPrize(issue_number, prizeTemplate->prize_param, prizeInfo);

    //计算高等奖奖金
    money_t totalHighPrizeMoney = przCalc->saleAmount * przCalc->returnRate / 1000 - totalLowPrizeMoney + pool_money_amount;

    //下面定义的此变量(money_t firstPrizeRemainder)的含义 ：进调节基金的抹零值

    if ( (0 == prizeInfo[PRIZE_1].prizeBaseCount) && (1 == prizeInfo[PRIZE_1H].prizeBaseCount) ) //一等奖（二分之一）有人中奖
    {
        money_t totalHighPrizeMoney_ALL = totalHighPrizeMoney;
    	totalHighPrizeMoney /= 2;

        if (totalHighPrizeMoney / prizeInfo[PRIZE_1H].prizeBaseCount
        		/ calc_prize_param->minAmount
        		* calc_prize_param->minAmount < calc_prize_param->firstPrizeLowerBetLimit / 2 )
        {
            przCalc->moneyEnough = 0;

			prizeInfo[PRIZE_1H].prizeBaseAmount = calc_prize_param->firstPrizeLowerBetLimit / 2;//保底不抹零

			money_t firstPrizeRemainder = 0;//calc_prize_param->firstPrizeLowerBetLimit % 2;

			prizeInfo[PRIZE_1].prizeBaseAmount = 0;
			poolMoneyLeft = totalHighPrizeMoney_ALL -
					prizeInfo[PRIZE_1H].prizeBaseAmount * prizeInfo[PRIZE_1H].prizeBaseCount - firstPrizeRemainder;

			przCalc->highPrize2Adjust += firstPrizeRemainder;
			if (poolMoneyLeft >= 0)
			{
				przCalc->moneyEnough = 1;
			}
		}
		else if (calc_prize_param->firstPrizeUpperBetLimit == 0)
		{
			money_t firstPrizePerBet = totalHighPrizeMoney / prizeInfo[PRIZE_1H].prizeBaseCount
					/ calc_prize_param->minAmount * calc_prize_param->minAmount;
			money_t firstPrizeRemainder = totalHighPrizeMoney - firstPrizePerBet *
					(prizeInfo[PRIZE_1H].prizeBaseCount);

			prizeInfo[PRIZE_1].prizeBaseAmount = 0;
			prizeInfo[PRIZE_1H].prizeBaseAmount = firstPrizePerBet;

			przCalc->highPrize2Adjust += firstPrizeRemainder;
			poolMoneyLeft = totalHighPrizeMoney_ALL - firstPrizeRemainder - firstPrizePerBet * prizeInfo[PRIZE_1H].prizeBaseCount;
		}
		else
		{
			money_t firstPrizePerBet = totalHighPrizeMoney / (prizeInfo[PRIZE_1H].prizeBaseCount)
					 / calc_prize_param->minAmount * calc_prize_param->minAmount;
			money_t firstPrizeRemainder = totalHighPrizeMoney % firstPrizePerBet;

			if (firstPrizePerBet > calc_prize_param->firstPrizeUpperBetLimit / 2)
			{
				firstPrizePerBet = calc_prize_param->firstPrizeUpperBetLimit / 2;
				firstPrizeRemainder = 0;//calc_prize_param->firstPrizeUpperBetLimit % 2;
			}

			prizeInfo[PRIZE_1].prizeBaseAmount = 0;
			prizeInfo[PRIZE_1H].prizeBaseAmount = firstPrizePerBet;

			przCalc->highPrize2Adjust += firstPrizeRemainder;
			poolMoneyLeft = totalHighPrizeMoney_ALL - firstPrizeRemainder - firstPrizePerBet * prizeInfo[PRIZE_1H].prizeBaseCount;
		}
    }
    else if ( (0 == prizeInfo[PRIZE_1].prizeBaseCount) && (0 == prizeInfo[PRIZE_1H].prizeBaseCount) )//一等奖没有人中奖
	{
		prizeInfo[PRIZE_1].prizeBaseAmount = 0;
		prizeInfo[PRIZE_1H].prizeBaseAmount = 0;
		poolMoneyLeft += totalHighPrizeMoney;
	}
    else
    {
        if (totalHighPrizeMoney / (prizeInfo[PRIZE_1].prizeBaseCount * 2 + prizeInfo[PRIZE_1H].prizeBaseCount)
        		/ calc_prize_param->minAmount * calc_prize_param->minAmount < calc_prize_param->firstPrizeLowerBetLimit / 2 )
        {
            przCalc->moneyEnough = 0;

			money_t bd = calc_prize_param->firstPrizeLowerBetLimit / 2;
			prizeInfo[PRIZE_1].prizeBaseAmount = bd * 2;
			prizeInfo[PRIZE_1H].prizeBaseAmount = bd;

			money_t firstPrizeRemainder = 0;//calc_prize_param->firstPrizeLowerBetLimit %
					//(prizeInfo[PRIZE_1].prizeBaseCount * 2 + prizeInfo[PRIZE_1H].prizeBaseCount);

			poolMoneyLeft =
					totalHighPrizeMoney -
					bd * (prizeInfo[PRIZE_1].prizeBaseCount * 2 +
					 prizeInfo[PRIZE_1H].prizeBaseCount) - firstPrizeRemainder;

			przCalc->highPrize2Adjust += firstPrizeRemainder;
		}
		else if (calc_prize_param->firstPrizeUpperBetLimit == 0)
		{
			money_t firstPrizePerBet = totalHighPrizeMoney  / (prizeInfo[PRIZE_1].prizeBaseCount * 2 + prizeInfo[PRIZE_1H].prizeBaseCount)
					/ calc_prize_param->minAmount * calc_prize_param->minAmount;

			money_t firstPrizeRemainder = totalHighPrizeMoney - firstPrizePerBet *
					(prizeInfo[PRIZE_1].prizeBaseCount * 2 + prizeInfo[PRIZE_1H].prizeBaseCount);

			prizeInfo[PRIZE_1].prizeBaseAmount = firstPrizePerBet * 2;
			prizeInfo[PRIZE_1H].prizeBaseAmount = firstPrizePerBet;

			przCalc->highPrize2Adjust += firstPrizeRemainder;
			poolMoneyLeft = 0;
		}
		else
		{
			money_t firstPrizePerBet = totalHighPrizeMoney / (prizeInfo[PRIZE_1].prizeBaseCount * 2 + prizeInfo[PRIZE_1H].prizeBaseCount)
					/ calc_prize_param->minAmount * calc_prize_param->minAmount;

			money_t firstPrizeRemainder = totalHighPrizeMoney % firstPrizePerBet;

			if (firstPrizePerBet > calc_prize_param->firstPrizeUpperBetLimit / 2)
			{
				firstPrizePerBet = calc_prize_param->firstPrizeUpperBetLimit / 2;
				firstPrizeRemainder = 0;//calc_prize_param->firstPrizeUpperBetLimit %
						 //(2 * prizeInfo[PRIZE_1].prizeBaseCount + prizeInfo[PRIZE_1H].prizeBaseCount);
			}

			prizeInfo[PRIZE_1].prizeBaseAmount = firstPrizePerBet * 2;
			prizeInfo[PRIZE_1H].prizeBaseAmount = firstPrizePerBet;

			przCalc->highPrize2Adjust += firstPrizeRemainder;
			poolMoneyLeft = totalHighPrizeMoney - firstPrizeRemainder -
					firstPrizePerBet * 2 * prizeInfo[PRIZE_1].prizeBaseCount -
					firstPrizePerBet * prizeInfo[PRIZE_1H].prizeBaseCount;
		}
    }


    // 计算已用金额
    przCalc->prizeAmount = calcTotalPrize(issue_number, prizeTemplate->prize_param, prizeInfo);
    memcpy(&przCalc->poolUsed ,&przCalc->pool, sizeof(przCalc->poolUsed));

    money_t pl = poolMoneyLeft - przCalc->pool.poolAmount;

    przCalc->poolUsed.poolAmount = pl;

    return 0;
}*/

