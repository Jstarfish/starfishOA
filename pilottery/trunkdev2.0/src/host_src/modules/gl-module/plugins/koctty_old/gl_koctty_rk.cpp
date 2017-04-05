#include "global.h"
#include "gl_inf.h"
#include "gl_koctty_rk.h"
#include "gl_koctty_db.h"


GAME_RISK_KOCTTY_ISSUE_DATA *rk_koctty_issueData = NULL;


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


#define TwoStarBet(issue,number)                    rk_koctty_issueData[issue].betData.koctty2star[number]
#define ThreeStarBet(issue,number)                  rk_koctty_issueData[issue].betData.koctty3star[number]
#define FourStarBet(issue,number)                   rk_koctty_issueData[issue].betData.koctty4star[number]

#define saleMoney(subtype,issue)                    rk_koctty_issueData[issue].saleMoney[subtype]
#define saleMoneyCommit(subtype,issue)              rk_koctty_issueData[issue].saleMoneyCommit[subtype]


#define maxWinMoney(subtype,issue)                  rk_koctty_issueData[issue].currMaxWin[subtype]
#define currPayMoney(subtype,issue)                 rk_koctty_issueData[issue].currPay[subtype]



void (*rk_verifyFunAdder[MAX_FUN_KEY])(BETLINE *line,int issue,bool commitFlag);
void (*rk_verifyFunRollback[MAX_FUN_KEY])(BETLINE *line,int issue,bool commitFlag);


static uint8 rptSubtype;
static char rptNumber[32]; //Notify betNumber String








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
        default:
            log_error("rk_get2StarDirectNumberIndex() bettype[%d] error", GL_BETTYPE_A(line));
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
    }
    return bet;
}




uint16 rk_getBetNumberIndex(BETLINE *line,uint16 dindex[])
{
    switch(line->subtype)
    {
        case SUBTYPE_QH2:
            return rk_get2StarDirectNumberIndex(line, dindex);
        case SUBTYPE_QH3:
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
            return ((num/10) == (num%10));

        case SUBTYPE_QH3:
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
    case SUBTYPE_4ZX:
        return 0;

    }

    return 0;
}

bool rk_verifyCommFun(BETLINE *line,int issue)
{
    money_t lineMoney = line->betCount * line->betTimes * line->singleAmount;
    if(saleMoney(line->subtype,issue) + lineMoney  <= riskValue(issue,line->subtype))
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

        money_t currPayMoney = totalWinMoney  - (saleMoney(line->subtype,issue) + lineMoney) * winReturnRate(issue) / WIN_RETURN_RATEBASE;

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


void rk_saleDataAdder(BETLINE *line,int issue,bool commitFlag)
{
    if(commitFlag)
    {
        saleMoneyCommit(line->subtype,issue) += line->betCount * line->betTimes * line->singleAmount;
    }
    else
    {
        saleMoney(line->subtype,issue) += line->betCount * line->betTimes * line->singleAmount;
    }
}

void rk_saleDataRelease(BETLINE *line,int issue)
{
    saleMoney(line->subtype,issue) -= line->betCount * line->betTimes * line->singleAmount;
}


void rk_saleDataReleaseCommit(BETLINE *line,int issue)
{
    saleMoneyCommit(line->subtype,issue) -= line->betCount * line->betTimes * line->singleAmount;
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




/////////////////////////////////////////////////////////////////////////////////
void rk_initVerifyFun(void)
{
    rk_verifyFunAdder[SUBTYPE_QH2] = rk_2StarDirectAdder;
    rk_verifyFunAdder[SUBTYPE_QH3] = rk_3StarDirectAdder;
    rk_verifyFunAdder[SUBTYPE_4ZX] = rk_4StarDirectAdder;

    rk_verifyFunRollback[SUBTYPE_QH2] = rk_2StarDirectRollback;
    rk_verifyFunRollback[SUBTYPE_QH3] = rk_3StarDirectRollback;
    rk_verifyFunRollback[SUBTYPE_4ZX] = rk_4StarDirectRollback;

}


//  风险控制验证接口
bool riskVerify(    TICKET* pTicket,bool commitFlag)
{
    int issueIndex = -1;

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
                if(!rk_verifyCommFun(line,issueIndex ))
                {
                    issueStatRefuseMoney(issueIndex) += pTicket->amount;
                    issueStatRefuseCount(issueIndex)++;
                    for(int rcount = 0; rcount < acount+1; rcount++)
                    {
                        issueIndex = rk_get_koctty_issueIndexBySeq( pTicket->issueSeq + rcount);
                        line = (BETLINE *)GL_BETLINE(pTicket);
                        int backline = (rcount == acount)? aline : pTicket->betlineCount;
                        for(int rline = 0;rline < backline; rline++)
                        {
                            rk_saleDataRelease(line,issueIndex);
                            rk_verifyFunRollback[line->subtype](line,issueIndex, commitFlag);
                            line = (BETLINE *) GL_BETLINE_NEXT(line);
                        }
                    }
                    log_info("koctty rk no pass issue[%lld] subtype[%d] commit[%d]",\
                            pTicket->issue,line->subtype,commitFlag?1:0);
                    send_rkNotify(pTicket->gameCode, pTicket->issue,rptSubtype, rptNumber);
                    return false;
                }
                rk_saleDataAdder(line,issueIndex,commitFlag);
                //rk_verifyFunAdder[line->subtype](line,issueIndex, commitFlag);
                line = (BETLINE *) GL_BETLINE_NEXT(line);
            }
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
                for(int aline = 0;aline < pTicket->betlineCount; aline++)
                {
                    rk_updateReportData(line,issueIndex);
                    rk_saleDataAdder(line,issueIndex, commitFlag);
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
            for(int i=0;i<pTicket->betlineCount;i++)
            {
                if(commitFlag)
                    rk_saleDataReleaseCommit(line,issueIndex);
                else
                    rk_saleDataRelease(line,issueIndex);
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
        }
        for(num = 0;num < 1000; num++)
        {
            ThreeStarBet(issue,num).betCount = ThreeStarBet(issue,num).betCountCommit;
        }
        for(num = 0;num < 10000; num++)
        {
            FourStarBet(issue,num).betCount = FourStarBet(issue,num).betCountCommit;
        }

        for(uint8 subtype = SUBTYPE_QH2; subtype <= SUBTYPE_4ZX; subtype++)
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
    }
    for(num = 0;num < 1000; num++)
    {
        ThreeStarBet(issue,num).betCount = 0;
        ThreeStarBet(issue,num).betCountCommit = 0;

    }
    for(num = 0;num < 10000; num++)
    {
        FourStarBet(issue,num).betCount = 0;
        FourStarBet(issue,num).betCountCommit = 0;

    }

    for(uint8 subtype = SUBTYPE_QH2; subtype <= SUBTYPE_4ZX; subtype++)
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
    int s[3] = {0};
    money_t f[3] = {0};
    money_t p[3] = {0};
    const char *format="%d:%lld:%lld#%d:%lld:%lld#%d:%lld:%lld#";

    sscanf(rkStr,format,&s[0],&f[0],&p[0],&s[1],&f[1],&p[1],&s[2],&f[2],&p[2]);

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

                for(uint8 subtype = SUBTYPE_QH2; subtype <= SUBTYPE_4ZX; subtype++)
                {
                    for(int sdx = 0; sdx < 4; sdx++)
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

                }
                for(num = 0;num < 1000; num++)
                {
                    rkIssueData.rkData[count].threeStarbetCountCommit[num] = ThreeStarBet(issue,num).betCountCommit;

                }
                for(num = 0;num < 10000; num++)
                {
                    rkIssueData.rkData[count].fourStarbetCountCommit[num] = FourStarBet(issue,num).betCountCommit;
                }

                for(uint8 subtype = SUBTYPE_QH2; subtype <= SUBTYPE_4ZX; subtype++)
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
                    }
                    for(num = 0;num < 1000; num++)
                    {
                        ThreeStarBet(issue,num).betCountCommit = rkIssueData.rkData[count].threeStarbetCountCommit[num];
                    }
                    for(num = 0;num < 10000; num++)
                    {
                        FourStarBet(issue,num).betCountCommit = rkIssueData.rkData[count].fourStarbetCountCommit[num];
                    }

                    for(uint8 subtype = SUBTYPE_QH2; subtype <= SUBTYPE_4ZX; subtype++)
                    {
                        saleMoneyCommit(subtype,issue) = rkIssueData.rkData[count].saleMoneyCommit[subtype];
                    }
                }
                count++;
            }
        }
        return true;
    }
    else
        return false;

    return true;
}


typedef struct _KOCTTY_REPORT_DATA
{
    money_t currPayQH2;
    money_t currPayQH3;
    money_t currPay4ZX;

}KOCTTY_REPORT_DATA;


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

    sprintf((char *)data,"1:%lld,%lld#2:%lld,%lld#3:%lld,%lld",
            currPayMoney(SUBTYPE_QH2,issue),maxPay(issue,SUBTYPE_QH2),
            currPayMoney(SUBTYPE_QH3,issue),maxPay(issue,SUBTYPE_QH3),
            currPayMoney(SUBTYPE_4ZX,issue),maxPay(issue,SUBTYPE_4ZX));
    return true;

}






