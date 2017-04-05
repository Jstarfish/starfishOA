#include "global.h"
#include "gl_inf.h"
#include "gl_koc11x5_rk.h"
#include "gl_koc11x5_db.h"

const uint8 subtypeNeedMatch[KOC11X5_SUBTYPE_COUNT + 1] = { 0, 2,3,4,5,6,7,8,1,2,3,2,3 };

const uint8 subtypeRxNeedCount[KOC11X5_SUBTYPE_COUNT + 1] = { 0, 2,3,4,5,5,5,5 };

// RX2  RX3 RX4 RX5 RX6 RX7  RX8  Q1   Q2ZU Q3ZU Q2ZX Q3ZX
const uint16 subtypeBetNumCount[KOC11X5_SUBTYPE_COUNT + 1] = { 0, 55, 165,330,462,462,330, 165, 11,  55,  165, 110, 990 };

//    RX2    RX3 RX4 RX5 RX6 RX7  RX8  Q1   Q2ZU Q3ZU Q2ZX Q3ZX
const uint16 subtypeWinNumCount[KOC11X5_SUBTYPE_COUNT + 1] = { 0, 10080,3360,840,120,720,2520,6720,5040,1008,336, 504, 56 };

const uint8 eachWinnumMatchBetIdx[KOC11X5_SUBTYPE_COUNT + 1] = { 0,10,10,5,1,6,15,20,1,1,1,1,1 };

GAME_RISK_KOC11X5_ISSUE_DATA *rk_koc11x5_issueData = NULL;
GAME_KOC11X5_RK_INDEX *rk_koc11x5_idxTable = NULL;


ISSUE_INFO *koc11x5_issue_info = NULL;
int totalIssueCount = 0;


#define KOC11X5_SEG_UNIT 2
#define WIN_RETURN_RATEBASE 1000


#define issueBeUsed(issue)                          (koc11x5_issue_info[issue].used)
#define issueState(issue)                           (koc11x5_issue_info[issue].curState)

#define issueStatRefuseMoney(issue)                 (koc11x5_issue_info[issue].stat.issueRefuseAmount)
#define issueStatRefuseCount(issue)                 (koc11x5_issue_info[issue].stat.issueRefuseCount)

#define winReturnRate(issue)                        (rk_koc11x5_issueData[issue].returnRate)

#define riskValue(issue)                            (rk_koc11x5_issueData[issue].riskValue)
#define maxPay(issue)                               (rk_koc11x5_issueData[issue].maxPay)

#define subWinMoney(issue,subtype)                  (rk_koc11x5_issueData[issue].sub_unitWin[subtype])

#define K11X5_BETS(issue,subtype,idx)               (rk_koc11x5_issueData[issue].bets[subtype][idx])

#define saleMoney(issue)                            (rk_koc11x5_issueData[issue].saleMoney)
#define saleMoneyCommit(issue)                      (rk_koc11x5_issueData[issue].saleMoneyCommit)

#define maxWinMoney(issue)                          (rk_koc11x5_issueData[issue].currMaxWin)
#define currPayMoney(issue)                         (rk_koc11x5_issueData[issue].currPay)

#define IndexBetNum(a,b,c,d,e)                      (rk_koc11x5_idxTable->bn2idx[a][b][c][d][e])
#define IndexBetMap(subtype, idx)                   (rk_koc11x5_idxTable->betmap[subtype][idx])
#define IndexBetWinNum(subtype, bidx,widx)          (rk_koc11x5_idxTable->b2windex[subtype][bidx][widx])
#define IndexWinToBet(wdx,subtype,bidx)             (rk_koc11x5_idxTable->w2bidx[wdx][subtype][bidx])


const uint16 betZX_First = 0xF00;
const uint16 betZX_Mid = 0xF0;
const uint16 betZX_End = 0xF;


static uint8 rptSubtype;
static char rptNumber[32]; //Notify betNumber String

void rk_swap_p(uint8 arr[], int a, int b)
{
    uint8 temp = arr[a];
    arr[a] = arr[b];
    arr[b] = temp;
}

void rk_permutation(uint8 arr[], int begin, int end, uint8 post[][5], int *idx)
{
    if (begin == end)
    {
        for (int i = 0; i <= end; i++)
        {
            post[*idx][i] = arr[i];
        }
        (*idx)++;
        return;
    }
    else
    {
        for (int j = begin; j <= end; j++)
        {
            rk_swap_p(arr, begin, j);
            rk_permutation(arr, begin + 1, end, post, idx);
            rk_swap_p(arr, j, begin);
        }
    }
}

bool rk_next_comb(int* comb, const int n, const int k)
{
    int i = k - 1;
    const int e = n - k;
    do
        comb[i]++;
    while (comb[i] > e + i && i--);
    if (comb[0] > e)
        return 0;
    while (++i < k)
        comb[i] = comb[i - 1] + 1;
    return 1;
}

int rk_combintion(int n, int k, uint8 post[][5])
{
    int count = 0;
    int comb[5] = { -1 };

    for (int i = 0; i < k; i++)
        comb[i] = i;
    do
    {
        for (int i = 0; i < k; i++)
        {
            post[count][i] = comb[i];
        }
        count++;
    } while (rk_next_comb(comb, n, k));
    return count;
}

bool unEqualFive(uint8 a, uint8 b, uint8 c, uint8 d, uint8 e)
{
    return ((a != b) && (a != c) && (a != d) && (a != e)
        && (b != c) && (b != d) && (b != e)
        && (c != d) && (c != e)
        && (d != e));
}

bool gl_k11x5_unique(const uint8 array[], int count)
{
    uint16 end = 0;
    uint8 ret[12] = { 0 };
    for (int i = 0; i < count; i++)
    {
        ret[array[i]]++;
    }
    for (int j = 0; j < 12; j++)
    {
        if (ret[j] > 0)
            end++;
    }
    return (end == count);
}

uint16 rk_getBetNumberIndex(BETLINE *line, uint16 dindex[])
{
    uint8 dan = 0;
    uint8 tuo = 0;
    uint8 dmatch = 0;
    uint8 tmatch = 0;
    uint8 cnt = 0;
    uint8 andRet[10] = { 0 };
    uint8 zxf[1], zxs[1], zxt[1];
    uint8 zxbit[2];
    uint8 num[3] = { 0 };
    uint16 ret = 0;

    GL_BETPART* bp = GL_BETPART_A(line);

    switch (line->subtype)
    {
    case SUBTYPE_Q1:
    case SUBTYPE_RX2:
    case SUBTYPE_RX3:
    case SUBTYPE_RX4:
    case SUBTYPE_RX5:
    case SUBTYPE_RX6:
    case SUBTYPE_RX7:
    case SUBTYPE_RX8:
    case SUBTYPE_Q2ZU:
    case SUBTYPE_Q3ZU:
        if (BETTYPE_DT == line->bettype)
        {
            dan = bitCount(bp->bitmap, 0, 2);
            tuo = bitCount(bp->bitmap, 2, 2);

            for (uint16 idx = 0; idx < subtypeBetNumCount[line->subtype]; idx++)
            {
                bitAnd((uint8 *)&(IndexBetMap(line->subtype, idx)), 0, bp->bitmap, 0, 2, andRet);
                dmatch = bitCount(andRet, 0, 2);

                memset(andRet, 0, sizeof(andRet));
                bitAnd((uint8 *)&(IndexBetMap(line->subtype, idx)), 0, bp->bitmap, 2, 2, andRet);
                tmatch = bitCount(andRet, 0, 2);

                if ((dan == dmatch) && ((dmatch + tmatch) >= subtypeNeedMatch[line->subtype]) )
                {
                    dindex[ret] = idx;
                    ret++;
                }
            }
        }
        else
        {
            for (uint16 idx = 0; idx < subtypeBetNumCount[line->subtype]; idx++)
            {
                memset(andRet, 0, sizeof(andRet));
                bitAnd((uint8 *)&(IndexBetMap(line->subtype, idx)), 0, bp->bitmap, 0, bp->size, andRet);
                cnt = bitCount(andRet, 0, 2);

                if (cnt == subtypeNeedMatch[line->subtype])
                {
                    dindex[ret] = idx;
                    ret++;
                }
            }
        }
        break;

    case SUBTYPE_Q2ZX:
        for (uint16 idx = 0; idx < subtypeBetNumCount[SUBTYPE_Q2ZX]; idx++)
        {
            zxf[0] = IndexBetMap(SUBTYPE_Q2ZX, idx) >> 4;
            zxs[0] = betZX_End & IndexBetMap(SUBTYPE_Q2ZX, idx);

            zxbit[0] = 0; zxbit[1] = 0;
            num2bit(zxf, 1, zxbit, 0, 1);
            memset(andRet, 0, sizeof(andRet));
            bitAnd(zxbit, 0, bp->bitmap, 0, 2, andRet);
            cnt = bitCount(andRet, 0, 2);
            if (cnt == 1)
            {
                zxbit[0] = 0; zxbit[1] = 0;
                num2bit(zxs, 1, zxbit, 0, 1);
                memset(andRet, 0, sizeof(andRet));
                bitAnd(zxbit, 0, bp->bitmap, 2, 2, andRet);
                cnt = bitCount(andRet, 0, 2);

                if (cnt == 1)
                {
                    dindex[ret] = idx;
                    ret++;
                }
            }
        }
        break;

    case SUBTYPE_Q3ZX:
        for (uint16 idx = 0; idx < subtypeBetNumCount[SUBTYPE_Q3ZX]; idx++)
        {
            zxf[0] = IndexBetMap(SUBTYPE_Q3ZX, idx) >> 8;
            zxs[0] = (betZX_Mid & IndexBetMap(SUBTYPE_Q3ZX, idx)) >> 4;
            zxt[0] = betZX_End & IndexBetMap(SUBTYPE_Q3ZX, idx);
            zxbit[0] = 0; zxbit[1] = 0;
            num2bit(zxf, 1, zxbit, 0, 1);
            memset(andRet, 0, sizeof(andRet));
            bitAnd(zxbit, 0, bp->bitmap, 0, 2, andRet);
            cnt = bitCount(andRet, 0, 2);
            if (cnt == 1)
            {
                zxbit[0] = 0; zxbit[1] = 0;
                num2bit(zxs, 1, zxbit, 0, 1);
                memset(andRet, 0, sizeof(andRet));
                bitAnd(zxbit, 0, bp->bitmap, 2, 2, andRet);
                cnt = bitCount(andRet, 0, 2);
                if (cnt == 1)
                {
                    zxbit[0] = 0; zxbit[1] = 0;
                    num2bit(zxt, 1, zxbit, 0, 1);
                    memset(andRet, 0, sizeof(andRet));
                    bitAnd(zxbit, 0, bp->bitmap, 4, 2, andRet);
                    cnt = bitCount(andRet, 0, 2);
                    if (cnt == 1)
                    {
                        dindex[ret] = idx;
                        ret++;
                    }
                }
            }
        }
        break;
    }
    return ret;
}

void rk_verifyFunAdder(BETLINE *line, int issue, bool commitFlag)
{
    uint16 dindex[MAX_BETS_COUNT] = { 0 };
    int bct = rk_getBetNumberIndex(line, dindex);

    for (int jdx = 0; jdx < bct; jdx++)
    {
        if (commitFlag)
            K11X5_BETS(issue, line->subtype, dindex[jdx]).betCountCommit += line->betTimes;
        else
            K11X5_BETS(issue, line->subtype, dindex[jdx]).betCount += line->betTimes;
    }
}

void rk_verifyFunRollback(BETLINE *line, int issue, bool commitFlag)
{
    uint16 dindex[MAX_BETS_COUNT] = { 0 };
    int bct = rk_getBetNumberIndex(line, dindex);

    for (int jdx = 0; jdx < bct; jdx++)
    {
        if (commitFlag)
            K11X5_BETS(issue, line->subtype, dindex[jdx]).betCountCommit -= line->betTimes;
        else
            K11X5_BETS(issue, line->subtype, dindex[jdx]).betCount -= line->betTimes;
    }
}


int rk_get_koc11x5_issueIndexBySeq(uint32 issueSeq)
{
    ISSUE_INFO *allIssueInfo = gl_koc11x5_getIssueTable();
    if (allIssueInfo == NULL)
    {
        log_error("gl_koc11x5_getIssueTable return NULL");
        return -1;
    }

    for (int i = 0; i < totalIssueCount; i++)
    {
        if (allIssueInfo[i].used)
        {
            if (allIssueInfo[i].serialNumber == issueSeq)
                return i;
        }
    }
    log_error("gl_koc11x5_getIssueTable seq[%d] return -1", issueSeq);
    return -1;
}


bool rk_getNumRestrictFlag(BETLINE *line)
{
    ts_notused(line);
    return false;
}


money_t getMatchMaxWin(int issue, uint16 winNumber)
{
    money_t maxMoney = 0;
    for (uint8 sub = SUBTYPE_RX2; sub <= SUBTYPE_Q3ZX; sub++)
        for (uint8 idx = 0; idx < eachWinnumMatchBetIdx[sub]; idx++)
            maxMoney += K11X5_BETS(issue, sub, IndexWinToBet(winNumber, sub, idx)).betCount * subWinMoney(issue, sub);

    return maxMoney;
}

void get_k11x5_sortArrayStr(const uint8 array[], int count, char *buf)
{
    char tmp[3];
    uint8 ret[12] = { 0 };
    for (int i = 0; i < count; i++)
    {
        ret[array[i]]++;
    }
    for (int j = 0; j < 12; j++)
    {
        if (ret[j] > 0)
        {
            memset(tmp, 0, sizeof(tmp));
            sprintf(tmp, "%02d+", j);
            strncat(buf, tmp, 3);
        }
    }
    char *e = buf;
    e[strlen(buf) - 1] = '\0';
}

void get_k11x5_betNumString(uint8 subtype, int idx, char *betnum)
{
    uint16 index = 0;

    uint8 num[10] = { 0 };

    switch (subtype)
    {
    case SUBTYPE_Q1:
        sprintf(betnum, "%02d", idx + 1);
        break;
    case SUBTYPE_RX2:
        for (uint16 n = 1; n < 2048; n++)
        {
            if (bitCount((uint8 *)&n, 0, 2) == 2)
            {
                if (index == idx)
                {
                    bit2num((uint8 *)&n, 2, num, 1);
                    if (num[0] < num[1])
                        sprintf(betnum, "%02d+%02d", num[0], num[1]);
                    else
                        sprintf(betnum, "%02d+%02d", num[1], num[0]);
                    break;
                }
                else
                    index++;
            }
        }
        break;
    case SUBTYPE_RX3:
        for (uint16 n = 1; n < 2048; n++)
        {
            if (bitCount((uint8 *)&n, 0, 2) == 3)
            {
                if (index == idx)
                {
                    bit2num((uint8 *)&n, 2, num, 1);
                    get_k11x5_sortArrayStr(num, 3, betnum);
                    break;
                }
                else
                    index++;
            }
        }
        break;
    case SUBTYPE_RX4:
        for (uint16 n = 1; n < 2048; n++)
        {
            if (bitCount((uint8 *)&n, 0, 2) == 4)
            {
                if (index == idx)
                {
                    bit2num((uint8 *)&n, 2, num, 1);
                    get_k11x5_sortArrayStr(num, 4, betnum);
                    break;
                }
                else
                    index++;
            }
        }
        break;
    case SUBTYPE_RX5:
        for (uint16 n = 1; n < 2048; n++)
        {
            if (bitCount((uint8 *)&n, 0, 2) == 5)
            {
                if (index == idx)
                {
                    bit2num((uint8 *)&n, 2, num, 1);
                    get_k11x5_sortArrayStr(num, 5, betnum);
                    break;
                }
                else
                    index++;
            }
        }
        break;
    case SUBTYPE_RX6:
        for (uint16 n = 1; n < 2048; n++)
        {
            if (bitCount((uint8 *)&n, 0, 2) == 6)
            {
                if (index == idx)
                {
                    bit2num((uint8 *)&n, 2, num, 1);
                    get_k11x5_sortArrayStr(num, 6, betnum);
                    break;
                }
                else
                    index++;
            }
        }
        break;
    case SUBTYPE_RX7:
        for (uint16 n = 1; n < 2048; n++)
        {
            if (bitCount((uint8 *)&n, 0, 2) == 7)
            {
                if (index == idx)
                {
                    bit2num((uint8 *)&n, 2, num, 1);
                    get_k11x5_sortArrayStr(num, 7, betnum);
                    break;
                }
                else
                    index++;
            }
        }
        break;
    case SUBTYPE_RX8:
        for (uint16 n = 1; n < 2048; n++)
        {
            if (bitCount((uint8 *)&n, 0, 2) == 8)
            {
                if (index == idx)
                {
                    bit2num((uint8 *)&n, 2, num, 1);
                    get_k11x5_sortArrayStr(num, 8, betnum);
                    break;
                }
                else
                    index++;
            }
        }
        break;
    case SUBTYPE_Q2ZU:
        for (uint16 n = 1; n < 2048; n++)
        {
            if (bitCount((uint8 *)&n, 0, 2) == 2)
            {
                if (index == idx)
                {
                    bit2num((uint8 *)&n, 2, num, 1);
                    if (num[0] < num[1])
                        sprintf(betnum, "%02d+%02d", num[0], num[1]);
                    else
                        sprintf(betnum, "%02d+%02d", num[1], num[0]);
                    break;
                }
                else
                    index++;
            }
        }
        break;
    case SUBTYPE_Q3ZU:
        for (uint16 n = 1; n < 2048; n++)
        {
            if (bitCount((uint8 *)&n, 0, 2) == 3)
            {
                if (index == idx)
                {
                    bit2num((uint8 *)&n, 2, num, 1);
                    get_k11x5_sortArrayStr(num, 3, betnum);
                    break;
                }
                else
                    index++;
            }
        }
        break;
    case SUBTYPE_Q2ZX:
        for (uint8 a = 1; a < 12; a++)
            for (uint8 b = 1; b < 12; b++)
            {
                if (a != b)
                {
                    if (index == idx)
                    {
                        sprintf(betnum, "%02d:%02d", a, b);
                        return;
                    }
                    else
                        index++;
                }
            }
        break;
    case SUBTYPE_Q3ZX:
        for (uint8 a = 1; a < 12; a++)
            for (uint8 b = 1; b < 12; b++)
                for (uint8 c = 1; c < 12; c++)
                {
                    if ((a != b) && (a != c) && (b != c))
                    {
                        if (index == idx)
                        {
                            sprintf(betnum, "%02d:%02d:%02d", a, b, c);
                            return;
                        }
                        else
                            index++;
                    }
                }
        break;
    }
    return;
}

void get_k11x5_WinnumStr(uint16 idx,char * buf)
{
    for (uint8 a = 1; a < 12; a++)
        for (uint8 b = 1; b < 12; b++)
            for (uint8 c = 1; c < 12; c++)
                for (uint8 d = 1; d < 12; d++)
                    for (uint8 e = 1; e < 12; e++)
                    {
                        uint8 arr[5] = { a,b,c,d,e };
                        if (gl_k11x5_unique(arr, 5))
                        {
                            if (idx == IndexBetNum(a, b, c, d, e))
                            {
                                sprintf(buf,"winNum  [%02d][%02d][%02d][%02d][%02d]\n", a, b, c, d, e);
                            }
                        }
                    }
    return;
}

void getOverMaxPayBets(int issue, uint16 winNumber, char *buf)
{
    char betnumStr[64];
    char tmp[256];

    memset(betnumStr, 0, sizeof(betnumStr));
    get_k11x5_WinnumStr(winNumber, betnumStr);
    strncat(buf, betnumStr, strlen(betnumStr));
    for (uint8 sub = SUBTYPE_RX2; sub <= SUBTYPE_Q3ZX; sub++)
        for (uint8 idx = 0; idx < eachWinnumMatchBetIdx[sub]; idx++)
            if (K11X5_BETS(issue, sub, IndexWinToBet(winNumber, sub, idx)).betCount > 0)
            {
                memset(betnumStr, 0, sizeof(betnumStr));
                get_k11x5_betNumString(sub, IndexWinToBet(winNumber, sub, idx), betnumStr);
                bzero(tmp, sizeof(tmp));
                sprintf(tmp, " subtype[%d] betnum[%s] bets[%d]", sub, betnumStr, K11X5_BETS(issue, sub, IndexWinToBet(winNumber, sub, idx)).betCount);
                strncat(buf, tmp, strlen(tmp));
            }

    return;
}


bool rk_verifyCommFun(BETLINE *line, int issue)
{
    char overpayInfo[1024];
    money_t lineMoney = line->betCount * line->betTimes * line->singleAmount;
    if (saleMoney(issue) + lineMoney <= riskValue(issue))
    {
        rk_verifyFunAdder(line, issue, false);
        return true;
    }
    money_t eachWin[990] = { 0 };
    uint16 dindex[MAX_BETS_COUNT] = { 0 };
    uint16 bct = rk_getBetNumberIndex(line, dindex);

    for (int bidx = 0; bidx < bct; bidx++)
    {
        //log_debug("rk_verifyCommFun betCount[%d] dindex[%d]=[%d]", bct, bidx,dindex[bidx]);
        money_t currSubtypeWin = line->betTimes * subWinMoney(issue, line->subtype);
        for (int wjdx = 0; wjdx < subtypeWinNumCount[line->subtype]; wjdx++)
        {
            //log_debug("rk_verifyCommFun winNumCount[%d] bidx[%d] wjdx[%d] ---> wIndex[%d]", subtypeWinNumCount[line->subtype], dindex[bidx],wjdx, IndexBetWinNum(line->subtype, dindex[bidx], wjdx));
            money_t matchWinMoney = getMatchMaxWin(issue, IndexBetWinNum(line->subtype, dindex[bidx], wjdx));
            money_t totalWinMoney = currSubtypeWin + matchWinMoney;
            money_t currPayMoney = totalWinMoney - (saleMoney(issue) + lineMoney) * winReturnRate(issue) / WIN_RETURN_RATEBASE;

            if (currPayMoney > maxPay(issue))
            {
                char currBetNumStr[64];

                memset(currBetNumStr, 0, sizeof(currBetNumStr));
                get_k11x5_betNumString(line->subtype, dindex[bidx], currBetNumStr);

                log_info("rk_verifyCommFun no pass issue[%d] line->subtype[%d] bct[%d] bidx[%d] dindex[%d] currBetNum[%s] line->betCount[%d] line->betTimes[%d] currentBetCount[%d] ,\
                      currSubtypeWin[%lld] matchMaxWin[%lld] totalWinMoney[%lld]  saleMoney[%lld] currPayMoney[%lld] maxPay[%lld] winIdx[%d]",
                    issue,line->subtype, bct, bidx,dindex[bidx], currBetNumStr,line->betCount, line->betTimes, K11X5_BETS(issue, line->subtype, dindex[bidx]).betCount,
                    currSubtypeWin, matchWinMoney, totalWinMoney, saleMoney(issue), currPayMoney, maxPay(issue), IndexBetWinNum(line->subtype, dindex[bidx], wjdx));
                bzero(overpayInfo, sizeof(overpayInfo));
                getOverMaxPayBets(issue, IndexBetWinNum(line->subtype, dindex[bidx], wjdx), overpayInfo);
                log_info("rk_verifyCommFun payInfo[%s]", overpayInfo);
                for (int rt = 0; rt < bidx; rt++)
                {
                    K11X5_BETS(issue, line->subtype, dindex[rt]).betCount -= line->betTimes;
                }
                rptSubtype = line->subtype;
                memset(rptNumber, 0, sizeof(rptNumber));
                sprintf(rptNumber, "%d", dindex[bidx]);
                return false;
            }
        }
        K11X5_BETS(issue, line->subtype, dindex[bidx]).betCount += line->betTimes;
    }

    return true;
}


void rk_updateReportData(BETLINE *line, int issue)
{
    ts_notused(line);
    ts_notused(issue);
    return;
}


void rk_saleDataAdder(BETLINE *line, int issue, bool commitFlag)
{
    if (commitFlag)
    {
        saleMoneyCommit(issue) += line->betCount * line->betTimes * line->singleAmount;
    }
    else
    {
        saleMoney(issue) += line->betCount * line->betTimes * line->singleAmount;
    }
}

void rk_saleDataRelease(BETLINE *line, int issue)
{
    saleMoney(issue) -= line->betCount * line->betTimes * line->singleAmount;
}


void rk_saleDataReleaseCommit(BETLINE *line, int issue)
{
    saleMoneyCommit(issue) -= line->betCount * line->betTimes * line->singleAmount;
}



/////////////////////////////////////////////////////////////////////////////////


//  风险控制验证接口
bool riskVerify(TICKET* pTicket, bool commitFlag)
{
    int issueIndex = -1;
    int startIssueIdx = rk_get_koc11x5_issueIndexBySeq(pTicket->issueSeq);

    if (!commitFlag)
    {
        for (int acount = 0; acount < pTicket->issueCount; acount++)
        {
            issueIndex = rk_get_koc11x5_issueIndexBySeq(pTicket->issueSeq + acount);
            if (issueIndex < 0)
            {
                log_info("riskVerify issue_seq[%d] acount[%d] not find!", pTicket->issueSeq, acount);
                continue;
            }
            BETLINE *line = (BETLINE *)GL_BETLINE(pTicket);
            for (int aline = 0;aline < pTicket->betlineCount; aline++)
            {

                if (rk_getNumRestrictFlag(line))
                {
                    log_info("riskVerify rk_getNumRestrictFlag! ");
                    return false;
                }
                if (!rk_verifyCommFun(line, issueIndex))
                {
                    issueStatRefuseMoney(startIssueIdx) += pTicket->amount;
                    issueStatRefuseCount(startIssueIdx)++;
                    log_info("koc11x5 rk no pass startIssueIdx[%d] issue[%lld] subtype[%d] amount[%lld]", startIssueIdx, pTicket->issue, line->subtype, pTicket->amount);
                    for (int rcount = 0; rcount < acount + 1; rcount++)
                    {
                        issueIndex = rk_get_koc11x5_issueIndexBySeq(pTicket->issueSeq + rcount);
                        line = (BETLINE *)GL_BETLINE(pTicket);
                        int backline = (rcount == acount) ? aline : pTicket->betlineCount;
                        for (int rline = 0;rline < backline; rline++)
                        {
                            rk_saleDataRelease(line, issueIndex);
                            rk_verifyFunRollback(line, issueIndex, commitFlag);
                            line = (BETLINE *)GL_BETLINE_NEXT(line);
                        }
                    }
                    send_rkNotify(pTicket->gameCode, pTicket->issue, rptSubtype, rptNumber);
                    return false;
                }
                rk_saleDataAdder(line, issueIndex, commitFlag);
                line = (BETLINE *)GL_BETLINE_NEXT(line);
            }
        }
    }
    else
    {
        for (int acount = 0; acount < pTicket->issueCount; acount++)
        {
            issueIndex = rk_get_koc11x5_issueIndexBySeq(pTicket->issueSeq + acount);
            if (issueIndex >= 0)
            {
                BETLINE *line = (BETLINE *)GL_BETLINE(pTicket);
                for (int aline = 0;aline < pTicket->betlineCount; aline++)
                {
                    rk_updateReportData(line, issueIndex);
                    rk_saleDataAdder(line, issueIndex, commitFlag);
                    rk_verifyFunAdder(line, issueIndex, commitFlag);
                    line = (BETLINE *)GL_BETLINE_NEXT(line);
                }
            }
        }
    }

    log_info("koc11x5 rk pass issue[%lld] commit[%d]", pTicket->issue, commitFlag ? 1 : 0);
    return true;
}


// 退票风险控制参数回滚接口
void riskRollback(TICKET* pTicket, bool commitFlag)
{
    int issueIndex = -1;

    for (int acount = 0; acount < pTicket->issueCount; acount++)
    {
        issueIndex = rk_get_koc11x5_issueIndexBySeq(pTicket->issueSeq + acount);
        if (issueIndex >= 0)
        {
            BETLINE *line = (BETLINE *)GL_BETLINE(pTicket);
            for (int i = 0;i < pTicket->betlineCount;i++)
            {
                if (commitFlag)
                    rk_saleDataReleaseCommit(line, issueIndex);
                else
                    rk_saleDataRelease(line, issueIndex);
                rk_verifyFunRollback(line, issueIndex, commitFlag);
                line = (BETLINE *)GL_BETLINE_NEXT(line);
            }
        }
    }
}

bool gl_koc11x5_rk_mem_get_meta(int *length)
{
    ts_notused(length);
    return true;
}

bool gl_koc11x5_rk_mem_save(void *buf, int *length)
{
    ts_notused(buf);
    ts_notused(length);
    return true;
}

bool gl_koc11x5_rk_mem_recovery(void *buf, int length)
{
    ts_notused(buf);
    ts_notused(length);
    return true;
}

void gl_koc11x5_rk_reinitData(void)
{
    for (int issue = 0;issue < totalIssueCount;issue++)
    {
        for (uint8 subtype = PRIZE_RX2; subtype <= PRIZE_Q3ZX; subtype++)
        {
            for (int idx = 0; idx < subtypeBetNumCount[subtype]; idx++)
            {
                K11X5_BETS(issue, subtype, idx).betCount = K11X5_BETS(issue, subtype, idx).betCountCommit;
            }
        }
        saleMoney(issue) = saleMoneyCommit(issue);
    }
    return;
}

bool gl_koc11x5_sale_rk_verify(TICKET* pTicket)
{
    if (riskVerify(pTicket, false))
    {
        return true;
    }
    return false;
}


void gl_koc11x5_sale_rk_commit(TICKET* pTicket)
{
    riskVerify(pTicket, true);
}


void gl_koc11x5_cancel_rk_rollback(TICKET* pTicket)
{
    riskRollback(pTicket, false);
}

void gl_koc11x5_cancel_rk_commit(TICKET* pTicket)
{
    riskRollback(pTicket, true);
}


////////////////////////////////////////////////////////////////



void setKOC11X5winMoney(uint64 issueNumber, int issue)
{
    PRIZE_PARAM *prizeParam = gl_koc11x5_getPrizeTable(issueNumber);
    DIVISION_PARAM * divisionTable = (DIVISION_PARAM *)gl_koc11x5_getDivisionTable(NULL, 0);

    for (int i = 0; i < MAX_PRIZE_COUNT; i++)
    {
        if (prizeParam[i].used)
        {
            for (int j = 0; j < MAX_DIVISION_COUNT; j++)
            {
                if ((divisionTable[j].used) && (prizeParam[i].prizeCode == divisionTable[j].prizeCode))
                {
                    subWinMoney(issue, divisionTable[j].subtypeCode) = prizeParam[i].fixedPrizeAmount;
                }
            }
        }
    }
    return;
}


void rk_clear_issue_betsData(int issue)
{
    for (uint8 subtype = PRIZE_RX2; subtype <= PRIZE_Q3ZX; subtype++)
    {
        for (int idx = 0; idx < subtypeBetNumCount[subtype]; idx++)
        {
            K11X5_BETS(issue, subtype, idx).betCount = 0;
            K11X5_BETS(issue, subtype, idx).betCountCommit = 0;
        }
    }

    saleMoney(issue) = 0;
    saleMoneyCommit(issue) = 0;
}


// load issue param when add issue by gl_drive , no need init ,need empty bets data
bool load_koc11x5_issue_rkdata(uint32 startIssueSeq, int issue_count, char *rkStr)
{
    money_t f = 0;
    money_t p = 0;
    const char *format = "%lld:%lld";

    sscanf(rkStr, format, &f, &p);

    POLICY_PARAM* policyParam = gl_getPolicyParam(GAME_KOC11X5);

    uint32 issueSeq = startIssueSeq;
    for (int issue_idx = 0; issue_idx < issue_count; issue_idx++)
    {
        int issue = rk_get_koc11x5_issueIndexBySeq(issueSeq);
        if (issue > -1)
        {
            if (issueBeUsed(issue))
            {
                ISSUE_INFO *issueInfo = gl_koc11x5_get_issueInfoByIndex(issue);

                winReturnRate(issue) = policyParam->returnRate;
                setKOC11X5winMoney(issueInfo->issueNumber, issue);

                riskValue(issue) = f;
                maxPay(issue) = p;

                rk_clear_issue_betsData(issue);
            }
            issueSeq++;
        }
    }
    return true;
}

void gl_koc11x5_rk_issueData2File(const char *filePath, void *buf)
{
    int fp;
    char fileName[MAX_PATH_LENGTH] = { 0 };
    sprintf(fileName, "%s/koc11x5_rk.snapshot", filePath);
    if ((fp = open(fileName, O_CREAT | O_WRONLY, S_IRUSR)) < 0)
    {
        log_error("open %s error!", fileName);
        return;
    }

    ssize_t ret = write(fp, buf, sizeof(GL_KOC11X5_RK_CHKP_ISSUE_DATA));
    if (ret < 0)
    {
        log_error("write %s error errno[%d]", fileName, errno);
    }
    close(fp);

}

bool gl_koc11x5_rk_issueFile2Data(const char *filePath, void *buf)
{
    int fp;
    char fileName[MAX_PATH_LENGTH] = { 0 };
    sprintf(fileName, "%s/koc11x5_rk.snapshot", filePath);
    if ((fp = open(fileName, O_RDONLY)) < 0)
    {
        log_error("open %s error!", fileName);
        return false;
    }

    ssize_t ret = read(fp, buf, sizeof(GL_KOC11X5_RK_CHKP_ISSUE_DATA));
    if (ret < 0)
    {
        log_error("read %s error errno[%d]", fileName, errno);
        return false;
    }
    close(fp);
    return true;
}

bool gl_koc11x5_rk_saveData(const char *filePath)
{
    int count = 0;

    void * buf = malloc(sizeof(GL_KOC11X5_RK_CHKP_ISSUE_DATA));
    if (NULL == buf)
    {
        log_error("gl_koc11x5_rk_restoreData malloc error! sizeof[%d]", sizeof(GL_KOC11X5_RK_CHKP_ISSUE_DATA));
        return false;
    }
    bzero(buf, sizeof(GL_KOC11X5_RK_CHKP_ISSUE_DATA));
    GL_KOC11X5_RK_CHKP_ISSUE_DATA * rkIssueData = (GL_KOC11X5_RK_CHKP_ISSUE_DATA *)buf;

    ISSUE_INFO *issueInfo = gl_koc11x5_getIssueTable();
    for (int i = 0; i < totalIssueCount; i++)
    {
        if (issueInfo[i].used)
        {
            if ((issueInfo[i].curState >= ISSUE_STATE_PRESALE) && (issueInfo[i].curState < ISSUE_STATE_CLOSED))
            {
                int issue = rk_get_koc11x5_issueIndexBySeq(issueInfo[i].serialNumber);
                rkIssueData->rkData[count].issueSeq = issueInfo[i].serialNumber;
                rkIssueData->rkData[count].saleMoneyCommit = saleMoneyCommit(issue);
                count++;
            }
        }
    }
    gl_koc11x5_rk_issueData2File(filePath, (void *)rkIssueData);
    free(buf);
    return true;
}

bool gl_koc11x5_rk_restoreData(const char *filePath)
{
    void * buf = malloc(sizeof(GL_KOC11X5_RK_CHKP_ISSUE_DATA));
    if (NULL == buf)
    {
        log_error("gl_koc11x5_rk_restoreData malloc error! sizeof[%d]", sizeof(GL_KOC11X5_RK_CHKP_ISSUE_DATA));
        return false;
    }
    bzero(buf, sizeof(GL_KOC11X5_RK_CHKP_ISSUE_DATA));
    GL_KOC11X5_RK_CHKP_ISSUE_DATA * rkIssueData = (GL_KOC11X5_RK_CHKP_ISSUE_DATA *)buf;

    if (gl_koc11x5_rk_issueFile2Data(filePath, (void *)rkIssueData))
    {
        for (int count = 0; count < MAX_ISSUE_NUMBER; count++)
        {
            if (rkIssueData->rkData[count].issueSeq > 0)
            {
                int issue = rk_get_koc11x5_issueIndexBySeq(rkIssueData->rkData[count].issueSeq);
                if (issue >= 0)
                {
                    for (uint8 subtype = PRIZE_RX2; subtype <= PRIZE_Q3ZX; subtype++)
                    {
                        for (int idx = 0; idx < subtypeBetNumCount[subtype]; idx++)
                        {
                            K11X5_BETS(issue, subtype, idx).betCount = K11X5_BETS(issue, subtype, idx).betCountCommit;
                        }
                    }
                    maxWinMoney(issue) = rkIssueData->rkData[count].currMaxWin;
                    currPayMoney(issue) = rkIssueData->rkData[count].currPay;
                    saleMoneyCommit(issue) = rkIssueData->rkData[count].saleMoneyCommit;

                }
            }
        }
        free(buf);
        return true;
    }
    else
    {
        free(buf);
        return false;
    }
}



bool gl_koc11x5_rk_getReportData(uint32 issueSeq, void *data)
{
    int issue = rk_get_koc11x5_issueIndexBySeq(issueSeq);
    if (issue < 0)
    {
        log_info("gl_koc11x5_rk_getReportData issue_seq[%d]  not find!", issueSeq);
        return false;
    }
    sprintf((char *)data, "1:%lld,%lld", currPayMoney(issue), maxPay(issue));
    return true;

}


void gl_getCanWinNum(uint8 subtype, uint8 num[], uint16 betidx)
{
    uint16 jdx = 0;
    uint8 a, b, c, d;
    uint8 pe[10081][5];

    switch (subtype)
    {
    case SUBTYPE_Q1:
    {
        for (a = 1; a < 12; a++)
            for (b = 1; b < 12; b++)
                for (c = 1; c < 12; c++)
                    for (d = 1; d < 12; d++)
                    {
                        uint8 arr[5] = { num[0],a,b,c,d };
                        if (gl_k11x5_unique(arr, 5))
                        {
                            uint8 arr[5] = { num[0],a,b,c,d };
                            IndexBetWinNum(subtype, betidx, jdx) = IndexBetNum(num[0], a, b, c, d);
                            jdx++;
                        }
                    }
    }
    break;

    case SUBTYPE_RX2:
    {
        uint16 wdx = 0;
        for (a = 1; a < 12; a++)
            for (b = 1; b < 12; b++)
                for (c = 1; c < 12; c++)
                {
                    uint8 arr[5] = { a, b, c, num[0], num[1] };
                    if (gl_k11x5_unique(arr, 5))
                    {
                        int start = 0;
                        bzero((void *)pe, sizeof(pe));
                        rk_permutation(arr, 0, 4, pe, &start);
                        for (jdx = 0; jdx < start; jdx++)
                        {
                            IndexBetWinNum(subtype, betidx, wdx) = IndexBetNum(pe[jdx][0], pe[jdx][1], pe[jdx][2], pe[jdx][3], pe[jdx][4]);
                            wdx++;
                        }

                    }
                }
    }
    break;
    case SUBTYPE_RX3:
    {
        uint16 wdx = 0;
        for (a = 1; a < 12; a++)
            for (b = 1; b < 12; b++)
            {
                uint8 arr[5] = { a, b, num[0], num[1], num[2] };
                if (gl_k11x5_unique(arr, 5))
                {
                    int start = 0;
                    bzero((void *)pe, sizeof(pe));
                    rk_permutation(arr, 0, 4, pe, &start);
                    for (jdx = 0; jdx < start; jdx++)
                    {
                        IndexBetWinNum(subtype, betidx, wdx) = IndexBetNum(pe[jdx][0], pe[jdx][1], pe[jdx][2], pe[jdx][3], pe[jdx][4]);
                        wdx++;
                    }
                }
            }
    }
    break;
    case SUBTYPE_RX4:
    {
        uint16 wdx = 0;
        for (a = 1; a < 12; a++)
        {
            uint8 arr[5] = { a, num[0], num[1], num[2], num[3] };
            if (gl_k11x5_unique(arr, 5))
            {
                int start = 0;
                bzero((void *)pe, sizeof(pe));
                rk_permutation(arr, 0, 4, pe, &start);
                for (jdx = 0; jdx < start; jdx++)
                {
                    IndexBetWinNum(subtype, betidx, wdx) = IndexBetNum(pe[jdx][0], pe[jdx][1], pe[jdx][2], pe[jdx][3], pe[jdx][4]);
                    wdx++;
                }
            }
        }
    }
    break;
    case SUBTYPE_RX5:
    {
        int start = 0;
        bzero((void *)pe, sizeof(pe));
        rk_permutation(num, 0, 4, pe, &start);
        for (jdx = 0; jdx < start; jdx++)
        {
            IndexBetWinNum(subtype, betidx, jdx) = IndexBetNum(pe[jdx][0], pe[jdx][1], pe[jdx][2], pe[jdx][3], pe[jdx][4]);
        }
    }
    break;

    case SUBTYPE_RX6:
    {
        uint16 wdx = 0;
        uint8 cm[7][5];
        bzero((void *)cm, sizeof(cm));
        int ct = rk_combintion(6, 5, cm);
        for (int idx = 0; idx < ct; idx++)
        {
            uint8 arr[5] = { num[cm[idx][0]],num[cm[idx][1]],num[cm[idx][2]],num[cm[idx][3]],num[cm[idx][4]] };
            int start = 0;
            bzero((void *)pe, sizeof(pe));
            rk_permutation(arr, 0, 4, pe, &start);
            for (jdx = 0; jdx < start; jdx++)
            {
                IndexBetWinNum(subtype, betidx, wdx) = IndexBetNum(pe[jdx][0], pe[jdx][1], pe[jdx][2], pe[jdx][3], pe[jdx][4]);
                wdx++;
            }
        }
    }
    break;

    case SUBTYPE_RX7:
    {
        uint16 wdx = 0;
        uint8 cm[22][5];
        bzero((void *)cm, sizeof(cm));
        int ct = rk_combintion(7, 5, cm);
        for (int idx = 0; idx < ct; idx++)
        {
            uint8 arr[5] = { num[cm[idx][0]],num[cm[idx][1]],num[cm[idx][2]],num[cm[idx][3]],num[cm[idx][4]] };
            int start = 0;
            bzero((void *)pe, sizeof(pe));
            rk_permutation(arr, 0, 4, pe, &start);
            for (jdx = 0; jdx < start; jdx++)
            {
                IndexBetWinNum(subtype, betidx, wdx) = IndexBetNum(pe[jdx][0], pe[jdx][1], pe[jdx][2], pe[jdx][3], pe[jdx][4]);
                wdx++;
            }
        }
    }
    break;

    case SUBTYPE_RX8:
    {
        uint16 wdx = 0;
        uint8 cm[57][5];
        bzero((void *)cm, sizeof(cm));
        int ct = rk_combintion(8, 5, cm);
        for (int idx = 0; idx < ct; idx++)
        {
            uint8 arr[5] = { num[cm[idx][0]],num[cm[idx][1]],num[cm[idx][2]],num[cm[idx][3]],num[cm[idx][4]] };
            int start = 0;
            bzero((void *)pe, sizeof(pe));
            rk_permutation(arr, 0, 4, pe, &start);
            for (jdx = 0; jdx < start; jdx++)
            {
                IndexBetWinNum(subtype, betidx, wdx) = IndexBetNum(pe[jdx][0], pe[jdx][1], pe[jdx][2], pe[jdx][3], pe[jdx][4]);
                wdx++;
            }
        }
    }
    break;

    case SUBTYPE_Q2ZU:
    {
        uint16 wdx = 0;
        for (a = 1; a < 12; a++)
            for (b = 1; b < 12; b++)
                for (c = 1; c < 12; c++)
                {
                    uint8 arr[5] = { a, b, c, num[0], num[1] };
                    if (gl_k11x5_unique(arr, 5))
                    {
                        int start = 0;
                        jdx = 0;
                        bzero((void *)pe, sizeof(pe));
                        rk_permutation(arr, 0, 2, pe, &start);
                        for (jdx = 0; jdx < start; jdx++)
                        {
                            IndexBetWinNum(subtype, betidx, wdx) = IndexBetNum(num[0], num[1], pe[jdx][0], pe[jdx][1], pe[jdx][2]);
                            wdx++;
                            IndexBetWinNum(subtype, betidx, wdx) = IndexBetNum(num[1], num[0], pe[jdx][0], pe[jdx][1], pe[jdx][2]);
                            wdx++;
                        }
                    }
                }
    }
    break;
    case SUBTYPE_Q3ZU:
    {
        for (a = 1; a < 12; a++)
            for (b = 1; b < 12; b++)
            {
                uint8 arr[5] = { a, b, num[0], num[1], num[2] };
                if (gl_k11x5_unique(arr, 5))
                {
                    IndexBetWinNum(subtype, betidx, jdx) = IndexBetNum(num[0], num[1], num[2],a,b);
                    jdx++;
                    IndexBetWinNum(subtype, betidx, jdx) = IndexBetNum(num[0], num[1], num[2],b,a);
                    jdx++;
                    IndexBetWinNum(subtype, betidx, jdx) = IndexBetNum(num[0], num[2], num[1], a, b);
                    jdx++;
                    IndexBetWinNum(subtype, betidx, jdx) = IndexBetNum(num[0], num[2], num[1], b, a);
                    jdx++;
                    IndexBetWinNum(subtype, betidx, jdx) = IndexBetNum(num[1], num[0], num[2], a, b);
                    jdx++;
                    IndexBetWinNum(subtype, betidx, jdx) = IndexBetNum(num[1], num[0], num[2], b, a);
                    jdx++;
                    IndexBetWinNum(subtype, betidx, jdx) = IndexBetNum(num[1], num[2], num[0], a, b);
                    jdx++;
                    IndexBetWinNum(subtype, betidx, jdx) = IndexBetNum(num[1], num[2], num[0], b, a);
                    jdx++;
                    IndexBetWinNum(subtype, betidx, jdx) = IndexBetNum(num[2], num[0], num[1], a, b);
                    jdx++;
                    IndexBetWinNum(subtype, betidx, jdx) = IndexBetNum(num[2], num[0], num[1], b, a);
                    jdx++;
                    IndexBetWinNum(subtype, betidx, jdx) = IndexBetNum(num[2], num[1], num[0], a, b);
                    jdx++;
                    IndexBetWinNum(subtype, betidx, jdx) = IndexBetNum(num[2], num[1], num[0], b, a);
                    jdx++;
                }
            }
    }
    break;

    case SUBTYPE_Q2ZX:
    {
        uint16 wdx = 0;
        for (a = 1; a < 12; a++)
            for (b = 1; b < 12; b++)
                for (c = 1; c < 12; c++)
                {
                    uint8 arr[5] = { a, b, c, num[0], num[1] };
                    if (gl_k11x5_unique(arr, 5))
                    {
                        int start = 0;
                        bzero((void *)pe, sizeof(pe));
                        rk_permutation(arr, 0, 2, pe, &start);
                        for (jdx = 0; jdx < start; jdx++)
                        {
                            IndexBetWinNum(subtype, betidx, wdx) = IndexBetNum(num[0], num[1], pe[jdx][0], pe[jdx][1], pe[jdx][2]);
                            wdx++;
                        }
                    }
                }
    }
    break;

    case SUBTYPE_Q3ZX:
    {
        uint16 wdx = 0;
        for (a = 1; a < 12; a++)
            for (b = 1; b < 12; b++)
            {
                uint8 arr[5] = { a,b,num[0],num[1],num[2] };
                if (gl_k11x5_unique(arr, 5))
                {
                    IndexBetWinNum(subtype, betidx, wdx) = IndexBetNum(num[0], num[1], num[2], a, b);
                    wdx++;
                    IndexBetWinNum(subtype, betidx, wdx) = IndexBetNum(num[0], num[1], num[2], b, a);
                    wdx++;
                }
            }
    }
    break;
    }
    return;
}


void gl_k11x5_rk_gw2bidx(uint16 windex, uint8 num[])
{
    uint8 cnt = 0;
    uint8 andRet[10] = { 0 };
    uint16 betmap = 0;
    uint16 bjdx[8] = { 0 };
    uint16 q2zujdx = 0;
    uint16 q3zujdx = 0;

    uint16 cmp = 0;

    for (uint8 subtype = SUBTYPE_RX2; subtype <= SUBTYPE_Q3ZX; subtype++)
    {
        betmap = 0;
        switch (subtype)
        {
        case SUBTYPE_Q1:
            IndexWinToBet(windex, SUBTYPE_Q1, 0) = num[0] - 1;
            break;
        case SUBTYPE_RX2:
        case SUBTYPE_RX3:
        case SUBTYPE_RX4:
        case SUBTYPE_RX5:
        case SUBTYPE_RX6:
        case SUBTYPE_RX7:
        case SUBTYPE_RX8:
        {
            num2bit(num, 5, (uint8 *)&betmap, 0, 1);
            for (uint16 idx = 0; idx < subtypeBetNumCount[subtype]; idx++)
            {
                uint16 cmp = betmap & IndexBetMap(subtype, idx);
                cnt = bitCount((uint8 *)&cmp, 0, 2);
                if (cnt == subtypeRxNeedCount[subtype])
                {
                    IndexWinToBet(windex, subtype, bjdx[subtype]) = idx;
                    bjdx[subtype]++;
                }
            }
        }
        break;
        case SUBTYPE_Q2ZU:
        {
            num2bit(num, 2, (uint8 *)&betmap, 0, 1);
            for (uint16 idx = 0; idx < subtypeBetNumCount[SUBTYPE_Q2ZU]; idx++)
            {
                //uint16 cmp = betmap & IndexBetMap(SUBTYPE_Q2ZU, idx);
                //cnt = bitCount((uint8 *)&cmp, 0, 2);
                //if (cnt == 2)
                if(betmap == IndexBetMap(SUBTYPE_Q2ZU, idx))
                {
                    IndexWinToBet(windex, SUBTYPE_Q2ZU, q2zujdx) = idx;
                    //log_debug("zzzzz: betmap[%d] windex[%d] q2zujdx[%d] idx[%d]", betmap, windex, q2zujdx,idx);
                    q2zujdx++;
                }
            }
        }
        break;
        case SUBTYPE_Q3ZU:
        {
            num2bit(num, 3, (uint8 *)&betmap, 0, 1);
            for (uint16 idx = 0; idx < subtypeBetNumCount[SUBTYPE_Q3ZU]; idx++)
            {
                //uint16 cmp = betmap & IndexBetMap(SUBTYPE_Q3ZU, idx);
                //cnt = bitCount((uint8 *)&cmp, 0, 2);
                //if (cnt == 3)
                if (betmap == IndexBetMap(SUBTYPE_Q3ZU, idx))
                {
                    IndexWinToBet(windex, SUBTYPE_Q3ZU, q3zujdx) = idx;
                    q3zujdx++;
                }
            }
        }
        break;

        case SUBTYPE_Q2ZX:
            betmap = (num[0] << 4) | num[1];
            for (uint16 idx = 0; idx < subtypeBetNumCount[SUBTYPE_Q2ZX]; idx++)
            {
                if (betmap == IndexBetMap(SUBTYPE_Q2ZX, idx))
                {
                    IndexWinToBet(windex, SUBTYPE_Q2ZX, 0) = idx;
                    break;
                }
            }
            break;

        case SUBTYPE_Q3ZX:
            betmap = (num[0] << 8) | (num[1] << 4) | num[2];
            for (uint16 idx = 0; idx < subtypeBetNumCount[SUBTYPE_Q3ZX]; idx++)
            {
                if (betmap == IndexBetMap(SUBTYPE_Q3ZX, idx))
                {
                    IndexWinToBet(windex, SUBTYPE_Q3ZX, 0) = idx;
                    break;
                }
            }
            break;
        }
    }
    return;
}

void gl_k11x5_init_betnum(void)
{
    uint16 index = 0;
    for (uint8 a = 1; a < 12; a++)
        for (uint8 b = 1; b < 12; b++)
            for (uint8 c = 1; c < 12; c++)
                for (uint8 d = 1; d < 12; d++)
                    for (uint8 e = 1; e < 12; e++)
                    {
                        uint8 arr[5] = { a,b,c,d,e };
                        if (gl_k11x5_unique(arr, 5))
                        {
                            IndexBetNum(a, b, c, d, e) = index;
                            index++;
                        }
                    }
    return;
}


void gl_k11x5_init_w2b(void)
{
    uint16 index = 0;

    for (uint8 a = 1; a < 12; a++)
        for (uint8 b = 1; b < 12; b++)
            for (uint8 c = 1; c < 12; c++)
                for (uint8 d = 1; d < 12; d++)
                    for (uint8 e = 1; e < 12; e++)
                    {
                        uint8 arr[5] = { a,b,c,d,e };
                        if (gl_k11x5_unique(arr, 5))
                        {
                            gl_k11x5_rk_gw2bidx(index, arr);
                            index++;
                        }
                    }

    return;
}



bool gl_koc11x5_rk_init(void)
{
    int cnt = 0;
    uint16 betidx[KOC11X5_SUBTYPE_COUNT + 1] = { 0 };
    uint16 sum = 0;
    uint8 a, b, c;
    uint8 num[5] = { 0 };

    if (rk_koc11x5_idxTable != NULL)
    {
        gl_k11x5_init_betnum();
        for (uint16 n = 1; n < 2048; n++)
        {
            cnt = bitCount((uint8 *)&n, 0, 2);
            switch (cnt)
            {
            case 1:
            {
                IndexBetMap(SUBTYPE_Q1, betidx[SUBTYPE_Q1]) = n;
                bzero((void *)num, sizeof(num));
                bit2num((uint8 *)&n, 2, num, 1);
                gl_getCanWinNum(SUBTYPE_Q1,num, betidx[SUBTYPE_Q1]);

                betidx[SUBTYPE_Q1]++;
            }
            break;
            case 2:
            {
                bzero((void *)num, sizeof(num));
                bit2num((uint8 *)&n, 2, num, 1);

                IndexBetMap(SUBTYPE_RX2, betidx[SUBTYPE_RX2]) = n;
                gl_getCanWinNum(SUBTYPE_RX2, num, betidx[SUBTYPE_RX2]);
                betidx[SUBTYPE_RX2]++;

                IndexBetMap(SUBTYPE_Q2ZU, betidx[SUBTYPE_Q2ZU]) = n;
                gl_getCanWinNum(SUBTYPE_Q2ZU, num, betidx[SUBTYPE_Q2ZU]);
                betidx[SUBTYPE_Q2ZU]++;
            }
            break;
            case 3:
            {
                bzero((void *)num, sizeof(num));
                bit2num((uint8 *)&n, 2, num, 1);

                IndexBetMap(SUBTYPE_RX3, betidx[SUBTYPE_RX3]) = n;
                gl_getCanWinNum(SUBTYPE_RX3, num, betidx[SUBTYPE_RX3]);
                betidx[SUBTYPE_RX3]++;

                IndexBetMap(SUBTYPE_Q3ZU, betidx[SUBTYPE_Q3ZU]) = n;
                gl_getCanWinNum(SUBTYPE_Q3ZU, num, betidx[SUBTYPE_Q3ZU]);
                betidx[SUBTYPE_Q3ZU]++;
            }
            break;
            case 4:
            {
                bzero((void *)num, sizeof(num));
                bit2num((uint8 *)&n, 2, num, 1);
                IndexBetMap(SUBTYPE_RX4, betidx[SUBTYPE_RX4]) = n;
                gl_getCanWinNum(SUBTYPE_RX4, num, betidx[SUBTYPE_RX4]);
                betidx[SUBTYPE_RX4]++;
            }
            break;
            case 5:
            {
                bzero((void *)num, sizeof(num));
                bit2num((uint8 *)&n, 2, num, 1);
                IndexBetMap(SUBTYPE_RX5, betidx[SUBTYPE_RX5]) = n;
                gl_getCanWinNum(SUBTYPE_RX5, num, betidx[SUBTYPE_RX5]);
                betidx[SUBTYPE_RX5]++;
            }
            break;
            case 6:
            {
                bzero((void *)num, sizeof(num));
                bit2num((uint8 *)&n, 2, num, 1);
                IndexBetMap(SUBTYPE_RX6, betidx[SUBTYPE_RX6]) = n;
                gl_getCanWinNum(SUBTYPE_RX6, num, betidx[SUBTYPE_RX6]);
                betidx[SUBTYPE_RX6]++;
            }
            break;
            case 7:
            {
                bzero((void *)num, sizeof(num));
                bit2num((uint8 *)&n, 2, num, 1);
                IndexBetMap(SUBTYPE_RX7, betidx[SUBTYPE_RX7]) = n;
                gl_getCanWinNum(SUBTYPE_RX7, num, betidx[SUBTYPE_RX7]);
                betidx[SUBTYPE_RX7]++;
            }
            break;
            case 8:
            {
                bzero((void *)num, sizeof(num));
                bit2num((uint8 *)&n, 2, num, 1);
                IndexBetMap(SUBTYPE_RX8, betidx[SUBTYPE_RX8]) = n;
                gl_getCanWinNum(SUBTYPE_RX8, num, betidx[SUBTYPE_RX8]);
                betidx[SUBTYPE_RX8]++;
            }
            break;
            default:
                continue;
            }
        }

        for (a = 1; a < 12; a++)
            for (b = 1; b < 12; b++)
            {
                if (a != b)
                {
                    sum = (a << 4) | b;
                    IndexBetMap(SUBTYPE_Q2ZX, betidx[SUBTYPE_Q2ZX]) = sum;
                    num[0] = a;
                    num[1] = b;
                    gl_getCanWinNum(SUBTYPE_Q2ZX, num, betidx[SUBTYPE_Q2ZX]);
                    betidx[SUBTYPE_Q2ZX]++;
                }
            }

        for (a = 1; a < 12; a++)
            for (b = 1; b < 12; b++)
                for (c = 1; c < 12; c++)
                {
                    if ((a != b) && (a != c) && (b != c))
                    {
                        sum = (a << 8) | (b << 4) | c;
                        IndexBetMap(SUBTYPE_Q3ZX, betidx[SUBTYPE_Q3ZX]) = sum;
                        num[0] = a;
                        num[1] = b;
                        num[2] = c;
                        gl_getCanWinNum(SUBTYPE_Q3ZX, num, betidx[SUBTYPE_Q3ZX]);
                        betidx[SUBTYPE_Q3ZX]++;
                    }
                }
        gl_k11x5_init_w2b();
    }
    return true;
}







