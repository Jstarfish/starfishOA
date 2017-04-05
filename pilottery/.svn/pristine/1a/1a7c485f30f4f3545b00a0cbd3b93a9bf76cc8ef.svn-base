#include "global.h"
#include "gl_inf.h"
#include "gl_kock3_rk.h"
#include "gl_kock3_db.h"


GAME_RISK_KOCK3_ISSUE_DATA *rk_kock3_issueData = NULL;
GAME_KOCK3_RK_INDEX *rk_kock3_bcTable = NULL;


ISSUE_INFO *kock3_issue_info = NULL;
int totalIssueCount = 0;


#define KOCK3_SEG_UNIT 2
#define WIN_RETURN_RATEBASE 1000


#define issueBeUsed(issue)                          kock3_issue_info[issue].used
#define issueState(issue)                           kock3_issue_info[issue].curState

#define issueStatRefuseMoney(issue)                 kock3_issue_info[issue].stat.issueRefuseAmount
#define issueStatRefuseCount(issue)                 kock3_issue_info[issue].stat.issueRefuseCount

#define winReturnRate(issue)                        rk_kock3_issueData[issue].returnRate

#define riskValue(issue)                            rk_kock3_issueData[issue].riskValue
#define maxPay(issue)                               rk_kock3_issueData[issue].maxPay

#define zxHzWinMoney(issue,sum)                     rk_kock3_issueData[issue].sub_zxhz_unitWin[abs(21 - 2 * sum)]
#define subWinMoney(issue,subtype)                  rk_kock3_issueData[issue].sub_unitWin[subtype]


#define ZxHzBet(issue,sum)                          rk_kock3_issueData[issue].bets_zx_hz[sum]
#define ThreeSameAllBet(issue)                      rk_kock3_issueData[issue].bets_3ta
#define ThreeSameSingleBet(issue,number)            rk_kock3_issueData[issue].bets_3ts[(number) % 10 - 1]
#define ThreeOrderAllBet(issue)                     rk_kock3_issueData[issue].bets_3qa
#define ThreeDiffSingleBet(issue,number)            rk_kock3_issueData[issue].bets_3ds[(number) / 100][((number) - (number) / 100 * 100) / 10][(number) % 10]
#define TwoSameAllBet(issue,number)                 rk_kock3_issueData[issue].bets_2ta[(number) % 10 - 1]
#define TwoSameSingleBet(issue,number)              rk_kock3_issueData[issue].bets_2ts[(number) / 100 - 1][(number) % 10 - 1]
#define TwoDiffSingleBet(issue,number)              rk_kock3_issueData[issue].bets_2ds[(number) / 10 - 1][(number) % 10 - 1]

#define saleMoney(issue)                            rk_kock3_issueData[issue].saleMoney
#define saleMoneyCommit(issue)                      rk_kock3_issueData[issue].saleMoneyCommit


#define maxWinMoney(issue)                          rk_kock3_issueData[issue].currMaxWin
#define currPayMoney(issue)                         rk_kock3_issueData[issue].currPay

#define IndexZxHz(sum)                              rk_kock3_bcTable->index_zx_hz[sum]
#define IndexThreeSameAll                           rk_kock3_bcTable->index_3t
#define IndexThreeSameSingle(number)                rk_kock3_bcTable->index_3t.eachBet[(number) % 10 - 1]
#define IndexThreeOrderAll                          rk_kock3_bcTable->index_3qa
#define IndexThreeDiffSingle(number)                rk_kock3_bcTable->index_3ds[(number) / 100][((number) - (number) / 100 * 100) / 10][(number) % 10]
#define IndexTwoSameAll(number)                     rk_kock3_bcTable->index_2ta[(number) % 10 - 1]
#define IndexTwoSameSingle(number)                  rk_kock3_bcTable->index_2ts[(number) / 100 - 1][(number) % 10 - 1]
#define IndexTwoDiffSingle(number)                  rk_kock3_bcTable->index_2ds[(number) / 10 - 1][(number) % 10 - 1]



static uint8 rptSubtype;
static char rptNumber[32]; //Notify betNumber String

/*
    GL_BETPART *betpart = GL_BETPART_A(line);
    return betpart->bitmap[0];

    GL_BETPART *betpart = GL_BETPART_A(line);
    return atoi((char *)(betpart->bitmap));
*/

void rk_verifyFunAdder(BETLINE *line,int issue,bool commitFlag)
{
	uint8 bitnum = 0;
	uint16 strnum = 0;
	GL_BETPART *betpart = GL_BETPART_A(line);
	if(betpart->mode == MODE_JS)
		bitnum = betpart->bitmap[0];
	else
		strnum = atoi((char *)(betpart->bitmap));

	switch(line->subtype)
	{
	case SUBTYPE_ZX:
	    if(commitFlag)
	    	ZxHzBet(issue,bitnum).betCountCommit +=  line->betTimes;
	    else
	    	ZxHzBet(issue,bitnum).betCount +=  line->betTimes;
		break;
	case SUBTYPE_3TA:
	    if(commitFlag)
	    	ThreeSameAllBet(issue).betCountCommit +=  line->betTimes;
	    else
	    	ThreeSameAllBet(issue).betCount +=  line->betTimes;
		break;
	case SUBTYPE_3TS:
	    if(commitFlag)
	    	ThreeSameSingleBet(issue,strnum).betCountCommit +=  line->betTimes;
	    else
	    	ThreeSameSingleBet(issue,strnum).betCount +=  line->betTimes;
		break;
	case SUBTYPE_3QA:
	    if(commitFlag)
	    	ThreeOrderAllBet(issue).betCountCommit +=  line->betTimes;
	    else
	    	ThreeOrderAllBet(issue).betCount +=  line->betTimes;
		break;
	case SUBTYPE_3DS:
	    if(commitFlag)
	    	ThreeDiffSingleBet(issue,strnum).betCountCommit +=  line->betTimes;
	    else
	    	ThreeDiffSingleBet(issue,strnum).betCount +=  line->betTimes;
		break;
	case SUBTYPE_2TA:
	    if(commitFlag)
	    	TwoSameAllBet(issue,bitnum).betCountCommit +=  line->betTimes;
	    else
	    	TwoSameAllBet(issue,bitnum).betCount +=  line->betTimes;
		break;
	case SUBTYPE_2TS:
	    if(commitFlag)
	    	TwoSameSingleBet(issue,strnum).betCountCommit +=  line->betTimes;
	    else
	    	TwoSameSingleBet(issue,strnum).betCount +=  line->betTimes;
		break;
	case SUBTYPE_2DS:
	    if(commitFlag)
	    	TwoDiffSingleBet(issue,bitnum).betCountCommit +=  line->betTimes;
	    else
	    	TwoDiffSingleBet(issue,bitnum).betCount +=  line->betTimes;
	}
}

void rk_verifyFunRollback(BETLINE *line,int issue,bool commitFlag)
{
	uint8 bitnum = 0;
	uint16 strnum = 0;
	GL_BETPART *betpart = GL_BETPART_A(line);
	if(betpart->mode == MODE_JS)
		bitnum = betpart->bitmap[0];
	else
		strnum = atoi((char *)(betpart->bitmap));

	switch(line->subtype)
	{
	case SUBTYPE_ZX:
	    if(commitFlag)
	    	ZxHzBet(issue,bitnum).betCountCommit -=  line->betTimes;
	    else
	    	ZxHzBet(issue,bitnum).betCount -=  line->betTimes;
		break;
	case SUBTYPE_3TA:
	    if(commitFlag)
	    	ThreeSameAllBet(issue).betCountCommit -=  line->betTimes;
	    else
	    	ThreeSameAllBet(issue).betCount -=  line->betTimes;
		break;
	case SUBTYPE_3TS:
	    if(commitFlag)
	    	ThreeSameSingleBet(issue,strnum).betCountCommit -=  line->betTimes;
	    else
	    	ThreeSameSingleBet(issue,strnum).betCount -=  line->betTimes;
		break;
	case SUBTYPE_3QA:
	    if(commitFlag)
	    	ThreeOrderAllBet(issue).betCountCommit -=  line->betTimes;
	    else
	    	ThreeOrderAllBet(issue).betCount -=  line->betTimes;
		break;
	case SUBTYPE_3DS:
	    if(commitFlag)
	    	ThreeDiffSingleBet(issue,strnum).betCountCommit -=  line->betTimes;
	    else
	    	ThreeDiffSingleBet(issue,strnum).betCount -=  line->betTimes;
		break;
	case SUBTYPE_2TA:
	    if(commitFlag)
	    	TwoSameAllBet(issue,bitnum).betCountCommit -=  line->betTimes;
	    else
	    	TwoSameAllBet(issue,bitnum).betCount -=  line->betTimes;
		break;
	case SUBTYPE_2TS:
	    if(commitFlag)
	    	TwoSameSingleBet(issue,strnum).betCountCommit -=  line->betTimes;
	    else
	    	TwoSameSingleBet(issue,strnum).betCount -=  line->betTimes;
		break;
	case SUBTYPE_2DS:
	    if(commitFlag)
	    	TwoDiffSingleBet(issue,bitnum).betCountCommit -=  line->betTimes;
	    else
	    	TwoDiffSingleBet(issue,bitnum).betCount -=  line->betTimes;
	}
}


int rk_get_kock3_issueIndexBySeq(uint32 issueSeq)
{
    ISSUE_INFO *allIssueInfo = gl_kock3_getIssueTable();
    if(allIssueInfo == NULL)
    {
        log_error("gl_kock3_getIssueTable return NULL");
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
    log_error("gl_kock3_getIssueTable seq[%d] return -1",issueSeq);
    return -1;
}

uint32 * numCurrentBetCount(uint8 subtype,uint32 issue,uint16 number)
{
    switch(subtype)
    {
        case SUBTYPE_ZX:
            return &(ZxHzBet(issue,number).betCount);
        case SUBTYPE_3TA:
            return &(ThreeSameAllBet(issue).betCount);
        case SUBTYPE_3TS:
            return &(ThreeSameSingleBet(issue,number).betCount);

        case SUBTYPE_3QA:
        	return &(ThreeOrderAllBet(issue).betCount);
        case SUBTYPE_3DS:
        	return &(ThreeDiffSingleBet(issue,number).betCount);
        case SUBTYPE_2TA:
        	return &(TwoSameAllBet(issue,number).betCount);
        case SUBTYPE_2TS:
        	return &(TwoSameSingleBet(issue,number).betCount);
        case SUBTYPE_2DS:
        	return &(TwoDiffSingleBet(issue,number).betCount);
        default:
            return NULL;
    }
}

uint32 * numCurrentBetCountCommit(uint8 subtype,uint32 issue,uint16 number)
{
    switch(subtype)
    {
        case SUBTYPE_ZX:
            return &(ZxHzBet(issue,number).betCountCommit);
        case SUBTYPE_3TA:
            return &(ThreeSameAllBet(issue).betCountCommit);
        case SUBTYPE_3TS:
            return &(ThreeSameSingleBet(issue,number).betCountCommit);

        case SUBTYPE_3QA:
        	return &(ThreeOrderAllBet(issue).betCountCommit);
        case SUBTYPE_3DS:
        	return &(ThreeDiffSingleBet(issue,number).betCountCommit);
        case SUBTYPE_2TA:
        	return &(TwoSameAllBet(issue,number).betCountCommit);
        case SUBTYPE_2TS:
        	return &(TwoSameSingleBet(issue,number).betCountCommit);
        case SUBTYPE_2DS:
        	return &(TwoDiffSingleBet(issue,number).betCountCommit);
        default:
            return NULL;
    }
}



bool rk_getNumRestrictFlag(BETLINE *line)
{
    ts_notused(line);
    return false;
}


money_t  getMatchMaxWin(uint8 subtype,uint16 betNumber,int issue,uint16 betTimes)
{
    money_t maxMoney = 0;
    money_t betsWin = 0;

    uint32 tmpBets = 0;

    switch(subtype)
    {
    case SUBTYPE_ZX:
    {
    	for(int idx = 0; idx < IndexZxHz(betNumber).numCount; idx++)
    	{
    		if(IndexZxHz(betNumber).eachBet[idx].sub3t)
    		{
    			betsWin += subWinMoney(issue,SUBTYPE_3TA) * (ThreeSameAllBet(issue).betCount + betTimes);
    			betsWin += subWinMoney(issue,SUBTYPE_3TS) * (ThreeSameSingleBet(issue,IndexZxHz(betNumber).eachBet[idx].zx_num ).betCount + betTimes);
    		}

    		if(IndexZxHz(betNumber).eachBet[idx].sub3ds)
    			betsWin += subWinMoney(issue,SUBTYPE_3DS) * (ThreeDiffSingleBet(issue,IndexZxHz(betNumber).eachBet[idx].zx_num).betCount + betTimes);

    		if(IndexZxHz(betNumber).eachBet[idx].sub3q)
    			betsWin += subWinMoney(issue,SUBTYPE_3QA) * (ThreeOrderAllBet(issue).betCount + betTimes);

    		if(IndexZxHz(betNumber).eachBet[idx].sub2ta)
    			betsWin += subWinMoney(issue,SUBTYPE_2TA) * (TwoSameAllBet(issue,IndexZxHz(betNumber).eachBet[idx].sub2ta_index).betCount + betTimes);

    		if(IndexZxHz(betNumber).eachBet[idx].sub2ts)
    			betsWin += subWinMoney(issue,SUBTYPE_2TS) * (TwoSameSingleBet(issue,IndexZxHz(betNumber).eachBet[idx].sub2ts_index).betCount + betTimes);

    		if(IndexZxHz(betNumber).eachBet[idx].sub2ds)
    		{
    			for(int jdx = 0; jdx < 7; jdx++)
    			{
   					tmpBets = ( IndexZxHz(betNumber).eachBet[idx].sub2ds_index[jdx] > tmpBets ) ? IndexZxHz(betNumber).eachBet[idx].sub2ds_index[jdx] : tmpBets;
    			}
    			betsWin += subWinMoney(issue,SUBTYPE_2DS) * (TwoDiffSingleBet(issue,tmpBets).betCount + betTimes);
    		}

    		maxMoney = (maxMoney > betsWin)? maxMoney : betsWin;
    		betsWin = 0;
    	}

        break;
    }
    case SUBTYPE_3TA:
    {
        for(int n = 0; n < 6; n++)
        {
        	betsWin += zxHzWinMoney(issue,(IndexThreeSameAll.eachBet[n].subhz)) * (ZxHzBet(issue,(IndexThreeSameAll.eachBet[n].subhz)).betCount + betTimes);
        	betsWin += subWinMoney(issue,SUBTYPE_3TS) * (ThreeSameSingleBet(issue,IndexThreeSameAll.eachBet[n].zx_num).betCount  + betTimes);
        	betsWin += subWinMoney(issue,SUBTYPE_2TA) * (TwoSameAllBet(issue,IndexThreeSameAll.eachBet[n].sub2t).betCount  + betTimes);
    		maxMoney = (maxMoney > betsWin)? maxMoney : betsWin;
    		betsWin = 0;
        }
        break;
    }
    case SUBTYPE_3TS:

    	betsWin += zxHzWinMoney(issue,(IndexThreeSameSingle(betNumber).subhz)) * (ZxHzBet(issue,(IndexThreeSameSingle(betNumber).subhz)).betCount + betTimes);
    	betsWin += subWinMoney(issue,SUBTYPE_3TA) * (ThreeSameAllBet(issue).betCount  + betTimes);
    	betsWin += subWinMoney(issue,SUBTYPE_2TA) * (TwoSameAllBet(issue,IndexThreeSameSingle(betNumber).sub2t).betCount  + betTimes);
		maxMoney = betsWin;
		break;

    case SUBTYPE_3QA:
        for(int n = 0; n < 4; n++)
        {
        	betsWin += zxHzWinMoney(issue,(IndexThreeOrderAll.eachBet[n].subhz)) * (ZxHzBet(issue,(IndexThreeOrderAll.eachBet[n].subhz)).betCount + betTimes);
        	betsWin += subWinMoney(issue,SUBTYPE_3DS) * (ThreeDiffSingleBet(issue,IndexThreeOrderAll.eachBet[n].zx_num).betCount  + betTimes);
			for(int jdx = 0; jdx < 3; jdx++)
			{
					tmpBets = ( IndexThreeOrderAll.eachBet[n].sub2ds_index[jdx] > tmpBets ) ? IndexThreeOrderAll.eachBet[n].sub2ds_index[jdx] : tmpBets;
			}
			betsWin += subWinMoney(issue,SUBTYPE_2DS) * (TwoDiffSingleBet(issue,tmpBets).betCount + betTimes);
    		maxMoney = (maxMoney > betsWin)? maxMoney : betsWin;
    		betsWin = 0;
        }
    	break;
    case SUBTYPE_3DS:
    	betsWin += zxHzWinMoney(issue,(IndexThreeDiffSingle(betNumber).subhz)) * (ZxHzBet(issue,(IndexThreeSameSingle(betNumber).subhz)).betCount + betTimes);
    	if(IndexThreeDiffSingle(betNumber).sub3qa)
    	    betsWin += subWinMoney(issue,SUBTYPE_3QA) * (ThreeOrderAllBet(issue).betCount  + betTimes);
		for(int jdx = 0; jdx < 3; jdx++)
		{
				tmpBets = ( IndexThreeDiffSingle(betNumber).sub2ds_index[jdx] > tmpBets ) ? IndexThreeDiffSingle(betNumber).sub2ds_index[jdx] : tmpBets;
		}
		betsWin += subWinMoney(issue,SUBTYPE_2DS) * (TwoDiffSingleBet(issue,tmpBets).betCount + betTimes);
		maxMoney = betsWin;
    	break;
    case SUBTYPE_2TA:
        for(int n = 0; n < 6; n++)
        {
        	betsWin += zxHzWinMoney(issue,(IndexTwoSameAll(betNumber).eachBet[n].subhz)) * (ZxHzBet(issue,(IndexTwoSameAll(betNumber).eachBet[n].subhz)).betCount + betTimes);

            if(IndexTwoSameAll(betNumber).eachBet[n].sub3t > 0)
            {
            	betsWin += subWinMoney(issue,SUBTYPE_3TA) * (ThreeSameAllBet(issue).betCount  + betTimes);
        	    betsWin += subWinMoney(issue,SUBTYPE_3TS) * (ThreeSameSingleBet(issue,IndexTwoSameAll(betNumber).eachBet[n].sub3t).betCount  + betTimes);
            }
            else
            {
            	betsWin += subWinMoney(issue,SUBTYPE_2DS) * (TwoDiffSingleBet(issue,IndexTwoSameAll(betNumber).eachBet[n].sub2ds).betCount  + betTimes);
            }
    		maxMoney = (maxMoney > betsWin)? maxMoney : betsWin;
    		betsWin = 0;
        }

    	break;
    case SUBTYPE_2TS:
    	betsWin += zxHzWinMoney(issue,(IndexTwoSameSingle(betNumber).subhz)) * (ZxHzBet(issue,(IndexTwoSameSingle(betNumber).subhz)).betCount + betTimes);
		betsWin += subWinMoney(issue, SUBTYPE_2TA) * (TwoSameAllBet(issue, IndexTwoSameSingle(betNumber).sub2t).betCount + betTimes);
    	betsWin += subWinMoney(issue,SUBTYPE_2DS) * (TwoDiffSingleBet(issue,IndexTwoSameSingle(betNumber).sub2ds).betCount  + betTimes);
		maxMoney = betsWin;
		break;

    case SUBTYPE_2DS:
        for(int n = 0; n < 6; n++)
        {
        	betsWin += zxHzWinMoney(issue,(IndexTwoDiffSingle(betNumber).eachBet[n].subhz)) * (ZxHzBet(issue,(IndexTwoDiffSingle(betNumber).eachBet[n].subhz)).betCount + betTimes);
        	if(IndexTwoDiffSingle(betNumber).eachBet[n].sub3qa)
        		betsWin += subWinMoney(issue,SUBTYPE_3QA) * (ThreeOrderAllBet(issue).betCount  + betTimes);
        	if(IndexTwoDiffSingle(betNumber).eachBet[n].sub2t > 0)
        	{
        		betsWin += subWinMoney(issue,SUBTYPE_2TA) * (TwoSameAllBet(issue,IndexTwoDiffSingle(betNumber).eachBet[n].sub2t).betCount  + betTimes);
        		betsWin += subWinMoney(issue,SUBTYPE_2TS) * (TwoSameSingleBet(issue,IndexTwoDiffSingle(betNumber).eachBet[n].zx_num).betCount + betTimes);

        	}
    		maxMoney = (maxMoney > betsWin)? maxMoney : betsWin;
    		betsWin = 0;
        }
    }

    return maxMoney;
}


money_t  getMatchMaxWinCommit(uint8 subtype,uint16 betNumber,int issue,uint16 betCounts)
{
	ts_notused(subtype);
	ts_notused(betNumber);
	ts_notused(issue);
	ts_notused(betCounts);

    return 0;
}

bool rk_verifyCommFun(BETLINE *line,int issue)
{
    money_t lineMoney = line->betCount * line->betTimes * line->singleAmount;
    if(saleMoney(issue) + lineMoney  <= riskValue(issue))
    {
        rk_verifyFunAdder(line,issue, false);
        return true;
    }

	uint16 betnum = 0;

	GL_BETPART *betpart = GL_BETPART_A(line);
	if(betpart->mode == MODE_JS)
		betnum = betpart->bitmap[0];
	else
		betnum = atoi((char *)(betpart->bitmap));

    money_t myWinMoney = (line->subtype == SUBTYPE_ZX) ? zxHzWinMoney(issue,betnum) :subWinMoney(issue,line->subtype);

    money_t matchMaxWin = getMatchMaxWin(line->subtype,betnum,issue,line->betTimes);

    money_t totalWinMoney = (line->betTimes + *(numCurrentBetCount(line->subtype,issue,betnum))) * myWinMoney + matchMaxWin;

    money_t currPayMoney = totalWinMoney  - (saleMoney(issue) + lineMoney) * winReturnRate(issue) / WIN_RETURN_RATEBASE;

    if(currPayMoney > maxPay(issue))
    {
        rptSubtype = line->subtype;
        memset(rptNumber,0,sizeof(rptNumber));
        sprintf(rptNumber,"%d",betnum);

        log_info("rk_verifyCommFun no pass line->subtype[%d] verify  \
                      line->betCount[%d] line->betTimes[%d] num[%d] currentBetCount[%d]  \
                      myWinMoney[%lld] matchMaxWin[%lld] totalWinMoney[%lld]  saleMoney[%lld] currPayMoney[%lld] maxPay[%lld] ",\
                      line->subtype,line->betCount,line->betTimes,betnum,*numCurrentBetCount(line->subtype,issue,betnum),
                      myWinMoney, matchMaxWin,totalWinMoney,saleMoney(issue), currPayMoney, maxPay(issue) );


        *(numCurrentBetCount(line->subtype,issue,betnum)) -= line->betTimes;
        return false;
    }
    else
    {
        *(numCurrentBetCount(line->subtype,issue,betnum)) += line->betTimes;
    }

    return true;
}


void rk_updateReportData(BETLINE *line,int issue)
{
	ts_notused(line);
	ts_notused(issue);
    return;
}


void rk_saleDataAdder(BETLINE *line,int issue,bool commitFlag)
{
    if(commitFlag)
    {
        saleMoneyCommit(issue) += line->betCount * line->betTimes * line->singleAmount;
    }
    else
    {
        saleMoney(issue) += line->betCount * line->betTimes * line->singleAmount;
    }
}

void rk_saleDataRelease(BETLINE *line,int issue)
{
    saleMoney(issue) -= line->betCount * line->betTimes * line->singleAmount;
}


void rk_saleDataReleaseCommit(BETLINE *line,int issue)
{
    saleMoneyCommit(issue) -= line->betCount * line->betTimes * line->singleAmount;
}



/////////////////////////////////////////////////////////////////////////////////


//  风险控制验证接口
bool riskVerify(    TICKET* pTicket,bool commitFlag)
{
    int issueIndex = -1;

    if(!commitFlag)
    {
        for(int acount = 0; acount < pTicket->issueCount; acount++)
        {
            issueIndex = rk_get_kock3_issueIndexBySeq( pTicket->issueSeq + acount);
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
                        issueIndex = rk_get_kock3_issueIndexBySeq( pTicket->issueSeq + rcount);
                        line = (BETLINE *)GL_BETLINE(pTicket);
                        int backline = (rcount == acount)? aline : pTicket->betlineCount;
                        for(int rline = 0;rline < backline; rline++)
                        {
                            rk_saleDataRelease(line,issueIndex);
                            rk_verifyFunRollback(line,issueIndex, commitFlag);
                            line = (BETLINE *) GL_BETLINE_NEXT(line);
                        }
                    }
                    log_info("kock3 rk no pass issue[%lld] subtype[%d] commit[%d]",\
                            pTicket->issue,line->subtype,commitFlag?1:0);
                    send_rkNotify(pTicket->gameCode, pTicket->issue,rptSubtype, rptNumber);
                    return false;
                }
                rk_saleDataAdder(line,issueIndex,commitFlag);
                line = (BETLINE *) GL_BETLINE_NEXT(line);
            }
        }
    }
    else
    {
        for(int acount = 0; acount < pTicket->issueCount; acount++)
        {
            issueIndex = rk_get_kock3_issueIndexBySeq( pTicket->issueSeq + acount);
            if(issueIndex >= 0 )
            {
                BETLINE *line =  (BETLINE *)GL_BETLINE(pTicket);
                for(int aline = 0;aline < pTicket->betlineCount; aline++)
                {
                    rk_updateReportData(line,issueIndex);
                    rk_saleDataAdder(line,issueIndex, commitFlag);
                    rk_verifyFunAdder(line,issueIndex, commitFlag);
                    line = (BETLINE *) GL_BETLINE_NEXT(line);
                }
            }
        }
    }

    log_info("kock3 rk pass issue[%lld] commit[%d]",pTicket->issue,commitFlag?1:0);
    return true;
}


// 退票风险控制参数回滚接口
void riskRollback(TICKET* pTicket,bool commitFlag)
{
    int issueIndex = -1;

    for(int acount = 0; acount < pTicket->issueCount; acount++)
    {
        issueIndex = rk_get_kock3_issueIndexBySeq( pTicket->issueSeq + acount);
        if(issueIndex >= 0 )
        {
            BETLINE *line = (BETLINE *)GL_BETLINE(pTicket);
            for(int i=0;i<pTicket->betlineCount;i++)
            {
                if(commitFlag)
                    rk_saleDataReleaseCommit(line,issueIndex);
                else
                    rk_saleDataRelease(line,issueIndex);
                rk_verifyFunRollback(line,issueIndex, commitFlag);
                line = (BETLINE *) GL_BETLINE_NEXT(line);
            }
        }
    }
}

bool gl_kock3_rk_mem_get_meta( int *length)
{
    ts_notused(length);
    return true;
}

bool gl_kock3_rk_mem_save( void *buf, int *length)
{
    ts_notused(buf);
    ts_notused(length);
    return true;
}

bool gl_kock3_rk_mem_recovery( void *buf, int length)
{
    ts_notused(buf);
    ts_notused(length);
    return true;
}

void gl_kock3_rk_reinitData(void)
{
    int num;
    uint16 const bet3t[] = {111,222,333,444,555,666};
    uint8 const bet2t[] = {11,22,33,44,55,66};

    for(int issue=0;issue < totalIssueCount;issue++)
    {
        for(num = 3;num < 19; num++)
        {
        	ZxHzBet(issue,num).betCount = ZxHzBet(issue,num).betCountCommit;
        }

        ThreeSameAllBet(issue).betCount = ThreeSameAllBet(issue).betCountCommit;
        for(num = 0; num < 6; num++)
        {
        	ThreeSameSingleBet(issue,bet3t[num]).betCount = ThreeSameSingleBet(issue,bet3t[num]).betCountCommit;
        }
        ThreeOrderAllBet(issue).betCount = ThreeOrderAllBet(issue).betCountCommit;

    	for (uint8 a = 1; a < 7; a++)
    	{
    		for (uint8 b = 1; b < 7; b++)
    		{
    			for (uint8 c = 1; c < 7; c++)
    			{
    				if((a < b) && (b < c))
    					ThreeDiffSingleBet(issue,a * 100 + b * 10 + c).betCount = ThreeDiffSingleBet(issue,a * 100 + b * 10 + c).betCountCommit;
    			}
    		}
    	}

        for(num = 1; num < 7; num++)
        {
        	TwoSameAllBet(issue,num * 10 + num).betCount = TwoSameAllBet(issue,num * 10 + num).betCountCommit;
        	for(int n = 1; n < 7; n++)
        	{
        	    if((bet2t[num] % 10) != n)
        	    	TwoSameSingleBet(issue,bet2t[num] * 10 + n).betCount = TwoSameSingleBet(issue,bet2t[num] * 10 + n).betCountCommit;
        	}
        }

        for(int idx = 12; idx <= 56; idx++)
        {
        	uint8 a = idx / 10;
        	uint8 b = idx % 10;
        	if((a < 7) && (b < 7) && (a < b))
        	{
        		for(int jdx = 0; jdx < 7; jdx++)
        		{
        			TwoDiffSingleBet(issue,idx).betCount = TwoDiffSingleBet(issue,idx).betCountCommit;
        		}
        	}
        }

    	saleMoney(issue) = saleMoneyCommit(issue);
    }
    return;
}

bool gl_kock3_sale_rk_verify(TICKET* pTicket)
{
    if( riskVerify(pTicket, false))
    {
        return true;
    }
    return false;
}


void gl_kock3_sale_rk_commit(TICKET* pTicket)
{
     riskVerify(pTicket, true);
}


void gl_kock3_cancel_rk_rollback(TICKET* pTicket)
{
    riskRollback(pTicket, false);
}

void gl_kock3_cancel_rk_commit(TICKET* pTicket)
{
    riskRollback(pTicket, true);
}


////////////////////////////////////////////////////////////////



void setKOCK3winMoney(uint64 issueNumber,int issue)
{
    PRIZE_PARAM *prizeParam = gl_kock3_getPrizeTable(issueNumber);
	DIVISION_PARAM * divisionTable = (DIVISION_PARAM *)gl_kock3_getDivisionTable(NULL,0);

	for (int i = 0; i < MAX_PRIZE_COUNT; i++)
	{
		if (prizeParam[i].used)
		{
		    for (int j = 0; j < MAX_DIVISION_COUNT; j++)
		    {
			    if ((divisionTable[j].used) && (prizeParam[i].prizeCode == divisionTable[j].prizeCode))
			    {
				    if (divisionTable[j].subtypeCode == SUBTYPE_ZX)
				    {
					    for (int sum = 3; sum < 19; sum++)
					    {
						    if (abs(21 - 2 * sum) == divisionTable[j].absDiff)
							    zxHzWinMoney(issue, sum) = prizeParam[i].fixedPrizeAmount;
					    }
				    }
				    else
					    subWinMoney(issue, divisionTable[j].subtypeCode) = prizeParam[i].fixedPrizeAmount;
			    }
		    }
	    }
    }
    return;
}


void rk_clear_issue_betsData(int issue)
{
    int num;
    uint16 const bet3t[] = {111,222,333,444,555,666};
    uint8 const bet2t[] = {11,22,33,44,55,66};


    for(num = 3;num < 19; num++)
    {
     	ZxHzBet(issue,num).betCount = 0;
      	ZxHzBet(issue,num).betCountCommit = 0;
    }

    ThreeSameAllBet(issue).betCount = 0;
    ThreeSameAllBet(issue).betCountCommit = 0;
    for(num = 0; num < 6; num++)
    {
     	ThreeSameSingleBet(issue,bet3t[num]).betCount = 0;
      	ThreeSameSingleBet(issue,bet3t[num]).betCountCommit = 0;
    }
    ThreeOrderAllBet(issue).betCount = 0;
    ThreeOrderAllBet(issue).betCountCommit = 0;

  	for (uint8 a = 1; a < 7; a++)
   	{
   		for (uint8 b = 1; b < 7; b++)
   		{
   			for (uint8 c = 1; c < 7; c++)
   			{
   				if((a < b) && (b < c))
   				{
   					ThreeDiffSingleBet(issue,a * 100 + b * 10 + c).betCount = 0;
   				    ThreeDiffSingleBet(issue,a * 100 + b * 10 + c).betCountCommit = 0;
   				}
   			}
   		}
   	}

    for(num = 1; num < 7; num++)
    {
      	TwoSameAllBet(issue,num * 10 + num).betCount = 0;
       	TwoSameAllBet(issue,num * 10 + num).betCountCommit = 0;
       	for(int n = 1; n < 7; n++)
       	{
       	    if((bet2t[num] % 10) != n)
       	    {
       	    	TwoSameSingleBet(issue,bet2t[num] * 10 + n).betCount = 0;
       	    	TwoSameSingleBet(issue,bet2t[num] * 10 + n).betCountCommit = 0;
       	    }
       	}
    }

    for(int idx = 12; idx <= 56; idx++)
    {
       	uint8 a = idx / 10;
       	uint8 b = idx % 10;
       	if((a < 7) && (b < 7) && (a < b))
       	{
       		for(int jdx = 0; jdx < 7; jdx++)
       		{
       			TwoDiffSingleBet(issue,idx).betCount = 0;
       			TwoDiffSingleBet(issue,idx).betCountCommit = 0;
       		}
       	}
    }

  	saleMoney(issue) = 0;
   	saleMoneyCommit(issue) = 0;
}


// load issue param when add issue by gl_drive , no need init ,need empty bets data
bool load_kock3_issue_rkdata(uint32 startIssueSeq,int issue_count, char *rkStr)
{
    money_t f = 0;
    money_t p = 0;
    const char *format="%lld:%lld";

    sscanf(rkStr,format,&f,&p);

    POLICY_PARAM* policyParam = gl_getPolicyParam(GAME_KOCK3);

    uint32 issueSeq = startIssueSeq;
    for(int issue_idx = 0; issue_idx < issue_count; issue_idx++)
    {
        int issue = rk_get_kock3_issueIndexBySeq(issueSeq);
        if (issue > -1)
        {
            if( issueBeUsed(issue) )
            {
                ISSUE_INFO *issueInfo = gl_kock3_get_issueInfoByIndex(issue);

                winReturnRate(issue) = policyParam->returnRate;
                setKOCK3winMoney( issueInfo->issueNumber,issue);


                riskValue(issue) = f;
                maxPay(issue) = p;

                rk_clear_issue_betsData( issue);
            }
            issueSeq++;
        }
    }
    return true;
}

void gl_kock3_rk_issueData2File(const char *filePath,void *buf)
{
    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName,"%s/kock3_rk.snapshot", filePath);
    if((fp = open(fileName,O_CREAT|O_WRONLY,S_IRUSR )) < 0 )
    {
        log_error("open %s error!",fileName);
        return;
    }

    ssize_t ret = write( fp, buf, sizeof(GL_KOCK3_RK_CHKP_ISSUE_DATA));
    if(ret < 0)
    {
        log_error("write %s error errno[%d]",fileName,errno);
    }
    close(fp);

}

bool gl_kock3_rk_issueFile2Data(const char *filePath,void *buf)
{
    int fp;
    char fileName[MAX_PATH_LENGTH] = {0};
    sprintf(fileName,"%s/kock3_rk.snapshot", filePath);
    if((fp = open(fileName,O_RDONLY )) < 0 )
    {
        log_error("open %s error!",fileName);
        return false;
    }

    ssize_t ret = read( fp, buf, sizeof(GL_KOCK3_RK_CHKP_ISSUE_DATA));
    if(ret < 0)
    {
        log_error("read %s error errno[%d]",fileName,errno);
        return false;
    }
    close(fp);
    return true;
}

bool gl_kock3_rk_saveData(const char *filePath)
{
    int count = 0;
    GL_KOCK3_RK_CHKP_ISSUE_DATA rkIssueData;
    memset((void *)&rkIssueData, 0 ,sizeof(rkIssueData));
    ISSUE_INFO *issueInfo = gl_kock3_getIssueTable();
    for(int i = 0; i < totalIssueCount; i++)
    {
        if(issueInfo[i].used)
        {
            if((issueInfo[i].curState >= ISSUE_STATE_PRESALE) && (issueInfo[i].curState < ISSUE_STATE_CLOSED))
            {
                int issue = rk_get_kock3_issueIndexBySeq(issueInfo[i].serialNumber);


                rkIssueData.rkData[count].issueSeq = issueInfo[i].serialNumber;


                rkIssueData.rkData[count].saleMoneyCommit = saleMoneyCommit(issue);

                count++;
            }
        }
    }
    gl_kock3_rk_issueData2File(filePath,(void *)&rkIssueData);
    return true;
}

bool gl_kock3_rk_restoreData(const char *filePath)
{
    int num;
    uint16 const bet3t[] = {111,222,333,444,555,666};
    uint8 const bet2t[] = {11,22,33,44,55,66};

    GL_KOCK3_RK_CHKP_ISSUE_DATA rkIssueData;
    memset((void *)&rkIssueData, 0 ,sizeof(rkIssueData));
    if(gl_kock3_rk_issueFile2Data(filePath,(void *)&rkIssueData))
    {
        for(int count = 0; count < MAX_ISSUE_NUMBER; count++)
        {
            if(rkIssueData.rkData[count].issueSeq > 0)
            {
                int issue = rk_get_kock3_issueIndexBySeq(rkIssueData.rkData[count].issueSeq);

                if(issue >= 0)
                {

                    for(num = 3;num < 19; num++)
                    {
                    	ZxHzBet(issue,num).betCountCommit = rkIssueData.rkData[count].bets_zx_hz[num].betCountCommit;
                    }

                    ThreeSameAllBet(issue).betCountCommit = rkIssueData.rkData[count].bets_3ta.betCountCommit;
                    for(num = 0; num < 6; num++)
                    {
                    	ThreeSameSingleBet(issue,bet3t[num]).betCountCommit = rkIssueData.rkData[count].bets_3ts[num].betCountCommit;
                    }
                    ThreeOrderAllBet(issue).betCountCommit = rkIssueData.rkData[count].bets_3qa.betCountCommit;

                	for (uint8 a = 1; a < 7; a++)
                	{
                		for (uint8 b = 1; b < 7; b++)
                		{
                			for (uint8 c = 1; c < 7; c++)
                			{
                				if((a < b) && (b < c))
                					ThreeDiffSingleBet(issue,a * 100 + b * 10 + c).betCountCommit = rkIssueData.rkData[count].bets_3ds[a][b][c].betCountCommit;
                			}
                		}
                	}

                    for(num = 1; num < 7; num++)
                    {
                    	TwoSameAllBet(issue,num * 10 + num).betCountCommit = rkIssueData.rkData[count].bets_2ta[num].betCountCommit;
                    	for(int n = 1; n < 7; n++)
                    	{
                    	    if((bet2t[num] % 10) != n)
                    	    	TwoSameSingleBet(issue,bet2t[num] * 10 + n).betCountCommit = rkIssueData.rkData[count].bets_2ts[bet2t[num] % 10][n].betCountCommit;
                    	}
                    }

                    for(int idx = 12; idx <= 56; idx++)
                    {
                    	uint8 a = idx / 10;
                    	uint8 b = idx % 10;
                    	if((a < 7) && (b < 7) && (a < b))
                    	{
                    		for(int jdx = 0; jdx < 7; jdx++)
                    		{
                    			TwoDiffSingleBet(issue,idx).betCountCommit = rkIssueData.rkData[count].bets_2ds[a][b].betCountCommit;
                    		}
                    	}
                    }

                    maxWinMoney(issue) = rkIssueData.rkData[count].currMaxWin;
                    currPayMoney(issue) = rkIssueData.rkData[count].currPay;
                    saleMoneyCommit(issue) = rkIssueData.rkData[count].saleMoneyCommit;

                }
            }
        }
        return true;
    }
    else
        return false;

    return true;
}



bool gl_kock3_rk_getReportData(uint32 issueSeq,void *data)
{
    int issue = rk_get_kock3_issueIndexBySeq( issueSeq);
    if(issue < 0)
    {
        log_info("gl_kock3_rk_getReportData issue_seq[%d]  not find!",issueSeq);
        return false;
    }
    sprintf((char *)data,"1:%lld,%lld",currPayMoney(issue),maxPay(issue));
    return true;

}



bool gl_kock3_rk_init(void)
{
	uint8 const bet2t[] = {11,22,33,44,55,66};

	int bet3t = 0;
	int bet3q = 0;

    if(rk_kock3_bcTable != NULL)
    {
    	for (uint8 a = 1; a < 7; a++)
    	{
    		for (uint8 b = 1; b < 7; b++)
    		{
    			for (uint8 c = 1; c < 7; c++)
    			{
                    if ((a <= b) && (b <= c))
    				{
                    	uint8 sum = a + b + c;
                    	uint16 bet = a * 100 + b * 10 + c;
                    	uint8 count = IndexZxHz(sum).numCount;
                    	IndexZxHz(sum).eachBet[count].zx_num = bet;


                    	if((a == b) && (b == c))
                    	{
                    		IndexZxHz(sum).eachBet[count].sub3t = true;

                    		IndexThreeSameAll.eachBet[bet3t].zx_num = bet;
                    		IndexThreeSameAll.eachBet[bet3t].subhz = sum;
                    		IndexThreeSameAll.eachBet[bet3t].sub2t = a * 10 + a;
                    		bet3t++;
                    	}

                    	if((a < b) && (b < c))
                    	{
                    		IndexZxHz(sum).eachBet[count].sub3ds = true;

                    		IndexThreeDiffSingle(bet).zx_num = bet;
                    		IndexThreeDiffSingle(bet).subhz = sum;
                    		IndexThreeDiffSingle(bet).sub2ds_index[0] = a * 10 + b;
                    		IndexThreeDiffSingle(bet).sub2ds_index[1] = a * 10 + c;
                    		IndexThreeDiffSingle(bet).sub2ds_index[2] = b * 10 + c;

                    		if(((b - a) == 1) && ((c - b) == 1))
                    		{
                    			IndexThreeDiffSingle(bet).sub3qa = true;
                    			IndexThreeOrderAll.eachBet[bet3q].zx_num = bet;
                    			IndexThreeOrderAll.eachBet[bet3q].subhz = sum;
                    			IndexThreeOrderAll.eachBet[bet3q].sub2ds_index[0] = a * 10 + b;
                    			IndexThreeOrderAll.eachBet[bet3q].sub2ds_index[1] = a * 10 + c;
                    			IndexThreeOrderAll.eachBet[bet3q].sub2ds_index[2] = b * 10 + c;
                    			bet3q++;
                    		}
                    	}

                    	if((a == b) && (a != c))
                    	{
                    		IndexZxHz(sum).eachBet[count].sub2ts_index = bet;
                    		IndexZxHz(sum).eachBet[count].sub2ts = true;

                    		IndexZxHz(sum).eachBet[count].sub2ds_index[IndexZxHz(sum).eachBet[count].sub2ds] = a * 10 + c;
                    		IndexZxHz(sum).eachBet[count].sub2ds++;
                    	}

                    	if((a != b) && (b == c))
                    	{
                    		IndexZxHz(sum).eachBet[count].sub2ts_index = b * 100 + b * 10 + a;
                    		IndexZxHz(sum).eachBet[count].sub2ts = true;

                    		IndexZxHz(sum).eachBet[count].sub2ds_index[IndexZxHz(sum).eachBet[count].sub2ds] = a * 10 + b;
                    		IndexZxHz(sum).eachBet[count].sub2ds++;
                    	}


                    	IndexZxHz(sum).numCount++;
    				}
    			}
    		}
    	}

        for(int idx = 0; idx < 6; idx++)
        {
        	uint8 bets = bet2t[idx];
        	uint8 jdx = bet2t[idx] % 10 - 1;

        	for(int n = 1; n < 7; n++)
        	{
        		IndexTwoSameAll(jdx).eachBet[n - 1].zx_num = bets * 10 + n;
        	    IndexTwoSameAll(bets).eachBet[n - 1].subhz = (bets / 10) + (bets % 10) + n;
        	    if( (bets % 10) == n )
        	        IndexTwoSameAll(bets).eachBet[n - 1].sub3t = n * 100 + n * 10 + n;

        	    else
        	    {
        	        IndexTwoSameAll(bets).eachBet[n - 1].sub2ds = ( (bets % 10) > n )? (n * 10 + (bets % 10)) : ((bets % 10) * 10 + n);
        	        IndexTwoSameSingle(bets * 10 + n).subhz = (bets / 10) * 2 + n;
					IndexTwoSameSingle(bets * 10 + n).sub2t = bets;
        	        IndexTwoSameSingle(bets * 10 + n).sub2ds = (bets % 10) + n;
        	    }
        	}
        }

        for(int idx = 12; idx <= 56; idx++)
        {
        	uint8 a = idx / 10;
        	uint8 b = idx % 10;
        	if((a < 7) && (b < 7) && (a < b))
        	{
        		for(int jdx = 0; jdx < 7; jdx++)
        		{
        		    IndexTwoDiffSingle(idx).eachBet[jdx].zx_num = idx * 10 + jdx;
        		    IndexTwoDiffSingle(idx).eachBet[jdx].subhz = a + b + jdx;
        		    IndexTwoDiffSingle(idx).eachBet[jdx].sub3qa = ( ((b - a) == 1) && ((jdx - b) == 1) )? true: false;
        		    if (a == jdx)
        		        IndexTwoDiffSingle(idx).eachBet[jdx].sub2t = a * 10 + a;
        		    if (b == jdx)
        		    	IndexTwoDiffSingle(idx).eachBet[jdx].sub2t = b * 10 + b;
        		}
        	}
        }
    }

    return true;
}







