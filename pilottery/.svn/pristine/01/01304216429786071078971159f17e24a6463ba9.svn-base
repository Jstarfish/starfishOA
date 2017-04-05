#include "global.h"
#include "gl_inf.h"

#include "gl_koctty_db.h"

#include "gl_koctty_prize_calc.h"

// static function
/*****************************************************************************************
 * 函数名称：calcTotalPrize
 * 参数：
 * 返回值：
 * 功能描述：
 ******************************************************************************************/
static money_t calcTotalPrize(uint64 issue_number, PRIZE_PARAM *prize_param, GL_PRIZE_INFO prizeInfo[MAX_PRIZE_COUNT])
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

int gl_koctty_calc_prize(uint64 issue_number, GL_PRIZE_CALC *przCalc, GT_PRIZE_PARAM *prize_param, GL_PRIZE_INFO prizeInfo[MAX_PRIZE_COUNT])
{
    //przarg->isPrizeMoneyEnough = 1;
    for (int i = 0; i < MAX_PRIZE_COUNT; ++i) {
        PRIZE_PARAM *prizeParam = &(prize_param->prize_param[i]);
        if(!prizeParam->used) {
            continue;
        }

        prizeInfo[i].prizeBaseAmount = prizeParam->fixedPrizeAmount;
    }

    przCalc->prizeAmount = calcTotalPrize(issue_number, prize_param->prize_param, prizeInfo);
    memcpy(&przCalc->poolUsed ,&przCalc->pool, sizeof(przCalc->poolUsed));
    przCalc->poolUsed.poolAmount = przCalc->saleAmount * przCalc->returnRate/1000
 									   - przCalc->prizeAmount;

   return 0;
}


