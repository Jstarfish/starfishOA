/*
 * gl_tema_prize_calc.cpp
 *
 *  Created on: 2011-6-30
 *      Author: Administrator
 */

#include "global.h"
#include "gl_inf.h"

#include "gl_tema_db.h"

// static function
/*****************************************************************************************
 * 函数名称：calcTotalPrize
 * 参数：
 * 返回值：
 * 功能描述：
 ******************************************************************************************/
static money_t calcTotalPrize(uint64 issue_number,PRIZE_PARAM *prize_param, GL_PRIZE_INFO prizeInfo[MAX_PRIZE_COUNT])
{
	ts_notused(issue_number);
    money_t totalPrizeMoney = 0;

    PRIZE_PARAM *prize_ptr = prize_param;
    for (uint8 i = 0; i < MAX_PRIZE_COUNT; ++i) {
        PRIZE_PARAM *prizeParam = &prize_ptr[i];
        if(!prizeParam->used) {
            continue;
        }
        // TODO...
        totalPrizeMoney += prizeInfo[i].prizeBaseCount * prizeInfo[i].prizeBaseAmount;
    }

    return totalPrizeMoney;
}

#if 0
/*****************************************************************************************
 * 函数名称：calcTotalLowPrize
 * 参数：
 * 返回值：
 * 功能描述：
 ******************************************************************************************/
static money_t calcTotalLowPrize(PRIZE_PARAM *prize_param, GL_PRIZE_INFO prizeInfo[MAX_PRIZE_COUNT])
{
    money_t totalPrizeMoney = 0;
    PRIZE_PARAM *prize_ptr = prize_param;
    for (uint8 i = 0; i < MAX_PRIZE_COUNT; ++i) {
        PRIZE_PARAM *prizeParam = &prize_ptr[i];
        if(!prizeParam->used) {
            continue;
        }
        if (prizeParam->assignType == ASSIGN_FIXED) {
            totalPrizeMoney += prizeInfo[i].prizeBaseCount * prizeParam->fixedPrizeAmount;
        }
    }

    return totalPrizeMoney;
}

/*****************************************************************************************
 * 函数名称：calcMoneyUsed
 * 参数：
 * 返回值：
 * 功能描述：计算所使用的高等奖金，奖池奖金，发行基金数目
 ******************************************************************************************/
static money_t calcPoolMoneyLeft(POLICY_PARAM *policyParam, money_t totalPrize, money_t totalSellMoney, money_t poolMoney)
{
    money_t prizeMoneyAmount = totalSellMoney * policyParam->returnRate/1000;

    return (poolMoney + prizeMoneyAmount - totalPrize);
}
#endif

int gl_tema_calc_prize(uint64 issue_number, GL_PRIZE_CALC *przCalc, GT_PRIZE_PARAM *prize_param, GL_PRIZE_INFO prizeInfo[MAX_PRIZE_COUNT])
{
	ts_notused(issue_number);
	money_t total_money_for_prize = przCalc->saleAmount * przCalc->returnRate/1000;
    for (uint8 i = 1; i < MAX_PRIZE_COUNT; ++i)
    {
		PRIZE_PARAM *prizeParam = &(prize_param->prize_param[i]);
		if(!prizeParam->used){
			continue;
		}

		prizeInfo[i].prizeBaseAmount = prizeParam->fixedPrizeAmount;
	}

    przCalc->prizeAmount = calcTotalPrize(0, prize_param->prize_param, prizeInfo);
    przCalc->poolUsed.poolAmount = total_money_for_prize - przCalc->prizeAmount;


    return 0;
}
