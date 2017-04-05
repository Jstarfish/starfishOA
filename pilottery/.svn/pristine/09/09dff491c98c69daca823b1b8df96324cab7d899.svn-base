#include "global.h"
#include "gl_inf.h"
#include "gl_koctty_rk.h"
#include "gl_koctty_db.h"


GAME_RISK_KOCTTY_ISSUE_DATA *rk_koctty_issueData = NULL;
KOCTTY_BETBC_TABLE *rk_koctty_bcTable = NULL;


ISSUE_INFO *koctty_issue_info = NULL;
int totalIssueCount = 0;


#define KOCTTY_SEG_UNIT 2
#define WIN_RETURN_RATEBASE 1000


#define issueBeUsed(issue)                          koctty_issue_info[issue].used
#define issueState(issue)                           koctty_issue_info[issue].curState

#define issueStatRefuseMoney(issue)                 koctty_issue_info[issue].stat.issueRefuseAmount
#define issueStatRefuseCount(issue)                 koctty_issue_info[issue].stat.issueRefuseCount

#define winReturnRate(issue)                        rk_koctty_issueData[issue].returnRate

#define riskValue(issue,subtype)                    rk_koctty_issueData[issue].riskCtrl[subtype].riskValue
#define maxPay(issue,subtype)                       rk_koctty_issueData[issue].riskCtrl[subtype].maxPay
#define winMoney(issue,subtype)                     rk_koctty_issueData[issue].riskCtrl[subtype].unitBetWin
#define specBetWin(issue,subtype)                   rk_koctty_issueData[issue].riskCtrl[subtype].specBetWin


#define TwoStarBet(issue,number)                    rk_koctty_issueData[issue].betData.kqh2[number]
#define ThreeStarBet(issue,number)                  rk_koctty_issueData[issue].betData.kqh3[number]
#define FourStarBet(issue,number)                   rk_koctty_issueData[issue].betData.k4[number]

#define FirstTwoBet(issue,number)                   rk_koctty_issueData[issue].betData.q2[number]
#define LastTwoBet(issue,number)                    rk_koctty_issueData[issue].betData.h2[number]
#define FirstThreeBet(issue,number)                 rk_koctty_issueData[issue].betData.q3[number]
#define LastThreeBet(issue,number)                  rk_koctty_issueData[issue].betData.h3[number]

#define saleMoney(subtype,issue)                    rk_koctty_issueData[issue].saleMoney[subtype]
#define saleMoneyCommit(subtype,issue)              rk_koctty_issueData[issue].saleMoneyCommit[subtype]


#define maxWinMoney(subtype,issue)                  rk_koctty_issueData[issue].currMaxWin[subtype]
#define currPayMoney(subtype,issue)                 rk_koctty_issueData[issue].currPay[subtype]

#define twoStarBCidx(bitnum)                        rk_koctty_bcTable->twoStarBC[bitnum]
#define threeStarBCidx(bitnum)                      rk_koctty_bcTable->threeStarBC[bitnum]
#define fourStarBCidx(bitnum)                       rk_koctty_bcTable->fourStarBC[bitnum]





void (*rk_verifyFunAdder[MAX_FUN_KEY])(BETLINE *line,int issue,bool commitFlag);
void (*rk_verifyFunRollback[MAX_FUN_KEY])(BETLINE *line,int issue,bool commitFlag);


static uint8 rptSubtype;
static char rptNumber[32]; //Notify betNumber String

static uint8 fourStarMp[25][5];


uint16 getBCnumFromBitmap(const uint8 *bitmap,const uint8 len)
{
    uint8 bitmatch[2] = {255,255};
    uint16 andRet = 0;
    bitAnd(bitmap, 0, bitmatch, 0, len, (uint8 *)&andRet);
	return andRet;
}



int rk_get_koctty_issueIndexBySeq(uint32 issueSeq)
{
    ISSUE_INFO *allIssueInfo = gl_koctty_getIssueTable();
    if(allIssueInfo == NULL)
    {
        log_error("gl_koctty_getIssueTable return NULL");
        return -1;
    }

    for(int i = 0; i < totalIssueCount ; i++)
    {
        if(allIssueInfo[i].used)
        {
            if(allIssueInfo[i].serialNumber == issueSeq)
                return i;
        }
    }
    log_error("gl_koctty_getIssueTable seq[%d] return -1",issueSeq);
    return -1;
}

uint32 * numCurrentBetCount(uint8 subtype,uint32 issue,uint32 index)
{
    switch(subtype)
    {
        case SUBTYPE_QH2:
            return &(TwoStarBet(issue,index).betCount);
        case SUBTYPE_QH3:
            return &(ThreeStarBet(issue,index).betCount);
        case SUBTYPE_4ZX:
            return &(FourStarBet(issue,index).betCount);

        case SUBTYPE_Q2:
        	return &(FirstTwoBet(issue,index).betCount);
        case SUBTYPE_H2:
        	return &(LastTwoBet(issue,index).betCount);
        case SUBTYPE_Q3:
        	return &(FirstThreeBet(issue,index).betCount);
        case SUBTYPE_H3:
        	return &(LastThreeBet(issue,index).betCount);
        default:
            return NULL;
    }
}

uint32 * numCurrentBetCountCommit(uint8 subtype,uint32 issue,uint32 index)
{
    switch(subtype)
    {
        case SUBTYPE_QH2:
            return &(TwoStarBet(issue,index).betCountCommit);
        case SUBTYPE_QH3:
            return &(ThreeStarBet(issue,index).betCountCommit);
        case SUBTYPE_4ZX:
            return &(FourStarBet(issue,index).betCountCommit);

        case SUBTYPE_Q2:
        	return &(FirstTwoBet(issue,index).betCountCommit);
        case SUBTYPE_H2:
        	return &(LastTwoBet(issue,index).betCountCommit);
        case SUBTYPE_Q3:
        	return &(FirstThreeBet(issue,index).betCountCommit);
        case SUBTYPE_H3:
        	return &(LastThreeBet(issue,index).betCountCommit);

        default:
            return NULL;
    }
}



bool rk_getNumRestrictFlag(BETLINE *line)
{
    ts_notused(line);
    return false;
}


uint16  rk_get2StarDirectNumberIndex(BETLINE *line, uint16 dindex[])
{
    uint16 bet = 0;
    GL_BETPART *betpart = GL_BETPART_A(line);
    switch(GL_BETTYPE_A(line))
    {
        case BETTYPE_DS:
        case BETTYPE_YXFS:
        {
            uint8 n1num[10] = {0};
            uint8 n2num[10] = {0};

            uint8 n1count = bitToUint8((uint8 *)(betpart->bitmap), n1num, 2, 0);
            uint8 n2count = bitToUint8((uint8 *)(betpart->bitmap+2), n2num, 2, 0);

            for(int n1 = 0; n1 < n1count; n1++)
            {
                for(int n2 = 0; n2 < n2count; n2++)
                {
                    dindex[bet] = n1num[n1]*10 + n2num[n2];
                    bet++;
                }
            }
            break;
        }
        case BETTYPE_FW:
        {
            uint8 ns[8] = {0};
            uint8 ne[8] = {0};
            memcpy((void *)ns,(void *)(betpart->bitmap),betpart->size/2);
            memcpy((void *)ne,(void *)(betpart->bitmap + betpart->size/2),betpart->size/2);
            
            uint16 fws = atoi((char *)ns);
            uint16 fwe = atoi((char *)ne);
            for(int x = fws; x <= fwe; x++)
            {
                dindex[bet] = x;
                bet++;
            }
            break;
        }
        case BETTYPE_BC:
        {
        	uint16 mybitmap = getBCnumFromBitmap(betpart->bitmap,betpart->size);
        	bet = twoStarBCidx(mybitmap).numCount;
            for(int x = 0; x <= bet ; x++)
            {
                dindex[x] = twoStarBCidx(mybitmap).numArray[x];
            }
            break;
        }
		case BETTYPE_BD:
        {
			uint16 sortn = 0;
			uint16 count = 0;
			uint8 betnum[2] = { 0 };
			uint8 position[35][4];
			memset((void *)position, 0, sizeof(position));

			int ret = gl_tty_getDsPosition(betpart->size / 2, 2, position);
			for (int idx = 0; idx < ret; idx++)
			{
				gl_tty_getDsNum(betpart->bitmap, betnum, position[idx], 2);
                dindex[bet] = betnum[0] * 10 + betnum[1];
                bet++;
                dindex[bet] = betnum[1] * 10 + betnum[0];
                bet++;
			}
            break;
        }
        default:
            log_error("rk_get2StarDirectNumberIndex() bettype[%d] error", GL_BETTYPE_A(line));
            return -1;
    }
    return bet;
}



uint16 rk_get4StarDirectSegIndex(BETLINE *line,uint16 dindex[])
{
    uint16 bet = 0;
    GL_BETPART *betpart = GL_BETPART_A(line);
    switch(GL_BETTYPE_A(line))
    {
        case BETTYPE_DS:
        case BETTYPE_YXFS:
        {
            uint8 n1num[10] = {0};
            uint8 n2num[10] = {0};
            uint8 n3num[10] = {0};
            uint8 n4num[10] = {0};

            uint8 n1count = bitToUint8((uint8 *)betpart->bitmap, n1num, 2, 0);
            uint8 n2count = bitToUint8((uint8 *)(betpart->bitmap+2), n2num, 2, 0);
            uint8 n3count = bitToUint8((uint8 *)(betpart->bitmap+4), n3num, 2, 0);
            uint8 n4count = bitToUint8((uint8 *)(betpart->bitmap+6), n4num, 2, 0);

            for(int n1 = 0; n1 < n1count; n1++)
            {
                for(int n2 = 0; n2 < n2count; n2++)
                {
                    for(int n3 = 0; n3 < n3count; n3++)
                    {
                        for(int n4 = 0; n4 < n4count; n4++)
                        {
                            dindex[bet] = n1num[n1]*1000 + n2num[n2]*100 + n3num[n3]*10 + n4num[n4];
                            bet++;
                        }
                    }
                }
            }
    
            break;
        }
        case BETTYPE_FW:
        {
            uint8 ns[8] = {0};
            uint8 ne[8] = {0};
            memcpy((void *)ns,(void *)(betpart->bitmap),betpart->size/2);
            memcpy((void *)ne,(void *)(betpart->bitmap + betpart->size/2),betpart->size/2);
            
            uint16 fws = atoi((char *)ns);
            uint16 fwe = atoi((char *)ne);
            for(int x = fws; x <= fwe; x++)
            {
                dindex[bet] = x;
                bet++;
            }
            break;
        }
        case BETTYPE_BC:
        {
        	uint16 mybitmap = getBCnumFromBitmap(betpart->bitmap,betpart->size);
        	bet = fourStarBCidx(mybitmap).numCount;
            for(int x = 0; x <= bet ; x++)
            {
                dindex[x] = fourStarBCidx(mybitmap).numArray[x];
            }
            break;
        }
		case BETTYPE_BD:
        {
			uint16 sortn = 0;
			uint16 count = 0;
			uint8 betnum[4] = { 0 };
			uint8 position[35][4];
			memset((void *)position, 0, sizeof(position));

			int ret = gl_tty_getDsPosition(betpart->size / 2, 4, position);
			for (int idx = 0; idx < ret; idx++)
			{
				gl_tty_getDsNum(betpart->bitmap, betnum, position[idx], 4);

                for (int idx = 0; idx < 24; idx++)
                {
                    dindex[bet] = betnum[fourStarMp[idx][0]] * 1000 + betnum[fourStarMp[idx][1]] * 100 + betnum[fourStarMp[idx][2]] * 10 + betnum[fourStarMp[idx][3]];
                    bet++;
                }

			}
            break;
        }
        default:
            log_error("rk_get4StarDirectNumberIndex() bettype[%d] error", GL_BETTYPE_A(line));
            return -1;
    }
    return bet;
}



uint16  rk_get3StarDirectNumberIndex(BETLINE *line, uint16 dindex[])
{
    uint16 bet = 0;
    GL_BETPART *betpart = GL_BETPART_A(line);
    switch(GL_BETTYPE_A(line))
    {
        case BETTYPE_DS:
        case BETTYPE_YXFS:
        {
            uint8 n1num[10] = {0};
            uint8 n2num[10] = {0};
            uint8 n3num[10] = {0};

            uint8 n1count = bitToUint8((uint8 *)(betpart->bitmap), n1num, 2, 0);
            uint8 n2count = bitToUint8((uint8 *)((betpart->bitmap)+2), n2num, 2, 0);
            uint8 n3count = bitToUint8((uint8 *)((betpart->bitmap)+4), n3num, 2, 0);


            for(int n1 = 0; n1 < n1count; n1++)
            {
                for(int n2 = 0; n2 < n2count; n2++)
                {
                    for(int n3 = 0; n3 < n3count; n3++)
                    {
                        dindex[bet] = n1num[n1]*100 + n2num[n2]*10 + n3num[n3];
                        bet++;
                    }
                }
            }
            break;
        }
        case BETTYPE_FW:
        {
            uint8 ns[8] = {0};
            uint8 ne[8] = {0};
            memcpy((void *)ns,(void *)(betpart->bitmap),betpart->size/2);
            memcpy((void *)ne,(void *)(betpart->bitmap + betpart->size/2),betpart->size/2);

            uint16 fws = atoi((char *)ns);
            uint16 fwe = atoi((char *)ne);
            for(int x = fws; x <= fwe; x++)
            {
                dindex[bet] = x;
                bet++;
            }
            break;
        }
        case BETTYPE_BC:
        {
        	uint16 mybitmap = getBCnumFromBitmap(betpart->bitmap,betpart->size);
        	bet = threeStarBCidx(mybitmap).numCount;
            for(int x = 0; x <= bet ; x++)
            {
                dindex[x] = threeStarBCidx(mybitmap).numArray[x];
            }
            break;
        }
		case BETTYPE_BD:
        {
			uint16 sortn = 0;
			uint16 count = 0;
			uint8 betnum[3] = { 0 };
			uint8 position[35][4];
			memset((void *)position, 0, sizeof(position));

			int ret = gl_tty_getDsPosition(betpart->size / 2, 3, position);
			for (int idx = 0; idx < ret; idx++)
			{
				gl_tty_getDsNum(betpart->bitmap, betnum, position[idx], 3);

                dindex[bet] = betnum[0] * 100 + betnum[1] * 10 + betnum[2];
                bet++;
                dindex[bet] = betnum[0] * 100 + betnum[2] * 10 + betnum[1];
                bet++;
                dindex[bet] = betnum[1] * 100 + betnum[0] * 10 + betnum[2];
                bet++;
                dindex[bet] = betnum[1] * 100 + betnum[2] * 10 + betnum[0];
                bet++;
                dindex[bet] = betnum[2] * 100 + betnum[0] * 10 + betnum[1];
                bet++;
                dindex[bet] = betnum[2] * 100 + betnum[1] * 10 + betnum[0];
                bet++;
			}
            break;
        }
        default:
            log_error("rk_get3StarDirectNumberIndex() bettype[%d] error", GL_BETTYPE_A(line));
            return -1;
    }
    return bet;
}




uint16 rk_getBetNumberIndex(BETLINE *line,uint16 dindex[])
{
    switch(line->subtype)
    {
        case SUBTYPE_QH2:
        case SUBTYPE_Q2:
        case SUBTYPE_H2:
            return rk_get2StarDirectNumberIndex(line, dindex);
        case SUBTYPE_QH3:
        case SUBTYPE_Q3:
        case SUBTYPE_H3:
            return rk_get3StarDirectNumberIndex(line, dindex);
        case SUBTYPE_4ZX:
            return rk_get4StarDirectSegIndex(line, dindex);
        default:
            log_error("rk_getBetNumberIndex() subtype[%d] error", line->subtype);
            return -1;
    }
}


bool isSpecNum(uint8 subtype,uint16 num)
{
    switch(subtype)
    {
        case SUBTYPE_QH2:
        case SUBTYPE_Q2:
        case SUBTYPE_H2:
            return ((num/10) == (num%10));

        case SUBTYPE_QH3:
        case SUBTYPE_Q3:
        case SUBTYPE_H3:
        {
            uint8 a = num/100;
            uint8 b = (num - num/100 * 100)/10;
            uint8 c = num%10;
            return ((a == b) && (b == c));
        }
        case SUBTYPE_4ZX:
        {
            uint8 a = num/1000;
            uint8 b = (num - num/1000 * 1000)/100;
            uint8 c = (num - a*1000 - b*100)/10;
            uint8 d = num%10;
            return ((a == b) && (b == c) && (c == d));
        }
    }
    return false;
}


money_t  getMatchMaxWin(uint8 subtype,uint16 betNumber,int issue,bool specFlag,uint16 betCounts)
{
    money_t myWinMoney;
    money_t betsWin;
    money_t ret = 0;
    uint16 matchNum;
    uint16 addCount;

    switch(subtype)
    {
    case SUBTYPE_QH2:
    {
        for(uint8 m=0; m < 100; m++)
        {
            myWinMoney = ((m/10) == (m%10))?specBetWin(issue,SUBTYPE_QH2):winMoney(issue,SUBTYPE_QH2);
            addCount = (m == betNumber)? betCounts : 0;
            betsWin = (*(numCurrentBetCount(SUBTYPE_QH2,issue,m)) + addCount) * myWinMoney;
            ret = (betsWin > ret)? betsWin : ret;
        }
        return ret;
    }
    case SUBTYPE_QH3:
    {
        uint8 n1 = betNumber/100;
        uint8 n2 = (betNumber - n1 * 100) / 10;
        uint8 n3 = betNumber % 10;

        for(uint8 x=0; x < 10; x++)
        {
            matchNum = x * 100 + n1 * 10 + n2;
            myWinMoney = ((x == n1) && (n1 == n2))?specBetWin(issue,SUBTYPE_QH3):winMoney(issue,SUBTYPE_QH3);
            betsWin = (*(numCurrentBetCount(SUBTYPE_QH3,issue,matchNum)))  * myWinMoney;
            ret = (betsWin > ret)? betsWin : ret;

            // log_debug("11111 matchNum[%d] ret[%lld]",matchNum,ret);

            matchNum = n2 * 100 + n3 * 10 + x;
            myWinMoney = ((n2 == n3) && (n3 == x))?specBetWin(issue,SUBTYPE_QH3):winMoney(issue,SUBTYPE_QH3);
            addCount = (specFlag && (betNumber == matchNum)) ? betCounts : 0;
            betsWin = (*(numCurrentBetCount(SUBTYPE_QH3,issue,matchNum)) + addCount)  * myWinMoney;
            ret = (betsWin > ret)? betsWin : ret;

            // log_debug("22222 matchNum[%d] ret[%lld]",matchNum,ret);
        }
        return ret;
    }
    case SUBTYPE_Q2:
    case SUBTYPE_H2:
    case SUBTYPE_Q3:
    case SUBTYPE_H3:
    case SUBTYPE_4ZX:
        return 0;

    }

    return 0;
}


money_t  getMatchMaxWinCommit(uint8 subtype,uint16 betNumber,int issue,bool specFlag,uint16 betCounts)
{
    money_t myWinMoney;
    money_t betsWin;
    money_t ret = 0;
    uint16 matchNum;
    uint16 addCount;

    switch(subtype)
    {
    case SUBTYPE_QH2:
    {
        for(uint8 m=0; m < 100; m++)
        {
            myWinMoney = ((m/10) == (m%10))?specBetWin(issue,SUBTYPE_QH2):winMoney(issue,SUBTYPE_QH2);
            addCount = (m == betNumber)? betCounts : 0;
            betsWin = (*(numCurrentBetCountCommit(SUBTYPE_QH2,issue,m)) + addCount) * myWinMoney;
            ret = (betsWin > ret)? betsWin : ret;
        }
        return ret;
    }
    case SUBTYPE_QH3:
    {
        uint8 n1 = betNumber/100;
        uint8 n2 = (betNumber - n1 * 100) / 10;
        uint8 n3 = betNumber % 10;

        for(uint8 x=0; x < 10; x++)
        {
            matchNum = x * 100 + n1 * 10 + n2;
            myWinMoney = ((x == n1) && (n1 == n2))?specBetWin(issue,SUBTYPE_QH3):winMoney(issue,SUBTYPE_QH3);
            betsWin = (*(numCurrentBetCountCommit(SUBTYPE_QH3,issue,matchNum)))  * myWinMoney;
            ret = (betsWin > ret)? betsWin : ret;

            // log_debug("11111 matchNum[%d] ret[%lld]",matchNum,ret);

            matchNum = n2 * 100 + n3 * 10 + x;
            myWinMoney = ((n2 == n3) && (n3 == x))?specBetWin(issue,SUBTYPE_QH3):winMoney(issue,SUBTYPE_QH3);
            addCount = (specFlag && (betNumber == matchNum)) ? betCounts : 0;
            betsWin = (*(numCurrentBetCountCommit(SUBTYPE_QH3,issue,matchNum)) + addCount)  * myWinMoney;
            ret = (betsWin > ret)? betsWin : ret;

            // log_debug("22222 matchNum[%d] ret[%lld]",matchNum,ret);
        }
        return ret;
    }
    case SUBTYPE_Q2:
    case SUBTYPE_H2:
    case SUBTYPE_Q3:
    case SUBTYPE_H3:
    case SUBTYPE_4ZX:
        return 0;

    }

    return 0;
}

// koctty sales only one subtype each ticket, is limited by terminal, so we add total ticket amount as subtype money 
bool rk_verifyCommFun(BETLINE *line,int issue, money_t ticketAmount)
{
    if(saleMoney(line->subtype,issue) + ticketAmount <= riskValue(issue,line->subtype))
    {
        rk_verifyFunAdder[line->subtype](line,issue, false);
        return true;
    }

    uint16 dindex[MAX_BETS_COUNT] = {0};
    int betNumIndexCount = rk_getBetNumberIndex(line,dindex);

    for(int jdx=0;jdx < betNumIndexCount;jdx++)
    {
        bool  specNumFlag = isSpecNum(line->subtype,dindex[jdx]);
        money_t myWinMoney = specNumFlag ? specBetWin(issue,line->subtype):winMoney(issue,line->subtype);

        money_t matchMaxWin = getMatchMaxWin(line->subtype,dindex[jdx],issue,specNumFlag,line->betTimes);

        money_t totalWinMoney = (line->betTimes + *(numCurrentBetCount(line->subtype,issue,dindex[jdx]))) * myWinMoney + matchMaxWin;

        money_t currPayMoney = totalWinMoney  - (saleMoney(line->subtype,issue) + ticketAmount) * winReturnRate(issue) / WIN_RETURN_RATEBASE;

        if(currPayMoney > maxPay(issue,line->subtype))
        {
            rptSubtype = line->subtype;
            memset(rptNumber,0,sizeof(rptNumber));
            sprintf(rptNumber,"%d",dindex[jdx]);

            log_info("rk_verifyCommFun no pass line->subtype[%d] verify  \
                      line->betCount[%d] line->betTimes[%d] num[%d] currentBetCount[%d]  \
                      myWinMoney[%lld] matchMaxWin[%lld] totalWinMoney[%lld]  saleMoney[%lld] currPayMoney[%lld] maxPay[%lld] ",\
                      line->subtype,line->betCount,line->betTimes,dindex[jdx],*numCurrentBetCount(line->subtype,issue,dindex[jdx]),
                      myWinMoney, matchMaxWin,totalWinMoney,saleMoney(line->subtype,issue), currPayMoney, maxPay(issue,line->subtype) );

            for(int ndx = 0; ndx < jdx; ndx++)
            {
                *(numCurrentBetCount(line->subtype,issue,dindex[ndx])) -= line->betTimes;
            }
            return false;
        }
        else
        {
            *(numCurrentBetCount(line->subtype,issue,dindex[jdx])) += line->betTimes;
        }
    }
    return true;
}


void rk_updateReportData(BETLINE *line,int issue)
{
    money_t lineMoney = line->betCount * line->betTimes * line->singleAmount;

    uint16 dindex[MAX_BETS_COUNT] = {0};
    int betNumIndexCount = rk_getBetNumberIndex(line,dindex);

    for(int jdx=0;jdx < betNumIndexCount;jdx++)
    {
        bool  specNumFlag = isSpecNum(line->subtype,dindex[jdx]);
        money_t myWinMoney = (isSpecNum(line->subtype,dindex[jdx]))?specBetWin(issue,line->subtype):winMoney(issue,line->subtype);

        money_t matchMaxWin = getMatchMaxWinCommit(line->subtype,dindex[jdx],issue,specNumFlag,line->betTimes);

        money_t totalWinMoney = (line->betTimes + *(numCurrentBetCountCommit(line->subtype,issue,dindex[jdx]))) * myWinMoney + matchMaxWin;

        money_t currPayMoney = totalWinMoney  - (saleMoneyCommit(line->subtype,issue) + lineMoney) * winReturnRate(issue) / WIN_RETURN_RATEBASE;

        if(totalWinMoney > maxWinMoney(line->subtype,issue) )
        {
            maxWinMoney(line->subtype,issue) = totalWinMoney;
            currPayMoney(line->subtype,issue) = currPayMoney;
        }
    }
    return;
}


void rk_saleMoneyAdder(int issue, bool commitFlag, uint8 subtype, money_t tamount)
{
    if (commitFlag)
    {
        saleMoneyCommit(subtype,issue) += tamount;
    }
    else
    {
        saleMoney(subtype,issue) += tamount;
    }
}

void rk_saleMoneyRelease(int issue, bool commitFlag, uint8 subtype, money_t tamount)
{
    if (commitFlag)
    {
        saleMoneyCommit(subtype, issue) -= tamount;
    }
    else
    {
        saleMoney(subtype, issue) -= tamount;
    }
}



void rk_2StarDirectAdder(BETLINE *line,int issue,bool commitFlag)
{
    uint16 dindex[1000] = {0};
    uint16  indexCount = rk_get2StarDirectNumberIndex(line, dindex);
    for(int i=0;i<indexCount;i++)
    {
        if(commitFlag)
        {
            TwoStarBet(issue,dindex[i]).betCountCommit +=  line->betTimes;
        }
        else
        {
            TwoStarBet(issue,dindex[i]).betCount +=  line->betTimes;
        }
    }
}
void rk_2StarDirectRollback(BETLINE *line,int issue,bool commitFlag)
{
    uint16 dindex[1000] = {0};
    uint16  indexCount = rk_get2StarDirectNumberIndex(line, dindex);
    for(int i=0;i<indexCount;i++)
    {
        if(commitFlag)
        {
            TwoStarBet(issue,dindex[i]).betCountCommit -=  line->betTimes;
        }
        else
        {
            TwoStarBet(issue,dindex[i]).betCount -=  line->betTimes;
        }
    }
}


void rk_3StarDirectAdder(BETLINE *line,int issue,bool commitFlag)
{
    uint16 dindex[1000] = {0};
    uint16  indexCount = rk_get3StarDirectNumberIndex(line, dindex);
    for(int i=0;i<indexCount;i++)
    {
        if(commitFlag)
        {
            ThreeStarBet(issue,dindex[i]).betCountCommit +=  line->betTimes;
        }
        else
        {
            ThreeStarBet(issue,dindex[i]).betCount +=  line->betTimes;
        }
    }
}

void rk_3StarDirectRollback(BETLINE *line,int issue,bool commitFlag)
{
    uint16 dindex[1000] = {0};
    uint16  indexCount = rk_get3StarDirectNumberIndex(line, dindex);
    for(int i=0;i<indexCount;i++)
    {
        if(commitFlag)
        {
            ThreeStarBet(issue,dindex[i]).betCountCommit -=  line->betTimes;
        }
        else
        {
            ThreeStarBet(issue,dindex[i]).betCount -=  line->betTimes;
        }
    }
}


void rk_4StarDirectAdder(BETLINE *line,int issue,bool commitFlag)
{
    uint16 dindex[MAX_BETS_COUNT] = {0};
    uint16  indexCount = rk_get4StarDirectSegIndex(line, dindex);
    for(int i=0;i<indexCount;i++)
    {
        if(commitFlag)
        {
            FourStarBet(issue,dindex[i]).betCountCommit +=  line->betTimes;
        }
        else
        {
            FourStarBet(issue,dindex[i]).betCount +=  line->betTimes;
        }
    }
}


void rk_4StarDirectRollback(BETLINE *line,int issue,bool commitFlag)
{
    uint16 dindex[MAX_BETS_COUNT] = {0};
    uint16  indexCount = rk_get4StarDirectSegIndex(line, dindex);
    for(int i=0;i<indexCount;i++)
    {
        if(commitFlag)
        {
            FourStarBet(issue,dindex[i]).betCountCommit -=  line->betTimes;
        }
        else
        {
            FourStarBet(issue,dindex[i]).betCount -=  line->betTimes;
        }
    }
}

void rk_First2StarAdder(BETLINE *line,int issue,bool commitFlag)
{
    uint16 dindex[1000] = {0};
    uint16  indexCount = rk_get2StarDirectNumberIndex(line, dindex);
    for(int i=0;i<indexCount;i++)
    {
        if(commitFlag)
        {
            FirstTwoBet(issue,dindex[i]).betCountCommit +=  line->betTimes;
        }
        else
        {
            FirstTwoBet(issue,dindex[i]).betCount +=  line->betTimes;
        }
    }
}

void rk_First2StarRollback(BETLINE *line,int issue,bool commitFlag)
{
    uint16 dindex[1000] = {0};
    uint16  indexCount = rk_get2StarDirectNumberIndex(line, dindex);
    for(int i=0;i<indexCount;i++)
    {
        if(commitFlag)
        {
        	FirstTwoBet(issue,dindex[i]).betCountCommit -=  line->betTimes;
        }
        else
        {
        	FirstTwoBet(issue,dindex[i]).betCount -=  line->betTimes;
        }
    }
}

void rk_Last2StarAdder(BETLINE *line,int issue,bool commitFlag)
{
    uint16 dindex[1000] = {0};
    uint16  indexCount = rk_get2StarDirectNumberIndex(line, dindex);
    for(int i=0;i<indexCount;i++)
    {
        if(commitFlag)
        {
            LastTwoBet(issue,dindex[i]).betCountCommit +=  line->betTimes;
        }
        else
        {
            LastTwoBet(issue,dindex[i]).betCount +=  line->betTimes;
        }
    }
}

void rk_Last2StarRollback(BETLINE *line,int issue,bool commitFlag)
{
    uint16 dindex[1000] = {0};
    uint16  indexCount = rk_get2StarDirectNumberIndex(line, dindex);
    for(int i=0;i<indexCount;i++)
    {
        if(commitFlag)
        {
        	LastTwoBet(issue,dindex[i]).betCountCommit -=  line->betTimes;
        }
        else
        {
        	LastTwoBet(issue,dindex[i]).betCount -=  line->betTimes;
        }
    }
}


void rk_First3StarAdder(BETLINE *line,int issue,bool commitFlag)
{
    uint16 dindex[1000] = {0};
    uint16  indexCount = rk_get3StarDirectNumberIndex(line, dindex);
    for(int i=0;i<indexCount;i++)
    {
        if(commitFlag)
        {
            FirstThreeBet(issue,dindex[i]).betCountCommit +=  line->betTimes;
        }
        else
        {
            FirstThreeBet(issue,dindex[i]).betCount +=  line->betTimes;
        }
    }
}

void rk_First3StarRollback(BETLINE *line,int issue,bool commitFlag)
{
    uint16 dindex[1000] = {0};
    uint16  indexCount = rk_get3StarDirectNumberIndex(line, dindex);
    for(int i=0;i<indexCount;i++)
    {
        if(commitFlag)
        {
            FirstThreeBet(issue,dindex[i]).betCountCommit -=  line->betTimes;
        }
        else
        {
            FirstThreeBet(issue,dindex[i]).betCount -=  line->betTimes;
        }
    }
}

void rk_Last3StarAdder(BETLINE *line,int issue,bool commitFlag)
{
    uint16 dindex[1000] = {0};
    uint16  indexCount = rk_get3StarDirectNumberIndex(line, dindex);
    for(int i=0;i<indexCount;i++)
    {
        if(commitFlag)
        {
            LastThreeBet(issue,dindex[i]).betCountCommit +=  line->betTimes;
        }
        else
        {
            LastThreeBet(issue,dindex[i]).betCount +=  line->betTimes;
        }
    }
}

void rk_Last3StarRollback(BETLINE *line,int issue,bool commitFlag)
{
    uint16 dindex[1000] = {0};
    uint16  indexCount = rk_get3StarDirectNumberIndex(line, dindex);
    for(int i=0;i<indexCount;i++)
    {
        if(commitFlag)
        {
            LastThreeBet(issue,dindex[i]).betCountCommit -=  line->betTimes;
        }
        else
        {
            LastThreeBet(issue,dindex[i]).betCount -=  line->betTimes;
        }
    }
}


/////////////////////////////////////////////////////////////////////////////////
void rk_initVerifyFun(void)
{
    rk_verifyFunAdder[SUBTYPE_QH2] = rk_2StarDirectAdder;
    rk_verifyFunAdder[SUBTYPE_QH3] = rk_3StarDirectAdder;
    rk_verifyFunAdder[SUBTYPE_4ZX] = rk_4StarDirectAdder;

    rk_verifyFunRollback[SUBTYPE_QH2] = rk_2StarDirectRollback;
    rk_verifyFunRollback[SUBTYPE_QH3] = rk_3StarDirectRollback;
    rk_verifyFunRollback[SUBTYPE_4ZX] = rk_4StarDirectRollback;


    rk_verifyFunAdder[SUBTYPE_Q2] = rk_First2StarAdder;
    rk_verifyFunAdder[SUBTYPE_H2] = rk_Last2StarAdder;
    rk_verifyFunAdder[SUBTYPE_Q3] = rk_First3StarAdder;
    rk_verifyFunAdder[SUBTYPE_H3] = rk_Last3StarAdder;

    rk_verifyFunRollback[SUBTYPE_Q2] = rk_First2StarRollback;
    rk_verifyFunRollback[SUBTYPE_H2] = rk_Last2StarRollback;
    rk_verifyFunRollback[SUBTYPE_Q3] = rk_First3StarRollback;
    rk_verifyFunRollback[SUBTYPE_H3] = rk_Last3StarRollback;

}


//  风险控制验证接口
bool riskVerify(    TICKET* pTicket,bool commitFlag)
{
    int issueIndex = -1;
    int startIssueIdx = rk_get_koctty_issueIndexBySeq(pTicket->issueSeq);

    if(!commitFlag)
    {
        for(int acount = 0; acount < pTicket->issueCount; acount++)
        {
            issueIndex = rk_get_koctty_issueIndexBySeq( pTicket->issueSeq + acount);
            if(issueIndex < 0)
            {
                log_info("riskVerify issue_seq[%d] acount[%d] not find!",pTicket->issueSeq , acount);
                continue;
            }
            BETLINE *line =  (BETLINE *)GL_BETLINE(pTicket);
            for(int aline = 0;aline < pTicket->betlineCount; aline++)
            {

                if(rk_getNumRestrictFlag( line))
                {
                    log_info("riskVerify rk_getNumRestrictFlag! ");
                    return false;
                }
                if(!rk_verifyCommFun(line,issueIndex, pTicket->amount))
                {
                    issueStatRefuseMoney(startIssueIdx) += pTicket->amount;
                    issueStatRefuseCount(startIssueIdx)++;
                    log_info("koctty rk no pass startIssueIdx[%d] issue[%lld] subtype[%d] amount[%lld]", startIssueIdx,pTicket->issue, line->subtype, pTicket->amount);
                    for(int rcount = 0; rcount < acount+1; rcount++)
                    {
                        issueIndex = rk_get_koctty_issueIndexBySeq( pTicket->issueSeq + rcount);
                        line = (BETLINE *)GL_BETLINE(pTicket);
                        int backline = (rcount == acount)? aline : pTicket->betlineCount;
                        for(int rline = 0;rline < backline; rline++)
                        {
                            rk_verifyFunRollback[line->subtype](line,issueIndex, commitFlag);
                            line = (BETLINE *) GL_BETLINE_NEXT(line);
                        }
                    }
                    send_rkNotify(pTicket->gameCode, pTicket->issue,rptSubtype, rptNumber);
                    return false;
                }
                line = (BETLINE *) GL_BETLINE_NEXT(line);
            }
            line = (BETLINE *)GL_BETLINE(pTicket);
            rk_saleMoneyAdder(issueIndex, commitFlag, line->subtype, pTicket->amount);
        }
    }
    else
    {
        for(int acount = 0; acount < pTicket->issueCount; acount++)
        {
            issueIndex = rk_get_koctty_issueIndexBySeq( pTicket->issueSeq + acount);
            if(issueIndex >= 0 )
            {
                BETLINE *line =  (BETLINE *)GL_BETLINE(pTicket);
                rk_saleMoneyAdder(issueIndex, commitFlag, line->subtype, pTicket->amount);
                for(int aline = 0;aline < pTicket->betlineCount; aline++)
                {
                    rk_updateReportData(line,issueIndex);
                    rk_verifyFunAdder[line->subtype](line,issueIndex, commitFlag);
                    line = (BETLINE *) GL_BETLINE_NEXT(line);
                }
            }
        }
    }


    log_info("koctty rk pass issue[%lld] commit[%d]",pTicket->issue,commitFlag?1:0);
    return true;
}


// 退票风险控制参数回滚接口
void riskRollback(TICKET* pTicket,bool commitFlag)
{
    int issueIndex = -1;

    for(int acount = 0; acount < pTicket->issueCount; acount++)
    {
        issueIndex = rk_get_koctty_issueIndexBySeq( pTicket->issueSeq + acount);
        if(issueIndex >= 0 )
        {
            BETLINE *line = (BETLINE *)GL_BETLINE(pTicket);
            rk_saleMoneyRelease(issueIndex, commitFlag, line->subtype, pTicket->amount);
            for(int i=0;i<pTicket->betlineCount;i++)
            {
                rk_verifyFunRollback[line->subtype](line,issueIndex, commitFlag);
                line = (BETLINE *) GL_BETLINE_NEXT(line);
            }
        }
    }
}

bool gl_koctty_rk_mem_get_meta( int *length)
{
    ts_notused(length);
    return true;
}

bool gl_koctty_rk_mem_save( void *buf, int *length)
{
    ts_notused(buf);
    ts_notused(length);
    return true;
}

bool gl_koctty_rk_mem_recovery( void *buf, int length)
{
    ts_notused(buf);
    ts_notused(length);
    return true;
}

void gl_koctty_rk_reinitData(void)
{
    int num;
    for(int issue=0;issue < totalIssueCount;issue++)
    {
        for(num = 0;num < 100; num++)
        {
            TwoStarBet(issue,num).betCount = TwoStarBet(issue,num).betCountCommit;
            FirstTwoBet(issue,num).betCount = FirstTwoBet(issue,num).betCountCommit;
            LastTwoBet(issue,num).betCount = LastTwoBet(issue,num).betCountCommit;
        }
        for(num = 0;num < 1000; num++)
        {
            ThreeStarBet(issue,num).betCount = ThreeStarBet(issue,num).betCountCommit;
            FirstThreeBet(issue,num).betCount = FirstThreeBet(issue,num).betCountCommit;
            LastThreeBet(issue,num).betCount = LastThreeBet(issue,num).betCountCommit;
        }
        for(num = 0;num < 10000; num++)
        {
            FourStarBet(issue,num).betCount = FourStarBet(issue,num).betCountCommit;
        }

        for(uint8 subtype = SUBTYPE_QH2; subtype <= SUBTYPE_H3; subtype++)
        {
            saleMoney(subtype,issue) = saleMoneyCommit(subtype,issue);
        }
    }

    return;
}

bool gl_koctty_sale_rk_verify(TICKET* pTicket)
{
    if( riskVerify(pTicket, false))
    {
        return true;
    }
    return false;
}


void gl_koctty_sale_rk_commit(TICKET* pTicket)
{
     riskVerify(pTicket, true);
}


void gl_koctty_cancel_rk_rollback(TICKET* pTicket)
{
    riskRollback(pTicket, false);
}

void gl_koctty_cancel_rk_commit(TICKET* pTicket)
{
    riskRollback(pTicket, true);
}


////////////////////////////////////////////////////////////////



void getKOCTTYwinMoney(uint64 issueNumber,int flag,int issue)
{
    PRIZE_PARAM *prizeParam = gl_koctty_getPrizeTable(issueNumber);

    for(int i = 0; i < MAX_PRIZE_COUNT; i++)
    {
        switch(prizeParam[i].prizeCode)
        {
        case 1:
            winMoney(issue,SUBTYPE_4ZX) = prizeParam[i].fixedPrizeAmount;
            break;
        case 2:
            winMoney(issue,SUBTYPE_QH3) = prizeParam[i].fixedPrizeAmount;
            break;
        case 3:
            winMoney(issue,SUBTYPE_QH2) = prizeParam[i].fixedPrizeAmount;
            break;
        case 7:
        	winMoney(issue,SUBTYPE_Q3) = prizeParam[i].fixedPrizeAmount;
        	break;
        case 8:
        	winMoney(issue,SUBTYPE_H3) = prizeParam[i].fixedPrizeAmount;
        	break;
        case 9:
        	winMoney(issue,SUBTYPE_Q2) = prizeParam[i].fixedPrizeAmount;
        	break;
        case 10:
        	winMoney(issue,SUBTYPE_H2) = prizeParam[i].fixedPrizeAmount;
        	break;

        }
    }

    for(int i = 0; i < MAX_PRIZE_COUNT; i++)
    {
        switch(prizeParam[i].prizeCode)
        {
        case 4:
            specBetWin(issue,SUBTYPE_4ZX) = ( flag == 1) ? prizeParam[i].fixedPrizeAmount : winMoney(issue,SUBTYPE_4ZX);
            break;
        case 5:
            specBetWin(issue,SUBTYPE_QH3) = ( flag == 1) ? prizeParam[i].fixedPrizeAmount : winMoney(issue,SUBTYPE_QH3);
            break;
        case 6:
            specBetWin(issue,SUBTYPE_QH2) = ( flag == 1) ? prizeParam[i].fixedPrizeAmount : winMoney(issue,SUBTYPE_QH2);
            break;

        case 11:
        	specBetWin(issue,SUBTYPE_Q3) = ( flag == 1) ? prizeParam[i].fixedPrizeAmount : winMoney(issue,SUBTYPE_Q3);
        	break;
        case 12:
        	specBetWin(issue,SUBTYPE_H3) = ( flag == 1) ? prizeParam[i].fixedPrizeAmount : winMoney(issue,SUBTYPE_H3);
        	break;
        case 13:
        	specBetWin(issue,SUBTYPE_Q2) = ( flag == 1) ? prizeParam[i].fixedPrizeAmount : winMoney(issue,SUBTYPE_Q2);
        	break;
        case 14:
        	specBetWin(issue,SUBTYPE_H2) = ( flag == 1) ? prizeParam[i].fixedPrizeAmount : winMoney(issue,SUBTYPE_H2);
        	break;
        }
    }

    return;
}


void rk_clear_issue_betsData(int issue)
{
    int num;

    for(num = 0;num < 100; num++)
    {
        TwoStarBet(issue,num).betCount = 0;
        TwoStarBet(issue,num).betCountCommit = 0;

        FirstTwoBet(issue,num).betCount = 0;
        FirstTwoBet(issue,num).betCountCommit = 0;
        LastTwoBet(issue,num).betCount = 0;
        LastTwoBet(issue,num).betCountCommit = 0;

    }
    for(num = 0;num < 1000; num++)
    {
        ThreeStarBet(issue,num).betCount = 0;
        ThreeStarBet(issue,num).betCountCommit = 0;

        FirstThreeBet(issue,num).betCount = 0;
        FirstThreeBet(issue,num).betCountCommit = 0;
        LastThreeBet(issue,num).betCount = 0;
        LastThreeBet(issue,num).betCountCommit = 0;

    }
    for(num = 0;num < 10000; num++)
    {
        FourStarBet(issue,num).betCount = 0;
        FourStarBet(issue,num).betCountCommit = 0;

    }

    for(uint8 subtype = SUBTYPE_QH2; subtype <= SUBTYPE_H3; subtype++)
    {
        saleMoney(subtype,issue) = saleMoneyCommit(subtype,issue) = 0;
        currPayMoney(subtype,issue) = 0;
        maxWinMoney(subtype,issue) = 0;
    }

}
/*
#define issueBeUsed(issue)                        d3_issue_info[issue].used
#define issueState(issue)                         d3_issue_info[issue].curState
*/
// load issue param when add issue by gl_drive , no need init ,need empty bets data
bool load_koctty_issue_rkdata(uint32 startIssueSeq,int issue_count, char *rkStr)
{
    int s[7] = {0};
    money_t f[7] = {0};
    money_t p[7] = {0};
    const char *format="%d:%lld:%lld#%d:%lld:%lld#%d:%lld:%lld#%d:%lld:%lld#%d:%lld:%lld#%d:%lld:%lld#%d:%lld:%lld#";

    sscanf(rkStr,format,&s[0],&f[0],&p[0],&s[1],&f[1],&p[1],&s[2],&f[2],&p[2],&s[3],&f[3],&p[3],&s[4],&f[4],&p[4],&s[5],&f[5],&p[5],&s[6],&f[6],&p[6]);

    POLICY_PARAM* policyParam = gl_getPolicyParam(GAME_KOCTTY);

    uint32 issueSeq = startIssueSeq;
    for(int issue_idx = 0; issue_idx < issue_count; issue_idx++)
    {
        int issue = rk_get_koctty_issueIndexBySeq(issueSeq);
        if (issue > -1)
        {
            if( issueBeUsed(issue) )
            {
                //void *nousebuf;

                KOCTTY_CALC_PRIZE_PARAM calcParam = {0};

                ISSUE_INFO *issueInfo = gl_koctty_get_issueInfoByIndex(issue);
                if(strlen(issueInfo->winConfigStr) != 0)
                {
                    gl_koctty_resolve_winStr(issueInfo->issueNumber,(void *)&calcParam);
                }

                winReturnRate(issue) = policyParam->returnRate;
                getKOCTTYwinMoney( issueInfo->issueNumber,calcParam.specWinFlag,issue);

                for(uint8 subtype = SUBTYPE_QH2; subtype <= SUBTYPE_H3; subtype++)
                {
                    for(int sdx = 0; sdx < 7; sdx++)
                    {
                        if(subtype == s[sdx])
                        {
                            riskValue(issue,subtype) = f[sdx];
                            maxPay(issue,subtype) = p[sdx];
                        }
                    }
                }
                rk_clear_issue_betsData( issue);
            }
            issueSeq++;
        }
    }
    return true;
}

void gl_koctty_rk_issueData2File(const char *filePath,void *buf)
{
    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName,"%s/koctty_rk.snapshot", filePath);
    if((fp = open(fileName,O_CREAT|O_WRONLY,S_IRUSR )) < 0 )
    {
        log_error("open %s error!",fileName);
        return;
    }

    ssize_t ret = write( fp, buf, sizeof(GL_KOCTTY_RK_CHKP_ISSUE_DATA));
    if(ret < 0)
    {
        log_error("write %s error errno[%d]",fileName,errno);
    }
    close(fp);

}

bool gl_koctty_rk_issueFile2Data(const char *filePath,void *buf)
{
    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName,"%s/koctty_rk.snapshot", filePath);
    if((fp = open(fileName,O_RDONLY )) < 0 )
    {
        log_error("open %s error!",fileName);
        return false;
    }

    ssize_t ret = read( fp, buf, sizeof(GL_KOCTTY_RK_CHKP_ISSUE_DATA));
    if(ret < 0)
    {
        log_error("read %s error errno[%d]",fileName,errno);
        return false;
    }
    close(fp);
    return true;
}

bool gl_koctty_rk_saveData(const char *filePath)
{
    int num;
    int count = 0;
    GL_KOCTTY_RK_CHKP_ISSUE_DATA rkIssueData;
    memset((void *)&rkIssueData, 0 ,sizeof(rkIssueData));
    ISSUE_INFO *issueInfo = gl_koctty_getIssueTable();
    for(int i = 0; i < totalIssueCount; i++)
    {
        if(issueInfo[i].used)
        {
            if((issueInfo[i].curState >= ISSUE_STATE_PRESALE) && (issueInfo[i].curState < ISSUE_STATE_CLOSED))
            {
                int issue = rk_get_koctty_issueIndexBySeq(issueInfo[i].serialNumber);


                rkIssueData.rkData[count].issueSeq = issueInfo[i].serialNumber;

                for(num = 0;num < 100; num++)
                {
                    rkIssueData.rkData[count].twoStarbetCountCommit[num] = TwoStarBet(issue,num).betCountCommit;
                    rkIssueData.rkData[count].firstTwoBetCountCommit[num] = FirstTwoBet(issue,num).betCountCommit;
                    rkIssueData.rkData[count].lastTwoBetCountCommit[num] = LastTwoBet(issue,num).betCountCommit;
                }
                for(num = 0;num < 1000; num++)
                {
                    rkIssueData.rkData[count].threeStarbetCountCommit[num] = ThreeStarBet(issue,num).betCountCommit;
                    rkIssueData.rkData[count].firstThreeBetCountCommit[num] = FirstThreeBet(issue,num).betCountCommit;
                    rkIssueData.rkData[count].lastThreeBetCountCommit[num] = LastThreeBet(issue,num).betCountCommit;

                }
                for(num = 0;num < 10000; num++)
                {
                    rkIssueData.rkData[count].fourStarbetCountCommit[num] = FourStarBet(issue,num).betCountCommit;
                }

                for(uint8 subtype = SUBTYPE_QH2; subtype <= SUBTYPE_H3; subtype++)
                {
                    rkIssueData.rkData[count].saleMoneyCommit[subtype] = saleMoneyCommit(subtype,issue);
                }
                count++;
            }
        }
    }
    gl_koctty_rk_issueData2File(filePath,(void *)&rkIssueData);
    return true;
}

bool gl_koctty_rk_restoreData(const char *filePath)
{
    int num;

    GL_KOCTTY_RK_CHKP_ISSUE_DATA rkIssueData;
    memset((void *)&rkIssueData, 0 ,sizeof(rkIssueData));
    if(gl_koctty_rk_issueFile2Data(filePath,(void *)&rkIssueData))
    {
        for(int count = 0; count < MAX_ISSUE_NUMBER; count++)
        {
            if(rkIssueData.rkData[count].issueSeq > 0)
            {
                int issue = rk_get_koctty_issueIndexBySeq(rkIssueData.rkData[count].issueSeq);

                if(issue >= 0)
                {

                    for(num = 0;num < 100; num++)
                    {
                        TwoStarBet(issue,num).betCountCommit = rkIssueData.rkData[count].twoStarbetCountCommit[num];
                        FirstTwoBet(issue,num).betCountCommit = rkIssueData.rkData[count].firstTwoBetCountCommit[num];
                        LastTwoBet(issue,num).betCountCommit = rkIssueData.rkData[count].lastTwoBetCountCommit[num];
                    }
                    for(num = 0;num < 1000; num++)
                    {
                        ThreeStarBet(issue,num).betCountCommit = rkIssueData.rkData[count].threeStarbetCountCommit[num];
                        FirstThreeBet(issue,num).betCountCommit = rkIssueData.rkData[count].firstThreeBetCountCommit[num];
                        LastThreeBet(issue,num).betCountCommit = rkIssueData.rkData[count].lastThreeBetCountCommit[num];
                    }
                    for(num = 0;num < 10000; num++)
                    {
                        FourStarBet(issue,num).betCountCommit = rkIssueData.rkData[count].fourStarbetCountCommit[num];
                    }

                    for(uint8 subtype = SUBTYPE_QH2; subtype <= SUBTYPE_H3; subtype++)
                    {
                        saleMoneyCommit(subtype,issue) = rkIssueData.rkData[count].saleMoneyCommit[subtype];
                    }
                }
            }
        }
        return true;
    }
    else
        return false;

    return true;
}



bool gl_koctty_rk_getReportData(uint32 issueSeq,void *data)
{
    int issue = rk_get_koctty_issueIndexBySeq( issueSeq);
    if(issue < 0)
    {
        log_info("gl_koctty_rk_getReportData issue_seq[%d]  not find!",issueSeq);
        return false;
    }
/*
    KOCTTY_REPORT_DATA *rpt = (KOCTTY_REPORT_DATA *)data;
    rpt->currPayQH2 = currPayMoney(SUBTYPE_QH2,issue);
    rpt->currPayQH3 = currPayMoney(SUBTYPE_QH3,issue);
    rpt->currPay4ZX = currPayMoney(SUBTYPE_4ZX,issue);
*/

    sprintf((char *)data,"1:%lld,%lld#2:%lld,%lld#3:%lld,%lld#4:%lld,%lld#5:%lld,%lld#6:%lld,%lld#7:%lld,%lld",
            currPayMoney(SUBTYPE_QH2,issue),maxPay(issue,SUBTYPE_QH2),
            currPayMoney(SUBTYPE_QH3,issue),maxPay(issue,SUBTYPE_QH3),
            currPayMoney(SUBTYPE_4ZX,issue),maxPay(issue,SUBTYPE_4ZX),
            currPayMoney(SUBTYPE_Q2,issue),maxPay(issue,SUBTYPE_Q2),
            currPayMoney(SUBTYPE_H2,issue),maxPay(issue,SUBTYPE_H2),
            currPayMoney(SUBTYPE_Q3,issue),maxPay(issue,SUBTYPE_Q3),
            currPayMoney(SUBTYPE_H3,issue),maxPay(issue,SUBTYPE_H3));
    return true;

}



void setIndexForBCArray(const uint8 n, uint16 mybitmap)
{
    uint8 andret[64];
	uint16 idx = 0;
	switch(n)
	{
		case 2:
		{
            for(idx = 0; idx < 100; idx++)
            {
                memset(andret, 0, sizeof(andret));
				// mybitmap maybe has more than 4 bits,so can't compare with betCompact directly
                bitAnd((uint8 *)&(TwoStarBet(0,idx).betCompact), 0,(uint8 *)& mybitmap, 0, 2, andret);
                if( bitCount(andret, 0, 64) == 2)
                {
                	twoStarBCidx(mybitmap).numArray[twoStarBCidx(mybitmap).numCount] = idx;
                	twoStarBCidx(mybitmap).numCount++;
                }
            }
			break;
		}
		case 3:
		{
			for(idx = 0; idx < 1000; idx++)
            {
                memset(andret, 0, sizeof(andret));
                bitAnd((uint8 *)&(ThreeStarBet(0,idx).betCompact), 0,(uint8 *)& mybitmap, 0, 2, andret);
                if( bitCount(andret, 0, 64) == 3)
                {
                	threeStarBCidx(mybitmap).numArray[threeStarBCidx(mybitmap).numCount] = idx;
                	threeStarBCidx(mybitmap).numCount++;
                }
            }
			break;
		}
		case 4:
		{
		    for(idx = 0; idx < 10000; idx++)
            {
                memset(andret, 0, sizeof(andret));
                bitAnd((uint8 *)&(FourStarBet(0,idx).betCompact), 0,(uint8 *)& mybitmap, 0, 2, andret);
                if( bitCount(andret, 0, 64) == 4)
                {
                	fourStarBCidx(mybitmap).numArray[fourStarBCidx(mybitmap).numCount] = idx;
                	fourStarBCidx(mybitmap).numCount++;
                }
            }
			break;
		}
	}
	return;
}



bool gl_tty_rk_init(void)
{
	int num = 0;
	uint16 sortn = 0;
    uint16 bitmap = 0;
	uint8 array[4] = { 0 };


    if (rk_koctty_issueData != NULL)
    {
        for (uint8 a = 0; a < 10; a++)
            for (uint8 b = 0; b < 10; b++)
                for (uint8 c = 0; c < 10; c++)
                    for (uint8 d = 0; d < 10; d++)
                    {
                        array[0] = a;
                        array[1] = b;
                        array[2] = c;
                        array[3] = d;
                        num = a * 1000 + b * 100 + c * 10 + d;

                        bitmap = 0;
                        num2bit(array, 4, (uint8 *)&bitmap, 0, 0);
                        for (int issue = 0;issue < totalIssueCount;issue++)
                        {
                            FourStarBet(issue, num).betCompact = bitmap;
                        }
                    }

        for (uint8 a = 0; a < 10; a++)
            for (uint8 b = 0; b < 10; b++)
                for (uint8 c = 0; c < 10; c++)
                {
                    array[0] = a;
                    array[1] = b;
                    array[2] = c;
                    num = a * 100 + b * 10 + c;

                    bitmap = 0;
                    num2bit(array, 3, (uint8 *)&bitmap, 0, 0);
                    for (int issue = 0;issue < totalIssueCount;issue++)
                    {
                        ThreeStarBet(issue, num).betCompact = bitmap;
                        FirstThreeBet(issue, num).betCompact = bitmap;
                        LastThreeBet(issue, num).betCompact = bitmap;
                    }
                }

        for (uint8 a = 0; a < 10; a++)
            for (uint8 b = 0; b < 10; b++)
            {
                array[0] = a;
                array[1] = b;
                num = a * 10 + b;

                bitmap = 0;
                num2bit(array, 2, (uint8 *)&bitmap, 0, 0);
                for (int issue = 0;issue < totalIssueCount;issue++)
                {
                    TwoStarBet(issue, num).betCompact = bitmap;
                    FirstTwoBet(issue, num).betCompact = bitmap;
                    LastTwoBet(issue, num).betCompact = bitmap;
                }
            }
    }

   // init 'BC' bettype index table
   //for ( mybitmap from '0000 0000 0000 0011' to '0000 0011 1111 1100')
    for(uint16 mybitmap = 3; mybitmap <= 1020; mybitmap++)
    {
	    int ret = bitCount((uint8 *)&mybitmap, 0, 2);
	    if((ret < 2) || (ret > 8))
	    {
		    continue;
	    }
		setIndexForBCArray(2, mybitmap);

		if(ret >= 3)
		{
		    setIndexForBCArray(3, mybitmap);
		}

		if(ret >= 4)
		{
		    setIndexForBCArray(4, mybitmap);
		}
   }

    bzero((void *)fourStarMp, sizeof(fourStarMp));
    uint8 str[] = { 0,1,2,3};
    int start = 0;
    permutation(str, 0, 3, fourStarMp, &start);
    return true;
}







